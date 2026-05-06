"""TrackPoint Pydantic schemas."""

from pydantic import BaseModel, field_validator
from typing import Optional, Any
from datetime import datetime


class TrackPointOut(BaseModel):
    """A single GPS track point."""
    time: str  # ISO format string
    turtle_id: str
    lat: float
    lng: float
    battery_pct: Optional[float] = None
    speed_kmh: Optional[float] = None
    depth_m: Optional[float] = None
    temperature_c: Optional[float] = None
    source: str = "satellite"

    model_config = {"from_attributes": True}

    @field_validator("time", mode="before")
    @classmethod
    def coerce_time(cls, v: Any) -> str:
        if isinstance(v, datetime):
            return v.isoformat()
        return str(v)


class TrackListOut(BaseModel):
    """Paginated track point list."""
    turtle_id: str
    items: list[TrackPointOut]
    total: int
    page: int
