class_name NavService
extends RefCounted

## THE NAVIGATION LAYER — one place that talks to NavigationServer3D.
##
## Both 3D spikes had NO navigation mesh at all: enemies moved straight at the
## player and `game3d_spike/` used ONE perimeter box for collision, which it said
## plainly was a spike-level simplification. A production foundation cannot carry
## that forward, so this file exists and is measured.
##
## ============================================================================
## "EVERY SOCKET IS ON THE NAVIGATION MESH" AND "YOU CAN WALK THERE" ARE
## DIFFERENT CLAIMS, AND ONLY THE SECOND MATTERS.
## ============================================================================
## `reachable()` therefore asks for a PATH and checks where that path actually
## ENDS. `map_get_path` always returns something -- it snaps an off-mesh target
## to the nearest point on the mesh -- so a function that merely checked "did I
## get a path back" would accept every point in the universe. Checking the END
## POINT against the REQUESTED point is what makes the test able to refuse, and
## the suite proves it refuses.

static func map_rid_for(node: Node3D) -> RID:
	return node.get_world_3d().navigation_map

## Force the navigation map to process. A freshly baked region is not queryable
## until the server has synchronised, and a query made before then silently
## returns nothing -- which reads exactly like "unreachable" and would make the
## reachability checks lie in the safe direction.
static func sync(map: RID) -> void:
	NavigationServer3D.map_force_update(map)

static func nearest_point(map: RID, p: Vector3) -> Vector3:
	return NavigationServer3D.map_get_closest_point(map, p)

static func path_between(map: RID, from: Vector3, to: Vector3) -> PackedVector3Array:
	return NavigationServer3D.map_get_path(map, from, to, true)

static func path_length(p: PackedVector3Array) -> float:
	var total := 0.0
	for i in range(1, p.size()):
		total += p[i].distance_to(p[i - 1])
	return total

## Planar distance. Height is presentation and is never a gameplay coordinate,
## so a vertical difference must not make two points "far apart".
static func planar_distance(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()

## Reachability BY PATH. Returns everything the caller could want to report, so
## a failing check can say WHY rather than just "false".
static func reachable(map: RID, from: Vector3, to: Vector3,
		tolerance: float) -> Dictionary:
	var p := path_between(map, from, to)
	if p.size() < 2:
		return {
			"reachable": false, "points": p.size(), "end_error": INF,
			"path_length": 0.0, "straight": planar_distance(from, to),
			"why": "no path returned",
		}
	var err := planar_distance(p[p.size() - 1], to)
	return {
		"reachable": err <= tolerance,
		"points": p.size(),
		"end_error": err,
		"path_length": path_length(p),
		"straight": planar_distance(from, to),
		"why": "path ends %.3f m from the requested point (tolerance %.3f m)" % [err, tolerance],
	}

## Total walkable area of every polygon in the baked mesh, and the vertical band
## those polygons occupy.
##
## THE BAND IS NOT DECORATION. `CLAUDE.md` section 5.2 records that 2D REMOVED the
## "open-topped box collider baking a walkable interior" defect, because a
## navigation polygon has no height. THREE DIMENSIONS BRING IT BACK: a column's
## flat top is a perfectly good walkable surface as far as the baker is
## concerned, and an island of navigation mesh three metres in the air is exactly
## the kind of defect that passes every count-based check.
static func measure_mesh(nm: NavigationMesh) -> Dictionary:
	if nm == null:
		return {"polygons": 0, "area": 0.0, "min_y": 0.0, "max_y": 0.0, "vertices": 0}
	var verts := nm.get_vertices()
	var area := 0.0
	var lo := INF
	var hi := -INF
	for i in range(nm.get_polygon_count()):
		var idx := nm.get_polygon(i)
		if idx.size() < 3:
			continue
		var a := verts[idx[0]]
		for k in range(1, idx.size() - 1):
			var b := verts[idx[k]]
			var c := verts[idx[k + 1]]
			area += 0.5 * ((b - a).cross(c - a)).length()
	for v in verts:
		lo = minf(lo, v.y)
		hi = maxf(hi, v.y)
	if verts.size() == 0:
		lo = 0.0
		hi = 0.0
	return {
		"polygons": nm.get_polygon_count(),
		"area": area,
		"min_y": lo,
		"max_y": hi,
		"vertices": verts.size(),
	}

## ============================================================================
## A PATH FOLLOWER THIS PROJECT OWNS, rather than one it hopes about.
## ============================================================================
## `NavigationAgent3D` advances along its path by 3D distance, and Recast lays
## the baked surface a little ABOVE the collision floor -- here, a measured
## 0.30 m, which is `cell_height * 1.5`. Ground-point actors stand at y = 0, so
## the vertical gap alone sat right at the agent's own advance threshold and the
## agents STALLED: measured, an enemy covered 4.67 m of a 12.44 m path in
## fifteen seconds instead of arriving in five.
##
## Nothing about that is visible in a polygon count or a path query. It showed up
## only because a check measured whether the actor ACTUALLY ARRIVED, which is the
## same rule that says "every socket is on the navigation mesh" and "you can walk
## there" are different claims.
##
## So the follower below advances on PLANAR distance, in this project's own code,
## where the rule is stated once and can be tested directly.
class PathFollower extends RefCounted:
	var points: PackedVector3Array = PackedVector3Array()
	var index: int = 0
	var advance_tolerance: float = 0.45
	var repaths: int = 0

	func set_path(p: PackedVector3Array) -> void:
		points = p
		index = 0
		repaths += 1

	func repath(map: RID, from: Vector3, to: Vector3) -> void:
		set_path(NavService.path_between(map, from, to))

	func point_count() -> int:
		return points.size()

	func finished() -> bool:
		return index >= points.size()

	## The planar steering direction from `pos`, advancing past points already
	## reached. Returns ZERO when the path is done.
	func steer(pos: Vector3) -> Vector3:
		while index < points.size() \
				and NavService.planar_distance(points[index], pos) <= advance_tolerance:
			index += 1
		if index >= points.size():
			return Vector3.ZERO
		var d := points[index] - pos
		d.y = 0.0
		if d.length() < 0.0001:
			return Vector3.ZERO
		return d.normalized()

	func remaining_length(pos: Vector3) -> float:
		if index >= points.size():
			return 0.0
		var total := NavService.planar_distance(pos, points[index])
		for i in range(index + 1, points.size()):
			total += NavService.planar_distance(points[i], points[i - 1])
		return total

## The usable width of a corridor, measured ACROSS it on the baked mesh.
##
## This is the project's named "agent-radius erosion silently deleting a
## corridor" defect class, given a live measurement. The corridor is sampled
## across its own axis and the extent of points that are genuinely ON the mesh is
## returned -- not the authored gap, which is what erosion eats.
static func corridor_width(map: RID, centre: Vector3, across: Vector3,
		search_half: float, samples: int) -> Dictionary:
	var ax := across.normalized()
	var on_mesh: Array[float] = []
	for i in range(samples + 1):
		var t := lerpf(-search_half, search_half, float(i) / float(samples))
		var probe := centre + ax * t
		var snap := nearest_point(map, probe)
		# On the mesh means the closest point IS essentially the probe point.
		if planar_distance(snap, probe) <= 0.05:
			on_mesh.append(t)
	if on_mesh.is_empty():
		return {"width": 0.0, "min_t": 0.0, "max_t": 0.0, "samples_on_mesh": 0}
	var lo: float = on_mesh[0]
	var hi: float = on_mesh[0]
	for t in on_mesh:
		lo = minf(lo, t)
		hi = maxf(hi, t)
	return {
		"width": hi - lo,
		"min_t": lo,
		"max_t": hi,
		"samples_on_mesh": on_mesh.size(),
	}
