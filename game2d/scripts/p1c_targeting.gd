class_name P1CTargeting
extends RefCounted

## P1C-H — targeting. **Per-use, never persistent** (D-347 ruling 1).
##
## There is deliberately **NO stored target field anywhere in this class.** Every call
## takes the cursor or stick it should use and answers from that alone. Hover is
## information, not selection; there is no cycling, no sticky namelock, no permanent marker
## and no globally selected enemy. `_expect` in the suite proves two uses answer
## independently, and a separate check proves the class declares no state to store one in.

## **The controller soft-target CONE. Stated as a TOTAL width and applied as a half-width.**
## It is a different number for a different job from a Skill's release arc, and the two must
## never be conflated: the arc is what a release sweeps, the cone is aim ASSISTANCE.
const SOFT_TARGET_CONE_TOTAL_DEG: float = 65.0
const SOFT_TARGET_HALF_DEG: float = SOFT_TARGET_CONE_TOTAL_DEG * 0.5   ## 32.5

## How far soft targeting will reach, in metres.
const ACQUISITION_DISTANCE_M: float = 9.0

## **There is NO lock-on and NO retention.** Recorded as a constant so a later phase cannot
## quietly add one and call it pre-existing.
const LOCK_ON_ENABLED: bool = false
const RETAINS_TARGET_BETWEEN_USES: bool = false


## Where a mouse use aims: straight at the cursor, sampled at the moment of use.
##
## **Per-use by construction** — the answer is a pure function of the arguments, so two
## uses with the cursor moved between them cannot agree by accident.
static func aim_for_use(origin: Vector2, cursor: Vector2) -> Vector2:
	var d: Vector2 = cursor - origin
	if d.length_squared() <= 0.0:
		return Vector2.RIGHT
	return d.normalized()


## Controller soft targeting, evaluated fresh for this one use.
##
## `candidates` is an array of `{"id": int, "position": Vector2}` in the same space as
## `origin`. `intent` is the stick direction for THIS use.
##
## **An enemy at the actor's feet does not outrank the one being aimed at.** The in-reach
## priority group is a CONTACT-MELEE rule and is deliberately not generalized here: the
## score below rewards angular agreement first and uses distance only to break ties, so a
## nearer candidate outside the cone never beats a further one inside it.
static func soft_target(origin: Vector2, intent: Vector2, candidates: Array,
		px_per_m: float) -> Dictionary:
	var out: Dictionary = {"id": -1, "angle_deg": INF, "distance_m": INF, "considered": 0}
	if intent.length_squared() <= 0.0:
		return out
	var intent_deg: float = rad_to_deg(atan2(intent.y, intent.x))
	var best_score: float = -INF
	for c: Dictionary in candidates:
		var to: Vector2 = (c["position"] as Vector2) - origin
		var dist_m: float = to.length() / px_per_m
		if to.length_squared() <= 0.0:
			# Exactly at the origin: no direction, so it cannot be "aimed at".
			continue
		if dist_m > ACQUISITION_DISTANCE_M:
			continue
		var off: float = absf(wrapf(rad_to_deg(atan2(to.y, to.x)) - intent_deg, -180.0, 180.0))
		out["considered"] = int(out["considered"]) + 1
		if off > SOFT_TARGET_HALF_DEG:
			continue
		# Angular agreement dominates; distance only separates equals.
		var score: float = (SOFT_TARGET_HALF_DEG - off) * 1000.0 - dist_m
		if score > best_score:
			best_score = score
			out["id"] = int(c["id"])
			out["angle_deg"] = off
			out["distance_m"] = dist_m
	return out
