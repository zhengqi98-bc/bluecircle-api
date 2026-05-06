"""Notification rule model — triggers and channels for alerts."""

import uuid
from datetime import datetime
from sqlalchemy import String, DateTime, Text, Boolean, ForeignKey, func
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base
from typing import Optional


class NotificationRule(Base):
    """A notification rule defines WHEN and HOW to notify.

    Trigger conditions: alert_type, severity_min, turtle_id (optional)
    Channels: email, webhook, sms (bitmask or separate flags)
    """

    __tablename__ = "notification_rules"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    description: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

    # ── Trigger conditions ──
    alert_types: Mapped[Optional[list]] = mapped_column(
        JSONB, nullable=True, comment="Alert types to match (null=all)"
    )
    # e.g., ["low_battery", "offline", "boundary", "sst_high"]

    severity_min: Mapped[str] = mapped_column(
        String(10), nullable=False, default="medium",
        comment="Minimum severity: low/medium/high/critical"
    )

    turtle_id: Mapped[Optional[str]] = mapped_column(
        String(20), ForeignKey("turtles.id", ondelete="SET NULL"), index=True, nullable=True
    )

    # ── Channel flags ──
    email_enabled: Mapped[bool] = mapped_column(Boolean, default=False)
    email_recipients: Mapped[Optional[list]] = mapped_column(
        JSONB, nullable=True, comment="List of email addresses"
    )

    webhook_enabled: Mapped[bool] = mapped_column(Boolean, default=False)
    webhook_url: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    webhook_secret: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)

    sms_enabled: Mapped[bool] = mapped_column(Boolean, default=False)
    sms_recipients: Mapped[Optional[list]] = mapped_column(
        JSONB, nullable=True, comment="List of phone numbers"
    )

    # ── Status ──
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_by: Mapped[Optional[uuid.UUID]] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="SET NULL"), index=True, nullable=True
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    # ── Relationships ──
    turtle = relationship("Turtle", back_populates="notification_rules")
    user = relationship("User", back_populates="notification_rules")


class NotificationLog(Base):
    """Log of sent notifications for audit trail."""

    __tablename__ = "notification_logs"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    rule_id: Mapped[Optional[int]] = mapped_column(
        ForeignKey("notification_rules.id", ondelete="SET NULL"), index=True, nullable=True
    )
    alert_id: Mapped[Optional[int]] = mapped_column(
        ForeignKey("alerts.id", ondelete="SET NULL"), index=True, nullable=True
    )

    channel: Mapped[str] = mapped_column(
        String(20), nullable=False, comment="email/webhook/sms"
    )
    status: Mapped[str] = mapped_column(
        String(20), nullable=False, default="sent", comment="sent/failed/queued"
    )
    recipient: Mapped[str] = mapped_column(String(255), nullable=False)
    subject: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    error_message: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

    sent_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )

    # ── Relationships ──
    rule = relationship("NotificationRule")
    alert = relationship("Alert")
