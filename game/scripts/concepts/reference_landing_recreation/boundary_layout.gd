class_name ReferenceLandingBoundaryLayout
extends RefCounted
## Reference Landing Recreation -- Session 3: roads and boundaries (NON-CANONICAL).
##
## Frames both edges of Session 1's width band (`ReferenceLandingBlueprint`) with a
## low kerb line ("Roads") and, further out, a sealing boundary line of fences,
## rock masses and lantern posts ("Boundaries"), matching the reference image's
## damaged low walls and dead-tree-lined edges with a few deliberate breaches.
## See docs/concepts/reference_landing_recreation/03_roads_and_boundaries.md.
##
## BUILDS ON SESSION 1 AND 2 BY CALLING THEIR PUBLIC STATICS, NOT BY COPYING THEM.
## `ReferenceLandingGroundLayout.position_at_arc()`, `.cumulative_arc_lengths()`
## and `.brokenness_at()` are already the authoritative "where is the ground, and
## how broken is it here" answers Session 2 built; this file calls them directly
## instead of re-deriving a second, potentially drifting copy. Only the one thing
## neither prior file needed -- "which way does the route face at this arc length,
## so an edge piece can turn to follow it" -- is new here.
##
## WHY EDGES ARE WALKED PER STRAIGHT SEGMENT, NOT ALONG A CURVED OFFSET CURVE.
## `ReferenceLandingBlueprint.CENTERLINE` is three straight segments (SPAWN to
## MIDPOINT, MIDPOINT to BEND, BEND to PORTAL); this is a draft session, so each
## edge is walked as three straight runs at that segment's own tangent, with one
## `barrier_corner` dropped at each interior waypoint to mark the turn, rather
## than computing a properly curved offset polyline. The corridor's two bends are
## gentle (about 32 degrees, then 16 more), so the seam this leaves is small and
## camera-hidden at the 55-degree accepted pitch.
##
## HOW A PIECE'S FACING IS DERIVED FROM ITS OWN MEASURED SHAPE, NOT ASSUMED.
## `game/assets/third_party/kaykit/SOURCE_AND_LICENSE.md` establishes that this
## rig faces +Z at identity and that facing a direction D uses
## `atan2(D.x, D.z)` -- `riftfall_landing_layout.gd`'s own wall placements confirm
## the same convention holds for KayKit architecture props (`wall` needs yaw 0 for
## a Z-running curtain and PI/2 for an X-running one, i.e. its long axis is local
## Z). Rather than hand-typing which axis is long for every one of the nineteen
## Roads/Boundaries payloads, `_ensure_measured()` reads it off each piece's own
## measured AABB (`size.z >= size.x` => long axis Z, matching `wall`'s own
## convention; otherwise X, using the mirror-image formula derived from the same
## rotation). A natural rock (FAMILY_FOREST) skips this entirely and gets an
## arbitrary deterministic yaw instead, exactly as `riftfall_landing_layout.gd`'s
## own rock placements do (`_place_aligned(outcrop, at, float(at.z) * 0.11, ...)`)
## -- an irregular mass has no "long axis" worth aligning to the road.
##
## THE BROKENNESS GRADIENT DRIVES BOTH LAYERS, REUSING SESSION 2'S OWN CURVE.
## Roads: `barrier`'s own role text in `approved_environment_palette.gd` says the
## quiet part out loud -- "because it is a discrete module, simply omitting units
## along the length IS the degradation -- unbroken at the arrival, gapped, then
## gone" -- so units are progressively OMITTED (not shrunk or reskinned) as
## `ReferenceLandingGroundLayout.brokenness_at()` rises toward SPAWN, and
## `barrier_column` (a kerb with an integral post) replaces plain `barrier` for
## the "intact approach" once brokenness drops low near PORTAL. Boundaries: the
## same brokenness value picks between a broken-dominant weighted pool
## (`fence_broken`, rock masses) and an intact-dominant one (`fence`,
## `fence_pillar`), mirroring `ground_layout.gd`'s LARGE_BROKEN_WEIGHTS /
## LARGE_INTACT_WEIGHTS split exactly.
##
## THREE DELIBERATE BOUNDARY BREACHES. `BREACHES` names three one-sided arc
## ranges (a design choice, authored directly against Session 1's own waypoints,
## exactly as `BEND` is authored in `blueprint.gd` rather than derived) where the
## boundary-fill cursor still advances but places nothing, opening a gap that
## reads as damage rather than as the corridor being open on both sides at once.
## Roads (the kerb) are NOT breached -- the task brief ties breaches to the
## boundary line specifically, and the kerb already thins toward SPAWN on its own
## through the omission mechanism above.
##
## POST_LANTERN IS ON ITS OWN RHYTHM, DELIBERATELY SEPARATE FROM THE WEIGHTED
## FILL. The task brief is explicit that this rhythm matters because Session 5
## matches torches to it, so lanterns are placed by `_build_lanterns()` at a
## fixed `LANTERN_SPACING_ARC` and are the ONLY payload that function ever
## places -- not mixed into the general pool, which would make the spacing
## irregular. A lantern is skipped only where its side is inside a breach (a
## missing beat in the chain, not an unlit post), and every kept position is
## returned in `build()`'s `"lantern_positions"` entry for Session 5 to read
## directly instead of re-deriving.
##
## GROUND CONTACT follows the same three rules `ground_layout.gd` and
## `riftfall_landing_layout.gd` already establish:
##   "base"    -- measured, yaw-rotated AABB base and horizontal centre land on
##                the target ground point (every Roads payload; most Boundaries).
##   "surface" -- `ExteriorAssetProbe.dominant_surface_y()` lands on the target
##                height plus `SURFACE_LIFT` (only `plaque`, and unused by
##                default -- see the class doc note below on why).
##   "plant"   -- placed at its own authored origin, unadjusted, because the
##                piece is modelled already planted or half-buried
##                (`Rock_3_R_Color1`, `Rock_3_K_Color1`, `Rock_3_A_Color1`).
##
## WHY `plaque` IS DECLARED BUT NEVER PLACED BY DEFAULT. It is a genuine Roads
## payload ("a 2 x 2 m inscribed slab... not a repeating unit") and is measured
## and cross-checked with the other eighteen so a later session or the owner can
## drop one in without discovering a stale entry, but this session's own task is
## edge framing, not way-markers, so `build()` places zero of them. `used_keys`
## in the returned Dictionary will not include it, and that is a correct report
## rather than an oversight.
##
## DETERMINISM. Every yaw, pool draw and omission roll comes from `cell_random()`
## -- a pure hash of an integer index, a side and a decision-specific salt, never
## `Time.*`/`randi()`/`randf()`/engine RNG state -- so the same route resolves the
## same way on every run. `_SALT_TAGS` exists for the same reason
## `ground_layout.gd`'s does: Godot's `hash()` folds a string's FINAL character in
## with multiplier 33^0 = 1, so a bare trailing digit barely perturbs the hash
## between adjacent salts; looking the salt up as a whole word first avoids that.

const FAMILY_DUNGEON: String = "KayKit Dungeon Asset Pack 1.1 FREE"
const FAMILY_HALLOWEEN: String = "KayKit Halloween Bits 1.0 FREE"
const FAMILY_FOREST: String = "KayKit Forest Nature Pack 1.0 FREE"

const SURFACE_LIFT: float = 0.008

## Extra clearance BEYOND `ReferenceLandingBlueprint.width_at(arc) * 0.5`, so a
## piece's own reference point sits this far outside the walkable band -- never
## merely at its edge. `boundary_check.gd`'s spot check verifies this holds for
## EVERY placed instance, not a sample.
const ROAD_GAP: float = 0.6
const BOUNDARY_GAP: float = 2.0

## Extra clearance added to a `barrier_corner`'s own miter offset, beyond
## `ROAD_GAP` -- see its placement block in `_build_roads()` for why a miter
## needs a bigger margin than a straight run does.
const CORNER_EXTRA_GAP: float = 1.0

## Kerb and boundary framing start this far past SPAWN (the rift patch stays
## unframed, matching the reference image) and stop this far short of PORTAL
## (Session 4's gate architecture takes over the immediate threshold).
const ROAD_START_ARC: float = 6.0
const ROAD_END_ARC_MARGIN: float = 3.0

const LANTERN_START_ARC: float = 12.0
const LANTERN_SPACING_ARC: float = 14.0

const LEFT: int = -1
const RIGHT: int = 1

## Three deliberate one-sided boundary breaches -- see the class doc comment.
const BREACHES: Array[Dictionary] = [
	{"arc_from": 14.0, "arc_to": 23.0, "side": LEFT},
	{"arc_from": 86.0, "arc_to": 96.0, "side": RIGHT},
	{"arc_from": 128.0, "arc_to": 136.0, "side": LEFT},
]

## Roads -- 6 pieces, all from `approved_environment_palette.gd`'s Roads drawer.
const ROAD_PAYLOADS: Array[Dictionary] = [
	{"key": "barrier_colum_half", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/barrier_colum_half.gltf",
		"role": "2.350 m off-grid fitting piece, closes a run whose leftover isn't a clean 2 or 4 m."},
	{"key": "barrier_column", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/barrier_column.gltf",
		"role": "1.400 m kerb with an integral post; used for the intact approach near PORTAL."},
	{"key": "barrier_corner", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/barrier_corner.gltf",
		"role": "Turns the kerb line through MIDPOINT and BEND."},
	{"key": "barrier", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/barrier.gltf",
		"role": "Plain 4 m road edge; the default kerb unit, progressively omitted toward SPAWN."},
	{"key": "barrier_half", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/barrier_half.gltf",
		"role": "2 m half-module kerb; closes a run whose leftover is a clean half module."},
	{"key": "plaque", "family": FAMILY_HALLOWEEN, "contact": "surface",
		"path": "res://assets/third_party/kaykit/halloween/plaque.gltf",
		"role": "2x2 m marker slab; measured and cross-checked, deliberately unused this session -- see class doc comment."},
]

## Boundaries -- 8 pieces from `approved_environment_palette.gd`'s Boundaries
## drawer plus 5 from the Gate 1C allowlist (`fence_broken`, `fence_pillar_broken`
## and three more forest rocks), for 13 total.
const BOUNDARY_PAYLOADS: Array[Dictionary] = [
	{"key": "fence", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/fence.gltf",
		"role": "Intact fence; the near-PORTAL, maintained-looking pool."},
	{"key": "fence_pillar", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/fence_pillar.gltf",
		"role": "Intact 2.200 m stone post, accompanies fence in the intact pool."},
	{"key": "post", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/post.gltf",
		"role": "Unlit 3.30 m post; a plain support in both pools, never on the lantern rhythm."},
	{"key": "post_lantern", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/post_lantern.gltf",
		"role": "Lit 3.30 m post; placed ONLY by _build_lanterns() on its own even rhythm."},
	{"key": "Rock_1_H_Color1", "family": FAMILY_FOREST, "contact": "base",
		"path": "res://assets/third_party/kaykit/forest/Rock_1_H_Color1.gltf",
		"role": "1.868 m rock, missing-middle-rung; shoulders the corridor in both pools."},
	{"key": "Rock_2_F_Color1", "family": FAMILY_FOREST, "contact": "base",
		"path": "res://assets/third_party/kaykit/forest/Rock_2_F_Color1.gltf",
		"role": "4.143 m natural mass, substitutes for one fence bay in the broken pool."},
	{"key": "Rock_3_R_Color1", "family": FAMILY_FOREST, "contact": "plant",
		"path": "res://assets/third_party/kaykit/forest/Rock_3_R_Color1.gltf",
		"role": "Wide impassable natural mass, broken pool only."},
	{"key": "Rock_3_K_Color1", "family": FAMILY_FOREST, "contact": "plant",
		"path": "res://assets/third_party/kaykit/forest/Rock_3_K_Color1.gltf",
		"role": "Bedrock through the fractured scar ground; hand-placed near SPAWN only, not in either pool."},
	{"key": "fence_broken", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/fence_broken.gltf",
		"role": "Broken fence, Gate 1C allowlist; the broken pool's dominant member."},
	{"key": "fence_pillar_broken", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/fence_pillar_broken.gltf",
		"role": "Broken post, Gate 1C allowlist; accompanies fence_broken in the broken pool."},
	{"key": "Rock_1_A_Color1", "family": FAMILY_FOREST, "contact": "base",
		"path": "res://assets/third_party/kaykit/forest/Rock_1_A_Color1.gltf",
		"role": "0.540 m pebble mass, Gate 1C allowlist; broken pool."},
	{"key": "Rock_1_Q_Color1", "family": FAMILY_FOREST, "contact": "base",
		"path": "res://assets/third_party/kaykit/forest/Rock_1_Q_Color1.gltf",
		"role": "Outcrop, Gate 1C allowlist; both pools."},
	{"key": "Rock_3_A_Color1", "family": FAMILY_FOREST, "contact": "plant",
		"path": "res://assets/third_party/kaykit/forest/Rock_3_A_Color1.gltf",
		"role": "Half-buried route rock, Gate 1C allowlist; hand-placed near SPAWN only, not in either pool."},
]

## Weighted pools for the boundary-fill cursor. Iterated in declaration order by
## `weighted_pick()` -- GDScript dictionaries preserve insertion order -- so this
## order is part of the deterministic contract, exactly as `ground_layout.gd`'s
## weight dictionaries are.
const BOUNDARY_BROKEN_WEIGHTS: Dictionary = {
	"fence_broken": 0.30,
	"fence_pillar_broken": 0.12,
	"Rock_2_F_Color1": 0.14,
	"Rock_1_H_Color1": 0.10,
	"Rock_1_A_Color1": 0.09,
	"Rock_1_Q_Color1": 0.08,
	"Rock_3_R_Color1": 0.06,
	"post": 0.11,
}
const BOUNDARY_INTACT_WEIGHTS: Dictionary = {
	"fence": 0.48,
	"fence_pillar": 0.22,
	"post": 0.12,
	"Rock_1_H_Color1": 0.09,
	"Rock_1_Q_Color1": 0.09,
}

## Hand-placed accents near SPAWN, closer in than the main boundary line -- see
## `Rock_3_K_Color1` and `Rock_3_A_Color1`'s role text above. Not part of either
## weighted pool; a fixed, small, authored set, the same idiom
## `riftfall_landing_layout.gd`'s `_build_forest_framing()` uses for its own
## half-buried route rocks.
const SPAWN_ACCENTS: Array[Dictionary] = [
	{"key": "Rock_3_K_Color1", "arc": 5.0, "side": LEFT},
	{"key": "Rock_3_K_Color1", "arc": 7.0, "side": RIGHT},
	{"key": "Rock_3_A_Color1", "arc": 9.0, "side": LEFT},
	{"key": "Rock_3_A_Color1", "arc": 10.0, "side": RIGHT},
]

const _SALT_TAGS: Dictionary = {
	1: "omit",
	2: "pool_broken",
	3: "pool_pick",
	4: "plant_yaw",
	5: "accent_yaw",
}

var _aabb_cache: Dictionary = {}
var _surface_drop_cache: Dictionary = {}
var _module_cache: Dictionary = {}
var _long_axis_cache: Dictionary = {}
var _instance_index: int = 0


static func road_payload(key: String) -> Dictionary:
	for record: Dictionary in ROAD_PAYLOADS:
		if String(record["key"]) == key:
			return record
	return {}


static func boundary_payload(key: String) -> Dictionary:
	for record: Dictionary in BOUNDARY_PAYLOADS:
		if String(record["key"]) == key:
			return record
	return {}


## Deterministic pseudo-random value in `[0.0, 1.0)` for an integer `index`, a
## `side` (LEFT/RIGHT) and a decision-specific `salt` -- see the class doc
## comment's DETERMINISM section for why `salt` is looked up in `_SALT_TAGS`
## rather than folded in as a raw integer.
static func cell_random(index: int, side: int, salt: int) -> float:
	assert(_SALT_TAGS.has(salt), "cell_random: salt %d has no _SALT_TAGS entry" % salt)
	var tag: String = String(_SALT_TAGS.get(salt, str(salt)))
	return float(abs(hash("%d_%d_%s" % [index, side, tag])) % 1000000) / 1000000.0


static func weighted_pick(weights: Dictionary, r: float) -> String:
	var cumulative: float = 0.0
	var last_key: String = ""
	for key: String in weights.keys():
		last_key = key
		cumulative += float(weights[key])
		if r < cumulative:
			return key
	return last_key


## Index (0, 1 or 2) of the `ReferenceLandingBlueprint.CENTERLINE` segment that
## contains `arc`, clamped to the last segment beyond the route's own length.
static func segment_index_for_arc(arc: float) -> int:
	var lengths: Array[float] = ReferenceLandingGroundLayout.cumulative_arc_lengths()
	for i: int in range(1, lengths.size()):
		if arc <= lengths[i]:
			return i - 1
	return lengths.size() - 2


## Normalized horizontal (x, z) direction of travel for CENTERLINE segment `i`,
## returned as `Vector2(dx, dz)`.
static func horizontal_tangent_for_segment(i: int) -> Vector2:
	var centerline: Array[Vector3] = ReferenceLandingBlueprint.CENTERLINE
	var a: Vector3 = centerline[i]
	var b: Vector3 = centerline[i + 1]
	var flat: Vector2 = Vector2(b.x - a.x, b.z - a.z)
	if flat.length() <= 0.0001:
		return Vector2(0.0, -1.0)
	return flat.normalized()


static func horizontal_tangent_at_arc(arc: float) -> Vector2:
	return horizontal_tangent_for_segment(segment_index_for_arc(arc))


## World point offset perpendicular from the centerline at `arc`, `offset`
## metres BEYOND the width band's own half-width on the given `side`
## (LEFT = -1, RIGHT = +1). Ground height comes from
## `ReferenceLandingGroundLayout.position_at_arc()`, never assumed.
static func edge_point(arc: float, side: int, offset: float) -> Vector3:
	var half_width: float = ReferenceLandingBlueprint.width_at(arc) * 0.5
	var total_offset: float = half_width + offset
	var tangent: Vector2 = horizontal_tangent_at_arc(arc)
	var perp: Vector2 = Vector2(-tangent.y, tangent.x) * float(side)
	var center: Vector3 = ReferenceLandingGroundLayout.position_at_arc(arc)
	return Vector3(
		center.x + perp.x * total_offset, center.y, center.z + perp.y * total_offset
	)


## True iff `arc` on `side` falls inside one of the three authored `BREACHES`.
static func is_breached(arc: float, side: int) -> bool:
	for breach: Dictionary in BREACHES:
		if int(breach["side"]) == side and arc >= float(breach["arc_from"]) \
				and arc <= float(breach["arc_to"]):
			return true
	return false


## Measures payload `key` exactly once, populating `_aabb_cache` ("base"
## contact), `_surface_drop_cache` ("surface" contact), `_module_cache` (every
## contact -- the piece's own footprint, used as its cursor-advance step) and
## `_long_axis_cache` ("local Z" or "local X", whichever measured AABB dimension
## is larger -- see the class doc comment's facing note).
func _ensure_measured(key: String, record: Dictionary) -> void:
	if _aabb_cache.has(key):
		return
	var probe_node: Node3D = (load(String(record["path"])) as PackedScene).instantiate() as Node3D
	var measured: Dictionary = ExteriorAssetProbe.measure(probe_node)
	var size: Vector3 = measured["size"]
	var box: AABB = AABB(
		Vector3(
			float(measured["centre"].x) - size.x * 0.5,
			float(measured["base_offset"]),
			float(measured["centre"].z) - size.z * 0.5,
		),
		size,
	)
	_aabb_cache[key] = box
	_module_cache[key] = maxf(size.x, size.z)
	_long_axis_cache[key] = "z" if size.z >= size.x else "x"

	if String(record["contact"]) == "surface":
		_surface_drop_cache[key] = ExteriorAssetProbe.dominant_surface_y(probe_node)

	probe_node.free()


## Yaw that aligns payload's measured long axis with horizontal direction
## `tangent`, derived from the same Y-axis rotation `riftfall_landing_layout.gd`'s
## wall placements already confirm: at yaw 0 local +Z maps to world (0, 0, 1),
## and `yaw = atan2(D.x, D.z)` aligns local +Z with any direction D. For a piece
## whose long axis is local X instead, the mirror-image solution is
## `atan2(-D.z, D.x)`.
static func _yaw_for_tangent(tangent: Vector2, long_axis: String) -> float:
	if long_axis == "z":
		return atan2(tangent.x, tangent.y)
	return atan2(-tangent.y, tangent.x)


## Instantiates payload `key` under `parent` at world point `(x, ground_y, z)`
## with the given `yaw`, honouring `record`'s ground-contact convention.
func lay_piece(
	key: String, record: Dictionary, x: float, z: float, ground_y: float, yaw: float,
	parent: Node3D
) -> Node3D:
	_ensure_measured(key, record)
	var scene: PackedScene = load(String(record["path"])) as PackedScene
	assert(scene != null, "Reference Landing boundary: %s failed to load" % record["path"])
	var node: Node3D = scene.instantiate() as Node3D
	node.name = "%s_%d" % [key.replace("-", "_"), _instance_index]
	_instance_index += 1
	parent.add_child(node)
	node.rotation = Vector3(0.0, yaw, 0.0)

	var contact: String = String(record["contact"])
	if contact == "surface":
		var surface_y: float = float(_surface_drop_cache[key])
		node.position = Vector3(x, ground_y - surface_y + SURFACE_LIFT, z)
	elif contact == "plant":
		node.position = Vector3(x, ground_y, z)
	else:
		var box: AABB = _aabb_cache[key]
		var rotated: AABB = (
			Transform3D(Basis.from_euler(Vector3(0.0, yaw, 0.0)), Vector3.ZERO) * box
		)
		node.position = Vector3(
			x - rotated.get_center().x, ground_y - rotated.position.y, z - rotated.get_center().z
		)

	return node


## Yaw for a boundary-fill instance of `key`/`record` at arc length `arc`: a
## natural rock (FAMILY_FOREST) gets an arbitrary deterministic spin, matching
## `riftfall_landing_layout.gd`'s own treatment of rocks; anything else is
## tangent-aligned via its measured long axis.
func _fill_yaw(key: String, record: Dictionary, arc: float, side: int) -> float:
	if String(record["family"]) == FAMILY_FOREST:
		return cell_random(int(round(arc * 10.0)), side, 4) * TAU
	return _yaw_for_tangent(horizontal_tangent_at_arc(arc), String(_long_axis_cache[key]))


func _record_placed(placed: Array, counts: Dictionary, key: String, pos: Vector3) -> void:
	counts[key] = int(counts.get(key, 0)) + 1
	placed.append({"key": key, "x": pos.x, "z": pos.z})


## Roads: a kerb line per side, walked per straight segment (see class doc
## comment), with `barrier_corner` marking each interior waypoint.
func _build_roads(parent: Node3D) -> Dictionary:
	var group: Node3D = Node3D.new()
	group.name = "Roads"
	parent.add_child(group)

	var lengths: Array[float] = ReferenceLandingGroundLayout.cumulative_arc_lengths()
	var total: float = lengths[lengths.size() - 1]
	var road_end: float = total - ROAD_END_ARC_MARGIN

	var counts: Dictionary = {}
	var placed: Array = []
	var corner_count: int = 0

	for side: int in [LEFT, RIGHT]:
		for seg: int in range(3):
			var seg_start: float = maxf(lengths[seg], ROAD_START_ARC)
			var seg_end: float = minf(lengths[seg + 1], road_end)
			if seg_end <= seg_start:
				continue

			var cursor: float = seg_start
			while cursor < seg_end:
				var broken: float = ReferenceLandingGroundLayout.brokenness_at(cursor)
				var key: String = "barrier_column" if broken < 0.20 else "barrier"
				var record: Dictionary = road_payload(key)
				_ensure_measured(key, record)
				var module: float = float(_module_cache[key])
				var remaining: float = seg_end - cursor

				if remaining < module:
					if remaining >= 1.5:
						key = "barrier_half"
					elif remaining >= 0.9:
						key = "barrier_colum_half"
					else:
						break
					record = road_payload(key)
					_ensure_measured(key, record)
					module = float(_module_cache[key])
					if remaining < module * 0.5:
						break

				var placed_arc: float = cursor + module * 0.5
				var omit: bool = false
				if key == "barrier":
					var omit_chance: float = clampf((broken - 0.55) * 1.6, 0.0, 0.55)
					omit = cell_random(int(round(placed_arc * 10.0)), side, 1) < omit_chance

				if not omit:
					var pos: Vector3 = edge_point(placed_arc, side, ROAD_GAP)
					var yaw: float = _yaw_for_tangent(
						horizontal_tangent_at_arc(placed_arc), String(_long_axis_cache[key])
					)
					lay_piece(key, record, pos.x, pos.z, pos.y, yaw, group)
					_record_placed(placed, counts, key, pos)

				cursor += module

		for corner_arc: float in [lengths[1], lengths[2]]:
			if corner_arc < ROAD_START_ARC or corner_arc > road_end:
				continue
			var record: Dictionary = road_payload("barrier_corner")
			_ensure_measured("barrier_corner", record)

			# MITER, NOT A PLAIN edge_point(). At a convex bend, offsetting only
			# perpendicular to the INCOMING segment's tangent can land the piece
			# closer to the OUTGOING segment's own centerline than to its own --
			# measured exactly this failure at MIDPOINT before this fix (a
			# barrier_corner at (7.10, -70.00) registered INSIDE the band because
			# it sat only 6.01 m from the next segment while sitting the full
			# 7.10 m from this one). Offsetting along the bisector of both
			# tangents instead (the standard polyline miter join) pushes the
			# corner piece outward from BOTH segments at once, plus
			# CORNER_EXTRA_GAP as a margin since a miter's own clearance is
			# smaller than a straight run's by construction (it shrinks as the
			# bend gets sharper).
			var tangent_in: Vector2 = horizontal_tangent_at_arc(maxf(corner_arc - 0.5, 0.0))
			var tangent_out: Vector2 = horizontal_tangent_at_arc(minf(corner_arc + 0.5, total))
			var bisector: Vector2 = tangent_in + tangent_out
			bisector = tangent_out if bisector.length() <= 0.0001 else bisector.normalized()
			var half_width: float = ReferenceLandingBlueprint.width_at(corner_arc) * 0.5
			var miter_offset: float = half_width + ROAD_GAP + CORNER_EXTRA_GAP
			var perp: Vector2 = Vector2(-bisector.y, bisector.x) * float(side)
			var center: Vector3 = ReferenceLandingGroundLayout.position_at_arc(corner_arc)
			var pos: Vector3 = Vector3(
				center.x + perp.x * miter_offset, center.y, center.z + perp.y * miter_offset
			)
			var yaw: float = _yaw_for_tangent(bisector, String(_long_axis_cache["barrier_corner"]))
			lay_piece("barrier_corner", record, pos.x, pos.z, pos.y, yaw, group)
			_record_placed(placed, counts, "barrier_corner", pos)
			corner_count += 1

	return {"group": group, "counts": counts, "placed": placed, "corner_count": corner_count}


## Boundaries: the weighted fill line -- see class doc comment for the pools and
## the breach mechanism.
func _build_boundary_fill(group: Node3D) -> Dictionary:
	var lengths: Array[float] = ReferenceLandingGroundLayout.cumulative_arc_lengths()
	var total: float = lengths[lengths.size() - 1]
	var boundary_end: float = total - ROAD_END_ARC_MARGIN

	var counts: Dictionary = {}
	var placed: Array = []
	var breach_skips: int = 0

	for side: int in [LEFT, RIGHT]:
		var cursor: float = ROAD_START_ARC
		while cursor < boundary_end:
			var broken: float = ReferenceLandingGroundLayout.brokenness_at(cursor)
			var index: int = int(round(cursor * 10.0))
			# BIASED, NOT A PLAIN brokenness COMPARISON. A first draft compared
			# the raw hash draw straight against `broken` and measured
			# fence(25) outnumbering fence_broken(10) -- the OPPOSITE of the
			# task brief's "use the broken fence variants ... more than the
			# intact fence" -- because more than half the route already sits
			# below brokenness 0.5 (everything past roughly the BEND) and the
			# intact pool's dominant "fence" entry (weight 0.48) then wins most
			# draws through that whole back half. The effective-broken bias
			# pushes the threshold up so the broken pool stays dominant across
			# most of the corridor and the intact pool only truly takes over in
			# the last stretch approaching PORTAL, matching the reference
			# image's read of "damaged for nearly the whole approach, whole only
			# right at the gate" rather than an even fence/rocks-per-brokenness
			# split.
			var effective_broken: float = clampf(broken * 1.6 + 0.10, 0.0, 1.0)
			var pool: Dictionary = (
				BOUNDARY_BROKEN_WEIGHTS if cell_random(index, side, 2) < effective_broken
				else BOUNDARY_INTACT_WEIGHTS
			)
			var key: String = weighted_pick(pool, cell_random(index, side, 3))
			var record: Dictionary = boundary_payload(key)
			_ensure_measured(key, record)
			var module: float = maxf(float(_module_cache[key]), 1.0)
			var placed_arc: float = cursor + module * 0.5

			if placed_arc <= boundary_end:
				if is_breached(placed_arc, side):
					breach_skips += 1
				else:
					var pos: Vector3 = edge_point(placed_arc, side, BOUNDARY_GAP)
					var yaw: float = _fill_yaw(key, record, placed_arc, side)
					lay_piece(key, record, pos.x, pos.z, pos.y, yaw, group)
					_record_placed(placed, counts, key, pos)

			cursor += module

	return {"counts": counts, "placed": placed, "breach_skips": breach_skips}


## Lanterns: their own fixed rhythm, independent of the weighted fill -- see
## class doc comment. `positions` is returned for Session 5 to read directly.
func _build_lanterns(group: Node3D) -> Dictionary:
	var lengths: Array[float] = ReferenceLandingGroundLayout.cumulative_arc_lengths()
	var total: float = lengths[lengths.size() - 1]
	var boundary_end: float = total - ROAD_END_ARC_MARGIN
	var record: Dictionary = boundary_payload("post_lantern")
	_ensure_measured("post_lantern", record)

	var counts: Dictionary = {}
	var placed: Array = []
	var positions: Array[Vector3] = []

	var arc: float = LANTERN_START_ARC
	while arc <= boundary_end:
		for side: int in [LEFT, RIGHT]:
			if is_breached(arc, side):
				continue
			var pos: Vector3 = edge_point(arc, side, BOUNDARY_GAP)
			var yaw: float = _yaw_for_tangent(
				horizontal_tangent_at_arc(arc), String(_long_axis_cache["post_lantern"])
			)
			lay_piece("post_lantern", record, pos.x, pos.z, pos.y, yaw, group)
			_record_placed(placed, counts, "post_lantern", pos)
			positions.append(pos)
		arc += LANTERN_SPACING_ARC

	return {"counts": counts, "placed": placed, "positions": positions}


## Hand-placed SPAWN_ACCENTS -- see class doc comment and the constant itself.
func _build_spawn_accents(group: Node3D) -> Dictionary:
	var counts: Dictionary = {}
	var placed: Array = []

	for entry: Dictionary in SPAWN_ACCENTS:
		var key: String = String(entry["key"])
		var record: Dictionary = boundary_payload(key)
		_ensure_measured(key, record)
		var arc: float = float(entry["arc"])
		var side: int = int(entry["side"])
		var pos: Vector3 = edge_point(arc, side, BOUNDARY_GAP * 0.6)
		var yaw: float = cell_random(int(round(arc * 10.0)), side, 5) * TAU
		lay_piece(key, record, pos.x, pos.z, pos.y, yaw, group)
		_record_placed(placed, counts, key, pos)

	return {"counts": counts, "placed": placed}


static func _merge_counts(into: Dictionary, from: Dictionary) -> void:
	for key: String in from.keys():
		into[key] = int(into.get(key, 0)) + int(from[key])


## Main entry point. Creates one "Roads" `Node3D` and one "Boundaries" `Node3D`
## under `parent` -- the only two nodes this function adds directly to `parent`.
## Returns a `Dictionary` reporting exactly what it built.
func build(parent: Node3D) -> Dictionary:
	_aabb_cache.clear()
	_surface_drop_cache.clear()
	_module_cache.clear()
	_long_axis_cache.clear()
	_instance_index = 0

	# Cross-measure every registered payload once, regardless of whether this
	# particular deterministic run happens to use it -- mirrors ground_layout.gd.
	for record: Dictionary in ROAD_PAYLOADS:
		_ensure_measured(String(record["key"]), record)
	for record: Dictionary in BOUNDARY_PAYLOADS:
		_ensure_measured(String(record["key"]), record)

	var roads: Dictionary = _build_roads(parent)

	var boundaries_group: Node3D = Node3D.new()
	boundaries_group.name = "Boundaries"
	parent.add_child(boundaries_group)

	var fill: Dictionary = _build_boundary_fill(boundaries_group)
	var lanterns: Dictionary = _build_lanterns(boundaries_group)
	var accents: Dictionary = _build_spawn_accents(boundaries_group)

	var road_counts: Dictionary = roads["counts"]
	var boundary_counts: Dictionary = {}
	_merge_counts(boundary_counts, fill["counts"])
	_merge_counts(boundary_counts, lanterns["counts"])
	_merge_counts(boundary_counts, accents["counts"])

	var all_placed: Array = []
	all_placed.append_array(roads["placed"])
	all_placed.append_array(fill["placed"])
	all_placed.append_array(lanterns["placed"])
	all_placed.append_array(accents["placed"])

	var road_instances: int = 0
	for key: String in road_counts.keys():
		road_instances += int(road_counts[key])
	var boundary_instances: int = 0
	for key: String in boundary_counts.keys():
		boundary_instances += int(boundary_counts[key])

	return {
		"road_counts": road_counts,
		"boundary_counts": boundary_counts,
		"road_instances": road_instances,
		"boundary_instances": boundary_instances,
		"corner_count": roads["corner_count"],
		"lantern_positions": lanterns["positions"],
		"breach_skips": fill["breach_skips"],
		"placed": all_placed,
	}
