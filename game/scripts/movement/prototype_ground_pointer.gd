class_name PrototypeGroundPointer
extends RefCounted
## The ONE shared cursor-to-ground-to-navigation resolution, extracted from
## `scripts/prototype_zero/prototype_zero.gd` under D-195 and Gate 1A
## specification §3 so a second scene reuses it instead of cloning it.
##
## Both functions were MOVED, not rewritten. `PrototypeZeroRoom` keeps its own
## `ground_point_under_cursor()` and `resolve_to_navigation()` names and its own
## constants; their bodies now call these.

## Long enough to reach the floor from the camera at any calibration distance
## the rigs allow.
const RAY_LENGTH: float = 400.0
## Below this a resolved point counts as the point that was clicked. It is a
## geometry tolerance, not a gameplay value.
const ADJUST_EPSILON: float = 0.05


## Where the cursor meets the world. Falls back to the y = 0 ground plane when
## the ray misses every collider, so a click on empty floor beyond the room edge
## still produces a point that the navigation resolution can correct.
static func ground_point(
	camera: Camera3D, world: World3D, screen: Vector2, world_mask: int
) -> Dictionary:
	var from: Vector3 = camera.project_ray_origin(screen)
	var direction: Vector3 = camera.project_ray_normal(screen)

	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(
		from, from + direction * RAY_LENGTH, world_mask
	)
	var hit: Dictionary = world.direct_space_state.intersect_ray(query)
	if not hit.is_empty():
		return {"valid": true, "point": hit["position"], "hit_world": true}

	var plane_point: Variant = Plane(Vector3.UP, 0.0).intersects_ray(from, direction)
	if plane_point == null:
		return {"valid": false}
	return {"valid": true, "point": plane_point, "hit_world": false}


## Specification §9.3: "An unreachable point resolves to the nearest valid
## navigation point and never causes permanent running into a wall."
static func resolve_to_navigation(map: RID, requested: Vector3) -> Dictionary:
	var flattened: Vector3 = Vector3(requested.x, 0.0, requested.z)
	var closest: Vector3 = NavigationServer3D.map_get_closest_point(map, flattened)
	var offset: float = Vector2(closest.x - flattened.x, closest.z - flattened.z).length()
	return {"point": closest, "adjusted": offset > ADJUST_EPSILON, "offset": offset}
