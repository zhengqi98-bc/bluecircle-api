"""Notification engine — dispatch notifications when alerts are created.

This is called by the alert creation endpoint (or scheduled scanner in Task G)
to check matching notification rules and send alerts.
"""

from typing import Optional
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.notification import NotificationRule, NotificationLog
from app.models.alert import Alert
from app.models.turtle import Turtle
from app.services.email_service import send_email, build_alert_email_html
from app.services.webhook_service import send_webhook, build_webhook_payload
from app.services.sms_service import send_sms


async def dispatch_notifications(
    db: AsyncSession,
    alert_id: int,
) -> dict:
    """Check notification rules and dispatch alerts.

    Called whenever a new alert is created.

    Returns:
        dict: {rules_matched: int, dispatched: int, failed: int, logs: list}
    """
    # Fetch the alert
    alert_result = await db.execute(select(Alert).where(Alert.id == alert_id))
    alert = alert_result.scalar()
    if not alert:
        return {"rules_matched": 0, "dispatched": 0, "failed": 0, "logs": []}

    # Fetch matching notification rules
    rules_q = select(NotificationRule).where(
        NotificationRule.is_active == True  # noqa: E712
    )

    # Filter by alert type
    # Rules with alert_types=None match ALL types
    # Rules with specific types only match those
    rules_result = await db.execute(rules_q)
    all_rules = rules_result.scalars().all()

    matching_rules = []
    for rule in all_rules:
        # Alert type filter
        if rule.alert_types and alert.alert_type not in rule.alert_types:
            continue

        # Severity filter (order: critical > high > medium > low)
        sev_order = {"low": 0, "medium": 1, "high": 2, "critical": 3}
        if sev_order.get(alert.severity, 0) < sev_order.get(rule.severity_min, 0):
            continue

        # Turtle filter
        if rule.turtle_id and rule.turtle_id != alert.turtle_id:
            continue

        matching_rules.append(rule)

    # Dispatch notifications
    dispatched = 0
    failed = 0
    logs = []

    for rule in matching_rules:
        # Build alert info for notification content
        alert_info = {
            "id": alert.id,
            "alert_type": alert.alert_type,
            "severity": alert.severity,
            "title": alert.title,
            "description": alert.description,
            "turtle_id": alert.turtle_id,
            "lat": float(alert.lat) if alert.lat else None,
            "lng": float(alert.lng) if alert.lng else None,
            "status": alert.status,
            "created_at": alert.created_at.isoformat() if alert.created_at else "",
        }

        # Get turtle name if available
        turtle_name = None
        if alert.turtle_id:
            t_result = await db.execute(select(Turtle).where(Turtle.id == alert.turtle_id))
            turtle = t_result.scalar()
            if turtle:
                turtle_name = turtle.name

        # ── Email ──
        if rule.email_enabled and rule.email_recipients:
            html = build_alert_email_html(
                alert_type=alert.alert_type,
                severity=alert.severity,
                title=alert.title,
                description=alert.description or "",
                turtle_id=alert.turtle_id,
                turtle_name=turtle_name,
                lat=float(alert.lat) if alert.lat else None,
                lng=float(alert.lng) if alert.lng else None,
            )
            result = await send_email(
                to_emails=rule.email_recipients,
                subject=f"[{alert.severity.upper()}] {alert.title}",
                body_html=html,
            )
            log_entry = await _log_dispatch(
                db, rule.id, alert.id, "email",
                ", ".join(rule.email_recipients),
                alert.title, result
            )
            logs.append(log_entry)
            if result["success"]:
                dispatched += 1
            else:
                failed += 1

        # ── Webhook ──
        if rule.webhook_enabled and rule.webhook_url:
            payload = build_webhook_payload(alert_info)
            result = await send_webhook(
                webhook_url=rule.webhook_url,
                payload=payload,
                secret=rule.webhook_secret,
            )
            log_entry = await _log_dispatch(
                db, rule.id, alert.id, "webhook",
                rule.webhook_url, alert.title, result
            )
            logs.append(log_entry)
            if result["success"]:
                dispatched += 1
            else:
                failed += 1

        # ── SMS ──
        if rule.sms_enabled and rule.sms_recipients:
            sms_text = f"[Blue Circle {alert.severity.upper()}] {alert.title}"
            if alert.turtle_id:
                sms_text += f" - Turtle: {alert.turtle_id}"
            result = await send_sms(rule.sms_recipients, sms_text)
            log_entry = await _log_dispatch(
                db, rule.id, alert.id, "sms",
                ", ".join(rule.sms_recipients),
                alert.title, result
            )
            logs.append(log_entry)
            if result["success"]:
                dispatched += 1
            else:
                failed += 1

    return {
        "rules_matched": len(matching_rules),
        "dispatched": dispatched,
        "failed": failed,
        "logs": logs,
    }


async def _log_dispatch(
    db: AsyncSession,
    rule_id: int,
    alert_id: int,
    channel: str,
    recipient: str,
    subject: Optional[str],
    result: dict,
) -> dict:
    """Log a notification dispatch attempt."""
    entry = NotificationLog(
        rule_id=rule_id,
        alert_id=alert_id,
        channel=channel,
        status="sent" if result.get("success") else "failed",
        recipient=recipient[:255],
        subject=subject[:255] if subject else None,
        error_message=result.get("error"),
    )
    db.add(entry)
    await db.flush()
    return {
        "log_id": entry.id,
        "channel": channel,
        "status": entry.status,
        "recipient": entry.recipient,
        "error": entry.error_message,
    }
