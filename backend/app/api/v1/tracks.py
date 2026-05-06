"""Track Points API router — /api/v1/turtles/{turtle_id}/tracks"""

from datetime import datetime
from typing import Optional

from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func

from app.database import get_db
from app.models.track_point import TrackPoint
from app.models.turtle import Turtle
from app.schemas.track import TrackPointOut, TrackListOut

router = APIRouter(tags=["Tracks"])


@router.get("/turtles/{turtle_id}/tracks", response_model=TrackListOut)
async def get_tracks(
    turtle_id: str,
    from_date: Optional[str] = Query(None, description="Start date (ISO format, e.g. 2026-04-01)"),
    to_date: Optional[str] = Query(None, description="End date (ISO format)"),
    page: int = Query(1, ge=1),
    page_size: int = Query(200, ge=1, le=2000),
    db: AsyncSession = Depends(get_db),
):
    """Get GPS track points for a turtle, with optional date range filter."""
    # Verify turtle exists
    turtle = await db.get(Turtle, turtle_id)
    if not turtle:
        raise HTTPException(status_code=404, detail="Turtle not found")

    query = select(TrackPoint).where(TrackPoint.turtle_id == turtle_id)

    # Date filters
    if from_date:
        try:
            dt_from = datetime.fromisoformat(from_date)
            query = query.where(TrackPoint.time >= dt_from)
        except ValueError:
            raise HTTPException(status_code=400, detail="Invalid from_date format")

    if to_date:
        try:
            dt_to = datetime.fromisoformat(to_date)
            query = query.where(TrackPoint.time <= dt_to)
        except ValueError:
            raise HTTPException(status_code=400, detail="Invalid to_date format")

    # Count total
    count_q = select(func.count()).select_from(query.subquery())
    total = (await db.execute(count_q)).scalar() or 0

    # Paginate
    query = query.order_by(TrackPoint.time.desc()).offset((page - 1) * page_size).limit(page_size)
    result = await db.execute(query)
    points = result.scalars().all()

    return TrackListOut(
        turtle_id=turtle_id,
        items=[TrackPointOut.model_validate(p) for p in points],
        total=total,
        page=page,
    )
