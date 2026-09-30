extends SceneTree
## Riftwrought — Roguelite Foundation G3 verification: the completed level-up
## continuation seam.
##
## ONE FOCUSED HEADLESS TEST OF ONE METHOD. Foundation G3 adds exactly one thing
## to the accepted single level-up coordinator: `next_level_coordinator()`, which
## answers null until that coordinator has completed its one level-up, and
## afterwards answers a NEW, independent coordinator built through the existing
## `with_state()` seam from the completed one's track, run build and ledger. It
## runs as a `SceneTree` script exactly as every earlier foundation suite does.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## EVERY "NOTHING MOVED" CLAIM COMPARES A WHOLE SNAPSHOT, AND THE SNAPSHOT CARRIES
## THE RANKS AND THE CARD FINGERPRINTS EXPLICITLY. Measured while this suite was
## written: the run build's own `describe()` renders a pair held at rank 1 and the
## same pair held at rank 2 as the SAME line, so a describe-only snapshot — the
## accepted E2 suite's shape, which was sufficient for a one-level lifecycle that
## never begins from a ranked build — would be blind to exactly the state a
## continuation exists to carry. Every pair's rank, every card's acquisition count
## and mechanical identity, and every consumed seed are therefore read one by one.
##
## IT RE-TESTS NOTHING THE CONTINUATION DOES NOT TOUCH. The offer, the choice
## transaction, the experience track and the run build each own their suites. What
## is tested here is the seam: when it answers, what it carries, what it begins,
## and that nothing on either side of it can reach the other.
##
## IT USES NO LEVEL CURVE AND NO SEED DERIVATION. Every requirement and every root
## seed below is an explicit test input to the accepted coordinator's
## caller-supplied contract, typed here. The accepted curve and the accepted seed
## derivation are named nowhere in this file — their class names are DERIVED from
## the engine's global class list by directory, so that the absence proof in the
## last check can hold for this file too without the file having to type them.

# --- The files this seam lives in and stands beside ------------------------------

const COORDINATOR_FILE: String = "res://scripts/levels/rift_level_up_coordinator.gd"
const RESULT_FILE: String = "res://scripts/levels/rift_level_up_result.gd"
const TRACK_FILE: String = "res://scripts/experience/rift_experience_track.gd"
const THIS_FILE: String = "res://tests/rift_level_up_continuation_verification.gd"

const LEVEL_SCRIPTS: Array[String] = [
	"res://scripts/levels/rift_level_up_coordinator.gd",
	"res://scripts/levels/rift_level_up_result.gd",
]

## Where the two accepted, deliberately unwired foundations G1 and G2 live. Their
## classes are found BY THIS PATH in the engine's global class list and are never
## typed into this file.
const UNWIRED_FOUNDATION_DIRECTORIES: Array[String] = [
	"res://scripts/level_requirements/",
	"res://scripts/level_seeds/",
]
const UNWIRED_FOUNDATION_CLASS_COUNT: int = 4

## FOUNDATION G4 (decision D-269) IS THE ONE CALLER OF THIS SEAM, AND G1 AND G2 ARE
## NAMED BY EXACTLY THREE FILES OUTSIDE THEIR OWN DIRECTORIES, EACH GRANT PER FILE AND
## PER DIRECTORY. The repeated run-level coordinator calls `next_level_coordinator()`
## once per successful choice — D-268 ruling 2 made single succession its obligation
## — and asks G1 for each level's requirement and G2 for each level's root seed; the
## run-level record re-derives its root through G2 alone. The grants are written as
## the DIRECTORIES whose classes each file may name, so this file still types no G1
## or G2 class name and the absence proof below still holds for it. Neither G4 file
## is itself called by anything that runs.
##
## THE THIRD GRANT IS H9's, AND IT CORRECTS A STALE GUARD (D-296). The accepted
## Experience Collection review has read G1's requirement for its experience bar
## since D-288 (accepted under D-290), while this table still named G4's two files
## as the only readers — so this suite has failed since D-288, found when D-295 next
## ran it. H9's review file may name what G1's directory declares and NOTHING of
## G2's. No other review file, and no I3 file, holds a grant; neither G4 row moved.
##
## THIS REPLACES TWO BLANKET ABSENCES ONE FOR ONE: the same single assertion is
## made either way, it still fails for any other file AND for any directory a
## listed file is not granted, and the pinned count does not move.
const RUN_LEVEL_COORDINATOR_FILE: String = "res://scripts/levels/rift_run_level_coordinator.gd"
const FOUNDATION_WIRING_GRANTS: Array = [
	["res://scripts/levels/rift_run_level_coordinator.gd", [
		"res://scripts/level_requirements/", "res://scripts/level_seeds/",
	]],
	["res://scripts/levels/rift_run_level_up_result.gd", ["res://scripts/level_seeds/"]],
	["res://scripts/roguelite/experience/roguelite_experience_collection_review.gd", [
		"res://scripts/level_requirements/",
	]],
]
const RUN_LEVEL_SCRIPTS: Array[String] = [
	"res://scripts/levels/rift_run_level_coordinator.gd",
	"res://scripts/levels/rift_run_level_up_result.gd",
]

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]
const PROJECT_SETTINGS_FILE: String = "res://project.godot"

## THE ONE NEW MEMBER, and the one row the accepted pins moved by.
const CONTINUATION_METHOD: String = "next_level_coordinator"
const CONTINUATION_SIGNATURE: String = "next_level_coordinator() -> Object"

## The coordinator's method list AS ACCEPTED under D-250 and extended by F5 under
## D-261 — eighteen members — retyped here, so that "exactly one method was added
## and nothing else moved" is a comparison against the accepted surface rather
## than against the file being checked.
const ACCEPTED_COORDINATOR_SIGNATURES: Array[String] = [
	"with_state(track: Object, build: Object, ledger: Object) -> Object",
	"level() -> int",
	"experience() -> float",
	"is_completed() -> bool",
	"is_offer_active() -> bool",
	"offer_root_seed() -> int",
	"offer_lanes() -> type 28",
	"offer_identity_for(lane: int) -> type 34",
	## Roguelite I10 (decision D-312): two readings of the standing offer, added in
	## their place; the continuation's own row is still the only one G3 adds.
	"offer_support_content_kind() -> int",
	"offer_support_fallback_category() -> int",
	"frozen_requirement() -> float",
	"reading_for(requirement: float) -> Object",
	"run_build() -> Object",
	"consumption_ledger() -> Object",
	"award_experience(base_experience: float) -> String",
	"open_offer(requirement: float, profiles: type 28, definitions: type 28,"
		+ " cards: type 28, root_seed: int) -> String",
	"choose(lane: int) -> Object",
	"_no_offer_reason() -> String",
	"describe() -> String",
	"_lifecycle_line() -> String",
]

## The member the new row follows. The method is declared after the choice
## section and before the presentation section.
const CONTINUATION_FOLLOWS: String = "_no_offer_reason() -> String"

const ACCEPTED_COORDINATOR_FIELDS: Array[String] = [
	"_track", "_build", "_ledger", "_offer", "_requirement", "_completed",
]

## THE WHOLE NEW METHOD, AS CODE. Four lines and no fifth: a signature, a guard
## that reads the completed flag, a null, and one delegation. Pinned whole, so the
## structural claims below are not the only thing standing between this seam and
## a quiet second statement.
const EXPECTED_METHOD_CODE: Array[String] = [
	"func next_level_coordinator() -> RiftLevelUpCoordinator:",
	"if not _completed:",
	"return null",
	"return RiftLevelUpCoordinator.with_state(_track, _build, _ledger)",
]
const EXPECTED_DELEGATION: String = "RiftLevelUpCoordinator.with_state(_track, _build, _ledger)"

## Every private field of the coordinator AND of the accepted experience track —
## the level and the progress live there — which the new method must not assign.
const UNASSIGNABLE_FIELDS: Array[String] = [
	"_level", "_progress", "_track", "_build", "_ledger", "_offer", "_requirement", "_completed",
]

## The accepted experience track's surface, retyped. G3 adds no setter and no
## reconstruction factory to it: a continuation's level and experience travel
## only inside the track's own `duplicated()`, reached through `with_state()`.
const ACCEPTED_TRACK_SIGNATURES: Array[String] = [
	"level() -> int",
	"progress() -> float",
	"award(base_experience: float, totals: Object) -> String",
	"requirement_problem(requirement: float) -> String",
	"reading_for(requirement: float) -> Object",
	"is_ready(requirement: float) -> bool",
	"remaining(requirement: float) -> float",
	"level_can_increment(level: int) -> bool",
	"advance_one_level(requirement: float) -> String",
	"duplicated() -> Object",
	"describe() -> String",
	"_shown(value: float) -> String",
]
const ACCEPTED_TRACK_FIELDS: Array[String] = ["_level", "_progress"]

## The accepted receipt's surface, retyped from its accepted F5 pin. G3 does not
## change it. Foundation G4 (decision D-269) later added exactly one row,
## `duplicated()`, after `problem()`, and no field. Roguelite Foundation I9
## (decision D-310) later added exactly two rows — `carries_support_fallback()` and
## `support_fallback_line()` — and appended exactly two fields, the Support content
## kind and the fallback category. G3 still changes none of it.
const ACCEPTED_RESULT_SIGNATURES: Array[String] = [
	"refused_without_a_seed(reason: String, requested_lane: int) -> Object",
	"refused(reason: String, for_root_seed: int, requested_lane: int) -> Object",
	"taken(from_choice: Object) -> Object",
	"granted_identity() -> type 34",
	"carries_support_progression() -> bool",
	"carries_support_fallback() -> bool",
	"problem() -> String",
	"duplicated() -> Object",
	"identity_line() -> String",
	"support_progression_line() -> String",
	"support_fallback_line() -> String",
	"describe() -> String",
	"_stated(reason: String) -> String",
]
const ACCEPTED_RESULT_FIELDS: Array[String] = [
	"ok", "failure_reason", "root_seed", "root_seed_known", "lane",
	"support_progression_kind", "support_rank_before", "support_rank_after",
	"_granted_identity",
	"support_content_kind", "support_fallback_category",
]

## What the brief forbids G3 to add, as member-name fragments over every method
## AND field name the coordinator declares. The exact pin above already refuses
## any extra member; this states the brief's list by name so a reader can see it.
const FORBIDDEN_MEMBER_FRAGMENTS: Array[String] = [
	"reset", "clear", "resurrect", "revive", "death", "abandon",
	"persist", "save", "load", "history", "queue", "pending", "loop", "auto",
]

# --- The explicit test inputs -------------------------------------------------------
#
# Every requirement and every root seed below is a caller-supplied input to the
# accepted coordinator, typed here. Nothing derives them.

## The two-level manual chain the brief describes.
const CHAIN_AWARD: float = 30.0
const CHAIN_FIRST_REQUIREMENT: float = 10.0
const CHAIN_FIRST_RETAINED: float = 20.0
const CHAIN_SECOND_REQUIREMENT: float = 20.0
const CHAIN_SECOND_RETAINED: float = 0.0
const CHAIN_FIRST_SEED: int = 12345
const CHAIN_SECOND_SEED: int = 314159

## What the chain's two offers carry, measured against the accepted mechanisms
## before being written here. At 314159 an EMPTY build's Support lane offers the
## pair the chain took at Level 1; the continuation's must offer the other one,
## which is what makes "the offer is composed against the carried build" a
## behavioural observation rather than a description.
const SKILL: StringName = &"quick_strike"
const REACHING: StringName = &"reaching_edge"
const SWEEPING: StringName = &"sweeping_edge"
const CHAIN_FIRST_SUPPORT: StringName = &"sweeping_edge"
const CHAIN_SECOND_SUPPORT: StringName = &"reaching_edge"
const CHAIN_SECOND_COMBAT_CARD: StringName = &"card_celerity"
const COMBAT_CARD_AT_ZERO: StringName = &"card_vitality"

## The exact-carry fixture: three awards and one requirement, chosen so the
## retained experience is NOT a round number. 150.1 minus 100 is not exactly
## 50.1 in a double, and that is the point — a continuation must carry the
## source's exact bits, whatever they are, and the expectation is derived
## independently through the accepted track rather than typed.
const CARRY_AWARDS: Array[float] = [50.0, 50.0, 50.1]
const CARRY_REQUIREMENT: float = 100.0
const CARRY_SEED: int = 0

## The ranked fixtures, the rank-increase seed the F3/F4/F5 suites document, and
## the first accepted E2 worked seed.
const RANK_REQUIREMENT: float = 100.0
const RANK_INCREASE_SEED: int = 18
const NEW_PAIR_SEED: int = 0

## The refusal fixture: a seeded lifecycle, so "nothing moved" is a claim about
## something rather than about an untouched default.
const SEEDED_PROGRESS: float = 40.0
const REFUSAL_REQUIREMENT: float = 40.0
const UNREACHED_REQUIREMENT: float = 100.0
const PRE_SPENT_SEED: int = 777
const OPEN_SEED: int = 2
const UNDECLARED_LANE: int = 7

## The accepted E2 and D3 refusal wordings this suite quotes, typed independently.
const NO_OFFER_REASON: String = "no offer is open; one must be opened before a lane may be taken"
const SPENT_SEED_REASON: String = "root seed %d has already been consumed by this run"

const OWED_CHECKS: Array[String] = [
	"continuation_is_null_before_any_offer_and_while_an_offer_stands",
	"refused_operations_and_refused_choices_never_make_continuation_available",
	"a_completed_coordinator_continues_with_its_exact_level_experience_build_and_ledger",
	"the_continuation_begins_a_fresh_unfinished_lifecycle_with_no_offer",
	"carried_support_pairs_and_ranks_survive_the_continuation",
	"the_consumed_seed_stays_consumed_and_a_different_seed_completes_a_continuation",
	"two_sequential_explicit_lifecycles_reach_level_three_preserving_surplus",
	"the_source_stays_completed_and_unmoved_and_every_coordinator_is_independent",
	"the_production_change_is_one_delegating_method_and_nothing_else",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0
var _nulls: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation G3 — Completed Level-Up Continuation Seam (D-267) ===")

	_check_null_before_completion()
	_check_refusals_never_make_continuation_available()
	_check_exact_carry()
	_check_fresh_lifecycle()
	_check_supports_and_ranks_are_carried()
	_check_consumed_seed_stays_consumed()
	_check_two_sequential_lifecycles()
	_check_independence()
	_check_the_production_change()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT LEVEL-UP CONTINUATION VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT LEVEL-UP CONTINUATION VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. Null before completion --------------------------------------------------------

func _check_null_before_completion() -> void:
	print("")
	print("--- 1. Continuation is null before any offer and while an offer stands")

	## A DEFAULT COORDINATOR, the degenerate case, asked twice.
	var fresh: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()
	var fresh_before: String = _snapshot(fresh)
	_expect_null_and_unmoved(fresh, fresh_before, "a default coordinator")
	_expect_null_and_unmoved(fresh, fresh_before, "a default coordinator asked again")

	## A SEEDED ONE — progress, a ranked pair, a card and a spent seed — so the
	## unmoved claim is about something that could have moved.
	var lifecycle: RiftLevelUpCoordinator = _seeded_lifecycle()
	var before: String = _snapshot(lifecycle)
	_expect_null_and_unmoved(lifecycle, before, "a seeded coordinator before any offer")
	_expect_null_and_unmoved(lifecycle, before, "a seeded coordinator asked again")

	## WHILE AN OFFER STANDS.
	_expect_accepted(_open(lifecycle, REFUSAL_REQUIREMENT, OPEN_SEED),
		"opening the seeded coordinator's offer")
	_expect(lifecycle.is_offer_active() and not lifecycle.is_completed(),
		"the seeded offer does not stand: %s" % _snapshot(lifecycle))
	var standing: String = _snapshot(lifecycle)
	_expect_null_and_unmoved(lifecycle, standing, "a coordinator with an offer standing")
	_expect_null_and_unmoved(lifecycle, standing, "a coordinator with an offer standing, asked again")

	## POSITIVE CONTROL: the same lifecycle, once it takes a lane, DOES continue —
	## so the nulls above were caused by the missing completion, not by a method
	## that answers null for everything.
	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.UTILITY)
	_expect(outcome.ok, "the positive control's choice was refused: %s" % outcome.failure_reason)
	_expect(lifecycle.is_completed(), "the positive control did not complete")
	_expect(lifecycle.next_level_coordinator() != null,
		"a completed coordinator answered null")

	print("  %d continuation requests answered null, 0 moved anything; the completed control continued" % _nulls)
	_done("continuation_is_null_before_any_offer_and_while_an_offer_stands")


# --- 2. Refused operations and choices ---------------------------------------------------

func _check_refusals_never_make_continuation_available() -> void:
	print("")
	print("--- 2. Refused operations and refused choices never make continuation available")
	var nulls_before: int = _nulls

	## BEFORE ANY OFFER: every refusal the lifecycle can produce with nothing open.
	var lifecycle: RiftLevelUpCoordinator = _seeded_lifecycle()
	var before: String = _snapshot(lifecycle)
	_expect_refused_then_null(lifecycle, before, lifecycle.award_experience(-5.0),
		"a negative award")
	_expect_refused_then_null(lifecycle, before, lifecycle.award_experience(0.0),
		"a zero award")
	_expect_refused_then_null(lifecycle, before, lifecycle.award_experience(INF),
		"an infinite award")
	_expect_refused_then_null(lifecycle, before,
		_open(lifecycle, UNREACHED_REQUIREMENT, OPEN_SEED), "an open below the threshold")
	_expect_refused_then_null(lifecycle, before,
		_open(lifecycle, 0.0, OPEN_SEED), "an open against no requirement")
	_expect_refused_then_null(lifecycle, before,
		_open(lifecycle, NAN, OPEN_SEED), "an open against an unreadable requirement")
	for lane: int in [RiftOffer.Lane.SUPPORT, RiftOffer.Lane.COMBAT_DEFENCE, UNDECLARED_LANE]:
		var no_offer: RiftLevelUpResult = lifecycle.choose(lane)
		_expect_refused_result_then_null(lifecycle, before, no_offer, lane,
			"taking lane %d with no offer" % lane)
		_expect(no_offer.failure_reason == NO_OFFER_REASON,
			"taking lane %d with no offer was refused as: %s" % [lane, no_offer.failure_reason])

	## WHILE AN OFFER STANDS: the award gate, the second-open gate and an
	## undeclared lane.
	_expect_accepted(_open(lifecycle, REFUSAL_REQUIREMENT, OPEN_SEED), "opening the offer")
	var standing: String = _snapshot(lifecycle)
	_expect_refused_then_null(lifecycle, standing, lifecycle.award_experience(5.0),
		"an award while the offer stands")
	_expect_refused_then_null(lifecycle, standing,
		_open(lifecycle, REFUSAL_REQUIREMENT, OPEN_SEED + 1), "a second open")
	_expect_refused_result_then_null(lifecycle, standing, lifecycle.choose(UNDECLARED_LANE),
		UNDECLARED_LANE, "an undeclared lane")

	## POSITIVE CONTROL: the same standing offer then pays out, and only then does
	## a continuation exist.
	var taken: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect(taken.ok, "the declared lane after the refusals was refused: %s" % taken.failure_reason)
	_expect(lifecycle.next_level_coordinator() != null,
		"the lifecycle completed after its refusals and still answered null")

	## A REFUSED CHOICE OF A DECLARED LANE — the accepted transaction's own
	## single-consumption refusal, reached through a ledger that already holds the
	## offer's seed. Every declared lane is refused and none of them makes a
	## continuation available; this lifecycle can never complete, which is the
	## accepted coordinator's own behaviour for a spent seed, recorded in check 6.
	var spent: RiftLevelUpCoordinator = _seeded_lifecycle()
	_expect_accepted(_open(spent, REFUSAL_REQUIREMENT, PRE_SPENT_SEED),
		"opening an offer on a seed the ledger already holds")
	var spent_before: String = _snapshot(spent)
	for lane: int in RiftOffer.LANE_ORDER:
		var refused: RiftLevelUpResult = spent.choose(lane)
		_expect_refused_result_then_null(spent, spent_before, refused, lane,
			"taking declared lane %d of a spent seed" % lane)
		_expect(refused.failure_reason == SPENT_SEED_REASON % PRE_SPENT_SEED,
			"a spent seed's lane %d was refused as: %s" % [lane, refused.failure_reason])

	print("  %d refusals across both states, each followed by a null continuation and an unmoved lifecycle"
		% (_nulls - nulls_before))
	_done("refused_operations_and_refused_choices_never_make_continuation_available")


# --- 3. Exact carry -----------------------------------------------------------------------

func _check_exact_carry() -> void:
	print("")
	print("--- 3. A completed coordinator continues with its exact level, experience, build and ledger")

	var source: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()
	for award: float in CARRY_AWARDS:
		_expect_accepted(source.award_experience(award), "an exact-carry award of %s" % _exact(award))
	_expect_accepted(_open(source, CARRY_REQUIREMENT, CARRY_SEED), "the exact-carry offer")
	var outcome: RiftLevelUpResult = source.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect(outcome.ok, "the exact-carry choice was refused: %s" % outcome.failure_reason)
	_expect(outcome.identity_line() == String(COMBAT_CARD_AT_ZERO),
		"the exact-carry choice granted %s" % outcome.identity_line())

	## THE RETAINED EXPERIENCE, DERIVED INDEPENDENTLY through the accepted track:
	## the same three awards against empty totals and one advance.
	var reference: RiftExperienceTrack = RiftExperienceTrack.new()
	for award: float in CARRY_AWARDS:
		_expect_accepted(reference.award(award, PlayerStatTotals.new()), "a reference award")
	_expect_accepted(reference.advance_one_level(CARRY_REQUIREMENT), "the reference advance")

	var source_carried: String = _carried(source)
	var continuation: RiftLevelUpCoordinator = source.next_level_coordinator()
	_expect(continuation != null, "a completed coordinator answered null")
	if continuation == null:
		_done("a_completed_coordinator_continues_with_its_exact_level_experience_build_and_ledger")
		return
	_expect(continuation != source, "the continuation IS the source")
	_expect(continuation is RiftLevelUpCoordinator, "the continuation is not a level-up coordinator")

	_expect(continuation.level() == source.level() and continuation.level() == reference.level(),
		"the level was not carried: source %d, continuation %d, reference %d" % [
			source.level(), continuation.level(), reference.level()])
	## `==` ON THE DOUBLES, not a tolerance: the carried value must be the same
	## bits, and a tolerance is exactly what would hide a re-derivation.
	_expect(continuation.experience() == source.experience()
			and continuation.experience() == reference.progress(),
		"the retained experience was not carried exactly: source %s, continuation %s, reference %s" % [
			_exact(source.experience()), _exact(continuation.experience()),
			_exact(reference.progress())])
	_expect(continuation.experience() != 50.1,
		"the retained experience is the round literal, so the exact-carry fixture proves less than it claims")
	_expect(_carried(continuation) == source_carried,
		"the carried state differs:\n    source       %s\n    continuation %s" % [
			source_carried, _carried(continuation)])

	## THE CARRIED PASSIVE ACQUISITION, field by field.
	var carried_build: RiftRunBuild = continuation.run_build()
	var source_build: RiftRunBuild = source.run_build()
	_expect(carried_build.acquisitions_for(COMBAT_CARD_AT_ZERO) == 1,
		"the continuation holds %d of %s" % [
			carried_build.acquisitions_for(COMBAT_CARD_AT_ZERO), COMBAT_CARD_AT_ZERO])
	_expect(not carried_build.mechanical_identity_for(COMBAT_CARD_AT_ZERO).is_empty()
			and carried_build.mechanical_identity_for(COMBAT_CARD_AT_ZERO)
				== source_build.mechanical_identity_for(COMBAT_CARD_AT_ZERO),
		"the card's mechanical identity was not carried: '%s' against '%s'" % [
			carried_build.mechanical_identity_for(COMBAT_CARD_AT_ZERO),
			source_build.mechanical_identity_for(COMBAT_CARD_AT_ZERO)])
	_expect(carried_build.passive_acquisitions() == source_build.passive_acquisitions()
			and carried_build.stat_totals().describe() == source_build.stat_totals().describe(),
		"the passive acquisitions or stat totals were not carried")
	var carried_seeds: PackedInt64Array = continuation.consumption_ledger().consumed_seeds()
	_expect(carried_seeds == source.consumption_ledger().consumed_seeds()
			and carried_seeds.size() == 1 and carried_seeds[0] == CARRY_SEED,
		"the ledger was not carried: %s" % str(carried_seeds))

	print("  Level %d with %s retained, %s x%d {%s}, seeds %s — carried exactly" % [
		continuation.level(), _exact(continuation.experience()), COMBAT_CARD_AT_ZERO,
		carried_build.acquisitions_for(COMBAT_CARD_AT_ZERO),
		carried_build.mechanical_identity_for(COMBAT_CARD_AT_ZERO), str(carried_seeds)])
	_done("a_completed_coordinator_continues_with_its_exact_level_experience_build_and_ledger")


# --- 4. A fresh lifecycle ---------------------------------------------------------------------

func _check_fresh_lifecycle() -> void:
	print("")
	print("--- 4. The continuation begins a fresh, unfinished lifecycle with no offer")

	## THE SOURCE CONSUMED ROOT SEED 0 ON PURPOSE. Zero is also what the no-offer
	## seed reading answers, so a continuation whose ledger holds zero and whose
	## seed reading answers zero is exactly the case where only the flag can say
	## whether an offer stands.
	var source: RiftLevelUpCoordinator = _completed_at(null, NEW_PAIR_SEED, RiftOffer.Lane.UTILITY)
	var continuation: RiftLevelUpCoordinator = source.next_level_coordinator()
	_expect(continuation != null, "a completed coordinator answered null")
	if continuation == null:
		_done("the_continuation_begins_a_fresh_unfinished_lifecycle_with_no_offer")
		return

	_expect(not continuation.is_completed(), "the continuation begins completed")
	_expect(not continuation.is_offer_active(), "the continuation begins with an offer standing")
	_expect(continuation.frozen_requirement() == RiftLevelUpCoordinator.NO_REQUIREMENT,
		"the continuation begins with %s frozen" % _exact(continuation.frozen_requirement()))
	_expect(continuation.offer_lanes().is_empty(),
		"the continuation reports %d lanes" % continuation.offer_lanes().size())
	for lane: int in [RiftOffer.Lane.SUPPORT, RiftOffer.Lane.COMBAT_DEFENCE,
			RiftOffer.Lane.UTILITY, UNDECLARED_LANE]:
		_expect(continuation.offer_identity_for(lane).is_empty(),
			"the continuation reports an identity for lane %d" % lane)

	## THE NO-OFFER SEED READING KEEPS ITS ACCEPTED MEANING: a stand-in, not a
	## sentinel. It answers the stand-in, which here EQUALS a seed the ledger
	## holds, and the flag is what says no offer stands.
	_expect(continuation.offer_root_seed() == RiftLevelUpCoordinator.UNSTATED_ROOT_SEED,
		"the no-offer seed reading answers %d" % continuation.offer_root_seed())
	_expect(continuation.consumption_ledger().has_consumed(RiftLevelUpCoordinator.UNSTATED_ROOT_SEED),
		"the fixture did not spend the stand-in seed, so this case proves nothing")
	_expect(not continuation.is_offer_active(),
		"the seed reading and the flag disagree about whether an offer stands")

	## IT IS UNFINISHED, NOT FINISHED-WITHOUT-AN-OFFER: a lane request is refused
	## with the no-offer reason and no seed, and the lifecycle can be advanced.
	var no_offer: RiftLevelUpResult = continuation.choose(RiftOffer.Lane.SUPPORT)
	_expect(not no_offer.ok and no_offer.failure_reason == NO_OFFER_REASON
			and not no_offer.root_seed_known,
		"a lane request on the fresh continuation answered: %s" % no_offer.describe())
	_refusals += 1
	_expect(continuation.next_level_coordinator() == null,
		"an unfinished continuation continued")
	_nulls += 1

	var second: RiftLevelUpCoordinator = source.next_level_coordinator()
	_expect_accepted(second.award_experience(CHAIN_AWARD), "an award to a fresh continuation")
	_expect(second.experience() > source.experience(),
		"a fresh continuation's award did not move it")
	_expect(not source.award_experience(CHAIN_AWARD).is_empty(),
		"the completed source accepted the award its continuation accepted")
	_refusals += 1

	print("  finished=%s offer=%s seed=%d (the stand-in, and a seed the ledger holds) requirement=%s lanes=0"
		% [str(continuation.is_completed()), str(continuation.is_offer_active()),
			continuation.offer_root_seed(), _exact(continuation.frozen_requirement())])
	_done("the_continuation_begins_a_fresh_unfinished_lifecycle_with_no_offer")


# --- 5. Supports and ranks ---------------------------------------------------------------------

func _check_supports_and_ranks_are_carried() -> void:
	print("")
	print("--- 5. Carried support pairs and ranks survive the continuation")

	## (a) A NEW PAIR THE CHOICE ITSELF GRANTED, 0 -> 1.
	var new_pair: RiftLevelUpCoordinator = _completed_at(null, NEW_PAIR_SEED, RiftOffer.Lane.SUPPORT)
	var new_pair_next: RiftLevelUpCoordinator = new_pair.next_level_coordinator()
	_expect_ranks(new_pair_next, {REACHING: 1}, "the new-pair continuation")
	_expect(_carried(new_pair_next) == _carried(new_pair),
		"the new-pair continuation differs:\n    %s\n    %s" % [
			_carried(new_pair), _carried(new_pair_next)])

	## (b) A SEPARATELY INITIALIZED RANK-2 PAIR the choice never touched, with a
	## card the choice DID grant beside it.
	var ranked: RiftRunBuild = RiftRunBuild.new()
	_expect_accepted(ranked.acquire_support(SKILL, REACHING), "acquiring the fixture pair")
	_expect_accepted(ranked.rank_support(SKILL, REACHING), "raising the fixture pair to rank 2")
	var held: RiftLevelUpCoordinator = _completed_at(ranked, NEW_PAIR_SEED, RiftOffer.Lane.COMBAT_DEFENCE)
	var held_next: RiftLevelUpCoordinator = held.next_level_coordinator()
	_expect_ranks(held_next, {REACHING: 2}, "the held-rank continuation")
	_expect(held_next.run_build().acquisitions_for(COMBAT_CARD_AT_ZERO) == 1,
		"the held-rank continuation lost the card granted beside the pair")
	_expect(_carried(held_next) == _carried(held),
		"the held-rank continuation differs:\n    %s\n    %s" % [_carried(held), _carried(held_next)])

	## (c) A RANK INCREASE THE CHOICE CONSUMED, 1 -> 2, from a pool with every
	## compatible pair already held.
	var exhausted: RiftRunBuild = RiftRunBuild.new()
	_expect_accepted(exhausted.acquire_support(SKILL, REACHING), "holding the first pair")
	_expect_accepted(exhausted.acquire_support(SKILL, SWEEPING), "holding the second pair")
	var raised: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, exhausted, null)
	_expect_accepted(raised.award_experience(RANK_REQUIREMENT), "the rank-increase award")
	_expect_accepted(_open(raised, RANK_REQUIREMENT, RANK_INCREASE_SEED), "the rank-increase offer")
	var receipt: RiftLevelUpResult = raised.choose(RiftOffer.Lane.SUPPORT)
	_expect(receipt.ok and receipt.support_rank_before == 1 and receipt.support_rank_after == 2,
		"the rank-increase choice answered %s, %s" % [receipt.describe(), receipt.support_progression_line()])
	var raised_next: RiftLevelUpCoordinator = raised.next_level_coordinator()
	_expect_ranks(raised_next, {REACHING: 1, SWEEPING: 2}, "the rank-increase continuation")
	_expect(raised_next.run_build().total_support_ranks() == 3,
		"the rank-increase continuation holds %d ranks" % raised_next.run_build().total_support_ranks())
	_expect(_carried(raised_next) == _carried(raised),
		"the rank-increase continuation differs:\n    %s\n    %s" % [_carried(raised), _carried(raised_next)])

	print("  new pair %s@1, held %s@2 beside %s x1, and %s@1 + %s@2 after a consumed 1 -> 2 — all carried"
		% [REACHING, REACHING, COMBAT_CARD_AT_ZERO, REACHING, SWEEPING])
	_done("carried_support_pairs_and_ranks_survive_the_continuation")


# --- 6. The consumed seed -----------------------------------------------------------------------

func _check_consumed_seed_stays_consumed() -> void:
	print("")
	print("--- 6. The consumed seed stays consumed; a different seed completes a continuation")

	var source: RiftLevelUpCoordinator = _chain_first_level()
	var source_before: String = _snapshot(source)
	var stale: RiftLevelUpCoordinator = source.next_level_coordinator()
	var ledger: RiftConsumptionLedger = stale.consumption_ledger()
	_expect(ledger.has_consumed(CHAIN_FIRST_SEED) and ledger.count() == 1,
		"the continuation's ledger does not hold the first offer's seed: %s" % ledger.describe())

	## OPENING IS NOT CONSUMING, AND THE ACCEPTED COORDINATOR DOES NOT CONSULT THE
	## LEDGER WHEN IT OPENS: the offer composes and stands. The protection is the
	## accepted choice transaction's, at the moment of consumption.
	_expect_accepted(_open(stale, CHAIN_SECOND_REQUIREMENT, CHAIN_FIRST_SEED),
		"opening an offer on the spent seed")
	var stale_before: String = _snapshot(stale)
	var refusals_here: int = 0
	for lane: int in RiftOffer.LANE_ORDER:
		## THE REFUSAL IS THE ACCEPTED TRANSACTION'S OWN, quoted rather than
		## restated: an independently composed offer, taken through the accepted
		## transaction against copies of the same state, gives the same sentence.
		var direct: RiftOfferChoiceResult = RiftOfferChoice.choose(
			RiftOfferComposition.compose(
				SkillSupportCatalogue.skill_profiles(),
				SkillSupportCatalogue.support_definitions(),
				stale.run_build().acquired_supports(),
				PassiveCardCatalogue.records(), CHAIN_FIRST_SEED),
			lane, stale.run_build(), stale.consumption_ledger())
		var refused: RiftLevelUpResult = stale.choose(lane)
		_expect_refused_result_then_null(stale, stale_before, refused, lane,
			"spending seed %d again through lane %d" % [CHAIN_FIRST_SEED, lane])
		_expect(refused.failure_reason == SPENT_SEED_REASON % CHAIN_FIRST_SEED
				and refused.failure_reason == direct.failure_reason,
			"lane %d was refused as '%s'; the accepted transaction says '%s'" % [
				lane, refused.failure_reason, direct.failure_reason])
		_expect(refused.root_seed_known and refused.root_seed == CHAIN_FIRST_SEED,
			"the refusal names seed %d (known %s)" % [refused.root_seed, str(refused.root_seed_known)])
		refusals_here += 1
	_expect(stale.consumption_ledger().count() == 1 and stale.level() == 2
			and stale.experience() == CHAIN_FIRST_RETAINED,
		"a refused spend moved the continuation: %s" % _snapshot(stale))

	## THE STALE OFFER CANNOT BE WITHDRAWN. The accepted coordinator has no
	## withdrawal, so this continuation refuses an award and a second open too, and
	## can never complete — the accepted one-offer rule, measured rather than
	## hidden. It is why a different seed is shown on a SECOND continuation.
	_expect_refused_then_null(stale, stale_before, stale.award_experience(CHAIN_AWARD),
		"an award behind the stale offer")
	_expect_refused_then_null(stale, stale_before,
		_open(stale, CHAIN_SECOND_REQUIREMENT, CHAIN_SECOND_SEED), "opening a fresh seed behind the stale offer")

	## A DIFFERENT EXPLICIT SEED COMPLETES A CONTINUATION OF THE SAME COMPLETED STATE.
	var onward: RiftLevelUpCoordinator = source.next_level_coordinator()
	_expect(onward.consumption_ledger().has_consumed(CHAIN_FIRST_SEED),
		"the second continuation forgot the spent seed")
	_expect_accepted(_open(onward, CHAIN_SECOND_REQUIREMENT, CHAIN_SECOND_SEED),
		"opening the different seed")
	var completed: RiftLevelUpResult = onward.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect(completed.ok and completed.root_seed == CHAIN_SECOND_SEED,
		"the different seed did not complete: %s" % completed.describe())
	var spent_now: PackedInt64Array = onward.consumption_ledger().consumed_seeds()
	_expect(onward.is_completed() and onward.level() == 3 and spent_now.size() == 2
			and spent_now[0] == CHAIN_FIRST_SEED and spent_now[1] == CHAIN_SECOND_SEED,
		"the completed continuation is %s" % _snapshot(onward))
	_expect(_snapshot(source) == source_before,
		"the source moved:\n    before %s\n    after  %s" % [source_before, _snapshot(source)])

	print("  seed %d still spent in the continuation; %d lanes refused with the transaction's own sentence, nothing moved"
		% [CHAIN_FIRST_SEED, refusals_here])
	print("  the stale offer cannot be withdrawn: that continuation refused an award and a second open and cannot complete")
	print("  a second continuation completed on seed %d: Level %d, seeds %s"
		% [CHAIN_SECOND_SEED, onward.level(), str(spent_now)])
	_done("the_consumed_seed_stays_consumed_and_a_different_seed_completes_a_continuation")


# --- 7. The two-level manual chain -------------------------------------------------------------

func _check_two_sequential_lifecycles() -> void:
	print("")
	print("--- 7. Two sequential explicit one-level lifecycles reach Level 3, preserving surplus")

	var first: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()
	_expect_accepted(first.award_experience(CHAIN_AWARD), "the chain's one award")
	_expect(first.experience() == CHAIN_AWARD, "the chain holds %s" % _exact(first.experience()))
	_expect_accepted(_open(first, CHAIN_FIRST_REQUIREMENT, CHAIN_FIRST_SEED), "the Level 1 offer")
	_expect(first.frozen_requirement() == CHAIN_FIRST_REQUIREMENT,
		"Level 1 froze %s" % _exact(first.frozen_requirement()))
	var first_support: PackedStringArray = first.offer_identity_for(RiftOffer.Lane.SUPPORT)
	var first_receipt: RiftLevelUpResult = first.choose(RiftOffer.Lane.SUPPORT)
	_expect(first_receipt.ok, "the Level 1 choice was refused: %s" % first_receipt.failure_reason)
	_expect(first_support.size() == 2 and StringName(first_support[1]) == CHAIN_FIRST_SUPPORT,
		"Level 1 offered [%s]" % ", ".join(first_support))
	_expect(first.level() == 2 and first.experience() == CHAIN_FIRST_RETAINED and first.is_completed(),
		"after Level 1: %s" % _snapshot(first))

	var second: RiftLevelUpCoordinator = first.next_level_coordinator()
	_expect(second != null and second.level() == 2 and second.experience() == CHAIN_FIRST_RETAINED,
		"the continuation begins at %s" % _snapshot(second))
	## THE CARRIED SURPLUS ALREADY MEETS THE NEXT REQUIREMENT, WITH NO AWARD.
	var reading: RiftExperienceReading = second.reading_for(CHAIN_SECOND_REQUIREMENT)
	_expect(reading.ok and reading.ready and reading.remaining == 0.0,
		"the carried surplus reads %s against %s" % [reading.describe(), _exact(CHAIN_SECOND_REQUIREMENT)])
	_expect_accepted(_open(second, CHAIN_SECOND_REQUIREMENT, CHAIN_SECOND_SEED), "the Level 2 offer")
	var second_support: PackedStringArray = second.offer_identity_for(RiftOffer.Lane.SUPPORT)
	var second_combat: PackedStringArray = second.offer_identity_for(RiftOffer.Lane.COMBAT_DEFENCE)

	## THE LEVEL 2 OFFER IS COMPOSED AGAINST THE CARRIED BUILD. The same seed on an
	## empty build offers the pair Level 1 took; the continuation offers the other.
	var empty_offer: RiftOffer = RiftOfferComposition.compose(
		SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(),
		null, PassiveCardCatalogue.records(), CHAIN_SECOND_SEED)
	var empty_support: PackedStringArray = empty_offer.identity_for(RiftOffer.Lane.SUPPORT)
	_expect(empty_support.size() == 2 and StringName(empty_support[1]) == CHAIN_FIRST_SUPPORT,
		"an empty build at seed %d offers [%s], so this comparison proves nothing"
			% [CHAIN_SECOND_SEED, ", ".join(empty_support)])
	_expect(second_support.size() == 2 and StringName(second_support[1]) == CHAIN_SECOND_SUPPORT,
		"the continuation offered [%s]" % ", ".join(second_support))
	_expect(second_combat.size() == 1 and StringName(second_combat[0]) == CHAIN_SECOND_COMBAT_CARD,
		"the continuation's Combat and Defence lane offered [%s]" % ", ".join(second_combat))

	var second_receipt: RiftLevelUpResult = second.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect(second_receipt.ok, "the Level 2 choice was refused: %s" % second_receipt.failure_reason)
	_expect(second.level() == 3, "the chain finished at Level %d" % second.level())
	_expect(second.experience() == CHAIN_SECOND_RETAINED,
		"the chain retained %s" % _exact(second.experience()))
	_expect(second.is_completed() and not second.is_offer_active()
			and second.frozen_requirement() == RiftLevelUpCoordinator.NO_REQUIREMENT,
		"the chain's second lifecycle did not close cleanly: %s" % _snapshot(second))
	var build: RiftRunBuild = second.run_build()
	_expect(build.support_rank_for(SKILL, CHAIN_FIRST_SUPPORT) == 1 and build.support_count() == 1
			and build.acquisitions_for(CHAIN_SECOND_COMBAT_CARD) == 1 and build.passive_acquisitions() == 1,
		"the chain's build is %s" % _held(second))
	var seeds: PackedInt64Array = second.consumption_ledger().consumed_seeds()
	_expect(seeds.size() == 2 and seeds[0] == CHAIN_FIRST_SEED and seeds[1] == CHAIN_SECOND_SEED,
		"the chain consumed %s" % str(seeds))

	## THE FIRST LIFECYCLE IS UNTOUCHED BY THE SECOND, AND THE CHAIN CAN GO ON.
	_expect(first.level() == 2 and first.experience() == CHAIN_FIRST_RETAINED
			and first.consumption_ledger().count() == 1,
		"the second lifecycle moved the first: %s" % _snapshot(first))
	var third: RiftLevelUpCoordinator = second.next_level_coordinator()
	_expect(third != null and third.level() == 3 and third.experience() == CHAIN_SECOND_RETAINED
			and not third.is_completed() and not third.is_offer_active()
			and third.consumption_ledger().count() == 2,
		"the Level 3 continuation begins at %s" % _snapshot(third))

	print("  award %s; Level 1 against %s -> Level 2 with %s retained; continue; Level 2 against %s -> Level 3 with %s retained"
		% [_exact(CHAIN_AWARD), _exact(CHAIN_FIRST_REQUIREMENT), _exact(first.experience()),
			_exact(CHAIN_SECOND_REQUIREMENT), _exact(second.experience())])
	print("  seed %d took %s -> %s; seed %d offered %s -> %s (an empty build offers %s) and took %s; seeds %s"
		% [CHAIN_FIRST_SEED, first_support[0], first_support[1], CHAIN_SECOND_SEED,
			second_support[0], second_support[1], empty_support[1], second_combat[0], str(seeds)])
	_done("two_sequential_explicit_lifecycles_reach_level_three_preserving_surplus")


# --- 8. Independence ----------------------------------------------------------------------------

func _check_independence() -> void:
	print("")
	print("--- 8. The source stays completed and unmoved, and every coordinator is independent")

	var source: RiftLevelUpCoordinator = _chain_first_level()
	var source_before: String = _snapshot(source)
	var one: RiftLevelUpCoordinator = source.next_level_coordinator()
	var two: RiftLevelUpCoordinator = source.next_level_coordinator()
	var two_before: String = _snapshot(two)
	_expect(one != source and two != source and one != two,
		"two continuations and the source are not three distinct coordinators")
	_expect(_snapshot(one) == two_before,
		"two continuations of one source begin in different states")

	## NO PRIVATE VALUE IS SHARED. Read by name, never written: each of the three
	## values a continuation is built from must be a different object in every pair.
	for field: String in ["_track", "_build", "_ledger"]:
		_expect(one.get(field) != null and one.get(field) != source.get(field)
				and two.get(field) != source.get(field) and one.get(field) != two.get(field),
			"the %s of two coordinators is one object" % field)

	## PROGRESSING ONE CONTINUATION REACHES NEITHER THE SOURCE NOR THE OTHER.
	_expect_accepted(one.award_experience(CHAIN_AWARD), "an award to the first continuation")
	_expect(one.experience() == CHAIN_FIRST_RETAINED + CHAIN_AWARD,
		"the first continuation holds %s" % _exact(one.experience()))
	_expect_accepted(_open(one, CHAIN_SECOND_REQUIREMENT, CHAIN_SECOND_SEED), "the first continuation's offer")
	var taken: RiftLevelUpResult = one.choose(RiftOffer.Lane.SUPPORT)
	_expect(taken.ok and one.level() == 3, "the first continuation did not complete: %s" % taken.describe())
	_expect(_snapshot(source) == source_before,
		"progressing a continuation moved the source:\n    before %s\n    after  %s" % [
			source_before, _snapshot(source)])
	_expect(_snapshot(two) == two_before,
		"progressing one continuation moved the other:\n    before %s\n    after  %s" % [
			two_before, _snapshot(two)])

	## THE SOURCE IS STILL COMPLETED AND STILL REFUSES EVERYTHING, UNMOVED.
	_expect(source.is_completed(), "the source is no longer completed")
	var refused_here: int = 0
	_expect_refused_and_unmoved(source, source_before, source.award_experience(CHAIN_AWARD),
		"an award to the source")
	_expect_refused_and_unmoved(source, source_before,
		_open(source, CHAIN_SECOND_REQUIREMENT, CHAIN_SECOND_SEED), "an open on the source")
	refused_here += 2
	for lane: int in [RiftOffer.Lane.SUPPORT, RiftOffer.Lane.COMBAT_DEFENCE,
			RiftOffer.Lane.UTILITY, UNDECLARED_LANE]:
		var refused: RiftLevelUpResult = source.choose(lane)
		_refusals += 1
		_expect(not refused.ok and _snapshot(source) == source_before,
			"lane %d on the source answered %s" % [lane, refused.describe()])
		refused_here += 1

	## AND IT STILL CONTINUES FROM ITS OWN STATE, NOT FROM A CONTINUATION'S.
	var three: RiftLevelUpCoordinator = source.next_level_coordinator()
	_expect(three != null and _snapshot(three) == two_before,
		"a later continuation of the source begins at %s, not %s" % [_snapshot(three), two_before])

	## SNAPSHOTS HANDED OUT BY EITHER SIDE ARE THEIR OWN. Distinct objects, and
	## mutating each reaches no coordinator.
	var source_build: RiftRunBuild = source.run_build()
	var two_build: RiftRunBuild = two.run_build()
	var source_ledger: RiftConsumptionLedger = source.consumption_ledger()
	var two_ledger: RiftConsumptionLedger = two.consumption_ledger()
	_expect(source_build != two_build and source_ledger != two_ledger,
		"the source and its continuation handed out one object")
	_expect_accepted(source_build.acquire_support(SKILL, REACHING), "mutating the source's build copy")
	_expect_accepted(two_build.acquire_support(SKILL, REACHING), "mutating the continuation's build copy")
	_expect(source_ledger.consume(CHAIN_SECOND_SEED) and two_ledger.consume(CHAIN_SECOND_SEED),
		"mutating the two ledger copies")
	_expect(source_build.support_count() == 2 and two_ledger.count() == 2,
		"the copies were not actually mutated")
	_expect(_snapshot(source) == source_before and _snapshot(two) == two_before
			and _snapshot(three) == two_before,
		"mutating a handed-out copy moved a coordinator")

	print("  3 continuations of one source, 0 shared private values; progressing one moved neither the source nor another")
	print("  %d operations refused on the completed source, unmoved; 4 handed-out copies mutated, 0 coordinators moved"
		% refused_here)
	_done("the_source_stays_completed_and_unmoved_and_every_coordinator_is_independent")


# --- 9. The production change ---------------------------------------------------------------------

func _check_the_production_change() -> void:
	print("")
	print("--- 9. The production change is one delegating method and nothing else")

	## EXACTLY ONE MEMBER WAS ADDED, IN ITS PLACE, AND NO OTHER MOVED.
	var signatures: PackedStringArray = _signatures_of(COORDINATOR_FILE)
	var expected: PackedStringArray = PackedStringArray(ACCEPTED_COORDINATOR_SIGNATURES)
	expected.insert(expected.find(CONTINUATION_FOLLOWS) + 1, CONTINUATION_SIGNATURE)
	_expect(", ".join(signatures) == ", ".join(expected),
		"the coordinator declares: %s" % ", ".join(signatures))
	var without: PackedStringArray = signatures.duplicate()
	var at: int = without.find(CONTINUATION_SIGNATURE)
	if at >= 0:
		without.remove_at(at)
	_expect(at >= 0 and ", ".join(without) == ", ".join(PackedStringArray(ACCEPTED_COORDINATOR_SIGNATURES)),
		"removing the one new member does not leave the accepted surface")
	_expect(signatures.size() == ACCEPTED_COORDINATOR_SIGNATURES.size() + 1 and signatures.count(CONTINUATION_SIGNATURE) == 1,
		"the coordinator declares %d methods" % signatures.size())

	var fields: PackedStringArray = _fields_of(RiftLevelUpCoordinator.new())
	_expect(", ".join(fields) == ", ".join(PackedStringArray(ACCEPTED_COORDINATOR_FIELDS)),
		"the coordinator carries the fields: %s" % ", ".join(fields))

	var named: PackedStringArray = PackedStringArray()
	for member: String in _names_of(signatures) + fields:
		for fragment: String in FORBIDDEN_MEMBER_FRAGMENTS:
			if member.to_lower().contains(fragment):
				named.append("%s (%s)" % [member, fragment])
	_expect(named.is_empty(), "the coordinator declares forbidden member(s): %s" % ", ".join(named))

	## THE METHOD, AS CODE, IS EXACTLY FOUR LINES.
	var raw: String = FileAccess.get_file_as_string(COORDINATOR_FILE)
	var code: String = _code_only(raw)
	var body: PackedStringArray = _method_code(code, "func %s(" % CONTINUATION_METHOD)
	_expect(" | ".join(body) == " | ".join(PackedStringArray(EXPECTED_METHOD_CODE)),
		"the new method reads: %s" % " | ".join(body))
	var body_text: String = "\n".join(body)

	## IT DELEGATES THROUGH `with_state()`, ONCE, WITH THE THREE PRIVATE VALUES.
	_expect(body_text.count("with_state(") == 1 and body_text.count(EXPECTED_DELEGATION) == 1,
		"the new method does not delegate once through with_state()")
	_expect(code.count("with_state(") == 2,
		"the coordinator's code names with_state( %d times — a declaration and one call are owed"
			% code.count("with_state("))
	_expect(not body_text.contains(".new(") and not body_text.contains("duplicated("),
		"the new method constructs or copies something itself")

	## IT ASSIGNS NOTHING. Not one `=` in its code — so no field of either
	## coordinator and no field of the track can be written there.
	_expect(body_text.count("=") == 0, "the new method's code contains an assignment")
	## MATCHED AS WHOLE IDENTIFIERS, NOT AS SUBSTRINGS. This suite's first run
	## failed here on a correct file: `_level` is a substring of the method's own
	## name, `next_level_coordinator`. A substring is not a statement — F5's
	## lesson — so a field counts only where no letter, digit or underscore
	## touches it on either side. Proved in both directions just below.
	var reached: PackedStringArray = PackedStringArray()
	for field: String in ["_level", "_progress", "_offer", "_requirement"]:
		if _identifier_count(body_text, field) > 0:
			reached.append(field)
	_expect(reached.is_empty(), "the new method names %s" % ", ".join(reached))
	_expect(_identifier_count(body_text, "_completed") == 1,
		"the new method names the completed flag %d times, not only in its guard"
			% _identifier_count(body_text, "_completed"))
	_expect(_identifier_count("coordinator._level = 2", "_level") == 1
			and _identifier_count("func next_level_coordinator() -> X:", "_level") == 0,
		"the identifier matcher cannot tell a field from a fragment of a method name")

	## AND NOTHING ELSE IN THE FILE WRITES INTO ANOTHER OBJECT'S PRIVATE FIELD
	## BESIDE THE THREE WRITES `with_state()` HAS ALWAYS MADE.
	var crossing: RegEx = RegEx.create_from_string(
		"\\.(%s)\\s*=(?!=)" % "|".join(PackedStringArray(UNASSIGNABLE_FIELDS)))
	var writes: PackedStringArray = PackedStringArray()
	for found: RegExMatch in crossing.search_all(code):
		writes.append(found.get_string(1))
	var with_state_code: String = "\n".join(_method_code(code, "static func with_state("))
	_expect(", ".join(writes) == "_track, _build, _ledger"
			and crossing.search_all(with_state_code).size() == 3,
		"cross-object private writes: %s" % ", ".join(writes))

	## THE ACCEPTED TRACK GAINED NO SETTER AND NO FACTORY, AND THE RECEIPT DID NOT MOVE.
	_expect(", ".join(_signatures_of(TRACK_FILE)) == ", ".join(PackedStringArray(ACCEPTED_TRACK_SIGNATURES)),
		"the experience track declares: %s" % ", ".join(_signatures_of(TRACK_FILE)))
	_expect(", ".join(_fields_of(RiftExperienceTrack.new())) == ", ".join(PackedStringArray(ACCEPTED_TRACK_FIELDS)),
		"the experience track carries: %s" % ", ".join(_fields_of(RiftExperienceTrack.new())))
	_expect(", ".join(_signatures_of(RESULT_FILE)) == ", ".join(PackedStringArray(ACCEPTED_RESULT_SIGNATURES)),
		"the receipt declares: %s" % ", ".join(_signatures_of(RESULT_FILE)))
	_expect(", ".join(_fields_of(RiftLevelUpResult.new())) == ", ".join(PackedStringArray(ACCEPTED_RESULT_FIELDS)),
		"the receipt carries: %s" % ", ".join(_fields_of(RiftLevelUpResult.new())))

	## NO G1 OR G2 CLASS IS NAMED — by the coordinator, by the receipt, by this
	## file, or by anything that runs outside those two foundations' own
	## directories. The names are DERIVED from the engine by directory.
	var unwired: PackedStringArray = _unwired_foundation_classes()
	_expect(unwired.size() == UNWIRED_FOUNDATION_CLASS_COUNT,
		"%d G1/G2 classes were found by directory, not %d, so the absence scan may be inert"
			% [unwired.size(), UNWIRED_FOUNDATION_CLASS_COUNT])
	var named_foundations: PackedStringArray = PackedStringArray()
	for path: String in LEVEL_SCRIPTS + [THIS_FILE]:
		var text: String = FileAccess.get_file_as_string(path)
		for name: String in unwired:
			if text.contains(name):
				named_foundations.append("%s names %s" % [path.get_file(), name])
	_expect(named_foundations.is_empty(), "%s" % ", ".join(named_foundations))

	## NOTHING THAT RUNS CALLS THE CONTINUATION BUT THE G4 RUN-LEVEL COORDINATOR,
	## AND G1 AND G2 ARE NAMED NOWHERE BUT THE THREE GRANTED FILES — G4's TWO (D-269)
	## AND H9's REVIEW, WHICH MAY NAME G1's CLASSES ALONE (D-296).
	var project_files: int = 0
	var callers: PackedStringArray = PackedStringArray()
	var wirings: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			project_files += 1
			var text: String = FileAccess.get_file_as_string(path)
			if path != COORDINATOR_FILE and path != RUN_LEVEL_COORDINATOR_FILE \
					and text.contains(CONTINUATION_METHOD):
				callers.append(path.get_file())
			if _is_under_unwired_directory(path):
				continue
			for name: String in unwired:
				if text.contains(name) and not _granted_file_may_name(path, name):
					wirings.append("%s names %s" % [path.get_file(), name])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	if settings.contains(CONTINUATION_METHOD):
		callers.append("project.godot")
	for name: String in unwired:
		if settings.contains(name):
			wirings.append("project.godot names %s" % name)
	_expect(callers.is_empty(), "running code names the continuation: %s" % ", ".join(callers))
	_expect(wirings.is_empty(), "G1 or G2 is wired: %s" % ", ".join(wirings))
	_expect(project_files > 100, "only %d project files were scanned" % project_files)
	_expect(raw.count("func %s(" % CONTINUATION_METHOD) == 1,
		"the coordinator declares the continuation %d times" % raw.count("func %s(" % CONTINUATION_METHOD))

	## `scripts/levels/` holds E2's two scripts and, since D-269, G4's two.
	var level_scripts: PackedStringArray = _files_under("res://scripts/levels", [".gd"])
	level_scripts.sort()
	var expected_scripts: PackedStringArray = PackedStringArray(LEVEL_SCRIPTS + RUN_LEVEL_SCRIPTS)
	expected_scripts.sort()
	_expect(", ".join(level_scripts) == ", ".join(expected_scripts),
		"scripts/levels/ holds: %s" % ", ".join(level_scripts))

	print("  %d coordinator methods (the accepted %d plus %s) and %d fields; the method is %d code lines with 0 assignments"
		% [signatures.size(), ACCEPTED_COORDINATOR_SIGNATURES.size(), CONTINUATION_METHOD,
			fields.size(), body.size()])
	print("  %d G1/G2 classes found by directory: named by 0 E2 files, by this suite, or by any running file outside the %d per-file grants (G4's two files; H9's review, G1 only); %d project files scanned, 0 call the continuation outside the G4 run coordinator"
		% [unwired.size(), FOUNDATION_WIRING_GRANTS.size(), project_files])
	print("  %d refusals and %d null continuations were driven across this suite" % [_refusals, _nulls])
	_done("the_production_change_is_one_delegating_method_and_nothing_else")


# --- Fixtures ---------------------------------------------------------------------------------

## A lifecycle that already holds progress, a ranked pair, a card and a spent
## seed, and has not yet reached any open. Built through the accepted seam.
func _seeded_lifecycle() -> RiftLevelUpCoordinator:
	var track: RiftExperienceTrack = RiftExperienceTrack.new()
	_expect_accepted(track.award(SEEDED_PROGRESS, PlayerStatTotals.new()), "seeding the track")
	var build: RiftRunBuild = RiftRunBuild.new()
	_expect_accepted(build.acquire_support(SKILL, REACHING), "seeding the pair")
	_expect_accepted(build.rank_support(SKILL, REACHING), "seeding the pair's rank")
	_expect_accepted(build.acquire_passive_card(_card(COMBAT_CARD_AT_ZERO)), "seeding the card")
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	_expect(ledger.consume(PRE_SPENT_SEED), "seeding the ledger")
	return RiftLevelUpCoordinator.with_state(track, build, ledger)


## A completed lifecycle: `build` (or an empty one), one award meeting the rank
## requirement, one offer at `root_seed`, and `lane` taken.
func _completed_at(build: RiftRunBuild, root_seed: int, lane: int) -> RiftLevelUpCoordinator:
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, build, null)
	_expect_accepted(lifecycle.award_experience(RANK_REQUIREMENT), "a fixture award")
	_expect_accepted(_open(lifecycle, RANK_REQUIREMENT, root_seed), "a fixture offer")
	var outcome: RiftLevelUpResult = lifecycle.choose(lane)
	_expect(outcome.ok and lifecycle.is_completed(),
		"a fixture choice of lane %d was refused: %s" % [lane, outcome.failure_reason])
	return lifecycle


## The two-level chain's first lifecycle, completed through its Support lane.
func _chain_first_level() -> RiftLevelUpCoordinator:
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()
	_expect_accepted(lifecycle.award_experience(CHAIN_AWARD), "the chain's award")
	_expect_accepted(_open(lifecycle, CHAIN_FIRST_REQUIREMENT, CHAIN_FIRST_SEED), "the chain's first offer")
	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.SUPPORT)
	_expect(outcome.ok, "the chain's first choice was refused: %s" % outcome.failure_reason)
	return lifecycle


func _open(lifecycle: RiftLevelUpCoordinator, requirement: float, root_seed: int) -> String:
	return lifecycle.open_offer(
		requirement,
		SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(),
		PassiveCardCatalogue.records(), root_seed
	)


func _card(card_id: StringName) -> PassiveCardDefinition:
	for record: PassiveCardDefinition in PassiveCardCatalogue.records():
		if record.card_id == card_id:
			return record
	return null


func _unwired_foundation_classes() -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		if _is_under_unwired_directory(String(entry.get("path", ""))):
			out.append(String(entry.get("class", "")))
	out.sort()
	return out


func _is_under_unwired_directory(path: String) -> bool:
	for directory: String in UNWIRED_FOUNDATION_DIRECTORIES:
		if path.begins_with(directory):
			return true
	return false


## Whether `path` is a file granted, by its own row, the directory that declares
## class `name` — G4's two files (D-269) and H9's review (D-296). The class's
## directory is read from the engine's global class list, so no G1 or G2 class name
## is typed here.
func _granted_file_may_name(path: String, name: String) -> bool:
	var declared_in: String = ""
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		if String(entry.get("class", "")) == name:
			declared_in = String(entry.get("path", ""))
	if declared_in.is_empty():
		return false
	for row: Array in FOUNDATION_WIRING_GRANTS:
		if String(row[0]) != path:
			continue
		for directory: String in row[1]:
			if declared_in.begins_with(directory):
				return true
		return false
	return false


# --- Assertions ---------------------------------------------------------------------------------

func _expect_accepted(refusal: String, described: String) -> void:
	_expect(refusal.is_empty(), "%s was refused: %s" % [described, refusal])


## The continuation answers null AND the whole lifecycle is exactly as it was.
func _expect_null_and_unmoved(
	lifecycle: RiftLevelUpCoordinator, before: String, described: String
) -> void:
	_nulls += 1
	_expect(lifecycle.next_level_coordinator() == null, "%s continued" % described)
	_expect(_snapshot(lifecycle) == before,
		"asking %s to continue moved it:\n    before %s\n    after  %s" % [
			described, before, _snapshot(lifecycle)])


## A refused operation that moved nothing, after which continuation is still null
## and asking for it moved nothing either.
func _expect_refused_then_null(
	lifecycle: RiftLevelUpCoordinator, before: String, refusal: String, described: String
) -> void:
	_expect_refused_and_unmoved(lifecycle, before, refusal, described)
	_expect_null_and_unmoved(lifecycle, before, "after %s, the lifecycle" % described)


func _expect_refused_and_unmoved(
	lifecycle: RiftLevelUpCoordinator, before: String, refusal: String, described: String
) -> void:
	_refusals += 1
	_expect(not refusal.strip_edges().is_empty(), "%s was accepted" % described)
	_expect(_snapshot(lifecycle) == before,
		"the refusal of %s moved the lifecycle:\n    before %s\n    after  %s" % [
			described, before, _snapshot(lifecycle)])


## A refused choice that granted nothing and moved nothing, after which
## continuation is still null.
func _expect_refused_result_then_null(
	lifecycle: RiftLevelUpCoordinator, before: String, outcome: RiftLevelUpResult,
	requested_lane: int, described: String
) -> void:
	_refusals += 1
	_expect(not outcome.ok and not outcome.failure_reason.strip_edges().is_empty()
			and outcome.granted_identity().is_empty() and outcome.lane == requested_lane
			and outcome.problem().is_empty(),
		"%s answered %s" % [described, outcome.describe()])
	_expect(_snapshot(lifecycle) == before,
		"the refusal of %s moved the lifecycle:\n    before %s\n    after  %s" % [
			described, before, _snapshot(lifecycle)])
	_expect_null_and_unmoved(lifecycle, before, "after %s, the lifecycle" % described)


## Exactly these pairs at exactly these ranks, and no other pair.
func _expect_ranks(lifecycle: RiftLevelUpCoordinator, ranks: Dictionary, described: String) -> void:
	_expect(lifecycle != null, "%s is null" % described)
	if lifecycle == null:
		return
	var build: RiftRunBuild = lifecycle.run_build()
	_expect(build.support_count() == ranks.size(),
		"%s holds %d pairs, not %d" % [described, build.support_count(), ranks.size()])
	for support: Variant in ranks:
		_expect(build.support_rank_for(SKILL, support as StringName) == int(ranks[support]),
			"%s holds %s at rank %d, not %d" % [
				described, support, build.support_rank_for(SKILL, support as StringName), int(ranks[support])])


# --- Snapshots -----------------------------------------------------------------------------------

## THE COMPLETE LIFECYCLE AS ONE LINE: both flags, the offer's whole identity, the
## frozen requirement, and everything `_carried()` reads.
func _snapshot(lifecycle: RiftLevelUpCoordinator) -> String:
	if lifecycle == null:
		return "no coordinator"
	var lanes: PackedStringArray = PackedStringArray()
	for lane: int in lifecycle.offer_lanes():
		lanes.append("%d:%s" % [lane, " -> ".join(lifecycle.offer_identity_for(lane))])
	return "finished=%s offer=%s seed=%d requirement=%s lanes=[%s] | %s" % [
		str(lifecycle.is_completed()), str(lifecycle.is_offer_active()),
		lifecycle.offer_root_seed(), _exact(lifecycle.frozen_requirement()),
		", ".join(lanes), _carried(lifecycle),
	]


## EXACTLY WHAT A CONTINUATION OWES TO CARRY: the level, the retained experience
## to seventeen decimal places, and everything `_held()` reads.
func _carried(lifecycle: RiftLevelUpCoordinator) -> String:
	return "level=%d experience=%s | %s" % [
		lifecycle.level(), _exact(lifecycle.experience()), _held(lifecycle),
	]


## The build and the ledger, with every pair's RANK and every card's COUNT and
## MECHANICAL IDENTITY read one by one — the build's own `describe()` renders two
## different ranks as the same line.
func _held(lifecycle: RiftLevelUpCoordinator) -> String:
	var build: RiftRunBuild = lifecycle.run_build()
	var ranks: PackedStringArray = PackedStringArray()
	for pair: String in build.support_pairs():
		var parts: PackedStringArray = pair.split(" -> ")
		ranks.append("%s@%d" % [pair, build.support_rank_for(StringName(parts[0]), StringName(parts[1]))])
	var cards: PackedStringArray = PackedStringArray()
	for card_id: StringName in build.acquired_card_ids():
		cards.append("%s x%d {%s}" % [
			card_id, build.acquisitions_for(card_id), build.mechanical_identity_for(card_id)])
	return "%s | ranks [%s] | cards [%s] | seeds %s" % [
		build.describe(), ", ".join(ranks), ", ".join(cards),
		str(lifecycle.consumption_ledger().consumed_seeds()),
	]


func _exact(value: float) -> String:
	return String.num(value, 17)


# --- Source reading --------------------------------------------------------------------------------

func _code_only(source: String) -> String:
	var out: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


## The non-blank, stripped code lines of one method, from its declaration to the
## next declaration.
func _method_code(code: String, declaration: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var start: int = code.find(declaration)
	if start < 0:
		return out
	var end: int = code.length()
	for marker: String in ["\nfunc ", "\nstatic func ", "\nclass "]:
		var next: int = code.find(marker, start + 1)
		if next >= 0 and next < end:
			end = next
	for line: String in code.substr(start, end - start).split("\n"):
		if not line.strip_edges().is_empty():
			out.append(line.strip_edges())
	return out


## How many times `identifier` occurs in `code` with no letter, digit or
## underscore touching it on either side.
func _identifier_count(code: String, identifier: String) -> int:
	var bounded: RegEx = RegEx.create_from_string(
		"(?<![A-Za-z0-9_])%s(?![A-Za-z0-9_])" % identifier)
	return bounded.search_all(code).size()


func _names_of(signatures: PackedStringArray) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for signature: String in signatures:
		out.append(signature.get_slice("(", 0))
	return out


## Every method as `name(arg: Type, ...) -> Type`, in declaration order — the same
## rendering the accepted E2 and F5 pins use.
func _signatures_of(path: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var script: GDScript = load(path) as GDScript
	if script == null:
		return out
	for entry: Dictionary in script.get_script_method_list():
		var args: PackedStringArray = PackedStringArray()
		for argument: Dictionary in entry.get("args", []):
			args.append("%s: %s" % [
				String(argument.get("name", "")),
				_type_name(int(argument.get("type", 0))),
			])
		var returns: Dictionary = entry.get("return", {}) as Dictionary
		out.append("%s(%s) -> %s" % [
			String(entry.get("name", "")), ", ".join(args),
			_type_name(int(returns.get("type", 0))),
		])
	return out


func _type_name(type_id: int) -> String:
	match type_id:
		TYPE_NIL:
			return "void"
		TYPE_BOOL:
			return "bool"
		TYPE_INT:
			return "int"
		TYPE_FLOAT:
			return "float"
		TYPE_STRING:
			return "String"
		TYPE_OBJECT:
			return "Object"
		_:
			return "type %d" % type_id


func _fields_of(instance: Object) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for entry: Dictionary in instance.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			out.append(String(entry.get("name", "")))
	return out


func _files_under(root: String, extensions: Array[String]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open(root)
	if dir == null:
		return out
	dir.list_dir_begin()
	var entry: String = dir.get_next()
	while not entry.is_empty():
		if entry != "." and entry != "..":
			var full: String = root.path_join(entry)
			if dir.current_is_dir():
				out.append_array(_files_under(full, extensions))
			else:
				for extension: String in extensions:
					if entry.ends_with(extension):
						out.append(full)
						break
		entry = dir.get_next()
	dir.list_dir_end()
	return out


# --- The owed set -----------------------------------------------------------------------------------

func _check_every_check_ran() -> void:
	print("")
	print("--- Every check this suite owes actually reached its last line")
	var missing: PackedStringArray = PackedStringArray()
	for owed: String in OWED_CHECKS:
		if not _reached.has(owed):
			missing.append(owed)
	var extra: PackedStringArray = PackedStringArray()
	for ran: Variant in _reached:
		if not OWED_CHECKS.has(String(ran)):
			extra.append(String(ran))
	_expect(missing.is_empty(), "check(s) never completed: %s" % ", ".join(missing))
	_expect(extra.is_empty(), "check(s) ran that the suite does not owe: %s" % ", ".join(extra))
	print("  %d of %d owed checks completed" % [_reached.size(), OWED_CHECKS.size()])


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
