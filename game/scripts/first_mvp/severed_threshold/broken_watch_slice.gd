class_name BrokenWatchSlice
extends Node3D
## Riftwrought — Gate 1D: Broken Watch Combat & Loot Slice (decision D-217).
##
## THE FIRST DIRECTLY RUNNABLE CANONICAL-OPENING PLAYTEST SCENE. It assembles,
## without editing any of them:
##
##   * Riftfall Landing's ACCEPTED Greybox V2 layout and Visual Review dressing
##     (`RiftfallLandingGreyboxLayout`, `RiftfallLandingVisualReviewDressing`,
##     `ExteriorReviewLighting`, `ExteriorReviewTreatment`) — instanced fresh,
##     UNMODIFIED, exactly as `riftfall_landing_visual_review.tscn` already
##     does. Route, dimensions, camera, collision, navigation, lighting
##     direction and material treatment are untouched.
##   * `BrokenWatchLayout` (this gate's one new authored space), placed as a
##     SIBLING of the Landing layout under the SAME `NavigationRegion3D`, so
##     the whole slice bakes as one continuous navigation mesh rather than two
##     maps stitched together at runtime.
##   * The proven Prototype Zero combat kernel, reused by COMPOSITION exactly
##     as `prototype_zero.gd` wires it: `PrototypePlayer`, `PrototypeGraveblade`
##     (x2, the reused `graveblade.tres` data, unedited), `QuickStrikeAction`,
##     `AttackCoordinator`, `TargetAcquisition`, `DamageEvent` — none of these
##     files are touched. This scene builds fresh instances of the two plain
##     coordinator/acquisition classes and calls the same `setup()` contracts
##     Prototype Zero's own room calls.
##
## THE ONE PRODUCTION RULE THIS SCENE MUST ENFORCE THAT PROTOTYPE ZERO DOES
## NOT: per-use mouse targeting, not persistent selection (D-193, canonical in
## `design/COMBAT_IDENTITY_AND_MOMENT_TO_MOMENT.md` §12/§21). Research into
## `QuickStrikeAction`/`TargetAcquisition` found the KERNEL already resolves
## per-use correctly — `target` is sampled fresh from `_aim_provider.call()`
## exactly once per attempt and cleared at the attempt's end. The one thing
## Prototype Zero's OWN room does that must NOT be copied here is
## `PrototypeZeroRoom.soft_target`, which conflates controller D-178 retention
## with a mouse "quiet indicator" field that outlives one Skill Use. This
## scene's `_mouse_aim_provider()` therefore does a bare fresh ray pick with NO
## stored field at all, and hover-info (`_update_hover_info()`) is a
## COMPLETELY SEPARATE per-frame query the aim provider never reads — hover
## can inform the HUD and can never leak into acquisition, structurally.
## Controller retention reuses `TargetAcquisition.soft_target()` and its D-178
## cone/tie/retention fields exactly as `_controller_aim()` does, with the
## retained `previous` target kept local to `_soft_target` here.
##
## SCOPE, EXACTLY THE BOUNDED GATE 1D BRIEF. No Nexus Threshold, no Mara, no
## dialogue, no Foundation Cache, no Rift Shards/Echo, no Augments, no Skill
## Configuration UI, no other Skills, no ailments, no other Ossuary Host
## roles, no Elites, no Forge, no random loot table, no procedural
## generation. Reaching `ExitToNexusThreshold` logs a restrained completion
## line and nothing else — no scene load, no save, no Passive point.
##
## WRITES NOTHING. This scene never constructs `PrototypeSettings` or
## `PrototypeLabState` and is never loaded through `PrototypeApp`, so nothing
## it does can reach the engine's persistent user-data store — exactly the
## precedent `riftfall_landing_review.tscn` already set for a bounded
## playtest scene.
##
## Run it directly:
##   /Applications/Godot.app/Contents/MacOS/Godot --path game \
##     res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn

const WORLD_MASK: int = 1
const VERIFICATION_SCRIPT: String = "res://tests/gate_1d_broken_watch_verification.gd"

const STARTING_SWORD_PATH: String = "res://data/first_mvp/severed_threshold/broken_watch/starting_sword.tres"
const WATCHSTEEL_SWORD_PATH: String = "res://data/first_mvp/severed_threshold/broken_watch/watchsteel_sword.tres"
const PLAYER_SCENE: String = "res://scenes/actors/prototype_player.tscn"
const GRAVEBLADE_SCENE: String = "res://scenes/actors/prototype_graveblade.tscn"
const ITEM_DROP_SCRIPT: String = "res://scripts/items/first_mvp_item_drop.gd"

const ACCEPTED_MAX_SPEED: float = 5.0
const EXIT_REACHED_METRES: float = 2.5
const FALLEN_DELAY: float = 0.90
const ITEM_INTERACTION_RANGE: float = 2.20
## The same yaw Riftfall Landing's own `Composition` node carries in every
## variant (canonical, Greybox V2, visual review), so the layout's local -Z
## runs straight up the screen at the accepted camera. Broken Watch is a
## sibling under this SAME node, so it inherits the identical orientation
## without a second rotation decision.
const COMPOSITION_YAW_DEGREES: float = 45.0

@export_group("Navigation bake, metres")
@export var agent_radius: float = 0.40
@export var agent_height: float = 1.80
@export var agent_max_climb: float = 0.20
@export var agent_max_slope: float = 20.0
@export var nav_cell_size: float = 0.15
@export var bake_ceiling: float = 0.90
@export var bake_floor: float = -1.00

@export_group("Review controls")
@export var camera_distance_step: float = 2.0

var composition: Node3D
var landing_layout: RiftfallLandingGreyboxLayout
var landing_dressing: RiftfallLandingVisualReviewDressing
var broken_watch: BrokenWatchLayout
var nav_region: NavigationRegion3D
var lighting: ExteriorReviewLighting
var treatment: ExteriorReviewTreatment
var camera_rig: PrototypeCameraRig
var marker: DestinationMarker
var input_family: InputFamilyTracker
var hud: FirstMvpCombatHud
var item_comparison: FirstMvpItemComparison
var fallen_overlay: FirstMvpFallenOverlay

var player: PrototypePlayer
var loadout: PlayerLoadout
var attack_coordinator: AttackCoordinator
var acquisition: TargetAcquisition
var graveblades: Array[PrototypeGraveblade] = []

var navmesh_polygon_count: int = 0
var navmesh_area: float = 0.0
var bake_count: int = 0

var log_lines: PackedStringArray = PackedStringArray()
var grid_visible: bool = false
var slice_complete: bool = false
var refused_action_inputs: int = 0

var _mouse_hold: PrototypeMouseHold = PrototypeMouseHold.new()
var _soft_target: PrototypeTargetable = null
var _soft_target_since_msec: int = 0

var _active_drop: FirstMvpItemDrop = null
var _drop_granted: bool = false
var _rewarded_enemies: Dictionary = {}
var _nameplate: Button

var _fallen_countdown: float = -1.0
var _pending_fallen_event: DamageEvent = null

## Verification seam, the same established pattern as Gate B's
## `set_stick_override` and Gate D's `begin_attack_for_verification()`: forces
## the NEXT Quick Strike aim resolution onto an exact target, bypassing the
## real cursor so the checks can drive one deterministic attack without a
## screen to point at. It consumes itself after one use — the same per-use
## semantics as the real aim providers — so ordinary play (which never calls
## it) is completely unaffected.
var _forced_aim_target_for_verification: PrototypeTargetable = null


func _ready() -> void:
	composition = $Composition
	composition.rotation_degrees = Vector3(0.0, COMPOSITION_YAW_DEGREES, 0.0)
	nav_region = $Composition/NavigationRegion3D
	landing_layout = $Composition/NavigationRegion3D/Landing
	broken_watch = $Composition/NavigationRegion3D/BrokenWatch
	landing_dressing = $Composition/LandingDressing
	camera_rig = $CameraRig
	marker = $DestinationMarker
	input_family = $InputFamilyTracker
	hud = $CanvasLayer/Hud
	item_comparison = $CanvasLayer/ItemComparison
	fallen_overlay = $CanvasLayer/FallenOverlay

	lighting = $ExteriorLighting
	treatment = ExteriorReviewTreatment.new()
	lighting.configure($WorldEnvironment, $KeyLight)

	# First-MVP Gameplay J11 (decision D-344): RIFTFALL LANDING CLOSED ITS OWN FAR END,
	# AND THAT CLOSURE IS FALSE IN THIS COMPOSITION. The Landing's accepted Greybox V2
	# ends in a tall boundary mass its own source calls "the far cap beyond the landing,
	# so the space closes rather than trailing into open void" -- exactly right for a
	# Landing that ends there, and a solid standing inside Broken Watch's Watch Threshold
	# here, because the two layouts are siblings in one shared local frame. On the route's
	# own centreline it stopped a player-sized body outright and the navigation mesh
	# carried no surface at all, so the seam was passable only by a detour the design
	# never drew. It is removed from THIS instance, before the bake, exactly as
	# `CanonicalOpeningRuntime` removes Broken Watch's own far cap toward the Nexus
	# Threshold: `riftfall_landing_greybox_layout.gd` is untouched, and the standalone
	# Landing review still builds the cap, because a Landing that ends there needs it.
	#
	# THE CAP IS FOUND FROM AUTHORED STRUCTURAL DATA, NOT FROM A NODE NAME: it is the only
	# Riftfall Landing boundary mass whose footprint overlaps a Broken Watch walkable
	# rectangle -- the defect itself, written as a predicate over both layouts' own
	# constants. Exactly one must qualify, and exactly its three built nodes must go: the
	# visual, the collision shape and the navigation carve. Anything else is a real change
	# to one of the two layouts, and it must fail loudly rather than quietly reseal the
	# route or quietly take more of the Landing down with it.
	var landing_caps: Array[Rect2] = []
	for mass: Dictionary in RiftfallLandingGreyboxLayout.BOUNDARY_MASSES:
		var rect: Rect2 = mass["rect"]
		for room: Rect2 in BrokenWatchLayout.WALKABLE:
			if rect.intersects(room):
				landing_caps.append(rect)
				break
	var cap_nodes_removed: int = 0
	for rect: Rect2 in landing_caps:
		var stem: String = "Boundary_%d_%d" % [int(rect.position.x * 10.0), int(rect.position.y * 10.0)]
		for built: String in ["Visuals/%s" % stem, "WorldCollision/%s" % stem,
				"NavigationObstacles/%sCarve" % stem]:
			var node: Node = landing_layout.get_node_or_null(built)
			if node != null:
				node.free()
				cap_nodes_removed += 1
	var cap_fault: String = "BrokenWatchSlice: expected exactly 1 Riftfall Landing far cap overlapping Broken Watch and its 3 built nodes, found %d and %d" % [landing_caps.size(), cap_nodes_removed]
	if landing_caps.size() != 1 or cap_nodes_removed != 3:
		# `assert()` is stripped in release builds; `push_error()` is not, so both are used.
		push_error(cap_fault)
	assert(landing_caps.size() == 1 and cap_nodes_removed == 3, cap_fault)
	log_event("landing cap opened", "%d Riftfall Landing boundary mass overlaps Broken Watch; its %d built nodes are removed in THIS composition, before the bake" % [landing_caps.size(), cap_nodes_removed])

	_configure_navigation()
	bake_navigation()

	# Riftfall Landing's own accepted treatment, applied exactly as
	# `riftfall_landing_visual_review.gd` applies it — one selection, no
	# neutral state, no toggle.
	landing_dressing.build(landing_layout, treatment, lighting)
	lighting.set_mode(ExteriorReviewLighting.Mode.CANDIDATE)
	treatment.set_candidate(true)

	_spawn_player()
	_spawn_combat_kernel()
	_spawn_graveblades()

	hud.bind_room(self)
	item_comparison.bind_room(self)
	fallen_overlay.bind_room(self)

	camera_rig.set_target(player)
	camera_rig.reset_calibration()
	input_family.family_changed.connect(_on_family_changed)

	_build_nameplate()

	log_event("broken watch slice", "Gate 1D playtest scene assembled; writes nothing")
	log_event("landing footprint", "%.2f m^2 (Riftfall Landing, unmodified)" % landing_layout.footprint_area())
	log_event("broken watch footprint", "%.2f m^2 across %d rooms" % [
		broken_watch.footprint_area(), broken_watch.room_count(),
	])
	log_event("dressing", "landing %d instance(s), broken watch %d instance(s)" % [
		landing_dressing.instance_count(), broken_watch.dressing_instance_count(),
	])

	await _await_navigation_synchronized()
	_maybe_start_verification()


func _maybe_start_verification() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if not arguments.has("--verify-1d"):
		return
	var script: GDScript = load(VERIFICATION_SCRIPT) as GDScript
	var runner: Node = Node.new()
	runner.name = "BrokenWatchVerification"
	runner.set_script(script)
	runner.set("slice", self)
	runner.set("arguments", arguments)
	add_child(runner)


# --- Assembly ------------------------------------------------------------------

func _spawn_player() -> void:
	var starting_sword: PrototypeWeaponData = load(STARTING_SWORD_PATH) as PrototypeWeaponData
	loadout = PlayerLoadout.new(starting_sword)

	player = (load(PLAYER_SCENE) as PackedScene).instantiate() as PrototypePlayer
	player.name = "Player"
	player.max_speed = ACCEPTED_MAX_SPEED
	player.weapon = starting_sword
	$Actors.add_child(player)
	player.global_position = landing_layout.player_start()
	player.face_instantly(route_forward())

	player.movement_command_resolved.connect(_on_movement_command_resolved)
	player.arrived_at_destination.connect(_on_arrived)
	player.movement_intent_cleared.connect(_on_intent_cleared)
	player.fell.connect(_on_player_fell)
	player.weapon_changed.connect(_on_weapon_changed)


func route_forward() -> Vector3:
	var points: PackedVector3Array = landing_layout.centreline_world()
	if points.size() < 2:
		return Vector3(0.0, 0.0, -1.0)
	var span: Vector3 = points[1] - points[0]
	return Vector3(span.x, 0.0, span.z).normalized()


func _spawn_combat_kernel() -> void:
	attack_coordinator = AttackCoordinator.new()
	attack_coordinator.name = "AttackCoordinator"
	attack_coordinator.set_log_sink(_log_combat_event)
	add_child(attack_coordinator)

	acquisition = TargetAcquisition.new(get_world_3d())

	player.attack.setup(player, acquisition, _resolve_quick_strike_aim, _target_candidates, _log_combat_event)


func _spawn_graveblades() -> void:
	graveblades.append(_spawn_graveblade("FirstGraveblade", broken_watch.first_encounter_spawn()))
	graveblades.append(_spawn_graveblade("SecondGraveblade", broken_watch.second_encounter_spawn()))
	# First-MVP Gameplay J9 (decision D-338): the Graveblade that emits `died` is
	# bound, because `DamageEvent.source` is the attacker, not the enemy that died.
	graveblades[0].died.connect(_on_first_graveblade_died.bind(graveblades[0]))


func _spawn_graveblade(node_name: String, at: Vector3) -> PrototypeGraveblade:
	var enemy: PrototypeGraveblade = (load(GRAVEBLADE_SCENE) as PackedScene).instantiate() as PrototypeGraveblade
	enemy.name = node_name
	# Position is set BEFORE the node enters the tree, not after: `_ready()`
	# captures `_spawn_position` from `global_position` the moment it enters,
	# and `reset_encounter()` (used by Restart) returns the Graveblade there.
	# Setting the position after `add_child()` would leave every restart
	# sending it back to world origin instead of its authored encounter spawn.
	enemy.position = at
	$Actors.add_child(enemy)
	enemy.face_instantly(-route_forward())
	enemy.setup(player, attack_coordinator, acquisition, _log_combat_event)
	return enemy


func graveblade_max_life() -> float:
	if graveblades.is_empty() or graveblades[0].data == null:
		return 0.0
	return graveblades[0].data.max_life


# --- Navigation ------------------------------------------------------------

func _configure_navigation() -> void:
	var mesh: NavigationMesh = NavigationMesh.new()
	mesh.geometry_parsed_geometry_type = NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS
	mesh.geometry_collision_mask = WORLD_MASK
	mesh.geometry_source_geometry_mode = NavigationMesh.SOURCE_GEOMETRY_ROOT_NODE_CHILDREN
	mesh.cell_size = nav_cell_size
	mesh.cell_height = nav_cell_size
	mesh.agent_radius = agent_radius
	mesh.agent_height = agent_height
	mesh.agent_max_climb = agent_max_climb
	mesh.agent_max_slope = agent_max_slope
	var rect: Rect2 = landing_layout.bake_rect().merge(broken_watch.bake_rect())
	mesh.filter_baking_aabb = AABB(
		Vector3(rect.position.x, bake_floor, rect.position.y),
		Vector3(rect.size.x, bake_ceiling - bake_floor, rect.size.y)
	)
	nav_region.navigation_mesh = mesh


func bake_navigation() -> void:
	var started: int = Time.get_ticks_msec()
	nav_region.bake_navigation_mesh(false)
	if NavigationServer3D.map_get_iteration_id(navigation_map()) > 0:
		NavigationServer3D.map_force_update(navigation_map())
	var elapsed: int = Time.get_ticks_msec() - started
	bake_count += 1
	_measure_navmesh()
	log_event("navigation baked", "%d polygons, %.1f m^2 walkable, %d ms (bake #%d, one continuous map)" % [
		navmesh_polygon_count, navmesh_area, elapsed, bake_count,
	])


func _measure_navmesh() -> void:
	var mesh: NavigationMesh = nav_region.navigation_mesh
	navmesh_polygon_count = mesh.get_polygon_count()
	var vertices: PackedVector3Array = mesh.get_vertices()
	var area: float = 0.0
	for i: int in navmesh_polygon_count:
		var indices: PackedInt32Array = mesh.get_polygon(i)
		for t: int in range(1, indices.size() - 1):
			var a: Vector3 = vertices[indices[0]]
			var b: Vector3 = vertices[indices[t]]
			var c: Vector3 = vertices[indices[t + 1]]
			area += absf((b.x - a.x) * (c.z - a.z) - (c.x - a.x) * (b.z - a.z)) * 0.5
	navmesh_area = area


func navigation_map() -> RID:
	return get_world_3d().navigation_map


func _await_navigation_synchronized() -> void:
	var probe: Vector3 = landing_layout.player_start()
	for frame: int in 40:
		if NavigationServer3D.map_get_iteration_id(navigation_map()) == 0:
			await get_tree().physics_frame
			continue
		var answer: Vector3 = NavigationServer3D.map_get_closest_point(navigation_map(), probe)
		if Vector2(answer.x - probe.x, answer.z - probe.z).length() < 0.35:
			log_event("navigation ready", "map answers queries after %d physics frame%s" % [
				frame, "" if frame == 1 else "s",
			])
			return
		await get_tree().physics_frame
	push_warning("BrokenWatchSlice: the navigation map did not become queryable")


# --- Production mouse targeting: per-use, never persistent ---------------------

## Fired once per Skill Use from `QuickStrikeAction._begin_attempt()` /
## `_refresh_approach_aim()`. Dispatches to mouse or controller; either path
## returns a fresh decision every call and stores nothing this function will
## read again next time.
func _resolve_quick_strike_aim() -> Dictionary:
	if _forced_aim_target_for_verification != null:
		var forced: PrototypeTargetable = _forced_aim_target_for_verification
		_forced_aim_target_for_verification = null
		return {
			"target": forced,
			"direction": _planar(forced.global_position - player.global_position),
			"reason": "forced for verification",
		}
	if input_family.family == InputFamilyTracker.Family.CONTROLLER:
		return _controller_aim_provider()
	return _mouse_aim_provider()


## Verification-only entry point (see `_forced_aim_target_for_verification`).
func force_next_aim_for_verification(target: PrototypeTargetable) -> void:
	_forced_aim_target_for_verification = target


## PRODUCTION RULE (D-193, COMBAT_IDENTITY_AND_MOMENT_TO_MOMENT.md §12/§21):
## one fresh ray pick against wherever the cursor is RIGHT NOW. No field here
## survives past this single call — there is no "current mouse target" for a
## later frame to read, so movement or a new cursor position automatically
## clears whatever this returned last time simply by not being asked again.
func _mouse_aim_provider() -> Dictionary:
	var cursor: Dictionary = ground_point_under_cursor()
	var camera: Camera3D = camera_rig.camera
	var screen: Vector2 = get_viewport().get_mouse_position()
	var from: Vector3 = camera.project_ray_origin(screen)
	var direction: Vector3 = camera.project_ray_normal(screen)
	var picked: PrototypeTargetable = acquisition.fixture_under_ray(from, direction)
	if picked != null:
		return {"target": picked, "direction": (picked.global_position - player.global_position), "reason": "cursor over %s" % picked.target_display_name()}
	var aim: Vector3 = player.facing_direction()
	if bool(cursor.get("valid", false)):
		aim = _planar(Vector3(cursor["point"]) - player.global_position)
	return {"target": null, "direction": aim, "reason": "directional swing toward the cursor"}


## D-178 controller soft targeting, reused exactly as Prototype Zero's own
## `_controller_aim()` does — including its brief, bounded retention. The
## retained `previous` field is kept LOCAL to this room, not shared with the
## mouse path above.
func _controller_aim_provider() -> Dictionary:
	var raw: Vector2 = PrototypeLocomotion.read_stick_actions()
	var intended: Vector3 = player.facing_direction()
	if raw.length() > player.stick_deadzone:
		var planar: Vector3 = camera_rig.ground_right() * raw.x + camera_rig.ground_forward() * -raw.y
		if planar.length() > 0.0001:
			intended = planar.normalized()
	var previous: PrototypeTargetable = _soft_target if _soft_target_retention_remaining() > 0.0 else null
	var outcome: Dictionary = acquisition.soft_target(
		player.global_position, intended, _target_candidates(), player.attack.data, previous
	)
	_set_soft_target(outcome["target"] as PrototypeTargetable)
	return {"target": outcome["target"], "direction": intended, "reason": String(outcome["reason"])}


func _set_soft_target(target: PrototypeTargetable) -> void:
	if target == _soft_target:
		return
	if _soft_target != null:
		_soft_target.set_soft_targeted(false)
	_soft_target = target
	_soft_target_since_msec = Time.get_ticks_msec()
	if _soft_target != null:
		_soft_target.set_soft_targeted(true)


func _soft_target_retention_remaining() -> float:
	if _soft_target == null:
		return 0.0
	var elapsed: float = float(Time.get_ticks_msec() - _soft_target_since_msec) / 1000.0
	return maxf(player.attack.data.soft_target_retention - elapsed, 0.0)


func _target_candidates() -> Array[PrototypeTargetable]:
	var found: Array[PrototypeTargetable] = []
	for enemy: PrototypeGraveblade in graveblades:
		var area: PrototypeTargetable = enemy.get_node_or_null("TargetArea") as PrototypeTargetable
		if area != null:
			found.append(area)
	return found


## Purely presentational, and structurally separate from the aim provider
## above: hovering an enemy shows its name and Life on the HUD and NOTHING
## else. It never writes into `_soft_target`, never influences
## `_resolve_quick_strike_aim()`, and is skipped entirely for the controller
## (which has no cursor).
func _update_hover_info() -> void:
	if input_family.family == InputFamilyTracker.Family.CONTROLLER:
		hud.show_hover(null)
		return
	var camera: Camera3D = camera_rig.camera
	var screen: Vector2 = get_viewport().get_mouse_position()
	var from: Vector3 = camera.project_ray_origin(screen)
	var direction: Vector3 = camera.project_ray_normal(screen)
	var hovered: PrototypeTargetable = acquisition.fixture_under_ray(from, direction)
	var enemy: PrototypeGraveblade = null
	if hovered != null:
		var actor: Node = hovered.combat_actor()
		enemy = actor as PrototypeGraveblade
	hud.show_hover(enemy)


func _log_combat_event(kind: String, detail: String) -> void:
	log_event(kind, detail)


# --- Guaranteed drop, comparison, equip -----------------------------------

func _on_first_graveblade_died(event: DamageEvent, enemy: PrototypeGraveblade) -> void:
	if _rewarded_enemies.has(enemy.get_instance_id()):
		log_event("reward refused", "duplicate kill signal from an already-rewarded enemy")
		return
	_rewarded_enemies[enemy.get_instance_id()] = true
	if _drop_granted:
		log_event("reward refused", "the guaranteed drop was already granted")
		return
	_drop_granted = true
	_place_drop(event.target.global_position if event.target != null else broken_watch.first_encounter_spawn())


func _place_drop(near: Vector3) -> void:
	var watchsteel: PrototypeWeaponData = load(WATCHSTEEL_SWORD_PATH) as PrototypeWeaponData
	var drop: FirstMvpItemDrop = (load(ITEM_DROP_SCRIPT) as GDScript).new()
	drop.name = "GuaranteedDrop"
	drop.weapon = watchsteel
	drop.interaction_range = ITEM_INTERACTION_RANGE
	$Actors.add_child(drop)
	var resolved: Dictionary = PrototypeGroundPointer.resolve_to_navigation(navigation_map(), near)
	drop.global_position = Vector3(resolved["point"].x, 0.0, resolved["point"].z)
	_active_drop = drop
	log_event("guaranteed drop", "%s placed near the fallen Graveblade" % watchsteel.display_name)


## The one funnel into the item comparison: the nameplate's click and the
## controller's interact both arrive here. It refuses a character that is not
## alive (First-MVP UI J4, decision D-328), asking `player.is_alive()` and
## nothing else, so a press that reaches the nameplate on the lethal frame —
## before `_update_drop_nameplate()` has run again to hide it — opens nothing.
func open_item_comparison(reason: String) -> void:
	if _active_drop == null:
		return
	if item_comparison.is_open or fallen_overlay.is_open:
		return
	if not player.is_alive():
		return
	log_event("item comparison opened", reason)
	item_comparison.open_for(_active_drop)


func on_weapon_equipped(drop: FirstMvpItemDrop) -> void:
	player.equip_weapon(loadout.equipped_weapon)
	hud.show_message("Equipped %s" % loadout.equipped_weapon.display_name)
	if drop == _active_drop:
		_active_drop.queue_free()
		_active_drop = null


func _on_weapon_changed(record: PrototypeWeaponData) -> void:
	log_event("weapon equipped", record.display_name)


## The controller's route to the comparison. A character that is not alive is
## refused before the range is measured or a message is written (J4, D-328).
func _try_interact_with_drop() -> void:
	if _active_drop == null:
		return
	if item_comparison.is_open or fallen_overlay.is_open:
		return
	if not player.is_alive():
		return
	if not _active_drop.player_is_in_range(player.global_position):
		hud.show_message("Walk closer to inspect it")
		return
	open_item_comparison("controller interact")


func _build_nameplate() -> void:
	_nameplate = Button.new()
	_nameplate.name = "GroundNameplate"
	_nameplate.focus_mode = Control.FOCUS_NONE
	_nameplate.visible = false
	_nameplate.pressed.connect(func() -> void: open_item_comparison("nameplate clicked"))
	$CanvasLayer.add_child(_nameplate)


## While the character is not alive the nameplate is hidden and the prompt
## cleared (J4, D-328). That takes effect from the first process update after
## the lethal frame; a press before it is refused by `open_item_comparison()`.
func _update_drop_nameplate() -> void:
	if _active_drop == null or _nameplate == null:
		if _nameplate != null:
			_nameplate.visible = false
		hud.show_item_prompt("")
		return
	if not player.is_alive():
		_nameplate.visible = false
		hud.show_item_prompt("")
		_active_drop.set_soft_targeted(false)
		return
	var camera: Camera3D = camera_rig.camera
	var anchor: Vector3 = _active_drop.label_anchor()
	if camera.is_position_behind(anchor) or item_comparison.is_open or fallen_overlay.is_open:
		_nameplate.visible = false
		hud.show_item_prompt("")
		return
	var screen: Vector2 = camera.unproject_position(anchor)
	_nameplate.text = _active_drop.display_name()
	_nameplate.position = screen - Vector2(60, 28)
	_nameplate.size = Vector2(120, 28)
	_nameplate.visible = true
	var controller: bool = input_family.family == InputFamilyTracker.Family.CONTROLLER
	if controller:
		hud.show_item_prompt("%s — %s" % [
			_active_drop.display_name(),
			"(A) Inspect" if _active_drop.player_is_in_range(player.global_position) else "walk closer",
		])
	else:
		hud.show_item_prompt("%s — Left click" % _active_drop.display_name())
	_active_drop.set_soft_targeted(controller and _active_drop.player_is_in_range(player.global_position))


# --- Fallen and restart ---------------------------------------------------

func _on_player_fell(event: DamageEvent) -> void:
	for enemy: PrototypeGraveblade in graveblades:
		enemy.set_ai_enabled(false)
	attack_coordinator.revoke_all("player fallen")
	_pending_fallen_event = event
	_fallen_countdown = FALLEN_DELAY


func _tick_fallen_delay(delta: float) -> void:
	if _fallen_countdown < 0.0:
		return
	_fallen_countdown -= delta
	if _fallen_countdown <= 0.0:
		_fallen_countdown = -1.0
		fallen_overlay.open_for(_pending_fallen_event)


## §12: the already-proven minimal Fallen/Restart behavior. Returns the
## bounded slice to a valid deterministic state — both Graveblades restored,
## the player revived at the entry — WITHOUT re-granting the guaranteed drop
## (the `_drop_granted` latch is untouched) and WITHOUT any disk write (this
## scene never constructs a settings or lab-state store).
##
## A restart also cancels a Fallen presentation that is armed but not yet open
## (First-MVP UI J3, decision D-326). F5 inside the FALLEN_DELAY window used to
## revive the player and leave the countdown and its killing event armed, so
## the overlay then opened over a living, full-Life character. Both are cleared
## here BEFORE the revival, so nothing of the old death is still waiting once
## the character is alive. An overlay that is already open is not touched here;
## it closes itself before it calls this.
func restart_current_slice(reason: String) -> void:
	log_event("slice restarted", reason)
	_fallen_countdown = -1.0
	_pending_fallen_event = null
	player.revive_for_testing()
	player.global_position = broken_watch.entry()
	# First-MVP Gameplay J10 (decision D-340): the revival keeps the old destination,
	# locomotion and attack, so the one neutralization authority ends them at the entry.
	player.clear_movement_intent(reason, false)
	player.face_instantly(route_forward())
	for enemy: PrototypeGraveblade in graveblades:
		enemy.set_ai_enabled(true)
		enemy.reset_encounter()
	attack_coordinator.reset()
	_soft_target = null
	marker.hide_destination()


# --- Modal contract (FirstMvpModal) -----------------------------------------

func neutralize_for_modal(reason: String) -> void:
	player.clear_movement_intent(reason)


func restore_after_modal(_reason: String) -> void:
	pass


# --- Input -------------------------------------------------------------------

func _input(event: InputEvent) -> void:
	input_family.observe(event)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"move_point"):
		if _pointer_over_ui():
			log_event("movement command rejected", "pointer over interface, no world command issued")
			return
		_mouse_hold.press()
		_issue_move_command()
		return
	if event.is_action_released(&"move_point"):
		_mouse_hold.release()
		return
	if event.is_action_pressed(&"quick_strike"):
		if _pointer_over_ui():
			log_event("quick strike rejected", "pointer over interface, no attack issued")
			return
		if player.awaiting_neutral:
			log_event("quick strike rejected", "awaiting neutral input after an interruption")
			return
		# Specification §9.5: the attack is now the newest intent, so an older
		# HELD movement control is suspended rather than left free to cancel
		# the wind-up on the next frame; the held click stops re-issuing so it
		# cannot do the same.
		player.suspend_held_movement_for_attack()
		_mouse_hold.release()
		player.attack.press()
		return
	if event.is_action_released(&"quick_strike"):
		player.attack.release_input()
		return
	if event.is_action_pressed(&"attack_in_place"):
		player.attack.set_attack_in_place(true)
	elif event.is_action_released(&"attack_in_place"):
		player.attack.set_attack_in_place(false)
	if event.is_action_pressed(&"interact"):
		_try_interact_with_drop()
		return
	if event.is_action_pressed(&"quick_restart"):
		restart_current_slice("quick restart")
		return
	_handle_review_keys(event)


func _handle_review_keys(event: InputEvent) -> void:
	var key: InputEventKey = event as InputEventKey
	if key == null or not key.pressed or key.echo:
		return
	match key.physical_keycode:
		KEY_F6:
			set_grid_visible(not grid_visible)
		KEY_BRACKETLEFT:
			camera_rig.adjust_distance(-camera_distance_step)
		KEY_BRACKETRIGHT:
			camera_rig.adjust_distance(camera_distance_step)
		KEY_BACKSLASH:
			camera_rig.reset_calibration()


func set_grid_visible(value: bool) -> void:
	grid_visible = value
	landing_layout.set_grid_visible(value)
	broken_watch.set_grid_visible(value)
	log_event("review grid", "visible=%s" % str(value))


func _pointer_over_ui() -> bool:
	return get_viewport().gui_get_hovered_control() != null


func _process(delta: float) -> void:
	player.set_ground_basis(camera_rig.ground_forward(), camera_rig.ground_right())
	if _mouse_hold.should_reissue(delta, Input.is_action_pressed(&"move_point")):
		if not _pointer_over_ui():
			_issue_move_command()
	_update_neutral_latch()
	_update_hover_info()
	_update_drop_nameplate()
	_tick_fallen_delay(delta)
	_check_exit(player.global_position)


func _physics_process(_delta: float) -> void:
	player.set_stick_raw(PrototypeLocomotion.read_stick_actions())


func _update_neutral_latch() -> void:
	if not player.awaiting_neutral:
		return
	if get_tree().paused:
		return
	if Input.is_action_pressed(&"move_point") or Input.is_action_pressed(&"quick_strike"):
		return
	if PrototypeLocomotion.read_stick_actions().length() > player.stick_deadzone:
		return
	player.release_neutral_latch()


func _issue_move_command() -> void:
	var cursor: Dictionary = ground_point_under_cursor()
	if not bool(cursor.get("valid", false)):
		log_event("movement command rejected", "no ground under the cursor")
		return
	var requested: Vector3 = cursor["point"]
	var resolution: Dictionary = PrototypeGroundPointer.resolve_to_navigation(navigation_map(), requested)
	player.command_move_to(resolution["point"], requested, bool(resolution["adjusted"]))


func ground_point_under_cursor() -> Dictionary:
	var screen: Vector2 = get_viewport().get_mouse_position()
	return PrototypeGroundPointer.ground_point(camera_rig.camera, get_world_3d(), screen, WORLD_MASK)


func _on_movement_command_resolved(status: String, requested: Vector3, resolved: Vector3) -> void:
	if status.begins_with("rejected"):
		log_event("movement command rejected", status)
		return
	marker.show_destination(resolved, requested, status == "adjusted")


func _on_arrived(_point: Vector3) -> void:
	marker.hide_destination()


func _on_intent_cleared(_reason: String) -> void:
	marker.hide_destination()


func _on_family_changed(_family: InputFamilyTracker.Family, _reason: String) -> void:
	pass


func _check_exit(position: Vector3) -> void:
	if slice_complete:
		return
	if position.distance_to(broken_watch.exit_to_nexus_threshold()) <= EXIT_REACHED_METRES:
		slice_complete = true
		hud.show_message("Broken Watch complete — the route continues toward the Nexus Threshold")
		log_event("slice complete", "ExitToNexusThreshold reached; nothing loads, opens, or is stored")


func _planar(v: Vector3) -> Vector3:
	return Vector3(v.x, 0.0, v.z)


# --- Measurement -------------------------------------------------------------

func measurements() -> Dictionary:
	return {
		"landing_footprint": landing_layout.footprint_area(),
		"broken_watch_footprint": broken_watch.footprint_area(),
		"broken_watch_rooms": broken_watch.room_count(),
		"navmesh_polygons": navmesh_polygon_count,
		"navmesh_area": navmesh_area,
		"bake_count": bake_count,
		"player_life": player.life,
		"player_max_life": player.max_life,
		"player_mana": player.mana,
		"player_max_mana": player.max_mana,
		"equipped_weapon_id": String(loadout.equipped_weapon.weapon_id) if loadout.equipped_weapon != null else "",
		"owned_item_count": loadout.owned_items.size(),
		"drop_granted": _drop_granted,
		"slice_complete": slice_complete,
		"sockets": broken_watch.socket_positions(),
	}


func log_event(kind: String, detail: String) -> void:
	var line: String = "[broken-watch] %-24s %s" % [kind, detail]
	log_lines.append(line)
	print(line)
