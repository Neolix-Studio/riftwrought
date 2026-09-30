class_name SpikeArena
extends Node3D

## THE SPIKE'S TEST YARD — engine primitives only.
##
## ============================================================================
## NOT A ZONE, NOT A ROOM, NOT CAMPAIGN CONTENT, AND NOT THE game3d/ ARENA.
## ============================================================================
## game3d/'s production arena is built from the Ultimate Modular Ruins pack,
## which this spike is NOT authorized to import. So this yard is a floor, four
## low walls and two target dummies -- nothing else -- so the only art on screen
## is the art being judged: the Huntress, the bow, the arrow, the control body.
##
## ONE navigation bake, from the yard's own static colliders (layer 4), through
## the verbatim `NavService` -- exactly the method game3d/ uses. The two dummies
## are children of this node when the bake runs, so paths route around them.

const HALF_X := 15.0
const HALF_Z := 10.0

var nav_region: NavigationRegion3D
var bake_count: int = 0
var parsed_vertices: int = 0
var colliders: int = 0

func build_geometry() -> void:
	var floor_mat := StandardMaterial3D.new()
	# NEUTRAL, not blue: under the accepted cold moonlight a blue-grey floor
	# rendered saturated blue and swallowed the dark bow (first rendered look).
	floor_mat.albedo_color = Color(0.165, 0.160, 0.158)
	floor_mat.roughness = 0.94
	var floor_mi := MeshInstance3D.new()
	floor_mi.name = "Floor"
	var pm := PlaneMesh.new()
	pm.size = Vector2(HALF_X * 2.0, HALF_Z * 2.0)
	floor_mi.mesh = pm
	floor_mi.material_override = floor_mat
	add_child(floor_mi)
	_body_box("FloorBody", Vector3(0, -0.25, 0), Vector3(HALF_X * 2.0, 0.5, HALF_Z * 2.0), false)
	# A faint one-metre grid: a SCALE REFERENCE for judging stride and draw, and
	# nothing else. Unshaded, dim, drawn just above the floor.
	var grid := MeshInstance3D.new()
	grid.name = "MetreGrid"
	var im := ImmediateMesh.new()
	im.surface_begin(Mesh.PRIMITIVE_LINES)
	for x in range(int(-HALF_X), int(HALF_X) + 1):
		im.surface_add_vertex(Vector3(x, 0.004, -HALF_Z))
		im.surface_add_vertex(Vector3(x, 0.004, HALF_Z))
	for z in range(int(-HALF_Z), int(HALF_Z) + 1):
		im.surface_add_vertex(Vector3(-HALF_X, 0.004, z))
		im.surface_add_vertex(Vector3(HALF_X, 0.004, z))
	im.surface_end()
	grid.mesh = im
	var gm := StandardMaterial3D.new()
	gm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	gm.albedo_color = Color(0.24, 0.24, 0.25)
	grid.material_override = gm
	add_child(grid)
	var wall_mat := StandardMaterial3D.new()
	wall_mat.albedo_color = Color(0.215, 0.212, 0.212)
	wall_mat.roughness = 0.93
	for w in [[Vector3(0, 0, -HALF_Z - 0.5), Vector3(HALF_X * 2.0 + 2.0, 1.0, 1.0)],
			[Vector3(0, 0, HALF_Z + 0.5), Vector3(HALF_X * 2.0 + 2.0, 1.0, 1.0)],
			[Vector3(-HALF_X - 0.5, 0, 0), Vector3(1.0, 1.0, HALF_Z * 2.0)],
			[Vector3(HALF_X + 0.5, 0, 0), Vector3(1.0, 1.0, HALF_Z * 2.0)]]:
		var mi := MeshInstance3D.new()
		mi.name = "Wall"
		var bm := BoxMesh.new()
		bm.size = w[1]
		mi.mesh = bm
		mi.material_override = wall_mat
		mi.position = (w[0] as Vector3) + Vector3(0, 0.5, 0)
		add_child(mi)
		# The collider is TALL, as game3d/'s are, so the baker sees a solid
		# obstruction through the whole sampled band.
		var sz: Vector3 = w[1]
		_body_box("WallBody", (w[0] as Vector3) + Vector3(0, 1.4, 0), Vector3(sz.x, 3.2, sz.z), true)

## YARD LIGHTS -- PROVISIONAL, so the review can SEE. game3d/'s arena is lit by
## nine torches; this yard has none, and under the accepted moonlight alone the
## first renders were too dim to judge a dark bow at gameplay framing. They are
## visibility, not a lighting design, and nothing here is carried anywhere.
func build_lights() -> void:
	for p in [Vector3(-7.5, 3.2, 3.0), Vector3(7.5, 3.2, 3.0), Vector3(0.0, 3.2, -5.0), Vector3(0.0, 3.2, 7.0)]:
		var l := OmniLight3D.new()
		l.name = "YardLight"
		l.light_color = Color(1.0, 0.86, 0.70)
		l.light_energy = SpikeConfig.YARD_LIGHT_ENERGY
		l.omni_range = 11.0
		l.omni_attenuation = 1.4
		l.shadow_enabled = false
		l.position = p
		add_child(l)

func _body_box(n: String, pos: Vector3, size: Vector3, _blocking: bool) -> void:
	var sb := StaticBody3D.new()
	sb.name = n
	sb.collision_layer = 4
	sb.collision_mask = 0
	var cs := CollisionShape3D.new()
	var bx := BoxShape3D.new()
	bx.size = size
	cs.shape = bx
	sb.position = pos
	sb.add_child(cs)
	add_child(sb)
	colliders += 1

## Bakes ONCE, from THIS node's static colliders -- the method game3d/ proved:
## parse explicitly from an explicit root, because a region's own bake parses its
## children and would bake an EMPTY mesh here, silently.
func bake() -> void:
	nav_region = NavigationRegion3D.new()
	nav_region.name = "NavRegion"
	add_child(nav_region)
	var nm := NavigationMesh.new()
	nm.geometry_parsed_geometry_type = NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS
	nm.geometry_source_geometry_mode = NavigationMesh.SOURCE_GEOMETRY_ROOT_NODE_CHILDREN
	nm.geometry_collision_mask = 4
	nm.agent_radius = ProdConfig.NAV_AGENT_RADIUS
	nm.agent_height = ProdConfig.NAV_AGENT_HEIGHT
	nm.agent_max_climb = ProdConfig.NAV_AGENT_MAX_CLIMB
	nm.agent_max_slope = ProdConfig.NAV_AGENT_MAX_SLOPE_DEG
	nm.cell_size = ProdConfig.NAV_CELL_SIZE
	nm.cell_height = ProdConfig.NAV_CELL_HEIGHT
	nm.filter_baking_aabb = AABB(Vector3(-HALF_X - 3.0, -1.5, -HALF_Z - 3.0),
		Vector3(HALF_X * 2.0 + 6.0, 3.0, HALF_Z * 2.0 + 6.0))
	var src := NavigationMeshSourceGeometryData3D.new()
	NavigationServer3D.parse_source_geometry_data(nm, src, self)
	parsed_vertices = src.get_vertices().size() / 3
	NavigationServer3D.bake_from_source_geometry_data(nm, src)
	nav_region.navigation_mesh = nm
	bake_count += 1

func nav_mesh() -> NavigationMesh:
	return nav_region.navigation_mesh if nav_region != null else null

## Authored walkable probes, for reachability BY PATH (not by socket).
static func walkable_probes() -> Array:
	return [Vector3(-10, 0, 6), Vector3(10, 0, 6), Vector3(0, 0, -7), Vector3(-10, 0, -7), Vector3(10, 0, -7)]

## Points that MUST be unreachable -- the negative control.
static func unreachable_probes() -> Array:
	return [Vector3(0, 0, 40), Vector3(HALF_X + 3.0, 0, 0)]
