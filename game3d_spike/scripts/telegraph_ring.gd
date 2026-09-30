class_name TelegraphRing
extends Node3D

## GROUND TELEGRAPH / DANGER MARKER — PROVISIONAL.
##
## Deliberately RED, so it is never confused with the violet Rift accent. The
## reference the owner supplied uses the same separation: violet is identity,
## red is danger. A telegraph that reads as flavour is a telegraph that failed.
##
## It is drawn UNSHADED so the moody environment lighting cannot swallow it,
## and it sits on the ground plane where an ARPG player actually looks.

var _fill: MeshInstance3D
var _rim: MeshInstance3D
var _radius: float = 2.0

static func make(radius: float) -> TelegraphRing:
	var t := TelegraphRing.new()
	t._radius = radius
	return t

func _ready() -> void:
	position.y = 0.03

	var fill_mat := StandardMaterial3D.new()
	fill_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	fill_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	fill_mat.albedo_color = Color(
		SpikeConfig.COL_TELEGRAPH.r, SpikeConfig.COL_TELEGRAPH.g,
		SpikeConfig.COL_TELEGRAPH.b, 0.13)
	fill_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	var disc := CylinderMesh.new()
	disc.top_radius = _radius
	disc.bottom_radius = _radius
	disc.height = 0.012
	disc.radial_segments = 48
	_fill = MeshInstance3D.new()
	_fill.mesh = disc
	_fill.material_override = fill_mat
	_fill.scale = Vector3(0.05, 1.0, 0.05)
	add_child(_fill)

	var rim_mat := StandardMaterial3D.new()
	rim_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	rim_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	rim_mat.albedo_color = Color(
		SpikeConfig.COL_TELEGRAPH.r, SpikeConfig.COL_TELEGRAPH.g,
		SpikeConfig.COL_TELEGRAPH.b, 0.92)
	var torus := TorusMesh.new()
	torus.inner_radius = _radius - 0.042
	torus.outer_radius = _radius
	torus.rings = 48
	_rim = MeshInstance3D.new()
	_rim.mesh = torus
	_rim.material_override = rim_mat
	_rim.rotation_degrees = Vector3(0, 0, 0)
	add_child(_rim)

func set_progress(p: float) -> void:
	if _fill != null:
		var s := lerpf(0.05, 1.0, clampf(p, 0.0, 1.0))
		_fill.scale = Vector3(s, 1.0, s)
