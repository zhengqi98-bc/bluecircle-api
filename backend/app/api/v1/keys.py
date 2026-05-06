"""API Key management router — /api/v1/keys"""

import uuid
import secrets
import hashlib
from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.models.user import User
from app.models.api_key import ApiKey
from app.schemas.api_key import ApiKeyCreate, ApiKeyOut, ApiKeyCreated
from app.auth.dependencies import require_user, require_approved
from app.config import settings

router = APIRouter(prefix="/keys", tags=["API Keys"])


def _generate_key() -> str:
    """Generate a new API key: bc_ + 40 hex chars."""
    return settings.api_key_prefix + secrets.token_hex(20)


def _hash_key(raw_key: str) -> str:
    """SHA-256 hash of the raw key for storage."""
    return hashlib.sha256(raw_key.encode()).hexdigest()


def _key_to_out(ak: ApiKey) -> ApiKeyOut:
    """Convert ApiKey model to output schema."""
    return ApiKeyOut(
        id=str(ak.id),
        name=ak.name,
        key_prefix=settings.api_key_prefix + "****",
        rate_limit=ak.rate_limit,
        is_active=ak.is_active,
        last_used_at=ak.last_used_at,
        created_at=ak.created_at,
    )


@router.get("/", response_model=list[ApiKeyOut])
async def list_keys(user: User = Depends(require_approved), db: AsyncSession = Depends(get_db)):
    """List all API keys for the authenticated user."""
    result = await db.execute(
        select(ApiKey).where(
            ApiKey.user_id == user.id,
            ApiKey.is_active == True,
        ).order_by(ApiKey.created_at.desc())
    )
    keys = result.scalars().all()
    return [_key_to_out(k) for k in keys]


@router.post("/", response_model=ApiKeyCreated, status_code=201)
async def create_key(body: ApiKeyCreate, user: User = Depends(require_approved), db: AsyncSession = Depends(get_db)):
    """Create a new API key. Returns the raw key ONCE — save it!"""
    raw_key = _generate_key()
    key_hash = _hash_key(raw_key)

    api_key = ApiKey(
        user_id=user.id,
        key_hash=key_hash,
        name=body.name,
        rate_limit=body.rate_limit,
    )
    db.add(api_key)
    await db.flush()
    await db.refresh(api_key)

    return ApiKeyCreated(
        api_key=_key_to_out(api_key),
        raw_key=raw_key,
    )


@router.delete("/{key_id}")
async def revoke_key(key_id: str, user: User = Depends(require_approved), db: AsyncSession = Depends(get_db)):
    """Revoke (deactivate) an API key."""
    try:
        key_uuid = uuid.UUID(key_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid key ID format")

    result = await db.execute(
        select(ApiKey).where(ApiKey.id == key_uuid, ApiKey.user_id == user.id)
    )
    key = result.scalar_one_or_none()

    if key is None:
        raise HTTPException(status_code=404, detail="Key not found")

    key.is_active = False
    await db.flush()

    return {"detail": "API key revoked"}
