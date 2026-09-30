class_name ExteriorReviewLighting
extends Node
## First-MVP Gate 1B — the two lighting states of the review scene
## (specification §6.1 and §6.2).
##
## F1 switches between them and nothing else in the scene changes, so a
## difference the owner sees between the two frames is a difference the LIGHT
## made. Both states are built here in one place, from named values, so the
## report can quote what "neutral" and "candidate" actually were.
##
## NEUTRAL REVIEW (§6.1) must be "bright enough to reveal geometry and material
## mismatch" and "must not use fog, extreme grading, darkness, or bloom to
## conceal differences". So it is a flat, bright, near-white studio: high ambient
## from a plain colour, one white key light, LINEAR tonemapping, no glow, no fog,
## no adjustments, no colour-correction ramp. Nothing here can flatter a
## candidate or hide a clash.
##
## CANDIDATE EXTERIOR TREATMENT (§6.2) is the restrained proposal: subdued cold
## ambient, one readable directional key, restrained warm lantern light, and
## subtle distance fog. It "may not establish final shipping lighting, palette,
## fog, or post-processing" — it is one legible option for the owner to react to,
## and the overlay says so on screen.

enum Mode { NEUTRAL, CANDIDATE }

# --- Neutral review, §6.1 -----------------------------------------------------
const NEUTRAL_BACKGROUND: Color = Color(0.55, 0.56, 0.58)
const NEUTRAL_AMBIENT: Color = Color(0.90, 0.91, 0.93)
const NEUTRAL_AMBIENT_ENERGY: float = 1.05
const NEUTRAL_KEY: Color = Color(1.0, 1.0, 1.0)
const NEUTRAL_KEY_ENERGY: float = 1.10
const NEUTRAL_KEY_ROTATION: Vector3 = Vector3(-52.0, 38.0, 0.0)
const NEUTRAL_SHADOW_OPACITY: float = 0.45

# --- Candidate exterior treatment, §6.2 ---------------------------------------
const CANDIDATE_SKY_TOP: Color = Color(0.055, 0.062, 0.082)
const CANDIDATE_SKY_HORIZON: Color = Color(0.115, 0.120, 0.140)
const CANDIDATE_GROUND_HORIZON: Color = Color(0.085, 0.086, 0.094)
const CANDIDATE_GROUND_BOTTOM: Color = Color(0.028, 0.031, 0.038)
const CANDIDATE_AMBIENT: Color = Color(0.30, 0.35, 0.46)
const CANDIDATE_AMBIENT_ENERGY: float = 0.48
const CANDIDATE_KEY: Color = Color(0.72, 0.78, 0.95)
const CANDIDATE_KEY_ENERGY: float = 1.25
const CANDIDATE_KEY_ROTATION: Vector3 = Vector3(-46.0, 34.0, 0.0)
const CANDIDATE_SHADOW_OPACITY: float = 0.85
## Subtle only: §6.2 allows distance fog "only if every silhouette remains
## inspectable". At this density the far end of the k0rveen row is still legible.
const CANDIDATE_FOG_COLOUR: Color = Color(0.075, 0.082, 0.098)
const CANDIDATE_FOG_DENSITY: float = 0.0032
## Restrained warm lantern light, §6.2.
const LANTERN_COLOUR: Color = Color(1.0, 0.72, 0.38)
const LANTERN_ENERGY: float = 4.0
const LANTERN_RANGE: float = 9.0

var mode: Mode = Mode.NEUTRAL

var _environment: WorldEnvironment
var _key: DirectionalLight3D
var _lanterns: Array[OmniLight3D] = []


func configure(environment: WorldEnvironment, key: DirectionalLight3D) -> void:
	_environment = environment
	_key = key


## The lantern lights belong to the candidate treatment only; in neutral review
## they are off, because a warm pool of light is exactly the kind of thing §6.1
## forbids using to flatter a material.
func add_lantern(at: Vector3) -> OmniLight3D:
	var lantern: OmniLight3D = OmniLight3D.new()
	lantern.name = "LanternLight_%d" % _lanterns.size()
	lantern.position = at
	lantern.light_color = LANTERN_COLOUR
	lantern.light_energy = LANTERN_ENERGY
	lantern.omni_range = LANTERN_RANGE
	lantern.omni_attenuation = 1.4
	lantern.shadow_enabled = false
	add_child(lantern)
	_lanterns.append(lantern)
	return lantern


func set_mode(wanted: Mode) -> void:
	mode = wanted
	if wanted == Mode.NEUTRAL:
		_apply_neutral()
	else:
		_apply_candidate()
	for lantern: OmniLight3D in _lanterns:
		lantern.visible = wanted == Mode.CANDIDATE


func toggle() -> Mode:
	set_mode(Mode.CANDIDATE if mode == Mode.NEUTRAL else Mode.NEUTRAL)
	return mode


func mode_name() -> String:
	return "neutral source review" if mode == Mode.NEUTRAL else "candidate exterior treatment"


func lantern_count() -> int:
	return _lanterns.size()


func _apply_neutral() -> void:
	var environment: Environment = Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = NEUTRAL_BACKGROUND
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = NEUTRAL_AMBIENT
	environment.ambient_light_energy = NEUTRAL_AMBIENT_ENERGY
	environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	environment.fog_enabled = false
	environment.glow_enabled = false
	environment.ssao_enabled = false
	environment.adjustment_enabled = false
	_environment.environment = environment
	_key.light_color = NEUTRAL_KEY
	_key.light_energy = NEUTRAL_KEY_ENERGY
	_key.rotation_degrees = NEUTRAL_KEY_ROTATION
	_key.shadow_enabled = true
	_key.shadow_opacity = NEUTRAL_SHADOW_OPACITY


func _apply_candidate() -> void:
	var sky_material: ProceduralSkyMaterial = ProceduralSkyMaterial.new()
	sky_material.sky_top_color = CANDIDATE_SKY_TOP
	sky_material.sky_horizon_color = CANDIDATE_SKY_HORIZON
	sky_material.ground_horizon_color = CANDIDATE_GROUND_HORIZON
	sky_material.ground_bottom_color = CANDIDATE_GROUND_BOTTOM
	var sky: Sky = Sky.new()
	sky.sky_material = sky_material

	var environment: Environment = Environment.new()
	environment.background_mode = Environment.BG_SKY
	environment.sky = sky
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = CANDIDATE_AMBIENT
	environment.ambient_light_energy = CANDIDATE_AMBIENT_ENERGY
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.fog_enabled = true
	environment.fog_light_color = CANDIDATE_FOG_COLOUR
	environment.fog_density = CANDIDATE_FOG_DENSITY
	# No glow and no colour adjustment: §6.2 permits light, fog, and material
	# relationships, and this spike deliberately proposes no post-processing.
	environment.glow_enabled = false
	environment.adjustment_enabled = false
	_environment.environment = environment
	_key.light_color = CANDIDATE_KEY
	_key.light_energy = CANDIDATE_KEY_ENERGY
	_key.rotation_degrees = CANDIDATE_KEY_ROTATION
	_key.shadow_enabled = true
	_key.shadow_opacity = CANDIDATE_SHADOW_OPACITY
