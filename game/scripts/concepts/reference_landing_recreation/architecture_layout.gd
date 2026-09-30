class_name ReferenceLandingArchitectureLayout
extends RefCounted
## Reference Landing Recreation -- Session 4: architecture and background (NON-CANONICAL).
##
## Builds a damaged curtain-wall run along both sides of the route, a periodic
## pillar/column rank a little further out, a flanking gate structure at
## PORTAL, and a sparse unattended periphery scatter beyond all of it, so the
## world reads as continuing past Session 3's boundary line rather than
## stopping there. See
## docs/concepts/reference_landing_recreation/04_architecture_and_background.md.
##
## BUILDS ON SESSIONS 1-3 BY CALLING THEIR PUBLIC STATICS, NOT BY COPYING THEM.
## `ReferenceLandingGroundLayout.cumulative_arc_lengths()`, `.position_at_arc()`
## and `.brokenness_at()` are Session 2's answers; `ReferenceLandingBoundaryLayout
## .horizontal_tangent_at_arc()`, `.edge_point()` and `.is_breached()` are
## Session 3's. This file calls all six directly. It does NOT call any
## underscore-prefixed (private) function on either sibling class -- where the
## same small piece of math is needed again (a yaw formula, a weighted pick, a
## deterministic hash) it is reimplemented locally, exactly as
## `boundary_layout.gd` reimplements its own `cell_random()` rather than
## reusing `ground_layout.gd`'s differently-shaped one.
##
## EVERY ONE OF THE NINETEEN PAYLOADS BELOW USES "base" GROUND CONTACT. Unlike
## Sessions 2 and 3, this file has no "surface" or "plant" branch in
## `lay_piece()` at all -- asserted, not merely omitted, so a future payload
## added with a different contact value fails loudly instead of silently
## landing at the wrong height.
##
## THE CAMERA NOTE, AND WHY THE GATE IS NOT THE REFERENCE IMAGE'S TWIN TOWERS.
## The accepted 19 m / 55 deg / 45 deg camera cannot show a horizon or a tall
## structure (Gate 1C report Sec8.1): the top of frame sits 32.5 deg below
## horizontal, so a taller object is pushed FURTHER off the top of the screen,
## never closer to visible. `pillar` (4 m) and `wall_pillar` stay inside the
## band this camera can actually show; nothing here reaches for the reference
## image's rising twin-tower silhouette. The gate reads through convergence,
## flanking mass and lantern density (Session 3's `post_lantern` rhythm,
## Session 5's torches), not height.
##
## THE ARCH IS A LANDMARK, NOT THE GATE OPENING -- MEASURED, NOT ASSUMED, AND
## MATCHING AN EXISTING PROJECT PRECEDENT. `arch.gltf`'s own clear opening is
## documented at 3.000 m (Gate 1B). `build()` computes the actual band width
## at PORTAL from `ReferenceLandingBlueprint.width_at()` -- 9.000 m here,
## because PORTAL's arc length falls past the last WIDTH_CONTROL_POINTS entry
## -- and 3.000 m is narrower than that by a wide margin. Placing the arch
## across the band would mean either shrinking the band (forbidden -- Session 1
## owns that number) or leaving the arch's own side pillars sitting inside the
## walkable width. `riftfall_landing_layout.gd` already answered this exact
## question for the canonical zone: its own arch is placed as "a displaced
## landmark, never the route... well outside the walkable footprint." This
## file makes the same choice for the same reason and says so on screen: the
## actual flanking gate is built from `wall_pillar` (Gate 1C's own name for
## this job is literally "the two piers that face the Watch breach"), planted
## just outside the band edge exactly the way Riftfall Landing's Watch piers
## are; the arch stands nearby as decoration.
##
## THE BROKENNESS GRADIENT DRIVES THE WALL RUN, REUSING THE SAME BIAS SESSION 3
## ALREADY TUNED. `_build_walls()` copies `boundary_layout.gd`'s own
## `effective_broken = clampf(broken * 1.6 + 0.10, 0.0, 1.0)` transform
## verbatim (as a value, not as a shared function) so the wall's damage read
## agrees with the fence's at every arc length rather than drifting from it.
##
## THREE BREACHES, REUSED RATHER THAN RE-AUTHORED. The wall run skips the same
## `ReferenceLandingBoundaryLayout.BREACHES` ranges Session 3 already left open
## in the fence line, via the public `is_breached()` check -- so wall and fence
## fail together, reading as one boundary rather than two independent damage
## rolls. One of the three (the first, nearest MIDPOINT) receives a single
## authored `wall_open_scaffold` instance instead of staying empty: KayKit's
## own role text for that piece is "interrupted repair... the garrison began
## mending the breach and never finished," which only means something placed
## at an actual breach edge, so it is placed once, by hand, rather than folded
## into the general weighted pool.
##
## GATE CONTACT AND WALKABLE-BAND SAFETY ARE STRUCTURAL, NOT CHECKED AFTER THE
## FACT. Every single placement in this file -- wall run, pillar rank, gate
## piers, the arch landmark, the periphery scatter -- goes through
## `ReferenceLandingBoundaryLayout.edge_point(arc, side, offset)` with a
## strictly positive `offset`. Because `edge_point()` always adds `offset` to
## the band's own half-width, nothing this file places can land inside the
## band by construction; `architecture_check.gd`'s exhaustive BAND CHECK exists
## to PROVE that invariant held, not to discover whether it did.
##
## DETERMINISM. Every pool draw, breach dressing roll and periphery yaw comes
## from this file's own `cell_random()`, a pure hash of an integer index, a
## side and a decision-specific salt looked up in `_SALT_TAGS` -- never
## `Time.*`, `randi()`/`randf()`, or engine RNG state. See `boundary_layout.gd`'s
## own DETERMINISM note for why the salt is looked up as a word rather than
## folded in as a raw digit (Godot's `hash()` weights a string's final
## character least, so adjacent bare-digit salts barely perturb the hash).

const FAMILY_DUNGEON: String = "KayKit Dungeon Asset Pack 1.1 FREE"
const FAMILY_HALLOWEEN: String = "KayKit Halloween Bits 1.0 FREE"
const FAMILY_GRAVEYARD: String = "Kenney Graveyard Kit 5.0"

const LEFT: int = -1
const RIGHT: int = 1

## Radial offsets, all measured OUTWARD from the band's own half-width at that
## arc length (see `ReferenceLandingBoundaryLayout.edge_point()`). Ordered by
## distance from the centreline: Roads (0.6, Session 3) < Boundaries (2.0,
## Session 3) < Walls (4.0) < PillarRank (5.4) < Periphery (7.0-13.0).
const WALL_GAP: float = 4.0
const PILLAR_RANK_GAP: float = 5.4
const GATE_PIER_GAP: float = 1.0
const ARCH_LANDMARK_GAP: float = 6.5
const DRESSING_GAP_EXTRA: float = 0.9
const PERIPHERY_MIN_GAP: float = 7.0
const PERIPHERY_MAX_GAP: float = 13.0

## Wall framing starts a little later than Session 3's kerb (which starts at
## 6.0) is not required here -- the rift patch itself stays unwalled, matching
## the reference image, but the corridor's masonry is allowed to begin sooner
## than its kerb since a low kerb reads as "maintained road edge" while a wall
## reads as "the space this happened in", which the image shows right up to
## the fissured ground.
const WALL_START_ARC: float = 4.0
const WALL_END_ARC_MARGIN: float = 5.0

const PILLAR_RANK_START_ARC: float = 10.0
const PILLAR_RANK_SPACING_ARC: float = 20.0

## The arch's own documented clear opening (Gate 1B report; also stated in
## `docs/concepts/reference_landing_recreation/00_overview.md`). A constant,
## not a live measurement, because "clear opening" (the gap between the two
## uprights) is a different quantity from the AABB `ExteriorAssetProbe.measure()`
## returns (the piece's own full outer footprint) and re-deriving it from the
## mesh is out of scope for a draft session; the number is cited from an
## already-measured project record, exactly as `ARCH_CLEAR_OPENING_METERS`'s
## doc comment above states.
const ARCH_CLEAR_OPENING_METERS: float = 3.0
const ARCH_LANDMARK_ARC_OFFSET: float = 5.0

const PERIPHERY_STEP_ARC: float = 6.0
const PERIPHERY_START_ARC: float = 2.0
const PERIPHERY_END_ARC_MARGIN: float = 2.0

## Chance a placed BROKEN-pool wall instance also receives one Kenney Graveyard
## dressing piece just outside it -- see the task brief's "damage dressing on
## wall runs."
const DRESSING_CHANCE: float = 0.16

## The complete, approved set of Session 4 payloads: the 14 Architecture pieces
## from `approved_environment_palette.gd`, plus `wall`, `wall_pillar` and
## `arch` from the Gate 1C allowlist, plus two Kenney Graveyard dressing
## pieces. Do not add, remove, substitute, or reference any other asset path.
const PAYLOADS: Array[Dictionary] = [
	{"key": "pillar", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/pillar.gltf",
		"role": "Intact upright; ranks the near-gate approach, degrading to column stumps toward SPAWN."},
	{"key": "stairs_modular_center", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/stairs_modular_center.gltf",
		"role": "Declared and measured for cross-check completeness; unused this session -- see class doc comment note below."},
	{"key": "wall_Tsplit", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_Tsplit.gltf",
		"role": "Rare accent in the intact pool near the gate; reads as an internal wall meeting the curtain."},
	{"key": "wall_arched", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_arched.gltf",
		"role": "Declared and measured for cross-check completeness; unused this session -- see class doc comment note below."},
	{"key": "wall_broken", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_broken.gltf",
		"role": "Dominant member of the broken wall pool; also the far-back periphery ruin silhouette."},
	{"key": "wall_cracked", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_cracked.gltf",
		"role": "Middle term of the damage gradient, in both the broken and intact wall pools."},
	{"key": "wall_endcap", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_endcap.gltf",
		"role": "Terminates the ordinary wall run honestly where the gate structure takes over."},
	{"key": "wall_half", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_half.gltf",
		"role": "Closes a wall run whose leftover length is a clean half module."},
	{"key": "wall_half_endcap_sloped", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_half_endcap_sloped.gltf",
		"role": "The last surviving stretch of wall before a badly damaged section; broken pool."},
	{"key": "wall_open_scaffold", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_open_scaffold.gltf",
		"role": "One authored instance at the first breach: interrupted repair, never finished."},
	{"key": "wall_sloped", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_sloped.gltf",
		"role": "Declared and measured for cross-check completeness; unused this session -- see class doc comment note below."},
	{"key": "rubble_half", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/rubble_half.gltf",
		"role": "4 m collapse mass; substitutes for a wall module in the broken pool and in the periphery scatter."},
	{"key": "rubble_large", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/rubble_large.gltf",
		"role": "8.129 m collapse; a rarer, larger interruption in the broken wall pool."},
	{"key": "column", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/column.gltf",
		"role": "Sheared-off pillar stump; the broken half of the pillar rank, and a periphery silhouette piece."},
	{"key": "wall", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall.gltf",
		"role": "Gate 1C allowlist. Plain 4 m intact curtain; the dominant member of the intact wall pool."},
	{"key": "wall_pillar", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_pillar.gltf",
		"role": "Gate 1C allowlist. The two piers that flank PORTAL, exactly as Riftfall Landing's own Watch piers do."},
	{"key": "arch", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/arch.gltf",
		"role": "Gate 1C allowlist. A displaced landmark beside PORTAL, never the route -- see class doc comment."},
	{"key": "stone-wall-damaged", "family": FAMILY_GRAVEYARD, "contact": "base",
		"path": "res://assets/third_party/kenney/graveyard/stone-wall-damaged.glb",
		"role": "Damage dressing beside broken wall instances, and a periphery piece; blocks nothing, carves nothing."},
	{"key": "stone-wall-column", "family": FAMILY_GRAVEYARD, "contact": "base",
		"path": "res://assets/third_party/kenney/graveyard/stone-wall-column.glb",
		"role": "The ends of damaged dressing runs, and a periphery piece; blocks nothing, carves nothing."},
]

## WHY stairs_modular_center, wall_arched AND wall_sloped ARE DECLARED BUT
## NEVER PLACED. `stairs_modular_center`'s own role text describes a 4.000 m
## RISE -- a full wall-module step, meant for a change of floor level, not for
## `ReferenceLandingBlueprint`'s gentle 0.9 m climb spread over the route's
## second half. `wall_sloped` exists for exactly that gentle-climb case, but
## the climb here (0.9 m over roughly 75 m) is under 1.5%, well inside what an
## ordinary rigid wall module already tolerates without a visible seam --
## reaching for it would be authoring a fix for a problem the numbers say does
## not exist. `wall_arched` is the dungeon family's own arched aperture and
## shares `arch.gltf`'s problem: a module-scale piece cannot honestly span a
## 9 m band, so it would need the exact same "landmark, not opening" treatment
## the class doc comment already gives `arch` -- doing that twice would dilute
## rather than reinforce the gate, so only the Halloween `arch` (the piece the
## task brief specifically names) gets the landmark role, and `wall_arched`
## stays declared-only, the same honest omission `boundary_layout.gd` records
## for `plaque`. All three are still measured by `build()`'s pre-pass and
## still validated against `architecture_check.gd`'s own `APPROVED_KEYS`
## list, exactly like every placed key.

## Weighted pools for the wall run, keyed to `ReferenceLandingGroundLayout
## .brokenness_at()` via the same bias `boundary_layout.gd` already uses for
## its fence line (see class doc comment). Iteration order is part of the
## deterministic contract, as in every sibling file.
const WALL_INTACT_WEIGHTS: Dictionary = {
	"wall": 0.55,
	"wall_Tsplit": 0.15,
	"wall_cracked": 0.20,
	"wall_broken": 0.10,
}
const WALL_BROKEN_WEIGHTS: Dictionary = {
	"wall_broken": 0.32,
	"wall_cracked": 0.22,
	"rubble_half": 0.20,
	"wall_half_endcap_sloped": 0.14,
	"rubble_large": 0.12,
}

const DRESSING_KEYS: PackedStringArray = ["stone-wall-damaged", "stone-wall-column"]

## Sparser, unattended background pool -- see class doc comment and the task
## brief's "the point is that the world doesn't visibly end at the fence line,
## not that every piece back there needs individual attention." Deliberately
## excludes every payload already doing structural work in the wall run or
## pillar rank (`pillar`, `wall`, `wall_Tsplit`, `wall_cracked`,
## `wall_half_endcap_sloped`, `wall_endcap`, `wall_open_scaffold`), so the
## periphery reads as a distinct, rougher layer rather than a continuation of
## the authored wall.
const PERIPHERY_WEIGHTS: Dictionary = {
	"rubble_half": 0.28,
	"column": 0.22,
	"stone-wall-damaged": 0.20,
	"wall_broken": 0.16,
	"stone-wall-column": 0.14,
}

## Keys whose measured long axis is worth aligning to the local tangent even
## in the periphery scatter (they read as built or semi-structured); anything
## else in `PERIPHERY_WEIGHTS` gets an arbitrary deterministic yaw, the same
## treatment `boundary_layout.gd` and `ground_layout.gd` both give natural
## rock/rubble pieces.
const PERIPHERY_ALIGNED_KEYS: PackedStringArray = ["column"]

const _SALT_TAGS: Dictionary = {
	1: "wall_broken_bias",
	2: "wall_pool_pick",
	3: "wall_module_leftover",
	4: "dressing_roll",
	5: "dressing_pick",
	6: "pillar_pick",
	7: "periphery_pick",
	8: "periphery_offset",
	9: "periphery_yaw",
}

var _aabb_cache: Dictionary = {}
var _module_cache: Dictionary = {}
var _long_axis_cache: Dictionary = {}
var _instance_index: int = 0


static func payload(key: String) -> Dictionary:
	for record: Dictionary in PAYLOADS:
		if String(record["key"]) == key:
			return record
	return {}


## Deterministic pseudo-random value in `[0.0, 1.0)` -- see the class doc
## comment's DETERMINISM section.
static func cell_random(index: int, side: int, salt: int) -> float:
	assert(_SALT_TAGS.has(salt), "architecture_layout: salt %d has no _SALT_TAGS entry" % salt)
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


## Same Y-axis rotation convention every sibling file in this concept uses
## (see `game/assets/third_party/kaykit/SOURCE_AND_LICENSE.md` Sec3.6 and
## `boundary_layout.gd`'s own doc comment): local +Z maps to world (0, 0, 1)
## at yaw 0, so `atan2(D.x, D.z)` aligns a local-Z-long piece with direction D;
## a local-X-long piece uses the mirror-image `atan2(-D.z, D.x)`.
static func _yaw_for_tangent(tangent: Vector2, long_axis: String) -> float:
	if long_axis == "z":
		return atan2(tangent.x, tangent.y)
	return atan2(-tangent.y, tangent.x)


## Measures payload `key` exactly once. All nineteen payloads use "base"
## contact -- asserted, not merely assumed, per the class doc comment.
func _ensure_measured(key: String, record: Dictionary) -> void:
	if _aabb_cache.has(key):
		return
	assert(String(record["contact"]) == "base",
		"architecture_layout: %s has contact '%s', expected 'base' -- lay_piece() has no other branch" % [key, record["contact"]])
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
	probe_node.free()


## Instantiates payload `key` under `parent` at world point `(x, ground_y, z)`
## with the given `yaw`, laying it by its measured, yaw-rotated AABB base and
## horizontal centre -- the only ground-contact rule any Session 4 payload
## uses.
func lay_piece(
	key: String, record: Dictionary, x: float, z: float, ground_y: float, yaw: float,
	parent: Node3D
) -> Node3D:
	_ensure_measured(key, record)
	var scene: PackedScene = load(String(record["path"])) as PackedScene
	assert(scene != null, "Reference Landing architecture: %s failed to load" % record["path"])
	var node: Node3D = scene.instantiate() as Node3D
	node.name = "%s_%d" % [key.replace("-", "_"), _instance_index]
	_instance_index += 1
	parent.add_child(node)
	node.rotation = Vector3(0.0, yaw, 0.0)

	var box: AABB = _aabb_cache[key]
	var rotated: AABB = (
		Transform3D(Basis.from_euler(Vector3(0.0, yaw, 0.0)), Vector3.ZERO) * box
	)
	node.position = Vector3(
		x - rotated.get_center().x, ground_y - rotated.position.y, z - rotated.get_center().z
	)
	return node


func _record_placed(placed: Array, counts: Dictionary, key: String, pos: Vector3) -> void:
	counts[key] = int(counts.get(key, 0)) + 1
	placed.append({"key": key, "x": pos.x, "z": pos.z})


## The damaged curtain-wall run, one per side, plus its occasional Kenney
## dressing accents. See class doc comment for the brokenness bias and the
## breach-skip mechanism.
func _build_walls(parent: Node3D) -> Dictionary:
	var group: Node3D = Node3D.new()
	group.name = "Walls"
	parent.add_child(group)

	var lengths: Array[float] = ReferenceLandingGroundLayout.cumulative_arc_lengths()
	var total: float = lengths[lengths.size() - 1]
	var wall_end: float = total - WALL_END_ARC_MARGIN

	var counts: Dictionary = {}
	var placed: Array = []
	var breach_skips: int = 0
	var dressing_count: int = 0

	for side: int in [LEFT, RIGHT]:
		var cursor: float = WALL_START_ARC
		while cursor < wall_end:
			var broken: float = ReferenceLandingGroundLayout.brokenness_at(cursor)
			var index: int = int(round(cursor * 10.0))
			# Same effective-broken bias `boundary_layout.gd` derived for its
			# own fence line -- see class doc comment. Kept as a literal value
			# rather than a shared call so this file has no dependency on a
			# private boundary_layout.gd helper.
			var effective_broken: float = clampf(broken * 1.6 + 0.10, 0.0, 1.0)
			var pool: Dictionary = (
				WALL_BROKEN_WEIGHTS if cell_random(index, side, 1) < effective_broken
				else WALL_INTACT_WEIGHTS
			)
			var key: String = weighted_pick(pool, cell_random(index, side, 2))
			var record: Dictionary = payload(key)
			_ensure_measured(key, record)
			var module: float = maxf(float(_module_cache[key]), 1.0)
			var placed_arc: float = cursor + module * 0.5

			if placed_arc <= wall_end:
				if ReferenceLandingBoundaryLayout.is_breached(placed_arc, side):
					breach_skips += 1
				else:
					var tangent: Vector2 = ReferenceLandingBoundaryLayout.horizontal_tangent_at_arc(placed_arc)
					var pos: Vector3 = ReferenceLandingBoundaryLayout.edge_point(placed_arc, side, WALL_GAP)
					var yaw: float = _yaw_for_tangent(tangent, String(_long_axis_cache[key]))
					lay_piece(key, record, pos.x, pos.z, pos.y, yaw, group)
					_record_placed(placed, counts, key, pos)

					var is_broken_member: bool = WALL_BROKEN_WEIGHTS.has(key)
					if is_broken_member and cell_random(index, side, 4) < DRESSING_CHANCE:
						var dressing_key: String = (
							DRESSING_KEYS[0] if cell_random(index, side, 5) < 0.5 else DRESSING_KEYS[1]
						)
						var dressing_record: Dictionary = payload(dressing_key)
						_ensure_measured(dressing_key, dressing_record)
						var dpos: Vector3 = ReferenceLandingBoundaryLayout.edge_point(
							placed_arc, side, WALL_GAP + DRESSING_GAP_EXTRA
						)
						var dyaw: float = _yaw_for_tangent(tangent, String(_long_axis_cache[dressing_key]))
						lay_piece(dressing_key, dressing_record, dpos.x, dpos.z, dpos.y, dyaw, group)
						_record_placed(placed, counts, dressing_key, dpos)
						dressing_count += 1

			cursor += module

		# Cap the ordinary run honestly where the gate structure takes over --
		# skipped if the cap point itself falls in a breach, matching the
		# "damage, not maintenance" read.
		if wall_end > WALL_START_ARC and not ReferenceLandingBoundaryLayout.is_breached(wall_end, side):
			var cap_record: Dictionary = payload("wall_endcap")
			_ensure_measured("wall_endcap", cap_record)
			var cap_tangent: Vector2 = ReferenceLandingBoundaryLayout.horizontal_tangent_at_arc(wall_end)
			var cap_pos: Vector3 = ReferenceLandingBoundaryLayout.edge_point(wall_end, side, WALL_GAP)
			var cap_yaw: float = _yaw_for_tangent(cap_tangent, String(_long_axis_cache["wall_endcap"]))
			lay_piece("wall_endcap", cap_record, cap_pos.x, cap_pos.z, cap_pos.y, cap_yaw, group)
			_record_placed(placed, counts, "wall_endcap", cap_pos)

	return {
		"group": group, "counts": counts, "placed": placed,
		"breach_skips": breach_skips, "dressing_count": dressing_count,
	}


## One authored `wall_open_scaffold` at the first breach -- see class doc
## comment. Placed at that breach's own midpoint arc, same `WALL_GAP` offset
## the ordinary run uses, so it reads as part of the same wall rather than as
## a stray prop.
func _build_breach_accent(parent: Node3D) -> Dictionary:
	var breach: Dictionary = ReferenceLandingBoundaryLayout.BREACHES[0]
	var side: int = int(breach["side"])
	var arc: float = (float(breach["arc_from"]) + float(breach["arc_to"])) * 0.5

	var key: String = "wall_open_scaffold"
	var record: Dictionary = payload(key)
	_ensure_measured(key, record)
	var tangent: Vector2 = ReferenceLandingBoundaryLayout.horizontal_tangent_at_arc(arc)
	var pos: Vector3 = ReferenceLandingBoundaryLayout.edge_point(arc, side, WALL_GAP)
	var yaw: float = _yaw_for_tangent(tangent, String(_long_axis_cache[key]))
	lay_piece(key, record, pos.x, pos.z, pos.y, yaw, parent)

	var counts: Dictionary = {key: 1}
	var placed: Array = [{"key": key, "x": pos.x, "z": pos.z}]
	return {"counts": counts, "placed": placed}


## The pillar rank: `pillar` where the route is largely intact, `column`
## (a stump) where it is not -- see `pillar`'s own role text in
## `approved_environment_palette.gd`, quoted in the class doc comment.
func _build_pillar_rank(parent: Node3D) -> Dictionary:
	var group: Node3D = Node3D.new()
	group.name = "PillarRank"
	parent.add_child(group)

	var lengths: Array[float] = ReferenceLandingGroundLayout.cumulative_arc_lengths()
	var total: float = lengths[lengths.size() - 1]
	var rank_end: float = total - WALL_END_ARC_MARGIN

	var counts: Dictionary = {}
	var placed: Array = []

	var arc: float = PILLAR_RANK_START_ARC
	while arc <= rank_end:
		for side: int in [LEFT, RIGHT]:
			if ReferenceLandingBoundaryLayout.is_breached(arc, side):
				continue
			var broken: float = ReferenceLandingGroundLayout.brokenness_at(arc)
			var index: int = int(round(arc * 10.0))
			var key: String = "column" if broken >= 0.35 else "pillar"
			var record: Dictionary = payload(key)
			_ensure_measured(key, record)
			var pos: Vector3 = ReferenceLandingBoundaryLayout.edge_point(arc, side, PILLAR_RANK_GAP)
			var yaw: float
			if key == "pillar":
				# Intact and upright: aligned to the road, like a built thing.
				var tangent: Vector2 = ReferenceLandingBoundaryLayout.horizontal_tangent_at_arc(arc)
				yaw = _yaw_for_tangent(tangent, String(_long_axis_cache[key]))
			else:
				# A sheared stump was knocked out of alignment, not built
				# that way -- arbitrary yaw, the same treatment rocks and
				# rubble get elsewhere in this concept.
				yaw = cell_random(index, side, 6) * TAU
			lay_piece(key, record, pos.x, pos.z, pos.y, yaw, group)
			_record_placed(placed, counts, key, pos)
		arc += PILLAR_RANK_SPACING_ARC

	return {"counts": counts, "placed": placed}


## PORTAL's gate structure: two `wall_pillar` piers flanking the band exactly
## the way Riftfall Landing's own Watch piers flank its breach, plus one
## `arch` landmark kept outside the footprint. See class doc comment for why
## the arch cannot honestly be the opening.
func _build_gate(parent: Node3D) -> Dictionary:
	var group: Node3D = Node3D.new()
	group.name = "Gate"
	parent.add_child(group)

	var lengths: Array[float] = ReferenceLandingGroundLayout.cumulative_arc_lengths()
	var gate_arc: float = lengths[lengths.size() - 1]
	var half_width: float = ReferenceLandingBlueprint.width_at(gate_arc) * 0.5
	var opening_width: float = half_width * 2.0
	var arch_fits: bool = ARCH_CLEAR_OPENING_METERS >= opening_width

	var counts: Dictionary = {}
	var placed: Array = []
	var pier_positions: Dictionary = {}

	var pier_record: Dictionary = payload("wall_pillar")
	_ensure_measured("wall_pillar", pier_record)
	var gate_tangent: Vector2 = ReferenceLandingBoundaryLayout.horizontal_tangent_at_arc(gate_arc)
	var pier_yaw: float = _yaw_for_tangent(gate_tangent, String(_long_axis_cache["wall_pillar"]))
	for side: int in [LEFT, RIGHT]:
		var pos: Vector3 = ReferenceLandingBoundaryLayout.edge_point(gate_arc, side, GATE_PIER_GAP)
		lay_piece("wall_pillar", pier_record, pos.x, pos.z, pos.y, pier_yaw, group)
		_record_placed(placed, counts, "wall_pillar", pos)
		pier_positions[side] = pos

	# The arch landmark: turned ACROSS the road (its long axis perpendicular
	# to the direction of travel, matching riftfall_landing_layout.gd's own
	# device for the same piece) and set well outside the band on one side,
	# a few metres before PORTAL so it reads as something passed on the way
	# to the gate rather than sitting on top of the piers.
	var arch_record: Dictionary = payload("arch")
	_ensure_measured("arch", arch_record)
	var arch_arc: float = maxf(gate_arc - ARCH_LANDMARK_ARC_OFFSET, 0.0)
	var arch_tangent: Vector2 = ReferenceLandingBoundaryLayout.horizontal_tangent_at_arc(arch_arc)
	var perpendicular: Vector2 = Vector2(-arch_tangent.y, arch_tangent.x)
	var arch_pos: Vector3 = ReferenceLandingBoundaryLayout.edge_point(arch_arc, RIGHT, ARCH_LANDMARK_GAP)
	var arch_yaw: float = _yaw_for_tangent(perpendicular, String(_long_axis_cache["arch"]))
	lay_piece("arch", arch_record, arch_pos.x, arch_pos.z, arch_pos.y, arch_yaw, group)
	_record_placed(placed, counts, "arch", arch_pos)

	return {
		"counts": counts,
		"placed": placed,
		"gate_arc": gate_arc,
		"half_width": half_width,
		"opening_width": opening_width,
		"arch_clear_opening": ARCH_CLEAR_OPENING_METERS,
		"arch_fits_as_opening": arch_fits,
		"pier_left": pier_positions[LEFT],
		"pier_right": pier_positions[RIGHT],
	}


## Sparse, unattended background scatter beyond everything else -- see class
## doc comment. Each instance's own outward offset is itself randomised within
## [PERIPHERY_MIN_GAP, PERIPHERY_MAX_GAP] so the periphery reads as an uneven
## field rather than a fourth ruler-straight line.
func _build_periphery(parent: Node3D) -> Dictionary:
	var group: Node3D = Node3D.new()
	group.name = "Periphery"
	parent.add_child(group)

	var lengths: Array[float] = ReferenceLandingGroundLayout.cumulative_arc_lengths()
	var total: float = lengths[lengths.size() - 1]
	var end: float = total - PERIPHERY_END_ARC_MARGIN

	var counts: Dictionary = {}
	var placed: Array = []

	for side: int in [LEFT, RIGHT]:
		var arc: float = PERIPHERY_START_ARC
		var index: int = 0
		while arc <= end:
			var key: String = weighted_pick(PERIPHERY_WEIGHTS, cell_random(index, side, 7))
			var record: Dictionary = payload(key)
			_ensure_measured(key, record)
			var extra: float = lerpf(
				PERIPHERY_MIN_GAP, PERIPHERY_MAX_GAP, cell_random(index, side, 8)
			)
			var pos: Vector3 = ReferenceLandingBoundaryLayout.edge_point(arc, side, extra)
			var yaw: float
			if PERIPHERY_ALIGNED_KEYS.has(key):
				var tangent: Vector2 = ReferenceLandingBoundaryLayout.horizontal_tangent_at_arc(arc)
				yaw = _yaw_for_tangent(tangent, String(_long_axis_cache[key]))
			else:
				yaw = cell_random(index, side, 9) * TAU
			lay_piece(key, record, pos.x, pos.z, pos.y, yaw, group)
			_record_placed(placed, counts, key, pos)

			index += 1
			arc += PERIPHERY_STEP_ARC

	return {"counts": counts, "placed": placed}


static func _merge_counts(into: Dictionary, from: Dictionary) -> void:
	for key: String in from.keys():
		into[key] = int(into.get(key, 0)) + int(from[key])


## Main entry point. Creates "Walls", "PillarRank", "Gate" and "Periphery"
## `Node3D` groups under `parent`. Returns a `Dictionary` reporting exactly
## what it built, including the PORTAL gate-opening finding.
func build(parent: Node3D) -> Dictionary:
	_aabb_cache.clear()
	_module_cache.clear()
	_long_axis_cache.clear()
	_instance_index = 0

	# Cross-measure every registered payload once, regardless of whether this
	# particular deterministic run happens to use it -- mirrors
	# ground_layout.gd and boundary_layout.gd.
	for record: Dictionary in PAYLOADS:
		_ensure_measured(String(record["key"]), record)

	var walls: Dictionary = _build_walls(parent)
	var breach_accent: Dictionary = _build_breach_accent(walls["group"])
	var pillars: Dictionary = _build_pillar_rank(parent)
	var gate: Dictionary = _build_gate(parent)
	var periphery: Dictionary = _build_periphery(parent)

	var all_counts: Dictionary = {}
	_merge_counts(all_counts, walls["counts"])
	_merge_counts(all_counts, breach_accent["counts"])
	_merge_counts(all_counts, pillars["counts"])
	_merge_counts(all_counts, gate["counts"])
	_merge_counts(all_counts, periphery["counts"])

	var all_placed: Array = []
	all_placed.append_array(walls["placed"])
	all_placed.append_array(breach_accent["placed"])
	all_placed.append_array(pillars["placed"])
	all_placed.append_array(gate["placed"])
	all_placed.append_array(periphery["placed"])

	var total_instances: int = 0
	for key: String in all_counts.keys():
		total_instances += int(all_counts[key])

	return {
		"counts": all_counts,
		"placed": all_placed,
		"total_instances": total_instances,
		"wall_counts": walls["counts"],
		"pillar_counts": pillars["counts"],
		"gate_counts": gate["counts"],
		"periphery_counts": periphery["counts"],
		"breach_skips": walls["breach_skips"],
		"dressing_count": walls["dressing_count"],
		"gate_arc": gate["gate_arc"],
		"gate_half_width": gate["half_width"],
		"gate_opening_width": gate["opening_width"],
		"arch_clear_opening": gate["arch_clear_opening"],
		"arch_fits_as_opening": gate["arch_fits_as_opening"],
		"pier_left": gate["pier_left"],
		"pier_right": gate["pier_right"],
	}
