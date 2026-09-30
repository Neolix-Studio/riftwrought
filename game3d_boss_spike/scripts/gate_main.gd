extends Node3D

## Assembly and entry point for the D-368 Boss Animation Feasibility Gate.
##
## Everything is built in code. The scene file carries one node, so there is no
## second, silently-diverging source of truth about what the encounter contains.
##
## IT COMPLETES NO PHASE AND AUTHORIZES NOTHING. It is delivered OPEN pending
## owner live review, and the runtime says so on screen and in the log.

var corpus: AnimationLibrary
var arena: Arena
var player: PlayerProbe
var boss: BossPuglin
var control: OrdinaryEnemy
var cam: IsoCamera
var hud: GateHud

## Measured at startup and printed, so the compatibility claim is a live
## measurement rather than a comment.
var rig_report: Dictionary = {}
var required_missing: Array[String] = []
var capture_mode: String = ""

func _ready() -> void:
	_print_header()

	corpus = RigCompat.build_corpus()
	if corpus == null:
		push_error("GATE: the UAL1+UAL2 corpus failed to build")
		return

	_measure_rigs()

	arena = Arena.new()
	arena.name = "Arena"
	add_child(arena)

	player = PlayerProbe.new()
	player.name = "PlayerProbe"
	add_child(player)
	player.setup(corpus, arena)
	player.global_position = Vector3(0, 0, 7.0)
	player.aim_dir = Vector3(0, 0, -1)

	arena.build(corpus, player)

	boss = BossPuglin.new()
	boss.name = "BossPuglin"
	add_child(boss)
	boss.setup(corpus, arena)
	boss.global_position = Vector3(0, 0, -2.0)
	boss.player = player

	control = OrdinaryEnemy.new()
	control.name = "OrdinaryPuglinControl"
	add_child(control)
	control.setup(corpus, OrdinaryEnemy.Kind.PUGLIN_CONTROL)
	control.global_position = Vector3(4.6, 0, -2.0)
	control.player = player

	arena.spawn_initial_imps(GateConfig.IMP_COUNT_PHASE1)

	_refresh_targets()

	cam = IsoCamera.new()
	add_child(cam)
	cam.setup(player)

	hud = GateHud.new()
	hud.name = "GateHud"
	add_child(hud)
	hud.setup()
	hud.boss = boss
	hud.control = control
	hud.player = player
	hud.cam = cam
	hud.arena = arena

	# Verify every clip the gate asks for EXISTS, up front. A typo must never
	# surface as a boss that simply stands still.
	required_missing = RigCompat.verify_required(_any_player(),
		GateConfig.REQUIRED_CLIPS)

	_print_corpus_facts()
	_print_commission_list()
	_print_state()

	capture_mode = _arg_value("--capture")
	if capture_mode != "":
		_run_capture(capture_mode, _arg_value("--out"),
			int(_arg_value("--wait")) if _arg_value("--wait") != "" else 90)
		return

	# A headless smoke run: let the encounter actually tick for N frames and
	# quit. Used by the runner to prove the scene runs error-free without
	# needing a window. Absent in normal play.
	var selftest := _arg_value("--selftest")
	if selftest != "":
		await _run_selftest(int(selftest))

func _any_player() -> AnimationPlayer:
	# The clip check needs any AnimationPlayer carrying the merged corpus; they
	# all carry the same library instance.
	var n := boss.visual().get_node_or_null("GateAnimationPlayer")
	return n as AnimationPlayer

func _refresh_targets() -> void:
	var t: Array = [boss, control]
	for i in arena.imps:
		t.append(i)
	player.targets = t

## LIVE rig measurement. The owner's instruction was explicit -- prove
## compatibility, do not assume it -- so the numbers in the report come from
## here, not from a constant.
func _measure_rigs() -> void:
	var ual_names: Array[String] = []
	var ps := load(RigCompat.UAL2) as PackedScene
	var inst: Node = ps.instantiate()
	add_child(inst)
	var uskel := RigCompat.find_skeleton(inst)
	ual_names = RigCompat.bone_names(uskel)
	var upath := String(inst.get_path_to(uskel)) if uskel != null else ""
	remove_child(inst)
	inst.free()

	var ual1_names: Array[String] = []
	var ps1 := load(RigCompat.UAL1) as PackedScene
	var inst1: Node = ps1.instantiate()
	add_child(inst1)
	var u1skel := RigCompat.find_skeleton(inst1)
	ual1_names = RigCompat.bone_names(u1skel)
	remove_child(inst1)
	inst1.free()

	var subjects := {}
	for entry in [["Puglin", RigCompat.PUGLIN], ["Imp", RigCompat.IMP],
			["Female_Ranger", RigCompat.OUTFIT_RANGER]]:
		var sps := load(entry[1]) as PackedScene
		var si: Node = sps.instantiate()
		add_child(si)
		var sk := RigCompat.find_skeleton(si)
		var names := RigCompat.bone_names(sk)
		var path := String(si.get_path_to(sk)) if sk != null else ""
		var own_anims := 0
		var sap := RigCompat._find_ap(si)
		if sap != null:
			own_anims = sap.get_animation_list().size()
		subjects[entry[0]] = {
			"measure": RigCompat.measure_subset(names, ual_names),
			"skeleton_path": path,
			"own_animations": own_anims,
		}
		remove_child(si)
		si.free()

	rig_report = {
		"ual2_bones": ual_names.size(),
		"ual1_bones": ual1_names.size(),
		"ual1_vs_ual2": RigCompat.measure_subset(ual1_names, ual_names),
		"ual2_vs_ual1": RigCompat.measure_subset(ual_names, ual1_names),
		"ual_skeleton_path": upath,
		"subjects": subjects,
		"library_clip_counts": RigCompat.library_clip_counts.duplicate(),
		"collisions": RigCompat.collisions.duplicate(),
		"combined_distinct": RigCompat.clip_source.size(),
	}

# ------------------------------------------------------------------ input ----

func _unhandled_input(e: InputEvent) -> void:
	if e.is_action_pressed("gate_fire"):
		player.fire()
	elif e.is_action_pressed("gate_zoom_in"):
		cam.zoom(-1.0)
	elif e.is_action_pressed("gate_zoom_out"):
		cam.zoom(1.0)
	elif e.is_action_pressed("gate_overlay_toggle"):
		hud.visible_overlay = not hud.visible_overlay
	elif e.is_action_pressed("gate_restart"):
		get_tree().reload_current_scene()

func _process(_delta: float) -> void:
	# Aim follows the cursor's ground point, independent of movement.
	if player != null and cam != null:
		var g := cam.cursor_ground_point()
		var d := g - player.global_position
		d.y = 0.0
		if d.length() > 0.4:
			player.aim_dir = d.normalized()
	if player != null and Input.is_action_pressed("gate_fire"):
		player.fire()

# ------------------------------------------------------------- printouts ----

func _print_header() -> void:
	print("========================================================================")
	print("RIFTWROUGHT — BOSS ANIMATION FEASIBILITY GATE  (%s, %s)"
		% [GateConfig.GATE_DECISION, GateConfig.GATE_DATE])
	print("========================================================================")
	print("A BOUNDED, ISOLATED FEASIBILITY GATE. It completes no phase and")
	print("authorizes nothing. Every value in it REMAINS PROVISIONAL and is")
	print("NOT A PRODUCT LOCK.")
	for d in GateConfig.DENIALS:
		print("  · %s" % d)
	print("  · %s" % GateConfig.BOSS_NOT_NAME)
	print("")

func _print_corpus_facts() -> void:
	print("------------------------------------------------------------------------")
	print("RIG COMPATIBILITY — MEASURED AT RUNTIME, NOT ASSUMED")
	print("------------------------------------------------------------------------")
	print("  UAL1 bones=%d  UAL2 bones=%d  identical-both-ways=%s"
		% [rig_report["ual1_bones"], rig_report["ual2_bones"],
		   str(rig_report["ual1_vs_ual2"]["absent"].is_empty()
			   and rig_report["ual1_vs_ual2"]["extra"].is_empty())])
	print("  UAL skeleton node path: '%s'" % rig_report["ual_skeleton_path"])
	for k in rig_report["subjects"]:
		var s: Dictionary = rig_report["subjects"][k]
		var m: Dictionary = s["measure"]
		print("  %-14s bones=%d  absent=%d  extra=%d  STRICT SUBSET=%s  path='%s'  own animations=%d"
			% [k, m["subject_count"], m["absent"].size(), m["extra"].size(),
			   str(m["compatible"]), s["skeleton_path"], s["own_animations"]])
	print("  library clip counts: %s   clips present in BOTH: %s"
		% [str(rig_report["library_clip_counts"]), str(rig_report["collisions"])])
	print("  COMBINED DISTINCT CORPUS: %d clips" % rig_report["combined_distinct"])
	print("  required clips missing: %d %s" % [required_missing.size(), str(required_missing)])
	print("")
	print("CORPUS FACTS AND LIMITATIONS, MEASURED:")
	for l in GateConfig.CORPUS_FACTS:
		print("  %s" % l)
	print("")
	print("THE THREE ATTACKS — three different GEOMETRIC CLASSES, not three circles:")
	for a in boss.attacks:
		print("  %s %-6s shape=%-8s motion=%-19s clip=%-20s (%s)  windup=%.2f s  windup speed x%.2f -> release x%.2f"
			% [a["id"], a["design"], Telegraph.shape_name(a["shape"]),
			   BossPuglin.motion_name(a["motion"]), a["clip"],
			   RigCompat.attribute(String(a["clip"])),
			   float(a["windup"]), float(a["windup_speed"]), float(a["release_speed"])])
	print("  The ORDINARY control's entire vocabulary, for contrast: 1 attack, shape=DISC.")
	print("")

func _print_commission_list() -> void:
	print("------------------------------------------------------------------------")
	print("WHAT STILL REQUIRES COMMISSIONED SIGNATURE ANIMATION")
	print("Enumerated, each tied to a measured absence. 'Some polish remains' is")
	print("not an answer, so this list is specific.")
	print("------------------------------------------------------------------------")
	for row in GateConfig.COMMISSION_REQUIRED:
		print("  [%s]" % row[0])
		print("      %s" % row[1])
	print("")

func _print_state() -> void:
	print("------------------------------------------------------------------------")
	print("PLAYER TOP SPEED: %.3f m/s — %s"
		% [GateConfig.TOP_SPEED_MPS, GateConfig.TOP_SPEED_STATUS])
	print("CAMERA: pitch %.1f deg, yaw %.1f deg, orthographic size %.2f m "
		% [GateConfig.CAM_PITCH_DEG, GateConfig.CAM_YAW_DEG, GateConfig.CAM_SIZE_DEFAULT]
		+ "(bounds %.1f-%.1f) — THE ACCEPTED PROVISIONAL FRAMING, CARRIED, STILL PROVISIONAL."
		% [GateConfig.CAM_SIZE_MIN, GateConfig.CAM_SIZE_MAX])
	print("OUTPUT %d x %d IS A COMPARISON OUTPUT, NOT A PRODUCT LOCK."
		% [GateConfig.OUTPUT_WIDTH, GateConfig.OUTPUT_HEIGHT])
	print("SOUND HOOKS: %d named hooks, %d audio assets. HOOKS, NOT SOUNDS."
		% [GateConfig.SOUND_HOOKS.size(), GateConfig.AUDIO_ASSETS_ADDED])
	print("STATE: Boss Animation Feasibility Gate %s" % GateConfig.GATE_STATE)
	print("------------------------------------------------------------------------")

# -------------------------------------------------------------- captures ----

func _arg_value(key: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with(key + "="):
			return a.substr(key.length() + 1)
	return ""

## Rendered evidence. Each capture drives the encounter to a specific, named
## moment and saves the ACTUAL Godot render at native resolution. A composed
## mock-up would prove nothing, so nothing here is composed.
func _run_capture(mode: String, out_path: String, wait_frames: int) -> void:
	if out_path == "":
		out_path = "res://evidence/capture.png"
	# Let the arena settle and the clips start.
	for i in 24:
		await get_tree().process_frame

	match mode:
		"compare":
			# BOSS BESIDE THE ORDINARY CONTROL, both idle and both in frame.
			#
			# The AI is frozen on both, because an earlier version of this
			# capture let the boss start an attack and framed a telegraph
			# instead of the comparison it was named for. The camera is also
			# centred on a midpoint node and snapped, rather than left to lag
			# toward the player and leave the boss half off-screen.
			boss.debug_freeze_ai = true
			boss.debug_suppress_movement = true
			control.player = null
			# PLACED ALONG THE SCREEN-HORIZONTAL AXIS, WHICH IS COMPUTED, NOT
			# GUESSED. At the fixed 45-degree camera yaw the camera's right
			# vector is world (1, 0, -1)/sqrt(2), so two subjects separated
			# along world X alone land on a screen DIAGONAL -- which is what an
			# earlier capture did, putting the boss half off the top edge while
			# the control sat at the bottom. Separating along (1, 0, -1) puts
			# them genuinely side by side.
			# The camera's right axis is basis * (1,0,0) = (cos45, 0, -sin45),
			# so world (1, 0, -1)/sqrt(2) IS screen-right. Both subjects sit on
			# it at the same screen height, and the pair is nudged left so the
			# control does not land under the on-screen text panels.
			var right := Vector3(1, 0, -1).normalized()
			boss.global_position = -right * 1.9
			control.global_position = right * 1.9
			# Both turned to face the camera, so the boss's axe-and-shield
			# silhouette is presented rather than hidden behind its own body.
			boss.rotation.y = deg_to_rad(45.0)
			control.rotation.y = deg_to_rad(45.0)
			boss.set("_yaw", deg_to_rad(45.0))
			# The player probe is moved out of frame: this capture is about the
			# boss and the control, and a third figure of the control's size
			# would only muddle the comparison.
			player.global_position = Vector3(-11.0, 0, 11.0)
			for imp in arena.imps:
				if imp != null and is_instance_valid(imp):
					(imp as Node3D).global_position = Vector3(-24.0, 0, 24.0)
			boss.director().play("idle", GateConfig.CLIP_BOSS_IDLE, 1.0, 0.0, true)
			control.director().play("idle", GateConfig.CLIP_CONTROL_IDLE, 1.0, 0.0, true)
			var mid := Node3D.new()
			mid.name = "CompareFramingAnchor"
			add_child(mid)
			mid.global_position = right * 0.9
			cam.target = mid
			cam.ortho_size = 12.0
			cam.snap_to_target()
			for i in 30:
				await get_tree().process_frame
		"sweep":
			await _capture_telegraph(0, 3.2, GateConfig.Shape.CONE)
		"slam":
			await _capture_telegraph(1, 4.4, GateConfig.Shape.ANNULUS)
		"lance":
			await _capture_telegraph(2, 9.0, GateConfig.Shape.LINE)
		"phase":
			boss.debug_suppress_movement = true
			cam.target = boss
			cam.ortho_size = 12.0
			cam.snap_to_target()
			# Drive health to just above the threshold, then one more hit.
			while boss.phase == 1 and boss.state != BossPuglin.State.PHASE_BREAK:
				boss.take_hit(60.0, 0.0, player.global_position)
				await get_tree().process_frame
			# Mid-transition, while the shield-break clip is running.
			for i in 26:
				await get_tree().process_frame
		"death":
			boss.debug_suppress_movement = true
			cam.target = boss
			cam.ortho_size = 12.0
			cam.snap_to_target()
			boss.take_hit(GateConfig.BOSS_HEALTH + 10.0, 0.0, player.global_position)
			# Mid-clip, so the evidence shows the real 'Death01' in motion.
			for i in 46:
				await get_tree().process_frame
		_:
			for i in wait_frames:
				await get_tree().process_frame

	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	var err := img.save_png(out_path)
	if err != OK:
		push_error("GATE: capture '%s' failed to save to %s (err %d)" % [mode, out_path, err])
	else:
		print("CAPTURE: %s -> %s (%dx%d)" % [mode, out_path, img.get_width(), img.get_height()])
	get_tree().quit(0)

## Forces one attack and waits until its telegraph is at (near) full extent, so
## the evidence shows the danger area the player actually has to read.
##
## `expect_shape` IS NOT DECORATION. An earlier version set `debug_forced_attack`
## without clearing the already-chosen pending attack, so the boss kept winding
## up the attack it had picked BEFORE the override -- and the "slam" capture was
## saved showing the Sweep's CONE under a file named for the ANNULUS. A picture
## that claims to show one thing and shows another is worse than no picture, so
## the capture now refuses to save unless the LIVE telegraph is the shape it was
## named for.
func _capture_telegraph(idx: int, distance: float,
		expect_shape: GateConfig.Shape) -> void:
	boss.debug_freeze_ai = false
	boss.debug_suppress_movement = true
	# Clear the pending choice AND the cooldown, or the override arrives too late.
	boss.debug_forced_attack = idx
	boss.state = BossPuglin.State.IDLE
	boss.set("_pending_attack", -1)
	boss.set("_cooldown", 0.0)
	boss.global_position = Vector3(0, 0, -1.2)
	player.global_position = Vector3(0, 0, -1.2 + distance)
	player.aim_dir = Vector3(0, 0, -1)
	cam.target = player
	cam.ortho_size = GateConfig.CAM_SIZE_DEFAULT
	cam.snap_to_target()
	var guard := 0
	var framed := false
	while guard < 1800:
		guard += 1
		await get_tree().process_frame
		var t := boss.telegraph()
		if boss.state == BossPuglin.State.WINDUP and t != null \
				and is_instance_valid(t) and t.shape == expect_shape \
				and t.progress >= 0.93:
			framed = true
			break
	if not framed:
		push_error("GATE: capture refused -- never reached a %s telegraph at full extent for attack %d"
			% [Telegraph.shape_name(expect_shape), idx])
		get_tree().quit(1)
		return
	for i in 2:
		await get_tree().process_frame

## Ticks the encounter for a bounded number of frames and quits. It drives the
## boss through all three attacks, a stagger, the phase break and death, so a
## headless smoke run exercises the real code paths rather than just _ready().
func _run_selftest(frames: int) -> void:
	print("SELFTEST: ticking %d frames" % frames)
	var f := 0
	while f < frames:
		f += 1
		await get_tree().process_frame
		# Fire as fast as the cooldown allows, so the boss takes sustained
		# pressure and its poise gate is actually reached. The attack rotation
		# is left ALONE -- the point is to prove all three fire naturally.
		if f % 3 == 0:
			player.aim_dir = (boss.global_position - player.global_position).normalized()
			player.fire()
	print("SELFTEST: boss state=%s phase=%d hp=%.0f poise=%.0f attacks_fired=%s hooks=%d"
		% [boss.state_name(), boss.phase, boss.health, boss.poise,
		   str(boss.attacks_fired), boss.hooks_fired.size()])
	print("SELFTEST: shots=%d  boss hits taken=%d  staggers=%d  interrupts=%s"
		% [player.shots_fired, boss.hit_frames.size(), boss.stagger_frames.size(),
		   str(boss.interrupted_attack_ids)])
	print("SELFTEST: control hits=%d  player damage taken=%.0f  boss pos=%s player pos=%s"
		% [control.hit_frames.size(), player.damage_taken,
		   str(boss.global_position.round()), str(player.global_position.round())])
	print("SELFTEST: all boss events:")
	for e in boss.events:
		print("    f%-6d %-22s %s" % [e[2], e[0], e[1]])
	boss.debug_forced_attack = -1
	get_tree().quit(0)
