"""Redis-based API response cache middleware (ASGI-compatible).

Caches GET responses in Redis with configurable TTL.
Bypasses cache for authenticated requests.
"""

import hashlib
import json
from typing import Optional

from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import Response

from app.config import settings


class CacheMiddleware(BaseHTTPMiddleware):
    """Redis-backed response cache for GET requests (ASGI)."""

    def __init__(
        self,
        app,
        ttl: int = 60,
        exclude_paths: Optional[list[str]] = None,
        cache_prefix: str = "bc:cache:",
    ):
        super().__init__(app)
        self.ttl = ttl
        self.exclude_paths = exclude_paths or [
            "/api/v1/admin",
            "/api/v1/auth",
            "/api/v1/keys",
            "/api/v1/ingest",
            "/api/v1/notifications",
            "/api/v1/reports/export",
        ]
        self.cache_prefix = cache_prefix
        self._redis = None

    def _get_redis(self):
        """Lazy-init Redis connection."""
        if self._redis is not None:
            return self._redis
        try:
            import redis as redis_lib
            self._redis = redis_lib.from_url(settings.redis_url, decode_responses=False)
            self._redis.ping()
        except Exception:
            self._redis = False
        return self._redis

    def _should_cache(self, request: Request) -> bool:
        if request.method != "GET":
            return False
        if request.headers.get("Authorization"):
            return False
        path = request.url.path
        for ex in self.exclude_paths:
            if path.startswith(ex):
                return False
        return True

    async def dispatch(self, request: Request, call_next):
        """ASGI dispatch — called by BaseHTTPMiddleware for each request."""
        if not self._should_cache(request):
            return await call_next(request)

        redis = self._get_redis()
        if not redis:
            return await call_next(request)

        cache_key = self.cache_prefix + hashlib.md5(
            (request.url.path + "?" + request.url.query).encode()
        ).hexdigest() if request.url.query else self.cache_prefix + hashlib.md5(
            request.url.path.encode()
        ).hexdigest()

        # Try cache hit
        try:
            cached = redis.get(cache_key)
            if cached:
                data = json.loads(cached)
                return Response(
                    content=data["body"].encode("utf-8"),
                    status_code=data["status"],
                    headers=dict(data.get("headers", {})),
                    media_type=data.get("media_type", "application/json"),
                )
        except Exception:
            pass

        # Cache miss — forward request
        response = await call_next(request)

        # Store 2xx responses in cache
        if 200 <= response.status_code < 300:
            try:
                body = b""
                async for chunk in response.body_iterator:
                    body += chunk

                redis.setex(cache_key, self.ttl, json.dumps({
                    "body": body.decode("utf-8", errors="replace"),
                    "status": response.status_code,
                    "headers": dict(response.headers),
                    "media_type": response.media_type or "application/json",
                }))

                return Response(
                    content=body,
                    status_code=response.status_code,
                    headers=dict(response.headers),
                    media_type=response.media_type or "application/json",
                )
            except Exception:
                pass

        return response
