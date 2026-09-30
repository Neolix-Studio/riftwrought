class_name RiftExperienceTrack
extends RefCounted
## Riftwrought — Roguelite Foundation E1: the temporary Rift experience track,
## as a pure in-memory VALUE.
##
## IT HOLDS TWO NUMBERS AND DECIDES NOTHING ELSE. A level, which begins at 1, and
## the effective experience accumulated toward the next one, which begins at
## exactly zero. Everything a caller might expect to find beside them — how much
## a level costs, how much an enemy is worth, what is offered when one is gained,
## in what order, and whether any of it survives the run — is deliberately
## absent, and each absence is asserted by the suite rather than promised here.
##
## THE REQUIREMENT IS SUPPLIED, NEVER OWNED. Every question about a threshold —
## is the track ready, how much is still needed, may it advance — takes the
## requirement for the current level as an argument. This foundation therefore
## invents no experience curve at all, which is the one decision it would be
## easiest to make by accident: a single default number here would silently
## become the game's first balance value, chosen by whoever needed a test to
## compile. A later foundation owns the curve and owns the ordering of what a
## gained level offers.
##
## EXPERIENCE GAIN IS APPLIED WHEN THE AWARD ARRIVES, AND ONLY TO THAT AWARD.
## The build's stat totals are handed in with each award and are read once,
## through the accepted calculation path, and never stored. That is what makes
## the rule structural rather than remembered: acquiring more Experience Gain
## later cannot raise experience already accumulated, because this value holds no
## reference to any totals to re-apply and no record of what any earlier award
## was worth before its multiplier. There is nothing here to make retroactive.
##
## NO PERCENTAGE ARITHMETIC IS RESTATED. The multiplier belongs to the accepted
## stat vocabulary and is asked for by name; this file contains no
## multiplication, no division and no floating-point literal but zero. Two
## implementations of one percentage rule is how two answers to one question
## start, and the one that is wrong is always the copy.
##
## FRACTIONAL EXPERIENCE IS KEPT EXACTLY AS IT ARRIVES. Nothing here rounds,
## floors or truncates, because a multiplier of any interesting size produces a
## fraction and discarding it makes a percentage silently worth less than it
## says. The stored progress is a float and stays one.
##
## ONE CALL ADVANCES ONE LEVEL. If the surplus left over would satisfy the next
## requirement as well, the track will say so when it is next asked — and it
## still advances only when it is asked again. That is not a convenience: it is
## what keeps a future offer resolvable between two level gains rather than after
## a silent run of them.
##
## IT FAILS CLOSED AND NEVER PARTIALLY. Every operation returns "" when it was
## accepted or the single plain-language reason it was refused, and a refusal
## leaves the level and the progress exactly as they were. Reading operations
## that cannot answer in their own return type answer through a reading instead,
## which is the honest path and the one a caller that must tell "not yet" from
## "that is not a requirement" calls.
##
## IT IS TEMPORARY, IN-MEMORY AND RUN-SCOPED. There is no clear, no reset, no
## death rule, no abandon rule, no file, no schema and no persistence: a new run
## is a new track, exactly as a new run is a new build. The first-MVP canonical
## opening already carries a persisted, whole-number, curve-driven character
## experience concept, and this is deliberately NOT that one — it shares no file
## with it, names nothing in it, and is not a second implementation of it.
##
## IT IS A VALUE, NOT A STORE. No node, no signal, no clock, no random source, no
## file, and no experience source of any kind: what an award represents, where it
## came from and how it was collected are all decided elsewhere.

## Where a track begins. A level, not a level requirement.
const STARTING_LEVEL: int = 1

## The point at which one more level could no longer be represented. It is an
## ARITHMETIC BOUND rather than a maximum level: this foundation deliberately
## decides no ceiling on how far a run may go, and this constant exists only so
## that the single increment this file performs cannot silently wrap into a
## negative level. Reaching it through this value's own interface would take
## nine quintillion successful calls; the rule is nevertheless enforced rather
## than assumed, and is exposed as a pure test below so it can be driven.
const LEVEL_INCREMENT_LIMIT: int = 9223372036854775807

var _level: int = STARTING_LEVEL
var _progress: float = 0.0


# --- Reading the track ---------------------------------------------------------
#
# Scalars only, and deliberately no setter for either: the level moves through
# `advance_one_level()` and the progress through `award()`, so there is exactly
# one way for each to change and both of those ways are validated.

func level() -> int:
	return _level


## The effective experience accumulated toward the next level, fractions
## included.
func progress() -> float:
	return _progress


# --- Awarding experience -------------------------------------------------------

## Records one experience award of `base_experience`, as modified by the build
## `totals` describe AT THIS MOMENT. Returns "" when it was accepted, or the
## single plain-language reason it was refused. A refused award changes nothing.
##
## THE ORDER OF THE GATES IS THE CONTRACT. The award is checked before the build
## is, because the award is what is being made and an unusable one is unusable
## whatever the build looks like. Then the totals must exist. Then the accepted
## calculation must succeed. Then its result must be worth recording. Only then
## is the sum tested, and only if THAT is usable is anything written — which is
## the one refusal that happens after every validation has passed, and therefore
## the only one that could leave a partial state if the order were wrong.
##
## THE MULTIPLIER IS NOT COMPUTED HERE. `value_of()` is the accepted path, it is
## asked for the accepted Experience Gain identifier, and whatever it answers is
## what is recorded. This file cannot disagree with it, because it does not know
## how to.
func award(base_experience: float, totals: PlayerStatTotals) -> String:
	if not is_finite(base_experience):
		return "an experience award must be a finite number, not %s" % _shown(base_experience)
	if base_experience <= 0.0:
		return "an experience award must be positive, not %s" % _shown(base_experience)
	if totals == null:
		return "an experience award must carry the stat totals to evaluate it against"
	var effective: PlayerStatValue = totals.value_of(
		PlayerStats.EXPERIENCE_GAIN, base_experience)
	if not effective.ok:
		return "an award of %s could not be evaluated: %s" % [
			_shown(base_experience), effective.failure_reason,
		]
	## Reachable rather than defensive: a small enough award under a reduction
	## can round to nothing, and the accepted calculation reports that as an
	## ordinary success because zero is a perfectly good product. Recording it
	## would report that experience was awarded when none was.
	if effective.value <= 0.0:
		return "an award of %s came to %s after Experience Gain, which is not positive" % [
			_shown(base_experience), _shown(effective.value),
		]
	var candidate: float = _progress + effective.value
	if not is_finite(candidate):
		return "adding %s to %s would make the stored progress unusable" % [
			_shown(effective.value), _shown(_progress),
		]
	_progress = candidate
	return ""


# --- Asking about a caller-supplied requirement ---------------------------------

## Returns "" when `requirement` is one this track can be measured against, or
## the single plain-language reason it is not. Pure and static: it is the ONE
## place a requirement is validated, so the reading path and the advancing path
## cannot come to two different answers about the same number.
static func requirement_problem(requirement: float) -> String:
	if not is_finite(requirement):
		return "an experience requirement must be a finite number, not %s" % _shown(requirement)
	if requirement <= 0.0:
		return "an experience requirement must be positive, not %s" % _shown(requirement)
	return ""


## The honest answer to both threshold questions at once, including the answer
## "that is not a requirement". This is the explicit result path; the two scalar
## readings below are conveniences built on it and say strictly less.
func reading_for(requirement: float) -> RiftExperienceReading:
	var refusal: String = requirement_problem(requirement)
	if not refusal.is_empty():
		return RiftExperienceReading.failed(refusal)
	return RiftExperienceReading.measured(
		requirement, _progress,
		_progress >= requirement,
		maxf(requirement - _progress, 0.0)
	)


## Whether the accumulated progress is at least `requirement`.
##
## AN INVALID REQUIREMENT IS NEVER READY, which is fail-closed but says nothing
## about why. A caller that must distinguish "not yet" from "that is not a
## requirement" calls `reading_for()`.
func is_ready(requirement: float) -> bool:
	var reading: RiftExperienceReading = reading_for(requirement)
	return reading.ok and reading.ready


## How much more experience `requirement` still needs. Zero once it is met.
##
## AN INVALID REQUIREMENT ANSWERS INFINITY, AND DELIBERATELY NOT ZERO. Zero is
## precisely the answer that means "nothing more is needed", so returning it for
## a requirement that could not be read would be the most plausible possible
## lie. Infinity is obviously wrong instead of quietly wrong; `reading_for()`
## says why.
func remaining(requirement: float) -> float:
	var reading: RiftExperienceReading = reading_for(requirement)
	return reading.remaining if reading.ok else INF


# --- Advancing ------------------------------------------------------------------

## Whether a track at `level` can take one more level without the arithmetic
## wrapping. Pure and static so that the rule can be driven directly: through
## this value's own interface the bound is unreachable in any finite run, and a
## guard that only exists inside an unreachable branch is a guard nobody has
## ever tested.
static func level_can_increment(level: int) -> bool:
	return level < LEVEL_INCREMENT_LIMIT


## Advances EXACTLY ONE level against the caller-supplied `requirement`,
## subtracting exactly one requirement and keeping every unit of surplus.
## Returns "" when it was accepted, or the single plain-language reason it was
## refused. A refused advance changes neither the level nor the progress.
##
## IT NEVER CONSUMES TWO THRESHOLDS IN ONE CALL, however large the surplus. If
## what is left still satisfies the next requirement the track will report ready
## again, and the second level is gained by asking again.
##
## IT ASKS THE SAME READING A CALLER WOULD. Whether the requirement is usable
## and whether it has been met are decided in exactly one place — the reading —
## rather than by a second comparison written here, so the answer a caller was
## shown and the answer this function acts on cannot come apart. Two expressions
## of one rule is how a track starts refusing to advance at the very moment it
## reports that it can.
##
## BOTH NEW VALUES ARE COMPUTED BEFORE EITHER IS WRITTEN. Neither computation can
## fail once the gates above have passed, so today this is defence in depth
## rather than a fix for something reachable; it is the shape that keeps being
## correct if a step is ever inserted between the two writes.
func advance_one_level(requirement: float) -> String:
	var reading: RiftExperienceReading = reading_for(requirement)
	if not reading.ok:
		return reading.failure_reason
	if not reading.ready:
		return "%s of experience is short of the %s this level requires" % [
			_shown(_progress), _shown(requirement),
		]
	if not level_can_increment(_level):
		return "level %d cannot take another without overflowing" % _level
	var kept: float = _progress - requirement
	var next_level: int = _level + 1
	_progress = kept
	_level = next_level
	return ""


# --- The whole value ------------------------------------------------------------

## An independent copy. Awarding to the copy cannot move this track, and
## advancing this track cannot move the copy — which is what lets a caller ask
## "where would this leave me?" without granting anything.
func duplicated() -> RiftExperienceTrack:
	var copy: RiftExperienceTrack = RiftExperienceTrack.new()
	copy._level = _level
	copy._progress = _progress
	return copy


# --- Presentation ---------------------------------------------------------------
#
# Reached by nothing above. No formatted string is compared, parsed or fed back
# into a number, and nothing here states a requirement, because this value does
# not know one.

func describe() -> String:
	return "Level %d, %s experience accumulated" % [_level, _shown(_progress)]


## An alias for the scientific formatter this engine already carries, used
## because ordinary float printing renders the two extremes a refusal most needs
## to name as either "0.0" or as three hundred digits.
static func _shown(value: float) -> String:
	return String.num_scientific(value)
