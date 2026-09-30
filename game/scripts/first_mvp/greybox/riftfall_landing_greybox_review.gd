class_name RiftfallLandingGreyboxReview
extends Node3D
## Riftfall Landing — ISOLATED GREYBOX REVIEW SCENE, V2. NOT CANONICAL.
##
## Level-design blockout only. It exists so the project owner can judge scale
## and flow with the accepted movement and camera before any asset, lighting
## or VFX work begins on a next Riftfall Landing iteration. Acceptance of this
## scene is a precondition for that work, not a consequence of it.
##
## V2 REPLACES V1's COMPOSITION after the project owner rejected it: "reads as
## a rectangle", "feels like a hallway", "the middle has no identity", "the
## breach doesn't feel like a destination", "essentially straight with a minor
## angle". `RiftfallLandingGreyboxLayout` now builds a genuine hook/S route
## with real lateral swing, discrete gapped boundary massing instead of
## corridor walls, and five distinct irregular rooms joined by short pinch
## transitions. See that file's own header for the room-by-room detail.
##
## IT DOES NOT TOUCH THE CANONICAL GATE 1C SCENE. It shares no file with
## `scenes/first_mvp/severed_threshold/`, loads none of its scripts, and reads
## none of its accepted payload allowlist. It shares no file with the Zone
## Composer or with `zone_composer_practice.tscn` either. What it DOES reuse,
## unchanged, is the same shared kernel every other first-MVP review instrument
## reuses, so this is not a second locomotion or camera implementation:
## `CalibrationHallPlayer` (body), `PrototypeCameraRig` (the accepted 19 m /
## 55° / 45° camera), `DestinationMarker`, `PrototypeGroundPointer`, and
## `PrototypeMouseHold`.
##
## IT LOADS NO THIRD-PARTY ASSET. All geometry comes from
## `RiftfallLandingGreyboxLayout`, which builds only `BoxMesh`, `TorusMesh`,
## `PlaneMesh` and `ImmediateMesh` primitives in flat diagnostic colours — no
## imported mesh, no registered exterior lighting or material treatment
## component, no shader, no particle system. The smoke test proves this with a
## raw source scan of both scripts in this directory.
##
## IT WRITES NOTHING. No storage path, no configuration store, no save.
## Reaching Way Out is a developer measurement, exactly like the canonical
## scene's own ExitToBrokenWatch: nothing loads, nothing is stored.
##
## NO INPUT ACTION IS DECLARED. Every review key below is read as a PHYSICAL
## key, exactly as every other first-MVP review instrument does, so
## `project.godot` is not touched and no locked Prototype Zero InputMap count
## can move.
##
## Controls: left click or hold to move; left stick to move directly.
## F6 grid · [ ] camera distance · \ reset.

const PLAYER_SCENE: String = "res://scenes/first_mvp/calibration/calibration_hall_player.tscn"
const VERIFICATION_SCRIPT: String = "res://tests/riftfall_landing_greybox_verification.gd"
const WORLD_MASK: int = 1

const ACCEPTED_CAMERA_DISTANCE: float = 19.0
const ACCEPTED_CAMERA_PITCH: float = 55.0
const ACCEPTED_CAMERA_FOV: float = 45.0
const ACCEPTED_MAX_SPEED: float = 5.0
## The accepted camera's own yaw. The `Composition` node carries a matching
## yaw so the layout's local -Z runs straight up the screen, exactly as the
## canonical scene's own `Composition` node does and for the same reason.
const COMPOSITION_YAW_DEGREES: float = 45.0

const WAY_OUT_REACHED_METRES: float = 2.5
const MAXIMUM_STEP_METRES: float = 0.50

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
var layout: RiftfallLandingGreyboxLayout
var nav_region: NavigationRegion3D
var camera_rig: PrototypeCameraRig
var marker: DestinationMarker
var player: CalibrationHallPlayer

var navmesh_polygon_count: int = 0
var navmesh_area: float = 0.0
var last_bake_msec: int = 0
var bake_count: int = 0

var log_lines: PackedStringArray = PackedStringArray()
var grid_visible: bool = false
var accepted_commands: int = 0
var adjusted_commands: int = 0
var rejected_commands: int = 0
var refused_action_inputs: int = 0
var walked_metres: float = 0.0
var walked_seconds: float = 0.0
var way_out_reached: bool = false

var _mouse_hold: PrototypeMouseHold = PrototypeMouseHold.new()
var _last_position: Vector3 = Vector3.ZERO
var _has_last_position: bool = false


func _ready() -> void:
	composition = $Composition
	composition.rotation_degrees = Vector3(0.0, COMPOSITION_YAW_DEGREES, 0.0)
	nav_region = $Composition/NavigationRegion3D
	layout = $Composition/NavigationRegion3D/Layout
	camera_rig = $CameraRig
	marker = $DestinationMarker

	_configure_navigation()
	bake_navigation()
	_spawn_player()
	camera_rig.set_target(player)
	camera_rig.reset_calibration()

	log_event("greybox review", "isolated level-design blockout, NOT canonical; owner acceptance precedes any asset/lighting/VFX pass")
	log_event("controls", "F6 grid · [ ] camera · \\ reset")
	log_event("footprint", "%.2f m^2 walkable, %.1f%% clear of architecture" % [
		layout.footprint_area(), layout.clear_fraction() * 100.0,
	])
	log_event("route", "%.3f m centreline, narrowest measured clearance %.3f m" % [
		layout.centreline_length(), layout.narrowest_clearance(),
	])
	log_event("route widths", "%d stations: %d in 10-14 m, %d wider, %d narrower; median %.2f m" % [
		layout.width_samples().size(), layout.widths_in_ordinary_band(),
		layout.widths_wider_than_ordinary(), layout.widths_narrower_than_ordinary(),
		layout.median_width(),
	])
	log_event("watch breach", "%.3f m measured clearance" % layout.breach_clearance())
	log_event("composition", "%d direction change(s) >= 25 deg, %.1f m lateral swing" % [
		layout.direction_change_count(), layout.lateral_swing(),
	])

	await _await_navigation_synchronized()
	_maybe_start_verification()


func _maybe_start_verification() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if not arguments.has("--verify-greybox"):
		return
	var script: GDScript = load(VERIFICATION_SCRIPT) as GDScript
	var runner: Node = Node.new()
	runner.name = "RiftfallLandingGreyboxVerification"
	runner.set_script(script)
	runner.set("review", self)
	runner.set("arguments", arguments)
	add_child(runner)


func _spawn_player() -> void:
	player = (load(PLAYER_SCENE) as PackedScene).instantiate() as CalibrationHallPlayer
	player.name = "ReviewBody"
	player.max_speed = ACCEPTED_MAX_SPEED
	$Actors.add_child(player)
	player.global_position = layout.player_start()
	player.face_instantly(route_forward())
	_last_position = player.global_position
	_has_last_position = true
	player.movement_command_resolved.connect(_on_movement_command_resolved)
	player.arrived_at_destination.connect(_on_arrived)
	player.movement_intent_cleared.connect(_on_intent_cleared)


func route_forward() -> Vector3:
	var points: PackedVector3Array = layout.centreline_world()
	if points.size() < 2:
		return Vector3(0.0, 0.0, -1.0)
	var span: Vector3 = points[1] - points[0]
	return Vector3(span.x, 0.0, span.z).normalized()


# --- Navigation -------------------------------------------------------------

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
	var rect: Rect2 = layout.bake_rect()
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
	last_bake_msec = Time.get_ticks_msec() - started
	bake_count += 1
	_measure_navmesh()
	log_event("navigation baked", "%d polygons, %.1f m^2 walkable, %d ms (bake #%d)" % [
		navmesh_polygon_count, navmesh_area, last_bake_msec, bake_count,
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
	var probe: Vector3 = layout.player_start()
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
	push_warning("RiftfallLandingGreyboxReview: the navigation map did not become queryable")


func route_path_length() -> float:
	var points: PackedVector3Array = NavigationServer3D.map_get_path(
		navigation_map(), layout.player_start(), layout.way_out(), true
	)
	var total: float = 0.0
	for i: int in range(1, points.size()):
		total += points[i].distance_to(points[i - 1])
	return total


# --- Input --------------------------------------------------------------------

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
	for refused: StringName in [&"quick_strike", &"attack_in_place", &"interact"]:
		if event.is_action_pressed(refused):
			refused_action_inputs += 1
			log_event("input refused", "'%s' has no action in this greybox review" % refused)
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
			reset_review()


func set_grid_visible(value: bool) -> void:
	grid_visible = value
	layout.set_grid_visible(value)
	log_event("review grid", "visible=%s" % str(value))


func reset_review() -> void:
	set_grid_visible(false)
	camera_rig.reset_calibration()
	player.clear_movement_intent("review reset", false)
	player.global_position = layout.player_start()
	player.velocity = Vector3.ZERO
	player.face_instantly(route_forward())
	marker.hide_destination()
	_last_position = player.global_position
	walked_metres = 0.0
	walked_seconds = 0.0
	way_out_reached = false
	accepted_commands = 0
	adjusted_commands = 0
	rejected_commands = 0
	refused_action_inputs = 0
	camera_rig.focus = player.global_position
	log_event("review reset", "player, camera, marker, grid, and counters")


func _pointer_over_ui() -> bool:
	return get_viewport().gui_get_hovered_control() != null


func _process(delta: float) -> void:
	if player == null:
		return
	player.set_ground_basis(camera_rig.ground_forward(), camera_rig.ground_right())
	if _mouse_hold.should_reissue(delta, Input.is_action_pressed(&"move_point")):
		if not _pointer_over_ui():
			_issue_move_command()
	_update_neutral_latch()


func _physics_process(delta: float) -> void:
	if player == null:
		return
	player.set_stick_raw(PrototypeLocomotion.read_stick_actions())
	_accumulate_walk(delta)


func _accumulate_walk(delta: float) -> void:
	var here: Vector3 = player.global_position
	if _has_last_position:
		var step: float = Vector2(here.x - _last_position.x, here.z - _last_position.z).length()
		if step > 0.0005 and step <= MAXIMUM_STEP_METRES:
			walked_metres += step
			walked_seconds += delta
	_last_position = here
	_has_last_position = true
	if way_out_reached:
		return
	if here.distance_to(layout.way_out()) <= WAY_OUT_REACHED_METRES:
		way_out_reached = true
		log_event("way out reached", "%.2f m walked in %.2f s of simulation; nothing is loaded, opened, or stored" % [
			walked_metres, walked_seconds,
		])


func _update_neutral_latch() -> void:
	if not player.awaiting_neutral:
		return
	if Input.is_action_pressed(&"move_point"):
		return
	if PrototypeLocomotion.read_stick_actions().length() > player.stick_deadzone:
		return
	player.release_neutral_latch()


func _issue_move_command() -> void:
	var cursor: Dictionary = ground_point_under_cursor()
	if not bool(cursor.get("valid", false)):
		rejected_commands += 1
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
		rejected_commands += 1
		log_event("movement command rejected", status)
		return
	if status == "adjusted":
		adjusted_commands += 1
	else:
		accepted_commands += 1
	marker.show_destination(resolved, requested, status == "adjusted")


func _on_arrived(point: Vector3) -> void:
	marker.hide_destination()


func _on_intent_cleared(_reason: String) -> void:
	marker.hide_destination()


# --- Measurement --------------------------------------------------------------

func measurements() -> Dictionary:
	return {
		"footprint_area": layout.footprint_area(),
		"clear_fraction": layout.clear_fraction(),
		"centreline_metres": layout.centreline_length(),
		"resolved_path_metres": route_path_length(),
		"narrowest_clearance": layout.narrowest_clearance(),
		"breach_clearance": layout.breach_clearance(),
		"width_samples": layout.width_samples().size(),
		"widths_ordinary": layout.widths_in_ordinary_band(),
		"widths_wider": layout.widths_wider_than_ordinary(),
		"widths_narrower": layout.widths_narrower_than_ordinary(),
		"median_width": layout.median_width(),
		"navmesh_polygons": navmesh_polygon_count,
		"navmesh_area": navmesh_area,
		"bake_count": bake_count,
		"player_position": player.global_position,
		"walked_metres": walked_metres,
		"walked_seconds": walked_seconds,
		"way_out_reached": way_out_reached,
		"accepted_commands": accepted_commands,
		"adjusted_commands": adjusted_commands,
		"rejected_commands": rejected_commands,
		"refused_action_inputs": refused_action_inputs,
		"sockets": layout.socket_positions(),
	}


func log_event(kind: String, detail: String) -> void:
	var line: String = "[greybox-review] %-24s %s" % [kind, detail]
	log_lines.append(line)
	print(line)
