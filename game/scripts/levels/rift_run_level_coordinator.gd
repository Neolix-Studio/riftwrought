class_name RiftRunLevelCoordinator
extends RefCounted
## Riftwrought — Roguelite Foundation G4: repeated run-level coordination, as a
## pure in-memory coordinator that composes accepted one-level lifecycles one
## explicit choice at a time.
##
## THE ONE THING IT PROVES. A run holds one seed and one current one-level
## lifecycle. When that lifecycle's level-up is available, the current level's
## requirement is asked of the accepted requirement curve (Foundation G1), the
## current level's offer root seed is asked of the accepted per-level derivation
## (Foundation G2), the offer is opened and one lane resolved by the accepted
## one-level coordinator (Foundation E2), and the completed lifecycle is replaced,
## exactly once, by the continuation the accepted seam (Foundation G3) builds from
## it. The next level-up is then available — and it is not taken until somebody
## explicitly asks for it.
##
##
## IT HOLDS TWO THINGS, AND EVERYTHING ELSE IS OWNED BELOW IT
## ---------------------------------------------------------------------------
## The run seed, exactly as it was given, and the one current lifecycle. There is
## no stored level, experience, requirement, root seed, offer, build, ledger,
## completed flag, pending choice or history: the level, the experience, the offer
## and its frozen requirement, the build and the ledger all live in the current
## lifecycle, which already answers each of them, and a second copy of any of them
## here would be a second thing that could be wrong. Every reading below is a
## delegation, and every object one hands out is a copy the lifecycle made.
##
## THE CURRENT LIFECYCLE IS NEVER HANDED OUT. A caller holding it could open, take
## or continue it behind this run's back, and "exactly one live successor" would
## stop being a property of the run.
##
##
## WHO OWNS WHAT, STATED ONCE
## ---------------------------------------------------------------------------
## - G1 owns what each level requires. This file asks it and never restates it.
## - G2 owns each level's offer root seed. This file asks it and never restates it.
## - E2 owns each atomic one-level lifecycle: awards, the active-offer boundary,
##   the frozen requirement, the composition, the choice transaction and the
##   single advance. This file forwards to it and decides none of it.
## - G3 owns lawful continuation. This file calls it once per successful choice
##   and keeps only what it returns.
## - This file owns the ORDER in which those are asked, the one run seed, and the
##   single-successor rule D-268 ruling 2 placed here.
##
##
## THE OPENING ORDER IS THE CONTRACT (D-268 ruling 4, D-266 ruling 1)
## ---------------------------------------------------------------------------
## 1. A lifecycle already holding an offer cannot open another, whatever else is
##    true, so that is asked first.
## 2. G1 is asked for the current level's requirement, and its `ok` is asked
##    before its requirement is converted or forwarded.
## 3. The current lifecycle is asked whether that requirement is met; if not, no
##    seed is derived and no offer is composed.
## 4. G2 is asked for the current level's root seed from the run seed, and its
##    `ok` is asked before its seed is read or forwarded. A refused reading's
##    stand-in is a number the offer composer would read as a real seed, so it
##    must never reach the lifecycle.
## 5. The current lifecycle's ledger is asked whether that exact root seed has
##    already been consumed. If it has, the attempt is refused HERE, before the
##    lifecycle is asked to open anything — because the lifecycle would open it,
##    opening is not consuming, and an offer on a spent seed can never be taken
##    and never be withdrawn. This preflight is in addition to the choice
##    transaction's own final defence, not instead of it.
## 6. Only then is the lifecycle asked to open the offer, with the requirement and
##    the root seed this file was just given.
##
## TWO OF THOSE GATES CANNOT CLOSE TODAY, AND THAT IS STATED RATHER THAN HIDDEN.
## G1 refuses only below Level 1 and beyond a representation boundary hundreds of
## trillions of levels away, and G2 refuses only below Level 1; a lifecycle begins
## at Level 1 and gains one level per choice. And G2 hands consecutive levels of
## one run distinct root seeds for the first 2^32 levels, so a spent seed cannot
## come round again in any run that could be played. The gates stay because the
## rulings above make them mandatory, and because they are the shape that stays
## correct if any of those facts moves.
##
##
## ONE CHOICE, ONE LEVEL, AND SURPLUS NEVER ADVANCES ANYTHING BY ITSELF
## ---------------------------------------------------------------------------
## Taking a lane asks the current lifecycle to take it. A refusal leaves that same
## lifecycle, and its standing offer, exactly as they were. A success replaces the
## completed lifecycle with the one continuation asked for it, which begins with
## no offer. If the retained experience already meets the next requirement, that
## next level-up is still not opened, offered or taken until a caller explicitly
## asks for each step: there is no loop, no queue and no recursion here.
##
## THE RESULT CARRIES THE REPRODUCTION PAIR. Every choice answers a run-level
## record holding the exact run seed and the level the offer was asked at (D-266
## ruling 3), beside a copy of the one-level receipt.
##
##
## THE RUN SEED IS ACCEPTED AS GIVEN. Every signed 64-bit integer is a run seed G2
## answers for, so none is masked, folded or refused here. D-266 ruling 2 — that a
## GENERATED or PLAYER-VISIBLE run seed should come from 0 … 4,294,967,295 — binds
## whatever later chooses or shows a run seed, which nothing here does.
##
## STILL ABSENT, AND DELIBERATELY: experience sources of any kind, automatic
## opening, automatic or recursive multiple levels, a queue of pending offers,
## run-seed generation or display, support effects, applying any total to
## anything that lives, offer presentation, input, scenes, pausing, death, abandon,
## reset, saving and balance. No node, no signal, no clock, no random source, no
## file. Nothing that runs calls this file.

## The run seed, exactly as the run was begun with it.
var _run_seed: int

## The one current one-level lifecycle. Replaced by exactly one continuation after
## each successful choice, and never handed out.
var _current: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()


## A new run, seeded with `for_run_seed` and holding a fresh one-level lifecycle
## at its first level with no experience, no offer, no build and no spent seed.
func _init(for_run_seed: int) -> void:
	_run_seed = for_run_seed


# --- Reading the run --------------------------------------------------------------
#
# Scalars and copies only, every one delegated. Nothing here can move anything,
# and nothing here hands out an object this run still uses.

func run_seed() -> int:
	return _run_seed


func level() -> int:
	return _current.level()


func experience() -> float:
	return _current.experience()


## What the current level requires, as the accepted curve answers it — a fresh
## reading on every call, and the one place in this file the curve is asked.
func requirement_reading() -> RiftLevelRequirementReading:
	return RiftLevelRequirementCurve.requirement_for(_current.level())


func is_offer_active() -> bool:
	return _current.is_offer_active()


## The standing offer's root seed, meaningful only when `is_offer_active()` — the
## current lifecycle's own stand-in answers otherwise, unchanged.
func offer_root_seed() -> int:
	return _current.offer_root_seed()


func offer_lanes() -> Array[int]:
	return _current.offer_lanes()


func offer_identity_for(lane: int) -> PackedStringArray:
	return _current.offer_identity_for(lane)


## The standing offer's Support content kind and passive-fallback category (Roguelite
## I10, D-312), each the current lifecycle's own answer, unchanged — its unresolved
## values included.
func offer_support_content_kind() -> int:
	return _current.offer_support_content_kind()


func offer_support_fallback_category() -> int:
	return _current.offer_support_fallback_category()


func frozen_requirement() -> float:
	return _current.frozen_requirement()


func run_build() -> RiftRunBuild:
	return _current.run_build()


func consumption_ledger() -> RiftConsumptionLedger:
	return _current.consumption_ledger()


# --- Awarding experience -----------------------------------------------------------

## Forwarded whole to the current lifecycle, which evaluates Experience Gain from
## what the run holds at this moment, refuses every award while an offer stands,
## and moves nothing when it refuses. Its answer is returned verbatim.
func award_experience(base_experience: float) -> String:
	return _current.award_experience(base_experience)


# --- Opening the current level's offer --------------------------------------------

## Opens the current level's offer from the equipped Skill profiles, the support
## definitions and the passive-card definitions. The requirement and the root seed
## are never supplied by the caller: they are asked of G1 and G2 for the current
## level, in the order the header states. Returns "" when the offer opened, or the
## single plain-language reason it did not; a refusal leaves no offer standing and
## the run exactly as it was.
func open_current_offer(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	cards: Array[PassiveCardDefinition]
) -> String:
	var current_level: int = _current.level()
	if _current.is_offer_active():
		return "level %d already has an offer open; only a lane of that offer may be taken" \
			% current_level

	var needed: RiftLevelRequirementReading = requirement_reading()
	if not needed.ok:
		return "level %d has no requirement: %s" % [current_level, needed.failure_reason]
	var requirement: float = needed.experience_requirement()

	var readiness: RiftExperienceReading = _current.reading_for(requirement)
	if not (readiness.ok and readiness.ready):
		return "no offer opens yet for level %d — %s" % [current_level, readiness.describe()]

	var seed_reading: RiftLevelOfferSeedReading = RiftLevelOfferSeedDerivation.offer_root_seed_for(
		_run_seed, current_level)
	if not seed_reading.ok:
		return "level %d has no offer root seed: %s" % [current_level, seed_reading.failure_reason]
	var root_seed: int = seed_reading.offer_root_seed

	if _current.consumption_ledger().has_consumed(root_seed):
		return "level %d's offer root seed %d has already been consumed by this run; no offer opens" % [
			current_level, root_seed,
		]

	return _current.open_offer(requirement, profiles, definitions, cards, root_seed)


# --- Taking one lane ---------------------------------------------------------------

## Takes exactly one lane of the current level's standing offer. Always answers a
## run-level record carrying the exact run seed, the level the offer was asked at,
## and a copy of the one-level receipt.
##
## A REFUSAL MOVES NOTHING. The same current lifecycle is kept, with its offer
## still standing, so a caller may take a different lane of the same offer.
##
## A SUCCESS ADVANCES EXACTLY ONE LEVEL. The completed lifecycle is asked for its
## continuation exactly once, and only that continuation is kept; the completed
## one is no longer reachable from this run. Nothing further is opened or taken.
func choose(lane: int) -> RiftRunLevelUpResult:
	var asked_run_seed: int = _run_seed
	var source_level: int = _current.level()
	var outcome: RiftLevelUpResult = _current.choose(lane)
	if outcome.ok:
		_current = _current.next_level_coordinator()
	return RiftRunLevelUpResult.recorded(asked_run_seed, source_level, outcome)


# --- Presentation ---------------------------------------------------------------
#
# Reached by nothing above. The lifecycle renders itself; this adds the seed.

func describe() -> String:
	return "run seed %d; %s" % [_run_seed, _current.describe()]
