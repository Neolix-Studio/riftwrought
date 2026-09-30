class_name DestinationMarker
extends Node3D
## Prototype Zero — Gate B destination marker (specification §9.3).
##
## "A visible restrained destination marker confirms accepted ground intent."
##
## Restrained means: a thin ground ring, one short pulse when it is placed, and
## a quick fade on arrival. When the clicked point was NOT walkable and had to
## be resolved to the nearest navigable point, a second dim mark shows where the
## click actually landed, so an adjustment is visible rather than mysterious.
##
## Final art is not decided here. Shape and colour follow the Wroughtstone
## palette direction (muted copper on dark slate) without claiming to be it.

const RING_INNER: float = 0.06
const RING_RADIUS: float = 0.42
const PULSE_SECONDS: float = 0.22
const FADE_SECONDS: float = 0.18

var _ring: MeshInstance3D
var _ring_material: StandardMaterial3D
var _requested: MeshInstance3D
var _requested_material: StandardMaterial3D

var _pulse: float = 0.0
var _fading: bool = false
var _alpha: float = 0.0


func _ready() -> void:
	_ring = MeshInstance3D.new()
	_ring.name = "Ring"
	var torus: TorusMesh = TorusMesh.new()
	torus.inner_radius = RING_RADIUS - RING_INNER
	torus.outer_radius = RING_RADIUS
	torus.rings = 24
	_ring.mesh = torus
	_ring_material = _flat_material(Color(0.92, 0.62, 0.32))
	_ring.material_override = _ring_material
	_ring.position = Vector3(0.0, 0.03, 0.0)
	_ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(_ring)

	_requested = MeshInstance3D.new()
	_requested.name = "RequestedPoint"
	var pin: BoxMesh = BoxMesh.new()
	pin.size = Vector3(0.16, 0.02, 0.16)
	_requested.mesh = pin
	_requested_material = _flat_material(Color(0.55, 0.62, 0.72))
	# The most common adjusted click lands ON a wall, so the mark would otherwise
	# be hidden inside the very geometry that caused the adjustment.
	_requested_material.no_depth_test = true
	_requested.material_override = _requested_material
	_requested.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_requested.visible = false
	add_child(_requested)

	visible = false


func _flat_material(colour: Color) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = colour
	material.no_depth_test = false
	return material


func show_destination(resolved: Vector3, requested: Vector3, adjusted: bool) -> void:
	global_position = Vector3(resolved.x, 0.0, resolved.z)
	visible = true
	_fading = false
	_alpha = 1.0
	_pulse = PULSE_SECONDS
	_requested.visible = adjusted
	if adjusted:
		_requested.global_position = Vector3(requested.x, 0.04, requested.z)


func hide_destination() -> void:
	if not visible:
		return
	_fading = true


func _process(delta: float) -> void:
	if not visible:
		return
	if _pulse > 0.0:
		_pulse = maxf(_pulse - delta, 0.0)
		var t: float = 1.0 - _pulse / PULSE_SECONDS
		_ring.scale = Vector3.ONE * lerpf(1.35, 1.0, ease(t, 0.35))
	if _fading:
		_alpha = maxf(_alpha - delta / FADE_SECONDS, 0.0)
		if _alpha <= 0.0:
			visible = false
			_fading = false
			_requested.visible = false
	_ring_material.albedo_color.a = _alpha
	_requested_material.albedo_color.a = _alpha * 0.7
