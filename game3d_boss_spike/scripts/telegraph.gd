class_name Telegraph
extends Node3D

## A ground-plane danger area for the D-368 gate.
##
## ============================================================================
## THE OWNER'S CONSTRAINT, VERBATIM:
##   "The three attacks must not be distinguished merely by damage numbers or
##    differently sized circles. Their anticipation, timing, motion and danger
##    area must be visibly different."
## ============================================================================
##
## So this class supports THREE GENUINELY DIFFERENT GEOMETRIC CLASSES for the
## boss -- CONE, ANNULUS and LINE -- plus DISC, which is what the ORDINARY
## enemies use. That is deliberate: the plain circle is the ordinary enemy's
## vocabulary, so "the boss is not just bigger circles" is a contrast the gate
## can point at rather than a slogan. DISC is also what the verification suite
## plants, three times at three radii, to PROVE the distinctness check refuses
## exactly the thing the owner ruled out.
##
## ONE SOURCE OF TRUTH: the same shape parameters drive the drawn mesh AND
## `contains()`, which resolves the hit. The area that was SHOWN is therefore
## the area that RESOLVES -- that identity is what makes the consistency check
## meaningful rather than decorative. Two separate definitions, one for drawing
## and one for damage, is exactly the defect this avoids.
##
## Measurement is done in the telegraph's OWN LOCAL FRAME (CLAUDE.md 6), so a
## parent transform cannot silently rotate the result.
##
## LOCAL FORWARD IS +Z, WHICH IS MEASURED RATHER THAN ASSUMED. Godot's own
## convention is -Z, but these Quaternius characters are authored facing +Z:
## the toe vector `foot_l -> ball_l` was measured at (-0.099, 0, +0.995) on the
## Puglin, the Imp AND the Ranger outfit. That is why the accepted D-366 spike's
## `atan2(to.x, to.z)` is correct for these assets, and every shape here follows
## the same +Z convention so the drawn area faces the way the creature does.
## Getting this backwards draws a perfect danger area behind the boss -- a
## defect that exists only in a rendered frame, which is exactly the class
## CLAUDE.md 6 says to render evidence for.

const GROUND_Y := 0.03

var shape: GateConfig.Shape = GateConfig.Shape.CONE
var radius: float = 1.0          # CONE / DISC outer, ANNULUS outer
var inner: float = 0.0           # ANNULUS inner
var total_deg: float = 360.0     # CONE total sweep
var width: float = 1.0           # LINE width
var length: float = 1.0          # LINE length

var progress: float = 0.0        # 0 -> 1 anticipation fill
var committed: bool = false

var _mesh_inst: MeshInstance3D
var _mat: StandardMaterial3D
var _fill_inst: MeshInstance3D
var _fill_mat: StandardMaterial3D

static func make_cone(total_degrees: float, r: float) -> Telegraph:
	var t := Telegraph.new()
	t.shape = GateConfig.Shape.CONE
	t.total_deg = total_degrees
	t.radius = r
	t._build()
	return t

static func make_annulus(inner_r: float, outer_r: float) -> Telegraph:
	var t := Telegraph.new()
	t.shape = GateConfig.Shape.ANNULUS
	t.inner = inner_r
	t.radius = outer_r
	t._build()
	return t

static func make_line(w: float, l: float) -> Telegraph:
	var t := Telegraph.new()
	t.shape = GateConfig.Shape.LINE
	t.width = w
	t.length = l
	t._build()
	return t

## The ORDINARY enemy marker, and the suite's negative control. A guard nothing
## can reach is not a guard, so the suite plants three of these at three radii
## and requires the "three shape classes" check to refuse them.
static func make_disc(r: float) -> Telegraph:
	var t := Telegraph.new()
	t.shape = GateConfig.Shape.DISC
	t.radius = r
	t._build()
	return t

static func shape_name(s: GateConfig.Shape) -> String:
	match s:
		GateConfig.Shape.CONE: return "CONE"
		GateConfig.Shape.ANNULUS: return "ANNULUS"
		GateConfig.Shape.LINE: return "LINE"
		GateConfig.Shape.DISC: return "DISC"
	return "UNKNOWN"

func _build() -> void:
	name = "Telegraph_" + shape_name(shape)
	_mat = StandardMaterial3D.new()
	_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	_mat.albedo_color = Color(GateConfig.COL_TELEGRAPH, 0.26)
	_mat.emission_enabled = true
	_mat.emission = GateConfig.COL_TELEGRAPH
	_mat.emission_energy_multiplier = 1.4
	_mat.no_depth_test = false

	_mesh_inst = MeshInstance3D.new()
	_mesh_inst.name = "Outline"
	_mesh_inst.mesh = _make_mesh(1.0)
	_mesh_inst.material_override = _mat
	_mesh_inst.position.y = GROUND_Y
	add_child(_mesh_inst)

	# The anticipation fill: a brighter copy that grows with `progress`, so the
	# player can read HOW LONG IS LEFT, not merely THAT something is coming.
	_fill_mat = StandardMaterial3D.new()
	_fill_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_fill_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_fill_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	_fill_mat.albedo_color = Color(GateConfig.COL_TELEGRAPH, 0.52)
	_fill_mat.emission_enabled = true
	_fill_mat.emission = GateConfig.COL_TELEGRAPH
	_fill_mat.emission_energy_multiplier = 3.0

	_fill_inst = MeshInstance3D.new()
	_fill_inst.name = "Fill"
	_fill_inst.material_override = _fill_mat
	_fill_inst.position.y = GROUND_Y + 0.01
	add_child(_fill_inst)
	set_progress(0.0)

## `frac` scales the shape's own growth dimension, which differs PER SHAPE
## CLASS -- the cone fills by angle, the annulus by radial band, the line by
## length. Three shapes that filled identically would be three circles wearing
## different outlines.
func _make_mesh(frac: float) -> ArrayMesh:
	match shape:
		GateConfig.Shape.CONE:
			return _cone_mesh(total_deg * clampf(frac, 0.0, 1.0), radius)
		GateConfig.Shape.ANNULUS:
			var band: float = inner + (radius - inner) * clampf(frac, 0.0, 1.0)
			return _annulus_mesh(inner, maxf(inner + 0.001, band))
		GateConfig.Shape.LINE:
			return _line_mesh(width, length * clampf(frac, 0.0, 1.0))
		GateConfig.Shape.DISC:
			return _annulus_mesh(0.0, maxf(0.001, radius * clampf(frac, 0.0, 1.0)))
	return ArrayMesh.new()

## Plain array construction rather than SurfaceTool, so the geometry is explicit
## arithmetic (CLAUDE.md 6: prefer exact arithmetic to sampling).
func _cone_mesh(sweep_deg: float, r: float) -> ArrayMesh:
	var verts := PackedVector3Array()
	var segs := 36
	var half := deg_to_rad(sweep_deg) * 0.5
	# Local forward is +Z (measured), so the sector opens along the actor's
	# own facing.
	for i in segs:
		var a0: float = -half + (2.0 * half) * (float(i) / float(segs))
		var a1: float = -half + (2.0 * half) * (float(i + 1) / float(segs))
		verts.append(Vector3.ZERO)
		verts.append(Vector3(sin(a0) * r, 0.0, cos(a0) * r))
		verts.append(Vector3(sin(a1) * r, 0.0, cos(a1) * r))
	return _mesh_from(verts)

func _annulus_mesh(r_in: float, r_out: float) -> ArrayMesh:
	var verts := PackedVector3Array()
	var segs := 48
	for i in segs:
		var a0: float = TAU * (float(i) / float(segs))
		var a1: float = TAU * (float(i + 1) / float(segs))
		var i0 := Vector3(sin(a0) * r_in, 0.0, cos(a0) * r_in)
		var i1 := Vector3(sin(a1) * r_in, 0.0, cos(a1) * r_in)
		var o0 := Vector3(sin(a0) * r_out, 0.0, cos(a0) * r_out)
		var o1 := Vector3(sin(a1) * r_out, 0.0, cos(a1) * r_out)
		verts.append(i0); verts.append(o0); verts.append(o1)
		verts.append(i0); verts.append(o1); verts.append(i1)
	return _mesh_from(verts)

func _line_mesh(w: float, l: float) -> ArrayMesh:
	var verts := PackedVector3Array()
	var hw: float = w * 0.5
	var a := Vector3(-hw, 0.0, 0.0)
	var b := Vector3(hw, 0.0, 0.0)
	var c := Vector3(hw, 0.0, l)
	var d := Vector3(-hw, 0.0, l)
	verts.append(a); verts.append(b); verts.append(c)
	verts.append(a); verts.append(c); verts.append(d)
	return _mesh_from(verts)

func _mesh_from(verts: PackedVector3Array) -> ArrayMesh:
	var m := ArrayMesh.new()
	if verts.is_empty():
		return m
	var arr := []
	arr.resize(Mesh.ARRAY_MAX)
	arr[Mesh.ARRAY_VERTEX] = verts
	m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	return m

func set_progress(p: float) -> void:
	progress = clampf(p, 0.0, 1.0)
	if _fill_inst != null:
		_fill_inst.mesh = _make_mesh(progress)
	if _fill_mat != null:
		_fill_mat.emission_energy_multiplier = 2.0 + 4.0 * progress

## The commit flash: the shown area turns to the commit colour at the instant
## damage resolves, so the telegraph's end is legible rather than inferred.
func commit() -> void:
	committed = true
	set_progress(1.0)
	if _mat != null:
		_mat.albedo_color = Color(GateConfig.COL_TELEGRAPH_COMMIT, 0.52)
		_mat.emission = GateConfig.COL_TELEGRAPH_COMMIT
		_mat.emission_energy_multiplier = 5.0
	if _fill_mat != null:
		_fill_mat.albedo_color = Color(GateConfig.COL_TELEGRAPH_COMMIT, 0.72)
		_fill_mat.emission = GateConfig.COL_TELEGRAPH_COMMIT
		_fill_mat.emission_energy_multiplier = 7.0

# ------------------------------------------------------------ resolution ----

## Does a WORLD point fall inside the danger area?
##
## Converted into this node's OWN LOCAL FRAME first, then tested with exact
## arithmetic against the same parameters that built the mesh. The Y axis is
## deliberately ignored: visual height is presentation and is NEVER a gameplay
## coordinate (CLAUDE.md 5).
func contains(world_point: Vector3) -> bool:
	var p := to_local(world_point)
	p.y = 0.0
	match shape:
		GateConfig.Shape.CONE:
			var d := p.length()
			if d > radius or d < 0.0001:
				return d <= radius and d <= 0.0001
			# Local forward is +Z (measured). Angle away from forward.
			var ang := absf(rad_to_deg(atan2(p.x, p.z)))
			return ang <= total_deg * 0.5
		GateConfig.Shape.ANNULUS:
			var d2 := p.length()
			return d2 >= inner and d2 <= radius
		GateConfig.Shape.LINE:
			if p.z < 0.0 or p.z > length:
				return false
			return absf(p.x) <= width * 0.5
		GateConfig.Shape.DISC:
			return p.length() <= radius
	return false

## The area's own extent in metres, for the framing/readability measurement.
func extent_m() -> float:
	match shape:
		GateConfig.Shape.CONE: return radius
		GateConfig.Shape.ANNULUS: return radius
		GateConfig.Shape.LINE: return length
		GateConfig.Shape.DISC: return radius
	return 0.0

## Points on the area's own boundary, in WORLD space, for projecting the shown
## danger area to screen pixels. Derived from the shape parameters, so a shape
## change cannot leave the measurement describing the old geometry.
func boundary_points_world(count: int = 24) -> Array[Vector3]:
	var out: Array[Vector3] = []
	match shape:
		GateConfig.Shape.CONE:
			var half := deg_to_rad(total_deg) * 0.5
			for i in count:
				var a: float = -half + (2.0 * half) * (float(i) / float(maxi(1, count - 1)))
				out.append(to_global(Vector3(sin(a) * radius, 0.0, cos(a) * radius)))
			out.append(to_global(Vector3.ZERO))
		GateConfig.Shape.ANNULUS, GateConfig.Shape.DISC:
			for i in count:
				var a2: float = TAU * (float(i) / float(count))
				out.append(to_global(Vector3(sin(a2) * radius, 0.0, cos(a2) * radius)))
		GateConfig.Shape.LINE:
			var hw: float = width * 0.5
			for corner in [Vector3(-hw, 0, 0), Vector3(hw, 0, 0),
					Vector3(hw, 0, length), Vector3(-hw, 0, length)]:
				out.append(to_global(corner))
	return out
