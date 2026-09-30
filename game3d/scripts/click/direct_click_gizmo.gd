class_name DirectClickGizmo
extends Node3D

## THE D-404 WORLD MARKERS — the clicked point, the straight segment and the
## first blocking contact, drawn flat on the ground.
##
## Review tooling, NOT presentation and NOT a UI foundation. It is a plain
## Node3D holding one MeshInstance3D: NOT a CollisionObject3D, NOT a navigation
## node, NOT registered as a combat entity, and it owns no number -- every point
## is read from the live order when it redraws.
##
## FLAT RIBBONS, NOT ONE-PIXEL LINES: a line primitive is one pixel wide at any
## zoom and all but vanishes at gameplay framing. The markers are told apart by
## SHAPE as well as colour: the destination is a RING with a CROSS, the segment a
## DASHED ribbon, the contact an X with a short tick along the wall normal.

const COL_DESTINATION := Color(0.40, 0.86, 1.0)
const COL_SEGMENT := Color(0.92, 0.94, 1.0)
const COL_CONTACT := Color(1.0, 0.42, 0.28)
## STRUCTURAL presentation sizes, in metres. Not gameplay values.
const RIBBON_W := 0.07
const LIFT_Y := 0.04
const RING_R := 0.32
const RING_SEGMENTS := 24
const DASH_M := 0.35

var player: PlayerController = null
var mesh_instance: MeshInstance3D
var _mesh: ImmediateMesh
var redraws: int = 0
## What the last redraw drew, so a check can read it without reading pixels.
var last_drawn: Dictionary = {}

func build() -> void:
	_mesh = ImmediateMesh.new()
	mesh_instance = MeshInstance3D.new()
	# NAMED "Guide", NOT "Markers": the accepted D-402 check E44 walks the live
	# tree for any node naming Prey, Mark or Ignite (Huntress's Mark must not
	# exist), and the first name of this mesh tripped it -- found by that check
	# on the first regression run (D-404). A review guide is not a Mark.
	mesh_instance.name = "DirectClickGuideMesh"
	mesh_instance.mesh = _mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.vertex_color_use_as_albedo = true
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.no_depth_test = true
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.render_priority = 2
	mesh_instance.material_override = mat
	add_child(mesh_instance)

func redraw() -> void:
	if _mesh == null or player == null:
		return
	redraws += 1
	_mesh.clear_surfaces()
	var o := player.click_order
	last_drawn = {"destination": false, "segment": false, "contact": false}
	if o.orders_issued == 0:
		return
	_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	# THE STRAIGHT INTENDED SEGMENT, dashed, from where the order began.
	var a := o.origin
	var b := o.destination
	var length := NavService.planar_distance(a, b)
	if length > 0.01:
		var dir := (b - a)
		dir.y = 0.0
		dir = dir.normalized()
		var t := 0.0
		while t < length:
			var t1 := minf(t + DASH_M, length)
			_ribbon(a + dir * t, a + dir * t1, COL_SEGMENT, 0.75)
			t += DASH_M * 2.0
		last_drawn["segment"] = true
	# THE CLICKED DESTINATION: a ring with a cross.
	for i in RING_SEGMENTS:
		var a0 := TAU * float(i) / float(RING_SEGMENTS)
		var a1 := TAU * float(i + 1) / float(RING_SEGMENTS)
		_ribbon(b + Vector3(cos(a0), 0, sin(a0)) * RING_R, b + Vector3(cos(a1), 0, sin(a1)) * RING_R,
			COL_DESTINATION, 0.95)
	_ribbon(b + Vector3(-RING_R * 0.6, 0, 0), b + Vector3(RING_R * 0.6, 0, 0), COL_DESTINATION, 0.95)
	_ribbon(b + Vector3(0, 0, -RING_R * 0.6), b + Vector3(0, 0, RING_R * 0.6), COL_DESTINATION, 0.95)
	last_drawn["destination"] = true
	# THE FIRST BLOCKING CONTACT: an X, and a tick along the wall normal.
	if o.has_contact:
		var c := Vector3(o.contact_point.x, 0.0, o.contact_point.z)
		var k := 0.26
		_ribbon(c + Vector3(-k, 0, -k), c + Vector3(k, 0, k), COL_CONTACT, 1.0)
		_ribbon(c + Vector3(-k, 0, k), c + Vector3(k, 0, -k), COL_CONTACT, 1.0)
		_ribbon(c, c + o.contact_normal * 0.55, COL_CONTACT, 1.0)
		last_drawn["contact"] = true
	_mesh.surface_end()

## One flat ribbon quad from p to q, lifted just off the floor.
func _ribbon(p: Vector3, q: Vector3, col: Color, alpha: float) -> void:
	var d := q - p
	d.y = 0.0
	if d.length() < 0.0001:
		return
	var side := Vector3(-d.z, 0.0, d.x).normalized() * (RIBBON_W * 0.5)
	var lift := Vector3(0.0, LIFT_Y, 0.0)
	var c := Color(col.r, col.g, col.b, alpha)
	var v0 := p - side + lift
	var v1 := p + side + lift
	var v2 := q + side + lift
	var v3 := q - side + lift
	for v in [v0, v1, v2, v0, v2, v3]:
		_mesh.surface_set_color(c)
		_mesh.surface_add_vertex(v)
