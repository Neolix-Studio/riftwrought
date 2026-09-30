extends SceneTree
## Riftwrought — Roguelite I13: Player Global-Damage Application V1: automated, rendered
## verification (decision D-318).
##
## THE ONE QUESTION: does the accepted Power card's Global Damage modifier scale every
## outgoing Hit the player produces — Quick Strike, Faultbreaker, Splinter Shot and
## Emberbolt — exactly once, through C1's own calculation path, without writing a weapon or
## a Skill record, without compounding across applications, without touching an enemy's
## damage, and without making Maximum Life live?
##
## TWO SCENES, EACH LOADED EXACTLY AS IT SHIPS AND NEITHER GIVEN ITS OWN FLAG:
##   1. the Gate 1E developer practice range (D-219), where Quick Strike and the three
##      Foundation Skills run on the production player against production Graveblades; and
##   2. the accepted I3 live-effect review (D-295, D-316), driven through seed 99's accepted
##      I12 sequence to the Level 5 passive fallback, where Power is taken with a real key
##      press and real controller Quick Strikes measure what it deals — then a fresh
##      expedition takes the fallback's Vitality lane instead.
##
## EVERY EXPECTED NUMBER IS C1'S OWN ANSWER. Each is asked of `PlayerStats.apply()` or of a
## fresh `PlayerStatTotals` holding the accepted card's own magnitude, and compared to the
## last bit. No multiplier is written here: 100, 110, 120 and 121 appear only as display
## expectations.
##
## STAGED, AND STATED WHERE IT HAPPENS:
##   - in the practice range every Global Damage total reaches the player through the
##     production seam, `RiftBuildApplication.apply()`, handed a run build this harness
##     composed from the accepted Power card; only the refusal proofs hand the player's entry
##     point an incoherent total directly;
##   - Quick Strike and the Skills there are pressed on their action nodes with the range's
##     own verification aim, as Gate 1E's suite presses them: real kernels, real releases,
##     real projectiles and real Graveblades, but not device input;
##   - one Graveblade attack is forced through its own `begin_attack_for_verification()`;
##   - the result-shape refusals tamper with results the seam itself returned;
##   - in the review every experience point beyond the route's own 75 is awarded as I11 and
##     I12 awarded theirs — a production Graveblade registered with the run's H8 runtime,
##     killed, and its mote collected by one explicit H8 sweep; the Elite Hall's two
##     Graveblades are placed with `place_at()` and quieted; expedition B is handed seed 99
##     again (D-294 ruling 4).
##
## IT PORTS D-211's OWED-SET DISCIPLINE and GATE F's ON-SCREEN MEASUREMENT. The evidence
## frames add no assertion, so the headless and rendered runs pin one count.
##
## Run: godot --headless --path game --script res://tests/global_damage_live_application_verification.gd -- --seed 99

const PRACTICE_SCENE: String = "res://scenes/first_mvp/canonical_opening/foundation_skill_practice.tscn"
const REVIEW_SCENE: String = "res://scenes/roguelite/roguelite_live_effect_review.tscn"
const PLAYER_SCRIPT: String = "res://scripts/actors/prototype_player.gd"
const QUICK_STRIKE_SCRIPT: String = "res://scripts/combat/quick_strike_action.gd"
const SKILL_ACTION_SCRIPT: String = "res://scripts/skills/first_mvp_skill_action.gd"
const SEAM_SCRIPT: String = "res://scripts/roguelite/live_effects/rift_build_application.gd"
const RESULT_SCRIPT: String = "res://scripts/roguelite/live_effects/rift_build_application_result.gd"
const REVIEW_SCRIPT: String = "res://scripts/roguelite/live_effects/roguelite_live_effect_review.gd"
const THIS_FILE: String = "res://tests/global_damage_live_application_verification.gd"
const GRAVEBLADE_SCENE: String = "res://scenes/actors/prototype_graveblade.tscn"
const GRAVEBLADE_RECORD: String = "res://data/prototype_zero/graveblade.tres"
const WORN_SWORD: String = "res://data/first_mvp/severed_threshold/broken_watch/starting_sword.tres"
const HONED_SWORD: String = "res://data/prototype_zero/honed_sword.tres"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31
const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]

## The six production files Roguelite I13 changed, each at its D-318 SHA-256 prefix — the player,
## the seam, its result and the live-effect review moved one for one to their D-320 files when
## Roguelite I14 made Maximum Life live.
const D318_HASHES: Array = [
	## First-MVP UI J2 (D-324) moved the player once more, from `a6d93721`, so that neutralizing a
	## fallen character's controls keeps it FALLEN.
	[PLAYER_SCRIPT, "80e38838"],
	[QUICK_STRIKE_SCRIPT, "e6514705"],
	[SKILL_ACTION_SCRIPT, "1874582b"],
	[SEAM_SCRIPT, "c7b9df38"],
	## Roguelite I14's correction (D-321) moved the result once more, from `73d445f7`, for its describe().
	[RESULT_SCRIPT, "2fd01f80"],
	[REVIEW_SCRIPT, "75cb02b9"],
]

## The practice range's measuring positions: every Graveblade far from the line of a shot,
## all three inside Faultbreaker's radius from the area spot.
const STRIKE_SPOT: Vector3 = Vector3(0.0, 0.0, 3.0)
const AREA_SPOT: Vector3 = Vector3(0.0, 0.0, -9.0)
const SHOT_SPOT: Vector3 = Vector3(0.0, 0.0, 0.0)
const FACING: Vector3 = Vector3(0.0, 0.0, -1.0)
const NEAR: float = 1.2
const SHOT_DISTANCE: float = 9.0

## The review: seed 99 with Support taken at every level (the accepted I10/I11/I12 table).
const ROUTE_SEED: int = 99
const REVIEW_AMOUNT: float = 25.0
const LEVEL_TWO_AMOUNT: float = 125.0
## 150 + 175 + 200: Levels 3, 4 and 5 owed one after another, as I12 banks them.
const CHAIN_AMOUNTS: Array[float] = [150.0, 175.0, 200.0]
const SUPPORT: int = 0
const BETWEEN_REACHES: float = 3.20
const QUICK_STRIKE_BUTTON: JoyButton = JOY_BUTTON_X

## The accepted wording, typed independently of every mechanism (D-293, D-295, D-297, D-312).
const RECEIPT_TITLE: String = "Temporary build — this expedition"
const OFFER_STANDING_TEXT: String = "Level-up offer open — choose one of the three cards."
const STANDING_LINES: Array[String] = [RECEIPT_TITLE, OFFER_STANDING_TEXT]
const RECEIPT_LIVE_NOTE: String = "Applied to the character now; every value returns to its baseline when this expedition ends."
const LIVE_PREFIX: String = "Live now — "
const HELD_HEADING: String = "Held, not live on the character:"
const DAMAGE_LINE: String = "damage 100 → 110"
const LIVE_POWER: String = "Live now — reach 1.65 m → 3.65 m · arc 100° → 260° · cone 65° → 155° · one target\ndamage 100 → 110"
## Roguelite I14 (D-320) made Maximum Life live, so the Vitality receipt, its line and the Life display
## moved one for one: the maximum is stated under "Live now —" and nothing is held.
const VITALITY_LINE: String = "Maximum Life 500 → 575 · Life preserved at 100%"
const LIVE_VITALITY: String = "Live now — reach 1.65 m → 3.65 m · arc 100° → 260° · cone 65° → 155° · one target\nMaximum Life 500 → 575 · Life preserved at 100%"
const POWER_RECEIPT: Array[String] = [
	RECEIPT_TITLE, "Support — Power (+10% Global Damage)", "Passive fallback from Combat and Defence",
	"Rift level 5 → 6 · 0 XP carried over", LIVE_POWER, RECEIPT_LIVE_NOTE,
]
const VITALITY_RECEIPT: Array[String] = [
	RECEIPT_TITLE, "Combat and Defence — Vitality (+15% Maximum Life)",
	"Rift level 5 → 6 · 0 XP carried over", LIVE_VITALITY, RECEIPT_LIVE_NOTE,
]
const LIFE_LINE: String = "Life — 575 / 575"

## What this harness must never do: reach into the review, rewrite a record, a weapon, a
## projectile or a damage record, or touch the player's stored total except through its
## entry point. Read over this file's own CODE, comments removed and strings emptied.
const INJECTION_PATTERNS: Array[String] = [
	"review._", ".mote_runtime._", "level_up_panel._", "mote_runtime = ", "review.set(", "review.call(",
	".callv(", "set_meta(", "add_action(", "action_add_event(", "while ", "award_experience(",
	"._increased_global_damage", "physical_damage = ", "spell_damage = ", "weapon_damage_scale = ",
	".damage = ", "final_life_damage = ", "raw_physical_damage = ", ".max_speed = ", ".reach = ",
	"Input.action_press(",
]

const OWED_CHECKS: Array[String] = [
	"the_harness_is_isolated_and_names_the_authorized_scenes",
	"the_production_shape_is_the_authorized_one",
	"a_fresh_player_holds_no_global_damage",
	"the_entry_point_and_the_query_refuse_without_a_fallback",
	"one_power_makes_quick_strike_deal_c1s_answer",
	"two_power_acquisitions_add_before_they_apply",
	"a_new_weapon_is_evaluated_through_the_same_total",
	"faultbreaker_applies_it_once_to_its_weapon_base",
	"splinter_shot_applies_it_once_to_its_weapon_base",
	"emberbolt_applies_it_once_to_its_spell_base",
	"a_projectile_keeps_the_damage_it_launched_with",
	"the_enemy_attack_path_is_untouched",
	"an_empty_build_restores_the_raw_base_and_rewrites_nothing",
	"the_result_refuses_every_incoherent_global_damage_shape",
	"the_seam_derives_from_the_raw_base_and_writes_the_total_first",
	"before_power_a_real_strike_deals_one_hundred_and_offers_hide_the_receipts",
	"power_is_live_in_the_choices_own_call",
	"the_level_six_receipt_lists_the_damage_under_live_now",
	"real_strikes_after_power_deal_the_new_amount",
	"f5_restores_the_damage_and_every_covered_baseline",
	"the_next_expedition_starts_at_global_damage_zero",
	"vitality_is_live_and_keeps_full_life",
]

var practice: FoundationSkillPractice
var review: RogueliteLiveEffectReview
var arguments: PackedStringArray = PackedStringArray()

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _shot_dir: String = ""
var _stage: Node3D
var _next_use_id: int = 97000
var _fixtures: int = 0
var _presses: int = 0
var _practice_uses: int = 0
var _staged_builds: int = 0
var _expeditions: int = 0
var _staged_plans: int = 0

## Measured in the practice range and read again at its end.
var _practice_speed: float = 0.0
var _records_at_start: Dictionary = {}
var _kept_events: Array = []

## Measured across the review.
var _baseline: Dictionary = {}
var _standing: Array[Dictionary] = []
var _before_power: Dictionary = {}
var _power_taken: Dictionary = {}
var _receipt_measure: String = ""
var _vitality_measure: String = ""


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	_shot_dir = _argument_value("--shots")
	print("")
	print("=== Roguelite I13 — Player Global-Damage Application V1 verification (D-318) ===")
	_stage = Node3D.new()
	_stage.name = "I13FixtureStage"
	root.add_child(_stage)

	practice = await _load_scene(PRACTICE_SCENE) as FoundationSkillPractice
	if practice == null or practice.player == null:
		printerr("GLOBAL DAMAGE LIVE APPLICATION VERIFICATION: the practice range did not load")
		quit(1)
		return
	await _settle(10)
	_practice_speed = practice.player.max_speed
	_records_at_start = _record_snapshot()

	_check_the_harness_is_isolated_and_names_the_authorized_scenes()
	_check_the_production_shape_is_the_authorized_one()
	_check_a_fresh_player_holds_no_global_damage()
	_check_the_entry_point_and_the_query_refuse_without_a_fallback()
	await _check_one_power_makes_quick_strike_deal_c1s_answer()
	await _check_two_power_acquisitions_add_before_they_apply()
	await _check_a_new_weapon_is_evaluated_through_the_same_total()
	await _check_faultbreaker_applies_it_once_to_its_weapon_base()
	await _check_splinter_shot_applies_it_once_to_its_weapon_base()
	await _check_emberbolt_applies_it_once_to_its_spell_base()
	await _check_a_projectile_keeps_the_damage_it_launched_with()
	await _check_the_enemy_attack_path_is_untouched()
	await _check_an_empty_build_restores_the_raw_base_and_rewrites_nothing()
	_check_the_result_refuses_every_incoherent_global_damage_shape()
	_check_the_seam_derives_from_the_raw_base_and_writes_the_total_first()

	review = await _load_scene(REVIEW_SCENE) as RogueliteLiveEffectReview
	if review == null:
		printerr("GLOBAL DAMAGE LIVE APPLICATION VERIFICATION: the accepted I3 scene did not load")
		quit(1)
		return
	practice = null
	await _settle(10)
	await _await_navigation()

	await _expedition_a()
	await _check_f5_restores_the_damage_and_every_covered_baseline()
	await _check_the_next_expedition_starts_at_global_damage_zero()
	await _check_vitality_is_live_and_keeps_full_life()

	_check_every_check_ran()

	print("")
	print("  %d practice uses, %d real Quick Strike presses, %d builds staged through the seam in the practice range, %d expeditions (%d given seed %d again by staging), %d fixture Graveblades registered and killed, %d applications and %d restorations made by the review"
		% [_practice_uses, _presses, _staged_builds, _expeditions, _staged_plans, ROUTE_SEED, _fixtures,
			review.applications_made, review.restorations_made])
	if _failures.is_empty():
		print("GLOBAL DAMAGE LIVE APPLICATION VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("GLOBAL DAMAGE LIVE APPLICATION VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		quit(1)


## Changes to one of the two accepted scenes exactly as it ships and waits until it stands.
func _load_scene(path: String) -> Node:
	var changed: Error = change_scene_to_packed(load(path) as PackedScene)
	for frame: int in 30:
		await process_frame
		if current_scene != null and current_scene.scene_file_path == path:
			break
	if changed != OK or current_scene == null or current_scene.scene_file_path != path:
		return null
	return current_scene


# --- 1–4. Isolation, the production shape, a fresh player, and the refusals ---------------------

func _check_the_harness_is_isolated_and_names_the_authorized_scenes() -> void:
	print("")
	print("--- 1. The harness loads the Gate 1E practice range as it ships; no accepted suite starts; nothing is injected")
	var script: GDScript = practice.get_script() as GDScript
	_expect(practice.scene_file_path == PRACTICE_SCENE and script.resource_path.ends_with("foundation_skill_practice.gd")
			and practice.get_node_or_null("FoundationSkillVerification") == null
			and not arguments.has("--verify-skills") and not arguments.has("--verify-live-effects")
			and (practice.player.get_script() as GDScript).resource_path == PLAYER_SCRIPT
			and (practice.player.attack.get_script() as GDScript).resource_path == QUICK_STRIKE_SCRIPT,
		"the practice range is %s running %s, or an accepted suite started in it" % [practice.scene_file_path, script.resource_path])
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
			and not settings.contains("[autoload]") and not settings.contains("global_damage_live")
			and injected.is_empty() and listed == INJECTION_PATTERNS.size() and own.length() > 20000,
		"%d actions, or project.godot moved, or this harness's code names %s (%d of %d patterns listed)"
			% [actions, ", ".join(injected), listed, INJECTION_PATTERNS.size()])
	print("  the practice range %s runs %s on the production player; no accepted suite started; %d actions; the entrypoint is %s; project.godot declares no [autoload]; 0 of %d injection patterns in this harness's code"
		% [PRACTICE_SCENE.get_file(), script.resource_path.get_file(), actions, ENTRYPOINT.get_file(), INJECTION_PATTERNS.size()])
	_done("the_harness_is_isolated_and_names_the_authorized_scenes")


func _check_the_production_shape_is_the_authorized_one() -> void:
	print("")
	print("--- 2. One stored total on the player, one entry point, one query; every damage-committing site asks it; nothing restates the arithmetic")
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in D318_HASHES:
		var digest: String = FileAccess.get_sha256(String(row[0]))
		if not digest.begins_with(String(row[1])):
			moved.append("%s %s" % [String(row[0]).get_file(), digest.left(8)])
	var player_source: String = FileAccess.get_file_as_string(PLAYER_SCRIPT)
	var player_code: String = _bare(player_source)
	var functions: PackedStringArray = _declared_functions(player_source)
	var query: String = _function_body(player_code, "outgoing_hit_damage").strip_edges()
	var setter: String = _function_body(player_code, "set_increased_global_damage")
	var reader: String = _function_body(player_code, "increased_global_damage").strip_edges()
	_expect(moved.is_empty() and player_code.count("var _increased_global_damage: float = 0.0") == 1
			and functions.count("set_increased_global_damage") == 1 and functions.count("increased_global_damage") == 1
			and functions.count("outgoing_hit_damage") == 1
			and query == "return PlayerStats.apply(PlayerStats.GLOBAL_DAMAGE, base_damage, _increased_global_damage)"
			and setter.count("PlayerStats.apply(PlayerStats.GLOBAL_DAMAGE, 0.0, total_increased)") == 1
			and setter.count("_increased_global_damage = total_increased") == 1
			and not setter.contains("*") and not setter.contains("+")
			and reader == "return _increased_global_damage" and player_code.count("_increased_global_damage =") == 1,
		"moved %s; the player's query reads '%s' and its reader '%s'" % [", ".join(moved), query, reader])

	## WHO WRITES THE TOTAL AND WHO ASKS THE QUERY, over every running file.
	var private: RegEx = RegEx.create_from_string("(?<![A-Za-z0-9])_increased_global_damage")
	var setters: PackedStringArray = PackedStringArray()
	var askers: PackedStringArray = PackedStringArray()
	var namers: PackedStringArray = PackedStringArray()
	var scanned: int = 0
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd", ".tscn", ".tres"]):
			if path == PLAYER_SCRIPT:
				continue
			scanned += 1
			var code: String = _bare(FileAccess.get_file_as_string(path))
			if code.count("set_increased_global_damage(") > 0:
				setters.append("%s x%d" % [path.get_file(), code.count("set_increased_global_damage(")])
			if code.count("outgoing_hit_damage(") > 0:
				askers.append("%s x%d" % [path.get_file(), code.count("outgoing_hit_damage(")])
			if private.search(code) != null:
				namers.append(path.get_file())
	askers.sort()
	_expect(scanned > 100 and setters == PackedStringArray(["rift_build_application.gd x2"])
			and askers == PackedStringArray(["first_mvp_skill_action.gd x2", "quick_strike_action.gd x1"]) and namers.is_empty(),
		"the entry point is called by [%s], the query by [%s], and the stored total is named by [%s]"
			% [", ".join(setters), ", ".join(askers), ", ".join(namers)])

	## EVERY SITE THAT COMMITS A HIT'S DAMAGE ASKS THE QUERY FIRST, and none restates it.
	var strike: String = _bare(FileAccess.get_file_as_string(QUICK_STRIKE_SCRIPT))
	var release: String = _function_body(strike, "_fire_release")
	var skill: String = _bare(FileAccess.get_file_as_string(SKILL_ACTION_SCRIPT))
	var area: String = _function_body(skill, "_resolve_area")
	var launch: String = _function_body(skill, "_spawn_projectile")
	var refused: String = _function_body(skill, "_damage_refused")
	var restated: RegEx = RegEx.create_from_string("(?<![0-9.])1(\\.0+)?\\s*\\+")
	_expect(release.count("_player.outgoing_hit_damage(_player.physical_damage)") == 1 and strike.count("physical_damage") == 1
			and release.count("DamageEvent.physical(") == 1 and release.contains("use_id, _player, actor, outgoing.value")
			and release.find("if outgoing.ok:") >= 0 and release.find("if outgoing.ok:") < release.find("DamageEvent.physical(")
			and release.count("push_error(") == 1
			and area.count("_player.outgoing_hit_damage(data.hit_damage(_player.weapon))") == 1
			and area.contains("var damage: float = outgoing.value")
			and area.find("return _damage_refused(outgoing") >= 0 and area.find("return _damage_refused(outgoing") < area.find("of_type(")
			and launch.count("_player.outgoing_hit_damage(data.hit_damage(_player.weapon))") == 1
			and launch.find("return _damage_refused(outgoing") >= 0
			and launch.find("return _damage_refused(outgoing") < launch.find("FirstMvpSkillProjectile.new()")
			and launch.contains("projectile.setup(data, _player, use_id, aim, damage, _log)")
			and skill.count("data.hit_damage(") == 2 and refused.count("push_error(") == 1 and not refused.contains("of_type(")
			and restated.search(release) == null and restated.search(area) == null and restated.search(launch) == null,
		"a damage-committing site does not ask the query first, or restates the arithmetic")
	_expect(_joined(RiftBuildApplication.covered_stats()) == _joined([PlayerStats.GLOBAL_DAMAGE, PlayerStats.SKILL_SPEED, PlayerStats.MAXIMUM_LIFE, PlayerStats.MOVEMENT_SPEED])
			and RiftBuildApplication.deferred_stats().is_empty()
			and _joined(RiftBuildApplication.run_path_stats()) == _joined([PlayerStats.EXPERIENCE_GAIN, PlayerStats.PICKUP_RADIUS]),
		"the seam covers [%s] and holds [%s]" % [_joined(RiftBuildApplication.covered_stats()), _joined(RiftBuildApplication.deferred_stats())])
	print("  %d changed production files at their D-318 SHA-256 prefixes, four since moved to their D-320 ones, the result since to its D-321 one and the player since to its D-324 one; the player declares one stored total, 0.0, and set_increased_global_damage, increased_global_damage and outgoing_hit_damage"
		% D318_HASHES.size())
	print("  of %d running files, the entry point's only caller is [%s], the query's only callers are [%s], and none but the player names the stored total"
		% [scanned, ", ".join(setters), ", ".join(askers)])
	print("  Quick Strike's release, the area release and every projectile launch ask the query before a damage record or a projectile exists; a refused answer reaches push_error and deals nothing; none restates 1 + a total")
	print("  the seam covers [%s], holds [%s] and leaves [%s] to the run's own mote path"
		% [_joined(RiftBuildApplication.covered_stats()), _joined(RiftBuildApplication.deferred_stats()),
			_joined(RiftBuildApplication.run_path_stats())])
	_done("the_production_shape_is_the_authorized_one")


func _check_a_fresh_player_holds_no_global_damage() -> void:
	print("")
	print("--- 3. A fresh player holds +0% Global Damage, and its outgoing damage is the weapon's own raw base")
	var player: PrototypePlayer = practice.player
	var detached: PrototypePlayer = PrototypePlayer.new()
	var fresh: float = detached.increased_global_damage()
	detached.free()
	var raw: PlayerStatValue = player.outgoing_hit_damage(player.physical_damage)
	var c1: PlayerStatValue = PlayerStats.apply(PlayerStats.GLOBAL_DAMAGE, player.physical_damage, 0.0)
	_expect(fresh == 0.0 and player.increased_global_damage() == 0.0 and raw.ok and c1.ok and raw.value == c1.value
			and raw.value == player.physical_damage and roundi(player.physical_damage) == 100 and raw.problem().is_empty(),
		"a fresh player holds %s and deals %s" % [PlayerStats.format_increased(player.increased_global_damage()), raw.describe()])
	print("  a detached player and the range's player both hold %s; the Worn Sword's raw %.0f comes back from the query as %.0f, C1's answer, to the last bit"
		% [PlayerStats.format_increased(fresh), player.physical_damage, raw.value])
	_done("a_fresh_player_holds_no_global_damage")


func _check_the_entry_point_and_the_query_refuse_without_a_fallback() -> void:
	print("")
	print("--- 4. STAGED: the entry point refuses every total C1 refuses and changes nothing; the query returns C1's refusal whole, never a fallback number")
	var player: PrototypePlayer = practice.player
	var bad: Array[float] = [NAN, INF, -INF, -1.0, -1.5]
	var refused: int = 0
	var reasons: PackedStringArray = PackedStringArray()
	for total: float in bad:
		var reason: String = player.set_increased_global_damage(total)
		var c1: PlayerStatValue = PlayerStats.apply(PlayerStats.GLOBAL_DAMAGE, 0.0, total)
		if not reason.is_empty() and not c1.ok and reason == c1.failure_reason and player.increased_global_damage() == 0.0:
			refused += 1
		reasons.append(reason)
	var accepted: String = player.set_increased_global_damage(0.25)
	var held: float = player.increased_global_damage()
	var restored: RiftBuildApplicationResult = RiftBuildApplication.apply(RiftRunBuild.new(), player, _practice_speed)
	_staged_builds += 1
	_expect(refused == bad.size() and accepted.is_empty() and held == 0.25 and restored.ok and restored.committed
			and player.increased_global_damage() == 0.0,
		"%d of %d refused; +25%% answered '%s' and held %s; the empty build left %s"
			% [refused, bad.size(), accepted, PlayerStats.format_increased(held), PlayerStats.format_increased(player.increased_global_damage())])
	var answered: int = 0
	for base: float in [-5.0, NAN, INF]:
		var answer: PlayerStatValue = player.outgoing_hit_damage(base)
		var c1: PlayerStatValue = PlayerStats.apply(PlayerStats.GLOBAL_DAMAGE, base, 0.0)
		if (not answer.ok and answer.failure_reason == c1.failure_reason and answer.problem().is_empty()
				and String(answer.stat_id).is_empty() and answer.value == 0.0 and answer.base_value == 0.0):
			answered += 1
	_expect(answered == 3, "%d of 3 unusable bases came back as C1's own refusal with no partial number" % answered)
	for index: int in bad.size():
		print("  %s refused: '%s'" % [str(bad[index]), reasons[index]])
	print("  %d of %d refused with C1's own reason and the total left at +0%%; +25%% accepted and then restored by the seam's empty build"
		% [refused, bad.size()])
	print("  a base of -5, nan and inf: 3 of 3 came back as C1's refusal, not as zero, the base or a clamp")
	_done("the_entry_point_and_the_query_refuse_without_a_fallback")


# --- 5–7. Quick Strike ----------------------------------------------------------------------------

func _check_one_power_makes_quick_strike_deal_c1s_answer() -> void:
	print("")
	print("--- 5. One Power, through the seam: a released Quick Strike's damage record carries C1's answer, and the Graveblade loses exactly that")
	var player: PrototypePlayer = practice.player
	player.equip_weapon(load(WORN_SWORD) as PrototypeWeaponData)
	var build: RiftRunBuild = _power_build(1)
	var applied: RiftBuildApplicationResult = RiftBuildApplication.apply(build, player, _practice_speed)
	_staged_builds += 1
	var answer: PlayerStatValue = _c1(1).value_of(PlayerStats.GLOBAL_DAMAGE, player.physical_damage)
	var enemy: PrototypeGraveblade = practice.graveblades[0]
	var hit: Dictionary = await _practice_strike(enemy)
	var event: DamageEvent = hit["event"]
	_expect(applied.ok and applied.committed and applied.problem().is_empty() and answer.ok
			and player.increased_global_damage() == answer.total_increased and build.total_for(PlayerStats.GLOBAL_DAMAGE) == answer.total_increased
			and event != null and int(hit["events"]) == 1 and event.raw_physical_damage == answer.value
			and event.final_life_damage == answer.value and hit["taken"] == event and event.source == player
			and float(hit["after"]) == maxf(float(hit["before"]) - answer.value, 0.0)
			and player.physical_damage == float(_records_at_start["worn"]) and roundi(answer.value) == 110
			and answer.value != player.physical_damage,
		"one Power: the record carried %s against C1's %.12f; Life %.12f -> %.12f"
			% ["nothing" if event == null else event.describe(), answer.value, float(hit["before"]), float(hit["after"])])
	if event != null:
		_kept_events.append([event, answer.value])
	print("  the Worn Sword's raw %.0f at %s: C1 answers %.12f; the release's damage record carries raw %.12f and final %.12f; the Graveblade %.0f -> %.12f"
		% [player.physical_damage, PlayerStats.format_increased(answer.total_increased), answer.value,
			event.raw_physical_damage if event != null else 0.0, event.final_life_damage if event != null else 0.0,
			float(hit["before"]), float(hit["after"])])
	_done("one_power_makes_quick_strike_deal_c1s_answer")


func _check_two_power_acquisitions_add_before_they_apply() -> void:
	print("")
	print("--- 6. Two Power acquisitions are one +20% applied once — never +21% — and applying that build again changes nothing")
	var player: PrototypePlayer = practice.player
	var build: RiftRunBuild = _power_build(2)
	var totals: PlayerStatTotals = _c1(2)
	var answer: PlayerStatValue = totals.value_of(PlayerStats.GLOBAL_DAMAGE, player.physical_damage)
	var first: RiftBuildApplicationResult = RiftBuildApplication.apply(build, player, _practice_speed)
	var after_first: float = player.increased_global_damage()
	var second: RiftBuildApplicationResult = RiftBuildApplication.apply(build, player, _practice_speed)
	_staged_builds += 2
	var enemy: PrototypeGraveblade = practice.graveblades[0]
	var hit: Dictionary = await _practice_strike(enemy)
	var event: DamageEvent = hit["event"]
	_expect(first.ok and second.ok and first.describe() == second.describe() and after_first == answer.total_increased
			and player.increased_global_damage() == answer.total_increased and build.total_for(PlayerStats.GLOBAL_DAMAGE) == answer.total_increased
			and totals.count_for(PlayerStats.GLOBAL_DAMAGE) == 2 and PlayerStats.format_increased(answer.total_increased) == "+20%"
			and event != null and event.final_life_damage == answer.value and event.raw_physical_damage == answer.value
			and float(hit["after"]) == maxf(float(hit["before"]) - answer.value, 0.0)
			and roundi(answer.value) == 120 and roundi(answer.value) != 121,
		"two Power: the player holds %s; the record carried %s against C1's %.12f"
			% [PlayerStats.format_increased(player.increased_global_damage()), "nothing" if event == null else event.describe(), answer.value])
	if event != null:
		_kept_events.append([event, answer.value])
	print("  two acquisitions sum to %s in C1's accumulator and in the build, applied once: %.12f, which displays as %d, not 121; applied again, the same description and the same %s"
		% [PlayerStats.format_increased(answer.total_increased), answer.value, roundi(answer.value),
			PlayerStats.format_increased(player.increased_global_damage())])
	_done("two_power_acquisitions_add_before_they_apply")


func _check_a_new_weapon_is_evaluated_through_the_same_total() -> void:
	print("")
	print("--- 7. With one Power held, the Honed Sword's own 150 is evaluated through the same total, and the Worn Sword's 100 again after it")
	var player: PrototypePlayer = practice.player
	var worn: PrototypeWeaponData = load(WORN_SWORD) as PrototypeWeaponData
	var honed: PrototypeWeaponData = load(HONED_SWORD) as PrototypeWeaponData
	player.equip_weapon(worn)
	var applied: RiftBuildApplicationResult = RiftBuildApplication.apply(_power_build(1), player, _practice_speed)
	_staged_builds += 1
	var total: float = player.increased_global_damage()
	var enemy: PrototypeGraveblade = practice.graveblades[0]
	var hundred: PlayerStatValue = _c1(1).value_of(PlayerStats.GLOBAL_DAMAGE, worn.physical_damage)
	var first: Dictionary = await _practice_strike(enemy)
	player.equip_weapon(honed)
	var raw_honed: float = player.physical_damage
	var fifty: PlayerStatValue = _c1(1).value_of(PlayerStats.GLOBAL_DAMAGE, honed.physical_damage)
	var second: Dictionary = await _practice_strike(enemy)
	var total_after_equip: float = player.increased_global_damage()
	player.equip_weapon(worn)
	var raw_worn: float = player.physical_damage
	var third: Dictionary = await _practice_strike(enemy)
	var hits: Array = [first, second, third]
	var wanted: Array[float] = [hundred.value, fifty.value, hundred.value]
	var exact: int = 0
	for index: int in 3:
		var event: DamageEvent = hits[index]["event"]
		if (event != null and event.final_life_damage == wanted[index] and event.raw_physical_damage == wanted[index]
				and float(hits[index]["after"]) == maxf(float(hits[index]["before"]) - wanted[index], 0.0)):
			exact += 1
			_kept_events.append([event, wanted[index]])
	_expect(applied.ok and exact == 3 and raw_honed == honed.physical_damage and raw_worn == worn.physical_damage
			and total == total_after_equip and player.increased_global_damage() == total
			and worn.physical_damage == float(_records_at_start["worn"]) and honed.physical_damage == float(_records_at_start["honed"])
			and roundi(fifty.value) == 165 and roundi(hundred.value) == 110,
		"%d of 3 hits exact; raw %.0f then %.0f; the total %s -> %s"
			% [exact, raw_honed, raw_worn, PlayerStats.format_increased(total), PlayerStats.format_increased(total_after_equip)])
	print("  Worn Sword %.0f -> %.12f; Honed Sword %.0f -> %.12f; Worn Sword again -> %.12f: %d of 3 hits exactly C1's answer, the total %s throughout, no application between them"
		% [worn.physical_damage, hundred.value, honed.physical_damage, fifty.value, hundred.value, exact, PlayerStats.format_increased(total)])
	print("  the two weapon records still read %.0f and %.0f" % [worn.physical_damage, honed.physical_damage])
	_done("a_new_weapon_is_evaluated_through_the_same_total")


# --- 8–10. The three Foundation Skills -----------------------------------------------------------

func _check_faultbreaker_applies_it_once_to_its_weapon_base() -> void:
	print("")
	print("--- 8. One Power: one Faultbreaker release deals C1's answer for its weapon-derived base to every Graveblade it strikes, once")
	var player: PrototypePlayer = practice.player
	practice.restore()
	practice.equip_index(0)
	var applied: RiftBuildApplicationResult = RiftBuildApplication.apply(_power_build(1), player, _practice_speed)
	_staged_builds += 1
	var action: FirstMvpSkillAction = practice.action_for(FirstMvpSkillLibrary.FAULTBREAKER_ID)
	var base: float = action.canonical_data.hit_damage(player.weapon)
	var answer: PlayerStatValue = _c1(1).value_of(PlayerStats.GLOBAL_DAMAGE, base)
	var twice: PlayerStatValue = _c1(1).value_of(PlayerStats.GLOBAL_DAMAGE, answer.value)
	_home_graveblades()
	_stand_practice(AREA_SPOT, FACING)
	await _settle(3)
	var lives: Array[float] = []
	for enemy: PrototypeGraveblade in practice.graveblades:
		lives.append(enemy.life)
	var events_before: int = action.damage_events
	practice.force_next_aim_for_verification(_area(practice.graveblades[0]))
	action.press()
	action.release_input()
	_practice_uses += 1
	await _settle(int(ceil(action.data.action_time * 60.0)) + 8)
	var events: int = action.damage_events - events_before
	var struck: int = 0
	var exact: int = 0
	for index: int in practice.graveblades.size():
		var enemy: PrototypeGraveblade = practice.graveblades[index]
		if enemy.life == lives[index]:
			continue
		struck += 1
		var taken: FirstMvpDamageEvent = enemy.last_damage_taken as FirstMvpDamageEvent
		if (taken != null and taken.raw_damage() == answer.value and taken.final_life_damage == answer.value
				and taken.damage_type == FirstMvpDamageEvent.PHYSICAL and enemy.life == maxf(lives[index] - answer.value, 0.0)):
			exact += 1
			_kept_events.append([taken, answer.value])
	_expect(applied.ok and answer.ok and events >= 2 and events == struck and exact == struck
			and base == action.data.hit_damage(player.weapon) and answer.value != base and answer.value != twice.value
			and roundi(base) == 192,
		"Faultbreaker: %d event(s), %d struck, %d exact against C1's %.12f from a base of %.12f"
			% [events, struck, exact, answer.value, base])
	print("  the Garrison Greatsword's %.0f at the record's own scale is a base of %.12f; at %s C1 answers %.12f (applied twice it would be %.12f)"
		% [player.physical_damage, base, PlayerStats.format_increased(answer.total_increased), answer.value, twice.value])
	print("  one release: %d damage record(s) on %d Graveblade(s), %d of them exactly C1's answer in raw, final and Life lost, all Physical" % [events, struck, exact])
	_done("faultbreaker_applies_it_once_to_its_weapon_base")


func _check_splinter_shot_applies_it_once_to_its_weapon_base() -> void:
	print("")
	print("--- 9. One Power: a Splinter Shot projectile stores C1's answer for its weapon-derived base at launch and deals exactly that")
	var player: PrototypePlayer = practice.player
	practice.restore()
	practice.equip_index(1)
	var applied: RiftBuildApplicationResult = RiftBuildApplication.apply(_power_build(1), player, _practice_speed)
	_staged_builds += 1
	var action: FirstMvpSkillAction = practice.action_for(FirstMvpSkillLibrary.SPLINTER_SHOT_ID)
	var base: float = action.canonical_data.hit_damage(player.weapon)
	var answer: PlayerStatValue = _c1(1).value_of(PlayerStats.GLOBAL_DAMAGE, base)
	var twice: PlayerStatValue = _c1(1).value_of(PlayerStats.GLOBAL_DAMAGE, answer.value)
	var enemy: PrototypeGraveblade = practice.graveblades[0]
	var shot: Dictionary = await _launch(action, enemy)
	await _await_resolution(shot)
	var event: FirstMvpDamageEvent = (shot["outcome"] as Dictionary).get("event") as FirstMvpDamageEvent
	_expect(applied.ok and bool(shot["launched"]) and float(shot["stored"]) == answer.value and event != null
			and event.raw_damage() == answer.value and event.final_life_damage == answer.value
			and event.damage_type == FirstMvpDamageEvent.PHYSICAL and action.last_damage_dealt == event
			and enemy.life == maxf(float(shot["before"]) - answer.value, 0.0)
			and answer.value != base and answer.value != twice.value and roundi(base) == 110,
		"Splinter Shot: stored %.12f, dealt %s, against C1's %.12f" % [float(shot["stored"]),
			"nothing" if event == null else event.describe(), answer.value])
	if event != null:
		_kept_events.append([event, answer.value])
	print("  the Marrow Bow's %.0f at the record's own scale is a base of %.12f; the projectile stored %.12f at launch — C1's answer — and its one Hit dealt %.12f Physical: Life %.0f -> %.12f"
		% [player.physical_damage, base, float(shot["stored"]), event.final_life_damage if event != null else 0.0,
			float(shot["before"]), enemy.life])
	_done("splinter_shot_applies_it_once_to_its_weapon_base")


func _check_emberbolt_applies_it_once_to_its_spell_base() -> void:
	print("")
	print("--- 10. One Power: an Emberbolt projectile stores C1's answer for its Skill-defined base at launch and deals exactly that, as Fire")
	var player: PrototypePlayer = practice.player
	practice.restore()
	practice.equip_index(2)
	var applied: RiftBuildApplicationResult = RiftBuildApplication.apply(_power_build(1), player, _practice_speed)
	_staged_builds += 1
	var action: FirstMvpSkillAction = practice.action_for(FirstMvpSkillLibrary.EMBERBOLT_ID)
	var base: float = action.canonical_data.hit_damage(player.weapon)
	var answer: PlayerStatValue = _c1(1).value_of(PlayerStats.GLOBAL_DAMAGE, base)
	var from_wand: PlayerStatValue = _c1(1).value_of(PlayerStats.GLOBAL_DAMAGE, player.physical_damage)
	var enemy: PrototypeGraveblade = practice.graveblades[0]
	var shot: Dictionary = await _launch(action, enemy)
	await _await_resolution(shot)
	var event: FirstMvpDamageEvent = (shot["outcome"] as Dictionary).get("event") as FirstMvpDamageEvent
	_expect(applied.ok and bool(shot["launched"]) and float(shot["stored"]) == answer.value and event != null
			and event.raw_damage() == answer.value and event.final_life_damage == answer.value and event.is_fire()
			and action.last_damage_dealt == event and enemy.life == maxf(float(shot["before"]) - answer.value, 0.0)
			and base == action.canonical_data.spell_damage and base != player.physical_damage and answer.value != from_wand.value
			and roundi(base) == 130,
		"Emberbolt: stored %.12f, dealt %s, against C1's %.12f" % [float(shot["stored"]),
			"nothing" if event == null else event.describe(), answer.value])
	if event != null:
		_kept_events.append([event, answer.value])
	print("  Emberbolt's own %.0f, not the Cantor Wand's %.0f; the projectile stored %.12f at launch — C1's answer — and its one Hit dealt %.12f Fire: Life %.0f -> %.12f"
		% [base, player.physical_damage, float(shot["stored"]), event.final_life_damage if event != null else 0.0,
			float(shot["before"]), enemy.life])
	_done("emberbolt_applies_it_once_to_its_spell_base")


# --- 11–13. The snapshot, the enemy and the empty build -------------------------------------------

func _check_a_projectile_keeps_the_damage_it_launched_with() -> void:
	print("")
	print("--- 11. A projectile launched at +10% keeps what it stored when +20% is applied in flight; the next one launches at +20%")
	var player: PrototypePlayer = practice.player
	practice.restore()
	practice.equip_index(1)
	var applied: RiftBuildApplicationResult = RiftBuildApplication.apply(_power_build(1), player, _practice_speed)
	_staged_builds += 1
	var action: FirstMvpSkillAction = practice.action_for(FirstMvpSkillLibrary.SPLINTER_SHOT_ID)
	var base: float = action.canonical_data.hit_damage(player.weapon)
	var one: PlayerStatValue = _c1(1).value_of(PlayerStats.GLOBAL_DAMAGE, base)
	var two: PlayerStatValue = _c1(2).value_of(PlayerStats.GLOBAL_DAMAGE, base)
	var enemy: PrototypeGraveblade = practice.graveblades[0]
	var shot: Dictionary = await _launch(action, enemy)
	var projectile: FirstMvpSkillProjectile = shot["projectile"]
	var changed: RiftBuildApplicationResult = RiftBuildApplication.apply(_power_build(2), player, _practice_speed)
	_staged_builds += 1
	var in_flight: bool = is_instance_valid(projectile) and not projectile.resolved
	var stored_after: float = projectile.damage if in_flight else -1.0
	await _await_resolution(shot)
	var event: FirstMvpDamageEvent = (shot["outcome"] as Dictionary).get("event") as FirstMvpDamageEvent
	var first_ok: bool = (event != null and event.final_life_damage == one.value and event.raw_damage() == one.value
		and enemy.life == maxf(float(shot["before"]) - one.value, 0.0))
	practice.restore()
	var next: Dictionary = await _launch(action, enemy)
	await _await_resolution(next)
	var next_event: FirstMvpDamageEvent = (next["outcome"] as Dictionary).get("event") as FirstMvpDamageEvent
	_expect(applied.ok and changed.ok and in_flight and float(shot["stored"]) == one.value and stored_after == one.value
			and player.increased_global_damage() == two.total_increased and first_ok
			and bool(next["launched"]) and float(next["stored"]) == two.value and next_event != null
			and next_event.final_life_damage == two.value and enemy.life == maxf(float(next["before"]) - two.value, 0.0),
		"stored %.12f at launch and %.12f in flight after +20%%; dealt %s; the next stored %.12f against C1's %.12f"
			% [float(shot["stored"]), stored_after, "nothing" if event == null else event.describe(), float(next["stored"]), two.value])
	if event != null:
		_kept_events.append([event, one.value])
	if next_event != null:
		_kept_events.append([next_event, two.value])
	print("  launched at %s storing %.12f; +20%% applied through the seam while it flew; it still stored %.12f and dealt %.12f on impact"
		% [PlayerStats.format_increased(one.total_increased), float(shot["stored"]), stored_after,
			event.final_life_damage if event != null else 0.0])
	print("  the next projectile launched at %s and stored and dealt %.12f — C1's answer at the new total"
		% [PlayerStats.format_increased(two.total_increased), float(next["stored"])])
	_done("a_projectile_keeps_the_damage_it_launched_with")


func _check_the_enemy_attack_path_is_untouched() -> void:
	print("")
	print("--- 12. With +20% held by the player, a Graveblade's Hit on the player is still exactly its own record's damage")
	var player: PrototypePlayer = practice.player
	practice.restore()
	var record: Resource = load(GRAVEBLADE_RECORD)
	var enemy: PrototypeGraveblade = practice.graveblades[0]
	_stand_practice(STRIKE_SPOT, FACING)
	enemy.place_at(STRIKE_SPOT + FACING * NEAR)
	await _settle(3)
	var life_before: float = player.life
	var taken_before: int = player.damage_taken_events
	var total: float = player.increased_global_damage()
	var began: bool = enemy.begin_attack_for_verification()
	for frame: int in 150:
		await physics_frame
		if player.damage_taken_events > taken_before:
			break
	var event: DamageEvent = player.last_damage_taken
	var recorded: float = float(record.get("physical_damage"))
	_expect(began and total == _c1(2).total_for(PlayerStats.GLOBAL_DAMAGE) and player.increased_global_damage() == total
			and player.damage_taken_events == taken_before + 1 and event != null and event.source == enemy
			and event.raw_physical_damage == recorded and event.final_life_damage == recorded
			and enemy.data.physical_damage == recorded and enemy.last_damage_dealt == event
			and player.life == life_before - recorded and roundi(recorded) == 125,
		"the Graveblade began %s and dealt %s against its record's %.0f"
			% [str(began), "nothing" if event == null else event.describe(), recorded])
	print("  the player holds %s; the Graveblade's one Hit carried raw %.12f and final %.12f — its record's own %.0f — and Life went %.0f -> %.0f"
		% [PlayerStats.format_increased(total), event.raw_physical_damage if event != null else 0.0,
			event.final_life_damage if event != null else 0.0, recorded, life_before, player.life])
	_done("the_enemy_attack_path_is_untouched")


func _check_an_empty_build_restores_the_raw_base_and_rewrites_nothing() -> void:
	print("")
	print("--- 13. An empty build restores +0% while an Emberbolt flies; it keeps what it stored, no record or earlier damage record moves, and the next Hits are raw")
	var player: PrototypePlayer = practice.player
	practice.restore()
	practice.equip_index(2)
	var action: FirstMvpSkillAction = practice.action_for(FirstMvpSkillLibrary.EMBERBOLT_ID)
	var base: float = action.canonical_data.hit_damage(player.weapon)
	var two: PlayerStatValue = _c1(2).value_of(PlayerStats.GLOBAL_DAMAGE, base)
	var enemy: PrototypeGraveblade = practice.graveblades[0]
	var shot: Dictionary = await _launch(action, enemy)
	var projectile: FirstMvpSkillProjectile = shot["projectile"]
	var restored: RiftBuildApplicationResult = RiftBuildApplication.apply(RiftRunBuild.new(), player, _practice_speed)
	_staged_builds += 1
	var in_flight: bool = is_instance_valid(projectile) and not projectile.resolved
	var stored_after: float = projectile.damage if in_flight else -1.0
	await _await_resolution(shot)
	var event: FirstMvpDamageEvent = (shot["outcome"] as Dictionary).get("event") as FirstMvpDamageEvent
	var intact: int = 0
	for kept: Array in _kept_events:
		var old: DamageEvent = kept[0]
		if old.final_life_damage == float(kept[1]) and old.raw_physical_damage == float(kept[1]):
			intact += 1
	var records: bool = _record_snapshot() == _records_at_start
	practice.restore()
	var next: Dictionary = await _launch(action, enemy)
	await _await_resolution(next)
	var next_event: FirstMvpDamageEvent = (next["outcome"] as Dictionary).get("event") as FirstMvpDamageEvent
	player.equip_weapon(load(WORN_SWORD) as PrototypeWeaponData)
	var strike: Dictionary = await _practice_strike(enemy)
	var strike_event: DamageEvent = strike["event"]
	_expect(restored.ok and restored.committed and player.increased_global_damage() == 0.0
			and restored.global_damage.value == restored.global_damage.base_value
			and in_flight and float(shot["stored"]) == two.value and stored_after == two.value and event != null
			and event.final_life_damage == two.value and enemy.life != float(shot["before"])
			and intact == _kept_events.size() and _kept_events.size() >= 10 and records
			and float(next["stored"]) == base and next_event != null and next_event.final_life_damage == base
			and strike_event != null and strike_event.final_life_damage == player.physical_damage
			and strike_event.final_life_damage == float(_records_at_start["worn"]),
		"restored %s; stored %.12f in flight; %d of %d earlier records intact; records unchanged %s; next Emberbolt %.12f; next Quick Strike %s"
			% [PlayerStats.format_increased(player.increased_global_damage()), stored_after, intact, _kept_events.size(), str(records),
				float(next["stored"]), "nothing" if strike_event == null else strike_event.describe()])
	print("  an Emberbolt launched at +20%% stored %.12f; the seam's empty build restored %s while it flew; it still stored %.12f and dealt %.12f"
		% [float(shot["stored"]), PlayerStats.format_increased(player.increased_global_damage()), stored_after,
			event.final_life_damage if event != null else 0.0])
	print("  %d of %d damage records made earlier in this range still carry exactly what they carried; every weapon, Skill, Quick Strike and Graveblade record reads as it did when the range loaded"
		% [intact, _kept_events.size()])
	print("  the next Emberbolt stored and dealt its own %.0f, and the next Quick Strike the Worn Sword's own %.0f, each to the last bit"
		% [float(next["stored"]), strike_event.final_life_damage if strike_event != null else 0.0])
	_done("an_empty_build_restores_the_raw_base_and_rewrites_nothing")


# --- 14–15. The result and the seam ----------------------------------------------------------------

func _check_the_result_refuses_every_incoherent_global_damage_shape() -> void:
	print("")
	print("--- 14. STAGED: the result's own problem() refuses every incoherent Global Damage shape, a written result included; the receipt lines say what is live")
	var player: PrototypePlayer = practice.player
	var one: RiftRunBuild = _power_build(1)
	var derived: RiftBuildApplicationResult = RiftBuildApplication.derive(one, player, _practice_speed)
	var missing: RiftBuildApplicationResult = RiftBuildApplication.derive(one, player, _practice_speed)
	missing.global_damage = null
	var wrong_stat: RiftBuildApplicationResult = RiftBuildApplication.derive(one, player, _practice_speed)
	wrong_stat.global_damage = PlayerStats.apply(PlayerStats.MAXIMUM_LIFE, wrong_stat.global_damage.base_value,
		wrong_stat.global_damage.total_increased)
	var wrong_total: RiftBuildApplicationResult = RiftBuildApplication.derive(one, player, _practice_speed)
	wrong_total.increased_global_damage = _c1(2).total_for(PlayerStats.GLOBAL_DAMAGE)
	var wrong_value: RiftBuildApplicationResult = RiftBuildApplication.derive(one, player, _practice_speed)
	var held: PlayerStatValue = wrong_value.global_damage
	wrong_value.global_damage = PlayerStatValue.computed(PlayerStats.GLOBAL_DAMAGE, held.base_value, held.total_increased,
		held.scale, held.mode, held.value + 0.000001)
	var partial_value: RiftBuildApplicationResult = RiftBuildApplicationResult.refused("staged refusal")
	partial_value.global_damage = derived.global_damage
	var partial_total: RiftBuildApplicationResult = RiftBuildApplicationResult.refused("staged refusal")
	partial_total.increased_global_damage = derived.increased_global_damage
	var written: RiftBuildApplicationResult = RiftBuildApplication.apply(one, player, _practice_speed)
	var written_clean: String = written.problem()
	written.global_damage = null
	var restored: RiftBuildApplicationResult = RiftBuildApplication.apply(RiftRunBuild.new(), player, _practice_speed)
	var rank_three: RiftRunBuild = _power_build(1)
	_expect_quiet(rank_three.acquire_support(&"quick_strike", &"sweeping_edge").is_empty(), "stage")
	_expect_quiet(rank_three.rank_support(&"quick_strike", &"sweeping_edge").is_empty(), "stage")
	_expect_quiet(rank_three.rank_support(&"quick_strike", &"sweeping_edge").is_empty(), "stage")
	var refusals: Array[RiftBuildApplicationResult] = [
		RiftBuildApplication.derive(null, player, _practice_speed),
		RiftBuildApplication.derive(rank_three, player, _practice_speed),
	]
	_staged_builds += 10
	var clean_refusals: int = 0
	for refusal: RiftBuildApplicationResult in refusals:
		if not refusal.ok and refusal.global_damage == null and refusal.increased_global_damage == 0.0 and refusal.problem().is_empty():
			clean_refusals += 1
	var answers: Array = [
		["a success missing its Global Damage derivation", missing.problem(), "a derived application is missing its Global Damage derivation"],
		["a derivation naming another stat", wrong_stat.problem(), "the Global Damage derivation names maximum_life"],
		["a copied total that is not the build's", wrong_total.problem(), "the Global Damage total +20% is not the build's own +10%"],
		["a copied value a millionth off C1's answer", wrong_value.problem(), "the Global Damage value "],
		["a refusal carrying a Global Damage derivation", partial_value.problem(), "a refused application must carry no partial value"],
		["a refusal carrying a Global Damage total", partial_total.problem(), "a refused application must carry no partial value"],
		["a written result stripped of its derivation", written.problem(), "a derived application is missing its Global Damage derivation"],
	]
	var wrong: PackedStringArray = PackedStringArray()
	for row: Array in answers:
		if not String(row[1]).begins_with(String(row[2])):
			wrong.append("%s: '%s'" % [row[0], row[1]])
	_expect(derived.ok and not derived.committed and derived.problem().is_empty() and held.problem().is_empty()
			and wrong_value.global_damage.problem().is_empty() and String(answers[3][1]).contains("is not C1's own answer")
			and written_clean.is_empty() and written.committed and restored.ok and player.increased_global_damage() == 0.0
			and wrong.is_empty() and clean_refusals == refusals.size(),
		"refusals answered: %s; %d of %d seam refusals carried no Global Damage state" % ["; ".join(wrong), clean_refusals, refusals.size()])

	## PRESENTATION: the damage line is the live change, and an empty build says nothing about
	## damage. Roguelite I14 (D-320) made Maximum Life live, so beside Vitality this moved one for
	## one: both lines are live and nothing is held.
	var mixed: RiftRunBuild = _power_build(1)
	_expect_quiet(mixed.acquire_passive_card(PassiveCardCatalogue.record(PassiveCardCatalogue.VITALITY_ID)).is_empty(), "stage")
	var mixed_result: RiftBuildApplicationResult = RiftBuildApplication.derive(mixed, player, _practice_speed)
	var empty_result: RiftBuildApplicationResult = RiftBuildApplication.derive(RiftRunBuild.new(), player, _practice_speed)
	_staged_builds += 2
	_expect(derived.applied_lines() == PackedStringArray([DAMAGE_LINE]) and derived.held_lines().is_empty()
			and mixed_result.applied_lines() == PackedStringArray([DAMAGE_LINE, VITALITY_LINE])
			and mixed_result.held_lines().is_empty()
			and mixed_result.live_lines() == PackedStringArray([DAMAGE_LINE, VITALITY_LINE])
			and empty_result.applied_lines().is_empty() and empty_result.held_lines().is_empty()
			and derived.describe().contains("global damage +10% -> ") and not derived.describe().contains("deferred [global_damage")
			and not "\n".join(mixed_result.applied_lines()).contains("Power"),
		"one Power reads %s; beside Vitality %s / %s; an empty build %s"
			% [str(derived.applied_lines()), str(mixed_result.applied_lines()), str(mixed_result.held_lines()), str(empty_result.applied_lines())])
	for row: Array in answers:
		print("  %s: '%s'" % [row[0], row[1]])
	print("  a clean derivation and a clean written result answer ''; %d of %d seam refusals carry no Global Damage derivation and a +0%% total"
		% [clean_refusals, refusals.size()])
	print("  one Power's applied line: '%s'; beside Vitality: %s, both live and nothing held; an empty build: no damage line; the description reads '%s'"
		% [DAMAGE_LINE, str(mixed_result.applied_lines()), derived.describe()])
	_done("the_result_refuses_every_incoherent_global_damage_shape")


func _check_the_seam_derives_from_the_raw_base_and_writes_the_total_first() -> void:
	print("")
	print("--- 15. The seam derives from the weapon's RAW damage — never the player's outgoing damage — and writes the total first, after its refusal test")
	var player: PrototypePlayer = practice.player
	var stacked_player: RiftBuildApplicationResult = RiftBuildApplication.apply(_power_build(2), player, _practice_speed)
	var outgoing: PlayerStatValue = player.outgoing_hit_damage(player.physical_damage)
	var derived: RiftBuildApplicationResult = RiftBuildApplication.derive(_power_build(1), player, _practice_speed)
	var answer: PlayerStatValue = _c1(1).value_of(PlayerStats.GLOBAL_DAMAGE, player.physical_damage)
	var compounded: PlayerStatValue = _c1(1).value_of(PlayerStats.GLOBAL_DAMAGE, outgoing.value)
	var first: RiftBuildApplicationResult = RiftBuildApplication.apply(_power_build(1), player, _practice_speed)
	var second: RiftBuildApplicationResult = RiftBuildApplication.apply(_power_build(1), player, _practice_speed)
	var after_twice: float = player.increased_global_damage()
	var restored: RiftBuildApplicationResult = RiftBuildApplication.apply(RiftRunBuild.new(), player, _practice_speed)
	_staged_builds += 5
	_expect(stacked_player.ok and outgoing.value != player.physical_damage
			and derived.global_damage.base_value == player.physical_damage and derived.global_damage.value == answer.value
			and derived.global_damage.value != compounded.value and first.describe() == second.describe()
			and after_twice == answer.total_increased and restored.ok and player.increased_global_damage() == 0.0,
		"over a player holding +20%% (outgoing %.12f) the seam derived %s against C1's %.12f"
			% [outgoing.value, derived.global_damage.describe(), answer.value])
	var seam: String = _bare(FileAccess.get_file_as_string(SEAM_SCRIPT))
	var derive_body: String = _function_body(seam, "derive")
	var apply_body: String = _function_body(seam, "apply")
	var leaves: int = apply_body.find("if not result.ok:")
	var writes: int = apply_body.find("player.set_increased_global_damage(")
	var refuses: int = apply_body.find("return RiftBuildApplicationResult.refused(")
	var covered: int = apply_body.find("live.")
	_expect(derive_body.count("totals.value_of(PlayerStats.GLOBAL_DAMAGE, player.physical_damage)") == 1
			and not derive_body.contains("outgoing_hit_damage") and not derive_body.contains("set_increased")
			and leaves >= 0 and writes > leaves and refuses > writes and covered > refuses
			and apply_body.count("set_increased_global_damage(") == 2 and apply_body.count("derive(") == 1,
		"apply() tests at %d, writes the total at %d, refuses at %d and writes the covered values at %d" % [leaves, writes, refuses, covered])
	print("  over a player already holding +20%% (outgoing %.12f), deriving one Power answered %.12f from the raw %.0f — C1's answer — not %.12f"
		% [outgoing.value, derived.global_damage.value, player.physical_damage, compounded.value])
	print("  one Power applied twice leaves %s; apply() tests the derivation, then writes the total, then refuses if the player refused it, then writes every other covered value"
		% PlayerStats.format_increased(after_twice))
	_done("the_seam_derives_from_the_raw_base_and_writes_the_total_first")


# --- Practice-range helpers -------------------------------------------------------------------------

## A run build holding `count` acquisitions of the accepted Power card.
func _power_build(count: int) -> RiftRunBuild:
	var build: RiftRunBuild = RiftRunBuild.new()
	for index: int in count:
		_expect_quiet(build.acquire_passive_card(PassiveCardCatalogue.record(PassiveCardCatalogue.POWER_ID)).is_empty(),
			"the build refused Power acquisition %d" % (index + 1))
	return build


## C1's own accumulator holding the accepted Power card's own magnitude `count` times —
## independent of the run build, the seam and the player.
func _c1(count: int) -> PlayerStatTotals:
	var totals: PlayerStatTotals = PlayerStatTotals.new()
	var card: PassiveCardDefinition = PassiveCardCatalogue.record(PassiveCardCatalogue.POWER_ID)
	_expect_quiet(card.stat_id == PlayerStats.GLOBAL_DAMAGE, "the Power card names %s" % card.stat_id)
	for index: int in count:
		_expect_quiet(totals.add(card.stat_id, card.magnitude).is_empty(), "C1 refused Power %d" % (index + 1))
	return totals


func _stand_practice(at: Vector3, facing: Vector3) -> void:
	var player: PrototypePlayer = practice.player
	player.global_position = at
	player.velocity = Vector3.ZERO
	player.clear_movement_intent("verification", false)
	player.face_instantly(facing)


## The three practice Graveblades back on the range's own authored spots.
func _home_graveblades() -> void:
	for index: int in practice.graveblades.size():
		var spot: Vector2 = FoundationSkillPractice.TARGET_SPOTS[index]
		practice.graveblades[index].place_at(Vector3(spot.x, 0.0, spot.y))


## One Quick Strike from the strike spot at `enemy` 1.2 m ahead, after the range's own restore.
func _practice_strike(enemy: PrototypeGraveblade) -> Dictionary:
	practice.restore()
	var attack: QuickStrikeAction = practice.player.attack
	_stand_practice(STRIKE_SPOT, FACING)
	await _settle(2)
	var spot: Vector3 = STRIKE_SPOT + FACING * NEAR
	enemy.place_at(spot)
	await _settle(3)
	_expect_quiet(_planar_gap(enemy.global_position, spot) < 0.05 and attack.phase == QuickStrikeAction.Phase.READY,
		"the Graveblade stands at %s, not at %s, or Quick Strike is busy" % [enemy.global_position, spot])
	var before: float = enemy.life
	var events: int = attack.damage_events
	practice.force_next_aim_for_verification(_area(enemy))
	attack.press()
	attack.release_input()
	_practice_uses += 1
	for frame: int in 180:
		await physics_frame
		if attack.damage_events > events and attack.phase == QuickStrikeAction.Phase.READY:
			break
	var dealt: int = attack.damage_events - events
	return {
		"before": before, "after": enemy.life, "events": dealt,
		"event": attack.last_damage_dealt if dealt == 1 else null, "taken": enemy.last_damage_taken,
	}


## Presses a projectile Skill at `enemy`, 9 m ahead of the shot spot, and returns the moment its
## projectile exists: the projectile, the damage it stored at launch, and a dictionary its one
## `finished` signal fills.
func _launch(action: FirstMvpSkillAction, enemy: PrototypeGraveblade) -> Dictionary:
	## The player first, and settled, so a Graveblade is never placed where the player's body stood on
	## the same frame — its own slide would push it off the spot. Then the Skill must be READY: a press
	## during its recovery is, correctly, ignored.
	_stand_practice(SHOT_SPOT, FACING)
	await _settle(2)
	var spot: Vector3 = SHOT_SPOT + FACING * SHOT_DISTANCE
	enemy.place_at(spot)
	await _settle(3)
	for frame: int in 240:
		if action.phase == FirstMvpSkillAction.Phase.READY:
			break
		await physics_frame
	_expect_quiet(_planar_gap(enemy.global_position, spot) < 0.05,
		"the Graveblade stands at %s, not at %s" % [enemy.global_position, spot])
	var spawned: int = action.projectiles_spawned
	var before: float = enemy.life
	practice.force_next_aim_for_verification(_area(enemy))
	action.press()
	action.release_input()
	_practice_uses += 1
	var projectile: FirstMvpSkillProjectile = null
	for frame: int in 180:
		await physics_frame
		if action.projectiles_spawned > spawned:
			projectile = _live_projectile(action.use_id)
			break
	var outcome: Dictionary = {}
	if projectile != null:
		projectile.finished.connect(func(result: Dictionary) -> void: outcome.merge(result))
	return {
		"projectile": projectile, "launched": projectile != null, "before": before, "outcome": outcome,
		"stored": projectile.damage if projectile != null else -1.0,
	}


func _await_resolution(shot: Dictionary) -> void:
	for frame: int in 240:
		if not (shot["outcome"] as Dictionary).is_empty():
			return
		await physics_frame


func _live_projectile(use_id: int) -> FirstMvpSkillProjectile:
	for child: Node in practice.get_node("Actors").get_children():
		var projectile: FirstMvpSkillProjectile = child as FirstMvpSkillProjectile
		if projectile != null and projectile.use_id == use_id and not projectile.resolved:
			return projectile
	return null


## Every weapon, Skill, Quick Strike and Graveblade number the range's Hits are made from.
func _record_snapshot() -> Dictionary:
	var snapshot: Dictionary = {
		"worn": (load(WORN_SWORD) as PrototypeWeaponData).physical_damage,
		"honed": (load(HONED_SWORD) as PrototypeWeaponData).physical_damage,
		"graveblade": float((load(GRAVEBLADE_RECORD) as Resource).get("physical_damage")),
	}
	for path: String in FoundationSkillPractice.WEAPON_PATHS:
		snapshot[path] = (load(path) as PrototypeWeaponData).physical_damage
	for id: StringName in [FirstMvpSkillLibrary.FAULTBREAKER_ID, FirstMvpSkillLibrary.SPLINTER_SHOT_ID,
			FirstMvpSkillLibrary.EMBERBOLT_ID]:
		var action: FirstMvpSkillAction = practice.action_for(id)
		snapshot[String(id)] = [
			action.canonical_data.weapon_damage_scale, action.canonical_data.spell_damage,
			action.data.weapon_damage_scale, action.data.spell_damage, action.canonical_data.damage_type,
		]
	var strike: QuickStrikeData = practice.player.attack.canonical_data
	snapshot["quick_strike"] = [
		strike.reach, strike.release_arc_degrees, strike.soft_target_cone_degrees, strike.action_time,
		strike.maximum_targets,
	]
	return snapshot


# --- The review: expedition A ----------------------------------------------------------------------

func _expedition_a() -> void:
	await _begin_expedition("A")
	_baseline = _live_values()
	await _open_level_one()
	_standing.append(_standing_snapshot("Level 1, opened on its own"))
	_take_support()
	await _settle(4)

	## Before Power: one real controller Quick Strike into the quiet Elite, 1.2 m ahead.
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var centre: Vector3 = _elite_hall_centre()
	var forward: Vector3 = _forward()
	elite.place_at(centre + forward * NEAR)
	_stand_facing(centre, forward)
	await _settle(2)
	var life: float = elite.life
	var outgoing: PlayerStatValue = review.player.outgoing_hit_damage(review.player.physical_damage)
	var swing: Dictionary = await _swing()
	_before_power = {"swing": swing, "before": life, "after": elite.life, "event": elite.last_damage_taken, "outgoing": outgoing}
	elite.place_at(centre - forward * 7.0)

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
	_before_power["standing_total"] = review.player.increased_global_damage()
	_before_power["standing_outgoing"] = review.player.outgoing_hit_damage(review.player.physical_damage)
	_before_power["applications"] = review.applications_made
	_check_before_power_a_real_strike_deals_one_hundred_and_offers_hide_the_receipts()

	_power_taken = _take_support()
	_check_power_is_live_in_the_choices_own_call()
	_quiet_room(2)
	await _capture("01_level_six_power_damage_live", 1.2)
	_receipt_measure = await _measure_receipt(POWER_RECEIPT.size(), "the Level 6 Power receipt")
	_check_the_level_six_receipt_lists_the_damage_under_live_now()
	await _check_real_strikes_after_power_deal_the_new_amount()


func _check_before_power_a_real_strike_deals_one_hundred_and_offers_hide_the_receipts() -> void:
	print("")
	print("--- 16. Before Power a real Quick Strike deals the weapon's own 100; behind the standing fallback offer the damage reading is still 100; no receipt shows while any offer stands")
	var swing: Dictionary = _before_power["swing"]
	var event: DamageEvent = _before_power["event"]
	var outgoing: PlayerStatValue = _before_power["outgoing"]
	var standing: PlayerStatValue = _before_power["standing_outgoing"]
	var raw: float = review.player.physical_damage
	_expect(String((swing["outcome"] as Dictionary).get("outcome", "")) == "hit" and int(swing["damage"]) == 1
			and int(swing["family"]) == InputFamilyTracker.Family.CONTROLLER and event != null and event.source == review.player
			and event.raw_physical_damage == raw and event.final_life_damage == raw
			and float(_before_power["after"]) == float(_before_power["before"]) - raw and outgoing.ok and outgoing.value == raw
			and roundi(raw) == 100 and float(_before_power["standing_total"]) == 0.0 and standing.ok and standing.value == raw
			and int(_before_power["applications"]) == 4 and review.application_refusals == 0,
		"before Power the real strike dealt %s; behind the fallback offer the reading was %s with %s held"
			% ["nothing" if event == null else event.describe(), standing.describe(), PlayerStats.format_increased(float(_before_power["standing_total"]))])
	var faults: PackedStringArray = PackedStringArray()
	for snap: Dictionary in _standing:
		if not (bool(snap["open"]) and bool(snap["paused"]) and snap["receipt"] == PackedStringArray(STANDING_LINES)
				and not bool(snap["live_shown"])):
			faults.append("%s: %s" % [snap["label"], str(snap)])
	_expect(_standing.size() == 5 and faults.is_empty(), "%d standing moments; %s" % [_standing.size(), "; ".join(faults)])
	print("  after Level 1, a real controller press into the Elite 1.2 m ahead: one damage record of raw %.12f and final %.12f — the Worn Sword's own — Life %.0f -> %.0f"
		% [event.raw_physical_damage if event != null else 0.0, event.final_life_damage if event != null else 0.0,
			float(_before_power["before"]), float(_before_power["after"])])
	print("  behind the standing Level 5 fallback offer, after 4 applications: %s held, and the damage reading is %.12f"
		% [PlayerStats.format_increased(float(_before_power["standing_total"])), standing.value])
	for snap: Dictionary in _standing:
		print("  %s: the receipt shows only '%s'; no live line" % [snap["label"], (snap["receipt"] as PackedStringArray)[1]])
	_done("before_power_a_real_strike_deals_one_hundred_and_offers_hide_the_receipts")


func _check_power_is_live_in_the_choices_own_call() -> void:
	print("")
	print("--- 17. Enter on the fallback's Power: in that press's own call, before another frame, the damage reading becomes C1's answer")
	var taken: Dictionary = _power_taken
	var answer: PlayerStatValue = _c1(1).value_of(PlayerStats.GLOBAL_DAMAGE, review.player.physical_damage)
	var application: RiftBuildApplicationResult = taken["application"]
	var record: RiftRunLevelUpResult = taken["record"]
	var receipt: RiftLevelUpResult = null if record == null else record.level_up()
	var reading: PlayerStatValue = taken["outgoing"]
	_expect(bool(taken["same_frame"]) and int(taken["applications"]) == 1 and review.applications_made == 5
			and review.application_refusals == 0 and float(taken["total"]) == answer.total_increased
			and reading.ok and reading.value == answer.value and roundi(reading.value) == 110
			and review.mote_runtime.run_build().total_for(PlayerStats.GLOBAL_DAMAGE) == answer.total_increased
			and application != null and application.ok and application.committed and application.problem().is_empty()
			and application.global_damage.value == answer.value and application.increased_global_damage == answer.total_increased
			and not bool(taken["open"]) and receipt != null and receipt.carries_support_fallback()
			and receipt.granted_identity() == PackedStringArray([String(PassiveCardCatalogue.POWER_ID)])
			and review.mote_runtime.level() == 6,
		"the Power press: same frame %s, %d application(s), %s held, reading %s against C1's %.12f"
			% [str(taken["same_frame"]), int(taken["applications"]), PlayerStats.format_increased(float(taken["total"])),
				reading.describe(), answer.value])
	print("  in the Enter press's own call — physics and process frames unchanged — the run's whole build went through the seam a fifth time: %s held, and the reading for the Worn Sword's %.0f is %.12f, C1's answer"
		% [PlayerStats.format_increased(float(taken["total"])), review.player.physical_damage, reading.value])
	print("  5 applications, 0 refusals; the panel closed at Rift level 6; the record granted [%s] as the passive fallback"
		% ", ".join(receipt.granted_identity() if receipt != null else PackedStringArray()))
	_done("power_is_live_in_the_choices_own_call")


func _check_the_level_six_receipt_lists_the_damage_under_live_now() -> void:
	print("")
	print("--- 18. The Level 6 receipt lists the damage under \"Live now —\" beside the rank-two spatial values; nothing is held")
	var application: RiftBuildApplicationResult = review.last_application
	var live_line: String = review.live_receipt_text()
	_expect(_receipt_lines() == PackedStringArray(POWER_RECEIPT) and live_line == LIVE_POWER
			and live_line == LIVE_PREFIX + "\n".join(application.applied_lines()) and live_line.count(LIVE_PREFIX) == 1
			and not live_line.contains(HELD_HEADING) and not live_line.contains("Global Damage") and not live_line.contains("Power")
			and application.applied_lines().size() == 2 and application.applied_lines()[1] == DAMAGE_LINE
			and application.held_lines().is_empty() and application.deferred_stats.is_empty()
			and review.live_receipt_control().is_visible_in_tree() and not paused,
		"the receipt reads %s" % str(_receipt_lines()))
	for line: String in _receipt_lines():
		print("  | %s" % line.replace("\n", " / "))
	print("  \"Live now —\" appears once; the damage is its second line; no held heading, and no card named in it")
	print("  %s" % _receipt_measure)
	_done("the_level_six_receipt_lists_the_damage_under_live_now")


func _check_real_strikes_after_power_deal_the_new_amount() -> void:
	print("")
	print("--- 19. After Power, real controller Quick Strikes deal C1's answer: once into the Elite at 3.20 m, then three into a 300-Life Graveblade")
	var answer: PlayerStatValue = _c1(1).value_of(PlayerStats.GLOBAL_DAMAGE, review.player.physical_damage)
	var centre: Vector3 = _elite_hall_centre()
	var forward: Vector3 = _forward()
	var elite: PrototypeGraveblade = review.room_enemies[2][0]
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	escort.place_at(centre - forward * 7.0)
	elite.place_at(centre + forward * BETWEEN_REACHES)
	_stand_facing(centre, forward)
	await _settle(2)
	var elite_before: float = elite.life
	var first: Dictionary = await _swing()
	var elite_event: DamageEvent = elite.last_damage_taken
	var elite_ok: bool = (String((first["outcome"] as Dictionary).get("outcome", "")) == "hit"
		and int(first["began"]) == QuickStrikeAction.Phase.WINDUP and first["target"] == _area(elite)
		and float(first["moved"]) < 0.001 and elite_event != null and elite_event.raw_physical_damage == answer.value
		and elite_event.final_life_damage == answer.value and elite.life == elite_before - answer.value)
	elite.place_at(centre - forward * 7.0)
	var trail: PackedStringArray = PackedStringArray(["%.0f" % escort.life])
	var exact: int = 0
	var alive_after: Array[bool] = []
	for strike: int in 3:
		escort.place_at(centre + forward * NEAR)
		_stand_facing(centre, forward)
		await _settle(2)
		var before: float = escort.life
		var swing: Dictionary = await _swing()
		var event: DamageEvent = escort.last_damage_taken
		if (int(swing["damage"]) == 1 and event != null and event.final_life_damage == answer.value
				and event.raw_physical_damage == answer.value and escort.life == maxf(before - answer.value, 0.0)):
			exact += 1
		alive_after.append(escort.is_alive())
		trail.append("%.0f" % escort.life)
	var experience: float = review.mote_runtime.experience()
	var paid: bool = _award([REVIEW_AMOUNT])
	var mote_ok: bool = paid and review.mote_runtime.experience() == experience + REVIEW_AMOUNT
	_expect(elite_ok and exact == 3 and str(alive_after) == "[true, true, false]" and roundi(escort.data.max_life) == 300
			and roundi(answer.value) == 110 and mote_ok and review.player.physical_damage == float(_baseline["weapon_damage"]),
		"after Power: the Elite %s; %d of 3 exact into the escort (%s); a mote paid %s"
			% [str(elite_ok), exact, " -> ".join(trail), str(mote_ok)])
	print("  3.20 m ahead, inside rank two's 3.65 m: the real press wound up without stepping and its one damage record carried %.12f — C1's answer — Elite %.0f -> %.0f"
		% [elite_event.final_life_damage if elite_event != null else 0.0, elite_before, elite.life])
	print("  a 300-Life Graveblade 1.2 m ahead, three real presses: %s — %d of 3 exactly C1's answer; %.0f damage still takes three hits"
		% [" -> ".join(trail), exact, answer.value])
	print("  an Experience Mote collected after Power paid exactly its %.0f: Global Damage moves no experience" % REVIEW_AMOUNT)
	_done("real_strikes_after_power_deal_the_new_amount")


# --- The expedition's end, the next one, and the Vitality lane --------------------------------------

func _check_f5_restores_the_damage_and_every_covered_baseline() -> void:
	print("")
	print("--- 20. F5 ends the expedition, and the one empty-build restoration returns Global Damage to +0% with every covered baseline")
	var before: Dictionary = _live_values()
	var restorations: int = review.restorations_made
	await _key(KEY_F5)
	await _settle(4)
	var after: Dictionary = _live_values()
	var restored: RiftBuildApplicationResult = review.last_restoration
	_expect(float(before["global"]) == _c1(1).total_for(PlayerStats.GLOBAL_DAMAGE) and float(before["outgoing"]) != float(before["weapon_damage"])
			and review.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB and review.mote_runtime == null
			and review.restorations_made == restorations + 1 and restored != null and restored.ok and restored.committed
			and restored.global_damage.total_increased == 0.0 and restored.global_damage.value == restored.global_damage.base_value
			and after == _baseline and float(after["global"]) == 0.0 and float(after["outgoing"]) == float(after["weapon_damage"])
			and review.last_application == null and review.live_receipt_text().is_empty() and not paused,
		"F5: %s -> %s against %s" % [str(before), str(after), str(_baseline)])
	print("  %s -> %s" % [_live_line(before), _live_line(after)])
	print("  restored by the seam from an empty build: %s" % ("none" if restored == null else restored.describe()))
	_done("f5_restores_the_damage_and_every_covered_baseline")


func _check_the_next_expedition_starts_at_global_damage_zero() -> void:
	print("")
	print("--- 21. The next expedition begins with an empty build, +0% Global Damage and the raw base")
	await _begin_expedition("B")
	var build: RiftRunBuild = review.mote_runtime.run_build()
	var live: Dictionary = _live_values()
	_expect(build.is_empty() and build.total_for(PlayerStats.GLOBAL_DAMAGE) == 0.0 and build.acquisitions_for(PassiveCardCatalogue.POWER_ID) == 0
			and float(live["global"]) == 0.0 and float(live["outgoing"]) == float(live["weapon_damage"]) and live == _baseline
			and review.last_application == null and review.mote_runtime.level() == 1 and review.mote_runtime.run_seed() == ROUTE_SEED,
		"B began with %s / %s" % [build.describe(), str(live)])
	print("  B began at Rift level 1, run seed %d: an empty build, card_power 0, %s held; %s" % [ROUTE_SEED,
		PlayerStats.format_increased(float(live["global"])), _live_line(live)])
	_done("the_next_expedition_starts_at_global_damage_zero")


## Roguelite I14 (D-320) made Maximum Life live, and this check moved one for one: the same press on
## the same card now enlarges the character from 500 / 500 to 575 / 575, C1's answer with Life's
## fraction kept, and says so under "Live now"; the damage still does not move.
func _check_vitality_is_live_and_keeps_full_life() -> void:
	print("")
	print("--- 22. Expedition B takes the same Supports and then the fallback's Vitality: Maximum Life is live (D-320) — 500 / 500 becomes 575 / 575 — and the damage does not move")
	var max_life: float = review.player.max_life
	var life: float = review.player.life
	## The review's counters run across expeditions: B's own five applications are counted from here.
	var applications: int = review.applications_made
	await _open_level_one()
	_take_support()
	await _settle(4)
	await _award_and_wait([LEVEL_TWO_AMOUNT])
	_take_support()
	await _settle(4)
	await _award_and_wait(CHAIN_AMOUNTS)
	_take_support()
	_take_support()
	await _joy(JOY_BUTTON_DPAD_RIGHT)
	var focused: bool = root.gui_get_focus_owner() == review.level_up_panel.card_buttons()[1]
	var physics: int = Engine.get_physics_frames()
	var process: int = Engine.get_process_frames()
	_push_joy(JOY_BUTTON_A, true)
	var same_frame: bool = Engine.get_physics_frames() == physics and Engine.get_process_frames() == process
	var record: RiftRunLevelUpResult = review.last_choice_record
	var application: RiftBuildApplicationResult = review.last_application
	_push_joy(JOY_BUTTON_A, false)
	await _await_process_frames(1)
	_quiet_room(2)
	await _capture("02_level_six_vitality_held", 1.2)
	_vitality_measure = await _measure_receipt(VITALITY_RECEIPT.size(), "the Level 6 Vitality receipt")
	var receipt: RiftLevelUpResult = null if record == null else record.level_up()
	var live: Dictionary = _live_values()
	var label: Label = _life_label()
	var live_line: String = review.live_receipt_text()
	var maximum: PlayerStatValue = PlayerStats.apply(PlayerStats.MAXIMUM_LIFE, max_life,
		PassiveCardCatalogue.record(PassiveCardCatalogue.VITALITY_ID).magnitude)
	_expect(focused and same_frame and receipt != null and record.succeeded() and receipt.lane == 1
			and receipt.granted_identity() == PackedStringArray([String(PassiveCardCatalogue.VITALITY_ID)])
			and application != null and application.ok and application.committed
			and application.deferred_stats.is_empty() and application.increased_global_damage == 0.0
			and maximum.ok and application.maximum_life.value == maximum.value
			and review.mote_runtime.run_build().total_for(PlayerStats.MAXIMUM_LIFE) == maximum.total_increased
			and review.player.max_life == maximum.value and review.player.life == maximum.value
			and roundi(max_life) == 500 and roundi(life) == 500 and roundi(maximum.value) == 575
			and float(live["global"]) == 0.0 and float(live["outgoing"]) == float(live["weapon_damage"])
			and review.applications_made == applications + 5 and review.application_refusals == 0 and review.mote_runtime.level() == 6,
		"the Vitality press: focused %s, same frame %s, deferred %s; Life %.0f / %.0f from %.0f / %.0f"
			% [str(focused), str(same_frame), "none" if application == null else _joined(application.deferred_stats),
				review.player.life, review.player.max_life, life, max_life])
	_expect(_receipt_lines() == PackedStringArray(VITALITY_RECEIPT) and live_line == LIVE_VITALITY
			and not live_line.contains(HELD_HEADING) and live_line.get_slice(LIVE_PREFIX, 1).contains("Maximum Life")
			and not live_line.contains("damage") and label != null and label.is_visible_in_tree() and label.text == LIFE_LINE,
		"the Vitality receipt reads %s; the Life display '%s'" % [str(_receipt_lines()), "none" if label == null else label.text])
	for line: String in _receipt_lines():
		print("  | %s" % line.replace("\n", " / "))
	print("  Maximum Life %.0f -> %.0f and Life %.0f -> %.0f, its fraction kept; the Life display reads '%s'; Global Damage %s; the damage reading %.12f, the raw base"
		% [max_life, review.player.max_life, life, review.player.life, "none" if label == null else label.text,
			PlayerStats.format_increased(float(live["global"])), float(live["outgoing"])])
	print("  %s" % _vitality_measure)
	await _key(KEY_F5)
	await _settle(4)
	_expect_quiet(review.mote_runtime == null and _live_values() == _baseline, "B's own F5 left %s" % str(_live_values()))
	_done("vitality_is_live_and_keeps_full_life")


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


# --- Review helpers, ported from the accepted I12 harness --------------------------------------------

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
		enemy.name = "I13Fixture%d" % _fixtures
		enemy.position = at
		_stage.add_child(enemy)
		enemy.set_ai_enabled(false)
		registered = registered and runtime.register_graveblade(enemy, float(amount)).is_empty()
		enemy.receive_damage(DamageEvent.physical(_use(), review.player, enemy, enemy.life + 1000.0))
		registered = registered and not enemy.is_alive() and runtime.emission_answer(enemy).is_empty()
		expected.append(drops + expected.size())
		total += float(amount)
	var answer: RiftMoteSweepResult = runtime.sweep_at(at)
	## Presentation only: H9's panel is told to read the run again, as I11's and I12's harnesses do.
	review.experience_hud.refresh()
	return registered and answer.ok and answer.collected_indices() == expected and runtime.experience() == before + total


## One Enter press on the focused Support card, read in that press's own call stack — before any
## frame can pass — then released.
func _take_support() -> Dictionary:
	var physics: int = Engine.get_physics_frames()
	var process: int = Engine.get_process_frames()
	var applications: int = review.applications_made
	var choices: int = review.choices_taken
	_push_key(KEY_ENTER, true)
	var taken: Dictionary = {
		"same_frame": Engine.get_physics_frames() == physics and Engine.get_process_frames() == process,
		"applications": review.applications_made - applications,
		"total": review.player.increased_global_damage(),
		"outgoing": review.player.outgoing_hit_damage(review.player.physical_damage),
		"open": review.level_up_panel.is_open,
		"application": review.last_application,
		"record": review.last_choice_record,
	}
	_push_key(KEY_ENTER, false)
	_expect_quiet(review.choices_taken == choices + 1 and int(taken["applications"]) == 1 and bool(taken["same_frame"]),
		"a Support choice was not taken and applied in its own call")
	return taken


func _standing_snapshot(label: String) -> Dictionary:
	return {
		"label": label, "open": review.level_up_panel.is_open, "paused": paused,
		"receipt": _receipt_lines(), "live_shown": review.live_receipt_control().is_visible_in_tree(),
	}


func _live_values() -> Dictionary:
	var strike: QuickStrikeData = review.player.attack.data
	return {
		"max_speed": review.player.max_speed, "increased": review.player.increased_attack_speed(),
		"effective": review.player.attack.effective_action_time(), "reach": strike.reach,
		"arc": strike.release_arc_degrees, "cone": strike.soft_target_cone_degrees, "targets": strike.maximum_targets,
		"weapon_damage": review.player.physical_damage, "max_life": review.player.max_life,
		"global": review.player.increased_global_damage(),
		"outgoing": review.player.outgoing_hit_damage(review.player.physical_damage).value,
	}


func _live_line(live: Dictionary) -> String:
	return "movement %.1f m/s, action time %.2f s, reach %.2f m, arc %.0f°, cone %.0f°, %d target(s), Global Damage %s, damage %.12f" % [
		float(live["max_speed"]), float(live["effective"]), float(live["reach"]), float(live["arc"]),
		float(live["cone"]), int(live["targets"]), PlayerStats.format_increased(float(live["global"])), float(live["outgoing"])]


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


func _life_label() -> Label:
	if review.hud == null:
		return null
	for node: Node in review.hud.find_children("*", "Label", true, false):
		var label: Label = node as Label
		if label != null and label.text.begins_with("Life — "):
			return label
	return null


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


## One press and release of the controller's Quick Strike button through the viewport, followed
## until the action is READY again.
func _swing() -> Dictionary:
	await _until_neutral()
	await _until_ready()
	await _as_controller()
	var attack: QuickStrikeAction = review.player.attack
	var start_at: Vector3 = review.player.global_position
	var marks: Dictionary = {"finish": -1, "outcome": {}, "windup_at": start_at}
	var on_release: Callable = func(_id: int, outcome: Dictionary) -> void:
		marks["outcome"] = outcome
	var on_phase: Callable = func(next: int) -> void:
		if next == QuickStrikeAction.Phase.WINDUP:
			marks["windup_at"] = review.player.global_position
		if next == QuickStrikeAction.Phase.READY and int(marks["finish"]) < 0:
			marks["finish"] = Engine.get_physics_frames()
	attack.use_released.connect(on_release)
	attack.phase_changed.connect(on_phase)
	var damage: int = attack.damage_events
	_push_joy(QUICK_STRIKE_BUTTON, true)
	marks["family"] = review.input_family.family
	var began: int = attack.phase
	var target: PrototypeTargetable = attack.target
	_push_joy(QUICK_STRIKE_BUTTON, false)
	_presses += 1
	for frame: int in 300:
		await physics_frame
		if int(marks["finish"]) >= 0 or began == QuickStrikeAction.Phase.READY:
			break
	attack.use_released.disconnect(on_release)
	attack.phase_changed.disconnect(on_phase)
	marks["began"] = began
	marks["target"] = target
	marks["moved"] = _planar_gap(start_at, marks["windup_at"] as Vector3)
	marks["damage"] = attack.damage_events - damage
	return marks


func _until_neutral() -> void:
	for frame: int in 30:
		if not review.player.awaiting_neutral and not paused:
			return
		await _await_process_frames(1)


## Waits until the action is READY and returns from the idle step, so a press is never pushed from
## inside a physics-frame resume (I3's lesson).
func _until_ready() -> void:
	for frame: int in 300:
		if review.player.attack.phase == QuickStrikeAction.Phase.READY:
			break
		await physics_frame
	await process_frame


## The accepted tracker refuses a family change inside its anti-flicker cooldown (I3's lesson).
func _as_controller() -> void:
	if review.input_family.family == InputFamilyTracker.Family.CONTROLLER:
		return
	await create_timer(review.input_family.switch_cooldown_seconds + 0.05).timeout
	await process_frame


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

func _area(enemy: PrototypeGraveblade) -> PrototypeTargetable:
	return enemy.get_node_or_null("TargetArea") as PrototypeTargetable


func _use() -> int:
	_next_use_id += 1
	return _next_use_id


func _rounded(at: Vector3) -> Vector3:
	return Vector3(roundf(at.x), 0.0, roundf(at.z))


func _planar_gap(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()


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
