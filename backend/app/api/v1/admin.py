"""Admin API router — /api/v1/admin"""

from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func

from app.database import get_db
from app.models.user import User
from app.models.turtle import Turtle
from app.models.dataset import Dataset
from app.models.alert import Alert
from app.models.trial import TrialApplication
from app.models.track_point import TrackPoint
from app.models.hardware import HardwareApplication
from app.auth.dependencies import require_user
from app.schemas.admin import UserAdminOut, TrialReview, DashboardStats
from app.services.health import full_health_check

router = APIRouter(prefix="/admin", tags=["Admin"])


# ── Admin guard ──
async def require_admin(user: User = Depends(require_user)) -> User:
    if user.role != "admin":
        raise HTTPException(status_code=403, detail="Admin access required")
    return user


# ── Dashboard Stats ──

@router.get("/health")
async def admin_health(
    db: AsyncSession = Depends(get_db),
    _admin: User = Depends(require_admin),
):
    """Detailed system health (admin only)."""
    return await full_health_check(db)


@router.get("/stats", response_model=DashboardStats)
async def dashboard_stats(db: AsyncSession = Depends(get_db), _admin: User = Depends(require_admin)):
    """Get aggregate statistics for admin dashboard."""
    # These could be optimized into a single query, but fine for now
    total_turtles = (await db.execute(select(func.count()).select_from(Turtle.__table__))).scalar() or 0
    active_turtles = (await db.execute(
        select(func.count()).select_from(Turtle.__table__).where(Turtle.is_active == True)
    )).scalar() or 0
    total_users = (await db.execute(select(func.count()).select_from(User.__table__))).scalar() or 0
    total_datasets = (await db.execute(select(func.count()).select_from(Dataset.__table__))).scalar() or 0
    total_alerts = (await db.execute(select(func.count()).select_from(Alert.__table__))).scalar() or 0
    open_alerts = (await db.execute(
        select(func.count()).select_from(Alert.__table__).where(Alert.status == "open")
    )).scalar() or 0
    pending_trials = (await db.execute(
        select(func.count()).select_from(TrialApplication.__table__).where(TrialApplication.status == "pending")
    )).scalar() or 0
    total_points = (await db.execute(select(func.count()).select_from(TrackPoint.__table__))).scalar() or 0

    return DashboardStats(
        total_turtles=total_turtles,
        active_turtles=active_turtles,
        total_users=total_users,
        total_datasets=total_datasets,
        total_alerts=total_alerts,
        open_alerts=open_alerts,
        pending_trials=pending_trials,
        total_track_points=total_points,
    )


# ── User Management ──

@router.get("/users", response_model=list[UserAdminOut])
async def list_users(
    role: Optional[str] = Query(None),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: AsyncSession = Depends(get_db),
    _admin: User = Depends(require_admin),
):
    """List all users (admin only)."""
    query = select(User)
    if role:
        query = query.where(User.role == role)
    query = query.order_by(User.created_at.desc()).offset(offset).limit(limit)
    result = await db.execute(query)
    users = result.scalars().all()
    return [UserAdminOut.model_validate(u) for u in users]


@router.patch("/users/{user_id}/role")
async def set_user_role(
    user_id: str, role: str = Query(..., pattern="^(user|researcher|admin)$"),
    db: AsyncSession = Depends(get_db), _admin: User = Depends(require_admin),
):
    """Change a user's role."""
    user = await db.get(User, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.role = role
    await db.flush()
    return {"detail": f"User {user.email} role set to {role}"}


@router.patch("/users/{user_id}/approve")
async def approve_user(
    user_id: str, approved: bool = Query(True),
    db: AsyncSession = Depends(get_db), _admin: User = Depends(require_admin),
):
    """Approve or reject a user registration (toggle is_approved)."""
    user = await db.get(User, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.is_approved = approved
    await db.flush()
    return {"detail": f"User {user.email} is_approved set to {approved}"}


# ── Trial Management ──

@router.get("/trials", response_model=list)
async def list_trials(
    status: Optional[str] = Query("pending"),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: AsyncSession = Depends(get_db),
    _admin: User = Depends(require_admin),
):
    """List trial applications (admin view — all users)."""
    query = select(TrialApplication)
    if status:
        query = query.where(TrialApplication.status == status)
    query = query.order_by(TrialApplication.created_at.desc()).offset(offset).limit(limit)
    result = await db.execute(query)
    trials = result.scalars().all()
    return [
        {
            "id": t.id,
            "institution": t.institution,
            "contact_name": t.contact_name,
            "contact_email": t.contact_email,
            "target_species": t.target_species,
            "quantity": t.quantity,
            "duration_months": t.duration_months,
            "status": t.status,
            "reviewer_notes": t.reviewer_notes,
            "created_at": str(t.created_at),
        }
        for t in trials
    ]


@router.patch("/trials/{trial_id}/review")
async def review_trial(
    trial_id: int, body: TrialReview,
    db: AsyncSession = Depends(get_db), _admin: User = Depends(require_admin),
):
    """Approve or reject a trial application."""
    trial = await db.get(TrialApplication, trial_id)
    if not trial:
        raise HTTPException(status_code=404, detail="Trial not found")
    trial.status = body.status
    trial.reviewer_notes = body.reviewer_notes
    await db.flush()
    return {"detail": f"Trial {trial_id} {body.status}"}


# ── Hardware Application Management ──

from app.schemas.hardware import HardwareOut, HardwareReview, HardwareShip


@router.get("/hardware", response_model=list)
async def list_hardware_apps(
    status: Optional[str] = Query(None),
    device_type: Optional[str] = Query(None),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: AsyncSession = Depends(get_db),
    _admin: User = Depends(require_admin),
):
    """List all hardware applications (admin only)."""
    query = select(HardwareApplication)
    if status:
        query = query.where(HardwareApplication.status == status)
    if device_type:
        query = query.where(HardwareApplication.device_type == device_type)
    query = query.order_by(HardwareApplication.created_at.desc()).offset(offset).limit(limit)
    result = await db.execute(query)
    apps = result.scalars().all()
    return [HardwareOut.model_validate(a).model_dump() for a in apps]


@router.patch("/hardware/{app_id}/review")
async def review_hardware_app(
    app_id: int,
    body: HardwareReview,
    db: AsyncSession = Depends(get_db),
    admin: User = Depends(require_admin),
):
    """Approve or reject a hardware application."""
    app = await db.get(HardwareApplication, app_id)
    if not app:
        raise HTTPException(status_code=404, detail="Application not found")
    if app.status != "pending":
        raise HTTPException(
            status_code=400, detail="Can only review pending applications"
        )
    app.status = body.status
    app.reviewer_id = admin.id
    app.reviewer_notes = body.reviewer_notes
    await db.flush()
    return {"detail": f"Hardware application {app_id} {body.status}"}


@router.patch("/hardware/{app_id}/ship")
async def ship_hardware(
    app_id: int,
    body: HardwareShip,
    db: AsyncSession = Depends(get_db),
    admin: User = Depends(require_admin),
):
    """Mark an approved application as shipped with tracking number."""
    app = await db.get(HardwareApplication, app_id)
    if not app:
        raise HTTPException(status_code=404, detail="Application not found")
    if app.status != "approved":
        raise HTTPException(
            status_code=400, detail="Can only ship approved applications"
        )
    app.status = "shipped"
    app.tracking_number = body.tracking_number
    from datetime import datetime, timezone
    app.shipped_at = datetime.now(timezone.utc)
    app.expected_return = body.expected_return
    await db.flush()
    return {"detail": f"Hardware app {app_id} marked as shipped"}
