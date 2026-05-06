"""Report Pydantic schemas."""

from pydantic import BaseModel, field_validator
from typing import Optional, Any
from datetime import datetime


class ReportCreate(BaseModel):
    """Request to generate a new report."""
    title: str
    report_type: str  # turtle_activity | fleet_overview | monthly_summary | alert_summary
    turtle_id: Optional[str] = None
    params: Optional[dict] = None  # e.g. {"date_from": "2026-01-01", "date_to": "2026-05-01"}


class ReportOut(BaseModel):
    """Report response."""
    id: str
    title: str
    report_type: str
    turtle_id: Optional[str] = None
    params: Optional[dict] = None
    status: str
    html_content: str = ""
    file_path: Optional[str] = None
    created_by: Optional[str] = None
    created_at: Optional[str] = None
    completed_at: Optional[str] = None

    model_config = {"from_attributes": True}

    @field_validator("id", "created_by", mode="before")
    @classmethod
    def coerce_uuid(cls, v: Any) -> Optional[str]:
        if v is None:
            return None
        return str(v)

    @field_validator("created_at", "completed_at", mode="before")
    @classmethod
    def coerce_datetime(cls, v: Any) -> Optional[str]:
        if v is None:
            return None
        if isinstance(v, datetime):
            return v.isoformat()
        return str(v)


class ReportListOut(BaseModel):
    """Paginated report list."""
    items: list[ReportOut]
    total: int


class ReportDownload(BaseModel):
    """Download response — raw HTML."""
    title: str
    report_type: str
    html_content: str
    generated_at: Optional[str] = None
