extends Node3D
## Reference Landing Recreation -- rendered-evidence preview (NON-CANONICAL).
##
## EVIDENCE SCAFFOLDING ONLY, not Session 8's real assembly. It exists purely so
## Session 6 (and any later session that also owes a screenshot) can look at a
## real render instead of trusting geometry it never saw. Session 8 still does
## the actual combine into the concept's own
## `reference_landing_recreation.tscn` -- see
## docs/concepts/reference_landing_recreation/08_integration_and_playtest.md.
##
## Builds Sessions 1-6's layouts (ground, roads/boundaries, architecture, props,
## lighting) fresh onto itself every run, adds the project's accepted camera rig
## COMPLETELY UNCHANGED -- `res://scripts/camera/prototype_camera_rig.gd`, whose
## own `@export` defaults are the D-175 locked values (19 m / 55 deg pitch /
## 45 deg FOV / 45 deg yaw) -- and never sets `distance_metres`, `pitch_degrees`,
## `fov_degrees` or `yaw_degrees` anywhere in this file. Prints the rig's actual
## live values every run so "byte-identical to the accepted rig" is a printed
## fact, not a claim.
##
## Run headless first to prove it parses and runs with zero SCRIPT ERROR. No
## --quit flag: that would end the process after the first idle frame, before
## this script's own awaited build-and-settle chain finishes, so exit is left
## entirely to this script's own get_tree().quit() call.
##   godot --headless --path game --import
##   godot --headless --path game \
##     res://scenes/concepts/reference_landing_recreation/reference_landing_recreation_preview.tscn
##
## Then non-headless, for the actual screenshot:
##   godot --path game --resolution 1920x1080 \
##     res://scenes/concepts/reference_landing_recreation/reference_landing_recreation_preview.tscn \
##     -- --shots <dir>
##
## With no `--shots` argument the scene still builds, settles and quits (the
## headless "does it run" check above), it just skips the `save_png` call.

## How far along the route to aim the camera -- close enough to SPAWN that the
## rift glow disc reads as the frame's actual subject rather than a sliver at
## its edge, while the ~28 x 21 m accepted camera footprint (see
## PrototypeCameraRig.ground_footprint()) still reaches forward far enough to
## catch the first post_lantern pair at arc 12. Matches how Gate 1C's own
## evidence takes its "arrival" shot near the player's actual start rather than
## at an arbitrary midpoint.
const FOCUS_ARC: float = 5.0

var camera_rig: PrototypeCameraRig


func _ready() -> void:
	var shot_dir: String = _argument_value("--shots")

	ReferenceLandingGroundLayout.new().build(self)
	ReferenceLandingBoundaryLayout.new().build(self)
	ReferenceLandingArchitectureLayout.new().build(self)
	ReferenceLandingPropsLayout.new().build(self)
	ReferenceLandingLightingLayout.new().build(self)

	var focus_target: Marker3D = Marker3D.new()
	focus_target.name = "FocusTarget"
	focus_target.position = ReferenceLandingGroundLayout.position_at_arc(FOCUS_ARC)
	add_child(focus_target)

	camera_rig = PrototypeCameraRig.new()
	camera_rig.name = "CameraRig"
	add_child(camera_rig)
	await get_tree().process_frame
	camera_rig.set_target(focus_target)

	print("")
	print("=== Reference Landing Recreation -- Session 6 preview ===")
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

	# physics_frame, not frame_post_draw: this must also complete headless, where
	# nothing is ever rendered and frame_post_draw would never fire.
	await _settle(30)

	if shot_dir != "":
		# Only reached with --shots, i.e. only on a real (non-headless) render --
		# frame_post_draw is safe here and gives the renderer time to actually
		# draw the settled scene before the texture is read back.
		for i: int in 8:
			await RenderingServer.frame_post_draw
		var path: String = "%s/reference_landing_recreation_session6_lighting.png" % shot_dir
		get_viewport().get_texture().get_image().save_png(path)
		print("screenshot: %s" % path)

	print("PREVIEW: %s" % ("PASS" if camera_ok else "FAIL: camera rig does not match the accepted values"))
	get_tree().quit(0 if camera_ok else 1)


func _settle(frames: int) -> void:
	for i: int in frames:
		await get_tree().physics_frame


func _argument_value(flag: String) -> String:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	for i: int in args.size():
		if args[i] == flag and i + 1 < args.size():
			return args[i + 1]
	return ""
