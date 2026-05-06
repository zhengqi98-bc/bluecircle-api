"""Blue Circle API — FastAPI application entry point."""

from contextlib import asynccontextmanager
from fastapi import FastAPI, WebSocket
from fastapi.middleware.cors import CORSMiddleware

from app.config import settings
from app.database import engine, Base
from app.api.v1 import turtles as turtles_router
from app.api.v1 import datasets as datasets_router
from app.api.v1 import auth as auth_router
from app.api.v1 import keys as keys_router
from app.api.v1 import trial as trial_router
from app.api.v1 import tracks as tracks_router
from app.api.v1 import alerts as alerts_router
from app.api.v1 import admin as admin_router
from app.api.v1 import reports as reports_router
from app.api.v1 import hardware as hardware_router
from app.api.v1 import ingest as ingest_router
from app.api.v1 import webhooks as webhooks_router
from app.api.v1 import map_viz as map_viz_router
from app.api.v1 import notifications as notifications_router
from app.middleware.rate_limit import RateLimitMiddleware
from app.middleware.cache import CacheMiddleware
from app.ws import ws_live_tracking
from app.services.health import check_database, check_redis, check_disk, check_uptime

# Import all models so Base.metadata knows about them
from app.models import Turtle, TrackPoint, Alert, Dataset, DatasetFile, TrialApplication, ApiKey, User, Report, HardwareApplication  # noqa: F401


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan: create tables on startup (dev mode)."""
    if settings.environment == "development":
        async with engine.begin() as conn:
            await conn.run_sync(Base.metadata.create_all)
    yield


app = FastAPI(
    title=settings.app_name,
    version=settings.app_version,
    lifespan=lifespan,
)

# ── CORS ──
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origin_list,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allow_headers=["Authorization", "Content-Type", "X-API-Key"],
)

# ── Rate Limiting (after CORS, before routers) ──
app.add_middleware(RateLimitMiddleware)

# ── Response Caching (Redis, 60s TTL) ──
app.add_middleware(CacheMiddleware, ttl=60)

# ── REST Routers ──
app.include_router(turtles_router.router, prefix="/api/v1")
app.include_router(datasets_router.router, prefix="/api/v1")
app.include_router(auth_router.router, prefix="/api/v1")
app.include_router(keys_router.router, prefix="/api/v1")
app.include_router(trial_router.router, prefix="/api/v1")
app.include_router(tracks_router.router, prefix="/api/v1")
app.include_router(alerts_router.router, prefix="/api/v1")
app.include_router(admin_router.router, prefix="/api/v1")
app.include_router(reports_router.router, prefix="/api/v1")
app.include_router(hardware_router.router, prefix="/api/v1")
app.include_router(ingest_router.router, prefix="/api/v1")
app.include_router(webhooks_router.router, prefix="/api/v1")
app.include_router(map_viz_router.router, prefix="/api/v1")
app.include_router(notifications_router.router, prefix="/api/v1")

# ── WebSocket ──
@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    turtle_id = websocket.query_params.get("turtle_id")
    await ws_live_tracking(websocket, turtle_id=turtle_id)


@app.get("/")
async def root():
    return {
        "name": settings.app_name,
        "version": settings.app_version,
        "environment": settings.environment,
        "docs": "/docs",
    }


@app.get("/health")
async def health():
    """Quick health check."""
    return {
        "status": "ok",
        "environment": settings.environment,
        "version": settings.app_version,
        "uptime": check_uptime(),
    }

@app.get("/_migrate")
async def run_migration():
    """One-time migration: create all tables."""
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    return {"status": "migrated"}
