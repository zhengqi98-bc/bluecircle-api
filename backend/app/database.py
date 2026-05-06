"""Async SQLAlchemy engine & session factory."""

from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
from sqlalchemy.orm import DeclarativeBase
from app.config import settings

# ── Async Engine ──
engine = create_async_engine(
    settings.database_url,
    echo=settings.debug,
    pool_size=10,
    max_overflow=20,
)

# ── Session Factory ──
async_session = async_sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)


# ── Base Model ──
class Base(DeclarativeBase):
    pass


# ── Dependency: get async DB session ──
async def get_db() -> AsyncSession:
    async with async_session() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
