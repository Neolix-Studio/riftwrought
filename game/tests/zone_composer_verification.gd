extends SceneTree
## Riftwrought Zone Composer — Phase 1 verification (D-210).
##
## VERIFIES ONLY WHAT PHASE 1 CAN GENUINELY BREAK, and deliberately nothing else.
## It adds no gate, reruns no gate, regenerates no evidence, and asserts nothing
## about combat, movement, cameras, navigation, Riftfall Landing's geometry or any
## accepted value. Those are all proved by the existing locked chain, which
## `zone_composer_smoke.sh` runs once on the final tree.
##
## What it does prove, in order:
##
##   1. the palette and the project's ACCEPTED asset record agree exactly, in both
##      directions, and every approved file is present and measurable;
##   2. the ground arithmetic answers correctly, including saying "no ground"
##      rather than inventing a point;
##   3. one piece from every available category places into the right container,
##      at the right height, at the accepted scale, with an understandable name;
##   4. Godot's real undo restores the exact scene state and redo restores it
##      exactly again — measured node by node and transform by transform;
##   5. a composed zone survives being saved and reopened;
##   6. a composed zone contains no reference to this addon, so the running game
##      needs no editor code;
##   7. "Play From Here" moves a developer marker and NEVER the zone's real
##      Player Start;
##   8. the translucent preview node cannot be saved into a zone;
##   9. every third-party source asset is byte-identical before and after all of
##      the above;
##  10. (D-211) every story marker has its own visible editor symbol, distinct by
##      shape as well as by colour, carrying a facing arrow that answers the
##      placed rotation at 0°, 45°, 90° and 180°; the translucent preview is built
##      from the SAME line segments the placed marker is drawn from; and the whole
##      visualization is editor-only — a saved zone gains no mesh, no script, no
##      metadata and no addon reference, and the owner's own composed practice
##      scene is byte-identical before and after the run.
##
## It runs headlessly with no editor:
##   godot --headless --path game --script res://tests/zone_composer_verification.gd

const Catalogue := preload("res://addons/riftwrought_zone_composer/zone_composer_catalogue.gd")
const Placement := preload("res://addons/riftwrought_zone_composer/zone_composer_placement.gd")
const Actions := preload("res://addons/riftwrought_zone_composer/zone_composer_actions.gd")
const Shapes := preload("res://addons/riftwrought_zone_composer/zone_composer_marker_shapes.gd")

const SAVED_ZONE_PATH: String = "user://zone_composer_verification_zone.tscn"
const SAVED_MARKER_ZONE_PATH: String = "user://zone_composer_verification_markers.tscn"

## The project owner's own composed zone. READ ONLY, and fingerprinted around the
## whole run: a correction to an authoring tool that edited the work already made
## with it would be a defect of the first order.
const PRACTICE_ZONE_PATH: String = "res://scenes/first_mvp/zone_composer_practice.tscn"

## The addon directory, enumerated rather than listed, so a file added to the tool
## cannot escape the scans below. (D-205's lesson: a guard that cannot see a file
## does not guard it.)
const ADDON_DIRECTORY: String = "res://addons/riftwrought_zone_composer"
const PREVIEW_NODE_NAME: String = "ZoneComposerPreview"

## Every third-party directory the retained families live in. Hashed before and
## after the run: an authoring tool that modified a source asset would be a defect
## of the first order.
const SOURCE_DIRECTORIES: Array[String] = [
	"res://assets/third_party/kaykit/dungeon",
	"res://assets/third_party/kaykit/forest",
	"res://assets/third_party/kaykit/halloween",
	"res://assets/third_party/kenney/graveyard",
]

var _checks: int = 0
var _failures: int = 0
var _catalogue: RefCounted


func _init() -> void:
	print("")
	print("=== RIFTWROUGHT ZONE COMPOSER — PHASE 1 VERIFICATION ===")
	print("")

	var before: Dictionary = _hash_sources()
	var practice_before: String = _fingerprint(PRACTICE_ZONE_PATH)

	_check_addon_files()
	_check_catalogue()
	_check_measurement()
	_check_ground_arithmetic()
	_check_snapping_and_turning()
	_check_naming()
	_check_placement_and_undo()
	_check_save_and_reopen()
	_check_play_from_here()
	_check_preview_is_never_saved()
	_check_marker_symbols()
	_check_marker_facing()
	_check_marker_visualization_is_editor_only()

	var after: Dictionary = _hash_sources()
	_step("15. The project owner's own composed zone was not touched")
	_expect(
		not practice_before.is_empty(),
		"the owner's practice zone exists and was fingerprinted (%s)" % practice_before.substr(0, 16)
	)
	_expect(
		practice_before == _fingerprint(PRACTICE_ZONE_PATH),
		"and it is byte-identical after the whole run"
	)
	_expect(before.size() > 0, "there are source assets to protect (%d files)" % before.size())
	_expect(
		before == after,
		"every third-party source asset is byte-identical after the whole run (%d files)"
			% after.size()
	)

	print("")
	if _failures == 0:
		print("ZONE COMPOSER VERIFICATION: PASS (%d checks)" % _checks)
	else:
		print("ZONE COMPOSER VERIFICATION: FAIL (%d of %d checks failed)" % [_failures, _checks])
	print("")
	quit(0 if _failures == 0 else 1)


# --- 1. The addon exists and is wired to itself -------------------------------

func _check_addon_files() -> void:
	_step("1. The addon is present and self-consistent")
	var expected: Array[String] = [
		"res://addons/riftwrought_zone_composer/plugin.cfg",
		"res://addons/riftwrought_zone_composer/plugin.gd",
		"res://addons/riftwrought_zone_composer/zone_composer_catalogue.gd",
		"res://addons/riftwrought_zone_composer/zone_composer_placement.gd",
		"res://addons/riftwrought_zone_composer/zone_composer_actions.gd",
		"res://addons/riftwrought_zone_composer/zone_composer_dock.gd",
		"res://addons/riftwrought_zone_composer/zone_composer_thumbnails.gd",
		"res://addons/riftwrought_zone_composer/zone_composer_marker_shapes.gd",
		"res://addons/riftwrought_zone_composer/zone_composer_marker_gizmos.gd",
	]
	for path: String in expected:
		_expect(FileAccess.file_exists(path), "%s exists" % path.get_file())

	# AND THE OTHER DIRECTION, which is the half that earns its keep: the scans
	# below walk the directory rather than this list, so a file added to the tool
	# and forgotten here would still be scanned — and this assertion says so out
	# loud rather than letting the list quietly go stale.
	var on_disk: PackedStringArray = _addon_scripts()
	var unlisted: PackedStringArray = PackedStringArray()
	for path: String in on_disk:
		if not expected.has(path):
			unlisted.append(path.get_file())
	_expect(
		unlisted.is_empty(),
		"the addon holds no script this check does not know about (%s)" % ", ".join(unlisted)
	)

	var config: ConfigFile = ConfigFile.new()
	_expect(
		config.load("res://addons/riftwrought_zone_composer/plugin.cfg") == OK,
		"plugin.cfg parses"
	)
	_expect(
		String(config.get_value("plugin", "script", "")) == "plugin.gd",
		"plugin.cfg points at plugin.gd"
	)
	_expect(
		String(config.get_value("plugin", "name", "")) == "Riftwrought Zone Composer",
		"the dock is named \"Riftwrought Zone Composer\""
	)

	# The addon must not reach into anything it has no business in. It reads the
	# accepted asset record and nothing else under scripts/.
	# EVERY `res://` PATH, NOT THREE HARD-CODED TREES. The narrower scan printed
	# "exactly one project file" while `plugin.gd` also names the editor check
	# under `tests/`, which it dispatches only on `--verify-zone-composer`. A guard
	# that can only see the directories someone thought of is not a guard.
	var referenced: PackedStringArray = PackedStringArray()
	for path: String in on_disk:
		var text: String = FileAccess.get_file_as_string(path)
		for line: String in text.split("\n"):
			var trimmed: String = line.strip_edges()
			if trimmed.begins_with("#"):
				continue
			var at: int = trimmed.find("res://")
			while at >= 0:
				var rest: String = trimmed.substr(at)
				var end: int = rest.find("\"")
				if end > 0:
					var found: String = rest.substr(0, end)
					if not found.begins_with(ADDON_DIRECTORY) and not referenced.has(found):
						referenced.append(found)
				at = trimmed.find("res://", at + 1)
	var sorted_paths: Array = Array(referenced)
	sorted_paths.sort()
	# THE EXPECTED LIST IS BUILT FROM THE ADDON'S OWN CONSTANT, NOT RETYPED, so a
	# record added to `ACCEPTED_RECORD_PATHS` without being registered here cannot
	# pass by coincidence — and one added HERE without being read still fails,
	# because `referenced` is scanned out of the source.
	var expected_paths: Array = Array(Catalogue.ACCEPTED_RECORD_PATHS.duplicate())
	expected_paths.append("res://tests/zone_composer_editor_check.gd")
	expected_paths.sort()
	_expect(
		sorted_paths == expected_paths,
		"the addon names exactly three project files by path — the two accepted asset records it "
			+ "reads, and the in-editor check it dispatches only under --verify-zone-composer (%s)"
			% ", ".join(PackedStringArray(sorted_paths))
	)

	# AND BY CLASS NAME, WHICH THE PATH SCAN CANNOT SEE, AND WHICH IT WAS QUIETLY
	# WRONG ABOUT. The palette measures every piece through `ExteriorAssetProbe`, a
	# global class declared under `scripts/`, so "exactly one project file" was
	# never true of the substance — only of the string literals. Both dependencies
	# are now stated, and a third one appearing fails here.
	var project_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var class_path: String = String(entry.get("path", ""))
		if class_path.begins_with("res://addons/"):
			continue
		project_classes.append(String(entry.get("class", "")))
	var used: PackedStringArray = PackedStringArray()
	for path: String in on_disk:
		var code: String = _code_of(FileAccess.get_file_as_string(path))
		for name: String in project_classes:
			if not name.is_empty() and code.contains(name) and not used.has(name):
				used.append(name)
	var sorted_used: Array = Array(used)
	sorted_used.sort()
	_expect(
		sorted_used == ["ExteriorAssetProbe"],
		"and depends on exactly one project CLASS — ExteriorAssetProbe, which measures the pieces (%s)"
			% ", ".join(PackedStringArray(sorted_used))
	)


# --- 2. The palette and the accepted record agree -----------------------------

func _check_catalogue() -> void:
	_step("2. The palette is exactly the project's accepted asset record")
	_catalogue = Catalogue.new()
	_catalogue.load_catalogue()

	var problems: PackedStringArray = _catalogue.problems()
	for problem: String in problems:
		print("      reported problem: %s" % problem)
	_expect(problems.is_empty(), "the catalogue reports no problems")

	# THE UNION OF BOTH ACCEPTED RECORDS, read the way the palette reads them.
	var riftfall: Array = (load(Catalogue.ACCEPTED_RECORD_PATH) as GDScript)\
		.get_script_constant_map()["PAYLOADS"]
	var expansion: Array = (load(Catalogue.EXPANSION_RECORD_PATH) as GDScript)\
		.get_script_constant_map()["PAYLOADS"]
	var approved: Array = []
	approved.append_array(riftfall)
	approved.append_array(expansion)
	_expect(riftfall.size() == 19,
		"the Gate 1C record still approves its 19 payloads (%d)" % riftfall.size())
	_expect(expansion.size() == 47,
		"the D-215 expansion record approves 47 payloads (%d)" % expansion.size())

	var asset_pieces: Array[Dictionary] = []
	var marker_pieces: Array[Dictionary] = []
	for piece: Dictionary in _catalogue.all_pieces():
		if String(piece["kind"]) == "asset":
			asset_pieces.append(piece)
		else:
			marker_pieces.append(piece)
	_expect(
		asset_pieces.size() == approved.size(),
		"the palette offers every approved payload and no other (%d)" % asset_pieces.size()
	)
	_expect(marker_pieces.size() == 3, "the palette offers 3 named marker points")

	# Both directions, key by key.
	var approved_keys: PackedStringArray = PackedStringArray()
	for entry: Variant in approved:
		approved_keys.append(Catalogue.piece_id_for_path(String((entry as Dictionary)["path"])))
	var palette_keys: PackedStringArray = PackedStringArray()
	for piece: Dictionary in asset_pieces:
		palette_keys.append(String(piece["key"]))
	var missing: PackedStringArray = PackedStringArray()
	for key: String in approved_keys:
		if not palette_keys.has(key):
			missing.append(key)
	var extra: PackedStringArray = PackedStringArray()
	for key: String in palette_keys:
		if not approved_keys.has(key):
			extra.append(key)
	_expect(missing.is_empty(), "no approved payload is missing from the palette")
	_expect(extra.is_empty(), "the palette invents no payload the record does not approve")

	# The paths, families, roles and contact rules are the record's own, unaltered.
	var mismatches: int = 0
	var joined: int = 0
	for piece: Dictionary in asset_pieces:
		for entry: Variant in approved:
			var payload: Dictionary = entry as Dictionary
			if Catalogue.piece_id_for_path(String(payload["path"])) != String(piece["key"]):
				continue
			joined += 1
			if String(payload["path"]) != String(piece["path"]):
				mismatches += 1
			if String(payload["family"]) != String(piece["family"]):
				mismatches += 1
			if String(payload["role"]) != String(piece["role"]):
				mismatches += 1
			if String(payload["contact"]) != String(piece["contact"]):
				mismatches += 1
	_expect(mismatches == 0, "every path, family, role and contact rule is the record's own")
	# A POSITIVE CONTROL ON THE LOOP ABOVE. Without it, a join that matched nothing
	# would report zero mismatches for ever and the assertion could never fail
	# again — the exact shape of check this project has been bitten by before.
	_expect(joined == asset_pieces.size(),
		"and every one of the %d offered pieces really was joined to a record entry (%d)"
			% [asset_pieces.size(), joined])

	# Only the four retained families, named from the record rather than typed.
	var families: PackedStringArray = PackedStringArray()
	for piece: Dictionary in asset_pieces:
		if not families.has(String(piece["family"])):
			families.append(String(piece["family"]))
	_expect(families.size() == 4, "exactly four families are offered (%d)" % families.size())
	var rejected_markers: Array[String] = [
		"k0rveen", "kenney/nature", "fantasy_town", "modular_ruins",
		"assetquest", "medieval_village", "modular_cave",
	]
	var rejected_hits: int = 0
	for piece: Dictionary in asset_pieces:
		for marker: String in rejected_markers:
			if String(piece["path"]).contains(marker):
				rejected_hits += 1
	_expect(rejected_hits == 0, "no rejected or unclassified family is offered")

	# Every drawer the brief names holds exactly the reviewed number of pieces.
	# Strictly stronger than the non-empty test this replaces one for one, because
	# `== 11` entails `> 0` while `> 0` would have accepted a drawer that had
	# quietly lost forty pieces.
	var reviewed_sizes: Dictionary = {
		Catalogue.CATEGORY_GROUND: 11,
		Catalogue.CATEGORY_ROADS: 9,
		Catalogue.CATEGORY_ARCHITECTURE: 16,
		Catalogue.CATEGORY_BOUNDARIES: 13,
		Catalogue.CATEGORY_PROPS: 16,
		Catalogue.CATEGORY_MARKERS: 4,
	}
	for category: String in Catalogue.CATEGORIES:
		var in_category: Array[Dictionary] = _catalogue.pieces_in_category(category)
		_expect(in_category.size() == int(reviewed_sizes[category]),
			"the \"%s\" category offers %d pieces, the reviewed number"
				% [category, in_category.size()])

	# The credits the record carries are shown.
	_expect(_catalogue.credits().size() == 2, "both CC0 credit lines are carried")

	# --- The pack-qualified id scheme (D-215) ---------------------------------
	#
	# A KayKit filename is NOT unique across packs. These prove the id both
	# identifies and disambiguates, and — the part that matters — that the
	# duplicate refusal is REACHABLE rather than merely unreached.
	var ids: PackedStringArray = PackedStringArray()
	var derived: int = 0
	var colonless: PackedStringArray = PackedStringArray()
	for piece: Dictionary in asset_pieces:
		var id: String = String(piece["key"])
		if not ids.has(id):
			ids.append(id)
		if id == Catalogue.piece_id_for_path(String(piece["path"])):
			derived += 1
		if id.get_slice_count(":") != 2 or id.get_slice(":", 0).is_empty():
			colonless.append(id)
	_expect(ids.size() == asset_pieces.size(),
		"all %d offered models answer to a DISTINCT id (%d distinct)"
			% [asset_pieces.size(), ids.size()])
	_expect(derived == asset_pieces.size(),
		"and every id is DERIVED from the record's own path, never typed (%d of %d)"
			% [derived, asset_pieces.size()])
	_expect(colonless.is_empty(),
		"every model id is exactly <pack>:<model> (%s)" % ", ".join(colonless))
	var marker_with_colon: PackedStringArray = PackedStringArray()
	for piece: Dictionary in marker_pieces:
		if String(piece["key"]).contains(":"):
			marker_with_colon.append(String(piece["key"]))
	_expect(marker_with_colon.is_empty(),
		"and no marker id carries one, so the two namespaces cannot overlap")
	# THE COLLISION THE SCHEME EXISTS TO STOP, PROVED ON REAL DATA. Both packs ship
	# a model called `pillar` and they genuinely differ; the palette offers the
	# Dungeon one, and the two paths derive to different ids.
	_expect(
		Catalogue.piece_id_for_path("res://assets/third_party/kaykit/dungeon/pillar.gltf")
			!= Catalogue.piece_id_for_path("res://assets/third_party/kaykit/halloween/pillar.gltf"),
		"two packs' identically-named `pillar` models derive to different ids"
	)
	# AND THE ONE CASE THE SCHEME CANNOT SEPARATE, stated rather than assumed away:
	# two vendors shipping a folder of the same name. Nothing in the project does,
	# so this is fabricated on purpose — it proves the refusal branch in
	# `load_catalogue` is reachable rather than dead code.
	_expect(
		Catalogue.piece_id_for_path("res://assets/third_party/kaykit/forest/X.gltf")
			== Catalogue.piece_id_for_path("res://assets/third_party/assetquest/forest/X.gltf"),
		"two vendors sharing a pack folder name WOULD collide, which is why a duplicate is refused"
	)

	# --- The reviewed authoring metadata (D-215) ------------------------------
	var reviewed: Array[Dictionary] = []
	var inherited: Array[Dictionary] = []
	for piece: Dictionary in asset_pieces:
		if float(piece["reviewed_snap"]) >= 0.0:
			reviewed.append(piece)
		else:
			inherited.append(piece)
	_expect(reviewed.size() == 47,
		"all 47 expansion pieces declare a reviewed snap (%d)" % reviewed.size())
	_expect(inherited.size() == 19,
		"and the 19 Gate 1C pieces declare none, so their accepted derived snap is untouched (%d)"
			% inherited.size())
	var incomplete: PackedStringArray = PackedStringArray()
	var bad_contact: PackedStringArray = PackedStringArray()
	for piece: Dictionary in reviewed:
		if String(piece["blocks"]).is_empty() or String(piece["carves"]).is_empty():
			incomplete.append(String(piece["key"]))
	for piece: Dictionary in asset_pieces:
		if not ["surface", "base", "plant"].has(String(piece["contact"])):
			bad_contact.append(String(piece["key"]))
	_expect(incomplete.is_empty(),
		"each of them also declares its reviewed collision and navigation intent (%s)"
			% ", ".join(incomplete))
	_expect(bad_contact.is_empty(),
		"and every piece uses one of the project's three ground-contact rules (%s)"
			% ", ".join(bad_contact))
	var packs: PackedStringArray = PackedStringArray()
	for piece: Dictionary in asset_pieces:
		var pack: String = String(piece["pack"])
		if not pack.is_empty() and not packs.has(pack):
			packs.append(pack)
	var sorted_packs: Array = Array(packs)
	sorted_packs.sort()
	_expect(sorted_packs == ["dungeon", "forest", "graveyard", "halloween"],
		"the palette draws on exactly the four retained packs (%s)"
			% ", ".join(PackedStringArray(sorted_packs)))

	# THE COLLISION LINE ON A CARD IS AN INTENTION WITH AN OWNER, NOT A PROMISE.
	# `dungeon:wall_broken` is recorded "solid, will need collision". Phase 1
	# authors no collision shape and no navigation carve for ANY piece, and this
	# proves the tool is not quietly promising otherwise — measured on a real
	# placement rather than argued from the absence of the word "collision".
	var solid: Dictionary = _catalogue.piece_for_key("dungeon:wall_broken")
	var probe_root: Node3D = Node3D.new()
	probe_root.name = "CollisionIntentProbe"
	var placed: Node3D = Placement.build_instance(solid, Vector3.ZERO, 0.0, 0.0, null)
	if placed != null:
		probe_root.add_child(placed)
	var authored_collision: int = 0
	var authored_carves: int = 0
	for node: Node in _all_nodes(probe_root):
		if node is CollisionShape3D or node is CollisionPolygon3D or node is CollisionObject3D:
			authored_collision += 1
		if node is NavigationObstacle3D or node is NavigationRegion3D:
			authored_carves += 1
	_expect(
		String(solid.get("blocks", "")) == "yes" and placed != null
			and authored_collision == 0 and authored_carves == 0,
		"a piece the record calls solid still places with 0 collision nodes and 0 "
			+ "navigation nodes — Phase 1 authors neither (%d, %d)"
				% [authored_collision, authored_carves]
	)
	probe_root.free()


# --- 3. Every approved piece is present and measurable ------------------------

func _check_measurement() -> void:
	_step("3. Every approved piece is present, loadable and measurable")
	var unavailable: PackedStringArray = PackedStringArray()
	var unmeasured: PackedStringArray = PackedStringArray()
	var rescaled: PackedStringArray = PackedStringArray()
	for piece: Dictionary in _catalogue.all_pieces():
		if String(piece["kind"]) != "asset":
			continue
		var key: String = String(piece["key"])
		if not bool(piece["available"]):
			unavailable.append(key)
			continue
		var measurement: Dictionary = _catalogue.measurement_for(key)
		if measurement.is_empty():
			unmeasured.append(key)
			continue
		var size: Vector3 = measurement["size"]
		if size.x <= 0.0 or size.y <= 0.0 or size.z <= 0.0:
			unmeasured.append(key)
		if Vector3(measurement["scale"]) != Vector3.ONE:
			rescaled.append(key)
		var footprint: String = _catalogue.footprint_text(key)
		if not footprint.contains("m wide"):
			unmeasured.append(key)
	_expect(unavailable.is_empty(), "no approved asset file is missing (%s)" % ", ".join(unavailable))
	_expect(unmeasured.is_empty(), "every approved asset measures a real footprint (%s)"
		% ", ".join(unmeasured))
	_expect(rescaled.is_empty(), "every approved asset measures at root scale 1.0")

	# The measured surface height for a flat piece is the plane, not the pebbles
	# on top of it — the finding Gate 1B recorded and this tool must not undo.
	var dirt: Dictionary = _catalogue.measurement_for("halloween:floor_dirt")
	_expect(
		absf(float(dirt["surface_y"])) < 0.001,
		"the dirt road bed's surface is measured at its plane, not its bounding box (%.4f)"
			% float(dirt["surface_y"])
	)
	_expect(
		absf(_catalogue.ground_offset_for("halloween:floor_dirt") - _catalogue.surface_lift()) < 0.0001,
		"a flat piece is laid at the accepted surface lift (%.4f m)" % _catalogue.surface_lift()
	)
	var rock: Dictionary = _catalogue.measurement_for("forest:Rock_3_A_Color1")
	_expect(
		float(rock["base_offset"]) < 0.0,
		"the half-buried rock is authored below its own origin (%.3f m)" % float(rock["base_offset"])
	)
	_expect(
		absf(_catalogue.ground_offset_for("forest:Rock_3_A_Color1")) < 0.0001,
		"a planted piece keeps that authored pivot instead of being lifted out of the ground"
	)
	var wall: Dictionary = _catalogue.measurement_for("dungeon:wall")
	_expect(
		absf(_catalogue.ground_offset_for("dungeon:wall") + float(wall["base_offset"])) < 0.0001,
		"a based piece is dropped so its measured underside meets the ground"
	)


# --- 4. The ground arithmetic -------------------------------------------------

func _check_ground_arithmetic() -> void:
	_step("4. The cursor finds the ground, or honestly says it cannot")
	var down: Dictionary = Placement.ray_ground_hit(
		Vector3(3.0, 10.0, -4.0), Vector3(0.0, -1.0, 0.0)
	)
	_expect(bool(down["valid"]), "a straight-down ray finds the ground")
	_expect(
		Vector3(down["point"]).is_equal_approx(Vector3(3.0, 0.0, -4.0)),
		"it lands exactly under the camera (%s)" % str(down["point"])
	)

	var angled: Dictionary = Placement.ray_ground_hit(
		Vector3(0.0, 10.0, 0.0), Vector3(1.0, -1.0, 0.0)
	)
	_expect(bool(angled["valid"]), "an angled ray finds the ground")
	_expect(
		Vector3(angled["point"]).is_equal_approx(Vector3(10.0, 0.0, 0.0)),
		"a 45° ray from 10 m up lands 10 m away (%s)" % str(angled["point"])
	)

	var level: Dictionary = Placement.ray_ground_hit(
		Vector3(0.0, 10.0, 0.0), Vector3(1.0, 0.0, 0.0)
	)
	_expect(not bool(level["valid"]), "a level ray reports no ground")
	# Replaced one for one when the copy was corrected: this used to require the
	# word "sky", which came with "Aim lower" — an instruction to move a camera the
	# owner is not holding. What is owed is that the refusal tells them what THEY
	# can do, so the assertion pins the cursor instruction rather than the old
	# metaphor. It is still one assertion, and the count did not move.
	_expect(
		String(level["reason"]).contains("Move the cursor"),
		"and says what to do about it, in cursor terms: \"%s\"" % String(level["reason"])
	)

	var up: Dictionary = Placement.ray_ground_hit(
		Vector3(0.0, 10.0, 0.0), Vector3(0.2, 1.0, 0.0)
	)
	_expect(not bool(up["valid"]), "a ray aimed upward reports no ground")

	var below: Dictionary = Placement.ray_ground_hit(
		Vector3(0.0, -5.0, 0.0), Vector3(0.0, -1.0, 0.0)
	)
	_expect(not bool(below["valid"]), "a camera below the ground reports no ground")

	# A cursor a hair above the horizon resolves kilometres out. That is arithmetic
	# rather than authoring, and the tool refuses it.
	var far: Dictionary = Placement.ray_ground_hit(
		Vector3(0.0, 10.0, 0.0), Vector3(1.0, -0.001, 0.0)
	)
	_expect(not bool(far["valid"]), "a nearly-level ray is refused rather than resolved 10 km away")
	_expect(
		String(far["reason"]).contains("too far away"),
		"and says why: \"%s\"" % String(far["reason"])
	)


func _check_snapping_and_turning() -> void:
	_step("5. Snapping and turning behave as the dock's labels promise")
	var raw: Vector3 = Vector3(3.31, 0.0, -7.62)
	_expect(
		Placement.snap_ground_point(raw, 0.0).is_equal_approx(raw),
		"\"Off\" changes nothing"
	)
	_expect(
		Placement.snap_ground_point(raw, 4.0).is_equal_approx(Vector3(4.0, 0.0, -8.0)),
		"4 m snapping lands on the module grid (%s)" % str(Placement.snap_ground_point(raw, 4.0))
	)
	_expect(
		Placement.snap_ground_point(raw, 0.25).is_equal_approx(Vector3(3.25, 0.0, -7.5)),
		"0.25 m snapping lands on the quarter-metre grid"
	)
	_expect(
		Placement.snap_ground_point(Vector3(1.0, 2.5, 1.0), 1.0).y == 2.5,
		"height is never snapped — it belongs to how the piece meets the ground"
	)
	_expect(Placement.SNAP_STEPS.size() == 5, "the five snap steps the brief names are offered")
	# THE SNAP A PIECE ARRIVES WITH, MEASURED IN METRES RATHER THAN IN INDICES, so
	# it stays true if a step is ever inserted. D-215 moved this rule out of the
	# plugin into a pure static precisely so it could be asserted at all.
	var snap_wrong: PackedStringArray = PackedStringArray()
	for piece: Dictionary in _catalogue.all_pieces():
		if String(piece["kind"]) != "asset":
			continue
		var key: String = String(piece["key"])
		var applied: float = Placement.SNAP_STEPS[
			Placement.recommended_snap_index(piece, _catalogue.measurement_for(key))
		]
		var reviewed_snap: float = float(piece["reviewed_snap"])
		var wanted: float = 0.0
		if reviewed_snap >= 0.0:
			# The reviewed grid, or the finest offered step that contains it.
			wanted = Placement.SNAP_STEPS[Placement.snap_index_containing(reviewed_snap)]
		else:
			# The D-212 accepted derivation, restated here from the measurement so
			# a change to the rule cannot pass by agreeing with itself.
			var size: Vector3 = _catalogue.measurement_for(key)["size"]
			var footprint: float = maxf(size.x, size.z)
			wanted = 4.0 if footprint >= 3.5 else (1.0 if footprint >= 1.5 else 0.0)
		if not is_equal_approx(applied, wanted):
			snap_wrong.append("%s applied %.2f wanted %.2f" % [key, applied, wanted])
	_expect(snap_wrong.is_empty(),
		"every piece arrives at the snap its record or its measured footprint asks for (%s)"
			% ", ".join(snap_wrong))
	# A 2 m reviewed grid is honoured through the 1 m step, because every 2 m
	# position is a 1 m position. Recorded, not rounded away.
	_expect(
		Placement.SNAP_STEPS[Placement.snap_index_containing(2.0)] == 1.0
			and Placement.SNAP_STEPS[Placement.snap_index_containing(4.0)] == 4.0,
		"a reviewed 2 m grid resolves to the 1 m step and a 4 m grid to the 4 m step"
	)
	_expect(
		Placement.SNAP_LABELS[0] == "Off" and Placement.SNAP_LABELS[4] == "4 m",
		"they are labelled Off, 0.25 m, 0.5 m, 1 m and 4 m"
	)
	_expect(
		is_equal_approx(Placement.turn_by(350.0, 45.0), 35.0),
		"turning past 360° wraps to a positive angle (%.1f)" % Placement.turn_by(350.0, 45.0)
	)
	_expect(
		is_equal_approx(Placement.turn_by(10.0, -45.0), 325.0),
		"turning below 0° wraps the other way (%.1f)" % Placement.turn_by(10.0, -45.0)
	)


func _check_naming() -> void:
	_step("6. Placed pieces get stable, understandable names")
	_expect(Placement.compact_name("Bare Tree, Tall") == "BareTreeTall", "\"Bare Tree, Tall\" → BareTreeTall")
	_expect(Placement.compact_name("Road Stone A") == "RoadStoneA", "\"Road Stone A\" → RoadStoneA")
	_expect(Placement.compact_name("Damaged Low Wall") == "DamagedLowWall", "\"Damaged Low Wall\" → DamagedLowWall")

	var container: Node3D = Node3D.new()
	_expect(
		Placement.next_instance_name(container, "Wall") == "Wall001",
		"the first is numbered 001"
	)
	var first: Node3D = Node3D.new()
	first.name = "Wall001"
	container.add_child(first)
	var second: Node3D = Node3D.new()
	second.name = "Wall002"
	container.add_child(second)
	_expect(
		Placement.next_instance_name(container, "Wall") == "Wall003",
		"the next is read off the children that are actually there"
	)
	container.remove_child(first)
	first.free()
	_expect(
		Placement.next_instance_name(container, "Wall") == "Wall003",
		"deleting one does not make the tool reuse its name"
	)
	container.free()

	# A PALETTE THAT GREW FROM 22 PIECES TO 69 COULD HAVE COLLIDED HERE AND NOWHERE
	# ELSE. A placed node is named from its DISPLAY name, never from its id, which
	# is exactly why pack-qualified ids cannot reach a saved scene — and exactly
	# why two pieces sharing a compacted display name would silently share a
	# numbering sequence inside one container.
	var bases: PackedStringArray = PackedStringArray()
	var clashes: PackedStringArray = PackedStringArray()
	for piece: Dictionary in _catalogue.all_pieces():
		if String(piece["kind"]) != "asset":
			continue
		var base: String = Placement.compact_name(String(piece["display"]))
		if bases.has(base):
			clashes.append(base)
		bases.append(base)
	_expect(clashes.is_empty(),
		"all %d model names compact to distinct node-name stems (%s)"
			% [bases.size(), ", ".join(clashes)])
	var marker_clashes: PackedStringArray = PackedStringArray()
	for reserved: String in ["PlayerStart", "WayOut", "PointOfInterest", "DeveloperTestSpawn"]:
		for base: String in bases:
			if base == reserved or base.begins_with(reserved) or reserved.begins_with(base):
				marker_clashes.append("%s vs %s" % [base, reserved])
	_expect(marker_clashes.is_empty(),
		"and none of them can be confused with a marker's own node name (%s)"
			% ", ".join(marker_clashes))


# --- 7. Placement, undo and redo ----------------------------------------------

func _check_placement_and_undo() -> void:
	_step("7. One piece from every category places, undoes and redoes exactly")
	var root: Node3D = _new_zone_root()
	var undo_redo: UndoRedo = UndoRedo.new()

	var chosen: Array[Dictionary] = []
	for category: String in Catalogue.CATEGORIES:
		var pieces: Array[Dictionary] = _catalogue.pieces_in_category(category)
		if not pieces.is_empty():
			chosen.append(pieces[0])
	_expect(chosen.size() == 6, "all six categories offer a piece to place (%d)" % chosen.size())

	var placed: Array[Node3D] = []
	var facing: float = 0.0
	var index: int = 0
	for piece: Dictionary in chosen:
		facing = Placement.turn_by(facing, 45.0)
		var at: Vector3 = Vector3(float(index) * 6.0, 0.0, -float(index) * 4.0)
		var result: Dictionary = Actions.place_piece(
			undo_redo, root, _catalogue, piece, at, facing
		)
		_expect(not result.is_empty(), "\"%s\" places" % String(piece["display"]))
		if result.is_empty():
			index += 1
			continue
		var node: Node3D = result["node"]
		placed.append(node)
		var wanted_container: String = String(
			Catalogue.CONTAINER_FOR_CATEGORY[String(piece["category"])]
		)
		_expect(
			String(node.get_parent().name) == wanted_container,
			"  it lands under \"%s\"" % wanted_container
		)
		_expect(node.owner == root, "  it belongs to the scene, so it will be saved")
		_expect(node.scale.is_equal_approx(Vector3.ONE), "  it is placed at the accepted scale")
		_expect(
			absf(node.position.x - at.x) < 0.0001 and absf(node.position.z - at.z) < 0.0001,
			"  it lands on the clicked spot"
		)
		_expect(
			absf(node.position.y - _catalogue.ground_offset_for(String(piece["key"]))) < 0.0001,
			"  it meets the ground the way the accepted record says it should"
		)
		_expect(
			absf(rad_to_deg(node.rotation.y) - facing) < 0.01
				or absf(rad_to_deg(node.rotation.y) + 360.0 - facing) < 0.01,
			"  it is turned to %d°" % int(facing)
		)
		_expect(
			node.rotation.x == 0.0 and node.rotation.z == 0.0,
			"  and only around the upright axis"
		)
		if String(piece["kind"]) == "asset":
			_expect(
				String(node.scene_file_path) == String(piece["path"]),
				"  it is an ordinary instance of the source model, not a copy of it"
			)
		index += 1

	var full: Dictionary = _describe(root)
	_expect(int(full["nodes"]) > 6, "the zone now holds %d nodes" % int(full["nodes"]))

	# Undo everything, one action at a time.
	var undone: int = 0
	# Bounded on purpose. `undo()` returning false while `has_undo()` stays true is
	# exactly what an unbalanced action does, and an unbounded loop turns that
	# defect into an 8-million-line log instead of a failed check. It did, once.
	while undo_redo.has_undo() and undone < 64:
		if not undo_redo.undo():
			break
		undone += 1
	_expect(undone == chosen.size(), "every placement is one undo step (%d)" % undone)
	var empty: Dictionary = _describe(root)
	_expect(
		int(empty["nodes"]) == 1,
		"undoing every placement leaves the bare scene root (%d nodes)" % int(empty["nodes"])
	)
	var still_parented: int = 0
	for node: Node3D in placed:
		if is_instance_valid(node) and node.get_parent() != null:
			still_parented += 1
	_expect(still_parented == 0, "nothing is left dangling in the tree")

	# Redo everything, and require the result to be identical node for node.
	var redone: int = 0
	while undo_redo.has_redo() and redone < 64:
		if not undo_redo.redo():
			break
		redone += 1
	_expect(redone == chosen.size(), "every placement redoes (%d)" % redone)
	var restored: Dictionary = _describe(root)
	_expect(
		restored["signature"] == full["signature"],
		"redo restores the exact scene state — every path, transform and source"
	)

	# And one more round trip, because a history that survives once is not proof
	# that it survives twice.
	var again: int = 0
	while undo_redo.has_undo() and again < 64:
		if not undo_redo.undo():
			break
		again += 1
	again = 0
	while undo_redo.has_redo() and again < 64:
		if not undo_redo.redo():
			break
		again += 1
	_expect(
		_describe(root)["signature"] == full["signature"],
		"a second undo/redo round trip restores it again, unchanged"
	)

	# `UndoRedo` extends Object, not RefCounted, so every one this file makes has to
	# be freed by hand or it is reported as a leaked ObjectDB instance at exit.
	root.free()
	undo_redo.free()


# --- 8. Save and reopen -------------------------------------------------------

func _check_save_and_reopen() -> void:
	_step("8. A composed zone survives being saved and reopened")
	var root: Node3D = _new_zone_root()
	var undo_redo: UndoRedo = UndoRedo.new()
	var keys: Array[String] = ["dungeon:floor_tile_large", "dungeon:wall", "halloween:path_A", "halloween:arch",
		"marker_player_start"]
	var index: int = 0
	for key: String in keys:
		var piece: Dictionary = _catalogue.piece_for_key(key)
		Actions.place_piece(
			undo_redo, root, _catalogue, piece,
			Vector3(float(index) * 4.0, 0.0, 0.0), 90.0
		)
		index += 1
	var before: Dictionary = _describe(root)

	var packed: PackedScene = PackedScene.new()
	_expect(packed.pack(root) == OK, "the zone packs")
	_expect(
		ResourceSaver.save(packed, SAVED_ZONE_PATH) == OK,
		"the zone saves as an ordinary .tscn"
	)
	root.free()

	var text: String = FileAccess.get_file_as_string(SAVED_ZONE_PATH)
	_expect(not text.is_empty(), "the saved file has content (%d bytes)" % text.length())
	_expect(
		not text.contains("addons/"),
		"the saved zone names no part of this addon, so the running game needs no editor code"
	)
	_expect(
		not text.contains("riftfall_landing"),
		"and it carries no dependency on Riftfall Landing's own implementation either"
	)
	_expect(
		text.contains("assets/third_party/kaykit/dungeon/wall.gltf")
			or text.contains("uid://"),
		"it references the approved source models"
	)

	var reopened_scene: PackedScene = ResourceLoader.load(
		SAVED_ZONE_PATH, "PackedScene", ResourceLoader.CACHE_MODE_IGNORE
	) as PackedScene
	_expect(reopened_scene != null, "the saved zone reopens")
	var reopened: Node3D = reopened_scene.instantiate() as Node3D
	_expect(reopened != null, "and instantiates")
	var after: Dictionary = _describe(reopened)
	_expect(
		after["signature"] == before["signature"],
		"every piece comes back in the same place, at the same angle, from the same model"
	)
	_expect(
		reopened.get_node_or_null(NodePath("Markers/PlayerStart")) != null,
		"the Player Start marker survives the round trip"
	)
	reopened.free()
	undo_redo.free()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVED_ZONE_PATH))

	_check_expansion_round_trip()


## THE SAMPLE ABOVE IS ENTIRELY GATE 1C PIECES, AND THAT IS NOT AN ACCIDENT — it
## is the sample the check was written with, and `pieces_in_category(c)[0]` is a
## Gate 1C piece in every drawer because that record loads first. So none of the
## 47 models D-215 added had been placed, undone, saved or reopened by anything
## above. This does exactly that, over a sample spanning every category the
## expansion touched AND all three of its source packs, because a palette proved
## only on the pieces that were already there proves nothing about the new ones.
func _check_expansion_round_trip() -> void:
	_step("8b. A sample of the D-215 expansion places, undoes, saves and reopens")
	# One per category, chosen so the five together span Dungeon, Halloween and
	# Forest. Story Markers gains no expansion model, so it is not represented
	# here; step 7 covers it.
	var sample: Array[String] = [
		"halloween:floor_dirt_small",   # Ground,       Halloween
		"dungeon:barrier_half",         # Roads,        Dungeon
		"dungeon:wall_broken",          # Architecture, Dungeon
		"forest:Rock_1_H_Color1",       # Boundaries,   Forest
		"halloween:shrine",             # Props,        Halloween
	]
	var root: Node3D = _new_zone_root()
	var undo_redo: UndoRedo = UndoRedo.new()
	var categories: PackedStringArray = PackedStringArray()
	var packs: PackedStringArray = PackedStringArray()
	var placed: int = 0
	var index: int = 0
	for key: String in sample:
		var piece: Dictionary = _catalogue.piece_for_key(key)
		if piece.is_empty():
			continue
		if not categories.has(String(piece["category"])):
			categories.append(String(piece["category"]))
		if not packs.has(String(piece["pack"])):
			packs.append(String(piece["pack"]))
		var result: Dictionary = Actions.place_piece(
			undo_redo, root, _catalogue, piece,
			Vector3(float(index) * 6.0, 0.0, 0.0), 45.0
		)
		if not result.is_empty():
			placed += 1
		index += 1
	_expect(placed == sample.size(),
		"all %d sample pieces place (%d)" % [sample.size(), placed])
	_expect(categories.size() == 5,
		"the sample spans every category the expansion touched (%s)" % ", ".join(categories))
	var sorted_packs: Array = Array(packs)
	sorted_packs.sort()
	_expect(sorted_packs == ["dungeon", "forest", "halloween"],
		"and all three of its source packs (%s)" % ", ".join(PackedStringArray(sorted_packs)))
	var full: Dictionary = _describe(root)

	# Undo every one, then redo every one, and require the tree back exactly.
	var undone: int = 0
	while undo_redo.has_undo() and undone < 32:
		if not undo_redo.undo():
			break
		undone += 1
	_expect(undone == sample.size(), "each is one undo step (%d)" % undone)
	_expect(int(_describe(root)["nodes"]) == 1,
		"undoing them all leaves the bare scene root")
	var redone: int = 0
	while undo_redo.has_redo() and redone < 32:
		if not undo_redo.redo():
			break
		redone += 1
	_expect(redone == sample.size(), "and each redoes (%d)" % redone)
	_expect(_describe(root)["signature"] == full["signature"],
		"redo restores every path, transform and source exactly")

	var packed: PackedScene = PackedScene.new()
	_expect(packed.pack(root) == OK and
		ResourceSaver.save(packed, SAVED_ZONE_PATH) == OK,
		"the sample zone packs and saves as an ordinary .tscn")
	root.free()

	var text: String = FileAccess.get_file_as_string(SAVED_ZONE_PATH)
	_expect(not text.contains("addons/"),
		"the saved file names no part of this addon")
	# The paths in the file read `.../kaykit/dungeon/wall_broken.gltf`, with a
	# SLASH. A colon after a pack name would mean an id had been written into the
	# zone, which is the one thing that would break a scene composed before D-215.
	_expect(
		not text.contains("dungeon:") and not text.contains("halloween:")
			and not text.contains("forest:") and not text.contains("graveyard:"),
		"AND NO PACK-QUALIFIED ID REACHES THE FILE — the id is the tool's, never the zone's"
	)
	var reopened_scene: PackedScene = ResourceLoader.load(
		SAVED_ZONE_PATH, "PackedScene", ResourceLoader.CACHE_MODE_IGNORE
	) as PackedScene
	var reopened: Node3D = reopened_scene.instantiate() as Node3D if reopened_scene != null else null
	_expect(reopened != null, "the sample zone reopens and instantiates")
	if reopened != null:
		_expect(_describe(reopened)["signature"] == full["signature"],
			"every expansion piece comes back in the same place, at the same angle, from the same model")
		# The node names came from the DISPLAY name, which is what makes the id
		# invisible to a saved scene. Prove the actual names, not the count.
		var names: PackedStringArray = PackedStringArray()
		for container: Node in reopened.get_children():
			for child: Node in container.get_children():
				names.append(String(child.name))
		var wanted: Array[String] = [
			"SmallDirtPatch001", "ShortStoneKerb001", "BrokenWallSection001",
			"PlayerScaleBoulder001", "WaysideShrineStone001",
		]
		var found: int = 0
		for name: String in wanted:
			if names.has(name):
				found += 1
		_expect(found == wanted.size(),
			"and each is named from its plain-language name, not its id (%d of %d: %s)"
				% [found, wanted.size(), ", ".join(names)])
		reopened.free()
	undo_redo.free()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVED_ZONE_PATH))


# --- 9. Play From Here --------------------------------------------------------

func _check_play_from_here() -> void:
	_step("9. \"Play From Here\" never moves the zone's real Player Start")
	var root: Node3D = _new_zone_root()
	var undo_redo: UndoRedo = UndoRedo.new()
	Actions.place_piece(
		undo_redo, root, _catalogue, _catalogue.piece_for_key("marker_player_start"),
		Vector3(2.0, 0.0, 3.0), 0.0
	)
	var start: Marker3D = Actions.player_start(root)
	_expect(start != null, "the zone has a Player Start")
	var start_before: Transform3D = start.transform

	var first: Dictionary = Actions.set_developer_spawn(undo_redo, root, Vector3(20.0, 0.0, -30.0))
	_expect(bool(first["created"]), "the first Play From Here creates a separate developer marker")
	var spawn: Marker3D = first["node"]
	_expect(
		String(spawn.name) == Catalogue.DEVELOPER_SPAWN_NODE_NAME,
		"it is called %s, not PlayerStart" % Catalogue.DEVELOPER_SPAWN_NODE_NAME
	)
	_expect(spawn != start, "it is a different node from the Player Start")
	_expect(
		spawn.position.is_equal_approx(Vector3(20.0, 0.0, -30.0)),
		"it sits where the owner clicked"
	)
	_expect(start.transform == start_before, "the Player Start has not moved")

	var second: Dictionary = Actions.set_developer_spawn(undo_redo, root, Vector3(-8.0, 0.0, 11.0))
	_expect(not bool(second["created"]), "a second Play From Here moves the same marker")
	_expect(
		spawn.position.is_equal_approx(Vector3(-8.0, 0.0, 11.0)),
		"it moves to the new spot"
	)
	_expect(start.transform == start_before, "the Player Start still has not moved")

	undo_redo.undo()
	_expect(
		spawn.position.is_equal_approx(Vector3(20.0, 0.0, -30.0)),
		"undo puts the developer marker back"
	)
	_expect(start.transform == start_before, "and the Player Start is untouched throughout")
	root.free()
	undo_redo.free()


# --- 10. The preview can never be saved ---------------------------------------

func _check_preview_is_never_saved() -> void:
	_step("10. The translucent placement preview can never be saved into a zone")
	var root: Node3D = _new_zone_root()
	var undo_redo: UndoRedo = UndoRedo.new()
	Actions.place_piece(
		undo_redo, root, _catalogue, _catalogue.piece_for_key("dungeon:wall"),
		Vector3.ZERO, 0.0
	)

	# Exactly what the plugin does while the mouse is over the viewport: a child
	# with NO OWNER.
	var preview: Node3D = Node3D.new()
	preview.name = PREVIEW_NODE_NAME
	var body: Node3D = (load("res://assets/third_party/kaykit/dungeon/wall.gltf") as PackedScene).instantiate() as Node3D
	preview.add_child(body)
	root.add_child(preview)
	_expect(preview.owner == null, "the preview deliberately has no owner")
	_expect(
		root.get_node_or_null(NodePath(PREVIEW_NODE_NAME)) != null,
		"it is in the live tree while placing"
	)

	var packed: PackedScene = PackedScene.new()
	_expect(packed.pack(root) == OK, "the zone packs with the preview present")
	var rebuilt: Node3D = packed.instantiate() as Node3D
	_expect(
		rebuilt.get_node_or_null(NodePath(PREVIEW_NODE_NAME)) == null,
		"the preview is absent from the packed scene"
	)
	_expect(
		rebuilt.get_node_or_null(NodePath("Architecture/TallStoneWall001")) != null,
		"while the real placement is present"
	)
	rebuilt.free()
	root.free()
	undo_redo.free()


# --- 11-13. Story marker symbols (D-211) --------------------------------------

func _check_marker_symbols() -> void:
	_step("11. Every story marker has its own symbol, distinct by shape as well as colour")
	var palette_markers: Array[Dictionary] = []
	for piece: Dictionary in _catalogue.all_pieces():
		if String(piece["kind"]) == "marker":
			palette_markers.append(piece)
	_expect(palette_markers.size() == 3, "the palette offers 3 markers (%d)" % palette_markers.size())

	var kinds: PackedStringArray = Shapes.kinds()
	_expect(
		kinds.size() == 4,
		"4 symbols are drawn: the 3 placeable markers plus the developer test spawn (%d)" % kinds.size()
	)

	# BOTH DIRECTIONS, exactly as the palette proves itself against the accepted
	# record: a palette marker with no symbol would be invisible again, and a
	# symbol for something the palette does not offer would be a second list.
	for piece: Dictionary in palette_markers:
		var key: String = String(piece["key"])
		_expect(
			Shapes.lines_for(key).size() > 0,
			"\"%s\" has a symbol drawn for it" % String(piece["display"])
		)
		_expect(
			Shapes.display_for(key) == String(piece["display"]),
			"  and the viewport calls it exactly what the palette calls it"
		)
		_expect(
			Shapes.node_name_for(key) == String(piece["node_name"]),
			"  and draws it on the node name the palette places (%s)" % String(piece["node_name"])
		)
		_expect(Shapes.has_facing_arrow(key), "  and it carries a facing arrow")
	var orphans: PackedStringArray = PackedStringArray()
	for kind: String in kinds:
		if kind == Shapes.DEVELOPER_SPAWN_KIND:
			continue
		if _catalogue.piece_for_key(kind).is_empty():
			orphans.append(kind)
	_expect(
		orphans.is_empty(),
		"no symbol is drawn for a marker the palette does not offer (%s)" % ", ".join(orphans)
	)
	_expect(
		Shapes.node_name_for(Shapes.DEVELOPER_SPAWN_KIND) == Catalogue.DEVELOPER_SPAWN_NODE_NAME,
		"the developer test spawn's symbol is drawn on %s" % Catalogue.DEVELOPER_SPAWN_NODE_NAME
	)
	_expect(
		not Shapes.has_facing_arrow(Shapes.DEVELOPER_SPAWN_KIND),
		"and it deliberately has NO arrow, because Play From Here writes a position and never a facing"
	)

	# Distinct by SHAPE. The line segments carry no colour at all, so any
	# difference here is a difference of form.
	var signatures: Dictionary = {}
	var counts: Dictionary = {}
	for kind: String in kinds:
		var lines: PackedVector3Array = Shapes.lines_for(kind)
		var parts: PackedStringArray = PackedStringArray()
		for point: Vector3 in lines:
			parts.append("%.3f,%.3f,%.3f" % [point.x, point.y, point.z])
		signatures[kind] = "|".join(parts)
		counts[kind] = lines.size() / 2
	var shape_clashes: int = 0
	var colour_clashes: int = 0
	var count_clashes: int = 0
	for i: int in kinds.size():
		for j: int in range(i + 1, kinds.size()):
			if String(signatures[kinds[i]]) == String(signatures[kinds[j]]):
				shape_clashes += 1
			if Shapes.colour_for(kinds[i]) == Shapes.colour_for(kinds[j]):
				colour_clashes += 1
			if int(counts[kinds[i]]) == int(counts[kinds[j]]):
				count_clashes += 1
	_expect(shape_clashes == 0, "no two symbols are the same shape")
	_expect(count_clashes == 0, "and no two are even built from the same number of segments (%s)"
		% str(counts))
	_expect(colour_clashes == 0, "no two symbols are the same colour either")

	# Readable at authoring zoom, measured against the project's own scale rather
	# than judged by eye: the player capsule is 1.80 m and the KayKit wall module
	# is 4.000 m.
	for kind: String in kinds:
		var box: AABB = _bounds_of(Shapes.lines_for(kind))
		var wanted_height: float = 2.5 if kind != Shapes.DEVELOPER_SPAWN_KIND else 0.5
		var wanted_width: float = 2.0 if kind != Shapes.DEVELOPER_SPAWN_KIND else 1.0
		var against: String = (
			"a third the height of a real marker" if kind == Shapes.DEVELOPER_SPAWN_KIND
			else "about a person, against a 4.000 m wall"
		)
		_expect(
			box.size.y >= wanted_height and box.size.y <= 3.2,
			"\"%s\" stands %.2f m tall — %s" % [Shapes.display_for(kind), box.size.y, against]
		)
		_expect(
			maxf(box.size.x, box.size.z) >= wanted_width,
			"  and measures %.2f m across, so it reads from directly above as well"
				% maxf(box.size.x, box.size.z)
		)
	_expect(
		_bounds_of(Shapes.lines_for(Shapes.DEVELOPER_SPAWN_KIND)).size.y
			< _bounds_of(Shapes.lines_for("marker_player_start")).size.y * 0.5,
		"the developer test spawn is drawn under half the height of a real marker, so it cannot be mistaken for one"
	)

	# The preview is built from the SAME segments, which is the only way it can be
	# a preview of the thing rather than a second drawing of it.
	for kind: String in kinds:
		var mesh: ArrayMesh = Shapes.line_mesh_for(kind)
		_expect(mesh != null, "\"%s\" builds a preview mesh" % Shapes.display_for(kind))
		if mesh == null:
			continue
		_expect(mesh.get_surface_count() == 1, "  with one surface")
		_expect(
			mesh.surface_get_primitive_type(0) == Mesh.PRIMITIVE_LINES,
			"  drawn as lines"
		)
		var vertices: PackedVector3Array = mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
		_expect(
			vertices == Shapes.lines_for(kind),
			"  from exactly the segments the placed marker is drawn from (%d points)" % vertices.size()
		)

	# The name a marker is claimed by, and — more important — the names it is not.
	_expect(Shapes.kind_for_node_name("PlayerStart") == "marker_player_start", "\"PlayerStart\" is a Player Start")
	_expect(Shapes.kind_for_node_name("PlayerStart002") == "marker_player_start",
		"and so is \"PlayerStart002\", which is how a second one is named")
	_expect(Shapes.kind_for_node_name("WayOut") == "marker_exit", "\"WayOut\" is a Way Out")
	_expect(Shapes.kind_for_node_name("PointOfInterest") == "marker_focus", "\"PointOfInterest\" is a Look At This")
	_expect(
		Shapes.kind_for_node_name("DeveloperTestSpawn") == Shapes.DEVELOPER_SPAWN_KIND,
		"\"DeveloperTestSpawn\" is the developer test spawn"
	)
	# The near misses that would actually happen. `PlayerSpawn` is one of the five
	# sockets Riftfall Landing builds at run time, one word away from PlayerStart;
	# `CeremonialArch001` is a MODEL that lives in the same Markers container.
	for stranger: String in [
		"PlayerStartCamera", "PlayerSpawn", "ExitToBrokenWatch", "RiftScarFocus",
		"CeremonialArch001", "Markers", "Ground", "Marker3D", "",
	]:
		_expect(
			Shapes.kind_for_node_name(stranger).is_empty(),
			"\"%s\" is claimed by nothing" % stranger
		)
	var impostor: Node3D = Node3D.new()
	impostor.name = "PlayerStart"
	_expect(
		Shapes.kind_for_node(impostor).is_empty(),
		"a plain Node3D called PlayerStart is left alone — only a Marker3D is claimed"
	)
	impostor.free()
	_expect(Shapes.kind_for_node(null).is_empty(), "and nothing at all is claimed by nothing")

	# THE SYMBOL MEANS "THE TOOL HONOURS THIS MARKER", so it is drawn on exactly
	# the set the tool honours: direct children of the Markers container. A marker
	# dragged into Props is one `ZoneComposerActions.player_start()` will no longer
	# find, and a full green symbol claiming otherwise would be a lie.
	var holder: Node3D = Node3D.new()
	for container_name: String in ["Markers", "Props"]:
		var container: Node3D = Node3D.new()
		container.name = container_name
		holder.add_child(container)
		var marker: Marker3D = Marker3D.new()
		marker.name = "PlayerStart"
		container.add_child(marker)
		var claimed: bool = not Shapes.kind_for_node(marker).is_empty()
		_expect(
			claimed == (container_name == "Markers"),
			"a PlayerStart under \"%s\" is %s" % [
				container_name, "drawn" if container_name == "Markers" else "left undrawn"
			]
		)
	# AND THE `Markers` CONTAINER LEGITIMATELY HOLDS A MODEL. The palette files the
	# Ceremonial Arch under "Story Markers", so `place_piece` puts an ordinary
	# instanced landmark in beside the points. It must be left alone, and it must
	# not make the container look malformed.
	var landmark: Node3D = Node3D.new()
	landmark.name = "CeremonialArch001"
	holder.get_node("Markers").add_child(landmark)
	_expect(
		Shapes.kind_for_node(landmark).is_empty(),
		"a Ceremonial Arch in the Markers container is a model, and is claimed by nothing"
	)
	var claimed_in_mixed: int = 0
	for child: Node in holder.get_node("Markers").get_children():
		if not Shapes.kind_for_node(child).is_empty():
			claimed_in_mixed += 1
	_expect(
		claimed_in_mixed == 1,
		"and a container holding one marker and one model still claims exactly the marker (%d)"
			% claimed_in_mixed
	)

	var nested_group: Node3D = Node3D.new()
	nested_group.name = "Group"
	holder.get_node("Markers").add_child(nested_group)
	var nested: Marker3D = Marker3D.new()
	nested.name = "WayOut"
	nested_group.add_child(nested)
	_expect(
		Shapes.kind_for_node(nested).is_empty(),
		"and one nested a level deeper under Markers/Group is left undrawn too"
	)
	holder.free()

	# A facing you cannot SEE is not a facing. Proved by distance rather than by
	# comparing formatted point sets: a symbol that is rotationally symmetric
	# still produces different-looking text after a 180° turn, because 0.0 and
	# -7.6e-17 are different strings.
	var half_turn: Basis = Basis(Vector3.UP, PI)
	for kind: String in kinds:
		var lines: PackedVector3Array = Shapes.lines_for(kind)
		var worst: float = 0.0
		for point: Vector3 in lines:
			var turned: Vector3 = half_turn * point
			var nearest: float = 1e9
			for other: Vector3 in lines:
				nearest = minf(nearest, turned.distance_to(other))
			worst = maxf(worst, nearest)
		if kind == Shapes.DEVELOPER_SPAWN_KIND:
			_expect(
				worst < 0.001,
				"the developer test spawn is deliberately the same shape whichever way it faces (%.6f m)"
					% worst
			)
		else:
			_expect(
				worst > 1.0,
				"\"%s\" looks visibly different after a half turn — %.3f m of movement"
					% [Shapes.display_for(kind), worst]
			)


func _check_marker_facing() -> void:
	_step("12. A marker's arrow answers the facing it was placed at")
	_expect(
		Shapes.FORWARD.is_equal_approx(Vector3(0.0, 0.0, 1.0)),
		"forward is +Z, which is the axis every other facing in this project uses"
	)
	for kind: String in Shapes.placeable_kinds():
		var tip: Vector3 = Shapes.facing_tip(kind)
		_expect(absf(tip.x) < 0.0001, "\"%s\" points its arrow straight ahead" % Shapes.display_for(kind))
		_expect(tip.z >= 2.0, "  and 2.60 m ahead, further than the symbol is wide (%.2f m)" % tip.z)
		var furthest: float = -1e9
		for point: Vector3 in Shapes.lines_for(kind):
			furthest = maxf(furthest, point.z)
		_expect(
			absf(furthest - tip.z) < 0.0001,
			"  with nothing drawn in front of it, so the arrow is what leads"
		)

	var root: Node3D = _new_zone_root()
	var undo_redo: UndoRedo = UndoRedo.new()
	var angles: Array[float] = [0.0, 45.0, 90.0, 180.0]
	for kind: String in Shapes.placeable_kinds():
		for facing: float in angles:
			var result: Dictionary = Actions.place_piece(
				undo_redo, root, _catalogue, _catalogue.piece_for_key(kind),
				Vector3(facing * 0.1, 0.0, 0.0), facing
			)
			if result.is_empty():
				_expect(false, "\"%s\" places at %d°" % [Shapes.display_for(kind), int(facing)])
				continue
			var node: Node3D = result["node"]
			var wanted: Vector3 = Vector3(sin(deg_to_rad(facing)), 0.0, cos(deg_to_rad(facing)))
			# Compared flat on the ground: the arrow lies 30 mm above the ground
			# plane so it is never inside it, and that lift is not a direction.
			var turned: Vector3 = node.transform.basis * Shapes.facing_tip(kind)
			var pointed: Vector3 = Vector3(turned.x, 0.0, turned.z).normalized()
			_expect(
				pointed.is_equal_approx(wanted),
				"\"%s\" at %3d° points its arrow at %s (wanted %s)"
					% [Shapes.display_for(kind), int(facing), str(pointed.snappedf(0.0001)),
						str(wanted.snappedf(0.0001))]
			)
			_expect(
				Shapes.kind_for_node(node) == kind,
				"  and the placed node is still recognised as \"%s\"" % Shapes.display_for(kind)
			)

	# Undo takes the marker AND its drawing away, because the drawing belongs to
	# the node: there is nothing else to remove.
	var markers: Node = root.get_node_or_null(NodePath("Markers"))
	var before_count: int = 0 if markers == null else markers.get_child_count()
	_expect(before_count == 12, "twelve markers were placed (%d)" % before_count)
	var undone: int = 0
	while undo_redo.has_undo() and undone < 64:
		if not undo_redo.undo():
			break
		undone += 1
	_expect(undone == 12, "each is one undo step (%d)" % undone)
	_expect(
		root.get_node_or_null(NodePath("Markers")) == null,
		"undoing them all leaves no marker and no container to draw one in"
	)
	var redone: int = 0
	while undo_redo.has_redo() and redone < 64:
		if not undo_redo.redo():
			break
		redone += 1
	_expect(redone == 12, "and redo restores every one (%d)" % redone)
	markers = root.get_node_or_null(NodePath("Markers"))
	var restored_kinds: int = 0
	for child: Node in markers.get_children():
		if not Shapes.kind_for_node(child).is_empty():
			restored_kinds += 1
	_expect(
		restored_kinds == 12,
		"each restored marker is recognised again, so its symbol comes back with it (%d)" % restored_kinds
	)
	root.free()
	undo_redo.free()


func _check_marker_visualization_is_editor_only() -> void:
	_step("13. The visualization is drawn by the editor and never by the zone")
	var root: Node3D = _new_zone_root()
	var undo_redo: UndoRedo = UndoRedo.new()
	var placed: Dictionary = {}
	var facing: float = 0.0
	for kind: String in Shapes.placeable_kinds():
		facing += 45.0
		var result: Dictionary = Actions.place_piece(
			undo_redo, root, _catalogue, _catalogue.piece_for_key(kind),
			Vector3(facing * 0.05, 0.0, -facing * 0.05), facing
		)
		if not result.is_empty():
			var node: Node3D = result["node"]
			placed[String(node.name)] = {
				"kind": kind, "position": node.position, "facing": node.rotation.y,
			}
	Actions.set_developer_spawn(undo_redo, root, Vector3(9.0, 0.0, -3.0))

	var packed: PackedScene = PackedScene.new()
	_expect(packed.pack(root) == OK, "a zone with all four markers packs")
	_expect(
		ResourceSaver.save(packed, SAVED_MARKER_ZONE_PATH) == OK,
		"and saves as an ordinary .tscn"
	)
	root.free()

	var text: String = FileAccess.get_file_as_string(SAVED_MARKER_ZONE_PATH)
	_expect(not text.is_empty(), "the saved file has content (%d bytes)" % text.length())
	for forbidden: String in [
		"addons/", "marker_shapes", "marker_gizmos", "EditorNode3DGizmo", "ZoneComposer",
	]:
		_expect(
			not text.contains(forbidden),
			"the saved zone contains no \"%s\": it needs no editor code to open or run" % forbidden
		)
	_expect(
		not text.contains("MeshInstance3D"),
		"and no marker mesh was written into it — a marker is still an empty point on disk"
	)

	var reopened: Node3D = (ResourceLoader.load(
		SAVED_MARKER_ZONE_PATH, "PackedScene", ResourceLoader.CACHE_MODE_IGNORE
	) as PackedScene).instantiate() as Node3D
	_expect(reopened != null, "the zone reopens")
	var markers: Node = reopened.get_node_or_null(NodePath("Markers"))
	_expect(markers != null, "and its Markers container is there")
	_expect(
		markers.get_child_count() == 4,
		"holding the three story markers and the developer test spawn (%d)" % markers.get_child_count()
	)
	var kept_kind: int = 0
	var kept_place: int = 0
	var kept_facing: int = 0
	for child: Node in markers.get_children():
		var record: Dictionary = placed.get(String(child.name), {}) as Dictionary
		if record.is_empty():
			continue
		var marker: Marker3D = child as Marker3D
		if marker == null:
			continue
		if Shapes.kind_for_node(marker) == String(record["kind"]):
			kept_kind += 1
		if marker.position.is_equal_approx(Vector3(record["position"])):
			kept_place += 1
		if absf(marker.rotation.y - float(record["facing"])) < 0.0001:
			kept_facing += 1
	_expect(kept_kind == 3, "every story marker comes back as the same kind (%d of 3)" % kept_kind)
	_expect(kept_place == 3, "in the same place (%d of 3)" % kept_place)
	_expect(kept_facing == 3, "facing the same way (%d of 3)" % kept_facing)

	_expect(
		_marker_container_is_bare(markers.get_children()) == 0,
		"and every one of them is still a bare Marker3D — no child, no script, no metadata"
	)
	_expect(
		_visual_nodes_under(markers) == 0,
		"nothing under Markers can render at all, so running the zone shows no marker graphics"
	)
	reopened.free()
	undo_redo.free()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVED_MARKER_ZONE_PATH))

	_step("14. The same is true of the zone the owner already composed")
	var practice_scene: PackedScene = ResourceLoader.load(
		PRACTICE_ZONE_PATH, "PackedScene", ResourceLoader.CACHE_MODE_IGNORE
	) as PackedScene
	_expect(practice_scene != null, "the owner's practice zone loads")
	if practice_scene != null:
		var practice: Node3D = practice_scene.instantiate() as Node3D
		var practice_markers: Node = practice.get_node_or_null(NodePath("Markers"))
		_expect(practice_markers != null, "and has a Markers container")
		if practice_markers != null:
			# SCOPED TO THE `Marker3D` CHILDREN, AND THAT IS NOT A WEAKENING — it is
			# the difference between a true claim and a false one. The palette files
			# the Ceremonial Arch under "Story Markers", so `place_piece` puts an
			# ordinary MODEL into this same container: an assertion over the whole
			# child list would fail the moment the owner places one, which is the
			# third time in this change a guard has been caught failing on ordinary
			# use of the tool it guards. What is owed is that every marker is
			# recognised and renders nothing — not that the folder holds only markers.
			var markers_only: Array[Node] = []
			var other_children: PackedStringArray = PackedStringArray()
			for child: Node in practice_markers.get_children():
				if child is Marker3D:
					markers_only.append(child)
				else:
					other_children.append(String(child.name))
			var recognised: PackedStringArray = PackedStringArray()
			for child: Node in markers_only:
				var kind: String = Shapes.kind_for_node(child)
				if not kind.is_empty():
					recognised.append("%s=%s" % [String(child.name), Shapes.display_for(kind)])
			if not other_children.is_empty():
				print("      it also holds %d model(s) the palette files under Story Markers: %s"
					% [other_children.size(), ", ".join(other_children)])
			_expect(
				recognised.size() > 0,
				"it holds markers to recognise (%d)" % recognised.size()
			)
			_expect(
				recognised.size() == markers_only.size(),
				"and every one of them is recognised, so it lights up with no edit to the file: %s"
					% ", ".join(recognised)
			)
			_expect(
				_marker_container_is_bare(markers_only) == 0,
				"each is still a bare Marker3D — no child, no script, no metadata"
			)
			var renderable: int = 0
			for child: Node in markers_only:
				renderable += _visual_nodes_under(child)
			_expect(
				renderable == 0,
				"and nothing under any of them can render, so running the zone shows no marker graphics"
			)
		practice.free()

	# The pure half stays pure, and the editor-only half stays out of it.
	var shapes_text: String = FileAccess.get_file_as_string(
		"%s/zone_composer_marker_shapes.gd" % ADDON_DIRECTORY
	)
	for editor_token: String in [
		"EditorNode3DGizmo", "EditorPlugin", "EditorInterface", "EditorUndoRedoManager",
	]:
		_expect(
			not _code_of(shapes_text).contains(editor_token),
			"the symbol geometry names no editor class (%s), so it can be measured without one" % editor_token
		)
	var gizmo_text: String = FileAccess.get_file_as_string(
		"%s/zone_composer_marker_gizmos.gd" % ADDON_DIRECTORY
	)
	_expect(
		_code_of(gizmo_text).contains("extends EditorNode3DGizmoPlugin"),
		"the drawing itself is an EditorNode3DGizmoPlugin, which cannot exist outside an editor"
	)
	var importers: PackedStringArray = PackedStringArray()
	for path: String in _addon_scripts():
		if path.ends_with("zone_composer_marker_gizmos.gd"):
			continue
		if _code_of(FileAccess.get_file_as_string(path)).contains("zone_composer_marker_gizmos.gd"):
			importers.append(path.get_file())
	_expect(
		importers.size() == 1 and importers[0] == "plugin.gd",
		"and exactly one file loads it — plugin.gd, which only the editor ever runs (%s)"
			% ", ".join(importers)
	)


## Zero when every node given is a bare `Marker3D`; otherwise the number that are
## not. Takes a LIST rather than a container, because a `Markers` container may
## legitimately also hold the Ceremonial Arch, which is a model.
func _marker_container_is_bare(nodes: Array[Node]) -> int:
	var wrong: int = 0
	for child: Node in nodes:
		var marker: Marker3D = child as Marker3D
		if marker == null:
			wrong += 1
			continue
		if marker.get_child_count() > 0:
			wrong += 1
		if marker.get_script() != null:
			wrong += 1
		if not marker.get_meta_list().is_empty():
			wrong += 1
	return wrong


## Anything that could put a pixel on the screen, anywhere below `node`.
func _visual_nodes_under(node: Node) -> int:
	var found: int = 0
	var stack: Array[Node] = [node]
	while not stack.is_empty():
		var current: Node = stack.pop_back()
		if current is VisualInstance3D:
			found += 1
		for child: Node in current.get_children():
			stack.append(child)
	return found


func _bounds_of(lines: PackedVector3Array) -> AABB:
	if lines.is_empty():
		return AABB()
	var lo: Vector3 = lines[0]
	var hi: Vector3 = lines[0]
	for point: Vector3 in lines:
		lo = lo.min(point)
		hi = hi.max(point)
	return AABB(lo, hi - lo)


## Source with comment lines stripped, so a token quoted in a comment is never
## mistaken for the code doing it — the project's established scanning rule.
func _code_of(text: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in text.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


## Every `.gd` and `.cfg` the addon holds, read off the filesystem.
func _addon_scripts() -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open(ADDON_DIRECTORY)
	if dir == null:
		return out
	dir.list_dir_begin()
	var name: String = dir.get_next()
	while not name.is_empty():
		if not dir.current_is_dir() and (name.ends_with(".gd") or name.ends_with(".cfg")):
			out.append("%s/%s" % [ADDON_DIRECTORY, name])
		name = dir.get_next()
	dir.list_dir_end()
	var sorted: Array = Array(out)
	sorted.sort()
	return PackedStringArray(sorted)


func _fingerprint(path: String) -> String:
	if not FileAccess.file_exists(path):
		return ""
	return _sha(FileAccess.get_file_as_bytes(path))


# --- helpers ------------------------------------------------------------------

func _new_zone_root() -> Node3D:
	var root: Node3D = Node3D.new()
	root.name = "TestZone"
	return root


## Every owned node under `root`, as a sorted, comparable description: path,
## transform to four decimals, and the source model it came from. Two scenes with
## the same signature are the same scene as far as this tool can make one.
func _describe(root: Node3D) -> Dictionary:
	var lines: PackedStringArray = PackedStringArray()
	var count: int = 0
	var stack: Array[Node] = [root]
	while not stack.is_empty():
		var node: Node = stack.pop_back()
		count += 1
		var spatial: Node3D = node as Node3D
		var transform_text: String = ""
		if spatial != null:
			transform_text = "%.4f,%.4f,%.4f|%.4f|%.3f,%.3f,%.3f" % [
				spatial.position.x, spatial.position.y, spatial.position.z,
				spatial.rotation.y, spatial.scale.x, spatial.scale.y, spatial.scale.z,
			]
		# The ROOT's own `scene_file_path` is deliberately excluded: a scene that has
		# been saved knows its own filename and one that has not does not, and that
		# is the only difference a save/reopen round trip may produce. Measured:
		# with it included, 13 of 14 lines matched and the fourteenth differed by
		# exactly `user://…tscn`. Every child's path, transform and source model is
		# still compared, which is the thing being proved.
		var source: String = "" if node == root else String(node.scene_file_path)
		lines.append("%s %s %s" % [
			String(root.get_path_to(node)), transform_text, source
		])
		# Descendants of an instanced model are walked too. Their paths and
		# transforms join the comparison, which makes the signature stricter
		# rather than looser.
		for child: Node in node.get_children():
			stack.append(child)
	var sorted: Array = Array(lines)
	sorted.sort()
	return {"nodes": count, "signature": "\n".join(PackedStringArray(sorted))}


func _hash_sources() -> Dictionary:
	var hashes: Dictionary = {}
	for directory: String in SOURCE_DIRECTORIES:
		_hash_directory(directory, hashes)
	return hashes


func _hash_directory(directory: String, into: Dictionary) -> void:
	var dir: DirAccess = DirAccess.open(directory)
	if dir == null:
		return
	dir.list_dir_begin()
	var name: String = dir.get_next()
	while not name.is_empty():
		var path: String = "%s/%s" % [directory, name]
		if dir.current_is_dir():
			_hash_directory(path, into)
		elif not name.ends_with(".import"):
			var bytes: PackedByteArray = FileAccess.get_file_as_bytes(path)
			into[path] = "%d:%s" % [bytes.size(), _sha(bytes)]
		name = dir.get_next()
	dir.list_dir_end()


func _sha(bytes: PackedByteArray) -> String:
	var context: HashingContext = HashingContext.new()
	context.start(HashingContext.HASH_SHA256)
	context.update(bytes)
	return context.finish().hex_encode()


func _step(title: String) -> void:
	print("")
	print("--- %s" % title)


func _expect(condition: bool, description: String) -> void:
	_checks += 1
	if condition:
		print("  PASS  %s" % description)
	else:
		_failures += 1
		print("  FAIL  %s" % description)


## Every node in a subtree, root included. Used to prove an absence.
func _all_nodes(node: Node) -> Array[Node]:
	var out: Array[Node] = [node]
	for child: Node in node.get_children():
		out.append_array(_all_nodes(child))
	return out
