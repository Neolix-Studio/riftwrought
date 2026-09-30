class_name RiftAnchor
extends Node3D
## First-MVP — Gate 1E: the central stabilizing Anchor, and the beat where it
## recognizes the Mark (D-219).
##
## `design/NARRATIVE_WORLD_AND_FIRST_REGION.md`: "The Rift Nexus is a surviving
## stabilizing instrument that recognizes the Riftmarked as a living continuity
## and key." §21.2: "The Nexus reacts to the Riftmarked's Shards and establishes
## the first stable connection."
##
## RECOGNITION COMES BEFORE EXPLANATION, and that ordering is the whole point of
## the beat. The brief: "When the Riftmarked approaches/enters the relevant
## Nexus area, it should visibly respond to the Mark BEFORE Mara fully
## understands what is happening ... The world event must communicate that the
## Nexus recognized something. Dialogue then explains consequence."
##
## So this object watches for the character and acts on its own. Mara does not
## trigger it, no dialogue precedes it, and nothing on screen announces it in
## words until it has already happened.
##
## FOUR STATES, AND EACH IS A DIFFERENT THING TO LOOK AT:
##
##   DORMANT      A dark ring and a still, dim core. It is an instrument that
##                has not worked in a long time.
##   STIRRING     The ring brightens from the point nearest the character and
##                the core begins to turn. Triggered by PROXIMITY, so the
##                player's own approach causes it.
##   RECOGNIZING  One bounded pulse: the core opens, the ring completes, and a
##                wave of light crosses the ground outward. This is the event.
##   AWAKE        Steady, brighter than dormant, quietly alive. It stays here.
##
## BUILT FROM PROJECT-AUTHORED PRIMITIVE GEOMETRY AND EMISSION, exactly as the
## brief allows ("simple geometry/emission") and exactly as Gate 1A built its
## entire hall. No asset was extracted, no shader file was added, no particle
## system was introduced. A torus, two cylinders, a sphere and a ground disc,
## with unshaded additive materials whose colours are animated in `_process`.
##
## NO AUDIO. The brief permits "audio only if an existing appropriate authored
## cue is available", and the Prototype Zero catalogue's twenty families are
## combat, item, and menu cues — there is no Rift or Anchor family in it, and
## inventing one is a §19 authored-audio decision this gate does not have. The
## silence is deliberate and is recorded rather than left to be noticed.
##
## THE PULSE IS BOUNDED AND HAPPENS ONCE. `RECOGNIZING` runs for exactly
## `PULSE_SECONDS` and then latches to `AWAKE`. Re-entering the area, reloading,
## restarting, or walking away and back cannot replay it, because the state is
## driven from the CHARACTER's saved `nexus_recognition_complete` rather than
## from a field that dies with the scene.
##
## NOT RIFT SHARDS. The brief: "Do not build Rift Shard gameplay yet. Do not
## trigger Rift Echo. Do not explain the full Unseaming." This object has no
## Shard, generates nothing, grants nothing by itself, and says nothing about
## the Unseaming. It reports that recognition happened; the runtime owns the
## reward and the dialogue owns the meaning.

enum State {
	DORMANT,
	STIRRING,
	RECOGNIZING,
	AWAKE,
}

## How close the character must come for the Anchor to begin stirring. Well
## inside the 13.532 m the accepted camera shows ahead of the body, so the
## player is always looking at the Anchor when it starts to answer them.
const STIR_RADIUS: float = 9.0
## How close they must come for recognition to fire.
const RECOGNITION_RADIUS: float = 5.0
## The bounded length of the one recognition pulse.
const PULSE_SECONDS: float = 2.60

const RING_INNER: float = 1.62
const RING_OUTER: float = 1.86
const CORE_RADIUS: float = 0.62
const COLUMN_RADIUS: float = 0.34
const COLUMN_HEIGHT: float = 3.40
const WAVE_MAX_RADIUS: float = 7.20

## The project's Rift violet, the same family Riftfall Landing's own rift scar
## uses (0.560, 0.380, 0.780) and the Zone Composer's Look At This marker.
const RIFT_VIOLET: Color = Color(0.560, 0.380, 0.780)
const RIFT_BRIGHT: Color = Color(0.780, 0.620, 1.000)
const DORMANT_TINT: Color = Color(0.220, 0.190, 0.290)

var state: State = State.DORMANT
var recognition_fired: bool = false
var stir_amount: float = 0.0
var pulse_time: float = 0.0
var closest_seen: float = 999.0

var _ring: MeshInstance3D
var _ring_material: StandardMaterial3D
var _core: MeshInstance3D
var _core_material: StandardMaterial3D
var _column: MeshInstance3D
var _column_material: StandardMaterial3D
var _wave: MeshInstance3D
var _wave_material: StandardMaterial3D
var _light: OmniLight3D
var _phase: float = 0.0
var _log: Callable = Callable()

## Fired exactly once, when the recognition pulse BEGINS. The runtime listens
## for this and owns everything that follows.
signal recognized()
## Fired once when the bounded pulse completes and the Anchor settles.
signal settled()


func _ready() -> void:
	_build()
	_apply_visual_state()


func configure(log_sink: Callable) -> void:
	_log = log_sink


## Puts the Anchor straight into its finished state with no pulse. Used when a
## saved character has already been recognized: the beat is not replayed, and
## the Anchor is simply already awake when they walk back in.
func set_already_awake() -> void:
	recognition_fired = true
	state = State.AWAKE
	stir_amount = 1.0
	pulse_time = PULSE_SECONDS
	_apply_visual_state()


# --- Construction --------------------------------------------------------------

func _build() -> void:
	_ring = MeshInstance3D.new()
	_ring.name = "AnchorRing"
	var torus: TorusMesh = TorusMesh.new()
	torus.inner_radius = RING_INNER
	torus.outer_radius = RING_OUTER
	torus.rings = 48
	torus.ring_segments = 12
	_ring.mesh = torus
	_ring_material = _emissive_material(DORMANT_TINT, 1.0)
	_ring.material_override = _ring_material
	_ring.position = Vector3(0.0, 0.90, 0.0)
	_ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(_ring)

	_column = MeshInstance3D.new()
	_column.name = "AnchorColumn"
	var column: CylinderMesh = CylinderMesh.new()
	column.top_radius = COLUMN_RADIUS * 0.55
	column.bottom_radius = COLUMN_RADIUS
	column.height = COLUMN_HEIGHT
	column.radial_segments = 14
	column.rings = 1
	_column.mesh = column
	_column_material = _emissive_material(DORMANT_TINT, 0.55)
	_column.material_override = _column_material
	_column.position = Vector3(0.0, COLUMN_HEIGHT * 0.5, 0.0)
	_column.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(_column)

	_core = MeshInstance3D.new()
	_core.name = "AnchorCore"
	var core: SphereMesh = SphereMesh.new()
	core.radius = CORE_RADIUS
	core.height = CORE_RADIUS * 2.0
	core.radial_segments = 20
	core.rings = 12
	_core.mesh = core
	_core_material = _emissive_material(DORMANT_TINT, 1.0)
	_core.material_override = _core_material
	_core.position = Vector3(0.0, 0.90, 0.0)
	_core.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(_core)

	# The ground wave. Flat, unshaded, additive; it exists only during the pulse
	# and is the part of the event the accepted camera can definitely show,
	# because it lies on the ground plane rather than above it.
	_wave = MeshInstance3D.new()
	_wave.name = "RecognitionWave"
	var disc: TorusMesh = TorusMesh.new()
	disc.inner_radius = 0.90
	disc.outer_radius = 1.30
	disc.rings = 56
	disc.ring_segments = 4
	_wave.mesh = disc
	_wave_material = _emissive_material(RIFT_BRIGHT, 0.0)
	_wave.material_override = _wave_material
	_wave.position = Vector3(0.0, 0.06, 0.0)
	_wave.rotation_degrees = Vector3(0.0, 0.0, 0.0)
	_wave.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_wave.visible = false
	add_child(_wave)

	_light = OmniLight3D.new()
	_light.name = "AnchorLight"
	_light.light_color = RIFT_VIOLET
	_light.light_energy = 0.35
	_light.omni_range = 12.0
	_light.shadow_enabled = false
	_light.position = Vector3(0.0, 1.20, 0.0)
	add_child(_light)


func _emissive_material(colour: Color, alpha: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.albedo_color = Color(colour.r, colour.g, colour.b, alpha)
	return material


# --- The beat ------------------------------------------------------------------

## Called every frame by the runtime with the character's current position. The
## Anchor decides for itself; nothing scripts it.
func observe(character_position: Vector3) -> void:
	var distance: float = Vector2(
		character_position.x - global_position.x, character_position.z - global_position.z
	).length()
	closest_seen = minf(closest_seen, distance)
	if state == State.RECOGNIZING or state == State.AWAKE:
		return
	if distance <= RECOGNITION_RADIUS:
		_begin_recognition(distance)
		return
	if distance <= STIR_RADIUS:
		if state == State.DORMANT:
			state = State.STIRRING
			_emit("anchor stirring", "the Riftmarked came within %.2f m" % distance)
		# Stir strength rises as they close, so the answer tracks the approach
		# rather than switching on at a threshold.
		stir_amount = clampf(
			1.0 - (distance - RECOGNITION_RADIUS) / maxf(STIR_RADIUS - RECOGNITION_RADIUS, 0.0001),
			0.0, 1.0
		)
	elif state == State.STIRRING:
		state = State.DORMANT
		stir_amount = 0.0


func _begin_recognition(distance: float) -> void:
	if recognition_fired:
		return
	recognition_fired = true
	state = State.RECOGNIZING
	pulse_time = 0.0
	stir_amount = 1.0
	_wave.visible = true
	_emit("anchor recognized the Mark", "at %.2f m; a bounded %.2f s response, once" % [distance, PULSE_SECONDS])
	recognized.emit()


func _process(delta: float) -> void:
	_phase += delta
	if state == State.RECOGNIZING:
		pulse_time += delta
		if pulse_time >= PULSE_SECONDS:
			state = State.AWAKE
			_wave.visible = false
			_emit("anchor settled", "steady; the connection holds")
			settled.emit()
	_apply_visual_state()


func _apply_visual_state() -> void:
	if _ring_material == null:
		return
	var breathe: float = 0.5 + 0.5 * sin(_phase * TAU / 4.4)
	match state:
		State.DORMANT:
			_set_colours(DORMANT_TINT, 0.55 + 0.10 * breathe, 0.30, 0.22)
		State.STIRRING:
			var tint: Color = DORMANT_TINT.lerp(RIFT_VIOLET, stir_amount)
			_set_colours(tint, 0.60 + 0.28 * stir_amount * breathe, 0.34 + 0.30 * stir_amount,
				0.22 + 0.80 * stir_amount)
			_column.rotation.y = _phase * 0.55 * stir_amount
		State.RECOGNIZING:
			var t: float = clampf(pulse_time / PULSE_SECONDS, 0.0, 1.0)
			# One rise and one settle, not a flicker: bright fast, ease down.
			var intensity: float = sin(clampf(t * 2.2, 0.0, 1.0) * PI * 0.5) * (1.0 - t * 0.42)
			_set_colours(RIFT_VIOLET.lerp(RIFT_BRIGHT, intensity), 0.75 + 0.25 * intensity,
				0.55 + 0.45 * intensity, 1.10 + 2.60 * intensity)
			_column.rotation.y = _phase * 1.9
			_advance_wave(t)
		State.AWAKE:
			_set_colours(RIFT_VIOLET, 0.72 + 0.14 * breathe, 0.46 + 0.10 * breathe, 0.95)
			_column.rotation.y = _phase * 0.35


func _set_colours(tint: Color, ring_alpha: float, column_alpha: float, light_energy: float) -> void:
	_ring_material.albedo_color = Color(tint.r, tint.g, tint.b, ring_alpha)
	_core_material.albedo_color = Color(tint.r, tint.g, tint.b, minf(ring_alpha + 0.20, 1.0))
	_column_material.albedo_color = Color(tint.r, tint.g, tint.b, column_alpha)
	_light.light_color = tint
	_light.light_energy = light_energy


## The wave crosses the ground outward once and fades as it goes, so the event
## reads as something leaving the Anchor rather than a light being turned up.
func _advance_wave(t: float) -> void:
	var radius: float = 1.10 + t * (WAVE_MAX_RADIUS - 1.10)
	var torus: TorusMesh = _wave.mesh as TorusMesh
	torus.inner_radius = maxf(radius - 0.42, 0.05)
	torus.outer_radius = radius
	_wave_material.albedo_color = Color(
		RIFT_BRIGHT.r, RIFT_BRIGHT.g, RIFT_BRIGHT.b, maxf(0.85 * (1.0 - t), 0.0)
	)


func _emit(event: String, detail: String) -> void:
	if _log.is_valid():
		_log.call(event, detail)


func state_name() -> String:
	match state:
		State.STIRRING:
			return "STIRRING"
		State.RECOGNIZING:
			return "RECOGNIZING"
		State.AWAKE:
			return "AWAKE"
		_:
			return "DORMANT"


func measurements() -> Dictionary:
	return {
		"state": state_name(),
		"recognition_fired": recognition_fired,
		"stir_amount": stir_amount,
		"pulse_time": pulse_time,
		"pulse_seconds": PULSE_SECONDS,
		"stir_radius": STIR_RADIUS,
		"recognition_radius": RECOGNITION_RADIUS,
		"closest_seen": closest_seen,
	}
