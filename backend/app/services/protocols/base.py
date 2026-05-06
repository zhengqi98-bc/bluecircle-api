"""Base protocol adapter — abstract class + registry."""

from abc import ABC, abstractmethod
from typing import Optional

from app.schemas.ingest import IngestPayload


class BaseProtocol(ABC):
    """Abstract protocol adapter.

    Each adapter must implement:
      - protocol_name: str (e.g. 'argos', 'spot')
      - parse(raw: str | bytes) -> list[IngestPayload]
    """

    protocol_name: str = "unknown"

    @abstractmethod
    def parse(self, raw) -> list[IngestPayload]:
        """Parse raw device data into ingest payloads."""
        ...

    def identify(self, raw) -> bool:
        """Quick check: does this raw data match this protocol?"""
        return False


class ProtocolRegistry:
    """Registry of protocol adapters."""

    _adapters: dict[str, BaseProtocol] = {}

    @classmethod
    def register(cls, adapter: BaseProtocol) -> None:
        """Register a protocol adapter."""
        cls._adapters[adapter.protocol_name] = adapter

    @classmethod
    def get(cls, name: str) -> Optional[BaseProtocol]:
        """Get a registered adapter by name."""
        return cls._adapters.get(name)

    @classmethod
    def list(cls) -> list[str]:
        """List all registered protocol names."""
        return list(cls._adapters.keys())

    @classmethod
    def detect(cls, raw) -> Optional[BaseProtocol]:
        """Auto-detect which adapter handles this data."""
        for adapter in cls._adapters.values():
            try:
                if adapter.identify(raw):
                    return adapter
            except Exception:
                continue
        return None


def get_adapter(name: str) -> Optional[BaseProtocol]:
    """Convenience: get adapter by name."""
    return ProtocolRegistry.get(name)
