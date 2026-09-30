class_name RiftMoteCollectionResult
extends RefCounted
## Riftwrought — Roguelite Foundation H3: the answer to one attempt to collect one
## Experience Mote from one world position, as a pure VALUE.
##
## THREE OUTCOMES, AND EXACTLY ONE OF THEM. An attempt was REFUSED, the mote was
## OUT OF RANGE, or the mote was COLLECTED. They are one field holding one of three
## values, never three flags, so no answer can claim two outcomes at once or none.
##
## OUT OF RANGE IS NOT A FAILURE. It is a spatial question that was answered
## successfully — the mote is further away than the effective Pickup Radius — for
## which no collection was attempted. It carries no reason, because nothing went
## wrong, and it carries the whole measurement, because the measurement is the
## answer.
##
## WHAT EACH OUTCOME CARRIES.
##
##   - REFUSED: the single plain-language reason, and nothing measured. A refusal
##     may have happened before any measurement existed, or after one existed and
##     the collection itself was refused; either way no distance or radius rides
##     along with it, so a caller cannot read a plausible partial answer off a
##     refusal.
##   - OUT OF RANGE: no reason; the planar distance and the effective radius the
##     pickup-range query measured; the distance strictly greater than the radius.
##   - COLLECTED: no reason; the same two measurements; the distance within the
##     radius, the boundary included.
##
## Scalars only. It holds no mote, no run, no build, no stat totals, no pickup
## reading, no node and no collection object: it describes an attempt that has
## already happened, and nothing that changes afterwards can change it.
##
##
## THE NON-VALUES ARE THE PICKUP-RANGE QUERY'S OWN (D-273, D-274 ruling 1)
## ---------------------------------------------------------------------------
## A refusal stores the distance as POSITIVE INFINITY and the radius as ZERO —
## the values no measured answer can hold. Zero is a real distance (a mote at the
## player's feet), so it cannot mark "not measured"; and infinity compared
## carelessly against a zero radius still reads "not within", which is the safe
## direction. The same two values the accepted pickup reading uses, for the same
## reasons, and asserted equal to them by this foundation's suite.
##
##
## IT OWNS NO FORMULA
## ---------------------------------------------------------------------------
## How far a mote is, what radius a set of modifiers produces, and whether a run
## accepts experience all belong to accepted mechanisms elsewhere. `problem()`
## checks this value's SHAPE, and one relationship between its own fields — that
## its outcome agrees with its own distance and radius. It re-derives nothing and
## performs no arithmetic.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file.

enum Outcome { REFUSED, OUT_OF_RANGE, COLLECTED }

## What a refusal carries as its radius. Zero, because no measured radius is ever
## zero.
const NO_RADIUS: float = 0.0

## What a refusal carries as its distance. Positive infinity, because no measured
## distance is ever infinite — and zero is a distance a measurement can hold.
const NO_DISTANCE: float = INF

## One of `Outcome`. THE AUTHORITY: nothing else here may be read as an answer
## until it has been asked.
var outcome: int = Outcome.REFUSED

## Non-empty exactly when the attempt was refused: the single plain-language
## reason, passed on as the refusing mechanism stated it.
var failure_reason: String = ""

## The distance, in metres, between the player and the mote on the horizontal
## ground plane, as the pickup-range query measured it. `NO_DISTANCE` on a
## refusal.
var planar_distance: float = NO_DISTANCE

## The effective Experience Mote Pickup Radius, in metres, as the pickup-range
## query took it from the accepted stat calculation. `NO_RADIUS` on a refusal.
var effective_radius: float = NO_RADIUS


## A refused attempt: the reason, and every measured field at its non-value.
static func refused(reason: String) -> RiftMoteCollectionResult:
	var result: RiftMoteCollectionResult = RiftMoteCollectionResult.new()
	result.outcome = Outcome.REFUSED
	result.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "the collection attempt was refused for an unstated reason"
	result.planar_distance = NO_DISTANCE
	result.effective_radius = NO_RADIUS
	return result


## A successfully answered spatial question for which no collection was
## attempted: the mote lies beyond the effective radius.
static func out_of_range(
	for_planar_distance: float,
	for_effective_radius: float
) -> RiftMoteCollectionResult:
	var result: RiftMoteCollectionResult = RiftMoteCollectionResult.new()
	result.outcome = Outcome.OUT_OF_RANGE
	result.failure_reason = ""
	result.planar_distance = for_planar_distance
	result.effective_radius = for_effective_radius
	return result


## A mote within the effective radius whose collection the run accepted.
static func collected(
	for_planar_distance: float,
	for_effective_radius: float
) -> RiftMoteCollectionResult:
	var result: RiftMoteCollectionResult = RiftMoteCollectionResult.new()
	result.outcome = Outcome.COLLECTED
	result.failure_reason = ""
	result.planar_distance = for_planar_distance
	result.effective_radius = for_effective_radius
	return result


func is_refused() -> bool:
	return outcome == Outcome.REFUSED


func is_out_of_range() -> bool:
	return outcome == Outcome.OUT_OF_RANGE


func is_collected() -> bool:
	return outcome == Outcome.COLLECTED


## Returns "" when this result is internally coherent, or the first
## inconsistency found. A refusal must carry a reason and only the two
## non-values; an out-of-range or collected result must carry no reason, a finite
## distance that is not negative, a finite positive radius, and a distance on the
## side of that radius its outcome claims.
func problem() -> String:
	if outcome == Outcome.REFUSED:
		if failure_reason.strip_edges().is_empty():
			return "a refused attempt must state a reason"
		if planar_distance != NO_DISTANCE:
			return "a refused attempt must carry no distance, not %s" \
				% String.num_scientific(planar_distance)
		if effective_radius != NO_RADIUS:
			return "a refused attempt must carry no radius, not %s" \
				% String.num_scientific(effective_radius)
		return ""
	if outcome != Outcome.OUT_OF_RANGE and outcome != Outcome.COLLECTED:
		return "an attempt must be refused, out of range or collected, not outcome %d" % outcome
	if not failure_reason.is_empty():
		return "an attempt that was not refused must state no failure reason"
	if not is_finite(planar_distance) or planar_distance < 0.0:
		return "a measured attempt must carry a finite distance that is not negative, not %s" \
			% String.num_scientific(planar_distance)
	if not is_finite(effective_radius) or effective_radius <= 0.0:
		return "a measured attempt must carry a finite positive radius, not %s" \
			% String.num_scientific(effective_radius)
	if outcome == Outcome.OUT_OF_RANGE and planar_distance <= effective_radius:
		return "reports out of range for a distance of %s within a radius of %s" % [
			String.num_scientific(planar_distance), String.num_scientific(effective_radius),
		]
	if outcome == Outcome.COLLECTED and planar_distance > effective_radius:
		return "reports collected for a distance of %s beyond a radius of %s" % [
			String.num_scientific(planar_distance), String.num_scientific(effective_radius),
		]
	return ""


# --- Presentation -------------------------------------------------------------
#
# Deliberately separate from the answer above, and reached by nothing in it.

func describe() -> String:
	if outcome == Outcome.REFUSED:
		return "refused — %s" % failure_reason
	if outcome == Outcome.OUT_OF_RANGE:
		return "out of range: %s m on the ground plane beyond a %s m radius; nothing was collected" % [
			String.num_scientific(planar_distance), String.num_scientific(effective_radius),
		]
	if outcome == Outcome.COLLECTED:
		return "collected: %s m on the ground plane within a %s m radius" % [
			String.num_scientific(planar_distance), String.num_scientific(effective_radius),
		]
	return "an unknown outcome %d" % outcome
