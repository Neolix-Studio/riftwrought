class_name ReferenceLandingPropsLayout
extends RefCounted
## Reference Landing Recreation -- Session 5: props and atmosphere (NON-CANONICAL).
##
## Small-scale dressing: two dead-tree clusters (near SPAWN and at the mid-
## corridor bend), a `lantern_standing` rhythm interleaved with Session 3's
## `post_lantern` posts, two `banner_shield_red` instances actually mounted on
## real Session 4 wall faces, and a sparse hand-placed clutter scatter (crates,
## barrels, the shrine, debris, and the two sword/shield pieces laid on the
## ground rather than mounted). See
## docs/concepts/reference_landing_recreation/05_props_and_atmosphere.md.
##
## BUILDS ON SESSIONS 1-4 BY CALLING THEIR PUBLIC STATICS, NOT BY COPYING THEM.
## `ReferenceLandingBlueprint`, `ReferenceLandingGroundLayout` and
## `ReferenceLandingBoundaryLayout`'s arc/tangent/band/breach functions are
## reused directly. The one exception is deliberate and documented below:
## finding an actual wall face to mount a banner on requires the REAL Session 4
## output, so `_find_wall_mount_targets()` instantiates
## `ReferenceLandingArchitectureLayout` and calls its public `build()` on a
## scratch (never-in-the-real-tree) parent, exactly the way `architecture_check
## .gd` already does to inspect that session's own results, then discards the
## scratch parent. This file never re-derives which key a given wall arc
## resolves to; it reads it from the real thing.
##
## EVERY HAND-AUTHORED LIST HERE IS SMALL ON PURPOSE. The task brief is
## explicit that "the Kenney Graveyard layer everywhere else in this project is
## deliberately 3 pieces used sparingly, not a themed clutter pass" -- so
## `DEAD_TREE_CLUSTERS` and `CLUTTER_SCATTER` are fixed, small, authored arrays
## (the same idiom `boundary_layout.gd`'s `SPAWN_ACCENTS` already uses), not
## weighted-pool loops walking the whole route. `LANTERN_FILL_ARC_STEP` is the
## one genuinely generic loop in this file, because a light-pool RHYTHM is
## exactly the kind of thing that should be regular rather than hand-typed.
##
## WHY torch_mounted IS DECLARED BUT NEVER PLACED. Its own role text in
## `approved_environment_palette.gd` calls it "the only wall-mounted light
## bracket" and, in the same breath, says the unlit brackets are "the cheapest
## statement that this place was tended and no longer is" -- i.e. it is
## authored to be UNLIT and wall-mounted, not a free-standing lit prop. The
## task brief's "lit torches/lanterns" rhythm is therefore built entirely from
## `lantern_standing` (a genuinely free-standing, genuinely lit fixture, per
## its own Riftfall Landing role text: "the only warm light"). Mounting is
## explicitly budgeted to "a handful" (task brief) and that handful is spent on
## the two required banners; laying `torch_mounted` flat on the ground would
## misrepresent a wall bracket as a floor object, so it is measured and
## cross-checked with the other thirteen and placed zero times -- the same
## honest omission `architecture_layout.gd` already records for
## `stairs_modular_center`, `wall_arched` and `wall_sloped`.
##
## WHY sword_shield AND sword_shield_broken ARE GROUND-LAID, NOT MOUNTED. Both
## are "authored to hang on masonry", but both role sentences also name a
## legitimate GROUND reading: sword_shield_broken "planted in the ground ...
## marks where a defender died", and sword_shield's own sentence asks for one
## "near the arrival end so the broken trophies further up the route read as
## damage rather than how the garrison always looked" -- arrival meaning
## SPAWN, where the player actually arrives. Placing both at "base" contact,
## unrotated beyond an arbitrary yaw, uses the ground reading the palette
## itself offers and keeps this session's wall-mount budget on the two
## banners the task brief actually requires.
##
## THE WALL-MOUNT GEOMETRY, DERIVED RATHER THAN ASSUMED. A banner "laid flat
## here" (base contact) sits with its thin measured AABB axis (local Y)
## vertical and its footprint (local X/Z) horizontal -- ordinary "base"
## placement. Mounting on a wall means rotating so that thin axis becomes
## HORIZONTAL, facing away from the wall into the corridor, while the
## banner's long (width) axis stays horizontal, aligned along the wall.
## `_mount_basis()` builds this directly from three target directions instead
## of composing Euler angles:
##   long axis (tangent-aligned, as every sibling file's `_yaw_for_tangent`
##     already does for a flat piece) -> the wall's own tangent direction;
##   thin axis (was vertical, now the facing normal) -> `inward`, i.e. away
##     from the wall, back toward the centreline, so a player walking the
##     corridor sees the banner's front;
##   the third (short footprint) axis is fixed as the CROSS PRODUCT of the
##     other two, which is what guarantees a proper rotation (determinant
##     +1, no mirroring) rather than a reflection -- see the derivation this
##     class doc comment omits for space; verified by hand before writing this
##     file that `y.cross(z)` (long-axis-Z case) or `x.cross(y)` (long-axis-X
##     case) always lands the third axis on pure world +Y or -Y, i.e. the
##     banner hangs perfectly upright with no lean, for either wall side.
## The banner's own measured local centre (`ExteriorAssetProbe.measure()`'s
## `centre`/`base_offset`) is then rotated by that basis and subtracted from
## the target mount point, the same "target minus rotated centre" idiom every
## sibling `lay_piece()` already uses for a plain Y-yaw -- it generalizes
## without change because a pure rotation of a symmetric box is always
## centred at the rotated centre, regardless of which axes it permutes.
##
## GATE CONTACT AND WALKABLE-BAND SAFETY ARE STRUCTURAL FOR EVERY GROUP EXCEPT
## THE TWO WALL MOUNTS. Dead trees, the lantern fill and the clutter scatter
## all go through `ReferenceLandingBoundaryLayout.edge_point(arc, side,
## offset)` with a strictly positive offset, so nothing in those three groups
## can land inside the band by construction, exactly as every sibling file
## already establishes. The two wall mounts do not use `edge_point()` --
## they are pulled INWARD from an already-placed Session 4 wall, which itself
## sits `WALL_GAP` (4.0 m) beyond the band edge -- but the inward pull is at
## most a metre or so (half a wall's thickness plus half a banner's
## thickness), leaving several metres of margin. `props_check.gd`'s BAND
## CHECK is still exhaustive over every placed instance in this file,
## including both mounts, rather than trusting that margin unchecked.
##
## DETERMINISM. The two generic passes (`_build_lantern_fill()` and every
## arbitrary yaw below) use `cell_random()`, a pure hash of an integer index,
## a side and a decision-specific salt -- never `Time.*`, `randi()`/`randf()`,
## or engine RNG state -- matching every sibling file in this concept.

const FAMILY_DUNGEON: String = "KayKit Dungeon Asset Pack 1.1 FREE"
const FAMILY_FOREST: String = "KayKit Forest Nature Pack 1.0 FREE"
const FAMILY_HALLOWEEN: String = "KayKit Halloween Bits 1.0 FREE"
const FAMILY_GRAVEYARD: String = "Kenney Graveyard Kit 5.0"

const LEFT: int = -1
const RIGHT: int = 1

## The complete, approved set of Session 5 payloads: the 9 Props pieces from
## `approved_environment_palette.gd`, plus 5 more from the Gate 1C allowlist.
## Do not add, remove, substitute, or reference any other asset path.
const PAYLOADS: Array[Dictionary] = [
	{"key": "banner_shield_red", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/banner_shield_red.gltf",
		"role": "The only object naming whose garrison this was; mounted on a real Session 4 wall face, near SPAWN and near PORTAL."},
	{"key": "tree_dead_small", "family": FAMILY_HALLOWEEN, "contact": "plant",
		"path": "res://assets/third_party/kaykit/halloween/tree_dead_small.gltf",
		"role": "Low outer member of a dead-tree cluster."},
	{"key": "shrine", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/shrine.gltf",
		"role": "One undecorated 2.400 m stone marker, mid-route, a punctuation point between lantern posts."},
	{"key": "barrel_large", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/barrel_large.gltf",
		"role": "Lone supply cylinder; anchor of an abandoned stores position."},
	{"key": "sword_shield_broken", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/sword_shield_broken.gltf",
		"role": "Ground-laid, not mounted this session -- marks where a defender died. See class doc comment."},
	{"key": "sword_shield", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/sword_shield.gltf",
		"role": "Ground-laid near SPAWN, not mounted this session, so the broken trophy further up reads as damage. See class doc comment."},
	{"key": "box_large", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/box_large.gltf",
		"role": "1.5 m crate; an ingredient, any arrangement and rotation per its own role text."},
	{"key": "torch_mounted", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/torch_mounted.gltf",
		"role": "Measured and cross-checked for completeness; unused this session -- see class doc comment."},
	{"key": "box_small", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/box_small.gltf",
		"role": "Second crate size step; tops a pile or scatters singly."},
	{"key": "Tree_Bare_1_C_Color1", "family": FAMILY_FOREST, "contact": "plant",
		"path": "res://assets/third_party/kaykit/forest/Tree_Bare_1_C_Color1.gltf",
		"role": "Gate 1C allowlist. Sparse bare-tree framing member."},
	{"key": "Tree_Bare_2_C_Color1", "family": FAMILY_FOREST, "contact": "plant",
		"path": "res://assets/third_party/kaykit/forest/Tree_Bare_2_C_Color1.gltf",
		"role": "Gate 1C allowlist. Taller bare-tree framing member."},
	{"key": "tree_dead_large", "family": FAMILY_HALLOWEEN, "contact": "plant",
		"path": "res://assets/third_party/kaykit/halloween/tree_dead_large.gltf",
		"role": "Gate 1C allowlist. Dead tree framing the road."},
	{"key": "lantern_standing", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/lantern_standing.gltf",
		"role": "Gate 1C allowlist. Standalone lit lantern; the interleaved light-pool fill between post_lantern posts."},
	{"key": "debris", "family": FAMILY_GRAVEYARD, "contact": "base",
		"path": "res://assets/third_party/kenney/graveyard/debris.glb",
		"role": "Gate 1C allowlist. Loose ground clutter; a solid pile, not a surface."},
]

## Auxiliary payloads measured for the wall-mount calculation only. These are
## Session 4's own assets, not Session 5's -- they are never placed by this
## file and are not part of `PAYLOADS` or its ID CHECK.
##
## THREE KEYS, NOT JUST "wall". `wall_cracked` is a member of BOTH
## `WALL_INTACT_WEIGHTS` (0.20) and `WALL_BROKEN_WEIGHTS` (0.22) in
## `architecture_layout.gd` -- a standing wall segment with damage texture,
## structurally distinct from an actual collapse form (`wall_broken`,
## `rubble_half`, `rubble_large`, `wall_half_endcap_sloped`), which cannot
## hold a mounted banner at all. Restricting the search to "wall" and
## "wall_Tsplit" alone was tried first and measured: because
## `_build_walls()`'s `effective_broken` bias keeps the broken pool dominant
## for nearly the whole route (see `ground_layout.gd`'s own
## `brokenness_at()`), the nearest "wall"/"wall_Tsplit" instance to SPAWN
## turned out to be past arc 90 of a ~146 m route -- past BEND, not "near
## SPAWN" by any reading. `wall_cracked` appears in both pools throughout the
## route, so including it as a legitimate standing-wall mount surface is what
## actually produces a SPAWN-side candidate worth the name, and "a faded
## banner on a cracked wall" is no less honest a picture than one on a
## pristine wall.
const _WALL_KEYS: PackedStringArray = ["wall", "wall_Tsplit", "wall_cracked"]
const _WALL_PATHS: Dictionary = {
	"wall": "res://assets/third_party/kaykit/dungeon/wall.gltf",
	"wall_Tsplit": "res://assets/third_party/kaykit/dungeon/wall_Tsplit.gltf",
	"wall_cracked": "res://assets/third_party/kaykit/dungeon/wall_cracked.gltf",
}

## Small air gap between a mounted piece's back face and the wall face, and
## between a "surface" piece and the ground beneath it elsewhere in this
## concept -- reused at the same value on purpose (see `ground_layout.gd`'s
## own `SURFACE_LIFT` doc comment: flush means flush plus this, or the two
## coplanar faces z-fight).
const MOUNT_LIFT: float = 0.008

## Banner vertical placement: its own measured centre sits this fraction of
## the wall's height above the wall's base, so the banner's top edge reads as
## hung from near the top of the wall.
const MOUNT_HEIGHT_FRACTION: float = 0.86

## Two authored dead-tree clusters: "near SPAWN" (arc 9-23, past the unwalled
## rift patch and the point Sessions 3/4 start framing the corridor) and "at
## the mid-corridor bend" (arc 96-117, straddling BEND at arc ~111.34),
## matching the task brief. A fixed, small, hand-authored list -- the same
## idiom `boundary_layout.gd`'s `SPAWN_ACCENTS` uses -- mixing the three
## "plant"-contact tree keys this session owns, deliberately not a weighted
## pool walking the whole route.
const DEAD_TREE_CLUSTERS: Array[Dictionary] = [
	{"key": "Tree_Bare_2_C_Color1", "arc": 9.0, "side": LEFT, "offset": 3.4},
	{"key": "Tree_Bare_1_C_Color1", "arc": 11.5, "side": RIGHT, "offset": 3.0},
	{"key": "tree_dead_large", "arc": 14.0, "side": LEFT, "offset": 4.6},
	{"key": "tree_dead_small", "arc": 15.5, "side": LEFT, "offset": 2.6},
	{"key": "Tree_Bare_1_C_Color1", "arc": 18.0, "side": RIGHT, "offset": 4.2},
	{"key": "tree_dead_small", "arc": 20.5, "side": RIGHT, "offset": 2.8},
	{"key": "Tree_Bare_2_C_Color1", "arc": 23.0, "side": LEFT, "offset": 3.8},
	{"key": "Tree_Bare_1_C_Color1", "arc": 96.0, "side": RIGHT, "offset": 3.2},
	{"key": "tree_dead_large", "arc": 100.0, "side": LEFT, "offset": 4.4},
	{"key": "Tree_Bare_2_C_Color1", "arc": 104.0, "side": RIGHT, "offset": 3.6},
	{"key": "tree_dead_small", "arc": 108.0, "side": LEFT, "offset": 2.4},
	{"key": "Tree_Bare_1_C_Color1", "arc": 113.0, "side": RIGHT, "offset": 4.0},
	{"key": "tree_dead_small", "arc": 117.0, "side": LEFT, "offset": 2.6},
]

## Sparse hand-placed clutter -- crates, barrels, the shrine, debris and the
## two ground-laid sword/shield pieces -- spread across the route rather than
## clustered, and kept close to the boundary line (offsets well under the 4.0
## m wall gap) so it reads as roadside litter rather than a themed pass. Total
## 12 instances across a ~146 m route, matching this project's own "sparingly"
## standard for a dressing layer (see class doc comment).
const CLUTTER_SCATTER: Array[Dictionary] = [
	{"key": "sword_shield", "arc": 12.0, "side": RIGHT, "offset": 2.0},
	{"key": "barrel_large", "arc": 8.0, "side": RIGHT, "offset": 2.2},
	{"key": "box_large", "arc": 8.6, "side": RIGHT, "offset": 1.6},
	{"key": "box_small", "arc": 9.2, "side": RIGHT, "offset": 1.8},
	{"key": "debris", "arc": 30.0, "side": LEFT, "offset": 1.4},
	{"key": "barrel_large", "arc": 55.0, "side": LEFT, "offset": 2.0},
	{"key": "box_large", "arc": 56.0, "side": LEFT, "offset": 1.4},
	{"key": "shrine", "arc": 65.0, "side": RIGHT, "offset": 2.4},
	{"key": "debris", "arc": 78.0, "side": RIGHT, "offset": 1.2},
	{"key": "sword_shield_broken", "arc": 118.0, "side": LEFT, "offset": 2.2},
	{"key": "debris", "arc": 125.0, "side": LEFT, "offset": 1.6},
	{"key": "box_small", "arc": 136.0, "side": RIGHT, "offset": 1.6},
]

## `lantern_standing` fill: interleaved with Session 3's `post_lantern` rhythm
## (`LANTERN_START_ARC` 12.0, spacing 14.0) by starting half a spacing step
## later, so the two rhythms alternate rather than coincide.
const LANTERN_FILL_START_ARC: float = 19.0
const LANTERN_FILL_SPACING_ARC: float = 14.0
const LANTERN_FILL_END_MARGIN: float = 3.0

## Same offset as Session 3's own `BOUNDARY_GAP`, so the interleaved lanterns
## sit on exactly the same line as `post_lantern` -- one cadence, not two.
const LANTERN_FILL_GAP: float = 2.0

const _SALT_TAGS: Dictionary = {
	1: "tree_yaw",
	2: "clutter_yaw",
	3: "lantern_yaw",
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
	assert(_SALT_TAGS.has(salt), "props_layout: salt %d has no _SALT_TAGS entry" % salt)
	var tag: String = String(_SALT_TAGS.get(salt, str(salt)))
	return float(abs(hash("%d_%d_%s" % [index, side, tag])) % 1000000) / 1000000.0


## Same Y-axis rotation convention every sibling file in this concept uses:
## local +Z maps to world (0, 0, 1) at yaw 0, so `atan2(D.x, D.z)` aligns a
## local-Z-long piece with direction D; a local-X-long piece uses the
## mirror-image `atan2(-D.z, D.x)`.
static func _yaw_for_tangent(tangent: Vector2, long_axis: String) -> float:
	if long_axis == "z":
		return atan2(tangent.x, tangent.y)
	return atan2(-tangent.y, tangent.x)


## Measures payload `key` exactly once.
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
	probe_node.free()


## Instantiates payload `key` under `parent` at world point `(x, ground_y, z)`
## with the given `yaw`, honouring `record`'s ground-contact convention
## ("base" or "plant" -- this session's fourteen payloads use only those two).
func lay_piece(
	key: String, record: Dictionary, x: float, z: float, ground_y: float, yaw: float,
	parent: Node3D
) -> Node3D:
	_ensure_measured(key, record)
	var scene: PackedScene = load(String(record["path"])) as PackedScene
	assert(scene != null, "Reference Landing props: %s failed to load" % record["path"])
	var node: Node3D = scene.instantiate() as Node3D
	node.name = "%s_%d" % [key.replace("-", "_"), _instance_index]
	_instance_index += 1
	parent.add_child(node)
	node.rotation = Vector3(0.0, yaw, 0.0)

	if String(record["contact"]) == "plant":
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


func _record_placed(placed: Array, counts: Dictionary, key: String, pos: Vector3) -> void:
	counts[key] = int(counts.get(key, 0)) + 1
	placed.append({"key": key, "x": pos.x, "z": pos.z})


## The two dead-tree clusters, straight from `DEAD_TREE_CLUSTERS`.
func _build_dead_trees(parent: Node3D) -> Dictionary:
	var group: Node3D = Node3D.new()
	group.name = "DeadTrees"
	parent.add_child(group)

	var counts: Dictionary = {}
	var placed: Array = []

	for entry: Dictionary in DEAD_TREE_CLUSTERS:
		var key: String = String(entry["key"])
		var record: Dictionary = payload(key)
		_ensure_measured(key, record)
		var arc: float = float(entry["arc"])
		var side: int = int(entry["side"])
		var offset: float = float(entry["offset"])
		var pos: Vector3 = ReferenceLandingBoundaryLayout.edge_point(arc, side, offset)
		var yaw: float = cell_random(int(round(arc * 10.0)), side, 1) * TAU
		lay_piece(key, record, pos.x, pos.z, pos.y, yaw, group)
		_record_placed(placed, counts, key, pos)

	return {"group": group, "counts": counts, "placed": placed}


## `lantern_standing` fill, interleaved with `post_lantern` -- see class doc
## comment and `LANTERN_FILL_*` constants.
func _build_lantern_fill(parent: Node3D) -> Dictionary:
	var group: Node3D = Node3D.new()
	group.name = "LanternFill"
	parent.add_child(group)

	var key: String = "lantern_standing"
	var record: Dictionary = payload(key)
	_ensure_measured(key, record)

	var lengths: Array[float] = ReferenceLandingGroundLayout.cumulative_arc_lengths()
	var total: float = lengths[lengths.size() - 1]
	var end: float = total - LANTERN_FILL_END_MARGIN

	var counts: Dictionary = {}
	var placed: Array = []

	var arc: float = LANTERN_FILL_START_ARC
	while arc <= end:
		for side: int in [LEFT, RIGHT]:
			if ReferenceLandingBoundaryLayout.is_breached(arc, side):
				continue
			var pos: Vector3 = ReferenceLandingBoundaryLayout.edge_point(arc, side, LANTERN_FILL_GAP)
			var tangent: Vector2 = ReferenceLandingBoundaryLayout.horizontal_tangent_at_arc(arc)
			var yaw: float = _yaw_for_tangent(tangent, String(_long_axis_cache[key]))
			lay_piece(key, record, pos.x, pos.z, pos.y, yaw, group)
			_record_placed(placed, counts, key, pos)
		arc += LANTERN_FILL_SPACING_ARC

	return {"group": group, "counts": counts, "placed": placed}


## The sparse clutter scatter, straight from `CLUTTER_SCATTER`.
func _build_clutter(parent: Node3D) -> Dictionary:
	var group: Node3D = Node3D.new()
	group.name = "Clutter"
	parent.add_child(group)

	var counts: Dictionary = {}
	var placed: Array = []

	for entry: Dictionary in CLUTTER_SCATTER:
		var key: String = String(entry["key"])
		var record: Dictionary = payload(key)
		_ensure_measured(key, record)
		var arc: float = float(entry["arc"])
		var side: int = int(entry["side"])
		var offset: float = float(entry["offset"])
		var pos: Vector3 = ReferenceLandingBoundaryLayout.edge_point(arc, side, offset)
		var yaw: float = cell_random(int(round(arc * 10.0)), side, 2) * TAU
		lay_piece(key, record, pos.x, pos.z, pos.y, yaw, group)
		_record_placed(placed, counts, key, pos)

	return {"group": group, "counts": counts, "placed": placed}


## Instantiates Session 4's real architecture layout onto a scratch (never-
## in-the-real-tree) parent, exactly as `architecture_check.gd` already does,
## finds every placed standing-wall instance (`_WALL_KEYS` -- see its own doc
## comment for why `wall_cracked` counts), converts each to an arc length, and
## returns the smallest-arc one ("near SPAWN") and the largest-arc one ("near
## PORTAL"). Fails loudly if Session 4 placed no standing wall at all, rather
## than silently mounting nowhere.
func _find_wall_mount_targets() -> Dictionary:
	var scratch: Node3D = Node3D.new()
	var arch: ReferenceLandingArchitectureLayout = ReferenceLandingArchitectureLayout.new()
	var result: Dictionary = arch.build(scratch)

	var candidates: Array[Dictionary] = []
	for entry: Dictionary in result["placed"]:
		var key: String = String(entry["key"])
		if not _WALL_KEYS.has(key):
			continue
		var x: float = float(entry["x"])
		var z: float = float(entry["z"])
		var info: Dictionary = ReferenceLandingGroundLayout.closest_on_centerline(x, z)
		candidates.append({"key": key, "x": x, "z": z, "arc": float(info["arc"])})

	assert(not candidates.is_empty(), "props_layout: Session 4 placed no intact wall to mount a banner on")

	candidates.sort_custom(func(a, b): return float(a["arc"]) < float(b["arc"]))
	scratch.free()

	return {
		"spawn": candidates[0],
		"portal": candidates[candidates.size() - 1],
		"candidate_count": candidates.size(),
	}


## Builds the rotation basis for a piece mounted on a wall whose own tangent
## direction is `tangent` and whose outward side is `side` (LEFT/RIGHT, same
## meaning as everywhere else in this concept). `long_axis` is the payload's
## own measured long axis ("z" or "x"). See class doc comment for the
## derivation: this always produces a proper (determinant +1) rotation, so
## the mounted piece never renders mirrored.
static func _mount_basis(tangent: Vector2, side: int, long_axis: String) -> Basis:
	var tangent_3d: Vector3 = Vector3(tangent.x, 0.0, tangent.y).normalized()
	var outward_2d: Vector2 = Vector2(-tangent.y, tangent.x) * float(side)
	var inward_3d: Vector3 = Vector3(-outward_2d.x, 0.0, -outward_2d.y).normalized()

	if long_axis == "z":
		var basis_z: Vector3 = tangent_3d
		var basis_y: Vector3 = inward_3d
		var basis_x: Vector3 = basis_y.cross(basis_z)
		return Basis(basis_x, basis_y, basis_z)

	var basis_x2: Vector3 = tangent_3d
	var basis_y2: Vector3 = inward_3d
	var basis_z2: Vector3 = basis_x2.cross(basis_y2)
	return Basis(basis_x2, basis_y2, basis_z2)


## Mounts payload `key` on the wall found at `wall_entry` (from
## `_find_wall_mount_targets()`), returning the placed node's world position
## for bookkeeping. See class doc comment for the full geometry derivation.
func _mount_on_wall(key: String, wall_entry: Dictionary, parent: Node3D) -> Vector3:
	var record: Dictionary = payload(key)
	_ensure_measured(key, record)

	var wall_key: String = String(wall_entry["key"])
	var wall_path: String = String(_WALL_PATHS[wall_key])
	var wall_probe: Node3D = (load(wall_path) as PackedScene).instantiate() as Node3D
	var wall_measured: Dictionary = ExteriorAssetProbe.measure(wall_probe)
	wall_probe.free()
	var wall_size: Vector3 = wall_measured["size"]
	var wall_half_thickness: float = minf(wall_size.x, wall_size.z) * 0.5
	var wall_height: float = wall_size.y

	var wall_x: float = float(wall_entry["x"])
	var wall_z: float = float(wall_entry["z"])
	var wall_arc: float = float(wall_entry["arc"])
	var wall_ground_y: float = ReferenceLandingGroundLayout.position_at_arc(wall_arc).y
	var tangent: Vector2 = ReferenceLandingBoundaryLayout.horizontal_tangent_at_arc(wall_arc)

	# Recover which side (LEFT/RIGHT) this wall instance sits on: compare the
	# wall's own offset from the centreline against the "outward for
	# side=RIGHT" perpendicular. `_build_gate()`/`_build_walls()` never
	# recorded the side in `placed`, so it is derived from the instance's own
	# position instead of assumed.
	var centre: Vector3 = ReferenceLandingGroundLayout.position_at_arc(wall_arc)
	var offset_vec: Vector2 = Vector2(wall_x - centre.x, wall_z - centre.z)
	var outward_probe: Vector2 = Vector2(-tangent.y, tangent.x)
	var side: int = RIGHT if offset_vec.dot(outward_probe) >= 0.0 else LEFT

	var basis: Basis = _mount_basis(tangent, side, String(_long_axis_cache[key]))

	var outward_2d: Vector2 = Vector2(-tangent.y, tangent.x) * float(side)
	var inward_2d: Vector2 = -outward_2d
	var box: AABB = _aabb_cache[key]
	var thin_extent: float = box.size.y

	var wall_face_xz: Vector2 = Vector2(wall_x, wall_z) + inward_2d * wall_half_thickness
	var mount_xz: Vector2 = wall_face_xz + inward_2d * (thin_extent * 0.5 + MOUNT_LIFT)
	var mount_y: float = wall_ground_y + wall_height * MOUNT_HEIGHT_FRACTION
	var mount_target: Vector3 = Vector3(mount_xz.x, mount_y, mount_xz.y)

	var local_centre: Vector3 = box.get_center()
	var world_centre_offset: Vector3 = basis * local_centre

	var scene: PackedScene = load(String(record["path"])) as PackedScene
	assert(scene != null, "Reference Landing props: %s failed to load" % record["path"])
	var node: Node3D = scene.instantiate() as Node3D
	node.name = "%s_%d" % [key.replace("-", "_"), _instance_index]
	_instance_index += 1
	parent.add_child(node)
	node.transform = Transform3D(basis, mount_target - world_centre_offset)

	return mount_target


func _build_wall_banners(parent: Node3D) -> Dictionary:
	var group: Node3D = Node3D.new()
	group.name = "WallBanners"
	parent.add_child(group)

	var targets: Dictionary = _find_wall_mount_targets()
	var spawn_wall: Dictionary = targets["spawn"]
	var portal_wall: Dictionary = targets["portal"]

	var counts: Dictionary = {}
	var placed: Array = []

	var spawn_pos: Vector3 = _mount_on_wall("banner_shield_red", spawn_wall, group)
	_record_placed(placed, counts, "banner_shield_red", spawn_pos)
	var portal_pos: Vector3 = _mount_on_wall("banner_shield_red", portal_wall, group)
	_record_placed(placed, counts, "banner_shield_red", portal_pos)

	return {
		"group": group, "counts": counts, "placed": placed,
		"spawn_wall": spawn_wall, "portal_wall": portal_wall,
		"candidate_count": targets["candidate_count"],
	}


static func _merge_counts(into: Dictionary, from: Dictionary) -> void:
	for key: String in from.keys():
		into[key] = int(into.get(key, 0)) + int(from[key])


## Main entry point. Creates "DeadTrees", "LanternFill", "WallBanners" and
## "Clutter" `Node3D` groups under `parent`. Returns a `Dictionary` reporting
## exactly what it built, including the wall-mount targets found.
func build(parent: Node3D) -> Dictionary:
	_aabb_cache.clear()
	_module_cache.clear()
	_long_axis_cache.clear()
	_instance_index = 0

	# Cross-measure every registered payload once, regardless of whether this
	# particular deterministic run happens to use it -- mirrors every sibling
	# file in this concept.
	for record: Dictionary in PAYLOADS:
		_ensure_measured(String(record["key"]), record)

	var trees: Dictionary = _build_dead_trees(parent)
	var lanterns: Dictionary = _build_lantern_fill(parent)
	var banners: Dictionary = _build_wall_banners(parent)
	var clutter: Dictionary = _build_clutter(parent)

	var all_counts: Dictionary = {}
	_merge_counts(all_counts, trees["counts"])
	_merge_counts(all_counts, lanterns["counts"])
	_merge_counts(all_counts, banners["counts"])
	_merge_counts(all_counts, clutter["counts"])

	var all_placed: Array = []
	all_placed.append_array(trees["placed"])
	all_placed.append_array(lanterns["placed"])
	all_placed.append_array(banners["placed"])
	all_placed.append_array(clutter["placed"])

	var total_instances: int = 0
	for key: String in all_counts.keys():
		total_instances += int(all_counts[key])

	return {
		"counts": all_counts,
		"placed": all_placed,
		"total_instances": total_instances,
		"tree_counts": trees["counts"],
		"lantern_counts": lanterns["counts"],
		"banner_counts": banners["counts"],
		"clutter_counts": clutter["counts"],
		"banner_spawn_wall": banners["spawn_wall"],
		"banner_portal_wall": banners["portal_wall"],
		"wall_candidate_count": banners["candidate_count"],
	}
