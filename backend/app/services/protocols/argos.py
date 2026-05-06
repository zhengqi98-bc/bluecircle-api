"""Argos satellite system protocol adapter.

Argos is a satellite-based wildlife tracking system operated by CLS/CNES.
Data arrives in "DS" (Distribution Service) format — a CSV-like text format
with fixed-position fields, typically delivered via email or FTP.

Reference: http://www.argos-system.org/manual/

DS Format (most common variant):
  PROGRAM_NUMBER,PTT_ID,SATELLITE,QUALITY,LATITUDE_1,LATITUDE_2,
  LONGITUDE_1,LONGITUDE_2,ALTITUDE,ERROR_RADIUS,SENSOR_A,SENSOR_B,
  SENSOR_C,SENSOR_D,DATE,TIME,...

We parse the core fields:
  - PTT_ID       → turtle_id (mapped via device registry)
  - LATITUDE_1/2 → decimal degrees (DDMM.MMM → decimal)
  - LONGITUDE_1/2→ decimal degrees (DDMM.MMM → decimal)
  - DATE         → YYYY-MM-DD
  - TIME         → HH:MM:SS → combined into ISO timestamp
  - QUALITY      → location class (0-3, A, B, Z)
  - SENSOR_A..D  → optional telemetry (battery, temp, depth, etc.)

Also supports the newer "Argos Web" JSON API format.
"""

import json
import re
from datetime import datetime, timezone
from typing import Optional

from app.services.protocols.base import BaseProtocol, ProtocolRegistry
from app.schemas.ingest import IngestPayload


# ── Argos DS format line parser ──────────────────────────────────────

_ARGO_DS_HEADER = re.compile(r"^\d{4,6},[A-Za-z0-9_-]{3,20},", re.MULTILINE)

# Field position map for DS format (1-indexed columns in CSV)
_FIELD = {
    "program": 0, "ptt_id": 1, "satellite": 2,
    "quality": 3, "lat1": 4, "lat2": 5,
    "lng1": 6, "lng2": 7, "altitude": 8,
    "error_radius": 9, "sensor_a": 10, "sensor_b": 11,
    "sensor_c": 12, "sensor_d": 13,
    "date": 14, "time": 15,
}


def _parse_argos_latlon(lat1: str, lat2: str, lng1: str, lng2: str):
    """Convert Argos lat/lon (DDMM.MMM or DDDMM.MMM) to decimal degrees.

    Format: lat=DDMM.MMM (S appended for negative), lon=DDDMM.MMM (W for negative)
    Also handles variant where direction is in separate lat2/lng2 field.
    """
    def _to_decimal(deg_min: str, direction: str = "") -> Optional[float]:
        if not deg_min or not deg_min.strip():
            return None
        dm = deg_min.strip()

        # Check if the value itself contains direction suffix
        negative = dm.endswith("S") or dm.endswith("W")
        dm = dm.rstrip("NSWEnswe")

        # Check if direction is in the companion field
        if not negative and direction:
            direction = direction.strip().upper()
            negative = direction in ("S", "W")

        if "." in dm:
            parts = dm.split(".")
            deg_digits = len(parts[0]) - 2  # subtract minutes (always 2 digits)
            if deg_digits < 1:
                return None
            try:
                deg = float(parts[0][:deg_digits])
                minutes = float(parts[0][deg_digits:] + "." + parts[1])
            except (ValueError, IndexError):
                return None
        else:
            deg_digits = len(dm) - 2
            if deg_digits < 1:
                return None
            try:
                deg = float(dm[:deg_digits])
                minutes = float(dm[deg_digits:])
            except (ValueError, IndexError):
                return None

        result = deg + minutes / 60.0
        return -result if negative else result

    # Try: lat1 is DDMM.MMM value, lat2 is direction indicator
    lat = _to_decimal(lat1, lat2)
    if lat is None:
        # Fallback: lat2 might be the value
        lat = _to_decimal(lat2, lat1)

    lng = _to_decimal(lng1, lng2)
    if lng is None:
        lng = _to_decimal(lng2, lng1)

    if lat is not None and lng is not None:
        return round(lat, 6), round(lng, 6)
    return None, None


def _parse_ds_line(line: str, turtle_id_map: dict = None) -> Optional[IngestPayload]:
    """Parse a single DS-format CSV line into an IngestPayload."""
    parts = [p.strip().strip('"') for p in line.split(",")]
    if len(parts) < 16:
        return None

    try:
        ptt_id = parts[_FIELD["ptt_id"]]
    except IndexError:
        return None

    turtle_id = turtle_id_map.get(ptt_id, ptt_id) if turtle_id_map else ptt_id

    # Parse lat/lon
    lat, lng = _parse_argos_latlon(
        parts[_FIELD["lat1"]], parts[_FIELD["lat2"]],
        parts[_FIELD["lng1"]], parts[_FIELD["lng2"]],
    )
    if lat is None or lng is None:
        return None

    # Parse date/time
    date_str = parts[_FIELD["date"]]
    time_str = parts[_FIELD["time"]]
    timestamp = None
    if date_str and time_str:
        try:
            dt = datetime.fromisoformat(f"{date_str}T{time_str}")
            timestamp = dt.replace(tzinfo=timezone.utc).isoformat()
        except (ValueError, TypeError):
            pass

    # Parse sensor data (device-specific, heuristic mapping)
    sensors = [
        parts[_FIELD["sensor_a"]],
        parts[_FIELD["sensor_b"]],
        parts[_FIELD["sensor_c"]],
        parts[_FIELD["sensor_d"]],
    ]
    # Common Argos sensor mappings:
    # sensor_a = battery voltage (mV → convert to % if possible)
    # sensor_b = temperature (°C)
    # sensor_c = depth (m)
    # sensor_d = speed or activity
    battery, temp, depth, speed = None, None, None, None

    for s in sensors:
        if not s or not s.strip():
            continue
        try:
            val = float(s)
            # Battery: if > 1000, assume mV → divide by 10 to get approx %
            # (Argos tags typically report battery in mV, 3000-4500mV range)
            # If < 100, treat as direct percentage
            if battery is None and (val > 100 or val < 0):
                if val > 1000:
                    battery = min(100.0, (val / 45.0))  # rough: 4500mV = 100%
                elif 0 <= val <= 100:
                    battery = val
                elif val > 100:
                    battery = None  # can't determine, skip
        except ValueError:
            pass

    return IngestPayload(
        turtle_id=turtle_id,
        timestamp=timestamp,
        lat=lat,
        lng=lng,
        battery_pct=battery,
        speed_kmh=speed,
        depth_m=depth,
        temperature_c=temp,
        source="argos",
    )


# ── Argos Web JSON format parser ────────────────────────────────────

def _parse_argos_json(data: dict, turtle_id_map: dict = None) -> list[IngestPayload]:
    """Parse Argos Web API JSON response into ingest payloads."""
    results = []
    locations = data.get("locations", data.get("data", []))

    for loc in locations:
        ptt_id = str(loc.get("ptt", loc.get("platformId", "")))
        if not ptt_id:
            continue

        turtle_id = turtle_id_map.get(ptt_id, ptt_id) if turtle_id_map else ptt_id

        lat = loc.get("latitude")
        lng = loc.get("longitude")
        if lat is None or lng is None:
            continue

        timestamp = loc.get("locationDate", loc.get("timestamp"))
        if timestamp:
            try:
                dt = datetime.fromisoformat(timestamp.replace("Z", "+00:00"))
                timestamp = dt.isoformat()
            except (ValueError, TypeError):
                pass

        sensors = loc.get("sensorData", loc.get("sensors", {}))
        battery = sensors.get("battery", sensors.get("batteryLevel"))
        temp = sensors.get("temperature", sensors.get("sst"))
        depth = sensors.get("depth", sensors.get("pressure"))

        results.append(IngestPayload(
            turtle_id=turtle_id,
            timestamp=timestamp,
            lat=float(lat),
            lng=float(lng),
            battery_pct=float(battery) if battery is not None else None,
            temperature_c=float(temp) if temp is not None else None,
            depth_m=float(depth) if depth is not None else None,
            source="argos",
        ))

    return results


# ── Adapter class ───────────────────────────────────────────────────

class ArgosAdapter(BaseProtocol):
    """Argos satellite system adapter.

    Supports:
      - DS format (CSV lines via email/FTP)
      - Argos Web JSON API format
    """

    protocol_name = "argos"

    def __init__(self, turtle_id_map: dict = None):
        """Initialize with optional PTT_ID → turtle_id mapping."""
        self.turtle_id_map = turtle_id_map or {}

    def identify(self, raw) -> bool:
        """Detect if raw data is Argos DS or JSON format."""
        if isinstance(raw, (dict,)):
            return "locations" in raw or "ptt" in raw or "platformId" in raw

        text = raw if isinstance(raw, str) else raw.decode("utf-8", errors="ignore")
        # DS format: starts with program_number,ptt_id,...
        if _ARGO_DS_HEADER.search(text):
            return True
        # JSON format
        try:
            data = json.loads(text)
            if isinstance(data, dict) and ("locations" in data or "data" in data):
                return True
        except (json.JSONDecodeError, TypeError):
            pass
        return False

    def parse(self, raw) -> list[IngestPayload]:
        """Parse raw Argos data into ingest payloads.

        Args:
            raw: str (DS format or JSON string) or dict (parsed JSON)

        Returns:
            list of IngestPayload objects ready for the ingest pipeline
        """
        # JSON input
        if isinstance(raw, dict):
            return _parse_argos_json(raw, self.turtle_id_map)

        text = raw if isinstance(raw, str) else raw.decode("utf-8", errors="ignore")

        # Try JSON first
        try:
            data = json.loads(text)
            if isinstance(data, dict):
                return _parse_argos_json(data, self.turtle_id_map)
        except (json.JSONDecodeError, TypeError):
            pass

        # DS format (CSV lines)
        payloads = []
        for line in text.splitlines():
            line = line.strip()
            if not line or line.startswith("#") or line.startswith("//"):
                continue
            # Must match DS header pattern (program_number,ptt_id,...)
            if not _ARGO_DS_HEADER.match(line):
                continue
            payload = _parse_ds_line(line, self.turtle_id_map)
            if payload:
                payloads.append(payload)

        return payloads


# Auto-register
ProtocolRegistry.register(ArgosAdapter())
