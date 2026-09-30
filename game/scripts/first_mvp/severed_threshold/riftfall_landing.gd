class_name RiftfallLanding
extends Node3D
## First-MVP Gate 1C — the CANONICAL Riftfall Landing environment (D-208).
##
## This is the first canonical place the player will control the Riftmarked: the
## safe opening of The Severed Threshold. It is not a review instrument and not a
## test room, and unlike both Gate 1B scenes it is meant to survive.
##
## WHAT IT CONTAINS: environment, lighting, the accepted material treatment,
## authored terrain and route geometry, the registered KayKit and Kenney Graveyard
## dressing, navigation, the five §8 sockets, and the repeating-stone anomaly.
##
## WHAT IT DELIBERATELY DOES NOT CONTAIN: a player, a camera, a marker, an
## overlay, a developer control, or any interface at all. §3 requires that
## separation, and it is what lets the same environment later carry a real
## character without inheriting a locomotion-only test body. The developer review
## wrapper at `scenes/first_mvp/severed_threshold/riftfall_landing_review.tscn`
## instances this scene and adds those things around it.
##
## WHAT IT IS NOT: Broken Watch, the Nexus Threshold, the complete Severed
## Threshold route, or the Rift Nexus. There is no enemy, no combat, no attack
## input, no Life, no Mana, no damage, no death, no loot, no item, no XP, no
## Passive, no reward, no inventory, no progression, no quest, no dialogue, no
## Mara, no checkpoint, no portal, no transition, no procedural generation, and no
## persistent state of any kind — this scene has no storage path at all: it opens
## no engine data directory, constructs no configuration store, saves no resource
## and makes no filesystem call whatsoever. Crossing `ExitToBrokenWatch` loads
## nothing, saves nothing, opens no quest and fabricates no Broken Watch.
##
## THE PRESENTATION IS THE ONE D-206 ACCEPTED, SELECTED PERMANENTLY. There is no
## neutral state, no source-material comparison and no lighting toggle: §6.5 says
## "The canonical scene opens only in the accepted exterior presentation", so
## `ExteriorReviewLighting` is put into its candidate state once and
## `ExteriorReviewTreatment` applies saturation x 0.42, value x 0.62 and cool tint
## (0.88, 0.90, 0.97) once, and nothing in this scene can change either. Both
## components are the first Gate 1B spike's, REUSED UNCHANGED and not forked —
## their names still say "review" because §11.2 authorizes no rename of a closed
## gate's files, and what they actually are is the one implementation of the
## accepted exterior direction.
##
## IT IS AUTHORED AT A 45 DEGREE YAW, and that is composition rather than
## decoration. The accepted camera's yaw is fixed at 45 degrees, so "away from the
## camera" in world space is (-0.7071, 0, -0.7071); the `Composition` node carries
## a matching 45 degree yaw, so the layout's own -Z runs straight up the screen and
## the broken road recedes toward the Watch instead of crossing the frame
## diagonally. The camera itself is untouched: 19 m, 55 degrees, 45 degrees.

const ACCEPTED_WORLD_UNIT_METRES: float = 1.0
const ACCEPTED_P_METRES: float = 0.80
const ACCEPTED_CAMERA_DISTANCE: float = 19.0
const ACCEPTED_CAMERA_PITCH: float = 55.0
const ACCEPTED_CAMERA_FOV: float = 45.0
const ACCEPTED_MAX_SPEED: float = 5.0
## D-175's measured reference camera footprint, the CF unit the room-library
## blueprint uses. Quoted rather than recomputed so CF here means what it means
## everywhere else in the project.
const REFERENCE_CF_AREA: float = 27.982 * 20.980

const WORLD_MASK: int = 1
## THE ONE LIGHTING VALUE GATE 1C MOVES, and §6.5 permits exactly this: "Individual
## light, ambient, practical, and fog values remain implementation-tunable inside
## the accepted direction; if any differs from the Gate 1B candidate state, the
## report must show before, after, and visual reason."
##
## Before: 0.48, the Gate 1B candidate ambient energy, unchanged in the shared
## component and still asserted there. After: 0.62, applied here only.
##
## The reason is measured rather than aesthetic. Gate 1B's boundary was a 1.00 m
## shoulder seen almost entirely from above, so its unlit vertical faces occupied
## a few pixels. Riftfall Landing's boundary is 1.8 to 4.5 m of authored terrain
## seen edge-on at a 55 degree camera, and at 0.48 those faces rendered as black
## cut-outs: the first rendered evidence run showed a route apparently bordered by
## holes in the world. Nothing else in the accepted direction moves — the key
## light, its colour and rotation, the shadow opacity, the sky, the tonemap, the
## fog colour and the 0.0032 fog density are all exactly as Gate 1B left them.
const EXTERIOR_AMBIENT_ENERGY: float = 0.62
const GATE_1B_AMBIENT_ENERGY: float = 0.48
## The composition yaw described above, matched to the accepted camera yaw.
const LANDING_YAW_DEGREES: float = 45.0

@export_group("Navigation bake, metres")
@export var agent_radius: float = 0.40
@export var agent_height: float = 1.80
@export var agent_max_climb: float = 0.20
@export var agent_max_slope: float = 20.0
## The project's navigation default, and NOT a value to raise for bake speed on a
## large footprint. Gate 1B measured what happens at 0.25: Recast places the baked
## surface on a voxel boundary, so it sat at y = 0.500 while the character stands
## at 0.000, `NavigationAgent3D` measures its 0.40 m `path_desired_distance` in
## THREE dimensions, and the agent could never reach its own first path point.
@export var nav_cell_size: float = 0.15
## The bake is clipped to the first metre above the ground, exactly as the Gate 1A
## hall clips its own bake below a 1.20 m half-wall. Every boundary bank here is
## at least 1.80 m tall, so no bank top can rasterise as a walkable ledge — and
## every solid additionally carves its own footprint, which is what stops the
## resulting open-topped wells from keeping a phantom walkable interior.
@export var bake_ceiling: float = 0.90
@export var bake_floor: float = -1.00

var layout: RiftfallLandingLayout
var nav_region: NavigationRegion3D
var lighting: ExteriorReviewLighting
var treatment: ExteriorReviewTreatment
var loop_event: RiftfallLoopEvent

var navmesh_polygon_count: int = 0
var navmesh_area: float = 0.0
var navmesh_surface_y: float = 0.0
var last_bake_msec: int = 0
## Exactly ONE for the life of the scene. Nothing a developer view can toggle
## touches a collision shape, so nothing needs a rebake, and §10 asks for that to
## be a measured fact rather than a promise.
var bake_count: int = 0
var navigation_ready_frames: int = -1

var log_lines: PackedStringArray = PackedStringArray()


func _ready() -> void:
	nav_region = $Composition/NavigationRegion3D
	layout = $Composition/NavigationRegion3D/Layout
	lighting = $ExteriorLighting

	# Applied here rather than as a serialized basis, because a 12-float
	# `Transform3D` literal in a scene file is easy to write and easy to write
	# ninety degrees wrong — which is exactly what happened on the first build, and
	# the verification now measures the resulting axis against the camera's own
	# forward direction rather than trusting either form.
	$Composition.rotation_degrees = Vector3(0.0, LANDING_YAW_DEGREES, 0.0)

	treatment = ExteriorReviewTreatment.new()
	lighting.configure($WorldEnvironment, $KeyLight)
	layout.build(treatment, lighting)
	loop_event = layout.loop_event

	# The accepted D-206 exterior presentation, selected once and permanently.
	lighting.set_mode(ExteriorReviewLighting.Mode.CANDIDATE)
	treatment.set_candidate(true)
	# ...and the one §6.5 tune, applied ON TOP of that state rather than by editing
	# the shared component, so both Gate 1B scenes keep the value they were accepted
	# with and this scene's difference is one named number.
	var environment: Environment = ($WorldEnvironment as WorldEnvironment).environment
	environment.ambient_light_energy = EXTERIOR_AMBIENT_ENERGY

	_configure_navigation()
	bake_navigation()

	log_event("riftfall landing", "canonical first-MVP exterior opening; no combat, no progression")
	log_event("credit", RiftfallLandingLayout.CREDIT_KAYKIT)
	log_event("credit", RiftfallLandingLayout.CREDIT_KENNEY)
	log_event("presentation", "accepted exterior: saturation x %.2f, value x %.2f, tint (%.2f, %.2f, %.2f)" % [
		ExteriorReviewTreatment.SATURATION, ExteriorReviewTreatment.VALUE,
		ExteriorReviewTreatment.TINT.r, ExteriorReviewTreatment.TINT.g,
		ExteriorReviewTreatment.TINT.b,
	])
	log_event("footprint", "%.1f m^2 authored, %.3f CF, %.1f%% clear of collision" % [
		layout.footprint_area(), footprint_in_cf(), layout.clear_fraction() * 100.0,
	])
	var narrowest: Dictionary = layout.narrowest_sample()
	log_event("route", "%.2f m centreline, narrowest measured clearance %.3f m at %.1f m along" % [
		layout.centreline_length(), layout.narrowest_clearance(),
		float(narrowest.get("along", 0.0)),
	])
	log_event("route widths", "%d stations: %d in 10-14 m, %d wider, %d narrower; median %.2f m" % [
		layout.width_samples().size(), layout.widths_in_ordinary_band(),
		layout.widths_wider_than_ordinary(),
		layout.width_samples().size() - layout.widths_in_ordinary_band()
			- layout.widths_wider_than_ordinary(),
		layout.median_width(),
	])
	log_event("watch breach", "%.3f m measured between the two authored breach masses" % (
		breach_clearance()
	))
	log_event("repeating stone", "%s cycle over %.3f m on a %.1f degree grade" % [
		"REST -> ROLL -> IMPACT_HOLD -> IMPOSSIBLE_RETURN",
		RiftfallLoopEvent.travel_distance(), RiftfallLoopEvent.grade_degrees(),
	])
	log_event("instances placed", "%d registered meshes across %d approved families" % [
		layout.placed.size(), layout.used_families().size(),
	])
	# Per payload, so the delivery report quotes a measurement rather than a count
	# of placement calls in the source.
	for key: String in layout.used_payload_keys():
		var record: Dictionary = RiftfallLandingLayout.payload(key)
		log_event("payload", "%-22s x%-3d  %s  (%s)" % [
			key, layout.instances_of(key), String(record["contact"]), String(record["family"]),
		])

	await _await_navigation_synchronized()


# --- Navigation ---------------------------------------------------------------

func _configure_navigation() -> void:
	var mesh: NavigationMesh = NavigationMesh.new()
	# Baked from the layout's own project-authored collision boxes, never from the
	# dressing meshes, so the walkable surface can never disagree with what the
	# character collides against — and so no visual choice can move the route.
	mesh.geometry_parsed_geometry_type = NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS
	mesh.geometry_collision_mask = WORLD_MASK
	mesh.geometry_source_geometry_mode = NavigationMesh.SOURCE_GEOMETRY_ROOT_NODE_CHILDREN
	mesh.cell_size = nav_cell_size
	mesh.cell_height = nav_cell_size
	mesh.agent_radius = agent_radius
	mesh.agent_height = agent_height
	mesh.agent_max_climb = agent_max_climb
	mesh.agent_max_slope = agent_max_slope
	var rect: Rect2 = layout.bake_rect()
	mesh.filter_baking_aabb = AABB(
		Vector3(rect.position.x, bake_floor, rect.position.y),
		Vector3(rect.size.x, bake_ceiling - bake_floor, rect.size.y)
	)
	nav_region.navigation_mesh = mesh


func bake_navigation() -> void:
	var started: int = Time.get_ticks_msec()
	nav_region.bake_navigation_mesh(false)
	if NavigationServer3D.map_get_iteration_id(navigation_map()) > 0:
		NavigationServer3D.map_force_update(navigation_map())
	last_bake_msec = Time.get_ticks_msec() - started
	bake_count += 1
	_measure_navmesh()
	log_event("navigation baked", "%d polygons, %.1f m^2 walkable, %d ms (bake #%d)" % [
		navmesh_polygon_count, navmesh_area, last_bake_msec, bake_count,
	])


func _measure_navmesh() -> void:
	var mesh: NavigationMesh = nav_region.navigation_mesh
	navmesh_polygon_count = mesh.get_polygon_count()
	var vertices: PackedVector3Array = mesh.get_vertices()
	var area: float = 0.0
	var highest: float = -1e9
	for i: int in navmesh_polygon_count:
		var indices: PackedInt32Array = mesh.get_polygon(i)
		for t: int in range(1, indices.size() - 1):
			var a: Vector3 = vertices[indices[0]]
			var b: Vector3 = vertices[indices[t]]
			var c: Vector3 = vertices[indices[t + 1]]
			area += absf((b.x - a.x) * (c.z - a.z) - (c.x - a.x) * (b.z - a.z)) * 0.5
	for vertex: Vector3 in vertices:
		highest = maxf(highest, vertex.y)
	navmesh_area = area
	navmesh_surface_y = highest if vertices.size() > 0 else 0.0


func navigation_map() -> RID:
	return get_world_3d().navigation_map


## The navigation map is not QUERYABLE until the server has synchronized it at
## least once. The readiness test is a real query with a known answer rather than
## a counter: the player spawn must come back as itself.
func _await_navigation_synchronized() -> void:
	var probe: Vector3 = player_spawn()
	for frame: int in 40:
		if NavigationServer3D.map_get_iteration_id(navigation_map()) == 0:
			await get_tree().physics_frame
			continue
		var answer: Vector3 = NavigationServer3D.map_get_closest_point(navigation_map(), probe)
		if Vector2(answer.x - probe.x, answer.z - probe.z).length() < 0.35:
			navigation_ready_frames = frame
			log_event("navigation ready", "map answers queries after %d physics frame%s" % [
				frame, "" if frame == 1 else "s",
			])
			return
		await get_tree().physics_frame
	push_warning("RiftfallLanding: the navigation map did not become queryable")


func point_is_navigable(point: Vector3, tolerance: float = 0.35) -> bool:
	var flat: Vector3 = Vector3(point.x, 0.0, point.z)
	var answer: Vector3 = NavigationServer3D.map_get_closest_point(navigation_map(), flat)
	return Vector2(answer.x - flat.x, answer.z - flat.z).length() <= tolerance


func route_path() -> PackedVector3Array:
	return NavigationServer3D.map_get_path(
		navigation_map(), player_spawn(), exit_socket(), true
	)


func route_path_length() -> float:
	var points: PackedVector3Array = route_path()
	var total: float = 0.0
	for i: int in range(1, points.size()):
		total += points[i].distance_to(points[i - 1])
	return total


# --- §8 sockets ---------------------------------------------------------------
## Spatial contracts, not gameplay triggers. Nothing subscribes to them, nothing
## fires when the player reaches one, and crossing the exit changes no state here.

func player_spawn() -> Vector3:
	return layout.socket_position("PlayerSpawn")


func exit_socket() -> Vector3:
	return layout.socket_position("ExitToBrokenWatch")


func rift_scar_focus() -> Vector3:
	return layout.socket_position("RiftScarFocus")


func repeating_stone_focus() -> Vector3:
	return layout.socket_position("RepeatingStoneFocus")


func watch_silhouette_focus() -> Vector3:
	return layout.socket_position("WatchSilhouetteFocus")


func socket_positions() -> Dictionary:
	var found: Dictionary = {}
	for socket_name: String in layout.socket_names():
		found[socket_name] = layout.socket_position(socket_name)
	return found


# --- Measurement --------------------------------------------------------------

func footprint_in_cf() -> float:
	return layout.footprint_area() / REFERENCE_CF_AREA


func breach_clearance() -> float:
	return layout.breach_clearance()


## WHAT THE ACCEPTED CAMERA CAN ACTUALLY SEE, and where the Watch massing first
## enters it. This function exists because its first version got the inequality
## backwards and produced a confident, wrong number.
##
## At 19 m and 55 degrees the camera sits 10.898 m behind the body and 15.564 m
## above it, and the top of a 45 degree frame leaves it 32.50 degrees below
## horizontal — so the horizon is NEVER in shot. At horizontal distance h from the
## camera the top edge of the picture is at y = 15.564 - 0.6371 h. That reaches
## ground level 24.430 m from the camera, which is 13.532 m ahead of the body, and
## is NEGATIVE beyond it: past that distance everything at or above ground level is
## off the top of the frame, and a taller object is further off rather than nearer
## to being seen.
##
## The consequence is worth stating plainly, because it is a fact about the
## accepted camera rather than about this scene: at 19 m / 55 degrees / 45 degrees
## a distant landmark cannot carry a bearing. Only what lies within about thirteen
## metres of the body can.
func silhouette_sighting() -> Dictionary:
	var pitch: float = deg_to_rad(ACCEPTED_CAMERA_PITCH)
	var half_fov: float = deg_to_rad(ACCEPTED_CAMERA_FOV) * 0.5
	var camera_height: float = ACCEPTED_CAMERA_DISTANCE * sin(pitch)
	var camera_behind: float = ACCEPTED_CAMERA_DISTANCE * cos(pitch)
	var top_ray: float = tan(pitch - half_fov)
	var tallest: float = 0.0
	var lowest_base: float = 1e9
	var nearest_mass: Vector3 = watch_silhouette_focus()
	for node: Node in _silhouette_meshes():
		var mesh: MeshInstance3D = node as MeshInstance3D
		var world: AABB = mesh.global_transform * mesh.get_aabb()
		tallest = maxf(tallest, world.end.y)
		if world.position.y < lowest_base:
			lowest_base = world.position.y
			nearest_mass = world.get_center()
	var visible_from: float = -1.0
	var along: float = 0.0
	var total: float = layout.centreline_length()
	while along <= total + 0.0001:
		var flat: Vector2 = layout.centreline_point(along)
		var here: Vector3 = layout.global_transform * Vector3(flat.x, 0.0, flat.y)
		var distance: float = Vector2(here.x - nearest_mass.x, here.z - nearest_mass.z).length()
		# The mass is in shot when its BASE lies below the top edge of the frame.
		if lowest_base < camera_height - (camera_behind + distance) * top_ray:
			visible_from = along
			break
		along += 0.25
	return {
		"tallest_mass": tallest,
		"lowest_base": lowest_base if lowest_base < 1e8 else 0.0,
		# The exact point the arithmetic above is a claim ABOUT, exposed so the
		# claim can be cross-checked against the production camera's own frustum
		# rather than against a second copy of the same arithmetic.
		"probe": Vector3(nearest_mass.x, (lowest_base if lowest_base < 1e8 else 0.0) + 0.10,
			nearest_mass.z),
		"visible_from_along": visible_from,
		"visible_from_spawn": visible_from >= 0.0 and visible_from < 0.001,
		"ground_visible_ahead": camera_height / top_ray - camera_behind,
		"ground_visible_behind": camera_behind - camera_height / tan(pitch + half_fov),
		"horizon_visible": (pitch - half_fov) <= 0.0,
	}


func _silhouette_meshes() -> Array[Node]:
	var found: Array[Node] = []
	var group: Node = layout.get_node_or_null("Visuals/WatchSilhouette")
	if group == null:
		return found
	for child: Node in group.get_children():
		if child is MeshInstance3D:
			found.append(child)
	return found


## Everything the developer overlay and the Gate 1C verification read, measured
## from the scene that was actually built.
func measurements() -> Dictionary:
	var widths: Array[Dictionary] = layout.width_samples()
	var clearance: Dictionary = layout.minimum_solid_clearance()
	return {
		"world_unit_metres": ACCEPTED_WORLD_UNIT_METRES,
		"player_unit_metres": ACCEPTED_P_METRES,
		"camera_distance_default": ACCEPTED_CAMERA_DISTANCE,
		"camera_pitch": ACCEPTED_CAMERA_PITCH,
		"camera_fov": ACCEPTED_CAMERA_FOV,
		"max_speed": ACCEPTED_MAX_SPEED,
		"footprint_area": layout.footprint_area(),
		"footprint_cf": footprint_in_cf(),
		"reference_cf_area": REFERENCE_CF_AREA,
		"centreline_metres": layout.centreline_length(),
		"resolved_path_metres": route_path_length(),
		"narrowest_clearance": layout.narrowest_clearance(),
		"breach_clearance": breach_clearance(),
		"width_samples": widths.size(),
		"widths_ordinary": layout.widths_in_ordinary_band(),
		"widths_wider": layout.widths_wider_than_ordinary(),
		"clear_fraction": layout.clear_fraction(),
		"minimum_solid_clearance": clearance,
		"navmesh_polygons": navmesh_polygon_count,
		"navmesh_area": navmesh_area,
		"navmesh_surface_y": navmesh_surface_y,
		"bake_msec": last_bake_msec,
		"bake_count": bake_count,
		"instances": layout.placed.size(),
		"used_payloads": layout.used_payload_keys().size(),
		"used_families": layout.used_families(),
		"authored_surfaces": layout.authored_surfaces(),
		"unregistered_authored_surfaces": layout.unregistered_authored_surfaces(),
		"treated_surfaces": treatment.surface_count(),
		"source_drift": treatment.drifted_sources().size(),
		"ambient_energy": (
			(($WorldEnvironment as WorldEnvironment).environment as Environment)
				.ambient_light_energy
		),
		"ambient_energy_gate_1b": GATE_1B_AMBIENT_ENERGY,
		"loop_state": loop_event.state_name(),
		"loop_state_elapsed": loop_event.state_elapsed,
		"loop_cycles": loop_event.cycle_count,
		"loop_seconds": loop_event.simulation_seconds,
		"loop_travel": RiftfallLoopEvent.travel_distance(),
		"loop_cycle_seconds": RiftfallLoopEvent.CYCLE_SECONDS,
		"stone_position": loop_event.stone_position(),
		"stone_rest": loop_event.rest_position(),
		"stone_impact": loop_event.impact_position(),
		"silhouette": silhouette_sighting(),
		"sockets": socket_positions(),
	}


func log_event(kind: String, detail: String) -> void:
	var line: String = "[gate-1c-riftfall] %-22s %s" % [kind, detail]
	log_lines.append(line)
	print(line)
