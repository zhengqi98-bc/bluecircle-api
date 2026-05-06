"""Hardware Applications API — /api/v1/hardware"""

from typing import Optional
from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func

from app.database import get_db
from app.models.hardware import HardwareApplication
from app.models.user import User
from app.schemas.hardware import (
    HardwareCreate,
    HardwareUpdate,
    HardwareOut,
    HardwareListOut,
)
from app.auth.dependencies import require_user, get_current_user

router = APIRouter(prefix="/hardware", tags=["Hardware Applications"])


@router.get("/", response_model=HardwareListOut)
async def list_applications(
    status: Optional[str] = Query(None),
    device_type: Optional[str] = Query(None),
    limit: int = Query(20, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: AsyncSession = Depends(get_db),
    user: User = Depends(require_user),
):
    """List current user's applications."""
    query = select(HardwareApplication).where(
        HardwareApplication.email == user.email
    )

    if status:
        query = query.where(HardwareApplication.status == status)
    if device_type:
        query = query.where(HardwareApplication.device_type == device_type)

    count_q = select(func.count()).select_from(query.subquery())
    total = (await db.execute(count_q)).scalar() or 0

    query = query.order_by(HardwareApplication.created_at.desc()).offset(offset).limit(limit)
    result = await db.execute(query)
    apps = result.scalars().all()

    return HardwareListOut(
        items=[HardwareOut.model_validate(a) for a in apps],
        total=total,
    )


@router.post("/", response_model=HardwareOut, status_code=201)
async def submit_application(
    body: HardwareCreate,
    db: AsyncSession = Depends(get_db),
    user: Optional[User] = Depends(get_current_user),
):
    """Submit a new hardware application. Auth optional but recommended."""
    app = HardwareApplication(
        applicant_name=body.applicant_name,
        email=body.email,
        institution=body.institution,
        phone=body.phone,
        project_title=body.project_title,
        project_description=body.project_description,
        target_species=body.target_species,
        target_count=body.target_count,
        region=body.region,
        latitude=body.latitude,
        longitude=body.longitude,
        device_type=body.device_type,
        quantity=body.quantity,
        start_date=body.start_date,
        end_date=body.end_date,
    )
    db.add(app)
    await db.flush()
    await db.refresh(app)
    return HardwareOut.model_validate(app)


@router.get("/{app_id}", response_model=HardwareOut)
async def get_application(
    app_id: int,
    db: AsyncSession = Depends(get_db),
    user: User = Depends(require_user),
):
    """Get application details (owner or admin)."""
    app = await db.get(HardwareApplication, app_id)
    if not app:
        raise HTTPException(status_code=404, detail="Application not found")
    if app.email != user.email and user.role != "admin":
        raise HTTPException(status_code=403, detail="Not your application")
    return HardwareOut.model_validate(app)


@router.patch("/{app_id}", response_model=HardwareOut)
async def update_application(
    app_id: int,
    body: HardwareUpdate,
    db: AsyncSession = Depends(get_db),
    user: User = Depends(require_user),
):
    """Update application (only before review, owner only)."""
    app = await db.get(HardwareApplication, app_id)
    if not app:
        raise HTTPException(status_code=404, detail="Application not found")
    if app.email != user.email:
        raise HTTPException(status_code=403, detail="Not your application")
    if app.status != "pending":
        raise HTTPException(
            status_code=400, detail="Cannot update application after review"
        )

    for field, value in body.model_dump(exclude_unset=True).items():
        setattr(app, field, value)

    await db.flush()
    await db.refresh(app)
    return HardwareOut.model_validate(app)


@router.delete("/{app_id}", status_code=204)
async def cancel_application(
    app_id: int,
    db: AsyncSession = Depends(get_db),
    user: User = Depends(require_user),
):
    """Cancel an application (only pending, owner only)."""
    app = await db.get(HardwareApplication, app_id)
    if not app:
        raise HTTPException(status_code=404, detail="Application not found")
    if app.email != user.email:
        raise HTTPException(status_code=403, detail="Not your application")
    if app.status != "pending":
        raise HTTPException(
            status_code=400, detail="Can only cancel pending applications"
        )
    await db.delete(app)
    await db.flush()
