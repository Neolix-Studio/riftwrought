extends SceneTree
## First-MVP UI J1 — Shared Modal Left-Click Activation V1: automated verification (decision
## D-322).
##
## THE ONE QUESTION: does every real button in every direct `FirstMvpModal` descendant answer an
## actual left press and release over it, while the backdrop, the right button and gameplay input
## stay blocked?
##
## FIVE ACCEPTED SCENES, LOADED AS THEY SHIP AND GIVEN NO FLAG OF THEIR OWN: the core loop (the
## item comparison, the run summary, the roguelite Fallen), the canonical opening on isolated
## storage (Gate 1D's Fallen, the Origin Ring, the first conversation, the Foundation Cache), the
## replayability review (the boon choice), the build-variety review (the upgrade choice — UI
## evidence only; D-223 stays OPEN) and the I2 review (the level-up offer). Each panel is opened by
## its own runtime's path.
##
## EVERY CLICK IS A REAL POINTER EVENT OVER THE REAL BUTTON: a motion, a left press and a left
## release, in WINDOW coordinates, so the stretch transform maps them. Most are pushed into the root
## window; the clicks that close a modal for the click-through proof go through
## `Input.parse_input_event()`, the path the operating system's own events take, so the Input
## singleton's action state is truthful. Nothing here emits `pressed`, calls a panel callback or
## reads an accessor added for it. Each click watches every button in its panel: it must produce
## exactly one `pressed`, on the button under the pointer.
##
## STAGED, AND STATED WHERE IT HAPPENS: enemies are quieted, placed and killed through
## `receive_damage()`; the player is placed and, twice, killed the same way; the run summary is
## reopened three times through its own `open_for()`; the I2 route toggles pickup with F8 exactly
## as I2's own suite does. Simulated input is not physical-device certification.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. The headless run and both rendered runs pin one count.
##
## Run: godot --headless --path game --script res://tests/first_mvp_modal_left_click_verification.gd -- --seed 99 --state-dir <empty dir>

const THIS_FILE: String = "res://tests/first_mvp_modal_left_click_verification.gd"
const MODAL_SCRIPT: String = "res://scripts/ui/first_mvp_modal.gd"
const PANEL_SCRIPT: String = "res://scripts/roguelite/level_up/rift_level_up_offer_panel.gd"
const FALLEN_SCRIPT: String = "res://scripts/ui/first_mvp_fallen_overlay.gd"

const CORE_LOOP_SCENE: String = "res://scenes/roguelite/roguelite_core_loop.tscn"
const OPENING_SCENE: String = "res://scenes/first_mvp/canonical_opening/canonical_opening.tscn"
const REPLAY_SCENE: String = "res://scenes/roguelite/roguelite_replayability_review.tscn"
const VARIETY_SCENE: String = "res://scenes/roguelite/roguelite_build_variety_review.tscn"
const LEVEL_UP_SCENE: String = "res://scenes/roguelite/roguelite_level_up_choice_review.tscn"

const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31
const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]

## The two production files J1 changed, at their D-322 SHA-256 prefixes.
const D322_HASHES: Array = [
	["res://scripts/ui/first_mvp_modal.gd", "1cfe9c73"],
	["res://scripts/roguelite/level_up/rift_level_up_offer_panel.gd", "694eb0b2"],
]

## Everything this work stands beside, at the prefix it held before the first J1 edit: the other
## eight descendants, the three indirect subclasses, Gate E's modal, eight modal-owning runtimes,
## the input-family tracker, the mouse-hold kernel, the player, eight scenes and project.godot.
const UNCHANGED_HASHES: Array = [
	["res://scripts/ui/first_mvp_fallen_overlay.gd", "de5e1ab0"],
	["res://scripts/ui/first_mvp_item_comparison.gd", "3607f9f7"],
	["res://scripts/ui/foundation_cache_panel.gd", "6d845d38"],
	["res://scripts/ui/nexus_dialogue_panel.gd", "7c6d384e"],
	["res://scripts/ui/origin_ring_panel.gd", "c3896263"],
	["res://scripts/roguelite/replayability/roguelite_boon_choice_panel.gd", "f1500d85"],
	["res://scripts/roguelite/roguelite_run_summary_panel.gd", "ea1d4c9c"],
	["res://scripts/roguelite/build_variety/roguelite_upgrade_choice_panel.gd", "2ee98c50"],
	["res://scripts/roguelite/roguelite_fallen_overlay.gd", "1753e7b7"],
	["res://scripts/roguelite/replayability/roguelite_replayability_summary_panel.gd", "97e83d04"],
	["res://scripts/roguelite/build_variety/roguelite_build_variety_summary_panel.gd", "17f06529"],
	["res://scripts/ui/gate_e_modal.gd", "d01d29ca"],
	## First-MVP UI J3 (D-326) moved Gate 1D's slice one for one, from `e6bbb174`, so that a restart
	## cancels a Fallen that is armed but not yet open. Same count.
	## First-MVP UI J4 (D-328) moved it again, from `b35e04a6`, so that a character that is not alive
	## cannot open the item comparison. Same count.
	## First-MVP UI J5 (D-330) moved it again, from `c204a087`, so that a fallen character's ground drop
	## loses its controller highlight. Same count.
	## First-MVP Gameplay J9 (D-338) moved it again, from `f83e9436`, so that its guaranteed drop counts
	## the Graveblade that died rather than the attacker. Same count.
	## First-MVP Gameplay J10 (D-340) moved it again, from `942aee83`, so that a restart leaves the character
	## standing at Broken Watch's entry. Same count.
	## First-MVP Gameplay J11 (D-344) moved it again, from `883ef25e`, so that Riftfall Landing's Watch Breach
	## far cap no longer seals the composed route into Broken Watch. Same count.
	["res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd", "d4e839fb"],
	["res://scripts/roguelite/roguelite_core_loop_runtime.gd", "a76cec3d"],
	["res://scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd", "601e5901"],
	["res://scripts/roguelite/replayability/roguelite_replayability_runtime.gd", "ef236cec"],
	["res://scripts/roguelite/build_variety/roguelite_build_variety_runtime.gd", "e9abb336"],
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", "128103b4"],
	["res://scripts/roguelite/experience/roguelite_experience_collection_review.gd", "150509d5"],
	["res://scripts/roguelite/live_effects/roguelite_live_effect_review.gd", "75cb02b9"],
	["res://scripts/input/input_family_tracker.gd", "8b721355"],
	["res://scripts/movement/prototype_mouse_hold.gd", "089e8dd5"],
	## First-MVP UI J2 (D-324) moved the player one for one, from `a6d93721`, so that neutralizing a
	## fallen character's controls keeps it FALLEN. Same count.
	["res://scripts/actors/prototype_player.gd", "80e38838"],
	["res://scenes/roguelite/roguelite_core_loop.tscn", "6bdf5388"],
	["res://scenes/first_mvp/canonical_opening/canonical_opening.tscn", "b1d9f2e4"],
	["res://scenes/roguelite/roguelite_replayability_review.tscn", "c8c9ec68"],
	["res://scenes/roguelite/roguelite_build_variety_review.tscn", "32b4beff"],
	["res://scenes/roguelite/roguelite_level_up_choice_review.tscn", "7038bce6"],
	["res://scenes/roguelite/roguelite_live_effect_review.tscn", "0c3c6c98"],
	["res://scenes/roguelite/roguelite_experience_collection_review.tscn", "123cfeb2"],
	["res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn", "e9d16993"],
	["res://project.godot", "55351038"],
]

## The nine direct descendants of the contract, by class, and the three classes beneath them.
const DIRECT_DESCENDANTS: Dictionary = {
	"FirstMvpFallenOverlay": "res://scripts/ui/first_mvp_fallen_overlay.gd",
	"FirstMvpItemComparison": "res://scripts/ui/first_mvp_item_comparison.gd",
	"FoundationCachePanel": "res://scripts/ui/foundation_cache_panel.gd",
	"NexusDialoguePanel": "res://scripts/ui/nexus_dialogue_panel.gd",
	"OriginRingPanel": "res://scripts/ui/origin_ring_panel.gd",
	"RiftLevelUpOfferPanel": "res://scripts/roguelite/level_up/rift_level_up_offer_panel.gd",
	"RogueliteBoonChoicePanel": "res://scripts/roguelite/replayability/roguelite_boon_choice_panel.gd",
	"RogueliteRunSummaryPanel": "res://scripts/roguelite/roguelite_run_summary_panel.gd",
	"RogueliteUpgradeChoicePanel": "res://scripts/roguelite/build_variety/roguelite_upgrade_choice_panel.gd",
}
const INDIRECT_DESCENDANTS: Dictionary = {
	"RogueliteBuildVarietySummaryPanel": "RogueliteReplayabilitySummaryPanel",
	"RogueliteFallenOverlay": "FirstMvpFallenOverlay",
	"RogueliteReplayabilitySummaryPanel": "RogueliteRunSummaryPanel",
}

## The contract's `_input()`, line for line with comments and indentation removed: the accepted
## body, and three lines that offer a left press to the GUI before the old `move_point` block.
const EXPECTED_INPUT_LINES: Array[String] = [
	"if not is_open:", "return",
	"for action: StringName in _armed.keys():",
	"if not bool(_armed[action]) and event.is_action_released(action):", "_armed[action] = true",
	"if event.is_action_pressed(&\"ui_cancel\"):", "get_viewport().set_input_as_handled()",
	"if not _consume(&\"ui_cancel\"):", "return", "if cancel_closes():", "close(\"cancelled\")", "return",
	"if event.is_action_pressed(&\"ui_confirm\") or event.is_action_pressed(&\"interact\"):",
	"var action: StringName = &\"ui_confirm\" if event.is_action_pressed(&\"ui_confirm\") else &\"interact\"",
	"get_viewport().set_input_as_handled()", "if not _consume(action):", "return", "activate_focused()", "return",
	"var click: InputEventMouseButton = event as InputEventMouseButton",
	"if click != null and click.button_index == MOUSE_BUTTON_LEFT and click.pressed:", "return",
	"if event.is_action_pressed(&\"quick_strike\") or event.is_action_pressed(&\"move_point\"):",
	"get_viewport().set_input_as_handled()",
]
const PASS_THROUGH: String = "click.button_index == MOUSE_BUTTON_LEFT and click.pressed"

## The contract's functions, unchanged in name and order by J1.
const MODAL_FUNCTIONS: Array[String] = [
	"_ready", "bind_room", "build_contents", "refresh_contents", "default_focus", "cancel_closes",
	"modal_name", "open", "close", "_input", "activate_focused", "_consume", "inputs_are_armed",
	"_on_family_changed", "register_glyph", "refresh_glyphs", "glyph_for", "_build_backdrop",
	"make_panel", "make_title", "make_line", "make_rule", "make_button",
]
## The I2 panel's functions after J1: D-293's delivery and I3's note setter, without `_input`.
const PANEL_FUNCTIONS: Array[String] = [
	"modal_name", "cancel_closes", "default_focus", "bind_room", "build_contents", "_build_card",
	"open_for_offer", "refresh_contents", "show_refusal", "set_note_text", "_on_card_pressed",
	"_set_button_caption", "card_count", "card_buttons", "lane_for_slot", "card_lines", "card_block",
	"refusal_text", "note_text", "text_controls",
]
## Running files that name the left mouse button in code: the contract, and three that are not modals.
const LEFT_BUTTON_NAMERS: Array[String] = [
	"res://addons/riftwrought_zone_composer/plugin.gd",
	"res://scripts/first_mvp/calibration/gate_1a_verification.gd",
	"res://scripts/tools/gate_c_verification.gd",
	"res://scripts/ui/first_mvp_modal.gd",
]
## Hand-routing a pointer: none may appear in the contract or in any descendant.
const HIT_TEST_TOKENS: Array[String] = [
	"gui_get_hovered_control", "has_point(", "get_local_mouse_position", "get_mouse_position",
	".pressed.emit(", "gui_find",
]
const POINTER_TOKENS: Array[String] = ["MOUSE_BUTTON", "InputEventMouse", "func _gui_input(",
	"func _unhandled_input(", "func _shortcut_input("]

const OWED_CHECKS: Array[String] = [
	"the_production_scope_is_exactly_the_two_authorized_files",
	"first_mvp_modal_is_the_one_shared_owner",
	"the_base_offers_only_an_open_modals_left_press_to_the_gui",
	"nothing_hit_tests_or_emits_pressed_by_hand",
	"the_level_up_panel_carries_no_override_or_counter",
	"the_direct_descendant_inventory_is_exactly_nine",
	"no_descendant_carries_a_second_pointer_route",
	"the_input_map_project_and_scenes_are_unchanged",
	"the_viewport_is_the_one_requested",
	"the_item_comparison_closes_and_equips_by_real_clicks",
	"the_run_summary_closes_by_a_real_click_reversing_d293",
	"the_roguelite_fallen_overlay_returns_to_the_nexus_by_a_real_click",
	"the_gate_1d_fallen_overlay_restarts_by_a_real_click",
	"held_inputs_at_opening_still_cannot_act",
	"the_origin_ring_selects_allocates_refunds_and_closes_by_real_clicks",
	"the_dialogue_continues_skips_and_closes_by_real_clicks",
	"the_foundation_cache_selects_and_confirms_by_real_clicks",
	"the_boon_choice_grants_only_the_clicked_boon",
	"the_upgrade_choice_takes_only_the_clicked_slot",
	"the_level_up_card_takes_its_own_lane_through_the_accepted_transaction",
	"hover_alone_commits_nothing",
	"backdrop_and_panel_left_clicks_commit_nothing",
	"right_clicks_commit_nothing",
	"keyboard_confirmation_is_unchanged",
	"controller_confirmation_is_unchanged",
	"cancel_is_unchanged_for_closable_and_mandatory_panels",
	"no_click_through_after_a_closing_button",
	"the_world_stays_paused_while_a_modal_stands",
	"focus_and_glyphs_are_unchanged",
	"every_state_change_happens_exactly_once",
]

## The nine panels, by the label every record below is keyed on.
const PANEL_LABELS: Array[String] = [
	"comparison", "summary", "roguelite fallen", "gate 1d fallen", "origin ring", "dialogue",
	"foundation cache", "boon", "upgrade", "level-up",
]

var arguments: PackedStringArray = PackedStringArray()
var loop: RogueliteCoreLoopRuntime
var opening: CanonicalOpeningRuntime
var replay: RogueliteReplayabilityRuntime
var variety: RogueliteBuildVarietyRuntime
var levels: RogueliteLevelUpChoiceReview

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _state_dir: String = ""
var _next_use_id: int = 322000
var _staged: PackedStringArray = PackedStringArray()

## Per-panel readings, asserted together by the cross-cutting checks.
var _hover: Dictionary = {}
var _backdrop: Dictionary = {}
var _right: Dictionary = {}
var _paused_reading: Dictionary = {}
var _focus: Dictionary = {}
var _cancel: Dictionary = {}
var _keyboard: Dictionary = {}
var _controller: Dictionary = {}
var _through: Dictionary = {}
var _clicks: Array[Dictionary] = []

## Buttons being watched and how often each emitted `pressed`.
var _fired: Dictionary = {}
var _watched: Array[Dictionary] = []


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	_state_dir = _argument_value("--state-dir")
	print("")
	print("=== First-MVP UI J1 — Shared Modal Left-Click Activation V1 verification (D-322) ===")

	_check_the_production_scope_is_exactly_the_two_authorized_files()
	_check_first_mvp_modal_is_the_one_shared_owner()
	_check_the_base_offers_only_an_open_modals_left_press_to_the_gui()
	_check_nothing_hit_tests_or_emits_pressed_by_hand()
	_check_the_level_up_panel_carries_no_override_or_counter()
	_check_the_direct_descendant_inventory_is_exactly_nine()
	_check_no_descendant_carries_a_second_pointer_route()
	_check_the_input_map_project_and_scenes_are_unchanged()
	_check_the_viewport_is_the_one_requested()

	await _core_loop_phase()
	await _opening_phase()
	await _replayability_phase()
	await _build_variety_phase()
	await _level_up_phase()

	_check_hover_alone_commits_nothing()
	_check_backdrop_and_panel_left_clicks_commit_nothing()
	_check_right_clicks_commit_nothing()
	_check_keyboard_confirmation_is_unchanged()
	_check_controller_confirmation_is_unchanged()
	_check_cancel_is_unchanged_for_closable_and_mandatory_panels()
	_check_no_click_through_after_a_closing_button()
	_check_the_world_stays_paused_while_a_modal_stands()
	_check_focus_and_glyphs_are_unchanged()
	_check_every_state_change_happens_exactly_once()

	_check_every_check_ran()

	print("")
	print("  staged: %s" % "; ".join(_staged))
	if _failures.is_empty():
		print("FIRST-MVP MODAL LEFT CLICK VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("FIRST-MVP MODAL LEFT CLICK VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		quit(1)


## Changes to an accepted scene exactly as it ships and waits until it stands.
func _load(path: String) -> Node:
	if paused:
		_failures.append("the tree was still paused before %s loaded" % path.get_file())
		return null
	var changed: Error = change_scene_to_packed(load(path) as PackedScene)
	for frame: int in 60:
		await process_frame
		if current_scene != null and current_scene.scene_file_path == path:
			break
	if changed != OK or current_scene == null or current_scene.scene_file_path != path:
		_failures.append("%s did not load" % path.get_file())
		return null
	return current_scene


func _await_navigation(room: BrokenWatchSlice) -> void:
	for frame: int in 900:
		if NavigationServer3D.map_get_iteration_id(room.navigation_map()) > 0:
			break
		await physics_frame
	await _settle(10)

# --- 1–9. Structure, scope and the inventory -----------------------------------------------

func _check_the_production_scope_is_exactly_the_two_authorized_files() -> void:
	print("")
	print("--- 1. Exactly two production files moved — the modal contract and the I2 panel — and every file they stand beside is byte-identical")
	var changed: PackedStringArray = PackedStringArray()
	for row: Array in D322_HASHES:
		var digest: String = FileAccess.get_sha256(String(row[0]))
		if not digest.begins_with(String(row[1])):
			changed.append("%s %s" % [String(row[0]).get_file(), digest.substr(0, 8)])
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in UNCHANGED_HASHES:
		var digest: String = FileAccess.get_sha256(String(row[0]))
		if not digest.begins_with(String(row[1])):
			moved.append("%s %s" % [String(row[0]).get_file(), digest.substr(0, 8)])
	_expect(changed.is_empty(), "the two J1 files are not at their D-322 hashes: %s" % ", ".join(changed))
	_expect(moved.is_empty() and UNCHANGED_HASHES.size() == 32, "moved: %s" % ", ".join(moved))
	print("  the contract is at its D-322 hash 1cfe9c73 and the I2 panel at 694eb0b2; %d files — the other eight descendants, the three indirect subclasses, Gate E's modal, eight modal-owning runtimes, the input-family tracker, the mouse-hold kernel, the player, eight scenes and project.godot — hold the hashes they held before the first J1 edit, but for the player, which J2 moved (D-324), and Gate 1D's slice, which J3, J4 and J5 moved (D-326, D-328, D-330)"
		% UNCHANGED_HASHES.size())
	_done("the_production_scope_is_exactly_the_two_authorized_files")


func _check_first_mvp_modal_is_the_one_shared_owner() -> void:
	print("")
	print("--- 2. FirstMvpModal is the one owner: the pass-through exists once in the project, in the contract")
	var namers: PackedStringArray = PackedStringArray()
	var carriers: PackedStringArray = PackedStringArray()
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd"]):
			var code: String = _uncommented(FileAccess.get_file_as_string(path))
			if code.contains("MOUSE_BUTTON_LEFT"):
				namers.append(path)
			for count: int in code.count(PASS_THROUGH):
				carriers.append(path)
	namers.sort()
	var modal_code: String = _uncommented(FileAccess.get_file_as_string(MODAL_SCRIPT))
	_expect(carriers == PackedStringArray([MODAL_SCRIPT]) and namers == PackedStringArray(LEFT_BUTTON_NAMERS)
			and modal_code.count("MOUSE_BUTTON_LEFT") == 1,
		"the pass-through is carried by %s; MOUSE_BUTTON_LEFT is named by %s" % [", ".join(carriers), ", ".join(namers)])
	var raw: String = FileAccess.get_file_as_string(MODAL_SCRIPT)
	_expect(raw.contains("A LEFT\n## PRESS REACHES THE GUI (First-MVP UI J1, decision D-322)")
			and raw.contains("Nothing here\n## finds, names or presses a button."),
		"the contract's header does not state the J1 rule")
	print("  the pass-through is written once, in first_mvp_modal.gd; the only other running files naming MOUSE_BUTTON_LEFT in code are two in-engine verification tools and the Zone Composer plugin, none of them a modal; the header states the rule and names D-322")
	_done("first_mvp_modal_is_the_one_shared_owner")


func _check_the_base_offers_only_an_open_modals_left_press_to_the_gui() -> void:
	print("")
	print("--- 3. The contract's _input() is the accepted body plus three lines, and those lines let only an open modal's left press through")
	var source: String = FileAccess.get_file_as_string(MODAL_SCRIPT)
	var lines: PackedStringArray = _code_lines(_function_body(source, "_input"))
	_expect(lines == PackedStringArray(EXPECTED_INPUT_LINES),
		"the contract's _input() reads:\n%s" % "\n".join(lines))
	var declared: PackedStringArray = _declared_functions(source)
	_expect(declared == PackedStringArray(MODAL_FUNCTIONS) and _declared_fields(source).size() == 10
			and source.count("\nconst ") == 8 and source.count("\nsignal ") == 2,
		"the contract declares %s and %d fields" % [", ".join(declared), _declared_fields(source).size()])
	print("  %d code lines: the open guard first, the release re-arming, cancel and confirm unchanged, then `var click …`, `if %s:`, `return`, then the accepted quick_strike / move_point block; 23 functions, 10 fields, 8 constants and 2 signals, none added"
		% [lines.size(), PASS_THROUGH])
	_done("the_base_offers_only_an_open_modals_left_press_to_the_gui")


func _check_nothing_hit_tests_or_emits_pressed_by_hand() -> void:
	print("")
	print("--- 4. Nothing hit-tests the pointer or emits pressed by hand; the one emit is the accepted keyboard/controller confirm")
	var source: String = FileAccess.get_file_as_string(MODAL_SCRIPT)
	var code: String = _uncommented(source)
	var input_body: String = _uncommented(_function_body(source, "_input"))
	var found: PackedStringArray = PackedStringArray()
	for path: String in [MODAL_SCRIPT] + _descendant_paths():
		var scanned: String = _uncommented(FileAccess.get_file_as_string(path))
		for token: String in HIT_TEST_TOKENS:
			if scanned.contains(token):
				found.append("%s names %s" % [path.get_file(), token])
		if path != MODAL_SCRIPT and scanned.contains("emit_signal(\"pressed\")"):
			found.append("%s emits pressed" % path.get_file())
	_expect(found.is_empty(), "%s" % ", ".join(found))
	_expect(code.count("emit_signal(\"pressed\")") == 1
			and _function_body(source, "activate_focused").contains("button.emit_signal(\"pressed\")")
			and code.count("\tactivate_focused()") == 1 and input_body.count("activate_focused()") == 1
			and input_body.find("activate_focused()") < input_body.find("var click"),
		"the contract emits pressed other than through the accepted confirm branch")
	print("  0 of %d hit-test tokens in the contract and the %d descendants; `emit_signal(\"pressed\")` appears once, in activate_focused(), called only from the ui_confirm / interact branch above the pointer lines"
		% [HIT_TEST_TOKENS.size(), _descendant_paths().size()])
	_done("nothing_hit_tests_or_emits_pressed_by_hand")


func _check_the_level_up_panel_carries_no_override_or_counter() -> void:
	print("")
	print("--- 5. The I2 panel's own left-press override and its counter are gone, and its header says the routing is inherited")
	var source: String = FileAccess.get_file_as_string(PANEL_SCRIPT)
	var code: String = _uncommented(source)
	var declared: PackedStringArray = _declared_functions(source)
	var fields: PackedStringArray = _declared_fields(source)
	_expect(not code.contains("func _input(") and not code.contains("left_presses_passed")
			and not code.contains("InputEventMouse") and not code.contains("MOUSE_BUTTON")
			and declared == PackedStringArray(PANEL_FUNCTIONS) and fields.size() == 11 and not fields.has("left_presses_passed"),
		"the panel declares %s and fields %s" % [", ".join(declared), ", ".join(fields)])
	var namers: PackedStringArray = PackedStringArray()
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd", ".tscn", ".tres"]):
			if FileAccess.get_file_as_string(path).contains("left_presses_passed"):
				namers.append(path)
	_expect(namers.is_empty() and source.contains("A LEFT CLICK REACHES THE CARD UNDER THE POINTER, AND THAT IS INHERITED.")
			and source.contains("(First-MVP UI J1, decision D-322)") and not source.contains("NEEDED ONE OVERRIDE"),
		"left_presses_passed is still named by %s, or the header was not rewritten" % ", ".join(namers))
	print("  no _input, no counter, no mouse token; 20 functions and 11 fields where there were 21 and 12; no running file names left_presses_passed; the header reads 'A LEFT CLICK REACHES THE CARD UNDER THE POINTER, AND THAT IS INHERITED.'")
	_done("the_level_up_panel_carries_no_override_or_counter")


func _check_the_direct_descendant_inventory_is_exactly_nine() -> void:
	print("")
	print("--- 6. The contract has exactly nine direct descendants, and three classes beneath them")
	var direct: Dictionary = {}
	var classes: Dictionary = {}
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		classes[String(entry["class"])] = entry
		if String(entry.get("base", "")) == "FirstMvpModal":
			direct[String(entry["class"])] = String(entry["path"])
	## Beneath the nine at any depth: a class whose base is one of them, or one of these.
	var indirect: Dictionary = {}
	for depth: int in 4:
		for name: String in classes.keys():
			var base: String = String((classes[name] as Dictionary).get("base", ""))
			if direct.has(base) or indirect.has(base):
				indirect[name] = base
	var extends_lines: PackedStringArray = PackedStringArray()
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd"]):
			if FileAccess.get_file_as_string(path).contains("\nextends FirstMvpModal\n"):
				extends_lines.append(path)
	extends_lines.sort()
	var expected_paths: PackedStringArray = PackedStringArray(DIRECT_DESCENDANTS.values())
	expected_paths.sort()
	_expect(direct == DIRECT_DESCENDANTS and indirect == INDIRECT_DESCENDANTS and extends_lines == expected_paths,
		"direct %s; indirect %s; files extending the contract %s" % [str(direct.keys()), str(indirect), ", ".join(extends_lines)])
	var names: PackedStringArray = PackedStringArray(direct.keys())
	names.sort()
	print("  direct: %s; beneath them: RogueliteFallenOverlay, RogueliteReplayabilitySummaryPanel, RogueliteBuildVarietySummaryPanel"
		% ", ".join(names))
	_done("the_direct_descendant_inventory_is_exactly_nine")


func _check_no_descendant_carries_a_second_pointer_route() -> void:
	print("")
	print("--- 7. No descendant routes the pointer; Gate 1D's Fallen keeps its F5 _input(), which calls the contract's")
	var found: PackedStringArray = PackedStringArray()
	var overriders: PackedStringArray = PackedStringArray()
	for path: String in _descendant_paths():
		var source: String = FileAccess.get_file_as_string(path)
		var code: String = _uncommented(source)
		for token: String in POINTER_TOKENS:
			if code.contains(token):
				found.append("%s names %s" % [path.get_file(), token])
		if _declared_functions(source).has("_input"):
			overriders.append(path.get_file())
	var fallen: String = _uncommented(_function_body(FileAccess.get_file_as_string(FALLEN_SCRIPT), "_input"))
	_expect(found.is_empty() and overriders == PackedStringArray(["first_mvp_fallen_overlay.gd"])
			and fallen.contains("quick_restart") and fallen.contains("super(event)") and not fallen.contains("MOUSE"),
		"%s; _input() is declared by %s" % [", ".join(found), ", ".join(overriders)])
	print("  0 of %d pointer tokens in the %d descendant scripts; one _input() among them, first_mvp_fallen_overlay.gd's, which answers quick_restart and hands every other event to the contract"
		% [POINTER_TOKENS.size(), _descendant_paths().size()])
	_done("no_descendant_carries_a_second_pointer_route")


func _check_the_input_map_project_and_scenes_are_unchanged() -> void:
	print("")
	print("--- 8. The InputMap, the entrypoint and project.godot are untouched; the eight scenes hold their pre-J1 hashes (check 1)")
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	var left_events: int = 0
	for event: InputEvent in InputMap.action_get_events(&"move_point"):
		var click: InputEventMouseButton = event as InputEventMouseButton
		if click != null and click.button_index == MOUSE_BUTTON_LEFT:
			left_events += 1
	_expect(actions == EXPECTED_ACTIONS and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT
			and not settings.contains("[autoload]") and not settings.contains("left_click")
			and InputMap.action_get_events(&"move_point").size() == 1 and left_events == 1,
		"%d actions, or project.godot moved, or move_point is not the left button alone" % actions)
	print("  %d actions; move_point is the left mouse button alone; the entrypoint is %s; project.godot declares no [autoload] and names nothing of J1"
		% [actions, ENTRYPOINT.get_file()])
	_done("the_input_map_project_and_scenes_are_unchanged")


func _check_the_viewport_is_the_one_requested() -> void:
	print("")
	print("--- 9. The viewport: every click is placed in window coordinates through the real stretch transform")
	var expected: String = _argument_value("--expect-window")
	var size: Vector2i = root.size
	var visible_rect: Rect2 = root.get_visible_rect()
	var scale: float = root.get_final_transform().get_scale().x
	if expected.is_empty():
		_expect(DisplayServer.get_name() == "headless", "no --expect-window was given to a %s run" % DisplayServer.get_name())
	else:
		_expect("%dx%d" % [size.x, size.y] == expected and visible_rect.size.x == 1920.0 and visible_rect.size.y == 1080.0,
			"the window is %s showing %s, not %s" % [str(size), str(visible_rect.size), expected])
	print("  display %s, window %dx%d, visible %dx%d, stretch x%.4f" % [DisplayServer.get_name(), size.x, size.y,
		int(visible_rect.size.x), int(visible_rect.size.y), scale])
	_done("the_viewport_is_the_one_requested")

# --- 10–12. The core loop: the item comparison, the run summary, the roguelite Fallen --------

func _core_loop_phase() -> void:
	loop = await _load(CORE_LOOP_SCENE) as RogueliteCoreLoopRuntime
	if loop == null:
		return
	await _await_navigation(loop)
	await _walk_into_gate(loop, loop.hub_module.exit_point())
	await _clear_room(loop, 0)
	await _walk_into_gate(loop, loop.room_modules[0].exit_point())
	await _clear_room(loop, 1)
	await _check_the_item_comparison_closes_and_equips_by_real_clicks()
	await _walk_into_gate(loop, loop.room_modules[1].exit_point())
	await _clear_room(loop, 2)
	await _walk_into_gate(loop, loop.room_modules[2].exit_point())
	await _check_the_run_summary_closes_by_a_real_click_reversing_d293()
	await _walk_into_gate(loop, loop.hub_module.exit_point())
	await _check_the_roguelite_fallen_overlay_returns_to_the_nexus_by_a_real_click()


func _core_open() -> bool:
	return loop.item_comparison.is_open or loop.fallen_overlay.is_open or loop.summary_panel.is_open


func _check_the_item_comparison_closes_and_equips_by_real_clicks() -> void:
	print("")
	print("--- 10. The item comparison: Close leaves the item on the ground and Equip takes it, each by one real click")
	var panel: FirstMvpItemComparison = loop.item_comparison
	var drop: FirstMvpItemDrop = loop.get_node_or_null("Actors/GuaranteedRunReward") as FirstMvpItemDrop
	_expect(drop != null, "the Cache Room laid no guaranteed reward")
	if drop == null:
		return
	var blade: PrototypeWeaponData = drop.weapon
	_stand(loop, drop.global_position)
	await _settle(3)
	await _key(KEY_ENTER)
	if not _opened("comparison", panel, "Enter beside the reward"):
		return
	var reader: Callable = func() -> Dictionary:
		return {"open": panel.is_open, "closes": panel.closes, "equipped": loop.loadout.equipped_weapon,
			"owned": loop.loadout.owned_items.size(), "drop": is_instance_valid(drop)}
	await _standing_probes("comparison", panel, loop, reader, _named(panel, "Close"), &"ui_cancel",
		_named(panel, "Equip"), false)
	## Close, through the operating system's path: the click-through proof for this panel.
	var closes: int = panel.closes
	var at: Vector3 = loop.player.global_position
	var uses: int = loop.player.attack.uses_started
	var close: Dictionary = await _parse_click(panel, _named(panel, "Close"))
	var closed: bool = (_one_press(close) and not panel.is_open and panel.closes == closes + 1
		and is_instance_valid(drop) and loop.loadout.equipped_weapon != blade and not loop.loadout.is_owned(blade))
	_through["comparison"] = await _after_close(loop, _core_open, at, uses)
	## Reopened by the keyboard's interact beside the item, then cancel.
	await _key(KEY_ENTER)
	var reopened: bool = panel.is_open
	closes = panel.closes
	await _key(KEY_ESCAPE)
	_cancel["comparison"] = reopened and not panel.is_open and panel.closes == closes + 1 and is_instance_valid(drop)
	await _key(KEY_ENTER)
	if not _opened("comparison", panel, "Enter a third time"):
		return
	var owned: int = loop.loadout.owned_items.size()
	closes = panel.closes
	var equip: Dictionary = _click(panel, _named(panel, "Equip"))
	var equipped: bool = (loop.loadout.equipped_weapon == blade and loop.player.weapon == blade
		and loop.run_state.reward_equipped and not panel.is_open and panel.closes == closes + 1
		and loop.loadout.owned_items.size() == owned + 1)
	await _await_process_frames(2)
	_expect(closed, "Close by a click: %s; open %s, closes %d, drop %s" % [str(close), str(panel.is_open),
		panel.closes, str(is_instance_valid(drop))])
	_expect(bool(equip["under"]) and _one_press(equip) and equipped and not is_instance_valid(drop),
		"Equip by a click: %s; equipped %s" % [str(equip), str(equipped)])
	_record("comparison", "Close", close)
	_record("comparison", "Equip", equip)
	print("  Close by one click: one pressed, the panel closed once, the %s still on the ground and not owned; Escape closed it again; Equip by one click: one pressed, picked up and equipped (owned %d -> %d), the run's reward marked equipped, the ground item gone"
		% [blade.display_name, owned, loop.loadout.owned_items.size()])
	_done("the_item_comparison_closes_and_equips_by_real_clicks")


func _check_the_run_summary_closes_by_a_real_click_reversing_d293() -> void:
	print("")
	print("--- 11. The run summary: the case D-293 measured broken — the pointer on \"Back to the Nexus\", a left press and a release — now closes it, once")
	var panel: RogueliteRunSummaryPanel = loop.summary_panel
	if not _opened("summary", panel, "walking out of the Elite Hall"):
		return
	var button: Button = _named(panel, "Back to the Nexus")
	var reader: Callable = func() -> Dictionary:
		return {"open": panel.is_open, "closes": panel.closes, "state": loop.loop_state, "runs": loop.runs_started}
	await _standing_probes("summary", panel, loop, reader, button, &"ui_confirm", button, false)
	var closes: int = panel.closes
	var at: Vector3 = loop.player.global_position
	var uses: int = loop.player.attack.uses_started
	var click: Dictionary = await _parse_click(panel, button)
	var closed: bool = (_one_press(click) and not panel.is_open and panel.closes == closes + 1
		and loop.loop_state == RogueliteCoreLoopRuntime.LoopState.RUN_COMPLETE)
	_through["summary"] = await _after_close(loop, _core_open, at, uses)
	## STAGED: the panel is reopened through its own open_for(), four times.
	loop.summary_panel.open_for(loop.run_state)
	await _await_process_frames(2)
	closes = panel.closes
	var pushed: Dictionary = _click(panel, button)
	var pushed_closed: bool = not panel.is_open and panel.closes == closes + 1
	await _await_process_frames(2)
	loop.summary_panel.open_for(loop.run_state)
	await _await_process_frames(2)
	closes = panel.closes
	await _key(KEY_ESCAPE)
	_cancel["summary"] = not panel.is_open and panel.closes == closes + 1
	loop.summary_panel.open_for(loop.run_state)
	await _await_process_frames(2)
	closes = panel.closes
	await _joy(JOY_BUTTON_A)
	_controller["summary"] = not panel.is_open and panel.closes == closes + 1
	loop.summary_panel.open_for(loop.run_state)
	await _await_process_frames(2)
	closes = panel.closes
	await _key(KEY_ENTER)
	_keyboard["summary"] = not panel.is_open and panel.closes == closes + 1
	_staged.append("the run summary reopened 4 times through its own open_for()")
	_expect(closed, "the left click on \"Back to the Nexus\": %s; open %s" % [str(click), str(panel.is_open)])
	_expect(bool(pushed["under"]) and _one_press(pushed) and pushed_closed, "the pushed click: %s" % str(pushed))
	_record("summary", "Back to the Nexus", click)
	_record("summary", "Back to the Nexus (pushed)", pushed)
	print("  one left press and release over \"Back to the Nexus\": one pressed, the summary closed once and the run stayed complete in the Nexus — where D-293 measured closes = 0; reopened, the same click in the same call closed it once more")
	_done("the_run_summary_closes_by_a_real_click_reversing_d293")


func _check_the_roguelite_fallen_overlay_returns_to_the_nexus_by_a_real_click() -> void:
	print("")
	print("--- 12. The roguelite Fallen: \"Return to the Nexus\" ends the run once, by one real click; cancel cannot close it")
	var panel: FirstMvpFallenOverlay = loop.fallen_overlay
	var enemy: PrototypeGraveblade = loop.room_enemies[0][0]
	var run_index: int = loop.plan.run_index
	var ended: int = _log_count(loop, "run ended")
	loop.player.receive_damage(DamageEvent.physical(_use(), enemy, loop.player, loop.player.life + 1000.0))
	_staged.append("the core loop's player killed once through receive_damage()")
	await _wait_for(func() -> bool: return panel.is_open, 5.0)
	if not _opened("roguelite fallen", panel, "the player falling in the Teaching Hall"):
		return
	var button: Button = _named(panel, "Return to the Nexus")
	var reader: Callable = func() -> Dictionary:
		return {"open": panel.is_open, "closes": panel.closes, "ended": _log_count(loop, "run ended"),
			"alive": loop.player.is_alive()}
	await _standing_probes("roguelite fallen", panel, loop, reader, button, &"ui_confirm", button, true)
	var closes: int = panel.closes
	var click: Dictionary = _click(panel, button)
	var returned: bool = (not panel.is_open and panel.closes == closes + 1 and _log_count(loop, "run ended") == ended + 1
		and loop.plan.run_index == run_index + 1 and loop.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB
		and loop.player.is_alive())
	await _await_process_frames(2)
	_expect(bool(click["under"]) and _one_press(click) and returned,
		"the click on \"Return to the Nexus\": %s; returned %s" % [str(click), str(returned)])
	_record("roguelite fallen", "Return to the Nexus", click)
	print("  one left press and release over \"Return to the Nexus\": one pressed, the overlay closed once, exactly one run ended (run index %d -> %d) and the character stands alive in the Nexus"
		% [run_index, loop.plan.run_index])
	_done("the_roguelite_fallen_overlay_returns_to_the_nexus_by_a_real_click")


# --- The standing-modal probes, shared by every panel -------------------------------------------

## Everything a standing modal owes before anything is chosen, recorded under `label`: the safe
## control focused, wearing the live family's glyph; the world paused; the pointer over every button
## choosing nothing; left clicks on the backdrop and on the panel's own body choosing nothing; a right
## click on `target` choosing nothing; and, where the panel must be answered, Esc and (B) leaving it
## open. A panel whose own hover PREVIEW is accepted keeps it: `reader` holds only committed state.
func _standing_probes(label: String, panel: FirstMvpModal, room: BrokenWatchSlice, reader: Callable,
		safe: Button, action: StringName, target: Button, mandatory: bool) -> void:
	var controller: bool = room.input_family.family == InputFamilyTracker.Family.CONTROLLER
	var glyph: Label = _glyph_of(safe)
	_focus[label] = (root.gui_get_focus_owner() == safe and panel.default_focus() == safe and glyph != null
		and glyph.text == FirstMvpModal.glyph_for(action, controller) and not glyph.text.is_empty())
	var at: Vector3 = room.player.global_position
	var uses: int = room.player.attack.uses_started
	var physics: int = Engine.get_physics_frames()
	await _settle(10)
	_paused_reading[label] = (paused and panel.is_open and room.player.global_position == at
		and room.player.attack.uses_started == uses and Engine.get_physics_frames() >= physics + 10)
	var before: Dictionary = reader.call()
	_watch(panel)
	var swept: int = 0
	for node: Node in panel.find_children("*", "Button", true, false):
		var button: Button = node as Button
		if not button.is_visible_in_tree():
			continue
		_push_motion(button.get_global_rect().get_center())
		await _await_process_frames(1)
		swept += 1
	_push_motion(Vector2(8.0, 8.0))
	await _await_process_frames(1)
	_hover[label] = [swept, _total_fired() == 0 and reader.call() == before and swept >= 1]
	var dim: Control = panel.get_node("Dim") as Control
	var body: Control = panel.get_node("Panel") as Control
	var destination: bool = room.player.has_destination
	var on_dim: Control = _click_at(Vector2(40.0, 40.0), MOUSE_BUTTON_LEFT)
	await _await_process_frames(1)
	var on_body: Control = _click_at(body.get_global_rect().position + Vector2(6.0, 6.0), MOUSE_BUTTON_LEFT)
	await _await_process_frames(1)
	_backdrop[label] = (on_dim == dim and on_body == body and _total_fired() == 0 and reader.call() == before
		and panel.is_open and room.player.has_destination == destination)
	var on_target: Control = _click_at(target.get_global_rect().get_center(), MOUSE_BUTTON_RIGHT)
	await _await_process_frames(1)
	_right[label] = (on_target == target and _total_fired() == 0 and reader.call() == before and panel.is_open
		and room.player.attack.uses_started == uses)
	if mandatory:
		await _key(KEY_ESCAPE)
		await _joy(JOY_BUTTON_B)
		_cancel[label] = panel.is_open and paused and _total_fired() == 0 and reader.call() == before
	_unwatch()
	if not (bool(_focus[label]) and bool(_paused_reading[label]) and bool((_hover[label] as Array)[1])
			and bool(_backdrop[label]) and bool(_right[label])):
		print("  %s standing probes: focus %s (%s), paused %s, hover %s, backdrop %s / body %s, right %s" % [label,
			str(_focus[label]), str(root.gui_get_focus_owner()), str(_paused_reading[label]), str(_hover[label]),
			str(on_dim), str(on_body), str(on_target)])


## After a click that closed a modal: the world runs again and nothing of that click reaches it —
## no destination, no attack, no movement, no modal, and the button no longer held.
func _after_close(room: BrokenWatchSlice, open_any: Callable, at: Vector3, uses: int) -> bool:
	await _settle(20)
	await _await_process_frames(5)
	return (not paused and not room.player.has_destination and room.player.attack.uses_started == uses
		and room.player.global_position.distance_to(at) < 0.05 and not bool(open_any.call())
		and not Input.is_action_pressed(&"move_point"))

# --- 13–17. The canonical opening, on isolated storage -------------------------------------------

func _opening_phase() -> void:
	_expect(not _state_dir.is_empty(), "no --state-dir was given; the canonical opening is never loaded without isolated storage")
	if _state_dir.is_empty():
		return
	opening = await _load(OPENING_SCENE) as CanonicalOpeningRuntime
	if opening == null:
		return
	await _await_navigation(opening)
	await _check_the_gate_1d_fallen_overlay_restarts_by_a_real_click()
	await _reach_the_anchor()
	await _check_held_inputs_at_opening_still_cannot_act()
	await _check_the_origin_ring_selects_allocates_refunds_and_closes_by_real_clicks()
	await _check_the_dialogue_continues_skips_and_closes_by_real_clicks()
	await _check_the_foundation_cache_selects_and_confirms_by_real_clicks()


func _check_the_gate_1d_fallen_overlay_restarts_by_a_real_click() -> void:
	print("")
	print("--- 13. Gate 1D's own Fallen, in the canonical opening on isolated storage: Restart by one real click restarts once; cancel cannot close it")
	var save: CharacterSave = opening.character_save
	var isolated: String = ProjectSettings.globalize_path(_state_dir).simplify_path()
	_expect(not save.uses_production_storage()
			and ProjectSettings.globalize_path(save.storage_path).simplify_path().begins_with(isolated),
		"the opening's character file is %s, not inside %s" % [save.storage_path, _state_dir])
	var panel: FirstMvpFallenOverlay = opening.fallen_overlay
	var enemy: PrototypeGraveblade = opening.graveblades[0]
	var restarts: int = _log_count(opening, "slice restarted")
	opening.player.receive_damage(DamageEvent.physical(_use(), enemy, opening.player, opening.player.life + 1000.0))
	_staged.append("the opening's player killed once at Riftfall Landing through receive_damage()")
	await _wait_for(func() -> bool: return panel.is_open, 5.0)
	if not _opened("gate 1d fallen", panel, "the player falling at Riftfall Landing"):
		return
	var button: Button = _named(panel, "Restart Broken Watch")
	var reader: Callable = func() -> Dictionary:
		return {"open": panel.is_open, "closes": panel.closes, "restarts": _log_count(opening, "slice restarted"),
			"alive": opening.player.is_alive()}
	await _standing_probes("gate 1d fallen", panel, opening, reader, button, &"ui_confirm", button, true)
	var closes: int = panel.closes
	var click: Dictionary = _click(panel, button)
	var restarted: bool = (not panel.is_open and panel.closes == closes + 1
		and _log_count(opening, "slice restarted") == restarts + 1 and opening.player.is_alive())
	await _await_process_frames(2)
	_expect((panel.get_script() as GDScript).resource_path == FALLEN_SCRIPT and bool(click["under"])
			and _one_press(click) and restarted,
		"the click on \"Restart Broken Watch\": %s; restarted %s" % [str(click), str(restarted)])
	_record("gate 1d fallen", "Restart Broken Watch", click)
	print("  the character file lies inside the run's own state directory; one left press and release over \"Restart Broken Watch\": one pressed, the overlay closed once, one restart through restart_current_slice(), the character alive")
	_done("the_gate_1d_fallen_overlay_restarts_by_a_real_click")


## STAGED: the character is placed at the Nexus arrival and then beside the central Anchor, which
## recognizes the Mark on its own and grants the first Passive point (D-219).
func _reach_the_anchor() -> void:
	_stand(opening, opening.rift_nexus.arrival())
	await _settle(4)
	_stand(opening, _anchor_spot())
	await _wait_for(func() -> bool: return opening.character.milestone_passive_point_claimed, 12.0)
	await _settle(4)
	_staged.append("the opening's character placed at the Nexus arrival and 4 m from the Anchor, which recognized the Mark itself")


## Four metres from the Anchor — inside its recognition radius — on the navigation mesh, and clear
## of Mara, the Foundation Cache and the equipment station, so (A) there answers the Anchor alone.
func _anchor_spot() -> Vector3:
	var nexus: RiftNexusLayout = opening.rift_nexus
	var anchor: Vector3 = nexus.anchor_point()
	var toward: Vector3 = nexus.arrival() - anchor
	toward.y = 0.0
	toward = toward.normalized()
	for step: int in 8:
		var spot: Vector3 = anchor + toward.rotated(Vector3.UP, float(step) * PI / 4.0) * 4.0
		var clear: bool = true
		for station: Vector3 in [nexus.mara_station(), nexus.foundation_cache(), nexus.equipment_station()]:
			if Vector2(spot.x - station.x, spot.z - station.z).length() < CanonicalOpeningRuntime.INTERACTION_RANGE + 0.5:
				clear = false
		var resolved: Vector3 = NavigationServer3D.map_get_closest_point(opening.navigation_map(), spot)
		if clear and Vector2(resolved.x - spot.x, resolved.z - spot.z).length() < 0.3:
			return Vector3(spot.x, anchor.y, spot.z)
	return anchor + toward * 4.0


func _check_held_inputs_at_opening_still_cannot_act() -> void:
	print("")
	print("--- 14. A control already held when a modal opens cannot act on it: a held left button must first be released, a held (A) is refused; a fresh press then acts once")
	var panel: OriginRingPanel = opening.origin_ring_panel
	var close: Button = _named(panel, "Close")
	## The left button, held over the world before F1 opens the Ring.
	_parse_mouse(root.get_visible_rect().size * 0.5, MOUSE_BUTTON_LEFT, true)
	await _await_process_frames(2)
	var held: bool = Input.is_action_pressed(&"move_point")
	await _key(KEY_F1)
	var opened_held: bool = panel.is_open and not panel.inputs_are_armed()
	var closes: int = panel.closes
	_watch(panel)
	_parse_motion(close.get_global_rect().get_center())
	_parse_mouse(close.get_global_rect().get_center(), MOUSE_BUTTON_LEFT, false)
	await _await_process_frames(2)
	var released: bool = (panel.is_open and panel.closes == closes and _total_fired() == 0 and panel.inputs_are_armed()
		and not Input.is_action_pressed(&"move_point"))
	_unwatch()
	var fresh: Dictionary = _click(panel, close)
	var fresh_closed: bool = not panel.is_open and panel.closes == closes + 1
	await _settle(10)
	var still: bool = not opening.player.has_destination
	## (A), held when it opens the Ring from beside the Anchor.
	var refused: int = panel.held_inputs_refused
	_parse_joy(JOY_BUTTON_A, true)
	await _await_process_frames(2)
	var opened_by_a: bool = panel.is_open and not panel.inputs_are_armed()
	closes = panel.closes
	_watch(panel)
	_push_joy(JOY_BUTTON_A, true)
	await _await_process_frames(1)
	var refused_once: bool = panel.is_open and panel.held_inputs_refused == refused + 1 and _total_fired() == 0
	_parse_joy(JOY_BUTTON_A, false)
	await _await_process_frames(2)
	var rearmed: bool = panel.is_open and panel.inputs_are_armed()
	_push_joy(JOY_BUTTON_A, true)
	_push_joy(JOY_BUTTON_A, false)
	var confirmed: bool = (not panel.is_open and panel.closes == closes + 1
		and int(_fired.get(close.get_instance_id(), 0)) == 1 and _total_fired() == 1)
	_unwatch()
	await _await_process_frames(2)
	_controller["origin ring"] = confirmed
	_expect(held and opened_held and released and bool(fresh["under"]) and _one_press(fresh) and fresh_closed and still,
		"left held %s, opened disarmed %s, release over Close acted %s, fresh click %s closed %s, no destination %s"
			% [str(held), str(opened_held), str(not released), str(fresh), str(fresh_closed), str(still)])
	_expect(opened_by_a and refused_once and rearmed and confirmed,
		"(A) opened the Ring disarmed %s, a second press refused %s, its release re-armed %s, a fresh (A) confirmed Close %s"
			% [str(opened_by_a), str(refused_once), str(rearmed), str(confirmed)])
	_record("origin ring", "Close (after a held left button)", fresh)
	print("  the left button held over the world as F1 opened the Ring: its release over Close acted on nothing and re-armed the panel; a fresh click closed it once; no destination followed")
	print("  (A) held as it opened the Ring beside the Anchor: pressed again while held, refused once by the contract's held-input rule; released, re-armed; a fresh (A) confirmed the focused Close once")
	_done("held_inputs_at_opening_still_cannot_act")


func _check_the_origin_ring_selects_allocates_refunds_and_closes_by_real_clicks() -> void:
	print("")
	print("--- 15. The Origin Ring: a click on a row selects it, Allocate and Refund act on that selection, Close closes — each by one real click; the pointer alone only previews")
	var panel: OriginRingPanel = opening.origin_ring_panel
	var passives: PassiveAllocation = opening.character.passives
	await _key(KEY_F1)
	if not _opened("origin ring", panel, "F1"):
		return
	var close: Button = _named(panel, "Close")
	var allocate: Button = _named(panel, "Allocate")
	var refund: Button = _named(panel, "Refund")
	var guard: Button = _named(panel, "orbiting_guard")
	var first: StringName = panel.selected
	var available: int = passives.available()
	var reader: Callable = func() -> Dictionary:
		return {"open": panel.is_open, "closes": panel.closes, "selected": panel.selected,
			"allocations": panel.allocations_made, "refunds": panel.refunds_made, "available": passives.available()}
	## Read in the same call as the motion: `mouse_entered` answers synchronously, and in a rendered
	## run the real cursor may move the hover on the next frame.
	_push_motion(guard.get_global_rect().get_center())
	var previewed: bool = panel.hovered == &"orbiting_guard" and panel.selected == first and first != &"orbiting_guard"
	await _standing_probes("origin ring", panel, opening, reader, close, &"ui_cancel", allocate, false)
	var select: Dictionary = _click(panel, guard)
	var selected: bool = (panel.selected == &"orbiting_guard" and panel.allocations_made == 0
		and root.gui_get_focus_owner() == guard)
	var allocation: Dictionary = _click(panel, allocate)
	var allocated: bool = (panel.allocations_made == 1 and passives.is_allocated(&"orbiting_guard")
		and passives.available() == available - 1)
	var refunding: Dictionary = _click(panel, refund)
	var refunded: bool = (panel.refunds_made == 1 and not passives.is_allocated(&"orbiting_guard")
		and passives.available() == available)
	var closes: int = panel.closes
	var shut: Dictionary = _click(panel, close)
	var closed: bool = not panel.is_open and panel.closes == closes + 1
	await _await_process_frames(2)
	await _key(KEY_F1)
	var reopened: bool = panel.is_open
	closes = panel.closes
	await _key(KEY_ESCAPE)
	_cancel["origin ring"] = reopened and not panel.is_open and panel.closes == closes + 1
	_expect(previewed and available == 1, "hover previewed %s over %s; %d point(s) available" % [panel.hovered, first, available])
	_expect(bool(select["under"]) and _one_press(select) and selected and bool(allocation["under"]) and _one_press(allocation)
			and allocated and bool(refunding["under"]) and _one_press(refunding) and refunded
			and bool(shut["under"]) and _one_press(shut) and closed,
		"row %s selected %s; Allocate %s allocated %s; Refund %s refunded %s; Close %s closed %s" % [str(select),
			str(selected), str(allocation), str(allocated), str(refunding), str(refunded), str(shut), str(closed)])
	for pair: Array in [["Orbiting Guard row", select], ["Allocate", allocation], ["Refund", refunding], ["Close", shut]]:
		_record("origin ring", String(pair[0]), pair[1])
	print("  the pointer over Orbiting Guard previewed it and left %s selected; a click selected it; Allocate spent the one point on it; Refund returned it; Close closed the Ring once — one pressed each"
		% first)
	_done("the_origin_ring_selects_allocates_refunds_and_closes_by_real_clicks")


func _check_the_dialogue_continues_skips_and_closes_by_real_clicks() -> void:
	print("")
	print("--- 16. The first conversation: Continue advances one line, Skip goes to the last, Close ends it — each by one real click; Enter and (A) still advance")
	var panel: NexusDialoguePanel = opening.dialogue_panel
	var talk: FirstMvpDialogue = opening.conversation
	var nexus: RiftNexusLayout = opening.rift_nexus
	var station: Vector3 = nexus.mara_station()
	var toward: Vector3 = nexus.anchor_point() - station
	toward.y = 0.0
	var spot: Vector3 = station + toward.normalized() * 2.0
	_stand(opening, Vector3(spot.x, station.y, spot.z))
	await _settle(3)
	await _key(KEY_ENTER)
	if not _opened("dialogue", panel, "Enter beside Mara"):
		return
	var proceed: Button = _named(panel, "Continue")
	var skip: Button = _named(panel, "Skip")
	var reader: Callable = func() -> Dictionary:
		return {"open": panel.is_open, "closes": panel.closes, "index": talk.index, "read": panel.lines_read,
			"complete": opening.character.mara_first_conversation_complete}
	await _standing_probes("dialogue", panel, opening, reader, proceed, &"ui_confirm", proceed, false)
	var index: int = talk.index
	var first: Dictionary = _click(panel, proceed)
	var advanced: bool = talk.index == index + 1 and panel.lines_read == 1 and panel.is_open
	await _await_process_frames(1)
	await _key(KEY_ENTER)
	_keyboard["dialogue"] = talk.index == index + 2 and panel.lines_read == 2 and panel.is_open
	var skipping: Dictionary = _click(panel, skip)
	var skipped: bool = (talk.is_last_line() and not skip.visible and root.gui_get_focus_owner() == proceed
		and panel.lines_read == 2 and panel.is_open)
	var closes: int = panel.closes
	var at: Vector3 = opening.player.global_position
	var uses: int = opening.player.attack.uses_started
	var last: Dictionary = await _parse_click(panel, proceed)
	var finished: bool = (_one_press(last) and not panel.is_open and panel.closes == closes + 1
		and opening.character.mara_first_conversation_complete)
	_through["dialogue"] = await _after_close(opening, opening.any_modal_open, at, uses)
	await _key(KEY_ENTER)
	var reopened: bool = panel.is_open
	closes = panel.closes
	await _key(KEY_ESCAPE)
	_cancel["dialogue"] = reopened and not panel.is_open and panel.closes == closes + 1
	await _key(KEY_ENTER)
	index = talk.index
	await _joy(JOY_BUTTON_A)
	_controller["dialogue"] = panel.is_open and talk.index == index + 1
	closes = panel.closes
	await _joy(JOY_BUTTON_B)
	var closed_by_b: bool = not panel.is_open and panel.closes == closes + 1
	_expect(bool(first["under"]) and _one_press(first) and advanced and bool(skipping["under"]) and _one_press(skipping)
			and skipped and finished and closed_by_b,
		"Continue %s advanced %s; Skip %s skipped %s; Close %s finished %s; (B) closed %s" % [str(first), str(advanced),
			str(skipping), str(skipped), str(last), str(finished), str(closed_by_b)])
	_record("dialogue", "Continue", first)
	_record("dialogue", "Skip", skipping)
	_record("dialogue", "Close", last)
	print("  a click on Continue advanced exactly one line and Enter one more; a click on Skip went to the last line, hid Skip and left the focus on Close; a click on Close read it through, recorded the conversation and closed once")
	_done("the_dialogue_continues_skips_and_closes_by_real_clicks")


func _check_the_foundation_cache_selects_and_confirms_by_real_clicks() -> void:
	print("")
	print("--- 17. The Foundation Cache: a click on a card selects it, Not yet closes, Choose confirms the selected card once; the pointer alone only previews")
	var panel: FoundationCachePanel = opening.foundation_cache_panel
	var character: CharacterState = opening.character
	await _key(KEY_F2)
	if not _opened("foundation cache", panel, "F2"):
		return
	var cards: Array[Button] = [_named(panel, "Package0"), _named(panel, "Package1"), _named(panel, "Package2")]
	var choose: Button = _named(panel, "Choose")
	var not_yet: Button = _named(panel, "Not yet")
	var reader: Callable = func() -> Dictionary:
		return {"open": panel.is_open, "closes": panel.closes, "selected": panel.selected_index,
			"confirmations": panel.confirmations, "granted": character.foundation_package_granted}
	var first: int = panel.selected_index
	## Read in the same call as the motion, as the Origin Ring's preview is (check 15).
	_push_motion(cards[2].get_global_rect().get_center())
	var previewed: bool = panel.hovered_index == 2 and panel.selected_index == first and first != 2
	await _standing_probes("foundation cache", panel, opening, reader, not_yet, &"ui_cancel", choose, false)
	var pick: Dictionary = _click(panel, cards[2])
	var picked: bool = (panel.selected_index == 2 and panel.confirmations == 0 and not character.foundation_package_granted
		and root.gui_get_focus_owner() == cards[2])
	var closes: int = panel.closes
	await _key(KEY_ESCAPE)
	_cancel["foundation cache"] = not panel.is_open and panel.closes == closes + 1 and not character.foundation_package_granted
	await _key(KEY_F2)
	closes = panel.closes
	var later: Dictionary = _click(panel, not_yet)
	var put_off: bool = not panel.is_open and panel.closes == closes + 1 and not character.foundation_package_granted
	await _await_process_frames(2)
	await _key(KEY_F2)
	var again: Dictionary = _click(panel, cards[1])
	var repicked: bool = panel.selected_index == 1 and panel.is_open
	closes = panel.closes
	var confirm: Dictionary = _click(panel, choose)
	var chosen: bool = (not panel.is_open and panel.closes == closes + 1 and panel.confirmations == 1
		and character.foundation_package_granted
		and character.foundation_package == CharacterState.FoundationPackage.PROJECTILE)
	await _await_process_frames(2)
	await _key(KEY_F2)
	var refused: bool = not panel.is_open
	_expect(previewed, "hover previewed %d over %d" % [panel.hovered_index, first])
	_expect(bool(pick["under"]) and _one_press(pick) and picked and bool(later["under"]) and _one_press(later) and put_off
			and bool(again["under"]) and _one_press(again) and repicked and bool(confirm["under"]) and _one_press(confirm)
			and chosen and refused,
		"card 3 %s picked %s; Not yet %s %s; card 2 %s %s; Choose %s chose %s; reopening refused %s" % [str(pick), str(picked),
			str(later), str(put_off), str(again), str(repicked), str(confirm), str(chosen), str(refused)])
	for pair: Array in [["third card", pick], ["Not yet", later], ["second card", again], ["Choose", confirm]]:
		_record("foundation cache", String(pair[0]), pair[1])
	print("  the pointer over the third card previewed it and left card %d selected; a click selected the third card; Escape and then Not yet closed without choosing; a click on the second card and on Choose granted exactly its package — Splinter Shot and the Marrow Bow — once"
		% (first + 1))
	_done("the_foundation_cache_selects_and_confirms_by_real_clicks")

# --- 18–20. The three roguelite choices -------------------------------------------------------------

func _replayability_phase() -> void:
	replay = await _load(REPLAY_SCENE) as RogueliteReplayabilityRuntime
	if replay == null:
		return
	await _await_navigation(replay)
	await _walk_into_gate(replay, replay.hub_module.exit_point())
	await _clear_room(replay, 0)
	await _walk_into_gate(replay, replay.room_modules[0].exit_point())
	await _clear_room(replay, replay.reward_beat_index())
	await _wait_for(func() -> bool: return replay.boon_panel.is_open, 5.0)
	await _check_the_boon_choice_grants_only_the_clicked_boon()


func _replay_open() -> bool:
	return (replay.item_comparison.is_open or replay.fallen_overlay.is_open or replay.summary_panel.is_open
		or replay.boon_panel.is_open)


func _check_the_boon_choice_grants_only_the_clicked_boon() -> void:
	print("")
	print("--- 18. The boon choice: a click on the second choice grants that boon and nothing else, once; cancel cannot close it")
	var panel: RogueliteBoonChoicePanel = replay.boon_panel
	if not _opened("boon", panel, "clearing the reward beat"):
		return
	var buttons: Array[Button] = panel.choice_buttons()
	var kinds: Array[int] = RogueliteRunBoon.offered_kinds()
	var reader: Callable = func() -> Dictionary:
		return {"open": panel.is_open, "closes": panel.closes, "taken": replay.boons_taken,
			"boon": -1 if replay.run_boon == null else int(replay.run_boon.kind)}
	await _standing_probes("boon", panel, replay, reader, buttons[0], &"ui_confirm", buttons[1], true)
	var taken: int = replay.boons_taken
	var room: int = replay.run_state.current_room_index
	var at: Vector3 = replay.player.global_position
	var uses: int = replay.player.attack.uses_started
	var click: Dictionary = await _parse_click(panel, buttons[1])
	var granted: bool = (_one_press(click) and replay.boons_taken == taken + 1 and replay.run_boon != null
		and int(replay.run_boon.kind) == kinds[1] and not panel.is_open and replay.run_state.is_cleared(room))
	_through["boon"] = await _after_close(replay, _replay_open, at, uses)
	var stayed: bool = replay.run_state.current_room_index == room and replay.boons_taken == taken + 1
	_expect(granted and stayed, "the click on the second choice: %s; boons taken %d, boon %s" % [str(click),
		replay.boons_taken, "none" if replay.run_boon == null else replay.run_boon.display_name()])
	_record("boon", "second choice", click)
	print("  one left press and release over \"%s\": one pressed on that button and none on the other; exactly one boon taken — %s — the reward beat cleared, and the run still in that room"
		% [RogueliteRunBoon.name_of(kinds[1]), RogueliteRunBoon.name_of(kinds[1])])
	_done("the_boon_choice_grants_only_the_clicked_boon")


func _build_variety_phase() -> void:
	variety = await _load(VARIETY_SCENE) as RogueliteBuildVarietyRuntime
	if variety == null:
		return
	await _await_navigation(variety)
	await _walk_into_gate(variety, variety.hub_module.exit_point())
	await _clear_room(variety, variety.opening_beat_index())
	await _wait_for(func() -> bool: return variety.choice_panel.is_open, 5.0)
	await _check_the_upgrade_choice_takes_only_the_clicked_slot()


func _check_the_upgrade_choice_takes_only_the_clicked_slot() -> void:
	print("")
	print("--- 19. The upgrade choice (UI evidence only; D-223 stays OPEN): a click on the second slot takes that slot's upgrade and nothing else, once")
	var panel: RogueliteUpgradeChoicePanel = variety.choice_panel
	if not _opened("upgrade", panel, "clearing the opening beat"):
		return
	var buttons: Array[Button] = panel.choice_buttons()
	var offered: Array[int] = panel.offered_kinds()
	var reader: Callable = func() -> Dictionary:
		return {"open": panel.is_open, "closes": panel.closes, "taken": variety.upgrades_taken,
			"acquired": variety.build.acquired.duplicate()}
	await _standing_probes("upgrade", panel, variety, reader, buttons[0], &"ui_confirm", buttons[1], true)
	var taken: int = variety.upgrades_taken
	var closes: int = panel.closes
	var click: Dictionary = _click(panel, buttons[1])
	var took: bool = (variety.upgrades_taken == taken + 1 and variety.build.acquired.size() == 1
		and variety.build.acquired[0] == offered[1] and not panel.is_open and panel.closes == closes + 1)
	await _await_process_frames(2)
	_expect(bool(click["under"]) and _one_press(click) and took, "the click on the second slot: %s; acquired %s of %s"
		% [str(click), str(variety.build.acquired), str(offered)])
	_record("upgrade", "second slot", click)
	print("  one left press and release over the second slot's button: one pressed; exactly one upgrade taken — %s, the kind that slot held — and the panel closed once"
		% RogueliteUpgrade.name_of(offered[1]))
	_done("the_upgrade_choice_takes_only_the_clicked_slot")


func _level_up_phase() -> void:
	levels = await _load(LEVEL_UP_SCENE) as RogueliteLevelUpChoiceReview
	if levels == null:
		return
	await _await_navigation(levels)
	await _walk_into_gate(levels, levels.hub_module.exit_point())
	for index: int in [0, 1]:
		await _clear_room(levels, index)
		await _walk_into_gate(levels, levels.room_modules[index].exit_point())
	await _clear_room(levels, 2)
	await _wait_for(func() -> bool: return levels.level_up_panel.is_open, 5.0)
	await _check_the_level_up_card_takes_its_own_lane_through_the_accepted_transaction()


func _check_the_level_up_card_takes_its_own_lane_through_the_accepted_transaction() -> void:
	print("")
	print("--- 20. The level-up offer: a click on card 3 takes that card's standing lane through H8, I1 and G4, once — the path I2's own override used to open")
	var panel: RiftLevelUpOfferPanel = levels.level_up_panel
	if not _opened("level-up", panel, "the route's motes reaching Level 1's requirement"):
		return
	var cards: Array[Button] = panel.card_buttons()
	var reader: Callable = func() -> Dictionary:
		return {"open": panel.is_open, "closes": panel.closes, "attempts": levels.choice_attempts,
			"taken": levels.choices_taken, "level": levels.mote_runtime.level()}
	await _standing_probes("level-up", panel, levels, reader, cards[0], &"ui_confirm", cards[2], true)
	var lane: int = panel.lane_for_slot(2)
	var identity: PackedStringArray = levels.mote_runtime.offer_identity_for(lane)
	var attempts: int = levels.choice_attempts
	var taken: int = levels.choices_taken
	var click: Dictionary = _click(panel, cards[2])
	var record: RiftRunLevelUpResult = levels.last_choice_record
	var took: bool = (record != null and record.succeeded() and record.level_up() != null
		and record.level_up().lane == lane and lane == RiftOffer.Lane.UTILITY
		and record.level_up().granted_identity() == identity and levels.choice_attempts == attempts + 1
		and levels.choices_taken == taken + 1 and not panel.is_open and levels.mote_runtime.level() == 2)
	await _await_process_frames(2)
	_expect(levels.automatic_pickup and bool(click["under"]) and _one_press(click) and took,
		"the click on card 3: %s; record %s" % [str(click), "none" if record == null else record.failure_reason()])
	_record("level-up", "card 3", click)
	print("  one left press and release over card 3: one pressed; lane %d (Utility) taken through H8, I1 and G4 — granted [%s], the identity the standing offer held for that lane — one attempt, one choice, the panel closed at Rift level 2"
		% [lane, ", ".join(identity)])
	_done("the_level_up_card_takes_its_own_lane_through_the_accepted_transaction")

# --- 21–30. What every panel owed, read together ------------------------------------------------

const CLOSABLE: Array[String] = ["comparison", "summary", "dialogue", "origin ring", "foundation cache"]
const MANDATORY: Array[String] = ["roguelite fallen", "gate 1d fallen", "boon", "upgrade", "level-up"]
const EXPECTED_CLICKS: int = 21


## The labels of `labels` whose reading in `readings` is missing or false.
func _short(readings: Dictionary, labels: Array[String]) -> PackedStringArray:
	var short: PackedStringArray = PackedStringArray()
	for label: String in labels:
		if not readings.has(label) or not bool(readings[label]):
			short.append(label)
	return short


func _check_hover_alone_commits_nothing() -> void:
	print("")
	print("--- 21. Hover alone commits nothing, on every panel")
	var short: PackedStringArray = PackedStringArray()
	var swept: int = 0
	for label: String in PANEL_LABELS:
		if not _hover.has(label) or not bool((_hover[label] as Array)[1]):
			short.append(label)
		else:
			swept += int((_hover[label] as Array)[0])
	_expect(short.is_empty(), "hover committed something, or was not measured, on: %s" % ", ".join(short))
	print("  %d of %d panels: the pointer passed over every visible button — %d in all — and nothing was pressed, chosen, closed, equipped, allocated, refunded, granted or taken; the Origin Ring's and the Foundation Cache's accepted hover previews moved and their selections did not"
		% [PANEL_LABELS.size() - short.size(), PANEL_LABELS.size(), swept])
	_done("hover_alone_commits_nothing")


func _check_backdrop_and_panel_left_clicks_commit_nothing() -> void:
	print("")
	print("--- 22. A left click on the dim backdrop or on the panel's own body commits nothing and moves nothing, on every panel")
	var short: PackedStringArray = _short(_backdrop, PANEL_LABELS)
	_expect(short.is_empty(), "a backdrop or body click acted on: %s" % ", ".join(short))
	print("  %d of %d panels: each press landed on the modal's own Dim, then on its own Panel body; each stopped there — nothing pressed, the panel open, the world still paused, no destination"
		% [PANEL_LABELS.size() - short.size(), PANEL_LABELS.size()])
	_done("backdrop_and_panel_left_clicks_commit_nothing")


func _check_right_clicks_commit_nothing() -> void:
	print("")
	print("--- 23. A right click over a real button commits nothing, on every panel")
	var short: PackedStringArray = _short(_right, PANEL_LABELS)
	_expect(short.is_empty(), "a right click acted on: %s" % ", ".join(short))
	print("  %d of %d panels: the pointer over a committing button, a right press and release — nothing pressed, no attack started, the panel open"
		% [PANEL_LABELS.size() - short.size(), PANEL_LABELS.size()])
	_done("right_clicks_commit_nothing")


func _check_keyboard_confirmation_is_unchanged() -> void:
	print("")
	print("--- 24. Keyboard confirmation is unchanged: Enter activates the focused control")
	var short: PackedStringArray = _short(_keyboard, ["summary", "dialogue"] as Array[String])
	_expect(short.is_empty(), "Enter did not act as accepted on: %s" % ", ".join(short))
	print("  Enter closed the run summary through its focused \"Back to the Nexus\" and advanced the first conversation one line through its focused Continue")
	_done("keyboard_confirmation_is_unchanged")


func _check_controller_confirmation_is_unchanged() -> void:
	print("")
	print("--- 25. Simulated controller confirmation is unchanged: (A) activates the focused control")
	var short: PackedStringArray = _short(_controller, ["summary", "dialogue", "origin ring"] as Array[String])
	_expect(short.is_empty(), "(A) did not act as accepted on: %s" % ", ".join(short))
	print("  (A) closed the run summary, advanced the first conversation one line, and — once its held press was released — closed the Origin Ring through its focused Close")
	_done("controller_confirmation_is_unchanged")


func _check_cancel_is_unchanged_for_closable_and_mandatory_panels() -> void:
	print("")
	print("--- 26. Cancel is unchanged: it closes the five closable panels and leaves the five that must be answered open")
	var closable: PackedStringArray = _short(_cancel, CLOSABLE)
	var mandatory: PackedStringArray = _short(_cancel, MANDATORY)
	_expect(closable.is_empty() and mandatory.is_empty(),
		"cancel did not close %s, or did not leave %s open" % [", ".join(closable), ", ".join(mandatory)])
	print("  Escape closed the comparison, the run summary, the conversation, the Origin Ring and the Foundation Cache once each; Escape and (B) left both Fallen overlays, the boon, the upgrade and the level-up choice open over the same state")
	_done("cancel_is_unchanged_for_closable_and_mandatory_panels")


func _check_no_click_through_after_a_closing_button() -> void:
	print("")
	print("--- 27. A click that closes a modal reaches nothing behind it, then or once the world runs again")
	var short: PackedStringArray = _short(_through, ["comparison", "summary", "dialogue", "boon"] as Array[String])
	_expect(short.is_empty(), "a closing click reached the world after: %s" % ", ".join(short))
	print("  4 closing clicks sent through Input.parse_input_event() — the comparison's Close, the run summary's \"Back to the Nexus\", the conversation's Close and the boon's second choice: over the 20 physics frames after each, no destination, no attack, no movement, no modal, and the left button no longer held")
	_done("no_click_through_after_a_closing_button")


func _check_the_world_stays_paused_while_a_modal_stands() -> void:
	print("")
	print("--- 28. The world stays paused while a modal stands")
	var short: PackedStringArray = _short(_paused_reading, PANEL_LABELS)
	_expect(short.is_empty(), "the world moved behind: %s" % ", ".join(short))
	print("  %d of %d panels: over 10 physics frames the tree stayed paused, the character did not move and no attack began"
		% [PANEL_LABELS.size() - short.size(), PANEL_LABELS.size()])
	_done("the_world_stays_paused_while_a_modal_stands")


func _check_focus_and_glyphs_are_unchanged() -> void:
	print("")
	print("--- 29. Focus and the input-family glyphs are unchanged")
	var short: PackedStringArray = _short(_focus, PANEL_LABELS)
	_expect(short.is_empty(), "the safe control was not focused, or its glyph was not the live family's, on: %s" % ", ".join(short))
	print("  %d of %d panels opened with their accepted safe control focused, its glyph the one FirstMvpModal.glyph_for() gives the live input family; a click on a control that does not close the panel leaves Godot's own focus on it — the Origin Ring's row, the Foundation Cache's card — and Skip hands its focus to Close as it hides"
		% [PANEL_LABELS.size() - short.size(), PANEL_LABELS.size()])
	_done("focus_and_glyphs_are_unchanged")


func _check_every_state_change_happens_exactly_once() -> void:
	print("")
	print("--- 30. Every click pressed exactly one button — the one under the pointer — exactly once")
	var faults: PackedStringArray = PackedStringArray()
	var labels: Dictionary = {}
	for click: Dictionary in _clicks:
		labels[String(click["label"])] = true
		if not bool(click["one"]) or not bool(click["under"]):
			faults.append("%s %s" % [click["label"], click["button"]])
	_expect(faults.is_empty() and _clicks.size() == EXPECTED_CLICKS and labels.size() == PANEL_LABELS.size(),
		"%d clicks on %d panels; not exactly one press on the button under the pointer: %s" % [_clicks.size(),
			labels.size(), ", ".join(faults)])
	print("  %d activating clicks on %d panels, every one over the real button: exactly one pressed on that button and none on any other button in its panel, and each panel's own outcome recorded exactly once"
		% [_clicks.size(), labels.size()])
	_done("every_state_change_happens_exactly_once")


func _check_every_check_ran() -> void:
	var missing: PackedStringArray = PackedStringArray()
	for name: String in OWED_CHECKS:
		if not _reached.has(name):
			missing.append(name)
	var extra: PackedStringArray = PackedStringArray()
	for name: String in _reached.keys():
		if not OWED_CHECKS.has(name):
			extra.append(name)
	_expect(missing.is_empty() and extra.is_empty(),
		"owed checks that never reached their last line: %s; unexpected: %s" % [", ".join(missing), ", ".join(extra)])
	print("")
	print("  %d of %d owed checks completed" % [OWED_CHECKS.size() - missing.size(), OWED_CHECKS.size()])

# --- The pointer, the keyboard and the controller ------------------------------------------------

## Window coordinates for a point in the viewport's own space: the stretch transform, applied the
## way the operating system's pointer arrives through it.
func _window(local: Vector2) -> Vector2:
	return root.get_final_transform() * local


func _motion_event(local: Vector2) -> InputEventMouseMotion:
	var motion: InputEventMouseMotion = InputEventMouseMotion.new()
	var at: Vector2 = _window(local)
	motion.position = at
	motion.global_position = at
	return motion


func _button_event(local: Vector2, index: MouseButton, pressed: bool) -> InputEventMouseButton:
	var click: InputEventMouseButton = InputEventMouseButton.new()
	var at: Vector2 = _window(local)
	click.button_index = index
	click.pressed = pressed
	click.position = at
	click.global_position = at
	return click


func _push_motion(local: Vector2) -> void:
	root.push_input(_motion_event(local), false)


func _parse_motion(local: Vector2) -> void:
	Input.parse_input_event(_motion_event(local))


func _parse_mouse(local: Vector2, index: MouseButton, pressed: bool) -> void:
	Input.parse_input_event(_button_event(local, index, pressed))


## A pointer motion to `local`, then a press and a release of `index` there. Answers the control the
## GUI found under the pointer.
func _click_at(local: Vector2, index: MouseButton) -> Control:
	_push_motion(local)
	var under: Control = root.gui_get_hovered_control()
	root.push_input(_button_event(local, index, true), false)
	root.push_input(_button_event(local, index, false), false)
	return under


## One real left click on `button`, pushed into the root window — motion, press and release in one
## call — with every button in the panel watched.
func _click(panel: Control, button: Button) -> Dictionary:
	_watch(panel)
	var local: Vector2 = button.get_global_rect().get_center()
	_push_motion(local)
	var under: bool = root.gui_get_hovered_control() == button
	root.push_input(_button_event(local, MOUSE_BUTTON_LEFT, true), false)
	root.push_input(_button_event(local, MOUSE_BUTTON_LEFT, false), false)
	var result: Dictionary = _fired_on(button, under)
	_unwatch()
	return result


## One real left click on `button` through `Input.parse_input_event()`, the path the operating
## system's own events take; it is delivered at the next frame's input flush.
func _parse_click(panel: Control, button: Button) -> Dictionary:
	_watch(panel)
	var local: Vector2 = button.get_global_rect().get_center()
	_parse_motion(local)
	_parse_mouse(local, MOUSE_BUTTON_LEFT, true)
	_parse_mouse(local, MOUSE_BUTTON_LEFT, false)
	await _await_process_frames(2)
	var result: Dictionary = _fired_on(button, int(_fired.get(button.get_instance_id(), 0)) == 1)
	_unwatch()
	return result


func _fired_on(button: Button, under: bool) -> Dictionary:
	var own: int = int(_fired.get(button.get_instance_id(), 0))
	return {"under": under, "fired": own, "others": _total_fired() - own}


## Counts `pressed` on every button in `panel`. The production connections stay exactly as they are;
## this only listens beside them.
func _watch(panel: Control) -> void:
	_unwatch()
	_fired.clear()
	for node: Node in panel.find_children("*", "Button", true, false):
		var button: Button = node as Button
		var id: int = button.get_instance_id()
		_fired[id] = 0
		var counter: Callable = func() -> void: _fired[id] = int(_fired[id]) + 1
		button.pressed.connect(counter)
		_watched.append({"button": button, "callable": counter})


func _unwatch() -> void:
	for entry: Dictionary in _watched:
		var button: Button = entry["button"]
		var counter: Callable = entry["callable"]
		if is_instance_valid(button) and button.pressed.is_connected(counter):
			button.pressed.disconnect(counter)
	_watched.clear()


func _total_fired() -> int:
	var total: int = 0
	for id: int in _fired.keys():
		total += int(_fired[id])
	return total


func _one_press(result: Dictionary) -> bool:
	return int(result["fired"]) == 1 and int(result["others"]) == 0


func _record(label: String, button_name: String, result: Dictionary) -> void:
	_clicks.append({"label": label, "button": button_name, "one": _one_press(result), "under": bool(result["under"])})


func _push_key(keycode: Key, pressed: bool) -> void:
	var event: InputEventKey = InputEventKey.new()
	event.keycode = keycode
	event.physical_keycode = keycode
	event.pressed = pressed
	root.push_input(event)


func _key(keycode: Key) -> void:
	_push_key(keycode, true)
	_push_key(keycode, false)
	await _await_process_frames(1)


func _joy_event(button: JoyButton, pressed: bool) -> InputEventJoypadButton:
	var event: InputEventJoypadButton = InputEventJoypadButton.new()
	event.device = 0
	event.button_index = button
	event.pressed = pressed
	return event


func _push_joy(button: JoyButton, pressed: bool) -> void:
	root.push_input(_joy_event(button, pressed))


func _parse_joy(button: JoyButton, pressed: bool) -> void:
	Input.parse_input_event(_joy_event(button, pressed))


func _joy(button: JoyButton) -> void:
	_push_joy(button, true)
	_push_joy(button, false)
	await _await_process_frames(1)


# --- The worlds ------------------------------------------------------------------------------------

func _stand(room: BrokenWatchSlice, at: Vector3) -> void:
	room.player.global_position = at
	room.player.velocity = Vector3.ZERO
	room.player.clear_movement_intent("verification", false)
	room.camera_rig.focus = room.player.global_position


func _walk_into_gate(room: BrokenWatchSlice, gate: Vector3) -> void:
	_stand(room, gate)
	await _await_process_frames(6)
	await _settle(4)


## STAGED: the room's enemies are quieted, gathered where the player stands and killed through the
## production intake.
func _clear_room(room: RogueliteCoreLoopRuntime, index: int) -> void:
	var centre: Vector3 = room.room_modules[index].room_centres()[0]
	centre = Vector3(roundf(centre.x), 0.0, roundf(centre.z))
	for enemy: PrototypeGraveblade in room.room_enemies[index]:
		enemy.set_ai_enabled(false)
	_stand(room, centre)
	for enemy: PrototypeGraveblade in room.room_enemies[index]:
		enemy.place_at(centre)
		_kill(room, enemy)
	await _settle(3)
	var note: String = "rooms cleared by quieting, gathering and killing their enemies through receive_damage()"
	if not _staged.has(note):
		_staged.append(note)


func _kill(room: BrokenWatchSlice, enemy: PrototypeGraveblade) -> void:
	enemy.receive_damage(DamageEvent.physical(_use(), room.player, enemy, enemy.life + 1000.0))
	_expect_quiet(not enemy.is_alive(), "%s did not die from a lethal hit" % enemy.name)


func _use() -> int:
	_next_use_id += 1
	return _next_use_id


func _opened(label: String, panel: FirstMvpModal, how: String) -> bool:
	_expect(panel.is_open and paused, "the %s did not open, paused, by %s" % [label, how])
	return panel.is_open


func _named(panel: Control, node_name: String) -> Button:
	for node: Node in panel.find_children(node_name, "Button", true, false):
		return node as Button
	_failures.append("no button named %s in %s" % [node_name, panel.name])
	return null


## `FirstMvpModal.make_button()` builds `Button -> HBoxContainer -> [caption, glyph]`.
func _glyph_of(button: Button) -> Label:
	if button == null or button.get_child_count() == 0:
		return null
	var row: Node = button.get_child(0)
	if row.get_child_count() < 2:
		return null
	return row.get_child(1) as Label


func _log_count(room: BrokenWatchSlice, token: String) -> int:
	var count: int = 0
	for line: String in room.log_lines:
		if line.contains(token):
			count += 1
	return count


func _wait_for(condition: Callable, seconds: float) -> bool:
	var deadline: int = Time.get_ticks_msec() + int(seconds * 1000.0)
	while not bool(condition.call()):
		if Time.get_ticks_msec() > deadline:
			return false
		await process_frame
	return true


func _settle(frames: int) -> void:
	for frame: int in frames:
		await physics_frame


func _await_process_frames(frames: int) -> void:
	for frame: int in frames:
		await process_frame


func _argument_value(flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


# --- Source readings ---------------------------------------------------------------------------------

func _descendant_paths() -> Array[String]:
	var paths: Array[String] = []
	for path: String in DIRECT_DESCENDANTS.values():
		paths.append(path)
	paths.append("res://scripts/roguelite/roguelite_fallen_overlay.gd")
	paths.append("res://scripts/roguelite/replayability/roguelite_replayability_summary_panel.gd")
	paths.append("res://scripts/roguelite/build_variety/roguelite_build_variety_summary_panel.gd")
	return paths


func _files_under(root_path: String, extensions: Array[String]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open(root_path)
	if dir == null:
		return out
	dir.list_dir_begin()
	var entry: String = dir.get_next()
	for guard: int in 100000:
		if entry.is_empty():
			break
		if entry != "." and entry != "..":
			var full: String = root_path.path_join(entry)
			if dir.current_is_dir():
				out.append_array(_files_under(full, extensions))
			else:
				for extension: String in extensions:
					if entry.ends_with(extension):
						out.append(full)
		entry = dir.get_next()
	dir.list_dir_end()
	return out


func _declared_functions(source: String) -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	var pattern: RegEx = RegEx.create_from_string("(?m)^(?:static )?func ([A-Za-z0-9_]+)\\(")
	for found: RegExMatch in pattern.search_all(source):
		names.append(found.get_string(1))
	return names


func _declared_fields(source: String) -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	var pattern: RegEx = RegEx.create_from_string("(?m)^var ([A-Za-z0-9_]+)")
	for found: RegExMatch in pattern.search_all(source):
		names.append(found.get_string(1))
	return names


## The indented body of top-level function `name`, up to the next unindented line.
func _function_body(source: String, name: String) -> String:
	var body: PackedStringArray = PackedStringArray()
	var inside: bool = false
	for line: String in source.split("\n"):
		if line.begins_with("func %s(" % name) or line.begins_with("static func %s(" % name):
			inside = true
			continue
		if inside:
			if (not line.is_empty() and not line.begins_with("\t") and not line.begins_with(" ")
					and not line.begins_with(")")):
				break
			body.append(line)
	return "\n".join(body)


## Code with every comment line removed.
func _uncommented(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


## The non-empty code lines of `body`, each stripped of its indentation.
func _code_lines(body: String) -> PackedStringArray:
	var lines: PackedStringArray = PackedStringArray()
	for line: String in body.split("\n"):
		var stripped: String = line.strip_edges()
		if stripped.is_empty() or stripped.begins_with("#"):
			continue
		lines.append(stripped)
	return lines


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


## Records a failure without adding to the pinned count.
func _expect_quiet(condition: bool, failure_message: String) -> void:
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
