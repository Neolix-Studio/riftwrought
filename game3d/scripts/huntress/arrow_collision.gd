class_name ArrowCollision
extends RefCounted

## ONE ARROW'S COLLISIONS, BY PHYSICAL TIME OF IMPACT — D-391 ruling 5 (D-392).
##
## ============================================================================
## "A single arrow resolves overlapping collisions by physical time of impact.
## The earliest intersection along its swept path wins. A mathematical tie within
## collision tolerance is resolved by a stable combat-entity ID, never engine
## iteration order, object name or memory order. No tolerance value is locked."
## ============================================================================
##
## PURE ARITHMETIC ON THE PLANE, so the D-392 suite can check it against closed
## forms. The simulation is a continuous 2D ground plane (combat section 0.1):
## an arrow is a moving circle of radius r_a, a body is a circle of radius r_b,
## and they touch when their centres are within r_a + r_b. Height is
## presentation and never enters.
##
## THE CHOICE READS NOTHING BUT THE SWEPT DISTANCE AND THE REGISTRY'S ORDER. It
## never reads the order candidates were listed in, a node's name, an instance
## id or a physics query's result order -- the D-392 suite scans this file's
## code for exactly those.

## The earliest parameter t in [0, 1] at which a circle of radius `r` centred at
## `c` is touched by the segment a -> b, or -1.0 if it never is. A START ALREADY
## INSIDE the circle is t = 0: the point-blank rule (combat section 0.5).
static func segment_circle_toi(a: Vector2, b: Vector2, c: Vector2, r: float) -> float:
	var m := a - c
	var cc := m.dot(m) - r * r
	if cc <= 0.0:
		return 0.0
	var d := b - a
	var aa := d.dot(d)
	if aa <= 0.0:
		return -1.0
	var bb := m.dot(d)
	if bb >= 0.0:
		return -1.0                    # moving away, and not inside
	var disc := bb * bb - aa * cc
	if disc < 0.0:
		return -1.0                    # the line misses the circle
	var t := (-bb - sqrt(disc)) / aa
	if t < 0.0 or t > 1.0:
		return -1.0
	return t

static func planar(v: Vector3) -> Vector2:
	return Vector2(v.x, v.z)

## Chooses ONE winner among candidates of the form
##   {"id": String, "distance_m": float, ...}
## where `distance_m` is how far along the arrow's swept path the contact happens.
##
## ORDER-INDEPENDENT BY CONSTRUCTION, in three steps:
##   1. the EARLIEST contact distance, d_min, over ALL candidates;
##   2. the TIE SET: every candidate within `tolerance_m` of d_min;
##   3. of the tie set, the one whose ID `registry.precedes()` every other.
## (A pairwise "within tolerance" rule is NOT transitive -- 1.0000, 1.0008 and
## 1.0016 m with a 0.001 m tolerance -- so a running pairwise reduction could
## depend on the order it met them. Anchoring the tie set on d_min cannot.)
## Returns the winner, or {} when there is none.
static func choose(candidates: Array, registry: CombatEntityRegistry, tolerance_m: float) -> Dictionary:
	if candidates.is_empty():
		return {}
	var d_min := INF
	for c in candidates:
		d_min = minf(d_min, float(c["distance_m"]))
	var best: Dictionary = {}
	for c in candidates:
		if float(c["distance_m"]) > d_min + tolerance_m:
			continue
		if best.is_empty() or registry.precedes(String(c["id"]), String(best["id"])):
			best = c
	return best

## The tie set the winner was chosen from -- reported so a tie is never silent.
static func tie_set(candidates: Array, tolerance_m: float) -> Array:
	var d_min := INF
	for c in candidates:
		d_min = minf(d_min, float(c["distance_m"]))
	var out: Array = []
	for c in candidates:
		if float(c["distance_m"]) <= d_min + tolerance_m:
			out.append(String(c["id"]))
	return out
