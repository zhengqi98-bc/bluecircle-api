"""SPOT GPS messenger protocol adapter.

SPOT devices (SPOT Gen3, SPOT Trace, SPOT X) send GPS fixes via:
  1. HTTP POST to a user-configured webhook URL (XML or JSON)
  2. SPOT API (poll-based, requires API key)

Message formats supported:
  - SPOT XML webhook payload (most common)
  - SPOT JSON API response

Reference: https://faq.findmespot.com/ (SPOT webhook docs)
"""

import json
import xml.etree.ElementTree as ET
from datetime import datetime, timezone
from typing import Optional

from app.services.protocols.base import BaseProtocol, ProtocolRegistry
from app.schemas.ingest import IngestPayload


# ── SPOT XML parser ─────────────────────────────────────────────────

def _parse_spot_xml(xml_text: str, turtle_id_map: dict = None) -> list[IngestPayload]:
    """Parse SPOT XML webhook payload.

    Typical SPOT XML:
    <message>
      <esn>0-1234567</esn>
      <unix_time>1615234567</unix_time>
      <message_type>UNLIMITED-TRACK</message_type>
      <latitude>37.12345</latitude>
      <longitude>-122.54321</longitude>
      <altitude>15</altitude>
      <battery_state>GOOD</battery_state>
      ...
    </message>
    """
    root = ET.fromstring(xml_text)
    payloads = []

    # Handle both single <message> and <feedMessageResponse> wrappers
    messages = root.findall(".//message")
    if not messages:
        messages = [root] if root.tag == "message" else []

    for msg in messages:
        esn = _get_text(msg, "esn", "")
        if not esn:
            esn = _get_text(msg, "messengerId", "")

        turtle_id = turtle_id_map.get(esn, esn) if turtle_id_map else esn
        if not turtle_id:
            continue

        lat = _get_float(msg, "latitude")
        lng = _get_float(msg, "longitude")
        if lat is None or lng is None:
            continue

        # Timestamp: unix_time or dateTime
        ts = _get_int(msg, "unix_time")
        timestamp = None
        if ts and ts > 0:
            dt = datetime.fromtimestamp(ts, tz=timezone.utc)
            timestamp = dt.isoformat()
        else:
            dt_str = _get_text(msg, "dateTime", "")
            if dt_str:
                try:
                    dt = datetime.fromisoformat(dt_str.replace("Z", "+00:00"))
                    timestamp = dt.isoformat()
                except (ValueError, TypeError):
                    pass

        # Battery: "GOOD" → 80%, "LOW" → 20%, numeric → direct
        bat_str = _get_text(msg, "battery_state", "").upper()
        battery = None
        if bat_str == "GOOD":
            battery = 80.0
        elif bat_str == "LOW":
            battery = 20.0
        elif bat_str:
            try:
                battery = float(bat_str)
            except ValueError:
                pass

        # Altitude (optional, SPOT provides it in meters)
        alt = _get_float(msg, "altitude")

        payloads.append(IngestPayload(
            turtle_id=turtle_id,
            timestamp=timestamp,
            lat=lat,
            lng=lng,
            battery_pct=battery,
            source="spot",
        ))

    return payloads


# ── SPOT JSON parser ────────────────────────────────────────────────

def _parse_spot_json(data: dict, turtle_id_map: dict = None) -> list[IngestPayload]:
    """Parse SPOT JSON response (API or webhook).

    SPOT API JSON structure:
    {
      "response": {
        "feedMessageResponse": {
          "messages": {
            "message": [
              {
                "esn": "0-1234567",
                "unixTime": 1615234567,
                "latitude": 37.1234,
                "longitude": -122.5432,
                "batteryState": "GOOD",
                ...
              }
            ]
          }
        }
      }
    }

    SPOT webhook JSON (newer devices):
    {
      "esn": "0-1234567",
      "latitude": 37.1234,
      "longitude": -122.5432,
      "unixTime": 1615234567,
      "batteryState": "GOOD"
    }
    """
    payloads = []

    # Try nested API response structure
    messages = []
    try:
        messages = data["response"]["feedMessageResponse"]["messages"]["message"]
        if isinstance(messages, dict):
            messages = [messages]
    except (KeyError, TypeError):
        pass

    # Try flat webhook structure
    if not messages and "esn" in data:
        messages = [data]

    # Try "messages" array at top level
    if not messages and "messages" in data:
        messages = data["messages"]
        if isinstance(messages, dict):
            messages = [messages]

    for msg in messages:
        esn = str(msg.get("esn", msg.get("messengerId", "")))
        turtle_id = turtle_id_map.get(esn, esn) if turtle_id_map else esn
        if not turtle_id:
            continue

        lat = msg.get("latitude")
        lng = msg.get("longitude")
        if lat is None or lng is None:
            continue

        # Timestamp
        ts_val = msg.get("unixTime") or msg.get("unix_time")
        timestamp = None
        if ts_val:
            try:
                dt = datetime.fromtimestamp(int(ts_val), tz=timezone.utc)
                timestamp = dt.isoformat()
            except (ValueError, TypeError, OSError):
                pass

        # Battery
        bat = msg.get("batteryState", msg.get("battery_state", "")).upper()
        battery = None
        if bat == "GOOD":
            battery = 80.0
        elif bat == "LOW":
            battery = 20.0
        elif bat:
            try:
                battery = float(bat)
            except ValueError:
                pass

        payloads.append(IngestPayload(
            turtle_id=turtle_id,
            timestamp=timestamp,
            lat=float(lat),
            lng=float(lng),
            battery_pct=battery,
            source="spot",
        ))

    return payloads


# ── Helper functions ────────────────────────────────────────────────

def _get_text(el, tag: str, default: str = "") -> str:
    child = el.find(tag)
    return child.text.strip() if child is not None and child.text else default


def _get_float(el, tag: str) -> Optional[float]:
    child = el.find(tag)
    if child is not None and child.text:
        try:
            return float(child.text.strip())
        except (ValueError, TypeError):
            pass
    return None


def _get_int(el, tag: str) -> Optional[int]:
    child = el.find(tag)
    if child is not None and child.text:
        try:
            return int(child.text.strip())
        except (ValueError, TypeError):
            pass
    return None


# ── Adapter class ───────────────────────────────────────────────────

class SpotAdapter(BaseProtocol):
    """SPOT GPS messenger adapter.

    Supports:
      - SPOT XML webhook payload
      - SPOT JSON API / webhook format
    """

    protocol_name = "spot"

    def __init__(self, turtle_id_map: dict = None):
        self.turtle_id_map = turtle_id_map or {}

    def identify(self, raw) -> bool:
        """Detect if raw data is SPOT format."""
        # JSON
        if isinstance(raw, dict):
            jkeys = raw.keys()
            return bool({"esn", "latitude", "longitude"} & jkeys) or \
                   "feedMessageResponse" in str(jkeys)

        text = raw if isinstance(raw, str) else raw.decode("utf-8", errors="ignore")
        text_stripped = text.strip()

        # XML
        if text_stripped.startswith("<"):
            root_tag = text_stripped[1:].split()[0].split(">")[0].split("/")[0]
            return root_tag in ("message", "feedMessageResponse", "messages")

        # JSON
        try:
            data = json.loads(text_stripped)
            return self.identify(data)
        except (json.JSONDecodeError, TypeError):
            pass

        return False

    def parse(self, raw) -> list[IngestPayload]:
        """Parse SPOT device data into ingest payloads."""
        # Dict (already parsed JSON)
        if isinstance(raw, dict):
            return _parse_spot_json(raw, self.turtle_id_map)

        text = raw if isinstance(raw, str) else raw.decode("utf-8", errors="ignore")
        text = text.strip()

        # XML
        if text.startswith("<"):
            return _parse_spot_xml(text, self.turtle_id_map)

        # JSON
        try:
            data = json.loads(text)
            return _parse_spot_json(data, self.turtle_id_map)
        except (json.JSONDecodeError, TypeError):
            pass

        # Unknown
        return []


# Auto-register
ProtocolRegistry.register(SpotAdapter())
