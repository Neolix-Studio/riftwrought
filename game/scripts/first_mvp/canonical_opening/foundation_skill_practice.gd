class_name FoundationSkillPractice
extends Node3D
## First-MVP — Gate 1E: the DEVELOPER-ONLY practice range for the three
## Foundation Skills (D-219).
##
## The brief, §17, authorizes exactly this: "The Rift Nexus is a safe area. Do
## not make Mara stand next to the player while the player repeatedly fireballs
## her. Normal damaging Skill execution may be disabled in the canonical safe
## Nexus. Automated verification or a separate developer-only practice scene may
## validate the Foundation Skills. Do NOT add a canonical combat dummy merely to
## test this gate."
##
## So this is a SEPARATE SCENE, reached by nothing in the game, containing no
## story, no Mara, no Anchor, no save and no progression. It is the Gate C
## practice-post precedent applied to Gate 1E: a flat plate, the player, and
## three Graveblades to hit. It is not canonical content and nothing in the
## canonical opening loads it.
##
## The Graveblades are reused UNMODIFIED — `graveblade.tres` is untouched, the
## same 300-Life record every gate since D has used — so "Faultbreaker takes two
## Hits and Emberbolt takes three" is measured against the same target the
## project has always measured against.
##
##   Run it directly:
##     /Applications/Godot.app/Contents/MacOS/Godot --path game \
##       res://scenes/first_mvp/canonical_opening/foundation_skill_practice.tscn
##
##   1 / 2 / 3   Faultbreaker · Splinter Shot · Emberbolt (PHYSICAL KEYS; no
##               InputMap action was added, for the reason every gate since 1A
##               has had — Gate E and Gate F emit one assertion per key event)
##   4 / 5 / 6   equip the Garrison Greatsword · Marrow Bow · Cantor Wand
##   R           restore the Graveblades and refill Life and Mana
##
## Left click still moves and right click still swings Quick Strike, both
## through the same inherited kernel, so the contrast between Quick Strike and a
## Foundation Skill can be felt rather than read.

const WORLD_MASK: int = 1
const PLAYER_SCENE: String = "res://scenes/actors/prototype_player.tscn"
const GRAVEBLADE_SCENE: String = "res://scenes/actors/prototype_graveblade.tscn"
const STARTING_SWORD: String = "res://data/first_mvp/severed_threshold/broken_watch/starting_sword.tres"

const FLOOR: Rect2 = Rect2(Vector2(-22.0, -18.0), Vector2(44.0, 36.0))
const TARGET_SPOTS: Array[Vector2] = [
	Vector2(0.0, -8.0), Vector2(-2.4, -9.6), Vector2(2.4, -9.6),
]
const PLAYER_SPOT: Vector2 = Vector2(0.0, 4.0)

const WEAPON_PATHS: Array[String] = [
	"res://data/first_mvp/foundation/garrison_greatsword.tres",
	"res://data/first_mvp/foundation/marrow_bow.tres",
	"res://data/first_mvp/foundation/cantor_wand.tres",
]

var player: PrototypePlayer
var loadout: FirstMvpEquipment
var attack_coordinator: AttackCoordinator
var acquisition: TargetAcquisition
var camera_rig: PrototypeCameraRig
var input_family: InputFamilyTracker
var nav_region: NavigationRegion3D
var skills: FirstMvpSkillLibrary
var graveblades: Array[PrototypeGraveblade] = []

## One `FirstMvpSkillAction` per Foundation Skill, all three built and all three
## live. Which one a press drives is a key, not a branch in the machine.
var actions: Dictionary = {}
var active_skill: StringName = FirstMvpSkillLibrary.FAULTBREAKER_ID

var log_lines: PackedStringArray = PackedStringArray()

var _mouse_hold: PrototypeMouseHold = PrototypeMouseHold.new()
var _forced_aim: PrototypeTargetable = null


func _ready() -> void:
	nav_region = $NavigationRegion3D
	camera_rig = $CameraRig
	input_family = $InputFamilyTracker
	skills = FirstMvpSkillLibrary.new()
	assert(skills.is_coherent(), "FoundationSkillPractice: %s" % ", ".join(skills.problems))

	_build_floor()
	_configure_navigation()
	nav_region.bake_navigation_mesh(false)

	_spawn_player()
	_spawn_kernel()
	_spawn_skills()
	_spawn_graveblades()

	camera_rig.set_target(player)
	camera_rig.reset_calibration()

	log_event("practice range", "developer-only; no story, no save, no progression")
	for id: StringName in [FirstMvpSkillLibrary.FAULTBREAKER_ID,
		FirstMvpSkillLibrary.SPLINTER_SHOT_ID, FirstMvpSkillLibrary.EMBERBOLT_ID]:
		log_event("skill", skills.record(id).describe())
	await get_tree().physics_frame
	_maybe_start_verification()


func _maybe_start_verification() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if not arguments.has("--verify-skills"):
		return
	var script: GDScript = load("res://tests/gate_1e_foundation_skills_verification.gd") as GDScript
	var runner: Node = Node.new()
	runner.name = "FoundationSkillVerification"
	runner.set_script(script)
	runner.set("practice", self)
	runner.set("arguments", arguments)
	add_child(runner)


# --- Assembly ------------------------------------------------------------------

func _build_floor() -> void:
	var plate: MeshInstance3D = MeshInstance3D.new()
	plate.name = "Floor"
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = Vector3(FLOOR.size.x, 0.20, FLOOR.size.y)
	plate.mesh = mesh
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = Color(0.62, 0.63, 0.66)
	material.roughness = 0.94
	plate.material_override = material
	plate.position = Vector3(
		FLOOR.position.x + FLOOR.size.x * 0.5, -0.10, FLOOR.position.y + FLOOR.size.y * 0.5
	)
	nav_region.add_child(plate)

	var body: StaticBody3D = StaticBody3D.new()
	body.name = "FloorCollision"
	body.collision_layer = WORLD_MASK
	body.collision_mask = 0
	var shape: CollisionShape3D = CollisionShape3D.new()
	var box: BoxShape3D = BoxShape3D.new()
	box.size = Vector3(FLOOR.size.x, 0.20, FLOOR.size.y)
	shape.shape = box
	shape.position = plate.position
	body.add_child(shape)
	nav_region.add_child(body)


func _configure_navigation() -> void:
	var mesh: NavigationMesh = NavigationMesh.new()
	mesh.geometry_parsed_geometry_type = NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS
	mesh.geometry_collision_mask = WORLD_MASK
	mesh.geometry_source_geometry_mode = NavigationMesh.SOURCE_GEOMETRY_ROOT_NODE_CHILDREN
	mesh.cell_size = 0.15
	mesh.cell_height = 0.15
	mesh.agent_radius = 0.40
	mesh.agent_height = 1.80
	mesh.agent_max_climb = 0.20
	mesh.agent_max_slope = 20.0
	mesh.filter_baking_aabb = AABB(
		Vector3(FLOOR.position.x, -1.0, FLOOR.position.y),
		Vector3(FLOOR.size.x, 1.9, FLOOR.size.y)
	)
	nav_region.navigation_mesh = mesh


func _spawn_player() -> void:
	var sword: PrototypeWeaponData = load(STARTING_SWORD) as PrototypeWeaponData
	loadout = FirstMvpEquipment.new(sword)
	player = (load(PLAYER_SCENE) as PackedScene).instantiate() as PrototypePlayer
	player.name = "Player"
	player.max_speed = 5.0
	player.weapon = sword
	$Actors.add_child(player)
	player.global_position = Vector3(PLAYER_SPOT.x, 0.0, PLAYER_SPOT.y)
	player.face_instantly(Vector3(0.0, 0.0, -1.0))


func _spawn_kernel() -> void:
	attack_coordinator = AttackCoordinator.new()
	attack_coordinator.name = "AttackCoordinator"
	attack_coordinator.set_log_sink(_log_event)
	add_child(attack_coordinator)
	acquisition = TargetAcquisition.new(get_world_3d())
	player.attack.setup(player, acquisition, _resolve_aim, _target_candidates, _log_event)


## ONE MACHINE, THREE RECORDS. Each `FirstMvpSkillAction` is the SAME class with
## a different `FirstMvpSkillData`; nothing about a heavy Area attack, a
## Physical projectile or a Fire Spell is special-cased in a call site here.
func _spawn_skills() -> void:
	for id: StringName in [FirstMvpSkillLibrary.FAULTBREAKER_ID,
		FirstMvpSkillLibrary.SPLINTER_SHOT_ID, FirstMvpSkillLibrary.EMBERBOLT_ID]:
		var action: FirstMvpSkillAction = FirstMvpSkillAction.new()
		action.name = String(id)
		action.data = skills.record(id)
		add_child(action)
		action.setup(player, acquisition, _resolve_aim, _target_candidates, _log_event,
			$Actors, _equipped_family)
		actions[id] = action


func _spawn_graveblades() -> void:
	for index: int in TARGET_SPOTS.size():
		var enemy: PrototypeGraveblade = (load(GRAVEBLADE_SCENE) as PackedScene).instantiate() as PrototypeGraveblade
		enemy.name = "PracticeGraveblade%d" % index
		enemy.position = Vector3(TARGET_SPOTS[index].x, 0.0, TARGET_SPOTS[index].y)
		$Actors.add_child(enemy)
		enemy.setup(player, attack_coordinator, acquisition, _log_event)
		# Inert by default: this range exists to measure what the SKILLS do, and
		# an enemy fighting back turns a measurement into a fight.
		enemy.set_ai_enabled(false)
		graveblades.append(enemy)


# --- Skill plumbing ------------------------------------------------------------

func _equipped_family() -> StringName:
	return loadout.equipped_family()


## THE PRODUCTION AIM RULE, DISPATCHED PER USE. Called ONCE per Skill Use by
## `FirstMvpSkillAction._begin_attempt()`; nothing it returns survives into the
## next use, which is what makes D-193's per-use rule structurally true rather
## than remembered. Mouse and controller are separate branches, exactly as
## `BrokenWatchSlice._resolve_quick_strike_aim()` separates them.
func _resolve_aim() -> Dictionary:
	if _forced_aim != null:
		var forced: PrototypeTargetable = _forced_aim
		_forced_aim = null
		return {
			"target": forced,
			"direction": Vector3(
				forced.global_position.x - player.global_position.x, 0.0,
				forced.global_position.z - player.global_position.z
			),
			"reason": "forced for verification",
		}
	if input_family.family == InputFamilyTracker.Family.CONTROLLER:
		return _controller_aim()
	var camera: Camera3D = camera_rig.camera
	var screen: Vector2 = get_viewport().get_mouse_position()
	var from: Vector3 = camera.project_ray_origin(screen)
	var direction: Vector3 = camera.project_ray_normal(screen)
	var picked: PrototypeTargetable = acquisition.fixture_under_ray(from, direction)
	if picked != null:
		return {
			"target": picked,
			"direction": picked.global_position - player.global_position,
			"reason": "cursor over %s" % picked.target_display_name(),
		}
	var cursor: Dictionary = PrototypeGroundPointer.ground_point(camera, get_world_3d(), screen, WORLD_MASK)
	var aim: Vector3 = player.facing_direction()
	if bool(cursor.get("valid", false)):
		var point: Vector3 = cursor["point"]
		aim = Vector3(point.x - player.global_position.x, 0.0, point.z - player.global_position.z)
	return {"target": null, "direction": aim, "reason": "directional toward the cursor"}


## Controller soft targeting for the Foundation Skills. The stick supplies the
## intent, the Skill's own cone and acquisition distance decide what that intent
## reaches, and CLEAR PLAYER INTENT WINS: the returned direction is always the
## stick's, never the target's, so a soft target corrects the shot rather than
## replacing the aim.
##
## No retention and no lock-on. See `FirstMvpSkillAction.soft_target()` for why
## both differences from D-178 are canonical rather than convenient.
func _controller_aim() -> Dictionary:
	var raw: Vector2 = PrototypeLocomotion.read_stick_actions()
	var intended: Vector3 = player.facing_direction()
	if raw.length() > player.stick_deadzone:
		var planar: Vector3 = camera_rig.ground_right() * raw.x + camera_rig.ground_forward() * -raw.y
		if planar.length() > 0.0001:
			intended = planar.normalized()
	var action: FirstMvpSkillAction = active_action()
	if action == null:
		return {"target": null, "direction": intended, "reason": "no Skill selected"}
	var outcome: Dictionary = action.soft_target(player.global_position, intended, _target_candidates())
	return {
		"target": outcome["target"],
		"direction": intended,
		"reason": String(outcome["reason"]),
	}


func force_next_aim_for_verification(target: PrototypeTargetable) -> void:
	_forced_aim = target


func _target_candidates() -> Array[PrototypeTargetable]:
	var found: Array[PrototypeTargetable] = []
	for enemy: PrototypeGraveblade in graveblades:
		if not is_instance_valid(enemy):
			continue
		var area: PrototypeTargetable = enemy.get_node_or_null("TargetArea") as PrototypeTargetable
		if area != null:
			found.append(area)
	return found


func action_for(skill_id: StringName) -> FirstMvpSkillAction:
	return actions.get(skill_id, null)


func active_action() -> FirstMvpSkillAction:
	return action_for(active_skill)


func select_skill(skill_id: StringName) -> void:
	if not actions.has(skill_id):
		return
	active_skill = skill_id
	var record: FirstMvpSkillData = skills.record(skill_id)
	log_event("skill selected", "%s — %s" % [record.display_name, _requirement_status(skill_id)])


func _requirement_status(skill_id: StringName) -> String:
	var action: FirstMvpSkillAction = action_for(skill_id)
	return action.requirement_status() if action != null else "unknown"


func equip_index(index: int) -> void:
	if index < 0 or index >= WEAPON_PATHS.size():
		return
	var record: FirstMvpWeaponRecord = load(WEAPON_PATHS[index]) as FirstMvpWeaponRecord
	loadout.pick_up(record)
	loadout.equip(record)
	player.equip_weapon(record)
	log_event("equipped", "%s — %s" % [record.describe(), loadout.describe_slots()])
	for id: StringName in actions.keys():
		log_event("requirement", "%s: %s" % [skills.record(id).display_name, _requirement_status(id)])


func restore() -> void:
	player.revive_for_testing()
	for index: int in graveblades.size():
		var enemy: PrototypeGraveblade = graveblades[index]
		if is_instance_valid(enemy):
			enemy.reset_encounter()
			enemy.set_ai_enabled(false)
	attack_coordinator.reset()
	log_event("restored", "Graveblades and resources reset")


# --- Frame ---------------------------------------------------------------------

func _process(delta: float) -> void:
	player.set_ground_basis(camera_rig.ground_forward(), camera_rig.ground_right())
	if _mouse_hold.should_reissue(delta, Input.is_action_pressed(&"move_point")):
		_issue_move_command()


func _physics_process(delta: float) -> void:
	player.set_stick_raw(PrototypeLocomotion.read_stick_actions())
	for id: StringName in actions.keys():
		(actions[id] as FirstMvpSkillAction).tick(delta)


func _input(event: InputEvent) -> void:
	input_family.observe(event)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"move_point"):
		_mouse_hold.press()
		_issue_move_command()
		return
	if event.is_action_released(&"move_point"):
		_mouse_hold.release()
		return
	if event.is_action_pressed(&"quick_strike"):
		player.suspend_held_movement_for_attack()
		_mouse_hold.release()
		player.attack.press()
		return
	if event.is_action_released(&"quick_strike"):
		player.attack.release_input()
		return
	if event.is_action_pressed(&"interact"):
		active_action().press()
		return
	if event.is_action_released(&"interact"):
		active_action().release_input()
		return
	_handle_practice_keys(event)


func _handle_practice_keys(event: InputEvent) -> void:
	var key: InputEventKey = event as InputEventKey
	if key == null or not key.pressed or key.echo:
		return
	match key.physical_keycode:
		KEY_1:
			select_skill(FirstMvpSkillLibrary.FAULTBREAKER_ID)
		KEY_2:
			select_skill(FirstMvpSkillLibrary.SPLINTER_SHOT_ID)
		KEY_3:
			select_skill(FirstMvpSkillLibrary.EMBERBOLT_ID)
		KEY_4:
			equip_index(0)
		KEY_5:
			equip_index(1)
		KEY_6:
			equip_index(2)
		KEY_R:
			restore()


func _issue_move_command() -> void:
	var screen: Vector2 = get_viewport().get_mouse_position()
	var cursor: Dictionary = PrototypeGroundPointer.ground_point(
		camera_rig.camera, get_world_3d(), screen, WORLD_MASK
	)
	if not bool(cursor.get("valid", false)):
		return
	var requested: Vector3 = cursor["point"]
	var resolution: Dictionary = PrototypeGroundPointer.resolve_to_navigation(
		get_world_3d().navigation_map, requested
	)
	player.command_move_to(resolution["point"], requested, bool(resolution["adjusted"]))


func _log_event(kind: String, detail: String) -> void:
	log_event(kind, detail)


func log_event(kind: String, detail: String) -> void:
	var line: String = "[practice] %-26s %s" % [kind, detail]
	log_lines.append(line)
	print(line)
