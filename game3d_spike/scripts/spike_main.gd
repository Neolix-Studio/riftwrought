extends Node3D

## RIFTWROUGHT — BOUNDED 3D FEASIBILITY SPIKE ROOT (D-366, 2026-09-17)
##
## Authorized by the project owner on 2026-09-17 as ONE isolated feasibility
## spike. It is DELIVERED AND OPEN pending owner live review.
##
## IT COMPLETES NO PHASE. It is not the final Huntress, not final art, not the
## 3D production project, not P2, not a completed pivot, not proof that the
## complete game is feasible, and not acceptance of the Quaternius visual style.

signal spike_event(kind: String)

var cam: IsoCamera
var player: HuntressSpike
var courtyard: Courtyard
var hud: SpikeHUD
var enemies: Array[EnemySpike] = []
var arrows_root: Node3D
var loot_root: Node3D

var mode_name: String = "NORMAL ENCOUNTER"
var density_mode: bool = false
var alive_count: int = 0
var enemy_total: int = 0
var loot_count: int = 0

var anim_lib: AnimationLibrary
var event_log: Array[String] = []
var use_eyes := true

const ENEMY_RING_R := 7.4

# --- evidence capture -------------------------------------------------------
# Captures are taken from the ACTUAL GODOT RENDER of this scene. Nothing is
# composed, painted or mocked up.
var _cap_mode: String = ""
var _cap_out: String = ""
var _cap_wait: int = 100
var _frame: int = 0
var _captured: bool = false

func _ready() -> void:
	_print_banner()
	anim_lib = RigAssembly.load_ual2_library()
	if anim_lib == null:
		push_error("SPIKE: UAL2 library unavailable — cannot continue")
		return

	_build_environment()

	courtyard = Courtyard.new()
	courtyard.name = "Courtyard"
	add_child(courtyard)
	courtyard.build()

	arrows_root = Node3D.new(); arrows_root.name = "Arrows"; add_child(arrows_root)
	loot_root = Node3D.new(); loot_root.name = "Loot"; add_child(loot_root)

	player = HuntressSpike.new()
	player.name = "HuntressPlaceholder"
	add_child(player)
	player.setup(anim_lib, use_eyes)
	player.collision_mask = 2 | 4          # enemies + world
	player.arrow_parent = arrows_root
	player.global_position = Vector3(0, 0, 3.0)

	cam = IsoCamera.new()
	cam.name = "IsoCamera"
	add_child(cam)
	cam.target = player
	cam.snap_to_target()
	cam.current = true
	player.cam = cam

	hud = SpikeHUD.new()
	hud.name = "SpikeHUD"
	hud.main = self
	add_child(hud)

	_spawn_encounter(SpikeConfig.ENEMY_COUNT_NORMAL, false)
	_parse_capture_args()
	_log("spike_ready")

func _parse_capture_args() -> void:
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--capture="):
			_cap_mode = a.substr(10)
		elif a.begins_with("--out="):
			_cap_out = a.substr(6)
		elif a.begins_with("--wait="):
			_cap_wait = int(a.substr(7))
	if _cap_mode == "":
		return
	print("SPIKE CAPTURE MODE: %s -> %s (wait %d frames)" % [_cap_mode, _cap_out, _cap_wait])
	match _cap_mode:
		"full":
			cam.zoom_target = SpikeConfig.CAM_SIZE_MAX
			player.global_position = Vector3(0, 0, 1.0)
		"close":
			cam.zoom_target = SpikeConfig.CAM_SIZE_MIN
			player.global_position = Vector3(0, 0, 0.5)
			_ring_enemies(3, 3.1)
		"combat":
			cam.zoom_target = 13.2
			player.global_position = Vector3(0, 0, 2.4)
			_ring_enemies(6, 4.6)
		"density":
			set_density_mode(true)
			cam.zoom_target = SpikeConfig.CAM_SIZE_MAX
			player.global_position = Vector3(0, 0, 0.0)
		"lighting":
			cam.zoom_target = 12.4
			player.global_position = Vector3(4.2, 0, -4.2)
			_ring_enemies(3, 3.8)
	cam.snap_to_target()

func _ring_enemies(n: int, radius: float) -> void:
	for i in range(enemies.size()):
		var e := enemies[i]
		if not is_instance_valid(e):
			continue
		if i < n:
			var ang := TAU * float(i) / float(maxi(n, 1)) - 0.6
			e.global_position = player.global_position + Vector3(
				cos(ang) * radius, 0, sin(ang) * radius)
		else:
			e.global_position = player.global_position + Vector3(
				cos(float(i)) * 8.0, 0, sin(float(i)) * 8.0)

## Drives the scene deterministically for a capture, without faking Input.
func _capture_drive() -> void:
	match _cap_mode:
		"combat":
			# Arrows in flight plus a landed hit, so the capture shows the read
			# under load rather than a posed still.
			if _frame in [46, 58, 70, 82]:
				player.aim_dir = Vector3(0.18, 0, -0.98).normalized()
				player._release_arrow()
			if _frame == 66:
				for e in enemies:
					if is_instance_valid(e):
						e.take_hit(30.0, e.global_position)
						break
		"lighting":
			if _frame % 9 == 0 and _frame > 14:
				player.aim_dir = Vector3(-0.72, 0, 0.69).normalized()
				player._release_arrow()

func _do_capture() -> void:
	_captured = true
	await RenderingServer.frame_post_draw
	var img: Image = get_viewport().get_texture().get_image()
	var dir := _cap_out.get_base_dir()
	if dir != "":
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
	img.save_png(_cap_out)
	print("SPIKE CAPTURE WRITTEN: %s  %dx%d" % [_cap_out, img.get_width(), img.get_height()])
	get_tree().quit()

func _print_banner() -> void:
	print("========================================================================")
	print("RIFTWROUGHT — 3D FEASIBILITY SPIKE  (%s, %s)" % [
		SpikeConfig.SPIKE_DECISION, SpikeConfig.SPIKE_DATE])
	print("STATE: %s" % SpikeConfig.SPIKE_STATE)
	print("BOUNDED + ISOLATED. NOT production, NOT P2, NOT a completed pivot,")
	print("NOT the final Huntress, NOT final art, NOT proof the complete game is")
	print("feasible, NOT acceptance of the Quaternius visual style.")
	print("EVERY TUNING VALUE IS PROVISIONAL.")
	print("TOP SPEED: %.2f m/s REMAINS PROVISIONAL — re-evaluated, not inherited." %
		SpikeConfig.TOP_SPEED_MPS)
	print("  (2D prototype %.1f m/s in a LOCKED 32.00 m footprint; framing-matched" %
		SpikeConfig.TOP_SPEED_2D_PROTOTYPE_MPS)
	print("   equivalent here would be %.3f m/s — STILL AN OPEN OWNER JUDGMENT.)" %
		SpikeConfig.FRAMING_MATCHED_SPEED_MPS)
	print("OUTPUT %d x %d IS A COMPARISON OUTPUT, NOT A PRODUCT LOCK." % [
		SpikeConfig.OUTPUT_WIDTH, SpikeConfig.OUTPUT_HEIGHT])
	for l in SpikeConfig.ANIM_LIMITATIONS:
		print("LIMITATION: %s" % l)
	print("========================================================================")

func _build_environment() -> void:
	var we := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.031, 0.040, 0.064)     # dark blue-gray base
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.250, 0.315, 0.470)  # cold ambient
	env.ambient_light_energy = SpikeConfig.AMBIENT_ENERGY

	env.fog_enabled = true
	env.fog_light_color = Color(0.072, 0.090, 0.135)
	env.fog_density = 0.016
	env.fog_sky_affect = 0.0

	env.tonemap_mode = Environment.TONE_MAPPER_ACES
	env.tonemap_exposure = 1.30
	env.tonemap_white = 5.0

	env.glow_enabled = true
	env.glow_intensity = 0.55
	env.glow_bloom = 0.10
	env.glow_hdr_threshold = 1.05
	env.glow_blend_mode = Environment.GLOW_BLEND_MODE_ADDITIVE

	env.ssao_enabled = true
	env.ssao_radius = 1.3
	env.ssao_intensity = 1.5
	env.ssil_enabled = false
	env.adjustment_enabled = true
	env.adjustment_saturation = 0.84      # ordinary surfaces stay quiet
	env.adjustment_contrast = 1.10

	we.environment = env
	add_child(we)

	# Cold moonlight key. Deliberately weak: the warm torches do the work.
	var sun := DirectionalLight3D.new()
	sun.name = "Moonlight"
	sun.light_color = Color(0.55, 0.67, 1.0)
	sun.light_energy = SpikeConfig.SUN_ENERGY
	sun.rotation_degrees = Vector3(-58, 128, 0)
	sun.shadow_enabled = true
	sun.directional_shadow_max_distance = 60.0
	sun.light_angular_distance = 1.2
	add_child(sun)

	# A weak cold fill from the opposite side so the courtyard floor never goes
	# fully black. PROVISIONAL, and deliberately shadowless so it adds no noise.
	var fill := DirectionalLight3D.new()
	fill.name = "ColdFill"
	fill.light_color = Color(0.42, 0.53, 0.86)
	fill.light_energy = 0.34
	fill.rotation_degrees = Vector3(-42, -52, 0)
	fill.shadow_enabled = false
	add_child(fill)

func _spawn_encounter(count: int, passive: bool) -> void:
	for e in enemies:
		if is_instance_valid(e):
			e.queue_free()
	enemies.clear()
	for c in loot_root.get_children():
		c.queue_free()
	loot_count = 0

	var rng := RandomNumberGenerator.new()
	rng.seed = 424242 + (1 if passive else 0)
	for i in range(count):
		var e := EnemySpike.new()
		e.name = "Imp_%02d" % i
		add_child(e)
		e.setup(anim_lib)
		e.collision_mask = 1 | 4
		e.player = player
		e.passive = passive
		e.loot_scene_owner = loot_root
		e.event_logged.connect(_on_enemy_event)
		var ang := TAU * float(i) / float(count) + rng.randf_range(-0.16, 0.16)
		var rad := ENEMY_RING_R if not passive else rng.randf_range(3.6, 8.6)
		e.global_position = Vector3(cos(ang) * rad, 0.0, sin(ang) * rad - 1.0)
		enemies.append(e)
	enemy_total = count
	alive_count = count
	mode_name = ("DEBUG DENSITY — %d PASSIVE enemies (readability only)" % count) \
		if passive else ("NORMAL ENCOUNTER — %d active enemies" % count)
	_log("encounter_spawned:%d:%s" % [count, "passive" if passive else "active"])

func _on_enemy_event(kind: String, at: Vector3) -> void:
	_log("enemy_%s" % kind)
	if kind == "loot":
		_spawn_loot(at)

func _spawn_loot(at: Vector3) -> void:
	var root := Node3D.new()
	root.name = "Loot_%d" % loot_count
	var mi := MeshInstance3D.new()
	mi.mesh = load(Courtyard.R % "Chest_Gold")
	mi.scale = Vector3.ONE * 0.5
	RigAssembly.tint_all(mi, [
		{"match": "Gold", "color": Color(0.58, 0.42, 0.14), "rough": 0.35,
		 "metal": 0.75, "emission": SpikeConfig.COL_LOOT_WARM, "energy": 1.4},
		{"match": "Wood", "color": Color(0.16, 0.11, 0.07), "rough": 0.9},
	], Color(0.22, 0.17, 0.10))
	root.add_child(mi)
	var beam := MeshInstance3D.new()
	var cyl := CylinderMesh.new()
	cyl.top_radius = 0.34; cyl.bottom_radius = 0.18; cyl.height = 2.6
	beam.mesh = cyl
	beam.position = Vector3(0, 1.3, 0)
	var bm := StandardMaterial3D.new()
	bm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	bm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	bm.albedo_color = Color(SpikeConfig.COL_LOOT_WARM.r, SpikeConfig.COL_LOOT_WARM.g,
		SpikeConfig.COL_LOOT_WARM.b, 0.16)
	bm.emission_enabled = true
	bm.emission = SpikeConfig.COL_LOOT_WARM
	bm.emission_energy_multiplier = 1.5
	beam.material_override = bm
	root.add_child(beam)
	var l := OmniLight3D.new()
	l.light_color = SpikeConfig.COL_LOOT_WARM
	l.light_energy = 2.0
	l.omni_range = 3.4
	l.shadow_enabled = false
	l.position = Vector3(0, 0.5, 0)
	root.add_child(l)
	loot_root.add_child(root)
	root.global_position = Vector3(at.x, 0.06, at.z)
	loot_count += 1

func _log(s: String) -> void:
	event_log.append(s)
	spike_event.emit(s)

func set_density_mode(on: bool) -> void:
	density_mode = on
	_spawn_encounter(
		SpikeConfig.ENEMY_COUNT_DENSITY if on else SpikeConfig.ENEMY_COUNT_NORMAL, on)

func _process(_d: float) -> void:
	_frame += 1
	if _cap_mode != "" and not _captured:
		_capture_drive()
		if _frame >= _cap_wait:
			_do_capture()
	if Input.is_action_just_pressed("spike_density_toggle"):
		set_density_mode(not density_mode)
	var n := 0
	for e in enemies:
		if is_instance_valid(e) and e.state != EnemySpike.State.DEAD:
			n += 1
	alive_count = n
