extends SceneTree
## Riftwrought — Roguelite Foundation F5 verification: Support progression
## propagated into the level-up receipt (decision D-260).
##
## ONE FOCUSED HEADLESS TEST. F5 adds no production file of its own: it extends
## the two accepted Foundation E2 scripts so the receipt a completed level-up
## returns keeps the Support progression the accepted choice transaction consumed
## — the kind, the rank before and the rank after — which is otherwise lost the
## moment the coordinator releases its one offer. So this suite needs no scene,
## no camera, no navigation, no rendering and no evidence frame, and it
## deliberately gets none. It runs as a `SceneTree` script exactly as every
## earlier foundation's suite does.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching its
## LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## WHAT THIS SUITE OWNS. The RECEIPT: that it carries exactly the progression the
## accepted choice result carried and nothing re-derived; that passive level-ups
## and every refusal carry none; that its permanent coherence is asked through the
## ONE shared transition rule; that it holds no reference to anything mutable; and
## that the coordinator's accepted one-level lifecycle did not move to make room
## for it. It does not re-prove the transaction (F4's suite), the composition
## (F3's), the continuation policy (F2's), ranked ownership (F1's) or the
## lifecycle itself (E2's) — E2's suite is rerun unchanged beside this one.
##
## THE EXPECTED ANSWERS ARE TYPED HERE, NOT READ FROM WHAT IS BEING CHECKED. The
## documented seeds, pairs, kinds and ranks were measured against the accepted
## mechanisms before they were written down, and every comparison against the
## accepted choice transaction is a comparison against an INDEPENDENTLY composed
## offer taken on an INDEPENDENT copy of the same pre-choice state — so "the
## receipt equals the choice" is two derivations agreeing, not one object read
## twice.
##
## THE ONE THING IT CANNOT OBSERVE IS RECORDED RATHER THAN DRESSED UP. Whether the
## coordinator COULD have re-derived the progression instead of copying it is a
## question about its source, not its behaviour: under today's rules a re-derived
## transition would produce the same three integers. So "copied, never
## re-derived" is proved STRUCTURALLY — the coordinator names no rank and no
## progression at all, and hands the whole successful result to the receipt's
## one-argument constructor — and behaviourally only in the direction that CAN
## fail: a receipt built from a hand-made choice result carries that result's
## values even where the build would say otherwise.

const RESULT_FILE: String = "res://scripts/levels/rift_level_up_result.gd"
const COORDINATOR_FILE: String = "res://scripts/levels/rift_level_up_coordinator.gd"

const E2_FILES: Array[String] = [
	"res://scripts/levels/rift_level_up_coordinator.gd",
	"res://scripts/levels/rift_level_up_result.gd",
]

## Foundation G4's two scripts (decision D-269), which share `scripts/levels/` with
## E2's and are the only running files granted E2's classes: the run-level
## coordinator names both, the run-level record names the receipt only. The same
## per-file, per-class grant the E2 suite carries, retyped here for this suite's
## own copy of that scan.
const RUN_LEVEL_READERS: Array = [
	["res://scripts/levels/rift_run_level_coordinator.gd", [
		"RiftLevelUpCoordinator", "RiftLevelUpResult",
	]],
	["res://scripts/levels/rift_run_level_up_result.gd", ["RiftLevelUpResult"]],
]

## Roguelite I2 (decision D-293): the one running file outside `scripts/levels/` granted
## an E2 class — the Playable Three-Lane Level-Up Choice Review, an isolated scene
## launched by name, which reads the receipt a choice carries to present it. It names
## the receipt and never the coordinator. Kept in its own table rather than added to
## the one above, whose paths are also the files `scripts/levels/` must hold. The same
## per-file, per-class grant the E2 suite carries; the same single assertion is made,
## and the pinned count does not move.
const REVIEW_READERS: Array = [
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", ["RiftLevelUpResult"]],
]

## The accepted suites whose allowlists or pins F5 moved, and the exact text each
## must now carry for the receipt. Read from their own sources, because a grant
## nobody can see is a grant that quietly stops meaning anything.
const F2_VERIFICATION: String = "res://tests/support_continuation_verification.gd"
const E2_VERIFICATION: String = "res://tests/rift_level_up_coordinator_verification.gd"

## The shared transition rule and its owner, and the call the receipt must make.
const SHARED_VALIDATOR: String = "RiftOffer.support_transition_problem("

## What the receipt's `problem()` prefixes the shared validator's answer with.
## Typed here so the verbatim-quotation proof is a comparison against an
## independent statement rather than against the file's own text.
const ILLEGAL_PREFIX: String = "the Support level-up granted an illegal progression: "

## The E2 lifecycle's accepted worked inputs, retyped.
const BASE_AWARD: float = 50.0
const REQUIREMENT: float = 100.0
const OVERFLOW_AWARD: float = 150.0
const EXPECTED_OVERFLOW: float = 50.0
const EXPECTED_LEVEL_AFTER: int = 2

## Foundation E2's accepted worked seed, and the seed Foundations F3 and F4
## document their rank example at. Measured against the shipped catalogues before
## they were written here.
const E2_SEED: int = 0
const RANK_SEED: int = 18

const EXPECTED_SKILL: StringName = &"quick_strike"
const EXPECTED_SUPPORT: StringName = &"reaching_edge"
const EXPECTED_OTHER_SUPPORT: StringName = &"sweeping_edge"
const EXPECTED_COMBAT_CARD: StringName = &"card_vitality"
const EXPECTED_UTILITY_CARD: StringName = &"card_magnetism"
const EXPECTED_COMBAT_STAT: StringName = &"maximum_life"
const EXPECTED_UTILITY_STAT: StringName = &"pickup_radius"
const EXPECTED_COMBAT_MAGNITUDE: float = 0.15
const EXPECTED_UTILITY_MAGNITUDE: float = 0.25

## The accepted presentation of E2's three worked receipts and of F4's two
## documented direct results, typed independently of both files.
const E2_SUPPORT_DESCRIBE: String = "root seed 0 spent; Support: quick_strike -> reaching_edge"
const E2_COMBAT_DESCRIBE: String = "root seed 0 spent; Combat and Defence: card_vitality"
const E2_UTILITY_DESCRIBE: String = "root seed 0 spent; Utility: card_magnetism"
const NEW_PAIR_LINE: String = "a new compatible pair, rank 0 -> 1"
const RANK_ONE_LINE: String = "another rank of a held pair, rank 1 -> 2"
## Foundation I5 (D-300) retired `RANK_TWO_LINE`: rank 2 is each shipped support's
## maximum, so no shipped state composes a 2 -> 3 progression for a receipt to carry.
const NO_PROGRESSION_LINE: String = "no support progression"

## The canonical Utility card a test-only record carries while declaring a Combat
## and Defence stat — Foundation E2's own reachable staging refusal, rebuilt.
const CANONICAL_UTILITY_ID: StringName = &"card_insight"

## A lane outside the declared set, a kind outside the declared two.
const UNDECLARED_LANE: int = 7
const UNDECLARED_KIND: int = 99

## How many root seeds the receipt-versus-choice corpus is measured over.
const SEED_SAMPLES: int = 16

## The receipt's whole shape, pinned exactly — an extra member and a missing one
## both fail the same comparison, and that is proved on the comparator itself.
## Foundation G4 (decision D-269) added exactly one row, `duplicated()`, in the
## position E2's pin gives it; no other row moved and no field was added.
## Roguelite Foundation I9 (decision D-310) later added exactly two rows —
## `carries_support_fallback()` and `support_fallback_line()`, each beside its
## progression counterpart, in the positions E2's pin gives them — and appended
## exactly two fields, `support_content_kind` and `support_fallback_category`. No
## other row or field moved.
const EXPECTED_RESULT_SIGNATURES: Array[String] = [
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

const EXPECTED_RESULT_FIELDS: Array[String] = [
	"ok", "failure_reason", "root_seed", "root_seed_known", "lane",
	"support_progression_kind", "support_rank_before", "support_rank_after",
	"_granted_identity",
	"support_content_kind", "support_fallback_category",
]

## The coordinator's accepted method shape, retyped from E2's pin. F5 changed one
## line of its body and none of its surface. Foundation G3 (decision D-267) later
## added exactly one row, `next_level_coordinator()`, in the position E2's pin
## gives it; no other row moved, and this check still asserts only that the
## surface is exactly the accepted one.
const EXPECTED_COORDINATOR_SIGNATURES: Array[String] = [
	"with_state(track: Object, build: Object, ledger: Object) -> Object",
	"level() -> int",
	"experience() -> float",
	"is_completed() -> bool",
	"is_offer_active() -> bool",
	"offer_root_seed() -> int",
	"offer_lanes() -> type 28",
	"offer_identity_for(lane: int) -> type 34",
	## Roguelite I10 (decision D-312) added exactly these two readings, in E2's pin's
	## own place; F5's surface assertion is otherwise unchanged.
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
	"next_level_coordinator() -> Object",
	"describe() -> String",
	"_lifecycle_line() -> String",
]

## Members the brief forbids the receipt to carry, by name, as properties AND as
## methods. Each is a way a compact historical record turns back into a live view.
const FORBIDDEN_MEMBERS: Array[String] = [
	"build", "run_build", "new_build", "ledger", "new_ledger", "consumption_ledger",
	"track", "experience", "level", "offer", "current_rank", "rank",
	"support_rank_for", "magnitude", "display_name", "skill_name", "support_name",
]

## What the receipt's code must never read or call: the mutable values a choice
## result carries, and every way of asking a build about a rank or a pair.
const RECEIPT_FORBIDDEN_CODE: Array[String] = [
	"new_build", "new_ledger", "support_rank_for", "has_support", "acquired_supports",
	"support_pairs", "rank_support", "acquire_support", "SupportContinuation.select",
	"ABSENT_RANK", "FIRST_RANK", "Kind.NEW_PAIR", "Kind.RANK_INCREASE",
]

## What the coordinator's code must never name, which is the structural half of
## "copied, never re-derived": it cannot re-derive what it cannot read.
const COORDINATOR_FORBIDDEN_CODE: Array[String] = [
	"rank", "progression", "chosen_identity", "has_support", "support_pairs",
	"outcome.root_seed", "outcome.lane",
]

const OWED_CHECKS: Array[String] = [
	"the_accepted_e2_new_pair_example_returns_a_new_pair_receipt",
	"an_exhausted_coordinator_returns_a_rank_increase_receipt",
	"a_state_with_one_pair_at_its_maximum_raises_only_the_other",
	"every_receipt_equals_its_underlying_d3_choice_over_a_corpus",
	"the_receipt_outlives_the_released_offer",
	"both_passive_lanes_grant_one_card_and_carry_no_progression",
	"every_refusal_carries_no_identity_and_no_progression",
	"tampered_stable_facts_make_problem_fail",
	"every_transition_is_judged_by_the_shared_validator",
	"nothing_mutable_can_reach_the_receipt",
	"the_receipt_shape_is_pinned_exactly_in_both_directions",
	"the_accepted_e2_lifecycle_is_unchanged",
	"the_accepted_f4_direct_result_is_unchanged",
	"the_progression_is_copied_and_never_re_derived",
	"the_scope_moved_exactly_where_the_receipt_required",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}

## Successes and refusals driven, counted so the per-outcome helpers make the
## pinned check count reproducible arithmetic rather than a number read off a run.
var _successes: int = 0
var _refusals: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation F5 — Support Progression in the Level-Up Receipt (D-260) ===")

	_check_the_accepted_e2_new_pair_example()
	_check_an_exhausted_coordinator_returns_a_rank_increase()
	_check_one_pair_at_its_maximum_raises_only_the_other()
	_check_every_receipt_equals_its_d3_choice()
	_check_the_receipt_outlives_the_released_offer()
	_check_both_passive_lanes()
	_check_every_refusal_carries_nothing()
	_check_tampered_stable_facts()
	_check_every_transition_is_judged_by_the_shared_validator()
	_check_nothing_mutable_can_reach_the_receipt()
	_check_the_receipt_shape_is_pinned()
	_check_the_accepted_e2_lifecycle_is_unchanged()
	_check_the_accepted_f4_direct_result_is_unchanged()
	_check_the_progression_is_copied()
	_check_the_scope()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT LEVEL-UP SUPPORT PROGRESSION VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT LEVEL-UP SUPPORT PROGRESSION VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. E2's accepted worked example ----------------------------------------------

func _check_the_accepted_e2_new_pair_example() -> void:
	print("")
	print("--- 1. E2's accepted new-pair example returns a NEW_PAIR 0 -> 1 receipt")

	var lifecycle: RiftLevelUpCoordinator = _open_lifecycle(null, E2_SEED, REQUIREMENT)
	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.SUPPORT)
	_expect_success(outcome, E2_SEED, RiftOffer.Lane.SUPPORT, "E2's worked example")

	_expect(outcome.carries_support_progression(),
		"the worked example's receipt carries no progression")
	_expect(outcome.support_progression_kind == SupportContinuationResult.Kind.NEW_PAIR,
		"the worked example's receipt declares kind %d" % outcome.support_progression_kind)
	_expect(outcome.support_rank_before == AcquiredSupports.ABSENT_RANK
			and outcome.support_rank_after == AcquiredSupports.FIRST_RANK,
		"the worked example's receipt moved %d -> %d" % [
			outcome.support_rank_before, outcome.support_rank_after])
	_expect(outcome.support_progression_line() == NEW_PAIR_LINE,
		"the worked example's progression reads '%s'" % outcome.support_progression_line())

	## THE IDENTITY IS EXACTLY THE SKILL THEN THE SUPPORT, and the progression is
	## nowhere inside it.
	var identity: PackedStringArray = outcome.granted_identity()
	_expect(identity.size() == 2 and StringName(identity[0]) == EXPECTED_SKILL
			and StringName(identity[1]) == EXPECTED_SUPPORT,
		"the worked example granted [%s]" % ", ".join(identity))
	_expect(outcome.identity_line() == "%s -> %s" % [EXPECTED_SKILL, EXPECTED_SUPPORT],
		"the worked example's identity line reads '%s'" % outcome.identity_line())

	## THE COORDINATOR-OWNED BUILD HOLDS EXACTLY THE ACQUIRED RANK.
	var build: RiftRunBuild = lifecycle.run_build()
	_expect(build.support_rank_for(EXPECTED_SKILL, EXPECTED_SUPPORT) == outcome.support_rank_after,
		"the run holds the pair at rank %d where the receipt says %d" % [
			build.support_rank_for(EXPECTED_SKILL, EXPECTED_SUPPORT), outcome.support_rank_after])
	_expect(build.support_count() == 1 and build.total_support_ranks() == 1,
		"the run holds %d pairs and %d ranks" % [build.support_count(), build.total_support_ranks()])

	print("  root seed %d: Support %s, %s; the run holds it at rank %d" % [
		outcome.root_seed, outcome.identity_line(), outcome.support_progression_line(),
		build.support_rank_for(EXPECTED_SKILL, EXPECTED_SUPPORT)])
	_done("the_accepted_e2_new_pair_example_returns_a_new_pair_receipt")


# --- 2. An exhausted coordinator ----------------------------------------------------

func _check_an_exhausted_coordinator_returns_a_rank_increase() -> void:
	print("")
	print("--- 2. An exhausted support pool returns a RANK_INCREASE 1 -> 2 receipt")

	var exhausted: RiftRunBuild = _build_at_rank(AcquiredSupports.FIRST_RANK)
	var lifecycle: RiftLevelUpCoordinator = _open_lifecycle(exhausted, RANK_SEED, REQUIREMENT)
	var offered: PackedStringArray = lifecycle.offer_identity_for(RiftOffer.Lane.SUPPORT)
	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.SUPPORT)
	_expect_success(outcome, RANK_SEED, RiftOffer.Lane.SUPPORT, "the exhausted rank choice")

	_expect(outcome.support_progression_kind == SupportContinuationResult.Kind.RANK_INCREASE,
		"the exhausted receipt declares kind %d" % outcome.support_progression_kind)
	_expect(outcome.support_rank_before == 1 and outcome.support_rank_after == 2,
		"the exhausted receipt moved %d -> %d, not 1 -> 2" % [
			outcome.support_rank_before, outcome.support_rank_after])
	_expect(outcome.support_progression_line() == RANK_ONE_LINE,
		"the exhausted receipt's progression reads '%s'" % outcome.support_progression_line())
	var identity: PackedStringArray = outcome.granted_identity()
	_expect(identity.size() == 2 and StringName(identity[0]) == EXPECTED_SKILL
			and StringName(identity[1]) == EXPECTED_OTHER_SUPPORT,
		"the exhausted receipt granted [%s]" % ", ".join(identity))
	_expect(", ".join(identity) == ", ".join(offered),
		"the receipt granted [%s] where the standing offer offered [%s]" % [
			", ".join(identity), ", ".join(offered)])

	var build: RiftRunBuild = lifecycle.run_build()
	_expect(build.support_rank_for(EXPECTED_SKILL, EXPECTED_OTHER_SUPPORT) == 2,
		"the raised pair holds rank %d"
			% build.support_rank_for(EXPECTED_SKILL, EXPECTED_OTHER_SUPPORT))
	_expect(build.support_rank_for(EXPECTED_SKILL, EXPECTED_SUPPORT) == 1,
		"the other pair moved to rank %d"
			% build.support_rank_for(EXPECTED_SKILL, EXPECTED_SUPPORT))
	_expect(build.support_count() == exhausted.support_count()
			and build.total_support_ranks() == exhausted.total_support_ranks() + 1,
		"the run holds %d pairs and %d ranks" % [build.support_count(), build.total_support_ranks()])

	print("  exhausted, root seed %d: Support %s, %s; the run holds it at rank %d" % [
		outcome.root_seed, outcome.identity_line(), outcome.support_progression_line(),
		build.support_rank_for(EXPECTED_SKILL, EXPECTED_OTHER_SUPPORT)])
	_done("an_exhausted_coordinator_returns_a_rank_increase_receipt")


# --- 3. One pair at its maximum ---------------------------------------------------

func _check_one_pair_at_its_maximum_raises_only_the_other() -> void:
	print("")
	print("--- 3. A state holding one pair at its maximum returns the OTHER pair's 1 -> 2 receipt")

	## MOVED ONE FOR ONE BY FOUNDATION I5 (D-300). This check used to hold every pair
	## at rank 2 and read back a 2 -> 3 receipt — a rank nothing defines. Rank 2 is
	## now each shipped support's maximum, so that state is EXHAUSTED and composes no
	## offer at all, which the I5 suite proves. What a separately initialized ranked
	## state can still return is the pair below its maximum: Reaching Edge is held at
	## rank 2 and Sweeping Edge at rank 1, and the receipt must read back Sweeping
	## Edge 1 -> 2 — the rank of the pair actually offered, not of the one beside it.
	var ranked: RiftRunBuild = _build_holding(2, 1)
	var lifecycle: RiftLevelUpCoordinator = _open_lifecycle(ranked, RANK_SEED, REQUIREMENT)
	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.SUPPORT)
	_expect_success(outcome, RANK_SEED, RiftOffer.Lane.SUPPORT, "the one-at-its-maximum choice")
	_expect(outcome.support_progression_kind == SupportContinuationResult.Kind.RANK_INCREASE
			and outcome.support_rank_before == 1 and outcome.support_rank_after == 2,
		"the one-at-its-maximum receipt declares kind %d, %d -> %d" % [
			outcome.support_progression_kind, outcome.support_rank_before,
			outcome.support_rank_after])
	_expect(outcome.support_progression_line() == RANK_ONE_LINE,
		"the one-at-its-maximum receipt's progression reads '%s'" % outcome.support_progression_line())
	var identity: PackedStringArray = outcome.granted_identity()
	_expect(identity.size() == 2 and StringName(identity[1]) == EXPECTED_OTHER_SUPPORT,
		"the one-at-its-maximum receipt granted [%s]" % ", ".join(identity))
	var build: RiftRunBuild = lifecycle.run_build()
	_expect(build.support_rank_for(EXPECTED_SKILL, EXPECTED_OTHER_SUPPORT) == 2,
		"the raised pair holds rank %d"
			% build.support_rank_for(EXPECTED_SKILL, EXPECTED_OTHER_SUPPORT))

	## A MIXED STATE, SO THE RECEIPT CANNOT BE READING ONE GLOBAL RANK — and, since
	## Foundation I5, so it cannot be offering the pair at its maximum. Sweeping Edge
	## is held at its maximum and Reaching Edge at rank 1: root seed 18, which raises
	## Sweeping Edge when every pair is at rank 1, must raise Reaching Edge instead,
	## and root seed 0 raises it too. Each must report the rank of the pair it
	## actually offered.
	var mixed_line: PackedStringArray = PackedStringArray()
	for row: Array in [
		[RANK_SEED, EXPECTED_SUPPORT, 1, 2],
		[E2_SEED, EXPECTED_SUPPORT, 1, 2],
	]:
		var mixed: RiftLevelUpCoordinator = _open_lifecycle(_mixed_build(), int(row[0]), REQUIREMENT)
		var taken: RiftLevelUpResult = mixed.choose(RiftOffer.Lane.SUPPORT)
		_expect_success(taken, int(row[0]), RiftOffer.Lane.SUPPORT, "the mixed-rank choice")
		var granted: PackedStringArray = taken.granted_identity()
		_expect(granted.size() == 2 and StringName(granted[1]) == StringName(row[1])
				and taken.support_rank_before == int(row[2])
				and taken.support_rank_after == int(row[3]),
			"mixed root seed %d granted [%s] %d -> %d" % [
				int(row[0]), ", ".join(granted), taken.support_rank_before,
				taken.support_rank_after])
		_expect(mixed.run_build().support_rank_for(EXPECTED_SKILL, StringName(row[1]))
				== taken.support_rank_after,
			"mixed root seed %d left the pair at rank %d" % [
				int(row[0]), mixed.run_build().support_rank_for(EXPECTED_SKILL, StringName(row[1]))])
		mixed_line.append("root seed %d raises %s %d -> %d" % [
			taken.root_seed, taken.identity_line(), taken.support_rank_before,
			taken.support_rank_after])

	print("  reaching_edge at its maximum, root seed %d: Support %s, %s; the run holds it at rank %d" % [
		outcome.root_seed, outcome.identity_line(), outcome.support_progression_line(),
		build.support_rank_for(EXPECTED_SKILL, EXPECTED_OTHER_SUPPORT)])
	print("  mixed ranks, sweeping_edge at its maximum: %s" % " and ".join(mixed_line))
	_done("a_state_with_one_pair_at_its_maximum_raises_only_the_other")


# --- 4. The receipt equals its D3 choice ------------------------------------------

func _check_every_receipt_equals_its_d3_choice() -> void:
	print("")
	print("--- 4. Every receipt equals the D3 choice for the same offer and pre-choice state")

	## FIVE PRE-CHOICE STATES — empty, one pair held, the pool exhausted at rank 1,
	## one pair at its maximum beside the other at rank 1, and the two pairs at
	## different ranks the other way round — so the corpus crosses new-pair and rank
	## offers in both directions. The fourth state held everything at rank 2 until
	## Foundation I5 (D-300) made that state exhausted, where it composes no offer;
	## it moved one for one to the mirror of the fifth.
	var states: Array = [
		["empty", RiftRunBuild.new()],
		["one held", _build_with_one_pair()],
		["exhausted", _build_at_rank(AcquiredSupports.FIRST_RANK)],
		["one pair at its maximum", _build_holding(2, 1)],
		["mixed", _mixed_build()],
	]
	var lifecycles: int = 0
	var new_pairs: int = 0
	var rank_increases: int = 0
	var passives: int = 0
	var disagreements: PackedStringArray = PackedStringArray()
	for state: Array in states:
		var pre_choice: RiftRunBuild = state[1]
		for seed_index: int in range(SEED_SAMPLES):
			for lane: int in RiftOffer.LANE_ORDER:
				lifecycles += 1
				var lifecycle: RiftLevelUpCoordinator = _open_lifecycle(
					pre_choice, seed_index, REQUIREMENT)
				## THE SAME OFFER: composed independently from the same inputs, and
				## asserted equal to the one the coordinator stands before it is taken.
				var offer: RiftOffer = _compose(pre_choice, seed_index)
				var same_offer: bool = lifecycle.offer_root_seed() == offer.root_seed
				for any_lane: int in RiftOffer.LANE_ORDER:
					if ", ".join(lifecycle.offer_identity_for(any_lane)) \
							!= ", ".join(offer.identity_for(any_lane)):
						same_offer = false
				var receipt: RiftLevelUpResult = lifecycle.choose(lane)
				## THE SAME PRE-CHOICE STATE: an independent copy, and a fresh ledger,
				## exactly what the coordinator was built with.
				var choice: RiftOfferChoiceResult = RiftOfferChoice.choose(
					offer, lane, pre_choice.duplicated(), RiftConsumptionLedger.new())
				var mismatch: String = _receipt_mismatch(receipt, choice)
				if not same_offer:
					mismatch = "the coordinator stood a different offer"
				if not mismatch.is_empty():
					disagreements.append("%s seed %d lane %d: %s" % [
						String(state[0]), seed_index, lane, mismatch])
				if receipt.carries_support_progression():
					if receipt.support_progression_kind == SupportContinuationResult.Kind.NEW_PAIR:
						new_pairs += 1
					else:
						rank_increases += 1
				else:
					passives += 1
	_expect(disagreements.is_empty(),
		"%d receipts disagree with their choice: %s" % [
			disagreements.size(), "; ".join(disagreements.slice(0, 4))])
	_expect(lifecycles == states.size() * SEED_SAMPLES * RiftOffer.LANE_ORDER.size(),
		"%d lifecycles were measured" % lifecycles)
	## THE CORPUS REALLY CROSSES BOTH KINDS, or "every receipt agrees" could be
	## about one kind only.
	_expect(new_pairs > 0 and rank_increases > 0,
		"the corpus drove %d new pairs and %d rank increases" % [new_pairs, rank_increases])
	_expect(passives == states.size() * SEED_SAMPLES * 2,
		"%d passive receipts were driven" % passives)

	print("  %d lifecycles over %d seeds, %d pre-choice states and 3 lanes: every receipt equals its D3 choice — %d new pairs, %d rank increases, %d passive" % [
		lifecycles, SEED_SAMPLES, states.size(), new_pairs, rank_increases, passives])
	_done("every_receipt_equals_its_underlying_d3_choice_over_a_corpus")


# --- 5. The receipt outlives its offer ----------------------------------------------

func _check_the_receipt_outlives_the_released_offer() -> void:
	print("")
	print("--- 5. The receipt keeps its facts after the coordinator releases the offer")

	var lifecycle: RiftLevelUpCoordinator = _open_lifecycle(
		_build_at_rank(AcquiredSupports.FIRST_RANK), RANK_SEED, REQUIREMENT)
	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.SUPPORT)
	_expect_success(outcome, RANK_SEED, RiftOffer.Lane.SUPPORT, "the released-offer choice")
	var at_commit: String = _receipt_line(outcome)

	## THE OFFER IS GONE FROM THE COORDINATOR — nothing it holds can answer what
	## was granted any more.
	var readable: int = 0
	for lane: int in RiftOffer.LANE_ORDER:
		readable += lifecycle.offer_identity_for(lane).size()
	_expect(not lifecycle.is_offer_active() and lifecycle.offer_lanes().is_empty()
			and readable == 0,
		"the coordinator still answers %d identifiers of its released offer" % readable)

	## LATER OPERATIONS, ALL REFUSED, AND NONE CAN REACH THE RECEIPT.
	var later: int = 0
	if not lifecycle.award_experience(BASE_AWARD).is_empty():
		later += 1
	if not _open(lifecycle, REQUIREMENT, RANK_SEED + 1).is_empty():
		later += 1
	for lane: int in [RiftOffer.Lane.SUPPORT, RiftOffer.Lane.COMBAT_DEFENCE]:
		var again: RiftLevelUpResult = lifecycle.choose(lane)
		_expect_refusal(again, "a lane taken after the release")
		later += 1
	_expect(later == 4, "%d of 4 later operations were refused" % later)
	_expect(_receipt_line(outcome) == at_commit,
		"the receipt moved after the release:\n    at commit %s\n    now       %s" % [
			at_commit, _receipt_line(outcome)])

	## AND IT OUTLIVES THE COORDINATOR ITSELF. Dropping the last reference to the
	## lifecycle is the strongest available form of "the receipt needs nothing it
	## came from".
	lifecycle = null
	_expect(_receipt_line(outcome) == at_commit and outcome.problem().is_empty(),
		"the receipt changed or became incoherent once its coordinator was gone")
	_expect(outcome.support_rank_before == 1 and outcome.support_rank_after == 2
			and outcome.support_progression_line() == RANK_ONE_LINE,
		"the receipt now reads %s" % outcome.support_progression_line())

	print("  the receipt outlived its released offer: %d lanes readable from the coordinator, " % readable
		+ "%d later operations refused, the receipt unmoved at %s" % [
			later, outcome.support_progression_line()])
	_done("the_receipt_outlives_the_released_offer")


# --- 6. Both passive lanes ------------------------------------------------------------

func _check_both_passive_lanes() -> void:
	print("")
	print("--- 6. Both passive lanes grant exactly one card and carry no progression")

	## E2's ACCEPTED PASSIVE EXAMPLES, UNCHANGED, and the same two lanes taken out
	## of a RANK offer, so "passive carries none" is not true only of new-pair offers.
	var shown: PackedStringArray = PackedStringArray()
	for row: Array in [
		[RiftOffer.Lane.COMBAT_DEFENCE, EXPECTED_COMBAT_CARD, EXPECTED_COMBAT_STAT,
			EXPECTED_COMBAT_MAGNITUDE, E2_COMBAT_DESCRIBE],
		[RiftOffer.Lane.UTILITY, EXPECTED_UTILITY_CARD, EXPECTED_UTILITY_STAT,
			EXPECTED_UTILITY_MAGNITUDE, E2_UTILITY_DESCRIBE],
	]:
		var lane: int = int(row[0])
		var lifecycle: RiftLevelUpCoordinator = _open_lifecycle(null, E2_SEED, REQUIREMENT)
		var outcome: RiftLevelUpResult = lifecycle.choose(lane)
		_expect_success(outcome, E2_SEED, lane, "E2's %s example" % RiftOffer.lane_label(lane))
		_expect_no_progression(outcome, "E2's %s example" % RiftOffer.lane_label(lane))
		var identity: PackedStringArray = outcome.granted_identity()
		_expect(identity.size() == 1 and StringName(identity[0]) == StringName(row[1]),
			"E2's %s example granted [%s]" % [RiftOffer.lane_label(lane), ", ".join(identity)])
		_expect(outcome.describe() == String(row[4]),
			"E2's %s example describes itself as '%s'" % [
				RiftOffer.lane_label(lane), outcome.describe()])
		var build: RiftRunBuild = lifecycle.run_build()
		_expect(build.total_for(StringName(row[2])) == float(row[3])
				and build.support_count() == 0 and build.passive_acquisitions() == 1,
			"E2's %s example left %s on %s, %d pairs, %d cards" % [
				RiftOffer.lane_label(lane), String.num(build.total_for(StringName(row[2])), 17),
				row[2], build.support_count(), build.passive_acquisitions()])

		var ranked: RiftLevelUpCoordinator = _open_lifecycle(
			_build_at_rank(AcquiredSupports.FIRST_RANK), RANK_SEED, REQUIREMENT)
		var rank_offer_kind: bool = ranked.offer_identity_for(RiftOffer.Lane.SUPPORT).size() == 2
		var from_rank_offer: RiftLevelUpResult = ranked.choose(lane)
		_expect_success(from_rank_offer, RANK_SEED, lane,
			"the %s lane of a rank offer" % RiftOffer.lane_label(lane))
		_expect_no_progression(from_rank_offer,
			"the %s lane of a rank offer" % RiftOffer.lane_label(lane))
		_expect(rank_offer_kind and from_rank_offer.granted_identity().size() == 1,
			"the %s lane of a rank offer granted [%s]" % [
				RiftOffer.lane_label(lane), ", ".join(from_rank_offer.granted_identity())])
		_expect(ranked.run_build().total_support_ranks()
				== _build_at_rank(AcquiredSupports.FIRST_RANK).total_support_ranks(),
			"the %s lane of a rank offer moved a rank" % RiftOffer.lane_label(lane))
		shown.append("%s: %s, %s" % [
			RiftOffer.lane_label(lane), outcome.identity_line(), outcome.support_progression_line()])

	print("  %s" % "; ".join(shown))
	print("  4 passive level-ups over new-pair AND rank offers: 0 carried a progression")
	_done("both_passive_lanes_grant_one_card_and_carry_no_progression")


# --- 7. Every refusal ---------------------------------------------------------------

func _check_every_refusal_carries_nothing() -> void:
	print("")
	print("--- 7. Every refusal carries no identity and no progression")

	var before: int = _refusals

	## Before any offer stands.
	var early: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()
	var no_offer: RiftLevelUpResult = early.choose(RiftOffer.Lane.SUPPORT)
	_expect_refusal(no_offer, "a lane taken before any offer stood")
	_expect(not no_offer.root_seed_known, "a refusal with no offer claims a seed")

	## An undeclared lane of a rank offer — the offer stands, so the seed is named.
	var ranked: RiftLevelUpCoordinator = _open_lifecycle(
		_build_at_rank(AcquiredSupports.FIRST_RANK), RANK_SEED, REQUIREMENT)
	var undeclared: RiftLevelUpResult = ranked.choose(UNDECLARED_LANE)
	_expect_refusal(undeclared, "an undeclared lane of a rank offer")
	_expect(undeclared.root_seed_known and undeclared.root_seed == RANK_SEED
			and undeclared.lane == UNDECLARED_LANE,
		"the undeclared-lane refusal echoes seed %d lane %d" % [
			undeclared.root_seed, undeclared.lane])
	## ...and the rank offer is still takeable, with its progression intact.
	var recovered: RiftLevelUpResult = ranked.choose(RiftOffer.Lane.SUPPORT)
	_expect_success(recovered, RANK_SEED, RiftOffer.Lane.SUPPORT,
		"the rank offer after a refused lane")
	_expect(recovered.support_progression_line() == RANK_ONE_LINE,
		"the recovered rank choice reads '%s'" % recovered.support_progression_line())

	## After completion: every lane, including the Support lane of the rank offer
	## that was just taken.
	for lane: int in [RiftOffer.Lane.SUPPORT, RiftOffer.Lane.COMBAT_DEFENCE,
			RiftOffer.Lane.UTILITY, UNDECLARED_LANE]:
		_expect_refusal(ranked.choose(lane), "lane %d after completion" % lane)

	## A CHOICE THE ACCEPTED TRANSACTION ITSELF REFUSES, QUOTED THROUGH THE
	## COORDINATOR, AND ON A RANK OFFER: the Support lane of the standing offer
	## carries a real progression, and the refused passive choice beside it must
	## still carry none. E2's own reachable staging refusal, rebuilt exactly — a
	## test-only record under the canonical Utility id declaring a Combat and
	## Defence stat, which the transaction resolves canonically and refuses.
	var swapped: Array[PassiveCardDefinition] = []
	swapped.append(PassiveCardDefinition.of(
		CANONICAL_UTILITY_ID, "Zz Probe Card", EXPECTED_COMBAT_STAT, 0.10, 100, true))
	swapped.append(PassiveCardCatalogue.record(EXPECTED_UTILITY_CARD))
	var disagreeing: RiftLevelUpCoordinator = _ready_lifecycle(
		_build_at_rank(AcquiredSupports.FIRST_RANK), REQUIREMENT)
	_expect(disagreeing.open_offer(REQUIREMENT,
			SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(),
			swapped, RANK_SEED).is_empty(),
		"the disagreeing record set did not open a rank offer")
	var refused_choice: RiftLevelUpResult = disagreeing.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect_refusal(refused_choice, "a catalogue disagreement quoted from the transaction")
	_expect(refused_choice.root_seed_known and refused_choice.root_seed == RANK_SEED
			and refused_choice.failure_reason.contains(String(CANONICAL_UTILITY_ID)),
		"the transaction refusal echoes seed %d and reads: %s" % [
			refused_choice.root_seed, refused_choice.failure_reason])
	var after_refusal: RiftLevelUpResult = disagreeing.choose(RiftOffer.Lane.SUPPORT)
	_expect_success(after_refusal, RANK_SEED, RiftOffer.Lane.SUPPORT,
		"the rank offer's Support lane after a refused passive lane")
	_expect(after_refusal.support_progression_line() == RANK_ONE_LINE,
		"the Support lane after a refusal reads '%s'" % after_refusal.support_progression_line())

	## THE CONSTRUCTOR'S OWN CONTRACT: nothing that is not a success becomes one.
	var from_null: RiftLevelUpResult = RiftLevelUpResult.taken(null)
	_expect_refusal(from_null, "taken() from no choice at all")
	_expect(not from_null.root_seed_known and from_null.lane == RiftOffer.UNRESOLVED_LANE,
		"taken(null) claims seed %d (known %s) and lane %d" % [
			from_null.root_seed, from_null.root_seed_known, from_null.lane])
	var refused_source: RiftOfferChoiceResult = RiftOfferChoiceResult.refused(
		"zz probe refusal", RANK_SEED, RiftOffer.Lane.SUPPORT)
	var from_refusal: RiftLevelUpResult = RiftLevelUpResult.taken(refused_source)
	_expect_refusal(from_refusal, "taken() from a refused choice")

	var driven: int = _refusals - before
	print("  %d refusals carried no identity and no progression" % driven)
	_done("every_refusal_carries_no_identity_and_no_progression")


# --- 8. Tampering -------------------------------------------------------------------

func _check_tampered_stable_facts() -> void:
	print("")
	print("--- 8. Tampering with any stable progression fact makes problem() fail")

	var new_pair: RiftLevelUpResult = _support_receipt(null, E2_SEED)
	var raised: RiftLevelUpResult = _support_receipt(
		_build_at_rank(AcquiredSupports.FIRST_RANK), RANK_SEED)
	_expect(new_pair.problem().is_empty() and raised.problem().is_empty(),
		"a fresh receipt is incoherent: '%s' / '%s'" % [new_pair.problem(), raised.problem()])

	var caught: int = 0
	var escaped: PackedStringArray = PackedStringArray()
	## [receipt, field, tampered value, described]
	for row: Array in [
		[new_pair, "support_progression_kind", SupportContinuationResult.Kind.RANK_INCREASE, "new pair declared a rank increase"],
		[new_pair, "support_rank_before", 1, "new pair from rank 1"],
		[new_pair, "support_rank_after", 2, "new pair to rank 2"],
		[new_pair, "support_progression_kind", UNDECLARED_KIND, "new pair of an undeclared kind"],
		[raised, "support_progression_kind", SupportContinuationResult.Kind.NEW_PAIR, "rank increase declared a new pair"],
		[raised, "support_rank_before", 2, "rank increase from 2 to 2"],
		[raised, "support_rank_before", 0, "rank increase from an absent rank"],
		[raised, "support_rank_after", 3, "rank increase by two"],
		[raised, "support_rank_after", 1, "rank increase that stood still"],
	]:
		var receipt: RiftLevelUpResult = row[0]
		var field: String = String(row[1])
		var original: int = int(receipt.get(field))
		receipt.set(field, int(row[2]))
		if receipt.problem().is_empty():
			escaped.append(String(row[3]))
		else:
			caught += 1
		receipt.set(field, original)
	_expect(escaped.is_empty(), "tampering escaped problem(): %s" % ", ".join(escaped))
	_expect(new_pair.problem().is_empty() and raised.problem().is_empty(),
		"a restored receipt is still incoherent: '%s' / '%s'" % [
			new_pair.problem(), raised.problem()])

	## A SUPPORT SUCCESS WITH UNRESOLVED PROGRESSION FAILS — tampered in place, and
	## built through the constructor from a hand-made choice result that carries
	## none, so the receipt is shown not to trust what it copies.
	var unresolved: RiftLevelUpResult = _support_receipt(null, E2_SEED)
	unresolved.support_progression_kind = RiftOffer.UNRESOLVED_PROGRESSION_KIND
	unresolved.support_rank_before = RiftOfferChoiceResult.NO_RANK
	unresolved.support_rank_after = RiftOfferChoiceResult.NO_RANK
	_expect(not unresolved.problem().is_empty(),
		"a Support success with no progression is coherent")
	_expect(not unresolved.carries_support_progression(),
		"a Support success with no progression claims to carry one")
	var hand_made: RiftOfferChoiceResult = RiftOfferChoiceResult.chosen(
		RANK_SEED, RiftOffer.Lane.SUPPORT,
		PackedStringArray([String(EXPECTED_SKILL), String(EXPECTED_SUPPORT)]),
		RiftOffer.UNRESOLVED_PROGRESSION_KIND,
		RiftOfferChoiceResult.NO_RANK, RiftOfferChoiceResult.NO_RANK,
		RiftRunBuild.new(), _ledger_with(RANK_SEED))
	var copied_unresolved: RiftLevelUpResult = RiftLevelUpResult.taken(hand_made)
	_expect(copied_unresolved.ok and not copied_unresolved.problem().is_empty(),
		"a receipt copied from an unresolved Support choice is coherent: '%s'"
			% copied_unresolved.problem())
	caught += 2

	## A PASSIVE SUCCESS CARRYING PROGRESSION FAILS, by kind, by ranks and by both.
	var passive: RiftLevelUpResult = _passive_receipt(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect(passive.problem().is_empty(), "a fresh passive receipt is incoherent")
	var passive_escaped: PackedStringArray = PackedStringArray()
	for row: Array in [
		[SupportContinuationResult.Kind.NEW_PAIR, RiftOfferChoiceResult.NO_RANK, RiftOfferChoiceResult.NO_RANK, "kind only"],
		[RiftOffer.UNRESOLVED_PROGRESSION_KIND, 0, 1, "ranks only"],
		[SupportContinuationResult.Kind.RANK_INCREASE, 1, 2, "a whole rank increase"],
	]:
		passive.support_progression_kind = int(row[0])
		passive.support_rank_before = int(row[1])
		passive.support_rank_after = int(row[2])
		if passive.problem().is_empty():
			passive_escaped.append(String(row[3]))
		else:
			caught += 1
	passive.support_progression_kind = RiftOffer.UNRESOLVED_PROGRESSION_KIND
	passive.support_rank_before = RiftOfferChoiceResult.NO_RANK
	passive.support_rank_after = RiftOfferChoiceResult.NO_RANK
	_expect(passive_escaped.is_empty(),
		"a passive receipt carrying progression is coherent: %s" % ", ".join(passive_escaped))
	_expect(passive.problem().is_empty(), "a restored passive receipt is incoherent")
	var passive_hand_made: RiftOfferChoiceResult = RiftOfferChoiceResult.chosen(
		RANK_SEED, RiftOffer.Lane.UTILITY, PackedStringArray([String(EXPECTED_UTILITY_CARD)]),
		SupportContinuationResult.Kind.NEW_PAIR, 0, 1,
		RiftRunBuild.new(), _ledger_with(RANK_SEED))
	_expect(not RiftLevelUpResult.taken(passive_hand_made).problem().is_empty(),
		"a receipt copied from a passive choice carrying progression is coherent")
	caught += 1

	## A REFUSAL EXPOSING A KIND OR A RANK FAILS.
	var refusal: RiftLevelUpResult = RiftLevelUpResult.refused(
		"zz probe refusal", RANK_SEED, RiftOffer.Lane.SUPPORT)
	refusal.support_progression_kind = SupportContinuationResult.Kind.NEW_PAIR
	var refused_kind: bool = not refusal.problem().is_empty()
	refusal.support_progression_kind = RiftOffer.UNRESOLVED_PROGRESSION_KIND
	refusal.support_rank_after = 1
	var refused_rank: bool = not refusal.problem().is_empty()
	refusal.support_rank_after = RiftOfferChoiceResult.NO_RANK
	_expect(refused_kind and refused_rank and refusal.problem().is_empty(),
		"a refusal exposing a kind (%s) or a rank (%s) was accepted" % [
			refused_kind, refused_rank])
	caught += 2

	print("  %d tampered stable facts refused by problem(); each restored receipt is coherent again" % caught)
	_done("tampered_stable_facts_make_problem_fail")


# --- 9. One transition rule ---------------------------------------------------------

func _check_every_transition_is_judged_by_the_shared_validator() -> void:
	print("")
	print("--- 9. Every transition is judged by the shared F3 validator, verbatim")

	var receipt: RiftLevelUpResult = _support_receipt(null, E2_SEED)
	var legal: int = 0
	var illegal: int = 0
	var disagreements: PackedStringArray = PackedStringArray()
	for row: Array in [
		[SupportContinuationResult.Kind.NEW_PAIR, 0, 1],
		[SupportContinuationResult.Kind.RANK_INCREASE, 1, 2],
		[SupportContinuationResult.Kind.RANK_INCREASE, 2, 3],
		[SupportContinuationResult.Kind.RANK_INCREASE, 976, 977],
		[SupportContinuationResult.Kind.NEW_PAIR, 1, 2],
		[SupportContinuationResult.Kind.NEW_PAIR, 0, 2],
		[SupportContinuationResult.Kind.NEW_PAIR, 0, 0],
		[SupportContinuationResult.Kind.RANK_INCREASE, 0, 1],
		[SupportContinuationResult.Kind.RANK_INCREASE, 1, 3],
		[SupportContinuationResult.Kind.RANK_INCREASE, 2, 2],
		[UNDECLARED_KIND, 0, 1],
		[RiftOffer.UNRESOLVED_PROGRESSION_KIND, 1, 2],
	]:
		receipt.support_progression_kind = int(row[0])
		receipt.support_rank_before = int(row[1])
		receipt.support_rank_after = int(row[2])
		var rule: String = RiftOffer.support_transition_problem(
			int(row[0]), int(row[1]), int(row[2]))
		var owed: String = "" if rule.is_empty() else ILLEGAL_PREFIX + rule
		if receipt.problem() != owed:
			disagreements.append("%d %d -> %d answered '%s', owed '%s'" % [
				int(row[0]), int(row[1]), int(row[2]), receipt.problem(), owed])
		if rule.is_empty():
			legal += 1
		else:
			illegal += 1
	_expect(disagreements.is_empty(),
		"the receipt answered differently from the shared rule: %s" % "; ".join(disagreements))
	_expect(legal == 4 and illegal == 8,
		"%d legal and %d illegal transitions, not 4 and 8" % [legal, illegal])

	## AND IT ASKS THE RULE RATHER THAN RESTATING IT, measured over CODE lines.
	var code: String = _code_only(FileAccess.get_file_as_string(RESULT_FILE))
	_expect(code.count(SHARED_VALIDATOR) == 1,
		"the receipt asks the shared validator %d times" % code.count(SHARED_VALIDATOR))
	for token: String in ["ABSENT_RANK", "FIRST_RANK", "Kind.NEW_PAIR", "Kind.RANK_INCREASE"]:
		_expect(not code.contains(token), "the receipt restates %s" % token)

	print("  %d legal and %d illegal transitions: every receipt answer is the shared validator's own" % [
		legal, illegal])
	_done("every_transition_is_judged_by_the_shared_validator")


# --- 10. Nothing mutable reaches the receipt ----------------------------------------

func _check_nothing_mutable_can_reach_the_receipt() -> void:
	print("")
	print("--- 10. Neither a returned copy nor the source choice result can reach the receipt")

	var receipt: RiftLevelUpResult = _support_receipt(
		_build_at_rank(AcquiredSupports.FIRST_RANK), RANK_SEED)
	var original: String = _receipt_line(receipt)

	## THE RETURNED IDENTITY IS A COPY, in both directions: growing, rewriting and
	## clearing it changes nothing the receipt answers next.
	var copy: PackedStringArray = receipt.granted_identity()
	copy.append("zz_extra")
	copy[0] = "zz_rewritten"
	var cleared: PackedStringArray = receipt.granted_identity()
	cleared.clear()
	_expect(_receipt_line(receipt) == original and receipt.problem().is_empty(),
		"mutating returned identity copies changed the receipt to %s" % _receipt_line(receipt))

	## THE SOURCE CHOICE RESULT, MUTATED AFTER THE RECEIPT WAS BUILT FROM IT. Its
	## private identity array, its three progression scalars and — the decisive
	## one — the live build it carries, raised again through the accepted rank
	## operation. A receipt that kept any reference would move with one of these.
	var build: RiftRunBuild = _build_at_rank(AcquiredSupports.FIRST_RANK)
	var offer: RiftOffer = _compose(build, RANK_SEED)
	var source: RiftOfferChoiceResult = RiftOfferChoice.choose(
		offer, RiftOffer.Lane.SUPPORT, build, RiftConsumptionLedger.new())
	var built: RiftLevelUpResult = RiftLevelUpResult.taken(source)
	var built_line: String = _receipt_line(built)
	var mutations: int = 0
	source._chosen_identity.append("zz_source_extra")
	mutations += 1
	source.support_rank_after = 99
	source.support_rank_before = 98
	source.support_progression_kind = UNDECLARED_KIND
	mutations += 3
	var raise: String = source.new_build.rank_support(EXPECTED_SKILL, EXPECTED_OTHER_SUPPORT)
	_expect(raise.is_empty(), "the source build refused a further rank: %s" % raise)
	mutations += 1
	source.new_ledger.consume(RANK_SEED + 1)
	mutations += 1
	_expect(_receipt_line(built) == built_line and built.problem().is_empty(),
		"mutating the source choice result moved the receipt:\n    was %s\n    now %s" % [
			built_line, _receipt_line(built)])
	_expect(built.support_rank_after == 2 and built.granted_identity().size() == 2,
		"the receipt now reports rank %d and %d ids" % [
			built.support_rank_after, built.granted_identity().size()])

	## THE RECEIPT IS BUILT ONLY FROM SCALARS AND A COPIED ARRAY. Nothing it holds
	## is an object, so there is nothing through which anything could reach it.
	var objects: PackedStringArray = PackedStringArray()
	for entry: Dictionary in built.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE == 0:
			continue
		if int(entry.get("type", TYPE_NIL)) == TYPE_OBJECT:
			objects.append(String(entry.get("name", "")))
	_expect(objects.is_empty(), "the receipt holds the object field(s) %s" % ", ".join(objects))

	print("  the returned identity and the source choice result were mutated %d ways; the receipt did not move" % (
		mutations + 3))
	_done("nothing_mutable_can_reach_the_receipt")


# --- 11. The shape ----------------------------------------------------------------

func _check_the_receipt_shape_is_pinned() -> void:
	print("")
	print("--- 11. The receipt's shape is pinned exactly, in both directions")

	var signatures: PackedStringArray = _signatures_of(RESULT_FILE)
	_expect(_same_list(signatures, EXPECTED_RESULT_SIGNATURES),
		"the receipt declares: %s" % ", ".join(signatures))
	var fields: PackedStringArray = _fields_of(RiftLevelUpResult.new())
	_expect(_same_list(fields, EXPECTED_RESULT_FIELDS),
		"the receipt carries: %s" % ", ".join(fields))
	var coordinator_signatures: PackedStringArray = _signatures_of(COORDINATOR_FILE)
	_expect(_same_list(coordinator_signatures, EXPECTED_COORDINATOR_SIGNATURES),
		"the coordinator declares: %s" % ", ".join(coordinator_signatures))

	## THE COMPARATOR IS PROVED TO REFUSE BOTH AN EXTRA MEMBER AND A MISSING ONE,
	## so an exact pin cannot quietly have become a subset test.
	var with_extra: Array[String] = EXPECTED_RESULT_FIELDS.duplicate()
	with_extra.append("new_build")
	var with_one_missing: Array[String] = EXPECTED_RESULT_FIELDS.duplicate()
	with_one_missing.remove_at(with_one_missing.find("support_rank_after"))
	_expect(not _same_list(fields, with_extra),
		"the field pin accepts an extra member")
	_expect(not _same_list(fields, with_one_missing),
		"the field pin accepts a missing member")

	## THE THREE PROGRESSION FIELDS ARE INTEGERS AND DEFAULT TO THE ACCEPTED
	## CONVENTIONS — the offer contract's unresolved kind and the choice result's
	## no-rank value — rather than to a third representation.
	var fresh: RiftLevelUpResult = RiftLevelUpResult.new()
	_expect(typeof(fresh.support_progression_kind) == TYPE_INT
			and typeof(fresh.support_rank_before) == TYPE_INT
			and typeof(fresh.support_rank_after) == TYPE_INT,
		"a progression field is not an integer")
	_expect(fresh.support_progression_kind == RiftOffer.UNRESOLVED_PROGRESSION_KIND
			and fresh.support_rank_before == RiftOfferChoiceResult.NO_RANK
			and fresh.support_rank_after == RiftOfferChoiceResult.NO_RANK,
		"a fresh receipt defaults to kind %d, %d -> %d" % [
			fresh.support_progression_kind, fresh.support_rank_before, fresh.support_rank_after])
	## THE THREE DECLARATIONS, MATCHED WHOLE. A bare `= ...NO_RANK` count would
	## also match every `!= ...NO_RANK` comparison in `problem()` — which is exactly
	## how this assertion's first draft failed on a correct file.
	var source: String = FileAccess.get_file_as_string(RESULT_FILE)
	_expect(source.contains(
				"var support_progression_kind: int = RiftOffer.UNRESOLVED_PROGRESSION_KIND\n")
			and source.contains("var support_rank_before: int = RiftOfferChoiceResult.NO_RANK\n")
			and source.contains("var support_rank_after: int = RiftOfferChoiceResult.NO_RANK\n"),
		"the receipt's defaults are not read from the accepted conventions")

	## THE COLLECTION IS STILL PRIVATE AND THE BRIEF'S FORBIDDEN MEMBERS ARE
	## ABSENT, as properties AND as methods.
	_expect(fields.has("_granted_identity") and not fields.has("granted_identity"),
		"the identity collection is no longer private")
	var present: PackedStringArray = PackedStringArray()
	for member: String in FORBIDDEN_MEMBERS:
		if fields.has(member) or fresh.has_method(member):
			present.append(member)
	_expect(present.is_empty(), "the receipt carries forbidden member(s) %s" % ", ".join(present))

	print("  %d fields and %d methods pinned; %d forbidden members absent; the comparator refuses an extra and a missing member" % [
		fields.size(), signatures.size(), FORBIDDEN_MEMBERS.size()])
	_done("the_receipt_shape_is_pinned_exactly_in_both_directions")


# --- 12. E2's lifecycle -----------------------------------------------------------

func _check_the_accepted_e2_lifecycle_is_unchanged() -> void:
	print("")
	print("--- 12. E2's seed, lane, completion, overflow and one-level boundary are unchanged")

	## A RANK CHOICE WITH OVERFLOW, SO THE UNCHANGED LIFECYCLE IS MEASURED ON THE
	## PATH F5 ACTUALLY TOUCHED.
	var pre_choice: RiftRunBuild = _build_at_rank(AcquiredSupports.FIRST_RANK)
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, pre_choice, null)
	_expect(lifecycle.award_experience(OVERFLOW_AWARD).is_empty(), "the overflow award was refused")
	_expect(_open(lifecycle, REQUIREMENT, RANK_SEED).is_empty(), "the overflow offer did not open")
	_expect(lifecycle.level() == 1 and lifecycle.frozen_requirement() == REQUIREMENT,
		"the offer moved the level to %d or froze %s" % [
			lifecycle.level(), String.num(lifecycle.frozen_requirement(), 17)])
	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.SUPPORT)
	_expect_success(outcome, RANK_SEED, RiftOffer.Lane.SUPPORT, "the overflow rank choice")

	_expect(lifecycle.level() == EXPECTED_LEVEL_AFTER, "the level reached %d" % lifecycle.level())
	_expect(lifecycle.experience() == EXPECTED_OVERFLOW,
		"%s experience was retained, not %s" % [
			String.num(lifecycle.experience(), 17), String.num(EXPECTED_OVERFLOW, 17)])
	_expect(lifecycle.is_completed() and not lifecycle.is_offer_active()
			and lifecycle.frozen_requirement() == RiftLevelUpCoordinator.NO_REQUIREMENT,
		"the lifecycle is completed=%s offer=%s requirement=%s" % [
			lifecycle.is_completed(), lifecycle.is_offer_active(),
			String.num(lifecycle.frozen_requirement(), 17)])
	var ledger: RiftConsumptionLedger = lifecycle.consumption_ledger()
	_expect(ledger.count() == 1 and ledger.has_consumed(RANK_SEED),
		"the ledger records %s" % ledger.describe())

	## THE COMMIT ADOPTED EXACTLY WHAT THE ACCEPTED TRANSACTION RETURNED for the
	## same offer and the same pre-choice state.
	var independent: RiftOfferChoiceResult = RiftOfferChoice.choose(
		_compose(pre_choice, RANK_SEED), RiftOffer.Lane.SUPPORT,
		pre_choice.duplicated(), RiftConsumptionLedger.new())
	_expect(_build_snapshot(lifecycle.run_build()) == _build_snapshot(independent.new_build),
		"the coordinator adopted %s where the transaction returned %s" % [
			_build_snapshot(lifecycle.run_build()), _build_snapshot(independent.new_build)])
	_expect(lifecycle.consumption_ledger().describe() == independent.new_ledger.describe(),
		"the coordinator's ledger reads %s" % lifecycle.consumption_ledger().describe())
	_expect(outcome.root_seed == independent.root_seed and outcome.lane == independent.lane,
		"the receipt reports seed %d lane %d where the transaction stamped %d %d" % [
			outcome.root_seed, outcome.lane, independent.root_seed, independent.lane])

	## EXACTLY ONE LEVEL-UP, AND EVERY LATER OPERATION REFUSED WITHOUT MUTATION.
	var settled: String = _lifecycle_snapshot(lifecycle)
	var refused: int = 0
	if not lifecycle.award_experience(BASE_AWARD).is_empty():
		refused += 1
	if not _open(lifecycle, EXPECTED_OVERFLOW, RANK_SEED + 1).is_empty():
		refused += 1
	for lane: int in [RiftOffer.Lane.SUPPORT, RiftOffer.Lane.COMBAT_DEFENCE,
			RiftOffer.Lane.UTILITY, UNDECLARED_LANE]:
		_expect_refusal(lifecycle.choose(lane), "lane %d after the one level-up" % lane)
		refused += 1
	_expect(refused == 6, "%d of 6 later operations were refused" % refused)
	_expect(_lifecycle_snapshot(lifecycle) == settled,
		"a refused later operation moved the lifecycle:\n    before %s\n    after  %s" % [
			settled, _lifecycle_snapshot(lifecycle)])

	print("  %s against %s through a rank choice: Level %d, %s retained, %d seed consumed, finished; %d later operations refused" % [
		String.num(OVERFLOW_AWARD), String.num(REQUIREMENT), lifecycle.level(),
		String.num(lifecycle.experience()), ledger.count(), refused])
	_done("the_accepted_e2_lifecycle_is_unchanged")


# --- 13. F4's direct result ---------------------------------------------------------

func _check_the_accepted_f4_direct_result_is_unchanged() -> void:
	print("")
	print("--- 13. F4's direct transaction result is unchanged")

	## THE THIRD ROW MOVED ONE FOR ONE UNDER FOUNDATION I5 (D-300). It froze Sweeping
	## Edge 2 -> 3 from every pair at rank 2 — now an exhausted state that composes
	## nothing. With Sweeping Edge at its maximum beside Reaching Edge at rank 1, the
	## same root seed 18 raises Reaching Edge 1 -> 2 instead.
	var shown: PackedStringArray = PackedStringArray()
	for row: Array in [
		[null, E2_SEED, EXPECTED_SUPPORT, SupportContinuationResult.Kind.NEW_PAIR, 0, 1,
			NEW_PAIR_LINE, "root seed 0 consumed; Support: quick_strike -> reaching_edge"],
		[_build_at_rank(AcquiredSupports.FIRST_RANK), RANK_SEED, EXPECTED_OTHER_SUPPORT,
			SupportContinuationResult.Kind.RANK_INCREASE, 1, 2, RANK_ONE_LINE,
			"root seed 18 consumed; Support: quick_strike -> sweeping_edge"],
		[_build_holding(1, 2), RANK_SEED, EXPECTED_SUPPORT,
			SupportContinuationResult.Kind.RANK_INCREASE, 1, 2, RANK_ONE_LINE,
			"root seed 18 consumed; Support: quick_strike -> reaching_edge"],
	]:
		var build: RiftRunBuild = row[0] if row[0] != null else RiftRunBuild.new()
		var before: String = _build_snapshot(build)
		var direct: RiftOfferChoiceResult = RiftOfferChoice.choose(
			_compose(build, int(row[1])), RiftOffer.Lane.SUPPORT, build,
			RiftConsumptionLedger.new())
		var identity: PackedStringArray = direct.chosen_identity()
		_expect(direct.ok and direct.problem().is_empty()
				and direct.support_progression_build_problem().is_empty(),
			"F4's direct result at seed %d: ok=%s '%s' audit '%s'" % [
				int(row[1]), direct.ok, direct.problem(),
				direct.support_progression_build_problem()])
		_expect(identity.size() == 2 and StringName(identity[1]) == StringName(row[2])
				and direct.support_progression_kind == int(row[3])
				and direct.support_rank_before == int(row[4])
				and direct.support_rank_after == int(row[5]),
			"F4's direct result at seed %d granted [%s] kind %d %d -> %d" % [
				int(row[1]), ", ".join(identity), direct.support_progression_kind,
				direct.support_rank_before, direct.support_rank_after])
		_expect(direct.support_progression_line() == String(row[6])
				and direct.describe() == String(row[7])
				and direct.carries_support_progression(),
			"F4's direct result reads '%s' / '%s'" % [
				direct.support_progression_line(), direct.describe()])
		_expect(_build_snapshot(build) == before,
			"F4's direct transaction moved the supplied build")
		shown.append("%s, %s" % [direct.identity_line(), direct.support_progression_line()])

	print("  D3 still answers: %s; every audit silent and every supplied build untouched" % "; ".join(shown))
	_done("the_accepted_f4_direct_result_is_unchanged")


# --- 14. Copied, never re-derived ---------------------------------------------------

func _check_the_progression_is_copied() -> void:
	print("")
	print("--- 14. The progression is copied out of one object and never re-derived")

	var coordinator_code: String = _code_only(FileAccess.get_file_as_string(COORDINATOR_FILE))
	var result_code: String = _code_only(FileAccess.get_file_as_string(RESULT_FILE))
	_expect(coordinator_code.length() > 3000 and result_code.length() > 1500,
		"the E2 sources read as %d and %d characters, so these scans prove nothing" % [
			coordinator_code.length(), result_code.length()])

	## THE COORDINATOR HANDS THE WHOLE RESULT OVER, ONCE, AND READS NOTHING OF IT.
	_expect(coordinator_code.count("RiftLevelUpResult.taken(outcome)") == 1,
		"the coordinator builds its receipt %d times from the whole outcome"
			% coordinator_code.count("RiftLevelUpResult.taken(outcome)"))
	_expect(coordinator_code.count("RiftLevelUpResult.taken(") == 1,
		"the coordinator builds a receipt some other way")
	var coordinator_reads: PackedStringArray = PackedStringArray()
	for token: String in COORDINATOR_FORBIDDEN_CODE:
		if coordinator_code.contains(token):
			coordinator_reads.append(token)
	_expect(coordinator_reads.is_empty(),
		"the coordinator's code names %s" % ", ".join(coordinator_reads))

	## THE RECEIPT READS EVERY STABLE FACT OUT OF THAT ONE ARGUMENT, AND NOTHING
	## MUTABLE OUT OF IT.
	for member: String in [
		"from_choice.root_seed", "from_choice.root_seed_known", "from_choice.lane",
		"from_choice.chosen_identity()", "from_choice.support_progression_kind",
		"from_choice.support_rank_before", "from_choice.support_rank_after",
	]:
		_expect(result_code.count(member) == 1 or (member == "from_choice.root_seed"
				and result_code.count(member) == 2),
			"the receipt reads %s %d times" % [member, result_code.count(member)])
	var receipt_reads: PackedStringArray = PackedStringArray()
	for token: String in RECEIPT_FORBIDDEN_CODE:
		if result_code.contains(token):
			receipt_reads.append(token)
	_expect(receipt_reads.is_empty(), "the receipt's code names %s" % ", ".join(receipt_reads))

	## AND THE ONE DIRECTION THAT CAN FAIL BEHAVIOURALLY: a receipt built from a
	## hand-made choice result carries THAT result's progression even where the
	## build it carries says something else — so the receipt copies rather than
	## asking the build.
	var disagreeing_build: RiftRunBuild = _build_at_rank(2)
	var claimed: RiftOfferChoiceResult = RiftOfferChoiceResult.chosen(
		RANK_SEED, RiftOffer.Lane.SUPPORT,
		PackedStringArray([String(EXPECTED_SKILL), String(EXPECTED_OTHER_SUPPORT)]),
		SupportContinuationResult.Kind.NEW_PAIR, 0, 1, disagreeing_build, _ledger_with(RANK_SEED))
	var copied: RiftLevelUpResult = RiftLevelUpResult.taken(claimed)
	_expect(copied.support_progression_kind == SupportContinuationResult.Kind.NEW_PAIR
			and copied.support_rank_before == 0 and copied.support_rank_after == 1,
		"the receipt reported %d %d -> %d instead of copying the choice's NEW_PAIR 0 -> 1" % [
			copied.support_progression_kind, copied.support_rank_before, copied.support_rank_after])
	_expect(disagreeing_build.support_rank_for(EXPECTED_SKILL, EXPECTED_OTHER_SUPPORT) == 2,
		"the fixture build does not disagree")
	_expect(claimed.support_progression_build_problem() != "" and copied.problem().is_empty(),
		"the control is not a disagreement the choice's own audit can see")

	## THE ACCEPTED DIAGNOSTIC STRINGS DID NOT GAIN THE PROGRESSION.
	var receipt: RiftLevelUpResult = _support_receipt(
		_build_at_rank(AcquiredSupports.FIRST_RANK), RANK_SEED)
	_expect(not receipt.describe().contains("rank") and not receipt.identity_line().contains("rank"),
		"an accepted diagnostic string now carries the progression: '%s' / '%s'" % [
			receipt.describe(), receipt.identity_line()])

	print("  the coordinator names 0 of %d rank or progression tokens and hands 1 whole result to taken(); the receipt reads 0 of %d mutable members" % [
		COORDINATOR_FORBIDDEN_CODE.size(), RECEIPT_FORBIDDEN_CODE.size()])
	_done("the_progression_is_copied_and_never_re_derived")


# --- 15. Scope ----------------------------------------------------------------------

func _check_the_scope() -> void:
	print("")
	print("--- 15. The scope moved exactly where the receipt required it to")

	## `scripts/levels/` STILL HOLDS EXACTLY THE TWO E2 SCRIPTS: F5 extended rather
	## than added. Since Foundation G4 (D-269) it also holds G4's two, and nothing
	## else — the same single assertion, widened by exactly those two files.
	var level_scripts: PackedStringArray = _files_under("res://scripts/levels", [".gd"])
	level_scripts.sort()
	var expected: PackedStringArray = PackedStringArray(E2_FILES)
	for row: Array in RUN_LEVEL_READERS:
		expected.append(String(row[0]))
	expected.sort()
	_expect(", ".join(level_scripts) == ", ".join(expected),
		"scripts/levels/ holds: %s" % ", ".join(level_scripts))

	## THE TWO ALLOWLIST MOVES THE RECEIPT REQUIRED ARE VISIBLE WHERE THEY LIVE.
	var f2_source: String = FileAccess.get_file_as_string(F2_VERIFICATION)
	_expect(f2_source.contains(
			"[\"res://scripts/levels/rift_level_up_result.gd\", [\n\t\t\"SupportContinuationResult\", \"SupportContinuation\",\n\t]]"),
		"the Foundation F2 suite does not grant the receipt the continuation record")
	var e2_source: String = FileAccess.get_file_as_string(E2_VERIFICATION)
	## Roguelite Foundation I9 (D-310) widened that one permit by exactly one token,
	## `fallback`, so the receipt can record what a consumed passive fallback was.
	## The same single assertion, reading the moved row.
	_expect(e2_source.contains(
			"[\"res://scripts/levels/rift_level_up_result.gd\", [\"rank\", \"fallback\"]]"),
		"the Foundation E2 suite does not permit the receipt the rank and fallback tokens")
	_expect(e2_source.contains("\"SupportContinuationResult\", \"SupportContinuation\","),
		"the Foundation E2 suite does not grant the receipt the continuation record")

	## THE RECEIPT CALLS NOTHING OF F2 AND NOTHING OF THE COMPOSER; THE COORDINATOR
	## STILL NAMES NO F2 CLASS AT ALL.
	var result_raw: String = FileAccess.get_file_as_string(RESULT_FILE)
	var coordinator_raw: String = FileAccess.get_file_as_string(COORDINATOR_FILE)
	_expect(result_raw.contains("SupportContinuationResult.kind_label(")
			and not result_raw.contains("SupportContinuation.select"),
		"the receipt does not render through kind_label, or calls the selector")
	_expect(not coordinator_raw.contains("SupportContinuation"),
		"the coordinator names a Foundation F2 class")
	_expect(not result_raw.contains("RiftOfferComposition")
			and not result_raw.contains("RiftOfferChoice.choose"),
		"the receipt names the composer or calls the transaction")

	## NOTHING THAT RUNS NAMES EITHER E2 CLASS OUTSIDE THE G4 GRANTS, and
	## project.godot is untouched in the two respects every foundation suite checks.
	var referenced: PackedStringArray = PackedStringArray()
	var scanned: int = 0
	for root: String in ["res://scripts", "res://scenes", "res://data", "res://addons"]:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if E2_FILES.has(path):
				continue
			scanned += 1
			var text: String = FileAccess.get_file_as_string(path)
			for name: String in ["RiftLevelUpCoordinator", "RiftLevelUpResult"]:
				if text.contains(name) and not _run_level_reader_may_name(path, name):
					referenced.append("%s names %s" % [path.get_file(), name])
	_expect(referenced.is_empty(), "Foundation E2 is referenced by code that runs: %s" % ", ".join(referenced))
	_expect(scanned > 100, "only %d project files were scanned" % scanned)
	var settings: String = FileAccess.get_file_as_string("res://project.godot")
	_expect(not settings.contains("[autoload]")
			and not settings.contains("RiftLevelUp")
			and String(ProjectSettings.get_setting("application/run/main_scene", ""))
				== "res://scenes/app/prototype_app.tscn",
		"project.godot gained an autoload, names E2, or moved the entrypoint")

	print("  scripts/levels/ holds E2's 2 scripts and G4's 2; 1 E2 permit and 1 F2 grant carry the receipt; %d project files name no E2 class outside the G4 grants and the D-293 review's receipt grant" % scanned)
	_done("the_scope_moved_exactly_where_the_receipt_required")


## Whether `path` is one of Foundation G4's two scripts, or the D-293 review, and is
## granted `name`. Per file AND per class, so the run-level record naming the
## coordinator would still be refused.
func _run_level_reader_may_name(path: String, name: String) -> bool:
	for row: Array in RUN_LEVEL_READERS + REVIEW_READERS:
		if String(row[0]) == path:
			return (row[1] as Array).has(name)
	return false


# --- Outcome assertions ---------------------------------------------------------------

## A successful receipt, and every property every success owes.
func _expect_success(
	outcome: RiftLevelUpResult, root_seed: int, lane: int, described: String
) -> void:
	_successes += 1
	_expect(outcome.ok, "%s was refused: %s" % [described, outcome.failure_reason])
	_expect(outcome.problem().is_empty(),
		"%s produced an incoherent receipt: %s" % [described, outcome.problem()])
	_expect(outcome.root_seed_known and outcome.root_seed == root_seed and outcome.lane == lane,
		"%s reports seed %d (known %s) lane %d" % [
			described, outcome.root_seed, outcome.root_seed_known, outcome.lane])
	_expect(outcome.carries_support_progression() == (lane == RiftOffer.Lane.SUPPORT),
		"%s carries progression=%s on lane %d" % [
			described, outcome.carries_support_progression(), lane])
	_expect(outcome.granted_identity().size() == RiftOfferChoiceResult.identity_size_for(lane),
		"%s granted %d ids" % [described, outcome.granted_identity().size()])


## A refused receipt, and every property every refusal owes: a reason, no
## identity, no progression, and coherence in its own right.
func _expect_refusal(outcome: RiftLevelUpResult, described: String) -> void:
	_refusals += 1
	_expect(not outcome.ok and not outcome.failure_reason.strip_edges().is_empty(),
		"%s was not a stated refusal" % described)
	_expect(outcome.granted_identity().is_empty() and outcome.identity_line() == "nothing granted",
		"%s still granted %s" % [described, outcome.identity_line()])
	_expect_no_progression(outcome, described)
	_expect(outcome.problem().is_empty(),
		"%s produced an incoherent refusal: %s" % [described, outcome.problem()])


## The no-progression shape, exactly: the offer contract's unresolved kind, the
## choice result's no-rank value on both sides, and the plain-language line.
func _expect_no_progression(outcome: RiftLevelUpResult, described: String) -> void:
	_expect(not outcome.carries_support_progression()
			and outcome.support_progression_kind == RiftOffer.UNRESOLVED_PROGRESSION_KIND
			and outcome.support_rank_before == RiftOfferChoiceResult.NO_RANK
			and outcome.support_rank_after == RiftOfferChoiceResult.NO_RANK
			and outcome.support_progression_line() == NO_PROGRESSION_LINE,
		"%s carries kind %d, %d -> %d ('%s')" % [
			described, outcome.support_progression_kind, outcome.support_rank_before,
			outcome.support_rank_after, outcome.support_progression_line()])


## "" when the receipt carries exactly the stable facts the choice result
## carried, or the first difference.
func _receipt_mismatch(receipt: RiftLevelUpResult, choice: RiftOfferChoiceResult) -> String:
	if receipt.ok != choice.ok:
		return "ok %s against %s" % [receipt.ok, choice.ok]
	if not receipt.ok:
		return "a refusal: %s" % receipt.failure_reason
	if not receipt.problem().is_empty():
		return "an incoherent receipt: %s" % receipt.problem()
	if receipt.root_seed != choice.root_seed or receipt.root_seed_known != choice.root_seed_known:
		return "seed %d against %d" % [receipt.root_seed, choice.root_seed]
	if receipt.lane != choice.lane:
		return "lane %d against %d" % [receipt.lane, choice.lane]
	if ", ".join(receipt.granted_identity()) != ", ".join(choice.chosen_identity()):
		return "[%s] against [%s]" % [
			", ".join(receipt.granted_identity()), ", ".join(choice.chosen_identity())]
	if receipt.support_progression_kind != choice.support_progression_kind \
			or receipt.support_rank_before != choice.support_rank_before \
			or receipt.support_rank_after != choice.support_rank_after:
		return "kind %d %d -> %d against %d %d -> %d" % [
			receipt.support_progression_kind, receipt.support_rank_before,
			receipt.support_rank_after, choice.support_progression_kind,
			choice.support_rank_before, choice.support_rank_after]
	if receipt.carries_support_progression() != choice.carries_support_progression():
		return "carries %s against %s" % [
			receipt.carries_support_progression(), choice.carries_support_progression()]
	if receipt.support_progression_line() != choice.support_progression_line():
		return "'%s' against '%s'" % [
			receipt.support_progression_line(), choice.support_progression_line()]
	return ""


# --- Fixtures -------------------------------------------------------------------------

## A coordinator built on a copy of `build` (the default when null) with the
## requirement reached and no offer standing.
func _ready_lifecycle(build: RiftRunBuild, requirement: float) -> RiftLevelUpCoordinator:
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, build, null)
	_expect(lifecycle.award_experience(BASE_AWARD).is_empty()
			and lifecycle.award_experience(BASE_AWARD).is_empty(),
		"a fixture's awards were refused")
	_expect(lifecycle.reading_for(requirement).ready, "a fixture did not reach its requirement")
	return lifecycle


## The same coordinator with its one offer standing at `root_seed`.
func _open_lifecycle(build: RiftRunBuild, root_seed: int, requirement: float) -> RiftLevelUpCoordinator:
	var lifecycle: RiftLevelUpCoordinator = _ready_lifecycle(build, requirement)
	var opened: String = _open(lifecycle, requirement, root_seed)
	_expect(opened.is_empty(), "a fixture's offer at seed %d did not open: %s" % [root_seed, opened])
	return lifecycle


func _open(lifecycle: RiftLevelUpCoordinator, requirement: float, root_seed: int) -> String:
	return lifecycle.open_offer(requirement,
		SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(),
		PassiveCardCatalogue.records(), root_seed)


## The offer the coordinator would compose, composed INDEPENDENTLY from the same
## inputs: its acquisition snapshot of `build` and the shipped records.
func _compose(build: RiftRunBuild, root_seed: int) -> RiftOffer:
	var source: RiftRunBuild = build if build != null else RiftRunBuild.new()
	return RiftOfferComposition.compose(
		SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(),
		source.acquired_supports(), PassiveCardCatalogue.records(), root_seed)


## A successful Support receipt from a real coordinator.
func _support_receipt(build: RiftRunBuild, root_seed: int) -> RiftLevelUpResult:
	var lifecycle: RiftLevelUpCoordinator = _open_lifecycle(build, root_seed, REQUIREMENT)
	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.SUPPORT)
	_expect_success(outcome, root_seed, RiftOffer.Lane.SUPPORT, "a Support fixture receipt")
	return outcome


func _passive_receipt(lane: int) -> RiftLevelUpResult:
	var lifecycle: RiftLevelUpCoordinator = _open_lifecycle(null, E2_SEED, REQUIREMENT)
	var outcome: RiftLevelUpResult = lifecycle.choose(lane)
	_expect_success(outcome, E2_SEED, lane, "a passive fixture receipt")
	return outcome


## Every compatible shipped pair held at `rank`, reached through the accepted
## run-build operations: the state from which the Support lane is exhausted.
func _build_at_rank(rank: int) -> RiftRunBuild:
	var build: RiftRunBuild = RiftRunBuild.new()
	for profile: SkillTagProfile in SkillSupportCatalogue.skill_profiles():
		for definition: SupportDefinition in SkillSupportCatalogue.support_definitions():
			if not definition.allows(profile):
				continue
			_expect(build.acquire_support(profile.skill_id, definition.support_id()).is_empty(),
				"the fixture could not acquire %s -> %s" % [
					profile.skill_id, definition.support_id()])
			for _step: int in range(rank - AcquiredSupports.FIRST_RANK):
				_expect(build.rank_support(profile.skill_id, definition.support_id()).is_empty(),
					"the fixture could not raise %s -> %s" % [
						profile.skill_id, definition.support_id()])
	return build


## The two shipped pairs held at the two given ranks — `AcquiredSupports.ABSENT_RANK`
## leaving a pair unheld — reached through the accepted run-build operations with
## one assertion per operation, exactly as `_build_at_rank()` makes them
## (Foundation I5, D-300: the mixed states a shipped maximum of rank 2 permits).
func _build_holding(reaching_rank: int, sweeping_rank: int) -> RiftRunBuild:
	var build: RiftRunBuild = RiftRunBuild.new()
	for row: Array in [[EXPECTED_SUPPORT, reaching_rank], [EXPECTED_OTHER_SUPPORT, sweeping_rank]]:
		var support_id: StringName = row[0]
		var rank: int = int(row[1])
		if rank == AcquiredSupports.ABSENT_RANK:
			continue
		_expect(build.acquire_support(EXPECTED_SKILL, support_id).is_empty(),
			"the fixture could not acquire %s -> %s" % [EXPECTED_SKILL, support_id])
		for _step: int in range(rank - AcquiredSupports.FIRST_RANK):
			_expect(build.rank_support(EXPECTED_SKILL, support_id).is_empty(),
				"the fixture could not raise %s -> %s" % [EXPECTED_SKILL, support_id])
	return build


## The two shipped pairs held at DIFFERENT ranks: the first at 1, the other at 2.
func _mixed_build() -> RiftRunBuild:
	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_support(EXPECTED_SKILL, EXPECTED_SUPPORT).is_empty()
			and build.acquire_support(EXPECTED_SKILL, EXPECTED_OTHER_SUPPORT).is_empty()
			and build.rank_support(EXPECTED_SKILL, EXPECTED_OTHER_SUPPORT).is_empty(),
		"the mixed fixture could not be built")
	return build


## One pair held, so the Support lane still offers the other as a new pair.
func _build_with_one_pair() -> RiftRunBuild:
	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_support(EXPECTED_SKILL, EXPECTED_SUPPORT).is_empty(),
		"the one-pair fixture could not be built")
	return build


func _ledger_with(root_seed: int) -> RiftConsumptionLedger:
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	_expect(ledger.consume(root_seed), "a fixture ledger refused seed %d" % root_seed)
	return ledger


# --- Formatting -----------------------------------------------------------------------

## Every stable fact a receipt carries, as one line.
func _receipt_line(receipt: RiftLevelUpResult) -> String:
	return "ok=%s reason=%s seed=%d known=%s lane=%d ids=[%s] kind=%d %d->%d carries=%s line=%s" % [
		receipt.ok, receipt.failure_reason, receipt.root_seed, receipt.root_seed_known,
		receipt.lane, ", ".join(receipt.granted_identity()), receipt.support_progression_kind,
		receipt.support_rank_before, receipt.support_rank_after,
		receipt.carries_support_progression(), receipt.support_progression_line(),
	]


## A whole run build: every pair at its rank, every card, every stat total.
func _build_snapshot(build: RiftRunBuild) -> String:
	if build == null:
		return "no build"
	var ranked: PackedStringArray = PackedStringArray()
	for pair: String in build.support_pairs():
		var ids: PackedStringArray = pair.split(" -> ")
		ranked.append("%s@%d" % [pair, build.support_rank_for(StringName(ids[0]), StringName(ids[1]))])
	var stats: PackedStringArray = PackedStringArray()
	for stat_id: StringName in PlayerStats.ALL:
		stats.append("%s=%s" % [stat_id, String.num(build.total_for(stat_id), 17)])
	return "pairs[%s] ranks=%d cards=%d | %s | %s" % [
		", ".join(ranked), build.total_support_ranks(), build.passive_acquisitions(),
		", ".join(stats), build.describe()]


## The whole lifecycle, for the later-operation atomicity proof.
func _lifecycle_snapshot(lifecycle: RiftLevelUpCoordinator) -> String:
	var lanes: PackedStringArray = PackedStringArray()
	for lane: int in lifecycle.offer_lanes():
		lanes.append("%d:%s" % [lane, " -> ".join(lifecycle.offer_identity_for(lane))])
	return "level=%d experience=%s finished=%s offer=%s seed=%d requirement=%s lanes=[%s] | %s | %s" % [
		lifecycle.level(), String.num(lifecycle.experience(), 17), lifecycle.is_completed(),
		lifecycle.is_offer_active(), lifecycle.offer_root_seed(),
		String.num(lifecycle.frozen_requirement(), 17), ", ".join(lanes),
		_build_snapshot(lifecycle.run_build()), lifecycle.consumption_ledger().describe(),
	]


## Exact, order-sensitive equality of two lists: an extra member and a missing
## one both fail it.
func _same_list(actual: PackedStringArray, expected: Array[String]) -> bool:
	if actual.size() != expected.size():
		return false
	for index: int in range(actual.size()):
		if actual[index] != expected[index]:
			return false
	return true


## Comment lines removed. Both E2 files say in plain English what they refuse to
## do, and a scan that cannot tell the promise from the breach is worthless.
func _code_only(source: String) -> String:
	var out: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


## Every method as `name(arg: Type, ...) -> Type`, in declaration order — the
## same rendering the accepted E2 suite pins with.
func _signatures_of(path: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var script: GDScript = load(path) as GDScript
	if script == null:
		return out
	for entry: Dictionary in script.get_script_method_list():
		var args: PackedStringArray = PackedStringArray()
		for argument: Dictionary in entry.get("args", []):
			args.append("%s: %s" % [
				String(argument.get("name", "")), _type_name(int(argument.get("type", 0)))])
		var returns: Dictionary = entry.get("return", {}) as Dictionary
		out.append("%s(%s) -> %s" % [
			String(entry.get("name", "")), ", ".join(args),
			_type_name(int(returns.get("type", 0)))])
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
	print("  %d successes and %d refusals were driven across this suite" % [_successes, _refusals])


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
