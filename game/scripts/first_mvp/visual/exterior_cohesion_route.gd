class_name ExteriorCohesionRoute
extends Node3D
## First-MVP Gate 1B — the ONE composed route slice this comparison builds
## (specification §5), with bounded candidate families switched inside it.
##
## THE WHOLE POINT IS THAT THIS IS NOT A CATALOGUE. The first Gate 1B spike laid
## every candidate out in rows, which proved compatibility and could not answer
## whether the assets make a believable place. So this file builds ONE route-shaped
## composition with three functional beats —
##
##     open arrival   ->   broken approach   ->   threshold silhouette
##
## — and changes only which family fills the same compositional roles. Those
## labels describe composition. This is NOT Riftfall Landing, NOT Broken Watch,
## NOT the Nexus Threshold, and NOT the Severed Threshold route.
##
## THE ROUTE IS PROJECT-AUTHORED AND THE CANDIDATES ARE DRESSED INTO IT. Every
## walkable surface, every boundary, every blocked footprint, and every navigation
## carve belongs to project-authored geometry that is IDENTICAL in all twelve mode
## combinations. A candidate family supplies MESHES ONLY. That is not tidiness: §7
## says "No candidate is allowed to change navigation merely because a visual mode
## was selected", and building it this way makes that a structural fact rather
## than a promise — the comparison never rebakes, because nothing a review toggle
## touches can change the collision the bake reads.
##
## PLACEMENT RULES, stated because they separate an honest comparison from a
## flattering one:
##
##   * every candidate is placed at scale 1.0 and the comparison asserts it. The
##     measured module ladder is 4.000 m (KayKit), 1.990-3.993 m (Quaternius), and
##     1.000 m (all three Kenney kits), and NOTHING here rescales a family to hide
##     that. Where a 1 m kit has to fill a 4 m role it TILES, which is what a
##     modular kit is for;
##   * a piece is placed by its measured AABB base unless it was authored to be
##     planted, in which case `plant` places it by its own origin and the measured
##     offset is reported rather than quietly corrected;
##   * flat SURFACE pieces are laid by the height carrying the most upward-facing
##     triangle AREA (`ExteriorAssetProbe.dominant_surface_y()`), never by their
##     bounding box — the first spike measured why, and the same trap is here.
##
## COLLISION IS A PROXY, NOT A DECISION. §7: "Simple project-authored collision
## proxies are allowed where candidate collision is absent, but the report must
## distinguish proxy dimensions from measured mesh dimensions." Each station
## carries ONE authored box whose footprint and height are constants of the route,
## identical in every architecture mode; the report prints them beside the measured
## mesh sizes.
##
## AND EVERY SOLID CARVES THE NAVIGATION MESH. Gate 1A's sharpest finding: a box
## whose TOP lies outside the bake volume rasterises as an open-topped well with a
## walkable interior, and the phantom island survives the agent-radius erosion
## whenever the box is deeper than 2 x radius = 0.80 m. Every solid here is.

const WORLD_LAYER: int = 1

enum Architecture { KAYKIT_BASELINE, QUATERNIUS_RUINS, KENNEY_TOWN }

# --- The authored ground ------------------------------------------------------
## MEASURED, from the first rendered evidence: an authored ground that runs far
## past the boundary shoulders reads as an endless grey plane and the route stops
## looking like a route. It now ends about six metres beyond the shoulders and the
## caps, so the slice reads as a causeway with darker ground beyond it — which is
## honest, because that is exactly what it is.
const GROUND_CENTRE: Vector2 = Vector2(0.0, 0.5)
const GROUND_EXTENT: Vector2 = Vector2(36.0, 76.0)
const GROUND_THICKNESS: float = 0.40
## A surface lowered so its top lies at exactly y = 0 is COPLANAR with the
## authored ground plane and disappears. Flush therefore means "flush plus this".
## Two orders of magnitude below the 0.20 m navigation climb limit.
const SURFACE_LIFT: float = 0.008
## How far above a solid's own top face its navigation carve extends. A carve
## exactly as tall as its box leaves the baked surface ON the top face at the
## boundary, and a low wide proxy then keeps a walkable island up there.
const CARVE_MARGIN: float = 0.50

# --- The route -----------------------------------------------------------------
## The long axis runs north (arrival) to south (threshold). Measured, not typed:
## `centreline_length_metres()` reads it back off the solids that were built.
const ROUTE_FROM_Z: float = -24.0
const ROUTE_TO_Z: float = 25.0
## The corridor funnels 16 m -> 14 m -> 12 m toward the threshold. Those steps are
## project-authored and identical in every mode.
const CORRIDOR_STEPS: Array[Dictionary] = [
	{"half_width": 7.0, "from_z": -24.0, "to_z": 20.0},
	{"half_width": 6.0, "from_z": 20.0, "to_z": 25.0},
]
const SHOULDER_OUTER: float = 11.0
const SHOULDER_HEIGHT: float = 1.0
const CAP_THICKNESS: float = 2.0

const THRESHOLD_Z: float = 12.0
const PLAYER_SPAWN: Vector2 = Vector2(0.0, -20.0)
## Through the registered Dungeon doorway, so traversal proves the whole route in
## every combination rather than stopping short of the tightest opening.
const ROUTE_TARGET: Vector2 = Vector2(0.0, 23.0)

const DUNGEON_WALL_Z: float = 21.0
const DUNGEON_PILLAR_X: float = 4.0

## The pieces whose job is to BE a surface. They are laid by measured surface
## height, never by their bounding box.
const FLAT_SURFACE_KEYS: Array[String] = [
	"ref_floor_dirt", "ref_path_A", "ref_path_C", "ref_floor_tile_large",
	"ground_pathStraight", "ground_pathBend",
]
## Ground clutter this low is walked over rather than around, so it does not count
## as an intrusion into the clear walking line. MEASURED: the Graveyard `debris`
## piece is 0.160 m tall, well under the 0.20 m navigation climb limit, and the
## first draft of this file wrongly laid it as a flat SURFACE — which sank it
## 0.080 m into the ground and left a scatter of chips where a debris pile should
## be, because `dominant_surface_y()` answers a solid object's own upper face.
const GROUND_CLUTTER_HEIGHT: float = 0.30

## §5's stable blocked stations. The FOOTPRINT and the PROXY HEIGHT are constants
## of the route and are identical in all three architecture modes; only the meshes
## inside them change. `proxy` false means the station stands on ground that is
## already blocked (a shoulder), so it adds no collision and no carve at all.
const STATIONS: Array[Dictionary] = [
	{"name": "ApproachWallWest", "at": Vector2(-5.0, -4.0), "size": Vector2(4.0, 1.2),
		"height": 4.0, "proxy": true},
	{"name": "ApproachWallEast", "at": Vector2(5.0, -1.0), "size": Vector2(4.0, 1.2),
		"height": 4.0, "proxy": true},
	{"name": "ApproachMassWest", "at": Vector2(-4.6, 2.2), "size": Vector2(2.4, 2.4),
		"height": 2.4, "proxy": true},
	{"name": "ApproachMassEast", "at": Vector2(4.8, 4.2), "size": Vector2(2.2, 2.2),
		"height": 2.2, "proxy": true},
	{"name": "ApproachWallWestTwo", "at": Vector2(-5.0, 6.8), "size": Vector2(4.0, 1.2),
		"height": 4.0, "proxy": true},
	{"name": "GateWest", "at": Vector2(-5.0, THRESHOLD_Z), "size": Vector2(4.0, 1.6),
		"height": 4.4, "proxy": true},
	{"name": "GateEast", "at": Vector2(5.0, THRESHOLD_Z), "size": Vector2(4.0, 1.6),
		"height": 4.4, "proxy": true},
	{"name": "ThresholdSilhouette", "at": Vector2(-9.0, 16.5), "size": Vector2(4.4, 1.4),
		"height": 4.5, "proxy": false},
]

## The clear channel the walking line uses. No architecture mesh in any mode may
## overlap it, which is asserted rather than eyeballed.
const SPINE_HALF_WIDTH: float = 2.0
const SPINE_HEIGHT: float = 2.2

@export var grid_visible: bool = false

var treatment: ExteriorReviewTreatment
var lighting: ExteriorReviewLighting

var architecture: Architecture = Architecture.KAYKIT_BASELINE
var topology_visible: bool = false
var dressing_visible: bool = false

var _visuals: Node3D
var _collision: StaticBody3D
var _obstacles: Node3D
var _anchors: Node3D
var _topology: Node3D
var _dressing: Node3D
var _architecture_groups: Dictionary = {}
var _grid: MeshInstance3D
var _flat_ground: MeshInstance3D
var _authored_banks: Node3D

## Every instance the route placed: the record it came from, the node, which
## layer it belongs to, and whether it is the PRIMARY instance whose measurement
## represents that candidate in the report.
var placed: Array[Dictionary] = []
## Every world-layer collision box, in route-local space, recorded as it is added
## so measurements read the built world rather than the authored intent.
var _solids: Array[Dictionary] = []
## The measured horizontal surface height of every flat piece, in the piece's own
## local space, so the report states them rather than the bounding boxes that
## would have been wrong.
var surface_drops: Dictionary = {}
## Cached local AABBs, measured once per model. The overlay redraws every frame
## and a measurement copies every surface's vertex array.
var _aabb_cache: Dictionary = {}


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
	_aabb_cache.clear()
	_architecture_groups.clear()

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

	_anchors = Node3D.new()
	_anchors.name = "PermanentKayKitAnchors"
	_visuals.add_child(_anchors)

	_topology = Node3D.new()
	_topology.name = "KenneyNatureTopology"
	_visuals.add_child(_topology)

	_dressing = Node3D.new()
	_dressing.name = "KenneyGraveyardDressing"
	_visuals.add_child(_dressing)

	for mode: Architecture in [
		Architecture.KAYKIT_BASELINE, Architecture.QUATERNIUS_RUINS, Architecture.KENNEY_TOWN,
	]:
		var group: Node3D = Node3D.new()
		group.name = "Architecture_%s" % architecture_name(mode).replace(" ", "_")
		_visuals.add_child(group)
		_architecture_groups[mode] = group

	_build_ground_and_route()
	_build_permanent_anchors()
	_build_dungeon_transition()
	_build_topology()
	_build_architecture()
	_build_dressing()
	_build_grid()

	set_architecture(Architecture.KAYKIT_BASELINE)
	set_topology_visible(false)
	set_dressing_visible(false)


# --- Authored ground, corridor, and boundary ----------------------------------

func _build_ground_and_route() -> void:
	# A far darker plane beyond the reviewed ground. A finite test ground's
	# boundary reaches the corner of any wide review frame however far it is
	# pushed out, and a boundary that reads as distant ground is honest while one
	# that reads as a hole is a distraction in every picture the owner judges.
	var surround: MeshInstance3D = MeshInstance3D.new()
	surround.name = "SurroundPlane"
	var surround_mesh: PlaneMesh = PlaneMesh.new()
	surround_mesh.size = Vector2(600.0, 600.0)
	surround.mesh = surround_mesh
	# Assigned to the MESH rather than through `material_override`, deliberately:
	# `material_override` outranks a per-surface override, so an authored surface
	# set that way would ignore the F2 treatment and stay bright while everything
	# around it darkened.
	surround_mesh.material = _authored_material(Color(0.262, 0.265, 0.273))
	surround.position = Vector3(GROUND_CENTRE.x, -0.09, GROUND_CENTRE.y)
	surround.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_visuals.add_child(surround)
	_register_authored(surround, "authored surround plane")

	_flat_ground = MeshInstance3D.new()
	_flat_ground.name = "AuthoredGround"
	var ground_mesh: PlaneMesh = PlaneMesh.new()
	ground_mesh.size = GROUND_EXTENT
	_flat_ground.mesh = ground_mesh
	# COOL and neutral rather than earth-coloured: a warm ground swallows a warm
	# candidate surface, and neutral review must be bright enough to reveal a
	# mismatch rather than hide one.
	ground_mesh.material = _authored_material(Color(0.402, 0.406, 0.416))
	_flat_ground.position = Vector3(GROUND_CENTRE.x, 0.0, GROUND_CENTRE.y)
	_visuals.add_child(_flat_ground)
	_register_authored(_flat_ground, "authored review ground")

	_add_solid("Ground", Vector3(GROUND_EXTENT.x, GROUND_THICKNESS, GROUND_EXTENT.y),
		Vector3(GROUND_CENTRE.x, -GROUND_THICKNESS * 0.5, GROUND_CENTRE.y), false)

	_authored_banks = Node3D.new()
	_authored_banks.name = "AuthoredBanks"
	_visuals.add_child(_authored_banks)

	# The corridor's boundary shoulders. Their footprint, height, collision, and
	# carve are IDENTICAL whether Kenney Nature topology is shown or not; the F4
	# toggle only swaps which mesh faces them.
	for step: Dictionary in CORRIDOR_STEPS:
		var half: float = float(step["half_width"])
		var from_z: float = float(step["from_z"])
		var to_z: float = float(step["to_z"])
		var depth: float = to_z - from_z
		var width: float = SHOULDER_OUTER - half
		for side: float in [-1.0, 1.0]:
			var centre: Vector3 = Vector3(
				side * (half + width * 0.5), SHOULDER_HEIGHT * 0.5, from_z + depth * 0.5
			)
			var size: Vector3 = Vector3(width, SHOULDER_HEIGHT, depth)
			var label: String = "Shoulder%s%.0f" % ["West" if side < 0.0 else "East", from_z]
			_add_solid(label, size, centre, true)
			var block: MeshInstance3D = MeshInstance3D.new()
			block.name = "%sVisual" % label
			var box: BoxMesh = BoxMesh.new()
			box.size = size
			block.mesh = box
			box.material = _authored_material(Color(0.318, 0.310, 0.296))
			block.position = centre
			_authored_banks.add_child(block)
			_register_authored(block, "authored boundary shoulder")

	for cap: Array in [["CapNorth", ROUTE_FROM_Z - CAP_THICKNESS * 0.5],
			["CapSouth", ROUTE_TO_Z + CAP_THICKNESS * 0.5]]:
		var size: Vector3 = Vector3(SHOULDER_OUTER * 2.0, SHOULDER_HEIGHT, CAP_THICKNESS)
		var centre: Vector3 = Vector3(0.0, SHOULDER_HEIGHT * 0.5, float(cap[1]))
		_add_solid(String(cap[0]), size, centre, true)
		var block: MeshInstance3D = MeshInstance3D.new()
		block.name = "%sVisual" % String(cap[0])
		var box: BoxMesh = BoxMesh.new()
		box.size = size
		block.mesh = box
		box.material = _authored_material(Color(0.318, 0.310, 0.296))
		block.position = centre
		_visuals.add_child(block)
		_register_authored(block, "authored route cap")


# --- §5.1 permanent KayKit reference, visible in EVERY mode -------------------

## The constant stylistic anchor: the registered Dungeon transition, the KayKit
## Forest bare trees and rocks, and the selected Halloween dirt, path, broken
## fence, dead trees, and lanterns. None of these is part of the D-202 extraction
## and none of them ever hides, so every candidate is judged beside the families
## the project already has.
func _build_permanent_anchors() -> void:
	var dirt: Dictionary = ExteriorCohesionCatalogue.record_for("ref_floor_dirt")
	# Four modules across, so the 4.000 m dirt module covers the whole 14 m corridor
	# with its outer metre tucked under the boundary shoulders. Three across left a
	# one-metre strip of authored ground down each edge, which read as a seam.
	for ix: int in 4:
		for iz: int in 5:
			_lay_surface(dirt, Vector2(-6.0 + float(ix) * 4.0, -18.0 + float(iz) * 4.0),
				0.0, "anchor", _anchors, 0)

	var tiles: Array[Dictionary] = [
		ExteriorCohesionCatalogue.record_for("ref_path_A"),
		ExteriorCohesionCatalogue.record_for("ref_path_C"),
	]
	var index: int = 0
	var z: float = -19.0
	while z <= -1.6:
		# The path crosses the dirt module, so it takes one more SURFACE_LIFT than
		# the dirt does. That is what stops two flush surfaces fighting for the
		# same depth.
		_lay_surface(tiles[index % 2], Vector2(0.0, z), 0.0, "anchor", _anchors, 1)
		index += 1
		z += 1.85

	var fence: Dictionary = ExteriorCohesionCatalogue.record_for("ref_fence_broken")
	for fz: float in [-19.0, -15.0, -11.0]:
		_place_aligned(fence, Vector3(-8.4, SHOULDER_HEIGHT, fz), PI * 0.5, "anchor", _anchors)
	var fence_pillar: Dictionary = ExteriorCohesionCatalogue.record_for("ref_fence_pillar_broken")
	for fz: float in [-21.0, -17.0, -13.0, -9.0]:
		_place_aligned(fence_pillar, Vector3(-8.4, SHOULDER_HEIGHT, fz), 0.0, "anchor", _anchors)

	# Planted pieces keep their own origin: four KayKit Forest models and the
	# Halloween dead tree sit up to 0.46 m below theirs BY DESIGN, and lifting
	# them onto their bounding box would put them on tiptoe.
	_plant("ref_tree_dead_large", Vector3(-9.2, SHOULDER_HEIGHT, -16.5), 0.35, _anchors)
	_plant("ref_tree_dead_large", Vector3(9.4, SHOULDER_HEIGHT, -6.0), -1.10, _anchors)
	_plant("ref_Tree_Bare_1_C_Color1", Vector3(-9.0, SHOULDER_HEIGHT, -3.5), 0.60, _anchors)
	_plant("ref_Tree_Bare_2_C_Color1", Vector3(9.2, SHOULDER_HEIGHT, -13.5), -0.40, _anchors)
	_plant("ref_Rock_3_A_Color1", Vector3(-5.6, 0.0, -8.6), 2.10, _anchors)

	_place_aligned(ExteriorCohesionCatalogue.record_for("ref_Rock_1_Q_Color1"),
		Vector3(-8.8, SHOULDER_HEIGHT, 4.5), 0.90, "anchor", _anchors)
	for spot: Vector3 in [Vector3(5.6, 0.0, -13.0), Vector3(-4.0, 0.0, 8.6)]:
		_place_aligned(ExteriorCohesionCatalogue.record_for("ref_Rock_1_A_Color1"),
			spot, 1.40, "anchor", _anchors)
		_add_solid("AnchorRock%.0f" % (spot.z * 10.0), Vector3(0.58, 0.54, 0.61),
			spot + Vector3(0.0, 0.27, 0.0), true)
	# The planted rock keeps its authored sink, so its proxy is sized from what is
	# actually above the ground rather than from the whole bounding box.
	_add_solid("AnchorRockPlanted", Vector3(0.96, 0.40, 0.81), Vector3(-6.4, 0.20, -8.6), true)

	# The middle and late route carried almost no permanent anchor in the first
	# composed draft, so the beats between the dirt causeway and the threshold read
	# as empty ground. These are the same registered pieces, spread along it.
	_plant("ref_tree_dead_large", Vector3(8.8, SHOULDER_HEIGHT, 12.0), 0.9, _anchors)
	_plant("ref_Tree_Bare_1_C_Color1", Vector3(-8.9, SHOULDER_HEIGHT, 17.5), -0.7, _anchors)
	_plant("ref_Rock_3_A_Color1", Vector3(6.0, 0.0, 8.6), 1.2, _anchors)
	_add_solid("AnchorRockMid", Vector3(0.96, 0.40, 0.81), Vector3(6.0, 0.20, 8.6), true)
	for spot: Vector3 in [Vector3(5.2, 0.0, 0.6), Vector3(-3.4, 0.0, 14.2)]:
		_place_aligned(ExteriorCohesionCatalogue.record_for("ref_Rock_1_A_Color1"),
			spot, 0.7, "anchor", _anchors)
		_add_solid("AnchorRockLate%.0f" % (spot.z * 10.0), Vector3(0.58, 0.54, 0.61),
			spot + Vector3(0.0, 0.27, 0.0), true)

	var lantern: Dictionary = ExteriorCohesionCatalogue.record_for("ref_lantern_standing")
	for side: float in [-1.0, 1.0]:
		var at: Vector3 = Vector3(side * 3.0, 0.0, 9.2)
		_place_aligned(lantern, at, 0.0, "anchor", _anchors)
		_add_solid("Lantern%s" % ("West" if side < 0.0 else "East"),
			Vector3(0.64, 0.93, 0.64), at + Vector3(0.0, 0.465, 0.0), true)
		if lighting != null:
			lighting.add_lantern(at + Vector3(0.0, 0.85, 0.0))


## The registered Dungeon pieces closing the route: a floor apron and a wall run
## whose doorway is MEASURED between the two `wall_pillar` inner faces rather than
## repeated from the constant that asked for it.
func _build_dungeon_transition() -> void:
	var apron: Dictionary = ExteriorCohesionCatalogue.record_for("ref_floor_tile_large")
	for ix: int in 3:
		for iz: int in 2:
			_lay_surface(apron, Vector2(-4.0 + float(ix) * 4.0, 15.0 + float(iz) * 4.0),
				0.0, "anchor", _anchors, 0)

	var pillar: Dictionary = ExteriorCohesionCatalogue.record_for("ref_wall_pillar")
	for side: float in [-1.0, 1.0]:
		var at: Vector3 = Vector3(side * DUNGEON_PILLAR_X, 0.0, DUNGEON_WALL_Z)
		_place_aligned(pillar, at, 0.0, "anchor", _anchors)
		_add_solid("DungeonPillar%s" % ("West" if side < 0.0 else "East"),
			Vector3(4.0, 4.0, 1.5), at + Vector3(0.0, 2.0, 0.0), true)

	# Backdrop only: these stand on the already-blocked shoulder, so they add no
	# collision and no carve.
	var wall: Dictionary = ExteriorCohesionCatalogue.record_for("ref_wall")
	for side: float in [-1.0, 1.0]:
		_place_aligned(wall, Vector3(side * 8.5, SHOULDER_HEIGHT, DUNGEON_WALL_Z),
			0.0, "anchor", _anchors)
		_place_aligned(wall, Vector3(side * 8.5, SHOULDER_HEIGHT, DUNGEON_WALL_Z - 4.0),
			PI * 0.5, "anchor", _anchors)


# --- Terrain axis: Kenney Nature topology (F4) --------------------------------

## §4.1's role: route edge, raised boundary, ground/path comparison, and one
## rock-scale reference. The cliff panels FACE the same authored shoulders the
## flat baseline shows as plain banks, so switching topology on changes what the
## boundary looks like and cannot change where it is.
func _build_topology() -> void:
	var top: Dictionary = ExteriorCohesionCatalogue.record_for("cliff_top_stone")
	var plain: Dictionary = ExteriorCohesionCatalogue.record_for("cliff_stone")
	var corner: Dictionary = ExteriorCohesionCatalogue.record_for("cliff_corner_stone")

	for step: Dictionary in CORRIDOR_STEPS:
		var half: float = float(step["half_width"])
		var from_z: float = float(step["from_z"])
		var to_z: float = float(step["to_z"])
		# The last step uses the plain face variant so both are visible in the
		# same frame; the owner is comparing two panels, not being shown one.
		var record: Dictionary = plain if is_equal_approx(half, 6.0) else top
		var tiles: int = int(round(to_z - from_z))
		for side: float in [-1.0, 1.0]:
			for i: int in tiles:
				var at: Vector3 = Vector3(
					side * (half + 0.1345), 0.0, from_z + float(i) + 0.5
				)
				_place_aligned(record, at, side * PI * 0.5, "topology", _topology)
	# The corner posts cap the ENDS of the two runs and the step where the corridor
	# jogs inward, rather than sitting on top of the first and last face panel —
	# which is where a first draft put them, invisibly doubled.
	var first: Dictionary = CORRIDOR_STEPS[0]
	var last: Dictionary = CORRIDOR_STEPS[CORRIDOR_STEPS.size() - 1]
	for side: float in [-1.0, 1.0]:
		_place_aligned(corner,
			Vector3(side * (float(first["half_width"]) + 0.0845), 0.0,
				float(first["from_z"]) + 0.0845),
			side * PI * 0.5, "topology", _topology)
		_place_aligned(corner,
			Vector3(side * (float(last["half_width"]) + 0.0845), 0.0,
				float(last["to_z"]) - 0.0845),
			side * PI * 0.5, "topology", _topology)
		# The 1 m jog where the shoulder steps inward, faced across Z and capped.
		var jog_z: float = float(last["from_z"])
		_place_aligned(plain,
			Vector3(side * (float(last["half_width"]) + 0.5), 0.0, jog_z - 0.0845),
			0.0, "topology", _topology)
		_place_aligned(corner,
			Vector3(side * (float(first["half_width"]) + 0.0845), 0.0, jog_z - 0.0845),
			side * PI * 0.5, "topology", _topology)

	var straight: Dictionary = ExteriorCohesionCatalogue.record_for("ground_pathStraight")
	var bend: Dictionary = ExteriorCohesionCatalogue.record_for("ground_pathBend")
	_lay_surface(bend, Vector2(0.0, -1.5), 0.0, "topology", _topology, 1)
	for i: int in 13:
		_lay_surface(straight, Vector2(0.0, -0.5 + float(i)), 0.0, "topology", _topology, 1)
	_lay_surface(bend, Vector2(0.0, 12.5), PI, "topology", _topology, 1)

	var rock: Dictionary = ExteriorCohesionCatalogue.record_for("rock_largeC")
	for spot: Vector3 in [
		Vector3(-8.4, SHOULDER_HEIGHT, -6.5), Vector3(8.6, SHOULDER_HEIGHT, 3.0),
		Vector3(-8.0, SHOULDER_HEIGHT, 14.5),
	]:
		_place_aligned(rock, spot, 0.6, "topology", _topology)


func set_topology_visible(value: bool) -> void:
	topology_visible = value
	_topology.visible = value
	# The authored banks are what the flat baseline shows; the Kenney panels face
	# the SAME blocked footprint, so exactly one of the two is drawn and neither
	# owns any collision.
	_authored_banks.visible = not value


# --- Architecture axis: three families in the same stations (F5) --------------

func _build_architecture() -> void:
	for station: Dictionary in STATIONS:
		var at: Vector2 = station["at"]
		var size: Vector2 = station["size"]
		if bool(station["proxy"]):
			_add_solid(String(station["name"]),
				Vector3(size.x, float(station["height"]), size.y),
				Vector3(at.x, float(station["height"]) * 0.5, at.y), true)

	for mode: Architecture in _architecture_groups:
		var group: Node3D = _architecture_groups[mode]
		for fill: Dictionary in _fills_for(mode):
			var record: Dictionary = ExteriorCohesionCatalogue.record_for(String(fill["key"]))
			var at: Vector3 = fill["at"]
			var yaw: float = float(fill.get("yaw", 0.0))
			if bool(fill.get("plant", false)):
				_plant(String(fill["key"]), at, yaw, group)
			else:
				_place_aligned(record, at, yaw, "architecture_%d" % int(mode), group)


## Mode 0 — the existing baseline: the registered Dungeon wall and wall_pillar,
## the Halloween arch, broken fence, and broken fence pillars. Nothing here was
## extracted by D-202; this is the language the project already has.
func _kaykit_fills() -> Array[Dictionary]:
	return [
		{"key": "ref_wall", "at": Vector3(-5.0, 0.0, -4.0)},
		{"key": "ref_fence_broken", "at": Vector3(5.0, 0.0, -1.0)},
		{"key": "ref_fence_pillar_broken", "at": Vector3(3.2, 0.0, -1.0)},
		{"key": "ref_fence_pillar_broken", "at": Vector3(6.8, 0.0, -1.0)},
		{"key": "ref_fence_pillar_broken", "at": Vector3(-5.2, 0.0, 1.6)},
		{"key": "ref_fence_pillar_broken", "at": Vector3(-4.1, 0.0, 2.4)},
		{"key": "ref_fence_pillar_broken", "at": Vector3(-4.8, 0.0, 3.0)},
		{"key": "ref_fence_pillar_broken", "at": Vector3(4.3, 0.0, 3.8)},
		{"key": "ref_fence_pillar_broken", "at": Vector3(5.3, 0.0, 4.6)},
		{"key": "ref_wall", "at": Vector3(-5.0, 0.0, 6.8)},
		{"key": "ref_wall_pillar", "at": Vector3(-5.0, 0.0, THRESHOLD_Z)},
		{"key": "ref_wall_pillar", "at": Vector3(5.0, 0.0, THRESHOLD_Z)},
		{"key": "ref_arch", "at": Vector3(-9.0, SHOULDER_HEIGHT, 16.5), "yaw": PI * 0.5},
	]


## Mode 1 — Quaternius Modular Ruins. Its `Wall_ArchRound_Broken` measures
## 3.993 x 3.985 m, which is the KayKit 4.000 m module to within 7 mm, so it fills
## the same station without tiling; `Wall_Broken` is exactly half of it.
func _quaternius_fills() -> Array[Dictionary]:
	return [
		{"key": "Wall_Broken", "at": Vector3(-6.0, 0.0, -4.0)},
		{"key": "Wall_Broken", "at": Vector3(-4.0, 0.0, -4.0)},
		{"key": "Wall_ArchRound_Broken", "at": Vector3(5.0, 0.0, -1.0)},
		{"key": "Stairs", "at": Vector3(-4.6, 0.0, 2.2), "yaw": PI},
		{"key": "Bricks", "at": Vector3(4.8, 0.0, 4.7)},
		{"key": "Column_Round_Short", "at": Vector3(4.2, 0.0, 3.6)},
		{"key": "Column_Round_Short", "at": Vector3(5.4, 0.0, 3.7)},
		{"key": "Wall_Broken", "at": Vector3(-6.0, 0.0, 6.8)},
		{"key": "Wall_Broken", "at": Vector3(-4.0, 0.0, 6.8)},
		{"key": "Wall_ArchRound_Broken", "at": Vector3(-5.0, 0.0, THRESHOLD_Z)},
		{"key": "Wall_ArchRound_Broken", "at": Vector3(5.0, 0.0, THRESHOLD_Z)},
		{"key": "Arch_Gothic", "at": Vector3(-9.0, SHOULDER_HEIGHT, 16.5), "yaw": PI * 0.5},
	]


## Mode 2 — Kenney Fantasy Town, the deliberately simpler language. Its module is
## a MEASURED 1.000 m against KayKit's 4.000 m, so filling the same stations means
## TILING it four across and two or three high. Nothing is rescaled; the module
## ratio is the finding, not a problem to hide.
func _kenney_town_fills() -> Array[Dictionary]:
	var fills: Array[Dictionary] = []
	# MEASURED FROM THE FIRST RENDER: stacking `wall-broken` two courses high
	# repeats its broken crenellation at mid-height, which reads as a mistake
	# rather than as a ruin. A modular kit stacks SOLID below and BROKEN on top,
	# so `wall-corner` carries the courses and `wall-broken` is the parapet.
	for wall_z: float in [-4.0, 6.8]:
		for i: int in 4:
			fills.append({"key": "wall-corner", "at": Vector3(-6.5 + float(i), 0.0, wall_z)})
			fills.append({
				"key": "wall-broken",
				"at": Vector3(-6.5 + float(i), 1.0, wall_z), "yaw": PI * 0.5,
			})
	for i: int in 4:
		fills.append({"key": "wall-corner", "at": Vector3(3.5 + float(i), 0.0, -1.0)})
		fills.append({
			"key": "wall-half", "at": Vector3(3.5 + float(i), 1.0, -1.0), "yaw": PI * 0.5,
		})
	fills.append({"key": "stairs-stone", "at": Vector3(-5.1, 0.0, 2.2)})
	fills.append({"key": "stairs-stone", "at": Vector3(-4.1, 0.0, 2.2), "yaw": PI})
	fills.append({"key": "pillar-stone", "at": Vector3(-4.6, 0.0, 3.0)})
	fills.append({"key": "pillar-stone", "at": Vector3(4.3, 0.0, 3.7)})
	fills.append({"key": "pillar-stone", "at": Vector3(5.3, 0.0, 4.7)})
	for level: int in 2:
		fills.append({
			"key": "wall-half", "at": Vector3(4.8, float(level) * 0.5, 4.2), "yaw": PI * 0.5,
		})
	for side: float in [-1.0, 1.0]:
		for i: int in 4:
			for level: int in 3:
				fills.append({
					"key": "wall-corner",
					"at": Vector3(side * (3.5 + float(i)), float(level), THRESHOLD_Z),
				})
		for level: int in 3:
			fills.append({
				"key": "pillar-stone",
				"at": Vector3(side * 3.2, float(level), THRESHOLD_Z),
			})
	for i: int in 3:
		for level: int in 2:
			fills.append({
				"key": "wall-corner",
				"at": Vector3(-10.0 + float(i), SHOULDER_HEIGHT + float(level), 16.5),
			})
		fills.append({
			"key": "wall-broken",
			"at": Vector3(-10.0 + float(i), SHOULDER_HEIGHT + 2.0, 16.5), "yaw": PI * 0.5,
		})
	fills.append({
		"key": "wall-arch", "at": Vector3(-9.0, SHOULDER_HEIGHT + 3.0, 16.5), "yaw": PI * 0.5,
	})
	return fills


func _fills_for(mode: Architecture) -> Array[Dictionary]:
	match mode:
		Architecture.QUATERNIUS_RUINS:
			return _quaternius_fills()
		Architecture.KENNEY_TOWN:
			return _kenney_town_fills()
		_:
			return _kaykit_fills()


func set_architecture(mode: Architecture) -> void:
	architecture = mode
	for key: Architecture in _architecture_groups:
		(_architecture_groups[key] as Node3D).visible = key == mode


func cycle_architecture() -> Architecture:
	set_architecture(((architecture + 1) % 3) as Architecture)
	return architecture


static func architecture_name(mode: Architecture) -> String:
	match mode:
		Architecture.QUATERNIUS_RUINS:
			return "Quaternius Modular Ruins"
		Architecture.KENNEY_TOWN:
			return "Kenney Fantasy Town"
		_:
			return "KayKit baseline"


# --- Dressing axis: Kenney Graveyard (F7) -------------------------------------

## §4.4's role: ONE optional restrained damage/dressing layer. Every piece stands
## either on an already-blocked shoulder or flat on the corridor floor, so the
## layer adds ZERO collision shapes and ZERO navigation carves — which is asserted
## rather than promised, and is why the route survives it unchanged.
func _build_dressing() -> void:
	var wall: Dictionary = ExteriorCohesionCatalogue.record_for("stone-wall-damaged")
	var column: Dictionary = ExteriorCohesionCatalogue.record_for("stone-wall-column")
	var runs: Array[Dictionary] = [
		{"x": -7.6, "from": -18.0, "yaw": PI * 0.5},
		{"x": 7.6, "from": -10.0, "yaw": -PI * 0.5},
	]
	for run: Dictionary in runs:
		var x: float = float(run["x"])
		var from_z: float = float(run["from"])
		var yaw: float = float(run["yaw"])
		_place_aligned(column, Vector3(x, SHOULDER_HEIGHT, from_z - 1.0), yaw,
			"dressing", _dressing)
		for i: int in 3:
			_place_aligned(wall, Vector3(x, SHOULDER_HEIGHT, from_z + float(i)), yaw,
				"dressing", _dressing)
		_place_aligned(column, Vector3(x, SHOULDER_HEIGHT, from_z + 3.0), yaw,
			"dressing", _dressing)

	var debris: Dictionary = ExteriorCohesionCatalogue.record_for("debris")
	var index: int = 0
	for spot: Vector2 in [
		Vector2(-2.8, -6.5), Vector2(2.4, -2.0), Vector2(-1.6, 3.4), Vector2(3.6, 8.0),
		Vector2(-3.8, 10.5), Vector2(1.2, 13.6), Vector2(-2.4, 16.4), Vector2(4.4, -11.0),
	]:
		# Placed by its AABB base, not laid as a surface: it is a solid pile of
		# rubble 0.160 m tall, and laying it by its own upper face would bury it.
		_place_aligned(debris, Vector3(spot.x, SURFACE_LIFT, spot.y),
			float(index) * 0.8, "dressing", _dressing)
		index += 1


func set_dressing_visible(value: bool) -> void:
	dressing_visible = value
	_dressing.visible = value


# --- Placement helpers --------------------------------------------------------

## Instantiates one catalogue record and places it so its measured AABB centre
## lands on `at.x`/`at.z` and its measured AABB BASE lands on `at.y`. Scale is
## never touched, which is what makes "root scale 1.0" a fact about the scene
## rather than about the importer alone.
func _place_aligned(
	record: Dictionary, at: Vector3, yaw: float, layer: String, parent: Node3D
) -> Node3D:
	var node: Node3D = _instantiate(record, layer, parent)
	node.rotation = Vector3(0.0, yaw, 0.0)
	var rotated: AABB = Transform3D(Basis.from_euler(Vector3(0.0, yaw, 0.0)), Vector3.ZERO) \
		* _local_aabb(record)
	node.position = Vector3(
		at.x - rotated.get_center().x, at.y - rotated.position.y, at.z - rotated.get_center().z
	)
	return node


## Places a piece by its OWN ORIGIN, unadjusted. Four KayKit Forest models and the
## Halloween dead tree sit up to 0.463 m below their origin because the creator
## authored them to be planted rather than placed; this shows them planted and
## reports the offset instead of quietly correcting it.
func _plant(key: String, at: Vector3, yaw: float, parent: Node3D) -> Node3D:
	var record: Dictionary = ExteriorCohesionCatalogue.record_for(key)
	var layer: String = "anchor" if parent == _anchors else "architecture"
	var node: Node3D = _instantiate(record, layer, parent)
	node.position = at
	node.rotation = Vector3(0.0, yaw, 0.0)
	return node


## Lays a flat surface piece at its MEASURED horizontal surface height, never by
## its bounding box. `stack` separates surfaces that overlap, because a piece
## lowered so its top lies at exactly y = 0 is coplanar with the authored ground
## and disappears, and two flush pieces at the same height fight each other.
func _lay_surface(
	record: Dictionary, at: Vector2, yaw: float, layer: String, parent: Node3D, stack: int
) -> Node3D:
	var drop: float = _surface_drop(record)
	var node: Node3D = _instantiate(record, layer, parent)
	node.rotation = Vector3(0.0, yaw, 0.0)
	node.position = Vector3(at.x, drop + float(stack) * SURFACE_LIFT, at.y)
	return node


func _instantiate(record: Dictionary, layer: String, parent: Node3D) -> Node3D:
	var scene: PackedScene = load(String(record["path"])) as PackedScene
	assert(scene != null, "Gate 1B cohesion: %s failed to load" % record["path"])
	var node: Node3D = scene.instantiate() as Node3D
	node.name = "%s_%d" % [String(record["key"]).replace("-", "_"), placed.size()]
	parent.add_child(node)
	if treatment != null:
		treatment.register(node, String(record["display"]))
	var probe: Dictionary = ExteriorAssetProbe.measure(node)
	placed.append({
		"key": record["key"],
		"record": record,
		"node": node,
		"layer": layer,
		"primary": instances_of(String(record["key"])) == 0,
		"surface": FLAT_SURFACE_KEYS.has(String(record["key"])),
		"probe": probe,
	})
	return node


## The piece's local AABB, measured once per model and cached. Instantiating a
## probe copy for every one of several hundred placements would read the whole
## kit's geometry repeatedly.
func _local_aabb(record: Dictionary) -> AABB:
	var key: String = String(record["key"])
	if _aabb_cache.has(key):
		return _aabb_cache[key]
	var scene: PackedScene = load(String(record["path"])) as PackedScene
	var probe_node: Node3D = scene.instantiate() as Node3D
	var measured: Dictionary = ExteriorAssetProbe.measure(probe_node)
	var box: AABB = AABB(
		Vector3(measured["centre"].x - measured["size"].x * 0.5, measured["base_offset"],
			measured["centre"].z - measured["size"].z * 0.5),
		measured["size"]
	)
	probe_node.free()
	_aabb_cache[key] = box
	return box


## How far to move a flat surface piece so its real horizontal surface lies just
## above the authored ground. Derived from `dominant_surface_y()`, never typed —
## and NOT from the bounding box, for the measured reason recorded there.
func _surface_drop(record: Dictionary) -> float:
	var key: String = String(record["key"])
	if not surface_drops.has(key):
		var scene: PackedScene = load(String(record["path"])) as PackedScene
		var probe_node: Node3D = scene.instantiate() as Node3D
		surface_drops[key] = ExteriorAssetProbe.dominant_surface_y(probe_node)
		probe_node.free()
	return -float(surface_drops[key]) + SURFACE_LIFT


func _add_solid(solid_name: String, size: Vector3, at: Vector3, carve: bool) -> void:
	var shape: CollisionShape3D = CollisionShape3D.new()
	shape.name = solid_name
	var box: BoxShape3D = BoxShape3D.new()
	box.size = size
	shape.shape = box
	shape.position = at
	_collision.add_child(shape)
	_solids.append({"name": solid_name, "aabb": AABB(at - size * 0.5, size)})
	if not carve:
		return
	var obstacle: NavigationObstacle3D = NavigationObstacle3D.new()
	obstacle.name = "%sCarve" % solid_name
	obstacle.position = Vector3(at.x, 0.0, at.z)
	# A carve exactly as tall as the box it removes leaves the baked surface ON
	# its top face at the boundary, and a low wide proxy then keeps a walkable
	# island up there. The margin puts the top face unambiguously inside.
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


func _build_grid() -> void:
	var half: Vector2 = Vector2(SHOULDER_OUTER + 4.0, (ROUTE_TO_Z - ROUTE_FROM_Z) * 0.5 + 4.0)
	var centre: Vector2 = Vector2(0.0, (ROUTE_TO_Z + ROUTE_FROM_Z) * 0.5)
	var mesh: ImmediateMesh = ImmediateMesh.new()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	var minor: Color = Color(0.40, 0.56, 0.74, 0.42)
	var major: Color = Color(0.88, 0.58, 0.26, 0.80)
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	var x: float = centre.x - half.x
	while x <= centre.x + half.x + 0.001:
		mesh.surface_set_color(major if is_zero_approx(fmod(absf(x), 5.0)) else minor)
		mesh.surface_add_vertex(Vector3(x, 0.02, centre.y - half.y))
		mesh.surface_add_vertex(Vector3(x, 0.02, centre.y + half.y))
		x += 1.0
	var z: float = centre.y - half.y
	while z <= centre.y + half.y + 0.001:
		mesh.surface_set_color(major if is_zero_approx(fmod(absf(z), 5.0)) else minor)
		mesh.surface_add_vertex(Vector3(centre.x - half.x, 0.02, z))
		mesh.surface_add_vertex(Vector3(centre.x + half.x, 0.02, z))
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


func route_target() -> Vector3:
	return Vector3(ROUTE_TARGET.x, 0.0, ROUTE_TARGET.y)


func ground_rect() -> Rect2:
	return Rect2(GROUND_CENTRE - GROUND_EXTENT * 0.5, GROUND_EXTENT)


## The walkable corridor as built, widest step included.
## The region the navigation mesh is baked over: the route and its boundary, and
## nothing beyond it. The authored ground extends much further for framing, and
## baking that would produce a large unreachable walkable island.
func route_bake_rect() -> Rect2:
	var half: float = SHOULDER_OUTER + 1.0
	return Rect2(
		Vector2(-half, ROUTE_FROM_Z - CAP_THICKNESS - 1.0),
		Vector2(half * 2.0, (ROUTE_TO_Z - ROUTE_FROM_Z) + CAP_THICKNESS * 2.0 + 2.0)
	)


func route_rect() -> Rect2:
	var half: float = 0.0
	for step: Dictionary in CORRIDOR_STEPS:
		half = maxf(half, float(step["half_width"]))
	return Rect2(Vector2(-half, ROUTE_FROM_Z), Vector2(half * 2.0, ROUTE_TO_Z - ROUTE_FROM_Z))


## MEASURED off the two caps actually built, not repeated from the constants that
## asked for them: a cap one centimetre out of place moves this number.
func centreline_length_metres() -> float:
	var north: Dictionary = solid("CapNorth")
	var south: Dictionary = solid("CapSouth")
	if north.is_empty() or south.is_empty():
		return 0.0
	return (south["aabb"] as AABB).position.z - (north["aabb"] as AABB).end.z


## The threshold opening, MEASURED between the inner faces of the two gate
## stations. It is a constant of the route rather than of a family, so all three
## architecture modes are judged through the same gap.
func threshold_gap_metres() -> float:
	var west: Dictionary = solid("GateWest")
	var east: Dictionary = solid("GateEast")
	if west.is_empty() or east.is_empty():
		return 0.0
	return (east["aabb"] as AABB).position.x - (west["aabb"] as AABB).end.x


## The registered Dungeon doorway between the two `wall_pillar` proxy faces.
func dungeon_doorway_metres() -> float:
	var west: Dictionary = solid("DungeonPillarWest")
	var east: Dictionary = solid("DungeonPillarEast")
	if west.is_empty() or east.is_empty():
		return 0.0
	return (east["aabb"] as AABB).position.x - (west["aabb"] as AABB).end.x


## The narrowest clear width the corridor offers, measured across every authored
## step. Ordinary connectors are 6-10 P and combat lanes 14-22 P.
func narrowest_corridor_metres() -> float:
	var narrowest: float = 1e9
	for step: Dictionary in CORRIDOR_STEPS:
		narrowest = minf(narrowest, float(step["half_width"]) * 2.0)
	return narrowest


## The fraction of the route footprint that carries no collision-bearing
## decoration. The room-authoring blueprint's clear-ground rule applies even to a
## visual exercise, so it is measured rather than asserted by eye. The authored
## ground, the boundary shoulders, and the route caps are structure rather than
## decoration and are excluded; everything else inside the route counts.
func route_clear_fraction() -> float:
	var route: Rect2 = route_rect()
	var occupied: float = 0.0
	for entry: Dictionary in _solids:
		var solid_name: String = String(entry["name"])
		if solid_name == "Ground" or solid_name.begins_with("Shoulder") \
				or solid_name.begins_with("Cap"):
			continue
		var box: AABB = entry["aabb"]
		var footprint: Rect2 = Rect2(
			Vector2(box.position.x, box.position.z), Vector2(box.size.x, box.size.z)
		)
		occupied += footprint.intersection(route).get_area()
	return 1.0 - occupied / maxf(route.get_area(), 0.0001)


## Every architecture mesh whose world AABB reaches into the clear walking line.
## Empty is the only acceptable answer, in every mode: a family that cannot leave
## the spine clear is evidence against itself rather than permission to move the
## route.
func spine_intrusions() -> PackedStringArray:
	var spine: AABB = AABB(
		Vector3(-SPINE_HALF_WIDTH, 0.0, ROUTE_FROM_Z),
		Vector3(SPINE_HALF_WIDTH * 2.0, SPINE_HEIGHT, ROUTE_TO_Z - ROUTE_FROM_Z)
	)
	var found: PackedStringArray = PackedStringArray()
	for entry: Dictionary in placed:
		if bool(entry["surface"]):
			continue
		var node: Node3D = entry["node"]
		if not is_instance_valid(node):
			continue
		var probe: Dictionary = entry["probe"]
		var local: AABB = AABB(
			Vector3(probe["centre"].x - probe["size"].x * 0.5, probe["base_offset"],
				probe["centre"].z - probe["size"].z * 0.5),
			probe["size"]
		)
		var world: AABB = node.transform * local
		# Ground clutter is walked over, not around. The rule is the MEASURED
		# height of the piece rather than a per-piece flag, so a future dressing
		# object cannot be exempted by being labelled.
		if world.end.y <= GROUND_CLUTTER_HEIGHT:
			continue
		if world.intersects(spine):
			found.append("%s at (%.2f, %.2f)" % [
				entry["key"], node.position.x, node.position.z,
			])
	return found


func solids() -> Array[Dictionary]:
	return _solids


func solid(solid_name: String) -> Dictionary:
	for entry: Dictionary in _solids:
		if String(entry["name"]) == solid_name:
			return entry
	return {}


func station(station_name: String) -> Dictionary:
	for entry: Dictionary in STATIONS:
		if String(entry["name"]) == station_name:
			return entry
	return {}


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


## How many instances of one model sit in the ALWAYS-VISIBLE anchor layer. §5.1
## requires its permanent references to be retained in EVERY mode, and a piece
## that appears only inside one architecture family is not that — so the two
## questions are counted separately rather than through one total.
func anchor_instances_of(key: String) -> int:
	var total: int = 0
	for entry: Dictionary in placed:
		if String(entry["key"]) == key and String(entry["layer"]) == "anchor":
			total += 1
	return total


func instances_in_layer(layer: String) -> int:
	var total: int = 0
	for entry: Dictionary in placed:
		if String(entry["layer"]) == layer:
			total += 1
	return total


## Authored scene surfaces join the same treatment the candidates do, so F1 and F2
## change the whole picture rather than leaving a bright ground under a dark
## exterior. They are project-authored, so nothing third-party is involved.
func _register_authored(node: Node3D, label: String) -> void:
	if treatment != null:
		treatment.register(node, label)


func _authored_material(colour: Color) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = colour
	material.roughness = 1.0
	material.metallic = 0.0
	material.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	return material
