extends Node3D
## Reference Landing Recreation -- Session 8 integration review (NON-CANONICAL).
##
## EVIDENCE SCAFFOLDING ONLY -- not part of the shipped environment scene,
## exactly like Session 6/7's own `preview_capture.gd` / `vfx_preview.gd`, whose
## shape this file follows. Unlike those two, it does not rebuild the layouts
## inline; it instances the REAL, finished `reference_landing_recreation.tscn`
## as a child, so what gets measured and screenshotted is exactly what ships.
## Adds the project's accepted camera rig COMPLETELY UNCHANGED --
## `res://scripts/camera/prototype_camera_rig.gd`, whose own `@export` defaults
## are the D-175 locked values (19 m / 55 deg pitch / 45 deg FOV / 45 deg yaw)
## -- and never sets `distance_metres`, `pitch_degrees`, `fov_degrees` or
## `yaw_degrees` anywhere in this file. Prints the rig's actual live values
## every run so "byte-identical to the accepted rig" is a printed fact.
##
## Also independently re-measures the achieved centerline length and
## traversal time from the SCENE'S OWN Spawn/Midpoint/Portal marker nodes
## (plus the un-marked BEND waypoint, read from the blueprint since it has no
## node of its own) rather than only trusting
## `ReferenceLandingBlueprint.total_arc_length()` -- the same "don't just check
## the file against itself" discipline `ground_check.gd`'s GAP CHECK already
## uses in this concept.
##
## Run headless first to prove it parses and runs with zero SCRIPT ERROR. No
## --quit flag: that would end the process after the first idle frame, before
## this script's own awaited build-and-settle chain finishes, so exit is left
## entirely to this script's own get_tree().quit() call.
##   godot --headless --path game --import
##   godot --headless --path game \
##     res://scenes/concepts/reference_landing_recreation/reference_landing_recreation_review.tscn
##
## Then non-headless, for the actual screenshots:
##   godot --path game --resolution 1920x1080 \
##     res://scenes/concepts/reference_landing_recreation/reference_landing_recreation_review.tscn \
##     -- --shots <dir>
##
## With no `--shots` argument the scene still builds, settles and quits (the
## headless "does it run" check above), it just skips the `save_png` calls.

## Same framing Sessions 6/7 used for their own "close to spawn" shot.
const START_ARC: float = 5.0

## Loose tolerance for the "does the scene's own marker match the blueprint
## constant it was authored from" cross-check -- these are hand-typed
## `Transform3D` origins in the `.tscn` compared against `const Vector3`
## values, so equality is expected to be exact, but floating point is floating
## point.
const EPSILON: float = 0.001

var camera_rig: PrototypeCameraRig
var focus_target: Marker3D


func _ready() -> void:
	var shot_dir: String = _argument_value("--shots")

	var real_scene_packed: PackedScene = load(
		"res://scenes/concepts/reference_landing_recreation/reference_landing_recreation.tscn"
	)
	var real_scene: Node3D = real_scene_packed.instantiate()
	add_child(real_scene)

	var spawn: Marker3D = real_scene.find_child("Spawn", false, false)
	var midpoint: Marker3D = real_scene.find_child("Midpoint", false, false)
	var portal: Marker3D = real_scene.find_child("Portal", false, false)
	assert(
		spawn != null and midpoint != null and portal != null,
		"integration_review: Spawn/Midpoint/Portal marker missing from the real scene"
	)

	focus_target = Marker3D.new()
	focus_target.name = "FocusTarget"
	focus_target.position = ReferenceLandingGroundLayout.position_at_arc(START_ARC)
	add_child(focus_target)

	camera_rig = PrototypeCameraRig.new()
	camera_rig.name = "CameraRig"
	add_child(camera_rig)
	await get_tree().process_frame
	camera_rig.set_target(focus_target)

	print("")
	print("=== Reference Landing Recreation -- Session 8 integration review ===")
	print("camera rig: yaw=%.4f pitch=%.4f fov=%.4f distance=%.4f" % [
		camera_rig.yaw_degrees, camera_rig.pitch_degrees,
		camera_rig.fov_degrees, camera_rig.distance_metres,
	])
	print("accepted (D-175, locked): yaw=45.0000 pitch=55.0000 fov=45.0000 distance=19.0000")
	var camera_ok: bool = (
		is_equal_approx(camera_rig.yaw_degrees, 45.0)
		and is_equal_approx(camera_rig.pitch_degrees, 55.0)
		and is_equal_approx(camera_rig.fov_degrees, 45.0)
		and is_equal_approx(camera_rig.distance_metres, 19.0)
	)
	print("camera matches the accepted rig byte-for-byte: %s" % ("YES" if camera_ok else "NO"))

	var spawn_ok: bool = spawn.position.distance_to(ReferenceLandingBlueprint.SPAWN) < EPSILON
	var midpoint_ok: bool = (
		midpoint.position.distance_to(ReferenceLandingBlueprint.MIDPOINT) < EPSILON
	)
	var portal_ok: bool = portal.position.distance_to(ReferenceLandingBlueprint.PORTAL) < EPSILON
	print("")
	print("Spawn marker matches blueprint constant:    %s  (%s)" % [spawn_ok, spawn.position])
	print("Midpoint marker matches blueprint constant: %s  (%s)" % [midpoint_ok, midpoint.position])
	print("Portal marker matches blueprint constant:   %s  (%s)" % [portal_ok, portal.position])

	# Achieved centerline length: Spawn -> Midpoint -> BEND -> Portal, reading
	# Spawn/Midpoint/Portal from the SCENE'S OWN marker nodes and only BEND
	# (which has no marker of its own -- see 01_blueprint_and_markers.md) from
	# the blueprint constant.
	var achieved_length: float = (
		spawn.position.distance_to(midpoint.position)
		+ midpoint.position.distance_to(ReferenceLandingBlueprint.BEND)
		+ ReferenceLandingBlueprint.BEND.distance_to(portal.position)
	)
	var blueprint_length: float = ReferenceLandingBlueprint.total_arc_length()
	var traversal_seconds: float = achieved_length / 5.0
	print("")
	print("achieved centerline length (scene markers + BEND): %.4f m" % achieved_length)
	print("ReferenceLandingBlueprint.total_arc_length():       %.4f m" % blueprint_length)
	print(
		"length agreement (scene markers vs blueprint constants): %s"
		% (absf(achieved_length - blueprint_length) < EPSILON)
	)
	print("target: approximately 150 m")
	print(
		"estimated direct-traversal time at 5.0 m/s: %.4f s  (target approximately 30 s)"
		% traversal_seconds
	)

	await _settle(30)

	if shot_dir != "":
		await _capture(shot_dir, "start", START_ARC)
		await _retarget_and_capture(shot_dir, "mid", blueprint_length / 2.0)
		await _retarget_and_capture(shot_dir, "gate", blueprint_length)

	var all_ok: bool = camera_ok and spawn_ok and midpoint_ok and portal_ok
	print("")
	print("INTEGRATION REVIEW: %s" % ("PASS" if all_ok else "FAIL"))
	get_tree().quit(0 if all_ok else 1)


func _retarget_and_capture(shot_dir: String, label: String, arc: float) -> void:
	focus_target.position = ReferenceLandingGroundLayout.position_at_arc(arc)
	camera_rig.set_target(focus_target)
	await _settle(10)
	await _capture(shot_dir, label, arc)


func _capture(shot_dir: String, label: String, arc: float) -> void:
	# frame_post_draw, not physics_frame: this must give the renderer time to
	# actually draw the just-moved camera before the texture is read back. Only
	# reached with --shots, i.e. only on a real (non-headless) render, where
	# this signal actually fires.
	for i: int in 8:
		await RenderingServer.frame_post_draw
	var path: String = "%s/reference_landing_recreation_%s.png" % [shot_dir, label]
	get_viewport().get_texture().get_image().save_png(path)
	print("screenshot at arc=%.4f: %s" % [arc, path])


func _settle(frames: int) -> void:
	for i: int in frames:
		await get_tree().physics_frame


func _argument_value(flag: String) -> String:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	for i: int in args.size():
		if args[i] == flag and i + 1 < args.size():
			return args[i + 1]
	return ""
