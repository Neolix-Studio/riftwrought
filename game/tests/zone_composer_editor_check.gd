@tool
extends Node
## Riftwrought Zone Composer — the IN-EDITOR half of the Phase 1 verification
## (D-210).
##
## WHY THIS EXISTS, AND IT IS THE SHARPEST LESSON OF THIS WORK.
##
## `zone_composer_verification.gd` drives the placement code with a plain
## `UndoRedo`, because `EditorUndoRedoManager` cannot be instantiated outside an
## editor. That leaves the branch the OWNER actually uses unproved — and the two
## classes are not interchangeable: `UndoRedo.add_do_method` takes a Callable
## while `EditorUndoRedoManager.add_do_method` takes an object, a method name and
## loose arguments. The first version of this tool assumed they were the same and
## every placement failed. A headless test that only exercised the other branch
## would have passed anyway.
##
## So this file runs INSIDE a real editor, against the real
## `EditorUndoRedoManager`, through the real `_forward_3d_gui_input` the mouse
## goes through — a synthesized click at a synthesized camera — and proves that a
## click places a piece, that "Undo Last Placement" removes it through Godot's own
## history, and that redo puts it back.
##
## It follows the project's established pattern: the shipping component dispatches
## a verification held under `tests/` when a user argument asks for it, exactly as
## `riftfall_landing_review.gd` dispatches `--verify-1c`.
##
## It is run by `game/tests/zone_composer_smoke.sh`:
##   godot --headless --editor --path game -- --verify-zone-composer

const Catalogue := preload("res://addons/riftwrought_zone_composer/zone_composer_catalogue.gd")
const Actions := preload("res://addons/riftwrought_zone_composer/zone_composer_actions.gd")
const Shapes := preload("res://addons/riftwrought_zone_composer/zone_composer_marker_shapes.gd")

## The zone the owner already composed. Opened READ-ONLY by the "reopen" mode to
## prove a saved zone gets its marker symbols back in a fresh editor session. It
## is never modified and the runner fingerprints it around the whole run.
const PRACTICE_ZONE_PATH: String = "res://scenes/first_mvp/zone_composer_practice.tscn"

## A throwaway scene the check writes, opens and deletes. It is the only file
## this check creates, and it never survives the run.
const SCRATCH_SCENE_PATH: String = "res://tests/zone_composer_editor_check_scene.tscn"

## Set by the plugin before this node enters the tree.
var composer: EditorPlugin
## "compose" — the full authoring pass in a scratch scene.
## "reopen"  — a second editor session that only opens an already-composed zone.
var mode: String = "compose"

var _checks: int = 0
var _failures: int = 0
## Every check function that ran to its LAST line. See `_finish()`.
var _completed: PackedStringArray = PackedStringArray()
var _viewport: SubViewport
var _camera: Camera3D


func _ready() -> void:
	_run.call_deferred()


func _run() -> void:
	print("")
	print("=== RIFTWROUGHT ZONE COMPOSER — IN-EDITOR CHECK (%s) ===" % mode)
	await _frames(4)

	if mode == "reopen":
		await _check_reopened_zone()
		_finish()
		return

	var root: Node3D = await _ensure_zone_scene()
	if root == null:
		_expect(false, "an edited 3D scene could be opened to compose into")
		_finish()
		return

	_build_camera()
	await _frames(2)

	_check_setup(root)
	await _check_click_places(root)
	await _check_undo_and_redo(root)
	await _check_turning_and_escape(root)
	_check_developer_spawn(root)
	await _check_marker_symbols(root)
	await _check_marker_preview(root)
	await _check_viewport_overlay()

	_finish()


# --- The scene ----------------------------------------------------------------

## MEASURED: a HEADLESS editor opens no scene tab at all, so
## `EditorInterface.add_root_node()` has nothing to add a root to and silently
## does nothing. The check therefore writes a throwaway scene and opens it the way
## the owner opens one — which is also a truer test, because the plugin only ever
## sees `get_edited_scene_root()`.
func _ensure_zone_scene() -> Node3D:
	# ALWAYS ITS OWN SCENE, NEVER WHATEVER THE EDITOR RESTORED.
	# This used to accept an already-open scene, and a headless editor restores the
	# last scene the OWNER had open — so the suite was composing walls, pillars and
	# markers into `zone_composer_practice.tscn`. Nothing was ever saved, so no file
	# changed, but a test that mutates the owner's work in memory is one edit away
	# from mutating it on disk. The runner now also fingerprints that file around
	# the whole run.
	var restored: Node3D = EditorInterface.get_edited_scene_root() as Node3D
	if restored != null:
		print("      the editor restored \"%s\" — leaving it alone and opening a scratch scene"
			% String(restored.name))
	var root: Node3D = Node3D.new()
	root.name = "ZoneComposerEditorCheck"
	var packed: PackedScene = PackedScene.new()
	if packed.pack(root) != OK or ResourceSaver.save(packed, SCRATCH_SCENE_PATH) != OK:
		root.free()
		print("      could not write the scratch scene")
		return null
	root.free()
	# A file written after the editor scanned the filesystem is not yet known to
	# it, and `open_scene_from_path` on an unknown path opens nothing. Rescan and
	# wait for it before asking.
	var filesystem: EditorFileSystem = EditorInterface.get_resource_filesystem()
	filesystem.scan()
	var waited: int = 0
	while filesystem.is_scanning() and waited < 600:
		await _frames(1)
		waited += 1
	await _frames(4)
	EditorInterface.open_scene_from_path(SCRATCH_SCENE_PATH)
	# Waiting for "a scene is open" would return instantly with the restored one
	# still current, which is exactly the mistake this function now exists to
	# avoid. Wait for OUR scene by its own path.
	waited = 0
	while waited < 600:
		var current: Node = EditorInterface.get_edited_scene_root()
		if current != null and String(current.scene_file_path) == SCRATCH_SCENE_PATH:
			break
		await _frames(1)
		waited += 1
	print("      scratch scene written, rescanned and opened after %d frames" % waited)
	var opened: Node3D = EditorInterface.get_edited_scene_root() as Node3D
	if opened == null or String(opened.scene_file_path) != SCRATCH_SCENE_PATH:
		print("      the scratch scene did not become the edited scene")
		return null
	return opened


## Removed on the way out, whether the check passed or failed. The smoke script
## removes it again defensively.
func _remove_scratch_scene() -> void:
	if mode != "compose" or not FileAccess.file_exists(SCRATCH_SCENE_PATH):
		return
	EditorInterface.close_scene()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(SCRATCH_SCENE_PATH))


## A camera 20 m up looking straight down, in its own viewport so the ray
## projection has a real size to work with. This is not the editor's camera — it
## stands in for it, and `_forward_3d_gui_input` cannot tell the difference,
## which is the point.
func _build_camera() -> void:
	_viewport = SubViewport.new()
	_viewport.size = Vector2i(800, 600)
	add_child(_viewport)
	_camera = Camera3D.new()
	_camera.fov = 45.0
	_camera.position = Vector3(0.0, 20.0, 0.0)
	_camera.rotation_degrees = Vector3(-90.0, 0.0, 0.0)
	_viewport.add_child(_camera)


func _centre() -> Vector2:
	return Vector2(_viewport.size) * 0.5


func _click_at(where: Vector2) -> int:
	var press: InputEventMouseButton = InputEventMouseButton.new()
	press.button_index = MOUSE_BUTTON_LEFT
	press.pressed = true
	press.position = where
	return composer._forward_3d_gui_input(_camera, press)


func _press_key(key: Key) -> int:
	var event: InputEventKey = InputEventKey.new()
	event.keycode = key
	event.physical_keycode = key
	event.pressed = true
	return composer._forward_3d_gui_input(_camera, event)


# --- The checks ---------------------------------------------------------------

func _check_setup(root: Node3D) -> void:
	_step("1. The dock sets a plain 3D scene up as a zone")
	_expect(composer != null, "the plugin handed this check a reference to itself")
	composer._on_setup_zone()
	var status: Dictionary = Actions.container_status(root)
	var missing: PackedStringArray = status["missing"]
	_expect(missing.is_empty(), "all six containers exist (%s)" % ", ".join(status["present"]))
	_expect(
		root.get_node_or_null(NodePath("Architecture")) != null
			and root.get_node_or_null(NodePath("Architecture")).owner == root,
		"and they belong to the scene, so Ctrl+S will save them"
	)
	_done("_check_setup")

func _check_click_places(root: Node3D) -> void:
	_step("2. A click on the ground places a piece — through the editor's own undo")
	composer._on_piece_chosen("dungeon:wall")
	await _frames(2)
	_expect(composer._mode == "placing", "choosing a piece enters placement mode")
	_expect(
		composer._preview != null and is_instance_valid(composer._preview),
		"a translucent preview exists while placing"
	)
	_expect(
		composer._preview.owner == null,
		"the preview has no owner, so it can never be saved into the zone"
	)

	var before: int = root.get_node("Architecture").get_child_count()
	var handled: int = _click_at(_centre())
	await _frames(2)
	_expect(
		handled == EditorPlugin.AFTER_GUI_INPUT_STOP,
		"the click is consumed rather than selecting something behind it"
	)
	var after: int = root.get_node("Architecture").get_child_count()
	_expect(after == before + 1, "one piece arrived under Architecture (%d → %d)" % [before, after])
	if after == before + 1:
		var placed: Node3D = root.get_node("Architecture").get_child(after - 1) as Node3D
		_expect(String(placed.name) == "TallStoneWall001", "named %s" % String(placed.name))
		_expect(placed.owner == root, "and it belongs to the scene")
		_expect(
			placed.scale.is_equal_approx(Vector3.ONE), "at the accepted scale"
		)
		_expect(
			absf(placed.position.x) < 0.001 and absf(placed.position.z) < 0.001,
			"under the cursor, at %s" % str(placed.position)
		)

	# A cursor aimed at the sky must place nothing at all.
	var sky_camera_pitch: float = _camera.rotation_degrees.x
	_camera.rotation_degrees = Vector3(20.0, 0.0, 0.0)
	var refused: int = _click_at(_centre())
	await _frames(2)
	_expect(
		refused == EditorPlugin.AFTER_GUI_INPUT_STOP,
		"a click with no ground under it is still consumed"
	)
	_expect(
		root.get_node("Architecture").get_child_count() == after,
		"but nothing is placed (%d, unchanged)" % root.get_node("Architecture").get_child_count()
	)
	_camera.rotation_degrees = Vector3(sky_camera_pitch, 0.0, 0.0)
	_done("_check_click_places")

func _check_undo_and_redo(root: Node3D) -> void:
	_step("3. \"Undo Last Placement\" walks Godot's real history")
	var architecture: Node = root.get_node("Architecture")
	var before: int = architecture.get_child_count()
	_expect(before > 0, "there is a placement to undo")
	_expect(composer._can_undo_placement(), "the dock's Undo button is enabled")

	composer._on_undo_last_placement()
	await _frames(2)
	_expect(
		architecture.get_child_count() == before - 1,
		"the piece is gone (%d → %d)" % [before, architecture.get_child_count()]
	)

	var history: UndoRedo = composer._placement_history()
	_expect(history != null, "the history is the editor's own UndoRedo for this scene")
	if history != null:
		_expect(history.has_redo(), "and it offers a redo")
		history.redo()
		await _frames(2)
		_expect(
			architecture.get_child_count() == before,
			"redo puts it back (%d)" % architecture.get_child_count()
		)
		var restored: Node3D = architecture.get_child(before - 1) as Node3D
		_expect(
			String(restored.name) == "TallStoneWall001" and restored.owner == root,
			"with its name and its ownership intact"
		)

	# And it refuses to undo something this tool did not do.
	var manual: Node3D = Node3D.new()
	manual.name = "SomethingTheOwnerDidByHand"
	if history != null:
		history.create_action("Add node")
		history.add_do_method(Callable(root, "add_child").bindv([manual]))
		history.add_do_reference(manual)
		history.add_undo_method(Callable(root, "remove_child").bindv([manual]))
		history.commit_action()
		await _frames(1)
		_expect(
			not composer._can_undo_placement(),
			"the dock's Undo button switches off when the last change was not a placement"
		)
		composer._on_undo_last_placement()
		await _frames(1)
		_expect(
			root.get_node_or_null(NodePath("SomethingTheOwnerDidByHand")) != null,
			"and pressing it leaves that change alone"
		)
		history.undo()
		await _frames(1)
	_done("_check_undo_and_redo")

func _check_turning_and_escape(root: Node3D) -> void:
	_step("4. Q, E and Esc do what the dock says they do")
	composer._on_piece_chosen("forest:Rock_1_A_Color1")
	await _frames(2)
	var facing: float = composer._facing
	var handled_e: int = _press_key(KEY_E)
	_expect(handled_e == EditorPlugin.AFTER_GUI_INPUT_STOP, "E is consumed while placing")
	_expect(
		absf(composer._facing - facing) > 0.001,
		"E turns the piece (%.0f° → %.0f°)" % [facing, composer._facing]
	)
	var turned: float = composer._facing
	_press_key(KEY_Q)
	_expect(
		absf(composer._facing - facing) < 0.001,
		"Q turns it back (%.0f° → %.0f°)" % [turned, composer._facing]
	)

	_press_key(KEY_ESCAPE)
	await _frames(2)
	_expect(composer._mode != "placing", "Esc leaves placement mode")
	_expect(
		root.get_node_or_null(NodePath(composer.PREVIEW_NODE_NAME)) == null,
		"and takes the preview with it"
	)
	var ignored: int = _press_key(KEY_E)
	_expect(
		ignored == EditorPlugin.AFTER_GUI_INPUT_PASS,
		"afterwards the 3D view is left entirely alone"
	)
	_done("_check_turning_and_escape")

func _check_developer_spawn(root: Node3D) -> void:
	_step("5. \"Play From Here\" moves only the developer marker")
	var undo_redo: EditorUndoRedoManager = EditorInterface.get_editor_undo_redo()
	Actions.place_piece(
		undo_redo, root, composer._catalogue,
		composer._catalogue.piece_for_key("marker_player_start"), Vector3(1.0, 0.0, 2.0), 0.0
	)
	var start: Marker3D = Actions.player_start(root)
	_expect(start != null, "the zone has a Player Start")
	if start == null:
		return
	var before: Transform3D = start.transform
	Actions.set_developer_spawn(undo_redo, root, Vector3(30.0, 0.0, -12.0))
	var spawn: Marker3D = root.get_node_or_null(
		NodePath("Markers/%s" % Catalogue.DEVELOPER_SPAWN_NODE_NAME)
	) as Marker3D
	_expect(spawn != null, "a separate developer test spawn is created")
	_expect(
		spawn != null and spawn.position.is_equal_approx(Vector3(30.0, 0.0, -12.0)),
		"it goes where the owner clicked"
	)
	_expect(start.transform == before, "and the real Player Start has not moved")


# --- Story marker symbols (D-211) ---------------------------------------------

## How many of `node`'s gizmos belong to THIS tool.
##
## COMPARED BY IDENTITY, and that is load-bearing twice over. A `Marker3D` always
## already carries Godot's own gizmo, so "the marker has a gizmo" is true before
## this correction exists and proves nothing. And reaching for
## `get_plugin().get_script()` throws on the built-in plugin, which would zero the
## whole count silently.
	_done("_check_developer_spawn")

## MEASURED AGAINST AN EXPLICIT PLUGIN, and that is what makes the disable test
## able to fail. Reading `composer.marker_gizmos()` inside here returns null the
## moment the tool is turned off, so the count would be 0 whether the symbols went
## away or not — a guard that answers "gone" without looking.
func _own_gizmos(node: Node3D, plugin: EditorNode3DGizmoPlugin = null) -> int:
	if plugin == null:
		plugin = composer.marker_gizmos()
	if plugin == null or node == null or not is_instance_valid(node):
		return 0
	var mine: int = 0
	for gizmo: Node3DGizmo in node.get_gizmos():
		var editor_gizmo: EditorNode3DGizmo = gizmo as EditorNode3DGizmo
		if editor_gizmo != null and editor_gizmo.get_plugin() == plugin:
			mine += 1
	return mine


## How many of `node`'s gizmos came from the plugin with this instance id. Takes an
## id rather than a reference so that asking the question cannot keep the answer
## alive — see the disable/re-enable block below.
func _gizmos_from_plugin_id(node: Node3D, plugin_id: int) -> int:
	if node == null or not is_instance_valid(node):
		return 0
	var mine: int = 0
	for gizmo: Node3DGizmo in node.get_gizmos():
		var editor_gizmo: EditorNode3DGizmo = gizmo as EditorNode3DGizmo
		if editor_gizmo == null:
			continue
		var plugin: EditorNode3DGizmoPlugin = editor_gizmo.get_plugin()
		if plugin != null and plugin.get_instance_id() == plugin_id:
			mine += 1
	return mine


func _place_marker(root: Node3D, key: String, at: Vector3, facing: float) -> Node3D:
	var result: Dictionary = Actions.place_piece(
		EditorInterface.get_editor_undo_redo(), root, composer._catalogue,
		composer._catalogue.piece_for_key(key), at, facing
	)
	return null if result.is_empty() else result["node"]


func _check_marker_symbols(root: Node3D) -> void:
	_step("6. Every placed story marker is drawn by this tool's own gizmo")
	_expect(composer.marker_gizmos() != null, "the marker gizmo plugin is registered")

	var markers: Array[Node3D] = []
	var facing: float = 0.0
	for key: String in Shapes.placeable_kinds():
		facing += 45.0
		var node: Node3D = _place_marker(root, key, Vector3(facing * 0.1, 0.0, 2.0), facing)
		if node != null:
			markers.append(node)
	_expect(markers.size() == 3, "all three story markers place (%d)" % markers.size())
	# A gizmo is requested from a deferred group call when the node enters the
	# world, so it is never there in the same frame the node arrived in.
	await _frames(3)

	var drawn: int = 0
	var segments: PackedStringArray = PackedStringArray()
	for node: Node3D in markers:
		if _own_gizmos(node) == 1:
			drawn += 1
		var count: int = int(composer.marker_gizmos().last_segment_count.get(String(node.name), 0))
		segments.append("%s %d" % [String(node.name), count])
	_expect(drawn == 3, "each carries exactly one of this tool's gizmos (%d of 3)" % drawn)
	_expect(
		int(composer.marker_gizmos().redraws.size()) >= 3,
		"and each was actually redrawn — %s" % ", ".join(segments)
	)
	var distinct: Dictionary = {}
	for entry: String in segments:
		distinct[entry.split(" ")[1]] = true
	_expect(
		distinct.size() == 3,
		"with three different symbols, not three copies of one (%d distinct segment counts)"
			% distinct.size()
	)

	# Undo takes the symbol with the marker, and redo brings both back — which is
	# the whole of "the representation is removed and restored", because the
	# representation belongs to the node and to nothing else.
	var undo_target: Node3D = markers[markers.size() - 1]
	var undo_name: String = String(undo_target.name)
	var history: UndoRedo = composer._placement_history()
	_expect(history != null, "the editor's own history is available")
	history.undo()
	await _frames(3)
	_expect(
		root.get_node("Markers").get_node_or_null(NodePath(undo_name)) == null,
		"undo removes the marker, and its symbol goes with it (%s)" % undo_name
	)
	history.redo()
	await _frames(3)
	var restored: Node3D = root.get_node("Markers").get_node_or_null(NodePath(undo_name)) as Node3D
	_expect(restored != null, "redo puts the marker back")
	_expect(
		restored != null and _own_gizmos(restored) == 1,
		"and its symbol is drawn again, without anything asking for it"
	)

	# The developer test spawn is drawn too, and it is the fourth symbol.
	Actions.set_developer_spawn(
		EditorInterface.get_editor_undo_redo(), root, Vector3(6.0, 0.0, 6.0)
	)
	await _frames(3)
	var spawn: Node3D = root.get_node_or_null(
		NodePath("Markers/%s" % Catalogue.DEVELOPER_SPAWN_NODE_NAME)
	) as Node3D
	_expect(spawn != null and _own_gizmos(spawn) == 1, "the developer test spawn is drawn as well")

	# An ordinary node is left completely alone.
	var stranger: Marker3D = Marker3D.new()
	stranger.name = "SomeOtherPoint"
	root.get_node("Markers").add_child(stranger)
	stranger.owner = root
	await _frames(3)
	_expect(
		_own_gizmos(stranger) == 0,
		"a Marker3D this tool did not place is not decorated by it"
	)
	root.get_node("Markers").remove_child(stranger)
	stranger.free()

	# Disabling and re-enabling the tool. `_unregister_marker_gizmos` and
	# `_register_marker_gizmos` are exactly what `_exit_tree` and `_enter_tree`
	# call, so this is the disable/enable path itself rather than an imitation.
	# THE PLUGIN'S INSTANCE ID, NOT THE PLUGIN. Measured, and it is the whole
	# subtlety of this test: `remove_node_3d_gizmo_plugin()` does not detach a
	# gizmo that is already drawn — dropping the LAST reference to the plugin
	# resource is what does, and that is exactly what `_unregister_marker_gizmos()`
	# achieves by nulling its own field. So a check that keeps a reference in order
	# to compare identity keeps the symbols alive and then reports that they did not
	# go away. Holding only the integer id compares identity without owning
	# anything. (The earlier version dodged this by reading the plugin back through
	# the composer, which is null by then — so it answered "gone" without looking.)
	var registered_id: int = composer.marker_gizmos().get_instance_id()
	var totals_before: Array[int] = []
	for node: Node3D in markers:
		totals_before.append(node.get_gizmos().size())
	composer._unregister_marker_gizmos()
	await _frames(3)
	var still_drawn: int = 0
	var lost_exactly_one: int = 0
	for i: int in markers.size():
		var node: Node3D = markers[i]
		if not is_instance_valid(node):
			continue
		if _gizmos_from_plugin_id(node, registered_id) > 0:
			still_drawn += 1
		if node.get_gizmos().size() == totals_before[i] - 1:
			lost_exactly_one += 1
	_expect(
		composer.marker_gizmos() == null and still_drawn == 0,
		"turning the tool off takes every symbol away (%d left)" % still_drawn
	)
	_expect(
		lost_exactly_one == markers.size(),
		"each marker lost exactly one gizmo — this tool's — and no more (%d of %d)"
			% [lost_exactly_one, markers.size()]
	)
	var built_in_survives: int = 0
	for node: Node3D in markers:
		if is_instance_valid(node) and node.get_gizmos().size() > 0:
			built_in_survives += 1
	_expect(
		built_in_survives == markers.size(),
		"while Godot's own marker gizmo is untouched (%d of %d)"
			% [built_in_survives, markers.size()]
	)
	composer._register_marker_gizmos()
	await _frames(3)
	var back: int = 0
	var totals_restored: int = 0
	for i: int in markers.size():
		var node: Node3D = markers[i]
		if not is_instance_valid(node):
			continue
		if _own_gizmos(node) == 1:
			back += 1
		if node.get_gizmos().size() == totals_before[i]:
			totals_restored += 1
	_expect(
		back == markers.size(),
		"turning it back on rebuilds every one of them (%d of %d)" % [back, markers.size()]
	)
	_expect(
		totals_restored == markers.size(),
		"with the same number of gizmos it started with, so nothing stacked up (%d of %d)"
			% [totals_restored, markers.size()]
	)

	# A rename is the one change Godot never redraws a gizmo for, and this tool's
	# markers are identified by name.
	var renamed_target: Node3D = markers[0]
	var original: String = String(renamed_target.name)
	renamed_target.name = "NotAMarkerAnyMore"
	await _frames(4)
	_expect(
		int(composer.marker_gizmos().last_segment_count.get("NotAMarkerAnyMore", -1)) == -1
			and _own_gizmos(renamed_target) == 0,
		"renaming a marker away from its name takes its symbol away"
	)
	renamed_target.name = original
	await _frames(4)
	_expect(
		_own_gizmos(renamed_target) == 1,
		"and renaming it back brings the symbol back (%s)" % original
	)
	_done("_check_marker_symbols")

func _check_marker_preview(root: Node3D) -> void:
	_step("7. The translucent marker preview shows the right symbol before the click")
	for key: String in Shapes.placeable_kinds():
		composer._on_piece_chosen(key)
		await _frames(2)
		var preview: Node3D = composer._preview
		_expect(
			preview != null and is_instance_valid(preview),
			"choosing \"%s\" builds a preview" % Shapes.display_for(key)
		)
		if preview == null:
			continue
		var mesh_node: MeshInstance3D = preview.get_child(0) as MeshInstance3D
		_expect(mesh_node != null, "  which is drawn geometry, not an empty node")
		if mesh_node == null:
			continue
		var vertices: PackedVector3Array = (
			mesh_node.mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
		)
		_expect(
			vertices == Shapes.lines_for(key),
			"  built from exactly the symbol the placed marker gets (%d points)" % vertices.size()
		)
		var material: StandardMaterial3D = mesh_node.material_override as StandardMaterial3D
		_expect(
			material != null and material.albedo_color.g > material.albedo_color.r,
			"  and tinted green while the ground is under the cursor"
		)

	# Q and E must move the arrow the instant they are pressed, not on the click.
	composer._on_piece_chosen("marker_exit")
	await _frames(2)
	var before: float = composer._preview.rotation.y
	_press_key(KEY_E)
	await _frames(1)
	_expect(
		absf(composer._preview.rotation.y - before) > 0.001,
		"E turns the preview symbol immediately (%.1f° → %.1f°)"
			% [rad_to_deg(before), rad_to_deg(composer._preview.rotation.y)]
	)
	_press_key(KEY_Q)
	await _frames(1)
	_expect(
		absf(composer._preview.rotation.y - before) < 0.001,
		"and Q turns it straight back"
	)

	# Red when there is no ground: the same distinction the model preview makes.
	var pitch: float = _camera.rotation_degrees.x
	_camera.rotation_degrees = Vector3(20.0, 0.0, 0.0)
	var motion: InputEventMouseMotion = InputEventMouseMotion.new()
	motion.position = _centre()
	composer._forward_3d_gui_input(_camera, motion)
	await _frames(1)
	var sky_material: StandardMaterial3D = (
		composer._preview.get_child(0) as MeshInstance3D
	).material_override as StandardMaterial3D
	_expect(
		sky_material != null and sky_material.albedo_color.r > sky_material.albedo_color.g,
		"aiming at the sky turns the marker preview red, exactly as a model preview goes red"
	)
	_camera.rotation_degrees = Vector3(pitch, 0.0, 0.0)
	_press_key(KEY_ESCAPE)
	await _frames(2)

	# A SCENE CHANGE WHILE PLACING MUST TAKE THE PREVIEW WITH IT. `scene_changed`
	# also fires on an ordinary tab switch, where the scene being left is still
	# alive — so forgetting the preview instead of freeing it would leave a green
	# symbol standing in a tab the owner comes back to. This drives the handler the
	# editor itself calls.
	composer._on_piece_chosen("marker_focus")
	await _frames(2)
	_expect(
		root.get_node_or_null(NodePath(composer.PREVIEW_NODE_NAME)) != null,
		"a preview is standing in the scene while placing"
	)
	composer._on_scene_changed(root)
	await _frames(2)
	_expect(
		root.get_node_or_null(NodePath(composer.PREVIEW_NODE_NAME)) == null,
		"and changing scenes removes it rather than leaving it behind"
	)
	_done("_check_marker_preview")

func _check_viewport_overlay() -> void:
	_step("8. The viewport caption and the selected marker's name really draw")
	# MEASURED, AND IT IS WHY THIS CHECK EXISTS: `_forward_3d_draw_over_viewport`
	# never fires for a plugin without `_handles()`, so Phase 1's placement caption
	# had never once been drawn and nothing failed. The callback is now the FORCE
	# variant. Driving it through a real `Control` is the only way to prove the
	# drawing code runs at all — a headless editor has no 3D viewport to look at,
	# so what is proved here is that the callback executes and puts text on a
	# canvas, not what that canvas looks like.
	_expect(
		composer.has_method("_forward_3d_force_draw_over_viewport"),
		"the plugin overrides the callback that does not need _handles()"
	)
	_expect(
		not composer.has_method("_handles"),
		"and it does not claim to handle every Node3D in order to get one"
	)
	# DRIVEN FROM A REAL DRAW CONTEXT, not by calling the method directly. Godot
	# refuses `draw_string` outside one, so calling the callback by hand would
	# either error or prove nothing about the path the editor takes. A `Control`'s
	# own `draw` signal is a real draw context, and the counter is what turns "it
	# was called" into a measurement.
	# AND THE COUNTER IS THE PLUGIN'S, NOT THIS FILE'S. Counting how many times the
	# callback was invoked proves it is dispatched; it does not prove anything
	# reached the canvas, which is exactly the state Phase 1 was in. `label_draws`
	# and `marker_name_draws` are incremented inside `_draw_label`, past the
	# empty-text guard, so they count strings that actually went to `draw_string`.
	var passes: Array[int] = [0]
	var probe: Control = Control.new()
	probe.size = Vector2(800, 600)
	probe.draw.connect(func() -> void:
		composer._forward_3d_force_draw_over_viewport(probe)
		passes[0] += 1
	)
	add_child(probe)
	probe.queue_redraw()
	await _frames(3)
	_expect(passes[0] > 0, "a real draw pass reaches the plugin's overlay (%d)" % passes[0])

	# The GREEN caption branch, which is the one that had never been seen: a piece
	# chosen and the cursor on real ground.
	composer._on_piece_chosen("marker_player_start")
	await _frames(2)
	var motion: InputEventMouseMotion = InputEventMouseMotion.new()
	motion.position = _centre()
	composer._forward_3d_gui_input(_camera, motion)
	await _frames(1)
	var captions_before: int = composer.label_draws
	probe.queue_redraw()
	await _frames(3)
	_expect(
		composer.label_draws > captions_before,
		"the placement caption really reaches the canvas (%d strings drawn)" % composer.label_draws
	)
	_expect(
		composer.last_label_text.contains("Player Start")
			and composer.last_label_text.contains("facing"),
		"and it says what is being placed and which way: \"%s\"" % composer.last_label_text
	)
	composer._on_exit_placement()
	await _frames(1)

	var selection: EditorSelection = EditorInterface.get_selection()
	var root: Node3D = EditorInterface.get_edited_scene_root() as Node3D
	var marker: Node = root.get_node_or_null(NodePath("Markers/WayOut"))
	_expect(marker != null, "there is a Way Out marker to select")
	if marker != null:
		var names_before: int = composer.marker_name_draws
		selection.clear()
		await _frames(1)
		probe.queue_redraw()
		await _frames(2)
		_expect(
			composer.marker_name_draws == names_before,
			"with nothing selected, no marker name is drawn (%d)" % composer.marker_name_draws
		)
		selection.add_node(marker)
		await _frames(2)
		probe.queue_redraw()
		await _frames(3)
		_expect(
			composer.marker_name_draws > names_before,
			"selecting a marker draws its name (%d)" % composer.marker_name_draws
		)
		_expect(
			composer.last_label_text == "Way Out",
			"in the palette's own wording: \"%s\"" % composer.last_label_text
		)
		selection.clear()
		await _frames(1)
	probe.queue_free()
	await _frames(1)
	_done("_check_viewport_overlay")

func _check_reopened_zone() -> void:
	_step("1. A zone saved earlier gets its marker symbols back in a fresh editor")
	EditorInterface.open_scene_from_path(PRACTICE_ZONE_PATH)
	var waited: int = 0
	while waited < 600:
		var current: Node = EditorInterface.get_edited_scene_root()
		if current != null and String(current.scene_file_path) == PRACTICE_ZONE_PATH:
			break
		await _frames(1)
		waited += 1
	var root: Node3D = EditorInterface.get_edited_scene_root() as Node3D
	# THE PATH IS ASSERTED FIRST, on purpose. A boot that opened the wrong scene
	# would find no markers at all, and "no marker lacks a symbol" is true of an
	# empty list.
	_expect(
		root != null and String(root.scene_file_path) == PRACTICE_ZONE_PATH,
		"the owner's own composed zone is the scene that opened (%d frames)" % waited
	)
	if root == null or String(root.scene_file_path) != PRACTICE_ZONE_PATH:
		return
	await _frames(4)
	var markers: Node = root.get_node_or_null(NodePath("Markers"))
	_expect(markers != null, "it has a Markers container")
	if markers == null:
		return
	var claimed: PackedStringArray = PackedStringArray()
	for child: Node in markers.get_children():
		if not Shapes.kind_for_node(child).is_empty():
			claimed.append(String(child.name))
	# NOT A PINNED COUNT. The owner's zone is a living file: they will add and
	# remove markers, and a suite that fails for that reason is the very defect
	# this correction had to repair twice elsewhere. What is owed is that it holds
	# markers at all — which closes the "no marker lacks a symbol is true of an
	# empty list" hole — and that every one of them is drawn.
	_expect(
		claimed.size() > 0,
		"holding %d marker(s) the owner placed: %s" % [claimed.size(), ", ".join(claimed)]
	)
	var drawn: int = 0
	for child: Node in markers.get_children():
		var marker: Node3D = child as Node3D
		if marker != null and not Shapes.kind_for_node(marker).is_empty() \
				and _own_gizmos(marker) == 1:
			drawn += 1
	_expect(
		drawn == claimed.size() and drawn > 0,
		"and every one of them is drawn, with nothing added to the file (%d of %d)"
			% [drawn, claimed.size()]
	)
	# Reopening must not have made the scene look modified.
	_expect(
		not EditorInterface.get_unsaved_scenes().has(PRACTICE_ZONE_PATH),
		"opening it left it unmodified, so nothing could be saved over it"
	)


# --- plumbing -----------------------------------------------------------------
	_done("_check_reopened_zone")

func _frames(count: int) -> void:
	for i: int in count:
		await get_tree().process_frame


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


## A CHECK FUNCTION THAT SILENTLY STOPS RUNNING IS THE ONE FAILURE A PASSING
## COUNT CANNOT SEE, and it happened here: `_check_viewport_overlay()` was called
## without `await`, so `_run()` reached `_finish()` while it was still suspended on
## its first frame wait and five of its seven assertions never ran. The suite
## reported PASS. Every check function now records that it reached its last line,
## and the set is compared here, in both directions.
func _done(name: String) -> void:
	if not _completed.has(name):
		_completed.append(name)


const COMPOSE_SECTIONS: Array[String] = [
	"_check_setup", "_check_click_places", "_check_undo_and_redo",
	"_check_turning_and_escape", "_check_developer_spawn", "_check_marker_symbols",
	"_check_marker_preview", "_check_viewport_overlay",
]
const REOPEN_SECTIONS: Array[String] = ["_check_reopened_zone"]


func _finish() -> void:
	var owed: Array[String] = REOPEN_SECTIONS if mode == "reopen" else COMPOSE_SECTIONS
	var unfinished: PackedStringArray = PackedStringArray()
	for name: String in owed:
		if not _completed.has(name):
			unfinished.append(name)
	var unexpected: PackedStringArray = PackedStringArray()
	for name: String in _completed:
		if not owed.has(name):
			unexpected.append(name)
	_expect(
		unfinished.is_empty(),
		"every check this mode owes ran to its last line (%d of %d)%s" % [
			_completed.size(), owed.size(),
			"" if unfinished.is_empty() else " — missing " + ", ".join(unfinished),
		]
	)
	_expect(
		unexpected.is_empty(),
		"and no check ran that this mode does not owe (%s)" % ", ".join(unexpected)
	)
	_remove_scratch_scene()
	print("")
	if _failures == 0:
		print("ZONE COMPOSER %s CHECK: PASS (%d checks)" % [mode.to_upper(), _checks])
	else:
		print("ZONE COMPOSER %s CHECK: FAIL (%d of %d checks failed)" % [
			mode.to_upper(), _failures, _checks])
	print("")
	get_tree().quit(0 if _failures == 0 else 1)
