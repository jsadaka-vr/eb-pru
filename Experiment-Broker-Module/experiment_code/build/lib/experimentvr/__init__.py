# -*- coding: utf-8 -*-
from typing import List

from chaoslib.discovery.discover import (
    discover_actions,
    discover_probes,
    initialize_discovery_result,
)
from chaoslib.types import DiscoveredActivities, Discovery
from logzero import logger

__version__ = "0.3.35"
__all__ = ["__version__", "discover"]


def discover(discover_system: bool = True) -> Discovery:
    """Discover capabilities from this extension."""
    logger.info("Discovering capabilities from experimentvr")

    discovery = initialize_discovery_result("experimentvr", __version__, "experiment")
    discovery["activities"].extend(load_exported_activities())

    return discovery


###############################################################################
# Private functions
###############################################################################
def load_exported_activities() -> List[DiscoveredActivities]:
    """Extract metadata from actions and probes exposed by this extension."""
    activities = []

    activities.extend(discover_actions("experimentvr.s3.actions"))
    activities.extend(discover_probes("experimentvr.s3.probes"))
    activities.extend(discover_actions("experimentvr.ssm.actions"))
    activities.extend(discover_probes("experimentvr.ssm.probes"))

    return activities
