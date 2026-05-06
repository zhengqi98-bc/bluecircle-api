"""Pydantic schemas for Turtle API."""

from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class TurtleBase(BaseModel):
    id: str
    name: str
    name_en: Optional[str] = None
    species: str
    species_en: Optional[str] = None
    sex: Optional[str] = None
    age_class: Optional[str] = None
    origin: Optional[str] = None
    origin_en: Optional[str] = None
    carapace_length_cm: Optional[float] = None
    photo_url: Optional[str] = None
    device_id: Optional[str] = None
    is_active: bool = True
    risk_level: Optional[str] = None


class TurtleOut(TurtleBase):
    """Turtle response — includes live sensor data."""
    lat: Optional[float] = None
    lng: Optional[float] = None
    battery_pct: Optional[float] = None
    speed_kmh: Optional[float] = None
    depth_m: Optional[float] = None
    last_seen_at: Optional[datetime] = None
    created_at: Optional[datetime] = None

    model_config = {"from_attributes": True}


class TurtleListOut(BaseModel):
    """Paginated turtle list."""
    items: list[TurtleOut]
    total: int
