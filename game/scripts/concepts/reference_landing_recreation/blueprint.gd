class_name ReferenceLandingBlueprint
extends RefCounted
## Reference Landing Recreation -- Session 1: blueprint and markers (NON-CANONICAL).
##
## Pure data and math for the recreation's centerline, width band and three named
## anchors. No meshes, no nodes, no dependency on the Zone Composer addon or on
## anything under first_mvp/. See
## docs/concepts/reference_landing_recreation/01_blueprint_and_markers.md.
##
## Authored directly on the world axes (this concept has no parent transform,
## unlike Riftfall Landing's rotated local frame): -Z is the direction of travel
## from the rift-patch spawn toward the gate, with a gentle rightward bend and a
## slight rise in the second half, echoing the reference image's single bend and
## its "climbs toward the gate" read.

## The three named anchors the task requires. Declared before CENTERLINE so the
## centerline can reference them directly instead of repeating coordinates.
const SPAWN: Vector3 = Vector3(0.0, 0.0, 0.0)
const MIDPOINT: Vector3 = Vector3(0.0, 0.0, -70.0)
const PORTAL: Vector3 = Vector3(48.0, 0.9, -128.0)

## One intermediate waypoint, not itself a named anchor, that places the
## reference image's single gentle bend between MIDPOINT and PORTAL.
const BEND: Vector3 = Vector3(22.0, 0.4, -105.0)

## Ordered centerline waypoints: straight from SPAWN to MIDPOINT (70 m), then a
## two-segment gentle curve -- about 32 degrees turning at MIDPOINT, then about
## 16 degrees more in the same direction at BEND -- through to PORTAL, with a
## slight rise (y 0.0 -> 0.9 m) across that second half.
const CENTERLINE: Array[Vector3] = [SPAWN, MIDPOINT, BEND, PORTAL]

## (arc length along CENTERLINE, clear corridor width in metres) control points
## for width_at(). Narrow at the rift-patch start -- the session brief explicitly
## allows this -- opening to the suggested 10-14 m ordinary band by the time the
## corridor is underway, then easing back down toward the gate threshold.
## Linearly interpolated between points; clamped to the first/last point outside
## [0, total_arc_length()].
const WIDTH_CONTROL_POINTS: Array[Vector2] = [
	Vector2(0.0, 6.0),
	Vector2(12.0, 9.0),
	Vector2(25.0, 12.0),
	Vector2(70.0, 13.0),
	Vector2(100.0, 11.0),
	Vector2(130.0, 10.0),
	Vector2(140.0, 9.0),
]

## Sum of CENTERLINE's segment lengths, measured rather than assumed.
static func total_arc_length() -> float:
	var total: float = 0.0
	for i in range(1, CENTERLINE.size()):
		total += CENTERLINE[i - 1].distance_to(CENTERLINE[i])
	return total

## Estimated direct-traversal time at the given speed (the accepted 5.0 m/s
## maximum movement speed by default).
static func traversal_time_seconds(speed: float = 5.0) -> float:
	return total_arc_length() / speed

## Clear corridor width at an arbitrary arc-length distance along CENTERLINE,
## linearly interpolated between WIDTH_CONTROL_POINTS and clamped at both ends.
static func width_at(arc_length: float) -> float:
	var points: Array[Vector2] = WIDTH_CONTROL_POINTS
	if arc_length <= points[0].x:
		return points[0].y
	var last: int = points.size() - 1
	if arc_length >= points[last].x:
		return points[last].y
	for i in range(1, points.size()):
		var a: Vector2 = points[i - 1]
		var b: Vector2 = points[i]
		if arc_length <= b.x:
			var t: float = (arc_length - a.x) / (b.x - a.x)
			return lerp(a.y, b.y, t)
	return points[last].y
