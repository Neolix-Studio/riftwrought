class_name ProductionArena
extends Node3D

## ONE SMALL PRODUCTION TEST ARENA.
##
## ============================================================================
## THIS IS A TEST ARENA. IT IS NOT A ZONE, A ROOM LIBRARY OR CAMPAIGN CONTENT.
## ============================================================================
## No campaign, prologue or Act I content is authored here, and no zone contract
## is claimed. Stock low-poly geometry is NOT presented as final production art;
## every colour is a RUNTIME MATERIAL OVERRIDE and no source mesh is edited.
##
## ---------------------------------------------------------------------------
## WHAT IS DELIBERATELY DIFFERENT FROM BOTH SPIKES
## ---------------------------------------------------------------------------
## `game3d_spike/` used "a simple perimeter box, NOT authored per-mesh" for
## collision and had NO navigation mesh at all -- it said so plainly, and for a
## feasibility spike that was the right scope. A production foundation cannot
## inherit it, so here:
##   * every blocking piece carries its OWN collider, sized from its OWN AABB;
##   * a real NavigationMesh is BAKED FROM THOSE COLLIDERS, exactly once;
##   * the layout is TWO CHAMBERS JOINED BY A ONE-MODULE DOORWAY, because a
##     corridor is the only thing that can prove agent-radius erosion did not
##     silently delete one;
##   * an INTERIOR BLOCKER stands in the west chamber, so a path across it must
##     be a route rather than a straight line -- and can be measured as one.
##
## Layout, in metres (the grid module is MEASURED at runtime, not assumed):
##
##        z=-11 +----------------------+
##              |   WEST CHAMBER       |#|   EAST
##              |          [blocker]   |#|  CHAMBER
##        z=0   |            x=-7      | |<- doorway at x=1, z=0
##              |                      |#|
##        z=+11 +----------------------+
##             x=-19                  x=1      x=13

const MODULE := 2.0                     ## the grid pitch; the MESH is measured

var static_pieces: int = 0
var colliders: int = 0
var torch_lights: Array[OmniLight3D] = []
var nav_region: NavigationRegion3D
var measured_floor_size: Vector2 = Vector2.ZERO
var measured_wall_size: Vector3 = Vector3.ZERO
var bake_count: int = 0
var parsed_source_vertices: int = 0

var _rng := RandomNumberGenerator.new()
var _geometry_root: Node3D

## AUTHORED WALKABLE RECTANGLES.
##
## ============================================================================
## THESE ARE WHAT REACHABILITY IS PROVED AGAINST -- BY PATH, TO THE CENTRE.
## ============================================================================
## This project has already been bitten once: a completely sealed 70 m^2 alcove
## passed every socket check it had, because it had no sockets. "Every socket is
## on the navigation mesh" and "you can walk there" are different claims, and
## only the second matters.
static func walkable_rects() -> Array:
	return [
		{"name": "west_north", "centre": Vector3(-10, 0, -7)},
		{"name": "west_south", "centre": Vector3(-10, 0, 7)},
		{"name": "west_of_blocker", "centre": Vector3(-13, 0, 0)},
		{"name": "east_of_blocker", "centre": Vector3(-3, 0, 0)},
		{"name": "doorway", "centre": Vector3(1, 0, 0)},
		{"name": "east_chamber", "centre": Vector3(7, 0, 0)},
	]

## Points that MUST be unreachable. A guard that accepts everything protects
## nothing, so the reachability test is fed these and required to refuse.
static func unreachable_probes() -> Array:
	return [
		{"name": "far_outside_the_arena", "point": Vector3(0, 0, 60)},
		{"name": "inside_the_west_wall", "point": Vector3(-20.5, 0, 0)},
	]

static func player_spawn() -> Vector3:
	return Vector3(-13, 0, 0)

## The doorway, and the axis to measure its usable width ACROSS.
static func doorway_centre() -> Vector3:
	return Vector3(1, 0, 0)

static func doorway_across() -> Vector3:
	return Vector3(0, 0, 1)

static func stone_rules() -> Array:
	return [
		{"match": "Highlights", "color": ProdConfig.COL_STONE_HIGHLIGHT, "rough": 0.90, "spec": 0.12},
		{"match": "Main", "color": ProdConfig.COL_STONE_MAIN, "rough": 0.93, "spec": 0.10},
		{"match": "DarkMetal", "color": ProdConfig.COL_METAL, "rough": 0.62, "metal": 0.55},
		{"match": "Fire", "color": ProdConfig.COL_TORCH_WARM, "rough": 0.40,
		 "emission": ProdConfig.COL_TORCH_WARM, "energy": 7.0},
		{"match": "Wood", "color": ProdConfig.COL_WOOD, "rough": 0.90},
		{"match": "Steel", "color": ProdConfig.COL_METAL, "rough": 0.55, "metal": 0.60},
		{"match": "Bone", "color": Color(0.30, 0.30, 0.28), "rough": 0.88},
		{"match": "White", "color": Color(0.26, 0.26, 0.25), "rough": 0.88},
		{"match": "Leaf", "color": Color(0.106, 0.148, 0.124), "rough": 0.94},
		{"match": "Grass", "color": Color(0.106, 0.148, 0.124), "rough": 0.94},
	]

# ----------------------------------------------------------------- pieces ----

## A visual piece with NO collider — decoration that must never block a path.
func decor(model: String, pos: Vector3, yaw_deg: float = 0.0) -> MeshInstance3D:
	var m: Mesh = load(AssetManifest.ruins(model))
	if m == null:
		push_error("FOUNDATION: arena model missing: %s" % model)
		return null
	var mi := MeshInstance3D.new()
	mi.name = model
	mi.mesh = m
	mi.position = pos
	mi.rotation_degrees = Vector3(0, yaw_deg, 0)
	_geometry_root.add_child(mi)
	RigCorpus.tint_all(mi, stone_rules(), ProdConfig.COL_STONE_MAIN)
	static_pieces += 1
	return mi

## A BLOCKING piece: mesh plus its OWN collider, sized from its OWN measured
## AABB. `tall` extends the collider upward so the navigation baker sees a solid
## obstruction through the whole sampled band rather than a low lip it can step
## over.
func blocker(model: String, pos: Vector3, yaw_deg: float = 0.0,
		tall: float = 3.2) -> MeshInstance3D:
	var mi := decor(model, pos, yaw_deg)
	if mi == null:
		return null
	var a: AABB = mi.mesh.get_aabb()
	var sb := StaticBody3D.new()
	sb.name = model + "_Body"
	sb.collision_layer = 4
	sb.collision_mask = 0
	var cs := CollisionShape3D.new()
	var bx := BoxShape3D.new()
	# MEASURED from the mesh, not guessed. The vertical extent is deliberately
	# forced tall; the horizontal extents are the mesh's own.
	bx.size = Vector3(maxf(a.size.x, 0.15), tall, maxf(a.size.z, 0.15))
	cs.shape = bx
	cs.position = Vector3(a.get_center().x, tall * 0.5 - 0.2, a.get_center().z)
	sb.position = pos
	sb.rotation_degrees = Vector3(0, yaw_deg, 0)
	sb.add_child(cs)
	_geometry_root.add_child(sb)
	colliders += 1
	return mi

func floor_slab(x0: float, x1: float, z0: float, z1: float) -> void:
	var sb := StaticBody3D.new()
	sb.name = "FloorBody"
	sb.collision_layer = 4
	sb.collision_mask = 0
	var cs := CollisionShape3D.new()
	var bx := BoxShape3D.new()
	bx.size = Vector3(x1 - x0, 0.5, z1 - z0)
	cs.shape = bx
	cs.position = Vector3((x0 + x1) * 0.5, -0.25, (z0 + z1) * 0.5)
	sb.add_child(cs)
	_geometry_root.add_child(sb)
	colliders += 1

func torch(pos: Vector3, yaw_deg: float = 0.0) -> void:
	decor("Torch", pos, yaw_deg)
	var l := OmniLight3D.new()
	l.light_color = ProdConfig.COL_TORCH_WARM
	l.light_energy = ProdConfig.TORCH_LIGHT_ENERGY
	l.omni_range = ProdConfig.TORCH_LIGHT_RANGE
	l.omni_attenuation = 1.6
	l.shadow_enabled = false
	l.position = pos + Vector3(0, 0.95, 0)
	add_child(l)
	torch_lights.append(l)

# ------------------------------------------------------------------ build ----

func build() -> void:
	_rng.seed = 20260917                 # deterministic; no unseeded randomness
	_geometry_root = Node3D.new()
	_geometry_root.name = "Geometry"
	add_child(_geometry_root)

	# Measure the modules FIRST, so the report states measured sizes rather than
	# the assumed 2.0 m pitch.
	var fm: Mesh = load(AssetManifest.ruins("Floor_Standard"))
	if fm != null:
		var fa := fm.get_aabb()
		measured_floor_size = Vector2(fa.size.x, fa.size.z)
	var wm: Mesh = load(AssetManifest.ruins("Wall"))
	if wm != null:
		measured_wall_size = wm.get_aabb().size

	_build_floors()
	_build_walls()
	_build_obstacles()
	_build_lighting()
	_build_navigation()

func _build_floors() -> void:
	for gx in range(-9, 1):
		for gz in range(-5, 6):
			decor("Floor_Standard", Vector3(gx * MODULE, 0, gz * MODULE),
				90.0 * float(_rng.randi_range(0, 3)))
	for gx in range(1, 7):
		for gz in range(-3, 4):
			decor("Floor_Standard", Vector3(gx * MODULE, 0, gz * MODULE),
				90.0 * float(_rng.randi_range(0, 3)))
	# ONE collider per chamber floor, because a floor is genuinely one surface.
	# The per-piece rule is about BLOCKING geometry, which is what can delete a
	# path; a floor slab cannot.
	floor_slab(-19.0, 1.0, -11.0, 11.0)
	floor_slab(1.0, 13.0, -7.0, 7.0)

func _build_walls() -> void:
	var kinds := ["Wall", "Wall_Broken"]
	# --- the divider, with ONE MODULE left open as the doorway ---------------
	for gz in range(-5, 6):
		if gz == 0:
			continue                      # THE DOORWAY
		blocker(kinds[_rng.randi_range(0, 1)], Vector3(1.0, 0, gz * MODULE), 90.0)
	decor("Arch_Gothic", Vector3(1.0, 0, 0.0), 90.0)

	# --- west chamber perimeter ---------------------------------------------
	for gz in range(-5, 6):
		blocker(kinds[_rng.randi_range(0, 1)], Vector3(-19.0, 0, gz * MODULE), 90.0)
	for gx in range(-9, 1):
		blocker(kinds[_rng.randi_range(0, 1)], Vector3(gx * MODULE, 0, -11.0), 0.0)
		blocker(kinds[_rng.randi_range(0, 1)], Vector3(gx * MODULE, 0, 11.0), 0.0)

	# --- east chamber perimeter ---------------------------------------------
	for gz in range(-3, 4):
		blocker(kinds[_rng.randi_range(0, 1)], Vector3(13.0, 0, gz * MODULE), 90.0)
	for gx in range(1, 7):
		blocker(kinds[_rng.randi_range(0, 1)], Vector3(gx * MODULE, 0, -7.0), 0.0)
		blocker(kinds[_rng.randi_range(0, 1)], Vector3(gx * MODULE, 0, 7.0), 0.0)

	# --- THE INTERIOR BLOCKER -----------------------------------------------
	# Three wall modules across the west chamber's middle, open at both ends. A
	# path from one side to the other MUST route around it, which is the only
	# honest way to prove the enemy is following a navigation path rather than
	# walking at the player.
	for gz in [-1, 0, 1]:
		blocker("Wall", Vector3(-7.0, 0, gz * MODULE), 90.0)

func _build_obstacles() -> void:
	for p in [Vector3(-15, 0, -7), Vector3(-15, 0, 7), Vector3(-3, 0, -7),
			  Vector3(-3, 0, 7), Vector3(5, 0, -4), Vector3(5, 0, 4)]:
		blocker("Column_Round", p, 0.0)
	blocker("Statue_Stag", Vector3(11, 0, 5), 215.0)
	# Small props, deterministic, kept clear of every authored rectangle centre
	# and of the doorway.
	var props := ["Barrel", "Crate"]
	var keep_clear := walkable_rects()
	for i in range(18):
		var px := _rng.randf_range(-18.0, 12.0)
		var pz := _rng.randf_range(-10.0, 10.0)
		if px > 0.0 and absf(pz) > 6.0:
			continue                       # outside the east chamber
		var p := Vector3(px, 0, pz)
		var too_close := false
		for r in keep_clear:
			if NavService.planar_distance(p, r["centre"]) < 2.4:
				too_close = true
		if absf(px - 1.0) < 3.0 and absf(pz) < 3.0:
			too_close = true               # never obstruct the doorway
		if absf(px + 7.0) < 1.6:
			too_close = true               # never sit inside the blocker line
		if too_close:
			continue
		blocker(props[_rng.randi_range(0, 1)], p, _rng.randf_range(0, 360), 1.4)

func _build_lighting() -> void:
	for t in [[Vector3(-18.6, 0.55, -6.0), 90.0], [Vector3(-18.6, 0.55, 6.0), 90.0],
			  [Vector3(-10.0, 0.55, -10.6), 0.0], [Vector3(-10.0, 0.55, 10.6), 0.0],
			  [Vector3(-2.0, 0.55, -10.6), 0.0], [Vector3(0.4, 0.55, -4.0), 270.0],
			  [Vector3(0.4, 0.55, 4.0), 270.0], [Vector3(12.6, 0.55, 0.0), 90.0],
			  [Vector3(7.0, 0.55, -6.6), 0.0]]:
		torch(t[0], t[1])

# ------------------------------------------------------------- navigation ----

func _build_navigation() -> void:
	nav_region = NavigationRegion3D.new()
	nav_region.name = "NavRegion"
	add_child(nav_region)

	var nm := NavigationMesh.new()
	# PARSE THE AUTHORED COLLIDERS, not the visual meshes.
	#
	# `CLAUDE.md` section 5 says the navigation surface is baked "from the room's
	# own static colliders". Baking from visual meshes instead would bake a
	# surface the body cannot actually occupy, and the two would drift apart the
	# first time a collider was adjusted.
	nm.geometry_parsed_geometry_type = NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS
	nm.geometry_source_geometry_mode = NavigationMesh.SOURCE_GEOMETRY_ROOT_NODE_CHILDREN
	nm.geometry_collision_mask = 4
	nm.agent_radius = ProdConfig.NAV_AGENT_RADIUS
	nm.agent_height = ProdConfig.NAV_AGENT_HEIGHT
	nm.agent_max_climb = ProdConfig.NAV_AGENT_MAX_CLIMB
	nm.agent_max_slope = ProdConfig.NAV_AGENT_MAX_SLOPE_DEG
	nm.cell_size = ProdConfig.NAV_CELL_SIZE
	nm.cell_height = ProdConfig.NAV_CELL_HEIGHT
	# CONFINE THE BAKE TO THE GROUND BAND.
	#
	# `CLAUDE.md` section 5.2 records that 2D REMOVED the "open-topped box
	# collider baking a walkable interior" defect, because a navigation polygon
	# has no height. THREE DIMENSIONS BRING IT BACK: the flat top of a column is
	# a perfectly good walkable surface as far as the baker is concerned, and an
	# island of navigation mesh three metres in the air passes every count-based
	# check ever written. Confining the bake volume removes the cause; the suite
	# still asserts the property, because a fix nobody verifies is a hope.
	nm.filter_baking_aabb = AABB(Vector3(-26.0, -1.5, -16.0), Vector3(46.0, 3.0, 32.0))

	# PARSE EXPLICITLY, FROM THE ARENA, RATHER THAN LETTING THE REGION GUESS.
	#
	# `NavigationRegion3D.bake_navigation_mesh()` parses the REGION's own
	# children. The arena's colliders are the region's SIBLINGS, so that call
	# bakes an EMPTY mesh -- and it does so silently, reporting success. It was
	# caught here only because the suite measures the polygon count instead of
	# trusting the bake, which is the whole reason that measurement exists.
	#
	# Parsing from an explicit root makes the source of the navigation surface a
	# stated fact rather than an accident of where a node happens to sit.
	var src := NavigationMeshSourceGeometryData3D.new()
	NavigationServer3D.parse_source_geometry_data(nm, src, self)
	parsed_source_vertices = src.get_vertices().size() / 3
	NavigationServer3D.bake_from_source_geometry_data(nm, src)
	nav_region.navigation_mesh = nm
	bake_count += 1

func nav_mesh() -> NavigationMesh:
	return nav_region.navigation_mesh if nav_region != null else null

## Every blocking collider in the arena, so the suite can assert that collision
## is authored per piece rather than approximated by one perimeter box.
func collider_count() -> int:
	return colliders

func authored_floor_area_m2() -> float:
	return (20.0 * 22.0) + (12.0 * 14.0)
