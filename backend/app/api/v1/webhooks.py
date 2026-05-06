"""Webhook endpoints for device data reception.

Devices can POST data directly to webhook URLs instead of using the
generic /api/v1/ingest/ endpoint. These endpoints auto-detect the
protocol from the data format.

Endpoints:
  POST /api/v1/ingest/webhook         — Auto-detect protocol
  POST /api/v1/ingest/webhook/argos   — Argos-specific
  POST /api/v1/ingest/webhook/spot    — SPOT-specific
"""

from fastapi import APIRouter, Depends, Request, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import get_db
from app.auth.dependencies import get_api_key
from app.schemas.ingest import IngestResponse
from app.services.ingest import process_ingest
from app.services.protocols import get_adapter, ProtocolRegistry

router = APIRouter(prefix="/ingest/webhook", tags=["Webhooks"])


async def _read_body(request: Request) -> str:
    """Read raw request body as string."""
    try:
        return (await request.body()).decode("utf-8", errors="ignore")
    except Exception:
        return ""


@router.post("", response_model=IngestResponse)
async def webhook_auto_detect(
    request: Request,
    db: AsyncSession = Depends(get_db),
    _api: dict = Depends(get_api_key),
):
    """Receive device data via webhook — auto-detect protocol.

    Accepts raw body from any device (Argos DS, SPOT XML/JSON, etc.).
    Auto-detects the protocol adapter and processes the data.
    """
    raw = await _read_body(request)
    if not raw:
        raise HTTPException(status_code=400, detail="Empty body")

    # Try auto-detect
    adapter = ProtocolRegistry.detect(raw)
    if not adapter:
        raise HTTPException(
            status_code=400,
            detail=f"Could not detect protocol. Supported: {ProtocolRegistry.list()}",
        )

    payloads = adapter.parse(raw)
    if not payloads:
        return IngestResponse(accepted=0, rejected=0, duplicates=0, errors=[])

    return await process_ingest(db, payloads)


@router.post("/argos", response_model=IngestResponse)
async def webhook_argos(
    request: Request,
    db: AsyncSession = Depends(get_db),
    _api: dict = Depends(get_api_key),
):
    """Receive Argos satellite data via webhook.

    Accepts:
      - Argos DS format (CSV text)
      - Argos Web JSON format
    """
    raw = await _read_body(request)
    if not raw:
        raise HTTPException(status_code=400, detail="Empty body")

    adapter = get_adapter("argos")
    if not adapter:
        raise HTTPException(status_code=500, detail="Argos adapter not available")

    payloads = adapter.parse(raw)
    if not payloads:
        return IngestResponse(accepted=0, rejected=0, duplicates=0, errors=[])

    return await process_ingest(db, payloads)


@router.post("/spot", response_model=IngestResponse)
async def webhook_spot(
    request: Request,
    db: AsyncSession = Depends(get_db),
    _api: dict = Depends(get_api_key),
):
    """Receive SPOT device data via webhook.

    Accepts:
      - SPOT XML format
      - SPOT JSON format
    """
    raw = await _read_body(request)
    if not raw:
        raise HTTPException(status_code=400, detail="Empty body")

    adapter = get_adapter("spot")
    if not adapter:
        raise HTTPException(status_code=500, detail="Spot adapter not available")

    payloads = adapter.parse(raw)
    if not payloads:
        return IngestResponse(accepted=0, rejected=0, duplicates=0, errors=[])

    return await process_ingest(db, payloads)
