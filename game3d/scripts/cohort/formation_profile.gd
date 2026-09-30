class_name FormationProfile
extends RefCounted

## A FORMATION PROFILE — the shape a mobile cohort's slots take round its anchor
## (D-398).
##
## ============================================================================
## ONE PROFILE EXISTS: THE VANGUARD, FOR THE ONE ROLE THAT EXISTS: MELEE.
## ============================================================================
## The owner: "Kindred Hounds use a Vanguard profile biased toward the player's
## movement direction and flanks, reducing the likelihood that the player
## consistently enters danger first." And: "Do not implement Ranged or Support
## minion production behaviour; leave clear extension points but no unused
## speculative branches."
##
## THE EXTENSION POINT IS THIS TYPE AND THE `Role` ENUM -- nothing else. A later,
## separately authorized stage that brings a ranged or support minion adds its
## role and a builder that returns its profile. NO such role, builder, branch or
## behaviour exists here, and the D-398 suite scans for one.
##
## A profile is DATA. The geometry lives in `CohortFormation`, which is pure.

enum Role { MELEE }

var role: int = Role.MELEE
var profile_name: String = ""
## Degrees either side of her travel direction that hold NO slot -- her lane.
var lane_half_deg: float = 0.0
## The first ring's reach, in degrees either side of her travel direction.
var arc_half_deg: float = 0.0
## Each further ring reaches this much further round her ...
var arc_widen_deg: float = 0.0
## ... up to this.
var arc_max_deg: float = 0.0
## Rings this far apart, slots this far apart along a ring (arc length).
var ring_step_m: float = 0.0
var spacing_m: float = 0.0
## The fixed, deterministic looseness of every slot.
var jitter_tangent_m: float = 0.0
var jitter_radial_m: float = 0.0

## THE VANGUARD — every value PROVISIONAL (`CohortConfig.registry()`).
static func vanguard() -> FormationProfile:
	var p := FormationProfile.new()
	p.role = Role.MELEE
	p.profile_name = "VANGUARD"
	p.lane_half_deg = CohortConfig.VANGUARD_LANE_HALF_DEG
	p.arc_half_deg = CohortConfig.VANGUARD_ARC_HALF_DEG
	p.arc_widen_deg = CohortConfig.VANGUARD_ARC_WIDEN_DEG
	p.arc_max_deg = CohortConfig.VANGUARD_ARC_MAX_DEG
	p.ring_step_m = CohortConfig.RING_STEP_M
	p.spacing_m = CohortConfig.SLOT_SPACING_M
	p.jitter_tangent_m = CohortConfig.JITTER_TANGENT_M
	p.jitter_radial_m = CohortConfig.JITTER_RADIAL_M
	return p

## A ring's reach, in degrees either side of her travel.
func arc_half_of_ring(ring: int) -> float:
	return minf(arc_half_deg + arc_widen_deg * float(ring), arc_max_deg)
