extends SceneTree
## Riftwrought — Roguelite I11: Repeated Playable Level-Up Offer Loop V1: automated,
## rendered verification (decision D-314).
##
## THE ONE QUESTION: can one expedition open, and resolve one at a time, a distinct
## three-card offer for EVERY Rift level it reaches — each from its own root seed, each
## chosen by its own fresh input — with the world held continuously while banked levels
## are chosen, and nothing chosen, skipped, collapsed or retried on its own?
##
## IT OWNS NO SCENE AND ADDS NO ENTRY POINT TO ANY RUNTIME. This is a SceneTree script: it
## loads the accepted I2 scene, `roguelite_level_up_choice_review.tscn`, exactly as it ships,
## and drives it from outside. The scene answers only its own I2 flag, which this harness
## does not pass, so no accepted suite starts in it.
##
## SIX EXPEDITIONS, EVERY ONE OF SEED 99:
##   A — keyboard. The route's own motes to exactly 100, Level 1 opened on its own, Support;
##       125 to Level 2's exact requirement, opened on its own, Support; then 525 banked at
##       Level 3, so Levels 3, 4 and 5 are chosen one after another in one panel that never
##       lets the world go — Level 5 being the naturally reached passive fallback — and the
##       fallback taken; then 225 at Level 6, opened on its own and taken, to Level 7.
##   B — controller. 250 at Level 1: Support by (A) while (A) is HELD, the Level 2 offer taking
##       its place; the still-held (A) refused by the panel; after its release the D-pad and a
##       fresh (A) take Combat and Defence — a pending in-range mote untouched throughout.
##   C — mouse. 250 at Level 1: Support by a click, the Level 2 offer taking its place; a fresh
##       click takes Utility.
##   D — keyboard again from Level 1 to Level 3, a refused Level 3 opening, then death and the
##       Fallen overlay's return to the Nexus.
##   E — the route completed: the run-summary, no offer after it.
##   F — the next expedition begins at Level 1 with nothing asked for.
##
## STAGED, AND STATED WHERE IT HAPPENS:
##   - expeditions B to F are handed seed 99 again by replacing the Nexus's next run plan
##     (D-294 ruling 4);
##   - the route's five Graveblades carry 125 experience in all, so every award beyond them
##     is made the way I10 made its awards: a production Graveblade in the Nexus, registered
##     with the expedition's own H8 runtime for exactly that amount through H8's public
##     `register_graveblade()`, killed through its own `receive_damage()`, and its mote
##     collected by one explicit H8 sweep where it fell — the accepted Experience Mote path,
##     with the harness standing in for the experience source the scene does not yet have.
##     Every OPENING after an award is the review's own, on its own tick;
##   - in B the player is placed onto a pending mote while the panel holds the world, and the
##     still-held (A) is represented by `Input.action_press()` — a held control's state with
##     no event, exactly what a real held button leaves behind;
##   - in D the harness opens the Level 3 offer through H8 itself, so the review's own one
##     request for that level meets a refusal no real route can produce;
##   - the refused CHOICE of check 8 hands the review's card entry point lane 7.
##
## A PAUSE PROBE MEASURES THE CONTINUOUS PAUSE. A plain `Node` this harness adds beside the
## scene counts every physics tick a pausable node receives and every NOTIFICATION_UNPAUSED
## the tree sends it: between chained offers both must stay unchanged.
##
## TWO THINGS ARE DRIVEN IN LOCKSTEP BESIDE THE REVIEW'S OWN RUN: a G4 twin of the same seed,
## given the same awards and the same choices, whose ledger and offers are readable.
##
## IT PORTS D-211's OWED-SET DISCIPLINE and GATE F's ON-SCREEN MEASUREMENT. The evidence
## frames add no assertion, so the headless and rendered runs pin the same count.
##
## Run: godot --headless --path game --script res://tests/roguelite_repeated_level_up_offer_loop_verification.gd -- --seed 99

const REVIEW_SCENE: String = "res://scenes/roguelite/roguelite_level_up_choice_review.tscn"
const REVIEW_SCRIPT: String = "res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
const PANEL_SCRIPT: String = "res://scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
const THIS_FILE: String = "res://tests/roguelite_repeated_level_up_offer_loop_verification.gd"
const GRAVEBLADE_SCENE: String = "res://scenes/actors/prototype_graveblade.tscn"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31

const ROUTE_SEED: int = 99
const REVIEW_AMOUNT: float = 25.0
const SUPPORT: int = 0
const COMBAT: int = 1
const UTILITY: int = 2

## Seed 99's chain, G1's and G2's own answers, typed and asserted against them.
const REQUIREMENTS: Array[float] = [100.0, 125.0, 150.0, 175.0, 200.0, 225.0, 250.0]
const ROOTS: Array[int] = [99, 1000102, 2000105, 3000108, 4000111, 5000114]

## Seed 99 with Support taken at every level: the accepted I10 table (D-312), Levels 1–5.
const SUPPORT_IDENTITIES: Array = [
	[["quick_strike", "sweeping_edge"], ["card_celerity"], ["card_fleetness"]],
	[["quick_strike", "reaching_edge"], ["card_power"], ["card_magnetism"]],
	[["quick_strike", "reaching_edge"], ["card_vitality"], ["card_fleetness"]],
	[["quick_strike", "sweeping_edge"], ["card_power"], ["card_magnetism"]],
	[["card_power"], ["card_vitality"], ["card_fleetness"]],
]
const SUPPORT_KINDS: Array[int] = [0, 0, 0, 0, 1]
const SUPPORT_CATEGORIES: Array[int] = [-1, -1, -1, -1, 0]
const SUPPORT_PROGRESSIONS: Array[String] = [
	"a new compatible pair, rank 0 -> 1", "a new compatible pair, rank 0 -> 1",
	"another rank of a held pair, rank 1 -> 2", "another rank of a held pair, rank 1 -> 2",
	"Passive fallback from Combat and Defence",
]
const SUPPORT_CHOICES: Array[String] = [
	"Support — Quick Strike → Sweeping Edge", "Support — Quick Strike → Reaching Edge",
	"Support — Quick Strike → Reaching Edge", "Support — Quick Strike → Sweeping Edge",
	"Support — Power (+10% Global Damage)",
]
## Seed 99's accepted Level 1 cards (D-293) and I10's accepted fallback cards (D-312), word for word.
const LEVEL_ONE_CARDS: Array = [
	["Support", "Sweeping Edge", "Applies to Quick Strike"],
	["Combat and Defence", "Celerity", "+10% Skill Speed"],
	["Utility", "Fleetness", "+10% Movement Speed"],
]
const LEVEL_ONE_CAPTIONS: Array[String] = ["Choose Sweeping Edge", "Choose Celerity", "Choose Fleetness"]
const FALLBACK_CARDS: Array = [
	["Support", "Power", "Supports maxed — +10% Global Damage"],
	["Combat and Defence", "Vitality", "+15% Maximum Life"],
	["Utility", "Fleetness", "+10% Movement Speed"],
]
const FALLBACK_CAPTIONS: Array[String] = ["Choose Power", "Choose Vitality", "Choose Fleetness"]
const FALLBACK_RECEIPT: Array[String] = [
	"Temporary build — this expedition", "Support — Power (+10% Global Damage)",
	"Passive fallback from Combat and Defence", "Rift level 5 → 6 · 0 XP carried over",
	"Recorded in the temporary build; not applied to the character in this review.",
]
const LEVEL_ONE_RECEIPT: Array[String] = [
	"Temporary build — this expedition", "Support — Quick Strike → Sweeping Edge",
	"a new compatible pair, rank 0 -> 1", "Rift level 1 → 2 · 0 XP carried over",
	"Recorded in the temporary build; not applied to the character in this review.",
]

const GREYBOX_NOTE: String = "Choices are recorded in this expedition's temporary build. Applying their effects to the playable character is not part of this review."
const OFFER_STANDING_TEXT: String = "Level-up offer open — choose one of the three cards."
const RECEIPT_TITLE_TEXT: String = "Temporary build — this expedition"
const RECEIPT_NOTE: String = "Recorded in the temporary build; not applied to the character in this review."
const NO_OFFER: String = "no offer is open; one must be opened before a lane may be taken"
const ALREADY_OPEN_AT_THREE: String = "level 3 already has an offer open; only a lane of that offer may be taken"
const REFUSAL_PREFIX: String = "That choice was refused: "
const STANDING_LINES: Array[String] = [RECEIPT_TITLE_TEXT, OFFER_STANDING_TEXT]

const QUICK_STRIKE: StringName = &"quick_strike"
const SWEEPING_EDGE: StringName = &"sweeping_edge"
const REACHING_EDGE: StringName = &"reaching_edge"
const POWER: StringName = &"card_power"
const MAGNETISM: StringName = &"card_magnetism"
const MAXIMUM_RANK: int = 2

## The accepted live values (D-175, D-178 and the canonical Quick Strike record).
const ACCEPTED_MAX_SPEED: float = 5.0
const ACCEPTED_ACTION_TIME: float = 0.80
const ACCEPTED_REACH: float = 1.65
const ACCEPTED_ARC: float = 100.0
const ACCEPTED_CONE: float = 65.0

## H9's review-panel text controls, in its `text_controls()` order.
const HUD_LEVEL: int = 2
const HUD_EXPERIENCE: int = 3
const HUD_REFUSAL: int = 7
const HUD_LEVEL_UP: int = 8
const HUD_LEVEL_UP_NOTE: int = 9

## The review's own fields and constants after D-314: the one-integer guard in place of the
## accepted boolean, and no single offered level.
const EXPECTED_FIELDS: String = "level_up_panel, offer_open_calls, offer_open_refusals, last_offer_refusal, choice_attempts, choice_refusals, choices_taken, last_choice_record, last_retained_experience, _offer_attempted_level, _receipt, _receipt_rule, _receipt_title, _receipt_status, _receipt_choice, _receipt_progression, _receipt_level, _receipt_note"
const EXPECTED_CONSTANTS: String = "LEVEL_UP_VERIFICATION_SCRIPT, OFFER_PANEL_SCRIPT, NO_LEVEL_ASKED, RECEIPT_TITLE, RECEIPT_NOTE, OFFER_STANDING_TEXT, SUPPORTS_MAXED_DETAIL, FALLBACK_RECEIPT_LINE"
## Nothing that would be a cap, a queue, a history or a second seed counter, in the review's code.
const GUARD_FORBIDDEN: Array[String] = [
	"OFFERED_LEVEL", "MAX_", "LEVEL_CAP", "_CAP", "queue", "history", "_pending", "offer_root_seed",
	"RiftLevelOfferSeed", "RiftLevelRequirement", "consumption_ledger", "while ", "Array[int]",
]
## The five functions on the opening and choosing path: none may loop.
const PATH_FUNCTIONS: Array[String] = [
	"_open_offer_when_ready", "_current_level_is_owed_an_offer", "_ask_for_current_offer",
	"_present_standing_offer", "choose_offered_lane",
]

## Accepted production files I11 must not touch, by the SHA-256 prefix each held before the
## first I11 edit: G1–G4 and E2, H8, D1, D3, the I6 fallback, the run build, both catalogues,
## H9, the modal contract, the core loop, I3's review and seam, the I2 scene and project.godot.
const UNCHANGED_HASHES: Array = [
	["res://scripts/levels/rift_level_up_coordinator.gd", "f178c358"],
	["res://scripts/levels/rift_level_up_result.gd", "2d67cee9"],
	["res://scripts/levels/rift_run_level_coordinator.gd", "b654e0a2"],
	["res://scripts/levels/rift_run_level_up_result.gd", "cc7f8b84"],
	["res://scripts/experience/rift_mote_runtime.gd", "23c41eb2"],
	["res://scripts/level_requirements/rift_level_requirement_curve.gd", "c8b3f3b1"],
	["res://scripts/level_seeds/rift_level_offer_seed_derivation.gd", "5cc31f28"],
	["res://scripts/choices/rift_offer_choice.gd", "533ee30f"],
	["res://scripts/choices/rift_offer_choice_result.gd", "f051a955"],
	["res://scripts/choices/rift_consumption_ledger.gd", "f990eab7"],
	["res://scripts/offers/rift_offer.gd", "9bc94208"],
	["res://scripts/offers/rift_offer_composition.gd", "15ef203a"],
	["res://scripts/fallback/support_exhaustion_passive_fallback.gd", "c1cad5e4"],
	["res://scripts/fallback/support_exhaustion_passive_fallback_result.gd", "a195665f"],
	["res://scripts/runs/rift_run_build.gd", "1920ae25"],
	["res://scripts/stats/passive_card_catalogue.gd", "278b30dc"],
	["res://scripts/skills/skill_support_catalogue.gd", "a94f61cc"],
	["res://scripts/roguelite/experience/roguelite_experience_collection_review.gd", "150509d5"],
	["res://scripts/roguelite/experience/roguelite_experience_review_hud.gd", "042a5088"],
	## First-MVP UI J1 (D-322) moved the modal contract one for one — `8d57039b` → `1cfe9c73` — to let a
	## left press reach the GUI. Same count.
	["res://scripts/ui/first_mvp_modal.gd", "1cfe9c73"],
	["res://scripts/roguelite/roguelite_core_loop_runtime.gd", "a76cec3d"],
	## Roguelite I12 (D-316) moved I3's review one for one — `6a260f4c` → `ec2ec19e` — to the
	## D-316 file, the one production file I12 edits. Same count. Roguelite I13 (D-318) moved it
	## again, `ec2ec19e` → `f4eab7a4`, and the seam, `1aa00c5f` → `63c7fe71`. Same count.
	## Roguelite I14 (D-320) moved both once more — `f4eab7a4` → `75cb02b9` and `63c7fe71` →
	## `c7b9df38` — making Maximum Life live. Same count.
	["res://scripts/roguelite/live_effects/roguelite_live_effect_review.gd", "75cb02b9"],
	["res://scripts/roguelite/live_effects/rift_build_application.gd", "c7b9df38"],
	["res://scenes/roguelite/roguelite_level_up_choice_review.tscn", "7038bce6"],
	["res://project.godot", "55351038"],
]

## What this harness must never do to the review or the run. Read over this file's own CODE,
## comments removed and strings emptied.
const INJECTION_PATTERNS: Array[String] = [
	"review._", ".mote_runtime._", "level_up_panel._", "mote_runtime = ", "with_state(",
	"review.set(", "review.call(", ".callv(", "set_meta(", "add_action(", "action_add_event(",
	"while ", "_offer_attempted_level =", "_receipt_from(", "_card_for(",
]

## The pause probe's own script: a plain Node counting what a pausable node receives.
const PROBE_SOURCE: String = "extends Node\nvar unpaused: int = 0\nvar paused_notices: int = 0\nvar ticks: int = 0\nfunc _notification(what: int) -> void:\n\tif what == NOTIFICATION_UNPAUSED:\n\t\tunpaused += 1\n\telif what == NOTIFICATION_PAUSED:\n\t\tpaused_notices += 1\nfunc _physics_process(_delta: float) -> void:\n\tticks += 1\n"

const OWED_CHECKS: Array[String] = [
	"the_harness_is_isolated_and_drives_the_accepted_scene",
	"the_guard_is_one_integer_with_no_cap_queue_or_seed_counter",
	"the_accepted_mechanisms_are_byte_identical",
	"no_offer_opens_below_the_requirement",
	"reaching_the_requirement_opens_exactly_one_offer",
	"the_accepted_level_one_presentation_is_unchanged",
	"an_unresolved_offer_blocks_further_openings",
	"a_refused_choice_keeps_the_same_offer_open_and_paused",
	"a_choice_advances_one_level_and_resumes_below_the_next_requirement",
	"a_later_offer_opens_on_its_own_at_its_exact_requirement",
	"the_next_offer_replaces_the_panel_without_an_unpaused_frame",
	"the_replacement_panel_shows_the_next_seed_and_identities",
	"the_input_that_chose_cannot_choose_again",
	"a_fresh_keyboard_controller_or_mouse_input_chooses_the_replacement",
	"three_banked_levels_take_three_distinct_choices",
	"every_choice_consumes_its_own_root_seed_once_and_none_is_skipped",
	"retained_experience_is_exact_after_every_step",
	"the_world_the_sweep_and_gameplay_input_stand_still_across_the_chain",
	"the_support_sequence_reaches_the_fallback_naturally",
	"the_fallback_panel_and_receipt_read_as_accepted",
	"the_fallback_is_acquired_once_and_both_supports_stay_at_rank_two",
	"an_ordinary_passive_lane_of_a_later_offer_changes_only_that_card",
	"the_loop_continues_past_the_fallback_with_no_cap",
	"a_refused_opening_is_asked_once_and_never_retried",
	"death_and_fallen_return_clear_the_tracking_and_the_build",
	"completion_ends_the_offers_and_the_next_expedition_begins_at_level_one",
	"no_character_effect_is_applied",
	"every_expedition_ends_clean",
]

var review: RogueliteLevelUpChoiceReview
var arguments: PackedStringArray = PackedStringArray()

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _shot_dir: String = ""
var _stage: Node3D
var _probe: Node
var _next_use_id: int = 95000
var _fixtures: int = 0
var _expeditions: int = 0
var _staged_plans: int = 0
var _baseline: Dictionary = {}
var _calls_at_start: int = 0

## The G4 twin of the current expedition.
var _twin: RiftRunLevelCoordinator

## Evidence gathered across the expeditions, read by the checks.
var _records: Dictionary = {}
var _choice_problems: PackedStringArray = PackedStringArray()
var _choices_read: int = 0
var _chained_read: int = 0
var _closing_read: int = 0
var _retained_lines: PackedStringArray = PackedStringArray()
var _choice_lines: PackedStringArray = PackedStringArray()
var _spent_again: PackedStringArray = PackedStringArray()
var _live_problems: PackedStringArray = PackedStringArray()
var _live_readings: int = 0
var _teardowns: PackedStringArray = PackedStringArray()
var _quiet_problems: PackedStringArray = PackedStringArray()
var _gate_lines: Dictionary = {}
var _hold_lines: Dictionary = {}
var _panel_lines: Dictionary = {}
var _passive_lines: Dictionary = {}
var _fresh_lines: Dictionary = {}


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	_shot_dir = _argument_value("--shots")
	print("")
	print("=== Roguelite I11 — Repeated Playable Level-Up Offer Loop V1 verification (D-314) ===")
	_stage = Node3D.new()
	_stage.name = "I11FixtureStage"
	root.add_child(_stage)
	var probe_script: GDScript = GDScript.new()
	probe_script.source_code = PROBE_SOURCE
	var compiled: Error = probe_script.reload()
	_probe = Node.new()
	_probe.name = "I11PauseProbe"
	_probe.set_script(probe_script)
	root.add_child(_probe)
	var changed: Error = change_scene_to_packed(load(REVIEW_SCENE) as PackedScene)
	for frame: int in 20:
		await process_frame
		if current_scene != null:
			break
	review = current_scene as RogueliteLevelUpChoiceReview
	if changed != OK or compiled != OK or review == null:
		printerr("ROGUELITE REPEATED LEVEL-UP OFFER LOOP VERIFICATION: the accepted review scene or the pause probe did not load")
		quit(1)
		return
	await _settle(10)
	await _await_navigation()

	_check_the_harness_is_isolated_and_drives_the_accepted_scene()
	_check_the_guard_is_one_integer_with_no_cap_queue_or_seed_counter()
	_check_the_accepted_mechanisms_are_byte_identical()

	await _expedition_a()
	await _expedition_b()
	await _expedition_c()
	await _expedition_d()
	await _expedition_e_and_f()

	## Read last, over everything the six expeditions gathered.
	_check_a_choice_advances_one_level_and_resumes_below_the_next_requirement()
	_check_the_input_that_chose_cannot_choose_again()
	_check_a_fresh_keyboard_controller_or_mouse_input_chooses_the_replacement()
	_check_every_choice_consumes_its_own_root_seed_once_and_none_is_skipped()
	_check_retained_experience_is_exact_after_every_step()
	_check_the_world_the_sweep_and_gameplay_input_stand_still_across_the_chain()
	_check_an_ordinary_passive_lane_of_a_later_offer_changes_only_that_card()
	_check_no_character_effect_is_applied()
	_check_every_expedition_ends_clean()

	_check_every_check_ran()

	print("")
	print("  %d expeditions (%d given seed %d again by staging), %d fixture Graveblades registered and killed, %d offer opening(s) asked by the review, %d level-ups taken through its panel, %d offers shown in place of a chosen one"
		% [_expeditions, _staged_plans, ROUTE_SEED, _fixtures, review.offer_open_calls, review.choices_taken,
			review.level_up_panel.replacements])
	if _failures.is_empty():
		print("ROGUELITE REPEATED LEVEL-UP OFFER LOOP VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("ROGUELITE REPEATED LEVEL-UP OFFER LOOP VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1–3. Isolation, the guard's shape, and the accepted mechanisms ------------------------

func _check_the_harness_is_isolated_and_drives_the_accepted_scene() -> void:
	print("")
	print("--- 1. The harness drives the accepted I2 scene unchanged; no accepted suite starts in it; nothing is injected")
	var script: GDScript = review.get_script() as GDScript
	_expect(review.scene_file_path == REVIEW_SCENE and script.resource_path == REVIEW_SCRIPT
			and review.get_node_or_null("RogueliteLevelUpChoiceReviewVerification") == null
			and review.get_node_or_null("RogueliteExperienceCollectionReviewVerification") == null
			and review.get_node_or_null("RogueliteCoreLoopVerification") == null
			and not arguments.has("--verify-level-up"),
		"the loaded scene is %s running %s, or an accepted suite started in it" % [review.scene_file_path, script.resource_path])
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	_expect(actions == EXPECTED_ACTIONS
			and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT
			and not settings.contains("[autoload]") and not settings.contains("repeated_level_up"),
		"the InputMap holds %d actions, or project.godot moved" % actions)
	var own: String = _bare(FileAccess.get_file_as_string(THIS_FILE))
	var injected: PackedStringArray = PackedStringArray()
	for pattern: String in INJECTION_PATTERNS:
		if own.contains(pattern):
			injected.append(pattern)
	var raw_own: String = FileAccess.get_file_as_string(THIS_FILE)
	var listed: int = 0
	for pattern: String in INJECTION_PATTERNS:
		if raw_own.contains("\"%s\"" % pattern):
			listed += 1
	_expect(injected.is_empty() and listed == INJECTION_PATTERNS.size() and own.length() > 20000,
		"this harness's code names %s (%d of %d patterns listed)" % [", ".join(injected), listed, INJECTION_PATTERNS.size()])
	print("  the accepted scene %s runs %s; no accepted suite started; %d actions; the entrypoint is %s; project.godot declares no [autoload]; 0 of %d injection patterns in this harness's code"
		% [REVIEW_SCENE.get_file(), REVIEW_SCRIPT.get_file(), actions, ENTRYPOINT.get_file(), INJECTION_PATTERNS.size()])
	_done("the_harness_is_isolated_and_drives_the_accepted_scene")


func _check_the_guard_is_one_integer_with_no_cap_queue_or_seed_counter() -> void:
	print("")
	print("--- 2. The guard is one integer; nothing caps the level, queues an offer, keeps a history, counts seeds, loops or chooses")
	var source: String = FileAccess.get_file_as_string(REVIEW_SCRIPT)
	var bare: String = _bare(source)
	var fields: PackedStringArray = PackedStringArray()
	var constants: PackedStringArray = PackedStringArray()
	var typed_collections: PackedStringArray = PackedStringArray()
	for line: String in bare.split("\n"):
		if line.begins_with("var "):
			fields.append(line.substr(4).get_slice(":", 0))
			if line.contains("Array") or line.contains("Packed"):
				typed_collections.append(line)
		elif line.begins_with("const "):
			constants.append(line.substr(6).get_slice(":", 0))
	_expect(", ".join(fields) == EXPECTED_FIELDS and ", ".join(constants) == EXPECTED_CONSTANTS and typed_collections.is_empty()
			and bare.contains("var _offer_attempted_level: int = NO_LEVEL_ASKED")
			and RogueliteLevelUpChoiceReview.NO_LEVEL_ASKED == 0 and RiftLevelRequirementCurve.FIRST_LEVEL == 1,
		"the review declares %s and constants %s (collections %s)" % [", ".join(fields), ", ".join(constants), ", ".join(typed_collections)])
	var forbidden: PackedStringArray = PackedStringArray()
	for token: String in GUARD_FORBIDDEN:
		if bare.contains(token):
			forbidden.append(token)
	var asking: String = _function_body(bare, "_ask_for_current_offer")
	var discarding: String = _function_body(bare, "_discard_mote_runtime")
	var choosing: String = _function_body(bare, "choose_offered_lane")
	var looping: PackedStringArray = PackedStringArray()
	for name: String in PATH_FUNCTIONS:
		var body: String = _function_body(bare, name)
		if body.is_empty() or body.contains("for ") or body.contains("while "):
			looping.append(name)
	_expect(forbidden.is_empty() and looping.is_empty()
			and bare.count("_offer_attempted_level = ") == 2
			and asking.contains("_offer_attempted_level = mote_runtime.level()")
			and discarding.contains("_offer_attempted_level = NO_LEVEL_ASKED")
			and bare.count("open_level_up_offer(") == 1 and asking.count("open_level_up_offer(") == 1
			and bare.count("_ask_for_current_offer()") == 3
			and _function_body(bare, "_open_offer_when_ready").count("_ask_for_current_offer()") == 1
			and choosing.count("_ask_for_current_offer()") == 1
			and bare.count("choose_level_up_lane(") == 1 and choosing.count("choose_level_up_lane(") == 1
			and bare.count("choose_offered_lane(") == 1,
		"the review names %s, loops in %s, or asks, opens or chooses from somewhere else" % [", ".join(forbidden), ", ".join(looping)])
	## First-MVP UI J1 (D-322) removed the panel's `_input` — its left-press routing moved into
	## the shared `FirstMvpModal` contract — so the panel declares 20 functions where it declared 21.
	var panel: String = _bare(FileAccess.get_file_as_string(PANEL_SCRIPT))
	var showing: String = _function_body(panel, "open_for_offer")
	_expect(panel.count("_runtime.") == 1 and panel.count("_runtime.choose_offered_lane(_lanes[slot])") == 1
			and not panel.contains("paused") and not panel.contains("InputMap")
			and showing.count("open()") == 1 and showing.contains("if not is_open:")
			and showing.contains("_armed[action] = not Input.is_action_pressed(action)")
			and showing.contains("replacements += 1") and not showing.contains("close(")
			and _declared_functions(FileAccess.get_file_as_string(PANEL_SCRIPT)).size() == 20,
		"the panel reaches the runtime otherwise, pauses, or does not replace an offer in place with the contract's arming rule")
	print("  the review declares %d fields — the one guard `_offer_attempted_level: int`, no list, array or queue — and constants %s; none of %d cap, queue, history or seed-counter tokens"
		% [fields.size(), ", ".join(constants), GUARD_FORBIDDEN.size()])
	print("  the guard is written twice: to the run's level just before the one opening call, and back to NO_LEVEL_ASKED when the expedition's runtime goes; the opening is asked from exactly the automatic tick and a successful choice; none of the %d path functions loops; the lane is taken only by the card entry point"
		% PATH_FUNCTIONS.size())
	print("  the panel still reaches the runtime once, pauses nothing, and — already open — shows a new offer in place with the contract's own arming rule and no close; 20 functions, none added")
	_done("the_guard_is_one_integer_with_no_cap_queue_or_seed_counter")


func _check_the_accepted_mechanisms_are_byte_identical() -> void:
	print("")
	print("--- 3. G1, G2, G4, E2, H8, D1, D3, I6, the build, the catalogues, H9, the modal, the core loop, I3 and the I2 scene are byte-identical")
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in UNCHANGED_HASHES:
		var digest: String = FileAccess.get_sha256(String(row[0]))
		if not digest.begins_with(String(row[1])):
			moved.append("%s %s" % [String(row[0]).get_file(), digest.substr(0, 8)])
	_expect(moved.is_empty() and UNCHANGED_HASHES.size() == 25, "moved: %s" % ", ".join(moved))
	print("  %d accepted files match the SHA-256 prefixes they held before the first I11 edit, but for I3's review and the seam, at their D-320 hashes, and the modal contract, at its D-322 hash" % UNCHANGED_HASHES.size())
	_done("the_accepted_mechanisms_are_byte_identical")


# --- Expedition A: the keyboard, and seed 99's five Support levels to the fallback ---------

func _expedition_a() -> void:
	await _begin_expedition("A")
	_baseline = _live_values()
	await _check_no_offer_opens_below_the_requirement()
	await _check_reaching_the_requirement_opens_exactly_one_offer()
	_check_the_accepted_level_one_presentation_is_unchanged()
	await _check_an_unresolved_offer_blocks_further_openings()
	_check_a_refused_choice_keeps_the_same_offer_open_and_paused()

	## Level 1, Support by Enter: the run keeps 0, below Level 2's 125, so the panel closes.
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	_take("A", "Enter", SUPPORT, 1, 0.0, false)
	_panel_lines["A level one receipt"] = _receipt_lines()
	var paused_at: Vector3 = escort.global_position
	var sweeps: int = review.sweeps_made
	await _settle(8)
	_hold_lines["A resumed"] = "%.3f|%d" % [_planar_gap(escort.global_position, paused_at), review.sweeps_made - sweeps]

	await _check_a_later_offer_opens_on_its_own_at_its_exact_requirement()
	await _chain_three_banked_levels()
	await _check_the_loop_continues_past_the_fallback_with_no_cap()
	await _end_expedition("A")


func _check_no_offer_opens_below_the_requirement() -> void:
	print("")
	print("--- 4. Real motes at 25, 50 and 75 open nothing and ask nothing")
	var steps: PackedStringArray = PackedStringArray()
	var problems: PackedStringArray = PackedStringArray()
	for index: int in [0, 1]:
		_quiet_room(index)
		var centre: Vector3 = _rounded(review.room_modules[index].room_centres()[0])
		_stand(centre)
		for enemy: PrototypeGraveblade in review.room_enemies[index]:
			enemy.place_at(centre)
			_kill(enemy)
			await _settle(3)
			_twin_award(REVIEW_AMOUNT)
			steps.append(_amount_text(review.mote_runtime.experience()))
			if not _nothing_asked():
				problems.append("at %s: %s" % [steps[steps.size() - 1], _state()])
		await _walk_into_gate(review.room_modules[index].exit_point())
	_expect(problems.is_empty() and steps == PackedStringArray(["25.0", "50.0", "75.0"])
			and review.run_state.current_room_index == 2,
		"below the requirement: %s (steps %s)" % ["; ".join(problems), ", ".join(steps)])
	print("  experience %s through real motes; at each step 0 opening(s) asked, no attempt recorded (attempted level %d), no panel, not paused, level 1, no offer"
		% [" -> ".join(steps), review.offer_attempted_level()])
	_done("no_offer_opens_below_the_requirement")


func _nothing_asked() -> bool:
	return (review.offer_open_calls == _calls_at_start and not review.offer_attempted()
		and review.offer_attempted_level() == RogueliteLevelUpChoiceReview.NO_LEVEL_ASKED
		and not review.level_up_panel.is_open and not paused and not review.mote_runtime.is_offer_active()
		and review.mote_runtime.level() == 1 and review.mote_runtime.experience() < REQUIREMENTS[0])


func _check_reaching_the_requirement_opens_exactly_one_offer() -> void:
	print("")
	print("--- 5. The fourth real mote reaches exactly 100 and exactly one offer opens on its own; nothing advances")
	var centre: Vector3 = _rounded(review.room_modules[2].room_centres()[0])
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	elite.set_ai_enabled(false)
	elite.place_at(centre - Vector3(4.0, 0.0, 0.0))
	escort.place_at(centre + Vector3(4.0, 0.0, 0.0))
	_stand(centre - Vector3(4.0, 0.0, 0.0))
	var calls: int = review.offer_open_calls
	var paused_notices: int = _probe_count("paused_notices")
	_kill(elite)
	await _settle(3)
	_twin_award(REVIEW_AMOUNT)
	_expect_quiet(_twin_open().is_empty(), "A: the twin did not open Level 1")
	var g1: RiftLevelRequirementReading = RiftLevelRequirementCurve.requirement_for(1)
	var g2: RiftLevelOfferSeedReading = RiftLevelOfferSeedDerivation.offer_root_seed_for(ROUTE_SEED, 1)
	var collected: PackedInt32Array = PackedInt32Array() if review.last_collection_result == null \
		else review.last_collection_result.collected_indices()
	_expect(collected == PackedInt32Array([3]) and review.mote_runtime.experience() == REQUIREMENTS[0]
			and g1.ok and g1.experience_requirement() == REQUIREMENTS[0],
		"the fourth mote did not reach G1's exact requirement: collected %s, %s" % [str(collected), _state()])
	_expect(review.offer_open_calls == calls + 1 and review.offer_open_refusals == 0 and review.offer_attempted()
			and review.offer_attempted_level() == 1 and review.level_up_panel.is_open and paused
			and review.mote_runtime.is_offer_active() and review.level_up_panel.opens == 1
			and _probe_count("paused_notices") == paused_notices + 1,
		"reaching the requirement asked %d opening(s) and left %s" % [review.offer_open_calls - calls, _state()])
	_expect(review.mote_runtime.level() == 1 and review.mote_runtime.frozen_offer_requirement() == REQUIREMENTS[0]
			and review.mote_runtime.offer_root_seed() == g2.offer_root_seed and g2.offer_root_seed == ROOTS[0]
			and _h8_line() == _expected_line(0) and _g4_line() == _expected_line(0)
			and escort.is_alive() and escort.ai_enabled,
		"opening advanced the run, froze the wrong requirement or root, or the escort was not alive: %s / %s" % [_h8_line(), _state()])
	print("  the collecting sweep took [3]: experience 100.0 = G1's Level 1 requirement; 1 opening asked, recorded against Level 1; the panel opened on its own; paused (1 pause notice to the probe); frozen requirement 100.0; root seed %d (G2: %d)"
		% [review.mote_runtime.offer_root_seed(), g2.offer_root_seed])
	print("  %s — identical in the review's run and the G4 twin" % _h8_line())
	_done("reaching_the_requirement_opens_exactly_one_offer")


func _check_the_accepted_level_one_presentation_is_unchanged() -> void:
	print("")
	print("--- 6. Seed 99's accepted Level 1 panel reads word for word as accepted, behind it only the standing line")
	var panel: RiftLevelUpOfferPanel = review.level_up_panel
	_expect(_shown_cards() == LEVEL_ONE_CARDS and _captions() == PackedStringArray(LEVEL_ONE_CAPTIONS)
			and _shown_cards() == _derived_cards() and panel.note_text() == GREYBOX_NOTE and panel.refusal_text().is_empty()
			and root.gui_get_focus_owner() == panel.card_buttons()[0] and not panel.cancel_closes(),
		"Level 1 reads %s with captions %s" % [str(_shown_cards()), ", ".join(_captions())])
	_expect(_receipt_lines() == PackedStringArray(STANDING_LINES) and _hud_text(HUD_LEVEL) == "Rift level 1"
			and _hud_text(HUD_EXPERIENCE) == "XP 100 / 100" and not _hud_visible(HUD_LEVEL_UP) and not _hud_visible(HUD_LEVEL_UP_NOTE),
		"behind the panel: %s / '%s' / '%s'" % [str(_receipt_lines()), _hud_text(HUD_LEVEL), _hud_text(HUD_EXPERIENCE)])
	var rows: PackedStringArray = PackedStringArray()
	for card: Array in _shown_cards():
		rows.append("%s: %s — %s" % [card[0], card[1], card[2]])
	print("  %s; %s; focus on card 1; the greybox note verbatim; H9 'Rift level 1' / 'XP 100 / 100', its LEVEL-UP READY lines withheld"
		% ["; ".join(rows), ", ".join(_captions())])
	_done("the_accepted_level_one_presentation_is_unchanged")


func _check_an_unresolved_offer_blocks_further_openings() -> void:
	print("")
	print("--- 7. While an offer stands unresolved, no further opening is asked, however many frames pass")
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	var before: Dictionary = _frozen(escort)
	var offer: String = _h8_line()
	var calls: int = review.offer_open_calls
	await _settle(30)
	await _await_process_frames(10)
	_expect(review.offer_open_calls == calls and _h8_line() == offer and _frozen(escort) == before
			and review.level_up_panel.is_open and paused and review.offer_attempted() and review.choices_taken == 0,
		"the unresolved offer let something through: %d call(s), %s" % [review.offer_open_calls - calls, _state()])
	print("  30 physics and 10 idle frames: %d further opening(s), the same offer (root %d), 0 choices, 0 sweeps, the escort and the probe unmoved"
		% [review.offer_open_calls - calls, review.mote_runtime.offer_root_seed()])
	_done("an_unresolved_offer_blocks_further_openings")


func _check_a_refused_choice_keeps_the_same_offer_open_and_paused() -> void:
	print("")
	print("--- 8. A refused choice keeps the same offer open and paused, showing the exact reason")
	var offer: String = _h8_line()
	var cards: Array = _shown_cards()
	## No card can produce an undeclared lane, so the review's own card entry point is handed one.
	review.choose_offered_lane(7)
	var record: RiftRunLevelUpResult = review.last_choice_record
	var reason: String = "" if record == null else record.failure_reason()
	_expect(record != null and not record.succeeded() and reason.begins_with("lane 7 is not one of the offer's lanes")
			and review.level_up_panel.refusal_text() == REFUSAL_PREFIX + reason and review.level_up_panel.is_open and paused
			and _h8_line() == offer and _shown_cards() == cards and review.mote_runtime.level() == 1
			and review.mote_runtime.experience() == REQUIREMENTS[0] and review.choices_taken == 0
			and _receipt_lines() == PackedStringArray(STANDING_LINES),
		"lane 7: '%s'; %s" % [reason, _state()])
	print("  lane 7: '%s'; shown word for word; the same offer still open, paused, level 1, 100.0" % reason)
	_done("a_refused_choice_keeps_the_same_offer_open_and_paused")


func _check_a_later_offer_opens_on_its_own_at_its_exact_requirement() -> void:
	print("")
	print("--- 10. At Level 2, exactly 125 opens Level 2's own offer on its own, from its own root seed")
	var calls: int = review.offer_open_calls
	var awarded: bool = _award([REQUIREMENTS[1]])
	var asked_by_award: bool = review.offer_open_calls == calls
	await _settle(3)
	_expect_quiet(_twin_open().is_empty(), "A: the twin did not open Level 2")
	var g2: RiftLevelOfferSeedReading = RiftLevelOfferSeedDerivation.offer_root_seed_for(ROUTE_SEED, 2)
	_expect(awarded and asked_by_award and review.offer_open_calls == calls + 1 and review.offer_attempted_level() == 2
			and review.level_up_panel.is_open and paused and review.mote_runtime.level() == 2
			and review.mote_runtime.experience() == REQUIREMENTS[1] and g2.offer_root_seed == ROOTS[1]
			and _h8_line() == _expected_line(1) and _g4_line() == _expected_line(1) and _cards_are_the_offer(),
		"Level 2 did not open on its own at 125: %s / %s" % [_h8_line(), _state()])
	_expect(_receipt_lines() == PackedStringArray(STANDING_LINES) and review.receipt_text("choice") == SUPPORT_CHOICES[0]
			and _hud_text(HUD_LEVEL) == "Rift level 2" and _hud_text(HUD_EXPERIENCE) == "XP 125 / 125",
		"behind the Level 2 panel: %s, held '%s'" % [str(_receipt_lines()), review.receipt_text("choice")])
	await _capture("01_later_offer")
	_panel_lines["01"] = await _measure_panel("the Level 2 offer")
	print("  125 awarded: the review asked 1 opening, recorded against Level 2; %s; cards %s; Level 1's receipt held but hidden"
		% [_h8_line(), " / ".join(_titles())])
	print("  %s" % _panel_lines["01"])
	## Level 2, Support by Enter: the run keeps 0, below Level 3's 150, so the panel closes.
	_take("A", "Enter", SUPPORT, 2, 0.0, false)
	_done("a_later_offer_opens_on_its_own_at_its_exact_requirement")


## At Level 3 with nothing kept, 525 is banked in one sweep: Levels 3, 4 and 5 are owed. The
## review opens Level 3 on its own; three fresh Enter presses take three Support lanes, and
## after each of the first two the next level's offer stands in the same panel. The third
## offer is the passive fallback, and taking it closes the panel at Level 6 with nothing kept.
func _chain_three_banked_levels() -> void:
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	var calls: int = review.offer_open_calls
	var awarded: bool = _award([REQUIREMENTS[2], REQUIREMENTS[3], REQUIREMENTS[4]])
	await _settle(3)
	_expect_quiet(_twin_open().is_empty(), "A: the twin did not open Level 3")
	var opened_level_three: bool = (awarded and review.offer_open_calls == calls + 1 and review.level_up_panel.is_open
		and paused and review.mote_runtime.level() == 3 and review.mote_runtime.experience() == 525.0
		and _h8_line() == _expected_line(2) and _g4_line() == _expected_line(2)
		and _hud_text(HUD_EXPERIENCE) == "XP 525 / 150")
	var held: Dictionary = _frozen(escort)
	var replacements: int = review.level_up_panel.replacements
	var closes: int = review.level_up_panel.closes
	var level_three_cards: Array = _shown_cards()

	## 1 — Enter takes Level 3's Support; Level 4's offer takes its place in the same call.
	var first: Dictionary = _take("A", "Enter", SUPPORT, 3, 375.0, true)
	var first_line: String = _h8_line()
	var first_cards: Array = _shown_cards()
	## The same key, repeating while held: an echo is not a press, and chooses nothing.
	_push_key_echo(KEY_ENTER)
	var after_echo: int = review.choices_taken
	## Every other way out, and gameplay input, while the replacement stands.
	var leak_before: Dictionary = _leak_reading()
	await _key(KEY_ESCAPE)
	await _joy(JOY_BUTTON_B)
	for keycode: Key in [KEY_F5, KEY_F8, KEY_F6, KEY_BRACKETLEFT]:
		await _key(keycode)
	await _mouse_click(Vector2(root.get_visible_rect().size) * 0.5, MOUSE_BUTTON_RIGHT)
	await _mouse_click(Vector2(40.0, 40.0), MOUSE_BUTTON_LEFT)
	var leak_after: Dictionary = _leak_reading()
	## First-MVP UI J1 (D-322): a third element held the panel's own left-press count, which no
	## check read. The panel counts nothing now; the backdrop press is read in `leak_after`.
	_gate_lines["A"] = [after_echo == int(first["choices"]), leak_before == leak_after]
	## Nothing chooses on its own, and the world holds, however many frames pass.
	await _settle(30)
	await _await_process_frames(10)
	var held_after_first: Dictionary = _frozen(escort)
	var still_first: bool = _h8_line() == first_line and review.choices_taken == after_echo
	await _capture("02_chained_offer")
	_panel_lines["02"] = await _measure_panel("the chained Level 4 offer")

	## 2 — a fresh Enter takes Level 4's Support; Level 5's offer — the fallback — takes its place.
	var ranks_before_fallback: RiftRunBuild = null
	var second: Dictionary = _take("A", "Enter", SUPPORT, 4, 200.0, true)
	ranks_before_fallback = review.mote_runtime.run_build()
	var second_line: String = _h8_line()
	var fallback_cards: Array = _shown_cards()
	var fallback_captions: PackedStringArray = _captions()
	var kinds: String = "%d/%d" % [review.mote_runtime.offer_support_content_kind(), review.mote_runtime.offer_support_fallback_category()]
	await _settle(30)
	await _await_process_frames(10)
	var held_after_second: Dictionary = _frozen(escort)
	var still_second: bool = _h8_line() == second_line and review.choices_taken == int(second["choices"])
	await _capture("03_fallback_offer")
	_panel_lines["03"] = await _measure_panel("the fallback offer")
	var detail_inside: bool = false
	for control: Control in review.level_up_panel.text_controls():
		if control is Label and (control as Label).text == FALLBACK_CARDS[0][2]:
			detail_inside = review.level_up_panel.card_block(0).get_global_rect().encloses(control.get_global_rect())
	var held_before_close: Dictionary = _frozen(escort)

	## 3 — a fresh Enter takes the fallback; nothing further is owed, so the panel closes.
	var build_before: RiftRunBuild = review.mote_runtime.run_build()
	var third: Dictionary = _take("A", "Enter", SUPPORT, 5, 0.0, false)
	var receipt: RiftLevelUpResult = review.last_choice_record.level_up() if review.last_choice_record != null else null
	var build_after: RiftRunBuild = review.mote_runtime.run_build()
	var fallback_receipt: PackedStringArray = _receipt_lines()
	await _capture("04_fallback_receipt", 1.2)
	_panel_lines["04"] = await _measure_receipt()
	var paused_at: Vector3 = escort.global_position
	var sweeps: int = review.sweeps_made
	await _settle(8)
	var resumed: bool = _planar_gap(escort.global_position, paused_at) > 0.0 and review.sweeps_made > sweeps
	_hold_lines["A"] = [held_after_first == held and held_after_second == held and held_before_close == held, resumed,
		"the escort — alive, AI on — unmoved across both chained offers and 80 held frames: position, state, state time, Life, the sweep count, drops %d / uncollected %d, attacks and destination identical; after the close it moved again and the sweep ran again"
			% [int(held["drops"]), int(held["uncollected"])]]

	print("")
	print("--- 11. A choice that leaves the next level owed shows that level's offer in the same call, with no frame and no unpaused tick between")
	var chain: Array[Dictionary] = [first, second]
	var steps: PackedStringArray = PackedStringArray()
	var faults: PackedStringArray = PackedStringArray()
	for index: int in 2:
		var taken: Dictionary = chain[index]
		var before: Dictionary = taken["before"]
		if not (bool(taken["same_frame"]) and bool(taken["open"]) and bool(taken["paused"]) and bool(taken["active"])
				and int(taken["replacements"]) == int(before["replacements"]) + 1 and int(taken["opens"]) == int(before["opens"])
				and int(taken["closes"]) == int(before["closes"]) and int(taken["unpaused"]) == int(before["unpaused"])
				and int(taken["ticks"]) == int(before["ticks"]) and int(taken["sweeps"]) == int(before["sweeps"])
				and int(taken["calls"]) == int(before["calls"]) + 1):
			faults.append("step %d: %s" % [index + 1, str(taken)])
		steps.append("Level %d -> %d: physics frame unchanged, panel open (opens %d, closes %d, replacements %d -> %d), the probe's ticks and unpause notices unchanged, 1 opening asked"
			% [3 + index, 4 + index, int(taken["opens"]), int(taken["closes"]), int(before["replacements"]),
				int(taken["replacements"])])
	_expect(opened_level_three and faults.is_empty(), "the chain: level 3 opened %s; %s" % [str(opened_level_three), "; ".join(faults)])
	_expect(held_after_first == held and held_after_second == held and held_before_close == held
			and int(third["closes"]) == closes + 1 and int(third["unpaused"]) == int(held["unpaused"]) + 1
			and review.level_up_panel.replacements == replacements + 2 and resumed,
		"the pause lapsed across the chain: %s -> %s -> %s; the close lifted it %d time(s)" % [str(held),
			str(held_after_first), str(held_after_second), int(third["unpaused"]) - int(held["unpaused"])])
	for line: String in steps:
		print("  %s" % line)
	print("  over both chained offers and 80 held frames: the probe received 0 physics ticks and 0 unpause notices; the one close at Level 6 sent exactly 1; the escort moved again after it")
	_done("the_next_offer_replaces_the_panel_without_an_unpaused_frame")

	print("")
	print("--- 12. Each replacement shows the NEXT level's own root seed and three identities, never the offer just taken")
	_expect(first_line == _expected_line(3) and second_line == _expected_line(4)
			and bool(first["cards_match"]) and bool(second["cards_match"]) and bool(first["focus_first"]) and bool(second["focus_first"])
			and String(first["refusal"]).is_empty() and String(second["refusal"]).is_empty()
			and first_cards != level_three_cards and fallback_cards != first_cards,
		"the replacements read %s and %s" % [first_line, second_line])
	print("  after Level 3: %s — %s" % [first_line, " / ".join(_titles_of(first_cards))])
	print("  after Level 4: %s — %s" % [second_line, " / ".join(_titles_of(fallback_cards))])
	print("  each the G4 twin's own; card 1 focused and no refusal left over each time; the held receipt hidden behind both")
	print("  %s" % _panel_lines["02"])
	_done("the_replacement_panel_shows_the_next_seed_and_identities")

	print("")
	print("--- 15. Three banked levels take three distinct choices, one level each, and nothing chooses on its own")
	var sources: PackedStringArray = PackedStringArray()
	for record: Array in _records["A"]:
		sources.append(str(record[0]))
	_expect(still_first and still_second and after_echo == int(first["choices"])
			and ", ".join(sources) == "1, 2, 3, 4, 5" and review.offer_open_calls == calls + 3
			and review.mote_runtime.level() == 6 and review.mote_runtime.experience() == 0.0,
		"the bank took %s choices from sources %s (%d openings)" % [str(review.choices_taken), ", ".join(sources), review.offer_open_calls - calls])
	print("  525 banked at Level 3 (150 + 175 + 200): 3 openings asked — 1 on the review's tick, 2 by the choices that chained them — 3 choices from sources 3, 4, 5; 40 frames after each of the first two, 0 choices made on their own")
	_done("three_banked_levels_take_three_distinct_choices")

	print("")
	print("--- 19. Support at every level reaches the passive fallback naturally, both supports already at their maximum rank")
	_expect(kinds == "1/0" and ranks_before_fallback != null
			and ranks_before_fallback.support_rank_for(QUICK_STRIKE, REACHING_EDGE) == MAXIMUM_RANK
			and ranks_before_fallback.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE) == MAXIMUM_RANK
			and SkillSupportCatalogue.support_maximum_rank(REACHING_EDGE) == MAXIMUM_RANK
			and SkillSupportCatalogue.support_maximum_rank(SWEEPING_EDGE) == MAXIMUM_RANK
			and ranks_before_fallback.passive_acquisitions() == 0 and second_line == _expected_line(4),
		"the fifth offer reads kind/category %s over %s" % [kinds, second_line])
	print("  Support taken at Levels 1–4 — Sweeping Edge new, Reaching Edge new, Reaching Edge 1 -> 2, Sweeping Edge 1 -> 2 — and the Level 5 offer, shown by the review's own chain, is PASSIVE_FALLBACK from category 0 with reaching_edge 2 / 2 and sweeping_edge 2 / 2 held")
	_done("the_support_sequence_reaches_the_fallback_naturally")

	print("")
	print("--- 20. The fallback panel and its receipt read exactly as I10 accepted them")
	_expect(fallback_cards == FALLBACK_CARDS and fallback_captions == PackedStringArray(FALLBACK_CAPTIONS) and detail_inside
			and fallback_receipt == PackedStringArray(FALLBACK_RECEIPT),
		"the fallback read %s / %s and its receipt %s" % [str(fallback_cards), ", ".join(fallback_captions), str(fallback_receipt)])
	_expect(receipt != null and receipt.carries_support_fallback() and receipt.support_content_kind == 1
			and receipt.support_fallback_category == 0 and receipt.granted_identity() == PackedStringArray([String(POWER)])
			and receipt.support_fallback_line() == "passive fallback: card_power, drawn from Combat and Defence"
			and not paused and not review.level_up_panel.is_open
			and _hud_text(HUD_LEVEL) == "Rift level 6" and _hud_text(HUD_EXPERIENCE) == "XP 0 / 225",
		"the fallback receipt is %s" % ("none" if receipt == null else receipt.describe()))
	var rows: PackedStringArray = PackedStringArray()
	for card: Array in fallback_cards:
		rows.append("%s: %s — %s" % [card[0], card[1], card[2]])
	print("  %s; %s" % ["; ".join(rows), ", ".join(fallback_captions)])
	print("  %s" % " | ".join(fallback_receipt))
	print("  %s" % _panel_lines["03"])
	print("  %s" % _panel_lines["04"])
	_done("the_fallback_panel_and_receipt_read_as_accepted")

	print("")
	print("--- 21. The fallback card is acquired exactly once; both supports stay at rank 2")
	var line: String = "card_power %d -> %d, passive cards %d -> %d, pairs [%s], ranks %d / %d -> %d / %d, total %d -> %d" % [
		build_before.acquisitions_for(POWER), build_after.acquisitions_for(POWER),
		build_before.passive_acquisitions(), build_after.passive_acquisitions(), ", ".join(build_after.support_pairs()),
		build_before.support_rank_for(QUICK_STRIKE, REACHING_EDGE), build_before.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE),
		build_after.support_rank_for(QUICK_STRIKE, REACHING_EDGE), build_after.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE),
		build_before.total_support_ranks(), build_after.total_support_ranks()]
	_expect(build_before.acquisitions_for(POWER) == 0 and build_after.acquisitions_for(POWER) == 1
			and build_after.passive_acquisitions() == 1 and build_after.support_pairs() == build_before.support_pairs()
			and build_after.support_rank_for(QUICK_STRIKE, REACHING_EDGE) == MAXIMUM_RANK
			and build_after.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE) == MAXIMUM_RANK
			and build_after.total_support_ranks() == 4 and build_before.total_support_ranks() == 4
			and _twin.run_build().acquisitions_for(POWER) == 1,
		line)
	print("  %s" % line)
	_done("the_fallback_is_acquired_once_and_both_supports_stay_at_rank_two")


func _check_the_loop_continues_past_the_fallback_with_no_cap() -> void:
	print("")
	print("--- 23. After the fallback the next level is owed its own offer like any other: 225 opens Level 6 on its own, and it is taken to Level 7")
	var calls: int = review.offer_open_calls
	var awarded: bool = _award([REQUIREMENTS[5]])
	await _settle(3)
	_expect_quiet(_twin_open().is_empty(), "A: the twin did not open Level 6")
	var g2: RiftLevelOfferSeedReading = RiftLevelOfferSeedDerivation.offer_root_seed_for(ROUTE_SEED, 6)
	var line: String = _h8_line()
	var opened: bool = (awarded and review.offer_open_calls == calls + 1 and review.offer_attempted_level() == 6
		and review.level_up_panel.is_open and paused and g2.offer_root_seed == ROOTS[5]
		and review.mote_runtime.offer_root_seed() == ROOTS[5] and line == _g4_line() and _cards_are_the_offer())
	var titles: PackedStringArray = _titles()
	_take("A", "Enter", SUPPORT, 6, 0.0, false)
	var g1: RiftLevelRequirementReading = RiftLevelRequirementCurve.requirement_for(7)
	_expect(opened and review.mote_runtime.level() == 7 and g1.ok and g1.experience_requirement() == REQUIREMENTS[6]
			and _hud_text(HUD_LEVEL) == "Rift level 7" and _hud_text(HUD_EXPERIENCE) == "XP 0 / 250"
			and _twin.consumption_ledger().count() == 6 and review.receipt_text("level") == "Rift level 6 → 7 · 0 XP carried over",
		"Level 6 opened %s (%s); %s" % [str(opened), line, _state()])
	print("  225 awarded at Level 6: 1 opening asked on the review's own tick; %s — %s, the G4 twin's own" % [line, " / ".join(titles)])
	print("  Support taken with Enter: Level 6 -> 7 with 0 kept; '%s' / '%s'; H9 'Rift level 7' / 'XP 0 / 250'; the twin's ledger holds 6 root seeds"
		% [review.receipt_text("choice"), review.receipt_text("level")])
	_done("the_loop_continues_past_the_fallback_with_no_cap")


# --- Expedition B: the controller, a HELD (A), and a pending in-range mote --------------------

func _expedition_b() -> void:
	await _begin_expedition("B")
	await _route_to_the_elite_hall()
	var centre: Vector3 = _rounded(review.room_modules[2].room_centres()[0])
	var near: Vector3 = centre - Vector3(4.0, 0.0, 0.0)
	var far: Vector3 = centre + Vector3(4.0, 0.0, 0.0)
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	_quiet_room(2)
	await _set_pickup(false)
	elite.place_at(near)
	escort.place_at(far)
	_kill(elite)
	_kill(escort)
	_stand(near)
	var awarded: bool = _award([150.0])
	await _set_pickup(true)
	await _settle(3)
	_twin_award(REVIEW_AMOUNT)
	_expect_quiet(_twin_open().is_empty(), "B: the twin did not open Level 1")
	var opened: bool = (awarded and review.level_up_panel.is_open and review.mote_runtime.level() == 1
		and review.mote_runtime.experience() == 250.0 and review.offer_open_calls == _calls_at_start + 1
		and _h8_line() == _expected_line(0) and review.mote_runtime.uncollected_count() == 1)
	## STAGED: the world is held, so a player cannot walk here; the harness places them ON the
	## escort's pending mote, in range for the whole chain.
	_stand(far)
	var gap: float = _planar_gap(review.player.global_position, review.marker_drop_position(4))
	var mote_before: Dictionary = _frozen(escort)

	## (A) is HELD: its state is what a real held button leaves behind, with no event.
	Input.action_press(&"ui_confirm")
	var first: Dictionary = _take("B", "(A)", SUPPORT, 1, 150.0, true, false)
	var armed_after_choice: bool = review.level_up_panel.inputs_are_armed()
	var refused_before: int = review.level_up_panel.held_inputs_refused
	var line_before: String = _h8_line()
	## The same held (A) pressing again — the input that chose, not a fresh one.
	_push_joy(JOY_BUTTON_A, true)
	var held_press: Dictionary = _reading()
	Input.action_release(&"ui_confirm")
	_push_joy(JOY_BUTTON_A, false)
	var armed_after_release: bool = review.level_up_panel.inputs_are_armed()
	await _settle(30)
	await _await_process_frames(10)
	var mote_after: Dictionary = _frozen(escort)
	var marker_waits: bool = review.marker_is_shown(4) and not review.marker_is_collected(4)
	_gate_lines["B"] = [
		opened, gap == 0.0, not armed_after_choice,
		review.level_up_panel.held_inputs_refused == refused_before + 1,
		int(held_press["choices"]) == int(first["choices"]) and _h8_line() == line_before and bool(held_press["open"]),
		armed_after_release, mote_after == mote_before and marker_waits and review.mote_runtime.experience() == 150.0,
	]
	_hold_lines["B"] = "the player %.2f m from the pending mote; 40 frames: %d sweep(s), %d uncollected, experience %s, its marker shown" % [
		gap, int(mote_after["sweeps"]) - int(mote_before["sweeps"]), int(mote_after["uncollected"]),
		_amount_text(review.mote_runtime.experience())]

	## A fresh input: the D-pad to card 2, then a new press of (A).
	await _joy(JOY_BUTTON_DPAD_RIGHT)
	var build_before: RiftRunBuild = review.mote_runtime.run_build()
	_take("B", "(A)", COMBAT, 2, 25.0, false)
	var build_after: RiftRunBuild = review.mote_runtime.run_build()
	_passive_lines["B"] = [review.receipt_text("choice"), review.receipt_text("progression"), build_before, build_after, POWER]
	await _settle(3)
	_gate_lines["B after"] = (review.last_collection_result != null
		and review.last_collection_result.collected_indices() == PackedInt32Array([4])
		and review.mote_runtime.experience() == 50.0 and review.mote_runtime.level() == 3 and not review.level_up_panel.is_open)
	await _end_expedition("B")


# --- Expedition C: the mouse ------------------------------------------------------------------

func _expedition_c() -> void:
	await _begin_expedition("C")
	await _route_to_the_elite_hall()
	var centre: Vector3 = _rounded(review.room_modules[2].room_centres()[0])
	var near: Vector3 = centre - Vector3(4.0, 0.0, 0.0)
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	elite.set_ai_enabled(false)
	elite.place_at(near)
	escort.place_at(centre + Vector3(4.0, 0.0, 0.0))
	_stand(near)
	var awarded: bool = _award([150.0])
	_kill(elite)
	await _settle(3)
	_twin_award(REVIEW_AMOUNT)
	_expect_quiet(_twin_open().is_empty(), "C: the twin did not open Level 1")
	var opened: bool = (awarded and review.level_up_panel.is_open and review.mote_runtime.experience() == 250.0
		and _h8_line() == _expected_line(0) and escort.is_alive() and escort.ai_enabled)
	var held: Dictionary = _frozen(escort)
	## First-MVP UI J1 (D-322): the panel no longer counts left presses, so the two clicks are read
	## by what they took — two cards, each checked against its own lane by `_take()`.
	var taken_before: int = review.choices_taken
	var first: Dictionary = _take("C", "left click", SUPPORT, 1, 150.0, true)
	await _settle(30)
	await _await_process_frames(10)
	var held_after: Dictionary = _frozen(escort)
	var build_before: RiftRunBuild = review.mote_runtime.run_build()
	_take("C", "left click", UTILITY, 2, 25.0, false)
	var build_after: RiftRunBuild = review.mote_runtime.run_build()
	_passive_lines["C"] = [review.receipt_text("choice"), review.receipt_text("progression"), build_before, build_after, MAGNETISM]
	_gate_lines["C"] = [opened, review.choices_taken == taken_before + 2,
		int(first["choices_after_release"]) == int(first["choices"]), held_after == held]
	var paused_at: Vector3 = escort.global_position
	await _settle(8)
	_gate_lines["C"].append(_planar_gap(escort.global_position, paused_at) > 0.0)
	_hold_lines["C"] = "the escort, alive with its AI on, unmoved across the chained panel and 40 held frames, and moving again once the panel closed"
	await _end_expedition("C")


# --- Expedition D: a chain from Level 1, a refused Level 3 opening, then death --------------------

func _expedition_d() -> void:
	await _begin_expedition("D")
	_quiet_room(0)
	var awarded: bool = _award([REQUIREMENTS[0], REQUIREMENTS[1]])
	await _settle(3)
	_expect_quiet(_twin_open().is_empty(), "D: the twin did not open Level 1")
	_expect_quiet(awarded and review.level_up_panel.is_open and review.mote_runtime.experience() == 225.0
			and _h8_line() == _expected_line(0),
		"D: 225 at Level 1 did not open Level 1 on its own: %s" % _state())
	_take("D", "Enter", SUPPORT, 1, 125.0, true)
	_take("D", "Enter", SUPPORT, 2, 0.0, false)
	await _check_a_refused_opening_is_asked_once_and_never_retried()
	await _check_death_and_fallen_return_clear_the_tracking_and_the_build()


func _check_a_refused_opening_is_asked_once_and_never_retried() -> void:
	print("")
	print("--- 24. A refused opening is asked once for its level, shown, and never asked again")
	var calls: int = review.offer_open_calls
	var refusals: int = review.offer_open_refusals
	var awarded: bool = _award([REQUIREMENTS[2]])
	## STAGED: the harness opens Level 3's offer through H8 itself, so the review's own one
	## request for Level 3 meets a refusal no real route can produce.
	var staged: String = review.mote_runtime.open_level_up_offer(SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(), PassiveCardCatalogue.records())
	var asked_by_staging: bool = review.offer_open_calls == calls
	await _settle(3)
	_expect(awarded and staged.is_empty() and asked_by_staging and review.offer_open_calls == calls + 1
			and review.offer_open_refusals == refusals + 1 and review.last_offer_refusal == ALREADY_OPEN_AT_THREE
			and review.offer_attempted_level() == 3 and review.offer_attempted() and not review.level_up_panel.is_open
			and not paused and review.mote_runtime.is_offer_active(),
		"the review's Level 3 request was not asked once and refused: %s" % _state())
	_expect(_hud_text(HUD_REFUSAL) == "Last refusal: level-up offer did not open — %s" % ALREADY_OPEN_AT_THREE
			and review.receipt_text("choice") == SUPPORT_CHOICES[1] and _receipt_lines().size() == 5,
		"the refusal is not shown beside the Level 2 receipt: '%s' / %s" % [_hud_text(HUD_REFUSAL), str(_receipt_lines())])
	await _settle(60)
	await _await_process_frames(10)
	_expect(review.offer_open_calls == calls + 1 and not review.level_up_panel.is_open and not paused,
		"the Level 3 opening was asked again: %d call(s)" % (review.offer_open_calls - calls))
	print("  1 request for Level 3, recorded against it and refused: '%s'; shown as '%s'; 70 frames later still 1, no panel, not paused"
		% [review.last_offer_refusal, _hud_text(HUD_REFUSAL)])
	_done("a_refused_opening_is_asked_once_and_never_retried")


func _check_death_and_fallen_return_clear_the_tracking_and_the_build() -> void:
	print("")
	print("--- 25. Death and the Fallen overlay's return to the Nexus clear the guard, the standing offer and the temporary build")
	var held: RiftRunBuild = review.mote_runtime.run_build()
	var holding: String = "level %d, attempted level %d, an offer standing %s, %d pair(s)" % [review.mote_runtime.level(),
		review.offer_attempted_level(), str(review.mote_runtime.is_offer_active()), held.support_count()]
	var lethal: DamageEvent = DamageEvent.physical(_use(), review.room_enemies[0][0], review.player, review.player.max_life + 999.0)
	review.player.receive_damage(lethal)
	## Read at the hit itself: once the overlay opens, its own neutralizing path is the
	## player's, and the first development run read the fall too late.
	var died: bool = not review.player.is_alive()
	for frame: int in 150:
		if review.fallen_overlay.is_open:
			break
		await physics_frame
	var fallen: bool = died and review.fallen_overlay.is_open
	## The Fallen overlay's own focused button, by Enter.
	_push_key(KEY_ENTER, true)
	_push_key(KEY_ENTER, false)
	await _settle(6)
	var cleared: bool = _cleared()
	_expect(fallen and cleared and not review.fallen_overlay.is_open and review.player.is_alive()
			and held.support_count() == 2,
		"death did not clear the expedition's offer state (fallen %s): %s" % [str(fallen), _state()])
	for fixture: Node in _stage.get_children():
		fixture.queue_free()
	await _await_process_frames(2)
	_teardowns.append("D by death")
	_fresh_lines["D"] = holding
	print("  before the lethal hit: %s; Fallen opened; Enter on its button returned to the Nexus" % holding)
	print("  after it: no runtime, attempted level %d, no refusal, record or receipt, the level-up panel closed, not paused; H9 reads '%s'"
		% [review.offer_attempted_level(), _hud_text(HUD_LEVEL)])
	_done("death_and_fallen_return_clear_the_tracking_and_the_build")


# --- Expeditions E and F: completion, and the next expedition ------------------------------------

func _expedition_e_and_f() -> void:
	print("")
	print("--- 26. Completion ends the offers; no offer opens and no choice is taken after it; the next expedition begins at Level 1")
	await _begin_expedition("E")
	## After D's death, the temporary build did not survive into the next expedition.
	var fresh_after_death: bool = _is_fresh()
	await _route_to_the_elite_hall()
	var centre: Vector3 = _rounded(review.room_modules[2].room_centres()[0])
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	_quiet_room(2)
	elite.place_at(centre)
	escort.place_at(centre)
	_stand(centre)
	_kill(elite)
	await _settle(3)
	_twin_award(REVIEW_AMOUNT)
	_expect_quiet(_twin_open().is_empty(), "E: the twin did not open Level 1")
	_take("E", "Enter", SUPPORT, 1, 0.0, false)
	_kill(escort)
	await _settle(3)
	var calls: int = review.offer_open_calls
	await _walk_into_gate(review.room_modules[2].exit_point())
	await _settle(2)
	var completed: bool = (review.loop_state == RogueliteCoreLoopRuntime.LoopState.RUN_COMPLETE and review.mote_runtime == null
		and review.summary_panel.is_open and not review.level_up_panel.is_open and not review.offer_attempted()
		and review.offer_attempted_level() == RogueliteLevelUpChoiceReview.NO_LEVEL_ASKED and review.offer_open_calls == calls)
	## After the run has finished, the card entry point is asked directly: nothing is taken.
	var attempts: int = review.choice_attempts
	review.choose_offered_lane(SUPPORT)
	var ignored: bool = review.choice_attempts == attempts
	_push_key(KEY_ENTER, true)
	_push_key(KEY_ENTER, false)
	await _settle(30)
	await _await_process_frames(6)
	var quiet: bool = (not review.summary_panel.is_open and not review.level_up_panel.is_open and not paused
		and review.offer_open_calls == calls and review.mote_runtime == null)
	_teardowns.append("E by completion")
	for fixture: Node in _stage.get_children():
		fixture.queue_free()
	await _begin_expedition("F")
	var fresh: bool = _is_fresh()
	_expect(fresh_after_death and completed and ignored and quiet,
		"completion: fresh after death %s, completed %s, a choice ignored %s, quiet after %s — %s" % [
			str(fresh_after_death), str(completed), str(ignored), str(quiet), _state()])
	_expect(fresh and review.mote_runtime.run_seed() == ROUTE_SEED and review.mote_runtime.run_build().is_empty(),
		"the next expedition did not begin at Level 1 with nothing asked: %s" % _state())
	print("  E began after D's death at %s" % _fresh_lines["E"])
	print("  E completed through its last Rift Gate at Level 2: the runtime gone, the summary open, attempted level %d; the card entry point asked afterwards took nothing; 36 frames in the Nexus asked nothing"
		% review.offer_attempted_level())
	print("  F began at %s" % _fresh_lines["F"])
	await _end_expedition("F")
	_done("completion_ends_the_offers_and_the_next_expedition_begins_at_level_one")


# --- The aggregate checks, read over all six expeditions -----------------------------------------

const EXPECTED_RETAINED: String = "A1 0, A2 0, A3 375, A4 200, A5 0, A6 0, B1 150, B2 25, C1 150, C2 25, D1 125, D2 0, E1 0"


func _check_a_choice_advances_one_level_and_resumes_below_the_next_requirement() -> void:
	print("")
	print("--- 9. Every successful choice advances exactly one level; below the next requirement the panel closes, play resumes and the completed receipt shows")
	var resumed: PackedStringArray = String(_hold_lines["A resumed"]).split("|")
	_expect(_choice_problems.is_empty() and _choices_read == 13 and _chained_read == 5 and _closing_read == 8,
		"%d choices read (%d chained, %d closing); %s" % [_choices_read, _chained_read, _closing_read, "; ".join(_choice_problems)])
	_expect(_panel_lines["A level one receipt"] == PackedStringArray(LEVEL_ONE_RECEIPT)
			and float(resumed[0]) > 0.0 and int(resumed[1]) > 0,
		"Level 1's receipt read %s; after it the escort moved %s m and %s sweep(s) ran" % [str(_panel_lines["A level one receipt"]),
			resumed[0], resumed[1]])
	for line: String in _choice_lines:
		print("  %s" % line)
	print("  %d choices, each one level; %d closed the panel with the completed receipt shown by the same input and the world running again; %d left the next level's offer standing"
		% [_choices_read, _closing_read, _chained_read])
	print("  Level 1's receipt: %s; after it the escort moved again and the sweep ran again" % " | ".join(_panel_lines["A level one receipt"]))
	_done("a_choice_advances_one_level_and_resumes_below_the_next_requirement")


func _check_the_input_that_chose_cannot_choose_again() -> void:
	print("")
	print("--- 13. The input that took a card cannot take one from the offer that replaced it")
	var a: Array = _gate_lines["A"]
	var b: Array = _gate_lines["B"]
	var c: Array = _gate_lines["C"]
	_expect(bool(a[0]) and bool(b[2]) and bool(b[3]) and bool(b[4]) and bool(b[5]) and bool(c[1]) and bool(c[2]),
		"A echo %s; B disarmed %s, refused %s, unchanged %s, re-armed %s; C presses %s, release %s" % [str(a[0]), str(b[2]),
			str(b[3]), str(b[4]), str(b[5]), str(c[1]), str(c[2])])
	print("  keyboard: each Enter press took exactly one card; its release and a held-key echo over the replacement took none")
	print("  controller: with (A) held, the press that took Level 1's Support left the panel disarmed; a second press of the still-held (A) was refused by the contract's held-input rule over the same Level 2 offer; its release re-armed the panel")
	print("  mouse: one click took exactly one card; 2 clicks took 2 cards")
	_done("the_input_that_chose_cannot_choose_again")


func _check_a_fresh_keyboard_controller_or_mouse_input_chooses_the_replacement() -> void:
	print("")
	print("--- 14. A fresh keyboard, controller or mouse input chooses from the replacement")
	var taken: PackedStringArray = PackedStringArray()
	for label: String in ["A", "B", "C", "D"]:
		taken.append("%s %d" % [label, (_records[label] as Array).size()])
	_expect(_choice_problems.is_empty() and ", ".join(taken) == "A 6, B 2, C 2, D 2",
		"the replacements were taken %s" % ", ".join(taken))
	print("  a new Enter took A's chained Level 4 and Level 5 offers and D's chained Level 2; the D-pad and a new (A) took B's chained Level 2 (Combat and Defence); a new click took C's chained Level 2 (Utility)")
	_done("a_fresh_keyboard_controller_or_mouse_input_chooses_the_replacement")


func _check_every_choice_consumes_its_own_root_seed_once_and_none_is_skipped() -> void:
	print("")
	print("--- 16. Every choice consumes its own level's root seed, exactly once; none is skipped, reused or consumed twice")
	var faults: PackedStringArray = PackedStringArray()
	var lines: PackedStringArray = PackedStringArray()
	for label: String in ["A", "B", "C", "D", "E"]:
		var roots: PackedInt64Array = PackedInt64Array()
		var records: Array = _records[label]
		for index: int in records.size():
			var record: Array = records[index]
			if int(record[0]) != index + 1 or int(record[1]) != ROOTS[index]:
				faults.append("%s choice %d was level %d from %d" % [label, index + 1, int(record[0]), int(record[1])])
			roots.append(int(record[1]))
		if _ledgers.get(label, PackedInt64Array()) != roots:
			faults.append("%s's twin consumed %s against %s" % [label, str(_ledgers.get(label)), str(roots)])
		lines.append("%s %s" % [label, str(roots)])
	_expect(faults.is_empty() and _spent_again.size() == 8 and _choice_problems.is_empty(),
		"; ".join(faults) + " | taken again: " + ", ".join(_spent_again))
	print("  %s — each G2's own for levels 1, 2, 3 … in order; each expedition's G4 twin consumed exactly those, once each" % " / ".join(lines))
	print("  after each of the %d closing choices, taking the same lane again through H8 answered '%s'" % [_spent_again.size(), NO_OFFER])
	_done("every_choice_consumes_its_own_root_seed_once_and_none_is_skipped")


func _check_retained_experience_is_exact_after_every_step() -> void:
	print("")
	print("--- 17. The experience the run keeps is exact after every step")
	_expect(", ".join(_retained_lines) == EXPECTED_RETAINED and _choice_problems.is_empty(),
		"retained: %s" % ", ".join(_retained_lines))
	print("  %s — each equal to the G4 twin's and to the review's own last_retained_experience" % ", ".join(_retained_lines))
	_done("retained_experience_is_exact_after_every_step")


func _check_the_world_the_sweep_and_gameplay_input_stand_still_across_the_chain() -> void:
	print("")
	print("--- 18. Across chained offers no enemy moves, no mote is swept and no gameplay input acts")
	var a: Array = _hold_lines["A"]
	var b: Array = _gate_lines["B"]
	var c: Array = _gate_lines["C"]
	_expect(bool(a[0]) and bool(a[1]) and bool(_gate_lines["A"][1]) and bool(b[0]) and bool(b[1]) and bool(b[6])
			and bool(_gate_lines["B after"]) and bool(c[0]) and bool(c[3]) and bool(c[4]),
		"A frozen %s, resumed %s, inputs %s; B opened %s, placed %s, mote %s, after %s; C opened %s, frozen %s" % [
			str(a[0]), str(a[1]), str(_gate_lines["A"][1]), str(b[0]), str(b[1]), str(b[6]), str(_gate_lines["B after"]),
			str(c[0]), str(c[3])])
	print("  A: %s" % String(a[2]))
	print("  A: Esc, (B), F5, F8, F6, [, a right click and a left click on the backdrop over the chained Level 4 offer — the same offer, 0 choices, no attack, no destination, pickup, grid, camera and expedition unchanged")
	print("  B: %s; the first sweep after the panel closed collected [4]" % _hold_lines["B"])
	print("  C: %s" % _hold_lines["C"])
	_done("the_world_the_sweep_and_gameplay_input_stand_still_across_the_chain")


func _check_an_ordinary_passive_lane_of_a_later_offer_changes_only_that_card() -> void:
	print("")
	print("--- 22. An ordinary passive lane of a later offer works, and changes only that card's acquisition")
	var faults: PackedStringArray = PackedStringArray()
	var lines: PackedStringArray = PackedStringArray()
	for label: String in ["B", "C"]:
		var entry: Array = _passive_lines[label]
		var before: RiftRunBuild = entry[2]
		var after: RiftRunBuild = entry[3]
		var card: StringName = entry[4]
		var lane: int = COMBAT if label == "B" else UTILITY
		var record: PassiveCardDefinition = PassiveCardCatalogue.record(card)
		var expected: String = "%s — %s (%s)" % [RiftOffer.lane_label(lane), record.display_name, record.effect_line()]
		if String(entry[0]) != expected or not String(entry[1]).is_empty() or before.acquisitions_for(card) != 0 \
				or after.acquisitions_for(card) != 1 or after.passive_acquisitions() != before.passive_acquisitions() + 1 \
				or after.support_pairs() != before.support_pairs() or after.total_support_ranks() != before.total_support_ranks() \
				or after.support_pairs() != PackedStringArray(["quick_strike -> sweeping_edge"]):
			faults.append("%s: '%s' / '%s'" % [label, entry[0], entry[1]])
		lines.append("%s at Level 2: '%s'; %s 0 -> %d, pairs [%s] and %d rank(s) unchanged" % [label, entry[0], card,
			after.acquisitions_for(card), ", ".join(after.support_pairs()), after.total_support_ranks()])
	_expect(faults.is_empty(), "; ".join(faults))
	for line: String in lines:
		print("  %s" % line)
	_done("an_ordinary_passive_lane_of_a_later_offer_changes_only_that_card")


func _check_no_character_effect_is_applied() -> void:
	print("")
	print("--- 27. No live character value moved: this review offers and records, and applies nothing")
	_expect(_live_problems.is_empty() and _live_readings == 13
			and is_equal_approx(float(_baseline["max_speed"]), ACCEPTED_MAX_SPEED)
			and is_equal_approx(float(_baseline["action_time"]), ACCEPTED_ACTION_TIME)
			and is_equal_approx(float(_baseline["reach"]), ACCEPTED_REACH)
			and is_equal_approx(float(_baseline["arc"]), ACCEPTED_ARC)
			and is_equal_approx(float(_baseline["cone"]), ACCEPTED_CONE)
			and float(_baseline["increased_attack_speed"]) == 0.0,
		"%d readings; baseline %s; %s" % [_live_readings, str(_baseline), "; ".join(_live_problems)])
	print("  max speed %.1f m/s, action time %.2f s (effective %.2f s), reach %.2f m, arc %.0f deg, cone %.0f deg, +%.0f%% attack speed — identical after all %d choices, the fallback and both passive lanes included"
		% [float(_baseline["max_speed"]), float(_baseline["action_time"]), float(_baseline["effective_action_time"]),
			float(_baseline["reach"]), float(_baseline["arc"]), float(_baseline["cone"]),
			100.0 * float(_baseline["increased_attack_speed"]), _live_readings])
	_done("no_character_effect_is_applied")


func _check_every_expedition_ends_clean() -> void:
	print("")
	print("--- 28. Every expedition ended with no runtime, guard, record, receipt or panel left")
	_expect(", ".join(_teardowns) == "A, B, C, D by death, E by completion, F" and _quiet_problems.is_empty(),
		"%s ended; %s" % [", ".join(_teardowns), "; ".join(_quiet_problems)])
	print("  6 of 6 expeditions (%s) ended with no runtime, attempted level 0, no record or receipt, the panel closed and the world running" % ", ".join(_teardowns))
	_done("every_expedition_ends_clean")


func _check_every_check_ran() -> void:
	print("")
	print("--- Every check this suite owes actually reached its last line")
	var missing: PackedStringArray = PackedStringArray()
	for owed: String in OWED_CHECKS:
		if not _reached.has(owed):
			missing.append(owed)
	var extra: PackedStringArray = PackedStringArray()
	for ran: String in _reached:
		if not OWED_CHECKS.has(ran):
			extra.append(ran)
	_expect(missing.is_empty(), "check(s) never completed: %s" % ", ".join(missing))
	_expect(extra.is_empty(), "check(s) ran that the suite does not owe: %s" % ", ".join(extra))
	print("  %d of %d owed checks completed" % [_reached.size(), OWED_CHECKS.size()])


# --- Taking a card -----------------------------------------------------------------------------

## Each expedition's G4 twin ledger, as it stood after that expedition's last choice.
var _ledgers: Dictionary = {}


## One choice, pushed as ONE input and read in that input's own call stack — before any frame
## can pass — against everything a choice owes. `chained` says whether the next level's offer
## must now stand in the same panel. With `release` false the input is left held.
func _take(label: String, how: String, lane: int, source_level: int, retained: float, chained: bool,
		release: bool = true) -> Dictionary:
	var panel: RiftLevelUpOfferPanel = review.level_up_panel
	var problems: PackedStringArray = PackedStringArray()
	var moment: String = "%s Level %d %s by %s" % [label, source_level, RiftOffer.lane_label(lane), how]
	if how != "left click" and root.gui_get_focus_owner() != panel.card_buttons()[lane]:
		problems.append("card %d was not focused before the input" % (lane + 1))
	var before: Dictionary = _reading()
	var frame: int = Engine.get_physics_frames()
	match how:
		"Enter":
			_push_key(KEY_ENTER, true)
		"(A)":
			_push_joy(JOY_BUTTON_A, true)
		"left click":
			var at: Vector2 = panel.card_buttons()[lane].get_global_rect().get_center()
			_point_at(at)
			_push_mouse(at, MOUSE_BUTTON_LEFT, true)
			_push_mouse(at, MOUSE_BUTTON_LEFT, false)
	var taken: Dictionary = _reading()
	taken["same_frame"] = Engine.get_physics_frames() == frame
	taken["before"] = before
	var record: RiftRunLevelUpResult = review.last_choice_record
	var receipt: RiftLevelUpResult = null if record == null else record.level_up()
	var twin_record: RiftRunLevelUpResult = _twin.choose(lane)
	var g2: RiftLevelOfferSeedReading = RiftLevelOfferSeedDerivation.offer_root_seed_for(ROUTE_SEED, source_level)
	if (record == null or receipt == null or not record.succeeded() or not record.problem().is_empty()
			or record.run_seed != ROUTE_SEED or record.source_level != source_level or receipt.lane != lane
			or not receipt.root_seed_known or receipt.root_seed != ROOTS[source_level - 1] or receipt.root_seed != g2.offer_root_seed):
		problems.append("the record is %s" % _record(record))
	if _record(record) != _record(twin_record):
		problems.append("the review took %s where the G4 twin took %s" % [_record(record), _record(twin_record)])
	if (int(taken["choices"]) != int(before["choices"]) + 1 or int(taken["attempts"]) != int(before["attempts"]) + 1
			or not bool(taken["same_frame"])):
		problems.append("one input made %d choice(s) across %d frame(s)" % [int(taken["choices"]) - int(before["choices"]),
			Engine.get_physics_frames() - frame])
	if (int(taken["level"]) != source_level + 1 or float(taken["experience"]) != retained
			or review.last_retained_experience != retained or _twin.level() != source_level + 1 or _twin.experience() != retained):
		problems.append("left level %d with %s, not %d with %s" % [int(taken["level"]), str(taken["experience"]),
			source_level + 1, str(retained)])
	var level_line: String = "Rift level %d → %d · %s XP carried over" % [source_level, source_level + 1, _whole(retained)]
	if review.receipt_text("level") != level_line:
		problems.append("the receipt's level line reads '%s'" % review.receipt_text("level"))
	if (String(taken["hud_level"]) != "Rift level %d" % (source_level + 1)
			or String(taken["hud_experience"]) != "XP %s / %d" % [_whole(retained), int(REQUIREMENTS[source_level])]):
		problems.append("H9 read '%s' / '%s' right after the choice" % [taken["hud_level"], taken["hud_experience"]])
	if chained:
		_chained_read += 1
		var twin_opened: String = _twin_open()
		if (not bool(taken["open"]) or not bool(taken["paused"]) or not bool(taken["active"])
				or int(taken["root"]) != ROOTS[source_level] or int(taken["calls"]) != int(before["calls"]) + 1
				or int(taken["attempted_level"]) != source_level + 1
				or int(taken["replacements"]) != int(before["replacements"]) + 1 or int(taken["opens"]) != int(before["opens"])
				or int(taken["closes"]) != int(before["closes"]) or int(taken["unpaused"]) != int(before["unpaused"])
				or int(taken["sweeps"]) != int(before["sweeps"]) or not bool(taken["focus_first"])
				or not String(taken["refusal"]).is_empty() or taken["receipt"] != PackedStringArray(STANDING_LINES)
				or not bool(taken["cards_match"]) or not twin_opened.is_empty() or _h8_line() != _g4_line()):
			problems.append("the next offer did not replace the panel: %s (twin '%s')" % [str(taken), twin_opened])
	else:
		_closing_read += 1
		if (bool(taken["open"]) or bool(taken["paused"]) or bool(taken["active"])
				or int(taken["calls"]) != int(before["calls"]) or int(taken["closes"]) != int(before["closes"]) + 1
				or int(taken["replacements"]) != int(before["replacements"]) or int(taken["unpaused"]) != int(before["unpaused"]) + 1
				or (taken["receipt"] as PackedStringArray).size() < 4):
			problems.append("the panel did not close with the receipt shown: %s" % str(taken))
		var again: RiftRunLevelUpResult = review.mote_runtime.choose_level_up_lane(lane)
		if again.succeeded() or again.failure_reason() != NO_OFFER:
			problems.append("taking the lane again answered '%s'" % again.failure_reason())
		_spent_again.append("%s: '%s'" % [moment, again.failure_reason()])
	if release:
		match how:
			"Enter":
				_push_key(KEY_ENTER, false)
			"(A)":
				_push_joy(JOY_BUTTON_A, false)
	taken["choices_after_release"] = review.choices_taken
	if review.choices_taken != int(taken["choices"]):
		problems.append("the release took another card")
	_note_live(moment)
	(_records[label] as Array).append([source_level, 0 if receipt == null else receipt.root_seed, lane])
	_ledgers[label] = _twin.consumption_ledger().consumed_seeds()
	_retained_lines.append("%s%d %s" % [label, source_level, _whole(float(taken["experience"]))])
	_choices_read += 1
	for problem: String in problems:
		_choice_problems.append("%s: %s" % [moment, problem])
	_choice_lines.append("%s: root %d, granted [%s] — %s; Level %d -> %d with %s kept; %s" % [
		moment, 0 if receipt == null else receipt.root_seed, "" if receipt == null else ", ".join(receipt.granted_identity()),
		review.receipt_text("choice"), source_level, source_level + 1, _whole(retained),
		("the Level %d offer (root %d) took its place in the same call" % [source_level + 1, int(taken["root"])]) if chained
			else "the panel closed and play resumed in the same call"])
	return taken


# --- Readings ------------------------------------------------------------------------------------

## Everything a choice is judged by, read at one instant.
func _reading() -> Dictionary:
	var panel: RiftLevelUpOfferPanel = review.level_up_panel
	var runtime: RiftMoteRuntime = review.mote_runtime
	var active: bool = runtime != null and runtime.is_offer_active()
	return {
		"open": panel.is_open, "paused": paused, "active": active,
		"level": runtime.level() if runtime != null else 0,
		"experience": runtime.experience() if runtime != null else 0.0,
		"root": runtime.offer_root_seed() if active else -1,
		"calls": review.offer_open_calls, "choices": review.choices_taken, "attempts": review.choice_attempts,
		"attempted_level": review.offer_attempted_level(),
		"opens": panel.opens, "closes": panel.closes, "replacements": panel.replacements,
		"unpaused": _probe_count("unpaused"), "ticks": _probe_count("ticks"), "sweeps": review.sweeps_made,
		"focus_first": root.gui_get_focus_owner() == panel.card_buttons()[0],
		"refusal": panel.refusal_text(), "receipt": _receipt_lines(),
		"cards_match": panel.is_open and active and _cards_are_the_offer(),
		"hud_level": _hud_text(HUD_LEVEL), "hud_experience": _hud_text(HUD_EXPERIENCE),
	}


## What must not move while the world is held: the enemy, the player, the sweep, the motes, the
## attack, and what the pause probe has received.
func _frozen(enemy: PrototypeGraveblade) -> Dictionary:
	var runtime: RiftMoteRuntime = review.mote_runtime
	return {
		"sweeps": review.sweeps_made, "player": review.player.global_position, "life": review.player.life,
		"enemy": enemy.global_position, "enemy_state": enemy.state, "enemy_time": enemy.state_time,
		"enemy_life": enemy.life, "enemy_ai": enemy.ai_enabled,
		"drops": runtime.drop_count(), "uncollected": runtime.uncollected_count(), "collected": runtime.collected_count(),
		"attack": review.player.attack.phase, "attacks": review.player.attack.uses_started,
		"destination": review.player.has_destination, "ticks": _probe_count("ticks"), "unpaused": _probe_count("unpaused"),
	}


func _leak_reading() -> Dictionary:
	return {
		"closes": review.level_up_panel.closes, "attempts": review.choice_attempts, "choices": review.choices_taken,
		"loop": review.loop_state, "runs": review.runs_started, "pickup": review.automatic_pickup,
		"grid": review.grid_visible, "camera": review.camera_rig.distance_metres,
		"attacks": review.player.attack.uses_started, "destination": review.player.has_destination,
		"offer": _h8_line(), "open": review.level_up_panel.is_open, "paused": paused,
	}


func _probe_count(field: String) -> int:
	return int(_probe.get(field))


func _note_live(moment: String) -> void:
	_live_readings += 1
	var live: Dictionary = _live_values()
	if live != _baseline:
		_live_problems.append("%s: %s" % [moment, str(live)])


func _live_values() -> Dictionary:
	var strike: QuickStrikeData = review.player.attack.data
	return {
		"max_speed": review.player.max_speed,
		"increased_attack_speed": review.player.increased_attack_speed(),
		"effective_action_time": review.player.attack.effective_action_time(),
		"action_time": strike.action_time,
		"reach": strike.reach,
		"arc": strike.release_arc_degrees,
		"cone": strike.soft_target_cone_degrees,
		"weapon_damage": review.player.weapon.physical_damage,
	}


func _line(root_seed: int, lanes: Array, identities: Array, kind: int, category: int) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for identity: Variant in identities:
		parts.append("[%s]" % ", ".join(PackedStringArray(identity)))
	return "root %d lanes %s %s kind %d category %d" % [root_seed, str(lanes), " ".join(parts), kind, category]


func _h8_line() -> String:
	var r: RiftMoteRuntime = review.mote_runtime
	if r == null or not r.is_offer_active():
		return "no offer"
	return _line(r.offer_root_seed(), r.offer_lanes(), [r.offer_identity_for(0), r.offer_identity_for(1), r.offer_identity_for(2)],
		r.offer_support_content_kind(), r.offer_support_fallback_category())


func _g4_line() -> String:
	if not _twin.is_offer_active():
		return "no offer"
	return _line(_twin.offer_root_seed(), _twin.offer_lanes(),
		[_twin.offer_identity_for(0), _twin.offer_identity_for(1), _twin.offer_identity_for(2)],
		_twin.offer_support_content_kind(), _twin.offer_support_fallback_category())


## Seed 99's typed offer at level `index + 1` with Support taken at every level before it.
func _expected_line(index: int) -> String:
	return _line(ROOTS[index], [0, 1, 2], SUPPORT_IDENTITIES[index], SUPPORT_KINDS[index], SUPPORT_CATEGORIES[index])


## Every field of a run-level record and its receipt copy, as one line.
func _record(record: RiftRunLevelUpResult) -> String:
	if record == null:
		return "no record"
	var receipt: RiftLevelUpResult = record.level_up()
	if receipt == null:
		return "run_seed=%d source=%d no receipt" % [record.run_seed, record.source_level]
	return "run_seed=%d source=%d succeeded=%s reason='%s' | ok=%s known=%s root=%d lane=%d identity=[%s] kind=%d ranks=%d->%d content=%d category=%d | problem='%s'" % [
		record.run_seed, record.source_level, str(record.succeeded()), record.failure_reason(),
		str(receipt.ok), str(receipt.root_seed_known), receipt.root_seed, receipt.lane,
		", ".join(receipt.granted_identity()), receipt.support_progression_kind, receipt.support_rank_before,
		receipt.support_rank_after, receipt.support_content_kind, receipt.support_fallback_category, record.problem()]


func _state() -> String:
	if review.mote_runtime == null:
		return "no runtime; attempted level %d, calls %d, open %s, paused %s" % [
			review.offer_attempted_level(), review.offer_open_calls, str(review.level_up_panel.is_open), str(paused)]
	return "level %d, experience %s, active %s, calls %d, attempted level %d, open %s, paused %s, refusal '%s'" % [
		review.mote_runtime.level(), _amount_text(review.mote_runtime.experience()),
		str(review.mote_runtime.is_offer_active()), review.offer_open_calls, review.offer_attempted_level(),
		str(review.level_up_panel.is_open), str(paused), review.last_offer_refusal]


# --- The cards ----------------------------------------------------------------------------------

func _shown_cards() -> Array:
	var shown: Array = []
	for slot: int in review.level_up_panel.card_count():
		shown.append(Array(review.level_up_panel.card_lines(slot)))
	return shown


func _captions() -> PackedStringArray:
	var captions: PackedStringArray = PackedStringArray()
	for button: Button in review.level_up_panel.card_buttons():
		captions.append(_caption(button))
	return captions


func _titles() -> PackedStringArray:
	return _titles_of(_shown_cards())


func _titles_of(cards: Array) -> PackedStringArray:
	var titles: PackedStringArray = PackedStringArray()
	for card: Array in cards:
		titles.append(String(card[1]))
	return titles


## What the standing offer's three cards must read, derived here from H8's own readings and the
## accepted catalogues — the harness's own derivation, not the review's.
func _derived_cards() -> Array:
	var runtime: RiftMoteRuntime = review.mote_runtime
	var kind: int = runtime.offer_support_content_kind()
	var cards: Array = []
	for lane: int in runtime.offer_lanes():
		var identity: PackedStringArray = runtime.offer_identity_for(lane)
		var label: String = RiftOffer.lane_label(lane)
		if lane == SUPPORT and kind == 0:
			var support: SupportDefinition = SkillSupportCatalogue.support_definition(StringName(identity[1]))
			var skill: SkillTagProfile = SkillSupportCatalogue.skill_profile(StringName(identity[0]))
			cards.append([label, support.display_name(), "Applies to %s" % skill.display_name])
		else:
			var record: PassiveCardDefinition = PassiveCardCatalogue.record(StringName(identity[0]))
			var detail: String = record.effect_line()
			if lane == SUPPORT:
				detail = "Supports maxed — %s" % detail
			cards.append([label, record.display_name, detail])
	return cards


func _cards_are_the_offer() -> bool:
	var shown: Array = _shown_cards()
	if shown != _derived_cards():
		return false
	var captions: PackedStringArray = _captions()
	for slot: int in shown.size():
		if captions[slot] != "Choose %s" % String(shown[slot][1]):
			return false
	return true


# --- On screen ---------------------------------------------------------------------------------

func _measure_panel(label: String) -> String:
	await _await_process_frames(4)
	var viewport: Rect2 = Rect2(Vector2.ZERO, Vector2(root.get_visible_rect().size))
	var panel: RiftLevelUpOfferPanel = review.level_up_panel
	var controls: Array[Control] = panel.text_controls()
	var visible: int = 0
	for control: Control in controls:
		if control.is_visible_in_tree():
			visible += 1
	var shown: int = _measure_text(controls, viewport, label)
	var smallest: int = _smallest_font(controls)
	var overlapping: int = 0
	for a: int in 3:
		for b: int in range(a + 1, 3):
			if panel.card_block(a).get_global_rect().intersects(panel.card_block(b).get_global_rect()):
				overlapping += 1
	var narrowest: float = 99999.0
	for slot: int in 3:
		narrowest = minf(narrowest, panel.card_block(slot).get_global_rect().size.x)
	var content: Rect2 = (panel.get_node("Panel") as Control).get_global_rect()
	var offset: Vector2 = content.get_center() - viewport.get_center()
	_expect_quiet(shown == visible and visible == controls.size() - 1 and smallest >= 12 and overlapping == 0
			and narrowest >= RiftLevelUpOfferPanel.CARD_WIDTH - 0.5 and viewport.encloses(content)
			and panel.get_global_rect().encloses(viewport) and absf(offset.x) <= 1.0 and absf(offset.y) <= 1.0,
		"%s: %d of %d controls on screen, smallest %d, %d overlapping, narrowest %.1f, offset %s" % [label, shown, visible,
			smallest, overlapping, narrowest, offset])
	return "%s: %d of %d visible text controls on screen, smallest %d px; 3 cards, %d overlapping, each at least %.0f px wide; the panel centred within 1 px" % [
		label, shown, visible, smallest, overlapping, RiftLevelUpOfferPanel.CARD_WIDTH]


func _measure_receipt() -> String:
	await _await_process_frames(4)
	var viewport: Rect2 = Rect2(Vector2.ZERO, Vector2(root.get_visible_rect().size))
	var controls: Array[Control] = review.receipt_controls()
	var shown: int = _measure_text(controls, viewport, "receipt")
	var host: Rect2 = review.experience_hud.panel.get_global_rect()
	var outside: int = 0
	for control: Control in controls:
		if control.is_visible_in_tree() and not host.encloses(control.get_global_rect()):
			outside += 1
	var centre: Rect2 = Rect2(viewport.size * 0.25, viewport.size * 0.5)
	var smallest: int = _smallest_font(controls)
	_expect_quiet(shown == 5 and outside == 0 and viewport.encloses(host) and not host.intersects(centre) and smallest >= 12,
		"the receipt: %d lines on screen, %d outside the review panel %s" % [shown, outside, host])
	return "the fallback receipt: %d lines on screen inside the review panel, clear of the centre, smallest %d px; not paused" % [shown, smallest]


# --- Expeditions --------------------------------------------------------------------------------

## STAGED for every expedition after the first: the Nexus's next plan is replaced by a fresh
## plan of the route's seed, so each expedition is an equivalent fresh one (D-294 ruling 4).
func _begin_expedition(label: String) -> void:
	if review.plan.seed_value != ROUTE_SEED:
		review.plan = RogueliteRunPlan.new(ROUTE_SEED, review.plan.run_index)
		_staged_plans += 1
	_calls_at_start = review.offer_open_calls
	await _walk_into_gate(review.hub_module.exit_point())
	_expeditions += 1
	_twin = RiftRunLevelCoordinator.new(ROUTE_SEED)
	_records[label] = []
	_fresh_lines[label] = "Level %d, XP %s, no offer standing, attempted level %d, an empty temporary build of %d pair(s) and %d card(s), the panel closed" % [
		review.mote_runtime.level() if review.mote_runtime != null else 0,
		_whole(review.mote_runtime.experience()) if review.mote_runtime != null else "—", review.offer_attempted_level(),
		review.mote_runtime.run_build().support_count() if review.mote_runtime != null else -1,
		review.mote_runtime.run_build().passive_acquisitions() if review.mote_runtime != null else -1]
	_expect_quiet(_is_fresh(), "expedition %s did not begin fresh at seed %d: %s" % [label, ROUTE_SEED, _state()])
	if not review.automatic_pickup:
		await _key(KEY_F8)


func _is_fresh() -> bool:
	var runtime: RiftMoteRuntime = review.mote_runtime
	return (review.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN and review.run_state.current_room_index == 0
		and runtime != null and runtime.run_seed() == ROUTE_SEED and runtime.level() == 1 and runtime.experience() == 0.0
		and not runtime.is_offer_active() and not review.offer_attempted()
		and review.offer_attempted_level() == RogueliteLevelUpChoiceReview.NO_LEVEL_ASKED
		and runtime.run_build().is_empty() and not review.level_up_panel.is_open and not paused
		and _receipt_lines().is_empty())


func _cleared() -> bool:
	return (review.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB and review.mote_runtime == null
		and not review.offer_attempted() and review.offer_attempted_level() == RogueliteLevelUpChoiceReview.NO_LEVEL_ASKED
		and review.last_choice_record == null and review.last_offer_refusal.is_empty() and _receipt_lines().is_empty()
		and not review.level_up_panel.is_open and not paused and _hud_text(HUD_LEVEL) == "No expedition in progress")


func _end_expedition(label: String) -> void:
	await _key(KEY_F5)
	await _settle(4)
	if not _cleared():
		_quiet_problems.append("expedition %s's end left offer state behind: %s" % [label, _state()])
	for fixture: Node in _stage.get_children():
		fixture.queue_free()
	await _await_process_frames(2)
	_teardowns.append(label)


## Clears the Teaching Hall and the Cache Room at the player's feet with pickup on, and walks
## into the Elite Hall at 75 — every mote real, every one given to the twin too.
func _route_to_the_elite_hall() -> void:
	for index: int in [0, 1]:
		_quiet_room(index)
		var centre: Vector3 = _rounded(review.room_modules[index].room_centres()[0])
		_stand(centre)
		for enemy: PrototypeGraveblade in review.room_enemies[index]:
			enemy.place_at(centre)
			_kill(enemy)
			_twin_award(REVIEW_AMOUNT)
		await _settle(3)
		await _walk_into_gate(review.room_modules[index].exit_point())
	_expect_quiet(review.run_state.current_room_index == 2 and review.mote_runtime.experience() == 75.0
			and not review.offer_attempted() and not review.level_up_panel.is_open,
		"the route did not reach the Elite Hall at 75 with nothing asked: %s" % _state())


## STAGED: each amount awarded as the header states, every mote collected by ONE explicit H8
## sweep before any tick of the review's own can run. The twin is given the same amounts.
func _award(amounts: Array) -> bool:
	var runtime: RiftMoteRuntime = review.mote_runtime
	var before: float = runtime.experience()
	var drops: int = runtime.drop_count()
	var at: Vector3 = review.hub_module.room_centres()[0] + Vector3(-4.0, 0.0, 2.0)
	var registered: bool = true
	var total: float = 0.0
	var expected: PackedInt32Array = PackedInt32Array()
	for amount: Variant in amounts:
		_fixtures += 1
		var enemy: PrototypeGraveblade = (load(GRAVEBLADE_SCENE) as PackedScene).instantiate() as PrototypeGraveblade
		enemy.name = "I11Fixture%d" % _fixtures
		enemy.position = at
		_stage.add_child(enemy)
		enemy.set_ai_enabled(false)
		registered = registered and runtime.register_graveblade(enemy, float(amount)).is_empty()
		enemy.receive_damage(DamageEvent.physical(_use(), review.player, enemy, enemy.life + 1000.0))
		registered = registered and not enemy.is_alive() and runtime.emission_answer(enemy).is_empty()
		expected.append(drops + expected.size())
		total += float(amount)
		_twin_award(float(amount))
	var answer: RiftMoteSweepResult = runtime.sweep_at(at)
	review.experience_hud.refresh()
	return registered and answer.ok and answer.collected_indices() == expected and runtime.experience() == before + total


func _twin_award(amount: float) -> void:
	_expect_quiet(_twin.award_experience(amount).is_empty(), "the twin refused an award of %s" % str(amount))


func _twin_open() -> String:
	return _twin.open_current_offer(SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(),
		PassiveCardCatalogue.records())


# --- Input, through the viewport ---------------------------------------------------------------

func _push_key(keycode: Key, pressed: bool) -> void:
	var event: InputEventKey = InputEventKey.new()
	event.keycode = keycode
	event.physical_keycode = keycode
	event.pressed = pressed
	root.push_input(event)


## The same key repeating while it is held: pressed, and an echo.
func _push_key_echo(keycode: Key) -> void:
	var event: InputEventKey = InputEventKey.new()
	event.keycode = keycode
	event.physical_keycode = keycode
	event.pressed = true
	event.echo = true
	root.push_input(event)


func _key(keycode: Key) -> void:
	_push_key(keycode, true)
	_push_key(keycode, false)
	await _await_process_frames(1)


func _push_joy(button: JoyButton, pressed: bool) -> void:
	var event: InputEventJoypadButton = InputEventJoypadButton.new()
	event.device = 0
	event.button_index = button
	event.pressed = pressed
	root.push_input(event)


func _joy(button: JoyButton) -> void:
	_push_joy(button, true)
	_push_joy(button, false)
	await _await_process_frames(1)


func _point_at(at: Vector2) -> void:
	var motion: InputEventMouseMotion = InputEventMouseMotion.new()
	motion.position = at
	motion.global_position = at
	root.push_input(motion, true)


func _push_mouse(at: Vector2, button: MouseButton, pressed: bool) -> void:
	var click: InputEventMouseButton = InputEventMouseButton.new()
	click.button_index = button
	click.pressed = pressed
	click.position = at
	click.global_position = at
	root.push_input(click, true)


func _mouse_click(at: Vector2, button: MouseButton) -> void:
	_point_at(at)
	_push_mouse(at, button, true)
	_push_mouse(at, button, false)
	await _await_process_frames(1)


func _set_pickup(value: bool) -> void:
	if review.automatic_pickup != value:
		await _key(KEY_F8)
	_expect_quiet(review.automatic_pickup == value, "F8 did not turn automatic pickup %s" % ("ON" if value else "OFF"))


# --- Evidence ------------------------------------------------------------------------------------

## Adds no assertion: the rendered runs pin the same count as the headless one.
func _capture(stem: String, settle_seconds: float = 0.0) -> void:
	if _shot_dir.is_empty():
		return
	if settle_seconds > 0.0:
		await create_timer(settle_seconds).timeout
	await _await_process_frames(6)
	for i: int in 7:
		await RenderingServer.frame_post_draw
	var path: String = "%s/%s.png" % [_shot_dir, stem]
	root.get_texture().get_image().save_png(path)
	print("  screenshot: %s" % path)


func _argument_value(flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


# --- Helpers ------------------------------------------------------------------------------------

func _stand(at: Vector3) -> void:
	review.player.global_position = Vector3(at.x, 0.0, at.z)
	review.player.velocity = Vector3.ZERO
	review.player.clear_movement_intent("verification", false)
	review.camera_rig.focus = review.player.global_position


func _kill(enemy: PrototypeGraveblade) -> void:
	enemy.receive_damage(DamageEvent.physical(_use(), review.player, enemy, enemy.life + 1000.0))
	_expect_quiet(not enemy.is_alive(), "%s did not die from a lethal hit" % enemy.name)


func _quiet_room(index: int) -> void:
	for enemy: PrototypeGraveblade in review.room_enemies[index]:
		enemy.set_ai_enabled(false)


func _walk_into_gate(gate: Vector3) -> void:
	_stand(gate)
	await _await_process_frames(6)
	await _settle(4)


func _use() -> int:
	_next_use_id += 1
	return _next_use_id


func _rounded(at: Vector3) -> Vector3:
	return Vector3(roundf(at.x), 0.0, roundf(at.z))


func _planar_gap(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()


func _await_navigation() -> void:
	for frame: int in 60:
		if NavigationServer3D.map_get_iteration_id(review.navigation_map()) > 0:
			return
		await physics_frame


func _settle(frames: int) -> void:
	for i: int in frames:
		await physics_frame


func _await_process_frames(frames: int) -> void:
	for i: int in frames:
		await process_frame


func _amount_text(value: float) -> String:
	return "%.1f" % value


func _whole(value: float) -> String:
	if value == floorf(value):
		return "%d" % int(value)
	return "%.1f" % value


func _hud_text(index: int) -> String:
	return review.experience_hud.text_controls()[index].text


func _hud_visible(index: int) -> bool:
	return review.experience_hud.text_controls()[index].is_visible_in_tree()


func _receipt_lines() -> PackedStringArray:
	var lines: PackedStringArray = PackedStringArray()
	for control: Control in review.receipt_controls():
		if control.is_visible_in_tree():
			lines.append((control as Label).text)
	return lines


func _caption(button: Button) -> String:
	for child: Node in button.get_children():
		for grandchild: Node in child.get_children():
			var label: Label = grandchild as Label
			if label != null:
				return label.text
	return button.text


func _smallest_font(controls: Array[Control]) -> int:
	var smallest: int = 999
	for control: Control in controls:
		if not control.is_visible_in_tree():
			continue
		if control is Label:
			smallest = mini(smallest, control.get_theme_font_size("font_size"))
		elif control is Button:
			for child: Node in control.find_children("*", "Label", true, false):
				smallest = mini(smallest, (child as Label).get_theme_font_size("font_size"))
	return smallest


func _measure_text(controls: Array[Control], viewport: Rect2, label: String) -> int:
	var visible: int = 0
	for control: Control in controls:
		if control == null or not control.is_visible_in_tree():
			continue
		var rect: Rect2 = control.get_global_rect()
		var inside: bool = rect.size.x > 0.0 and rect.size.y > 0.0 and viewport.encloses(rect)
		_expect_quiet(inside, "%s: a visible control has no rectangle inside the viewport (%s)" % [label, rect])
		if inside:
			visible += 1
	return visible


func _declared_functions(source: String) -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	var pattern: RegEx = RegEx.create_from_string("(?m)^(?:static )?func ([A-Za-z0-9_]+)\\(")
	for found: RegExMatch in pattern.search_all(source):
		names.append(found.get_string(1))
	return names


## The indented body of top-level function `name`, up to the next unindented line.
func _function_body(source: String, name: String) -> String:
	var body: PackedStringArray = PackedStringArray()
	var inside: bool = false
	for line: String in source.split("\n"):
		if line.begins_with("func %s(" % name) or line.begins_with("static func %s(" % name):
			inside = true
			continue
		if inside:
			if not line.is_empty() and not line.begins_with("\t") and not line.begins_with(" "):
				break
			body.append(line)
	return "\n".join(body)


## Code with every comment line removed and every string literal emptied.
func _bare(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	var strings: RegEx = RegEx.create_from_string("\"([^\"\\\\]|\\\\.)*\"")
	return strings.sub("\n".join(kept), "\"\"", true)


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


## Records a failure without adding to the pinned count, inside loops whose length is incidental.
func _expect_quiet(condition: bool, failure_message: String) -> void:
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
