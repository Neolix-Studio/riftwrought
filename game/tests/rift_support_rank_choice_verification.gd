extends SceneTree
## Riftwrought — Roguelite Foundation F4 verification: atomic Support rank-choice
## consumption (decision D-257).
##
## ONE FOCUSED HEADLESS TEST. F4 adds no file of its own: it EXTENDS the two
## accepted Foundation D3 scripts so the choice transaction consumes the support
## lane's FROZEN progression, and it extracts the frozen transition's legality
## rule out of `RiftOffer.problem()` into one shared static both sides ask. So
## this suite needs no scene, no camera, no navigation, no rendering and no
## evidence frame, and it deliberately gets none. It runs as a `SceneTree` script
## exactly as every earlier foundation's suite does.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching its
## LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## WHAT THIS SUITE OWNS. The TRANSACTION: that a new-pair offer is taken exactly
## as it always was, that a rank offer is now taken through the accepted rank
## operation, that an offer whose frozen before-rank no longer matches the run is
## refused in BOTH directions without spending anything, that a mutation which
## lands somewhere other than the offer promised is refused before the seed, that
## a tampered progression is caught by offer coherence before any mutation, and
## that the accepted early already-consumed gate still answers first. It does not
## re-prove the composition (F3's suite owns the frozen transition and the corpus),
## the ranked-ownership rules (F1's), the continuation policy (F2's) or the passive
## half of the transaction (D3's) — all four still pass.
##
## EVERY ATOMICITY PROOF COMPARES THE WHOLE OF BOTH SUPPLIED VALUES, which is the
## discipline the accepted D3 suite established: a complete snapshot of the run
## build — every pair, every rank, every card count, every bound mechanical
## identity and every stat total to seventeen significant digits — is taken beside
## a complete snapshot of the ledger immediately before each attempt, and both are
## compared afterwards. Checking only the thing the operation was about is how a
## partial mutation survives a green suite.
##
## THE STALE REFUSALS ARE DRIVEN IN BOTH DIRECTIONS AND NEVER FROM A SOURCE SCAN.
## A run that has moved AHEAD of an offer and a run that is somehow BEHIND it are
## the same disagreement and are separately composed, separately attempted and
## separately measured; each is then followed by a freshly composed matching offer
## on the SAME root seed, which must succeed — because a seed a refusal quietly
## spent would look exactly like a seed it did not.
##
## THE POSITIVE CASES USE THE SHIPPED CATALOGUES AND NOTHING ELSE. The one
## fabricated object in this file is a purpose-built run build that ACCEPTS both
## support operations and performs neither; it exists so the post-mutation gate
## can be DRIVEN rather than described, it is registered in no catalogue, ships in
## no scene and no `.tres`, and it is not canon.

const CHOICE_FILE: String = "res://scripts/choices/rift_offer_choice.gd"
const RESULT_FILE: String = "res://scripts/choices/rift_offer_choice_result.gd"
const OFFER_FILE: String = "res://scripts/offers/rift_offer.gd"

## The shared validator both sides must ask, and the two rank constants neither
## consumer may restate. A second copy of "a new pair goes from absent to first"
## inside the file that CONSUMES a progression is exactly what the extraction
## exists to prevent, so its absence is asserted rather than assumed.
const SHARED_VALIDATOR: String = "RiftOffer.support_transition_problem"
const RANK_CONSTANT_TOKENS: Array[String] = [
	"AcquiredSupports.ABSENT_RANK", "AcquiredSupports.FIRST_RANK",
]

## The two accepted operations the transaction must route between, by name. A
## transaction that named only one would have inferred the other.
const REQUIRED_OPERATIONS: Array[String] = [
	"build.acquire_support(", "build.rank_support(",
]

## The accepted continuation SELECTOR's call. The transaction reads which
## operation an offer FROZE; making this call would be taking that decision.
const FORBIDDEN_SELECTOR_CALL: String = "SupportContinuation.select"

## Foundation D3's own documented seeds, retyped here rather than read from its
## suite: a check that takes its expected answer from the thing it is checking
## proves only that a file agrees with itself.
const D3_LANE_SEED: int = 0
const D3_TWIN_SEED_A: int = 3
const D3_TWIN_SEED_B: int = 6
const D3_REPEAT_SEED_A: int = 7
const D3_REPEAT_SEED_B: int = 9
const D3_MASKED_LOW: int = -1
const D3_MASKED_HIGH: int = 9223372036854775807

const D3_SEED_CORPUS: Array[int] = [0, 3, 6, 7, 9, -1, 9223372036854775807]

## What the shipped records must produce, typed independently of them.
const EXPECTED_SKILL: StringName = &"quick_strike"
const EXPECTED_SUPPORT: StringName = &"reaching_edge"
const EXPECTED_OTHER_SUPPORT: StringName = &"sweeping_edge"
const EXPECTED_COMBAT_CARD: StringName = &"card_vitality"
const EXPECTED_UTILITY_CARD: StringName = &"card_magnetism"
const EXPECTED_COMBAT_STAT: StringName = &"maximum_life"
const EXPECTED_COMBAT_MAGNITUDE: float = 0.15

## The seed F3 shows its rank worked example at, and the seed corpus this suite
## measures the identity and determinism claims over.
const EXAMPLE_SEED: int = 18
const SEED_SAMPLES: int = 128

## Foundation E2's accepted one-level worked example, retyped.
const E2_ROOT_SEED: int = 0
const E2_REQUIREMENT: float = 100.0

## A progression kind outside the declared two, and a rank nothing composes.
const UNDECLARED_KIND: int = 99
const IMPOSSIBLE_RANK: int = 512

const OWED_CHECKS: Array[String] = [
	"a_fresh_new_pair_offer_is_consumed_exactly_as_it_always_was",
	"a_rank_increase_offer_succeeds_through_the_accepted_rank_operation",
	"both_passive_lanes_are_unchanged_and_carry_no_support_progression",
	"a_stale_rank_offer_refuses_atomically_in_both_directions",
	"a_stale_new_pair_offer_after_acquisition_refuses_atomically",
	"a_post_mutation_rank_that_disagrees_refuses_before_the_seed",
	"a_tampered_progression_is_refused_by_offer_coherence_before_mutation",
	"an_already_consumed_root_seed_keeps_its_accepted_diagnostic_precedence",
	"the_supplied_values_never_move_and_the_returned_values_are_independent",
	"result_coherence_rejects_every_contradictory_progression",
	"the_support_identity_is_still_exactly_two_ordered_ids",
	"the_accepted_d3_new_pair_seed_corpus_is_unchanged",
	"the_accepted_f3_composition_is_deterministic_and_unchanged",
	"the_accepted_e2_worked_example_is_still_a_new_pair_choice",
	"an_exhausted_e2_coordinator_completes_through_a_rank_choice",
	"the_progression_rule_has_exactly_one_owner_and_the_transaction_stays_pure",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0

## Successes driven, counted for the same reason refusals are: two of the
## assertions this suite owes are emitted once per outcome by the two helpers
## below, so the totals are what make the pinned check count reproducible
## arithmetic rather than a number somebody read off a run.
var _successes: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation F4 — Atomic Support Rank-Choice Consumption (D-257) ===")

	_check_a_fresh_new_pair_offer_is_consumed_exactly_as_it_always_was()
	_check_a_rank_increase_offer_succeeds_through_the_accepted_rank_operation()
	_check_both_passive_lanes_are_unchanged()
	_check_a_stale_rank_offer_refuses_atomically_in_both_directions()
	_check_a_stale_new_pair_offer_after_acquisition_refuses_atomically()
	_check_a_post_mutation_rank_that_disagrees_refuses_before_the_seed()
	_check_a_tampered_progression_is_refused_by_offer_coherence()
	_check_an_already_consumed_root_seed_keeps_its_precedence()
	_check_the_supplied_values_never_move_and_the_returned_values_are_independent()
	_check_result_coherence_rejects_every_contradictory_progression()
	_check_the_support_identity_is_still_exactly_two_ordered_ids()
	_check_the_accepted_d3_new_pair_seed_corpus_is_unchanged()
	_check_the_accepted_f3_composition_is_deterministic_and_unchanged()
	_check_the_accepted_e2_worked_example_is_still_a_new_pair_choice()
	_check_an_exhausted_e2_coordinator_completes_through_a_rank_choice()
	_check_the_progression_rule_has_exactly_one_owner()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT SUPPORT RANK CHOICE VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT SUPPORT RANK CHOICE VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. A fresh new pair, taken exactly as Foundation D3 always took it ----------

func _check_a_fresh_new_pair_offer_is_consumed_exactly_as_it_always_was() -> void:
	print("")
	print("--- 1. A fresh NEW_PAIR 0 -> 1 offer is consumed exactly as it always was")

	var offer: RiftOffer = _offer(null, D3_LANE_SEED)
	_expect(offer.ok and offer.problem().is_empty(),
		"the documented offer did not compose: %s" % offer.failure_reason)
	_expect(offer.support_progression_kind == SupportContinuationResult.Kind.NEW_PAIR,
		"root seed %d no longer offers a new pair: %s" % [
			D3_LANE_SEED, offer.support_progression_line()])
	_expect(offer.support_rank_before == AcquiredSupports.ABSENT_RANK
			and offer.support_rank_after == AcquiredSupports.FIRST_RANK,
		"the offer froze %d -> %d" % [offer.support_rank_before, offer.support_rank_after])
	_expect(offer.skill_id == EXPECTED_SKILL and offer.support_id == EXPECTED_SUPPORT,
		"root seed %d offers %s -> %s" % [D3_LANE_SEED, offer.skill_id, offer.support_id])

	var build: RiftRunBuild = RiftRunBuild.new()
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	var before_build: String = _snapshot(build)
	var before_ledger: String = _ledger_snapshot(ledger)

	var result: RiftOfferChoiceResult = RiftOfferChoice.choose(
		offer, RiftOffer.Lane.SUPPORT, build, ledger)
	_expect_success(result, "the support lane of root seed %d" % D3_LANE_SEED)

	## THE IDENTITY IS STILL EXACTLY THE TWO ORDERED IDS D3 GRANTED.
	_expect(" -> ".join(result.chosen_identity())
			== "%s -> %s" % [EXPECTED_SKILL, EXPECTED_SUPPORT],
		"the result granted %s" % result.identity_line())

	## THE PROGRESSION IS RETAINED, ALL THREE VALUES, AND IT IS THE OFFER'S OWN.
	_expect(result.carries_support_progression(),
		"a successful support choice reports no progression: %s"
			% result.support_progression_line())
	_expect(result.support_progression_kind == SupportContinuationResult.Kind.NEW_PAIR
			and result.support_rank_before == AcquiredSupports.ABSENT_RANK
			and result.support_rank_after == AcquiredSupports.FIRST_RANK,
		"the result reports %s" % result.support_progression_line())

	## ONE PAIR AT THE FIRST RANK, AND NOT A SECOND OF ANYTHING.
	_expect(result.new_build.support_rank_for(EXPECTED_SKILL, EXPECTED_SUPPORT)
			== AcquiredSupports.FIRST_RANK,
		"the new build holds the pair at rank %d"
			% result.new_build.support_rank_for(EXPECTED_SKILL, EXPECTED_SUPPORT))
	_expect(result.new_build.support_count() == 1
			and result.new_build.total_support_ranks() == 1,
		"the new build holds %d pairs and %d ranks" % [
			result.new_build.support_count(), result.new_build.total_support_ranks()])

	## AND NO PASSIVE STATE AT ALL — every declared stat, not a sample.
	_expect(result.new_build.passive_acquisitions() == 0
			and result.new_build.acquired_card_ids().is_empty(),
		"the support lane granted %d passive acquisitions"
			% result.new_build.passive_acquisitions())
	_expect(_nonzero_stats(result.new_build).is_empty(),
		"the support lane moved the stats %s" % _nonzero_stats(result.new_build))

	## THE SEED IS SPENT EXACTLY ONCE, AND NOTHING ELSE IS.
	_expect(result.new_ledger.count() == 1
			and result.new_ledger.has_consumed(D3_LANE_SEED),
		"the new ledger holds %s" % result.new_ledger.describe())

	## AND THE SUPPLIED VALUES NEVER MOVED.
	_expect(_snapshot(build) == before_build,
		"the supplied build changed:\n    before %s\n    after  %s" % [
			before_build, _snapshot(build)])
	_expect(_ledger_snapshot(ledger) == before_ledger,
		"the supplied ledger changed: %s -> %s" % [
			before_ledger, _ledger_snapshot(ledger)])

	print("  %s [%s]; 1 pair at rank %d, 0 passives, the supplied values untouched" % [
		result.describe(), result.support_progression_line(),
		result.new_build.support_rank_for(EXPECTED_SKILL, EXPECTED_SUPPORT)])
	_done("a_fresh_new_pair_offer_is_consumed_exactly_as_it_always_was")


# --- 2. A rank increase, through the accepted rank operation ---------------------

func _check_a_rank_increase_offer_succeeds_through_the_accepted_rank_operation() -> void:
	print("")
	print("--- 2. A RANK_INCREASE 1 -> 2 offer succeeds, and a later fresh offer raises the other pair, never the one at its maximum")

	var build: RiftRunBuild = _build_at_rank(AcquiredSupports.FIRST_RANK)
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	var pairs_before: int = build.support_count()
	var ranks_before: int = build.total_support_ranks()
	var before_build: String = _snapshot(build)

	var offer: RiftOffer = _offer(build.acquired_supports(), EXAMPLE_SEED)
	_expect(offer.ok and offer.problem().is_empty(),
		"the exhausted state did not compose: %s" % offer.failure_reason)
	_expect(offer.support_progression_kind == SupportContinuationResult.Kind.RANK_INCREASE,
		"an exhausted pool composed %s" % offer.support_progression_line())
	_expect(offer.support_rank_before == AcquiredSupports.FIRST_RANK
			and offer.support_rank_after == AcquiredSupports.FIRST_RANK + 1,
		"the offer froze %d -> %d" % [offer.support_rank_before, offer.support_rank_after])

	## THE OTHER PAIR, NAMED BEFORE THE CHOICE, so "it did not move" is a claim
	## about a specific thing rather than about an aggregate that could hide it.
	var other: Array = _other_pair(build, offer)
	var other_rank_before: int = build.support_rank_for(other[0], other[1])
	_expect(other_rank_before == AcquiredSupports.FIRST_RANK,
		"the untouched pair %s -> %s starts at rank %d" % [
			other[0], other[1], other_rank_before])

	var raised: RiftOfferChoiceResult = RiftOfferChoice.choose(
		offer, RiftOffer.Lane.SUPPORT, build, ledger)
	_expect_success(raised, "a rank increase of %s" % offer.support_progression_line())
	_expect(raised.support_progression_kind == SupportContinuationResult.Kind.RANK_INCREASE
			and raised.support_rank_before == offer.support_rank_before
			and raised.support_rank_after == offer.support_rank_after,
		"the result reports %s where the offer froze %s" % [
			raised.support_progression_line(), offer.support_progression_line()])

	## ONE MORE RANK, NOT ONE MORE PAIR. The two are different numbers the moment
	## anything is raised, and reporting either where the other was meant would
	## exhaust a pool that still had entries in it.
	_expect(raised.new_build.support_rank_for(offer.skill_id, offer.support_id)
			== offer.support_rank_after,
		"the raised pair holds rank %d" % raised.new_build.support_rank_for(
			offer.skill_id, offer.support_id))
	_expect(raised.new_build.support_count() == pairs_before,
		"the new build holds %d distinct pairs where the run held %d" % [
			raised.new_build.support_count(), pairs_before])
	_expect(raised.new_build.total_support_ranks() == ranks_before + 1,
		"the new build holds %d ranks where the run held %d" % [
			raised.new_build.total_support_ranks(), ranks_before])
	_expect(raised.new_build.support_rank_for(other[0], other[1]) == other_rank_before,
		"%s -> %s moved from rank %d to %d" % [
			other[0], other[1], other_rank_before,
			raised.new_build.support_rank_for(other[0], other[1])])

	## NO PASSIVE STATE MOVED EITHER, ALL SIX TOTALS.
	_expect(raised.new_build.passive_acquisitions() == 0
			and _nonzero_stats(raised.new_build).is_empty(),
		"a rank increase moved passive state: %s" % raised.new_build.describe())
	_expect(raised.new_ledger.has_consumed(EXAMPLE_SEED)
			and raised.new_ledger.count() == 1,
		"the rank choice spent %s" % raised.new_ledger.describe())
	_expect(_snapshot(build) == before_build,
		"the supplied build moved:\n    before %s\n    after  %s" % [
			before_build, _snapshot(build)])

	## A LATER FRESH OFFER, COMPOSED AGAINST THE RUN THE FIRST ONE PRODUCED,
	## STEPS AGAIN — AND IT STEPS THE PAIR THAT CAN STILL BE RAISED. This is the
	## proof that a consumed rank leaves a run a further rank can be composed from
	## rather than a run in a state nothing can read.
	##
	## MOVED ONE FOR ONE BY FOUNDATION I5 (D-300). The first choice took its pair to
	## rank 2, which is that support's maximum, so it is no longer a rank-increase
	## candidate: before maximum-rank filtering this searched for a fresh offer
	## raising that SAME pair 2 -> 3, a rank nothing defines. Every unspent seed now
	## raises the OTHER pair 1 -> 2 instead, and the search counts how often the pair
	## at its maximum was offered again — which must be never.
	##
	## IT MUST BE A DIFFERENT ROOT SEED, AND THAT IS THE ACCEPTED PROTECTION
	## RATHER THAN AN INCONVENIENCE: the first choice spent this run's copy of
	## `EXAMPLE_SEED`, and re-offering it would be refused by the early
	## already-consumed gate before the rank was ever looked at. So the seed is
	## SEARCHED FOR rather than guessed, over every unspent seed of the corpus, and
	## the search asserts it found one, because a loop that found nothing would skip
	## every assertion below it silently.
	var again: RiftOffer = null
	var offered_at_maximum: int = 0
	var probed: int = 0
	for probe: int in SEED_SAMPLES:
		if raised.new_ledger.has_consumed(probe):
			continue
		var candidate: RiftOffer = _offer(raised.new_build.acquired_supports(), probe)
		if not candidate.ok:
			continue
		probed += 1
		if candidate.skill_id == offer.skill_id \
				and candidate.support_id == offer.support_id:
			offered_at_maximum += 1
			continue
		if again == null and candidate.support_progression_kind \
				== SupportContinuationResult.Kind.RANK_INCREASE:
			again = candidate
	_expect(again != null and offered_at_maximum == 0,
		"over %d unspent seeds %s -> %s, at its maximum, was offered %d time(s), and a further rank of the other pair was %s" % [
			probed, offer.skill_id, offer.support_id, offered_at_maximum,
			"never found" if again == null else "found"])
	if again == null:
		_done("a_rank_increase_offer_succeeds_through_the_accepted_rank_operation")
		return
	_expect(again.problem().is_empty(),
		"the second offer is incoherent: %s" % again.problem())
	_expect(again.skill_id == StringName(other[0]) and again.support_id == StringName(other[1])
			and again.support_rank_before == AcquiredSupports.FIRST_RANK
			and again.support_rank_after == AcquiredSupports.FIRST_RANK + 1,
		"the second offer froze %s -> %s %d -> %d" % [
			again.skill_id, again.support_id, again.support_rank_before, again.support_rank_after])

	var third: RiftOfferChoiceResult = RiftOfferChoice.choose(
		again, RiftOffer.Lane.SUPPORT, raised.new_build, raised.new_ledger)
	_expect_success(third, "a second rank increase of %s" % again.support_progression_line())
	_expect(third.new_build.support_rank_for(again.skill_id, again.support_id)
			== AcquiredSupports.FIRST_RANK + 1
			and third.new_build.support_rank_for(offer.skill_id, offer.support_id)
			== AcquiredSupports.FIRST_RANK + 1,
		"the run holds %s -> %s at rank %d and %s -> %s at rank %d" % [
			again.skill_id, again.support_id,
			third.new_build.support_rank_for(again.skill_id, again.support_id),
			offer.skill_id, offer.support_id,
			third.new_build.support_rank_for(offer.skill_id, offer.support_id)])
	_expect(third.new_build.support_count() == pairs_before
			and third.new_build.total_support_ranks() == ranks_before + 2,
		"the twice-raised run holds %d pairs and %d ranks" % [
			third.new_build.support_count(), third.new_build.total_support_ranks()])
	_expect(third.new_ledger.count() == 2
			and third.new_ledger.has_consumed(EXAMPLE_SEED)
			and third.new_ledger.has_consumed(again.root_seed),
		"the twice-raised run spent %s" % third.new_ledger.describe())

	print("  %s -> %s raised %d -> %d, then %s -> %s %d -> %d on a fresh seed (the pair at its maximum offered %d times over %d unspent seeds): "
		% [offer.skill_id, offer.support_id, AcquiredSupports.FIRST_RANK,
			AcquiredSupports.FIRST_RANK + 1, again.skill_id, again.support_id,
			AcquiredSupports.FIRST_RANK, AcquiredSupports.FIRST_RANK + 1,
			offered_at_maximum, probed]
		+ "%d pairs unchanged, %d ranks in all, 0 passives and %d other pair unmoved by the first choice" % [
			third.new_build.support_count(), third.new_build.total_support_ranks(),
			pairs_before - 1])
	_done("a_rank_increase_offer_succeeds_through_the_accepted_rank_operation")


# --- 3. Both passive lanes are behaviourally unchanged ---------------------------

func _check_both_passive_lanes_are_unchanged() -> void:
	print("")
	print("--- 3. Both passive lanes are unchanged and carry no support progression")

	## MEASURED FROM A NEW-PAIR OFFER AND FROM A RANK OFFER, because "the passive
	## lanes did not change" is a claim about the transaction rather than about one
	## kind of support lane, and only the second of the two is new.
	var states: Array = [
		["a new-pair offer", null, D3_LANE_SEED],
		["a rank offer", _record_at_rank(AcquiredSupports.FIRST_RANK), EXAMPLE_SEED],
	]
	var taken: int = 0
	for row: Array in states:
		var acquired: AcquiredSupports = row[1] as AcquiredSupports
		var offer: RiftOffer = _offer(acquired, int(row[2]))
		_expect(offer.ok and offer.problem().is_empty(),
			"%s did not compose: %s" % [String(row[0]), offer.failure_reason])
		for lane: int in [RiftOffer.Lane.COMBAT_DEFENCE, RiftOffer.Lane.UTILITY]:
			var build: RiftRunBuild = _build_from(acquired)
			var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
			var pairs_before: PackedStringArray = build.support_pairs()
			var ranks_before: int = build.total_support_ranks()
			var result: RiftOfferChoiceResult = RiftOfferChoice.choose(
				offer, lane, build, ledger)
			_expect_success(result, "the %s lane of %s" % [
				RiftOffer.lane_label(lane), String(row[0])])
			taken += 1

			## NO PROGRESSION AT ALL, IN ALL THREE FIELDS.
			_expect(not result.carries_support_progression()
					and result.support_progression_kind
						== RiftOffer.UNRESOLVED_PROGRESSION_KIND
					and result.support_rank_before == RiftOfferChoiceResult.NO_RANK
					and result.support_rank_after == RiftOfferChoiceResult.NO_RANK,
				"the %s lane reported %s" % [
					RiftOffer.lane_label(lane), result.support_progression_line()])

			## AND NO SUPPORT STATE MOVED — the pairs and the total ranks, both.
			_expect(", ".join(result.new_build.support_pairs()) == ", ".join(pairs_before),
				"a passive lane changed the pairs to %s"
					% ", ".join(result.new_build.support_pairs()))
			_expect(result.new_build.total_support_ranks() == ranks_before,
				"a passive lane changed the total ranks to %d"
					% result.new_build.total_support_ranks())
			_expect(result.new_build.passive_acquisitions() == 1,
				"a passive lane recorded %d acquisitions"
					% result.new_build.passive_acquisitions())
			_expect(result.support_progression_build_problem().is_empty(),
				"a passive lane makes the build audit report '%s'"
					% result.support_progression_build_problem())

	## AND THE ONE CANONICAL MAGNITUDE, EXACTLY, so "unchanged" is measured against
	## a number rather than against a shape.
	var combat: RiftOfferChoiceResult = RiftOfferChoice.choose(
		_offer(null, D3_LANE_SEED), RiftOffer.Lane.COMBAT_DEFENCE,
		RiftRunBuild.new(), RiftConsumptionLedger.new())
	_expect_success(combat, "the documented Combat and Defence lane")
	_expect(combat.new_build.acquisitions_for(EXPECTED_COMBAT_CARD) == 1,
		"the combat lane granted %s %d times" % [
			EXPECTED_COMBAT_CARD, combat.new_build.acquisitions_for(EXPECTED_COMBAT_CARD)])
	_expect(combat.new_build.total_for(EXPECTED_COMBAT_STAT) == EXPECTED_COMBAT_MAGNITUDE,
		"%s came to %s, not %s" % [EXPECTED_COMBAT_STAT,
			_exact(combat.new_build.total_for(EXPECTED_COMBAT_STAT)),
			_exact(EXPECTED_COMBAT_MAGNITUDE)])

	print("  %d Combat/Defence and Utility choices over new-pair AND rank offers: "
		% taken + "0 carried a progression, 0 moved a pair or a rank, %s = %s exactly"
		% [EXPECTED_COMBAT_STAT, _exact(EXPECTED_COMBAT_MAGNITUDE)])
	_done("both_passive_lanes_are_unchanged_and_carry_no_support_progression")


# --- 4. A stale RANK offer, in both directions -----------------------------------

func _check_a_stale_rank_offer_refuses_atomically_in_both_directions() -> void:
	print("")
	print("--- 4. A stale rank offer refuses atomically whether the run is behind or ahead")

	## TWO DIRECTIONS, COMPOSED SEPARATELY. An offer frozen at a HIGHER rank than
	## the run now holds and an offer frozen at a LOWER one are the same
	## disagreement — the offer no longer describes this run — and a transaction
	## that only refused one of them would silently rebase the other.
	##
	## MOVED ONE FOR ONE BY FOUNDATION I5 (D-300). The two offers used to be composed
	## from runs holding every pair at rank 2 and at rank 3, and neither composes
	## anything now: a pair at its maximum is no longer a rank candidate, and rank 3
	## is above the shipped maximum of 2. So each offer is composed from the one
	## state a shipped rank offer can come from — every pair at rank 1 — and the run
	## it is answered against holds the OFFERED pair behind it (not held at all) or
	## ahead of it (at rank 2, its maximum). The other pair stays at rank 1, so the
	## replacement offer on the same seed still has something to give.
	var directions: Array = [
		["the run is BEHIND the offer", AcquiredSupports.FIRST_RANK,
			AcquiredSupports.ABSENT_RANK],
		["the run is AHEAD of the offer", AcquiredSupports.FIRST_RANK,
			AcquiredSupports.FIRST_RANK + 1],
	]
	var refused: int = 0
	for row: Array in directions:
		var described: String = String(row[0])
		var composed_at: int = int(row[1])
		var held_at: int = int(row[2])

		var offer: RiftOffer = _offer(_record_at_rank(composed_at), EXAMPLE_SEED)
		_expect(offer.ok and offer.problem().is_empty(),
			"%s: the fixture did not compose: %s" % [described, offer.failure_reason])
		_expect(offer.support_progression_kind
				== SupportContinuationResult.Kind.RANK_INCREASE
				and offer.support_rank_before == composed_at,
			"%s: the fixture froze %s" % [described, offer.support_progression_line()])

		var build: RiftRunBuild = _build_holding({offer.support_id: held_at})
		var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
		var current: int = build.support_rank_for(offer.skill_id, offer.support_id)
		_expect(current == held_at and current != offer.support_rank_before,
			"%s: the run holds rank %d against a frozen %d, so nothing is stale" % [
				described, current, offer.support_rank_before])

		var result: RiftOfferChoiceResult = _expect_atomic_refusal(
			RiftOfferChoice.choose(offer, RiftOffer.Lane.SUPPORT, build, ledger),
			build, ledger, described)
		refused += 1

		## THE REFUSAL NAMES THE PAIR AND BOTH NUMBERS. "This offer is stale" is
		## not something a caller can act on.
		_expect(result.failure_reason.contains("stale"),
			"%s: the refusal reads '%s'" % [described, result.failure_reason])
		_expect(result.failure_reason.contains(
					"%s -> %s" % [offer.skill_id, offer.support_id])
				and result.failure_reason.contains("rank %d" % offer.support_rank_before)
				and result.failure_reason.contains("rank %d" % current),
			"%s: the refusal does not name the pair and both ranks: '%s'" % [
				described, result.failure_reason])
		_expect(not result.carries_support_progression()
				and result.support_rank_before == RiftOfferChoiceResult.NO_RANK
				and result.support_rank_after == RiftOfferChoiceResult.NO_RANK,
			"%s: the refusal exposed %s" % [described, result.support_progression_line()])

		## THE SEED IS EXPLICITLY UNSPENT — the half of atomicity a build
		## comparison alone cannot see.
		_expect(not ledger.has_consumed(offer.root_seed) and ledger.is_empty(),
			"%s: a refused stale offer spent %s" % [described, ledger.describe()])

		## AND A NEWLY COMPOSED MATCHING OFFER ON THE SAME ROOT SEED SUCCEEDS,
		## which is what proves the seed really is still there to be spent.
		var fresh: RiftOffer = _offer(build.acquired_supports(), offer.root_seed)
		_expect(fresh.ok and fresh.root_seed == offer.root_seed,
			"%s: the replacement offer did not compose" % described)
		var recovered: RiftOfferChoiceResult = RiftOfferChoice.choose(
			fresh, RiftOffer.Lane.SUPPORT, build, ledger)
		_expect_success(recovered, "%s: a freshly composed matching offer" % described)
		_expect(recovered.new_ledger.has_consumed(offer.root_seed),
			"%s: the replacement did not consume root seed %d" % [
				described, offer.root_seed])
		_expect(recovered.new_build.support_rank_for(fresh.skill_id, fresh.support_id)
				== fresh.support_rank_after,
			"%s: the replacement landed at rank %d" % [described,
				recovered.new_build.support_rank_for(fresh.skill_id, fresh.support_id)])

	_expect(refused == directions.size(),
		"%d of %d stale directions were driven" % [refused, directions.size()])

	print("  %d stale rank offers refused in both directions, each naming the pair and "
		% refused + "both ranks; both seeds stayed spendable and both replacements succeeded")
	_done("a_stale_rank_offer_refuses_atomically_in_both_directions")


# --- 5. A stale NEW PAIR offer, after the pair was acquired ----------------------

func _check_a_stale_new_pair_offer_after_acquisition_refuses_atomically() -> void:
	print("")
	print("--- 5. A new-pair offer whose pair has since been acquired refuses atomically")

	var offer: RiftOffer = _offer(null, D3_LANE_SEED)
	_expect(offer.ok and offer.support_progression_kind
			== SupportContinuationResult.Kind.NEW_PAIR,
		"the fixture is not a new-pair offer: %s" % offer.support_progression_line())

	## THE PAIR IS ESTABLISHED THROUGH THE ACCEPTED OPERATION, so the run the offer
	## is answered against is a real run rather than a fixture that happens to
	## agree with one.
	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_support(offer.skill_id, offer.support_id).is_empty(),
		"the pair could not be established")
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	var current: int = build.support_rank_for(offer.skill_id, offer.support_id)
	_expect(current == AcquiredSupports.FIRST_RANK
			and current != offer.support_rank_before,
		"the run holds rank %d against a frozen %d" % [current, offer.support_rank_before])

	var result: RiftOfferChoiceResult = _expect_atomic_refusal(
		RiftOfferChoice.choose(offer, RiftOffer.Lane.SUPPORT, build, ledger),
		build, ledger, "a new-pair offer for a pair this run has since acquired")
	_expect(result.failure_reason.contains("stale")
			and result.failure_reason.contains(
				"%s -> %s" % [offer.skill_id, offer.support_id])
			and result.failure_reason.contains("rank %d" % offer.support_rank_before)
			and result.failure_reason.contains("rank %d" % current),
		"the refusal reads '%s'" % result.failure_reason)

	## NOTHING WAS SILENTLY REBASED ONTO THE CURRENT RANK, which is the failure
	## this refusal exists to prevent: the pair must still hold exactly what it did.
	_expect(build.support_rank_for(offer.skill_id, offer.support_id) == current,
		"the refused offer moved the pair to rank %d"
			% build.support_rank_for(offer.skill_id, offer.support_id))
	_expect(build.support_count() == 1 and build.total_support_ranks() == 1,
		"the refused offer left %d pairs and %d ranks" % [
			build.support_count(), build.total_support_ranks()])
	_expect(not ledger.has_consumed(offer.root_seed) and ledger.is_empty(),
		"a refused stale new-pair offer spent %s" % ledger.describe())

	## AND THE SAME ROOT SEED STILL BUYS A FRESHLY COMPOSED OFFER.
	var fresh: RiftOffer = _offer(build.acquired_supports(), D3_LANE_SEED)
	_expect(fresh.ok and fresh.root_seed == D3_LANE_SEED,
		"the replacement offer did not compose: %s" % fresh.failure_reason)
	var recovered: RiftOfferChoiceResult = RiftOfferChoice.choose(
		fresh, RiftOffer.Lane.SUPPORT, build, ledger)
	_expect_success(recovered, "a freshly composed offer on the same root seed")
	_expect(recovered.new_ledger.has_consumed(D3_LANE_SEED),
		"the replacement did not consume root seed %d" % D3_LANE_SEED)

	print("  a stale new-pair offer (%s) refuses, names rank %d against the held rank %d, "
		% [offer.support_progression_line(), offer.support_rank_before, current]
		+ "spends nothing, and root seed %d then buys a fresh offer" % D3_LANE_SEED)
	_done("a_stale_new_pair_offer_after_acquisition_refuses_atomically")


# --- 6. The post-mutation gate ---------------------------------------------------

## A RUN BUILD THAT ACCEPTS BOTH SUPPORT OPERATIONS AND PERFORMS NEITHER.
##
## IT EXISTS SO THE POST-MUTATION GATE CAN BE DRIVEN RATHER THAN DESCRIBED. With
## the accepted run build that gate is unreachable — a coherent new pair is
## `0 -> 1` and acquiring always lands on the first rank, a coherent rank increase
## is `N -> N + 1` and raising always lands one above — which is exactly why the
## gate must be proved against something that can fail. The alternative was a
## structural pin saying the lines are present, and a guard nobody has ever seen
## refuse is a guard nobody knows the shape of.
##
## IT OVERRIDES `duplicated()` TOO, AND THAT IS LOAD-BEARING RATHER THAN TIDY. The
## transaction stages on a duplicate, and the accepted duplicate constructs a
## PLAIN run build — so without this override the staged object would be an
## ordinary build that mutates correctly and the probe would prove nothing at all.
##
## IT IS TEST-ONLY. It is in no catalogue, no scene, no `.tres` and no library,
## and nothing outside this file can construct one.
class UnmovedBuild extends RiftRunBuild:
	func duplicated() -> RiftRunBuild:
		var copy: UnmovedBuild = UnmovedBuild.new()
		copy._supports = _supports.duplicated()
		copy._totals = _totals.duplicated()
		copy._card_holds = _card_holds.duplicate(true)
		return copy

	## The accepted operations, through `super`, so the probe can be SEEDED with a
	## real acquisition state before it starts refusing to move.
	func seed_pair(skill_id: StringName, support_id: StringName, to_rank: int) -> void:
		super.acquire_support(skill_id, support_id)
		for _step: int in range(to_rank - AcquiredSupports.FIRST_RANK):
			super.rank_support(skill_id, support_id)

	func acquire_support(_skill_id: StringName, _support_id: StringName) -> String:
		return ""

	func rank_support(_skill_id: StringName, _support_id: StringName) -> String:
		return ""


func _check_a_post_mutation_rank_that_disagrees_refuses_before_the_seed() -> void:
	print("")
	print("--- 6. A staged rank that disagrees with the frozen after-rank refuses first")

	var driven: int = 0
	for row: Array in [
		["a new pair that did not acquire", null, D3_LANE_SEED],
		["a rank increase that did not raise",
			_record_at_rank(AcquiredSupports.FIRST_RANK), EXAMPLE_SEED],
	]:
		var described: String = String(row[0])
		var acquired: AcquiredSupports = row[1] as AcquiredSupports
		var offer: RiftOffer = _offer(acquired, int(row[2]))
		_expect(offer.ok and offer.problem().is_empty(),
			"%s: the fixture did not compose: %s" % [described, offer.failure_reason])

		## THE PROBE IS SEEDED TO EXACTLY THE RANK THE OFFER FROZE, so the
		## precondition PASSES and the only thing left to fail is the outcome.
		var build: UnmovedBuild = UnmovedBuild.new()
		if acquired != null:
			for pair: String in acquired.pairs():
				var parts: PackedStringArray = pair.split(" -> ")
				build.seed_pair(StringName(parts[0]), StringName(parts[1]),
					AcquiredSupports.FIRST_RANK)
		_expect(build.support_rank_for(offer.skill_id, offer.support_id)
				== offer.support_rank_before,
			"%s: the probe holds rank %d against a frozen %d, so the precondition "
				% [described, build.support_rank_for(offer.skill_id, offer.support_id),
					offer.support_rank_before] + "would refuse first")

		var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
		var result: RiftOfferChoiceResult = _expect_atomic_refusal(
			RiftOfferChoice.choose(offer, RiftOffer.Lane.SUPPORT, build, ledger),
			build, ledger, described)
		driven += 1
		_expect(result.failure_reason.contains("reached rank")
				and result.failure_reason.contains(
					"froze rank %d" % offer.support_rank_after),
			"%s: the refusal reads '%s'" % [described, result.failure_reason])
		_expect(not result.failure_reason.contains("stale"),
			"%s: the outcome gate reported a stale offer instead: '%s'" % [
				described, result.failure_reason])

		## THE SEED IS UNSPENT, WHICH IS THE WHOLE POINT OF THE GATE'S POSITION.
		_expect(ledger.is_empty() and not ledger.has_consumed(offer.root_seed),
			"%s: the outcome gate spent %s" % [described, ledger.describe()])

	_expect(driven == 2, "%d of 2 outcome disagreements were driven" % driven)

	## AND THE PROBE REALLY IS THE CAUSE — the same two offers succeed against the
	## accepted run build, so the refusals above are about the outcome rather than
	## about anything this suite got wrong on the way in.
	var control: RiftOfferChoiceResult = RiftOfferChoice.choose(
		_offer(null, D3_LANE_SEED), RiftOffer.Lane.SUPPORT,
		RiftRunBuild.new(), RiftConsumptionLedger.new())
	_expect_success(control, "the same new-pair offer against the accepted run build")

	print("  2 mutations that succeeded without landing where the offer froze refused "
		+ "before the seed; the same offers succeed against the accepted run build")
	_done("a_post_mutation_rank_that_disagrees_refuses_before_the_seed")


# --- 7. A tampered progression is caught by offer coherence -----------------------

func _check_a_tampered_progression_is_refused_by_offer_coherence() -> void:
	print("")
	print("--- 7. A tampered progression kind, before-rank or after-rank refuses first")

	var refused: int = 0
	for row: Array in [
		["an undeclared kind", false, "support_progression_kind", UNDECLARED_KIND],
		["a new pair claiming a rank increase", false, "support_progression_kind",
			SupportContinuationResult.Kind.RANK_INCREASE],
		["a rank increase claiming a new pair", true, "support_progression_kind",
			SupportContinuationResult.Kind.NEW_PAIR],
		["a new pair's before-rank", false, "support_rank_before",
			AcquiredSupports.FIRST_RANK],
		["a new pair's after-rank", false, "support_rank_after", IMPOSSIBLE_RANK],
		["a rank increase's before-rank", true, "support_rank_before",
			AcquiredSupports.ABSENT_RANK],
		["a rank increase's after-rank", true, "support_rank_after", IMPOSSIBLE_RANK],
	]:
		var described: String = String(row[0])
		var ranked: bool = bool(row[1])
		var offer: RiftOffer = _offer(
			_record_at_rank(AcquiredSupports.FIRST_RANK) if ranked else null,
			EXAMPLE_SEED if ranked else D3_LANE_SEED)
		_expect(offer.ok and offer.problem().is_empty(),
			"%s: the fixture did not compose cleanly" % described)

		## EVERY MUTATION IS APPLIED TO A FRESHLY COMPOSED OFFER, so a refusal can
		## never be a leftover from the one before it.
		offer.set(String(row[2]), row[3])
		_expect(not offer.problem().is_empty(),
			"%s: the tampered offer still reports itself coherent" % described)

		var build: RiftRunBuild = _build_at_rank(AcquiredSupports.FIRST_RANK) if ranked \
			else RiftRunBuild.new()
		var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
		var result: RiftOfferChoiceResult = _expect_atomic_refusal(
			RiftOfferChoice.choose(offer, RiftOffer.Lane.SUPPORT, build, ledger),
			build, ledger, described)
		refused += 1

		## THE COHERENCE GATE ANSWERED, WHICH IS BEFORE ANY MUTATION IS STAGED —
		## and it QUOTES the offer's own reason rather than inventing a second one.
		_expect(result.failure_reason.contains("not internally coherent")
				and result.failure_reason.contains(offer.problem()),
			"%s: the refusal reads '%s' rather than quoting '%s'" % [
				described, result.failure_reason, offer.problem()])
		_expect(ledger.is_empty(), "%s: a tampered offer spent %s" % [
			described, ledger.describe()])

	_expect(refused == 7, "%d of 7 tampered progressions were driven" % refused)

	print("  %d tampered progressions refused by offer coherence before any mutation, "
		% refused + "each quoting the offer's own reason; 0 seeds spent")
	_done("a_tampered_progression_is_refused_by_offer_coherence_before_mutation")


# --- 8. The accepted early already-consumed gate still answers first ---------------

func _check_an_already_consumed_root_seed_keeps_its_precedence() -> void:
	print("")
	print("--- 8. One root seed cannot be spent twice, and the spent gate still answers first")

	var build: RiftRunBuild = _build_at_rank(AcquiredSupports.FIRST_RANK)
	var offer: RiftOffer = _offer(build.acquired_supports(), EXAMPLE_SEED)
	_expect(offer.ok and offer.support_progression_kind
			== SupportContinuationResult.Kind.RANK_INCREASE,
		"the fixture is not a rank offer: %s" % offer.support_progression_line())

	var first: RiftOfferChoiceResult = RiftOfferChoice.choose(
		offer, RiftOffer.Lane.SUPPORT, build, RiftConsumptionLedger.new())
	_expect_success(first, "the first consumption of root seed %d" % EXAMPLE_SEED)
	var spent_build: RiftRunBuild = first.new_build
	var spent_ledger: RiftConsumptionLedger = first.new_ledger

	## THE SAME OBJECT, A RECOMPOSED OFFER, AND AN EQUIVALENT ONE. All three are
	## the same root seed and none may spend it again — and the third is the one a
	## content comparison would let through, because nothing here compares what an
	## offer CONTAINS in order to decide whether it may be taken.
	var recomposed: RiftOffer = _offer(build.acquired_supports(), EXAMPLE_SEED)
	var equivalent: RiftOffer = _offer(spent_build.acquired_supports(), EXAMPLE_SEED)
	_expect(recomposed.ok and equivalent.ok,
		"the recomposed or equivalent offer did not compose")
	_expect(recomposed.describe() == offer.describe(),
		"the recomposed offer is not the same offer: %s" % recomposed.describe())

	var attempts: Array = [
		["the same offer object", offer],
		["a recomposed offer on the same root seed", recomposed],
		["an equivalent offer composed from the run it produced", equivalent],
	]
	for row: Array in attempts:
		for lane: int in RiftOffer.LANE_ORDER:
			var result: RiftOfferChoiceResult = _expect_atomic_refusal(
				RiftOfferChoice.choose(row[1] as RiftOffer, lane, spent_build, spent_ledger),
				spent_build, spent_ledger,
				"%s, %s lane" % [String(row[0]), RiftOffer.lane_label(lane)])
			_expect(result.failure_reason.contains("already been consumed"),
				"%s: the refusal reads '%s'" % [String(row[0]), result.failure_reason])

	## THE PRECEDENCE ITSELF: AN OFFER THAT IS BOTH SPENT AND STALE REPORTS SPENT.
	## D-245 accepted that order, and it is the one thing about this transaction a
	## new refusal could most easily have reordered.
	##
	## MOVED ONE FOR ONE BY FOUNDATION I5 (D-300). This offer was composed from every
	## pair at rank 4, which is above the shipped maximum and now composes nothing. It
	## is composed instead from Reaching Edge at its maximum beside Sweeping Edge at
	## rank 1, so it freezes Sweeping Edge 1 -> 2 against a run that already holds it
	## at 2 — stale, on the spent seed, which is exactly the both-faults case.
	var stale_and_spent: RiftOffer = _offer(
		_record_holding({EXPECTED_SUPPORT: AcquiredSupports.FIRST_RANK + 1}), EXAMPLE_SEED)
	_expect(stale_and_spent.ok and stale_and_spent.support_rank_before
			!= spent_build.support_rank_for(
				stale_and_spent.skill_id, stale_and_spent.support_id),
		"the both-faults fixture is not stale against the spent run")
	_expect(spent_ledger.has_consumed(stale_and_spent.root_seed),
		"the both-faults fixture's root seed is not spent, so precedence proves nothing")
	var both: RiftOfferChoiceResult = _expect_atomic_refusal(
		RiftOfferChoice.choose(
			stale_and_spent, RiftOffer.Lane.SUPPORT, spent_build, spent_ledger),
		spent_build, spent_ledger, "an offer that is both spent and stale")
	_expect(both.failure_reason.contains("already been consumed")
			and not both.failure_reason.contains("stale"),
		"an offer that is both spent and stale reports '%s'" % both.failure_reason)

	print("  %d attempts on a spent root seed refused across 3 offer identities and 3 lanes; "
		% (attempts.size() * RiftOffer.LANE_ORDER.size())
		+ "an offer that is both spent and stale still reports spent first")
	_done("an_already_consumed_root_seed_keeps_its_accepted_diagnostic_precedence")


# --- 9. Inputs never move; outputs are independent --------------------------------

func _check_the_supplied_values_never_move_and_the_returned_values_are_independent() -> void:
	print("")
	print("--- 9. The supplied values never move and the returned values are independent")

	var build: RiftRunBuild = _build_at_rank(AcquiredSupports.FIRST_RANK)
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	_expect(ledger.consume(987654321), "the seeded ledger could not record its seed")
	var offer: RiftOffer = _offer(build.acquired_supports(), EXAMPLE_SEED)
	_expect(offer.ok and offer.support_progression_kind
			== SupportContinuationResult.Kind.RANK_INCREASE,
		"the fixture is not a rank offer: %s" % offer.support_progression_line())

	var before_build: String = _snapshot(build)
	var before_ledger: String = _ledger_snapshot(ledger)
	var result: RiftOfferChoiceResult = RiftOfferChoice.choose(
		offer, RiftOffer.Lane.SUPPORT, build, ledger)
	_expect_success(result, "a rank increase against a seeded run")

	## THE INPUTS, WHOLE, INCLUDING EVERY PAIR'S RANK. `support_pairs()` and
	## `support_count()` are rank-free by the accepted D-252 ruling, so a snapshot
	## built out of them alone would report a run whose rank had silently moved as
	## unchanged — which is exactly the mutation this foundation introduces.
	_expect(_snapshot(build) == before_build,
		"the supplied build moved:\n    before %s\n    after  %s" % [
			before_build, _snapshot(build)])
	_expect(_ledger_snapshot(ledger) == before_ledger,
		"the supplied ledger moved: %s -> %s" % [before_ledger, _ledger_snapshot(ledger)])

	## THE GRANTED IDENTITY IS ANSWERED BY COPY, which D-249 measured and this
	## foundation must not have undone by adding three fields beside it.
	##
	## IT NO LONGER MATTERS THAT THIS COMES BEFORE THE PROBES BELOW, AND THE
	## CORRECTION IS RECORDED RATHER THAN QUIETLY DROPPED (D-258). This paragraph
	## used to say the ordering was load-bearing, because `problem()` then required
	## the CARRIED BUILD to still sit at the rank the choice reached — so a probe
	## that raised that support afterwards made a finished, correct result start
	## reporting itself incoherent. That requirement has moved to
	## `support_progression_build_problem()`, and `problem()` now answers about the
	## transaction rather than about a live object, so it is stable across
	## everything below.
	var read_once: PackedStringArray = result.chosen_identity()
	var expected: String = " -> ".join(read_once)
	read_once.append("zz_injected")
	_expect(" -> ".join(result.chosen_identity()) == expected,
		"mutating a read identity changed the result to %s"
			% " -> ".join(result.chosen_identity()))
	_expect(result.chosen_identity().size() == 2,
		"the identity is now %d ids long" % result.chosen_identity().size())
	_expect(result.problem().is_empty(),
		"the result stopped being coherent after a caller read it: %s" % result.problem())

	## AND THEY ARE INDEPENDENT IN BOTH DIRECTIONS. Moving the input afterwards
	## must not reach the result, and moving the result must not reach the input:
	## one direction alone is satisfied by two objects that merely happen not to
	## have been touched yet.
	var result_build_before: String = _snapshot(result.new_build)
	var result_ledger_before: String = _ledger_snapshot(result.new_ledger)
	_expect(build.acquire_support(&"zz_probe_skill", &"zz_probe_support").is_empty(),
		"the input build refused a probe acquisition")
	_expect(ledger.consume(123456789), "the input ledger refused a probe seed")
	_expect(_snapshot(result.new_build) == result_build_before,
		"moving the supplied build changed the returned one: %s"
			% _snapshot(result.new_build))
	_expect(_ledger_snapshot(result.new_ledger) == result_ledger_before,
		"moving the supplied ledger changed the returned one: %s"
			% _ledger_snapshot(result.new_ledger))

	var input_build_after: String = _snapshot(build)
	var input_ledger_after: String = _ledger_snapshot(ledger)
	_expect(result.new_build.rank_support(offer.skill_id, offer.support_id).is_empty(),
		"the returned build refused a probe rank increase")
	_expect(result.new_ledger.consume(24680), "the returned ledger refused a probe seed")
	_expect(_snapshot(build) == input_build_after,
		"moving the returned build changed the supplied one: %s" % _snapshot(build))
	_expect(_ledger_snapshot(ledger) == input_ledger_after,
		"moving the returned ledger changed the supplied one: %s" % _ledger_snapshot(ledger))

	## AND THIS IS THE CORRECTION ITSELF (D-258), DRIVEN RATHER THAN DESCRIBED. The
	## probe above did the ordinary next thing a run does with the value it was
	## handed: it raised that same support again, legitimately, through the accepted
	## operation. The TRANSACTION did not change, so the result must still report
	## itself coherent — and the separate audit must report that the build has moved
	## on. Two questions, two answers, and the old shape could give only one.
	var frozen_kind: int = result.support_progression_kind
	var frozen_before: int = result.support_rank_before
	var frozen_after: int = result.support_rank_after
	var frozen_identity: String = " -> ".join(result.chosen_identity())
	var frozen_seed: int = result.root_seed
	var frozen_lane: int = result.lane

	_expect(result.problem().is_empty(),
		"a legitimate later rank increase made a finished result incoherent: '%s'"
			% result.problem())

	var audit: String = result.support_progression_build_problem()
	_expect(not audit.is_empty(),
		"the audit reports nothing after the carried build moved on")
	_expect(audit.contains("%s -> %s" % [offer.skill_id, offer.support_id])
			and audit.contains("rank %d" % frozen_after)
			and audit.contains("rank %d" % result.new_build.support_rank_for(
				offer.skill_id, offer.support_id)),
		"the audit reads '%s' and does not name the pair, the consumed rank and the current one"
			% audit)

	## AND NOT ONE STABLE FACT MOVED WITH IT. The frozen progression, the identity,
	## the seed and the lane are what the result IS; only the build it is holding
	## changed, and none of them may follow it.
	_expect(result.support_progression_kind == frozen_kind
			and result.support_rank_before == frozen_before
			and result.support_rank_after == frozen_after,
		"the frozen progression moved to %s" % result.support_progression_line())
	_expect(" -> ".join(result.chosen_identity()) == frozen_identity
			and result.root_seed == frozen_seed and result.lane == frozen_lane,
		"the result's identity, seed or lane moved: %s" % result.describe())
	_expect(result.carries_support_progression(),
		"the result stopped carrying its progression after the build moved on")

	## A REFUSAL LEAVES BOTH SUPPLIED VALUES WHERE THEY WERE TOO — measured on a
	## seeded run rather than an empty one, because "nothing changed" is nearly
	## free to satisfy when there was nothing there.
	##
	## MOVED ONE FOR ONE BY FOUNDATION I5 (D-300). The stale offer was composed from
	## every pair at rank 5, above the shipped maximum, which now composes nothing;
	## and every rank offer a shipped state can still compose freezes 1 -> 2, which
	## this seeded run — both pairs at rank 1 — matches. So the stale offer is the
	## other kind a run can outgrow: a NEW-PAIR offer composed from nothing held,
	## whose pair this run already holds.
	var stale: RiftOffer = _offer(null, EXAMPLE_SEED)
	_expect(stale.ok, "the stale fixture did not compose")
	_expect_atomic_refusal(
		RiftOfferChoice.choose(stale, RiftOffer.Lane.SUPPORT, build, ledger),
		build, ledger, "a stale new-pair offer against a seeded run")

	print("  the supplied build and ledger never moved on success or failure; the returned "
		+ "values are independent in both directions; and a later legitimate rank leaves "
		+ "problem() empty while the audit reports '%s'" % audit)
	_done("the_supplied_values_never_move_and_the_returned_values_are_independent")


# --- 10. Result coherence -----------------------------------------------------------

func _check_result_coherence_rejects_every_contradictory_progression() -> void:
	print("")
	print("--- 10. Every contradictory progression on a result is reported by problem()")

	var reported: int = 0

	## EACH MUTATION IS APPLIED TO A FRESHLY PRODUCED RESULT, so a report can never
	## be a leftover from the one before it.
	for row: Array in [
		["a new pair claiming a rank increase", false, "support_progression_kind",
			SupportContinuationResult.Kind.RANK_INCREASE, "not a held rank"],
		["a new pair with no kind at all", false, "support_progression_kind",
			RiftOffer.UNRESOLVED_PROGRESSION_KIND, "unknown support progression kind"],
		["a new pair's before-rank", false, "support_rank_before",
			AcquiredSupports.FIRST_RANK, "a new pair must freeze"],
		["a new pair's after-rank", false, "support_rank_after", IMPOSSIBLE_RANK,
			"a new pair must freeze"],
		["a rank increase claiming a new pair", true, "support_progression_kind",
			SupportContinuationResult.Kind.NEW_PAIR, "a new pair must freeze"],
		["a rank increase's after-rank", true, "support_rank_after", IMPOSSIBLE_RANK,
			"a single step"],
		["an undeclared kind", true, "support_progression_kind", UNDECLARED_KIND,
			"unknown support progression kind"],
	]:
		var described: String = String(row[0])
		var result: RiftOfferChoiceResult = _support_success(bool(row[1]))
		_expect(result.problem().is_empty(),
			"%s: the fixture result is already incoherent: %s" % [
				described, result.problem()])
		result.set(String(row[2]), row[3])
		var problem: String = result.problem()
		_expect(not problem.is_empty(), "%s was not reported" % described)
		_expect(problem.contains(String(row[4])),
			"%s reported '%s', which does not name '%s'" % [
				described, problem, String(row[4])])
		reported += 1

	## A LEGAL TRANSITION THE CARRIED BUILD DOES NOT AGREE WITH, AND IT IS THE ONE
	## CASE THAT BELONGS TO THE AUDIT RATHER THAN TO `problem()` (D-258). The
	## shared validator cannot see it — the step is legal — and the build is a live
	## object, so this is a question about NOW rather than a contradiction in the
	## record. `problem()` must stay empty and the audit must speak.
	var shifted: RiftOfferChoiceResult = _support_success(true)
	shifted.support_rank_before = shifted.support_rank_after
	shifted.support_rank_after = shifted.support_rank_after + 1
	_expect(RiftOffer.support_transition_problem(shifted.support_progression_kind,
			shifted.support_rank_before, shifted.support_rank_after).is_empty(),
		"the shifted transition is not legal, so this proves the wrong thing")
	_expect(shifted.problem().is_empty(),
		"a legal transition the build disagrees with made problem() report '%s'"
			% shifted.problem())
	_expect(shifted.support_progression_build_problem().contains(
			"rank %d" % shifted.support_rank_after),
		"the audit reads '%s'" % shifted.support_progression_build_problem())

	## A PURPORTED SUCCESS WITH NO BUILD AT ALL. `problem()` owns that refusal, and
	## the audit deliberately says nothing rather than manufacturing a mismatch out
	## of two absent values — which is the ownership line drawn in the direction
	## that is easy to get backwards.
	var buildless: RiftOfferChoiceResult = RiftOfferChoiceResult.chosen(
		D3_LANE_SEED, RiftOffer.Lane.SUPPORT,
		PackedStringArray([String(EXPECTED_SKILL), String(EXPECTED_SUPPORT)]),
		SupportContinuationResult.Kind.NEW_PAIR,
		AcquiredSupports.ABSENT_RANK, AcquiredSupports.FIRST_RANK,
		null, RiftConsumptionLedger.new())
	_expect(buildless.problem().contains("must carry the new run build"),
		"a success with no build reports '%s'" % buildless.problem())
	_expect(buildless.support_progression_build_problem().is_empty(),
		"a success with no build makes the audit report '%s'"
			% buildless.support_progression_build_problem())
	reported += 1

	## A PASSIVE SUCCESS THAT DECLARED AN OPERATION, AND ONE THAT EXPOSED A RANK.
	for row: Array in [
		["a passive success declaring a kind", "support_progression_kind",
			SupportContinuationResult.Kind.NEW_PAIR, "declares support progression kind"],
		["a passive success exposing a rank", "support_rank_after",
			AcquiredSupports.FIRST_RANK, "exposes the support ranks"],
	]:
		var passive: RiftOfferChoiceResult = RiftOfferChoice.choose(
			_offer(null, D3_LANE_SEED), RiftOffer.Lane.COMBAT_DEFENCE,
			RiftRunBuild.new(), RiftConsumptionLedger.new())
		_expect(passive.ok and passive.problem().is_empty(),
			"%s: the passive fixture is not coherent" % String(row[0]))
		passive.set(String(row[1]), row[2])
		_expect(passive.problem().contains(String(row[3])),
			"%s reported '%s'" % [String(row[0]), passive.problem()])
		reported += 1

	## AND A REFUSAL THAT EXPOSED EITHER.
	for row: Array in [
		["a refusal declaring a kind", "support_progression_kind",
			SupportContinuationResult.Kind.RANK_INCREASE,
			"must declare no support progression kind"],
		["a refusal exposing a rank", "support_rank_before",
			AcquiredSupports.FIRST_RANK, "must expose no support rank"],
	]:
		var refusal: RiftOfferChoiceResult = RiftOfferChoiceResult.refused(
			"zz refused for this check", D3_LANE_SEED, RiftOffer.Lane.SUPPORT)
		_expect(refusal.problem().is_empty(),
			"%s: the refusal fixture is not coherent" % String(row[0]))
		refusal.set(String(row[1]), row[2])
		_expect(refusal.problem().contains(String(row[3])),
			"%s reported '%s'" % [String(row[0]), refusal.problem()])
		reported += 1

	## AND `carries_support_progression()` READS THE KIND RATHER THAN THE LANE,
	## which is what keeps it from reporting an incoherent result as healthy.
	var support: RiftOfferChoiceResult = _support_success(false)
	var passive_ok: RiftOfferChoiceResult = RiftOfferChoice.choose(
		_offer(null, D3_LANE_SEED), RiftOffer.Lane.UTILITY,
		RiftRunBuild.new(), RiftConsumptionLedger.new())
	var plain_refusal: RiftOfferChoiceResult = RiftOfferChoiceResult.refused(
		"zz refused for this check", D3_LANE_SEED, RiftOffer.Lane.SUPPORT)
	_expect(support.carries_support_progression()
			and not passive_ok.carries_support_progression()
			and not plain_refusal.carries_support_progression(),
		"the progression flag answers %s / %s / %s" % [
			support.carries_support_progression(),
			passive_ok.carries_support_progression(),
			plain_refusal.carries_support_progression()])
	_expect(plain_refusal.support_progression_line() == "no support progression"
			and passive_ok.support_progression_line() == "no support progression",
		"a refusal and a passive success report '%s' and '%s'" % [
			plain_refusal.support_progression_line(),
			passive_ok.support_progression_line()])

	## AND NEITHER HAS AN APPLICABLE BUILD COMPARISON (D-258). A passive success
	## carries a real build and no progression; a refusal carries neither. The audit
	## answers "" for both, because there is nothing to compare rather than because
	## it happened to agree.
	_expect(passive_ok.support_progression_build_problem().is_empty()
			and plain_refusal.support_progression_build_problem().is_empty()
			and support.support_progression_build_problem().is_empty(),
		"the audit reports '%s' / '%s' / '%s'" % [
			passive_ok.support_progression_build_problem(),
			plain_refusal.support_progression_build_problem(),
			support.support_progression_build_problem()])

	print("  %d stable-fact contradictions reported by problem(); a legal transition the "
		% reported + "carried build disagrees with is reported by the point-in-time audit instead")
	_done("result_coherence_rejects_every_contradictory_progression")


# --- 11. The support identity is untouched -----------------------------------------

func _check_the_support_identity_is_still_exactly_two_ordered_ids() -> void:
	print("")
	print("--- 11. Every support choice grants exactly two ordered ids and no more")

	var measured: int = 0
	var ranked_seen: int = 0
	var new_seen: int = 0
	for seed_value: int in SEED_SAMPLES:
		for row: Array in [
			[null, RiftRunBuild.new()],
			[_record_at_rank(AcquiredSupports.FIRST_RANK),
				_build_at_rank(AcquiredSupports.FIRST_RANK)],
		]:
			var offer: RiftOffer = _offer(row[0] as AcquiredSupports, seed_value)
			if not offer.ok:
				_expect(false, "seed %d refused while measuring identities" % seed_value)
				continue
			var result: RiftOfferChoiceResult = RiftOfferChoice.choose(
				offer, RiftOffer.Lane.SUPPORT, row[1] as RiftRunBuild,
				RiftConsumptionLedger.new())
			if not result.ok:
				_expect(false, "seed %d was refused: %s" % [seed_value, result.failure_reason])
				continue
			var identity: PackedStringArray = result.chosen_identity()
			if identity.size() != 2 or StringName(identity[0]) != offer.skill_id \
					or StringName(identity[1]) != offer.support_id:
				_expect(false, "seed %d granted [%s]" % [seed_value, ", ".join(identity)])
				continue
			## NEITHER THE KIND NOR EITHER RANK REACHED THE IDENTITY OR THE
			## ACCEPTED PRESENTATION. `describe()` is what the accepted suites
			## compare, and a progression appearing inside it would change what
			## those comparisons mean.
			if result.identity_line().contains("rank") or result.describe().contains("rank"):
				_expect(false, "seed %d renders a rank in %s" % [seed_value, result.describe()])
				continue
			if result.support_progression_kind == SupportContinuationResult.Kind.RANK_INCREASE:
				ranked_seen += 1
			else:
				new_seen += 1
			measured += 1
	_expect(measured == SEED_SAMPLES * 2,
		"%d of %d support identities were measured" % [measured, SEED_SAMPLES * 2])
	_expect(new_seen == SEED_SAMPLES and ranked_seen == SEED_SAMPLES,
		"%d new-pair and %d rank identities were measured" % [new_seen, ranked_seen])
	_expect(RiftOfferChoiceResult.identity_size_for(RiftOffer.Lane.SUPPORT) == 2,
		"the support lane's owed identity size is now %d"
			% RiftOfferChoiceResult.identity_size_for(RiftOffer.Lane.SUPPORT))

	print("  %d support identities over new-pair AND rank choices are exactly 2 ordered ids; "
		% measured + "the accepted identity and presentation are unchanged")
	_done("the_support_identity_is_still_exactly_two_ordered_ids")


# --- 12. Foundation D3's documented new-pair corpus ---------------------------------

func _check_the_accepted_d3_new_pair_seed_corpus_is_unchanged() -> void:
	print("")
	print("--- 12. Every documented Foundation D3 seed still takes its new pair unchanged")

	## THE SEEDS ARE RETYPED FROM THE ACCEPTED SUITE RATHER THAN READ FROM IT, and
	## the expected answers are typed independently of the catalogue: a check that
	## takes its expected answer from the thing it is checking proves only that a
	## file agrees with itself.
	var taken: int = 0
	for root_seed: int in D3_SEED_CORPUS:
		var offer: RiftOffer = _offer(null, root_seed)
		if not offer.ok:
			_expect(false, "documented root seed %d no longer composes" % root_seed)
			continue
		if offer.support_progression_kind != SupportContinuationResult.Kind.NEW_PAIR \
				or offer.support_rank_before != AcquiredSupports.ABSENT_RANK \
				or offer.support_rank_after != AcquiredSupports.FIRST_RANK:
			_expect(false, "documented root seed %d now offers %s" % [
				root_seed, offer.support_progression_line()])
			continue
		var result: RiftOfferChoiceResult = RiftOfferChoice.choose(
			offer, RiftOffer.Lane.SUPPORT, RiftRunBuild.new(), RiftConsumptionLedger.new())
		if not result.ok:
			_expect(false, "documented root seed %d was refused: %s" % [
				root_seed, result.failure_reason])
			continue
		var landed: int = result.new_build.support_rank_for(
			offer.skill_id, offer.support_id)
		if result.new_build.support_count() != 1 \
				or result.new_build.total_support_ranks() != 1 \
				or landed != AcquiredSupports.FIRST_RANK:
			_expect(false, "documented root seed %d produced %s" % [
				root_seed, result.new_build.describe()])
			continue
		if not result.new_ledger.has_consumed(root_seed) or result.new_ledger.count() != 1:
			_expect(false, "documented root seed %d spent %s" % [
				root_seed, result.new_ledger.describe()])
			continue
		taken += 1
	_expect(taken == D3_SEED_CORPUS.size(),
		"%d of %d documented seeds took their new pair" % [taken, D3_SEED_CORPUS.size()])

	## THE TWO DOCUMENTED TWINS ARE STILL ONE COMPOSITION QUESTION AND TWO OFFERS,
	## and the two masked extremes are still independently spendable — the property
	## the complete root seed being the consumption identity exists to give.
	for row: Array in [
		["the documented twins", D3_TWIN_SEED_A, D3_TWIN_SEED_B],
		["the two masked extremes", D3_MASKED_LOW, D3_MASKED_HIGH],
		["the two repeatable-card seeds", D3_REPEAT_SEED_A, D3_REPEAT_SEED_B],
	]:
		var described: String = String(row[0])
		var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
		var first: RiftOfferChoiceResult = RiftOfferChoice.choose(
			_offer(null, int(row[1])), RiftOffer.Lane.COMBAT_DEFENCE,
			RiftRunBuild.new(), ledger)
		_expect_success(first, "%s: the first seed" % described)
		var second: RiftOfferChoiceResult = RiftOfferChoice.choose(
			_offer(null, int(row[2])), RiftOffer.Lane.COMBAT_DEFENCE,
			first.new_build, first.new_ledger)
		_expect_success(second, "%s: the second seed" % described)
		_expect(second.new_ledger.count() == 2
				and second.new_ledger.has_consumed(int(row[1]))
				and second.new_ledger.has_consumed(int(row[2])),
			"%s: the ledger holds %s" % [described, second.new_ledger.describe()])

	print("  %d documented Foundation D3 seeds still take their new pair at rank %d -> %d, "
		% [taken, AcquiredSupports.ABSENT_RANK, AcquiredSupports.FIRST_RANK]
		+ "and 3 documented seed pairs are still independently spendable")
	_done("the_accepted_d3_new_pair_seed_corpus_is_unchanged")


# --- 13. Foundation F3's composition is untouched -------------------------------------

func _check_the_accepted_f3_composition_is_deterministic_and_unchanged() -> void:
	print("")
	print("--- 13. F3's composition is byte-for-byte deterministic and untouched by F4")

	## THE WHOLE COMPOSED OFFER AS ONE COMPARABLE STRING, PROGRESSION INCLUDED. A
	## determinism proof that compared everything except the frozen kind and the
	## two ranks would be comparing less than the whole answer.
	var drifted: int = 0
	var ranked: int = 0
	var fresh: int = 0
	var held: AcquiredSupports = _record_at_rank(AcquiredSupports.FIRST_RANK)
	for seed_value: int in SEED_SAMPLES:
		for acquired: AcquiredSupports in [null, held] as Array[AcquiredSupports]:
			var once: RiftOffer = _offer(acquired, seed_value)
			var twice: RiftOffer = _offer(acquired, seed_value)
			if _full(once) != _full(twice):
				drifted += 1
				continue
			if not once.ok:
				_expect(false, "seed %d refused: %s" % [seed_value, once.failure_reason])
				continue
			if once.support_progression_kind == SupportContinuationResult.Kind.RANK_INCREASE:
				ranked += 1
			else:
				fresh += 1
	_expect(drifted == 0,
		"%d of %d compositions disagreed with themselves" % [drifted, SEED_SAMPLES * 2])
	_expect(fresh == SEED_SAMPLES and ranked == SEED_SAMPLES,
		"%d new-pair and %d rank compositions over %d seeds each" % [
			fresh, ranked, SEED_SAMPLES])

	## AND THE DOCUMENTED EXAMPLE IS EXACTLY WHAT F3 RECORDED, typed here rather
	## than read from that suite.
	var example: RiftOffer = _offer(null, D3_LANE_SEED)
	_expect(example.ok and example.skill_id == EXPECTED_SKILL
			and example.support_id == EXPECTED_SUPPORT
			and example.combat_card_id == EXPECTED_COMBAT_CARD
			and example.utility_card_id == EXPECTED_UTILITY_CARD,
		"root seed %d composes %s" % [D3_LANE_SEED, example.offer_line()])
	_expect(example.support_progression_line()
			== "a new compatible pair, rank %d -> %d" % [
				AcquiredSupports.ABSENT_RANK, AcquiredSupports.FIRST_RANK],
		"the documented example reports '%s'" % example.support_progression_line())
	## THE OFFER'S OWN PRESENTATION IS STILL RANK-FREE, which is D-256's third
	## ruling and is the one thing an added consumer could most easily have
	## dragged a rank into.
	_expect(not example.offer_line().contains("rank")
			and not example.seed_line().contains("rank")
			and not example.describe().contains("rank"),
		"the accepted offer presentation now states a rank: %s" % example.describe())

	print("  %d compositions over %d seeds and 2 acquisition states reproduce themselves "
		% [SEED_SAMPLES * 2, SEED_SAMPLES]
		+ "exactly, progression included; the accepted presentation is unchanged")
	_done("the_accepted_f3_composition_is_deterministic_and_unchanged")


# --- 14. Foundation E2's accepted worked example ---------------------------------------

func _check_the_accepted_e2_worked_example_is_still_a_new_pair_choice() -> void:
	print("")
	print("--- 14. E2's accepted one-level worked example is still a new-pair choice")

	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()
	_expect(lifecycle.award_experience(E2_REQUIREMENT).is_empty(),
		"the seeding award was refused")
	_expect(lifecycle.open_offer(E2_REQUIREMENT,
			SkillSupportCatalogue.skill_profiles(),
			SkillSupportCatalogue.support_definitions(),
			PassiveCardCatalogue.records(), E2_ROOT_SEED).is_empty(),
		"the accepted worked example's offer did not open")

	var identity: PackedStringArray = lifecycle.offer_identity_for(RiftOffer.Lane.SUPPORT)
	_expect(identity.size() == 2 and StringName(identity[0]) == EXPECTED_SKILL
			and StringName(identity[1]) == EXPECTED_SUPPORT,
		"the worked example offers [%s]" % ", ".join(identity))

	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.SUPPORT)
	_expect(outcome.ok and outcome.problem().is_empty(),
		"the worked example's choice was refused: %s" % outcome.failure_reason)
	_expect(lifecycle.level() == 2, "the worked example reached Level %d" % lifecycle.level())
	_expect(lifecycle.is_completed(), "the worked example did not finish")

	var final_build: RiftRunBuild = lifecycle.run_build()
	_expect(final_build.support_count() == 1 and final_build.total_support_ranks() == 1,
		"the worked example holds %d pairs and %d ranks" % [
			final_build.support_count(), final_build.total_support_ranks()])
	_expect(final_build.support_rank_for(EXPECTED_SKILL, EXPECTED_SUPPORT)
			== AcquiredSupports.FIRST_RANK,
		"the worked example holds the pair at rank %d"
			% final_build.support_rank_for(EXPECTED_SKILL, EXPECTED_SUPPORT))
	_expect(final_build.passive_acquisitions() == 0
			and _nonzero_stats(final_build).is_empty(),
		"the worked example moved passive state: %s" % final_build.describe())
	_expect(lifecycle.consumption_ledger().has_consumed(E2_ROOT_SEED),
		"the worked example did not consume root seed %d" % E2_ROOT_SEED)

	print("  root seed %d still opens %s -> %s as a new pair and still ends at Level %d "
		% [E2_ROOT_SEED, EXPECTED_SKILL, EXPECTED_SUPPORT, lifecycle.level()]
		+ "with 1 pair at rank %d and 0 passives"
			% final_build.support_rank_for(EXPECTED_SKILL, EXPECTED_SUPPORT))
	_done("the_accepted_e2_worked_example_is_still_a_new_pair_choice")


# --- 15. An exhausted E2 coordinator completes through a rank choice ---------------------

func _check_an_exhausted_e2_coordinator_completes_through_a_rank_choice() -> void:
	print("")
	print("--- 15. An exhausted E2 coordinator completes its one level-up through a rank")

	## THE COORDINATOR IS UNCHANGED BY THIS FOUNDATION AND BENEFITS THROUGH ITS
	## EXISTING CALL. It composes against its own acquisition snapshot, hands the
	## standing offer and the requested lane to the accepted transaction, and
	## commits what that transaction returns. Nothing was added to it by F4, and F4
	## propagated no progression into its own result type. Foundation F5 (D-260)
	## later carried the consumed progression into that result — copied whole out of
	## the successful choice result — and its own suite proves it; this check still
	## asserts only what F4 owns.
	var exhausted: RiftRunBuild = _build_at_rank(AcquiredSupports.FIRST_RANK)
	var pairs_before: int = exhausted.support_count()
	var ranks_before: int = exhausted.total_support_ranks()
	_expect(pairs_before > 0 and ranks_before == pairs_before,
		"the exhausted fixture holds %d pairs and %d ranks" % [pairs_before, ranks_before])

	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(
		null, exhausted, null)
	_expect(lifecycle.award_experience(E2_REQUIREMENT).is_empty(),
		"the seeding award was refused")
	_expect(lifecycle.open_offer(E2_REQUIREMENT,
			SkillSupportCatalogue.skill_profiles(),
			SkillSupportCatalogue.support_definitions(),
			PassiveCardCatalogue.records(), EXAMPLE_SEED).is_empty(),
		"the exhausted coordinator's offer did not open")
	_expect(lifecycle.is_offer_active() and lifecycle.level() == 1,
		"the offer did not stand, or the level moved on the question: Level %d"
			% lifecycle.level())

	var identity: PackedStringArray = lifecycle.offer_identity_for(RiftOffer.Lane.SUPPORT)
	_expect(identity.size() == 2, "the standing offer grants [%s]" % ", ".join(identity))
	var skill_id: StringName = StringName(identity[0])
	var support_id: StringName = StringName(identity[1])
	var rank_before: int = lifecycle.run_build().support_rank_for(skill_id, support_id)
	_expect(rank_before == AcquiredSupports.FIRST_RANK,
		"the offered pair is held at rank %d, so this is not a rank choice" % rank_before)

	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.SUPPORT)
	_expect(outcome.ok and outcome.problem().is_empty(),
		"the exhausted coordinator's rank choice was refused: %s" % outcome.failure_reason)
	_expect(lifecycle.level() == 2,
		"the exhausted coordinator reached Level %d" % lifecycle.level())
	_expect(lifecycle.is_completed() and not lifecycle.is_offer_active(),
		"the exhausted coordinator is completed=%s with an offer standing=%s" % [
			lifecycle.is_completed(), lifecycle.is_offer_active()])

	var after: RiftRunBuild = lifecycle.run_build()
	_expect(after.support_rank_for(skill_id, support_id) == rank_before + 1,
		"the raised pair holds rank %d" % after.support_rank_for(skill_id, support_id))
	_expect(after.support_count() == pairs_before,
		"the run holds %d distinct pairs where it held %d" % [
			after.support_count(), pairs_before])
	_expect(after.total_support_ranks() == ranks_before + 1,
		"the run holds %d ranks where it held %d" % [
			after.total_support_ranks(), ranks_before])
	_expect(after.passive_acquisitions() == 0 and _nonzero_stats(after).is_empty(),
		"the rank choice moved passive state: %s" % after.describe())
	_expect(lifecycle.consumption_ledger().has_consumed(EXAMPLE_SEED),
		"the rank choice did not consume root seed %d" % EXAMPLE_SEED)

	## AND IT IS PERMANENTLY FINISHED. A coordinator that completed through a rank
	## must be as finished as one that completed through a new pair — no second
	## award, no second offer, no second lane.
	_expect(not lifecycle.award_experience(E2_REQUIREMENT).is_empty(),
		"a finished coordinator accepted a further award")
	_expect(not lifecycle.open_offer(E2_REQUIREMENT,
			SkillSupportCatalogue.skill_profiles(),
			SkillSupportCatalogue.support_definitions(),
			PassiveCardCatalogue.records(), EXAMPLE_SEED + 1).is_empty(),
		"a finished coordinator opened a second offer")
	var second: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.SUPPORT)
	_expect(not second.ok, "a finished coordinator took a second lane")
	_expect(lifecycle.level() == 2 and lifecycle.is_completed(),
		"a finished coordinator moved to Level %d" % lifecycle.level())
	_expect(after.support_rank_for(skill_id, support_id) == rank_before + 1,
		"the refused second attempt moved the rank to %d"
			% lifecycle.run_build().support_rank_for(skill_id, support_id))

	print("  an exhausted coordinator completes its one level-up through %s -> %s rank %d -> %d: "
		% [skill_id, support_id, rank_before, rank_before + 1]
		+ "Level %d, %d pairs, %d ranks, permanently finished" % [
			lifecycle.level(), after.support_count(), after.total_support_ranks()])
	_done("an_exhausted_e2_coordinator_completes_through_a_rank_choice")


# --- 16. One owner for the progression rule, and a still-pure transaction -----------

func _check_the_progression_rule_has_exactly_one_owner() -> void:
	print("")
	print("--- 16. The transition rule has one owner, and the transaction stays pure")

	## THE SHARED VALIDATOR, DRIVEN DIRECTLY AND IN BOTH DIRECTIONS. A validator
	## that only ever answered "" would satisfy every caller and protect nothing.
	var legal: int = 0
	for row: Array in [
		[SupportContinuationResult.Kind.NEW_PAIR,
			AcquiredSupports.ABSENT_RANK, AcquiredSupports.FIRST_RANK],
		[SupportContinuationResult.Kind.RANK_INCREASE,
			AcquiredSupports.FIRST_RANK, AcquiredSupports.FIRST_RANK + 1],
		[SupportContinuationResult.Kind.RANK_INCREASE, 976, 977],
	]:
		if RiftOffer.support_transition_problem(int(row[0]), int(row[1]), int(row[2])).is_empty():
			legal += 1
	_expect(legal == 3, "%d of 3 legal transitions were accepted" % legal)

	var refused: int = 0
	for row: Array in [
		[SupportContinuationResult.Kind.NEW_PAIR, AcquiredSupports.FIRST_RANK,
			AcquiredSupports.FIRST_RANK + 1],
		[SupportContinuationResult.Kind.NEW_PAIR, AcquiredSupports.ABSENT_RANK,
			IMPOSSIBLE_RANK],
		[SupportContinuationResult.Kind.RANK_INCREASE, AcquiredSupports.ABSENT_RANK,
			AcquiredSupports.FIRST_RANK],
		[SupportContinuationResult.Kind.RANK_INCREASE, AcquiredSupports.FIRST_RANK,
			IMPOSSIBLE_RANK],
		[UNDECLARED_KIND, AcquiredSupports.ABSENT_RANK, AcquiredSupports.FIRST_RANK],
		[RiftOffer.UNRESOLVED_PROGRESSION_KIND, AcquiredSupports.FIRST_RANK,
			AcquiredSupports.FIRST_RANK + 1],
	]:
		if not RiftOffer.support_transition_problem(
				int(row[0]), int(row[1]), int(row[2])).is_empty():
			refused += 1
	_expect(refused == 6, "%d of 6 illegal transitions were refused" % refused)

	## AND THE OFFER RETURNS THAT ANSWER VERBATIM rather than wrapping it, which is
	## what makes "one definition" true of the text a reader sees as well as of the
	## branch that decides it.
	var tampered: RiftOffer = _offer(null, D3_LANE_SEED)
	tampered.support_rank_after = IMPOSSIBLE_RANK
	_expect(tampered.problem() == RiftOffer.support_transition_problem(
			tampered.support_progression_kind, tampered.support_rank_before,
			tampered.support_rank_after),
		"the offer reports '%s' where the shared validator answers '%s'" % [
			tampered.problem(),
			RiftOffer.support_transition_problem(tampered.support_progression_kind,
				tampered.support_rank_before, tampered.support_rank_after)])

	## BOTH CONSUMERS ASK IT, AND NEITHER RESTATES THE RULE. A second copy of "a
	## new pair goes from absent to first" inside the file that CONSUMES a
	## progression is exactly what the extraction exists to prevent, so its absence
	## is measured rather than assumed — over CODE lines, because both files say in
	## plain English what the accepted record's two named ranks mean.
	##
	## THE TWO CONSUMERS REACH IT BY DIFFERENT ROUTES, AND THAT IS STATED RATHER
	## THAN AVERAGED AWAY. The RESULT calls the validator directly, because it
	## re-checks a progression it has already consumed and holds no offer to ask.
	## The TRANSACTION does not call it at all: it requires `offer.problem()` to be
	## empty before anything is staged, and that is where the offer asks the
	## validator — so a tampered transition is refused by the coherence gate rather
	## than by a second check of the same rule. Asserting "both call it" would have
	## been asserting the wrong thing and would have invited exactly the duplicate
	## the extraction removes.
	var restates: PackedStringArray = PackedStringArray()
	for path: String in [CHOICE_FILE, RESULT_FILE]:
		var raw: String = FileAccess.get_file_as_string(path)
		_expect(raw.length() > 1500,
			"%s read as %d characters, so these scans prove nothing" % [
				path.get_file(), raw.length()])
		var code: String = _code_only(raw)
		for token: String in RANK_CONSTANT_TOKENS:
			if code.contains(token):
				restates.append("%s restates %s" % [path.get_file(), token])
	var asks: int = 1 if FileAccess.get_file_as_string(RESULT_FILE).contains(
		SHARED_VALIDATOR) else 0
	_expect(asks == 1,
		"the choice result does not ask %s" % SHARED_VALIDATOR)
	_expect(not FileAccess.get_file_as_string(CHOICE_FILE).contains(SHARED_VALIDATOR),
		"the transaction asks the validator directly instead of requiring the offer's own coherence")
	_expect(_code_only(FileAccess.get_file_as_string(CHOICE_FILE)).contains("offer.problem()"),
		"the transaction no longer requires the offer's own coherence before staging")
	_expect(restates.is_empty(),
		"the transition rule is written twice: %s" % ", ".join(restates))
	_expect(FileAccess.get_file_as_string(OFFER_FILE).contains(
			"static func support_transition_problem("),
		"the shared validator is not declared where the offer contract owns it")

	## THE TRANSACTION ROUTES TO BOTH ACCEPTED OPERATIONS BY NAME. A transaction
	## that named only one of them would have inferred the other.
	var choice_source: String = FileAccess.get_file_as_string(CHOICE_FILE)
	var routed: PackedStringArray = PackedStringArray()
	for operation: String in REQUIRED_OPERATIONS:
		if not choice_source.contains(operation):
			routed.append(operation)
	_expect(routed.is_empty(),
		"the transaction does not route to %s" % ", ".join(routed))
	_expect(choice_source.contains("SupportContinuationResult.Kind.NEW_PAIR")
			and choice_source.contains("SupportContinuationResult.Kind.RANK_INCREASE"),
		"the transaction does not route on the accepted progression kinds")

	## AND IT MAKES NO CONTINUATION DECISION OF ITS OWN. Reading which operation an
	## offer FROZE is consuming a decision; calling the selector would be taking one.
	var selecting: PackedStringArray = PackedStringArray()
	for path: String in [CHOICE_FILE, RESULT_FILE]:
		if FileAccess.get_file_as_string(path).contains(FORBIDDEN_SELECTOR_CALL):
			selecting.append(path.get_file())
	_expect(selecting.is_empty(),
		"%s calls the accepted continuation selector" % ", ".join(selecting))

	## THE THREE NEW RESULT MEMBERS EXIST BY NAME, so a rename is caught here as
	## well as by the accepted suite's ordered pin.
	var probe: RiftOfferChoiceResult = RiftOfferChoiceResult.refused(
		"zz probe", D3_LANE_SEED, RiftOffer.Lane.SUPPORT)
	var missing: PackedStringArray = PackedStringArray()
	for member: String in [
		"support_progression_kind", "support_rank_before", "support_rank_after",
	]:
		if probe.get(member) == null:
			missing.append(member)
	_expect(missing.is_empty(),
		"the result no longer carries %s" % ", ".join(missing))
	_expect(probe.has_method("carries_support_progression")
			and probe.has_method("support_progression_line")
			and probe.has_method("support_progression_build_problem"),
		"the result no longer answers its own progression inspection")

	## THE OWNERSHIP LINE, ASSERTED STRUCTURALLY AS WELL AS BEHAVIOURALLY (D-258).
	## `problem()` must not read the carried build's rank at all; the audit must.
	## Behaviour proves the two answer differently, and this proves WHERE each of
	## them lives, so a later edit cannot quietly fold the comparison back in.
	var result_source: String = FileAccess.get_file_as_string(RESULT_FILE)
	var problem_body: String = result_source.substr(
		result_source.find("func problem() -> String:"))
	problem_body = problem_body.substr(0, problem_body.find(
		"func support_progression_build_problem() -> String:"))
	_expect(problem_body.length() > 400 and not problem_body.contains("support_rank_for("),
		"problem() reads the carried build's rank again, over %d characters"
			% problem_body.length())
	_expect(result_source.substr(result_source.find(
			"func support_progression_build_problem() -> String:")).contains(
				"new_build.support_rank_for("),
		"the point-in-time audit does not read the carried build's rank")

	## PURITY, UNCHANGED. The two extended files still store nothing, randomise
	## nothing, read no ambient state and compute nothing of their own — a rank
	## RECORDS PROGRESSION here and applies nothing, so a magnitude, a ceiling or a
	## per-rank value would be the first sign of a system nobody authorized.
	var impure: PackedStringArray = PackedStringArray()
	for path: String in [CHOICE_FILE, RESULT_FILE]:
		var raw: String = FileAccess.get_file_as_string(path)
		var code: String = _code_only(raw)
		for token: String in [
			"user://", "ConfigFile", "ResourceSaver", "FileAccess",
			"randi", "randf", "randomize", "RandomNumberGenerator",
			"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
		]:
			if raw.contains(token):
				impure.append("%s reads %s" % [path.get_file(), token])
		for token: String in [
			"rank_cap", "max_rank", "maximum_rank", "diminish", "multiplier",
			"magnitude", "refund", "release(",
		]:
			if code.contains(token):
				impure.append("%s carries %s" % [path.get_file(), token])
		if code.contains("*") or code.contains("/"):
			impure.append("%s computes something of its own" % path.get_file())
	_expect(impure.is_empty(), "the extended files are no longer pure: %s"
		% ", ".join(impure))

	print("  %d legal and %d illegal transitions driven through one shared validator; "
		% [legal, refused]
		+ "the result asks it directly and the transaction through the offer's own "
		+ "coherence, 0 restate it, and both extended files stay pure")
	_done("the_progression_rule_has_exactly_one_owner_and_the_transaction_stays_pure")


# --- Fixtures ------------------------------------------------------------------------
#
# Every positive case is composed from the SHIPPED catalogues, which is what makes
# it a statement about the project rather than about a fixture.

func _offer(acquired: AcquiredSupports, root_seed: int) -> RiftOffer:
	return RiftOfferComposition.compose(
		SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(),
		acquired,
		PassiveCardCatalogue.records(),
		root_seed
	)


## Every compatible shipped pair, each held at `rank`. This is the acquisition
## state that makes the support pool EXHAUSTED, which is the only state from which
## the accepted composition offers a rank increase at all.
func _record_at_rank(rank: int) -> AcquiredSupports:
	var record: AcquiredSupports = AcquiredSupports.new()
	for profile: SkillTagProfile in SkillSupportCatalogue.skill_profiles():
		for definition: SupportDefinition in SkillSupportCatalogue.support_definitions():
			if not definition.allows(profile):
				continue
			record.acquire(profile.skill_id, definition.support_id())
			for _step: int in range(rank - AcquiredSupports.FIRST_RANK):
				record.increase_rank(profile.skill_id, definition.support_id())
	return record


## The same state as a run build, reached THROUGH the accepted run-build
## operations rather than by handing it a record — so the state a choice is
## answered against is a real run rather than a fixture that happens to agree
## with one.
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
				_expect(build.rank_support(
						profile.skill_id, definition.support_id()).is_empty(),
					"the fixture could not raise %s -> %s" % [
						profile.skill_id, definition.support_id()])
	return build


## Every compatible shipped pair held at the rank `ranks` gives its support id —
## any support it does not name at rank 1, and `AcquiredSupports.ABSENT_RANK`
## leaving that pair unheld — reached through the accepted run-build operations
## with one assertion per operation, exactly as `_build_at_rank()` does
## (Foundation I5, D-300: the mixed states a shipped maximum of rank 2 permits).
func _build_holding(ranks: Dictionary) -> RiftRunBuild:
	var build: RiftRunBuild = RiftRunBuild.new()
	for profile: SkillTagProfile in SkillSupportCatalogue.skill_profiles():
		for definition: SupportDefinition in SkillSupportCatalogue.support_definitions():
			if not definition.allows(profile):
				continue
			var rank: int = int(ranks.get(definition.support_id(), AcquiredSupports.FIRST_RANK))
			if rank == AcquiredSupports.ABSENT_RANK:
				continue
			_expect(build.acquire_support(profile.skill_id, definition.support_id()).is_empty(),
				"the fixture could not acquire %s -> %s" % [
					profile.skill_id, definition.support_id()])
			for _step: int in range(rank - AcquiredSupports.FIRST_RANK):
				_expect(build.rank_support(
						profile.skill_id, definition.support_id()).is_empty(),
					"the fixture could not raise %s -> %s" % [
						profile.skill_id, definition.support_id()])
	return build


## The same mixed state as a bare acquisition record, as `_record_at_rank()` builds
## one: nothing asserted, because a record's own operations are F1's to prove.
func _record_holding(ranks: Dictionary) -> AcquiredSupports:
	var record: AcquiredSupports = AcquiredSupports.new()
	for profile: SkillTagProfile in SkillSupportCatalogue.skill_profiles():
		for definition: SupportDefinition in SkillSupportCatalogue.support_definitions():
			if not definition.allows(profile):
				continue
			var rank: int = int(ranks.get(definition.support_id(), AcquiredSupports.FIRST_RANK))
			if rank == AcquiredSupports.ABSENT_RANK:
				continue
			record.acquire(profile.skill_id, definition.support_id())
			for _step: int in range(rank - AcquiredSupports.FIRST_RANK):
				record.increase_rank(profile.skill_id, definition.support_id())
	return record


## A run build holding exactly what `acquired` holds, or an empty one for a null.
func _build_from(acquired: AcquiredSupports) -> RiftRunBuild:
	if acquired == null:
		return RiftRunBuild.new()
	var build: RiftRunBuild = RiftRunBuild.new()
	for pair: String in acquired.pairs():
		var parts: PackedStringArray = pair.split(" -> ")
		var skill_id: StringName = StringName(parts[0])
		var support_id: StringName = StringName(parts[1])
		build.acquire_support(skill_id, support_id)
		for _step: int in range(
				acquired.rank_for(skill_id, support_id) - AcquiredSupports.FIRST_RANK):
			build.rank_support(skill_id, support_id)
	return build


## One held pair the offer does NOT name, so "it did not move" is a claim about a
## specific thing rather than about an aggregate that could hide it.
func _other_pair(build: RiftRunBuild, offer: RiftOffer) -> Array:
	var offered: String = "%s -> %s" % [offer.skill_id, offer.support_id]
	for pair: String in build.support_pairs():
		if pair == offered:
			continue
		var parts: PackedStringArray = pair.split(" -> ")
		return [StringName(parts[0]), StringName(parts[1])]
	_expect(false, "the fixture holds no pair other than %s" % offered)
	return [&"", &""]


## One real, successful support choice — a new pair or a rank increase — produced
## through the accepted transaction rather than through the constructor, so a
## coherence check is made against something the project can actually build.
func _support_success(ranked: bool) -> RiftOfferChoiceResult:
	var acquired: AcquiredSupports = _record_at_rank(AcquiredSupports.FIRST_RANK) \
		if ranked else null
	var result: RiftOfferChoiceResult = RiftOfferChoice.choose(
		_offer(acquired, EXAMPLE_SEED if ranked else D3_LANE_SEED),
		RiftOffer.Lane.SUPPORT, _build_from(acquired), RiftConsumptionLedger.new())
	_expect(result.ok, "the %s fixture was refused: %s" % [
		"rank" if ranked else "new-pair", result.failure_reason])
	return result


# --- Assertions ------------------------------------------------------------------------

## One successful result, checked as a whole rather than only on `ok`.
func _expect_success(result: RiftOfferChoiceResult, described: String) -> void:
	_successes += 1
	_expect(result != null and result.ok, "%s was refused: %s" % [
		described, "no result at all" if result == null else result.failure_reason])
	if result == null or not result.ok:
		return
	_expect(result.problem().is_empty(),
		"%s produced an incoherent result: %s" % [described, result.problem()])
	## A FRESHLY RETURNED RESULT SATISFIES BOTH QUERIES (D-258): the permanent
	## coherence contract AND the point-in-time audit, because at the instant a
	## transaction completes the carried build really does hold exactly the rank the
	## choice reached. The two only diverge later, and check 9 drives that.
	_expect(result.support_progression_build_problem().is_empty(),
		"%s produced a build the choice does not match: %s" % [
			described, result.support_progression_build_problem()])
	_expect(result.new_build != null and result.new_ledger != null,
		"%s succeeded without both new values" % described)
	_expect(not result.chosen_identity().is_empty(),
		"%s succeeded and granted nothing" % described)


## One refusal, counted, and checked for the properties EVERY refusal owes: a
## stated reason, a coherent shape, and no updated state, granted identity or
## progression result.
func _expect_refused(result: RiftOfferChoiceResult, described: String) -> void:
	_refusals += 1
	_expect(result != null and not result.ok, "%s was accepted" % described)
	if result == null or result.ok:
		return
	_expect(not result.failure_reason.strip_edges().is_empty(),
		"%s was refused without a reason" % described)
	_expect(result.problem().is_empty(),
		"the refusal of %s is itself incoherent: %s" % [described, result.problem()])
	_expect(result.new_build == null and result.new_ledger == null,
		"the refusal of %s carries an updated build or ledger" % described)
	_expect(result.chosen_identity().is_empty(),
		"the refusal of %s granted %s" % [described, " -> ".join(result.chosen_identity())])
	_expect(not result.carries_support_progression()
			and result.support_progression_kind == RiftOffer.UNRESOLVED_PROGRESSION_KIND
			and result.support_rank_before == RiftOfferChoiceResult.NO_RANK
			and result.support_rank_after == RiftOfferChoiceResult.NO_RANK,
		"the refusal of %s exposed %s" % [described, result.support_progression_line()])
	## AND NO BUILD COMPARISON APPLIES TO IT (D-258). A refusal carries no build
	## and no progression, so the point-in-time audit has nothing to compare and
	## must say so rather than inventing a mismatch out of two absent values.
	_expect(result.support_progression_build_problem().is_empty(),
		"the refusal of %s reports the build problem '%s'" % [
			described, result.support_progression_build_problem()])


## A refusal that also left BOTH supplied values exactly as they were. The
## snapshots are complete on purpose: a refusal that raised a rank without
## spending a seed, or spent a seed without raising anything, is caught by the
## same comparison that catches a refusal which did both.
func _expect_atomic_refusal(
	result: RiftOfferChoiceResult, build: RiftRunBuild,
	ledger: RiftConsumptionLedger, described: String
) -> RiftOfferChoiceResult:
	var before_build: String = _snapshot(build)
	var before_ledger: String = _ledger_snapshot(ledger)
	_expect_refused(result, described)
	_expect(_snapshot(build) == before_build,
		"the refusal of %s changed the build:\n    before %s\n    after  %s" % [
			described, before_build, _snapshot(build)])
	_expect(_ledger_snapshot(ledger) == before_ledger,
		"the refusal of %s changed the ledger: %s -> %s" % [
			described, before_ledger, _ledger_snapshot(ledger)])
	return result


# --- Formatting ------------------------------------------------------------------------

## The COMPLETE run build as one line, to seventeen significant digits.
##
## EVERY PAIR'S RANK IS IN IT EXPLICITLY, AND THAT IS THE ONE THING THIS SUITE
## COULD MOST EASILY HAVE GOT WRONG. `support_pairs()` and `support_count()` are
## rank-free by the accepted D-252 ruling, so an atomicity comparison built out of
## the accepted Foundation D3 snapshot alone would report a run whose rank had
## silently moved as unchanged — which is exactly the mutation this foundation
## introduces.
func _snapshot(build: RiftRunBuild) -> String:
	if build == null:
		return "no build"
	var parts: PackedStringArray = PackedStringArray()
	var ranked: PackedStringArray = PackedStringArray()
	for pair: String in build.support_pairs():
		var ids: PackedStringArray = pair.split(" -> ")
		ranked.append("%s@%d" % [pair,
			build.support_rank_for(StringName(ids[0]), StringName(ids[1]))])
	parts.append("pairs[%s]" % ", ".join(ranked))
	parts.append("pair_count=%d" % build.support_count())
	parts.append("total_ranks=%d" % build.total_support_ranks())
	var cards: PackedStringArray = PackedStringArray()
	for card_id: StringName in build.acquired_card_ids():
		cards.append("%s x%d {%s}" % [
			card_id, build.acquisitions_for(card_id),
			build.mechanical_identity_for(card_id)])
	parts.append("cards[%s]" % ", ".join(cards))
	parts.append("acquisitions=%d" % build.passive_acquisitions())
	for stat_id: StringName in PlayerStats.ALL:
		parts.append("%s=%s(%d)" % [
			stat_id, _exact(build.total_for(stat_id)),
			build.contribution_count_for(stat_id)])
	parts.append("empty=%s" % build.is_empty())
	return " | ".join(parts)


func _ledger_snapshot(ledger: RiftConsumptionLedger) -> String:
	if ledger == null:
		return "no ledger"
	var seeds: PackedStringArray = PackedStringArray()
	for root_seed: int in ledger.consumed_seeds():
		seeds.append(str(root_seed))
	return "count=%d seeds=[%s] empty=%s" % [
		ledger.count(), ", ".join(seeds), ledger.is_empty()]


## The WHOLE composed offer as one comparable string, progression included.
func _full(offer: RiftOffer) -> String:
	if not offer.ok:
		return "REFUSED lane=%d seed=%d reason='%s'" % [
			offer.refusing_lane, offer.root_seed, offer.failure_reason]
	return "root=%d seeds=[%s] %s [%s] | %s | %s" % [
		offer.root_seed, offer.seed_line(), offer.offer_line(),
		offer.support_progression_line(),
		offer.combat_derivation.describe(), offer.utility_derivation.describe()]


func _nonzero_stats(build: RiftRunBuild) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for stat_id: StringName in PlayerStats.ALL:
		if build.total_for(stat_id) != 0.0:
			parts.append("%s=%s" % [stat_id, _exact(build.total_for(stat_id))])
	return ", ".join(parts)


func _exact(value: float) -> String:
	return String.num(value, 17)


## Comment lines removed. Both extended files say in plain English what they
## refuse to do, and a scan that cannot tell the promise from the breach is
## worthless — Gate 1C's lesson, kept.
func _code_only(source: String) -> String:
	var out: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


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
	print("  %d successes and %d refusals were driven across this suite" % [
		_successes, _refusals])


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
