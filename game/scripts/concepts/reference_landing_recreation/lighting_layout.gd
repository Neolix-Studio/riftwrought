class_name ReferenceLandingLightingLayout
extends RefCounted
## Reference Landing Recreation -- Session 6: lighting (NON-CANONICAL).
##
## Ordinary lights, one `WorldEnvironment`, and one placeholder emissive mesh --
## no shader, no particle system, no material-desaturation treatment. See
## docs/concepts/reference_landing_recreation/06_lighting.md.
##
## THREE PIECES, matching the task brief exactly:
##
##   1. WORLDENVIRONMENT -- a cool, slightly desaturated ambient plus light fog,
##      in the spirit of canonical Riftfall Landing's own accepted numbers
##      (exterior ambient energy 0.62, fog density 0.0032) -- a STARTING POINT
##      quoted in the brief, not a requirement this non-canonical concept must
##      match exactly. The material saturation/value/tint treatment those same
##      Riftfall Landing numbers include is a SEPARATE system
##      (`exterior_review_treatment.gd`, a `ShaderMaterial` grading pass) that
##      this session deliberately does not touch -- no shader work yet.
##
##   2. LANTERN LIGHTS -- one `OmniLight3D` at every lit fixture Sessions 3 and
##      5 actually placed: `post_lantern` (`boundary_layout.gd`) and
##      `lantern_standing` (`props_layout.gd`). Their ground positions are
##      recomputed independently through each session's own PUBLIC API rather
##      than trusted from a second-hand bookkeeping dictionary -- the same
##      "don't take the other session's word for it" discipline
##      `props_layout.gd`'s own `_find_wall_mount_targets()` already uses. The
##      +0.85 m vertical offset from base to flame-bowl height matches the
##      project's own established convention for this exact fixture family,
##      used identically in `riftfall_landing_layout.gd`,
##      `exterior_cohesion_route.gd` and `exterior_spike_layout.gd`. Colour,
##      energy, range, attenuation and "no shadows" are copied verbatim from
##      `exterior_review_lighting.gd`'s `add_lantern()` -- the brief names that
##      function directly as the template to reuse.
##
##   3. SPAWN RIFT GLOW -- one focused warm-violet `OmniLight3D` plus a flat,
##      unshaded, alpha-blended emissive disc at `ReferenceLandingBlueprint.
##      SPAWN`, using the project's own established rift purple,
##      `Color(0.482, 0.286, 0.702)` from `riftfall_loop_event.gd`'s
##      `RIFT_COLOUR` (see that file's `_rift_material()` for the closest
##      existing precedent to this idiom). THIS IS A PLACEHOLDER for Session
##      7's real crack shader on a flat ground quad -- not the final effect,
##      and it is deliberately not detailed geometry (no true cracks).
##
## Deliberately does NOT touch camera distance, pitch or FOV anywhere -- D-175's
## 19 m / 55 deg / 45 deg rig is project-wide locked and this file never
## constructs or references a camera at all.

# --- WorldEnvironment: cool ambient + light fog --------------------------------
const AMBIENT_COLOUR: Color = Color(0.30, 0.35, 0.46)
const AMBIENT_ENERGY: float = 0.62
const SKY_TOP: Color = Color(0.055, 0.062, 0.082)
const SKY_HORIZON: Color = Color(0.115, 0.120, 0.140)
const GROUND_HORIZON: Color = Color(0.085, 0.086, 0.094)
const GROUND_BOTTOM: Color = Color(0.028, 0.031, 0.038)
const FOG_COLOUR: Color = Color(0.075, 0.082, 0.098)
const FOG_DENSITY: float = 0.0032

# --- Lantern lights, copied from exterior_review_lighting.gd's add_lantern() --
const LANTERN_COLOUR: Color = Color(1.0, 0.72, 0.38)
const LANTERN_ENERGY: float = 4.0
const LANTERN_RANGE: float = 9.0
const LANTERN_ATTENUATION: float = 1.4
## Base-to-flame-bowl offset, matching the project's established convention for
## this fixture family (see class doc comment for the three call sites).
const LANTERN_HEIGHT_OFFSET: float = 0.85

# --- SPAWN rift glow ------------------------------------------------------------
const RIFT_COLOUR: Color = Color(0.482, 0.286, 0.702)
const RIFT_LIGHT_HEIGHT_OFFSET: float = 1.0
const RIFT_LIGHT_ENERGY: float = 5.0
const RIFT_LIGHT_RANGE: float = 6.5
## Tighter falloff than the lanterns' 1.4 -- "focused", per the brief, rather
## than a broad wash.
const RIFT_LIGHT_ATTENUATION: float = 1.6
## Flat disc, not a thin ring outline: the reference image's rift patch reads as
## a diffuse glowing crack AREA rather than a neat circle, and Session 7's real
## shader lands on "a flat ground quad" per its own brief -- a disc is the
## closer placeholder shape for what that becomes.
const RIFT_GLOW_RADIUS: float = 2.2
const RIFT_GLOW_HEIGHT: float = 0.02
const RIFT_GLOW_ALBEDO_ALPHA: float = 0.75
const RIFT_GLOW_EMISSION_ENERGY: float = 0.75


## Independently recomputes Session 3's `post_lantern` light positions by
## building `ReferenceLandingBoundaryLayout` onto a throwaway scratch node and
## reading its own reported `lantern_positions` (full `Vector3`, including
## ground height) -- never assumed, never hand-copied.
func _boundary_lantern_positions() -> Array[Vector3]:
	var scratch: Node3D = Node3D.new()
	var boundary: ReferenceLandingBoundaryLayout = ReferenceLandingBoundaryLayout.new()
	var result: Dictionary = boundary.build(scratch)
	var positions: Array[Vector3] = result["lantern_positions"]
	scratch.free()
	return positions


## Independently recomputes Session 5's `lantern_standing` fill positions using
## ONLY `ReferenceLandingPropsLayout`'s public constants and
## `ReferenceLandingBoundaryLayout`'s public static helpers -- the exact same
## arithmetic `props_layout.gd`'s own `_build_lantern_fill()` performs, without
## reading (or trusting) its private `placed` bookkeeping, which does not carry
## ground height anyway. Neither session's file is touched to get this.
func _lantern_fill_positions() -> Array[Vector3]:
	var lengths: Array[float] = ReferenceLandingGroundLayout.cumulative_arc_lengths()
	var total: float = lengths[lengths.size() - 1]
	var end: float = total - ReferenceLandingPropsLayout.LANTERN_FILL_END_MARGIN

	var positions: Array[Vector3] = []
	var arc: float = ReferenceLandingPropsLayout.LANTERN_FILL_START_ARC
	while arc <= end:
		for side: int in [ReferenceLandingPropsLayout.LEFT, ReferenceLandingPropsLayout.RIGHT]:
			if ReferenceLandingBoundaryLayout.is_breached(arc, side):
				continue
			positions.append(ReferenceLandingBoundaryLayout.edge_point(
				arc, side, ReferenceLandingPropsLayout.LANTERN_FILL_GAP
			))
		arc += ReferenceLandingPropsLayout.LANTERN_FILL_SPACING_ARC
	return positions


func _add_lantern_light(group: Node3D, base: Vector3, light_name: String) -> OmniLight3D:
	var light: OmniLight3D = OmniLight3D.new()
	light.name = light_name
	light.position = base + Vector3(0.0, LANTERN_HEIGHT_OFFSET, 0.0)
	light.light_color = LANTERN_COLOUR
	light.light_energy = LANTERN_ENERGY
	light.omni_range = LANTERN_RANGE
	light.omni_attenuation = LANTERN_ATTENUATION
	light.shadow_enabled = false
	group.add_child(light)
	return light


func _build_environment(parent: Node3D) -> WorldEnvironment:
	var sky_material: ProceduralSkyMaterial = ProceduralSkyMaterial.new()
	sky_material.sky_top_color = SKY_TOP
	sky_material.sky_horizon_color = SKY_HORIZON
	sky_material.ground_horizon_color = GROUND_HORIZON
	sky_material.ground_bottom_color = GROUND_BOTTOM
	var sky: Sky = Sky.new()
	sky.sky_material = sky_material

	var environment: Environment = Environment.new()
	environment.background_mode = Environment.BG_SKY
	environment.sky = sky
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = AMBIENT_COLOUR
	environment.ambient_light_energy = AMBIENT_ENERGY
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	environment.fog_enabled = true
	environment.fog_light_color = FOG_COLOUR
	environment.fog_density = FOG_DENSITY
	environment.glow_enabled = false
	environment.adjustment_enabled = false

	var node: WorldEnvironment = WorldEnvironment.new()
	node.name = "WorldEnvironment"
	node.environment = environment
	parent.add_child(node)
	return node


func _rift_material() -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(RIFT_COLOUR.r, RIFT_COLOUR.g, RIFT_COLOUR.b, RIFT_GLOW_ALBEDO_ALPHA)
	material.emission_enabled = true
	material.emission = RIFT_COLOUR
	material.emission_energy_multiplier = RIFT_GLOW_EMISSION_ENERGY
	return material


func _build_rift_glow(parent: Node3D) -> Dictionary:
	var group: Node3D = Node3D.new()
	group.name = "RiftGlow"
	parent.add_child(group)

	var light: OmniLight3D = OmniLight3D.new()
	light.name = "RiftLight"
	light.position = ReferenceLandingBlueprint.SPAWN + Vector3(0.0, RIFT_LIGHT_HEIGHT_OFFSET, 0.0)
	light.light_color = RIFT_COLOUR
	light.light_energy = RIFT_LIGHT_ENERGY
	light.omni_range = RIFT_LIGHT_RANGE
	light.omni_attenuation = RIFT_LIGHT_ATTENUATION
	light.shadow_enabled = false
	group.add_child(light)

	var disc: MeshInstance3D = MeshInstance3D.new()
	disc.name = "RiftGlowDisc"
	var cylinder: CylinderMesh = CylinderMesh.new()
	cylinder.top_radius = RIFT_GLOW_RADIUS
	cylinder.bottom_radius = RIFT_GLOW_RADIUS
	cylinder.height = RIFT_GLOW_HEIGHT
	cylinder.radial_segments = 32
	disc.mesh = cylinder
	var material: StandardMaterial3D = _rift_material()
	disc.material_override = material
	disc.position = Vector3(
		ReferenceLandingBlueprint.SPAWN.x, ReferenceLandingBlueprint.SPAWN.y + 0.03,
		ReferenceLandingBlueprint.SPAWN.z,
	)
	disc.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	group.add_child(disc)

	return {"light": light, "disc": disc, "material": material}


## Main entry point. Creates one "WorldEnvironment", one "Lights" `Node3D` and
## one "RiftGlow" `Node3D` under `parent`. Returns a `Dictionary` reporting
## exactly what it built, for `lighting_check.gd` to verify independently.
func build(parent: Node3D) -> Dictionary:
	var environment: WorldEnvironment = _build_environment(parent)

	var lights_group: Node3D = Node3D.new()
	lights_group.name = "Lights"
	parent.add_child(lights_group)

	var post_lantern_positions: Array[Vector3] = _boundary_lantern_positions()
	var lantern_standing_positions: Array[Vector3] = _lantern_fill_positions()

	var post_lantern_lights: Array[OmniLight3D] = []
	for i: int in post_lantern_positions.size():
		post_lantern_lights.append(
			_add_lantern_light(lights_group, post_lantern_positions[i], "PostLanternLight_%d" % i)
		)

	var lantern_standing_lights: Array[OmniLight3D] = []
	for i: int in lantern_standing_positions.size():
		lantern_standing_lights.append(
			_add_lantern_light(lights_group, lantern_standing_positions[i], "LanternStandingLight_%d" % i)
		)

	var lantern_lights: Array[OmniLight3D] = []
	lantern_lights.append_array(post_lantern_lights)
	lantern_lights.append_array(lantern_standing_lights)

	var rift: Dictionary = _build_rift_glow(parent)

	return {
		"environment": environment,
		"lights_group": lights_group,
		"post_lantern_positions": post_lantern_positions,
		"lantern_standing_positions": lantern_standing_positions,
		"post_lantern_lights": post_lantern_lights,
		"lantern_standing_lights": lantern_standing_lights,
		"lantern_lights": lantern_lights,
		"lantern_light_count": lantern_lights.size(),
		"rift_light": rift["light"],
		"rift_glow_disc": rift["disc"],
		"rift_glow_material": rift["material"],
	}
