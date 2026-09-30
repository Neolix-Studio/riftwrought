extends SceneTree
## Riftwrought — Roguelite Foundation I9 verification: Immutable Passive-Fallback Level-Up
## Receipt Propagation (decision D-310).
##
## ONE FOCUSED HEADLESS TEST, run as a `SceneTree` script exactly as every earlier
## foundation's suite is. I9 edits one pure-logic file — the accepted one-level level-up
## receipt — so it needs no scene, no camera and no evidence frame.
##
## IT PORTS D-211's OWED-SET DISCIPLINE: every check records reaching its LAST line, and
## the set is compared with what the suite owes in both directions.
##
## "UNCHANGED" IS A BEFORE/AFTER MEASUREMENT, NOT A RE-READING. Before the first I9 edit a
## scratch probe drove the unchanged E2 and G4 paths over a fixed corpus — one E2 lifecycle
## for every lane of nine rank states over 72 root seeds, E2's refusals, the receipt's
## constructors driven directly, and G4 runs over seven run seeds and four lane sequences —
## formatted every receipt and run-level record with members that existed before I9, and
## recorded the SHA-256 of the whole corpus. Check 1 recomposes it with the same code and
## requires the same digest. The same probe recorded the one class whose answer moves: 72 E2
## fallback receipts that called themselves incoherent and 7 G4 records wrapping one.
##
## THE EXPECTED ANSWERS ARE TYPED HERE, NOT READ FROM WHAT IS BEING CHECKED. Every worked
## seed, card, category, root seed and line below was measured against the accepted
## mechanisms before it was written down.
##
## THE TEST DATA IS NOT CONTENT. Every fabricated or tampered receipt and choice result lives
## in this file only; the `zz` prefix keeps a fabricated id from colliding with a record.

const RECEIPT_FILE: String = "res://scripts/levels/rift_level_up_result.gd"
const E2_COORDINATOR_FILE: String = "res://scripts/levels/rift_level_up_coordinator.gd"
const G4_COORDINATOR_FILE: String = "res://scripts/levels/rift_run_level_coordinator.gd"
const G4_RECORD_FILE: String = "res://scripts/levels/rift_run_level_up_result.gd"
const REVIEW_FILE: String = "res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
const CHOICE_FILE: String = "res://scripts/choices/rift_offer_choice.gd"
const CHOICE_RESULT_FILE: String = "res://scripts/choices/rift_offer_choice_result.gd"
const OFFER_FILE: String = "res://scripts/offers/rift_offer.gd"

const SUPPORT_LANE: int = RiftOffer.Lane.SUPPORT
const COMBAT_LANE: int = RiftOffer.Lane.COMBAT_DEFENCE
const UTILITY_LANE: int = RiftOffer.Lane.UTILITY
const FALLBACK_KIND: int = RiftOffer.SupportContentKind.PASSIVE_FALLBACK
const PROGRESSION_KIND: int = RiftOffer.SupportContentKind.SUPPORT_PROGRESSION
const NO_CONTENT: int = RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND
const NO_CATEGORY: int = RiftOfferChoiceResult.NO_FALLBACK_CATEGORY
const NO_KIND: int = RiftOffer.UNRESOLVED_PROGRESSION_KIND
const NO_RANK: int = RiftOfferChoiceResult.NO_RANK
const COMBAT: int = PlayerStatDefinition.Category.COMBAT_DEFENCE
const UTILITY: int = PlayerStatDefinition.Category.UTILITY

const QS: StringName = &"quick_strike"
const REACH: StringName = &"reaching_edge"
const SWEEP: StringName = &"sweeping_edge"
const POWER: StringName = &"card_power"
const CELERITY: StringName = &"card_celerity"
const VITALITY: StringName = &"card_vitality"
const INSIGHT: StringName = &"card_insight"
const MAGNETISM: StringName = &"card_magnetism"

## The pre-I9 measurement, taken with the accepted receipt before the first edit.
const PRE_I9_ROWS: int = 3198
const PRE_I9_DIGEST: String = "9f090c6441b2e74f2d038c7cacfbc589933311d831b72be3b68dd5881daf1bca"
const PRE_I9_E2_MOVING: int = 72
const PRE_I9_G4_MOVING: int = 7
const PRE_I9_E2_PROBLEM: String = "the Support lane granted 1 identifiers, not 2"
const PRE_I9_G4_PROBLEM: String = "the one-level result it records is incoherent: the Support lane granted 1 identifiers, not 2"
const PRE_I9_RECEIPT_PREFIX: String = "0f2e4a86"
const RECEIPT_PREFIX: String = "2d67cee9"

## The corpus the pre-I9 probe measured, verbatim.
const STATES: Array = [[0, 0], [1, 0], [0, 1], [1, 1], [2, 0], [0, 2], [2, 1], [1, 2], [2, 2]]
const SPECIAL_SEEDS: Array[int] = [-1, -12345, 2147483647, 4294967295, 4294967296,
	9223372036854775807, -9223372036854775807 - 1, 51507111]
const RUN_SEEDS: Array[int] = [99, 0, -1, 7, 12345, 9223372036854775807, -9223372036854775807 - 1]
const RUN_SEQUENCES: Array = [[0, 0, 0, 0, 0], [1, 1, 1, 1, 1], [2, 2, 2, 2, 2], [0, 1, 2, 0, 1]]
const UNDECLARED_LANES: Array[int] = [7, -1, 3]

## I8's worked example: root seed 18, both shipped supports at rank 2 — Support
## [card_celerity] drawn from Combat and Defence, beside card_power and card_insight.
const EXAMPLE_SEED: int = 18
const EXAMPLE_DESCRIBE: String = "root seed 18 spent; Support: card_celerity"
const EXAMPLE_LINE: String = "passive fallback: card_celerity, drawn from Combat and Defence"
## The first root seed at the same state whose fallback draws from Utility.
const UTILITY_SEED: int = 2
const UTILITY_LINE: String = "passive fallback: card_magnetism, drawn from Utility"

## The E2 worked lifecycle: 150 against 100 leaves exactly 50.
const E2_AWARD: float = 150.0
const E2_REQUIREMENT: float = 100.0
const E2_RETAINED: float = 50.0

## The G4 worked run: run seed 99 takes the Support lane at every level; Levels 1 to 4
## take both new pairs and raise both, and Level 5 is a passive fallback.
const G4_RUN_SEED: int = 99
const G4_AWARD: float = 1000.0
const G4_ROOTS: Array[int] = [99, 1000102, 2000105, 3000108, 4000111]
const G4_FALLBACK_LEVEL: int = 5
const G4_FALLBACK_ROOT: int = 4000111
const G4_FALLBACK_DESCRIBE: String = "run seed 99 at level 5: root seed 4000111 spent; Support: card_power"
const G4_FALLBACK_LINE: String = "passive fallback: card_power, drawn from Combat and Defence"
const G4_RETAINED: float = 250.0
const G4_NEXT_REQUIREMENT: float = 225.0

## The accepted E2 and F5 worked receipts, typed.
const NEW_PAIR_DESCRIBE: String = "root seed 0 spent; Support: quick_strike -> reaching_edge"
const NEW_PAIR_LINE: String = "a new compatible pair, rank 0 -> 1"
const RANK_LINE: String = "another rank of a held pair, rank 1 -> 2"
const COMBAT_DESCRIBE: String = "root seed 0 spent; Combat and Defence: card_vitality"
const UTILITY_DESCRIBE: String = "root seed 0 spent; Utility: card_magnetism"
const SPENT_REASON: String = "root seed 18 has already been consumed by this run"

const ROOT_SAMPLES: int = 4096
const E2_SAMPLES: int = 256
const SEED_SAMPLES: int = 256

## The receipt's whole shape after I9.
const EXPECTED_RECEIPT_FIELDS: Array[String] = [
	"ok", "failure_reason", "root_seed", "root_seed_known", "lane",
	"support_progression_kind", "support_rank_before", "support_rank_after",
	"_granted_identity", "support_content_kind", "support_fallback_category",
]
const EXPECTED_RECEIPT_METHODS: Array[String] = [
	"refused_without_a_seed", "refused", "taken", "granted_identity",
	"carries_support_progression", "carries_support_fallback", "problem", "duplicated",
	"identity_line", "support_progression_line", "support_fallback_line", "describe", "_stated",
]
const EXPECTED_RECEIPT_CLASSES: Array[String] = [
	"RiftLevelUpResult", "RiftOffer", "RiftOfferChoice", "RiftOfferChoiceResult",
	"SupportContinuation", "SupportContinuationResult",
]

## What the brief forbids the receipt to store or expose, by exact member name.
const FORBIDDEN_RECEIPT_MEMBERS: Array[String] = [
	"choice", "choice_result", "from_choice", "offer", "fallback", "support_fallback",
	"support_fallback_card_id", "fallback_card_id", "card_id", "selected_card_id",
	"build", "run_build", "new_build", "ledger", "new_ledger", "consumption_ledger",
	"track", "coordinator", "level", "experience", "display_name", "card_name",
	"stat_id", "magnitude", "weight", "base_weight", "category_label", "tickets",
]

## The four members I9 gives the receipt, and every running file that may name each.
const NEW_MEMBERS: Array[String] = [
	"support_content_kind", "support_fallback_category", "carries_support_fallback",
	"support_fallback_line",
]
## Measured before the suite was written: the receipt names all four; the choice result
## owns its own content kind, category and reading; the transaction routes on the content
## kind; the offer carries its own content kind and fallback line. Nothing else.
const MEMBER_OWNERS: Array = [
	["res://scripts/levels/rift_level_up_result.gd", [
		"support_content_kind", "support_fallback_category", "carries_support_fallback",
		"support_fallback_line",
	]],
	["res://scripts/choices/rift_offer_choice_result.gd", [
		"support_content_kind", "support_fallback_category", "carries_support_fallback",
	]],
	["res://scripts/choices/rift_offer_choice.gd", ["support_content_kind"]],
	["res://scripts/offers/rift_offer.gd", ["support_content_kind", "support_fallback_line"]],
	## Roguelite I10 (D-312): both coordinators and the mote runtime name their two readings of
	## the STANDING offer — `offer_support_content_kind()` and `offer_support_fallback_category()`
	## — which read the offer, never a receipt; and the running review renders a consumed
	## fallback from the receipt's kind, category and reading. Each only these.
	["res://scripts/levels/rift_level_up_coordinator.gd", ["support_content_kind", "support_fallback_category"]],
	["res://scripts/levels/rift_run_level_coordinator.gd", ["support_content_kind", "support_fallback_category"]],
	["res://scripts/experience/rift_mote_runtime.gd", ["support_content_kind", "support_fallback_category"]],
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", [
		"support_content_kind", "support_fallback_category", "carries_support_fallback",
	]],
]
## Every running file that names the receipt's class besides the receipt itself.
const RECEIPT_READERS: Array[String] = [
	"res://scripts/levels/rift_level_up_coordinator.gd",
	"res://scripts/levels/rift_run_level_coordinator.gd",
	"res://scripts/levels/rift_run_level_up_result.gd",
	"res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd",
]

## Accepted files I9 must not touch, by the SHA-256 prefix each held before the first I9
## edit: I8's two choice files, the offer and composer, the I6 fallback, the ledger, the run
## build, the card records and selector, the acquisition record, the continuation, both
## coordinators and the run-level record, the track, G1 and G2, the mote runtime, the
## running review and its panel, the live-effect seam and review, and project.godot.
const UNCHANGED_HASHES: Array = [
	["res://scripts/choices/rift_offer_choice.gd", "533ee30f"],
	["res://scripts/choices/rift_offer_choice_result.gd", "f051a955"],
	["res://scripts/offers/rift_offer.gd", "9bc94208"],
	["res://scripts/offers/rift_offer_composition.gd", "15ef203a"],
	["res://scripts/fallback/support_exhaustion_passive_fallback.gd", "c1cad5e4"],
	["res://scripts/fallback/support_exhaustion_passive_fallback_result.gd", "a195665f"],
	["res://scripts/choices/rift_consumption_ledger.gd", "f990eab7"],
	["res://scripts/runs/rift_run_build.gd", "1920ae25"],
	["res://scripts/stats/passive_card_catalogue.gd", "278b30dc"],
	["res://scripts/stats/passive_card_definition.gd", "c64dcaf4"],
	["res://scripts/stats/passive_card_selection.gd", "833cd25b"],
	["res://scripts/stats/passive_card_selection_result.gd", "05a74cb3"],
	["res://scripts/skills/acquired_supports.gd", "aad88e92"],
	["res://scripts/continuation/support_continuation.gd", "c815ad5d"],
	["res://scripts/continuation/support_continuation_result.gd", "68c8811d"],
	## Roguelite I10 (D-312): both coordinators, the mote runtime and the running review moved
	## one for one — from `bbba1a71`, `01090425`, `083d4c28` and `005af300` — to the D-312
	## files. Same count.
	["res://scripts/levels/rift_level_up_coordinator.gd", "f178c358"],
	["res://scripts/levels/rift_run_level_coordinator.gd", "b654e0a2"],
	["res://scripts/levels/rift_run_level_up_result.gd", "cc7f8b84"],
	["res://scripts/experience/rift_experience_track.gd", "7f0ab193"],
	["res://scripts/level_requirements/rift_level_requirement_curve.gd", "c8b3f3b1"],
	["res://scripts/level_seeds/rift_level_offer_seed_derivation.gd", "5cc31f28"],
	["res://scripts/experience/rift_mote_runtime.gd", "23c41eb2"],
	## Roguelite I10's correction (D-313) moved the running review again, `1af0ffe8` → `9dcbfcc6`.
	## Roguelite I11 (D-314) moved the running review and its panel one for one — `9dcbfcc6` →
	## `128103b4` and `434740f2` → `61173e43` — to the D-314 files. Same count.
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", "128103b4"],
	## First-MVP UI J1 (D-322) moved the panel one for one — `61173e43` → `694eb0b2` — removing its
	## own left-press override now that the shared modal contract routes the pointer. Same count.
	["res://scripts/roguelite/level_up/rift_level_up_offer_panel.gd", "694eb0b2"],
	## Roguelite I13 (D-318) made Global Damage live, so the seam, its result and the live-effect
	## review moved one for one — `1aa00c5f`, `b6b6d1ee` and `ec2ec19e` — to the D-318 files, and Roguelite I14 (D-320), making Maximum Life live, to the D-320 files. Same count.
	["res://scripts/roguelite/live_effects/rift_build_application.gd", "c7b9df38"],
	## Roguelite I14's correction (D-321) moved the result once more, from `73d445f7`, for its
	## describe() diagnostic. Same count.
	["res://scripts/roguelite/live_effects/rift_build_application_result.gd", "2fd01f80"],
	## Roguelite I12 (D-316) moved the live-effect review one for one — `6a260f4c` →
	## `ec2ec19e` — to the D-316 file. Same count.
	["res://scripts/roguelite/live_effects/roguelite_live_effect_review.gd", "75cb02b9"],
	["res://project.godot", "55351038"],
]

## The accepted suites and runners I9 moved one for one, read by path.
const E2_SUITE: String = "res://tests/rift_level_up_coordinator_verification.gd"
const F5_SUITE: String = "res://tests/rift_level_up_support_progression_verification.gd"
const F5_RUNNER: String = "res://tests/rift_level_up_support_progression_smoke.sh"
const G3_SUITE: String = "res://tests/rift_level_up_continuation_verification.gd"
const G4_SUITE: String = "res://tests/rift_run_level_coordinator_verification.gd"
const G4_RUNNER: String = "res://tests/rift_run_level_coordinator_smoke.sh"
const I6_SUITE: String = "res://tests/support_exhaustion_passive_fallback_verification.gd"
const I7_SUITE: String = "res://tests/passive_fallback_offer_composition_verification.gd"
const I7_RUNNER: String = "res://tests/passive_fallback_offer_composition_smoke.sh"
const I8_SUITE: String = "res://tests/passive_fallback_choice_transaction_verification.gd"
const I8_RUNNER: String = "res://tests/passive_fallback_choice_transaction_smoke.sh"

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31

const OWED_CHECKS: Array[String] = [
	"every_accepted_receipt_reproduces_the_pre_i9_corpus",
	"the_root_seed_18_fallback_choice_becomes_a_coherent_receipt",
	"every_shipped_fallback_card_and_both_categories_propagate",
	"taken_copies_every_stable_fact_from_the_whole_choice",
	"a_null_or_refused_choice_makes_no_successful_receipt",
	"new_pair_and_rank_increase_receipts_are_unchanged",
	"combat_and_utility_receipts_are_unchanged",
	"every_mixed_shape_is_refused_by_exact_message",
	"mutating_the_source_choice_cannot_reach_the_receipt",
	"receipt_copies_are_independent_in_every_field",
	"e2_commits_the_fallback_once_with_a_coherent_receipt",
	"g4_records_the_fallback_with_its_run_provenance",
	"continuing_the_lifecycle_keeps_the_card_and_the_spent_seed",
	"nothing_opens_or_advances_by_itself",
	"nothing_running_consumes_or_displays_the_fallback_receipt",
	"the_receipt_shape_and_its_seams_are_pinned",
	"accepted_files_and_suites_moved_one_for_one",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}

## Every receipt the corpus formatter touched, for check 1's content audit.
var _seen: Array = []


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation I9 — Immutable Passive-Fallback Level-Up Receipt Propagation (D-310) ===")

	_check_every_accepted_receipt_reproduces_the_pre_i9_corpus()
	_check_the_root_seed_18_fallback_choice_becomes_a_coherent_receipt()
	_check_every_shipped_fallback_card_and_both_categories_propagate()
	_check_taken_copies_every_stable_fact_from_the_whole_choice()
	_check_a_null_or_refused_choice_makes_no_successful_receipt()
	_check_new_pair_and_rank_increase_receipts_are_unchanged()
	_check_combat_and_utility_receipts_are_unchanged()
	_check_every_mixed_shape_is_refused_by_exact_message()
	_check_mutating_the_source_choice_cannot_reach_the_receipt()
	_check_receipt_copies_are_independent_in_every_field()
	_check_e2_commits_the_fallback_once_with_a_coherent_receipt()
	_check_g4_records_the_fallback_with_its_run_provenance()
	_check_continuing_the_lifecycle_keeps_the_card_and_the_spent_seed()
	_check_nothing_opens_or_advances_by_itself()
	_check_nothing_running_consumes_or_displays_the_fallback_receipt()
	_check_the_receipt_shape_and_its_seams_are_pinned()
	_check_accepted_files_and_suites_moved_one_for_one()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("PASSIVE FALLBACK LEVEL-UP RECEIPT VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("PASSIVE FALLBACK LEVEL-UP RECEIPT VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. Every accepted receipt, measured against the pre-I9 receipt ------------------------------------------------

func _check_every_accepted_receipt_reproduces_the_pre_i9_corpus() -> void:
	print("")
	print("--- 1. Every accepted receipt and run-level record reproduces the pre-I9 corpus exactly")
	_seen.clear()
	var corpus: Array = _corpus()
	var rows: PackedStringArray = corpus[0]
	var moving: Array = corpus[1]
	var digest: String = "\n".join(rows).sha256_text()
	_expect(rows.size() == PRE_I9_ROWS and digest == PRE_I9_DIGEST,
		"%d rows hash %s, not %d rows at %s" % [rows.size(), digest, PRE_I9_ROWS, PRE_I9_DIGEST])

	## THE TWO NEW FIELDS ON EVERY RECEIPT THE CORPUS FORMATTED. Four of the constructor rows
	## are incoherent BY DESIGN — a Support choice with no progression, a passive choice with
	## one, a Support choice with one id and a passive choice with two — and the digest above
	## already proves their verdicts did not move. Their content fields are still audited: each
	## carries exactly what I8's `chosen()` declared for its lane, and no fallback category.
	var progressions: int = 0
	var passives: int = 0
	var refusals: int = 0
	var fallbacks: int = 0
	var incoherent: int = 0
	var wrong: PackedStringArray = PackedStringArray()
	for receipt: RiftLevelUpResult in _seen:
		if not receipt.ok:
			refusals += 1
			if not _refused_whole(receipt) and wrong.size() < 5:
				wrong.append("a refusal reads %s" % _full_row(receipt))
			continue
		if receipt.carries_support_fallback():
			fallbacks += 1
			continue
		var owed_content: int = PROGRESSION_KIND if receipt.lane == SUPPORT_LANE else NO_CONTENT
		if receipt.support_content_kind != owed_content or receipt.support_fallback_category != NO_CATEGORY \
				or receipt.support_fallback_line() != "no passive fallback":
			wrong.append("a success reads %s" % _full_row(receipt))
		if not receipt.problem().is_empty():
			incoherent += 1
		elif receipt.lane == SUPPORT_LANE:
			progressions += 1
			if not receipt.carries_support_progression() or receipt.granted_identity().size() != 2:
				wrong.append("a Support progression reads %s" % _full_row(receipt))
		else:
			passives += 1
			if receipt.carries_support_progression() or receipt.granted_identity().size() != 1:
				wrong.append("a passive receipt reads %s" % _full_row(receipt))
	_expect(wrong.is_empty() and progressions > 500 and passives > 1000 and refusals > 500 and incoherent == 4
			and fallbacks == PRE_I9_E2_MOVING + PRE_I9_G4_MOVING,
		"%d progressions, %d passives, %d refusals, %d incoherent, %d fallbacks; %s" % [
			progressions, passives, refusals, incoherent, fallbacks, "; ".join(wrong)])

	## THE ONE CLASS WHOSE ANSWER MOVED.
	var e2_moved: int = 0
	var g4_moved: int = 0
	var faults: PackedStringArray = PackedStringArray()
	for item: Variant in moving:
		if item is RiftRunLevelUpResult:
			var record: RiftRunLevelUpResult = item
			var carried: RiftLevelUpResult = record.level_up()
			if record.problem().is_empty() and record.succeeded() and carried.carries_support_fallback() \
					and _fallback_shape(carried).is_empty():
				g4_moved += 1
			elif faults.size() < 5:
				faults.append("%s / '%s'" % [record.describe(), record.problem()])
		else:
			var receipt: RiftLevelUpResult = item
			if _fallback_shape(receipt).is_empty():
				e2_moved += 1
			elif faults.size() < 5:
				faults.append("%s / '%s'" % [receipt.describe(), _fallback_shape(receipt)])
	_expect(e2_moved == PRE_I9_E2_MOVING and g4_moved == PRE_I9_G4_MOVING
			and moving.size() == PRE_I9_E2_MOVING + PRE_I9_G4_MOVING,
		"%d E2 and %d G4 of %d moving rows are coherent fallbacks; %s" % [e2_moved, g4_moved, moving.size(), "; ".join(faults)])
	print("  %d accepted receipt and run-level record rows (E2 lifecycles over 9 rank states x 72 root seeds x 3 lanes, E2 refusals, the constructors, and G4 runs over 7 run seeds x 4 lane sequences) hash %s — identical to the pre-I9 receipt's"
		% [rows.size(), digest.left(16)])
	print("  every formatted receipt carries its Support content: %d Support progressions SUPPORT_PROGRESSION with no fallback category, %d passive receipts and %d refusals with neither, and the %d constructor rows that are incoherent by design carry what their lane's choice declared"
		% [progressions, passives, refusals, incoherent])
	print("  the one class whose answer moved: %d E2 fallback receipts the pre-I9 receipt called incoherent ('%s') and %d G4 records wrapping one ('%s') are each coherent now — one card, PASSIVE_FALLBACK, a passive category, no progression"
		% [e2_moved, PRE_I9_E2_PROBLEM, g4_moved, PRE_I9_G4_PROBLEM])
	_done("every_accepted_receipt_reproduces_the_pre_i9_corpus")


# --- 2. The worked example ---------------------------------------------------------------------------------------------

func _check_the_root_seed_18_fallback_choice_becomes_a_coherent_receipt() -> void:
	print("")
	print("--- 2. I8's root-seed-18 fallback choice becomes a coherent level-up receipt")
	var choice: RiftOfferChoiceResult = _fallback_choice(EXAMPLE_SEED)
	var receipt: RiftLevelUpResult = RiftLevelUpResult.taken(choice)
	_expect(choice.ok and choice.problem().is_empty() and choice.carries_support_fallback()
			and choice.support_fallback_category == COMBAT,
		"the I8 choice is %s" % choice.describe())
	## Every field, typed.
	_expect(receipt.ok and receipt.failure_reason.is_empty() and receipt.root_seed == EXAMPLE_SEED
			and receipt.root_seed_known and receipt.lane == SUPPORT_LANE
			and receipt.granted_identity() == PackedStringArray([String(CELERITY)])
			and receipt.support_content_kind == FALLBACK_KIND and receipt.support_fallback_category == COMBAT
			and receipt.support_progression_kind == NO_KIND
			and receipt.support_rank_before == NO_RANK and receipt.support_rank_after == NO_RANK,
		"the receipt reads %s" % _full_row(receipt))
	_expect(receipt.problem().is_empty() and receipt.carries_support_fallback()
			and not receipt.carries_support_progression(),
		"the receipt reports '%s'" % receipt.problem())
	_expect(receipt.describe() == EXAMPLE_DESCRIBE and receipt.identity_line() == String(CELERITY)
			and receipt.support_progression_line() == "no support progression"
			and receipt.support_fallback_line() == EXAMPLE_LINE,
		"the receipt presents '%s' / '%s' / '%s'" % [receipt.describe(), receipt.identity_line(), receipt.support_fallback_line()])
	## Proof 2: every fact equals the choice's own.
	var mismatch: String = _receipt_matches_choice(receipt, choice)
	_expect(mismatch.is_empty(), "the receipt disagrees with its choice on %s" % mismatch)
	print("  root seed 18 at R2 S2: the I8 choice consumed Support [card_celerity] from category %d; the receipt reads root seed %d, lane Support, [%s], content PASSIVE_FALLBACK, category %d, progression kind %d at ranks %d -> %d — equal to the choice in all ten facts"
		% [choice.support_fallback_category, receipt.root_seed, ", ".join(receipt.granted_identity()),
			receipt.support_fallback_category, receipt.support_progression_kind, receipt.support_rank_before, receipt.support_rank_after])
	print("  presented: '%s'; '%s'; '%s'; problem() empty" % [receipt.describe(), receipt.support_progression_line(), receipt.support_fallback_line()])
	_done("the_root_seed_18_fallback_choice_becomes_a_coherent_receipt")


# --- 3. Every shipped fallback card, both categories ------------------------------------------------------------------

func _check_every_shipped_fallback_card_and_both_categories_propagate() -> void:
	print("")
	print("--- 3. Every fallback over %d root seeds propagates: all six shipped cards, both categories" % ROOT_SAMPLES)
	var held: AcquiredSupports = _held(2, 2)
	var cards: Array[PassiveCardDefinition] = _cards()
	var carried: int = 0
	var by_card: Dictionary = {}
	var by_category: Dictionary = {}
	var faults: PackedStringArray = PackedStringArray()
	for root_seed: int in ROOT_SAMPLES:
		var offer: RiftOffer = _compose(held, cards, root_seed)
		var choice: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, SUPPORT_LANE, _bare_build(2, 2), RiftConsumptionLedger.new())
		var receipt: RiftLevelUpResult = RiftLevelUpResult.taken(choice)
		var fault: String = _fallback_shape(receipt)
		if fault.is_empty() and _receipt_matches_choice(receipt, choice).is_empty() \
				and receipt.granted_identity() == PackedStringArray([String(offer.support_fallback_card_id)]) \
				and receipt.support_fallback_category == offer.support_fallback.selected_category:
			carried += 1
			_count(by_card, receipt.granted_identity()[0])
			_count(by_category, _category_name(receipt.support_fallback_category))
		elif faults.size() < 5:
			faults.append("root seed %d: %s %s" % [root_seed, fault, _receipt_matches_choice(receipt, choice)])
	_expect(carried == ROOT_SAMPLES and by_card.size() == PassiveCardCatalogue.ALL.size() and by_category.size() == 2,
		"%d of %d carried; cards %s; categories %s; %s" % [carried, ROOT_SAMPLES, str(by_card), str(by_category), "; ".join(faults)])

	## THROUGH THE UNCHANGED ONE-LEVEL COORDINATOR: every receipt equals the taken() of an
	## independently composed offer chosen on an independent copy of the same state.
	var through_e2: int = 0
	var e2_cards: Dictionary = {}
	var e2_categories: Dictionary = {}
	for root_seed: int in E2_SAMPLES:
		var lifecycle: RiftLevelUpCoordinator = _ready_lifecycle(_bare_build(2, 2), E2_REQUIREMENT)
		lifecycle.open_offer(E2_REQUIREMENT, _profiles(), _definitions(), cards, root_seed)
		var receipt: RiftLevelUpResult = lifecycle.choose(SUPPORT_LANE)
		var independent: RiftLevelUpResult = RiftLevelUpResult.taken(RiftOfferChoice.choose(
			_compose(held, cards, root_seed), SUPPORT_LANE, _bare_build(2, 2), RiftConsumptionLedger.new()))
		if _fallback_shape(receipt).is_empty() and _full_row(receipt) == _full_row(independent):
			through_e2 += 1
			_count(e2_cards, receipt.granted_identity()[0])
			_count(e2_categories, _category_name(receipt.support_fallback_category))
	_expect(through_e2 == E2_SAMPLES and e2_cards.size() == PassiveCardCatalogue.ALL.size() and e2_categories.size() == 2,
		"%d of %d through E2; cards %s; categories %s" % [through_e2, E2_SAMPLES, str(e2_cards), str(e2_categories)])
	print("  %d of %d fallback choices over root seeds 0-%d become coherent receipts equal to their choice: by card %s; by category %s"
		% [carried, ROOT_SAMPLES, ROOT_SAMPLES - 1, _owner_line(by_card), _owner_line(by_category)])
	print("  %d of %d through the unchanged one-level coordinator, each equal field for field to an independent choice's receipt: by card %s; by category %s"
		% [through_e2, E2_SAMPLES, _owner_line(e2_cards), _owner_line(e2_categories)])
	_done("every_shipped_fallback_card_and_both_categories_propagate")


# --- 4. taken() reads the whole choice -----------------------------------------------------------------------------------

func _check_taken_copies_every_stable_fact_from_the_whole_choice() -> void:
	print("")
	print("--- 4. taken() receives the whole choice result and copies every stable fact out of it")
	var shapes: Array = [
		["a Combat and Defence fallback", _fallback_choice(EXAMPLE_SEED)],
		["a Utility fallback", _fallback_choice(UTILITY_SEED)],
		["a new pair", RiftOfferChoice.choose(_compose(AcquiredSupports.new(), _cards(), 0), SUPPORT_LANE, RiftRunBuild.new(), RiftConsumptionLedger.new())],
		["a rank increase", RiftOfferChoice.choose(_compose(_held(1, 1), _cards(), EXAMPLE_SEED), SUPPORT_LANE, _bare_build(1, 1), RiftConsumptionLedger.new())],
		["a Combat and Defence card", RiftOfferChoice.choose(_compose(AcquiredSupports.new(), _cards(), 0), COMBAT_LANE, RiftRunBuild.new(), RiftConsumptionLedger.new())],
		["a Utility card", RiftOfferChoice.choose(_compose(AcquiredSupports.new(), _cards(), 0), UTILITY_LANE, RiftRunBuild.new(), RiftConsumptionLedger.new())],
	]
	var copied: int = 0
	for row: Array in shapes:
		var choice: RiftOfferChoiceResult = row[1]
		var receipt: RiftLevelUpResult = RiftLevelUpResult.taken(choice)
		var mismatch: String = _receipt_matches_choice(receipt, choice)
		_expect(choice.ok and receipt.ok and mismatch.is_empty() and receipt.problem().is_empty(),
			"%s: the receipt disagrees on %s or reports '%s'" % [String(row[0]), mismatch, receipt.problem()])
		copied += 1

	## THE BUILD IS NEVER ASKED. A hand-made fallback result over an EMPTY build — which holds
	## no card at all — still yields the receipt of exactly what the choice declares.
	var empty_build: RiftRunBuild = RiftRunBuild.new()
	var hand_made: RiftOfferChoiceResult = RiftOfferChoiceResult.chosen_support_fallback(
		EXAMPLE_SEED, PackedStringArray([String(INSIGHT)]), UTILITY, empty_build, _spent(EXAMPLE_SEED))
	var from_hand: RiftLevelUpResult = RiftLevelUpResult.taken(hand_made)
	_expect(from_hand.granted_identity() == PackedStringArray([String(INSIGHT)])
			and from_hand.support_fallback_category == UTILITY and from_hand.problem().is_empty()
			and empty_build.acquisitions_for(INSIGHT) == 0 and _receipt_matches_choice(from_hand, hand_made).is_empty(),
		"the hand-made receipt reads %s" % _full_row(from_hand))

	## STRUCTURAL, read from the code: one argument; each stable fact read out of it once.
	var taken_body: String = _function_body(_code(RECEIPT_FILE), "taken")
	var reads: PackedStringArray = PackedStringArray()
	for member: String in ["from_choice.ok", "from_choice.root_seed_known", "from_choice.lane",
			"from_choice.chosen_identity()", "from_choice.support_progression_kind",
			"from_choice.support_rank_before", "from_choice.support_rank_after",
			"from_choice.support_content_kind", "from_choice.support_fallback_category"]:
		if taken_body.count(member) != 1:
			reads.append("%s x%d" % [member, taken_body.count(member)])
	_expect(taken_body.begins_with("func taken(from_choice: RiftOfferChoiceResult) -> RiftLevelUpResult:")
			and taken_body.count("from_choice.root_seed") == 2 and reads.is_empty()
			and _code(RECEIPT_FILE).count("from_choice") == taken_body.count("from_choice")
			and not taken_body.contains("new_build") and not taken_body.contains("new_ledger"),
		"taken() reads %s" % ", ".join(reads))
	## Since Roguelite I10 (D-312) the coordinator names two of the members, in its readings of
	## the STANDING offer only: `choose()` still names none, and nothing outside that grant does.
	var coordinator_code: String = _code(E2_COORDINATOR_FILE)
	var choose_body: String = _function_body(coordinator_code, "choose")
	var named: PackedStringArray = PackedStringArray()
	for member: String in NEW_MEMBERS:
		if choose_body.contains(member) \
				or (coordinator_code.contains(member) and not _owner_may_name(E2_COORDINATOR_FILE, member)):
			named.append(member)
	_expect(coordinator_code.count("RiftLevelUpResult.taken(outcome)") == 1
			and coordinator_code.count("RiftLevelUpResult.taken(") == 1 and named.is_empty(),
		"the coordinator builds its receipt %d times and names %s" % [
			coordinator_code.count("RiftLevelUpResult.taken("), ", ".join(named)])
	print("  %d choice shapes — two fallbacks, a new pair, a rank increase and both passive lanes — each copied whole: seed, known, lane, identity, three progression facts, content kind and category"
		% copied)
	print("  a hand-made Utility fallback over an empty build: the receipt carries [card_insight] and category 1 as the choice declares; the build is never asked")
	print("  STRUCTURAL, read from the code: taken() takes one RiftOfferChoiceResult and reads each stable fact once; nothing else in the receipt names it; the one-level coordinator builds its receipt only through taken(outcome) and names none of the four new members in choose(), and none at all outside I10's (D-312) two standing-offer readings")
	_done("taken_copies_every_stable_fact_from_the_whole_choice")


# --- 5. Nothing is built out of a refusal ------------------------------------------------------------------------------

func _check_a_null_or_refused_choice_makes_no_successful_receipt() -> void:
	print("")
	print("--- 5. A null or refused choice makes no successful receipt and exposes no fallback fact")
	var refusals: Array = []
	refusals.append(["taken(null)", RiftLevelUpResult.taken(null)])
	refusals.append(["taken(a refused choice)", RiftLevelUpResult.taken(
		RiftOfferChoiceResult.refused("zz refused", EXAMPLE_SEED, SUPPORT_LANE))])
	refusals.append(["taken(a choice refused without a seed)", RiftLevelUpResult.taken(
		RiftOfferChoiceResult.refused_without_a_seed("zz no offer", SUPPORT_LANE))])
	refusals.append(["refused()", RiftLevelUpResult.refused("zz refused", EXAMPLE_SEED, SUPPORT_LANE)])
	refusals.append(["refused_without_a_seed()", RiftLevelUpResult.refused_without_a_seed("zz none", SUPPORT_LANE)])

	## Through the coordinator, around a standing FALLBACK offer.
	var early: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, _bare_build(2, 2), null)
	refusals.append(["a lane before any offer", early.choose(SUPPORT_LANE)])
	var standing: RiftLevelUpCoordinator = _open_fallback_lifecycle(EXAMPLE_SEED)
	for lane: int in UNDECLARED_LANES:
		refusals.append(["undeclared lane %d of a fallback offer" % lane, standing.choose(lane)])
	var spent: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, _bare_build(2, 2), _spent(EXAMPLE_SEED))
	spent.award_experience(E2_REQUIREMENT)
	spent.open_offer(E2_REQUIREMENT, _profiles(), _definitions(), _cards(), EXAMPLE_SEED)
	var spent_support: RiftLevelUpResult = spent.choose(SUPPORT_LANE)
	refusals.append(["the fallback lane on a spent seed", spent_support])
	standing.choose(SUPPORT_LANE)
	for lane: int in RiftOffer.LANE_ORDER:
		refusals.append(["lane %d after the fallback completed" % lane, standing.choose(lane)])
	## And a G4 refusal, whose carried receipt is a copy.
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(G4_RUN_SEED)
	refusals.append(["a G4 choice before any offer", run.choose(SUPPORT_LANE).level_up()])

	var whole: int = 0
	for row: Array in refusals:
		var receipt: RiftLevelUpResult = row[1]
		_expect(_refused_whole(receipt) and _refused_whole(receipt.duplicated()),
			"%s reads %s" % [String(row[0]), _full_row(receipt)])
		whole += 1
	_expect(spent_support.failure_reason == SPENT_REASON and spent_support.root_seed == EXAMPLE_SEED,
		"the spent-seed refusal reads '%s'" % spent_support.failure_reason)
	print("  %d refusals — taken() of null and of two refused choices, both refusal constructors, a lane before any offer, 3 undeclared lanes of a fallback offer, the fallback lane on a spent seed ('%s'), 3 lanes after completion and a G4 choice before any offer — each ok=false with no identity, no Support content kind, no fallback category and no progression, coherent, and copied the same"
		% [whole, SPENT_REASON])
	_done("a_null_or_refused_choice_makes_no_successful_receipt")


# --- 6. Progression receipts --------------------------------------------------------------------------------------------

func _check_new_pair_and_rank_increase_receipts_are_unchanged() -> void:
	print("")
	print("--- 6. The accepted new-pair and rank-increase receipts are unchanged")
	var fresh: RiftLevelUpCoordinator = _ready_lifecycle(null, E2_REQUIREMENT)
	fresh.open_offer(E2_REQUIREMENT, _profiles(), _definitions(), _cards(), 0)
	var new_pair: RiftLevelUpResult = fresh.choose(SUPPORT_LANE)
	_expect(new_pair.ok and new_pair.problem().is_empty() and new_pair.describe() == NEW_PAIR_DESCRIBE
			and new_pair.support_progression_kind == SupportContinuationResult.Kind.NEW_PAIR
			and new_pair.support_rank_before == 0 and new_pair.support_rank_after == 1
			and new_pair.support_progression_line() == NEW_PAIR_LINE
			and new_pair.support_content_kind == PROGRESSION_KIND and new_pair.support_fallback_category == NO_CATEGORY
			and new_pair.carries_support_progression() and not new_pair.carries_support_fallback()
			and new_pair.support_fallback_line() == "no passive fallback",
		"the new pair reads %s" % _full_row(new_pair))
	var ranked: RiftLevelUpCoordinator = _ready_lifecycle(_bare_build(1, 1), E2_REQUIREMENT)
	ranked.open_offer(E2_REQUIREMENT, _profiles(), _definitions(), _cards(), EXAMPLE_SEED)
	var raised: RiftLevelUpResult = ranked.choose(SUPPORT_LANE)
	_expect(raised.ok and raised.problem().is_empty()
			and raised.granted_identity() == PackedStringArray([String(QS), String(SWEEP)])
			and raised.support_progression_kind == SupportContinuationResult.Kind.RANK_INCREASE
			and raised.support_progression_line() == RANK_LINE
			and raised.support_content_kind == PROGRESSION_KIND and raised.support_fallback_category == NO_CATEGORY
			and raised.carries_support_progression() and not raised.carries_support_fallback()
			and ranked.run_build().support_rank_for(QS, SWEEP) == 2,
		"the rank increase reads %s" % _full_row(raised))
	print("  root seed 0: '%s', %s, content SUPPORT_PROGRESSION, no fallback category, '%s'" % [
		new_pair.describe(), new_pair.support_progression_line(), new_pair.support_fallback_line()])
	print("  root seed 18 with both pairs at rank 1: '%s', %s, content SUPPORT_PROGRESSION, no fallback category" % [
		raised.describe(), raised.support_progression_line()])
	_done("new_pair_and_rank_increase_receipts_are_unchanged")


# --- 7. Passive receipts -------------------------------------------------------------------------------------------------

func _check_combat_and_utility_receipts_are_unchanged() -> void:
	print("")
	print("--- 7. The accepted Combat-and-Defence and Utility receipts are unchanged")
	var rows: Array = [
		[COMBAT_LANE, null, 0, COMBAT_DESCRIBE],
		[UTILITY_LANE, null, 0, UTILITY_DESCRIBE],
		[COMBAT_LANE, _bare_build(2, 2), EXAMPLE_SEED, "root seed 18 spent; Combat and Defence: card_power"],
		[UTILITY_LANE, _bare_build(2, 2), EXAMPLE_SEED, "root seed 18 spent; Utility: card_insight"],
	]
	var shown: PackedStringArray = PackedStringArray()
	for row: Array in rows:
		var lifecycle: RiftLevelUpCoordinator = _ready_lifecycle(row[1], E2_REQUIREMENT)
		lifecycle.open_offer(E2_REQUIREMENT, _profiles(), _definitions(), _cards(), int(row[2]))
		var receipt: RiftLevelUpResult = lifecycle.choose(int(row[0]))
		_expect(receipt.ok and receipt.problem().is_empty() and receipt.describe() == String(row[3])
				and receipt.support_content_kind == NO_CONTENT and receipt.support_fallback_category == NO_CATEGORY
				and receipt.support_progression_kind == NO_KIND and not receipt.carries_support_progression()
				and not receipt.carries_support_fallback() and receipt.support_fallback_line() == "no passive fallback"
				and receipt.support_progression_line() == "no support progression",
			"the passive receipt reads %s" % _full_row(receipt))
		shown.append(receipt.describe())
	print("  %s — every one with no Support content kind, no fallback category and no progression, including both passive lanes of the root-seed-18 fallback offer"
		% "; ".join(shown))
	_done("combat_and_utility_receipts_are_unchanged")


# --- 8. Every mixed shape ---------------------------------------------------------------------------------------------

func _check_every_mixed_shape_is_refused_by_exact_message() -> void:
	print("")
	print("--- 8. Every mixed shape is refused by problem(), and each new scalar is tampered independently")
	## [base, label, field (or "+id" / "-id"), value, the exact message]
	var rows: Array = [
		["fallback", "fallback with two ids", "+id", "zz_second", "the Support lane granted 2 identifiers, not 1"],
		["fallback", "fallback with a progression kind", "support_progression_kind", SupportContinuationResult.Kind.NEW_PAIR, "the Support level-up's passive fallback declares support progression kind 0"],
		["fallback", "fallback with ranks", "support_rank_after", 1, "the Support level-up's passive fallback exposes the support ranks 0 -> 1"],
		["fallback", "fallback without a category", "support_fallback_category", NO_CATEGORY, "the Support level-up's passive fallback names category -1, which no passive lane draws from"],
		["fallback", "fallback with a non-canonical category", "support_fallback_category", 2, "the Support level-up's passive fallback names category 2, which no passive lane draws from"],
		["fallback", "fallback with no content kind", "support_content_kind", NO_CONTENT, "the Support level-up declares the unknown Support content kind -1"],
		["fallback", "fallback declared a progression", "support_content_kind", PROGRESSION_KIND, "the Support lane granted 1 identifiers, not 2"],
		["fallback", "fallback of an undeclared content kind", "support_content_kind", 7, "the Support level-up declares the unknown Support content kind 7"],
		["fallback", "fallback moved to the Combat and Defence lane", "lane", COMBAT_LANE, "the Combat and Defence lane declares Support content kind 1"],
		["progression", "progression with a Combat and Defence fallback category", "support_fallback_category", COMBAT, "a Support progression names the fallback category 0"],
		["progression", "progression with a Utility fallback category", "support_fallback_category", UTILITY, "a Support progression names the fallback category 1"],
		["progression", "progression declared a fallback", "support_content_kind", FALLBACK_KIND, "the Support lane granted 2 identifiers, not 1"],
		["progression", "progression with one id", "-id", "", "the Support lane granted 1 identifiers, not 2"],
		["progression", "progression with no content kind", "support_content_kind", NO_CONTENT, "the Support level-up declares the unknown Support content kind -1"],
		["combat", "Combat and Defence lane carrying PASSIVE_FALLBACK", "support_content_kind", FALLBACK_KIND, "the Combat and Defence lane declares Support content kind 1"],
		["combat", "Combat and Defence lane carrying SUPPORT_PROGRESSION", "support_content_kind", PROGRESSION_KIND, "the Combat and Defence lane declares Support content kind 0"],
		["combat", "Combat and Defence lane carrying a fallback category", "support_fallback_category", COMBAT, "the Combat and Defence lane names the fallback category 0"],
		["utility", "Utility lane carrying PASSIVE_FALLBACK", "support_content_kind", FALLBACK_KIND, "the Utility lane declares Support content kind 1"],
		["utility", "Utility lane carrying a fallback category", "support_fallback_category", UTILITY, "the Utility lane names the fallback category 1"],
		["refusal", "refusal carrying PASSIVE_FALLBACK", "support_content_kind", FALLBACK_KIND, "a refused level-up must declare no Support content kind, not 1"],
		["refusal", "refusal carrying SUPPORT_PROGRESSION", "support_content_kind", PROGRESSION_KIND, "a refused level-up must declare no Support content kind, not 0"],
		["refusal", "refusal carrying a fallback category", "support_fallback_category", COMBAT, "a refused level-up must name no fallback category, not 0"],
		["refusal", "refusal carrying an identity", "+id", "zz_card", "a refused level-up must expose no granted identity"],
	]
	var caught: int = 0
	var escaped: PackedStringArray = PackedStringArray()
	for row: Array in rows:
		var receipt: RiftLevelUpResult = _base(String(row[0]))
		_expect(receipt.problem().is_empty(), "the %s base is incoherent: %s" % [String(row[0]), receipt.problem()])
		var field: String = String(row[2])
		var original: Variant = null
		var saved_identity: PackedStringArray = receipt.granted_identity()
		if field == "+id":
			receipt._granted_identity.append(String(row[3]))
		elif field == "-id":
			receipt._granted_identity.remove_at(receipt._granted_identity.size() - 1)
		else:
			original = receipt.get(field)
			receipt.set(field, int(row[3]))
		if receipt.problem() == String(row[4]):
			caught += 1
		else:
			escaped.append("%s answered '%s'" % [String(row[1]), receipt.problem()])
		if field == "+id" or field == "-id":
			receipt._granted_identity = saved_identity
		else:
			receipt.set(field, original)
		if not receipt.problem().is_empty():
			escaped.append("%s is still incoherent once restored: %s" % [String(row[1]), receipt.problem()])

	## THE RECEIPT DOES NOT TRUST WHAT IT COPIES: mixed choice results built through I8's own
	## constructors, and tampered after construction, arrive as incoherent receipts.
	var progression_choice: RiftOfferChoiceResult = _base_choice("progression")
	progression_choice.support_fallback_category = COMBAT
	var combat_choice: RiftOfferChoiceResult = _base_choice("combat")
	combat_choice.support_content_kind = FALLBACK_KIND
	var copied_rows: Array = [
		["an I8 fallback naming no category", RiftOfferChoiceResult.chosen_support_fallback(EXAMPLE_SEED,
			PackedStringArray([String(CELERITY)]), NO_CATEGORY, RiftRunBuild.new(), _spent(EXAMPLE_SEED)),
			"the Support level-up's passive fallback names category -1, which no passive lane draws from"],
		["an I8 fallback granting two ids", RiftOfferChoiceResult.chosen_support_fallback(EXAMPLE_SEED,
			PackedStringArray([String(CELERITY), String(POWER)]), COMBAT, RiftRunBuild.new(), _spent(EXAMPLE_SEED)),
			"the Support lane granted 2 identifiers, not 1"],
		["a progression choice tampered with a category", progression_choice,
			"a Support progression names the fallback category 0"],
		["a Combat and Defence choice tampered with PASSIVE_FALLBACK", combat_choice,
			"the Combat and Defence lane declares Support content kind 1"],
	]
	for row: Array in copied_rows:
		var receipt: RiftLevelUpResult = RiftLevelUpResult.taken(row[1])
		if receipt.ok and receipt.problem() == String(row[2]) and receipt.duplicated().problem() == String(row[2]):
			caught += 1
		else:
			escaped.append("%s answered '%s'" % [String(row[0]), receipt.problem()])
	_expect(escaped.is_empty() and caught == rows.size() + copied_rows.size(),
		"%d of %d caught; %s" % [caught, rows.size() + copied_rows.size(), "; ".join(escaped)])
	print("  %d of %d mixed shapes refused by exact message — %d tamperings (the content kind tampered 10 times and the category 7, each alone, across all four shapes; plus identities, a progression, ranks and a lane), each coherent again once restored, and %d mixed choice results copied by taken() and still refused"
		% [caught, rows.size() + copied_rows.size(), rows.size(), copied_rows.size()])
	print("  both one-versus-two mistakes refused: 'the Support lane granted 2 identifiers, not 1' and 'the Support lane granted 1 identifiers, not 2'")
	_done("every_mixed_shape_is_refused_by_exact_message")


# --- 9. The source choice cannot reach the receipt --------------------------------------------------------------------

func _check_mutating_the_source_choice_cannot_reach_the_receipt() -> void:
	print("")
	print("--- 9. Mutating the source choice after the receipt is built cannot alter the receipt")
	var choice: RiftOfferChoiceResult = _fallback_choice(EXAMPLE_SEED)
	var receipt: RiftLevelUpResult = RiftLevelUpResult.taken(choice)
	var before: String = _full_row(receipt)
	var mutations: int = 0
	choice._chosen_identity.append("zz_source_extra")
	choice.support_content_kind = PROGRESSION_KIND
	choice.support_fallback_category = UTILITY
	choice.support_progression_kind = SupportContinuationResult.Kind.NEW_PAIR
	choice.support_rank_after = 5
	choice.lane = UTILITY_LANE
	choice.root_seed = 7
	choice.ok = false
	mutations += 8
	var acquired: String = choice.new_build.acquire_passive_card(PassiveCardCatalogue.record(POWER))
	choice.new_ledger.consume(EXAMPLE_SEED + 1)
	mutations += 2
	_expect(acquired.is_empty() and choice.new_build.acquisitions_for(POWER) == 1 and choice.chosen_identity().size() == 2,
		"the source was not actually mutated: '%s'" % acquired)
	_expect(_full_row(receipt) == before and receipt.problem().is_empty() and receipt.carries_support_fallback(),
		"the receipt moved:\n    was %s\n    now %s" % [before, _full_row(receipt)])
	var objects: PackedStringArray = PackedStringArray()
	for entry: Dictionary in receipt.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0 \
				and int(entry.get("type", TYPE_NIL)) == TYPE_OBJECT:
			objects.append(String(entry.get("name", "")))
	_expect(objects.is_empty(), "the receipt holds the object field(s) %s" % ", ".join(objects))
	print("  the source choice mutated %d ways — its identity, both content scalars, its progression, its lane, seed and success, its build and its ledger — and the receipt did not move; it holds no object field"
		% mutations)
	_done("mutating_the_source_choice_cannot_reach_the_receipt")


# --- 10. Copies ----------------------------------------------------------------------------------------------------------

func _check_receipt_copies_are_independent_in_every_field() -> void:
	print("")
	print("--- 10. A receipt copy carries every field, and copies cannot reach each other")
	var original: RiftLevelUpResult = RiftLevelUpResult.taken(_fallback_choice(EXAMPLE_SEED))
	var first: RiftLevelUpResult = original.duplicated()
	var second: RiftLevelUpResult = original.duplicated()
	var fields_equal: int = 0
	for field: String in EXPECTED_RECEIPT_FIELDS:
		if field == "_granted_identity":
			if first.granted_identity() == original.granted_identity():
				fields_equal += 1
		elif first.get(field) == original.get(field) and second.get(field) == original.get(field):
			fields_equal += 1
	_expect(fields_equal == EXPECTED_RECEIPT_FIELDS.size() and first != original and second != original and first != second,
		"%d of %d fields copied" % [fields_equal, EXPECTED_RECEIPT_FIELDS.size()])
	var line: String = _full_row(original)
	first.support_content_kind = PROGRESSION_KIND
	first.support_fallback_category = UTILITY
	first._granted_identity.append("zz_first_extra")
	_expect(_full_row(first) != line and not first.problem().is_empty(),
		"the first copy was not actually mutated")
	_expect(_full_row(original) == line and _full_row(second) == line and original.problem().is_empty()
			and second.problem().is_empty(),
		"a mutated copy reached the original or another copy")
	original.support_content_kind = NO_CONTENT
	original.support_fallback_category = 2
	original._granted_identity.append("zz_original_extra")
	_expect(_full_row(second) == line and second.problem().is_empty()
			and first.granted_identity().has("zz_first_extra") and not first.granted_identity().has("zz_original_extra"),
		"a mutated original reached a copy")
	## A copy judges nothing: an incoherent receipt's copy is the same incoherent receipt.
	var tampered: RiftLevelUpResult = RiftLevelUpResult.taken(_fallback_choice(EXAMPLE_SEED))
	tampered.support_fallback_category = NO_CATEGORY
	_expect(not tampered.problem().is_empty() and tampered.duplicated().problem() == tampered.problem()
			and tampered.duplicated().support_fallback_category == NO_CATEGORY,
		"copying an incoherent receipt changed its verdict")
	print("  %d of %d fields copied, both content scalars included; a copy mutated in its content kind, category and identity reached neither the original nor a sibling, and a mutated original reached neither copy; an incoherent receipt's copy carries the same verdict"
		% [fields_equal, EXPECTED_RECEIPT_FIELDS.size()])
	_done("receipt_copies_are_independent_in_every_field")


# --- 11. E2 ------------------------------------------------------------------------------------------------------------

func _check_e2_commits_the_fallback_once_with_a_coherent_receipt() -> void:
	print("")
	print("--- 11. The unchanged one-level coordinator commits the fallback exactly once and returns a coherent receipt")
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, _bare_build(2, 2), null)
	var awarded: String = lifecycle.award_experience(E2_AWARD)
	var opened: String = lifecycle.open_offer(E2_REQUIREMENT, _profiles(), _definitions(), _cards(), EXAMPLE_SEED)
	var offered: PackedStringArray = lifecycle.offer_identity_for(SUPPORT_LANE)
	var before: RiftRunBuild = lifecycle.run_build()
	var receipt: RiftLevelUpResult = lifecycle.choose(SUPPORT_LANE)
	var after: RiftRunBuild = lifecycle.run_build()
	_expect(awarded.is_empty() and opened.is_empty() and offered == PackedStringArray([String(CELERITY)]),
		"the lifecycle awarded '%s', opened '%s' with [%s]" % [awarded, opened, ", ".join(offered)])
	## Proof 11: the receipt.
	_expect(receipt.ok and receipt.problem().is_empty() and receipt.root_seed == EXAMPLE_SEED and receipt.root_seed_known
			and receipt.lane == SUPPORT_LANE and receipt.granted_identity() == PackedStringArray([String(CELERITY)])
			and receipt.support_content_kind == FALLBACK_KIND and receipt.support_fallback_category == COMBAT
			and receipt.support_progression_kind == NO_KIND and receipt.support_rank_before == NO_RANK
			and receipt.support_rank_after == NO_RANK and receipt.support_fallback_line() == EXAMPLE_LINE,
		"the coordinator returned %s / '%s'" % [_full_row(receipt), receipt.problem()])
	## Proof 12: one level, one seed, the surplus retained.
	_expect(lifecycle.level() == 2 and lifecycle.experience() == E2_RETAINED and lifecycle.is_completed()
			and not lifecycle.is_offer_active() and lifecycle.frozen_requirement() == RiftLevelUpCoordinator.NO_REQUIREMENT
			and lifecycle.consumption_ledger().count() == 1 and lifecycle.consumption_ledger().has_consumed(EXAMPLE_SEED),
		"level %d, experience %s, seeds [%s]" % [lifecycle.level(), String.num(lifecycle.experience(), 17), _seeds_line(lifecycle.consumption_ledger())])
	## Proof 13: exactly one more acquisition of the card; no support state moved.
	_expect(before.acquisitions_for(CELERITY) == 0 and after.acquisitions_for(CELERITY) == 1
			and after.passive_acquisitions() == before.passive_acquisitions() + 1
			and after.acquisitions_for(POWER) == 0 and after.acquisitions_for(INSIGHT) == 0
			and after.support_pairs() == before.support_pairs() and after.total_support_ranks() == 4
			and after.support_rank_for(QS, REACH) == 2 and after.support_rank_for(QS, SWEEP) == 2
			and after.total_for(&"skill_speed") == 0.10 and after.contribution_count_for(&"skill_speed") == 1,
		"the build moved to %s" % _snapshot(after))
	## The Utility category through the same path.
	var utility: RiftLevelUpCoordinator = _open_fallback_lifecycle(UTILITY_SEED)
	var utility_receipt: RiftLevelUpResult = utility.choose(SUPPORT_LANE)
	_expect(utility_receipt.problem().is_empty() and utility_receipt.carries_support_fallback()
			and utility_receipt.support_fallback_category == UTILITY
			and utility_receipt.granted_identity() == PackedStringArray([String(MAGNETISM)])
			and utility_receipt.support_fallback_line() == UTILITY_LINE
			and utility.level() == 2 and utility.run_build().acquisitions_for(MAGNETISM) == 1
			and _seeds_line(utility.consumption_ledger()) == str(UTILITY_SEED),
		"the Utility fallback reads %s" % _full_row(utility_receipt))
	print("  root seed 18: %s against %s -> Level %d with %s retained, 1 seed consumed [%s], finished, no offer standing; the receipt: %s, category %d"
		% [String.num(E2_AWARD, 1), String.num(E2_REQUIREMENT, 1), lifecycle.level(), String.num(lifecycle.experience(), 1),
			_seeds_line(lifecycle.consumption_ledger()), receipt.support_fallback_line(), receipt.support_fallback_category])
	print("  the committed build: card_celerity held 0 -> 1, skill_speed = %s over %d contribution, card_power and card_insight 0 -> 0, pairs [%s] at ranks 2 / 2 unmoved"
		% [String.num(after.total_for(&"skill_speed"), 17), after.contribution_count_for(&"skill_speed"), ", ".join(after.support_pairs())])
	print("  root seed 2: %s, category %d — Level 2, card_magnetism held once, seed 2 consumed" % [
		utility_receipt.support_fallback_line(), utility_receipt.support_fallback_category])
	_done("e2_commits_the_fallback_once_with_a_coherent_receipt")


# --- 12. G4 ------------------------------------------------------------------------------------------------------------

func _check_g4_records_the_fallback_with_its_run_provenance() -> void:
	print("")
	print("--- 12. The unchanged run-level coordinator records the fallback with its run provenance")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(G4_RUN_SEED)
	var records: Array = _run_support_levels(run)
	var shape: PackedStringArray = PackedStringArray()
	var roots: Array[int] = []
	for record: RiftRunLevelUpResult in records:
		var carried: RiftLevelUpResult = record.level_up()
		roots.append(carried.root_seed)
		shape.append("L%d %s" % [record.source_level, "fallback" if carried.carries_support_fallback() else carried.support_progression_line()])
	_expect(records.size() == G4_FALLBACK_LEVEL and roots == G4_ROOTS,
		"the run took %d levels at roots %s" % [records.size(), str(roots)])
	var record: RiftRunLevelUpResult = records[G4_FALLBACK_LEVEL - 1]
	var receipt: RiftLevelUpResult = record.level_up()
	## Proof 14: the run seed, the source level and a coherent nested fallback receipt.
	_expect(record.run_seed == G4_RUN_SEED and record.source_level == G4_FALLBACK_LEVEL
			and record.problem().is_empty() and record.succeeded() and record.failure_reason().is_empty()
			and record.describe() == G4_FALLBACK_DESCRIBE,
		"the record reads %s / '%s'" % [record.describe(), record.problem()])
	_expect(receipt.ok and receipt.problem().is_empty() and receipt.root_seed == G4_FALLBACK_ROOT
			and receipt.lane == SUPPORT_LANE and receipt.granted_identity() == PackedStringArray([String(POWER)])
			and receipt.support_content_kind == FALLBACK_KIND and receipt.support_fallback_category == COMBAT
			and receipt.support_progression_kind == NO_KIND and receipt.support_rank_before == NO_RANK
			and receipt.support_rank_after == NO_RANK and receipt.support_fallback_line() == G4_FALLBACK_LINE,
		"the nested receipt reads %s" % _full_row(receipt))
	## Proof 15: every level_up() is an independent copy carrying the new facts.
	var one: RiftLevelUpResult = record.level_up()
	var two: RiftLevelUpResult = record.level_up()
	var line: String = _full_row(two)
	one.support_content_kind = PROGRESSION_KIND
	one.support_fallback_category = UTILITY
	one._granted_identity.append("zz_handed_extra")
	_expect(one != two and _full_row(one) != line and _full_row(two) == line
			and _full_row(record.level_up()) == line and record.problem().is_empty(),
		"a handed-out receipt reached the record or another copy")
	var fields: PackedStringArray = _fields_of(record)
	_expect(fields == PackedStringArray(["run_seed", "source_level", "_level_up"])
			and not fields.has("support_content_kind") and not fields.has("support_fallback_category"),
		"the run-level record carries %s" % ", ".join(fields))
	## G2 still places the fallback record: moving its source level breaks it.
	record.source_level = G4_FALLBACK_LEVEL - 1
	var moved: String = record.problem()
	record.source_level = G4_FALLBACK_LEVEL
	_expect(moved.contains("derives root seed") and record.problem().is_empty(),
		"a moved source level reads '%s'" % moved)
	## The build holds the card once more, and no support moved.
	var build: RiftRunBuild = run.run_build()
	_expect(build.acquisitions_for(POWER) == 1 and build.passive_acquisitions() == 1
			and build.support_rank_for(QS, REACH) == 2 and build.support_rank_for(QS, SWEEP) == 2
			and build.total_support_ranks() == 4,
		"the run build reads %s" % _snapshot(build))
	print("  run seed 99, Support at every level: %s at roots %s" % [", ".join(shape), str(roots)])
	print("  the Level 5 record: '%s', problem() empty; its receipt: root seed %d, Support, [card_power], PASSIVE_FALLBACK, category %d — '%s'"
		% [record.describe(), receipt.root_seed, receipt.support_fallback_category, receipt.support_fallback_line()])
	print("  level_up() hands out independent copies carrying both content scalars; the record keeps its three fields and no fallback field of its own; G2 still refuses the record at a moved level")
	_done("g4_records_the_fallback_with_its_run_provenance")


# --- 13. Continuation ---------------------------------------------------------------------------------------------------

func _check_continuing_the_lifecycle_keeps_the_card_and_the_spent_seed() -> void:
	print("")
	print("--- 13. Continuing a completed fallback lifecycle keeps the acquired card and the consumed seed")
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, _bare_build(2, 2), null)
	lifecycle.award_experience(E2_AWARD)
	lifecycle.open_offer(E2_REQUIREMENT, _profiles(), _definitions(), _cards(), EXAMPLE_SEED)
	lifecycle.choose(SUPPORT_LANE)
	var finished: String = _lifecycle_row(lifecycle)
	var next: RiftLevelUpCoordinator = lifecycle.next_level_coordinator()
	_expect(next != null and next.level() == 2 and next.experience() == E2_RETAINED and not next.is_completed()
			and not next.is_offer_active() and next.run_build().acquisitions_for(CELERITY) == 1
			and next.run_build().total_support_ranks() == 4
			and _seeds_line(next.consumption_ledger()) == str(EXAMPLE_SEED)
			and _lifecycle_row(lifecycle) == finished,
		"the continuation reads %s" % ("null" if next == null else _lifecycle_row(next)))
	## The consumed seed travels: the same root seed opens (opening is not consuming) and its
	## fallback is refused as already spent, with nothing moved.
	var opened: String = next.open_offer(E2_RETAINED, _profiles(), _definitions(), _cards(), EXAMPLE_SEED)
	var standing: String = _lifecycle_row(next)
	var refused: RiftLevelUpResult = next.choose(SUPPORT_LANE)
	_expect(opened.is_empty() and not refused.ok and refused.failure_reason == SPENT_REASON
			and _refused_whole(refused) and _lifecycle_row(next) == standing,
		"the spent seed answered '%s'" % refused.failure_reason)
	## A fresh root seed continues from the carried build: its Support lane is a fallback again.
	var onward: RiftLevelUpCoordinator = lifecycle.next_level_coordinator()
	onward.open_offer(E2_RETAINED, _profiles(), _definitions(), _cards(), 0)
	var again: RiftLevelUpResult = onward.choose(SUPPORT_LANE)
	var build: RiftRunBuild = onward.run_build()
	_expect(again.ok and again.problem().is_empty() and again.carries_support_fallback()
			and build.passive_acquisitions() == 2 and build.acquisitions_for(CELERITY) >= 1
			and build.total_support_ranks() == 4 and onward.level() == 3
			and _seeds_line(onward.consumption_ledger()) == "0, 18",
		"the onward fallback reads %s at %s" % [_full_row(again), _lifecycle_row(onward)])
	print("  the continuation begins at Level 2 with %s retained, card_celerity held once, ranks 2 / 2 and seed 18 spent; the completed lifecycle is untouched"
		% String.num(E2_RETAINED, 1))
	print("  root seed 18 opens again and its fallback is refused — '%s' — with nothing moved; root seed 0 then takes %s: two passive acquisitions, seeds [%s], Level 3"
		% [refused.failure_reason, again.support_fallback_line(), _seeds_line(onward.consumption_ledger())])
	_done("continuing_the_lifecycle_keeps_the_card_and_the_spent_seed")


# --- 14. Nothing automatic ----------------------------------------------------------------------------------------------

func _check_nothing_opens_or_advances_by_itself() -> void:
	print("")
	print("--- 14. No second offer opens and no level advances by itself")
	var lifecycle: RiftLevelUpCoordinator = _open_fallback_lifecycle(EXAMPLE_SEED)
	lifecycle.choose(SUPPORT_LANE)
	var finished: String = _lifecycle_row(lifecycle)
	var refused: int = 0
	for attempt: String in [lifecycle.award_experience(E2_REQUIREMENT),
			lifecycle.open_offer(E2_REQUIREMENT, _profiles(), _definitions(), _cards(), 0)]:
		if not attempt.is_empty():
			refused += 1
	for lane: int in RiftOffer.LANE_ORDER:
		if not lifecycle.choose(lane).ok:
			refused += 1
	_expect(refused == 5 and _lifecycle_row(lifecycle) == finished and lifecycle.level() == 2,
		"%d of 5 operations refused after the fallback; the lifecycle reads %s" % [refused, _lifecycle_row(lifecycle)])
	## G4 with surplus that already meets the next requirement.
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(G4_RUN_SEED)
	_run_support_levels(run)
	var reading: RiftLevelRequirementReading = run.requirement_reading()
	_expect(run.level() == G4_FALLBACK_LEVEL + 1 and run.experience() == G4_RETAINED and not run.is_offer_active()
			and reading.ok and reading.experience_requirement() == G4_NEXT_REQUIREMENT
			and run.experience() >= reading.experience_requirement() and run.level() == G4_FALLBACK_LEVEL + 1,
		"after the fallback the run reads level %d, %s retained, offer %s" % [run.level(), String.num(run.experience(), 17), run.is_offer_active()])
	var opened: String = run.open_current_offer(_profiles(), _definitions(), _cards())
	_expect(opened.is_empty() and run.is_offer_active() and run.level() == G4_FALLBACK_LEVEL + 1,
		"an explicit open answered '%s'" % opened)
	print("  after the E2 fallback: %d of 5 later operations refused and the lifecycle unmoved at Level 2" % refused)
	print("  after the G4 fallback: Level %d with %s retained against a requirement of %s — no offer stands until one is explicitly opened, and opening it moves no level"
		% [G4_FALLBACK_LEVEL + 1, String.num(G4_RETAINED, 1), String.num(G4_NEXT_REQUIREMENT, 1)])
	_done("nothing_opens_or_advances_by_itself")


# --- 15. Nothing running ----------------------------------------------------------------------------------------------

func _check_nothing_running_consumes_or_displays_the_fallback_receipt() -> void:
	print("")
	print("--- 15. Nothing that runs or renders consumes or displays the fallback receipt")
	var scanned: int = 0
	var stray: PackedStringArray = PackedStringArray()
	var readers: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			scanned += 1
			var text: String = FileAccess.get_file_as_string(path)
			for member: String in NEW_MEMBERS:
				if text.contains(member) and not _owner_may_name(path, member):
					stray.append("%s names %s" % [path.get_file(), member])
			if path != RECEIPT_FILE and text.contains("RiftLevelUpResult"):
				readers.append(path)
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for member: String in NEW_MEMBERS:
		if settings.contains(member):
			stray.append("project.godot names %s" % member)
	readers.sort()
	var expected_readers: PackedStringArray = PackedStringArray(RECEIPT_READERS)
	expected_readers.sort()
	_expect(scanned > 100 and stray.is_empty(), "%d files scanned; %s" % [scanned, ", ".join(stray)])
	_expect(readers == expected_readers, "the receipt's class is named by %s" % ", ".join(readers))
	var reading_members: PackedStringArray = PackedStringArray()
	for path: String in RECEIPT_READERS:
		for member: String in NEW_MEMBERS:
			if FileAccess.get_file_as_string(path).contains(member) and not _owner_may_name(path, member):
				reading_members.append("%s names %s" % [path.get_file(), member])
	_expect(reading_members.is_empty(), "; ".join(reading_members))
	## Roguelite I11 (D-314), one for one: no single OFFERED_LEVEL any longer — the running review
	## asks each level's offer once, behind one integer guard whose empty value is NO_LEVEL_ASKED.
	var review_constants: Dictionary = _constants(REVIEW_FILE)
	var fresh_fallbacks: int = 0
	for root_seed: int in SEED_SAMPLES:
		if _compose(AcquiredSupports.new(), _cards(), root_seed).support_content_kind == FALLBACK_KIND:
			fresh_fallbacks += 1
	_expect(not review_constants.has("OFFERED_LEVEL") and review_constants.get("NO_LEVEL_ASKED") == 0 and fresh_fallbacks == 0,
		"the running review declares %s; a fresh build composed %d fallbacks" % [str(review_constants.keys()), fresh_fallbacks])
	_expect(_action_count() == EXPECTED_ACTIONS and not settings.contains("[autoload]")
			and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT,
		"project.godot holds %d actions" % _action_count())
	print("  %d running files scanned: outside the receipt, only the choice result, the transaction, the offer and — since I10 (D-312) — both coordinators, the mote runtime and the running review name any of the receipt's four new members, each only its own; project.godot names none"
		% scanned)
	print("  the receipt's class is named by exactly %d running files — the one-level coordinator, the run-level coordinator and record, and the running review — and none of them names a new member beyond its I10 (D-312) grant"
		% readers.size())
	print("  the running review asks each level's offer once (I11, D-314), beginning at Level 1, and a fresh build composes 0 fallbacks over %d root seeds; project.godot: %d actions, the Prototype App entrypoint, no [autoload]"
		% [SEED_SAMPLES, _action_count()])
	_done("nothing_running_consumes_or_displays_the_fallback_receipt")


# --- 16. The shape and the seams --------------------------------------------------------------------------------------

func _check_the_receipt_shape_and_its_seams_are_pinned() -> void:
	print("")
	print("--- 16. The receipt holds exactly its shape, and neither coordinator moved")
	var fields: PackedStringArray = _fields_of(RiftLevelUpResult.new())
	var methods: PackedStringArray = _methods_of(RECEIPT_FILE)
	_expect(fields == PackedStringArray(EXPECTED_RECEIPT_FIELDS), "the receipt carries %s" % ", ".join(fields))
	_expect(methods == PackedStringArray(EXPECTED_RECEIPT_METHODS), "the receipt declares %s" % ", ".join(methods))
	_expect(_named_classes(RECEIPT_FILE) == PackedStringArray(EXPECTED_RECEIPT_CLASSES),
		"the receipt names %s" % ", ".join(_named_classes(RECEIPT_FILE)))
	var fresh: RiftLevelUpResult = RiftLevelUpResult.new()
	var source: String = FileAccess.get_file_as_string(RECEIPT_FILE)
	_expect(typeof(fresh.support_content_kind) == TYPE_INT and typeof(fresh.support_fallback_category) == TYPE_INT
			and fresh.support_content_kind == NO_CONTENT and fresh.support_fallback_category == NO_CATEGORY
			and source.contains("var support_content_kind: int = RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND\n")
			and source.contains("var support_fallback_category: int = RiftOfferChoiceResult.NO_FALLBACK_CATEGORY\n"),
		"the new defaults are not the accepted sentinels")
	var present: PackedStringArray = PackedStringArray()
	for member: String in FORBIDDEN_RECEIPT_MEMBERS:
		if fields.has(member) or fresh.has_method(member):
			present.append(member)
	_expect(present.is_empty(), "the receipt carries forbidden member(s) %s" % ", ".join(present))

	## THE SEAMS, READ FROM THE CODE.
	var code: String = _code(RECEIPT_FILE)
	var copy_body: String = _function_body(code, "duplicated")
	var problem_body: String = _function_body(code, "problem")
	_expect(code.count("RiftOfferChoiceResult.identity_size_for_content(lane, support_content_kind)") == 1
			and not code.contains("identity_size_for(") and code.count("RiftOffer.support_transition_problem(") == 1
			and copy_body.contains("copy.support_content_kind = support_content_kind")
			and copy_body.contains("copy.support_fallback_category = support_fallback_category")
			and copy_body.contains("copy._granted_identity = _granted_identity.duplicate()")
			and problem_body.count("RiftOffer.category_for_lane(") == 2,
		"the receipt's seams are not the accepted readings")
	var presentation_leaks: PackedStringArray = PackedStringArray()
	for name: String in ["identity_line", "describe", "support_progression_line"]:
		if _function_body(code, name).contains("fallback"):
			presentation_leaks.append(name)
	for token: String in ["support_fallback_card_id", "selected_card_id", "display_name", "magnitude", "new_build", "new_ledger"]:
		if code.contains(token):
			presentation_leaks.append(token)
	_expect(presentation_leaks.is_empty(), "the receipt names %s" % ", ".join(presentation_leaks))
	var coordinators: PackedStringArray = PackedStringArray()
	for path: String in [E2_COORDINATOR_FILE, G4_COORDINATOR_FILE, G4_RECORD_FILE]:
		for member: String in NEW_MEMBERS:
			if FileAccess.get_file_as_string(path).contains(member) and not _owner_may_name(path, member):
				coordinators.append("%s names %s" % [path.get_file(), member])
	_expect(coordinators.is_empty() and _listing("res://scripts/levels") == PackedStringArray([
			"rift_level_up_coordinator.gd", "rift_level_up_coordinator.gd.uid", "rift_level_up_result.gd",
			"rift_level_up_result.gd.uid", "rift_run_level_coordinator.gd", "rift_run_level_coordinator.gd.uid",
			"rift_run_level_up_result.gd", "rift_run_level_up_result.gd.uid"]),
		"%s; scripts/levels/ holds %s" % [", ".join(coordinators), ", ".join(_listing("res://scripts/levels"))])
	print("  the receipt: %d fields (the accepted 9 plus 2 appended) and %d methods (the accepted 11 plus 2); it names exactly %d project classes and holds no forbidden member"
		% [fields.size(), methods.size(), EXPECTED_RECEIPT_CLASSES.size()])
	print("  STRUCTURAL, read from the code: problem() asks identity_size_for_content() once and the shared transition rule once, and reads the passive categories through the offer's own lane vocabulary; duplicated() assigns both new scalars; identity_line(), describe() and the progression line name no fallback")
	print("  neither coordinator nor the run-level record names a new member outside I10's (D-312) two standing-offer readings; scripts/levels/ still holds its 4 scripts and 4 uid files")
	_done("the_receipt_shape_and_its_seams_are_pinned")


# --- 17. Accepted files and suites --------------------------------------------------------------------------------------

func _check_accepted_files_and_suites_moved_one_for_one() -> void:
	print("")
	print("--- 17. Every accepted file outside the receipt is byte-identical, and the moved pins are present")
	var unchanged: int = 0
	for row: Array in UNCHANGED_HASHES:
		var digest: String = FileAccess.get_sha256(String(row[0]))
		if digest.begins_with(String(row[1])):
			unchanged += 1
		else:
			_expect(false, "%s hashes %s, not %s…" % [String(row[0]), digest.left(8), String(row[1])])
	_expect(unchanged == UNCHANGED_HASHES.size() and FileAccess.get_sha256(RECEIPT_FILE).begins_with(RECEIPT_PREFIX),
		"%d of %d unchanged; the receipt hashes %s" % [unchanged, UNCHANGED_HASHES.size(), FileAccess.get_sha256(RECEIPT_FILE).left(8)])

	var receipt_signatures_added: Array[String] = ["carries_support_fallback() -> bool", "support_fallback_line() -> String"]
	var e2: Dictionary = _constants(E2_SUITE)
	var f5: Dictionary = _constants(F5_SUITE)
	var g3: Dictionary = _constants(G3_SUITE)
	var g4: Dictionary = _constants(G4_SUITE)
	var e2_signatures: Array = e2.get("EXPECTED_RESULT_SIGNATURES", [])
	var permit: Array = []
	for row: Array in e2.get("PERMITTED_DEFERRED_TOKENS", []):
		if String(row[0]) == RECEIPT_FILE:
			permit = row[1]
	_expect(e2_signatures.size() == 13 and e2_signatures.has(receipt_signatures_added[0])
			and e2_signatures.has(receipt_signatures_added[1])
			and str(e2.get("EXPECTED_RESULT_FIELDS")) == str(EXPECTED_RECEIPT_FIELDS)
			and str(permit) == str(["rank", "fallback"]),
		"the E2 suite's pins do not carry the move")
	_expect(str(f5.get("EXPECTED_RESULT_SIGNATURES")) == str(e2_signatures)
			and str(f5.get("EXPECTED_RESULT_FIELDS")) == str(EXPECTED_RECEIPT_FIELDS)
			and FileAccess.get_file_as_string(F5_SUITE).contains("[\\\"res://scripts/levels/rift_level_up_result.gd\\\", [\\\"rank\\\", \\\"fallback\\\"]]")
			and FileAccess.get_file_as_string(F5_RUNNER).contains("11 fields and 13 methods pinned"),
		"the F5 suite or runner does not carry the move")
	_expect(str(g3.get("ACCEPTED_RESULT_SIGNATURES")) == str(e2_signatures)
			and str(g3.get("ACCEPTED_RESULT_FIELDS")) == str(EXPECTED_RECEIPT_FIELDS),
		"the G3 suite's pins do not carry the move")
	var g4_signatures: Array = g4.get("ACCEPTED_E2_RESULT_SIGNATURES", [])
	_expect(g4_signatures.size() == 12 and g4_signatures.has(receipt_signatures_added[0])
			and g4_signatures.has(receipt_signatures_added[1]) and not g4_signatures.has("duplicated() -> Object")
			and str(g4.get("ACCEPTED_E2_RESULT_FIELDS")) == str(EXPECTED_RECEIPT_FIELDS)
			and FileAccess.get_file_as_string(G4_RUNNER).contains("and its two Support-content fields and two readings under I9"),
		"the G4 suite or runner does not carry the move")

	var hash_rows: Array = []
	for pair: Array in [[I6_SUITE, "ACCEPTED_HASHES", 24], [I7_SUITE, "UNCHANGED_HASHES", 27], [I8_SUITE, "UNCHANGED_HASHES", 25]]:
		var rows: Array = _constants(String(pair[0])).get(String(pair[1]), [])
		var prefix: String = ""
		for row: Array in rows:
			if String(row[0]) == RECEIPT_FILE:
				prefix = String(row[1])
		hash_rows.append("%s %s (%d)" % [String(pair[0]).get_file(), prefix, rows.size()])
		_expect(prefix == RECEIPT_PREFIX and rows.size() == int(pair[2]),
			"%s pins the receipt at '%s' over %d rows" % [String(pair[0]).get_file(), prefix, rows.size()])
	var i7: Dictionary = _constants(I7_SUITE)
	var i7_receipt_grant: Array = []
	for row: Array in i7.get("CONSUMING_READERS", []):
		if String(row[0]) == RECEIPT_FILE:
			i7_receipt_grant = row[1]
	var i7_runner: String = FileAccess.get_file_as_string(I7_RUNNER)
	## Roguelite I10 (D-312) added four consuming readers to I7's three: seven.
	_expect((i7.get("CONSUMING_READERS", []) as Array).size() == 7 and i7_receipt_grant.size() == 5
			and String(i7.get("E2_FALLBACK_RECEIPT_LINE", "")) == EXAMPLE_LINE and not i7.has("E2_FALLBACK_RECEIPT_PROBLEM")
			and i7_runner.contains("*/scripts/choices/rift_offer_choice.gd|*/scripts/choices/rift_offer_choice_result.gd|*/scripts/levels/rift_level_up_result.gd)")
			and i7_runner.contains("and since I9 (D-310) its receipt is coherent and records it"),
		"the I7 suite or runner does not carry the move")
	var i8: Dictionary = _constants(I8_SUITE)
	var i8_owed: Array = i8.get("OWED_CHECKS", [])
	var i8_runner: String = FileAccess.get_file_as_string(I8_RUNNER)
	_expect(str(i8.get("RECEIPT_I8_TOKENS")) == str(["carries_support_fallback", "identity_size_for_content", "support_fallback_category", "NO_FALLBACK_CATEGORY"])
			and String(i8.get("E2_FALLBACK_RECEIPT_LINE", "")) == EXAMPLE_LINE and not i8.has("E2_FALLBACK_RECEIPT_PROBLEM")
			and i8_owed.size() == 17 and i8_owed.has("the_downstream_receipt_path_records_the_fallback_since_i9")
			and not i8_owed.has("the_downstream_receipt_path_is_measured_and_not_repaired")
			and i8_runner.contains("carries_support_fallback|identity_size_for_content|support_fallback_category|NO_FALLBACK_CATEGORY)")
			and i8_runner.contains("THE BINDING PREREQUISITE D-308 RECORDED IS MET BY I9 (D-310)"),
		"the I8 suite or runner does not carry the move")
	print("  %d of %d accepted production files byte-identical by SHA-256 prefix to the tree before the first I9 edit, except both coordinators and the mote runtime, pinned at their D-312 hashes, and the running review and its panel, at their D-314 hashes, and the seam, its result and the live-effect review, at their D-320 hashes, the result at its D-321 hash, the panel at its D-322 hash —both choice files, the offer and composer, the I6 fallback, the ledger, the run build, the card records and selector, the acquisition record, the continuation, both coordinators and the run-level record, the track, G1, G2, the mote runtime, the running review and its panel, the live-effect seam and review, and project.godot"
		% [unchanged, UNCHANGED_HASHES.size()])
	print("  the receipt %s… (was %s…)" % [FileAccess.get_sha256(RECEIPT_FILE).left(8), PRE_I9_RECEIPT_PREFIX])
	print("  E2: two signature rows, two field rows and the fallback permit; F5: the same pins and its permit text; G3 and G4: the same receipt pins; hash rows: %s; I7: the receipt as its third consuming reader; I8: check 15 renamed and moved, the receipt's four-member grant"
		% ", ".join(PackedStringArray(hash_rows)))
	_done("accepted_files_and_suites_moved_one_for_one")


# --- The corpus: identical to the pre-I9 probe ----------------------------------------------------------------------------

## [unchanged rows, moving receipts and records]. A moving row is a successful Support-lane
## receipt whose lane carried a passive fallback: the one class I9 is authorized to move.
func _corpus() -> Array:
	var rows: PackedStringArray = PackedStringArray()
	var moving: Array = []
	var profiles: Array[SkillTagProfile] = SkillSupportCatalogue.skill_profiles()
	var definitions: Array[SupportDefinition] = SkillSupportCatalogue.support_definitions()
	var cards: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	var seeds: Array[int] = []
	for s: int in 64:
		seeds.append(s)
	seeds.append_array(SPECIAL_SEEDS)

	## 1. One E2 lifecycle per state, seed and lane.
	for state: Array in STATES:
		for root_seed: int in seeds:
			for lane: int in RiftOffer.LANE_ORDER:
				var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(
					null, _bare_build(int(state[0]), int(state[1])), null)
				var awarded: String = lifecycle.award_experience(100.0)
				var opened: String = lifecycle.open_offer(100.0, profiles, definitions, cards, root_seed)
				var fallback: bool = lane == RiftOffer.Lane.SUPPORT \
					and lifecycle.offer_identity_for(RiftOffer.Lane.SUPPORT).size() == 1
				var receipt: RiftLevelUpResult = lifecycle.choose(lane)
				var row: String = "E2 R%d S%d seed %d lane %d: award='%s' open='%s' | %s | %s" % [
					state[0], state[1], root_seed, lane, awarded, opened, _receipt_row(receipt), _lifecycle_row(lifecycle)]
				if fallback:
					moving.append(receipt)
				else:
					rows.append(row)

	## 2. E2 refusals: undeclared lanes, no offer, after completion, and a spent seed.
	for state: Array in STATES:
		for root_seed: int in 16:
			var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(
				null, _bare_build(int(state[0]), int(state[1])), null)
			rows.append("E2 no offer R%d S%d: %s" % [state[0], state[1], _receipt_row(lifecycle.choose(RiftOffer.Lane.SUPPORT))])
			lifecycle.award_experience(100.0)
			lifecycle.open_offer(100.0, profiles, definitions, cards, root_seed)
			for lane: int in UNDECLARED_LANES:
				rows.append("E2 undeclared R%d S%d seed %d lane %d: %s | %s" % [
					state[0], state[1], root_seed, lane, _receipt_row(lifecycle.choose(lane)), _lifecycle_row(lifecycle)])
			var spent: RiftConsumptionLedger = RiftConsumptionLedger.new()
			spent.consume(root_seed)
			var stale: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(
				null, _bare_build(int(state[0]), int(state[1])), spent)
			stale.award_experience(100.0)
			stale.open_offer(100.0, profiles, definitions, cards, root_seed)
			for lane: int in RiftOffer.LANE_ORDER:
				rows.append("E2 spent R%d S%d seed %d lane %d: %s | %s" % [
					state[0], state[1], root_seed, lane, _receipt_row(stale.choose(lane)), _lifecycle_row(stale)])
	var finished: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, null, null)
	finished.award_experience(100.0)
	finished.open_offer(100.0, profiles, definitions, cards, 0)
	finished.choose(RiftOffer.Lane.UTILITY)
	for lane: int in [0, 1, 2, 7]:
		rows.append("E2 finished lane %d: %s | %s" % [lane, _receipt_row(finished.choose(lane)), _lifecycle_row(finished)])

	## 3. The constructors, driven directly.
	rows.append("taken(null): %s" % _receipt_row(RiftLevelUpResult.taken(null)))
	rows.append("taken(refused): %s" % _receipt_row(RiftLevelUpResult.taken(
		RiftOfferChoiceResult.refused("zz refused", 5, 0))))
	rows.append("refused: %s" % _receipt_row(RiftLevelUpResult.refused("zz refused", 5, 7)))
	rows.append("refused blank: %s" % _receipt_row(RiftLevelUpResult.refused("  ", 5, 1)))
	rows.append("refused_without_a_seed: %s" % _receipt_row(RiftLevelUpResult.refused_without_a_seed("zz none", 2)))
	for shape: Array in [
		[0, 0, ["quick_strike", "reaching_edge"], SupportContinuationResult.Kind.NEW_PAIR, 0, 1],
		[18, 0, ["quick_strike", "sweeping_edge"], SupportContinuationResult.Kind.RANK_INCREASE, 1, 2],
		[0, 1, ["card_vitality"], RiftOffer.UNRESOLVED_PROGRESSION_KIND, 0, 0],
		[0, 2, ["card_magnetism"], RiftOffer.UNRESOLVED_PROGRESSION_KIND, 0, 0],
		[3, 0, ["quick_strike", "reaching_edge"], RiftOffer.UNRESOLVED_PROGRESSION_KIND, 0, 0],
		[3, 1, ["card_vitality"], SupportContinuationResult.Kind.NEW_PAIR, 0, 1],
		[3, 0, ["quick_strike"], SupportContinuationResult.Kind.NEW_PAIR, 0, 1],
		[3, 2, ["card_power", "card_insight"], RiftOffer.UNRESOLVED_PROGRESSION_KIND, 0, 0],
	]:
		var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
		ledger.consume(int(shape[0]))
		var choice: RiftOfferChoiceResult = RiftOfferChoiceResult.chosen(int(shape[0]), int(shape[1]),
			PackedStringArray(shape[2]), int(shape[3]), int(shape[4]), int(shape[5]), RiftRunBuild.new(), ledger)
		rows.append("taken(chosen %s): %s" % [str(shape), _receipt_row(RiftLevelUpResult.taken(choice))])

	## 4. G4 runs, each level asked explicitly.
	for run_seed: int in RUN_SEEDS:
		for sequence: Array in RUN_SEQUENCES:
			var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(run_seed)
			rows.append("G4 %d %s no offer: %s" % [run_seed, str(sequence), _record_row(run.choose(0))])
			var award: String = run.award_experience(750.0)
			for step: int in sequence.size():
				var lane: int = int(sequence[step])
				var opened: String = run.open_current_offer(profiles, definitions, cards)
				rows.append("G4 %d %s step %d undeclared: %s" % [run_seed, str(sequence), step, _record_row(run.choose(7))])
				var fallback: bool = lane == RiftOffer.Lane.SUPPORT \
					and run.offer_identity_for(RiftOffer.Lane.SUPPORT).size() == 1
				var record: RiftRunLevelUpResult = run.choose(lane)
				var row: String = "G4 %d %s step %d lane %d: award='%s' open='%s' | %s | %s" % [
					run_seed, str(sequence), step, lane, award, opened, _record_row(record), _run_row(run)]
				if fallback:
					moving.append(record)
				else:
					rows.append(row)
	return [rows, moving]


## PRE-I9 MEMBERS ONLY — verbatim from the probe that measured the digest.
func _receipt_row(r: RiftLevelUpResult) -> String:
	_seen.append(r)
	var copy: RiftLevelUpResult = r.duplicated()
	return "%s | copy_equal=%s" % [_receipt_core(r), _receipt_core(copy) == _receipt_core(r) and copy != r]


func _receipt_core(r: RiftLevelUpResult) -> String:
	return "ok=%s reason='%s' seed=%d known=%s lane=%d kind=%d ranks=%d->%d ids=[%s] carries=%s problem='%s' line=%s prog=%s describe=%s" % [
		r.ok, r.failure_reason, r.root_seed, r.root_seed_known, r.lane, r.support_progression_kind,
		r.support_rank_before, r.support_rank_after, ", ".join(r.granted_identity()),
		r.carries_support_progression(), r.problem(), r.identity_line(), r.support_progression_line(), r.describe()]


func _record_row(record: RiftRunLevelUpResult) -> String:
	var carried: String = "none" if record.level_up() == null else _receipt_row(record.level_up())
	return "run=%d level=%d succeeded=%s reason='%s' problem='%s' describe=%s receipt={%s}" % [
		record.run_seed, record.source_level, record.succeeded(), record.failure_reason(),
		record.problem(), record.describe(), carried]


func _lifecycle_row(lifecycle: RiftLevelUpCoordinator) -> String:
	return "level=%d exp=%s done=%s offer=%s next=%s ledger=[%s] build={%s}" % [
		lifecycle.level(), String.num(lifecycle.experience(), 17), lifecycle.is_completed(),
		lifecycle.is_offer_active(), lifecycle.next_level_coordinator() != null,
		_seeds_line(lifecycle.consumption_ledger()), _snapshot(lifecycle.run_build())]


func _run_row(run: RiftRunLevelCoordinator) -> String:
	return "level=%d exp=%s offer=%s ledger=[%s] build={%s}" % [
		run.level(), String.num(run.experience(), 17), run.is_offer_active(),
		_seeds_line(run.consumption_ledger()), _snapshot(run.run_build())]


## The pre-I9 row plus the I9 fields and reading.
func _full_row(r: RiftLevelUpResult) -> String:
	return "%s | content=%d category=%d fallback=%s fline=%s" % [_receipt_core(r), r.support_content_kind,
		r.support_fallback_category, r.carries_support_fallback(), r.support_fallback_line()]


# --- Helpers -------------------------------------------------------------------------------------------------------------

func _profiles() -> Array[SkillTagProfile]:
	return SkillSupportCatalogue.skill_profiles()


func _definitions() -> Array[SupportDefinition]:
	return SkillSupportCatalogue.support_definitions()


func _cards() -> Array[PassiveCardDefinition]:
	return PassiveCardCatalogue.records()


func _compose(held: AcquiredSupports, cards: Array[PassiveCardDefinition], root_seed: int) -> RiftOffer:
	return RiftOfferComposition.compose(_profiles(), _definitions(), held, cards, root_seed)


## The shipped pairs at the given ranks, as an acquisition record.
func _held(reaching: int, sweeping: int) -> AcquiredSupports:
	var record: AcquiredSupports = AcquiredSupports.new()
	for row: Array in [[REACH, reaching], [SWEEP, sweeping]]:
		if int(row[1]) >= 1:
			record.acquire(QS, row[0] as StringName)
		for _step: int in range(int(row[1]) - 1):
			record.increase_rank(QS, row[0] as StringName)
	return record


func _bare_build(reaching: int, sweeping: int) -> RiftRunBuild:
	var build: RiftRunBuild = RiftRunBuild.new()
	for row: Array in [[REACH, reaching], [SWEEP, sweeping]]:
		if int(row[1]) >= 1:
			build.acquire_support(QS, row[0] as StringName)
		for _step: int in range(int(row[1]) - 1):
			build.rank_support(QS, row[0] as StringName)
	return build


func _spent(root_seed: int) -> RiftConsumptionLedger:
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	ledger.consume(root_seed)
	return ledger


## I8's fallback choice at `root_seed`, both shipped supports at rank 2.
func _fallback_choice(root_seed: int) -> RiftOfferChoiceResult:
	return RiftOfferChoice.choose(_compose(_held(2, 2), _cards(), root_seed), SUPPORT_LANE,
		_bare_build(2, 2), RiftConsumptionLedger.new())


## A lifecycle holding `build` whose experience reaches `requirement`, with no offer yet.
func _ready_lifecycle(build: RiftRunBuild, requirement: float) -> RiftLevelUpCoordinator:
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, build, null)
	lifecycle.award_experience(requirement)
	return lifecycle


## A lifecycle at R2 S2 with the fallback offer of `root_seed` standing.
func _open_fallback_lifecycle(root_seed: int) -> RiftLevelUpCoordinator:
	var lifecycle: RiftLevelUpCoordinator = _ready_lifecycle(_bare_build(2, 2), E2_REQUIREMENT)
	lifecycle.open_offer(E2_REQUIREMENT, _profiles(), _definitions(), _cards(), root_seed)
	return lifecycle


## Takes the Support lane at every level up to and including the fallback at Level 5.
func _run_support_levels(run: RiftRunLevelCoordinator) -> Array:
	var records: Array = []
	run.award_experience(G4_AWARD)
	for _step: int in G4_FALLBACK_LEVEL:
		run.open_current_offer(_profiles(), _definitions(), _cards())
		records.append(run.choose(SUPPORT_LANE))
	return records


## A fresh coherent choice result of one shape.
func _base_choice(kind: String) -> RiftOfferChoiceResult:
	match kind:
		"fallback":
			return _fallback_choice(EXAMPLE_SEED)
		"progression":
			return RiftOfferChoice.choose(_compose(AcquiredSupports.new(), _cards(), 0), SUPPORT_LANE, RiftRunBuild.new(), RiftConsumptionLedger.new())
		"combat":
			return RiftOfferChoice.choose(_compose(AcquiredSupports.new(), _cards(), 0), COMBAT_LANE, RiftRunBuild.new(), RiftConsumptionLedger.new())
		"utility":
			return RiftOfferChoice.choose(_compose(AcquiredSupports.new(), _cards(), 0), UTILITY_LANE, RiftRunBuild.new(), RiftConsumptionLedger.new())
	return RiftOfferChoiceResult.refused("zz refused for this check", 5, SUPPORT_LANE)


## A fresh coherent receipt of one shape.
func _base(kind: String) -> RiftLevelUpResult:
	if kind == "refusal":
		return RiftLevelUpResult.refused("zz refused for this check", 5, SUPPORT_LANE)
	return RiftLevelUpResult.taken(_base_choice(kind))


## "" when `r` is a coherent successful Support fallback receipt, or the first thing that is not.
func _fallback_shape(r: RiftLevelUpResult) -> String:
	if r == null or not r.ok:
		return "not a success"
	if not r.problem().is_empty():
		return "incoherent: %s" % r.problem()
	if r.lane != SUPPORT_LANE or r.support_content_kind != FALLBACK_KIND or not r.carries_support_fallback():
		return "lane %d content %d" % [r.lane, r.support_content_kind]
	if r.granted_identity().size() != 1:
		return "%d ids" % r.granted_identity().size()
	if r.support_fallback_category != COMBAT and r.support_fallback_category != UTILITY:
		return "category %d" % r.support_fallback_category
	if r.carries_support_progression() or r.support_progression_kind != NO_KIND \
			or r.support_rank_before != NO_RANK or r.support_rank_after != NO_RANK:
		return "a progression"
	var canonical: PassiveCardDefinition = PassiveCardCatalogue.record(StringName(r.granted_identity()[0]))
	if canonical == null or canonical.category() != r.support_fallback_category:
		return "the card is not of its category"
	return ""


## "" when every stable fact of `r` equals `c`'s, or the facts that differ.
func _receipt_matches_choice(r: RiftLevelUpResult, c: RiftOfferChoiceResult) -> String:
	var differ: PackedStringArray = PackedStringArray()
	if r.ok != c.ok:
		differ.append("ok")
	if r.root_seed != c.root_seed:
		differ.append("root seed")
	if r.root_seed_known != c.root_seed_known:
		differ.append("seed known")
	if r.lane != c.lane:
		differ.append("lane")
	if r.granted_identity() != c.chosen_identity():
		differ.append("identity")
	if r.support_progression_kind != c.support_progression_kind:
		differ.append("progression kind")
	if r.support_rank_before != c.support_rank_before or r.support_rank_after != c.support_rank_after:
		differ.append("ranks")
	if r.support_content_kind != c.support_content_kind:
		differ.append("content kind")
	if r.support_fallback_category != c.support_fallback_category:
		differ.append("category")
	if r.carries_support_fallback() != c.carries_support_fallback():
		differ.append("fallback reading")
	return ", ".join(differ)


## A refusal carrying a reason and nothing else, and coherent by its own rule.
func _refused_whole(r: RiftLevelUpResult) -> bool:
	return r != null and not r.ok and not r.failure_reason.strip_edges().is_empty() \
		and r.granted_identity().is_empty() and r.identity_line() == "nothing granted" \
		and r.support_content_kind == NO_CONTENT and r.support_fallback_category == NO_CATEGORY \
		and r.support_progression_kind == NO_KIND and r.support_rank_before == NO_RANK \
		and r.support_rank_after == NO_RANK and not r.carries_support_fallback() \
		and not r.carries_support_progression() and r.support_fallback_line() == "no passive fallback" \
		and r.problem().is_empty()


func _category_name(category: int) -> String:
	for lane: int in [COMBAT_LANE, UTILITY_LANE]:
		if RiftOffer.category_for_lane(lane) == category:
			return RiftOffer.lane_label(lane)
	return "category %d" % category


## Whether `path` owns `member` by `MEMBER_OWNERS`. Per file and per member.
func _owner_may_name(path: String, member: String) -> bool:
	for row: Array in MEMBER_OWNERS:
		if String(row[0]) == path:
			return (row[1] as Array).has(member)
	return false


func _snapshot(build: RiftRunBuild) -> String:
	if build == null:
		return "no build"
	var parts: PackedStringArray = PackedStringArray()
	parts.append("pairs[%s]" % ", ".join(build.support_pairs()))
	parts.append("pair_count=%d ranks=%d reach=%d sweep=%d" % [build.support_count(), build.total_support_ranks(),
		build.support_rank_for(QS, REACH), build.support_rank_for(QS, SWEEP)])
	var held: PackedStringArray = PackedStringArray()
	for card_id: StringName in build.acquired_card_ids():
		held.append("%s x%d {%s}" % [card_id, build.acquisitions_for(card_id), build.mechanical_identity_for(card_id)])
	parts.append("cards[%s]" % ", ".join(held))
	parts.append("acquisitions=%d" % build.passive_acquisitions())
	for stat_id: StringName in PlayerStats.ALL:
		parts.append("%s=%s(%d)" % [stat_id, String.num(build.total_for(stat_id), 17), build.contribution_count_for(stat_id)])
	return " | ".join(parts)


func _seeds_line(ledger: RiftConsumptionLedger) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for root_seed: int in ledger.consumed_seeds():
		parts.append(str(root_seed))
	return ", ".join(parts)


func _count(tally: Dictionary, key: Variant) -> void:
	tally[key] = int(tally.get(key, 0)) + 1


func _owner_line(owners: Dictionary) -> String:
	var keys: PackedStringArray = PackedStringArray()
	for key: Variant in owners:
		keys.append(String(key))
	keys.sort()
	var parts: PackedStringArray = PackedStringArray()
	for key: String in keys:
		parts.append("%s %d" % [key, int(owners[key])])
	return "[%s]" % ", ".join(parts)


## A script's own constants, read from the engine rather than retyped.
func _constants(path: String) -> Dictionary:
	var script: GDScript = load(path) as GDScript
	return script.get_script_constant_map() if script != null else {}


## A file's source with every comment line removed.
func _code(path: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in FileAccess.get_file_as_string(path).split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


func _function_body(source: String, name: String) -> String:
	var start: int = source.find("func %s(" % name)
	if start < 0:
		return ""
	var rest: String = source.substr(start)
	var end: int = rest.length()
	for marker: String in ["\nfunc ", "\nstatic func "]:
		var at: int = rest.find(marker, 1)
		if at > 0 and at < end:
			end = at
	return rest.substr(0, end)


## Every project class a file names, sorted, from the engine's own class list.
func _named_classes(path: String) -> PackedStringArray:
	var raw: String = FileAccess.get_file_as_string(path)
	var out: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var class_id: String = String(entry.get("class", ""))
		if not class_id.is_empty() and raw.contains(class_id):
			out.append(class_id)
	out.sort()
	return out


func _methods_of(path: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var script: GDScript = load(path) as GDScript
	if script == null:
		return out
	for entry: Dictionary in script.get_script_method_list():
		out.append(String(entry.get("name", "")))
	return out


func _fields_of(instance: Object) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for entry: Dictionary in instance.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			out.append(String(entry.get("name", "")))
	return out


func _listing(directory_path: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open(directory_path)
	if dir != null:
		for entry: String in dir.get_files():
			out.append(entry)
	out.sort()
	return out


func _action_count() -> int:
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	return actions


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


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
