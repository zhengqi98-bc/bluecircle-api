"""Data ingestion service — validate, deduplicate, store, and push."""

import json
from datetime import datetime, timezone
from typing import Optional

from sqlalchemy import select, exists
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.track_point import TrackPoint
from app.models.turtle import Turtle
from app.schemas.ingest import IngestPayload, IngestResponse

# Redis connection (lazy init)
_redis = None


def _get_redis():
    """Lazy-init Redis connection."""
    global _redis
    if _redis is not None:
        return _redis
    try:
        import redis as redis_lib
        from app.config import settings
        _redis = redis_lib.from_url(settings.redis_url, decode_responses=True)
        _redis.ping()
    except Exception:
        _redis = False  # Mark as unavailable
    return _redis


async def _point_exists(db: AsyncSession, turtle_id: str, ts: datetime) -> bool:
    """Check if a track point already exists."""
    stmt = select(exists().where(
        TrackPoint.turtle_id == turtle_id,
        TrackPoint.time == ts,
    ))
    result = await db.execute(stmt)
    return result.scalar() or False


async def _update_turtle_position(
    db: AsyncSession, turtle_id: str, lat: float, lng: float,
    battery: Optional[float], speed: Optional[float], depth: Optional[float], ts: datetime
) -> None:
    """Update turtle's last-known position."""
    result = await db.execute(select(Turtle).where(Turtle.id == turtle_id))
    turtle = result.scalar()
    if not turtle:
        return

    turtle.last_lat = lat
    turtle.last_lng = lng
    turtle.last_seen_at = ts
    if battery is not None:
        turtle.last_battery_pct = battery
    if speed is not None:
        turtle.last_speed_kmh = speed
    if depth is not None:
        turtle.last_depth_m = depth
    await db.flush()


async def process_single_point(
    db: AsyncSession, payload: IngestPayload
) -> dict:
    """Process a single data point. Returns status dict."""
    # Parse timestamp
    ts_str = payload.timestamp
    if ts_str:
        ts = datetime.fromisoformat(ts_str.replace("Z", "+00:00"))
        if ts.tzinfo is None:
            ts = ts.replace(tzinfo=timezone.utc)
    else:
        ts = datetime.now(timezone.utc)

    # Verify turtle exists (skip if not found to avoid FK violation)
    turtle_exists = await db.execute(
        select(exists().where(Turtle.id == payload.turtle_id))
    )
    if not turtle_exists.scalar():
        return {"status": "rejected", "reason": f"Unknown turtle: {payload.turtle_id}"}

    # Check duplicate
    if await _point_exists(db, payload.turtle_id, ts):
        return {"status": "duplicate"}

    # Create track point
    tp = TrackPoint(
        time=ts,
        turtle_id=payload.turtle_id,
        lat=payload.lat,
        lng=payload.lng,
        battery_pct=payload.battery_pct,
        speed_kmh=payload.speed_kmh,
        depth_m=payload.depth_m,
        temperature_c=payload.temperature_c,
        source=payload.source,
    )
    db.add(tp)

    # Update turtle last position
    await _update_turtle_position(
        db, payload.turtle_id, payload.lat, payload.lng,
        payload.battery_pct, payload.speed_kmh, payload.depth_m, ts
    )

    # Push to Redis for WebSocket broadcast
    _publish_to_redis(payload)

    return {"status": "accepted"}


def _publish_to_redis(payload: IngestPayload) -> None:
    """Publish new data to Redis pub/sub for WebSocket broadcast."""
    try:
        r = _get_redis()
        if r:
            msg = json.dumps({
                "turtle_id": payload.turtle_id,
                "lat": payload.lat,
                "lng": payload.lng,
                "battery_pct": payload.battery_pct,
                "speed_kmh": payload.speed_kmh,
                "depth_m": payload.depth_m,
                "temperature_c": payload.temperature_c,
                "source": payload.source,
                "timestamp": payload.timestamp or datetime.now(timezone.utc).isoformat(),
            })
            r.publish("tracking:live", msg)
    except Exception:
        pass  # Redis failure shouldn't block ingest


async def process_ingest(
    db: AsyncSession, points: list[IngestPayload]
) -> IngestResponse:
    """Process a batch of data points. Returns summary."""
    accepted = 0
    rejected = 0
    duplicates = 0
    errors: list[str] = []

    for i, payload in enumerate(points):
        try:
            result = await process_single_point(db, payload)
            if result["status"] == "accepted":
                accepted += 1
            elif result["status"] == "duplicate":
                duplicates += 1
            else:
                rejected += 1
                reason = result.get("reason", "unknown")
                errors.append(f"Point {i} ({payload.turtle_id}): {reason}")
        except Exception as e:
            rejected += 1
            errors.append(f"Point {i}: {str(e)[:120]}")

    return IngestResponse(
        accepted=accepted,
        rejected=rejected,
        duplicates=duplicates,
        errors=errors,
    )
