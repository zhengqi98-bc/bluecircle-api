"""Dataset & DatasetFile models."""

from datetime import datetime
from sqlalchemy import String, DateTime, Text, Integer, Boolean, BigInteger, ForeignKey, func
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base
from typing import Optional


class Dataset(Base):
    __tablename__ = "datasets"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(300), nullable=False)
    subtitle: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    species: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    region: Mapped[Optional[str]] = mapped_column(String(200), nullable=True)
    period: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    data_scope: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)  # "187天·47k点"
    formats: Mapped[Optional[list[str]]] = mapped_column(ARRAY(String), nullable=True)  # {CSV,GeoJSON,NetCDF}
    category: Mapped[Optional[str]] = mapped_column(String(30), nullable=True)  # track|env
    doi: Mapped[Optional[str]] = mapped_column(String(100), nullable=True)
    is_published: Mapped[bool] = mapped_column(Boolean, default=False)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    files = relationship("DatasetFile", back_populates="dataset", cascade="all, delete-orphan")


class DatasetFile(Base):
    __tablename__ = "dataset_files"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    dataset_id: Mapped[int] = mapped_column(
        Integer, ForeignKey("datasets.id", ondelete="CASCADE"), nullable=False
    )
    filename: Mapped[str] = mapped_column(String(255), nullable=False)
    file_path: Mapped[str] = mapped_column(Text, nullable=False)
    file_size_bytes: Mapped[Optional[int]] = mapped_column(BigInteger, nullable=True)
    format: Mapped[Optional[str]] = mapped_column(String(10), nullable=True)  # csv|geojson|nc|pdf
    download_count: Mapped[int] = mapped_column(Integer, default=0)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    dataset = relationship("Dataset", back_populates="files")
