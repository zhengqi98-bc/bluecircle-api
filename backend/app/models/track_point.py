"""TrackPoint model — lat/lng columns (TimescaleDB hypertable optional)."""

from datetime import datetime
from sqlalchemy import String, DateTime, Numeric, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base
from typing import Optional


class TrackPoint(Base):
    __tablename__ = "track_points"

    time: Mapped[datetime] = mapped_column(DateTime(timezone=True), primary_key=True, nullable=False)
    turtle_id: Mapped[str] = mapped_column(
        String(20), ForeignKey("turtles.id", ondelete="CASCADE"), primary_key=True, index=True
    )
    lat: Mapped[float] = mapped_column(Numeric(9, 6), nullable=False)
    lng: Mapped[float] = mapped_column(Numeric(9, 6), nullable=False)
    battery_pct: Mapped[Optional[float]] = mapped_column(Numeric(4, 1), nullable=True)
    speed_kmh: Mapped[Optional[float]] = mapped_column(Numeric(5, 2), nullable=True)
    depth_m: Mapped[Optional[float]] = mapped_column(Numeric(5, 1), nullable=True)
    temperature_c: Mapped[Optional[float]] = mapped_column(Numeric(4, 1), nullable=True)
    source: Mapped[str] = mapped_column(String(20), default="satellite")

    turtle = relationship("Turtle", back_populates="track_points")
