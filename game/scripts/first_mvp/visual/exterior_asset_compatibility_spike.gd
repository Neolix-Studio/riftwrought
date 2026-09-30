class_name ExteriorAssetCompatibilitySpike
extends Node3D
## First-MVP Gate 1B — the Exterior Asset Compatibility Spike root.
##
## A temporary, developer-only, non-canonical scene, authorized by D-198 and
## specified by
## `design/FIRST_MVP_GATE_1B_EXTERIOR_ASSET_COMPATIBILITY_SPIKE_SPECIFICATION.md`.
## It answers one question and no other:
##
##   Can the registered KayKit Forest Nature and Halloween Bits candidates form a
##   coherent dark exterior around the real Riftwrought Knight and Dungeon Pack,
##   and can k0rveen's LowPoly Environment Pack fill terrain/background gaps
##   without becoming a competing foreground style?
##
## THIS IS NOT RIFTFALL LANDING. It is not the Severed Threshold, not Broken
## Watch, not the Nexus Threshold, not campaign content, and not a Bastion room.
## There is no combat, no Quick Strike, no target acquisition, no enemy, no
## damage, no Life or Mana, no loot, no XP, no Passive, no inventory, no story,
## no Mara, no Nexus, no procedural generation, no HUD, and no save or settings
## file. Specification §8 requires that this spike "should have no storage path
## at all", and it has none: it opens no engine user-data path, constructs no
## configuration store, saves no resource, and makes no filesystem call at all.
##
## That sentence deliberately avoids NAMING those APIs. Both this project's Gate
## 1A suite and Gate 1B's own scan these files RAW — comments included — for the
## literal strings, and a raw scan is stronger than a comment-stripped one
## precisely because it cannot be talked around. A file that spells out the
## breach in prose fails its own check, which is the correct behaviour for a scan
## of that shape and the reason the prose above is worded as it is.
##
## WHAT IT REUSES RATHER THAN CLONING. The locomotion contract is the accepted
## Prototype Zero one, through the shared components extracted under D-195 —
## `PrototypeLocomotion`, `PrototypeGroundPointer`, `PrototypeMouseHold` — plus
## `PrototypeCameraRig`, `DestinationMarker`, and `InputFamilyTracker`. The player
## body is the Gate 1A `calibration_hall_player.tscn` REUSED UNCHANGED rather
## than copied: specification §2 forbids a second locomotion implementation, and
## a third wrapper around the same kernel would be exactly that. Not one byte of
## Gate 1A, Prototype Zero, the project entrypoint, or the InputMap is edited.
##
## NO NEW INPUT ACTION IS DECLARED. §6 asks for "physical-key developer toggles
## without adding InputMap actions", so every review toggle below is read as a
## PHYSICAL KEY. The only InputMap actions this scene consumes are the accepted
## movement ones — `move_point` and `move_vector_*` — and the three combat
## actions it refuses by name. That matters beyond tidiness: the Gate B, E, and F
## suites each walk `InputMap.get_actions()` and emit one assertion per key event,
## so declaring an action here would move three locked Prototype Zero counts
## without a single old assertion having become false.

const PLAYER_SCENE: String = "res://scenes/first_mvp/calibration/calibration_hall_player.tscn"
const VERIFICATION_SCRIPT: String = "res://tests/gate_1b_exterior_asset_spike_verification.gd"
const WORLD_MASK: int = 1

## D-175's accepted values, reproduced here so the spike measures the ASSETS
## against the accepted relationship rather than against a second opinion about
## it. §5.4 requires every one of them to be preserved, and the verification
## asserts each against the camera rig and player it actually built.
const ACCEPTED_WORLD_UNIT_METRES: float = 1.0
const ACCEPTED_P_METRES: float = 0.80
const ACCEPTED_CAMERA_DISTANCE: float = 19.0
const ACCEPTED_CAMERA_PITCH: float = 55.0
const ACCEPTED_CAMERA_FOV: float = 45.0
const ACCEPTED_MAX_SPEED: float = 5.0

@export_group("Navigation bake, metres")
@export var agent_radius: float = 0.40
@export var agent_height: float = 1.80
@export var agent_max_climb: float = 0.20
@export var agent_max_slope: float = 20.0
## The project's navigation defaults, and NOT a value to raise for bake speed on
## a large ground.
##
## MEASURED DEFECT, and the fix for it. This was first set to 0.25 to keep the
## bake quick over 124 x 148 m, and the character then refused to move at all:
## every click was accepted, a full path was produced, and the body oscillated
## between two positions 8 mm apart forever. The cause was the CELL HEIGHT. Recast
## places the baked surface on a voxel boundary, so a 0.25 m cell height lifted
## every path point to y = 0.500 while the character stands at y = 0.000 — and
## `NavigationAgent3D` measures its 0.40 m `path_desired_distance` in three
## dimensions, so the agent could never reach its own first path point and never
## advanced past it. At the project's 0.15 the same query answers within the
## agent's tolerance and the path advances normally. The verification asserts the
## measured height of the baked surface for exactly this reason.
@export var nav_cell_size: float = 0.15

@export_group("Review controls")
## The one control beyond specification §6's six. It exists for a stated reason:
## a k0rveen terrain slab is 20 m across and its mountain is 15.7 m, and the
## accepted 19 m camera frames about 28 x 21 m of ground, so without a distance
## control the largest candidates cannot be seen whole at all. The DEFAULT is
## always the accepted 19 m and `\` returns to it; nothing accepted is changed.
@export var camera_distance_step: float = 2.0

var layout: ExteriorSpikeLayout
var nav_region: NavigationRegion3D
var player: CalibrationHallPlayer
var camera_rig: PrototypeCameraRig
var marker: DestinationMarker
var input_family: InputFamilyTracker
var lighting: ExteriorReviewLighting
var treatment: ExteriorReviewTreatment
var overlay: Node

var navmesh_polygon_count: int = 0
var navmesh_area: float = 0.0
var last_bake_msec: int = 0

# --- Instrumentation ----------------------------------------------------------
var log_lines: PackedStringArray = PackedStringArray()
var accepted_commands: int = 0
var adjusted_commands: int = 0
var rejected_commands: int = 0
var ui_clicks_absorbed: int = 0
## Every combat or interaction input this scene deliberately refused. §2: no
## combat. A counter makes that a measured fact rather than a promise.
var refused_action_inputs: int = 0
var overlay_visible: bool = true
## How many times the review toggles have been used this session, so the
## verification can prove a toggle really ran rather than that a flag was set.
var review_toggle_count: int = 0

var _mouse_hold: PrototypeMouseHold = PrototypeMouseHold.new()
var _stick_override_active: bool = false
var _stick_override: Vector2 = Vector2.ZERO
var _cursor_override: Variant = null


func _ready() -> void:
	nav_region = $NavigationRegion3D
	layout = $NavigationRegion3D/Layout
	camera_rig = $CameraRig
	marker = $DestinationMarker
	input_family = $InputFamilyTracker
	lighting = $ReviewLighting
	overlay = $CanvasLayer/ExteriorSpikeOverlay

	treatment = ExteriorReviewTreatment.new()
	lighting.configure($WorldEnvironment, $KeyLight)
	layout.build(treatment, lighting)
	# Neutral source review is the launch state on purpose: §6.1's job is to
	# reveal mismatch, and a spike that opened in its own flattering treatment
	# would be answering a different question.
	lighting.set_mode(ExteriorReviewLighting.Mode.NEUTRAL)
	treatment.set_candidate(false)

	_configure_navigation()
	bake_navigation()
	_spawn_player()
	camera_rig.set_target(player)
	camera_rig.distance_metres = ACCEPTED_CAMERA_DISTANCE
	camera_rig.pitch_degrees = ACCEPTED_CAMERA_PITCH
	camera_rig.fov_degrees = ACCEPTED_CAMERA_FOV
	camera_rig.reset_calibration()

	input_family.family_changed.connect(_on_family_changed)
	overlay.call("bind", self)

	log_event("gate 1B spike", "temporary exterior asset compatibility spike; nothing here is canonical")
	log_event("not riftfall landing", "no route, combat, reward, story, Mara, Nexus, progression, or save")
	log_event("credit", ExteriorAssetCatalogue.K0RVEEN_CREDIT)
	log_event("candidates placed", "%d instances of %d catalogued models" % [
		layout.placed.size(), ExteriorAssetCatalogue.manifest().size(),
	])
	log_event("court clear ground", "%.1f%% of the %.0f x %.0f m court is free of decoration" % [
		layout.court_clear_fraction() * 100.0,
		layout.court_rect().size.x, layout.court_rect().size.y,
	])
	log_event("dungeon doorway", "%.3f m measured between the registered wall_pillar faces" % (
		layout.dungeon_doorway_metres()
	))
	log_event("arch opening", "%.3f m measured between the Halloween arch's leg faces" % (
		layout.arch_opening_metres()
	))

	await _await_navigation_synchronized()
	_maybe_start_verification()


func _maybe_start_verification() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if not arguments.has("--verify-1b"):
		return
	var script: GDScript = load(VERIFICATION_SCRIPT) as GDScript
	var runner: Node = Node.new()
	runner.name = "Gate1BVerification"
	runner.set_script(script)
	runner.set("spike", self)
	runner.set("arguments", arguments)
	add_child(runner)


# --- Construction -------------------------------------------------------------

## The Gate 1A player scene, reused unchanged. Its class is still named
## `CalibrationHallPlayer` and its documentation still names the Scale
## Calibration Hall, because D-198 does not authorize editing a closed gate's
## files — not even its comments. What it actually is, is a locomotion-only body
## over the one shared kernel, which is exactly what this spike needs.
func _spawn_player() -> void:
	player = (load(PLAYER_SCENE) as PackedScene).instantiate() as CalibrationHallPlayer
	player.name = "Player"
	player.max_speed = ACCEPTED_MAX_SPEED
	player.position = layout.player_spawn()
	$Actors.add_child(player)
	player.movement_command_resolved.connect(_on_movement_command_resolved)
	player.arrived_at_destination.connect(_on_arrived)
	player.movement_intent_cleared.connect(_on_intent_cleared)


# --- Navigation ---------------------------------------------------------------

func _configure_navigation() -> void:
	var mesh: NavigationMesh = NavigationMesh.new()
	# Baked from the spike's own collision boxes, not from the decorative candidate
	# meshes, so the walkable surface can never disagree with what the character
	# actually collides against — and so a k0rveen terrain slab cannot quietly
	# become navigable production terrain, which §5.3 forbids.
	mesh.geometry_parsed_geometry_type = NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS
	mesh.geometry_collision_mask = WORLD_MASK
	mesh.geometry_source_geometry_mode = NavigationMesh.SOURCE_GEOMETRY_ROOT_NODE_CHILDREN
	mesh.cell_size = nav_cell_size
	mesh.cell_height = nav_cell_size
	mesh.agent_radius = agent_radius
	mesh.agent_height = agent_height
	mesh.agent_max_climb = agent_max_climb
	mesh.agent_max_slope = agent_max_slope
	# Clipped to the first 1.2 m above the ground, exactly as the Gate 1A hall
	# clips its own bake: it removes every tall obstacle's TOP from the bake so
	# nothing above head height can rasterise as a walkable ledge.
	var rect: Rect2 = layout.ground_rect()
	mesh.filter_baking_aabb = AABB(
		Vector3(rect.position.x - 2.0, -1.0, rect.position.y - 2.0),
		Vector3(rect.size.x + 4.0, 2.2, rect.size.y + 4.0)
	)
	nav_region.navigation_mesh = mesh


func bake_navigation() -> void:
	var started: int = Time.get_ticks_msec()
	nav_region.bake_navigation_mesh(false)
	if NavigationServer3D.map_get_iteration_id(navigation_map()) > 0:
		NavigationServer3D.map_force_update(navigation_map())
	last_bake_msec = Time.get_ticks_msec() - started
	_measure_navmesh()
	log_event("navigation baked", "%d polygons, %.1f m^2 walkable, %d ms" % [
		navmesh_polygon_count, navmesh_area, last_bake_msec,
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


## The navigation map is not QUERYABLE until the server has synchronized it at
## least once. The readiness test is a real query with a known answer rather than
## a counter: the player spawn must come back as itself.
func _await_navigation_synchronized() -> void:
	var probe: Vector3 = layout.player_spawn()
	for frame: int in 30:
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
	push_warning("ExteriorAssetCompatibilitySpike: the navigation map did not become queryable")


func point_is_navigable(point: Vector3, tolerance: float = 0.35) -> bool:
	var flat: Vector3 = Vector3(point.x, 0.0, point.z)
	var answer: Vector3 = NavigationServer3D.map_get_closest_point(navigation_map(), flat)
	return Vector2(answer.x - flat.x, answer.z - flat.z).length() <= tolerance


# --- Input --------------------------------------------------------------------

func _input(event: InputEvent) -> void:
	input_family.observe(event)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"move_point"):
		if _pointer_over_ui():
			ui_clicks_absorbed += 1
			log_event("movement command rejected", "pointer over interface, no world command issued")
			return
		_mouse_hold.press()
		_issue_move_command()
		return
	if event.is_action_released(&"move_point"):
		_mouse_hold.release()
		return
	# §2: no combat. The combat actions are refused HERE, by name, and counted,
	# rather than being silently unbound somewhere else.
	for refused: StringName in [&"quick_strike", &"attack_in_place", &"interact"]:
		if event.is_action_pressed(refused):
			refused_action_inputs += 1
			log_event("input refused", "'%s' has no action in the exterior spike" % refused)
			return
	_handle_review_keys(event)


## Specification §6's review toggles, all read as PHYSICAL KEYS so no InputMap
## action is added. F1, F2, F4, F6, F3, and `\` are the six §6 asks for; `[` and
## `]` are the one documented addition, explained on `camera_distance_step`.
func _handle_review_keys(event: InputEvent) -> void:
	var key: InputEventKey = event as InputEventKey
	if key == null or not key.pressed or key.echo:
		return
	match key.physical_keycode:
		KEY_F1:
			set_lighting_candidate(lighting.mode == ExteriorReviewLighting.Mode.NEUTRAL)
		KEY_F2:
			set_candidate_materials(not treatment.candidate_active())
		KEY_F4:
			set_k0rveen_visible(not layout.k0rveen_visible)
		KEY_F6:
			layout.set_grid_visible(not layout.grid_visible)
			review_toggle_count += 1
			log_event("scale grid", "visible=%s" % str(layout.grid_visible))
		KEY_F3:
			set_overlay_visible(not overlay_visible)
		KEY_BRACKETLEFT:
			camera_rig.adjust_distance(-camera_distance_step)
			_log_camera()
		KEY_BRACKETRIGHT:
			camera_rig.adjust_distance(camera_distance_step)
			_log_camera()
		KEY_BACKSLASH:
			reset_review()


func set_lighting_candidate(active: bool) -> void:
	lighting.set_mode(
		ExteriorReviewLighting.Mode.CANDIDATE if active else ExteriorReviewLighting.Mode.NEUTRAL
	)
	review_toggle_count += 1
	log_event("review lighting", lighting.mode_name())


func set_candidate_materials(active: bool) -> void:
	treatment.set_candidate(active)
	review_toggle_count += 1
	log_event("review materials", "%s (%d surfaces)" % [
		"candidate treatment" if active else "imported source materials",
		treatment.surface_count(),
	])


func set_k0rveen_visible(value: bool) -> void:
	layout.set_k0rveen_visible(value)
	review_toggle_count += 1
	# Hiding removes their collision as well, so the walkable surface is rebaked
	# to match: an invisible obstruction would be a worse answer than either
	# state, and a navigation hole under nothing would be another.
	bake_navigation()
	log_event("k0rveen candidates", "visible=%s; navigation rebaked" % str(value))


## §6: "reset all review modes and player position". Everything a session can
## change goes back to the launch state, and nothing was ever written to disk to
## go back to.
func reset_review() -> void:
	lighting.set_mode(ExteriorReviewLighting.Mode.NEUTRAL)
	treatment.set_candidate(false)
	if not layout.k0rveen_visible:
		set_k0rveen_visible(true)
	layout.set_grid_visible(false)
	set_overlay_visible(true)
	camera_rig.reset_calibration()
	player.clear_movement_intent("review reset", false)
	player.global_position = layout.player_spawn()
	player.velocity = Vector3.ZERO
	marker.hide_destination()
	review_toggle_count += 1
	log_event("review reset", "lighting, materials, k0rveen, grid, camera, and player position")


func review_is_launch_state() -> bool:
	return (
		lighting.mode == ExteriorReviewLighting.Mode.NEUTRAL
		and not treatment.candidate_active()
		and layout.k0rveen_visible
		and not layout.grid_visible
		and overlay_visible
		and camera_rig.is_default()
	)


func set_overlay_visible(value: bool) -> void:
	overlay_visible = value
	(overlay as CanvasItem).visible = value
	review_toggle_count += 1
	log_event("review overlay", "visible=%s" % str(value))


func _log_camera() -> void:
	log_event("camera", "distance %.1f m (accepted default %.1f m), pitch %.1f deg, fov %.1f deg" % [
		camera_rig.distance_metres, ACCEPTED_CAMERA_DISTANCE,
		camera_rig.pitch_degrees, camera_rig.fov_degrees,
	])


func _pointer_over_ui() -> bool:
	return get_viewport().gui_get_hovered_control() != null


func _process(delta: float) -> void:
	if player == null:
		return
	player.set_ground_basis(camera_rig.ground_forward(), camera_rig.ground_right())
	if _mouse_hold.should_reissue(delta, Input.is_action_pressed(&"move_point")):
		if _pointer_over_ui():
			ui_clicks_absorbed += 1
		else:
			_issue_move_command()
	_update_neutral_latch()


func _physics_process(_delta: float) -> void:
	if player == null:
		return
	player.set_stick_raw(read_stick_raw())


func read_stick_raw() -> Vector2:
	if _stick_override_active:
		return _stick_override
	return PrototypeLocomotion.read_stick_actions()


func set_stick_override(raw: Variant) -> void:
	if raw == null:
		_stick_override_active = false
		_stick_override = Vector2.ZERO
		return
	_stick_override_active = true
	_stick_override = raw


func set_cursor_override(screen: Variant) -> void:
	_cursor_override = screen


func _update_neutral_latch() -> void:
	if not player.awaiting_neutral:
		return
	if Input.is_action_pressed(&"move_point"):
		return
	if read_stick_raw().length() > player.stick_deadzone:
		return
	player.release_neutral_latch()
	log_event("input neutral", "held movement controls returned to neutral; input accepted again")


# --- Movement commands --------------------------------------------------------

func _issue_move_command() -> void:
	var cursor: Dictionary = ground_point_under_cursor(_cursor_override)
	if not bool(cursor.get("valid", false)):
		rejected_commands += 1
		log_event("movement command rejected", "no ground under the cursor")
		return
	var requested: Vector3 = cursor["point"]
	var resolution: Dictionary = resolve_to_navigation(requested)
	player.command_move_to(resolution["point"], requested, bool(resolution["adjusted"]))


func ground_point_under_cursor(at_screen: Variant = null) -> Dictionary:
	var screen: Vector2 = at_screen if at_screen != null else get_viewport().get_mouse_position()
	return PrototypeGroundPointer.ground_point(
		camera_rig.camera, get_world_3d(), screen, WORLD_MASK
	)


func resolve_to_navigation(requested: Vector3) -> Dictionary:
	return PrototypeGroundPointer.resolve_to_navigation(navigation_map(), requested)


func _on_movement_command_resolved(status: String, requested: Vector3, resolved: Vector3) -> void:
	if status.begins_with("rejected"):
		rejected_commands += 1
		log_event("movement command rejected", status)
		return
	if status == "adjusted":
		adjusted_commands += 1
		log_event("movement command adjusted",
			"clicked (%.2f, %.2f) is not walkable; nearest navigable point (%.2f, %.2f)" % [
				requested.x, requested.z, resolved.x, resolved.z,
			])
	else:
		accepted_commands += 1
		log_event("movement command accepted", "destination (%.2f, %.2f)" % [resolved.x, resolved.z])
	marker.show_destination(resolved, requested, status == "adjusted")


func _on_arrived(point: Vector3) -> void:
	marker.hide_destination()
	log_event("arrived", "at (%.2f, %.2f)" % [point.x, point.z])


func _on_intent_cleared(reason: String) -> void:
	marker.hide_destination()
	log_event("movement intent cleared", reason)


func _on_family_changed(_family: InputFamilyTracker.Family, reason: String) -> void:
	log_event("input family", "%s (%s)" % [input_family.family_label(), reason])


# --- Measurement, for the overlay and the verification ------------------------

## Everything the §7 measurement table needs, measured from the built scene or
## from the authoritative catalogue. Nothing here is a hand-typed expectation,
## and nothing here is a visual judgement: §7's "foreground, background-only, or
## reject" column is deliberately absent, because §9 reserves it for the owner.
func measurements() -> Dictionary:
	var footprint: Dictionary = camera_footprint()
	return {
		"world_unit_metres": ACCEPTED_WORLD_UNIT_METRES,
		"player_unit_metres": ACCEPTED_P_METRES,
		"camera_distance": camera_rig.distance_metres,
		"camera_distance_default": ACCEPTED_CAMERA_DISTANCE,
		"camera_pitch": camera_rig.pitch_degrees,
		"camera_fov": camera_rig.fov_degrees,
		"camera_yaw": camera_rig.yaw_degrees,
		"max_speed": player.max_speed,
		"player_diameter": player.collision_diameter(),
		"player_height": player.collision_height(),
		"cf_metres": Vector2(float(footprint["focus_width"]), float(footprint["depth"])),
		"reference_aspect": float(footprint["reference_aspect"]),
		"live_aspect": float(footprint["live_aspect"]),
		"ground_metres": layout.ground_rect().size,
		"court_metres": layout.court_rect().size,
		"court_clear_fraction": layout.court_clear_fraction(),
		"dungeon_doorway": layout.dungeon_doorway_metres(),
		"arch_opening": layout.arch_opening_metres(),
		"candidates": candidate_measurements(),
		"lighting_mode": lighting.mode_name(),
		"materials_candidate": treatment.candidate_active(),
		"treated_surfaces": treatment.surface_count(),
		"k0rveen_visible": layout.k0rveen_visible,
		"grid_visible": layout.grid_visible,
		"player_position": player.global_position,
		"movement_mode": player.movement_mode_name(),
		"input_family": input_family.family_label(),
		"navmesh_polygons": navmesh_polygon_count,
		"navmesh_area": navmesh_area,
		"bake_msec": last_bake_msec,
		"is_launch_state": review_is_launch_state(),
		"instances": layout.placed.size(),
	}


## One row per catalogued candidate, measured from the PRIMARY placed instance.
func candidate_measurements() -> Array[Dictionary]:
	var rows: Array[Dictionary] = []
	for entry: Dictionary in layout.primary_instances():
		var record: Dictionary = entry["record"]
		if String(record["family"]) == ExteriorAssetCatalogue.FAMILY_DUNGEON:
			continue
		var probe: Dictionary = entry["probe"]
		rows.append({
			"key": record["key"],
			"display": record["display"],
			"family": record["family"],
			"path": record["path"],
			"in_archive": record["in_archive"],
			"archive": record["archive"],
			"role": record["role"],
			"size": probe["size"],
			"base_offset": probe["base_offset"],
			"meshes": probe["meshes"],
			"surfaces": probe["surfaces"],
			"vertices": probe["vertices"],
			"materials": probe["materials"],
			"textures": probe["textures"],
			"untextured_surfaces": probe["untextured_surfaces"],
			"missing_normals": probe["missing_normals"],
			"double_sided": probe["double_sided"],
			"transparent": probe["transparent"],
			"casts_shadow": probe["casts_shadow"],
			"receives_light": probe["receives_light"],
			"scale": probe["scale"],
			"instances": layout.instances_of(String(record["key"])),
			"screen_fraction": ExteriorAssetProbe.screen_height_fraction(
				float(probe["size"].y), ACCEPTED_CAMERA_DISTANCE, ACCEPTED_CAMERA_FOV
			),
		})
	return rows


## The ground quad the camera actually covers, measured at the fixed reference
## aspect exactly as Gate B records CF and Gate 1A measures it. CF is a project
## unit, not a function of the window.
func camera_footprint() -> Dictionary:
	var footprint: Dictionary = camera_rig.ground_footprint(reference_aspect())
	footprint["reference_aspect"] = reference_aspect()
	footprint["live_aspect"] = live_aspect()
	return footprint


func reference_aspect() -> float:
	return (
		float(ProjectSettings.get_setting("display/window/size/viewport_width", 1920))
		/ float(ProjectSettings.get_setting("display/window/size/viewport_height", 1080))
	)


func live_aspect() -> float:
	var viewport: Vector2 = get_viewport().get_visible_rect().size
	return viewport.x / maxf(viewport.y, 1.0)


# --- Log ----------------------------------------------------------------------

func log_event(kind: String, detail: String) -> void:
	var line: String = "[gate-1b] %-28s %s" % [kind, detail]
	log_lines.append(line)
	print(line)
