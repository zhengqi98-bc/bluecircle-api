"""Admin dashboard schemas."""

from pydantic import BaseModel, field_validator
from typing import Optional, Any
from datetime import datetime


class UserAdminOut(BaseModel):
    """User info for admin panel."""
    id: str
    email: str
    institution: Optional[str] = None
    role: str
    is_active: bool
    is_approved: bool
    created_at: Optional[str] = None

    model_config = {"from_attributes": True}

    @field_validator("id", mode="before")
    @classmethod
    def coerce_id(cls, v: Any) -> str:
        return str(v)

    @field_validator("created_at", mode="before")
    @classmethod
    def coerce_created_at(cls, v: Any) -> Optional[str]:
        if v is None:
            return None
        if isinstance(v, datetime):
            return v.isoformat()
        return str(v)


class TrialReview(BaseModel):
    """Admin review of a trial application."""
    status: str  # "approved" | "rejected"
    reviewer_notes: Optional[str] = None


class DashboardStats(BaseModel):
    """Aggregate statistics for admin dashboard."""
    total_turtles: int
    active_turtles: int
    total_users: int
    total_datasets: int
    total_alerts: int
    open_alerts: int
    pending_trials: int
    total_track_points: int
