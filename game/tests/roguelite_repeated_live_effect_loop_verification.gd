extends SceneTree
## Riftwrought — Roguelite I12: Repeated Live-Effect Level-Up Loop Review V1: automated,
## rendered verification (decision D-316).
##
## THE ONE QUESTION: can the accepted live-effect review (I3) inherit the accepted repeated and
## chained level-up loop (I11) — making the run's WHOLE accumulated temporary build live after
## every successful choice, inside that choice's own call and before another frame, holding the
## world continuously while one offer takes another's place, and keeping every previous choice
## receipt and every live-effect receipt hidden for as long as any offer stands?
##
## IT OWNS NO SCENE AND ADDS NO ENTRY POINT TO ANY RUNTIME. This is a SceneTree script: it loads
## the accepted I3 scene, `roguelite_live_effect_review.tscn`, exactly as it ships, and drives it
## from outside. The scene answers only its own I3 flag, which this harness does not pass, so no
## accepted suite starts in it.
##
## TWO EXPEDITIONS, BOTH OF SEED 99:
##   A — the route's own motes to 75 and one more mote to exactly 100: Level 1 opens on its own
##       and Support is taken (Sweeping Edge, rank 0 -> 1); 125 at Level 2, opened on its own,
##       Support (Reaching Edge, rank 0 -> 1); then 525 banked at Level 3, so Levels 3, 4 and 5
##       are chosen one after another in one panel that never lets the world go — Reaching Edge
##       rank 1 -> 2, Sweeping Edge rank 1 -> 2, and the Level 5 passive fallback, Power. The
##       accumulated build is then played with real controller Quick Strikes at 3.20 m, at 110°
##       off the facing and into two eligible targets, and a real stick walk; F5 ends it.
##   B — the next expedition begins with nothing of A's; F5 ends it.
##
## STAGED, AND STATED WHERE IT HAPPENS:
##   - every experience point beyond the route's own 75 is awarded the way I11 awarded its own:
##     a production Graveblade in the Nexus, registered with the expedition's own H8 runtime for
##     exactly that amount through H8's public `register_graveblade()`, killed through its own
##     `receive_damage()`, and its mote collected by ONE explicit H8 sweep where it fell. No
##     experience-track award method is called anywhere in this file. Every opening after an
##     award is the review's own, on its own tick;
##   - the Elite Hall's two Graveblades are placed with their own `place_at()` and switched
##     with their own `set_ai_enabled()`, so an angle, a distance and a Life can be measured;
##   - the refused choice during the chain hands the review's card entry point lane 7;
##   - expedition B is handed seed 99 again by replacing the Nexus's next run plan (D-294
##     ruling 4).
##
## A PAUSE PROBE MEASURES THE CONTINUOUS PAUSE, exactly as I11's does: a plain `Node` beside the
## scene counts every physics tick a pausable node receives and every NOTIFICATION_UNPAUSED.
##
## G1, G2 AND G4 ARE ASKED, NOT RESTATED: G1 for each requirement, G2 for each root seed, and G4
## through the run the H8 runtime forwards to, for every offer, record and build. Each answer is
## compared against a typed expectation stated here independently.
##
## IT PORTS D-211's OWED-SET DISCIPLINE and GATE F's ON-SCREEN MEASUREMENT. The evidence frames
## add no assertion, so the headless and rendered runs pin the same count.
##
## Run: godot --headless --path game --script res://tests/roguelite_repeated_live_effect_loop_verification.gd -- --seed 99

const REVIEW_SCENE: String = "res://scenes/roguelite/roguelite_live_effect_review.tscn"
const REVIEW_SCRIPT: String = "res://scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
const I2_SCRIPT: String = "res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
const PANEL_SCRIPT: String = "res://scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
const H9_SCRIPT: String = "res://scripts/roguelite/experience/roguelite_experience_collection_review.gd"
const H9_HUD_SCRIPT: String = "res://scripts/roguelite/experience/roguelite_experience_review_hud.gd"
const CORE_LOOP_SCRIPT: String = "res://scripts/roguelite/roguelite_core_loop_runtime.gd"
const SLICE_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
const SEAM_SCRIPT: String = "res://scripts/roguelite/live_effects/rift_build_application.gd"
const THIS_FILE: String = "res://tests/roguelite_repeated_live_effect_loop_verification.gd"
const GRAVEBLADE_SCENE: String = "res://scenes/actors/prototype_graveblade.tscn"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31

const ROUTE_SEED: int = 99
const REVIEW_AMOUNT: float = 25.0
const SUPPORT: int = 0
const QUICK_STRIKE: StringName = &"quick_strike"
const REACHING_EDGE: StringName = &"reaching_edge"
const SWEEPING_EDGE: StringName = &"sweeping_edge"
const POWER: StringName = &"card_power"
const MAXIMUM_RANK: int = 2

## G1's requirements for Levels 1–6 and G2's root seeds for seed 99, Levels 1–5, typed here and
## asserted against the mechanisms' own answers.
const REQUIREMENTS: Array[float] = [100.0, 125.0, 150.0, 175.0, 200.0, 225.0]
const ROOTS: Array[int] = [99, 1000102, 2000105, 3000108, 4000111]

## Seed 99 with Support taken at every level: the accepted I10/I11 table (D-312, D-314).
const OFFERS: Array = [
	[["quick_strike", "sweeping_edge"], ["card_celerity"], ["card_fleetness"]],
	[["quick_strike", "reaching_edge"], ["card_power"], ["card_magnetism"]],
	[["quick_strike", "reaching_edge"], ["card_vitality"], ["card_fleetness"]],
	[["quick_strike", "sweeping_edge"], ["card_power"], ["card_magnetism"]],
	[["card_power"], ["card_vitality"], ["card_fleetness"]],
]
const OFFER_KINDS: Array[int] = [0, 0, 0, 0, 1]
const OFFER_CATEGORIES: Array[int] = [-1, -1, -1, -1, 0]
const OFFER_TITLES: Array = [
	["Sweeping Edge", "Celerity", "Fleetness"], ["Reaching Edge", "Power", "Magnetism"],
	["Reaching Edge", "Vitality", "Fleetness"], ["Sweeping Edge", "Power", "Magnetism"],
	["Power", "Vitality", "Fleetness"],
]
## I10's accepted fallback cards (D-312), word for word.
const FALLBACK_CARDS: Array = [
	["Support", "Power", "Supports maxed — +10% Global Damage"],
	["Combat and Defence", "Vitality", "+15% Maximum Life"],
	["Utility", "Fleetness", "+10% Movement Speed"],
]

## The five choices, typed independently of every mechanism: what each takes, what it leaves the
## run, whether the next level's offer then stands, and what is live afterwards.
const STEP_CHOICES: Array[String] = [
	"Support — Quick Strike → Sweeping Edge", "Support — Quick Strike → Reaching Edge",
	"Support — Quick Strike → Reaching Edge", "Support — Quick Strike → Sweeping Edge",
	"Support — Power (+10% Global Damage)",
]
const STEP_SECONDARY: Array[String] = [
	"a new compatible pair, rank 0 -> 1", "a new compatible pair, rank 0 -> 1",
	"another rank of a held pair, rank 1 -> 2", "another rank of a held pair, rank 1 -> 2",
	"Passive fallback from Combat and Defence",
]
const STEP_LEVEL_LINES: Array[String] = [
	"Rift level 1 → 2 · 0 XP carried over", "Rift level 2 → 3 · 0 XP carried over",
	"Rift level 3 → 4 · 375 XP carried over", "Rift level 4 → 5 · 200 XP carried over",
	"Rift level 5 → 6 · 0 XP carried over",
]
const STEP_KEPT: Array[float] = [0.0, 0.0, 375.0, 200.0, 0.0]
const STEP_CHAINED: Array[bool] = [false, false, true, true, false]
const STEP_RANKS_BEFORE: Array[int] = [0, 0, 1, 1, -1]
const STEP_RANKS_AFTER: Array[int] = [1, 1, 2, 2, -1]
const STEP_REACH: Array[float] = [1.65, 2.65, 3.65, 3.65, 3.65]
const STEP_ARC: Array[float] = [180.0, 180.0, 180.0, 260.0, 260.0]
const STEP_CONE: Array[float] = [110.0, 110.0, 110.0, 155.0, 155.0]
const STEP_REACHING_RANK: Array[int] = [0, 1, 2, 2, 2]
const STEP_SWEEPING_RANK: Array[int] = [1, 1, 1, 2, 2]
const STEP_SUPPORTS: Array[String] = [
	"quick_strike -> sweeping_edge rank 1",
	"quick_strike -> reaching_edge rank 1, quick_strike -> sweeping_edge rank 1",
	"quick_strike -> reaching_edge rank 2, quick_strike -> sweeping_edge rank 1",
	"quick_strike -> reaching_edge rank 2, quick_strike -> sweeping_edge rank 2",
	"quick_strike -> reaching_edge rank 2, quick_strike -> sweeping_edge rank 2",
]
const STEP_HUD: Array = [
	["Rift level 2", "XP 0 / 125"], ["Rift level 3", "XP 0 / 150"], ["Rift level 4", "XP 375 / 175"],
	["Rift level 5", "XP 200 / 200"], ["Rift level 6", "XP 0 / 225"],
]
const LIVE_ONE: String = "Live now — arc 100° → 180° · cone 65° → 110° · one target"
const LIVE_TWO: String = "Live now — reach 1.65 m → 2.65 m · arc 100° → 180° · cone 65° → 110° · one target"
const LIVE_THREE: String = "Live now — reach 1.65 m → 3.65 m · arc 100° → 180° · cone 65° → 110° · one target"
const LIVE_FOUR: String = "Live now — reach 1.65 m → 3.65 m · arc 100° → 260° · cone 65° → 155° · one target"
## Roguelite I13 (D-318) made Global Damage live, so the fifth receipt moved one for one:
## Power's damage is now a live line beside the spatial ones, and no held heading remains.
const LIVE_FIVE: String = "Live now — reach 1.65 m → 3.65 m · arc 100° → 260° · cone 65° → 155° · one target\ndamage 100 → 110"
const STEP_LIVE: Array[String] = [LIVE_ONE, LIVE_TWO, LIVE_THREE, LIVE_FOUR, LIVE_FIVE]
const POWER_DAMAGE_LINE: String = "damage 100 → 110"

## The accepted wording the receipts are read against (D-293, D-295, D-297, D-313).
const LIVE_PREFIX: String = "Live now — "
const HELD_HEADING: String = "Held, not live on the character:"
const RECEIPT_TITLE: String = "Temporary build — this expedition"
const OFFER_STANDING_TEXT: String = "Level-up offer open — choose one of the three cards."
const RECEIPT_LIVE_NOTE: String = "Applied to the character now; every value returns to its baseline when this expedition ends."
const PANEL_NOTE: String = "Covered effects are applied immediately for this expedition. Final values and presentation are not locked."
const STANDING_LINES: Array[String] = [RECEIPT_TITLE, OFFER_STANDING_TEXT]
const NO_OFFER: String = "no offer is open; one must be opened before a lane may be taken"
const REFUSAL_PREFIX: String = "That choice was refused: "
## Nothing a completed receipt or a live receipt carries may be visible while an offer stands.
const STALE_MARKERS: Array[String] = [
	"Live now", "Held, not live", "carried over", "Passive fallback", "rank 0 -> 1", "rank 1 -> 2",
	"Support —", "Applied to the character",
]

## The accepted live baselines (D-175, D-178 and the canonical Quick Strike record).
const ACCEPTED_MAX_SPEED: float = 5.0
const ACCEPTED_ACTION_TIME: float = 0.80
const ACCEPTED_REACH: float = 1.65
const ACCEPTED_ARC: float = 100.0
const ACCEPTED_CONE: float = 65.0
const ACCEPTED_MARKER: float = 0.325
const ACCEPTED_DAMAGE: float = 100.0
const SPEED_TOLERANCE: float = 0.01

## I4's accepted measuring positions (D-299), used as the reference for the real play below.
const BETWEEN_REACHES: float = 3.20
const WIDE_ANGLE: float = 110.0
const NEAR_TARGET: float = 1.20
const PAIR_NEAR: float = 3.00
const PAIR_FAR: float = 3.40

## The controller's Quick Strike button (project.godot: joypad button 2).
const QUICK_STRIKE_BUTTON: JoyButton = JOY_BUTTON_X
const WALK_TICKS: int = 45
const PLATEAU_WINDOW: int = 12

## H9's review-panel text controls, in its `text_controls()` order.
const HUD_LEVEL: int = 2
const HUD_EXPERIENCE: int = 3

## The review's accepted shape (D-295, D-297): exactly these fields, constants and functions.
const EXPECTED_FIELDS: String = "applications_made, application_refusals, restorations_made, last_application, last_restoration, last_application_physics_frame, last_application_process_frame, _live_line, _receipt_live"
const EXPECTED_CONSTANTS: String = "LIVE_EFFECT_VERIFICATION_SCRIPT, PANEL_NOTE, RECEIPT_LIVE_NOTE, LIVE_PREFIX, HELD_HEADING, NOTHING_CHANGED"
const EXPECTED_FUNCTIONS: String = "_build_run_surfaces, choose_offered_lane, _apply_expedition_build, _discard_mote_runtime, _restore_baselines, _refresh_receipt, live_receipt_for, live_receipt_text, live_receipt_control, _maybe_start_verification"
const EXPECTED_OVERRIDES: Array[String] = [
	"_build_run_surfaces", "_discard_mote_runtime", "_maybe_start_verification", "_refresh_receipt",
	"choose_offered_lane",
]
## The files the running review is made of: I3 over I2 and its panel, over H9 and its panel, over
## the core loop. None of them may write a covered live value; only the seam does.
const CHAIN_FILES: Array[String] = [REVIEW_SCRIPT, I2_SCRIPT, PANEL_SCRIPT, H9_SCRIPT, H9_HUD_SCRIPT, CORE_LOOP_SCRIPT]
const LIVE_WRITE_TOKENS: Array[String] = [
	"set_increased_attack_speed(", ".reach =", ".release_arc_degrees =", ".soft_target_cone_degrees =",
]
## Concrete Skill, support and card names and the stat words: none may appear in the review or
## its scene, comments included — the same list I3's own suite holds it to.
const CONCRETE_TOKENS: Array[String] = [
	"quick_strike", "Quick Strike", "QuickStrike", "sweeping_edge", "Sweeping Edge", "reaching_edge",
	"Reaching Edge", "card_power", "card_celerity", "card_vitality", "card_fleetness", "card_insight",
	"card_magnetism", "Celerity", "Vitality", "Fleetness", "Insight", "Magnetism", "Skill Speed",
	"Movement Speed", "Global Damage", "Maximum Life", "Experience Gain", "Pickup Radius", "10%",
]

## Accepted files I12 must not touch, by the SHA-256 prefix each held before the first I12 edit:
## I11's transaction and panel, the modal contract, H9, the core loop, the seam and its result,
## both catalogues and the stat vocabulary, the run build, H8, G1, G2, G4, E2, D1, D3, I6, the
## Quick Strike kernel, record and player, both review scenes, the loading teaser and project.godot.
const UNCHANGED_HASHES: Array = [
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", "128103b4"],
	## First-MVP UI J1 (D-322) moved the panel and the modal contract one for one — `61173e43` →
	## `694eb0b2` and `8d57039b` → `1cfe9c73` — moving the left-press routing from the panel into
	## the contract. Same count.
	["res://scripts/roguelite/level_up/rift_level_up_offer_panel.gd", "694eb0b2"],
	["res://scripts/ui/first_mvp_modal.gd", "1cfe9c73"],
	["res://scripts/roguelite/experience/roguelite_experience_collection_review.gd", "150509d5"],
	["res://scripts/roguelite/experience/roguelite_experience_review_hud.gd", "042a5088"],
	["res://scripts/roguelite/roguelite_core_loop_runtime.gd", "a76cec3d"],
	## Roguelite I13 (D-318) moved the seam and its result, the Quick Strike kernel and the player
	## one for one — `1aa00c5f`, `b6b6d1ee`, `4983826f` and `0b41b42c` — to the D-318 files. Same count.
	## Roguelite I14 (D-320) moved the seam, its result and the player one for one again — `63c7fe71`,
	## `b46ed70c` and `5639f75e` — to the D-320 files, making Maximum Life live. Same count.
	["res://scripts/roguelite/live_effects/rift_build_application.gd", "c7b9df38"],
	## Roguelite I14's correction (D-321) moved the result once more, from `73d445f7`, for its
	## describe() diagnostic. Same count.
	["res://scripts/roguelite/live_effects/rift_build_application_result.gd", "2fd01f80"],
	["res://scripts/skills/skill_support_catalogue.gd", "a94f61cc"],
	["res://scripts/stats/passive_card_catalogue.gd", "278b30dc"],
	["res://scripts/stats/player_stats.gd", "b0be8c7c"],
	["res://scripts/stats/player_stat_totals.gd", "84f3a515"],
	["res://scripts/runs/rift_run_build.gd", "1920ae25"],
	["res://scripts/experience/rift_mote_runtime.gd", "23c41eb2"],
	["res://scripts/level_requirements/rift_level_requirement_curve.gd", "c8b3f3b1"],
	["res://scripts/level_seeds/rift_level_offer_seed_derivation.gd", "5cc31f28"],
	["res://scripts/levels/rift_run_level_coordinator.gd", "b654e0a2"],
	["res://scripts/levels/rift_run_level_up_result.gd", "cc7f8b84"],
	["res://scripts/levels/rift_level_up_coordinator.gd", "f178c358"],
	["res://scripts/levels/rift_level_up_result.gd", "2d67cee9"],
	["res://scripts/offers/rift_offer.gd", "9bc94208"],
	["res://scripts/offers/rift_offer_composition.gd", "15ef203a"],
	["res://scripts/choices/rift_offer_choice.gd", "533ee30f"],
	["res://scripts/choices/rift_offer_choice_result.gd", "f051a955"],
	["res://scripts/choices/rift_consumption_ledger.gd", "f990eab7"],
	["res://scripts/fallback/support_exhaustion_passive_fallback.gd", "c1cad5e4"],
	["res://scripts/fallback/support_exhaustion_passive_fallback_result.gd", "a195665f"],
	["res://scripts/combat/quick_strike_action.gd", "e6514705"],
	["res://scripts/combat/quick_strike_data.gd", "50bfabfc"],
	["res://scripts/combat/target_acquisition.gd", "bf4c14d4"],
	## First-MVP UI J2 (D-324) moved the player one for one again, from `a6d93721`, so that
	## neutralizing a fallen character's controls keeps it FALLEN. Same count.
	["res://scripts/actors/prototype_player.gd", "80e38838"],
	["res://data/prototype_zero/quick_strike.tres", "76060315"],
	["res://scenes/roguelite/roguelite_live_effect_review.tscn", "0c3c6c98"],
	["res://scenes/roguelite/roguelite_level_up_choice_review.tscn", "7038bce6"],
	["res://assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png", "b34395ab"],
	["res://project.godot", "55351038"],
]
## The one production file I12 edits. Roguelite I13 (D-318) corrected one of its comments, so its
## prefix moved one for one from the D-316 `ec2ec19e` to the D-318 file, and Roguelite I14 (D-320) moved it
## again, from `f4eab7a4`, for one comment it corrected.
const CHANGED_FILE: String = "res://scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
const CHANGED_PREFIX: String = "75cb02b9"

## What this harness must never do to the review, the run or the character. Read over this file's
## own CODE, comments removed and strings emptied.
const INJECTION_PATTERNS: Array[String] = [
	"review._", ".mote_runtime._", "level_up_panel._", "mote_runtime = ", "review.set(", "review.call(",
	".callv(", "set_meta(", "add_action(", "action_add_event(", "while ", "award_experience(",
	"RiftBuildApplication.apply(", "set_increased_attack_speed(", ".max_speed = ", ".reach = ",
	"graveblades.append(", "Input.action_press(",
]

## The pause probe's own script: a plain Node counting what a pausable node receives.
const PROBE_SOURCE: String = "extends Node\nvar unpaused: int = 0\nvar paused_notices: int = 0\nvar ticks: int = 0\nfunc _notification(what: int) -> void:\n\tif what == NOTIFICATION_UNPAUSED:\n\t\tunpaused += 1\n\telif what == NOTIFICATION_PAUSED:\n\t\tpaused_notices += 1\nfunc _physics_process(_delta: float) -> void:\n\tticks += 1\n"

const OWED_CHECKS: Array[String] = [
	"the_harness_is_isolated_and_drives_the_accepted_i3_scene",
	"the_review_adds_no_state_and_keeps_one_application_seam",
	"the_accepted_mechanisms_are_byte_identical",
	"the_catalogue_and_seam_boundaries_are_the_accepted_ones",
	"level_one_opens_on_its_own_from_real_motes",
	"every_standing_offer_hides_both_receipts",
	"each_successful_choice_applies_the_whole_build_in_its_own_call",
	"the_live_values_accumulate_choice_by_choice",
	"a_chained_offer_takes_the_panel_with_the_values_already_live",
	"a_refused_lane_during_the_chain_changes_nothing",
	"the_world_stays_held_across_both_chained_offers",
	"the_cumulative_values_stand_behind_the_fallback_offer",
	"the_fallback_holds_power_changes_no_rank_and_consumes_its_root_once",
	"the_final_receipt_lists_the_damage_under_live_now",
	"the_real_strike_reaches_three_point_two_metres_on_the_accepted_timing",
	"the_real_strike_hits_one_hundred_and_ten_degrees_off_its_facing",
	"two_eligible_targets_still_make_one_hit",
	"movement_stays_at_its_baseline_and_power_adds_c1s_damage",
	"f5_restores_every_baseline_through_the_empty_build",
	"the_next_expedition_begins_without_the_previous_build",
]

var review: RogueliteLiveEffectReview
var arguments: PackedStringArray = PackedStringArray()

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _shot_dir: String = ""
var _stage: Node3D
var _probe: Node
var _next_use_id: int = 96000
var _fixtures: int = 0
var _expeditions: int = 0
var _staged_plans: int = 0
var _presses: int = 0
var _baseline: Dictionary = {}

## Evidence gathered across expedition A, read by the checks.
var _steps: Array[Dictionary] = []
var _standing: Array[Dictionary] = []
var _resumed: Array[Dictionary] = []
var _held_world: Dictionary = {}
var _frozen_readings: Array[Dictionary] = []
var _after_power: Dictionary = {}
var _panel_line: String = ""
var _receipt_line: String = ""
var _wrapped_lines: int = 0
var _hits: Array[float] = []
## Roguelite I13 (D-318): how many of those real hits took exactly C1's answer to the last bit.
var _exact_hits: int = 0
var _openings: PackedStringArray = PackedStringArray()


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	_shot_dir = _argument_value("--shots")
	print("")
	print("=== Roguelite I12 — Repeated Live-Effect Level-Up Loop Review V1 verification (D-316) ===")
	_stage = Node3D.new()
	_stage.name = "I12FixtureStage"
	root.add_child(_stage)
	var probe_script: GDScript = GDScript.new()
	probe_script.source_code = PROBE_SOURCE
	var compiled: Error = probe_script.reload()
	_probe = Node.new()
	_probe.name = "I12PauseProbe"
	_probe.set_script(probe_script)
	root.add_child(_probe)
	var changed: Error = change_scene_to_packed(load(REVIEW_SCENE) as PackedScene)
	for frame: int in 20:
		await process_frame
		if current_scene != null:
			break
	review = current_scene as RogueliteLiveEffectReview
	if changed != OK or compiled != OK or review == null:
		printerr("ROGUELITE REPEATED LIVE EFFECT LOOP VERIFICATION: the accepted I3 scene or the pause probe did not load")
		quit(1)
		return
	await _settle(10)
	await _await_navigation()

	_check_the_harness_is_isolated_and_drives_the_accepted_i3_scene()
	_check_the_review_adds_no_state_and_keeps_one_application_seam()
	_check_the_accepted_mechanisms_are_byte_identical()
	_check_the_catalogue_and_seam_boundaries_are_the_accepted_ones()

	await _expedition_a()
	await _check_f5_restores_every_baseline_through_the_empty_build()
	await _check_the_next_expedition_begins_without_the_previous_build()

	## Read last, over everything expedition A gathered.
	_check_every_standing_offer_hides_both_receipts()
	_check_each_successful_choice_applies_the_whole_build_in_its_own_call()
	_check_the_live_values_accumulate_choice_by_choice()
	_check_a_chained_offer_takes_the_panel_with_the_values_already_live()

	_check_every_check_ran()

	print("")
	print("  %d expeditions (%d given seed %d again by staging), %d fixture Graveblades registered and killed, %d real Quick Strike presses, %d offer openings asked by the review, %d level-ups taken, %d offers shown in place of a chosen one, %d applications and %d restorations made by the review"
		% [_expeditions, _staged_plans, ROUTE_SEED, _fixtures, _presses, review.offer_open_calls, review.choices_taken,
			review.level_up_panel.replacements, review.applications_made, review.restorations_made])
	if _failures.is_empty():
		print("ROGUELITE REPEATED LIVE EFFECT LOOP VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("ROGUELITE REPEATED LIVE EFFECT LOOP VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1–4. Isolation, the review's shape, the accepted files and the accepted boundaries ----------

func _check_the_harness_is_isolated_and_drives_the_accepted_i3_scene() -> void:
	print("")
	print("--- 1. The harness drives the accepted I3 scene unchanged; no accepted suite starts in it; nothing is injected")
	var script: GDScript = review.get_script() as GDScript
	_expect(review.scene_file_path == REVIEW_SCENE and script.resource_path == REVIEW_SCRIPT
			and script.get_base_script().resource_path == I2_SCRIPT and review is RogueliteLevelUpChoiceReview
			and review.get_node_or_null("RogueliteLiveEffectReviewVerification") == null
			and review.get_node_or_null("RogueliteLevelUpChoiceReviewVerification") == null
			and review.get_node_or_null("RogueliteExperienceCollectionReviewVerification") == null
			and review.get_node_or_null("RogueliteCoreLoopVerification") == null
			and not arguments.has("--verify-live-effects") and not arguments.has("--verify-level-up"),
		"the loaded scene is %s running %s, or an accepted suite started in it" % [review.scene_file_path, script.resource_path])
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	_expect(actions == EXPECTED_ACTIONS
			and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT
			and not settings.contains("[autoload]") and not settings.contains("repeated_live_effect"),
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
	var live: Label = review.live_receipt_control()
	var controls: Array[Control] = review.receipt_controls()
	_expect(injected.is_empty() and listed == INJECTION_PATTERNS.size() and own.length() > 20000
			and live != null and live.get_parent() == controls[4].get_parent()
			and live.get_index() == controls[4].get_index() + 1 and live.get_index() == controls[5].get_index() - 1,
		"this harness's code names %s (%d of %d patterns listed), or the live line is not between I2's level line and its note"
			% [", ".join(injected), listed, INJECTION_PATTERNS.size()])
	print("  the accepted scene %s runs %s over %s; no accepted suite started; %d actions; the entrypoint is %s; project.godot declares no [autoload]; 0 of %d injection patterns in this harness's code"
		% [REVIEW_SCENE.get_file(), REVIEW_SCRIPT.get_file(), I2_SCRIPT.get_file(), actions, ENTRYPOINT.get_file(),
			INJECTION_PATTERNS.size()])
	_done("the_harness_is_isolated_and_drives_the_accepted_i3_scene")


func _check_the_review_adds_no_state_and_keeps_one_application_seam() -> void:
	print("")
	print("--- 2. The review adds no field, constant or function; its receipt follows the standing offer; the seam stays the one live writer")
	var source: String = FileAccess.get_file_as_string(REVIEW_SCRIPT)
	var bare: String = _bare(source)
	var fields: PackedStringArray = PackedStringArray()
	var constants: PackedStringArray = PackedStringArray()
	var collections: PackedStringArray = PackedStringArray()
	for line: String in bare.split("\n"):
		if line.begins_with("var "):
			fields.append(line.substr(4).get_slice(":", 0))
			if line.contains("Array") or line.contains("Dictionary") or line.contains("Packed") or line.contains("RiftRunBuild"):
				collections.append(line)
		elif line.begins_with("const "):
			constants.append(line.substr(6).get_slice(":", 0))
	var functions: PackedStringArray = _declared_functions(source)
	var inherited: PackedStringArray = PackedStringArray()
	for path: String in [I2_SCRIPT, H9_SCRIPT, CORE_LOOP_SCRIPT, SLICE_SCRIPT]:
		inherited.append_array(_declared_functions(FileAccess.get_file_as_string(path)))
	var overrides: PackedStringArray = PackedStringArray()
	for name: String in functions:
		if inherited.has(name):
			overrides.append(name)
	overrides.sort()
	var public: PackedStringArray = PackedStringArray()
	for name: String in functions:
		if not name.begins_with("_"):
			public.append(name)
	_expect(", ".join(fields) == EXPECTED_FIELDS and ", ".join(constants) == EXPECTED_CONSTANTS and collections.is_empty()
			and ", ".join(functions) == EXPECTED_FUNCTIONS and overrides == PackedStringArray(EXPECTED_OVERRIDES)
			and ", ".join(public) == "choose_offered_lane, live_receipt_for, live_receipt_text, live_receipt_control",
		"the review declares fields %s, constants %s, functions %s (overrides %s, collections %s)" % [", ".join(fields),
			", ".join(constants), ", ".join(functions), ", ".join(overrides), ", ".join(collections)])
	var refresh: String = _function_body(bare, "_refresh_receipt")
	var apply_body: String = _function_body(bare, "_apply_expedition_build")
	var restore_body: String = _function_body(bare, "_restore_baselines")
	_expect(refresh.contains("super()") and refresh.contains("level_up_panel.is_open")
			and refresh.contains("_receipt_live.visible = not standing and") and bare.count("_receipt_live.visible") == 1
			and bare.count("RiftBuildApplication.apply(") == 2 and apply_body.count("RiftBuildApplication.apply(") == 1
			and restore_body.count("RiftBuildApplication.apply(RiftRunBuild.new()") == 1
			and bare.count("run_build()") == 1 and apply_body.count("mote_runtime.run_build()") == 1
			and not apply_body.contains("last_choice_record") and not apply_body.contains("receipt_text(")
			and not apply_body.contains("lane") and _function_body(bare, "choose_offered_lane").count("_apply_expedition_build()") == 1,
		"the receipt does not follow the standing offer, or the application reads something beside the run's whole build")
	var writers: PackedStringArray = PackedStringArray()
	for path: String in CHAIN_FILES:
		var code: String = _bare(FileAccess.get_file_as_string(path))
		for token: String in LIVE_WRITE_TOKENS:
			if code.contains(token):
				writers.append("%s: %s" % [path.get_file(), token])
		if code.contains("max_speed =") and not (path == CORE_LOOP_SCRIPT and code.count("max_speed =") == 1
				and _function_body(code, "_spawn_player_in_hub").contains("player.max_speed = ACCEPTED_MAX_SPEED")):
			writers.append("%s: max_speed =" % path.get_file())
	var seam: String = _bare(FileAccess.get_file_as_string(SEAM_SCRIPT))
	var concrete: PackedStringArray = PackedStringArray()
	for token: String in CONCRETE_TOKENS:
		if source.contains(token) or FileAccess.get_file_as_string(REVIEW_SCENE).contains(token):
			concrete.append(token)
	var decimals: RegExMatch = RegEx.create_from_string("[0-9]+\\.[0-9]+").search(bare)
	_expect(writers.is_empty() and seam.count("set_increased_attack_speed(") == 1
			and seam.count("player.max_speed = result.movement_speed") == 1 and seam.count("live.reach = result.reach") == 1
			and concrete.is_empty() and decimals == null,
		"a covered live value is written outside the seam (%s), or the review names %s" % [", ".join(writers), ", ".join(concrete)])
	print("  the review declares %d fields, %d constants and %d functions — the accepted ones, no field for a chained offer, a queue, a build, a lane, an identity or a seed, and no new public method"
		% [fields.size(), constants.size(), functions.size()])
	print("  %d overrides (%s); _refresh_receipt hides the live line while the level-up panel is open; the build is applied through RiftBuildApplication twice — after a choice from mote_runtime.run_build(), and to restore from an empty build"
		% [overrides.size(), ", ".join(overrides)])
	print("  of the %d files the running review is made of, none writes reach, arc, cone or Skill Speed, and only the core loop's spawn sets the accepted movement baseline; the seam writes them; 0 of %d concrete tokens and no decimal value in the review or its scene"
		% [CHAIN_FILES.size(), CONCRETE_TOKENS.size()])
	_done("the_review_adds_no_state_and_keeps_one_application_seam")


func _check_the_accepted_mechanisms_are_byte_identical() -> void:
	print("")
	print("--- 3. I11, the modal contract, H9, the core loop, the seam, the catalogues, H8, G1, G2, G4, both scenes, the teaser and project.godot are byte-identical")
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in UNCHANGED_HASHES:
		var digest: String = FileAccess.get_sha256(String(row[0]))
		if not digest.begins_with(String(row[1])):
			moved.append("%s %s" % [String(row[0]).get_file(), digest.substr(0, 8)])
	var changed: String = FileAccess.get_sha256(CHANGED_FILE)
	_expect(moved.is_empty() and UNCHANGED_HASHES.size() == 36 and changed.begins_with(CHANGED_PREFIX),
		"moved: %s; the review hashes %s" % [", ".join(moved), changed.substr(0, 8)])
	print("  %d accepted files match the SHA-256 prefixes they held before the first I12 edit, but for the four I13 moved (D-318), three of them moved again by I14 (D-320), the panel and the modal contract J1 moved (D-322), and the player J2 moved once more (D-324); the one edited file, %s, is at its D-320 hash %s"
		% [UNCHANGED_HASHES.size(), CHANGED_FILE.get_file(), CHANGED_PREFIX])
	_done("the_accepted_mechanisms_are_byte_identical")


func _check_the_catalogue_and_seam_boundaries_are_the_accepted_ones() -> void:
	print("")
	print("--- 4. I4's rank-one and rank-two values are the catalogue's; Global Damage (D-318) and Maximum Life (D-320) are live; Experience Gain and Pickup Radius stay the run's")
	var reaching_one: Dictionary = SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, REACHING_EDGE, 1)
	var reaching_two: Dictionary = SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, REACHING_EDGE, 2)
	var sweeping_one: Dictionary = SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, SWEEPING_EDGE, 1)
	var sweeping_two: Dictionary = SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, SWEEPING_EDGE, 2)
	_expect(reaching_one == {&"reach": 2.65} and reaching_two == {&"reach": 3.65}
			and sweeping_one == {&"release_arc_degrees": 180.0, &"soft_target_cone_degrees": 110.0}
			and sweeping_two == {&"release_arc_degrees": 260.0, &"soft_target_cone_degrees": 155.0}
			and SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, REACHING_EDGE, 3).is_empty()
			and SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, SWEEPING_EDGE, 3).is_empty()
			and SkillSupportCatalogue.support_maximum_rank(REACHING_EDGE) == MAXIMUM_RANK
			and SkillSupportCatalogue.support_maximum_rank(SWEEPING_EDGE) == MAXIMUM_RANK,
		"the catalogue answers %s / %s / %s / %s" % [str(reaching_one), str(reaching_two), str(sweeping_one), str(sweeping_two)])
	var covered: String = _joined(RiftBuildApplication.covered_stats())
	var run_path: String = _joined(RiftBuildApplication.run_path_stats())
	var deferred: String = _joined(RiftBuildApplication.deferred_stats())
	## Roguelite I13 (D-318) moved Global Damage one for one from the held list to the covered one, and
	## Roguelite I14 (D-320) Maximum Life, the last: the held list is now empty.
	_expect(covered == _joined([PlayerStats.GLOBAL_DAMAGE, PlayerStats.SKILL_SPEED, PlayerStats.MAXIMUM_LIFE, PlayerStats.MOVEMENT_SPEED])
			and run_path == _joined([PlayerStats.EXPERIENCE_GAIN, PlayerStats.PICKUP_RADIUS])
			and deferred.is_empty()
			and _joined(RiftBuildApplication.covered_quantities()) == _joined([SkillSupportCatalogue.STRIKE_REACH,
				SkillSupportCatalogue.STRIKE_RELEASE_ARC_DEGREES, SkillSupportCatalogue.STRIKE_SOFT_TARGET_CONE_DEGREES]),
		"the seam covers %s, leaves %s to the run and holds %s" % [covered, run_path, deferred])
	print("  reaching_edge: rank 1 %s, rank 2 %s; sweeping_edge: rank 1 %s, rank 2 %s; nothing at rank 3; maximum rank %d for both"
		% [str(reaching_one), str(reaching_two), str(sweeping_one), str(sweeping_two), MAXIMUM_RANK])
	print("  the seam makes [%s] live, leaves [%s] to the run's own mote path and holds [%s] without applying them"
		% [covered, run_path, deferred])
	_done("the_catalogue_and_seam_boundaries_are_the_accepted_ones")


# --- Expedition A ------------------------------------------------------------------------------

func _expedition_a() -> void:
	await _begin_expedition("A")
	_baseline = _live_values()
	await _check_level_one_opens_on_its_own_from_real_motes()
	_standing.append(_standing_snapshot("Level 1, opened on its own", 1))
	var escort: PrototypeGraveblade = review.room_enemies[2][1]

	## Level 1, Support: the run keeps 0 against Level 2's 125, so the panel closes.
	_take_support(0)
	await _resume_reading(escort, "after Level 1")

	## Level 2: exactly 125, opened by the review on its own tick.
	await _award_and_wait([REQUIREMENTS[1]], 2)
	_standing.append(_standing_snapshot("Level 2, opened on its own", 2))
	_take_support(1)
	await _resume_reading(escort, "after Level 2")

	## Level 3: 525 banked (150 + 175 + 200), so Levels 3, 4 and 5 are owed one after another.
	await _award_and_wait([REQUIREMENTS[2], REQUIREMENTS[3], REQUIREMENTS[4]], 3)
	_standing.append(_standing_snapshot("Level 3, opened on its own with 525 banked", 3))
	_held_world = _frozen(escort)

	## Level 3, Support: Reaching Edge rank 1 -> 2, and Level 4's offer takes its place.
	_take_support(2)
	_frozen_readings.append(_frozen(escort))
	_check_a_refused_lane_during_the_chain_changes_nothing()
	_frozen_readings.append(_frozen(escort))
	await _hold()
	_standing.append(_standing_snapshot("Level 4, after 30 physics and 10 idle frames held", 4))
	_frozen_readings.append(_frozen(escort))

	## Level 4, Support: Sweeping Edge rank 1 -> 2, and Level 5's fallback offer takes its place.
	_take_support(3)
	_frozen_readings.append(_frozen(escort))
	await _hold()
	_standing.append(_standing_snapshot("Level 5 fallback, after 30 physics and 10 idle frames held", 5))
	_frozen_readings.append(_frozen(escort))
	await _capture("01_fallback_offer_after_rank_two")
	_panel_line = await _measure_panel("the fallback offer standing")
	_check_the_cumulative_values_stand_behind_the_fallback_offer()

	## Level 5, Support: the passive fallback, Power; nothing further is owed, so the panel closes.
	_take_support(4)
	var paused_at: Vector3 = escort.global_position
	var sweeps: int = review.sweeps_made
	var ticks: int = _probe_count("ticks")
	await _settle(8)
	_after_power = {
		"moved": _planar_gap(escort.global_position, paused_at), "sweeps": review.sweeps_made - sweeps,
		"ticks": _probe_count("ticks") - ticks, "alive": escort.is_alive(), "ai": escort.ai_enabled,
	}
	_check_the_world_stays_held_across_both_chained_offers()
	_check_the_fallback_holds_power_changes_no_rank_and_consumes_its_root_once()
	## The world is quieted only now, after it has been seen running again.
	_quiet_room(2)
	await _capture("02_level_six_live_and_held_receipt", 1.2)
	_receipt_line = await _measure_receipt()
	_check_the_final_receipt_lists_the_damage_under_live_now()

	await _check_the_real_strike_reaches_three_point_two_metres_on_the_accepted_timing()
	await _check_the_real_strike_hits_one_hundred_and_ten_degrees_off_its_facing()
	await _check_two_eligible_targets_still_make_one_hit()
	await _check_movement_stays_at_its_baseline_and_power_adds_c1s_damage()


func _check_level_one_opens_on_its_own_from_real_motes() -> void:
	print("")
	print("--- 5. The route's real motes reach 75 and ask nothing; one more real mote reaches exactly 100 and Level 1's offer opens on its own")
	var steps: PackedStringArray = PackedStringArray()
	var early: int = 0
	for index: int in [0, 1]:
		_quiet_room(index)
		var centre: Vector3 = _rounded(review.room_modules[index].room_centres()[0])
		_stand(centre)
		for enemy: PrototypeGraveblade in review.room_enemies[index]:
			enemy.place_at(centre)
			_kill(enemy)
			await _settle(3)
			steps.append(_whole(review.mote_runtime.experience()))
			if review.offer_open_calls != 0 or review.level_up_panel.is_open or paused:
				early += 1
		await _walk_into_gate(review.room_modules[index].exit_point())
	## STAGED: the Elite stays quiet and out of the way; the escort pursues, the world's witness.
	var centre: Vector3 = _elite_hall_centre()
	var forward: Vector3 = _forward()
	var lateral: Vector3 = forward.rotated(Vector3.UP, PI * 0.5)
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	elite.set_ai_enabled(false)
	elite.place_at(centre - forward * 7.0 + lateral * 3.0)
	escort.place_at(centre - forward * 7.0 - lateral * 3.0)
	escort.set_ai_enabled(true)
	_stand_facing(centre, forward)
	var in_hall: bool = (review.run_state.current_room_index == 2 and review.mote_runtime.experience() == 75.0
		and review.offer_open_calls == 0 and not review.level_up_panel.is_open)
	var notices: int = _probe_count("paused_notices")
	var awarded: bool = _award([REVIEW_AMOUNT])
	var asked_by_award: bool = review.offer_open_calls == 0
	await _settle(3)
	var g1: RiftLevelRequirementReading = RiftLevelRequirementCurve.requirement_for(1)
	var g2: RiftLevelOfferSeedReading = RiftLevelOfferSeedDerivation.offer_root_seed_for(ROUTE_SEED, 1)
	_expect(steps == PackedStringArray(["25", "50", "75"]) and early == 0 and in_hall and awarded and asked_by_award,
		"the route read %s with %d early opening(s); in the hall %s; awarded %s" % [", ".join(steps), early, str(in_hall), str(awarded)])
	_expect(review.offer_open_calls == 1 and review.offer_attempted_level() == 1 and review.level_up_panel.is_open and paused
			and review.mote_runtime.level() == 1 and review.mote_runtime.experience() == REQUIREMENTS[0]
			and g1.ok and g1.experience_requirement() == REQUIREMENTS[0]
			and review.mote_runtime.frozen_offer_requirement() == REQUIREMENTS[0]
			and g2.offer_root_seed == ROOTS[0] and review.mote_runtime.offer_root_seed() == g2.offer_root_seed
			and _offer_line() == _expected_offer(0) and _probe_count("paused_notices") == notices + 1
			and review.applications_made == 0 and review.last_application == null
			and escort.is_alive() and escort.ai_enabled and elite.is_alive() and review.level_up_panel.note_text() == PANEL_NOTE,
		"Level 1 did not open on its own at exactly 100: %s / %s" % [_offer_line(), _state()])
	_openings.append("Level 1: %s" % _offer_line())
	print("  the route's real motes: experience %s through the review's own sweep, 0 openings asked; one fixture mote of 25 by one explicit H8 sweep" % " -> ".join(steps))
	print("  100 = G1's Level 1 requirement; the review asked 1 opening on its own tick, the panel opened and the probe was paused once; root seed %d = G2's; %s"
		% [g2.offer_root_seed, _offer_line()])
	print("  the panel states I3's note: %s" % review.level_up_panel.note_text())
	_done("level_one_opens_on_its_own_from_real_motes")


## One more level's experience through real motes, then the review's own opening on its tick.
func _award_and_wait(amounts: Array, level: int) -> void:
	var calls: int = review.offer_open_calls
	var awarded: bool = _award(amounts)
	var asked_by_award: bool = review.offer_open_calls == calls
	await _settle(3)
	var g1: RiftLevelRequirementReading = RiftLevelRequirementCurve.requirement_for(level)
	var g2: RiftLevelOfferSeedReading = RiftLevelOfferSeedDerivation.offer_root_seed_for(ROUTE_SEED, level)
	_expect_quiet(awarded and asked_by_award and review.offer_open_calls == calls + 1
			and review.offer_attempted_level() == level and review.level_up_panel.is_open and paused
			and review.mote_runtime.level() == level and g1.ok and g1.experience_requirement() == REQUIREMENTS[level - 1]
			and g2.offer_root_seed == ROOTS[level - 1] and review.mote_runtime.offer_root_seed() == g2.offer_root_seed
			and _offer_line() == _expected_offer(level - 1),
		"Level %d did not open on its own: %s / %s" % [level, _offer_line(), _state()])
	_openings.append("Level %d: %s" % [level, _offer_line()])


## After a choice that closed the panel: play runs again — the escort moves and the sweep runs.
func _resume_reading(escort: PrototypeGraveblade, label: String) -> void:
	var at: Vector3 = escort.global_position
	var sweeps: int = review.sweeps_made
	await _settle(4)
	_resumed.append({"label": label, "moved": _planar_gap(escort.global_position, at), "sweeps": review.sweeps_made - sweeps,
		"paused": paused})


## 30 physics and 10 idle frames while the world is held.
func _hold() -> void:
	await _settle(30)
	await _await_process_frames(10)


# --- Taking a card ---------------------------------------------------------------------------------

## One choice, pushed as ONE Enter press on the focused Support card and read in that press's own
## call stack — before any frame can pass — then released. Everything a choice is judged by is
## kept for the checks.
func _take_support(step: int) -> Dictionary:
	var panel: RiftLevelUpOfferPanel = review.level_up_panel
	var before: Dictionary = _moment()
	before["focused"] = root.gui_get_focus_owner() == panel.card_buttons()[SUPPORT]
	var build_before: RiftRunBuild = review.mote_runtime.run_build()
	_push_key(KEY_ENTER, true)
	var taken: Dictionary = _moment()
	taken["before"] = before
	taken["step"] = step
	taken["record"] = review.last_choice_record
	taken["application"] = review.last_application
	taken["derived"] = RiftBuildApplication.derive(review.mote_runtime.run_build(), review.player, ACCEPTED_MAX_SPEED)
	taken["build_before"] = build_before
	taken["build"] = review.mote_runtime.run_build()
	taken["offer"] = _offer_line()
	taken["focus_first"] = panel.is_open and root.gui_get_focus_owner() == panel.card_buttons()[SUPPORT]
	taken["receipt_choice"] = review.receipt_text("choice")
	taken["receipt_secondary"] = review.receipt_text("progression")
	taken["receipt_level"] = review.receipt_text("level")
	taken["retake"] = ""
	if panel.is_open:
		taken["cards"] = _shown_cards()
		var snapshot: Dictionary = _standing_snapshot("Level %d, in place of Level %d's in the same call" % [step + 2, step + 1], step + 2)
		taken["snapshot"] = snapshot
		_standing.append(snapshot)
	else:
		## Taking the same lane again through H8 after the panel closed: nothing stands to take.
		var again: RiftRunLevelUpResult = review.mote_runtime.choose_level_up_lane(SUPPORT)
		taken["retake"] = "succeeded" if again.succeeded() else again.failure_reason()
	_push_key(KEY_ENTER, false)
	taken["choices_after_release"] = review.choices_taken
	_steps.append(taken)
	return taken


## Everything a moment is judged by, read at one instant.
func _moment() -> Dictionary:
	var panel: RiftLevelUpOfferPanel = review.level_up_panel
	var runtime: RiftMoteRuntime = review.mote_runtime
	var active: bool = runtime != null and runtime.is_offer_active()
	return {
		"physics": Engine.get_physics_frames(), "process": Engine.get_process_frames(),
		"open": panel.is_open, "paused": paused, "active": active,
		"level": runtime.level() if runtime != null else 0,
		"experience": runtime.experience() if runtime != null else 0.0,
		"root": runtime.offer_root_seed() if active else -1,
		"calls": review.offer_open_calls, "attempted_level": review.offer_attempted_level(),
		"choices": review.choices_taken, "attempts": review.choice_attempts, "choice_refusals": review.choice_refusals,
		"applications": review.applications_made, "application_refusals": review.application_refusals,
		"applied_physics": review.last_application_physics_frame, "applied_process": review.last_application_process_frame,
		"opens": panel.opens, "closes": panel.closes, "replacements": panel.replacements,
		"unpaused": _probe_count("unpaused"), "ticks": _probe_count("ticks"), "sweeps": review.sweeps_made,
		"receipt": _receipt_lines(), "live_shown": review.live_receipt_control().is_visible_in_tree(),
		"live_line": review.live_receipt_text(), "live": _live_values(),
		"hud_level": _hud_text(HUD_LEVEL), "hud_experience": _hud_text(HUD_EXPERIENCE),
		"refusal": panel.refusal_text(),
	}


## What is on screen behind a standing offer, and what the review holds behind it.
func _standing_snapshot(label: String, level: int) -> Dictionary:
	var stale: PackedStringArray = PackedStringArray()
	for text: String in _visible_review_texts():
		for marker: String in STALE_MARKERS:
			if text.contains(marker):
				stale.append("'%s' in '%s'" % [marker, text])
	return {
		"label": label, "level": level, "open": review.level_up_panel.is_open, "paused": paused,
		"receipt": _receipt_lines(), "live_shown": review.live_receipt_control().is_visible_in_tree(),
		"stale": stale, "modals": _open_modals(),
		"had_receipt": not review.receipt_text("choice").is_empty(),
		"had_live": not review.live_receipt_text().is_empty(),
		"hud": [_hud_text(HUD_LEVEL), _hud_text(HUD_EXPERIENCE)],
		"hud_shown": _hud_visible(HUD_LEVEL) and _hud_visible(HUD_EXPERIENCE),
		"titles": _titles(), "note": review.level_up_panel.note_text(),
	}


# --- 6–9. Read over every choice and every standing moment -----------------------------------------

const STANDING_HUD: Array = [
	["Rift level 1", "XP 100 / 100"], ["Rift level 2", "XP 125 / 125"], ["Rift level 3", "XP 525 / 150"],
	["Rift level 4", "XP 375 / 175"], ["Rift level 4", "XP 375 / 175"], ["Rift level 4", "XP 375 / 175"],
	["Rift level 5", "XP 200 / 200"], ["Rift level 5", "XP 200 / 200"],
]


func _check_every_standing_offer_hides_both_receipts() -> void:
	print("")
	print("--- 6. While any offer stands — opened on its own, taking a chosen one's place, after a refusal or after held frames — no receipt and no live line shows")
	var faults: PackedStringArray = PackedStringArray()
	var behind: int = 0
	for index: int in _standing.size():
		var snap: Dictionary = _standing[index]
		var level: int = int(snap["level"])
		if not (bool(snap["open"]) and bool(snap["paused"]) and snap["receipt"] == PackedStringArray(STANDING_LINES)
				and not bool(snap["live_shown"]) and (snap["stale"] as PackedStringArray).is_empty()
				and snap["modals"] == PackedStringArray(["LevelUpOfferPanel"]) and bool(snap["hud_shown"])
				and snap["hud"] == STANDING_HUD[index] and snap["titles"] == PackedStringArray(OFFER_TITLES[level - 1])
				and String(snap["note"]) == PANEL_NOTE):
			faults.append("%s: %s" % [snap["label"], str(snap)])
		if bool(snap["had_receipt"]) and bool(snap["had_live"]):
			behind += 1
	_expect(_standing.size() == 8 and faults.is_empty(), "%d standing moments; %s" % [_standing.size(), "; ".join(faults)])
	## The fix is what hides them: at every standing moment after the first, a completed receipt and a
	## live line were held, and I3's accepted receipt rule, before D-316, would have shown the line.
	_expect(behind == 7 and not bool(_standing[0]["had_receipt"]),
		"%d of %d standing moments held both a completed receipt and a live line" % [behind, _standing.size()])
	for snap: Dictionary in _standing:
		print("  %s: '%s' / '%s' behind the three cards %s; the receipt shows only '%s'; no live line, no stale receipt text; the level-up panel the only open modal"
			% [snap["label"], snap["hud"][0], snap["hud"][1], " / ".join(snap["titles"]), (snap["receipt"] as PackedStringArray)[1]])
	print("  %d of %d standing moments held both a completed receipt and a live line — hidden, not cleared" % [behind, _standing.size()])
	_done("every_standing_offer_hides_both_receipts")


func _check_each_successful_choice_applies_the_whole_build_in_its_own_call() -> void:
	print("")
	print("--- 7. Each successful choice makes the run's whole build live in that input's own call: no physics or process frame between the choice and the live values")
	var faults: PackedStringArray = PackedStringArray()
	var lines: PackedStringArray = PackedStringArray()
	for taken: Dictionary in _steps:
		var step: int = int(taken["step"])
		var before: Dictionary = taken["before"]
		var application: RiftBuildApplicationResult = taken["application"]
		var derived: RiftBuildApplicationResult = taken["derived"]
		var record: RiftRunLevelUpResult = taken["record"]
		var receipt: RiftLevelUpResult = null if record == null else record.level_up()
		var same_frame: bool = (int(taken["physics"]) == int(before["physics"]) and int(taken["process"]) == int(before["process"])
			and int(taken["applied_physics"]) == int(before["physics"]) and int(taken["applied_process"]) == int(before["process"]))
		var whole: bool = (application != null and application.ok and application.committed and application.problem().is_empty()
			and derived.ok and not derived.committed
			and application.describe().replace("; committed", "") == derived.describe().replace("; derived only", ""))
		var g2: RiftLevelOfferSeedReading = RiftLevelOfferSeedDerivation.offer_root_seed_for(ROUTE_SEED, step + 1)
		if not (same_frame and whole and bool(before["focused"])
				and int(taken["applications"]) == int(before["applications"]) + 1 and int(taken["application_refusals"]) == 0
				and int(taken["choices"]) == int(before["choices"]) + 1 and int(taken["attempts"]) == int(before["attempts"]) + 1
				and int(taken["choices_after_release"]) == int(taken["choices"])
				and record != null and receipt != null and record.succeeded() and record.problem().is_empty()
				and record.run_seed == ROUTE_SEED and record.source_level == step + 1 and receipt.lane == SUPPORT
				and receipt.root_seed_known and receipt.root_seed == ROOTS[step] and receipt.root_seed == g2.offer_root_seed
				and int(taken["level"]) == step + 2 and float(taken["experience"]) == STEP_KEPT[step]):
			faults.append("step %d: same frame %s, whole %s, %s" % [step + 1, str(same_frame), str(whole), str(taken)])
		lines.append("Level %d -> %d from root %d: applied on physics frame %d and process frame %d — the input's own; applications %d -> %d; %s"
			% [step + 1, step + 2, 0 if receipt == null else receipt.root_seed, int(taken["applied_physics"]), int(taken["applied_process"]),
				int(before["applications"]), int(taken["applications"]),
				"the next offer took its place" if STEP_CHAINED[step] else "the panel closed and play resumed"])
	_expect(_steps.size() == 5 and faults.is_empty(), "%d choices; %s" % [_steps.size(), "; ".join(faults)])
	for line: String in lines:
		print("  %s" % line)
	print("  each application equals the seam's own derivation of a fresh copy of the run's whole build, and none was refused")
	_done("each_successful_choice_applies_the_whole_build_in_its_own_call")


func _check_the_live_values_accumulate_choice_by_choice() -> void:
	print("")
	print("--- 8. After every choice the character holds the whole accumulated build: exactly the catalogue's value for each rank held, and nothing else moved")
	var faults: PackedStringArray = PackedStringArray()
	var lines: PackedStringArray = PackedStringArray()
	for taken: Dictionary in _steps:
		var step: int = int(taken["step"])
		var live: Dictionary = taken["live"]
		var build: RiftRunBuild = taken["build"]
		var application: RiftBuildApplicationResult = taken["application"]
		var receipt: RiftLevelUpResult = (taken["record"] as RiftRunLevelUpResult).level_up()
		var supports: PackedStringArray = PackedStringArray() if application == null else application.supports_applied.duplicate()
		supports.sort()
		var ranks_ok: bool = step == 4 or (receipt.support_rank_before == STEP_RANKS_BEFORE[step]
			and receipt.support_rank_after == STEP_RANKS_AFTER[step])
		if not (float(live["reach"]) == STEP_REACH[step] and float(live["arc"]) == STEP_ARC[step]
				and float(live["cone"]) == STEP_CONE[step] and int(live["targets"]) == 1
				and float(live["max_speed"]) == ACCEPTED_MAX_SPEED and float(live["increased"]) == 0.0
				and float(live["effective"]) == ACCEPTED_ACTION_TIME and float(live["action_time"]) == ACCEPTED_ACTION_TIME
				and float(live["weapon_damage"]) == float(_baseline["weapon_damage"])
				and float(live["max_life"]) == float(_baseline["max_life"])
				and float(live["margin"]) == float(_baseline["margin"]) and float(live["mana_cost"]) == float(_baseline["mana_cost"])
				and build.support_rank_for(QUICK_STRIKE, REACHING_EDGE) == STEP_REACHING_RANK[step]
				and build.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE) == STEP_SWEEPING_RANK[step]
				and ", ".join(supports) == STEP_SUPPORTS[step] and ranks_ok
				and String(taken["live_line"]) == STEP_LIVE[step] and String(taken["receipt_choice"]) == STEP_CHOICES[step]
				and String(taken["receipt_secondary"]) == STEP_SECONDARY[step]
				and String(taken["receipt_level"]) == STEP_LEVEL_LINES[step]
				and String(taken["hud_level"]) == STEP_HUD[step][0] and String(taken["hud_experience"]) == STEP_HUD[step][1]):
			faults.append("step %d: %s / '%s' / [%s]" % [step + 1, str(live), taken["live_line"], ", ".join(supports)])
		lines.append("%s: reach %.2f m, arc %.0f°, cone %.0f°, %d target, %.1f m/s, %.2f s; %s; '%s'"
			% [STEP_CHOICES[step], float(live["reach"]), float(live["arc"]), float(live["cone"]), int(live["targets"]),
				float(live["max_speed"]), float(live["effective"]), STEP_SECONDARY[step], String(taken["live_line"]).replace("\n", " / ")])
	_expect(_steps.size() == 5 and faults.is_empty(), "; ".join(faults))
	for line: String in lines:
		print("  %s" % line)
	_done("the_live_values_accumulate_choice_by_choice")


func _check_a_chained_offer_takes_the_panel_with_the_values_already_live() -> void:
	print("")
	print("--- 9. When a choice leaves the next level owed, that level's offer takes the panel in the same call — the world still held, the new values already live, both receipts hidden")
	var faults: PackedStringArray = PackedStringArray()
	var lines: PackedStringArray = PackedStringArray()
	var chained: int = 0
	for taken: Dictionary in _steps:
		var step: int = int(taken["step"])
		if not STEP_CHAINED[step]:
			continue
		chained += 1
		var before: Dictionary = taken["before"]
		var live: Dictionary = taken["live"]
		if not (bool(taken["open"]) and bool(taken["paused"]) and bool(taken["active"])
				and int(taken["replacements"]) == int(before["replacements"]) + 1 and int(taken["opens"]) == int(before["opens"])
				and int(taken["closes"]) == int(before["closes"]) and int(taken["unpaused"]) == int(before["unpaused"])
				and int(taken["ticks"]) == int(before["ticks"]) and int(taken["sweeps"]) == int(before["sweeps"])
				and int(taken["calls"]) == int(before["calls"]) + 1 and int(taken["attempted_level"]) == step + 2
				and int(taken["root"]) == ROOTS[step + 1] and String(taken["offer"]) == _expected_offer(step + 1)
				and bool(taken["focus_first"]) and String(taken["refusal"]).is_empty()
				and taken["receipt"] == PackedStringArray(STANDING_LINES) and not bool(taken["live_shown"])
				and float(live["reach"]) == STEP_REACH[step] and float(live["arc"]) == STEP_ARC[step]):
			faults.append("step %d: %s" % [step + 1, str(taken)])
		lines.append("Level %d -> %d: the panel stayed open (opens %d, closes %d, replacements %d -> %d); 0 probe ticks and 0 unpause notices; Level %d's offer from root %d, card 1 focused; reach %.2f m, arc %.0f°, cone %.0f° already live; receipt and live line hidden"
			% [step + 1, step + 2, int(taken["opens"]), int(taken["closes"]), int(before["replacements"]), int(taken["replacements"]),
				step + 2, int(taken["root"]), float(live["reach"]), float(live["arc"]), float(live["cone"])])
	var fallback: Dictionary = _steps[3] if _steps.size() > 3 else {}
	_expect(chained == 2 and faults.is_empty() and fallback.get("cards", []) == FALLBACK_CARDS,
		"%d chained; %s; the fallback cards read %s" % [chained, "; ".join(faults), str(fallback.get("cards", []))])
	for line: String in lines:
		print("  %s" % line)
	var rows: PackedStringArray = PackedStringArray()
	for card: Variant in fallback.get("cards", []):
		rows.append("%s: %s — %s" % [card[0], card[1], card[2]])
	print("  the fallback offer reads, word for word as I10 accepted it: %s" % "; ".join(rows))
	_done("a_chained_offer_takes_the_panel_with_the_values_already_live")


# --- 10–14. The chain, the fallback and the final receipt ----------------------------------------

func _check_a_refused_lane_during_the_chain_changes_nothing() -> void:
	print("")
	print("--- 10. A refused lane during the chain keeps the identical offer, the pause and both receipts hidden, and applies nothing")
	var before: Dictionary = _moment()
	var offer: String = _offer_line()
	var cards: Array = _shown_cards()
	var application: RiftBuildApplicationResult = review.last_application
	## STAGED: no card can produce an undeclared lane, so the card entry point is handed one.
	review.choose_offered_lane(7)
	var record: RiftRunLevelUpResult = review.last_choice_record
	var reason: String = "" if record == null else record.failure_reason()
	var after: Dictionary = _moment()
	_standing.append(_standing_snapshot("Level 4, after a refused lane", 4))
	_expect(record != null and not record.succeeded() and reason.begins_with("lane 7 is not one of the offer's lanes")
			and review.level_up_panel.refusal_text() == REFUSAL_PREFIX + reason,
		"lane 7 answered '%s' and the panel shows '%s'" % [reason, review.level_up_panel.refusal_text()])
	_expect(bool(after["open"]) and bool(after["paused"]) and _offer_line() == offer and _shown_cards() == cards
			and int(after["choices"]) == int(before["choices"]) and int(after["choice_refusals"]) == int(before["choice_refusals"]) + 1
			and int(after["applications"]) == int(before["applications"]) and int(after["application_refusals"]) == 0
			and review.last_application == application and after["live"] == before["live"]
			and after["receipt"] == PackedStringArray(STANDING_LINES) and not bool(after["live_shown"])
			and int(after["level"]) == 4 and int(after["physics"]) == int(before["physics"])
			and int(after["unpaused"]) == int(before["unpaused"]),
		"the refusal moved something: %s -> %s" % [str(before), str(after)])
	print("  lane 7: '%s' — shown word for word; the same Level 4 offer, still open and paused; 0 applications, 0 application refusals, every live value unchanged; receipt and live line hidden" % reason)
	_done("a_refused_lane_during_the_chain_changes_nothing")


func _check_the_world_stays_held_across_both_chained_offers() -> void:
	print("")
	print("--- 11. From Level 3's opening to the fallback choice the world stands still; the one close lets it go")
	var faults: PackedStringArray = PackedStringArray()
	for reading: Dictionary in _frozen_readings:
		if reading != _held_world:
			faults.append(str(reading))
	var power: Dictionary = _steps[4] if _steps.size() > 4 else {}
	var power_before: Dictionary = power.get("before", {})
	_expect(_frozen_readings.size() == 5 and faults.is_empty() and bool(_held_world["enemy_alive"]) and bool(_held_world["enemy_ai"]),
		"the world moved across the chain: %s against %s" % ["; ".join(faults), str(_held_world)])
	_expect(int(power.get("unpaused", -1)) == int(_held_world["unpaused"]) + 1 and int(power_before.get("unpaused", -1)) == int(_held_world["unpaused"])
			and not bool(power.get("paused", true)) and float(_after_power["moved"]) > 0.0 and int(_after_power["sweeps"]) > 0
			and int(_after_power["ticks"]) > 0 and bool(_after_power["alive"]) and bool(_after_power["ai"])
			and _resumed.size() == 2 and float(_resumed[0]["moved"]) > 0.0 and int(_resumed[0]["sweeps"]) > 0
			and float(_resumed[1]["moved"]) > 0.0 and int(_resumed[1]["sweeps"]) > 0,
		"the close did not let the world go: %s / %s" % [str(_after_power), str(_resumed)])
	print("  the escort — alive, AI on, pursuing — and the player, the sweep, the motes, the attack and the probe: identical across both chained offers, the refused lane and 80 held frames (5 readings)")
	print("  the fallback choice sent the probe exactly 1 unpause notice; 8 frames later the escort had moved, the sweep had run and the probe had ticked; after Levels 1 and 2 the same")
	_done("the_world_stays_held_across_both_chained_offers")


func _check_the_cumulative_values_stand_behind_the_fallback_offer() -> void:
	print("")
	print("--- 12. Behind the standing fallback offer, both supports at rank 2: 5.0 m/s, 0.80 s, 3.65 m, 260°, 155°, one target — four applications, no refusal, the world held")
	var live: Dictionary = _live_values()
	var build: RiftRunBuild = review.mote_runtime.run_build()
	_expect(float(live["max_speed"]) == ACCEPTED_MAX_SPEED and float(live["action_time"]) == ACCEPTED_ACTION_TIME
			and float(live["effective"]) == ACCEPTED_ACTION_TIME and float(live["increased"]) == 0.0
			and float(live["reach"]) == 3.65 and float(live["arc"]) == 260.0 and float(live["cone"]) == 155.0
			and int(live["targets"]) == 1,
		"behind the fallback offer: %s" % str(live))
	_expect(build.support_rank_for(QUICK_STRIKE, REACHING_EDGE) == MAXIMUM_RANK
			and build.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE) == MAXIMUM_RANK and build.support_count() == 2
			and build.passive_acquisitions() == 0 and review.applications_made == 4 and review.application_refusals == 0
			and paused and review.level_up_panel.is_open and review.mote_runtime.level() == 5
			and review.mote_runtime.offer_support_content_kind() == 1 and _frozen(review.room_enemies[2][1]) == _held_world,
		"the build %s, %d applications, %d refusals, paused %s" % [build.describe(), review.applications_made,
			review.application_refusals, str(paused)])
	print("  movement %.1f m/s, action time %.2f s, reach %.2f m, arc %.0f°, cone %.0f°, %d target; reaching_edge %d / %d and sweeping_edge %d / %d; %d applications, %d refusals; paused"
		% [float(live["max_speed"]), float(live["effective"]), float(live["reach"]), float(live["arc"]), float(live["cone"]),
			int(live["targets"]), build.support_rank_for(QUICK_STRIKE, REACHING_EDGE), MAXIMUM_RANK,
			build.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE), MAXIMUM_RANK, review.applications_made, review.application_refusals])
	print("  %s" % _panel_line)
	_done("the_cumulative_values_stand_behind_the_fallback_offer")


func _check_the_fallback_holds_power_changes_no_rank_and_consumes_its_root_once() -> void:
	print("")
	print("--- 13. The fallback choice holds Power, changes no rank, consumes root 4,000,111 once, applies a fifth time and closes the panel at Level 6 with 0 XP")
	var taken: Dictionary = _steps[4]
	var record: RiftRunLevelUpResult = taken["record"]
	var receipt: RiftLevelUpResult = record.level_up()
	var before: RiftRunBuild = taken["build_before"]
	var after: RiftRunBuild = taken["build"]
	var application: RiftBuildApplicationResult = taken["application"]
	var g1: RiftLevelRequirementReading = RiftLevelRequirementCurve.requirement_for(6)
	var carrying: int = 0
	for step: Dictionary in _steps:
		var each: RiftRunLevelUpResult = step["record"]
		if each != null and each.level_up() != null and each.level_up().root_seed == ROOTS[4]:
			carrying += 1
	_expect(receipt.carries_support_fallback() and receipt.support_content_kind == 1 and receipt.support_fallback_category == 0
			and receipt.granted_identity() == PackedStringArray([String(POWER)]) and receipt.root_seed == ROOTS[4]
			and carrying == 1 and String(taken["retake"]) == NO_OFFER,
		"the fallback record %s; %d record(s) carry root %d; taking it again answered '%s'" % [receipt.describe(), carrying,
			ROOTS[4], taken["retake"]])
	_expect(before.acquisitions_for(POWER) == 0 and after.acquisitions_for(POWER) == 1 and after.passive_acquisitions() == 1
			and before.support_rank_for(QUICK_STRIKE, REACHING_EDGE) == MAXIMUM_RANK
			and after.support_rank_for(QUICK_STRIKE, REACHING_EDGE) == MAXIMUM_RANK
			and before.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE) == MAXIMUM_RANK
			and after.support_rank_for(QUICK_STRIKE, SWEEPING_EDGE) == MAXIMUM_RANK
			and before.total_support_ranks() == 4 and after.total_support_ranks() == 4 and after.support_count() == 2
			and is_equal_approx(after.total_for(PlayerStats.GLOBAL_DAMAGE), 0.10),
		"the fallback moved a rank or held Power otherwise: %s -> %s" % [before.describe(), after.describe()])
	## Roguelite I13 (D-318): Power's total is now live through the seam rather than held by it.
	_expect(int(taken["applications"]) == 5 and application != null and application.ok and application.committed
			and application.deferred_stats.is_empty() and application.run_path_stats.is_empty()
			and application.increased_global_damage == after.total_for(PlayerStats.GLOBAL_DAMAGE)
			and not bool(taken["open"]) and not bool(taken["paused"]) and not bool(taken["active"])
			and int(taken["level"]) == 6 and float(taken["experience"]) == 0.0 and g1.ok and g1.experience_requirement() == REQUIREMENTS[5]
			and String(taken["hud_level"]) == "Rift level 6" and String(taken["hud_experience"]) == "XP 0 / 225"
			and float((taken["live"] as Dictionary)["weapon_damage"]) == ACCEPTED_DAMAGE,
		"after the fallback: %s" % str(taken))
	print("  Support — Power, passive fallback from category 0, root %d: carried by exactly 1 of the 5 records; taking the lane again answered '%s'"
		% [receipt.root_seed, taken["retake"]])
	print("  card_power 0 -> 1; reaching_edge 2 -> 2, sweeping_edge 2 -> 2, total ranks 4 -> 4; Global Damage +%.0f%% held in the build and live through the seam; weapon damage %.0f raw"
		% [100.0 * after.total_for(PlayerStats.GLOBAL_DAMAGE), float((taken["live"] as Dictionary)["weapon_damage"])])
	print("  5 successful applications; the panel closed and play resumed; Rift level 6 with 0 XP against G1's 225")
	_done("the_fallback_holds_power_changes_no_rank_and_consumes_its_root_once")


func _check_the_final_receipt_lists_the_damage_under_live_now() -> void:
	print("")
	print("--- 14. The final receipt: the accepted fallback wording, and the whole live build — Power's damage included (D-318) — under \"Live now\", with no held heading left")
	var taken: Dictionary = _steps[4]
	var application: RiftBuildApplicationResult = taken["application"]
	var live_line: String = String(taken["live_line"])
	var composed: String = LIVE_PREFIX + "\n".join(application.applied_lines())
	var expected: PackedStringArray = PackedStringArray([RECEIPT_TITLE, STEP_CHOICES[4], STEP_SECONDARY[4], STEP_LEVEL_LINES[4],
		LIVE_FIVE, RECEIPT_LIVE_NOTE])
	_expect(taken["receipt"] == expected and bool(taken["live_shown"]) and _receipt_lines() == expected,
		"the final receipt reads %s" % str(taken["receipt"]))
	## Roguelite I13 (D-318) moved this assertion one for one: Power's total is live, so its
	## damage is the seam's second applied line, no card is named in it, and nothing is held.
	_expect(live_line == LIVE_FIVE and live_line == composed and live_line.count(LIVE_PREFIX) == 1 and live_line.begins_with(LIVE_PREFIX)
			and not live_line.contains(HELD_HEADING) and not live_line.contains("Global Damage") and not live_line.contains("Power")
			and application.held_lines().is_empty() and application.applied_lines().size() == 2
			and application.applied_lines()[1] == POWER_DAMAGE_LINE
			and RogueliteLiveEffectReview.LIVE_PREFIX == LIVE_PREFIX and RogueliteLiveEffectReview.HELD_HEADING == HELD_HEADING
			and RogueliteLiveEffectReview.RECEIPT_LIVE_NOTE == RECEIPT_LIVE_NOTE,
		"the live section reads '%s'" % live_line.replace("\n", " / "))
	for line: String in expected:
		print("  | %s" % line.replace("\n", " / "))
	print("  \"Live now —\" appears once and heads the seam's two applied lines; Power's damage reads '%s' — no card named, no held heading" % POWER_DAMAGE_LINE)
	print("  %s" % _receipt_line)
	_done("the_final_receipt_lists_the_damage_under_live_now")


# --- 15–18. The accumulated build in real play --------------------------------------------------------

func _check_the_real_strike_reaches_three_point_two_metres_on_the_accepted_timing() -> void:
	print("")
	print("--- 15. A real controller Quick Strike reaches a Graveblade 3.20 m ahead without stepping, releases on the accepted marker and finishes at 0.80 s")
	var centre: Vector3 = _elite_hall_centre()
	var forward: Vector3 = _forward()
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	escort.place_at(centre - forward * 7.0)
	elite.place_at(centre + forward * BETWEEN_REACHES)
	_stand_facing(centre, forward)
	await _settle(2)
	var live_query: Dictionary = _release_query(review.player.attack.data, [elite, escort])
	var base_query: Dictionary = _release_query(review.player.attack.canonical_data, [elite, escort])
	var life: float = elite.life
	_stand_facing(centre, forward)
	var swing: Dictionary = await _swing()
	_record_hit(life, elite.life)
	var dt: float = _dt()
	_expect(String(live_query.get("outcome", "")) == "hit" and live_query.get("target") == _area(elite)
			and String(base_query.get("outcome", "")) == "miss" and _rejected(base_query, elite) == "3.20 m is beyond the 1.65 m reach",
		"at 3.20 m the live record answered %s and the canonical %s ('%s')" % [live_query.get("outcome"), base_query.get("outcome"),
			_rejected(base_query, elite)])
	_expect(int(swing["began"]) == QuickStrikeAction.Phase.WINDUP and swing["target"] == _area(elite)
			and float(swing["moved"]) < 0.001 and int(swing["family"]) == InputFamilyTracker.Family.CONTROLLER
			and String((swing["outcome"] as Dictionary).get("outcome", "")) == "hit" and (swing["outcome"] as Dictionary).get("target") == _area(elite)
			and int(swing["queries"]) == 1 and int(swing["releases"]) == 1 and int(swing["damage"]) == 1
			and elite.life == life - _power_hit(),
		"the real press at 3.20 m began %d, moved %.3f m and answered %s for %.0f" % [int(swing["began"]), float(swing["moved"]),
			(swing["outcome"] as Dictionary).get("outcome"), life - elite.life])
	_expect(_ticks_match(int(swing["release"]), ACCEPTED_ACTION_TIME * ACCEPTED_MARKER) and _ticks_match(int(swing["finish"]), ACCEPTED_ACTION_TIME)
			and absf(float(swing["anim_release"]) - ACCEPTED_MARKER) < 0.0001
			and review.player.attack.effective_action_time() == ACCEPTED_ACTION_TIME and review.player.increased_attack_speed() == 0.0,
		"the press released at tick %d and finished at tick %d, the pose at %.4f" % [int(swing["release"]), int(swing["finish"]),
			float(swing["anim_release"])])
	print("  3.20 m ahead: the live record's release query %s; the canonical record's %s — '%s'" % [live_query.get("outcome"),
		base_query.get("outcome"), _rejected(base_query, elite)])
	print("  the real press began in its wind-up toward it without stepping and hit once — Life %.0f -> %.0f" % [life, elite.life])
	print("  the kernel times a %.3f s action at +0%% Skill Speed; at %d Hz the release fired on tick %d, the first at or after 0.80 s x 0.325, with the pose at %.4f, and READY returned on tick %d (%.4f s), inside the one-tick window after 0.80 s that I3's accepted suite reads"
		% [review.player.attack.effective_action_time(), Engine.physics_ticks_per_second, int(swing["release"]),
			float(swing["anim_release"]), int(swing["finish"]), int(swing["finish"]) * dt])
	_done("the_real_strike_reaches_three_point_two_metres_on_the_accepted_timing")


func _check_the_real_strike_hits_one_hundred_and_ten_degrees_off_its_facing() -> void:
	print("")
	print("--- 16. The real Quick Strike's release selects and hits a Graveblade 110° off its facing — outside the baseline 100° arc, inside rank two's 260°")
	var centre: Vector3 = _elite_hall_centre()
	var forward: Vector3 = _forward()
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	escort.place_at(centre - forward * 7.0)
	elite.place_at(centre + forward.rotated(Vector3.UP, deg_to_rad(WIDE_ANGLE)) * NEAR_TARGET)
	_stand_facing(centre, forward)
	await _settle(2)
	var live_query: Dictionary = _release_query(review.player.attack.data, [elite, escort])
	var base_query: Dictionary = _release_query(review.player.attack.canonical_data, [elite, escort])
	var life: float = elite.life
	_stand_facing(centre, forward)
	var swing: Dictionary = await _swing()
	_record_hit(life, elite.life)
	_expect(String(live_query.get("outcome", "")) == "hit" and live_query.get("target") == _area(elite)
			and String(base_query.get("outcome", "")) == "miss" and _rejected(base_query, elite) == "110 deg is outside the 100 deg release arc",
		"at 110° the live record answered %s and the canonical %s ('%s')" % [live_query.get("outcome"), base_query.get("outcome"),
			_rejected(base_query, elite)])
	_expect(int(swing["began"]) == QuickStrikeAction.Phase.WINDUP and swing["target"] == null
			and String(swing["acquisition"]).begins_with("no eligible target in the 155 deg cone")
			and String((swing["outcome"] as Dictionary).get("outcome", "")) == "hit" and (swing["outcome"] as Dictionary).get("target") == _area(elite)
			and int(swing["queries"]) == 1 and int(swing["damage"]) == 1 and elite.life == life - _power_hit(),
		"the real press at 110° answered %s ('%s') for %.0f" % [(swing["outcome"] as Dictionary).get("outcome"), swing["acquisition"],
			life - elite.life])
	print("  110° at %.2f m: the live record's release query %s; the canonical record's %s — '%s'" % [NEAR_TARGET, live_query.get("outcome"),
		base_query.get("outcome"), _rejected(base_query, elite)])
	print("  the real press swung along the facing — '%s' — and its one release selected it and hit: Life %.0f -> %.0f"
		% [swing["acquisition"], life, elite.life])
	_done("the_real_strike_hits_one_hundred_and_ten_degrees_off_its_facing")


func _check_two_eligible_targets_still_make_one_hit() -> void:
	print("")
	print("--- 17. Two Graveblades both inside rank two's reach and arc — 110° at 3.00 m and -110° at 3.40 m — take one real release and one hit")
	var centre: Vector3 = _elite_hall_centre()
	var forward: Vector3 = _forward()
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	elite.place_at(centre + forward.rotated(Vector3.UP, deg_to_rad(WIDE_ANGLE)) * PAIR_NEAR)
	escort.place_at(centre + forward.rotated(Vector3.UP, deg_to_rad(-WIDE_ANGLE)) * PAIR_FAR)
	_stand_facing(centre, forward)
	await _settle(2)
	var base_query: Dictionary = _release_query(review.player.attack.canonical_data, [elite, escort])
	var near_life: float = elite.life
	var far_life: float = escort.life
	_stand_facing(centre, forward)
	var swing: Dictionary = await _swing()
	_record_hit(near_life, elite.life)
	var outcome: Dictionary = swing["outcome"]
	var legal: int = 0
	for record: Dictionary in outcome.get("considered", []):
		if String(record.get("rejected", "")).is_empty():
			legal += 1
	_expect(String(base_query.get("outcome", "")) == "miss" and legal == 2 and String(outcome.get("outcome", "")) == "hit"
			and outcome.get("target") == _area(elite) and int(swing["releases"]) == 1 and int(swing["damage"]) == 1
			and elite.life == near_life - _power_hit() and escort.life == far_life
			and review.player.attack.data.maximum_targets == 1,
		"two legal targets: %d legal, %d damage event(s), near %.0f -> %.0f, far %.0f -> %.0f" % [legal, int(swing["damage"]),
			near_life, elite.life, far_life, escort.life])
	print("  the canonical record's query refused both; the live record's real release found %d legal targets, made 1 damage event on the nearer — %.0f -> %.0f — and left the other at %.0f; maximum targets %d"
		% [legal, near_life, elite.life, escort.life, review.player.attack.data.maximum_targets])
	_done("two_eligible_targets_still_make_one_hit")


func _check_movement_stays_at_its_baseline_and_power_adds_c1s_damage() -> void:
	print("")
	print("--- 18. A real stick walk moves at 5.0 m/s, and every real hit dealt exactly C1's answer for the weapon's 100 at +10% — Power is live (D-318)")
	var centre: Vector3 = _elite_hall_centre()
	var right: Vector3 = review.camera_rig.ground_right()
	right.y = 0.0
	right = right.normalized()
	var across: Vector3 = right.rotated(Vector3.UP, PI * 0.5)
	for index: int in 2:
		var enemy: PrototypeGraveblade = review.room_enemies[2][index]
		enemy.place_at(centre - right * 6.0 + across * (2.0 * index - 1.0) * 2.5)
	_stand(centre)
	await _settle(2)
	var walk: Dictionary = await _stick_walk(right)
	_expect(absf(float(walk["top"]) - ACCEPTED_MAX_SPEED) <= SPEED_TOLERANCE
			and absf(float(walk["plateau"]) - ACCEPTED_MAX_SPEED) <= SPEED_TOLERANCE and float(walk["along"]) > 0.99
			and int(walk["family"]) == InputFamilyTracker.Family.CONTROLLER and review.player.max_speed == ACCEPTED_MAX_SPEED,
		"the stick walk measured top %.3f and plateau %.3f m/s along %.3f" % [float(walk["top"]), float(walk["plateau"]), float(walk["along"])])
	## Roguelite I13 (D-318) moved this assertion one for one: every real hit after Power took
	## exactly C1's answer for the weapon's raw 100 at the build's +10%, and the weapon itself
	## still reads 100.
	_expect(_hits.size() == 3 and _exact_hits == 3 and roundi(_power_hit()) == 110
			and review.player.physical_damage == ACCEPTED_DAMAGE and review.player.physical_damage == float(_baseline["weapon_damage"])
			and is_equal_approx(review.mote_runtime.run_build().total_for(PlayerStats.GLOBAL_DAMAGE), 0.10)
			and review.last_application.deferred_stats.is_empty()
			and review.player.increased_global_damage() == review.last_application.increased_global_damage,
		"the real hits dealt %s against C1's %.12f from a weapon of %.0f" % [str(_hits), _power_hit(), review.player.physical_damage])
	print("  a real stick held fully right for %d ticks: top speed and every %d-tick plateau within %.2f m/s of 5.0 m/s, straight along the camera's right"
		% [WALK_TICKS, PLATEAU_WINDOW, SPEED_TOLERANCE])
	print("  measured: top %.4f m/s, plateau %.4f m/s over %.2f m" % [float(walk["top"]), float(walk["plateau"]), float(walk["distance"])])
	print("  the three real hits each took C1's answer for the weapon's raw 100 at +10%% — %.0f, %.0f and %.0f — live through the seam"
		% [_hits[0], _hits[1], _hits[2]])
	_done("movement_stays_at_its_baseline_and_power_adds_c1s_damage")


# --- 19–20. The expedition's end, and the next one ---------------------------------------------------

func _check_f5_restores_every_baseline_through_the_empty_build() -> void:
	print("")
	print("--- 19. F5 ends the expedition, and the one empty-build restoration returns every covered value to its baseline")
	var before: Dictionary = _live_values()
	var restorations: int = review.restorations_made
	await _key(KEY_F5)
	await _settle(4)
	var after: Dictionary = _live_values()
	var restored: RiftBuildApplicationResult = review.last_restoration
	_expect(float(before["reach"]) == 3.65 and float(before["arc"]) == 260.0 and review.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB
			and review.mote_runtime == null and review.restorations_made == restorations + 1
			and restored != null and restored.ok and restored.committed and restored.supports_applied.is_empty()
			and restored.deferred_stats.is_empty() and restored.reach == ACCEPTED_REACH,
		"F5 did not end the expedition through the empty build: %s" % ("none" if restored == null else restored.describe()))
	_expect(after == _baseline and float(after["max_speed"]) == ACCEPTED_MAX_SPEED and float(after["effective"]) == ACCEPTED_ACTION_TIME
			and float(after["reach"]) == ACCEPTED_REACH and float(after["arc"]) == ACCEPTED_ARC and float(after["cone"]) == ACCEPTED_CONE
			and int(after["targets"]) == 1 and review.last_application == null and review.live_receipt_text().is_empty()
			and not review.live_receipt_control().is_visible_in_tree() and _receipt_lines().is_empty()
			and not review.level_up_panel.is_open and not paused and review.application_refusals == 0,
		"after F5: %s against %s" % [str(after), str(_baseline)])
	print("  %s -> %s" % [_live_line(before), _live_line(after)])
	print("  restored by the seam from an empty build (%s); no application, live line or receipt left" % restored.describe())
	_done("f5_restores_every_baseline_through_the_empty_build")


func _check_the_next_expedition_begins_without_the_previous_build() -> void:
	print("")
	print("--- 20. The next expedition begins at every baseline with no build, receipt, offer, application result or held Power")
	var restorations: int = review.restorations_made
	await _begin_expedition("B")
	var build: RiftRunBuild = review.mote_runtime.run_build()
	var live: Dictionary = _live_values()
	_expect(review.mote_runtime.run_seed() == ROUTE_SEED and review.mote_runtime.level() == 1
			and review.mote_runtime.experience() == 0.0 and not review.mote_runtime.is_offer_active()
			and review.offer_attempted_level() == RogueliteLevelUpChoiceReview.NO_LEVEL_ASKED
			and build.is_empty() and build.support_count() == 0 and build.acquisitions_for(POWER) == 0
			and build.total_for(PlayerStats.GLOBAL_DAMAGE) == 0.0 and review.last_application == null
			and review.live_receipt_text().is_empty() and not review.live_receipt_control().is_visible_in_tree()
			and _receipt_lines().is_empty() and not review.level_up_panel.is_open and not paused
			and live == _baseline and review.restorations_made == restorations + 1
			and _hud_text(HUD_LEVEL) == "Rift level 1" and _hud_text(HUD_EXPERIENCE) == "XP 0 / 100",
		"expedition B began with %s / %s" % [build.describe(), str(live)])
	print("  B began at Rift level 1, XP 0 / 100, run seed %d: an empty build (0 pairs, card_power 0, Global Damage 0), no offer, no receipt, no live line, no application result; %s"
		% [ROUTE_SEED, _live_line(live)])
	await _key(KEY_F5)
	await _settle(4)
	_expect_quiet(review.mote_runtime == null and _live_values() == _baseline, "B's own F5 left %s" % _state())
	_done("the_next_expedition_begins_without_the_previous_build")


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


# --- Readings ------------------------------------------------------------------------------------

## What must not move while the world is held: the enemy, the player, the sweep, the motes, the
## attack, and what the pause probe has received.
func _frozen(enemy: PrototypeGraveblade) -> Dictionary:
	var runtime: RiftMoteRuntime = review.mote_runtime
	return {
		"sweeps": review.sweeps_made, "player": review.player.global_position, "life": review.player.life,
		"enemy": enemy.global_position, "enemy_state": enemy.state, "enemy_time": enemy.state_time,
		"enemy_life": enemy.life, "enemy_ai": enemy.ai_enabled, "enemy_alive": enemy.is_alive(),
		"drops": runtime.drop_count(), "uncollected": runtime.uncollected_count(), "collected": runtime.collected_count(),
		"attack": review.player.attack.phase, "attacks": review.player.attack.uses_started,
		"destination": review.player.has_destination, "ticks": _probe_count("ticks"), "unpaused": _probe_count("unpaused"),
	}


func _live_values() -> Dictionary:
	var strike: QuickStrikeData = review.player.attack.data
	return {
		"max_speed": review.player.max_speed, "increased": review.player.increased_attack_speed(),
		"effective": review.player.attack.effective_action_time(), "action_time": strike.action_time,
		"reach": strike.reach, "arc": strike.release_arc_degrees, "cone": strike.soft_target_cone_degrees,
		"targets": strike.maximum_targets, "margin": strike.approach_stop_margin,
		"soft_distance": strike.soft_target_distance, "mana_cost": strike.mana_cost,
		"weapon_damage": review.player.physical_damage, "max_life": review.player.max_life,
		"acceleration": review.player.acceleration, "braking": review.player.braking,
		"arrival": review.player.arrival_tolerance,
	}


## Roguelite I13 (D-318): C1's own answer for the weapon's raw damage at the whole build's Global
## Damage total — what every real hit after Power deals. Asked of the vocabulary, never restated.
func _power_hit() -> float:
	return PlayerStats.apply(PlayerStats.GLOBAL_DAMAGE, review.player.physical_damage,
		review.mote_runtime.run_build().total_for(PlayerStats.GLOBAL_DAMAGE)).value


## One real hit's Life loss, and whether the Life it left is exactly the Life before less C1's answer.
func _record_hit(before: float, after: float) -> void:
	_hits.append(before - after)
	if after == before - _power_hit():
		_exact_hits += 1


func _live_line(live: Dictionary) -> String:
	return "movement %.1f m/s, action time %.2f s, reach %.2f m, arc %.0f°, cone %.0f°, %d target(s)" % [
		float(live["max_speed"]), float(live["effective"]), float(live["reach"]), float(live["arc"]),
		float(live["cone"]), int(live["targets"])]


func _probe_count(field: String) -> int:
	return int(_probe.get(field))


func _offer_line() -> String:
	var runtime: RiftMoteRuntime = review.mote_runtime
	if runtime == null or not runtime.is_offer_active():
		return "no offer"
	return _line(runtime.offer_root_seed(), runtime.offer_lanes(),
		[runtime.offer_identity_for(0), runtime.offer_identity_for(1), runtime.offer_identity_for(2)],
		runtime.offer_support_content_kind(), runtime.offer_support_fallback_category())


func _expected_offer(index: int) -> String:
	return _line(ROOTS[index], [0, 1, 2], OFFERS[index], OFFER_KINDS[index], OFFER_CATEGORIES[index])


func _line(root_seed: int, lanes: Array, identities: Array, kind: int, category: int) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for identity: Variant in identities:
		parts.append("[%s]" % ", ".join(PackedStringArray(identity)))
	return "root %d lanes %s %s kind %d category %d" % [root_seed, str(lanes), " ".join(parts), kind, category]


func _shown_cards() -> Array:
	var shown: Array = []
	for slot: int in review.level_up_panel.card_count():
		shown.append(Array(review.level_up_panel.card_lines(slot)))
	return shown


func _titles() -> PackedStringArray:
	var titles: PackedStringArray = PackedStringArray()
	for card: Array in _shown_cards():
		titles.append(String(card[1]))
	return titles


## Every visible receipt line in its on-screen order: I2's six, with I3's live line between the
## level line and the note.
func _receipt_lines() -> PackedStringArray:
	var lines: PackedStringArray = PackedStringArray()
	for control: Control in _receipt_controls():
		if control.is_visible_in_tree():
			lines.append((control as Label).text)
	return lines


func _receipt_controls() -> Array[Control]:
	var controls: Array[Control] = review.receipt_controls()
	controls.insert(controls.size() - 1, review.live_receipt_control())
	return controls


## Every visible piece of text inside H9's review panel, the receipt section included.
func _visible_review_texts() -> PackedStringArray:
	var texts: PackedStringArray = PackedStringArray()
	for node: Node in review.experience_hud.find_children("*", "Label", true, false):
		var label: Label = node as Label
		if label != null and label.is_visible_in_tree():
			texts.append(label.text)
	return texts


func _open_modals() -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	for child: Node in review.get_node("CanvasLayer").get_children():
		var modal: FirstMvpModal = child as FirstMvpModal
		if modal != null and modal.is_open:
			names.append(String(modal.name))
	return names


func _state() -> String:
	if review.mote_runtime == null:
		return "no runtime; attempted level %d, calls %d, open %s, paused %s" % [
			review.offer_attempted_level(), review.offer_open_calls, str(review.level_up_panel.is_open), str(paused)]
	return "level %d, experience %s, active %s, calls %d, attempted level %d, open %s, paused %s, refusal '%s'" % [
		review.mote_runtime.level(), _whole(review.mote_runtime.experience()),
		str(review.mote_runtime.is_offer_active()), review.offer_open_calls, review.offer_attempted_level(),
		str(review.level_up_panel.is_open), str(paused), review.last_offer_refusal]


# --- On screen -------------------------------------------------------------------------------------

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
	var content: Rect2 = (panel.get_node("Panel") as Control).get_global_rect()
	var offset: Vector2 = content.get_center() - viewport.get_center()
	_expect_quiet(shown == visible and visible == controls.size() - 1 and smallest >= 12 and overlapping == 0
			and viewport.encloses(content) and absf(offset.x) <= 1.0 and absf(offset.y) <= 1.0,
		"%s: %d of %d controls on screen, smallest %d, %d overlapping, offset %s" % [label, shown, visible, smallest, overlapping, offset])
	return "%s: %d of %d visible text controls on screen, smallest %d px; 3 cards, %d overlapping; the panel centred within 1 px; behind it no receipt and no live line" % [
		label, shown, visible, smallest, overlapping]


func _measure_receipt() -> String:
	await _await_process_frames(4)
	var viewport: Rect2 = Rect2(Vector2.ZERO, Vector2(root.get_visible_rect().size))
	var controls: Array[Control] = _receipt_controls()
	var shown: int = _measure_text(controls, viewport, "receipt")
	var host: Rect2 = review.experience_hud.panel.get_global_rect()
	var outside: int = 0
	var overlapping: int = 0
	var visible: Array[Control] = []
	for control: Control in controls:
		if control.is_visible_in_tree():
			visible.append(control)
			if not host.encloses(control.get_global_rect()):
				outside += 1
	for a: int in visible.size():
		for b: int in range(a + 1, visible.size()):
			if visible[a].get_global_rect().intersects(visible[b].get_global_rect()):
				overlapping += 1
	var centre: Rect2 = Rect2(viewport.size * 0.25, viewport.size * 0.5)
	var smallest: int = _smallest_font(controls)
	_wrapped_lines = review.live_receipt_control().get_line_count()
	_expect_quiet(shown == 6 and outside == 0 and overlapping == 0 and viewport.encloses(host) and not host.intersects(centre)
			and smallest >= 12 and not paused,
		"the receipt: %d lines on screen, %d outside the review panel %s, %d overlapping" % [shown, outside, host, overlapping])
	print("  the live line's three logical lines are drawn as %d lines in the review panel's text column" % _wrapped_lines)
	return "the final receipt: %d lines on screen inside the review panel, 0 overlapping, clear of the centre, smallest %d px; not paused" % [
		shown, smallest]


# --- Expeditions ---------------------------------------------------------------------------------

## STAGED for every expedition after the first: the Nexus's next plan is replaced by a fresh plan
## of the route's seed, so each expedition is an equivalent fresh one (D-294 ruling 4).
func _begin_expedition(label: String) -> void:
	if review.plan.seed_value != ROUTE_SEED:
		review.plan = RogueliteRunPlan.new(ROUTE_SEED, review.plan.run_index)
		_staged_plans += 1
	await _walk_into_gate(review.hub_module.exit_point())
	_expeditions += 1
	_expect_quiet(review.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN and review.mote_runtime != null
			and review.mote_runtime.run_seed() == ROUTE_SEED and review.mote_runtime.level() == 1
			and review.mote_runtime.run_build().is_empty() and not review.level_up_panel.is_open,
		"expedition %s did not begin fresh at seed %d: %s" % [label, ROUTE_SEED, _state()])
	if not review.automatic_pickup:
		await _key(KEY_F8)


## STAGED: each amount awarded as the header states, every mote collected by ONE explicit H8 sweep
## before any tick of the review's own can run.
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
		enemy.name = "I12Fixture%d" % _fixtures
		enemy.position = at
		_stage.add_child(enemy)
		enemy.set_ai_enabled(false)
		registered = registered and runtime.register_graveblade(enemy, float(amount)).is_empty()
		enemy.receive_damage(DamageEvent.physical(_use(), review.player, enemy, enemy.life + 1000.0))
		registered = registered and not enemy.is_alive() and runtime.emission_answer(enemy).is_empty()
		expected.append(drops + expected.size())
		total += float(amount)
	var answer: RiftMoteSweepResult = runtime.sweep_at(at)
	## Presentation only: H9's panel is told to read the run again, as I11's harness does.
	review.experience_hud.refresh()
	return registered and answer.ok and answer.collected_indices() == expected and runtime.experience() == before + total


# --- Real play -------------------------------------------------------------------------------------

## One press and release of the controller's Quick Strike button through the viewport, followed
## until the action is READY again. Ticks are counted from the press.
func _swing() -> Dictionary:
	await _until_neutral()
	await _until_ready()
	await _as_controller()
	var attack: QuickStrikeAction = review.player.attack
	var start_at: Vector3 = review.player.global_position
	var marks: Dictionary = {"release": -1, "finish": -1, "anim_release": -1.0, "outcome": {}, "windup_at": start_at}
	var start: int = Engine.get_physics_frames()
	var on_release: Callable = func(_id: int, outcome: Dictionary) -> void:
		if int(marks["release"]) < 0:
			marks["release"] = Engine.get_physics_frames() - start
			marks["anim_release"] = review.player.quick_strike_animation_position()
			marks["outcome"] = outcome
	var on_phase: Callable = func(next: int) -> void:
		if next == QuickStrikeAction.Phase.WINDUP:
			marks["windup_at"] = review.player.global_position
		if next == QuickStrikeAction.Phase.READY and int(marks["finish"]) < 0:
			marks["finish"] = Engine.get_physics_frames() - start
	attack.use_released.connect(on_release)
	attack.phase_changed.connect(on_phase)
	var queries: int = attack.release_queries
	var releases: int = attack.uses_released
	var damage: int = attack.damage_events
	_push_joy(QUICK_STRIKE_BUTTON, true)
	marks["family"] = review.input_family.family
	var began: int = attack.phase
	var target: PrototypeTargetable = attack.target
	var acquisition: String = attack.last_acquisition
	_push_joy(QUICK_STRIKE_BUTTON, false)
	_presses += 1
	for i: int in 300:
		await physics_frame
		if int(marks["finish"]) >= 0 or began == QuickStrikeAction.Phase.READY:
			break
	attack.use_released.disconnect(on_release)
	attack.phase_changed.disconnect(on_phase)
	marks["began"] = began
	marks["target"] = target
	marks["acquisition"] = acquisition
	marks["moved"] = _planar_gap(start_at, marks["windup_at"] as Vector3)
	marks["queries"] = attack.release_queries - queries
	marks["releases"] = attack.uses_released - releases
	marks["damage"] = attack.damage_events - damage
	return marks


## The left stick held fully along the camera's ground right through Godot's own Input, for
## WALK_TICKS physics ticks, then let go: the top planar speed, and the highest speed over any
## PLATEAU_WINDOW-tick window of measured displacement.
func _stick_walk(right: Vector3) -> Dictionary:
	await _until_neutral()
	var from: Vector3 = review.player.global_position
	var positions: Array[Vector3] = []
	var top: float = 0.0
	_push_axis(JOY_AXIS_LEFT_X, 1.0)
	for i: int in WALK_TICKS:
		await physics_frame
		positions.append(review.player.global_position)
		top = maxf(top, review.player.planar_speed())
	var family: int = review.input_family.family
	_push_axis(JOY_AXIS_LEFT_X, 0.0)
	await _settle(20)
	var plateau: float = 0.0
	for i: int in range(positions.size() - PLATEAU_WINDOW):
		plateau = maxf(plateau, _planar_gap(positions[i], positions[i + PLATEAU_WINDOW]) / (float(PLATEAU_WINDOW) * _dt()))
	var travelled: Vector3 = positions[positions.size() - 1] - from
	travelled.y = 0.0
	return {"top": top, "plateau": plateau, "distance": travelled.length(), "family": family,
		"along": travelled.normalized().dot(right) if travelled.length() > 0.0 else 0.0}


## The kernel's own release query, asked with `record` for the player where they stand, over the
## two Elite Hall Graveblades.
func _release_query(record: QuickStrikeData, enemies: Array) -> Dictionary:
	var candidates: Array[PrototypeTargetable] = []
	for enemy: PrototypeGraveblade in enemies:
		candidates.append(_area(enemy))
	return review.acquisition.resolve_release(review.player.global_position, review.player.facing_direction(),
		null, candidates, record)


func _rejected(outcome: Dictionary, enemy: PrototypeGraveblade) -> String:
	for record: Dictionary in outcome.get("considered", []):
		if record.get("fixture") == _area(enemy):
			return String(record.get("rejected", ""))
	return "(not considered)"


func _area(enemy: PrototypeGraveblade) -> PrototypeTargetable:
	return enemy.get_node_or_null("TargetArea") as PrototypeTargetable


func _ticks_match(ticks: int, seconds: float) -> bool:
	var dt: float = _dt()
	return ticks * dt >= seconds - 0.000001 and ticks * dt < seconds + dt + 0.000001


func _dt() -> float:
	return 1.0 / float(Engine.physics_ticks_per_second)


func _until_neutral() -> void:
	for i: int in 30:
		if not review.player.awaiting_neutral and not paused:
			return
		await _await_process_frames(1)


## Waits until the action is READY and returns from the idle step, after every physics tick of this
## frame has run, so a press is never pushed from inside a physics-frame resume (I3's lesson).
func _until_ready() -> void:
	for i: int in 300:
		if review.player.attack.phase == QuickStrikeAction.Phase.READY:
			break
		await physics_frame
	await process_frame


## THE CONTROLLER FAMILY, BEFORE EVERY CONTROLLER PRESS (I3's lesson): the accepted tracker refuses
## a family change inside its anti-flicker cooldown, so a joypad press pushed just after a key is
## aimed by the mouse path. The harness waits the cooldown out, and every press records its family.
func _as_controller() -> void:
	if review.input_family.family == InputFamilyTracker.Family.CONTROLLER:
		return
	await create_timer(review.input_family.switch_cooldown_seconds + 0.05).timeout
	await process_frame


# --- Places ----------------------------------------------------------------------------------------

func _elite_hall_centre() -> Vector3:
	return _rounded(review.room_modules[2].room_centres()[0])


func _forward() -> Vector3:
	var facing: Vector3 = review.route_forward()
	facing.y = 0.0
	return facing.normalized()


func _stand(at: Vector3) -> void:
	review.player.global_position = Vector3(at.x, 0.0, at.z)
	review.player.velocity = Vector3.ZERO
	review.player.clear_movement_intent("verification", false)
	review.camera_rig.focus = review.player.global_position


func _stand_facing(at: Vector3, facing: Vector3) -> void:
	_stand(at)
	review.player.face_instantly(facing)


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


# --- Input, through the viewport and Godot's own Input ----------------------------------------------

func _push_key(keycode: Key, pressed: bool) -> void:
	var event: InputEventKey = InputEventKey.new()
	event.keycode = keycode
	event.physical_keycode = keycode
	event.pressed = pressed
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


## A joypad axis, as a device reports it: through Godot's own Input, so the InputMap's stick
## actions and their deadzones read it exactly as they read a real stick.
func _push_axis(axis: JoyAxis, value: float) -> void:
	var event: InputEventJoypadMotion = InputEventJoypadMotion.new()
	event.device = 0
	event.axis = axis
	event.axis_value = value
	Input.parse_input_event(event)
	Input.flush_buffered_events()


# --- Evidence ----------------------------------------------------------------------------------------

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


# --- Helpers -----------------------------------------------------------------------------------------

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


func _whole(value: float) -> String:
	if value == floorf(value):
		return "%d" % int(value)
	return "%.1f" % value


func _joined(ids: Array) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for id: Variant in ids:
		parts.append(String(id))
	return ", ".join(parts)


func _hud_text(index: int) -> String:
	return review.experience_hud.text_controls()[index].text


func _hud_visible(index: int) -> bool:
	return review.experience_hud.text_controls()[index].is_visible_in_tree()


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
