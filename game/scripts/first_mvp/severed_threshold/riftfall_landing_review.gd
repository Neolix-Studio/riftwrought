class_name RiftfallLandingReview
extends Node3D
## First-MVP Gate 1C — the DEVELOPER REVIEW WRAPPER around canonical Riftfall
## Landing (D-208 §3, §8 and §9).
##
## The canonical scene owns the world. This scene owns the temporary things a
## person needs in order to walk around it and judge it: a locomotion-only body,
## the accepted camera, the destination marker, input-family tracking, five
## physical diagnostic keys, and a compact overlay that is OFF by default.
##
## THE SEPARATION IS THE POINT. Everything here is review scaffolding and none of
## it is canonical character architecture. The body is
## `scenes/first_mvp/calibration/calibration_hall_player.tscn`, REUSED UNCHANGED:
## its class is still named `CalibrationHallPlayer` and its documentation still
## names the Scale Calibration Hall, because §2 does not authorize editing a
## closed gate's files — not even its comments, which is the same call both Gate
## 1B scenes made. What it actually is, is a locomotion-only body over the one
## shared movement kernel, which is exactly what a movement review needs and
## exactly what the Riftmarked must NOT inherit later.
##
## NO NEW INPUT ACTION IS DECLARED. §9 asks for physical developer keys, and that
## matters beyond tidiness: the Gate B, E and F suites each walk
## `InputMap.get_actions()` and emit one assertion per key event, so declaring an
## action here would move three locked Prototype Zero counts without a single old
## assertion having become false. `project.godot` is not edited.
##
## IT WRITES NOTHING. This scene has no storage path at all: it opens no engine
## data directory, constructs no configuration store, saves no resource, and makes
## no filesystem call of any kind. That sentence deliberately avoids naming those
## APIs, because this project's suites scan these files RAW — comments included —
## for the literal strings, and a raw scan is stronger than a comment-stripped one
## precisely because it cannot be talked around.
##
## NOTHING HERE IS GAMEPLAY. Reaching `ExitToBrokenWatch` is logged as a developer
## measurement and does nothing else: no level loads, no progress is stored, no
## quest opens, and Broken Watch is not fabricated. The combat inputs Prototype
## Zero declares are refused BY NAME and counted, so "no combat entered Gate 1C"
## is a measurement rather than an absence nobody looked for.

const LANDING_SCENE: String = "res://scenes/first_mvp/severed_threshold/riftfall_landing.tscn"
const PLAYER_SCENE: String = "res://scenes/first_mvp/calibration/calibration_hall_player.tscn"
const VERIFICATION_SCRIPT: String = "res://tests/gate_1c_riftfall_landing_verification.gd"
const WORLD_MASK: int = 1

## How close the review body must come to the exit socket for the wrapper to log
## that it was reached. A measurement threshold, not a trigger volume.
const EXIT_REACHED_METRES: float = 2.5
## The furthest the body can move in one physics frame at the accepted 5.0 m/s and
## 60 Hz is 0.084 m; anything beyond this is a reposition rather than a step.
const MAXIMUM_STEP_METRES: float = 0.50

@export_group("Review controls")
## §9 permits the accepted camera calibration keys only where they are inherited
## from the existing reusable camera component, and `[` / `]` are: they call
## `PrototypeCameraRig.adjust_distance()`, which Gate B shipped and Gate 1A and
## both Gate 1B scenes reuse. The DEFAULT is always the accepted 19 m and `\`
## returns to it; nothing accepted is changed.
@export var camera_distance_step: float = 2.0

var landing: RiftfallLanding
var player: CalibrationHallPlayer
var camera_rig: PrototypeCameraRig
var marker: DestinationMarker
var input_family: InputFamilyTracker
var overlay: Node

# --- Instrumentation ----------------------------------------------------------
var log_lines: PackedStringArray = PackedStringArray()
var accepted_commands: int = 0
var adjusted_commands: int = 0
var rejected_commands: int = 0
var ui_clicks_absorbed: int = 0
## Every combat or interaction input this scene deliberately refused.
var refused_action_inputs: int = 0
var review_toggle_count: int = 0
var overlay_visible: bool = false
var grid_visible: bool = false
var diagnostics_visible: bool = false
## The distance the body has actually WALKED, accumulated from its own planar
## motion, and the simulation time it took. Distinct from the geometric centreline
## and from the resolved navigation path, and reported as such.
var walked_metres: float = 0.0
var walked_seconds: float = 0.0
var exit_reached: bool = false
var exit_reached_metres: float = 0.0
var exit_reached_seconds: float = 0.0

var _mouse_hold: PrototypeMouseHold = PrototypeMouseHold.new()
var _stick_override_active: bool = false
var _stick_override: Vector2 = Vector2.ZERO
var _cursor_override: Variant = null
var _last_position: Vector3 = Vector3.ZERO
var _has_last_position: bool = false


func _ready() -> void:
	landing = $Landing
	camera_rig = $CameraRig
	marker = $DestinationMarker
	input_family = $InputFamilyTracker
	overlay = $CanvasLayer/RiftfallLandingOverlay

	# The canonical scene bakes its own navigation in its own `_ready`, which runs
	# before this one because it is a child. Waiting for its synchronization here
	# would double-await; the verification waits for a real query instead.
	_spawn_player()
	camera_rig.set_target(player)
	camera_rig.reset_calibration()

	input_family.family_changed.connect(_on_family_changed)
	overlay.call("bind", self)
	set_overlay_visible(false)
	landing.layout.set_grid_visible(false)
	landing.layout.set_diagnostics_visible(false)
	review_toggle_count = 0

	log_event("gate 1c review", "developer wrapper around the canonical Riftfall Landing scene")
	log_event("not gameplay", "no combat, enemy, reward, progression, save, or transition exists")
	log_event("controls", "F3 overlay · F6 grid · F7 navigation and collision roles · [ ] camera · \\ reset")
	_maybe_start_verification()


func _maybe_start_verification() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if not arguments.has("--verify-1c"):
		return
	var script: GDScript = load(VERIFICATION_SCRIPT) as GDScript
	var runner: Node = Node.new()
	runner.name = "Gate1CRiftfallVerification"
	runner.set_script(script)
	runner.set("review", self)
	runner.set("arguments", arguments)
	add_child(runner)


func _spawn_player() -> void:
	player = (load(PLAYER_SCENE) as PackedScene).instantiate() as CalibrationHallPlayer
	player.name = "ReviewBody"
	player.max_speed = RiftfallLanding.ACCEPTED_MAX_SPEED
	$Actors.add_child(player)
	player.global_position = landing.player_spawn()
	# Face the route rather than a world axis, so the first frame the owner sees
	# is the composition the Landing was authored for.
	player.face_instantly(route_forward())
	_last_position = player.global_position
	_has_last_position = true
	player.movement_command_resolved.connect(_on_movement_command_resolved)
	player.arrived_at_destination.connect(_on_arrived)
	player.movement_intent_cleared.connect(_on_intent_cleared)


## The direction the authored route leaves the spawn, in world space.
func route_forward() -> Vector3:
	var points: PackedVector3Array = landing.layout.centreline_world()
	if points.size() < 2:
		return Vector3(0.0, 0.0, -1.0)
	var span: Vector3 = points[1] - points[0]
	return Vector3(span.x, 0.0, span.z).normalized()


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
	# No combat. The combat actions are refused HERE, by name, and counted, rather
	# than being silently unbound somewhere else.
	for refused: StringName in [&"quick_strike", &"attack_in_place", &"interact"]:
		if event.is_action_pressed(refused):
			refused_action_inputs += 1
			log_event("input refused", "'%s' has no action in Riftfall Landing" % refused)
			return
	_handle_review_keys(event)


## §9's review controls, all read as PHYSICAL KEYS so no InputMap action is added.
func _handle_review_keys(event: InputEvent) -> void:
	var key: InputEventKey = event as InputEventKey
	if key == null or not key.pressed or key.echo:
		return
	match key.physical_keycode:
		KEY_F3:
			set_overlay_visible(not overlay_visible)
		KEY_F6:
			set_grid_visible(not grid_visible)
		KEY_F7:
			set_diagnostics_visible(not diagnostics_visible)
		KEY_BRACKETLEFT:
			camera_rig.adjust_distance(-camera_distance_step)
			_log_camera()
		KEY_BRACKETRIGHT:
			camera_rig.adjust_distance(camera_distance_step)
			_log_camera()
		KEY_BACKSLASH:
			reset_review()


func set_overlay_visible(value: bool) -> void:
	overlay_visible = value
	overlay.call("set_panels_visible", value)
	review_toggle_count += 1
	log_event("review overlay", "diagnostics visible=%s" % str(value))


func set_grid_visible(value: bool) -> void:
	grid_visible = value
	landing.layout.set_grid_visible(value)
	review_toggle_count += 1
	log_event("scale grid", "visible=%s" % str(value))


func set_diagnostics_visible(value: bool) -> void:
	diagnostics_visible = value
	landing.layout.set_diagnostics_visible(value)
	review_toggle_count += 1
	log_event("navigation and collision roles", "visible=%s" % str(value))


## §9: reset player, camera, marker, loop state, counters, and review modes.
## Nothing was ever put anywhere for this to restore FROM; it simply returns the
## live scene to its launch state.
func reset_review() -> void:
	landing.loop_event.reset()
	set_overlay_visible(false)
	set_grid_visible(false)
	set_diagnostics_visible(false)
	camera_rig.reset_calibration()
	player.clear_movement_intent("review reset", false)
	player.global_position = landing.player_spawn()
	player.velocity = Vector3.ZERO
	player.face_instantly(route_forward())
	marker.hide_destination()
	_last_position = player.global_position
	walked_metres = 0.0
	walked_seconds = 0.0
	exit_reached = false
	exit_reached_metres = 0.0
	exit_reached_seconds = 0.0
	accepted_commands = 0
	adjusted_commands = 0
	rejected_commands = 0
	ui_clicks_absorbed = 0
	refused_action_inputs = 0
	review_toggle_count = 0
	camera_rig.focus = player.global_position
	log_event("review reset", "player, camera, marker, loop state, counters, and review modes")


func review_is_launch_state() -> bool:
	return (
		not overlay_visible
		and not grid_visible
		and not diagnostics_visible
		and camera_rig.is_default()
		and landing.loop_event.cycle_count == 0
		and landing.loop_event.state == RiftfallLoopEvent.State.REST
	)


func _log_camera() -> void:
	log_event("camera", "distance %.1f m (accepted default %.1f m), pitch %.1f deg, fov %.1f deg" % [
		camera_rig.distance_metres, RiftfallLanding.ACCEPTED_CAMERA_DISTANCE,
		camera_rig.pitch_degrees, camera_rig.fov_degrees,
	])


## Public because it is a CLAIM the verification has to be able to check: the
## wrapper refuses to turn a pointer press into a world command whenever the
## cursor is over any drawn Control.
func pointer_over_ui() -> bool:
	return get_viewport().gui_get_hovered_control() != null


func _pointer_over_ui() -> bool:
	return pointer_over_ui()


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


func _physics_process(delta: float) -> void:
	if player == null:
		return
	player.set_stick_raw(read_stick_raw())
	_accumulate_walk(delta)


## Walked distance and elapsed time, accumulated on the SIMULATION clock the body
## moves on rather than on a wall clock that keeps running while the process
## stalls. Prototype Zero's D-192 lesson, applied here from the beginning.
func _accumulate_walk(delta: float) -> void:
	var here: Vector3 = player.global_position
	if _has_last_position:
		var step: float = Vector2(here.x - _last_position.x, here.z - _last_position.z).length()
		# A step larger than the accepted maximum speed can produce in one physics
		# frame is not walking — it is a reset or a verification reposition — and
		# counting it inflates the one number that is supposed to mean "the body
		# actually covered this ground". The first evidence run reported 62.36 m
		# walked in 0.1 s for exactly that reason.
		if step > 0.0005 and step <= MAXIMUM_STEP_METRES:
			walked_metres += step
			walked_seconds += delta
	_last_position = here
	_has_last_position = true
	if exit_reached:
		return
	if here.distance_to(landing.exit_socket()) <= EXIT_REACHED_METRES:
		exit_reached = true
		exit_reached_metres = walked_metres
		exit_reached_seconds = walked_seconds
		# A developer MEASUREMENT and nothing else: no level loads, no state is
		# stored, no quest opens, and Broken Watch is not started.
		log_event("exit socket reached",
			"%.2f m walked in %.2f s of simulation; nothing is loaded, opened, or stored" % [
				walked_metres, walked_seconds,
			])


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
	return PrototypeGroundPointer.resolve_to_navigation(landing.navigation_map(), requested)


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


# --- Measurement --------------------------------------------------------------

## The canonical scene's own measurements plus everything only the wrapper can
## know: where the body is, what it is doing, and what the session has counted.
func measurements() -> Dictionary:
	var found: Dictionary = landing.measurements()
	var footprint: Dictionary = camera_rig.ground_footprint(reference_aspect())
	found["camera_distance"] = camera_rig.distance_metres
	found["camera_yaw"] = camera_rig.yaw_degrees
	found["cf_metres"] = Vector2(float(footprint["focus_width"]), float(footprint["depth"]))
	found["cf_area"] = float(footprint["focus_width"]) * float(footprint["depth"])
	found["reference_aspect"] = reference_aspect()
	found["live_aspect"] = live_aspect()
	found["player_position"] = player.global_position
	found["player_diameter"] = player.collision_diameter()
	found["player_height"] = player.collision_height()
	found["movement_mode"] = player.movement_mode_name()
	found["destination"] = player.current_path()
	found["input_family"] = input_family.family_label()
	found["walked_metres"] = walked_metres
	found["walked_seconds"] = walked_seconds
	found["exit_reached"] = exit_reached
	found["exit_reached_metres"] = exit_reached_metres
	found["exit_reached_seconds"] = exit_reached_seconds
	found["accepted_commands"] = accepted_commands
	found["adjusted_commands"] = adjusted_commands
	found["rejected_commands"] = rejected_commands
	found["ui_clicks_absorbed"] = ui_clicks_absorbed
	found["refused_action_inputs"] = refused_action_inputs
	found["overlay_visible"] = overlay_visible
	found["grid_visible"] = grid_visible
	found["diagnostics_visible"] = diagnostics_visible
	found["is_launch_state"] = review_is_launch_state()
	return found


func reference_aspect() -> float:
	return (
		float(ProjectSettings.get_setting("display/window/size/viewport_width", 1920))
		/ float(ProjectSettings.get_setting("display/window/size/viewport_height", 1080))
	)


func live_aspect() -> float:
	var viewport: Vector2 = get_viewport().get_visible_rect().size
	return viewport.x / maxf(viewport.y, 1.0)


func log_event(kind: String, detail: String) -> void:
	var line: String = "[gate-1c-review] %-26s %s" % [kind, detail]
	log_lines.append(line)
	print(line)
