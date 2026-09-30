class_name RiftMotePickupQuery
extends RefCounted
## Riftwrought — Roguelite Foundation H2: the planar Experience Mote pickup-range
## query, as a pure STATELESS rule.
##
## IT ANSWERS ONE QUESTION. Is a world position within the player's effective
## Experience Mote Pickup Radius? It calculates and reports the answer, and that is
## all it does: it does not find a mote, move one, own one or collect one.
##
## THREE REVIEW-LEVEL RULES (decision D-273).
##
##   - The base Experience Mote Pickup Radius is `BASE_PICKUP_RADIUS`, 2.5 m — a
##     GREYBOX REVIEW VALUE, not final balance.
##   - Distance is measured on the horizontal X/Z gameplay plane. Height is
##     ignored: a mote on a ledge above the player and one at the player's feet
##     are the same distance away if they stand over the same ground.
##   - The boundary is INCLUSIVE. A mote whose planar distance equals the
##     effective radius exactly is in range.
##
## THE RADIUS IS THE ACCEPTED STAT CALCULATION'S, NEVER THIS FILE'S. The effective
## radius is whatever the accepted player-stat path answers for Pickup Radius
## from the base, against the stat totals the caller hands in, at the moment of
## the question. This file adds no percentage, scales nothing, caps nothing and
## applies no diminishing return: every modifier the totals hold reaches the
## radius exactly as the accepted path combines it, and a calculation that path
## refuses is refused here with its own reason — never replaced by the base, a
## floor or a guess.
##
## WHAT PICKUP RADIUS REACHES IS UNCHANGED. The stat applies to Experience Motes
## and to run resources explicitly classified for automatic pickup, and never to
## gear pickup, manual interaction distance or mouse click range (D-230, D-232).
## This query is the first thing that asks the stat for a radius at all; it does
## not classify anything, and it names no particular card that grants the stat.
##
##
## THE ORDER IS THE CONTRACT
## ---------------------------------------------------------------------------
## 1. A player position with any component that is not a finite number refuses.
## 2. A mote position with any component that is not a finite number refuses —
##    the height included, even though the distance ignores it: an ignored number
##    is still not allowed to be garbage.
## 3. Missing stat totals refuse.
## 4. The accepted calculation is asked for the effective radius from the base.
## 5. A calculation it refuses is refused here, quoting its reason; so is one
##    that does not come back as a finite, strictly positive radius.
## 6. Only then is the planar distance measured and compared, boundary included.
##
## A refusal carries the two positions it was asked about and nothing measured —
## see the reading beside this file for the non-values and why they are the ones
## they are.
##
##
## IT IS PURE AND STATELESS. No instance field of any kind, no static state, no
## node, no signal, no clock, no random source, no file, no project setting, no
## physics, collision or navigation query, and no reference kept to the stat
## totals it was handed. The same three inputs always produce the same answer,
## whatever was asked before them and in whatever order. Nothing that runs calls
## it: scanning for motes, deciding which ones to collect, and handing a collected
## one's experience to a run all belong to later foundations with their own
## authorization.

## The Experience Mote Pickup Radius before any Pickup Radius modifier, in metres.
## A greybox review value (D-273), not final balance.
const BASE_PICKUP_RADIUS: float = 2.5


## Whether `mote_position` is within the effective Experience Mote Pickup Radius
## of a player standing at `player_position`, whose Pickup Radius modifiers are
## the ones `totals` holds. Always a reading: `ok` with the whole measurement, or a
## refusal carrying the two positions and one reason and nothing measured.
static func evaluate(
	player_position: Vector3,
	mote_position: Vector3,
	totals: PlayerStatTotals
) -> RiftMotePickupReading:
	if not player_position.is_finite():
		return RiftMotePickupReading.refused(player_position, mote_position,
			"the player position must have a finite x, y and z, not %s" % player_position)
	if not mote_position.is_finite():
		return RiftMotePickupReading.refused(player_position, mote_position,
			"the mote position must have a finite x, y and z, not %s" % mote_position)
	if totals == null:
		return RiftMotePickupReading.refused(player_position, mote_position,
			"the pickup range needs the player's stat totals, and none were given")
	var radius: PlayerStatValue = totals.value_of(PlayerStats.PICKUP_RADIUS, BASE_PICKUP_RADIUS)
	if not radius.ok:
		return RiftMotePickupReading.refused(player_position, mote_position,
			"the effective Pickup Radius could not be calculated: %s" % radius.failure_reason)
	if not is_finite(radius.value) or radius.value <= 0.0:
		return RiftMotePickupReading.refused(player_position, mote_position,
			"the effective Pickup Radius must be a finite positive number, not %s"
				% String.num_scientific(radius.value))
	## THE HORIZONTAL GAMEPLAY PLANE: x and z only. Each component is read out of
	## the position into a full-precision number before it is subtracted, so the
	## difference, its square and the sum are all taken at that precision.
	var across: float = mote_position.x - player_position.x
	var along: float = mote_position.z - player_position.z
	var planar_distance: float = sqrt(across * across + along * along)
	return RiftMotePickupReading.measured(player_position, mote_position,
		BASE_PICKUP_RADIUS, radius.value, planar_distance, planar_distance <= radius.value)
