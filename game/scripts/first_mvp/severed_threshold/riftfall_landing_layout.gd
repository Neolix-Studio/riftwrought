class_name RiftfallLandingLayout
extends Node3D
## First-MVP Gate 1C — the authored geometry of Riftfall Landing (D-208 §6).
##
## THE ROUTE IS PROJECT-AUTHORED AND THE REGISTERED FAMILIES ARE DRESSED INTO IT.
## Every walkable surface, every boundary, every blocked footprint and every
## navigation carve belongs to authored geometry built here in code. A third-party
## payload supplies MESHES ONLY. That is the one structural idea Gate 1B proved
## and D-208 §6.4 restates: "Project-authored geometry owns topology. Visual
## meshes never silently define a different walkable route."
##
## AUTHORED IN A ROTATED LOCAL FRAME, ON PURPOSE. The accepted camera has a FIXED
## 45 degree yaw, so the direction "away from the camera" in world space is
## (-0.7071, 0, -0.7071) and nothing composed on the world axes runs up the
## screen. This node's parent carries a 45 degree yaw, so in the coordinates
## below:
##
##     -Z is straight AWAY from the camera (up the screen, toward Broken Watch)
##     +X is straight to the right of the screen
##
## Everything here — walkable rectangles, boundary banks, collision boxes and
## navigation carves — is axis-aligned in that frame, which keeps the geometry
## simple and the measurements exact while the composition reads as a road
## running into the distance. The camera itself is never rotated, retimed or
## railed: D-208 §2 forbids that and §5 keeps 19 m / 55 deg / 45 deg.
##
## THE FOUR BEATS OF §6.2 ARE THE FIVE WALKABLE REGIONS BELOW.
##
##     RiftScar          safe arrival, deliberately open
##     ProcessionLower   first bearing, the broken road begins
##     ProcessionBend    broken procession; the repeating stone sits in its pocket
##     WatchApproach     architecture grows denser and darker
##     BreachAndBeyond   the 8 m Watch breach and honest ground past it
##
## COLLISION FOLLOWS READABLE SILHOUETTES (paper design §7). Boundary banks, the
## breach masses, the procession kerb, tree trunks and substantial rocks own one
## authored box each and carve the navigation mesh. Small rubble, path pieces,
## dirt, the repeating stone and every Kenney Graveyard dressing piece are
## non-blocking and carve nothing, which is exactly the arrangement D-206 accepted.
##
## AND EVERY SOLID CARVES. Gate 1A's sharpest finding: a box whose TOP lies
## outside the bake volume rasterises as an open-topped well with a walkable
## interior, and the phantom island survives agent-radius erosion whenever the box
## is deeper than 2 x radius = 0.80 m. Every boundary bank here is.

const WORLD_LAYER: int = 1

## Flush means "flush plus this": a surface lowered so its top lies at exactly
## y = 0 is coplanar with the authored ground and disappears. Two orders of
## magnitude below the 0.20 m navigation climb limit.
const SURFACE_LIFT: float = 0.008
## How far above a solid's own top face its navigation carve extends. A carve
## exactly as tall as its box leaves the baked surface ON the top face at the
## boundary, and a low wide proxy then keeps a walkable island up there.
const CARVE_MARGIN: float = 0.50
const GROUND_THICKNESS: float = 0.40
## Ground clutter this low is walked over rather than around, so it does not count
## as an intrusion into the clear walking line. The rule is the MEASURED height of
## the piece rather than a per-piece flag, so a future dressing object cannot be
## exempted by being labelled — Gate 1B's lesson, kept.
const GROUND_CLUTTER_HEIGHT: float = 0.30

## The whole authored review footprint: walkable regions, boundary banks and the
## ground solid beneath both. The navigation bake is clipped to exactly this.
const ARENA: Rect2 = Rect2(Vector2(-21.0, -41.0), Vector2(42.0, 79.0))

## §6.1's principal movement footprint, as five overlapping authored rectangles.
## Their union area is measured by exact rectangle sweep in `footprint_area()`,
## never typed.
const WALKABLE: Array[Dictionary] = [
	{"name": "RiftScar", "rect": Rect2(Vector2(-16.0, 12.0), Vector2(30.0, 21.0)),
		"beat": "1 Rift Scar — safe arrival"},
	{"name": "ProcessionLower", "rect": Rect2(Vector2(-6.0, -4.0), Vector2(13.0, 18.0)),
		"beat": "2 First Bearing — the broken road begins"},
	{"name": "ProcessionBend", "rect": Rect2(Vector2(-2.0, -12.0), Vector2(17.0, 12.0)),
		"beat": "3 Broken Procession — the repeating stone"},
	{"name": "WatchApproach", "rect": Rect2(Vector2(3.0, -22.0), Vector2(13.0, 12.0)),
		"beat": "4 Watch Breach — denser, darker"},
	{"name": "BreachAndBeyond", "rect": Rect2(Vector2(4.0, -36.0), Vector2(12.0, 16.0)),
		"beat": "4 Watch Breach — honest ground beyond"},
]

## The boundary. Together these tile ARENA minus the walkable union exactly, which
## is asserted rather than assumed: the verification samples a lattice and
## requires every point to be either walkable or inside a bank.
##
## The heights rise from a low lip at the arrival to tall dark masses at the
## breach, which is §6.2 beat 4's "architecture grows denser and darker" expressed
## in the terrain rather than only in the dressing. Nothing here is climbable:
## every bank is far above the 0.20 m navigation climb limit and each one carves.
const BANKS: Array[Dictionary] = [
	{"name": "BankArrivalRidge", "rect": Rect2(Vector2(-21.0, 33.0), Vector2(42.0, 5.0)),
		"height": 3.4},
	{"name": "BankScarWest", "rect": Rect2(Vector2(-21.0, 12.0), Vector2(5.0, 21.0)),
		"height": 1.8},
	{"name": "BankScarEast", "rect": Rect2(Vector2(14.0, 12.0), Vector2(7.0, 21.0)),
		"height": 2.4},
	{"name": "BankProcessionWest", "rect": Rect2(Vector2(-21.0, -4.0), Vector2(15.0, 16.0)),
		"height": 2.8},
	{"name": "BankProcessionEast", "rect": Rect2(Vector2(7.0, 0.0), Vector2(14.0, 12.0)),
		"height": 2.8},
	{"name": "BankBendWest", "rect": Rect2(Vector2(-21.0, -12.0), Vector2(19.0, 8.0)),
		"height": 3.2},
	{"name": "BankBendEast", "rect": Rect2(Vector2(15.0, -10.0), Vector2(6.0, 10.0)),
		"height": 3.2},
	{"name": "BankApproachWest", "rect": Rect2(Vector2(-21.0, -22.0), Vector2(24.0, 10.0)),
		"height": 3.6},
	{"name": "BankApproachEast", "rect": Rect2(Vector2(16.0, -22.0), Vector2(5.0, 12.0)),
		"height": 3.6},
	{"name": "BankBreachWest", "rect": Rect2(Vector2(-21.0, -36.0), Vector2(25.0, 14.0)),
		"height": 4.2},
	{"name": "BankBreachEast", "rect": Rect2(Vector2(16.0, -36.0), Vector2(5.0, 14.0)),
		"height": 4.2},
	{"name": "BankFarWatch", "rect": Rect2(Vector2(-21.0, -41.0), Vector2(42.0, 5.0)),
		"height": 4.5},
]

## §6.2 beat 4. Two authored masses inside the corridor, and the gap between their
## inner faces IS the Watch breach. It is measured off the built collision boxes
## in `breach_clearance()`, so a mass one centimetre out of place moves it.
const BREACH_MASSES: Array[Dictionary] = [
	{"name": "BreachMassWest", "rect": Rect2(Vector2(4.0, -27.5), Vector2(2.0, 3.0)),
		"height": 5.0},
	{"name": "BreachMassEast", "rect": Rect2(Vector2(14.0, -27.5), Vector2(2.0, 3.0)),
		"height": 5.0},
]

## Route-defining masses inside the walkable footprint. Each owns one authored
## collision box and one carve, and each is dressed with registered meshes. Every
## one of them is kept clear of the centreline by at least
## MINIMUM_SOLID_CLEARANCE, which is what keeps §6.1's "narrowest mandatory
## clearance at least 8.0 m" true away from the breach.
const ROUTE_MASSES: Array[Dictionary] = [
	{"name": "ScarShoulderStack", "rect": Rect2(Vector2(4.4, 21.0), Vector2(4.4, 3.0)),
		"height": 2.6},
	{"name": "ScarFallenWall", "rect": Rect2(Vector2(-12.6, 15.6), Vector2(5.0, 1.6)),
		"height": 2.2},
	{"name": "ProcessionRuinWest", "rect": Rect2(Vector2(-6.0, 3.4), Vector2(1.4, 1.4)),
		"height": 3.0},
	{"name": "ProcessionRuinEast", "rect": Rect2(Vector2(5.2, 6.6), Vector2(1.8, 1.4)),
		"height": 3.0},
	{"name": "ProcessionKerb", "rect": Rect2(Vector2(11.05, -5.65), Vector2(3.9, 2.3)),
		"height": 0.95},
	{"name": "BendRuinWest", "rect": Rect2(Vector2(-2.0, -10.2), Vector2(2.2, 1.6)),
		"height": 2.8},
	{"name": "ApproachRuinWest", "rect": Rect2(Vector2(3.0, -16.4), Vector2(2.2, 3.6)),
		"height": 3.4},
	{"name": "ApproachRuinEast", "rect": Rect2(Vector2(14.4, -20.0), Vector2(2.0, 3.0)),
		"height": 3.4},
	{"name": "BreachTrunkWest", "rect": Rect2(Vector2(4.6, -32.4), Vector2(1.0, 1.0)),
		"height": 3.0},
]

## Nothing collision-bearing may come closer than this to the route centreline,
## except the two breach masses, whose 8.000 m gap is the authored narrowest
## clearance §6.1 asks for. 4.2 m each side leaves 8.4 m everywhere else.
const MINIMUM_SOLID_CLEARANCE: float = 4.2

## §6.1's route centreline, in this rotated local frame. Measured, not typed:
## `centreline_length()` reads it back off the points below.
const CENTRELINE: Array[Vector2] = [
	Vector2(-3.0, 18.0),
	Vector2(0.5, 12.0),
	Vector2(0.5, -1.0),
	Vector2(4.5, -6.0),
	Vector2(9.5, -11.0),
	Vector2(10.0, -20.0),
	Vector2(10.0, -26.0),
	Vector2(10.0, -31.0),
]
const SPAWN_INDEX: int = 0
const BREACH_INDEX: int = 6
const EXIT_INDEX: int = 7

## The clear walking line no collision-bearing mesh may reach into.
const SPINE_HALF_WIDTH: float = 2.0
const SPINE_HEIGHT: float = 2.2

## Width sampling along the centreline, for §6.1's ordinary and narrowest widths.
const WIDTH_SAMPLE_STEP: float = 0.5
const WIDTH_MARCH_STEP: float = 0.05
const WIDTH_MARCH_LIMIT: float = 34.0
const ORDINARY_WIDTH_MIN: float = 10.0
const ORDINARY_WIDTH_MAX: float = 14.0

# --- The exact §6.3 payload allowlist ----------------------------------------
## THIS IS AN ALLOWLIST, NOT A SECOND ASSET CATALOGUE. It carries no archive, no
## SHA-256, no licence text and no source map: Gate 1B already proves every one of
## those file by file, and D-208 §11.1 forbids duplicating them here. What it does
## carry is the thing Gate 1B cannot know — which of the approved payloads this
## canonical scene uses, how each one meets the ground, and whether it blocks.
##
## The fourth registered Dungeon piece — the 2.500 m corner block — is permitted by
## §6.3 and deliberately NOT used. The closed Gate 1A smoke runner's first-MVP
## asset allowlist recognises only `floor_tile_large`, `wall` and `wall_pillar`
## from that kit, and §11.2 forbids changing an assertion there, so using the
## corner block would have failed a closed gate for a piece this composition does
## not need. Its exact filename is deliberately not written anywhere in Gate 1C,
## because the suite scans these files RAW for asset names it must not carry.
const FAMILY_DUNGEON: String = "KayKit Dungeon Asset Pack 1.1 FREE"
const FAMILY_FOREST: String = "KayKit Forest Nature Pack 1.0 FREE"
const FAMILY_HALLOWEEN: String = "KayKit Halloween Bits 1.0 FREE"
const FAMILY_GRAVEYARD: String = "Kenney Graveyard Kit 5.0"

## `contact` is §6.4's "determine contact from the intended ground contact, not
## blindly from the entire AABB":
##   surface — laid at its MEASURED horizontal surface height
##             (`ExteriorAssetProbe.dominant_surface_y()`), never by its box;
##   base    — placed so its measured AABB base meets the authored ground;
##   plant   — placed by its OWN origin, unadjusted, because KayKit authored it to
##             be planted and the measured below-origin pivot is deliberate.
const PAYLOADS: Array[Dictionary] = [
	{"key": "floor_tile_large", "family": FAMILY_DUNGEON, "contact": "surface",
		"path": "res://assets/third_party/kaykit/dungeon/floor_tile_large.gltf",
		"role": "Bastion paving apron through and beyond the Watch breach"},
	{"key": "wall", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall.gltf",
		"role": "Watch curtain masonry on the breach masses and approach banks"},
	{"key": "wall_pillar", "family": FAMILY_DUNGEON, "contact": "base",
		"path": "res://assets/third_party/kaykit/dungeon/wall_pillar.gltf",
		"role": "the two piers that face the Watch breach"},
	{"key": "Tree_Bare_1_C_Color1", "family": FAMILY_FOREST, "contact": "plant",
		"path": "res://assets/third_party/kaykit/forest/Tree_Bare_1_C_Color1.gltf",
		"role": "sparse bare framing on the banks and two route-side trunks"},
	{"key": "Tree_Bare_2_C_Color1", "family": FAMILY_FOREST, "contact": "plant",
		"path": "res://assets/third_party/kaykit/forest/Tree_Bare_2_C_Color1.gltf",
		"role": "tall bare framing behind the arrival and along the procession"},
	{"key": "Rock_1_A_Color1", "family": FAMILY_FOREST, "contact": "base",
		"path": "res://assets/third_party/kaykit/forest/Rock_1_A_Color1.gltf",
		"role": "small ground rocks, edge clusters"},
	{"key": "Rock_1_Q_Color1", "family": FAMILY_FOREST, "contact": "base",
		"path": "res://assets/third_party/kaykit/forest/Rock_1_Q_Color1.gltf",
		"role": "large bank outcrops that break the boundary silhouette"},
	{"key": "Rock_3_A_Color1", "family": FAMILY_FOREST, "contact": "plant",
		"path": "res://assets/third_party/kaykit/forest/Rock_3_A_Color1.gltf",
		"role": "half-buried route rocks; authored 0.465 m below its own origin"},
	{"key": "floor_dirt", "family": FAMILY_HALLOWEEN, "contact": "surface",
		"path": "res://assets/third_party/kaykit/halloween/floor_dirt.gltf",
		"role": "the broken procession road bed"},
	{"key": "path_A", "family": FAMILY_HALLOWEEN, "contact": "surface",
		"path": "res://assets/third_party/kaykit/halloween/path_A.gltf",
		"role": "surviving road stones down the centreline"},
	{"key": "path_C", "family": FAMILY_HALLOWEEN, "contact": "surface",
		"path": "res://assets/third_party/kaykit/halloween/path_C.gltf",
		"role": "surviving road stones down the centreline"},
	{"key": "arch", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/arch.gltf",
		"role": "displaced ceremonial arch; a LANDMARK on the bank, never the route"},
	{"key": "fence_broken", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/fence_broken.gltf",
		"role": "the ruined ceremonial edge of the procession"},
	{"key": "fence_pillar_broken", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/fence_pillar_broken.gltf",
		"role": "the posts that survived that edge"},
	{"key": "tree_dead_large", "family": FAMILY_HALLOWEEN, "contact": "plant",
		"path": "res://assets/third_party/kaykit/halloween/tree_dead_large.gltf",
		"role": "dead trees framing the road and the breach"},
	{"key": "lantern_standing", "family": FAMILY_HALLOWEEN, "contact": "base",
		"path": "res://assets/third_party/kaykit/halloween/lantern_standing.gltf",
		"role": "four surviving road lanterns; the only warm light in the Landing"},
	{"key": "stone-wall-damaged", "family": FAMILY_GRAVEYARD, "contact": "base",
		"path": "res://assets/third_party/kenney/graveyard/stone-wall-damaged.glb",
		"role": "sparse damage dressing on the banks; blocks nothing, carves nothing"},
	{"key": "stone-wall-column", "family": FAMILY_GRAVEYARD, "contact": "base",
		"path": "res://assets/third_party/kenney/graveyard/stone-wall-column.glb",
		"role": "the ends of those damaged runs; blocks nothing, carves nothing"},
	{"key": "debris", "family": FAMILY_GRAVEYARD, "contact": "base",
		"path": "res://assets/third_party/kenney/graveyard/debris.glb",
		"role": "ground rubble; a solid pile 0.160 m tall, walked over, never laid as a surface"},
]

## Kenney's Graveyard kit is CC0 and needs no attribution; the project credits it
## anyway, exactly as the register prefers. KayKit is likewise CC0. No CC BY
## family is used by Riftfall Landing.
const CREDIT_KAYKIT: String = "Dungeon, Forest Nature and Halloween Bits by Kay Lousberg (KayKit), CC0 1.0."
const CREDIT_KENNEY: String = "Graveyard Kit by Kenney (www.kenney.nl), CC0 1.0."

# --- Authored colours ---------------------------------------------------------
## Project-authored terrain and masonry, quiet and cool so the accepted treatment
## has something honest to act on rather than a colour already chosen for it.
## MEASURED OFF THE RENDERED EVIDENCE, not chosen on paper, and corrected twice.
##
## The treatment multiplies value by 0.62 and the accepted exterior ambient is
## deliberately low, so an authored albedo that reads as "stone" in an editor
## viewport renders far darker than a KayKit surface beside it — and this Landing's
## boundary is 1.8 to 4.5 m of vertical authored terrain seen edge-on, which Gate
## 1B's 1.00 m shoulders never presented.
##
## The second correction came from SAMPLING THE RENDERED PIXELS rather than from
## reasoning about them. At the first pass the authored ground rendered at
## (49, 56, 78) while a treated KayKit `floor_dirt` module lying on it rendered at
## (109, 113, 138) — the road was 2.2x brighter than the world it crossed, which is
## why the whole space read as bright paving floating on a void. The values below
## put the authored terrain in the same material family as the registered pieces,
## which is what "reads as one authored place rather than a playground of packs"
## means in numbers.
const COLOUR_SURROUND: Color = Color(0.380, 0.390, 0.410)
const COLOUR_GROUND: Color = Color(0.720, 0.700, 0.660)
const COLOUR_BANK: Color = Color(0.700, 0.676, 0.630)
## The bank caps catch the key light where the faces cannot, which is what stops a
## tall boundary reading as a hole in the world.
const COLOUR_BANK_CAP: Color = Color(0.790, 0.762, 0.706)
const COLOUR_MASS: Color = Color(0.760, 0.742, 0.710)
const COLOUR_WATCH: Color = Color(0.520, 0.528, 0.552)
const COLOUR_SCAR: Color = Color(0.540, 0.470, 0.600)
## Broken ground at the scar edge, kept below the terrain value so it reads as
## fractured earth rather than as clean fallen panels.
const COLOUR_SCAR_SHARD: Color = Color(0.640, 0.620, 0.590)
const COLOUR_RIFT: Color = Color(0.482, 0.286, 0.702)

var treatment: ExteriorReviewTreatment
var lighting: ExteriorReviewLighting

var loop_event: RiftfallLoopEvent

@export var grid_visible: bool = false
@export var diagnostics_visible: bool = false

var _visuals: Node3D
var _collision: StaticBody3D
var _obstacles: Node3D
var _sockets: Node3D
var _grid: MeshInstance3D
var _diagnostics: Node3D

## Every instance this layout placed.
var placed: Array[Dictionary] = []
## Every world-layer collision box, in layout-local space, recorded as it is added
## so measurements read the built world rather than the authored intent.
var _solids: Array[Dictionary] = []
## The measured horizontal surface height of every `surface` piece, in the piece's
## own local space, so the report states them rather than the bounding boxes that
## would have been wrong.
var surface_drops: Dictionary = {}
var _aabb_cache: Dictionary = {}
var _socket_nodes: Dictionary = {}
## Computed once at build. The overlay redraws every frame and a width sample
## marches thousands of points.
var _width_samples: Array[Dictionary] = []
var _authored_surfaces: int = 0
var _unregistered_authored_surfaces: int = 0


func build(
	review_treatment: ExteriorReviewTreatment, review_lighting: ExteriorReviewLighting
) -> void:
	treatment = review_treatment
	lighting = review_lighting

	for child: Node in get_children():
		child.free()
	placed.clear()
	_solids.clear()
	surface_drops.clear()
	_aabb_cache.clear()
	_socket_nodes.clear()
	_width_samples.clear()
	_authored_surfaces = 0
	_unregistered_authored_surfaces = 0

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

	_sockets = Node3D.new()
	_sockets.name = "Sockets"
	add_child(_sockets)

	_build_ground()
	_build_banks()
	_build_masses()
	_build_watch_silhouette()
	_build_rift_scar()
	_build_road_surfaces()
	_build_procession_dressing()
	_build_watch_architecture()
	_build_forest_framing()
	_build_graveyard_dressing()
	_build_loop_event()
	_build_sockets()
	_build_grid()
	_build_diagnostics()
	_measure_widths()


# --- Authored ground, boundary and masses -------------------------------------

func _build_ground() -> void:
	# A far darker plane beyond the authored footprint. A finite ground's boundary
	# reaches the corner of a wide frame however far it is pushed out, and a
	# boundary that reads as distant ground is honest while one that reads as a
	# hole is a distraction in every picture the owner judges.
	var surround: MeshInstance3D = MeshInstance3D.new()
	surround.name = "SurroundPlane"
	var surround_mesh: PlaneMesh = PlaneMesh.new()
	surround_mesh.size = Vector2(700.0, 700.0)
	surround.mesh = surround_mesh
	# Assigned to the MESH rather than through `material_override`, deliberately:
	# `material_override` outranks a per-surface override, so an authored surface
	# set that way would ignore the exterior treatment and stay bright while
	# everything around it darkened.
	surround_mesh.material = _authored_material(COLOUR_SURROUND)
	surround.position = Vector3(ARENA.get_center().x, -0.12, ARENA.get_center().y)
	surround.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_visuals.add_child(surround)
	_register_authored(surround, "authored surround plane")

	var ground: MeshInstance3D = MeshInstance3D.new()
	ground.name = "AuthoredGround"
	var ground_mesh: PlaneMesh = PlaneMesh.new()
	ground_mesh.size = ARENA.size
	ground.mesh = ground_mesh
	ground_mesh.material = _authored_material(COLOUR_GROUND)
	ground.position = Vector3(ARENA.get_center().x, 0.0, ARENA.get_center().y)
	ground.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_visuals.add_child(ground)
	_register_authored(ground, "authored ground")

	_add_solid("Ground", Vector3(ARENA.size.x, GROUND_THICKNESS, ARENA.size.y),
		Vector3(ARENA.get_center().x, -GROUND_THICKNESS * 0.5, ARENA.get_center().y), false)


func _build_banks() -> void:
	var group: Node3D = Node3D.new()
	group.name = "BoundaryBanks"
	_visuals.add_child(group)
	for bank: Dictionary in BANKS:
		var rect: Rect2 = bank["rect"]
		var height: float = float(bank["height"])
		var centre: Vector3 = Vector3(
			rect.get_center().x, height * 0.5, rect.get_center().y
		)
		var size: Vector3 = Vector3(rect.size.x, height, rect.size.y)
		_add_solid(String(bank["name"]), size, centre, true)
		_add_box_visual(group, "%sVisual" % String(bank["name"]), size, centre,
			COLOUR_BANK, "authored boundary bank")
		# A slightly inset, slightly lighter cap. It has no collision and no carve —
		# the bank beneath already owns both — and it exists so the boundary reads
		# as raised ground catching the key light rather than as a flat void.
		_add_box_visual(group, "%sCap" % String(bank["name"]),
			Vector3(maxf(size.x - 0.7, 0.4), 0.34, maxf(size.z - 0.7, 0.4)),
			centre + Vector3(0.0, height * 0.5, 0.0), COLOUR_BANK_CAP,
			"authored bank cap")


func _build_masses() -> void:
	var group: Node3D = Node3D.new()
	group.name = "RouteMasses"
	_visuals.add_child(group)
	for mass: Dictionary in BREACH_MASSES + ROUTE_MASSES:
		var rect: Rect2 = mass["rect"]
		var height: float = float(mass["height"])
		var centre: Vector3 = Vector3(rect.get_center().x, height * 0.5, rect.get_center().y)
		var size: Vector3 = Vector3(rect.size.x, height, rect.size.y)
		_add_solid(String(mass["name"]), size, centre, true)
		_add_box_visual(group, "%sVisual" % String(mass["name"]), size, centre,
			COLOUR_MASS, "authored route mass")

	# The procession kerb carries the repeating stone. Its collision is the low
	# readable plinth above; these two authored pieces are what the eye reads, and
	# the tilted slab IS the shallow grade §7 asks the stone to roll down.
	var kerb: Node3D = Node3D.new()
	kerb.name = "ProcessionKerbFace"
	group.add_child(kerb)
	_add_box_visual(kerb, "KerbBase", Vector3(3.6, 0.42, 2.2),
		Vector3(12.9, 0.21, -4.5), COLOUR_MASS, "authored procession kerb")
	var slab: MeshInstance3D = _add_box_visual(kerb, "KerbGrade", Vector3(4.0, 0.20, 2.0),
		Vector3(13.05, 0.48, -4.5), COLOUR_MASS, "authored procession grade")
	slab.rotation = Vector3(0.0, 0.0, RiftfallLoopEvent.GRADE_RADIANS)


## §6.2 beat 2, REBUILT AFTER A MEASUREMENT THAT CONTRADICTED THE BRIEF.
##
## The first version put a 28 m keep 40 m up the route on the assumption that a
## tall enough object seen from far enough away reads as a distant silhouette.
## MEASURED, on the accepted 19 m / 55 degree / 45 degree camera: it does not, and
## it cannot. That camera's top ray leaves it 32.5 degrees below horizontal, so the
## horizon is never in frame; at horizontal distance h from the camera the top of
## the picture is at y = 15.564 - 0.6371 h, which reaches ground level 24.43 m from
## the camera — 13.53 m ahead of the body — and goes NEGATIVE beyond it. Past that
## point everything at or above ground level is off the TOP of the frame, and being
## taller only pushes it further off. A 28 m keep 40 m away is exactly as invisible
## as a pebble there.
##
## So the Watch is built where it can actually be seen: a wall that rises across
## the whole far end of the space, immediately beyond the last walkable metre,
## whose lower five to eight metres fill the top of the frame as the player crosses
## the breach and reaches the exit socket. The upper masses are kept because the
## review camera can be pulled back to 40 m with `]`, where they do come into view.
##
## Nothing here has collision, nothing is walkable, and no enemy, encounter or
## interaction exists past the breach. It is scenery that says where the route
## goes; it is not Broken Watch.
func _build_watch_silhouette() -> void:
	var group: Node3D = Node3D.new()
	group.name = "WatchSilhouette"
	_visuals.add_child(group)
	var pieces: Array[Dictionary] = [
		{"name": "WatchOuterWall", "size": Vector3(34.0, 7.2, 4.0),
			"at": Vector3(10.0, 3.6, -38.0)},
		{"name": "WatchFace", "size": Vector3(16.0, 14.0, 5.0),
			"at": Vector3(10.0, 7.0, -41.0)},
		{"name": "WatchTowerWest", "size": Vector3(7.0, 17.0, 6.0),
			"at": Vector3(-1.0, 8.5, -42.0)},
		{"name": "WatchTowerEast", "size": Vector3(7.0, 15.0, 6.0),
			"at": Vector3(21.0, 7.5, -42.0)},
		{"name": "WatchCrown", "size": Vector3(10.0, 9.0, 5.0),
			"at": Vector3(10.0, 18.5, -44.0)},
	]
	for piece: Dictionary in pieces:
		_add_box_visual(group, String(piece["name"]), piece["size"], piece["at"],
			COLOUR_WATCH, "authored Watch massing")


## §6.2 beat 1. A change in ground treatment rather than a pit: the principal
## route stays one continuous readable plane (paper design §3), so the scar is a
## stain, a low authored rim of broken ground, and restrained Rift residue.
func _build_rift_scar() -> void:
	var group: Node3D = Node3D.new()
	group.name = "RiftScar"
	_visuals.add_child(group)

	# MEASURED AGAINST THE FIRST RENDERED EVIDENCE RUN: one large dark ellipse read
	# as a hole cut in the ground rather than as a scar. Three overlapping lobes at
	# different scales and angles, at a lighter violet-grey, read as scorched and
	# fractured ground instead — asymmetrical, as §6.2 beat 1 asks.
	var lobes: Array[Dictionary] = [
		{"at": Vector3(-3.6, 0.011, 19.4), "radius": 4.6, "scale": Vector3(1.0, 1.0, 0.80),
			"yaw": 0.0},
		{"at": Vector3(-6.9, 0.012, 22.1), "radius": 2.8, "scale": Vector3(1.0, 1.0, 0.72),
			"yaw": 0.72},
		{"at": Vector3(-0.6, 0.013, 17.0), "radius": 2.2, "scale": Vector3(1.0, 1.0, 0.66),
			"yaw": -0.48},
	]
	for lobe: Dictionary in lobes:
		var stain: MeshInstance3D = MeshInstance3D.new()
		stain.name = "ScarStain%d" % group.get_child_count()
		var disc: CylinderMesh = CylinderMesh.new()
		disc.top_radius = float(lobe["radius"])
		disc.bottom_radius = float(lobe["radius"])
		disc.height = 0.02
		disc.radial_segments = 22
		stain.mesh = disc
		disc.material = _authored_material(COLOUR_SCAR)
		stain.position = lobe["at"]
		stain.scale = lobe["scale"]
		stain.rotation = Vector3(0.0, float(lobe["yaw"]), 0.0)
		stain.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		group.add_child(stain)
		_register_authored(stain, "authored Rift scar stain")

	# Asymmetrical broken ground around it. Low enough to be walked over — under
	# the measured ground-clutter height — so the arrival envelope stays clear.
	var shards: Array[Dictionary] = [
		{"size": Vector3(3.2, 0.22, 1.4), "at": Vector3(-8.6, 0.11, 22.6), "yaw": 0.42},
		{"size": Vector3(2.4, 0.18, 1.2), "at": Vector3(1.9, 0.09, 22.2), "yaw": -0.28},
		{"size": Vector3(2.8, 0.26, 1.6), "at": Vector3(-7.2, 0.13, 15.6), "yaw": 1.02},
		{"size": Vector3(1.8, 0.16, 1.0), "at": Vector3(2.6, 0.08, 16.4), "yaw": 0.66},
	]
	for shard: Dictionary in shards:
		var mesh: MeshInstance3D = _add_box_visual(group, "ScarShard%d" % group.get_child_count(),
			shard["size"], shard["at"], COLOUR_SCAR_SHARD, "authored scar shard")
		mesh.rotation = Vector3(0.0, float(shard["yaw"]), 0.0)

	# The Rift residue. Restrained, local, and deliberately NOT graded by the
	# exterior treatment — see COLOUR_RIFT.
	for at: Vector3 in [
		Vector3(-3.6, 0.03, 19.4), Vector3(-6.4, 0.03, 21.8), Vector3(-0.4, 0.03, 17.2),
	]:
		var ring: MeshInstance3D = MeshInstance3D.new()
		ring.name = "ScarResidue%d" % group.get_child_count()
		var torus: TorusMesh = TorusMesh.new()
		torus.inner_radius = 0.62
		torus.outer_radius = 0.84
		torus.rings = 18
		ring.mesh = torus
		ring.material_override = _rift_material(0.34)
		ring.position = at
		ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		group.add_child(ring)
		_unregistered_authored_surfaces += 1


# --- Registered payload placement ---------------------------------------------

## The broken road: `floor_dirt` on its own measured 4.000 m module, laid only
## where the road runs, so the Landing reads as a damaged causeway across open
## ground rather than as a fully paved courtyard.
func _build_road_surfaces() -> void:
	var group: Node3D = Node3D.new()
	group.name = "RoadSurfaces"
	_visuals.add_child(group)

	# MEASURED AGAINST THE FIRST RENDERED EVIDENCE RUN: laid on a strict 4 m grid,
	# the module's own edge seams line up across the whole road and read as a tiled
	# floor. Alternate rows are offset by half a module and every other row is
	# turned a quarter turn, which breaks both the seam lines and the repeated
	# pebble pattern without moving a single walkable metre.
	var dirt: Dictionary = payload("floor_dirt")
	var row: int = 0
	var z: float = -34.0
	while z <= 34.0:
		var x: float = -18.0 + (2.0 if row % 2 == 1 else 0.0)
		while x <= 18.0:
			var at: Vector2 = Vector2(x, z)
			if _is_walkable(at) and distance_to_centreline(at) <= 5.4:
				_lay_surface(dirt, at, PI * 0.5 * float((row + int(x)) % 4), "road", group, 0)
			x += 4.0
		z += 4.0
		row += 1

	# Surviving road stones down the centreline itself, following its direction.
	var stones: Array[Dictionary] = [payload("path_A"), payload("path_C")]
	var index: int = 0
	var along: float = 3.0
	var total: float = centreline_length()
	while along <= total - 3.0:
		var point: Vector2 = centreline_point(along)
		var ahead: Vector2 = centreline_point(minf(along + 1.0, total))
		var yaw: float = atan2(ahead.x - point.x, ahead.y - point.y)
		_lay_surface(stones[index % 2], point, yaw, "road", group, 1)
		index += 1
		along += 1.9

	# The Bastion's own paving carries the breach and the ground beyond it, which
	# is where the Landing hands the route to Broken Watch.
	var apron: Dictionary = payload("floor_tile_large")
	for ix: int in 3:
		for iz: int in 3:
			_lay_surface(apron, Vector2(6.0 + float(ix) * 4.0, -24.0 - float(iz) * 4.0),
				0.0, "road", group, 0)


## The ruined ceremonial edge of §6.2 beat 3: people once entered the Bastion here
## in order, and the present route is torn open rather than maintained.
func _build_procession_dressing() -> void:
	var group: Node3D = Node3D.new()
	group.name = "ProcessionEdge"
	_visuals.add_child(group)

	# MEASURED AGAINST THE FIRST RENDERED EVIDENCE RUN. Twelve pieces in two even
	# runs read as intact cemetery ironwork, which is exactly the theme D-206
	# rejected; five, unevenly spaced and leaning, read as the last of a ceremonial
	# edge. All of them stand on the already-blocked west bank, so the layer owns no
	# collision and carves nothing.
	var fence: Dictionary = payload("fence_broken")
	var post: Dictionary = payload("fence_pillar_broken")
	var edge: Array[Dictionary] = [
		{"record": fence, "at": Vector3(-7.4, 2.8, 8.8), "yaw": 0.04},
		{"record": post, "at": Vector3(-7.5, 2.8, 6.4), "yaw": -0.18},
		{"record": fence, "at": Vector3(-7.4, 2.8, 2.2), "yaw": -0.06},
		{"record": post, "at": Vector3(-7.2, 2.8, -0.4), "yaw": 0.34},
		{"record": post, "at": Vector3(-7.6, 2.8, 11.6), "yaw": 0.12},
	]
	for piece: Dictionary in edge:
		_place_aligned(piece["record"], piece["at"], float(piece["yaw"]),
			"procession", group)

	# §6.4: the 3.000 m Halloween arch is a DISPLACED LANDMARK, never the route.
	# It stands on the eastern bend bank, turned across the road so its opening
	# faces the boundary rather than the walking line, well outside the walkable
	# footprint. The verification asserts both facts.
	_place_aligned(payload("arch"), Vector3(17.4, 3.2, -6.2), 0.0, "procession", group)

	# The four surviving road lanterns, and the only warm light in the Landing.
	# A 0.925 m standing lantern is a real object, so each owns an authored
	# collision box and a carve, and each is kept clear of the walking line: a
	# lantern the body walks through would be exactly the "visual mesh silently
	# defining a different route" §6.4 forbids.
	for at: Vector2 in [Vector2(-4.8, 9.6), Vector2(6.4, 1.2), Vector2(13.2, -8.0),
			Vector2(14.6, -19.0)]:
		var stand: Vector3 = Vector3(at.x, 0.0, at.y)
		_place_aligned(payload("lantern_standing"), stand, 0.0, "procession", group)
		_add_solid("Lantern%.0f" % (at.y * 10.0), Vector3(0.64, 0.93, 0.64),
			stand + Vector3(0.0, 0.465, 0.0), true)
		if lighting != null:
			lighting.add_lantern(_to_world(stand + Vector3(0.0, 0.86, 0.0)))


## §6.2 beat 4 and §6.4: "The Watch transition is the project-authored broad
## breach supported by KayKit Dungeon architecture." The masonry faces the two
## authored breach masses; it does not define the opening, and switching it off
## would not move the 8.000 m gap by a millimetre.
func _build_watch_architecture() -> void:
	var group: Node3D = Node3D.new()
	group.name = "WatchArchitecture"
	_visuals.add_child(group)

	var pillar: Dictionary = payload("wall_pillar")
	_place_aligned(pillar, Vector3(5.0, 0.0, -26.0), 0.0, "watch", group)
	_place_aligned(pillar, Vector3(15.0, 0.0, -26.0), 0.0, "watch", group)

	var wall: Dictionary = payload("wall")
	# Curtain runs along the approach banks, receding toward the breach.
	for z: float in [-13.0, -17.0, -21.0]:
		_place_aligned(wall, Vector3(18.6, 3.6, z), 0.0, "watch", group)
	for z: float in [-25.0, -29.0, -33.0]:
		_place_aligned(wall, Vector3(18.6, 4.2, z), 0.0, "watch", group)
		_place_aligned(wall, Vector3(1.4, 4.2, z), 0.0, "watch", group)
	# And a broken run facing the western approach bank.
	for x: float in [-2.0, 2.0]:
		_place_aligned(wall, Vector3(x, 3.6, -20.6), PI * 0.5, "watch", group)


## Sparse exterior framing. Trees are PLANTED and rocks are PLACED, and the two
## substantial route-side trunks are the only ones that own collision — the rest
## stand on already-blocked banks, where a second collision box would block
## nothing new and carve nothing new.
func _build_forest_framing() -> void:
	var group: Node3D = Node3D.new()
	group.name = "ForestFraming"
	_visuals.add_child(group)

	var planted: Array[Dictionary] = [
		{"key": "Tree_Bare_2_C_Color1", "at": Vector3(-18.4, 1.8, 21.0), "yaw": 0.30},
		{"key": "Tree_Bare_1_C_Color1", "at": Vector3(17.2, 2.4, 24.6), "yaw": -0.85},
		{"key": "Tree_Bare_1_C_Color1", "at": Vector3(-19.0, 2.8, 6.2), "yaw": 1.24},
		{"key": "Tree_Bare_2_C_Color1", "at": Vector3(12.6, 2.8, 6.8), "yaw": -0.42},
		{"key": "tree_dead_large", "at": Vector3(-16.2, 3.2, -6.6), "yaw": 0.62},
		{"key": "tree_dead_large", "at": Vector3(18.2, 3.2, -2.4), "yaw": -1.10},
		{"key": "Tree_Bare_1_C_Color1", "at": Vector3(-14.0, 3.6, -17.4), "yaw": 0.10},
		{"key": "tree_dead_large", "at": Vector3(19.0, 3.6, -15.0), "yaw": 1.50},
		{"key": "Tree_Bare_2_C_Color1", "at": Vector3(-3.0, 4.2, 34.6), "yaw": 0.0},
	]
	for entry: Dictionary in planted:
		_plant(String(entry["key"]), entry["at"], float(entry["yaw"]), group, "framing")

	# Two dead trees INSIDE the footprint, so the road is framed by something the
	# player can actually walk around rather than only by the boundary. §6.4:
	# "tree trunks ... own readable collision and navigation exclusion", so each
	# carries an authored trunk box sized from the trunk rather than from the
	# canopy — a canopy-sized collider would block empty-looking space.
	for at: Vector3 in [Vector3(2.4, 0.0, 25.2), Vector3(-10.4, 0.0, 12.8)]:
		_plant("tree_dead_large", at, float(at.x) * 0.19, group, "framing")
		_add_solid("TreeTrunk%.0f" % (at.z * 10.0), Vector3(0.90, 3.00, 0.90),
			at + Vector3(0.0, 1.50, 0.0), true)

	var outcrop: Dictionary = payload("Rock_1_Q_Color1")
	for at: Vector3 in [
		Vector3(-18.6, 1.8, 27.2), Vector3(18.4, 2.4, 16.4), Vector3(-17.6, 3.2, -9.4),
	]:
		_place_aligned(outcrop, at, float(at.z) * 0.11, "framing", group)

	# Ground rocks CLUSTER AT THE EDGES (paper design §5), never in the centre, and
	# each owns a small authored collision box: `Rock_1_A_Color1` measures 0.540 m
	# tall, which is knee height at this scale and far too tall to be walked
	# through. Every one is kept at least MINIMUM_SOLID_CLEARANCE from the
	# centreline, which the verification measures rather than trusts.
	var pebble: Dictionary = payload("Rock_1_A_Color1")
	for at: Vector3 in [
		Vector3(-13.5, 0.0, 29.0), Vector3(11.0, 0.0, 28.0), Vector3(-14.0, 0.0, 15.0),
		Vector3(12.0, 0.0, 14.5), Vector3(-8.0, 0.0, 20.0),
		Vector3(-5.4, 0.0, 6.0), Vector3(6.4, 0.0, 10.4),
		Vector3(8.8, 0.0, -2.0), Vector3(13.6, 0.0, -7.0), Vector3(-1.4, 0.0, -11.0),
		Vector3(4.2, 0.0, -13.0), Vector3(15.2, 0.0, -16.0),
		Vector3(4.8, 0.0, -22.6), Vector3(15.0, 0.0, -30.0), Vector3(5.2, 0.0, -34.4),
	]:
		_place_aligned(pebble, at, float(at.x) * 0.23, "framing", group)
		_add_solid("EdgeRock%.0f_%.0f" % [at.x * 10.0, at.z * 10.0],
			Vector3(0.62, 0.54, 0.66), at + Vector3(0.0, 0.27, 0.0), true)

	# Half-buried route rocks. `Rock_3_A_Color1` is authored 0.465 m BELOW its own
	# origin, so it is planted rather than placed: lifting it onto its bounding box
	# would stand a half-buried rock on tiptoe. Each keeps a small authored
	# collision box sized from what is actually above the ground, not from the
	# whole bounding box.
	for at: Vector3 in [
		Vector3(-8.0, 0.0, 24.4), Vector3(8.4, 0.0, 8.0), Vector3(-0.6, 0.0, -9.2),
		Vector3(5.2, 0.0, -33.0),
	]:
		_plant("Rock_3_A_Color1", at, float(at.z) * 0.17, group, "framing")
		_add_solid("BuriedRock%.0f" % (at.z * 10.0), Vector3(0.96, 0.40, 0.81),
			at + Vector3(0.0, 0.20, 0.0), true)


## D-206's one supplemental family, used exactly as it was accepted: sparingly, as
## damage, debris and history, never as a cemetery theme and never as
## architecture. Every piece stands on an already-blocked bank or flat on the
## ground, so this layer owns ZERO collision shapes and ZERO navigation carves —
## which is asserted rather than promised.
func _build_graveyard_dressing() -> void:
	var group: Node3D = Node3D.new()
	group.name = "GraveyardDressing"
	_visuals.add_child(group)

	var damaged: Dictionary = payload("stone-wall-damaged")
	var column: Dictionary = payload("stone-wall-column")
	# MEASURED AGAINST THE FIRST RENDERED EVIDENCE RUN: four even five-piece runs of
	# an upright 1 m slab read as rows of headstones from the accepted camera, which
	# is the cemetery theme D-206 rejected. Two shorter, unevenly spaced, unevenly
	# turned runs read as collapsed low walling — which is what the pieces are.
	var runs: Array[Dictionary] = [
		{"x": -19.2, "from": 18.0, "height": 1.8, "yaw": PI * 0.5, "length": 2},
		{"x": 18.9, "from": -30.0, "height": 4.2, "yaw": -PI * 0.5, "length": 3},
	]
	for run: Dictionary in runs:
		var x: float = float(run["x"])
		var from_z: float = float(run["from"])
		var y: float = float(run["height"])
		var yaw: float = float(run["yaw"])
		_place_aligned(column, Vector3(x, y, from_z - 1.0), yaw + 0.09, "dressing", group)
		for i: int in int(run["length"]):
			_place_aligned(damaged, Vector3(x, y, from_z + float(i) * 1.0),
				yaw - 0.05 * float(i), "dressing", group)
	# And three single fallen pieces, well apart, so the layer reads as damage
	# rather than as a boundary treatment.
	for single: Dictionary in [
		{"at": Vector3(-17.6, 2.8, 4.6), "yaw": 1.24},
		{"at": Vector3(16.2, 3.2, -3.0), "yaw": -0.86},
		{"at": Vector3(-19.0, 3.6, -16.0), "yaw": 0.42},
	]:
		_place_aligned(damaged, single["at"], float(single["yaw"]), "dressing", group)

	# `debris` is a SOLID PILE 0.160 m tall, placed by its measured AABB base and
	# never laid as a surface: laying it by its own upper face sinks it 0.080 m
	# into the ground and leaves a scatter of chips where a rubble pile should be.
	# Gate 1B measured that; it is not repeated here.
	var debris: Dictionary = payload("debris")
	var index: int = 0
	for at: Vector2 in [
		Vector2(-6.4, 20.2), Vector2(3.4, 24.8), Vector2(-8.8, 13.4), Vector2(2.4, 8.2),
		Vector2(-3.4, 3.0), Vector2(4.2, -2.6), Vector2(8.2, -8.4), Vector2(6.4, -14.6),
		Vector2(12.4, -17.8), Vector2(7.6, -23.4), Vector2(12.8, -25.2),
		Vector2(8.0, -29.6), Vector2(13.6, -30.8),
	]:
		_place_aligned(debris, Vector3(at.x, SURFACE_LIFT, at.y),
			float(index) * 0.71, "dressing", group)
		index += 1


func _build_loop_event() -> void:
	loop_event = RiftfallLoopEvent.new()
	loop_event.name = "RiftfallLoopEvent"
	add_child(loop_event)
	loop_event.build(treatment)
	_unregistered_authored_surfaces += loop_event.unregistered_surfaces()


## §8's spatial contracts. Stable named transforms, not gameplay triggers.
func _build_sockets() -> void:
	var stone: Vector3 = loop_event.rest_position() if loop_event != null else Vector3.ZERO
	var wanted: Array[Dictionary] = [
		{"name": "PlayerSpawn", "at": _local3(CENTRELINE[SPAWN_INDEX])},
		{"name": "ExitToBrokenWatch", "at": _local3(CENTRELINE[EXIT_INDEX])},
		{"name": "RiftScarFocus", "at": Vector3(-3.6, 0.0, 19.4)},
		{"name": "RepeatingStoneFocus", "at": stone},
		{"name": "WatchSilhouetteFocus", "at": Vector3(10.0, 1.0, -38.0)},
	]
	for entry: Dictionary in wanted:
		var marker: Marker3D = Marker3D.new()
		marker.name = String(entry["name"])
		marker.position = entry["at"]
		_sockets.add_child(marker)
		_socket_nodes[String(entry["name"])] = marker


func socket(socket_name: String) -> Marker3D:
	return _socket_nodes.get(socket_name, null)


func socket_names() -> PackedStringArray:
	return PackedStringArray(_socket_nodes.keys())


func socket_position(socket_name: String) -> Vector3:
	var marker: Marker3D = socket(socket_name)
	return marker.global_position if marker != null else Vector3.ZERO


# --- Developer diagnostics ----------------------------------------------------

func _build_grid() -> void:
	var mesh: ImmediateMesh = ImmediateMesh.new()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	var minor: Color = Color(0.40, 0.56, 0.74, 0.36)
	var major: Color = Color(0.88, 0.58, 0.26, 0.72)
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	var x: float = ARENA.position.x
	while x <= ARENA.end.x + 0.001:
		mesh.surface_set_color(major if is_zero_approx(fmod(absf(x), 5.0)) else minor)
		mesh.surface_add_vertex(Vector3(x, 0.03, ARENA.position.y))
		mesh.surface_add_vertex(Vector3(x, 0.03, ARENA.end.y))
		x += 1.0
	var z: float = ARENA.position.y
	while z <= ARENA.end.y + 0.001:
		mesh.surface_set_color(major if is_zero_approx(fmod(absf(z), 5.0)) else minor)
		mesh.surface_add_vertex(Vector3(ARENA.position.x, 0.03, z))
		mesh.surface_add_vertex(Vector3(ARENA.end.x, 0.03, z))
		z += 1.0
	mesh.surface_end()

	_grid = MeshInstance3D.new()
	_grid.name = "ScaleGrid"
	_grid.mesh = mesh
	_grid.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_grid.visible = grid_visible
	add_child(_grid)


## F7's navigation/path and collision-role view. Drawn from the SAME solids and
## centreline the measurements read, so a diagnostic can never show one route
## while the scene walks another. It is off by default and changes nothing.
func _build_diagnostics() -> void:
	var mesh: ImmediateMesh = ImmediateMesh.new()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.no_depth_test = true
	var walkable: Color = Color(0.35, 0.72, 0.52, 0.85)
	var blocking: Color = Color(0.92, 0.42, 0.32, 0.85)
	var line: Color = Color(0.95, 0.78, 0.32, 0.95)
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	for region: Dictionary in WALKABLE:
		_stroke_rect(mesh, region["rect"], 0.06, walkable)
	for entry: Dictionary in _solids:
		if String(entry["name"]) == "Ground":
			continue
		var box: AABB = entry["aabb"]
		_stroke_rect(mesh, Rect2(
			Vector2(box.position.x, box.position.z), Vector2(box.size.x, box.size.z)
		), 0.09, blocking)
	for i: int in range(1, CENTRELINE.size()):
		mesh.surface_set_color(line)
		mesh.surface_add_vertex(Vector3(CENTRELINE[i - 1].x, 0.14, CENTRELINE[i - 1].y))
		mesh.surface_add_vertex(Vector3(CENTRELINE[i].x, 0.14, CENTRELINE[i].y))
	mesh.surface_end()

	_diagnostics = MeshInstance3D.new()
	_diagnostics.name = "RouteDiagnostics"
	_diagnostics.mesh = mesh
	_diagnostics.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_diagnostics.visible = diagnostics_visible
	add_child(_diagnostics)


func _stroke_rect(mesh: ImmediateMesh, rect: Rect2, height: float, colour: Color) -> void:
	var corners: Array[Vector2] = [
		rect.position, Vector2(rect.end.x, rect.position.y), rect.end,
		Vector2(rect.position.x, rect.end.y),
	]
	for i: int in 4:
		mesh.surface_set_color(colour)
		mesh.surface_add_vertex(Vector3(corners[i].x, height, corners[i].y))
		mesh.surface_add_vertex(Vector3(corners[(i + 1) % 4].x, height, corners[(i + 1) % 4].y))


func set_grid_visible(value: bool) -> void:
	grid_visible = value
	if _grid != null:
		_grid.visible = value


func set_diagnostics_visible(value: bool) -> void:
	diagnostics_visible = value
	if _diagnostics != null:
		_diagnostics.visible = value


# --- Placement helpers --------------------------------------------------------

static func payload(key: String) -> Dictionary:
	for record: Dictionary in PAYLOADS:
		if String(record["key"]) == key:
			return record
	return {}


static func payload_paths() -> PackedStringArray:
	var paths: PackedStringArray = PackedStringArray()
	for record: Dictionary in PAYLOADS:
		paths.append(String(record["path"]))
	return paths


## Places one payload so its measured AABB centre lands on `at.x`/`at.z` and its
## measured AABB BASE lands on `at.y`. Scale is never touched, which is what makes
## "root scale 1.0" a fact about the scene rather than about the importer alone.
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


## Places a piece by its OWN ORIGIN, unadjusted. Four registered pieces sit up to
## 0.465 m below their origin because KayKit authored them to be planted rather
## than placed; this shows them planted and reports the offset instead of quietly
## correcting it.
func _plant(key: String, at: Vector3, yaw: float, parent: Node3D, layer: String) -> Node3D:
	var node: Node3D = _instantiate(payload(key), layer, parent)
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
	var node: Node3D = _instantiate(record, layer, parent)
	node.rotation = Vector3(0.0, yaw, 0.0)
	node.position = Vector3(at.x, _surface_drop(record) + float(stack) * SURFACE_LIFT, at.y)
	return node


func _instantiate(record: Dictionary, layer: String, parent: Node3D) -> Node3D:
	var scene: PackedScene = load(String(record["path"])) as PackedScene
	assert(scene != null, "Gate 1C: %s failed to load" % record["path"])
	var node: Node3D = scene.instantiate() as Node3D
	node.name = "%s_%d" % [String(record["key"]).replace("-", "_"), placed.size()]
	parent.add_child(node)
	if treatment != null:
		treatment.register(node, String(record["key"]))
	placed.append({
		"key": record["key"],
		"record": record,
		"node": node,
		"layer": layer,
		"primary": instances_of(String(record["key"])) == 0,
		"surface": String(record["contact"]) == "surface",
		"probe": ExteriorAssetProbe.measure(node),
	})
	return node


func _local_aabb(record: Dictionary) -> AABB:
	var key: String = String(record["key"])
	if _aabb_cache.has(key):
		return _aabb_cache[key]
	var probe_node: Node3D = (load(String(record["path"])) as PackedScene).instantiate() as Node3D
	var measured: Dictionary = ExteriorAssetProbe.measure(probe_node)
	var box: AABB = AABB(
		Vector3(measured["centre"].x - measured["size"].x * 0.5, measured["base_offset"],
			measured["centre"].z - measured["size"].z * 0.5),
		measured["size"]
	)
	probe_node.free()
	_aabb_cache[key] = box
	return box


func _surface_drop(record: Dictionary) -> float:
	var key: String = String(record["key"])
	if not surface_drops.has(key):
		var probe_node: Node3D = (load(String(record["path"])) as PackedScene) \
			.instantiate() as Node3D
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
	_solids.append({"name": solid_name, "aabb": AABB(at - size * 0.5, size), "carve": carve})
	if not carve:
		return
	var obstacle: NavigationObstacle3D = NavigationObstacle3D.new()
	obstacle.name = "%sCarve" % solid_name
	obstacle.position = Vector3(at.x, 0.0, at.z)
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


func _add_box_visual(
	parent: Node3D, mesh_name: String, size: Vector3, at: Vector3, colour: Color, label: String
) -> MeshInstance3D:
	var node: MeshInstance3D = MeshInstance3D.new()
	node.name = mesh_name
	var box: BoxMesh = BoxMesh.new()
	box.size = size
	node.mesh = box
	box.material = _authored_material(colour)
	node.position = at
	parent.add_child(node)
	_register_authored(node, label)
	return node


func _authored_material(colour: Color) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = colour
	material.roughness = 1.0
	material.metallic = 0.0
	material.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	return material


func _rift_material(alpha: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(COLOUR_RIFT.r, COLOUR_RIFT.g, COLOUR_RIFT.b, alpha)
	material.emission_enabled = true
	material.emission = COLOUR_RIFT
	material.emission_energy_multiplier = 0.85
	return material


## Authored surfaces join the same treatment the registered payloads do, so the
## accepted exterior rule acts on the whole picture rather than leaving a bright
## authored ground under a dark exterior.
func _register_authored(node: Node3D, _label: String) -> void:
	_authored_surfaces += 1
	if treatment != null:
		treatment.register(node, "authored geometry")


func _to_world(local: Vector3) -> Vector3:
	return global_transform * local


static func _local3(at: Vector2) -> Vector3:
	return Vector3(at.x, 0.0, at.y)


# --- Measured geometry --------------------------------------------------------

func arena_rect() -> Rect2:
	return ARENA


## The navigation bake is clipped to exactly the authored footprint and its
## boundary, and to the first metre above the ground. Both matter: baking the
## surround plane would produce a large unreachable walkable island, and baking
## above 0.90 m would rasterise every bank top as a legitimate walkable ledge.
func bake_rect() -> Rect2:
	return ARENA


## §6.1's principal movement footprint: the exact union area of the five authored
## walkable rectangles, by sweep over their distinct x boundaries. Exact, not
## sampled, so it can be quoted to the square centimetre.
func footprint_area() -> float:
	var edges: Array[float] = []
	for region: Dictionary in WALKABLE:
		var rect: Rect2 = region["rect"]
		if not edges.has(rect.position.x):
			edges.append(rect.position.x)
		if not edges.has(rect.end.x):
			edges.append(rect.end.x)
	edges.sort()
	var total: float = 0.0
	for i: int in range(1, edges.size()):
		var left: float = edges[i - 1]
		var right: float = edges[i]
		var middle: float = (left + right) * 0.5
		var spans: Array[Vector2] = []
		for region: Dictionary in WALKABLE:
			var rect: Rect2 = region["rect"]
			if rect.position.x <= middle and middle <= rect.end.x:
				spans.append(Vector2(rect.position.y, rect.end.y))
		total += (right - left) * _merged_span_length(spans)
	return total


static func _merged_span_length(spans: Array[Vector2]) -> float:
	if spans.is_empty():
		return 0.0
	spans.sort_custom(func(a: Vector2, b: Vector2) -> bool: return a.x < b.x)
	var length: float = 0.0
	var from: float = spans[0].x
	var to: float = spans[0].y
	for i: int in range(1, spans.size()):
		if spans[i].x > to:
			length += to - from
			from = spans[i].x
			to = spans[i].y
		else:
			to = maxf(to, spans[i].y)
	return length + (to - from)


## Camera footprints, at the fixed reference aspect. CF is a project unit, not a
## function of the window, so the reference area is passed in by the caller that
## measured it from the camera rig.
func footprint_in_cf(reference_area: float) -> float:
	return footprint_area() / maxf(reference_area, 0.0001)


func centreline_length() -> float:
	var total: float = 0.0
	for i: int in range(1, CENTRELINE.size()):
		total += CENTRELINE[i].distance_to(CENTRELINE[i - 1])
	return total


func centreline_point(along: float) -> Vector2:
	var remaining: float = maxf(along, 0.0)
	for i: int in range(1, CENTRELINE.size()):
		var segment: float = CENTRELINE[i].distance_to(CENTRELINE[i - 1])
		if remaining <= segment or i == CENTRELINE.size() - 1:
			return CENTRELINE[i - 1].lerp(CENTRELINE[i], clampf(remaining / segment, 0.0, 1.0))
		remaining -= segment
	return CENTRELINE[CENTRELINE.size() - 1]


func centreline_world() -> PackedVector3Array:
	var points: PackedVector3Array = PackedVector3Array()
	for at: Vector2 in CENTRELINE:
		points.append(_to_world(_local3(at)))
	return points


func distance_to_centreline(at: Vector2) -> float:
	var nearest: float = 1e9
	for i: int in range(1, CENTRELINE.size()):
		nearest = minf(nearest, _distance_to_segment(at, CENTRELINE[i - 1], CENTRELINE[i]))
	return nearest


static func _distance_to_segment(point: Vector2, from: Vector2, to: Vector2) -> float:
	var span: Vector2 = to - from
	var length_squared: float = span.length_squared()
	if length_squared < 0.000001:
		return point.distance_to(from)
	var t: float = clampf((point - from).dot(span) / length_squared, 0.0, 1.0)
	return point.distance_to(from + span * t)


## The measured clear width across the route at `along`, taken PERPENDICULAR to
## the centreline and marched against the authored footprint and every
## collision-bearing solid the scene actually built. It is not read off the
## authoring constants, so a mass one centimetre out of place moves it.
func clear_width_at(along: float) -> Dictionary:
	var here: Vector2 = centreline_point(along)
	var ahead: Vector2 = centreline_point(minf(along + 0.25, centreline_length()))
	var behind: Vector2 = centreline_point(maxf(along - 0.25, 0.0))
	var direction: Vector2 = (ahead - behind)
	if direction.length() < 0.0001:
		direction = Vector2(0.0, -1.0)
	var normal: Vector2 = Vector2(-direction.y, direction.x).normalized()
	var left: float = _march(here, normal)
	var right: float = _march(here, -normal)
	return {"along": along, "at": here, "left": left, "right": right, "width": left + right}


## How far the perpendicular ray travels before it leaves the authored footprint
## or meets a collision-bearing solid. EXACT ray-versus-rectangle arithmetic, not
## a stepped probe: a probe that samples every 5 cm under-reports every width by
## up to 5 cm per side, which is the difference between an 8.000 m breach passing
## its own "at least 8.0 m" rule and failing it for no reason but the sampler.
func _march(from: Vector2, direction: Vector2) -> float:
	var reach: float = 0.0
	var grew: bool = true
	# The footprint is a union of overlapping rectangles, so the ray may pass from
	# one into the next. Extend through whichever rectangle covers the current
	# reach until none does.
	while grew:
		grew = false
		for region: Dictionary in WALKABLE:
			var span: Vector2 = _ray_span(from, direction, region["rect"])
			if span.y <= span.x:
				continue
			if span.x <= reach + 0.000001 and span.y > reach + 0.000001:
				reach = span.y
				grew = true
	var limit: float = minf(reach, WIDTH_MARCH_LIMIT)
	for entry: Dictionary in _solids:
		if String(entry["name"]) == "Ground":
			continue
		var box: AABB = entry["aabb"]
		var span: Vector2 = _ray_span(from, direction, Rect2(
			Vector2(box.position.x, box.position.z), Vector2(box.size.x, box.size.z)
		))
		if span.y > span.x:
			limit = minf(limit, span.x)
	return maxf(limit, 0.0)


## The interval of ray parameters for which `from + direction * t` lies inside
## `rect`, clamped to t >= 0. Returns Vector2(0, -1) when the ray misses it.
static func _ray_span(from: Vector2, direction: Vector2, rect: Rect2) -> Vector2:
	var near: float = 0.0
	var far: float = WIDTH_MARCH_LIMIT
	var lows: Array[float] = [rect.position.x, rect.position.y]
	var highs: Array[float] = [rect.end.x, rect.end.y]
	var origin: Array[float] = [from.x, from.y]
	var span: Array[float] = [direction.x, direction.y]
	for axis: int in 2:
		if absf(span[axis]) < 0.000001:
			if origin[axis] < lows[axis] or origin[axis] > highs[axis]:
				return Vector2(0.0, -1.0)
			continue
		var first: float = (lows[axis] - origin[axis]) / span[axis]
		var second: float = (highs[axis] - origin[axis]) / span[axis]
		if first > second:
			var swap: float = first
			first = second
			second = swap
		near = maxf(near, first)
		far = minf(far, second)
	if far < near:
		return Vector2(0.0, -1.0)
	return Vector2(near, far)


func _measure_widths() -> void:
	_width_samples.clear()
	var total: float = centreline_length()
	var along: float = 0.0
	while along <= total + 0.0001:
		_width_samples.append(clear_width_at(along))
		along += WIDTH_SAMPLE_STEP


func width_samples() -> Array[Dictionary]:
	return _width_samples


func narrowest_clearance() -> float:
	return float(narrowest_sample().get("width", 0.0))


## The narrowest station and where it is, so the report can name the place rather
## than only the number.
func narrowest_sample() -> Dictionary:
	var narrowest: Dictionary = {}
	for sample: Dictionary in _width_samples:
		if narrowest.is_empty() or float(sample["width"]) < float(narrowest["width"]):
			narrowest = sample
	return narrowest


func widths_in_ordinary_band() -> int:
	var total: int = 0
	for sample: Dictionary in _width_samples:
		var width: float = float(sample["width"])
		if width >= ORDINARY_WIDTH_MIN and width <= ORDINARY_WIDTH_MAX:
			total += 1
	return total


func median_width() -> float:
	if _width_samples.is_empty():
		return 0.0
	var widths: Array[float] = []
	for sample: Dictionary in _width_samples:
		widths.append(float(sample["width"]))
	widths.sort()
	return widths[widths.size() / 2]


func widths_wider_than_ordinary() -> int:
	var total: int = 0
	for sample: Dictionary in _width_samples:
		if float(sample["width"]) > ORDINARY_WIDTH_MAX:
			total += 1
	return total


## §6.1's Watch breach, MEASURED between the inner faces of the two authored
## breach masses rather than repeated from the constant that asked for it.
func breach_clearance() -> float:
	var west: Dictionary = solid("BreachMassWest")
	var east: Dictionary = solid("BreachMassEast")
	if west.is_empty() or east.is_empty():
		return 0.0
	return (east["aabb"] as AABB).position.x - (west["aabb"] as AABB).end.x


## The fraction of the authored movement footprint carrying no collision-bearing
## obstacle. The ground solid and the boundary banks are structure rather than
## decoration and are excluded; everything else inside the footprint counts.
func clear_fraction() -> float:
	var footprint: float = footprint_area()
	var occupied: float = 0.0
	for entry: Dictionary in _solids:
		var solid_name: String = String(entry["name"])
		if solid_name == "Ground" or solid_name.begins_with("Bank"):
			continue
		var box: AABB = entry["aabb"]
		occupied += _rect_inside_footprint(Rect2(
			Vector2(box.position.x, box.position.z), Vector2(box.size.x, box.size.z)
		))
	return 1.0 - occupied / maxf(footprint, 0.0001)


func _rect_inside_footprint(rect: Rect2) -> float:
	var total: float = 0.0
	var claimed: Array[Rect2] = []
	for region: Dictionary in WALKABLE:
		var overlap: Rect2 = rect.intersection(region["rect"])
		if overlap.get_area() <= 0.0:
			continue
		var already: float = 0.0
		for previous: Rect2 in claimed:
			already += previous.intersection(overlap).get_area()
		total += maxf(overlap.get_area() - already, 0.0)
		claimed.append(overlap)
	return total


## The closest any collision-bearing solid other than the ground and the boundary
## banks comes to the route centreline. The two breach masses are reported
## separately because their gap IS the authored narrowest clearance.
func minimum_solid_clearance() -> Dictionary:
	var nearest: float = 1e9
	var owner: String = ""
	for entry: Dictionary in _solids:
		var solid_name: String = String(entry["name"])
		if solid_name == "Ground" or solid_name.begins_with("Bank") \
				or solid_name.begins_with("Breach"):
			continue
		var box: AABB = entry["aabb"]
		var rect: Rect2 = Rect2(
			Vector2(box.position.x, box.position.z), Vector2(box.size.x, box.size.z)
		)
		var distance: float = _rect_distance_to_centreline(rect)
		if distance < nearest:
			nearest = distance
			owner = solid_name
	return {"metres": nearest, "solid": owner}


func _rect_distance_to_centreline(rect: Rect2) -> float:
	var nearest: float = 1e9
	var along: float = 0.0
	var total: float = centreline_length()
	while along <= total + 0.0001:
		var point: Vector2 = centreline_point(along)
		var clamped: Vector2 = Vector2(
			clampf(point.x, rect.position.x, rect.end.x),
			clampf(point.y, rect.position.y, rect.end.y)
		)
		nearest = minf(nearest, point.distance_to(clamped))
		along += 0.25
	return nearest


## Every placed mesh whose world AABB reaches into the clear walking line. Empty
## is the only acceptable answer.
func spine_intrusions() -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	var total: float = centreline_length()
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
		# height of the piece rather than a per-piece flag.
		if world.end.y <= GROUND_CLUTTER_HEIGHT:
			continue
		var along: float = 0.0
		while along <= total + 0.0001:
			var point: Vector2 = centreline_point(along)
			var box: AABB = AABB(
				Vector3(point.x - SPINE_HALF_WIDTH, 0.0, point.y - SPINE_HALF_WIDTH),
				Vector3(SPINE_HALF_WIDTH * 2.0, SPINE_HEIGHT, SPINE_HALF_WIDTH * 2.0)
			)
			if world.intersects(box):
				found.append("%s at (%.2f, %.2f)" % [
					entry["key"], node.position.x, node.position.z,
				])
				break
			along += 0.5
	return found


## §6.4: the Halloween arch is a landmark, never the traversable opening. Both
## halves of that claim are measured — it stands outside the walkable footprint,
## and no point of the centreline passes under it.
func arch_is_off_route() -> Dictionary:
	for entry: Dictionary in placed:
		if String(entry["key"]) != "arch":
			continue
		var node: Node3D = entry["node"]
		var probe: Dictionary = entry["probe"]
		var world: AABB = node.transform * AABB(
			Vector3(probe["centre"].x - probe["size"].x * 0.5, probe["base_offset"],
				probe["centre"].z - probe["size"].z * 0.5),
			probe["size"]
		)
		var rect: Rect2 = Rect2(
			Vector2(world.position.x, world.position.z), Vector2(world.size.x, world.size.z)
		)
		return {
			"found": true,
			"walkable_overlap": _rect_inside_footprint(rect),
			"centreline_distance": _rect_distance_to_centreline(rect),
			"rect": rect,
		}
	return {"found": false, "walkable_overlap": 0.0, "centreline_distance": 0.0}


func _is_walkable(at: Vector2) -> bool:
	for region: Dictionary in WALKABLE:
		if (region["rect"] as Rect2).has_point(at):
			return true
	return false


func is_walkable_point(at: Vector2) -> bool:
	return _is_walkable(at)


func _is_blocked(at: Vector2) -> bool:
	for entry: Dictionary in _solids:
		if String(entry["name"]) == "Ground":
			continue
		var box: AABB = entry["aabb"]
		if at.x >= box.position.x and at.x <= box.end.x \
				and at.y >= box.position.z and at.y <= box.end.z:
			return true
	return false


func is_blocked_point(at: Vector2) -> bool:
	return _is_blocked(at)


## Every authored point is either inside the walkable footprint or inside a
## boundary bank: the banks tile the arena's complement exactly. Sampled on a
## lattice, because a gap in the boundary is a hole the player walks out through.
func boundary_gaps(step: float = 0.5) -> PackedStringArray:
	var gaps: PackedStringArray = PackedStringArray()
	var x: float = ARENA.position.x + step * 0.5
	while x < ARENA.end.x:
		var z: float = ARENA.position.y + step * 0.5
		while z < ARENA.end.y:
			var at: Vector2 = Vector2(x, z)
			if not _is_walkable(at) and not _is_inside_bank(at):
				gaps.append("(%.2f, %.2f)" % [x, z])
				if gaps.size() >= 12:
					return gaps
			z += step
		x += step
	return gaps


func _is_inside_bank(at: Vector2) -> bool:
	for bank: Dictionary in BANKS:
		if (bank["rect"] as Rect2).has_point(at):
			return true
	return false


func solids() -> Array[Dictionary]:
	return _solids


func solid(solid_name: String) -> Dictionary:
	for entry: Dictionary in _solids:
		if String(entry["name"]) == solid_name:
			return entry
	return {}


func carving_solids() -> int:
	var total: int = 0
	for entry: Dictionary in _solids:
		if bool(entry["carve"]):
			total += 1
	return total


func instances_of(key: String) -> int:
	var total: int = 0
	for entry: Dictionary in placed:
		if String(entry["key"]) == key:
			total += 1
	return total


func instances_in_layer(layer: String) -> int:
	var total: int = 0
	for entry: Dictionary in placed:
		if String(entry["layer"]) == layer:
			total += 1
	return total


func used_payload_keys() -> PackedStringArray:
	var keys: PackedStringArray = PackedStringArray()
	for entry: Dictionary in placed:
		if not keys.has(String(entry["key"])):
			keys.append(String(entry["key"]))
	return keys


func used_families() -> PackedStringArray:
	var families: PackedStringArray = PackedStringArray()
	for entry: Dictionary in placed:
		var family: String = String((entry["record"] as Dictionary)["family"])
		if not families.has(family):
			families.append(family)
	return families


func primary_instances() -> Array[Dictionary]:
	var primaries: Array[Dictionary] = []
	for entry: Dictionary in placed:
		if bool(entry["primary"]):
			primaries.append(entry)
	return primaries


func authored_surfaces() -> int:
	return _authored_surfaces


func unregistered_authored_surfaces() -> int:
	return _unregistered_authored_surfaces
