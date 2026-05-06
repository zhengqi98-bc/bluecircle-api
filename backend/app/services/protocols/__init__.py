"""Protocol adapters for real tracking device data.

Supported protocols:
  - argos  — Argos satellite system (DS format)
  - spot   — SPOT GPS messenger (XML/JSON webhook)
  - custom — Generic JSON/CSV adapter

Each adapter converts raw device messages into IngestPayload objects
that feed into the existing ingest pipeline.
"""

from app.services.protocols.base import BaseProtocol, ProtocolRegistry, get_adapter
from app.services.protocols.argos import ArgosAdapter
from app.services.protocols.spot import SpotAdapter

__all__ = [
    "BaseProtocol",
    "ProtocolRegistry",
    "get_adapter",
    "ArgosAdapter",
    "SpotAdapter",
]
