class_name RiftMotePickupReading
extends RefCounted
## Riftwrought — Roguelite Foundation H2: one answer to "is this world position
## within the player's effective Experience Mote Pickup Radius?", as a pure VALUE.
##
## WHY A TYPE RATHER THAN A BOOL. "In range" has only two answers, and neither of
## them can say "I could not measure that". A bool answers `false` for a position
## that is not a number and for a stat calculation that failed exactly as it
## answers `false` for a mote four metres away, and a later coordinator could not
## tell the three apart. So the answer comes back with `ok`, and `failure_reason`
## is non-empty exactly when `ok` is false. `ok` IS THE AUTHORITY: nothing else in
## this value may be read as an answer until it has been asked.
##
## WHAT A SUCCESS CARRIES. The two positions it was asked about, the base radius
## the query started from, the effective radius the accepted stat calculation
## produced from that base, the planar distance between the two positions, and
## whether that distance is within that radius. Scalars and positions only: it
## holds no reference to the stat totals it was measured against, or to any other
## object, so nothing that changes after the answer can change the answer.
##
## A REFUSAL CARRIES THE QUESTION, THE REASON, AND NOTHING MEASURED. The two
## positions are kept, because they are the inputs a reader needs to see what was
## asked — including the component that was not a number. Nothing else is: no
## base radius, no effective radius, no distance, and never "in range".
##
##
## THE NON-VALUES, AND WHY THEY ARE THESE TWO
## ---------------------------------------------------------------------------
## The project's rule for a stored non-value is that it must be a value NO
## SUCCESSFUL ANSWER CAN EVER HOLD, so that it is unambiguous beside `ok`
## (decisions D-262 and D-263). The two quantities here need two different ones.
##
## `NO_RADIUS` IS ZERO. Every successful base radius and every successful effective
## radius is strictly positive, so zero is a radius no success can hold.
##
## `NO_DISTANCE` IS POSITIVE INFINITY, AND ZERO WOULD HAVE BEEN WRONG. Zero is a
## distance a success CAN hold — a mote exactly at the player's feet — so by the
## rule above it cannot mark "not measured". Worse, the two zeros together would
## compare as in range: `0 <= 0` is true, which is exactly the careless comparison
## D-263 moved a refused requirement to infinity to defeat. Infinity is a distance
## no success can hold — two finite world positions are always a finite distance
## apart, measured by this foundation's suite at the largest separation the
## engine's positions can express — and `INF <= radius` is false for every radius,
## including `NO_RADIUS`. So a caller that forgets `ok` and compares the two stored
## numbers reads "out of range", which is the same answer the stored verdict
## gives.
##
##
## IT OWNS NO FORMULA
## ---------------------------------------------------------------------------
## Which radius a set of modifiers produces belongs to the accepted stat
## calculation, and how the planar distance is measured belongs to the query;
## re-deriving either here would write a rule a second time. `problem()` checks
## this value's SHAPE, and one relationship between its own fields: that its
## verdict agrees with its own distance and radius, as the accepted experience
## reading checks that its readiness agrees with its own progress and
## requirement. Whether the distance and the radius are the right ones for their
## inputs is proved by the suite, never here.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file. It
## describes an answer that has already been given and performs nothing.

## What a refused reading carries as either radius. Zero, because no successful
## radius is ever zero.
const NO_RADIUS: float = 0.0

## What a refused reading carries as its distance. Positive infinity, because no
## successful distance is ever infinite — see the header for why zero is not safe.
const NO_DISTANCE: float = INF

var ok: bool = false

## Non-empty exactly when `ok` is false. Otherwise the single plain-language
## reason, naming what was refused rather than merely that something was.
var failure_reason: String = ""

## The player's world position that was asked about, on a success and — as the
## question — on a refusal as well.
var player_position: Vector3 = Vector3.ZERO

## The mote's world position that was asked about, on a success and — as the
## question — on a refusal as well.
var mote_position: Vector3 = Vector3.ZERO

## The radius, in metres, before any Pickup Radius modifier. `NO_RADIUS` on a
## refusal.
var base_radius: float = NO_RADIUS

## The radius, in metres, after the accepted stat calculation applied the stat
## totals it was given to `base_radius`. `NO_RADIUS` on a refusal.
var effective_radius: float = NO_RADIUS

## The distance, in metres, between the two positions on the horizontal ground
## plane, with any height difference ignored. `NO_DISTANCE` on a refusal.
var planar_distance: float = NO_DISTANCE

## Whether `planar_distance` is within `effective_radius`, the boundary included.
## Never true on a refusal.
var in_range: bool = false


## The only way to build a refusal. It keeps the question and the reason and sets
## every measured field to its non-value, so no partial radius, distance or
## verdict can ride along with one.
static func refused(
	for_player_position: Vector3,
	for_mote_position: Vector3,
	reason: String
) -> RiftMotePickupReading:
	var result: RiftMotePickupReading = RiftMotePickupReading.new()
	result.ok = false
	result.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "the pickup range was refused for an unstated reason"
	result.player_position = for_player_position
	result.mote_position = for_mote_position
	result.base_radius = NO_RADIUS
	result.effective_radius = NO_RADIUS
	result.planar_distance = NO_DISTANCE
	result.in_range = false
	return result


static func measured(
	for_player_position: Vector3,
	for_mote_position: Vector3,
	for_base_radius: float,
	for_effective_radius: float,
	for_planar_distance: float,
	for_in_range: bool
) -> RiftMotePickupReading:
	var result: RiftMotePickupReading = RiftMotePickupReading.new()
	result.ok = true
	result.failure_reason = ""
	result.player_position = for_player_position
	result.mote_position = for_mote_position
	result.base_radius = for_base_radius
	result.effective_radius = for_effective_radius
	result.planar_distance = for_planar_distance
	result.in_range = for_in_range
	return result


## Returns "" when the reading is internally coherent, or the first
## inconsistency found. A refusal must carry a reason and only non-values; a
## success must carry no reason, finite positions, strictly positive finite radii,
## a finite distance that is not negative, and a verdict that agrees with its own
## distance and radius.
func problem() -> String:
	if not ok:
		if failure_reason.strip_edges().is_empty():
			return "a refused reading must state a reason"
		if base_radius != NO_RADIUS or effective_radius != NO_RADIUS:
			return "a refused reading must carry no radius, not %s and %s" % [
				_shown(base_radius), _shown(effective_radius),
			]
		if planar_distance != NO_DISTANCE:
			return "a refused reading must carry no distance, not %s" % _shown(planar_distance)
		if in_range:
			return "a refused reading must never report a mote in range"
		return ""
	if not failure_reason.is_empty():
		return "a successful reading must state no failure reason"
	if not player_position.is_finite() or not mote_position.is_finite():
		return "a successful reading must be about two finite positions"
	if not is_finite(base_radius) or base_radius <= 0.0:
		return "a successful reading must carry a positive finite base radius, not %s" % _shown(
			base_radius)
	if not is_finite(effective_radius) or effective_radius <= 0.0:
		return "a successful reading must carry a positive finite effective radius, not %s" % _shown(
			effective_radius)
	if not is_finite(planar_distance) or planar_distance < 0.0:
		return "a successful reading must carry a finite distance that is not negative, not %s" % _shown(
			planar_distance)
	if in_range != (planar_distance <= effective_radius):
		return "reports in range %s for a distance of %s against a radius of %s" % [
			str(in_range), _shown(planar_distance), _shown(effective_radius),
		]
	return ""


# --- Presentation -------------------------------------------------------------
#
# Deliberately separate from the answer above, and reached by nothing in it. No
# formatted string is compared, parsed or fed back into a number.

func describe() -> String:
	if not ok:
		return "refused — %s" % failure_reason
	return "%s: %s m on the ground plane against a %s m radius (base %s m)" % [
		"in range" if in_range else "out of range",
		_shown(planar_distance), _shown(effective_radius), _shown(base_radius),
	]


## The scientific formatter this engine already carries, used because ordinary
## float printing rounds away exactly the last-place differences a boundary
## reading most needs to show.
static func _shown(value: float) -> String:
	return String.num_scientific(value)
