"""Notification schemas."""

from pydantic import BaseModel, field_validator
from typing import Optional
from datetime import datetime


class NotificationRuleCreate(BaseModel):
    """Create a notification rule."""
    name: str
    description: Optional[str] = None
    alert_types: Optional[list[str]] = None
    severity_min: str = "medium"
    turtle_id: Optional[str] = None
    email_enabled: bool = False
    email_recipients: Optional[list[str]] = None
    webhook_enabled: bool = False
    webhook_url: Optional[str] = None
    webhook_secret: Optional[str] = None
    sms_enabled: bool = False
    sms_recipients: Optional[list[str]] = None
    is_active: bool = True

    @field_validator("severity_min")
    @classmethod
    def check_severity(cls, v: str) -> str:
        valid = {"low", "medium", "high", "critical"}
        if v not in valid:
            raise ValueError(f"severity must be one of: {valid}")
        return v


class NotificationRuleUpdate(BaseModel):
    """Update a notification rule (partial)."""
    name: Optional[str] = None
    description: Optional[str] = None
    alert_types: Optional[list[str]] = None
    severity_min: Optional[str] = None
    turtle_id: Optional[str] = None
    email_enabled: Optional[bool] = None
    email_recipients: Optional[list[str]] = None
    webhook_enabled: Optional[bool] = None
    webhook_url: Optional[str] = None
    webhook_secret: Optional[str] = None
    sms_enabled: Optional[bool] = None
    sms_recipients: Optional[list[str]] = None
    is_active: Optional[bool] = None


class NotificationRuleOut(BaseModel):
    """Notification rule response."""
    id: int
    name: str
    description: Optional[str] = None
    alert_types: Optional[list] = None
    severity_min: str
    turtle_id: Optional[str] = None
    email_enabled: bool
    email_recipients: Optional[list] = None
    webhook_enabled: bool
    webhook_url: Optional[str] = None
    sms_enabled: bool
    sms_recipients: Optional[list] = None
    is_active: bool
    created_at: Optional[datetime] = None

    model_config = {"from_attributes": True}


class NotificationRuleListOut(BaseModel):
    """List of notification rules."""
    items: list[NotificationRuleOut]
    total: int


class NotificationLogOut(BaseModel):
    """Notification log entry."""
    id: int
    rule_id: Optional[int] = None
    alert_id: Optional[int] = None
    channel: str
    status: str
    recipient: str
    subject: Optional[str] = None
    error_message: Optional[str] = None
    sent_at: Optional[datetime] = None

    model_config = {"from_attributes": True}


class NotificationLogListOut(BaseModel):
    """List of notification logs."""
    items: list[NotificationLogOut]
    total: int


class TestNotificationRequest(BaseModel):
    """Test a notification rule by sending a test message."""
    rule_id: int
    channel: str  # email / webhook / sms
