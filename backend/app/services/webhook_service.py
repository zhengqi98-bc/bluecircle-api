"""Webhook notification service."""

import json
import hmac
import hashlib
import httpx
from typing import Optional


async def send_webhook(
    webhook_url: str,
    payload: dict,
    secret: Optional[str] = None,
    timeout: int = 10,
) -> dict:
    """Send a webhook notification.

    Args:
        webhook_url: Target URL
        payload: JSON payload to send
        secret: Optional HMAC secret for signature header
        timeout: Request timeout in seconds

    Returns:
        dict: {success: bool, error: str|None, status_code: int|None}
    """
    if not webhook_url:
        return {"success": False, "error": "No webhook URL", "status_code": None}

    headers = {"Content-Type": "application/json", "User-Agent": "BlueCircle/1.0"}

    # Add HMAC signature if secret provided
    if secret:
        body = json.dumps(payload, ensure_ascii=False, default=str)
        sig = hmac.new(
            secret.encode("utf-8"),
            body.encode("utf-8"),
            hashlib.sha256
        ).hexdigest()
        headers["X-BlueCircle-Signature"] = f"sha256={sig}"

    try:
        async with httpx.AsyncClient(timeout=timeout) as client:
            resp = await client.post(webhook_url, json=payload, headers=headers)
            if 200 <= resp.status_code < 300:
                return {"success": True, "error": None, "status_code": resp.status_code}
            else:
                body = resp.text[:500]
                return {
                    "success": False,
                    "error": f"HTTP {resp.status_code}: {body}",
                    "status_code": resp.status_code,
                }
    except httpx.TimeoutException:
        return {"success": False, "error": "Webhook timeout", "status_code": None}
    except Exception as e:
        return {"success": False, "error": str(e)[:300], "status_code": None}


def build_webhook_payload(alert: dict) -> dict:
    """Build standard webhook payload for alert notification.

    Args:
        alert: dict with alert fields (from Alert model)

    Returns:
        dict: Standardized webhook payload
    """
    return {
        "event": "alert.created",
        "source": "bluecircle",
        "timestamp": alert.get("created_at", ""),
        "data": {
            "alert_id": alert.get("id"),
            "alert_type": alert.get("alert_type"),
            "severity": alert.get("severity"),
            "title": alert.get("title"),
            "description": alert.get("description"),
            "turtle_id": alert.get("turtle_id"),
            "lat": alert.get("lat"),
            "lng": alert.get("lng"),
            "status": alert.get("status"),
            "dashboard_url": "https://data.maskcube.com/",
        },
    }
