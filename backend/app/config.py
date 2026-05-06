"""Application configuration — loaded from environment variables."""

from pydantic_settings import BaseSettings
from typing import List, Optional


class Settings(BaseSettings):
    # ── App ──
    app_name: str = "Blue Circle API"
    app_version: str = "0.2.0"
    debug: bool = False
    environment: str = "development"

    # ── Database ──
    database_url: str = ""  # REQUIRED: set DATABASE_URL in .env
    database_url_sync: str = "postgresql://bluecircle:bluecircle_dev@localhost:5432/bluecircle"

    # ── Redis ──
    redis_url: str = "redis://localhost:6379/0"

    # ── CORS ──
    cors_origins: str = "https://home.maskcube.com"

    # ── JWT Auth ──
    jwt_secret: str = "bluecircle-jwt-secret-change-in-production"
    jwt_algorithm: str = "HS256"
    jwt_access_expire_minutes: int = 30
    jwt_refresh_expire_days: int = 7

    # ── API Key ──
    api_key_prefix: str = "bc_"
    api_key_default_rate_limit: int = 100  # requests per minute

    # ── Computed ──
    @property
    def cors_origin_list(self) -> List[str]:
        return [o.strip() for o in self.cors_origins.split(",") if o.strip()]

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8"}


settings = Settings()
