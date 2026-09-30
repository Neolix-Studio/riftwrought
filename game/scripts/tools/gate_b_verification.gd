extends Node
## Prototype Zero — Gate B automated verification.
##
## Specification §25 forbids installing a test framework and states plainly that
## automated tests cannot certify feel. These checks therefore assert only the
## things a machine CAN settle: that the navigation mesh covers the room, that
## an unreachable click resolves onto it, that both movement schemes actually
## move the character and stop where they should, that walls hold, that the
## deadzone rejects noise, that analog magnitude scales speed, that input-family
## tracking follows real input and ignores drift, and that no WASD binding
## exists. Whether any of it feels good is the project owner's judgement.
##
## Run:  godot --headless --path game -- --verify
##       godot --path game --resolution 1280x720 -- --verify --shots <dir>

const TICK: float = 1.0 / 60.0

var room: PrototypeZeroRoom
var player: PrototypePlayer

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _shot_dir: String = ""
var _joypad_injection_works: bool = false


func run(owner_room: PrototypeZeroRoom, arguments: PackedStringArray) -> void:
	room = owner_room
	player = owner_room.player
	_shot_dir = _argument_value(arguments, "--shots")

	print("")
	print("=== Gate B verification ===")
	await _settle(10)
	_joypad_injection_works = await _probe_joypad_injection()

	_report_calibration()
	_check_approved_calibration()
	await _check_navigation_mesh()
	await _check_unreachable_resolution()
	await _check_cursor_raycast()
	await _check_click_to_move_arrival()
	await _check_ui_does_not_leak()
	await _check_wall_collision()
	await _check_barrier_detour()
	await _check_controller_movement()
	await _check_input_family()
	_check_no_wasd()

	if _shot_dir != "":
		await _capture_evidence()

	print("")
	if _failures.is_empty():
		print("GATE B VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("GATE B VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		get_tree().quit(1)


# --- Measured calibration record ---------------------------------------------

func _report_calibration() -> void:
	var summary: Dictionary = room.calibration_summary()
	print("")
	print("--- Measured calibration (locked by D-175; not final first-MVP scale)")
	print("  world unit interpretation   1 unit = 1 metre")
	print("  clear playable floor        %.1f x %.1f m   (full floor %.1f x %.1f m)" % [
		summary["clear_floor"].x, summary["clear_floor"].y,
		summary["full_floor"].x, summary["full_floor"].y,
	])
	print("  P, player collision         %.2f m diameter, %.2f m tall capsule" % [
		summary["player_collision_diameter_P"], summary["player_collision_height"],
	])
	print("  movement                    %.1f m/s max, %.0f accel, %.0f brake, %.2f stick deadzone" % [
		summary["max_speed"], summary["acceleration"], summary["braking"], summary["stick_deadzone"],
	])
	print("  long-axis crossing time     %.2f s" % summary["crossing_time_long_axis"])
	print("  camera                      yaw %.0f deg, pitch %.0f deg, fov %.0f deg, %.0f m out, %.1f m high" % [
		summary["camera_yaw"], summary["camera_pitch"], summary["camera_fov"],
		summary["camera_distance"], summary["camera_height"],
	])
	print("  CF, camera ground footprint %.1f m wide at the character, %.1f m deep" % [
		summary["cf_focus_width"], summary["cf_depth"],
	])
	print("                              %.1f m wide at the near edge, %.1f m at the far edge" % [
		summary["cf_near_width"], summary["cf_far_width"],
	])
	print("  clear floor in CF units     %.2f CF  (CF measured at the %.2f reference aspect)" % [
		summary["room_in_cf"], summary["aspect"],
	])
	print("  ground seen past the focus  %.1f m" % summary["ground_visible_past_focus"])
	print("  navigation mesh             %d polygons, %.1f m^2 walkable" % [
		summary["navmesh_polygons"], summary["navmesh_area"],
	])


# --- Checks ------------------------------------------------------------------

## The project owner selected these live and locked them under D-175. They are
## now the SHIPPED defaults, so they are asserted rather than merely printed: a
## later gate must not be able to drift the approved calibration by accident.
func _check_approved_calibration() -> void:
	print("")
	print("--- Approved calibration is the shipped default (D-175)")
	var summary: Dictionary = room.calibration_summary()
	var expectations: Array[Dictionary] = [
		{"what": "clear floor width", "got": summary["clear_floor"].x, "want": 18.0, "tol": 0.001, "unit": "m"},
		{"what": "clear floor depth", "got": summary["clear_floor"].y, "want": 14.0, "tol": 0.001, "unit": "m"},
		{"what": "player collision diameter P", "got": summary["player_collision_diameter_P"], "want": 0.80, "tol": 0.001, "unit": "m"},
		{"what": "player collision height", "got": summary["player_collision_height"], "want": 1.80, "tol": 0.001, "unit": "m"},
		{"what": "maximum movement speed", "got": summary["max_speed"], "want": 5.0, "tol": 0.001, "unit": "m/s"},
		{"what": "camera distance", "got": summary["camera_distance"], "want": 19.0, "tol": 0.001, "unit": "m"},
		{"what": "camera pitch", "got": summary["camera_pitch"], "want": 55.0, "tol": 0.001, "unit": "deg"},
		{"what": "camera field of view", "got": summary["camera_fov"], "want": 45.0, "tol": 0.001, "unit": "deg"},
		{"what": "CF width at the character", "got": summary["cf_focus_width"], "want": 28.0, "tol": 0.15, "unit": "m"},
		{"what": "CF depth", "got": summary["cf_depth"], "want": 21.0, "tol": 0.15, "unit": "m"},
		{"what": "clear floor in CF units", "got": summary["room_in_cf"], "want": 0.43, "tol": 0.005, "unit": "CF"},
	]
	for expectation: Dictionary in expectations:
		var got: float = expectation["got"]
		var want: float = expectation["want"]
		print("  %-28s %8.3f %-4s (approved %.3f)" % [expectation["what"], got, expectation["unit"], want])
		_expect(absf(got - want) <= float(expectation["tol"]),
			"%s is %.3f %s, but D-175 approved %.3f %s" % [
				expectation["what"], got, expectation["unit"], want, expectation["unit"],
			])

	# Retained, not re-approved: the owner's verdict covered overall feel and
	# raised no objection to these, so they are the accepted first baseline.
	var retained: Array[Dictionary] = [
		{"what": "acceleration", "got": player.acceleration, "want": 30.0, "unit": "m/s^2"},
		{"what": "braking", "got": player.braking, "want": 40.0, "unit": "m/s^2"},
		{"what": "arrival tolerance", "got": player.arrival_tolerance, "want": 0.20, "unit": "m"},
		{"what": "stick deadzone", "got": player.stick_deadzone, "want": 0.20, "unit": ""},
		{"what": "substantial-turn threshold", "got": player.substantial_turn_degrees, "want": 35.0, "unit": "deg"},
		{"what": "camera follow half-life", "got": room.camera_rig.follow_half_life, "want": 0.07, "unit": "s"},
		{"what": "run-cycle reference speed", "got": player.run_cycle_reference_speed, "want": 5.0, "unit": "m/s"},
	]
	for item: Dictionary in retained:
		_expect(is_equal_approx(float(item["got"]), float(item["want"])),
			"retained baseline %s changed from %.3f to %.3f" % [item["what"], item["want"], item["got"]])
	print("  retained baseline unchanged: 30 accel, 40 brake, 0.20 arrival, 0.20 deadzone, 35 deg turn, 0.07 s follow")
	print("  run animation reference speed now tracks the approved 5.0 m/s maximum")

	# The reset key must return to the approved values, not to an older default.
	room.camera_rig.adjust_distance(4.0)
	room.camera_rig.adjust_fov(-6.0)
	player.max_speed = 2.0
	room.camera_rig.reset_calibration()
	player.max_speed = room._default_max_speed
	print("  after adjusting and resetting: %.1f m, fov %.1f deg, %.1f m/s" % [
		room.camera_rig.distance_metres, room.camera_rig.fov_degrees, player.max_speed,
	])
	_expect(is_equal_approx(room.camera_rig.distance_metres, 19.0), "reset did not restore the approved 19 m camera distance")
	_expect(is_equal_approx(room.camera_rig.fov_degrees, 45.0), "reset did not restore the approved 45 degree field of view")
	_expect(is_equal_approx(room.camera_rig.pitch_degrees, 55.0), "reset did not restore the approved 55 degree pitch")
	_expect(is_equal_approx(player.max_speed, 5.0), "reset did not restore the approved 5.0 m/s maximum speed")


func _check_navigation_mesh() -> void:
	print("")
	print("--- Navigation mesh")
	var clear: Vector2 = room.clear_extent()
	# A correct bake inscribes the clear floor by roughly the agent radius on
	# every side, so the walkable area sits a little under the clear floor.
	var ideal: float = (clear.x - room.agent_radius_used() * 2.0) * (clear.y - room.agent_radius_used() * 2.0)
	print("  walkable area %.1f m^2 against an inscribed ideal of about %.1f m^2" % [room.navmesh_area, ideal])
	_expect(room.navmesh_polygon_count > 0, "the navigation mesh baked no polygons")
	_expect(room.navmesh_area > ideal * 0.80, "walkable area %.1f m^2 is far under the inscribed ideal %.1f m^2" % [room.navmesh_area, ideal])
	_expect(room.navmesh_area < clear.x * clear.y * 1.05, "walkable area %.1f m^2 exceeds the clear floor" % room.navmesh_area)

	# No dead pocket: every sampled point on a 1 m lattice inside the clear
	# floor, inset by the agent radius, must sit on the mesh.
	var off_mesh: int = 0
	var sampled: int = 0
	var inset: float = room.agent_radius_used() + 0.15
	var x: float = -clear.x * 0.5 + inset
	while x <= clear.x * 0.5 - inset:
		var z: float = -clear.y * 0.5 + inset
		while z <= clear.y * 0.5 - inset:
			var wanted: Vector3 = Vector3(x, 0.0, z)
			var got: Vector3 = NavigationServer3D.map_get_closest_point(room.navigation_map(), wanted)
			sampled += 1
			if got.distance_to(wanted) > 0.25:
				off_mesh += 1
			z += 1.0
		x += 1.0
	print("  lattice coverage: %d of %d sampled interior points are on the mesh" % [sampled - off_mesh, sampled])
	_expect(off_mesh == 0, "%d of %d interior lattice points are not on the navigation mesh" % [off_mesh, sampled])


func _check_unreachable_resolution() -> void:
	print("")
	print("--- Unreachable-point resolution (specification §9.3)")
	var probes: Array[Vector3] = [
		Vector3(40.0, 0.0, 40.0),      # far outside the room
		Vector3(0.0, 0.0, -60.0),      # far beyond the north wall
		Vector3(-9.6, 0.0, 0.0),       # inside the west wall
		Vector3(9.9, 0.0, 7.4),        # inside the south-east corner
	]
	for probe: Vector3 in probes:
		var resolution: Dictionary = room.resolve_to_navigation(probe)
		var resolved: Vector3 = resolution["point"]
		print("  (%7.1f, %7.1f) -> (%6.2f, %6.2f)  adjusted=%s" % [
			probe.x, probe.z, resolved.x, resolved.z, str(resolution["adjusted"]),
		])
		_expect(bool(resolution["adjusted"]), "unreachable point (%.1f, %.1f) was reported as directly walkable" % [probe.x, probe.z])
		_expect(room.contains_point_in_clear_floor(resolved, 0.05),
			"unreachable point (%.1f, %.1f) resolved to (%.2f, %.2f), outside the clear floor" % [
				probe.x, probe.z, resolved.x, resolved.z,
			])

	# A point on the open floor must NOT be adjusted.
	var open: Dictionary = room.resolve_to_navigation(Vector3(3.0, 0.0, -2.0))
	_expect(not bool(open["adjusted"]), "an open-floor point was needlessly adjusted")


## The raycast under the cursor is the entry point of the whole mouse scheme, so
## it is aimed at real screen positions rather than trusted.
func _check_cursor_raycast() -> void:
	print("")
	print("--- Cursor raycast into the world")
	await _teleport(Vector3(0.0, 0.0, 0.0))
	var size: Vector2 = room.get_viewport().get_visible_rect().size
	print("  viewport %d x %d" % [int(size.x), int(size.y)])

	var centre: Dictionary = room.ground_point_under_cursor(size * 0.5)
	_expect(bool(centre.get("valid", false)), "the ray through the screen centre found no world point")
	var centre_point: Vector3 = centre["point"]
	print("  screen centre   -> (%6.2f, %6.2f, %6.2f) world hit=%s" % [
		centre_point.x, centre_point.y, centre_point.z, str(centre["hit_world"]),
	])
	_expect(bool(centre["hit_world"]), "the screen centre did not hit any collider")
	_expect(absf(centre_point.y) < 0.05, "the screen centre hit something %.2f m above the floor" % centre_point.y)
	# The camera is aimed at the player, so the centre of the screen is the floor
	# under the player's feet.
	var centre_offset: float = Vector2(centre_point.x, centre_point.z).length()
	_expect(centre_offset < 1.0, "the screen centre resolved %.2f m away from the camera focus" % centre_offset)

	# Aim low on the screen: still floor, and nearer the camera than the centre.
	var low: Dictionary = room.ground_point_under_cursor(Vector2(size.x * 0.5, size.y * 0.88))
	var low_point: Vector3 = low["point"]
	print("  low on screen   -> (%6.2f, %6.2f, %6.2f)" % [low_point.x, low_point.y, low_point.z])
	_expect(bool(low.get("valid", false)), "a click low on the screen found no world point")
	_expect(low_point.x + low_point.z > centre_point.x + centre_point.z,
		"a click low on the screen did not land nearer the camera than the centre")

	# Aim high on the screen: this is where the far wall stands, so the hit is
	# well above the floor and must be corrected onto the navigation mesh.
	var high: Dictionary = room.ground_point_under_cursor(Vector2(size.x * 0.5, size.y * 0.06))
	var high_point: Vector3 = high["point"]
	var high_resolution: Dictionary = room.resolve_to_navigation(high_point)
	print("  high on screen  -> (%6.2f, %6.2f, %6.2f) world hit=%s, resolved to (%.2f, %.2f) adjusted=%s" % [
		high_point.x, high_point.y, high_point.z, str(high["hit_world"]),
		high_resolution["point"].x, high_resolution["point"].z, str(high_resolution["adjusted"]),
	])
	_expect(bool(high.get("valid", false)), "a click high on the screen found no world point")
	_expect(room.contains_point_in_clear_floor(high_resolution["point"], 0.05),
		"a click on the far wall resolved outside the clear floor")

	# Every corner of the screen must produce a usable destination rather than a
	# rejection, so the player can never click somewhere that silently does
	# nothing while the room is in view.
	for corner: Vector2 in [
		Vector2(0.04, 0.10), Vector2(0.96, 0.10), Vector2(0.04, 0.94), Vector2(0.96, 0.94),
	]:
		var probe: Dictionary = room.ground_point_under_cursor(corner * size)
		_expect(bool(probe.get("valid", false)), "a click at screen fraction %s produced no world point" % str(corner))
		if bool(probe.get("valid", false)):
			var resolved: Vector3 = room.resolve_to_navigation(probe["point"])["point"]
			_expect(room.contains_point_in_clear_floor(resolved, 0.05),
				"a click at screen fraction %s resolved outside the clear floor" % str(corner))
	print("  all four screen corners resolve to points inside the clear floor")


func _check_click_to_move_arrival() -> void:
	print("")
	print("--- Click-to-move arrival")
	await _teleport(Vector3(-7.0, 0.0, -5.0))
	var target: Vector3 = room.resolve_to_navigation(Vector3(7.0, 0.0, 5.0))["point"]
	player.command_move_to(target, target, false)
	var elapsed: float = await _await_idle(12.0)
	var distance: float = Vector2(player.global_position.x - target.x, player.global_position.z - target.z).length()
	print("  travelled the room diagonal in %.2f s, stopped %.3f m from the destination" % [elapsed, distance])
	_expect(elapsed < 12.0, "the character never finished its path")
	_expect(distance <= player.arrival_tolerance + 0.15,
		"stopped %.3f m from the destination, outside the %.2f m arrival tolerance" % [distance, player.arrival_tolerance])
	_expect(player.action_state == PrototypePlayer.ActionState.IDLE, "state did not return to IDLE on arrival")
	_expect(player.planar_speed() < 0.2, "the character was still moving %.2f m/s after arrival" % player.planar_speed())

	# A brand-new command while already walking must replace the old one.
	var first: Vector3 = room.resolve_to_navigation(Vector3(-6.0, 0.0, 4.0))["point"]
	player.command_move_to(first, first, false)
	await _settle(20)
	var second: Vector3 = room.resolve_to_navigation(Vector3(6.0, 0.0, -4.0))["point"]
	player.command_move_to(second, second, false)
	_expect(player.destination.is_equal_approx(second), "a new movement command did not replace the older destination")
	await _await_idle(12.0)
	var second_distance: float = Vector2(player.global_position.x - second.x, player.global_position.z - second.z).length()
	print("  a redirected command arrived %.3f m from the newer destination" % second_distance)
	_expect(second_distance <= player.arrival_tolerance + 0.15, "the redirected command did not reach the newer destination")


func _check_ui_does_not_leak() -> void:
	print("")
	print("--- Interface click absorption (specification §9.3)")
	# The overlay panels use MOUSE_FILTER_STOP, so a click on one never reaches
	# `_unhandled_input`. Assert the property that guarantees it rather than
	# faking a pointer position.
	var overlay: Control = room.overlay as Control
	var stopping: int = 0
	var passing: PackedStringArray = PackedStringArray()
	for child: Node in overlay.get_children():
		if child is Control:
			var control: Control = child as Control
			if control.mouse_filter == Control.MOUSE_FILTER_STOP:
				stopping += 1
			elif control.mouse_filter == Control.MOUSE_FILTER_PASS:
				passing.append(control.name)
	print("  overlay root filter=%d (2 = ignore), %d absorbing panels, %d passing" % [
		overlay.mouse_filter, stopping, passing.size(),
	])
	_expect(overlay.mouse_filter == Control.MOUSE_FILTER_IGNORE,
		"the overlay root absorbs clicks over the whole play field")
	_expect(passing.is_empty(), "overlay panels %s pass clicks through to the world" % str(passing))
	_expect(stopping > 0, "no overlay panel absorbs clicks, so the leak test has nothing to prove")


func _check_wall_collision() -> void:
	print("")
	print("--- Wall collision")
	var half: Vector2 = room.clear_half_extent()
	await _teleport(Vector3(0.0, 0.0, 0.0))
	# Command a destination hard against each wall and hold there.
	for corner: Vector3 in [
		Vector3(-half.x, 0.0, -half.y), Vector3(half.x, 0.0, -half.y),
		Vector3(half.x, 0.0, half.y), Vector3(-half.x, 0.0, half.y),
	]:
		var target: Vector3 = room.resolve_to_navigation(corner)["point"]
		player.command_move_to(target, corner, true)
		await _await_idle(10.0)
		var inside: bool = room.contains_point_in_clear_floor(player.global_position, 0.02)
		print("  corner (%5.1f, %5.1f): stopped at (%6.2f, %6.2f) inside=%s" % [
			corner.x, corner.z, player.global_position.x, player.global_position.z, str(inside),
		])
		_expect(inside, "the character left the clear floor at (%.2f, %.2f)" % [
			player.global_position.x, player.global_position.z,
		])
	_expect(absf(player.global_position.y) < 0.05, "the character left the floor plane (y = %.3f)" % player.global_position.y)

	# Path following stops short of a wall by construction. Direct controller
	# movement does not consult the navigation mesh at all, so this is the check
	# that the wall COLLIDER actually holds the body.
	var capsule: CollisionShape3D = player.get_node("CollisionShape3D") as CollisionShape3D
	var radius: float = (capsule.shape as CapsuleShape3D).radius
	for drive: Dictionary in [
		{"name": "east wall", "direction": Vector3(1.0, 0.0, 0.0), "axis": "x", "limit": half.x},
		{"name": "west wall", "direction": Vector3(-1.0, 0.0, 0.0), "axis": "x", "limit": -half.x},
		{"name": "north wall", "direction": Vector3(0.0, 0.0, -1.0), "axis": "z", "limit": -half.y},
		{"name": "south wall", "direction": Vector3(0.0, 0.0, 1.0), "axis": "z", "limit": half.y},
	]:
		await _teleport(Vector3(0.0, 0.0, 0.0))
		await _hold_stick(_stick_for_world_direction(drive["direction"]), 4.0)
		var value: float = player.global_position.x if drive["axis"] == "x" else player.global_position.z
		var limit: float = drive["limit"]
		var gap: float = absf(limit) - absf(value)
		print("  drove into the %-11s for 4 s: %s = %6.2f, wall face at %6.2f, gap %.3f m (capsule radius %.2f)" % [
			drive["name"], drive["axis"], value, limit, gap, radius,
		])
		_expect(absf(value) < absf(limit), "the character passed through the %s" % drive["name"])
		_expect(gap > radius - 0.12 and gap < radius + 0.35,
			"the character stopped %.3f m from the %s, which does not match a %.2f m capsule radius" % [
				gap, drive["name"], radius,
			])
		await _hold_stick(Vector2.ZERO, 0.3)
	room.set_stick_override(null)


func _check_barrier_detour() -> void:
	print("")
	print("--- Barrier: navigation around one obstacle")
	room.room.set_barrier_enabled(true)
	await _settle(6)
	print("  barrier on: %d polygons, %.1f m^2 walkable" % [room.navmesh_polygon_count, room.navmesh_area])

	var start: Vector3 = Vector3(room.room.barrier_position.x, 0.0, room.room.barrier_position.z - 2.6)
	var goal: Vector3 = Vector3(room.room.barrier_position.x, 0.0, room.room.barrier_position.z + 2.6)
	await _teleport(room.resolve_to_navigation(start)["point"])
	var target: Vector3 = room.resolve_to_navigation(goal)["point"]
	player.command_move_to(target, target, false)
	await _settle(4)
	var path_length: float = player.remaining_path_length()
	var straight: float = Vector2(target.x - player.global_position.x, target.z - player.global_position.z).length()
	print("  path %.2f m against a %.2f m straight line (ratio %.2f)" % [path_length, straight, path_length / straight])
	_expect(path_length > straight * 1.15, "the path did not detour around the barrier")

	var elapsed: float = await _await_idle(15.0)
	var distance: float = Vector2(player.global_position.x - target.x, player.global_position.z - target.z).length()
	print("  arrived in %.2f s, %.3f m from the destination" % [elapsed, distance])
	_expect(distance <= player.arrival_tolerance + 0.20, "the character did not reach the far side of the barrier")

	room.room.set_barrier_enabled(false)
	await _settle(6)
	print("  barrier off: %d polygons, %.1f m^2 walkable" % [room.navmesh_polygon_count, room.navmesh_area])


func _check_controller_movement() -> void:
	print("")
	print("--- Controller direct movement and deadzone")
	if not _joypad_injection_works:
		print("  SKIPPED: synthetic joypad events do not reach the Input singleton in this")
		print("           run, so the stick path is exercised through the same public")
		print("           entry point the room calls instead: PrototypePlayer.set_stick_raw().")
	await _stick_case("below deadzone", Vector2(0.12, 0.0), false)
	await _stick_case("just above deadzone", Vector2(0.30, 0.0), true)
	await _stick_case("full deflection", Vector2(1.0, 0.0), true)

	# Analog magnitude must scale speed (specification §9.4).
	var half_speed: float = await _measure_stick_speed(Vector2(0.55, 0.0))
	var full_speed: float = await _measure_stick_speed(Vector2(1.0, 0.0))
	print("  speed at 0.55 deflection %.2f m/s, at full deflection %.2f m/s" % [half_speed, full_speed])
	_expect(full_speed > half_speed + 0.4, "analog magnitude does not scale speed")
	_expect(full_speed > player.max_speed * 0.9, "full deflection reached only %.2f of %.2f m/s" % [full_speed, player.max_speed])

	# Direction: the stick is read in camera space, so "up" moves away from the
	# camera rather than along world -Z.
	await _teleport(Vector3(0.0, 0.0, 0.0))
	var before: Vector3 = player.global_position
	await _hold_stick(Vector2(0.0, -1.0), 0.7)
	var moved: Vector3 = player.global_position - before
	var expected: Vector3 = room.camera_rig.ground_forward()
	var alignment: float = Vector3(moved.x, 0.0, moved.z).normalized().dot(expected)
	print("  stick up moved (%.2f, %.2f); camera-forward alignment %.3f" % [moved.x, moved.z, alignment])
	_expect(alignment > 0.98, "stick up did not move away from the camera (alignment %.3f)" % alignment)
	await _hold_stick(Vector2.ZERO, 0.4)

	# A live stick outranks an older click destination (specification §9.5).
	await _teleport(Vector3(0.0, 0.0, 0.0))
	var target: Vector3 = room.resolve_to_navigation(Vector3(7.0, 0.0, 0.0))["point"]
	player.command_move_to(target, target, false)
	await _settle(10)
	_expect(player.has_destination, "the click destination was not taken in the first place")
	await _hold_stick(Vector2(-1.0, 0.0), 0.3)
	_expect(not player.has_destination, "a live stick did not supersede the older click destination")
	_expect(player.movement_mode == PrototypePlayer.MovementMode.CONTROLLER_DIRECT,
		"movement mode did not change to controller direct")
	await _hold_stick(Vector2.ZERO, 0.3)

	# A held stick that a newer click superseded must not immediately steal the
	# movement back (specification §9.5, "older held input").
	await _teleport(Vector3(0.0, 0.0, 0.0))
	await _hold_stick(Vector2(1.0, 0.0), 0.2)
	_expect(player.movement_mode == PrototypePlayer.MovementMode.CONTROLLER_DIRECT,
		"the held stick was not driving before the click")
	var click: Vector3 = room.resolve_to_navigation(Vector3(-6.0, 0.0, 0.0))["point"]
	player.command_move_to(click, click, false)
	await _settle(30)
	print("  after a click over a still-held stick: mode=%s, stale=%s" % [
		player.movement_mode_name(), str(player.stick_is_stale()),
	])
	_expect(player.stick_is_stale(), "the superseded held stick was not marked stale")
	_expect(player.movement_mode == PrototypePlayer.MovementMode.MOUSE_PATH,
		"a still-held older stick cancelled the newer click command")

	# A substantial direction change makes that same held stick a new intent.
	_apply_stick(Vector2(0.0, 1.0))
	await _settle(4)
	print("  after a %.0f deg stick turn: stale=%s, mode=%s" % [
		90.0, str(player.stick_is_stale()), player.movement_mode_name(),
	])
	_expect(not player.stick_is_stale(), "a 90 degree stick turn was not treated as a new movement intent")
	await _hold_stick(Vector2.ZERO, 0.2)
	room.set_stick_override(null)
	await _settle(4)


func _check_input_family() -> void:
	print("")
	print("--- Input-family tracking (specification §9.2)")
	var tracker: InputFamilyTracker = room.input_family
	tracker.switch_cooldown_seconds = 0.0

	var motion: InputEventMouseMotion = InputEventMouseMotion.new()
	motion.relative = Vector2(40.0, 0.0)
	tracker.observe(motion)
	_expect(tracker.family == InputFamilyTracker.Family.MOUSE_KEYBOARD, "mouse motion did not select the mouse family")

	var drift: InputEventJoypadMotion = InputEventJoypadMotion.new()
	drift.axis = JOY_AXIS_LEFT_X
	drift.axis_value = 0.11
	tracker.observe(drift)
	print("  sub-deadzone stick drift (0.11): family stays %s" % tracker.family_name())
	_expect(tracker.family == InputFamilyTracker.Family.MOUSE_KEYBOARD, "resting-stick drift stole the input family")

	var deflect: InputEventJoypadMotion = InputEventJoypadMotion.new()
	deflect.axis = JOY_AXIS_LEFT_X
	deflect.axis_value = 0.85
	tracker.observe(deflect)
	print("  deliberate stick deflection (0.85): family becomes %s" % tracker.family_name())
	_expect(tracker.family == InputFamilyTracker.Family.CONTROLLER, "a deliberate stick deflection did not select the controller family")

	var tiny: InputEventMouseMotion = InputEventMouseMotion.new()
	tiny.relative = Vector2(1.0, 0.0)
	tracker.observe(tiny)
	print("  one-pixel mouse jitter: family stays %s" % tracker.family_name())
	_expect(tracker.family == InputFamilyTracker.Family.CONTROLLER, "a single jittery pixel stole the input family back")

	var button: InputEventJoypadButton = InputEventJoypadButton.new()
	button.button_index = JOY_BUTTON_A
	button.pressed = true
	tracker.observe(button)
	_expect(tracker.family == InputFamilyTracker.Family.CONTROLLER, "a controller button did not hold the controller family")

	var key: InputEventKey = InputEventKey.new()
	key.physical_keycode = KEY_F3
	key.pressed = true
	tracker.observe(key)
	print("  keyboard press: family becomes %s" % tracker.family_name())
	_expect(tracker.family == InputFamilyTracker.Family.MOUSE_KEYBOARD, "a keyboard press did not select the mouse and keyboard family")

	# The checks above call the tracker directly. This one proves it is actually
	# WIRED to the running input pipeline, by feeding a real event to the engine
	# and letting it arrive through the room's own `_input`.
	tracker.family = InputFamilyTracker.Family.MOUSE_KEYBOARD
	var live_button: InputEventJoypadButton = InputEventJoypadButton.new()
	live_button.device = 0
	live_button.button_index = JOY_BUTTON_A
	live_button.pressed = true
	Input.parse_input_event(live_button)
	await _settle(4)
	print("  a real engine-dispatched controller button reached the tracker: %s" % str(
		tracker.family == InputFamilyTracker.Family.CONTROLLER
	))
	_expect(tracker.family == InputFamilyTracker.Family.CONTROLLER,
		"the tracker is not connected to the running input pipeline; it only responds to direct calls")
	var live_release: InputEventJoypadButton = InputEventJoypadButton.new()
	live_release.device = 0
	live_release.button_index = JOY_BUTTON_A
	live_release.pressed = false
	Input.parse_input_event(live_release)
	await _settle(2)

	# The family change must be cosmetic. Nothing mechanical may move with it.
	await _teleport(Vector3(2.0, 0.0, 2.0))
	var target: Vector3 = room.resolve_to_navigation(Vector3(-4.0, 0.0, 2.0))["point"]
	player.command_move_to(target, target, false)
	await _settle(6)
	var before_state: int = player.action_state
	var before_destination: Vector3 = player.destination
	tracker.observe(deflect)
	tracker.observe(motion)
	await _settle(2)
	print("  after two family switches mid-walk: destination unchanged=%s" % str(before_destination.is_equal_approx(player.destination)))
	_expect(before_destination.is_equal_approx(player.destination), "a family switch changed the destination")
	_expect(before_state == player.action_state, "a family switch changed the action state")
	player.clear_movement_intent("verification cleanup", false)
	await _settle(2)

	# Interruption contract: clearing held intent latches until controls read
	# neutral again.
	player.command_move_to(target, target, false)
	await _settle(4)
	player.clear_movement_intent("simulated focus loss")
	_expect(player.awaiting_neutral, "an interruption did not require neutral input before accepting more")
	_expect(not player.has_destination, "an interruption did not clear the held destination")
	player.command_move_to(target, target, false)
	_expect(not player.has_destination, "a movement command was accepted while awaiting neutral input")
	player.release_neutral_latch()
	player.command_move_to(target, target, false)
	_expect(player.has_destination, "movement was still refused after controls returned to neutral")
	print("  interruption latch: held intent cleared, refused input, then accepted again")
	player.clear_movement_intent("verification cleanup", false)
	await _settle(2)


func _check_no_wasd() -> void:
	print("")
	print("--- WASD absence (specification §9.1: \"The player may not move through WASD bindings\")")
	var forbidden: Array[Key] = [KEY_W, KEY_A, KEY_S, KEY_D]
	var offenders: PackedStringArray = PackedStringArray()
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_"):
			continue
		for event: InputEvent in InputMap.action_get_events(action):
			if event is InputEventKey:
				var key: InputEventKey = event as InputEventKey
				var code: Key = key.physical_keycode if key.physical_keycode != KEY_NONE else key.keycode
				if forbidden.has(code):
					offenders.append("%s -> %s" % [action, OS.get_keycode_string(code)])
	var project_actions: int = 0
	for action: StringName in InputMap.get_actions():
		if not String(action).begins_with("ui_"):
			project_actions += 1
	print("  %d project actions declared, %d WASD movement bindings" % [project_actions, offenders.size()])
	_expect(offenders.is_empty(), "WASD bindings present: %s" % str(offenders))

	for action: StringName in [&"move_vector_left", &"move_vector_right", &"move_vector_forward", &"move_vector_back"]:
		for event: InputEvent in InputMap.action_get_events(action):
			_expect(event is InputEventJoypadMotion, "%s is bound to something other than a joypad axis" % action)


# --- Helpers -----------------------------------------------------------------

func _stick_case(label: String, raw: Vector2, should_move: bool) -> void:
	await _teleport(Vector3(0.0, 0.0, 0.0))
	var before: Vector3 = player.global_position
	await _hold_stick(raw, 0.5)
	var moved: float = Vector2(player.global_position.x - before.x, player.global_position.z - before.z).length()
	print("  %-22s raw %.2f -> magnitude %.2f, moved %.3f m in 0.5 s" % [
		label, raw.length(), player.stick_magnitude, moved,
	])
	if should_move:
		_expect(moved > 0.1, "%s did not move the character" % label)
	else:
		_expect(moved < 0.02, "%s moved the character %.3f m; the deadzone is not holding" % [label, moved])
	await _hold_stick(Vector2.ZERO, 0.3)


func _measure_stick_speed(raw: Vector2) -> float:
	await _teleport(Vector3(-4.0, 0.0, 0.0))
	await _hold_stick(raw, 1.0)
	var speed: float = player.planar_speed()
	await _hold_stick(Vector2.ZERO, 0.3)
	return speed


## Holds a stick reading for a duration. When synthetic joypad events reach the
## Input singleton the real action path is exercised; otherwise the same value
## is pushed through the one public entry point the room itself uses, which is
## reported honestly rather than presented as a full-stack test.
func _hold_stick(raw: Vector2, seconds: float) -> void:
	_apply_stick(raw)
	await _settle(int(seconds / TICK))


## The stick is read in camera space, so a check that wants the character to
## travel along a world axis has to ask for the deflection that produces it.
func _stick_for_world_direction(direction: Vector3) -> Vector2:
	var forward: Vector3 = room.camera_rig.ground_forward()
	var right: Vector3 = room.camera_rig.ground_right()
	return Vector2(direction.dot(right), -direction.dot(forward)).normalized()


## One entry point for a held stick reading, so every controller check exercises
## the same path the room does.
func _apply_stick(raw: Vector2) -> void:
	if _joypad_injection_works:
		_inject_axes(raw)
	else:
		room.set_stick_override(raw)


func _inject_axes(raw: Vector2) -> void:
	for axis: JoyAxis in [JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y]:
		var event: InputEventJoypadMotion = InputEventJoypadMotion.new()
		event.device = 0
		event.axis = axis
		event.axis_value = raw.x if axis == JOY_AXIS_LEFT_X else raw.y
		Input.parse_input_event(event)


func _probe_joypad_injection() -> bool:
	room.set_stick_override(null)
	_inject_axes(Vector2(0.8, 0.0))
	await get_tree().physics_frame
	await get_tree().physics_frame
	var seen: Vector2 = room.read_stick_raw()
	_inject_axes(Vector2.ZERO)
	await get_tree().physics_frame
	var works: bool = seen.length() > 0.5
	print("  synthetic joypad injection reaches the Input singleton: %s" % str(works))
	return works


func _teleport(to: Vector3) -> void:
	_apply_stick(Vector2.ZERO)
	player.clear_movement_intent("verification teleport", false)
	player.global_position = Vector3(to.x, 0.0, to.z)
	player.velocity = Vector3.ZERO
	await _settle(4)


func _await_idle(timeout_seconds: float) -> float:
	var elapsed: float = 0.0
	while elapsed < timeout_seconds:
		await get_tree().physics_frame
		elapsed += TICK
		if not player.has_destination and player.planar_speed() < 0.15:
			return elapsed
	return timeout_seconds


func _settle(frames: int) -> void:
	for i: int in frames:
		await get_tree().physics_frame


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _argument_value(arguments: PackedStringArray, flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


# --- Rendered evidence -------------------------------------------------------

func _capture_evidence() -> void:
	print("")
	print("--- Rendered evidence")
	room.set_debug_visuals(false)
	room.room.set_grid_visible(true)
	await _teleport(Vector3(0.0, 0.0, 2.0))
	await _shoot("gate_b_room_and_scale", 6)

	room.room.set_grid_visible(false)
	# Walking up-screen, so the destination ring stays clear of the lower panels.
	await _teleport(Vector3(2.5, 0.0, 3.5))
	var target: Vector3 = room.resolve_to_navigation(Vector3(-2.0, 0.0, -1.0))["point"]
	player.command_move_to(target, target, false)
	await _settle(24)
	await _shoot("gate_b_click_to_move", 2)
	await _await_idle(12.0)

	# Clicking into a wall from close range, so the dim requested-point mark and
	# the resolved destination ring are both in frame.
	await _teleport(Vector3(0.0, 0.0, -4.0))
	var into_wall: Vector3 = Vector3(0.6, 0.0, -7.6)
	var resolution: Dictionary = room.resolve_to_navigation(into_wall)
	player.command_move_to(resolution["point"], into_wall, true)
	await _settle(8)
	await _shoot("gate_b_unreachable_click", 2)
	await _await_idle(12.0)

	room.room.set_barrier_enabled(true)
	await _settle(8)
	room.set_debug_visuals(true)
	await _teleport(Vector3(-4.5, 0.0, -6.2))
	var far_side: Vector3 = room.resolve_to_navigation(Vector3(-4.5, 0.0, -0.9))["point"]
	player.command_move_to(far_side, far_side, false)
	await _settle(52)
	await _shoot("gate_b_navigation_and_barrier", 2)
	await _await_idle(15.0)
	room.room.set_barrier_enabled(false)
	room.set_debug_visuals(false)
	await _settle(6)

	if room.overlay.has_method("toggle_debug"):
		room.overlay.call("toggle_debug")
	await _teleport(Vector3(2.0, 0.0, -2.0))
	await _hold_stick(Vector2(-0.75, -0.75), 0.6)
	await _shoot("gate_b_controller_direct_and_debug", 2)
	await _hold_stick(Vector2.ZERO, 0.3)


func _shoot(name_stem: String, settle_frames: int) -> void:
	for i: int in settle_frames:
		await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var path: String = "%s/%s.png" % [_shot_dir, name_stem]
	get_viewport().get_texture().get_image().save_png(path)
	print("  screenshot: %s" % path)
