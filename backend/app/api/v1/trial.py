"""Trial Application API router — /api/v1/trials"""

from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.models.user import User
from app.models.trial import TrialApplication
from app.auth.dependencies import require_user, require_approved, get_current_user
from pydantic import BaseModel

router = APIRouter(prefix="/trials", tags=["Trials"])


# ── Schemas (lightweight, inline) ──

class TrialApply(BaseModel):
    """Trial application request."""
    institution: str
    contact_name: Optional[str] = None
    contact_email: str
    contact_phone: Optional[str] = None
    target_species: Optional[str] = None
    preferred_device: Optional[str] = None
    quantity: int = 1
    duration_months: int = 3
    project_brief: Optional[str] = None


class TrialOut(BaseModel):
    """Trial application response."""
    id: int
    institution: str
    contact_name: Optional[str] = None
    contact_email: str
    target_species: Optional[str] = None
    preferred_device: Optional[str] = None
    quantity: int
    duration_months: int
    status: str
    created_at: str

    model_config = {"from_attributes": True}


# ── Routes ──

@router.post("/", response_model=TrialOut, status_code=201)
async def apply_trial(
    body: TrialApply,
    db: AsyncSession = Depends(get_db),
    user: Optional[User] = Depends(get_current_user),
):
    """Submit a trial device application. Auth optional."""
    trial = TrialApplication(
        user_id=user.id if user else None,
        institution=body.institution,
        contact_name=body.contact_name,
        contact_email=body.contact_email,
        contact_phone=body.contact_phone,
        target_species=body.target_species,
        preferred_device=body.preferred_device,
        quantity=body.quantity,
        duration_months=body.duration_months,
        project_brief=body.project_brief,
    )
    db.add(trial)
    await db.flush()
    await db.refresh(trial)

    return TrialOut(
        id=trial.id,
        institution=trial.institution,
        contact_name=trial.contact_name,
        contact_email=trial.contact_email,
        target_species=trial.target_species,
        preferred_device=trial.preferred_device,
        quantity=trial.quantity,
        duration_months=trial.duration_months,
        status=trial.status,
        created_at=str(trial.created_at),
    )


@router.get("/", response_model=list[TrialOut])
async def list_trials(
    status_filter: Optional[str] = Query(None, alias="status"),
    limit: int = Query(20, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: AsyncSession = Depends(get_db),
    user: User = Depends(require_approved),
):
    """List trial applications (authenticated users only)."""
    if user.role != "admin":
        # Regular users only see their own
        query = select(TrialApplication).where(TrialApplication.user_id == user.id)
    else:
        query = select(TrialApplication)

    if status_filter:
        query = query.where(TrialApplication.status == status_filter)

    query = query.order_by(TrialApplication.created_at.desc()).offset(offset).limit(limit)
    result = await db.execute(query)
    trials = result.scalars().all()

    return [
        TrialOut(
            id=t.id,
            institution=t.institution,
            contact_name=t.contact_name,
            contact_email=t.contact_email,
            target_species=t.target_species,
            preferred_device=t.preferred_device,
            quantity=t.quantity,
            duration_months=t.duration_months,
            status=t.status,
            created_at=str(t.created_at),
        )
        for t in trials
    ]
