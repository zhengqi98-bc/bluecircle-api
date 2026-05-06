"""WebSocket module — real-time turtle tracking via Redis Pub/Sub."""

import asyncio
import json
import random
import threading
from datetime import datetime, timezone

from fastapi import WebSocket, WebSocketDisconnect

# In-memory registry of connected clients
active_connections: dict[str, set[WebSocket]] = {}

# Redis pub/sub listener
_redis_listener_started = False
_redis_last_data: dict[str, dict] = {}  # turtle_id → last known position


def _start_redis_listener():
    """Start a background thread that listens to Redis pub/sub."""
    global _redis_listener_started
    if _redis_listener_started:
        return
    _redis_listener_started = True

    def listen():
        try:
            import redis as redis_lib
            from app.config import settings

            r = redis_lib.from_url(settings.redis_url, decode_responses=True)
            pubsub = r.pubsub()
            pubsub.subscribe("tracking:live")

            for msg in pubsub.listen():
                if msg["type"] == "message":
                    try:
                        data = json.loads(msg["data"])
                        tid = data.get("turtle_id", "")
                        _redis_last_data[tid] = data
                    except Exception:
                        pass
        except Exception:
            pass  # Redis unavailable — fall back to mock

    t = threading.Thread(target=listen, daemon=True)
    t.start()


async def ws_live_tracking(websocket: WebSocket, turtle_id: str = None):
    """WebSocket endpoint for real-time turtle position updates.

    Receives data from:
    1. Redis pub/sub (real device data via POST /api/v1/ingest/)
    2. Simulated mock data (fallback)
    """
    _start_redis_listener()
    await websocket.accept()

    tid = turtle_id or "*"
    if tid not in active_connections:
        active_connections[tid] = set()
    active_connections[tid].add(websocket)

    try:
        await websocket.send_json({
            "type": "connected",
            "turtle_id": turtle_id,
            "message": "Subscribed to live tracking (Redis + mock fallback)",
        })

        # Base positions for mock data fallback
        base_positions = {
            "BC-CD-2304": (8.71, 106.61), "BC-HD-2412": (22.55, 114.89),
            "BC-HN-2418": (19.85, 111.20), "BC-PG-2307": (-3.50, 135.42),
            "BC-PH-2311": (23.37, 119.50), "BC-PH-2425": (10.32, 118.74),
            "BC-RY-2429": (24.51, 124.18), "BC-SB-2315": (6.17, 118.04),
            "BC-XS-2401": (16.97, 112.32), "BC-XS-2421": (17.10, 112.45),
        }

        while True:
            try:
                # Priority 1: Real data from Redis
                updates = []
                for t_id, data in list(_redis_last_data.items()):
                    if turtle_id and turtle_id != t_id:
                        continue
                    updates.append({
                        "type": "position",
                        "turtle_id": t_id,
                        "lat": data.get("lat"),
                        "lng": data.get("lng"),
                        "battery_pct": data.get("battery_pct"),
                        "speed_kmh": data.get("speed_kmh"),
                        "depth_m": data.get("depth_m"),
                        "temperature_c": data.get("temperature_c"),
                        "source": data.get("source", "device"),
                        "timestamp": data.get("timestamp", datetime.now(timezone.utc).isoformat()),
                    })

                # Priority 2: Mock fallback for turtles without real data
                real_ids = set(_redis_last_data.keys())
                for t_id, (base_lat, base_lng) in base_positions.items():
                    if t_id in real_ids:
                        continue
                    if turtle_id and turtle_id != t_id:
                        continue
                    lat = base_lat + random.uniform(-0.3, 0.3)
                    lng = base_lng + random.uniform(-0.3, 0.3)
                    updates.append({
                        "type": "position",
                        "turtle_id": t_id,
                        "lat": round(lat, 6),
                        "lng": round(lng, 6),
                        "battery_pct": round(random.uniform(50, 98), 1),
                        "speed_kmh": round(random.uniform(0.1, 3.5), 2),
                        "depth_m": round(random.uniform(0, 15), 1),
                        "temperature_c": round(random.uniform(24, 30), 1),
                        "source": "mock",
                        "timestamp": datetime.now(timezone.utc).isoformat(),
                    })

                await websocket.send_json({
                    "type": "positions",
                    "count": len(updates),
                    "data": updates,
                })

                await asyncio.sleep(3)

            except WebSocketDisconnect:
                break
            except RuntimeError:
                break

    except WebSocketDisconnect:
        pass
    finally:
        if tid in active_connections:
            active_connections[tid].discard(websocket)
            if not active_connections[tid]:
                del active_connections[tid]


async def broadcast_position(turtle_id: str, lat: float, lng: float, **kwargs):
    """Broadcast a position update to all subscribed clients."""
    message = {
        "type": "position",
        "turtle_id": turtle_id,
        "lat": lat,
        "lng": lng,
        **kwargs,
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }
    for key in [turtle_id, "*"]:
        if key in active_connections:
            dead = set()
            for ws in active_connections[key]:
                try:
                    await ws.send_json(message)
                except (WebSocketDisconnect, RuntimeError):
                    dead.add(ws)
            active_connections[key] -= dead
