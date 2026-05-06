"""Pydantic schemas for Dataset API."""

from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class DatasetFileOut(BaseModel):
    id: int
    filename: str
    format: Optional[str] = None
    file_size_bytes: Optional[int] = None
    download_count: int = 0
    created_at: Optional[datetime] = None

    model_config = {"from_attributes": True}


class DatasetOut(BaseModel):
    id: int
    name: str
    subtitle: Optional[str] = None
    species: Optional[str] = None
    region: Optional[str] = None
    period: Optional[str] = None
    data_scope: Optional[str] = None
    formats: Optional[List[str]] = None
    category: Optional[str] = None
    doi: Optional[str] = None
    is_published: bool = False
    created_at: Optional[datetime] = None
    files: List[DatasetFileOut] = []

    model_config = {"from_attributes": True}


class DatasetListOut(BaseModel):
    items: List[DatasetOut]
    total: int
    page: int
    page_size: int
