"""Map visualization schemas — heatmap, distribution, corridor."""

from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class HeatmapPoint(BaseModel):
    """A single heatmap data point (lat, lng with intensity weight)."""
    lat: float
    lng: float
    weight: float = 1.0


class HeatmapResponse(BaseModel):
    """Heatmap density data for frontend rendering."""
    points: list[HeatmapPoint]
    total_points: int
    grid_resolution_deg: float  # e.g., 0.1 degrees
    bounds: dict  # {north, south, east, west}


class SpeciesDistribution(BaseModel):
    """Species distribution statistics."""
    species: str
    species_en: str
    count: int
    percentage: float


class DistributionResponse(BaseModel):
    """Species distribution response."""
    total: int
    species: list[SpeciesDistribution]


class CorridorPoint(BaseModel):
    """A point along a migration corridor."""
    lat: float
    lng: float
    density: float  # number of turtles passing through this cell


class CorridorResponse(BaseModel):
    """Migration corridor analysis for a turtle."""
    turtle_id: str
    turtle_name: str
    corridor_points: list[CorridorPoint]
    total_track_points: int
    corridor_width_km: float  # estimated corridor width
    direction: str  # "north", "south", "east", "west", "mixed"
    distance_km: float  # total distance traveled
