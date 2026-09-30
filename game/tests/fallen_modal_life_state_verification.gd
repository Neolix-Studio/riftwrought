extends SceneTree
## First-MVP UI J2 — Fallen-State Preservation Across Modal Neutralization V1: automated
## verification (decision D-324).
##
## THE ONE QUESTION: when a modal neutralizes the controls of a character who has already fallen —
## the Fallen overlay's own opening above all — does the character stay FALLEN, `is_alive()` false at
## zero Life, while a living character's neutralization, the overlay, the paused world and the one
## revival through Restart stay exactly as accepted?
##
## THE PLAYER IS THE ONLY PRODUCTION FILE J2 MOVES, and that is proved by reconstruction: the player
## with J2's added comment removed and its one guarded assignment put back is, byte for byte, the file
## as it stood before the first J2 edit.
##
## PRODUCTION PLAYER FIXTURES prove the neutralization itself: `prototype_player.tscn` instanced whole
## into this harness's own stage with its processing disabled, and every script variable read before
## and after each call, so what a call changes is LISTED rather than sampled.
##
## TWO ACCEPTED SCENES, LOADED AS THEY SHIP AND GIVEN NO FLAG OF THEIR OWN, prove it in play: Gate
## 1D's own `broken_watch_slice.tscn`, and the I3 live-effect review, the deepest accepted roguelite
## runtime (the core loop, H9's motes, I2's offers and I3's live build, as I12–I14 drive it). Every
## death is dealt by a real Graveblade's own attack, and every Restart is the overlay's own.
##
## STAGED, AND STATED WHERE IT HAPPENS:
##   - enemies are quieted and placed; Gate 1D's first Graveblade is killed through `receive_damage()`
##     so that the guaranteed drop, and with it the item comparison, exists;
##   - the player is placed before each death — at Riftfall Landing's start, the Teaching Hall's centre
##     or the Elite Hall's — and each Graveblade attack is begun through its own
##     `begin_attack_for_verification()`; everything after that is the attack's own;
##   - a living Quick Strike is begun through the room's forced-aim seam and `attack.press()`, as Gate
##     1D's accepted suite begins one, and a living NAVIGATE through `command_move_to()`;
##   - the route to Vitality is I14's: experience beyond the route's own 75 is awarded by production
##     Graveblades registered with the run's H8 runtime and killed (D-315 ruling 1);
##   - one mote is dropped under the fallen character by one more such Graveblade, so that a sweep, if
##     one ran, would have something to collect;
##   - one fallen fixture is given a velocity and a stick reading, so that clearing them can be seen.
##
## Input is simulated: keys and joypad buttons pushed into the root window, the stick through
## `Input.parse_input_event()`, the pointer in WINDOW coordinates so the stretch transform maps it. That
## is not physical-device certification.
##
## IT PORTS D-211's OWED-SET DISCIPLINE.
##
## Run: godot --headless --path game --script res://tests/fallen_modal_life_state_verification.gd -- --seed 99

const THIS_FILE: String = "res://tests/fallen_modal_life_state_verification.gd"
const PLAYER_SCRIPT: String = "res://scripts/actors/prototype_player.gd"
const PLAYER_SCENE: String = "res://scenes/actors/prototype_player.tscn"
const GRAVEBLADE_SCENE: String = "res://scenes/actors/prototype_graveblade.tscn"
const GRAVEBLADE_RECORD: String = "res://data/prototype_zero/graveblade.tres"
const WORN_BLADE: String = "res://data/roguelite/worn_blade.tres"
const SLICE_SCENE: String = "res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
const REVIEW_SCENE: String = "res://scenes/roguelite/roguelite_live_effect_review.tscn"
const MODAL_SCRIPT: String = "res://scripts/ui/first_mvp_modal.gd"
const FALLEN_SCRIPT: String = "res://scripts/ui/first_mvp_fallen_overlay.gd"
const ROGUELITE_FALLEN_SCRIPT: String = "res://scripts/roguelite/roguelite_fallen_overlay.gd"
const SKILL_ACTION_SCRIPT: String = "res://scripts/skills/first_mvp_skill_action.gd"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31
const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]

## The player before the first J2 edit, whole, and J2's two changes to it, exactly as written.
const PRE_J2_SHA256: String = "a6d93721beb10409eb3fefb856de80e8996c52b1816d51d97b53575088716392"
const J2_PREFIX: String = "80e38838"
const J2_ADDED_COMMENT: String = "##\n## It clears CONTROLS, never life: a FALLEN character stays FALLEN (First-MVP UI\n## J2, decision D-324). Every modal neutralizes through here as it opens, the\n## Fallen overlay among them, and the unconditional return to IDLE this used to\n## write made `is_alive()` answer true behind that overlay at zero Life (D-315).\n## Movement, the attack, targeting, locomotion and velocity are still cleared for\n## a fallen character exactly as for a living one; only the return to IDLE is\n## withheld. Only `revive_for_testing()` brings a character back.\n"
const J2_STATE_RULE: String = "\tif action_state != ActionState.FALLEN:\n\t\taction_state = ActionState.IDLE\n"
const ACCEPTED_STATE_LINE: String = "\taction_state = ActionState.IDLE\n"

## The player's declarations, counted before the first J2 edit.
const PLAYER_FIELDS: int = 30
const PLAYER_EXPORTS: int = 18
const PLAYER_FUNCTIONS: int = 53
const PLAYER_CONSTANTS: int = 4
const PLAYER_ENUMS: int = 2
const PLAYER_SIGNALS: Array[String] = [
	"life_changed", "took_damage", "fell", "mana_changed", "weapon_changed", "attack_speed_changed",
	"movement_command_resolved", "arrived_at_destination", "movement_intent_cleared", "movement_mode_changed",
]
const CLEAR_SIGNATURE: String = "func clear_movement_intent(reason: String, require_neutral: bool = true) -> void:"
const IS_ALIVE_SIGNATURE: String = "func is_alive() -> bool:"
## `clear_movement_intent()`'s code lines after J2: the accepted body, with its one assignment of
## IDLE now made only when the character is not FALLEN.
const CLEAR_LINES: Array[String] = [
	"if attack != null:", "attack.clear(reason)", "_movement_suspended_by_attack = false",
	"has_destination = false", "_agent.target_position = global_position", "_locomotion.reset()",
	"velocity = Vector3.ZERO", "if action_state != ActionState.FALLEN:", "action_state = ActionState.IDLE",
	"_set_mode(MovementMode.NONE)", "if require_neutral:", "awaiting_neutral = true", "neutral_reason = reason",
	"movement_intent_cleared.emit(reason)",
]
## `receive_damage()` and `_fall()`, code line for code line, as accepted: Life, the Hit, then the
## fall; and inside the fall, FALLEN before the latch, the emission, the clip and `fell`.
const RECEIVE_DAMAGE_LINES: Array[String] = [
	"if not is_alive():", "return",
	"var source_key: int = event.source.get_instance_id() if event.source != null else 0",
	"if _accepted_use_ids.get(source_key, -1) == event.use_id:", "return",
	"_accepted_use_ids[source_key] = event.use_id", "damage_taken_events += 1", "last_damage_taken = event",
	"life = maxf(life - event.final_life_damage, 0.0)", "life_changed.emit(life, max_life)", "took_damage.emit(event)",
	"if life <= 0.0:", "_fall(event)",
]
const FALL_LINES: Array[String] = [
	"fallen_at_msec = Time.get_ticks_msec()", "if attack != null:", "attack.clear(\"player fallen\")",
	"has_destination = false", "_agent.target_position = global_position", "_locomotion.reset()",
	"_movement_suspended_by_attack = false", "velocity = Vector3.ZERO", "_set_mode(MovementMode.NONE)",
	"action_state = ActionState.FALLEN", "awaiting_neutral = true", "neutral_reason = \"fallen\"",
	"movement_intent_cleared.emit(\"fallen\")", "if _rig != null:", "_current_clip = DEATH_CLIP",
	"_rig.play(DEATH_CLIP, 1.0, 0.10)", "_rig.animation_player.speed_scale = 1.0", "fell.emit(event)",
]
## Every player function that assigns the action state.
const STATE_WRITERS: Array[String] = [
	"command_move_to", "clear_movement_intent", "_fall", "revive_for_testing", "_physics_process", "_arrive",
]

## Everything J2 stands beside, at the SHA-256 prefix each held before the first J2 edit: the modal
## contract, both Fallen overlays and the comparison, the level-up panel, Prototype Zero's modal, Fallen
## overlay and room, the eight runtimes that neutralize through a modal, the combat kernels, the
## locomotion kernel, the seam and its result, H8's runtime, the stat vocabulary, three HUDs, eight
## scenes, three records and project.godot.
const UNCHANGED_HASHES: Array = [
	["res://scripts/ui/first_mvp_modal.gd", "1cfe9c73"],
	["res://scripts/ui/first_mvp_fallen_overlay.gd", "de5e1ab0"],
	["res://scripts/roguelite/roguelite_fallen_overlay.gd", "1753e7b7"],
	["res://scripts/ui/first_mvp_item_comparison.gd", "3607f9f7"],
	["res://scripts/roguelite/level_up/rift_level_up_offer_panel.gd", "694eb0b2"],
	["res://scripts/ui/gate_e_modal.gd", "d01d29ca"],
	["res://scripts/ui/prototype_fallen_overlay.gd", "08660c7a"],
	["res://scripts/prototype_zero/prototype_zero.gd", "21b41e49"],
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
	["res://scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd", "601e5901"],
	["res://scripts/roguelite/roguelite_core_loop_runtime.gd", "a76cec3d"],
	["res://scripts/roguelite/experience/roguelite_experience_collection_review.gd", "150509d5"],
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", "128103b4"],
	["res://scripts/roguelite/live_effects/roguelite_live_effect_review.gd", "75cb02b9"],
	["res://scripts/combat/quick_strike_action.gd", "e6514705"],
	["res://scripts/combat/attack_coordinator.gd", "9ee63381"],
	["res://scripts/combat/damage_event.gd", "3b3185c4"],
	["res://scripts/actors/prototype_graveblade.gd", "0ae1374b"],
	["res://scripts/movement/prototype_locomotion.gd", "c71de58f"],
	["res://scripts/roguelite/live_effects/rift_build_application.gd", "c7b9df38"],
	["res://scripts/roguelite/live_effects/rift_build_application_result.gd", "2fd01f80"],
	["res://scripts/experience/rift_mote_runtime.gd", "23c41eb2"],
	["res://scripts/stats/player_stats.gd", "b0be8c7c"],
	## First-MVP UI J6 (D-332) moved the combat HUD one for one, from `0bb284a1`, so that its Life and
	## Mana fills draw the fraction their labels state. Same count.
	## First-MVP UI J7 (D-334) moved it again, from `aff939f3`, so that the enemy hover Life fill draws
	## its fraction. Same count.
	## First-MVP UI J8 (D-336) moved it again, from `38c485cb`, so that the player resource column sits
	## wholly inside the window. Same count.
	["res://scripts/ui/first_mvp_combat_hud.gd", "ee485029"],
	["res://scripts/roguelite/roguelite_run_hud.gd", "7f0ac70c"],
	["res://scripts/roguelite/experience/roguelite_experience_review_hud.gd", "042a5088"],
	["res://scenes/actors/prototype_player.tscn", "3078a215"],
	["res://scenes/actors/prototype_graveblade.tscn", "752db86c"],
	["res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn", "e9d16993"],
	["res://scenes/first_mvp/canonical_opening/canonical_opening.tscn", "b1d9f2e4"],
	["res://scenes/roguelite/roguelite_core_loop.tscn", "6bdf5388"],
	["res://scenes/roguelite/roguelite_experience_collection_review.tscn", "123cfeb2"],
	["res://scenes/roguelite/roguelite_level_up_choice_review.tscn", "7038bce6"],
	["res://scenes/roguelite/roguelite_live_effect_review.tscn", "0c3c6c98"],
	["res://data/prototype_zero/graveblade.tres", "56317f5f"],
	["res://data/roguelite/graveblade_elite.tres", "6eb3d792"],
	["res://data/roguelite/worn_blade.tres", "7c04f292"],
	["res://project.godot", "55351038"],
]

## Where a modal or an overlay would have to look to special-case death.
const DEATH_TOKENS: Array[String] = ["is_alive", "ActionState", "FALLEN", "action_state", "revive", "life <= ", "life == 0"]

## The two Fallen overlays' own words, typed independently of both scripts.
const KILLING_SOURCE: String = "Graveblade — Melee Hit — 125 Physical Damage"
const DETAIL: String = "Life ran 125 → 0 of %s. No Armour, Evasion, Block, Resistance, or Mana Guard exists yet to reduce it."
const GATE_1D_LABELS: Array[String] = ["Fallen", "Killed by", KILLING_SOURCE, "<detail>", "Restart Broken Watch", "F5 also restarts."]
const ROGUELITE_NOTE: String = "The expedition ends here. Whatever it granted was temporary and goes with it. Nothing you brought in is lost, because nothing is kept between runs yet."
const ROGUELITE_LABELS: Array[String] = ["Fallen", "Killed by", KILLING_SOURCE, "<detail>", ROGUELITE_NOTE, "Return to the Nexus",
	"F5 also abandons the run and returns to the Nexus."]

## The review's accepted route (I14's), seed 99 with Support taken at every level.
const ROUTE_SEED: int = 99
const REVIEW_AMOUNT: float = 25.0
const LEVEL_TWO_AMOUNT: float = 125.0
const CHAIN_AMOUNTS: Array[float] = [150.0, 175.0, 200.0]
## The mote dropped under the fallen character.
const CORPSE_MOTE: float = 250.0
const NEAR: float = 1.2

const OWED_CHECKS: Array[String] = [
	"the_production_scope_is_exactly_the_player",
	"the_player_declares_nothing_new",
	"is_alive_is_unchanged",
	"clear_movement_intent_is_the_accepted_body_with_one_fallen_rule",
	"the_player_stays_the_only_state_authority",
	"no_modal_or_runtime_carries_a_death_special_case",
	"no_scene_input_map_or_presentation_changed",
	"a_living_idle_neutralization_is_unchanged",
	"a_living_navigate_neutralization_is_unchanged",
	"a_living_stick_neutralization_is_unchanged",
	"a_fallen_neutralization_clears_controls_and_keeps_fallen",
	"gate_1d_living_modals_still_neutralize_to_idle",
	"gate_1d_the_delay_keeps_the_player_fallen_with_no_modal",
	"gate_1d_opening_fallen_changes_no_death_fact",
	"gate_1d_the_paused_fallen_player_can_do_nothing",
	"gate_1d_restart_by_focused_confirm",
	"gate_1d_restart_by_a_real_left_click_without_click_through",
	"gate_1d_restart_by_f5_while_the_overlay_stands",
	"roguelite_vitality_is_held_at_575_and_living_offers_neutralize_to_idle",
	"roguelite_the_delay_and_the_open_overlay_keep_the_player_fallen_at_0_of_575",
	"roguelite_no_sweep_pickup_experience_or_offer_while_fallen",
	"roguelite_the_paused_fallen_player_can_do_nothing",
	"roguelite_a_real_left_click_returns_to_the_nexus_and_restores_the_baseline",
	"roguelite_focused_confirm_returns_once",
	"roguelite_f5_while_the_overlay_stands_returns_once",
	"roguelite_f5_inside_the_delay_cancels_the_overlay",
	"the_next_expedition_begins_clean",
	"no_life_damage_or_fall_signal_repeats",
	"no_new_damage_is_accepted_while_fallen",
	"the_killing_event_and_instrumentation_are_unchanged",
	"the_overlays_read_exactly_as_accepted",
]

var arguments: PackedStringArray = PackedStringArray()
var slice: BrokenWatchSlice
var review: RogueliteLiveEffectReview

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _staged: PackedStringArray = PackedStringArray()
var _stage: Node3D
var _next_use_id: int = 324000
var _fixture_players: int = 0
var _fixtures: int = 0

## One record per death, in order, read by the cross-cutting checks.
var _deaths: Array[Dictionary] = []
## Every living modal opening measured in play: label, then what it found and what it left.
var _living: Array[Dictionary] = []
## Where Gate 1D's restart leaves the character once its body has settled, read after the focused
## confirm restart; the click restart, readable only after the next frame's input flush, is held to it.
var _gate_1d_settled: Vector3 = Vector3.INF

## Buttons being watched and how often each emitted `pressed`.
var _fired: Dictionary = {}
var _watched: Array[Dictionary] = []


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	print("")
	print("=== First-MVP UI J2 — Fallen-State Preservation Across Modal Neutralization V1 verification (D-324) ===")
	_stage = Node3D.new()
	_stage.name = "J2FixtureStage"
	root.add_child(_stage)

	_check_the_production_scope_is_exactly_the_player()
	_check_the_player_declares_nothing_new()
	_check_is_alive_is_unchanged()
	_check_clear_movement_intent_is_the_accepted_body_with_one_fallen_rule()
	_check_the_player_stays_the_only_state_authority()
	_check_no_modal_or_runtime_carries_a_death_special_case()
	_check_no_scene_input_map_or_presentation_changed()

	_check_a_living_idle_neutralization_is_unchanged()
	_check_a_living_navigate_neutralization_is_unchanged()
	_check_a_living_stick_neutralization_is_unchanged()
	_check_a_fallen_neutralization_clears_controls_and_keeps_fallen()
	for fixture: Node in _stage.get_children():
		fixture.queue_free()
	await _await_process_frames(2)

	await _gate_1d_phase()
	await _roguelite_phase()

	_check_no_life_damage_or_fall_signal_repeats()
	_check_no_new_damage_is_accepted_while_fallen()
	_check_the_killing_event_and_instrumentation_are_unchanged()
	_check_the_overlays_read_exactly_as_accepted()

	_check_every_check_ran()

	print("")
	print("  staged: %s" % "; ".join(_staged))
	if _failures.is_empty():
		print("FALLEN MODAL LIFE STATE VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("FALLEN MODAL LIFE STATE VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
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


# --- 1–7. Structure: the one file, its shape, the one authority ------------------------------

func _check_the_production_scope_is_exactly_the_player() -> void:
	print("")
	print("--- 1. Exactly one production file moved — the player — and it is the pre-J2 file plus one comment and one guard")
	var source: String = FileAccess.get_file_as_string(PLAYER_SCRIPT)
	var digest: String = FileAccess.get_sha256(PLAYER_SCRIPT)
	var rebuilt: String = source.replace(J2_ADDED_COMMENT, "").replace(J2_STATE_RULE, ACCEPTED_STATE_LINE)
	_expect(digest.begins_with(J2_PREFIX) and source.count(J2_ADDED_COMMENT) == 1 and source.count(J2_STATE_RULE) == 1
			and rebuilt.sha256_text() == PRE_J2_SHA256,
		"the player hashes %s; the comment occurs %d time(s), the guard %d; the reconstruction hashes %s"
			% [digest.left(8), source.count(J2_ADDED_COMMENT), source.count(J2_STATE_RULE), rebuilt.sha256_text().left(8)])
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in UNCHANGED_HASHES:
		var held: String = FileAccess.get_sha256(String(row[0]))
		if not held.begins_with(String(row[1])):
			moved.append("%s %s" % [String(row[0]).get_file(), held.left(8)])
	_expect(moved.is_empty() and UNCHANGED_HASHES.size() == 38, "moved: %s" % ", ".join(moved))
	print("  the player is at its J2 hash %s; with J2's 8 comment lines removed and its 2-line guard put back as the accepted 1 line it is, byte for byte, the pre-J2 file %s"
		% [J2_PREFIX, PRE_J2_SHA256.left(8)])
	print("  %d files J2 stands beside hold the hashes they held before the first J2 edit, but for Gate 1D's slice, which J3, J4 and J5 moved (D-326, D-328, D-330), and the combat HUD, which J6 moved (D-332)" % UNCHANGED_HASHES.size())
	_done("the_production_scope_is_exactly_the_player")


func _check_the_player_declares_nothing_new() -> void:
	print("")
	print("--- 2. No player field, export, function, constant, enum, signal or parameter was added")
	var source: String = FileAccess.get_file_as_string(PLAYER_SCRIPT)
	var signals: PackedStringArray = PackedStringArray()
	var pattern: RegEx = RegEx.create_from_string("(?m)^signal ([A-Za-z0-9_]+)\\(")
	for found: RegExMatch in pattern.search_all(source):
		signals.append(found.get_string(1))
	var fields: int = RegEx.create_from_string("(?m)^var ").search_all(source).size()
	var exports: int = RegEx.create_from_string("(?m)^@export var ").search_all(source).size()
	var constants: int = RegEx.create_from_string("(?m)^const ").search_all(source).size()
	var enums: int = RegEx.create_from_string("(?m)^enum ").search_all(source).size()
	var functions: PackedStringArray = _declared_functions(source)
	var script: GDScript = load(PLAYER_SCRIPT) as GDScript
	var reflected: PackedStringArray = PackedStringArray()
	for entry: Dictionary in script.get_script_signal_list():
		reflected.append(String(entry["name"]))
	_expect(fields == PLAYER_FIELDS and exports == PLAYER_EXPORTS and functions.size() == PLAYER_FUNCTIONS
			and constants == PLAYER_CONSTANTS and enums == PLAYER_ENUMS and signals == PackedStringArray(PLAYER_SIGNALS)
			and reflected.size() == PLAYER_SIGNALS.size() and source.count(CLEAR_SIGNATURE) == 1
			and source.count(IS_ALIVE_SIGNATURE) == 1 and source.count("func clear_movement_intent(") == 1
			and not source.contains("preserve_fallen"),
		"%d fields, %d exports, %d functions, %d constants, %d enums, signals %s"
			% [fields, exports, functions.size(), constants, enums, ", ".join(signals)])
	print("  %d fields, %d exports, %d functions, %d constants, %d enums and %d signals — the counts before J2; clear_movement_intent keeps its one signature, (reason: String, require_neutral: bool = true), and is_alive() takes nothing"
		% [fields, exports, functions.size(), constants, enums, signals.size()])
	_done("the_player_declares_nothing_new")


func _check_is_alive_is_unchanged() -> void:
	print("")
	print("--- 3. is_alive() is byte-identical: one line, the action state is not FALLEN")
	var source: String = FileAccess.get_file_as_string(PLAYER_SCRIPT)
	var body: String = _function_body(source, "is_alive")
	_expect(_code_lines(body) == PackedStringArray(["return action_state != ActionState.FALLEN"])
			and source.contains(IS_ALIVE_SIGNATURE + "\n\treturn action_state != ActionState.FALLEN\n\n\n"),
		"is_alive() reads %s" % str(_code_lines(body)))
	print("  %s / return action_state != ActionState.FALLEN — no Life test, no modal test, nothing else" % IS_ALIVE_SIGNATURE)
	_done("is_alive_is_unchanged")


func _check_clear_movement_intent_is_the_accepted_body_with_one_fallen_rule() -> void:
	print("")
	print("--- 4. clear_movement_intent() is the accepted body with only its IDLE assignment guarded; receive_damage() and _fall() keep their order")
	var source: String = FileAccess.get_file_as_string(PLAYER_SCRIPT)
	var lines: PackedStringArray = _code_lines(_function_body(source, "clear_movement_intent"))
	var accepted: PackedStringArray = PackedStringArray(CLEAR_LINES)
	accepted.remove_at(accepted.find("if action_state != ActionState.FALLEN:"))
	var rebuilt: PackedStringArray = lines.duplicate()
	var guard: int = rebuilt.find("if action_state != ActionState.FALLEN:")
	if guard >= 0:
		rebuilt.remove_at(guard)
	_expect(lines == PackedStringArray(CLEAR_LINES) and rebuilt == accepted and lines.count("return") == 0
			and _code_lines(_function_body(source, "receive_damage")) == PackedStringArray(RECEIVE_DAMAGE_LINES)
			and _code_lines(_function_body(source, "_fall")) == PackedStringArray(FALL_LINES),
		"clear_movement_intent reads %s" % str(lines))
	print("  %d code lines: the attack cleared, the suspension, the destination, the agent's target, the locomotion and the velocity, then `if action_state != ActionState.FALLEN:` over the accepted `action_state = ActionState.IDLE`, then the mode, the latch and the emission — no early return"
		% lines.size())
	print("  receive_damage() is its 13 accepted lines (Life, then the Hit, then the fall) and _fall() its 18 (FALLEN, the latch, the emission, the clip, then fell)")
	_done("clear_movement_intent_is_the_accepted_body_with_one_fallen_rule")


func _check_the_player_stays_the_only_state_authority() -> void:
	print("")
	print("--- 5. The player is the only writer of its action state, and only revive_for_testing() can leave FALLEN (structural)")
	var code: String = _bare(FileAccess.get_file_as_string(PLAYER_SCRIPT))
	var writers: PackedStringArray = PackedStringArray()
	for name: String in _declared_functions(code):
		if _function_body(code, name).contains("action_state = "):
			writers.append(name)
	var outsiders: PackedStringArray = PackedStringArray()
	var scanned: int = 0
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd"]):
			if path == PLAYER_SCRIPT:
				continue
			scanned += 1
			if _bare(FileAccess.get_file_as_string(path)).contains("action_state = "):
				outsiders.append(path.get_file())
	var move_lines: PackedStringArray = _code_lines(_function_body(code, "command_move_to"))
	var physics_lines: PackedStringArray = _code_lines(_function_body(code, "_physics_process"))
	var clear_lines: PackedStringArray = _code_lines(_function_body(code, "clear_movement_intent"))
	var revive_lines: PackedStringArray = _code_lines(_function_body(code, "revive_for_testing"))
	_expect(writers == PackedStringArray(STATE_WRITERS) and outsiders.is_empty() and scanned > 100
			and move_lines[0] == "if not is_alive():" and physics_lines[0] == "if not is_alive():"
			and clear_lines[clear_lines.find("action_state = ActionState.IDLE") - 1] == "if action_state != ActionState.FALLEN:"
			and code.count("_arrive()") == 2 and _function_body(code, "_path_velocity").contains("_arrive()")
			and code.count("_path_velocity()") == 2 and _function_body(code, "_physics_process").contains("_path_velocity()")
			and revive_lines.has("action_state = ActionState.IDLE") and _function_body(code, "_fall").contains("action_state = ActionState.FALLEN"),
		"the state is written in [%s]; outside the player by [%s]" % [", ".join(writers), ", ".join(outsiders)])
	print("  of %d other running scripts, none writes an action state; inside the player, [%s] do: command_move_to and _physics_process return first for a fallen character, _arrive is reached only through _physics_process, clear_movement_intent guards its IDLE, _fall writes FALLEN, and revive_for_testing alone writes IDLE unconditionally"
		% [scanned, ", ".join(writers)])
	_done("the_player_stays_the_only_state_authority")


func _check_no_modal_or_runtime_carries_a_death_special_case() -> void:
	print("")
	print("--- 6. No modal, overlay or runtime learned about death: the modal contract and both Fallen overlays name no life state, every runtime is unchanged, and no call passes a third argument")
	var namers: PackedStringArray = PackedStringArray()
	for path: String in [MODAL_SCRIPT, FALLEN_SCRIPT, ROGUELITE_FALLEN_SCRIPT]:
		var code: String = _bare(FileAccess.get_file_as_string(path))
		for token: String in DEATH_TOKENS:
			if code.contains(token):
				namers.append("%s names %s" % [path.get_file(), token])
	var widened: PackedStringArray = PackedStringArray()
	var calls: int = 0
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd"]):
			var code: String = _bare(FileAccess.get_file_as_string(path))
			if code.contains("preserve_fallen"):
				widened.append("%s names preserve_fallen" % path.get_file())
			var at: int = code.find("clear_movement_intent(")
			while at >= 0:
				if not code.substr(maxi(at - 5, 0), 5).contains("func "):
					calls += 1
					if _top_level_commas(code, at + "clear_movement_intent(".length()) > 1:
						widened.append("%s passes a third argument" % path.get_file())
				at = code.find("clear_movement_intent(", at + 1)
	_expect(namers.is_empty() and widened.is_empty() and calls >= 20,
		"%s; %s" % [", ".join(namers), ", ".join(widened)])
	print("  0 of %d death tokens in first_mvp_modal.gd, first_mvp_fallen_overlay.gd and roguelite_fallen_overlay.gd; the eight runtimes are at their pre-J2 hashes (check 1); %d running calls of clear_movement_intent, none with a third argument, and no preserve_fallen anywhere"
		% [DEATH_TOKENS.size(), calls])
	_done("no_modal_or_runtime_carries_a_death_special_case")


func _check_no_scene_input_map_or_presentation_changed() -> void:
	print("")
	print("--- 7. The InputMap, the entrypoint and project.godot are untouched; the scenes, both overlays and the HUDs hold their pre-J2 hashes (check 1)")
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	_expect(actions == EXPECTED_ACTIONS and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT
			and not settings.contains("[autoload]") and not settings.contains("fallen_modal"),
		"%d actions, or project.godot moved" % actions)
	print("  %d actions; the entrypoint is %s; project.godot declares no [autoload] and names nothing of J2" % [actions, ENTRYPOINT.get_file()])
	_done("no_scene_input_map_or_presentation_changed")

# --- 8–11. The neutralization itself, on production player fixtures ----------------------------

func _check_a_living_idle_neutralization_is_unchanged() -> void:
	print("")
	print("--- 8. A living IDLE character: clearing arms the latch, aims the agent at the body and ends IDLE; the non-latching form changes nothing more")
	var fixture: PrototypePlayer = _spawn_fixture()
	var heard: Dictionary = _listen(fixture)
	var before: Dictionary = _vars(fixture)
	fixture.clear_movement_intent("j2 idle", true)
	var after: Dictionary = _vars(fixture)
	fixture.clear_movement_intent("j2 idle again", false)
	var again: Dictionary = _vars(fixture)
	_expect(fixture.action_state == PrototypePlayer.ActionState.IDLE and fixture.is_alive()
			and _diff(before, after) == PackedStringArray(["agent_target", "awaiting_neutral", "neutral_reason"])
			and fixture.awaiting_neutral and fixture.neutral_reason == "j2 idle" and _diff(after, again).is_empty()
			and heard["cleared"] == ["j2 idle", "j2 idle again"] and int(heard["life_changed"]) == 0,
		"idle: changed %s, then %s; heard %s" % [str(_diff(before, after)), str(_diff(after, again)), str(heard)])
	print("  IDLE -> IDLE; changed exactly [%s]; the (…, false) form changed nothing; movement_intent_cleared twice, with each reason"
		% ", ".join(_diff(before, after)))
	_done("a_living_idle_neutralization_is_unchanged")


func _check_a_living_navigate_neutralization_is_unchanged() -> void:
	print("")
	print("--- 9. A living NAVIGATE character (STAGED through command_move_to): clearing drops the destination and the mode and ends IDLE")
	var fixture: PrototypePlayer = _spawn_fixture()
	var point: Vector3 = fixture.global_position + Vector3(3.0, 0.0, 0.0)
	fixture.command_move_to(point, point, false)
	var heard: Dictionary = _listen(fixture)
	var before: Dictionary = _vars(fixture)
	var navigating: bool = fixture.action_state == PrototypePlayer.ActionState.NAVIGATE and fixture.has_destination
	fixture.clear_movement_intent("j2 navigate", true)
	var after: Dictionary = _vars(fixture)
	_expect(navigating and fixture.action_state == PrototypePlayer.ActionState.IDLE and not fixture.has_destination
			and fixture.movement_mode == PrototypePlayer.MovementMode.NONE and fixture.velocity == Vector3.ZERO
			and _agent_target(fixture) == fixture.global_position
			and _diff(before, after) == PackedStringArray(["action_state", "agent_target", "awaiting_neutral", "has_destination", "movement_mode", "neutral_reason"])
			and heard["cleared"] == ["j2 navigate"],
		"navigate: navigating %s; changed %s" % [str(navigating), str(_diff(before, after))])
	print("  NAVIGATE (mouse path) -> IDLE; changed exactly [%s]" % ", ".join(_diff(before, after)))
	_done("a_living_navigate_neutralization_is_unchanged")


func _check_a_living_stick_neutralization_is_unchanged() -> void:
	print("")
	print("--- 10. A living character with a commanding stick reading: clearing resets the locomotion kernel and ends IDLE")
	var fixture: PrototypePlayer = _spawn_fixture()
	fixture.set_stick_raw(Vector2(0.9, 0.0))
	var heard: Dictionary = _listen(fixture)
	var before: Dictionary = _vars(fixture)
	var commanding: bool = fixture.stick_is_commanding()
	fixture.clear_movement_intent("j2 stick", true)
	var after: Dictionary = _vars(fixture)
	_expect(commanding and not fixture.stick_is_commanding() and fixture.stick_raw == Vector2.ZERO and fixture.stick_magnitude == 0.0
			and fixture.action_state == PrototypePlayer.ActionState.IDLE
			and _diff(before, after) == PackedStringArray(["agent_target", "awaiting_neutral", "neutral_reason", "stick_magnitude", "stick_raw"])
			and heard["cleared"] == ["j2 stick"],
		"stick: commanding %s; changed %s" % [str(commanding), str(_diff(before, after))])
	print("  a stick of 0.90 commanding -> not commanding, IDLE; changed exactly [%s]" % ", ".join(_diff(before, after)))
	_done("a_living_stick_neutralization_is_unchanged")


func _check_a_fallen_neutralization_clears_controls_and_keeps_fallen() -> void:
	print("")
	print("--- 11. A FALLEN character (STAGED: a stick reading and a velocity left on the body): clearing clears them, re-latches, and leaves FALLEN, Life and every death fact alone")
	var fixture: PrototypePlayer = _spawn_fixture()
	var heard: Dictionary = _listen(fixture)
	fixture.receive_damage(DamageEvent.physical(_use(), null, fixture, fixture.max_life + 1000.0))
	var fallen: bool = not fixture.is_alive() and fixture.life == 0.0 and fixture.neutral_reason == "fallen"
	var at_fall: Dictionary = heard.duplicate(true)
	fixture.set_stick_raw(Vector2(0.9, 0.0))
	fixture.velocity = Vector3(1.5, -2.0, 0.0)
	var before: Dictionary = _vars(fixture)
	fixture.clear_movement_intent("fallen opened", true)
	var after: Dictionary = _vars(fixture)
	fixture.clear_movement_intent("verification", false)
	var again: Dictionary = _vars(fixture)
	var kept: bool = (fixture.action_state == PrototypePlayer.ActionState.FALLEN and not fixture.is_alive() and fixture.life == 0.0
		and fixture.velocity == Vector3.ZERO and fixture.stick_raw == Vector2.ZERO and fixture.movement_mode == PrototypePlayer.MovementMode.NONE
		and not fixture.has_destination and fixture.awaiting_neutral and fixture.neutral_reason == "fallen opened"
		and fixture.attack.phase == QuickStrikeAction.Phase.READY and _agent_target(fixture) == fixture.global_position)
	_expect(fallen and kept and _diff(before, after) == PackedStringArray(["neutral_reason", "stick_magnitude", "stick_raw", "velocity"])
			and _diff(after, again).is_empty() and heard["cleared"] == ["fallen", "fallen opened", "verification"]
			and int(heard["life_changed"]) == int(at_fall["life_changed"]) and int(heard["took_damage"]) == 1 and int(heard["fell"]) == 1,
		"fallen: fell %s, kept %s; changed %s then %s; heard %s" % [str(fallen), str(kept), str(_diff(before, after)), str(_diff(after, again)), str(heard)])

	## The player's own gates now answer honestly: nothing moves, attacks, is hurt or falls again.
	var answers: Array[String] = []
	var answer: Callable = func(status: String, _requested: Vector3, _resolved: Vector3) -> void: answers.append(status)
	fixture.movement_command_resolved.connect(answer)
	var point: Vector3 = fixture.global_position + Vector3(3.0, 0.0, 0.0)
	fixture.command_move_to(point, point, false)
	fixture.movement_command_resolved.disconnect(answer)
	fixture.set_stick_raw(Vector2(0.9, 0.0))
	var events: int = fixture.damage_taken_events
	var last: DamageEvent = fixture.last_damage_taken
	var fallen_at: int = fixture.fallen_at_msec
	fixture.receive_damage(DamageEvent.physical(_use(), null, fixture, 50.0))
	var refused: bool = (answers == ["rejected: fallen"] and not fixture.has_destination and not fixture.stick_is_commanding()
		and fixture.damage_taken_events == events and fixture.last_damage_taken == last and fixture.fallen_at_msec == fallen_at
		and int(heard["fell"]) == 1 and int(heard["took_damage"]) == 1 and fixture.life == 0.0)
	fixture.revive_for_testing()
	var revived: bool = (fixture.is_alive() and fixture.action_state == PrototypePlayer.ActionState.IDLE and fixture.life == fixture.max_life
		and fixture.awaiting_neutral and fixture.neutral_reason == "encounter reset")
	_expect(refused and revived, "after the neutralization: answers %s, refused %s; revive_for_testing() revived %s" % [str(answers), str(refused), str(revived)])
	print("  FALLEN -> FALLEN at 0 / %.0f; changed exactly [%s]; the (…, false) form changed nothing; not one life_changed, took_damage or fell from either call"
		% [fixture.max_life, ", ".join(_diff(before, after))])
	print("  then command_move_to() answered '%s', a live stick did not command, and a 50-damage event was refused; revive_for_testing() alone brought it back, IDLE at full Life with the latch set"
		% (answers[0] if not answers.is_empty() else "nothing"))
	_done("a_fallen_neutralization_clears_controls_and_keeps_fallen")


## One production player, whole, on this harness's own stage, far from every room and with its
## processing disabled.
func _spawn_fixture() -> PrototypePlayer:
	_fixture_players += 1
	var fixture: PrototypePlayer = (load(PLAYER_SCENE) as PackedScene).instantiate() as PrototypePlayer
	fixture.name = "J2Player%d" % _fixture_players
	fixture.process_mode = Node.PROCESS_MODE_DISABLED
	fixture.position = Vector3(400.0 + 4.0 * float(_fixture_players), 40.0, 400.0)
	_stage.add_child(fixture)
	return fixture


## Counts what a player says: every reason it clears with, and each Life, Hit and fall.
func _listen(player: PrototypePlayer) -> Dictionary:
	var heard: Dictionary = {"cleared": [], "life_changed": 0, "took_damage": 0, "fell": 0}
	player.movement_intent_cleared.connect(func(reason: String) -> void: (heard["cleared"] as Array).append(reason))
	player.life_changed.connect(func(_current: float, _maximum: float) -> void: heard["life_changed"] = int(heard["life_changed"]) + 1)
	player.took_damage.connect(func(_event: DamageEvent) -> void: heard["took_damage"] = int(heard["took_damage"]) + 1)
	player.fell.connect(func(_event: DamageEvent) -> void: heard["fell"] = int(heard["fell"]) + 1)
	return heard


## Every script variable the player holds, plus its velocity, its position and its agent's target,
## each as text; an object as its identity.
func _vars(player: PrototypePlayer) -> Dictionary:
	var out: Dictionary = {}
	for property: Dictionary in player.get_property_list():
		if int(property["usage"]) & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var value: Variant = player.get(String(property["name"]))
			if typeof(value) == TYPE_OBJECT:
				var object: Object = value as Object
				out[String(property["name"])] = "object %d" % (object.get_instance_id() if object != null else 0)
			else:
				out[String(property["name"])] = var_to_str(value)
	out["velocity"] = var_to_str(player.velocity)
	out["global_position"] = var_to_str(player.global_position)
	out["agent_target"] = var_to_str(_agent_target(player))
	return out


func _diff(before: Dictionary, after: Dictionary) -> PackedStringArray:
	var changed: PackedStringArray = PackedStringArray()
	for key: Variant in before:
		if not after.has(key) or String(after[key]) != String(before[key]):
			changed.append(String(key))
	changed.sort()
	return changed


func _agent_target(player: PrototypePlayer) -> Vector3:
	return (player.get_node("NavigationAgent3D") as NavigationAgent3D).target_position

# --- 12–18. Gate 1D's own slice ------------------------------------------------------------------

func _gate_1d_phase() -> void:
	slice = await _load(SLICE_SCENE) as BrokenWatchSlice
	if slice == null:
		return
	await _await_navigation(slice)
	for enemy: PrototypeGraveblade in slice.graveblades:
		enemy.set_ai_enabled(false)
	_note("Gate 1D's two Graveblades quieted and placed; the first killed through receive_damage() so the guaranteed drop exists")
	await _check_gate_1d_living_modals_still_neutralize_to_idle()

	var start: Vector3 = slice.landing_layout.player_start()
	var killer: PrototypeGraveblade = slice.graveblades[1]
	var first: Dictionary = await _die(slice, killer, start, "gate 1d — focused confirm", true, Callable(), Callable())
	_check_gate_1d_the_delay_keeps_the_player_fallen_with_no_modal(first)
	_check_gate_1d_opening_fallen_changes_no_death_fact(first)
	await _stand_behind_the_overlay(slice, first, Callable())
	_check_gate_1d_the_paused_fallen_player_can_do_nothing(first)
	await _restart_gate_1d(first, "confirm")
	_check_gate_1d_restart_by_focused_confirm(first)

	var second: Dictionary = await _die(slice, killer, start, "gate 1d — real left click", true, Callable(), Callable())
	await _stand_behind_the_overlay(slice, second, Callable())
	await _restart_gate_1d(second, "click")
	_check_gate_1d_restart_by_a_real_left_click_without_click_through(second)

	var third: Dictionary = await _die(slice, killer, start, "gate 1d — F5 with the overlay standing", true, Callable(), Callable())
	await _stand_behind_the_overlay(slice, third, Callable())
	await _restart_gate_1d(third, "f5")
	_check_gate_1d_restart_by_f5_while_the_overlay_stands(third)


func _check_gate_1d_living_modals_still_neutralize_to_idle() -> void:
	print("")
	print("--- 12. Gate 1D, living: the item comparison, opened on its own path, still neutralizes an IDLE, a NAVIGATE, a Quick Strike wind-up and a stick to IDLE, pauses and focuses Close")
	var player: PrototypePlayer = slice.player
	var start: Vector3 = slice.landing_layout.player_start()
	var forward: Vector3 = _forward(slice)
	var first: PrototypeGraveblade = slice.graveblades[0]
	var second: PrototypeGraveblade = slice.graveblades[1]
	first.place_at(start + forward * 6.0)
	_kill(slice, first)
	await _settle(3)
	var readings: Array[Dictionary] = []

	_stand_facing(slice, start, forward)
	await _until_neutral(slice)
	readings.append(await _open_living("IDLE"))

	await _until_neutral(slice)
	var goal: Dictionary = PrototypeGroundPointer.resolve_to_navigation(slice.navigation_map(), start + forward * 5.0)
	var destination: Vector3 = goal["point"]
	player.command_move_to(destination, destination, false)
	await _settle(4)
	readings.append(await _open_living("NAVIGATE"))

	_stand_facing(slice, start, forward)
	await _until_neutral(slice)
	second.place_at(start + forward * 1.0)
	second.face_instantly(-forward)
	await _settle(2)
	var life_before: float = second.life
	slice.force_next_aim_for_verification(second.get_node("TargetArea") as PrototypeTargetable)
	player.attack.press()
	player.attack.release_input()
	await _settle(2)
	readings.append(await _open_living("QUICK STRIKE"))
	_note("a living Quick Strike begun through the room's forced-aim seam and attack.press(), and a living NAVIGATE through command_move_to()")

	_stand_facing(slice, start, forward)
	await _until_neutral(slice)
	_parse_stick(1.0)
	await _settle(5)
	readings.append(await _open_living("STICK"))

	var found_ok: bool = (readings.size() == 4
		and readings[0]["found"]["state"] == "IDLE"
		and readings[1]["found"]["state"] == "NAVIGATE" and bool(readings[1]["found"]["destination"]) and bool(readings[1]["found"]["moving"])
		and bool(readings[2]["found"]["busy"]) and readings[2]["found"]["phase"] == "ATTACK_WINDUP"
		and readings[3]["found"]["state"] == "NAVIGATE" and readings[3]["found"]["mode"] == "controller direct"
		and bool(readings[3]["found"]["stick"]) and bool(readings[3]["found"]["moving"]))
	var faults: PackedStringArray = PackedStringArray()
	for reading: Dictionary in readings:
		for key: Variant in reading["left"]:
			if not bool(reading["left"][key]):
				faults.append("%s: %s" % [reading["label"], key])
	_expect(found_ok and faults.is_empty() and int(readings[2]["cancelled"]) == 1 and second.life == life_before,
		"found %s; left faults %s; the wind-up cancelled %s, the target at %s" % [
			str(readings.map(func(r: Dictionary) -> Variant: return r["found"])), ", ".join(faults), str(readings[2]["cancelled"]), str(second.life)])
	for reading: Dictionary in readings:
		_living.append(reading)
		var found: Dictionary = reading["found"]
		print("  %s (%s, %s, attack %s) -> IDLE, mode none, no destination, no velocity, stick at rest, attack READY with no target or buffer, latched as 'comparison opened', paused, Close focused; 10 paused frames moved nothing; Escape closed it"
			% [reading["label"], found["state"], found["mode"], found["phase"]])
	print("  the wind-up was cancelled before its release (1 cancelled use); the Graveblade it aimed at still holds %.0f Life" % second.life)
	_done("gate_1d_living_modals_still_neutralize_to_idle")


## Reads what the living character is doing, opens the item comparison through the room's own
## `open_item_comparison()`, reads what the contract's neutralization left, holds the paused world
## for 10 frames, then closes it with Escape and waits for the neutral latch to lift.
func _open_living(label: String) -> Dictionary:
	var player: PrototypePlayer = slice.player
	var panel: FirstMvpItemComparison = slice.item_comparison
	var found: Dictionary = {
		"state": player.action_state_name(), "mode": player.movement_mode_name(), "moving": player.planar_speed() > 0.1,
		"busy": player.attack.busy(), "phase": player.attack.phase_name(), "destination": player.has_destination,
		"stick": player.stick_is_commanding(),
	}
	var cancelled: int = player.attack.uses_cancelled_before_release
	slice.open_item_comparison("verification")
	var at: Vector3 = player.global_position
	var left: Dictionary = {
		"open": panel.is_open, "paused": paused, "idle": player.action_state == PrototypePlayer.ActionState.IDLE and player.is_alive(),
		"mode": player.movement_mode == PrototypePlayer.MovementMode.NONE, "velocity": player.velocity == Vector3.ZERO,
		"no destination": not player.has_destination, "agent": _agent_target(player) == player.global_position,
		"stick at rest": player.stick_raw == Vector2.ZERO and not player.stick_is_commanding(),
		"attack ready": player.attack.phase == QuickStrikeAction.Phase.READY and not player.attack.buffered
			and not player.attack.holding and player.attack.target == null,
		"latched": player.awaiting_neutral and player.neutral_reason == "comparison opened",
		"focus": root.gui_get_focus_owner() == panel.default_focus() and panel.default_focus() != null,
	}
	var uses: int = player.attack.uses_started
	await _settle(10)
	left["held"] = (paused and player.global_position == at and player.action_state == PrototypePlayer.ActionState.IDLE
		and player.attack.uses_started == uses)
	if label == "STICK":
		_parse_stick(0.0)
	await _key(KEY_ESCAPE)
	left["closed"] = not panel.is_open and not paused
	await _until_neutral(slice)
	return {"label": label, "found": found, "left": left, "cancelled": player.attack.uses_cancelled_before_release - cancelled}

func _check_gate_1d_the_delay_keeps_the_player_fallen_with_no_modal(record: Dictionary) -> void:
	print("")
	print("--- 13. Gate 1D: a real Graveblade kills the player; on the lethal frame and every frame of the delay the player is FALLEN at 0 with no modal open and no enemy acting")
	var delay_faults: PackedStringArray = record["delay_faults"]
	_expect(_lethal_ok(record) and int(record["delay_samples"]) > 0 and delay_faults.is_empty() and bool(record["opened"]),
		"lethal %s; %d delay samples, faults %s; opened %s" % [str(record["lethal"]), int(record["delay_samples"]), ", ".join(delay_faults), str(record["opened"])])
	print("  %d of the Graveblade's own attacks: Life %s; on the lethal frame FALLEN, not alive, no modal, not paused, no attack permission held, 0 Graveblades acting"
		% [int(record["began"]), _trail_text(record)])
	print("  every one of the %d idle frames before the overlay opened read the same" % int(record["delay_samples"]))
	_done("gate_1d_the_delay_keeps_the_player_fallen_with_no_modal")


func _check_gate_1d_opening_fallen_changes_no_death_fact(record: Dictionary) -> void:
	print("")
	print("--- 14. Gate 1D: the Fallen overlay's own opening — read inside its neutralization, and after it — changes no death fact")
	_expect(_opening_ok(record), "before %s; at the neutralization %s; after %s; cleared %s" % [
		str(record["before_open"]), str(record["at_open"]), str(record["open_facts"]), str(record["cleared_reasons"])])
	var facts: Dictionary = record["open_facts"]
	print("  inside open()'s neutralization and after it: FALLEN, not alive, Life %s / %s, the same fallen_at_msec, %d DamageEvents, the same killing event, Mana %s, the same weapon, position and facing; movement_intent_cleared said [%s]; the latch reads 'fallen opened'"
		% [_n(float(facts["life"])), _n(float(facts["max_life"])), int(facts["events"]), _n(float(facts["mana"])), ", ".join(record["cleared_reasons"] as PackedStringArray)])
	_done("gate_1d_opening_fallen_changes_no_death_fact")


func _check_gate_1d_the_paused_fallen_player_can_do_nothing(record: Dictionary) -> void:
	print("")
	print("--- 15. Gate 1D: behind the standing overlay, 30 paused physics frames and 10 idle frames — a left press, a right press, a held stick and a movement command — move nothing")
	_expect(_standing_ok(record) and _skill_actions(slice) == 0, "standing %s" % str(record["standing"]))
	print("  %s" % _standing_text(record))
	print("  Gate 1D's slice carries 0 Foundation Skill actions, so none can begin")
	_done("gate_1d_the_paused_fallen_player_can_do_nothing")


func _check_gate_1d_restart_by_focused_confirm(record: Dictionary) -> void:
	print("")
	print("--- 16. Gate 1D: Enter on the focused \"Restart Broken Watch\" restarts once, revives once and reopens nothing")
	_expect(_gate_1d_restart_ok(record), "restart %s" % str(record["restart"]))
	var restart: Dictionary = record["restart"]
	print("  %s" % _restart_text(record))
	print("  in the restart's own call the character stood %.3f m from Broken Watch's entry; once its body had settled, %.2f m — where every Gate 1D restart leaves it"
		% [float(restart["entry_gap"]), float(restart["settled_gap"])])
	_done("gate_1d_restart_by_focused_confirm")


func _check_gate_1d_restart_by_a_real_left_click_without_click_through(record: Dictionary) -> void:
	print("")
	print("--- 17. Gate 1D: one real left click on \"Restart Broken Watch\" (J1) restarts once; nothing of the click reaches the world")
	var restart: Dictionary = record["restart"]
	var click: Dictionary = restart["click"]
	_expect(_gate_1d_restart_ok(record) and bool(click.get("under", false)) and _one_press(click) and bool(restart["through"]),
		"restart %s" % str(restart))
	print("  one left press and release through Input.parse_input_event(): one pressed, on that button; %s" % _restart_text(record))
	print("  read after the next frame's input flush, the character stood %.3f m from where the focused-confirm restart's body settled"
		% _planar_gap(slice.player.global_position, _gate_1d_settled))
	print("  over the 20 physics frames after it: no destination, no attack, no movement, no modal, and the left button no longer held")
	_done("gate_1d_restart_by_a_real_left_click_without_click_through")


func _check_gate_1d_restart_by_f5_while_the_overlay_stands(record: Dictionary) -> void:
	print("")
	print("--- 18. Gate 1D: F5 with the overlay standing takes the overlay's own quick_restart path, once")
	_expect(_gate_1d_restart_ok(record), "restart %s" % str(record["restart"]))
	print("  %s" % _restart_text(record))
	_done("gate_1d_restart_by_f5_while_the_overlay_stands")


# --- The death, the standing overlay and the restart, shared by both runtimes ---------------------

## STAGED start, real death: the player is placed at `at`, facing the route, and `killer` 1.2 m in
## front of it; each attack is begun through the Graveblade's own verification seam and everything
## after that is the attack's own. Waits for the overlay unless told not to. `after_lethal` runs on the
## lethal frame; `extra` adds a runtime's own faults to every frame of the delay.
func _die(room: BrokenWatchSlice, killer: PrototypeGraveblade, at: Vector3, label: String, wait_for_overlay: bool,
		after_lethal: Callable, extra: Callable) -> Dictionary:
	var player: PrototypePlayer = room.player
	var forward: Vector3 = _forward(room)
	await _until_neutral(room)
	_stand_facing(room, at, forward)
	killer.set_ai_enabled(false)
	killer.place_at(at + forward * NEAR)
	killer.face_instantly(-forward)
	await _settle(2)
	var counts: Dictionary = {"life_changed": 0, "took_damage": 0, "fell": 0}
	var emissions: Array[Dictionary] = []
	var cleared: Array[Dictionary] = []
	var record: Dictionary = {
		"label": label, "roguelite": room is RogueliteCoreLoopRuntime, "killer": killer.get_instance_id(),
		"record_damage": float((load(GRAVEBLADE_RECORD) as Resource).get("physical_damage")),
		"life_before": player.life, "max_before": player.max_life, "trail": [], "began": 0,
		"counts": counts, "emissions": emissions, "cleared": cleared,
	}
	var on_life: Callable = func(current: float, maximum: float) -> void:
		counts["life_changed"] = int(counts["life_changed"]) + 1
		emissions.append({"life": current, "max": maximum, "state": player.action_state_name(),
			"awaiting": player.awaiting_neutral, "reason": player.neutral_reason})
	var on_damage: Callable = func(_event: DamageEvent) -> void: counts["took_damage"] = int(counts["took_damage"]) + 1
	var on_fell: Callable = func(_event: DamageEvent) -> void: counts["fell"] = int(counts["fell"]) + 1
	var on_cleared: Callable = func(reason: String) -> void: cleared.append({"reason": reason, "facts": _facts(room, counts)})
	player.life_changed.connect(on_life)
	player.took_damage.connect(on_damage)
	player.fell.connect(on_fell)
	player.movement_intent_cleared.connect(on_cleared)
	record["listeners"] = [on_life, on_damage, on_fell, on_cleared]

	for guard: int in 8:
		if not player.is_alive():
			break
		var taken: int = player.damage_taken_events
		var began: bool = false
		for attempt: int in 120:
			began = killer.begin_attack_for_verification()
			if began:
				break
			await physics_frame
		if not began:
			break
		record["began"] = int(record["began"]) + 1
		for frame: int in 180:
			await physics_frame
			if player.damage_taken_events > taken:
				break
		(record["trail"] as Array).append(player.life)

	var event: DamageEvent = player.last_damage_taken
	record["lethal"] = {
		"state": player.action_state_name(), "alive": player.is_alive(), "life": player.life, "modal": _any_modal_open(room),
		"paused": paused, "holder": room.attack_coordinator.holder() == null, "acting": _ai_count(room),
	}
	record["killing"] = {
		"from_killer": event != null and event.source == killer, "raw": 0.0 if event == null else event.raw_physical_damage,
		"final": 0.0 if event == null else event.final_life_damage, "use": -1 if event == null else event.use_id,
		"event": 0 if event == null else event.get_instance_id(), "fallen_at": player.fallen_at_msec,
	}
	record["lethal_facts"] = _facts(room, counts)
	if after_lethal.is_valid():
		after_lethal.call(record)
	if not wait_for_overlay:
		_deaths.append(record)
		return record

	var samples: int = 0
	var faults: PackedStringArray = PackedStringArray()
	var last: Dictionary = _facts(room, counts)
	for frame: int in 600:
		if room.fallen_overlay.is_open:
			break
		last = _facts(room, counts)
		if not (last["state"] == "FALLEN" and not bool(last["alive"]) and float(last["life"]) == 0.0 and not _any_modal_open(room)
				and room.attack_coordinator.holder() == null and _ai_count(room) == 0 and not paused):
			faults.append("delay frame %d" % samples)
		if extra.is_valid():
			faults.append_array(extra.call("delay frame %d" % samples) as PackedStringArray)
		samples += 1
		await process_frame
	record["delay_samples"] = samples
	record["delay_faults"] = faults
	record["opened"] = room.fallen_overlay.is_open
	record["before_open"] = last
	record["open_facts"] = _facts(room, counts)
	record["open_latch"] = player.awaiting_neutral and player.neutral_reason == "fallen opened"
	var reasons: PackedStringArray = PackedStringArray()
	record["at_open"] = {}
	for entry: Dictionary in cleared:
		reasons.append(String(entry["reason"]))
		if entry["reason"] == "fallen opened":
			record["at_open"] = entry["facts"]
	record["cleared_reasons"] = reasons
	_deaths.append(record)
	return record


## Behind the standing overlay: 30 paused physics frames and then 10 idle frames, with a left press on
## the backdrop, a right press over the overlay's own button, a full stick held and released, and the
## player's own `command_move_to()` asked once — every frame read for any change. Then one more
## DamageEvent through the production intake.
func _stand_behind_the_overlay(room: BrokenWatchSlice, record: Dictionary, extra: Callable) -> void:
	var player: PrototypePlayer = room.player
	var overlay: FirstMvpFallenOverlay = room.fallen_overlay
	var counts: Dictionary = record["counts"]
	var button: Button = _named(overlay, _restart_caption(overlay))
	var start: Dictionary = _facts(room, counts)
	var enemies: Array[String] = _enemy_snapshot(room)
	var uses: int = player.attack.uses_started
	var closes: int = overlay.closes
	var focused: bool = button != null and root.gui_get_focus_owner() == button and overlay.default_focus() == button
	var answers: Array[String] = []
	var answer: Callable = func(status: String, _requested: Vector3, _resolved: Vector3) -> void: answers.append(status)
	player.movement_command_resolved.connect(answer)
	var faults: PackedStringArray = PackedStringArray()
	var dim: Control = overlay.get_node("Dim") as Control
	var on_dim: Control = null
	var on_button: Control = null
	_watch(overlay)
	for frame: int in 30:
		if frame == 4:
			on_dim = _click_at(Vector2(40.0, 40.0), MOUSE_BUTTON_LEFT)
		elif frame == 8 and button != null:
			on_button = _click_at(button.get_global_rect().get_center(), MOUSE_BUTTON_RIGHT)
		elif frame == 12:
			_parse_stick(1.0)
		elif frame == 16:
			var point: Vector3 = player.global_position + _forward(room) * 3.0
			player.command_move_to(point, point, false)
		elif frame == 24:
			_parse_stick(0.0)
		await physics_frame
		faults.append_array(_fallen_faults(room, start, enemies, uses, closes, "physics frame %d" % frame, extra))
	for frame: int in 10:
		await process_frame
		faults.append_array(_fallen_faults(room, start, enemies, uses, closes, "idle frame %d" % frame, extra))
	var fired: int = _total_fired()
	_unwatch()
	player.movement_command_resolved.disconnect(answer)
	var killer: PrototypeGraveblade = instance_from_id(int(record["killer"])) as PrototypeGraveblade
	var before: Dictionary = _facts(room, counts)
	player.receive_damage(DamageEvent.physical(_use(), killer, player, float(record["record_damage"])))
	var after: Dictionary = _facts(room, counts)
	record["standing"] = {
		"faults": faults, "focused": focused, "on_dim": on_dim == dim, "on_button": on_button == button and button != null,
		"fired": fired, "answers": answers, "refused": before == after and after == start, "fade": overlay.modulate.a,
		"still_open": overlay.is_open and paused, "labels": _overlay_labels(overlay), "glyph": _glyph_ok(room, button),
		"end_facts": after, "script": (overlay.get_script() as GDScript).resource_path, "source": overlay.killing_source,
	}


func _fallen_faults(room: BrokenWatchSlice, start: Dictionary, enemies: Array[String], uses: int, closes: int, label: String,
		extra: Callable) -> PackedStringArray:
	var player: PrototypePlayer = room.player
	var counts: Dictionary = _deaths.back()["counts"]
	var faults: PackedStringArray = PackedStringArray()
	if not (paused and room.fallen_overlay.is_open and room.fallen_overlay.closes == closes and _facts(room, counts) == start
			and player.velocity == Vector3.ZERO and not player.has_destination and player.movement_mode == PrototypePlayer.MovementMode.NONE
			and player.attack.phase == QuickStrikeAction.Phase.READY and player.attack.uses_started == uses
			and not player.stick_is_commanding() and player.stick_magnitude == 0.0 and room.attack_coordinator.holder() == null
			and _enemy_snapshot(room) == enemies and _total_fired() == 0):
		faults.append(label)
	if extra.is_valid():
		faults.append_array(extra.call(label) as PackedStringArray)
	return faults


## Gate 1D's Restart, by `method`: Enter on the focused button, one real left click through
## `Input.parse_input_event()`, or F5. Then — the Graveblades STAGED quiet again — the 20 frames after
## a click, and a wait longer than the whole Fallen delay and fade for an overlay that must not come.
func _restart_gate_1d(record: Dictionary, method: String) -> void:
	var player: PrototypePlayer = slice.player
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var button: Button = _named(overlay, "Restart Broken Watch")
	var closes: int = overlay.closes
	var opens: int = overlay.opens
	var restarts: int = _log_count(slice, "slice restarted")
	var emissions: Array[Dictionary] = record["emissions"]
	var mark: int = emissions.size()
	var click: Dictionary = {}
	match method:
		"confirm":
			_push_key(KEY_ENTER, true)
		"f5":
			_push_key(KEY_F5, true)
		"click":
			click = await _parse_click(overlay, button)
	var spawns: Array[Vector3] = [slice.broken_watch.first_encounter_spawn(), slice.broken_watch.second_encounter_spawn()]
	var enemies_ok: bool = true
	for index: int in slice.graveblades.size():
		var enemy: PrototypeGraveblade = slice.graveblades[index]
		enemies_ok = (enemies_ok and enemy.is_alive() and enemy.life == enemy.data.max_life and enemy.ai_enabled
			and _planar_gap(enemy.global_position, spawns[index]) < 0.6)
	var restart: Dictionary = {
		"method": method, "click": click,
		"closed_once": not overlay.is_open and overlay.closes == closes + 1 and overlay.opens == opens,
		"restarted_once": _log_count(slice, "slice restarted") == restarts + 1,
		"alive": player.is_alive() and player.action_state == PrototypePlayer.ActionState.IDLE,
		"full": player.life == player.max_life and player.max_life == float(record["max_before"]) and player.mana == player.max_mana,
		"revivals": emissions.slice(mark),
		"entry_gap": _planar_gap(player.global_position, slice.broken_watch.entry()),
		"at_entry": (_planar_gap(player.global_position, _gate_1d_settled) < 0.05 if method == "click"
			else _planar_gap(player.global_position, slice.broken_watch.entry()) < 0.05),
		"enemies": enemies_ok, "permission": slice.attack_coordinator.holder() == null, "running": not paused,
		"instrumentation": player.damage_taken_events == 0 and player.last_damage_taken == null and player.fallen_at_msec == 0,
		"loadout": slice.loadout != null and player.weapon == slice.loadout.equipped_weapon,
	}
	if method != "click":
		_push_key(KEY_ENTER if method == "confirm" else KEY_F5, false)
	for enemy: PrototypeGraveblade in slice.graveblades:
		enemy.set_ai_enabled(false)
	restart["through"] = true
	if method == "click":
		restart["through"] = await _after_close(slice, player.global_position, player.attack.uses_started)
	await _wait_seconds(BrokenWatchSlice.FALLEN_DELAY + FirstMvpFallenOverlay.FADE_SECONDS + 0.4)
	restart["no_later_overlay"] = overlay.opens == opens and not overlay.is_open and player.is_alive() and not paused
	restart["settled_gap"] = _planar_gap(player.global_position, slice.broken_watch.entry())
	if method == "confirm":
		_gate_1d_settled = player.global_position
	record["restart"] = restart
	_disconnect(player, record)


## One revival, exactly as `revive_for_testing()` makes it: full Life, IDLE, the latch set to "encounter reset".
func _gate_1d_restart_ok(record: Dictionary) -> bool:
	if not record.has("restart"):
		return false
	var restart: Dictionary = record["restart"]
	var revivals: Array = restart["revivals"]
	return (bool(restart["closed_once"]) and bool(restart["restarted_once"]) and bool(restart["alive"]) and bool(restart["full"])
		and revivals.size() == 1 and _is_revival(revivals[0] as Dictionary, float(record["max_before"]))
		and bool(restart["at_entry"]) and bool(restart["enemies"]) and bool(restart["permission"]) and bool(restart["running"])
		and bool(restart["instrumentation"]) and bool(restart["loadout"]) and bool(restart["no_later_overlay"]))


func _restart_text(record: Dictionary) -> String:
	var restart: Dictionary = record["restart"]
	return "the overlay closed once, one restart_current_slice(), one revival (life_changed %s, IDLE, latched 'encounter reset'); Broken Watch's entry, both Graveblades at full Life at their spawns and active, no permission held, instrumentation reset; no Fallen overlay in the %.2f s after" % [
		_revival_text(restart["revivals"] as Array), BrokenWatchSlice.FALLEN_DELAY + FirstMvpFallenOverlay.FADE_SECONDS + 0.4]

# --- 19–27. The roguelite: the I3 live-effect review -----------------------------------------------

## The run's own readings a fallen character must not move, captured on the lethal frame.
var _corpse_run: Dictionary = {}
var _corpse_mote: Dictionary = {}


func _roguelite_phase() -> void:
	review = await _load(REVIEW_SCENE) as RogueliteLiveEffectReview
	if review == null:
		return
	await _await_navigation(review)

	await _begin_expedition_a()
	await _open_level_one()
	_take_support()
	await _settle(4)
	await _award_and_wait([LEVEL_TWO_AMOUNT])
	_take_support()
	await _settle(4)
	await _award_and_wait(CHAIN_AMOUNTS)
	_take_support()
	_take_support()
	await _choose_vitality()
	await _settle(4)
	_note("the I3 review driven through I14's seed-99 route to Vitality: route experience to 75, the rest awarded by production Graveblades registered with H8 and killed (D-315 ruling 1)")
	_check_roguelite_vitality_is_held_at_575_and_living_offers_neutralize_to_idle()

	var centre: Vector3 = _elite_hall_centre()
	_quiet_room(2)
	review.room_enemies[2][0].place_at(centre - _forward(review) * 7.0)
	var escort: PrototypeGraveblade = review.room_enemies[2][1]
	var at_575: Dictionary = await _die(review, escort, centre, "roguelite — 0 / 575, real left click", true,
		_drop_corpse_mote, _roguelite_faults)
	_check_roguelite_the_delay_and_the_open_overlay_keep_the_player_fallen_at_0_of_575(at_575)
	await _stand_behind_the_overlay(review, at_575, _roguelite_faults)
	_check_roguelite_no_sweep_pickup_experience_or_offer_while_fallen(at_575)
	_check_roguelite_the_paused_fallen_player_can_do_nothing(at_575)
	await _return_roguelite(at_575, "click")
	_check_roguelite_a_real_left_click_returns_to_the_nexus_and_restores_the_baseline(at_575)

	var by_confirm: Dictionary = await _die_in_the_teaching_hall("roguelite — focused confirm", true)
	await _stand_behind_the_overlay(review, by_confirm, _roguelite_faults)
	await _return_roguelite(by_confirm, "confirm")
	_check_roguelite_focused_confirm_returns_once(by_confirm)

	var by_f5: Dictionary = await _die_in_the_teaching_hall("roguelite — F5 with the overlay standing", true)
	await _stand_behind_the_overlay(review, by_f5, _roguelite_faults)
	await _return_roguelite(by_f5, "f5")
	_check_roguelite_f5_while_the_overlay_stands_returns_once(by_f5)

	var in_delay: Dictionary = await _die_in_the_teaching_hall("roguelite — F5 inside the delay", false)
	await _settle(3)
	in_delay["before_f5"] = {"state": review.player.action_state_name(), "alive": review.player.is_alive(),
		"open": review.fallen_overlay.is_open, "opens": review.fallen_overlay.opens}
	await _return_roguelite(in_delay, "f5-delay")
	_check_roguelite_f5_inside_the_delay_cancels_the_overlay(in_delay)

	await _walk_into_gate(review, review.hub_module.exit_point())
	_check_the_next_expedition_begins_clean()


func _check_roguelite_vitality_is_held_at_575_and_living_offers_neutralize_to_idle() -> void:
	print("")
	print("--- 19. The roguelite, living: Vitality is taken at the Level 5 fallback and Maximum Life is live at 575 / 575; every level-up offer opened on a living character left it IDLE, latched and paused")
	var player: PrototypePlayer = review.player
	var magnitude: float = PassiveCardCatalogue.record(PassiveCardCatalogue.VITALITY_ID).magnitude
	var want: PlayerStatValue = PlayerStats.apply(PlayerStats.MAXIMUM_LIFE, player.maximum_life_baseline(), magnitude)
	var offers: Array[Dictionary] = []
	for reading: Dictionary in _living:
		if String(reading["label"]).begins_with("offer"):
			offers.append(reading)
	var faults: PackedStringArray = PackedStringArray()
	for reading: Dictionary in offers:
		for key: Variant in reading["left"]:
			if not bool(reading["left"][key]):
				faults.append("%s: %s" % [reading["label"], key])
	_expect(review.mote_runtime != null and review.mote_runtime.level() == 6
			and review.mote_runtime.run_build().acquisitions_for(PassiveCardCatalogue.VITALITY_ID) == 1
			and want.ok and player.max_life == want.value and player.life == want.value and roundi(want.value) == 575
			and player.increased_maximum_life() == magnitude and player.maximum_life_baseline() == 500.0
			and player.is_alive() and not paused and offers.size() == 3 and faults.is_empty(),
		"level %d, %s / %s, +%s; %d offer readings, faults %s" % [review.mote_runtime.level() if review.mote_runtime != null else -1,
			_n(player.life), _n(player.max_life), str(player.increased_maximum_life()), offers.size(), ", ".join(faults)])
	print("  Rift level 6 holding one Vitality: Life %s / %s — C1's answer for %s on the unmodified %s — alive and not paused"
		% [_n(player.life), _n(player.max_life), PlayerStats.format_increased(magnitude), _n(player.maximum_life_baseline())])
	print("  3 offers opened through the contract on a living character (Levels 1, 2 and 3; 4 and 5 replaced them in place): each left it IDLE, latched as 'level-up offer opened', and the world paused")
	_done("roguelite_vitality_is_held_at_575_and_living_offers_neutralize_to_idle")


func _check_roguelite_the_delay_and_the_open_overlay_keep_the_player_fallen_at_0_of_575(record: Dictionary) -> void:
	print("")
	print("--- 20. The roguelite: five of the escort's own Hits take 575 to 0; the delay and the overlay's own opening leave the player FALLEN at 0 / 575 with Maximum Life still +15%")
	var facts: Dictionary = record["open_facts"]
	var delay_faults: PackedStringArray = record["delay_faults"]
	_expect(_lethal_ok(record) and int(record["delay_samples"]) > 0 and delay_faults.is_empty() and _opening_ok(record)
			and roundi(float(record["max_before"])) == 575 and float(facts["max_life"]) == float(record["max_before"])
			and float(facts["increased"]) == PassiveCardCatalogue.record(PassiveCardCatalogue.VITALITY_ID).magnitude
			and float(facts["baseline"]) == 500.0 and _trail_ok(record),
		"lethal %s; delay faults %s; opening %s; facts %s" % [str(record["lethal"]), ", ".join(delay_faults), str(_opening_ok(record)), str(facts)])
	print("  %d of the escort's own attacks: Life %s; every one of the %d idle frames of the delay FALLEN at 0 with no modal and no enemy acting"
		% [int(record["began"]), _trail_text(record), int(record["delay_samples"])])
	print("  inside the overlay's own neutralization and after it: FALLEN, not alive, Life 0 / %s, Maximum Life %s over a baseline of %s; movement_intent_cleared said [%s]"
		% [_n(float(facts["max_life"])), PlayerStats.format_increased(float(facts["increased"])), _n(float(facts["baseline"])),
			", ".join(record["cleared_reasons"] as PackedStringArray)])
	_done("roguelite_the_delay_and_the_open_overlay_keep_the_player_fallen_at_0_of_575")


func _check_roguelite_no_sweep_pickup_experience_or_offer_while_fallen(record: Dictionary) -> void:
	print("")
	print("--- 21. The roguelite, STAGED: a mote worth %s lies under the fallen character; through the delay and behind the overlay it is never swept, no experience is paid, no offer opens and no choice is taken" % _n(CORPSE_MOTE))
	var standing: Dictionary = record["standing"]
	var reading: Dictionary = _run_reading()
	_expect(bool(_corpse_mote.get("placed", false)) and (record["delay_faults"] as PackedStringArray).is_empty()
			and (standing["faults"] as PackedStringArray).is_empty() and reading == _corpse_run
			and int(reading["uncollected"]) == int(_corpse_mote["uncollected_before"]) + 1 and float(reading["experience"]) == 0.0
			and int(reading["level"]) == 6 and not bool(reading["offer_open"]),
		"the mote %s; the run now %s against %s" % [str(_corpse_mote), str(reading), str(_corpse_run)])
	print("  the mote was dropped at the corpse's feet (uncollected %d -> %d); %d sweeps before, the same after; experience %s at Rift level %d; %d offer openings, %d choices, the offer panel closed — unchanged through the delay, 30 paused physics frames and 10 idle frames"
		% [int(_corpse_mote["uncollected_before"]), int(reading["uncollected"]), int(reading["sweeps"]), _n(float(reading["experience"])),
			int(reading["level"]), int(reading["offer_calls"]), int(reading["choices"])])
	_done("roguelite_no_sweep_pickup_experience_or_offer_while_fallen")


func _check_roguelite_the_paused_fallen_player_can_do_nothing(record: Dictionary) -> void:
	print("")
	print("--- 22. The roguelite: behind the standing overlay, 30 paused physics frames and 10 idle frames — a left press, a right press, a held stick and a movement command — move nothing")
	_expect(_standing_ok(record) and _skill_actions(review) == 0, "standing %s" % str(record["standing"]))
	print("  %s" % _standing_text(record))
	print("  the review carries 0 Foundation Skill actions, so none can begin")
	_done("roguelite_the_paused_fallen_player_can_do_nothing")


func _check_roguelite_a_real_left_click_returns_to_the_nexus_and_restores_the_baseline(record: Dictionary) -> void:
	print("")
	print("--- 23. The roguelite: one real left click on \"Return to the Nexus\" ends the run once; I14's empty build restores Maximum Life on the FALLEN character — 0 / 575 -> 0 / 500 — and revive_for_testing() then restores Life")
	var back: Dictionary = record["return"] if record.has("return") else {}
	var restoration: Dictionary = back.get("restoration", {})
	var revivals: Array = back.get("revivals", [])
	var click: Dictionary = back.get("click", {})
	var first: Dictionary = revivals[0] if not revivals.is_empty() else {}
	_expect(_roguelite_return_ok(record, 3) and bool(click.get("under", false)) and _one_press(click) and bool(back.get("through", false))
			and float(restoration.get("life_before", -1.0)) == 0.0 and float(restoration.get("max_before", -1.0)) == float(record["max_before"])
			and float(restoration.get("life_after", -1.0)) == 0.0 and float(restoration.get("max_after", -1.0)) == 500.0
			and float(restoration.get("increased", -1.0)) == 0.0
			and float(first.get("life", -1.0)) == 0.0 and float(first.get("max", -1.0)) == 500.0 and first.get("state", "") == "FALLEN",
		"return %s" % str(back))
	print("  one left press and release through Input.parse_input_event(): one pressed, on that button; %s" % _return_text(record))
	print("  the restoration ran on the FALLEN character at 0 / %s and kept its zero: 0 / 500 (life_changed %s, still FALLEN); then the core loop's two revivals: %s"
		% [_n(float(restoration.get("max_before", 0.0))), _revival_text(revivals.slice(0, 1)), _revival_text(revivals.slice(1))])
	print("  over the 20 physics frames after the click: no destination, no attack, no movement, no modal, and the left button no longer held")
	_done("roguelite_a_real_left_click_returns_to_the_nexus_and_restores_the_baseline")


func _check_roguelite_focused_confirm_returns_once(record: Dictionary) -> void:
	print("")
	print("--- 24. The roguelite: Enter on the focused \"Return to the Nexus\" ends the run once")
	_expect(_roguelite_return_ok(record, 2) and _standing_ok(record), "return %s" % str(record.get("return", {})))
	print("  %s" % _return_text(record))
	_done("roguelite_focused_confirm_returns_once")


func _check_roguelite_f5_while_the_overlay_stands_returns_once(record: Dictionary) -> void:
	print("")
	print("--- 25. The roguelite: F5 with the overlay standing takes the overlay's own quick_restart path, once")
	_expect(_roguelite_return_ok(record, 2) and _standing_ok(record), "return %s" % str(record.get("return", {})))
	print("  %s" % _return_text(record))
	_done("roguelite_f5_while_the_overlay_stands_returns_once")


func _check_roguelite_f5_inside_the_delay_cancels_the_overlay(record: Dictionary) -> void:
	print("")
	print("--- 26. The roguelite: F5 on the lethal hit's heels, before the overlay, cancels it — the run ends once and no Fallen ever opens over the living character")
	var before: Dictionary = record["before_f5"]
	_expect(_lethal_ok(record) and before["state"] == "FALLEN" and not bool(before["alive"]) and not bool(before["open"])
			and _roguelite_return_ok(record, 2),
		"before F5 %s; return %s" % [str(before), str(record.get("return", {}))])
	print("  3 physics frames after the lethal hit: FALLEN, no overlay; F5 then: %s" % _return_text(record))
	_done("roguelite_f5_inside_the_delay_cancels_the_overlay")


func _check_the_next_expedition_begins_clean() -> void:
	print("")
	print("--- 27. After four deaths the next expedition begins clean: a fresh run at Rift level 1, an empty build, 500 / 500 and every baseline")
	var player: PrototypePlayer = review.player
	var runtime: RiftMoteRuntime = review.mote_runtime
	var teaching: PrototypeGraveblade = review.room_enemies[0][0]
	_expect(review.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN and review.run_state.current_room_index == 0
			and runtime != null and runtime.level() == 1 and runtime.experience() == 0.0 and runtime.run_build().is_empty()
			and player.is_alive() and player.action_state == PrototypePlayer.ActionState.IDLE
			and player.life == 500.0 and player.max_life == 500.0 and player.increased_maximum_life() == 0.0
			and player.maximum_life_baseline() == 500.0 and player.weapon.resource_path == WORN_BLADE
			and player.damage_taken_events == 0 and player.fallen_at_msec == 0
			and review.live_receipt_text().is_empty() and review.last_application == null
			and not review.level_up_panel.is_open and not review.fallen_overlay.is_open and not paused
			and teaching.is_alive() and teaching.life == teaching.data.max_life,
		"the next run began at level %d, %s / %s, %s" % [runtime.level() if runtime != null else -1, _n(player.life), _n(player.max_life),
			"empty" if runtime != null and runtime.run_build().is_empty() else "held"])
	print("  run %s: Rift level 1, 0 experience, an empty build; Life 500 / 500, +0%% Maximum Life over 500, the Worn Blade, no receipt, no offer, no overlay; the Teaching Hall's Graveblade at full Life"
		% review.plan.run_id())
	_done("the_next_expedition_begins_clean")


# --- The roguelite's deaths and returns ---------------------------------------------------------

func _die_in_the_teaching_hall(label: String, wait_for_overlay: bool) -> Dictionary:
	await _walk_into_gate(review, review.hub_module.exit_point())
	_quiet_room(0)
	var centre: Vector3 = _rounded(review.room_modules[0].room_centres()[0])
	return await _die(review, review.room_enemies[0][0], centre, label, wait_for_overlay, _capture_run_baseline, _roguelite_faults)


## STAGED, on the lethal frame: one production Graveblade registered with the run's H8 runtime at the
## corpse's feet and killed, so its mote lies where a sweep would find it.
func _drop_corpse_mote(record: Dictionary) -> void:
	var runtime: RiftMoteRuntime = review.mote_runtime
	var before: int = runtime.uncollected_count()
	_fixtures += 1
	var enemy: PrototypeGraveblade = (load(GRAVEBLADE_SCENE) as PackedScene).instantiate() as PrototypeGraveblade
	enemy.name = "J2CorpseMote%d" % _fixtures
	enemy.position = review.player.global_position
	_stage.add_child(enemy)
	enemy.set_ai_enabled(false)
	var registered: bool = runtime.register_graveblade(enemy, CORPSE_MOTE).is_empty()
	enemy.receive_damage(DamageEvent.physical(_use(), review.player, enemy, enemy.life + 1000.0))
	_corpse_mote = {"placed": registered and not enemy.is_alive() and runtime.uncollected_count() == before + 1,
		"uncollected_before": before}
	record["mote"] = _corpse_mote
	_capture_run_baseline(record)
	_note("one mote dropped under the fallen character by a production Graveblade registered with H8 and killed")


func _capture_run_baseline(_record: Dictionary) -> void:
	_corpse_run = _run_reading()


func _run_reading() -> Dictionary:
	var runtime: RiftMoteRuntime = review.mote_runtime
	return {
		"offer_open": review.level_up_panel.is_open, "offer_calls": review.offer_open_calls, "choices": review.choices_taken,
		"attempts": review.choice_attempts, "sweeps": review.sweeps_made, "collecting": review.collecting_sweeps,
		"applications": review.applications_made, "restorations": review.restorations_made,
		"experience": -1.0 if runtime == null else runtime.experience(), "level": -1 if runtime == null else runtime.level(),
		"uncollected": -1 if runtime == null else runtime.uncollected_count(), "drops": -1 if runtime == null else runtime.drop_count(),
		"offer_active": false if runtime == null else runtime.is_offer_active(),
	}


func _roguelite_faults(label: String) -> PackedStringArray:
	var faults: PackedStringArray = PackedStringArray()
	if _run_reading() != _corpse_run:
		faults.append("%s: the run moved to %s" % [label, str(_run_reading())])
	return faults


## The roguelite's return, by `method`: one real left click through `Input.parse_input_event()`, Enter
## on the focused button, F5 with the overlay standing, or F5 inside the delay before it.
func _return_roguelite(record: Dictionary, method: String) -> void:
	var player: PrototypePlayer = review.player
	var overlay: FirstMvpFallenOverlay = review.fallen_overlay
	var closes: int = overlay.closes
	var opens: int = overlay.opens
	var ended: int = _log_count(review, "run ended")
	var index: int = review.plan.run_index
	var restorations: int = review.restorations_made
	var discarded: int = review.runtimes_discarded
	var emissions: Array[Dictionary] = record["emissions"]
	var mark: int = emissions.size()
	var click: Dictionary = {}
	match method:
		"click":
			click = await _parse_click(overlay, _named(overlay, "Return to the Nexus"))
		"confirm":
			_push_key(KEY_ENTER, true)
		_:
			_push_key(KEY_F5, true)
	var restored: RiftBuildApplicationResult = review.last_restoration
	var back: Dictionary = {
		"method": method, "click": click,
		"closed_once": (not overlay.is_open and overlay.opens == opens
			and overlay.closes == (closes if method == "f5-delay" else closes + 1)),
		"ended_once": _log_count(review, "run ended") == ended + 1 and review.plan.run_index == index + 1,
		"hub": review.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB and review.mote_runtime == null
			and review.runtimes_discarded == discarded + 1,
		"restored": review.restorations_made == restorations + 1 and restored != null and restored.ok and restored.committed,
		"restoration": {} if restored == null else {"life_before": restored.life_before, "max_before": restored.maximum_life_before,
			"life_after": restored.life_after, "max_after": restored.maximum_life_after, "increased": restored.increased_maximum_life},
		"alive": player.is_alive() and player.action_state == PrototypePlayer.ActionState.IDLE,
		"baseline": (player.life == 500.0 and player.max_life == 500.0 and player.increased_maximum_life() == 0.0
			and player.maximum_life_baseline() == 500.0 and player.mana == player.max_mana),
		"weapon": player.weapon.resource_path == WORN_BLADE and String(review.loadout.equipped_weapon.weapon_id) == "roguelite_worn_blade",
		"receipt": review.live_receipt_text().is_empty() and review.last_application == null,
		"at_hub": _planar_gap(player.global_position, review.hub_module.entry_point()) < 0.6,
		"instrumentation": player.damage_taken_events == 0 and player.last_damage_taken == null and player.fallen_at_msec == 0,
		"revivals": emissions.slice(mark), "running": not paused,
	}
	if method == "confirm":
		_push_key(KEY_ENTER, false)
	elif method != "click":
		_push_key(KEY_F5, false)
	back["through"] = true
	if method == "click":
		back["through"] = await _after_close(review, player.global_position, player.attack.uses_started)
	await _wait_seconds(BrokenWatchSlice.FALLEN_DELAY + FirstMvpFallenOverlay.FADE_SECONDS + 0.4)
	back["no_later_overlay"] = overlay.opens == opens and not overlay.is_open and player.is_alive() and not paused
	record["return"] = back
	_disconnect(player, record)


## `revivals` is how many life_changed the return owes: the two revivals (the core loop's restart and
## its arrival in the Nexus), and before them the restoration's own when it moved a maximum.
func _roguelite_return_ok(record: Dictionary, revivals: int) -> bool:
	if not record.has("return"):
		return false
	var back: Dictionary = record["return"]
	var said: Array = back["revivals"]
	var ok: bool = said.size() == revivals
	for index: int in range(revivals - 2, revivals):
		ok = ok and index >= 0 and index < said.size() and _is_revival(said[index] as Dictionary, 500.0)
	for key: String in ["closed_once", "ended_once", "hub", "restored", "alive", "baseline", "weapon", "receipt", "at_hub",
			"instrumentation", "running", "no_later_overlay"]:
		ok = ok and bool(back[key])
	return ok


func _return_text(record: Dictionary) -> String:
	return "the overlay closed once, exactly one run ended (the plan advanced once) and its mote runtime was discarded; the empty build restored every baseline once; the character stands alive and IDLE at 500 / 500 in the Nexus with the Worn Blade and no receipt; no Fallen overlay in the %.2f s after" % (
		BrokenWatchSlice.FALLEN_DELAY + FirstMvpFallenOverlay.FADE_SECONDS + 0.4)


# --- I14's route to Vitality, ported from the accepted I14 harness --------------------------------

func _begin_expedition_a() -> void:
	if review.plan.seed_value != ROUTE_SEED:
		review.plan = RogueliteRunPlan.new(ROUTE_SEED, review.plan.run_index)
		_note("expedition A handed seed %d by staging (D-294 ruling 4)" % ROUTE_SEED)
	await _walk_into_gate(review, review.hub_module.exit_point())
	_expect_quiet(review.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN and review.mote_runtime != null
			and review.mote_runtime.run_seed() == ROUTE_SEED and review.mote_runtime.level() == 1,
		"expedition A did not begin fresh at seed %d" % ROUTE_SEED)
	if not review.automatic_pickup:
		await _key(KEY_F8)


func _open_level_one() -> void:
	for index: int in [0, 1]:
		_quiet_room(index)
		var room_centre: Vector3 = _rounded(review.room_modules[index].room_centres()[0])
		_stand(review, room_centre)
		for enemy: PrototypeGraveblade in review.room_enemies[index]:
			enemy.place_at(room_centre)
			_kill(review, enemy)
			await _settle(3)
		await _walk_into_gate(review, review.room_modules[index].exit_point())
	_quiet_room(2)
	var centre: Vector3 = _elite_hall_centre()
	var forward: Vector3 = _forward(review)
	var lateral: Vector3 = forward.rotated(Vector3.UP, PI * 0.5)
	review.room_enemies[2][0].place_at(centre - forward * 7.0 + lateral * 3.0)
	review.room_enemies[2][1].place_at(centre - forward * 7.0 - lateral * 3.0)
	_stand_facing(review, centre, forward)
	var in_hall: bool = review.run_state.current_room_index == 2 and review.mote_runtime.experience() == 75.0
	await _award_and_wait([REVIEW_AMOUNT])
	_expect_quiet(in_hall and review.mote_runtime.level() == 1, "Level 1 did not open from 75 route experience and one fixture mote")


## Awards `amounts`, then reads, on the offer the review opened by itself, what its contract's
## neutralization left on the living character.
func _award_and_wait(amounts: Array) -> void:
	var calls: int = review.offer_open_calls
	var awarded: bool = _award(amounts)
	await _settle(3)
	var player: PrototypePlayer = review.player
	_living.append({"label": "offer %d" % (_living.size() + 1), "found": {}, "left": {
		"open": review.level_up_panel.is_open and review.offer_open_calls == calls + 1 and awarded,
		"paused": paused, "idle": player.is_alive() and player.action_state == PrototypePlayer.ActionState.IDLE,
		"mode": player.movement_mode == PrototypePlayer.MovementMode.NONE, "velocity": player.velocity == Vector3.ZERO,
		"latched": player.awaiting_neutral and player.neutral_reason == "level-up offer opened",
	}})


func _award(amounts: Array) -> bool:
	var runtime: RiftMoteRuntime = review.mote_runtime
	var before: float = runtime.experience()
	var drops: int = runtime.drop_count()
	var at: Vector3 = review.hub_module.room_centres()[0] + Vector3(-4.0, 0.0, 2.0)
	var registered: bool = true
	var total: float = 0.0
	var expected: PackedInt32Array = PackedInt32Array()
	for amount: Variant in amounts:
		_fixtures += 1
		var enemy: PrototypeGraveblade = (load(GRAVEBLADE_SCENE) as PackedScene).instantiate() as PrototypeGraveblade
		enemy.name = "J2Fixture%d" % _fixtures
		enemy.position = at
		_stage.add_child(enemy)
		enemy.set_ai_enabled(false)
		registered = registered and runtime.register_graveblade(enemy, float(amount)).is_empty()
		enemy.receive_damage(DamageEvent.physical(_use(), review.player, enemy, enemy.life + 1000.0))
		registered = registered and not enemy.is_alive() and runtime.emission_answer(enemy).is_empty()
		expected.append(drops + expected.size())
		total += float(amount)
	var answer: RiftMoteSweepResult = runtime.sweep_at(at)
	review.experience_hud.refresh()
	return registered and answer.ok and answer.collected_indices() == expected and runtime.experience() == before + total


func _take_support() -> void:
	var choices: int = review.choices_taken
	_push_key(KEY_ENTER, true)
	var taken: bool = review.choices_taken == choices + 1
	_push_key(KEY_ENTER, false)
	_expect_quiet(taken, "a Support choice was not taken in its own call")


func _choose_vitality() -> void:
	await _joy(JOY_BUTTON_DPAD_RIGHT)
	var choices: int = review.choices_taken
	_push_joy(JOY_BUTTON_A, true)
	var taken: bool = review.choices_taken == choices + 1 and not review.level_up_panel.is_open
	_push_joy(JOY_BUTTON_A, false)
	_expect_quiet(taken, "Vitality was not taken by (A) on the Combat and Defence card")


func _elite_hall_centre() -> Vector3:
	return _rounded(review.room_modules[2].room_centres()[0])


func _quiet_room(index: int) -> void:
	for enemy: PrototypeGraveblade in review.room_enemies[index]:
		enemy.set_ai_enabled(false)

# --- 28–31. Across every death ----------------------------------------------------------------------

func _check_no_life_damage_or_fall_signal_repeats() -> void:
	print("")
	print("--- 28. Across every death: one life_changed and one took_damage per Hit, one fell, and not one more from the delay, the overlay's opening or the paused frames behind it")
	var faults: PackedStringArray = PackedStringArray()
	for record: Dictionary in _deaths:
		var hits: int = (record["trail"] as Array).size()
		for moment: String in ["lethal_facts", "open_facts", "end_facts"]:
			var facts: Dictionary = record.get(moment, {})
			if moment == "end_facts" and record.has("standing"):
				facts = record["standing"]["end_facts"]
			if facts.is_empty():
				continue
			if not (int(facts["took_damage"]) == hits and int(facts["life_changed"]) == hits and int(facts["fell"]) == 1
					and int(record["began"]) == hits):
				faults.append("%s at %s: %s" % [record["label"], moment, str(facts)])
	_expect(_deaths.size() == 7 and faults.is_empty(), "%d deaths; %s" % [_deaths.size(), "; ".join(faults)])
	for record: Dictionary in _deaths:
		print("  %s: %d Hits, %d took_damage, %d life_changed, 1 fell" % [record["label"], (record["trail"] as Array).size(),
			(record["trail"] as Array).size(), (record["trail"] as Array).size()])
	_done("no_life_damage_or_fall_signal_repeats")


func _check_no_new_damage_is_accepted_while_fallen() -> void:
	print("")
	print("--- 29. Across every standing overlay: one more of the killer's own 125-damage events through receive_damage() is refused — no Life, no Hit, no second fall, no new instrumentation")
	var refused: int = 0
	var standing: int = 0
	for record: Dictionary in _deaths:
		if record.has("standing"):
			standing += 1
			if bool(record["standing"]["refused"]):
				refused += 1
	_expect(standing == 6 and refused == standing, "%d of %d standing overlays refused the event" % [refused, standing])
	print("  %d of %d refused it; is_alive() is false behind the overlay, so the intake's own first line turns it away" % [refused, standing])
	_done("no_new_damage_is_accepted_while_fallen")


func _check_the_killing_event_and_instrumentation_are_unchanged() -> void:
	print("")
	print("--- 30. Across every death: the killing event is the Graveblade's own — raw and final equal to its record's damage — and it, fallen_at_msec and the DamageEvent count stand unchanged from the lethal frame to the end of the standing overlay")
	var faults: PackedStringArray = PackedStringArray()
	for record: Dictionary in _deaths:
		var killing: Dictionary = record["killing"]
		var lethal: Dictionary = record["lethal_facts"]
		var ok: bool = (bool(killing["from_killer"]) and float(killing["raw"]) == float(record["record_damage"])
			and float(killing["final"]) == float(record["record_damage"]) and int(killing["fallen_at"]) > 0
			and int(lethal["event"]) == int(killing["event"]) and int(lethal["fallen_at"]) == int(killing["fallen_at"]))
		for moment: String in ["open_facts", "end_facts"]:
			var facts: Dictionary = record.get(moment, {})
			if moment == "end_facts" and record.has("standing"):
				facts = record["standing"]["end_facts"]
			if not facts.is_empty():
				ok = ok and int(facts["event"]) == int(killing["event"]) and int(facts["fallen_at"]) == int(killing["fallen_at"]) \
					and int(facts["events"]) == int(lethal["events"])
		if not ok:
			faults.append(String(record["label"]))
	_expect(faults.is_empty() and _deaths.size() == 7, "deaths whose killing record moved: %s" % ", ".join(faults))
	print("  7 of 7: raw %s and final %s from the Graveblade that struck, use id and fallen_at_msec unchanged through the delay, the opening and the paused frames" % [
		_n(float(_deaths[0]["record_damage"])), _n(float(_deaths[0]["record_damage"]))])
	_done("the_killing_event_and_instrumentation_are_unchanged")


func _check_the_overlays_read_exactly_as_accepted() -> void:
	print("")
	print("--- 31. Across every standing overlay: the words, the focused button, its glyph and the fade are exactly the accepted ones")
	var faults: PackedStringArray = PackedStringArray()
	for record: Dictionary in _deaths:
		if not record.has("standing"):
			continue
		var standing: Dictionary = record["standing"]
		var roguelite: bool = bool(record["roguelite"])
		var expected: PackedStringArray = PackedStringArray(ROGUELITE_LABELS if roguelite else GATE_1D_LABELS)
		expected[expected.find("<detail>")] = DETAIL % ("%.0f" % float(record["max_before"]))
		if not (standing["labels"] == expected and standing["source"] == KILLING_SOURCE and bool(standing["glyph"])
				and float(standing["fade"]) == 1.0 and bool(standing["focused"])
				and standing["script"] == (ROGUELITE_FALLEN_SCRIPT if roguelite else FALLEN_SCRIPT)):
			faults.append("%s: %s" % [record["label"], str(standing["labels"])])
	_expect(faults.is_empty(), "; ".join(faults))
	print("  Gate 1D, three times: Fallen / Killed by / %s / %s / Restart Broken Watch / F5 also restarts." % [KILLING_SOURCE, DETAIL % "500"])
	print("  the roguelite, three times, the words of its own subclass, the detail naming the Maximum Life the character held — \"%s\" at 575, \"%s\" at 500" % [DETAIL % "575", DETAIL % "500"])
	print("  every one focused on its button, that button's glyph the live input family's, and faded in to 1.00")
	_done("the_overlays_read_exactly_as_accepted")


func _check_every_check_ran() -> void:
	var missing: PackedStringArray = PackedStringArray()
	for name: String in OWED_CHECKS:
		if not _reached.has(name):
			missing.append(name)
	var extra: PackedStringArray = PackedStringArray()
	for name: Variant in _reached.keys():
		if not OWED_CHECKS.has(String(name)):
			extra.append(String(name))
	_expect(missing.is_empty() and extra.is_empty(),
		"owed checks that never reached their last line: %s; unexpected: %s" % [", ".join(missing), ", ".join(extra)])
	var completed: PackedStringArray = PackedStringArray()
	for name: String in OWED_CHECKS:
		if _reached.has(name):
			completed.append(name)
	print("")
	print("  %d of %d owed checks completed" % [OWED_CHECKS.size() - missing.size(), OWED_CHECKS.size()])
	print("  completed: %s" % ", ".join(completed))


# --- Readings ---------------------------------------------------------------------------------------

func _facts(room: BrokenWatchSlice, counts: Dictionary) -> Dictionary:
	var player: PrototypePlayer = room.player
	var event: DamageEvent = player.last_damage_taken
	return {
		"life": player.life, "max_life": player.max_life, "increased": player.increased_maximum_life(),
		"baseline": player.maximum_life_baseline(), "state": player.action_state_name(), "alive": player.is_alive(),
		"fallen_at": player.fallen_at_msec, "events": player.damage_taken_events,
		"event": 0 if event == null else event.get_instance_id(), "mana": player.mana,
		"weapon": "" if player.weapon == null else player.weapon.resource_path, "position": player.global_position,
		"facing": player.facing_direction(), "life_changed": int(counts["life_changed"]),
		"took_damage": int(counts["took_damage"]), "fell": int(counts["fell"]),
	}


func _any_modal_open(room: BrokenWatchSlice) -> bool:
	var open: bool = room.item_comparison.is_open or room.fallen_overlay.is_open
	var loop: RogueliteCoreLoopRuntime = room as RogueliteCoreLoopRuntime
	if loop != null:
		open = open or loop.summary_panel.is_open
	var levels: RogueliteLevelUpChoiceReview = room as RogueliteLevelUpChoiceReview
	if levels != null:
		open = open or levels.level_up_panel.is_open
	return open


func _ai_count(room: BrokenWatchSlice) -> int:
	var acting: int = 0
	for enemy: PrototypeGraveblade in room.graveblades:
		if is_instance_valid(enemy) and enemy.ai_enabled:
			acting += 1
	return acting


func _enemy_snapshot(room: BrokenWatchSlice) -> Array[String]:
	var out: Array[String] = []
	for enemy: PrototypeGraveblade in room.graveblades:
		out.append("%s %s %s %s %s" % [enemy.name, enemy.state_name(), var_to_str(enemy.global_position), var_to_str(enemy.life),
			str(enemy.ai_enabled)])
	return out


func _skill_actions(room: Node) -> int:
	var found: int = 0
	for node: Node in room.find_children("*", "", true, false):
		var script: Script = node.get_script() as Script
		if script != null and script.resource_path == SKILL_ACTION_SCRIPT:
			found += 1
	return found


func _restart_caption(overlay: FirstMvpFallenOverlay) -> String:
	return "Return to the Nexus" if overlay is RogueliteFallenOverlay else "Restart Broken Watch"


## Every visible label in the overlay, in tree order, but the glyph beside a button's caption.
func _overlay_labels(overlay: Control) -> PackedStringArray:
	var texts: PackedStringArray = PackedStringArray()
	for node: Node in overlay.find_children("*", "Label", true, false):
		var label: Label = node as Label
		if not label.is_visible_in_tree():
			continue
		if label.get_parent() is HBoxContainer and label.get_parent().get_parent() is Button and label.get_index() == 1:
			continue
		texts.append(label.text)
	return texts


func _glyph_ok(room: BrokenWatchSlice, button: Button) -> bool:
	var glyph: Label = _glyph_of(button)
	var controller: bool = room.input_family.family == InputFamilyTracker.Family.CONTROLLER
	return glyph != null and not glyph.text.is_empty() and glyph.text == FirstMvpModal.glyph_for(&"ui_confirm", controller)


func _lethal_ok(record: Dictionary) -> bool:
	var lethal: Dictionary = record["lethal"]
	return (lethal["state"] == "FALLEN" and not bool(lethal["alive"]) and float(lethal["life"]) == 0.0 and not bool(lethal["modal"])
		and not bool(lethal["paused"]) and bool(lethal["holder"]) and int(lethal["acting"]) == 0 and _trail_ok(record))


func _opening_ok(record: Dictionary) -> bool:
	if not bool(record.get("opened", false)):
		return false
	var at_open: Dictionary = record["at_open"]
	return (not at_open.is_empty() and record["before_open"] == at_open and at_open == record["open_facts"]
		and at_open["state"] == "FALLEN" and not bool(at_open["alive"]) and float(at_open["life"]) == 0.0
		and bool(record["open_latch"]) and record["cleared_reasons"] == PackedStringArray(["fallen", "fallen opened"]))


func _standing_ok(record: Dictionary) -> bool:
	if not record.has("standing"):
		return false
	var standing: Dictionary = record["standing"]
	return ((standing["faults"] as PackedStringArray).is_empty() and bool(standing["focused"]) and bool(standing["on_dim"])
		and bool(standing["on_button"]) and int(standing["fired"]) == 0 and standing["answers"] == ["rejected: fallen"]
		and bool(standing["refused"]) and float(standing["fade"]) == 1.0 and bool(standing["still_open"]) and bool(standing["glyph"]))


func _standing_text(record: Dictionary) -> String:
	var facts: Dictionary = record["standing"]["end_facts"]
	return "30 physics and 10 idle frames: paused and FALLEN at 0 / %s throughout; the left press landed on the overlay's own Dim and the right press over \"%s\" pressed nothing; the held stick moved nothing; command_move_to() answered 'rejected: fallen'; no enemy moved or asked for permission; the focus stayed on the button, the overlay faded in to 1.00, and one more DamageEvent was refused" % [
		_n(float(facts["max_life"])), _restart_caption_for(record)]


func _restart_caption_for(record: Dictionary) -> String:
	return "Return to the Nexus" if bool(record["roguelite"]) else "Restart Broken Watch"


func _trail_ok(record: Dictionary) -> bool:
	var trail: Array = record["trail"]
	var life: float = float(record["life_before"])
	var damage: float = float(record["record_damage"])
	if trail.is_empty():
		return false
	for value: Variant in trail:
		life = maxf(life - damage, 0.0)
		if float(value) != life:
			return false
	return life == 0.0


func _trail_text(record: Dictionary) -> String:
	var parts: PackedStringArray = PackedStringArray([_n(float(record["life_before"]))])
	for value: Variant in record["trail"]:
		parts.append(_n(float(value)))
	return " -> ".join(parts)


func _is_revival(said: Dictionary, maximum: float) -> bool:
	return (float(said["life"]) == maximum and float(said["max"]) == maximum and said["state"] == "IDLE"
		and bool(said["awaiting"]) and said["reason"] == "encounter reset")


func _revival_text(revivals: Array) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for said: Variant in revivals:
		var entry: Dictionary = said
		parts.append("%s / %s %s" % [_n(float(entry["life"])), _n(float(entry["max"])), entry["state"]])
	return "[%s]" % ", ".join(parts)


func _disconnect(player: PrototypePlayer, record: Dictionary) -> void:
	var listeners: Array = record.get("listeners", [])
	var signals: Array[Signal] = [player.life_changed, player.took_damage, player.fell, player.movement_intent_cleared]
	for index: int in listeners.size():
		var callable: Callable = listeners[index]
		if signals[index].is_connected(callable):
			signals[index].disconnect(callable)


## After a click that closed a modal: the world runs again and nothing of that click reaches it — no
## destination, no attack, no movement, no modal, and the button no longer held.
func _after_close(room: BrokenWatchSlice, at: Vector3, uses: int) -> bool:
	await _settle(20)
	await _await_process_frames(5)
	return (not paused and not room.player.has_destination and room.player.attack.uses_started == uses
		and room.player.global_position.distance_to(at) < 0.05 and not _any_modal_open(room)
		and not Input.is_action_pressed(&"move_point"))


func _wait_seconds(seconds: float) -> void:
	var deadline: int = Time.get_ticks_msec() + int(seconds * 1000.0)
	while Time.get_ticks_msec() < deadline:
		await process_frame


func _until_neutral(room: BrokenWatchSlice) -> void:
	for frame: int in 60:
		if not room.player.awaiting_neutral:
			return
		await physics_frame


# --- The worlds -------------------------------------------------------------------------------------

func _forward(room: BrokenWatchSlice) -> Vector3:
	var facing: Vector3 = room.route_forward()
	facing.y = 0.0
	return facing.normalized()


func _stand(room: BrokenWatchSlice, at: Vector3) -> void:
	room.player.global_position = Vector3(at.x, 0.0, at.z)
	room.player.velocity = Vector3.ZERO
	room.player.clear_movement_intent("verification", false)
	room.camera_rig.focus = room.player.global_position


func _stand_facing(room: BrokenWatchSlice, at: Vector3, facing: Vector3) -> void:
	_stand(room, at)
	room.player.face_instantly(facing)


func _walk_into_gate(room: BrokenWatchSlice, gate: Vector3) -> void:
	_stand(room, gate)
	await _await_process_frames(6)
	await _settle(4)


func _kill(room: BrokenWatchSlice, enemy: PrototypeGraveblade) -> void:
	enemy.receive_damage(DamageEvent.physical(_use(), room.player, enemy, enemy.life + 1000.0))
	_expect_quiet(not enemy.is_alive(), "%s did not die from a lethal hit" % enemy.name)


func _note(text: String) -> void:
	if not _staged.has(text):
		_staged.append(text)


func _log_count(room: BrokenWatchSlice, token: String) -> int:
	var count: int = 0
	for line: String in room.log_lines:
		if line.contains(token):
			count += 1
	return count


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


func _rounded(at: Vector3) -> Vector3:
	return Vector3(roundf(at.x), 0.0, roundf(at.z))


func _planar_gap(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()


func _n(value: float) -> String:
	if is_equal_approx(value, roundf(value)):
		return "%d" % roundi(value)
	return "%.2f" % value


func _use() -> int:
	_next_use_id += 1
	return _next_use_id


# --- The pointer, the keyboard, the stick and the controller ----------------------------------------

## Window coordinates for a point in the viewport's own space: the stretch transform, applied the way
## the operating system's pointer arrives through it.
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


## A pointer motion to `local`, then a press and a release of `index` there, pushed into the root
## window. Answers the control the GUI found under the pointer.
func _click_at(local: Vector2, index: MouseButton) -> Control:
	root.push_input(_motion_event(local), false)
	var under: Control = root.gui_get_hovered_control()
	root.push_input(_button_event(local, index, true), false)
	root.push_input(_button_event(local, index, false), false)
	return under


## One real left click on `button` through `Input.parse_input_event()`, the path the operating
## system's own events take; it is delivered at the next frame's input flush.
func _parse_click(panel: Control, button: Button) -> Dictionary:
	if button == null:
		return {}
	_watch(panel)
	var local: Vector2 = button.get_global_rect().get_center()
	Input.parse_input_event(_motion_event(local))
	Input.parse_input_event(_button_event(local, MOUSE_BUTTON_LEFT, true))
	Input.parse_input_event(_button_event(local, MOUSE_BUTTON_LEFT, false))
	await _await_process_frames(2)
	var own: int = int(_fired.get(button.get_instance_id(), 0))
	var result: Dictionary = {"under": own == 1, "fired": own, "others": _total_fired() - own}
	_unwatch()
	return result


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
	for id: Variant in _fired.keys():
		total += int(_fired[id])
	return total


func _one_press(result: Dictionary) -> bool:
	return int(result.get("fired", 0)) == 1 and int(result.get("others", -1)) == 0


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


func _push_joy(button: JoyButton, pressed: bool) -> void:
	var event: InputEventJoypadButton = InputEventJoypadButton.new()
	event.device = 0
	event.button_index = button
	event.pressed = pressed
	root.push_input(event)


func _joy(button: JoyButton) -> void:
	_push_joy(button, true)
	_push_joy(button, false)
	await _await_process_frames(1)


## The left stick, right along the ground, through the Input singleton the room reads it from.
func _parse_stick(value: float) -> void:
	var motion: InputEventJoypadMotion = InputEventJoypadMotion.new()
	motion.device = 0
	motion.axis = JOY_AXIS_LEFT_X
	motion.axis_value = value
	Input.parse_input_event(motion)


func _settle(frames: int) -> void:
	for frame: int in frames:
		await physics_frame


func _await_process_frames(frames: int) -> void:
	for frame: int in frames:
		await process_frame


# --- Source readings ----------------------------------------------------------------------------------

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


## Code with every comment line removed and every string literal emptied.
func _bare(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	var strings: RegEx = RegEx.create_from_string("\"([^\"\\\\]|\\\\.)*\"")
	return strings.sub("\n".join(kept), "\"\"", true)


## The non-empty code lines of `body`, each stripped of its indentation.
func _code_lines(body: String) -> PackedStringArray:
	var lines: PackedStringArray = PackedStringArray()
	for line: String in body.split("\n"):
		var stripped: String = line.strip_edges()
		if stripped.is_empty() or stripped.begins_with("#"):
			continue
		lines.append(stripped)
	return lines


## The commas at the top level of the argument list that opens at `start`, up to its closing paren.
func _top_level_commas(code: String, start: int) -> int:
	var depth: int = 0
	var commas: int = 0
	for index: int in range(start, code.length()):
		var character: String = code[index]
		if character == "(" or character == "[" or character == "{":
			depth += 1
		elif character == ")" or character == "]" or character == "}":
			if depth == 0:
				return commas
			depth -= 1
		elif character == "," and depth == 0:
			commas += 1
	return commas


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


## Records a failure without adding to the pinned count, inside helpers whose length is incidental.
func _expect_quiet(condition: bool, failure_message: String) -> void:
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
