"""Hardware Application Pydantic schemas."""

from pydantic import BaseModel, field_validator
from typing import Optional, Any
from datetime import datetime


class HardwareCreate(BaseModel):
    """Submit a new hardware application."""
    applicant_name: str
    email: str
    institution: str
    phone: Optional[str] = None
    project_title: str
    project_description: str = ""
    target_species: str
    target_count: int = 1
    region: str = ""
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    device_type: str = "gps_tag"
    quantity: int = 1
    start_date: Optional[str] = None
    end_date: Optional[str] = None


class HardwareUpdate(BaseModel):
    """Update an application (before review — owner only)."""
    project_title: Optional[str] = None
    project_description: Optional[str] = None
    target_species: Optional[str] = None
    target_count: Optional[int] = None
    region: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    device_type: Optional[str] = None
    quantity: Optional[int] = None
    start_date: Optional[str] = None
    end_date: Optional[str] = None


class HardwareOut(BaseModel):
    """Application response."""
    id: int
    applicant_name: str
    email: str
    institution: str
    phone: Optional[str] = None
    project_title: str
    project_description: str
    target_species: str
    target_count: int
    region: str
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    device_type: str
    quantity: int
    start_date: Optional[str] = None
    end_date: Optional[str] = None
    status: str
    reviewer_notes: Optional[str] = None
    tracking_number: Optional[str] = None
    shipped_at: Optional[str] = None
    expected_return: Optional[str] = None
    created_at: Optional[str] = None
    updated_at: Optional[str] = None

    model_config = {"from_attributes": True}

    @field_validator("shipped_at", "created_at", "updated_at", mode="before")
    @classmethod
    def coerce_datetime(cls, v: Any) -> Optional[str]:
        if v is None:
            return None
        if isinstance(v, datetime):
            return v.isoformat()
        return str(v)


class HardwareListOut(BaseModel):
    """Paginated application list."""
    items: list[HardwareOut]
    total: int


class HardwareReview(BaseModel):
    """Admin review action."""
    status: str  # approved | rejected
    reviewer_notes: Optional[str] = None


class HardwareShip(BaseModel):
    """Admin ship action."""
    tracking_number: str
    expected_return: Optional[str] = None
