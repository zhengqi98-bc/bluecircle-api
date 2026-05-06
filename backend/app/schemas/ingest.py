"""Ingest Pydantic schemas with validators."""

from pydantic import BaseModel, field_validator, model_validator
from typing import Optional
from datetime import datetime, timezone


class IngestPayload(BaseModel):
    """Single data point from a tracking device."""
    turtle_id: str
    timestamp: Optional[str] = None  # ISO 8601; defaults to now
    lat: float
    lng: float
    battery_pct: Optional[float] = None
    speed_kmh: Optional[float] = None
    depth_m: Optional[float] = None
    temperature_c: Optional[float] = None
    source: str = "device"

    @field_validator("turtle_id")
    @classmethod
    def check_turtle_id(cls, v: str) -> str:
        v = v.strip()
        if not v:
            raise ValueError("turtle_id must not be empty")
        if len(v) > 20:
            raise ValueError("turtle_id too long (max 20 chars)")
        return v

    @field_validator("lat")
    @classmethod
    def validate_lat(cls, v: float) -> float:
        if v < -90 or v > 90:
            raise ValueError(f"Latitude out of range: {v}")
        return round(v, 6)

    @field_validator("lng")
    @classmethod
    def validate_lng(cls, v: float) -> float:
        if v < -180 or v > 180:
            raise ValueError(f"Longitude out of range: {v}")
        return round(v, 6)

    @field_validator("battery_pct")
    @classmethod
    def validate_battery(cls, v: Optional[float]) -> Optional[float]:
        if v is not None and (v < 0 or v > 100):
            raise ValueError(f"Battery out of range: {v}")
        return v

    @field_validator("speed_kmh")
    @classmethod
    def validate_speed(cls, v: Optional[float]) -> Optional[float]:
        if v is not None and v < 0:
            raise ValueError(f"Speed must be non-negative: {v}")
        return v

    @field_validator("depth_m")
    @classmethod
    def validate_depth(cls, v: Optional[float]) -> Optional[float]:
        if v is not None and v < 0:
            raise ValueError(f"Depth must be positive (sea level=0): {v}")
        return v

    @field_validator("temperature_c")
    @classmethod
    def validate_temp(cls, v: Optional[float]) -> Optional[float]:
        if v is not None and (v < -5 or v > 45):
            raise ValueError(f"Temperature out of range: {v}")
        return v

    @field_validator("timestamp")
    @classmethod
    def validate_timestamp(cls, v: Optional[str]) -> Optional[str]:
        if v is None:
            return None
        try:
            dt = datetime.fromisoformat(v.replace("Z", "+00:00"))
            now = datetime.now(timezone.utc)
            # Not more than 5 minutes in the future
            if dt > now.replace(tzinfo=dt.tzinfo if dt.tzinfo else timezone.utc):
                delta = (dt.replace(tzinfo=timezone.utc) - now).total_seconds()
                if delta > 300:
                    raise ValueError("Timestamp too far in the future")
            # Not more than 30 days old
            if (now - dt.replace(tzinfo=timezone.utc)).days > 30:
                raise ValueError("Timestamp too old (>30 days)")
        except ValueError as e:
            if "Timestamp" in str(e):
                raise
            raise ValueError(f"Invalid timestamp format: {v}")
        return v


class IngestBatch(BaseModel):
    """Batch of data points."""
    points: list[IngestPayload]

    @field_validator("points")
    @classmethod
    def check_batch_size(cls, v: list) -> list:
        if len(v) > 100:
            raise ValueError("Batch too large (max 100 points)")
        return v


class IngestResponse(BaseModel):
    """Response from ingest endpoint."""
    accepted: int
    rejected: int
    duplicates: int
    errors: list[str] = []
