extends SceneTree
## Riftwrought — Roguelite Foundation C3 verification: Deterministic Passive
## Card Selection (decision D-234).
##
## ONE FOCUSED HEADLESS TEST. The foundation is two pure-logic scripts under
## `scripts/stats/` — a selector and its result — so it needs no scene, no
## camera, no navigation, no rendering and no evidence frame, and it deliberately
## gets none. It runs as a `SceneTree` script exactly as all four earlier
## foundations' suites do.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## THE TICKET LADDER IS WALKED EXHAUSTIVELY, NOT SAMPLED. Every ticket from 0 to
## the category total is drawn and its owner recorded, so "each card owns exactly
## a hundred tickets" is a complete enumeration rather than an impression from a
## handful of seeds. Nothing in this suite proves a distribution by sampling one.
##
## THE EXPECTED POOLS ARE WRITTEN OUT HERE, NOT READ FROM THE CATALOGUE. A check
## that takes its expected answer from the thing it is checking proves only that
## a file agrees with itself. Both pools, their order, their weights and their
## total are typed independently below.
##
## THE SEED CORPUS IS A REGRESSION PIN AND SAYS SO. Reproducing a fixed corpus
## proves the stream cannot change silently; it does not prove the mapping is
## right, and it is not asked to. Correctness lives in the exhaustive ticket
## walk, which uses no seed at all.
##
## THE TEST DATA IS NOT CONTENT. Every fabricated card built below lives inside
## this file only, is registered in no catalogue, ships in no scene, no `.tres`
## and no library, and is not canon.

## The two scripts this foundation owns. NEITHER may name a concrete class, a
## card, a catalogue or a presentation name. Scanned RAW, comments included —
## D-215's lesson: an illustrative name in a comment breaches the rule just as
## surely as a real one.
const SELECTION_FILES: Array[String] = [
	"res://scripts/stats/passive_card_selection.gd",
	"res://scripts/stats/passive_card_selection_result.gd",
]

## Concrete class, Skill, support and card names. The same list Foundations C1
## and C2 are held to, plus the CATALOGUE itself: a selector takes the records it
## is given, so naming the shipped six would make it the shipped six's selector.
const FORBIDDEN_TOKENS: Array[String] = [
	"QuickStrike", "quick_strike", "Quick Strike",
	"PrototypePlayer", "PrototypeWeaponData", "PrototypeGraveblade",
	"PassiveEffects", "PassiveGraph", "PassiveNodeData",
	"RogueliteUpgrade", "RogueliteRunBoon", "RogueliteBuildState",
	"SkillSupportCatalogue", "SupportDefinition", "SupportSelection", "SkillTags",
	"FirstMvpSkill", "CharacterState", "ExperienceTable", "PlayerLoadout",
	"Faultbreaker", "Splinter Shot", "Emberbolt", "Marrowshot",
	"Reaching Edge", "reaching_edge", "Sweeping Edge", "sweeping_edge",
	"Expedition Blade", "Quickened Edge", "Quickened Form",
	"First Fracture", "first_fracture", "Graveblade", "Riftmarked",
	"PassiveCardCatalogue", "card_power", "card_celerity", "card_vitality",
	"card_fleetness", "card_insight", "card_magnetism",
]

## A pure selector may read no ambient state whatsoever.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
]

## The presentation field the mechanism must be unable to see. Scanned for by
## name AND driven behaviourally, because either alone is weaker: a scan cannot
## see a name read through a helper, and a behavioural test cannot see a name
## read for a purpose that happens not to matter today.
const NAME_FIELD_TOKEN: String = "display_name"

## The two global class names this foundation introduces. NOTHING that runs may
## reference either: C3 selects and is deliberately unwired — no offer, no
## acquisition, no runtime application.
const SELECTION_CLASSES: Array[String] = [
	"PassiveCardSelection", "PassiveCardSelectionResult",
]

## `res://addons` IS SCANNED TOO, AND THAT IS DELIBERATELY WIDER THAN THE THREE
## ROOTS THE EARLIER FOUNDATIONS USE. An editor plugin is code that runs; a
## reference from one would load this class while a scripts/scenes/data scan
## reported nothing. `project.godot` is checked separately below, because an
## `[autoload]` entry names a class from a file no extension filter would reach.
const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]

## THE FILES AUTHORIZED TO NAME A FOUNDATION C3 CLASS, AND THE EXACT CLASSES EACH
## MAY NAME (D-239). The Foundation D1 offer composer DELEGATES both of its
## passive lanes to this selector, so it names the selector and the result it
## returns; the D1 offer HOLDS those two results and reads the category label
## from the result's own formatter, so it names the result.
##
## THIS REPLACES D-234's BLANKET "nothing that runs may name either class" ONE
## FOR ONE: the same single assertion is made either way, it still fails for any
## other file AND for any class a listed file is not granted, and the pinned
## count does not move.
##
## ONE SUBSTRING IS RECORDED RATHER THAN LEFT TO BE FOUND: `PassiveCardSelection`
## is contained in `PassiveCardSelectionResult`, so a file naming the result is
## reported as naming the selector too, and a grant for the result must carry
## both. The stronger property — that the D1 offer never CALLS this selector — is
## asserted by the D1 suite, which owns that boundary.
const AUTHORIZED_READERS: Array = [
	["res://scripts/offers/rift_offer_composition.gd",
		["PassiveCardSelection", "PassiveCardSelectionResult"]],
	["res://scripts/offers/rift_offer.gd",
		["PassiveCardSelection", "PassiveCardSelectionResult"]],
	## D-304: the Roguelite Foundation I6 exhausted-support fallback asks this
	## selector's public record check and its exclusion-aware draw for every card
	## it could choose, and reads the two passive lanes' results to learn which
	## cards to exclude, so it names both classes; its result HOLDS the card
	## draw's own result, so it names the result and — by the substring above —
	## the selector. Added one for one, and the pinned count does not move.
	["res://scripts/fallback/support_exhaustion_passive_fallback.gd",
		["PassiveCardSelection", "PassiveCardSelectionResult"]],
	["res://scripts/fallback/support_exhaustion_passive_fallback_result.gd",
		["PassiveCardSelection", "PassiveCardSelectionResult"]],
]

## The one project file that can load a class without naming it from any
## script at all.
const PROJECT_SETTINGS_FILE: String = "res://project.godot"

## The only project classes the two scripts may name. An ALLOWLIST derived from
## the engine's own global class list, not a denylist of remembered names.
const AUTHORIZED_CLASSES: Array[String] = [
	"PassiveCardSelection", "PassiveCardSelectionResult",
	"PassiveCardDefinition", "PlayerStats", "PlayerStatDefinition",
]

## Every method each script declares, in order, and no other. Pinned as NAMES
## rather than as a count, because the thing this guards against — an offer
## generator, an acquisition step, a stacking rule, a pity counter — arrives as
## an extra method with a plausible name rather than as a missing one.
##
## ROGUELITE FOUNDATION I6 (D-304) ADDED EXACTLY TWO, in the positions below, as
## extensions rather than replacements: the exclusion-aware draw that
## `select_with_ticket` is now the empty-exclusion case of, and the whole-set
## record check moved out of that draw so a caller need not copy it. The same
## single assertion pins the same list; no existing name moved.
const EXPECTED_SELECTOR_METHODS: Array[String] = [
	"select", "select_with_ticket", "select_with_ticket_excluding", "records_problem",
	"ticket_for", "_mix", "_sorted_records",
]

const EXPECTED_RESULT_METHODS: Array[String] = [
	"failed", "chosen", "card_for_ticket", "problem",
	"category_label", "ladder_line", "describe",
]

## The eight fields a result carries, in order, and no ninth.
const EXPECTED_RESULT_FIELDS: Array[String] = [
	"ok", "failure_reason", "requested_category", "candidate_ids",
	"candidate_weights", "total_weight", "normalized_ticket", "selected_card_id",
]

# --- The two expected pools, typed independently of the catalogue ---------------
#
# In LADDER ORDER, which is ascending stable id. Not the declaration order of the
# catalogue, and not the presentation order of anything.

const COMBAT_POOL: Array[String] = ["card_celerity", "card_power", "card_vitality"]
const UTILITY_POOL: Array[String] = ["card_fleetness", "card_insight", "card_magnetism"]

## The review weight every shipped card carries, and what three of them sum to.
## Written out rather than read from the catalogue, for the same reason the pools
## are.
const REVIEW_WEIGHT: int = 100
const POOL_TOTAL: int = 300

## How many identical calls must agree before "deterministic" is a measurement.
const REPEAT_CALLS: int = 100

## How many seeds the category-stream demonstration runs over. It is a
## DEMONSTRATION of a stream property, not a proof of a distribution: the
## load-bearing proof is the exhaustive walk above.
const STREAM_SAMPLES: int = 512

## seed, combat card, combat normalized ticket, utility card, utility ticket.
##
## A REGRESSION PIN, TAKEN FROM A RUN OF THIS CODE AND THEN FROZEN. It proves
## the seeded stream cannot move without somebody noticing; it does not, and is
## not asked to, prove the mapping is correct. Negative and 64-bit seeds are in
## the corpus on purpose.
const SEED_CORPUS: Array = [
	[0, "card_vitality", 294, "card_insight", 110],
	[1, "card_vitality", 296, "card_fleetness", 14],
	[3, "card_celerity", 92, "card_fleetness", 72],
	[4, "card_celerity", 25, "card_magnetism", 292],
	[5, "card_power", 182, "card_magnetism", 254],
	[7, "card_vitality", 274, "card_fleetness", 95],
	[42, "card_vitality", 212, "card_insight", 160],
	[12345, "card_power", 173, "card_insight", 105],
	[99991, "card_vitality", 280, "card_insight", 129],
	[2147483647, "card_vitality", 291, "card_magnetism", 207],
	[-1, "card_celerity", 21, "card_insight", 165],
	[-12345, "card_power", 143, "card_fleetness", 10],
	[1000000007, "card_vitality", 242, "card_fleetness", 64],
	[9223372036854775807, "card_celerity", 21, "card_insight", 165],
	## THE FIVE BELOW ARE IN THE CORPUS FOR ONE REASON: each drives the mixer
	## through a multiplication whose exact product EXCEEDS INT64_MAX, which
	## none of the fourteen above does. Godot wraps that product modulo 2^64
	## and the mask recovers the correct low 32 bits — but a regression pin
	## that never reaches the arithmetic it exists to freeze is not freezing
	## it, so these rows and the range assertion beside them cover the path.
	[257, "card_celerity", 48, "card_magnetism", 266],
	[259, "card_celerity", 36, "card_insight", 161],
	[261, "card_vitality", 214, "card_insight", 188],
	[263, "card_celerity", 51, "card_insight", 145],
	[265, "card_celerity", 62, "card_fleetness", 86],
]

## The seeds whose mixing crosses an INT64_MAX product, listed separately so
## the range assertion names the property rather than trusting the corpus to
## still contain one.
const OVERFLOW_CROSSING_SEEDS: Array[int] = [257, 259, 261, 263, 265]

## The widest value a ticket may take, which is also the ladder ceiling.
const TICKET_CEILING: int = 0xFFFFFFFF

## The Foundation C1 and C2 suites, each of which must allow exactly these two
## files to name what they read. Two independently typed copies of one list is
## how they drift.
## Which C1/C2 classes each script names, exactly, in this order.
const READER_CLASS_UNIVERSE: Array[String] = [
	"PassiveCardDefinition", "PlayerStatDefinition", "PlayerStats",
]

const EXPECTED_READER_CLASSES: Array = [
	["res://scripts/stats/passive_card_selection.gd",
		["PassiveCardDefinition", "PlayerStatDefinition"]],
	["res://scripts/stats/passive_card_selection_result.gd",
		["PassiveCardDefinition", "PlayerStatDefinition", "PlayerStats"]],
]

const VOCABULARY_SUITE: String = "res://tests/player_stat_vocabulary_verification.gd"
const RECORDS_SUITE: String = "res://tests/passive_card_records_verification.gd"

const OWED_CHECKS: Array[String] = [
	"the_two_category_pools_hold_in_both_directions",
	"every_ticket_in_a_pool_is_owned_exactly_once",
	"exact_boundaries_wrapping_and_a_refused_negative_ticket",
	"a_heavier_card_owns_more_tickets_on_an_uneven_ladder",
	"input_order_cannot_change_a_result",
	"presentation_names_cannot_change_a_result",
	"every_invalid_case_fails_closed_with_no_partial_result",
	"the_seeded_entry_point_reproduces_a_fixed_corpus",
	"the_selector_is_generic_reads_nothing_ambient_and_is_unwired",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation C3 — Deterministic Passive Card Selection (D-234) ===")

	_check_the_two_category_pools_hold_in_both_directions()
	_check_every_ticket_in_a_pool_is_owned_exactly_once()
	_check_exact_boundaries_wrapping_and_a_refused_negative_ticket()
	_check_a_heavier_card_owns_more_tickets_on_an_uneven_ladder()
	_check_input_order_cannot_change_a_result()
	_check_presentation_names_cannot_change_a_result()
	_check_every_invalid_case_fails_closed_with_no_partial_result()
	_check_the_seeded_entry_point_reproduces_a_fixed_corpus()
	_check_the_selector_is_generic_reads_nothing_ambient_and_is_unwired()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("PASSIVE CARD SELECTION VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("PASSIVE CARD SELECTION VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. Both category pools, in both directions --------------------------------

func _check_the_two_category_pools_hold_in_both_directions() -> void:
	print("")
	print("--- 1. Both category pools hold in BOTH directions")

	## POSITIVE CONTROL FIRST. A selector that refuses everything protects
	## nothing, so the shipped records must be a clean set before any refusal
	## below means anything.
	var shipped: PackedStringArray = PassiveCardCatalogue.problems()
	_expect(shipped.is_empty(), "the shipped catalogue reports: %s" % ", ".join(shipped))

	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var rows: Array = [
		[PlayerStatDefinition.Category.COMBAT_DEFENCE, COMBAT_POOL, UTILITY_POOL,
			"Combat and Defence"],
		[PlayerStatDefinition.Category.UTILITY, UTILITY_POOL, COMBAT_POOL, "Utility"],
	]
	for row: Array in rows:
		var category: int = int(row[0])
		var expected: Array = row[1]
		var other: Array = row[2]
		var label: String = String(row[3])

		var result: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
			cards, category, 0
		)
		_expect(result.ok, "the %s pool refused: %s" % [label, result.failure_reason])
		_expect(result.problem().is_empty(),
			"the %s result is incoherent: %s" % [label, result.problem()])
		_expect(result.requested_category == category,
			"the %s result reports category %d" % [label, result.requested_category])

		## THE LABEL IS DERIVED FROM THE VOCABULARY, and is pinned against a
		## string typed here rather than read back out of the same lookup.
		_expect(PassiveCardSelectionResult.category_label(category) == label,
			"category %d is labelled '%s', not '%s'" % [
				category, PassiveCardSelectionResult.category_label(category), label,
			])

		## DIRECTION ONE: every expected card is on the ladder, in order.
		var actual: PackedStringArray = PackedStringArray()
		for card_id: StringName in result.candidate_ids:
			actual.append(String(card_id))
		var wanted: PackedStringArray = PackedStringArray()
		for card_id: String in expected:
			wanted.append(card_id)
		_expect(", ".join(actual) == ", ".join(wanted),
			"the %s ladder is [%s], not [%s]" % [label, ", ".join(actual), ", ".join(wanted)])

		var missing: PackedStringArray = PackedStringArray()
		for card_id: String in expected:
			if not actual.has(card_id):
				missing.append(card_id)
		_expect(missing.is_empty(), "the %s pool is missing %s" % [label, ", ".join(missing)])

		## DIRECTION TWO: no card from the OTHER category appears. Stated as its
		## own assertion rather than left implied by the exact-order test, so a
		## reader can see the claim being made.
		var intruders: PackedStringArray = PackedStringArray()
		for card_id: String in other:
			if actual.has(card_id):
				intruders.append(card_id)
		_expect(intruders.is_empty(),
			"the %s pool holds the other category's %s" % [label, ", ".join(intruders)])

		## Every card on the ladder really does derive this category from its own
		## canonical stat definition — measured through the record, not through
		## the selector that just filtered on it.
		var misfiled: PackedStringArray = PackedStringArray()
		for card_id: StringName in result.candidate_ids:
			var record: PassiveCardDefinition = PassiveCardCatalogue.record(card_id)
			if record == null or record.category() != category:
				misfiled.append(String(card_id))
		_expect(misfiled.is_empty(),
			"the %s ladder holds cards whose stat says otherwise: %s" % [
				label, ", ".join(misfiled),
			])

		_expect(result.total_weight == POOL_TOTAL,
			"the %s total weight is %d, not %d" % [label, result.total_weight, POOL_TOTAL])
		var uneven: PackedStringArray = PackedStringArray()
		for index: int in result.candidate_weights.size():
			if result.candidate_weights[index] != REVIEW_WEIGHT:
				uneven.append("%s=%d" % [
					result.candidate_ids[index], result.candidate_weights[index],
				])
		_expect(uneven.is_empty(), "the %s ladder is not all %d: %s" % [
			label, REVIEW_WEIGHT, ", ".join(uneven),
		])

	## THE TWO POOLS PARTITION THE CATALOGUE: together they are all six, and they
	## share nothing. Measured rather than assumed, because "three and three"
	## would also be satisfied by one card filed in both.
	var union: Array[String] = []
	for card_id: String in COMBAT_POOL:
		union.append(card_id)
	var overlap: PackedStringArray = PackedStringArray()
	for card_id: String in UTILITY_POOL:
		if union.has(card_id):
			overlap.append(card_id)
		union.append(card_id)
	_expect(overlap.is_empty(), "the two pools share %s" % ", ".join(overlap))
	_expect(union.size() == cards.size(),
		"the two pools hold %d cards against a catalogue of %d" % [union.size(), cards.size()])
	var uncovered: PackedStringArray = PackedStringArray()
	for card: PassiveCardDefinition in cards:
		if not union.has(String(card.card_id)):
			uncovered.append(String(card.card_id))
	_expect(uncovered.is_empty(), "no pool holds %s" % ", ".join(uncovered))

	print("  Combat and Defence [%s] / Utility [%s]; 0 shared, 0 uncovered, %d x%d each"
		% [", ".join(COMBAT_POOL), ", ".join(UTILITY_POOL), cards.size(), REVIEW_WEIGHT])
	_done("the_two_category_pools_hold_in_both_directions")


# --- 2. Every ticket in a pool is owned exactly once ---------------------------

func _check_every_ticket_in_a_pool_is_owned_exactly_once() -> void:
	print("")
	print("--- 2. EVERY ticket from 0 to %d is walked, in both pools" % (POOL_TOTAL - 1))

	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var reported: PackedStringArray = PackedStringArray()
	for row: Array in [
		[PlayerStatDefinition.Category.COMBAT_DEFENCE, COMBAT_POOL, "Combat and Defence"],
		[PlayerStatDefinition.Category.UTILITY, UTILITY_POOL, "Utility"],
	]:
		var category: int = int(row[0])
		var expected: Array = row[1]
		var label: String = String(row[2])

		## Accumulated rather than asserted per ticket: three hundred draws of
		## four assertions each would drown the count without proving more.
		var owners: Dictionary = {}
		var refused: int = 0
		var incoherent: int = 0
		var wrong_ticket: int = 0
		var disagreed: int = 0
		for ticket: int in POOL_TOTAL:
			var result: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
				cards, category, ticket
			)
			if not result.ok:
				refused += 1
				continue
			if not result.problem().is_empty():
				incoherent += 1
			if result.normalized_ticket != ticket:
				wrong_ticket += 1
			## The result's own audit path must agree with the selector's answer.
			if result.card_for_ticket(ticket) != result.selected_card_id:
				disagreed += 1
			owners[String(result.selected_card_id)] = int(
				owners.get(String(result.selected_card_id), 0)
			) + 1

		_expect(refused == 0, "%d of %d %s tickets were refused" % [refused, POOL_TOTAL, label])
		_expect(incoherent == 0, "%d %s results were internally incoherent" % [incoherent, label])
		_expect(wrong_ticket == 0,
			"%d %s results reported a ticket other than the one drawn" % [wrong_ticket, label])
		_expect(disagreed == 0,
			"%d %s results disagreed with their own re-derivation" % [disagreed, label])

		## EXACTLY A HUNDRED EACH, in both directions: every expected card owns
		## a hundred, and no unexpected card owns anything at all.
		var counts: PackedStringArray = PackedStringArray()
		for card_id: String in expected:
			var owned: int = int(owners.get(card_id, 0))
			counts.append("%s=%d" % [card_id, owned])
			_expect(owned == REVIEW_WEIGHT,
				"%s owns %d of the %d %s tickets, not %d" % [
					card_id, owned, POOL_TOTAL, label, REVIEW_WEIGHT,
				])
		var strangers: PackedStringArray = PackedStringArray()
		for card_id: Variant in owners:
			if not expected.has(String(card_id)):
				strangers.append(String(card_id))
		_expect(strangers.is_empty(),
			"the %s walk also selected %s" % [label, ", ".join(strangers)])
		_expect(owners.size() == expected.size(),
			"the %s walk selected %d distinct cards, not %d" % [
				label, owners.size(), expected.size(),
			])
		reported.append("%s: %s" % [label, ", ".join(counts)])

	print("  %s" % " | ".join(reported))
	_done("every_ticket_in_a_pool_is_owned_exactly_once")


# --- 3. Exact boundaries, wrapping, and the refused negative -------------------

func _check_exact_boundaries_wrapping_and_a_refused_negative_ticket() -> void:
	print("")
	print("--- 3. The EXACT boundaries, the wrap, and the refused negative ticket")

	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var combat: int = PlayerStatDefinition.Category.COMBAT_DEFENCE
	var utility: int = PlayerStatDefinition.Category.UTILITY

	## Every boundary of both ladders, typed out rather than computed, so an
	## off-by-one in the walk cannot be reproduced by an off-by-one here.
	var boundaries: Array = [
		[combat, 0, "card_celerity"], [combat, 99, "card_celerity"],
		[combat, 100, "card_power"], [combat, 199, "card_power"],
		[combat, 200, "card_vitality"], [combat, 299, "card_vitality"],
		[utility, 0, "card_fleetness"], [utility, 99, "card_fleetness"],
		[utility, 100, "card_insight"], [utility, 199, "card_insight"],
		[utility, 200, "card_magnetism"], [utility, 299, "card_magnetism"],
	]
	for row: Array in boundaries:
		var result: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
			cards, int(row[0]), int(row[1])
		)
		_expect(result.ok and String(result.selected_card_id) == String(row[2]),
			"ticket %d in category %d selected %s, not %s" % [
				int(row[1]), int(row[0]), result.selected_card_id, row[2],
			])
		_expect(result.normalized_ticket == int(row[1]),
			"ticket %d was reported back as %d" % [int(row[1]), result.normalized_ticket])

	## A ticket at or beyond the total WRAPS by modulo rather than falling off
	## the ladder, and the REDUCED ticket is what is reported — so the number a
	## reviewer checks against the total is always the number that was used.
	var wraps: Array = [
		[300, 0, "card_celerity"],
		[399, 99, "card_celerity"],
		[400, 100, "card_power"],
		[599, 299, "card_vitality"],
		[600, 0, "card_celerity"],
		[12345, 45, "card_celerity"],
		[2147483647, 247, "card_vitality"],
		[9223372036854775807, 7, "card_celerity"],
	]
	for row: Array in wraps:
		var result: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
			cards, combat, int(row[0])
		)
		_expect(result.ok, "the oversized ticket %d was refused: %s" % [
			int(row[0]), result.failure_reason,
		])
		_expect(result.normalized_ticket == int(row[1]),
			"ticket %d reduced to %d, not %d" % [
				int(row[0]), result.normalized_ticket, int(row[1]),
			])
		_expect(String(result.selected_card_id) == String(row[2]),
			"ticket %d selected %s, not %s" % [int(row[0]), result.selected_card_id, row[2]])
		_expect(result.problem().is_empty(),
			"the wrapped result for %d is incoherent: %s" % [int(row[0]), result.problem()])

	## A NEGATIVE TICKET IS REFUSED RATHER THAN FOLDED, which is the convention
	## the project's earlier selector already set. Every refusal names the
	## offending value, echoes the question, and carries no partial selection.
	var refused_negatives: int = 0
	for negative: int in [-1, -100, -300, -12345, -9223372036854775807]:
		var refused: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
			cards, combat, negative
		)
		_refusals += 1
		if not refused.ok:
			refused_negatives += 1
		_expect(not refused.ok, "the negative ticket %d was accepted" % negative)
		_expect(refused.failure_reason.contains("must not be negative"),
			"%d was refused as '%s', which does not name the rule" % [
				negative, refused.failure_reason,
			])
		_expect(refused.failure_reason.contains(str(negative)),
			"the refusal of %d does not quote the ticket: %s" % [
				negative, refused.failure_reason,
			])
		_expect(String(refused.selected_card_id).is_empty()
				and refused.candidate_ids.is_empty()
				and refused.candidate_weights.is_empty()
				and refused.total_weight == 0
				and refused.normalized_ticket == 0,
			"the refusal of %d carries a partial selection" % negative)
		_expect(refused.problem().is_empty(),
			"the refusal of %d is itself incoherent: %s" % [negative, refused.problem()])
		_expect(refused.requested_category == combat,
			"the refusal of %d forgot which category was asked for" % negative)

	## THE SEEDED PATH CAN NEVER REACH THAT REFUSAL, because the stream is masked
	## to 32 bits. Measured across the whole corpus rather than argued.
	var negative_tickets: int = 0
	for row: Array in SEED_CORPUS:
		for category: int in [combat, utility]:
			if PassiveCardSelection.ticket_for(int(row[0]), category) < 0:
				negative_tickets += 1
	_expect(negative_tickets == 0,
		"%d seeded tickets were negative" % negative_tickets)

	print("  0/99 -> first, 100/199 -> second, 200/299 -> third in both pools; "
		+ "300 -> 0, 599 -> 299, 2147483647 -> 247; "
		+ "%d negatives refused, %d seeded negatives" % [refused_negatives, negative_tickets])
	_done("exact_boundaries_wrapping_and_a_refused_negative_ticket")


# --- 4. An uneven ladder ------------------------------------------------------

func _check_a_heavier_card_owns_more_tickets_on_an_uneven_ladder() -> void:
	print("")
	print("--- 4. A heavier card owns MORE tickets, and the ladder is ordered by id")

	## Weights 4, 6 and 5 over a sorted ladder, so every boundary is a distinct
	## number and an off-by-one cannot hide behind a degenerate weight of 1. The
	## shipped six are all equal, which is exactly the arrangement in which a
	## weight bug is invisible.
	##
	## SUPPLIED IN AN ORDER THAT IS NEITHER SORTED NOR WEIGHTED, and with a
	## heavy card in the OTHER category, so its absence from the total is loud
	## rather than subtle.
	var uneven: Array[PassiveCardDefinition] = []
	uneven.append(_card("zz_third", "Gamma", PlayerStats.MAXIMUM_LIFE, 5))
	uneven.append(_card("zz_other", "Delta", PlayerStats.MOVEMENT_SPEED, 1000))
	uneven.append(_card("zz_first", "Alpha", PlayerStats.GLOBAL_DAMAGE, 4))
	uneven.append(_card("zz_second", "Beta", PlayerStats.SKILL_SPEED, 6))

	var combat: int = PlayerStatDefinition.Category.COMBAT_DEFENCE
	var opened: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
		uneven, combat, 0
	)
	_expect(opened.ok, "the uneven ladder refused: %s" % opened.failure_reason)
	_expect(opened.ladder_line() == "zz_first x4, zz_second x6, zz_third x5",
		"the uneven ladder is [%s]" % opened.ladder_line())
	_expect(opened.total_weight == 15, "the uneven total is %d, not 15" % opened.total_weight)

	var boundaries: Array = [
		[0, "zz_first"], [3, "zz_first"],
		[4, "zz_second"], [9, "zz_second"],
		[10, "zz_third"], [14, "zz_third"],
	]
	for row: Array in boundaries:
		var result: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
			uneven, combat, int(row[0])
		)
		_expect(result.ok and String(result.selected_card_id) == String(row[1]),
			"uneven ticket %d selected %s, not %s" % [
				int(row[0]), result.selected_card_id, row[1],
			])

	var wrapped: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
		uneven, combat, 15
	)
	_expect(wrapped.ok and String(wrapped.selected_card_id) == "zz_first"
			and wrapped.normalized_ticket == 0,
		"a ticket equal to the uneven total selected %s at %d" % [
			wrapped.selected_card_id, wrapped.normalized_ticket,
		])

	var owners: Dictionary = {}
	var incoherent: int = 0
	for ticket: int in 15:
		var result: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
			uneven, combat, ticket
		)
		if not result.problem().is_empty():
			incoherent += 1
		owners[String(result.selected_card_id)] = int(
			owners.get(String(result.selected_card_id), 0)
		) + 1
	_expect(incoherent == 0, "%d uneven results were incoherent" % incoherent)
	_expect(int(owners.get("zz_first", 0)) == 4 and int(owners.get("zz_second", 0)) == 6
			and int(owners.get("zz_third", 0)) == 5,
		"the uneven ownership is %s, not 4 / 6 / 5" % owners)
	_expect(int(owners.get("zz_second", 0)) > int(owners.get("zz_third", 0))
			and int(owners.get("zz_third", 0)) > int(owners.get("zz_first", 0)),
		"a heavier card did not own more tickets: %s" % owners)

	## THE OTHER CATEGORY'S HEAVY CARD IS ABSENT FROM THIS LADDER ENTIRELY — not
	## merely unselected. A weight of 1000 in a total of 15 would be impossible
	## to miss if it had leaked in.
	_expect(not opened.candidate_ids.has(&"zz_other"),
		"the other category's card is on the combat ladder")
	_expect(int(owners.get("zz_other", 0)) == 0,
		"the other category's card won %d tickets" % int(owners.get("zz_other", 0)))

	## And it is present and alone in ITS OWN ladder, so its absence above is a
	## filter working rather than a record quietly missing.
	var other: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
		uneven, PlayerStatDefinition.Category.UTILITY, 0
	)
	_expect(other.ok and other.ladder_line() == "zz_other x1000",
		"the utility ladder is [%s]" % other.ladder_line())

	print("  0/3 -> first, 4/9 -> second, 10/14 -> third; 15 wraps to 0; "
		+ "ownership 4 / 6 / 5; a 1000-weight card in the other lane contributes 0")
	_done("a_heavier_card_owns_more_tickets_on_an_uneven_ladder")


# --- 5. Input order changes nothing -------------------------------------------

func _check_input_order_cannot_change_a_result() -> void:
	print("")
	print("--- 5. The order the records arrive in cannot change a single result")

	var canonical: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var reversed_order: Array[PassiveCardDefinition] = _reversed(canonical)
	var rotated: Array[PassiveCardDefinition] = _rotated(canonical, 2)
	var interleaved: Array[PassiveCardDefinition] = _interleaved(canonical)

	## The permutations are proved to BE permutations, and to actually differ
	## from the canonical order. A reordering test over an order that did not
	## move proves nothing at all.
	for row: Array in [
		[reversed_order, "reversed"], [rotated, "rotated"], [interleaved, "interleaved"],
	]:
		var permuted: Array[PassiveCardDefinition] = row[0]
		var label: String = String(row[1])
		_expect(permuted.size() == canonical.size(),
			"the %s order holds %d records, not %d" % [
				label, permuted.size(), canonical.size(),
			])
		_expect(_ids_of(permuted) != _ids_of(canonical),
			"the %s order is identical to the canonical one" % label)
		_expect(_sorted_ids_of(permuted) == _sorted_ids_of(canonical),
			"the %s order is not a permutation of the same records" % label)

	var mismatched: int = 0
	var compared: int = 0
	for category: int in [
		PlayerStatDefinition.Category.COMBAT_DEFENCE, PlayerStatDefinition.Category.UTILITY,
	]:
		for ticket: int in POOL_TOTAL:
			var reference: String = _derivation(
				PassiveCardSelection.select_with_ticket(canonical, category, ticket)
			)
			for permuted: Array[PassiveCardDefinition] in [
				reversed_order, rotated, interleaved,
			]:
				compared += 1
				if _derivation(
					PassiveCardSelection.select_with_ticket(permuted, category, ticket)
				) != reference:
					mismatched += 1
	_expect(mismatched == 0,
		"%d of %d reordered draws disagreed with the canonical order" % [mismatched, compared])
	_expect(compared == POOL_TOTAL * 2 * 3,
		"only %d reordered draws were compared" % compared)

	## And the seeded path agrees too, over the whole corpus.
	var seeded_mismatches: int = 0
	for row: Array in SEED_CORPUS:
		for category: int in [
			PlayerStatDefinition.Category.COMBAT_DEFENCE, PlayerStatDefinition.Category.UTILITY,
		]:
			var reference: String = _derivation(
				PassiveCardSelection.select(canonical, category, int(row[0]))
			)
			if _derivation(
				PassiveCardSelection.select(reversed_order, category, int(row[0]))
			) != reference:
				seeded_mismatches += 1
	_expect(seeded_mismatches == 0,
		"%d seeded draws moved when the records were reversed" % seeded_mismatches)

	print("  %d draws over 3 permutations and %d seeded draws are bit-identical to the canonical order"
		% [compared, SEED_CORPUS.size() * 2])
	_done("input_order_cannot_change_a_result")


# --- 6. Presentation names change nothing --------------------------------------

func _check_presentation_names_cannot_change_a_result() -> void:
	print("")
	print("--- 6. A presentation name cannot reach the mechanism")

	var canonical: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()

	## EVERY name replaced with a different, still-legal one. Legal matters: an
	## empty name is refused by the record contract, so a test that blanked them
	## would be measuring the refusal rather than the blindness.
	var renamed: Array[PassiveCardDefinition] = []
	var index: int = 0
	for card: PassiveCardDefinition in canonical:
		renamed.append(PassiveCardDefinition.of(
			card.card_id, "Renamed %d" % index, card.stat_id,
			card.magnitude, card.base_weight, card.repeatable
		))
		index += 1

	## AND a set in which two names are SWAPPED between cards. A selector that
	## sorted or compared on the name would move here even though every id,
	## stat, magnitude and weight is untouched.
	var swapped: Array[PassiveCardDefinition] = []
	var names: Dictionary = {}
	for card: PassiveCardDefinition in canonical:
		names[String(card.card_id)] = card.display_name
	for card: PassiveCardDefinition in canonical:
		var name_for: String = card.display_name
		if String(card.card_id) == "card_power":
			name_for = String(names.get("card_vitality", ""))
		elif String(card.card_id) == "card_vitality":
			name_for = String(names.get("card_power", ""))
		swapped.append(PassiveCardDefinition.of(
			card.card_id, name_for, card.stat_id,
			card.magnitude, card.base_weight, card.repeatable
		))

	var changed_names: int = 0
	for position: int in canonical.size():
		if renamed[position].display_name != canonical[position].display_name:
			changed_names += 1
	_expect(changed_names == canonical.size(),
		"only %d of %d names were actually changed" % [changed_names, canonical.size()])
	_expect(swapped[0].display_name != canonical[0].display_name
			or swapped[2].display_name != canonical[2].display_name,
		"the swapped set did not actually swap two names")

	var moved: int = 0
	var compared: int = 0
	for category: int in [
		PlayerStatDefinition.Category.COMBAT_DEFENCE, PlayerStatDefinition.Category.UTILITY,
	]:
		for ticket: int in POOL_TOTAL:
			var reference: String = _derivation(
				PassiveCardSelection.select_with_ticket(canonical, category, ticket)
			)
			for altered: Array[PassiveCardDefinition] in [renamed, swapped]:
				compared += 1
				if _derivation(
					PassiveCardSelection.select_with_ticket(altered, category, ticket)
				) != reference:
					moved += 1
	_expect(moved == 0, "%d of %d renamed draws moved" % [moved, compared])

	## THE SCAN THE BEHAVIOUR CANNOT GIVE. A name read for a purpose that happens
	## not to matter today would pass every draw above, so the two files are also
	## scanned for the field itself.
	var naming: PackedStringArray = PackedStringArray()
	for path: String in SELECTION_FILES:
		if FileAccess.get_file_as_string(path).contains(NAME_FIELD_TOKEN):
			naming.append(path.get_file())
	_expect(naming.is_empty(), "%s reads %s" % [", ".join(naming), NAME_FIELD_TOKEN])

	## The scan is proved capable of failing by finding the field in the record
	## that legitimately declares it.
	_expect(FileAccess.get_file_as_string(
			"res://scripts/stats/passive_card_definition.gd").contains(NAME_FIELD_TOKEN),
		"the %s scan cannot find the field in the record that declares it" % NAME_FIELD_TOKEN)

	print("  %d draws over a fully renamed set and a name-swapped set are bit-identical; "
		% compared + "neither script names %s" % NAME_FIELD_TOKEN)
	_done("presentation_names_cannot_change_a_result")


# --- 7. Every invalid case fails closed ----------------------------------------

func _check_every_invalid_case_fails_closed_with_no_partial_result() -> void:
	print("")
	print("--- 7. Every invalid case refuses the WHOLE selection, with no partial result")

	var combat: int = PlayerStatDefinition.Category.COMBAT_DEFENCE
	var utility: int = PlayerStatDefinition.Category.UTILITY
	var shipped: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()

	## POSITIVE CONTROL. A selector that refuses everything protects nothing.
	var accepted: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
		shipped, combat, 0
	)
	_expect(accepted.ok and accepted.problem().is_empty(),
		"the valid control was refused: %s" % accepted.failure_reason)

	## A DEFAULT-CONSTRUCTED RESULT IS NOT A USABLE ONE. This is what closes the
	## sentinel collision the result records: `requested_category` cannot separate
	## "asked for -1" from "nothing was asked for", and this is why that is
	## unreachable — an object nobody constructed through `failed()` carries no
	## reason and is refused outright.
	var unbuilt: PassiveCardSelectionResult = PassiveCardSelectionResult.new()
	_expect(unbuilt.requested_category == PassiveCardSelectionResult.UNRESOLVED_CATEGORY,
		"a default result reports category %d" % unbuilt.requested_category)
	_expect(not unbuilt.problem().is_empty(),
		"a default-constructed result passed its own coherence test")
	var asked_for_sentinel: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
		shipped, PassiveCardSelectionResult.UNRESOLVED_CATEGORY, 0
	)
	_expect(not asked_for_sentinel.ok and not asked_for_sentinel.failure_reason.is_empty()
			and asked_for_sentinel.problem().is_empty(),
		"asking for the sentinel category did not produce a coherent refusal")

	var empty: Array[PassiveCardDefinition] = []
	_expect_refusal(empty, combat, 0, "no passive card records were given", "an empty record set")

	var holds_null: Array[PassiveCardDefinition] = [null]
	_expect_refusal(holds_null, combat, 0, "record is null", "a record set holding null")

	## Each of the record contract's own refusals reaches the selector whole,
	## rather than being repaired, skipped or reworded on the way through.
	var faulty: Array = [
		[_card("", "Nameless", PlayerStats.GLOBAL_DAMAGE, 100), "must carry a stable id",
			"a record with no id"],
		[_card("card power", "Spaced", PlayerStats.GLOBAL_DAMAGE, 100), "lower_snake_case",
			"a record with an illegal id"],
		[PassiveCardDefinition.of(&"zz_zero", "Zero", PlayerStats.GLOBAL_DAMAGE, 0.0, 100, false),
			"is not positive", "a record with a zero magnitude"],
		[PassiveCardDefinition.of(&"zz_light", "Light", PlayerStats.GLOBAL_DAMAGE, 0.10, 0, false),
			"below the minimum", "a record with a zero base weight"],
		[_card("zz_stray", "Stray", &"not_a_stat", 100), "not a recognised player stat",
			"a record naming an unknown stat"],
	]
	for row: Array in faulty:
		var polluted: Array[PassiveCardDefinition] = shipped.duplicate()
		polluted.append(row[0])
		_expect_refusal(polluted, combat, 0, String(row[1]), String(row[2]))

	## THE CASE THIS FOUNDATION EXISTS TO GET RIGHT: a malformed record in the
	## category NOBODY ASKED FOR still refuses the entire selection. Skipping it
	## would silently remove a card from a lane that is never drawn until it is.
	## THE FAULT IS APPLIED TO THE UTILITY CARD THAT IS ALREADY THERE rather
	## than by substituting a different one, so the set stays six records with
	## six distinct ids and the refusal cannot be a duplicate wearing another
	## fault's clothing.
	var utility_faults: Array = [
		["weight", "below the minimum", "a zero-weight UTILITY card, with combat requested"],
		["id", "lower_snake_case", "an illegally named UTILITY card, with combat requested"],
		["magnitude", "is not positive",
			"a negative-magnitude UTILITY card, with combat requested"],
	]
	for row: Array in utility_faults:
		var broken: Array[PassiveCardDefinition] = []
		var replaced: bool = false
		for card: PassiveCardDefinition in shipped:
			if card.category() == utility and not replaced:
				replaced = true
				broken.append(_faulted(card, String(row[0])))
			else:
				broken.append(card)
		_expect(replaced, "%s found no utility card to break" % String(row[2]))
		## The set really does still hold three healthy combat cards, so the
		## refusal below cannot be explained by the requested lane being broken.
		var healthy_combat: int = 0
		for card: PassiveCardDefinition in broken:
			if card.problem().is_empty() and card.category() == combat:
				healthy_combat += 1
		_expect(healthy_combat == COMBAT_POOL.size(),
			"%s left only %d healthy combat cards" % [String(row[2]), healthy_combat])
		_expect_refusal(broken, combat, 0, String(row[1]), String(row[2]))

	## DUPLICATES. Both shapes: two different records sharing an id, and the very
	## same record supplied twice — the second is the one a sort-then-validate
	## implementation would silently swallow.
	var twinned: Array[PassiveCardDefinition] = shipped.duplicate()
	twinned.append(_card("card_power", "Impostor", PlayerStats.MAXIMUM_LIFE, 100))
	_expect_refusal(twinned, combat, 0, "duplicate card id", "two records sharing an id")

	var doubled: Array[PassiveCardDefinition] = shipped.duplicate()
	doubled.append(shipped[0])
	_expect_refusal(doubled, combat, 0, "duplicate card id", "the same record supplied twice")

	## AN UNRECOGNISED CATEGORY. The parameter is an int precisely so this branch
	## can be driven, and the refusal echoes the value it was asked about.
	for stray: int in [2, 7, 99, -1, -7]:
		var refused: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
			shipped, stray, 0
		)
		_refusals += 1
		_expect(not refused.ok, "the unrecognised category %d was accepted" % stray)
		_expect(refused.failure_reason.contains("not a recognised passive card category"),
			"category %d was refused as '%s'" % [stray, refused.failure_reason])
		_expect(refused.requested_category == stray,
			"the refusal of category %d reports category %d" % [
				stray, refused.requested_category,
			])
		_expect(refused.problem().is_empty(),
			"the refusal of category %d is itself incoherent: %s" % [stray, refused.problem()])
		_expect(String(refused.selected_card_id).is_empty()
				and refused.candidate_ids.is_empty() and refused.total_weight == 0,
			"the refusal of category %d carries a partial selection" % stray)

	## AN EMPTY MATCHING CATEGORY. The set is valid, the category is recognised,
	## and nothing in it belongs to that category.
	var utility_only: Array[PassiveCardDefinition] = []
	for card: PassiveCardDefinition in shipped:
		if card.category() == utility:
			utility_only.append(card)
	_expect(utility_only.size() == UTILITY_POOL.size(),
		"the utility-only set holds %d cards" % utility_only.size())
	_expect_refusal(utility_only, combat, 0,
		"no supplied passive card belongs to the Combat and Defence category",
		"a set with nothing in the requested category")
	var still_works: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
		utility_only, utility, 0
	)
	_expect(still_works.ok,
		"the utility-only set refused its OWN category: %s" % still_works.failure_reason)

	## THE WEIGHT CEILING, DRIVEN IN BOTH DIRECTIONS. It was written as the file's
	## only overflow guard and, until this check existed, NOTHING REACHED IT — a
	## guard nothing can reach is not a guard. The ceiling is the seeded stream's
	## own width, so a ladder that exceeded it would put candidates beyond any
	## ticket a seed can produce, silently and with no symptom.
	var ceiling: int = PassiveCardSelection.MAXIMUM_TOTAL_WEIGHT
	_expect(ceiling == TICKET_CEILING,
		"the ladder ceiling is %d, not the stream's own width %d" % [ceiling, TICKET_CEILING])

	## EXACTLY AT the ceiling is accepted, so the refusal below is an off-by-one
	## away from a legal ladder rather than a comfortable distance from one.
	var at_ceiling: Array[PassiveCardDefinition] = []
	at_ceiling.append(_card("zz_heavy_one", "Heavy One", PlayerStats.GLOBAL_DAMAGE, 4_000_000_000))
	at_ceiling.append(_card("zz_heavy_two", "Heavy Two", PlayerStats.MAXIMUM_LIFE, ceiling - 4_000_000_000))
	var accepted_ladder: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
		at_ceiling, combat, 0
	)
	_expect(accepted_ladder.ok, "a ladder totalling exactly the ceiling was refused: %s"
		% accepted_ladder.failure_reason)
	_expect(accepted_ladder.total_weight == ceiling,
		"the at-ceiling ladder totals %d, not %d" % [accepted_ladder.total_weight, ceiling])
	_expect(accepted_ladder.problem().is_empty(),
		"the at-ceiling result is incoherent: %s" % accepted_ladder.problem())

	var over_ceiling: Array[PassiveCardDefinition] = []
	over_ceiling.append(_card("zz_heavy_one", "Heavy One", PlayerStats.GLOBAL_DAMAGE, 4_000_000_000))
	over_ceiling.append(_card("zz_heavy_two", "Heavy Two", PlayerStats.MAXIMUM_LIFE, ceiling - 3_999_999_999))
	_expect_refusal(over_ceiling, combat, 0, "would exceed the ceiling",
		"a ladder one weight past the ceiling")

	## THE ORDER OF THE REFUSALS IS PART OF THE CONTRACT: a broken record and a
	## bad category together report the RECORD, because the whole set is
	## validated before anything looks at a category.
	var both_wrong: Array[PassiveCardDefinition] = shipped.duplicate()
	both_wrong.append(_card("zz_stray", "Stray", &"not_a_stat", 100))
	var precedence: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
		both_wrong, 99, 0
	)
	_expect(not precedence.ok, "a broken record with a bad category was accepted")
	_expect(precedence.failure_reason.contains("not a recognised player stat"),
		"a broken record with a bad category reported '%s' instead of the record"
			% precedence.failure_reason)

	print("  %d refusals, each naming its fault and carrying no partial result; "
		% _refusals + "a fault in the OTHER lane still refuses the whole selection")
	_done("every_invalid_case_fails_closed_with_no_partial_result")


# --- 8. The seeded entry point -------------------------------------------------

func _check_the_seeded_entry_point_reproduces_a_fixed_corpus() -> void:
	print("")
	print("--- 8. The seeded entry point reproduces a FIXED corpus exactly")

	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var combat: int = PlayerStatDefinition.Category.COMBAT_DEFENCE
	var utility: int = PlayerStatDefinition.Category.UTILITY

	var reached: Dictionary = {}
	var wrong: int = 0
	var undelegated: int = 0
	for row: Array in SEED_CORPUS:
		var seed_value: int = int(row[0])
		var pairs: Array = [
			[combat, String(row[1]), int(row[2])],
			[utility, String(row[3]), int(row[4])],
		]
		for pair: Array in pairs:
			var category: int = int(pair[0])
			var result: PassiveCardSelectionResult = PassiveCardSelection.select(
				cards, category, seed_value
			)
			if not result.ok or String(result.selected_card_id) != String(pair[1]) \
					or result.normalized_ticket != int(pair[2]):
				wrong += 1
				_expect(false, "seed %d in category %d gave %s@%d, not %s@%d" % [
					seed_value, category, result.selected_card_id,
					result.normalized_ticket, pair[1], int(pair[2]),
				])
			reached[String(result.selected_card_id)] = true

			## THE SEEDED ENTRY POINT IS A CONVENIENCE OVER THE CORE, and that is
			## proved rather than promised: it must agree with the core called
			## directly with the ticket the stream produced.
			if _derivation(result) != _derivation(PassiveCardSelection.select_with_ticket(
					cards, category, PassiveCardSelection.ticket_for(seed_value, category))):
				undelegated += 1
	_expect(wrong == 0, "%d corpus rows disagreed" % wrong)
	_expect(undelegated == 0,
		"%d seeded results disagreed with the pure core called on their own ticket"
			% undelegated)

	## THE CORPUS IS NOT DEGENERATE. All six cards are reached, so a stream stuck
	## on one answer would fail here rather than pass quietly.
	_expect(reached.size() == COMBAT_POOL.size() + UTILITY_POOL.size(),
		"the corpus reaches %d distinct cards, not %d" % [
			reached.size(), COMBAT_POOL.size() + UTILITY_POOL.size(),
		])

	## REPRODUCIBLE, MEASURED. Identical calls, then records rebuilt from scratch
	## — so the reproduction is a property of the seed rather than of these
	## particular objects.
	var first: String = _derivation(PassiveCardSelection.select(cards, combat, 12345))
	var drifted: int = 0
	for _call: int in REPEAT_CALLS:
		if _derivation(PassiveCardSelection.select(cards, combat, 12345)) != first:
			drifted += 1
	_expect(drifted == 0, "%d of %d identical seeded calls disagreed" % [drifted, REPEAT_CALLS])
	_expect(_derivation(PassiveCardSelection.select(
			PassiveCardCatalogue.records(), combat, 12345)) == first,
		"rebuilt records produced a different seeded result")

	## AN HONEST LIMIT, ASSERTED RATHER THAN LEFT TO BE DISCOVERED: the stream
	## reads only the low 32 bits of a seed, so two seeds sharing them agree.
	_expect(PassiveCardSelection.ticket_for(-1, combat)
			== PassiveCardSelection.ticket_for(9223372036854775807, combat),
		"two seeds sharing their low 32 bits produced different tickets")

	## THE MIXER'S ARITHMETIC IS EXERCISED WHERE IT ACTUALLY OVERFLOWS. Each of
	## these seeds drives a multiplication whose exact product exceeds INT64_MAX;
	## Godot wraps it modulo 2^64 and the mask recovers the correct low 32 bits, so
	## every ticket must still land inside [0, ceiling]. Without these rows the
	## corpus never reached that path at all — measured, not assumed.
	var out_of_range: PackedStringArray = PackedStringArray()
	for seed_value: int in OVERFLOW_CROSSING_SEEDS:
		for category: int in [combat, utility]:
			var produced: int = PassiveCardSelection.ticket_for(seed_value, category)
			if produced < 0 or produced > TICKET_CEILING:
				out_of_range.append("seed %d category %d gave %d" % [
					seed_value, category, produced,
				])
	_expect(out_of_range.is_empty(),
		"a mixed ticket left [0, %d]: %s" % [TICKET_CEILING, ", ".join(out_of_range)])
	var covered_overflow: int = 0
	for row: Array in SEED_CORPUS:
		if OVERFLOW_CROSSING_SEEDS.has(int(row[0])):
			covered_overflow += 1
	_expect(covered_overflow == OVERFLOW_CROSSING_SEEDS.size(),
		"the corpus pins only %d of the %d overflow-crossing seeds" % [
			covered_overflow, OVERFLOW_CROSSING_SEEDS.size(),
		])

	## THE CATEGORY-SALTED STREAM, DEMONSTRATED RATHER THAN ARGUED. If one ticket
	## served both lanes, the SAME ORDINAL would be chosen in each for every
	## seed, because both ladders are the same length — measured here at all of
	## them. Salting by category removes that. This is a demonstration of a
	## stream property; the load-bearing proof of ownership is the exhaustive
	## walk, which uses no seed at all.
	var shared_matches: int = 0
	var salted_matches: int = 0
	for offset: int in STREAM_SAMPLES:
		var seed_value: int = 5000 + offset
		var one_ticket: int = PassiveCardSelection.ticket_for(seed_value, combat)
		var shared_a: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
			cards, combat, one_ticket)
		var shared_b: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
			cards, utility, one_ticket)
		if shared_a.candidate_ids.find(shared_a.selected_card_id) \
				== shared_b.candidate_ids.find(shared_b.selected_card_id):
			shared_matches += 1
		var salted_a: PassiveCardSelectionResult = PassiveCardSelection.select(
			cards, combat, seed_value)
		var salted_b: PassiveCardSelectionResult = PassiveCardSelection.select(
			cards, utility, seed_value)
		if salted_a.candidate_ids.find(salted_a.selected_card_id) \
				== salted_b.candidate_ids.find(salted_b.selected_card_id):
			salted_matches += 1
	_expect(shared_matches == STREAM_SAMPLES,
		"a single shared ticket matched ordinals in only %d of %d seeds, so the "
			% [shared_matches, STREAM_SAMPLES]
			+ "correlation this salt removes is not what was measured")
	_expect(salted_matches < STREAM_SAMPLES,
		"the category-salted streams still match ordinals in every one of %d seeds"
			% STREAM_SAMPLES)

	print("  %d corpus rows exact over 2 categories; %d of 6 cards reached; %d of %d repeats agree; "
		% [SEED_CORPUS.size(), reached.size(), REPEAT_CALLS - drifted, REPEAT_CALLS]
		+ "one shared ticket matches ordinals %d of %d, the salted streams %d of %d"
			% [shared_matches, STREAM_SAMPLES, salted_matches, STREAM_SAMPLES])
	_done("the_seeded_entry_point_reproduces_a_fixed_corpus")


# --- 9. Generic, ambient-free, and unwired ------------------------------------

func _check_the_selector_is_generic_reads_nothing_ambient_and_is_unwired() -> void:
	print("")
	print("--- 9. The two scripts name nothing concrete, read nothing ambient, run nowhere")

	var scanned: int = 0
	var forbidden_total: int = 0
	var ambient_total: int = 0
	for path: String in SELECTION_FILES:
		if not FileAccess.file_exists(path):
			_expect(false, "%s is missing" % path)
			continue
		## RAW, comments included.
		var source: String = FileAccess.get_file_as_string(path)
		var named: PackedStringArray = PackedStringArray()
		for token: String in FORBIDDEN_TOKENS:
			if source.contains(token):
				named.append(token)
		forbidden_total += named.size()
		_expect(named.is_empty(), "%s names %s" % [path.get_file(), ", ".join(named)])
		var ambient: PackedStringArray = PackedStringArray()
		for token: String in AMBIENT_TOKENS:
			if source.contains(token):
				ambient.append(token)
		ambient_total += ambient.size()
		_expect(ambient.is_empty(),
			"%s reads ambient state: %s" % [path.get_file(), ", ".join(ambient)])
		scanned += 1
	_expect(scanned == SELECTION_FILES.size(),
		"%d of %d selection scripts were scanned" % [scanned, SELECTION_FILES.size()])

	## THE SCANS ARE PROVED CAPABLE OF FAILING, by showing them finding their own
	## tokens in the one file that legitimately holds them: this one.
	var own: String = FileAccess.get_file_as_string(
		"res://tests/passive_card_selection_verification.gd")
	var found_here: int = 0
	for token: String in FORBIDDEN_TOKENS:
		if own.contains(token):
			found_here += 1
	_expect(found_here >= 10,
		"the forbidden-token scan found only %d of its own tokens and may be inert" % found_here)
	var ambient_here: int = 0
	for token: String in AMBIENT_TOKENS:
		if own.contains(token):
			ambient_here += 1
	_expect(ambient_here >= 3,
		"the ambient scan found only %d of its own tokens and may be inert" % ambient_here)

	## AN ALLOWLIST, NOT ONLY A DENYLIST. The token lists above can only refuse
	## names somebody remembered to add; this asks the ENGINE which project
	## classes exist and requires that the two scripts name none of them but the
	## five they are entitled to.
	var project_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var class_id: String = String(entry.get("class", ""))
		if not class_id.is_empty() and not AUTHORIZED_CLASSES.has(class_id):
			project_classes.append(class_id)
	_expect(project_classes.size() > 20,
		"only %d project classes were enumerated; the allowlist may be inert"
			% project_classes.size())
	_expect(project_classes.has("PassiveCardCatalogue"),
		"the catalogue is not among the classes this allowlist refuses, "
			+ "so its absence is unproved")
	for path: String in SELECTION_FILES:
		var source: String = FileAccess.get_file_as_string(path)
		var outside: PackedStringArray = PackedStringArray()
		for class_id: String in project_classes:
			if source.contains(class_id):
				outside.append(class_id)
		_expect(outside.is_empty(),
			"%s names the unauthorized project class(es) %s" % [
				path.get_file(), ", ".join(outside),
			])

	## THE PROOF A TOKEN SCAN CANNOT GIVE. An offer generator, an acquisition
	## step, a stacking rule or a pity counter need name nothing forbidden at
	## all — it arrives as an extra method with a plausible name. So both
	## scripts' methods are enumerated from the engine and pinned BY NAME.
	var selector_methods: PackedStringArray = _methods_of(
		"res://scripts/stats/passive_card_selection.gd")
	_expect(", ".join(selector_methods) == ", ".join(EXPECTED_SELECTOR_METHODS),
		"the selector declares: %s" % ", ".join(selector_methods))
	var result_methods: PackedStringArray = _methods_of(
		"res://scripts/stats/passive_card_selection_result.gd")
	_expect(", ".join(result_methods) == ", ".join(EXPECTED_RESULT_METHODS),
		"the result declares: %s" % ", ".join(result_methods))

	var result_fields: PackedStringArray = PackedStringArray()
	for entry: Dictionary in PassiveCardSelectionResult.new().get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			result_fields.append(String(entry.get("name", "")))
	_expect(", ".join(result_fields) == ", ".join(EXPECTED_RESULT_FIELDS),
		"a result carries the fields: %s" % ", ".join(result_fields))

	## THE SELECTOR CARRIES NO STATE AT ALL, which is what makes "no pity
	## counter, no memory of the last draw, no cache" a property of the file
	## rather than a promise in its header.
	var selector_fields: PackedStringArray = PackedStringArray()
	for entry: Dictionary in PassiveCardSelection.new().get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			selector_fields.append(String(entry.get("name", "")))
	_expect(selector_fields.is_empty(),
		"the selector carries the instance field(s) %s" % ", ".join(selector_fields))

	## NOTHING REFERENCES IT. There is no offer, no acquisition and no runtime
	## application, so no file that runs may name either class.
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if SELECTION_FILES.has(path):
				continue
			project_files += 1
			var source: String = FileAccess.get_file_as_string(path)
			for name: String in SELECTION_CLASSES:
				if not source.contains(name):
					continue
				if _is_authorized_reader(path, name):
					continue
				referenced.append("%s names %s" % [path.get_file(), name])
	## AND THE ONE FILE THAT CAN LOAD A CLASS WITHOUT ANY SCRIPT NAMING IT. An
	## `[autoload]` entry would make this class part of every run while a scan of
	## script text reported nothing at all.
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for name: String in SELECTION_CLASSES:
		if settings.contains(name):
			referenced.append("project.godot names %s" % name)
	_expect(not settings.contains("[autoload]"),
		"project.godot declares an [autoload] section")
	_expect(referenced.is_empty(),
		"Foundation C3 is referenced by code that runs: %s" % ", ".join(referenced))
	_expect(project_files > 100, "only %d project files were scanned" % project_files)
	## The addons root is really being reached, so widening SCANNED_ROOTS is not a
	## constant that quietly resolves to nothing.
	_expect(_files_under("res://addons", [".gd"]).size() > 0,
		"the addons root was scanned and held no script, so widening the scan proved nothing")

	## THE EXEMPTIONS THE C1 AND C2 SUITES GRANT THESE TWO FILES ARE EARNED, AND
	## THE LISTS AGREE. Each of those suites proves that nothing names its
	## classes except an authorized reader; if these two stopped naming them,
	## those exemptions would quietly become claims about nothing while still
	## passing.
	for row: Array in [
		[VOCABULARY_SUITE, ["PlayerStats", "PlayerStatDefinition"], "C1"],
		[RECORDS_SUITE, ["PassiveCardDefinition"], "C2"],
	]:
		var suite_source: String = FileAccess.get_file_as_string(String(row[0]))
		var listed: int = 0
		for path: String in SELECTION_FILES:
			if suite_source.contains(path):
				listed += 1
		_expect(listed == SELECTION_FILES.size(),
			"the Foundation %s suite authorizes %d of these %d scripts by path" % [
				String(row[2]), listed, SELECTION_FILES.size(),
			])
		var unearned: PackedStringArray = PackedStringArray()
		for path: String in SELECTION_FILES:
			var source: String = FileAccess.get_file_as_string(path)
			var names_one: bool = false
			for class_id: String in row[1]:
				if source.contains(class_id):
					names_one = true
			if not names_one:
				unearned.append(path.get_file())
		_expect(unearned.is_empty(),
			"%s name no Foundation %s class, so their exemption is unearned" % [
				", ".join(unearned), String(row[2]),
			])

	## AND THE EXACT SET, PER FILE, BECAUSE THE TEST ABOVE IS OR-SHAPED. "At least
	## one authorized class" is satisfied while a grant covering a SECOND class
	## quietly protects nothing. Pinning which classes each file actually names
	## turns that into a statement: the selector names the record type and the stat
	## definition and NOT the vocabulary object, and the result names all three.
	for row: Array in EXPECTED_READER_CLASSES:
		var path: String = String(row[0])
		var expected_named: Array = row[1]
		var source: String = FileAccess.get_file_as_string(path)
		var actually_named: PackedStringArray = PackedStringArray()
		for class_id: String in READER_CLASS_UNIVERSE:
			if source.contains(class_id):
				actually_named.append(class_id)
		var wanted_named: PackedStringArray = PackedStringArray()
		for class_id: String in expected_named:
			wanted_named.append(class_id)
		_expect(", ".join(actually_named) == ", ".join(wanted_named),
			"%s names [%s], not [%s]" % [
				path.get_file(), ", ".join(actually_named), ", ".join(wanted_named),
			])

	## Determinism at the file level, measured rather than argued.
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var first: String = _derivation(PassiveCardSelection.select_with_ticket(
		cards, PlayerStatDefinition.Category.UTILITY, 137))
	var drifted: int = 0
	for _call: int in REPEAT_CALLS:
		if _derivation(PassiveCardSelection.select_with_ticket(
				cards, PlayerStatDefinition.Category.UTILITY, 137)) != first:
			drifted += 1
	_expect(drifted == 0, "%d of %d identical draws disagreed" % [drifted, REPEAT_CALLS])

	print("  %d scripts scanned raw: %d forbidden tokens, %d ambient reads; "
		% [scanned, forbidden_total, ambient_total]
		+ "%d methods and %d fields pinned, 0 selector state; " % [
			selector_methods.size() + result_methods.size(), result_fields.size(),
		]
		+ "%d project files name no Foundation C3 class; %d of %d identical draws disagree"
			% [project_files, drifted, REPEAT_CALLS])
	_done("the_selector_is_generic_reads_nothing_ambient_and_is_unwired")


# --- Helpers -------------------------------------------------------------------

## A fabricated card. Test data only: it is in no catalogue, no scene and no
## `.tres`, and it is not canon.
func _card(card_id: String, display: String, stat_id: StringName,
		weight: int) -> PassiveCardDefinition:
	return PassiveCardDefinition.of(
		StringName(card_id), display, stat_id, 0.10, weight, false
	)


## The same card with exactly one fault introduced, so a refusal cannot be
## explained by anything else about it having changed.
func _faulted(card: PassiveCardDefinition, kind: String) -> PassiveCardDefinition:
	match kind:
		"weight":
			return PassiveCardDefinition.of(card.card_id, card.display_name, card.stat_id,
				card.magnitude, 0, card.repeatable)
		"id":
			return PassiveCardDefinition.of(
				StringName(String(card.card_id).replace("_", " ")), card.display_name,
				card.stat_id, card.magnitude, card.base_weight, card.repeatable)
		"magnitude":
			return PassiveCardDefinition.of(card.card_id, card.display_name, card.stat_id,
				-card.magnitude, card.base_weight, card.repeatable)
	return card


## The WHOLE derivation as one string, so a comparison cannot pass by agreeing
## on the answer while disagreeing about how it was reached.
func _derivation(result: PassiveCardSelectionResult) -> String:
	return "ok=%s reason='%s' category=%d ladder=[%s] total=%d ticket=%d selected=%s" % [
		result.ok, result.failure_reason, result.requested_category,
		result.ladder_line(), result.total_weight, result.normalized_ticket,
		result.selected_card_id,
	]


## A refusal must be non-empty, must NAME the fault rather than merely report
## that there was one, must carry no partial selection, and must itself be a
## coherent result.
func _expect_refusal(records: Array[PassiveCardDefinition], category: int, ticket: int,
		expected_fragment: String, described: String) -> void:
	_refusals += 1
	var result: PassiveCardSelectionResult = PassiveCardSelection.select_with_ticket(
		records, category, ticket
	)
	_expect(not result.ok, "%s was accepted" % described)
	_expect(result.failure_reason.contains(expected_fragment),
		"%s was refused as '%s', which does not name '%s'" % [
			described, result.failure_reason, expected_fragment,
		])
	_expect(String(result.selected_card_id).is_empty()
			and result.candidate_ids.is_empty()
			and result.candidate_weights.is_empty()
			and result.total_weight == 0
			and result.normalized_ticket == 0,
		"%s left a partial selection behind" % described)
	_expect(result.problem().is_empty(),
		"the refusal of %s is itself incoherent: %s" % [described, result.problem()])


## Whether `path` is granted `name` by the allowlist above. An exact per-file,
## per-class test: a file not listed is granted nothing, and a listed file is
## granted only the classes written beside it.
func _is_authorized_reader(path: String, name: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) != path:
			continue
		for granted: String in row[1]:
			if granted == name:
				return true
		return false
	return false


func _methods_of(path: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var script: GDScript = load(path) as GDScript
	if script == null:
		return out
	for entry: Dictionary in script.get_script_method_list():
		out.append(String(entry.get("name", "")))
	return out


func _ids_of(records: Array[PassiveCardDefinition]) -> String:
	var out: PackedStringArray = PackedStringArray()
	for record: PassiveCardDefinition in records:
		out.append(String(record.card_id))
	return ", ".join(out)


func _sorted_ids_of(records: Array[PassiveCardDefinition]) -> String:
	var out: PackedStringArray = PackedStringArray()
	for record: PassiveCardDefinition in records:
		out.append(String(record.card_id))
	out.sort()
	return ", ".join(out)


func _reversed(records: Array[PassiveCardDefinition]) -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	for index: int in range(records.size() - 1, -1, -1):
		out.append(records[index])
	return out


func _rotated(records: Array[PassiveCardDefinition], by: int) -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	for index: int in records.size():
		out.append(records[(index + by) % records.size()])
	return out


## Front and back alternately — a permutation that is neither the reverse nor a
## rotation, so three genuinely different orders are compared rather than two.
func _interleaved(records: Array[PassiveCardDefinition]) -> Array[PassiveCardDefinition]:
	var out: Array[PassiveCardDefinition] = []
	var low: int = 0
	var high: int = records.size() - 1
	while low <= high:
		out.append(records[low])
		if low != high:
			out.append(records[high])
		low += 1
		high -= 1
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


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true


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
