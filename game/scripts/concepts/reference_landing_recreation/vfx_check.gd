extends SceneTree
## Reference Landing Recreation -- Session 7 headless check (NON-CANONICAL).
##
## Builds the Vfx layout onto a scratch (never-in-the-real-tree) Node3D --
## `_process` never fires on it, so every animated result below comes from
## explicit `advance()` calls, exactly as `vfx_layout.gd`'s class doc comment
## describes -- then runs five independent checks:
##
##   SHADER FILE CHECK  -- the shader is a real .gdshader file on disk (not
##                          an inline string, unlike
##                          `exterior_review_treatment.gd`'s own precedent),
##                          declares `shader_type spatial`, and the crack
##                          quad's material is a genuine `ShaderMaterial`
##                          loaded from that exact resource path.
##
##   CRACK QUAD CHECK   -- the quad's mesh, size, position, rotation and
##                          no-shadow state match this file's own declared
##                          constants, and every shader parameter this
##                          session set is actually present on the built
##                          material with the expected value.
##
##   ANIMATION CHECK    -- advancing a fresh instance by fixed deltas
##                          accumulates `simulation_seconds` exactly and the
##                          shader's own "time" parameter tracks it exactly --
##                          proving the uniform genuinely changes rather than
##                          sitting frozen at its build-time default.
##
##   FLICKER CHECK      -- the flicker light's position is recomputed
##                          independently via
##                          `ReferenceLandingBoundaryLayout.edge_point()`,
##                          never trusted from `vfx_layout.gd`'s own working;
##                          its colour/range/attenuation/no-shadow match the
##                          declared constants; advancing it changes
##                          `light_energy` away from the built default (it
##                          genuinely flickers); and two INDEPENDENTLY built
##                          instances, advanced through the identical delta
##                          sequence, land on the identical final
##                          `light_energy` (the flicker is deterministic, not
##                          engine RNG state -- see the class doc comment).
##
##   MOTES CHECK        -- the particle system exists with the declared
##                          amount/lifetime, an emissive unshaded billboard
##                          draw pass in the project's own rift purple, a
##                          process material whose direction is +Y (upward
##                          drift, per the brief), and a non-zero-volume
##                          `visibility_aabb`. That last one is here because
##                          it is exactly the kind of thing every other check
##                          above would pass while the effect stayed
##                          completely invisible on screen: GPUParticles3D
##                          does not auto-fit its own culling box the way a
##                          MeshInstance3D does, and the first rendered
##                          screenshot for this session showed zero visible
##                          motes despite every other property being correct
##                          -- caught only by looking at the picture, exactly
##                          as this project's own Gate F HUD-anchor defect
##                          was.
##
## Run with:
##   godot --headless --path game --import
##   godot --headless --path game --script res://scripts/concepts/reference_landing_recreation/vfx_check.gd


func _initialize() -> void:
	print("=== Reference Landing Recreation -- Session 7 VFX check ===")

	var scratch: Node3D = Node3D.new()
	var layout: ReferenceLandingVfxLayout = ReferenceLandingVfxLayout.new()
	var result: Dictionary = layout.build(scratch)

	var overall_ok: bool = true

	# --- SHADER FILE CHECK -----------------------------------------------------
	print("")
	var shader_ok: bool = true
	var shader_failure: String = ""
	var shader_path: String = ReferenceLandingVfxLayout.SHADER_PATH
	if not FileAccess.file_exists(shader_path):
		shader_ok = false
		shader_failure = "shader file does not exist on disk: %s" % shader_path
	else:
		var source: String = FileAccess.get_file_as_string(shader_path)
		if source.find("shader_type spatial") == -1:
			shader_ok = false
			shader_failure = "shader file does not declare shader_type spatial"

	var crack_material: ShaderMaterial = result["crack_material"]
	if shader_ok and crack_material == null:
		shader_ok = false
		shader_failure = "crack quad has no ShaderMaterial"
	elif shader_ok and crack_material.shader == null:
		shader_ok = false
		shader_failure = "crack quad's ShaderMaterial has no Shader assigned"
	elif shader_ok and crack_material.shader.resource_path != shader_path:
		shader_ok = false
		shader_failure = "crack quad's Shader resource_path %s != expected %s" % [
			crack_material.shader.resource_path, shader_path,
		]

	print("shader path: %s" % shader_path)
	if shader_ok:
		print("SHADER FILE CHECK: PASS (real .gdshader file, not an inline string)")
	else:
		overall_ok = false
		print("SHADER FILE CHECK: FAIL: %s" % shader_failure)

	# --- CRACK QUAD CHECK -------------------------------------------------------
	print("")
	var crack_ok: bool = true
	var crack_failure: String = ""
	var mesh_instance: MeshInstance3D = result["crack_mesh"]
	var quad: QuadMesh = mesh_instance.mesh as QuadMesh
	if quad == null:
		crack_ok = false
		crack_failure = "crack quad mesh is not a QuadMesh"
	elif not quad.size.is_equal_approx(Vector2(
		ReferenceLandingVfxLayout.CRACK_QUAD_SIZE, ReferenceLandingVfxLayout.CRACK_QUAD_SIZE
	)):
		crack_ok = false
		crack_failure = "crack quad size %s != expected %.3f x %.3f" % [
			quad.size, ReferenceLandingVfxLayout.CRACK_QUAD_SIZE, ReferenceLandingVfxLayout.CRACK_QUAD_SIZE,
		]

	var expected_pos: Vector3 = Vector3(
		ReferenceLandingBlueprint.SPAWN.x,
		ReferenceLandingBlueprint.SPAWN.y + ReferenceLandingVfxLayout.CRACK_HEIGHT_OFFSET,
		ReferenceLandingBlueprint.SPAWN.z,
	)
	if crack_ok and not mesh_instance.position.is_equal_approx(expected_pos):
		crack_ok = false
		crack_failure = "crack quad position %s != expected %s" % [mesh_instance.position, expected_pos]
	if crack_ok and not mesh_instance.rotation_degrees.is_equal_approx(Vector3(-90.0, 0.0, 0.0)):
		crack_ok = false
		crack_failure = "crack quad rotation_degrees %s != expected (-90, 0, 0)" % mesh_instance.rotation_degrees
	if crack_ok and mesh_instance.cast_shadow != GeometryInstance3D.SHADOW_CASTING_SETTING_OFF:
		crack_ok = false
		crack_failure = "crack quad casts a shadow"
	if crack_ok and mesh_instance.material_override != crack_material:
		crack_ok = false
		crack_failure = "crack quad's material_override is not the built ShaderMaterial"

	var expected_params: Dictionary = {
		"rift_colour": Vector3(
			ReferenceLandingVfxLayout.RIFT_COLOUR.r,
			ReferenceLandingVfxLayout.RIFT_COLOUR.g,
			ReferenceLandingVfxLayout.RIFT_COLOUR.b,
		),
		"cell_scale": ReferenceLandingVfxLayout.CRACK_CELL_SCALE,
		"crack_width": ReferenceLandingVfxLayout.CRACK_WIDTH,
		"pulse_speed": ReferenceLandingVfxLayout.CRACK_PULSE_SPEED,
		"pulse_strength": ReferenceLandingVfxLayout.CRACK_PULSE_STRENGTH,
		"drift_speed": ReferenceLandingVfxLayout.CRACK_DRIFT_SPEED,
		"emission_energy": ReferenceLandingVfxLayout.CRACK_EMISSION_ENERGY,
		"base_alpha": ReferenceLandingVfxLayout.CRACK_BASE_ALPHA,
		"radius_fade_start": ReferenceLandingVfxLayout.CRACK_RADIUS_FADE_START,
		"radius_fade_end": ReferenceLandingVfxLayout.CRACK_RADIUS_FADE_END,
	}
	for key: String in expected_params.keys():
		if not crack_ok:
			break
		var actual: Variant = crack_material.get_shader_parameter(key)
		var expected: Variant = expected_params[key]
		var matches: bool = false
		if expected is Vector3:
			matches = actual != null and (actual as Vector3).is_equal_approx(expected)
		else:
			matches = actual != null and is_equal_approx(float(actual), float(expected))
		if not matches:
			crack_ok = false
			crack_failure = "shader parameter %s = %s != expected %s" % [key, actual, expected]

	print("crack quad: %s, size %s, position %s" % [
		mesh_instance.name, quad.size if quad != null else Vector2(), mesh_instance.position,
	])
	if crack_ok:
		print("CRACK QUAD CHECK: PASS (checked %d shader parameters)" % expected_params.size())
	else:
		overall_ok = false
		print("CRACK QUAD CHECK: FAIL: %s" % crack_failure)

	# --- ANIMATION CHECK ---------------------------------------------------------
	print("")
	var anim_scratch: Node3D = Node3D.new()
	var anim_layout: ReferenceLandingVfxLayout = ReferenceLandingVfxLayout.new()
	var anim_result: Dictionary = anim_layout.build(anim_scratch)
	var anim_material: ShaderMaterial = anim_result["crack_material"]

	var anim_ok: bool = true
	var anim_failure: String = ""
	var deltas: Array[float] = [0.5, 0.25, 1.75, 0.10]
	var running_total: float = 0.0
	var seen_time_values: Array[float] = []
	for d: float in deltas:
		anim_layout.advance(d)
		running_total += d
		if not is_equal_approx(anim_layout.simulation_seconds, running_total):
			anim_ok = false
			anim_failure = "simulation_seconds %.6f != expected running total %.6f" % [
				anim_layout.simulation_seconds, running_total,
			]
			break
		var shader_time: Variant = anim_material.get_shader_parameter("time")
		if shader_time == null or not is_equal_approx(float(shader_time), running_total):
			anim_ok = false
			anim_failure = "shader time parameter %s != expected %.6f after advance(%.3f)" % [
				shader_time, running_total, d,
			]
			break
		seen_time_values.append(float(shader_time))

	if anim_ok and seen_time_values.size() >= 2 \
			and is_equal_approx(seen_time_values[0], seen_time_values[seen_time_values.size() - 1]):
		anim_ok = false
		anim_failure = "shader time parameter never changed across %d advance() calls" % deltas.size()

	print("simulation_seconds after %d advance() calls: %.4f" % [deltas.size(), anim_layout.simulation_seconds])
	print("shader time values observed: %s" % [seen_time_values])
	if anim_ok:
		print("ANIMATION CHECK: PASS")
	else:
		overall_ok = false
		print("ANIMATION CHECK: FAIL: %s" % anim_failure)
	anim_scratch.free()

	# --- FLICKER CHECK --------------------------------------------------------
	print("")
	var flicker_ok: bool = true
	var flicker_failure: String = ""
	var flicker_light: OmniLight3D = result["flicker_light"]

	var expected_edge: Vector3 = ReferenceLandingBoundaryLayout.edge_point(
		ReferenceLandingVfxLayout.FLICKER_ARC, ReferenceLandingBoundaryLayout.LEFT,
		ReferenceLandingVfxLayout.FLICKER_EDGE_OFFSET,
	) + Vector3(0.0, ReferenceLandingVfxLayout.FLICKER_HEIGHT_OFFSET, 0.0)

	if not flicker_light.position.is_equal_approx(expected_edge):
		flicker_ok = false
		flicker_failure = "flicker light position %s != independently recomputed %s" % [
			flicker_light.position, expected_edge,
		]
	elif not flicker_light.light_color.is_equal_approx(ReferenceLandingVfxLayout.FLICKER_COLOUR):
		flicker_ok = false
		flicker_failure = "flicker light colour %s != expected %s" % [
			flicker_light.light_color, ReferenceLandingVfxLayout.FLICKER_COLOUR,
		]
	elif not is_equal_approx(flicker_light.omni_range, ReferenceLandingVfxLayout.FLICKER_RANGE):
		flicker_ok = false
		flicker_failure = "flicker light range %.3f != expected %.3f" % [
			flicker_light.omni_range, ReferenceLandingVfxLayout.FLICKER_RANGE,
		]
	elif not is_equal_approx(flicker_light.omni_attenuation, ReferenceLandingVfxLayout.FLICKER_ATTENUATION):
		flicker_ok = false
		flicker_failure = "flicker light attenuation %.3f != expected %.3f" % [
			flicker_light.omni_attenuation, ReferenceLandingVfxLayout.FLICKER_ATTENUATION,
		]
	elif flicker_light.shadow_enabled:
		flicker_ok = false
		flicker_failure = "flicker light has shadows enabled"

	# Advancing changes the energy away from the plain base value -- it
	# genuinely flickers rather than sitting fixed.
	if flicker_ok:
		var initial_energy: float = flicker_light.light_energy
		for i: int in 40:
			layout.advance(0.05)
		if is_equal_approx(flicker_light.light_energy, initial_energy):
			flicker_ok = false
			flicker_failure = "flicker light energy never changed across 2.0s of advance()"

	# Determinism: two fresh instances, advanced through the identical delta
	# sequence, must land on the identical final light_energy -- read back
	# through build()'s own public return value, never a private member.
	if flicker_ok:
		var seq: Array[float] = [0.03, 0.11, 0.07, 0.20, 0.05, 0.09, 0.13, 0.02, 0.15, 0.08]
		var final_energies: Array[float] = []
		for run: int in 2:
			var det_scratch: Node3D = Node3D.new()
			var det_layout: ReferenceLandingVfxLayout = ReferenceLandingVfxLayout.new()
			var det_result: Dictionary = det_layout.build(det_scratch)
			for d: float in seq:
				det_layout.advance(d)
			final_energies.append((det_result["flicker_light"] as OmniLight3D).light_energy)
			det_scratch.free()
		if not is_equal_approx(final_energies[0], final_energies[1]):
			flicker_ok = false
			flicker_failure = "flicker is not deterministic: %.6f != %.6f for the same delta sequence" % [
				final_energies[0], final_energies[1],
			]

	print("flicker light: %s, base energy %.2f, current energy %.3f" % [
		flicker_light.position, ReferenceLandingVfxLayout.FLICKER_BASE_ENERGY, flicker_light.light_energy,
	])
	if flicker_ok:
		print("FLICKER CHECK: PASS (changes over time, and is deterministic across independent runs)")
	else:
		overall_ok = false
		print("FLICKER CHECK: FAIL: %s" % flicker_failure)

	# --- MOTES CHECK -------------------------------------------------------------
	print("")
	var motes_ok: bool = true
	var motes_failure: String = ""
	var particles: GPUParticles3D = result["particles"]
	if particles == null:
		motes_ok = false
		motes_failure = "no GPUParticles3D built"
	elif particles.amount != ReferenceLandingVfxLayout.MOTE_AMOUNT:
		motes_ok = false
		motes_failure = "particle amount %d != expected %d" % [particles.amount, ReferenceLandingVfxLayout.MOTE_AMOUNT]
	elif not is_equal_approx(particles.lifetime, ReferenceLandingVfxLayout.MOTE_LIFETIME):
		motes_ok = false
		motes_failure = "particle lifetime %.3f != expected %.3f" % [particles.lifetime, ReferenceLandingVfxLayout.MOTE_LIFETIME]
	else:
		var draw_mesh: QuadMesh = particles.draw_pass_1 as QuadMesh
		if draw_mesh == null:
			motes_ok = false
			motes_failure = "particle draw_pass_1 is not a QuadMesh"
		else:
			var mote_material: StandardMaterial3D = draw_mesh.material as StandardMaterial3D
			if mote_material == null:
				motes_ok = false
				motes_failure = "particle mesh has no StandardMaterial3D"
			elif mote_material.shading_mode != BaseMaterial3D.SHADING_MODE_UNSHADED:
				motes_ok = false
				motes_failure = "particle material is not unshaded"
			elif not mote_material.emission_enabled:
				motes_ok = false
				motes_failure = "particle material has emission disabled"
			elif not mote_material.emission.is_equal_approx(ReferenceLandingVfxLayout.RIFT_COLOUR):
				motes_ok = false
				motes_failure = "particle emission colour %s != expected %s" % [
					mote_material.emission, ReferenceLandingVfxLayout.RIFT_COLOUR,
				]
			elif mote_material.billboard_mode != BaseMaterial3D.BILLBOARD_ENABLED:
				motes_ok = false
				motes_failure = "particle mesh is not billboarded"

		var process_material: ParticleProcessMaterial = particles.process_material as ParticleProcessMaterial
		if motes_ok and process_material == null:
			motes_ok = false
			motes_failure = "particles have no ParticleProcessMaterial"
		elif motes_ok and not process_material.direction.is_equal_approx(Vector3(0.0, 1.0, 0.0)):
			motes_ok = false
			motes_failure = "particle direction %s != expected upward (0, 1, 0)" % process_material.direction
		elif motes_ok and particles.visibility_aabb.get_volume() <= 0.0:
			motes_ok = false
			motes_failure = "particles have a zero-volume visibility_aabb -- silently frustum-culled and invisible on screen despite every other property being correct"

	print("particles: amount %d, lifetime %.2f" % [
		particles.amount if particles != null else 0, particles.lifetime if particles != null else 0.0,
	])
	if motes_ok:
		print("MOTES CHECK: PASS")
	else:
		overall_ok = false
		print("MOTES CHECK: FAIL: %s" % motes_failure)

	# --- Final verdict --------------------------------------------------------------
	print("")
	scratch.free()

	if overall_ok:
		print("VFX CHECK: PASS")
		quit(0)
	else:
		printerr("VFX CHECK: FAIL")
		quit(1)
