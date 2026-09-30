extends Node3D
## Reference Landing Recreation -- Session 7 rendered-evidence preview
## (NON-CANONICAL).
##
## EVIDENCE SCAFFOLDING ONLY, not Session 8's real assembly, exactly like
## Session 6's `preview_capture.gd` (which this file deliberately does not
## edit -- see this concept's own "don't touch a prior session's file"
## discipline). Builds Sessions 1-6's layouts fresh onto itself, then
## `ReferenceLandingVfxLayout` on top, adds the project's accepted camera rig
## COMPLETELY UNCHANGED, and takes TWO screenshots several seconds of
## simulated time apart so the crack shader's pulse and the flicker light's
## random steps both visibly differ between them -- the "a couple frames
## apart showing the effect actually animating" the session brief's
## definition of done asks for.
##
## Run headless first to prove it parses and runs with zero SCRIPT ERROR. No
## --quit flag: that would end the process after the first idle frame, before
## this script's own awaited build-and-settle chain finishes, so exit is left
## entirely to this script's own get_tree().quit() call.
##   godot --headless --path game --import
##   godot --headless --path game \
##     res://scenes/concepts/reference_landing_recreation/vfx_preview.tscn
##
## Then non-headless, for the actual screenshots:
##   godot --path game --resolution 1920x1080 \
##     res://scenes/concepts/reference_landing_recreation/vfx_preview.tscn \
##     -- --shots <dir>
##
## With no `--shots` argument the scene still builds, settles and quits (the
## headless "does it run" check above), it just skips the `save_png` calls.

## Same framing Session 6 used -- close enough to SPAWN that the rift effect
## reads as the frame's actual subject, while still catching the first
## post_lantern pair at arc 12.
const FOCUS_ARC: float = 5.0

## Simulated seconds between the two screenshots -- long enough that the
## crack shader's pulse (period 2*PI/CRACK_PULSE_SPEED =~ 4.49 s) visibly
## moves and several flicker steps (each 0.05-0.22 s) have certainly fired.
const SECOND_SHOT_DELAY_SECONDS: float = 1.6

var camera_rig: PrototypeCameraRig
var vfx_layout: ReferenceLandingVfxLayout


func _ready() -> void:
	var shot_dir: String = _argument_value("--shots")

	ReferenceLandingGroundLayout.new().build(self)
	ReferenceLandingBoundaryLayout.new().build(self)
	ReferenceLandingArchitectureLayout.new().build(self)
	ReferenceLandingPropsLayout.new().build(self)
	ReferenceLandingLightingLayout.new().build(self)
	vfx_layout = ReferenceLandingVfxLayout.new()
	vfx_layout.build(self)

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
	print("=== Reference Landing Recreation -- Session 7 VFX preview ===")
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

	# physics_frame, not frame_post_draw: this must also complete headless,
	# where nothing is ever rendered and frame_post_draw would never fire.
	await _settle(30)

	if shot_dir != "":
		# Only reached with --shots, i.e. only on a real (non-headless) render
		# -- frame_post_draw is safe here and gives the renderer time to
		# actually draw the settled scene before the texture is read back.
		await _capture(shot_dir, "session7_vfx_a", 0.0)
		await _settle_seconds(SECOND_SHOT_DELAY_SECONDS)
		await _capture(shot_dir, "session7_vfx_b", SECOND_SHOT_DELAY_SECONDS)

	print("PREVIEW: %s" % ("PASS" if camera_ok else "FAIL: camera rig does not match the accepted values"))
	get_tree().quit(0 if camera_ok else 1)


func _capture(shot_dir: String, label: String, elapsed_seconds: float) -> void:
	for i: int in 8:
		await RenderingServer.frame_post_draw
	var path: String = "%s/reference_landing_recreation_%s.png" % [shot_dir, label]
	get_viewport().get_texture().get_image().save_png(path)
	print("screenshot at simulation_seconds=%.3f (real elapsed %.3f s): %s" % [
		vfx_layout.simulation_seconds, elapsed_seconds, path,
	])


func _settle(frames: int) -> void:
	for i: int in frames:
		await get_tree().physics_frame


## Settles by wall-clock seconds rather than a frame count, so the two
## screenshots are guaranteed to be `SECOND_SHOT_DELAY_SECONDS` of real
## (and, since `vfx_layout` is a live tree member, simulated) time apart
## regardless of the machine's actual frame rate.
func _settle_seconds(seconds: float) -> void:
	var start_ticks: int = Time.get_ticks_msec()
	var target_ms: int = int(seconds * 1000.0)
	while Time.get_ticks_msec() - start_ticks < target_ms:
		await get_tree().physics_frame


func _argument_value(flag: String) -> String:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	for i: int in args.size():
		if args[i] == flag and i + 1 < args.size():
			return args[i + 1]
	return ""
