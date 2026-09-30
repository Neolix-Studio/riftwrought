class_name SpikeCapture
extends RefCounted

## RENDERED EVIDENCE — each capture WAITS FOR ITS STATE, never for a frame count.
##
## game3d/'s first "telegraph" capture contained no telegraph: a fixed frame
## count landed wherever the cycle happened to be. So every capture here waits
## until the thing it photographs is TRUE -- the phase, the release frame, the
## Prey, the hound at its target -- then PAUSES the world (rendering continues)
## and saves the frame. The developer overlay is hidden in every capture; the
## compact HUD is shown, because it is the review surface.

static func run(main: SpikeMain, mode: String, out: String) -> void:
	# THE WORLD MUST ACTUALLY PAUSE. An earlier draft set the root to always
	# process -- which every child inherits -- so "paused" froze nothing and the
	# "release frame" landed in RECOVERY. The coroutine resumes on SceneTree
	# signals, which fire while paused, so no node needs to stay unpaused.
	main.overlay.set_enabled(false)
	var tree := main.get_tree()
	var p := main.probe
	await _frames(tree, 30)
	match mode:
		"look":
			main.inset.set_enabled(true)
			await _phys(tree, 20)
		"e01_run":
			main.inset.set_enabled(true)
			p.global_position = Vector3(-9.0, 0, 6.0)
			main.hound.global_position = Vector3(-10.0, 0, 7.2)
			main.cam.snap_to_target()
			main.cam.debug_cursor_override = Vector3(40.0, 0, 6.0)
			p.intent.debug_move_axis = _camera_relative(main, Vector3(1, 0, 0))
			await _until(tree, func(): return p.driver.phase == "RUN" and p.motor.speed() > 3.8, 240)
			await _phys(tree, 17)
		"e02_draw", "e03_release", "e04_recovery":
			main.inset.set_enabled(true)
			# Far enough back that target A is OUTSIDE the hound's reach, so the
			# stand-in does not run through the line of fire in these frames.
			p.global_position = Vector3(-1.0, 0, 4.6)
			main.hound.global_position = p.global_position + Vector3(1.2, 0, 1.0)
			main.cam.snap_to_target()
			main.cam.debug_cursor_override = main.target_a.global_position + Vector3(0, 0, 0)
			await _phys(tree, 20)
			var released_before := p.arrows_released
			p.begin_bow_shot()
			if mode == "e02_draw":
				await _until(tree, func(): return p.driver.phase == "HOLD", 400)
			elif mode == "e03_release":
				await _until(tree, func(): return p.arrows_released > released_before, 400)
			else:
				await _until(tree, func(): return p.driver.phase == "RECOVERY" and p.driver.tau > p.driver.t_rel + 0.40, 600)
		"e06_prey_a", "e07_prey_b", "e08_hound_a", "e09_hound_b":
			var hound_mode := mode.begins_with("e08") or mode.begins_with("e09")
			# Standing between the targets, both within the hound's reach; the
			# accepted camera at its WIDEST accepted zoom, so both targets and the
			# PREY word are in frame.
			p.global_position = Vector3(0.0, 0, 1.0)
			main.hound.global_position = p.global_position + Vector3(0.9, 0, 0.9)
			main.cam.apply_zoom(20.0)
			main.cam.snap_to_target()
			await _phys(tree, 10)
			await _shoot_until_prey(main, main.target_a)
			if mode == "e07_prey_b" or mode == "e09_hound_b":
				await _shoot_until_prey(main, main.target_b)
			var want: TargetDummy = main.target_b if (mode == "e07_prey_b" or mode == "e09_hound_b") else main.target_a
			main.cam.debug_cursor_override = null
			if hound_mode:
				await _until(tree, func(): return main.hound.target == want and main.hound.speed < 0.01 \
					and main.hound.bites > 0, 900)
				await _phys(tree, 6)
			else:
				await _phys(tree, 24)
		"e10_hound_autonomous":
			# THE OTHER HALF OF THE RULE: the Prey is OUT OF REACH, so the hound
			# takes the nearer target autonomously -- and the HUD says why.
			p.global_position = Vector3(4.2, 0, 1.2)
			main.hound.global_position = p.global_position + Vector3(0.9, 0, 0.9)
			main.cam.apply_zoom(20.0)
			main.cam.snap_to_target()
			await _phys(tree, 10)
			await _shoot_until_prey(main, main.target_a)
			main.cam.debug_cursor_override = null
			await _until(tree, func(): return main.hound.target == main.target_b \
				and main.hound.target_reason == "AUTONOMOUS" and main.hound.speed < 0.01 and main.hound.bites > 0, 900)
			await _phys(tree, 6)
		"e05_lineup_profile_right", "e05_lineup_front_right":
			await SpikeLineup.build_and_frame(main, mode == "e05_lineup_profile_right")
		"e05_raw_vs_corrected":
			await SpikeLineup.build_and_frame(main, true, true)
		"e01a_draw_filmstrip":
			await SpikeLineup.build_filmstrip(main)
		_:
			await _phys(tree, 10)
	tree.paused = true
	await _frames(tree, 3)
	await RenderingServer.frame_post_draw
	var img := main.get_viewport().get_texture().get_image()
	img.save_png(out)
	print("CAPTURE: %s -> %s (%dx%d, developer overlay hidden)" % [mode, out, img.get_width(), img.get_height()])

static func _camera_relative(main: SpikeMain, world_dir: Vector3) -> Vector2:
	# The accepted controller maps the left stick through the camera's locked
	# basis; invert that mapping so the capture can ask for a WORLD direction.
	var b := main.cam.locked_basis()
	var fwd := -b.z; fwd.y = 0.0; fwd = fwd.normalized()
	var right := b.x; right.y = 0.0; right = right.normalized()
	return Vector2(world_dir.dot(right), -world_dir.dot(fwd)).normalized()

static func _shoot_until_prey(main: SpikeMain, t: TargetDummy) -> void:
	var tree := main.get_tree()
	main.cam.debug_cursor_override = t.global_position
	await _phys(tree, 12)
	var guard := 0
	while main.prey.current != t and guard < 6:
		guard += 1
		await _until(tree, func(): return not main.probe.commitment.active, 600)
		main.probe.begin_bow_shot()
		await _until(tree, func(): return main.prey.current == t, 240)

static func _until(tree: SceneTree, cond: Callable, max_frames: int) -> bool:
	var g := 0
	while g < max_frames:
		if bool(cond.call()):
			return true
		await tree.physics_frame
		g += 1
	# A capture that did not reach its state proves nothing. Said as an ERROR so
	# the runner's error guard refuses the run.
	push_error("CAPTURE: the waited-for state never arrived — this frame proves nothing")
	return false

static func _phys(tree: SceneTree, n: int) -> void:
	for i in n:
		await tree.physics_frame

static func _frames(tree: SceneTree, n: int) -> void:
	for i in n:
		await tree.process_frame
