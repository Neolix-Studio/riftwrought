class_name RiftNexusLayout
extends Node3D
## First-MVP — Gate 1E: the MINIMAL Rift Nexus production shell (D-219).
##
## The brief: "Build only enough of the Nexus to support this milestone. The
## complete hub eventually targets a larger spacious layout, but this gate needs
## only a minimal production shell." So this is a real place the character walks
## into, not a placeholder room, and it is deliberately smaller than the
## canonical hub.
##
## MEASURED SCALE, AND THE DEFERRAL STATED RATHER THAN IMPLIED.
## `design/CROWNLESS_BASTION_ROOM_LIBRARY_AND_MAP_AUTHORING_BLUEPRINT.md` §13
## targets approximately 5-8 CF for the finished Nexus. This shell measures
## about 3.5 CF — comfortably larger than the Nexus Threshold that precedes it
## and larger than anything else in the opening, so it reads as arrival, and
## honestly short of the eventual target. Growing it to 5-8 CF belongs with the
## stations it does not yet have.
##
## STATIONS: THE BRIEF SAYS PREFER ABSENCE. "Do not populate it with fake future
## stations merely because the final design lists them ... Prefer absence over a
## screen full of disabled future buttons." So the Forge, Run Assembly,
## Pursuits, Distortions, Echo Hunt, the Vault and the Reliquary are ABSENT —
## not greyed out, not labelled "coming soon", not present as empty plinths.
## The only architectural placeholder is the ONE thing the brief explicitly asks
## for: a visibly closed forward route toward First Footing, which is a real
## decision the player is about to have and therefore earns its place.
##
## IT IS AN OPEN-AIR WALLED ENCLOSURE, AND THAT IS A MEASURED CONSTRAINT RATHER
## THAN A STYLE CHOICE. The project's whole extracted inventory contains no
## roof, no ceiling, no door leaf, no gate, no window and no furniture; the
## single aperture piece is `wall_arched`. A roofed interior cannot be built
## from what exists, and extracting anything would move a third-party inventory
## pinned in six runners. So the Nexus is a broad walled platform open to the
## sky, which is also what a surviving stabilizing INSTRUMENT should look like.
##
## THE CENTRAL ANCHOR IS BUILT BY `RiftAnchor`, not here. This layout owns
## ground, boundary, dressing, and the sockets that say where things go.

const WORLD_LAYER: int = 1
const APPROVED_PALETTE_SCRIPT: String = "res://scripts/environment/approved_environment_palette.gd"

const WALL_THICKNESS: float = 1.5
const WALL_HEIGHT: float = 4.0
const LOW_WALL_HEIGHT: float = 2.4

## Cleaner and cooler again than the Nexus Threshold's (0.690, 0.700, 0.720).
## Three spaces, three grounds, each a step further from the ruin.
const GROUND_COLOUR: Color = Color(0.735, 0.745, 0.775)
const DAIS_COLOUR: Color = Color(0.560, 0.545, 0.640)
const WALL_COLOUR: Color = Color(0.310, 0.315, 0.365)
const CLOSED_ROUTE_COLOUR: Color = Color(0.240, 0.235, 0.290)

# --- Rooms, in layout-local metres --------------------------------------------
# The Nexus Threshold's NEXUS_GATE socket sits at (3.0, -145.0) and its approach
# ground ends at z = -145. The Nexus begins there.
const ENTRY: Rect2 = Rect2(Vector2(-3.0, -153.0), Vector2(12.0, 8.0))
## The broad central floor. Its centre is (3.0, -167.0), which is the Anchor.
const FLOOR: Rect2 = Rect2(Vector2(-21.0, -181.0), Vector2(48.0, 28.0))
## Mara's edge, and the character's own equipment station.
const WEST_EDGE: Rect2 = Rect2(Vector2(-31.0, -176.0), Vector2(10.0, 16.0))
## The dormant edge: where the Nexus's other instruments will one day stand.
## It is empty on purpose.
const EAST_EDGE: Rect2 = Rect2(Vector2(27.0, -177.0), Vector2(10.0, 17.0))
## The raised route platform toward the first regional route.
const ROUTE_PLATFORM: Rect2 = Rect2(Vector2(-5.0, -193.0), Vector2(16.0, 12.0))

const WALKABLE: Array[Rect2] = [ENTRY, FLOOR, WEST_EDGE, EAST_EDGE, ROUTE_PLATFORM]

# --- Sockets -------------------------------------------------------------------
## Where the Nexus Threshold hands the player over.
const ARRIVAL: Vector2 = Vector2(3.0, -149.0)
## The central stabilizing Anchor: the exact centre of FLOOR.
const ANCHOR: Vector2 = Vector2(3.0, -167.0)
## Mara's station inside the Nexus, on the west edge, off the centreline.
const MARA_STATION: Vector2 = Vector2(-24.0, -168.0)
## The Foundation Cache, on the west edge beside Mara — she is the one who
## opens it.
const FOUNDATION_CACHE: Vector2 = Vector2(-24.0, -173.0)
## Local equipment access, on the same edge. One station, not a shop row.
const EQUIPMENT_STATION: Vector2 = Vector2(-16.0, -177.5)
## The closed forward route toward First Footing.
const FORWARD_ROUTE: Vector2 = Vector2(3.0, -191.0)

## The Anchor's own footprint. Nothing is placed inside it and it carries no
## collision, so the player may walk right up to and around the Anchor.
const DAIS_RADIUS: float = 4.5

const BOUNDARY_WALLS: Array[Dictionary] = [
	# The entry throat, framing the gate from the inside.
	{"rect": Rect2(Vector2(-4.5, -153.0), Vector2(WALL_THICKNESS, 8.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(9.0, -153.0), Vector2(WALL_THICKNESS, 8.0)), "height": WALL_HEIGHT},
	# The floor's north edge, broken by the entry.
	{"rect": Rect2(Vector2(-21.0, -154.5), Vector2(18.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(9.0, -154.5), Vector2(18.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	# The floor's long edges, broken by the two station edges.
	{"rect": Rect2(Vector2(-22.5, -181.0), Vector2(WALL_THICKNESS, 5.0)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(-22.5, -160.0), Vector2(WALL_THICKNESS, 7.0)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(27.0, -181.0), Vector2(WALL_THICKNESS, 4.0)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(27.0, -160.0), Vector2(WALL_THICKNESS, 7.0)), "height": LOW_WALL_HEIGHT},
	# The floor's south edge, broken by the route platform.
	{"rect": Rect2(Vector2(-21.0, -182.5), Vector2(16.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(11.0, -182.5), Vector2(16.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	# The west station edge.
	{"rect": Rect2(Vector2(-32.5, -176.0), Vector2(WALL_THICKNESS, 16.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(-31.0, -177.5), Vector2(10.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(-31.0, -160.0), Vector2(10.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	# The east station edge: built, and deliberately empty.
	{"rect": Rect2(Vector2(37.0, -177.0), Vector2(WALL_THICKNESS, 17.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(27.0, -178.5), Vector2(10.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(27.0, -160.0), Vector2(10.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	# The route platform's sides.
	{"rect": Rect2(Vector2(-6.5, -193.0), Vector2(WALL_THICKNESS, 12.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(11.0, -193.0), Vector2(WALL_THICKNESS, 12.0)), "height": WALL_HEIGHT},
]

## Restrained edge dressing only. The brief: "The central floor stays broad and
## lightly dressed" and "Stations occupy readable edges rather than creating
## narrow shop alleys." Nothing at all stands inside the Anchor's dais.
const DRESSING_PLACEMENTS: Array[Dictionary] = [
	# The entry: the Nexus's own stone begins.
	{"key": "wall_arched", "at": Vector2(3.0, -152.0), "yaw": 0.0, "source": "d215"},
	{"key": "post_lantern", "at": Vector2(-2.0, -150.0), "yaw": 0.0, "source": "d215"},
	{"key": "post_lantern", "at": Vector2(8.0, -150.0), "yaw": 0.0, "source": "d215"},
	# The floor's four corner columns: they give the broad space a scale to be
	# read against without cluttering the middle of it.
	{"key": "pillar", "at": Vector2(-18.0, -158.0), "yaw": 0.0, "source": "d215"},
	{"key": "pillar", "at": Vector2(24.0, -158.0), "yaw": 0.0, "source": "d215"},
	{"key": "pillar", "at": Vector2(-18.0, -178.0), "yaw": 0.0, "source": "d215"},
	{"key": "pillar", "at": Vector2(24.0, -178.0), "yaw": 0.0, "source": "d215"},
	{"key": "column", "at": Vector2(-18.0, -168.0), "yaw": 0.0, "source": "d215"},
	{"key": "column", "at": Vector2(24.0, -168.0), "yaw": 0.0, "source": "d215"},
	# The west edge: Mara's working station. A surveyor's records, not a shop.
	{"key": "box_large", "at": Vector2(-28.5, -164.0), "yaw": 0.0, "source": "d215"},
	{"key": "box_small", "at": Vector2(-29.5, -166.0), "yaw": 25.0, "source": "d215"},
	{"key": "barrel_large", "at": Vector2(-29.0, -171.5), "yaw": 0.0, "source": "d215"},
	{"key": "plaque", "at": Vector2(-30.8, -168.0), "yaw": 90.0, "source": "d215"},
	{"key": "torch_mounted", "at": Vector2(-30.8, -173.0), "yaw": 90.0, "source": "d215"},
	{"key": "lantern_standing", "at": Vector2(-22.0, -170.0), "yaw": 0.0, "source": "gate_1c"},
	# The east edge: built and empty. What stands here later has not been
	# decided, and nothing pretends otherwise.
	{"key": "torch_mounted", "at": Vector2(36.8, -168.0), "yaw": -90.0, "source": "d215"},
	{"key": "lantern_standing", "at": Vector2(28.5, -170.0), "yaw": 0.0, "source": "gate_1c"},
	# The route platform: the way out, lit and waiting.
	{"key": "post_lantern", "at": Vector2(-4.0, -186.0), "yaw": 0.0, "source": "d215"},
	{"key": "post_lantern", "at": Vector2(10.0, -186.0), "yaw": 0.0, "source": "d215"},
	# Inside the platform, against the inner faces at x = -5 and x = 11 — not
	# buried in the walls themselves, which is where -6.2 and 12.2 put them.
	{"key": "banner_shield_red", "at": Vector2(-4.8, -190.0), "yaw": 90.0, "source": "d215"},
	{"key": "banner_shield_red", "at": Vector2(11.2, -190.0), "yaw": -90.0, "source": "d215"},
]

var _visuals: Node3D
var _collision: StaticBody3D
var _obstacles: Node3D
var _markers: Node3D
var _dressing: Node3D
var _grid: MeshInstance3D
var grid_visible: bool = false

var _boundary_rects: Array[Rect2] = []
var _dressing_instance_count: int = 0
var _dressing_used_keys: Dictionary = {}
var _closed_route: MeshInstance3D


func _ready() -> void:
	_build()


func _build() -> void:
	for child: Node in get_children():
		child.free()
	_boundary_rects.clear()
	_dressing_instance_count = 0
	_dressing_used_keys.clear()

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

	_dressing = Node3D.new()
	_dressing.name = "Dressing"
	add_child(_dressing)

	_build_ground()
	_build_dais()
	_build_walls()
	_build_closed_route()
	_build_dressing()
	_build_sockets()
	_build_grid()


func _build_ground() -> void:
	for rect: Rect2 in WALKABLE:
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
		_add_ground_collision(plate.name, Vector3(rect.size.x, 0.20, rect.size.y), plate.position)


## A flat inlaid disc marking the Anchor's ground. It is a SURFACE, not a step:
## no collision, no carve, no height, so the player walks straight onto it and
## the navigation mesh never knows it is there.
func _build_dais() -> void:
	var dais: MeshInstance3D = MeshInstance3D.new()
	dais.name = "AnchorDais"
	var mesh: CylinderMesh = CylinderMesh.new()
	mesh.top_radius = DAIS_RADIUS
	mesh.bottom_radius = DAIS_RADIUS
	mesh.height = 0.04
	mesh.radial_segments = 40
	mesh.rings = 1
	dais.mesh = mesh
	dais.material_override = _lit_material(DAIS_COLOUR)
	dais.position = Vector3(ANCHOR.x, 0.02, ANCHOR.y)
	dais.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_visuals.add_child(dais)


func _build_walls() -> void:
	for entry: Dictionary in BOUNDARY_WALLS:
		_wall_block(entry["rect"] as Rect2, float(entry["height"]))


func _wall_block(rect: Rect2, height: float) -> void:
	var name_stem: String = "Wall_%d_%d" % [int(rect.position.x * 10.0), int(rect.position.y * 10.0)]
	var mass: MeshInstance3D = MeshInstance3D.new()
	mass.name = name_stem
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = Vector3(rect.size.x, height, rect.size.y)
	mass.mesh = mesh
	mass.material_override = _lit_material(WALL_COLOUR)
	mass.position = Vector3(
		rect.position.x + rect.size.x * 0.5, height * 0.5, rect.position.y + rect.size.y * 0.5
	)
	_visuals.add_child(mass)
	_boundary_rects.append(rect)
	_add_solid_with_carve(name_stem, Vector3(rect.size.x, height, rect.size.y), mass.position)


## THE ONE ARCHITECTURAL PLACEHOLDER THE BRIEF ASKS FOR: a visibly closed
## forward route toward First Footing.
##
## It is a real solid across the far end of the route platform, with real
## collision and a real navigation carve, so the player genuinely cannot pass
## it. The runtime puts a plain-language reason on screen when they reach it;
## the geometry does not pretend to be a door that might open.
func _build_closed_route() -> void:
	var rect: Rect2 = Rect2(Vector2(-5.0, -194.5), Vector2(16.0, WALL_THICKNESS))
	_closed_route = MeshInstance3D.new()
	_closed_route.name = "ClosedForwardRoute"
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = Vector3(rect.size.x, WALL_HEIGHT, rect.size.y)
	_closed_route.mesh = mesh
	_closed_route.material_override = _lit_material(CLOSED_ROUTE_COLOUR)
	_closed_route.position = Vector3(
		rect.position.x + rect.size.x * 0.5, WALL_HEIGHT * 0.5,
		rect.position.y + rect.size.y * 0.5
	)
	_visuals.add_child(_closed_route)
	_boundary_rects.append(rect)
	_add_solid_with_carve("ClosedForwardRoute", Vector3(rect.size.x, WALL_HEIGHT, rect.size.y), _closed_route.position)


func _build_sockets() -> void:
	_add_socket_marker("NexusArrival", ARRIVAL, Color(0.35, 0.80, 0.95))
	_add_socket_marker("CentralAnchor", ANCHOR, Color(0.70, 0.45, 0.95))
	_add_socket_marker("MaraStation", MARA_STATION, Color(0.95, 0.85, 0.55))
	_add_socket_marker("FoundationCache", FOUNDATION_CACHE, Color(0.85, 0.58, 0.30))
	_add_socket_marker("EquipmentStation", EQUIPMENT_STATION, Color(0.60, 0.80, 0.90))
	_add_socket_marker("ForwardRoute", FORWARD_ROUTE, Color(0.90, 0.75, 0.30))


func _add_socket_marker(marker_name: String, at: Vector2, colour: Color) -> void:
	var ring: MeshInstance3D = MeshInstance3D.new()
	ring.name = "%sRing" % marker_name
	var torus: TorusMesh = TorusMesh.new()
	torus.inner_radius = 0.45
	torus.outer_radius = 0.62
	torus.rings = 20
	ring.mesh = torus
	ring.material_override = _unshaded_material(colour, 1.0)
	ring.position = Vector3(at.x, 0.05, at.y)
	ring.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	ring.visible = grid_visible
	_markers.add_child(ring)


func _build_grid() -> void:
	var bounds: Rect2 = bake_rect()
	var mesh: ImmediateMesh = ImmediateMesh.new()
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	var minor: Color = Color(0.20, 0.20, 0.22, 0.35)
	var major: Color = Color(0.35, 0.75, 0.90, 0.75)
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
	if _markers != null:
		for marker: Node in _markers.get_children():
			(marker as MeshInstance3D).visible = value


# --- Dressing ------------------------------------------------------------------

func _build_dressing() -> void:
	for entry: Dictionary in DRESSING_PLACEMENTS:
		_place_dressing(String(entry["key"]), entry["at"] as Vector2, float(entry["yaw"]), String(entry["source"]))


func _payload_for(key: String, source: String) -> Dictionary:
	if source == "gate_1c":
		return RiftfallLandingLayout.payload(key)
	var palette: GDScript = load(APPROVED_PALETTE_SCRIPT) as GDScript
	for record: Dictionary in palette.PAYLOADS:
		if String(record["key"]) == key:
			return record
	return {}


func _place_dressing(key: String, at: Vector2, yaw_degrees: float, source: String) -> void:
	var record: Dictionary = _payload_for(key, source)
	assert(not record.is_empty(), "RiftNexusLayout: unknown dressing key %s (%s)" % [key, source])
	var scene: PackedScene = load(String(record["path"])) as PackedScene
	assert(scene != null, "RiftNexusLayout: %s failed to load" % record["path"])
	var node: Node3D = scene.instantiate() as Node3D
	node.name = "%s_%d" % [key.replace("-", "_").replace(":", "_"), _dressing_instance_count]
	_dressing_instance_count += 1
	_dressing.add_child(node)
	_dressing_used_keys[key] = int(_dressing_used_keys.get(key, 0)) + 1

	var yaw: float = deg_to_rad(yaw_degrees)
	var contact: String = String(record.get("contact", "base"))
	if contact == "plant":
		node.position = Vector3(at.x, 0.0, at.y)
		node.rotation = Vector3(0.0, yaw, 0.0)
		return
	node.rotation = Vector3(0.0, yaw, 0.0)
	var probe_node: Node3D = scene.instantiate() as Node3D
	var measured: Dictionary = ExteriorAssetProbe.measure(probe_node)
	probe_node.free()
	var local_box: AABB = AABB(
		Vector3(measured["centre"].x - measured["size"].x * 0.5, measured["base_offset"],
			measured["centre"].z - measured["size"].z * 0.5),
		measured["size"]
	)
	var rotated: AABB = Transform3D(Basis.from_euler(Vector3(0.0, yaw, 0.0)), Vector3.ZERO) * local_box
	node.position = Vector3(
		at.x - rotated.get_center().x, -rotated.position.y, at.y - rotated.get_center().z
	)


func dressing_instance_count() -> int:
	return _dressing_instance_count


func dressing_used_keys() -> PackedStringArray:
	var keys: PackedStringArray = PackedStringArray()
	for key: String in _dressing_used_keys:
		keys.append(key)
	return keys


# --- Collision helpers ---------------------------------------------------------

func _add_ground_collision(solid_name: String, size: Vector3, at: Vector3) -> void:
	var shape: CollisionShape3D = CollisionShape3D.new()
	shape.name = solid_name
	var box: BoxShape3D = BoxShape3D.new()
	box.size = size
	shape.shape = box
	shape.position = at
	_collision.add_child(shape)


func _add_solid_with_carve(solid_name: String, size: Vector3, at: Vector3) -> void:
	var shape: CollisionShape3D = CollisionShape3D.new()
	shape.name = solid_name
	var box: BoxShape3D = BoxShape3D.new()
	box.size = size
	shape.shape = box
	shape.position = at
	_collision.add_child(shape)

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


# --- Measurement ---------------------------------------------------------------

func footprint_area() -> float:
	return NexusThresholdLayout.rect_union_area(WALKABLE)


func footprint_cf() -> float:
	return footprint_area() / 588.0


func room_count() -> int:
	return WALKABLE.size()


func _overall_bounds() -> Rect2:
	var bounds: Rect2 = WALKABLE[0]
	for rect: Rect2 in WALKABLE:
		bounds = bounds.merge(rect)
	for rect: Rect2 in _boundary_rects:
		bounds = bounds.merge(rect)
	return bounds.grow(2.0)


func bake_rect() -> Rect2:
	return _overall_bounds()


func arrival() -> Vector3:
	return global_transform * Vector3(ARRIVAL.x, 0.0, ARRIVAL.y)


func anchor_point() -> Vector3:
	return global_transform * Vector3(ANCHOR.x, 0.0, ANCHOR.y)


func mara_station() -> Vector3:
	return global_transform * Vector3(MARA_STATION.x, 0.0, MARA_STATION.y)


func foundation_cache() -> Vector3:
	return global_transform * Vector3(FOUNDATION_CACHE.x, 0.0, FOUNDATION_CACHE.y)


func equipment_station() -> Vector3:
	return global_transform * Vector3(EQUIPMENT_STATION.x, 0.0, EQUIPMENT_STATION.y)


func forward_route() -> Vector3:
	return global_transform * Vector3(FORWARD_ROUTE.x, 0.0, FORWARD_ROUTE.y)


func socket_positions() -> Dictionary:
	return {
		"NexusArrival": arrival(),
		"CentralAnchor": anchor_point(),
		"MaraStation": mara_station(),
		"FoundationCache": foundation_cache(),
		"EquipmentStation": equipment_station(),
		"ForwardRoute": forward_route(),
	}
