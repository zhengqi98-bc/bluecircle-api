"""Report model."""

import uuid
from datetime import datetime
from sqlalchemy import String, DateTime, Text, ForeignKey, func
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base
from typing import Optional


class Report(Base):
    __tablename__ = "reports"

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    report_type: Mapped[str] = mapped_column(
        String(30), nullable=False
    )  # turtle_activity | fleet_overview | monthly_summary | alert_summary
    turtle_id: Mapped[Optional[str]] = mapped_column(
        String(20), ForeignKey("turtles.id", ondelete="SET NULL"), index=True, nullable=True
    )
    params: Mapped[Optional[dict]] = mapped_column(JSONB, nullable=True)
    status: Mapped[str] = mapped_column(
        String(20), default="completed"
    )  # pending | generating | completed | failed
    html_content: Mapped[str] = mapped_column(Text, nullable=False, default="")
    file_path: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    created_by: Mapped[Optional[uuid.UUID]] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("users.id", ondelete="SET NULL"),
        index=True,
        nullable=True,
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), server_default=func.now()
    )
    completed_at: Mapped[Optional[datetime]] = mapped_column(
        DateTime(timezone=True), nullable=True
    )

    turtle = relationship("Turtle", back_populates="reports")
    user = relationship("User", back_populates="reports")
