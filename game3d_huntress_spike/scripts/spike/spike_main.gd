class_name SpikeMain
extends Node3D

## RIFTWROUGHT — HUNTRESS BOW-RETARGETING AND PREY FEASIBILITY SPIKE (D-388)
##
## The composition root: it builds the yard, the two target dummies, the
## verbatim accepted camera and controller (with the bow), Prey, the stand-in
## hound, the compact HUD and the hidden developer surfaces -- prints the
## truthfulness banner -- and, in capture mode, renders the evidence.
##
## ============================================================================
## DELIVERED and OPEN pending owner live review. NOT P2. NOT production. NOT
## final Huntress art. NOT VFX intake. NOT tuning. It modifies NO accepted
## project, and it LOCKS NO VALUE.
## ============================================================================

var clip_source: KayKitClipSource
var arena: SpikeArena
var cam: IsoCameraRig
var probe: HuntressSpikeProbe
var prey: PreyState
var hound: StandInHound
var target_a: TargetDummy
var target_b: TargetDummy
var hud: SpikeHud
var overlay: SpikeDevOverlay
var inset: CloseupInset
var world_root: Node3D
var ready_done: bool = false
var build_ok: bool = false
## Toggle counters -- the suite asserts they are reachable.
var comparison_toggles: int = 0
var rate_changes: int = 0

func _ready() -> void:
	_build_environment()
	clip_source = KayKitClipSource.new()
	if not clip_source.load_all():
		push_error("SPIKE: the KayKit clip source did not load the seven authorized clips")
		return

	arena = SpikeArena.new()
	arena.name = "Yard"
	add_child(arena)
	arena.build_geometry()
	arena.build_lights()
	target_a = TargetDummy.new()
	target_a.build("TARGET A", "round", Color(0.62, 0.74, 0.92))
	arena.add_child(target_a)
	target_a.position = SpikeConfig.TARGET_A_POS
	target_b = TargetDummy.new()
	target_b.build("TARGET B", "square", Color(0.90, 0.78, 0.52))
	arena.add_child(target_b)
	target_b.position = SpikeConfig.TARGET_B_POS
	arena.bake()

	world_root = Node3D.new()
	world_root.name = "Projectiles"
	add_child(world_root)

	cam = IsoCameraRig.new()
	cam.name = "CameraRig"
	add_child(cam)
	cam.build()

	probe = HuntressSpikeProbe.new()
	probe.name = "HuntressProbe"
	probe.clip_source = clip_source
	add_child(probe)
	probe.setup(null)
	probe.camera = cam
	probe.bolt_parent = world_root
	probe.arrow_parent = world_root
	probe.on_arrow_hit = _on_arrow_hit
	probe.global_position = SpikeConfig.PLAYER_SPAWN
	cam.target = probe
	cam.snap_to_target()

	prey = PreyState.new()
	prey.name = "PreyState"
	add_child(prey)
	prey.watch(target_a)
	prey.watch(target_b)

	hound = StandInHound.new()
	add_child(hound)
	hound.build()
	hound.huntress = probe
	hound.targets_provider = func() -> Array: return [target_a, target_b]
	hound.connect_prey(prey)
	hound.global_position = SpikeConfig.PLAYER_SPAWN + Vector3(1.3, 0, 1.1)

	hud = SpikeHud.new()
	hud.name = "SpikeHud"
	hud.probe = probe
	hud.prey = prey
	hud.hound = hound
	add_child(hud)
	hud.build()

	overlay = SpikeDevOverlay.new()
	overlay.name = "SpikeDevOverlay"
	overlay.probe = probe
	overlay.prey = prey
	overlay.hound = hound
	add_child(overlay)
	overlay.build()

	inset = CloseupInset.new()
	inset.name = "CloseupInset"
	add_child(inset)
	inset.build(get_viewport().world_3d)
	inset.target = probe.visual

	build_ok = true
	_print_banner()
	ready_done = true
	_maybe_capture()

## THE PREY HOOK -- the arrow's Hit. A DIRECT use, so it may designate.
func _on_arrow_hit(t: Node, use_id: int, _arrow: Node) -> void:
	prey.designate(t, PreyState.DIRECT_USE, use_id)

func _process(_delta: float) -> void:
	if not build_ok:
		return
	if Input.is_action_just_pressed("toggle_overlay"):
		overlay.toggle()
	if Input.is_action_just_pressed("spike_toggle_closeup"):
		inset.toggle()
	if Input.is_action_just_pressed("spike_toggle_comparison"):
		toggle_comparison()
	if Input.is_action_just_pressed("spike_cycle_rate"):
		cycle_rate()

## Changes WHICH body is visible -- and nothing in the simulation (R-03).
func toggle_comparison() -> void:
	probe.set_comparison(not probe.showing_native_control())
	comparison_toggles += 1

## Applies from the NEXT use; a use in progress keeps the rate it began with.
func cycle_rate() -> void:
	probe.cycle_rate()
	rate_changes += 1

func _build_environment() -> void:
	# VALUES CARRIED FROM game3d/'s accepted foundation (foundation_main.gd), all
	# PROVISIONAL: ACES, exposure 1.30, tonemap white 5.0 (the fix for Godot's
	# default 1.0, which washed game3d/'s first captures out), glow and SSAO.
	var we := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.043, 0.055, 0.086)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.250, 0.315, 0.470)
	env.ambient_light_energy = ProdConfig.AMBIENT_ENERGY
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
	we.environment = env
	add_child(we)
	var sun := DirectionalLight3D.new()
	sun.name = "Moonlight"
	sun.light_color = Color(0.62, 0.72, 1.0)
	sun.light_energy = ProdConfig.SUN_ENERGY
	sun.shadow_enabled = true
	sun.rotation_degrees = Vector3(-58, 128, 0)
	add_child(sun)
	var fill := DirectionalLight3D.new()
	fill.name = "Fill"
	fill.light_color = Color(0.55, 0.62, 0.86)
	fill.light_energy = 0.34
	fill.shadow_enabled = false
	fill.rotation_degrees = Vector3(-42, -52, 0)
	add_child(fill)

# ----------------------------------------------------------------- banner ----

func _print_banner() -> void:
	print("========================================================================")
	print("RIFTWROUGHT — %s  (%s, %s)" % [SpikeConfig.STAGE, SpikeConfig.DECISION, SpikeConfig.DATE])
	print("SPIKE STATE: %s" % SpikeConfig.STATE)
	print("========================================================================")
	for d in SpikeConfig.denials():
		print("  %s" % d)
	print("  %s" % SpikeConfig.BOW_ACTION_DENIAL)
	print("  %s" % SpikeConfig.CLASSIFICATION_STATE)
	print("")
	print("EVERY SPIKE VALUE IS DIAGNOSTIC, PROVISIONAL OR MEASURED — NONE IS A LOCK:")
	for row in SpikeConfig.registry():
		print("  %-44s %-24s %s" % [row[0], str(row[1]), row[2]])
	print("")
	var d := probe.driver
	var rt := d.retarget
	print("MEASURED AT START-UP (each by the rule the owed-criteria inventory declares):")
	print("  bow hand: %s  (the hand extended forward at the end of Ranged_Bow_Draw)" % ("LEFT" if d.bow_hand == "l" else "RIGHT"))
	print("  T_full=%.4f s · T_rel=%.4f s · T_total=%.4f s · release marker=%.4f (normalised)" % [
		d.t_full, d.t_rel, d.t_total, d.marker()])
	print("  aim-line offset: Huntress %.2f° · native control %.2f°" % [rad_to_deg(d.alpha_h), rad_to_deg(d.alpha_r)])
	print("  nock moment: Huntress %.4f s (gap %.4f m) · native control %.4f s (gap %.4f m)" % [
		d.nock_tau_h, float(d.measured["huntress"]["nock_gap_m"]),
		d.nock_tau_r, float(d.measured["ranger"]["nock_gap_m"])])
	print("  draw length: Huntress %.3f m · native control %.3f m" % [
		float(d.measured["huntress"]["draw_length_m"]), float(d.measured["ranger"]["draw_length_m"])])
	print("  leg-length ratio (Huntress / source): %.4f" % rt.leg_ratio)
	print("")
	print("THE EXPLICIT RETARGET MAP (BoneMap x2 on SkeletonProfileHumanoid):")
	for p in rt.pairs:
		print("  [PAIR]      %-14s KayKit %-12s -> Huntress %s" % [p["profile"], p["s_name"], p["t_name"]])
	for dd in rt.derived:
		print("  [DERIVED]   Huntress %-12s = halfway between %s and %s" % [dd["name"],
			rt.names[int(dd["a"])], rt.names[int(dd["b"])]])
	print("  [REST-HELD] %d Huntress bones: %s" % [rt.rest_held.size(), ", ".join(rt.rest_held)])
	for u in rt.unmapped_source:
		print("  [UNMAPPED]  KayKit %-12s %s" % [u, SpikeConfig.UNMAPPED_SOURCE.get(u, "")])
	print("")
	print("CLIPS: 7 authorized · %d played · %d present in the files and NOT used:" % [
		SpikeConfig.PLAYED_CLIPS.size(), clip_source.unused_inventory().size()])
	for e in clip_source.unused_inventory():
		print("  [UNUSED] %s :: %s" % [e[0], e[1]])
	print("")
	print("DEFERRED — printed every run, NONE is a pass:")
	for r in SpikeConfig.deferred_rows():
		print("  [DEFERRED] %s  %s  -> returns to: %s" % [r[0], r[1], r[2]])
	print("")
	print("OWED-TO-OWNER — live review, NOT a pass and NOT a failure:")
	for r in SpikeConfig.owed_to_owner():
		print("  [OWED-TO-OWNER] %s  %s" % [r[0], r[1]])
	print("========================================================================")

# ---------------------------------------------------------------- capture ----

func _cli(prefix: String, fallback: String) -> String:
	for a in OS.get_cmdline_user_args():
		if a.begins_with(prefix):
			return a.substr(prefix.length())
	return fallback

func _maybe_capture() -> void:
	var mode := _cli("--capture=", "")
	if mode == "":
		return
	var out := _cli("--out=", "res://evidence/capture.png")
	await SpikeCapture.run(self, mode, out)
	get_tree().quit(0)
