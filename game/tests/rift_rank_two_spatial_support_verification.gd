extends SceneTree
## Riftwrought — Roguelite I4: Rank-Two Spatial Support Effects — automated
## verification (decision D-298).
##
## ONE FOCUSED HEADLESS TEST. I4 gives the two shipped spatial supports an exact
## rank-two record in `SkillSupportCatalogue` and lets the accepted I3 run-build seam
## consume it. It adds no scene, panel, HUD, evidence frame or playable review, and
## this suite builds none: it runs as a `SceneTree` script, as the foundation suites do.
##
## THE MECHANISM IS MEASURED ON THE REAL KERNEL, IN A FIXTURE MADE OF NODES. The stage
## below is a flat floor, a navigation mesh laid over it, the production player scene
## and the production Graveblade scene — nodes this suite creates and frees, never a
## scene file. Every reach, arc and cone is measured by the ACCEPTED code that uses it
## in play: `TargetAcquisition.resolve_release()` (the one release query),
## `TargetAcquisition.soft_target()` (the controller soft-target search), and the
## player's own `QuickStrikeAction` ticking in the physics step — its approach, its
## wind-up, its one release query and its one damage event.
##
## WHAT IS STAGED, STATED WHERE IT HAPPENS:
##   1. every build is composed by this harness through the accepted run build's own
##      `acquire_support()` and `rank_support()` — the operations the accepted level-up
##      choice calls — because no playable route reaches rank two: one playable
##      level-up exists and more are deferred. The three seed-99 builds of check 17 are
##      the exception, and are produced by the accepted run-level coordinator itself;
##   2. a press enters at the kernel's own `press()`, exactly as the accepted room's
##      input handler calls it, and the aim is the accepted room's CONTROLLER provider
##      with the stick at rest and no retained target — the kernel's own
##      `soft_target()` along the facing. The viewport, the input family and the room's
##      routing are not exercised here; I3 proved them at rank one, and none reads a rank;
##   3. every Graveblade is the production scene with its AI switched off, placed with
##      its own `place_at()`, so an angle, a distance and a Life are exact;
##   4. check 12 writes three numbers straight into the live private record, once, to
##      prove the seam derives from the canonical record rather than from what the
##      actor holds — the one place this suite writes a live value itself, and the
##      seam overwrites it.
##
## EVERY EXPECTED VALUE IS A TYPED LITERAL FROM THE BRIEF OR AN ACCEPTED MECHANISM'S OWN
## ANSWER, asked directly, and EVERY PRINTED LINE CARRIES WHAT WAS MEASURED rather than
## what was expected — the runner reads those lines back as evidence, and a line that
## restates the expectation would prove nothing the count does not. IT PORTS D-211's
## OWED-SET DISCIPLINE: every check records reaching its LAST line, and the suite
## compares that set to what it owes in both directions.
##
## Run: godot --headless --path game --script res://tests/rift_rank_two_spatial_support_verification.gd

const CATALOGUE_FILE: String = "res://scripts/skills/skill_support_catalogue.gd"
const SEAM_FILE: String = "res://scripts/roguelite/live_effects/rift_build_application.gd"
const RESULT_FILE: String = "res://scripts/roguelite/live_effects/rift_build_application_result.gd"
const PLAYER_SCENE: String = "res://scenes/actors/prototype_player.tscn"
const GRAVEBLADE_SCENE: String = "res://scenes/actors/prototype_graveblade.tscn"
const CANONICAL_QUICK_STRIKE: String = "res://data/prototype_zero/quick_strike.tres"
const CANONICAL_DATA_ROOT: String = "res://data"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31
const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]

## The ids this suite drives, typed independently of the catalogue.
const QUICK_STRIKE: StringName = &"quick_strike"
const REACHING: StringName = &"reaching_edge"
const SWEEPING: StringName = &"sweeping_edge"
const UNCATALOGUED: StringName = &"invented_support"
const ROUTE_SEED: int = 99
const REVIEW_AMOUNT: float = 25.0
const LEVEL_ONE_MOTES: int = 4

## The accepted canonical baselines (D-175, D-178 and the canonical Quick Strike record).
const ACCEPTED_MAX_SPEED: float = 5.0
const ACCEPTED_ACTION_TIME: float = 0.80
const ACCEPTED_REACH: float = 1.65
const ACCEPTED_ARC: float = 100.0
const ACCEPTED_CONE: float = 65.0
const ACCEPTED_MARGIN: float = 0.10
const ACCEPTED_MARKER: float = 0.325
const ACCEPTED_DAMAGE: float = 100.0
const GRAVEBLADE_LIFE: float = 300.0
const ONE_CARD: float = 0.10
const FLEET_SPEED: float = 5.5

## THE AUTHORITATIVE REVIEW TABLE, typed from the brief (D-298). Absolute values.
const REACH_RANK_ONE: float = 2.65
const REACH_RANK_TWO: float = 3.65
const ARC_RANK_ONE: float = 180.0
const ARC_RANK_TWO: float = 260.0
const CONE_RANK_ONE: float = 110.0
const CONE_RANK_TWO: float = 155.0

## The catalogue's six value constants by name, each with its typed value.
const VALUE_CONSTANTS: Dictionary = {
	"REACHING_EDGE_RANK_ONE_REACH": REACH_RANK_ONE,
	"REACHING_EDGE_RANK_TWO_REACH": REACH_RANK_TWO,
	"SWEEPING_EDGE_RANK_ONE_RELEASE_ARC_DEGREES": ARC_RANK_ONE,
	"SWEEPING_EDGE_RANK_ONE_SOFT_TARGET_CONE_DEGREES": CONE_RANK_ONE,
	"SWEEPING_EDGE_RANK_TWO_RELEASE_ARC_DEGREES": ARC_RANK_TWO,
	"SWEEPING_EDGE_RANK_TWO_SOFT_TARGET_CONE_DEGREES": CONE_RANK_TWO,
}

## The probes. Every one sits clear of both boundaries it separates.
const FACING: Vector3 = Vector3(0.0, 0.0, 1.0)
const BETWEEN_REACHES: float = 3.20   ## beyond rank one's 2.65 m, inside rank two's 3.65 m
const APPROACH_FROM: float = 4.50     ## beyond every reach, inside the 5.0 m acquisition distance
const WIDE_ANGLE: float = 110.0       ## outside rank one's +/-90 deg arc, inside rank two's +/-130 deg
const CONE_ANGLE: float = 70.0        ## outside rank one's +/-55 deg cone, inside rank two's +/-77.5 deg
const CONE_DISTANCE: float = 3.00
const NEAR_TARGET: float = 1.20
const FAR_TARGET: float = 1.40
const COMBINED_ANGLE: float = 120.0
const COMBINED_DISTANCE: float = 3.40
const FLOOR_SIZE: float = 60.0

## The seam's refusals, typed independently.
const REACHING_RANK_THREE_REFUSAL: String = "reaching_edge on quick_strike is held at rank 3, and the catalogue holds reviewed values only for ranks 1 and 2; nothing was applied"
const SWEEPING_RANK_THREE_REFUSAL: String = "sweeping_edge on quick_strike is held at rank 3, and the catalogue holds reviewed values only for ranks 1 and 2; nothing was applied"
const SWEEPING_RANK_FOUR_REFUSAL: String = "sweeping_edge on quick_strike is held at rank 4, and the catalogue holds reviewed values only for ranks 1 and 2; nothing was applied"
const UNCATALOGUED_REFUSAL: String = "invented_support on quick_strike is held at rank 1, and the catalogue holds no reviewed value for it at any rank; nothing was applied"

## I3's accepted seed-99 answers (D-295, D-297), typed from its delivery record. Roguelite I13
## (D-318) added the Global Damage derivation to the seam's own account, so the description
## moved one for one: at +0% the weapon's 100 is its own answer.
## Roguelite I14's correction (D-321) added the Maximum Life derivation and the Life transition to
## the seam's describe(), so this line moved one for one: the Sweeping Edge build holds no Vitality,
## at full Life, and the count does not move.
const I3_SWEEPING_DESCRIBE: String = "quick_strike; skill speed +0% -> 0.800000000 s; movement +0% -> 5.000 m/s; global damage +0% -> 100.000 from 100.000; maximum life +0% -> 500.000 from 500.000; life 500.000/500.000 -> 500.000/500.000; reach 1.65 m, arc 180 deg, cone 110 deg, 1 target(s); supports [quick_strike -> sweeping_edge rank 1]; run path []; deferred []; committed"
const I3_SEED_99: Array = [
	["quick_strike, sweeping_edge", "Live now — arc 100° → 180° · cone 65° → 110° · one target"],
	["card_celerity", "Live now — action time 0.80 s → 0.727 s"],
	["card_fleetness", "Live now — movement speed 5.0 m/s → 5.5 m/s"],
]

## The only project classes each edited or read file may name — measured before the
## first I4 edit and unchanged by it, so no whole-project walker gains a name to see.
const CATALOGUE_NAMES: Array[String] = [
	"FirstMvpSkillData", "FirstMvpSkillLibrary", "QuickStrikeData", "RogueliteUpgrade",
	"SkillSupportCatalogue", "SkillTagProfile", "SkillTags", "SupportDefinition", "SupportEligibility",
]
const SEAM_NAMES: Array[String] = [
	"PlayerStatTotals", "PlayerStatValue", "PlayerStats", "PrototypePlayer", "QuickStrikeAction",
	"QuickStrikeData", "RiftBuildApplication", "RiftBuildApplicationResult", "RiftRunBuild",
	"SkillSupportCatalogue",
]
## Roguelite I14 (D-320) moved the result's set one for one: it now also names the player's class,
## for the player's two pure static Life functions it re-derives a transition through, and nothing
## else of it. The seam's set did not move.
const RESULT_NAMES: Array[String] = [
	"PlayerStatTotals", "PlayerStatValue", "PlayerStats", "PrototypePlayer", "QuickStrikeData",
	"RiftBuildApplication", "RiftBuildApplicationResult",
]

## A support id, a support name or a rank constant retyped in an application file.
const RETYPED_TOKENS: Array[String] = [
	"\"reaching_edge\"", "\"sweeping_edge\"", "\"quick_strike\"", "REACHING_EDGE", "SWEEPING_EDGE",
	"EDGE_RANK", "RANK_ONE", "RANK_TWO", "Reaching Edge", "Sweeping Edge",
]

## I3's own rank-arithmetic tokens (its SEAM_FORBIDDEN_TOKENS), asked again here.
const RANK_ARITHMETIC_TOKENS: Array[String] = ["rank *", "* rank", "rank +", "+ rank", "rank -", "rank /"]

## What neither edited production file may name in CODE: storage, input, a scene, a
## node tree or a control.
const INERT_TOKENS: Array[String] = [
	"user://", "ConfigFile", "ResourceSaver", "FileAccess", "DirAccess", "save(", "store_",
	"InputMap", "Input.", "PackedScene", "instantiate", "add_child", "CanvasLayer", "Control",
	"get_tree", "signal ",
]

const OWED_CHECKS: Array[String] = [
	"the_fixture_is_the_production_kernel_at_every_baseline",
	"the_rank_one_records_are_unchanged",
	"exact_rank_two_records_exist_for_both_supports",
	"the_catalogue_owns_every_concrete_value",
	"no_application_file_retypes_a_support_id_or_effect_number",
	"no_arithmetic_derives_rank_two_from_rank_one",
	"reaching_edge_moves_the_real_reach_boundary_both_ways",
	"sweeping_edge_moves_the_real_release_boundary_both_ways",
	"sweeping_edge_moves_the_real_soft_target_boundary_both_ways",
	"both_ranks_stay_single_target_non_area_and_damage_neutral",
	"both_supports_coexist_at_rank_two",
	"the_same_build_twice_or_in_another_order_changes_nothing",
	"an_empty_build_restores_the_canonical_baselines",
	"rank_three_refuses_before_any_live_write",
	"a_refusal_leaves_every_covered_value_unchanged",
	"the_canonical_records_are_unchanged",
	"i3s_rank_one_seed_99_behaviour_is_unchanged",
	"no_scene_ui_input_map_entrypoint_or_persistence_changed",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}

var _stage: Node3D = null
var _player: PrototypePlayer = null
var _acquisition: TargetAcquisition = null
var _enemies: Array[PrototypeGraveblade] = []
var _hits: Dictionary = {}
var _events: int = 0
var _spawned: int = 0
var _presses: int = 0
var _applications: int = 0
var _refusals: int = 0
var _hashes_before: Dictionary = {}


func _initialize() -> void:
	_run()


func _run() -> void:
	await process_frame
	print("")
	print("=== Roguelite I4 — Rank-Two Spatial Support Effects verification (D-298) ===")
	_hashes_before = _canonical_hashes()
	await _build_fixture()

	_check_the_fixture_is_the_production_kernel_at_every_baseline()
	_check_the_rank_one_records_are_unchanged()
	_check_exact_rank_two_records_exist_for_both_supports()
	_check_the_catalogue_owns_every_concrete_value()
	_check_no_application_file_retypes_a_support_id_or_effect_number()
	_check_no_arithmetic_derives_rank_two_from_rank_one()
	await _check_reaching_edge_moves_the_real_reach_boundary_both_ways()
	await _check_sweeping_edge_moves_the_real_release_boundary_both_ways()
	await _check_sweeping_edge_moves_the_real_soft_target_boundary_both_ways()
	await _check_both_ranks_stay_single_target_non_area_and_damage_neutral()
	await _check_both_supports_coexist_at_rank_two()
	_check_the_same_build_twice_or_in_another_order_changes_nothing()
	_check_an_empty_build_restores_the_canonical_baselines()
	_check_rank_three_refuses_before_any_live_write()
	await _check_a_refusal_leaves_every_covered_value_unchanged()
	_check_the_canonical_records_are_unchanged()
	_check_i3s_rank_one_seed_99_behaviour_is_unchanged()
	_check_no_scene_ui_input_map_entrypoint_or_persistence_changed()

	_check_every_check_ran()

	await _clear_enemies()
	_stage.queue_free()
	await process_frame
	print("")
	print("  %d real Quick Strike presses, %d production Graveblades placed, %d builds applied through the seam (%d refused), %d kernel log lines heard; the fixture freed"
		% [_presses, _spawned, _applications, _refusals, _events])
	if _failures.is_empty():
		print("RIFT RANK TWO SPATIAL SUPPORT VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT RANK TWO SPATIAL SUPPORT VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- The fixture -------------------------------------------------------------------------------------------------

## A floor on the world layer, a navigation mesh laid over it, and the production
## player scene with its Quick Strike set up exactly as the accepted room sets it up.
func _build_fixture() -> void:
	_stage = Node3D.new()
	_stage.name = "I4Stage"
	root.add_child(_stage)

	var ground: StaticBody3D = StaticBody3D.new()
	ground.name = "Floor"
	ground.collision_layer = TargetAcquisition.WORLD_MASK
	ground.collision_mask = 0
	var shape: CollisionShape3D = CollisionShape3D.new()
	var box: BoxShape3D = BoxShape3D.new()
	box.size = Vector3(FLOOR_SIZE, 1.0, FLOOR_SIZE)
	shape.shape = box
	shape.position = Vector3(0.0, -0.5, 0.0)
	ground.add_child(shape)
	_stage.add_child(ground)

	## One clockwise quad, the winding Godot's navigation mesh expects.
	var half: float = FLOOR_SIZE * 0.5
	var mesh: NavigationMesh = NavigationMesh.new()
	mesh.vertices = PackedVector3Array([
		Vector3(-half, 0.0, -half), Vector3(half, 0.0, -half),
		Vector3(half, 0.0, half), Vector3(-half, 0.0, half),
	])
	mesh.add_polygon(PackedInt32Array([0, 1, 2, 3]))
	var region: NavigationRegion3D = NavigationRegion3D.new()
	region.name = "Navigation"
	region.navigation_mesh = mesh
	_stage.add_child(region)

	_player = (load(PLAYER_SCENE) as PackedScene).instantiate() as PrototypePlayer
	_player.name = "Player"
	_stage.add_child(_player)
	_acquisition = TargetAcquisition.new(_stage.get_world_3d())
	_player.attack.setup(_player, _acquisition, _controller_aim, _candidates, _log_event)

	var map: RID = _stage.get_world_3d().navigation_map
	for frame: int in 60:
		if NavigationServer3D.map_get_iteration_id(map) > 0:
			break
		await physics_frame
	await _settle(4)


## The accepted room's controller aim provider (`BrokenWatchSlice._controller_aim_provider`)
## with the stick at rest and no retained target: the kernel's own soft-target search
## along the facing, read from the player's LIVE record.
func _controller_aim() -> Dictionary:
	var intended: Vector3 = _player.facing_direction()
	var outcome: Dictionary = _acquisition.soft_target(
		_player.global_position, intended, _candidates(), _player.attack.data, null)
	return {"target": outcome["target"], "direction": intended, "reason": String(outcome["reason"])}


## The accepted room's candidate provider: every placed Graveblade's target area.
func _candidates() -> Array[PrototypeTargetable]:
	var found: Array[PrototypeTargetable] = []
	for enemy: PrototypeGraveblade in _enemies:
		if not is_instance_valid(enemy):
			continue
		var area: PrototypeTargetable = enemy.get_node_or_null("TargetArea") as PrototypeTargetable
		if area != null:
			found.append(area)
	return found


func _log_event(_event: String, _detail: String) -> void:
	_events += 1


## One production Graveblade, its AI off, placed with its own `place_at()`.
func _spawn(at: Vector3) -> PrototypeGraveblade:
	var enemy: PrototypeGraveblade = (load(GRAVEBLADE_SCENE) as PackedScene).instantiate() as PrototypeGraveblade
	_spawned += 1
	enemy.name = "Graveblade%d" % _spawned
	enemy.position = Vector3(at.x, 0.0, at.z)
	_stage.add_child(enemy)
	enemy.set_ai_enabled(false)
	enemy.place_at(at)
	var id: int = enemy.get_instance_id()
	_hits[id] = 0
	enemy.took_damage.connect(func(_hit: DamageEvent) -> void: _hits[id] = int(_hits[id]) + 1)
	_enemies.append(enemy)
	await _settle(2)
	return enemy


func _clear_enemies() -> void:
	_player.clear_movement_intent("verification", false)
	for enemy: PrototypeGraveblade in _enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	_enemies.clear()
	await process_frame
	await _settle(1)


func _stand_facing(at: Vector3, facing: Vector3) -> void:
	_player.global_position = Vector3(at.x, 0.0, at.z)
	_player.velocity = Vector3.ZERO
	_player.clear_movement_intent("verification", false)
	_player.face_instantly(facing)


func _at(angle_degrees: float, distance: float) -> Vector3:
	return FACING.rotated(Vector3.UP, deg_to_rad(angle_degrees)) * distance


# --- Builds and the seam -------------------------------------------------------------------------------------------

## A build holding Reaching Edge and Sweeping Edge at the given ranks (0 = not held),
## Reaching Edge acquired first, through the run build's own two operations.
func _build(reaching_rank: int, sweeping_rank: int, cards: Array[StringName] = []) -> RiftRunBuild:
	var build: RiftRunBuild = RiftRunBuild.new()
	for card: StringName in cards:
		_expect_quiet(build.acquire_passive_card(PassiveCardCatalogue.record(card)).is_empty(), "stage %s" % card)
	_raise(build, REACHING, reaching_rank)
	_raise(build, SWEEPING, sweeping_rank)
	return build


func _raise(build: RiftRunBuild, support_id: StringName, rank: int) -> void:
	if rank <= 0:
		return
	_expect_quiet(build.acquire_support(QUICK_STRIKE, support_id).is_empty(), "stage %s" % support_id)
	for step: int in range(1, rank):
		_expect_quiet(build.rank_support(QUICK_STRIKE, support_id).is_empty(), "stage %s rank" % support_id)
	_expect_quiet(build.support_rank_for(QUICK_STRIKE, support_id) == rank,
		"the staged %s did not reach rank %d" % [support_id, rank])


func _apply(build: RiftRunBuild) -> RiftBuildApplicationResult:
	var result: RiftBuildApplicationResult = RiftBuildApplication.apply(build, _player, ACCEPTED_MAX_SPEED)
	_applications += 1
	if not result.ok:
		_refusals += 1
	return result


func _live() -> Dictionary:
	var strike: QuickStrikeData = _player.attack.data
	return {
		"max_speed": _player.max_speed,
		"increased": _player.increased_attack_speed(),
		"effective": _player.attack.effective_action_time(),
		"action_time": strike.action_time,
		"reach": strike.reach,
		"arc": strike.release_arc_degrees,
		"cone": strike.soft_target_cone_degrees,
		"targets": strike.maximum_targets,
		"margin": strike.approach_stop_margin,
		"soft_distance": strike.soft_target_distance,
		"mana_cost": strike.mana_cost,
		"marker": strike.release_marker_normalized,
		"weapon_damage": _player.physical_damage,
		"max_life": _player.max_life,
		"acceleration": _player.acceleration,
		"braking": _player.braking,
		"arrival": _player.arrival_tolerance,
	}


func _is_baseline(live: Dictionary) -> bool:
	return float(live["max_speed"]) == ACCEPTED_MAX_SPEED and float(live["increased"]) == 0.0 \
		and float(live["effective"]) == ACCEPTED_ACTION_TIME and _geometry(live, ACCEPTED_REACH, ACCEPTED_ARC, ACCEPTED_CONE)


func _geometry(live: Dictionary, reach: float, arc: float, cone: float) -> bool:
	return float(live["reach"]) == reach and float(live["arc"]) == arc and float(live["cone"]) == cone \
		and int(live["targets"]) == 1 and float(live["margin"]) == ACCEPTED_MARGIN


func _is_canonical(record: QuickStrikeData) -> bool:
	return record != null and record.action_time == ACCEPTED_ACTION_TIME and record.reach == ACCEPTED_REACH \
		and record.release_arc_degrees == ACCEPTED_ARC and record.soft_target_cone_degrees == ACCEPTED_CONE \
		and record.maximum_targets == 1 and record.release_marker_normalized == ACCEPTED_MARKER


func _geometry_line(live: Dictionary) -> String:
	return "reach %.2f m, arc %.0f°, cone %.0f°, %d target(s)" % [
		float(live["reach"]), float(live["arc"]), float(live["cone"]), int(live["targets"])]


func _live_line(live: Dictionary) -> String:
	return "movement %.1f m/s, Skill Speed +%.0f%% (action time %.4f s), %s" % [
		float(live["max_speed"]), 100.0 * float(live["increased"]), float(live["effective"]), _geometry_line(live)]


func _record_line(record: QuickStrikeData) -> String:
	return "%.2f s, reach %.2f m, arc %.0f°, cone %.0f°, %d target(s), marker %.3f" % [
		record.action_time, record.reach, record.release_arc_degrees, record.soft_target_cone_degrees,
		record.maximum_targets, record.release_marker_normalized]


func _ranks(skill_id: StringName, support_id: StringName) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for rank: int in SkillSupportCatalogue.reviewed_support_ranks(skill_id, support_id):
		parts.append(str(rank))
	return ", ".join(parts)


# --- The real kernel ------------------------------------------------------------------------------------------------

## The kernel's own release query, asked with `record` for the player where they stand.
func _release_query(record: QuickStrikeData) -> Dictionary:
	return _acquisition.resolve_release(_player.global_position, _player.facing_direction(), null, _candidates(), record)


## The kernel's own controller soft-target search, asked with `record` along the facing.
func _soft_query(record: QuickStrikeData) -> Dictionary:
	return _acquisition.soft_target(_player.global_position, _player.facing_direction(), _candidates(), record)


func _considered_for(outcome: Dictionary, enemy: PrototypeGraveblade) -> Dictionary:
	for record: Dictionary in outcome.get("considered", []):
		if record.get("fixture") == _area(enemy):
			return record
	return {}


func _rejected(outcome: Dictionary, enemy: PrototypeGraveblade) -> String:
	return String(_considered_for(outcome, enemy).get("rejected", "(not considered)"))


func _legal_in(outcome: Dictionary) -> int:
	var legal: int = 0
	for record: Dictionary in outcome.get("considered", []):
		if String(record.get("rejected", "")).is_empty():
			legal += 1
	return legal


func _area(enemy: PrototypeGraveblade) -> PrototypeTargetable:
	return enemy.get_node_or_null("TargetArea") as PrototypeTargetable


func _hits_on(enemy: PrototypeGraveblade) -> int:
	return int(_hits.get(enemy.get_instance_id(), 0))


## One real Quick Strike: the kernel's own `press()`, as the accepted room calls it,
## followed through the physics step until the action is READY again. Records the
## phase the press began in, the target and acquisition it was taken with, the planar
## gap to the target when the wind-up began, how far the player had moved by then, the
## one release outcome, and how many queries, releases and damage events it made.
func _press() -> Dictionary:
	await _until_ready()
	var attack: QuickStrikeAction = _player.attack
	_expect_quiet(_player.has_mana_for(attack.data.mana_cost), "the player could not afford a press")
	var start: Vector3 = _player.global_position
	var marks: Dictionary = {"windup_distance": -1.0, "windup_at": start, "outcome": {}, "released": false}
	var on_release: Callable = func(_id: int, outcome: Dictionary) -> void:
		if not bool(marks["released"]):
			marks["released"] = true
			marks["outcome"] = outcome
	var on_phase: Callable = func(next: int) -> void:
		if next == QuickStrikeAction.Phase.WINDUP and float(marks["windup_distance"]) < 0.0:
			marks["windup_at"] = _player.global_position
			marks["windup_distance"] = 0.0 if attack.target == null \
				else _planar_gap(_player.global_position, attack.target.global_position)
	attack.use_released.connect(on_release)
	attack.phase_changed.connect(on_phase)
	var queries: int = attack.release_queries
	var releases: int = attack.uses_released
	var damage: int = attack.damage_events
	_player.suspend_held_movement_for_attack()
	attack.press()
	var began: int = attack.phase
	var target: PrototypeTargetable = attack.target
	var acquisition: String = attack.last_acquisition
	attack.release_input()
	_presses += 1
	for frame: int in 300:
		if began == QuickStrikeAction.Phase.READY:
			break
		await physics_frame
		if bool(marks["released"]) and attack.phase == QuickStrikeAction.Phase.READY:
			break
	attack.use_released.disconnect(on_release)
	attack.phase_changed.disconnect(on_phase)
	marks["began"] = began
	marks["target"] = target
	marks["acquisition"] = acquisition
	marks["moved"] = _planar_gap(start, marks["windup_at"] as Vector3)
	marks["queries"] = attack.release_queries - queries
	marks["releases"] = attack.uses_released - releases
	marks["damage"] = attack.damage_events - damage
	return marks


func _outcome(marks_or_query: Dictionary) -> String:
	if marks_or_query.has("outcome") and marks_or_query["outcome"] is Dictionary:
		return String((marks_or_query["outcome"] as Dictionary).get("outcome", "none"))
	return String(marks_or_query.get("outcome", "none"))


func _struck(marks: Dictionary) -> Variant:
	return (marks["outcome"] as Dictionary).get("target")


func _phase(marks: Dictionary) -> String:
	return String(QuickStrikeAction.Phase.find_key(int(marks["began"]))).to_lower()


## The wind-up began on the first tick at or inside `stop`: never outside it, and never
## more than one tick of full-speed travel inside it.
func _stopped_at(marks: Dictionary, stop: float) -> bool:
	var tick: float = ACCEPTED_MAX_SPEED / float(Engine.physics_ticks_per_second) + 0.001
	var gap: float = float(marks["windup_distance"])
	return gap <= stop and gap > stop - tick


func _until_ready() -> void:
	for frame: int in 300:
		if _player.attack.phase == QuickStrikeAction.Phase.READY:
			break
		await physics_frame
	await process_frame


func _settle(frames: int) -> void:
	for frame: int in frames:
		await physics_frame


func _planar_gap(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()


# --- 1. The fixture ---------------------------------------------------------------------------------------------------

func _check_the_fixture_is_the_production_kernel_at_every_baseline() -> void:
	print("")
	print("--- 1. The fixture is the production player and Graveblade on a real navigation mesh, at every canonical baseline")
	var attack: QuickStrikeAction = _player.attack
	var map: RID = _stage.get_world_3d().navigation_map
	var path: PackedVector3Array = NavigationServer3D.map_get_path(map, Vector3.ZERO, FACING * APPROACH_FROM, true)
	var restored: RiftBuildApplicationResult = _apply(RiftRunBuild.new())
	_expect(_player.is_inside_tree() and _player.scene_file_path == PLAYER_SCENE and attack != null
			and attack.data_is_private() and attack.canonical_data == load(CANONICAL_QUICK_STRIKE)
			and _is_canonical(attack.canonical_data) and _is_canonical(attack.data) and attack.data.problem().is_empty(),
		"the fixture's player is not the production player holding a private copy of the canonical record")
	_expect(path.size() >= 2 and _planar_gap(path[path.size() - 1], FACING * APPROACH_FROM) < 0.05,
		"the fixture's navigation mesh answered a %d-point path" % path.size())
	_expect(restored.ok and restored.committed and _is_baseline(_live())
			and BrokenWatchSlice.ACCEPTED_MAX_SPEED == ACCEPTED_MAX_SPEED and _player.physical_damage == ACCEPTED_DAMAGE,
		"the fixture does not start at every baseline: %s" % _live_line(_live()))
	print("  %s holds a private copy of %s (private: %s); a %d-point navigation path crosses the fixture's floor; %s"
		% [_player.scene_file_path.get_file(), attack.canonical_data.resource_path.get_file(), str(attack.data_is_private()),
			path.size(), _live_line(_live())])
	_done("the_fixture_is_the_production_kernel_at_every_baseline")


# --- 2. Rank one ------------------------------------------------------------------------------------------------------

func _check_the_rank_one_records_are_unchanged() -> void:
	print("")
	print("--- 2. The rank-one records are I3's, byte for byte in value, and apply exactly as I3 applied them")
	var reach_record: Dictionary = SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, REACHING, 1)
	var sweep_record: Dictionary = SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, SWEEPING, 1)
	_expect(SkillSupportCatalogue.REACHING_EDGE_RANK_ONE_REACH == REACH_RANK_ONE
			and SkillSupportCatalogue.SWEEPING_EDGE_RANK_ONE_RELEASE_ARC_DEGREES == ARC_RANK_ONE
			and SkillSupportCatalogue.SWEEPING_EDGE_RANK_ONE_SOFT_TARGET_CONE_DEGREES == CONE_RANK_ONE
			and reach_record == {&"reach": REACH_RANK_ONE}
			and sweep_record == {&"release_arc_degrees": ARC_RANK_ONE, &"soft_target_cone_degrees": CONE_RANK_ONE},
		"the catalogue's rank-one records moved")
	var reach_one: RiftBuildApplicationResult = _apply(_build(1, 0))
	var reach_live: Dictionary = _live()
	var sweep_one: RiftBuildApplicationResult = _apply(_build(0, 1))
	var sweep_live: Dictionary = _live()
	_expect(reach_one.ok and reach_one.committed
			and reach_one.supports_applied == PackedStringArray(["quick_strike -> reaching_edge rank 1"])
			and _geometry(reach_live, REACH_RANK_ONE, ACCEPTED_ARC, ACCEPTED_CONE)
			and sweep_one.ok and sweep_one.committed
			and sweep_one.supports_applied == PackedStringArray(["quick_strike -> sweeping_edge rank 1"])
			and _geometry(sweep_live, ACCEPTED_REACH, ARC_RANK_ONE, CONE_RANK_ONE),
		"rank one applied %s and %s" % [reach_one.describe(), sweep_one.describe()])
	_apply(RiftRunBuild.new())
	print("  the catalogue's rank-one records: %s and %s" % [str(reach_record), str(sweep_record)])
	print("  applied: [%s] %s; [%s] %s" % [", ".join(reach_one.supports_applied), _geometry_line(reach_live),
		", ".join(sweep_one.supports_applied), _geometry_line(sweep_live)])
	_done("the_rank_one_records_are_unchanged")


# --- 3. Rank two ------------------------------------------------------------------------------------------------------

func _check_exact_rank_two_records_exist_for_both_supports() -> void:
	print("")
	print("--- 3. Exact rank-two records exist for both supports, and the seam applies each exactly")
	var reach_two: Dictionary = SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, REACHING, 2)
	var sweep_two: Dictionary = SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, SWEEPING, 2)
	var records_line: String = "%s and %s" % [str(reach_two), str(sweep_two)]
	_expect(SkillSupportCatalogue.RANK_ONE == 1 and SkillSupportCatalogue.RANK_TWO == 2
			and SkillSupportCatalogue.REACHING_EDGE_RANK_TWO_REACH == REACH_RANK_TWO
			and SkillSupportCatalogue.SWEEPING_EDGE_RANK_TWO_RELEASE_ARC_DEGREES == ARC_RANK_TWO
			and SkillSupportCatalogue.SWEEPING_EDGE_RANK_TWO_SOFT_TARGET_CONE_DEGREES == CONE_RANK_TWO
			and reach_two == {&"reach": REACH_RANK_TWO}
			and sweep_two == {&"release_arc_degrees": ARC_RANK_TWO, &"soft_target_cone_degrees": CONE_RANK_TWO}
			and _ranks(QUICK_STRIKE, REACHING) == "1, 2" and _ranks(QUICK_STRIKE, SWEEPING) == "1, 2",
		"the rank-two records are %s; the reviewed ranks are [%s] and [%s]"
			% [records_line, _ranks(QUICK_STRIKE, REACHING), _ranks(QUICK_STRIKE, SWEEPING)])
	## Every answer is a fresh copy: changing one cannot reach the table.
	reach_two[&"reach"] = 99.0
	sweep_two.clear()
	var reach_again: Dictionary = SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, REACHING, 2)
	var sweep_again: Dictionary = SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, SWEEPING, 2)
	_expect(reach_again == {&"reach": REACH_RANK_TWO}
			and sweep_again == {&"release_arc_degrees": ARC_RANK_TWO, &"soft_target_cone_degrees": CONE_RANK_TWO},
		"changing an answer reached the catalogue's table")
	var reach_result: RiftBuildApplicationResult = _apply(_build(2, 0))
	var reach_live: Dictionary = _live()
	var sweep_result: RiftBuildApplicationResult = _apply(_build(0, 2))
	var sweep_live: Dictionary = _live()
	var record: QuickStrikeData = _player.attack.data
	var half_arc: float = rad_to_deg(record.release_arc_half_radians())
	var half_cone: float = record.soft_target_cone_half_degrees()
	_expect(reach_result.ok and reach_result.committed and reach_result.problem().is_empty()
			and reach_result.supports_applied == PackedStringArray(["quick_strike -> reaching_edge rank 2"])
			and _geometry(reach_live, REACH_RANK_TWO, ACCEPTED_ARC, ACCEPTED_CONE)
			and sweep_result.ok and sweep_result.committed and sweep_result.problem().is_empty()
			and sweep_result.supports_applied == PackedStringArray(["quick_strike -> sweeping_edge rank 2"])
			and _geometry(sweep_live, ACCEPTED_REACH, ARC_RANK_TWO, CONE_RANK_TWO)
			and record.problem().is_empty() and half_cone == 77.5
			and record.soft_target_cone_total_degrees() == CONE_RANK_TWO and is_equal_approx(half_arc, 130.0),
		"rank two applied %s and %s" % [reach_result.describe(), sweep_result.describe()])
	_apply(RiftRunBuild.new())
	print("  the catalogue's rank-two records: %s; its reviewed ranks: [%s] and [%s]; after a caller changed its copies it still answers %s and %s"
		% [records_line, _ranks(QUICK_STRIKE, REACHING), _ranks(QUICK_STRIKE, SWEEPING), str(reach_again), str(sweep_again)])
	print("  applied: [%s] %s; [%s] %s — the record's own half-angles +/-%.1f° arc and +/-%.1f° cone, inside its 89° guard"
		% [", ".join(reach_result.supports_applied), _geometry_line(reach_live), ", ".join(sweep_result.supports_applied),
			_geometry_line(sweep_live), half_arc, half_cone])
	_done("exact_rank_two_records_exist_for_both_supports")


# --- 4. The catalogue owns the values ----------------------------------------------------------------------------------

func _check_the_catalogue_owns_every_concrete_value() -> void:
	print("")
	print("--- 4. The catalogue owns every concrete value: six literal constants, named by no other running file")
	var source: String = FileAccess.get_file_as_string(CATALOGUE_FILE)
	var declared: RegEx = RegEx.create_from_string("(?m)^const ([A-Z_]+_EDGE_RANK_[A-Z_]+): float = ([0-9]+\\.[0-9]+)$")
	var found: Dictionary = {}
	for match: RegExMatch in declared.search_all(source):
		found[match.get_string(1)] = match.get_string(2).to_float()
	var constants: Dictionary = (load(CATALOGUE_FILE) as GDScript).get_script_constant_map()
	var named: PackedStringArray = PackedStringArray()
	var wrong: PackedStringArray = PackedStringArray()
	for key: Variant in constants:
		if String(key).contains("_EDGE_RANK_"):
			named.append(String(key))
			if not VALUE_CONSTANTS.has(String(key)) or float(constants[key]) != float(VALUE_CONSTANTS[String(key)]):
				wrong.append(String(key))
	_expect(found == VALUE_CONSTANTS and named.size() == VALUE_CONSTANTS.size() and wrong.is_empty(),
		"the catalogue declares %s as literals and holds %s (%s wrong)" % [str(found), ", ".join(named), ", ".join(wrong)])
	## Nothing else in the running project states a rank value or asks for one but the seam.
	var namers: PackedStringArray = PackedStringArray()
	var readers: PackedStringArray = PackedStringArray()
	var scanned: int = 0
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd", ".tscn", ".tres"]):
			scanned += 1
			var text: String = FileAccess.get_file_as_string(path)
			if path != CATALOGUE_FILE and (text.contains("_EDGE_RANK_") or text.contains("SkillSupportCatalogue.RANK_")):
				namers.append(path.get_file())
			if text.contains("support_rank_values(") or text.contains("reviewed_support_ranks("):
				readers.append(path.get_file())
	readers.sort()
	var project: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	var seam: String = _code_only(FileAccess.get_file_as_string(SEAM_FILE))
	var asks_record: int = seam.count("SkillSupportCatalogue.support_rank_values(")
	var asks_ranks: int = seam.count("SkillSupportCatalogue.reviewed_support_ranks(")
	_expect(scanned > 100 and namers.is_empty() and not project.contains("_EDGE_RANK_")
			and readers == PackedStringArray(["rift_build_application.gd", "skill_support_catalogue.gd"])
			and asks_record == 1 and asks_ranks == 1 and seam.count("support_rank_for(") == 1,
		"rank values are named by %s and asked for by %s" % [", ".join(namers), ", ".join(readers)])
	print("  the catalogue declares %d value constants, each a literal; of %d running files %d other name(s) one"
		% [found.size(), scanned, namers.size()])
	print("  the rank table is read by [%s]; the seam asks it %d time(s) for a rank's record and %d for the ranks it holds"
		% [", ".join(readers), asks_record, asks_ranks])
	_done("the_catalogue_owns_every_concrete_value")


# --- 5. No application file retypes a value -------------------------------------------------------------------------

func _check_no_application_file_retypes_a_support_id_or_effect_number() -> void:
	print("")
	print("--- 5. No application file retypes a support id, a support name, a rank constant or an effect number")
	var retyped: PackedStringArray = PackedStringArray()
	var literals: Dictionary = {}
	for path: String in [SEAM_FILE, RESULT_FILE]:
		var source: String = FileAccess.get_file_as_string(path)
		var code: String = _uncommented(source)
		for token: String in RETYPED_TOKENS:
			if code.contains(token):
				retyped.append("%s: %s" % [path.get_file(), token])
		literals[path] = _numeric_literals(_code_only(source))
	var seam_literals: PackedStringArray = literals[SEAM_FILE]
	var result_literals: PackedStringArray = literals[RESULT_FILE]
	_expect(retyped.is_empty(), "retyped: %s" % ", ".join(retyped))
	## Roguelite I14 (D-320) moved the result's allowance one for one: its Maximum Life receipt line
	## turns a fraction into a percentage (100) and gives a number at most six decimal places (6).
	## Neither is an effect number, and the seam's allowance did not move.
	_expect(_values_within(seam_literals, [0.0]) and _values_within(result_literals, [0.0, 1.0, 6.0, 100.0])
			and not seam_literals.is_empty() and not result_literals.is_empty(),
		"the seam's code holds [%s] and the result's [%s]" % [", ".join(seam_literals), ", ".join(result_literals)])
	print("  the seam's code holds the numeric literal(s) [%s] and the result's [%s]; %d of %d retyping tokens found in either"
		% [", ".join(seam_literals), ", ".join(result_literals), retyped.size(), RETYPED_TOKENS.size()])
	_done("no_application_file_retypes_a_support_id_or_effect_number")


# --- 6. No arithmetic ------------------------------------------------------------------------------------------------

func _check_no_arithmetic_derives_rank_two_from_rank_one() -> void:
	print("")
	print("--- 6. No generic arithmetic derives rank two from rank one: literals, operator-free lookups, and no answer past the table")
	var catalogue: String = _code_only(FileAccess.get_file_as_string(CATALOGUE_FILE))
	var bodies: String = ""
	for name: String in ["support_rank_values", "reviewed_support_ranks", "_rank_records"]:
		bodies += _function_body(catalogue, name)
	var seam: String = _code_only(FileAccess.get_file_as_string(SEAM_FILE))
	var phrase: String = _function_body(seam, "_reviewed_ranks_phrase")
	var rank_arithmetic: RegEx = RegEx.create_from_string("\\brank\\s*[-+*/%]|[-+*/%]\\s*rank\\b")
	var tokens: PackedStringArray = PackedStringArray()
	for token: String in RANK_ARITHMETIC_TOKENS:
		if seam.contains(token) or catalogue.contains(token):
			tokens.append(token)
	var matches: int = rank_arithmetic.search_all(seam).size() + rank_arithmetic.search_all(catalogue).size()
	_expect(bodies.length() > 300 and _operators_in(bodies) == 0 and phrase.length() > 100 and _operators_in(phrase) == 0
			and matches == 0 and tokens.is_empty(),
		"an operator in the catalogue's lookups (%d) or the seam's phrase (%d), or rank arithmetic %s"
			% [_operators_in(bodies), _operators_in(phrase), ", ".join(tokens)])
	## A rule would answer past the table; the table does not.
	var answered: PackedStringArray = PackedStringArray()
	var asked: int = 0
	for rank: int in [-1, 0, 3, 4, 5, 10, 100, AcquiredSupports.MAXIMUM_RECORDABLE_RANK]:
		for support_id: StringName in [REACHING, SWEEPING]:
			asked += 1
			if not SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, support_id, rank).is_empty():
				answered.append("%s at %d" % [support_id, rank])
	## And the three rank-two moves are not one multiplier.
	var one_reach: float = float(SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, REACHING, 1)[&"reach"])
	var two_reach: float = float(SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, REACHING, 2)[&"reach"])
	var one_sweep: Dictionary = SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, SWEEPING, 1)
	var two_sweep: Dictionary = SkillSupportCatalogue.support_rank_values(QUICK_STRIKE, SWEEPING, 2)
	var ratios: Array[float] = [
		two_reach / one_reach,
		float(two_sweep[&"release_arc_degrees"]) / float(one_sweep[&"release_arc_degrees"]),
		float(two_sweep[&"soft_target_cone_degrees"]) / float(one_sweep[&"soft_target_cone_degrees"]),
	]
	_expect(answered.is_empty() and not is_equal_approx(ratios[0], ratios[1])
			and not is_equal_approx(ratios[0], ratios[2]) and not is_equal_approx(ratios[1], ratios[2]),
		"the catalogue answered %s; the ratios are %s" % [", ".join(answered), str(ratios)])
	print("  %d operator(s) in the catalogue's three lookups and %d in the seam's rank phrase; %d rank-arithmetic match(es) in either; %d of %d questions past the table answered (ranks -1, 0, 3, 4, 5, 10, 100 and the largest recordable)"
		% [_operators_in(bodies), _operators_in(phrase), matches + tokens.size(), answered.size(), asked])
	print("  the rank-two moves are +%.2f m (x%.3f), +%.0f° (x%.3f) and +%.0f° (x%.3f): no one increment and no one multiplier makes them"
		% [two_reach - one_reach, ratios[0], float(two_sweep[&"release_arc_degrees"]) - float(one_sweep[&"release_arc_degrees"]),
			ratios[1], float(two_sweep[&"soft_target_cone_degrees"]) - float(one_sweep[&"soft_target_cone_degrees"]), ratios[2]])
	_done("no_arithmetic_derives_rank_two_from_rank_one")


# --- 7. Reaching Edge through the real kernel -----------------------------------------------------------------------

func _check_reaching_edge_moves_the_real_reach_boundary_both_ways() -> void:
	print("")
	print("--- 7. Reaching Edge: the real release query and the real approach move from rank one's 2.65 m to rank two's 3.65 m, and back")
	await _clear_enemies()
	_stand_facing(Vector3.ZERO, FACING)
	var enemy: PrototypeGraveblade = await _spawn(FACING * BETWEEN_REACHES)
	_apply(_build(1, 0))
	var query_one: Dictionary = _release_query(_player.attack.data)
	_apply(_build(2, 0))
	var query_two: Dictionary = _release_query(_player.attack.data)
	_apply(_build(1, 0))
	var query_back: Dictionary = _release_query(_player.attack.data)
	## Read now: this Graveblade is freed before the check prints.
	var reach_refusal: String = _rejected(query_one, enemy)
	_expect(enemy.scene_file_path == GRAVEBLADE_SCENE
			and _outcome(query_one) == "miss" and reach_refusal == "3.20 m is beyond the 2.65 m reach"
			and _outcome(query_two) == "hit" and query_two.get("target") == _area(enemy)
			and _outcome(query_back) == "miss" and _rejected(query_back, enemy) == "3.20 m is beyond the 2.65 m reach",
		"at 3.20 m the release query answered %s, %s, %s (%s)" % [_outcome(query_one), _outcome(query_two),
			_outcome(query_back), reach_refusal])

	## The real press from where the player stands: rank two swings at once, rank one must walk.
	_apply(_build(2, 0))
	_stand_facing(Vector3.ZERO, FACING)
	var swing_two: Dictionary = await _press()
	var after_two: float = enemy.life
	_apply(_build(1, 0))
	_stand_facing(Vector3.ZERO, FACING)
	var swing_one: Dictionary = await _press()
	var after_one: float = enemy.life
	_expect(int(swing_two["began"]) == QuickStrikeAction.Phase.WINDUP and swing_two["target"] == _area(enemy)
			and float(swing_two["moved"]) < 0.001 and _outcome(swing_two) == "hit" and int(swing_two["damage"]) == 1
			and after_two == GRAVEBLADE_LIFE - ACCEPTED_DAMAGE
			and int(swing_one["began"]) == QuickStrikeAction.Phase.APPROACH and swing_one["target"] == _area(enemy)
			and _stopped_at(swing_one, REACH_RANK_ONE - ACCEPTED_MARGIN) and _outcome(swing_one) == "hit"
			and int(swing_one["damage"]) == 1 and after_one == GRAVEBLADE_LIFE - 2.0 * ACCEPTED_DAMAGE,
		"from 3.20 m rank two began %s and moved %.3f m; rank one began %s and wound up %.3f m away"
			% [_phase(swing_two), float(swing_two["moved"]), _phase(swing_one), float(swing_one["windup_distance"])])

	## The live approach distance, from 4.50 m: the reach less the accepted 0.10 m margin.
	await _clear_enemies()
	var target: PrototypeGraveblade = await _spawn(FACING * APPROACH_FROM)
	var stops: Array[Dictionary] = []
	for build: RiftRunBuild in [RiftRunBuild.new(), _build(1, 0), _build(2, 0)]:
		_apply(build)
		_stand_facing(Vector3.ZERO, FACING)
		stops.append(await _press())
	var bands: Array[float] = [ACCEPTED_REACH - ACCEPTED_MARGIN, REACH_RANK_ONE - ACCEPTED_MARGIN, REACH_RANK_TWO - ACCEPTED_MARGIN]
	var right: bool = true
	for index: int in stops.size():
		right = right and int(stops[index]["began"]) == QuickStrikeAction.Phase.APPROACH and stops[index]["target"] == _area(target) \
			and _stopped_at(stops[index], bands[index]) and _outcome(stops[index]) == "hit" and int(stops[index]["damage"]) == 1
	_expect(right, "from 4.50 m the approaches wound up %.3f, %.3f and %.3f m away"
		% [float(stops[0]["windup_distance"]), float(stops[1]["windup_distance"]), float(stops[2]["windup_distance"])])
	_apply(RiftRunBuild.new())
	print("  3.20 m ahead: rank one's query %s — '%s'; rank two's %s; rank one's again %s"
		% [_outcome(query_one), reach_refusal, _outcome(query_two), _outcome(query_back)])
	print("  from where the player stands, rank two's real press began in %s, moved %.3f m and %s, %.0f -> %.0f; rank one's began in %s, wound up %.3f m away and %s, %.0f -> %.0f"
		% [_phase(swing_two), float(swing_two["moved"]), _outcome(swing_two), GRAVEBLADE_LIFE, after_two,
			_phase(swing_one), float(swing_one["windup_distance"]), _outcome(swing_one), after_two, after_one])
	print("  a real approach to a Graveblade 4.50 m ahead wound up %.3f m from it at baseline, %.3f m at rank one and %.3f m at rank two (each the reach less the 0.10 m margin); the three releases: %s, %s, %s"
		% [float(stops[0]["windup_distance"]), float(stops[1]["windup_distance"]), float(stops[2]["windup_distance"]),
			_outcome(stops[0]), _outcome(stops[1]), _outcome(stops[2])])
	_done("reaching_edge_moves_the_real_reach_boundary_both_ways")


# --- 8. Sweeping Edge's release ---------------------------------------------------------------------------------------

func _check_sweeping_edge_moves_the_real_release_boundary_both_ways() -> void:
	print("")
	print("--- 8. Sweeping Edge: the real release query moves from rank one's +/-90° to rank two's +/-130°, and back; the real swing hits once")
	await _clear_enemies()
	_stand_facing(Vector3.ZERO, FACING)
	var enemy: PrototypeGraveblade = await _spawn(_at(WIDE_ANGLE, NEAR_TARGET))
	_apply(_build(0, 1))
	var query_one: Dictionary = _release_query(_player.attack.data)
	_apply(_build(0, 2))
	var query_two: Dictionary = _release_query(_player.attack.data)
	_apply(_build(0, 1))
	var query_back: Dictionary = _release_query(_player.attack.data)
	_expect(_outcome(query_one) == "miss" and _rejected(query_one, enemy) == "110 deg is outside the 180 deg release arc"
			and _outcome(query_two) == "hit" and query_two.get("target") == _area(enemy)
			and _outcome(query_back) == "miss" and _rejected(query_back, enemy) == "110 deg is outside the 180 deg release arc",
		"at 110° the release query answered %s, %s, %s (%s)" % [_outcome(query_one), _outcome(query_two),
			_outcome(query_back), _rejected(query_one, enemy)])
	## The real swing: 110° is outside both cones, so each press swings along the facing.
	_stand_facing(Vector3.ZERO, FACING)
	var swing_one: Dictionary = await _press()
	var life_after_one: float = enemy.life
	var hits_after_one: int = _hits_on(enemy)
	_apply(_build(0, 2))
	_stand_facing(Vector3.ZERO, FACING)
	var swing_two: Dictionary = await _press()
	_expect(int(swing_one["began"]) == QuickStrikeAction.Phase.WINDUP and swing_one["target"] == null
			and String(swing_one["acquisition"]).begins_with("no eligible target in the 110 deg cone")
			and _outcome(swing_one) == "miss" and int(swing_one["damage"]) == 0 and life_after_one == GRAVEBLADE_LIFE
			and int(swing_two["began"]) == QuickStrikeAction.Phase.WINDUP and swing_two["target"] == null
			and String(swing_two["acquisition"]).begins_with("no eligible target in the 155 deg cone")
			and _outcome(swing_two) == "hit" and _struck(swing_two) == _area(enemy)
			and int(swing_two["queries"]) == 1 and int(swing_two["releases"]) == 1 and int(swing_two["damage"]) == 1
			and _hits_on(enemy) == 1 and enemy.life == GRAVEBLADE_LIFE - ACCEPTED_DAMAGE,
		"at 110° rank one's swing %s (%d damage) and rank two's %s (%d damage, %d hit(s) on it, Life %.0f)"
			% [_outcome(swing_one), int(swing_one["damage"]), _outcome(swing_two), int(swing_two["damage"]),
				_hits_on(enemy), enemy.life])
	_apply(RiftRunBuild.new())
	print("  110° at 1.20 m: rank one's query %s — '%s'; rank two's %s; rank one's again %s"
		% [_outcome(query_one), _rejected(query_one, enemy), _outcome(query_two), _outcome(query_back)])
	print("  the real swing along the facing: rank one %s with %d damage event(s), %d hit(s), Life %.0f; rank two made %d query, %d release and %d damage event(s), %d hit(s) on it, %.0f -> %.0f"
		% [_outcome(swing_one), int(swing_one["damage"]), hits_after_one, life_after_one, int(swing_two["queries"]),
			int(swing_two["releases"]), int(swing_two["damage"]), _hits_on(enemy), GRAVEBLADE_LIFE, enemy.life])
	_done("sweeping_edge_moves_the_real_release_boundary_both_ways")


# --- 9. Sweeping Edge's soft target -----------------------------------------------------------------------------------

func _check_sweeping_edge_moves_the_real_soft_target_boundary_both_ways() -> void:
	print("")
	print("--- 9. Sweeping Edge: the real controller soft-target search moves from rank one's +/-55° to rank two's +/-77.5°, and back")
	await _clear_enemies()
	_stand_facing(Vector3.ZERO, FACING)
	var enemy: PrototypeGraveblade = await _spawn(_at(CONE_ANGLE, CONE_DISTANCE))
	_apply(RiftRunBuild.new())
	var soft_base: Dictionary = _soft_query(_player.attack.data)
	_apply(_build(0, 1))
	var soft_one: Dictionary = _soft_query(_player.attack.data)
	_apply(_build(0, 2))
	var soft_two: Dictionary = _soft_query(_player.attack.data)
	_apply(_build(0, 1))
	var soft_back: Dictionary = _soft_query(_player.attack.data)
	_expect(soft_base.get("target") == null and _rejected(soft_base, enemy) == "70.0 deg outside the 32.5 deg half-cone (65 deg total)"
			and soft_one.get("target") == null and _rejected(soft_one, enemy) == "70.0 deg outside the 55.0 deg half-cone (110 deg total)"
			and String(soft_one.get("reason", "")) == "no eligible target in the 110 deg cone"
			and soft_two.get("target") == _area(enemy) and String(soft_two.get("reason", "")) == "approach: 70 deg off intent, 3.00 m away"
			and soft_back.get("target") == null and _rejected(soft_back, enemy) == "70.0 deg outside the 55.0 deg half-cone (110 deg total)",
		"at 70° the soft-target search answered '%s', '%s', '%s', '%s'" % [soft_base.get("reason"), soft_one.get("reason"),
			soft_two.get("reason"), soft_back.get("reason")])
	## The real press through the controller aim path.
	_stand_facing(Vector3.ZERO, FACING)
	var press_one: Dictionary = await _press()
	_apply(_build(0, 2))
	_stand_facing(Vector3.ZERO, FACING)
	var press_two: Dictionary = await _press()
	_expect(int(press_one["began"]) == QuickStrikeAction.Phase.WINDUP and press_one["target"] == null
			and String(press_one["acquisition"]) == "no eligible target in the 110 deg cone"
			and int(press_two["began"]) == QuickStrikeAction.Phase.APPROACH and press_two["target"] == _area(enemy)
			and String(press_two["acquisition"]) == "approach: 70 deg off intent, 3.00 m away"
			and _outcome(press_two) == "hit" and int(press_two["damage"]) == 1,
		"the real presses began %s ('%s') and %s ('%s')" % [_phase(press_one), press_one["acquisition"],
			_phase(press_two), press_two["acquisition"]])
	_apply(RiftRunBuild.new())
	print("  70° at 3.00 m: baseline — '%s'; rank one — '%s'; rank two chose it — '%s'; rank one again — '%s'"
		% [_rejected(soft_base, enemy), _rejected(soft_one, enemy), soft_two.get("reason"), _rejected(soft_back, enemy)])
	print("  the real press: rank one began in %s — '%s'; rank two began in %s — '%s' — and its release %s with %d damage event(s)"
		% [_phase(press_one), press_one["acquisition"], _phase(press_two), press_two["acquisition"], _outcome(press_two),
			int(press_two["damage"])])
	_done("sweeping_edge_moves_the_real_soft_target_boundary_both_ways")


# --- 10. One target, no Area, no damage change -------------------------------------------------------------------------

func _check_both_ranks_stay_single_target_non_area_and_damage_neutral() -> void:
	print("")
	print("--- 10. At both ranks Quick Strike resolves one target, carries no Area, and deals exactly its weapon's damage")
	## Reaching Edge's two stand +/-10 deg off the facing: the kernel turns the player to
	## face the one it chose, and a second target at +/-30 deg then sits 60 deg off —
	## outside the 100 deg arc, so it was no longer a legal second target. The first
	## development run placed them there, and this check's own legal count said so.
	var cases: Array = [
		["Reaching Edge rank one", 1, 0, 10.0, 2.00, 2.30],
		["Reaching Edge rank two", 2, 0, 10.0, 3.00, 3.40],
		["Sweeping Edge rank one", 0, 1, 70.0, NEAR_TARGET, FAR_TARGET],
		["Sweeping Edge rank two", 0, 2, WIDE_ANGLE, NEAR_TARGET, FAR_TARGET],
		["both at rank two", 2, 2, WIDE_ANGLE, 3.00, 3.40],
	]
	var wrong: PackedStringArray = PackedStringArray()
	var lines: PackedStringArray = PackedStringArray()
	var most_targets: int = 0
	for case: Array in cases:
		await _clear_enemies()
		_stand_facing(Vector3.ZERO, FACING)
		var near: PrototypeGraveblade = await _spawn(_at(float(case[3]), float(case[4])))
		var far: PrototypeGraveblade = await _spawn(_at(-float(case[3]), float(case[5])))
		var result: RiftBuildApplicationResult = _apply(_build(int(case[1]), int(case[2])))
		most_targets = maxi(most_targets, maxi(result.maximum_targets, _player.attack.data.maximum_targets))
		_stand_facing(Vector3.ZERO, FACING)
		var swing: Dictionary = await _press()
		var legal: int = _legal_in(swing["outcome"] as Dictionary)
		if not (result.ok and result.maximum_targets == 1 and _player.attack.data.maximum_targets == 1
				and legal == 2 and int(swing["releases"]) == 1 and int(swing["damage"]) == 1
				and _struck(swing) == _area(near) and near.life == GRAVEBLADE_LIFE - ACCEPTED_DAMAGE
				and far.life == GRAVEBLADE_LIFE and _hits_on(far) == 0
				and _player.physical_damage == ACCEPTED_DAMAGE):
			wrong.append("%s: %d legal, %d damage event(s), near %.0f, far %.0f" % [case[0], legal, int(swing["damage"]),
				near.life, far.life])
		lines.append("%s: %d legal at +/-%.0f°, %d release(s), %d damage event(s); the nearer %.0f -> %.0f, the other %.0f with %d hit(s)"
			% [case[0], legal, float(case[3]), int(swing["releases"]), int(swing["damage"]), GRAVEBLADE_LIFE, near.life,
				far.life, _hits_on(far)])
	var profile: SkillTagProfile = SkillSupportCatalogue.quick_strike_profile()
	_expect(wrong.is_empty(), "two legal targets were not one hit: %s" % "; ".join(wrong))
	_expect(not profile.carries(SkillTags.AREA) and not profile.satisfies(SkillTags.AREA)
			and profile.carries(SkillTags.STRIKE) and _player.physical_damage == ACCEPTED_DAMAGE,
		"Quick Strike carries Area, or its damage moved: %s, %.0f" % [profile.tag_line(), _player.physical_damage])
	_apply(RiftRunBuild.new())
	await _clear_enemies()
	for line: String in lines:
		print("  %s" % line)
	print("  at most %d target(s) at any rank; Quick Strike's tags %s — carries Area: %s; weapon damage %.0f"
		% [most_targets, profile.tag_line(), str(profile.carries(SkillTags.AREA)), _player.physical_damage])
	_done("both_ranks_stay_single_target_non_area_and_damage_neutral")


# --- 11. Both supports together ----------------------------------------------------------------------------------------

func _check_both_supports_coexist_at_rank_two() -> void:
	print("")
	print("--- 11. Both spatial supports at rank two coexist: 3.65 m, 260°, 155°, one target — and each alone misses what both reach")
	var both: RiftBuildApplicationResult = _apply(_build(2, 2))
	var both_live: Dictionary = _live()
	var mixed_one: RiftBuildApplicationResult = _apply(_build(2, 1))
	var mixed_one_live: Dictionary = _live()
	var mixed_two: RiftBuildApplicationResult = _apply(_build(1, 2))
	var mixed_two_live: Dictionary = _live()
	_expect(both.ok and both.committed and both.problem().is_empty()
			and both.supports_applied == PackedStringArray(["quick_strike -> reaching_edge rank 2", "quick_strike -> sweeping_edge rank 2"])
			and _geometry(both_live, REACH_RANK_TWO, ARC_RANK_TWO, CONE_RANK_TWO)
			and mixed_one.ok and _geometry(mixed_one_live, REACH_RANK_TWO, ARC_RANK_ONE, CONE_RANK_ONE)
			and mixed_two.ok and _geometry(mixed_two_live, REACH_RANK_ONE, ARC_RANK_TWO, CONE_RANK_TWO),
		"both at rank two left %s; mixed %s and %s" % [_geometry_line(both_live), _geometry_line(mixed_one_live),
			_geometry_line(mixed_two_live)])
	await _clear_enemies()
	_stand_facing(Vector3.ZERO, FACING)
	var enemy: PrototypeGraveblade = await _spawn(_at(COMBINED_ANGLE, COMBINED_DISTANCE))
	_apply(_build(2, 2))
	var query_both: Dictionary = _release_query(_player.attack.data)
	_apply(_build(2, 0))
	var query_reach: Dictionary = _release_query(_player.attack.data)
	_apply(_build(0, 2))
	var query_sweep: Dictionary = _release_query(_player.attack.data)
	_apply(_build(2, 2))
	_stand_facing(Vector3.ZERO, FACING)
	var swing: Dictionary = await _press()
	_expect(_outcome(query_both) == "hit" and query_both.get("target") == _area(enemy)
			and _rejected(query_reach, enemy) == "120 deg is outside the 100 deg release arc"
			and _rejected(query_sweep, enemy) == "3.40 m is beyond the 1.65 m reach"
			and _outcome(swing) == "hit" and int(swing["damage"]) == 1 and _hits_on(enemy) == 1,
		"at 120° and 3.40 m: both %s; Reaching alone '%s'; Sweeping alone '%s'; the real swing %s"
			% [_outcome(query_both), _rejected(query_reach, enemy), _rejected(query_sweep, enemy), _outcome(swing)])
	_apply(RiftRunBuild.new())
	print("  both at rank two: %s, supports [%s]; Reaching 2 + Sweeping 1: %s; Reaching 1 + Sweeping 2: %s"
		% [_geometry_line(both_live), ", ".join(both.supports_applied), _geometry_line(mixed_one_live), _geometry_line(mixed_two_live)])
	print("  120° at 3.40 m: both together — %s, and the real swing %s with %d damage event(s); Reaching Edge alone — '%s'; Sweeping Edge alone — '%s'"
		% [_outcome(query_both), _outcome(swing), int(swing["damage"]), _rejected(query_reach, enemy), _rejected(query_sweep, enemy)])
	_done("both_supports_coexist_at_rank_two")


# --- 12. Idempotence and order ----------------------------------------------------------------------------------------

func _check_the_same_build_twice_or_in_another_order_changes_nothing() -> void:
	print("")
	print("--- 12. The same complete build applied twice, or acquired in another order, lands on the same values, and never compounds from the live ones")
	## The same whole build, acquired in two orders: Reaching first, and Sweeping first.
	var cards: Array[StringName] = [PassiveCardCatalogue.CELERITY_ID]
	var forward: RiftRunBuild = RiftRunBuild.new()
	_expect_quiet(forward.acquire_passive_card(PassiveCardCatalogue.record(cards[0])).is_empty(), "stage")
	_expect_quiet(forward.acquire_support(QUICK_STRIKE, REACHING).is_empty(), "stage")
	_expect_quiet(forward.acquire_support(QUICK_STRIKE, SWEEPING).is_empty(), "stage")
	_expect_quiet(forward.rank_support(QUICK_STRIKE, REACHING).is_empty(), "stage")
	_expect_quiet(forward.rank_support(QUICK_STRIKE, SWEEPING).is_empty(), "stage")
	var reverse: RiftRunBuild = RiftRunBuild.new()
	_expect_quiet(reverse.acquire_support(QUICK_STRIKE, SWEEPING).is_empty(), "stage")
	_expect_quiet(reverse.rank_support(QUICK_STRIKE, SWEEPING).is_empty(), "stage")
	_expect_quiet(reverse.acquire_support(QUICK_STRIKE, REACHING).is_empty(), "stage")
	_expect_quiet(reverse.rank_support(QUICK_STRIKE, REACHING).is_empty(), "stage")
	_expect_quiet(reverse.acquire_passive_card(PassiveCardCatalogue.record(cards[0])).is_empty(), "stage")

	var first: RiftBuildApplicationResult = _apply(forward)
	var after_first: Dictionary = _live()
	var signals: Dictionary = {"n": 0}
	var counter: Callable = func(_increased: float, _time: float) -> void:
		signals["n"] = int(signals["n"]) + 1
	_player.attack_speed_changed.connect(counter)
	var second: RiftBuildApplicationResult = _apply(forward)
	var after_second: Dictionary = _live()
	var reversed: RiftBuildApplicationResult = _apply(reverse)
	var after_reversed: Dictionary = _live()
	var again: RiftBuildApplicationResult = _apply(forward)
	var after_again: Dictionary = _live()
	_player.attack_speed_changed.disconnect(counter)
	var c1: PlayerStatTotals = PlayerStatTotals.new()
	_expect_quiet(c1.add(PlayerStats.SKILL_SPEED, ONE_CARD).is_empty(), "C1")
	var celerity: PlayerStatValue = c1.value_of(PlayerStats.SKILL_SPEED, ACCEPTED_ACTION_TIME)
	var identical: int = 0
	for other: Dictionary in [after_second, after_reversed, after_again]:
		if other == after_first:
			identical += 1
	_expect(first.ok and second.ok and reversed.ok and again.ok and identical == 3
			and first.describe() == second.describe() and first.describe() == reversed.describe()
			and first.supports_applied == reversed.supports_applied and int(signals["n"]) == 0
			and _geometry(after_first, REACH_RANK_TWO, ARC_RANK_TWO, CONE_RANK_TWO)
			and float(after_first["effective"]) == celerity.value,
		"the same build twice and in another order left %s, %s, %s, %s (%d speed-change signals)"
			% [_live_line(after_first), _live_line(after_second), _live_line(after_reversed), _live_line(after_again),
				int(signals["n"])])
	## STAGED: three numbers written straight into the live private record. The seam
	## derives from the canonical record, so a derivation ignores them and an
	## application overwrites them.
	var live_record: QuickStrikeData = _player.attack.data
	live_record.reach = 9.0
	live_record.release_arc_degrees = 17.0
	live_record.soft_target_cone_degrees = 30.0
	var polluted: String = _geometry_line(_live())
	var derived: RiftBuildApplicationResult = RiftBuildApplication.derive(forward, _player, ACCEPTED_MAX_SPEED)
	var still_polluted: String = _geometry_line(_live())
	var reapplied: RiftBuildApplicationResult = _apply(forward)
	_expect(derived.ok and not derived.committed and derived.reach == REACH_RANK_TWO
			and derived.release_arc_degrees == ARC_RANK_TWO and derived.soft_target_cone_degrees == CONE_RANK_TWO
			and still_polluted == polluted and reapplied.ok and _live() == after_first,
		"over a live record reading %s the seam derived %s and applied %s" % [polluted, derived.describe(), _live_line(_live())])
	var reapplied_line: String = _geometry_line(_live())
	_apply(RiftRunBuild.new())
	print("  Celerity + Reaching Edge 2 + Sweeping Edge 2, applied, applied again, acquired Sweeping-first and applied, then applied again: %s; %d of 3 re-applications identical to the first, %d speed-change signals, supports [%s]"
		% [_live_line(after_first), identical, int(signals["n"]), ", ".join(first.supports_applied)])
	print("  over a live record the harness set to %s, the seam derived %.2f m / %.0f° / %.0f° from the canonical record while the live record still read %s, and the application left %s"
		% [polluted, derived.reach, derived.release_arc_degrees, derived.soft_target_cone_degrees, still_polluted, reapplied_line])
	_done("the_same_build_twice_or_in_another_order_changes_nothing")


# --- 13. The empty build --------------------------------------------------------------------------------------------

func _check_an_empty_build_restores_the_canonical_baselines() -> void:
	print("")
	print("--- 13. An empty build restores 1.65 m / 100° / 65° and every other baseline, knowing nothing of what was applied")
	var full: RiftBuildApplicationResult = _apply(_build(2, 2, [PassiveCardCatalogue.CELERITY_ID, PassiveCardCatalogue.FLEETNESS_ID]))
	var before: Dictionary = _live()
	var restored: RiftBuildApplicationResult = _apply(RiftRunBuild.new())
	var after: Dictionary = _live()
	_expect(full.ok and not _is_baseline(before) and float(before["max_speed"]) == FLEET_SPEED
			and restored.ok and restored.committed and restored.supports_applied.is_empty() and _is_baseline(after)
			and _player.attack.data_is_private() and _player.attack.data != _player.attack.canonical_data,
		"an empty build left %s" % _live_line(after))
	print("  %s -> %s" % [_live_line(before), _live_line(after)])
	_done("an_empty_build_restores_the_canonical_baselines")


# --- 14. Rank three refuses ---------------------------------------------------------------------------------------------

func _check_rank_three_refuses_before_any_live_write() -> void:
	print("")
	print("--- 14. Rank three and above refuse — naming the Skill, the support, the rank and the exact supported ranks — and derive() refuses them before apply() could write")
	var pressure: Array[StringName] = [PassiveCardCatalogue.CELERITY_ID, PassiveCardCatalogue.CELERITY_ID, PassiveCardCatalogue.FLEETNESS_ID]
	var uncatalogued: RiftRunBuild = _build(0, 0, pressure)
	_expect_quiet(uncatalogued.acquire_support(QUICK_STRIKE, UNCATALOGUED).is_empty(), "stage")
	var cases: Array = [
		["Reaching Edge at rank three", _build(3, 0, pressure), REACHING_RANK_THREE_REFUSAL],
		["Sweeping Edge at rank three beside Reaching Edge at rank two", _build(2, 3, pressure), SWEEPING_RANK_THREE_REFUSAL],
		["Sweeping Edge at rank four", _build(0, 4, pressure), SWEEPING_RANK_FOUR_REFUSAL],
		["both at rank three", _build(3, 3, pressure), REACHING_RANK_THREE_REFUSAL],
		["an uncatalogued support", uncatalogued, UNCATALOGUED_REFUSAL],
	]
	var wrong: PackedStringArray = PackedStringArray()
	var answers: PackedStringArray = PackedStringArray()
	var clean: int = 0
	for case: Array in cases:
		var derived: RiftBuildApplicationResult = RiftBuildApplication.derive(case[1] as RiftRunBuild, _player, ACCEPTED_MAX_SPEED)
		var applied: RiftBuildApplicationResult = _apply(case[1] as RiftRunBuild)
		var both_right: bool = true
		for answer: RiftBuildApplicationResult in [derived, applied]:
			if answer.ok or answer.committed or answer.failure_reason != String(case[2]) or not answer.problem().is_empty() \
					or answer.reach != 0.0 or not answer.supports_applied.is_empty():
				wrong.append("%s: %s" % [case[0], answer.describe()])
				both_right = false
		if both_right and derived.failure_reason == applied.failure_reason:
			clean += 1
		answers.append("%s: '%s'" % [case[0], applied.failure_reason])
	_expect(wrong.is_empty(), "rank refusals answered: %s" % "; ".join(wrong))
	var reason: String = RiftBuildApplication.derive(_build(3, 0), _player, ACCEPTED_MAX_SPEED).failure_reason
	var facts: PackedStringArray = PackedStringArray()
	for fact: String in ["quick_strike", "reaching_edge", "rank 3", "ranks 1 and 2", "nothing was applied"]:
		if reason.contains(fact):
			facts.append(fact)
	_expect(facts.size() == 5, "the refusal names only %s" % ", ".join(facts))
	## Structurally: apply() leaves on a refusal before its first write.
	var apply_body: String = _function_body(_code_only(FileAccess.get_file_as_string(SEAM_FILE)), "apply")
	var leaves: int = apply_body.find("if not result.ok:")
	var writes: int = apply_body.find("live.")
	_expect(leaves >= 0 and writes > leaves and apply_body.count("derive(") == 1,
		"apply() does not refuse before its first write")
	for line: String in answers:
		print("  %s" % line)
	print("  %d of %d refused identically by derive() and by apply(), with no partial value; a rank-three reason names [%s]; apply() tests the refusal at character %d of its body and first writes at %d"
		% [clean, cases.size(), ", ".join(facts), leaves, writes])
	_done("rank_three_refuses_before_any_live_write")


# --- 15. A refusal writes nothing ------------------------------------------------------------------------------------

func _check_a_refusal_leaves_every_covered_value_unchanged() -> void:
	print("")
	print("--- 15. A refusal leaves every covered player and Quick Strike value exactly where it stood")
	var standing: RiftBuildApplicationResult = _apply(_build(2, 2, [PassiveCardCatalogue.CELERITY_ID]))
	var snapshot: Dictionary = _live()
	var record_before: QuickStrikeData = _player.attack.data
	var signals: Dictionary = {"n": 0}
	var counter: Callable = func(_increased: float, _time: float) -> void:
		signals["n"] = int(signals["n"]) + 1
	_player.attack_speed_changed.connect(counter)
	var pressure: Array[StringName] = [PassiveCardCatalogue.CELERITY_ID, PassiveCardCatalogue.CELERITY_ID, PassiveCardCatalogue.FLEETNESS_ID]
	var refused: int = 0
	var builds: Array[RiftRunBuild] = [_build(3, 0, pressure), _build(2, 3, pressure), _build(0, 4, pressure),
		_build(3, 3, pressure), _build(1, 3, pressure)]
	for build: RiftRunBuild in builds:
		if not _apply(build).ok:
			refused += 1
	_player.attack_speed_changed.disconnect(counter)
	var after: Dictionary = _live()
	var moved: PackedStringArray = PackedStringArray()
	for key: Variant in snapshot:
		if after[key] != snapshot[key]:
			moved.append(String(key))
	_expect(standing.ok and not _is_baseline(snapshot) and refused == builds.size() and moved.is_empty() and int(signals["n"]) == 0
			and _player.attack.data == record_before and _player.attack.data_is_private()
			and _is_canonical(_player.attack.canonical_data),
		"refusals moved %s (%d signals)" % [", ".join(moved), int(signals["n"])])
	## And the kernel still resolves the geometry it was left with.
	await _clear_enemies()
	_stand_facing(Vector3.ZERO, FACING)
	var enemy: PrototypeGraveblade = await _spawn(FACING * BETWEEN_REACHES)
	var query: Dictionary = _release_query(_player.attack.data)
	var still: String = _outcome(query)
	_expect(still == "hit" and query.get("target") == _area(enemy),
		"after the refusals the release query at 3.20 m answered %s" % still)
	_apply(RiftRunBuild.new())
	await _clear_enemies()
	print("  %d of %d rank-three-or-higher builds, each also holding +20%% Skill Speed and Fleetness, refused over %s; %d of %d covered values moved, %d speed-change signals, the same private record: %s; the release query at 3.20 m afterwards: %s"
		% [refused, builds.size(), _live_line(snapshot), moved.size(), snapshot.size(), int(signals["n"]),
			str(_player.attack.data == record_before), still])
	_done("a_refusal_leaves_every_covered_value_unchanged")


# --- 16. The canonical records --------------------------------------------------------------------------------------

func _check_the_canonical_records_are_unchanged() -> void:
	print("")
	print("--- 16. The canonical records are unchanged: quick_strike.tres in memory, and every .tres under res://data on disk")
	var canonical: QuickStrikeData = _player.attack.canonical_data
	var loaded: QuickStrikeData = load(CANONICAL_QUICK_STRIKE) as QuickStrikeData
	var after: Dictionary = _canonical_hashes()
	var same: int = 0
	for path: Variant in after:
		if _hashes_before.get(path, "") == after[path]:
			same += 1
	_expect(canonical == loaded and _is_canonical(loaded) and loaded.resource_path == CANONICAL_QUICK_STRIKE
			and _player.attack.data != loaded and _player.attack.data.resource_path.is_empty(),
		"the canonical record reads %s" % _record_line(loaded))
	_expect(after.size() > 3 and after.size() == _hashes_before.size() and same == after.size(),
		"%d of %d canonical records hashed the same after the run" % [same, after.size()])
	print("  after %d applications quick_strike.tres reads %s; %d of %d .tres records under res://data hash identically before and after"
		% [_applications, _record_line(loaded), same, after.size()])
	_done("the_canonical_records_are_unchanged")


# --- 17. I3's seed-99 behaviour ---------------------------------------------------------------------------------------

func _check_i3s_rank_one_seed_99_behaviour_is_unchanged() -> void:
	print("")
	print("--- 17. I3's three seed-99 choices, produced by the accepted run-level coordinator, apply exactly as I3 accepted them")
	var c1: PlayerStatTotals = PlayerStatTotals.new()
	_expect_quiet(c1.add(PlayerStats.SKILL_SPEED, ONE_CARD).is_empty(), "C1")
	var celerity: PlayerStatValue = c1.value_of(PlayerStats.SKILL_SPEED, ACCEPTED_ACTION_TIME)
	var wrong: PackedStringArray = PackedStringArray()
	var lines: PackedStringArray = PackedStringArray()
	var sweeping_describe: String = ""
	for expected: Array in I3_SEED_99:
		var twin: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(ROUTE_SEED)
		for mote: int in LEVEL_ONE_MOTES:
			_expect_quiet(twin.award_experience(REVIEW_AMOUNT).is_empty(), "the twin refused an award")
		_expect_quiet(twin.open_current_offer(SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(),
			PassiveCardCatalogue.records()).is_empty(), "the twin did not open its offer")
		var lane: int = -1
		for candidate: int in twin.offer_lanes():
			if ", ".join(twin.offer_identity_for(candidate)) == String(expected[0]):
				lane = candidate
		var taken: RiftRunLevelUpResult = twin.choose(lane)
		var build: RiftRunBuild = twin.run_build()
		var result: RiftBuildApplicationResult = _apply(build)
		var live: Dictionary = _live()
		var receipt: String = RogueliteLiveEffectReview.live_receipt_for(result)
		var right: bool = lane >= 0 and taken.succeeded() and result.ok and result.committed and receipt == String(expected[1])
		match String(expected[0]):
			"quick_strike, sweeping_edge":
				sweeping_describe = result.describe()
				right = right and sweeping_describe == I3_SWEEPING_DESCRIBE and build.support_rank_for(QUICK_STRIKE, SWEEPING) == 1 \
					and _geometry(live, ACCEPTED_REACH, ARC_RANK_ONE, CONE_RANK_ONE)
			"card_celerity":
				right = right and float(live["effective"]) == celerity.value and _geometry(live, ACCEPTED_REACH, ACCEPTED_ARC, ACCEPTED_CONE)
			"card_fleetness":
				right = right and float(live["max_speed"]) == FLEET_SPEED and _geometry(live, ACCEPTED_REACH, ACCEPTED_ARC, ACCEPTED_CONE)
		if not right:
			wrong.append("%s: lane %d, %s, receipt '%s'" % [expected[0], lane, result.describe(), receipt])
		lines.append("seed 99 lane %d [%s] -> %s; '%s'" % [lane, ", ".join(taken.level_up().granted_identity()) if taken.succeeded() else "none",
			_live_line(live), receipt])
		_apply(RiftRunBuild.new())
	_expect(wrong.is_empty(), "a seed-99 choice applied differently from I3: %s" % "; ".join(wrong))
	for line: String in lines:
		print("  %s" % line)
	print("  the Sweeping Edge choice derives: %s" % sweeping_describe)
	_done("i3s_rank_one_seed_99_behaviour_is_unchanged")


# --- 18. Nothing else moved ----------------------------------------------------------------------------------------

func _check_no_scene_ui_input_map_entrypoint_or_persistence_changed() -> void:
	print("")
	print("--- 18. No scene, UI, InputMap, entrypoint, save or persistence behaviour changed")
	var project: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	var actions: int = 0
	var inside: bool = false
	var action_line: RegEx = RegEx.create_from_string("^[A-Za-z_0-9]+=")
	for line: String in project.split("\n"):
		if line.begins_with("["):
			inside = line.strip_edges() == "[input]"
			continue
		if inside and action_line.search(line) != null:
			actions += 1
	var entrypoint: bool = project.contains("run/main_scene=\"%s\"" % ENTRYPOINT)
	var autoload: bool = project.contains("[autoload]")
	_expect(actions == EXPECTED_ACTIONS and entrypoint and not autoload
			and not project.contains("rank_two") and not project.contains("RankTwo"),
		"project.godot declares %d actions, or its entrypoint or autoloads moved" % actions)
	var inert: PackedStringArray = PackedStringArray()
	for path: String in [CATALOGUE_FILE, SEAM_FILE]:
		var source: String = FileAccess.get_file_as_string(path)
		var code: String = _code_only(source)
		for token: String in INERT_TOKENS:
			if code.contains(token):
				inert.append("%s: %s" % [path.get_file(), token])
		if not code.contains("\nextends RefCounted\n"):
			inert.append("%s is not a RefCounted" % path.get_file())
	_expect(inert.is_empty(), "an edited file names %s" % ", ".join(inert))
	var catalogue_names: PackedStringArray = _names_in(FileAccess.get_file_as_string(CATALOGUE_FILE))
	var seam_names: PackedStringArray = _names_in(FileAccess.get_file_as_string(SEAM_FILE))
	var result_names: PackedStringArray = _names_in(FileAccess.get_file_as_string(RESULT_FILE))
	_expect(catalogue_names == _sorted(CATALOGUE_NAMES) and seam_names == _sorted(SEAM_NAMES) and result_names == _sorted(RESULT_NAMES),
		"the catalogue names %s; the seam %s; the result %s" % [", ".join(catalogue_names), ", ".join(seam_names),
			", ".join(result_names)])
	print("  project.godot: %d actions; the Prototype App entrypoint %s; [autoload] present: %s; %d of %d inert-token or RefCounted findings in the catalogue and the seam"
		% [actions, "unchanged" if entrypoint else "MOVED", str(autoload), inert.size(), INERT_TOKENS.size()])
	print("  the catalogue names %d project classes (%s), the seam %d and the result %d — the sets measured before the first I4 edit, the result's with the player's class since I14 (D-320)"
		% [catalogue_names.size(), ", ".join(catalogue_names), seam_names.size(), result_names.size()])
	_done("no_scene_ui_input_map_entrypoint_or_persistence_changed")


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


# --- Source reading ------------------------------------------------------------------------------------------------

## Every `.tres` under res://data, by SHA-256.
func _canonical_hashes() -> Dictionary:
	var hashes: Dictionary = {}
	for path: String in _files_under(CANONICAL_DATA_ROOT, [".tres"]):
		hashes[path] = FileAccess.get_sha256(path)
	return hashes


## Code with whole-line comments removed; string literals kept.
func _uncommented(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


## Code with every comment removed and every string literal emptied.
func _code_only(source: String) -> String:
	var strings: RegEx = RegEx.create_from_string("\"([^\"\\\\]|\\\\.)*\"")
	var emptied: String = strings.sub(_uncommented(source), "\"\"", true)
	var trailing: RegEx = RegEx.create_from_string("(?m)\\s#.*$")
	return trailing.sub(emptied, "", true)


## Every distinct numeric literal in `code`, as written.
func _numeric_literals(code: String) -> PackedStringArray:
	var pattern: RegEx = RegEx.create_from_string("(?<![A-Za-z_0-9.])[0-9]+(?:\\.[0-9]+)?(?![A-Za-z_0-9.])")
	var found: PackedStringArray = PackedStringArray()
	for match: RegExMatch in pattern.search_all(code):
		if not found.has(match.get_string()):
			found.append(match.get_string())
	found.sort()
	return found


func _values_within(literals: PackedStringArray, allowed: Array[float]) -> bool:
	for literal: String in literals:
		if not allowed.has(literal.to_float()):
			return false
	return true


## Arithmetic operators in code: the return arrow excluded, and so is `%` applied to a
## string literal, which formats text and computes nothing. The first development run
## of this suite counted the seam's two `"…" % value` phrases as arithmetic — a defect
## in this check, recorded rather than quietly repaired.
func _operators_in(code: String) -> int:
	var formatting: RegEx = RegEx.create_from_string("\"\"\\s*%")
	var bare: String = formatting.sub(code.replace("->", ""), "\"\"", true)
	var count: int = 0
	for operator: String in ["+", "-", "*", "/", "%"]:
		count += bare.count(operator)
	return count


## The indented body of top-level function `name`, up to the next unindented line.
func _function_body(source: String, name: String) -> String:
	var body: PackedStringArray = PackedStringArray()
	var inside: bool = false
	for line: String in source.split("\n"):
		if line.begins_with("func %s(" % name) or line.begins_with("static func %s(" % name):
			inside = true
			continue
		if inside:
			if not line.is_empty() and not line.begins_with("\t") and not line.begins_with(" ") \
					and not line.begins_with(")"):
				break
			body.append(line)
	return "\n".join(body)


func _names_in(source: String) -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var id: String = String(entry.get("class", ""))
		if not id.is_empty() and source.contains(id):
			names.append(id)
	names.sort()
	return names


func _sorted(values: Array[String]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray(values)
	out.sort()
	return out


func _files_under(root_path: String, extensions: Array[String]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var directory: DirAccess = DirAccess.open(root_path)
	if directory == null:
		return out
	directory.list_dir_begin()
	var entry: String = directory.get_next()
	while not entry.is_empty():
		var full: String = "%s/%s" % [root_path, entry]
		if directory.current_is_dir():
			if not entry.begins_with("."):
				out.append_array(_files_under(full, extensions))
		else:
			for extension: String in extensions:
				if entry.ends_with(extension):
					out.append(full)
					break
		entry = directory.get_next()
	directory.list_dir_end()
	return out


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


## Records a failure without adding to the pinned count, inside loops and stagings whose
## length is incidental.
func _expect_quiet(condition: bool, failure_message: String) -> void:
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
