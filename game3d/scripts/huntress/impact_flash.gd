class_name ImpactFlash
extends Node3D

## A PLACEHOLDER IMPACT, GENERATED IN CODE: an expanding ring and a brief flash.
##
## PORTED from the accepted D-388 spike (game3d_huntress_spike/scripts/spike/
## impact_effect.gd) under D-392 -- renamed so it is never mistaken for that file.
##
## Engine primitives only -- a TorusMesh and a SphereMesh with unshaded
## materials. NO imported effect, shader, texture or particle resource. NOT final
## VFX (SD-04 here; it was the spike's DF-04).

const LIFE_S := 0.32

var _t: float = 0.0
var _ring: MeshInstance3D
var _flash: MeshInstance3D
var _ring_mat: StandardMaterial3D
var _flash_mat: StandardMaterial3D

func play(dir: Vector3) -> void:
	_ring = MeshInstance3D.new()
	var tor := TorusMesh.new()
	tor.inner_radius = 0.16
	tor.outer_radius = 0.20
	tor.rings = 16
	tor.ring_segments = 6
	_ring.mesh = tor
	_ring_mat = _mat(Color(1.0, 0.88, 0.62, 0.9))
	_ring.material_override = _ring_mat
	add_child(_ring)
	# The ring faces back along the shot, so it reads as a hit, not a splash.
	var z := -Vector3(dir.x, 0.0, dir.z).normalized()
	var x := Vector3.UP.cross(z).normalized()
	_ring.basis = Basis(x, z, x.cross(z))
	_flash = MeshInstance3D.new()
	var sph := SphereMesh.new()
	sph.radius = 0.12
	sph.height = 0.24
	_flash.mesh = sph
	_flash_mat = _mat(Color(1.0, 0.95, 0.85, 0.85))
	_flash.material_override = _flash_mat
	add_child(_flash)

func _mat(c: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	m.albedo_color = c
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	return m

func _process(delta: float) -> void:
	_t += delta
	var k := clampf(_t / LIFE_S, 0.0, 1.0)
	if _ring != null:
		_ring.scale = Vector3.ONE * (1.0 + 2.2 * k)
		_ring_mat.albedo_color.a = 0.9 * (1.0 - k)
	if _flash != null:
		_flash.scale = Vector3.ONE * (1.0 + 0.6 * k)
		_flash_mat.albedo_color.a = 0.85 * (1.0 - k) * (1.0 - k)
	if _t >= LIFE_S:
		queue_free()
