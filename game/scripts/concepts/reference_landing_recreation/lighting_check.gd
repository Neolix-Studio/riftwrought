extends SceneTree
## Reference Landing Recreation -- Session 6 headless check (NON-CANONICAL).
##
## Builds the Lighting layout onto a scratch (never-in-the-real-tree) `Node3D`,
## then runs four independent checks against the returned bookkeeping:
##
##   ENVIRONMENT CHECK -- the `WorldEnvironment`'s ambient colour/energy and fog
##                         colour/density/enabled state match this session's own
##                         declared constants exactly.
##
##   LANTERN CHECK      -- EXHAUSTIVE, not a sample: every `post_lantern`
##                         position Session 3 places and every `lantern_standing`
##                         position Session 5 places (both recomputed
##                         independently, exactly as `lighting_layout.gd` itself
##                         does) has exactly one matching `OmniLight3D` at the
##                         established +0.85 m height offset, with the correct
##                         colour, energy, range and no shadow -- checked in both
##                         directions, so an extra or a missing light is caught.
##                         The `lantern_standing` recount is ALSO cross-checked
##                         against `ReferenceLandingPropsLayout.build()`'s own
##                         reported count, so the independent recomputation is
##                         proved to agree with what Session 5 actually placed,
##                         not just with itself.
##
##   RIFT CHECK          -- the SPAWN light sits at SPAWN plus the declared
##                         height offset, in the project's own established rift
##                         purple; the glow disc sits at SPAWN, is unshaded,
##                         alpha-blended, emissive in the same colour, with its
##                         emission energy inside the brief's 0.6-0.9 band.
##
##   SCOPE CHECK         -- this file and `lighting_layout.gd` name no camera
##                         property (distance/pitch/FOV/yaw) anywhere -- this
##                         session tunes light and fog only, never the locked
##                         D-175 rig.
##
## Run with:
##   godot --headless --path game --import
##   godot --headless --path game --script res://scripts/concepts/reference_landing_recreation/lighting_check.gd

const EPSILON: float = 0.01


func _initialize() -> void:
	print("=== Reference Landing Recreation -- Session 6 lighting check ===")

	var scratch: Node3D = Node3D.new()
	var layout: ReferenceLandingLightingLayout = ReferenceLandingLightingLayout.new()
	var result: Dictionary = layout.build(scratch)

	var overall_ok: bool = true

	# --- ENVIRONMENT CHECK --------------------------------------------------------
	print("")
	var environment_node: WorldEnvironment = result["environment"]
	var env_ok: bool = environment_node != null and environment_node.environment != null
	var env_failure: String = "" if env_ok else "no WorldEnvironment/Environment built"
	if env_ok:
		var env: Environment = environment_node.environment
		if env.ambient_light_source != Environment.AMBIENT_SOURCE_COLOR:
			env_ok = false
			env_failure = "ambient_light_source is not AMBIENT_SOURCE_COLOR"
		elif not env.ambient_light_color.is_equal_approx(ReferenceLandingLightingLayout.AMBIENT_COLOUR):
			env_ok = false
			env_failure = "ambient_light_color %s != expected %s" % [
				env.ambient_light_color, ReferenceLandingLightingLayout.AMBIENT_COLOUR,
			]
		elif not is_equal_approx(env.ambient_light_energy, ReferenceLandingLightingLayout.AMBIENT_ENERGY):
			env_ok = false
			env_failure = "ambient_light_energy %.4f != expected %.4f" % [
				env.ambient_light_energy, ReferenceLandingLightingLayout.AMBIENT_ENERGY,
			]
		elif not env.fog_enabled:
			env_ok = false
			env_failure = "fog_enabled is false"
		elif not env.fog_light_color.is_equal_approx(ReferenceLandingLightingLayout.FOG_COLOUR):
			env_ok = false
			env_failure = "fog_light_color %s != expected %s" % [
				env.fog_light_color, ReferenceLandingLightingLayout.FOG_COLOUR,
			]
		elif not is_equal_approx(env.fog_density, ReferenceLandingLightingLayout.FOG_DENSITY):
			env_ok = false
			env_failure = "fog_density %.6f != expected %.6f" % [
				env.fog_density, ReferenceLandingLightingLayout.FOG_DENSITY,
			]
	print("ambient: colour %s, energy %.4f" % [
		environment_node.environment.ambient_light_color if env_ok or environment_node != null else Color(),
		environment_node.environment.ambient_light_energy if environment_node != null and environment_node.environment != null else 0.0,
	])
	if env_ok:
		print("ENVIRONMENT CHECK: PASS")
	else:
		overall_ok = false
		print("ENVIRONMENT CHECK: FAIL: %s" % env_failure)

	# --- LANTERN CHECK (exhaustive, both directions) -------------------------------
	print("")
	var expected_post_lantern: Array[Vector3] = _independent_boundary_lantern_positions()
	var expected_lantern_standing: Array[Vector3] = _independent_lantern_fill_positions()

	var props_scratch: Node3D = Node3D.new()
	var props_result: Dictionary = ReferenceLandingPropsLayout.new().build(props_scratch)
	var props_reported: int = int(Dictionary(props_result["lantern_counts"]).get("lantern_standing", 0))
	props_scratch.free()

	print("post_lantern positions recomputed: %d" % expected_post_lantern.size())
	print("lantern_standing positions recomputed: %d (Session 5's own build() reports %d)" % [
		expected_lantern_standing.size(), props_reported,
	])

	var lantern_ok: bool = true
	var lantern_failure: String = ""

	if expected_lantern_standing.size() != props_reported:
		lantern_ok = false
		lantern_failure = "recomputed lantern_standing count %d != Session 5's own reported %d" % [
			expected_lantern_standing.size(), props_reported,
		]

	var post_lantern_lights: Array = result["post_lantern_lights"]
	var lantern_standing_lights: Array = result["lantern_standing_lights"]

	if lantern_ok and post_lantern_lights.size() != expected_post_lantern.size():
		lantern_ok = false
		lantern_failure = "post_lantern light count %d != expected %d" % [
			post_lantern_lights.size(), expected_post_lantern.size(),
		]
	if lantern_ok and lantern_standing_lights.size() != expected_lantern_standing.size():
		lantern_ok = false
		lantern_failure = "lantern_standing light count %d != expected %d" % [
			lantern_standing_lights.size(), expected_lantern_standing.size(),
		]

	if lantern_ok:
		lantern_ok = _lights_match_bases(
			post_lantern_lights, expected_post_lantern, "post_lantern"
		)
		if not lantern_ok:
			lantern_failure = "a post_lantern light did not match its expected base position/properties"
	if lantern_ok:
		lantern_ok = _lights_match_bases(
			lantern_standing_lights, expected_lantern_standing, "lantern_standing"
		)
		if not lantern_ok:
			lantern_failure = "a lantern_standing light did not match its expected base position/properties"

	var total_lantern_lights: int = int(result["lantern_light_count"])
	print("total lantern OmniLight3D instances: %d" % total_lantern_lights)
	if lantern_ok and total_lantern_lights != expected_post_lantern.size() + expected_lantern_standing.size():
		lantern_ok = false
		lantern_failure = "lantern_light_count %d != sum of recomputed positions %d" % [
			total_lantern_lights, expected_post_lantern.size() + expected_lantern_standing.size(),
		]

	if lantern_ok:
		print("LANTERN CHECK: PASS (checked all %d lights in both directions)" % total_lantern_lights)
	else:
		overall_ok = false
		print("LANTERN CHECK: FAIL: %s" % lantern_failure)

	# --- RIFT CHECK -----------------------------------------------------------------
	print("")
	var rift_light: OmniLight3D = result["rift_light"]
	var rift_disc: MeshInstance3D = result["rift_glow_disc"]
	var rift_material: StandardMaterial3D = result["rift_glow_material"]

	var rift_ok: bool = true
	var rift_failure: String = ""

	var expected_light_pos: Vector3 = ReferenceLandingBlueprint.SPAWN + Vector3(
		0.0, ReferenceLandingLightingLayout.RIFT_LIGHT_HEIGHT_OFFSET, 0.0
	)
	if not rift_light.position.is_equal_approx(expected_light_pos):
		rift_ok = false
		rift_failure = "rift light at %s, expected %s" % [rift_light.position, expected_light_pos]
	elif not rift_light.light_color.is_equal_approx(ReferenceLandingLightingLayout.RIFT_COLOUR):
		rift_ok = false
		rift_failure = "rift light colour %s != expected %s" % [
			rift_light.light_color, ReferenceLandingLightingLayout.RIFT_COLOUR,
		]
	elif rift_light.shadow_enabled:
		rift_ok = false
		rift_failure = "rift light has shadows enabled"

	if rift_ok:
		var dx: float = rift_disc.position.x - ReferenceLandingBlueprint.SPAWN.x
		var dz: float = rift_disc.position.z - ReferenceLandingBlueprint.SPAWN.z
		if sqrt(dx * dx + dz * dz) > EPSILON:
			rift_ok = false
			rift_failure = "rift glow disc not centred on SPAWN: offset (%.3f, %.3f)" % [dx, dz]
	if rift_ok and rift_material.shading_mode != BaseMaterial3D.SHADING_MODE_UNSHADED:
		rift_ok = false
		rift_failure = "rift glow material is not unshaded"
	if rift_ok and rift_material.transparency != BaseMaterial3D.TRANSPARENCY_ALPHA:
		rift_ok = false
		rift_failure = "rift glow material is not alpha-blended"
	if rift_ok and not rift_material.emission_enabled:
		rift_ok = false
		rift_failure = "rift glow material has emission disabled"
	if rift_ok:
		var emission: Color = rift_material.emission
		if not emission.is_equal_approx(ReferenceLandingLightingLayout.RIFT_COLOUR):
			rift_ok = false
			rift_failure = "rift glow emission %s != expected %s" % [
				emission, ReferenceLandingLightingLayout.RIFT_COLOUR,
			]
	if rift_ok:
		var multiplier: float = rift_material.emission_energy_multiplier
		if multiplier < 0.6 or multiplier > 0.9:
			rift_ok = false
			rift_failure = "rift glow emission_energy_multiplier %.3f outside 0.6-0.9" % multiplier

	print("rift light: %s, energy %.2f, range %.2f" % [
		rift_light.position, rift_light.light_energy, rift_light.omni_range,
	])
	print("rift glow disc: %s, emission_energy_multiplier %.3f" % [
		rift_disc.position, rift_material.emission_energy_multiplier,
	])
	if rift_ok:
		print("RIFT CHECK: PASS")
	else:
		overall_ok = false
		print("RIFT CHECK: FAIL: %s" % rift_failure)

	# --- SCOPE CHECK: never a camera property --------------------------------------
	print("")
	var scope_ok: bool = true
	var scope_failure: String = ""
	var forbidden: PackedStringArray = [
		"distance_metres", "pitch_degrees", "fov_degrees", "yaw_degrees", "Camera3D", "CameraRig",
	]
	var source: String = FileAccess.get_file_as_string(
		"res://scripts/concepts/reference_landing_recreation/lighting_layout.gd"
	)
	for token: String in forbidden:
		if source.find(token) != -1:
			scope_ok = false
			scope_failure = "lighting_layout.gd names a forbidden camera token: %s" % token
			break
	if scope_ok:
		print("SCOPE CHECK: PASS (lighting_layout.gd names no camera property)")
	else:
		overall_ok = false
		print("SCOPE CHECK: FAIL: %s" % scope_failure)

	# --- Final verdict --------------------------------------------------------------
	print("")
	scratch.free()

	if overall_ok:
		print("LIGHTING CHECK: PASS")
		quit(0)
	else:
		printerr("LIGHTING CHECK: FAIL")
		quit(1)


## Every light in `lights` must match exactly one position in `bases` (within
## EPSILON, at the +0.85 m height offset) with the correct colour/energy/range
## and no shadow, and every base must be claimed by exactly one light -- a
## bijection check, not a one-way sample.
func _lights_match_bases(lights: Array, bases: Array[Vector3], label: String) -> bool:
	if lights.size() != bases.size():
		printerr("%s: light count %d != base count %d" % [label, lights.size(), bases.size()])
		return false
	var claimed: Array[bool] = []
	claimed.resize(bases.size())
	claimed.fill(false)
	for light: OmniLight3D in lights:
		if not light.light_color.is_equal_approx(ReferenceLandingLightingLayout.LANTERN_COLOUR):
			printerr("%s: light %s has wrong colour %s" % [label, light.name, light.light_color])
			return false
		if not is_equal_approx(light.light_energy, ReferenceLandingLightingLayout.LANTERN_ENERGY):
			printerr("%s: light %s has wrong energy %.3f" % [label, light.name, light.light_energy])
			return false
		if not is_equal_approx(light.omni_range, ReferenceLandingLightingLayout.LANTERN_RANGE):
			printerr("%s: light %s has wrong range %.3f" % [label, light.name, light.omni_range])
			return false
		if light.shadow_enabled:
			printerr("%s: light %s has shadows enabled" % [label, light.name])
			return false
		var matched: int = -1
		for i: int in bases.size():
			if claimed[i]:
				continue
			var expected: Vector3 = bases[i] + Vector3(
				0.0, ReferenceLandingLightingLayout.LANTERN_HEIGHT_OFFSET, 0.0
			)
			if light.position.is_equal_approx(expected):
				matched = i
				break
		if matched == -1:
			printerr("%s: light %s at %s matches no expected base position" % [label, light.name, light.position])
			return false
		claimed[matched] = true
	for i: int in claimed.size():
		if not claimed[i]:
			printerr("%s: base position %s has no matching light" % [label, bases[i]])
			return false
	return true


func _independent_boundary_lantern_positions() -> Array[Vector3]:
	var scratch: Node3D = Node3D.new()
	var result: Dictionary = ReferenceLandingBoundaryLayout.new().build(scratch)
	var positions: Array[Vector3] = result["lantern_positions"]
	scratch.free()
	return positions


func _independent_lantern_fill_positions() -> Array[Vector3]:
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
