class_name RiftfallLandingGreyboxLayout
extends Node3D
## Riftfall Landing — ISOLATED GREYBOX REVIEW LAYOUT, V2. NOT CANONICAL.
##
## Level-design blockout only, for the project owner to judge scale and flow
## before any asset, lighting or VFX work begins. It does not touch, read, or
## depend on the canonical `severed_threshold/riftfall_landing.tscn`, the Gate
## 1C accepted payload allowlist, or any registered third-party asset — every
## piece of geometry here is a Godot primitive (`BoxMesh`, `CylinderMesh`,
## `PlaneMesh`) in a flat diagnostic colour. Nothing from the registered asset
## library is loaded by this file, which the smoke test proves by a raw
## source scan.
##
## V1 WAS REJECTED BY THE PROJECT OWNER: "reads as a rectangle", "feels like a
## hallway", "the middle has no identity", "the breach doesn't feel like a
## destination", "essentially straight with a minor angle". Every one of those
## was a consequence of the SAME root cause — continuous parallel boundary
## strips run alongside a nearly-straight centreline, at a near-uniform width,
## through undifferentiated rectangular rooms. V2 changes the COMPOSITION, not
## individual box positions:
##
##   - the centreline is a genuine hook/S shape with 9 m of lateral swing
##     across two real direction changes, not a straight diagonal;
##   - boundary is DISCRETE, CHUNKY MASSES WITH GAPS, never a strip that tracks
##     the route — the shape of each room is read from its own irregular
##     outline and from negative space around a few large masses, not from a
##     tube's parallel walls;
##   - each of the five beats is an IRREGULAR ROOM built from several unequal,
##     offset rectangles (never one clean rectangle), joined by short, narrower
##     PINCH TRANSITIONS, so the space reads as a chain of distinct places
##     rather than one continuous corridor;
##   - First Bearing bends the route around one large dark-charcoal mass,
##     legible through the negative space either side of it;
##   - Broken Procession widens into an irregular plaza around the yellow
##     stone reservation, dressed with a few small scattered ruin-fragment
##     masses so it reads as a stopping place rather than another road segment;
##   - Watch Forecourt is the single broadest room in the layout, a real
##     destination space before the gate;
##   - the Watch Breach is framed by two OFFSET gatehouse masses — different
##     sizes, staggered along the route rather than mirrored twins — so
##     arriving reads as reaching a built threshold, not walking between two
##     identical posts.
##
## SPATIAL STRUCTURE, five beats (design/FIRST_MVP_RIFTFALL_LANDING_PAPER_DESIGN.md's
## own four-beat shape, with Watch Forecourt split out as its own destination
## room ahead of the breach, per the owner's required topology):
##   1. Rift Scar         — broad ASYMMETRICAL safe arrival
##   2. First Bearing     — the route bends around one large mass, shortly
##                           after spawn, legible through negative space
##   3. Broken Procession — a distinct widening/plaza around the repeating
##                           stone reservation — a place, not a road segment
##   4. Watch Forecourt    — the broadest room: a real destination space
##   5. Watch Breach       — an 8.000 m gap framed by two offset gatehouse
##                           masses, into (unbuilt) Broken Watch
##
## DIAGNOSTIC COLOUR LANGUAGE (flat, unlit for markers; flat, lightly lit for
## mass so the overhead and gameplay shots both read the geometry's shape):
##   light grey    walkable ground
##   dark charcoal solid boundary / inaccessible mass
##   muted blue    architecture reserved for later replacement
##   violet        Rift Scar / VFX reservation (flush ground patch, no collision)
##   green         Player Start
##   red           Way Out
##   yellow        repeating-stone reservation (flush ground patch, no collision)
##   thin warm line route centreline guide, review only
##
## MEASUREMENT IS EXACT, NOT SAMPLED. Footprint area is a coordinate-compressed
## rectangle-union sweep over every walkable rectangle; route width is exact
## ray-versus-rectangle arithmetic perpendicular to the centreline tangent,
## marched against every solid this scene actually built — never a fixed-step
## sampler and never a number repeated from a target.
##
## `Rect2` stands in for a horizontal XZ footprint throughout this file:
## `position.x` / `size.x` is world X, `position.y` / `size.y` is world Z.

const WORLD_LAYER: int = 1

const GROUND_COLOUR: Color = Color(0.745, 0.755, 0.770)
const BOUNDARY_COLOUR: Color = Color(0.135, 0.145, 0.165)
const ARCHITECTURE_COLOUR: Color = Color(0.300, 0.420, 0.580)
const RIFT_SCAR_COLOUR: Color = Color(0.560, 0.380, 0.780)
const PLAYER_START_COLOUR: Color = Color(0.300, 0.850, 0.400)
const WAY_OUT_COLOUR: Color = Color(0.880, 0.250, 0.220)
const STONE_RESERVATION_COLOUR: Color = Color(0.920, 0.800, 0.250)
const CENTRELINE_COLOUR: Color = Color(0.950, 0.850, 0.550, 0.70)

## Boundary and architecture masses vary in height so the big bend mass and
## the gatehouses read as more substantial than an ordinary edge chunk.
const BOUNDARY_HEIGHT_LOW: float = 2.20
const BOUNDARY_HEIGHT_HIGH: float = 3.60
const ARCHITECTURE_HEIGHT: float = 4.20
const GATEHOUSE_HEIGHT: float = 5.40

## THE ROUTE: a genuine hook/S shape. Two real direction changes (the P1->P2
## hook around the First Bearing mass, and the P3->P4 turn into the Watch
## Forecourt), 9 m of lateral swing, and the bend begins well inside the first
## third of the route — "shortly after spawning", per the brief. The line
## continues all the way through the gatehouse gap to Way Out, so both the
## measured breach clearance and the exit evidence frame read the real gate.
const CENTRELINE: Array[Vector2] = [
	Vector2(-4.0, 22.0),   # Rift Scar, near Player Start
	Vector2(2.0, 16.0),    # First Bearing, NE arm — the lean before the hook
	Vector2(-5.0, 7.0),    # First Bearing, after the hook around the big mass
	Vector2(-5.0, -2.0),   # Broken Procession, through the plaza
	Vector2(3.0, -9.0),    # the second bend, into Watch Forecourt
	Vector2(3.0, -14.0),   # across the Watch Forecourt
	Vector2(3.0, -18.0),   # through the gatehouse gap
	Vector2(3.0, -24.0),   # the Watch Breach, at Way Out
]

const PLAYER_START: Vector2 = Vector2(-7.0, 24.0)
const WAY_OUT: Vector2 = Vector2(3.0, -27.0)

## --- Beat 1: Rift Scar --------------------------------------------------
## Three unequal, offset rectangles — never one rectangle — so the outline
## itself reads as irregular and asymmetrical, not as a bounded box with a
## spawn point in it.
const RIFT_SCAR_MAIN: Rect2 = Rect2(Vector2(-15.0, 13.0), Vector2(23.0, 14.0))
const RIFT_SCAR_NW_BULGE: Rect2 = Rect2(Vector2(-19.0, 21.0), Vector2(9.0, 9.0))
const RIFT_SCAR_SE_SLIVER: Rect2 = Rect2(Vector2(2.0, 8.0), Vector2(9.0, 6.0))
const RIFT_SCAR_RESERVATION: Rect2 = Rect2(Vector2(-16.0, 24.0), Vector2(5.0, 5.0))

const TRANSITION_SCAR_TO_BEARING: Rect2 = Rect2(Vector2(-2.0, 9.0), Vector2(11.0, 4.0))

## --- Beat 2: First Bearing ------------------------------------------------
## Two arms that do NOT overlap along a shared straight edge — they meet only
## at a short diagonal notch — so the room itself has the hook shape rather
## than being a straight tube with a mass dropped in front of it.
const BEARING_NE_ARM: Rect2 = Rect2(Vector2(-1.0, 7.0), Vector2(13.0, 10.0))
const BEARING_NW_ARM: Rect2 = Rect2(Vector2(-13.0, 1.0), Vector2(13.0, 10.0))
## The one large mass the route bends around, filling the inside of the hook.
## Its footprint touches neither arm, so the bend is read entirely from the
## negative space curling around it.
const BEARING_BEND_MASS: Rect2 = Rect2(Vector2(1.0, 1.0), Vector2(13.0, 6.0))

const TRANSITION_BEARING_TO_PROCESSION: Rect2 = Rect2(Vector2(-9.0, -3.0), Vector2(8.0, 4.0))

## --- Beat 3: Broken Procession --------------------------------------------
## An irregular plaza — a main body plus a west and an east bulge — around the
## stone reservation, dressed with small scattered ruin fragments so it reads
## as a ruined ceremonial stopping place rather than a wide road segment.
const PROCESSION_MAIN: Rect2 = Rect2(Vector2(-14.0, -10.0), Vector2(18.0, 9.0))
const PROCESSION_WEST_BULGE: Rect2 = Rect2(Vector2(-18.0, -6.0), Vector2(6.0, 7.0))
const PROCESSION_EAST_BULGE: Rect2 = Rect2(Vector2(4.0, -9.0), Vector2(7.0, 6.0))
const STONE_RESERVATION: Rect2 = Rect2(Vector2(-9.0, -8.0), Vector2(5.0, 5.0))
const PROCESSION_RUIN_FRAGMENTS: Array[Rect2] = [
	Rect2(Vector2(-16.0, -5.0), Vector2(2.0, 3.0)),
	Rect2(Vector2(-13.0, -9.0), Vector2(2.0, 2.0)),
	Rect2(Vector2(7.0, -6.5), Vector2(2.0, 2.5)),
]

const TRANSITION_PROCESSION_TO_FORECOURT: Rect2 = Rect2(Vector2(1.0, -13.0), Vector2(8.0, 4.0))

## --- Beat 4: Watch Forecourt ------------------------------------------------
## The single broadest room in the layout — a real destination space, not
## another widened corridor — asymmetrically extended further west than east,
## with a second west bulge so its own outline stays irregular too.
const FORECOURT_MAIN: Rect2 = Rect2(Vector2(-9.0, -20.0), Vector2(26.0, 7.0))
const FORECOURT_WEST_BULGE: Rect2 = Rect2(Vector2(-17.0, -19.0), Vector2(8.0, 6.0))

## --- Beat 5: Watch Breach ---------------------------------------------------
## The gate court, narrower than the forecourt it opens from, then a small
## landing beyond the gap where Way Out sits.
const BREACH_COURT: Rect2 = Rect2(Vector2(-1.0, -25.0), Vector2(11.0, 5.0))
const BEYOND_BREACH: Rect2 = Rect2(Vector2(1.0, -30.0), Vector2(8.0, 5.0))

## The two gatehouses. OFFSET, not mirrored: different footprints, staggered
## along Z, so the threshold reads as one built structure rather than twin
## posts. Inner faces at x = 0 and x = 8 -> an 8.000 m gap.
const GATEHOUSE_WEST: Rect2 = Rect2(Vector2(-6.0, -26.0), Vector2(6.0, 9.0))
const GATEHOUSE_EAST: Rect2 = Rect2(Vector2(8.0, -23.0), Vector2(5.0, 7.0))

## --- Discrete boundary massing ----------------------------------------------
## Chunky, gapped, NEVER a continuous strip alongside the route. Each entry is
## {rect, tall} — `tall` picks BOUNDARY_HEIGHT_HIGH for the few masses meant to
## read as more substantial (the bend mass, the plaza's outer anchors).
const BOUNDARY_MASSES: Array[Dictionary] = [
	# Rift Scar: a few big outer chunks, not a ring — the scar's own irregular
	# rectangle union already reads as asymmetrical; boundary only needs to
	# stop the open sides.
	{"rect": Rect2(Vector2(-15.0, 27.0), Vector2(23.0, 4.0)), "tall": false},
	{"rect": Rect2(Vector2(-19.0, 13.0), Vector2(4.0, 8.0)), "tall": false},
	{"rect": Rect2(Vector2(8.0, 8.0), Vector2(4.0, 20.0)), "tall": false},

	# First Bearing: the one large bend mass, plus two outer anchors that do
	# NOT run the arm's full length.
	{"rect": BEARING_BEND_MASS, "tall": true},
	{"rect": Rect2(Vector2(-17.0, 3.0), Vector2(4.0, 9.0)), "tall": false},
	{"rect": Rect2(Vector2(7.0, 16.0), Vector2(4.0, 5.0)), "tall": false},

	# Broken Procession: two outer anchors framing the plaza's north and south
	# reaches, well short of the bulges so the irregular outline stays legible.
	{"rect": Rect2(Vector2(-14.0, -18.0), Vector2(12.0, 6.0)), "tall": true},
	{"rect": Rect2(Vector2(-22.0, -9.0), Vector2(4.0, 8.0)), "tall": false},

	# Watch Forecourt: two anchors at the broad room's far corners only — the
	# room's own width is what carries "broad destination space".
	{"rect": Rect2(Vector2(-22.0, -18.0), Vector2(4.0, 6.0)), "tall": false},
	{"rect": Rect2(Vector2(17.0, -21.0), Vector2(5.0, 8.0)), "tall": false},

	# Watch Breach: the far cap beyond the landing, so the space closes rather
	# than trailing into open void.
	{"rect": Rect2(Vector2(1.0, -34.0), Vector2(8.0, 4.0)), "tall": true},
]

## Ground rectangles: every room plus every transition.
const WALKABLE: Array[Rect2] = [
	RIFT_SCAR_MAIN, RIFT_SCAR_NW_BULGE, RIFT_SCAR_SE_SLIVER,
	TRANSITION_SCAR_TO_BEARING,
	BEARING_NE_ARM, BEARING_NW_ARM,
	TRANSITION_BEARING_TO_PROCESSION,
	PROCESSION_MAIN, PROCESSION_WEST_BULGE, PROCESSION_EAST_BULGE,
	TRANSITION_PROCESSION_TO_FORECOURT,
	FORECOURT_MAIN, FORECOURT_WEST_BULGE,
	BREACH_COURT, BEYOND_BREACH,
]

const ORDINARY_WIDTH_MIN: float = 10.0
const ORDINARY_WIDTH_MAX: float = 14.0
const WIDTH_STEP: float = 0.5
const MAX_SEARCH_METRES: float = 60.0

var _visuals: Node3D
var _collision: StaticBody3D
var _obstacles: Node3D
var _markers: Node3D
var _grid: MeshInstance3D
var grid_visible: bool = false

## Every collision-bearing solid this node built, as an XZ `Rect2` footprint,
## so measurement reads the built world rather than the authored constants.
var _boundary_rects: Array[Rect2] = []
var _architecture_rects: Array[Rect2] = []


func _ready() -> void:
	_build()


# --- Construction ---------------------------------------------------------

func _build() -> void:
	for child: Node in get_children():
		child.free()
	_boundary_rects.clear()
	_architecture_rects.clear()

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

	_markers = Node3D.new()
	_markers.name = "Markers"
	add_child(_markers)

	_build_ground()
	_build_boundary_masses()
	_build_architecture()
	_build_reservations()
	_build_centreline_guide()
	_build_sockets()
	_build_grid()


func _build_ground() -> void:
	for rect: Rect2 in WALKABLE:
		_add_ground_plate(rect)


func _add_ground_plate(rect: Rect2) -> void:
	var plate: MeshInstance3D = MeshInstance3D.new()
	plate.name = "Ground_%d_%d" % [int(rect.position.x * 10.0), int(rect.position.y * 10.0)]
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = Vector3(rect.size.x, 0.20, rect.size.y)
	plate.mesh = mesh
	plate.material_override = _lit_material(GROUND_COLOUR)
	plate.position = Vector3(
		rect.position.x + rect.size.x * 0.5, -0.10, rect.position.y + rect.size.y * 0.5
	)
	_visuals.add_child(plate)
	_add_solid_collision_only(plate.name, Vector3(rect.size.x, 0.20, rect.size.y), plate.position, false)


## Discrete, chunky, gapped masses — never a strip that tracks the route.
func _build_boundary_masses() -> void:
	for entry: Dictionary in BOUNDARY_MASSES:
		var rect: Rect2 = entry["rect"]
		var tall: bool = entry["tall"]
		_boundary_block(rect, tall)


func _boundary_block(rect: Rect2, tall: bool) -> void:
	var height: float = BOUNDARY_HEIGHT_HIGH if tall else BOUNDARY_HEIGHT_LOW
	var name_stem: String = "Boundary_%d_%d" % [int(rect.position.x * 10.0), int(rect.position.y * 10.0)]
	var mass: MeshInstance3D = MeshInstance3D.new()
	mass.name = name_stem
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = Vector3(rect.size.x, height, rect.size.y)
	mass.mesh = mesh
	mass.material_override = _lit_material(BOUNDARY_COLOUR)
	mass.position = Vector3(
		rect.position.x + rect.size.x * 0.5, height * 0.5, rect.position.y + rect.size.y * 0.5
	)
	_visuals.add_child(mass)
	_boundary_rects.append(rect)
	_add_solid_collision_only(name_stem, Vector3(rect.size.x, height, rect.size.y), mass.position, true)


## Beat 3's ruin fragments and beat 5's offset gatehouses — the "architecture
## reserved for later replacement" family.
func _build_architecture() -> void:
	for fragment: Rect2 in PROCESSION_RUIN_FRAGMENTS:
		_architecture_block(fragment, ARCHITECTURE_HEIGHT * 0.35)
	_architecture_block(GATEHOUSE_WEST, GATEHOUSE_HEIGHT)
	_architecture_block(GATEHOUSE_EAST, GATEHOUSE_HEIGHT * 0.80)


func _architecture_block(rect: Rect2, height: float) -> void:
	var name_stem: String = "Architecture_%d_%d" % [int(rect.position.x * 10.0), int(rect.position.y * 10.0)]
	var mass: MeshInstance3D = MeshInstance3D.new()
	mass.name = name_stem
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = Vector3(rect.size.x, height, rect.size.y)
	mass.mesh = mesh
	mass.material_override = _lit_material(ARCHITECTURE_COLOUR)
	mass.position = Vector3(
		rect.position.x + rect.size.x * 0.5, height * 0.5, rect.position.y + rect.size.y * 0.5
	)
	_visuals.add_child(mass)
	_architecture_rects.append(rect)
	_add_solid_collision_only(name_stem, Vector3(rect.size.x, height, rect.size.y), mass.position, true)


## Violet Rift Scar/VFX reservation and yellow repeating-stone reservation:
## flush ground-level patches, unshaded, no collision, no navigation carve.
func _build_reservations() -> void:
	_reservation_patch("RiftScarReservation", RIFT_SCAR_RESERVATION, RIFT_SCAR_COLOUR, 0.55)
	_reservation_patch("StoneReservation", STONE_RESERVATION, STONE_RESERVATION_COLOUR, 0.65)


func _reservation_patch(patch_name: String, rect: Rect2, colour: Color, alpha: float) -> void:
	var patch: MeshInstance3D = MeshInstance3D.new()
	patch.name = patch_name
	var mesh: PlaneMesh = PlaneMesh.new()
	mesh.size = rect.size
	patch.mesh = mesh
	patch.material_override = _unshaded_material(colour, alpha)
	patch.position = Vector3(
		rect.position.x + rect.size.x * 0.5, 0.015, rect.position.y + rect.size.y * 0.5
	)
	patch.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_visuals.add_child(patch)


func _build_centreline_guide() -> void:
	var mesh: ImmediateMesh = ImmediateMesh.new()
	var material: StandardMaterial3D = _unshaded_material(CENTRELINE_COLOUR, CENTRELINE_COLOUR.a)
	mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP, material)
	for point: Vector2 in CENTRELINE:
		mesh.surface_add_vertex(Vector3(point.x, 0.03, point.y))
	mesh.surface_end()
	var line: MeshInstance3D = MeshInstance3D.new()
	line.name = "CentrelineGuide"
	line.mesh = mesh
	line.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_visuals.add_child(line)


func _build_sockets() -> void:
	_add_socket_marker("PlayerStart", PLAYER_START, PLAYER_START_COLOUR)
	_add_socket_marker("WayOut", WAY_OUT, WAY_OUT_COLOUR)


func _add_socket_marker(marker_name: String, at: Vector2, colour: Color) -> void:
	var ring: MeshInstance3D = MeshInstance3D.new()
	ring.name = "%sRing" % marker_name
	var torus: TorusMesh = TorusMesh.new()
	torus.inner_radius = 0.55
	torus.outer_radius = 0.75
	torus.rings = 20
	ring.mesh = torus
	ring.material_override = _unshaded_material(colour, 1.0)
	ring.position = Vector3(at.x, 0.05, at.y)
	ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_markers.add_child(ring)

	var pole: MeshInstance3D = MeshInstance3D.new()
	pole.name = "%sPole" % marker_name
	var box: BoxMesh = BoxMesh.new()
	box.size = Vector3(0.12, 2.0, 0.12)
	pole.mesh = box
	pole.material_override = _unshaded_material(colour, 1.0)
	pole.position = Vector3(at.x, 1.0, at.y)
	pole.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_markers.add_child(pole)


func _build_grid() -> void:
	var bounds: Rect2 = _overall_bounds()
	var mesh: ImmediateMesh = ImmediateMesh.new()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	var minor: Color = Color(0.20, 0.20, 0.22, 0.35)
	var major: Color = Color(0.90, 0.62, 0.30, 0.75)
	var x: float = floor(bounds.position.x)
	while x <= bounds.position.x + bounds.size.x + 0.001:
		mesh.surface_set_color(major if is_zero_approx(fmod(absf(x), 5.0)) else minor)
		mesh.surface_add_vertex(Vector3(x, 0.02, bounds.position.y))
		mesh.surface_add_vertex(Vector3(x, 0.02, bounds.position.y + bounds.size.y))
		x += 1.0
	var z: float = floor(bounds.position.y)
	while z <= bounds.position.y + bounds.size.y + 0.001:
		mesh.surface_set_color(major if is_zero_approx(fmod(absf(z), 5.0)) else minor)
		mesh.surface_add_vertex(Vector3(bounds.position.x, 0.02, z))
		mesh.surface_add_vertex(Vector3(bounds.position.x + bounds.size.x, 0.02, z))
		z += 1.0
	mesh.surface_end()
	_grid = MeshInstance3D.new()
	_grid.name = "ReviewGrid"
	_grid.mesh = mesh
	_grid.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_grid.visible = grid_visible
	_visuals.add_child(_grid)


func set_grid_visible(value: bool) -> void:
	grid_visible = value
	if _grid != null:
		_grid.visible = value


func _add_solid_collision_only(solid_name: String, size: Vector3, at: Vector3, carve: bool) -> void:
	var shape: CollisionShape3D = CollisionShape3D.new()
	shape.name = solid_name
	var box: BoxShape3D = BoxShape3D.new()
	box.size = size
	shape.shape = box
	shape.position = at
	_collision.add_child(shape)
	if carve:
		_carve_navigation(solid_name, size, at)


## Same measured lesson Gate 1A recorded: a box collider whose top lies outside
## the navigation bake volume rasterises as an open-topped well with a walkable
## phantom interior. Every non-ground solid also carves its own footprint out
## of the baked mesh.
func _carve_navigation(solid_name: String, size: Vector3, at: Vector3) -> void:
	var obstacle: NavigationObstacle3D = NavigationObstacle3D.new()
	obstacle.name = "%sCarve" % solid_name
	obstacle.position = Vector3(at.x, 0.0, at.z)
	obstacle.height = size.y
	obstacle.affect_navigation_mesh = true
	obstacle.carve_navigation_mesh = true
	obstacle.avoidance_enabled = false
	var half_x: float = size.x * 0.5
	var half_z: float = size.z * 0.5
	obstacle.vertices = PackedVector3Array([
		Vector3(-half_x, 0.0, -half_z),
		Vector3(half_x, 0.0, -half_z),
		Vector3(half_x, 0.0, half_z),
		Vector3(-half_x, 0.0, half_z),
	])
	_obstacles.add_child(obstacle)


func _lit_material(colour: Color) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = colour
	material.roughness = 0.92
	material.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	return material


func _unshaded_material(colour: Color, alpha: float) -> StandardMaterial3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA if alpha < 0.999 else BaseMaterial3D.TRANSPARENCY_DISABLED
	material.albedo_color = Color(colour.r, colour.g, colour.b, alpha)
	return material


# --- Measurement, exact rather than sampled -------------------------------

## Coordinate-compressed rectangle-union area: exact, not a sampled grid.
static func _rect_union_area(rects: Array[Rect2]) -> float:
	if rects.is_empty():
		return 0.0
	var xs: Array[float] = []
	for r: Rect2 in rects:
		xs.append(r.position.x)
		xs.append(r.position.x + r.size.x)
	xs.sort()
	var total: float = 0.0
	for i: int in range(xs.size() - 1):
		var x0: float = xs[i]
		var x1: float = xs[i + 1]
		var width: float = x1 - x0
		if width <= 0.0000001:
			continue
		var xm: float = (x0 + x1) * 0.5
		var intervals: Array[Vector2] = []
		for r: Rect2 in rects:
			if xm >= r.position.x and xm <= r.position.x + r.size.x:
				intervals.append(Vector2(r.position.y, r.position.y + r.size.y))
		if intervals.is_empty():
			continue
		intervals.sort_custom(func(a: Vector2, b: Vector2) -> bool: return a.x < b.x)
		var merged: float = 0.0
		var cur_start: float = intervals[0].x
		var cur_end: float = intervals[0].y
		for j: int in range(1, intervals.size()):
			var iv: Vector2 = intervals[j]
			if iv.x <= cur_end + 0.0000001:
				cur_end = maxf(cur_end, iv.y)
			else:
				merged += cur_end - cur_start
				cur_start = iv.x
				cur_end = iv.y
		merged += cur_end - cur_start
		total += width * merged
	return total


static func _rect_overlap_area(a: Rect2, b: Rect2) -> float:
	var x0: float = maxf(a.position.x, b.position.x)
	var x1: float = minf(a.position.x + a.size.x, b.position.x + b.size.x)
	var z0: float = maxf(a.position.y, b.position.y)
	var z1: float = minf(a.position.y + a.size.y, b.position.y + b.size.y)
	if x1 <= x0 or z1 <= z0:
		return 0.0
	return (x1 - x0) * (z1 - z0)


## Exact ray-versus-rectangle slab intersection: the distance along `dir` from
## `origin` to the first point where the ray enters `rect`, or INF if it never
## does. `origin` already inside `rect` reports 0.0 rather than a negative or
## undefined distance.
static func _ray_rect_hit(origin: Vector2, dir: Vector2, rect: Rect2) -> float:
	var t_min: float = 0.0
	var t_max: float = INF
	for axis: int in [0, 1]:
		var o: float = origin.x if axis == 0 else origin.y
		var d: float = dir.x if axis == 0 else dir.y
		var lo: float = rect.position.x if axis == 0 else rect.position.y
		var hi: float = lo + (rect.size.x if axis == 0 else rect.size.y)
		if absf(d) < 0.0000001:
			if o < lo or o > hi:
				return INF
			continue
		var t1: float = (lo - o) / d
		var t2: float = (hi - o) / d
		if t1 > t2:
			var swap: float = t1
			t1 = t2
			t2 = swap
		t_min = maxf(t_min, t1)
		t_max = minf(t_max, t2)
		if t_min > t_max:
			return INF
	return t_min if t_min > 0.0000001 else 0.0


func footprint_area() -> float:
	return _rect_union_area(WALKABLE)


func centreline_length() -> float:
	var total: float = 0.0
	for i: int in range(1, CENTRELINE.size()):
		total += CENTRELINE[i].distance_to(CENTRELINE[i - 1])
	return total


func centreline_point(along: float) -> Vector2:
	var total: float = centreline_length()
	var remaining: float = clampf(along, 0.0, total)
	for i: int in range(1, CENTRELINE.size()):
		var a: Vector2 = CENTRELINE[i - 1]
		var b: Vector2 = CENTRELINE[i]
		var seg_len: float = a.distance_to(b)
		if remaining <= seg_len or i == CENTRELINE.size() - 1:
			var t: float = 0.0 if seg_len < 0.0001 else clampf(remaining / seg_len, 0.0, 1.0)
			return a.lerp(b, t)
		remaining -= seg_len
	return CENTRELINE[CENTRELINE.size() - 1]


func centreline_tangent(along: float) -> Vector2:
	var total: float = centreline_length()
	var eps: float = 0.25
	var a: Vector2 = centreline_point(maxf(along - eps, 0.0))
	var b: Vector2 = centreline_point(minf(along + eps, total))
	var d: Vector2 = b - a
	if d.length() < 0.0001:
		return Vector2(0.0, -1.0)
	return d.normalized()


func centreline_world() -> PackedVector3Array:
	var out: PackedVector3Array = PackedVector3Array()
	for point: Vector2 in CENTRELINE:
		out.append(global_transform * Vector3(point.x, 0.0, point.y))
	return out


## The number of times the centreline's own heading changes by more than 25
## degrees between consecutive segments — a measured count of real direction
## changes, for the "visibly changes direction at least twice" requirement.
func direction_change_count(threshold_degrees: float = 25.0) -> int:
	var changes: int = 0
	for i: int in range(1, CENTRELINE.size() - 1):
		var a: Vector2 = (CENTRELINE[i] - CENTRELINE[i - 1]).normalized()
		var b: Vector2 = (CENTRELINE[i + 1] - CENTRELINE[i]).normalized()
		var angle: float = rad_to_deg(absf(a.angle_to(b)))
		if angle >= threshold_degrees:
			changes += 1
	return changes


## The centreline's own lateral (X) range, in the composition's local frame —
## a measured fact about how much the route actually swings sideways.
func lateral_swing() -> float:
	var low: float = INF
	var high: float = -INF
	for point: Vector2 in CENTRELINE:
		low = minf(low, point.x)
		high = maxf(high, point.x)
	return high - low


func _solid_rects() -> Array[Rect2]:
	var rects: Array[Rect2] = []
	rects.append_array(_boundary_rects)
	rects.append_array(_architecture_rects)
	return rects


func _march(origin: Vector2, dir: Vector2, solids: Array[Rect2]) -> float:
	var best: float = MAX_SEARCH_METRES
	for rect: Rect2 in solids:
		var hit: float = _ray_rect_hit(origin, dir, rect)
		if hit < best:
			best = hit
	return best


## Width sampled every `WIDTH_STEP` along the centreline, perpendicular to the
## tangent, by exact ray-versus-rectangle arithmetic against every solid the
## scene actually built — not a fixed step probe.
func width_samples() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	var total: float = centreline_length()
	var solids: Array[Rect2] = _solid_rects()
	var along: float = 0.0
	while along <= total + 0.0001:
		var point: Vector2 = centreline_point(along)
		var tangent: Vector2 = centreline_tangent(along)
		var perp: Vector2 = Vector2(-tangent.y, tangent.x)
		var pos: float = _march(point, perp, solids)
		var neg: float = _march(point, -perp, solids)
		out.append({"along": along, "width": pos + neg, "point": point})
		along += WIDTH_STEP
	return out


func narrowest_clearance() -> float:
	var narrowest: float = INF
	for sample: Dictionary in width_samples():
		narrowest = minf(narrowest, float(sample["width"]))
	return narrowest if narrowest < INF else 0.0


func narrowest_sample() -> Dictionary:
	var best: Dictionary = {}
	var narrowest: float = INF
	for sample: Dictionary in width_samples():
		if float(sample["width"]) < narrowest:
			narrowest = float(sample["width"])
			best = sample
	return best


func widths_in_ordinary_band() -> int:
	var count: int = 0
	for sample: Dictionary in width_samples():
		var width: float = float(sample["width"])
		if width >= ORDINARY_WIDTH_MIN and width <= ORDINARY_WIDTH_MAX:
			count += 1
	return count


func widths_wider_than_ordinary() -> int:
	var count: int = 0
	for sample: Dictionary in width_samples():
		if float(sample["width"]) > ORDINARY_WIDTH_MAX:
			count += 1
	return count


func widths_narrower_than_ordinary() -> int:
	var count: int = 0
	for sample: Dictionary in width_samples():
		if float(sample["width"]) < ORDINARY_WIDTH_MIN:
			count += 1
	return count


func median_width() -> float:
	var widths: Array[float] = []
	for sample: Dictionary in width_samples():
		widths.append(float(sample["width"]))
	if widths.is_empty():
		return 0.0
	widths.sort()
	var mid: int = widths.size() / 2
	if widths.size() % 2 == 0:
		return (widths[mid - 1] + widths[mid]) * 0.5
	return widths[mid]


## The measured gap at the Watch Breach specifically: the narrowest width
## sample whose station lies alongside the two gatehouse masses that actually
## frame the gap (their combined Z span), rather than a separately authored
## "breach court" rectangle the route might not precisely cross.
func breach_clearance() -> float:
	var total: float = centreline_length()
	var z_low: float = minf(GATEHOUSE_WEST.position.y, GATEHOUSE_EAST.position.y) - 1.0
	var z_high: float = maxf(
		GATEHOUSE_WEST.position.y + GATEHOUSE_WEST.size.y,
		GATEHOUSE_EAST.position.y + GATEHOUSE_EAST.size.y
	) + 1.0
	var narrowest: float = INF
	for sample: Dictionary in width_samples():
		var point: Vector2 = sample["point"]
		if point.y >= z_low and point.y <= z_high:
			narrowest = minf(narrowest, float(sample["width"]))
	return narrowest if narrowest < INF else total


## 1 minus (boundary/architecture footprint that overlaps walkable ground) /
## footprint. Most boundary mass sits outside the walkable union by
## construction; the ruin fragments and the parts of the bend mass or
## gatehouses that legally nibble a room's edge count against it, exactly as
## built.
func clear_fraction() -> float:
	var footprint: float = footprint_area()
	if footprint <= 0.0:
		return 1.0
	var obstacle_total: float = 0.0
	for solid: Rect2 in _solid_rects():
		for walkable: Rect2 in WALKABLE:
			obstacle_total += _rect_overlap_area(solid, walkable)
	return 1.0 - clampf(obstacle_total / footprint, 0.0, 1.0)


func _overall_bounds() -> Rect2:
	var bounds: Rect2 = WALKABLE[0]
	for rect: Rect2 in WALKABLE:
		bounds = bounds.merge(rect)
	for rect: Rect2 in _boundary_rects:
		bounds = bounds.merge(rect)
	return bounds.grow(2.0)


func bake_rect() -> Rect2:
	return _overall_bounds()


func player_start() -> Vector3:
	return global_transform * Vector3(PLAYER_START.x, 0.0, PLAYER_START.y)


func way_out() -> Vector3:
	return global_transform * Vector3(WAY_OUT.x, 0.0, WAY_OUT.y)


func socket_positions() -> Dictionary:
	return {"PlayerStart": player_start(), "WayOut": way_out()}
