class_name GateBDebugVisuals
extends Node3D
## Prototype Zero — Gate B navigation debug drawing (specification §22:
## "Debug toggles may additionally: show navigation paths").
##
## Draws the baked navigation mesh and the character's current path. It is
## development instrumentation, not player-facing presentation, and nothing in
## the player-facing loop depends on it.

var _navmesh_view: MeshInstance3D
var _path_view: MeshInstance3D


func _ready() -> void:
	_navmesh_view = MeshInstance3D.new()
	_navmesh_view.name = "NavigationMeshView"
	_navmesh_view.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(_navmesh_view)

	_path_view = MeshInstance3D.new()
	_path_view.name = "NavigationPathView"
	_path_view.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(_path_view)

	visible = false


## Rebuilds the translucent walkable-surface overlay. Called after every bake so
## a dead pocket in the mesh is visible rather than inferred.
func show_navigation_mesh(mesh: NavigationMesh) -> void:
	var immediate: ImmediateMesh = ImmediateMesh.new()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(0.30, 0.72, 0.92, 0.22)
	material.cull_mode = BaseMaterial3D.CULL_DISABLED

	var vertices: PackedVector3Array = mesh.get_vertices()
	immediate.surface_begin(Mesh.PRIMITIVE_TRIANGLES, material)
	for i: int in mesh.get_polygon_count():
		var indices: PackedInt32Array = mesh.get_polygon(i)
		for t: int in range(1, indices.size() - 1):
			immediate.surface_add_vertex(vertices[indices[0]] + Vector3.UP * 0.04)
			immediate.surface_add_vertex(vertices[indices[t]] + Vector3.UP * 0.04)
			immediate.surface_add_vertex(vertices[indices[t + 1]] + Vector3.UP * 0.04)
	immediate.surface_end()
	_navmesh_view.mesh = immediate


func show_path(path: PackedVector3Array) -> void:
	if path.size() < 2:
		_path_view.mesh = null
		return
	var immediate: ImmediateMesh = ImmediateMesh.new()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color(0.95, 0.72, 0.35)
	immediate.surface_begin(Mesh.PRIMITIVE_LINE_STRIP, material)
	for point: Vector3 in path:
		immediate.surface_add_vertex(point + Vector3.UP * 0.09)
	immediate.surface_end()
	_path_view.mesh = immediate
