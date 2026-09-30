class_name TargetAcquisition
extends RefCounted
## Prototype Zero — Gate C targeting queries (specification §11).
##
## One place owns every "which target?" decision, so mouse selection, controller
## soft targeting, and release validation cannot drift apart. Since Gate D it
## works in terms of `PrototypeTargetable`, so an inert practice post and a real
## Graveblade go through exactly the same queries — which is the point: no
## targeting rule can quietly differ between the thing Gate C proved these rules
## on and the thing Gate D fights. Each query returns
## its reasoning as well as its answer, because §22 requires the debug surface to
## show "soft-target score and aim angle" and "target acquired, changed, or
## cleared" — a decision that cannot be inspected cannot be trusted.
##
## Nothing here moves an actor, spends a resource, or applies an effect.

const WORLD_MASK: int = 1
const TARGET_MASK: int = 4

var _world: World3D
var _cursor_ray_length: float = 400.0


func _init(world: World3D) -> void:
	_world = world


# --- Mouse -------------------------------------------------------------------

## Specification §11.1: "Right-clicking an enemy selects that enemy." The pick is
## an exact ray against the fixture's own body shape — no invisible generosity
## radius, so what the cursor is over is what gets selected.
func fixture_under_ray(from: Vector3, direction: Vector3) -> PrototypeTargetable:
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(
		from, from + direction * _cursor_ray_length, TARGET_MASK
	)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var hit: Dictionary = _world.direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return null
	var fixture: PrototypeTargetable = hit["collider"] as PrototypeTargetable
	if fixture == null or not fixture.is_valid_target():
		return null
	return fixture


# --- Controller soft targeting ----------------------------------------------

## Specification §11.2 priority, in order:
##   1. non-neutral left-stick direction     -> `intended`
##   2. eligible living targets inside the acquisition distance, the cone, and
##      line of sight
##   3. D-178: if any eligible candidate is ALREADY inside the Skill's release
##      reach, only that group is considered — a contact-melee attack must not
##      walk past something it could hit right now to approach something farther
##      away that happens to be aimed at a little better
##   4. within whichever group is active, angle to the intended direction is the
##      primary score and distance is the secondary one
##   5. current facing when the stick is neutral -> caller passes facing as `intended`
##   6. untargeted swing in the chosen direction when no sensible target exists
##
## The cone is a TOTAL width (D-178): a candidate may sit at most
## `soft_target_cone_half_degrees()` — 32.5 degrees for the locked 65 — either
## side of `intended`.
##
## `previous` implements the permitted brief retention: an already chosen target
## keeps its place while it is still sensible, so a held repeat does not flicker.
## Retention is searched inside the ACTIVE group only, which is what stops it
## preserving an out-of-reach approach target after an in-reach target appears.
func soft_target(
	origin: Vector3,
	intended: Vector3,
	candidates: Array[PrototypeTargetable],
	data: QuickStrikeData,
	previous: PrototypeTargetable = null
) -> Dictionary:
	var considered: Array[Dictionary] = []
	var half_cone: float = data.soft_target_cone_half_radians()
	var flat_intent: Vector3 = _planar(intended)
	if flat_intent.length() < 0.0001:
		return {
			"target": null, "group": "none",
			"reason": "no intended direction", "considered": considered,
		}
	flat_intent = flat_intent.normalized()

	for fixture: PrototypeTargetable in candidates:
		if fixture == null or not fixture.is_valid_target():
			continue
		var to_target: Vector3 = _planar(fixture.global_position - origin)
		var distance: float = to_target.length()
		if distance < 0.0001:
			continue
		var angle: float = flat_intent.angle_to(to_target.normalized())
		var record: Dictionary = {
			"fixture": fixture,
			"distance": distance,
			"angle_degrees": rad_to_deg(angle),
			# D-178 group membership, recorded for every candidate so the debug
			# surface can show WHY the priority group came out as it did.
			"in_reach": distance <= data.reach,
			"rejected": "",
		}
		if distance > data.soft_target_distance:
			record["rejected"] = "beyond %.1f m acquisition distance" % data.soft_target_distance
		elif angle > half_cone:
			record["rejected"] = "%.1f deg outside the %.1f deg half-cone (%.0f deg total)" % [
				rad_to_deg(angle), data.soft_target_cone_half_degrees(),
				data.soft_target_cone_total_degrees(),
			]
		elif is_obstructed(origin + Vector3.UP * 1.10, fixture.targeting_point()):
			record["rejected"] = "obstructed"
		considered.append(record)

	var eligible: Array[Dictionary] = []
	for record: Dictionary in considered:
		if String(record["rejected"]).is_empty():
			eligible.append(record)
	if eligible.is_empty():
		return {
			"target": null, "group": "none",
			"reason": "no eligible target in the %.0f deg cone" % data.soft_target_cone_total_degrees(),
			"considered": considered,
		}

	# D-178 priority group. Anything already inside the release reach forms the
	# first group; approach candidates are considered ONLY when that group is
	# empty. Eligibility itself is unchanged — this reorders, it never admits.
	var active: Array[Dictionary] = []
	for record: Dictionary in eligible:
		if bool(record["in_reach"]):
			active.append(record)
	var group: String = "in reach"
	if active.is_empty():
		active = eligible
		group = "approach"

	# Angle leads inside the active group. Everything within the tie band counts
	# as equally well aimed, and among those the nearest wins.
	var best_angle: float = INF
	for record: Dictionary in active:
		best_angle = minf(best_angle, float(record["angle_degrees"]))
	var chosen: Dictionary = {}
	for record: Dictionary in active:
		if float(record["angle_degrees"]) > best_angle + data.soft_target_angle_tie_degrees:
			continue
		if chosen.is_empty() or float(record["distance"]) < float(chosen["distance"]):
			chosen = record

	# Permitted retention: keep the previous target when it is still in the
	# active group and not meaningfully worse than the new pick. Searching the
	# ACTIVE group rather than every eligible candidate is what makes D-178's
	# last rule true — an out-of-reach target cannot be retained once a valid
	# in-reach target exists, because it is no longer in the group being decided.
	if previous != null:
		for record: Dictionary in active:
			if record["fixture"] != previous:
				continue
			if float(record["angle_degrees"]) <= best_angle + data.soft_target_angle_tie_degrees:
				return {
					"target": previous,
					"group": group,
					"reason": "retained, %s: still %.0f deg off, %.2f m" % [
						group, record["angle_degrees"], record["distance"],
					],
					"considered": considered,
				}
			break

	return {
		"target": chosen["fixture"],
		"group": group,
		"reason": "%s: %.0f deg off intent, %.2f m away" % [
			group, chosen["angle_degrees"], chosen["distance"],
		],
		"considered": considered,
	}


# --- Release validation ------------------------------------------------------

## Specification §11.3. The explicit target is preferred when it is still legal;
## otherwise the nearest legal enemy inside the ACTUAL release arc; otherwise the
## attack misses cleanly. Nothing is teleported and the reach is never extended.
func resolve_release(
	origin: Vector3,
	facing: Vector3,
	explicit: PrototypeTargetable,
	candidates: Array[PrototypeTargetable],
	data: QuickStrikeData
) -> Dictionary:
	var half_arc: float = data.release_arc_half_radians()
	var flat_facing: Vector3 = _planar(facing).normalized()
	var considered: Array[Dictionary] = []
	var legal: Array[Dictionary] = []

	for fixture: PrototypeTargetable in candidates:
		if fixture == null:
			continue
		var to_target: Vector3 = _planar(fixture.global_position - origin)
		var distance: float = to_target.length()
		var angle: float = INF if distance < 0.0001 else flat_facing.angle_to(to_target.normalized())
		var record: Dictionary = {
			"fixture": fixture,
			"distance": distance,
			"angle_degrees": rad_to_deg(angle) if angle != INF else 0.0,
			"rejected": "",
		}
		if not fixture.is_valid_target():
			record["rejected"] = "not a valid target"
		elif distance > data.reach:
			record["rejected"] = "%.2f m is beyond the %.2f m reach" % [distance, data.reach]
		elif angle > half_arc:
			record["rejected"] = "%.0f deg is outside the %.0f deg release arc" % [
				rad_to_deg(angle), data.release_arc_degrees,
			]
		elif is_obstructed(origin + Vector3.UP * 1.10, fixture.targeting_point()):
			record["rejected"] = "obstructed"
		considered.append(record)
		if String(record["rejected"]).is_empty():
			legal.append(record)

	if legal.is_empty():
		return {"outcome": "miss", "target": null, "reason": "nothing legal inside the release arc", "considered": considered}

	for record: Dictionary in legal:
		if record["fixture"] == explicit:
			return {
				"outcome": "hit",
				"target": explicit,
				"reason": "explicit target, %.2f m at %.0f deg" % [record["distance"], record["angle_degrees"]],
				"considered": considered,
			}

	var nearest: Dictionary = legal[0]
	for record: Dictionary in legal:
		if float(record["distance"]) < float(nearest["distance"]):
			nearest = record
	return {
		"outcome": "hit",
		"target": nearest["fixture"],
		"reason": "nearest inside the arc, %.2f m at %.0f deg" % [nearest["distance"], nearest["angle_degrees"]],
		"considered": considered,
	}


## Bounded deterministic gather: every target-layer shape overlapping a sphere of
## the skill's own reach. The precise distance and arc tests are then applied to
## the small result set, so the query cannot silently reach further than `reach`.
func candidates_in_reach(origin: Vector3, radius: float) -> Array[PrototypeTargetable]:
	var sphere: SphereShape3D = SphereShape3D.new()
	sphere.radius = radius
	var query: PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
	query.shape = sphere
	query.transform = Transform3D(Basis.IDENTITY, origin + Vector3.UP * 0.90)
	query.collision_mask = TARGET_MASK
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var found: Array[PrototypeTargetable] = []
	for hit: Dictionary in _world.direct_space_state.intersect_shape(query, 16):
		var fixture: PrototypeTargetable = hit["collider"] as PrototypeTargetable
		if fixture != null and not found.has(fixture):
			found.append(fixture)
	return found


## World geometry between the actor's chest and the target's. Walls and the
## optional barrier obstruct; target areas, the player, and the Graveblade never
## do — they are on their own layers, so bodies do not shield one another.
func is_obstructed(from: Vector3, to: Vector3) -> bool:
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to, WORLD_MASK)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	return not _world.direct_space_state.intersect_ray(query).is_empty()


func _planar(vector: Vector3) -> Vector3:
	return Vector3(vector.x, 0.0, vector.z)
