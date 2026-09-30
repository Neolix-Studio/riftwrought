extends Node
## First-MVP Gate 1B — automated verification of the Exterior Cohesion
## Comparison (D-202), with the D-204 colour-atlas dependency correction.
##
## Specification §9 lists ten things this must prove. It proves what a machine CAN
## settle: that the extraction is exactly the authorized 21-model, four-licence,
## two-atlas, two-source-map manifest and every file is byte-identical to its
## in-archive original; that the 62 + 29 = 91 inventory arithmetic holds and is
## DERIVED rather than typed; that all nine Kenney 2025 models resolve their own
## kit's D-204 colour atlas at the point of use; that every candidate imports at root scale 1.0 and measures
## what the report says it measures; that the accepted world, camera, movement,
## and InputMap are untouched; that ONE composed route exists with the same
## footprint, the same clearances, the same threshold gap, the same reachable
## destination, and the same navigation mesh in all TWELVE mode combinations; that
## returning to source materials reproduces the imported presentation exactly;
## that no later first-MVP system leaked in; that nothing is written to disk; and
## that the visible surfaces are actually on screen.
##
## WHAT IT DELIBERATELY DOES NOT DECIDE. Specification §8: "Automated checks
## measure integrity and visibility; only the owner decides visual belonging."
## There is no assertion anywhere below about whether a candidate looks right, and
## nothing computes §8's "foreground, background-only, or rejected" status — §10
## reserves that for the project owner, and §11 leaves Gate 1B OPEN after
## automated success.
##
## A PROPERTY IS ASSERTED TO EXIST BEFORE ITS VALUE IS READ, throughout. That is
## not defensive tidiness: `Resource.get()` answers `null` for a name that is not
## there, `float(null)` throws, and a throw inside a check function aborts the
## WHOLE function while the suite still reports PASS. D-200 and D-201 measured
## exactly that in Gate 1A — one assertion of seven ran and six were silently
## skipped behind a green result.
##
## Run:  godot --headless --path game res://scenes/first_mvp/visual/exterior_cohesion_comparison.tscn -- --verify-1b-cohesion
##       godot --path game --resolution 1280x720 res://.../exterior_cohesion_comparison.tscn -- --verify-1b-cohesion --shots <dir>

const TICK: float = 1.0 / 60.0

## D-175's accepted contract. §7 requires every one of these to be preserved, and
## they are asserted against the objects the comparison actually built.
const ACCEPTED_MAX_SPEED: float = 5.0
const ACCEPTED_ACCELERATION: float = 30.0
const ACCEPTED_BRAKING: float = 40.0
const ACCEPTED_ARRIVAL_TOLERANCE: float = 0.20
const ACCEPTED_DEADZONE: float = 0.20
const ACCEPTED_SUBSTANTIAL_TURN: float = 35.0
const ACCEPTED_TURN_RATE: float = 720.0
const ACCEPTED_CAMERA_DISTANCE: float = 19.0
const ACCEPTED_CAMERA_PITCH: float = 55.0
const ACCEPTED_CAMERA_FOV: float = 45.0
const ACCEPTED_P: float = 0.80

## The complete InputMap this project declares. D-202 adds none of them and
## removes none: §6 requires physical developer keys, and this list is how that is
## proved rather than promised.
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

## Shipping D-202 code. The verification itself is excluded by construction — it
## lives under `tests/`, not under `scripts/first_mvp/` — so a scan for forbidden
## storage strings cannot be confused by the file that forbids them.
const SHIPPING_SCRIPTS: Array[String] = [
	"res://scripts/first_mvp/visual/exterior_cohesion_comparison.gd",
	"res://scripts/first_mvp/visual/exterior_cohesion_catalogue.gd",
	"res://scripts/first_mvp/visual/exterior_cohesion_route.gd",
	"res://scripts/first_mvp/visual/exterior_cohesion_overlay.gd",
]

## The first Gate 1B spike's files, reused unchanged. They are listed so the
## reuse is a checked fact rather than a claim in a comment.
const REUSED_SPIKE_SCRIPTS: Array[String] = [
	"res://scripts/first_mvp/visual/exterior_review_lighting.gd",
	"res://scripts/first_mvp/visual/exterior_review_treatment.gd",
	"res://scripts/first_mvp/visual/exterior_asset_probe.gd",
]

const ARCHITECTURE_MODES: Array[int] = [0, 1, 2]

## D-208 §11.2. The one Gate 1C path this closed instrument is aware of, and only
## in order to prove it stays outside.
const GATE_1C_CANONICAL_SCENE: String = (
	"res://scenes/first_mvp/severed_threshold/riftfall_landing.tscn"
)

var comparison: ExteriorCohesionComparison
var arguments: PackedStringArray = PackedStringArray()

var route: ExteriorCohesionRoute
var player: CalibrationHallPlayer

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _shot_dir: String = ""


func _ready() -> void:
	await run()


func run() -> void:
	route = comparison.route
	player = comparison.player
	_shot_dir = _argument_value("--shots")

	print("")
	print("=== First-MVP Gate 1B verification — Exterior Cohesion Comparison (D-202) ===")
	await _settle(10)

	_check_engine_and_entrypoint()
	_check_accepted_values_untouched()
	_check_input_map_untouched()
	_check_extraction_manifest()
	_check_licences_and_source_maps()
	_check_inventory_arithmetic()
	_report_measurements()
	_check_import_state()
	_check_route_composition()
	_check_navigation_and_clearance()
	await _check_mode_invariance()
	await _check_click_resolution()
	await _check_traversal()
	_check_locomotion_contract()
	await _check_controller_and_arbitration()
	await _check_refused_combat_inputs()
	await _check_review_lighting()
	await _check_material_treatment()
	await _check_toggles_and_reset()
	_check_scope()
	_check_no_state_written()
	_check_closed_gates_untouched()
	_check_surfaces_are_on_screen()

	if _shot_dir != "":
		await _capture_evidence()

	print("")
	if _failures.is_empty():
		print("GATE 1B COHESION VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("GATE 1B COHESION VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		get_tree().quit(1)


# --- 1. Engine, entrypoint, and the accepted values ---------------------------

func _check_engine_and_entrypoint() -> void:
	print("")
	print("--- Engine baseline and entrypoint (§9.4, §9.8)")
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
		"the project main scene is '%s'; D-202 must not replace the Prototype App" % main_scene)
	for required: String in [
		"res://scenes/app/prototype_app.tscn",
		"res://scenes/prototype_zero/prototype_zero.tscn",
		"res://scenes/prototype_zero/gate_a_asset_spike.tscn",
		"res://scenes/first_mvp/calibration/scale_calibration_hall.tscn",
		"res://scenes/first_mvp/visual/exterior_asset_compatibility_spike.tscn",
	]:
		_expect(ResourceLoader.exists(required), "%s is missing" % required)
	print("  the Prototype App, the laboratory, the Gate A spike, the Gate 1A hall,")
	print("  and the first Gate 1B spike all still exist")


## §9.8: the Prototype Zero resources and the Gate 1A calibration record are
## unchanged. Re-read here so a change to any of them fails inside this run as
## well as in the locked chain the smoke script runs first.
func _check_accepted_values_untouched() -> void:
	print("")
	print("--- Prototype Zero and Gate 1A accepted values are untouched (§9.8)")
	var quick_strike: Resource = load("res://data/prototype_zero/quick_strike.tres")
	var graveblade: Resource = load("res://data/prototype_zero/graveblade.tres")
	var starter: Resource = load("res://data/prototype_zero/starter_sword.tres")
	var honed: Resource = load("res://data/prototype_zero/honed_sword.tres")
	var calibration: Resource = load("res://data/first_mvp/calibration/scale_calibration.tres")
	var accepted: Array[Dictionary] = [
		{"what": "Quick Strike action time", "on": quick_strike, "field": "action_time", "want": 0.80},
		{"what": "Quick Strike reach", "on": quick_strike, "field": "reach", "want": 1.65},
		{"what": "Quick Strike release marker", "on": quick_strike, "field": "release_marker_normalized", "want": 0.325},
		{"what": "controller soft-target cone", "on": quick_strike, "field": "soft_target_cone_degrees", "want": 65.0},
		{"what": "controller soft-target distance", "on": quick_strike, "field": "soft_target_distance", "want": 5.0},
		{"what": "Graveblade Life", "on": graveblade, "field": "max_life", "want": 300.0},
		{"what": "Graveblade damage", "on": graveblade, "field": "physical_damage", "want": 125.0},
		{"what": "Graveblade preferred attack distance", "on": graveblade, "field": "preferred_attack_distance", "want": 1.40},
		{"what": "Graveblade attack reach", "on": graveblade, "field": "attack_reach", "want": 1.65},
		{"what": "Graveblade anticipation", "on": graveblade, "field": "anticipation", "want": 0.55},
		{"what": "Training Sword damage", "on": starter, "field": "physical_damage", "want": 100.0},
		{"what": "Honed Sword damage", "on": honed, "field": "physical_damage", "want": 150.0},
		{"what": "Gate 1A world unit", "on": calibration, "field": "world_unit_metres", "want": 1.0},
		{"what": "Gate 1A P", "on": calibration, "field": "player_unit_metres", "want": 0.80},
		{"what": "Gate 1A camera distance", "on": calibration, "field": "camera_distance_metres", "want": 19.0},
		{"what": "Gate 1A camera pitch", "on": calibration, "field": "camera_pitch_degrees", "want": 55.0},
		{"what": "Gate 1A camera fov", "on": calibration, "field": "camera_fov_degrees", "want": 45.0},
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
	print("  %d accepted Prototype Zero and Gate 1A values re-read and unchanged" % accepted.size())


## §6 and §9.8: no InputMap action was added. This is the sharpest of the scope
## checks, because the Gate B, E, and F suites each walk `InputMap.get_actions()`
## and emit one assertion per key event, so a single new action here would move
## three locked Prototype Zero counts without any old assertion having become
## false.
func _check_input_map_untouched() -> void:
	print("")
	print("--- The InputMap is byte-for-byte the accepted set (§6, §9.8)")
	var declared: PackedStringArray = PackedStringArray()
	for action: StringName in InputMap.get_actions():
		var name: String = String(action)
		if name.begins_with("ui_") and not EXPECTED_ACTIONS.has(name):
			continue  # Godot's built-in menu actions, which no gate declares
		declared.append(name)
	declared.sort()
	var expected: PackedStringArray = PackedStringArray(EXPECTED_ACTIONS)
	expected.sort()
	print("  %d project actions declared, %d expected" % [declared.size(), expected.size()])
	_expect(declared == expected,
		"the InputMap changed: declared %s" % ", ".join(declared))
	for forbidden: String in [
		"review_topology", "cycle_architecture", "toggle_dressing", "cohesion_reset",
		"review_lighting", "review_materials",
	]:
		_expect(not InputMap.has_action(forbidden),
			"a D-202 input action '%s' was declared; §6 forbids adding any" % forbidden)
	for path: String in SHIPPING_SCRIPTS:
		var source: String = _code_only(FileAccess.get_file_as_string(path))
		_expect(not source.contains("InputMap.add_action"),
			"%s adds an input action at runtime" % path.get_file())
	print("  every review toggle is read as a physical key; no action was added by data or by code")


# --- 2. The extraction manifest (§9.5) ----------------------------------------

func _check_extraction_manifest() -> void:
	print("")
	print("--- The exact §4 extraction manifest (§9.5)")
	var manifest: Array[Dictionary] = ExteriorCohesionCatalogue.manifest()
	print("  %d catalogued candidate models" % manifest.size())
	_expect(manifest.size() == 21,
		"the catalogue holds %d models; §4 authorizes exactly 21" % manifest.size())
	var by_family: Dictionary = {}
	for record: Dictionary in manifest:
		var family: String = String(record["family"])
		by_family[family] = int(by_family.get(family, 0)) + 1
		_expect(ResourceLoader.exists(String(record["path"])),
			"%s is missing from the project" % record["path"])
		_expect((load(String(record["path"])) as PackedScene) != null,
			"%s did not import as a scene" % record["path"])
	for pair: Array in [
		[ExteriorCohesionCatalogue.FAMILY_NATURE, 6, "§4.1"],
		[ExteriorCohesionCatalogue.FAMILY_RUINS, 6, "§4.2"],
		[ExteriorCohesionCatalogue.FAMILY_TOWN, 6, "§4.3"],
		[ExteriorCohesionCatalogue.FAMILY_GRAVEYARD, 3, "§4.4"],
	]:
		var found: int = int(by_family.get(String(pair[0]), 0))
		print("  %-52s %d models" % [pair[0], found])
		_expect(found == int(pair[1]),
			"%s authorizes exactly %d models from %s; %d are catalogued" % [
				pair[2], int(pair[1]), pair[0], found,
			])

	# Nothing was extracted that §4 and D-204 do not name. The four candidate
	# directories are walked RECURSIVELY and every file under them must be a
	# manifest model, a verbatim licence, an authorized colour atlas, or Godot's
	# own import settings. The recursion is what makes the two atlases in
	# `Textures/` subject to this scan at all rather than invisible to it.
	var allowed: PackedStringArray = ExteriorCohesionCatalogue.expected_files()
	for directory: String in [
		ExteriorCohesionCatalogue.DIR_NATURE, ExteriorCohesionCatalogue.DIR_RUINS,
		ExteriorCohesionCatalogue.DIR_TOWN, ExteriorCohesionCatalogue.DIR_GRAVEYARD,
		ExteriorCohesionCatalogue.DIR_KENNEY_LICENCES,
		ExteriorCohesionCatalogue.DIR_RUINS_LICENCES,
	]:
		var found_files: PackedStringArray = _files_under(directory)
		var payloads: int = 0
		for file: String in found_files:
			if file.ends_with(".import"):
				continue
			payloads += 1
			_expect(allowed.has(file),
				"%s was extracted but §4 does not authorize it" % file)
		print("  %-16s %d authorized files" % [directory.get_file(), payloads])

	# The excluded families §4 names by hand, checked BY NAME rather than by
	# counting, exactly as the first spike checks its own exclusions.
	for forbidden: String in [
		"tree", "crop", "flower", "water", "bridge", "tent", "roof", "building",
		"stall", "fountain", "hedge", "banner", "windmill", "watermill", "cart",
		"road", "grave", "gravestone", "coffin", "crypt", "pumpkin", "character",
		"skull", "cross", "urn", "altar", "candle", "fence", "bush", "treasure",
		"trap", "statue", "furniture", "floor",
	]:
		var leaked: PackedStringArray = PackedStringArray()
		for directory: String in [
			ExteriorCohesionCatalogue.DIR_NATURE, ExteriorCohesionCatalogue.DIR_RUINS,
			ExteriorCohesionCatalogue.DIR_TOWN, ExteriorCohesionCatalogue.DIR_GRAVEYARD,
		]:
			for file: String in _files_under(directory):
				if file.ends_with(".import"):
					continue
				if file.get_file().to_lower().contains(forbidden):
					leaked.append(file)
		_expect(leaked.is_empty(),
			"§4 excludes '%s' and %s was extracted" % [forbidden, ", ".join(leaked)])
	print("  none of the §4 exclusions reached the project")

	# The three archives §2 names as still outside the game project.
	for absent: String in [
		"res://assets/third_party/assetquest", "res://assets/third_party/kenney/cave",
		"res://assets/third_party/kenney/modular_cave",
		"res://assets/third_party/quaternius/medieval_village",
	]:
		_expect(DirAccess.open(absent) == null,
			"%s exists; §2 keeps AssetQuest Forest, Kenney Modular Cave, and Quaternius"
			% absent + " Medieval Village outside the game project")
	print("  AssetQuest Forest, Kenney Modular Cave, and Quaternius Medieval Village stayed out")


## Every authorized file is proved BYTE-IDENTICAL to its in-archive original, from
## inside the engine, on every run. All four archives are ZIPs, so unlike the
## first spike's RAR this needs no shell step at all.
func _check_licences_and_source_maps() -> void:
	print("")
	print("--- Byte identity against the four archives, and the two source maps (§9.5)")
	var verbatim: int = 0
	var mismatched: PackedStringArray = PackedStringArray()
	for record: Dictionary in ExteriorCohesionCatalogue.manifest():
		if _archive_bytes_match(String(record["archive"]), String(record["in_archive"]),
				String(record["path"])):
			verbatim += 1
		else:
			mismatched.append(String(record["path"]).get_file())
	print("  %d of %d models are byte-identical to their in-archive originals" % [
		verbatim, ExteriorCohesionCatalogue.manifest().size(),
	])
	_expect(mismatched.is_empty(),
		"these models differ from the archive: %s" % ", ".join(mismatched))

	var licences: int = 0
	for copy: Dictionary in ExteriorCohesionCatalogue.LICENCE_COPIES:
		var identical: bool = _archive_bytes_match(
			String(copy["archive"]), String(copy["source"]), String(copy["path"])
		)
		_expect(identical, "%s is not a verbatim copy of %s" % [
			String(copy["path"]).get_file(), copy["source"],
		])
		if identical:
			licences += 1
		# Three of the four source files are named `License.txt`, so §4.5 requires
		# collision-free game-side names. Proved rather than assumed.
		_expect(String(copy["path"]).get_file() != "License.txt",
			"%s kept a colliding filename" % copy["path"])
		var text: String = FileAccess.get_file_as_string(String(copy["path"]))
		_expect(text.to_lower().contains("creativecommons.org/publicdomain/zero"),
			"%s does not declare CC0" % String(copy["path"]).get_file())
	print("  %d of 4 verbatim archive licences, all CC0 1.0, all collision-free" % licences)

	# The two project-authored source maps §4.5 requires, checked by CONTENT: each
	# must map every game-side file to its archive, exact in-archive path, archive
	# SHA-256, source page, creator, version, and licence.
	for pair: Array in [
		[ExteriorCohesionCatalogue.SOURCE_MAP_KENNEY, [
			ExteriorCohesionCatalogue.FAMILY_NATURE, ExteriorCohesionCatalogue.FAMILY_TOWN,
			ExteriorCohesionCatalogue.FAMILY_GRAVEYARD,
		]],
		[ExteriorCohesionCatalogue.SOURCE_MAP_QUATERNIUS, [
			ExteriorCohesionCatalogue.FAMILY_RUINS,
		]],
	]:
		var path: String = String(pair[0])
		_expect(FileAccess.file_exists(path), "%s is missing" % path)
		if not FileAccess.file_exists(path):
			continue
		var note: String = FileAccess.get_file_as_string(path)
		var families: Array = pair[1]
		for family: String in families:
			_expect(note.contains(family), "%s never names %s" % [path.get_file(), family])
			_expect(note.contains(ExteriorCohesionCatalogue.SOURCE_PAGE[family]),
				"%s never gives the source page for %s" % [path.get_file(), family])
			_expect(note.contains(ExteriorCohesionCatalogue.CREATOR[family]),
				"%s never names the creator of %s" % [path.get_file(), family])
		var mapped: int = 0
		for record: Dictionary in ExteriorCohesionCatalogue.manifest():
			if not families.has(String(record["family"])):
				continue
			if note.contains(String(record["in_archive"])) \
					and note.contains(String(record["path"]).get_file()):
				mapped += 1
		var owed: int = 0
		for record: Dictionary in ExteriorCohesionCatalogue.manifest():
			if families.has(String(record["family"])):
				owed += 1
		_expect(mapped == owed,
			"%s maps %d of %d files back to their exact in-archive path" % [
				path.get_file(), mapped, owed,
			])
		for family: String in families:
			var archive: String = ""
			for record: Dictionary in ExteriorCohesionCatalogue.manifest():
				if String(record["family"]) == family:
					archive = String(record["archive"])
					break
			_expect(note.contains(String(ExteriorCohesionCatalogue.ARCHIVE_SHA[archive])),
				"%s never records the archive SHA-256 for %s" % [path.get_file(), family])
		# The traceability finding travels with the meshes, not only with the report.
		_expect(note.contains("CC0"), "%s never states the licence" % path.get_file())
		print("  %s maps %d files, with archive, in-archive path, SHA-256, source, creator, licence"
			% [path.get_file(), mapped])

	# THE D-204 COLOUR ATLASES. At D-203 delivery these were an ABSENCE recorded in
	# the source note so a later authorization would be one line of work. D-204 gave
	# that authorization, so the same five assertions are now positive: the two
	# dependencies exist, are exactly the authorized size, are byte-identical to
	# their in-archive originals through the same `ZIPReader` proof the 21 models
	# and 4 licences go through, and are mapped in the game-side note by archive
	# path, hash, AND game-side destination.
	_expect(ExteriorCohesionCatalogue.ATLAS_DEPENDENCIES.size() == 2,
		"the atlas-dependency record should name exactly the two 2025 Kenney kits")
	var kenney_note: String = FileAccess.get_file_as_string(
		ExteriorCohesionCatalogue.SOURCE_MAP_KENNEY
	)
	var atlases_verbatim: int = 0
	for entry: Dictionary in ExteriorCohesionCatalogue.ATLAS_DEPENDENCIES:
		var atlas_path: String = String(entry["path"])
		var present: bool = FileAccess.file_exists(atlas_path)
		_expect(present, "the D-204 colour atlas %s is missing" % atlas_path)
		# Read the size unconditionally so an absent file cannot silently drop the
		# assertions after it — the D-200/D-201 lesson, applied here.
		var on_disk: int = FileAccess.get_file_as_bytes(atlas_path).size() if present else -1
		_expect(on_disk == int(entry["bytes"]),
			"%s is %d bytes; D-204 authorizes exactly %d" % [
				atlas_path.get_file(), on_disk, int(entry["bytes"]),
			])
		var identical: bool = _archive_bytes_match(
			String(entry["archive"]), String(entry["in_archive"]), atlas_path
		)
		_expect(identical, "%s is not byte-identical to %s inside %s" % [
			atlas_path.get_file(), entry["in_archive"], entry["archive"],
		])
		if identical:
			atlases_verbatim += 1
		_expect(kenney_note.contains(String(entry["in_archive"])),
			"the Kenney source note does not name the atlas source %s" % entry["in_archive"])
		_expect(kenney_note.contains(String(entry["sha256"])),
			"the Kenney source note does not record the atlas SHA-256 for %s" % entry["family"])
		# The destination, not only the source. A note that records where a file came
		# from but not where it went cannot be checked against the tree.
		_expect(kenney_note.contains(atlas_path.trim_prefix("res://assets/third_party/kenney/")),
			"the Kenney source note does not map the game-side destination %s" % atlas_path)
	print("  %d of 2 D-204 colour atlases byte-identical to their in-archive originals,"
		% atlases_verbatim)
	print("  each with its source path, SHA-256, and game-side destination in the source note")


## §4.5 and §9.5's arithmetic as D-204 restates it, DERIVED from the filesystem
## rather than typed: 21 models + 4 licences + 2 colour atlases + 2 source maps
## = 29 new files, and 62 + 29 = 91.
func _check_inventory_arithmetic() -> void:
	print("")
	print("--- The 62 + 29 = 91 third-party inventory (§4.5, §9.5, §12)")
	var arithmetic: Dictionary = ExteriorCohesionCatalogue.inventory_arithmetic()
	print("    %d  third-party files the first Gate 1B spike left behind" % int(arithmetic["existing"]))
	print("  + %d  D-202 selected models" % int(arithmetic["models"]))
	print("  + %d  D-202 verbatim archive licences" % int(arithmetic["licences"]))
	print("  + %d  D-204 colour atlases" % int(arithmetic["atlases"]))
	print("  + %d  D-202 project-authored source maps" % int(arithmetic["source_maps"]))
	print("  = %d" % int(arithmetic["total"]))
	_expect(int(arithmetic["atlases"]) == 2,
		"D-204 authorizes exactly 2 colour atlases, not %d" % int(arithmetic["atlases"]))
	_expect(int(arithmetic["added"]) == 29, "§4.5's addition is 29 files, not %d" % int(arithmetic["added"]))
	_expect(int(arithmetic["total"]) == 91, "§4.5's total is 91 files, not %d" % int(arithmetic["total"]))

	# Counted from the tree, and the counter RECURSES — which is how the two D-204
	# atlases in their `Textures/` subdirectories are counted at all. The payload
	# filter is the one every earlier suite uses; the two source maps are added back
	# explicitly because §4.5 counts them in its own addition, and the three
	# PRE-EXISTING `.md` notes stay outside it exactly as they were before, checked
	# by content and byte identity instead.
	var payloads: int = _count_third_party_payloads("res://assets/third_party")
	var maps: int = 0
	for path: String in [
		ExteriorCohesionCatalogue.SOURCE_MAP_KENNEY,
		ExteriorCohesionCatalogue.SOURCE_MAP_QUATERNIUS,
	]:
		if FileAccess.file_exists(path):
			maps += 1
	print("  measured on disk: %d payload files + %d D-202 source maps = %d" % [
		payloads, maps, payloads + maps,
	])
	# MOVED FORWARD BY AUTHORIZATION UNDER D-215, and the two assertions below move
	# TOGETHER because they are one repair. `arithmetic["total"]` is derived from
	# §4.5's own constants and is deliberately left at 91: it records what the
	# cohesion comparison authorized and nothing since. The D-215 term is added HERE
	# instead, and it is DERIVED FROM THE RECORD rather than typed, so the number on
	# disk stays tied to what the owner actually approved — 47 models plus 47 `.bin`
	# sidecars. Repairing only one of these two would leave a suite that passes
	# while measuring nothing.
	var d215_models: int = _d215_approved_payloads().size()
	var d215_files: int = d215_models * 2
	print("  D-215 availability record: %d models = %d files" % [d215_models, d215_files])

	# MOVED FORWARD AGAIN BY AUTHORIZATION UNDER D-216: the project owner's
	# acceptance of Riftfall Landing Greybox V2 + Visual Review as the
	# development-ready placeholder registered two LeLu Noise Pack textures
	# (the Rift Scar crack decal and wisp planes). DERIVED FROM THE DRESSING
	# SCRIPT'S OWN CONSTANTS, exactly as the two D-202 source maps above are
	# derived from `ExteriorCohesionCatalogue`'s own constants rather than
	# typed, so the number on disk stays tied to what the owner actually
	# approved rather than to a literal that could drift from it.
	var lelu_files: int = 0
	for path: String in [
		RiftfallLandingVisualReviewDressing.CRACK_TEXTURE,
		RiftfallLandingVisualReviewDressing.WISP_TEXTURE,
	]:
		if FileAccess.file_exists(path):
			lelu_files += 1
	print("  D-216 LeLu Noise Pack textures: %d files" % lelu_files)

	# NO EXTRA ASSERTION IS ADDED HERE, AND THAT IS DELIBERATE: the cohesion count
	# stays at its locked 613. A separate "the record approves 47" check would have
	# been redundant rather than protective — the two assertions below already fail
	# loudly in every direction that matters. An emptied record makes `d215_files`
	# 0 while the disk still holds 183, so the first fails; a record that grew a
	# 48th entry with no file on disk makes it 96, so the second fails. Likewise for
	# `lelu_files`: a missing texture or an unexpectedly added one fails here first.
	_expect(payloads == 89 + d215_files + lelu_files,
		"%d third-party payload files exist; 62 + 21 + 4 + 2 = 89, plus the %d D-215 files, plus the %d LeLu files, is the authorized number"
			% [payloads, d215_files, lelu_files])
	_expect(maps == 2, "%d of the two D-202 source maps exist" % maps)
	_expect(payloads + maps == int(arithmetic["total"]) + d215_files + lelu_files,
		"the measured inventory is %d, not the authorized 91 + %d + %d"
			% [payloads + maps, d215_files, lelu_files])

	# The pre-existing notes were the three the first spike left; D-216 added a
	# fourth, LeLu's own source note.
	var notes: int = _count_third_party_notes("res://assets/third_party")
	print("  project-authored `.md` notes under assets/third_party: %d" % notes)
	_expect(notes == 6,
		"%d `.md` notes exist; the three earlier ones, the two D-202 source maps, and the D-216 LeLu note is 6" % notes)


# --- 3. Measurements (§8) -----------------------------------------------------

func _report_measurements() -> void:
	print("")
	print("--- §8 measurements, read off the instances this comparison placed")
	var m: Dictionary = comparison.measurements()
	print("  %-22s %-8s %-8s %-8s %-7s %-6s %-5s %-7s %s" % [
		"candidate", "x", "y", "z", "base y", "m/s", "used", "screen", "materials",
	])
	for row: Dictionary in m["candidates"]:
		var size: Vector3 = row["size"]
		print("  %-22s %8.3f %8.3f %8.3f  %+.3f  %d/%-3d x%-4d %5.1f%%  %s" % [
			row["display"], size.x, size.y, size.z, float(row["base_offset"]),
			int(row["meshes"]), int(row["surfaces"]), int(row["instances"]),
			float(row["screen_fraction"]) * 100.0,
			", ".join(row["materials"]) if (row["materials"] as PackedStringArray).size() > 0
				else "(none)",
		])
	print("  the frame is %.2f m tall at the accepted camera, so the player's own 1.80 m body"
		% (2.0 * ACCEPTED_CAMERA_DISTANCE * tan(deg_to_rad(ACCEPTED_CAMERA_FOV) * 0.5)))
	print("  occupies %.1f%% of it — that is the number to read the screen column against"
		% (ExteriorAssetProbe.screen_height_fraction(
			1.80, ACCEPTED_CAMERA_DISTANCE, ACCEPTED_CAMERA_FOV) * 100.0))
	print("  measured surface heights, laid by upward-facing triangle AREA:")
	for key: String in route.surface_drops:
		print("    %-24s %+.4f m" % [key, float(route.surface_drops[key])])
	_expect((m["candidates"] as Array).size() == 21,
		"the measurement table has %d rows, not 21" % (m["candidates"] as Array).size())


## §8: root scale, normals, transparency, culling, shadows, whether source
## materials resolve, and whether a material override is necessary.
func _check_import_state() -> void:
	print("")
	print("--- Import state of all 21 candidates (§8)")
	var scaled: PackedStringArray = PackedStringArray()
	var missing_normals: PackedStringArray = PackedStringArray()
	var transparent: PackedStringArray = PackedStringArray()
	var no_shadow: PackedStringArray = PackedStringArray()
	var unshaded: PackedStringArray = PackedStringArray()
	var double_sided: int = 0
	var untextured_models: int = 0
	var metallic_models: PackedStringArray = PackedStringArray()

	for entry: Dictionary in route.primary_instances():
		var record: Dictionary = entry["record"]
		if String(record["key"]).begins_with("ref_"):
			continue
		var probe: Dictionary = entry["probe"]
		var node: Node3D = entry["node"]
		if not (node.scale.is_equal_approx(Vector3.ONE)):
			scaled.append(String(record["display"]))
		if int(probe["missing_normals"]) > 0:
			missing_normals.append(String(record["display"]))
		if int(probe["transparent"]) > 0:
			transparent.append(String(record["display"]))
		if not bool(probe["casts_shadow"]):
			no_shadow.append(String(record["display"]))
		if not bool(probe["receives_light"]):
			unshaded.append(String(record["display"]))
		double_sided += int(probe["double_sided"])
		if (probe["textures"] as PackedStringArray).is_empty():
			untextured_models += 1
		if _is_metallic(node):
			metallic_models.append(String(record["display"]))

	print("  root scale 1.0 on %d of 21   ·   normals present on all but %d   ·   transparent %d"
		% [21 - scaled.size(), missing_normals.size(), transparent.size()])
	print("  double-sided surfaces %d   ·   models with no albedo texture %d   ·   fully metallic %d"
		% [double_sided, untextured_models, metallic_models.size()])
	_expect(scaled.is_empty(),
		"the comparison rescaled %s; §8 records import scale and this one never changes it"
		% ", ".join(scaled))
	_expect(missing_normals.is_empty(), "no normals on %s" % ", ".join(missing_normals))
	_expect(transparent.is_empty(), "unexpected transparency on %s" % ", ".join(transparent))
	_expect(no_shadow.is_empty(), "%s does not cast shadow" % ", ".join(no_shadow))
	_expect(unshaded.is_empty(), "%s imported unshaded" % ", ".join(unshaded))

	# THE D-204 CORRECTION, PROVED AT THE POINT OF USE. All nine Kenney Fantasy Town
	# and Kenney Graveyard models declare an external colour atlas. At D-203 delivery
	# the manifest did not include it and all nine resolved NO albedo texture; D-204
	# authorized exactly those two files, so each must now resolve ITS OWN kit's
	# atlas. Proving a file exists on disk is not the same as proving the importer
	# used it, and proving SOMETHING resolved is not the same as proving the right
	# thing did — a Graveyard piece pointed at the Fantasy Town atlas would pass a
	# "has a texture" check and be wrong on screen.
	var declared: int = 0
	var unresolved: PackedStringArray = PackedStringArray()
	var wrong_atlas: PackedStringArray = PackedStringArray()
	var resolved_by_family: Dictionary = {}
	for entry: Dictionary in route.primary_instances():
		var record: Dictionary = entry["record"]
		if String(record["key"]).begins_with("ref_"):
			continue
		if not bool(record["declares_external_atlas"]):
			continue
		declared += 1
		var family: String = String(record["family"])
		var owed: String = ExteriorCohesionCatalogue.atlas_for_family(family)
		var resolved: PackedStringArray = entry["probe"]["textures"]
		if resolved.is_empty():
			unresolved.append(String(record["display"]))
			continue
		for texture_path: String in resolved:
			if texture_path != owed:
				wrong_atlas.append("%s -> %s" % [record["display"], texture_path])
		if not resolved.has(owed):
			continue
		resolved_by_family[family] = int(resolved_by_family.get(family, 0)) + 1
	var town_resolved: int = int(resolved_by_family.get(ExteriorCohesionCatalogue.FAMILY_TOWN, 0))
	var graveyard_resolved: int = int(
		resolved_by_family.get(ExteriorCohesionCatalogue.FAMILY_GRAVEYARD, 0)
	)
	print("  %d models declare the external atlas '%s'; %d Fantasy Town and %d Graveyard"
		% [declared, ExteriorCohesionCatalogue.DECLARED_EXTERNAL_URI,
			town_resolved, graveyard_resolved]
		+ " resolve their own kit's copy")
	_expect(declared == 9,
		"exactly the six Fantasy Town and three Graveyard models declare the external atlas; %d do"
		% declared)
	_expect(unresolved.is_empty(),
		"D-204 restored both atlases but %s still resolve no albedo texture"
		% ", ".join(unresolved))
	_expect(wrong_atlas.is_empty(),
		"these models resolve an atlas that is not their own kit's: %s" % ", ".join(wrong_atlas))
	_expect(town_resolved == 6,
		"%d of the six Fantasy Town models resolve %s" % [
			town_resolved,
			ExteriorCohesionCatalogue.atlas_for_family(ExteriorCohesionCatalogue.FAMILY_TOWN),
		])
	_expect(graveyard_resolved == 3,
		"%d of the three Graveyard models resolve %s" % [
			graveyard_resolved,
			ExteriorCohesionCatalogue.atlas_for_family(ExteriorCohesionCatalogue.FAMILY_GRAVEYARD),
		])
	# The remaining twelve carry flat named colour materials and declare no image at
	# all — six Kenney Nature and six Quaternius. That is a DIFFERENT condition from
	# the one D-204 corrected and is deliberately still counted separately.
	_expect(untextured_models == 12,
		"%d of 21 candidates resolve no albedo texture; since D-204 that should be the "
		% untextured_models
		+ "six Kenney Nature and six Quaternius models, which carry flat colour by design")

	# Kenney Nature imports with metallic = 1.0 from its own glTF, which under
	# Forward+ leaves a fully rough metal with no diffuse response. That is why §8
	# asks whether a material override is NECESSARY, and for this family it is.
	print("  fully metallic on import: %s" % ", ".join(metallic_models))
	_expect(metallic_models.size() == 6,
		"the six Kenney Nature models import fully metallic; %d do" % metallic_models.size())
	comparison.set_candidate_materials(true)
	var still_metallic: PackedStringArray = PackedStringArray()
	for entry: Dictionary in route.primary_instances():
		var record: Dictionary = entry["record"]
		if String(record["family"]) != ExteriorCohesionCatalogue.FAMILY_NATURE:
			continue
		if _is_metallic(entry["node"], true):
			still_metallic.append(String(record["display"]))
	_expect(still_metallic.is_empty(),
		"the candidate treatment leaves %s metallic" % ", ".join(still_metallic))
	comparison.set_candidate_materials(false)
	print("  the candidate treatment resolves it: 0 of the six are metallic under it")


# --- 4. One composed route, not a catalogue (§5, §9.7) ------------------------

func _check_route_composition() -> void:
	print("")
	print("--- ONE composed route with three beats, not a source lineup (§5)")
	var m: Dictionary = comparison.measurements()
	var centreline: float = float(m["centreline_metres"])
	print("  centreline %.1f m   ·   route footprint %.0f x %.0f m   ·   %.1f%% clear of decoration" % [
		centreline, float(m["route_metres"].x), float(m["route_metres"].y),
		float(m["route_clear_fraction"]) * 100.0,
	])
	_expect(centreline >= 40.0 and centreline <= 50.0,
		"the route centreline measures %.2f m; §5 asks for approximately 40-50 m" % centreline)
	# The room-authoring blueprint's clear-ground rule is a FLOOR for a combat
	# footprint. This is a traversable comparison slice rather than a combat room,
	# and obstructing it further to land inside the 80% upper guidance would hide
	# the very thing the owner is judging. Measured, stated, and left open.
	_expect(float(m["route_clear_fraction"]) >= 0.65,
		"only %.1f%% of the route footprint is clear; the blueprint floor is 65%%"
		% (float(m["route_clear_fraction"]) * 100.0))
	_expect(float(m["narrowest_corridor"]) >= 4.80,
		"the corridor narrows to %.2f m, below the 6 P ordinary connector"
		% float(m["narrowest_corridor"]))

	# §5.1's permanent stylistic anchor: the real Knight, the KayKit Forest bare
	# trees and rocks, the selected Halloween dirt, path, broken fence, dead tree,
	# and lantern, and at least one registered Dungeon wall/pillar transition.
	_expect(player != null and _count_script_class(comparison, "MediumRigVisual") > 0,
		"the real Knight is not in the scene")
	# §5.1 names exactly what "every mode retains": the KayKit Forest bare trees
	# and rocks, the selected Halloween dirt, path, broken fence, dead tree, and
	# lantern, and at least one registered Dungeon wall/pillar transition. Those
	# are asserted in the ALWAYS-VISIBLE anchor layer, because a piece that appears
	# only inside one architecture family is not retained in every mode. The
	# Halloween arch is NOT in §5.1's list — it is the KayKit baseline's threshold
	# silhouette — so it is asserted to exist and reported as what it is.
	var anchors_present: PackedStringArray = PackedStringArray()
	var silhouette_only: PackedStringArray = PackedStringArray()
	for record: Dictionary in ExteriorCohesionCatalogue.kaykit_reference():
		var key: String = String(record["key"])
		var anchored: int = route.anchor_instances_of(key)
		var anywhere: int = route.instances_of(key)
		if key == "ref_arch":
			_expect(anywhere > 0,
				"the Halloween arch is absent; it is the KayKit baseline's threshold silhouette")
			silhouette_only.append("%s x%d" % [record["display"], anywhere])
			continue
		_expect(anchored > 0,
			"§5.1 requires %s in every mode, and it is not in the always-visible anchor layer"
			% record["display"])
		if anchored > 0:
			anchors_present.append("%s x%d" % [record["display"], anchored])
	print("  §5.1 anchors, always visible: %s" % ", ".join(anchors_present))
	print("  KayKit-baseline architecture only: %s" % ", ".join(silhouette_only))
	_expect(route.instances_in_layer("anchor") >= 40,
		"only %d permanent anchor instances were placed" % route.instances_in_layer("anchor"))

	# The three functional beats, measured off the stations actually built.
	# Every station the route declares must exist, and there must be as many of
	# them as the route says — a station added to the composition and not to this
	# list would otherwise be checked by nothing.
	var station_names: Array[String] = [
		"ApproachWallWest", "ApproachWallEast", "ApproachMassWest", "ApproachMassEast",
		"ApproachWallWestTwo", "GateWest", "GateEast", "ThresholdSilhouette",
	]
	_expect(ExteriorCohesionRoute.STATIONS.size() == station_names.size(),
		"the route declares %d stations and this check knows %d of them" % [
			ExteriorCohesionRoute.STATIONS.size(), station_names.size(),
		])
	for station_name: String in station_names:
		_expect(not route.station(station_name).is_empty(),
			"the %s station is missing from the composition" % station_name)
	_expect(is_equal_approx(route.threshold_gap_metres(), 6.0),
		"the threshold gap measures %.4f m, not the authored 6.000 m"
		% route.threshold_gap_metres())
	_expect(is_equal_approx(route.dungeon_doorway_metres(), 4.0),
		"the registered Dungeon doorway measures %.4f m, not 4.000 m"
		% route.dungeon_doorway_metres())
	print("  threshold gap %.3f m (%.2f P)   ·   registered Dungeon doorway %.3f m (%.2f P)" % [
		route.threshold_gap_metres(), route.threshold_gap_metres() / ACCEPTED_P,
		route.dungeon_doorway_metres(), route.dungeon_doorway_metres() / ACCEPTED_P,
	])

	# Every family fills the SAME stations. A family with no fill would leave a
	# beat empty and quietly change the comparison.
	for mode: int in ARCHITECTURE_MODES:
		route.set_architecture(mode as ExteriorCohesionRoute.Architecture)
		var visible_meshes: int = 0
		for entry: Dictionary in route.placed:
			if String(entry["layer"]) == "architecture_%d" % mode:
				visible_meshes += 1
		print("  %-26s %d meshes fill the same eight stations"
			% [ExteriorCohesionRoute.architecture_name(
				mode as ExteriorCohesionRoute.Architecture), visible_meshes])
		_expect(visible_meshes >= 10,
			"%s fills the stations with only %d meshes" % [
				ExteriorCohesionRoute.architecture_name(
					mode as ExteriorCohesionRoute.Architecture), visible_meshes,
			])
	route.set_architecture(ExteriorCohesionRoute.Architecture.KAYKIT_BASELINE)


func _check_navigation_and_clearance() -> void:
	print("")
	print("--- Navigation, route clearance, and the baked surface (§7, §9.7)")
	print("  %d polygons, %.1f m^2 walkable, %d ms" % [
		comparison.navmesh_polygon_count, comparison.navmesh_area, comparison.last_bake_msec,
	])
	_expect(comparison.navmesh_polygon_count > 0, "the navigation mesh is empty")
	_expect(comparison.navmesh_area > 300.0,
		"only %.1f m^2 is walkable; the route corridor is far larger" % comparison.navmesh_area)

	# The first Gate 1B spike's navigation defect, asserted so it cannot come back:
	# `NavigationAgent3D` measures its `path_desired_distance` in THREE dimensions,
	# so a baked surface lifted onto a voxel boundary above the character's feet
	# stops movement entirely.
	var agent: NavigationAgent3D = player.get_node_or_null("NavigationAgent3D")
	_expect(agent != null, "the player has no NavigationAgent3D")
	var tolerance: float = agent.path_desired_distance if agent != null else 0.40
	var worst: float = 0.0
	for probe: Vector3 in [
		route.player_spawn(), Vector3(0.0, 0.0, -10.0), Vector3(0.0, 0.0, 0.0),
		Vector3(0.0, 0.0, 10.0), Vector3(0.0, 0.0, 16.0), route.route_target(),
	]:
		var answer: Vector3 = NavigationServer3D.map_get_closest_point(
			comparison.navigation_map(), probe
		)
		worst = maxf(worst, absf(answer.y - probe.y))
	print("  baked surface at most %.4f m above the character, against the agent's %.2f m tolerance"
		% [worst, tolerance])
	_expect(worst < tolerance,
		"the baked surface is %.4f m above the ground, at or beyond the agent's %.2f m tolerance"
		% [worst, tolerance])

	# Gate 1A's open-topped-well finding. Every solid deeper than 2 x agent radius
	# could hold a phantom walkable island; every one of them carves.
	var phantom: PackedStringArray = PackedStringArray()
	var wide_enough: int = 0
	for entry: Dictionary in route.solids():
		var solid_name: String = String(entry["name"])
		if solid_name == "Ground":
			continue
		var box: AABB = entry["aabb"]
		if minf(box.size.x, box.size.z) <= 2.0 * comparison.agent_radius:
			continue
		wide_enough += 1
		var centre: Vector3 = Vector3(box.get_center().x, 0.0, box.get_center().z)
		var answer: Vector3 = NavigationServer3D.map_get_closest_point(
			comparison.navigation_map(), centre
		)
		if Vector2(answer.x - centre.x, answer.z - centre.z).length() < 0.20:
			phantom.append("%s answers itself" % solid_name)
	print("  %d solids are wide enough to hold a phantom island; %d do"
		% [wide_enough, phantom.size()])
	_expect(phantom.is_empty(), "phantom walkable islands: %s" % ", ".join(phantom))

	# The corridor is walkable across its width at several stations along it.
	var off_route: PackedStringArray = PackedStringArray()
	for probe: Vector2 in [
		Vector2(-6.0, -21.0), Vector2(6.0, -21.0), Vector2(0.0, -12.0),
		Vector2(-6.0, -6.0), Vector2(6.0, -6.0), Vector2(0.0, 4.0),
		Vector2(0.0, 9.0), Vector2(0.0, 12.0), Vector2(0.0, 15.0), Vector2(0.0, 19.0),
	]:
		if not comparison.point_is_navigable(Vector3(probe.x, 0.0, probe.y)):
			off_route.append("(%.1f, %.1f)" % [probe.x, probe.y])
	_expect(off_route.is_empty(),
		"these points on the route are not walkable: %s" % ", ".join(off_route))
	print("  10 probes along and across the route all resolve onto the walkable surface")

	# And the boundary really bounds: a point beyond the shoulder is not walkable.
	for outside: Vector2 in [Vector2(-16.0, -10.0), Vector2(16.0, 4.0), Vector2(0.0, -32.0)]:
		_expect(not comparison.point_is_navigable(Vector3(outside.x, 0.0, outside.y)),
			"(%.1f, %.1f) is outside the route and should not be walkable" % [
				outside.x, outside.y,
			])
	print("  three points beyond the boundary shoulders and caps are correctly unreachable")


## §7's hardest requirement: "The player must traverse the complete route under
## every topology, architecture, material, and dressing combination" and "No
## candidate is allowed to change navigation merely because a visual mode was
## selected." All TWELVE combinations are walked through and measured.
func _check_mode_invariance() -> void:
	print("")
	print("--- The same route in all twelve mode combinations (§5, §7, §9.7)")
	var baseline_solids: String = _solid_fingerprint()
	var baseline_area: float = comparison.navmesh_area
	var baseline_polygons: int = comparison.navmesh_polygon_count
	var baseline_path: float = comparison.route_path_length()
	var baseline_bakes: int = comparison.bake_count
	print("  baseline: %d solids fingerprinted, %.4f m^2 walkable, %d polygons, %.4f m path" % [
		route.solids().size(), baseline_area, baseline_polygons, baseline_path,
	])
	_expect(baseline_path > 30.0,
		"the resolved route path is only %.2f m long" % baseline_path)

	var combinations: int = 0
	for mode: int in ARCHITECTURE_MODES:
		for topology: bool in [false, true]:
			for dressing: bool in [false, true]:
				combinations += 1
				comparison.set_architecture(mode as ExteriorCohesionRoute.Architecture)
				comparison.set_topology_visible(topology)
				comparison.set_dressing_visible(dressing)
				await _settle(2)
				var label: String = "%s / topology %s / dressing %s" % [
					ExteriorCohesionRoute.architecture_name(
						mode as ExteriorCohesionRoute.Architecture),
					"on" if topology else "off", "on" if dressing else "off",
				]
				_expect(_solid_fingerprint() == baseline_solids,
					"%s changed the collision skeleton" % label)
				_expect(is_equal_approx(comparison.navmesh_area, baseline_area),
					"%s changed the walkable area to %.4f m^2" % [label, comparison.navmesh_area])
				_expect(comparison.navmesh_polygon_count == baseline_polygons,
					"%s changed the polygon count to %d" % [label, comparison.navmesh_polygon_count])
				_expect(is_equal_approx(route.threshold_gap_metres(), 6.0),
					"%s changed the threshold gap to %.4f m" % [label, route.threshold_gap_metres()])
				_expect(comparison.point_is_navigable(route.route_target()),
					"%s made the route destination unreachable" % label)
				_expect(is_equal_approx(comparison.route_path_length(), baseline_path),
					"%s changed the resolved path length to %.4f m"
					% [label, comparison.route_path_length()])
				var intrusions: PackedStringArray = route.spine_intrusions()
				_expect(intrusions.is_empty(),
					"%s puts a mesh in the clear walking line: %s" % [label, ", ".join(intrusions)])
	print("  %d combinations: identical solids, %.4f m^2, %d polygons, %.4f m path, 6.000 m gap"
		% [combinations, baseline_area, baseline_polygons, baseline_path])
	_expect(combinations == 12, "only %d of the twelve combinations were walked" % combinations)

	# The strongest form of "a visual mode cannot change navigation": it never
	# needed rebaking at all, because no review toggle touches a collision shape.
	print("  navigation bakes this whole session: %d" % comparison.bake_count)
	_expect(comparison.bake_count == baseline_bakes,
		"cycling the review modes rebaked navigation %d times"
		% (comparison.bake_count - baseline_bakes))
	_expect(comparison.bake_count == 1,
		"navigation was baked %d times; once is the whole point" % comparison.bake_count)

	# The dressing layer in particular owns nothing structural.
	var dressing_solids: int = 0
	for entry: Dictionary in route.solids():
		if String(entry["name"]).to_lower().contains("dress"):
			dressing_solids += 1
	_expect(dressing_solids == 0,
		"the Graveyard dressing layer owns %d collision shapes; §5.2 makes it visual only"
		% dressing_solids)
	comparison.reset_review()
	await _settle(2)


# --- 5. Movement, click resolution, and the locomotion contract ---------------

func _check_click_resolution() -> void:
	print("")
	print("--- Click-to-move resolution (§7)")
	var camera: Camera3D = comparison.camera_rig.camera
	var on_route: Vector3 = Vector3(0.0, 0.0, -8.0)
	var screen: Vector2 = camera.unproject_position(on_route)
	comparison.set_cursor_override(screen)
	var cursor: Dictionary = comparison.ground_point_under_cursor(screen)
	_expect(bool(cursor.get("valid", false)), "the cursor found no ground on the open route")
	if bool(cursor.get("valid", false)):
		var point: Vector3 = cursor["point"]
		_expect(point.distance_to(on_route) < 0.60,
			"the cursor resolved to (%.2f, %.2f), %.2f m from the point under it" % [
				point.x, point.z, point.distance_to(on_route),
			])
	var resolution: Dictionary = comparison.resolve_to_navigation(on_route)
	_expect(not bool(resolution["adjusted"]), "a point on the open route was adjusted")

	# A request beyond the boundary shoulders is adjusted onto the nearest
	# navigable point rather than accepted or silently dropped.
	var unreachable: Vector3 = Vector3(0.0, 0.0, -34.0)
	var adjusted: Dictionary = comparison.resolve_to_navigation(unreachable)
	_expect(bool(adjusted["adjusted"]), "a point beyond the route cap was not adjusted")
	var landed: Vector3 = adjusted["point"]
	_expect(comparison.point_is_navigable(landed),
		"the adjusted destination (%.2f, %.2f) is not itself walkable" % [landed.x, landed.z])
	print("  a point on the route is accepted unchanged; one beyond the cap resolves to (%.2f, %.2f)"
		% [landed.x, landed.z])
	comparison.set_cursor_override(null)
	await _settle(2)


## §7: the player traverses the COMPLETE route. Walked for real, on the navigation
## mesh, from the spawn to the destination beyond the threshold and through the
## registered Dungeon doorway.
func _check_traversal() -> void:
	print("")
	print("--- Traversing the complete route (§7)")
	await _teleport(route.player_spawn())
	var start: Vector3 = player.global_position
	var target: Vector3 = route.route_target()
	player.command_move_to(target, target, false)
	var elapsed: float = 0.0
	var frames: int = 0
	while frames < 1800:
		await get_tree().physics_frame
		frames += 1
		elapsed += TICK
		if player.global_position.distance_to(target) < 0.60:
			break
	var travelled: float = start.distance_to(player.global_position)
	print("  walked %.2f m of a %.2f m route in %.2f s, ending %.2f m from the destination" % [
		travelled, comparison.route_path_length(), elapsed,
		player.global_position.distance_to(target),
	])
	_expect(player.global_position.distance_to(target) < 0.60,
		"the character stopped %.2f m short of the route destination"
		% player.global_position.distance_to(target))
	_expect(travelled > 35.0, "the character only covered %.2f m" % travelled)
	# Fast enough to be moving at the accepted speed rather than crawling, and slow
	# enough that it is not teleporting.
	_expect(elapsed > travelled / (ACCEPTED_MAX_SPEED * 1.05),
		"the walk took %.2f s, which is faster than %.2f m/s allows" % [elapsed, ACCEPTED_MAX_SPEED])
	player.clear_movement_intent("verification", false)
	await _release_all_inputs()
	await _teleport(route.player_spawn())

	# Collision, proved by pushing the STICK into a wall rather than by clicking
	# at it: a click-to-move command walks politely around an obstacle, which
	# proves the navigation mesh and says nothing about collision.
	await _teleport(Vector3(-4.0, 0.0, -18.0))
	comparison.set_stick_override(_stick_toward(Vector3(-1.0, 0.0, 0.0)))
	for i: int in 200:
		await get_tree().physics_frame
	var stopped_at: float = player.global_position.x
	comparison.set_stick_override(null)
	await _release_all_inputs()
	# The face is READ OFF the shoulder solid the route actually built rather than
	# typed here, so narrowing the corridor cannot leave this check measuring the
	# wrong wall and passing or failing for the wrong reason.
	var face: float = 0.0
	for entry: Dictionary in route.solids():
		if not String(entry["name"]).begins_with("ShoulderWest"):
			continue
		var box: AABB = entry["aabb"]
		if box.position.z <= -18.0 and box.end.z >= -18.0:
			face = box.end.x
			break
	_expect(face < 0.0, "no west boundary shoulder covers z = -18")
	var clearance: float = absf(face - stopped_at)
	print("  the stick into the west shoulder (face at x = %.3f) stops the body at x = %.4f, %.4f m away"
		% [face, stopped_at, clearance])
	_expect(clearance > 0.30 and clearance < 0.55,
		"the body stopped %.4f m from the shoulder face; its capsule radius is 0.40 m" % clearance)
	await _teleport(route.player_spawn())


func _check_locomotion_contract() -> void:
	print("")
	print("--- The accepted locomotion and camera contract (§7)")
	var contract: Array[Dictionary] = [
		{"what": "maximum speed", "value": player.max_speed, "want": ACCEPTED_MAX_SPEED},
		{"what": "acceleration", "value": player.acceleration, "want": ACCEPTED_ACCELERATION},
		{"what": "braking", "value": player.braking, "want": ACCEPTED_BRAKING},
		{"what": "arrival tolerance", "value": player.arrival_tolerance,
			"want": ACCEPTED_ARRIVAL_TOLERANCE},
		{"what": "stick deadzone", "value": player.stick_deadzone, "want": ACCEPTED_DEADZONE},
		{"what": "substantial turn", "value": player.substantial_turn_degrees,
			"want": ACCEPTED_SUBSTANTIAL_TURN},
		{"what": "turn rate", "value": player.turn_rate_degrees, "want": ACCEPTED_TURN_RATE},
		{"what": "camera distance", "value": comparison.camera_rig.distance_metres,
			"want": ACCEPTED_CAMERA_DISTANCE},
		{"what": "camera pitch", "value": comparison.camera_rig.pitch_degrees,
			"want": ACCEPTED_CAMERA_PITCH},
		{"what": "camera field of view", "value": comparison.camera_rig.fov_degrees,
			"want": ACCEPTED_CAMERA_FOV},
		{"what": "player collision diameter", "value": player.collision_diameter(),
			"want": ACCEPTED_P},
		{"what": "player collision height", "value": player.collision_height(), "want": 1.80},
	]
	for entry: Dictionary in contract:
		_expect(is_equal_approx(float(entry["value"]), float(entry["want"])),
			"%s is %s, not the accepted %s" % [entry["what"], entry["value"], entry["want"]])
	print("  %d accepted movement and camera values re-read off the objects built here"
		% contract.size())

	# One click-to-move and one controller-locomotion implementation in the whole
	# project, not two. §3 forbids a second, and this is how that is proved.
	for required: String in [
		"PrototypeLocomotion", "PrototypeGroundPointer", "PrototypeMouseHold",
	]:
		_expect(_comparison_uses(required),
			"the comparison does not use the shared %s kernel" % required)
	for reused: String in REUSED_SPIKE_SCRIPTS:
		_expect(FileAccess.file_exists(reused), "%s is missing" % reused)
	_expect(_comparison_uses("ExteriorReviewLighting") and _comparison_uses("ExteriorReviewTreatment")
			and _comparison_uses("ExteriorAssetProbe"),
		"the comparison forked the first Gate 1B spike's lighting, treatment, or probe")
	print("  the shared locomotion kernel and the first spike's lighting, treatment, and probe")
	print("  are REUSED rather than forked")

	# CF is a project unit at the fixed 1920 x 1080 reference aspect, not a
	# function of the window.
	var m: Dictionary = comparison.measurements()
	var cf: Vector2 = m["cf_metres"]
	print("  CF measured %.3f x %.3f m at the reference aspect %.4f (live aspect %.4f)" % [
		cf.x, cf.y, float(m["reference_aspect"]), float(m["live_aspect"]),
	])
	_expect(absf(cf.x - 27.982) < 0.05 and absf(cf.y - 20.980) < 0.05,
		"CF measures %.3f x %.3f m, not D-175's 27.982 x 20.980 m" % [cf.x, cf.y])


func _check_controller_and_arbitration() -> void:
	print("")
	print("--- Controller movement and input arbitration (§7)")
	await _teleport(Vector3(0.0, 0.0, -14.0))
	var deadzone_start: Vector3 = player.global_position
	comparison.set_stick_override(Vector2(0.15, 0.0))
	for i: int in 30:
		await get_tree().physics_frame
	_expect(player.global_position.distance_to(deadzone_start) < 0.05,
		"a stick reading inside the 0.20 deadzone moved the character")
	comparison.set_stick_override(_stick_toward(Vector3(0.0, 0.0, 1.0)))
	for i: int in 40:
		await get_tree().physics_frame
	var moved: Vector3 = player.global_position - deadzone_start
	_expect(moved.z > 0.5 and absf(moved.x) < 0.6,
		"the stick moved the character (%.2f, %.2f); it is camera-relative" % [moved.x, moved.z])
	_expect(player.movement_mode_name() == "controller direct",
		"a held stick reports movement mode '%s'" % player.movement_mode_name())
	print("  deadzone holds at 0.15; a camera-relative push moves (%.2f, %.2f)"
		% [moved.x, moved.z])

	# A mouse command supersedes a held stick: the accepted arbitration rule.
	var destination: Vector3 = Vector3(0.0, 0.0, -6.0)
	var resolved: Dictionary = comparison.resolve_to_navigation(destination)
	player.command_move_to(resolved["point"], destination, false)
	await _settle(4)
	# The accepted kernel reports exactly "mouse path" and "controller direct";
	# asserting the real string rather than a substring guess is what makes this
	# check able to fail for the right reason.
	_expect(player.movement_mode_name() == "mouse path",
		"a click did not supersede the held stick; mode is '%s'" % player.movement_mode_name())
	print("  a click supersedes the held stick: movement mode is '%s'" % player.movement_mode_name())
	comparison.set_stick_override(null)
	player.clear_movement_intent("verification", false)
	await _release_all_inputs()
	await _teleport(route.player_spawn())


func _check_refused_combat_inputs() -> void:
	print("")
	print("--- No combat input exists here (§2)")
	var before: int = comparison.refused_action_inputs
	for action: StringName in [&"quick_strike", &"attack_in_place", &"interact"]:
		var event: InputEventAction = InputEventAction.new()
		event.action = action
		event.pressed = true
		Input.parse_input_event(event)
		await _settle(2)
	var refused: int = comparison.refused_action_inputs - before
	print("  %d of 3 combat inputs were refused by name and counted" % refused)
	_expect(refused == 3, "only %d of the three combat inputs were refused" % refused)

	# And the interface really absorbs a click rather than issuing a world command.
	var absorbed_before: int = comparison.ui_clicks_absorbed
	var commands_before: int = comparison.accepted_commands + comparison.adjusted_commands
	# §6: "Interface clicks must not move the player OR CHANGE A COMPARISON MODE."
	# The second half needs its own witness, so the whole mode state and the
	# player's position are captured and compared afterwards.
	var modes_before: String = _mode_fingerprint()
	var position_before: Vector3 = player.global_position
	var leak_panel: Control = _find_control(comparison.overlay, "InterfaceLeakTest")
	_expect(leak_panel != null, "the interface leak test panel is missing")
	if leak_panel != null:
		# `gui_get_hovered_control()` is updated by pointer MOTION, and `push_input`
		# transforms window coordinates unless told they are local — a check that
		# only warps the mouse and pushes a button misses the panel and leaks a
		# real command for its own reasons.
		var centre: Vector2 = leak_panel.get_global_rect().get_center()
		var motion: InputEventMouseMotion = InputEventMouseMotion.new()
		motion.position = centre
		get_viewport().push_input(motion, true)
		await _await_process_frames(2)
		var click: InputEventMouseButton = InputEventMouseButton.new()
		click.button_index = MOUSE_BUTTON_LEFT
		click.pressed = true
		click.position = centre
		get_viewport().push_input(click, true)
		await _await_process_frames(2)
		var release: InputEventMouseButton = InputEventMouseButton.new()
		release.button_index = MOUSE_BUTTON_LEFT
		release.pressed = false
		release.position = centre
		get_viewport().push_input(release, true)
		await _await_process_frames(2)
		var commands_after: int = comparison.accepted_commands + comparison.adjusted_commands
		print("  a click on the interface panel issued %d movement commands and absorbed %d"
			% [commands_after - commands_before, comparison.ui_clicks_absorbed - absorbed_before])
		_expect(commands_after == commands_before,
			"clicking the interface issued %d movement commands" % (commands_after - commands_before))
		_expect(_mode_fingerprint() == modes_before,
			"clicking the interface changed a comparison mode: %s -> %s" % [
				modes_before, _mode_fingerprint(),
			])
		_expect(player.global_position.distance_to(position_before) < 0.01,
			"clicking the interface moved the character %.4f m"
			% player.global_position.distance_to(position_before))
		print("  it changed no comparison mode and moved the character 0.0000 m")
	await _release_all_inputs()


# --- 6. Review states and the non-destructive treatment (§6) ------------------

func _check_review_lighting() -> void:
	print("")
	print("--- The two review states (§6)")
	comparison.set_lighting_candidate(false)
	await _settle(2)
	var environment: Environment = (comparison.get_node("WorldEnvironment") as WorldEnvironment).environment
	_expect(comparison.lighting.mode == ExteriorReviewLighting.Mode.NEUTRAL,
		"the neutral review state did not apply")
	# §6: "Neutral review must expose mismatch." It may not use fog, glow, or
	# grading to conceal a difference, which is asserted rather than trusted.
	_expect(not environment.fog_enabled, "neutral review enabled fog")
	_expect(not environment.glow_enabled, "neutral review enabled glow")
	_expect(not environment.adjustment_enabled, "neutral review enabled colour adjustment")
	_expect(environment.tonemap_mode == Environment.TONE_MAPPER_LINEAR,
		"neutral review is not linear-tonemapped")
	_expect(environment.ambient_light_energy >= 1.0,
		"neutral review ambient is only %.2f; it must be bright enough to reveal a mismatch"
		% environment.ambient_light_energy)
	print("  neutral: linear tonemap, ambient energy %.2f, no fog, no glow, no adjustment"
		% environment.ambient_light_energy)

	comparison.set_lighting_candidate(true)
	await _settle(2)
	environment = (comparison.get_node("WorldEnvironment") as WorldEnvironment).environment
	_expect(comparison.lighting.mode == ExteriorReviewLighting.Mode.CANDIDATE,
		"the candidate treatment did not apply")
	_expect(environment.fog_enabled, "the candidate treatment has no distance fog")
	_expect(environment.fog_density <= 0.01,
		"the candidate fog density is %.4f; §6 forbids hiding mismatch behind it"
		% environment.fog_density)
	_expect(not environment.glow_enabled, "the candidate treatment enabled glow")
	_expect(not environment.adjustment_enabled,
		"the candidate treatment enabled colour grading; §6 forbids heavy grading")
	_expect(comparison.lighting.lantern_count() >= 2,
		"the candidate treatment has %d restrained warm lights" % comparison.lighting.lantern_count())
	print("  candidate: filmic tonemap, fog density %.4f, %d warm lantern lights, no glow, no grading"
		% [environment.fog_density, comparison.lighting.lantern_count()])
	comparison.set_lighting_candidate(false)
	await _settle(2)


## §6: "Switching source materials back on must restore the imported presentation."
## Measured across THREE full cycles, not one — Prototype Zero's D-191 aim
## assistance defect only appeared on the second pass.
func _check_material_treatment() -> void:
	print("")
	print("--- The candidate material treatment is non-destructive (§6)")
	var treatment: ExteriorReviewTreatment = comparison.treatment
	print("  %d surfaces registered across %d labelled objects" % [
		treatment.surface_count(), treatment.registered_labels().size(),
	])
	_expect(treatment.surface_count() > 200,
		"only %d surfaces are registered for treatment" % treatment.surface_count())
	for cycle: int in 3:
		comparison.set_candidate_materials(true)
		await _settle(2)
		_expect(treatment.candidate_active(), "cycle %d did not apply the treatment" % (cycle + 1))
		comparison.set_candidate_materials(false)
		await _settle(2)
		var drifted: PackedStringArray = treatment.drifted_sources()
		var held: PackedStringArray = treatment.overridden_surfaces()
		_expect(drifted.is_empty(),
			"cycle %d changed %d imported materials: %s" % [
				cycle + 1, drifted.size(), ", ".join(drifted),
			])
		_expect(held.is_empty(),
			"cycle %d left %d overrides behind" % [cycle + 1, held.size()])
	print("  three candidate -> source cycles: 0 imported materials changed, 0 overrides left")

	# WHAT D-204 CHANGED HERE, AND WHY THE TREATMENT WAS NOT TOUCHED. Before the
	# atlases were restored these nine models carried no texture, so they took the
	# treatment's DUPLICATE branch, which inherits cull mode and kept them
	# double-sided. Now they are textured, so they take the SHADER branch — the same
	# one every KayKit surface takes — and that shader declares `cull_back`.
	#
	# The treatment rule did not change; its INPUT did. D-204 forbids changing a
	# treatment value or rule, so nothing here was forked or special-cased, and the
	# consequence is measured, asserted, drawn on the overlay, and reported instead
	# of being quietly designed away. What actually has to hold is that the shader
	# samples the RESTORED atlas — the dependency proved at the point of use — and
	# that the imported material is still untouched underneath it.
	comparison.set_candidate_materials(true)
	await _settle(2)
	var mismatched: PackedStringArray = PackedStringArray()
	var shaded_surfaces: int = 0
	var source_still_double_sided: int = 0
	var source_lost_culling: PackedStringArray = PackedStringArray()
	for entry: Dictionary in route.placed:
		var record: Dictionary = entry["record"]
		var family: String = String(record["family"])
		if family != ExteriorCohesionCatalogue.FAMILY_TOWN \
				and family != ExteriorCohesionCatalogue.FAMILY_GRAVEYARD:
			continue
		var owed: String = ExteriorCohesionCatalogue.atlas_for_family(family)
		for mesh_instance: MeshInstance3D in _meshes_under(entry["node"]):
			for surface: int in mesh_instance.mesh.get_surface_count():
				var applied: Material = mesh_instance.get_surface_override_material(surface)
				var shaded: ShaderMaterial = applied as ShaderMaterial
				if shaded == null:
					mismatched.append("%s did not take the shader branch" % record["display"])
					continue
				var sampled: Texture2D = shaded.get_shader_parameter("source_albedo") as Texture2D
				if sampled == null or sampled.resource_path != owed:
					mismatched.append("%s samples %s, not %s" % [
						record["display"],
						"nothing" if sampled == null else sampled.resource_path, owed,
					])
					continue
				shaded_surfaces += 1
				# The imported material underneath, re-read now rather than trusted.
				var source: StandardMaterial3D = (
					mesh_instance.mesh.surface_get_material(surface) as StandardMaterial3D
				)
				if source != null and source.cull_mode == BaseMaterial3D.CULL_DISABLED:
					source_still_double_sided += 1
				else:
					source_lost_culling.append(String(record["display"]))
	print("  %d Kenney Town/Graveyard surfaces sample the restored atlas through the shader"
		% shaded_surfaces)
	print("  %d of them are still CULL_DISABLED in the IMPORTED material underneath;"
		% source_still_double_sided)
	print("  the shader renders cull_back, so the treatment shows them single-sided —")
	print("  a stated consequence of restoring the atlas, not a change to the treatment")
	_expect(mismatched.is_empty(),
		"%d surfaces do not sample their own kit's restored atlas: %s" % [
			mismatched.size(), ", ".join(mismatched),
		])
	_expect(shaded_surfaces > 0, "no Kenney Town or Graveyard surface was found to check")
	_expect(source_lost_culling.is_empty(),
		"the treatment altered the imported cull mode on %s" % ", ".join(source_lost_culling))
	comparison.set_candidate_materials(false)
	await _settle(2)


func _check_toggles_and_reset() -> void:
	print("")
	print("--- Every review toggle, and the reset (§6)")
	var before: int = comparison.review_toggle_count

	comparison.set_topology_visible(true)
	await _settle(2)
	_expect(route.topology_visible, "F4 did not show the Kenney Nature topology")
	_expect(route.instances_in_layer("topology") > 50,
		"only %d topology instances were placed" % route.instances_in_layer("topology"))
	comparison.set_topology_visible(false)
	await _settle(2)
	_expect(not route.topology_visible, "F4 did not restore the flat baseline")

	var seen: PackedStringArray = PackedStringArray()
	for i: int in 3:
		comparison.cycle_architecture()
		seen.append(ExteriorCohesionRoute.architecture_name(route.architecture))
	_expect(seen.size() == 3 and route.architecture
			== ExteriorCohesionRoute.Architecture.KAYKIT_BASELINE,
		"F5 does not cycle back to the KayKit baseline after three presses: %s" % ", ".join(seen))
	print("  F5 cycles %s" % " -> ".join(seen))

	comparison.set_dressing_visible(true)
	await _settle(2)
	_expect(route.dressing_visible, "F7 did not show the Graveyard dressing")
	_expect(route.instances_in_layer("dressing") >= 16,
		"only %d dressing instances were placed" % route.instances_in_layer("dressing"))
	comparison.set_dressing_visible(false)

	route.set_grid_visible(true)
	_expect(route.grid_visible, "F6 did not show the 1 m grid")
	route.set_grid_visible(false)
	comparison.set_overlay_visible(false)
	_expect(not (comparison.overlay as CanvasItem).visible, "F3 did not hide the overlay")
	comparison.set_overlay_visible(true)

	# `\` returns everything, including the camera and the player.
	comparison.set_lighting_candidate(true)
	comparison.set_candidate_materials(true)
	comparison.set_topology_visible(true)
	comparison.set_architecture(ExteriorCohesionRoute.Architecture.KENNEY_TOWN)
	comparison.set_dressing_visible(true)
	route.set_grid_visible(true)
	comparison.camera_rig.adjust_distance(6.0)
	await _teleport(Vector3(4.0, 0.0, 6.0))
	_expect(not comparison.review_is_launch_state(),
		"the comparison still reports the launch state after six modes were changed")
	comparison.reset_review()
	await _settle(4)
	_expect(comparison.review_is_launch_state(),
		"the reset did not return every mode and the camera to the launch state")
	_expect(player.global_position.distance_to(route.player_spawn()) < 0.30,
		"the reset left the player %.2f m from the spawn"
		% player.global_position.distance_to(route.player_spawn()))
	print("  %d toggle operations ran; the reset restores every mode, the camera, and the player"
		% (comparison.review_toggle_count - before))


# --- 7. Scope, storage, and the closed gates (§9.6, §9.8, §9.9) ---------------

func _check_scope() -> void:
	print("")
	print("--- No combat, canonical route, story, progression, or save entered the work (§9.9)")
	# NOTE on what is NOT in this list. The first spike forbade a member called
	# "route" outright; this comparison is deliberately route-SHAPED, so that word
	# cannot be the test here. The canonical work is forbidden by name below and by
	# the file-absence checks that follow, which is the stronger statement anyway.
	for forbidden: String in [
		"attack", "quick_strike", "acquisition", "soft_target", "target_acquisition",
		"life", "mana", "damage", "graveblade", "enemy", "coordinator",
		"loot", "drop", "experience", "passive", "inventory", "equipment", "rarity",
		"affix", "craft", "forge", "hud", "settings", "saved_state", "lab_progress",
		"director", "story", "mara", "nexus", "riftmarked", "procedural", "generator",
		"run_graph", "module_library", "pursuit", "intensity", "riftfall", "landing",
		"broken_watch", "severed",
	]:
		_expect(not (forbidden in comparison),
			"the comparison has a '%s' member; that is not authorized by D-202" % forbidden)
	for forbidden: String in [
		"attack", "life", "mana", "weapon", "receive_damage", "physical_damage",
		"experience", "target", "inventory", "equip_weapon", "action_state",
	]:
		_expect(not (forbidden in player),
			"the comparison player has a '%s' member; it carries locomotion only" % forbidden)
	print("  the comparison and its player carry review modes, geometry, and locomotion, nothing else")

	for type_name: String in [
		"PrototypeGraveblade", "QuickStrikeAction", "AttackCoordinator", "PrototypeTargetable",
		"PrototypeHUD", "PrototypeProgressionDirector", "PrototypeSettings", "PrototypeLabState",
		"PrototypeAudioDirector", "PrototypePlayer", "PrototypeZeroRoom",
		"ScaleCalibrationHall", "CalibrationFixtures", "ExteriorAssetCompatibilitySpike",
	]:
		_expect(_count_script_class(comparison, type_name) == 0,
			"a %s exists inside the cohesion comparison" % type_name)
	_expect(_count_nodes_of_type(comparison, "AudioStreamPlayer") == 0
			and _count_nodes_of_type(comparison, "AudioStreamPlayer3D") == 0,
		"the cohesion comparison plays audio; D-202 authorizes none")
	print("  no combat, progression, HUD, settings, save, hall, first-spike, or audio object exists")

	# The canonical work this comparison must NOT start.
	for absent: String in [
		"res://scenes/first_mvp/severed_threshold.tscn",
		"res://scenes/first_mvp/broken_watch.tscn",
		"res://scenes/first_mvp/nexus_threshold.tscn",
		"res://scenes/first_mvp/rift_nexus.tscn",
		"res://scripts/first_mvp/run_graph.gd",
	]:
		_expect(not ResourceLoader.exists(absent),
			"%s exists; the Severed Threshold route is not authorized" % absent)
	# D-208 §11.2 REPLACES ONE ROW OF THAT LIST, ONE FOR ONE. Gate 1C authorizes
	# exactly one canonical Riftfall Landing scene, at
	# res://scenes/first_mvp/severed_threshold/riftfall_landing.tscn, so the row
	# that required a Riftfall Landing path to be ABSENT is false by authorization.
	# Deleting it would weaken this suite, so it becomes the next honest boundary
	# instead: ISOLATION. The Gate 1C scene exists where Gate 1C put it, and nothing
	# in this closed instrument's live tree, or in its own source, is any part of it.
	_expect(
		ResourceLoader.exists(GATE_1C_CANONICAL_SCENE)
		and _count_script_class(comparison, "RiftfallLanding") == 0
		and _count_script_class(comparison, "RiftfallLandingLayout") == 0
		and _count_script_class(comparison, "RiftfallLoopEvent") == 0
		and not _code_only(FileAccess.get_file_as_string(
			"res://scripts/first_mvp/visual/exterior_cohesion_comparison.gd"
		)).contains("severed_threshold"),
		("Gate 1C's canonical scene is missing from its authorized path, or this closed "
		+ "Gate 1B instrument contains or names part of it"))
	_expect(not FileAccess.file_exists("res://../docs/testing/FIRST_MVP_VERTICAL_SLICE_REPORT.md"),
		"a first-MVP vertical-slice report exists; that work is not authorized")
	print("  Riftfall Landing exists as the isolated D-208 Gate 1C scene and is no part of\n  this instrument; Broken Watch, the Nexus Threshold, the Rift Nexus and the wider\n  Severed Threshold route remain unstarted")


func _check_no_state_written() -> void:
	print("")
	print("--- §9: the comparison has no production storage path at all")
	for path: String in SHIPPING_SCRIPTS:
		var source: String = _code_only(FileAccess.get_file_as_string(path))
		for forbidden: String in [
			"user://", "ConfigFile", "FileAccess.open", "ResourceSaver", "store_string",
			"store_line", "save_to_file", "get_file_as_string", "get_file_as_bytes",
		]:
			_expect(not source.contains(forbidden),
				"%s reaches '%s'; the comparison reads and writes nothing" % [
					path.get_file(), forbidden,
				])
	for forbidden: String in ["storage_path", "save", "load_state", "schema_version"]:
		_expect(not (forbidden in comparison), "the comparison has a '%s' member" % forbidden)
	print("  no user:// path, ConfigFile, FileAccess call, or ResourceSaver in D-202 shipping code")


## §9.6: the closed gates and the first Gate 1B spike did not begin using the new
## candidates. Proved per scene rather than by a directory-wide scan, because the
## whole point is that the OLD work is unchanged while the NEW work is authorized.
func _check_closed_gates_untouched() -> void:
	print("")
	print("--- The Prototype App, Gate 1A hall, and first Gate 1B spike name no new family (§9.6)")
	var new_directories: PackedStringArray = PackedStringArray([
		"assets/third_party/kenney/", "assets/third_party/quaternius/",
	])
	var checked: int = 0
	for path: String in [
		"res://scripts/first_mvp/calibration/scale_calibration_hall.gd",
		"res://scripts/first_mvp/calibration/scale_calibration_geometry.gd",
		"res://scripts/first_mvp/calibration/calibration_fixtures.gd",
		"res://scripts/first_mvp/calibration/gate_1a_verification.gd",
		"res://scripts/first_mvp/visual/exterior_asset_compatibility_spike.gd",
		"res://scripts/first_mvp/visual/exterior_asset_catalogue.gd",
		"res://scripts/first_mvp/visual/exterior_spike_layout.gd",
		"res://scripts/first_mvp/visual/exterior_spike_overlay.gd",
		"res://scenes/first_mvp/calibration/scale_calibration_hall.tscn",
		"res://scenes/first_mvp/visual/exterior_asset_compatibility_spike.tscn",
		"res://scripts/app/prototype_app.gd",
		"res://scripts/prototype_zero/prototype_zero.gd",
	]:
		_expect(FileAccess.file_exists(path), "%s is missing" % path)
		if not FileAccess.file_exists(path):
			continue
		checked += 1
		var source: String = FileAccess.get_file_as_string(path)
		for directory: String in new_directories:
			_expect(not source.contains(directory),
				"%s names %s; the closed work must not start using the D-202 candidates" % [
					path.get_file(), directory,
				])
	print("  %d closed-gate files scanned; none names a D-202 candidate directory" % checked)

	# And the first spike's own manifest is still exactly what D-198 authorized:
	# this work extended the project, it did not widen that one.
	_expect(ExteriorAssetCatalogue.manifest().size() == 18,
		"the first Gate 1B spike's catalogue now holds %d models, not the authorized 18"
		% ExteriorAssetCatalogue.manifest().size())
	_expect(ExteriorAssetCatalogue.LICENCE_COPIES.size() == 3,
		"the first Gate 1B spike's licence list changed size")
	print("  the first Gate 1B spike's catalogue is still exactly its 18 models and 3 licence copies")


# --- 8. Visible surfaces (§9.7) -----------------------------------------------

func _check_surfaces_are_on_screen() -> void:
	print("")
	print("--- The review surfaces really are on screen (§9.7)")
	var view: Rect2 = get_viewport().get_visible_rect()
	var root: Control = comparison.overlay as Control
	var rect: Rect2 = root.get_global_rect()
	var offscreen: PackedStringArray = PackedStringArray()
	var total: int = _collect_offscreen_text(root, view, offscreen)
	print("  overlay root %.0f x %.0f in a %.0f x %.0f viewport; %d text controls, %d off screen"
		% [rect.size.x, rect.size.y, view.size.x, view.size.y, total, offscreen.size()])
	_expect(rect.size.x >= view.size.x - 1.0 and rect.size.y >= view.size.y - 1.0,
		"the overlay root is %.0f x %.0f, not the %.0f x %.0f viewport" % [
			rect.size.x, rect.size.y, view.size.x, view.size.y,
		])
	_expect(total >= 8, "the overlay shows only %d text controls" % total)
	_expect(offscreen.is_empty(),
		"the overlay draws text off screen or at zero size: %s" % ", ".join(offscreen))

	var text: String = _visible_text_in(root).to_lower()
	for required: String in [
		"exterior cohesion comparison", "temporary developer review scene",
		"not riftfall landing", "comparison axes", "review controls",
		"kenney nature topology", "architecture", "dressing",
		"interface leak test", "your call", "module ladder",
		"colour atlas restored", "kenney", "quaternius",
	]:
		_expect(text.contains(required), "the overlay never says '%s'" % required)
	print("  the overlay states what this scene is, names every axis and family,")
	print("  carries the D-204 restored-atlas record, and leaves the call to the owner")


# --- 9. Rendered evidence (§8) ------------------------------------------------

func _capture_evidence() -> void:
	print("")
	print("--- Rendered evidence (§8)")
	var brief: bool = arguments.has("--shots-brief")
	var window: Vector2i = DisplayServer.window_get_size()
	if window.x <= 0 or window.y <= 0:
		window = Vector2i(get_viewport().get_visible_rect().size)
	# The filenames name the WINDOW, not the logical viewport: with
	# `stretch/mode = canvas_items` and an `expand` aspect, 1280 x 720 and
	# 1920 x 1080 are the same logical rect, so a viewport-derived suffix would
	# give both runs identical names and the second would overwrite the first.
	var suffix: String = "_%dx%d" % [window.x, window.y]
	comparison.reset_review()
	await _settle(4)

	# §8's eight required views, in its own order, plus the frames that make each
	# one auditable. `clean` additionally captures the frame with the overlay
	# hidden — the same F3 the owner has — because the panels necessarily cover
	# part of the space they describe.
	var stations: Array[Dictionary] = [
		{"name": "1_kaykit_baseline_neutral", "at": Vector3(0.0, 0.0, -4.0), "distance": 26.0,
			"mode": 0, "topology": false, "dressing": false, "candidate": false,
			"grid": false, "clean": true, "brief": true},
		{"name": "2_kaykit_baseline_treatment", "at": Vector3(0.0, 0.0, -4.0), "distance": 26.0,
			"mode": 0, "topology": false, "dressing": false, "candidate": true,
			"grid": false, "clean": true, "brief": true},
		{"name": "3a_topology_off", "at": Vector3(0.0, 0.0, 0.0), "distance": 24.0,
			"mode": 0, "topology": false, "dressing": false, "candidate": true,
			"grid": false, "clean": true, "brief": true},
		{"name": "3b_topology_on", "at": Vector3(0.0, 0.0, 0.0), "distance": 24.0,
			"mode": 0, "topology": true, "dressing": false, "candidate": true,
			"grid": false, "clean": true, "brief": true},
		{"name": "4a_quaternius_neutral", "at": Vector3(0.0, 0.0, 6.0), "distance": 24.0,
			"mode": 1, "topology": true, "dressing": false, "candidate": false,
			"grid": false, "clean": true, "brief": true},
		{"name": "4b_quaternius_treatment", "at": Vector3(0.0, 0.0, 6.0), "distance": 24.0,
			"mode": 1, "topology": true, "dressing": false, "candidate": true,
			"grid": false, "clean": true, "brief": true},
		{"name": "5a_kenney_town_neutral", "at": Vector3(0.0, 0.0, 6.0), "distance": 24.0,
			"mode": 2, "topology": true, "dressing": false, "candidate": false,
			"grid": false, "clean": true, "brief": true},
		{"name": "5b_kenney_town_treatment", "at": Vector3(0.0, 0.0, 6.0), "distance": 24.0,
			"mode": 2, "topology": true, "dressing": false, "candidate": true,
			"grid": false, "clean": true, "brief": true},
		{"name": "6a_dressing_off", "at": Vector3(0.0, 0.0, -8.0), "distance": 26.0,
			"mode": 0, "topology": true, "dressing": false, "candidate": true,
			"grid": false, "clean": true, "brief": true},
		{"name": "6b_dressing_on", "at": Vector3(0.0, 0.0, -8.0), "distance": 26.0,
			"mode": 0, "topology": true, "dressing": true, "candidate": true,
			"grid": false, "clean": true, "brief": true},
		{"name": "7a_knight_grid_kaykit", "at": Vector3(0.0, 0.0, 11.0), "distance": 19.0,
			"mode": 0, "topology": true, "dressing": false, "candidate": false,
			"grid": true, "clean": true, "brief": true},
		{"name": "7b_knight_grid_quaternius", "at": Vector3(0.0, 0.0, 11.0), "distance": 19.0,
			"mode": 1, "topology": true, "dressing": false, "candidate": false,
			"grid": true, "clean": true, "brief": true},
		{"name": "7c_knight_grid_kenney_town", "at": Vector3(0.0, 0.0, 11.0), "distance": 19.0,
			"mode": 2, "topology": true, "dressing": false, "candidate": false,
			"grid": true, "clean": true, "brief": true},
		{"name": "8a_route_from_the_arrival", "at": Vector3(0.0, 0.0, -19.0), "distance": 19.0,
			"mode": 0, "topology": true, "dressing": true, "candidate": true,
			"grid": false, "clean": true, "brief": true},
		{"name": "8b_route_at_the_threshold", "at": Vector3(0.0, 0.0, 10.0), "distance": 19.0,
			"mode": 0, "topology": true, "dressing": true, "candidate": true,
			"grid": false, "clean": true, "brief": true},
		{"name": "8c_whole_route_slice", "at": Vector3(0.0, 0.0, 0.0), "distance": 46.0,
			"mode": 0, "topology": true, "dressing": true, "candidate": true,
			"grid": false, "clean": true, "brief": true},
		{"name": "8d_whole_route_slice_neutral", "at": Vector3(0.0, 0.0, 0.0),
			"distance": 46.0, "mode": 0, "topology": false, "dressing": false,
			"candidate": false, "grid": false, "clean": true, "brief": true},
		{"name": "9_launch_state_from_the_spawn", "at": Vector3(0.0, 0.0, -20.0),
			"distance": 19.0, "mode": 0, "topology": false, "dressing": false,
			"candidate": false, "grid": false, "clean": false, "brief": false},
	]

	for station: Dictionary in stations:
		if brief and not bool(station["brief"]):
			continue
		comparison.set_architecture(int(station["mode"]) as ExteriorCohesionRoute.Architecture)
		comparison.set_topology_visible(bool(station["topology"]))
		comparison.set_dressing_visible(bool(station["dressing"]))
		comparison.set_lighting_candidate(bool(station["candidate"]))
		comparison.set_candidate_materials(bool(station["candidate"]))
		route.set_grid_visible(bool(station["grid"]))
		comparison.camera_rig.adjust_distance(
			float(station["distance"]) - comparison.camera_rig.distance_metres
		)
		await _teleport(station["at"])
		await _shoot("gate_1b_cohesion_%s%s" % [station["name"], suffix], 8)
		if bool(station["clean"]):
			comparison.set_overlay_visible(false)
			await _shoot("gate_1b_cohesion_%s_clean%s" % [station["name"], suffix], 5)
			comparison.set_overlay_visible(true)
		await _settle(3)

	# A click-to-move destination on the open route, so the marker is in frame.
	comparison.reset_review()
	await _teleport(Vector3(-4.0, 0.0, -14.0))
	var goal: Vector3 = comparison.resolve_to_navigation(Vector3(3.0, 0.0, -2.0))["point"]
	player.command_move_to(goal, goal, false)
	await _settle(20)
	await _shoot("gate_1b_cohesion_10_click_to_move" + suffix, 4)
	player.clear_movement_intent("evidence cleanup", false)
	await _settle(4)
	comparison.reset_review()
	await _settle(4)


func _shoot(name_stem: String, settle_frames: int) -> void:
	for i: int in settle_frames:
		await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var path: String = "%s/%s.png" % [_shot_dir, name_stem]
	get_viewport().get_texture().get_image().save_png(path)
	print("  screenshot: %s" % path)


# --- Helpers ------------------------------------------------------------------

## Reads one file out of one archive and compares it, byte for byte, with the
## game-side copy. All four D-202 archives are ZIPs, so this needs no shell step.
func _archive_bytes_match(archive: String, inside: String, game_side: String) -> bool:
	var reader: ZIPReader = ZIPReader.new()
	if reader.open(ProjectSettings.globalize_path("res://../%s" % archive)) != OK:
		return false
	if not reader.file_exists(inside):
		reader.close()
		return false
	var archived: PackedByteArray = reader.read_file(inside)
	reader.close()
	if not FileAccess.file_exists(game_side):
		return false
	var extracted: PackedByteArray = FileAccess.get_file_as_bytes(game_side)
	return archived == extracted


## A stable text description of every collision box the route built, used to prove
## that a review toggle changed none of them.
## Every comparison mode in one comparable string, so "an interface click changed
## nothing" is a witness rather than an assurance.
func _mode_fingerprint() -> String:
	return "light=%d materials=%s topology=%s architecture=%d dressing=%s grid=%s overlay=%s camera=%.3f" % [
		int(comparison.lighting.mode), str(comparison.treatment.candidate_active()),
		str(route.topology_visible), int(route.architecture),
		str(route.dressing_visible), str(route.grid_visible),
		str(comparison.overlay_visible), comparison.camera_rig.distance_metres,
	]


func _solid_fingerprint() -> String:
	var parts: PackedStringArray = PackedStringArray()
	for entry: Dictionary in route.solids():
		var box: AABB = entry["aabb"]
		parts.append("%s|%.4f,%.4f,%.4f|%.4f,%.4f,%.4f" % [
			entry["name"], box.position.x, box.position.y, box.position.z,
			box.size.x, box.size.y, box.size.z,
		])
	parts.sort()
	return "\n".join(parts)


func _is_metallic(node: Node3D, use_override: bool = false) -> bool:
	for mesh_instance: MeshInstance3D in _meshes_under(node):
		for surface: int in mesh_instance.mesh.get_surface_count():
			var material: Material = (
				mesh_instance.get_surface_override_material(surface) if use_override
				else mesh_instance.get_active_material(surface)
			)
			var standard: StandardMaterial3D = material as StandardMaterial3D
			if standard == null:
				continue
			if standard.metallic > 0.5:
				return true
	return false


func _meshes_under(node: Node) -> Array[MeshInstance3D]:
	var found: Array[MeshInstance3D] = []
	var mesh_instance: MeshInstance3D = node as MeshInstance3D
	if mesh_instance != null and mesh_instance.mesh != null:
		found.append(mesh_instance)
	for child: Node in node.get_children():
		found.append_array(_meshes_under(child))
	return found


func _count_third_party_payloads(directory: String) -> int:
	var total: int = 0
	var handle: DirAccess = DirAccess.open(directory)
	if handle == null:
		return 0
	for file: String in handle.get_files():
		if file.ends_with(".import") or file.ends_with(".md") or file == ".DS_Store":
			continue
		total += 1
	for sub: String in handle.get_directories():
		total += _count_third_party_payloads("%s/%s" % [directory, sub])
	return total


func _count_third_party_notes(directory: String) -> int:
	var total: int = 0
	var handle: DirAccess = DirAccess.open(directory)
	if handle == null:
		return 0
	for file: String in handle.get_files():
		if file.ends_with(".md"):
			total += 1
	for sub: String in handle.get_directories():
		total += _count_third_party_notes("%s/%s" % [directory, sub])
	return total


## The raw left-stick reading that produces a given WORLD direction at the current
## camera yaw. Derived from the camera's own ground basis rather than hard-coded.
func _stick_toward(world_direction: Vector3) -> Vector2:
	var wanted: Vector3 = Vector3(world_direction.x, 0.0, world_direction.z).normalized()
	var forward: Vector3 = comparison.camera_rig.ground_forward()
	var right: Vector3 = comparison.camera_rig.ground_right()
	return Vector2(wanted.dot(right), -wanted.dot(forward))


func _teleport(to: Vector3) -> void:
	comparison.set_stick_override(Vector2.ZERO)
	player.clear_movement_intent("verification teleport", false)
	player.global_position = Vector3(to.x, 0.0, to.z)
	player.velocity = Vector3.ZERO
	comparison.set_stick_override(null)
	await _settle(6)


## Putting the physical controls at rest is not the same as being allowed to act
## again: the scene lifts its neutral latch on its own, and this waits for it.
func _release_all_inputs() -> void:
	comparison.set_stick_override(Vector2.ZERO)
	Input.action_release(&"move_point")
	for frame: int in 30:
		await get_tree().physics_frame
		if not player.awaiting_neutral:
			break
	comparison.set_stick_override(null)


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


func _comparison_uses(type_name: String) -> bool:
	for path: String in SHIPPING_SCRIPTS:
		if _code_only(FileAccess.get_file_as_string(path)).contains(type_name):
			return true
	return false


## Strips comment lines so a source scan reads CODE. A file that says in prose
## that it writes no user:// path must not fail its own check.
func _code_only(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


## RECURSIVE since D-204, and that is the point of it. The two authorized colour
## atlases live in a `Textures/` SUBDIRECTORY of two candidate folders, so a scan
## that stopped at the top level would not have seen them — and, far worse, would
## not have seen an UNAUTHORIZED file put beside them either. A guard that cannot
## look into a subdirectory does not guard the subdirectory.
func _files_under(directory: String) -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	var handle: DirAccess = DirAccess.open(directory)
	if handle == null:
		return found
	for file: String in handle.get_files():
		found.append("%s/%s" % [directory, file])
	for sub: String in handle.get_directories():
		found.append_array(_files_under("%s/%s" % [directory, sub]))
	return found


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
						control.name, rect.position.x, rect.position.y,
						rect.size.x, rect.size.y,
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


## The D-215 availability record's approved payloads, read by path. Empty when the
## record is absent, so this gate reports the disk count disagreeing with the
## authorization rather than throwing.
func _d215_approved_payloads() -> Array:
	var record_path: String = "res://scripts/environment/approved_environment_palette.gd"
	if not ResourceLoader.exists(record_path):
		return []
	var record: GDScript = load(record_path) as GDScript
	if record == null:
		return []
	var constants: Dictionary = record.get_script_constant_map()
	if not constants.has("PAYLOADS"):
		return []
	return constants["PAYLOADS"]
