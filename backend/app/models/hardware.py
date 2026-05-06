"""Hardware Application model — device request & tracking."""

import uuid
from datetime import datetime
from sqlalchemy import String, DateTime, Text, Integer, Numeric, ForeignKey, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base
from typing import Optional


class HardwareApplication(Base):
    """A researcher's application for tracking hardware devices."""

    __tablename__ = "hardware_applications"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)

    # ── Applicant info ──
    applicant_name: Mapped[str] = mapped_column(String(100), nullable=False)
    email: Mapped[str] = mapped_column(String(255), nullable=False, index=True)
    institution: Mapped[str] = mapped_column(String(255), nullable=False)
    phone: Mapped[Optional[str]] = mapped_column(String(30), nullable=True)

    # ── Project info ──
    project_title: Mapped[str] = mapped_column(String(255), nullable=False)
    project_description: Mapped[str] = mapped_column(Text, nullable=False, default="")
    target_species: Mapped[str] = mapped_column(String(100), nullable=False)
    target_count: Mapped[int] = mapped_column(Integer, nullable=False, default=1)

    # ── Location ──
    region: Mapped[str] = mapped_column(String(255), nullable=False, default="")
    latitude: Mapped[Optional[float]] = mapped_column(Numeric(9, 6), nullable=True)
    longitude: Mapped[Optional[float]] = mapped_column(Numeric(9, 6), nullable=True)

    # ── Device request ──
    device_type: Mapped[str] = mapped_column(
        String(50), nullable=False, default="gps_tag"
    )  # gps_tag | depth_sensor | temp_sensor | camera_tag | satellite_tag
    quantity: Mapped[int] = mapped_column(Integer, nullable=False, default=1)

    # ── Project timeline ──
    start_date: Mapped[Optional[str]] = mapped_column(String(10), nullable=True)
    end_date: Mapped[Optional[str]] = mapped_column(String(10), nullable=True)

    # ── Approval flow ──
    status: Mapped[str] = mapped_column(
        String(20), nullable=False, default="pending"
    )  # pending | approved | rejected | shipped | returned
    reviewer_id: Mapped[Optional[uuid.UUID]] = mapped_column(
        UUID(as_uuid=True), ForeignKey("users.id", ondelete="SET NULL"), nullable=True
    )
    reviewer_notes: Mapped[Optional[str]] = mapped_column(Text, nullable=True)

    # ── Shipping ──
    tracking_number: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    shipped_at: Mapped[Optional[datetime]] = mapped_column(
        DateTime(timezone=True), nullable=True
    )
    expected_return: Mapped[Optional[str]] = mapped_column(String(10), nullable=True)

    # ── Timestamps ──
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now(), onupdate=func.now()
    )

    # ── Relationships ──
    reviewer = relationship("User", back_populates="hardware_reviews")
