"""Data Ingestion API — /api/v1/ingest"""

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.schemas.ingest import IngestPayload, IngestBatch, IngestResponse
from app.services.ingest import process_ingest
from app.auth.dependencies import get_api_key

router = APIRouter(prefix="/ingest", tags=["Data Ingestion"])


@router.post("/", response_model=IngestResponse)
async def ingest_data(
    body: IngestBatch,
    db: AsyncSession = Depends(get_db),
    _api_key: dict = Depends(get_api_key),
):
    """Ingest tracking data from devices. Requires API key.

    Accepts up to 100 points per request. Each point is validated,
    deduplicated, stored, and pushed to live WebSocket subscribers.
    """
    return await process_ingest(db, body.points)


@router.post("/single", response_model=IngestResponse)
async def ingest_single(
    body: IngestPayload,
    db: AsyncSession = Depends(get_db),
    _api_key: dict = Depends(get_api_key),
):
    """Ingest a single tracking data point (convenience endpoint)."""
    return await process_ingest(db, [body])
