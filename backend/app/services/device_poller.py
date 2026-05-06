"""Device polling service — periodically fetches data from registered devices.

This service runs in the background (via systemd timer or cron) and:
  1. Queries the hardware_applications table for active/shipped devices
  2. For each device, calls the appropriate protocol adapter
  3. Feeds parsed data into the ingest pipeline

Run modes:
  - Poll ALL active devices:  device_poller.py --all
  - Poll specific device:     device_poller.py --device-id 5
  - Poll by protocol:         device_poller.py --protocol argos

Can be called via:
  - Cron job (every 15 min): */15 * * * * cd /opt/bluecircle-backend && PYTHONPATH=. venv/bin/python app/services/device_poller.py --all
  - Systemd timer
  - Manual CLI
"""

import asyncio
import sys
from datetime import datetime, timezone
from typing import Optional

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import async_session
from app.models.hardware import HardwareApplication
from app.services.ingest import process_ingest
from app.services.protocols import get_adapter
from app.schemas.ingest import IngestPayload


async def poll_device(
    db: AsyncSession,
    device: HardwareApplication,
) -> dict:
    """Poll a single device for new data.

    Returns:
        dict with keys: device_id, status, points_accepted, points_duplicate, errors
    """
    result = {
        "device_id": device.id,
        "device_type": device.device_type,
        "protocol": device.device_type,
        "status": "skipped",
        "points_accepted": 0,
        "points_duplicate": 0,
        "errors": [],
    }

    # Map device_type to protocol name
    protocol_name = _device_to_protocol(device.device_type)
    if not protocol_name:
        result["status"] = "unsupported"
        result["errors"].append(f"No adapter for device_type: {device.device_type}")
        return result

    adapter = get_adapter(protocol_name)
    if not adapter:
        result["status"] = "no_adapter"
        result["errors"].append(f"Adapter {protocol_name} not registered")
        return result

    # Fetch data from device (simulated for now — real impl would call Argos API / SPOT API)
    raw_data = await _fetch_device_data(device)
    if not raw_data:
        result["status"] = "no_data"
        return result

    # Parse through protocol adapter
    try:
        payloads = adapter.parse(raw_data)
    except Exception as e:
        result["status"] = "parse_error"
        result["errors"].append(str(e)[:200])
        return result

    if not payloads:
        result["status"] = "empty"
        return result

    # Feed into ingest pipeline
    try:
        ingest_result = await process_ingest(db, payloads)
        result["status"] = "ok"
        result["points_accepted"] = ingest_result.accepted
        result["points_duplicate"] = ingest_result.duplicates
        result["errors"].extend(ingest_result.errors)
    except Exception as e:
        result["status"] = "ingest_error"
        result["errors"].append(str(e)[:200])

    return result


async def poll_all_devices(db: AsyncSession) -> list[dict]:
    """Poll all active/shipped devices."""
    stmt = (
        select(HardwareApplication)
        .where(HardwareApplication.status.in_(["shipped", "approved"]))
        .order_by(HardwareApplication.id)
    )
    result = await db.execute(stmt)
    devices = result.scalars().all()

    results = []
    for device in devices:
        r = await poll_device(db, device)
        results.append(r)
        if r["errors"]:
            print(f"  [{device.id}] {device.device_type}: {r['status']} — "
                  f"accepted={r['points_accepted']}, errors={r['errors']}", file=sys.stderr)

    return results


async def poll_by_device_id(db: AsyncSession, device_id: int) -> dict:
    """Poll a specific device by ID."""
    stmt = select(HardwareApplication).where(HardwareApplication.id == device_id)
    result = await db.execute(stmt)
    device = result.scalar()
    if not device:
        return {"status": "not_found", "errors": [f"Device {device_id} not found"]}
    return await poll_device(db, device)


# ── Helpers ─────────────────────────────────────────────────────────

def _device_to_protocol(device_type: str) -> Optional[str]:
    """Map device_type to protocol adapter name."""
    mapping = {
        "satellite_tag": "argos",
        "gps_tag": "spot",
        "argos": "argos",
        "spot": "spot",
        "depth_sensor": "spot",   # Often bundled with SPOT
        "temp_sensor": "argos",   # Often bundled with Argos tags
    }
    return mapping.get(device_type)


async def _fetch_device_data(device: HardwareApplication) -> Optional[str]:
    """Fetch raw data from a device.

    This is a PLACEHOLDER. In production, this would:
      - Argos: call ArgosWeb API or check email/FTP for new DS files
      - SPOT:  call SPOT API with device credentials

    For now, returns None (no data to fetch) — real data comes via webhooks.
    """
    # TODO: Implement actual device API calls
    # Argos: GET https://api.argos-system.com/... with API key
    # SPOT:  GET https://api.findmespot.com/spot-main-web/consumer/rest/...
    return None


# ── CLI entry point ─────────────────────────────────────────────────

async def _main():
    """CLI entry point for manual/scheduled polling."""
    import argparse
    parser = argparse.ArgumentParser(description="Device poller for Blue Circle")
    parser.add_argument("--all", action="store_true", help="Poll all active devices")
    parser.add_argument("--device-id", type=int, help="Poll specific device by ID")
    parser.add_argument("--protocol", type=str, help="Filter by protocol (argos/spot)")
    args = parser.parse_args()

    start_time = datetime.now(timezone.utc)
    print(f"[{start_time.isoformat()}] Device poller started", file=sys.stderr)

    async with async_session() as db:
        try:
            if args.device_id:
                results = [await poll_by_device_id(db, args.device_id)]
            else:
                results = await poll_all_devices(db)
                if args.protocol:
                    results = [r for r in results if r.get("protocol") == args.protocol]

            # Summary
            total = len(results)
            ok = sum(1 for r in results if r["status"] == "ok")
            accepted = sum(r["points_accepted"] for r in results)
            dups = sum(r["points_duplicate"] for r in results)
            errors = sum(1 for r in results if r["errors"])

            elapsed = (datetime.now(timezone.utc) - start_time).total_seconds()
            print(
                f"[{datetime.now(timezone.utc).isoformat()}] Done: "
                f"{total} devices, {ok} ok, {accepted} points accepted, "
                f"{dups} duplicates, {errors} with errors, "
                f"{elapsed:.1f}s",
                file=sys.stderr,
            )

        except Exception as e:
            print(f"FATAL: {e}", file=sys.stderr)
            sys.exit(1)


if __name__ == "__main__":
    asyncio.run(_main())
