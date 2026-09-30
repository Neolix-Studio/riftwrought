extends Node
## First-MVP Gate 1A — automated verification of the Scale Calibration Hall.
##
## Specification §9 lists eighteen things this must prove. It proves what a
## machine CAN settle: that the hall is the size it says it is, that every gate,
## lane, and ranged mark measures what it claims, that the navigation mesh covers
## the test surfaces and excludes the architecture, that clicks resolve, that the
## character can actually walk through each gate and along each lane and is
## stopped by walls at its own radius, that the accepted locomotion contract is
## unchanged, that every calibration fixture is mechanically inert, that no later
## Gate 1 system leaked in, that nothing is written to disk, and that the visible
## surfaces are actually on screen.
##
## Whether any of it FEELS right at ARPG scale is the project owner's judgement,
## and specification §11 keeps Gate 1A OPEN until they have played it.
##
## Run:  godot --headless --path game res://scenes/first_mvp/calibration/scale_calibration_hall.tscn -- --verify-1a
##       godot --path game --resolution 1280x720 res://.../scale_calibration_hall.tscn -- --verify-1a --shots <dir>

const TICK: float = 1.0 / 60.0

## D-175's accepted Prototype Zero locomotion contract. Gate 1A reuses it and
## must not have drifted it.
const ACCEPTED_MAX_SPEED: float = 5.0
const ACCEPTED_ACCELERATION: float = 30.0
const ACCEPTED_BRAKING: float = 40.0
const ACCEPTED_ARRIVAL_TOLERANCE: float = 0.20
const ACCEPTED_DEADZONE: float = 0.20
const ACCEPTED_SUBSTANTIAL_TURN: float = 35.0
const ACCEPTED_TURN_RATE: float = 720.0

var hall: ScaleCalibrationHall
var arguments: PackedStringArray = PackedStringArray()

var player: CalibrationHallPlayer
var geometry: ScaleCalibrationGeometry
var fixtures: CalibrationFixtures
var data: ScaleCalibrationData

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _shot_dir: String = ""


func _ready() -> void:
	await run()


func run() -> void:
	player = hall.player
	geometry = hall.geometry
	fixtures = hall.fixtures
	data = hall.data
	_shot_dir = _argument_value("--shots")

	print("")
	print("=== First-MVP Gate 1A verification — Scale Calibration Hall ===")
	await _settle(10)

	_check_engine_baseline()
	_check_prototype_zero_is_untouched()
	_report_measurements()
	_check_hall_footprint()
	_check_gate_widths()
	_check_lane_widths()
	_check_ranged_marks()
	_check_telegraph_and_hazard()
	_check_navigation_coverage()
	await _check_click_resolution()
	await _check_gate_traversal()
	await _check_lane_traversal()
	await _check_wall_collision()
	_check_locomotion_contract()
	await _check_controller_and_arbitration()
	await _check_refused_combat_inputs()
	_check_fixture_inertness()
	await _check_runtime_calibration_reset()
	_check_scope()
	_check_no_state_written()
	_check_surfaces_are_on_screen()

	if _shot_dir != "":
		await _capture_evidence()

	print("")
	if _failures.is_empty():
		print("GATE 1A VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("GATE 1A VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		get_tree().quit(1)


# --- 1. Engine and entrypoint baseline ------------------------------------------

func _check_engine_baseline() -> void:
	print("")
	print("--- Engine baseline and entrypoint (specification §9.1 and §9.3)")
	var version: String = "%s.%s" % [
		Engine.get_version_info()["string"], Engine.get_version_info()["status"],
	]
	var version_string: String = str(Engine.get_version_info()["string"])
	print("  engine %s, renderer %s, physics %d Hz" % [
		version_string,
		ProjectSettings.get_setting("rendering/renderer/rendering_method"),
		int(ProjectSettings.get_setting("physics/common/physics_ticks_per_second")),
	])
	_expect(version_string.begins_with("4.7.2"),
		"engine is %s, not the locked 4.7.2 stable baseline" % version_string)
	_expect(
		String(ProjectSettings.get_setting("rendering/renderer/rendering_method")) == "forward_plus",
		"the renderer is no longer Forward+")
	_expect(int(ProjectSettings.get_setting("physics/common/physics_ticks_per_second")) == 60,
		"physics is no longer 60 Hz")

	# The hall is a SEPARATE runnable scene. It must not have become the project.
	var main_scene: String = String(ProjectSettings.get_setting("application/run/main_scene"))
	print("  project main scene: %s" % main_scene)
	_expect(main_scene == "res://scenes/app/prototype_app.tscn",
		"the project main scene is '%s'; Gate 1A must not replace the Prototype App" % main_scene)
	for required: String in [
		"res://scenes/app/prototype_app.tscn",
		"res://scenes/prototype_zero/prototype_zero.tscn",
		"res://scenes/prototype_zero/gate_a_asset_spike.tscn",
	]:
		_expect(ResourceLoader.exists(required), "%s is missing" % required)
	print("  the Prototype App, the laboratory, and the Gate A spike all still exist")


## Gate 1A may not change Prototype Zero's accepted values. Four of the five
## locked records are re-read here and their accepted numbers asserted, so a
## change to any of them fails inside the Gate 1A run as well as in the Gate F
## chain.
##
## REPAIRED UNDER D-200, DELIVERED D-201. Two of these field names were wrong — `release_reach`
## for `reach`, and `preferred_distance` for `preferred_attack_distance`.
## `Resource.get()` answers `null` for a name that is not there, `float(null)`
## THROWS, and a throw inside a check function aborts the WHOLE function: the
## first row ran, the other six silently never did, and the suite still reported
## `PASS (278 checks)`. The names are corrected, and the property is now asserted
## to EXIST before any numeric conversion, so a future typo produces a visible
## failure instead of an invisible abort.
##
## The count moved 278 -> 284 (+6, the six rows that were being skipped) rather
## than 278 -> 285 because ONE row was already running: the rows are evaluated in
## order and row 1, `action_time`, is a real property that reached its `_expect()`
## before row 2 threw. No assertion was added and no asserted value moved.
##
## THIS GUARD DELIBERATELY EMITS ONE ASSERTION PER ROW IN BOTH BRANCHES, so the
## count is exactly the row count and an existence guard cannot drift it.
## `gate_1b_exterior_asset_spike_verification.gd` solves the same problem but does
## NOT have the same shape: it emits an unconditional existence `_expect()` and
## then a second value `_expect()`, so a present row costs it TWO. Do not "align"
## the two by copying that form here — it would take Gate 1A from 284 to 291
## (7 rows x 2 over the 277 other checks) without a single assertion having become
## false, which is exactly the kind of silent count move specification §9 forbids.
func _check_prototype_zero_is_untouched() -> void:
	print("")
	print("--- Prototype Zero's accepted values are untouched (D-195 calibration rule)")
	var quick_strike: Resource = load("res://data/prototype_zero/quick_strike.tres")
	var graveblade: Resource = load("res://data/prototype_zero/graveblade.tres")
	var starter: Resource = load("res://data/prototype_zero/starter_sword.tres")
	var honed: Resource = load("res://data/prototype_zero/honed_sword.tres")
	var accepted: Array[Dictionary] = [
		{"what": "Quick Strike action time", "on": quick_strike, "field": "action_time", "want": 0.80},
		{"what": "Quick Strike reach", "on": quick_strike, "field": "reach", "want": 1.65},
		{"what": "controller soft-target cone", "on": quick_strike, "field": "soft_target_cone_degrees", "want": 65.0},
		{"what": "Graveblade Life", "on": graveblade, "field": "max_life", "want": 300.0},
		{"what": "Graveblade preferred distance", "on": graveblade, "field": "preferred_attack_distance", "want": 1.40},
		{"what": "Training Sword damage", "on": starter, "field": "physical_damage", "want": 100.0},
		{"what": "Honed Sword damage", "on": honed, "field": "physical_damage", "want": 150.0},
	]
	for row: Dictionary in accepted:
		var field: String = String(row["field"])
		var raw: Variant = (row["on"] as Resource).get(field)
		if raw == null:
			# Fail EXPLICITLY, before the numeric conversion that used to throw.
			_expect(false, "%s: the property '%s' does not exist on that resource" % [
				row["what"], field,
			])
			continue
		var got: float = float(raw)
		var want: float = float(row["want"])
		_expect(is_equal_approx(got, want),
			"%s is %.4f, not the accepted %.4f" % [row["what"], got, want])
	print("  %d values re-read: quick_strike, graveblade, starter_sword, and honed_sword still hold their accepted values" % accepted.size())


# --- 2. Measured hall -------------------------------------------------------------

func _report_measurements() -> void:
	var m: Dictionary = hall.measurements()
	var clear: Vector2 = m["clear_metres"]
	var clear_p: Vector2 = m["clear_p"]
	var cf: Vector2 = m["cf_metres"]
	print("")
	print("--- Measured hall (candidate first-MVP values; nothing here is decided)")
	print("  world unit                  1 unit = %.2f m,  P = %.2f m" % [
		float(m["world_unit_metres"]), float(m["player_unit_metres"]),
	])
	print("  clear usable floor          %.2f x %.2f m   = %.1f P x %.1f P   = %.0f m^2" % [
		clear.x, clear.y, clear_p.x, clear_p.y, float(m["clear_area"]),
	])
	print("  §4.1 target                 %.2f x %.2f m   = %.1f P x %.1f P" % [
		data.target_hall_extent_metres().x, data.target_hall_extent_metres().y,
		data.target_hall_length_p, data.target_hall_width_p,
	])
	print("  full floor, walls included  %.2f x %.2f m  (%d x %d modules of %.3f m)" % [
		geometry.floor_extent().x, geometry.floor_extent().y,
		ScaleCalibrationGeometry.TILES_X, ScaleCalibrationGeometry.TILES_Z,
		ScaleCalibrationGeometry.TILE_SIZE,
	])
	print("  player collision            %.2f m diameter, %.2f m tall" % [
		float(m["player_diameter"]), float(m["player_height"]),
	])
	print("  camera                      %.1f m out, pitch %.1f deg, fov %.1f deg, yaw %.1f deg" % [
		float(m["camera_distance"]), float(m["camera_pitch"]),
		float(m["camera_fov"]), float(m["camera_yaw"]),
	])
	print("  CF at this camera           %.2f x %.2f m = %.0f m^2" % [
		cf.x, cf.y, float(m["cf_area"]),
	])
	print("                              measured at the fixed %.3f reference aspect; this window is %.3f" % [
		float(m["reference_aspect"]), float(m["live_aspect"]),
	])
	print("  hall in CF units            %.2f CF" % float(m["clear_in_cf"]))
	print("  movement                    %.2f m/s maximum" % float(m["max_speed"]))
	print("  navigation                  %d polygons, %.1f m^2 walkable" % [
		int(m["navmesh_polygons"]), float(m["navmesh_area"]),
	])


func _check_hall_footprint() -> void:
	print("")
	print("--- §4.1 hall footprint, within the one-floor-module construction tolerance")
	var clear: Vector2 = geometry.clear_extent()
	var target: Vector2 = data.target_hall_extent_metres()
	var module: float = data.floor_module_metres
	print("  measured %.2f x %.2f m against a target of %.2f x %.2f m; deviation %.2f m and %.2f m of a %.2f m module" % [
		clear.x, clear.y, target.x, target.y,
		absf(clear.x - target.x), absf(clear.y - target.y), module,
	])
	_expect(absf(clear.x - target.x) <= module,
		"the hall's long axis is %.2f m from its target, more than one %.2f m module" % [
			absf(clear.x - target.x), module,
		])
	_expect(absf(clear.y - target.y) <= module,
		"the hall's short axis is %.2f m from its target, more than one %.2f m module" % [
			absf(clear.y - target.y), module,
		])
	# Construction integrity: the clear floor must be the tile count minus the two
	# one-metre wall footprints, exactly. A drift here means a wall moved.
	var expected: Vector2 = geometry.floor_extent() - Vector2(2.0, 2.0) * ScaleCalibrationGeometry.WALL_DEPTH
	_expect(
		absf(clear.x - expected.x) < 0.001 and absf(clear.y - expected.y) < 0.001,
		"the measured clear floor %.3f x %.3f does not match the built walls %.3f x %.3f" % [
			clear.x, clear.y, expected.x, expected.y,
		])

	# §4.1: "The hall must require meaningful camera travel. It must not reveal
	# the entire usable floor as one small-room tableau at the default camera."
	var m: Dictionary = hall.measurements()
	var cf: Vector2 = m["cf_metres"]
	print("  the camera shows %.1f x %.1f m at once; the hall is %.2f CF by area" % [
		cf.x, cf.y, float(m["clear_in_cf"]),
	])
	_expect(float(m["clear_in_cf"]) >= 2.0,
		"the hall is only %.2f CF; it would read as one small-room tableau" % float(m["clear_in_cf"]))
	# CF is a PROJECT unit at the fixed reference aspect, so this number must be
	# the same headless, at 1280 x 720, and fullscreen. D-175 measured CF as
	# 27.982 x 20.980 m at the default camera; if this run disagrees, CF has
	# quietly become a function of the window instead of of the camera.
	_expect(absf(cf.x - 27.982) < 0.05 and absf(cf.y - 20.980) < 0.05,
		"CF measured %.3f x %.3f m, not the D-175 27.982 x 20.980 m" % [cf.x, cf.y])
	_expect(clear.x > cf.x and clear.y > cf.y,
		"the default camera covers the whole hall in one view (%.1f x %.1f vs %.1f x %.1f)" % [
			cf.x, cf.y, clear.x, clear.y,
		])


func _check_gate_widths() -> void:
	print("")
	print("--- §4.2 doorway comparisons, measured off the built collision boxes")
	var tolerance: float = data.geometry_tolerance_metres
	for gate: Dictionary in geometry.gate_records():
		var measured: float = float(gate["measured_metres"])
		var target: float = float(gate["target_metres"])
		print("  %-19s measured %6.3f m = %5.2f P   target %6.3f m = %4.1f P   (%s)" % [
			gate["name"], measured, float(gate["measured_p"]), target,
			float(gate["target_p"]), gate["meaning"],
		])
		_expect(absf(measured - target) <= tolerance,
			"the %s measures %.3f m, not %.3f m within %.3f m" % [
				gate["name"], measured, target, tolerance,
			])
	print("  the 4 P stress gate exists as a deliberate lower-bound comparison, not as an approved doorway")


func _check_lane_widths() -> void:
	print("")
	print("--- §4.2 combat-lane comparisons, measured wall face to rail face")
	var tolerance: float = data.geometry_tolerance_metres
	for lane: Dictionary in geometry.lane_records():
		var measured: float = float(lane["measured_metres"])
		var target: float = float(lane["target_metres"])
		print("  %-21s measured %6.3f m = %5.2f P   target %6.3f m = %4.1f P" % [
			lane["name"], measured, float(lane["measured_p"]), target, float(lane["target_p"]),
		])
		_expect(absf(measured - target) <= tolerance,
			"the %s measures %.3f m, not %.3f m within %.3f m" % [
				lane["name"], measured, target, tolerance,
			])
	var lanes: Array[Dictionary] = geometry.lane_records()
	_expect(float(lanes[1]["measured_metres"]) > float(lanes[0]["measured_metres"]) + 5.0,
		"the broad formation lane is not meaningfully broader than the close ordinary lane")


func _check_ranged_marks() -> void:
	print("")
	print("--- §6.2 ranged reading gallery, measured from the firing origin")
	var tolerance: float = data.geometry_tolerance_metres
	print("  firing origin at (%.2f, %.2f)" % [hall.fixtures.firing_origin().x, hall.fixtures.firing_origin().z])
	for mark: Dictionary in fixtures.ranged_records():
		var measured: float = float(mark["measured_metres"])
		var target: float = float(mark["target_metres"])
		print("    %5.1f m mark   measured %.4f m" % [target, measured])
		_expect(absf(measured - target) <= tolerance,
			"the %.1f m mark measures %.4f m" % [target, measured])
	_expect(fixtures.ranged_records().size() == 3,
		"specification §6.2 requires exactly three ground-distance marks")


func _check_telegraph_and_hazard() -> void:
	print("")
	print("--- §6.3 telegraph and hazard court — test inputs, and the escape space they leave")
	print("  Mauler commitment footprint  %.2f m radius, %.0f deg  (PROVISIONAL)" % [
		fixtures.current_arc_radius(), data.mauler_arc_degrees,
	])
	print("  Cinder Seal hazard footprint %.2f m radius              (PROVISIONAL)" % [
		fixtures.current_seal_radius(),
	])
	var wide_enough: int = 0
	for escape: Dictionary in fixtures.escape_records():
		var clear: float = float(escape["clear_metres"])
		print("    escape %-5s %.2f m = %.2f P" % [
			escape["name"], clear, data.p_for_metres(clear),
		])
		if clear >= 2.0:
			wide_enough += 1
	# §6.3: "The hazard test must leave at least two visibly distinct ways out."
	_expect(wide_enough >= 2,
		"only %d escape routes from the Cinder Seal are at least 2 m wide" % wide_enough)
	_expect(fixtures.current_seal_radius() > 0.0 and fixtures.current_arc_radius() > 0.0,
		"a telegraph or hazard footprint has no size")


# --- 3. Navigation ------------------------------------------------------------------

func _check_navigation_coverage() -> void:
	print("")
	print("--- §9.11 the navigation mesh covers the test surfaces and excludes the architecture")
	_expect(hall.navmesh_polygon_count > 0, "the navigation mesh has no polygons")
	# The clear floor is 1500 m^2; Recast erodes by the 0.40 m agent radius and
	# removes the partitions and the three occluders, so a walkable area far above
	# or far below this band means the bake changed shape.
	print("  %d polygons, %.1f m^2 walkable of %.0f m^2 clear floor" % [
		hall.navmesh_polygon_count, hall.navmesh_area, geometry.clear_area(),
	])
	_expect(hall.navmesh_area > geometry.clear_area() * 0.72
			and hall.navmesh_area < geometry.clear_area() * 0.97,
		"the walkable area is %.1f m^2 against a %.0f m^2 clear floor" % [
			hall.navmesh_area, geometry.clear_area(),
		])

	var walkable: Array[Dictionary] = []
	for gate: Dictionary in geometry.gate_records():
		walkable.append({"what": "%s centre" % gate["name"], "at": gate["centre"]})
	for lane: Dictionary in geometry.lane_records():
		walkable.append({"what": "%s centre" % lane["name"], "at": lane["centre"]})
	for mark: Dictionary in fixtures.ranged_records():
		walkable.append({"what": "%.0f m ranged mark" % float(mark["target_metres"]), "at": mark["at"]})
	walkable.append({"what": "entrance threshold", "at": geometry.entrance_point()})
	walkable.append({"what": "exit threshold", "at": geometry.exit_point()})
	walkable.append({"what": "player spawn", "at": geometry.player_spawn()})
	walkable.append({"what": "surround group stand", "at": Vector3(
		ScaleCalibrationGeometry.SURROUND_CENTRE.x, 0.0, ScaleCalibrationGeometry.SURROUND_CENTRE.y
	)})
	walkable.append({"what": "telegraph court", "at": Vector3(
		ScaleCalibrationGeometry.MAULER_ARC_AT.x, 0.0,
		ScaleCalibrationGeometry.MAULER_ARC_AT.y - 5.0
	)})
	walkable.append({"what": "firing origin", "at": fixtures.firing_origin()})
	for row: Dictionary in walkable:
		_expect(hall.point_is_navigable(row["at"]),
			"%s at (%.2f, %.2f) is not on the navigation mesh" % [
				row["what"], Vector3(row["at"]).x, Vector3(row["at"]).z,
			])
	print("  %d intended walkable surfaces are all on the mesh" % walkable.size())

	var blocked: Array[Dictionary] = [
		{"what": "inside partition one", "at": Vector3(ScaleCalibrationGeometry.PARTITION_ONE_X, 0.0, -12.0)},
		{"what": "inside partition two", "at": Vector3(ScaleCalibrationGeometry.PARTITION_TWO_X, 0.0, -12.0)},
		{"what": "inside the pillar", "at": Vector3(
			ScaleCalibrationGeometry.PILLAR_AT.x, 0.0, ScaleCalibrationGeometry.PILLAR_AT.y
		)},
		{"what": "inside the wall section", "at": Vector3(
			ScaleCalibrationGeometry.WALL_SECTION_AT.x, 0.0, ScaleCalibrationGeometry.WALL_SECTION_AT.y
		)},
		{"what": "inside the half-wall", "at": Vector3(
			ScaleCalibrationGeometry.HALF_WALL_AT.x, 0.0, ScaleCalibrationGeometry.HALF_WALL_AT.y
		)},
		{"what": "inside the north wall", "at": Vector3(0.0, 0.0, -geometry.clear_half_extent().y - 0.5)},
		{"what": "outside the hall entirely", "at": Vector3(70.0, 0.0, 0.0)},
		{"what": "on top of the half-wall", "at": Vector3(
			ScaleCalibrationGeometry.HALF_WALL_AT.x,
			ScaleCalibrationGeometry.HALF_WALL_SIZE.y,
			ScaleCalibrationGeometry.HALF_WALL_AT.y
		)},
	]
	for row: Dictionary in blocked:
		_expect(not hall.point_is_navigable(row["at"]),
			"%s is walkable; the bake includes geometry it should exclude" % row["what"])
	print("  %d walls, occluders, ledges, and out-of-room points are all excluded" % blocked.size())

	# §5: "one broad rectangular developer space with a clear entrance-to-exit
	# spine". The spine is the straight z = -5.4 line through the 4 P stress gate
	# and the 10 P broad connector; it is only a spine if it is walkable for its
	# whole length, which is asked here metre by metre rather than assumed.
	var half: Vector2 = geometry.clear_half_extent()
	var spine_blocked: PackedStringArray = PackedStringArray()
	var samples: int = 0
	var x: float = -half.x + 1.0
	while x <= half.x - 1.0 + 0.001:
		samples += 1
		if not hall.point_is_navigable(Vector3(x, 0.0, geometry.spine_z())):
			spine_blocked.append("%.1f" % x)
		x += 1.0
	print("  the entrance-to-exit spine at z = %.1f is walkable at %d of %d sampled metres" % [
		geometry.spine_z(), samples - spine_blocked.size(), samples,
	])
	_expect(spine_blocked.is_empty(),
		"the spine is blocked at x = %s" % ", ".join(spine_blocked))


# --- 4. Clicks ------------------------------------------------------------------------

func _check_click_resolution() -> void:
	print("")
	print("--- §9.12 clicks from representative screen positions resolve to intended ground")
	await _teleport(Vector3(0.0, 0.0, geometry.spine_z()))
	var viewport: Vector2 = get_viewport().get_visible_rect().size
	var screens: Array[Dictionary] = [
		{"what": "screen centre", "at": viewport * 0.5},
		{"what": "upper left quadrant", "at": viewport * Vector2(0.28, 0.30)},
		{"what": "lower right quadrant", "at": viewport * Vector2(0.72, 0.70)},
		{"what": "just below centre", "at": viewport * Vector2(0.50, 0.66)},
	]
	for row: Dictionary in screens:
		var cursor: Dictionary = hall.ground_point_under_cursor(row["at"])
		_expect(bool(cursor.get("valid", false)),
			"%s produced no ground point at all" % row["what"])
		if not bool(cursor.get("valid", false)):
			continue
		var requested: Vector3 = cursor["point"]
		var resolution: Dictionary = hall.resolve_to_navigation(requested)
		var resolved: Vector3 = resolution["point"]
		print("  %-22s world (%7.2f, %7.2f) -> navigable (%7.2f, %7.2f), %s" % [
			row["what"], requested.x, requested.z, resolved.x, resolved.z,
			"adjusted" if bool(resolution["adjusted"]) else "accepted",
		])
		_expect(geometry.contains_point(resolved, 0.01),
			"%s resolved outside the hall" % row["what"])
		_expect(hall.point_is_navigable(resolved, 0.05),
			"%s resolved to a point that is not on the navigation mesh" % row["what"])

	# An unreachable point must resolve safely rather than sending the character
	# into a wall (specification §9.3, reused unchanged).
	var unreachable: Array[Dictionary] = [
		{"what": "inside the north wall", "at": Vector3(0.0, 0.0, -18.0)},
		{"what": "inside the pillar", "at": Vector3(
			ScaleCalibrationGeometry.PILLAR_AT.x, 0.0, ScaleCalibrationGeometry.PILLAR_AT.y
		)},
		{"what": "far outside the hall", "at": Vector3(120.0, 0.0, -90.0)},
	]
	for row: Dictionary in unreachable:
		var resolution: Dictionary = hall.resolve_to_navigation(row["at"])
		var resolved: Vector3 = resolution["point"]
		print("  %-22s (%7.2f, %7.2f) -> (%7.2f, %7.2f), moved %.2f m" % [
			row["what"], Vector3(row["at"]).x, Vector3(row["at"]).z,
			resolved.x, resolved.z, float(resolution["offset"]),
		])
		_expect(bool(resolution["adjusted"]),
			"%s was not reported as adjusted" % row["what"])
		_expect(geometry.contains_point(resolved, 0.01) and hall.point_is_navigable(resolved, 0.05),
			"%s did not resolve onto walkable floor inside the hall" % row["what"])

	# §7: developer UI absorbs pointer input and cannot issue movement commands.
	var before: int = hall.accepted_commands + hall.adjusted_commands
	var absorbed_before: int = hall.ui_clicks_absorbed
	var leak: Control = hall.overlay.get_node("InterfaceLeakTest") as Control
	_expect(leak != null, "the interface leak-test panel is missing from the overlay")
	if leak != null:
		var inside: Vector2 = leak.get_global_rect().get_center()
		# The hover has to be established by a MOTION event: `gui_get_hovered_control()`
		# is updated by pointer movement, not by a button press, so warping the
		# mouse alone leaves the hall's `_pointer_over_ui()` answering "no" and the
		# test proves nothing.
		var motion: InputEventMouseMotion = InputEventMouseMotion.new()
		motion.position = inside
		motion.global_position = inside
		get_viewport().push_input(motion, true)
		await _settle(2)
		_expect(get_viewport().gui_get_hovered_control() != null,
			"the pointer is over the overlay panel and the viewport reports no hovered control")
		var click: InputEventMouseButton = InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.pressed = true
		click.position = inside
		click.global_position = inside
		get_viewport().push_input(click, true)
		await _settle(4)
		var release: InputEventMouseButton = InputEventMouseButton.new()
		release.button_index = MOUSE_BUTTON_LEFT
		release.pressed = false
		release.position = inside
		release.global_position = inside
		get_viewport().push_input(release, true)
		await _settle(4)
		print("  clicking the overlay: %d commands issued, %d clicks absorbed" % [
			hall.accepted_commands + hall.adjusted_commands - before,
			hall.ui_clicks_absorbed - absorbed_before,
		])
		_expect(hall.accepted_commands + hall.adjusted_commands == before,
			"clicking the developer overlay leaked a ground movement command")
		# The structural guarantee behind it, asserted as well as exercised: the
		# root ignores the pointer so it cannot swallow the whole play field, and
		# no panel passes a click through to the world.
		var passing: PackedStringArray = PackedStringArray()
		var stopping: int = 0
		for child: Node in hall.overlay.get_children():
			var control: Control = child as Control
			if control == null:
				continue
			if control.mouse_filter == Control.MOUSE_FILTER_STOP:
				stopping += 1
			elif control.mouse_filter == Control.MOUSE_FILTER_PASS:
				passing.append(String(control.name))
		_expect((hall.overlay as Control).mouse_filter == Control.MOUSE_FILTER_IGNORE,
			"the overlay root absorbs clicks over the whole play field")
		_expect(passing.is_empty(),
			"overlay panels %s pass clicks through to the world" % str(passing))
		_expect(stopping > 0, "no overlay panel absorbs clicks, so the leak test proves nothing")
		# Move the pointer back off the interface so nothing later inherits the hover.
		var away: InputEventMouseMotion = InputEventMouseMotion.new()
		away.position = get_viewport().get_visible_rect().size * 0.5
		away.global_position = away.position
		get_viewport().push_input(away, true)
		await _settle(2)


# --- 5. Traversal and collision ---------------------------------------------------------

func _check_gate_traversal() -> void:
	print("")
	print("--- §9.13 the player traverses every gate, through THAT gate")
	for gate: Dictionary in geometry.gate_records():
		var at_x: float = Vector3(gate["centre"]).x
		var centre_z: float = Vector3(gate["centre"]).z
		await _teleport(Vector3(at_x - 3.0, 0.0, centre_z))
		var goal: Vector3 = hall.resolve_to_navigation(Vector3(at_x + 3.0, 0.0, centre_z))["point"]
		player.command_move_to(goal, goal, false)

		var crossing_z: float = NAN
		var previous_x: float = player.global_position.x
		var elapsed: float = 0.0
		while elapsed < 12.0:
			await get_tree().physics_frame
			elapsed += TICK
			var now_x: float = player.global_position.x
			if is_nan(crossing_z) and previous_x < at_x and now_x >= at_x:
				crossing_z = player.global_position.z
			previous_x = now_x
			if not player.has_destination and player.planar_speed() < 0.15:
				break
		var span: Vector2 = gate["span"]
		var arrived: float = player.global_position.distance_to(goal)
		print("  %-19s crossed the partition at z = %7.3f (gap %.2f .. %.2f), %.2f m from the goal after %.2f s" % [
			gate["name"], crossing_z, span.x, span.y, arrived, elapsed,
		])
		_expect(not is_nan(crossing_z),
			"the player never crossed the %s partition" % gate["name"])
		_expect(not is_nan(crossing_z) and crossing_z > span.x and crossing_z < span.y,
			"the player crossed at z = %.3f, outside the %s gap" % [crossing_z, gate["name"]])
		_expect(arrived < 0.5, "the player stopped %.2f m from the far side of the %s" % [
			arrived, gate["name"],
		])


func _check_lane_traversal() -> void:
	print("")
	print("--- §9.13 the player traverses both combat lanes end to end, inside the lane")
	for lane: Dictionary in geometry.lane_records():
		var centre_z: float = Vector3(lane["centre"]).z
		var from: Vector3 = Vector3(ScaleCalibrationGeometry.LANE_FROM_X + 0.8, 0.0, centre_z)
		var to: Vector3 = Vector3(ScaleCalibrationGeometry.LANE_TO_X - 0.8, 0.0, centre_z)
		await _teleport(from)
		var goal: Vector3 = hall.resolve_to_navigation(to)["point"]
		player.command_move_to(goal, goal, false)
		var low: float = minf(float(lane["from_z"]), float(lane["to_z"]))
		var high: float = maxf(float(lane["from_z"]), float(lane["to_z"]))
		var strayed: bool = false
		var elapsed: float = 0.0
		while elapsed < 15.0:
			await get_tree().physics_frame
			elapsed += TICK
			var z: float = player.global_position.z
			if z < low - 0.5 or z > high + 0.5:
				strayed = true
			if not player.has_destination and player.planar_speed() < 0.15:
				break
		var arrived: float = player.global_position.distance_to(goal)
		print("  %-21s walked %.1f m in %.2f s, %.2f m from the goal, stayed inside the lane: %s" % [
			lane["name"], from.distance_to(goal), elapsed, arrived, str(not strayed),
		])
		_expect(arrived < 0.5, "the player stopped %.2f m short in the %s" % [arrived, lane["name"]])
		_expect(not strayed, "the walk along the %s left the lane" % lane["name"])


func _check_wall_collision() -> void:
	print("")
	print("--- §9.13 collision stops the body at its own measured radius")
	var radius: float = player.collision_diameter() * 0.5
	var wall_face: float = -geometry.clear_half_extent().y
	await _teleport(Vector3(0.0, 0.0, wall_face + 4.0))
	# The stick is read in the camera's ground basis, so the raw vector that
	# pushes toward world -Z is derived from that basis rather than guessed.
	var wanted: Vector3 = Vector3(0.0, 0.0, -1.0)
	var raw: Vector2 = Vector2(
		wanted.dot(hall.camera_rig.ground_right()),
		-wanted.dot(hall.camera_rig.ground_forward())
	)
	hall.set_stick_override(raw)
	await _settle(200)
	var stopped: float = player.global_position.z
	hall.set_stick_override(null)
	await _settle(6)
	print("  pushed into the north wall for 200 frames: body centre stopped at z = %.4f, wall face %.2f, radius %.2f" % [
		stopped, wall_face, radius,
	])
	_expect(absf(stopped - (wall_face + radius)) < 0.08,
		"the body stopped %.4f m from the wall face, not its %.2f m radius" % [
			stopped - wall_face, radius,
		])
	player.clear_movement_intent("verification cleanup", false)
	await _settle(4)


# --- 6. The accepted locomotion contract -----------------------------------------------

func _check_locomotion_contract() -> void:
	print("")
	print("--- §9.14 the accepted Prototype Zero locomotion contract, reused rather than cloned")
	var expectations: Array[Dictionary] = [
		{"what": "maximum speed", "got": player.max_speed, "want": ACCEPTED_MAX_SPEED, "unit": "m/s"},
		{"what": "acceleration", "got": player.acceleration, "want": ACCEPTED_ACCELERATION, "unit": "m/s^2"},
		{"what": "braking", "got": player.braking, "want": ACCEPTED_BRAKING, "unit": "m/s^2"},
		{"what": "arrival tolerance", "got": player.arrival_tolerance, "want": ACCEPTED_ARRIVAL_TOLERANCE, "unit": "m"},
		{"what": "stick deadzone", "got": player.stick_deadzone, "want": ACCEPTED_DEADZONE, "unit": ""},
		{"what": "substantial turn", "got": player.substantial_turn_degrees, "want": ACCEPTED_SUBSTANTIAL_TURN, "unit": "deg"},
		{"what": "turn rate", "got": player.turn_rate_degrees, "want": ACCEPTED_TURN_RATE, "unit": "deg/s"},
		{"what": "player collision diameter P", "got": player.collision_diameter(), "want": 0.80, "unit": "m"},
		{"what": "player collision height", "got": player.collision_height(), "want": 1.80, "unit": "m"},
		{"what": "camera distance", "got": hall.camera_rig.distance_metres, "want": 19.0, "unit": "m"},
		{"what": "camera pitch", "got": hall.camera_rig.pitch_degrees, "want": 55.0, "unit": "deg"},
		{"what": "camera field of view", "got": hall.camera_rig.fov_degrees, "want": 45.0, "unit": "deg"},
	]
	for row: Dictionary in expectations:
		var got: float = float(row["got"])
		var want: float = float(row["want"])
		print("    %-28s %8.3f %s" % [row["what"], got, row["unit"]])
		_expect(absf(got - want) < 0.001,
			"%s is %.4f, not the accepted %.4f" % [row["what"], got, want])

	# It is the SAME implementation, not a second one that happens to agree. Both
	# player scripts must delegate to the shared kernel, and neither may carry its
	# own copy of the deadzone or acceleration arithmetic.
	var shared: String = _code_only(FileAccess.get_file_as_string(
		"res://scripts/movement/prototype_locomotion.gd"))
	_expect(shared.contains("class_name PrototypeLocomotion"),
		"the shared locomotion kernel is missing")
	for path: String in [
		"res://scripts/actors/prototype_player.gd",
		"res://scripts/first_mvp/calibration/calibration_hall_player.gd",
	]:
		var source: String = _code_only(FileAccess.get_file_as_string(path))
		_expect(source.contains("PrototypeLocomotion"),
			"%s does not use the shared locomotion kernel" % path.get_file())
		_expect(not source.contains("move_toward(desired"),
			"%s carries its own copy of the acceleration model" % path.get_file())
	for path: String in [
		"res://scripts/prototype_zero/prototype_zero.gd",
		"res://scripts/first_mvp/calibration/scale_calibration_hall.gd",
	]:
		var source: String = _code_only(FileAccess.get_file_as_string(path))
		_expect(source.contains("PrototypeGroundPointer"),
			"%s does not use the shared cursor-to-navigation resolution" % path.get_file())
		_expect(source.contains("PrototypeMouseHold"),
			"%s does not use the shared click-and-hold timer" % path.get_file())
	print("  both players and both scenes go through the one shared movement implementation")

	# No WASD, still (specification §9.1). ONE aggregate assertion, deliberately:
	# Prototype Zero's own suites already assert this per action, and Gate 1A must
	# not inflate a locked count by walking the same list again.
	var offenders: PackedStringArray = PackedStringArray()
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_"):
			continue
		for event: InputEvent in InputMap.action_get_events(action):
			var key: InputEventKey = event as InputEventKey
			if key == null:
				continue
			if [KEY_W, KEY_A, KEY_S, KEY_D].has(key.physical_keycode):
				offenders.append("%s -> %s" % [action, OS.get_keycode_string(key.physical_keycode)])
	print("  WASD movement bindings: %d" % offenders.size())
	_expect(offenders.is_empty(), "WASD bindings present: %s" % str(offenders))
	# Gate 1A declared no new input action, which is what keeps the locked Gate B,
	# E, and F counts from moving.
	for hall_only: StringName in [&"toggle_role_fixtures", &"toggle_telegraph_markers", &"gate_1a"]:
		_expect(not InputMap.has_action(hall_only),
			"Gate 1A declared the new input action '%s'; that would move three locked counts" % hall_only)


func _check_controller_and_arbitration() -> void:
	print("")
	print("--- §9.14 deadzone, camera-relative direction, and held-input arbitration")
	await _teleport(Vector3(0.0, 0.0, geometry.spine_z()))

	# Below the deadzone nothing moves.
	hall.set_stick_override(Vector2(0.0, -0.15))
	await _settle(40)
	var drift: float = player.global_position.distance_to(Vector3(0.0, 0.0, geometry.spine_z()))
	hall.set_stick_override(null)
	await _settle(6)
	print("  a 0.15 deflection below the 0.20 deadzone moved the body %.4f m in 40 frames" % drift)
	_expect(drift < 0.02, "sub-deadzone stick noise moved the character %.4f m" % drift)

	# Above it, the character moves along the CAMERA's ground forward.
	await _teleport(Vector3(0.0, 0.0, geometry.spine_z()))
	var start: Vector3 = player.global_position
	hall.set_stick_override(Vector2(0.0, -0.9))
	await _settle(45)
	var travelled: Vector3 = player.global_position - start
	hall.set_stick_override(null)
	await _settle(8)
	var forward: Vector3 = hall.camera_rig.ground_forward()
	var alignment: float = Vector3(travelled.x, 0.0, travelled.z).normalized().dot(forward)
	print("  pushing the stick away from the player moved %.2f m at %.4f alignment with the camera's ground forward" % [
		travelled.length(), alignment,
	])
	_expect(travelled.length() > 1.5, "a full stick deflection moved only %.2f m" % travelled.length())
	_expect(alignment > 0.995,
		"controller movement is not camera-relative: alignment %.4f" % alignment)

	# A fresh click outranks a stick that is merely still held; the held stick
	# becomes stale and only commands again after a substantial turn.
	hall.set_stick_override(Vector2(0.0, -0.9))
	await _settle(6)
	var goal: Vector3 = hall.resolve_to_navigation(
		player.global_position + Vector3(3.0, 0.0, 0.0)
	)["point"]
	player.command_move_to(goal, goal, false)
	await _settle(4)
	print("  after a click over a held stick: stale = %s, mode = %s" % [
		str(player.stick_is_stale()), player.movement_mode_name(),
	])
	_expect(player.stick_is_stale(), "the superseded held stick was not marked stale")
	_expect(player.movement_mode_name() == "mouse path",
		"the click did not take over from the held stick")
	# A 90-degree turn of the same held stick is a NEW intent.
	hall.set_stick_override(Vector2(0.9, 0.0))
	await _settle(4)
	print("  after turning that held stick 90 degrees: stale = %s" % str(player.stick_is_stale()))
	_expect(not player.stick_is_stale(),
		"a 90 degree stick turn was not treated as a new movement intent")
	hall.set_stick_override(null)
	player.clear_movement_intent("verification cleanup", false)
	await _settle(6)


func _check_refused_combat_inputs() -> void:
	print("")
	print("--- §7 right-click and combat inputs cannot begin an action in this scene")
	await _teleport(Vector3(0.0, 0.0, geometry.spine_z()))
	var before_position: Vector3 = player.global_position
	var before_refused: int = hall.refused_action_inputs
	for action: StringName in [&"quick_strike", &"attack_in_place", &"interact"]:
		# A synthetic InputEventAction, not `Input.action_press()`: the latter sets
		# the action's STATE without ever producing an event, so `_unhandled_input`
		# is never reached and the refusal it is supposed to test never runs.
		var press: InputEventAction = InputEventAction.new()
		press.action = action
		press.pressed = true
		get_viewport().push_input(press)
		await _settle(3)
		var release: InputEventAction = InputEventAction.new()
		release.action = action
		release.pressed = false
		get_viewport().push_input(release)
		await _settle(3)
	var moved: float = player.global_position.distance_to(before_position)
	print("  pressed quick_strike, attack_in_place, and interact: %d refusals recorded, body moved %.4f m" % [
		hall.refused_action_inputs - before_refused, moved,
	])
	_expect(hall.refused_action_inputs - before_refused == 3,
		"the hall refused %d of 3 combat inputs" % (hall.refused_action_inputs - before_refused))
	_expect(moved < 0.02, "a combat input moved the character %.4f m" % moved)


# --- 7. Fixture inertness -------------------------------------------------------------

func _check_fixture_inertness() -> void:
	print("")
	print("--- §9.15 every enemy, projectile, telegraph, and hazard fixture is mechanically inert")
	var colliders: PackedStringArray = PackedStringArray()
	_collect_collision_objects(fixtures, colliders)
	print("  fixture subtree: %d nodes, %d collision objects" % [
		_count_nodes(fixtures), colliders.size(),
	])
	_expect(colliders.is_empty(),
		"calibration fixtures carry collision objects: %s" % ", ".join(colliders))

	# Nothing under the fixtures may be a body, an area, or a targetable.
	for type_name: String in ["CollisionObject3D", "Area3D", "PhysicsBody3D", "CharacterBody3D"]:
		_expect(_count_nodes_of_type(fixtures, type_name) == 0,
			"a fixture is a %s" % type_name)

	var source: String = _code_only(FileAccess.get_file_as_string(
		"res://scripts/first_mvp/calibration/calibration_fixtures.gd"))
	for forbidden: String in [
		"DamageEvent", "PrototypeTargetable", "AttackCoordinator", "receive_damage",
		"take_damage", "max_life", "PrototypeGraveblade", "QuickStrikeAction",
	]:
		_expect(not source.contains(forbidden),
			"the fixtures reach '%s'; Gate 1A fixtures are inert" % forbidden)
	for forbidden: String in ["life", "damage", "attack", "target", "ailment", "projectile_hit"]:
		_expect(not (forbidden in fixtures),
			"the fixture node has a '%s' member; that is production enemy behaviour" % forbidden)

	# Each placeholder visibly says its size is not a locked value.
	var labels: int = _count_nodes_of_type(fixtures, "Label3D")
	var provisional: int = 0
	for label: Node in _nodes_of_type(fixtures, "Label3D"):
		if String((label as Label3D).text).to_lower().contains("not a locked gameplay value") \
			or String((label as Label3D).text).to_lower().contains("test inputs"):
			provisional += 1
	print("  %d fixture labels on screen, %d of them state that the size is not a locked value" % [
		labels, provisional,
	])
	_expect(provisional >= 4,
		"only %d fixture labels declare their size provisional" % provisional)

	# The toggles work and do not disturb anything mechanical.
	fixtures.set_role_fixtures_visible(false)
	_expect(not fixtures.role_fixtures_visible, "F1 did not hide the role fixtures")
	fixtures.set_role_fixtures_visible(true)
	_expect(fixtures.role_fixtures_visible, "F1 did not restore the role fixtures")
	var seen: PackedStringArray = PackedStringArray()
	for i: int in 4:
		seen.append(fixtures.cycle_markers())
	print("  the telegraph and hazard cycle visits: %s" % ", ".join(seen))
	_expect(seen.size() == 4 and seen[3] == "candidate",
		"the telegraph and hazard cycle does not return to the candidate preset")
	_expect(seen.has("hidden"), "the telegraph and hazard court cannot be hidden")


# --- 8. Runtime calibration ------------------------------------------------------------

func _check_runtime_calibration_reset() -> void:
	print("")
	print("--- §9.6 runtime calibration is session-only and resets cleanly")
	_expect(hall.runtime_calibration_is_baseline(),
		"the hall did not start at the Gate 1A baseline")
	hall.camera_rig.adjust_distance(4.0)
	hall.camera_rig.adjust_pitch(-5.0)
	hall.camera_rig.adjust_fov(3.0)
	player.max_speed = 7.4
	geometry.set_grid_visible(true)
	fixtures.cycle_markers()
	fixtures.set_role_fixtures_visible(false)
	await _settle(3)
	print("  changed: camera %.1f m / %.1f deg / %.1f deg, speed %.2f m/s, grid %s, markers '%s'" % [
		hall.camera_rig.distance_metres, hall.camera_rig.pitch_degrees,
		hall.camera_rig.fov_degrees, player.max_speed,
		str(geometry.grid_visible), fixtures.marker_state_name(),
	])
	_expect(not hall.runtime_calibration_is_baseline(),
		"changing the calibration did not leave the baseline")
	hall.reset_calibration()
	await _settle(3)
	print("  after reset: camera %.1f m / %.1f deg / %.1f deg, speed %.2f m/s, grid %s, markers '%s'" % [
		hall.camera_rig.distance_metres, hall.camera_rig.pitch_degrees,
		hall.camera_rig.fov_degrees, player.max_speed,
		str(geometry.grid_visible), fixtures.marker_state_name(),
	])
	_expect(hall.runtime_calibration_is_baseline(), "Reset did not restore the Gate 1A baseline")
	_expect(is_equal_approx(hall.camera_rig.distance_metres, data.camera_distance_metres)
			and is_equal_approx(hall.camera_rig.pitch_degrees, data.camera_pitch_degrees)
			and is_equal_approx(hall.camera_rig.fov_degrees, data.camera_fov_degrees)
			and is_equal_approx(player.max_speed, data.maximum_movement_speed),
		"Reset restored something other than the candidate values from the calibration record")


# --- 9. Scope --------------------------------------------------------------------------

func _check_scope() -> void:
	print("")
	print("--- §9.16 no combat, progression, story, save, or later Gate 1 system exists here")
	for forbidden: String in [
		"attack", "quick_strike", "acquisition", "soft_target", "target_acquisition",
		"life", "mana", "damage", "graveblade", "enemy", "coordinator",
		"loot", "drop", "experience", "passive", "inventory", "equipment", "rarity",
		"affix", "craft", "forge", "hud", "settings", "saved_state", "lab_progress",
		"director", "story", "mara", "nexus", "riftmarked", "threshold_room",
		"procedural", "generator", "run_graph", "module_library", "pursuit", "intensity",
	]:
		_expect(not (forbidden in hall),
			"the hall has a '%s' member; that is not authorized by D-195" % forbidden)
	for forbidden: String in [
		"attack", "life", "mana", "weapon", "receive_damage", "physical_damage",
		"experience", "target", "inventory", "equip_weapon", "action_state",
	]:
		_expect(not (forbidden in player),
			"the hall player has a '%s' member; specification §3 gives it locomotion only" % forbidden)
	print("  the hall and its player carry locomotion, geometry, and inert fixtures and nothing else")

	# Nothing from the combat or progression layer is instantiated in the tree.
	for type_name: String in [
		"PrototypeGraveblade", "QuickStrikeAction", "AttackCoordinator", "PrototypeTargetable",
		"PrototypeHUD", "PrototypeProgressionDirector", "PrototypeSettings", "PrototypeLabState",
		"PrototypeAudioDirector", "PrototypePlayer", "PrototypeZeroRoom",
	]:
		_expect(_count_script_class(hall, type_name) == 0,
			"a %s exists inside the calibration hall" % type_name)
	_expect(_count_nodes_of_type(hall, "AudioStreamPlayer") == 0
			and _count_nodes_of_type(hall, "AudioStreamPlayer3D") == 0,
		"the calibration hall plays audio; Gate 1A authorizes none")
	print("  no combat, progression, HUD, settings, save, or audio object is instantiated")

	# D-208 §11.2: COMMENT CORRECTION ONLY. Gate 1B closed under D-206 and the
	# isolated Gate 1C Riftfall Landing scene exists under D-208, so "Gate 1B and
	# the canonical opening slice have not begun" is stale. The three paths below
	# are unchanged and still absent — Gate 1C lives under
	# scenes/first_mvp/severed_threshold/, which is none of them — so no assertion,
	# branch, count or behaviour moves here and Gate 1A stays at 284 checks.
	for absent: String in [
		"res://scenes/first_mvp/severed_threshold.tscn",
		"res://scenes/first_mvp/rift_nexus.tscn",
		"res://scripts/first_mvp/run_graph.gd",
	]:
		_expect(not ResourceLoader.exists(absent),
			"%s exists; Gate 1B and later first-MVP work are not authorized" % absent)
	_expect(not FileAccess.file_exists("res://../docs/testing/FIRST_MVP_VERTICAL_SLICE_REPORT.md"),
		"a first-MVP vertical-slice report exists; that work is not authorized")
	print("  the wider Severed Threshold route, the Nexus and the vertical slice have not")
	print("  been started; Gate 1B is closed and Gate 1C's Riftfall Landing is isolated")


func _check_no_state_written() -> void:
	print("")
	print("--- §9.5 and §3 the hall writes no save or settings file")
	for path: String in [
		"res://scripts/first_mvp/calibration/scale_calibration_hall.gd",
		"res://scripts/first_mvp/calibration/scale_calibration_geometry.gd",
		"res://scripts/first_mvp/calibration/calibration_fixtures.gd",
		"res://scripts/first_mvp/calibration/calibration_hall_player.gd",
		"res://scripts/first_mvp/calibration/scale_calibration_overlay.gd",
		"res://scripts/first_mvp/calibration/scale_calibration_data.gd",
	]:
		var source: String = _code_only(FileAccess.get_file_as_string(path))
		for forbidden: String in [
			"user://", "ConfigFile", "FileAccess.open", "ResourceSaver", "store_string",
			"store_line", "save_to_file",
		]:
			_expect(not source.contains(forbidden),
				"%s reaches '%s'; the hall writes nothing" % [path.get_file(), forbidden])
	for forbidden: String in ["storage_path", "save", "load_state", "schema_version"]:
		_expect(not (forbidden in hall), "the hall has a '%s' member" % forbidden)
	print("  no user:// path, ConfigFile, FileAccess write, or ResourceSaver call exists in Gate 1A code")


# --- 10. Visible surfaces ----------------------------------------------------------------

func _check_surfaces_are_on_screen() -> void:
	print("")
	print("--- §9.17 the calibration surfaces really are on screen")
	var view: Rect2 = get_viewport().get_visible_rect()
	var root: Control = hall.overlay as Control
	var rect: Rect2 = root.get_global_rect()
	var offscreen: PackedStringArray = PackedStringArray()
	var total: int = _collect_offscreen_text(root, view, offscreen)
	print("  overlay root %.0f x %.0f in a %.0f x %.0f viewport; %d text controls, %d off screen or zero-sized" % [
		rect.size.x, rect.size.y, view.size.x, view.size.y, total, offscreen.size(),
	])
	_expect(rect.size.x >= view.size.x - 1.0 and rect.size.y >= view.size.y - 1.0,
		"the overlay root is %.0f x %.0f, not the %.0f x %.0f viewport" % [
			rect.size.x, rect.size.y, view.size.x, view.size.y,
		])
	_expect(total >= 8, "the overlay shows only %d text controls" % total)
	_expect(offscreen.is_empty(),
		"the overlay draws text off screen or at zero size: %s" % ", ".join(offscreen))

	# The §8 conspicuous statement must actually be readable, not merely present.
	var text: String = _visible_text_in(root).to_lower()
	for required: String in [
		"scale calibration hall", "temporary developer", "candidate",
		"clear floor", "stress gate", "major gate", "close ordinary lane",
		"broad formation lane", "cinder seal", "mauler",
	]:
		_expect(text.contains(required),
			"the overlay never says '%s'" % required)
	print("  the overlay states what this scene is, and every §8 measurement group reaches the screen")


# --- Rendered evidence ---------------------------------------------------------------------

func _capture_evidence() -> void:
	print("")
	print("--- Rendered evidence (§10)")
	var brief: bool = arguments.has("--shots-brief")
	# The filename names the WINDOW, not the logical viewport. With
	# `stretch/mode = canvas_items` and an `expand` aspect, a 1280 x 720 window and
	# a 1920 x 1080 one are the SAME 16:9 logical rect — 1920 x 1080 in both — so a
	# viewport-derived suffix gave the two runs identical names and the second
	# silently overwrote four frames of the first. That also means the §9.17
	# on-screen assertions are literally the same assertions at both sizes, which
	# the report says rather than implying two independent proofs; the 1280 x 720
	# frames exist so READABILITY at the minimum window can be judged by eye.
	var window: Vector2i = DisplayServer.window_get_size()
	if window.x <= 0 or window.y <= 0:
		window = Vector2i(get_viewport().get_visible_rect().size)
	var suffix: String = "_%dx%d" % [window.x, window.y]
	hall.reset_calibration()

	# Each station is one relationship the project owner has to be able to audit.
	# `clean` additionally captures the frame with the overlay hidden — the same
	# F3 the owner has — because the panels necessarily cover part of the space
	# they are describing.
	var stations: Array[Dictionary] = [
		{
			"name": "hall_from_entrance", "at": geometry.player_spawn(),
			"grid": false, "clean": false, "distance": 0.0, "brief": true,
		},
		{
			"name": "hall_overview_wide_40m", "at": Vector3(0.0, 0.0, 0.0),
			"grid": true, "clean": true, "distance": 40.0, "brief": false,
		},
		{
			"name": "doorway_south_route_grid", "at": Vector3(-13.5, 0.0, geometry.spine_z()),
			"grid": true, "clean": true, "distance": 0.0, "brief": true,
		},
		{
			"name": "doorway_north_route_grid", "at": Vector3(-13.5, 0.0, 6.0),
			"grid": true, "clean": true, "distance": 0.0, "brief": false,
		},
		{
			"name": "combat_lanes_and_spacing", "at": Vector3(-2.0, 0.0, 1.5),
			"grid": false, "clean": true, "distance": 0.0, "brief": true,
		},
		{
			"name": "ranged_gallery", "at": Vector3(13.0, 0.0, -11.0),
			"grid": false, "clean": false, "distance": 0.0, "brief": false,
		},
		{
			"name": "telegraph_and_hazard", "at": Vector3(15.5, 0.0, 8.0),
			"grid": false, "clean": true, "distance": 0.0, "brief": true,
		},
		{
			"name": "occlusion_pillar", "at": Vector3(9.0, 0.0, -2.6),
			"grid": false, "clean": false, "distance": 0.0, "brief": false,
		},
		{
			"name": "occlusion_half_wall", "at": Vector3(16.0, 0.0, 2.6),
			"grid": false, "clean": false, "distance": 0.0, "brief": false,
		},
	]

	for station: Dictionary in stations:
		if brief and not bool(station["brief"]):
			continue
		var distance: float = float(station["distance"])
		if distance > 0.0:
			# The rig's own `]` control, at its 40 m limit. Not a second camera and
			# not a mock-up: the owner has exactly this control, and the default
			# 19 m frames above are the ones that show what 2.56 CF feels like.
			hall.camera_rig.adjust_distance(distance - hall.camera_rig.distance_metres)
		geometry.set_grid_visible(bool(station["grid"]))
		await _teleport(station["at"])
		await _shoot("gate_1a_%s%s" % [station["name"], suffix], 8)
		if bool(station["clean"]):
			hall.set_overlay_visible(false)
			await _shoot("gate_1a_%s_clean%s" % [station["name"], suffix], 4)
			hall.set_overlay_visible(true)
		geometry.set_grid_visible(false)
		if distance > 0.0:
			hall.reset_calibration()
		await _settle(3)

	# A click-to-move destination on open ground, so the marker is in frame.
	await _teleport(Vector3(-6.0, 0.0, -8.0))
	var goal: Vector3 = hall.resolve_to_navigation(Vector3(0.0, 0.0, -8.0))["point"]
	player.command_move_to(goal, goal, false)
	await _settle(20)
	await _shoot("gate_1a_click_to_move" + suffix, 4)
	player.clear_movement_intent("evidence cleanup", false)
	await _settle(4)
	await _teleport(geometry.player_spawn())
	hall.reset_calibration()


func _shoot(name_stem: String, settle_frames: int) -> void:
	for i: int in settle_frames:
		await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var path: String = "%s/%s.png" % [_shot_dir, name_stem]
	get_viewport().get_texture().get_image().save_png(path)
	print("  screenshot: %s" % path)


# --- Helpers -------------------------------------------------------------------------------

func _teleport(to: Vector3) -> void:
	hall.set_stick_override(Vector2.ZERO)
	player.clear_movement_intent("verification teleport", false)
	player.global_position = Vector3(to.x, 0.0, to.z)
	player.velocity = Vector3.ZERO
	hall.set_stick_override(null)
	await _settle(6)


func _settle(frames: int) -> void:
	for i: int in frames:
		await get_tree().physics_frame


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _argument_value(flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


## Strips comment lines so a source scan reads CODE. A file that says in prose
## that it writes no user:// path must not fail its own check.
func _code_only(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		var trimmed: String = line.strip_edges()
		if trimmed.begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


func _count_nodes(node: Node) -> int:
	var total: int = 1
	for child: Node in node.get_children():
		total += _count_nodes(child)
	return total


func _count_nodes_of_type(node: Node, type_name: String) -> int:
	var total: int = 0
	for child: Node in node.get_children():
		if child.is_class(type_name):
			total += 1
		total += _count_nodes_of_type(child, type_name)
	return total


func _nodes_of_type(node: Node, type_name: String) -> Array[Node]:
	var found: Array[Node] = []
	for child: Node in node.get_children():
		if child.is_class(type_name):
			found.append(child)
		found.append_array(_nodes_of_type(child, type_name))
	return found


## Counts nodes whose attached script declares the given global class name.
func _count_script_class(node: Node, class_name_wanted: String) -> int:
	var total: int = 0
	for child: Node in node.get_children():
		var script: Script = child.get_script() as Script
		if script != null and script.get_global_name() == StringName(class_name_wanted):
			total += 1
		total += _count_script_class(child, class_name_wanted)
	return total


func _collect_collision_objects(node: Node, into: PackedStringArray) -> void:
	for child: Node in node.get_children():
		if child.is_class("CollisionObject3D"):
			into.append(String(child.name))
		_collect_collision_objects(child, into)


func _collect_offscreen_text(node: Node, view: Rect2, into: PackedStringArray) -> int:
	var total: int = 0
	for child: Node in node.get_children():
		var control: Control = child as Control
		if control != null and control.is_visible_in_tree():
			var text: String = ""
			var label: Label = control as Label
			if label != null:
				text = label.text
			var rich: RichTextLabel = control as RichTextLabel
			if rich != null and text.is_empty():
				text = rich.get_parsed_text()
			var button: Button = control as Button
			if button != null and text.is_empty():
				text = button.text
			if not text.strip_edges().is_empty():
				total += 1
				var rect: Rect2 = control.get_global_rect()
				if rect.size.x <= 0.0 or rect.size.y <= 0.0 or not view.encloses(rect):
					into.append("%s at (%.0f, %.0f) %.0f x %.0f" % [
						control.name, rect.position.x, rect.position.y, rect.size.x, rect.size.y,
					])
		total += _collect_offscreen_text(child, view, into)
	return total


func _visible_text_in(node: Node) -> String:
	var parts: PackedStringArray = PackedStringArray()
	_collect_text(node, parts)
	return "\n".join(parts)


func _collect_text(node: Node, into: PackedStringArray) -> void:
	for child: Node in node.get_children():
		var label: Label = child as Label
		if label != null and not label.text.strip_edges().is_empty():
			into.append(label.text)
		var rich: RichTextLabel = child as RichTextLabel
		if rich != null and not rich.get_parsed_text().strip_edges().is_empty():
			into.append(rich.get_parsed_text())
		var button: Button = child as Button
		if button != null and not button.text.strip_edges().is_empty():
			into.append(button.text)
		_collect_text(child, into)
