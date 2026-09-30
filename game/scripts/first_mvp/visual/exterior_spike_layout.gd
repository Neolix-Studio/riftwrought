class_name ExteriorSpikeLayout
extends Node3D
## First-MVP Gate 1B — the comparison ground the spike builds (specification §5).
##
## Three readable areas connected by unobstructed ground, exactly as §5 asks:
##
##     KayKit source lineup            z = -50 (Forest) and z = -41 (Halloween)
##             |
##             v
##     hybrid exterior court           z = -22 .. +12, with the registered
##             |                       Dungeon wall run as the §5.2 transition
##             v
##     k0rveen supplemental lineup     z = +40 and z = +62
##
## THE GROUND IS PROJECT-AUTHORED. §5.2 requires "project-authored flat navigable
## ground", and the k0rveen terrain slabs are explicitly NOT it: §5.3 says they
## "must not become navigable production terrain during this spike", so they are
## displayed objects with blocking proxies and nothing walks on them.
##
## THE SIZE OF THIS PLACE IS NOT A TARGET. §5: "It needs enough open floor to
## move around and inspect the assets, but its dimensions do not become a
## production-room target." The Gate 1A hall measured space; this one measures
## assets, and it is large only because one k0rveen terrain slab is 20 m across.
##
## PLACEMENT RULES, stated because they are the difference between an honest
## comparison and a flattering one:
##
##   * every candidate is placed at scale 1.0 and the spike asserts it;
##   * in the §5.1 SOURCE LINEUP every STANDING piece sits at exactly y = 0 with
##     no rotation and no vertical adjustment, so a piece KayKit authored to be
##     partly buried is shown partly buried and the measured offset is reported
##     rather than quietly corrected. The three flat SURFACE pieces are laid at
##     their measured surface height even there, because a surface coplanar with
##     the ground is not a modest presentation choice — it is invisible;
##   * in the §5.2 COURT the flat surface pieces — dirt, path, and the dungeon
##     floor module — are lowered by their own MEASURED top height so they lie
##     flush with the authored ground. That offset is computed from the
##     measurement, never typed, which is why the report can state that the
##     Halloween dirt module's top sits 0.030 m above its origin while the
##     registered Dungeon floor module's sits 0.050 m above its own.
##
## COLLISION IS A PROXY, NOT A DECISION. §5.4: "Simple project-authored collision
## proxies may protect major displayed assets, but collision fidelity is not
## being approved here." Each proxy is one box on the world layer, sized from the
## measured cross-section of the piece it protects. Thin surface pieces get none.
##
## AND EVERY PROXY CARVES THE NAVIGATION MESH. This is Gate 1A's sharpest finding
## applied before it could bite: a box collider whose TOP lies outside the bake
## volume rasterises as an open-topped well with a walkable interior, and the
## phantom island survives the agent-radius erosion whenever the box is deeper
## than 2 x radius = 0.80 m. Almost every proxy here is — a 20 m terrain slab
## most of all — so a spike without carving would have had a walkable island
## sealed inside every large asset in it.

## Layer 1 is "world": the authored ground, the boundary berm, and every asset
## proxy. Click raycasts, character collision, and the navigation bake all read
## this one layer, exactly as in Prototype Zero and the Gate 1A hall.
const WORLD_LAYER: int = 1

# --- The authored ground ------------------------------------------------------
# MEASURED, twice, from the rendered evidence: the §7 review frames at the 40 m
# distance reach roughly 26 m past their focus, and a ground whose own boundary
# and the dark surround beyond it fall inside a review frame is a distraction in
# every picture the owner is asked to judge. The north edge is 31 m clear of the
# northernmost candidate and the south edge 11 m clear of the southernmost.
const GROUND_CENTRE: Vector2 = Vector2(0.0, 0.0)
const GROUND_EXTENT: Vector2 = Vector2(124.0, 164.0)
const GROUND_THICKNESS: float = 0.40
## MEASURED DEFECT, and the fix for it. A surface piece lowered so its top lies
## at exactly y = 0 is COPLANAR with the authored ground plane, and the first
## rendered evidence showed the whole `floor_dirt` patch missing: twenty 4 m
## modules were laid, imported cleanly, and were invisible because the ground was
## fighting them for the same depth. Flush therefore means "flush plus this",
## which is below the 0.20 m navigation climb limit by two orders of magnitude
## and invisible at the accepted camera, but is not zero.
const SURFACE_LIFT: float = 0.008
## How far above a solid's own top face its navigation carve extends. See
## `_add_solid()` for the measurement that set it.
const CARVE_MARGIN: float = 0.50
## The pieces whose job is to BE a surface. They are laid by their measured
## surface height everywhere, including the source lineup.
const FLAT_SURFACE_KEYS: Array[String] = ["floor_dirt", "path_A", "path_C"]
## A low boundary berm rather than a wall: it stops the character walking into
## empty space without turning an exterior into a room. Its 0.60 m height is
## deliberately above the 0.20 m navigation climb limit, so it blocks instead of
## becoming a step.
const BERM_HEIGHT: float = 0.60
const BERM_THICKNESS: float = 0.80

# --- §5.1 source lineup -------------------------------------------------------
# MEASURED, from the first rendered evidence run: at the 40 m review distance the
# §7 "complete neutral source lineup" frame reaches about 20 m past its focus, and
# rows at -50 / -41 put the ground's own north boundary and the dark surround
# beyond it into the top corner of the picture. Six metres south takes the edge
# out of frame without changing the ground, the navigation mesh, or any measured
# dimension.
const LINEUP_FOREST_Z: float = -45.0
const LINEUP_HALLOWEEN_Z: float = -36.0
const LINEUP_SPACING: float = 6.0

# --- §5.2 hybrid exterior court -----------------------------------------------
const COURT_CENTRE: Vector2 = Vector2(0.0, -5.0)
const COURT_EXTENT: Vector2 = Vector2(46.0, 34.0)
const PATH_FROM_Z: float = -20.0
const PATH_TO_Z: float = 10.0
const ARCH_AT: Vector2 = Vector2(0.0, -4.0)
const DUNGEON_WALL_Z: float = 9.0
## Wall run centres. The two `wall_pillar` pieces at -4 and +4 are each 4.000 m
## wide, so their inner faces leave a doorway the spike MEASURES rather than
## assumes.
const DUNGEON_WALL_X: Array[float] = [-12.0, -8.0, 8.0, 12.0]
const DUNGEON_PILLAR_X: Array[float] = [-4.0, 4.0]

# --- §5.3 k0rveen supplemental lineup -----------------------------------------
const K0RVEEN_ROW_A_Z: float = 40.0
const K0RVEEN_ROW_B_Z: float = 62.0

const PLAYER_SPAWN: Vector2 = Vector2(0.0, -28.0)

@export var grid_visible: bool = false

var treatment: ExteriorReviewTreatment
var lighting: ExteriorReviewLighting

var _visuals: Node3D
var _collision: StaticBody3D
var _obstacles: Node3D
var _k0rveen_group: Node3D
var _grid: MeshInstance3D

## Every candidate instance the layout placed: the record it came from, the node,
## which area it is in, and whether it is the PRIMARY instance whose measurement
## represents that candidate in the report.
var placed: Array[Dictionary] = []
## Every world-layer collision box, in layout-local space, recorded as it is
## added so measurements read the built world rather than the authored intent.
var _solids: Array[Dictionary] = []
## Collision shapes and navigation carves that belong to the k0rveen group, so
## hiding it really removes it rather than leaving invisible obstructions.
var _k0rveen_shapes: Array[CollisionShape3D] = []
var _k0rveen_carves: Array[NavigationObstacle3D] = []

var k0rveen_visible: bool = true
## The measured horizontal surface height of every flat piece the court lays, in
## the piece's own local space, so the report can state them rather than repeat
## the bounding boxes that were wrong.
var surface_drops: Dictionary = {}


func build(
	review_treatment: ExteriorReviewTreatment, review_lighting: ExteriorReviewLighting
) -> void:
	treatment = review_treatment
	lighting = review_lighting

	for child: Node in get_children():
		child.free()
	placed.clear()
	surface_drops.clear()
	_solids.clear()
	_k0rveen_shapes.clear()
	_k0rveen_carves.clear()

	_visuals = Node3D.new()
	_visuals.name = "Visuals"
	add_child(_visuals)

	_collision = StaticBody3D.new()
	_collision.name = "WorldCollision"
	_collision.collision_layer = WORLD_LAYER
	_collision.collision_mask = 0
	add_child(_collision)

	_obstacles = Node3D.new()
	_obstacles.name = "NavigationObstacles"
	add_child(_obstacles)

	_k0rveen_group = Node3D.new()
	_k0rveen_group.name = "K0rveenCandidates"
	_visuals.add_child(_k0rveen_group)

	_build_ground()
	_build_source_lineup()
	_build_hybrid_court()
	_build_k0rveen_lineup()
	_build_grid()


# --- Ground -------------------------------------------------------------------

func _build_ground() -> void:
	# A far darker plane beyond the reviewed ground, so the exterior does not end
	# in visible void at a camera that sees several metres past the boundary. It
	# carries no collision and is not part of the navigable surface.
	var surround: MeshInstance3D = MeshInstance3D.new()
	surround.name = "SurroundPlane"
	var surround_mesh: PlaneMesh = PlaneMesh.new()
	surround_mesh.size = Vector2(600.0, 600.0)
	surround.mesh = surround_mesh
	# Assigned to the MESH rather than through `material_override`, deliberately:
	# `material_override` outranks a per-surface override, so an authored surface
	# set that way would silently ignore the F2 treatment and stay bright while
	# everything around it darkened.
	# A darker TONE than the review ground rather than a near-black void. At a 45
	# degree camera yaw the far CORNERS of a 40 m review frame reach about 50 m
	# past the focus, so a finite ground's boundary is visible in the corner of a
	# wide evidence frame however far it is pushed out — and a boundary that reads
	# as distant ground is honest, while one that reads as a hole is a distraction
	# in every picture the owner is asked to judge.
	surround_mesh.material = _authored_material(Color(0.262, 0.265, 0.273), 1.0)
	surround.position = Vector3(GROUND_CENTRE.x, -0.09, GROUND_CENTRE.y)
	surround.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_visuals.add_child(surround)
	_register_authored(surround, "authored surround plane")

	var ground: MeshInstance3D = MeshInstance3D.new()
	ground.name = "AuthoredGround"
	var ground_mesh: PlaneMesh = PlaneMesh.new()
	ground_mesh.size = GROUND_EXTENT
	ground.mesh = ground_mesh
	# Project-authored and deliberately quiet, but LIGHT: §6.1 requires neutral
	# review to be "bright enough to reveal geometry and material mismatch", and
	# a dark ground under a source lineup does the opposite. The candidate
	# treatment darkens it by the same rule it applies to everything else.
	# COOL and neutral rather than earth-coloured, for a measured reason: the
	# first rendered evidence used a warm grey ground and the Halloween
	# `floor_dirt` module — which is also a warm grey — vanished into it, leaving
	# only the module's own scattered pebbles visible as confetti across the
	# court. A neutral ground lets a warm candidate surface be seen AS a surface.
	ground_mesh.material = _authored_material(Color(0.402, 0.406, 0.416), 1.0)
	ground.position = Vector3(GROUND_CENTRE.x, 0.0, GROUND_CENTRE.y)
	_visuals.add_child(ground)
	_register_authored(ground, "authored review ground")

	_add_solid(
		"Ground", Vector3(GROUND_EXTENT.x, GROUND_THICKNESS, GROUND_EXTENT.y),
		Vector3(GROUND_CENTRE.x, -GROUND_THICKNESS * 0.5, GROUND_CENTRE.y), false
	)

	var half: Vector2 = GROUND_EXTENT * 0.5
	var berms: Array[Dictionary] = [
		{
			"name": "BermNorth",
			"size": Vector3(GROUND_EXTENT.x, BERM_HEIGHT, BERM_THICKNESS),
			"at": Vector3(GROUND_CENTRE.x, BERM_HEIGHT * 0.5,
				GROUND_CENTRE.y - half.y + BERM_THICKNESS * 0.5),
		},
		{
			"name": "BermSouth",
			"size": Vector3(GROUND_EXTENT.x, BERM_HEIGHT, BERM_THICKNESS),
			"at": Vector3(GROUND_CENTRE.x, BERM_HEIGHT * 0.5,
				GROUND_CENTRE.y + half.y - BERM_THICKNESS * 0.5),
		},
		{
			"name": "BermWest",
			"size": Vector3(BERM_THICKNESS, BERM_HEIGHT, GROUND_EXTENT.y),
			"at": Vector3(GROUND_CENTRE.x - half.x + BERM_THICKNESS * 0.5,
				BERM_HEIGHT * 0.5, GROUND_CENTRE.y),
		},
		{
			"name": "BermEast",
			"size": Vector3(BERM_THICKNESS, BERM_HEIGHT, GROUND_EXTENT.y),
			"at": Vector3(GROUND_CENTRE.x + half.x - BERM_THICKNESS * 0.5,
				BERM_HEIGHT * 0.5, GROUND_CENTRE.y),
		},
	]
	for berm: Dictionary in berms:
		var block: MeshInstance3D = MeshInstance3D.new()
		block.name = "%sVisual" % berm["name"]
		var box: BoxMesh = BoxMesh.new()
		box.size = berm["size"]
		block.mesh = box
		box.material = _authored_material(Color(0.318, 0.310, 0.296), 1.0)
		block.position = berm["at"]
		_visuals.add_child(block)
		_register_authored(block, "authored boundary berm")
		_add_solid(String(berm["name"]), berm["size"], berm["at"], true)


# --- §5.1 KayKit source lineup ------------------------------------------------

## Every extracted Forest and Halloween model, once, at root scale 1.0, with its
## source material intact and a label naming pack, filename, and measured size.
func _build_source_lineup() -> void:
	_lineup_row(
		ExteriorAssetCatalogue.FAMILY_FOREST, LINEUP_FOREST_Z, "lineup_forest",
		Color(0.78, 0.86, 0.78)
	)
	_lineup_row(
		ExteriorAssetCatalogue.FAMILY_HALLOWEEN, LINEUP_HALLOWEEN_Z, "lineup_halloween",
		Color(0.90, 0.82, 0.70)
	)


func _lineup_row(family: String, at_z: float, area: String, colour: Color) -> void:
	var records: Array[Dictionary] = []
	for record: Dictionary in ExteriorAssetCatalogue.manifest():
		if String(record["family"]) == family:
			records.append(record)
	var span: float = float(records.size() - 1) * LINEUP_SPACING
	var start: float = -span * 0.5
	for index: int in records.size():
		var record: Dictionary = records[index]
		# Standing pieces sit at exactly y = 0, unadjusted, so a piece KayKit
		# authored to be planted is SHOWN planted. The three flat SURFACE pieces
		# are the one exception, and for a measured reason: a surface whose own
		# plane is at y = 0 is coplanar with the ground it is standing on, so the
		# first rendered lineup showed the dirt module as nothing but a scatter of
		# loose pebbles. They are laid at their measured surface height here as
		# well, which is a placement, not a rescale — §5.1's requirement is root
		# scale 1.0, and the spike asserts that separately.
		var y: float = 0.0
		if FLAT_SURFACE_KEYS.has(String(record["key"])):
			y = _surface_drop(record)
		var at: Vector3 = Vector3(start + float(index) * LINEUP_SPACING, y, at_z)
		var node: Node3D = _place(record, at, 0.0, area, true)
		var probe: Dictionary = measurement_of(node)
		# MEASURED, from the first rendered evidence run: a label carrying the
		# mesh and surface counts as well as the size ran to about 45 characters
		# and rendered roughly 7 m wide in world space, straight across three
		# neighbouring candidates. The counts live in the overlay table instead,
		# and the 3D label keeps only what has to be read beside the object.
		_add_label(
			_visuals, Vector3(at.x, maxf(float(probe["size"].y), 1.0) + 0.9, at.z),
			"%s\n%.2f x %.2f x %.2f m" % [
				record["display"], float(probe["size"].x), float(probe["size"].y),
				float(probe["size"].z),
			], colour
		)
	_add_label(
		_visuals, Vector3(start - LINEUP_SPACING * 1.6, 3.4, at_z),
		"%s\nsource review\nroot scale 1.0, no adjustment" % family,
		Color(0.86, 0.70, 0.42)
	)


# --- §5.2 hybrid exterior court -----------------------------------------------

func _build_hybrid_court() -> void:
	_build_dirt_patch()
	_build_path()
	_build_court_architecture()
	_build_court_nature()
	_build_dungeon_transition()
	_add_label(
		_visuals, Vector3(COURT_CENTRE.x, 6.4, COURT_CENTRE.y - COURT_EXTENT.y * 0.5 + 1.0),
		"HYBRID EXTERIOR COURT — a non-canonical composition\n"
		+ "This is NOT Riftfall Landing and NOT a Bastion room.",
		Color(0.86, 0.70, 0.42)
	)


## `floor_dirt` laid as a 4 x 4 patch of its own 4.000 m module — a 16 x 16 m
## ruined courtyard around the gateway and the path — lowered by its own measured
## top so it lies flush with the authored ground.
func _build_dirt_patch() -> void:
	var record: Dictionary = ExteriorAssetCatalogue.record_for("floor_dirt")
	var drop: float = _surface_drop(record)
	for ix: int in 4:
		for iz: int in 4:
			var at: Vector3 = Vector3(-8.0 + float(ix) * 4.0, drop, -12.0 + float(iz) * 4.0)
			_place(record, at, 0.0, "court", false)


## The two path tiles alternating along the spine, from the court's north
## approach, under the arch, to the dungeon threshold.
func _build_path() -> void:
	var tiles: Array[Dictionary] = [
		ExteriorAssetCatalogue.record_for("path_A"), ExteriorAssetCatalogue.record_for("path_C"),
	]
	# The path is a surface too, and it crosses the dirt module, so it takes one
	# more SURFACE_LIFT than the dirt does — about 16 mm above the authored
	# ground in total. That is what stops the two flush surfaces fighting.
	var drops: Array[float] = [
		_surface_drop(tiles[0]) + SURFACE_LIFT, _surface_drop(tiles[1]) + SURFACE_LIFT,
	]
	var step: float = 1.85
	var index: int = 0
	var z: float = PATH_FROM_Z
	while z <= PATH_TO_Z + 0.001:
		var which: int = index % 2
		_place(tiles[which], Vector3(0.0, drops[which], z), 0.0, "court", false)
		index += 1
		z += step


func _build_court_architecture() -> void:
	# The arch straddles the path. Its two legs were MEASURED at x -2.00..-1.50
	# and +1.50..+2.00 in the 0.30-1.80 m band, so the proxies are those legs and
	# the clear opening between them is a measured 3.00 m rather than a guess.
	var arch: Dictionary = ExteriorAssetCatalogue.record_for("arch")
	_place(arch, Vector3(ARCH_AT.x, 0.0, ARCH_AT.y), 0.0, "court", false)
	for side: float in [-1.0, 1.0]:
		_add_proxy(
			"ArchLeg%s" % ("West" if side < 0.0 else "East"),
			Vector3(0.50, 4.40, 0.50),
			Vector3(ARCH_AT.x + side * 1.75, 2.20, ARCH_AT.y)
		)

	# Two standing lanterns flanking the gateway. In the candidate treatment each
	# carries one restrained warm light; in neutral review they are unlit props.
	var lantern: Dictionary = ExteriorAssetCatalogue.record_for("lantern_standing")
	for side: float in [-1.0, 1.0]:
		var at: Vector3 = Vector3(ARCH_AT.x + side * 3.0, 0.0, ARCH_AT.y)
		_place(lantern, at, 0.0, "court", false)
		if lighting != null:
			lighting.add_lantern(at + Vector3(0.0, 0.85, 0.0))

	# A broken boundary along the court's north-west edge.
	var fence: Dictionary = ExteriorAssetCatalogue.record_for("fence_broken")
	for x: float in [-18.0, -14.0, -10.0, -6.0]:
		_place(fence, Vector3(x, 0.0, -19.0), 0.0, "court", false)
		_add_proxy("Fence%d" % int(x), Vector3(4.0, 2.20, 0.50), Vector3(x, 1.10, -19.0))
	var pillar: Dictionary = ExteriorAssetCatalogue.record_for("fence_pillar_broken")
	for x: float in [-20.25, -3.75, 8.0]:
		_place(pillar, Vector3(x, 0.0, -19.0), 0.0, "court", false)
		_add_proxy(
			"FencePillar%d" % int(x * 100.0), Vector3(0.50, 1.50, 0.50),
			Vector3(x, 0.75, -19.0)
		)


func _build_court_nature() -> void:
	var placements: Array[Dictionary] = [
		{"key": "tree_dead_large", "at": Vector2(-19.5, -13.0), "yaw": 0.35,
			"proxy": Vector3(0.45, 5.10, 0.45)},
		{"key": "tree_dead_large", "at": Vector2(13.5, -17.5), "yaw": -1.10,
			"proxy": Vector3(0.45, 5.10, 0.45)},
		{"key": "Tree_Bare_1_C_Color1", "at": Vector2(-19.0, 3.0), "yaw": 0.6,
			"proxy": Vector3(1.00, 5.30, 1.00)},
		{"key": "Tree_Bare_2_C_Color1", "at": Vector2(16.0, 4.5), "yaw": -0.4,
			"proxy": Vector3(0.60, 7.70, 0.60)},
		{"key": "Rock_1_Q_Color1", "at": Vector2(-16.5, -2.5), "yaw": 0.9,
			"proxy": Vector3(2.10, 4.30, 2.70)},
		{"key": "Rock_3_A_Color1", "at": Vector2(9.0, -12.5), "yaw": 2.1,
			"proxy": Vector3.ZERO},
		{"key": "Rock_1_A_Color1", "at": Vector2(-9.5, 6.0), "yaw": 1.4,
			"proxy": Vector3.ZERO},
		{"key": "Rock_1_A_Color1", "at": Vector2(-7.0, 10.5), "yaw": -0.8,
			"proxy": Vector3.ZERO},
		{"key": "Rock_3_A_Color1", "at": Vector2(7.0, 10.8), "yaw": 0.2,
			"proxy": Vector3.ZERO},
	]
	var index: int = 0
	for placement: Dictionary in placements:
		var record: Dictionary = ExteriorAssetCatalogue.record_for(String(placement["key"]))
		var at: Vector2 = placement["at"]
		_place(record, Vector3(at.x, 0.0, at.y), float(placement["yaw"]), "court", false)
		var proxy: Vector3 = placement["proxy"]
		if proxy.length() > 0.0:
			_add_proxy(
				"Nature%d" % index, proxy, Vector3(at.x, proxy.y * 0.5, at.y)
			)
		index += 1


## §5.2's transition reference: "at least one already registered Dungeon wall or
## wall-pillar piece". A short run of the registered pieces with a doorway, and a
## patch of the registered Dungeon floor module behind it, so the owner can see
## the outdoor dirt meeting the dungeon stone rather than imagining it.
func _build_dungeon_transition() -> void:
	var wall: Dictionary = ExteriorAssetCatalogue.record_for("dungeon_wall")
	var pillar: Dictionary = ExteriorAssetCatalogue.record_for("dungeon_wall_pillar")
	var floor_module: Dictionary = ExteriorAssetCatalogue.record_for("dungeon_floor_tile_large")

	for x: float in DUNGEON_WALL_X:
		_place(wall, Vector3(x, 0.0, DUNGEON_WALL_Z), 0.0, "transition",
			is_equal_approx(x, -12.0))
		_add_proxy(
			"DungeonWall%d" % int(x), Vector3(4.0, 4.0, 1.0),
			Vector3(x, 2.0, DUNGEON_WALL_Z)
		)
	for x: float in DUNGEON_PILLAR_X:
		_place(pillar, Vector3(x, 0.0, DUNGEON_WALL_Z), 0.0, "transition",
			is_equal_approx(x, -4.0))
		_add_proxy(
			"DungeonPillar%d" % int(x), Vector3(4.0, 4.0, 1.5),
			Vector3(x, 2.0, DUNGEON_WALL_Z)
		)

	var drop: float = _surface_drop(floor_module)
	for ix: int in 4:
		for iz: int in 3:
			_place(
				floor_module,
				Vector3(-6.0 + float(ix) * 4.0, drop, 12.0 + float(iz) * 4.0),
				0.0, "transition", ix == 0 and iz == 0
			)
	_add_label(
		_visuals, Vector3(0.0, 5.6, DUNGEON_WALL_Z + 4.5),
		"Registered Dungeon Pack transition reference\n"
		+ "already imported at Gate A — NOT part of the Gate 1B extraction",
		Color(0.72, 0.80, 0.92)
	)


# --- §5.3 k0rveen supplemental lineup -----------------------------------------

func _build_k0rveen_lineup() -> void:
	var placements: Array[Dictionary] = [
		{"key": "k0rveen_Terrain_1", "at": Vector2(-13.0, K0RVEEN_ROW_A_Z),
			"proxy": Vector3(20.0, 2.80, 20.0)},
		{"key": "k0rveen_Terrain_2", "at": Vector2(11.0, K0RVEEN_ROW_A_Z),
			"proxy": Vector3(20.0, 1.80, 20.0)},
		{"key": "k0rveen_Mounting_1", "at": Vector2(-12.0, K0RVEEN_ROW_B_Z),
			"proxy": Vector3(15.70, 7.80, 16.75)},
		{"key": "k0rveen_Tree_1", "at": Vector2(8.0, K0RVEEN_ROW_B_Z),
			"proxy": Vector3(1.70, 12.30, 2.15)},
		{"key": "k0rveen_Rock_1", "at": Vector2(20.0, K0RVEEN_ROW_B_Z),
			"proxy": Vector3(3.45, 0.40, 2.05)},
	]
	for placement: Dictionary in placements:
		var record: Dictionary = ExteriorAssetCatalogue.record_for(String(placement["key"]))
		var at: Vector2 = placement["at"]
		var node: Node3D = _place(
			record, Vector3(at.x, 0.0, at.y), 0.0, "k0rveen", true, _k0rveen_group
		)
		var probe: Dictionary = measurement_of(node)
		_add_label(
			_k0rveen_group, Vector3(at.x, float(probe["size"].y) + 2.6, at.y),
			"%s\n%.2f x %.2f x %.2f m\nno texture" % [
				record["display"], float(probe["size"].x), float(probe["size"].y),
				float(probe["size"].z),
			], Color(0.82, 0.78, 0.92)
		)
		var proxy: Vector3 = placement["proxy"]
		_add_proxy(
			"K0rveen_%s" % record["key"], proxy,
			Vector3(at.x, proxy.y * 0.5, at.y), true
		)

	_add_label(
		_k0rveen_group, Vector3(-24.0, 5.0, K0RVEEN_ROW_A_Z - 12.0),
		"%s — SUPPLEMENTAL / BACKGROUND CANDIDATES\n%s\n"
		% [ExteriorAssetCatalogue.FAMILY_K0RVEEN, ExteriorAssetCatalogue.K0RVEEN_CREDIT]
		+ "Not navigable terrain in this spike. Classification is the owner's.",
		Color(0.86, 0.70, 0.42)
	)


## §5.3 and §6: F4 hides the k0rveen candidates entirely, so the owner can see
## whether the KayKit-only composition stands on its own. Hiding removes their
## collision as well — an invisible wall would be a worse answer than either
## state — and the caller rebakes navigation so the walkable surface matches what
## is actually there.
func set_k0rveen_visible(value: bool) -> void:
	k0rveen_visible = value
	_k0rveen_group.visible = value
	for shape: CollisionShape3D in _k0rveen_shapes:
		shape.disabled = not value
	for carve: NavigationObstacle3D in _k0rveen_carves:
		carve.affect_navigation_mesh = value


# --- Placement helpers --------------------------------------------------------

## Instantiates one catalogue record. Scale is never touched, which is what makes
## "root scale 1.0" a fact about the scene rather than about the importer alone.
func _place(
	record: Dictionary, at: Vector3, yaw: float, area: String, primary: bool,
	parent: Node3D = null
) -> Node3D:
	var scene: PackedScene = load(String(record["path"])) as PackedScene
	assert(scene != null, "Gate 1B: %s failed to load" % record["path"])
	var node: Node3D = scene.instantiate() as Node3D
	node.name = "%s_%d" % [record["key"], placed.size()]
	node.position = at
	node.rotation = Vector3(0.0, yaw, 0.0)
	var host: Node3D = parent if parent != null else _visuals
	host.add_child(node)
	if treatment != null:
		treatment.register(node, String(record["display"]))
	# MEASURED ONCE, here, and cached. The overlay redraws every frame and the
	# measurement copies every surface's vertex array, so remeasuring on demand
	# would have re-read the whole scene's geometry sixty times a second.
	placed.append({
		"key": record["key"],
		"record": record,
		"node": node,
		"area": area,
		"primary": primary,
		"probe": ExteriorAssetProbe.measure(node),
	})
	return node


## The cached measurement of a node this layout placed.
func measurement_of(node: Node3D) -> Dictionary:
	for entry: Dictionary in placed:
		if entry["node"] == node:
			return entry["probe"]
	return ExteriorAssetProbe.measure(node)


## How far to lower a flat surface piece so its real horizontal surface lies just
## above the authored ground. Derived from `dominant_surface_y()`, never typed —
## and NOT from the bounding box, for the measured reason recorded there.
func _surface_drop(record: Dictionary) -> float:
	var scene: PackedScene = load(String(record["path"])) as PackedScene
	var probe_node: Node3D = scene.instantiate() as Node3D
	var surface_y: float = ExteriorAssetProbe.dominant_surface_y(probe_node)
	probe_node.free()
	surface_drops[String(record["key"])] = surface_y
	return -surface_y + SURFACE_LIFT


func _add_proxy(
	proxy_name: String, size: Vector3, at: Vector3, is_k0rveen: bool = false
) -> void:
	_add_solid(proxy_name, size, at, true, is_k0rveen)


func _add_solid(
	solid_name: String, size: Vector3, at: Vector3, carve: bool,
	is_k0rveen: bool = false
) -> void:
	var shape: CollisionShape3D = CollisionShape3D.new()
	shape.name = solid_name
	var box: BoxShape3D = BoxShape3D.new()
	box.size = size
	shape.shape = box
	shape.position = at
	_collision.add_child(shape)
	_solids.append({"name": solid_name, "aabb": AABB(at - size * 0.5, size)})
	if is_k0rveen:
		_k0rveen_shapes.append(shape)
	if not carve:
		return
	var obstacle: NavigationObstacle3D = NavigationObstacle3D.new()
	obstacle.name = "%sCarve" % solid_name
	obstacle.position = Vector3(at.x, 0.0, at.z)
	# MEASURED: a carve exactly as tall as the box it removes leaves the surface
	# ON its top face at the boundary, and a low, wide proxy then keeps a walkable
	# island up there — the 3.45 x 0.40 x 2.05 m k0rveen rock proxy did, while
	# every taller obstacle was carved cleanly. The margin puts the top face
	# unambiguously inside the carve.
	obstacle.height = size.y + CARVE_MARGIN
	obstacle.affect_navigation_mesh = true
	obstacle.carve_navigation_mesh = true
	obstacle.avoidance_enabled = false
	var half_x: float = size.x * 0.5
	var half_z: float = size.z * 0.5
	obstacle.vertices = PackedVector3Array([
		Vector3(-half_x, 0.0, -half_z), Vector3(half_x, 0.0, -half_z),
		Vector3(half_x, 0.0, half_z), Vector3(-half_x, 0.0, half_z),
	])
	_obstacles.add_child(obstacle)
	if is_k0rveen:
		_k0rveen_carves.append(obstacle)


func _build_grid() -> void:
	var half: Vector2 = GROUND_EXTENT * 0.5
	var mesh: ImmediateMesh = ImmediateMesh.new()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	var minor: Color = Color(0.40, 0.56, 0.74, 0.42)
	var major: Color = Color(0.88, 0.58, 0.26, 0.80)
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	var x: float = GROUND_CENTRE.x - half.x
	while x <= GROUND_CENTRE.x + half.x + 0.001:
		mesh.surface_set_color(major if is_zero_approx(fmod(absf(x), 5.0)) else minor)
		mesh.surface_add_vertex(Vector3(x, 0.02, GROUND_CENTRE.y - half.y))
		mesh.surface_add_vertex(Vector3(x, 0.02, GROUND_CENTRE.y + half.y))
		x += 1.0
	var z: float = GROUND_CENTRE.y - half.y
	while z <= GROUND_CENTRE.y + half.y + 0.001:
		mesh.surface_set_color(major if is_zero_approx(fmod(absf(z), 5.0)) else minor)
		mesh.surface_add_vertex(Vector3(GROUND_CENTRE.x - half.x, 0.02, z))
		mesh.surface_add_vertex(Vector3(GROUND_CENTRE.x + half.x, 0.02, z))
		z += 1.0
	mesh.surface_end()

	_grid = MeshInstance3D.new()
	_grid.name = "ScaleGrid"
	_grid.mesh = mesh
	_grid.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_grid.visible = grid_visible
	_visuals.add_child(_grid)


func set_grid_visible(value: bool) -> void:
	grid_visible = value
	if _grid != null:
		_grid.visible = value


# --- Measured geometry --------------------------------------------------------

func player_spawn() -> Vector3:
	return Vector3(PLAYER_SPAWN.x, 0.0, PLAYER_SPAWN.y)


func ground_rect() -> Rect2:
	return Rect2(GROUND_CENTRE - GROUND_EXTENT * 0.5, GROUND_EXTENT)


func court_rect() -> Rect2:
	return Rect2(COURT_CENTRE - COURT_EXTENT * 0.5, COURT_EXTENT)


func solids() -> Array[Dictionary]:
	return _solids


func solid(solid_name: String) -> Dictionary:
	for entry: Dictionary in _solids:
		if String(entry["name"]) == solid_name:
			return entry
	return {}


## The registered Dungeon doorway between the two `wall_pillar` inner faces,
## MEASURED off the proxies actually built rather than repeated from the layout
## constants that asked for it.
func dungeon_doorway_metres() -> float:
	var west: Dictionary = solid("DungeonPillar-4")
	var east: Dictionary = solid("DungeonPillar4")
	if west.is_empty() or east.is_empty():
		return 0.0
	var west_box: AABB = west["aabb"]
	var east_box: AABB = east["aabb"]
	return east_box.position.x - west_box.end.x


## The Halloween arch's clear opening, MEASURED between the inner faces of the two
## leg proxies the court actually built. Those proxies are themselves sized from
## the arch mesh's own cross-section in the 0.30-1.80 m band, so this is a real
## doorway width rather than a guess about a decorative piece.
func arch_opening_metres() -> float:
	var west: Dictionary = solid("ArchLegWest")
	var east: Dictionary = solid("ArchLegEast")
	if west.is_empty() or east.is_empty():
		return 0.0
	return (east["aabb"] as AABB).position.x - (west["aabb"] as AABB).end.x


## The fraction of the §5.2 court footprint that carries no collision-bearing
## decoration. The room-authoring blueprint's 65-80% clear-ground rule applies
## "even to this visual exercise" (§5.2), so it is measured rather than asserted
## by eye. The authored ground slab and the boundary berm are not decoration and
## are excluded; every asset proxy inside the court counts.
func court_clear_fraction() -> float:
	var court: Rect2 = court_rect()
	var occupied: float = 0.0
	for entry: Dictionary in _solids:
		var solid_name: String = String(entry["name"])
		if solid_name == "Ground" or solid_name.begins_with("Berm"):
			continue
		var box: AABB = entry["aabb"]
		var footprint: Rect2 = Rect2(
			Vector2(box.position.x, box.position.z), Vector2(box.size.x, box.size.z)
		)
		var overlap: Rect2 = footprint.intersection(court)
		occupied += overlap.get_area()
	return 1.0 - occupied / maxf(court.get_area(), 0.0001)


func primary_instances() -> Array[Dictionary]:
	var primaries: Array[Dictionary] = []
	for entry: Dictionary in placed:
		if bool(entry["primary"]):
			primaries.append(entry)
	return primaries


func instances_of(key: String) -> int:
	var total: int = 0
	for entry: Dictionary in placed:
		if String(entry["key"]) == key:
			total += 1
	return total


## Authored scene surfaces join the same treatment the candidates do, so F1 and
## F2 change the whole picture rather than leaving a bright ground under a dark
## exterior. They are project-authored, so nothing third-party is involved.
func _register_authored(node: Node3D, label: String) -> void:
	if treatment != null:
		treatment.register(node, label)


func _authored_material(colour: Color, roughness: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = colour
	material.roughness = roughness
	material.metallic = 0.0
	material.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	return material


## Billboarded instrumentation text. Gate 1A measured a 0.009 x 34 label at about
## 0.31 m per line; this spike's labels stand beside 6 m-spaced candidates rather
## than across an open hall, so they are one step smaller again — about 0.23 m
## per line — and carry the name and the measured size and nothing else.
func _add_label(parent: Node3D, at: Vector3, text: String, colour: Color) -> Label3D:
	var label: Label3D = Label3D.new()
	label.text = text
	label.position = at
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.double_sided = true
	label.no_depth_test = false
	label.fixed_size = false
	label.pixel_size = 0.0075
	label.font_size = 30
	label.outline_size = 8
	label.modulate = colour
	label.outline_modulate = Color(0.05, 0.06, 0.08, 0.90)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.render_priority = 4
	label.outline_render_priority = 3
	parent.add_child(label)
	return label
