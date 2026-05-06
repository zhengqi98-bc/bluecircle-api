"""Alert Pydantic schemas."""

from pydantic import BaseModel, field_validator
from typing import Optional, Any
from datetime import datetime


class AlertCreate(BaseModel):
    """Create a new alert."""
    turtle_id: Optional[str] = None
    alert_type: str  # e.g. "fishing", "collision", "temperature", "battery"
    severity: str  # "critical", "high", "medium", "low"
    title: str
    description: Optional[str] = None
    lat: Optional[float] = None
    lng: Optional[float] = None
    metadata: Optional[dict] = None


class AlertUpdate(BaseModel):
    """Update alert (e.g. resolve it)."""
    status: Optional[str] = None  # "open", "acknowledged", "resolved"
    description: Optional[str] = None


class AlertOut(BaseModel):
    """Alert response."""
    id: int
    turtle_id: Optional[str] = None
    alert_type: str
    severity: str
    title: str
    description: Optional[str] = None
    lat: Optional[float] = None
    lng: Optional[float] = None
    status: str
    created_at: Optional[str] = None
    resolved_at: Optional[str] = None

    model_config = {"from_attributes": True}

    @field_validator("created_at", "resolved_at", mode="before")
    @classmethod
    def coerce_datetime(cls, v: Any) -> Optional[str]:
        if v is None:
            return None
        if isinstance(v, datetime):
            return v.isoformat()
        return str(v)


class AlertListOut(BaseModel):
    """Paginated alert list."""
    items: list[AlertOut]
    total: int
