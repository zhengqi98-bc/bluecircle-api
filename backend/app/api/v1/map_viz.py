"""Map visualization aggregation API — heatmap, distribution, corridor."""

from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, text
from typing import Optional

from app.database import get_db
from app.models.turtle import Turtle
from app.models.track_point import TrackPoint
from app.schemas.map_viz import (
    HeatmapPoint, HeatmapResponse, SpeciesDistribution,
    DistributionResponse, CorridorPoint, CorridorResponse,
)

router = APIRouter(prefix="/map", tags=["Map Visualization"])


# ── Heatmap (activity density) ──────────────────────────────────────

@router.get("/heatmap", response_model=HeatmapResponse)
async def get_heatmap(
    turtle_id: Optional[str] = Query(None, description="Filter to single turtle"),
    species: Optional[str] = Query(None, description="Filter by species"),
    days: int = Query(30, ge=1, le=365, description="Days of data to include"),
    resolution: float = Query(0.5, ge=0.1, le=5.0, description="Grid resolution in degrees"),
    db: AsyncSession = Depends(get_db),
):
    """Get heatmap data for turtle activity density.

    Returns a list of weighted lat/lng points aggregated from track data.
    Each point represents a grid cell with weight = number of track points in that cell.
    """
    # Build query for track points
    q = (
        select(
            func.round(TrackPoint.lat / resolution).label("lat_bin"),
            func.round(TrackPoint.lng / resolution).label("lng_bin"),
            func.count().label("weight"),
        )
        .select_from(TrackPoint)
    )

    if turtle_id:
        # Verify turtle exists
        turtle_check = await db.execute(select(Turtle).where(Turtle.id == turtle_id))
        if not turtle_check.scalar():
            raise HTTPException(status_code=404, detail="Turtle not found")
        q = q.where(TrackPoint.turtle_id == turtle_id)

    if species:
        # Join with turtles to filter by species
        q = q.join(Turtle, TrackPoint.turtle_id == Turtle.id)
        q = q.where(Turtle.species == species)

    if days:
        q = q.where(
            TrackPoint.time >= func.now() - text("INTERVAL :days days").bindparams(days=days)
        )

    q = q.group_by("lat_bin", "lng_bin").order_by(func.count().desc())
    result = await db.execute(q)
    rows = result.all()

    points = []
    min_lat, max_lat = 90, -90
    min_lng, max_lng = 180, -180

    for lat_bin, lng_bin, weight in rows:
        lat = float(lat_bin) * resolution
        lng = float(lng_bin) * resolution
        w = int(weight)
        points.append(HeatmapPoint(lat=lat, lng=lng, weight=w))

        if lat < min_lat:
            min_lat = lat
        if lat > max_lat:
            max_lat = lat
        if lng < min_lng:
            min_lng = lng
        if lng > max_lng:
            max_lng = lng

    if not points:
        min_lat, max_lat = 0, 0
        min_lng, max_lng = 0, 0

    return HeatmapResponse(
        points=points,
        total_points=sum(p.weight for p in points),
        grid_resolution_deg=resolution,
        bounds={
            "north": max_lat + resolution,
            "south": min_lat - resolution,
            "east": max_lng + resolution,
            "west": min_lng - resolution,
        },
    )


# ── Species distribution ────────────────────────────────────────────

@router.get("/distribution", response_model=DistributionResponse)
async def get_distribution(
    db: AsyncSession = Depends(get_db),
):
    """Get species distribution statistics for pie chart visualization."""
    q = (
        select(Turtle.species, Turtle.species_en, func.count(Turtle.id))
        .group_by(Turtle.species, Turtle.species_en)
        .order_by(func.count(Turtle.id).desc())
    )
    result = await db.execute(q)
    rows = result.all()

    species_list = []
    total = sum(count for _, _, count in rows)

    for sp, sp_en, count in rows:
        species_list.append(SpeciesDistribution(
            species=sp,
            species_en=sp_en or sp,
            count=count,
            percentage=round(count / total * 100, 1) if total > 0 else 0,
        ))

    return DistributionResponse(total=total, species=species_list)


# ── Migration corridor ──────────────────────────────────────────────

@router.get("/corridor/{turtle_id}", response_model=CorridorResponse)
async def get_corridor(
    turtle_id: str,
    resolution: float = Query(0.2, ge=0.05, le=2.0, description="Corridor grid resolution in degrees"),
    db: AsyncSession = Depends(get_db),
):
    """Get migration corridor analysis for a specific turtle.

    Aggregates track points into grid cells with density = count of passes,
    calculates total distance and general direction.
    """
    # Verify turtle exists
    turtle_result = await db.execute(select(Turtle).where(Turtle.id == turtle_id))
    turtle = turtle_result.scalar()
    if not turtle:
        raise HTTPException(status_code=404, detail="Turtle not found")

    # Aggregate track points into corridor grid cells
    q = (
        select(
            func.round(TrackPoint.lat / resolution).label("lat_bin"),
            func.round(TrackPoint.lng / resolution).label("lng_bin"),
            func.count().label("density"),
        )
        .where(TrackPoint.turtle_id == turtle_id)
        .group_by("lat_bin", "lng_bin")
        .order_by("lat_bin", "lng_bin")
    )
    result = await db.execute(q)
    rows = result.all()

    corridor_points = [
        CorridorPoint(
            lat=float(lat_bin) * resolution,
            lng=float(lng_bin) * resolution,
            density=float(density),
        )
        for lat_bin, lng_bin, density in rows
    ]

    # Calculate corridor width (standard deviation of points from mean line)
    if len(corridor_points) >= 2:
        lats = [p.lat for p in corridor_points]
        lngs = [p.lng for p in corridor_points]
        mean_lat = sum(lats) / len(lats)
        mean_lng = sum(lngs) / len(lngs)

        # Estimate width as 2 * avg deviation (gives ~95% corridor)
        lat_dev = sum(abs(p.lat - mean_lat) for p in corridor_points) / len(corridor_points)
        lng_dev = sum(abs(p.lng - mean_lng) for p in corridor_points) / len(corridor_points)
        # Approximate km: 1° ≈ 111km
        corridor_width = max(lat_dev, lng_dev) * 2 * 111
    else:
        corridor_width = 0

    # Calculate total distance
    total_distance = 0
    if len(corridor_points) >= 2:
        for i in range(1, len(corridor_points)):
            dlat = corridor_points[i].lat - corridor_points[i-1].lat
            dlng = corridor_points[i].lng - corridor_points[i-1].lng
            total_distance += ((dlat * 111) ** 2 + (dlng * 111) ** 2) ** 0.5

    # Determine general direction
    direction = "mixed"
    if len(corridor_points) >= 2:
        start_lat, start_lng = corridor_points[0].lat, corridor_points[0].lng
        end_lat, end_lng = corridor_points[-1].lat, corridor_points[-1].lng
        dlat = end_lat - start_lat
        dlng = end_lng - start_lng

        if abs(dlat) > abs(dlng):
            direction = "north" if dlat > 0 else "south"
        else:
            direction = "east" if dlng > 0 else "west"

    # Count total track points
    count_q = select(func.count()).where(TrackPoint.turtle_id == turtle_id)
    total_tracks = (await db.execute(count_q)).scalar() or 0

    return CorridorResponse(
        turtle_id=turtle_id,
        turtle_name=turtle.name,
        corridor_points=corridor_points,
        total_track_points=total_tracks,
        corridor_width_km=round(corridor_width, 1),
        direction=direction,
        distance_km=round(total_distance, 1),
    )
