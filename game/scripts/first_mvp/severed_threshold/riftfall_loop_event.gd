class_name RiftfallLoopEvent
extends Node3D
## First-MVP Gate 1C — the repeating-stone anomaly (D-208 §7).
##
## Riftfall Landing's ONE authored story event, and the first visible proof that
## reality is repeating incorrectly. A loose piece of masonry rolls a short
## readable distance down a shallow grade, strikes, holds — and then returns to
## its starting state far too abruptly to read as ordinary reverse motion. Then it
## does it again.
##
## IT IS A DETERMINISTIC STATE MACHINE, NOT A PHYSICS OBJECT.
##
##     REST -> ROLL -> IMPACT_HOLD -> IMPOSSIBLE_RETURN -> REST
##
## §7 forbids random timing, physics impulses and non-deterministic rigid-body
## outcomes, so there is no `RigidBody3D`, no impulse, no randomness and no seed
## anywhere below: every position and every rotation is a pure function of the
## state and the elapsed time in it. Two runs of the same length produce the same
## cycle count.
##
## IT IS READABLE WITH AUDIO MUTED, and Gate 1C adds no audio at all. The reset is
## carried entirely by motion — a 0.10 s snap against a 1.10 s roll is an order of
## magnitude too fast to be a rewind, which is the point.
##
## IT TOUCHES NOTHING. No collision shape, no navigation carve, no damage, no
## interaction prompt, no quest state, no persistent state of any kind, and no
## dependence on where the player is standing. It runs whether or not anyone is
## watching, which is why "at least two complete cycles during an ordinary first
## traversal" is arithmetic rather than a hope: the cycle is 2.05 s and §6.1's
## traversal expectation is 12-20 s.
##
## THE STONE IS PROJECT-AUTHORED. §7: "Do not scale or repurpose a third-party
## hero prop for this event." It is two authored boxes at odd angles — a chipped
## masonry fragment at the scale of a fist-sized block — carrying the same
## authored stone colour the kerb it sits on does, and registered with the same
## exterior treatment, so it is graded by the accepted rule rather than
## hand-coloured beside it.

enum State { REST, ROLL, IMPACT_HOLD, IMPOSSIBLE_RETURN }

## §7's timing bands, chosen inside them and stated rather than tuned in secret:
##   REST               0.35 - 0.55 s
##   ROLL               0.90 - 1.30 s
##   IMPACT_HOLD        0.30 - 0.50 s
##   IMPOSSIBLE_RETURN  0.08 - 0.15 s
const REST_SECONDS: float = 0.45
const ROLL_SECONDS: float = 1.10
const IMPACT_SECONDS: float = 0.40
const RETURN_SECONDS: float = 0.10
const CYCLE_SECONDS: float = REST_SECONDS + ROLL_SECONDS + IMPACT_SECONDS + RETURN_SECONDS

## Where it rests and where it strikes, in the layout's own local frame. §7 asks
## for 1.25-2.00 m; the measured travel is read back off these two points in
## `travel_distance()` rather than typed.
const REST_LOCAL: Vector3 = Vector3(13.90, 0.95, -4.50)
const IMPACT_LOCAL: Vector3 = Vector3(12.20, 0.62, -4.50)
## The shallow visible grade the stone rolls down, and the tilt the authored kerb
## slab carries so the eye can see the slope the motion obeys.
const GRADE_RADIANS: float = 0.191695

## The stone tumbles as it travels. This is the effective rolling radius, chosen
## so the fragment turns a little over one full revolution across the whole
## descent — enough that the rotation is unmistakable, slow enough that it does
## not read as a spin.
const TUMBLE_RADIUS: float = 0.26

const STONE_COLOUR: Color = Color(0.334, 0.326, 0.312)
const RIFT_COLOUR: Color = Color(0.482, 0.286, 0.702)
## Restrained, and deliberately capped: §7 forbids this becoming a quest marker or
## a bright screen-filling effect, so the residue never exceeds this alpha and is
## a 0.9 m ring on the ground rather than a light source.
const RESIDUE_PEAK_ALPHA: float = 0.62
const RESIDUE_REST_ALPHA: float = 0.10

var state: State = State.REST
var state_elapsed: float = 0.0
var cycle_count: int = 0
## The event's own clock, accumulated from the frames it actually ran, so a
## measurement of "how many cycles in N seconds" is taken on the clock the event
## runs on rather than on a wall clock that keeps going while the process stalls.
## That is Prototype Zero's D-192 lesson, applied before it can bite.
var simulation_seconds: float = 0.0

var _stone: Node3D
var _residue: MeshInstance3D
var _residue_material: StandardMaterial3D
var _impact_residue: MeshInstance3D
var _impact_material: StandardMaterial3D
var _unregistered_surfaces: int = 0


func build(treatment: ExteriorReviewTreatment) -> void:
	for child: Node in get_children():
		child.free()

	_stone = Node3D.new()
	_stone.name = "MasonryFragment"
	add_child(_stone)
	# A chipped block: one body and one broken corner, at odd angles. Two authored
	# primitives, no third-party mesh, no imported prop rescaled into a hero role.
	_add_chunk(_stone, "FragmentBody", Vector3(0.40, 0.34, 0.44),
		Vector3(0.0, 0.0, 0.0), Vector3(0.0, 0.22, 0.0))
	_add_chunk(_stone, "FragmentCorner", Vector3(0.26, 0.20, 0.22),
		Vector3(0.13, -0.09, 0.14), Vector3(0.36, -0.51, 0.18))
	if treatment != null:
		treatment.register(_stone, "authored masonry fragment")

	# The residue that marks the return. It is NOT registered with the exterior
	# treatment: the treatment is a stone-palette rule, and desaturating the Rift
	# would delete the story beat rather than grade it. That exclusion is counted
	# and reported rather than left implicit.
	_residue_material = _rift_material()
	_residue = _residue_ring("ReturnResidue", REST_LOCAL, 0.62, 0.88, _residue_material)
	_impact_material = _rift_material()
	_impact_residue = _residue_ring("ImpactResidue", IMPACT_LOCAL, 0.30, 0.44, _impact_material)

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
	_unregistered_surfaces += 1
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


## §7: "developer reset returns the event to the exact initial state and cycle
## count". Exact means exact: the state, the clock, the counter, the stone's
## position and rotation, and both residue alphas.
func reset() -> void:
	state = State.REST
	state_elapsed = 0.0
	cycle_count = 0
	simulation_seconds = 0.0
	_apply(0.0)


func _process(delta: float) -> void:
	advance(delta)


## Separated from `_process` so the verification can observe the machine through
## the SAME production object the player sees, at a step it controls, without a
## second implementation of the timing existing anywhere.
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


## The one place the stone's pose is decided. `phase` is 0-1 within the current
## state, so every position and rotation is a pure function of (state, phase) and
## nothing accumulates drift across cycles.
func _apply(phase: float) -> void:
	var travel: float = 0.0
	var residue: float = RESIDUE_REST_ALPHA
	match state:
		State.REST:
			travel = 0.0
			# The mark left by the impossible return, fading through the pause.
			residue = lerpf(RESIDUE_PEAK_ALPHA, RESIDUE_REST_ALPHA, clampf(phase, 0.0, 1.0))
		State.ROLL:
			# A rolling stone accelerates. Squared time is the honest shape and it
			# puts the fastest motion immediately before the strike.
			travel = clampf(phase, 0.0, 1.0) * clampf(phase, 0.0, 1.0)
			residue = RESIDUE_REST_ALPHA
		State.IMPACT_HOLD:
			travel = 1.0
			residue = RESIDUE_REST_ALPHA
		State.IMPOSSIBLE_RETURN:
			# LINEAR, and over a tenth of a second. Nothing eases, nothing settles,
			# nothing arcs: it is the same object arriving back at a place it has
			# already left, which is exactly what should not be possible.
			travel = 1.0 - clampf(phase, 0.0, 1.0)
			residue = lerpf(RESIDUE_REST_ALPHA, RESIDUE_PEAK_ALPHA, clampf(phase, 0.0, 1.0))
	_stone.position = REST_LOCAL.lerp(IMPACT_LOCAL, travel)
	# Rolling without slipping toward -X turns the fragment about -Z.
	_stone.rotation = Vector3(0.0, 0.0, -travel * travel_distance() / TUMBLE_RADIUS)
	_residue_material.albedo_color = Color(
		RIFT_COLOUR.r, RIFT_COLOUR.g, RIFT_COLOUR.b, residue
	)
	_impact_material.albedo_color = Color(
		RIFT_COLOUR.r, RIFT_COLOUR.g, RIFT_COLOUR.b,
		RESIDUE_REST_ALPHA * 0.6 + (RESIDUE_PEAK_ALPHA - RESIDUE_REST_ALPHA)
			* 0.35 * (1.0 if state == State.IMPACT_HOLD else 0.0)
	)


static func travel_distance() -> float:
	return REST_LOCAL.distance_to(IMPACT_LOCAL)


static func grade_degrees() -> float:
	return rad_to_deg(atan2(
		absf(REST_LOCAL.y - IMPACT_LOCAL.y),
		Vector2(REST_LOCAL.x - IMPACT_LOCAL.x, REST_LOCAL.z - IMPACT_LOCAL.z).length()
	))


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


static func state_name_of(which: State) -> String:
	match which:
		State.ROLL:
			return "ROLL"
		State.IMPACT_HOLD:
			return "IMPACT_HOLD"
		State.IMPOSSIBLE_RETURN:
			return "IMPOSSIBLE_RETURN"
		_:
			return "REST"


func rest_position() -> Vector3:
	return REST_LOCAL


func impact_position() -> Vector3:
	return IMPACT_LOCAL


func stone_position() -> Vector3:
	return _stone.position if _stone != null else REST_LOCAL


func stone_global_position() -> Vector3:
	return _stone.global_position if _stone != null else global_position


func stone_rotation_degrees() -> float:
	return rad_to_deg(_stone.rotation.z) if _stone != null else 0.0


func residue_alpha() -> float:
	return _residue_material.albedo_color.a if _residue_material != null else 0.0


func mesh_count() -> int:
	return _count_meshes(self)


func unregistered_surfaces() -> int:
	return _unregistered_surfaces


func _count_meshes(node: Node) -> int:
	var total: int = 0
	for child: Node in node.get_children():
		if child is MeshInstance3D:
			total += 1
		total += _count_meshes(child)
	return total
