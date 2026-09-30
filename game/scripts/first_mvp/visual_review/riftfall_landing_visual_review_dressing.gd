class_name RiftfallLandingVisualReviewDressing
extends Node3D
## Riftfall Landing — ISOLATED VISUAL REVIEW dressing pass, built on top of the
## project owner's accepted Greybox V2 layout (`RiftfallLandingGreyboxLayout`,
## instanced UNCHANGED alongside this node — see `riftfall_landing_visual_review.gd`).
##
## THIS NODE NEVER TOUCHES ROUTE, DIMENSIONS, CLEARANCES, COLLISION OR
## NAVIGATION. Every `CollisionShape3D` and every `NavigationObstacle3D` in the
## scene was already built by the unmodified V2 layout before this node runs;
## this pass only (a) recolours the material_override of the ground/boundary/
## architecture MeshInstance3D nodes V2 already built — a per-surface visual
## change with no effect on physics or navigation — and (b) adds new, purely
## decorative sibling nodes (registered KayKit/Kenney meshes, lights, a crack
## decal, drifting wisp planes, a self-contained repeating-stone anomaly) that
## carry NO CollisionShape3D and NO NavigationObstacle3D of their own. Assets
## decorate and articulate the authored geometry; they do not determine it.
##
## PALETTE DISCIPLINE. Every dressing key below resolves to a path recorded in
## one of the project's two accepted asset records — the D-208 Gate 1C
## allowlist (`RiftfallLandingLayout.payload()`) or the D-215 availability
## record (`approved_environment_palette.gd`) — read, never retyped. No path is
## written here. Exactly 12 distinct registered model keys are used; the count
## is asserted by `used_keys()` rather than promised.
##
## Rift Scar VFX (crack decal, drifting wisps) uses exactly two textures
## extracted from LeLu's Noise Pack (FREE) — see
## `game/assets/third_party/lelu/SOURCE_AND_LICENSE.md`. No living green plant
## is used anywhere in this file: the only tree keys are `tree_dead_large` and
## `tree_dead_small`.

const GATE_1C_LAYOUT_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/riftfall_landing_layout.gd"
const APPROVED_PALETTE_SCRIPT: String = "res://scripts/environment/approved_environment_palette.gd"
const STONE_SCRIPT: String = "res://scripts/first_mvp/visual_review/riftfall_landing_visual_review_stone.gd"

const CRACK_TEXTURE: String = "res://assets/third_party/lelu/noise_pack/T_Cracks336.png"
const WISP_TEXTURE: String = "res://assets/third_party/lelu/noise_pack/T_CloudNoise_Tiled.png"

## The four keys D-208 already registered for Gate 1C; read through
## `RiftfallLandingLayout.payload()`, never retyped.
const GATE_1C_KEYS: PackedStringArray = [
	"wall_pillar", "Rock_1_Q_Color1", "tree_dead_large", "lantern_standing",
]
## The eight further keys D-215 approved for availability; read through
## `approved_environment_palette.gd`'s `PAYLOADS`, never retyped.
const D215_KEYS: PackedStringArray = [
	"wall_broken", "wall_cracked", "wall_endcap", "pillar",
	"rubble_large", "Rock_3_R_Color1", "tree_dead_small", "banner_shield_red",
]

## Project-authored palette, PRE-treatment — the same family of raw values
## `RiftfallLandingLayout.COLOUR_*` uses, extended with cooler/darker "far"
## and "watch" tones. `ExteriorReviewTreatment.treated_colour()` (the exact
## static function the accepted saturation x0.42 / value x0.62 / cool-tint
## rule is built from) is applied to each of these explicitly in `_apply()`
## below, rather than left to the node's `material_override`-vs-surface-
## override precedence — see that function's own comment for why that
## distinction is load-bearing here.
const COLOUR_GROUND_NEAR: Color = Color(0.720, 0.700, 0.660)
const COLOUR_GROUND_FAR: Color = Color(0.560, 0.566, 0.610)
const COLOUR_BANK_LOW_NEAR: Color = Color(0.700, 0.676, 0.630)
const COLOUR_BANK_LOW_FAR: Color = Color(0.540, 0.546, 0.580)
const COLOUR_BANK_TALL_NEAR: Color = Color(0.620, 0.605, 0.585)
const COLOUR_BANK_TALL_FAR: Color = Color(0.460, 0.468, 0.500)
const COLOUR_RUIN_FRAGMENT: Color = Color(0.640, 0.620, 0.590)
const COLOUR_WATCH: Color = Color(0.520, 0.528, 0.552)
const COLOUR_RIFT: Color = Color(0.482, 0.286, 0.702)

## The route runs from the Rift Scar (large local Z) to the Watch Breach
## (large negative local Z); every gradient below reads world local Z through
## this pair, matching V2's own `CENTRELINE` endpoints.
const ROUTE_NEAR_Z: float = 26.5
const ROUTE_FAR_Z: float = -27.0

const WISP_ALPHA: float = 0.16
const WISP_PAN_SPEED: float = 0.015
const RIFT_LIGHT_ENERGY: float = 3.4
const RIFT_LIGHT_RANGE: float = 9.0
const PULSE_SPEED: float = 0.8

var _treatment: ExteriorReviewTreatment
var _instance_count: int = 0
var _used_keys: Dictionary = {}
var _wisp_materials: Array[StandardMaterial3D] = []
var _crack_material: ShaderMaterial
var stone: RiftfallLandingVisualReviewStone


func build(layout: RiftfallLandingGreyboxLayout, treatment: ExteriorReviewTreatment,
		lighting: ExteriorReviewLighting) -> void:
	for child: Node in get_children():
		child.free()
	_instance_count = 0
	_used_keys.clear()
	_wisp_materials.clear()
	_treatment = treatment

	_reskin_authored_geometry(layout)
	_hide_diagnostics(layout)
	_build_rift_scar_vfx(layout, lighting)
	_build_repeating_stone(layout)
	_build_dressing_instances(lighting)


func _process(delta: float) -> void:
	if _wisp_materials.is_empty():
		return
	var shift: Vector3 = Vector3(WISP_PAN_SPEED * delta, 0.0, 0.0)
	for material: StandardMaterial3D in _wisp_materials:
		material.uv1_offset += shift


# --- Reskin: same authored boxes, new materials, zero geometry change --------

func _reskin_authored_geometry(layout: RiftfallLandingGreyboxLayout) -> void:
	var visuals: Node3D = layout.get_node("Visuals")
	for child: Node in visuals.get_children():
		var mesh_instance: MeshInstance3D = child as MeshInstance3D
		if mesh_instance == null:
			continue
		var name: String = mesh_instance.name
		if name.begins_with("Ground_"):
			_apply(mesh_instance, _route_colour(mesh_instance.position.z, COLOUR_GROUND_NEAR, COLOUR_GROUND_FAR), 0.94)
		elif name.begins_with("Boundary_"):
			var box: BoxMesh = mesh_instance.mesh as BoxMesh
			var tall: bool = box != null and box.size.y > 2.8
			var near_c: Color = COLOUR_BANK_TALL_NEAR if tall else COLOUR_BANK_LOW_NEAR
			var far_c: Color = COLOUR_BANK_TALL_FAR if tall else COLOUR_BANK_LOW_FAR
			_apply(mesh_instance, _route_colour(mesh_instance.position.z, near_c, far_c), 0.97)
		elif name.begins_with("Architecture_"):
			var box2: BoxMesh = mesh_instance.mesh as BoxMesh
			var is_gatehouse: bool = box2 != null and box2.size.y > 3.0
			_apply(mesh_instance, COLOUR_WATCH if is_gatehouse else COLOUR_RUIN_FRAGMENT, 0.95)
		_treatment.register(mesh_instance, "authored geometry (visual review)")


## `RiftfallLandingGreyboxLayout` already gave every one of these nodes its
## own diagnostic `material_override` — a NODE-level property, which always
## wins over a `surface_material_override` regardless of what
## `ExteriorReviewTreatment.set_candidate()` sets. So the accepted saturation/
## value/tint rule is applied HERE, explicitly, with the treatment's own
## static formula, rather than left to the dynamic per-surface mechanism that
## works for the registered dressing meshes below (which carry no
## `material_override` of their own, so it applies to them normally). Both
## paths produce numerically identical output; this one just has to survive
## a property Greybox V2 already set.
func _apply(mesh_instance: MeshInstance3D, colour: Color, roughness: float) -> void:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = ExteriorReviewTreatment.treated_colour(colour)
	material.roughness = roughness
	material.metallic = 0.0
	material.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	mesh_instance.material_override = material


func _route_colour(z: float, near_colour: Color, far_colour: Color) -> Color:
	var t: float = clampf(inverse_lerp(ROUTE_NEAR_Z, ROUTE_FAR_Z, z), 0.0, 1.0)
	return near_colour.lerp(far_colour, t)


## The flat diagnostic language (green/red socket rings and poles, the warm
## centreline guide) is exactly what V2 needs and exactly what a cohesive
## dark-fantasy screenshot must not show. F6 still restores them alongside the
## review grid for anyone checking alignment against the accepted layout.
func _hide_diagnostics(layout: RiftfallLandingGreyboxLayout) -> void:
	var markers: Node3D = layout.get_node("Markers")
	markers.visible = false
	var visuals: Node3D = layout.get_node("Visuals")
	var centreline: Node = visuals.get_node_or_null("CentrelineGuide")
	if centreline != null:
		centreline.visible = false
	var stone_reservation: Node = visuals.get_node_or_null("StoneReservation")
	if stone_reservation != null:
		# Superseded by the repeating-stone anomaly's own residue rings below,
		# so the plaza is not double-marked.
		stone_reservation.visible = false


# --- Rift Scar: crack decal, violet light, drifting wisps --------------------

func _build_rift_scar_vfx(layout: RiftfallLandingGreyboxLayout, lighting: ExteriorReviewLighting) -> void:
	var reservation: MeshInstance3D = layout.get_node("Visuals/RiftScarReservation") as MeshInstance3D
	var centre: Vector3 = reservation.position
	_crack_material = _build_crack_material()
	reservation.material_override = _crack_material
	reservation.visible = true

	var violet_light: OmniLight3D = OmniLight3D.new()
	violet_light.name = "RiftScarLight"
	violet_light.position = Vector3(centre.x, 1.6, centre.z)
	violet_light.light_color = COLOUR_RIFT
	violet_light.light_energy = RIFT_LIGHT_ENERGY
	violet_light.omni_range = RIFT_LIGHT_RANGE
	violet_light.omni_attenuation = 1.6
	violet_light.shadow_enabled = false
	add_child(violet_light)

	var wisp_points: Array[Vector3] = [
		Vector3(centre.x - 0.6, 1.9, centre.z + 0.4),
		Vector3(centre.x - 3.4, 2.3, centre.z - 3.0),
		Vector3(centre.x + 2.6, 1.7, centre.z - 1.6),
	]
	for i: int in wisp_points.size():
		_add_wisp(wisp_points[i], 2.6 + float(i) * 0.4, i)


func _build_crack_material() -> ShaderMaterial:
	var shader: Shader = Shader.new()
	shader.code = """
shader_type spatial;
render_mode unshaded, blend_mix, cull_disabled, depth_draw_always, depth_prepass_alpha;

// Riftwrought — Riftfall Landing visual review, Rift Scar crack decal.
// Samples one LeLu's Noise Pack crack mask (see
// game/assets/third_party/lelu/SOURCE_AND_LICENSE.md), tints it violet, and
// pulses its emission restrainedly. No texture is modified on disk.
uniform sampler2D crack_mask : source_color, filter_linear;
uniform vec3 tint : source_color = vec3(0.62, 0.40, 0.92);
uniform float pulse_speed = 0.8;

void fragment() {
	vec4 mask = texture(crack_mask, UV);
	float pulse = 1.05 + 0.28 * sin(TIME * pulse_speed);
	ALBEDO = tint * mask.r;
	ALPHA = clamp(mask.r * 0.95, 0.0, 1.0);
	EMISSION = tint * mask.r * pulse * 1.35;
}
"""
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("crack_mask", load(CRACK_TEXTURE))
	material.set_shader_parameter("tint", Vector3(COLOUR_RIFT.r, COLOUR_RIFT.g, COLOUR_RIFT.b))
	material.set_shader_parameter("pulse_speed", PULSE_SPEED)
	return material


func _add_wisp(at: Vector3, size: float, index: int) -> void:
	var quad: MeshInstance3D = MeshInstance3D.new()
	quad.name = "RiftWisp_%d" % index
	var mesh: QuadMesh = QuadMesh.new()
	mesh.size = Vector2(size, size)
	quad.mesh = mesh
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	material.albedo_texture = load(WISP_TEXTURE)
	material.albedo_color = Color(COLOUR_RIFT.r, COLOUR_RIFT.g, COLOUR_RIFT.b, WISP_ALPHA)
	material.uv1_offset = Vector3(float(index) * 0.31, float(index) * 0.17, 0.0)
	quad.material_override = material
	quad.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	quad.position = at
	add_child(quad)
	_wisp_materials.append(material)


# --- Broken Procession: the repeating-stone anomaly --------------------------

func _build_repeating_stone(layout: RiftfallLandingGreyboxLayout) -> void:
	var reservation: MeshInstance3D = layout.get_node("Visuals/StoneReservation") as MeshInstance3D
	var centre: Vector3 = reservation.position
	var script: GDScript = load(STONE_SCRIPT) as GDScript
	stone = script.new()
	stone.name = "RepeatingStoneAnomaly"
	add_child(stone)
	stone.configure(
		Vector3(centre.x + 1.3, 0.02, centre.z),
		Vector3(centre.x - 1.3, 0.02, centre.z)
	)
	stone.build(_treatment)


# --- Registered dressing instances -------------------------------------------

## `{key, at: Vector2, yaw: float}`. `at` is local XZ, in the SAME frame as
## `RiftfallLandingGreyboxLayout`'s own `Rect2` constants (this node is a
## sibling of `Layout` under the same rotated `Composition` node, so no extra
## transform is needed). Sparse and edge-clustered by construction: 34
## instances of 12 registered types dress five beats plus a handful of the
## route's fourteen boundary masses — never one per mass, and never placed
## merely to fill ground the footprint measurement already counts as clear.
const PLACEMENTS: Array[Dictionary] = [
	# --- Beat 1: Rift Scar — displaced masonry, at most a few dead forms -----
	{"key": "rubble_large", "at": Vector2(-17.0, 22.5), "yaw": 25.0},
	{"key": "Rock_1_Q_Color1", "at": Vector2(-12.5, 15.6), "yaw": 40.0},
	{"key": "tree_dead_small", "at": Vector2(-17.6, 16.4), "yaw": 10.0},
	{"key": "tree_dead_small", "at": Vector2(6.4, 9.6), "yaw": -20.0},

	# --- Beat 2: First Bearing — the bend read through the boundary mass -----
	{"key": "wall_cracked", "at": Vector2(3.5, 6.6), "yaw": 0.0},
	{"key": "wall_cracked", "at": Vector2(9.0, 6.6), "yaw": 0.0},
	{"key": "wall_pillar", "at": Vector2(0.6, 3.5), "yaw": 90.0},
	{"key": "pillar", "at": Vector2(13.2, 2.0), "yaw": 0.0},
	{"key": "lantern_standing", "at": Vector2(-0.6, 8.4), "yaw": 0.0},

	# --- Beat 3: Broken Procession — a stopping place, not a road segment ----
	{"key": "rubble_large", "at": Vector2(-15.0, -3.5), "yaw": 15.0},
	{"key": "wall_broken", "at": Vector2(-12.0, -8.0), "yaw": 90.0},
	{"key": "wall_cracked", "at": Vector2(8.0, -5.3), "yaw": 90.0},
	{"key": "banner_shield_red", "at": Vector2(-10.2, -9.4), "yaw": -35.0},
	{"key": "tree_dead_large", "at": Vector2(-16.6, -7.2), "yaw": 15.0},

	# --- Beat 4: Watch Forecourt — the single broadest, darkest room ---------
	{"key": "wall_cracked", "at": Vector2(-20.0, -19.5), "yaw": 0.0},
	{"key": "wall_endcap", "at": Vector2(-17.5, -19.5), "yaw": 0.0},
	{"key": "wall_cracked", "at": Vector2(19.0, -18.0), "yaw": 90.0},
	{"key": "wall_endcap", "at": Vector2(19.0, -22.5), "yaw": 90.0},
	{"key": "pillar", "at": Vector2(-21.0, -15.0), "yaw": 0.0},
	{"key": "Rock_3_R_Color1", "at": Vector2(20.5, -19.5), "yaw": -30.0},
	{"key": "lantern_standing", "at": Vector2(-6.0, -19.5), "yaw": 0.0},

	# --- Beat 5: Watch Breach — offset gatehouses, warm-framed threshold -----
	{"key": "wall_pillar", "at": Vector2(-3.0, -23.5), "yaw": 0.0},
	{"key": "wall_broken", "at": Vector2(-4.0, -19.5), "yaw": 90.0},
	{"key": "wall_cracked", "at": Vector2(-1.5, -25.0), "yaw": 0.0},
	{"key": "wall_endcap", "at": Vector2(-5.6, -21.0), "yaw": 90.0},
	{"key": "wall_pillar", "at": Vector2(10.5, -20.5), "yaw": 0.0},
	{"key": "wall_broken", "at": Vector2(9.2, -17.5), "yaw": 90.0},
	{"key": "wall_cracked", "at": Vector2(11.5, -22.5), "yaw": 0.0},
	{"key": "wall_endcap", "at": Vector2(9.0, -22.0), "yaw": 90.0},
	{"key": "rubble_large", "at": Vector2(3.5, -33.0), "yaw": -10.0},
	{"key": "lantern_standing", "at": Vector2(-0.8, -21.0), "yaw": 0.0},
	{"key": "lantern_standing", "at": Vector2(8.8, -21.0), "yaw": 0.0},

	# --- Scattered along the route's other boundary masses, sparingly -------
	{"key": "Rock_1_Q_Color1", "at": Vector2(-16.5, 6.5), "yaw": 60.0},
	{"key": "tree_dead_large", "at": Vector2(9.2, 18.0), "yaw": -10.0},
]


func _build_dressing_instances(lighting: ExteriorReviewLighting) -> void:
	var lanterns_placed: int = 0
	for entry: Dictionary in PLACEMENTS:
		var key: String = String(entry["key"])
		var at: Vector2 = entry["at"]
		var yaw: float = float(entry["yaw"])
		_place(key, at, yaw)
		if key == "lantern_standing":
			# A warm light pool beside each lantern model, exactly the shared
			# component's own restrained warm treatment (§6.2), never a second
			# lighting implementation.
			lighting.add_lantern(Vector3(at.x, 1.4, at.y))
			lanterns_placed += 1


func _payload_for(key: String) -> Dictionary:
	if GATE_1C_KEYS.has(key):
		return RiftfallLandingLayout.payload(key)
	var palette: GDScript = load(APPROVED_PALETTE_SCRIPT) as GDScript
	for record: Dictionary in palette.PAYLOADS:
		if String(record["key"]) == key:
			return record
	return {}


func _place(key: String, at: Vector2, yaw_degrees: float) -> Node3D:
	var record: Dictionary = _payload_for(key)
	assert(not record.is_empty(), "Riftfall Landing visual review: unknown dressing key %s" % key)
	var contact: String = String(record["contact"])
	if contact == "plant":
		return _plant(key, record, at, yaw_degrees)
	return _place_base(key, record, at, yaw_degrees)


func _instantiate(key: String, record: Dictionary) -> Node3D:
	var scene: PackedScene = load(String(record["path"])) as PackedScene
	assert(scene != null, "Riftfall Landing visual review: %s failed to load" % record["path"])
	var node: Node3D = scene.instantiate() as Node3D
	node.name = "%s_%d" % [key.replace("-", "_"), _instance_count]
	_instance_count += 1
	add_child(node)
	if _treatment != null:
		_treatment.register(node, key)
	_used_keys[key] = int(_used_keys.get(key, 0)) + 1
	return node


func _plant(key: String, record: Dictionary, at: Vector2, yaw_degrees: float) -> Node3D:
	var node: Node3D = _instantiate(key, record)
	node.position = Vector3(at.x, 0.0, at.y)
	node.rotation = Vector3(0.0, deg_to_rad(yaw_degrees), 0.0)
	return node


func _place_base(key: String, record: Dictionary, at: Vector2, yaw_degrees: float) -> Node3D:
	var node: Node3D = _instantiate(key, record)
	var yaw: float = deg_to_rad(yaw_degrees)
	node.rotation = Vector3(0.0, yaw, 0.0)
	var probe_node: Node3D = (load(String(record["path"])) as PackedScene).instantiate() as Node3D
	var measured: Dictionary = ExteriorAssetProbe.measure(probe_node)
	probe_node.free()
	var local_box: AABB = AABB(
		Vector3(measured["centre"].x - measured["size"].x * 0.5, measured["base_offset"],
			measured["centre"].z - measured["size"].z * 0.5),
		measured["size"]
	)
	var rotated: AABB = Transform3D(Basis.from_euler(Vector3(0.0, yaw, 0.0)), Vector3.ZERO) * local_box
	node.position = Vector3(
		at.x - rotated.get_center().x, -rotated.position.y, at.y - rotated.get_center().z
	)
	return node


# --- Reporting ----------------------------------------------------------------

func used_keys() -> PackedStringArray:
	var keys: PackedStringArray = PackedStringArray()
	for key: String in _used_keys:
		keys.append(key)
	return keys


func distinct_type_count() -> int:
	return _used_keys.size()


func instance_count() -> int:
	return _instance_count
