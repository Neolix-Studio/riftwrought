class_name ExteriorCohesionComparison
extends Node3D
## First-MVP Gate 1B — the Exterior Cohesion Comparison root.
##
## A temporary, developer-only, non-canonical scene, authorized by D-202 and
## specified by
## `design/FIRST_MVP_GATE_1B_EXTERIOR_COHESION_COMPARISON_SPECIFICATION.md`.
## It answers one narrower question than the first spike did, and no other:
##
##   Can a deliberately composed, traversable exterior route slice use one
##   restrained supplemental terrain language and one restrained ruin language
##   while still reading as the same game as the KayKit Knight, Dungeon, Forest,
##   and Halloween families?
##
## THIS IS NOT RIFTFALL LANDING. It is not the Severed Threshold, not Broken
## Watch, not the Nexus Threshold, not campaign content, and not a Bastion room.
## "Open arrival", "broken approach", and "threshold silhouette" are composition
## labels. There is no combat, no Quick Strike, no target acquisition, no enemy,
## no damage, no Life or Mana, no loot, no XP, no Passive, no inventory, no story,
## no Mara, no Nexus, no procedural generation, no HUD, and no save or settings
## file. Specification §9 requires that this comparison have "no production
## storage path", and it has none at all: it opens no engine user-data path,
## constructs no configuration store, saves no resource, and makes no filesystem
## call of any kind.
##
## That sentence deliberately avoids NAMING those APIs. This project's suites scan
## these files RAW — comments included — for the literal strings, and a raw scan
## is stronger than a comment-stripped one precisely because it cannot be talked
## around. A file that spells out the breach in prose fails its own check, which
## is correct behaviour for a scan of that shape and the reason the prose above is
## worded as it is.
##
## WHAT IT REUSES RATHER THAN CLONING. Specification §3: "Reuse the existing
## movement, camera, probe, material-treatment, and overlay code where its
## existing contract genuinely fits; do not create a second implementation merely
## to give this spike different names." So the locomotion contract is the accepted
## Prototype Zero one through the components extracted under D-195 —
## `PrototypeLocomotion`, `PrototypeGroundPointer`, `PrototypeMouseHold` — plus
## `PrototypeCameraRig`, `DestinationMarker`, and `InputFamilyTracker`; the body
## is the Gate 1A `calibration_hall_player.tscn` REUSED UNCHANGED; and the two
## review states and the non-destructive material treatment are the first Gate 1B
## spike's `ExteriorReviewLighting` and `ExteriorReviewTreatment`, reused
## unchanged and not forked. Not one byte of Prototype Zero, Gate 1A, the first
## Gate 1B spike's scene or scripts, the project entrypoint, or the InputMap is
## edited.
##
## NO NEW INPUT ACTION IS DECLARED. §6 asks for physical developer keys, so every
## review toggle below is read as a PHYSICAL KEY. That matters beyond tidiness:
## the Gate B, E, and F suites each walk `InputMap.get_actions()` and emit one
## assertion per key event, so declaring an action here would move three locked
## Prototype Zero counts without a single old assertion having become false.

const PLAYER_SCENE: String = "res://scenes/first_mvp/calibration/calibration_hall_player.tscn"
const VERIFICATION_SCRIPT: String = "res://tests/gate_1b_exterior_cohesion_verification.gd"
const WORLD_MASK: int = 1

## D-175's accepted values, reproduced here so the comparison measures the ASSETS
## against the accepted relationship rather than against a second opinion about
## it. §7 requires every one of them to be preserved, and the verification asserts
## each against the camera rig and player it actually built.
const ACCEPTED_WORLD_UNIT_METRES: float = 1.0
const ACCEPTED_P_METRES: float = 0.80
const ACCEPTED_CAMERA_DISTANCE: float = 19.0
const ACCEPTED_CAMERA_PITCH: float = 55.0
const ACCEPTED_CAMERA_FOV: float = 45.0
const ACCEPTED_MAX_SPEED: float = 5.0

@export_group("Navigation bake, metres")
@export var agent_radius: float = 0.40
@export var agent_height: float = 1.80
@export var agent_max_climb: float = 0.20
@export var agent_max_slope: float = 20.0
## The project's navigation defaults, and NOT a value to raise for bake speed on a
## large ground. The first Gate 1B spike measured what happens at 0.25: Recast
## places the baked surface on a voxel boundary, so the surface sat at y = 0.500
## while the character stands at 0.000, `NavigationAgent3D` measures its 0.40 m
## `path_desired_distance` in THREE dimensions, and the agent could never reach
## its own first path point — a full path was produced, the target reported
## reachable, and the body oscillated between two positions 8 mm apart forever.
## The verification asserts the measured baked-surface height against the agent's
## own tolerance, so this cannot come back silently.
@export var nav_cell_size: float = 0.15

@export_group("Review controls")
## §6 permits the accepted camera calibration keys only where they are inherited
## from the existing reusable camera component, and `[` / `]` are: they call
## `PrototypeCameraRig.adjust_distance()`, which Gate B shipped and Gate 1A and
## the first Gate 1B spike both reuse. The DEFAULT is always the accepted 19 m and
## `\` returns to it; nothing accepted is changed.
@export var camera_distance_step: float = 2.0

var route: ExteriorCohesionRoute
var nav_region: NavigationRegion3D
var player: CalibrationHallPlayer
var camera_rig: PrototypeCameraRig
var marker: DestinationMarker
var input_family: InputFamilyTracker
var lighting: ExteriorReviewLighting
var treatment: ExteriorReviewTreatment
var overlay: Node

var navmesh_polygon_count: int = 0
var navmesh_area: float = 0.0
var last_bake_msec: int = 0
## How many times the navigation mesh has been baked this session. It must be
## exactly ONE however many review modes are cycled: §7 forbids a visual mode
## changing navigation, and this scene makes that structural — no review toggle
## touches a collision shape, so none of them needs a rebake.
var bake_count: int = 0

# --- Instrumentation ----------------------------------------------------------
var log_lines: PackedStringArray = PackedStringArray()
var accepted_commands: int = 0
var adjusted_commands: int = 0
var rejected_commands: int = 0
var ui_clicks_absorbed: int = 0
## Every combat or interaction input this scene deliberately refused. §2: no
## combat. A counter makes that a measured fact rather than a promise.
var refused_action_inputs: int = 0
var overlay_visible: bool = true
## How many times the review toggles have been used this session, so the
## verification can prove a toggle really ran rather than that a flag was set.
var review_toggle_count: int = 0

var _mouse_hold: PrototypeMouseHold = PrototypeMouseHold.new()
var _stick_override_active: bool = false
var _stick_override: Vector2 = Vector2.ZERO
var _cursor_override: Variant = null


func _ready() -> void:
	nav_region = $NavigationRegion3D
	route = $NavigationRegion3D/Route
	camera_rig = $CameraRig
	marker = $DestinationMarker
	input_family = $InputFamilyTracker
	lighting = $ReviewLighting
	overlay = $CanvasLayer/ExteriorCohesionOverlay

	treatment = ExteriorReviewTreatment.new()
	lighting.configure($WorldEnvironment, $KeyLight)
	route.build(treatment, lighting)
	# The launch state is the EXISTING BASELINE in every axis: neutral review
	# light, imported source materials, the flat ground, the KayKit architecture,
	# and no dressing. A comparison that opened in its own proposal would be
	# answering a different question.
	lighting.set_mode(ExteriorReviewLighting.Mode.NEUTRAL)
	treatment.set_candidate(false)

	_configure_navigation()
	bake_navigation()
	_spawn_player()
	camera_rig.set_target(player)
	camera_rig.distance_metres = ACCEPTED_CAMERA_DISTANCE
	camera_rig.pitch_degrees = ACCEPTED_CAMERA_PITCH
	camera_rig.fov_degrees = ACCEPTED_CAMERA_FOV
	camera_rig.reset_calibration()

	input_family.family_changed.connect(_on_family_changed)
	overlay.call("bind", self)

	log_event("gate 1B cohesion", "temporary exterior cohesion comparison; nothing here is canonical")
	log_event("not riftfall landing", "no canonical route, combat, reward, story, Mara, Nexus, or save")
	log_event("credit", ExteriorCohesionCatalogue.CREDIT_KENNEY)
	log_event("credit", ExteriorCohesionCatalogue.CREDIT_QUATERNIUS)
	log_event("instances placed", "%d in total: %d registered KayKit anchors, %d topology, %d dressing, %d architecture" % [
		route.placed.size(), route.instances_in_layer("anchor"),
		route.instances_in_layer("topology"), route.instances_in_layer("dressing"),
		route.instances_in_layer("architecture_0") + route.instances_in_layer("architecture_1")
			+ route.instances_in_layer("architecture_2"),
	])
	log_event("catalogued models", "%d D-202 candidates, all placed at root scale 1.0" % (
		ExteriorCohesionCatalogue.manifest().size()
	))
	log_event("route footprint", "%.1f m centreline, %.1f m narrowest clear width, %.1f%% clear" % [
		route.centreline_length_metres(), route.narrowest_corridor_metres(),
		route.route_clear_fraction() * 100.0,
	])
	log_event("threshold gap", "%.3f m measured between the two gate stations, identical in every mode" % (
		route.threshold_gap_metres()
	))
	log_event("dungeon doorway", "%.3f m measured between the registered wall_pillar faces" % (
		route.dungeon_doorway_metres()
	))

	await _await_navigation_synchronized()
	_maybe_start_verification()


func _maybe_start_verification() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if not arguments.has("--verify-1b-cohesion"):
		return
	var script: GDScript = load(VERIFICATION_SCRIPT) as GDScript
	var runner: Node = Node.new()
	runner.name = "Gate1BCohesionVerification"
	runner.set_script(script)
	runner.set("comparison", self)
	runner.set("arguments", arguments)
	add_child(runner)


# --- Construction -------------------------------------------------------------

## The Gate 1A player scene, reused unchanged. Its class is still named
## `CalibrationHallPlayer` and its documentation still names the Scale Calibration
## Hall, because D-202 does not authorize editing a closed gate's files — not even
## its comments, which is the same call the first Gate 1B spike made. What it
## actually is, is a locomotion-only body over the one shared kernel, which is
## exactly what this comparison needs.
func _spawn_player() -> void:
	player = (load(PLAYER_SCENE) as PackedScene).instantiate() as CalibrationHallPlayer
	player.name = "Player"
	player.max_speed = ACCEPTED_MAX_SPEED
	player.position = route.player_spawn()
	$Actors.add_child(player)
	player.movement_command_resolved.connect(_on_movement_command_resolved)
	player.arrived_at_destination.connect(_on_arrived)
	player.movement_intent_cleared.connect(_on_intent_cleared)


# --- Navigation ---------------------------------------------------------------

func _configure_navigation() -> void:
	var mesh: NavigationMesh = NavigationMesh.new()
	# Baked from the route's own project-authored collision boxes, not from the
	# candidate meshes, so the walkable surface can never disagree with what the
	# character collides against — and so switching a visual family cannot move
	# the route, which §7 forbids.
	mesh.geometry_parsed_geometry_type = NavigationMesh.PARSED_GEOMETRY_STATIC_COLLIDERS
	mesh.geometry_collision_mask = WORLD_MASK
	mesh.geometry_source_geometry_mode = NavigationMesh.SOURCE_GEOMETRY_ROOT_NODE_CHILDREN
	mesh.cell_size = nav_cell_size
	mesh.cell_height = nav_cell_size
	mesh.agent_radius = agent_radius
	mesh.agent_height = agent_height
	mesh.agent_max_climb = agent_max_climb
	mesh.agent_max_slope = agent_max_slope
	# Clipped BELOW the 1.00 m boundary shoulders, exactly as the Gate 1A hall
	# clips its own bake below a 1.20 m half-wall: it removes every raised top
	# from the bake so nothing above the corridor floor can rasterise as a
	# walkable ledge. Every solid also carves its own footprint, which is what
	# stops the resulting open-topped wells keeping a phantom interior.
	#
	# It is also clipped to the ROUTE rather than to the whole authored ground.
	# Measured on the first build: baking the full 84 x 124 m ground produced
	# 9487.2 m^2 of walkable surface, almost all of it the open ground OUTSIDE the
	# boundary shoulders — an island the character can never reach, but one that
	# `map_get_closest_point` would happily snap an unreachable click onto. The
	# walkable surface should be the route the owner is asked to walk.
	var rect: Rect2 = route.route_bake_rect()
	mesh.filter_baking_aabb = AABB(
		Vector3(rect.position.x, -1.0, rect.position.y),
		Vector3(rect.size.x, 1.9, rect.size.y)
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
	for i: int in navmesh_polygon_count:
		var indices: PackedInt32Array = mesh.get_polygon(i)
		for t: int in range(1, indices.size() - 1):
			var a: Vector3 = vertices[indices[0]]
			var b: Vector3 = vertices[indices[t]]
			var c: Vector3 = vertices[indices[t + 1]]
			area += absf((b.x - a.x) * (c.z - a.z) - (c.x - a.x) * (b.z - a.z)) * 0.5
	navmesh_area = area


func navigation_map() -> RID:
	return get_world_3d().navigation_map


## The navigation map is not QUERYABLE until the server has synchronized it at
## least once. The readiness test is a real query with a known answer rather than
## a counter: the player spawn must come back as itself.
func _await_navigation_synchronized() -> void:
	var probe: Vector3 = route.player_spawn()
	for frame: int in 30:
		if NavigationServer3D.map_get_iteration_id(navigation_map()) == 0:
			await get_tree().physics_frame
			continue
		var answer: Vector3 = NavigationServer3D.map_get_closest_point(navigation_map(), probe)
		if Vector2(answer.x - probe.x, answer.z - probe.z).length() < 0.35:
			log_event("navigation ready", "map answers queries after %d physics frame%s" % [
				frame, "" if frame == 1 else "s",
			])
			return
		await get_tree().physics_frame
	push_warning("ExteriorCohesionComparison: the navigation map did not become queryable")


func point_is_navigable(point: Vector3, tolerance: float = 0.35) -> bool:
	var flat: Vector3 = Vector3(point.x, 0.0, point.z)
	var answer: Vector3 = NavigationServer3D.map_get_closest_point(navigation_map(), flat)
	return Vector2(answer.x - flat.x, answer.z - flat.z).length() <= tolerance


## The complete walking line the owner is asked to traverse, as the navigation
## server resolves it. Measured in every mode combination.
func route_path() -> PackedVector3Array:
	return NavigationServer3D.map_get_path(
		navigation_map(), route.player_spawn(), route.route_target(), true
	)


func route_path_length() -> float:
	var points: PackedVector3Array = route_path()
	var total: float = 0.0
	for i: int in range(1, points.size()):
		total += points[i].distance_to(points[i - 1])
	return total


# --- Input --------------------------------------------------------------------

func _input(event: InputEvent) -> void:
	input_family.observe(event)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"move_point"):
		if _pointer_over_ui():
			ui_clicks_absorbed += 1
			log_event("movement command rejected", "pointer over interface, no world command issued")
			return
		_mouse_hold.press()
		_issue_move_command()
		return
	if event.is_action_released(&"move_point"):
		_mouse_hold.release()
		return
	# §2: no combat. The combat actions are refused HERE, by name, and counted,
	# rather than being silently unbound somewhere else.
	for refused: StringName in [&"quick_strike", &"attack_in_place", &"interact"]:
		if event.is_action_pressed(refused):
			refused_action_inputs += 1
			log_event("input refused", "'%s' has no action in the cohesion comparison" % refused)
			return
	_handle_review_keys(event)


## Specification §6's review toggles, all read as PHYSICAL KEYS so no InputMap
## action is added.
func _handle_review_keys(event: InputEvent) -> void:
	var key: InputEventKey = event as InputEventKey
	if key == null or not key.pressed or key.echo:
		return
	match key.physical_keycode:
		KEY_F1:
			set_lighting_candidate(lighting.mode == ExteriorReviewLighting.Mode.NEUTRAL)
		KEY_F2:
			set_candidate_materials(not treatment.candidate_active())
		KEY_F3:
			set_overlay_visible(not overlay_visible)
		KEY_F4:
			set_topology_visible(not route.topology_visible)
		KEY_F5:
			cycle_architecture()
		KEY_F6:
			route.set_grid_visible(not route.grid_visible)
			review_toggle_count += 1
			log_event("scale grid", "visible=%s" % str(route.grid_visible))
		KEY_F7:
			set_dressing_visible(not route.dressing_visible)
		KEY_BRACKETLEFT:
			camera_rig.adjust_distance(-camera_distance_step)
			_log_camera()
		KEY_BRACKETRIGHT:
			camera_rig.adjust_distance(camera_distance_step)
			_log_camera()
		KEY_BACKSLASH:
			reset_review()


func set_lighting_candidate(active: bool) -> void:
	lighting.set_mode(
		ExteriorReviewLighting.Mode.CANDIDATE if active else ExteriorReviewLighting.Mode.NEUTRAL
	)
	review_toggle_count += 1
	log_event("review lighting", lighting.mode_name())


func set_candidate_materials(active: bool) -> void:
	treatment.set_candidate(active)
	review_toggle_count += 1
	log_event("review materials", "%s (%d surfaces)" % [
		"candidate treatment" if active else "imported source materials",
		treatment.surface_count(),
	])


## §5.2's terrain axis. No rebake follows, and that is the point: the authored
## boundary shoulders own the collision and the carve, and the Kenney cliff panels
## only face them.
func set_topology_visible(value: bool) -> void:
	route.set_topology_visible(value)
	review_toggle_count += 1
	log_event("kenney nature topology", "%s; navigation untouched (bake #%d stands)" % [
		"on" if value else "off (existing flat baseline)", bake_count,
	])


func cycle_architecture() -> void:
	var mode: ExteriorCohesionRoute.Architecture = route.cycle_architecture()
	review_toggle_count += 1
	log_event("architecture", "%s; same stations, same %.3f m threshold gap" % [
		ExteriorCohesionRoute.architecture_name(mode), route.threshold_gap_metres(),
	])


func set_architecture(mode: ExteriorCohesionRoute.Architecture) -> void:
	route.set_architecture(mode)
	review_toggle_count += 1
	log_event("architecture", ExteriorCohesionRoute.architecture_name(mode))


func set_dressing_visible(value: bool) -> void:
	route.set_dressing_visible(value)
	review_toggle_count += 1
	log_event("graveyard dressing", "%s; adds no collision and no navigation carve" % [
		"on" if value else "off",
	])


## §6: "reset modes, player, camera, and comparison state". Everything a session
## can change goes back to the launch state, and nothing was ever written to disk
## to go back to.
func reset_review() -> void:
	lighting.set_mode(ExteriorReviewLighting.Mode.NEUTRAL)
	treatment.set_candidate(false)
	route.set_topology_visible(false)
	route.set_architecture(ExteriorCohesionRoute.Architecture.KAYKIT_BASELINE)
	route.set_dressing_visible(false)
	route.set_grid_visible(false)
	set_overlay_visible(true)
	camera_rig.reset_calibration()
	player.clear_movement_intent("review reset", false)
	player.global_position = route.player_spawn()
	player.velocity = Vector3.ZERO
	marker.hide_destination()
	review_toggle_count += 1
	log_event("review reset", "lighting, materials, topology, architecture, dressing, grid, camera, player")


func review_is_launch_state() -> bool:
	return (
		lighting.mode == ExteriorReviewLighting.Mode.NEUTRAL
		and not treatment.candidate_active()
		and not route.topology_visible
		and route.architecture == ExteriorCohesionRoute.Architecture.KAYKIT_BASELINE
		and not route.dressing_visible
		and not route.grid_visible
		and overlay_visible
		and camera_rig.is_default()
	)


func set_overlay_visible(value: bool) -> void:
	overlay_visible = value
	(overlay as CanvasItem).visible = value
	review_toggle_count += 1
	log_event("review overlay", "visible=%s" % str(value))


func _log_camera() -> void:
	log_event("camera", "distance %.1f m (accepted default %.1f m), pitch %.1f deg, fov %.1f deg" % [
		camera_rig.distance_metres, ACCEPTED_CAMERA_DISTANCE,
		camera_rig.pitch_degrees, camera_rig.fov_degrees,
	])


func _pointer_over_ui() -> bool:
	return get_viewport().gui_get_hovered_control() != null


func _process(delta: float) -> void:
	if player == null:
		return
	player.set_ground_basis(camera_rig.ground_forward(), camera_rig.ground_right())
	if _mouse_hold.should_reissue(delta, Input.is_action_pressed(&"move_point")):
		if _pointer_over_ui():
			ui_clicks_absorbed += 1
		else:
			_issue_move_command()
	_update_neutral_latch()


func _physics_process(_delta: float) -> void:
	if player == null:
		return
	player.set_stick_raw(read_stick_raw())


func read_stick_raw() -> Vector2:
	if _stick_override_active:
		return _stick_override
	return PrototypeLocomotion.read_stick_actions()


func set_stick_override(raw: Variant) -> void:
	if raw == null:
		_stick_override_active = false
		_stick_override = Vector2.ZERO
		return
	_stick_override_active = true
	_stick_override = raw


func set_cursor_override(screen: Variant) -> void:
	_cursor_override = screen


func _update_neutral_latch() -> void:
	if not player.awaiting_neutral:
		return
	if Input.is_action_pressed(&"move_point"):
		return
	if read_stick_raw().length() > player.stick_deadzone:
		return
	player.release_neutral_latch()
	log_event("input neutral", "held movement controls returned to neutral; input accepted again")


# --- Movement commands --------------------------------------------------------

func _issue_move_command() -> void:
	var cursor: Dictionary = ground_point_under_cursor(_cursor_override)
	if not bool(cursor.get("valid", false)):
		rejected_commands += 1
		log_event("movement command rejected", "no ground under the cursor")
		return
	var requested: Vector3 = cursor["point"]
	var resolution: Dictionary = resolve_to_navigation(requested)
	player.command_move_to(resolution["point"], requested, bool(resolution["adjusted"]))


func ground_point_under_cursor(at_screen: Variant = null) -> Dictionary:
	var screen: Vector2 = at_screen if at_screen != null else get_viewport().get_mouse_position()
	return PrototypeGroundPointer.ground_point(
		camera_rig.camera, get_world_3d(), screen, WORLD_MASK
	)


func resolve_to_navigation(requested: Vector3) -> Dictionary:
	return PrototypeGroundPointer.resolve_to_navigation(navigation_map(), requested)


func _on_movement_command_resolved(status: String, requested: Vector3, resolved: Vector3) -> void:
	if status.begins_with("rejected"):
		rejected_commands += 1
		log_event("movement command rejected", status)
		return
	if status == "adjusted":
		adjusted_commands += 1
		log_event("movement command adjusted",
			"clicked (%.2f, %.2f) is not walkable; nearest navigable point (%.2f, %.2f)" % [
				requested.x, requested.z, resolved.x, resolved.z,
			])
	else:
		accepted_commands += 1
		log_event("movement command accepted", "destination (%.2f, %.2f)" % [resolved.x, resolved.z])
	marker.show_destination(resolved, requested, status == "adjusted")


func _on_arrived(point: Vector3) -> void:
	marker.hide_destination()
	log_event("arrived", "at (%.2f, %.2f)" % [point.x, point.z])


func _on_intent_cleared(reason: String) -> void:
	marker.hide_destination()
	log_event("movement intent cleared", reason)


func _on_family_changed(_family: InputFamilyTracker.Family, reason: String) -> void:
	log_event("input family", "%s (%s)" % [input_family.family_label(), reason])


# --- Measurement, for the overlay and the verification ------------------------

## Everything the §8 measurement table needs, measured from the built scene or
## from the authoritative catalogue. Nothing here is a hand-typed expectation, and
## nothing here is a visual judgement: §8's "foreground, background-only, or
## rejected" status is deliberately absent, because §10 reserves it for the owner.
func measurements() -> Dictionary:
	var footprint: Dictionary = camera_footprint()
	return {
		"world_unit_metres": ACCEPTED_WORLD_UNIT_METRES,
		"player_unit_metres": ACCEPTED_P_METRES,
		"camera_distance": camera_rig.distance_metres,
		"camera_distance_default": ACCEPTED_CAMERA_DISTANCE,
		"camera_pitch": camera_rig.pitch_degrees,
		"camera_fov": camera_rig.fov_degrees,
		"camera_yaw": camera_rig.yaw_degrees,
		"max_speed": player.max_speed,
		"player_diameter": player.collision_diameter(),
		"player_height": player.collision_height(),
		"cf_metres": Vector2(float(footprint["focus_width"]), float(footprint["depth"])),
		"reference_aspect": float(footprint["reference_aspect"]),
		"live_aspect": float(footprint["live_aspect"]),
		"ground_metres": route.ground_rect().size,
		"route_metres": route.route_rect().size,
		"centreline_metres": route.centreline_length_metres(),
		"narrowest_corridor": route.narrowest_corridor_metres(),
		"route_clear_fraction": route.route_clear_fraction(),
		"threshold_gap": route.threshold_gap_metres(),
		"dungeon_doorway": route.dungeon_doorway_metres(),
		"candidates": candidate_measurements(),
		"lighting_mode": lighting.mode_name(),
		"materials_candidate": treatment.candidate_active(),
		"treated_surfaces": treatment.surface_count(),
		"topology_visible": route.topology_visible,
		"architecture": ExteriorCohesionRoute.architecture_name(route.architecture),
		"dressing_visible": route.dressing_visible,
		"grid_visible": route.grid_visible,
		"player_position": player.global_position,
		"movement_mode": player.movement_mode_name(),
		"input_family": input_family.family_label(),
		"navmesh_polygons": navmesh_polygon_count,
		"navmesh_area": navmesh_area,
		"bake_msec": last_bake_msec,
		"bake_count": bake_count,
		"is_launch_state": review_is_launch_state(),
		"instances": route.placed.size(),
		"atlas_dependent_models": atlas_dependent_models(),
	}


## One row per catalogued candidate, measured from the PRIMARY placed instance.
func candidate_measurements() -> Array[Dictionary]:
	var rows: Array[Dictionary] = []
	for entry: Dictionary in route.primary_instances():
		var record: Dictionary = entry["record"]
		if String(record["key"]).begins_with("ref_"):
			continue
		var probe: Dictionary = entry["probe"]
		rows.append({
			"key": record["key"],
			"display": record["display"],
			"family": record["family"],
			"path": record["path"],
			"in_archive": record["in_archive"],
			"archive": record["archive"],
			"role": record["role"],
			"size": probe["size"],
			"base_offset": probe["base_offset"],
			"meshes": probe["meshes"],
			"surfaces": probe["surfaces"],
			"vertices": probe["vertices"],
			"materials": probe["materials"],
			"textures": probe["textures"],
			"untextured_surfaces": probe["untextured_surfaces"],
			"missing_normals": probe["missing_normals"],
			"double_sided": probe["double_sided"],
			"transparent": probe["transparent"],
			"casts_shadow": probe["casts_shadow"],
			"receives_light": probe["receives_light"],
			"scale": probe["scale"],
			"instances": route.instances_of(String(record["key"])),
			"screen_fraction": ExteriorAssetProbe.screen_height_fraction(
				float(probe["size"].y), ACCEPTED_CAMERA_DISTANCE, ACCEPTED_CAMERA_FOV
			),
		})
	return rows


## How many placed models declare an EXTERNAL colour atlas rather than embedding
## their own image. It counts a fact about the glTF, not a failure: since D-204
## restored both atlases all nine RESOLVE, and the overlay says so. The other
## twelve carry flat named colour materials by design and declare no image at all
## — a different condition, kept separate here and in the report.
func atlas_dependent_models() -> int:
	var total: int = 0
	for record: Dictionary in ExteriorCohesionCatalogue.manifest():
		if bool(record["declares_external_atlas"]):
			total += 1
	return total


## The ground quad the camera actually covers, measured at the fixed reference
## aspect exactly as Gate B records CF and Gate 1A measures it. CF is a project
## unit, not a function of the window.
func camera_footprint() -> Dictionary:
	var footprint: Dictionary = camera_rig.ground_footprint(reference_aspect())
	footprint["reference_aspect"] = reference_aspect()
	footprint["live_aspect"] = live_aspect()
	return footprint


func reference_aspect() -> float:
	return (
		float(ProjectSettings.get_setting("display/window/size/viewport_width", 1920))
		/ float(ProjectSettings.get_setting("display/window/size/viewport_height", 1080))
	)


func live_aspect() -> float:
	var viewport: Vector2 = get_viewport().get_visible_rect().size
	return viewport.x / maxf(viewport.y, 1.0)


# --- Log ----------------------------------------------------------------------

func log_event(kind: String, detail: String) -> void:
	var line: String = "[gate-1b-cohesion] %-26s %s" % [kind, detail]
	log_lines.append(line)
	print(line)
