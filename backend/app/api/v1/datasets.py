"""Dataset API router — /api/v1/datasets"""

from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from sqlalchemy.orm import selectinload
from typing import Optional

from app.database import get_db
from app.models.dataset import Dataset
from app.schemas.dataset import DatasetOut, DatasetListOut, DatasetFileOut

router = APIRouter(prefix="/datasets", tags=["Datasets"])


@router.get("/", response_model=DatasetListOut)
async def list_datasets(
    category: Optional[str] = Query(None, description="Filter by category: track|env"),
    species: Optional[str] = Query(None, description="Filter by species"),
    q: Optional[str] = Query(None, description="Search in name/subtitle/species/region"),
    page: int = Query(1, ge=1),
    page_size: int = Query(7, ge=1, le=50),
    db: AsyncSession = Depends(get_db),
):
    """List research datasets with filtering, search, and pagination."""
    query = select(Dataset).options(selectinload(Dataset.files))

    if category and category != "all":
        query = query.where(Dataset.category == category)
    if species and species != "all":
        query = query.where(Dataset.species.ilike(f"%{species}%"))
    if q:
        search = f"%{q}%"
        query = query.where(
            (Dataset.name.ilike(search))
            | (Dataset.subtitle.ilike(search))
            | (Dataset.species.ilike(search))
            | (Dataset.region.ilike(search))
        )

    # Total count
    count_q = select(func.count()).select_from(query.subquery())
    total = (await db.execute(count_q)).scalar() or 0

    # Paginate
    query = query.order_by(Dataset.id).offset((page - 1) * page_size).limit(page_size)
    result = await db.execute(query)
    datasets = result.scalars().unique().all()

    items = [
        DatasetOut(
            id=d.id,
            name=d.name,
            subtitle=d.subtitle,
            species=d.species,
            region=d.region,
            period=d.period,
            data_scope=d.data_scope,
            formats=d.formats,
            category=d.category,
            doi=d.doi,
            is_published=d.is_published,
            created_at=d.created_at,
            files=_files_to_out(d),
        )
        for d in datasets
    ]
    return DatasetListOut(items=items, total=total, page=page, page_size=page_size)


@router.get("/{dataset_id}", response_model=DatasetOut)
async def get_dataset(
    dataset_id: int,
    db: AsyncSession = Depends(get_db),
):
    """Get a single dataset by ID, including its files."""
    result = await db.execute(
        select(Dataset).options(selectinload(Dataset.files)).where(Dataset.id == dataset_id)
    )
    dataset = result.scalar()
    if not dataset:
        raise HTTPException(status_code=404, detail="Dataset not found")

    return DatasetOut(
        id=dataset.id,
        name=dataset.name,
        subtitle=dataset.subtitle,
        species=dataset.species,
        region=dataset.region,
        period=dataset.period,
        data_scope=dataset.data_scope,
        formats=dataset.formats,
        category=dataset.category,
        doi=dataset.doi,
        is_published=dataset.is_published,
        created_at=dataset.created_at,
        files=_files_to_out(dataset),
    )


def _files_to_out(d: Dataset) -> list:
    """Convert dataset files to output schema."""
    return [
        DatasetFileOut(
            id=f.id,
            filename=f.filename,
            format=f.format,
            file_size_bytes=f.file_size_bytes,
            download_count=f.download_count or 0,
            created_at=f.created_at,
        )
        for f in (d.files or [])
    ]


