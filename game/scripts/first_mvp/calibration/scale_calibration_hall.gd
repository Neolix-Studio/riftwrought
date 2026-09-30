class_name ScaleCalibrationHall
extends Node3D
## First-MVP Gate 1A — the Scale Calibration Hall root.
##
## A temporary, developer-only, non-canonical scene, authorized by D-195 and
## specified by `design/FIRST_MVP_GATE_1A_SCALE_CALIBRATION_HALL_SPECIFICATION.md`.
## It answers one question and no other:
##
##   Do the current player, camera, movement, KayKit architecture, combat lanes,
##   ranged sightlines, telegraph clearances, and occluders read at the scale of
##   a broad ARPG rather than an enlarged one-room prototype?
##
## WHAT IT DELIBERATELY IS NOT. There is no combat, no Quick Strike, no target
## acquisition, no enemy AI, no damage, no Life or Mana, no loot, no XP, no
## Passive, no inventory, no story, no Mara, no Nexus, no Riftmarked
## presentation, no procedural generation, and no save or settings file. The hall
## writes NOTHING to disk: runtime calibration exists for the current session
## only and returns to the candidate baseline on launch or on Reset.
##
## WHAT IT REUSES, rather than reimplementing. The locomotion contract is the
## accepted Prototype Zero one, through the shared components extracted under
## D-195 — `PrototypeLocomotion`, `PrototypeGroundPointer`, `PrototypeMouseHold` —
## plus `PrototypeCameraRig`, `DestinationMarker`, and `InputFamilyTracker`
## unchanged. Prototype Zero's own scenes, resources, values, and regression
## chain are untouched, and the Gate 1A suite reruns that whole chain first.

const PLAYER_SCENE: String = "res://scenes/first_mvp/calibration/calibration_hall_player.tscn"
const WORLD_MASK: int = 1

@export_group("Navigation bake, provisional metres")
@export var agent_radius: float = 0.40
@export var agent_height: float = 1.80
@export var agent_max_climb: float = 0.20
@export var agent_max_slope: float = 20.0
@export var nav_cell_size: float = 0.15

@export_group("Calibration steps")
@export var camera_distance_step: float = 1.0
@export var camera_angle_step: float = 2.5
@export var speed_step: float = 0.2

var data: ScaleCalibrationData
var geometry: ScaleCalibrationGeometry
var nav_region: NavigationRegion3D
var player: CalibrationHallPlayer
var camera_rig: PrototypeCameraRig
var marker: DestinationMarker
var input_family: InputFamilyTracker
var fixtures: CalibrationFixtures
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
## Every combat or interaction input this scene deliberately refused, because
## specification §7 requires that "right-click and combat inputs cannot begin an
## action in this scene". A counter makes that a measured fact.
var refused_action_inputs: int = 0
var overlay_visible: bool = true

var _mouse_hold: PrototypeMouseHold = PrototypeMouseHold.new()
var _stick_override_active: bool = false
var _stick_override: Vector2 = Vector2.ZERO
var _cursor_override: Variant = null
var _default_max_speed: float = 5.0


func _ready() -> void:
	geometry = $NavigationRegion3D/Geometry
	nav_region = $NavigationRegion3D
	camera_rig = $CameraRig
	marker = $DestinationMarker
	input_family = $InputFamilyTracker
	fixtures = $Fixtures
	overlay = $CanvasLayer/CalibrationOverlay
	data = geometry.data
	_default_max_speed = data.maximum_movement_speed

	# MEASURED during Prototype Zero Gate B: at the Gate A light angle the 4 m
	# walls threw shadows most of the way across the floor. A 62-degree elevation
	# keeps the wall shadow inside the wall's own footprint.
	var key_light: DirectionalLight3D = $KeyLight
	key_light.rotation_degrees = Vector3(-62.0, 35.0, 0.0)

	fixtures.configure(geometry, data)
	fixtures.build()

	_configure_navigation()
	bake_navigation()
	_spawn_player()
	camera_rig.set_target(player)
	camera_rig.distance_metres = data.camera_distance_metres
	camera_rig.pitch_degrees = data.camera_pitch_degrees
	camera_rig.fov_degrees = data.camera_fov_degrees
	camera_rig.reset_calibration()

	input_family.family_changed.connect(_on_family_changed)
	overlay.call("bind", self)

	log_event("gate 1A hall", "temporary developer calibration scene; nothing here is canonical")
	log_event("clear floor", "%.2f x %.2f m measured (%.1f P x %.1f P)" % [
		geometry.clear_extent().x, geometry.clear_extent().y,
		data.p_for_metres(geometry.clear_extent().x),
		data.p_for_metres(geometry.clear_extent().y),
	])
	for gate: Dictionary in geometry.gate_records():
		log_event("gate measured", "%-20s %.3f m (%.2f P), target %.3f m" % [
			gate["name"], float(gate["measured_metres"]), float(gate["measured_p"]),
			float(gate["target_metres"]),
		])
	for lane: Dictionary in geometry.lane_records():
		log_event("lane measured", "%-22s %.3f m (%.2f P), target %.3f m" % [
			lane["name"], float(lane["measured_metres"]), float(lane["measured_p"]),
			float(lane["target_metres"]),
		])

	await _await_navigation_synchronized()
	_maybe_start_verification()


func _maybe_start_verification() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if not arguments.has("--verify-1a"):
		return
	var script: GDScript = load(
		"res://scripts/first_mvp/calibration/gate_1a_verification.gd"
	) as GDScript
	var runner: Node = Node.new()
	runner.name = "Gate1AVerification"
	runner.set_script(script)
	runner.set("hall", self)
	runner.set("arguments", arguments)
	add_child(runner)


# --- Construction ----------------------------------------------------------------

func _spawn_player() -> void:
	player = (load(PLAYER_SCENE) as PackedScene).instantiate() as CalibrationHallPlayer
	player.name = "Player"
	player.max_speed = data.maximum_movement_speed
	player.position = geometry.player_spawn()
	$Actors.add_child(player)
	player.movement_command_resolved.connect(_on_movement_command_resolved)
	player.arrived_at_destination.connect(_on_arrived)
	player.movement_intent_cleared.connect(_on_intent_cleared)


# --- Navigation --------------------------------------------------------------------

func _configure_navigation() -> void:
	var mesh: NavigationMesh = NavigationMesh.new()
	# Baked from the hall's own collision boxes, not from the decorative kit
	# meshes, so the walkable surface can never disagree with what the character
	# actually collides against.
	mesh.geometry_parsed_geometry_type = NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS
	mesh.geometry_collision_mask = WORLD_MASK
	mesh.geometry_source_geometry_mode = NavigationMesh.SOURCE_GEOMETRY_ROOT_NODE_CHILDREN
	mesh.cell_size = nav_cell_size
	mesh.cell_height = nav_cell_size
	mesh.agent_radius = agent_radius
	mesh.agent_height = agent_height
	mesh.agent_max_climb = agent_max_climb
	mesh.agent_max_slope = agent_max_slope
	# The bake is bounded to the FIRST METRE above the floor, and that ceiling is
	# lower than Prototype Zero's on purpose. Prototype Zero's obstacles are all
	# 4 m walls whose tops sit far above any plausible ceiling; this hall has a
	# 1.20 m half-wall, and a ledge that low would otherwise bake as a perfectly
	# legitimate walkable surface with open sky above it. Clipping the source
	# geometry at 1.0 m removes every obstacle top from the bake while leaving
	# the obstacle itself standing, which is what makes the half-wall a barrier
	# rather than a step.
	var full: Vector2 = geometry.floor_extent()
	mesh.filter_baking_aabb = AABB(
		Vector3(-full.x * 0.5 - 2.0, -1.0, -full.y * 0.5 - 2.0),
		Vector3(full.x + 4.0, 2.0, full.y + 4.0)
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
## a counter: a point well inside the clear floor must come back as itself.
func _await_navigation_synchronized() -> void:
	var probe: Vector3 = Vector3(0.0, 0.0, geometry.spine_z())
	for frame: int in 30:
		if NavigationServer3D.map_get_iteration_id(navigation_map()) == 0:
			await get_tree().physics_frame
			continue
		var answer: Vector3 = NavigationServer3D.map_get_closest_point(navigation_map(), probe)
		if Vector2(answer.x - probe.x, answer.z - probe.z).length() < 0.25:
			log_event("navigation ready", "map answers queries after %d physics frame%s" % [
				frame, "" if frame == 1 else "s",
			])
			return
		await get_tree().physics_frame
	push_warning("ScaleCalibrationHall: the navigation map did not become queryable in 30 frames")


## True when a planar point is on the walkable surface, within `tolerance`.
func point_is_navigable(point: Vector3, tolerance: float = 0.25) -> bool:
	var flat: Vector3 = Vector3(point.x, 0.0, point.z)
	var answer: Vector3 = NavigationServer3D.map_get_closest_point(navigation_map(), flat)
	return Vector2(answer.x - flat.x, answer.z - flat.z).length() <= tolerance


# --- Input ---------------------------------------------------------------------------

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
	# Specification §7: "right-click and combat inputs cannot begin an action in
	# this scene". They are refused HERE, by name, and counted, rather than being
	# silently unbound somewhere else.
	for refused: StringName in [&"quick_strike", &"attack_in_place", &"interact"]:
		if event.is_action_pressed(refused):
			refused_action_inputs += 1
			log_event("input refused", "'%s' has no action in the calibration hall" % refused)
			return
	_handle_calibration_input(event)


func _handle_calibration_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"toggle_debug_overlay"):
		set_overlay_visible(not overlay_visible)
	elif event.is_action_pressed(&"toggle_calibration_grid"):
		geometry.set_grid_visible(not geometry.grid_visible)
		log_event("calibration grid", "visible=%s" % str(geometry.grid_visible))
	elif event.is_action_pressed(&"calibrate_camera_closer"):
		camera_rig.adjust_distance(-camera_distance_step)
		_log_camera()
	elif event.is_action_pressed(&"calibrate_camera_farther"):
		camera_rig.adjust_distance(camera_distance_step)
		_log_camera()
	elif event.is_action_pressed(&"calibrate_pitch_down"):
		camera_rig.adjust_pitch(-camera_angle_step)
		_log_camera()
	elif event.is_action_pressed(&"calibrate_pitch_up"):
		camera_rig.adjust_pitch(camera_angle_step)
		_log_camera()
	elif event.is_action_pressed(&"calibrate_fov_down"):
		camera_rig.adjust_fov(-camera_angle_step)
		_log_camera()
	elif event.is_action_pressed(&"calibrate_fov_up"):
		camera_rig.adjust_fov(camera_angle_step)
		_log_camera()
	elif event.is_action_pressed(&"calibrate_speed_down"):
		_adjust_speed(-speed_step)
	elif event.is_action_pressed(&"calibrate_speed_up"):
		_adjust_speed(speed_step)
	elif event.is_action_pressed(&"calibrate_reset"):
		reset_calibration()
	else:
		_handle_fixture_keys(event)


## The two hall-only toggles. They are read as PHYSICAL KEYS rather than declared
## as new named input actions, deliberately: Prototype Zero's input map is locked
## and its Gate B, E, and F suites walk `InputMap.get_actions()` one assertion per
## key event, so declaring two more actions would move THREE locked check counts
## without a single old assertion having become false. Gate 1A specification §9
## permits a count to move only where authorization makes a specific old absence
## assertion false, and this is not one of those. F1 is bound to nothing at all;
## F4 additionally carries Prototype Zero's `toggle_barrier`, which nothing in
## this scene listens to.
func _handle_fixture_keys(event: InputEvent) -> void:
	var key: InputEventKey = event as InputEventKey
	if key == null or not key.pressed or key.echo:
		return
	match key.physical_keycode:
		KEY_F1:
			fixtures.set_role_fixtures_visible(not fixtures.role_fixtures_visible)
			log_event("role fixtures", "visible=%s" % str(fixtures.role_fixtures_visible))
		KEY_F4:
			var state: String = fixtures.cycle_markers()
			log_event("telegraph and hazard court", "preset '%s' (x%.2f)" % [
				state, fixtures.current_marker_scale(),
			])


## Specification §7: "reset all runtime calibration to the Gate 1A starting
## baseline". Everything a session can change goes back to the candidate values,
## and nothing was ever written to disk to go back to.
func reset_calibration() -> void:
	camera_rig.reset_calibration()
	player.max_speed = _default_max_speed
	fixtures.reset_to_baseline()
	geometry.set_grid_visible(false)
	log_event("calibration reset", "camera, speed, grid, and fixtures back to the Gate 1A baseline")


func runtime_calibration_is_baseline() -> bool:
	return (
		camera_rig.is_default()
		and is_equal_approx(player.max_speed, _default_max_speed)
		and fixtures.marker_state == 0
		and fixtures.role_fixtures_visible
		and not geometry.grid_visible
	)


func set_overlay_visible(value: bool) -> void:
	overlay_visible = value
	(overlay as CanvasItem).visible = value
	log_event("calibration overlay", "visible=%s" % str(value))


func _adjust_speed(delta_speed: float) -> void:
	player.max_speed = clampf(player.max_speed + delta_speed, 1.0, 12.0)
	log_event("movement speed", "%.2f m/s (Gate 1A candidate %.2f)" % [
		player.max_speed, _default_max_speed,
	])


func _log_camera() -> void:
	log_event("camera", "distance %.1f m, pitch %.1f deg, fov %.1f deg" % [
		camera_rig.distance_metres, camera_rig.pitch_degrees, camera_rig.fov_degrees,
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


# --- Movement commands ---------------------------------------------------------------

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


# --- Measurement, for the overlay and the verification ---------------------------------

## Everything specification §8 requires the overlay to display, all of it either
## measured from the built world or read from the authoritative local calibration
## record. Nothing here is a hand-typed expectation.
func measurements() -> Dictionary:
	var clear: Vector2 = geometry.clear_extent()
	var footprint: Dictionary = camera_footprint()
	return {
		"world_unit_metres": data.world_unit_metres,
		"player_unit_metres": data.player_unit_metres,
		"camera_distance": camera_rig.distance_metres,
		"camera_pitch": camera_rig.pitch_degrees,
		"camera_fov": camera_rig.fov_degrees,
		"camera_yaw": camera_rig.yaw_degrees,
		"max_speed": player.max_speed,
		"player_diameter": player.collision_diameter(),
		"player_height": player.collision_height(),
		"clear_metres": clear,
		"clear_p": Vector2(data.p_for_metres(clear.x), data.p_for_metres(clear.y)),
		"clear_area": geometry.clear_area(),
		"cf_metres": Vector2(float(footprint["focus_width"]), float(footprint["depth"])),
		"cf_area": float(footprint["focus_width"]) * float(footprint["depth"]),
		"reference_aspect": float(footprint["reference_aspect"]),
		"live_aspect": float(footprint["live_aspect"]),
		"clear_in_cf": geometry.clear_area()
			/ maxf(float(footprint["focus_width"]) * float(footprint["depth"]), 0.0001),
		"gates": geometry.gate_records(),
		"lanes": geometry.lane_records(),
		"ranged": fixtures.ranged_records(),
		"roles": fixtures.role_records(),
		"escapes": fixtures.escape_records(),
		"arc_radius": fixtures.current_arc_radius(),
		"arc_degrees": data.mauler_arc_degrees,
		"seal_radius": fixtures.current_seal_radius(),
		"marker_preset": fixtures.marker_state_name(),
		"marker_scale": fixtures.current_marker_scale(),
		"player_position": player.global_position,
		"movement_mode": player.movement_mode_name(),
		"input_family": input_family.family_label(),
		"grid_visible": geometry.grid_visible,
		"role_fixtures_visible": fixtures.role_fixtures_visible,
		"navmesh_polygons": navmesh_polygon_count,
		"navmesh_area": navmesh_area,
		"is_baseline": runtime_calibration_is_baseline(),
	}


## The ground quad the current camera actually covers, measured by intersecting
## the frustum with the y = 0 plane. This is `PrototypeCameraRig`'s own measured
## CF, not a second opinion about it.
##
## MEASURED DEFECT, and the fix for it. CF was first computed from the LIVE
## viewport aspect, and a headless viewport here is 1920 x 1920 — square. The
## same hall therefore reported 15.74 x 20.98 m and 4.54 CF headless against
## 27.98 x 20.98 m and 2.56 CF rendered at 1920 x 1080: one hall, two answers,
## and the smaller one flattering the result. CF is a PROJECT UNIT defined at the
## fixed 1920 x 1080 reference aspect — which is exactly how Gate B records it —
## so it is computed at that aspect and means the same thing in a headless run, a
## 1280 x 720 window, and macOS fullscreen. The live aspect is reported beside it
## rather than hidden.
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


# --- Log ------------------------------------------------------------------------------

func log_event(kind: String, detail: String) -> void:
	var line: String = "[gate-1a] %-28s %s" % [kind, detail]
	log_lines.append(line)
	print(line)
