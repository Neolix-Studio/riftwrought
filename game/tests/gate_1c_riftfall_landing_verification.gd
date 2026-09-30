extends Node
## First-MVP Gate 1C — automated verification of canonical Riftfall Landing
## (D-208 §11).
##
## WHAT IT PROVES, and only what a machine CAN settle: that the two scenes exist
## separately and the canonical one carries no player, camera or interface; that
## every accepted world, camera, movement and resource value is untouched and no
## InputMap action was added; that the authored footprint, CF, centreline, route
## widths, breach clearance and clear-ground fraction land inside §6.1's bands and
## are MEASURED from the geometry that was built; that only the §6.3 payloads are
## used, at root scale 1.0, with the recorded contact rule, and that the arch is a
## landmark rather than a gateway; that the accepted D-206 treatment and lighting
## are applied permanently and no imported material was written to; that the
## repeating stone passes through all four of its states, at its authored timing,
## deterministically, with no collision, no carve and an exact reset; that
## navigation is baked exactly once over the intended footprint with no phantom
## island, no walkable bank top and no unreachable intended ground; that the route
## can be walked end to end by the production movement object; that mouse,
## controller and interface input behave as the accepted kernel defines; and that
## nothing excluded by §2 entered the work.
##
## WHAT IT DELIBERATELY DOES NOT DECIDE. §1: "Only the project owner can answer
## the governing question after playing the result with mouse and controller."
## There is no assertion anywhere below about whether the Landing looks like a
## world, whether the route reads without an arrow, or whether the anomaly lands.
## Gate 1C is delivered OPEN.
##
## IT DOES NOT RE-PROVE GATE 1B. §11.1: the inherited chain already checks every
## archive mapping, byte identity, licence, colour atlas and per-surface material,
## and this suite must not duplicate hundreds of those assertions. What it adds is
## the one thing Gate 1B cannot know — that THIS scene uses only the approved
## subset and behaves as §6 to §10 require.
##
## A PROPERTY IS ASSERTED TO EXIST BEFORE ITS VALUE IS READ, throughout. That is
## not defensive tidiness: `Resource.get()` answers `null` for a name that is not
## there, `float(null)` throws, and a throw inside a check function aborts the
## WHOLE function while the suite still reports PASS. D-200 and D-201 measured
## exactly that in Gate 1A — one assertion of seven ran and six were silently
## skipped behind a green result.
##
## Run:  godot --headless --path game res://scenes/first_mvp/severed_threshold/riftfall_landing_review.tscn -- --verify-1c
##       godot --path game --resolution 1920x1080 res://.../riftfall_landing_review.tscn -- --verify-1c --shots <dir>

const CANONICAL_SCENE: String = "res://scenes/first_mvp/severed_threshold/riftfall_landing.tscn"
const REVIEW_SCENE: String = "res://scenes/first_mvp/severed_threshold/riftfall_landing_review.tscn"

## D-175's accepted contract, asserted against the objects Gate 1C actually built.
const ACCEPTED_MAX_SPEED: float = 5.0
const ACCEPTED_ACCELERATION: float = 30.0
const ACCEPTED_BRAKING: float = 40.0
const ACCEPTED_ARRIVAL_TOLERANCE: float = 0.20
const ACCEPTED_DEADZONE: float = 0.20
const ACCEPTED_SUBSTANTIAL_TURN: float = 35.0
const ACCEPTED_CAMERA_DISTANCE: float = 19.0
const ACCEPTED_CAMERA_PITCH: float = 55.0
const ACCEPTED_CAMERA_FOV: float = 45.0
const ACCEPTED_CAMERA_YAW: float = 45.0
const ACCEPTED_P: float = 0.80

## §6.1's required bands.
const FOOTPRINT_MIN: float = 1150.0
const FOOTPRINT_MAX: float = 1350.0
const CF_MIN: float = 2.0
const CF_MAX: float = 2.3
const CENTRELINE_MIN: float = 45.0
const CENTRELINE_MAX: float = 55.0
const MANDATORY_CLEARANCE_MIN: float = 8.0
const BREACH_MIN: float = 7.8
const CLEAR_FRACTION_MIN: float = 0.70

## The complete InputMap this project declares. Gate 1C adds none and removes none.
const EXPECTED_ACTIONS: Array[String] = [
	"move_point", "move_vector_left", "move_vector_right", "move_vector_forward",
	"move_vector_back", "quick_strike", "attack_in_place", "reset_target_fixtures",
	"toggle_slow_motion", "toggle_fixture_drift", "toggle_fixture_present",
	"toggle_debug_overlay", "toggle_barrier", "toggle_calibration_grid",
	"calibrate_camera_closer", "calibrate_camera_farther", "calibrate_pitch_down",
	"calibrate_pitch_up", "calibrate_fov_down", "calibrate_fov_up",
	"calibrate_speed_down", "calibrate_speed_up", "reset_encounter", "interact",
	"ui_confirm", "ui_cancel", "reset_lab_progress", "pause", "quick_restart",
	"toggle_damage_numbers", "calibrate_reset",
]

## Shipping Gate 1C code. The verification itself is excluded by construction — it
## lives under `tests/`, not under `scripts/first_mvp/` — so a scan for forbidden
## storage strings cannot be confused by the file that forbids them.
const SHIPPING_SCRIPTS: Array[String] = [
	"res://scripts/first_mvp/severed_threshold/riftfall_landing.gd",
	"res://scripts/first_mvp/severed_threshold/riftfall_landing_layout.gd",
	"res://scripts/first_mvp/severed_threshold/riftfall_loop_event.gd",
	"res://scripts/first_mvp/severed_threshold/riftfall_landing_review.gd",
	"res://scripts/first_mvp/severed_threshold/riftfall_landing_overlay.gd",
]

## Reused unchanged, and listed so the reuse is a checked fact rather than a claim.
const REUSED_SCRIPTS: Array[String] = [
	"res://scripts/first_mvp/visual/exterior_review_lighting.gd",
	"res://scripts/first_mvp/visual/exterior_review_treatment.gd",
	"res://scripts/first_mvp/visual/exterior_asset_probe.gd",
	"res://scripts/movement/prototype_locomotion.gd",
	"res://scripts/movement/prototype_ground_pointer.gd",
	"res://scripts/movement/prototype_mouse_hold.gd",
	"res://scripts/camera/prototype_camera_rig.gd",
	"res://scripts/input/input_family_tracker.gd",
	"res://scripts/prototype_zero/destination_marker.gd",
	"res://scenes/first_mvp/calibration/calibration_hall_player.tscn",
]

## Every family D-206 rejected or left unclassified. No Gate 1C file may name one.
const FORBIDDEN_ASSET_FRAGMENTS: Array[String] = [
	"k0rveen", "kenney/nature", "fantasy_town", "modular_ruins", "assetquest",
	"medieval_village", "modular_cave", "demonson", "fire_golem", "lowpoly_Village",
	"wall_corner",
]

var review: RiftfallLandingReview
var arguments: PackedStringArray = PackedStringArray()

var landing: RiftfallLanding
var layout: RiftfallLandingLayout
var loop_event: RiftfallLoopEvent
var player: CalibrationHallPlayer

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _shot_dir: String = ""


func _ready() -> void:
	await run()


func run() -> void:
	landing = review.landing
	layout = landing.layout
	loop_event = landing.loop_event
	player = review.player
	_shot_dir = _argument_value("--shots")

	print("")
	print("=== First-MVP Gate 1C verification — Riftfall Landing (D-208) ===")
	await _settle(10)
	await _await_navigation()

	_check_engine_and_entrypoint()
	_check_accepted_values_untouched()
	_check_input_map_untouched()
	_check_scene_separation()
	_check_layout_targets()
	_check_route_and_beats()
	_check_asset_allowlist()
	_check_presentation()
	await _check_loop_event()
	_check_sockets()
	await _check_navigation()
	await _check_traversal()
	await _check_collision_and_cursor()
	await _check_controller_and_input()
	await _check_overlay_and_reset()
	_check_scope()
	_check_no_state_written()
	_check_closed_gates_untouched()
	await _check_surfaces_are_on_screen()

	if _shot_dir != "":
		await _capture_evidence()

	print("")
	if _failures.is_empty():
		print("GATE 1C VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("GATE 1C VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		get_tree().quit(1)


# --- 1. Engine, entrypoint and the accepted values ----------------------------

func _check_engine_and_entrypoint() -> void:
	print("")
	print("--- Engine baseline, entrypoint, and the two Gate 1C scenes (§11)")
	var version: String = str(Engine.get_version_info()["string"])
	print("  engine %s, renderer %s, physics %d Hz" % [
		version, ProjectSettings.get_setting("rendering/renderer/rendering_method"),
		int(ProjectSettings.get_setting("physics/common/physics_ticks_per_second")),
	])
	_expect(version.begins_with("4.7.2"),
		"engine is %s, not the locked 4.7.2 stable baseline" % version)
	_expect(
		String(ProjectSettings.get_setting("rendering/renderer/rendering_method")) == "forward_plus",
		"the renderer is no longer Forward+")
	_expect(int(ProjectSettings.get_setting("physics/common/physics_ticks_per_second")) == 60,
		"physics is no longer 60 Hz")

	var main_scene: String = String(ProjectSettings.get_setting("application/run/main_scene"))
	print("  project main scene: %s" % main_scene)
	_expect(main_scene == "res://scenes/app/prototype_app.tscn",
		"the project main scene is '%s'; §2 forbids Gate 1C replacing the Prototype App"
		% main_scene)
	# Aggregated deliberately: an aggregate that names its bad member precisely is
	# the shape §11.1 asks for, and one assertion per path would add fifteen rows
	# that all say the same thing.
	var missing_scenes: PackedStringArray = PackedStringArray()
	for required: String in [
		"res://scenes/app/prototype_app.tscn",
		"res://scenes/prototype_zero/prototype_zero.tscn",
		"res://scenes/prototype_zero/gate_a_asset_spike.tscn",
		"res://scenes/first_mvp/calibration/scale_calibration_hall.tscn",
		"res://scenes/first_mvp/visual/exterior_asset_compatibility_spike.tscn",
		"res://scenes/first_mvp/visual/exterior_cohesion_comparison.tscn",
		CANONICAL_SCENE, REVIEW_SCENE,
	]:
		if not ResourceLoader.exists(required):
			missing_scenes.append(required)
	_expect(missing_scenes.is_empty(),
		"earlier or Gate 1C scenes are missing: %s" % ", ".join(missing_scenes))
	var missing_reused: PackedStringArray = PackedStringArray()
	for reused: String in REUSED_SCRIPTS:
		if not ResourceLoader.exists(reused):
			missing_reused.append(reused)
	_expect(missing_reused.is_empty(),
		"reused components are missing: %s" % ", ".join(missing_reused))
	print("  every earlier scene, every reused component, and both Gate 1C scenes exist")


## §2 and §11.9: the Prototype Zero resources and the Gate 1A calibration record
## are unchanged. Ten load-bearing rows, re-read here so a change fails inside
## this run as well as in the locked chain the smoke script runs first — and the
## shell separately proves every `.tres` byte-identical, which is why this is ten
## rows rather than a duplicate of Gate 1B's eighteen.
func _check_accepted_values_untouched() -> void:
	print("")
	print("--- Prototype Zero and Gate 1A accepted values are untouched (§2, §11.9)")
	var quick_strike: Resource = load("res://data/prototype_zero/quick_strike.tres")
	var graveblade: Resource = load("res://data/prototype_zero/graveblade.tres")
	var starter: Resource = load("res://data/prototype_zero/starter_sword.tres")
	var honed: Resource = load("res://data/prototype_zero/honed_sword.tres")
	var calibration: Resource = load("res://data/first_mvp/calibration/scale_calibration.tres")
	var accepted: Array[Dictionary] = [
		{"what": "Quick Strike action time", "on": quick_strike, "field": "action_time", "want": 0.80},
		{"what": "Quick Strike reach", "on": quick_strike, "field": "reach", "want": 1.65},
		{"what": "Graveblade Life", "on": graveblade, "field": "max_life", "want": 300.0},
		{"what": "Graveblade damage", "on": graveblade, "field": "physical_damage", "want": 125.0},
		{"what": "Training Sword damage", "on": starter, "field": "physical_damage", "want": 100.0},
		{"what": "Honed Sword damage", "on": honed, "field": "physical_damage", "want": 150.0},
		{"what": "Gate 1A world unit", "on": calibration, "field": "world_unit_metres", "want": 1.0},
		{"what": "Gate 1A P", "on": calibration, "field": "player_unit_metres", "want": 0.80},
		{"what": "Gate 1A camera distance", "on": calibration, "field": "camera_distance_metres", "want": 19.0},
		{"what": "Gate 1A movement speed", "on": calibration, "field": "maximum_movement_speed", "want": 5.0},
	]
	for entry: Dictionary in accepted:
		var value: Variant = (entry["on"] as Resource).get(String(entry["field"]))
		_expect(value != null,
			"%s: the property '%s' does not exist on that resource" % [
				entry["what"], entry["field"],
			])
		if value == null:
			continue
		_expect(is_equal_approx(float(value), float(entry["want"])),
			"%s is %s, not the accepted %s" % [entry["what"], value, entry["want"]])
	print("  %d accepted values re-read and unchanged" % accepted.size())

	# And the live objects Gate 1C built carry exactly the accepted contract.
	var live: Array[Dictionary] = [
		{"what": "maximum movement speed", "is": player.max_speed, "want": ACCEPTED_MAX_SPEED},
		{"what": "acceleration", "is": player.acceleration, "want": ACCEPTED_ACCELERATION},
		{"what": "braking", "is": player.braking, "want": ACCEPTED_BRAKING},
		{"what": "arrival tolerance", "is": player.arrival_tolerance, "want": ACCEPTED_ARRIVAL_TOLERANCE},
		{"what": "controller deadzone", "is": player.stick_deadzone, "want": ACCEPTED_DEADZONE},
		{"what": "substantial turn", "is": player.substantial_turn_degrees, "want": ACCEPTED_SUBSTANTIAL_TURN},
		{"what": "camera distance", "is": review.camera_rig.distance_metres, "want": ACCEPTED_CAMERA_DISTANCE},
		{"what": "camera pitch", "is": review.camera_rig.pitch_degrees, "want": ACCEPTED_CAMERA_PITCH},
		{"what": "camera fov", "is": review.camera_rig.fov_degrees, "want": ACCEPTED_CAMERA_FOV},
		{"what": "camera yaw", "is": review.camera_rig.yaw_degrees, "want": ACCEPTED_CAMERA_YAW},
		{"what": "player diameter", "is": player.collision_diameter(), "want": ACCEPTED_P},
		{"what": "player height", "is": player.collision_height(), "want": 1.80},
	]
	for entry: Dictionary in live:
		_expect(is_equal_approx(float(entry["is"]), float(entry["want"])),
			"live %s is %.4f, not the accepted %.4f" % [
				entry["what"], float(entry["is"]), float(entry["want"]),
			])
	print("  %d live world, camera and movement values match the accepted contract" % live.size())


## §2: no InputMap action was added. This is the sharpest of the scope checks,
## because the Gate B, E and F suites each walk `InputMap.get_actions()` and emit
## one assertion per key event, so declaring an action here would move three
## locked Prototype Zero counts without a single old assertion having become false.
func _check_input_map_untouched() -> void:
	print("")
	print("--- The InputMap is byte-for-byte the accepted 31-action set (§2)")
	var declared: PackedStringArray = PackedStringArray()
	for action: StringName in InputMap.get_actions():
		var name_text: String = String(action)
		if name_text.begins_with("ui_") and not EXPECTED_ACTIONS.has(name_text):
			continue
		declared.append(name_text)
	declared.sort()
	var wanted: Array[String] = EXPECTED_ACTIONS.duplicate()
	wanted.sort()
	print("  %d project actions declared" % declared.size())
	_expect(declared.size() == wanted.size(),
		"the project declares %d actions, not the accepted %d" % [declared.size(), wanted.size()])
	var missing: PackedStringArray = PackedStringArray()
	for action: String in wanted:
		if not declared.has(action):
			missing.append(action)
	_expect(missing.is_empty(), "accepted actions are missing: %s" % ", ".join(missing))
	var added: PackedStringArray = PackedStringArray()
	for action: String in declared:
		if not wanted.has(action):
			added.append(action)
	_expect(added.is_empty(),
		"Gate 1C added InputMap actions: %s; §9 requires physical keys" % ", ".join(added))
	var wasd: PackedStringArray = PackedStringArray()
	for forbidden: String in ["move_up", "move_down", "move_left", "move_right", "wasd"]:
		if declared.has(forbidden):
			wasd.append(forbidden)
	_expect(wasd.is_empty(), "WASD-style actions exist: %s" % ", ".join(wasd))
	print("  no action added, none removed, and still no WASD binding")


# --- 2. Scene separation (§3) -------------------------------------------------

func _check_scene_separation() -> void:
	print("")
	print("--- The canonical scene carries the world and nothing else (§3)")
	_expect(landing is RiftfallLanding, "the canonical scene root is not a RiftfallLanding")
	_expect(review is RiftfallLandingReview, "the review root is not a RiftfallLandingReview")
	_expect(landing.get_parent() == review,
		"the review wrapper does not instance the canonical scene as its own child")
	_expect(_count_script_class(landing, "CalibrationHallPlayer") == 0,
		"a locomotion body exists inside the CANONICAL scene; §3 puts it in the wrapper")
	_expect(_count_script_class(landing, "PrototypeCameraRig") == 0,
		"a camera rig exists inside the CANONICAL scene")
	_expect(_count_script_class(landing, "DestinationMarker") == 0,
		"a destination marker exists inside the CANONICAL scene")
	_expect(_count_script_class(landing, "RiftfallLandingOverlay") == 0,
		"the developer overlay exists inside the CANONICAL scene")
	_expect(_count_nodes_of_type(landing, "CanvasLayer") == 0
			and _count_nodes_of_type(landing, "Control") == 0,
		"the canonical scene contains interface nodes")
	_expect(_count_nodes_of_type(landing, "Camera3D") == 0,
		"the canonical scene contains a camera")
	_expect(review.player != null and review.camera_rig != null and review.marker != null
			and review.input_family != null,
		"the review wrapper is missing a body, camera, marker or input-family tracker")
	# The 45 degree composition yaw, MEASURED against the camera's own forward
	# direction rather than read back off the basis that set it.
	var composition_forward: Vector3 = layout.global_transform.basis * Vector3(0.0, 0.0, -1.0)
	var camera_axis: Vector3 = review.camera_rig.ground_forward()
	print("  the layout's own -Z axis lies %.2f degrees from the camera forward axis" % (
		rad_to_deg(composition_forward.normalized().angle_to(camera_axis))
	))
	_expect(composition_forward.normalized().angle_to(camera_axis) < deg_to_rad(1.0),
		"the composition yaw puts the layout's forward axis %.2f degrees off the camera's"
		% rad_to_deg(composition_forward.normalized().angle_to(camera_axis)))
	var canonical_source: String = _code_only(FileAccess.get_file_as_string(
		"res://scripts/first_mvp/severed_threshold/riftfall_landing.gd"
	))
	_expect(not canonical_source.contains("riftfall_landing_review")
			and not canonical_source.contains("calibration_hall_player"),
		"the canonical scene's script names the review wrapper or the test body")
	print("  the canonical scene has no player, camera, marker, overlay or Control;")
	print("  the wrapper supplies all four and the canonical script names neither")


# --- 3. §6.1's required measured outcome --------------------------------------

func _check_layout_targets() -> void:
	print("")
	print("--- §6.1 measured outcome, read off the geometry that was built")
	var footprint: float = layout.footprint_area()
	var cf: float = landing.footprint_in_cf()
	var centreline: float = layout.centreline_length()
	var resolved: float = landing.route_path_length()
	var narrowest: Dictionary = layout.narrowest_sample()
	var breach: float = landing.breach_clearance()
	var clear: float = layout.clear_fraction()
	print("  authored movement footprint  %.2f m^2  (band %.0f - %.0f)" % [
		footprint, FOOTPRINT_MIN, FOOTPRINT_MAX,
	])
	print("  CF at the reference camera   %.3f CF (band %.1f - %.1f, %.2f m^2 per CF)" % [
		cf, CF_MIN, CF_MAX, RiftfallLanding.REFERENCE_CF_AREA,
	])
	print("  geometric route centreline   %.3f m (band %.0f - %.0f)" % [
		centreline, CENTRELINE_MIN, CENTRELINE_MAX,
	])
	print("  resolved navigation path     %.3f m spawn to exit socket" % resolved)
	print("  navigation mesh after erosion %.2f m^2 over %d polygons" % [
		landing.navmesh_area, landing.navmesh_polygon_count,
	])
	print("  narrowest measured clearance %.3f m at %.1f m along the route" % [
		float(narrowest["width"]), float(narrowest["along"]),
	])
	print("  Watch breach                 %.3f m between the authored breach masses" % breach)
	print("  route widths                 %d of %d stations in 10-14 m, %d wider, median %.2f m" % [
		layout.widths_in_ordinary_band(), layout.width_samples().size(),
		layout.widths_wider_than_ordinary(), layout.median_width(),
	])
	print("  clear movement footprint     %.1f%% free of collision-bearing obstacles" % (
		clear * 100.0
	))
	_expect(footprint >= FOOTPRINT_MIN and footprint <= FOOTPRINT_MAX,
		"the authored footprint is %.2f m^2, outside §6.1's %.0f - %.0f" % [
			footprint, FOOTPRINT_MIN, FOOTPRINT_MAX,
		])
	_expect(cf >= CF_MIN and cf <= CF_MAX,
		"the footprint is %.3f CF, outside §6.1's %.1f - %.1f" % [cf, CF_MIN, CF_MAX])
	_expect(centreline >= CENTRELINE_MIN and centreline <= CENTRELINE_MAX,
		"the centreline is %.3f m, outside §6.1's %.0f - %.0f" % [
			centreline, CENTRELINE_MIN, CENTRELINE_MAX,
		])
	_expect(float(narrowest["width"]) >= MANDATORY_CLEARANCE_MIN - 0.0005,
		"the narrowest mandatory clearance is %.3f m, under §6.1's %.1f m" % [
			float(narrowest["width"]), MANDATORY_CLEARANCE_MIN,
		])
	_expect(breach >= BREACH_MIN,
		"the Watch breach measures %.3f m, under §6.1's %.1f m floor" % [breach, BREACH_MIN])
	_expect(absf(breach - 8.0) <= 0.20,
		"the Watch breach measures %.3f m against §6.1's 8.0 m target" % breach)
	_expect(clear >= CLEAR_FRACTION_MIN,
		"only %.1f%% of the movement footprint is clear, under §6.1's 70%%" % (clear * 100.0))
	# "Ordinary clear route width 10-14 m through most of the route": measured at
	# every station, and MOST means a majority of them. The stations outside the
	# band are named rather than hidden — the arrival bowl and the junction are
	# deliberately wider (paper design §4: "generous empty floor"), and the seven
	# narrower ones are the breach itself.
	var ordinary: int = layout.widths_in_ordinary_band()
	var stations: int = layout.width_samples().size()
	_expect(ordinary * 2 > stations,
		"only %d of %d stations measure 10-14 m; §6.1 asks for most of the route" % [
			ordinary, stations,
		])
	_expect(layout.median_width() >= 10.0 and layout.median_width() <= 14.0,
		"the median route width is %.2f m, outside 10-14 m" % layout.median_width())
	# The resolved navigation path is a DIFFERENT quantity from the geometric
	# centreline and must not be reported as the same one; it is asserted only to
	# be a real path of a plausible length.
	_expect(resolved > 0.0 and resolved <= centreline * 1.35,
		"the resolved path is %.2f m against a %.2f m centreline" % [resolved, centreline])
	# Traversal expectation: §6.1 asks for roughly 12-20 s of first-play movement
	# and looking around at the accepted 5.0 m/s.
	var direct_seconds: float = resolved / ACCEPTED_MAX_SPEED
	print("  direct traversal at 5.0 m/s  %.1f s before any looking around" % direct_seconds)
	_expect(direct_seconds >= 8.0 and direct_seconds <= 20.0,
		"a direct traversal takes %.1f s, outside a sane first-play expectation" % direct_seconds)


func _check_route_and_beats() -> void:
	print("")
	print("--- §6.2's four beats, the boundary, and the clear walking line")
	var beats: PackedStringArray = PackedStringArray()
	for region: Dictionary in RiftfallLandingLayout.WALKABLE:
		beats.append(String(region["name"]))
	print("  authored walkable regions: %s" % ", ".join(beats))
	var missing_beats: PackedStringArray = PackedStringArray()
	for required: String in [
		"RiftScar", "ProcessionLower", "ProcessionBend", "WatchApproach", "BreachAndBeyond",
	]:
		if not beats.has(required):
			missing_beats.append(required)
	_expect(missing_beats.is_empty(),
		"§6.2 beats are missing from the authored regions: %s" % ", ".join(missing_beats))
	# The boundary must tile the arena's complement exactly: a gap is a hole the
	# player walks out through.
	var gaps: PackedStringArray = layout.boundary_gaps()
	_expect(gaps.is_empty(),
		"the boundary leaves %d unbanked, unwalkable sample(s): %s" % [
			gaps.size(), ", ".join(gaps),
		])
	var intrusions: PackedStringArray = layout.spine_intrusions()
	_expect(intrusions.is_empty(),
		"%d placed mesh(es) reach into the clear walking line: %s" % [
			intrusions.size(), ", ".join(intrusions),
		])
	var clearance: Dictionary = layout.minimum_solid_clearance()
	print("  nearest non-boundary solid to the centreline: %.3f m (%s)" % [
		float(clearance["metres"]), String(clearance["solid"]),
	])
	_expect(float(clearance["metres"]) >= RiftfallLandingLayout.MINIMUM_SOLID_CLEARANCE - 0.0005,
		"'%s' sits %.3f m from the centreline, inside the %.1f m rule" % [
			String(clearance["solid"]), float(clearance["metres"]),
			RiftfallLandingLayout.MINIMUM_SOLID_CLEARANCE,
		])
	# The route bends. A straight corridor would make the whole composition a
	# hallway, which §6.2 forbids; a maze would be worse.
	var span: float = RiftfallLandingLayout.CENTRELINE[0].distance_to(
		RiftfallLandingLayout.CENTRELINE[RiftfallLandingLayout.CENTRELINE.size() - 1]
	)
	print("  centreline %.2f m over a %.2f m straight span: %.1f%% longer than a corridor" % [
		layout.centreline_length(), span,
		(layout.centreline_length() / span - 1.0) * 100.0,
	])
	_expect(layout.centreline_length() > span * 1.02,
		"the route is a straight corridor: %.2f m over a %.2f m span" % [
			layout.centreline_length(), span,
		])
	_expect(layout.centreline_length() < span * 1.60,
		"the route wanders %.2f m over a %.2f m span; §6.2 forbids a maze" % [
			layout.centreline_length(), span,
		])
	# The composition yaw is what makes the road run away from the fixed camera.
	var forward: Vector3 = review.route_forward()
	var camera_forward: Vector3 = review.camera_rig.ground_forward()
	print("  route leaves the spawn at %.1f degrees from the camera's forward axis" % (
		rad_to_deg(forward.angle_to(camera_forward))
	))
	_expect(forward.angle_to(camera_forward) < deg_to_rad(35.0),
		"the route leaves the spawn %.1f degrees away from the camera forward axis" % (
			rad_to_deg(forward.angle_to(camera_forward))
		))
	# §6.2 BEAT 2, AND THE MEASUREMENT THAT CHANGED HOW IT IS BUILT. The accepted
	# camera's top ray is 32.50 degrees below horizontal, so the horizon is never in
	# shot and nothing at or above ground level beyond 13.53 m ahead of the body can
	# appear however tall it is. A DISTANT silhouette is therefore not a design
	# choice at this camera — it is impossible — and the forward bearing has to be
	# carried by what lies inside that band. Both halves are asserted.
	var silhouette: Dictionary = landing.silhouette_sighting()
	print("  accepted camera: horizon in shot %s; ground visible %.2f m behind to %.2f m ahead" % [
		str(bool(silhouette["horizon_visible"])),
		float(silhouette["ground_visible_behind"]), float(silhouette["ground_visible_ahead"]),
	])
	print("  Watch massing %.1f m tall, base y %.2f; first enters the frame %.2f m along" % [
		float(silhouette["tallest_mass"]), float(silhouette["lowest_base"]),
		float(silhouette["visible_from_along"]),
	])
	_expect(not bool(silhouette["horizon_visible"]),
		"the accepted camera now shows the horizon; the visible-band arithmetic below is void")
	_expect(absf(float(silhouette["ground_visible_ahead"]) - 13.532) < 0.01,
		"the accepted camera shows ground %.3f m ahead, not the computed 13.532 m"
		% float(silhouette["ground_visible_ahead"]))
	_expect(float(silhouette["visible_from_along"]) >= 0.0,
		"the Watch massing never enters the accepted camera's frame anywhere on the route")
	_expect(float(silhouette["visible_from_along"]) >= layout.centreline_length() * 0.60,
		("the Watch massing appears %.1f m along a %.1f m route; it is built to be reached, "
		+ "not seen from the arrival, because this camera cannot show a distant landmark")
		% [float(silhouette["visible_from_along"]), layout.centreline_length()])
	# What DOES carry the bearing from the arrival: road surface inside the visible
	# band, ahead of the spawn, on the centreline.
	var road_ahead: int = 0
	for entry: Dictionary in layout.placed:
		if not bool(entry["surface"]):
			continue
		var node: Node3D = entry["node"]
		var flat: Vector2 = Vector2(node.position.x, node.position.z)
		var along_spawn: float = 0.0
		while along_spawn <= float(silhouette["ground_visible_ahead"]):
			if layout.centreline_point(along_spawn).distance_to(flat) <= 5.5:
				road_ahead += 1
				break
			along_spawn += 0.5
	print("  road surface pieces inside the visible band ahead of the spawn: %d" % road_ahead)
	_expect(road_ahead >= 4,
		("only %d road surface piece(s) lie inside the %.1f m the camera can show ahead of the "
		+ "spawn; nothing else can carry the first bearing at this camera")
		% [road_ahead, float(silhouette["ground_visible_ahead"])])


# --- 4. §6.3's payload allowlist and §6.4's placement rules -------------------

func _check_asset_allowlist() -> void:
	print("")
	print("--- §6.3 payloads only, §6.4 contact and collision (%d instances)" % layout.placed.size())
	var approved: PackedStringArray = RiftfallLandingLayout.payload_paths()
	var outside: PackedStringArray = PackedStringArray()
	var rescaled: PackedStringArray = PackedStringArray()
	for entry: Dictionary in layout.placed:
		var record: Dictionary = entry["record"]
		if not approved.has(String(record["path"])):
			outside.append(String(record["path"]))
		var node: Node3D = entry["node"]
		if not node.scale.is_equal_approx(Vector3.ONE):
			rescaled.append("%s at scale %s" % [record["key"], node.scale])
	_expect(outside.is_empty(),
		"%d instance(s) come from outside the §6.3 manifest: %s" % [
			outside.size(), ", ".join(outside),
		])
	_expect(rescaled.is_empty(),
		"%d instance(s) are not at root scale 1.0: %s" % [rescaled.size(), ", ".join(rescaled)])
	# Every payload the allowlist names must exist on disk, whether or not this
	# composition uses it: §6.3 says "Not every permitted piece must be used", and
	# a manifest naming a missing file would be a manifest nobody checked.
	var absent: PackedStringArray = PackedStringArray()
	for path: String in approved:
		if not ResourceLoader.exists(path):
			absent.append(path)
	_expect(absent.is_empty(), "approved payloads are missing: %s" % ", ".join(absent))
	print("  %d of the %d approved payloads used, all at scale 1.0" % [
		layout.used_payload_keys().size(), approved.size(),
	])

	# No Gate 1C file may name a rejected or unclassified family, and that is
	# scanned RAW so a path inside a comment cannot slip past either.
	var named: PackedStringArray = PackedStringArray()
	for path: String in SHIPPING_SCRIPTS:
		var source: String = FileAccess.get_file_as_string(path)
		for fragment: String in FORBIDDEN_ASSET_FRAGMENTS:
			if source.contains(fragment) and not named.has(fragment):
				named.append(fragment)
	_expect(named.is_empty(),
		"Gate 1C names rejected or unclassified assets: %s" % ", ".join(named))

	# The four families D-206 retained, and no fifth.
	var families: PackedStringArray = layout.used_families()
	for family: String in families:
		print("  family in use: %s" % family)
	_expect(families.size() == 4, "%d families are in use, not the four retained" % families.size())
	var unused: PackedStringArray = PackedStringArray()
	for required: String in [
		RiftfallLandingLayout.FAMILY_DUNGEON, RiftfallLandingLayout.FAMILY_FOREST,
		RiftfallLandingLayout.FAMILY_HALLOWEEN, RiftfallLandingLayout.FAMILY_GRAVEYARD,
	]:
		if not families.has(required):
			unused.append(required)
	_expect(unused.is_empty(), "retained families are unused: %s" % ", ".join(unused))

	# §6.4: contact rules. Each placed piece must sit on the ground the way its
	# record says it does, which is what "determine contact from the intended
	# ground contact, not blindly from the entire AABB" means in practice.
	var contact_faults: PackedStringArray = PackedStringArray()
	for entry: Dictionary in layout.placed:
		var record: Dictionary = entry["record"]
		var contact: String = String(record["contact"])
		if not ["surface", "base", "plant"].has(contact):
			contact_faults.append("%s has contact rule '%s'" % [record["key"], contact])
	_expect(contact_faults.is_empty(),
		"unknown contact rules: %s" % ", ".join(contact_faults))
	# The measured surface heights the `surface` pieces were laid by. Gate 1B
	# measured why a bounding box is the wrong answer; this proves Gate 1C used
	# the right one.
	var unmeasured: PackedStringArray = PackedStringArray()
	for key: String in ["floor_dirt", "path_A", "path_C", "floor_tile_large"]:
		if not layout.surface_drops.has(key):
			unmeasured.append(key)
	_expect(unmeasured.is_empty(),
		"surface pieces laid without a measured dominant surface height: %s"
		% ", ".join(unmeasured))
	print("  measured surface heights used for laying: %s" % str(layout.surface_drops))

	# §6.4: the Halloween arch is a landmark, never the traversable opening.
	var arch: Dictionary = layout.arch_is_off_route()
	_expect(bool(arch["found"]), "the Halloween arch landmark was never placed")
	if bool(arch["found"]):
		print("  arch landmark: %.3f m^2 of walkable overlap, %.2f m from the centreline" % [
			float(arch["walkable_overlap"]), float(arch["centreline_distance"]),
		])
		_expect(float(arch["walkable_overlap"]) <= 0.0001,
			"the arch overlaps %.3f m^2 of the movement footprint; §6.4 keeps it off the route"
			% float(arch["walkable_overlap"]))
		_expect(float(arch["centreline_distance"]) >= 6.0,
			"the arch stands %.2f m from the centreline; it must read as a landmark"
			% float(arch["centreline_distance"]))

	# §6.4 and D-206: the Graveyard layer is dressing. It owns no collision and
	# carves nothing, which is exactly the arrangement that made it safe to adopt.
	var graveyard_solids: int = 0
	for entry: Dictionary in layout.solids():
		var solid_name: String = String(entry["name"])
		if solid_name.to_lower().contains("debris") or solid_name.to_lower().contains("stone_wall") \
				or solid_name.to_lower().contains("graveyard"):
			graveyard_solids += 1
	_expect(graveyard_solids == 0,
		"the Kenney Graveyard dressing owns %d collision shape(s); D-206 adopted it as dressing"
		% graveyard_solids)
	var graveyard_instances: int = (
		layout.instances_of("debris") + layout.instances_of("stone-wall-damaged")
		+ layout.instances_of("stone-wall-column")
	)
	print("  Kenney Graveyard: %d instances, 0 collision shapes, 0 navigation carves" % (
		graveyard_instances
	))
	_expect(graveyard_instances > 0 and graveyard_instances <= 40,
		"%d Graveyard pieces are placed; D-206 adopted the layer as SPARSE dressing"
		% graveyard_instances)
	# Sparse also means it must not dominate: the layer stays a minority of the
	# placed dressing rather than becoming the visual language.
	_expect(graveyard_instances * 3 < layout.placed.size(),
		"the Graveyard layer is %d of %d instances; it must stay sparse" % [
			graveyard_instances, layout.placed.size(),
		])


# --- 5. §6.5's presentation ---------------------------------------------------

func _check_presentation() -> void:
	print("")
	print("--- §6.5: the accepted exterior presentation, selected permanently")
	_expect(is_equal_approx(ExteriorReviewTreatment.SATURATION, 0.42),
		"the accepted saturation is %.4f, not 0.42" % ExteriorReviewTreatment.SATURATION)
	_expect(is_equal_approx(ExteriorReviewTreatment.VALUE, 0.62),
		"the accepted value scale is %.4f, not 0.62" % ExteriorReviewTreatment.VALUE)
	_expect(ExteriorReviewTreatment.TINT.is_equal_approx(Color(0.88, 0.90, 0.97)),
		"the accepted cool tint is %s, not (0.88, 0.90, 0.97)" % ExteriorReviewTreatment.TINT)
	_expect(landing.treatment.candidate_active(),
		"the canonical scene did not apply the accepted material treatment")
	_expect(landing.lighting.mode == ExteriorReviewLighting.Mode.CANDIDATE,
		"the canonical scene is not in the accepted exterior lighting state")
	_expect(landing.treatment.surface_count() > 0,
		"the treatment registered no surface at all")
	print("  %d surfaces treated; %d authored surfaces registered, %d Rift surfaces excluded" % [
		landing.treatment.surface_count(), layout.authored_surfaces(),
		layout.unregistered_authored_surfaces(),
	])
	# The safety rule: raw imported materials are never written to.
	var drifted: PackedStringArray = landing.treatment.drifted_sources()
	_expect(drifted.is_empty(),
		"%d imported source material(s) drifted: %s" % [drifted.size(), ", ".join(drifted)])
	print("  source-material drift: %d" % drifted.size())
	# §6.5: no neutral/source comparison toggle is exposed.
	var review_source: String = _code_only(FileAccess.get_file_as_string(
		"res://scripts/first_mvp/severed_threshold/riftfall_landing_review.gd"
	))
	var landing_source: String = _code_only(FileAccess.get_file_as_string(
		"res://scripts/first_mvp/severed_threshold/riftfall_landing.gd"
	))
	var toggles: PackedStringArray = PackedStringArray()
	for forbidden: String in ["Mode.NEUTRAL", "set_candidate(false)", "toggle()"]:
		if review_source.contains(forbidden) or landing_source.contains(forbidden):
			toggles.append(forbidden)
	_expect(toggles.is_empty(),
		"Gate 1C exposes a neutral/source comparison toggle: %s" % ", ".join(toggles))
	# The lighting values are the Gate 1B candidate ones, unmoved.
	var lighting_values: Array[Dictionary] = [
		{"what": "ambient energy", "is": ExteriorReviewLighting.CANDIDATE_AMBIENT_ENERGY, "want": 0.48},
		{"what": "key energy", "is": ExteriorReviewLighting.CANDIDATE_KEY_ENERGY, "want": 1.25},
		{"what": "shadow opacity", "is": ExteriorReviewLighting.CANDIDATE_SHADOW_OPACITY, "want": 0.85},
		{"what": "fog density", "is": ExteriorReviewLighting.CANDIDATE_FOG_DENSITY, "want": 0.0032},
		{"what": "lantern energy", "is": ExteriorReviewLighting.LANTERN_ENERGY, "want": 4.0},
	]
	for entry: Dictionary in lighting_values:
		_expect(is_equal_approx(float(entry["is"]), float(entry["want"])),
			"the candidate %s is %.4f, not the Gate 1B %.4f" % [
				entry["what"], float(entry["is"]), float(entry["want"]),
			])
	print("  candidate lighting values unchanged from Gate 1B, including fog density %.4f" % (
		ExteriorReviewLighting.CANDIDATE_FOG_DENSITY
	))
	# The single §6.5 tune, proved in both directions: the SHARED component still
	# holds the value both closed Gate 1B scenes were accepted with, and this scene
	# holds the one named difference.
	var live: Dictionary = landing.measurements()
	print("  exterior ambient energy: Gate 1B %.2f (component, unchanged) -> Gate 1C %.2f (live)" % [
		float(live["ambient_energy_gate_1b"]), float(live["ambient_energy"]),
	])
	_expect(is_equal_approx(
		ExteriorReviewLighting.CANDIDATE_AMBIENT_ENERGY, RiftfallLanding.GATE_1B_AMBIENT_ENERGY
	), "the shared lighting component's ambient energy is no longer the Gate 1B value")
	_expect(is_equal_approx(
		float(live["ambient_energy"]), RiftfallLanding.EXTERIOR_AMBIENT_ENERGY
	), "the live exterior ambient energy is %.4f, not the declared Gate 1C tune %.4f" % [
		float(live["ambient_energy"]), RiftfallLanding.EXTERIOR_AMBIENT_ENERGY,
	])
	# And nothing else in the accepted direction moved with it.
	var sky_environment: Environment = (
		(landing.get_node("WorldEnvironment") as WorldEnvironment).environment
	)
	_expect(sky_environment.fog_enabled
			and is_equal_approx(sky_environment.fog_density,
				ExteriorReviewLighting.CANDIDATE_FOG_DENSITY)
			and sky_environment.tonemap_mode == Environment.TONE_MAPPER_FILMIC
			and not sky_environment.glow_enabled
			and not sky_environment.adjustment_enabled,
		"the exterior environment differs from the accepted candidate state beyond ambient energy")
	_expect(landing.lighting.lantern_count() > 0,
		"the Landing placed no lantern light at all")
	print("  %d lantern lights, the only warm light in the Landing" % (
		landing.lighting.lantern_count()
	))


# --- 6. §7's repeating stone --------------------------------------------------

func _check_loop_event() -> void:
	print("")
	print("--- §7: the repeating stone, observed through the production object")
	_expect(loop_event != null, "the repeating-stone event was never built")
	if loop_event == null:
		return
	# Timing bands.
	var bands: Array[Dictionary] = [
		{"what": "REST", "is": RiftfallLoopEvent.REST_SECONDS, "low": 0.35, "high": 0.55},
		{"what": "ROLL", "is": RiftfallLoopEvent.ROLL_SECONDS, "low": 0.90, "high": 1.30},
		{"what": "IMPACT_HOLD", "is": RiftfallLoopEvent.IMPACT_SECONDS, "low": 0.30, "high": 0.50},
		{"what": "IMPOSSIBLE_RETURN", "is": RiftfallLoopEvent.RETURN_SECONDS, "low": 0.08, "high": 0.15},
	]
	for band: Dictionary in bands:
		_expect(float(band["is"]) >= float(band["low"]) and float(band["is"]) <= float(band["high"]),
			"%s lasts %.3f s, outside §7's %.2f - %.2f s" % [
				String(band["what"]), float(band["is"]), float(band["low"]), float(band["high"]),
			])
	var travel: float = RiftfallLoopEvent.travel_distance()
	print("  travel %.4f m on a %.2f degree grade; cycle %.3f s" % [
		travel, RiftfallLoopEvent.grade_degrees(), RiftfallLoopEvent.CYCLE_SECONDS,
	])
	_expect(travel >= 1.25 and travel <= 2.00,
		"the stone travels %.3f m, outside §7's 1.25 - 2.00 m" % travel)
	_expect(RiftfallLoopEvent.grade_degrees() > 0.5,
		"the stone rolls on a %.2f degree grade; §7 asks for a visible one"
		% RiftfallLoopEvent.grade_degrees())
	# The return must be an order of magnitude faster than the roll, which is what
	# makes it unreadable as ordinary reverse motion.
	_expect(RiftfallLoopEvent.ROLL_SECONDS / RiftfallLoopEvent.RETURN_SECONDS >= 7.0,
		"the return is only %.1fx faster than the roll" % (
			RiftfallLoopEvent.ROLL_SECONDS / RiftfallLoopEvent.RETURN_SECONDS
		))
	# At least two complete cycles during an ordinary first traversal.
	var traversal_seconds: float = landing.route_path_length() / ACCEPTED_MAX_SPEED
	_expect(traversal_seconds / RiftfallLoopEvent.CYCLE_SECONDS >= 2.0,
		"only %.1f cycles fit into a %.1f s traversal" % [
			traversal_seconds / RiftfallLoopEvent.CYCLE_SECONDS, traversal_seconds,
		])

	# It touches nothing.
	_expect(_count_nodes_of_type(loop_event, "CollisionShape3D") == 0
			and _count_nodes_of_type(loop_event, "StaticBody3D") == 0
			and _count_nodes_of_type(loop_event, "Area3D") == 0,
		"the repeating stone owns collision")
	_expect(_count_nodes_of_type(loop_event, "NavigationObstacle3D") == 0,
		"the repeating stone carves the navigation mesh")
	var stone_source: String = _code_only(FileAccess.get_file_as_string(
		"res://scripts/first_mvp/severed_threshold/riftfall_loop_event.gd"
	))
	var stone_faults: PackedStringArray = PackedStringArray()
	for forbidden: String in [
		"RigidBody3D", "apply_impulse", "randf", "randi", "RandomNumberGenerator",
		"Area3D", "damage", "interact", "player", "Player", "body_entered",
		"get_first_node_in_group",
	]:
		if stone_source.contains(forbidden):
			stone_faults.append(forbidden)
	_expect(stone_faults.is_empty(),
		("the repeating stone names %s; §7 forbids physics, randomness, interaction "
		+ "and any dependence on the player") % ", ".join(stone_faults))

	# OBSERVED, through the production object, across two complete cycles.
	loop_event.reset()
	await _settle(2)
	var seen: Dictionary = {}
	var frames: int = int(ceil(RiftfallLoopEvent.CYCLE_SECONDS * 2.6 * 60.0))
	var travelled_max: float = 0.0
	for i: int in frames:
		await get_tree().process_frame
		seen[loop_event.state_name()] = true
		travelled_max = maxf(travelled_max,
			loop_event.stone_position().distance_to(loop_event.rest_position()))
	print("  states observed over %d idle frames: %s" % [frames, ", ".join(seen.keys())])
	print("  completed cycles %d, event clock %.2f s, furthest travel %.4f m" % [
		loop_event.cycle_count, loop_event.simulation_seconds, travelled_max,
	])
	for required: String in ["REST", "ROLL", "IMPACT_HOLD", "IMPOSSIBLE_RETURN"]:
		_expect(seen.has(required),
			"the state '%s' never occurred in %d observed frames" % [required, frames])
	_expect(loop_event.cycle_count >= 2,
		"only %d complete cycles ran in %.2f s of event time" % [
			loop_event.cycle_count, loop_event.simulation_seconds,
		])
	_expect(absf(travelled_max - travel) <= 0.02,
		"the stone reached %.4f m from rest against an authored %.4f m" % [travelled_max, travel])

	# Determinism: the same elapsed time produces the same state and cycle count.
	var first: Dictionary = _sample_loop(3.17)
	var second: Dictionary = _sample_loop(3.17)
	print("  determinism: %s / cycle %d, then %s / cycle %d after the same 3.17 s" % [
		String(first["state"]), int(first["cycles"]),
		String(second["state"]), int(second["cycles"]),
	])
	_expect(String(first["state"]) == String(second["state"])
			and int(first["cycles"]) == int(second["cycles"])
			and first["position"].distance_to(second["position"]) < 0.0005,
		"two identical 3.17 s runs produced different results")

	# §7: developer reset returns the exact initial state AND cycle count.
	loop_event.reset()
	_expect(loop_event.state == RiftfallLoopEvent.State.REST
			and loop_event.cycle_count == 0
			and is_zero_approx(loop_event.state_elapsed)
			and is_zero_approx(loop_event.simulation_seconds)
			and loop_event.stone_position().distance_to(loop_event.rest_position()) < 0.0005
			and is_zero_approx(loop_event.stone_rotation_degrees()),
		"the reset did not restore the exact initial state, pose and counters")
	print("  reset restores REST, cycle 0, the rest position and zero rotation")


## Drives the production object for an exact simulated duration, so "the same
## elapsed time gives the same answer" is a measurement rather than a hope. The
## node's own `_process` is suspended for the duration so the two clocks cannot
## interleave; this is the SAME object the player sees, not a copy of the timing.
func _sample_loop(seconds: float) -> Dictionary:
	loop_event.process_mode = Node.PROCESS_MODE_DISABLED
	loop_event.reset()
	var step: float = 1.0 / 60.0
	var elapsed: float = 0.0
	while elapsed < seconds - 0.000001:
		loop_event.advance(minf(step, seconds - elapsed))
		elapsed += step
	var sample: Dictionary = {
		"state": loop_event.state_name(),
		"cycles": loop_event.cycle_count,
		"position": loop_event.stone_position(),
	}
	loop_event.process_mode = Node.PROCESS_MODE_INHERIT
	return sample


# --- 7. §8's sockets ----------------------------------------------------------

func _check_sockets() -> void:
	print("")
	print("--- §8: the five canonical sockets are spatial contracts, not triggers")
	var missing_sockets: PackedStringArray = PackedStringArray()
	for required: String in [
		"PlayerSpawn", "ExitToBrokenWatch", "RiftScarFocus", "RepeatingStoneFocus",
		"WatchSilhouetteFocus",
	]:
		var marker: Marker3D = layout.socket(required)
		if marker == null:
			missing_sockets.append(required)
			continue
		print("  %-22s %s" % [required, marker.global_position])
	_expect(missing_sockets.is_empty(),
		"§8 sockets are missing: %s" % ", ".join(missing_sockets))
	_expect(landing.point_is_navigable(landing.player_spawn()),
		"the PlayerSpawn socket is not on the navigation mesh")
	_expect(landing.point_is_navigable(landing.exit_socket()),
		"the ExitToBrokenWatch socket is not on the navigation mesh")
	_expect(landing.point_is_navigable(landing.rift_scar_focus()),
		"the RiftScarFocus socket is not on walkable ground")
	# The exit lies BEYOND the breach with honest ground past it.
	var exit_local: Vector2 = RiftfallLandingLayout.CENTRELINE[RiftfallLandingLayout.EXIT_INDEX]
	var breach_local: Vector2 = RiftfallLandingLayout.CENTRELINE[
		RiftfallLandingLayout.BREACH_INDEX
	]
	_expect(exit_local.y < breach_local.y,
		"the exit socket is not beyond the breach")
	var beyond: float = 0.0
	for region: Dictionary in RiftfallLandingLayout.WALKABLE:
		var rect: Rect2 = region["rect"]
		if rect.has_point(exit_local):
			beyond = maxf(beyond, exit_local.y - rect.position.y)
	print("  ground beyond the exit socket: %.2f m" % beyond)
	_expect(beyond >= 3.0,
		"only %.2f m of ground lies beyond the exit socket; §6.2 asks for enough to cross it"
		% beyond)
	# Crossing the exit does nothing.
	var review_source: String = _code_only(FileAccess.get_file_as_string(
		"res://scripts/first_mvp/severed_threshold/riftfall_landing_review.gd"
	))
	# Precise tokens, because a crude one is worse than none: "quest" alone matches
	# the word `requested`, which is the name the shared pointer kernel gives the
	# raw click point, and a check that fires on that proves nothing about scope.
	var wrapper_faults: PackedStringArray = PackedStringArray()
	for forbidden: String in [
		"change_scene", "broken_watch", "BrokenWatch", "nexus", "Nexus",
		"checkpoint", "quest_", "objective", "milestone",
	]:
		if review_source.contains(forbidden):
			wrapper_faults.append(forbidden)
	_expect(wrapper_faults.is_empty(),
		("the wrapper names %s; §8 says crossing the exit loads, opens and stores "
		+ "nothing") % ", ".join(wrapper_faults))
	print("  crossing the exit loads no level, stores no progress and opens no quest")


# --- 8. §10's navigation and movement proof -----------------------------------

func _check_navigation() -> void:
	print("")
	print("--- §10: navigation baked once over the intended footprint")
	print("  %d polygons, %.2f m^2 walkable, highest navmesh vertex y = %.4f" % [
		landing.navmesh_polygon_count, landing.navmesh_area, landing.navmesh_surface_y,
	])
	_expect(landing.bake_count == 1,
		"the navigation mesh was baked %d times; exactly one bake is owed" % landing.bake_count)
	_expect(landing.navmesh_polygon_count > 0 and landing.navmesh_area > 0.0,
		"the navigation bake produced nothing")
	# The navmesh must be smaller than the authored footprint (agent-radius
	# erosion) and not wildly smaller (a bake that lost the route).
	_expect(landing.navmesh_area < layout.footprint_area(),
		"the navigation mesh (%.1f m^2) is not smaller than the authored footprint (%.1f m^2)"
		% [landing.navmesh_area, layout.footprint_area()])
	_expect(landing.navmesh_area > layout.footprint_area() * 0.65,
		"the navigation mesh is only %.1f%% of the authored footprint"
		% (landing.navmesh_area / layout.footprint_area() * 100.0))
	# Gate 1B's engine finding: a baked surface placed above the character's feet
	# puts every path point outside the agent's own three-dimensional tolerance.
	_expect(landing.navmesh_surface_y <= 0.30,
		("the baked surface sits at y = %.4f; the body stands at 0.000 and the agent "
		+ "measures its 0.40 m path tolerance in three dimensions")
		% landing.navmesh_surface_y)
	# No walkable bank top, no out-of-bounds ground, no phantom interior.
	var phantoms: PackedStringArray = PackedStringArray()
	for entry: Dictionary in layout.solids():
		var solid_name: String = String(entry["name"])
		if solid_name == "Ground":
			continue
		var box: AABB = entry["aabb"]
		if box.size.x < 1.2 or box.size.z < 1.2:
			continue
		var centre_local: Vector3 = Vector3(box.get_center().x, 0.0, box.get_center().z)
		var centre_world: Vector3 = layout.global_transform * centre_local
		if landing.point_is_navigable(centre_world, 0.60):
			phantoms.append(solid_name)
	_expect(phantoms.is_empty(),
		"%d solid(s) keep a walkable interior: %s" % [phantoms.size(), ", ".join(phantoms)])
	print("  no phantom walkable island inside any of the %d carved solids" % (
		layout.carving_solids()
	))
	# Out of bounds is out of bounds.
	var outside_points: Array[Vector3] = [
		Vector3(0.0, 0.0, 60.0), Vector3(0.0, 0.0, -60.0),
		Vector3(60.0, 0.0, 0.0), Vector3(-60.0, 0.0, 0.0),
	]
	var reachable_outside: int = 0
	for at: Vector3 in outside_points:
		if landing.point_is_navigable(layout.global_transform * at, 1.0):
			reachable_outside += 1
	_expect(reachable_outside == 0,
		"%d of %d far out-of-bounds probes landed on the navigation mesh" % [
			reachable_outside, outside_points.size(),
		])

	# A lattice of principal ground, with every INTENDED sample reachable. A sample
	# counts as intended only when a 0.95 m disc around it is entirely walkable and
	# unblocked, and that radius is DERIVED rather than guessed: Recast ceils the
	# 0.40 m agent radius to a whole number of 0.15 m cells (0.45 m) and rasterises
	# the boundary onto the same grid, so the walkable surface legitimately stops up
	# to 0.45 + 2 cells from a solid. The first build used 0.75 m and reported one
	# unreachable sample that was in fact correctly eroded ground beside a lantern.
	var intended: int = 0
	var unreachable: PackedStringArray = PackedStringArray()
	var rect: Rect2 = layout.arena_rect()
	var x: float = rect.position.x
	while x <= rect.end.x:
		var z: float = rect.position.y
		while z <= rect.end.y:
			var at: Vector2 = Vector2(x, z)
			if _disc_is_clear(at, 0.95):
				intended += 1
				if not landing.point_is_navigable(
					layout.global_transform * Vector3(at.x, 0.0, at.y), 0.45
				):
					if unreachable.size() < 8:
						unreachable.append("(%.1f, %.1f)" % [at.x, at.y])
			z += 2.0
		x += 2.0
	print("  principal-ground lattice: %d intended samples, %d unreachable" % [
		intended, unreachable.size(),
	])
	_expect(intended > 200, "only %d lattice samples counted as intended ground" % intended)
	_expect(unreachable.is_empty(),
		"%d intended ground sample(s) are unreachable: %s" % [
			unreachable.size(), ", ".join(unreachable),
		])
	await _settle(1)


func _disc_is_clear(at: Vector2, radius: float) -> bool:
	if not layout.is_walkable_point(at) or layout.is_blocked_point(at):
		return false
	for i: int in 8:
		var angle: float = TAU * float(i) / 8.0
		var probe: Vector2 = at + Vector2(cos(angle), sin(angle)) * radius
		if not layout.is_walkable_point(probe) or layout.is_blocked_point(probe):
			return false
	return true


## §10: "The automated traversal may control the shared production movement object
## for verification. It may not teleport between path samples and then claim the
## route was walked." So exactly one command is issued and the body walks.
func _check_traversal() -> void:
	print("")
	print("--- §10: spawn to exit, walked by the production movement object")
	review.reset_review()
	await _settle(6)
	var start: Vector3 = player.global_position
	var goal: Vector3 = landing.exit_socket()
	var resolution: Dictionary = review.resolve_to_navigation(goal)
	player.command_move_to(resolution["point"], goal, bool(resolution["adjusted"]))
	var frames: int = 0
	var walked_from: float = review.walked_metres
	while frames < 2400:
		await get_tree().physics_frame
		frames += 1
		if player.global_position.distance_to(goal) <= 1.0:
			break
	var walked: float = review.walked_metres - walked_from
	var straight: float = start.distance_to(goal)
	print("  walked %.2f m in %d physics frames (%.2f s of simulation)" % [
		walked, frames, float(frames) / 60.0,
	])
	print("  straight-line spawn to exit %.2f m; resolved path %.2f m; centreline %.2f m" % [
		straight, landing.route_path_length(), layout.centreline_length(),
	])
	_expect(player.global_position.distance_to(goal) <= 1.2,
		"the body stopped %.2f m from the exit socket after %d frames" % [
			player.global_position.distance_to(goal), frames,
		])
	# The loop stops the measurement 1.0 m short of the socket, so the walked
	# distance is compared against the straight line MINUS that tolerance. It still
	# proves the body traversed rather than being teleported between path samples,
	# which §10 forbids.
	_expect(walked >= straight - 1.5,
		"the body covered %.2f m to reach a point %.2f m away; it did not walk the route" % [
			walked, straight,
		])
	_expect(walked <= layout.centreline_length() * 1.6,
		"the body walked %.2f m to cover a %.2f m route" % [walked, layout.centreline_length()])
	_expect(review.exit_reached, "the wrapper never recorded the exit socket as reached")
	# And reaching it did exactly nothing: the wrapper is still the running tree,
	# the canonical scene is still its child, and no scene was swapped underneath.
	_expect(review.is_inside_tree() and landing.is_inside_tree()
			and landing.get_parent() == review,
		"reaching the exit socket changed the running scene tree")
	review.reset_review()
	await _settle(6)
	_expect(player.global_position.distance_to(landing.player_spawn()) < 0.30,
		"the reset left the body %.2f m from the spawn"
		% player.global_position.distance_to(landing.player_spawn()))


func _check_collision_and_cursor() -> void:
	print("")
	print("--- §10: collision stop distance, and honest cursor resolution")
	# Walk into a boundary bank and stop at the capsule radius.
	review.reset_review()
	await _settle(4)
	var wall: Dictionary = layout.solid("BankScarWest")
	_expect(not wall.is_empty(), "the west scar bank does not exist")
	if not wall.is_empty():
		var box: AABB = wall["aabb"]
		var start_local: Vector2 = Vector2(box.end.x + 4.0, box.get_center().z)
		await _teleport(layout.global_transform * Vector3(start_local.x, 0.0, start_local.y))
		var push: Vector3 = (layout.global_transform.basis * Vector3(-1.0, 0.0, 0.0)).normalized()
		review.set_stick_override(Vector2(
			push.dot(review.camera_rig.ground_right()),
			-push.dot(review.camera_rig.ground_forward())
		))
		await _settle(150)
		review.set_stick_override(null)
		await _settle(10)
		var local_now: Vector3 = layout.global_transform.affine_inverse() * player.global_position
		var gap: float = local_now.x - box.end.x
		print("  the body stops %.3f m from the bank face against a %.2f m capsule radius" % [
			gap, 0.40,
		])
		_expect(gap >= 0.34 and gap <= 0.70,
			"the body stopped %.3f m from the bank face; the capsule radius is 0.40 m" % gap)
	await _release_all_inputs()

	# A click on a blocked footprint and a click well out of bounds must both
	# resolve honestly rather than being accepted or silently dropped.
	var mass: Dictionary = layout.solid("BreachMassWest")
	_expect(not mass.is_empty(), "the west breach mass does not exist")
	if not mass.is_empty():
		var mass_box: AABB = mass["aabb"]
		var blocked_local: Vector3 = Vector3(
			mass_box.get_center().x, 0.0, mass_box.get_center().z
		)
		var blocked: Dictionary = review.resolve_to_navigation(
			layout.global_transform * blocked_local
		)
		_expect(bool(blocked["adjusted"]),
			"a click inside a solid breach mass resolved as if it were walkable")
		_expect(landing.point_is_navigable(blocked["point"]),
			"a click inside a solid resolved to a point that is not on the navigation mesh")
	var far: Dictionary = review.resolve_to_navigation(
		layout.global_transform * Vector3(0.0, 0.0, 90.0)
	)
	_expect(bool(far["adjusted"]) and landing.point_is_navigable(far["point"]),
		"a click 90 m out of bounds did not resolve to a navigable point")
	print("  blocked and out-of-bounds clicks resolve to navigable ground, marked adjusted")

	# Cursor rays from all four screen corners.
	await _teleport(landing.repeating_stone_focus())
	await _settle(4)
	var viewport: Vector2 = get_viewport().get_visible_rect().size
	var corners: Array[Vector2] = [
		Vector2(2.0, 2.0), Vector2(viewport.x - 2.0, 2.0),
		Vector2(2.0, viewport.y - 2.0), Vector2(viewport.x - 2.0, viewport.y - 2.0),
	]
	var corner_failures: PackedStringArray = PackedStringArray()
	for corner: Vector2 in corners:
		var hit: Dictionary = review.ground_point_under_cursor(corner)
		if not bool(hit.get("valid", false)):
			corner_failures.append("%s produced no ground point" % corner)
			continue
		var resolved: Dictionary = review.resolve_to_navigation(hit["point"])
		if not landing.point_is_navigable(resolved["point"]):
			corner_failures.append("%s resolved off the navigation mesh" % corner)
	print("  four screen corners at %d x %d: %d honest, %d faulty" % [
		int(viewport.x), int(viewport.y), corners.size() - corner_failures.size(),
		corner_failures.size(),
	])
	_expect(corner_failures.is_empty(),
		"cursor rays failed at %d corner(s): %s" % [
			corner_failures.size(), ", ".join(corner_failures),
		])
	# THE ANALYTIC CLAIM, CROSS-CHECKED THROUGH THE PRODUCTION CAMERA. Deriving a
	# number and then asserting the same derivation proves only that arithmetic is
	# repeatable; this asks the real `Camera3D` what is in its frustum.
	var sighting: Dictionary = landing.silhouette_sighting()
	var mass_centre: Vector3 = sighting["probe"]
	await _teleport(landing.player_spawn())
	await _settle(8)
	var seen_from_spawn: bool = review.camera_rig.camera.is_position_in_frustum(mass_centre)
	await _teleport(landing.exit_socket())
	await _settle(8)
	var seen_from_exit: bool = review.camera_rig.camera.is_position_in_frustum(mass_centre)
	print("  the Watch massing in the real camera frustum: from the spawn %s, from the exit %s" % [
		str(seen_from_spawn), str(seen_from_exit),
	])
	_expect(not seen_from_spawn,
		"the production camera does see the Watch massing from the spawn; the 13.53 m visible band is wrong")
	_expect(seen_from_exit,
		"the production camera cannot see the Watch massing even from the exit socket")
	_expect(float(sighting["visible_from_along"]) >= 0.0,
		"the analytic sighting and the production camera disagree about the Watch massing")
	review.reset_review()
	await _settle(4)


func _check_controller_and_input() -> void:
	print("")
	print("--- §10: controller alignment, deadzone, and mouse-to-stick takeover")
	review.reset_review()
	await _teleport(landing.rift_scar_focus())
	await _settle(4)

	# Full stick forward must move away from the camera, not toward world -Z.
	var before: Vector3 = player.global_position
	review.set_stick_override(Vector2(0.0, -1.0))
	await _settle(60)
	var moved: Vector3 = player.global_position - before
	review.set_stick_override(null)
	await _release_all_inputs()
	var planar: Vector3 = Vector3(moved.x, 0.0, moved.z)
	print("  full stick forward moved %.2f m at %.1f degrees from the camera forward axis" % [
		planar.length(), rad_to_deg(planar.angle_to(review.camera_rig.ground_forward())),
	])
	_expect(planar.length() > 1.0, "a full stick moved the body only %.2f m" % planar.length())
	_expect(planar.angle_to(review.camera_rig.ground_forward()) < deg_to_rad(12.0),
		"a full stick forward moved %.1f degrees off the camera forward axis"
		% rad_to_deg(planar.angle_to(review.camera_rig.ground_forward())))

	# Inside the deadzone nothing moves. The body must be genuinely AT REST before
	# the sample is taken: releasing the controls only stops the intent, and a
	# 5.0 m/s body braking at 40 m/s^2 still carries about 0.31 m of travel, which
	# would otherwise be measured as deadzone drift that never happened.
	await _await_body_at_rest()
	before = player.global_position
	review.set_stick_override(Vector2(0.0, -ACCEPTED_DEADZONE * 0.6))
	await _settle(40)
	var drift: float = Vector2(
		player.global_position.x - before.x, player.global_position.z - before.z
	).length()
	review.set_stick_override(null)
	await _release_all_inputs()
	print("  a stick at %.2f (inside the %.2f deadzone) moved the body %.4f m" % [
		ACCEPTED_DEADZONE * 0.6, ACCEPTED_DEADZONE, drift,
	])
	_expect(drift < 0.02, "a stick inside the deadzone moved the body %.4f m" % drift)

	# A stick command takes over an older mouse destination.
	var goal: Vector3 = landing.repeating_stone_focus()
	var resolution: Dictionary = review.resolve_to_navigation(goal)
	player.command_move_to(resolution["point"], goal, bool(resolution["adjusted"]))
	await _settle(10)
	_expect(player.movement_mode_name().to_lower().contains("mouse"),
		"a mouse command did not put the body into a mouse movement mode (%s)"
		% player.movement_mode_name())
	review.set_stick_override(Vector2(0.0, -1.0))
	await _settle(20)
	print("  after a stick command the movement mode is '%s'" % player.movement_mode_name())
	_expect(player.movement_mode_name().to_lower().contains("controller"),
		"the stick did not take over the older mouse destination (%s)"
		% player.movement_mode_name())
	review.set_stick_override(null)
	await _release_all_inputs()

	# §2: no combat. The combat actions are refused by name and counted.
	var refused_before: int = review.refused_action_inputs
	for action: StringName in [&"quick_strike", &"attack_in_place", &"interact"]:
		var press: InputEventAction = InputEventAction.new()
		press.action = action
		press.pressed = true
		Input.parse_input_event(press)
		await _settle(2)
	print("  combat and interaction inputs refused this session: %d" % (
		review.refused_action_inputs - refused_before
	))
	_expect(review.refused_action_inputs - refused_before == 3,
		"%d of 3 combat inputs were refused and counted"
		% (review.refused_action_inputs - refused_before))
	review.reset_review()
	await _settle(4)


func _check_overlay_and_reset() -> void:
	print("")
	print("--- §9: a clean default view, five physical keys, and an exact reset")
	review.reset_review()
	await _await_process_frames(3)
	_expect(not review.overlay_visible and not review.grid_visible
			and not review.diagnostics_visible,
		"the default view is not clean: overlay=%s grid=%s roles=%s" % [
			str(review.overlay_visible), str(review.grid_visible),
			str(review.diagnostics_visible),
		])
	_expect(not layout.grid_visible and not layout.diagnostics_visible,
		"the layout's own diagnostic meshes are visible in the default view")
	# The one line §9 permits is always drawn.
	var identity: Control = _find_control(review, "IdentityLine")
	_expect(identity != null and identity.visible,
		"the small developer-build identification line is missing from the clean view")

	# The three view toggles.
	review.set_overlay_visible(true)
	review.set_grid_visible(true)
	review.set_diagnostics_visible(true)
	await _await_process_frames(4)
	_expect(review.overlay_visible and layout.grid_visible and layout.diagnostics_visible,
		"F3, F6 or F7 did not turn its view on")
	_expect(landing.bake_count == 1,
		"turning a diagnostic view on rebaked navigation (%d bakes)" % landing.bake_count)

	# §9's required overlay content.
	var text: String = _visible_text_in(review)
	var unsaid: PackedStringArray = PackedStringArray()
	for required: String in [
		"Riftfall Landing", "Gate 1C", "footprint", "centreline", "walked", "Watch breach",
		"navigation mesh", "clear of collision", "state", "cycles", "input", "absorbed",
		"exit socket", "drift", "saturation", "camera", "movement speed", "cycle",
	]:
		if not text.to_lower().contains(required.to_lower()):
			unsaid.append(required)
	_expect(unsaid.is_empty(),
		"§9 requires the F3 overlay to report %s; it never says them" % ", ".join(unsaid))

	# Clicking the overlay must not move the body, place a marker or change the loop.
	var absorbed_before: int = review.ui_clicks_absorbed
	var accepted_before: int = review.accepted_commands
	var position_before: Vector3 = player.global_position
	var cycles_before: int = landing.loop_event.cycle_count
	var panel: Control = _find_control(review, "InterfaceLeakTest")
	_expect(panel != null, "the interface leak-test panel does not exist")
	if panel != null:
		var centre: Vector2 = panel.get_global_rect().get_center()
		# `gui_get_hovered_control()` is updated by pointer MOTION, and `push_input`
		# transforms window coordinates unless told they are local. Gate 1A measured
		# both traps; a check that skips either one leaks a real command.
		var motion: InputEventMouseMotion = InputEventMouseMotion.new()
		motion.position = centre
		get_viewport().push_input(motion, true)
		await _await_process_frames(2)
		_expect(get_viewport().gui_get_hovered_control() != null,
			"the pointer is not over any Control at the leak panel's own centre")
		_expect(review.pointer_over_ui(),
			"the wrapper does not consider the pointer to be over its own interface")
		var click: InputEventMouseButton = InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.pressed = true
		click.position = centre
		get_viewport().push_input(click, true)
		await _await_process_frames(2)
		var release: InputEventMouseButton = InputEventMouseButton.new()
		release.button_index = MOUSE_BUTTON_LEFT
		release.position = centre
		get_viewport().push_input(release, true)
		await _settle(6)
	print("  a press on a panel: accepted %d -> %d, rejected %d -> %d" % [
		accepted_before, review.accepted_commands,
		review.rejected_commands, review.rejected_commands,
	])
	_expect(review.accepted_commands == accepted_before,
		"a click on the overlay issued a world movement command")
	_expect(player.global_position.distance_to(position_before) < 0.05,
		"a click on the overlay moved the body %.3f m"
		% player.global_position.distance_to(position_before))
	_expect(landing.loop_event.cycle_count >= cycles_before,
		"a click on the overlay reset the repeating stone")

	# THE SECOND LEAK PATH, and the one the wrapper's own counter exists for. A
	# press on a panel never reaches `_unhandled_input` at all — the Control tree
	# consumes it, which is the strongest possible absorption and is why the
	# counter above did not move. But a command that was STARTED on the world and
	# is still held re-issues every 0.10 s from `_process`, and that path has to
	# refuse the reissue itself when the cursor has since moved over the interface.
	if panel != null:
		# The starting point has to be over the WORLD, and "the left edge" is not a
		# safe way to say that: with the overlay open the left column reaches most of
		# the way down the frame, and the first rendered run started the hold on a
		# panel — where the Control tree correctly ate the press, so no hold ever
		# began and the check failed for the wrong reason. Candidates are tried until
		# one really has no Control under it.
		var size: Vector2 = get_viewport().get_visible_rect().size
		var world_point: Vector2 = size * 0.5
		for candidate: Vector2 in [
			size * Vector2(0.50, 0.50), size * Vector2(0.50, 0.30),
			size * Vector2(0.62, 0.62), size * Vector2(0.38, 0.44),
		]:
			var probe: InputEventMouseMotion = InputEventMouseMotion.new()
			probe.position = candidate
			get_viewport().push_input(probe, true)
			await _await_process_frames(2)
			if get_viewport().gui_get_hovered_control() == null:
				world_point = candidate
				break
		var to_world: InputEventMouseMotion = InputEventMouseMotion.new()
		to_world.position = world_point
		get_viewport().push_input(to_world, true)
		await _await_process_frames(2)
		_expect(get_viewport().gui_get_hovered_control() == null,
			"no point on screen is free of the overlay; the held-drag test cannot start")
		var press: InputEventMouseButton = InputEventMouseButton.new()
		press.button_index = MOUSE_BUTTON_LEFT
		press.pressed = true
		press.position = world_point
		get_viewport().push_input(press, true)
		Input.action_press(&"move_point")
		await _await_process_frames(2)
		var held_absorbed: int = review.ui_clicks_absorbed
		var over_panel: InputEventMouseMotion = InputEventMouseMotion.new()
		over_panel.position = panel.get_global_rect().get_center()
		get_viewport().push_input(over_panel, true)
		await _await_process_frames(24)
		Input.action_release(&"move_point")
		var up: InputEventMouseButton = InputEventMouseButton.new()
		up.button_index = MOUSE_BUTTON_LEFT
		up.position = panel.get_global_rect().get_center()
		get_viewport().push_input(up, true)
		await _release_all_inputs()
		print("  a HELD command dragged over a panel: absorbed %d -> %d" % [
			held_absorbed, review.ui_clicks_absorbed,
		])
		_expect(review.ui_clicks_absorbed > held_absorbed,
			"a held movement command dragged over the interface was not absorbed")
	player.clear_movement_intent("verification cleanup", false)
	await _settle(4)

	# The inherited camera-distance keys, and the reset that undoes them.
	review.camera_rig.adjust_distance(4.0)
	_expect(not review.camera_rig.is_default(),
		"the camera-distance key changed nothing")
	review.reset_review()
	await _await_process_frames(3)
	_expect(review.review_is_launch_state(),
		"the reset did not return every mode, the camera and the loop to the launch state")
	_expect(review.camera_rig.is_default()
			and is_equal_approx(review.camera_rig.distance_metres, ACCEPTED_CAMERA_DISTANCE),
		"the reset left the camera at %.2f m rather than the accepted %.1f m" % [
			review.camera_rig.distance_metres, ACCEPTED_CAMERA_DISTANCE,
		])
	_expect(review.ui_clicks_absorbed == 0 and review.accepted_commands == 0
			and review.walked_metres < 0.01 and not review.exit_reached,
		"the reset did not clear the session counters")
	print("  reset restores the clean view, the accepted camera, the loop and every counter")


# --- 9. Scope, storage, and the closed gates ----------------------------------

func _check_scope() -> void:
	print("")
	print("--- §2: nothing excluded entered the work")
	var excluded: Array[String] = [
		"attack", "quick_strike", "acquisition", "soft_target", "target_acquisition",
		"life", "mana", "damage", "graveblade", "enemy", "coordinator",
		"loot", "drop", "experience", "passive", "inventory", "equipment", "rarity",
		"affix", "craft", "forge", "hud", "settings", "saved_state", "lab_progress",
		"director", "story", "mara", "nexus", "riftmarked", "procedural", "generator",
		"run_graph", "module_library", "pursuit", "intensity", "broken_watch",
		"checkpoint", "portal", "transition",
	]
	var landing_members: PackedStringArray = PackedStringArray()
	var review_members: PackedStringArray = PackedStringArray()
	for forbidden: String in excluded:
		if forbidden in landing:
			landing_members.append(forbidden)
		if forbidden in review:
			review_members.append(forbidden)
	_expect(landing_members.is_empty(),
		"the canonical Landing has excluded members: %s" % ", ".join(landing_members))
	_expect(review_members.is_empty(),
		"the review wrapper has excluded members: %s" % ", ".join(review_members))
	var body_members: PackedStringArray = PackedStringArray()
	for forbidden: String in [
		"attack", "life", "mana", "weapon", "receive_damage", "physical_damage",
		"experience", "target", "inventory", "equip_weapon", "action_state",
	]:
		if forbidden in player:
			body_members.append(forbidden)
	_expect(body_members.is_empty(),
		"the review body has combat members: %s" % ", ".join(body_members))
	print("  %d excluded names checked against the Landing, the wrapper and the body"
		% excluded.size())
	print("  the Landing, the wrapper and the body carry geometry, review state and locomotion")

	var present: PackedStringArray = PackedStringArray()
	for type_name: String in [
		"PrototypeGraveblade", "QuickStrikeAction", "AttackCoordinator", "PrototypeTargetable",
		"PrototypeHUD", "PrototypeProgressionDirector", "PrototypeSettings", "PrototypeLabState",
		"PrototypeAudioDirector", "PrototypePlayer", "PrototypeZeroRoom",
		"ScaleCalibrationHall", "CalibrationFixtures", "ExteriorAssetCompatibilitySpike",
		"ExteriorCohesionComparison", "ExteriorCohesionRoute",
	]:
		if _count_script_class(review, type_name) > 0:
			present.append(type_name)
	_expect(present.is_empty(),
		"excluded systems exist inside the Gate 1C review tree: %s" % ", ".join(present))
	_expect(_count_nodes_of_type(review, "AudioStreamPlayer") == 0
			and _count_nodes_of_type(review, "AudioStreamPlayer3D") == 0,
		"Riftfall Landing plays audio; §2 authorizes none")
	_expect(_count_nodes_of_type(review, "Area3D") == 0,
		"an Area3D exists; §8 says the sockets are spatial contracts, not triggers")
	print("  no combat, progression, HUD, settings, save, hall, Gate 1B, audio or trigger object")

	# THE LATER WORK THAT MUST NOT BE STARTED, MOVED ONE FOR ONE BY D-219.
	#
	# Every row below is REPLACED rather than added to, so this check still emits
	# exactly the same number of assertions and Gate 1C stays at its locked 200.
	#
	# Two of the six paths named the Nexus Threshold and the Rift Nexus, which
	# D-219 authorizes and delivers; those became false BY AUTHORIZATION exactly
	# as Broken Watch's did under D-217, and the boundary moves to the next
	# milestone. The `broken_watch.*` rows are also replaced: they were already
	# stale after D-217 — Gate 1D's real files are `broken_watch_slice.*`, so
	# those two rows had been passing for the wrong reason ever since, and a row
	# that cannot fail is not a boundary.
	var started: PackedStringArray = PackedStringArray()
	for absent: String in [
		"res://scenes/first_mvp/first_footing.tscn",
		"res://scripts/first_mvp/first_footing.gd",
		"res://scenes/first_mvp/severed_threshold/severed_threshold_route.tscn",
		"res://scripts/first_mvp/run_graph.gd",
		"res://scripts/first_mvp/module_library.gd",
		"res://scripts/first_mvp/dungeon_recipe.gd",
	]:
		if ResourceLoader.exists(absent):
			started.append(absent)
	_expect(started.is_empty(),
		"later work has been started: %s; the canonical opening stops at First Footing"
		% ", ".join(started))
	_expect(not FileAccess.file_exists("res://../docs/testing/FIRST_MVP_VERTICAL_SLICE_REPORT.md"),
		"a first-MVP vertical-slice report exists; that work is not authorized")
	# Replaced one for one: the row this stands in for named
	# `FIRST_MVP_GATE_1D_SPECIFICATION.md`, which is not the filename Gate 1D
	# actually used, so it survived D-217 without ever being able to fail.
	_expect(not FileAccess.file_exists(
		"res://../design/FIRST_MVP_GATE_1F_FIRST_FOOTING_SPECIFICATION.md"),
		"a First Footing specification exists; that milestone is not authorized")
	print("  First Footing, the wider route, the run graph and the module library remain unstarted")


func _check_no_state_written() -> void:
	print("")
	print("--- §8: Gate 1C has no production storage path at all")
	var storage_faults: PackedStringArray = PackedStringArray()
	for path: String in SHIPPING_SCRIPTS:
		var source: String = _code_only(FileAccess.get_file_as_string(path))
		for forbidden: String in [
			"ConfigFile", "FileAccess.open", "ResourceSaver", "store_string",
			"store_line", "save_to_file", "get_file_as_string", "get_file_as_bytes",
			"DirAccess", "OS.get_user_data_dir",
		]:
			if source.contains(forbidden):
				storage_faults.append("%s names %s" % [path.get_file(), forbidden])
	_expect(storage_faults.is_empty(),
		"Gate 1C reaches storage: %s" % ", ".join(storage_faults))
	print("  %d shipping Gate 1C scripts, none of which opens, writes or names a store" % (
		SHIPPING_SCRIPTS.size()
	))


func _check_closed_gates_untouched() -> void:
	print("")
	print("--- §11.2: the closed Gate 1B instruments still stand, and stay isolated")
	var gone: PackedStringArray = PackedStringArray()
	for path: String in [
		"res://tests/gate_1b_exterior_asset_spike_verification.gd",
		"res://tests/gate_1b_exterior_cohesion_verification.gd",
		"res://scripts/first_mvp/calibration/gate_1a_verification.gd",
	]:
		if not FileAccess.file_exists(path):
			gone.append(path)
	_expect(gone.is_empty(), "closed-gate verifiers are missing: %s" % ", ".join(gone))
	# Neither closed Gate 1B script may load or instance a Gate 1C class.
	var leaked: PackedStringArray = PackedStringArray()
	for path: String in [
		"res://scripts/first_mvp/visual/exterior_cohesion_comparison.gd",
		"res://scripts/first_mvp/visual/exterior_cohesion_route.gd",
		"res://scripts/first_mvp/visual/exterior_cohesion_catalogue.gd",
		"res://scripts/first_mvp/visual/exterior_cohesion_overlay.gd",
		"res://scripts/first_mvp/visual/exterior_asset_compatibility_spike.gd",
		"res://scripts/first_mvp/visual/exterior_spike_layout.gd",
		"res://scripts/first_mvp/visual/exterior_spike_overlay.gd",
		"res://scripts/first_mvp/visual/exterior_asset_catalogue.gd",
		"res://scenes/first_mvp/visual/exterior_cohesion_comparison.tscn",
		"res://scenes/first_mvp/visual/exterior_asset_compatibility_spike.tscn",
	]:
		var source: String = FileAccess.get_file_as_string(path)
		for gate_1c: String in [
			"RiftfallLanding", "RiftfallLoopEvent", "riftfall_landing", "severed_threshold",
		]:
			if source.contains(gate_1c) and not leaked.has(path):
				leaked.append(path)
	_expect(leaked.is_empty(),
		"closed Gate 1B files name Gate 1C: %s" % ", ".join(leaked))
	# And the reused components were not forked.
	var shipping_source: String = ""
	for path: String in SHIPPING_SCRIPTS:
		shipping_source += _code_only(FileAccess.get_file_as_string(path))
	var unused_components: PackedStringArray = PackedStringArray()
	for reused_type: String in [
		"ExteriorReviewTreatment", "ExteriorReviewLighting", "ExteriorAssetProbe",
		"PrototypeCameraRig", "PrototypeGroundPointer", "PrototypeMouseHold",
		"PrototypeLocomotion", "InputFamilyTracker", "DestinationMarker",
	]:
		if not shipping_source.contains(reused_type):
			unused_components.append(reused_type)
	_expect(unused_components.is_empty(),
		"Gate 1C does not use %s; §3 forbids a second implementation"
		% ", ".join(unused_components))
	var clones: PackedStringArray = PackedStringArray()
	for cloned: String in ["shader_type spatial", "func read_stick_actions", "func ground_point("]:
		if shipping_source.contains(cloned):
			clones.append(cloned)
	_expect(clones.is_empty(),
		"Gate 1C re-implements %s instead of reusing the shared component"
		% ", ".join(clones))
	print("  every shared component is REUSED and none is forked or re-implemented")


func _check_surfaces_are_on_screen() -> void:
	print("")
	print("--- The overlay is actually on screen, not merely present in the tree")
	review.set_overlay_visible(true)
	await _await_process_frames(4)
	var viewport: Rect2 = get_viewport().get_visible_rect()
	var root: Control = review.overlay as Control
	print("  overlay root %s inside viewport %s" % [root.get_global_rect(), viewport.size])
	_expect(root.get_global_rect().size.x >= viewport.size.x - 1.0
			and root.get_global_rect().size.y >= viewport.size.y - 1.0,
		"the overlay root does not cover the viewport: %s" % root.get_global_rect())
	var offscreen: PackedStringArray = PackedStringArray()
	for panel_name: String in ["IdentityLine", "InterfaceLeakTest", "LogPanel"]:
		var panel: Control = _find_control(review, panel_name)
		if panel == null:
			offscreen.append("%s is missing" % panel_name)
			continue
		var rect: Rect2 = panel.get_global_rect()
		if rect.size.x <= 1.0 or rect.size.y <= 1.0 or not viewport.intersects(rect):
			offscreen.append("%s at %s" % [panel_name, rect])
	_expect(offscreen.is_empty(),
		"overlay surfaces are not on screen: %s" % ", ".join(offscreen))
	review.reset_review()
	await _await_process_frames(2)


# --- Rendered evidence (§12) --------------------------------------------------

func _capture_evidence() -> void:
	print("")
	print("--- §12: rendered evidence")
	var window: Vector2i = DisplayServer.window_get_size()
	if window.x <= 0 or window.y <= 0:
		window = Vector2i(get_viewport().get_visible_rect().size)
	var suffix: String = "%dx%d" % [window.x, window.y]
	var brief: bool = arguments.has("--shots-brief")
	review.reset_review()
	await _settle(6)

	if not brief:
		await _clean_shot("01_arrival_%s_clean" % suffix, landing.player_spawn(), 19.0)
		await _clean_shot("02_first_bearing_%s_clean" % suffix,
			_along_route(14.0), 19.0)
		await _stone_shot("03_stone_roll_%s_clean" % suffix,
			RiftfallLoopEvent.State.ROLL, 0.62)
		await _stone_shot("04_stone_impossible_return_%s_clean" % suffix,
			RiftfallLoopEvent.State.IMPOSSIBLE_RETURN, 0.45)
		await _clean_shot("05_watch_breach_%s_clean" % suffix, _along_route(45.0), 19.0)
		await _overview_shot("06_route_overview_%s_overlay" % suffix)
	else:
		await _clean_shot("07_arrival_%s_clean" % suffix, landing.player_spawn(), 19.0)
		await _clean_shot("08_watch_breach_%s_clean" % suffix, _along_route(45.0), 19.0)
	review.reset_review()
	await _settle(4)


func _along_route(metres: float) -> Vector3:
	var flat: Vector2 = layout.centreline_point(metres)
	return layout.global_transform * Vector3(flat.x, 0.0, flat.y)


func _clean_shot(stem: String, at: Vector3, distance: float) -> void:
	review.set_overlay_visible(false)
	review.set_grid_visible(false)
	review.set_diagnostics_visible(false)
	review.camera_rig.adjust_distance(distance - review.camera_rig.distance_metres)
	await _teleport(at)
	await _shoot(stem, 8)


## §12 names the roll and the impossible return specifically, and both are short.
## The event's own `_process` is suspended and the SAME production object is
## stepped to the wanted phase, so the frame is of the real machine at a real
## state rather than of a stand-in posed to look like one.
func _stone_shot(stem: String, wanted: RiftfallLoopEvent.State, phase: float) -> void:
	review.set_overlay_visible(false)
	review.set_grid_visible(false)
	review.set_diagnostics_visible(false)
	review.camera_rig.adjust_distance(17.0 - review.camera_rig.distance_metres)
	await _teleport(_along_route(28.0))
	loop_event.process_mode = Node.PROCESS_MODE_DISABLED
	loop_event.reset()
	var step: float = 1.0 / 240.0
	var guard: int = 0
	while guard < 4000:
		guard += 1
		loop_event.advance(step)
		if loop_event.state == wanted \
				and loop_event.state_elapsed >= RiftfallLoopEvent.state_duration(wanted) * phase:
			break
	print("  stone posed at %s, %.3f s into the state" % [
		loop_event.state_name(), loop_event.state_elapsed,
	])
	_expect(loop_event.state == wanted,
		"the stone could not be posed at %s for the evidence frame"
		% RiftfallLoopEvent.state_name_of(wanted))
	await _shoot(stem, 4)
	loop_event.process_mode = Node.PROCESS_MODE_INHERIT
	loop_event.reset()


## The one frame that must show the whole relationship. The accepted camera cannot
## pull back far enough to hold a 53 m route, so the rig's own calibration RANGE
## is widened for this single frame and restored immediately; the accepted 19 m
## default and the inherited `[` / `]` limits are untouched, which is asserted.
func _overview_shot(stem: String) -> void:
	var range_before: Vector2 = review.camera_rig.distance_range
	review.set_overlay_visible(true)
	review.set_diagnostics_visible(true)
	review.camera_rig.distance_range = Vector2(10.0, 96.0)
	review.camera_rig.adjust_distance(84.0 - review.camera_rig.distance_metres)
	await _teleport(_along_route(24.0))
	await _shoot(stem, 8)
	review.camera_rig.distance_range = range_before
	review.camera_rig.reset_calibration()
	_expect(review.camera_rig.distance_range == range_before
			and is_equal_approx(review.camera_rig.distance_metres, ACCEPTED_CAMERA_DISTANCE),
		"the overview frame left the camera calibration changed")
	await _settle(4)


func _shoot(name_stem: String, settle_frames: int) -> void:
	for i: int in settle_frames:
		await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var path: String = "%s/%s.png" % [_shot_dir, name_stem]
	get_viewport().get_texture().get_image().save_png(path)
	print("  screenshot: %s" % path)


# --- Helpers ------------------------------------------------------------------

func _await_navigation() -> void:
	for frame: int in 40:
		if NavigationServer3D.map_get_iteration_id(landing.navigation_map()) > 0 \
				and landing.point_is_navigable(landing.player_spawn()):
			return
		await get_tree().physics_frame


func _teleport(to: Vector3) -> void:
	review.set_stick_override(Vector2.ZERO)
	player.clear_movement_intent("verification teleport", false)
	player.global_position = Vector3(to.x, 0.0, to.z)
	player.velocity = Vector3.ZERO
	review.camera_rig.focus = player.global_position
	review.set_stick_override(null)
	await _settle(6)


## Putting the physical controls at rest is not the same as being allowed to act
## again: the wrapper lifts its neutral latch on its own, and this waits for it.
## The body is at rest when it has stopped, not when the controls have. A 5.0 m/s
## body braking at the accepted 40 m/s^2 still travels about 0.31 m.
func _await_body_at_rest() -> void:
	for frame: int in 90:
		if player.planar_speed() < 0.005:
			return
		await get_tree().physics_frame


func _release_all_inputs() -> void:
	review.set_stick_override(Vector2.ZERO)
	Input.action_release(&"move_point")
	for frame: int in 30:
		await get_tree().physics_frame
		if not player.awaiting_neutral:
			break
	review.set_stick_override(null)


func _settle(frames: int) -> void:
	for i: int in frames:
		await get_tree().physics_frame


## Anything built or updated in `_process` — overlay text, the hovered control —
## needs IDLE frames. `_settle()` waits on physics, and a loaded machine fits
## several physics steps inside one idle frame.
func _await_process_frames(frames: int) -> void:
	for i: int in frames:
		await get_tree().process_frame


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _argument_value(flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


func _code_only(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


func _count_nodes_of_type(node: Node, type_name: String) -> int:
	var total: int = 0
	for child: Node in node.get_children():
		if child.is_class(type_name):
			total += 1
		total += _count_nodes_of_type(child, type_name)
	return total


func _count_script_class(node: Node, class_name_wanted: String) -> int:
	var total: int = 0
	for child: Node in node.get_children():
		var script: Script = child.get_script() as Script
		if script != null and script.get_global_name() == StringName(class_name_wanted):
			total += 1
		total += _count_script_class(child, class_name_wanted)
	return total


func _find_control(node: Node, wanted: String) -> Control:
	for child: Node in node.get_children():
		if child.name == wanted and child is Control:
			return child
		var deeper: Control = _find_control(child, wanted)
		if deeper != null:
			return deeper
	return null


## Reading the right words out of a Control tree proves the words EXIST, not that
## anyone can see them; `_check_surfaces_are_on_screen` is the other half.
func _visible_text_in(node: Node) -> String:
	var found: String = ""
	for child: Node in node.get_children():
		var control: Control = child as Control
		if control != null and not control.visible:
			continue
		if child is Label:
			found += (child as Label).text + "\n"
		elif child is RichTextLabel:
			found += (child as RichTextLabel).get_parsed_text() + "\n"
		elif child is Button:
			found += (child as Button).text + "\n"
		found += _visible_text_in(child)
	return found
