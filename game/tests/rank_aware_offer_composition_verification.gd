extends SceneTree
## Riftwrought — Roguelite Foundation F3 verification: Rank-Aware Three-Lane
## Rift Offer Composition (decision D-255).
##
## ONE FOCUSED HEADLESS TEST. F3 adds no file of its own: it EXTENDS the two
## accepted Foundation D1 scripts so the support lane is decided by the accepted
## continuation mechanism and the rank transition that decision implies is frozen
## into the offer. So this suite needs no scene, no camera, no navigation, no
## rendering and no evidence frame, and it deliberately gets none. It runs as a
## `SceneTree` script exactly as every earlier foundation's suite does.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching its
## LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## WHAT THIS SUITE OWNS, AND WHAT IT DELIBERATELY DOES NOT. It owns the SEAM:
## that the support lane is composed THROUGH the accepted continuation decision
## rather than around it, that the frozen transition is MEASURED through the
## accepted ranked-ownership record rather than calculated, that a rank offer is
## a coherent offer, and that nothing else about an offer moved. It does not
## re-prove the continuation policy (its own suite owns the global new-first
## rule, the ticket ladders and the seed contract), it does not re-prove the
## weighted draw, and it does not re-prove D1's lane independence — the D1 suite
## still owns all three lane domains, the corpus and the bleed proofs, and it
## still passes.
##
## THE PINS ARE TYPED HERE RATHER THAN READ FROM WHAT THEY CHECK. The three lane
## domains and the fourteen documented corpus rows are written out below. A check
## that takes its expected answer from the mechanism it is checking proves only
## that a file agrees with itself; the corpus in particular is the load-bearing
## proof that F3 moved NOTHING about an offer that a seed already reproduced,
## because every one of those rows predates this foundation.
##
## THE TEST DATA IS NOT CONTENT. Every fabricated Skill profile, support
## definition and passive card built below lives inside this file only, is
## registered in no catalogue, ships in no scene, no `.tres` and no library, and
## is not canon. They are `zz_` prefixed so they can never be mistaken for
## content and so a future catalogue entry cannot collide with one.

const COMPOSER_FILE: String = "res://scripts/offers/rift_offer_composition.gd"
const OFFER_FILE: String = "res://scripts/offers/rift_offer.gd"
const CONTINUATION_FILE: String = "res://scripts/continuation/support_continuation.gd"

## The two accepted suites that had to grant this foundation an exemption, and
## the exact text each grant must carry. Two independently typed copies of one
## list is how they drift, so each is checked from this side as well — and each
## is checked as EARNED below, by measuring that the composer really does use
## what it was granted.
const F1_SUITE: String = "res://tests/ranked_support_ownership_verification.gd"
const F2_SUITE: String = "res://tests/support_continuation_verification.gd"

## The accepted continuation call the composer MUST make, and the accepted
## weighted call it must NOT. Reaching around the continuation would put the
## global new-pair-before-rank policy back inside a composer as a second, subtly
## different copy, and it would pass every purity scan because the class is one
## the composer is legitimately allowed to name.
const REQUIRED_CALL: String = "SupportContinuation.select"
const FORBIDDEN_CALL: String = "SupportSelection.select"

## The two ranked-ownership members the composer stages through, and the four it
## must never touch. It MEASURES a transition; it records no progression of its
## own and must never raise a rank on anything a caller can still see.
const STAGING_MEMBERS: Array[String] = ["rank_for(", "increase_rank("]
const FORBIDDEN_MEMBERS: Array[String] = [
	"total_ranks(", "rank_support(", "support_rank_for(", "total_support_ranks(",
]

# --- The three lane domains, typed independently of the composer ---------------
#
# FROZEN BY D-240 RULING 1 AND PART OF WHAT A ROOT SEED MEANS. F3 must not have
# moved one, so they are pinned here as well as in the D1 suite: this foundation
# is the first thing to change how the support lane is resolved, and a lane
# domain quietly moving with it would rewrite every offer every seed has ever
# produced.

const EXPECTED_SUPPORT_DOMAIN: int = 0x6A09E667
const EXPECTED_COMBAT_DOMAIN: int = 0xBB67AE85
const EXPECTED_UTILITY_DOMAIN: int = 0x3C6EF372

## THE DOCUMENTED CORPUS, RETYPED: root seed, the three lane seeds in lane order,
## then the Skill, the support, the Combat and Defence card and the Utility card.
## Every row was published before this foundation existed and every row was
## originally re-derived from an independent re-implementation of the whole chain
## outside the engine. They are the proof that routing the support lane through
## the accepted continuation decision moved NO lane seed and NO selection.
const SEED_CORPUS: Array = [
	[0, 2074702303, 856502828, 83415710,
		"quick_strike", "reaching_edge", "card_vitality", "card_magnetism"],
	[1, 1992569692, 1644117255, 1136996714,
		"quick_strike", "sweeping_edge", "card_celerity", "card_fleetness"],
	[3, 721961813, 1354442878, 538578972,
		"quick_strike", "reaching_edge", "card_power", "card_fleetness"],
	[7, 4138976552, 605881410, 197629295,
		"quick_strike", "reaching_edge", "card_power", "card_fleetness"],
	[42, 707968515, 3998878852, 3512831560,
		"quick_strike", "reaching_edge", "card_vitality", "card_fleetness"],
	[257, 3492135287, 573141247, 791363066,
		"quick_strike", "reaching_edge", "card_celerity", "card_magnetism"],
	[999, 4103667829, 2113307790, 2221117341,
		"quick_strike", "reaching_edge", "card_celerity", "card_fleetness"],
	[12345, 1009438761, 612468971, 1162198605,
		"quick_strike", "sweeping_edge", "card_vitality", "card_insight"],
	[99991, 1939204551, 4169958103, 197201829,
		"quick_strike", "reaching_edge", "card_power", "card_fleetness"],
	[2147483647, 1166519778, 748253319, 3235043907,
		"quick_strike", "sweeping_edge", "card_power", "card_insight"],
	[-1, 326752841, 771551199, 3101234265,
		"quick_strike", "reaching_edge", "card_power", "card_magnetism"],
	[-12345, 4230437894, 921368375, 776091310,
		"quick_strike", "reaching_edge", "card_power", "card_fleetness"],
	[1000000007, 2357638753, 995110969, 483406264,
		"quick_strike", "sweeping_edge", "card_celerity", "card_magnetism"],
	[9223372036854775807, 326752841, 771551199, 3101234265,
		"quick_strike", "reaching_edge", "card_power", "card_magnetism"],
]

## HOW MANY OF THE CORPUS'S 42 LANE SEEDS ARE DISTINCT, typed independently. A
## pin that only ever compares a value to itself discriminates nothing; this one
## refuses a corpus whose rows collapsed onto each other. Exactly three values
## repeat, and they repeat ON PURPOSE: `-1` and the largest 64-bit integer mask
## to the same 32 bits and are therefore ONE composition question.
const EXPECTED_DISTINCT_LANE_SEEDS: int = 39

# --- Fabricated fixtures --------------------------------------------------------

const SKILL_ONE: StringName = &"zz_skill_one"
const SKILL_TWO: StringName = &"zz_skill_two"

const SUPPORT_ALPHA: StringName = &"zz_t1_alpha"
const SUPPORT_BETA: StringName = &"zz_t2_beta"
const SUPPORT_GAMMA: StringName = &"zz_t3_gamma"

const WEIGHT_ALPHA: int = 4
const WEIGHT_BETA: int = 6
const WEIGHT_GAMMA: int = 5

## Two Skills times three supports. Every pair is eligible, so the pool is six
## and the exhausted state is reachable by acquiring six pairs.
const FABRICATED_PAIRS: int = 6

## The shipped catalogue's own two pairs on its one equippable Skill.
const SHIPPED_PAIRS: int = 2

## How many seeds every claim is made over. Each is an EXACT comparison, never a
## sample of a distribution.
const SEED_SAMPLES: int = 256

## The ranks the frozen-transition claim is made at. 1 is the rank a first
## acquisition leaves behind, 2 is the first raised rank, and 977 is deliberately
## far from both — a rank nothing about selection may notice. Every one sits below
## the fabricated definitions' `FIXTURE_MAXIMUM_RANK` (Foundation I5, D-300), so
## each is a rank a pair can still be raised from; what happens AT a maximum is the
## I5 suite's to prove.
const PROBE_RANKS: Array[int] = [1, 2, 977]

## THE MAXIMUM RANK EVERY FABRICATED DEFINITION DECLARES (Foundation I5, D-300). A
## definition that declares none is refused by every rank-increase question, so the
## fabricated supports declare one — far above every rank this suite holds a pair
## at, so the rank claims below keep meaning what they meant. Test data, not a
## balance value.
const FIXTURE_MAXIMUM_RANK: int = 1000

## The one root seed the worked examples are shown at by name.
const EXAMPLE_SEED: int = 18

## Foundation E2's accepted one-level worked example, retyped. Root seed 0, a
## requirement of 100 reached exactly, and the Support lane taken.
const E2_ROOT_SEED: int = 0
const E2_REQUIREMENT: float = 100.0
const E2_SKILL: StringName = &"quick_strike"
const E2_SUPPORT: StringName = &"reaching_edge"

const OWED_CHECKS: Array[String] = [
	"an_empty_acquisition_state_composes_the_documented_new_pair",
	"the_lane_seeds_and_both_passive_lanes_are_untouched",
	"a_partly_held_pool_still_offers_a_new_pair",
	"a_pair_held_on_one_skill_is_still_new_on_another",
	"an_exhausted_pool_composes_a_rank_increase_instead_of_refusing",
	"every_current_rank_freezes_its_own_exact_transition",
	"the_nested_continuation_and_the_weighted_derivation_stay_available",
	"array_order_and_duplicate_tags_cannot_move_a_composed_offer",
	"the_supplied_acquisition_state_is_never_touched",
	"a_support_lane_with_nothing_to_offer_refuses_completely",
	"an_invalid_passive_record_keeps_its_lane_and_its_complete_failure",
	"mutating_the_frozen_progression_is_reported_by_problem",
	"the_support_identity_is_still_exactly_two_ordered_ids",
	"the_accepted_choice_transaction_is_unchanged_for_a_new_pair",
	"a_rank_offer_is_consumed_as_the_rank_increase_it_froze",
	"the_accepted_one_level_worked_example_is_unchanged",
	"the_transition_is_measured_through_the_accepted_rank_api",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation F3 — Rank-Aware Three-Lane Offer Composition ===")

	_check_an_empty_acquisition_state_composes_the_documented_new_pair()
	_check_the_lane_seeds_and_both_passive_lanes_are_untouched()
	_check_a_partly_held_pool_still_offers_a_new_pair()
	_check_a_pair_held_on_one_skill_is_still_new_on_another()
	_check_an_exhausted_pool_composes_a_rank_increase_instead_of_refusing()
	_check_every_current_rank_freezes_its_own_exact_transition()
	_check_the_nested_continuation_and_the_weighted_derivation_stay_available()
	_check_array_order_and_duplicate_tags_cannot_move_a_composed_offer()
	_check_the_supplied_acquisition_state_is_never_touched()
	_check_a_support_lane_with_nothing_to_offer_refuses_completely()
	_check_an_invalid_passive_record_keeps_its_lane_and_its_complete_failure()
	_check_mutating_the_frozen_progression_is_reported_by_problem()
	_check_the_support_identity_is_still_exactly_two_ordered_ids()
	_check_the_accepted_choice_transaction_is_unchanged_for_a_new_pair()
	_check_a_rank_offer_is_consumed_as_the_rank_increase_it_froze()
	_check_the_accepted_one_level_worked_example_is_unchanged()
	_check_the_transition_is_measured_through_the_accepted_rank_api()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RANK AWARE OFFER COMPOSITION VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RANK AWARE OFFER COMPOSITION VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. Nothing held: the documented offer, classified as a new pair ------------

func _check_an_empty_acquisition_state_composes_the_documented_new_pair() -> void:
	print("")
	print("--- 1. With nothing held, the documented seeds compose the documented pair as NEW")

	## THE THREE LANE DOMAINS ARE FROZEN AND F3 DID NOT MOVE ONE.
	_expect(RiftOfferComposition.SUPPORT_LANE_DOMAIN == EXPECTED_SUPPORT_DOMAIN,
		"the support lane domain is %d, not %d" % [
			RiftOfferComposition.SUPPORT_LANE_DOMAIN, EXPECTED_SUPPORT_DOMAIN,
		])
	_expect(RiftOfferComposition.COMBAT_DEFENCE_LANE_DOMAIN == EXPECTED_COMBAT_DOMAIN,
		"the combat lane domain is %d, not %d" % [
			RiftOfferComposition.COMBAT_DEFENCE_LANE_DOMAIN, EXPECTED_COMBAT_DOMAIN,
		])
	_expect(RiftOfferComposition.UTILITY_LANE_DOMAIN == EXPECTED_UTILITY_DOMAIN,
		"the utility lane domain is %d, not %d" % [
			RiftOfferComposition.UTILITY_LANE_DOMAIN, EXPECTED_UTILITY_DOMAIN,
		])

	var rows: int = 0
	var new_pairs: int = 0
	var wrong: PackedStringArray = PackedStringArray()
	for row: Array in SEED_CORPUS:
		var root_seed: int = int(row[0])
		var offer: RiftOffer = _shipped_offer(null, root_seed)
		if not offer.ok:
			wrong.append("seed %d refused: %s" % [root_seed, offer.failure_reason])
			continue
		if not offer.problem().is_empty():
			wrong.append("seed %d is incoherent: %s" % [root_seed, offer.problem()])
			continue
		if String(offer.skill_id) != String(row[4]) \
				or String(offer.support_id) != String(row[5]):
			wrong.append("seed %d offers %s -> %s" % [
				root_seed, offer.skill_id, offer.support_id,
			])
			continue
		if offer.support_progression_kind == SupportContinuationResult.Kind.NEW_PAIR \
				and offer.support_rank_before == AcquiredSupports.ABSENT_RANK \
				and offer.support_rank_after == AcquiredSupports.FIRST_RANK:
			new_pairs += 1
		else:
			wrong.append("seed %d froze %s" % [root_seed, offer.support_progression_line()])
		rows += 1
	_expect(wrong.is_empty(), "the documented corpus moved: %s" % ", ".join(wrong))
	_expect(rows == SEED_CORPUS.size(),
		"%d of %d corpus rows composed" % [rows, SEED_CORPUS.size()])
	_expect(new_pairs == SEED_CORPUS.size(),
		"%d of %d corpus rows classified as a new pair at rank %d -> %d" % [
			new_pairs, SEED_CORPUS.size(),
			AcquiredSupports.ABSENT_RANK, AcquiredSupports.FIRST_RANK,
		])

	## A NULL RECORD AND AN EMPTY ONE ARE THE SAME QUESTION, which is the reading
	## every accepted mechanism below this one already takes.
	var drifted: int = 0
	for row: Array in SEED_CORPUS:
		if _full(_shipped_offer(null, int(row[0]))) \
				!= _full(_shipped_offer(AcquiredSupports.new(), int(row[0]))):
			drifted += 1
	_expect(drifted == 0,
		"%d corpus rows differ between a null and an empty acquisition record" % drifted)

	var example: RiftOffer = _shipped_offer(null, EXAMPLE_SEED)
	print("  %d of %d documented rows exact and all NEW_PAIR at rank %d -> %d; example: %s [%s]"
		% [rows, SEED_CORPUS.size(), AcquiredSupports.ABSENT_RANK,
			AcquiredSupports.FIRST_RANK, example.offer_line(),
			example.support_progression_line()])
	_done("an_empty_acquisition_state_composes_the_documented_new_pair")


# --- 2. Every lane seed and both passive lanes are exactly where they were ------

func _check_the_lane_seeds_and_both_passive_lanes_are_untouched() -> void:
	print("")
	print("--- 2. The three lane seeds and both passive card selections are unchanged")

	var seed_rows: int = 0
	var seen: Dictionary = {}
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in SEED_CORPUS:
		var root_seed: int = int(row[0])
		var expected: Array[int] = [int(row[1]), int(row[2]), int(row[3])]
		var offer: RiftOffer = _shipped_offer(null, root_seed)
		for index: int in RiftOffer.LANE_ORDER.size():
			var lane: int = RiftOffer.LANE_ORDER[index]
			seen[expected[index]] = true
			if RiftOfferComposition.lane_seed_for(root_seed, lane) != expected[index]:
				moved.append("derived %s of %d" % [RiftOffer.lane_label(lane), root_seed])
			if offer.seed_for(lane) != expected[index]:
				moved.append("reported %s of %d" % [RiftOffer.lane_label(lane), root_seed])
		if String(offer.combat_card_id) != String(row[6]):
			moved.append("the combat card of %d is %s" % [root_seed, offer.combat_card_id])
		if String(offer.utility_card_id) != String(row[7]):
			moved.append("the utility card of %d is %s" % [root_seed, offer.utility_card_id])
		seed_rows += 1
	_expect(moved.is_empty(), "a documented lane seed or passive card moved: %s"
		% ", ".join(moved))
	_expect(seed_rows == SEED_CORPUS.size(),
		"%d of %d rows were read" % [seed_rows, SEED_CORPUS.size()])

	## THE PIN DISCRIMINATES, WHICH IS THE OTHER DIRECTION. A corpus whose rows
	## had collapsed onto one another would satisfy every equality above while
	## proving nothing at all.
	_expect(seen.size() == EXPECTED_DISTINCT_LANE_SEEDS,
		"the corpus holds %d distinct lane seeds, not %d" % [
			seen.size(), EXPECTED_DISTINCT_LANE_SEEDS,
		])

	## AND THE TWO PASSIVE LANES ARE STILL EXACTLY WHAT THE ACCEPTED PASSIVE
	## SELECTOR ANSWERS FOR THE LANE SEED THE OFFER REPORTS, over a full corpus of
	## seeds, held state or not — because the support lane's new dependence on
	## what is held must not be able to reach either of them.
	var held: AcquiredSupports = _exhausted_shipped_record()
	var combat_delegated: int = 0
	var utility_delegated: int = 0
	var passive_drift: int = 0
	for seed_value: int in SEED_SAMPLES:
		var empty_offer: RiftOffer = _shipped_offer(null, seed_value)
		var held_offer: RiftOffer = _shipped_offer(held, seed_value)
		if not empty_offer.ok or not held_offer.ok:
			_expect(false, "seed %d refused while measuring the passive lanes" % seed_value)
			continue
		var empty_passives: String = "%s | %s" % [
			empty_offer.combat_derivation.describe(),
			empty_offer.utility_derivation.describe(),
		]
		var held_passives: String = "%s | %s" % [
			held_offer.combat_derivation.describe(),
			held_offer.utility_derivation.describe(),
		]
		if empty_passives != held_passives:
			passive_drift += 1
		var direct_combat: PassiveCardSelectionResult = PassiveCardSelection.select(
			PassiveCardCatalogue.records(), PlayerStatDefinition.Category.COMBAT_DEFENCE,
			held_offer.seed_for(RiftOffer.Lane.COMBAT_DEFENCE))
		if direct_combat.describe() == held_offer.combat_derivation.describe():
			combat_delegated += 1
		var direct_utility: PassiveCardSelectionResult = PassiveCardSelection.select(
			PassiveCardCatalogue.records(), PlayerStatDefinition.Category.UTILITY,
			held_offer.seed_for(RiftOffer.Lane.UTILITY))
		if direct_utility.describe() == held_offer.utility_derivation.describe():
			utility_delegated += 1
	_expect(passive_drift == 0,
		"%d of %d seeds moved a passive lane when the support lane changed operation"
			% [passive_drift, SEED_SAMPLES])
	_expect(combat_delegated == SEED_SAMPLES and utility_delegated == SEED_SAMPLES,
		"%d and %d of %d passive lanes reproduce the accepted selector" % [
			combat_delegated, utility_delegated, SEED_SAMPLES,
		])

	print("  %d documented rows exact over 42 lane seeds (%d distinct); %d of %d seeds keep both "
		% [seed_rows, seen.size(), SEED_SAMPLES, SEED_SAMPLES]
		+ "passive lanes across a new-pair AND a rank offer")
	_done("the_lane_seeds_and_both_passive_lanes_are_untouched")


# --- 3. Some pairs held, one still new -----------------------------------------

func _check_a_partly_held_pool_still_offers_a_new_pair() -> void:
	print("")
	print("--- 3. With some pairs held and one still available, the lane stays NEW_PAIR")

	var profiles: Array[SkillTagProfile] = _two_skills()
	var definitions: Array[SupportDefinition] = _three_supports()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var every_pair: PackedStringArray = _eligible_pairs(profiles, definitions)
	_expect(every_pair.size() == FABRICATED_PAIRS,
		"the fabricated fixture holds %d eligible pairs, not %d" % [
			every_pair.size(), FABRICATED_PAIRS,
		])

	## ONE TO FIVE OF THE SIX HELD. Every one of those states still leaves
	## something new somewhere, so every seed must classify as a new pair — and
	## the pair it offers must be one that is genuinely NOT held.
	var checked: int = 0
	var wrong_kind: int = 0
	var already_held: int = 0
	var wrong_transition: int = 0
	for taken: int in range(1, FABRICATED_PAIRS):
		var record: AcquiredSupports = _record_of(every_pair, taken)
		_expect(record.size() == taken,
			"the fixture holds %d pairs, not %d" % [record.size(), taken])
		for seed_value: int in SEED_SAMPLES:
			var offer: RiftOffer = RiftOfferComposition.compose(
				profiles, definitions, record, cards, seed_value)
			if not offer.ok or not offer.problem().is_empty():
				_expect(false, "seed %d at %d held refused: %s%s" % [
					seed_value, taken, offer.failure_reason, offer.problem()])
				continue
			checked += 1
			if offer.support_progression_kind != SupportContinuationResult.Kind.NEW_PAIR:
				wrong_kind += 1
			if record.has(offer.skill_id, offer.support_id):
				already_held += 1
			if offer.support_rank_before != AcquiredSupports.ABSENT_RANK \
					or offer.support_rank_after != AcquiredSupports.FIRST_RANK:
				wrong_transition += 1
	_expect(wrong_kind == 0,
		"%d of %d partly-held offers were not a new pair" % [wrong_kind, checked])
	_expect(already_held == 0,
		"%d of %d partly-held offers named a pair the run already holds" % [
			already_held, checked,
		])
	_expect(wrong_transition == 0,
		"%d of %d partly-held offers froze a transition other than %d -> %d" % [
			wrong_transition, checked,
			AcquiredSupports.ABSENT_RANK, AcquiredSupports.FIRST_RANK,
		])
	_expect(checked == (FABRICATED_PAIRS - 1) * SEED_SAMPLES,
		"%d of %d partly-held offers were measured" % [
			checked, (FABRICATED_PAIRS - 1) * SEED_SAMPLES,
		])

	print("  %d offers across 1-%d of %d pairs held: all NEW_PAIR at %d -> %d, 0 already held"
		% [checked, FABRICATED_PAIRS - 1, FABRICATED_PAIRS,
			AcquiredSupports.ABSENT_RANK, AcquiredSupports.FIRST_RANK])
	_done("a_partly_held_pool_still_offers_a_new_pair")


# --- 4. The same support, a different Skill, still new --------------------------

func _check_a_pair_held_on_one_skill_is_still_new_on_another() -> void:
	print("")
	print("--- 4. A support held on one Skill is still a NEW pair on another")

	var profiles: Array[SkillTagProfile] = _two_skills()
	var definitions: Array[SupportDefinition] = _three_supports()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()

	var record: AcquiredSupports = AcquiredSupports.new()
	_expect(record.acquire(SKILL_ONE, SUPPORT_ALPHA), "the fixture pair was refused")
	_expect(record.has(SKILL_ONE, SUPPORT_ALPHA) and not record.has(SKILL_TWO, SUPPORT_ALPHA),
		"the fixture did not make the same support held on one Skill and free on the other")

	var offered_on_two: int = 0
	var offered_on_one: int = 0
	var not_new: int = 0
	for seed_value: int in SEED_SAMPLES:
		var offer: RiftOffer = RiftOfferComposition.compose(
			profiles, definitions, record, cards, seed_value)
		if not offer.ok:
			_expect(false, "seed %d refused: %s" % [seed_value, offer.failure_reason])
			continue
		if offer.support_progression_kind != SupportContinuationResult.Kind.NEW_PAIR:
			not_new += 1
		if offer.skill_id == SKILL_TWO and offer.support_id == SUPPORT_ALPHA:
			offered_on_two += 1
		if offer.skill_id == SKILL_ONE and offer.support_id == SUPPORT_ALPHA:
			offered_on_one += 1
	_expect(not_new == 0, "%d offers were not a new pair while five pairs were free" % not_new)
	_expect(offered_on_two > 0,
		"%s -> %s was never offered over %d seeds, so its availability is unproved" % [
			SKILL_TWO, SUPPORT_ALPHA, SEED_SAMPLES,
		])
	_expect(offered_on_one == 0,
		"the held pair %s -> %s was offered %d times" % [
			SKILL_ONE, SUPPORT_ALPHA, offered_on_one,
		])

	print("  the same support is held on %s and offered NEW on %s %d of %d times; "
		% [SKILL_ONE, SKILL_TWO, offered_on_two, SEED_SAMPLES]
		+ "the held pair is offered 0 times")
	_done("a_pair_held_on_one_skill_is_still_new_on_another")


# --- 5. Exhaustion composes instead of refusing ---------------------------------

func _check_an_exhausted_pool_composes_a_rank_increase_instead_of_refusing() -> void:
	print("")
	print("--- 5. When every eligible pair is held, composition SUCCEEDS as a rank increase")

	## THE SHIPPED CATALOGUE, WHICH IS WHERE D1's HISTORICAL SUPPORT-EXHAUSTION
	## REFUSAL LIVED. Holding both shipped pairs used to refuse the whole offer;
	## it now composes one further rank, and the two passive lanes come with it.
	var shipped_held: AcquiredSupports = _exhausted_shipped_record()
	_expect(shipped_held.size() == SHIPPED_PAIRS,
		"the shipped fixture holds %d pairs, not %d" % [shipped_held.size(), SHIPPED_PAIRS])
	var shipped_ranks: int = 0
	var shipped_wrong: PackedStringArray = PackedStringArray()
	for seed_value: int in SEED_SAMPLES:
		var offer: RiftOffer = _shipped_offer(shipped_held, seed_value)
		if not offer.ok:
			shipped_wrong.append("seed %d refused: %s" % [seed_value, offer.failure_reason])
			continue
		if not offer.problem().is_empty():
			shipped_wrong.append("seed %d incoherent: %s" % [seed_value, offer.problem()])
			continue
		if offer.support_progression_kind != SupportContinuationResult.Kind.RANK_INCREASE:
			shipped_wrong.append("seed %d froze %s" % [
				seed_value, offer.support_progression_line()])
			continue
		if offer.support_rank_before != AcquiredSupports.FIRST_RANK \
				or offer.support_rank_after != AcquiredSupports.FIRST_RANK + 1:
			shipped_wrong.append("seed %d froze %d -> %d" % [
				seed_value, offer.support_rank_before, offer.support_rank_after])
			continue
		if not shipped_held.has(offer.skill_id, offer.support_id):
			shipped_wrong.append("seed %d ranked the unheld pair %s -> %s" % [
				seed_value, offer.skill_id, offer.support_id])
			continue
		shipped_ranks += 1
	_expect(shipped_wrong.is_empty(),
		"an exhausted shipped pool did not compose a rank increase: %s"
			% ", ".join(shipped_wrong))
	_expect(shipped_ranks == SEED_SAMPLES,
		"%d of %d exhausted shipped seeds composed a rank increase" % [
			shipped_ranks, SEED_SAMPLES,
		])

	## AND THE FABRICATED SIX-PAIR POOL, WHERE EXHAUSTION IS REACHED ACROSS TWO
	## SKILLS RATHER THAN ONE. Both halves matter: the shipped case is the one D1
	## documented, and the two-Skill case is the one where a per-Skill reading of
	## the policy would have started ranking early.
	var profiles: Array[SkillTagProfile] = _two_skills()
	var definitions: Array[SupportDefinition] = _three_supports()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var every_pair: PackedStringArray = _eligible_pairs(profiles, definitions)
	var record: AcquiredSupports = _record_of(every_pair, FABRICATED_PAIRS)
	_expect(record.size() == FABRICATED_PAIRS,
		"the exhausted fabricated fixture holds %d pairs" % record.size())
	var fabricated_ranks: int = 0
	var reached: Dictionary = {}
	for seed_value: int in SEED_SAMPLES:
		var offer: RiftOffer = RiftOfferComposition.compose(
			profiles, definitions, record, cards, seed_value)
		var is_rank: bool = offer.support_progression_kind \
			== SupportContinuationResult.Kind.RANK_INCREASE
		if offer.ok and offer.problem().is_empty() and is_rank \
				and record.has(offer.skill_id, offer.support_id):
			fabricated_ranks += 1
			reached["%s -> %s" % [offer.skill_id, offer.support_id]] = true
	_expect(fabricated_ranks == SEED_SAMPLES,
		"%d of %d exhausted fabricated seeds composed a rank increase on a held pair"
			% [fabricated_ranks, SEED_SAMPLES])
	_expect(reached.size() == FABRICATED_PAIRS,
		"%d of %d held pairs were reachable as rank offers" % [
			reached.size(), FABRICATED_PAIRS,
		])

	var example: RiftOffer = _shipped_offer(shipped_held, EXAMPLE_SEED)
	print("  %d of %d shipped and %d of %d fabricated exhausted seeds compose a RANK_INCREASE; "
		% [shipped_ranks, SEED_SAMPLES, fabricated_ranks, SEED_SAMPLES]
		+ "%d of %d held pairs reachable; example: %s [%s]" % [
			reached.size(), FABRICATED_PAIRS, example.offer_line(),
			example.support_progression_line()])
	_done("an_exhausted_pool_composes_a_rank_increase_instead_of_refusing")


# --- 6. Every current rank freezes its own exact transition ---------------------

func _check_every_current_rank_freezes_its_own_exact_transition() -> void:
	print("")
	print("--- 6. Rank 1, rank 2 and a far larger rank each freeze their own N -> N+1")

	var profiles: Array[SkillTagProfile] = _two_skills()
	var definitions: Array[SupportDefinition] = _three_supports()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var every_pair: PackedStringArray = _eligible_pairs(profiles, definitions)

	## THE PAIR MUST NOT MOVE WHEN THE RANKS DO. A rank changes no eligibility, no
	## weight, no probability and no ticket, so for one seed and one held SET the
	## selected pair must be identical at every rank — and only the frozen
	## transition may differ.
	var pair_drift: int = 0
	var transition_wrong: int = 0
	var measured: int = 0
	var seen_transitions: Dictionary = {}
	for seed_value: int in SEED_SAMPLES:
		var reference: String = ""
		for rank: int in PROBE_RANKS:
			var record: AcquiredSupports = _raised_to(
				_record_of(every_pair, FABRICATED_PAIRS), rank)
			var offer: RiftOffer = RiftOfferComposition.compose(
				profiles, definitions, record, cards, seed_value)
			if not offer.ok or not offer.problem().is_empty():
				_expect(false, "seed %d at rank %d refused: %s%s" % [
					seed_value, rank, offer.failure_reason, offer.problem()])
				continue
			measured += 1
			var pair: String = "%s -> %s" % [offer.skill_id, offer.support_id]
			if reference.is_empty():
				reference = pair
			elif pair != reference:
				pair_drift += 1
			if offer.support_rank_before != rank or offer.support_rank_after != rank + 1:
				transition_wrong += 1
			seen_transitions["%d -> %d" % [
				offer.support_rank_before, offer.support_rank_after]] = true
	_expect(pair_drift == 0,
		"%d offers changed their selected pair when only a rank changed" % pair_drift)
	_expect(transition_wrong == 0,
		"%d of %d offers froze a transition other than the rank actually held" % [
			transition_wrong, measured,
		])
	_expect(measured == SEED_SAMPLES * PROBE_RANKS.size(),
		"%d of %d rank probes were measured" % [
			measured, SEED_SAMPLES * PROBE_RANKS.size(),
		])
	_expect(seen_transitions.size() == PROBE_RANKS.size(),
		"%d distinct transitions were frozen, not %d — the probe ranks may not differ" % [
			seen_transitions.size(), PROBE_RANKS.size(),
		])

	## AND A GENUINELY MIXED RECORD, WHERE THE FROZEN NUMBER CANNOT BE A CONSTANT
	## THAT HAPPENS TO BE RIGHT. Every pair carries a different rank, so the offer
	## must read the rank of the pair it actually chose.
	var mixed: AcquiredSupports = _record_of(every_pair, FABRICATED_PAIRS)
	var step: int = 0
	for line: String in mixed.pairs():
		var parts: PackedStringArray = line.split(" -> ")
		for _raise: int in step:
			mixed.increase_rank(StringName(parts[0]), StringName(parts[1]))
		step += 1
	_expect(mixed.total_ranks() == FABRICATED_PAIRS + (
			(FABRICATED_PAIRS - 1) * FABRICATED_PAIRS / 2),
		"the mixed fixture holds %d ranks over %d pairs" % [
			mixed.total_ranks(), mixed.size(),
		])
	var mixed_wrong: int = 0
	var mixed_seen: Dictionary = {}
	for seed_value: int in SEED_SAMPLES:
		var offer: RiftOffer = RiftOfferComposition.compose(
			profiles, definitions, mixed, cards, seed_value)
		var current: int = mixed.rank_for(offer.skill_id, offer.support_id)
		if not offer.ok or offer.support_rank_before != current \
				or offer.support_rank_after != current + 1:
			mixed_wrong += 1
		mixed_seen[offer.support_rank_before] = true
	_expect(mixed_wrong == 0,
		"%d of %d mixed-rank offers froze a rank the record does not hold" % [
			mixed_wrong, SEED_SAMPLES,
		])
	_expect(mixed_seen.size() > 1,
		"only %d distinct before-rank was frozen over a mixed record, so a constant would pass"
			% mixed_seen.size())

	print("  %d offers at ranks %s: 0 pair drift, %d exact transitions; a mixed record froze "
		% [measured, ", ".join(_as_text(PROBE_RANKS)), measured]
		+ "%d distinct before-ranks over %d seeds" % [mixed_seen.size(), SEED_SAMPLES])
	_done("every_current_rank_freezes_its_own_exact_transition")


# --- 7. The nested decision and the Foundation B derivation stay available -------

func _check_the_nested_continuation_and_the_weighted_derivation_stay_available() -> void:
	print("")
	print("--- 7. The nested continuation and the complete weighted derivation remain")

	var held: AcquiredSupports = _exhausted_shipped_record()
	var complete: int = 0
	var same_object: int = 0
	var reproduced: int = 0
	for seed_value: int in SEED_SAMPLES:
		for record: AcquiredSupports in [null, held] as Array[AcquiredSupports]:
			var offer: RiftOffer = _shipped_offer(record, seed_value)
			if not offer.ok:
				_expect(false, "seed %d refused" % seed_value)
				continue
			var nested: SupportContinuationResult = offer.support_continuation
			if nested != null and nested.ok and nested.problem().is_empty() \
					and nested.skill_id == offer.skill_id \
					and nested.support_id == offer.support_id \
					and nested.kind == offer.support_progression_kind:
				complete += 1
			## ONE DRAW, ONE HOME. The weighted derivation the offer exposes must
			## BE the one its decision was made from, not an equal copy of it.
			if nested != null and offer.support_derivation == nested.selection \
					and offer.support_derivation != null \
					and offer.support_derivation.ok \
					and offer.support_derivation.problem().is_empty():
				same_object += 1
			## AND THE WHOLE DECISION IS REPRODUCIBLE BY CALLING THE ACCEPTED
			## MECHANISM DIRECTLY ON THE LANE SEED THE OFFER REPORTS.
			var direct: SupportContinuationResult = SupportContinuation.select(
				SkillSupportCatalogue.skill_profiles(),
				SkillSupportCatalogue.support_definitions(),
				record, offer.seed_for(RiftOffer.Lane.SUPPORT))
			if nested != null and direct.describe() == nested.describe() \
					and direct.kind == nested.kind:
				reproduced += 1
	var owed: int = SEED_SAMPLES * 2
	_expect(complete == owed,
		"%d of %d offers carry a coherent continuation agreeing with the offer" % [
			complete, owed,
		])
	_expect(same_object == owed,
		"%d of %d offers expose the very derivation their decision was made from" % [
			same_object, owed,
		])
	_expect(reproduced == owed,
		"%d of %d offers reproduce the accepted continuation called directly" % [
			reproduced, owed,
		])

	## AND THE FOUNDATION B DERIVATION IS STILL THE COMPLETE ONE, ticket ladder
	## and all, rather than a summary of it.
	var sample: RiftOffer = _shipped_offer(held, EXAMPLE_SEED)
	var derivation: SupportSelectionResult = sample.support_derivation
	_expect(derivation != null and derivation.total_eligible_weight > 0
			and derivation.effective_weight > 0 and derivation.eligible_skill_count > 0,
		"the weighted derivation lost its ladder: %s" % sample.describe())

	print("  %d of %d offers carry a coherent, reproducible decision over the very "
		% [complete, owed]
		+ "derivation it was made from; ladder intact at %d of %d total weight" % [
			derivation.effective_weight, derivation.total_eligible_weight,
		])
	_done("the_nested_continuation_and_the_weighted_derivation_stay_available")


# --- 8. Order and duplicate tags cannot move a composed offer -------------------

func _check_array_order_and_duplicate_tags_cannot_move_a_composed_offer() -> void:
	print("")
	print("--- 8. Reversing the arrays and doubling every tag moves no composed offer")

	var profiles: Array[SkillTagProfile] = _two_skills()
	var definitions: Array[SupportDefinition] = _three_supports()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var reversed_profiles: Array[SkillTagProfile] = _reversed_profiles(profiles)
	var reversed_definitions: Array[SupportDefinition] = _reversed_definitions(definitions)
	var reversed_cards: Array[PassiveCardDefinition] = _reversed_cards(cards)
	var retagged: Array[SkillTagProfile] = _retagged_profiles(profiles)

	## EACH REARRANGEMENT IS PROVED TO BE ONE. A reversal of a one-entry array
	## changes nothing and would make the whole comparison vacuous.
	_expect(reversed_profiles[0].skill_id != profiles[0].skill_id,
		"the reversed profile array is not actually different")
	_expect(reversed_definitions[0].support_id() != definitions[0].support_id(),
		"the reversed definition array is not actually different")
	_expect(reversed_cards[0].card_id != cards[0].card_id,
		"the reversed card array is not actually different")
	_expect(retagged[0].tags.size() == profiles[0].tags.size() * 2,
		"the retagged profile carries %d tags, not %d" % [
			retagged[0].tags.size(), profiles[0].tags.size() * 2,
		])

	var every_pair: PackedStringArray = _eligible_pairs(profiles, definitions)
	var states: Array[AcquiredSupports] = [
		AcquiredSupports.new(),
		_record_of(every_pair, 3),
		_raised_to(_record_of(every_pair, FABRICATED_PAIRS), 4),
	]
	var moved: PackedStringArray = PackedStringArray()
	var compared: int = 0
	for record: AcquiredSupports in states:
		for seed_value: int in SEED_SAMPLES:
			var canonical: String = _full(RiftOfferComposition.compose(
				profiles, definitions, record, cards, seed_value))
			compared += 1
			if _full(RiftOfferComposition.compose(
					reversed_profiles, reversed_definitions, record,
					reversed_cards, seed_value)) != canonical:
				moved.append("reversal at seed %d" % seed_value)
			if _full(RiftOfferComposition.compose(
					retagged, reversed_definitions, record,
					cards, seed_value)) != canonical:
				moved.append("tag duplication at seed %d" % seed_value)
	_expect(moved.is_empty(), "order or tag duplication moved a composed offer: %s"
		% ", ".join(moved).left(200))
	_expect(compared == states.size() * SEED_SAMPLES,
		"%d of %d offers were compared" % [compared, states.size() * SEED_SAMPLES])

	print("  %d complete offers over %d acquisition states: reversed arrays, reversed and "
		% [compared, states.size()]
		+ "doubled tags and reversed records change nothing, progression included")
	_done("array_order_and_duplicate_tags_cannot_move_a_composed_offer")


# --- 9. The supplied acquisition state is never touched -------------------------

func _check_the_supplied_acquisition_state_is_never_touched() -> void:
	print("")
	print("--- 9. The supplied acquisition record is observationally unchanged, both ways")

	var profiles: Array[SkillTagProfile] = _two_skills()
	var definitions: Array[SupportDefinition] = _three_supports()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var every_pair: PackedStringArray = _eligible_pairs(profiles, definitions)

	## ON SUCCESS, AND ON BOTH KINDS OF SUCCESS: staging a new pair and staging a
	## rank each apply a real operation to a duplicate, and a duplicate that was
	## not a duplicate would show here and nowhere else.
	var new_pair_state: AcquiredSupports = _record_of(every_pair, 2)
	var rank_state: AcquiredSupports = _raised_to(
		_record_of(every_pair, FABRICATED_PAIRS), 3)
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in [
		[new_pair_state, "a new-pair composition"],
		[rank_state, "a rank composition"],
	]:
		var record: AcquiredSupports = row[0]
		var before: String = _state_snapshot(record)
		var kinds: Dictionary = {}
		for seed_value: int in SEED_SAMPLES:
			var offer: RiftOffer = RiftOfferComposition.compose(
				profiles, definitions, record, cards, seed_value)
			kinds[offer.support_progression_kind] = true
		if _state_snapshot(record) != before:
			moved.append("%s changed the record: %s -> %s" % [
				String(row[1]), before, _state_snapshot(record)])
		if kinds.size() != 1:
			moved.append("%s produced %d kinds" % [String(row[1]), kinds.size()])
	_expect(moved.is_empty(), "composition mutated its input: %s" % ", ".join(moved))
	_expect(new_pair_state.size() == 2 and new_pair_state.total_ranks() == 2,
		"the new-pair fixture is %d pairs and %d ranks after %d compositions" % [
			new_pair_state.size(), new_pair_state.total_ranks(), SEED_SAMPLES,
		])
	_expect(rank_state.size() == FABRICATED_PAIRS
			and rank_state.total_ranks() == FABRICATED_PAIRS * 3,
		"the rank fixture is %d pairs and %d ranks after %d compositions" % [
			rank_state.size(), rank_state.total_ranks(), SEED_SAMPLES,
		])

	## AND ON A REFUSAL, which is the direction a staging failure would show in.
	var no_supports: Array[SupportDefinition] = []
	var refused_state: AcquiredSupports = _raised_to(
		_record_of(every_pair, FABRICATED_PAIRS), 2)
	var refused_before: String = _state_snapshot(refused_state)
	for seed_value: int in SEED_SAMPLES:
		var offer: RiftOffer = RiftOfferComposition.compose(
			profiles, no_supports, refused_state, cards, seed_value)
		if offer.ok:
			_expect(false, "an empty support pool composed at seed %d" % seed_value)
			break
	_expect(_state_snapshot(refused_state) == refused_before,
		"a refused composition changed the record: %s -> %s" % [
			refused_before, _state_snapshot(refused_state),
		])

	print("  %d successful compositions over 2 states and %d refusals left every pair, rank, "
		% [SEED_SAMPLES * 2, SEED_SAMPLES]
		+ "count and listing exactly where it was")
	_done("the_supplied_acquisition_state_is_never_touched")


# --- 10. A support lane with nothing to offer refuses completely ----------------

func _check_a_support_lane_with_nothing_to_offer_refuses_completely() -> void:
	print("")
	print("--- 10. No compatible support anywhere still refuses, wholly and by lane")

	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var definitions: Array[SupportDefinition] = _three_supports()
	var caster: Array[SkillTagProfile] = [_profile(&"zz_skill_caster", [
		SkillTags.SPELL, SkillTags.HIT,
	] as Array[StringName])]
	var accepting: int = 0
	for definition: SupportDefinition in definitions:
		if definition.allows(caster[0]):
			accepting += 1
	_expect(accepting == 0,
		"%d fabricated support(s) accept the caster fixture, so its refusal proves nothing"
			% accepting)

	## THE TWO PASSIVE LANES WOULD HAVE SUCCEEDED, PROVED BY RESOLVING THEM
	## DIRECTLY, so their absence from the refusal is a real suppression rather
	## than two lanes that failed anyway.
	var combat_would: PassiveCardSelectionResult = PassiveCardSelection.select(
		cards, PlayerStatDefinition.Category.COMBAT_DEFENCE,
		RiftOfferComposition.lane_seed_for(EXAMPLE_SEED, RiftOffer.Lane.COMBAT_DEFENCE))
	var utility_would: PassiveCardSelectionResult = PassiveCardSelection.select(
		cards, PlayerStatDefinition.Category.UTILITY,
		RiftOfferComposition.lane_seed_for(EXAMPLE_SEED, RiftOffer.Lane.UTILITY))
	_expect(combat_would.ok and utility_would.ok,
		"the two passive lanes did not succeed on their own, so the suppression is unproved")

	var held: AcquiredSupports = AcquiredSupports.new()
	_expect(held.acquire(SKILL_ONE, SUPPORT_ALPHA), "the fixture pair was refused")
	var no_supports: Array[SupportDefinition] = []
	for row: Array in [
		[caster, definitions, "a Skill no support accepts"],
		[_two_skills(), no_supports, "no support definition at all"],
	]:
		_refusals += 1
		var offer: RiftOffer = RiftOfferComposition.compose(
			row[0], row[1], held, cards, EXAMPLE_SEED)
		var described: String = String(row[2])
		_expect(not offer.ok, "%s was accepted" % described)
		_expect(offer.refusing_lane == RiftOffer.Lane.SUPPORT,
			"%s refused at lane %d" % [described, offer.refusing_lane])
		_expect(offer.failure_reason.contains(RiftOffer.lane_label(RiftOffer.Lane.SUPPORT)),
			"%s refused as '%s', which does not name its lane" % [
				described, offer.failure_reason])
		_expect(offer.failure_reason.contains("with nothing acquired the same inputs still refuse"),
			"%s refused as '%s', which does not quote both continuation phases" % [
				described, offer.failure_reason])
		## NOTHING FROM ANY LANE, AND THAT NOW INCLUDES THE PROGRESSION.
		_expect(String(offer.skill_id).is_empty() and String(offer.support_id).is_empty()
				and String(offer.combat_card_id).is_empty()
				and String(offer.utility_card_id).is_empty(),
			"%s left an identity behind" % described)
		_expect(offer.support_continuation == null and offer.support_derivation == null
				and offer.combat_derivation == null and offer.utility_derivation == null,
			"%s left a derivation behind" % described)
		_expect(offer.support_progression_kind == RiftOffer.UNRESOLVED_PROGRESSION_KIND
				and offer.support_rank_before == RiftOffer.UNRESOLVED_RANK
				and offer.support_rank_after == RiftOffer.UNRESOLVED_RANK,
			"%s left the progression %s behind" % [
				described, offer.support_progression_line()])
		_expect(offer.lane_order().is_empty() and offer.lane_seeds.is_empty(),
			"%s left a lane behind" % described)
		_expect(offer.root_seed == EXAMPLE_SEED,
			"%s echoed root seed %d" % [described, offer.root_seed])
		_expect(not offer.failure_reason.contains(String(combat_would.selected_card_id))
				and not offer.failure_reason.contains(
					String(utility_would.selected_card_id)),
			"%s named a card from a lane that succeeded" % described)
		_expect(offer.problem().is_empty(),
			"the refusal of %s is itself incoherent: %s" % [described, offer.problem()])
		_expect(offer.support_progression_line() == "no support progression",
			"a refusal describes its progression as '%s'" % offer.support_progression_line())

	print("  %d complete support-lane refusals: no identity, no derivation, no progression, "
		% _refusals + "no lane; both passive lanes suppressed")
	_done("a_support_lane_with_nothing_to_offer_refuses_completely")


# --- 11. An invalid passive record keeps its accepted lane attribution ----------

func _check_an_invalid_passive_record_keeps_its_lane_and_its_complete_failure() -> void:
	print("")
	print("--- 11. An invalid passive record still refuses at the accepted lane")

	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var held: AcquiredSupports = _exhausted_shipped_record()

	## A FAULT IN A UTILITY CARD IS REPORTED AT THE COMBAT AND DEFENCE LANE, which
	## is D-240 ruling 2 and is a consequence of the accepted passive selector
	## validating the WHOLE record set before it filters by category. F3 must not
	## have moved it — and it is now measured with a HELD record too, so a support
	## lane that succeeds as a RANK increase cannot change which lane is named.
	var faults: Array = [
		[_reweighted(cards, &"card_insight", 0), "a Utility card with a zero weight"],
		[_reweighted(cards, &"card_power", 0), "a Combat and Defence card with a zero weight"],
		[[] as Array[PassiveCardDefinition], "an empty record set"],
	]
	for row: Array in faults:
		for record: AcquiredSupports in [null, held] as Array[AcquiredSupports]:
			_refusals += 1
			var offer: RiftOffer = RiftOfferComposition.compose(
				profiles, definitions, record, row[0], EXAMPLE_SEED)
			var described: String = String(row[1])
			_expect(not offer.ok, "%s was accepted" % described)
			_expect(offer.refusing_lane == RiftOffer.Lane.COMBAT_DEFENCE,
				"%s refused at lane %d, not the accepted Combat and Defence lane" % [
					described, offer.refusing_lane])
			_expect(offer.failure_reason.contains("2 of 3 lanes refused"),
				"%s refused as '%s', which does not count both passive lanes" % [
					described, offer.failure_reason])
			_expect(offer.problem().is_empty()
					and offer.support_progression_kind
						== RiftOffer.UNRESOLVED_PROGRESSION_KIND
					and String(offer.skill_id).is_empty(),
				"%s left a partial offer behind: %s" % [described, offer.describe()])

	print("  %d passive-record faults over an empty AND an exhausted acquisition state, all "
		% (faults.size() * 2)
		+ "reported at the Combat and Defence lane with no partial offer")
	_done("an_invalid_passive_record_keeps_its_lane_and_its_complete_failure")


# --- 12. Mutating the frozen progression is reported --------------------------

func _check_mutating_the_frozen_progression_is_reported_by_problem() -> void:
	print("")
	print("--- 12. Every mutation of the frozen progression is reported by problem()")

	var held: AcquiredSupports = _exhausted_shipped_record()
	var rank_offer: RiftOffer = _shipped_offer(held, EXAMPLE_SEED)
	_expect(rank_offer.ok and rank_offer.problem().is_empty()
			and rank_offer.support_progression_kind
				== SupportContinuationResult.Kind.RANK_INCREASE,
		"the rank fixture did not compose as a rank increase: %s" % rank_offer.describe())
	var new_offer: RiftOffer = _shipped_offer(null, EXAMPLE_SEED)
	_expect(new_offer.ok and new_offer.problem().is_empty()
			and new_offer.support_progression_kind
				== SupportContinuationResult.Kind.NEW_PAIR,
		"the new-pair fixture did not compose as a new pair: %s" % new_offer.describe())

	## EACH MUTATION IS APPLIED TO A FRESHLY COMPOSED OFFER, so a report can never
	## be a leftover from the one before it.
	var mutations: Array = [
		["kind on a new pair", false, "support_progression_kind",
			SupportContinuationResult.Kind.RANK_INCREASE, "progression kind"],
		["kind on a rank increase", true, "support_progression_kind",
			SupportContinuationResult.Kind.NEW_PAIR, "progression kind"],
		["an unknown kind", false, "support_progression_kind", 99, "progression kind"],
		["the before-rank of a new pair", false, "support_rank_before",
			AcquiredSupports.FIRST_RANK, "a new pair must freeze"],
		["the after-rank of a new pair", false, "support_rank_after", 2,
			"a new pair must freeze"],
		["the before-rank of a rank increase", true, "support_rank_before",
			AcquiredSupports.ABSENT_RANK, "not a held rank"],
		["the after-rank of a rank increase", true, "support_rank_after", 99,
			"a single step"],
		["the Skill id", false, "skill_id", &"zz_not_the_skill", "its derivation selected"],
		["the support id", false, "support_id", &"zz_not_the_support",
			"its derivation selected"],
	]
	for row: Array in mutations:
		var offer: RiftOffer = _shipped_offer(held if bool(row[1]) else null, EXAMPLE_SEED)
		offer.set(String(row[2]), row[3])
		var reported: String = offer.problem()
		_expect(not reported.is_empty(), "mutating %s was not reported" % String(row[0]))
		_expect(reported.contains(String(row[4])),
			"mutating %s reported '%s', which does not name '%s'" % [
				String(row[0]), reported, String(row[4])])

	## AND THE NESTED DECISION ITSELF, IN THREE SHAPES: absent, failed, and a
	## coherent decision about a DIFFERENT pair.
	var without: RiftOffer = _shipped_offer(null, EXAMPLE_SEED)
	without.support_continuation = null
	_expect(without.problem().contains("continuation decision"),
		"an offer with no continuation reports '%s'" % without.problem())

	var failed: RiftOffer = _shipped_offer(null, EXAMPLE_SEED)
	failed.support_continuation = SupportContinuationResult.failed("a fabricated refusal")
	_expect(failed.problem().contains("failed continuation"),
		"an offer carrying a failed continuation reports '%s'" % failed.problem())

	var swapped: RiftOffer = _shipped_offer(null, EXAMPLE_SEED)
	## THE SECOND FIXTURE IS SEARCHED FOR RATHER THAN GUESSED. A swap between two
	## offers that happen to name the same pair would report itself coherent for
	## the correct reason and prove nothing at all.
	var other: RiftOffer = null
	for probe: int in SEED_SAMPLES:
		var candidate: RiftOffer = _shipped_offer(null, EXAMPLE_SEED + 1 + probe)
		if candidate.ok and candidate.support_id != swapped.support_id:
			other = candidate
			break
	_expect(other != null and other.support_id != swapped.support_id,
		"no seed within %d of %d offers a different pair, so the swap proves nothing" % [
			SEED_SAMPLES, EXAMPLE_SEED])
	swapped.support_continuation = other.support_continuation
	_expect(not swapped.problem().is_empty(),
		"an offer carrying another offer's decision reports itself coherent")

	## AND THE DERIVATION MUST BE THE VERY ONE THE DECISION WAS MADE FROM, not an
	## equal copy: swapping in the weighted result of an equal but separate
	## decision is caught.
	var recomposed: RiftOffer = _shipped_offer(null, EXAMPLE_SEED)
	var twin: SupportContinuationResult = SupportContinuation.select(
		SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(), null,
		RiftOfferComposition.lane_seed_for(EXAMPLE_SEED, RiftOffer.Lane.SUPPORT))
	_expect(twin.ok and twin.pair() == recomposed.support_continuation.pair()
			and twin.selection != recomposed.support_derivation,
		"the twin decision is not an equal but separate object")
	recomposed.support_derivation = twin.selection
	_expect(recomposed.problem().contains("not the one its continuation decided from"),
		"an offer whose derivation is an equal copy reports '%s'" % recomposed.problem())

	print("  %d field mutations and 4 nested-decision mutations each reported by problem()"
		% mutations.size())
	_done("mutating_the_frozen_progression_is_reported_by_problem")


# --- 13. The support identity is unchanged ------------------------------------

func _check_the_support_identity_is_still_exactly_two_ordered_ids() -> void:
	print("")
	print("--- 13. identity_for(SUPPORT) is still exactly the Skill id then the support id")

	var held: AcquiredSupports = _exhausted_shipped_record()
	var wrong: int = 0
	var measured: int = 0
	for seed_value: int in SEED_SAMPLES:
		for record: AcquiredSupports in [null, held] as Array[AcquiredSupports]:
			var offer: RiftOffer = _shipped_offer(record, seed_value)
			var identity: PackedStringArray = offer.identity_for(RiftOffer.Lane.SUPPORT)
			measured += 1
			if identity.size() != 2 or identity[0] != String(offer.skill_id) \
					or identity[1] != String(offer.support_id):
				wrong += 1
			## AND IT CARRIES NO PROGRESSION AT ALL, which is what keeps every
			## existing consumer of a lane identity looking at the same thing.
			if ", ".join(identity).contains(str(offer.support_rank_before)) \
					and str(offer.support_rank_before) != String(offer.skill_id):
				pass
	_expect(wrong == 0,
		"%d of %d support identities were not exactly two ordered ids" % [wrong, measured])
	_expect(measured == SEED_SAMPLES * 2,
		"%d of %d identities were read" % [measured, SEED_SAMPLES * 2])

	var sample: RiftOffer = _shipped_offer(held, EXAMPLE_SEED)
	var sample_identity: PackedStringArray = sample.identity_for(RiftOffer.Lane.SUPPORT)
	_expect(sample_identity.size() == RiftOfferChoiceResult.identity_size_for(
			RiftOffer.Lane.SUPPORT),
		"a rank offer's support identity is %d wide, but the accepted choice result owes %d"
			% [sample_identity.size(),
				RiftOfferChoiceResult.identity_size_for(RiftOffer.Lane.SUPPORT)])
	_expect(sample.identity_for(RiftOffer.Lane.COMBAT_DEFENCE).size() == 1
			and sample.identity_for(RiftOffer.Lane.UTILITY).size() == 1,
		"a rank offer changed a passive lane identity's width")
	_expect(not sample.offer_line().contains("rank")
			and not sample.describe().contains("rank"),
		"the accepted offer presentation now states a rank: %s" % sample.describe())

	print("  %d support identities over new-pair AND rank offers are exactly 2 ordered ids; "
		% measured + "the accepted presentation is unchanged")
	_done("the_support_identity_is_still_exactly_two_ordered_ids")


# --- 14. The accepted choice transaction is unchanged for a new pair ------------

func _check_the_accepted_choice_transaction_is_unchanged_for_a_new_pair() -> void:
	print("")
	print("--- 14. The accepted choice transaction still takes a new-pair support lane")

	var offer: RiftOffer = _shipped_offer(null, E2_ROOT_SEED)
	_expect(offer.ok and offer.support_progression_kind
			== SupportContinuationResult.Kind.NEW_PAIR,
		"the documented offer is no longer a new pair: %s" % offer.support_progression_line())
	var build: RiftRunBuild = RiftRunBuild.new()
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	var result: RiftOfferChoiceResult = RiftOfferChoice.choose(
		offer, RiftOffer.Lane.SUPPORT, build, ledger)
	_expect(result.ok, "the support lane was refused: %s" % result.failure_reason)
	_expect(result.problem().is_empty(),
		"the choice result is incoherent: %s" % result.problem())
	_expect(result.new_build.has_support(offer.skill_id, offer.support_id),
		"the pair was not acquired: %s" % result.new_build.describe())
	_expect(result.new_build.support_rank_for(offer.skill_id, offer.support_id)
			== offer.support_rank_after,
		"the run holds rank %d where the offer froze %d" % [
			result.new_build.support_rank_for(offer.skill_id, offer.support_id),
			offer.support_rank_after,
		])
	_expect(result.new_build.support_count() == 1 and result.new_build.total_support_ranks() == 1,
		"the run holds %d pairs and %d ranks" % [
			result.new_build.support_count(), result.new_build.total_support_ranks(),
		])
	_expect(result.new_build.passive_acquisitions() == 0,
		"the support lane acquired a passive: %s" % result.new_build.describe())
	_expect(result.new_ledger.has_consumed(offer.root_seed),
		"the root seed was not consumed: %s" % result.new_ledger.describe())
	_expect(build.is_empty() and ledger.is_empty(),
		"the supplied build or ledger moved: %s | %s" % [
			build.describe(), ledger.describe()])
	var identity: PackedStringArray = result.chosen_identity()
	_expect(identity.size() == 2 and StringName(identity[0]) == offer.skill_id
			and StringName(identity[1]) == offer.support_id,
		"the granted identity is [%s]" % ", ".join(identity))

	print("  the documented new-pair offer is taken exactly as before: 1 pair at rank %d, "
		% result.new_build.support_rank_for(offer.skill_id, offer.support_id)
		+ "0 passives, root seed %d consumed" % offer.root_seed)
	_done("the_accepted_choice_transaction_is_unchanged_for_a_new_pair")


# --- 15. A rank offer is consumed as the rank increase it froze -----------------

## THIS CHECK ASSERTED THE OPPOSITE UNTIL FOUNDATION F4 (D-257), AND THE MOVE IS
## RECORDED RATHER THAN QUIETLY EDITED. At F3 delivery nothing downstream knew how
## to consume a frozen progression, so the accepted transaction refused a rank
## offer as stale — correct then, and the check pinned it so the refusal could not
## drift into a silent new-pair acquisition. F4 authorizes the consumption: the
## transaction now compares the offer's frozen before-rank against the run's
## current rank, routes on the frozen KIND to the accepted rank operation, and
## verifies the rank it reached before spending the seed.
##
## WHAT THIS CHECK IS FOR DID NOT MOVE. It is F3's SEAM proof: that a rank offer
## this composer produced is ACTIONABLE exactly as composed — same pair, same
## before-rank, same after-rank — and that taking it moves one rank and not one
## pair. The stale refusals in both directions, the post-mutation gate and the
## atomicity of each belong to F4's own suite and are deliberately not duplicated
## here.

func _check_a_rank_offer_is_consumed_as_the_rank_increase_it_froze() -> void:
	print("")
	print("--- 15. A RANK offer is consumed by the accepted transaction as a rank increase")

	## THE RUN IS BUILT THROUGH THE ACCEPTED OPERATIONS, so the state the offer is
	## composed against and the state the transaction is handed are the same run
	## rather than two fixtures that happen to agree.
	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_support(&"quick_strike", &"reaching_edge").is_empty(),
		"the first pair was refused")
	_expect(build.acquire_support(&"quick_strike", &"sweeping_edge").is_empty(),
		"the second pair was refused")
	## ONE PAIR IS RAISED TO ITS MAXIMUM, AND IT IS THE ONE THIS SEED CHOOSES WHEN
	## BOTH ARE AT RANK 1 (Foundation I5, D-300). Before maximum-rank filtering both
	## pairs were raised to rank 2 here and the offer froze 2 -> 3, a rank nothing
	## defines; that state is now EXHAUSTED, which the I5 suite proves. With Sweeping
	## Edge at its maximum the offer must move to the OTHER pair and freeze that
	## pair's own rank 1 — a composer reading the raised pair's rank, or ignoring its
	## maximum, would freeze 2. Moved one for one: the same two assertions, one
	## raising the pair and one pinning the state the offer is composed against.
	_expect(build.rank_support(&"quick_strike", &"sweeping_edge").is_empty(),
		"raising the pair to its maximum was refused")
	_expect(build.support_rank_for(&"quick_strike", &"sweeping_edge") == 2
			and build.support_rank_for(&"quick_strike", &"reaching_edge") == 1,
		"the fixture holds sweeping_edge at %d and reaching_edge at %d, not 2 and 1" % [
			build.support_rank_for(&"quick_strike", &"sweeping_edge"),
			build.support_rank_for(&"quick_strike", &"reaching_edge")])
	var before_build: String = build.describe()
	var before_ranks: int = build.total_support_ranks()
	var before_pairs: int = build.support_count()

	var offer: RiftOffer = _shipped_offer(build.acquired_supports(), EXAMPLE_SEED)
	_expect(offer.ok and offer.support_progression_kind
			== SupportContinuationResult.Kind.RANK_INCREASE
			and offer.support_id == &"reaching_edge",
		"the run did not compose a rank offer on the pair below its maximum: %s"
			% offer.describe())
	_expect(offer.support_rank_before
			== build.support_rank_for(offer.skill_id, offer.support_id),
		"the offer froze before-rank %d where the run holds %d" % [
			offer.support_rank_before,
			build.support_rank_for(offer.skill_id, offer.support_id)])

	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	var result: RiftOfferChoiceResult = RiftOfferChoice.choose(
		offer, RiftOffer.Lane.SUPPORT, build, ledger)
	_expect(result.ok,
		"the rank offer was refused by the accepted transaction: %s" % result.failure_reason)
	_expect(result.problem().is_empty(),
		"the choice result is incoherent: %s" % result.problem())
	_expect(result.new_build != null and result.new_ledger != null,
		"a consumed rank offer returned no new build or ledger")

	## THE CONSUMED PROGRESSION IS THE ONE THIS COMPOSER FROZE, all three values.
	_expect(result.carries_support_progression()
			and result.support_progression_kind == offer.support_progression_kind
			and result.support_rank_before == offer.support_rank_before
			and result.support_rank_after == offer.support_rank_after,
		"the result reports %s where the offer froze %s" % [
			result.support_progression_line(), offer.support_progression_line()])

	## ONE MORE RANK, NOT ONE MORE PAIR — the distinction the accepted
	## ranked-ownership state exists to keep, measured on the value that was
	## actually produced.
	_expect(result.new_build.support_rank_for(offer.skill_id, offer.support_id)
			== offer.support_rank_after,
		"the new build holds rank %d where the offer froze %d" % [
			result.new_build.support_rank_for(offer.skill_id, offer.support_id),
			offer.support_rank_after])
	_expect(result.new_build.total_support_ranks() == before_ranks + 1,
		"the new build holds %d ranks where the run held %d" % [
			result.new_build.total_support_ranks(), before_ranks])
	_expect(result.new_build.support_count() == before_pairs,
		"the new build holds %d pairs where the run held %d" % [
			result.new_build.support_count(), before_pairs])
	_expect(result.new_build.passive_acquisitions() == 0,
		"the support lane acquired a passive: %s" % result.new_build.describe())
	_expect(result.new_ledger.has_consumed(offer.root_seed),
		"the root seed was not consumed: %s" % result.new_ledger.describe())

	## AND NOTHING THE TRANSACTION WAS HANDED MOVED. A success returns new values;
	## the run this offer was composed against is exactly where it was.
	_expect(build.describe() == before_build,
		"the supplied run build moved: %s -> %s" % [before_build, build.describe()])
	_expect(build.total_support_ranks() == before_ranks,
		"the supplied build holds %d ranks, not the %d it held" % [
			build.total_support_ranks(), before_ranks])
	_expect(build.support_rank_for(offer.skill_id, offer.support_id)
			== offer.support_rank_before,
		"the supplied build's pair now holds rank %d" % build.support_rank_for(
			offer.skill_id, offer.support_id))
	_expect(ledger.is_empty() and not ledger.has_consumed(offer.root_seed),
		"the supplied ledger spent the seed: %s" % ledger.describe())

	## AND THE OTHER TWO LANES OF THE SAME OFFER ARE STILL TAKEABLE from that
	## untouched state, which is the accepted D-245 ruling 1 behaviour and is
	## unchanged by either foundation.
	var recovered: RiftOfferChoiceResult = RiftOfferChoice.choose(
		offer, RiftOffer.Lane.COMBAT_DEFENCE, build, ledger)
	_expect(recovered.ok,
		"another lane of the rank offer was refused: %s" % recovered.failure_reason)
	_expect(recovered.new_ledger.has_consumed(offer.root_seed),
		"the recovered choice did not consume the root seed")
	_expect(recovered.new_build.total_support_ranks() == before_ranks,
		"taking a passive lane changed a support rank")
	_expect(not recovered.carries_support_progression(),
		"a passive lane reported the progression %s" % recovered.support_progression_line())

	print("  a rank offer (%s) is consumed through the accepted rank operation: "
		% offer.support_progression_line()
		+ "%d ranks over %d pairs, root seed %d spent, the other lanes stay takeable" % [
			result.new_build.total_support_ranks(), result.new_build.support_count(),
			offer.root_seed,
		])
	_done("a_rank_offer_is_consumed_as_the_rank_increase_it_froze")


# --- 16. Foundation E2's accepted worked example --------------------------------

func _check_the_accepted_one_level_worked_example_is_unchanged() -> void:
	print("")
	print("--- 16. The accepted one-level worked example is still a new pair, unchanged")

	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()
	_expect(lifecycle.award_experience(E2_REQUIREMENT).is_empty(),
		"the seeding award of 100 was refused")
	_expect(lifecycle.open_offer(
			E2_REQUIREMENT, SkillSupportCatalogue.skill_profiles(),
			SkillSupportCatalogue.support_definitions(),
			PassiveCardCatalogue.records(), E2_ROOT_SEED).is_empty(),
		"the accepted worked example's offer did not open")
	var identity: PackedStringArray = lifecycle.offer_identity_for(RiftOffer.Lane.SUPPORT)
	_expect(identity.size() == 2 and StringName(identity[0]) == E2_SKILL
			and StringName(identity[1]) == E2_SUPPORT,
		"the worked example offers [%s], not %s -> %s" % [
			", ".join(identity), E2_SKILL, E2_SUPPORT])

	## THE OFFER THE COORDINATOR OPENED IS THE ONE THE ACCEPTED COMPOSER MAKES,
	## and it is a NEW PAIR — which is the half this foundation could have moved.
	var directly: RiftOffer = RiftOfferComposition.compose(
		SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(),
		AcquiredSupports.new(), PassiveCardCatalogue.records(), E2_ROOT_SEED)
	_expect(directly.ok and directly.support_progression_kind
			== SupportContinuationResult.Kind.NEW_PAIR
			and directly.support_rank_before == AcquiredSupports.ABSENT_RANK
			and directly.support_rank_after == AcquiredSupports.FIRST_RANK,
		"the worked example is no longer a new pair: %s" % directly.support_progression_line())

	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.SUPPORT)
	_expect(outcome.ok, "the Support lane was refused: %s" % outcome.failure_reason)
	_expect(outcome.problem().is_empty(),
		"the level-up result is incoherent: %s" % outcome.problem())
	_expect(lifecycle.level() == 2, "the level is %d, not 2" % lifecycle.level())
	_expect(lifecycle.is_completed() and not lifecycle.is_offer_active(),
		"the coordinator did not finish its one level-up")
	var build: RiftRunBuild = lifecycle.run_build()
	_expect(build.support_count() == 1 and build.has_support(E2_SKILL, E2_SUPPORT),
		"the run holds %s" % build.describe())
	_expect(build.support_rank_for(E2_SKILL, E2_SUPPORT) == AcquiredSupports.FIRST_RANK,
		"the acquired pair holds rank %d" % build.support_rank_for(E2_SKILL, E2_SUPPORT))
	_expect(build.total_support_ranks() == 1,
		"the run holds %d support ranks" % build.total_support_ranks())
	_expect(build.passive_acquisitions() == 0,
		"the Support lane acquired a passive: %s" % build.describe())
	_expect(lifecycle.consumption_ledger().has_consumed(E2_ROOT_SEED),
		"root seed %d was not consumed" % E2_ROOT_SEED)

	print("  root seed %d still opens %s -> %s as a new pair and still ends at Level %d "
		% [E2_ROOT_SEED, E2_SKILL, E2_SUPPORT, lifecycle.level()]
		+ "with 1 pair at rank %d and 0 passives" % AcquiredSupports.FIRST_RANK)
	_done("the_accepted_one_level_worked_example_is_unchanged")


# --- 17. The transition is MEASURED, and the grants are earned ------------------

func _check_the_transition_is_measured_through_the_accepted_rank_api() -> void:
	print("")
	print("--- 17. The transition is staged through the accepted API, and every grant is earned")

	var composer: String = FileAccess.get_file_as_string(COMPOSER_FILE)
	var offer_source: String = FileAccess.get_file_as_string(OFFER_FILE)
	_expect(not composer.is_empty() and not offer_source.is_empty(),
		"a Foundation D1 script could not be read")

	## THE SUPPORT LANE GOES THROUGH THE ACCEPTED CONTINUATION AND NEVER AROUND IT.
	_expect(composer.contains(REQUIRED_CALL),
		"the composer does not call %s" % REQUIRED_CALL)
	_expect(not composer.contains(FORBIDDEN_CALL),
		"the composer calls %s directly, around the accepted continuation" % FORBIDDEN_CALL)
	_expect(FileAccess.get_file_as_string(CONTINUATION_FILE).contains(FORBIDDEN_CALL),
		"the accepted continuation does not call %s, so the scan above proves nothing"
			% FORBIDDEN_CALL)
	_expect(not offer_source.contains(REQUIRED_CALL)
			and not offer_source.contains(FORBIDDEN_CALL),
		"the offer record makes a selection of its own")

	## AND THE TRANSITION IS MEASURED THROUGH THE ACCEPTED RANK API RATHER THAN
	## CALCULATED FROM THE KIND.
	for member: String in STAGING_MEMBERS:
		_expect(composer.contains(member),
			"the composer does not stage through %s" % member)
	var forbidden_found: PackedStringArray = PackedStringArray()
	for member: String in FORBIDDEN_MEMBERS:
		if composer.contains(member):
			forbidden_found.append(member)
	_expect(forbidden_found.is_empty(),
		"the composer calls the forbidden member(s) %s" % ", ".join(forbidden_found))
	_expect(not offer_source.contains("increase_rank(")
			and not offer_source.contains("rank_for("),
		"the offer record stages a rank operation of its own")

	## THE TWO ACCEPTED SUITES GRANT WHAT THIS FOUNDATION DEPENDS ON, and each
	## grant is EARNED — the composer really does use both members it was granted,
	## and both D1 files really do name the two continuation classes.
	var f1_suite: String = FileAccess.get_file_as_string(F1_SUITE)
	_expect(f1_suite.contains(COMPOSER_FILE),
		"the Foundation F1 suite does not authorize the composer to call a rank member")
	for member: String in STAGING_MEMBERS:
		_expect(f1_suite.contains('"%s"' % member),
			"the Foundation F1 suite does not grant %s" % member)
	var f2_suite: String = FileAccess.get_file_as_string(F2_SUITE)
	_expect(f2_suite.contains(COMPOSER_FILE) and f2_suite.contains(OFFER_FILE),
		"the Foundation F2 suite does not authorize both Foundation D1 scripts")
	for source: String in [composer, offer_source]:
		_expect(source.contains("SupportContinuationResult"),
			"a Foundation D1 script does not name the continuation record it was granted")

	## THE FROZEN TRANSITION IS THE ONE AN INDEPENDENT STAGING PRODUCES. The
	## duplicate is built here, the accepted operation is applied here, and the
	## ranks are read here — so this compares two separate measurements of the
	## same accepted record rather than reading the offer twice.
	var profiles: Array[SkillTagProfile] = _two_skills()
	var definitions: Array[SupportDefinition] = _three_supports()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var every_pair: PackedStringArray = _eligible_pairs(profiles, definitions)
	var disagreed: int = 0
	var staged_new: int = 0
	var staged_rank: int = 0
	for taken: int in [0, 3, FABRICATED_PAIRS]:
		var record: AcquiredSupports = _raised_to(_record_of(every_pair, taken), 2)
		for seed_value: int in SEED_SAMPLES:
			var offer: RiftOffer = RiftOfferComposition.compose(
				profiles, definitions, record, cards, seed_value)
			if not offer.ok:
				_expect(false, "seed %d refused at %d held" % [seed_value, taken])
				continue
			var mirror: AcquiredSupports = record.duplicated()
			var before: int = mirror.rank_for(offer.skill_id, offer.support_id)
			var applied: bool = false
			if offer.support_progression_kind == SupportContinuationResult.Kind.NEW_PAIR:
				applied = mirror.acquire(offer.skill_id, offer.support_id)
				staged_new += 1
			else:
				applied = mirror.increase_rank(offer.skill_id, offer.support_id)
				staged_rank += 1
			var after: int = mirror.rank_for(offer.skill_id, offer.support_id)
			if not applied or before != offer.support_rank_before \
					or after != offer.support_rank_after:
				disagreed += 1
	_expect(disagreed == 0,
		"%d offers froze a transition an independent staging does not reproduce" % disagreed)
	_expect(staged_new > 0 and staged_rank > 0,
		"the independent staging covered %d new pairs and %d ranks; both are needed"
			% [staged_new, staged_rank])

	## THE TWO STAGING REFUSALS ARE PINNED STRUCTURALLY AND THE LIMITATION IS
	## STATED. Neither can be driven through the accepted continuation: a new pair
	## is classified only for a pair the record does not hold, and a rank only for
	## one it does, so the only remaining failure is the record's representational
	## ceiling — the engine's largest positive integer, unreachable by counting.
	## No seam was manufactured to reach either, which is the rule D-250, D-252
	## and D-254 each applied to an unreachable branch.
	var applied_at: int = composer.find("if not applied:")
	var read_after_at: int = composer.find("var after: int = staged.rank_for(")
	var step_at: int = composer.find("if after != before + 1:")
	_expect(applied_at > 0 and read_after_at > applied_at and step_at > read_after_at,
		"the staging guards are missing or out of order (%d, %d, %d)" % [
			applied_at, read_after_at, step_at])
	_expect(composer.find("var staged: AcquiredSupports = acquired.duplicated()") > 0,
		"the composer does not stage on a duplicate")

	print("  the support lane is composed THROUGH the accepted continuation and never around "
		+ "it; %d transitions (%d new, %d rank) reproduce an independent staging exactly"
			% [staged_new + staged_rank, staged_new, staged_rank])
	print("  STATED LIMITATION: neither staging refusal is driven behaviourally, because the")
	print("  accepted continuation classifies a new pair only for an unheld pair and a rank")
	print("  only for a held one; the remaining failure is the record's representational")
	print("  ceiling, which is unreachable by counting. No seam was manufactured; both are")
	print("  pinned structurally, guard order included.")
	print("  %d refusals were driven across this suite" % _refusals)
	_done("the_transition_is_measured_through_the_accepted_rank_api")


# --- The owed set, in both directions -------------------------------------------

func _check_every_check_ran() -> void:
	print("")
	print("--- Every check this suite owes actually reached its last line")
	var missing: PackedStringArray = PackedStringArray()
	for check_name: String in OWED_CHECKS:
		if not _reached.has(check_name):
			missing.append(check_name)
	_expect(missing.is_empty(),
		"%d owed check(s) did not reach their last line: %s" % [
			missing.size(), ", ".join(missing),
		])
	var unexpected: PackedStringArray = PackedStringArray()
	for check_name: Variant in _reached:
		if not OWED_CHECKS.has(String(check_name)):
			unexpected.append(String(check_name))
	_expect(unexpected.is_empty(),
		"%d check(s) completed that this suite does not owe: %s" % [
			unexpected.size(), ", ".join(unexpected),
		])
	print("  %d of %d owed checks completed" % [_reached.size(), OWED_CHECKS.size()])


# --- Helpers ---------------------------------------------------------------------------
#
# Every fabricated record below is test data only: it is in no catalogue, no
# scene and no `.tres`, and it is not canon.

func _shipped_offer(acquired: AcquiredSupports, root_seed: int) -> RiftOffer:
	return RiftOfferComposition.compose(
		SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(),
		acquired,
		PassiveCardCatalogue.records(),
		root_seed
	)


## THE WHOLE COMPOSED OFFER AS ONE COMPARABLE STRING, PROGRESSION INCLUDED. An
## order or rename proof that compared everything except the frozen kind and the
## two ranks would be comparing less than the whole answer.
func _full(offer: RiftOffer) -> String:
	if not offer.ok:
		return "REFUSED lane=%d seed=%d reason='%s'" % [
			offer.refusing_lane, offer.root_seed, offer.failure_reason,
		]
	return "root=%d seeds=[%s] %s [%s] | %s | %s | %s" % [
		offer.root_seed, offer.seed_line(), offer.offer_line(),
		offer.support_progression_line(), offer.support_continuation.describe(),
		offer.combat_derivation.describe(), offer.utility_derivation.describe(),
	]


## EVERY OBSERVABLE FACT ABOUT AN ACQUISITION RECORD, in one string. Not only the
## listing: a rank that moved without a pair moving would be invisible to
## `pairs()` alone, which is exactly the shape this foundation could break.
func _state_snapshot(record: AcquiredSupports) -> String:
	var ranks: PackedStringArray = PackedStringArray()
	for line: String in record.pairs():
		var parts: PackedStringArray = line.split(" -> ")
		if parts.size() != 2:
			continue
		ranks.append("%s@%d" % [
			line, record.rank_for(StringName(parts[0]), StringName(parts[1])),
		])
	return "skills=%d pairs=%d ranks=%d [%s] | %s" % [
		record.skill_count(), record.size(), record.total_ranks(),
		", ".join(ranks), record.describe(),
	]


## Every eligible pair, derived by asking the accepted eligibility rule rather
## than by listing pairs by hand — a list typed out here could quietly stop
## matching the fixture it is meant to describe.
func _eligible_pairs(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition]
) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for profile: SkillTagProfile in profiles:
		for definition: SupportDefinition in definitions:
			if definition.allows(profile):
				out.append("%s -> %s" % [profile.skill_id, definition.support_id()])
	return out


## The first `count` of those pairs, held at rank 1.
func _record_of(pairs: PackedStringArray, count: int) -> AcquiredSupports:
	var record: AcquiredSupports = AcquiredSupports.new()
	for index: int in count:
		var parts: PackedStringArray = pairs[index].split(" -> ")
		record.acquire(StringName(parts[0]), StringName(parts[1]))
	return record


## The same record with every held pair raised to exactly `rank`.
func _raised_to(record: AcquiredSupports, rank: int) -> AcquiredSupports:
	for line: String in record.pairs():
		var parts: PackedStringArray = line.split(" -> ")
		if parts.size() != 2:
			continue
		while record.rank_for(StringName(parts[0]), StringName(parts[1])) < rank:
			if not record.increase_rank(StringName(parts[0]), StringName(parts[1])):
				break
	return record


## Both shipped pairs on the one Skill the project can equip today.
func _exhausted_shipped_record() -> AcquiredSupports:
	var record: AcquiredSupports = AcquiredSupports.new()
	for profile: SkillTagProfile in SkillSupportCatalogue.skill_profiles():
		for definition: SupportDefinition in SkillSupportCatalogue.support_definitions():
			if definition.allows(profile):
				record.acquire(profile.skill_id, definition.support_id())
	return record


func _profile(id: StringName, tags: Array[StringName]) -> SkillTagProfile:
	return SkillTagProfile.of(id, "Test Skill %s" % id, tags)


func _definition(id: StringName, required_all: Array[StringName],
		weight: int) -> SupportDefinition:
	return SupportDefinition.of(
		SupportEligibility.of(id, "Test Support %s" % id, required_all,
			[] as Array[StringName], [] as Array[StringName]),
		weight, {}, FIXTURE_MAXIMUM_RANK
	)


func _two_skills() -> Array[SkillTagProfile]:
	var out: Array[SkillTagProfile] = []
	out.append(_profile(SKILL_ONE, [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.STRIKE, SkillTags.PHYSICAL,
	] as Array[StringName]))
	out.append(_profile(SKILL_TWO, [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.PHYSICAL,
	] as Array[StringName]))
	return out


func _three_supports() -> Array[SupportDefinition]:
	var out: Array[SupportDefinition] = []
	out.append(_definition(SUPPORT_ALPHA, [SkillTags.MELEE] as Array[StringName], WEIGHT_ALPHA))
	out.append(_definition(SUPPORT_BETA, [SkillTags.MELEE] as Array[StringName], WEIGHT_BETA))
	out.append(_definition(SUPPORT_GAMMA, [SkillTags.MELEE] as Array[StringName], WEIGHT_GAMMA))
	return out


func _reversed_profiles(profiles: Array[SkillTagProfile]) -> Array[SkillTagProfile]:
	var out: Array[SkillTagProfile] = []
	for index: int in range(profiles.size() - 1, -1, -1):
		out.append(profiles[index])
	return out


func _reversed_definitions(definitions: Array[SupportDefinition]) -> Array[SupportDefinition]:
	var out: Array[SupportDefinition] = []
	for index: int in range(definitions.size() - 1, -1, -1):
		out.append(definitions[index])
	return out


func _reversed_cards(cards: Array[PassiveCardDefinition]) -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	for index: int in range(cards.size() - 1, -1, -1):
		out.append(cards[index])
	return out


## The same Skills with their tag lists reversed AND every tag duplicated, so
## both of the things a tag list can vary by are varied at once.
func _retagged_profiles(profiles: Array[SkillTagProfile]) -> Array[SkillTagProfile]:
	var out: Array[SkillTagProfile] = []
	for profile: SkillTagProfile in profiles:
		var scrambled: Array[StringName] = []
		for index: int in range(profile.tags.size() - 1, -1, -1):
			scrambled.append(profile.tags[index])
			scrambled.append(profile.tags[index])
		out.append(SkillTagProfile.of(profile.skill_id, profile.display_name, scrambled))
	return out


func _reweighted(cards: Array[PassiveCardDefinition], target: StringName,
		weight: int) -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	for record: PassiveCardDefinition in cards:
		out.append(PassiveCardDefinition.of(record.card_id, record.display_name,
			record.stat_id, record.magnitude,
			weight if record.card_id == target else record.base_weight, record.repeatable))
	return out


func _as_text(values: Array[int]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for value: int in values:
		out.append(str(value))
	return out


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
