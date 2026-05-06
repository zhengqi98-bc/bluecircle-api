"""System health check utilities."""

import os
import time
import shutil
from datetime import datetime, timezone
from typing import Optional

from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

from app.config import settings

# Track service start time
START_TIME = datetime.now(timezone.utc)


async def check_database(db: AsyncSession) -> dict:
    """Check PostgreSQL connectivity."""
    try:
        start = time.monotonic()
        await db.execute(text("SELECT 1"))
        elapsed = round((time.monotonic() - start) * 1000, 1)
        return {"status": "ok", "latency_ms": elapsed}
    except Exception as e:
        return {"status": "error", "message": str(e)[:200]}


def check_redis() -> dict:
    """Check Redis connectivity."""
    try:
        import redis
        start = time.monotonic()
        r = redis.from_url(settings.redis_url, socket_timeout=3)
        r.ping()
        elapsed = round((time.monotonic() - start) * 1000, 1)
        r.close()
        return {"status": "ok", "latency_ms": elapsed}
    except ImportError:
        return {"status": "unknown", "message": "redis-py not installed"}
    except Exception as e:
        return {"status": "error", "message": str(e)[:200]}


def check_disk() -> dict:
    """Check disk usage."""
    try:
        usage = shutil.disk_usage("/")
        total_gb = round(usage.total / (1024**3), 2)
        used_gb = round(usage.used / (1024**3), 2)
        free_gb = round(usage.free / (1024**3), 2)
        pct = round(usage.used / usage.total * 100, 1)
        status = "ok" if pct < 90 else "warning"
        return {
            "status": status,
            "total_gb": total_gb,
            "used_gb": used_gb,
            "free_gb": free_gb,
            "used_pct": pct,
        }
    except Exception as e:
        return {"status": "error", "message": str(e)[:200]}


def check_memory() -> dict:
    """Check memory usage."""
    try:
        mem = {}
        with open("/proc/meminfo") as f:
            for line in f:
                if ":" in line:
                    key, val = line.split(":", 1)
                    mem[key.strip()] = int(val.strip().split()[0])
        total_mb = round(mem.get("MemTotal", 0) / 1024, 1)
        available_mb = round(mem.get("MemAvailable", 0) / 1024, 1)
        used_mb = round(total_mb - available_mb, 1)
        pct = round(used_mb / total_mb * 100, 1) if total_mb > 0 else 0
        status = "ok" if pct < 85 else "warning"
        return {
            "status": status,
            "total_mb": total_mb,
            "used_mb": used_mb,
            "available_mb": available_mb,
            "used_pct": pct,
        }
    except Exception as e:
        return {"status": "error", "message": str(e)[:200]}


def check_uptime() -> dict:
    """Return service uptime."""
    delta = datetime.now(timezone.utc) - START_TIME
    hours, rem = divmod(int(delta.total_seconds()), 3600)
    minutes, seconds = divmod(rem, 60)
    return {
        "started_at": START_TIME.isoformat(),
        "uptime_seconds": int(delta.total_seconds()),
        "uptime_human": f"{hours}h {minutes}m {seconds}s",
    }


async def full_health_check(db: AsyncSession) -> dict:
    """Full health check for admin dashboard."""
    return {
        "app": {
            "name": settings.app_name,
            "version": settings.app_version,
            "environment": settings.environment,
        },
        "database": await check_database(db),
        "redis": check_redis(),
        "disk": check_disk(),
        "memory": check_memory(),
        "uptime": check_uptime(),
        "checked_at": datetime.now(timezone.utc).isoformat(),
    }
