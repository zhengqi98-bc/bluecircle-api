"""Turtle API router — /api/v1/turtles"""

from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func
from typing import Optional

from app.database import get_db
from app.models.turtle import Turtle
from app.schemas.turtle import TurtleOut, TurtleListOut

router = APIRouter(prefix="/turtles", tags=["Turtles"])


@router.get("/", response_model=TurtleListOut)
async def list_turtles(
    species: Optional[str] = Query(None, description="Filter by species"),
    is_active: Optional[bool] = Query(None, description="Filter active only"),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: AsyncSession = Depends(get_db),
):
    """List all tracked turtles with live sensor data."""
    query = select(Turtle)

    if species:
        query = query.where(Turtle.species == species)
    if is_active is not None:
        query = query.where(Turtle.is_active == is_active)

    # Total count
    count_q = select(func.count()).select_from(query.subquery())
    total = (await db.execute(count_q)).scalar() or 0

    # Fetch page
    query = query.order_by(Turtle.id).offset(offset).limit(limit)
    result = await db.execute(query)
    turtles = result.scalars().all()

    items = [_turtle_to_out(t) for t in turtles]
    return TurtleListOut(items=items, total=total)


@router.get("/{turtle_id}", response_model=TurtleOut)
async def get_turtle(turtle_id: str, db: AsyncSession = Depends(get_db)):
    """Get a single turtle by ID."""
    turtle = await db.get(Turtle, turtle_id)
    if not turtle:
        raise HTTPException(status_code=404, detail="Turtle not found")
    return _turtle_to_out(turtle)


def _turtle_to_out(t: Turtle) -> TurtleOut:
    return TurtleOut(
        id=t.id,
        name=t.name,
        name_en=t.name_en,
        species=t.species,
        species_en=t.species_en,
        sex=t.sex,
        age_class=t.age_class,
        origin=t.origin,
        origin_en=t.origin_en,
        carapace_length_cm=float(t.carapace_length_cm) if t.carapace_length_cm else None,
        photo_url=t.photo_url,
        device_id=t.device_id,
        is_active=t.is_active,
        risk_level=t.risk_level,
        lat=float(t.last_lat) if t.last_lat else None,
        lng=float(t.last_lng) if t.last_lng else None,
        battery_pct=float(t.last_battery_pct) if t.last_battery_pct else None,
        speed_kmh=float(t.last_speed_kmh) if t.last_speed_kmh else None,
        depth_m=float(t.last_depth_m) if t.last_depth_m else None,
        last_seen_at=t.last_seen_at,
        created_at=t.created_at,
    )
