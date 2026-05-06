"""Turtle model — uses regular lat/lng columns (PostGIS optional)."""

from datetime import datetime
from sqlalchemy import String, Boolean, DateTime, Numeric, Text, func
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base
from typing import Optional


class Turtle(Base):
    __tablename__ = "turtles"

    id: Mapped[str] = mapped_column(String(20), primary_key=True)  # e.g. "BC-XS-2401"
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    name_en: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    species: Mapped[str] = mapped_column(String(50), nullable=False)
    species_en: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    sex: Mapped[Optional[str]] = mapped_column(String(1), nullable=True)
    age_class: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    origin: Mapped[Optional[str]] = mapped_column(String(200), nullable=True)
    origin_en: Mapped[Optional[str]] = mapped_column(String(200), nullable=True)
    carapace_length_cm: Mapped[Optional[float]] = mapped_column(Numeric(5, 1), nullable=True)
    photo_url: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    device_id: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)

    # Current position (latest known) — using lat/lng columns
    last_lat: Mapped[Optional[float]] = mapped_column(Numeric(9, 6), nullable=True)
    last_lng: Mapped[Optional[float]] = mapped_column(Numeric(9, 6), nullable=True)
    last_battery_pct: Mapped[Optional[float]] = mapped_column(Numeric(4, 1), nullable=True)
    last_speed_kmh: Mapped[Optional[float]] = mapped_column(Numeric(5, 2), nullable=True)
    last_depth_m: Mapped[Optional[float]] = mapped_column(Numeric(5, 1), nullable=True)
    last_seen_at: Mapped[Optional[datetime]] = mapped_column(DateTime(timezone=True), nullable=True)

    # Status
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    risk_level: Mapped[Optional[str]] = mapped_column(String(10), nullable=True)

    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    # Relationships
    track_points = relationship("TrackPoint", back_populates="turtle", cascade="all, delete-orphan")
    alerts = relationship("Alert", back_populates="turtle", cascade="all, delete-orphan")
    reports = relationship("Report", back_populates="turtle", cascade="all, delete-orphan")
    notification_rules = relationship("NotificationRule", back_populates="turtle", cascade="all, delete-orphan")
