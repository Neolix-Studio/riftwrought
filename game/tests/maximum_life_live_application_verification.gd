extends SceneTree
## Riftwrought — Roguelite I14: Player Maximum-Life Application V1: automated, rendered
## verification (decision D-320).
##
## THE ONE QUESTION: does the accepted Vitality modifier make Maximum Life live on the
## playable character through the existing run-build application seam, while preserving the
## character's current-Life percentage, remaining atomic and idempotent, and restoring the
## baseline cleanly?
##
## ONE SCENE, LOADED EXACTLY AS IT SHIPS AND GIVEN NO FLAG OF ITS OWN: the accepted I3
## live-effect review (D-295, D-316), driven through seed 99's accepted I12 sequence to the
## Level 5 passive fallback, where the ordinary Combat and Defence lane — Vitality — is taken
## with a real controller press. A real Graveblade Hit then lands on the enlarged character,
## F5 ends the expedition, and a fresh expedition begins.
##
## BESIDE IT, PRODUCTION PLAYER FIXTURES. Each is `prototype_player.tscn` instanced whole into
## this harness's own stage — the production script, its Quick Strike action and that action's
## private record — with its processing disabled so it neither falls nor regenerates Mana.
## Every transition-table row is driven through the production seam on one of them.
##
## EVERY EXPECTED NUMBER IS C1'S OWN ANSWER OR THE PLAYER'S OWN RULE. A maximum is asked of
## `PlayerStats.apply()` or of a fresh `PlayerStatTotals` holding the accepted card's own
## magnitude; a Life is asked of `PrototypePlayer.preserved_life()`; each is compared to the
## last bit. The brief's table values — 575, 287.5, 143.75, 650, 325, 250 — appear only as
## display expectations and are checked against those answers, never used to make them.
##
## STAGED, AND STATED WHERE IT HAPPENS:
##   - a fixture's damage is dealt through the production intake, `receive_damage()`, with a
##     DamageEvent this harness makes; a fixture's Life or configured maximum is set directly
##     only to reach an incoherent or extreme state, or to show the baseline is its own;
##   - builds are composed here from the accepted card and support records and handed to the
##     seam; only the entry-point refusals hand the player an incoherent total directly;
##   - the result-shape refusals tamper with results the seam itself returned;
##   - in the review every experience point beyond the route's own 75 is awarded as I11–I13
##     awarded theirs; the Elite Hall's two Graveblades are placed and quieted; the one
##     Graveblade Hit is forced through its own `begin_attack_for_verification()`; the held
##     build is handed to the seam once more, directly; expedition B is handed seed 99 again
##     (D-294 ruling 4).
##
## IT PORTS D-211's OWED-SET DISCIPLINE and GATE F's ON-SCREEN MEASUREMENT. The evidence frames
## add no assertion, so the headless and rendered runs pin one count.
##
## Run: godot --headless --path game --script res://tests/maximum_life_live_application_verification.gd -- --seed 99

const REVIEW_SCENE: String = "res://scenes/roguelite/roguelite_live_effect_review.tscn"
const PLAYER_SCENE: String = "res://scenes/actors/prototype_player.tscn"
const PLAYER_SCRIPT: String = "res://scripts/actors/prototype_player.gd"
const SEAM_SCRIPT: String = "res://scripts/roguelite/live_effects/rift_build_application.gd"
const RESULT_SCRIPT: String = "res://scripts/roguelite/live_effects/rift_build_application_result.gd"
const REVIEW_SCRIPT: String = "res://scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
const THIS_FILE: String = "res://tests/maximum_life_live_application_verification.gd"
const GRAVEBLADE_SCENE: String = "res://scenes/actors/prototype_graveblade.tscn"
const GRAVEBLADE_RECORD: String = "res://data/prototype_zero/graveblade.tres"
const ELITE_RECORD: String = "res://data/roguelite/graveblade_elite.tres"
const STARTER_SWORD: String = "res://data/prototype_zero/starter_sword.tres"
const WORN_SWORD: String = "res://data/first_mvp/severed_threshold/broken_watch/starting_sword.tres"
const HONED_SWORD: String = "res://data/prototype_zero/honed_sword.tres"
const CANONICAL_QUICK_STRIKE: String = "res://data/prototype_zero/quick_strike.tres"
const SKILL_RECORDS: Array[String] = [
	"res://data/first_mvp/skills/faultbreaker.tres",
	"res://data/first_mvp/skills/splinter_shot.tres",
	"res://data/first_mvp/skills/emberbolt.tres",
]
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31
const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]

## The four production files Roguelite I14 changed, each at its D-320 SHA-256 prefix.
const D320_HASHES: Array = [
	## First-MVP UI J2 (D-324) moved the player once more, from `a6d93721`, so that neutralizing a
	## fallen character's controls keeps it FALLEN.
	[PLAYER_SCRIPT, "80e38838"],
	[SEAM_SCRIPT, "c7b9df38"],
	## Roguelite I14's correction (D-321) moved the result once more, from `73d445f7`, for its describe().
	[RESULT_SCRIPT, "2fd01f80"],
	[REVIEW_SCRIPT, "75cb02b9"],
]

const QUICK_STRIKE: StringName = &"quick_strike"
const REACHING_EDGE: StringName = &"reaching_edge"
const SWEEPING_EDGE: StringName = &"sweeping_edge"

## The review: seed 99 with Support taken at every level (the accepted I10–I13 table).
const ROUTE_SEED: int = 99
const REVIEW_AMOUNT: float = 25.0
const LEVEL_TWO_AMOUNT: float = 125.0
## 150 + 175 + 200: Levels 3, 4 and 5 owed one after another, as I12 banks them.
const CHAIN_AMOUNTS: Array[float] = [150.0, 175.0, 200.0]
const NEAR: float = 1.2

## The accepted wording, typed independently of every mechanism (D-293, D-295, D-297, D-312),
## and the brief's own full-Life line.
const RECEIPT_TITLE: String = "Temporary build — this expedition"
const OFFER_STANDING_TEXT: String = "Level-up offer open — choose one of the three cards."
const STANDING_LINES: Array[String] = [RECEIPT_TITLE, OFFER_STANDING_TEXT]
const RECEIPT_LIVE_NOTE: String = "Applied to the character now; every value returns to its baseline when this expedition ends."
const LIVE_PREFIX: String = "Live now — "
const HELD_HEADING: String = "Held, not live on the character:"
const FULL_LIFE_LINE: String = "Maximum Life 500 → 575 · Life preserved at 100%"
const SPATIAL_LINE: String = "reach 1.65 m → 3.65 m · arc 100° → 260° · cone 65° → 155° · one target"
const ACTION_LINE: String = "action time 0.80 s → 0.727 s"
const MOVEMENT_LINE: String = "movement speed 5.0 m/s → 5.5 m/s"
const DAMAGE_LINE: String = "damage 100 → 110"
const LIVE_VITALITY: String = "Live now — reach 1.65 m → 3.65 m · arc 100° → 260° · cone 65° → 155° · one target\nMaximum Life 500 → 575 · Life preserved at 100%"
const VITALITY_RECEIPT: Array[String] = [
	RECEIPT_TITLE, "Combat and Defence — Vitality (+15% Maximum Life)",
	"Rift level 5 → 6 · 0 XP carried over", LIVE_VITALITY, RECEIPT_LIVE_NOTE,
]
const LIFE_BEFORE_LINE: String = "Life — 500 / 500"
const LIFE_LIVE_LINE: String = "Life — 575 / 575"
const LIFE_HIT_LINE: String = "Life — 450 / 575"

## The brief's transition table. Each row: a label, the Vitality acquisitions applied first,
## the damage then dealt through the production intake, the acquisitions applied second, the
## Life and maximum the brief states after, and the applied line the receipt must show ("" for
## none). Display expectations only; the answers are C1's and the rule's. Roguelite I14's correction
## (D-321) added an eighth column: the Maximum Life segment the seam's describe() must carry.
const TABLE: Array = [
	["500 / 500, +15%", 0, 0.0, 1, 575.0, 575.0, "Maximum Life 500 → 575 · Life preserved at 100%",
		"maximum life +15% -> 575.000 from 500.000; life 500.000/500.000 -> 575.000/575.000"],
	["250 / 500, +15%", 0, 250.0, 1, 287.5, 575.0, "Maximum Life 500 → 575 · Life preserved at 50%",
		"maximum life +15% -> 575.000 from 500.000; life 250.000/500.000 -> 287.500/575.000"],
	["125 / 500, +15%", 0, 375.0, 1, 143.75, 575.0, "Maximum Life 500 → 575 · Life preserved at 25%",
		"maximum life +15% -> 575.000 from 500.000; life 125.000/500.000 -> 143.750/575.000"],
	["0 / 500, +15%", 0, 500.0, 1, 0.0, 575.0, "Maximum Life 500 → 575 · Life preserved at 0%",
		"maximum life +15% -> 575.000 from 500.000; life 0.000/500.000 -> 0.000/575.000"],
	["287.5 / 575, +30%", 1, 287.5, 2, 325.0, 650.0, "Maximum Life 500 → 650 · Life preserved at 50%",
		"maximum life +30% -> 650.000 from 500.000; life 287.500/575.000 -> 325.000/650.000"],
	["287.5 / 575, empty build", 1, 287.5, 0, 250.0, 500.0, "",
		"maximum life +0% -> 500.000 from 500.000; life 287.500/575.000 -> 250.000/500.000"],
]
## The seam's describe() segments for a build without Vitality and with one, both at full Life, and
## for one Vitality applied again at 450 / 575 (D-321).
const DESCRIBE_PLAIN: String = "maximum life +0% -> 500.000 from 500.000; life 500.000/500.000 -> 500.000/500.000"
const DESCRIBE_VITALITY: String = "maximum life +15% -> 575.000 from 500.000; life 500.000/500.000 -> 575.000/575.000"
const DESCRIBE_SAME_AT_450: String = "maximum life +15% -> 575.000 from 500.000; life 450.000/575.000 -> 450.000/575.000"

## What this harness must never do: reach into the review, rewrite a record, a weapon or a
## damage record, or touch any stored total or baseline except through the player's own entry
## points. Read over this file's own CODE, comments removed and strings emptied.
const INJECTION_PATTERNS: Array[String] = [
	"review._", ".mote_runtime._", "level_up_panel._", "mote_runtime = ", "review.set(", "review.call(",
	".callv(", "set_meta(", "add_action(", "action_add_event(", "while ", "award_experience(",
	"._increased_maximum_life", "._maximum_life_baseline", "._increased_global_damage",
	"review.player.life = ", "review.player.max_life = ", "physical_damage = ", "magnitude = ",
	"final_life_damage = ", "raw_physical_damage = ", ".max_speed = ", ".reach = ", "Input.action_press(",
]

const OWED_CHECKS: Array[String] = [
	"the_harness_is_isolated_and_names_the_authorized_scene",
	"the_production_shape_is_the_authorized_one",
	"c1_is_the_only_percentage_path_and_the_baseline_is_the_characters_own",
	"c1_answers_every_maximum_life_derivation",
	"every_transition_in_the_table_preserves_the_life_fraction",
	"zero_life_is_never_revived_and_a_living_character_never_reaches_zero",
	"the_same_build_again_heals_nothing_and_says_nothing",
	"two_vitalities_are_one_total_and_never_compound",
	"incoherent_totals_and_life_states_refuse_and_move_nothing",
	"the_seam_derives_before_it_writes_and_puts_global_damage_back",
	"the_result_refuses_every_incoherent_maximum_life_shape",
	"life_changed_fires_once_per_real_transition_and_never_for_a_no_op",
	"the_receipt_states_maximum_life_as_live_and_never_as_held",
	"power_and_vitality_are_both_live",
	"every_accepted_effect_line_is_unchanged_beside_vitality",
	"before_vitality_the_offers_hold_the_world_and_hide_the_receipts",
	"vitality_is_live_in_the_choices_own_call",
	"the_level_six_receipt_states_maximum_life_under_live_now",
	"a_real_graveblade_hit_takes_its_own_125_from_575",
	"the_same_held_build_again_does_not_heal",
	"f5_restores_the_baseline_through_the_empty_build",
	"the_next_expedition_starts_at_the_baseline",
	"no_record_or_card_moved",
]

var review: RogueliteLiveEffectReview
var arguments: PackedStringArray = PackedStringArray()

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _shot_dir: String = ""
var _stage: Node3D
var _next_use_id: int = 98000
var _fixtures: int = 0
var _fixture_players: int = 0
var _staged_builds: int = 0
var _expeditions: int = 0
var _staged_plans: int = 0

var _records_at_start: Dictionary = {}
var _baseline: Dictionary = {}
var _standing: Array[Dictionary] = []
var _chosen: Dictionary = {}
var _hit: Dictionary = {}
var _receipt_measure: String = ""


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	_shot_dir = _argument_value("--shots")
	print("")
	print("=== Roguelite I14 — Player Maximum-Life Application V1 verification (D-320) ===")
	_stage = Node3D.new()
	_stage.name = "I14FixtureStage"
	root.add_child(_stage)
	_records_at_start = _record_snapshot()

	review = await _load_scene(REVIEW_SCENE) as RogueliteLiveEffectReview
	if review == null or review.player == null:
		printerr("MAXIMUM LIFE LIVE APPLICATION VERIFICATION: the accepted I3 scene did not load")
		quit(1)
		return
	await _settle(10)
	await _await_navigation()

	_check_the_harness_is_isolated_and_names_the_authorized_scene()
	_check_the_production_shape_is_the_authorized_one()
	_check_c1_is_the_only_percentage_path_and_the_baseline_is_the_characters_own()
	_check_c1_answers_every_maximum_life_derivation()
	_check_every_transition_in_the_table_preserves_the_life_fraction()
	_check_zero_life_is_never_revived_and_a_living_character_never_reaches_zero()
	_check_the_same_build_again_heals_nothing_and_says_nothing()
	_check_two_vitalities_are_one_total_and_never_compound()
	_check_incoherent_totals_and_life_states_refuse_and_move_nothing()
	_check_the_seam_derives_before_it_writes_and_puts_global_damage_back()
	_check_the_result_refuses_every_incoherent_maximum_life_shape()
	_check_life_changed_fires_once_per_real_transition_and_never_for_a_no_op()
	_check_the_receipt_states_maximum_life_as_live_and_never_as_held()
	_check_power_and_vitality_are_both_live()
	_check_every_accepted_effect_line_is_unchanged_beside_vitality()

	await _expedition_a()
	await _check_f5_restores_the_baseline_through_the_empty_build()
	await _check_the_next_expedition_starts_at_the_baseline()
	_check_no_record_or_card_moved()

	_check_every_check_ran()

	print("")
	print("  %d fixture players spawned, %d builds staged through the seam on them, %d expeditions (%d given seed %d again by staging), %d fixture Graveblades registered and killed, %d applications and %d restorations made by the review"
		% [_fixture_players, _staged_builds, _expeditions, _staged_plans, ROUTE_SEED, _fixtures,
			review.applications_made, review.restorations_made])
	if _failures.is_empty():
		print("MAXIMUM LIFE LIVE APPLICATION VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("MAXIMUM LIFE LIVE APPLICATION VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		quit(1)


## Changes to the accepted scene exactly as it ships and waits until it stands.
func _load_scene(path: String) -> Node:
	var changed: Error = change_scene_to_packed(load(path) as PackedScene)
	for frame: int in 30:
		await process_frame
		if current_scene != null and current_scene.scene_file_path == path:
			break
	if changed != OK or current_scene == null or current_scene.scene_file_path != path:
		return null
	return current_scene


# --- 1–4. Isolation, the production shape, the one calculation path, C1's answers --------------

func _check_the_harness_is_isolated_and_names_the_authorized_scene() -> void:
	print("")
	print("--- 1. The harness loads the accepted I3 review as it ships; no accepted suite starts; nothing is injected")
	var script: GDScript = review.get_script() as GDScript
	_expect(review.scene_file_path == REVIEW_SCENE and script.resource_path == REVIEW_SCRIPT
			and review.get_node_or_null("RogueliteLiveEffectReviewVerification") == null
			and not arguments.has("--verify-live-effects") and not arguments.has("--verify-level-up-choices")
			and (review.player.get_script() as GDScript).resource_path == PLAYER_SCRIPT,
		"the review is %s running %s, or an accepted suite started in it" % [review.scene_file_path, script.resource_path])
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	var own: String = _bare(FileAccess.get_file_as_string(THIS_FILE))
	var raw_own: String = FileAccess.get_file_as_string(THIS_FILE)
	var injected: PackedStringArray = PackedStringArray()
	var listed: int = 0
	for pattern: String in INJECTION_PATTERNS:
		if own.contains(pattern):
			injected.append(pattern)
		if raw_own.contains("\"%s\"" % pattern):
			listed += 1
	_expect(actions == EXPECTED_ACTIONS and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT
			and not settings.contains("[autoload]") and not settings.contains("maximum_life_live")
			and injected.is_empty() and listed == INJECTION_PATTERNS.size() and own.length() > 20000,
		"%d actions, or project.godot moved, or this harness's code names %s (%d of %d patterns listed)"
			% [actions, ", ".join(injected), listed, INJECTION_PATTERNS.size()])
	print("  the accepted scene %s runs %s on the production player; no accepted suite started; %d actions; the entrypoint is %s; project.godot declares no [autoload]; 0 of %d injection patterns in this harness's code"
		% [REVIEW_SCENE.get_file(), script.resource_path.get_file(), actions, ENTRYPOINT.get_file(), INJECTION_PATTERNS.size()])
	_done("the_harness_is_isolated_and_names_the_authorized_scene")


func _check_the_production_shape_is_the_authorized_one() -> void:
	print("")
	print("--- 2. One stored total and one captured baseline on the player, one write entry point and one Life rule; the seam covers four stats and holds none")
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in D320_HASHES:
		var digest: String = FileAccess.get_sha256(String(row[0]))
		if not digest.begins_with(String(row[1])):
			moved.append("%s %s" % [String(row[0]).get_file(), digest.left(8)])
	var player_source: String = FileAccess.get_file_as_string(PLAYER_SCRIPT)
	var player_code: String = _bare(player_source)
	var functions: PackedStringArray = _declared_functions(player_source)
	var setter: String = _function_body(player_code, "set_increased_maximum_life")
	var reader: String = _function_body(player_code, "increased_maximum_life").strip_edges()
	var baseline: String = _function_body(player_code, "maximum_life_baseline").strip_edges()
	var rule: String = _function_body(player_code, "preserved_life")
	var guard: String = _function_body(player_code, "life_transition_problem")
	var names: Array[String] = [
		"set_increased_maximum_life", "increased_maximum_life", "maximum_life_baseline", "preserved_life",
		"life_transition_problem", "set_increased_global_damage", "increased_global_damage", "outgoing_hit_damage",
	]
	var declared_once: int = 0
	for name: String in names:
		if functions.count(name) == 1:
			declared_once += 1
	_expect(moved.is_empty() and declared_once == names.size()
			and player_code.count("var _increased_maximum_life: float = 0.0") == 1
			and player_code.count("var _maximum_life_baseline: float = 0.0") == 1
			and player_code.count("_increased_maximum_life = ") == 1 and player_code.count("_maximum_life_baseline = ") == 1
			and player_code.count("max_life = ") == 1 and setter.count("max_life = maximum.value") == 1
			and setter.count("PlayerStats.apply(PlayerStats.MAXIMUM_LIFE, baseline, total_increased)") == 1
			and setter.count("life_transition_problem(life, max_life, maximum.value)") == 1
			and setter.count("preserved_life(life, max_life, maximum.value)") == 1
			and setter.count("life_changed.emit(life, max_life)") == 1
			and not setter.contains("*") and not setter.contains("+") and not setter.contains("clamp")
			and not setter.contains("revive") and not setter.contains("action_state")
			and reader == "return _increased_maximum_life"
			and baseline == "return max_life if _increased_maximum_life == 0.0 else _maximum_life_baseline"
			and rule.count("return maximum_after * (current / maximum_before)") == 1
			and rule.count("if maximum_after == maximum_before:") == 1 and not rule.contains("PlayerStats")
			and not guard.contains("PlayerStats") and not guard.contains("clamp"),
		"moved %s; %d of %d functions declared once; the reader reads '%s' and the baseline '%s'"
			% [", ".join(moved), declared_once, names.size(), reader, baseline])

	## WHO WRITES THE TOTAL, WHO NAMES THE STORED STATE, AND WHO WRITES A MAXIMUM, over every running file.
	var private: RegEx = RegEx.create_from_string("(?<![A-Za-z0-9])_(increased_maximum_life|maximum_life_baseline)")
	var callers: PackedStringArray = PackedStringArray()
	var namers: PackedStringArray = PackedStringArray()
	var writers: PackedStringArray = PackedStringArray()
	var scanned: int = 0
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd", ".tscn", ".tres"]):
			if path == PLAYER_SCRIPT:
				continue
			scanned += 1
			var code: String = _bare(FileAccess.get_file_as_string(path))
			if code.count("set_increased_maximum_life(") > 0:
				callers.append("%s x%d" % [path.get_file(), code.count("set_increased_maximum_life(")])
			if private.search(code) != null:
				namers.append(path.get_file())
			if path.ends_with(".gd") and code.contains("max_life = "):
				writers.append(path.get_file())
	_expect(scanned > 100 and callers == PackedStringArray(["rift_build_application.gd x1"]) and namers.is_empty()
			and writers.is_empty(),
		"the entry point is called by [%s]; the stored state is named by [%s]; a maximum is written by [%s]"
			% [", ".join(callers), ", ".join(namers), ", ".join(writers)])

	var seam: String = _bare(FileAccess.get_file_as_string(SEAM_SCRIPT))
	var result: String = _bare(FileAccess.get_file_as_string(RESULT_SCRIPT))
	_expect(_joined(RiftBuildApplication.covered_stats()) == _joined([PlayerStats.GLOBAL_DAMAGE, PlayerStats.SKILL_SPEED,
				PlayerStats.MAXIMUM_LIFE, PlayerStats.MOVEMENT_SPEED])
			and RiftBuildApplication.deferred_stats().is_empty()
			and _joined(RiftBuildApplication.run_path_stats()) == _joined([PlayerStats.EXPERIENCE_GAIN, PlayerStats.PICKUP_RADIUS])
			and seam.count("set_increased_maximum_life(") == 1 and seam.count("set_increased_global_damage(") == 2
			and seam.count("totals.value_of(PlayerStats.MAXIMUM_LIFE, player.maximum_life_baseline())") == 1
			and seam.count("PrototypePlayer.life_transition_problem(") == 1 and seam.count("PrototypePlayer.preserved_life(") == 1
			and result.count("PrototypePlayer.life_transition_problem(") == 1 and result.count("PrototypePlayer.preserved_life(") == 1
			and result.count("PlayerStats.apply(") == 2
			and result.count("PlayerStats.MAXIMUM_LIFE, maximum_life.base_value, maximum_life.total_increased)") == 1,
		"the seam covers [%s] and holds [%s], or names the player's Life entry points otherwise"
			% [_joined(RiftBuildApplication.covered_stats()), _joined(RiftBuildApplication.deferred_stats())])
	print("  %d changed production files at their D-320 SHA-256 prefixes, the result at its D-321 one and the player at its D-324 one; the player declares one stored total and one captured baseline, both 0.0, and %s"
		% [D320_HASHES.size(), ", ".join(PackedStringArray(names.slice(0, 5)))])
	print("  of %d running files, the entry point's only caller is [%s]; none but the player names the stored total or baseline, and none but the player writes a maximum"
		% [scanned, ", ".join(callers)])
	print("  the seam covers [%s], holds [%s] and leaves [%s] to the run's own mote path; it and its result reach the Life rule only through the player's two static functions"
		% [_joined(RiftBuildApplication.covered_stats()), _joined(RiftBuildApplication.deferred_stats()),
			_joined(RiftBuildApplication.run_path_stats())])
	_done("the_production_shape_is_the_authorized_one")


func _check_c1_is_the_only_percentage_path_and_the_baseline_is_the_characters_own() -> void:
	print("")
	print("--- 3. C1 is the only path from a percentage to a maximum; no Life number is typed into production; the baseline is the character's own configured maximum, never a moved one")
	var player_code: String = _bare(FileAccess.get_file_as_string(PLAYER_SCRIPT))
	var seam: String = _bare(FileAccess.get_file_as_string(SEAM_SCRIPT))
	var result: String = _bare(FileAccess.get_file_as_string(RESULT_SCRIPT))
	var bodies: Dictionary = {}
	for name: String in ["set_increased_maximum_life", "increased_maximum_life", "maximum_life_baseline", "preserved_life", "life_transition_problem"]:
		bodies["player.%s" % name] = _function_body(player_code, name)
	bodies["seam.derive"] = _function_body(seam, "derive")
	bodies["seam.apply"] = _function_body(seam, "apply")
	bodies["result.problem"] = _function_body(result, "problem")
	bodies["result.applied_lines"] = _function_body(result, "applied_lines")
	var restated: RegEx = RegEx.create_from_string("(?<![0-9.])1(\\.0+)?\\s*\\+")
	var typed: PackedStringArray = PackedStringArray()
	for key: Variant in bodies:
		var body: String = bodies[key]
		if restated.search(body) != null:
			typed.append("%s restates 1 + a total" % key)
		for literal: String in _numeric_literals(body):
			if literal in ["500", "500.0", "575", "575.0", "650", "0.15", "1.15", "15", "0.3", "1.3"]:
				typed.append("%s types %s" % [key, literal])
	_expect(typed.is_empty() and bodies.size() == 9 and String(bodies["seam.derive"]).length() > 200,
		"production restates or types: %s" % ", ".join(typed))

	## The baseline is read, never remembered from a number: a detached player's is its own
	## configured maximum; a fixture configured at 400 (STAGED) is enlarged from 400; and a
	## fixture already enlarged is enlarged again from its unmodified baseline, never from 575.
	var detached: PrototypePlayer = PrototypePlayer.new()
	var detached_ok: bool = detached.increased_maximum_life() == 0.0 and detached.maximum_life_baseline() == detached.max_life
	detached.free()
	var configured: PrototypePlayer = _spawn_fixture()
	configured.max_life = 400.0
	configured.life = 400.0
	var from_400: RiftBuildApplicationResult = _apply(configured, _vitality(1))
	var c1_400: PlayerStatValue = PlayerStats.apply(PlayerStats.MAXIMUM_LIFE, 400.0, _c1(PassiveCardCatalogue.VITALITY_ID, 1).total_for(PlayerStats.MAXIMUM_LIFE))
	var held_400: String = "%s / %s, baseline %s" % [_n(configured.life), _n(configured.max_life), _n(configured.maximum_life_baseline())]
	var back_400: RiftBuildApplicationResult = _apply(configured, RiftRunBuild.new())
	var restored_400: bool = configured.max_life == 400.0 and configured.life == 400.0 and configured.maximum_life_baseline() == 400.0
	var enlarged: PrototypePlayer = _spawn_fixture()
	_apply(enlarged, _vitality(1))
	var reads: float = enlarged.maximum_life_baseline()
	var shown: float = enlarged.max_life
	var again: RiftBuildApplicationResult = RiftBuildApplication.derive(_vitality(2), enlarged, _movement_baseline())
	_staged_builds += 1
	var two: PlayerStatValue = PlayerStats.apply(PlayerStats.MAXIMUM_LIFE, reads, _c1(PassiveCardCatalogue.VITALITY_ID, 2).total_for(PlayerStats.MAXIMUM_LIFE))
	var compounded: PlayerStatValue = _c1(PassiveCardCatalogue.VITALITY_ID, 1).value_of(PlayerStats.MAXIMUM_LIFE, shown)
	var from_moved: PlayerStatValue = _c1(PassiveCardCatalogue.VITALITY_ID, 2).value_of(PlayerStats.MAXIMUM_LIFE, shown)
	_expect(detached_ok and from_400.ok and from_400.maximum_life.base_value == 400.0 and from_400.maximum_life.value == c1_400.value
			and configured.maximum_life_baseline() == 400.0 and roundi(c1_400.value) == 460 and back_400.ok and restored_400
			and reads == float(roundi(reads)) and roundi(reads) == 500 and shown != reads
			and again.ok and again.maximum_life.base_value == reads and again.maximum_life.value == two.value
			and again.maximum_life.value != compounded.value and again.maximum_life.value != from_moved.value,
		"configured 400 gave %s; an enlarged fixture reads its baseline as %s under a maximum of %s and derived %s"
			% [held_400, _n(reads), _n(shown), "nothing" if not again.ok else again.maximum_life.describe()])
	_free(configured)
	_free(enlarged)
	print("  in the player's five new functions, the seam's derive() and apply() and the result's problem() and applied_lines(): no 1 + a total restated and no Life number typed (0 of %d bodies)" % bodies.size())
	print("  a detached player holds +0%% and reads its own configured maximum as its baseline; a fixture configured at 400 (STAGED) became %s — C1's %.12f — and an empty build returned it to 400 / 400"
		% [held_400, c1_400.value])
	print("  enlarged to %s, a fixture still reads its baseline as %s; a second Vitality is derived from that baseline — %.12f, C1's answer — not %.12f (one card on the moved maximum) or %.12f (both on it)"
		% [_n(shown), _n(reads), two.value, compounded.value, from_moved.value])
	_done("c1_is_the_only_percentage_path_and_the_baseline_is_the_characters_own")


func _check_c1_answers_every_maximum_life_derivation() -> void:
	print("")
	print("--- 4. One, two and three Vitalities: the maximum is C1's exact answer for the whole total against the unmodified baseline, every time")
	var card: PassiveCardDefinition = PassiveCardCatalogue.record(PassiveCardCatalogue.VITALITY_ID)
	var fixture: PrototypePlayer = _spawn_fixture()
	var shown: Array[int] = [575, 650, 725]
	var percents: Array[String] = ["+15%", "+30%", "+45%"]
	var exact: int = 0
	var lines: PackedStringArray = PackedStringArray()
	for count: int in [1, 2, 3]:
		var build: RiftRunBuild = _vitality(count)
		var totals: PlayerStatTotals = _c1(PassiveCardCatalogue.VITALITY_ID, count)
		var baseline: float = fixture.maximum_life_baseline()
		var want: PlayerStatValue = PlayerStats.apply(PlayerStats.MAXIMUM_LIFE, baseline, totals.total_for(PlayerStats.MAXIMUM_LIFE))
		var via: PlayerStatValue = totals.value_of(PlayerStats.MAXIMUM_LIFE, baseline)
		var result: RiftBuildApplicationResult = _apply(fixture, build)
		if (result.ok and result.committed and result.problem().is_empty() and result.maximum_life.stat_id == PlayerStats.MAXIMUM_LIFE
				and result.maximum_life.base_value == baseline and result.increased_maximum_life == totals.total_for(PlayerStats.MAXIMUM_LIFE)
				and build.total_for(PlayerStats.MAXIMUM_LIFE) == totals.total_for(PlayerStats.MAXIMUM_LIFE)
				and result.maximum_life.value == want.value and result.maximum_life.value == via.value
				and result.maximum_life_after == want.value and fixture.max_life == want.value and fixture.life == want.value
				and fixture.increased_maximum_life() == totals.total_for(PlayerStats.MAXIMUM_LIFE)
				and roundi(want.value) == shown[count - 1]
				and PlayerStats.format_increased(totals.total_for(PlayerStats.MAXIMUM_LIFE)) == percents[count - 1]):
			exact += 1
		lines.append("%d Vitality: %s -> %.12f against C1's %.12f" % [count, PlayerStats.format_increased(result.increased_maximum_life),
			result.maximum_life.value if result.ok else -1.0, want.value])
	_expect(exact == 3 and card.stat_id == PlayerStats.MAXIMUM_LIFE and card.repeatable
			and PlayerStats.format_increased(card.magnitude) == "+15%",
		"%d of 3 derivations exact: %s" % [exact, "; ".join(lines)])
	_free(fixture)
	for line: String in lines:
		print("  %s" % line)
	print("  %d of 3 exactly C1's answer against the unmodified baseline, each at full Life leaving Life equal to the new maximum; the Vitality record names %s at %s and is repeatable"
		% [exact, card.stat_id, PlayerStats.format_increased(card.magnitude)])
	_done("c1_answers_every_maximum_life_derivation")


# --- 5–8. The transitions, on production player fixtures ---------------------------------------

func _check_every_transition_in_the_table_preserves_the_life_fraction() -> void:
	print("")
	print("--- 5. The brief's table, through the production seam: each maximum is C1's answer, each Life the preservation rule's, each emitted once, and each receipt line says so")
	var exact: int = 0
	var printed: PackedStringArray = PackedStringArray()
	for row: Array in TABLE:
		var fixture: PrototypePlayer = _spawn_fixture()
		if int(row[1]) > 0:
			_apply(fixture, _vitality(int(row[1])))
		if float(row[2]) > 0.0:
			_damage(fixture, float(row[2]))
		var life_before: float = fixture.life
		var maximum_before: float = fixture.max_life
		var baseline: float = fixture.maximum_life_baseline()
		var seen: Array = _listen(fixture)
		var result: RiftBuildApplicationResult = _apply(fixture, _vitality(int(row[3])))
		var want: PlayerStatValue = _c1(PassiveCardCatalogue.VITALITY_ID, int(row[3])).value_of(PlayerStats.MAXIMUM_LIFE, baseline)
		var life_after: float = PrototypePlayer.preserved_life(life_before, maximum_before, want.value)
		var stated: PackedStringArray = _maximum_life_lines(result)
		var wanted_line: String = String(row[6])
		if (result.ok and result.committed and result.problem().is_empty()
				and result.life_before == life_before and result.maximum_life_before == maximum_before
				and result.maximum_life_after == want.value and result.life_after == life_after
				and fixture.max_life == want.value and fixture.life == life_after
				and want.value == float(row[5]) and life_after == float(row[4])
				and (stated.is_empty() if wanted_line.is_empty() else stated == PackedStringArray([wanted_line]))
				and seen.size() == 1 and seen[0] == [life_after, want.value]
				and (life_before == 0.0) == (fixture.life == 0.0)
				and result.describe().count(String(row[7])) == 1):
			exact += 1
		printed.append("%s -> %s / %s, the fraction %s kept as %s, %d emission(s), line '%s', diagnostic '%s'" % [row[0],
			_n(fixture.life), _n(fixture.max_life), _n(life_before / maximum_before), _n(fixture.life / fixture.max_life),
			seen.size(), "" if stated.is_empty() else stated[0],
			String(row[7]) if result.describe().contains(String(row[7])) else "MISSING"])
		_free(fixture)
	_expect(exact == TABLE.size(), "%d of %d table rows exact: %s" % [exact, TABLE.size(), "; ".join(printed)])
	for line: String in printed:
		print("  %s" % line)
	print("  %d of %d rows: the maximum C1's answer and the Life the rule's, both to the last bit, one life_changed each, carrying exactly that Life and maximum"
		% [exact, TABLE.size()])
	_done("every_transition_in_the_table_preserves_the_life_fraction")


func _check_zero_life_is_never_revived_and_a_living_character_never_reaches_zero() -> void:
	print("")
	print("--- 6. A fallen character at zero Life stays at zero and stays fallen through every transition; a living one is never taken to zero")
	var fixture: PrototypePlayer = _spawn_fixture()
	var falls: Array = [0]
	fixture.fell.connect(func(_event: DamageEvent) -> void: falls[0] = int(falls[0]) + 1)
	_damage(fixture, fixture.life)
	var fallen: bool = not fixture.is_alive() and fixture.action_state_name() == "FALLEN" and fixture.life == 0.0
	var trail: PackedStringArray = PackedStringArray(["%s / %s %s" % [_n(fixture.life), _n(fixture.max_life), fixture.action_state_name()]])
	var kept: int = 0
	for count: int in [1, 2, 0]:
		var result: RiftBuildApplicationResult = _apply(fixture, _vitality(count))
		var want: PlayerStatValue = _c1(PassiveCardCatalogue.VITALITY_ID, count).value_of(PlayerStats.MAXIMUM_LIFE, fixture.maximum_life_baseline())
		if (result.ok and result.life_before == 0.0 and result.life_after == 0.0 and fixture.life == 0.0
				and fixture.max_life == want.value and not fixture.is_alive() and fixture.action_state_name() == "FALLEN"):
			kept += 1
		trail.append("%s / %s %s" % [_n(fixture.life), _n(fixture.max_life), fixture.action_state_name()])
	_expect(fallen and kept == 3 and int(falls[0]) == 1,
		"a fallen fixture went %s over %d fall(s)" % [" -> ".join(trail), int(falls[0])])
	_free(fixture)

	## STAGED: two extreme configurations, the only ones that reach the rule's two defensive
	## refusals — a living Life too small to survive the division, and a maximum too small to
	## survive the scale. Each is refused whole, and nothing moves.
	var tiny_life: PrototypePlayer = _spawn_fixture()
	tiny_life.max_life = 1e300
	tiny_life.life = 1e-300
	var tiny_before: String = _state(tiny_life)
	var tiny_seen: Array = _listen(tiny_life)
	var tiny: RiftBuildApplicationResult = _apply(tiny_life, _vitality(1))
	var tiny_ok: bool = (not tiny.ok and not tiny.committed and tiny.problem().is_empty()
		and tiny.failure_reason.begins_with("Maximum Life: a living character at 1e-300 of 1e+300 would keep no Life")
		and tiny.failure_reason.ends_with("; nothing was applied") and _state(tiny_life) == tiny_before and tiny_seen.is_empty())
	var tiny_maximum: PrototypePlayer = _spawn_fixture()
	tiny_maximum.max_life = pow(2.0, -1074.0)
	tiny_maximum.life = 0.0
	var small_before: String = _state(tiny_maximum)
	var small_seen: Array = _listen(tiny_maximum)
	var small: String = tiny_maximum.set_increased_maximum_life(-0.5)
	var small_ok: bool = (small == "the new Maximum Life 0 is not a positive finite number"
		and _state(tiny_maximum) == small_before and small_seen.is_empty())
	_expect(tiny_ok and small_ok, "the living guard answered '%s'; the maximum guard answered '%s'" % [tiny.failure_reason, small])
	_free(tiny_life)
	_free(tiny_maximum)
	print("  killed through receive_damage: %s — one fall, and never revived" % " -> ".join(trail))
	print("  STAGED 1e-300 Life of a 1e+300 maximum: '%s'; nothing moved" % tiny.failure_reason)
	print("  STAGED a maximum of 2^-1074 handed -50%% directly: '%s'; nothing moved" % small)
	_done("zero_life_is_never_revived_and_a_living_character_never_reaches_zero")


func _check_the_same_build_again_heals_nothing_and_says_nothing() -> void:
	print("")
	print("--- 7. The same whole build applied again moves nothing and emits nothing — at full Life, and at 450 / 575 after a real 125-point Hit")
	var fixture: PrototypePlayer = _spawn_fixture()
	var seen: Array = _listen(fixture)
	var first: RiftBuildApplicationResult = _apply(fixture, _vitality(1))
	var after_first: int = seen.size()
	var again: RiftBuildApplicationResult = _apply(fixture, _vitality(1))
	var full_ok: bool = (first.ok and again.ok and after_first == 1 and seen.size() == 1 and fixture.life == fixture.max_life
		and again.life_before == again.life_after and again.maximum_life_before == again.maximum_life_after
		and roundi(fixture.max_life) == 575)
	_damage(fixture, 125.0)
	var damaged_life: float = fixture.life
	var damaged_maximum: float = fixture.max_life
	var after_hit: int = seen.size()
	var total: float = fixture.increased_maximum_life()
	var third: RiftBuildApplicationResult = _apply(fixture, _vitality(1))
	var with_power: RiftBuildApplicationResult = _apply(fixture, _build([PassiveCardCatalogue.POWER_ID, PassiveCardCatalogue.VITALITY_ID]))
	var damaged_ok: bool = (third.ok and third.committed and fixture.life == damaged_life and fixture.max_life == damaged_maximum
		and third.life_before == damaged_life and third.life_after == damaged_life and seen.size() == after_hit
		and fixture.increased_maximum_life() == total and fixture.maximum_life_baseline() == 500.0
		and roundi(damaged_life) == 450 and with_power.ok and fixture.life == damaged_life
		and fixture.increased_global_damage() > 0.0 and seen.size() == after_hit
		and third.describe().count(DESCRIBE_SAME_AT_450) == 1)
	_expect(full_ok and damaged_ok, "the same build again: at full %s; after the Hit %s / %s with %d emission(s) after it"
		% [str(full_ok), _n(fixture.life), _n(fixture.max_life), seen.size() - after_hit])
	_free(fixture)
	print("  at full: 575 / 575 after the first application and after the second, 1 emission in all")
	print("  a real 125-point Hit through receive_damage left %s / %s; the same build again left exactly %s / %s, and adding Power to it moved Life by nothing — 0 emissions after the Hit"
		% [_n(damaged_life), _n(damaged_maximum), _n(damaged_life), _n(damaged_maximum)])
	print("  the same build again describes itself truthfully: '%s'" % (DESCRIBE_SAME_AT_450
		if third.describe().contains(DESCRIBE_SAME_AT_450) else "MISSING"))
	_done("the_same_build_again_heals_nothing_and_says_nothing")


func _check_two_vitalities_are_one_total_and_never_compound() -> void:
	print("")
	print("--- 8. Two Vitalities are one +30% total applied once to the unmodified baseline: 650, never 575's +15%")
	var fixture: PrototypePlayer = _spawn_fixture()
	_apply(fixture, _vitality(1))
	var seen: Array = _listen(fixture)
	var build: RiftRunBuild = _vitality(2)
	var two: PlayerStatValue = _c1(PassiveCardCatalogue.VITALITY_ID, 2).value_of(PlayerStats.MAXIMUM_LIFE, fixture.maximum_life_baseline())
	var compounded: PlayerStatValue = _c1(PassiveCardCatalogue.VITALITY_ID, 1).value_of(PlayerStats.MAXIMUM_LIFE, fixture.max_life)
	var result: RiftBuildApplicationResult = _apply(fixture, build)
	var once: int = seen.size()
	var again: RiftBuildApplicationResult = _apply(fixture, build)
	var back: RiftBuildApplicationResult = _apply(fixture, _vitality(1))
	_expect(result.ok and again.ok and back.ok and build.acquisitions_for(PassiveCardCatalogue.VITALITY_ID) == 2
			and result.increased_maximum_life == _c1(PassiveCardCatalogue.VITALITY_ID, 2).total_for(PlayerStats.MAXIMUM_LIFE)
			and result.maximum_life.value == two.value and result.maximum_life_after == two.value
			and roundi(two.value) == 650 and two.value != compounded.value and once == 1 and seen[0] == [two.value, two.value]
			and seen.size() == 2 and roundi(fixture.max_life) == 575 and fixture.life == fixture.max_life,
		"two Vitalities answered %s against C1's %.12f (compounded %.12f), with %d emission(s)"
			% [result.describe(), two.value, compounded.value, seen.size()])
	_free(fixture)
	print("  two acquisitions sum to %s and derive %.12f from the unmodified 500 — not %.12f, 575 at +15%%; applied again, no emission; back to one, 575 / 575"
		% [PlayerStats.format_increased(result.increased_maximum_life), two.value, compounded.value])
	_done("two_vitalities_are_one_total_and_never_compound")


# --- 9–12. Refusals, ordering, the result's shape and the signal -------------------------------

func _check_incoherent_totals_and_life_states_refuse_and_move_nothing() -> void:
	print("")
	print("--- 9. STAGED: every total C1 refuses and every incoherent Life state is refused whole — Life, maximum, both totals, speed, timing, the live record and every signal unchanged")
	var fixture: PrototypePlayer = _spawn_fixture()
	var standing: RiftRunBuild = _build([PassiveCardCatalogue.POWER_ID, PassiveCardCatalogue.CELERITY_ID,
		PassiveCardCatalogue.FLEETNESS_ID, PassiveCardCatalogue.VITALITY_ID], [[REACHING_EDGE, 1], [SWEEPING_EDGE, 1]])
	_expect_quiet(_apply(fixture, standing).ok, "the standing build was refused")
	var life_signals: Array = _listen(fixture)
	var speed_signals: Array = [0]
	fixture.attack_speed_changed.connect(func(_increased: float, _time: float) -> void: speed_signals[0] = int(speed_signals[0]) + 1)
	var before: String = _state(fixture)

	## The entry point itself, handed totals no build can hold.
	var totals: Array[float] = [NAN, INF, -INF, -1.0, -1.5]
	var refused: int = 0
	var reasons: PackedStringArray = PackedStringArray()
	for total: float in totals:
		var reason: String = fixture.set_increased_maximum_life(total)
		var c1: PlayerStatValue = PlayerStats.apply(PlayerStats.MAXIMUM_LIFE, fixture.maximum_life_baseline(), total)
		if not reason.is_empty() and not c1.ok and reason == c1.failure_reason and _state(fixture) == before:
			refused += 1
		reasons.append("%s: '%s'" % [str(total), reason])

	## The seam, handed a build that would move every covered value, over six incoherent states.
	var other: RiftRunBuild = _build([PassiveCardCatalogue.POWER_ID, PassiveCardCatalogue.POWER_ID,
		PassiveCardCatalogue.CELERITY_ID, PassiveCardCatalogue.CELERITY_ID, PassiveCardCatalogue.FLEETNESS_ID,
		PassiveCardCatalogue.FLEETNESS_ID, PassiveCardCatalogue.VITALITY_ID, PassiveCardCatalogue.VITALITY_ID],
		[[REACHING_EDGE, 2], [SWEEPING_EDGE, 2]])
	var states: Array = [
		["a Life that is not a number", NAN, 575.0], ["a negative Life", -1.0, 575.0],
		["a Life above its maximum", 600.0, 575.0], ["an infinite Life", INF, 575.0],
		["a zero maximum", 0.0, 0.0], ["a maximum that is not a number", 575.0, NAN],
	]
	var held: int = 0
	var answers: PackedStringArray = PackedStringArray()
	for state: Array in states:
		fixture.life = float(state[1])
		fixture.max_life = float(state[2])
		var staged: String = _state(fixture)
		var answer: RiftBuildApplicationResult = _apply(fixture, other)
		if (not answer.ok and not answer.committed and answer.problem().is_empty() and answer.maximum_life == null
				and answer.failure_reason.begins_with("Maximum Life: the current ")
				and answer.failure_reason.ends_with("; nothing was applied") and _state(fixture) == staged):
			held += 1
		answers.append("%s: '%s'" % [state[0], answer.failure_reason])
		fixture.max_life = 575.0
		fixture.life = 575.0
	_expect(refused == totals.size() and held == states.size() and _state(fixture) == before
			and life_signals.is_empty() and int(speed_signals[0]) == 0,
		"%d of %d totals and %d of %d states refused whole; %s against %s; %d Life and %d speed signal(s)"
			% [refused, totals.size(), held, states.size(), _state(fixture), before, life_signals.size(), int(speed_signals[0])])
	_free(fixture)
	for line: String in reasons:
		print("  entry point, %s" % line)
	for line: String in answers:
		print("  seam, %s" % line)
	print("  %d of %d totals and %d of %d incoherent states refused with nothing moved: %s" % [refused, totals.size(), held, states.size(), before])
	print("  0 life_changed and 0 attack_speed_changed signals; the +20% Global Damage the refused build carried was never written — the +10% stood")
	_done("incoherent_totals_and_life_states_refuse_and_move_nothing")


func _check_the_seam_derives_before_it_writes_and_puts_global_damage_back() -> void:
	print("")
	print("--- 10. The seam derives and checks the Life transition before any write, writes the two fallible totals first, and puts Global Damage back if the second is refused")
	var seam: String = _bare(FileAccess.get_file_as_string(SEAM_SCRIPT))
	var derive: String = _function_body(seam, "derive")
	var apply: String = _function_body(seam, "apply")
	var maximum_at: int = derive.find("totals.value_of(PlayerStats.MAXIMUM_LIFE")
	var transition_at: int = derive.find("PrototypePlayer.life_transition_problem(")
	var transition_refused: int = derive.find("return RiftBuildApplicationResult.refused(", transition_at)
	var preserved_at: int = derive.find("PrototypePlayer.preserved_life(")
	var derived_at: int = derive.find("RiftBuildApplicationResult.derived(")
	var order: Array[int] = [
		apply.find("if not result.ok:"),
		apply.find("var previous_damage: float = player.increased_global_damage()"),
		apply.find("player.set_increased_global_damage(result.increased_global_damage)"),
		apply.find("return RiftBuildApplicationResult.refused("),
		apply.find("player.set_increased_maximum_life(result.increased_maximum_life)"),
		apply.find("player.set_increased_global_damage(previous_damage)"),
		apply.find("return RiftBuildApplicationResult.refused(", apply.find("player.set_increased_global_damage(previous_damage)")),
		apply.find("live."),
		apply.find("result.committed = true"),
	]
	var ascending: bool = order[0] >= 0
	for index: int in range(1, order.size()):
		ascending = ascending and order[index] > order[index - 1]
	_expect(maximum_at >= 0 and transition_at > maximum_at and transition_refused > transition_at
			and preserved_at > transition_refused and derived_at > preserved_at
			and not derive.contains("set_increased") and not derive.contains("max_life =")
			and ascending and apply.count("set_increased_maximum_life(") == 1 and apply.count("set_increased_global_damage(") == 2
			and apply.count("derive(") == 1,
		"derive() orders its Life reading %d, %d, %d, %d, %d; apply() orders its writes %s"
			% [maximum_at, transition_at, transition_refused, preserved_at, derived_at, str(order)])
	## Behaviourally: a whole build and then an empty one, each in one call.
	var fixture: PrototypePlayer = _spawn_fixture()
	var whole: RiftBuildApplicationResult = _apply(fixture, _build([PassiveCardCatalogue.POWER_ID, PassiveCardCatalogue.VITALITY_ID]))
	var loaded: String = _state(fixture)
	var empty: RiftBuildApplicationResult = _apply(fixture, RiftRunBuild.new())
	_expect(whole.ok and whole.committed and fixture.increased_global_damage() == 0.0 and fixture.increased_maximum_life() == 0.0
			and fixture.max_life == 500.0 and fixture.life == 500.0 and empty.ok and empty.committed and loaded != _state(fixture),
		"a whole build then an empty one left %s" % _state(fixture))
	_free(fixture)
	print("  derive() reads the maximum at %d, asks the player's rule at %d, refuses at %d and only then preserves at %d and builds the result at %d; it writes nothing"
		% [maximum_at, transition_at, transition_refused, preserved_at, derived_at])
	print("  apply() tests, reads the standing Global Damage, writes it, refuses, writes Maximum Life, puts Global Damage back, refuses, and only then writes every other covered value — %s" % str(order))
	print("  STRUCTURAL ONLY: the put-back branch is read in code, not driven — derive() asks the player's own rule about the same Life first, so no coherent state reaches it")
	_done("the_seam_derives_before_it_writes_and_puts_global_damage_back")


func _check_the_result_refuses_every_incoherent_maximum_life_shape() -> void:
	print("")
	print("--- 11. STAGED: the result's own problem() refuses every incoherent Maximum Life shape, a written result included, and re-derives the Life it states")
	var fixture: PrototypePlayer = _spawn_fixture()
	_damage(fixture, 250.0)
	var one: RiftRunBuild = _vitality(1)
	var clean: RiftBuildApplicationResult = _derive(fixture, one)
	var missing: RiftBuildApplicationResult = _derive(fixture, one)
	missing.maximum_life = null
	var wrong_stat: RiftBuildApplicationResult = _derive(fixture, one)
	wrong_stat.maximum_life = PlayerStats.apply(PlayerStats.GLOBAL_DAMAGE, wrong_stat.maximum_life.base_value,
		wrong_stat.maximum_life.total_increased)
	var wrong_total: RiftBuildApplicationResult = _derive(fixture, one)
	wrong_total.increased_maximum_life = _c1(PassiveCardCatalogue.VITALITY_ID, 2).total_for(PlayerStats.MAXIMUM_LIFE)
	var wrong_value: RiftBuildApplicationResult = _derive(fixture, one)
	var held: PlayerStatValue = wrong_value.maximum_life
	wrong_value.maximum_life = PlayerStatValue.computed(PlayerStats.MAXIMUM_LIFE, held.base_value, held.total_increased,
		held.scale, held.mode, held.value + 0.000001)
	var wrong_after: RiftBuildApplicationResult = _derive(fixture, one)
	wrong_after.maximum_life_after = wrong_after.maximum_life_after + 0.000001
	var nan_life: RiftBuildApplicationResult = _derive(fixture, one)
	nan_life.life_before = NAN
	var no_maximum: RiftBuildApplicationResult = _derive(fixture, one)
	no_maximum.maximum_life_before = 0.0
	var over: RiftBuildApplicationResult = _derive(fixture, one)
	over.life_before = over.maximum_life_before + 1.0
	var healed: RiftBuildApplicationResult = _derive(fixture, one)
	healed.life_after = healed.maximum_life_after
	var nudged: RiftBuildApplicationResult = _derive(fixture, one)
	nudged.life_after = nudged.life_after + 0.000000001
	var partial_value: RiftBuildApplicationResult = RiftBuildApplicationResult.refused("staged refusal")
	partial_value.maximum_life = clean.maximum_life
	var partial_total: RiftBuildApplicationResult = RiftBuildApplicationResult.refused("staged refusal")
	partial_total.increased_maximum_life = clean.increased_maximum_life
	var partial_life: RiftBuildApplicationResult = RiftBuildApplicationResult.refused("staged refusal")
	partial_life.life_after = clean.life_after
	var partial_before: RiftBuildApplicationResult = RiftBuildApplicationResult.refused("staged refusal")
	partial_before.maximum_life_before = clean.maximum_life_before
	var written: RiftBuildApplicationResult = _apply(fixture, one)
	var written_clean: String = written.problem()
	var was_committed: bool = written.committed
	written.maximum_life = null
	fixture.life = NAN
	var state_refusal: RiftBuildApplicationResult = _derive(fixture, one)
	fixture.life = 287.5
	var refusals: Array[RiftBuildApplicationResult] = [RiftBuildApplication.derive(null, fixture, _movement_baseline()), state_refusal]
	var bare_refusals: int = 0
	for refusal: RiftBuildApplicationResult in refusals:
		if (not refusal.ok and refusal.maximum_life == null and refusal.increased_maximum_life == 0.0 and refusal.life_before == 0.0
				and refusal.maximum_life_before == 0.0 and refusal.life_after == 0.0 and refusal.maximum_life_after == 0.0
				and refusal.problem().is_empty()):
			bare_refusals += 1
	var answers: Array = [
		["a success missing its Maximum Life derivation", missing.problem(), "a derived application is missing its Maximum Life derivation"],
		["a derivation naming another stat", wrong_stat.problem(), "the Maximum Life derivation names global_damage"],
		["a copied total that is not the build's", wrong_total.problem(), "the Maximum Life total +30% is not the build's own +15%"],
		["a derivation a millionth off C1's answer", wrong_value.problem(), "the Maximum Life value 575.000001000000 is not C1's own answer 575.000000000000"],
		["a final maximum a millionth off C1's answer", wrong_after.problem(), "the final Maximum Life 575.000001000000 is not C1's own answer 575.000000000000"],
		["a prior Life that is not a number", nan_life.problem(), "the Life transition is not coherent: the current Life nan is not a finite number from 0 to the current Maximum Life 500"],
		["a prior maximum of zero", no_maximum.problem(), "the Life transition is not coherent: the current Maximum Life 0 is not a positive finite number"],
		["a prior Life above its maximum", over.problem(), "the Life transition is not coherent: the current Life 501 is not a finite number from 0 to the current Maximum Life 500"],
		["a Life after healed to the new maximum", healed.problem(), "the Life after 575.000000000000 is not the preserved 287.500000000000"],
		["a Life after a billionth off the rule", nudged.problem(), "the Life after 287.500000001000 is not the preserved 287.500000000000"],
		["a refusal carrying a Maximum Life derivation", partial_value.problem(), "a refused application must carry no partial value"],
		["a refusal carrying a Maximum Life total", partial_total.problem(), "a refused application must carry no partial value"],
		["a refusal carrying a Life after", partial_life.problem(), "a refused application must carry no partial value"],
		["a refusal carrying a prior maximum", partial_before.problem(), "a refused application must carry no partial value"],
		["a written result stripped of its derivation", written.problem(), "a derived application is missing its Maximum Life derivation"],
	]
	var wrong: PackedStringArray = PackedStringArray()
	for row: Array in answers:
		if String(row[1]) != String(row[2]):
			wrong.append("%s: '%s'" % [row[0], row[1]])
	_expect(clean.ok and not clean.committed and clean.problem().is_empty() and held.problem().is_empty()
			and wrong_value.maximum_life.problem().is_empty() and written_clean.is_empty() and was_committed
			and clean.life_after == 287.5 and wrong.is_empty() and bare_refusals == refusals.size(),
		"refusals answered: %s; %d of %d seam refusals carried no Maximum Life state" % ["; ".join(wrong), bare_refusals, refusals.size()])
	_free(fixture)
	for row: Array in answers:
		print("  %s: '%s'" % [row[0], row[1]])
	print("  a clean derivation and a clean written result answer ''; the millionth-off derivations pass PlayerStatValue.problem()'s approximate test and are caught only by the bit-exact re-derivation")
	print("  %d of %d seam refusals carry no Maximum Life derivation, a +0%% total and no Life fact" % [bare_refusals, refusals.size()])
	_done("the_result_refuses_every_incoherent_maximum_life_shape")


func _check_life_changed_fires_once_per_real_transition_and_never_for_a_no_op() -> void:
	print("")
	print("--- 12. life_changed fires exactly once for every transition that moves Life or its maximum, carrying the new pair, and never for one that moves neither")
	var fixture: PrototypePlayer = _spawn_fixture()
	var seen: Array = _listen(fixture)
	var steps: Array = [
		["an empty build", 0], ["one Vitality", 1], ["one Vitality again", 1], ["two Vitalities", 2],
		["two Vitalities again", 2], ["an empty build", 0], ["an empty build again", 0],
	]
	var wanted: Array[int] = [0, 1, 0, 1, 0, 1, 0]
	var counted: Array[int] = []
	var paired: int = 0
	for step: Array in steps:
		var before: int = seen.size()
		_apply(fixture, _vitality(int(step[1])))
		counted.append(seen.size() - before)
		if seen.size() == before or seen.back() == [fixture.life, fixture.max_life]:
			paired += 1
	var quiet: PrototypePlayer = _spawn_fixture()
	var quiet_seen: Array = _listen(quiet)
	_apply(quiet, _build([PassiveCardCatalogue.POWER_ID, PassiveCardCatalogue.CELERITY_ID, PassiveCardCatalogue.FLEETNESS_ID]))
	_expect(counted == wanted and paired == steps.size() and quiet_seen.is_empty(),
		"emissions %s against %s; %d of %d paired; a build without Vitality emitted %d" % [str(counted), str(wanted), paired,
			steps.size(), quiet_seen.size()])
	_free(fixture)
	_free(quiet)
	var named: PackedStringArray = PackedStringArray()
	for index: int in steps.size():
		named.append("%s %d" % [steps[index][0], counted[index]])
	print("  %s; each emission carried the Life and maximum the character then held" % ", ".join(named))
	print("  Power, Celerity and Fleetness on a fixture holding no Vitality: 0 life_changed")
	_done("life_changed_fires_once_per_real_transition_and_never_for_a_no_op")


# --- 13–15. The receipt ---------------------------------------------------------------------------

func _check_the_receipt_states_maximum_life_as_live_and_never_as_held() -> void:
	print("")
	print("--- 13. The receipt states Maximum Life as live — the baseline, C1's answer and the Life kept — never under the held heading, and never rounds a fraction into a whole")
	var fixture: PrototypePlayer = _spawn_fixture()
	var full: RiftBuildApplicationResult = _derive(fixture, _vitality(1))
	_apply(fixture, _vitality(1))
	_damage(fixture, 125.0)
	var damaged: RiftBuildApplicationResult = _derive(fixture, _vitality(1))
	var emptied: RiftBuildApplicationResult = _derive(fixture, RiftRunBuild.new())
	fixture.life = 574.77
	var near: RiftBuildApplicationResult = _derive(fixture, _vitality(1))
	_free(fixture)
	var halved: PrototypePlayer = _spawn_fixture()
	_damage(halved, 250.0)
	var half: RiftBuildApplicationResult = _derive(halved, _vitality(1))
	_free(halved)
	var reader: PrototypePlayer = _spawn_fixture()
	var with_insight: RiftBuildApplicationResult = _derive(reader, _build([PassiveCardCatalogue.INSIGHT_ID, PassiveCardCatalogue.VITALITY_ID]))
	var every_card: RiftBuildApplicationResult = _derive(reader, _build([PassiveCardCatalogue.POWER_ID, PassiveCardCatalogue.CELERITY_ID,
		PassiveCardCatalogue.VITALITY_ID, PassiveCardCatalogue.FLEETNESS_ID, PassiveCardCatalogue.INSIGHT_ID, PassiveCardCatalogue.MAGNETISM_ID]))
	_free(reader)
	var vitality_receipt: String = RogueliteLiveEffectReview.live_receipt_for(full)
	var insight_receipt: String = RogueliteLiveEffectReview.live_receipt_for(with_insight)
	var rule: float = PrototypePlayer.preserved_life(emptied.life_before, emptied.maximum_life_before, emptied.maximum_life_after)
	var lines: Array = [
		["full", _maximum_life_lines(full), FULL_LIFE_LINE],
		["half", _maximum_life_lines(half), "Maximum Life 500 → 575 · Life preserved at 50%"],
		["450 / 575, the same build", _maximum_life_lines(damaged), "Maximum Life 500 → 575 · Life preserved at 78.3%"],
		["574.77 / 575 (STAGED), the same build", _maximum_life_lines(near), "Maximum Life 500 → 575 · Life preserved at 99.96%"],
	]
	var wrong: PackedStringArray = PackedStringArray()
	for row: Array in lines:
		if row[1] != PackedStringArray([String(row[2])]):
			wrong.append("%s: %s" % [row[0], str(row[1])])
	_expect(wrong.is_empty() and _maximum_life_lines(emptied).is_empty() and emptied.life_after == rule
			and emptied.life_after != 391.3 and roundi(emptied.maximum_life_after) == 500
			and vitality_receipt == LIVE_PREFIX + FULL_LIFE_LINE and not vitality_receipt.contains(HELD_HEADING)
			and insight_receipt == LIVE_PREFIX + FULL_LIFE_LINE + "\n" + HELD_HEADING + "\nExperience Gain +10% — applied by the run's own mote path"
			and not insight_receipt.get_slice(HELD_HEADING, 1).contains("Maximum Life")
			and full.deferred_stats.is_empty() and every_card.ok and every_card.deferred_stats.is_empty()
			and not "\n".join(every_card.held_lines()).contains("Maximum Life") and not "\n".join(every_card.held_lines()).contains("held —"),
		"lines %s; an empty build over 450 / 575 left %.12f against the rule's %.12f; receipts '%s' and '%s'"
			% ["; ".join(wrong), emptied.life_after, rule, vitality_receipt.replace("\n", " / "), insight_receipt.replace("\n", " / ")])
	for row: Array in lines:
		print("  %s: '%s'" % [row[0], (row[1] as PackedStringArray)[0] if not (row[1] as PackedStringArray).is_empty() else ""])
	print("  an empty build over 450 / 575: no Maximum Life line, and the Life it leaves is the rule's %.12f — unrounded; the receipt only formats" % emptied.life_after)
	print("  Vitality alone: '%s'; beside Insight: '%s'" % [vitality_receipt.replace("\n", " / "), insight_receipt.replace("\n", " / ")])
	print("  every card at once: held lines %s — the seam defers nothing" % str(every_card.held_lines()))
	_done("the_receipt_states_maximum_life_as_live_and_never_as_held")


func _check_power_and_vitality_are_both_live() -> void:
	print("")
	print("--- 14. Power and Vitality together: both live, both under \"Live now —\", nothing held; the weapon record untouched")
	var fixture: PrototypePlayer = _spawn_fixture()
	var result: RiftBuildApplicationResult = _apply(fixture, _build([PassiveCardCatalogue.POWER_ID, PassiveCardCatalogue.VITALITY_ID]))
	var damage: PlayerStatValue = _c1(PassiveCardCatalogue.POWER_ID, 1).value_of(PlayerStats.GLOBAL_DAMAGE, fixture.physical_damage)
	var maximum: PlayerStatValue = _c1(PassiveCardCatalogue.VITALITY_ID, 1).value_of(PlayerStats.MAXIMUM_LIFE, fixture.maximum_life_baseline())
	var outgoing: PlayerStatValue = fixture.outgoing_hit_damage(fixture.physical_damage)
	var receipt: String = RogueliteLiveEffectReview.live_receipt_for(result)
	_expect(result.ok and result.committed and result.applied_lines() == PackedStringArray([DAMAGE_LINE, FULL_LIFE_LINE])
			and result.held_lines().is_empty() and receipt == LIVE_PREFIX + DAMAGE_LINE + "\n" + FULL_LIFE_LINE
			and receipt.count(LIVE_PREFIX) == 1 and not receipt.contains(HELD_HEADING)
			and result.global_damage.value == damage.value and outgoing.value == damage.value
			and fixture.max_life == maximum.value and fixture.life == maximum.value
			and fixture.physical_damage == float(_records_at_start["starter"]) and roundi(outgoing.value) == 110,
		"Power and Vitality answered %s: '%s'" % [str(result.applied_lines()), receipt.replace("\n", " / ")])
	_free(fixture)
	print("  '%s'" % receipt.replace("\n", " / "))
	print("  a Hit's damage %.12f and the maximum %.12f, each C1's answer; Life %s / %s; the training sword still reads %.0f"
		% [outgoing.value, maximum.value, _n(maximum.value), _n(maximum.value), float(_records_at_start["starter"])])
	_done("power_and_vitality_are_both_live")


func _check_every_accepted_effect_line_is_unchanged_beside_vitality() -> void:
	print("")
	print("--- 15. Beside Vitality every accepted support, Skill Speed, movement and damage effect is the same value and the same words; the one new line comes last")
	var cards: Array = [PassiveCardCatalogue.POWER_ID, PassiveCardCatalogue.CELERITY_ID, PassiveCardCatalogue.FLEETNESS_ID]
	var supports: Array = [[REACHING_EDGE, 2], [SWEEPING_EDGE, 2]]
	var without: PrototypePlayer = _spawn_fixture()
	var with: PrototypePlayer = _spawn_fixture()
	var plain: RiftBuildApplicationResult = _apply(without, _build(cards, supports))
	var enlarged: RiftBuildApplicationResult = _apply(with, _build(cards + [PassiveCardCatalogue.VITALITY_ID], supports))
	var accepted: PackedStringArray = PackedStringArray([SPATIAL_LINE, ACTION_LINE, MOVEMENT_LINE, DAMAGE_LINE])
	var extended: PackedStringArray = accepted.duplicate()
	extended.append(FULL_LIFE_LINE)
	## Roguelite I14's correction (D-321): describe() now states the Maximum Life derivation and the Life
	## transition, so the two descriptions differ — and they differ ONLY there. With each build's own
	## segment removed, what is left is word for word the same.
	var plain_text: String = plain.describe()
	var enlarged_text: String = enlarged.describe()
	_expect(plain.ok and enlarged.ok and plain.applied_lines() == accepted and enlarged.applied_lines() == extended
			and _effects(without) == _effects(with) and plain_text != enlarged_text
			and plain_text.count(DESCRIBE_PLAIN) == 1 and enlarged_text.count(DESCRIBE_VITALITY) == 1
			and plain_text.replace(DESCRIBE_PLAIN, "") == enlarged_text.replace(DESCRIBE_VITALITY, "")
			and plain.held_lines().is_empty() and enlarged.held_lines().is_empty()
			and without.max_life == 500.0 and roundi(with.max_life) == 575,
		"without Vitality %s; with it %s; effects %s against %s" % [str(plain.applied_lines()), str(enlarged.applied_lines()),
			str(_effects(without)), str(_effects(with))])
	_free(without)
	_free(with)
	for line: String in extended:
		print("  | %s" % line)
	print("  reach, arc, cone, targets, action time, movement, Global Damage and the damage reading identical with and without Vitality; the seam's two descriptions differ only in '%s' against '%s', and are otherwise word for word the same"
		% [DESCRIBE_PLAIN, DESCRIBE_VITALITY])
	_done("every_accepted_effect_line_is_unchanged_beside_vitality")


# --- The review: expedition A, seed 99, Vitality at the Level 5 fallback --------------------------

func _expedition_a() -> void:
	await _begin_expedition("A")
	_baseline = _live_values()
	await _open_level_one()
	_standing.append(_standing_snapshot("Level 1, opened on its own"))
	_take_support()
	await _settle(4)
	await _award_and_wait([LEVEL_TWO_AMOUNT])
	_standing.append(_standing_snapshot("Level 2, opened on its own"))
	_take_support()
	await _settle(4)
	await _award_and_wait(CHAIN_AMOUNTS)
	_standing.append(_standing_snapshot("Level 3, opened on its own with 525 banked"))
	_take_support()
	_standing.append(_standing_snapshot("Level 4, in place of Level 3's in the same call"))
	_take_support()
	_standing.append(_standing_snapshot("Level 5 fallback, in place of Level 4's in the same call"))
	_check_before_vitality_the_offers_hold_the_world_and_hide_the_receipts()

	await _choose_vitality()
	_check_vitality_is_live_in_the_choices_own_call()
	await _await_process_frames(1)
	_quiet_room(2)
	await _capture("01_level_six_vitality_live", 1.2)
	_receipt_measure = await _measure_receipt(VITALITY_RECEIPT.size(), "the Level 6 Vitality receipt")
	_check_the_level_six_receipt_states_maximum_life_under_live_now()
	await _check_a_real_graveblade_hit_takes_its_own_125_from_575()
	_check_the_same_held_build_again_does_not_heal()


## D-pad right to the Combat and Defence card, then (A), read in that press's own call stack —
## before any frame can pass — then released.
func _choose_vitality() -> void:
	await _joy(JOY_BUTTON_DPAD_RIGHT)
	var focused: bool = root.gui_get_focus_owner() == review.level_up_panel.card_buttons()[1]
	var before: Dictionary = _live_values()
	var choices: int = review.choices_taken
	var applications: int = review.applications_made
	var seen: Array = []
	var listener: Callable = func(current: float, maximum: float) -> void: seen.append([current, maximum])
	review.player.life_changed.connect(listener)
	var physics: int = Engine.get_physics_frames()
	var process: int = Engine.get_process_frames()
	_push_joy(JOY_BUTTON_A, true)
	_chosen = {
		"focused": focused, "before": before, "after": _live_values(),
		"same_frame": Engine.get_physics_frames() == physics and Engine.get_process_frames() == process,
		"choices": review.choices_taken - choices, "applications": review.applications_made - applications,
		"open": review.level_up_panel.is_open, "level": review.mote_runtime.level(), "hud": _life_text(),
		"live_line": review.live_receipt_text(), "application": review.last_application,
		"record": review.last_choice_record, "emissions": seen.duplicate(),
	}
	review.player.life_changed.disconnect(listener)
	_push_joy(JOY_BUTTON_A, false)


func _check_before_vitality_the_offers_hold_the_world_and_hide_the_receipts() -> void:
	print("")
	print("--- 16. Before Vitality: every standing offer holds the world still, shows only the standing receipt and no live line, and the character stands at 500 / 500 holding no Maximum Life")
	var faults: PackedStringArray = PackedStringArray()
	for snap: Dictionary in _standing:
		if not (bool(snap["open"]) and bool(snap["paused"]) and snap["receipt"] == PackedStringArray(STANDING_LINES)
				and not bool(snap["live_shown"]) and float(snap["life"]) == 500.0 and float(snap["max_life"]) == 500.0
				and float(snap["maximum"]) == 0.0 and String(snap["hud"]) == LIFE_BEFORE_LINE):
			faults.append("%s: %s" % [snap["label"], str(snap)])
	_expect(_standing.size() == 5 and faults.is_empty() and review.applications_made == 4 and review.application_refusals == 0,
		"%d standing moments; %s" % [_standing.size(), "; ".join(faults)])
	for snap: Dictionary in _standing:
		print("  %s: paused, the receipt shows only '%s', no live line; %s" % [snap["label"], (snap["receipt"] as PackedStringArray)[1], snap["hud"]])
	print("  4 applications before the fallback, 0 refusals; +0% Maximum Life held behind the standing Level 5 offer")
	_done("before_vitality_the_offers_hold_the_world_and_hide_the_receipts")


func _check_vitality_is_live_in_the_choices_own_call() -> void:
	print("")
	print("--- 17. (A) on the fallback's Vitality: in that press's own call, before another frame, the choice commits once and Maximum Life is live at 575 / 575")
	var taken: Dictionary = _chosen
	var before: Dictionary = taken["before"]
	var after: Dictionary = taken["after"]
	var application: RiftBuildApplicationResult = taken["application"]
	var record: RiftRunLevelUpResult = taken["record"]
	var receipt: RiftLevelUpResult = null if record == null else record.level_up()
	var want: PlayerStatValue = _c1(PassiveCardCatalogue.VITALITY_ID, 1).value_of(PlayerStats.MAXIMUM_LIFE, float(before["baseline"]))
	var build: RiftRunBuild = review.mote_runtime.run_build()
	var unmoved: PackedStringArray = PackedStringArray()
	for key: String in ["reach", "arc", "cone", "targets", "max_speed", "effective", "weapon_damage", "global", "outgoing"]:
		if after[key] != before[key]:
			unmoved.append(key)
	_expect(bool(taken["focused"]) and bool(taken["same_frame"]) and int(taken["choices"]) == 1 and int(taken["applications"]) == 1
			and not bool(taken["open"]) and int(taken["level"]) == 6 and receipt != null and record.succeeded() and receipt.lane == 1
			and receipt.granted_identity() == PackedStringArray([String(PassiveCardCatalogue.VITALITY_ID)])
			and application != null and application.ok and application.committed and application.problem().is_empty()
			and application.maximum_life.value == want.value and application.life_before == 500.0
			and application.maximum_life_before == 500.0 and application.life_after == want.value
			and float(after["max_life"]) == want.value and float(after["life"]) == want.value and roundi(want.value) == 575
			and String(taken["hud"]) == LIFE_LIVE_LINE and taken["emissions"] == [[want.value, want.value]]
			and unmoved.is_empty() and float(after["global"]) == 0.0 and float(after["outgoing"]) == float(after["weapon_damage"])
			and roundi(float(after["outgoing"])) == 100 and float(after["reach"]) == 3.65 and float(after["arc"]) == 260.0
			and float(after["cone"]) == 155.0 and float(after["maximum"]) == want.total_increased and float(after["baseline"]) == 500.0
			and build.total_for(PlayerStats.MAXIMUM_LIFE) == want.total_increased
			and build.acquisitions_for(PassiveCardCatalogue.VITALITY_ID) == 1
			and String(taken["live_line"]) == LIVE_VITALITY and review.application_refusals == 0,
		"the Vitality press: focused %s, same frame %s, %s -> %s, the HUD '%s', emissions %s, moved %s"
			% [str(taken["focused"]), str(taken["same_frame"]), _live_line(before), _live_line(after), taken["hud"],
				str(taken["emissions"]), ", ".join(unmoved)])
	print("  in the (A) press's own call — physics and process frames unchanged — the choice committed once, the panel closed at Rift level %d and the record granted [%s]"
		% [int(taken["level"]), ", ".join(receipt.granted_identity() if receipt != null else PackedStringArray())])
	print("  %s -> %s" % [_live_line(before), _live_line(after)])
	print("  Maximum Life %.12f — C1's answer for +15%% on the unmodified 500 — with Life kept at 100%%; one life_changed, %s; the HUD reads '%s' in that same call"
		% [want.value, str(taken["emissions"]), taken["hud"]])
	_done("vitality_is_live_in_the_choices_own_call")


func _check_the_level_six_receipt_states_maximum_life_under_live_now() -> void:
	print("")
	print("--- 18. The Level 6 receipt states Maximum Life under \"Live now —\" beside the rank-two spatial values; nothing is held")
	var application: RiftBuildApplicationResult = review.last_application
	var live_line: String = review.live_receipt_text()
	_expect(_receipt_lines() == PackedStringArray(VITALITY_RECEIPT) and live_line == LIVE_VITALITY
			and live_line == LIVE_PREFIX + "\n".join(application.applied_lines()) and live_line.count(LIVE_PREFIX) == 1
			and not live_line.contains(HELD_HEADING) and not live_line.contains("held —") and not live_line.contains("damage")
			and application.applied_lines().size() == 2 and application.applied_lines()[1] == FULL_LIFE_LINE
			and application.held_lines().is_empty() and application.deferred_stats.is_empty()
			and review.live_receipt_control().is_visible_in_tree() and not paused and _life_text() == LIFE_LIVE_LINE,
		"the receipt reads %s" % str(_receipt_lines()))
	for line: String in _receipt_lines():
		print("  | %s" % line.replace("\n", " / "))
	print("  \"Live now —\" appears once; Maximum Life is its second line; no held heading; the HUD reads '%s'" % _life_text())
	print("  %s" % _receipt_measure)
	_done("the_level_six_receipt_states_maximum_life_under_live_now")


func _check_a_real_graveblade_hit_takes_its_own_125_from_575() -> void:
	print("")
	print("--- 19. STAGED start, real Hit: a Graveblade's attack lands on the enlarged character for exactly its own record's 125 — 575 -> 450 — and the HUD follows")
	var centre: Vector3 = _elite_hall_centre()
	var forward: Vector3 = _forward()
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	elite.place_at(centre - forward * 7.0)
	_stand_facing(centre, forward)
	await _settle(2)
	escort.place_at(centre + forward * NEAR)
	await _settle(3)
	var recorded: float = float((load(GRAVEBLADE_RECORD) as Resource).get("physical_damage"))
	var life_before: float = review.player.life
	var maximum_before: float = review.player.max_life
	var total: float = review.player.increased_maximum_life()
	var taken_before: int = review.player.damage_taken_events
	var seen: Array = []
	var listener: Callable = func(current: float, maximum: float) -> void: seen.append([current, maximum])
	review.player.life_changed.connect(listener)
	var began: bool = false
	for attempt: int in 90:
		began = escort.begin_attack_for_verification()
		if began:
			break
		await physics_frame
	for frame: int in 180:
		await physics_frame
		if review.player.damage_taken_events > taken_before:
			break
	await _await_process_frames(1)
	review.player.life_changed.disconnect(listener)
	var event: DamageEvent = review.player.last_damage_taken
	_hit = {"before": life_before, "after": review.player.life, "maximum": review.player.max_life}
	_expect(began and review.player.damage_taken_events == taken_before + 1 and event != null and event.source == escort
			and event.raw_physical_damage == recorded and event.final_life_damage == recorded
			and escort.data.physical_damage == recorded and escort.data.resource_path == GRAVEBLADE_RECORD
			and roundi(life_before) == 575 and review.player.life == life_before - recorded and roundi(review.player.life) == 450
			and review.player.max_life == maximum_before and review.player.is_alive()
			and review.player.increased_maximum_life() == total and seen == [[review.player.life, review.player.max_life]]
			and _life_text() == LIFE_HIT_LINE and roundi(recorded) == 125,
		"the Graveblade began %s and dealt %s against its record's %.0f; Life %s -> %s / %s; the HUD '%s'"
			% [str(began), "nothing" if event == null else event.describe(), recorded, _n(life_before), _n(review.player.life),
				_n(review.player.max_life), _life_text()])
	print("  the escort's one Hit carried raw %.12f and final %.12f — its record's own %.0f — and Life went %s -> %s of %s; one life_changed; the HUD reads '%s'"
		% [event.raw_physical_damage if event != null else 0.0, event.final_life_damage if event != null else 0.0, recorded,
			_n(life_before), _n(review.player.life), _n(review.player.max_life), _life_text()])
	await _capture("02_graveblade_hit_450_of_575", 1.2)
	_done("a_real_graveblade_hit_takes_its_own_125_from_575")


func _check_the_same_held_build_again_does_not_heal() -> void:
	print("")
	print("--- 20. STAGED: the run's own held build handed to the seam once more at 450 / 575 — nothing moves, nothing heals, nothing is emitted")
	var build: RiftRunBuild = review.mote_runtime.run_build()
	var life_before: float = review.player.life
	var maximum_before: float = review.player.max_life
	var total: float = review.player.increased_maximum_life()
	var effects: Dictionary = _effects(review.player)
	var applications: int = review.applications_made
	var line: String = review.live_receipt_text()
	var seen: Array = []
	var listener: Callable = func(current: float, maximum: float) -> void: seen.append([current, maximum])
	review.player.life_changed.connect(listener)
	var again: RiftBuildApplicationResult = RiftBuildApplication.apply(build, review.player, _movement_baseline())
	review.player.life_changed.disconnect(listener)
	_expect(again.ok and again.committed and again.problem().is_empty() and again.life_before == life_before
			and again.life_after == life_before and again.maximum_life_after == maximum_before
			and review.player.life == life_before and review.player.max_life == maximum_before and roundi(life_before) == 450
			and seen.is_empty() and review.player.increased_maximum_life() == total and review.player.maximum_life_baseline() == 500.0
			and _effects(review.player) == effects and review.applications_made == applications
			and review.live_receipt_text() == line and _life_text() == LIFE_HIT_LINE,
		"the held build again left %s / %s with %d emission(s)" % [_n(review.player.life), _n(review.player.max_life), seen.size()])
	print("  the held build again: %s / %s before and after, 0 life_changed, every covered value and the receipt unchanged"
		% [_n(life_before), _n(maximum_before)])
	_done("the_same_held_build_again_does_not_heal")


# --- The expedition's end, the next one, and the records -----------------------------------------

func _check_f5_restores_the_baseline_through_the_empty_build() -> void:
	print("")
	print("--- 21. F5 at 450 / 575: the one empty-build restoration keeps Life's fraction as it returns the maximum to 500, the core loop's own revive then restores Life, and nothing is left held")
	var before: Dictionary = _live_values()
	var restorations: int = review.restorations_made
	var seen: Array = []
	var listener: Callable = func(current: float, maximum: float) -> void: seen.append([current, maximum])
	review.player.life_changed.connect(listener)
	await _key(KEY_F5)
	await _settle(4)
	review.player.life_changed.disconnect(listener)
	var after: Dictionary = _live_values()
	var restored: RiftBuildApplicationResult = review.last_restoration
	var kept: float = PrototypePlayer.preserved_life(float(before["life"]), float(before["max_life"]), 500.0)
	_expect(review.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB and review.mote_runtime == null
			and review.restorations_made == restorations + 1 and restored != null and restored.ok and restored.committed
			and restored.problem().is_empty() and restored.increased_maximum_life == 0.0
			and restored.maximum_life.value == restored.maximum_life.base_value and restored.maximum_life_after == 500.0
			and restored.life_before == float(before["life"]) and restored.maximum_life_before == float(before["max_life"])
			and roundi(restored.life_before) == 450 and restored.life_after == kept
			and not seen.is_empty() and seen[0] == [kept, 500.0] and seen.back() == [500.0, 500.0]
			and after == _baseline and review.player.increased_maximum_life() == 0.0 and review.player.maximum_life_baseline() == 500.0
			and review.last_application == null and review.live_receipt_text().is_empty() and _life_text() == LIFE_BEFORE_LINE
			and not paused,
		"F5: %s -> %s against %s; emissions %s" % [_live_line(before), _live_line(after), _live_line(_baseline), str(seen)])
	print("  %s -> %s" % [_live_line(before), _live_line(after)])
	print("  the restoration ran at %s / %s and kept the fraction: %.12f / 500, the rule's answer — its own one emission, %s; then the core loop's revive: %s"
		% [_n(restored.life_before), _n(restored.maximum_life_before), restored.life_after, str(seen[0]) if not seen.is_empty() else "none",
			str(seen.slice(1))])
	print("  +0%% Maximum Life held, baseline %s, no application, no live line; the HUD reads '%s'" % [_n(review.player.maximum_life_baseline()), _life_text()])
	_done("f5_restores_the_baseline_through_the_empty_build")


func _check_the_next_expedition_starts_at_the_baseline() -> void:
	print("")
	print("--- 22. The next expedition begins at 500 / 500 with an empty build, +0% Maximum Life and no receipt: nothing of Vitality leaks into it")
	await _begin_expedition("B")
	var build: RiftRunBuild = review.mote_runtime.run_build()
	var live: Dictionary = _live_values()
	_expect(build.is_empty() and build.total_for(PlayerStats.MAXIMUM_LIFE) == 0.0
			and build.acquisitions_for(PassiveCardCatalogue.VITALITY_ID) == 0 and live == _baseline
			and review.player.life == 500.0 and review.player.max_life == 500.0 and review.player.increased_maximum_life() == 0.0
			and review.player.maximum_life_baseline() == 500.0 and review.last_application == null
			and review.live_receipt_text().is_empty() and not review.live_receipt_control().is_visible_in_tree()
			and _life_text() == LIFE_BEFORE_LINE and review.mote_runtime.level() == 1 and review.mote_runtime.run_seed() == ROUTE_SEED,
		"B began with %s / %s" % [build.describe(), _live_line(live)])
	print("  B began at Rift level 1, run seed %d: an empty build, card_vitality 0, %s; the HUD reads '%s'; no application and no live line"
		% [ROUTE_SEED, _live_line(live), _life_text()])
	_done("the_next_expedition_starts_at_the_baseline")


func _check_no_record_or_card_moved() -> void:
	print("")
	print("--- 23. No weapon, Skill, Quick Strike, Graveblade, card or stat record moved anywhere in this run")
	var now: Dictionary = _record_snapshot()
	var moved: PackedStringArray = PackedStringArray()
	for key: Variant in _records_at_start:
		if str(now[key]) != str(_records_at_start[key]):
			moved.append(String(key))
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	var canonical: QuickStrikeData = review.player.attack.canonical_data
	_expect(moved.is_empty() and now.size() == _records_at_start.size() and now.size() >= 15
			and escort.data.physical_damage == float(_records_at_start["graveblade"][0])
			and canonical.reach == float(_records_at_start["quick_strike"][0]) and review.player.attack.data_is_private(),
		"records moved: %s" % ", ".join(moved))
	print("  %d records read at the start and again now, 0 moved: the three swords, both Graveblade records, the canonical Quick Strike, the three Skills, the six cards and the Maximum Life definition"
		% now.size())
	_done("no_record_or_card_moved")


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


# --- Fixture helpers ---------------------------------------------------------------------------------

## One production player, whole, on this harness's own stage, far from the review's rooms and
## with its processing disabled.
func _spawn_fixture() -> PrototypePlayer:
	_fixture_players += 1
	var fixture: PrototypePlayer = (load(PLAYER_SCENE) as PackedScene).instantiate() as PrototypePlayer
	fixture.name = "I14Player%d" % _fixture_players
	fixture.process_mode = Node.PROCESS_MODE_DISABLED
	fixture.position = Vector3(400.0 + 4.0 * float(_fixture_players), 40.0, 400.0)
	_stage.add_child(fixture)
	return fixture


func _free(fixture: PrototypePlayer) -> void:
	fixture.queue_free()


func _movement_baseline() -> float:
	return BrokenWatchSlice.ACCEPTED_MAX_SPEED


func _apply(fixture: PrototypePlayer, build: RiftRunBuild) -> RiftBuildApplicationResult:
	_staged_builds += 1
	return RiftBuildApplication.apply(build, fixture, _movement_baseline())


func _derive(fixture: PrototypePlayer, build: RiftRunBuild) -> RiftBuildApplicationResult:
	_staged_builds += 1
	return RiftBuildApplication.derive(build, fixture, _movement_baseline())


## Damage through the production intake, `receive_damage()`, with a DamageEvent made here.
func _damage(fixture: PrototypePlayer, amount: float) -> void:
	fixture.receive_damage(DamageEvent.physical(_use(), null, fixture, amount))


## Every `life_changed` the fixture emits from now on, as [Life, maximum] pairs.
func _listen(fixture: PrototypePlayer) -> Array:
	var seen: Array = []
	fixture.life_changed.connect(func(current: float, maximum: float) -> void: seen.append([current, maximum]))
	return seen


## Everything a partial write could move, exactly; NaN reads as itself.
func _state(fixture: PrototypePlayer) -> String:
	var strike: QuickStrikeData = fixture.attack.data
	var parts: PackedStringArray = PackedStringArray()
	for value: float in [fixture.life, fixture.max_life, fixture.increased_maximum_life(), fixture.maximum_life_baseline(),
			fixture.increased_global_damage(), fixture.max_speed, fixture.increased_attack_speed(), strike.reach,
			strike.release_arc_degrees, strike.soft_target_cone_degrees]:
		parts.append(_n(value))
	parts.append(fixture.action_state_name())
	return " | ".join(parts)


func _effects(player: PrototypePlayer) -> Dictionary:
	var strike: QuickStrikeData = player.attack.data
	return {
		"reach": strike.reach, "arc": strike.release_arc_degrees, "cone": strike.soft_target_cone_degrees,
		"targets": strike.maximum_targets, "increased": player.increased_attack_speed(),
		"effective": player.attack.effective_action_time(), "max_speed": player.max_speed,
		"global": player.increased_global_damage(), "outgoing": player.outgoing_hit_damage(player.physical_damage).value,
	}


## A run build of the accepted card records, and Quick Strike supports at the given ranks.
func _build(cards: Array, supports: Array = []) -> RiftRunBuild:
	var build: RiftRunBuild = RiftRunBuild.new()
	for card: Variant in cards:
		_expect_quiet(build.acquire_passive_card(PassiveCardCatalogue.record(card as StringName)).is_empty(),
			"the build refused %s" % card)
	for pair: Variant in supports:
		var support: StringName = (pair as Array)[0]
		_expect_quiet(build.acquire_support(QUICK_STRIKE, support).is_empty(), "the build refused %s" % support)
		for rank: int in range(1, int((pair as Array)[1])):
			_expect_quiet(build.rank_support(QUICK_STRIKE, support).is_empty(), "the build refused %s's rank" % support)
	return build


func _vitality(count: int) -> RiftRunBuild:
	var cards: Array = []
	for index: int in count:
		cards.append(PassiveCardCatalogue.VITALITY_ID)
	return _build(cards)


## C1's own accumulator holding one accepted card's own magnitude `count` times —
## independent of the run build, the seam and the player.
func _c1(card_id: StringName, count: int) -> PlayerStatTotals:
	var totals: PlayerStatTotals = PlayerStatTotals.new()
	var card: PassiveCardDefinition = PassiveCardCatalogue.record(card_id)
	for index: int in count:
		_expect_quiet(totals.add(card.stat_id, card.magnitude).is_empty(), "C1 refused %s %d" % [card_id, index + 1])
	return totals


func _maximum_life_lines(result: RiftBuildApplicationResult) -> PackedStringArray:
	var lines: PackedStringArray = PackedStringArray()
	for line: String in result.applied_lines():
		if line.begins_with("Maximum Life"):
			lines.append(line)
	return lines


func _n(value: float) -> String:
	return String.num_scientific(value)


## Every weapon, Skill, Quick Strike, Graveblade, card and stat number this run could have moved.
func _record_snapshot() -> Dictionary:
	var graveblade: Resource = load(GRAVEBLADE_RECORD)
	var elite: Resource = load(ELITE_RECORD)
	var strike: QuickStrikeData = load(CANONICAL_QUICK_STRIKE) as QuickStrikeData
	var snapshot: Dictionary = {
		"starter": (load(STARTER_SWORD) as PrototypeWeaponData).physical_damage,
		"worn": (load(WORN_SWORD) as PrototypeWeaponData).physical_damage,
		"honed": (load(HONED_SWORD) as PrototypeWeaponData).physical_damage,
		"graveblade": [float(graveblade.get("physical_damage")), float(graveblade.get("max_life"))],
		"elite": [float(elite.get("physical_damage")), float(elite.get("max_life"))],
		"quick_strike": [strike.reach, strike.release_arc_degrees, strike.soft_target_cone_degrees, strike.action_time,
			strike.maximum_targets],
		"maximum_life": PlayerStats.line(PlayerStats.MAXIMUM_LIFE),
	}
	for path: String in SKILL_RECORDS:
		var skill: Resource = load(path)
		snapshot[path] = [skill.get("weapon_damage_scale"), skill.get("spell_damage"), skill.get("damage_type")]
	for card_id: StringName in [PassiveCardCatalogue.POWER_ID, PassiveCardCatalogue.CELERITY_ID, PassiveCardCatalogue.VITALITY_ID,
			PassiveCardCatalogue.FLEETNESS_ID, PassiveCardCatalogue.INSIGHT_ID, PassiveCardCatalogue.MAGNETISM_ID]:
		var card: PassiveCardDefinition = PassiveCardCatalogue.record(card_id)
		snapshot[String(card_id)] = [card.stat_id, card.magnitude, card.repeatable, card.display_name]
	return snapshot


# --- Review helpers, ported from the accepted I13 harness --------------------------------------------

## STAGED for every expedition after the first: the Nexus's next plan is replaced by a fresh plan of
## the route's seed (D-294 ruling 4).
func _begin_expedition(label: String) -> void:
	if review.plan.seed_value != ROUTE_SEED:
		review.plan = RogueliteRunPlan.new(ROUTE_SEED, review.plan.run_index)
		_staged_plans += 1
	await _walk_into_gate(review.hub_module.exit_point())
	_expeditions += 1
	_expect_quiet(review.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN and review.mote_runtime != null
			and review.mote_runtime.run_seed() == ROUTE_SEED and review.mote_runtime.level() == 1
			and review.mote_runtime.run_build().is_empty() and not review.level_up_panel.is_open,
		"expedition %s did not begin fresh at seed %d" % [label, ROUTE_SEED])
	if not review.automatic_pickup:
		await _key(KEY_F8)


## The route's own motes to 75 through the review's own sweep, then — STAGED — one fixture mote of 25
## with both Elite Hall Graveblades placed and quiet: Level 1's offer opens on the review's own tick.
func _open_level_one() -> void:
	for index: int in [0, 1]:
		_quiet_room(index)
		var room_centre: Vector3 = _rounded(review.room_modules[index].room_centres()[0])
		_stand(room_centre)
		for enemy: PrototypeGraveblade in review.room_enemies[index]:
			enemy.place_at(room_centre)
			_kill(enemy)
			await _settle(3)
		await _walk_into_gate(review.room_modules[index].exit_point())
	_quiet_room(2)
	var centre: Vector3 = _elite_hall_centre()
	var forward: Vector3 = _forward()
	var lateral: Vector3 = forward.rotated(Vector3.UP, PI * 0.5)
	review.room_enemies[2][0].place_at(centre - forward * 7.0 + lateral * 3.0)
	review.room_enemies[2][1].place_at(centre - forward * 7.0 - lateral * 3.0)
	_stand_facing(centre, forward)
	var in_hall: bool = review.run_state.current_room_index == 2 and review.mote_runtime.experience() == 75.0
	await _award_and_wait([REVIEW_AMOUNT])
	_expect_quiet(in_hall and review.mote_runtime.level() == 1, "Level 1 did not open from 75 route experience and one fixture mote")


func _award_and_wait(amounts: Array) -> void:
	var calls: int = review.offer_open_calls
	var awarded: bool = _award(amounts)
	await _settle(3)
	_expect_quiet(awarded and review.offer_open_calls == calls + 1 and review.level_up_panel.is_open and paused,
		"no offer opened on the review's own tick after awarding %s" % str(amounts))


## STAGED: each amount awarded by a production Graveblade registered with the run's H8 runtime and
## killed, every mote collected by ONE explicit H8 sweep before any tick of the review's own can run.
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
		enemy.name = "I14Fixture%d" % _fixtures
		enemy.position = at
		_stage.add_child(enemy)
		enemy.set_ai_enabled(false)
		registered = registered and runtime.register_graveblade(enemy, float(amount)).is_empty()
		enemy.receive_damage(DamageEvent.physical(_use(), review.player, enemy, enemy.life + 1000.0))
		registered = registered and not enemy.is_alive() and runtime.emission_answer(enemy).is_empty()
		expected.append(drops + expected.size())
		total += float(amount)
	var answer: RiftMoteSweepResult = runtime.sweep_at(at)
	## Presentation only: H9's panel is told to read the run again, as I11–I13's harnesses do.
	review.experience_hud.refresh()
	return registered and answer.ok and answer.collected_indices() == expected and runtime.experience() == before + total


## One Enter press on the focused Support card, read in that press's own call stack, then released.
func _take_support() -> void:
	var physics: int = Engine.get_physics_frames()
	var process: int = Engine.get_process_frames()
	var applications: int = review.applications_made
	var choices: int = review.choices_taken
	_push_key(KEY_ENTER, true)
	var same_frame: bool = Engine.get_physics_frames() == physics and Engine.get_process_frames() == process
	var applied: int = review.applications_made - applications
	_push_key(KEY_ENTER, false)
	_expect_quiet(review.choices_taken == choices + 1 and applied == 1 and same_frame,
		"a Support choice was not taken and applied in its own call")


func _standing_snapshot(label: String) -> Dictionary:
	return {
		"label": label, "open": review.level_up_panel.is_open, "paused": paused,
		"receipt": _receipt_lines(), "live_shown": review.live_receipt_control().is_visible_in_tree(),
		"life": review.player.life, "max_life": review.player.max_life,
		"maximum": review.player.increased_maximum_life(), "hud": _life_text(),
	}


func _live_values() -> Dictionary:
	var values: Dictionary = _effects(review.player)
	values["weapon_damage"] = review.player.physical_damage
	values["max_life"] = review.player.max_life
	values["life"] = review.player.life
	values["maximum"] = review.player.increased_maximum_life()
	values["baseline"] = review.player.maximum_life_baseline()
	return values


func _live_line(live: Dictionary) -> String:
	return "Life %s / %s, Maximum Life %s, reach %.2f m, arc %.0f°, cone %.0f°, action time %.2f s, movement %.1f m/s, Global Damage %s, damage %.12f" % [
		_n(float(live["life"])), _n(float(live["max_life"])), PlayerStats.format_increased(float(live["maximum"])),
		float(live["reach"]), float(live["arc"]), float(live["cone"]), float(live["effective"]), float(live["max_speed"]),
		PlayerStats.format_increased(float(live["global"])), float(live["outgoing"])]


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


func _life_text() -> String:
	if review.hud == null:
		return ""
	for node: Node in review.hud.find_children("*", "Label", true, false):
		var label: Label = node as Label
		if label != null and label.text.begins_with("Life — ") and label.is_visible_in_tree():
			return label.text
	return ""


func _measure_receipt(expected_lines: int, label: String) -> String:
	await _await_process_frames(4)
	var viewport: Rect2 = Rect2(Vector2.ZERO, Vector2(root.get_visible_rect().size))
	var controls: Array[Control] = _receipt_controls()
	var shown: int = _measure_text(controls, viewport, label)
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
	_expect_quiet(shown == expected_lines and outside == 0 and overlapping == 0 and viewport.encloses(host)
			and not host.intersects(centre) and smallest >= 12 and not paused,
		"%s: %d lines on screen, %d outside the review panel %s, %d overlapping" % [label, shown, outside, host, overlapping])
	print("  %s: the live line's logical lines are drawn as %d lines in the review panel's text column"
		% [label, review.live_receipt_control().get_line_count()])
	return "%s: %d lines on screen inside the review panel, 0 overlapping, clear of the centre, smallest %d px; not paused" % [
		label, shown, smallest]


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


func _await_navigation() -> void:
	for frame: int in 60:
		if NavigationServer3D.map_get_iteration_id(review.navigation_map()) > 0:
			return
		await physics_frame


# --- Input, through the viewport ---------------------------------------------------------------------

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


func _joy(button: JoyButton) -> void:
	_push_joy(button, true)
	_push_joy(button, false)
	await _await_process_frames(1)


# --- Evidence ------------------------------------------------------------------------------------------

## Adds no assertion: the rendered runs pin the same count as the headless one.
func _capture(stem: String, settle_seconds: float = 0.0) -> void:
	if _shot_dir.is_empty():
		return
	if settle_seconds > 0.0:
		await create_timer(settle_seconds).timeout
	await _await_process_frames(6)
	for frame: int in 7:
		await RenderingServer.frame_post_draw
	var path: String = "%s/%s.png" % [_shot_dir, stem]
	root.get_texture().get_image().save_png(path)
	print("  screenshot: %s" % path)


func _argument_value(flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


# --- Helpers ------------------------------------------------------------------------------------------

func _use() -> int:
	_next_use_id += 1
	return _next_use_id


func _rounded(at: Vector3) -> Vector3:
	return Vector3(roundf(at.x), 0.0, roundf(at.z))


func _settle(frames: int) -> void:
	for frame: int in frames:
		await physics_frame


func _await_process_frames(frames: int) -> void:
	for frame: int in frames:
		await process_frame


func _joined(ids: Array) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for id: Variant in ids:
		parts.append(String(id))
	return ", ".join(parts)


func _smallest_font(controls: Array[Control]) -> int:
	var smallest: int = 999
	for control: Control in controls:
		if control.is_visible_in_tree() and control is Label:
			smallest = mini(smallest, control.get_theme_font_size("font_size"))
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


## The indented body of top-level function `name`, up to the next unindented line. A signature
## written over several lines closes on an unindented `)` line, which belongs to the signature.
func _function_body(source: String, name: String) -> String:
	var body: PackedStringArray = PackedStringArray()
	var inside: bool = false
	for line: String in source.split("\n"):
		if line.begins_with("func %s(" % name) or line.begins_with("static func %s(" % name):
			inside = true
			continue
		if inside:
			if (not line.is_empty() and not line.begins_with("\t") and not line.begins_with(" ")
					and not line.begins_with(")")):
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


## Every distinct numeric literal in `code`, as written (I4's reading).
func _numeric_literals(code: String) -> PackedStringArray:
	var pattern: RegEx = RegEx.create_from_string("(?<![A-Za-z_0-9.])[0-9]+(?:\\.[0-9]+)?(?![A-Za-z_0-9.])")
	var found: PackedStringArray = PackedStringArray()
	for match: RegExMatch in pattern.search_all(code):
		if not found.has(match.get_string()):
			found.append(match.get_string())
	found.sort()
	return found


func _files_under(root_path: String, extensions: Array[String]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open(root_path)
	if dir == null:
		return out
	dir.list_dir_begin()
	var entry: String = dir.get_next()
	for guard: int in 100000:
		if entry.is_empty():
			break
		if entry != "." and entry != "..":
			var full: String = root_path.path_join(entry)
			if dir.current_is_dir():
				out.append_array(_files_under(full, extensions))
			else:
				for extension: String in extensions:
					if entry.ends_with(extension):
						out.append(full)
		entry = dir.get_next()
	dir.list_dir_end()
	return out


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


## Records a failure without adding to the pinned count, inside loops and helpers whose length is
## incidental.
func _expect_quiet(condition: bool, failure_message: String) -> void:
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
