class_name RiftMoteCollectionAttempt
extends RefCounted
## Riftwrought — Roguelite Foundation H3: one stat-aware attempt to collect one
## supplied Experience Mote from one supplied world position, as a pure STATELESS
## coordinator.
##
## IT COORDINATES THREE ACCEPTED MECHANISMS AND OWNS NONE OF THEM.
##
##   - The run (Foundation G4) owns the build, and therefore the stat totals the
##     effective Pickup Radius is calculated from. This file asks the run for an
##     independent copy of its build and that copy for its totals, once per
##     attempt, and keeps neither.
##   - The pickup-range query (Foundation H2) owns the radius and the distance: the
##     greybox base, the accepted stat calculation, the horizontal plane and the
##     inclusive boundary. This file asks it one question and restates none of its
##     answer.
##   - The mote (Foundation H1) owns whether it may pay, and pays exactly once; the
##     run commits the experience. This file asks the mote to collect itself into
##     the run, and only when the mote is within range.
##
## It adds exactly one thing of its own: the ORDER in which those three are asked,
## and one answer — refused, out of range, or collected — that says which of them
## decided.
##
##
## THE ORDER IS THE CONTRACT
## ---------------------------------------------------------------------------
## 1. A missing mote refuses.
## 2. A missing run refuses.
## 3. A mote that is not a valid record refuses, with the mote's own problem.
## 4. A mote already collected refuses — before anything is measured, because a
##    mote that can never pay again has no range worth asking about.
## 5. The run is asked for an independent copy of its build, and that copy for its
##    stat totals.
## 6. The pickup-range query is asked whether the mote's position is within the
##    effective Pickup Radius of the player's position, against those totals.
## 7. A refused reading is refused here, quoting its reason, and carries nothing
##    measured.
## 8. A mote beyond the radius is OUT OF RANGE. That is a valid answer, not a
##    failure: the mote is not asked to collect itself, and neither the mote nor
##    the run moves.
## 9. A mote within the radius is asked to collect itself into the run.
## 10. If it refuses — because the run refused the award, for instance while an
##     offer stands — its reason is passed on verbatim, nothing measured rides
##     along, and the mote stays uncollected and the run unchanged. The mote and
##     the run guarantee that; this file only refrains from doing anything else.
## 11. Only after the mote has collected itself is the answer COLLECTED, carrying
##     the distance and radius the query measured.
##
## Each refusal passes on the reason of whatever refused, and every reason is
## plain language. None is replaced by a generic pickup error.
##
##
## WHAT IT DOES NOT DO
## ---------------------------------------------------------------------------
## It computes no percentage, no radius, no distance and no experience, and holds
## no base radius. It binds no mote to a run: a mote remains run agnostic, exactly
## as the accepted mote is. It collects one mote per call and never scans a list
## of motes, a scene or a world, never chooses the nearest one, and never moves
## one. It stores no position, keeps no totals, caches no query, and mutates no
## build and no ledger; the only thing that can move is what the mote and the run
## already move when a collection is accepted.
##
## IT IS PURE AND STATELESS. No instance field of any kind, no static state, no
## constant, no constructor, no node, no signal, no clock, no random source, no
## file. The same inputs in the same state always produce the same answer. Nothing
## that runs calls it: spawning motes, finding them, deciding when to ask, and
## drawing any of it all belong to later foundations with their own
## authorization.


## Attempts to collect `mote` into `run`, for a player standing at
## `player_position` and a mote lying at `mote_position`. Always answers one
## result: refused, out of range, or collected — in the order the header states.
static func attempt(
	player_position: Vector3,
	mote_position: Vector3,
	mote: RiftExperienceMote,
	run: RiftRunLevelCoordinator
) -> RiftMoteCollectionResult:
	if mote == null:
		return RiftMoteCollectionResult.refused(
			"a collection attempt needs an Experience Mote, and none was given")
	if run == null:
		return RiftMoteCollectionResult.refused(
			"a collection attempt needs a run to collect into, and none was given")
	var invalid: String = mote.problem()
	if not invalid.is_empty():
		return RiftMoteCollectionResult.refused(invalid)
	if mote.is_collected():
		return RiftMoteCollectionResult.refused(
			"this Experience Mote has already been collected; no pickup range is measured for it")
	var totals: PlayerStatTotals = run.run_build().stat_totals()
	var reading: RiftMotePickupReading = RiftMotePickupQuery.evaluate(player_position, mote_position, totals)
	if not reading.ok:
		return RiftMoteCollectionResult.refused(reading.failure_reason)
	if not reading.in_range:
		return RiftMoteCollectionResult.out_of_range(reading.planar_distance, reading.effective_radius)
	var refusal: String = mote.collect_into(run)
	if not refusal.is_empty():
		return RiftMoteCollectionResult.refused(refusal)
	return RiftMoteCollectionResult.collected(reading.planar_distance, reading.effective_radius)
