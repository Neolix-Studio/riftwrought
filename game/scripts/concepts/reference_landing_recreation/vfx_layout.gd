class_name ReferenceLandingVfxLayout
extends Node3D
## Reference Landing Recreation -- Session 7: shaders & VFX (NON-CANONICAL).
##
## This project's first `.gdshader` file and first `GPUParticles3D` -- see
## docs/concepts/reference_landing_recreation/07_shaders_and_vfx.md. Three
## pieces, all built by `build()`:
##
##   1. RIFT-CRACK GROUND QUAD -- a flat `QuadMesh` at SPAWN carrying a real
##      `.gdshader` file (`shaders/rift_crack_ground.gdshader`), not an inline
##      shader string (contrast `exterior_review_treatment.gd`'s
##      `CANDIDATE_SHADER`). Animated cellular-noise cell boundaries read as
##      pulsing glowing cracks. This is the effect that REPLACES Session 6's
##      placeholder `RiftGlowDisc` (a plain unshaded `StandardMaterial3D` on a
##      `CylinderMesh`) -- `lighting_layout.gd` is intentionally left
##      untouched (this concept's sessions never edit a prior session's file,
##      only call its public API), so the placeholder disc still exists
##      wherever both layouts are composed together; this quad sits fractions
##      of a metre above it and is the visually dominant read, exactly as a
##      real crack-shader pass would be if it took over that job outright.
##      Session 8's integration is free to drop the Session 6 disc entirely.
##
##   2. RIFT MOTES -- one small `GPUParticles3D`, low count, drifting upward
##      with the process material's own spread providing the horizontal
##      jitter. A nice-to-have per the brief; included because it is cheap
##      once the crack quad's material and colour already exist to reuse.
##
##   3. LIGHTNING FLICKER LIGHT -- an `OmniLight3D` placed beyond the
##      boundary line near SPAWN (via `ReferenceLandingBoundaryLayout
##      .edge_point()`, never a hand-typed position), standing in for "real"
##      lightning-bolt geometry per the brief's explicit instruction not to
##      attempt that. Its own energy randomises on a short timer.
##
## `time` IS AN EXPLICIT SHADER UNIFORM, NOT GODOT'S BUILT-IN `TIME`. It is
## driven every frame from this node's own accumulated `simulation_seconds`
## clock -- the same discipline `riftfall_loop_event.gd` states for its own
## clock (Prototype Zero's D-192 lesson: measure the clock the thing actually
## runs on) -- so a headless check can call `advance()` with fixed deltas and
## assert the exact shader parameter that results, which built-in `TIME`
## (driven by real wall-clock rendering time) could never let it do.
##
## THE FLICKER IS DETERMINISTIC, EVEN THOUGH THE BRIEF SAYS "RANDOMIZE." This
## concept's Sessions 2-5 never call `Time.*`/`randi()`/`randf()`/engine RNG
## state anywhere -- every placement comes from `cell_random()`, a pure hash
## of an integer index and a decision-specific salt, so the same route
## resolves the same way on every run (see `boundary_layout.gd`'s own
## DETERMINISM note). `_flicker_random()` below is that same idiom applied to
## a TIME sequence instead of a SPATIAL one: a pure hash of an incrementing
## tick counter and a salt. The result still reads as an irregular flicker on
## screen -- nothing about the visual output announces it is deterministic --
## while staying exactly reproducible, which is what lets `vfx_check.gd`
## assert two independently-built instances, advanced through the identical
## delta sequence, land on the identical final light energy.
##
## THIS FILE EXTENDS `Node3D`, UNLIKE ITS FIVE SIBLING LAYOUT FILES. Sessions
## 1-6 are `RefCounted` builders with no runtime behaviour at all -- pure
## placement math, done once. A shader `time` uniform and a flicker timer both
## need a live `_process()` callback, which only a node actually inside a
## `SceneTree` receives, so this file follows `riftfall_loop_event.gd`'s
## shape instead: a `Node3D` that adds itself under `parent` and builds its
## own children, with `build(parent)` kept as the entry point every sibling
## layout already uses so a caller (a preview scene, or Session 8's real
## assembly) can build this alongside the others identically:
## `ReferenceLandingVfxLayout.new().build(self)`.
##
## `advance(delta)` IS SEPARATE FROM `_process(delta)` for the same reason
## `riftfall_loop_event.gd` separates them: verification can then drive the
## exact same production code through fixed, chosen deltas without waiting on
## real frames, on a `scratch` node that is deliberately never added to a
## live `SceneTree` (so `_process` never fires on it at all) -- the same
## pattern every `*_check.gd` sibling in this concept already uses to build a
## layout without giving it a chance to run.

const RIFT_COLOUR: Color = Color(0.482, 0.286, 0.702)
const SHADER_PATH: String = "res://scripts/concepts/reference_landing_recreation/shaders/rift_crack_ground.gdshader"

# --- Rift-crack ground quad -----------------------------------------------
const CRACK_QUAD_SIZE: float = 6.4
const CRACK_HEIGHT_OFFSET: float = 0.05
const CRACK_CELL_SCALE: float = 5.0
const CRACK_WIDTH: float = 0.06
const CRACK_PULSE_SPEED: float = 1.4
const CRACK_PULSE_STRENGTH: float = 0.4
const CRACK_DRIFT_SPEED: float = 0.05
const CRACK_EMISSION_ENERGY: float = 3.2
const CRACK_BASE_ALPHA: float = 0.5
const CRACK_RADIUS_FADE_START: float = 0.55
const CRACK_RADIUS_FADE_END: float = 1.0

# --- Rift motes (optional per the brief; included -- see class doc comment) -
const MOTE_AMOUNT: int = 16
const MOTE_LIFETIME: float = 4.0
const MOTE_SPAWN_RADIUS: float = 2.0
const MOTE_SIZE: float = 0.07

# --- Lightning flicker light ------------------------------------------------
## Near SPAWN (the wall run itself starts at arc 4.0 -- `architecture_layout
## .gd`'s `WALL_START_ARC`) and well beyond it, in `architecture_layout.gd`'s
## own PERIPHERY_MIN_GAP-PERIPHERY_MAX_GAP (7.0-13.0) band, so this reads as
## "in the rock beyond the walls" rather than beside the road.
const FLICKER_ARC: float = 6.0
const FLICKER_EDGE_OFFSET: float = 9.0
const FLICKER_HEIGHT_OFFSET: float = 2.0
const FLICKER_BASE_ENERGY: float = 7.0
const FLICKER_COLOUR: Color = Color(0.72, 0.62, 0.98)
const FLICKER_RANGE: float = 7.0
const FLICKER_ATTENUATION: float = 1.5
const FLICKER_MIN_MULTIPLIER: float = 0.10
const FLICKER_MAX_MULTIPLIER: float = 1.35
const FLICKER_MIN_INTERVAL: float = 0.05
const FLICKER_MAX_INTERVAL: float = 0.22

var simulation_seconds: float = 0.0
var _crack_material: ShaderMaterial
var _crack_mesh: MeshInstance3D
var _particles: GPUParticles3D
var _flicker_light: OmniLight3D
var _flicker_elapsed: float = 0.0
var _flicker_next_change: float = 0.0
var _flicker_tick: int = 0


func _process(delta: float) -> void:
	advance(delta)


## Separated from `_process` -- see class doc comment.
func advance(delta: float) -> void:
	simulation_seconds += delta
	if _crack_material != null:
		_crack_material.set_shader_parameter("time", simulation_seconds)

	_flicker_elapsed += delta
	var guard: int = 0
	while _flicker_elapsed >= _flicker_next_change and guard < 64:
		_flicker_elapsed -= _flicker_next_change
		_apply_flicker_step()
		guard += 1


func reset() -> void:
	simulation_seconds = 0.0
	_flicker_elapsed = 0.0
	_flicker_tick = 0
	if _crack_material != null:
		_crack_material.set_shader_parameter("time", 0.0)
	_flicker_next_change = FLICKER_MIN_INTERVAL
	_apply_flicker_step()


## Deterministic pseudo-random value in [0.0, 1.0) for flicker step `salt` --
## see class doc comment's DETERMINISM section.
func _flicker_random(salt: String) -> float:
	return float(abs(hash("flicker_%d_%s" % [_flicker_tick, salt])) % 1000000) / 1000000.0


func _apply_flicker_step() -> void:
	_flicker_tick += 1
	var multiplier: float = lerpf(
		FLICKER_MIN_MULTIPLIER, FLICKER_MAX_MULTIPLIER, _flicker_random("energy")
	)
	_flicker_next_change = lerpf(
		FLICKER_MIN_INTERVAL, FLICKER_MAX_INTERVAL, _flicker_random("interval")
	)
	if _flicker_light != null:
		_flicker_light.light_energy = FLICKER_BASE_ENERGY * multiplier


func _build_crack_material() -> ShaderMaterial:
	var shader: Shader = load(SHADER_PATH) as Shader
	assert(shader != null, "vfx_layout: rift_crack_ground.gdshader failed to load")
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("rift_colour", Vector3(RIFT_COLOUR.r, RIFT_COLOUR.g, RIFT_COLOUR.b))
	material.set_shader_parameter("time", 0.0)
	material.set_shader_parameter("cell_scale", CRACK_CELL_SCALE)
	material.set_shader_parameter("crack_width", CRACK_WIDTH)
	material.set_shader_parameter("pulse_speed", CRACK_PULSE_SPEED)
	material.set_shader_parameter("pulse_strength", CRACK_PULSE_STRENGTH)
	material.set_shader_parameter("drift_speed", CRACK_DRIFT_SPEED)
	material.set_shader_parameter("emission_energy", CRACK_EMISSION_ENERGY)
	material.set_shader_parameter("base_alpha", CRACK_BASE_ALPHA)
	material.set_shader_parameter("radius_fade_start", CRACK_RADIUS_FADE_START)
	material.set_shader_parameter("radius_fade_end", CRACK_RADIUS_FADE_END)
	return material


func _build_crack_quad() -> Dictionary:
	_crack_material = _build_crack_material()

	var mesh_instance: MeshInstance3D = MeshInstance3D.new()
	mesh_instance.name = "RiftCrackQuad"
	var quad: QuadMesh = QuadMesh.new()
	quad.size = Vector2(CRACK_QUAD_SIZE, CRACK_QUAD_SIZE)
	mesh_instance.mesh = quad
	mesh_instance.material_override = _crack_material
	# QuadMesh's default normal is +Z; -90 deg about X maps it to +Y so the
	# effect lies flat and faces the camera above rather than standing upright.
	mesh_instance.rotation_degrees = Vector3(-90.0, 0.0, 0.0)
	mesh_instance.position = Vector3(
		ReferenceLandingBlueprint.SPAWN.x,
		ReferenceLandingBlueprint.SPAWN.y + CRACK_HEIGHT_OFFSET,
		ReferenceLandingBlueprint.SPAWN.z,
	)
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(mesh_instance)
	_crack_mesh = mesh_instance

	return {"mesh": mesh_instance, "material": _crack_material}


func _build_motes() -> GPUParticles3D:
	var particles: GPUParticles3D = GPUParticles3D.new()
	particles.name = "RiftMotes"
	particles.amount = MOTE_AMOUNT
	particles.lifetime = MOTE_LIFETIME
	# Pre-simulated a full lifetime so the very first rendered frame already
	# shows motes mid-flight rather than every one spawning from zero at once.
	particles.preprocess = MOTE_LIFETIME
	particles.position = ReferenceLandingBlueprint.SPAWN + Vector3(0.0, 0.05, 0.0)
	# GPUParticles3D does NOT auto-fit its culling AABB the way a MeshInstance3D
	# does -- left at the zero-size default, the whole system was silently
	# frustum-culled and invisible in the rendered evidence even though every
	# property above was correct. Generous enough to contain the spawn sphere
	# (MOTE_SPAWN_RADIUS) plus the vertical rise the process material's
	# initial velocity and upward "gravity" produce over one lifetime.
	particles.visibility_aabb = AABB(Vector3(-3.0, -0.5, -3.0), Vector3(6.0, 5.0, 6.0))

	var mesh: QuadMesh = QuadMesh.new()
	mesh.size = Vector2(MOTE_SIZE, MOTE_SIZE)
	var mote_material: StandardMaterial3D = StandardMaterial3D.new()
	mote_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mote_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mote_material.albedo_color = Color(RIFT_COLOUR.r, RIFT_COLOUR.g, RIFT_COLOUR.b, 0.85)
	mote_material.emission_enabled = true
	mote_material.emission = RIFT_COLOUR
	mote_material.emission_energy_multiplier = 1.4
	mote_material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	mesh.material = mote_material
	particles.draw_pass_1 = mesh

	var process_material: ParticleProcessMaterial = ParticleProcessMaterial.new()
	process_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	process_material.emission_sphere_radius = MOTE_SPAWN_RADIUS
	process_material.direction = Vector3(0.0, 1.0, 0.0)
	process_material.spread = 20.0
	process_material.initial_velocity_min = 0.25
	process_material.initial_velocity_max = 0.55
	# A slight upward pull rather than downward gravity -- these are motes of
	# rift energy, not dust, and the brief asks for "upward drift."
	process_material.gravity = Vector3(0.0, 0.12, 0.0)
	process_material.damping_min = 0.05
	process_material.damping_max = 0.15
	process_material.scale_min = 0.6
	process_material.scale_max = 1.4
	process_material.color = Color(RIFT_COLOUR.r, RIFT_COLOUR.g, RIFT_COLOUR.b, 1.0)
	particles.process_material = process_material

	add_child(particles)
	_particles = particles
	return particles


func _build_flicker_light() -> OmniLight3D:
	var group: Node3D = Node3D.new()
	group.name = "LightningFlicker"
	add_child(group)

	var edge: Vector3 = ReferenceLandingBoundaryLayout.edge_point(
		FLICKER_ARC, ReferenceLandingBoundaryLayout.LEFT, FLICKER_EDGE_OFFSET
	)

	var light: OmniLight3D = OmniLight3D.new()
	light.name = "FlickerLight"
	light.position = edge + Vector3(0.0, FLICKER_HEIGHT_OFFSET, 0.0)
	light.light_color = FLICKER_COLOUR
	light.light_energy = FLICKER_BASE_ENERGY
	light.omni_range = FLICKER_RANGE
	light.omni_attenuation = FLICKER_ATTENUATION
	light.shadow_enabled = false
	group.add_child(light)
	_flicker_light = light
	return light


## Main entry point, matching every sibling layout's call shape
## (`SomeLayout.new().build(parent)`) even though this file is itself a
## `Node3D` -- see class doc comment. Adds itself as "Vfx" under `parent`,
## builds all three pieces as its own children, and returns a `Dictionary`
## reporting exactly what it built, for `vfx_check.gd` to verify
## independently.
func build(parent: Node3D) -> Dictionary:
	name = "Vfx"
	parent.add_child(self)

	var crack: Dictionary = _build_crack_quad()
	var particles: GPUParticles3D = _build_motes()
	var flicker_light: OmniLight3D = _build_flicker_light()

	reset()

	return {
		"crack_mesh": crack["mesh"],
		"crack_material": crack["material"],
		"particles": particles,
		"flicker_light": flicker_light,
	}
