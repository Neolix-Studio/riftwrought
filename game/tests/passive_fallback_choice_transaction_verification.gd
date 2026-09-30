extends SceneTree
## Riftwrought — Roguelite Foundation I8 verification: the Atomic Passive-Fallback
## Choice Transaction (decision D-308).
##
## ONE FOCUSED HEADLESS TEST, run as a `SceneTree` script exactly as every earlier
## foundation's suite is. I8 edits two pure-logic files — the accepted D3 choice
## transaction and its result — so it needs no scene, no camera and no evidence frame.
##
## IT PORTS D-211's OWED-SET DISCIPLINE: every check records reaching its LAST line,
## and the set is compared with what the suite owes in both directions.
##
## "UNCHANGED" IS A BEFORE/AFTER MEASUREMENT, NOT A RE-READING. Before the first I8
## edit a scratch probe took the accepted transaction through 4992 non-fallback
## choices — every lane of eight shipped rank states over 136 root seeds, the two
## ordinary passive lanes of every fallback offer, 1024 stale offers and 432 spent
## seeds — formatted each outcome with members that existed before I8, and recorded
## the SHA-256 of the whole corpus. Check 1 recomposes it with the same formatter and
## requires the same digest. The same probe recorded that the pre-I8 transaction
## refused all 136 fallback Support choices; that is the one class whose answer moved.
##
## EVERY ATOMICITY CLAIM COMPARES WHOLE SNAPSHOTS of the supplied build, ledger and
## offer, taken immediately before and after the attempt. Checking only the thing the
## operation was about is how a partial mutation survives a green suite.
##
## THE TEST DATA IS NOT CONTENT. Every fabricated card and forged result below lives
## in this file only and is not canon; the `zz_` prefix keeps a fabricated id from
## colliding with a catalogue entry.

const CHOICE_FILE: String = "res://scripts/choices/rift_offer_choice.gd"
const RESULT_FILE: String = "res://scripts/choices/rift_offer_choice_result.gd"
const LEDGER_FILE: String = "res://scripts/choices/rift_consumption_ledger.gd"
const D3_FILES: Array[String] = [CHOICE_FILE, RESULT_FILE]

const SUPPORT_LANE: int = RiftOffer.Lane.SUPPORT
const COMBAT_LANE: int = RiftOffer.Lane.COMBAT_DEFENCE
const UTILITY_LANE: int = RiftOffer.Lane.UTILITY
const FALLBACK_KIND: int = RiftOffer.SupportContentKind.PASSIVE_FALLBACK
const PROGRESSION_KIND: int = RiftOffer.SupportContentKind.SUPPORT_PROGRESSION
const NO_CONTENT: int = RiftOffer.UNRESOLVED_SUPPORT_CONTENT_KIND
const NO_CATEGORY: int = RiftOfferChoiceResult.NO_FALLBACK_CATEGORY
const COMBAT: int = PlayerStatDefinition.Category.COMBAT_DEFENCE
const UTILITY: int = PlayerStatDefinition.Category.UTILITY

const QS: StringName = &"quick_strike"
const REACH: StringName = &"reaching_edge"
const SWEEP: StringName = &"sweeping_edge"
const POWER: StringName = &"card_power"
const CELERITY: StringName = &"card_celerity"
const VITALITY: StringName = &"card_vitality"
const FLEETNESS: StringName = &"card_fleetness"
const INSIGHT: StringName = &"card_insight"

## The pre-I8 measurement, taken with the accepted transaction before the first edit.
const PRE_I8_ROWS: int = 4992
const PRE_I8_DIGEST: String = "9381d4bb493d3697b44ddd33b113f1c8265320a438f0616704baaa93ec16a590"
const PRE_I8_FALLBACK_ROWS: int = 136
const PRE_I8_FALLBACK_REASON: String = "the support lane named 1 identifiers, not 2"
const SPECIAL_SEEDS: Array[int] = [-1, -12345, 2147483647, 4294967295, 4294967296,
	9223372036854775807, -9223372036854775807 - 1, 51507111]
const STATES: Array = [[0, 0], [1, 0], [0, 1], [1, 1], [2, 0], [0, 2], [2, 1], [1, 2], [2, 2]]

## Root seed 18 with both shipped supports at rank 2: Support [card_celerity] from
## Combat and Defence, beside card_power and card_insight (D-306, typed here).
const EXAMPLE_SEED: int = 18
const EXPECTED_TWICE_TOTAL: float = 0.20

## What the then-unchanged one-level receipt reported about a consumed fallback under I8 —
## 'the Support lane granted 1 identifiers, not 2' — was recorded here, not decided.
## Roguelite Foundation I9 (D-310) extended the receipt to record the Support content kind
## and the fallback category, so this constant was replaced one for one by the receipt's
## own fallback line for the worked example, typed here.
const E2_FALLBACK_RECEIPT_LINE: String = "passive fallback: card_celerity, drawn from Combat and Defence"

const SEED_SAMPLES: int = 256
const ROOT_SAMPLES: int = 4096
const SEED_SEARCH_LIMIT: int = 4096

## The two edited files, by the SHA-256 prefix each holds after D-308.
const EDITED_HASHES: Array = [
	[CHOICE_FILE, "533ee30f"],
	[RESULT_FILE, "f051a955"],
]

## Accepted files I8 must not touch, by the SHA-256 prefix each held before the first
## I8 edit: the offer and its composer, the I6 fallback, the ledger, the run build, the
## card records and selector, the continuation, every level-up coordinator and receipt,
## the mote runtime, the running review and its panel, the live-effect seam and review,
## and project.godot. Roguelite Foundation I9 (D-310) moved the level-up receipt's row one
## for one to its D-310 hash; every other row still holds its pre-I8 prefix.
const UNCHANGED_HASHES: Array = [
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
	["res://scripts/stats/player_stat_totals.gd", "84f3a515"],
	["res://scripts/skills/acquired_supports.gd", "aad88e92"],
	["res://scripts/continuation/support_continuation.gd", "c815ad5d"],
	["res://scripts/continuation/support_continuation_result.gd", "68c8811d"],
	## Roguelite I10 (D-312): both level-up coordinators, the mote runtime and the running
	## review moved one for one — from `bbba1a71`, `01090425`, `083d4c28` and `005af300` — to
	## the D-312 files. Same count.
	["res://scripts/levels/rift_level_up_coordinator.gd", "f178c358"],
	["res://scripts/levels/rift_level_up_result.gd", "2d67cee9"],
	["res://scripts/levels/rift_run_level_coordinator.gd", "b654e0a2"],
	["res://scripts/levels/rift_run_level_up_result.gd", "cc7f8b84"],
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

const EXPECTED_CHOICE_METHODS: Array[String] = [
	"choose", "_stage", "_stage_support", "_stage_support_fallback", "_stage_passive",
]
const EXPECTED_RESULT_METHODS: Array[String] = [
	"identity_size_for", "identity_size_for_content", "refused_without_a_seed", "refused",
	"chosen", "chosen_support_fallback", "chosen_identity", "carries_support_progression",
	"carries_support_fallback", "problem", "support_progression_build_problem", "identity_line",
	"support_progression_line", "describe", "_stated",
]
const EXPECTED_RESULT_FIELDS: Array[String] = [
	"ok", "failure_reason", "root_seed", "root_seed_known", "lane",
	"support_progression_kind", "support_rank_before", "support_rank_after",
	"_chosen_identity", "new_build", "new_ledger",
	"support_content_kind", "support_fallback_category",
]

## Every project class each edited file names, exactly and sorted, from the engine's
## own class list — so a substring is reported honestly rather than hidden.
const EXPECTED_CHOICE_CLASSES: Array[String] = [
	"PassiveCardCatalogue", "PassiveCardDefinition", "RiftConsumptionLedger", "RiftOffer",
	"RiftOfferChoice", "RiftOfferChoiceResult", "RiftRunBuild", "SupportContinuation",
	"SupportContinuationResult",
]
const EXPECTED_RESULT_CLASSES: Array[String] = [
	"RiftConsumptionLedger", "RiftOffer", "RiftOfferChoice", "RiftOfferChoiceResult",
	"RiftRunBuild", "SupportContinuation", "SupportContinuationResult",
]

## Members only I8 introduces. Nothing that runs may name one outside the two edited files.
const I8_TOKENS: Array[String] = [
	"chosen_support_fallback", "carries_support_fallback", "identity_size_for_content",
	"support_fallback_category", "NO_FALLBACK_CATEGORY", "_stage_support_fallback",
]

## ROGUELITE FOUNDATION I9 (D-310): the one-level level-up receipt records which kind of
## Support content a choice consumed and a fallback's category, through the choice result's
## content-aware identity size and its no-category sentinel — so it names exactly these four
## I8 members, and neither the fallback constructor nor the transaction's staging. Granted
## per file and per member, and earned: the receipt must still name every one of them. The
## same single assertion.
## ROGUELITE I10 (D-312): both level-up coordinators and the mote runtime read the
## standing offer's passive-fallback category through `offer_support_fallback_category()` —
## the one-level coordinator answering the choice result's no-fallback sentinel otherwise —
## and the running review renders a consumed fallback from the receipt. Each is granted
## exactly the I8 members it names, per file and per member, and earned: each must still name
## every one. The same single assertion.
const I10_READER_TOKENS: Array = [
	["res://scripts/levels/rift_level_up_coordinator.gd", ["support_fallback_category", "NO_FALLBACK_CATEGORY"]],
	["res://scripts/levels/rift_run_level_coordinator.gd", ["support_fallback_category"]],
	["res://scripts/experience/rift_mote_runtime.gd", ["support_fallback_category"]],
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", [
		"carries_support_fallback", "support_fallback_category",
	]],
]
const RECEIPT_FILE: String = "res://scripts/levels/rift_level_up_result.gd"
const RECEIPT_I8_TOKENS: Array[String] = [
	"carries_support_fallback", "identity_size_for_content", "support_fallback_category",
	"NO_FALLBACK_CATEGORY",
]

## Concrete names and ambient reads neither edited file may hold, RAW (D-215).
const CONCRETE_TOKENS: Array[String] = [
	"card_power", "card_celerity", "card_vitality", "card_fleetness", "card_insight",
	"card_magnetism", "quick_strike", "QuickStrike", "reaching_edge", "sweeping_edge",
	"SkillSupportCatalogue", "display_name", "base_weight", "SupportExhaustionPassiveFallback",
]
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap", "FileAccess",
	"DirAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://", "get_tree(",
]

## What a transaction that advanced a level, built a receipt, opened a panel, touched an
## actor or saved anything would name IN CODE. Comment lines are stripped first: both
## files say in plain English what they do not do.
const WIRING_CODE_TOKENS: Array[String] = [
	"level", "experience", "receipt", "panel", "actor", "apply", "save", "persist",
	"input", "emit", "RiftLevelUp",
]

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31

## The accepted suites I8 moved one for one, read by path.
const D3_SUITE: String = "res://tests/rift_offer_choice_verification.gd"
const F1_SUITE: String = "res://tests/ranked_support_ownership_verification.gd"
const F1_RUNNER: String = "res://tests/ranked_support_ownership_smoke.sh"
const I5_SUITE: String = "res://tests/maximum_rank_support_filtering_verification.gd"
const I5_RUNNER: String = "res://tests/maximum_rank_support_filtering_smoke.sh"
const I6_SUITE: String = "res://tests/support_exhaustion_passive_fallback_verification.gd"
const I7_SUITE: String = "res://tests/passive_fallback_offer_composition_verification.gd"
const I7_RUNNER: String = "res://tests/passive_fallback_offer_composition_smoke.sh"

const OWED_CHECKS: Array[String] = [
	"every_accepted_non_fallback_choice_reproduces_exactly",
	"the_shipped_fallback_offer_is_consumed_as_one_passive_card",
	"every_shipped_fallback_card_and_both_categories_are_consumed",
	"a_repeatable_fallback_card_already_held_is_held_twice",
	"reversed_inputs_change_no_choice_outcome",
	"tampered_fallback_offers_refuse_atomically",
	"a_canonical_record_disagreement_refuses_atomically",
	"a_run_build_refusal_passes_through_without_spending",
	"the_same_fallback_choice_cannot_be_consumed_twice",
	"the_ordinary_passive_lanes_of_a_fallback_offer_are_unchanged",
	"fallback_unavailable_cannot_be_consumed",
	"every_refusal_exposes_nothing",
	"returned_values_do_not_alias_the_supplied_ones",
	"the_result_contract_rejects_every_mixed_shape",
	"the_downstream_receipt_path_records_the_fallback_since_i9",
	"nothing_is_wired_and_the_shapes_are_pinned",
	"accepted_files_and_suites_moved_one_for_one",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0

## Every refusal this suite drives through the transaction, held to the refusal contract
## at once by check 12.
var _collected_refusals: Array = []


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation I8 — Atomic Passive-Fallback Choice Transaction (D-308) ===")

	_check_every_accepted_non_fallback_choice_reproduces_exactly()
	_check_the_shipped_fallback_offer_is_consumed_as_one_passive_card()
	_check_every_shipped_fallback_card_and_both_categories_are_consumed()
	_check_a_repeatable_fallback_card_already_held_is_held_twice()
	_check_reversed_inputs_change_no_choice_outcome()
	_check_tampered_fallback_offers_refuse_atomically()
	_check_a_canonical_record_disagreement_refuses_atomically()
	_check_a_run_build_refusal_passes_through_without_spending()
	_check_the_same_fallback_choice_cannot_be_consumed_twice()
	_check_the_ordinary_passive_lanes_of_a_fallback_offer_are_unchanged()
	_check_fallback_unavailable_cannot_be_consumed()
	_check_every_refusal_exposes_nothing()
	_check_returned_values_do_not_alias_the_supplied_ones()
	_check_the_result_contract_rejects_every_mixed_shape()
	_check_the_downstream_receipt_path_records_the_fallback()
	_check_nothing_is_wired_and_the_shapes_are_pinned()
	_check_accepted_files_and_suites_moved_one_for_one()

	_check_every_check_ran()

	print("")
	print("  %d refusals were driven across this suite" % _refusals)
	if _failures.is_empty():
		print("PASSIVE FALLBACK CHOICE TRANSACTION VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("PASSIVE FALLBACK CHOICE TRANSACTION VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. Every accepted answer, measured against the pre-I8 transaction ---------------------------------------------

func _check_every_accepted_non_fallback_choice_reproduces_exactly() -> void:
	print("")
	print("--- 1. Every accepted non-fallback choice reproduces the pre-I8 transaction exactly")
	var unchanged: PackedStringArray = PackedStringArray()
	var results: Array = []
	var moving: Array = []
	var stale_rows: int = 0
	var spent_rows: int = 0
	var cards: Array[PassiveCardDefinition] = _cards()
	for state: Array in STATES:
		var held: AcquiredSupports = _held(int(state[0]), int(state[1]))
		var fallback_state: bool = int(state[0]) == 2 and int(state[1]) == 2
		for root_seed: int in _corpus_seeds():
			var offer: RiftOffer = _compose(held, cards, root_seed)
			var build: RiftRunBuild = _build(int(state[0]), int(state[1]))
			var ledger: RiftConsumptionLedger = _ledger()
			for lane: int in RiftOffer.LANE_ORDER:
				var r: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, lane, build, ledger)
				if fallback_state and lane == SUPPORT_LANE:
					moving.append([offer, r, build, ledger])
				else:
					unchanged.append("R%d S%d seed %d lane %d: %s" % [state[0], state[1], root_seed, lane, _row(r, build, ledger)])
					results.append([r, lane])
	for a: Array in STATES:
		if int(a[0]) == 2 and int(a[1]) == 2:
			continue
		for b: Array in STATES:
			if a == b:
				continue
			for root_seed: int in 16:
				var offer: RiftOffer = _compose(_held(int(a[0]), int(a[1])), cards, root_seed)
				var build: RiftRunBuild = _build(int(b[0]), int(b[1]))
				var ledger: RiftConsumptionLedger = _ledger()
				var r: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, SUPPORT_LANE, build, ledger)
				unchanged.append("stale R%d S%d -> R%d S%d seed %d: %s" % [a[0], a[1], b[0], b[1], root_seed, _row(r, build, ledger)])
				results.append([r, SUPPORT_LANE])
				stale_rows += 1
	for state: Array in STATES:
		for root_seed: int in 16:
			var offer: RiftOffer = _compose(_held(int(state[0]), int(state[1])), cards, root_seed)
			var build: RiftRunBuild = _build(int(state[0]), int(state[1]))
			var ledger: RiftConsumptionLedger = _ledger()
			ledger.consume(root_seed)
			for lane: int in RiftOffer.LANE_ORDER:
				var r: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, lane, build, ledger)
				unchanged.append("spent R%d S%d seed %d lane %d: %s" % [state[0], state[1], root_seed, lane, _row(r, build, ledger)])
				results.append([r, lane])
				spent_rows += 1
	var digest: String = "\n".join(unchanged).sha256_text()
	_expect(unchanged.size() == PRE_I8_ROWS and digest == PRE_I8_DIGEST,
		"%d rows hash %s, not %d rows at %s" % [unchanged.size(), digest, PRE_I8_ROWS, PRE_I8_DIGEST])

	## THE TWO NEW FIELDS, on every one of those outcomes.
	var progressions: int = 0
	var passives: int = 0
	var refusals: int = 0
	var wrong: PackedStringArray = PackedStringArray()
	for pair: Array in results:
		var r: RiftOfferChoiceResult = pair[0]
		var lane: int = int(pair[1])
		if not r.ok:
			refusals += 1
			if not _refused_whole(r) and wrong.size() < 5:
				wrong.append("a refusal exposes %s" % _result_line(r))
			continue
		if lane == SUPPORT_LANE:
			progressions += 1
			if r.support_content_kind != PROGRESSION_KIND or r.support_fallback_category != NO_CATEGORY \
					or r.carries_support_fallback() or not r.carries_support_progression() \
					or r.chosen_identity().size() != 2:
				wrong.append("a Support progression reads %s" % _result_line(r))
		else:
			passives += 1
			if r.support_content_kind != NO_CONTENT or r.support_fallback_category != NO_CATEGORY \
					or r.carries_support_fallback() or r.carries_support_progression() \
					or r.chosen_identity().size() != 1:
				wrong.append("a passive lane reads %s" % _result_line(r))
	_expect(wrong.is_empty() and progressions > 500 and passives > 1000 and refusals > 1000,
		"%d progressions, %d passives, %d refusals; %s" % [progressions, passives, refusals, "; ".join(wrong)])

	## THE ONE CLASS WHOSE ANSWER MOVED.
	var moved_whole: int = 0
	for row: Array in moving:
		if _fallback_consumed(row[0], row[1], row[2], row[3]).is_empty():
			moved_whole += 1
	_expect(moving.size() == PRE_I8_FALLBACK_ROWS and moved_whole == moving.size(),
		"%d of %d moving rows consumed whole" % [moved_whole, moving.size()])
	print("  %d accepted D3 outcomes (%d over 8 non-fallback states x 136 seeds and the two passive lanes of 136 fallback offers, %d stale offers, %d spent seeds) hash %s — identical to the pre-I8 transaction's"
		% [unchanged.size(), unchanged.size() - stale_rows - spent_rows, stale_rows, spent_rows, digest.left(16)])
	print("  every one carries its content kind: %d Support progressions SUPPORT_PROGRESSION with two ids, %d passive lanes and %d refusals with none, and no fallback category anywhere"
		% [progressions, passives, refusals])
	print("  the one class whose answer moved: the %d fallback Support choices the pre-I8 transaction refused as '%s' are each consumed whole as one passive card"
		% [moved_whole, PRE_I8_FALLBACK_REASON])
	_done("every_accepted_non_fallback_choice_reproduces_exactly")


# --- 2. The worked example ------------------------------------------------------------------------------------------

func _check_the_shipped_fallback_offer_is_consumed_as_one_passive_card() -> void:
	print("")
	print("--- 2. Root seed 18, both shipped supports at rank 2: the fallback Support lane is taken as one passive card")
	var offer: RiftOffer = _compose(_held(2, 2), _cards(), EXAMPLE_SEED)
	_expect(offer.ok and offer.problem().is_empty() and offer.support_content_kind == FALLBACK_KIND
			and offer.support_fallback_card_id == CELERITY and offer.combat_card_id == POWER
			and offer.utility_card_id == INSIGHT and offer.support_fallback.selected_category == COMBAT,
		"the example offer is %s" % offer.describe())
	var build: RiftRunBuild = _build(2, 2)
	var ledger: RiftConsumptionLedger = _ledger()
	var fresh_before: String = _snapshot(_build(2, 2))
	var attempt: Array = _attempt(offer, SUPPORT_LANE, build, ledger)
	var r: RiftOfferChoiceResult = attempt[0]
	var fault: String = _fallback_consumed(offer, r, build, ledger)
	_expect(fault.is_empty(), "the example was not consumed whole: %s" % fault)
	if not r.ok:
		_done("the_shipped_fallback_offer_is_consumed_as_one_passive_card")
		return

	## Every field, typed here rather than read back from what produced it.
	_expect(r.lane == SUPPORT_LANE and r.root_seed == EXAMPLE_SEED and r.root_seed_known
			and ", ".join(r.chosen_identity()) == "card_celerity"
			and r.support_content_kind == FALLBACK_KIND and r.support_fallback_category == COMBAT
			and r.support_progression_kind == RiftOffer.UNRESOLVED_PROGRESSION_KIND
			and r.support_rank_before == RiftOfferChoiceResult.NO_RANK
			and r.support_rank_after == RiftOfferChoiceResult.NO_RANK
			and r.carries_support_fallback() and not r.carries_support_progression()
			and r.support_progression_build_problem().is_empty() and r.problem().is_empty(),
		"the result reads %s" % _result_line(r))
	_expect(r.describe() == "root seed 18 consumed; Support: card_celerity" and r.identity_line() == "card_celerity"
			and r.support_progression_line() == "no support progression",
		"the result presents '%s'" % r.describe())
	## Proof 3: exactly one additional acquisition. Proof 4: its exact contribution.
	_expect(build.acquisitions_for(CELERITY) == 0 and r.new_build.acquisitions_for(CELERITY) == 1
			and r.new_build.passive_acquisitions() == build.passive_acquisitions() + 1,
		"card_celerity held %d -> %d" % [build.acquisitions_for(CELERITY), r.new_build.acquisitions_for(CELERITY)])
	_expect(r.new_build.total_for(&"skill_speed") == 0.10 and r.new_build.contribution_count_for(&"skill_speed") == 1
			and r.new_build.mechanical_identity_for(CELERITY) == "skill_speed 0.10000000000000001 repeatable"
			and _nonzero_stats(r.new_build) == "skill_speed=0.10000000000000001(1), maximum_life=0.14999999999999999(1)",
		"the contribution reads %s / %s" % [_nonzero_stats(r.new_build), r.new_build.mechanical_identity_for(CELERITY)])
	## Proof 5: the two ordinary offered cards are not acquired.
	_expect(r.new_build.acquisitions_for(POWER) == 0 and r.new_build.acquisitions_for(INSIGHT) == 0,
		"card_power x%d, card_insight x%d" % [r.new_build.acquisitions_for(POWER), r.new_build.acquisitions_for(INSIGHT)])
	## Proof 6: no pair and no rank moves.
	_expect(", ".join(r.new_build.support_pairs()) == "quick_strike -> reaching_edge, quick_strike -> sweeping_edge"
			and r.new_build.support_rank_for(QS, REACH) == 2 and r.new_build.support_rank_for(QS, SWEEP) == 2
			and r.new_build.total_support_ranks() == 4 and r.new_build.support_count() == 2,
		"the supports read %s" % ", ".join(r.new_build.support_pairs()))
	## Proof 7: the root seed consumed exactly once.
	_expect(_seeds_line(r.new_ledger) == "-424242, 18" and _seeds_line(ledger) == "-424242",
		"the ledgers read [%s] and [%s]" % [_seeds_line(r.new_ledger), _seeds_line(ledger)])
	## Proof 8: the supplied build, ledger and offer never moved.
	_expect(bool(attempt[1]) and _snapshot(build) == fresh_before,
		"a supplied value moved")
	print("  root seed 18 at R2 S2: Support [card_celerity] drawn from %s is consumed — card_celerity held %d -> %d, %s, card_power and card_insight held 0 -> 0, pairs [%s] at ranks %d / %d, ledger [%s] -> [%s]"
		% [PassiveCardSelectionResult.category_label(r.support_fallback_category), build.acquisitions_for(CELERITY),
			r.new_build.acquisitions_for(CELERITY), _nonzero_stats(r.new_build), ", ".join(r.new_build.support_pairs()),
			r.new_build.support_rank_for(QS, REACH), r.new_build.support_rank_for(QS, SWEEP),
			_seeds_line(ledger), _seeds_line(r.new_ledger)])
	print("  the result: '%s'; content PASSIVE_FALLBACK, category %d, no progression; the supplied build, ledger and offer byte-identical"
		% [r.describe(), r.support_fallback_category])
	_done("the_shipped_fallback_offer_is_consumed_as_one_passive_card")


# --- 3. Every shipped fallback card and both categories -------------------------------------------------------------

func _check_every_shipped_fallback_card_and_both_categories_are_consumed() -> void:
	print("")
	print("--- 3. Every fallback offer over %d root seeds is taken as one passive card: every shipped card, both categories" % ROOT_SAMPLES)
	var held: AcquiredSupports = _held(2, 2)
	var cards: Array[PassiveCardDefinition] = _cards()
	var consumed: int = 0
	var untouched: int = 0
	var by_card: Dictionary = {}
	var by_category: Dictionary = {}
	var faults: PackedStringArray = PackedStringArray()
	for root_seed: int in ROOT_SAMPLES:
		var offer: RiftOffer = _compose(held, cards, root_seed)
		var build: RiftRunBuild = _build(2, 2)
		var ledger: RiftConsumptionLedger = _ledger()
		var attempt: Array = _attempt(offer, SUPPORT_LANE, build, ledger)
		var r: RiftOfferChoiceResult = attempt[0]
		if bool(attempt[1]):
			untouched += 1
		var fault: String = _fallback_consumed(offer, r, build, ledger)
		if fault.is_empty():
			consumed += 1
			_count(by_card, r.chosen_identity()[0])
			_count(by_category, PassiveCardSelectionResult.category_label(r.support_fallback_category))
		elif faults.size() < 5:
			faults.append("root seed %d: %s" % [root_seed, fault])
	_expect(consumed == ROOT_SAMPLES and untouched == ROOT_SAMPLES,
		"%d consumed, %d untouched of %d; %s" % [consumed, untouched, ROOT_SAMPLES, "; ".join(faults)])
	_expect(by_card.size() == PassiveCardCatalogue.ALL.size() and by_category.size() == 2,
		"cards %s, categories %s" % [str(by_card), str(by_category)])
	print("  %d of %d fallback offers over root seeds 0-%d consumed as one passive card: by card %s; by category %s"
		% [consumed, ROOT_SAMPLES, ROOT_SAMPLES - 1, _owner_line(by_card), _owner_line(by_category)])
	print("  every one equal to the run build's own acquisition of its canonical record, in the fallback's own category, with 0 ordinary cards acquired, 0 pairs or ranks moved, the seed spent once, and %d of %d supplied build, ledger and offer triples byte-identical"
		% [untouched, ROOT_SAMPLES])
	_done("every_shipped_fallback_card_and_both_categories_are_consumed")


# --- 4. Repeatable and already held -----------------------------------------------------------------------------------

func _check_a_repeatable_fallback_card_already_held_is_held_twice() -> void:
	print("")
	print("--- 4. A repeatable fallback card already held once is held twice")
	var held: AcquiredSupports = _held(2, 2)
	var cards: Array[PassiveCardDefinition] = _cards()
	var seed_for_card: Dictionary = {}
	for root_seed: int in SEED_SEARCH_LIMIT:
		var o: RiftOffer = _compose(held, cards, root_seed)
		if o.ok and o.support_content_kind == FALLBACK_KIND and not seed_for_card.has(o.support_fallback_card_id):
			seed_for_card[o.support_fallback_card_id] = root_seed
	var twice: int = 0
	var seen: PackedStringArray = PackedStringArray()
	for card_id: StringName in PassiveCardCatalogue.ALL:
		if not seed_for_card.has(card_id):
			continue
		var root_seed: int = int(seed_for_card[card_id])
		var offer: RiftOffer = _compose(held, cards, root_seed)
		var build: RiftRunBuild = _bare_build(2, 2)
		_expect(build.acquire_passive_card(PassiveCardCatalogue.record(card_id)).is_empty(), "%s could not be held once" % card_id)
		var ledger: RiftConsumptionLedger = _ledger()
		var attempt: Array = _attempt(offer, SUPPORT_LANE, build, ledger)
		var r: RiftOfferChoiceResult = attempt[0]
		if bool(attempt[1]) and _fallback_consumed(offer, r, build, ledger).is_empty() \
				and build.acquisitions_for(card_id) == 1 and r.new_build.acquisitions_for(card_id) == 2:
			twice += 1
			seen.append("%s (root seed %d)" % [card_id, root_seed])
	_expect(seed_for_card.size() == PassiveCardCatalogue.ALL.size() and twice == PassiveCardCatalogue.ALL.size(),
		"%d of %d shipped cards found as a fallback and held twice: %s" % [twice, seed_for_card.size(), ", ".join(seen)])

	## The worked example, typed: card_celerity from root seed 18 onto a build holding it.
	var example: RiftOffer = _compose(held, cards, EXAMPLE_SEED)
	var holding: RiftRunBuild = _bare_build(2, 2)
	holding.acquire_passive_card(PassiveCardCatalogue.record(CELERITY))
	var again: RiftOfferChoiceResult = RiftOfferChoice.choose(example, SUPPORT_LANE, holding, _ledger())
	_expect(again.ok and again.carries_support_fallback() and again.new_build.acquisitions_for(CELERITY) == 2
			and again.new_build.total_for(&"skill_speed") == EXPECTED_TWICE_TOTAL
			and again.new_build.contribution_count_for(&"skill_speed") == 2
			and again.new_build.mechanical_identity_for(CELERITY) == holding.mechanical_identity_for(CELERITY),
		"card_celerity held again reads %s" % _nonzero_stats(again.new_build) if again.ok else again.failure_reason)

	## Through two fallback offers in sequence: held 0 -> 1 -> 2, one seed each.
	var first_seed: int = int(seed_for_card.get(CELERITY, 0))
	var chain_first: RiftOfferChoiceResult = RiftOfferChoice.choose(_compose(held, cards, first_seed), SUPPORT_LANE,
		_bare_build(2, 2), RiftConsumptionLedger.new())
	var chain_second: RiftOfferChoiceResult = RiftOfferChoice.choose(example, SUPPORT_LANE,
		chain_first.new_build, chain_first.new_ledger) if chain_first.ok else null
	_expect(first_seed != EXAMPLE_SEED and chain_first.ok and chain_second != null and chain_second.ok
			and chain_first.new_build.acquisitions_for(CELERITY) == 1 and chain_second.new_build.acquisitions_for(CELERITY) == 2
			and chain_second.new_ledger.count() == 2 and chain_second.new_ledger.has_consumed(first_seed)
			and chain_second.new_ledger.has_consumed(EXAMPLE_SEED) and chain_second.new_build.total_support_ranks() == 4,
		"the two-offer chain from root seeds %d and %d did not hold card_celerity twice" % [first_seed, EXAMPLE_SEED])
	print("  %d of %d shipped cards, each found as a fallback and taken onto a build already holding it once, are held twice through the run build's own repeat rule: %s"
		% [twice, PassiveCardCatalogue.ALL.size(), ", ".join(seen)])
	print("  card_celerity from root seed 18 onto a build holding it: skill_speed = %s over %d contributions, its mechanical identity unchanged; root seeds %d then 18 in sequence hold it 0 -> 1 -> 2 with two seeds spent"
		% [String.num(again.new_build.total_for(&"skill_speed"), 17) if again.ok else "-",
			again.new_build.contribution_count_for(&"skill_speed") if again.ok else -1, first_seed])
	_done("a_repeatable_fallback_card_already_held_is_held_twice")


# --- 5. Reversed composition inputs ---------------------------------------------------------------------------------

func _check_reversed_inputs_change_no_choice_outcome() -> void:
	print("")
	print("--- 5. Reversed composition inputs change no choice outcome")
	var profiles: Array[SkillTagProfile] = _profiles()
	var definitions: Array[SupportDefinition] = _definitions()
	var cards: Array[PassiveCardDefinition] = _cards()
	var reversed_profiles: Array[SkillTagProfile] = profiles.duplicate()
	reversed_profiles.reverse()
	var reversed_definitions: Array[SupportDefinition] = definitions.duplicate()
	reversed_definitions.reverse()
	var reversed_cards: Array[PassiveCardDefinition] = cards.duplicate()
	reversed_cards.reverse()
	var held: AcquiredSupports = _held(2, 2)
	var held_backwards: AcquiredSupports = _held_backwards(2, 2)
	var answers: int = 0
	var moved: int = 0
	var fallbacks: int = 0
	for root_seed: int in SEED_SAMPLES:
		var variants: Array = [
			RiftOfferComposition.compose(profiles, definitions, held, cards, root_seed),
			RiftOfferComposition.compose(reversed_profiles, definitions, held, cards, root_seed),
			RiftOfferComposition.compose(profiles, reversed_definitions, held, cards, root_seed),
			RiftOfferComposition.compose(profiles, definitions, held, reversed_cards, root_seed),
			RiftOfferComposition.compose(profiles, definitions, held_backwards, cards, root_seed),
			RiftOfferComposition.compose(reversed_profiles, reversed_definitions, held_backwards, reversed_cards, root_seed),
		]
		for lane: int in RiftOffer.LANE_ORDER:
			var expected: String = ""
			for index: int in variants.size():
				var build: RiftRunBuild = _build(2, 2)
				var ledger: RiftConsumptionLedger = _ledger()
				var r: RiftOfferChoiceResult = RiftOfferChoice.choose(variants[index], lane, build, ledger)
				var line: String = _full_row(r, build, ledger)
				if index == 0:
					expected = line
					if lane == SUPPORT_LANE and r.carries_support_fallback():
						fallbacks += 1
					continue
				answers += 1
				if line != expected:
					moved += 1
	_expect(answers == SEED_SAMPLES * 3 * 5 and moved == 0 and fallbacks == SEED_SAMPLES,
		"%d answers, %d moved, %d fallbacks" % [answers, moved, fallbacks])
	print("  %d answers over %d root seeds x 3 lanes x 5 reversals (Skills, supports, cards, the held pairs' order, and all four together) against the unreversed composition: %d moved; all %d Support answers are consumed fallbacks"
		% [answers, SEED_SAMPLES, moved, fallbacks])
	_done("reversed_inputs_change_no_choice_outcome")


# --- 6. Tampering -----------------------------------------------------------------------------------------------------

func _check_tampered_fallback_offers_refuse_atomically() -> void:
	print("")
	print("--- 6. Every tampered fallback offer refuses atomically, before a seed can be spent")
	var other: RiftOffer = _compose(_held(2, 2), _cards(), 257)
	## [label, "offer" or "fallback", field, value or "+1"]
	var rows: Array = [
		["Support content kind -> SUPPORT_PROGRESSION", "offer", "support_content_kind", PROGRESSION_KIND],
		["Support content kind -> an undeclared 7", "offer", "support_content_kind", 7],
		["Support content kind -> unresolved", "offer", "support_content_kind", NO_CONTENT],
		["fallback id -> the Combat and Defence lane's own card", "offer", "support_fallback_card_id", POWER],
		["fallback id -> a card no lane offers", "offer", "support_fallback_card_id", VITALITY],
		["fallback id -> empty", "offer", "support_fallback_card_id", &""],
		["fallback id -> an id no catalogue holds", "offer", "support_fallback_card_id", &"zz_unknown_card"],
		["fallback derivation -> none", "offer", "support_fallback", null],
		["fallback derivation -> another offer's", "offer", "support_fallback", other.support_fallback],
		["exhausted continuation -> none", "offer", "support_continuation", null],
		["a Skill borrowed onto the fallback lane", "offer", "skill_id", QS],
		["fallback category -> Utility", "fallback", "selected_category", UTILITY],
		["fallback selected card -> card_vitality", "fallback", "selected_card_id", VITALITY],
		["fallback category ticket moved by one", "fallback", "category_ticket", "+1"],
		["fallback card ticket moved by one", "fallback", "card_ticket", "+1"],
		["fallback marked refused", "fallback", "ok", false],
	]
	var at_gate: int = 0
	var atomic: int = 0
	var bare: int = 0
	var escaped: PackedStringArray = PackedStringArray()
	for row: Array in rows:
		var offer: RiftOffer = _compose(_held(2, 2), _cards(), EXAMPLE_SEED)
		var target: Object = offer if String(row[1]) == "offer" else offer.support_fallback
		var field: String = String(row[2])
		if typeof(row[3]) == TYPE_STRING and String(row[3]) == "+1":
			target.set(field, int(target.get(field)) + 1)
		else:
			target.set(field, row[3])
		var incoherent: String = offer.problem()
		var build: RiftRunBuild = _build(2, 2)
		var ledger: RiftConsumptionLedger = _ledger()
		var attempt: Array = _attempt(offer, SUPPORT_LANE, build, ledger)
		var r: RiftOfferChoiceResult = attempt[0]
		_collect(r)
		if not incoherent.is_empty() and not r.ok \
				and r.failure_reason == "the offer is not internally coherent: %s" % incoherent:
			at_gate += 1
		else:
			escaped.append("%s -> %s" % [String(row[0]), r.describe()])
		if bool(attempt[1]) and not ledger.has_consumed(EXAMPLE_SEED):
			atomic += 1
		if _refused_whole(r) and r.root_seed == EXAMPLE_SEED and r.lane == SUPPORT_LANE:
			bare += 1
	_expect(at_gate == rows.size() and atomic == rows.size() and bare == rows.size(),
		"%d at the gate, %d atomic, %d bare of %d; %s" % [at_gate, atomic, bare, rows.size(), "; ".join(escaped)])
	print("  %d of %d single-field tamperings (content kind x3, fallback id x4, the fallback derivation x2, the exhausted continuation, a borrowed Skill, and inside the fallback its category, card, both tickets and its success) refused with no seed spent — every one at the offer's own coherence gate, quoted verbatim"
		% [at_gate, rows.size()])
	print("  %d of %d left the supplied build, ledger and tampered offer byte-identical, and %d of %d refusals expose no identity, content kind, category, build or ledger"
		% [atomic, rows.size(), bare, rows.size()])
	print("  STRUCTURAL: the transaction's own one-card, fallback-coherence and three-way-agreement gates are unreachable through a supplied offer — a coherent offer already guarantees all three, and every tampering above is refused by that coherence first")
	_done("tampered_fallback_offers_refuse_atomically")


# --- 7. The canonical catalogue is the authority --------------------------------------------------------------------

func _check_a_canonical_record_disagreement_refuses_atomically() -> void:
	print("")
	print("--- 7. A fallback card the canonical catalogue holds in another category, or not at all, refuses atomically")
	var held: AcquiredSupports = _held(2, 2)
	## A canonical Combat and Defence id fabricated as a Utility card, so a fallback can
	## draw it from Utility while the catalogue says otherwise. Valid on its own.
	var misplaced: Array[PassiveCardDefinition] = [
		_card("zz_c_one", &"global_damage"), _card("zz_c_two", &"skill_speed"), _card("zz_c_three", &"maximum_life"),
		PassiveCardDefinition.of(POWER, "Test Misplaced", &"movement_speed", 0.10, 100, true),
		_card("zz_u_one", &"experience_gain"), _card("zz_u_two", &"pickup_radius"),
	]
	var expected_reason: String = "%s derives category %d and the Support lane's passive fallback drew from category %d" % [
		POWER, PassiveCardCatalogue.record(POWER).category(), UTILITY]
	var found: int = 0
	var refused: int = 0
	var atomic: int = 0
	for root_seed: int in SEED_SEARCH_LIMIT:
		var offer: RiftOffer = _compose(held, misplaced, root_seed)
		if not offer.ok or offer.support_content_kind != FALLBACK_KIND or offer.support_fallback_card_id != POWER:
			continue
		found += 1
		var build: RiftRunBuild = _build(2, 2)
		var ledger: RiftConsumptionLedger = _ledger()
		var attempt: Array = _attempt(offer, SUPPORT_LANE, build, ledger)
		var r: RiftOfferChoiceResult = attempt[0]
		_collect(r)
		if offer.problem().is_empty() and not r.ok and r.failure_reason == expected_reason:
			refused += 1
		if bool(attempt[1]) and not ledger.has_consumed(root_seed):
			atomic += 1
		if found == 64:
			break
	_expect(found == 64 and refused == found and atomic == found,
		"%d found, %d refused as '%s', %d atomic" % [found, refused, expected_reason, atomic])

	## An id the canonical catalogue does not hold at all.
	var unknown: Array[PassiveCardDefinition] = [
		_card("zz_c_one", &"global_damage"), _card("zz_c_two", &"skill_speed"), _card("zz_c_three", &"maximum_life"),
		_card("zz_u_one", &"movement_speed"), _card("zz_u_two", &"experience_gain"), _card("zz_u_three", &"pickup_radius"),
	]
	var unknown_refused: int = 0
	var unknown_atomic: int = 0
	var sample: String = ""
	for root_seed: int in 64:
		var offer: RiftOffer = _compose(held, unknown, root_seed)
		var build: RiftRunBuild = _build(2, 2)
		var ledger: RiftConsumptionLedger = _ledger()
		var attempt: Array = _attempt(offer, SUPPORT_LANE, build, ledger)
		var r: RiftOfferChoiceResult = attempt[0]
		_collect(r)
		if offer.ok and offer.problem().is_empty() and offer.support_content_kind == FALLBACK_KIND and not r.ok \
				and r.failure_reason == "%s is not a card the canonical catalogue holds" % offer.support_fallback_card_id:
			unknown_refused += 1
			sample = r.failure_reason
		if bool(attempt[1]) and not ledger.has_consumed(root_seed):
			unknown_atomic += 1
	_expect(unknown_refused == 64 and unknown_atomic == 64,
		"%d of 64 unknown fallback ids refused, %d atomic" % [unknown_refused, unknown_atomic])
	print("  a canonical Combat and Defence id fabricated as a Utility card: %d coherent fallback offers drawing it from Utility, %d refused — '%s' — with nothing spent and the supplied values byte-identical"
		% [found, refused, expected_reason])
	print("  a catalogue of ids the canonical one does not hold: %d of 64 coherent fallback offers refused — e.g. '%s' — atomically"
		% [unknown_refused, sample])
	print("  STRUCTURAL: a canonical record that is itself invalid is unreachable — the shipped catalogue is coherent, which its own accepted suite proves")
	_done("a_canonical_record_disagreement_refuses_atomically")


# --- 8. The run build's own refusal --------------------------------------------------------------------------------

func _check_a_run_build_refusal_passes_through_without_spending() -> void:
	print("")
	print("--- 8. A refusal from the run build passes through verbatim and spends nothing")
	var offer: RiftOffer = _compose(_held(2, 2), _cards(), EXAMPLE_SEED)
	var canonical: PassiveCardDefinition = PassiveCardCatalogue.record(CELERITY)
	## Each row binds card_celerity to a DIFFERENT mechanical fingerprint first.
	var rows: Array = [
		["a magnitude conflict", PassiveCardDefinition.of(CELERITY, "Test Held", &"skill_speed", 0.20, 100, true)],
		["a stat conflict", PassiveCardDefinition.of(CELERITY, "Test Held", &"global_damage", 0.10, 100, true)],
		["a repeat-flag conflict", PassiveCardDefinition.of(CELERITY, "Test Held", &"skill_speed", 0.10, 100, false)],
	]
	var verbatim: int = 0
	var reasons: PackedStringArray = PackedStringArray()
	for row: Array in rows:
		var build: RiftRunBuild = _bare_build(2, 2)
		_expect(build.acquire_passive_card(row[1] as PassiveCardDefinition).is_empty(), "%s could not be held" % String(row[0]))
		var ledger: RiftConsumptionLedger = _ledger()
		var owed_refusal: String = build.duplicated().acquire_passive_card(canonical)
		var attempt: Array = _attempt(offer, SUPPORT_LANE, build, ledger)
		var r: RiftOfferChoiceResult = attempt[0]
		_collect(r)
		if not owed_refusal.is_empty() and not r.ok and r.failure_reason == owed_refusal and bool(attempt[1]) \
				and build.acquisitions_for(CELERITY) == 1 and build.total_support_ranks() == 4 \
				and not ledger.has_consumed(EXAMPLE_SEED) and _refused_whole(r):
			verbatim += 1
			reasons.append("%s: '%s'" % [String(row[0]), r.failure_reason])
	_expect(verbatim == rows.size(), "%d of %d run-build refusals passed through verbatim: %s" % [verbatim, rows.size(), "; ".join(reasons)])

	## THE TWO BRANCHES NO SHIPPED CANONICAL RECORD CAN REACH, measured at their edge.
	var repeatable: int = 0
	for record: PassiveCardDefinition in PassiveCardCatalogue.records():
		if record.repeatable:
			repeatable += 1
	var edge: RiftRunBuild = _bare_build(2, 2)
	_expect(edge.acquire_passive_card(PassiveCardDefinition.of(&"zz_edge_speed", "Test Edge", &"skill_speed",
		1.7976931348623157e308, 100, true)).is_empty(), "the edge card could not be held")
	var at_edge: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, SUPPORT_LANE, edge, _ledger())
	_expect(repeatable == PassiveCardCatalogue.ALL.size() and at_edge.ok and at_edge.new_build.acquisitions_for(CELERITY) == 1
			and is_finite(at_edge.new_build.total_for(&"skill_speed")),
		"%d repeatable; at the edge the fallback answered %s" % [repeatable, at_edge.describe()])
	for line: String in reasons:
		print("  run-build refusal, verbatim, nothing spent: %s" % line)
	print("  STRUCTURAL: the run build's 'not repeatable' branch needs a non-repeatable canonical record, and %d of %d shipped records are repeatable, so a future non-repeatable conflict reaches the transaction today only as the repeat-flag fingerprint conflict above"
		% [repeatable, PassiveCardCatalogue.ALL.size()])
	print("  STRUCTURAL: the run build's unusable-total branch needs a sum that is not finite, and a shipped magnitude cannot make one — holding the largest finite skill_speed total, the fallback still succeeds")
	_done("a_run_build_refusal_passes_through_without_spending")


# --- 9. Once only --------------------------------------------------------------------------------------------------------

func _check_the_same_fallback_choice_cannot_be_consumed_twice() -> void:
	print("")
	print("--- 9. The same fallback choice cannot be consumed twice")
	var offer: RiftOffer = _compose(_held(2, 2), _cards(), EXAMPLE_SEED)
	var build: RiftRunBuild = _build(2, 2)
	var ledger: RiftConsumptionLedger = _ledger()
	var first: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, SUPPORT_LANE, build, ledger)
	_expect(first.ok and first.carries_support_fallback(), "the first choice was refused: %s" % first.failure_reason)
	var refused: int = 0
	for lane: int in RiftOffer.LANE_ORDER:
		var attempt: Array = _attempt(offer, lane, first.new_build, first.new_ledger)
		var r: RiftOfferChoiceResult = attempt[0]
		_collect(r)
		if not r.ok and r.failure_reason == "root seed 18 has already been consumed by this run" and bool(attempt[1]) \
				and _refused_whole(r) and first.new_build.acquisitions_for(CELERITY) == 1:
			refused += 1
	_expect(refused == 3, "%d of 3 lanes refused as already consumed" % refused)
	## THE TRANSACTION IS PURE: the ORIGINAL values can take the same offer again, and
	## the second answer equals the first while sharing nothing with it.
	var again: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, SUPPORT_LANE, build, ledger)
	_expect(again.ok and _snapshot(again.new_build) == _snapshot(first.new_build)
			and _ledger_snapshot(again.new_ledger) == _ledger_snapshot(first.new_ledger)
			and again.new_build != first.new_build and again.new_ledger != first.new_ledger,
		"a second choice from the original values answered %s" % again.describe())
	print("  after the fallback is consumed, all %d lanes of the same offer are refused against the new values — 'root seed 18 has already been consumed by this run' — atomically; the untouched originals still answer an equal, independent result"
		% refused)
	_done("the_same_fallback_choice_cannot_be_consumed_twice")


# --- 10. The ordinary passive lanes ------------------------------------------------------------------------------------

func _check_the_ordinary_passive_lanes_of_a_fallback_offer_are_unchanged() -> void:
	print("")
	print("--- 10. Either ordinary passive lane of a fallback offer is taken exactly as before")
	var held: AcquiredSupports = _held(2, 2)
	var good: int = 0
	var faults: PackedStringArray = PackedStringArray()
	for root_seed: int in SEED_SAMPLES:
		var offer: RiftOffer = _compose(held, _cards(), root_seed)
		for lane: int in [COMBAT_LANE, UTILITY_LANE]:
			var build: RiftRunBuild = _build(2, 2)
			var ledger: RiftConsumptionLedger = _ledger()
			var card: StringName = StringName(offer.identity_for(lane)[0])
			var attempt: Array = _attempt(offer, lane, build, ledger)
			var r: RiftOfferChoiceResult = attempt[0]
			var expected: RiftRunBuild = build.duplicated()
			expected.acquire_passive_card(PassiveCardCatalogue.record(card))
			if r.ok and r.problem().is_empty() and bool(attempt[1]) and ", ".join(r.chosen_identity()) == String(card) \
					and r.support_content_kind == NO_CONTENT and r.support_fallback_category == NO_CATEGORY \
					and not r.carries_support_fallback() and not r.carries_support_progression() \
					and _snapshot(r.new_build) == _snapshot(expected) \
					and r.new_build.acquisitions_for(offer.support_fallback_card_id) == build.acquisitions_for(offer.support_fallback_card_id) \
					and r.new_ledger.has_consumed(root_seed) and r.new_ledger.count() == 2:
				good += 1
			elif faults.size() < 3:
				faults.append("root seed %d lane %d: %s" % [root_seed, lane, _result_line(r)])
	_expect(good == 2 * SEED_SAMPLES, "%d of %d ordinary lanes taken as before; %s" % [good, 2 * SEED_SAMPLES, "; ".join(faults)])
	print("  %d of %d ordinary passive-lane choices of a fallback offer: the lane's own card taken through the run build's acquisition, no Support content, no fallback category, the fallback card not acquired"
		% [good, 2 * SEED_SAMPLES])
	_done("the_ordinary_passive_lanes_of_a_fallback_offer_are_unchanged")


# --- 11. Fallback unavailable ------------------------------------------------------------------------------------------

func _check_fallback_unavailable_cannot_be_consumed() -> void:
	print("")
	print("--- 11. A fallback-unavailable refusal cannot be consumed at all")
	var two: Array[PassiveCardDefinition] = [PassiveCardCatalogue.record(CELERITY), PassiveCardCatalogue.record(FLEETNESS)]
	var unavailable: int = 0
	var refused: int = 0
	for root_seed: int in 64:
		var offer: RiftOffer = _compose(_held(2, 2), two, root_seed)
		if not offer.ok and offer.is_support_fallback_unavailable() and offer.problem().is_empty():
			unavailable += 1
		for lane: int in RiftOffer.LANE_ORDER:
			var build: RiftRunBuild = _build(2, 2)
			var ledger: RiftConsumptionLedger = _ledger()
			var attempt: Array = _attempt(offer, lane, build, ledger)
			var r: RiftOfferChoiceResult = attempt[0]
			_collect(r)
			if not r.ok and r.failure_reason == "the offer did not compose: %s" % offer.failure_reason and bool(attempt[1]) \
					and not ledger.has_consumed(root_seed) and r.root_seed == root_seed and _refused_whole(r):
				refused += 1
	_expect(unavailable == 64 and refused == 192, "%d unavailable offers, %d of 192 choices refused" % [unavailable, refused])
	print("  the shipped two-card catalogue [card_celerity, card_fleetness] at R2 S2: %d of 64 offers refuse as fallback-unavailable, and %d of 192 lane choices of them are refused as 'the offer did not compose' with nothing spent"
		% [unavailable, refused])
	_done("fallback_unavailable_cannot_be_consumed")


# --- 12. Every refusal --------------------------------------------------------------------------------------------------

func _check_every_refusal_exposes_nothing() -> void:
	print("")
	print("--- 12. Every refusal exposes no identity, content kind, category, build or ledger")
	var bare: int = 0
	var reasons: Dictionary = {}
	for r: RiftOfferChoiceResult in _collected_refusals:
		if _refused_whole(r):
			bare += 1
		reasons[r.failure_reason.get_slice(":", 0)] = true
	_expect(_collected_refusals.size() >= 300 and bare == _collected_refusals.size(),
		"%d of %d collected refusals are bare" % [bare, _collected_refusals.size()])
	print("  %d of %d refusals collected by checks 6-11 carry a reason and nothing else: no identity, Support content kind, fallback category, progression, build or ledger, and each is coherent by its own rule (%d distinct reason heads)"
		% [bare, _collected_refusals.size(), reasons.size()])
	_done("every_refusal_exposes_nothing")


# --- 13. Aliasing ----------------------------------------------------------------------------------------------------------

func _check_returned_values_do_not_alias_the_supplied_ones() -> void:
	print("")
	print("--- 13. The returned identity, build and ledger reach nothing supplied, and nothing supplied reaches them")
	var offer: RiftOffer = _compose(_held(2, 2), _cards(), EXAMPLE_SEED)
	var offer_before: String = _offer_snapshot(offer)
	var build: RiftRunBuild = _build(2, 2)
	var ledger: RiftConsumptionLedger = _ledger()
	var build_before: String = _snapshot(build)
	var ledger_before: String = _ledger_snapshot(ledger)
	var r: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, SUPPORT_LANE, build, ledger)
	_expect(r.ok, "the fixture choice was refused: %s" % r.failure_reason)

	var read: PackedStringArray = r.chosen_identity()
	read.append("zz_injected")
	var one: PackedStringArray = r.chosen_identity()
	var other: PackedStringArray = r.chosen_identity()
	one.append("zz_first")
	_expect(read.size() == 2 and r.chosen_identity().size() == 1 and other.size() == 1 and r.problem().is_empty(),
		"a read identity reached the result: %s" % ", ".join(r.chosen_identity()))

	_expect(r.new_build != build and r.new_ledger != ledger, "the result handed back a supplied object")
	r.new_build.acquire_passive_card(PassiveCardCatalogue.record(POWER))
	r.new_ledger.consume(777)
	_expect(_snapshot(build) == build_before and _ledger_snapshot(ledger) == ledger_before,
		"mutating the returned values moved the supplied ones")
	var returned_after: String = _snapshot(r.new_build)
	var returned_ledger_after: String = _ledger_snapshot(r.new_ledger)
	build.acquire_passive_card(PassiveCardCatalogue.record(INSIGHT))
	ledger.consume(888)
	_expect(_snapshot(r.new_build) == returned_after and _ledger_snapshot(r.new_ledger) == returned_ledger_after,
		"mutating the supplied values moved the returned ones")
	_expect(_offer_snapshot(offer) == offer_before, "the offer moved")

	var supplied: PackedStringArray = PackedStringArray(["card_celerity"])
	var made: RiftOfferChoiceResult = RiftOfferChoiceResult.chosen_support_fallback(
		EXAMPLE_SEED, supplied, COMBAT, RiftRunBuild.new(), _spent(EXAMPLE_SEED))
	supplied.append("zz_injected")
	_expect(made.chosen_identity().size() == 1 and made.problem().is_empty(),
		"the fallback constructor kept the array it was handed")

	var first: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, SUPPORT_LANE, _build(2, 2), _ledger())
	var second: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, SUPPORT_LANE, _build(2, 2), _ledger())
	var second_before: String = _snapshot(second.new_build)
	first.new_build.acquire_passive_card(PassiveCardCatalogue.record(VITALITY))
	_expect(_snapshot(second.new_build) == second_before, "two results share a build")
	print("  2 identity reads, 2 returned-value mutations, 2 supplied-value mutations, the fallback constructor's own array and two sibling results: 0 reached anything they should not; the offer byte-identical")
	_done("returned_values_do_not_alias_the_supplied_ones")


# --- 14. The result contract -------------------------------------------------------------------------------------------

func _check_the_result_contract_rejects_every_mixed_shape() -> void:
	print("")
	print("--- 14. The result contract: four coherent shapes, and every mixture of them refused")
	var progression: RiftOfferChoiceResult = RiftOfferChoice.choose(_compose(_held(0, 0), _cards(), 0),
		SUPPORT_LANE, RiftRunBuild.new(), RiftConsumptionLedger.new())
	var fallback: RiftOfferChoiceResult = RiftOfferChoice.choose(_compose(_held(2, 2), _cards(), EXAMPLE_SEED),
		SUPPORT_LANE, _build(2, 2), _ledger())
	var passive: RiftOfferChoiceResult = RiftOfferChoice.choose(_compose(_held(0, 0), _cards(), 0),
		COMBAT_LANE, RiftRunBuild.new(), RiftConsumptionLedger.new())
	var refusal: RiftOfferChoiceResult = RiftOfferChoiceResult.refused("zz refused for this check", 5, SUPPORT_LANE)
	var table: PackedStringArray = PackedStringArray()
	for shape: Array in [["Support progression", progression], ["Support passive fallback", fallback],
			["ordinary passive lane", passive], ["refusal", refusal]]:
		var r: RiftOfferChoiceResult = shape[1]
		table.append("%s: %d ids, progression %s, fallback category %s, coherent %s" % [String(shape[0]),
			r.chosen_identity().size(), "present" if r.carries_support_progression() else "absent",
			PassiveCardSelectionResult.category_label(r.support_fallback_category) if r.carries_support_fallback() else "unresolved",
			r.problem().is_empty()])
	_expect(", ".join(table) == "Support progression: 2 ids, progression present, fallback category unresolved, coherent true, "
			+ "Support passive fallback: 1 ids, progression absent, fallback category Combat and Defence, coherent true, "
			+ "ordinary passive lane: 1 ids, progression absent, fallback category unresolved, coherent true, "
			+ "refusal: 0 ids, progression absent, fallback category unresolved, coherent true",
		"the four shapes read %s" % "; ".join(table))

	## THE CONTENT-AWARE READING, and the accepted one-argument reading beside it, unmoved.
	var sizes: PackedStringArray = PackedStringArray()
	for row: Array in [[SUPPORT_LANE, PROGRESSION_KIND], [SUPPORT_LANE, FALLBACK_KIND], [SUPPORT_LANE, NO_CONTENT],
			[SUPPORT_LANE, 7], [COMBAT_LANE, NO_CONTENT], [UTILITY_LANE, NO_CONTENT], [COMBAT_LANE, FALLBACK_KIND],
			[UTILITY_LANE, PROGRESSION_KIND], [7, NO_CONTENT], [RiftOffer.UNRESOLVED_LANE, FALLBACK_KIND]]:
		sizes.append(str(RiftOfferChoiceResult.identity_size_for_content(int(row[0]), int(row[1]))))
	var legacy: PackedStringArray = PackedStringArray()
	for lane: int in [SUPPORT_LANE, COMBAT_LANE, UTILITY_LANE, 7, RiftOffer.UNRESOLVED_LANE]:
		legacy.append(str(RiftOfferChoiceResult.identity_size_for(lane)))
	_expect(",".join(sizes) == "2,1,0,0,1,1,0,0,0,0", "identity_size_for_content answers %s" % ",".join(sizes))
	_expect(",".join(legacy) == "2,1,1,0,0", "the preserved identity_size_for answers %s" % ",".join(legacy))

	## BOTH ONE-VERSUS-TWO MISTAKES.
	var one_id_progression: RiftOfferChoiceResult = RiftOfferChoiceResult.chosen(EXAMPLE_SEED, SUPPORT_LANE,
		PackedStringArray(["card_celerity"]), SupportContinuationResult.Kind.NEW_PAIR,
		AcquiredSupports.ABSENT_RANK, AcquiredSupports.FIRST_RANK, RiftRunBuild.new(), _spent(EXAMPLE_SEED))
	var two_id_fallback: RiftOfferChoiceResult = RiftOfferChoiceResult.chosen_support_fallback(EXAMPLE_SEED,
		PackedStringArray(["quick_strike", "reaching_edge"]), COMBAT, RiftRunBuild.new(), _spent(EXAMPLE_SEED))
	_expect(one_id_progression.problem() == "the Support lane granted 1 identifiers, not 2",
		"a one-id Support progression reports '%s'" % one_id_progression.problem())
	_expect(two_id_fallback.problem() == "the Support lane granted 2 identifiers, not 1",
		"a two-id Support fallback reports '%s'" % two_id_fallback.problem())

	## EVERY MIXED SHAPE, one field at a time on a fresh coherent result, then restored.
	var rows: Array = [
		["fallback", "support_progression_kind", SupportContinuationResult.Kind.NEW_PAIR, "the Support lane's passive fallback declares support progression kind 0"],
		["fallback", "support_rank_after", 1, "the Support lane's passive fallback exposes the support ranks 0 -> 1"],
		["fallback", "support_fallback_category", NO_CATEGORY, "the Support lane's passive fallback names category -1, which no passive lane draws from"],
		["fallback", "support_fallback_category", 7, "the Support lane's passive fallback names category 7, which no passive lane draws from"],
		["fallback", "support_content_kind", PROGRESSION_KIND, "the Support lane granted 1 identifiers, not 2"],
		["fallback", "support_content_kind", NO_CONTENT, "the Support lane declares the unknown Support content kind -1"],
		["fallback", "support_content_kind", 7, "the Support lane declares the unknown Support content kind 7"],
		["fallback", "lane", COMBAT_LANE, "the Combat and Defence lane declares Support content kind 1"],
		["progression", "support_content_kind", FALLBACK_KIND, "the Support lane granted 2 identifiers, not 1"],
		["progression", "support_fallback_category", COMBAT, "a Support progression names the fallback category 0"],
		["progression", "support_content_kind", NO_CONTENT, "the Support lane declares the unknown Support content kind -1"],
		["passive", "support_content_kind", FALLBACK_KIND, "the Combat and Defence lane declares Support content kind 1"],
		["passive", "support_content_kind", PROGRESSION_KIND, "the Combat and Defence lane declares Support content kind 0"],
		["passive", "support_fallback_category", UTILITY, "the Combat and Defence lane names the fallback category 1"],
		["refusal", "support_content_kind", FALLBACK_KIND, "a refused choice must declare no Support content kind, not 1"],
		["refusal", "support_fallback_category", COMBAT, "a refused choice must name no fallback category, not 0"],
	]
	var caught: int = 0
	var restored: int = 0
	var escaped: PackedStringArray = PackedStringArray()
	for row: Array in rows:
		var base: RiftOfferChoiceResult = _shape(String(row[0]))
		var original: Variant = base.get(String(row[1]))
		base.set(String(row[1]), row[2])
		if base.problem() == String(row[3]):
			caught += 1
		else:
			escaped.append("%s %s -> '%s'" % [String(row[0]), String(row[1]), base.problem()])
		base.set(String(row[1]), original)
		if base.problem().is_empty():
			restored += 1
	_expect(caught == rows.size() and restored == rows.size(),
		"%d caught, %d restored of %d; %s" % [caught, restored, rows.size(), "; ".join(escaped)])
	## `carries_support_fallback()` reads the stored kind and nothing else.
	var flagged: RiftOfferChoiceResult = RiftOfferChoiceResult.refused("zz", 5, SUPPORT_LANE)
	flagged.support_content_kind = FALLBACK_KIND
	_expect(not flagged.carries_support_fallback() and fallback.carries_support_fallback()
			and not progression.carries_support_fallback() and not passive.carries_support_fallback(),
		"carries_support_fallback() does not read the stored kind")

	## THE POINT-IN-TIME AUDIT STAYS PROGRESSION-ONLY: a later acquisition of the same card
	## does not make the historical fallback choice incoherent.
	var later: String = fallback.new_build.acquire_passive_card(PassiveCardCatalogue.record(CELERITY))
	_expect(later.is_empty() and fallback.new_build.acquisitions_for(CELERITY) == 2
			and fallback.problem().is_empty() and fallback.support_progression_build_problem().is_empty(),
		"a later acquisition made the fallback choice report '%s' / '%s'" % [fallback.problem(), fallback.support_progression_build_problem()])
	var raised: String = progression.new_build.rank_support(QS, REACH)
	_expect(raised.is_empty() and progression.problem().is_empty() and not progression.support_progression_build_problem().is_empty(),
		"the progression audit control did not report the moved rank")
	for line: String in table:
		print("  coherent — %s" % line)
	print("  identity_size_for_content: Support progression 2, Support fallback 1, Support without content 0, an undeclared kind 0, each passive lane 1, a passive lane with Support content 0, an undeclared lane 0; the preserved identity_size_for still answers Support 2, passive 1, undeclared 0")
	print("  both one-versus-two mistakes refused: '%s' and '%s'" % [one_id_progression.problem(), two_id_fallback.problem()])
	print("  %d of %d mixed shapes refused by exact message and each coherent again once restored; carries_support_fallback() reads only the stored kind"
		% [caught, rows.size()])
	print("  a later acquisition of the same card leaves the historical fallback choice coherent (card_celerity held twice, problem() and the audit both empty); the progression audit still reports a later rank")
	_done("the_result_contract_rejects_every_mixed_shape")


# --- 15. Downstream: the receipt path, extended by I9 (D-310) ---------------------------------------------------

## MOVED ONE FOR ONE UNDER ROGUELITE FOUNDATION I9 (D-310). Under I8 these four assertions
## RECORDED that the then-unchanged one-level receipt could not describe a consumed fallback:
## it reported itself incoherent, the unchanged coordinator committed it anyway, and the
## run-level record wrapping it was incoherent. I9 extends the receipt, so the same four now
## prove the fallback arrives whole — the receipt copies the Support content kind and the
## category, the unchanged coordinator commits and returns that coherent receipt, and the
## unchanged run-level record wrapping it is coherent. I9's own suite proves the rest.
func _check_the_downstream_receipt_path_records_the_fallback() -> void:
	print("")
	print("--- 15. The receipt path, handed a consumed fallback — extended by I9 (D-310)")
	var chosen: RiftOfferChoiceResult = RiftOfferChoice.choose(_compose(_held(2, 2), _cards(), EXAMPLE_SEED),
		SUPPORT_LANE, _build(2, 2), _ledger())
	var receipt: RiftLevelUpResult = RiftLevelUpResult.taken(chosen)
	_expect(chosen.ok and receipt.ok and receipt.lane == SUPPORT_LANE and receipt.root_seed == EXAMPLE_SEED
			and receipt.root_seed_known and ", ".join(receipt.granted_identity()) == "card_celerity"
			and receipt.support_progression_kind == RiftOffer.UNRESOLVED_PROGRESSION_KIND
			and not receipt.carries_support_progression() and receipt.describe() == "root seed 18 spent; Support: card_celerity",
		"the receipt reads %s" % receipt.describe())
	var receipt_fields: PackedStringArray = _fields_of(RiftLevelUpResult.new())
	_expect(receipt.problem().is_empty() and receipt.duplicated().problem().is_empty()
			and receipt.carries_support_fallback() and receipt.duplicated().carries_support_fallback()
			and receipt.support_content_kind == FALLBACK_KIND and receipt.support_fallback_category == COMBAT
			and receipt.support_fallback_line() == E2_FALLBACK_RECEIPT_LINE
			and receipt_fields.has("support_content_kind") and receipt_fields.has("support_fallback_category"),
		"the receipt reports '%s' and carries %s" % [receipt.problem(), ", ".join(receipt_fields)])

	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, _bare_build(2, 2), null)
	var awarded: String = lifecycle.award_experience(100.0)
	var opened: String = lifecycle.open_offer(100.0, _profiles(), _definitions(), _cards(), EXAMPLE_SEED)
	var offered: PackedStringArray = lifecycle.offer_identity_for(SUPPORT_LANE)
	var committed: RiftLevelUpResult = lifecycle.choose(SUPPORT_LANE)
	var after: RiftRunBuild = lifecycle.run_build()
	_expect(awarded.is_empty() and opened.is_empty() and ", ".join(offered) == "card_celerity"
			and committed.ok and committed.problem().is_empty() and committed.carries_support_fallback()
			and committed.support_fallback_category == COMBAT
			and lifecycle.level() == 2 and lifecycle.is_completed() and not lifecycle.is_offer_active()
			and lifecycle.consumption_ledger().count() == 1 and lifecycle.consumption_ledger().has_consumed(EXAMPLE_SEED)
			and after.acquisitions_for(CELERITY) == 1 and after.total_support_ranks() == 4
			and lifecycle.next_level_coordinator() != null,
		"the coordinator answered %s / '%s' at level %d" % [committed.describe(), committed.problem(), lifecycle.level()])
	## Run seed 18 derives root seed 18 at Level 1, so the unchanged run-level record can hold
	## this receipt coherently; I8 wrapped it at run seed 12345, where the receipt's own
	## incoherence was reported before any seed was compared.
	var record: RiftRunLevelUpResult = RiftRunLevelUpResult.recorded(EXAMPLE_SEED, 1, committed)
	_expect(record.problem().is_empty() and record.succeeded() and record.level_up().carries_support_fallback()
			and record.level_up().support_fallback_category == COMBAT,
		"the run-level record reports '%s'" % record.problem())

	## The control: a progression through the same unchanged path is coherent.
	var control: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, null, null)
	control.award_experience(100.0)
	control.open_offer(100.0, _profiles(), _definitions(), _cards(), 0)
	var control_receipt: RiftLevelUpResult = control.choose(SUPPORT_LANE)
	_expect(control_receipt.ok and control_receipt.problem().is_empty() and control_receipt.carries_support_progression(),
		"the progression control reports '%s'" % control_receipt.problem())
	print("  RiftLevelUpResult.taken() on the consumed fallback: ok, Support, root seed 18, [card_celerity], no progression — coherent since I9 (D-310), carrying content PASSIVE_FALLBACK and category %d: '%s'"
		% [receipt.support_fallback_category, receipt.support_fallback_line()])
	print("  through the unchanged one-level coordinator at root seed 18: the fallback Support choice COMMITS — Level %d, completed, %d seed consumed, card_celerity held once, a next coordinator available — and returns that coherent receipt"
		% [lifecycle.level(), lifecycle.consumption_ledger().count()])
	print("  the unchanged run-level record wrapping it at run seed 18, level 1 is coherent and hands out a copy carrying the fallback; a progression through the same path is coherent")
	print("  THE BINDING PREREQUISITE D-308 RECORDED IS MET BY I9 (D-310): the one-level receipt, the one-level coordinator's commit and the run-level record carry the Support content kind and the fallback category")
	_done("the_downstream_receipt_path_records_the_fallback_since_i9")


# --- 16. Unwired, and the shapes -------------------------------------------------------------------------------------

func _check_nothing_is_wired_and_the_shapes_are_pinned() -> void:
	print("")
	print("--- 16. Nothing is wired, and both edited files hold exactly their shapes")
	_expect(", ".join(_methods_of(CHOICE_FILE)) == ", ".join(EXPECTED_CHOICE_METHODS),
		"the transaction declares %s" % ", ".join(_methods_of(CHOICE_FILE)))
	_expect(", ".join(_methods_of(RESULT_FILE)) == ", ".join(EXPECTED_RESULT_METHODS),
		"the result declares %s" % ", ".join(_methods_of(RESULT_FILE)))
	var result_fields: PackedStringArray = _fields_of(RiftOfferChoiceResult.new())
	_expect(", ".join(result_fields) == ", ".join(EXPECTED_RESULT_FIELDS) and _fields_of(RiftOfferChoice.new()).is_empty(),
		"the result carries %s" % ", ".join(result_fields))
	_expect(", ".join(_named_classes(CHOICE_FILE)) == ", ".join(EXPECTED_CHOICE_CLASSES)
			and ", ".join(_named_classes(RESULT_FILE)) == ", ".join(EXPECTED_RESULT_CLASSES),
		"the transaction names [%s]; the result names [%s]" % [", ".join(_named_classes(CHOICE_FILE)), ", ".join(_named_classes(RESULT_FILE))])
	var leaks: PackedStringArray = PackedStringArray()
	for path: String in D3_FILES:
		var raw: String = FileAccess.get_file_as_string(path)
		var code: String = _code(path)
		for token: String in CONCRETE_TOKENS + AMBIENT_TOKENS:
			if raw.contains(token):
				leaks.append("%s names %s" % [path.get_file(), token])
		for token: String in WIRING_CODE_TOKENS:
			if code.contains(token):
				leaks.append("%s code names %s" % [path.get_file(), token])
	if FileAccess.get_file_as_string(RESULT_FILE).contains("PassiveCardCatalogue"):
		leaks.append("the result names the card catalogue")
	_expect(leaks.is_empty(), "; ".join(leaks))

	## THE COMMIT ORDER, READ FROM THE CODE, because no behaviour can show it: the
	## transaction stages on duplicates, so a seed consumed before a refused staging would
	## still leave the supplied ledger untouched. The fallback is staged inside `_stage()`,
	## routed on the stored content kind, before the seed is consumed; its success is built
	## only after; and the fallback staging names no ledger operation at all.
	var choose_body: String = _function_body(_code(CHOICE_FILE), "choose")
	var staged_at: int = choose_body.find("_stage(staged_build, offer, lane, identity)")
	var spent_at: int = choose_body.find("staged_ledger.consume(offer.root_seed)")
	var built_at: int = choose_body.find("RiftOfferChoiceResult.chosen_support_fallback(")
	var routed: String = _function_body(_code(CHOICE_FILE), "_stage")
	_expect(staged_at > 0 and spent_at > staged_at and built_at > spent_at
			and routed.contains("RiftOffer.SupportContentKind.PASSIVE_FALLBACK:")
			and routed.contains("return _stage_support_fallback(build, offer, identity)")
			and not _function_body(_code(CHOICE_FILE), "_stage_support_fallback").contains("consume("),
		"the commit order reads staged %d, spent %d, built %d" % [staged_at, spent_at, built_at])

	var scanned: int = 0
	var stray: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			scanned += 1
			if D3_FILES.has(path):
				continue
			var text: String = FileAccess.get_file_as_string(path)
			for token: String in I8_TOKENS:
				if text.contains(token) and not (path == RECEIPT_FILE and RECEIPT_I8_TOKENS.has(token)) \
						and not _i10_reader_may_name(path, token):
					stray.append("%s names %s" % [path.get_file(), token])
	## The receipt's grant is earned: it must still name every member it is granted.
	var receipt_text: String = FileAccess.get_file_as_string(RECEIPT_FILE)
	for token: String in RECEIPT_I8_TOKENS:
		if not receipt_text.contains(token):
			stray.append("the receipt no longer names its granted %s" % token)
	## So is each I10 reader's (D-312).
	for row: Array in I10_READER_TOKENS:
		var reader_text: String = FileAccess.get_file_as_string(String(row[0]))
		for token: String in row[1]:
			if not reader_text.contains(token):
				stray.append("%s no longer names its granted %s" % [String(row[0]).get_file(), token])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for token: String in I8_TOKENS:
		if settings.contains(token):
			stray.append("project.godot names %s" % token)
	_expect(scanned > 100 and stray.is_empty(), "%d files scanned; %s" % [scanned, ", ".join(stray)])
	var owned: int = 0
	for token: String in I8_TOKENS:
		if FileAccess.get_file_as_string(CHOICE_FILE).contains(token) or FileAccess.get_file_as_string(RESULT_FILE).contains(token):
			owned += 1
	_expect(owned == I8_TOKENS.size(), "%d of %d I8 members appear in the two edited files" % [owned, I8_TOKENS.size()])

	## Roguelite I11 (D-314), one for one: no single OFFERED_LEVEL any longer — the running review
	## asks each level's offer once, behind one integer guard whose empty value is NO_LEVEL_ASKED.
	var review_constants: Dictionary = _constants("res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd")
	var fresh_fallbacks: int = 0
	for root_seed: int in SEED_SAMPLES:
		if _compose(AcquiredSupports.new(), _cards(), root_seed).support_content_kind == FALLBACK_KIND:
			fresh_fallbacks += 1
	_expect(not review_constants.has("OFFERED_LEVEL") and review_constants.get("NO_LEVEL_ASKED") == 0 and fresh_fallbacks == 0,
		"the running review declares %s; a fresh build composed %d fallbacks" % [str(review_constants.keys()), fresh_fallbacks])
	_expect(_action_count() == EXPECTED_ACTIONS and not settings.contains("[autoload]")
			and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT,
		"project.godot holds %d actions" % _action_count())
	_expect(", ".join(_listing("res://scripts/choices")) == "rift_consumption_ledger.gd, rift_consumption_ledger.gd.uid, rift_offer_choice.gd, rift_offer_choice.gd.uid, rift_offer_choice_result.gd, rift_offer_choice_result.gd.uid",
		"scripts/choices/ holds %s" % ", ".join(_listing("res://scripts/choices")))
	print("  methods pinned: transaction %d, result %d; the result carries %d fields (the accepted 11 plus 2 appended); transaction state: 0 fields"
		% [EXPECTED_CHOICE_METHODS.size(), EXPECTED_RESULT_METHODS.size(), result_fields.size()])
	print("  the transaction names exactly %d project classes and the result %d — neither names the I6 fallback classes, and the fallback is read only through the offer's own field"
		% [EXPECTED_CHOICE_CLASSES.size(), EXPECTED_RESULT_CLASSES.size()])
	print("  both files scanned raw: 0 concrete names, 0 ambient reads; in code, no level, experience, receipt, panel, actor, application, save, input or signal")
	print("  STRUCTURAL, read from the code: choose() stages the lane — a fallback through _stage() on the stored content kind — before it consumes the seed, and builds the fallback success only after; the fallback staging names no ledger operation")
	print("  %d running files scanned: none but the two edited files names an I8 member, except the four the level-up receipt is granted since I9 (D-310) and those I10 (D-312) grants both level-up coordinators, the mote runtime and the running review; project.godot names none; the running review asks each level's offer once (I11, D-314), beginning at Level 1, and a fresh build composes 0 fallbacks over %d root seeds"
		% [scanned, SEED_SAMPLES])
	print("  project.godot: %d actions, the Prototype App entrypoint, no [autoload]; scripts/choices/ holds its 3 scripts and 3 uid files" % _action_count())
	_done("nothing_is_wired_and_the_shapes_are_pinned")


# --- 17. Accepted files and suites ----------------------------------------------------------------------------------

func _check_accepted_files_and_suites_moved_one_for_one() -> void:
	print("")
	print("--- 17. Every accepted file outside the two edited ones is byte-identical, and the moved pins are present")
	var unchanged: int = 0
	for row: Array in UNCHANGED_HASHES:
		var digest: String = FileAccess.get_sha256(String(row[0]))
		if digest.begins_with(String(row[1])):
			unchanged += 1
		else:
			_expect(false, "%s hashes %s, not %s…" % [String(row[0]), digest.left(8), String(row[1])])
	var edited: int = 0
	for row: Array in EDITED_HASHES:
		if FileAccess.get_sha256(String(row[0])).begins_with(String(row[1])):
			edited += 1
	_expect(unchanged == UNCHANGED_HASHES.size() and edited == EDITED_HASHES.size(),
		"%d of %d unchanged, %d of %d edited at their D-308 hash" % [unchanged, UNCHANGED_HASHES.size(), edited, EDITED_HASHES.size()])

	var d3: Dictionary = _constants(D3_SUITE)
	_expect(str(d3.get("EXPECTED_CHOICE_METHODS")) == str(EXPECTED_CHOICE_METHODS)
			and str(d3.get("EXPECTED_RESULT_METHODS")) == str(EXPECTED_RESULT_METHODS)
			and str(d3.get("EXPECTED_RESULT_FIELDS")) == str(EXPECTED_RESULT_FIELDS),
		"the D3 suite's pins do not match the delivered shape")
	var f1_choice: Array = []
	var f1_result: Array = []
	for row: Array in _constants(F1_SUITE).get("AUTHORIZED_CALLERS", []):
		if String(row[0]) == CHOICE_FILE:
			f1_choice = row[1]
		if String(row[0]) == RESULT_FILE:
			f1_result = row[1]
	_expect(f1_choice.has("total_support_ranks(") and not f1_result.has("total_support_ranks(")
			and FileAccess.get_file_as_string(F1_RUNNER).contains("scripts/choices/rift_offer_choice.gd|support_rank_for(,rank_support(,rank_for(,total_support_ranks(")
			and FileAccess.get_file_as_string(CHOICE_FILE).contains("build.total_support_ranks()"),
		"F1 grants the transaction %s and the result %s" % [str(f1_choice), str(f1_result)])
	var i5: String = FileAccess.get_file_as_string(I5_SUITE)
	_expect(i5.contains("shape != \"new 0->1, new 0->1, rank 1->2, rank 1->2, fallback, fallback\"")
			and i5.contains("and taken.ok and taken.carries_support_fallback()")
			and i5.contains("fallback_choice.ok and fallback_choice.carries_support_fallback()")
			and FileAccess.get_file_as_string(I5_RUNNER).contains("8064 refusals were driven across this suite"),
		"the I5 suite or runner does not carry its move")
	var i6_hashes: Dictionary = {}
	var i6_rows: Array = _constants(I6_SUITE).get("ACCEPTED_HASHES", [])
	for row: Array in i6_rows:
		i6_hashes[String(row[0])] = String(row[1])
	_expect(String(i6_hashes.get(CHOICE_FILE, "")) == "533ee30f" and String(i6_hashes.get(RESULT_FILE, "")) == "f051a955"
			and i6_rows.size() == 24,
		"the I6 suite pins %s / %s over %d rows" % [i6_hashes.get(CHOICE_FILE, ""), i6_hashes.get(RESULT_FILE, ""), i6_rows.size()])
	## Roguelite Foundation I9 (D-310) added the level-up receipt as I7's third consuming reader
	## and moved I7's receipt hash row; I7's row count did not move. Roguelite I10 (D-312) added
	## both level-up coordinators, the mote runtime and the running review as four more: seven.
	var i7: Dictionary = _constants(I7_SUITE)
	var i7_hashes: Dictionary = {}
	for row: Array in i7.get("UNCHANGED_HASHES", []):
		i7_hashes[String(row[0])] = String(row[1])
	var i7_owed: Array = i7.get("OWED_CHECKS", [])
	var i7_runner: String = FileAccess.get_file_as_string(I7_RUNNER)
	_expect(String(i7_hashes.get(CHOICE_FILE, "")) == "533ee30f" and String(i7_hashes.get(RESULT_FILE, "")) == "f051a955"
			and i7_hashes.size() == 27 and i7_owed.size() == 18
			and i7_owed.has("the_i8_choice_transaction_consumes_the_fallback_lane")
			and not i7_owed.has("the_unchanged_choice_transaction_refuses_the_fallback_lane")
			and (i7.get("CONSUMING_READERS", []) as Array).size() == 7
			and i7_runner.contains("2644 refusals were driven across this suite")
			and i7_runner.contains("SupportContentKind|PASSIVE_FALLBACK|SUPPORT_PROGRESSION|support_content_kind|support_fallback)"),
		"the I7 suite or runner does not carry its move")
	print("  %d of %d accepted files byte-identical by SHA-256 prefix to the tree before the first I8 edit, except the level-up receipt, pinned at its D-310 hash, and both level-up coordinators and the mote runtime, pinned at their D-312 hashes, and the running review and its panel, at their D-314 hashes, and the seam, its result and the live-effect review, at their D-320 hashes, the result at its D-321 hash, the panel at its D-322 hash —the offer and composer, the I6 fallback, the ledger, the run build, the card records and selector, the continuation, every level-up coordinator and receipt, the mote runtime, the running review and its panel, the live-effect seam and review, and project.godot"
		% [unchanged, UNCHANGED_HASHES.size()])
	print("  the transaction 533ee30f… and its result f051a955… at their D-308 hashes")
	print("  D3: three pins moved; F1: total_support_ranks( granted to the transaction alone; I5: checks 18, 19 and 23 moved, 8064 refusals; I6: two hash rows (24); I7: check 12 renamed and moved, two hash rows (27), five members granted to each choice file, 2644 refusals")
	_done("accepted_files_and_suites_moved_one_for_one")


# --- Helpers ----------------------------------------------------------------------------------------------------------

## Whether `path` is one of Roguelite I10's readers granted I8 member `token` by
## `I10_READER_TOKENS` (D-312). Per file and per member.
func _i10_reader_may_name(path: String, token: String) -> bool:
	for row: Array in I10_READER_TOKENS:
		if String(row[0]) == path:
			return (row[1] as Array).has(token)
	return false


func _profiles() -> Array[SkillTagProfile]:
	return SkillSupportCatalogue.skill_profiles()


func _definitions() -> Array[SupportDefinition]:
	return SkillSupportCatalogue.support_definitions()


func _cards() -> Array[PassiveCardDefinition]:
	return PassiveCardCatalogue.records()


func _compose(held: AcquiredSupports, cards: Array[PassiveCardDefinition], root_seed: int) -> RiftOffer:
	return RiftOfferComposition.compose(_profiles(), _definitions(), held, cards, root_seed)


func _corpus_seeds() -> Array[int]:
	var seeds: Array[int] = []
	for s: int in 128:
		seeds.append(s)
	seeds.append_array(SPECIAL_SEEDS)
	return seeds


## The shipped pairs at the given ranks, as an acquisition record.
func _held(reaching: int, sweeping: int) -> AcquiredSupports:
	var record: AcquiredSupports = AcquiredSupports.new()
	for row: Array in [[REACH, reaching], [SWEEP, sweeping]]:
		if int(row[1]) >= 1:
			record.acquire(QS, row[0] as StringName)
		for _step: int in range(int(row[1]) - 1):
			record.increase_rank(QS, row[0] as StringName)
	return record


## The same record, the pairs acquired in the opposite order.
func _held_backwards(reaching: int, sweeping: int) -> AcquiredSupports:
	var record: AcquiredSupports = AcquiredSupports.new()
	for row: Array in [[SWEEP, sweeping], [REACH, reaching]]:
		if int(row[1]) >= 1:
			record.acquire(QS, row[0] as StringName)
		for _step: int in range(int(row[1]) - 1):
			record.increase_rank(QS, row[0] as StringName)
	return record


## The run build at those ranks holding card_vitality once — exactly the probe's.
func _build(reaching: int, sweeping: int) -> RiftRunBuild:
	var build: RiftRunBuild = _bare_build(reaching, sweeping)
	build.acquire_passive_card(PassiveCardCatalogue.record(VITALITY))
	return build


func _bare_build(reaching: int, sweeping: int) -> RiftRunBuild:
	var build: RiftRunBuild = RiftRunBuild.new()
	for row: Array in [[REACH, reaching], [SWEEP, sweeping]]:
		if int(row[1]) >= 1:
			build.acquire_support(QS, row[0] as StringName)
		for _step: int in range(int(row[1]) - 1):
			build.rank_support(QS, row[0] as StringName)
	return build


## A ledger already holding one seed no check composes, exactly the probe's.
func _ledger() -> RiftConsumptionLedger:
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	ledger.consume(-424242)
	return ledger


func _spent(root_seed: int) -> RiftConsumptionLedger:
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	ledger.consume(root_seed)
	return ledger


## A fabricated card. Test data only; not canon.
func _card(card_id: String, stat_id: StringName) -> PassiveCardDefinition:
	return PassiveCardDefinition.of(StringName(card_id), "Test %s" % card_id, stat_id, 0.10, 100, true)


## A fresh coherent result of one of the three success shapes, or a refusal.
func _shape(kind: String) -> RiftOfferChoiceResult:
	match kind:
		"fallback":
			return RiftOfferChoiceResult.chosen_support_fallback(EXAMPLE_SEED,
				PackedStringArray(["card_celerity"]), COMBAT, RiftRunBuild.new(), _spent(EXAMPLE_SEED))
		"progression":
			return RiftOfferChoiceResult.chosen(0, SUPPORT_LANE, PackedStringArray(["quick_strike", "reaching_edge"]),
				SupportContinuationResult.Kind.NEW_PAIR, AcquiredSupports.ABSENT_RANK, AcquiredSupports.FIRST_RANK,
				RiftRunBuild.new(), _spent(0))
		"passive":
			return RiftOfferChoiceResult.chosen(0, COMBAT_LANE, PackedStringArray(["card_vitality"]),
				RiftOffer.UNRESOLVED_PROGRESSION_KIND, RiftOfferChoiceResult.NO_RANK, RiftOfferChoiceResult.NO_RANK,
				RiftRunBuild.new(), _spent(0))
	return RiftOfferChoiceResult.refused("zz refused for this check", 5, SUPPORT_LANE)


## One choice, with whole snapshots of the three supplied values before and after.
func _attempt(offer: RiftOffer, lane: int, build: RiftRunBuild, ledger: RiftConsumptionLedger) -> Array:
	var before: String = "%s || %s || %s" % [_snapshot(build), _ledger_snapshot(ledger), _offer_snapshot(offer)]
	var r: RiftOfferChoiceResult = RiftOfferChoice.choose(offer, lane, build, ledger)
	var after: String = "%s || %s || %s" % [_snapshot(build), _ledger_snapshot(ledger), _offer_snapshot(offer)]
	return [r, before == after]


## "" when `r` is the whole, correct consumption of `offer`'s fallback Support lane against
## `build` and `ledger` — proofs 2 to 8 — or the first thing that is not.
func _fallback_consumed(offer: RiftOffer, r: RiftOfferChoiceResult, build: RiftRunBuild,
		ledger: RiftConsumptionLedger) -> String:
	if offer == null or not offer.ok or offer.support_content_kind != FALLBACK_KIND:
		return "the offer is not a fallback offer"
	var card: StringName = offer.support_fallback_card_id
	if r == null or not r.ok:
		return "refused: %s" % ("no result" if r == null else r.failure_reason)
	if not r.problem().is_empty():
		return "incoherent: %s" % r.problem()
	if not r.carries_support_fallback() or r.carries_support_progression():
		return "content kind %d" % r.support_content_kind
	if r.lane != SUPPORT_LANE or not r.root_seed_known or r.root_seed != offer.root_seed:
		return "lane %d, seed %d" % [r.lane, r.root_seed]
	if r.chosen_identity() != PackedStringArray([String(card)]):
		return "identity [%s]" % ", ".join(r.chosen_identity())
	var canonical: PassiveCardDefinition = PassiveCardCatalogue.record(card)
	if r.support_fallback_category != offer.support_fallback.selected_category \
			or canonical == null or canonical.category() != r.support_fallback_category:
		return "category %d" % r.support_fallback_category
	if r.new_build.acquisitions_for(card) != build.acquisitions_for(card) + 1:
		return "%s held %d -> %d" % [card, build.acquisitions_for(card), r.new_build.acquisitions_for(card)]
	var expected: RiftRunBuild = build.duplicated()
	if not expected.acquire_passive_card(canonical).is_empty() or _snapshot(expected) != _snapshot(r.new_build):
		return "not the run build's own acquisition of the canonical record"
	for ordinary: StringName in [offer.combat_card_id, offer.utility_card_id]:
		if r.new_build.acquisitions_for(ordinary) != build.acquisitions_for(ordinary):
			return "the ordinary card %s was acquired" % ordinary
	if r.new_build.support_pairs() != build.support_pairs() \
			or r.new_build.total_support_ranks() != build.total_support_ranks() \
			or r.new_build.support_rank_for(QS, REACH) != build.support_rank_for(QS, REACH) \
			or r.new_build.support_rank_for(QS, SWEEP) != build.support_rank_for(QS, SWEEP):
		return "a support pair or rank moved"
	if r.new_ledger.count() != ledger.count() + 1 or not r.new_ledger.has_consumed(offer.root_seed) \
			or ledger.has_consumed(offer.root_seed):
		return "the seed was not spent exactly once"
	for spent_seed: int in ledger.consumed_seeds():
		if not r.new_ledger.has_consumed(spent_seed):
			return "the new ledger lost %d" % spent_seed
	return ""


## A refusal carrying a reason and nothing else, and coherent by its own rule.
func _refused_whole(r: RiftOfferChoiceResult) -> bool:
	return r != null and not r.ok and not r.failure_reason.strip_edges().is_empty() \
		and r.chosen_identity().is_empty() and r.new_build == null and r.new_ledger == null \
		and r.support_content_kind == NO_CONTENT and r.support_fallback_category == NO_CATEGORY \
		and r.support_progression_kind == RiftOffer.UNRESOLVED_PROGRESSION_KIND \
		and r.support_rank_before == RiftOfferChoiceResult.NO_RANK \
		and r.support_rank_after == RiftOfferChoiceResult.NO_RANK \
		and not r.carries_support_fallback() and not r.carries_support_progression() \
		and r.problem().is_empty() and r.identity_line() == "nothing granted"


func _collect(r: RiftOfferChoiceResult) -> void:
	_refusals += 1
	_collected_refusals.append(r)


## PRE-I8 MEMBERS ONLY — verbatim from the probe that measured the digest.
func _row(r: RiftOfferChoiceResult, supplied_build: RiftRunBuild, supplied_ledger: RiftConsumptionLedger) -> String:
	return "ok=%s | reason='%s' | seed=%d known=%s | lane=%d | kind=%d ranks=%d->%d | ids=[%s] | problem='%s' | line=%s | prog=%s | audit='%s' | describe=%s | new_build={%s} | new_ledger={%s} | supplied_build={%s} | supplied_ledger={%s}" % [
		r.ok, r.failure_reason, r.root_seed, r.root_seed_known, r.lane,
		r.support_progression_kind, r.support_rank_before, r.support_rank_after,
		", ".join(r.chosen_identity()), r.problem(), r.identity_line(), r.support_progression_line(),
		r.support_progression_build_problem(), r.describe(),
		_snapshot(r.new_build), _ledger_snapshot(r.new_ledger),
		_snapshot(supplied_build), _ledger_snapshot(supplied_ledger),
	]


## The pre-I8 row plus the two I8 fields.
func _full_row(r: RiftOfferChoiceResult, supplied_build: RiftRunBuild, supplied_ledger: RiftConsumptionLedger) -> String:
	return "%s | content=%d category=%d" % [_row(r, supplied_build, supplied_ledger),
		r.support_content_kind, r.support_fallback_category]


func _result_line(r: RiftOfferChoiceResult) -> String:
	if r == null:
		return "no result"
	return "%s [ok=%s content=%d category=%d kind=%d ranks=%d->%d ids=%s problem='%s']" % [
		r.describe(), r.ok, r.support_content_kind, r.support_fallback_category,
		r.support_progression_kind, r.support_rank_before, r.support_rank_after,
		", ".join(r.chosen_identity()), r.problem()]


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
	parts.append("empty=%s" % build.is_empty())
	return " | ".join(parts)


func _ledger_snapshot(ledger: RiftConsumptionLedger) -> String:
	if ledger == null:
		return "no ledger"
	return "count=%d seeds=[%s] empty=%s" % [ledger.count(), _seeds_line(ledger), ledger.is_empty()]


func _seeds_line(ledger: RiftConsumptionLedger) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for root_seed: int in ledger.consumed_seeds():
		parts.append(str(root_seed))
	return ", ".join(parts)


## The whole offer, fallback derivation included, so a transaction that moved any of it
## is caught.
func _offer_snapshot(o: RiftOffer) -> String:
	if o == null:
		return "no offer"
	var derivation: String = "none"
	if o.support_fallback != null:
		var f: SupportExhaustionPassiveFallbackResult = o.support_fallback
		derivation = "ok=%s category=%d card=%s tickets=%d/%d normalized=%d excluded=%s problem='%s'" % [
			f.ok, f.selected_category, f.selected_card_id, f.category_ticket, f.card_ticket,
			f.normalized_category_ticket, str(f.excluded_card_ids()), f.problem()]
	return "%s | content=%d card=%s unavailable=%s | skill=%s support=%s kind=%d %d->%d | %s | %s | problem='%s'" % [
		o.describe(), o.support_content_kind, o.support_fallback_card_id, o.support_fallback_unavailable,
		o.skill_id, o.support_id, o.support_progression_kind, o.support_rank_before, o.support_rank_after,
		o.support_fallback_line(), derivation, o.problem()]


func _nonzero_stats(build: RiftRunBuild) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for stat_id: StringName in PlayerStats.ALL:
		if build.total_for(stat_id) != 0.0 or build.contribution_count_for(stat_id) != 0:
			parts.append("%s=%s(%d)" % [stat_id, String.num(build.total_for(stat_id), 17), build.contribution_count_for(stat_id)])
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
