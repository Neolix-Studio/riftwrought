class_name ReferenceLandingGroundLayout
extends RefCounted
## Reference Landing Recreation -- Session 2: ground and surface (NON-CANONICAL).
##
## Lays a continuous, gap-free walkable floor along Session 1's
## `ReferenceLandingBlueprint.CENTERLINE`, inside its `width_at()` band, using
## only the twelve registered payloads below. It reuses Session 1's data and
## the project's established `ExteriorAssetProbe` ground-contact idiom
## (`riftfall_landing_layout.gd`'s `_place_aligned` / `_lay_surface` pattern);
## it adds no new asset, no new blueprint value, and no gameplay.
##
## WHY A GRID, NOT HAND PLACEMENT. This is a draft session and the task brief
## explicitly allows "a straightforward grid fill". A 2.0 m world-axis-aligned
## grid is used because 2.0 m is the smallest module among the twelve payloads
## (see `module` below, taken from this project's own D-202/D-215 records
## rather than re-measured from scratch) and every other module is an exact
## multiple of it, so a 2x2 block of small cells tiles exactly under one large
## (4.0 m) piece with no seam math. The grid is anchored on WORLD axes at the
## origin (cell (0,0) covers x in [0,2), z in [0,2)), independent of where the
## centerline sits, which is what keeps `cell_key`/`closest_on_centerline`
## stateless and the fill reproducible from raw coordinates alone.
##
## WHY THE GROUND IS NOT FLAT. `ReferenceLandingBlueprint.CENTERLINE` rises
## from y = 0.0 at SPAWN to y = 0.9 at PORTAL. `position_at_arc()` is the one
## place that reads that elevation back out, and every placement call in
## `build()` asks it for the ground height at that point's own arc length
## rather than assuming y = 0.0 -- the same "measure, don't assume" discipline
## `ExteriorAssetProbe.dominant_surface_y()` embodies for a single mesh,
## applied here to the route's own authored slope.
##
## THE BROKENNESS GRADIENT is the mechanism behind the reference image's read:
## a fissured, rough patch right at the rift spawn, worn stone through the
## corridor, and clean intact paving at the gate. `brokenness_at()` is built
## the same way `ReferenceLandingBlueprint.width_at()` already is -- linear
## interpolation over hand-placed (arc, value) control points -- but its
## control points are computed from `cumulative_arc_lengths()` rather than
## typed as absolute metres, so the gradient automatically tracks Session 1's
## own waypoints (MIDPOINT "still notably rough", BEND "firming up", roughly
## the last 12 m before PORTAL "mostly intact") even if that centerline is
## ever revised.
##
## DETERMINISM. Every decision this file makes -- which pool a cell draws
## from, which piece inside that pool, which quarter-turn it faces -- comes
## from `cell_random()`, a pure hash of the cell's own integer coordinates and
## a per-decision "salt" (never `Time.*`, never `randi()`/`randf()`, never
## engine RNG state). The same grid cell always resolves the same way on every
## run, which is what lets `ground_check.gd` re-derive an independent
## "expected walkable" set and compare it against `build()`'s own bookkeeping
## rather than merely re-reading it.
##
## THE MODULE CROSS-CHECK. Each payload record below states its own
## established modular footprint (`module`, in metres) from the project's own
## records, but this file also measures every one of the twelve at runtime via
## `ExteriorAssetProbe.measure()` and prints a warning -- never a hard failure
## -- if the measured horizontal footprint disagrees by more than
## `MODULE_TOLERANCE`. Stating a number and then never checking it against the
## asset itself is exactly the mistake `dominant_surface_y()`'s own doc
## comment records this project having already made once (`floor_dirt`'s
## bounding-box top hiding its real plane); this is that same lesson applied
## to a size rather than a height.
##
## GROUND CONTACT follows the two rules already established in
## `riftfall_landing_layout.gd` and `approved_environment_palette.gd`:
##   "surface" -- laid so `ExteriorAssetProbe.dominant_surface_y()` lands
##                exactly at the intended ground height, plus `SURFACE_LIFT`
##                so it is not exactly coplanar with the ground beneath it;
##   "base"    -- laid so the piece's measured, yaw-rotated AABB base and
##                horizontal centre land on the intended ground point.
## None of the twelve payloads below use "plant" contact, so that convention
## is not reproduced here.
##
## ACCENT PASS. `floor_foundation_corner` and `floor_foundation_front` are
## deliberately never part of the coverage fill itself -- they are 2.0 m
## revetment pieces meant to read as an edge, not a walking surface -- so they
## are scattered sparsely (12% chance) only along the outermost ~2 m strip of
## the width band, added ON TOP of whatever coverage piece already occupies
## that cell, and are never counted toward the gap-free coverage guarantee.

const FAMILY_DUNGEON: String = "KayKit Dungeon Asset Pack 1.1 FREE"
const FAMILY_HALLOWEEN: String = "KayKit Halloween Bits 1.0 FREE"

## The smallest module among the twelve payloads. Every larger module used
## here (4.0 m) is an exact multiple of it, so a 2x2 block of cells tiles
## exactly under one large piece.
const GRID_STEP: float = 2.0

## Flush means "flush plus this" -- see `riftfall_landing_layout.gd`'s own
## `SURFACE_LIFT` doc comment. Reused at the same value on purpose: a surface
## piece lowered so its top lies exactly at the authored ground height is
## coplanar with that ground and disappears / z-fights.
const SURFACE_LIFT: float = 0.008

## How far a payload's measured max horizontal AABB dimension may disagree
## with its stated `module` before this file prints a warning (never a hard
## failure -- see the class doc comment's "module cross-check" section).
const MODULE_TOLERANCE: float = 0.75

## The complete, approved set of ground payloads for this session. `contact`
## and `module` are stated from this project's own D-202/D-215 records;
## `_ensure_measured()` cross-checks `module` against a live measurement.
## Do not add, remove, substitute, or reference any other asset path here.
const GROUND_PAYLOADS: Array[Dictionary] = [
	{"key": "floor_tile_large", "family": FAMILY_DUNGEON, "contact": "surface", "module": 4.0,
		"path": "res://assets/third_party/kaykit/dungeon/floor_tile_large.gltf",
		"role": "intact large paving -- the sound baseline near the gate"},
	{"key": "floor_dirt", "family": FAMILY_HALLOWEEN, "contact": "surface", "module": 4.0,
		"path": "res://assets/third_party/kaykit/halloween/floor_dirt.gltf",
		"role": "open dirt/rubble ground -- the broken baseline near the rift patch"},
	{"key": "floor_foundation_corner", "family": FAMILY_DUNGEON, "contact": "base", "module": 2.0,
		"path": "res://assets/third_party/kaykit/dungeon/floor_foundation_corner.gltf",
		"role": "revetment corner accent, edge-of-band only (see accent pass)"},
	{"key": "floor_foundation_front", "family": FAMILY_DUNGEON, "contact": "base", "module": 2.0,
		"path": "res://assets/third_party/kaykit/dungeon/floor_foundation_front.gltf",
		"role": "revetment face accent, edge-of-band only (see accent pass)"},
	{"key": "floor_tile_large_rocks", "family": FAMILY_DUNGEON, "contact": "surface", "module": 4.0,
		"path": "res://assets/third_party/kaykit/dungeon/floor_tile_large_rocks.gltf",
		"role": "fallen-stone field, broken pool"},
	{"key": "floor_dirt_small", "family": FAMILY_HALLOWEEN, "contact": "surface", "module": 2.0,
		"path": "res://assets/third_party/kaykit/halloween/floor_dirt_small.gltf",
		"role": "dirt shoulder, half-module, broken pool"},
	{"key": "floor_dirt_large_rocky", "family": FAMILY_DUNGEON, "contact": "surface", "module": 4.0,
		"path": "res://assets/third_party/kaykit/dungeon/floor_dirt_large_rocky.gltf",
		"role": "open ground, paving gone, broken pool"},
	{"key": "floor_tile_small_weeds_A", "family": FAMILY_DUNGEON, "contact": "surface", "module": 2.0,
		"path": "res://assets/third_party/kaykit/dungeon/floor_tile_small_weeds_A.gltf",
		"role": "sparse weeds in joints, broken pool"},
	{"key": "floor_tile_small", "family": FAMILY_DUNGEON, "contact": "surface", "module": 2.0,
		"path": "res://assets/third_party/kaykit/dungeon/floor_tile_small.gltf",
		"role": "intact 2 m paving unit, intact pool"},
	{"key": "floor_tile_small_broken_A", "family": FAMILY_DUNGEON, "contact": "surface", "module": 2.0,
		"path": "res://assets/third_party/kaykit/dungeon/floor_tile_small_broken_A.gltf",
		"role": "fracture pattern A, broken pool"},
	{"key": "floor_tile_small_broken_B", "family": FAMILY_DUNGEON, "contact": "surface", "module": 2.0,
		"path": "res://assets/third_party/kaykit/dungeon/floor_tile_small_broken_B.gltf",
		"role": "fracture pattern B, broken pool"},
	{"key": "floor_tile_small_corner", "family": FAMILY_DUNGEON, "contact": "surface", "module": 2.0,
		"path": "res://assets/third_party/kaykit/dungeon/floor_tile_small_corner.gltf",
		"role": "corner-cut paved piece, intact pool (lower weight -- a special shape, not a generic tile)"},
]

## Weighted pools. Each dictionary's weights sum to 1.0. Iterated in
## declaration order by `weighted_pick()` -- GDScript dictionaries preserve
## insertion order, so this order is part of the deterministic contract.
const LARGE_BROKEN_WEIGHTS: Dictionary = {
	"floor_dirt": 0.40,
	"floor_dirt_large_rocky": 0.35,
	"floor_tile_large_rocks": 0.25,
}
const LARGE_INTACT_WEIGHTS: Dictionary = {
	"floor_tile_large": 1.00,
}
const SMALL_BROKEN_WEIGHTS: Dictionary = {
	"floor_dirt_small": 0.30,
	"floor_tile_small_broken_A": 0.25,
	"floor_tile_small_broken_B": 0.25,
	"floor_tile_small_weeds_A": 0.20,
}
const SMALL_INTACT_WEIGHTS: Dictionary = {
	"floor_tile_small": 0.80,
	"floor_tile_small_corner": 0.20,
}

## Per-key caches, populated once by `_ensure_measured()` and reused by every
## instance of that key -- with an estimated 250-450 total instances across
## only twelve keys, re-measuring per instance would dominate headless run
## time for no benefit, exactly as `riftfall_landing_layout.gd`'s own
## `surface_drops` / `_aabb_cache` dictionaries exist to avoid.
var _aabb_cache: Dictionary = {}
var _surface_drop_cache: Dictionary = {}

## Running counter used only to keep instanced node names unique.
var _instance_index: int = 0


## Looks up one payload record by key, or `{}` if `key` is not one of the
## twelve. Mirrors `RiftfallLandingLayout.payload()`.
static func payload(key: String) -> Dictionary:
	for record: Dictionary in GROUND_PAYLOADS:
		if String(record["key"]) == key:
			return record
	return {}


## Cumulative arc length at each `ReferenceLandingBlueprint.CENTERLINE`
## waypoint: `[0.0, arc-at-MIDPOINT, arc-at-BEND, arc-at-PORTAL]`. The final
## entry equals `ReferenceLandingBlueprint.total_arc_length()`; this function
## keeps every PARTIAL sum as well, which `total_arc_length()` deliberately
## does not expose.
static func cumulative_arc_lengths() -> Array[float]:
	var lengths: Array[float] = [0.0]
	var total: float = 0.0
	var centerline: Array[Vector3] = ReferenceLandingBlueprint.CENTERLINE
	for i: int in range(1, centerline.size()):
		total += centerline[i - 1].distance_to(centerline[i])
		lengths.append(total)
	return lengths


## The authored world position -- including elevation -- at an arbitrary arc
## length along `ReferenceLandingBlueprint.CENTERLINE`, linearly interpolated
## between waypoints and clamped at both ends. This is the ONLY place ground
## height should be read from; never assume y = 0.0.
static func position_at_arc(arc_length: float) -> Vector3:
	var centerline: Array[Vector3] = ReferenceLandingBlueprint.CENTERLINE
	var lengths: Array[float] = cumulative_arc_lengths()
	var last: int = lengths.size() - 1
	var total: float = lengths[last]
	var clamped: float = clampf(arc_length, 0.0, total)
	if clamped <= lengths[0]:
		return centerline[0]
	for i: int in range(1, lengths.size()):
		if clamped <= lengths[i]:
			var segment_length: float = lengths[i] - lengths[i - 1]
			var t: float = 0.0
			if segment_length > 0.0:
				t = (clamped - lengths[i - 1]) / segment_length
			return centerline[i - 1].lerp(centerline[i], t)
	return centerline[last]


## Projects the point `(x, z)` onto the CENTERLINE polyline (all three
## segments, in the horizontal XZ plane -- the width band is a horizontal
## measure) and returns the global minimum over segments as
## `{"distance": float, "arc": float}`, `arc` being the cumulative arc length
## at that closest point.
##
## The closest-point fraction `t` is computed from the XZ projection alone,
## but is the SAME `t` `position_at_arc()` would use to reach that point along
## the 3D segment: lerping a straight 3D segment by `t` moves its XZ
## coordinates by exactly `t` of their own span, since both are affine in the
## one shared parameter. So `t` is converted to an arc length using the
## segment's real 3D length (`lengths[i] - lengths[i - 1]`), not its 2D one,
## which is what keeps this function's `arc` consistent with
## `position_at_arc()`'s and `ReferenceLandingBlueprint.width_at()`'s.
static func closest_on_centerline(x: float, z: float) -> Dictionary:
	var centerline: Array[Vector3] = ReferenceLandingBlueprint.CENTERLINE
	var lengths: Array[float] = cumulative_arc_lengths()
	var point: Vector2 = Vector2(x, z)
	var best_distance: float = INF
	var best_arc: float = 0.0
	for i: int in range(1, centerline.size()):
		var a: Vector2 = Vector2(centerline[i - 1].x, centerline[i - 1].z)
		var b: Vector2 = Vector2(centerline[i].x, centerline[i].z)
		var segment_xz: Vector2 = b - a
		var segment_length_sq: float = segment_xz.length_squared()
		var t: float = 0.0
		if segment_length_sq > 0.0:
			t = clampf((point - a).dot(segment_xz) / segment_length_sq, 0.0, 1.0)
		var closest_xz: Vector2 = a + segment_xz * t
		var distance: float = point.distance_to(closest_xz)
		if distance < best_distance:
			best_distance = distance
			var segment_length_3d: float = lengths[i] - lengths[i - 1]
			best_arc = lengths[i - 1] + t * segment_length_3d
	return {"distance": best_distance, "arc": best_arc}


## True iff `(x, z)` lies inside the width band `ReferenceLandingBlueprint`
## defines at that point's own arc length.
static func is_within_band(x: float, z: float) -> bool:
	var info: Dictionary = closest_on_centerline(x, z)
	var half_width: float = ReferenceLandingBlueprint.width_at(float(info["arc"])) * 0.5
	return float(info["distance"]) <= half_width


## String key for grid cell `(ix, iz)`, used as a `Dictionary` set key so
## `build()`'s bookkeeping and `ground_check.gd`'s independent re-derivation
## can be compared directly.
static func cell_key(ix: int, iz: int) -> String:
	return "%d_%d" % [ix, iz]


## 0.0 = fully intact, 1.0 = fully broken, at a given arc length. Built the
## same way `ReferenceLandingBlueprint.width_at()` interpolates over control
## points, but the control points are computed from `cumulative_arc_lengths()`
## rather than hardcoded absolute metres, so this gradient stays correct if
## Session 1's centerline is ever revised:
##   0.0 (rift patch)                      -> 1.00 fully broken
##   40% of the way to MIDPOINT            -> 0.85
##   MIDPOINT                              -> 0.65 still notably rough
##   BEND                                  -> 0.35 firming up
##   the last ~12 m before PORTAL          -> 0.15
##   PORTAL (the gate)                     -> 0.05 mostly intact
static func brokenness_at(arc_length: float) -> float:
	var lengths: Array[float] = cumulative_arc_lengths()
	var points: Array[Vector2] = [
		Vector2(0.0, 1.00),
		Vector2(lengths[1] * 0.4, 0.85),
		Vector2(lengths[1], 0.65),
		Vector2(lengths[2], 0.35),
		Vector2(maxf(lengths[2], lengths[3] - 12.0), 0.15),
		Vector2(lengths[3], 0.05),
	]
	if arc_length <= points[0].x:
		return points[0].y
	var last: int = points.size() - 1
	if arc_length >= points[last].x:
		return points[last].y
	for i: int in range(1, points.size()):
		var a: Vector2 = points[i - 1]
		var b: Vector2 = points[i]
		if arc_length <= b.x:
			var span: float = b.x - a.x
			var t: float = 0.0 if span <= 0.0 else (arc_length - a.x) / span
			return lerp(a.y, b.y, t)
	return points[last].y


## `cell_random()`'s per-decision tags. Godot's `hash()` is a DJB2-style
## accumulate-then-multiply-by-33 hash, so a string's FINAL character is
## folded in with multiplier 33^0 = 1 -- added straight into the running
## hash with no further mixing at all. Every salt this file uses (1-8) used
## to be exactly that final character, as a single ASCII digit, so
## incrementing `salt` by one shifted the whole hash by (essentially) exactly
## one: the several draws meant to be independent per cell -- large-vs-small,
## broken-vs-intact pool, which piece inside that pool, yaw, accent chance,
## accent pool -- were nearly identical instead. Looking `salt` up here first
## replaces that single trailing digit with a whole distinct word of its own,
## so consecutive salts no longer share a near-identical tail and decorrelate
## from one another. Every salt value `cell_random()` is called with anywhere
## in this file must have an entry here.
const _SALT_TAGS: Dictionary = {
	1: "large_eligible",
	2: "large_pool",
	3: "large_pick",
	4: "small_pool",
	5: "small_pick",
	6: "yaw",
	7: "accent_chance",
	8: "accent_pick",
}


## Deterministic pseudo-random value in `[0.0, 1.0)` for grid cell `(ix, iz)`
## and a decision-specific `salt`. Pure hash of the cell's own integer
## coordinates and a decision tag looked up in `_SALT_TAGS` (see its doc
## comment for why a tag rather than the raw integer) -- no `Time.*`, no
## `randi()`/`randf()`, no engine RNG state -- so the same cell and the same
## salt always resolve to the same value on every run.
static func cell_random(ix: int, iz: int, salt: int) -> float:
	assert(_SALT_TAGS.has(salt), "cell_random: salt %d has no _SALT_TAGS entry" % salt)
	var tag: String = String(_SALT_TAGS.get(salt, str(salt)))
	return float(abs(hash("%d_%d_%s" % [ix, iz, tag])) % 1000000) / 1000000.0


## Walks `weights` (a `{key: String -> weight: float}` `Dictionary` summing to
## 1.0, iterated in its own declaration/insertion order) accumulating a
## running total, and returns the key whose cumulative bucket contains `r`.
## Falls back to the last key if floating-point rounding leaves `r` a hair
## past the final bucket boundary.
static func weighted_pick(weights: Dictionary, r: float) -> String:
	var cumulative: float = 0.0
	var last_key: String = ""
	for key: String in weights.keys():
		last_key = key
		cumulative += float(weights[key])
		if r < cumulative:
			return key
	return last_key


## One of the four quarter-turns `{0, PI/2, PI, 3*PI/2}`, chosen from a
## `[0.0, 1.0)` random value. Matches this project's established practice
## (`riftfall_landing_layout.gd`'s road-tile placement) of alternating quarter
## turns to break up a repeated-texture tile's own seams.
static func _quantized_yaw(random_value: float) -> float:
	const STEPS: Array[float] = [0.0, PI * 0.5, PI, PI * 1.5]
	var index: int = clampi(int(floor(random_value * 4.0)), 0, 3)
	return STEPS[index]


## Measures payload `key` exactly once (subsequent calls are a cache hit),
## populating `_aabb_cache` (used by "base" contact) and, for "surface"
## contact keys, `_surface_drop_cache` (`ExteriorAssetProbe.dominant_surface_y`
## in the piece's own local space). Also runs the module cross-check described
## in the class doc comment, printing a warning -- never a hard failure -- on
## disagreement greater than `MODULE_TOLERANCE`.
func _ensure_measured(key: String) -> void:
	if _aabb_cache.has(key):
		return
	var record: Dictionary = payload(key)
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

	var stated_module: float = float(record["module"])
	var measured_max: float = maxf(size.x, size.z)
	if absf(measured_max - stated_module) > MODULE_TOLERANCE:
		print(
			(
				"WARNING: ReferenceLandingGroundLayout: %s measured max horizontal "
				+ "AABB %.3f m differs from stated module %.3f m by more than %.2f m"
			) % [key, measured_max, stated_module, MODULE_TOLERANCE]
		)

	if String(record["contact"]) == "surface":
		_surface_drop_cache[key] = ExteriorAssetProbe.dominant_surface_y(probe_node)

	probe_node.free()


## Instantiates payload `key`, adds it under `parent`, and positions it so
## that its ground-contact convention ("surface" or "base") lands on the
## world point `(x, ground_y, z)` with the given `yaw`. `ground_y` must come
## from `position_at_arc()` -- never assume 0.0. Public per the task brief so
## the check script (or a future session) can call it directly.
func lay_ground_piece(
	key: String, x: float, z: float, ground_y: float, yaw: float, parent: Node3D
) -> Node3D:
	_ensure_measured(key)
	var record: Dictionary = payload(key)
	var scene: PackedScene = load(String(record["path"])) as PackedScene
	assert(scene != null, "Reference Landing ground: %s failed to load" % record["path"])
	var node: Node3D = scene.instantiate() as Node3D
	node.name = "%s_%d" % [key.replace("-", "_"), _instance_index]
	_instance_index += 1
	parent.add_child(node)
	node.rotation = Vector3(0.0, yaw, 0.0)

	if String(record["contact"]) == "surface":
		var surface_y: float = float(_surface_drop_cache[key])
		node.position = Vector3(x, ground_y - surface_y + SURFACE_LIFT, z)
	else:
		var box: AABB = _aabb_cache[key]
		var rotated: AABB = (
			Transform3D(Basis.from_euler(Vector3(0.0, yaw, 0.0)), Vector3.ZERO) * box
		)
		node.position = Vector3(
			x - rotated.get_center().x,
			ground_y - rotated.position.y,
			z - rotated.get_center().z,
		)

	return node


## Main entry point. Creates one `Node3D` named "Ground" under `parent` (the
## only node this function adds directly to `parent`; every instanced payload
## goes under "Ground"), fills the whole width band along
## `ReferenceLandingBlueprint.CENTERLINE` with a gap-free 2.0 m grid of the
## twelve registered payloads biased by `brokenness_at()`, scatters a sparse
## revetment accent along the band's outer edge, and returns a `Dictionary`
## reporting exactly what it built.
func build(parent: Node3D) -> Dictionary:
	_aabb_cache.clear()
	_surface_drop_cache.clear()
	_instance_index = 0

	# Cross-check every registered payload once, regardless of whether this
	# particular deterministic run happens to use it, so the module warning
	# in the class doc comment is a property of the approved set rather than
	# of one run's random draws.
	for record: Dictionary in GROUND_PAYLOADS:
		_ensure_measured(String(record["key"]))

	var ground: Node3D = Node3D.new()
	ground.name = "Ground"
	parent.add_child(ground)

	var lengths: Array[float] = cumulative_arc_lengths()
	var total: float = lengths[lengths.size() - 1]

	# Bounding (ix, iz) range: sample the whole route every GRID_STEP of arc
	# length (plus the exact endpoint) and grow a running envelope from each
	# sample's own half-width plus a 1.0 m margin. Generous by construction --
	# `ground_check.gd`'s GAP CHECK independently re-derives the true band
	# over a much larger fixed range and would fail if this were too tight.
	var min_ix: int = 0
	var max_ix: int = 0
	var min_iz: int = 0
	var max_iz: int = 0
	var have_bounds: bool = false
	var step_index: int = 0
	while true:
		var arc: float = minf(float(step_index) * GRID_STEP, total)
		var pos: Vector3 = position_at_arc(arc)
		var half_span: float = ReferenceLandingBlueprint.width_at(arc) * 0.5 + 1.0
		var lo_ix: int = int(floor((pos.x - half_span) / GRID_STEP))
		var hi_ix: int = int(floor((pos.x + half_span) / GRID_STEP))
		var lo_iz: int = int(floor((pos.z - half_span) / GRID_STEP))
		var hi_iz: int = int(floor((pos.z + half_span) / GRID_STEP))
		if not have_bounds:
			min_ix = lo_ix
			max_ix = hi_ix
			min_iz = lo_iz
			max_iz = hi_iz
			have_bounds = true
		else:
			min_ix = mini(min_ix, lo_ix)
			max_ix = maxi(max_ix, hi_ix)
			min_iz = mini(min_iz, lo_iz)
			max_iz = maxi(max_iz, hi_iz)
		if arc >= total:
			break
		step_index += 1

	var filled: Dictionary = {}
	## cell_key -> Vector2i(ix, iz), for cells confirmed inside the band.
	var walkable: Dictionary = {}
	var used_keys: Dictionary = {}
	var coverage_instances: int = 0

	for iz: int in range(min_iz, max_iz + 1):
		for ix: int in range(min_ix, max_ix + 1):
			var key: String = cell_key(ix, iz)
			if filled.has(key):
				continue

			var cx: float = (float(ix) + 0.5) * GRID_STEP
			var cz: float = (float(iz) + 0.5) * GRID_STEP
			var info: Dictionary = closest_on_centerline(cx, cz)
			var half_width: float = ReferenceLandingBlueprint.width_at(float(info["arc"])) * 0.5
			if float(info["distance"]) > half_width:
				continue

			walkable[key] = Vector2i(ix, iz)

			var placed_large: bool = false
			if ix % 2 == 0 and iz % 2 == 0:
				var sub_coords: Array[Vector2i] = [
					Vector2i(ix, iz), Vector2i(ix + 1, iz),
					Vector2i(ix, iz + 1), Vector2i(ix + 1, iz + 1),
				]
				var all_free: bool = true
				for coord: Vector2i in sub_coords:
					if filled.has(cell_key(coord.x, coord.y)):
						all_free = false
						break
				var all_in_band: bool = all_free
				if all_free:
					for coord: Vector2i in sub_coords:
						var sub_cx: float = (float(coord.x) + 0.5) * GRID_STEP
						var sub_cz: float = (float(coord.y) + 0.5) * GRID_STEP
						if not is_within_band(sub_cx, sub_cz):
							all_in_band = false
							break

				if all_in_band and cell_random(ix, iz, 1) < 0.5:
					var block_cx: float = (float(ix) + 1.0) * GRID_STEP
					var block_cz: float = (float(iz) + 1.0) * GRID_STEP
					var broken: float = brokenness_at(float(info["arc"]))
					var pool: Dictionary = (
						LARGE_BROKEN_WEIGHTS if cell_random(ix, iz, 2) < broken
						else LARGE_INTACT_WEIGHTS
					)
					var chosen: String = weighted_pick(pool, cell_random(ix, iz, 3))
					var yaw: float = _quantized_yaw(cell_random(ix, iz, 6))
					var ground_y: float = position_at_arc(float(info["arc"])).y
					lay_ground_piece(chosen, block_cx, block_cz, ground_y, yaw, ground)
					used_keys[chosen] = true
					coverage_instances += 1
					for coord: Vector2i in sub_coords:
						var sub_key: String = cell_key(coord.x, coord.y)
						filled[sub_key] = true
						walkable[sub_key] = coord
					placed_large = true

			if placed_large:
				continue

			var broken_small: float = brokenness_at(float(info["arc"]))
			var pool_small: Dictionary = (
				SMALL_BROKEN_WEIGHTS if cell_random(ix, iz, 4) < broken_small
				else SMALL_INTACT_WEIGHTS
			)
			var chosen_small: String = weighted_pick(pool_small, cell_random(ix, iz, 5))
			var yaw_small: float = _quantized_yaw(cell_random(ix, iz, 6))
			var ground_y_small: float = position_at_arc(float(info["arc"])).y
			lay_ground_piece(chosen_small, cx, cz, ground_y_small, yaw_small, ground)
			used_keys[chosen_small] = true
			coverage_instances += 1
			filled[key] = true

	# Accent pass. Runs after coverage is complete, over the walkable set
	# already recorded. Never touches `filled` -- it is a decorative addition,
	# not a replacement, and must not affect the gap check.
	var accent_instances: int = 0
	for key: String in walkable.keys():
		var coord: Vector2i = walkable[key]
		var ix: int = coord.x
		var iz: int = coord.y
		var cx: float = (float(ix) + 0.5) * GRID_STEP
		var cz: float = (float(iz) + 0.5) * GRID_STEP
		var info: Dictionary = closest_on_centerline(cx, cz)
		var half_width: float = ReferenceLandingBlueprint.width_at(float(info["arc"])) * 0.5
		var distance: float = float(info["distance"])
		if half_width - distance > GRID_STEP:
			continue
		if cell_random(ix, iz, 7) >= 0.12:
			continue
		var accent_key: String = (
			"floor_foundation_corner" if cell_random(ix, iz, 8) < 0.5
			else "floor_foundation_front"
		)
		var ground_y: float = position_at_arc(float(info["arc"])).y
		var yaw: float = _quantized_yaw(cell_random(ix, iz, 6))
		lay_ground_piece(accent_key, cx, cz, ground_y, yaw, ground)
		used_keys[accent_key] = true
		accent_instances += 1

	var used_keys_array: Array[String] = []
	for key: String in used_keys.keys():
		used_keys_array.append(key)
	var filled_cells_array: Array[String] = []
	for key: String in filled.keys():
		filled_cells_array.append(key)
	var walkable_cells_array: Array[String] = []
	for key: String in walkable.keys():
		walkable_cells_array.append(key)

	return {
		"instances": coverage_instances + accent_instances,
		"coverage_instances": coverage_instances,
		"accent_instances": accent_instances,
		"used_keys": used_keys_array,
		"filled_cells": filled_cells_array,
		"walkable_cells": walkable_cells_array,
	}
