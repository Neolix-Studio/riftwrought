extends Node
## Riftfall Landing visual review — automated verification.
##
## THIS IS NOT A GATE. It proves what a machine can settle about one isolated,
## non-canonical candidate art pass: that Greybox V2's route, dimensions,
## clearances, camera, collision and navigation are byte-for-byte what they
## were before this pass (measured live, not assumed), that dressing uses only
## registered D-206/D-215 model keys within the approximately-12-type budget
## and no living plant, that the reused presentation components are applied
## without drifting their source materials, and that nothing here writes to
## disk. It does not decide whether the look reads well — only the project
## owner can, after playing it.
##
## Run:  godot --headless --path game res://scenes/first_mvp/visual_review/riftfall_landing_visual_review.tscn -- --verify-visual-review
##       godot --path game --resolution 1920x1080 res://.../riftfall_landing_visual_review.tscn -- --verify-visual-review --shots <dir>

const ACCEPTED_CAMERA_DISTANCE: float = 19.0
const ACCEPTED_CAMERA_PITCH: float = 55.0
const ACCEPTED_CAMERA_FOV: float = 45.0
const ACCEPTED_CAMERA_YAW: float = 45.0
const ACCEPTED_MAX_SPEED: float = 5.0

## Quoted from the accepted V2 report; this run must reproduce them exactly,
## because this scene is built from the SAME unmodified
## `RiftfallLandingGreyboxLayout` class V2 uses.
const V2_FOOTPRINT: float = 1201.00
const V2_CENTRELINE: float = 54.517
const V2_NARROWEST_CLEARANCE: float = 8.000
const V2_CLEAR_FRACTION: float = 0.828
const V2_DIRECTION_CHANGES: int = 4
const V2_LATERAL_SWING: float = 8.0
const V2_ORDINARY_STATIONS: int = 10
const V2_MEDIAN_WIDTH: float = 20.27
const NUMERIC_TOLERANCE: float = 0.01

const MAX_DISTINCT_DRESSING_TYPES: int = 12
const EXPECTED_DISTINCT_DRESSING_TYPES: int = 12

const ALLOWED_DRESSING_KEYS: Array[String] = [
	"wall_pillar", "Rock_1_Q_Color1", "tree_dead_large", "lantern_standing",
	"wall_broken", "wall_cracked", "wall_endcap", "pillar",
	"rubble_large", "Rock_3_R_Color1", "tree_dead_small", "banner_shield_red",
]

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

## This review's own three shipping scripts.
const SHIPPING_SCRIPTS: Array[String] = [
	"res://scripts/first_mvp/visual_review/riftfall_landing_visual_review.gd",
	"res://scripts/first_mvp/visual_review/riftfall_landing_visual_review_dressing.gd",
	"res://scripts/first_mvp/visual_review/riftfall_landing_visual_review_stone.gd",
]

const LELU_FILES: Dictionary = {
	"res://assets/third_party/lelu/noise_pack/T_Cracks336.png":
		"e3e691314752f948e1b47e30c3ab583dddebb19558e2f8352cc6cd9497cc8fda",
	"res://assets/third_party/lelu/noise_pack/T_CloudNoise_Tiled.png":
		"79ea8307f7adab9ec44fa4adc7b2f12969e9ae56afbd262c7f646b77fb660223",
}

var review: RiftfallLandingVisualReview
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
	print("=== Riftfall Landing visual review verification ===")
	await _settle(10)

	_check_accepted_values_untouched()
	_check_input_map_untouched()
	_check_v2_geometry_unchanged()
	_check_sockets()
	await _check_navigation_and_traversal()
	_check_dressing_palette()
	_check_treatment_safety()
	_check_no_state_written()
	_check_lelu_extraction()

	if _shot_dir != "":
		await _capture_evidence()

	print("")
	if _failures.is_empty():
		print("RIFTFALL LANDING VISUAL REVIEW: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFTFALL LANDING VISUAL REVIEW: %d FAILURE(S) of %d checks" % [
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


# --- V2 geometry is exactly what it was ---------------------------------------

func _check_v2_geometry_unchanged() -> void:
	print("")
	print("--- Greybox V2's own route, dimensions and clearances are unchanged")
	var footprint: float = layout.footprint_area()
	_expect(absf(footprint - V2_FOOTPRINT) < NUMERIC_TOLERANCE,
		"footprint %.2f m^2 has drifted from V2's accepted %.2f m^2" % [footprint, V2_FOOTPRINT])

	var centreline: float = layout.centreline_length()
	_expect(absf(centreline - V2_CENTRELINE) < NUMERIC_TOLERANCE,
		"centreline %.3f m has drifted from V2's accepted %.3f m" % [centreline, V2_CENTRELINE])

	var narrowest: float = layout.narrowest_clearance()
	_expect(absf(narrowest - V2_NARROWEST_CLEARANCE) < NUMERIC_TOLERANCE,
		"narrowest measured clearance %.3f m has drifted from V2's accepted %.3f m" % [
			narrowest, V2_NARROWEST_CLEARANCE,
		])

	var clear: float = layout.clear_fraction()
	_expect(absf(clear - V2_CLEAR_FRACTION) < 0.001,
		"clear ground fraction %.3f has drifted from V2's accepted %.3f" % [clear, V2_CLEAR_FRACTION])

	var changes: int = layout.direction_change_count()
	_expect(changes == V2_DIRECTION_CHANGES,
		"direction change count %d has drifted from V2's accepted %d" % [changes, V2_DIRECTION_CHANGES])

	var swing: float = layout.lateral_swing()
	_expect(absf(swing - V2_LATERAL_SWING) < NUMERIC_TOLERANCE,
		"lateral swing %.2f m has drifted from V2's accepted %.2f m" % [swing, V2_LATERAL_SWING])

	var ordinary: int = layout.widths_in_ordinary_band()
	_expect(ordinary == V2_ORDINARY_STATIONS,
		"ordinary-band station count %d has drifted from V2's accepted %d" % [ordinary, V2_ORDINARY_STATIONS])

	var median: float = layout.median_width()
	_expect(absf(median - V2_MEDIAN_WIDTH) < 0.01,
		"median width %.2f m has drifted from V2's accepted %.2f m" % [median, V2_MEDIAN_WIDTH])

	print("  footprint %.2f m^2, centreline %.3f m, narrowest %.3f m, clear %.1f%% — identical to V2" % [
		footprint, centreline, narrowest, clear * 100.0,
	])
	print("  %d direction change(s), %.1f m lateral swing, %d ordinary stations, %.2f m median — identical to V2" % [
		changes, swing, ordinary, median,
	])


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
	_expect(not markers.visible,
		"diagnostic markers are visible by default in the visual-review candidate")
	var sockets: Dictionary = layout.socket_positions()
	_expect(sockets.size() == 2 and sockets.has("PlayerStart") and sockets.has("WayOut"),
		"socket_positions() does not report exactly PlayerStart and WayOut: %s" % str(sockets.keys()))
	print("  Markers container holds exactly 4 nodes (hidden for the visual pass, unchanged in count)")


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


# --- Dressing palette ----------------------------------------------------------

func _check_dressing_palette() -> void:
	print("")
	print("--- Dressing uses only registered D-206/D-215 keys, within budget, no living plant")
	var dressing: RiftfallLandingVisualReviewDressing = review.dressing
	var used: PackedStringArray = dressing.used_keys()
	_expect(dressing.distinct_type_count() <= MAX_DISTINCT_DRESSING_TYPES,
		"%d distinct dressing types exceeds the approximately-%d-type budget" % [
			dressing.distinct_type_count(), MAX_DISTINCT_DRESSING_TYPES,
		])
	_expect(dressing.distinct_type_count() == EXPECTED_DISTINCT_DRESSING_TYPES,
		"%d distinct dressing types, not the declared %d" % [
			dressing.distinct_type_count(), EXPECTED_DISTINCT_DRESSING_TYPES,
		])
	for key: String in used:
		_expect(ALLOWED_DRESSING_KEYS.has(key), "dressing used an undeclared key '%s'" % key)
		var lower: String = key.to_lower()
		var mentions_tree: bool = lower.contains("tree")
		var is_dead_or_bare: bool = lower.contains("dead") or lower.contains("bare")
		_expect(not mentions_tree or is_dead_or_bare,
			"dressing key '%s' names a tree that is neither dead nor bare — no living plant is permitted" % key)
	_expect(dressing.instance_count() > 0, "the dressing pass placed no instances at all")
	print("  %d instance(s) across exactly %d distinct registered model type(s)" % [
		dressing.instance_count(), dressing.distinct_type_count(),
	])
	print("  every used key resolves through RiftfallLandingLayout.payload() or approved_environment_palette.gd")


# --- Reused presentation components, applied without drift --------------------

func _check_treatment_safety() -> void:
	print("")
	print("--- ExteriorReviewTreatment applies the accepted look without drifting a source material")
	_expect(review.treatment.candidate_active(), "the accepted candidate treatment is not active")
	_expect(review.treatment.drifted_sources().is_empty(),
		"%d source material(s) drifted: %s" % [
			review.treatment.drifted_sources().size(), ", ".join(review.treatment.drifted_sources()),
		])
	_expect(review.treatment.surface_count() > 0, "no surface was registered with the treatment")
	_expect(review.lighting.mode == ExteriorReviewLighting.Mode.CANDIDATE,
		"the accepted candidate exterior lighting is not active")
	print("  %d surface(s) registered, 0 drifted, candidate lighting and treatment both active" % (
		review.treatment.surface_count()
	))


func _check_no_state_written() -> void:
	print("")
	print("--- This review writes nothing")
	for path: String in SHIPPING_SCRIPTS:
		var source: String = FileAccess.get_file_as_string(path)
		_expect(not source.is_empty(), "could not read %s for the source scan" % path)
		for token: String in ["FileAccess.open", "ConfigFile", "user://", "ResourceSaver"]:
			_expect(not source.contains(token), "%s references '%s'" % [path, token])
	print("  no storage path, ConfigFile, or ResourceSaver call in any of this review's 3 shipping scripts")


func _check_lelu_extraction() -> void:
	print("")
	print("--- Exactly the minimum useful LeLu's Noise Pack files, byte-identical")
	for path: String in LELU_FILES:
		_expect(FileAccess.file_exists(path), "expected LeLu texture missing: %s" % path)
		var digest: String = FileAccess.get_sha256(path)
		_expect(digest == LELU_FILES[path],
			"%s has SHA-256 %s, not the expected %s" % [path, digest, LELU_FILES[path]])
	var note: String = FileAccess.get_file_as_string("res://assets/third_party/lelu/SOURCE_AND_LICENSE.md")
	_expect(not note.is_empty(), "the LeLu source-and-license note is missing or empty")
	_expect(note.contains("C7656131-73384949-8DAF97C7-B89D485A"),
		"the LeLu source-and-license note does not record the owner-provided licence code")
	_expect(note.contains("NOT required"), "the LeLu source-and-license note does not state attribution is not required")
	print("  %d LeLu texture(s) present, byte-identical, source-and-license note complete" % LELU_FILES.size())


# --- Rendered evidence ----------------------------------------------------------

func _capture_evidence() -> void:
	print("")
	print("--- Rendered evidence")
	review.reset_review()
	await _settle(6)

	await _overhead_shot("01_overhead")
	await _clean_shot("02_arrival", layout.player_start())
	await _clean_shot("03_procession", layout.centreline_point(33.0))
	await _clean_shot("04_breach", layout.centreline_point(layout.centreline_length() - 4.0))

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
	review.camera_rig.adjust_pitch(80.0 - review.camera_rig.pitch_degrees)
	review.camera_rig.adjust_distance(70.0 - review.camera_rig.distance_metres)
	var mid: Vector2 = layout.centreline_point(27.0)
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
