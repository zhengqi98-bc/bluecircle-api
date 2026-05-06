"""FastAPI dependencies for authentication."""

import uuid
from typing import Optional

from fastapi import Depends, HTTPException, Security, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer, APIKeyHeader
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.models.user import User
from app.models.api_key import ApiKey
from app.auth.jwt import decode_access_token
from app.auth.jwt import verify_password as _verify_password

# ── HTTP Bearer scheme (JWT) ──
bearer_scheme = HTTPBearer(auto_error=False)

# ── API Key header scheme ──
api_key_header = APIKeyHeader(name="X-API-Key", auto_error=False)


# ── GET CURRENT USER (JWT) ──

async def get_current_user(
    credentials: Optional[HTTPAuthorizationCredentials] = Security(bearer_scheme),
    db: AsyncSession = Depends(get_db),
) -> User:
    """Validate JWT Bearer token and return the authenticated user.

    Returns None if no token provided (for optional auth).
    For required auth, use `require_user` instead.
    """
    if credentials is None:
        return None

    payload = decode_access_token(credentials.credentials)
    if payload is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )

    user_id = payload.get("sub")
    if user_id is None:
        raise HTTPException(status_code=401, detail="Invalid token payload")

    try:
        user_uuid = uuid.UUID(user_id)
    except ValueError:
        raise HTTPException(status_code=401, detail="Invalid token user ID")

    result = await db.execute(select(User).where(User.id == user_uuid))
    user = result.scalar_one_or_none()
    if user is None:
        raise HTTPException(status_code=401, detail="User not found")
    if not user.is_active:
        raise HTTPException(status_code=403, detail="Account disabled")

    return user


async def require_user(user: Optional[User] = Depends(get_current_user)) -> User:
    """Require authenticated user — raises 401 if no valid token."""
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Authentication required",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return user


# ── GET CURRENT USER (API Key) ──

async def get_user_by_api_key(
    api_key: Optional[str] = Security(api_key_header),
    db: AsyncSession = Depends(get_db),
) -> Optional[User]:
    """Validate API Key header and return the associated user (optional)."""
    if not api_key:
        return None

    # Find API key record by prefix
    from app.config import settings
    from app.api.v1.keys import _hash_key

    # Hash the raw key and find match
    hashed = _hash_key(api_key)
    result = await db.execute(
        select(ApiKey).where(ApiKey.key_hash == hashed)
    )
    key_record = result.scalar_one_or_none()

    if key_record is None:
        return None

    if not key_record.is_active:
        return None

    # Load user
    result = await db.execute(select(User).where(User.id == key_record.user_id))
    user = result.scalar_one_or_none()
    if user is None or not user.is_active:
        return None

    return user


# ── COMBINED AUTH: JWT or API Key ──

async def get_current_user_optional(
    jwt_user: Optional[User] = Depends(get_current_user),
    api_user: Optional[User] = Depends(get_user_by_api_key),
) -> Optional[User]:
    """Try JWT first, then API key. Returns None if neither provided."""
    return jwt_user or api_user


# ── API KEY AUTH (for device ingest) ──

async def get_api_key(
    user: Optional[User] = Depends(get_user_by_api_key),
) -> dict:
    """Require valid API key — raises 401 if missing or invalid."""
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Valid API key required",
        )
    return {"user_id": str(user.id), "email": user.email}

async def require_approved(user: User = Depends(require_user)) -> User:
    """Require user login AND admin approval."""
    if not user.is_approved:
        raise HTTPException(status_code=403, detail="Account pending approval")
    return user


async def require_admin(user: User = Depends(require_approved)) -> User:
    """Require admin role."""
    if user.role != "admin":
        raise HTTPException(status_code=403, detail="Admin access required")
    return user
