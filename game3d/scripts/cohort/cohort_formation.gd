class_name CohortFormation
extends RefCounted

## THE COHORT'S GEOMETRY AND LAWS — pure, static, deterministic (D-398).
##
## ============================================================================
## PURE, SO THE SUITE CAN PROVE EACH PROPERTY ON EXACT INPUTS.
## ============================================================================
## Nothing here reads a node, a name, a tree order or a clock. The slot pattern is
## a function of (profile, first-ring radius, count) alone; the speed cap is a
## function of (base speed, her speed, distance behind) alone. The two walkable
## helpers ask the navigation server, which is deterministic for one baked map.
##
## ---------------------------------------------------------------------------
## THE FRAME.
## ---------------------------------------------------------------------------
## A slot offset is Vector2(right, forward) in the formation's own frame: forward
## is her heading, right is `right_of(heading)`. An angle of +a degrees is to her
## right, -a to her left, 0 straight ahead.

## Queries made of the navigation server by this file, for the cost check.
static var closest_point_queries: int = 0

## THE SLOT PATTERN for `count` members, in rank order: ring by ring, each ring
## forward flanks first, alternating right and left. Adding members APPENDS --
## the first k offsets do not depend on `count`.
static func slot_offsets(profile: FormationProfile, first_radius: float, count: int) -> Array:
	var out: Array = []
	var ring := 0
	while out.size() < count:
		var r := first_radius + profile.ring_step_m * float(ring)
		for a in ring_angles(profile, r, ring):
			if out.size() >= count:
				break
			out.append(_jittered(profile, r, float(a), out.size()))
		ring += 1
	return out

## The ring each rank sits on -- for the suite's ring counts.
static func ring_of_each(profile: FormationProfile, first_radius: float, count: int) -> Array:
	var out: Array = []
	var ring := 0
	while out.size() < count:
		var r := first_radius + profile.ring_step_m * float(ring)
		for a in ring_angles(profile, r, ring):
			if out.size() >= count:
				break
			out.append(ring)
		ring += 1
	return out

## One ring's slot angles, in degrees: its reach less her lane, divided so that
## neighbours sit at least the spacing apart along the ring. A ring farther out
## holds more slots (capacity scales with radius) and wraps further round her.
static func ring_angles(profile: FormationProfile, r: float, ring: int) -> Array:
	var lane := profile.lane_half_deg
	var window := maxf(0.0, profile.arc_half_of_ring(ring) - lane)
	var per_side := int(floor(deg_to_rad(window) * r / profile.spacing_m)) + 1
	var out: Array = []
	for j in per_side:
		var a := lane
		if per_side > 1:
			a = lane + window * float(j) / float(per_side - 1)
		out.append(a)
		out.append(-a)
	return out

## A slot's fixed looseness: a tangential shift (metres, so it is the same size on
## every ring) and a radial shift, from a low-discrepancy sequence of its RANK --
## never of a node, a name or a clock. A shift never carries a slot into her lane.
static func _jittered(profile: FormationProfile, r: float, a_deg: float, rank: int) -> Vector2:
	var t := jitter_unit(rank, 1) * profile.jitter_tangent_m
	var rr := r + jitter_unit(rank, 2) * profile.jitter_radial_m
	var a := a_deg + rad_to_deg(t / maxf(r, 0.01))
	if absf(a) < profile.lane_half_deg:
		a = signf(a_deg if a_deg != 0.0 else 1.0) * profile.lane_half_deg
	var ar := deg_to_rad(a)
	return Vector2(sin(ar) * rr, cos(ar) * rr)

## A deterministic value in [-1, 1] for (rank, salt).
static func jitter_unit(rank: int, salt: int) -> float:
	return fposmod(float(rank) * 0.6180339887 + float(salt) * 0.3819660113, 1.0) * 2.0 - 1.0

## Her right, on the ground plane.
static func right_of(heading: Vector3) -> Vector3:
	return Vector3(heading.z, 0.0, -heading.x)

## A formation offset placed round a point.
static func to_world(origin: Vector3, heading: Vector3, offset: Vector2) -> Vector3:
	var p := origin + heading * offset.y + right_of(heading) * offset.x
	p.y = 0.0
	return p

## THE PREDICTIVE LEAD: her planar velocity times the lead time, clamped.
static func lead_target(velocity: Vector3, lead_time: float, lead_max: float) -> Vector3:
	var v := Vector3(velocity.x, 0.0, velocity.z)
	return (v * lead_time).limit_length(lead_max)

## Turns a heading toward a wanted one by at most `max_rad`. An exact reversal
## turns one fixed way, never by memory or by chance.
static func turn_heading(current: Vector3, wanted: Vector3, max_rad: float) -> Vector3:
	var ac := atan2(current.x, current.z)
	var aw := atan2(wanted.x, wanted.z)
	var d := wrapf(aw - ac, -PI, PI)
	if absf(absf(d) - PI) < 0.0001:
		d = PI
	var a := ac + clampf(d, -max_rad, max_rad)
	return Vector3(sin(a), 0.0, cos(a))

## The tracking speed toward a slot: the slot's own pace plus the gain on the
## distance, capped. PURE.
static func tracking_speed(slot_speed: float, gain: float, distance: float, cap: float) -> float:
	return clampf(slot_speed * CohortConfig.PACE_RATIO + gain * distance, 0.0, cap)

static func planar(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()

# =============================================================================
# WALKABLE GROUND
# =============================================================================

## True when `p` lies on the baked mesh (its closest point is the point itself).
static func on_mesh(map: RID, p: Vector3) -> bool:
	closest_point_queries += 1
	return planar(NavigationServer3D.map_get_closest_point(map, p), p) <= CohortConfig.ON_MESH_M

## The farthest point along the STRAIGHT line from `from` toward `to` that stays on
## walkable ground -- so a slot is never inside a wall and never across one.
static func walkable_toward(map: RID, from: Vector3, to: Vector3) -> Vector3:
	var start := Vector3(from.x, 0.0, from.z)
	if not on_mesh(map, start):
		closest_point_queries += 1
		start = NavigationServer3D.map_get_closest_point(map, start)
		start.y = 0.0
	var d := planar(start, to)
	var n := maxi(1, int(ceil(d / CohortConfig.WALKABLE_SAMPLE_M)))
	var last := start
	for i in range(1, n + 1):
		var p := start.lerp(Vector3(to.x, 0.0, to.z), float(i) / float(n))
		if not on_mesh(map, p):
			break
		last = p
	last.y = 0.0
	return last

## True when the whole straight line from `from` to `to` is walkable.
static func straight_walkable(map: RID, from: Vector3, to: Vector3) -> bool:
	var d := planar(from, to)
	var n := maxi(1, int(ceil(d / CohortConfig.WALKABLE_SAMPLE_M)))
	for i in range(0, n + 1):
		if not on_mesh(map, from.lerp(to, float(i) / float(n))):
			return false
	return true
