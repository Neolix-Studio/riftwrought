extends Node
## First-MVP Gate 1B — automated verification of the Exterior Asset
## Compatibility Spike.
##
## Specification §8 lists eight things this must prove. It proves what a machine
## CAN settle: that the extraction is exactly the authorized manifest and every
## payload, texture, licence, and provenance record travelled with it; that every
## candidate imports at root scale 1.0 and measures what the report says it
## measures; that the accepted world, camera, movement, and InputMap are
## untouched; that the three review areas, the real Knight, and the registered
## Dungeon transition reference are all present; that every review toggle works
## and that returning to source mode reproduces the imported presentation exactly;
## that no later first-MVP system leaked in; that nothing is written to disk; and
## that the visible surfaces are actually on screen.
##
## WHAT IT DELIBERATELY DOES NOT DECIDE. Specification §7: "The report separates
## measured facts from visual judgement. Automated checks do not decide whether an
## asset belongs in Riftwrought." There is no assertion anywhere below about
## whether a candidate looks right, and no check computes §7's "foreground,
## background-only, or reject" column — §9 reserves that for the project owner,
## and automated success leaves the spike OPEN.
##
## Run:  godot --headless --path game res://scenes/first_mvp/visual/exterior_asset_compatibility_spike.tscn -- --verify-1b
##       godot --path game --resolution 1280x720 res://.../exterior_asset_compatibility_spike.tscn -- --verify-1b --shots <dir>

const TICK: float = 1.0 / 60.0

## D-175's accepted contract. §5.4 requires every one of these to be preserved,
## and they are asserted against the objects the spike actually built.
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

## The complete InputMap this project declares. Gate 1B adds none of them and
## removes none: §6 requires "physical-key developer toggles without adding
## InputMap actions", and this list is how that is proved rather than promised.
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

## Shipping Gate 1B code. The verification itself is excluded by construction —
## it lives under `tests/`, not under `scripts/first_mvp/` — so a scan for
## forbidden storage strings cannot be confused by the file that forbids them.
const SHIPPING_SCRIPTS: Array[String] = [
	"res://scripts/first_mvp/visual/exterior_asset_compatibility_spike.gd",
	"res://scripts/first_mvp/visual/exterior_asset_catalogue.gd",
	"res://scripts/first_mvp/visual/exterior_asset_probe.gd",
	"res://scripts/first_mvp/visual/exterior_review_lighting.gd",
	"res://scripts/first_mvp/visual/exterior_review_treatment.gd",
	"res://scripts/first_mvp/visual/exterior_spike_layout.gd",
	"res://scripts/first_mvp/visual/exterior_spike_overlay.gd",
]

const SOURCE_NOTE_KAYKIT: String = "res://assets/third_party/kaykit/SOURCE_AND_LICENSE.md"
const SOURCE_NOTE_K0RVEEN: String = "res://assets/third_party/k0rveen/SOURCE_AND_LICENSE.md"
const REPO_PROVENANCE: String = "res://../assets/licenses/K0RVEEN_LOW_POLY_ENVIRONMENT_PACK_CC_BY_4.0_SOURCE.md"
const GAME_PROVENANCE: String = "res://assets/third_party/k0rveen/licenses/K0RVEEN_LOW_POLY_ENVIRONMENT_PACK_CC_BY_4.0_SOURCE.md"

## D-208 §11.2. The one Gate 1C path this closed instrument is aware of, and only
## in order to prove it stays outside.
const GATE_1C_CANONICAL_SCENE: String = (
	"res://scenes/first_mvp/severed_threshold/riftfall_landing.tscn"
)

var spike: ExteriorAssetCompatibilitySpike
var arguments: PackedStringArray = PackedStringArray()

var layout: ExteriorSpikeLayout
var player: CalibrationHallPlayer

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _shot_dir: String = ""


func _ready() -> void:
	await run()


func run() -> void:
	layout = spike.layout
	player = spike.player
	_shot_dir = _argument_value("--shots")

	print("")
	print("=== First-MVP Gate 1B verification — Exterior Asset Compatibility Spike ===")
	await _settle(10)

	_check_engine_and_entrypoint()
	_check_accepted_values_untouched()
	_check_input_map_untouched()
	_check_extraction_manifest()
	_check_payloads_and_traceability()
	_check_licences_and_credit()
	_report_measurements()
	_check_import_state()
	_check_review_areas()
	_check_dungeon_transition()
	_check_navigation_and_terrain()
	await _check_click_resolution()
	await _check_movement()
	_check_locomotion_contract()
	await _check_controller_and_arbitration()
	await _check_refused_combat_inputs()
	await _check_review_lighting()
	await _check_material_treatment()
	await _check_k0rveen_toggle()
	await _check_grid_and_overlay_toggles()
	await _check_reset()
	_check_scope()
	_check_no_state_written()
	_check_surfaces_are_on_screen()

	if _shot_dir != "":
		await _capture_evidence()

	print("")
	if _failures.is_empty():
		print("GATE 1B VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("GATE 1B VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		get_tree().quit(1)


# --- 1. Engine, entrypoint, and the accepted values ---------------------------

func _check_engine_and_entrypoint() -> void:
	print("")
	print("--- Engine baseline and entrypoint (§8.2 and §8.5)")
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
		"the project main scene is '%s'; Gate 1B must not replace the Prototype App" % main_scene)
	for required: String in [
		"res://scenes/app/prototype_app.tscn",
		"res://scenes/prototype_zero/prototype_zero.tscn",
		"res://scenes/prototype_zero/gate_a_asset_spike.tscn",
		"res://scenes/first_mvp/calibration/scale_calibration_hall.tscn",
	]:
		_expect(ResourceLoader.exists(required), "%s is missing" % required)
	print("  the Prototype App, the laboratory, the Gate A spike, and the Gate 1A hall all still exist")


## §8.5: the Prototype Zero resources and the Gate 1A calibration record are
## unchanged. Re-read here so a change to any of them fails inside the Gate 1B
## run as well as in the locked chain the smoke script runs first.
func _check_accepted_values_untouched() -> void:
	print("")
	print("--- Prototype Zero and Gate 1A accepted values are untouched (§8.5)")
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
		# The PROPERTY IS ASSERTED TO EXIST before its value is read, and that is
		# not defensive tidiness. `Resource.get()` answers `null` for a name that
		# is not there, `float(null)` throws, and a throw inside a check function
		# aborts the WHOLE function — every later assertion in it silently never
		# runs while the suite still reports PASS. This spike FOUND that shape live
		# in the Gate 1A verification and reported it (report §8): two of the seven
		# fields `_check_prototype_zero_is_untouched()` re-read were named wrongly,
		# so its FIRST assertion ran and the remaining SIX were silently skipped
		# behind `PASS (278 checks)`. D-200 authorized the repair and D-201
		# delivered it — measured 278 + 6 = 284 — so the defect is fixed and this
		# guard is why an equivalent typo here would fail visibly instead. Do NOT
		# copy this guard's shape into `gate_1a_verification.gd`: it emits an
		# existence assertion AND a value assertion per row, which would take Gate
		# 1A from 284 to 291 without any assertion having become false.
		#
		# This comment is the D-202-authorized housekeeping correction; it is
		# comment text only, and no executable line above or below it changed.
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


## §6: no InputMap action was added. This is the sharpest of the scope checks,
## because the Gate B, E, and F suites each walk `InputMap.get_actions()` and emit
## one assertion per key event, so a single new action here would move three
## locked Prototype Zero counts without any old assertion having become false.
func _check_input_map_untouched() -> void:
	print("")
	print("--- The InputMap is byte-for-byte the accepted set (§6, §8.5)")
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
		"review_lighting", "review_materials", "toggle_k0rveen", "exterior_reset",
		"toggle_treatment", "spike_reset",
	]:
		_expect(not InputMap.has_action(forbidden),
			"a Gate 1B input action '%s' was declared; §6 forbids adding any" % forbidden)
	for path: String in SHIPPING_SCRIPTS:
		var source: String = _code_only(FileAccess.get_file_as_string(path))
		_expect(not source.contains("InputMap.add_action"),
			"%s adds an input action at runtime" % path.get_file())
	print("  every review toggle is read as a physical key; no action was added by data or by code")


# --- 2. The extraction manifest (§8.4) ----------------------------------------

func _check_extraction_manifest() -> void:
	print("")
	print("--- The exact §4 extraction manifest (§8.4)")
	var manifest: Array[Dictionary] = ExteriorAssetCatalogue.manifest()
	print("  %d catalogued candidate models" % manifest.size())
	_expect(manifest.size() == 18,
		"the catalogue holds %d models; §4 authorizes exactly 18" % manifest.size())
	var by_family: Dictionary = {}
	for record: Dictionary in manifest:
		var family: String = String(record["family"])
		by_family[family] = int(by_family.get(family, 0)) + 1
		_expect(ResourceLoader.exists(String(record["path"])),
			"%s is missing from the project" % record["path"])
		var scene: PackedScene = load(String(record["path"])) as PackedScene
		_expect(scene != null, "%s did not import as a scene" % record["path"])
	print("  Forest %d, Halloween %d, k0rveen %d" % [
		int(by_family.get(ExteriorAssetCatalogue.FAMILY_FOREST, 0)),
		int(by_family.get(ExteriorAssetCatalogue.FAMILY_HALLOWEEN, 0)),
		int(by_family.get(ExteriorAssetCatalogue.FAMILY_K0RVEEN, 0)),
	])
	_expect(int(by_family.get(ExteriorAssetCatalogue.FAMILY_FOREST, 0)) == 5,
		"§4.1 authorizes exactly five Forest models")
	_expect(int(by_family.get(ExteriorAssetCatalogue.FAMILY_HALLOWEEN, 0)) == 8,
		"§4.2 authorizes exactly eight Halloween models")
	_expect(int(by_family.get(ExteriorAssetCatalogue.FAMILY_K0RVEEN, 0)) == 5,
		"§4.3 authorizes exactly five k0rveen models")

	# Nothing was extracted that §4 does not name. The three candidate directories
	# are walked and every file in them must be manifest, payload, or Godot's own
	# import settings.
	#
	# THE ALLOWLIST MOVED FORWARD BY AUTHORIZATION UNDER D-215, one for one, and it
	# is the union of TWO authorizations rather than a widening of either. §4 of the
	# spike brief still authorizes exactly what it authorized — the five Forest and
	# eight Halloween models above are still asserted at five and eight, from
	# `ExteriorAssetCatalogue` alone, and that catalogue was NOT edited. What is
	# added is the separate D-215 availability record, read the same way the Zone
	# Composer palette reads it, plus each of its models' `.bin` sidecar.
	#
	# The count this loop contributes therefore moves by exactly the number of new
	# Forest and Halloween files: 4 Forest + 8 Halloween models = 12 models = 24
	# files, so Gate 1B moves 654 -> 678. The 35 Dungeon models D-215 also approved
	# are invisible here, because `kaykit/dungeon` is not one of the three
	# directories this loop walks — an asymmetry worth stating rather than leaving
	# to be rediscovered.
	var allowed: PackedStringArray = ExteriorAssetCatalogue.expected_files()
	for payload: Dictionary in _d215_approved_payloads():
		var payload_path: String = String(payload.get("path", ""))
		if payload_path.is_empty():
			continue
		allowed.append(payload_path)
		allowed.append(payload_path.get_basename() + ".bin")
	for directory: String in [
		ExteriorAssetCatalogue.DIR_FOREST, ExteriorAssetCatalogue.DIR_HALLOWEEN,
		ExteriorAssetCatalogue.DIR_K0RVEEN,
	]:
		var found: PackedStringArray = _files_in(directory)
		for file: String in found:
			if file.ends_with(".import"):
				continue
			_expect(allowed.has(file),
				"%s was extracted but neither §4 nor D-215 authorizes it" % file)
		print("  %s: %d files" % [directory.get_file(), found.size()])

	# The excluded families §4 names by hand, checked by name rather than by
	# counting: no pumpkin, grave, crypt, coffin, skull, living tree, bush, or
	# grass reached the project.
	for forbidden: String in [
		"pumpkin", "grave", "crypt", "coffin", "skull", "bush", "grass", "candle",
		"Tree_1_A", "Tree_2_A", "bench",
	]:
		var leaked: PackedStringArray = PackedStringArray()
		for directory: String in [
			ExteriorAssetCatalogue.DIR_FOREST, ExteriorAssetCatalogue.DIR_HALLOWEEN,
		]:
			for file: String in _files_in(directory):
				if file.get_file().to_lower().contains(forbidden.to_lower()):
					leaked.append(file)
		_expect(leaked.is_empty(),
			"§4 excludes '%s' and %s was extracted" % [forbidden, ", ".join(leaked)])
	print("  none of the §4 exclusions — pumpkins, graves, the crypt, seasonal foliage — was extracted")


## Every required payload exists, and every URI the glTF itself declares resolves
## to a file beside it. That is the difference between "the file is there" and
## "the file works": a missing `.bin` or a renamed atlas would still leave the
## `.gltf` on disk.
func _check_payloads_and_traceability() -> void:
	print("")
	print("--- Payloads, textures, and the source map (§8.4)")
	var uris_checked: int = 0
	for record: Dictionary in ExteriorAssetCatalogue.manifest():
		for payload: String in (record["payload"] as PackedStringArray):
			_expect(FileAccess.file_exists(payload),
				"%s is missing the payload %s" % [record["key"], payload])
		var path: String = String(record["path"])
		if not path.ends_with(".gltf"):
			continue
		var text: String = FileAccess.get_file_as_string(path)
		var parsed: Variant = JSON.parse_string(text)
		_expect(parsed is Dictionary, "%s is not valid glTF JSON" % path)
		if not (parsed is Dictionary):
			continue
		var document: Dictionary = parsed
		var base: String = path.get_base_dir()
		for section: String in ["buffers", "images"]:
			for entry: Variant in document.get(section, []):
				var uri: String = String((entry as Dictionary).get("uri", ""))
				if uri.is_empty():
					continue
				uris_checked += 1
				_expect(FileAccess.file_exists("%s/%s" % [base, uri]),
					"%s declares %s and it is not beside it" % [path.get_file(), uri])
	print("  %d declared glTF buffer and image URIs all resolve beside their model" % uris_checked)

	# The game-side source note is the file-by-file map back to the archives.
	var kaykit_note: String = FileAccess.get_file_as_string(SOURCE_NOTE_KAYKIT)
	var k0rveen_note: String = FileAccess.get_file_as_string(SOURCE_NOTE_K0RVEEN)
	_expect(not kaykit_note.is_empty(), "the KayKit source note is missing")
	_expect(not k0rveen_note.is_empty(), "the k0rveen source note is missing")
	for record: Dictionary in ExteriorAssetCatalogue.manifest():
		var note: String = (
			k0rveen_note if String(record["family"]) == ExteriorAssetCatalogue.FAMILY_K0RVEEN
			else kaykit_note
		)
		var stem: String = String(record["path"]).get_file().get_basename()
		_expect(note.contains(stem),
			"the source note never names %s" % stem)
		_expect(note.contains(String(record["archive"]).get_file()),
			"the source note never names the archive %s" % record["archive"])
	print("  every extracted model is mapped back to its archive in the game-side source note")

	# And the repository register records the extraction, because the register is
	# the authority the source note answers to.
	var register: String = FileAccess.get_file_as_string("res://../assets/ASSET_REGISTER.md")
	_expect(not register.is_empty(), "assets/ASSET_REGISTER.md could not be read")
	for family: String in ExteriorAssetCatalogue.families():
		_expect(register.contains(family.split(" 1.0")[0].split(" Pack")[0]),
			"the Asset Register never names %s" % family)
	_expect(register.contains("Gate 1B"),
		"the Asset Register does not record the Gate 1B extraction")
	print("  the repository Asset Register records the Gate 1B extraction")


## The licence copies are proved VERBATIM against the archives themselves,
## through `ZIPReader`, rather than by looking for a phrase in them. The k0rveen
## archive has no licence to compare against — which is the whole reason §4.3
## makes the durable provenance record mandatory — so that copy is compared
## byte-for-byte against the repository record it must reproduce.
func _check_licences_and_credit() -> void:
	print("")
	print("--- Verbatim licence copies, the provenance record, and the credit (§8.4)")
	for copy: Dictionary in ExteriorAssetCatalogue.LICENCE_COPIES:
		var game_side: String = String(copy["path"])
		_expect(FileAccess.file_exists(game_side), "%s is missing" % game_side)
		if not FileAccess.file_exists(game_side):
			continue
		var here: PackedByteArray = FileAccess.get_file_as_bytes(game_side)
		var archive: String = String(copy["archive"])
		if archive.ends_with(".zip"):
			var reader: ZIPReader = ZIPReader.new()
			var opened: Error = reader.open(
				ProjectSettings.globalize_path("res://../%s" % archive)
			)
			_expect(opened == OK, "could not open %s to check its licence" % archive)
			if opened != OK:
				continue
			var inside: PackedByteArray = reader.read_file(String(copy["source"]))
			reader.close()
			_expect(inside == here,
				"%s is not byte-identical to %s inside %s" % [
					game_side.get_file(), copy["source"], archive,
				])
			_expect(here.get_string_from_utf8().contains("Creative Commons Zero"),
				"%s does not declare CC0" % game_side.get_file())
			print("  %s  %d bytes, verbatim from %s" % [
				game_side.get_file(), here.size(), archive.get_file(),
			])
		else:
			var record: PackedByteArray = FileAccess.get_file_as_bytes(REPO_PROVENANCE)
			_expect(not record.is_empty(), "the repository k0rveen provenance record is missing")
			_expect(record == here,
				"the game-side k0rveen provenance note is not byte-identical to the repository record")
			var text: String = here.get_string_from_utf8()
			for required: String in [
				"Creative Commons Attribution", "k0rveen",
				"https://k0rveen.itch.io/lowpoly-environment-pack",
				"https://creativecommons.org/licenses/by/4.0/",
				ExteriorAssetCatalogue.K0RVEEN_CREDIT,
			]:
				_expect(text.contains(required),
					"the k0rveen provenance note is missing '%s'" % required)
			print("  %s  %d bytes, byte-identical to the repository record" % [
				game_side.get_file(), here.size(),
			])

	# The CC BY 4.0 credit must survive into the game-side note, into the code,
	# and onto the screen. §4.3 requires the first; a licence obligation nobody
	# can read is not discharged.
	var note: String = FileAccess.get_file_as_string(SOURCE_NOTE_K0RVEEN)
	_expect(note.contains(ExteriorAssetCatalogue.K0RVEEN_CREDIT),
		"the game-side k0rveen source note does not carry the required credit")
	var visible: String = _visible_text_in(spike.overlay)
	_expect(visible.contains(ExteriorAssetCatalogue.K0RVEEN_CREDIT),
		"the required CC BY 4.0 credit is not on screen")
	print("  the required credit is in the source note, in the catalogue, and on screen")

	# The KayKit payloads themselves are proved verbatim the same way. The
	# k0rveen FBX files cannot be read out of a RAR from inside Godot and are
	# checked in the shell step of the smoke script instead, which the report says
	# rather than leaving the gap unstated.
	var compared: int = 0
	for record: Dictionary in ExteriorAssetCatalogue.manifest():
		var archive: String = String(record["archive"])
		if not archive.ends_with(".zip"):
			continue
		var reader: ZIPReader = ZIPReader.new()
		if reader.open(ProjectSettings.globalize_path("res://../%s" % archive)) != OK:
			continue
		var inside: PackedByteArray = reader.read_file(String(record["in_archive"]))
		reader.close()
		var here: PackedByteArray = FileAccess.get_file_as_bytes(String(record["path"]))
		_expect(inside == here,
			"%s is not byte-identical to %s" % [record["path"], record["in_archive"]])
		compared += 1
	print("  %d KayKit models proved byte-identical to their in-archive originals" % compared)
	_expect(compared == 13, "expected 13 KayKit models to compare, compared %d" % compared)


# --- 3. Measurements (§7) -----------------------------------------------------

## Specification §7's table, printed so the report quotes measurements rather
## than restating intentions. The last §7 row — foreground / background-only /
## reject — is deliberately absent: §9 reserves it for the project owner.
func _report_measurements() -> void:
	print("")
	print("--- §7 measured candidate table (root scale 1.0, from the placed instances)")
	print("  %-30s %-22s %8s %8s %8s %7s %5s %5s %8s %s" % [
		"candidate", "family", "x", "y", "z", "base", "mesh", "surf", "screen", "texture",
	])
	for row: Dictionary in spike.candidate_measurements():
		var size: Vector3 = row["size"]
		var textures: PackedStringArray = row["textures"]
		print("  %-30s %-22s %8.3f %8.3f %8.3f %7.3f %5d %5d %7.1f%% %s" % [
			row["display"], String(row["family"]).substr(0, 22),
			size.x, size.y, size.z, float(row["base_offset"]),
			int(row["meshes"]), int(row["surfaces"]),
			float(row["screen_fraction"]) * 100.0,
			"none" if textures.is_empty() else String(textures[0]).get_file(),
		])
	var m: Dictionary = spike.measurements()
	print("  review ground   %.0f x %.0f m (not a room target)" % [
		float(m["ground_metres"].x), float(m["ground_metres"].y),
	])
	print("  hybrid court    %.0f x %.0f m, %.1f%% clear of collision-bearing decoration" % [
		float(m["court_metres"].x), float(m["court_metres"].y),
		float(m["court_clear_fraction"]) * 100.0,
	])
	print("  dungeon doorway %.3f m measured between the registered wall_pillar faces" % (
		float(m["dungeon_doorway"])
	))
	print("  arch opening    %.3f m measured between the Halloween arch's leg faces (%.2f P)" % [
		float(m["arch_opening"]), float(m["arch_opening"]) / ACCEPTED_P,
	])
	print("  navigation      %d polygons, %.1f m^2 walkable, %d ms" % [
		int(m["navmesh_polygons"]), float(m["navmesh_area"]), int(m["bake_msec"]),
	])
	print("  measured flat-surface heights, in each piece's own space:")
	for key: String in layout.surface_drops:
		print("    %-26s %+.3f m" % [key, float(layout.surface_drops[key])])


## §7: "import root scale" and whether normals, transparency, or double-sided
## rendering fail. Root scale is read out of Godot's own `.import` settings, so
## the answer is the importer's rather than an inference from the mesh.
func _check_import_state() -> void:
	print("")
	print("--- Import state: root scale, normals, transparency, shadows (§7)")
	for record: Dictionary in ExteriorAssetCatalogue.manifest():
		var import_path: String = "%s.import" % record["path"]
		_expect(FileAccess.file_exists(import_path),
			"%s has no import settings" % record["path"])
		if not FileAccess.file_exists(import_path):
			continue
		var settings: String = FileAccess.get_file_as_string(import_path)
		# Godot omits `nodes/root_scale` from the file when it is the default 1.0,
		# so both "absent" and "=1.0" are the same answer and anything else is a
		# rescale this spike did not authorize.
		var scale_line: String = ""
		for line: String in settings.split("\n"):
			if line.begins_with("nodes/root_scale="):
				scale_line = line.strip_edges()
		_expect(scale_line.is_empty() or scale_line == "nodes/root_scale=1.0",
			"%s imports at %s, not root scale 1.0" % [record["key"], scale_line])

	var without_normals: PackedStringArray = PackedStringArray()
	var double_sided: PackedStringArray = PackedStringArray()
	var transparent: PackedStringArray = PackedStringArray()
	var not_lit: PackedStringArray = PackedStringArray()
	var no_shadow: PackedStringArray = PackedStringArray()
	var rescaled: PackedStringArray = PackedStringArray()
	for row: Dictionary in spike.candidate_measurements():
		if int(row["missing_normals"]) > 0:
			without_normals.append(String(row["display"]))
		if int(row["double_sided"]) > 0:
			double_sided.append(String(row["display"]))
		if int(row["transparent"]) > 0:
			transparent.append(String(row["display"]))
		if not bool(row["receives_light"]):
			not_lit.append(String(row["display"]))
		if not bool(row["casts_shadow"]):
			no_shadow.append(String(row["display"]))
		if not (row["scale"] as Vector3).is_equal_approx(Vector3.ONE):
			rescaled.append(String(row["display"]))
	print("  normals missing: %d   double-sided: %d   transparent: %d   unlit: %d   shadowless: %d" % [
		without_normals.size(), double_sided.size(), transparent.size(),
		not_lit.size(), no_shadow.size(),
	])
	_expect(without_normals.is_empty(), "no normals on %s" % ", ".join(without_normals))
	_expect(not_lit.is_empty(), "unshaded material on %s" % ", ".join(not_lit))
	_expect(no_shadow.is_empty(), "shadow casting disabled on %s" % ", ".join(no_shadow))
	_expect(rescaled.is_empty(), "the spike rescaled %s" % ", ".join(rescaled))
	# The runtime treatment's shader is opaque and single-sided, so a double-sided
	# or transparent source would be silently misrepresented by it. None is, and
	# the treatment says so itself rather than this check assuming it.
	_expect(spike.treatment.unfaithful_surfaces.is_empty(),
		"the candidate treatment cannot faithfully reproduce %s" % ", ".join(
			spike.treatment.unfaithful_surfaces))
	print("  every candidate imports at root scale 1.0, lit, shadow-casting, opaque, single-sided")

	# The KayKit families each resolve to ONE shared atlas, which is the strongest
	# available statement that the texture reference survived extraction.
	var atlases: PackedStringArray = PackedStringArray()
	for row: Dictionary in spike.candidate_measurements():
		for texture: String in (row["textures"] as PackedStringArray):
			if not atlases.has(texture):
				atlases.append(texture)
	print("  texture atlases resolved: %s" % ", ".join(atlases))
	_expect(atlases.size() == 2,
		"expected exactly two KayKit atlases to resolve, found %d" % atlases.size())
	for expected: String in [
		ExteriorAssetCatalogue.TEXTURE_FOREST, ExteriorAssetCatalogue.TEXTURE_HALLOWEEN,
	]:
		_expect(atlases.has(expected), "%s never resolved" % expected)


# --- 4. Scene composition (§8.7) ----------------------------------------------

func _check_review_areas() -> void:
	print("")
	print("--- The three §5 review areas (§8.7)")
	var areas: Dictionary = {}
	for entry: Dictionary in layout.placed:
		var area: String = String(entry["area"])
		areas[area] = int(areas.get(area, 0)) + 1
	for area: String in ["lineup_forest", "lineup_halloween", "court", "k0rveen", "transition"]:
		print("  %-18s %d instances" % [area, int(areas.get(area, 0))])
		_expect(int(areas.get(area, 0)) > 0, "the '%s' area is empty" % area)

	# §5.1: every extracted Forest and Halloween model appears ONCE in the source
	# lineup, at root scale 1.0 and with its source material intact.
	var lineup_keys: PackedStringArray = PackedStringArray()
	for entry: Dictionary in layout.placed:
		if String(entry["area"]).begins_with("lineup_"):
			_expect(not lineup_keys.has(String(entry["key"])),
				"%s appears twice in the source lineup" % entry["key"])
			lineup_keys.append(String(entry["key"]))
	for record: Dictionary in ExteriorAssetCatalogue.manifest():
		if String(record["family"]) == ExteriorAssetCatalogue.FAMILY_K0RVEEN:
			continue
		_expect(lineup_keys.has(String(record["key"])),
			"%s is not in the §5.1 source lineup" % record["key"])
	print("  all %d Forest and Halloween models appear exactly once in the source lineup" % lineup_keys.size())

	# §5.3: all five k0rveen candidates are shown.
	var k0rveen_keys: PackedStringArray = PackedStringArray()
	for entry: Dictionary in layout.placed:
		if String(entry["area"]) == "k0rveen":
			k0rveen_keys.append(String(entry["key"]))
	_expect(k0rveen_keys.size() == 5,
		"the k0rveen lineup shows %d of 5 candidates" % k0rveen_keys.size())

	# §5.2: the hybrid court uses the pieces §5.2 names by hand.
	var court_keys: PackedStringArray = PackedStringArray()
	for entry: Dictionary in layout.placed:
		if String(entry["area"]) == "court" and not court_keys.has(String(entry["key"])):
			court_keys.append(String(entry["key"]))
	for required: String in [
		"floor_dirt", "path_A", "path_C", "arch", "fence_broken", "fence_pillar_broken",
		"tree_dead_large", "lantern_standing", "Rock_1_A_Color1", "Rock_1_Q_Color1",
		"Rock_3_A_Color1", "Tree_Bare_1_C_Color1", "Tree_Bare_2_C_Color1",
	]:
		_expect(court_keys.has(required),
			"the §5.2 hybrid court does not use %s" % required)
	print("  the hybrid court uses every piece §5.2 names, over %d instances" % int(areas.get("court", 0)))

	# §5.2 and the room blueprint's 65-80% clear-ground rule, measured.
	var clear: float = layout.court_clear_fraction()
	print("  court clear ground: %.1f%% of %.0f x %.0f m" % [
		clear * 100.0, layout.court_rect().size.x, layout.court_rect().size.y,
	])
	_expect(clear >= 0.65,
		"the court is only %.1f%% clear; the blueprint rule is at least 65%%" % (clear * 100.0))

	# §5.2 and §5.4: the real Knight, at the accepted scale, through the existing
	# rig scene rather than a second body.
	var rigs: Array[Node] = _nodes_of_script_class(player, "MediumRigVisual")
	_expect(rigs.size() == 1,
		"the player carries %d rig visuals; §5.4 reuses the one Knight rig" % rigs.size())
	_expect(is_equal_approx(player.collision_diameter(), ACCEPTED_P),
		"the player measures %.3f m across, not the accepted P of %.2f m" % [
			player.collision_diameter(), ACCEPTED_P,
		])
	print("  the accepted Knight rig is the player body, measured %.2f m across and %.2f m tall" % [
		player.collision_diameter(), player.collision_height(),
	])


## §5.2: "at least one already registered Dungeon wall or wall-pillar piece as
## the transition reference". The doorway between the two registered wall pillars
## is MEASURED off the proxies the layout built, not repeated from the constants
## that asked for it.
func _check_dungeon_transition() -> void:
	print("")
	print("--- The registered Dungeon transition reference (§5.2, §8.7)")
	var used: PackedStringArray = PackedStringArray()
	for entry: Dictionary in layout.placed:
		var record: Dictionary = entry["record"]
		if String(record["family"]) != ExteriorAssetCatalogue.FAMILY_DUNGEON:
			continue
		if not used.has(String(record["key"])):
			used.append(String(record["key"]))
	for required: String in ["dungeon_wall", "dungeon_wall_pillar", "dungeon_floor_tile_large"]:
		_expect(used.has(required), "the transition reference does not use %s" % required)
	var doorway: float = layout.dungeon_doorway_metres()
	print("  %d registered Dungeon pieces; doorway measures %.3f m (%.2f P)" % [
		used.size(), doorway, doorway / ACCEPTED_P,
	])
	_expect(absf(doorway - 4.0) < 0.01,
		"the dungeon doorway measures %.3f m" % doorway)

	# The Halloween arch's own opening, measured the same way off the leg proxies
	# the court built — and those proxies are sized from the arch mesh's measured
	# cross-section. It matters because 3.00 m is 3.75 P, NARROWER than the Gate 1A
	# 4 P stress gate the owner was shown as a deliberately uncomfortable lower
	# bound. That is a route-design fact, not a verdict on the piece.
	var opening: float = layout.arch_opening_metres()
	print("  the Halloween arch's clear opening measures %.3f m = %.2f P" % [
		opening, opening / ACCEPTED_P,
	])
	_expect(absf(opening - 3.0) < 0.01,
		"the arch opening measures %.3f m" % opening)
	_expect(opening < 4.0 * ACCEPTED_P,
		"the arch opening is no longer narrower than the Gate 1A 4 P stress gate")
	# And the registered pieces really are the Gate A ones, not a second copy.
	for record: Dictionary in ExteriorAssetCatalogue.dungeon_reference():
		_expect(String(record["path"]).begins_with("res://assets/third_party/kaykit/dungeon/"),
			"%s is not the registered Gate A dungeon piece" % record["key"])
		_expect(ResourceLoader.exists(String(record["path"])),
			"%s is missing" % record["path"])
	print("  they are the Gate A pieces at their registered paths; Gate 1B extracted none of them")


## §5.3: the k0rveen terrain and mountain "must not become navigable production
## terrain during this spike", and Gate 1A's open-topped-well finding says a large
## box proxy would otherwise bake a phantom walkable island inside itself.
func _check_navigation_and_terrain() -> void:
	print("")
	print("--- Navigation coverage, terrain exclusion, and phantom islands (§5.3, §8.7)")
	var walkable: Array[Dictionary] = [
		{"what": "player spawn", "at": layout.player_spawn()},
		{"what": "court centre", "at": Vector3(layout.COURT_CENTRE.x, 0.0, layout.COURT_CENTRE.y)},
		{"what": "under the arch", "at": Vector3(layout.ARCH_AT.x, 0.0, layout.ARCH_AT.y)},
		{"what": "dungeon doorway", "at": Vector3(0.0, 0.0, layout.DUNGEON_WALL_Z)},
		{"what": "behind the doorway", "at": Vector3(0.0, 0.0, layout.DUNGEON_WALL_Z + 7.0)},
		{"what": "Forest lineup", "at": Vector3(0.0, 0.0, layout.LINEUP_FOREST_Z + 2.5)},
		{"what": "Halloween lineup", "at": Vector3(0.0, 0.0, layout.LINEUP_HALLOWEEN_Z + 2.5)},
		{"what": "k0rveen approach", "at": Vector3(0.0, 0.0, layout.K0RVEEN_ROW_A_Z - 14.0)},
	]
	for probe: Dictionary in walkable:
		_expect(spike.point_is_navigable(probe["at"]),
			"%s at %s is not walkable" % [probe["what"], probe["at"]])
	print("  %d intended walkable positions across all three areas are on the navigation mesh" % walkable.size())

	# Every solid the layout built, except the authored ground, must be excluded —
	# and its CENTRE most of all, because that is exactly where an open-topped box
	# leaves a walkable island sealed inside solid geometry.
	var phantom: PackedStringArray = PackedStringArray()
	var tested: int = 0
	for solid: Dictionary in layout.solids():
		var solid_name: String = String(solid["name"])
		if solid_name == "Ground":
			continue
		var box: AABB = solid["aabb"]
		# Only boxes deeper than twice the agent radius can hold an island at all;
		# the narrower ones are excluded by the erosion and would prove nothing.
		if box.size.x <= 0.80 or box.size.z <= 0.80:
			continue
		tested += 1
		var centre: Vector3 = box.get_center()
		if spike.point_is_navigable(Vector3(centre.x, 0.0, centre.z), 0.30):
			phantom.append(solid_name)
	print("  %d solids wide enough to hold a phantom island; %d found" % [tested, phantom.size()])
	_expect(phantom.is_empty(),
		"a walkable island survives inside %s" % ", ".join(phantom))

	# §5.3 explicitly: the terrain slabs and the mountain are not walkable.
	for terrain: String in ["K0rveen_k0rveen_Terrain_1", "K0rveen_k0rveen_Terrain_2",
			"K0rveen_k0rveen_Mounting_1"]:
		var solid: Dictionary = layout.solid(terrain)
		_expect(not solid.is_empty(), "%s has no collision proxy" % terrain)
		if solid.is_empty():
			continue
		var box: AABB = solid["aabb"]
		_expect(not spike.point_is_navigable(
			Vector3(box.get_center().x, 0.0, box.get_center().z), 0.30),
			"%s became navigable terrain; §5.3 forbids it" % terrain)
	print("  the k0rveen terrain slabs and mountain are displayed objects, not navigable ground")

	# The boundary berm blocks rather than becoming a step.
	var berm: AABB = layout.solid("BermNorth")["aabb"]
	_expect(not spike.point_is_navigable(Vector3(berm.get_center().x, 0.0, berm.get_center().z), 0.45),
		"the boundary berm is walkable")
	print("  the 0.60 m boundary berm blocks; it is above the 0.20 m navigation climb limit")

	# MEASURED GUARD, against a defect that made the character unable to move at
	# all. Recast places the baked surface on a voxel boundary, so a navigation
	# cell height raised for bake speed lifts every path point above the ground —
	# and `NavigationAgent3D` measures its `path_desired_distance` in three
	# dimensions, so the agent can end up unable to reach its own first path point
	# and never advancing past it. The baked surface must therefore sit within the
	# agent's own path tolerance of the ground it represents.
	var agent: NavigationAgent3D = player.get_node("NavigationAgent3D")
	var worst: float = 0.0
	for probe: Dictionary in walkable:
		var at: Vector3 = probe["at"]
		var answer: Vector3 = NavigationServer3D.map_get_closest_point(
			spike.navigation_map(), Vector3(at.x, 0.0, at.z)
		)
		worst = maxf(worst, absf(answer.y))
	print("  baked surface sits at most %.3f m above the ground, against the agent's %.2f m path tolerance" % [
		worst, agent.path_desired_distance,
	])
	_expect(worst < agent.path_desired_distance,
		"the baked navigation surface is %.3f m above the ground, beyond the agent's %.2f m path tolerance" % [
			worst, agent.path_desired_distance,
		])


func _check_click_resolution() -> void:
	print("")
	print("--- Cursor to ground to navigation (§8.7)")
	await _teleport(Vector3(layout.COURT_CENTRE.x, 0.0, layout.COURT_CENTRE.y))
	var viewport: Vector2 = get_viewport().get_visible_rect().size
	var samples: Array[Dictionary] = [
		{"what": "screen centre", "at": viewport * 0.5, "walkable": true},
		{"what": "slightly left", "at": viewport * Vector2(0.36, 0.55), "walkable": true},
		{"what": "slightly right", "at": viewport * Vector2(0.64, 0.55), "walkable": true},
		{"what": "below the player", "at": viewport * Vector2(0.50, 0.72), "walkable": true},
	]
	for sample: Dictionary in samples:
		var cursor: Dictionary = spike.ground_point_under_cursor(sample["at"])
		_expect(bool(cursor.get("valid", false)),
			"no ground under the cursor at %s" % sample["what"])
		if not bool(cursor.get("valid", false)):
			continue
		var resolution: Dictionary = spike.resolve_to_navigation(cursor["point"])
		var point: Vector3 = resolution["point"]
		_expect(spike.point_is_navigable(point),
			"%s resolved to %s, which is not walkable" % [sample["what"], point])
	print("  %d representative screen positions resolve to walkable ground" % samples.size())

	# An unreachable request resolves to the nearest navigable point rather than
	# to itself, exactly as the accepted Prototype Zero rule requires.
	var far_away: Vector3 = Vector3(0.0, 0.0, layout.GROUND_CENTRE.y + 400.0)
	var corrected: Dictionary = spike.resolve_to_navigation(far_away)
	_expect(bool(corrected["adjusted"]),
		"an unreachable point was accepted unchanged")
	_expect(spike.point_is_navigable(corrected["point"]),
		"an unreachable point did not resolve onto the navigation mesh")
	print("  an unreachable request resolves %.1f m away, onto the mesh" % float(corrected["offset"]))


func _check_movement() -> void:
	print("")
	print("--- Movement across the comparison ground (§8.7)")
	await _teleport(layout.player_spawn())
	var goal: Vector3 = spike.resolve_to_navigation(
		Vector3(layout.COURT_CENTRE.x, 0.0, layout.COURT_CENTRE.y)
	)["point"]
	var started: Vector3 = player.global_position
	player.command_move_to(goal, goal, false)
	var frames: int = 0
	while frames < 900 and player.has_destination:
		await get_tree().physics_frame
		frames += 1
	var travelled: float = started.distance_to(player.global_position)
	var short: float = Vector2(
		player.global_position.x - goal.x, player.global_position.z - goal.z
	).length()
	print("  walked %.1f m from the spawn into the court in %.2f s, arriving %.2f m from the goal" % [
		travelled, float(frames) * TICK, short,
	])
	_expect(not player.has_destination,
		"the player never arrived; %.2f m short after %.2f s" % [short, float(frames) * TICK])
	_expect(short <= 0.75, "the player stopped %.2f m from the goal" % short)

	# Collision stops the body at its own radius from solid architecture. This is
	# driven by the STICK rather than by a click, deliberately: a navigation path
	# routes politely around a wall — the first version of this check watched the
	# character walk through the dungeon doorway and arrive tidily on the far
	# side, which proves the navigation mesh is right and proves nothing at all
	# about collision.
	await _teleport(Vector3(-8.0, 0.0, layout.DUNGEON_WALL_Z - 3.0))
	var wall: AABB = layout.solid("DungeonWall-8")["aabb"]
	spike.set_stick_override(_stick_toward(Vector3(0.0, 0.0, 1.0)))
	for i: int in 240:
		await get_tree().physics_frame
	var gap: float = wall.position.z - player.global_position.z
	print("  pushed into the wall for 4.0 s and stopped %.3f m from its face (capsule radius %.2f m)" % [
		gap, player.collision_diameter() * 0.5,
	])
	_expect(gap >= player.collision_diameter() * 0.5 - 0.06,
		"the player passed inside the wall: %.3f m gap" % gap)
	_expect(gap <= 1.0,
		"the player stopped %.3f m from the wall; the stick did not push it into the wall" % gap)
	spike.set_stick_override(null)
	player.clear_movement_intent("verification", false)
	await _release_all_inputs()
	await _settle(4)


## §5.4: the accepted locomotion contract, unchanged. Read off the player and the
## camera rig the spike actually built.
func _check_locomotion_contract() -> void:
	print("")
	print("--- The accepted locomotion and camera contract (§5.4, §8.5)")
	var contract: Array[Dictionary] = [
		{"what": "maximum speed", "got": player.max_speed, "want": ACCEPTED_MAX_SPEED},
		{"what": "acceleration", "got": player.acceleration, "want": ACCEPTED_ACCELERATION},
		{"what": "braking", "got": player.braking, "want": ACCEPTED_BRAKING},
		{"what": "arrival tolerance", "got": player.arrival_tolerance, "want": ACCEPTED_ARRIVAL_TOLERANCE},
		{"what": "stick deadzone", "got": player.stick_deadzone, "want": ACCEPTED_DEADZONE},
		{"what": "substantial turn", "got": player.substantial_turn_degrees, "want": ACCEPTED_SUBSTANTIAL_TURN},
		{"what": "turn rate", "got": player.turn_rate_degrees, "want": ACCEPTED_TURN_RATE},
		{"what": "camera distance", "got": spike.camera_rig.distance_metres, "want": ACCEPTED_CAMERA_DISTANCE},
		{"what": "camera pitch", "got": spike.camera_rig.pitch_degrees, "want": ACCEPTED_CAMERA_PITCH},
		{"what": "camera fov", "got": spike.camera_rig.fov_degrees, "want": ACCEPTED_CAMERA_FOV},
	]
	for entry: Dictionary in contract:
		_expect(is_equal_approx(float(entry["got"]), float(entry["want"])),
			"%s is %s, not the accepted %s" % [entry["what"], entry["got"], entry["want"]])
	print("  %d accepted locomotion and camera values hold on the objects this spike built" % contract.size())

	# The spike reuses the ONE shared kernel rather than carrying a second copy.
	for shared: String in [
		"res://scripts/movement/prototype_locomotion.gd",
		"res://scripts/movement/prototype_ground_pointer.gd",
		"res://scripts/movement/prototype_mouse_hold.gd",
	]:
		_expect(ResourceLoader.exists(shared), "%s is missing" % shared)
	var source: String = _code_only(FileAccess.get_file_as_string(SHIPPING_SCRIPTS[0]))
	for reused: String in [
		"PrototypeLocomotion", "PrototypeGroundPointer", "PrototypeMouseHold",
		"PrototypeCameraRig", "InputFamilyTracker",
	]:
		_expect(source.contains(reused) or _spike_uses(reused),
			"the spike does not reuse %s" % reused)
	# And it reuses the Gate 1A player scene rather than cloning a third body.
	_expect(spike.PLAYER_SCENE == "res://scenes/first_mvp/calibration/calibration_hall_player.tscn",
		"the spike does not reuse the accepted Gate 1A player scene")
	_expect(player is CalibrationHallPlayer,
		"the spike's player is not the accepted locomotion-only body")
	print("  it reuses the one shared locomotion kernel and the Gate 1A player body unchanged")

	# WASD is still absent, which is a project rule rather than a spike rule.
	for action: StringName in [&"move_vector_left", &"move_vector_right",
			&"move_vector_forward", &"move_vector_back"]:
		for event: InputEvent in InputMap.action_get_events(action):
			_expect(not (event is InputEventKey),
				"a keyboard event is bound to %s; there is no WASD movement" % action)
	print("  the movement vector still carries joypad axes only; there is no WASD")


func _check_controller_and_arbitration() -> void:
	print("")
	print("--- Controller movement, deadzone, and input arbitration (§5.4, §8.7)")
	await _teleport(Vector3(layout.COURT_CENTRE.x, 0.0, layout.COURT_CENTRE.y - 6.0))

	# Below the deadzone nothing moves.
	spike.set_stick_override(Vector2(0.0, -0.15))
	for i: int in 30:
		await get_tree().physics_frame
	_expect(player.planar_speed() < 0.05,
		"a stick inside the 0.20 deadzone moved the player at %.3f m/s" % player.planar_speed())

	# Above it, movement is camera-relative: pushing the stick away from the
	# player must move away from the camera, not toward world -Z.
	var before: Vector3 = player.global_position
	spike.set_stick_override(Vector2(0.0, -1.0))
	for i: int in 60:
		await get_tree().physics_frame
	var moved: Vector3 = player.global_position - before
	var forward: Vector3 = spike.camera_rig.ground_forward()
	var alignment: float = Vector3(moved.x, 0.0, moved.z).normalized().dot(forward)
	print("  full stick moved %.2f m, alignment with the camera's ground forward %.4f" % [
		moved.length(), alignment,
	])
	_expect(moved.length() > 0.5, "a full stick barely moved the player")
	_expect(alignment > 0.98, "controller movement is not camera-relative")

	# A fresh mouse command outranks a stick that is merely still held.
	var goal: Vector3 = spike.resolve_to_navigation(
		player.global_position + forward * -6.0
	)["point"]
	player.command_move_to(goal, goal, false)
	_expect(player.movement_mode == CalibrationHallPlayer.MovementMode.MOUSE_PATH,
		"a fresh mouse command did not supersede the held stick")
	_expect(player.stick_is_stale(),
		"the held stick was not marked stale after a mouse command")
	spike.set_stick_override(null)
	player.clear_movement_intent("verification", false)
	await _release_all_inputs()
	print("  the deadzone holds, movement is camera-relative, and a fresh click supersedes a held stick")

	# §6: interface clicks must not issue movement commands.
	var absorbed_before: int = spike.ui_clicks_absorbed
	var commands_before: int = spike.accepted_commands + spike.adjusted_commands
	var leak: Control = _find_control(spike.overlay, "InterfaceLeakTest")
	_expect(leak != null, "the interface leak test panel is missing")
	if leak != null:
		# `gui_get_hovered_control()` is updated by pointer MOTION, and `push_input`
		# transforms window coordinates unless told they are local. A check that
		# only warps the mouse and pushes a button misses the panel and leaks a
		# real command for its own reasons — Gate 1A measured exactly that.
		var centre: Vector2 = leak.get_global_rect().get_center()
		var motion: InputEventMouseMotion = InputEventMouseMotion.new()
		motion.position = centre
		motion.global_position = centre
		get_viewport().push_input(motion, true)
		await _await_process_frames(2)
		_expect(get_viewport().gui_get_hovered_control() != null,
			"the pointer is not over the interface panel; the leak test would prove nothing")
		var press: InputEventMouseButton = InputEventMouseButton.new()
		press.button_index = MOUSE_BUTTON_LEFT
		press.pressed = true
		press.position = centre
		press.global_position = centre
		get_viewport().push_input(press, true)
		await _await_process_frames(2)
		var release: InputEventMouseButton = InputEventMouseButton.new()
		release.button_index = MOUSE_BUTTON_LEFT
		release.pressed = false
		release.position = centre
		release.global_position = centre
		get_viewport().push_input(release, true)
		await _await_process_frames(2)
	var commands_after: int = spike.accepted_commands + spike.adjusted_commands
	print("  interface click: %d movement commands before, %d after, %d absorbed" % [
		commands_before, commands_after, spike.ui_clicks_absorbed - absorbed_before,
	])
	_expect(commands_after == commands_before,
		"a click on the interface issued a world movement command")


func _check_refused_combat_inputs() -> void:
	print("")
	print("--- No combat input can begin an action here (§2, §8.6)")
	var before: int = spike.refused_action_inputs
	# `Input.action_press()` sets an action's STATE without producing an
	# InputEvent, so a check that presses an action never reaches
	# `_unhandled_input` at all. Synthetic action events do.
	for action: StringName in [&"quick_strike", &"attack_in_place", &"interact"]:
		var event: InputEventAction = InputEventAction.new()
		event.action = action
		event.pressed = true
		event.strength = 1.0
		get_viewport().push_input(event, true)
		await _settle(2)
	var refused: int = spike.refused_action_inputs - before
	print("  %d of 3 combat inputs refused by name" % refused)
	_expect(refused == 3, "only %d of 3 combat inputs were refused" % refused)
	await _release_all_inputs()


# --- 5. Review modes (§6, §8.7) -----------------------------------------------

func _check_review_lighting() -> void:
	print("")
	print("--- F1 neutral review and the candidate exterior treatment (§6.1, §6.2)")
	spike.set_lighting_candidate(false)
	await _settle(2)
	var neutral: Environment = (spike.get_node("WorldEnvironment") as WorldEnvironment).environment
	print("  neutral: background %d, ambient energy %.2f, fog %s, glow %s, adjustments %s" % [
		int(neutral.background_mode), neutral.ambient_light_energy,
		str(neutral.fog_enabled), str(neutral.glow_enabled), str(neutral.adjustment_enabled),
	])
	# §6.1: neutral review "must not use fog, extreme grading, darkness, or bloom
	# to conceal differences".
	_expect(not neutral.fog_enabled, "neutral review uses fog")
	_expect(not neutral.glow_enabled, "neutral review uses bloom")
	_expect(not neutral.adjustment_enabled, "neutral review uses colour grading")
	_expect(neutral.ambient_light_energy >= 0.9,
		"neutral review is too dark to reveal a material mismatch")
	_expect(neutral.ambient_light_color.get_luminance() >= 0.8,
		"neutral review's ambient is not a near-white light")
	_expect(spike.lighting.lantern_count() > 0,
		"the candidate treatment declares no lantern light")
	for lantern: Node in spike.lighting.get_children():
		_expect(not (lantern as OmniLight3D).visible,
			"a warm lantern light is on during neutral review")

	spike.set_lighting_candidate(true)
	await _settle(2)
	var candidate: Environment = (spike.get_node("WorldEnvironment") as WorldEnvironment).environment
	print("  candidate: background %d, ambient energy %.2f, fog %s density %.4f" % [
		int(candidate.background_mode), candidate.ambient_light_energy,
		str(candidate.fog_enabled), candidate.fog_density,
	])
	_expect(candidate != neutral, "F1 did not change the environment")
	_expect(candidate.ambient_light_energy < neutral.ambient_light_energy,
		"the candidate treatment is not subdued relative to neutral review")
	# §6.2: "subtle distance fog only if every silhouette remains inspectable".
	# At this density the far end of the k0rveen row, 80 m away, keeps most of its
	# contrast; the number is stated so the owner can ask for another.
	_expect(candidate.fog_density <= 0.006,
		"the candidate fog at %.4f is not subtle" % candidate.fog_density)
	_expect(not candidate.glow_enabled and not candidate.adjustment_enabled,
		"the candidate treatment proposes post-processing; §6.2 does not")
	var lit: int = 0
	for lantern: Node in spike.lighting.get_children():
		if (lantern as OmniLight3D).visible:
			lit += 1
	print("  %d restrained warm lantern lights on in the candidate treatment" % lit)
	_expect(lit == spike.lighting.lantern_count(),
		"the candidate treatment did not light its lanterns")
	spike.set_lighting_candidate(false)
	await _settle(2)


## §6.3, and Prototype Zero's D-191 lesson: the treatment must never write to an
## imported material, and switching back must reproduce the imported presentation.
func _check_material_treatment() -> void:
	print("")
	print("--- F2 source and candidate materials, non-destructively (§6.3)")
	var treatment: ExteriorReviewTreatment = spike.treatment
	print("  %d registered surfaces across %d labelled objects" % [
		treatment.surface_count(), treatment.registered_labels().size(),
	])
	_expect(treatment.surface_count() > 60,
		"only %d surfaces were registered for treatment" % treatment.surface_count())
	_expect(not treatment.candidate_active(), "the spike did not launch in source mode")
	_expect(treatment.overridden_surfaces().is_empty(),
		"source mode still holds overrides on %s" % ", ".join(treatment.overridden_surfaces()))

	# Three full cycles, because D-191's defect only appeared on the SECOND pass:
	# a treatment that edited its source would compound, and one cycle would hide
	# it exactly as the default aim assistance hid the original.
	for cycle: int in 3:
		spike.set_candidate_materials(true)
		await _settle(2)
		_expect(treatment.overridden_surfaces().size() == treatment.surface_count(),
			"cycle %d: %d of %d surfaces took the candidate treatment" % [
				cycle, treatment.overridden_surfaces().size(), treatment.surface_count(),
			])
		_expect(treatment.drifted_sources().is_empty(),
			"cycle %d: the treatment wrote to an imported material: %s" % [
				cycle, ", ".join(treatment.drifted_sources()),
			])
		spike.set_candidate_materials(false)
		await _settle(2)
		_expect(treatment.overridden_surfaces().is_empty(),
			"cycle %d: source mode did not clear every override" % cycle)
		_expect(treatment.drifted_sources().is_empty(),
			"cycle %d: an imported material changed after returning to source" % cycle)
	print("  three candidate/source cycles: 0 imported materials changed, 0 overrides left behind")

	# The treatment is one rule with three stated numbers, not a hand-picked
	# palette. The same arithmetic is asserted on the GDScript path that the
	# shader applies to textured surfaces.
	var sample: Color = ExteriorReviewTreatment.treated_colour(Color(1.0, 0.0, 0.0))
	var luminance: float = 0.2126
	var expected_r: float = (
		lerpf(luminance, 1.0, ExteriorReviewTreatment.SATURATION)
		* ExteriorReviewTreatment.VALUE * ExteriorReviewTreatment.TINT.r
	)
	print("  treatment rule: saturation x %.2f, value x %.2f, tint (%.2f, %.2f, %.2f)" % [
		ExteriorReviewTreatment.SATURATION, ExteriorReviewTreatment.VALUE,
		ExteriorReviewTreatment.TINT.r, ExteriorReviewTreatment.TINT.g,
		ExteriorReviewTreatment.TINT.b,
	])
	_expect(is_equal_approx(sample.r, expected_r),
		"the untextured treatment does not apply the stated rule")
	_expect(ExteriorReviewTreatment.SATURATION < 1.0 and ExteriorReviewTreatment.VALUE < 1.0,
		"the candidate treatment neither desaturates nor darkens")
	# No treatment resource was written to disk: the shader is built from a string.
	_expect(not FileAccess.file_exists("res://assets/first_mvp/visual/exterior_candidate_treatment.gdshader"),
		"the treatment wrote a shader resource; it is meant to exist only at runtime")
	print("  the treatment is compiled at runtime and adds no resource file to the project")


func _check_k0rveen_toggle() -> void:
	print("")
	print("--- F4 k0rveen shown and hidden (§5.3, §6, §8.7)")
	_expect(layout.k0rveen_visible, "the spike did not launch with the k0rveen candidates shown")
	var polygons_shown: int = spike.navmesh_polygon_count
	var area_shown: float = spike.navmesh_area

	spike.set_k0rveen_visible(false)
	await _settle(6)
	var hidden: int = 0
	for entry: Dictionary in layout.placed:
		if String(entry["area"]) != "k0rveen":
			continue
		var node: Node3D = entry["node"]
		if not node.is_visible_in_tree():
			hidden += 1
	print("  hidden: %d of 5 k0rveen candidates; navigation %.0f -> %.0f m^2" % [
		hidden, area_shown, spike.navmesh_area,
	])
	_expect(hidden == 5, "only %d of 5 k0rveen candidates were hidden" % hidden)
	# Hiding must remove their obstruction too, and the mesh is rebaked to match:
	# an invisible wall would be a worse answer than either state.
	for terrain: String in ["K0rveen_k0rveen_Terrain_1", "K0rveen_k0rveen_Mounting_1"]:
		var box: AABB = layout.solid(terrain)["aabb"]
		_expect(spike.point_is_navigable(Vector3(box.get_center().x, 0.0, box.get_center().z), 0.60),
			"%s still obstructs the ground while hidden" % terrain)
	_expect(spike.navmesh_area > area_shown,
		"hiding the k0rveen candidates did not free the ground they stood on")

	# §7's seventh required view: the KayKit-only composition must stand on its
	# own. Every KayKit and Dungeon instance is still there and still visible.
	var kaykit_visible: int = 0
	for entry: Dictionary in layout.placed:
		if String(entry["area"]) == "k0rveen":
			continue
		if (entry["node"] as Node3D).is_visible_in_tree():
			kaykit_visible += 1
	print("  %d KayKit and registered Dungeon instances still stand with k0rveen hidden" % kaykit_visible)
	_expect(kaykit_visible == layout.placed.size() - 5,
		"hiding k0rveen also hid part of the KayKit composition")
	_expect(spike.point_is_navigable(
		Vector3(layout.COURT_CENTRE.x, 0.0, layout.COURT_CENTRE.y)),
		"the court stopped being walkable when k0rveen was hidden")

	spike.set_k0rveen_visible(true)
	await _settle(6)
	print("  restored: navigation %d polygons, %.0f m^2" % [
		spike.navmesh_polygon_count, spike.navmesh_area,
	])
	_expect(layout.k0rveen_visible, "F4 did not restore the k0rveen candidates")
	_expect(spike.navmesh_polygon_count == polygons_shown,
		"the rebake after restoring k0rveen did not reproduce the original mesh")


func _check_grid_and_overlay_toggles() -> void:
	print("")
	print("--- F6 the 1 m grid and F3 the overlay (§6)")
	_expect(not layout.grid_visible, "the grid is shown at launch")
	layout.set_grid_visible(true)
	await _settle(2)
	_expect(layout.grid_visible, "F6 did not show the 1 m grid")
	var grid: Node = layout.get_node_or_null("Visuals/ScaleGrid")
	_expect(grid != null and (grid as MeshInstance3D).visible, "the 1 m grid mesh is not visible")
	layout.set_grid_visible(false)
	await _settle(2)
	_expect(not layout.grid_visible, "F6 did not hide the grid again")

	spike.set_overlay_visible(false)
	await _settle(2)
	_expect(not (spike.overlay as CanvasItem).visible, "F3 did not hide the overlay")
	spike.set_overlay_visible(true)
	await _settle(2)
	_expect((spike.overlay as CanvasItem).visible, "F3 did not restore the overlay")
	print("  both toggles change what they claim to, in both directions")


func _check_reset() -> void:
	print("")
	print("--- Backslash resets every review mode and the player position (§6)")
	spike.set_lighting_candidate(true)
	spike.set_candidate_materials(true)
	spike.set_k0rveen_visible(false)
	layout.set_grid_visible(true)
	spike.camera_rig.adjust_distance(8.0)
	await _teleport(Vector3(20.0, 0.0, 30.0))
	_expect(not spike.review_is_launch_state(),
		"the review modes were not actually changed before the reset was tested")

	spike.reset_review()
	await _settle(6)
	print("  after reset: lighting %s, materials %s, k0rveen %s, grid %s, camera %.1f m, player %s" % [
		spike.lighting.mode_name(),
		"source" if not spike.treatment.candidate_active() else "candidate",
		str(layout.k0rveen_visible), str(layout.grid_visible),
		spike.camera_rig.distance_metres, str(player.global_position.round()),
	])
	_expect(spike.review_is_launch_state(), "the reset did not return to the launch state")
	_expect(player.global_position.distance_to(layout.player_spawn()) < 0.05,
		"the reset did not return the player to the spawn")
	_expect(spike.treatment.drifted_sources().is_empty(),
		"an imported material changed across the reset")


# --- 6. Scope and storage (§8.6, §8.8) ----------------------------------------

func _check_scope() -> void:
	print("")
	print("--- No combat, route, story, progression, or save system entered the spike (§8.6)")
	for forbidden: String in [
		"attack", "quick_strike", "acquisition", "soft_target", "target_acquisition",
		"life", "mana", "damage", "graveblade", "enemy", "coordinator",
		"loot", "drop", "experience", "passive", "inventory", "equipment", "rarity",
		"affix", "craft", "forge", "hud", "settings", "saved_state", "lab_progress",
		"director", "story", "mara", "nexus", "riftmarked", "threshold_room",
		"procedural", "generator", "run_graph", "module_library", "pursuit", "intensity",
		"riftfall", "landing", "broken_watch", "route",
	]:
		_expect(not (forbidden in spike),
			"the spike has a '%s' member; that is not authorized by D-198" % forbidden)
	for forbidden: String in [
		"attack", "life", "mana", "weapon", "receive_damage", "physical_damage",
		"experience", "target", "inventory", "equip_weapon", "action_state",
	]:
		_expect(not (forbidden in player),
			"the spike player has a '%s' member; it carries locomotion only" % forbidden)
	print("  the spike and its player carry review modes, geometry, and locomotion and nothing else")

	for type_name: String in [
		"PrototypeGraveblade", "QuickStrikeAction", "AttackCoordinator", "PrototypeTargetable",
		"PrototypeHUD", "PrototypeProgressionDirector", "PrototypeSettings", "PrototypeLabState",
		"PrototypeAudioDirector", "PrototypePlayer", "PrototypeZeroRoom",
		"ScaleCalibrationHall", "CalibrationFixtures",
	]:
		_expect(_count_script_class(spike, type_name) == 0,
			"a %s exists inside the exterior spike" % type_name)
	_expect(_count_nodes_of_type(spike, "AudioStreamPlayer") == 0
			and _count_nodes_of_type(spike, "AudioStreamPlayer3D") == 0,
		"the exterior spike plays audio; D-198 authorizes none")
	print("  no combat, progression, HUD, settings, save, calibration-hall, or audio object is instantiated")

	# The canonical route this spike must NOT start.
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
		and _count_script_class(spike, "RiftfallLanding") == 0
		and _count_script_class(spike, "RiftfallLandingLayout") == 0
		and _count_script_class(spike, "RiftfallLoopEvent") == 0
		and not _code_only(FileAccess.get_file_as_string(
			"res://scripts/first_mvp/visual/exterior_asset_compatibility_spike.gd"
		)).contains("severed_threshold"),
		("Gate 1C's canonical scene is missing from its authorized path, or this closed "
		+ "Gate 1B instrument contains or names part of it"))
	_expect(not FileAccess.file_exists("res://../docs/testing/FIRST_MVP_VERTICAL_SLICE_REPORT.md"),
		"a first-MVP vertical-slice report exists; that work is not authorized")
	print("  Riftfall Landing exists as the isolated D-208 Gate 1C scene and is no part of\n  this instrument; Broken Watch, the Nexus Threshold, the Rift Nexus and the wider\n  Severed Threshold route remain unstarted")


func _check_no_state_written() -> void:
	print("")
	print("--- §8: the spike has no storage path at all")
	for path: String in SHIPPING_SCRIPTS:
		var source: String = _code_only(FileAccess.get_file_as_string(path))
		for forbidden: String in [
			"user://", "ConfigFile", "FileAccess.open", "ResourceSaver", "store_string",
			"store_line", "save_to_file", "get_file_as_string", "get_file_as_bytes",
		]:
			_expect(not source.contains(forbidden),
				"%s reaches '%s'; the spike reads and writes nothing" % [path.get_file(), forbidden])
	for forbidden: String in ["storage_path", "save", "load_state", "schema_version"]:
		_expect(not (forbidden in spike), "the spike has a '%s' member" % forbidden)
	print("  no user:// path, ConfigFile, FileAccess call, or ResourceSaver exists in Gate 1B shipping code")


# --- 7. Visible surfaces (§8.7) -----------------------------------------------

func _check_surfaces_are_on_screen() -> void:
	print("")
	print("--- The review surfaces really are on screen (§8.7)")
	var view: Rect2 = get_viewport().get_visible_rect()
	var root: Control = spike.overlay as Control
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

	var text: String = _visible_text_in(root).to_lower()
	for required: String in [
		"exterior asset compatibility spike", "temporary developer review scene",
		"not riftfall landing", "candidate", "k0rveen", "no texture",
		"kaykit candidates", "review modes", "review controls", "interface leak test",
		"your call",
	]:
		_expect(text.contains(required), "the overlay never says '%s'" % required)
	print("  the overlay states what this scene is, names both families, and leaves the call to the owner")


# --- 8. Rendered evidence (§7) ------------------------------------------------

func _capture_evidence() -> void:
	print("")
	print("--- Rendered evidence (§7)")
	var brief: bool = arguments.has("--shots-brief")
	var window: Vector2i = DisplayServer.window_get_size()
	if window.x <= 0 or window.y <= 0:
		window = Vector2i(get_viewport().get_visible_rect().size)
	var suffix: String = "_%dx%d" % [window.x, window.y]
	spike.reset_review()
	await _settle(4)

	# §7's seven required views, in its own order, plus the frames that make each
	# one auditable. `clean` additionally captures the frame with the overlay
	# hidden — the same F3 the owner has — because the panels necessarily cover
	# part of the space they describe.
	var stations: Array[Dictionary] = [
		{
			"name": "1_neutral_source_lineup", "at": Vector3(0.0, 0.0, -40.5),
			"distance": 40.0, "grid": false, "candidate": false, "clean": true,
			"k0rveen": true, "brief": true,
		},
		{
			"name": "2_candidate_treatment_lineup", "at": Vector3(0.0, 0.0, -40.5),
			"distance": 40.0, "grid": false, "candidate": true, "clean": true,
			"k0rveen": true, "brief": false,
		},
		{
			"name": "3_knight_beside_candidates_grid", "at": Vector3(-6.0, 0.0, -40.5),
			"distance": 19.0, "grid": true, "candidate": false, "clean": true,
			"k0rveen": true, "brief": true,
		},
		{
			"name": "4_hybrid_court_dungeon_transition", "at": Vector3(0.0, 0.0, 2.0),
			"distance": 26.0, "grid": false, "candidate": false, "clean": true,
			"k0rveen": true, "brief": true,
		},
		{
			"name": "4b_hybrid_court_candidate", "at": Vector3(-2.0, 0.0, -6.0),
			"distance": 26.0, "grid": false, "candidate": true, "clean": true,
			"k0rveen": true, "brief": false,
		},
		{
			"name": "5_k0rveen_imported", "at": Vector3(-1.0, 0.0, 46.0),
			"distance": 40.0, "grid": false, "candidate": false, "clean": true,
			"k0rveen": true, "brief": true,
		},
		{
			"name": "6_k0rveen_candidate_treatment", "at": Vector3(-1.0, 0.0, 46.0),
			"distance": 40.0, "grid": false, "candidate": true, "clean": true,
			"k0rveen": true, "brief": false,
		},
		{
			"name": "7_kaykit_only_k0rveen_hidden", "at": Vector3(-2.0, 0.0, -6.0),
			"distance": 30.0, "grid": false, "candidate": true, "clean": true,
			"k0rveen": false, "brief": true,
		},
		{
			"name": "8_court_from_the_spawn", "at": Vector3(0.0, 0.0, -28.0),
			"distance": 19.0, "grid": false, "candidate": false, "clean": false,
			"k0rveen": true, "brief": false,
		},
		{
			"name": "9_arch_and_lanterns", "at": Vector3(0.0, 0.0, -4.0),
			"distance": 14.0, "grid": true, "candidate": true, "clean": true,
			"k0rveen": true, "brief": false,
		},
	]

	for station: Dictionary in stations:
		if brief and not bool(station["brief"]):
			continue
		spike.set_lighting_candidate(bool(station["candidate"]))
		spike.set_candidate_materials(bool(station["candidate"]))
		if layout.k0rveen_visible != bool(station["k0rveen"]):
			spike.set_k0rveen_visible(bool(station["k0rveen"]))
			await _settle(4)
		layout.set_grid_visible(bool(station["grid"]))
		spike.camera_rig.adjust_distance(
			float(station["distance"]) - spike.camera_rig.distance_metres
		)
		await _teleport(station["at"])
		await _shoot("gate_1b_%s%s" % [station["name"], suffix], 8)
		if bool(station["clean"]):
			spike.set_overlay_visible(false)
			await _shoot("gate_1b_%s_clean%s" % [station["name"], suffix], 5)
			spike.set_overlay_visible(true)
		await _settle(3)

	# A click-to-move destination on open ground, so the marker is in frame.
	spike.reset_review()
	await _teleport(Vector3(-6.0, 0.0, -16.0))
	var goal: Vector3 = spike.resolve_to_navigation(Vector3(2.0, 0.0, -2.0))["point"]
	player.command_move_to(goal, goal, false)
	await _settle(20)
	await _shoot("gate_1b_10_click_to_move" + suffix, 4)
	player.clear_movement_intent("evidence cleanup", false)
	await _settle(4)
	spike.reset_review()
	await _settle(4)


func _shoot(name_stem: String, settle_frames: int) -> void:
	for i: int in settle_frames:
		await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var path: String = "%s/%s.png" % [_shot_dir, name_stem]
	get_viewport().get_texture().get_image().save_png(path)
	print("  screenshot: %s" % path)


# --- Helpers ------------------------------------------------------------------

## The raw left-stick reading that produces a given WORLD direction at the
## current camera yaw. Derived from the camera's own ground basis rather than
## hard-coded, so it stays correct if the framing ever changes.
func _stick_toward(world_direction: Vector3) -> Vector2:
	var wanted: Vector3 = Vector3(world_direction.x, 0.0, world_direction.z).normalized()
	var forward: Vector3 = spike.camera_rig.ground_forward()
	var right: Vector3 = spike.camera_rig.ground_right()
	return Vector2(wanted.dot(right), -wanted.dot(forward))


func _teleport(to: Vector3) -> void:
	spike.set_stick_override(Vector2.ZERO)
	player.clear_movement_intent("verification teleport", false)
	player.global_position = Vector3(to.x, 0.0, to.z)
	player.velocity = Vector3.ZERO
	spike.set_stick_override(null)
	await _settle(6)


## Putting the physical controls at rest is not the same as being allowed to act
## again: the room lifts its neutral latch on its own, and this waits for it.
func _release_all_inputs() -> void:
	spike.set_stick_override(Vector2.ZERO)
	Input.action_release(&"move_point")
	for frame: int in 30:
		await get_tree().physics_frame
		if not player.awaiting_neutral:
			break
	spike.set_stick_override(null)


func _settle(frames: int) -> void:
	for i: int in frames:
		await get_tree().physics_frame


## Anything built or updated in `_process` — overlay text, hovered control —
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


func _spike_uses(type_name: String) -> bool:
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


func _files_in(directory: String) -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	var handle: DirAccess = DirAccess.open(directory)
	if handle == null:
		return found
	for file: String in handle.get_files():
		found.append("%s/%s" % [directory, file])
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


func _nodes_of_script_class(node: Node, class_name_wanted: String) -> Array[Node]:
	var found: Array[Node] = []
	for child: Node in node.get_children():
		var script: Script = child.get_script() as Script
		if script != null and script.get_global_name() == StringName(class_name_wanted):
			found.append(child)
		found.append_array(_nodes_of_script_class(child, class_name_wanted))
	return found


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


## The D-215 availability record's approved payloads, read by path exactly as the
## Zone Composer palette reads it. Returns an empty list if the record is absent,
## so this gate degrades into its pre-D-215 behaviour rather than throwing — and a
## missing record would then show up as 24 unauthorized files rather than as a
## silent pass.
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
