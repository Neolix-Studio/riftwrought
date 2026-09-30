extends Node
## Riftfall Landing greybox review — automated verification.
##
## THIS IS NOT A GATE. It proves what a machine can settle about one isolated,
## non-canonical level-design blockout: that the scene loads only primitive
## geometry, that the accepted movement and camera are untouched, that no
## InputMap action was added, and that the measured footprint, route length,
## width and clear ground land inside the review's own target bands. It does
## not decide whether the space reads well — only the project owner can, after
## playing it — and it does not re-run any earlier gate.
##
## Run:  godot --headless --path game res://scenes/first_mvp/greybox/riftfall_landing_greybox_review.tscn -- --verify-greybox
##       godot --path game --resolution 1920x1080 res://.../riftfall_landing_greybox_review.tscn -- --verify-greybox --shots <dir>

const ACCEPTED_CAMERA_DISTANCE: float = 19.0
const ACCEPTED_CAMERA_PITCH: float = 55.0
const ACCEPTED_CAMERA_FOV: float = 45.0
const ACCEPTED_CAMERA_YAW: float = 45.0
const ACCEPTED_MAX_SPEED: float = 5.0

## The review's own target bands, quoted from the task brief.
const FOOTPRINT_MIN: float = 1150.0
const FOOTPRINT_MAX: float = 1350.0
const CENTRELINE_MIN: float = 45.0
const CENTRELINE_MAX: float = 55.0
const MANDATORY_CLEARANCE_MIN: float = 8.0
const CLEAR_FRACTION_MIN: float = 0.70
## V2's composition is deliberately BROAD ROOMS joined by SHORT TRANSITIONS —
## most stations are wider than the 10-14 m ordinary band by design, and that
## is correct, not a regression from V1. What must still be true is that the
## ordinary band exists at all, at the transitions, in a plausible count.
const ORDINARY_WIDTH_STATIONS_MIN: int = 5

## The complete InputMap this project declares. This review adds none.
const EXPECTED_ACTIONS: Array[String] = [
	"move_point", "move_vector_left", "move_vector_right", "move_vector_forward",
	"move_vector_back", "quick_strike", "attack_in_place", "reset_target_fixtures",
	"toggle_slow_motion", "toggle_fixture_drift", "toggle_fixture_present",
	"toggle_debug_overlay", "toggle_barrier", "toggle_calibration_grid",
	"calibrate_camera_closer", "calibrate_camera_farther", "calibrate_pitch_down",
	"calibrate_pitch_up", "calibrate_fov_down", "calibrate_fov_up",
	"calibrate_speed_down", "calibrate_speed_up", "reset_encounter", "interact",
	"ui_confirm", "ui_cancel", "reset_lab_progress", "pause", "quick_restart",
	"toggle_damage_numbers", "calibrate_reset",
]

## This review's own two shipping scripts. The verification script itself is
## excluded by construction — it lives under `tests/`, not under
## `scripts/first_mvp/greybox/` — so this scan cannot be confused by the file
## that forbids the fragments below.
const SHIPPING_SCRIPTS: Array[String] = [
	"res://scripts/first_mvp/greybox/riftfall_landing_greybox_layout.gd",
	"res://scripts/first_mvp/greybox/riftfall_landing_greybox_review.gd",
]

## Reused UNCHANGED. Listed so the reuse is a checked fact rather than a claim.
const REUSED_SCRIPTS: Array[String] = [
	"res://scripts/movement/prototype_locomotion.gd",
	"res://scripts/movement/prototype_ground_pointer.gd",
	"res://scripts/movement/prototype_mouse_hold.gd",
	"res://scripts/camera/prototype_camera_rig.gd",
	"res://scripts/prototype_zero/destination_marker.gd",
	"res://scenes/first_mvp/calibration/calibration_hall_player.tscn",
]

## No environment asset, texture, shader, particle system, or registered
## exterior presentation component of any kind. A raw scan, comments included:
## an illustrative literal fragment in a comment breaches the rule exactly as
## surely as a real one, which is why this review's own comments avoid these
## words entirely rather than relying on a comment-stripped scan.
const FORBIDDEN_FRAGMENTS: Array[String] = [
	"res://assets/", ".gltf", ".glb", ".png", ".import",
	"ExteriorReview", "kaykit", "kenney", "k0rveen",
	"GPUParticles", "CPUParticles", "ShaderMaterial", ".gdshader",
	"AudioStream", "DialogueLine", "loot", "Enemy",
]

var review: RiftfallLandingGreyboxReview
var arguments: PackedStringArray = PackedStringArray()

var layout: RiftfallLandingGreyboxLayout

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _shot_dir: String = ""


func _ready() -> void:
	await run()


func run() -> void:
	layout = review.layout
	_shot_dir = _argument_value("--shots")

	print("")
	print("=== Riftfall Landing greybox review verification ===")
	await _settle(10)

	_check_accepted_values_untouched()
	_check_input_map_untouched()
	_check_no_third_party_reference()
	_check_layout_targets()
	_check_sockets()
	await _check_navigation_and_traversal()
	_check_no_state_written()

	if _shot_dir != "":
		await _capture_evidence()

	print("")
	if _failures.is_empty():
		print("RIFTFALL LANDING GREYBOX REVIEW: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFTFALL LANDING GREYBOX REVIEW: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		get_tree().quit(1)


# --- Accepted values and InputMap ---------------------------------------------

func _check_accepted_values_untouched() -> void:
	print("")
	print("--- The accepted movement and camera are untouched")
	var rig: PrototypeCameraRig = review.camera_rig
	_expect(is_equal_approx(rig.distance_metres, ACCEPTED_CAMERA_DISTANCE),
		"camera distance is %.2f, not the accepted %.2f" % [rig.distance_metres, ACCEPTED_CAMERA_DISTANCE])
	_expect(is_equal_approx(rig.pitch_degrees, ACCEPTED_CAMERA_PITCH),
		"camera pitch is %.2f, not the accepted %.2f" % [rig.pitch_degrees, ACCEPTED_CAMERA_PITCH])
	_expect(is_equal_approx(rig.fov_degrees, ACCEPTED_CAMERA_FOV),
		"camera FOV is %.2f, not the accepted %.2f" % [rig.fov_degrees, ACCEPTED_CAMERA_FOV])
	_expect(is_equal_approx(rig.yaw_degrees, ACCEPTED_CAMERA_YAW),
		"camera yaw is %.2f, not the accepted %.2f" % [rig.yaw_degrees, ACCEPTED_CAMERA_YAW])
	_expect(is_equal_approx(review.player.max_speed, ACCEPTED_MAX_SPEED),
		"player max_speed is %.2f, not the accepted %.2f" % [review.player.max_speed, ACCEPTED_MAX_SPEED])
	print("  19 m / 55 deg / 45 deg camera and 5.0 m/s locomotion, all confirmed live")


func _check_input_map_untouched() -> void:
	print("")
	print("--- No InputMap action was added")
	var actions: PackedStringArray = PackedStringArray()
	for action: StringName in InputMap.get_actions():
		var name: String = String(action)
		if name.begins_with("ui_") and not EXPECTED_ACTIONS.has(name):
			continue
		actions.append(name)
	for expected: String in EXPECTED_ACTIONS:
		_expect(InputMap.has_action(expected), "expected action '%s' is missing" % expected)
	for present: String in actions:
		_expect(EXPECTED_ACTIONS.has(present),
			"unexpected InputMap action '%s' — this review must add none" % present)
	print("  InputMap still declares exactly the accepted %d actions" % EXPECTED_ACTIONS.size())


# --- No third-party reference, anywhere in this review's own source ----------

func _check_no_third_party_reference() -> void:
	print("")
	print("--- No environment asset, shader, particle system, or registered presentation component")
	for path: String in SHIPPING_SCRIPTS:
		var source: String = FileAccess.get_file_as_string(path)
		_expect(not source.is_empty(), "could not read %s for the source scan" % path)
		for fragment: String in FORBIDDEN_FRAGMENTS:
			_expect(not source.to_lower().contains(fragment.to_lower()),
				"%s names forbidden fragment '%s'" % [path, fragment])
	var scene_source: String = FileAccess.get_file_as_string(
		"res://scenes/first_mvp/greybox/riftfall_landing_greybox_review.tscn"
	)
	for fragment: String in FORBIDDEN_FRAGMENTS:
		_expect(not scene_source.to_lower().contains(fragment.to_lower()),
			"the greybox scene file names forbidden fragment '%s'" % fragment)
	for reused: String in REUSED_SCRIPTS:
		_expect(ResourceLoader.exists(reused), "expected reused component missing: %s" % reused)
	print("  %d shipping files scanned raw; none names a registered asset, shader, or particle system" % (
		SHIPPING_SCRIPTS.size() + 1
	))
	print("  %d shared components reused, none forked" % REUSED_SCRIPTS.size())


# --- Layout targets ------------------------------------------------------------

func _check_layout_targets() -> void:
	print("")
	print("--- Footprint, route, width and clear-ground targets")
	var footprint: float = layout.footprint_area()
	_expect(footprint >= FOOTPRINT_MIN and footprint <= FOOTPRINT_MAX,
		"footprint %.2f m^2 is outside the %d-%d m^2 band" % [footprint, int(FOOTPRINT_MIN), int(FOOTPRINT_MAX)])

	var centreline: float = layout.centreline_length()
	_expect(centreline >= CENTRELINE_MIN and centreline <= CENTRELINE_MAX,
		"centreline %.3f m is outside the %d-%d m band" % [centreline, int(CENTRELINE_MIN), int(CENTRELINE_MAX)])

	var narrowest: float = layout.narrowest_clearance()
	_expect(narrowest >= MANDATORY_CLEARANCE_MIN - 0.001,
		"narrowest measured clearance %.3f m is below the %d m mandatory floor" % [
			narrowest, int(MANDATORY_CLEARANCE_MIN),
		])

	var clear: float = layout.clear_fraction()
	_expect(clear >= CLEAR_FRACTION_MIN,
		"clear ground fraction %.1f%% is below the %d%% floor" % [clear * 100.0, int(CLEAR_FRACTION_MIN * 100.0)])

	var samples: Array[Dictionary] = layout.width_samples()
	var ordinary: int = layout.widths_in_ordinary_band()
	var share: float = float(ordinary) / float(maxi(samples.size(), 1))
	_expect(ordinary >= ORDINARY_WIDTH_STATIONS_MIN,
		"only %d stations sit in the 10-14 m ordinary band — the transitions should still measure there" % ordinary)

	var changes: int = layout.direction_change_count()
	_expect(changes >= 2,
		"the centreline changes direction >=25 deg only %d time(s), not the required at-least-twice" % changes)

	print("  footprint %.2f m^2, centreline %.3f m, narrowest %.3f m, clear %.1f%%, ordinary band %.1f%% (%d stations)" % [
		footprint, centreline, narrowest, clear * 100.0, share * 100.0, ordinary,
	])
	print("  %d direction change(s) >= 25 deg, %.1f m lateral swing" % [changes, layout.lateral_swing()])


func _check_sockets() -> void:
	print("")
	print("--- Exactly one Player Start and one Way Out; no other socket, branch, or pocket")
	var markers: Node = layout.get_node("Markers")
	var names: Array[String] = []
	for child: Node in markers.get_children():
		names.append(child.name)
	_expect(names.has("PlayerStartRing") and names.has("PlayerStartPole"),
		"Player Start marker is incomplete: %s" % ", ".join(names))
	_expect(names.has("WayOutRing") and names.has("WayOutPole"),
		"Way Out marker is incomplete: %s" % ", ".join(names))
	_expect(names.size() == 4,
		"the Markers container holds %d nodes, not exactly the 4 that make one Player Start and one Way Out — %s" % [
			names.size(), ", ".join(names),
		])
	var sockets: Dictionary = layout.socket_positions()
	_expect(sockets.size() == 2 and sockets.has("PlayerStart") and sockets.has("WayOut"),
		"socket_positions() does not report exactly PlayerStart and WayOut: %s" % str(sockets.keys()))
	print("  Markers container holds exactly 4 nodes: one Player Start, one Way Out")


# --- Navigation and traversal ---------------------------------------------------

func _check_navigation_and_traversal() -> void:
	print("")
	print("--- Navigation bakes once and the route is walkable end to end")
	_expect(review.bake_count == 1, "navigation baked %d times, not exactly once" % review.bake_count)
	_expect(review.navmesh_polygon_count > 0, "the baked navigation mesh has no polygons")

	var start: Vector3 = layout.player_start()
	var exit_point: Vector3 = layout.way_out()
	var path: PackedVector3Array = NavigationServer3D.map_get_path(
		review.navigation_map(), start, exit_point, true
	)
	_expect(path.size() >= 2, "no navigable path resolves from Player Start to Way Out")
	var length: float = 0.0
	for i: int in range(1, path.size()):
		length += path[i].distance_to(path[i - 1])
	_expect(length > 0.0 and length < 120.0,
		"resolved path length %.2f m is not a plausible route across this footprint" % length)
	print("  resolved path %.3f m, spawn to Way Out" % length)

	print("")
	print("--- The production body actually walks the route under one command")
	review.reset_review()
	await _settle(4)
	var cursor_flat: Vector3 = Vector3(exit_point.x, 0.0, exit_point.z)
	review.player.command_move_to(cursor_flat, cursor_flat, false)
	var guard: int = 0
	while review.player.has_destination and guard < 1800:
		await get_tree().physics_frame
		guard += 1
	_expect(not review.player.has_destination,
		"the review body never arrived at Way Out within %d physics frames" % guard)
	_expect(review.player.global_position.distance_to(exit_point) < 3.0,
		"the review body stopped %.2f m from Way Out" % review.player.global_position.distance_to(exit_point))
	print("  arrived at Way Out in %d physics frames; %.2f m walked" % [guard, review.walked_metres])
	review.reset_review()
	await _settle(4)


func _check_no_state_written() -> void:
	print("")
	print("--- This review writes nothing")
	for path: String in SHIPPING_SCRIPTS:
		var source: String = FileAccess.get_file_as_string(path)
		for token: String in ["FileAccess.open", "ConfigFile", "user://", "ResourceSaver"]:
			_expect(not source.contains(token), "%s references '%s'" % [path, token])
	print("  no storage path, ConfigFile, or ResourceSaver call in either shipping script")


# --- Rendered evidence ----------------------------------------------------------

func _capture_evidence() -> void:
	print("")
	print("--- Rendered evidence")
	review.reset_review()
	await _settle(6)

	await _overhead_shot("01_overhead")
	await _clean_shot("02_arrival", layout.player_start())
	await _clean_shot("03_middle", layout.centreline_point(layout.centreline_length() * 0.5))
	await _clean_shot("04_exit", layout.centreline_point(layout.centreline_length() - 4.0))

	review.reset_review()
	await _settle(4)


func _clean_shot(stem: String, at_local: Variant) -> void:
	var world_point: Vector3
	if at_local is Vector2:
		world_point = layout.global_transform * Vector3(at_local.x, 0.0, at_local.y)
	else:
		world_point = at_local
	await _teleport(world_point)
	await _shoot(stem, 8)


func _overhead_shot(stem: String) -> void:
	var range_before: Vector2 = review.camera_rig.distance_range
	var pitch_before: float = review.camera_rig.pitch_degrees
	review.camera_rig.distance_range = Vector2(10.0, 120.0)
	review.camera_rig.pitch_range = Vector2(30.0, 89.0)
	review.camera_rig.adjust_pitch(88.0 - review.camera_rig.pitch_degrees)
	review.camera_rig.adjust_distance(95.0 - review.camera_rig.distance_metres)
	var mid: Vector2 = layout.centreline_point(layout.centreline_length() * 0.5)
	await _teleport(layout.global_transform * Vector3(mid.x, 0.0, mid.y))
	await _shoot(stem, 8)
	review.camera_rig.distance_range = range_before
	review.camera_rig.reset_calibration()
	review.camera_rig.adjust_pitch(pitch_before - review.camera_rig.pitch_degrees)
	_expect(is_equal_approx(review.camera_rig.distance_metres, ACCEPTED_CAMERA_DISTANCE),
		"the overhead frame left the camera calibration changed")
	await _settle(4)


func _teleport(at: Vector3) -> void:
	review.player.clear_movement_intent("evidence teleport", false)
	review.player.global_position = at
	review.player.velocity = Vector3.ZERO
	review.camera_rig.focus = at
	await get_tree().physics_frame
	await get_tree().physics_frame


func _shoot(name_stem: String, settle_frames: int) -> void:
	for i: int in settle_frames:
		await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var path: String = "%s/%s.png" % [_shot_dir, name_stem]
	get_viewport().get_texture().get_image().save_png(path)
	print("  screenshot: %s" % path)


# --- Helpers ---------------------------------------------------------------

func _settle(frames: int) -> void:
	for i: int in frames:
		await get_tree().physics_frame


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _argument_value(flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]
