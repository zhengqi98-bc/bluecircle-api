"""Redis-based rate limiting middleware for API keys.

Limits requests per API key based on `rate_limit` field on the ApiKey model.
JWT-authenticated users bypass rate limiting (for now).
"""

import time
from typing import Optional

from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import JSONResponse

from app.config import settings


class RateLimitMiddleware(BaseHTTPMiddleware):
    """Rate limit middleware backed by Redis.

    Tracks requests per API key in a sliding window.
    Rate limit value comes from the ApiKey model's rate_limit field
    (requests per minute). Default: 100 rpm.
    """

    async def dispatch(self, request: Request, call_next):
        # Skip rate limiting for non-API paths
        if not request.url.path.startswith("/api/"):
            return await call_next(request)

        api_key = request.headers.get("X-API-Key")
        if not api_key:
            # IP-based rate limiting for unauthenticated requests
            ip = request.client.host if request.client else "unknown"
            try:
                import redis.asyncio as aioredis
                redis_client = aioredis.from_url(settings.redis_url)
                minute_window = int(time.time() / 60)
                ip_key = f"ratelimit:ip:{ip}:{minute_window}"
                count = await redis_client.get(ip_key)
                current = int(count) if count else 0
                ip_limit = 60  # 60 req/min for anonymous users
                if current >= ip_limit:
                    await redis_client.aclose()
                    return JSONResponse(
                        status_code=429,
                        content={"detail": f"Rate limit exceeded ({ip_limit} req/min)"},
                        headers={"Retry-After": "60"},
                    )
                pipe = redis_client.pipeline()
                pipe.incr(ip_key)
                pipe.expire(ip_key, 120)
                await pipe.execute()
                await redis_client.aclose()
            except Exception:
                pass
            return await call_next(request)

        # Rate limit logic
        # Simple in-memory + Redis hybrid for now
        # We use a Redis set keyed by {key_hash}:{minute_window}

        try:
            from app.database import async_session
            from sqlalchemy import select
            import hashlib
            from app.models.api_key import ApiKey

            key_hash = hashlib.sha256(api_key.encode()).hexdigest()
            minute_window = int(time.time() / 60)

            # Check Redis counter
            redis_key = f"ratelimit:{key_hash}:{minute_window}"

            import redis.asyncio as aioredis
            redis_client = aioredis.from_url(settings.redis_url)

            count = await redis_client.get(redis_key)
            current = int(count) if count else 0

            # Get the API key's configured rate limit from DB
            async with async_session() as session:
                result = await session.execute(
                    select(ApiKey).where(ApiKey.key_hash == key_hash, ApiKey.is_active == True)
                )
                key_record = result.scalar_one_or_none()

            rate_limit = key_record.rate_limit if key_record else settings.api_key_default_rate_limit

            if current >= rate_limit:
                return JSONResponse(
                    status_code=429,
                    content={"detail": f"Rate limit exceeded ({rate_limit} req/min)"},
                    headers={
                        "X-RateLimit-Limit": str(rate_limit),
                        "X-RateLimit-Remaining": "0",
                        "Retry-After": "60",
                    },
                )

            # Increment counter
            pipe = redis_client.pipeline()
            pipe.incr(redis_key)
            pipe.expire(redis_key, 120)  # TTL 2 minutes
            await pipe.execute()
            await redis_client.aclose()

        except Exception:
            # If Redis/DB unavailable, skip rate limiting gracefully
            pass

        # Continue processing
        response = await call_next(request)
        return response
