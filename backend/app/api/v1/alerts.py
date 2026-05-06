"""Alerts API router — /api/v1/alerts"""

from datetime import datetime, timezone
from typing import Optional

from fastapi import APIRouter, Depends, Query, HTTPException, BackgroundTasks
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func

from app.database import get_db
from app.models.alert import Alert
from app.models.user import User
from app.schemas.alert import AlertCreate, AlertUpdate, AlertOut, AlertListOut
from app.auth.dependencies import require_user, get_current_user

router = APIRouter(prefix="/alerts", tags=["Alerts"])


@router.get("/", response_model=AlertListOut)
async def list_alerts(
    severity: Optional[str] = Query(None, description="Filter by severity"),
    alert_type: Optional[str] = Query(None, description="Filter by type"),
    status: Optional[str] = Query("open", description="Filter by status"),
    turtle_id: Optional[str] = Query(None),
    limit: int = Query(20, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: AsyncSession = Depends(get_db),
):
    """List alerts with optional filters."""
    query = select(Alert)

    if severity:
        query = query.where(Alert.severity == severity)
    if alert_type:
        query = query.where(Alert.alert_type == alert_type)
    if status:
        query = query.where(Alert.status == status)
    if turtle_id:
        query = query.where(Alert.turtle_id == turtle_id)

    # Count
    count_q = select(func.count()).select_from(query.subquery())
    total = (await db.execute(count_q)).scalar() or 0

    # Paginate
    query = query.order_by(Alert.created_at.desc()).offset(offset).limit(limit)
    result = await db.execute(query)
    alerts = result.scalars().all()

    return AlertListOut(
        items=[AlertOut.model_validate(a) for a in alerts],
        total=total,
    )


@router.post("/", response_model=AlertOut, status_code=201)
async def create_alert(
    body: AlertCreate,
    background_tasks: BackgroundTasks,
    db: AsyncSession = Depends(get_db),
    user: Optional[User] = Depends(get_current_user),
):
    """Create a new alert. Auth optional for automated systems.

    Triggers notification dispatch in background if matching rules exist.
    """
    alert = Alert(
        turtle_id=body.turtle_id,
        alert_type=body.alert_type,
        severity=body.severity,
        title=body.title,
        description=body.description,
        lat=body.lat,
        lng=body.lng,
        metadata_=body.metadata,
    )
    db.add(alert)
    await db.flush()
    await db.refresh(alert)

    # Dispatch notifications in background (fire-and-forget)
    alert_id = alert.id
    background_tasks.add_task(_dispatch_alert_notifications, alert_id)

    return AlertOut.model_validate(alert)


async def _dispatch_alert_notifications(alert_id: int):
    """Background task: dispatch notifications for a new alert."""
    from app.database import async_session
    from app.services.notification_engine import dispatch_notifications

    async with async_session() as db:
        try:
            result = await dispatch_notifications(db, alert_id)
            await db.commit()
        except Exception:
            await db.rollback()


@router.get("/{alert_id}", response_model=AlertOut)
async def get_alert(alert_id: int, db: AsyncSession = Depends(get_db)):
    """Get a single alert by ID."""
    alert = await db.get(Alert, alert_id)
    if not alert:
        raise HTTPException(status_code=404, detail="Alert not found")
    return AlertOut.model_validate(alert)


@router.patch("/{alert_id}", response_model=AlertOut)
async def update_alert(
    alert_id: int,
    body: AlertUpdate,
    db: AsyncSession = Depends(get_db),
    user: User = Depends(require_user),
):
    """Update alert status or description (authenticated)."""
    alert = await db.get(Alert, alert_id)
    if not alert:
        raise HTTPException(status_code=404, detail="Alert not found")

    if body.status is not None:
        alert.status = body.status
        if body.status == "resolved":
            alert.resolved_at = datetime.now(timezone.utc)
    if body.description is not None:
        alert.description = body.description

    await db.flush()
    await db.refresh(alert)
    return AlertOut.model_validate(alert)
