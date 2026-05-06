"""Pydantic schemas for API Key management."""

from pydantic import BaseModel, field_validator
from typing import Optional, Any
from datetime import datetime


class ApiKeyCreate(BaseModel):
    """Request to create a new API key."""
    name: Optional[str] = None
    rate_limit: int = 100


class ApiKeyOut(BaseModel):
    """API key info (without the secret)."""
    id: str
    name: Optional[str] = None
    key_prefix: str  # first 8 chars of the raw key (for identification)
    rate_limit: int
    is_active: bool
    last_used_at: Optional[datetime] = None
    created_at: datetime

    model_config = {"from_attributes": True}

    @field_validator("id", mode="before")
    @classmethod
    def coerce_id_to_str(cls, v: Any) -> str:
        return str(v)


class ApiKeyCreated(BaseModel):
    """Response when creating a new key — includes the raw secret ONCE."""
    api_key: ApiKeyOut
    raw_key: str  # only shown once upon creation
