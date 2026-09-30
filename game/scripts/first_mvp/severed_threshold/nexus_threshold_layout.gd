class_name NexusThresholdLayout
extends Node3D
## First-MVP — Gate 1E: the third fixed Severed Threshold space (D-219).
##
## Riftfall Landing -> Broken Watch -> **Nexus Threshold** -> the Rift Nexus.
## Canonical purpose, from `design/CROWNLESS_BASTION_ROOM_LIBRARY_AND_MAP_
## AUTHORING_BLUEPRINT.md` §12.3: "safe meeting with Mara and first view into
## the Nexus", approximately 2-3 CF, "Combat: none after entry".
##
## BUILT EXACTLY LIKE `BrokenWatchLayout`, AND THAT IS THE POINT. Project-
## authored `Rect2` ground plates and boundary masses, every non-ground solid
## also carving its own footprint out of the navigation mesh, restrained
## dressing read from the two ACCEPTED asset records, sockets as named points,
## an F6 review grid, and exact rather than sampled area arithmetic. Nothing new
## was invented for this space and no asset was extracted for it.
##
## THE SIGHTLINE, AND THE MEASURED REASON IT IS NOT THE ONE THE BLUEPRINT
## DESCRIBES. §12.3 asks for "a long sightline toward the central Anchor so the
## Nexus immediately appears larger than the opening room." At the accepted
## 19 m / 55 deg / 45 deg camera that is not possible: the top of the frame
## leaves the camera 32.50 deg below horizontal, so the horizon is never in
## shot and the visible ground runs from 7.448 m behind the body to 13.532 m
## ahead of it. Anything further away is off the top of the frame HOWEVER TALL
## IT IS — a taller Anchor is pushed further off, not nearer to being seen.
## Gate 1C measured exactly this and its first implementation built a 28 m keep
## 40 m up the route that was invisible from everywhere.
##
## So this space delivers the beat with what the camera can actually show:
##
##   1. THE APPROACH IS ALIGNED ON THE ANCHOR'S OWN AXIS (x = 3.0), and the
##      Nexus gate frames it, so the Anchor arrives DEAD CENTRE in frame the
##      moment it is close enough to be seen at all.
##   2. THE ANCHOR'S LIGHT REACHES THE PLAYER BEFORE THE ANCHOR DOES. Violet
##      light spills onto the APPROACH's ground, and ground within 13.532 m
##      ahead IS visible at this camera. The player sees the Nexus before they
##      see the Nexus.
##   3. THE SPACE OPENS. The route runs 8 m wide at the mouth, 20 m across the
##      descent, 34 m across the terrace, then narrows to a 10 m approach. That
##      change is felt from inside the frame rather than seen from outside it.
##
## `docs/testing/FIRST_MVP_GATE_1E_NEXUS_THRESHOLD_REPORT.md` puts the wording
## question to the project owner rather than quietly amending the blueprint.
##
## COMBAT: NONE. This layout spawns nothing, carries no encounter socket, and
## the runtime places no enemy in it.

const WORLD_LAYER: int = 1
const APPROVED_PALETTE_SCRIPT: String = "res://scripts/environment/approved_environment_palette.gd"

const WALL_THICKNESS: float = 1.5
const WALL_HEIGHT: float = 4.0
const LOW_WALL_HEIGHT: float = 2.4

## Deliberately a shade lighter and cooler than Broken Watch's (0.700, 0.680,
## 0.640) — the ground itself starts telling the player they have left the ruin.
## The accepted D-206 material treatment is applied over this by the runtime,
## exactly as it is over every other authored surface.
const GROUND_COLOUR: Color = Color(0.690, 0.700, 0.720)
const WALL_COLOUR: Color = Color(0.330, 0.335, 0.360)
const APPROACH_GLOW: Color = Color(0.62, 0.44, 0.86)

# --- Rooms, in layout-local metres --------------------------------------------
# The route continues straight on from Broken Watch's BROKEN_ARCHWAY, whose exit
# socket sits at (3.0, -90.0) and whose ground ends at z = -93.
#
# THE MOUTH. Still enclosed, still the Watch's stonework. This is where the
# Watch stops being dangerous, and the runtime marks it as the safe boundary.
const MOUTH: Rect2 = Rect2(Vector2(-1.0, -101.0), Vector2(8.0, 8.0))
# THE DESCENT. The first widening. 20 m across against the mouth's 8.
const DESCENT: Rect2 = Rect2(Vector2(-7.0, -113.0), Vector2(20.0, 12.0))
# THE TERRACE. The broad safe decompression space. Mara stands here, off the
# centreline, so she is met rather than walked into.
const TERRACE: Rect2 = Rect2(Vector2(-14.0, -133.0), Vector2(34.0, 20.0))
const WEST_ALCOVE: Rect2 = Rect2(Vector2(-21.0, -128.0), Vector2(7.0, 10.0))
const EAST_ALCOVE: Rect2 = Rect2(Vector2(20.0, -129.0), Vector2(8.0, 11.0))
# THE APPROACH. Narrows to 10 m and aligns on the Anchor's axis. The Nexus
# gate is at its far end.
const APPROACH: Rect2 = Rect2(Vector2(-2.0, -145.0), Vector2(10.0, 12.0))

const WALKABLE: Array[Rect2] = [MOUTH, DESCENT, TERRACE, WEST_ALCOVE, EAST_ALCOVE, APPROACH]

# --- Sockets -------------------------------------------------------------------
## Where Broken Watch hands the player over. Two metres inside the mouth.
const ENTRY_POINT: Vector2 = Vector2(3.0, -95.0)
## The exact point past which no enemy may act. Everything beyond is safe.
const SAFE_BOUNDARY: Vector2 = Vector2(3.0, -99.0)
## Mara's station: on the terrace, west of the centreline, facing the route the
## player arrives along.
const MARA_STATION: Vector2 = Vector2(-6.0, -122.0)
## Where the Anchor's recognition beat is armed. On the centreline, at the head
## of the approach.
const RECOGNITION_POINT: Vector2 = Vector2(3.0, -136.0)
## The Nexus gate. The Rift Nexus begins here.
const NEXUS_GATE: Vector2 = Vector2(3.0, -145.0)

const BOUNDARY_WALLS: Array[Dictionary] = [
	# The mouth, still the Watch's own stone.
	{"rect": Rect2(Vector2(-2.5, -101.0), Vector2(WALL_THICKNESS, 8.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(7.0, -101.0), Vector2(WALL_THICKNESS, 8.0)), "height": WALL_HEIGHT},
	# The descent flares outward from the mouth.
	{"rect": Rect2(Vector2(-8.5, -113.0), Vector2(WALL_THICKNESS, 12.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(13.0, -113.0), Vector2(WALL_THICKNESS, 12.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(-7.0, -102.5), Vector2(6.0, WALL_THICKNESS)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(7.0, -102.5), Vector2(6.0, WALL_THICKNESS)), "height": WALL_HEIGHT},
	# The terrace: lower boundary, because this is a safe place rather than a
	# corridor and the player should be able to see over its edge.
	# THE WEST SEGMENT STOPS AT THE ALCOVE'S MOUTH. Spanning the full 15 m from
	# z -133 sealed WEST_ALCOVE completely — 70 m^2 of authored ground that baked
	# as an unreachable navigation island, while the east side (below) was
	# already correct. The asymmetry was the tell.
	{"rect": Rect2(Vector2(-15.5, -133.0), Vector2(WALL_THICKNESS, 5.0)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(-15.5, -118.0), Vector2(WALL_THICKNESS, 5.0)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(20.0, -133.0), Vector2(WALL_THICKNESS, 4.0)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(20.0, -118.0), Vector2(WALL_THICKNESS, 5.0)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(-14.0, -114.5), Vector2(7.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(13.0, -114.5), Vector2(7.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	# The alcoves.
	{"rect": Rect2(Vector2(-22.5, -128.0), Vector2(WALL_THICKNESS, 10.0)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(-21.0, -129.5), Vector2(7.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(-21.0, -118.0), Vector2(7.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(28.0, -129.0), Vector2(WALL_THICKNESS, 11.0)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(20.0, -130.5), Vector2(8.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(20.0, -118.0), Vector2(8.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	# The terrace's far edge, broken by the approach.
	{"rect": Rect2(Vector2(-14.0, -134.5), Vector2(12.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	{"rect": Rect2(Vector2(8.0, -134.5), Vector2(12.0, WALL_THICKNESS)), "height": LOW_WALL_HEIGHT},
	# The approach: tall again, so the gate frames what lies beyond it.
	{"rect": Rect2(Vector2(-3.5, -145.0), Vector2(WALL_THICKNESS, 12.0)), "height": WALL_HEIGHT},
	{"rect": Rect2(Vector2(8.0, -145.0), Vector2(WALL_THICKNESS, 12.0)), "height": WALL_HEIGHT},
]

## Restrained edge dressing, every key read from an ACCEPTED record: `source`
## "gate_1c" reads `RiftfallLandingLayout.payload()` (the D-208 §6.3 allowlist)
## and "palette" reads `approved_environment_palette.gd` (the D-215 record).
## Nothing here names a path; the records own every path in the project.
##
## The lanterns walk the player toward the gate — the same device Riftfall
## Landing uses to carry a bearing the camera cannot carry with a landmark.
## Keys are BARE model names, exactly as both records write them and exactly as
## `BrokenWatchLayout` reads them; `<pack>:<model>` is the Zone Composer's own
## runtime-only id scheme and never appears in a saved scene or a game record.
## `source` "gate_1c" reads `RiftfallLandingLayout.payload()`; anything else
## reads the D-215 palette, and "d215" is the string Broken Watch already uses.
const DRESSING_PLACEMENTS: Array[Dictionary] = [
	# The mouth: the Watch's last stones, damaged.
	# Clear of the west wall's inner face at x = -1, not buried inside it.
	{"key": "stone-wall-damaged", "at": Vector2(-0.85, -97.0), "yaw": 90.0, "source": "gate_1c"},
	{"key": "debris", "at": Vector2(5.6, -99.5), "yaw": 25.0, "source": "gate_1c"},
	# The descent: it stops being a ruin.
	{"key": "post_lantern", "at": Vector2(-5.4, -105.0), "yaw": 0.0, "source": "d215"},
	{"key": "post_lantern", "at": Vector2(11.4, -105.0), "yaw": 0.0, "source": "d215"},
	{"key": "stone-wall-column", "at": Vector2(-6.2, -110.5), "yaw": 0.0, "source": "gate_1c"},
	{"key": "stone-wall-column", "at": Vector2(12.2, -110.5), "yaw": 0.0, "source": "gate_1c"},
	# The terrace: quiet, tended, deliberately sparse. This is the first place
	# in the whole opening that looks looked-after.
	{"key": "lantern_standing", "at": Vector2(-9.5, -120.0), "yaw": 0.0, "source": "gate_1c"},
	{"key": "lantern_standing", "at": Vector2(15.0, -121.0), "yaw": 0.0, "source": "gate_1c"},
	{"key": "barrel_large", "at": Vector2(-11.0, -125.5), "yaw": 15.0, "source": "d215"},
	{"key": "box_large", "at": Vector2(-12.4, -123.0), "yaw": -20.0, "source": "d215"},
	{"key": "box_small", "at": Vector2(-10.2, -127.4), "yaw": 40.0, "source": "d215"},
	{"key": "barrel_large", "at": Vector2(17.5, -124.5), "yaw": -10.0, "source": "d215"},
	{"key": "column", "at": Vector2(-13.0, -131.0), "yaw": 0.0, "source": "d215"},
	{"key": "column", "at": Vector2(19.0, -131.0), "yaw": 0.0, "source": "d215"},
	{"key": "column", "at": Vector2(-13.0, -117.0), "yaw": 0.0, "source": "d215"},
	{"key": "column", "at": Vector2(19.0, -117.0), "yaw": 0.0, "source": "d215"},
	# The alcoves: the Surveyor's own working clutter, not treasure.
	{"key": "box_large", "at": Vector2(-18.0, -125.0), "yaw": 0.0, "source": "d215"},
	{"key": "box_small", "at": Vector2(-19.4, -122.5), "yaw": 30.0, "source": "d215"},
	{"key": "barrel_large", "at": Vector2(24.0, -124.0), "yaw": 0.0, "source": "d215"},
	{"key": "plaque", "at": Vector2(24.0, -127.5), "yaw": 0.0, "source": "d215"},
	# The approach: the lantern chain toward the gate.
	{"key": "post_lantern", "at": Vector2(-1.2, -137.0), "yaw": 0.0, "source": "d215"},
	{"key": "post_lantern", "at": Vector2(7.2, -137.0), "yaw": 0.0, "source": "d215"},
	{"key": "post_lantern", "at": Vector2(-1.2, -142.0), "yaw": 0.0, "source": "d215"},
	{"key": "post_lantern", "at": Vector2(7.2, -142.0), "yaw": 0.0, "source": "d215"},
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
	_build_walls()
	_build_approach_glow()
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


## THE ANCHOR'S LIGHT, REACHING THE PLAYER BEFORE THE ANCHOR DOES.
##
## A flat unshaded plate laid a centimetre over the approach's ground,
## brightening toward the gate. Ground within 13.532 m ahead of the body IS
## visible at the accepted camera, so this is the one part of the Nexus that
## can be seen from the Threshold at all. It is the sightline the blueprint
## asks for, delivered by the only surface the camera shows.
##
## It carries NO collision and NO navigation carve: it is light on a floor.
func _build_approach_glow() -> void:
	var glow: MeshInstance3D = MeshInstance3D.new()
	glow.name = "ApproachGlow"
	var mesh: PlaneMesh = PlaneMesh.new()
	mesh.size = Vector2(APPROACH.size.x - 1.0, APPROACH.size.y + 8.0)
	mesh.subdivide_depth = 24
	glow.mesh = mesh
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	material.albedo_color = Color(APPROACH_GLOW.r, APPROACH_GLOW.g, APPROACH_GLOW.b, 0.20)
	# A vertical gradient along the plane's own depth, so it is faint where the
	# terrace ends and strongest at the gate.
	var gradient: Gradient = Gradient.new()
	gradient.set_color(0, Color(1.0, 1.0, 1.0, 0.0))
	gradient.set_color(1, Color(1.0, 1.0, 1.0, 1.0))
	var texture: GradientTexture2D = GradientTexture2D.new()
	texture.gradient = gradient
	texture.width = 4
	texture.height = 128
	texture.fill_from = Vector2(0.0, 1.0)
	texture.fill_to = Vector2(0.0, 0.0)
	material.albedo_texture = texture
	glow.material_override = material
	glow.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	glow.position = Vector3(
		APPROACH.position.x + APPROACH.size.x * 0.5, 0.012,
		APPROACH.position.y + APPROACH.size.y * 0.5 + 4.0
	)
	_visuals.add_child(glow)


func _build_sockets() -> void:
	_add_socket_marker("NexusThresholdEntry", ENTRY_POINT, Color(0.35, 0.80, 0.95))
	_add_socket_marker("SafeBoundary", SAFE_BOUNDARY, Color(0.40, 0.90, 0.55))
	_add_socket_marker("MaraStation", MARA_STATION, Color(0.95, 0.85, 0.55))
	_add_socket_marker("RecognitionPoint", RECOGNITION_POINT, Color(0.70, 0.45, 0.95))
	_add_socket_marker("NexusGate", NEXUS_GATE, Color(0.90, 0.75, 0.30))


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


# --- Dressing: registered pieces only, non-colliding ---------------------------

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
	assert(not record.is_empty(), "NexusThresholdLayout: unknown dressing key %s (%s)" % [key, source])
	var scene: PackedScene = load(String(record["path"])) as PackedScene
	assert(scene != null, "NexusThresholdLayout: %s failed to load" % record["path"])
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


## Every non-ground solid also carves its own footprint out of the baked
## navigation mesh — the Gate 1A "open-topped well" fix every layout in this
## project follows. A box whose top sits inside the bake volume otherwise
## rasterises as a walkable phantom interior, and a narrower box CONCEALS the
## defect rather than avoiding it.
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


# --- Measurement, exact rather than sampled ------------------------------------

static func rect_union_area(rects: Array[Rect2]) -> float:
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


func footprint_area() -> float:
	return NexusThresholdLayout.rect_union_area(WALKABLE)


## Camera Footprints, the project unit. 1 CF is 28.0 x 21.0 m at the accepted
## camera (D-175), which is 588.00 m^2.
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


func entry() -> Vector3:
	return global_transform * Vector3(ENTRY_POINT.x, 0.0, ENTRY_POINT.y)


func safe_boundary() -> Vector3:
	return global_transform * Vector3(SAFE_BOUNDARY.x, 0.0, SAFE_BOUNDARY.y)


func mara_station() -> Vector3:
	return global_transform * Vector3(MARA_STATION.x, 0.0, MARA_STATION.y)


func recognition_point() -> Vector3:
	return global_transform * Vector3(RECOGNITION_POINT.x, 0.0, RECOGNITION_POINT.y)


func nexus_gate() -> Vector3:
	return global_transform * Vector3(NEXUS_GATE.x, 0.0, NEXUS_GATE.y)


func socket_positions() -> Dictionary:
	return {
		"NexusThresholdEntry": entry(),
		"SafeBoundary": safe_boundary(),
		"MaraStation": mara_station(),
		"RecognitionPoint": recognition_point(),
		"NexusGate": nexus_gate(),
	}
