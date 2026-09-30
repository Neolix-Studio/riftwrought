class_name ExteriorReviewTreatment
extends RefCounted
## First-MVP Gate 1B — the non-destructive candidate MATERIAL treatment
## (specification §6.2 and §6.3).
##
## THE SAFETY RULE FIRST. "Raw third-party textures and meshes stay unchanged.
## Any treatment uses scene overrides, duplicated runtime materials, or new
## project-authored resources. Switching back to source mode must reproduce the
## imported source presentation."
##
## So nothing here ever writes to an imported material. Every candidate material
## is built fresh at runtime; it is applied through
## `MeshInstance3D.set_surface_override_material()`, which is a per-surface scene
## override; and returning to source mode sets every one of those overrides back
## to null. A per-surface override is used rather than `material_override`
## precisely because two candidates carry several materials at once —
## k0rveen's `Terrain_1` has two surfaces and its `Tree_1` has five across four
## meshes — and a single `material_override` would silently collapse them into
## one, which would misrepresent the asset the owner is judging.
##
## This is Prototype Zero's D-191 lesson applied before it can bite: an aim
## assistance setting scaled the CACHED canonical `quick_strike.tres` in place and
## compounded across reloads. A material treatment that edited the imported
## material would do exactly the same thing, and would compound every time the
## owner pressed F2. `fingerprints()` records every source material before the
## first treatment and `source_is_intact()` re-reads them afterwards, so the
## claim is measured on every toggle rather than promised.
##
## THE TREATMENT IS ONE RULE, NOT A PALETTE. Specification §2 forbids "permanent
## palette, lighting, fog, post-processing, terrain, or material decisions", so
## this deliberately does not hand-pick a colour per asset — which would be a
## palette decision wearing a spike's clothes. It applies the same three numbers
## to every surface of every family:
##
##   saturation  x SATURATION   (toward luminance)
##   value       x VALUE
##   tint        x TINT         (a slight cool cast)
##
## A textured KayKit surface gets them through a small project-authored shader
## that samples the SAME imported texture, because an albedo multiply cannot
## desaturate a texture — it can only darken or tint it. An untextured k0rveen
## surface gets exactly the same arithmetic applied to its flat albedo colour.
## The three numbers are stated on the overlay and in the report so the owner can
## ask for different ones; they are a proposal, not a decision.

## Applied to both families. Stated on screen.
const SATURATION: float = 0.42
const VALUE: float = 0.62
const TINT: Color = Color(0.88, 0.90, 0.97)

## The candidate shader. It is compiled at runtime from this string and never
## written to disk, so the spike adds no shader resource file and the treatment
## cannot outlive the session.
const CANDIDATE_SHADER: String = """
shader_type spatial;
render_mode cull_back, diffuse_burley, specular_schlick_ggx;

// Riftwrought — Gate 1B candidate exterior treatment (RUNTIME ONLY).
// Samples the imported KayKit atlas unchanged and desaturates, darkens, and
// slightly cools the result. The source texture is never modified.
uniform sampler2D source_albedo : source_color, filter_linear_mipmap;
uniform float saturation : hint_range(0.0, 1.0) = 0.42;
uniform float value_scale : hint_range(0.0, 2.0) = 0.62;
uniform vec3 tint : source_color = vec3(0.88, 0.90, 0.97);
uniform float roughness_value : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 sampled = texture(source_albedo, UV);
	float luminance = dot(sampled.rgb, vec3(0.2126, 0.7152, 0.0722));
	vec3 treated = mix(vec3(luminance), sampled.rgb, saturation) * value_scale * tint;
	ALBEDO = treated;
	ROUGHNESS = roughness_value;
	METALLIC = 0.0;
	SPECULAR = 0.12;
}
"""

## One registered surface: where it lives, what it looked like when it was found,
## and the candidate material built for it.
var _surfaces: Array[Dictionary] = []
var _shader: Shader
var _candidate_active: bool = false
## Set when a registered source material is something this treatment cannot
## faithfully reproduce — a double-sided or transparent surface, which the
## runtime shader's `cull_back` and opaque blending would silently change. None
## of the manifest's candidates is either; this exists so that a future one
## cannot slip past unnoticed.
var unfaithful_surfaces: PackedStringArray = PackedStringArray()


func _init() -> void:
	_shader = Shader.new()
	_shader.code = CANDIDATE_SHADER


## Registers every surface under `node`. Called once, while the scene is being
## built and before any treatment has been applied, so the fingerprints are of
## the genuinely imported state.
func register(node: Node3D, label: String) -> void:
	for mesh_instance: MeshInstance3D in _meshes_under(node):
		for surface: int in mesh_instance.mesh.get_surface_count():
			var source: Material = mesh_instance.get_active_material(surface)
			if source == null:
				continue
			var standard: StandardMaterial3D = source as StandardMaterial3D
			if standard == null:
				continue
			if standard.cull_mode == BaseMaterial3D.CULL_DISABLED:
				unfaithful_surfaces.append("%s: double-sided" % label)
			if standard.transparency != BaseMaterial3D.TRANSPARENCY_DISABLED:
				unfaithful_surfaces.append("%s: transparent" % label)
			_surfaces.append({
				"label": label,
				"mesh": mesh_instance,
				"surface": surface,
				"source": standard,
				"fingerprint": fingerprint(standard),
				"candidate": _build_candidate(standard),
			})


## Everything about an imported material that this treatment could conceivably
## change. Compared before and after so "the source is untouched" is measured.
static func fingerprint(material: StandardMaterial3D) -> Dictionary:
	var texture_path: String = ""
	if material.albedo_texture != null:
		texture_path = material.albedo_texture.resource_path
	return {
		"resource_path": material.resource_path,
		"name": material.resource_name,
		"albedo": material.albedo_color,
		"metallic": material.metallic,
		"roughness": material.roughness,
		"specular_mode": int(material.specular_mode),
		"shading_mode": int(material.shading_mode),
		"cull_mode": int(material.cull_mode),
		"transparency": int(material.transparency),
		"texture": texture_path,
		"emission_enabled": material.emission_enabled,
		"emission": material.emission,
		"uv1_scale": material.uv1_scale,
	}


func _build_candidate(source: StandardMaterial3D) -> Material:
	if source.albedo_texture != null:
		var shaded: ShaderMaterial = ShaderMaterial.new()
		shaded.shader = _shader
		shaded.set_shader_parameter("source_albedo", source.albedo_texture)
		shaded.set_shader_parameter("saturation", SATURATION)
		shaded.set_shader_parameter("value_scale", VALUE)
		shaded.set_shader_parameter("tint", Vector3(TINT.r, TINT.g, TINT.b))
		shaded.set_shader_parameter("roughness_value", 1.0)
		return shaded
	# Untextured: the same arithmetic on the flat albedo colour, on a DUPLICATE
	# so the imported material is never the object being written to.
	var flat: StandardMaterial3D = source.duplicate() as StandardMaterial3D
	flat.albedo_color = treated_colour(source.albedo_color)
	flat.roughness = 1.0
	flat.metallic = 0.0
	flat.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	return flat


## The same three numbers the shader applies, in GDScript, so a textured and an
## untextured candidate really are treated by one rule.
static func treated_colour(source: Color) -> Color:
	var luminance: float = source.r * 0.2126 + source.g * 0.7152 + source.b * 0.0722
	return Color(
		lerpf(luminance, source.r, SATURATION) * VALUE * TINT.r,
		lerpf(luminance, source.g, SATURATION) * VALUE * TINT.g,
		lerpf(luminance, source.b, SATURATION) * VALUE * TINT.b,
		source.a
	)


func set_candidate(active: bool) -> void:
	_candidate_active = active
	for entry: Dictionary in _surfaces:
		var mesh_instance: MeshInstance3D = entry["mesh"]
		if not is_instance_valid(mesh_instance):
			continue
		mesh_instance.set_surface_override_material(
			int(entry["surface"]), entry["candidate"] if active else null
		)


func candidate_active() -> bool:
	return _candidate_active


func surface_count() -> int:
	return _surfaces.size()


func registered_labels() -> PackedStringArray:
	var labels: PackedStringArray = PackedStringArray()
	for entry: Dictionary in _surfaces:
		if not labels.has(String(entry["label"])):
			labels.append(String(entry["label"]))
	return labels


## Re-reads every source material and compares it with the fingerprint taken
## before the first treatment. Returns the surfaces that changed — empty is the
## only acceptable answer.
func drifted_sources() -> PackedStringArray:
	var drifted: PackedStringArray = PackedStringArray()
	for entry: Dictionary in _surfaces:
		var source: StandardMaterial3D = entry["source"]
		if not is_instance_valid(source):
			drifted.append("%s: source material was freed" % entry["label"])
			continue
		var now: Dictionary = fingerprint(source)
		var before: Dictionary = entry["fingerprint"]
		for field: String in before:
			if now[field] != before[field]:
				drifted.append("%s: %s changed %s -> %s" % [
					entry["label"], field, str(before[field]), str(now[field]),
				])
	return drifted


## Surfaces still carrying an override. In source mode this must be empty, which
## is the other half of "switching back reproduces the imported presentation":
## an untouched source material is not enough if an override is still hiding it.
func overridden_surfaces() -> PackedStringArray:
	var held: PackedStringArray = PackedStringArray()
	for entry: Dictionary in _surfaces:
		var mesh_instance: MeshInstance3D = entry["mesh"]
		if not is_instance_valid(mesh_instance):
			continue
		if mesh_instance.get_surface_override_material(int(entry["surface"])) != null:
			held.append("%s surface %d" % [entry["label"], int(entry["surface"])])
	return held


func _meshes_under(node: Node) -> Array[MeshInstance3D]:
	var found: Array[MeshInstance3D] = []
	var mesh_instance: MeshInstance3D = node as MeshInstance3D
	if mesh_instance != null and mesh_instance.mesh != null:
		found.append(mesh_instance)
	for child: Node in node.get_children():
		found.append_array(_meshes_under(child))
	return found
