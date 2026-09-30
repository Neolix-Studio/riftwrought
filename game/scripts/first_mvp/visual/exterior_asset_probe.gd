class_name ExteriorAssetProbe
extends RefCounted
## First-MVP Gate 1B — the measurement specification §7 asks for, taken from the
## nodes the spike actually placed.
##
## Every number this returns is read off a real instance in the scene rather than
## off the archive, a promotional render, or a hand-typed expectation. That is
## the whole reason the spike exists in Godot: "Promotional renders are not
## sufficient evidence" (§1).
##
## The AABB is computed in the PLACED NODE'S OWN LOCAL SPACE, so it is the
## asset's size at root scale 1.0 no matter where the layout put it — and the
## spike separately asserts that it never scaled a candidate, so the two
## statements cannot drift apart.
##
## Nothing here judges an asset. §7's last row — "plausible as foreground,
## background-only, or reject" — is deliberately NOT computed: specification §9
## reserves that classification for the project owner.

## A silhouette is called readable when the piece is at least this tall on screen
## at the accepted camera, expressed as a fraction of the frame height. It is a
## MEASURED REPORTING THRESHOLD for the report's table, not an approval rule: the
## number below is roughly the height a 1.80 m character occupies at 19 m, so the
## column answers "is this at least as legible as the player".
const READABLE_SCREEN_FRACTION: float = 0.055


## Measures one placed candidate. `node` is the instantiated model root as it
## sits in the scene.
static func measure(node: Node3D) -> Dictionary:
	var meshes: Array[MeshInstance3D] = []
	_gather(node, meshes)

	var box: AABB = AABB()
	var first: bool = true
	var surfaces: int = 0
	var vertices: int = 0
	var material_names: PackedStringArray = PackedStringArray()
	var textures: PackedStringArray = PackedStringArray()
	var missing_normals: int = 0
	var double_sided: int = 0
	var transparent: int = 0
	var untextured_surfaces: int = 0
	var casts_shadow: bool = false
	## True until a surface proves otherwise. No candidate in the manifest is
	## meant to be unshaded or emissive; the per-surface test below is what
	## decides it rather than this initial value.
	var receives_light: bool = true

	for mesh_instance: MeshInstance3D in meshes:
		var local: Transform3D = _relative_transform(node, mesh_instance)
		var piece: AABB = local * mesh_instance.get_aabb()
		if first:
			box = piece
			first = false
		else:
			box = box.merge(piece)
		if mesh_instance.cast_shadow != GeometryInstance3D.SHADOW_CASTING_SETTING_OFF:
			casts_shadow = true
		for surface: int in mesh_instance.mesh.get_surface_count():
			surfaces += 1
			var arrays: Array = mesh_instance.mesh.surface_get_arrays(surface)
			var positions: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
			vertices += positions.size()
			var format: int = int(mesh_instance.mesh.surface_get_format(surface))
			if (format & Mesh.ARRAY_FORMAT_NORMAL) == 0:
				missing_normals += 1
			var material: Material = mesh_instance.get_active_material(surface)
			var standard: StandardMaterial3D = material as StandardMaterial3D
			if standard == null:
				untextured_surfaces += 1
				continue
			var label: String = standard.resource_name
			if label.is_empty():
				label = "(unnamed)"
			if not material_names.has(label):
				material_names.append(label)
			if standard.cull_mode == BaseMaterial3D.CULL_DISABLED:
				double_sided += 1
			if standard.transparency != BaseMaterial3D.TRANSPARENCY_DISABLED:
				transparent += 1
			if standard.shading_mode == BaseMaterial3D.SHADING_MODE_UNSHADED:
				receives_light = false
			if standard.albedo_texture == null:
				untextured_surfaces += 1
			else:
				var texture_path: String = standard.albedo_texture.resource_path
				if not texture_path.is_empty() and not textures.has(texture_path):
					textures.append(texture_path)

	return {
		"meshes": meshes.size(),
		"surfaces": surfaces,
		"vertices": vertices,
		"size": box.size,
		"base_offset": box.position.y,
		"centre": box.get_center(),
		"materials": material_names,
		"textures": textures,
		"untextured_surfaces": untextured_surfaces,
		"missing_normals": missing_normals,
		"double_sided": double_sided,
		"transparent": transparent,
		"casts_shadow": casts_shadow,
		"receives_light": receives_light,
		"scale": node.scale,
	}


## The fraction of the frame height a piece of this world height occupies at the
## accepted camera. Perspective, so it depends on the distance to the camera; the
## spike asks about the piece standing at the camera's focus, which is where the
## player is and therefore where the owner reads it.
static func screen_height_fraction(
	world_height: float, camera_distance: float, fov_degrees: float
) -> float:
	var frame_height: float = 2.0 * camera_distance * tan(deg_to_rad(fov_degrees) * 0.5)
	return world_height / maxf(frame_height, 0.0001)


## The height of the piece's real horizontal SURFACE — the y at which it carries
## the most upward-facing triangle AREA — in its own local space.
##
## MEASURED DEFECT, and the reason this function exists. Laying a flat surface
## piece by the top of its bounding box is wrong whenever the piece carries loose
## detail above its surface, and the Halloween `floor_dirt` module does: its AABB
## top is +0.030 m, which is the tops of about fifteen scattered pebbles, while
## the 4 x 4 m dirt plane itself is 0.100 m lower. Placing sixteen modules by
## their bounding box therefore buried every slab under the authored ground and
## left only the pebbles above it — the first rendered evidence run showed a
## court strewn with confetti and no dirt whatsoever.
##
## Vertex COUNT does not fix it either: floor_dirt has 120 vertices at +0.030 and
## only 80 on the plane that matters, because a pebble is all vertices and no
## area. Area does fix it: 16 m^2 of slab against a fraction of a square metre of
## pebble top.
static func dominant_surface_y(node: Node3D, bin_metres: float = 0.005) -> float:
	var meshes: Array[MeshInstance3D] = []
	_gather(node, meshes)
	var area_by_bin: Dictionary = {}
	var best_bin: int = 0
	var best_area: float = 0.0
	for mesh_instance: MeshInstance3D in meshes:
		var local: Transform3D = _relative_transform(node, mesh_instance)
		for surface: int in mesh_instance.mesh.get_surface_count():
			var arrays: Array = mesh_instance.mesh.surface_get_arrays(surface)
			var positions: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
			var normals: PackedVector3Array = arrays[Mesh.ARRAY_NORMAL]
			var indices: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
			var indexed: bool = indices.size() > 0
			var count: int = indices.size() if indexed else positions.size()
			var triangle: int = 0
			while triangle + 2 < count:
				var ia: int = indices[triangle] if indexed else triangle
				var ib: int = indices[triangle + 1] if indexed else triangle + 1
				var ic: int = indices[triangle + 2] if indexed else triangle + 2
				triangle += 3
				var a: Vector3 = local * positions[ia]
				var b: Vector3 = local * positions[ib]
				var c: Vector3 = local * positions[ic]
				# Which way the triangle FACES is read from the mesh's own normals
				# rather than from the winding of its indices. Godot's front faces
				# are clockwise, so a cross product of the edges points the wrong
				# way, and a first attempt at this function selected the underside
				# of the dirt slab — its largest horizontal face — instead of its
				# top.
				if normals.size() <= maxi(ia, maxi(ib, ic)):
					continue
				var facing: Vector3 = (
					local.basis * (normals[ia] + normals[ib] + normals[ic])
				).normalized()
				if facing.y < 0.7:
					continue
				var projected: float = (b - a).cross(c - a).length() * 0.5 * facing.y
				var height: float = (a.y + b.y + c.y) / 3.0
				var bin: int = int(round(height / bin_metres))
				var total: float = float(area_by_bin.get(bin, 0.0)) + projected
				area_by_bin[bin] = total
				if total > best_area:
					best_area = total
					best_bin = bin
	if best_area <= 0.0:
		var fallback: Dictionary = measure(node)
		return float(fallback["base_offset"]) + float(fallback["size"].y)
	return float(best_bin) * bin_metres


static func _gather(node: Node, into: Array[MeshInstance3D]) -> void:
	var mesh_instance: MeshInstance3D = node as MeshInstance3D
	if mesh_instance != null and mesh_instance.mesh != null:
		into.append(mesh_instance)
	for child: Node in node.get_children():
		_gather(child, into)


## Transform of `node` relative to `root`, accumulated through the chain. Read
## from `transform` rather than `global_transform` on purpose: the answer must be
## the asset's own geometry, independent of where the layout placed it, and it
## must be the same in a headless run as in a rendered one.
static func _relative_transform(root: Node3D, node: Node3D) -> Transform3D:
	var chain: Array[Node3D] = []
	var current: Node = node
	while current != null and current != root:
		var spatial: Node3D = current as Node3D
		if spatial != null:
			chain.append(spatial)
		current = current.get_parent()
	chain.reverse()
	var accumulated: Transform3D = Transform3D.IDENTITY
	for step: Node3D in chain:
		accumulated = accumulated * step.transform
	return accumulated
