"""Alert scanning engine — periodic health checks on all turtles.

Detects:
  - low_battery:  battery < 20%
  - offline:      no data for > 24 hours
  - boundary:     outside known habitat area (configurable bounding boxes)
  - sst_high:     water temperature > threshold (30°C default)

Can be run via:
  - Cron job:      */15 * * * * cd /opt/bluecircle-backend && PYTHONPATH=. venv/bin/python app/services/alert_engine.py
  - Manual CLI:    python app/services/alert_engine.py
  - Background task in FastAPI lifespan
"""

import asyncio
import sys
from datetime import datetime, timezone, timedelta
from typing import Optional

from sqlalchemy import select, func, exists
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import async_session
from app.models.turtle import Turtle
from app.models.track_point import TrackPoint
from app.models.alert import Alert

# ── Thresholds ───────────────────────────────────────────────────────

LOW_BATTERY_THRESHOLD = 20.0       # %
OFFLINE_HOURS = 24                  # hours since last data
SST_HIGH_THRESHOLD = 30.0          # °C
BOUNDARY_CHECK_ENABLED = True

# Known habitat bounding boxes (approximate):
# Each: (name, min_lat, max_lat, min_lng, max_lng)
HABITAT_ZONES = [
    ("South China Sea", 5.0, 25.0, 105.0, 125.0),
    ("Sulu Sea", 5.0, 12.0, 117.0, 123.0),
    ("Coral Triangle", -10.0, 10.0, 115.0, 150.0),
    ("Western Pacific", 20.0, 35.0, 120.0, 150.0),
]
BOUNDARY_BUFFER_DEG = 2.0  # Allow some buffer outside known zones


# ── Detection functions ──────────────────────────────────────────────

async def check_low_battery(db: AsyncSession) -> list[dict]:
    """Find turtles with low battery and no existing open low_battery alert."""
    # Get turtles with low battery
    result = await db.execute(
        select(Turtle).where(
            Turtle.is_active == True,  # noqa: E712
            Turtle.last_battery_pct.isnot(None),
            Turtle.last_battery_pct < LOW_BATTERY_THRESHOLD,
        )
    )
    turtles = result.scalars().all()

    alerts_created = []
    for t in turtles:
        # Check if already has an open low_battery alert
        existing = await db.execute(
            select(exists().where(
                Alert.turtle_id == t.id,
                Alert.alert_type == "low_battery",
                Alert.status == "open",
            ))
        )
        if existing.scalar():
            continue

        bat = float(t.last_battery_pct)
        lat = float(t.last_lat) if t.last_lat else None
        lng = float(t.last_lng) if t.last_lng else None

        alert = Alert(
            turtle_id=t.id,
            alert_type="low_battery",
            severity="high" if bat < 10 else "medium",
            title=f"电池电量低: {t.name} ({bat:.0f}%)",
            description=f"海龟 {t.name}（{t.species}）设备电量仅剩 {bat:.0f}%，已低于安全阈值 {LOW_BATTERY_THRESHOLD:.0f}%。请尽快安排设备回收或更换。",
            lat=lat,
            lng=lng,
        )
        db.add(alert)
        await db.flush()
        alerts_created.append({
            "turtle_id": t.id, "turtle_name": t.name,
            "alert_type": "low_battery", "severity": alert.severity,
            "value": bat, "alert_id": alert.id,
        })

    return alerts_created


async def check_offline(db: AsyncSession) -> list[dict]:
    """Find turtles that haven't sent data in OFFLINE_HOURS hours."""
    cutoff = datetime.now(timezone.utc) - timedelta(hours=OFFLINE_HOURS)

    result = await db.execute(
        select(Turtle).where(
            Turtle.is_active == True,  # noqa: E712
            Turtle.last_seen_at.isnot(None),
            Turtle.last_seen_at < cutoff,
        )
    )
    turtles = result.scalars().all()

    alerts_created = []
    for t in turtles:
        existing = await db.execute(
            select(exists().where(
                Alert.turtle_id == t.id,
                Alert.alert_type == "offline",
                Alert.status == "open",
            ))
        )
        if existing.scalar():
            continue

        hours_offline = int((datetime.now(timezone.utc) - t.last_seen_at.replace(tzinfo=timezone.utc)).total_seconds() / 3600)

        alert = Alert(
            turtle_id=t.id,
            alert_type="offline",
            severity="critical" if hours_offline > 72 else "high",
            title=f"设备离线: {t.name}",
            description=f"海龟 {t.name}（{t.species}）已离线 {hours_offline} 小时（超过 {OFFLINE_HOURS}h 阈值）。最后信号: {t.last_seen_at.strftime('%Y-%m-%d %H:%M UTC')}。",
            lat=float(t.last_lat) if t.last_lat else None,
            lng=float(t.last_lng) if t.last_lng else None,
        )
        db.add(alert)
        alerts_created.append({
            "turtle_id": t.id, "turtle_name": t.name,
            "alert_type": "offline", "severity": alert.severity,
            "value":            hours_offline, "alert_id": alert.id,
        })

    return alerts_created


async def check_boundary(db: AsyncSession) -> list[dict]:
    """Find turtles outside known habitat zones."""
    if not BOUNDARY_CHECK_ENABLED:
        return []

    result = await db.execute(
        select(Turtle).where(
            Turtle.is_active == True,  # noqa: E712
            Turtle.last_lat.isnot(None),
            Turtle.last_lng.isnot(None),
        )
    )
    turtles = result.scalars().all()

    alerts_created = []
    for t in turtles:
        lat = float(t.last_lat)
        lng = float(t.last_lng)

        # Check if inside any known habitat zone (with buffer)
        in_zone = False
        for name, min_lat, max_lat, min_lng, max_lng in HABITAT_ZONES:
            if (min_lat - BOUNDARY_BUFFER_DEG <= lat <= max_lat + BOUNDARY_BUFFER_DEG and
                min_lng - BOUNDARY_BUFFER_DEG <= lng <= max_lng + BOUNDARY_BUFFER_DEG):
                in_zone = True
                break

        if in_zone:
            continue

        # Check if already has open boundary alert
        existing = await db.execute(
            select(exists().where(
                Alert.turtle_id == t.id,
                Alert.alert_type == "boundary",
                Alert.status == "open",
            ))
        )
        if existing.scalar():
            continue

        alert = Alert(
            turtle_id=t.id,
            alert_type="boundary",
            severity="medium",
            title=f"越界警告: {t.name}",
            description=f"海龟 {t.name}（{t.species}）当前位置 ({lat:.2f}, {lng:.2f}) 超出已知栖息地范围。可能正在进行长距离迁徙或设备漂移，请核实。",
            lat=lat,
            lng=lng,
        )
        db.add(alert)
        alerts_created.append({
            "turtle_id": t.id, "turtle_name": t.name,
            "alert_type": "boundary", "severity": alert.severity,
            "value":            f"({lat:.2f}, {lng:.2f})", "alert_id": alert.id,
        })

    return alerts_created


async def check_sst_high(db: AsyncSession) -> list[dict]:
    """Find turtles in high water temperature areas."""
    # Get recent track points with temperature data
    cutoff = datetime.now(timezone.utc) - timedelta(hours=24)
    result = await db.execute(
        select(TrackPoint).where(
            TrackPoint.time >= cutoff,
            TrackPoint.temperature_c.isnot(None),
            TrackPoint.temperature_c > SST_HIGH_THRESHOLD,
        ).order_by(TrackPoint.turtle_id)
    )
    points = result.scalars().all()

    # Group by turtle (deduplicate)
    turtle_temps = {}
    for p in points:
        if p.turtle_id not in turtle_temps:
            turtle_temps[p.turtle_id] = float(p.temperature_c)

    alerts_created = []
    for turtle_id, temp in turtle_temps.items():
        existing = await db.execute(
            select(exists().where(
                Alert.turtle_id == turtle_id,
                Alert.alert_type == "sst_high",
                Alert.status == "open",
            ))
        )
        if existing.scalar():
            continue

        # Get turtle info
        t_result = await db.execute(select(Turtle).where(Turtle.id == turtle_id))
        turtle = t_result.scalar()
        if not turtle or not turtle.is_active:
            continue

        severity = "critical" if temp > 33 else ("high" if temp > 31 else "medium")

        alert = Alert(
            turtle_id=turtle_id,
            alert_type="sst_high",
            severity=severity,
            title=f"SST 高温警告: {turtle.name}",
            description=f"海龟 {turtle.name}（{turtle.species}）所处海域表层水温 {temp:.1f}°C，已超过安全阈值 {SST_HIGH_THRESHOLD}°C。高温可能导致珊瑚白化、海草减少，影响海龟觅食。",
            lat=float(turtle.last_lat) if turtle.last_lat else None,
            lng=float(turtle.last_lng) if turtle.last_lng else None,
        )
        db.add(alert)
        alerts_created.append({
            "turtle_id": turtle_id, "turtle_name": turtle.name,
            "alert_type": "sst_high", "severity": alert.severity,
            "value":            temp, "alert_id": alert.id,
        })

    return alerts_created


# ── Main scanner ─────────────────────────────────────────────────────

async def scan_all(db: AsyncSession) -> dict:
    """Run all alert checks and create alerts.

    Returns:
        dict: Summary of alerts created per check type.
    """
    from app.services.notification_engine import dispatch_notifications

    results = {}

    checks = [
        ("low_battery", check_low_battery),
        ("offline", check_offline),
        ("boundary", check_boundary),
        ("sst_high", check_sst_high),
    ]

    total = 0
    new_alert_ids = []
    for check_name, check_fn in checks:
        try:
            alerts = await check_fn(db)
            results[check_name] = len(alerts)
            total += len(alerts)
            for a in alerts:
                alert_id = a.get("alert_id")
                if alert_id:
                    new_alert_ids.append(alert_id)
                print(f"  [{a['severity'].upper()}] {a['alert_type']}: {a['turtle_name']} ({a['turtle_id']}) — {a['value']}")
        except Exception as e:
            results[check_name] = f"ERROR: {str(e)[:100]}"
            print(f"  ERROR in {check_name}: {e}", file=sys.stderr)

    await db.flush()

    # Dispatch notifications for each new alert
    notified = 0
    for aid in new_alert_ids:
        try:
            result = await dispatch_notifications(db, aid)
            if result.get("dispatched", 0) > 0:
                notified += 1
        except Exception as e:
            print(f"  Notification error for alert {aid}: {e}", file=sys.stderr)

    return {"checks": results, "total_alerts": total, "notified": notified}


# ── CLI entry point ─────────────────────────────────────────────────

async def _main():
    """CLI entry point for manual/scheduled scanning."""
    start_time = datetime.now(timezone.utc)
    print(f"[{start_time.isoformat()}] Alert scanner started", file=sys.stderr)

    async with async_session() as db:
        try:
            result = await scan_all(db)
            await db.commit()

            elapsed = (datetime.now(timezone.utc) - start_time).total_seconds()
            print(
                f"[{datetime.now(timezone.utc).isoformat()}] Alert scan complete: "
                f"{result['checks']} — total {result['total_alerts']} new alerts, "
                f"{elapsed:.1f}s",
                file=sys.stderr,
            )
        except Exception as e:
            await db.rollback()
            print(f"FATAL: {e}", file=sys.stderr)
            sys.exit(1)


if __name__ == "__main__":
    asyncio.run(_main())
