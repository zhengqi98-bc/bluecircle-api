"""Notification API — rule management and log viewing."""

from fastapi import APIRouter, Depends, Query, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, func, desc

from app.database import get_db
from app.auth.dependencies import require_user, require_admin
from app.models.user import User
from app.models.notification import NotificationRule, NotificationLog
from app.schemas.notification import (
    NotificationRuleCreate, NotificationRuleUpdate,
    NotificationRuleOut, NotificationRuleListOut,
    NotificationLogOut, NotificationLogListOut,
    TestNotificationRequest,
)
from app.services.email_service import send_email, build_alert_email_html
from app.services.webhook_service import send_webhook, build_webhook_payload
from app.services.sms_service import send_sms

router = APIRouter(prefix="/notifications", tags=["Notifications"])


# ── Rules CRUD ───────────────────────────────────────────────────────

@router.get("/rules", response_model=NotificationRuleListOut)
async def list_rules(
    is_active: bool = Query(None),
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: AsyncSession = Depends(get_db),
):
    """List notification rules."""
    q = select(NotificationRule)
    if is_active is not None:
        q = q.where(NotificationRule.is_active == is_active)

    count_q = select(func.count()).select_from(q.subquery())
    total = (await db.execute(count_q)).scalar() or 0

    q = q.order_by(desc(NotificationRule.created_at)).offset(offset).limit(limit)
    result = await db.execute(q)
    rules = result.scalars().all()

    return NotificationRuleListOut(
        items=[NotificationRuleOut.model_validate(r) for r in rules],
        total=total,
    )


@router.post("/rules", response_model=NotificationRuleOut, status_code=201)
async def create_rule(
    body: NotificationRuleCreate,
    db: AsyncSession = Depends(get_db),
):
    """Create a notification rule."""
    rule = NotificationRule(
        name=body.name,
        description=body.description,
        alert_types=body.alert_types,
        severity_min=body.severity_min,
        turtle_id=body.turtle_id,
        email_enabled=body.email_enabled,
        email_recipients=body.email_recipients,
        webhook_enabled=body.webhook_enabled,
        webhook_url=body.webhook_url,
        webhook_secret=body.webhook_secret,
        sms_enabled=body.sms_enabled,
        sms_recipients=body.sms_recipients,
        is_active=body.is_active,
    )
    db.add(rule)
    await db.flush()
    await db.refresh(rule)
    return NotificationRuleOut.model_validate(rule)


@router.get("/rules/{rule_id}", response_model=NotificationRuleOut)
async def get_rule(rule_id: int, db: AsyncSession = Depends(get_db)):
    """Get a notification rule by ID."""
    rule = await db.get(NotificationRule, rule_id)
    if not rule:
        raise HTTPException(status_code=404, detail="Notification rule not found")
    return NotificationRuleOut.model_validate(rule)


@router.patch("/rules/{rule_id}", response_model=NotificationRuleOut)
async def update_rule(
    rule_id: int,
    body: NotificationRuleUpdate,
    db: AsyncSession = Depends(get_db),
):
    """Update a notification rule."""
    rule = await db.get(NotificationRule, rule_id)
    if not rule:
        raise HTTPException(status_code=404, detail="Notification rule not found")

    update_data = body.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(rule, key, value)

    await db.flush()
    await db.refresh(rule)
    return NotificationRuleOut.model_validate(rule)


@router.delete("/rules/{rule_id}", status_code=204)
async def delete_rule(rule_id: int, db: AsyncSession = Depends(get_db)):
    """Delete a notification rule."""
    rule = await db.get(NotificationRule, rule_id)
    if not rule:
        raise HTTPException(status_code=404, detail="Notification rule not found")
    await db.delete(rule)
    await db.flush()


# ── Test notification ─────────────────────────────────────────────────

@router.post("/test")
async def test_notification(
    body: TestNotificationRequest,
    db: AsyncSession = Depends(get_db),
    _admin: User = Depends(require_admin),
):
    """Send a test notification through a specific rule and channel."""
    rule = await db.get(NotificationRule, body.rule_id)
    if not rule:
        raise HTTPException(status_code=404, detail="Notification rule not found")

    channel = body.channel
    result = None

    if channel == "email" and rule.email_enabled and rule.email_recipients:
        html = build_alert_email_html(
            alert_type="test",
            severity="low",
            title="[TEST] 通知测试",
            description="这是一条来自 Blue Circle 的测试通知。如果您收到此消息，说明通知系统配置正确。",
        )
        result = await send_email(
            to_emails=rule.email_recipients,
            subject="通知测试",
            body_html=html,
        )

    elif channel == "webhook" and rule.webhook_enabled and rule.webhook_url:
        payload = build_webhook_payload({
            "id": 0, "alert_type": "test", "severity": "low",
            "title": "[TEST] Notification Test",
            "description": "This is a test webhook from Blue Circle.",
            "turtle_id": None, "lat": None, "lng": None,
            "status": "open", "created_at": "",
        })
        result = await send_webhook(
            webhook_url=rule.webhook_url,
            payload=payload,
            secret=rule.webhook_secret,
        )

    elif channel == "sms" and rule.sms_enabled and rule.sms_recipients:
        result = await send_sms(
            phone_numbers=rule.sms_recipients,
            message="[Blue Circle TEST] 通知系统测试。如果您收到此消息，说明SMS配置正确。",
        )

    else:
        raise HTTPException(
            status_code=400,
            detail=f"Channel '{channel}' is not enabled for rule {body.rule_id}"
        )

    return {
        "rule_id": body.rule_id,
        "channel": channel,
        "success": result["success"] if result else False,
        "error": result.get("error") if result else "Unknown error",
    }


# ── Logs ─────────────────────────────────────────────────────────────

@router.get("/logs", response_model=NotificationLogListOut)
async def list_logs(
    limit: int = Query(50, ge=1, le=200),
    offset: int = Query(0, ge=0),
    db: AsyncSession = Depends(get_db),
):
    """List notification logs."""
    count = (await db.execute(select(func.count()).select_from(NotificationLog))).scalar() or 0

    q = select(NotificationLog).order_by(desc(NotificationLog.sent_at)).offset(offset).limit(limit)
    result = await db.execute(q)
    logs = result.scalars().all()

    return NotificationLogListOut(
        items=[NotificationLogOut.model_validate(l) for l in logs],
        total=count,
    )
