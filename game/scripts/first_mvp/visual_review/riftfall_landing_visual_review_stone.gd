class_name RiftfallLandingVisualReviewStone
extends Node3D
## Riftfall Landing visual review — the "repeating stone" story beat, scaled to
## Greybox V2's own Broken Procession plaza.
##
## NOT a reuse of the canonical `RiftfallLoopEvent` (`severed_threshold/`). That
## class's rest/impact points are literal world-space constants authored for the
## canonical layout's own raised kerb, so instancing it unchanged here would sit
## the stone on top of nothing or drop it through V2's flat plaza floor — and
## editing it to accept a configurable rest/impact pair would mean touching a file
## the closed Gate 1C scene depends on, which this isolated, unapproved review
## must not do. So this is a second, independent, self-contained instance of the
## SAME accepted design beat (paper design, D-207 and D-208 §7): a loose fragment
## rolls a short readable distance, strikes, holds, and resets far too abruptly to
## read as reverse motion — reusing the same accepted state names and timing
## bands, parameterised to V2's own STONE_RESERVATION patch instead of copying
## canonical-scene coordinates.
##
## Deterministic, not a physics object: no `RigidBody3D`, no impulse, no
## randomness. Touches nothing — no collision shape, no navigation carve, no
## interaction, no persistent state.

enum State { REST, ROLL, IMPACT_HOLD, IMPOSSIBLE_RETURN }

const REST_SECONDS: float = 0.45
const ROLL_SECONDS: float = 1.10
const IMPACT_SECONDS: float = 0.40
const RETURN_SECONDS: float = 0.10
const CYCLE_SECONDS: float = REST_SECONDS + ROLL_SECONDS + IMPACT_SECONDS + RETURN_SECONDS

const STONE_COLOUR: Color = Color(0.334, 0.326, 0.312)
const RIFT_COLOUR: Color = Color(0.482, 0.286, 0.702)
const RESIDUE_PEAK_ALPHA: float = 0.62
const RESIDUE_REST_ALPHA: float = 0.10
const TUMBLE_RADIUS: float = 0.22

## Set by the dressing pass before `build()`, in the layout's own local frame —
## V2's STONE_RESERVATION centres near (-6.5, -5.5); the two points below are
## placed a short readable roll apart, inside that reservation, flush with the
## authored plaza floor rather than on a raised kerb.
var rest_local: Vector3 = Vector3(-5.2, 0.02, -5.5)
var impact_local: Vector3 = Vector3(-7.6, 0.02, -5.5)

var state: State = State.REST
var state_elapsed: float = 0.0
var cycle_count: int = 0
var simulation_seconds: float = 0.0

var _stone: Node3D
var _residue: MeshInstance3D
var _residue_material: StandardMaterial3D
var _impact_residue: MeshInstance3D
var _impact_material: StandardMaterial3D


func configure(rest: Vector3, impact: Vector3) -> void:
	rest_local = rest
	impact_local = impact


func build(treatment: ExteriorReviewTreatment) -> void:
	for child: Node in get_children():
		child.free()

	_stone = Node3D.new()
	_stone.name = "MasonryFragment"
	add_child(_stone)
	_add_chunk(_stone, "FragmentBody", Vector3(0.36, 0.30, 0.40),
		Vector3(0.0, 0.0, 0.0), Vector3(0.0, 0.18, 0.0))
	_add_chunk(_stone, "FragmentCorner", Vector3(0.22, 0.17, 0.19),
		Vector3(0.11, -0.08, 0.12), Vector3(0.30, -0.44, 0.15))
	if treatment != null:
		treatment.register(_stone, "authored masonry fragment (visual review)")

	_residue_material = _rift_material()
	_residue = _residue_ring("ReturnResidue", rest_local, 0.55, 0.78, _residue_material)
	_impact_material = _rift_material()
	_impact_residue = _residue_ring("ImpactResidue", impact_local, 0.26, 0.38, _impact_material)

	reset()


func _add_chunk(
	parent: Node3D, chunk_name: String, size: Vector3, at: Vector3, rotation_radians: Vector3
) -> void:
	var mesh: MeshInstance3D = MeshInstance3D.new()
	mesh.name = chunk_name
	var box: BoxMesh = BoxMesh.new()
	box.size = size
	mesh.mesh = box
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = STONE_COLOUR
	material.roughness = 1.0
	material.metallic = 0.0
	material.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	box.material = material
	mesh.position = at
	mesh.rotation = rotation_radians
	parent.add_child(mesh)


func _residue_ring(
	ring_name: String, at: Vector3, inner: float, outer: float, material: StandardMaterial3D
) -> MeshInstance3D:
	var ring: MeshInstance3D = MeshInstance3D.new()
	ring.name = ring_name
	var torus: TorusMesh = TorusMesh.new()
	torus.inner_radius = inner
	torus.outer_radius = outer
	torus.rings = 20
	ring.mesh = torus
	ring.material_override = material
	ring.position = Vector3(at.x, 0.03, at.z)
	ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(ring)
	return ring


func _rift_material() -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(RIFT_COLOUR.r, RIFT_COLOUR.g, RIFT_COLOUR.b, RESIDUE_REST_ALPHA)
	material.emission_enabled = true
	material.emission = RIFT_COLOUR
	material.emission_energy_multiplier = 0.80
	return material


func reset() -> void:
	state = State.REST
	state_elapsed = 0.0
	cycle_count = 0
	simulation_seconds = 0.0
	_apply(0.0)


func _process(delta: float) -> void:
	advance(delta)


func advance(delta: float) -> void:
	if _stone == null:
		return
	simulation_seconds += delta
	state_elapsed += delta
	var guard: int = 0
	while state_elapsed >= state_duration(state) and guard < 8:
		state_elapsed -= state_duration(state)
		_enter_next_state()
		guard += 1
	_apply(state_elapsed / maxf(state_duration(state), 0.0001))


func _enter_next_state() -> void:
	match state:
		State.REST:
			state = State.ROLL
		State.ROLL:
			state = State.IMPACT_HOLD
		State.IMPACT_HOLD:
			state = State.IMPOSSIBLE_RETURN
		_:
			state = State.REST
			cycle_count += 1


static func state_duration(which: State) -> float:
	match which:
		State.ROLL:
			return ROLL_SECONDS
		State.IMPACT_HOLD:
			return IMPACT_SECONDS
		State.IMPOSSIBLE_RETURN:
			return RETURN_SECONDS
		_:
			return REST_SECONDS


func _apply(phase: float) -> void:
	var travel: float = 0.0
	var residue: float = RESIDUE_REST_ALPHA
	match state:
		State.REST:
			travel = 0.0
			residue = lerpf(RESIDUE_PEAK_ALPHA, RESIDUE_REST_ALPHA, clampf(phase, 0.0, 1.0))
		State.ROLL:
			travel = clampf(phase, 0.0, 1.0) * clampf(phase, 0.0, 1.0)
			residue = RESIDUE_REST_ALPHA
		State.IMPACT_HOLD:
			travel = 1.0
			residue = RESIDUE_REST_ALPHA
		State.IMPOSSIBLE_RETURN:
			travel = 1.0 - clampf(phase, 0.0, 1.0)
			residue = lerpf(RESIDUE_REST_ALPHA, RESIDUE_PEAK_ALPHA, clampf(phase, 0.0, 1.0))
	_stone.position = rest_local.lerp(impact_local, travel)
	_stone.rotation = Vector3(0.0, 0.0, -travel * travel_distance() / TUMBLE_RADIUS)
	_residue_material.albedo_color = Color(RIFT_COLOUR.r, RIFT_COLOUR.g, RIFT_COLOUR.b, residue)
	_impact_material.albedo_color = Color(
		RIFT_COLOUR.r, RIFT_COLOUR.g, RIFT_COLOUR.b,
		RESIDUE_REST_ALPHA * 0.6 + (RESIDUE_PEAK_ALPHA - RESIDUE_REST_ALPHA)
			* 0.35 * (1.0 if state == State.IMPACT_HOLD else 0.0)
	)


func travel_distance() -> float:
	return rest_local.distance_to(impact_local)


func state_name() -> String:
	match state:
		State.ROLL:
			return "ROLL"
		State.IMPACT_HOLD:
			return "IMPACT_HOLD"
		State.IMPOSSIBLE_RETURN:
			return "IMPOSSIBLE_RETURN"
		_:
			return "REST"


func stone_position() -> Vector3:
	return _stone.position if _stone != null else rest_local
