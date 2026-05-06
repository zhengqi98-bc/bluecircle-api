"""Pydantic schemas for User authentication."""

from pydantic import BaseModel, field_validator
from typing import Optional, Any
from datetime import datetime


class UserRegister(BaseModel):
    """User registration request."""
    email: str
    password: str
    institution: Optional[str] = None


class UserLogin(BaseModel):
    """Login request."""
    email: str
    password: str


class TokenResponse(BaseModel):
    """JWT token pair response."""
    access_token: str
    refresh_token: str
    token_type: str = "bearer"


class RefreshRequest(BaseModel):
    """Token refresh request."""
    refresh_token: str


class UserOut(BaseModel):
    """Public user profile."""
    id: str
    email: str
    institution: Optional[str] = None
    role: str
    is_active: bool
    is_approved: bool
    created_at: Optional[datetime] = None

    model_config = {"from_attributes": True}

    @field_validator("id", mode="before")
    @classmethod
    def coerce_id_to_str(cls, v: Any) -> str:
        """Convert UUID (or any non-string) to str during validation."""
        return str(v)
