class_name Telegraph
extends Node3D

## A ground-plane telegraph: the shape the attack WILL cover, shown BEFORE it
## does, filling as the windup runs.
##
## ============================================================================
## THE TELEGRAPH AND THE COMMITTED SHAPE ARE THE SAME ARITHMETIC.
## ============================================================================
## `contains()` is the ONE function that decides whether a point is inside the
## danger area, and it is used by BOTH the drawing and the damage query. If they
## were two implementations they could disagree, and a telegraph that disagrees
## with its attack is worse than no telegraph at all. The suite asserts the
## agreement IN BOTH DIRECTIONS -- a point inside is hit, a point outside is not.
##
## The arc is stated as a TOTAL width and applied as a HALF-width, which is this
## project's standing convention.
##
## Colour, thickness and fill rate are PROVISIONAL.

var progress: float = 0.0            ## 0 -> 1 across the windup
var radius: float = 2.0
var arc_total_deg: float = 90.0
var facing: Vector3 = Vector3.FORWARD

var _fill: MeshInstance3D
var _edge: MeshInstance3D
var _mat: StandardMaterial3D

const SEGMENTS := 28

func build(p_radius: float, p_arc_total_deg: float) -> void:
	radius = p_radius
	arc_total_deg = p_arc_total_deg
	_mat = StandardMaterial3D.new()
	_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	# PROVISIONAL, and DELIBERATELY BOLD. The first captures showed a thin wash
	# that the brick texture read straight through. D-369 accepted, as a carried
	# debt, that prototype attack readability is "adequate for the prototype
	# only" and that production versions must communicate "without requiring
	# unusually close attention" -- so this is made at least as legible as the
	# shape the owner has already seen and accepted. IT IS NOT A CLAIM THAT
	# READABILITY IS SOLVED; that debt is still owed.
	_mat.albedo_color = Color(ProdConfig.COL_TELEGRAPH.r, ProdConfig.COL_TELEGRAPH.g,
		ProdConfig.COL_TELEGRAPH.b, 0.55)
	_mat.emission_enabled = true
	_mat.emission = ProdConfig.COL_TELEGRAPH
	_mat.emission_energy_multiplier = 2.2

	_fill = MeshInstance3D.new()
	_fill.name = "TelegraphFill"
	_fill.material_override = _mat
	add_child(_fill)
	_edge = MeshInstance3D.new()
	_edge.name = "TelegraphEdge"
	var em := _mat.duplicate()
	em.albedo_color = Color(1.0, 0.42, 0.42, 0.95)
	em.emission_energy_multiplier = 4.0
	_edge.material_override = em
	add_child(_edge)
	set_progress(0.0)

## THE ONE SHAPE TEST. Planar, in the telegraph's own frame.
func contains(world_point: Vector3) -> bool:
	var d := world_point - global_position
	d.y = 0.0
	var dist := d.length()
	if dist > radius:
		return false
	if dist < 0.0001:
		return true                     # the origin is inside every arc
	var f := facing
	f.y = 0.0
	if f.length() < 0.0001:
		return false
	var ang := rad_to_deg(f.normalized().angle_to(d.normalized()))
	return ang <= arc_total_deg * 0.5    # TOTAL width, applied as a HALF-width

func set_progress(p: float) -> void:
	progress = clampf(p, 0.0, 1.0)
	_rebuild()

func face(dir: Vector3) -> void:
	facing = dir
	facing.y = 0.0
	if facing.length() > 0.0001:
		facing = facing.normalized()
	_rebuild()

func _rebuild() -> void:
	if _fill == null:
		return
	_fill.mesh = _arc_mesh(radius * progress)
	_edge.mesh = _arc_ring(radius, 0.22)

func _base_angle() -> float:
	return atan2(facing.x, facing.z)

func _arc_mesh(r: float) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var half := deg_to_rad(arc_total_deg * 0.5)
	var base := _base_angle()
	for i in range(SEGMENTS):
		var a0 := base - half + (2.0 * half) * (float(i) / float(SEGMENTS))
		var a1 := base - half + (2.0 * half) * (float(i + 1) / float(SEGMENTS))
		var y := ProdConfig.DECAL_TELEGRAPH_Y
		st.add_vertex(Vector3(0, y, 0))
		st.add_vertex(Vector3(sin(a0) * r, y, cos(a0) * r))
		st.add_vertex(Vector3(sin(a1) * r, y, cos(a1) * r))
	return st.commit()

func _arc_ring(r: float, thickness: float) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var half := deg_to_rad(arc_total_deg * 0.5)
	var base := _base_angle()
	var inner: float = maxf(0.0, r - thickness)
	for i in range(SEGMENTS):
		var a0 := base - half + (2.0 * half) * (float(i) / float(SEGMENTS))
		var a1 := base - half + (2.0 * half) * (float(i + 1) / float(SEGMENTS))
		var y := ProdConfig.DECAL_TELEGRAPH_RING_Y
		var o0 := Vector3(sin(a0) * r, y, cos(a0) * r)
		var o1 := Vector3(sin(a1) * r, y, cos(a1) * r)
		var i0 := Vector3(sin(a0) * inner, y, cos(a0) * inner)
		var i1 := Vector3(sin(a1) * inner, y, cos(a1) * inner)
		st.add_vertex(i0); st.add_vertex(o0); st.add_vertex(o1)
		st.add_vertex(i0); st.add_vertex(o1); st.add_vertex(i1)
	return st.commit()
