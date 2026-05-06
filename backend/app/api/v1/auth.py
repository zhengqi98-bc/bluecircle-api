"""Auth API router — /api/v1/auth"""

import uuid

from fastapi import APIRouter, Body, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.models.user import User
from app.schemas.user import (
    UserRegister, UserLogin, TokenResponse, RefreshRequest, UserOut,
)
from app.auth import jwt
from app.auth.dependencies import require_user

router = APIRouter(prefix="/auth", tags=["Auth"])


@router.post("/register", status_code=201)
async def register(body: UserRegister, db: AsyncSession = Depends(get_db)):
    """Register a new user account and return JWT tokens."""
    # Check email uniqueness
    result = await db.execute(select(User).where(User.email == body.email))
    if result.scalar_one_or_none():
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Email already registered",
        )

    # Create user
    user = User(
        email=body.email,
        password_hash=jwt.hash_password(body.password),
        institution=body.institution,
    )
    db.add(user)
    await db.flush()

    # Don't issue tokens — user needs admin approval first
    return {"detail": "Registration successful. Please wait for admin approval.", "user_id": str(user.id)}


@router.post("/login", response_model=TokenResponse)
async def login(body: UserLogin, db: AsyncSession = Depends(get_db)):
    """Login with email + password and return JWT tokens."""
    result = await db.execute(select(User).where(User.email == body.email))
    user = result.scalar_one_or_none()

    if not user or not jwt.verify_password(body.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password",
        )

    if not user.is_active:
        raise HTTPException(status_code=403, detail="Account disabled")
    if not user.is_approved:
        raise HTTPException(status_code=403, detail="Account pending approval")

    token_data = {"sub": str(user.id), "email": user.email, "role": user.role}
    return TokenResponse(
        access_token=jwt.create_access_token(token_data),
        refresh_token=jwt.create_refresh_token(token_data),
    )


@router.post("/refresh", response_model=TokenResponse)
async def refresh_token(body: RefreshRequest, db: AsyncSession = Depends(get_db)):
    """Exchange a refresh token for a new access token pair."""
    payload = jwt.decode_refresh_token(body.refresh_token)
    if payload is None:
        raise HTTPException(status_code=401, detail="Invalid or expired refresh token")

    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=401, detail="Invalid token payload")

    # Verify user still exists and is active
    try:
        user_uuid = uuid.UUID(user_id)
    except ValueError:
        raise HTTPException(status_code=401, detail="Invalid token")

    result = await db.execute(select(User).where(User.id == user_uuid))
    user = result.scalar_one_or_none()
    if not user or not user.is_active:
        raise HTTPException(status_code=401, detail="User not found or disabled")

    token_data = {"sub": str(user.id), "email": user.email, "role": user.role}
    return TokenResponse(
        access_token=jwt.create_access_token(token_data),
        refresh_token=jwt.create_refresh_token(token_data),
    )


@router.get("/me", response_model=UserOut)
async def get_me(user: User = Depends(require_user)):
    """Return current authenticated user's profile."""
    return user

@router.post("/change-password")
async def change_password(
    old_password: str = Body(...),
    new_password: str = Body(..., min_length=8),
    user: User = Depends(require_user),
    db: AsyncSession = Depends(get_db),
):
    """Change current user's password."""
    if not jwt.verify_password(old_password, user.password_hash):
        raise HTTPException(status_code=400, detail="Current password is incorrect")
    user.password_hash = jwt.hash_password(new_password)
    await db.flush()
    return {"detail": "Password changed successfully"}
