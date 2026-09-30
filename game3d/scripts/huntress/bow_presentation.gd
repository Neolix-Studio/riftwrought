class_name BowPresentation
extends Node3D

## ============================================================================
## PORTED UNDER D-392 FROM THE ACCEPTED D-388 SPIKE -- TEMPORARY PLACEHOLDER.
## ============================================================================
## Source: game3d_huntress_spike/scripts/spike/bow_presentation.gd, accepted under D-389 as
## PROTOTYPE FEASIBILITY EVIDENCE ("viable for prototype only"). The owner's
## D-392 ruling: "The CC0 KayKit bow clips and the D-388 retarget/hand-contact
## approach may be ported only as explicitly temporary placeholder animation.
## Preserve provenance. Do not present them as final production animation or fix
## the five accepted polish debts." NOTHING here is final animation. The spike
## itself is NOT edited and NOT referenced at runtime: this is a copy, adapted as
## stated below, and every value it reads lives in HuntressConfig.
## ADAPTED: it reads HuntressConfig; ONE visual only -- the KayKit Ranger comparator is NOT
## ported. A PLACEHOLDER bow, string and arrow: NOT final art or attachment (SD-06).
## (The paragraphs below are the spike's own documentation, kept as provenance;
## where they say "the spike" they mean the source this was ported from.)

## THE BOW, ITS PROCEDURAL STRING AND THE NOCKED ARROW — for ONE visual.
##
## ============================================================================
## DIAGNOSTIC PRESENTATION. NOT FINAL ART, AND NOT THE FINAL ATTACHMENT (DF-07).
## ============================================================================
## The spike ATTEMPTS what D-386 listed as missing -- a bow in the right hand,
## an arrow that is visibly nocked and leaves on the release frame, and a string
## that follows the drawing hand -- so the owner can judge it rendered.
##
## ---------------------------------------------------------------------------
## THE BOW ORIENTATION CRITERION, DECLARED BEFORE BUILDING
## ---------------------------------------------------------------------------
## D-369 recorded that choosing a bow orientation by a sweep of world-vertical
## extent "is a poor proxy". So the criterion here is the geometry of a draw: at
## the visual's own FULL-DRAW pose, the bow's plane CONTAINS the arrow line, its
## long axis is world-up projected perpendicular to that line, and its string
## side faces the string hand. That solves ONE hand-local offset, which the hand
## then carries rigidly through every other pose.
##
## ---------------------------------------------------------------------------
## THE RIGID STRING IS LEFT OUT
## ---------------------------------------------------------------------------
## `Bow_Wooden`'s `White` surface IS a rigid string, tip to tip. The displayed
## bow is a runtime mesh built from the OTHER two surfaces; the source .obj is
## untouched. The string drawn here is two thin cylinders, tip -> centre -> tip.
##
## Every node here is top-level: its world transform is written each physics
## frame from the pose the driver just computed, so nothing lags a frame behind.

## Measured in the source .obj: the string's tips and its rest centre, in bow
## model units. The grip (LightWood) sits at the origin.
const TIP_LOCAL_TOP := Vector3(1.0155, 2.549, 0.0)
const TIP_LOCAL_BOTTOM := Vector3(1.0155, -2.549, 0.0)
const STRING_REST_LOCAL := Vector3(1.0155, 0.0, 0.0)
## The arrow sits beside the grip, not through it: a right-handed archer's arrow
## rests on the bow's left, which is the bow frame's +Z (see `solve`).
const ARROW_REST_SIDE_M := 0.028
const ARROW_MODEL_LENGTH := 2.7338

var label: String = ""
var bow_scale: float = 1.0
var arrow_scale: float = 1.0
## The bow's transform relative to the carrying bone, solved at full draw.
var bow_offset: Transform3D = Transform3D.IDENTITY

var bow_node: Node3D
var bow_mesh: MeshInstance3D
var arrow_node: Node3D
var arrow_mesh: MeshInstance3D
var string_top: MeshInstance3D
var string_bottom: MeshInstance3D

## Live state the suite reads.
var bow_world: Transform3D = Transform3D.IDENTITY
var tip_top_world: Vector3 = Vector3.ZERO
var tip_bottom_world: Vector3 = Vector3.ZERO
var string_centre_world: Vector3 = Vector3.ZERO
var string_rest_world: Vector3 = Vector3.ZERO
var arrow_world: Transform3D = Transform3D.IDENTITY
var arrow_visible: bool = false
var drawn: bool = false
var displayed_surfaces: int = 0
var source_surfaces: int = 0

func build(p_label: String, bow_len_m: float) -> void:
	label = p_label
	var src := load(AssetManifest.BOW_WOODEN) as ArrayMesh
	source_surfaces = src.get_surface_count()
	var m := ArrayMesh.new()
	for i in src.get_surface_count():
		var mat := src.surface_get_material(i)
		if mat != null and mat.resource_name == "White":
			continue
		m.add_surface_from_arrays(src.surface_get_primitive_type(i), src.surface_get_arrays(i))
		m.surface_set_material(m.get_surface_count() - 1, mat)
	displayed_surfaces = m.get_surface_count()
	# MEASURED from the mesh's own AABB, never copied from another project.
	var a := src.get_aabb()
	var measured := maxf(a.size.x, maxf(a.size.y, a.size.z))
	bow_scale = bow_len_m / measured if measured > 0.0 else 1.0

	bow_node = Node3D.new()
	bow_node.name = "Bow_%s" % label
	bow_node.top_level = true
	add_child(bow_node)
	bow_mesh = MeshInstance3D.new()
	bow_mesh.name = "BowMesh_Bow_Wooden_stringless"
	bow_mesh.mesh = m
	bow_mesh.scale = Vector3.ONE * bow_scale
	bow_node.add_child(bow_mesh)

	var smat := StandardMaterial3D.new()
	smat.albedo_color = Color(0.86, 0.84, 0.78)
	smat.roughness = 0.6
	string_top = _string_segment("StringTop", smat)
	string_bottom = _string_segment("StringBottom", smat)

	arrow_node = Node3D.new()
	arrow_node.name = "NockedArrow_%s" % label
	arrow_node.top_level = true
	add_child(arrow_node)
	arrow_mesh = MeshInstance3D.new()
	arrow_mesh.name = "ArrowMesh"
	arrow_mesh.mesh = load(AssetManifest.ARROW) as Mesh
	arrow_node.add_child(arrow_mesh)
	arrow_node.visible = false

func _string_segment(n: String, mat: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.name = n
	mi.top_level = true
	var cyl := CylinderMesh.new()
	cyl.top_radius = HuntressConfig.STRING_RADIUS_M
	cyl.bottom_radius = HuntressConfig.STRING_RADIUS_M
	cyl.height = 1.0
	cyl.radial_segments = 6
	cyl.rings = 1
	mi.mesh = cyl
	mi.material_override = mat
	add_child(mi)
	return mi

## Solves the hand-local bow offset from ONE full-draw pose, and the arrow scale
## from the same pose. `carry` is the carrying bone's WORLD transform, `grip` the
## grip point and `nock` the string-hand nock point, both WORLD.
func solve(carry: Transform3D, grip: Vector3, nock: Vector3) -> Dictionary:
	var u := (grip - nock).normalized()             # the arrow line, forward
	var up_perp := (Vector3.UP - u * Vector3.UP.dot(u)).normalized()
	var bx := -u                                    # model +X: the string side, toward the archer
	var by := up_perp                               # model +Y: the bow's long axis
	var bz := bx.cross(by).normalized()             # model +Z: the archer's left
	var bow_basis := Basis(bx, by, bz)
	var bow_xf := Transform3D(bow_basis, grip)
	bow_offset = carry.affine_inverse() * bow_xf
	var rest_pt := grip + bz * ARROW_REST_SIDE_M
	var draw_len := nock.distance_to(rest_pt)
	arrow_scale = (draw_len + HuntressConfig.ARROW_OVERHANG_M) / ARROW_MODEL_LENGTH
	arrow_mesh.scale = Vector3.ONE * arrow_scale
	return {"draw_length_m": draw_len, "arrow_length_m": draw_len + HuntressConfig.ARROW_OVERHANG_M,
		"bow_axis_vs_up_deg": rad_to_deg(by.angle_to(Vector3.UP)),
		"arrow_line": u}

## The solved attachment, copied onto a display-only presentation (the E-05
## comparison sheet) so the sheet shows exactly what the live probe shows.
func copy_solution_from(other: BowPresentation) -> void:
	bow_offset = other.bow_offset
	arrow_scale = other.arrow_scale
	arrow_mesh.scale = Vector3.ONE * arrow_scale

static func bow_model_length() -> float:
	var a := (load(AssetManifest.BOW_WOODEN) as Mesh).get_aabb()
	return maxf(a.size.x, maxf(a.size.y, a.size.z))

func bow_transform_for(carry: Transform3D) -> Transform3D:
	return carry * bow_offset

## Writes every world transform for this frame.
func update(carry: Transform3D, nock: Vector3, p_drawn: bool, p_arrow_visible: bool) -> void:
	bow_world = carry * bow_offset
	bow_node.global_transform = bow_world
	tip_top_world = bow_world * (TIP_LOCAL_TOP * bow_scale)
	tip_bottom_world = bow_world * (TIP_LOCAL_BOTTOM * bow_scale)
	string_rest_world = bow_world * (STRING_REST_LOCAL * bow_scale)
	drawn = p_drawn
	string_centre_world = nock if drawn else string_rest_world
	_place_segment(string_top, tip_top_world, string_centre_world)
	_place_segment(string_bottom, tip_bottom_world, string_centre_world)
	arrow_visible = p_arrow_visible
	arrow_node.visible = arrow_visible and visible
	if arrow_visible:
		var rest_pt := bow_world.origin + bow_world.basis.z.normalized() * ARROW_REST_SIDE_M
		var dz := (rest_pt - nock).normalized()
		var up_hint := bow_world.basis.y.normalized()
		var dx := up_hint.cross(dz).normalized()
		var dy := dz.cross(dx).normalized()
		arrow_world = Transform3D(Basis(dx, dy, dz), nock)
		arrow_node.global_transform = arrow_world

func _place_segment(mi: MeshInstance3D, a: Vector3, b: Vector3) -> void:
	var d := b - a
	var l := d.length()
	if l < 0.0001:
		mi.visible = false
		return
	mi.visible = visible
	var y := d / l
	var x := y.cross(Vector3.FORWARD)
	if x.length() < 0.01:
		x = y.cross(Vector3.RIGHT)
	x = x.normalized()
	var z := x.cross(y).normalized()
	mi.global_transform = Transform3D(Basis(x, y * l, z), (a + b) * 0.5)

## The nocked arrow's world transform and length, for the projectile that
## replaces it on the release frame.
func nocked_arrow() -> Dictionary:
	return {"xform": arrow_world, "scale": arrow_scale,
		"length": ARROW_MODEL_LENGTH * arrow_scale}

func set_shown(v: bool) -> void:
	visible = v
	bow_node.visible = v
	string_top.visible = v
	string_bottom.visible = v
	arrow_node.visible = v and arrow_visible
