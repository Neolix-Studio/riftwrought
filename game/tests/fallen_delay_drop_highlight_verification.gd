extends SceneTree
## First-MVP UI J5 — Fallen-Delay Ground-Drop Highlight Clearing V1: automated verification (decision D-330).
##
## THE ONE QUESTION: once the character is not alive, does Gate 1D's ground drop stop being
## controller-soft-selected — its ring back to the ordinary unselected presentation — from the slice's
## first process update after the lethal Hit, through the 0.90 s Fallen delay and behind the Fallen
## overlay? After J5 it does: the not-alive branch of `_update_drop_nameplate()` now makes the drop's
## existing public call `set_soft_targeted(false)` before it returns.
##
## THE SLICE IS THE ONLY PRODUCTION FILE J5 MOVES, BY ONE LINE, and that is proved by reconstruction: with
## that line removed it is, byte for byte, the file J4 left.
##
## GATE 1D'S OWN `broken_watch_slice.tscn`, LOADED AS IT SHIPS AND GIVEN NO FLAG OF ITS OWN. The drop is
## earned by the player's own Quick Strikes, every death is dealt by the production Graveblade's own
## attacks, and every press reaches the slice through the root viewport.
##
## THE LETHAL FRAME IS NOT J5's. J5 owns the first process update after the lethal Hit, not the inside of
## the lethal damage call. A deferred call on the player's own `fell` reads the drop after the lethal call
## stack has returned and before the slice processes again, and proves that no process update and no
## drawn frame has happened in between. Two harness nodes count every process update, one before the slice
## and one after it; the second reads what the slice and the drop left.
##
## THE SELECTION IS READ, NEVER WRITTEN: the drop's existing public field `soft_selected`, and the colour
## the drop's own `_process` writes into its existing `GroundRing` material.
##
## STAGED, AND STATED WHERE IT HAPPENS:
##   - both Graveblades are quieted; the first is placed, and the player's Quick Strike is aimed at it
##     through the slice's own verification seam `force_next_aim_for_verification()`;
##   - the controller is made the live family by one left-stick deflection pushed into the root viewport,
##     which the Input singleton never sees, so the character does not move;
##   - before each death the player is placed and the second Graveblade 1.2 m in front of it; each attack
##     is begun through `begin_attack_for_verification()`;
##   - before each living reading the player is placed at a measured distance from the drop;
##   - every mouse event the harness sends carries its own device id, and a harness node ahead of the
##     slice holds back every other mouse event, so a real pointer on a rendered window cannot change
##     the input family; one foreign pointer movement is sent on purpose to prove the filter holds;
##   - the direct opener is called exactly once; the first Graveblade is killed once more through
##     `receive_damage()` at the end, to read the drop latch.
##
## Input is simulated, which is not physical-device certification. With `--shots <dir>` the run also
## saves two evidence frames; they add no assertion, so the rendered runs pin the same count.
##
## IT PORTS D-211's OWED-SET DISCIPLINE.
##
## Run: godot --headless --path game --script res://tests/fallen_delay_drop_highlight_verification.gd

const THIS_FILE: String = "res://tests/fallen_delay_drop_highlight_verification.gd"
const SLICE_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
const SLICE_SCENE: String = "res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
const OPENING_SCRIPT: String = "res://scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
const CORE_LOOP_SCRIPT: String = "res://scripts/roguelite/roguelite_core_loop_runtime.gd"
const PROTOTYPE_ROOM_SCRIPT: String = "res://scripts/prototype_zero/prototype_zero.gd"
const GRAVEBLADE_RECORD: String = "res://data/prototype_zero/graveblade.tres"
const STARTING_SWORD: String = "res://data/first_mvp/severed_threshold/broken_watch/starting_sword.tres"
const WATCHSTEEL_SWORD: String = "res://data/first_mvp/severed_threshold/broken_watch/watchsteel_sword.tres"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31
const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]

## The slice as J4 left it, whole, and J5's one line inside it. The pair is [as J5 wrote it, as J4 left
## it]; it carries the whole branch so that it is unique.
const J4_SLICE_SHA256: String = "c204a0879450faf15ad29762e46b807bcc73f74c2d6dc8f91649bb22badaf1ca"
const J5_PREFIX: String = "f83e9436"
const J5_LINE: String = "\t\t_active_drop.set_soft_targeted(false)\n"
const J5_SLICE_MOVES: Array = [
	["\tif not player.is_alive():\n\t\t_nameplate.visible = false\n\t\thud.show_item_prompt(\"\")\n\t\t_active_drop.set_soft_targeted(false)\n\t\treturn\n",
		"\tif not player.is_alive():\n\t\t_nameplate.visible = false\n\t\thud.show_item_prompt(\"\")\n\t\treturn\n"],
]

## `_update_drop_nameplate()`'s first code lines after J5, through the camera read.
const NAMEPLATE_HEAD: Array[String] = [
	"if _active_drop == null or _nameplate == null:", "if _nameplate != null:", "_nameplate.visible = false",
	"hud.show_item_prompt(\"\")", "return", "if not player.is_alive():", "_nameplate.visible = false",
	"hud.show_item_prompt(\"\")", "_active_drop.set_soft_targeted(false)", "return", "var camera: Camera3D = camera_rig.camera",
]
const NAMEPLATE_LAST: String = "_active_drop.set_soft_targeted(controller and _active_drop.player_is_in_range(player.global_position))"
## The two functions that arm and fire the delay, code line for code line, as accepted (J3's own rows).
const FELL_LINES: Array[String] = [
	"for enemy: PrototypeGraveblade in graveblades:", "enemy.set_ai_enabled(false)",
	"attack_coordinator.revoke_all(\"player fallen\")", "_pending_fallen_event = event", "_fallen_countdown = FALLEN_DELAY",
]
const TICK_LINES: Array[String] = [
	"if _fallen_countdown < 0.0:", "return", "_fallen_countdown -= delta", "if _fallen_countdown <= 0.0:",
	"_fallen_countdown = -1.0", "fallen_overlay.open_for(_pending_fallen_event)",
]
## Words a Life-state inference would need. None may appear in `_update_drop_nameplate()`.
const INFERENCE_WORDS: Array[String] = ["life", "_fallen_countdown", "_pending_fallen_event", "action_state", "FALLEN", "awaiting_neutral"]

## The slice's declarations, as J4 left them.
const SLICE_FIELDS: int = 35
const SLICE_EXPORTS: int = 8
const SLICE_FUNCTIONS: int = 53
const SLICE_CONSTANTS: int = 12

## The six accepted suite files J5 moved, each put back to exactly what it was at the end of D-329. Each
## row is [path, its J5 prefix, its D-329 SHA-256, pairs of (as J5 wrote it, as D-329 left it)].
const J1_VERIFICATION: String = "res://tests/first_mvp_modal_left_click_verification.gd"
const J2_VERIFICATION: String = "res://tests/fallen_modal_life_state_verification.gd"
const J3_VERIFICATION: String = "res://tests/pending_fallen_restart_verification.gd"
const J3_SMOKE: String = "res://tests/pending_fallen_restart_smoke.sh"
const J4_VERIFICATION: String = "res://tests/fallen_delay_item_interaction_verification.gd"
const J4_SMOKE: String = "res://tests/fallen_delay_item_interaction_smoke.sh"

## Verification Maintenance V1 (decision D-342): every pair list this suite uses to put a file back lives in
## the flat, content-addressed provenance store under res://tests/provenance/, named by the SHA-256 of its
## listing. Each `*_ROWS` and `*_MOVE_IDS` constant below names its pair lists, and the variable of the old name
## holds them resolved, so every check reads exactly as before. They are resolved through the one engine there,
## and only while it is at the SHA-256 pinned here; a pair list the store cannot prove resolves to nothing.
const PROVENANCE_ENGINE: String = "res://tests/provenance/accepted_suite_provenance.gd"
const PROVENANCE_ENGINE_SHA256: String = "fadbdfeba32546d03bffe876c2b8be7a96dfe966ff9f5d4f720199d664b23dc4"

const MOVED_SUITE_ROWS: Array = [
	[J1_VERIFICATION, "8c0e290c", "c6fe40f1495c097a82f400c2d96c8e224a4d0c62c78bdc206ac980844c5ce2c4", "dcea2ecadfaf8db30ef7aa47f23bf1325d0d221bec227f73b90ba23fbabf10af"],
	[J2_VERIFICATION, "ca594f7d", "a3f97de5ddffc000d93354a2e18171e872a3f97b8b13571efa9c2efd2b798503", "7c500ad9962e46cb63f786ff17959b5969778e6d19012a8aaff910039a2ae0a2"],
	[J3_VERIFICATION, "b2cfc253", "565a0a4fd1a8b61347c1a91f90f6274be3475aeec9018e2f5cb9ae39153bfa7e", "81703bcc9a60c18ae723589abf5b6b0f1a696bd11a8c97e2bfe742998fdcb01c"],
	[J3_SMOKE, "6e4120a3", "5c45961b45b347b3ff78e2b42873e2ecd9a196f297bac456f3d6b6530aa1d0a7", "32358e8c607db638a7c579bfc26409d692192636d657d0e0e61cc76ede0b944b"],
	[J4_VERIFICATION, "7ad7dd67", "409b540d47a255d8f859e9bc75cd28ee026e924cfa1660e0c2af5669fd348741", "e0e9380e8eb53fa09711f75d9184a4ac34951b0e20230035930ca41d5163a273"],
	[J4_SMOKE, "ffbb4b7b", "8b55c045c3ac56eade2e422d9a21e0ac861a205cd186f58b30b6b99c539b345a", "d1ee40c01c9c2f2bb310cea23f7300c4541d80b11bef6f7253226847140b3a3b"],
]
var MOVED_SUITES: Array = _stored(MOVED_SUITE_ROWS)

## First-MVP UI J6 (D-332) moved five of the six files above again, one for one, when the combat HUD
## moved. Each is first put back to where J5 left it and then read exactly as before: `J6_PREFIXES` holds
## each file's J6 prefix, and `J6_MOVES` its pairs of [as J6 wrote it, as J5 left it], applied to that
## file alone.
const J6_PREFIXES: Dictionary = {
	J2_VERIFICATION: "f065a48d", J3_VERIFICATION: "68a1227e", J3_SMOKE: "f7b48202", J4_VERIFICATION: "308fe51a", J4_SMOKE: "b7ff3d66",
}
const J6_MOVE_IDS: Dictionary = {
	J2_VERIFICATION: "c50dea62f9b616092198b2e91c26bca6a89d98bafdcb0a05f188a99a2aa8799e",
	J3_VERIFICATION: "0cc650ce57c2472c01b53f90a47eedba9c7acec9574185d76b1877fdbcf80356",
	J3_SMOKE: "2016a5c2988311560e3403a1363641fa22a730bf2e3230e4526d953c278bc4da",
	J4_VERIFICATION: "b3dcb377fe37c67d670bc6a44e2bddf4f58d2b0816adc3360bbd9a5e84eb8eb1",
	J4_SMOKE: "edda6209f05ef611f1152881e42f04f56e5744e9edc62ee3222968d008fc7eb1",
}
var J6_MOVES: Dictionary = _stored(J6_MOVE_IDS)

## First-MVP UI J7 (D-334) moved the five files J6 moved above again, one for one, when the combat HUD
## moved. Each is first put back to where J6 left it and then read exactly as before: `J7_PREFIXES` holds
## each file's J7 prefix, and `J7_MOVES` its pairs of [as J7 wrote it, as J6 left it], applied to that
## file alone.
const J7_PREFIXES: Dictionary = {
	J2_VERIFICATION: "eb7f4153", J3_VERIFICATION: "520d9543", J3_SMOKE: "67cf7ba9", J4_VERIFICATION: "611891a3", J4_SMOKE: "d7cf4498",
}
const J7_MOVE_IDS: Dictionary = {
	J2_VERIFICATION: "3e7c3a327c2fcb3b5ae9daf1a554e1101538d0308bd5394087552c3136fb4d0b",
	J3_VERIFICATION: "1c516c4733d0b37638eac8a9e7544bf35b85b9fd7ffa1eb649c6674aa51c612d",
	J3_SMOKE: "e9b16d35e517a196779b81c5e027cf5fe5b93969503000e1e3ba6f33a0d2c242",
	J4_VERIFICATION: "7164b12714b6238ffa4470cd4d958e1d3ea17605a789432c534024ece612592b",
	J4_SMOKE: "89640d63fe43de273c4d04748dedc71f2ef0c6fa712641bf510daa676ab9e5b2",
}
var J7_MOVES: Dictionary = _stored(J7_MOVE_IDS)

## First-MVP UI J8 (D-336) moved the five files J7 moved above again, one for one, when the combat HUD
## moved. Each is first put back to where J7 left it and then read exactly as before: `J8_PREFIXES` holds
## each file's J8 prefix, and `J8_MOVES` its pairs of [as J8 wrote it, as J7 left it], applied to that
## file alone.
const J8_PREFIXES: Dictionary = {
	J2_VERIFICATION: "d5407c7c", J3_VERIFICATION: "1062c1db", J3_SMOKE: "689284cc", J4_VERIFICATION: "3deeb26a", J4_SMOKE: "cb520369",
}
const J8_MOVE_IDS: Dictionary = {
	J2_VERIFICATION: "3cfd6d4749e5e801664da0874fa7f571855f0c1c4d08a671cab93b6317b27503",
	J3_VERIFICATION: "da1e53b3a7be5c836b449eca6af9d6e422484f5f6b87c7dbde858f1b24e91e70",
	J3_SMOKE: "3ac248809645192bb948960935d03919041698fc4db7f88ca5f870e21a321cc6",
	J4_VERIFICATION: "1b66d63242bdd82fa624b7795247d40b5d49999ac005af40d8c6f9e110d8b4fd",
	J4_SMOKE: "604de133e29e7eef2e1abf4ea9985e367acebef9edffb68acffd93037a9cd1cd",
}
var J8_MOVES: Dictionary = _stored(J8_MOVE_IDS)

## First-MVP Gameplay J9 (D-338) moved the slice and the six files above again, one for one, when the slice's
## connection came to bind the first Graveblade. Each is first put back to where D-337 left it and then read
## exactly as before: `J9_PREFIXES` holds each file's J9 prefix, and `J9_MOVES` its pairs of [as J9 wrote it,
## as D-337 left it], applied to that file alone.
const J9_PREFIXES: Dictionary = {
	SLICE_SCRIPT: "942aee83", J1_VERIFICATION: "acbd3892", J2_VERIFICATION: "6acc1e0c", J3_VERIFICATION: "dc9be60f", J3_SMOKE: "ec5bc37f", J4_VERIFICATION: "eff592af", J4_SMOKE: "e14e996b",
}
const J9_MOVE_IDS: Dictionary = {
	SLICE_SCRIPT: "d678256ed00a877dddccb3783fc44d1367824b3b8c97beb41f6ac4155930997f",
	J1_VERIFICATION: "fb8d9401ba6c004b0d1e1997f866d76602e5b423be361ff06b383bafc3cc1749",
	J2_VERIFICATION: "fb8d9401ba6c004b0d1e1997f866d76602e5b423be361ff06b383bafc3cc1749",
	J3_VERIFICATION: "1a4d7f01639d1180ba3e70a49c8ce4e9c0a1843a82055d515465b366aecc64d8",
	J3_SMOKE: "d4f4a6ada9acac4c6a846830bc9283e4d5c4537f03d7a61b32b185a18dad22fb",
	J4_VERIFICATION: "155bdaf5bb4dd9b2169b9e4139f9fe758fd3bf98e82add80617e3443f37d5639",
	J4_SMOKE: "cec36c2a16824f2215ee25fae06ada08a06280f275458c0013c362e50f33d2c9",
}
var J9_MOVES: Dictionary = _stored(J9_MOVE_IDS)

## First-MVP Gameplay J10 (D-340) moved the slice and the six files above again, one for one, when Gate 1D's
## slice's restart came to end the movement command it carried. Each is first put back to where D-339 left it
## and then read exactly as before: `J10_PREFIXES` holds each file's J10 prefix, and `J10_MOVES` its pairs of
## [as J10 wrote it, as D-339 left it], applied to that file alone.
const J10_PREFIXES: Dictionary = {
	SLICE_SCRIPT: "883ef25e", J1_VERIFICATION: "75f26486", J2_VERIFICATION: "935a37e9", J3_VERIFICATION: "53c37976", J3_SMOKE: "9a860bca", J4_VERIFICATION: "5c8e9b07", J4_SMOKE: "0fd60eb7",
}
const J10_MOVE_IDS: Dictionary = {
	SLICE_SCRIPT: "0f3be56df737115f62f10f15bcee4d1ead68b785b0465eb9c6d7fd804540a413",
	J1_VERIFICATION: "26ba84a3fd1582fd17708ff4b49d5522cfbf6142a558114d9c519a6f24ab0250",
	J2_VERIFICATION: "26ba84a3fd1582fd17708ff4b49d5522cfbf6142a558114d9c519a6f24ab0250",
	J3_VERIFICATION: "d9ffd11477b4bfd3b1c1f297ab77ad7b4ce71a117d1acbd1872907bc18d0fe7a",
	J3_SMOKE: "58b1cc938d16d1b2bef63f0552efc11c7596ea019e4bb55e98972b4f9494757d",
	J4_VERIFICATION: "bab624db6148b8252317457295986ea7fcdbd0337bc63e5cd1b080eccc80286e",
	J4_SMOKE: "8d4a99d6cc235c0be4eb36dc8b9c9518d3ca17e98153302fdf794e950c8a3b16",
}
var J10_MOVES: Dictionary = _stored(J10_MOVE_IDS)

## Verification Maintenance V1 (D-342) moved one of the files above again, when its put-back pairs
## moved into the flat provenance store. Each is first put back to where D-341 left it and then read exactly
## as before: `VM1_PREFIXES` holds each file's D-342 prefix, and `VM1_MOVES` its pairs of [as D-342 wrote it,
## as D-341 left it], named in `VM1_MOVE_IDS` and applied to that file alone.
const VM1_PREFIXES: Dictionary = {
	J4_VERIFICATION: "15352d8a",
}
const VM1_MOVE_IDS: Dictionary = {
	J4_VERIFICATION: "e48a940f496b486a4e3d29945413a32e72c92d04cc1b53079b43b091c391d8ac",
}
var VM1_MOVES: Dictionary = _stored(VM1_MOVE_IDS)

## First-MVP Gameplay J11 (D-344) moved Gate 1D's slice and the accepted suite files above again, one for one,
## when the slice came to open Riftfall Landing's Watch Breach far cap in this composition. Each is first put
## back to where D-343 left it and then read exactly as before: `J11_PREFIXES` holds each file's J11 prefix, and
## `J11_MOVES` its pairs of [as J11 wrote it, as D-343 left it], named in `J11_MOVE_IDS` and applied to that file
## alone.
const J11_PREFIXES: Dictionary = {
	"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd": "d4e839fb",
	"res://tests/first_mvp_modal_left_click_verification.gd": "d12ad271",
	"res://tests/fallen_modal_life_state_verification.gd": "72e39a8a",
	"res://tests/pending_fallen_restart_verification.gd": "7d0e3f08",
	"res://tests/pending_fallen_restart_smoke.sh": "54a4464a",
	"res://tests/fallen_delay_item_interaction_verification.gd": "8aad4262",
	"res://tests/fallen_delay_item_interaction_smoke.sh": "939d9b48",
}
const J11_MOVE_IDS: Dictionary = {
	"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd": "f0f7cf747a8cc738a5e9477ea2028e6d863d9d83d3cc6799d39032a0275db868",
	"res://tests/first_mvp_modal_left_click_verification.gd": "e7b62a6207638ff89cd8732cc9bbcfd57503f83f8877662c7a4806a709fdc3c8",
	"res://tests/fallen_modal_life_state_verification.gd": "e7b62a6207638ff89cd8732cc9bbcfd57503f83f8877662c7a4806a709fdc3c8",
	"res://tests/pending_fallen_restart_verification.gd": "eab887b6ceea266bb06554728df7227e3c47fb0338990a0f9e3209f733f9b6c2",
	"res://tests/pending_fallen_restart_smoke.sh": "a7a5214f7f0fd6e1f4d32fc539df430b11312aee42ad845ee135cbdba73cecd2",
	"res://tests/fallen_delay_item_interaction_verification.gd": "7b773bea4b14e0ff94ae58afcf898e9d269834c1c8bd257ad10717becf55fc07",
	"res://tests/fallen_delay_item_interaction_smoke.sh": "a089abfb62d27e1a1f9d8f3e523c12d8da6f930056aba5d3daa0a7a687f5ce2b",
}
var J11_MOVES: Dictionary = _stored(J11_MOVE_IDS)

## Everything J5 stands beside, at the SHA-256 prefix each held before the first J5 edit.
const UNCHANGED_HASHES: Array = [
	["res://scripts/actors/prototype_player.gd", "80e38838"],
	["res://scripts/ui/first_mvp_modal.gd", "1cfe9c73"],
	["res://scripts/ui/first_mvp_fallen_overlay.gd", "de5e1ab0"],
	["res://scripts/roguelite/roguelite_fallen_overlay.gd", "1753e7b7"],
	["res://scripts/ui/first_mvp_item_comparison.gd", "3607f9f7"],
	## First-MVP UI J6 (D-332) moved the combat HUD one for one, from `0bb284a1`, so that its Life and
	## Mana fills draw the fraction their labels state. Same count.
	## First-MVP UI J7 (D-334) moved it again, from `aff939f3`, so that the enemy hover Life fill draws
	## its fraction. Same count.
	## First-MVP UI J8 (D-336) moved it again, from `38c485cb`, so that the player resource column sits
	## wholly inside the window. Same count.
	["res://scripts/ui/first_mvp_combat_hud.gd", "ee485029"],
	["res://scripts/items/first_mvp_item_drop.gd", "dbd5594d"],
	["res://scripts/items/player_loadout.gd", "d79b63df"],
	["res://scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd", "601e5901"],
	["res://scripts/roguelite/roguelite_core_loop_runtime.gd", "a76cec3d"],
	["res://scripts/roguelite/experience/roguelite_experience_collection_review.gd", "150509d5"],
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", "128103b4"],
	["res://scripts/roguelite/live_effects/roguelite_live_effect_review.gd", "75cb02b9"],
	["res://scripts/roguelite/replayability/roguelite_replayability_runtime.gd", "ef236cec"],
	["res://scripts/roguelite/build_variety/roguelite_build_variety_runtime.gd", "e9abb336"],
	["res://scripts/prototype_zero/prototype_zero.gd", "21b41e49"],
	["res://scripts/actors/prototype_graveblade.gd", "0ae1374b"],
	["res://scripts/combat/quick_strike_action.gd", "e6514705"],
	["res://scripts/combat/attack_coordinator.gd", "9ee63381"],
	["res://scripts/combat/damage_event.gd", "3b3185c4"],
	["res://scripts/combat/target_acquisition.gd", "bf4c14d4"],
	["res://scripts/combat/prototype_targetable.gd", "af29e970"],
	["res://scripts/movement/prototype_locomotion.gd", "c71de58f"],
	["res://scripts/movement/prototype_ground_pointer.gd", "ee7ab5ad"],
	["res://scripts/movement/prototype_mouse_hold.gd", "089e8dd5"],
	## First-MVP Gameplay J10 (D-340) moved Broken Watch's layout one for one, from `79c2b3a5`, so that its entry
	## socket stands clear of Riftfall Landing's Watch Breach far cap. Same count.
	["res://scripts/first_mvp/severed_threshold/broken_watch_layout.gd", "cac924df"],
	["res://scripts/prototype_zero/destination_marker.gd", "59a3e86d"],
	["res://scripts/camera/prototype_camera_rig.gd", "80c02363"],
	["res://scripts/input/input_family_tracker.gd", "8b721355"],
	["res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn", "e9d16993"],
	["res://scenes/actors/prototype_player.tscn", "3078a215"],
	["res://scenes/actors/prototype_graveblade.tscn", "752db86c"],
	["res://scenes/first_mvp/canonical_opening/canonical_opening.tscn", "b1d9f2e4"],
	["res://scenes/roguelite/roguelite_core_loop.tscn", "6bdf5388"],
	["res://data/prototype_zero/graveblade.tres", "56317f5f"],
	["res://data/first_mvp/severed_threshold/broken_watch/starting_sword.tres", "08e97d2e"],
	["res://data/first_mvp/severed_threshold/broken_watch/watchsteel_sword.tres", "e67730b2"],
	["res://project.godot", "55351038"],
	["res://tests/gate_1d_broken_watch_verification.gd", "9393f97a"],
	["res://tests/gate_1d_broken_watch_smoke.sh", "6f2878f7"],
	["res://tests/gate_1e_canonical_opening_verification.gd", "cef72cb6"],
	["res://tests/first_mvp_modal_left_click_smoke.sh", "977c05bd"],
	["res://tests/fallen_modal_life_state_smoke.sh", "9e0977fb"],
	["res://tests/roguelite_core_loop_verification.gd", "1c8e60d7"],
	["res://tests/roguelite_experience_collection_review_verification.gd", "c2c2d827"],
	["res://tests/roguelite_level_up_choice_review_verification.gd", "1f6bfa31"],
	["res://tests/roguelite_live_effect_review_verification.gd", "8ab346a6"],
	["res://tests/roguelite_repeated_live_effect_loop_verification.gd", "5fcf43e0"],
]

## The accepted words, typed independently of the code that shows them.
const KILLING_SOURCE: String = "Graveblade — Melee Hit — 125 Physical Damage"
const RESTART_CAPTION: String = "Restart Broken Watch"
const WALK_CLOSER: String = "Walk closer to inspect it"
const DROP_NAME: String = "Watchsteel Sword"

## Distances from the drop, along the route: inside and outside its 2.20 m interaction range.
const NEAR_DROP: float = 1.0
const LIVING_NEAR: float = 1.5
const FAR_DROP: float = 4.0
const NEAR: float = 1.2
## The controller's attempts inside the delay come first and the mouse click last, so that the family
## is still the controller's on every update up to the click. Each lands at the first frame with no
## more than this much left.
const PLAN_A: Array = [{"at": 0.70, "kind": "interact"}, {"at": 0.55, "kind": "direct"}, {"at": 0.40, "kind": "click"}]
## Where the Fallen evidence frame is taken, with `--shots` only.
const SHOT_AT: float = 0.85
const F5_AT: float = 0.45
const WINDOW_SECONDS: float = BrokenWatchSlice.FALLEN_DELAY + FirstMvpFallenOverlay.FADE_SECONDS + 0.4
## The drop's own pulse lifts an unselected ring at most this far from COPPER toward COPPER_BRIGHT.
const UNSELECTED_PULSE: float = 0.18
const COLOUR_TOLERANCE: float = 0.002

## A harness node that counts process updates. One runs before every other node, one after.
const PROBE_SOURCE: String = "extends Node\nvar ticks: int = 0\nvar on_tick: Callable\n\nfunc _process(_delta: float) -> void:\n\tticks += 1\n\tif on_tick.is_valid():\n\t\ton_tick.call(ticks)\n"
## Every mouse event the harness sends carries this device id. A harness node added after the scene,
## and so given each event before the slice, holds back every other mouse event: a real pointer on a
## rendered window cannot change the input family in the middle of a run.
const HARNESS_DEVICE: int = 3300
const FILTER_SOURCE: String = "extends Node\nvar device: int = 0\nvar held: int = 0\n\nfunc _input(event: InputEvent) -> void:\n\tif event is InputEventMouse and event.device != device:\n\t\theld += 1\n\t\tget_viewport().set_input_as_handled()\n"

const OWED_CHECKS: Array[String] = [
	"the_production_diff_is_exactly_the_one_authorized_line",
	"the_accepted_suites_moved_only_their_slice_pins",
	"the_line_sits_in_the_not_alive_branch_before_its_return",
	"the_reach_is_gate_1d_and_its_descendants_by_inheritance",
	"no_scene_input_map_or_project_setting_changed",
	"a_production_graveblade_death_creates_the_guaranteed_drop",
	"a_living_controller_player_in_range_soft_selects_the_drop",
	"production_graveblade_attacks_kill_the_player_and_arm_the_delay",
	"the_lethal_frame_is_read_before_any_process_or_drawn_frame",
	"the_first_process_update_clears_the_highlight",
	"the_highlight_stays_cleared_through_the_delay_as_the_countdown_falls",
	"the_j4_controller_direct_and_mouse_refusals_still_hold",
	"behind_the_fallen_overlay_the_highlight_stays_cleared",
	"after_a_normal_restart_range_and_family_still_drive_the_highlight",
	"a_living_comparison_and_equip_still_work_exactly_once",
	"f5_in_a_later_delay_still_cancels_before_the_revival",
	"the_guaranteed_drop_latch_still_permits_one_drop",
]

var arguments: PackedStringArray = PackedStringArray()
var slice: BrokenWatchSlice

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _staged: PackedStringArray = PackedStringArray()
var _next_use_id: int = 330000
var _shot_dir: String = ""
var _shots: PackedStringArray = PackedStringArray()

var _pre: Node = null
var _post: Node = null
var _filter: Node = null
## Where the post-slice probe appends its readings while a death is being watched.
var _tick_sink: Array = []
var _sinking: bool = false

var _drop_position: Vector3 = Vector3.INF
var _drops_created: int = 0
var _earned: Dictionary = {}
var _selection: Dictionary = {}
var _deaths: Dictionary = {}
var _living: Dictionary = {}
var _latch: Dictionary = {}
var _opened_pending: Array = []
## How often the harness had to close a comparison that should never have opened.
var _cleanups: int = 0


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	_shot_dir = _argument_value("--shots")
	print("")
	print("=== First-MVP UI J5 — Fallen-Delay Ground-Drop Highlight Clearing V1 verification (D-330) ===")

	_check_the_production_diff_is_exactly_the_one_authorized_line()
	_check_the_accepted_suites_moved_only_their_slice_pins()
	_check_the_line_sits_in_the_not_alive_branch_before_its_return()
	_check_the_reach_is_gate_1d_and_its_descendants_by_inheritance()
	_check_no_scene_input_map_or_project_setting_changed()

	await _play()
	if slice != null:
		_check_a_production_graveblade_death_creates_the_guaranteed_drop()
		_check_a_living_controller_player_in_range_soft_selects_the_drop()
		_check_production_graveblade_attacks_kill_the_player_and_arm_the_delay()
		_check_the_lethal_frame_is_read_before_any_process_or_drawn_frame()
		_check_the_first_process_update_clears_the_highlight()
		_check_the_highlight_stays_cleared_through_the_delay_as_the_countdown_falls()
		_check_the_j4_controller_direct_and_mouse_refusals_still_hold()
		_check_behind_the_fallen_overlay_the_highlight_stays_cleared()
		_check_after_a_normal_restart_range_and_family_still_drive_the_highlight()
		_check_a_living_comparison_and_equip_still_work_exactly_once()
		_check_f5_in_a_later_delay_still_cancels_before_the_revival()
		_check_the_guaranteed_drop_latch_still_permits_one_drop()

	_check_every_check_ran()
	if _post != null:
		_post.set("on_tick", Callable())
		_pre.queue_free()
		_post.queue_free()
		await process_frame

	print("")
	print("  staged: %s" % "; ".join(_staged))
	if _filter != null:
		print("  foreign pointer events held back: %d — 1 from the harness's own self-check, any other from a real pointer on the window" % int(_filter.get("held")))
	for shot: String in _shots:
		print("  screenshot: %s" % shot)
	if _failures.is_empty():
		print("FALLEN DELAY DROP HIGHLIGHT VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("FALLEN DELAY DROP HIGHLIGHT VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		quit(1)


# --- 1–5. Structure: the one line, its place, its reach ----------------------------------------

func _check_the_production_diff_is_exactly_the_one_authorized_line() -> void:
	print("")
	print("--- 1. Exactly one production file moved — Gate 1D's slice — and it is J4's file plus one line")
	var source: String = _before_j9(SLICE_SCRIPT, _before_j10(SLICE_SCRIPT, _before_j11(SLICE_SCRIPT, FileAccess.get_file_as_string(SLICE_SCRIPT))))
	var digest: String = source.sha256_text()
	var rebuilt: Dictionary = _put_back(source, J5_SLICE_MOVES)
	var j4_text: String = String(rebuilt["text"])
	var lines_now: int = source.count("\n")
	var lines_then: int = j4_text.count("\n")
	var removed: String = source.replace(J5_LINE, "")
	_expect(FileAccess.get_sha256(SLICE_SCRIPT).begins_with(String(J11_PREFIXES[SLICE_SCRIPT]))
			and _before_j11(SLICE_SCRIPT, FileAccess.get_file_as_string(SLICE_SCRIPT)).sha256_text().begins_with(String(J10_PREFIXES[SLICE_SCRIPT]))
			and _before_j10(SLICE_SCRIPT, _before_j11(SLICE_SCRIPT, FileAccess.get_file_as_string(SLICE_SCRIPT))).sha256_text().begins_with(String(J9_PREFIXES[SLICE_SCRIPT]))
			and digest.begins_with(J5_PREFIX) and bool(rebuilt["unique"]) and j4_text.sha256_text() == J4_SLICE_SHA256
			and source.count(J5_LINE) == 1 and lines_now == lines_then + 1 and removed.sha256_text() == J4_SLICE_SHA256,
		"the slice hashes %s; the branch occurs once: %s; the line occurs %d time(s); the reconstruction hashes %s; with the line removed it hashes %s"
			% [digest.left(8), str(rebuilt["unique"]), source.count(J5_LINE), j4_text.sha256_text().left(8), removed.sha256_text().left(8)])
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in UNCHANGED_HASHES:
		var held: String = FileAccess.get_sha256(String(row[0]))
		if not held.begins_with(String(row[1])):
			moved.append("%s %s" % [String(row[0]).get_file(), held.left(8)])
	_expect(moved.is_empty() and UNCHANGED_HASHES.size() == 48, "moved: %s" % ", ".join(moved))
	print("  the slice is at its J5 hash %s, %d lines; with J5's one line removed it is, byte for byte, J4's file %s, %d lines — once J9's two changes (D-338) are put back, and J10's clearing line (D-340) before them"
		% [J5_PREFIX, lines_now, J4_SLICE_SHA256.left(8), lines_then])
	print("  %d files J5 stands beside hold the hashes they held before the first J5 edit: the player, the modal contract, both Fallen overlays, the comparison, the HUD, the drop, the loadout, all 7 descendants of the slice, Prototype Zero's room, the combat, movement and camera kernels, five scenes, three records, project.godot and ten accepted suite files; the HUD since moved by J6 (D-332); Broken Watch's layout since moved by J10 (D-340)"
		% UNCHANGED_HASHES.size())
	_done("the_production_diff_is_exactly_the_one_authorized_line")


## Puts a file J6 moved back to where J5 left it (First-MVP UI J6, D-332).
func _before_j6(path: String, text: String) -> String:
	for pair: Array in J6_MOVES.get(path, []):
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


## Puts a file J7 moved back to where J6 left it (First-MVP UI J7, D-334).
func _before_j7(path: String, text: String) -> String:
	for pair: Array in J7_MOVES.get(path, []):
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


## Puts a file J8 moved back to where J7 left it (First-MVP UI J8, D-336).
func _before_j8(path: String, text: String) -> String:
	for pair: Array in J8_MOVES.get(path, []):
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


## Puts a file J9 moved back to where D-337 left it (First-MVP Gameplay J9, D-338).
func _before_j9(path: String, text: String) -> String:
	for pair: Array in J9_MOVES.get(path, []):
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


## Puts a file J10 moved back to where D-339 left it (First-MVP Gameplay J10, D-340).
func _before_j10(path: String, text: String) -> String:
	for pair: Array in J10_MOVES.get(path, []):
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


## Applies each [after, before] pair once; `unique` is false if any `after` does not occur exactly once.
func _put_back(text: String, pairs: Array) -> Dictionary:
	var unique: bool = true
	for pair: Array in pairs:
		if text.count(String(pair[0])) != 1:
			unique = false
		text = text.replace(String(pair[0]), String(pair[1]))
	return {"text": text, "unique": unique}


## Verification Maintenance V1 (decision D-342): resolves pair-list names through the one provenance engine — a
## String name to its pair list, a {key: name} Dictionary to {key: pair list}, and rows whose last field is a
## name to the same rows carrying the pair list — only while the engine is at its pinned SHA-256; otherwise
## every name resolves to an empty list, so every reconstruction that needs one fails.
static func _stored(ids: Variant) -> Variant:
	if FileAccess.get_sha256(PROVENANCE_ENGINE) == PROVENANCE_ENGINE_SHA256:
		return load(PROVENANCE_ENGINE).resolve(ids)
	printerr("  provenance refused: %s is not at its pinned SHA-256" % PROVENANCE_ENGINE)
	if ids is String:
		return []
	if ids is Dictionary:
		return {}
	var rows: Array = []
	for row: Array in ids:
		var empty: Array = row.slice(0, row.size() - 1)
		empty.append([])
		rows.append(empty)
	return rows


## Puts a file First-MVP Gameplay J11 (decision D-344) moved back to where D-343 left it.
func _before_j11(path: String, text: String) -> String:
	for pair: Array in J11_MOVES.get(path, []):
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


## Puts a file Verification Maintenance V1 moved back to where D-341 left it (decision D-342).
func _before_vm1(path: String, text: String) -> String:
	for pair: Array in VM1_MOVES.get(path, []):
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


func _check_the_accepted_suites_moved_only_their_slice_pins() -> void:
	print("")
	print("--- 2. The six accepted suite files that pinned the slice moved only their pins, one for one, at unchanged counts")
	var faults: PackedStringArray = PackedStringArray()
	var blocks: int = 0
	var back: PackedStringArray = PackedStringArray()
	for row: Array in MOVED_SUITES:
		var path: String = row[0]
		var j10_text: String = _before_vm1(path, _before_j11(path, FileAccess.get_file_as_string(path)))
		var j9_text: String = _before_j10(path, j10_text)
		var j8_text: String = _before_j9(path, j9_text)
		var j7_text: String = _before_j8(path, j8_text)
		var j6_text: String = _before_j7(path, j7_text)
		var j5_text: String = _before_j6(path, j6_text)
		var rebuilt: Dictionary = _put_back(j5_text, row[3])
		blocks += (row[3] as Array).size()
		back.append(String(row[2]).left(8))
		if not (FileAccess.get_sha256(path).begins_with(String(J11_PREFIXES.get(path, VM1_PREFIXES.get(path, J10_PREFIXES.get(path, J9_PREFIXES.get(path, J8_PREFIXES.get(path, J7_PREFIXES.get(path, J6_PREFIXES.get(path, row[1])))))))))
				and j10_text.sha256_text().begins_with(String(J10_PREFIXES.get(path, J9_PREFIXES.get(path, J8_PREFIXES.get(path, J7_PREFIXES.get(path, J6_PREFIXES.get(path, row[1])))))))
				and j9_text.sha256_text().begins_with(String(J9_PREFIXES.get(path, J8_PREFIXES.get(path, J7_PREFIXES.get(path, J6_PREFIXES.get(path, row[1]))))))
				and j8_text.sha256_text().begins_with(String(J8_PREFIXES.get(path, J7_PREFIXES.get(path, J6_PREFIXES.get(path, row[1])))))
				and j7_text.sha256_text().begins_with(String(J7_PREFIXES.get(path, J6_PREFIXES.get(path, row[1]))))
				and j6_text.sha256_text().begins_with(String(J6_PREFIXES.get(path, row[1]))) and j5_text.sha256_text().begins_with(String(row[1]))
				and bool(rebuilt["unique"]) and not (row[3] as Array).is_empty()
				and String(rebuilt["text"]).sha256_text() == String(row[2])):
			faults.append("%s at %s rebuilds to %s" % [path.get_file(), FileAccess.get_sha256(path).left(8), String(rebuilt["text"]).sha256_text().left(8)])
	_expect(faults.is_empty() and MOVED_SUITES.size() == 6, "; ".join(faults))
	print("  J1's and J2's verifications moved their slice row and the clause naming who moved it; J3's and J4's verifications and runners moved their slice and suite pins and the lines printing them: put back, the six are byte for byte %s (%d replaced blocks)"
		% [", ".join(back), blocks])
	_done("the_accepted_suites_moved_only_their_slice_pins")


func _check_the_line_sits_in_the_not_alive_branch_before_its_return() -> void:
	print("")
	print("--- 3. The line is the drop's existing public call, inside the existing not-alive branch, before it returns; nothing else in the slice moved")
	var source: String = _before_j11(SLICE_SCRIPT, FileAccess.get_file_as_string(SLICE_SCRIPT))
	var j4_text: String = String(_put_back(source, J5_SLICE_MOVES)["text"])
	var nameplate: PackedStringArray = _code_lines(_function_body(source, "_update_drop_nameplate"))
	var before: PackedStringArray = _code_lines(_function_body(j4_text, "_update_drop_nameplate"))
	var code: String = _bare(source)
	var callers: PackedStringArray = PackedStringArray()
	for name: String in _declared_functions(source):
		var body: String = _function_body(code, name)
		for index: int in body.count("_active_drop.set_soft_targeted("):
			callers.append(name)
	var inferences: PackedStringArray = PackedStringArray()
	var nameplate_code: String = _function_body(code, "_update_drop_nameplate")
	for word: String in INFERENCE_WORDS:
		if nameplate_code.contains(word):
			inferences.append(word)
	var fields: int = RegEx.create_from_string("(?m)^var ").search_all(source).size()
	var exports: int = RegEx.create_from_string("(?m)^@export var ").search_all(source).size()
	var constants: int = RegEx.create_from_string("(?m)^const ").search_all(source).size()
	var signals: int = RegEx.create_from_string("(?m)^signal ").search_all(source).size()
	var enums: int = RegEx.create_from_string("(?m)^enum ").search_all(source).size()
	var functions: PackedStringArray = _declared_functions(source)
	var head: PackedStringArray = nameplate.slice(0, NAMEPLATE_HEAD.size())
	_expect(head == PackedStringArray(NAMEPLATE_HEAD) and nameplate.size() == before.size() + 1
			and nameplate[nameplate.size() - 1] == NAMEPLATE_LAST and before[before.size() - 1] == NAMEPLATE_LAST
			and callers == PackedStringArray(["_update_drop_nameplate", "_update_drop_nameplate"])
			and code.count("player.is_alive()") == 3 and inferences.is_empty()
			and source.count("func _update_drop_nameplate() -> void:") == 1
			and _code_lines(_function_body(source, "_on_player_fell")) == PackedStringArray(FELL_LINES)
			and _code_lines(_function_body(source, "_tick_fallen_delay")) == PackedStringArray(TICK_LINES)
			and fields == SLICE_FIELDS and exports == SLICE_EXPORTS and functions.size() == SLICE_FUNCTIONS
			and constants == SLICE_CONSTANTS and signals == 0 and enums == 0 and functions == _declared_functions(j4_text),
		"head %s; %d lines against %d; callers %s; is_alive() %d; inferences %s; %d fields, %d exports, %d functions, %d constants, %d signals, %d enums"
			% [str(head), nameplate.size(), before.size(), str(callers), code.count("player.is_alive()"), str(inferences),
				fields, exports, functions.size(), constants, signals, enums])
	print("  _update_drop_nameplate(): the not-alive branch hides the nameplate, clears the prompt, then calls _active_drop.set_soft_targeted(false), then returns — before the camera read; %d code lines against J4's %d; its last line is still the living soft-selection write"
		% [nameplate.size(), before.size()])
	print("  _active_drop.set_soft_targeted() is called twice in the slice, both in _update_drop_nameplate(); player.is_alive() still occurs %d times; the function reads no Life, countdown, pending event, action state or neutral latch"
		% code.count("player.is_alive()"))
	print("  _on_player_fell() is its 5 accepted lines and _tick_fallen_delay() its 6 — no immediate lethal-call cleanup")
	print("  %d fields, %d exports, %d functions in J4's order, %d constants, no signal and no enum — the counts J4 left"
		% [fields, exports, functions.size(), constants])
	_done("the_line_sits_in_the_not_alive_branch_before_its_return")


func _check_the_reach_is_gate_1d_and_its_descendants_by_inheritance() -> void:
	print("")
	print("--- 4. What the line reaches (structural): Gate 1D, and every descendant of the slice by inheritance")
	var classes: Dictionary = {}
	var parents: Dictionary = {}
	var sources: Dictionary = {}
	var scanned: int = 0
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd"]):
			scanned += 1
			var code: String = _bare(FileAccess.get_file_as_string(path))
			sources[path] = code
			var named: RegExMatch = RegEx.create_from_string("(?m)^class_name (\\w+)").search(code)
			var parent: RegExMatch = RegEx.create_from_string("(?m)^extends (\\w+)").search(code)
			classes[path] = named.get_string(1) if named != null else ""
			parents[path] = parent.get_string(1) if parent != null else ""
	var lineage: PackedStringArray = PackedStringArray(["BrokenWatchSlice"])
	var descendants: PackedStringArray = PackedStringArray()
	for pass_index: int in 8:
		for path: String in sources.keys():
			if lineage.has(String(parents[path])) and not descendants.has(path):
				descendants.append(path)
				lineage.append(String(classes[path]))
	descendants.sort()
	var declarers: Array = []
	var soft_writers: Array = []
	for path: String in sources.keys():
		if String(sources[path]).contains("func _update_drop_nameplate("):
			declarers.append(String(path).get_file())
		if path != SLICE_SCRIPT and String(sources[path]).contains("_active_drop.set_soft_targeted("):
			soft_writers.append(String(path).get_file())
	declarers.sort()
	var no_super: PackedStringArray = PackedStringArray()
	var drop_owners: Array = []
	var names: PackedStringArray = PackedStringArray()
	for path: String in descendants:
		names.append(path.get_file())
		var body: String = _function_body(String(sources[path]), "_process")
		if String(sources[path]).contains("func _process(") and not body.contains("super"):
			no_super.append(path.get_file())
		if String(sources[path]).contains("_active_drop = "):
			drop_owners.append(path.get_file())
	_expect(scanned > 100 and descendants.size() == 7 and declarers == ["broken_watch_slice.gd"] and soft_writers.is_empty()
			and no_super.is_empty() and drop_owners == ["roguelite_core_loop_runtime.gd"]
			and not String(sources.get(PROTOTYPE_ROOM_SCRIPT, "")).contains("extends BrokenWatchSlice"),
		"descendants %s; declarers %s; soft writers %s; _process without super %s; drop owners %s" % [str(names), str(declarers), str(soft_writers), str(no_super), str(drop_owners)])
	print("  of %d running scripts, %d descend from BrokenWatchSlice: %s" % [scanned, descendants.size(), ", ".join(names)])
	print("  none overrides _update_drop_nameplate() or writes the drop's soft selection itself; every _process override among them calls super")
	print("  roguelite_core_loop_runtime.gd alone places its own reward in the inherited _active_drop, so the same line would clear it for a fallen roguelite character — structural only, not measured here")
	_done("the_reach_is_gate_1d_and_its_descendants_by_inheritance")


func _check_no_scene_input_map_or_project_setting_changed() -> void:
	print("")
	print("--- 5. The InputMap, the entrypoint and project.godot are untouched; scenes, the drop and the HUD hold their pre-J5 hashes (check 1)")
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	_expect(actions == EXPECTED_ACTIONS and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT
			and not settings.contains("[autoload]") and not settings.contains("fallen_delay") and not settings.contains("drop_highlight"),
		"%d actions, or project.godot moved" % actions)
	print("  %d actions; the entrypoint is %s; project.godot declares no [autoload] and names nothing of J5" % [actions, ENTRYPOINT.get_file()])
	_done("no_scene_input_map_or_project_setting_changed")


# --- The play, in Gate 1D's own slice ---------------------------------------------------------

func _play() -> void:
	slice = await _load(SLICE_SCENE) as BrokenWatchSlice
	if slice == null:
		return
	await _await_navigation()
	_install_probes()
	_quiet()
	slice.fallen_overlay.opened.connect(func() -> void: _opened_pending.append(slice._pending_fallen_event))
	slice.get_node("Actors").child_entered_tree.connect(func(node: Node) -> void:
		if node is FirstMvpItemDrop:
			_drops_created += 1)
	_note("Gate 1D's two Graveblades quieted; two harness nodes count every process update, one before the slice and one after it")
	var window: Vector2i = DisplayServer.window_get_size()
	var visible: Vector2 = root.get_visible_rect().size
	print("  display %s, window %dx%d, visible %dx%d" % [DisplayServer.get_name(), window.x, window.y, roundi(visible.x), roundi(visible.y)])

	await _earn_the_drop()
	if slice._active_drop == null:
		_failures.append("no guaranteed drop was created, so nothing after it can be measured")
		return
	_drop_position = slice._active_drop.global_position

	await _controller_selects_the_drop()
	var a: Dictionary = await _strike_player("A", _drop_position + _forward() * NEAR_DROP)
	await _through_the_delay(a, PLAN_A)
	await _behind_the_overlay(a)
	await _restart_by_confirm(a)
	_deaths["A"] = a

	await _living_highlight_after_restart()
	await _living_equip()

	var c: Dictionary = await _strike_player("C", slice.landing_layout.player_start())
	await _cancel_by_f5(c)
	_deaths["C"] = c

	var refused: int = _log_count("reward refused")
	var granted: int = _log_count("guaranteed drop")
	var created: int = _drops_created
	_kill(slice.graveblades[0])
	await _settle(3)
	_latch = {
		"refused": _log_count("reward refused") - refused, "granted": _log_count("guaranteed drop") - granted,
		"created": _drops_created - created, "created_total": _drops_created, "latched": slice._drop_granted,
		"active": slice._active_drop == null, "lines": _log_count("guaranteed drop"),
	}
	_note("the first Graveblade killed once more through receive_damage(), after every restart, to read the drop latch")


func _install_probes() -> void:
	var script: GDScript = GDScript.new()
	script.source_code = PROBE_SOURCE
	script.reload()
	_pre = Node.new()
	_pre.name = "J5ProbeBeforeTheSlice"
	_pre.set_script(script)
	_pre.process_priority = -1000000
	_pre.process_mode = Node.PROCESS_MODE_ALWAYS
	_post = Node.new()
	_post.name = "J5ProbeAfterTheSlice"
	_post.set_script(script)
	_post.process_priority = 1000000
	_post.process_mode = Node.PROCESS_MODE_ALWAYS
	_post.set("on_tick", _on_post_tick)
	root.add_child(_pre)
	root.add_child(_post)
	var filter: GDScript = GDScript.new()
	filter.source_code = FILTER_SOURCE
	filter.reload()
	_filter = Node.new()
	_filter.name = "J5ForeignPointerFilter"
	_filter.set_script(filter)
	_filter.set("device", HARNESS_DEVICE)
	_filter.process_mode = Node.PROCESS_MODE_ALWAYS
	root.add_child(_filter)
	_note("every mouse event the harness sends carries device id %d; a harness node ahead of the slice holds back every other mouse event, and one foreign pointer movement is sent on purpose to prove it" % HARNESS_DEVICE)


## What the slice and the drop left, read after every other node has processed.
func _on_post_tick(tick: int) -> void:
	if not _sinking or slice == null:
		return
	_tick_sink.append({
		"tick": tick, "nameplate": slice._nameplate.visible, "prompt": _prompt(), "panel": slice.hud._prompt_panel.visible,
		"paused": paused, "countdown": slice._fallen_countdown, "alive": slice.player.is_alive(),
		"comparison": slice.item_comparison.is_open, "overlay": slice.fallen_overlay.is_open,
		"has_drop": slice._active_drop != null, "soft": _soft(), "ring": _ring(slice._active_drop),
		"family": _family(), "in_range": _in_range(),
	})


func _pre_ticks() -> int:
	return int(_pre.get("ticks"))


## STAGED aim, real attack: the first Graveblade is placed on the route and the player's own Quick
## Strike, aimed through the slice's verification seam, kills it; the drop then comes out of the
## slice's own `died` handling.
func _earn_the_drop() -> void:
	var player: PrototypePlayer = slice.player
	var first: PrototypeGraveblade = slice.graveblades[0]
	var area: PrototypeTargetable = first.get_node("TargetArea") as PrototypeTargetable
	var forward: Vector3 = _forward()
	first.place_at(slice.landing_layout.player_start() + forward * 6.0)
	first.face_instantly(-forward)
	await _settle(2)
	var killed: Array = []
	first.died.connect(func(event: DamageEvent) -> void: killed.append(event))
	var trail: Array = [first.life]
	var uses: int = player.attack.uses_started
	for hit: int in 6:
		if not first.is_alive():
			break
		_stand_facing(first.global_position - forward * 1.0, forward)
		await _settle(1)
		slice.force_next_aim_for_verification(area)
		player.attack.press()
		player.attack.release_input()
		for frame: int in 120:
			await physics_frame
			if float(trail[-1]) > first.life and player.attack.phase == QuickStrikeAction.Phase.READY:
				break
		trail.append(first.life)
	await _settle(3)
	var drop: FirstMvpItemDrop = slice._active_drop
	_earned = {
		"trail": trail, "uses": player.attack.uses_started - uses, "dead": not first.is_alive(),
		"by_player": killed.size() == 1 and (killed[0] as DamageEvent).source == player,
		"damage": player.weapon.physical_damage, "created": _drops_created, "lines": _log_count("guaranteed drop"),
		"latched": slice._drop_granted, "drop": drop != null and drop.weapon != null and drop.weapon.resource_path == WATCHSTEEL_SWORD,
		"equipped": slice.loadout.equipped_weapon.resource_path, "owned": slice.loadout.owned_items.size(),
		"gap": _planar_gap(drop.global_position, first.global_position) if drop != null else -1.0,
	}
	_note("the first Graveblade placed on Riftfall Landing's route and struck by the player's own Quick Strike, aimed through force_next_aim_for_verification()")


## STAGED position, real input: the living character stands 1.0 m from the drop, read first with the
## mouse as the live family and then with the controller.
func _controller_selects_the_drop() -> void:
	var player: PrototypePlayer = slice.player
	var forward: Vector3 = _forward()
	await _until_neutral()
	_quiet()
	_stand_facing(_drop_position + forward * NEAR_DROP, forward)
	await _settle(2)
	await _await_process_frames(3)
	_selection["mouse"] = _reading()
	var at: Vector3 = player.global_position
	await _to_controller()
	await _await_process_frames(3)
	var on: Dictionary = _reading()
	on["moved"] = _planar_gap(at, player.global_position)
	# The filter's own proof: one 64-pixel pointer movement from device 0, as a real pointer's arrives.
	var held: int = int(_filter.get("held"))
	var foreign: InputEventMouseMotion = InputEventMouseMotion.new()
	foreign.position = _window_point(Vector2(400.0, 300.0))
	foreign.global_position = foreign.position
	foreign.relative = Vector2(64.0, 0.0)
	Input.parse_input_event(foreign)
	await _await_process_frames(3)
	on["foreign_held"] = int(_filter.get("held")) - held
	on["family_after_foreign"] = _family()
	on["soft_after_foreign"] = _soft()
	_selection["controller"] = on
	var shot: String = await _capture("01_living_controller_in_range_selected")
	if not shot.is_empty():
		_shots.append("%s — alive, the %s live, %.2f m from the drop, soft_selected %s, ring %s, prompt \"%s\""
			% [shot, _family(), _planar_gap(player.global_position, _drop_position), str(_soft()), _ring_word(_ring(slice._active_drop)), _prompt()])
	_note("the living character placed %.1f m from the drop before death A" % NEAR_DROP)


## STAGED: one left-stick deflection past the tracker's 0.20 threshold, and its return to rest, pushed
## into the root viewport. The tracker reads it in the slice's own `_input`; the Input singleton never
## sees it, so the stick actions the character moves by stay at rest.
func _to_controller() -> void:
	await _family_cooldown()
	_push_axis(JOY_AXIS_LEFT_X, 0.5)
	_push_axis(JOY_AXIS_LEFT_X, 0.0)
	for frame: int in 30:
		if slice.input_family.family == InputFamilyTracker.Family.CONTROLLER:
			break
		await process_frame
	_note("the controller made the live family by one left-stick deflection pushed into the root viewport, which the Input singleton never sees")


## STAGED start, real Hits: the player is placed at `stand` facing the route and the second Graveblade
## 1.2 m in front of it; each attack is begun through the Graveblade's own verification seam. `fell` is
## heard twice: at once, to count the process updates and drawn frames at the lethal Hit, and DEFERRED
## — after the lethal call stack has returned and before the slice processes again — to read the drop.
func _strike_player(label: String, stand: Vector3) -> Dictionary:
	var player: PrototypePlayer = slice.player
	var killer: PrototypeGraveblade = slice.graveblades[1]
	var forward: Vector3 = _forward()
	await _until_neutral()
	_quiet()
	_stand_facing(stand, forward)
	killer.place_at(stand + forward * NEAR)
	killer.face_instantly(-forward)
	await _settle(2)
	await _await_process_frames(3)
	var counts: Dictionary = {"took_damage": 0, "fell": 0}
	var emissions: Array = []
	var record: Dictionary = {
		"label": label, "counts": counts, "emissions": emissions, "trail": [], "began": 0,
		"life_before": player.life, "killer": killer, "ticks": [], "living": _reading(),
	}
	var on_life: Callable = func(current: float, maximum: float) -> void:
		emissions.append({"life": current, "max": maximum, "state": player.action_state_name(),
			"countdown": slice._fallen_countdown, "pending_null": slice._pending_fallen_event == null})
	var on_damage: Callable = func(_event: DamageEvent) -> void: counts["took_damage"] = int(counts["took_damage"]) + 1
	var on_fell: Callable = func(event: DamageEvent) -> void:
		counts["fell"] = int(counts["fell"]) + 1
		record["at_kill"] = {"pre": _pre_ticks(), "physics": Engine.is_in_physics_frame(), "process": Engine.get_process_frames(),
			"drawn": Engine.get_frames_drawn(), "countdown": slice._fallen_countdown, "pending": slice._pending_fallen_event == event,
			"soft": _soft(), "ring": _ring(slice._active_drop)}
		_tick_sink = record["ticks"]
		_sinking = true
	var on_fell_deferred: Callable = func(event: DamageEvent) -> void: _on_lethal_frame(record, event)
	player.life_changed.connect(on_life)
	player.took_damage.connect(on_damage)
	player.fell.connect(on_fell)
	player.fell.connect(on_fell_deferred, CONNECT_DEFERRED)
	record["listeners"] = [on_life, on_damage, on_fell, on_fell_deferred]

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
	record["event"] = event
	record["dead"] = not player.is_alive()
	record["from_killer"] = event != null and event.source == killer
	return record


## The lethal frame: the deferred call on `fell`, before the slice has processed again.
func _on_lethal_frame(record: Dictionary, event: DamageEvent) -> void:
	var player: PrototypePlayer = slice.player
	var at_kill: Dictionary = record.get("at_kill", {})
	record["lethal"] = {
		"same_step": _pre_ticks() == int(at_kill.get("pre", -1)),
		"process_same": Engine.get_process_frames() == int(at_kill.get("process", -1)), "process": Engine.get_process_frames(),
		"drawn_same": Engine.get_frames_drawn() == int(at_kill.get("drawn", -1)), "drawn": Engine.get_frames_drawn(),
		"state": player.action_state_name(), "alive": player.is_alive(), "life": player.life,
		"has_drop": slice._active_drop != null, "soft": _soft(), "ring": _ring(slice._active_drop), "family": _family(),
		"in_range": _in_range(), "gap": _planar_gap(player.global_position, _drop_position),
		"nameplate": slice._nameplate.visible, "centre": slice._nameplate.get_global_rect().get_center(), "prompt": _prompt(),
		"paused": paused, "countdown": slice._fallen_countdown, "pending": slice._pending_fallen_event == event,
		"overlay": slice.fallen_overlay.is_open, "comparison": slice.item_comparison.is_open,
	}


## Samples every process frame of the delay until the overlay opens by itself, making each planned
## attempt at the first frame with no more than its time left. A comparison that opened anyway is closed
## so the run can go on, and counted. `updated` marks a sample read after at least one slice process
## update since the lethal Hit.
func _through_the_delay(record: Dictionary, plan: Array) -> void:
	var player: PrototypePlayer = slice.player
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var event: DamageEvent = record["event"]
	var at_pre: int = int((record.get("at_kill", {}) as Dictionary).get("pre", -9))
	var opens: int = overlay.opens
	var opened_mark: int = _opened_pending.size()
	var samples: Array = []
	var attempts: Array = []
	var next: int = 0
	var shot_taken: bool = false
	for frame: int in 900:
		if overlay.is_open:
			break
		samples.append({"remaining": slice._fallen_countdown, "paused": paused, "alive": player.is_alive(), "life": player.life,
			"pending": slice._pending_fallen_event == event, "comparison": slice.item_comparison.is_open,
			"updated": _pre_ticks() > at_pre, "soft": _soft(), "ordinary": bool(_ring(slice._active_drop).get("ordinary", false))})
		if slice.item_comparison.is_open:
			slice.item_comparison.close("verification cleanup")
			_cleanups += 1
		if not _shot_dir.is_empty() and not shot_taken and slice._fallen_countdown > 0.0 and slice._fallen_countdown <= SHOT_AT:
			shot_taken = true
			await _capture_fallen()
		if next < plan.size() and slice._fallen_countdown > 0.0 and slice._fallen_countdown <= float(plan[next]["at"]):
			attempts.append(await _attempt(record, String(plan[next]["kind"])))
			next += 1
		await process_frame
	record["samples"] = samples
	record["attempts"] = attempts
	record["planned"] = plan.size()
	var at_open: Array = _opened_pending.slice(opened_mark)
	var focus: Control = overlay.default_focus()
	record["opened"] = {
		"once": overlay.is_open and overlay.opens == opens + 1 and at_open.size() == 1,
		"with_event": at_open.size() == 1 and at_open[0] == event, "source": overlay.killing_source,
		"state": player.action_state_name(), "alive": player.is_alive(), "paused": paused,
		"countdown": slice._fallen_countdown, "pending_is_event": slice._pending_fallen_event == event,
		"focused": focus != null and root.gui_get_focus_owner() == focus and focus.name == RESTART_CAPTION,
	}


## The Fallen evidence frame, with `--shots` only.
func _capture_fallen() -> void:
	var shot: String = await _capture("02_fallen_delay_ring_ordinary")
	if shot.is_empty():
		return
	_shots.append("%s — %s, %.3f s of the delay left, the %s live, soft_selected %s, ring %s, nameplate %s, prompt \"%s\", overlay %s"
		% [shot, slice.player.action_state_name(), slice._fallen_countdown, _family(), str(_soft()), _ring_word(_ring(slice._active_drop)),
			"shown" if slice._nameplate.visible else "hidden", _prompt(), "open" if slice.fallen_overlay.is_open else "not open"])


## One attempt at the item from inside the delay: the controller's interact, the opener itself, or a
## left click where the nameplate stood on the lethal frame (J1's route).
func _attempt(record: Dictionary, kind: String) -> Dictionary:
	var player: PrototypePlayer = slice.player
	var event: DamageEvent = record["event"]
	var before: Dictionary = _item_state()
	var message: Dictionary = _hud_message()
	var remaining: float = slice._fallen_countdown
	var logs: int = slice.log_lines.size()
	var result: Dictionary = {"kind": kind, "remaining": remaining, "soft_before": _soft(), "family": _family(), "in_range": _in_range()}
	match kind:
		"click":
			var centre: Vector2 = (record.get("lethal", {}) as Dictionary).get("centre", slice._nameplate.get_global_rect().get_center())
			result["press"] = await _parse_press_at(centre)
		"interact":
			_push_joy(JOY_BUTTON_A, true)
			result["synchronous"] = _synchronous(remaining, message)
			_push_joy(JOY_BUTTON_A, false)
		"direct":
			slice.open_item_comparison("verification")
			result["synchronous"] = _synchronous(remaining, message)
			_note("the opener called directly once, inside death A's delay, for the direct-entry refusal")
	await _await_process_frames(1)
	result["comparison"] = slice.item_comparison.is_open
	result["paused"] = paused
	result["after"] = _item_state()
	result["same"] = _same_items(before, result["after"])
	result["countdown_after"] = slice._fallen_countdown
	result["pending"] = slice._pending_fallen_event == event
	result["nameplate"] = slice._nameplate.visible
	result["prompt"] = _prompt()
	result["state"] = player.action_state_name()
	result["destination"] = player.has_destination
	result["soft_after"] = _soft()
	result["ordinary_after"] = bool(_ring(slice._active_drop).get("ordinary", false))
	result["new_logs"] = slice.log_lines.slice(logs)
	return result


## Read in the same call as the attempt, before any frame can pass.
func _synchronous(remaining: float, message: Dictionary) -> Dictionary:
	return {
		"comparison": slice.item_comparison.is_open, "paused": paused, "countdown_same": slice._fallen_countdown == remaining,
		"message_same": _hud_message() == message, "message": _hud_message(), "soft": _soft(),
	}


## Behind the standing overlay: 10 paused physics and 5 idle frames, each read.
func _behind_the_overlay(record: Dictionary) -> void:
	var faults: PackedStringArray = PackedStringArray()
	var read: int = 0
	for frame: int in 10:
		await physics_frame
		read += 1
		if not _behind_ok():
			faults.append("physics frame %d %s" % [frame, str(_reading())])
	for frame: int in 5:
		await process_frame
		read += 1
		if not _behind_ok():
			faults.append("idle frame %d %s" % [frame, str(_reading())])
	record["behind"] = {"faults": faults, "read": read, "reading": _reading()}


func _behind_ok() -> bool:
	return (slice.fallen_overlay.is_open and paused and not slice.item_comparison.is_open and not slice._nameplate.visible
		and _prompt().is_empty() and not slice.player.is_alive() and slice._active_drop != null and not _soft()
		and bool(_ring(slice._active_drop).get("ordinary", false)))


## Enter on the overlay's focused "Restart Broken Watch" — J3's accepted route.
func _restart_by_confirm(record: Dictionary) -> void:
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var restarts: int = _log_count("slice restarted")
	var closes: int = overlay.closes
	_push_key(KEY_ENTER, true)
	record["restart"] = {
		"closed_once": not overlay.is_open and overlay.closes == closes + 1,
		"restarted_once": _log_count("slice restarted") == restarts + 1 and _last_log("slice restarted").ends_with("Fallen"),
		"alive": slice.player.is_alive(), "countdown": slice._fallen_countdown, "pending_null": slice._pending_fallen_event == null,
	}
	_push_key(KEY_ENTER, false)
	_sinking = false
	_quiet()
	_disconnect(record)
	await _settle(3)


## J3's cancellation, read again: F5 into the slice's own input handling at the first frame with no
## more than F5_AT left, the restart read in its own call, then the window after it.
func _cancel_by_f5(record: Dictionary) -> void:
	var player: PrototypePlayer = slice.player
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var counts: Dictionary = record["counts"]
	var opens: int = overlay.opens
	for frame: int in 600:
		if overlay.is_open or (slice._fallen_countdown > 0.0 and slice._fallen_countdown <= F5_AT):
			break
		await process_frame
	var remaining: float = slice._fallen_countdown
	var restarts: int = _log_count("slice restarted")
	var mark: int = (record["emissions"] as Array).size()
	_push_key(KEY_F5, true)
	var reading: Dictionary = {
		"remaining": remaining, "revivals": (record["emissions"] as Array).slice(mark),
		"restarted_once": _log_count("slice restarted") == restarts + 1 and _last_log("slice restarted").ends_with("quick restart"),
		"countdown": slice._fallen_countdown, "pending_null": slice._pending_fallen_event == null,
		"alive": player.is_alive() and player.action_state == PrototypePlayer.ActionState.IDLE, "full": player.life == player.max_life,
		"overlay_untouched": not overlay.is_open and overlay.opens == opens,
	}
	_push_key(KEY_F5, false)
	_sinking = false
	_quiet()
	var fell: int = int(counts["fell"])
	var restarted: int = _log_count("slice restarted")
	var faults: PackedStringArray = PackedStringArray()
	var frames: int = 0
	var started: int = Time.get_ticks_msec()
	while Time.get_ticks_msec() - started < int(WINDOW_SECONDS * 1000.0):
		await process_frame
		frames += 1
		if (overlay.is_open or overlay.opens != opens or paused or not player.is_alive() or slice._fallen_countdown != -1.0
				or slice._pending_fallen_event != null or _log_count("slice restarted") != restarted or int(counts["fell"]) != fell):
			if faults.size() < 4:
				faults.append("frame %d" % frames)
	reading["window"] = {"frames": frames, "seconds": float(Time.get_ticks_msec() - started) / 1000.0, "faults": faults}
	if overlay.is_open:
		overlay.close("verification cleanup")
		_cleanups += 1
	record["restart"] = reading
	_disconnect(record)


# --- The living character, after a normal restart ---------------------------------------------

## STAGED positions, real input: the living character is placed in range, out of range and in range
## again with the controller live, then the mouse is made live by one real pointer movement.
func _living_highlight_after_restart() -> void:
	var forward: Vector3 = _forward()
	await _until_neutral()
	_quiet()
	_stand_facing(_drop_position + forward * LIVING_NEAR, forward)
	await _settle(2)
	await _await_process_frames(3)
	await _to_controller()
	await _await_process_frames(3)
	_living["near"] = _reading()
	_stand_facing(_drop_position + forward * FAR_DROP, forward)
	await _settle(2)
	await _await_process_frames(3)
	_living["far"] = _reading()
	_stand_facing(_drop_position + forward * LIVING_NEAR, forward)
	await _settle(2)
	await _await_process_frames(3)
	_living["back"] = _reading()
	await _point_with_the_mouse(slice._nameplate.get_global_rect().get_center())
	await _await_process_frames(3)
	_living["mouse"] = _reading()
	_note("the living character placed %.1f m, %.1f m and %.1f m from the drop after the restart" % [LIVING_NEAR, FAR_DROP, LIVING_NEAR])


## The accepted living route: the controller's interact in range opens the comparison, joypad right
## moves focus to Equip and (A) equips.
func _living_equip() -> void:
	var player: PrototypePlayer = slice.player
	var comparison: FirstMvpItemComparison = slice.item_comparison
	var reasons: Array = []
	var on_closed: Callable = func(reason: String) -> void: reasons.append(reason)
	comparison.closed.connect(on_closed)
	var near: Dictionary = _item_state()
	var by_pad: Dictionary = {"gap": _planar_gap(player.global_position, _drop_position)}
	var opens: int = comparison.opens
	await _family_cooldown()
	_push_joy(JOY_BUTTON_A, true)
	by_pad["open"] = comparison.is_open
	by_pad["opens"] = comparison.opens - opens
	by_pad["log"] = _last_log("item comparison opened").ends_with("controller interact")
	by_pad["paused"] = paused
	by_pad["focus"] = root.gui_get_focus_owner() == comparison.default_focus() and comparison.default_focus() != null
	_push_joy(JOY_BUTTON_A, false)
	var equips: Array = [0]
	var on_equip: Callable = func(_record: PrototypeWeaponData) -> void: equips[0] = int(equips[0]) + 1
	player.weapon_changed.connect(on_equip)
	reasons.clear()
	_push_joy(JOY_BUTTON_DPAD_RIGHT, true)
	_push_joy(JOY_BUTTON_DPAD_RIGHT, false)
	by_pad["equip_focused"] = root.gui_get_focus_owner() == _named(comparison, "Equip")
	_push_joy(JOY_BUTTON_A, true)
	_push_joy(JOY_BUTTON_A, false)
	await _await_process_frames(3)
	by_pad["equips"] = equips[0]
	by_pad["closed"] = not comparison.is_open and reasons == ["equipped"] and not paused
	by_pad["drop_gone"] = slice._active_drop == null and _item_state()["drops"] == 0
	by_pad["owned"] = int(_item_state()["owned"]) - int(near["owned"])
	by_pad["equipped"] = slice.loadout.equipped_weapon.resource_path == WATCHSTEEL_SWORD
	by_pad["weapon"] = player.weapon.resource_path == WATCHSTEEL_SWORD
	by_pad["lines"] = _log_count("weapon equipped") - int(near["equipped_logs"])
	var after_opens: int = comparison.opens
	_push_joy(JOY_BUTTON_A, true)
	_push_joy(JOY_BUTTON_A, false)
	await _await_process_frames(2)
	by_pad["again"] = {"opens": comparison.opens - after_opens, "equips": equips[0], "open": comparison.is_open}
	player.weapon_changed.disconnect(on_equip)
	comparison.closed.disconnect(on_closed)
	_living["by_pad"] = by_pad


# --- 6–17. What the play measured -------------------------------------------------------------

func _check_a_production_graveblade_death_creates_the_guaranteed_drop() -> void:
	print("")
	print("--- 6. A production Graveblade, killed by the player's own Quick Strike, creates the guaranteed drop through the slice's own route")
	_expect(_floats(_earned.get("trail", [])) == "300, 200, 100, 0" and int(_earned.get("uses", 0)) == 3 and bool(_earned.get("dead", false))
			and bool(_earned.get("by_player", false)) and float(_earned.get("damage", 0.0)) == 100.0 and int(_earned.get("created", 0)) == 1
			and int(_earned.get("lines", 0)) == 1 and bool(_earned.get("latched", false)) and bool(_earned.get("drop", false))
			and String(_earned.get("equipped", "")) == STARTING_SWORD and float(_earned.get("gap", 9.0)) < 0.6,
		"earned %s" % str(_earned))
	print("  3 Quick Strikes at 100: Life %s; the Graveblade's own died, from the player, gave one guaranteed drop — the Watchsteel Sword — one 'guaranteed drop' line, the latch set, the Worn Sword still equipped"
		% _floats(_earned.get("trail", [])).replace(", ", " -> "))
	_done("a_production_graveblade_death_creates_the_guaranteed_drop")


func _check_a_living_controller_player_in_range_soft_selects_the_drop() -> void:
	print("")
	print("--- 7. A living character in range: with the mouse live the drop is not controller-highlighted; with the controller live it is soft-selected and its ring bright")
	var mouse: Dictionary = _selection.get("mouse", {})
	var pad: Dictionary = _selection.get("controller", {})
	_expect(bool(mouse.get("alive", false)) and mouse.get("family", "") == "mouse" and bool(mouse.get("in_range", false))
			and not bool(mouse.get("soft", true)) and bool((mouse.get("ring", {}) as Dictionary).get("ordinary", false))
			and mouse.get("prompt", "") == "%s — Left click" % DROP_NAME
			and bool(pad.get("alive", false)) and pad.get("family", "") == "controller" and bool(pad.get("in_range", false))
			and bool(pad.get("soft", false)) and bool((pad.get("ring", {}) as Dictionary).get("selected", false))
			and pad.get("prompt", "") == "%s — (A) Inspect" % DROP_NAME and bool(pad.get("nameplate", false))
			and not bool(pad.get("comparison", true)) and float(pad.get("moved", 9.0)) < 0.01
			and int(pad.get("foreign_held", 0)) >= 1 and pad.get("family_after_foreign", "") == "controller" and bool(pad.get("soft_after_foreign", false)),
		"mouse %s; controller %s" % [str(mouse), str(pad)])
	print("  alive, %.2f m from the drop with the mouse live: soft_selected false, the ring %s, the prompt \"%s — Left click\""
		% [float(mouse.get("gap", 0.0)), _ring_word(mouse.get("ring", {})), DROP_NAME])
	print("  the same spot with the controller live: soft_selected true, the ring %s, the prompt \"%s — (A) Inspect\"; the stick deflection moved the character %.3f m"
		% [_ring_word(pad.get("ring", {})), DROP_NAME, float(pad.get("moved", 0.0))])
	print("  one 64-pixel pointer movement from a device other than the harness's own was held back by the harness's filter: the controller stayed live and the drop soft-selected")
	_done("a_living_controller_player_in_range_soft_selects_the_drop")


func _death_ok(record: Dictionary) -> bool:
	var lethal: Dictionary = record.get("lethal", {})
	var at_kill: Dictionary = record.get("at_kill", {})
	var counts: Dictionary = record["counts"]
	return (bool(record["dead"]) and bool(record["from_killer"]) and _floats(record["trail"]) == "375, 250, 125, 0"
		and float(record["life_before"]) == 500.0 and int(counts["took_damage"]) == 4 and int(record["began"]) == 4 and int(counts["fell"]) == 1
		and is_equal_approx(float(at_kill.get("countdown", 0.0)), BrokenWatchSlice.FALLEN_DELAY) and bool(at_kill.get("pending", false))
		and lethal.get("state", "") == "FALLEN" and not bool(lethal.get("alive", true)) and float(lethal.get("life", -1.0)) == 0.0
		and not bool(lethal.get("overlay", true)) and not bool(lethal.get("paused", true)) and bool(lethal.get("pending", false))
		and is_equal_approx(float(lethal.get("countdown", 0.0)), BrokenWatchSlice.FALLEN_DELAY) and bool(lethal.get("same_step", false)))


func _check_production_graveblade_attacks_kill_the_player_and_arm_the_delay() -> void:
	print("")
	print("--- 8. Two deaths, each to 4 of the second Graveblade's own attacks, each arming the normal 0.90 s delay on the lethal frame")
	var faults: PackedStringArray = PackedStringArray()
	var steps: PackedStringArray = PackedStringArray()
	for label: String in ["A", "C"]:
		var record: Dictionary = _deaths.get(label, {})
		if record.is_empty() or not _death_ok(record):
			faults.append("%s: lethal %s, at kill %s, trail %s" % [label, str(record.get("lethal", {})), str(record.get("at_kill", {})), str(record.get("trail", []))])
		else:
			steps.append("%s %s" % [label, "physics" if bool(record["at_kill"]["physics"]) else "process"])
	var a: Dictionary = (_deaths.get("A", {}) as Dictionary).get("living", {})
	var c: Dictionary = (_deaths.get("C", {}) as Dictionary).get("living", {})
	_expect(faults.is_empty() and bool(a.get("soft", false)) and bool(a.get("in_range", false)) and a.get("family", "") == "controller"
			and bool(a.get("has_drop", false)) and not bool(c.get("has_drop", true)),
		"%s; before A %s; before C %s" % ["; ".join(faults), str(a), str(c)])
	print("  2 deaths: Life 500 -> 375 -> 250 -> 125 -> 0 each; on each lethal frame FALLEN, not alive, no overlay, not paused, the countdown armed at exactly 0.90 s and the pending event the killing Hit itself; one took_damage per Hit and one fell")
	print("  before death A's first Hit the character stood %.2f m from the drop, in range, the controller live and the drop soft-selected; death C came after the drop was equipped"
		% float(a.get("gap", 0.0)))
	print("  timing: the lethal Hit landed in the %s step" % ", ".join(steps))
	_done("production_graveblade_attacks_kill_the_player_and_arm_the_delay")


func _check_the_lethal_frame_is_read_before_any_process_or_drawn_frame() -> void:
	print("")
	print("--- 9. The lethal frame, read after the lethal call has returned and before the slice processes again: the selection J5 does not own")
	var record: Dictionary = _deaths.get("A", {})
	var lethal: Dictionary = record.get("lethal", {})
	var at_kill: Dictionary = record.get("at_kill", {})
	_expect(bool(at_kill.get("physics", false)) and bool(lethal.get("same_step", false)) and bool(lethal.get("process_same", false))
			and bool(lethal.get("drawn_same", false)) and bool(lethal.get("has_drop", false)) and bool(lethal.get("in_range", false))
			and lethal.get("family", "") == "controller" and lethal.get("state", "") == "FALLEN" and not bool(lethal.get("alive", true))
			and bool(lethal.get("nameplate", false)) and not bool(lethal.get("comparison", true)) and not bool(lethal.get("overlay", true))
			and not bool(lethal.get("paused", true)) and bool(lethal.get("pending", false))
			and is_equal_approx(float(lethal.get("countdown", 0.0)), BrokenWatchSlice.FALLEN_DELAY),
		"lethal %s; at kill %s" % [str(lethal), str(at_kill)])
	print("  the lethal Hit landed in a physics step; in a deferred call on fell the slice's pre-probe count, the engine's process-frame count and its drawn-frame count were all unchanged — no process update and no drawn frame since the lethal Hit")
	print("  in that interval the drop was soft_selected %s and its ring %s — still as the last living update left them; the character FALLEN, not alive, %.2f m from the drop with the controller live, the nameplate not yet hidden, no comparison, no overlay, not paused, the countdown armed at 0.90 s"
		% [str(lethal.get("soft", "?")), _ring_word(lethal.get("ring", {})), float(lethal.get("gap", 0.0))])
	print("  timing: death A — process frames %d -> %d, frames drawn %d -> %d (%s)"
		% [int(at_kill.get("process", -1)), int(lethal.get("process", -1)), int(at_kill.get("drawn", -1)), int(lethal.get("drawn", -1)),
			DisplayServer.get_name()])
	_done("the_lethal_frame_is_read_before_any_process_or_drawn_frame")


func _first_update(record: Dictionary) -> Dictionary:
	var owed: int = int((record.get("at_kill", {}) as Dictionary).get("pre", -9)) + 1
	for reading: Dictionary in record.get("ticks", []):
		if int(reading["tick"]) == owed:
			return reading
	return {}


func _check_the_first_process_update_clears_the_highlight() -> void:
	print("")
	print("--- 10. On the slice's first process update after the lethal frame the drop is no longer soft-selected and its ring is ordinary")
	var record: Dictionary = _deaths.get("A", {})
	var first: Dictionary = _first_update(record)
	var ring: Dictionary = first.get("ring", {})
	var countdown: float = float(first.get("countdown", -1.0))
	_expect(not first.is_empty() and bool(first.get("has_drop", false)) and not bool(first.get("soft", true)) and bool(ring.get("ordinary", false))
			and not bool(first.get("nameplate", true)) and String(first.get("prompt", "x")).is_empty() and not bool(first.get("panel", true))
			and not bool(first.get("comparison", true)) and not bool(first.get("paused", true)) and not bool(first.get("alive", true))
			and not bool(first.get("overlay", true)) and countdown > 0.0 and countdown < BrokenWatchSlice.FALLEN_DELAY
			and first.get("family", "") == "controller" and bool(first.get("in_range", false)),
		"first update %s" % str(first))
	print("  read after every node's first process update past the lethal frame: soft_selected %s and the ring %s — with the %s live and the character in range: %s"
		% [str(first.get("soft", "?")), _ring_word(ring), String(first.get("family", "?")), str(first.get("in_range", "?"))])
	print("  the nameplate hidden, the prompt empty, the prompt panel hidden, no comparison, the tree unpaused, and the countdown running at %.3f s" % countdown)
	_done("the_first_process_update_clears_the_highlight")


func _check_the_highlight_stays_cleared_through_the_delay_as_the_countdown_falls() -> void:
	print("")
	print("--- 11. On every update and every sampled frame of the delay the drop stays unselected, and the countdown never rises or freezes")
	var record: Dictionary = _deaths.get("A", {})
	var faults: PackedStringArray = PackedStringArray()
	var owed: int = int((record.get("at_kill", {}) as Dictionary).get("pre", -9)) + 1
	var previous: float = INF
	var updates: int = 0
	var pad_updates: int = 0
	for reading: Dictionary in record.get("ticks", []):
		if int(reading["tick"]) < owed or bool(reading["overlay"]):
			continue
		updates += 1
		if reading["family"] == "controller" and bool(reading["in_range"]):
			pad_updates += 1
		if (bool(reading["soft"]) or not bool((reading["ring"] as Dictionary).get("ordinary", false)) or not bool(reading["has_drop"])
				or bool(reading["paused"]) or float(reading["countdown"]) >= previous or float(reading["countdown"]) <= 0.0):
			faults.append("update %s" % str(reading))
			break
		previous = float(reading["countdown"])
	previous = INF
	var interval: int = 0
	var samples: Array = record.get("samples", [])
	for sample: Dictionary in samples:
		if not bool(sample["updated"]):
			interval += 1
		if ((bool(sample["updated"]) and (bool(sample["soft"]) or not bool(sample["ordinary"])))
				or bool(sample["paused"]) or bool(sample["alive"]) or float(sample["life"]) != 0.0 or not bool(sample["pending"])
				or bool(sample["comparison"]) or float(sample["remaining"]) > previous or float(sample["remaining"]) <= 0.0):
			faults.append("sample %s" % str(sample))
			break
		previous = float(sample["remaining"])
	var opened: Dictionary = record.get("opened", {})
	var restart: Dictionary = record.get("restart", {})
	_expect(faults.is_empty() and updates > 20 and pad_updates >= 10 and samples.size() - interval > 20
			and bool(opened.get("once", false)) and bool(opened.get("with_event", false)) and opened.get("source", "") == KILLING_SOURCE
			and opened.get("state", "") == "FALLEN" and bool(opened.get("paused", false)) and float(opened.get("countdown", 0.0)) == -1.0
			and bool(opened.get("pending_is_event", false)) and bool(opened.get("focused", false))
			and bool(restart.get("closed_once", false)) and bool(restart.get("restarted_once", false)) and bool(restart.get("alive", false))
			and float(restart.get("countdown", 0.0)) == -1.0 and bool(restart.get("pending_null", false))
			and _cleanups == 0 and _opened_pending.size() == 1 and slice.fallen_overlay.opens == 1,
		"%s; %d updates, %d with the controller in range, %d samples before the first update; opened %s; restart %s; cleanups %d; overlay opened %d time(s)"
			% ["; ".join(faults), updates, pad_updates, interval, str(opened), str(restart), _cleanups, slice.fallen_overlay.opens])
	print("  on every one of death A's %d process updates from the first after the lethal frame until Fallen opened: soft_selected false, the ring ordinary, the tree unpaused, and the countdown strictly lower than at the update before"
		% updates)
	print("  %d of those updates came with the controller still live and the character still in range — every update before the delay's one mouse click" % pad_updates)
	print("  on every sampled frame after the first update: soft_selected false and the ring ordinary; on every sampled frame: not paused, FALLEN at 0, the killing Hit pending, no comparison, the countdown never rising; the harness's cleanup path ran %d times"
		% _cleanups)
	print("  Fallen then opened exactly once, on the original killing Hit, \"%s\" on the overlay, its restart button focused; Enter on it restarted the slice once" % KILLING_SOURCE)
	print("  timing: death A's delay — %d frames sampled, %d before the first update; %d process updates read" % [samples.size(), interval, updates])
	_done("the_highlight_stays_cleared_through_the_delay_as_the_countdown_falls")


func _attempt_left_nothing(attempt: Dictionary) -> bool:
	return (not bool(attempt["comparison"]) and not bool(attempt["paused"]) and bool(attempt["same"]) and bool(attempt["pending"])
		and attempt["state"] == "FALLEN" and not bool(attempt["destination"]) and not bool(attempt["nameplate"])
		and String(attempt["prompt"]).is_empty() and not bool(attempt["soft_before"]) and not bool(attempt["soft_after"])
		and bool(attempt["ordinary_after"]) and float(attempt["countdown_after"]) < float(attempt["remaining"])
		and float(attempt["countdown_after"]) > 0.0)


func _check_the_j4_controller_direct_and_mouse_refusals_still_hold() -> void:
	print("")
	print("--- 12. J4's refusals hold inside the delay — the controller's interact in range, the direct opener, a left click where the nameplate stood — and none of them re-selects the drop")
	var attempts: Array = (_deaths.get("A", {}) as Dictionary).get("attempts", [])
	var kinds: PackedStringArray = PackedStringArray()
	var times: PackedStringArray = PackedStringArray()
	var faults: PackedStringArray = PackedStringArray()
	var logged: PackedStringArray = PackedStringArray()
	for attempt: Dictionary in attempts:
		kinds.append(String(attempt["kind"]))
		times.append("%.3f" % float(attempt["remaining"]))
		var ok: bool = _attempt_left_nothing(attempt)
		match String(attempt["kind"]):
			"interact":
				var now: Dictionary = attempt["synchronous"]
				ok = (ok and bool(attempt["in_range"]) and attempt["family"] == "controller" and not bool(now["comparison"]) and not bool(now["paused"])
					and bool(now["countdown_same"]) and bool(now["message_same"]) and String((now["message"] as Dictionary)["text"]) != WALK_CLOSER
					and not bool(now["soft"]) and (attempt["new_logs"] as Array).is_empty())
			"direct":
				var now: Dictionary = attempt["synchronous"]
				ok = (ok and not bool(now["comparison"]) and not bool(now["paused"]) and bool(now["countdown_same"]) and bool(now["message_same"])
					and not bool(now["soft"]) and (attempt["new_logs"] as Array).is_empty())
			"click":
				var press: Dictionary = attempt["press"]
				ok = ok and int(press["down"]) == 0 and int(press["pressed"]) == 0
		if not ok:
			faults.append(str(attempt))
		for line: String in attempt["new_logs"]:
			logged.append(line.substr(15).strip_edges())
	_expect(kinds == PackedStringArray(["interact", "direct", "click"]) and faults.is_empty(), "%s; %s" % [str(kinds), "; ".join(faults)])
	print("  one joypad (A) press in range with the controller live: read in the same call, no comparison, no pause, the countdown not moved, the HUD message untouched, no \"Walk closer\"; nothing logged")
	print("  open_item_comparison(\"verification\") called directly: no comparison, no pause, the countdown not moved; nothing logged")
	print("  one left press and release through Input.parse_input_event() where the nameplate stood: it reached no nameplate, which stayed hidden; no comparison, no pause")
	print("  after each, the drop and loadout unchanged, the character FALLEN with no destination, the countdown still falling, and the drop still unselected with its ring ordinary; the slice logged, in all: %s"
		% ("nothing" if logged.is_empty() else "; ".join(logged)))
	print("  timing: the three attempts with %s s of 0.90 left" % ", ".join(times))
	_done("the_j4_controller_direct_and_mouse_refusals_still_hold")


func _check_behind_the_fallen_overlay_the_highlight_stays_cleared() -> void:
	print("")
	print("--- 13. Behind the Fallen overlay the drop stays unselected, the nameplate hidden and the comparison closed")
	var behind: Dictionary = (_deaths.get("A", {}) as Dictionary).get("behind", {})
	var reading: Dictionary = behind.get("reading", {})
	_expect(not behind.is_empty() and (behind["faults"] as PackedStringArray).is_empty() and int(behind.get("read", 0)) == 15,
		"behind %s" % str(behind))
	print("  %d paused physics and idle frames read with the overlay standing and the tree paused, %d of them faulted: the last soft_selected %s, the ring %s, the nameplate hidden, the prompt empty, no comparison"
		% [int(behind.get("read", 0)), (behind.get("faults", PackedStringArray()) as PackedStringArray).size(), str(reading.get("soft", "?")),
			_ring_word(reading.get("ring", {}))])
	_done("behind_the_fallen_overlay_the_highlight_stays_cleared")


func _check_after_a_normal_restart_range_and_family_still_drive_the_highlight() -> void:
	print("")
	print("--- 14. After a normal restart the living highlight follows range and family exactly as before")
	var near: Dictionary = _living.get("near", {})
	var far: Dictionary = _living.get("far", {})
	var back: Dictionary = _living.get("back", {})
	var mouse: Dictionary = _living.get("mouse", {})
	var selected: Callable = func(reading: Dictionary) -> bool:
		return (bool(reading.get("alive", false)) and reading.get("family", "") == "controller" and bool(reading.get("in_range", false))
			and bool(reading.get("soft", false)) and bool((reading.get("ring", {}) as Dictionary).get("selected", false))
			and reading.get("prompt", "") == "%s — (A) Inspect" % DROP_NAME)
	_expect(selected.call(near) and selected.call(back)
			and bool(far.get("alive", false)) and far.get("family", "") == "controller" and not bool(far.get("in_range", true))
			and not bool(far.get("soft", true)) and bool((far.get("ring", {}) as Dictionary).get("ordinary", false))
			and far.get("prompt", "") == "%s — walk closer" % DROP_NAME
			and bool(mouse.get("alive", false)) and mouse.get("family", "") == "mouse" and bool(mouse.get("in_range", false))
			and not bool(mouse.get("soft", true)) and bool((mouse.get("ring", {}) as Dictionary).get("ordinary", false))
			and mouse.get("prompt", "") == "%s — Left click" % DROP_NAME,
		"near %s; far %s; back %s; mouse %s" % [str(near), str(far), str(back), str(mouse)])
	print("  alive with the controller live: %.2f m from the drop, soft-selected and the ring %s; %.2f m away, unselected and the ring %s, the prompt \"— walk closer\"; back at %.2f m, soft-selected again"
		% [float(near.get("gap", 0.0)), _ring_word(near.get("ring", {})), float(far.get("gap", 0.0)), _ring_word(far.get("ring", {})), float(back.get("gap", 0.0))])
	print("  one real pointer movement made the mouse live: still in range, unselected, the ring %s, the prompt \"— Left click\"" % _ring_word(mouse.get("ring", {})))
	_done("after_a_normal_restart_range_and_family_still_drive_the_highlight")


func _check_a_living_comparison_and_equip_still_work_exactly_once() -> void:
	print("")
	print("--- 15. A living character in range opens the comparison with the controller's interact and equips through the existing path exactly once")
	var by_pad: Dictionary = _living.get("by_pad", {})
	var again: Dictionary = by_pad.get("again", {})
	_expect(bool(by_pad.get("open", false)) and int(by_pad.get("opens", 0)) == 1
			and bool(by_pad.get("log", false)) and bool(by_pad.get("paused", false)) and bool(by_pad.get("focus", false))
			and bool(by_pad.get("equip_focused", false)) and int(by_pad.get("equips", 0)) == 1 and bool(by_pad.get("closed", false))
			and bool(by_pad.get("drop_gone", false)) and int(by_pad.get("owned", 0)) == 1 and bool(by_pad.get("equipped", false))
			and bool(by_pad.get("weapon", false)) and int(by_pad.get("lines", 0)) == 1
			and int(again.get("opens", -1)) == 0 and int(again.get("equips", -1)) == 1 and not bool(again.get("open", true)),
		"by pad %s" % str(by_pad))
	print("  %.2f m from the drop one joypad (A) press opened the comparison once ('controller interact'), paused, Close focused" % float(by_pad.get("gap", 0.0)))
	print("  joypad right moved focus to Equip and (A) pressed it: one weapon_changed, one 'weapon equipped' line, the comparison closed as 'equipped', the drop gone, one more item owned, the Watchsteel Sword equipped and swung; one more (A) opened nothing")
	_done("a_living_comparison_and_equip_still_work_exactly_once")


func _check_f5_in_a_later_delay_still_cancels_before_the_revival() -> void:
	print("")
	print("--- 16. J3 intact: F5 inside a later delay cancels the pending Fallen before the revival, and no old overlay opens afterwards")
	var record: Dictionary = _deaths.get("C", {})
	var restart: Dictionary = record.get("restart", {})
	var revivals: Array = restart.get("revivals", [])
	var window: Dictionary = restart.get("window", {})
	var revival: Dictionary = revivals[0] if revivals.size() == 1 else {}
	_expect(float(restart.get("remaining", 0.0)) > 0.0 and float(restart.get("remaining", 1.0)) <= F5_AT and revivals.size() == 1
			and float(revival.get("life", 0.0)) == 500.0 and revival.get("state", "") == "IDLE" and float(revival.get("countdown", 0.0)) == -1.0
			and bool(revival.get("pending_null", false)) and bool(restart.get("restarted_once", false)) and float(restart.get("countdown", 0.0)) == -1.0
			and bool(restart.get("pending_null", false)) and bool(restart.get("alive", false)) and bool(restart.get("full", false))
			and bool(restart.get("overlay_untouched", false)) and (window.get("faults", ["missing"]) as Array).is_empty()
			and float(window.get("seconds", 0.0)) >= WINDOW_SECONDS,
		"restart %s" % str(restart))
	print("  F5 with %.3f s of 0.90 left: one restart_current_slice() (quick restart), one revival to 500 / 500 IDLE — at which the countdown already read -1.0 and the pending event was already null — and no Fallen overlay, pause, second restart or fall in the %.2f s after"
		% [float(restart.get("remaining", 0.0)), float(window.get("seconds", 0.0))])
	_done("f5_in_a_later_delay_still_cancels_before_the_revival")


func _check_the_guaranteed_drop_latch_still_permits_one_drop() -> void:
	print("")
	print("--- 17. The guaranteed-drop latch still permits exactly the accepted single drop")
	_expect(int(_latch.get("refused", 0)) == 1 and int(_latch.get("granted", -1)) == 0 and int(_latch.get("created", -1)) == 0
			and int(_latch.get("created_total", 0)) == 1 and bool(_latch.get("latched", false)) and bool(_latch.get("active", false))
			and int(_latch.get("lines", 0)) == 1,
		"latch %s" % str(_latch))
	print("  one drop was ever created, through 2 deaths, 2 restarts and one equip; one more kill of the first Graveblade was refused ('reward refused') with no second drop and no second 'guaranteed drop' line")
	_done("the_guaranteed_drop_latch_still_permits_one_drop")


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


# --- Readings ---------------------------------------------------------------------------------

## The drop's own public selection flag; false when there is no drop.
func _soft() -> bool:
	return slice._active_drop != null and slice._active_drop.soft_selected


func _in_range() -> bool:
	return slice._active_drop != null and slice._active_drop.player_is_in_range(slice.player.global_position)


func _family() -> String:
	return "controller" if slice.input_family.family == InputFamilyTracker.Family.CONTROLLER else "mouse"


func _reading() -> Dictionary:
	return {
		"alive": slice.player.is_alive(), "has_drop": slice._active_drop != null, "soft": _soft(), "ring": _ring(slice._active_drop),
		"family": _family(), "in_range": _in_range(),
		"gap": _planar_gap(slice.player.global_position, _drop_position) if _drop_position != Vector3.INF else -1.0,
		"nameplate": slice._nameplate.visible, "prompt": _prompt(), "comparison": slice.item_comparison.is_open, "paused": paused,
	}


## The colour the drop's own `_process` last wrote into its existing ring material, and which of its two
## presentations that is: selected is COPPER_BRIGHT; ordinary is COPPER lifted by the drop's pulse at
## most UNSELECTED_PULSE of the way toward COPPER_BRIGHT.
func _ring(drop: FirstMvpItemDrop) -> Dictionary:
	if drop == null or not is_instance_valid(drop):
		return {}
	var mesh: MeshInstance3D = drop.get_node_or_null("Visual/GroundRing") as MeshInstance3D
	if mesh == null or not (mesh.material_override is StandardMaterial3D):
		return {}
	var colour: Color = (mesh.material_override as StandardMaterial3D).albedo_color
	var low: Color = FirstMvpItemDrop.COPPER
	var high: Color = FirstMvpItemDrop.COPPER_BRIGHT
	var lift: float = (colour.r - low.r) / (high.r - low.r)
	var ordinary: bool = (lift >= -COLOUR_TOLERANCE and lift <= UNSELECTED_PULSE + COLOUR_TOLERANCE
		and _close(colour, low.lerp(high, clampf(lift, 0.0, 1.0))))
	return {"colour": colour, "selected": _close(colour, high), "ordinary": ordinary, "lift": lift}


func _close(a: Color, b: Color) -> bool:
	return (absf(a.r - b.r) <= COLOUR_TOLERANCE and absf(a.g - b.g) <= COLOUR_TOLERANCE
		and absf(a.b - b.b) <= COLOUR_TOLERANCE and absf(a.a - b.a) <= COLOUR_TOLERANCE)


func _ring_word(ring: Dictionary) -> String:
	if ring.is_empty():
		return "absent"
	var colour: Color = ring["colour"]
	var rgb: String = "(%.2f, %.2f, %.2f)" % [colour.r, colour.g, colour.b]
	if bool(ring["selected"]):
		return "bright %s, COPPER_BRIGHT" % rgb
	if bool(ring["ordinary"]):
		return "ordinary copper %s, lifted %.2f by the pulse" % [rgb, float(ring["lift"])]
	return "neither presentation %s" % rgb


## Everything an item interaction could move: the drop, ownership, the loadout, the swung weapon, and
## the comparison with its log line.
func _item_state() -> Dictionary:
	var drops: int = 0
	for node: Node in slice.get_node("Actors").get_children():
		if node is FirstMvpItemDrop and not node.is_queued_for_deletion():
			drops += 1
	var active: FirstMvpItemDrop = slice._active_drop
	return {
		"drops": drops, "active": active.get_instance_id() if active != null else 0, "owned": slice.loadout.owned_items.size(),
		"equipped": slice.loadout.equipped_weapon.resource_path, "weapon": slice.player.weapon.resource_path,
		"equipped_logs": _log_count("weapon equipped"), "open": slice.item_comparison.is_open, "opens": slice.item_comparison.opens,
		"opened_logs": _log_count("item comparison opened"),
	}


func _same_items(a: Dictionary, b: Dictionary) -> bool:
	for key: String in ["drops", "active", "owned", "equipped", "weapon", "equipped_logs", "open", "opens", "opened_logs"]:
		if a.get(key) != b.get(key):
			return false
	return true


func _hud_message() -> Dictionary:
	return {"text": slice.hud._message_label.text, "visible": slice.hud._message_label.visible, "timer": slice.hud._message_timer}


func _prompt() -> String:
	return slice.hud._prompt_label.text


func _floats(values: Array) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for value: Variant in values:
		parts.append(_n(float(value)))
	return ", ".join(parts)


func _quiet() -> void:
	for enemy: PrototypeGraveblade in slice.graveblades:
		enemy.set_ai_enabled(false)


func _disconnect(record: Dictionary) -> void:
	var player: PrototypePlayer = slice.player
	var listeners: Array = record.get("listeners", [])
	var signals: Array[Signal] = [player.life_changed, player.took_damage, player.fell, player.fell]
	for index: int in listeners.size():
		var callable: Callable = listeners[index]
		if signals[index].is_connected(callable):
			signals[index].disconnect(callable)
	# Two listeners hold the record they write into; dropping them here breaks that cycle.
	record.erase("listeners")


## The input-family tracker ignores a change inside its own anti-flicker cooldown; wait it out.
func _family_cooldown() -> void:
	var tracker: InputFamilyTracker = slice.input_family
	for frame: int in 60:
		if tracker._time_since_switch > tracker.switch_cooldown_seconds + 0.02:
			return
		await process_frame


## STAGED: one real pointer movement through `Input.parse_input_event()`, far enough for the tracker to
## call the mouse the live family.
func _point_with_the_mouse(local: Vector2) -> void:
	await _family_cooldown()
	var motion: InputEventMouseMotion = _motion_event(local)
	motion.relative = Vector2(64.0, 0.0)
	Input.parse_input_event(motion)
	for frame: int in 30:
		await process_frame
		if slice.input_family.family == InputFamilyTracker.Family.MOUSE_KEYBOARD:
			break
	await _await_process_frames(2)
	_note("one pointer movement made the mouse the live input family after the restart")


# --- The world --------------------------------------------------------------------------------

## Changes to the accepted scene exactly as it ships and waits until it stands.
func _load(path: String) -> Node:
	var changed: Error = change_scene_to_packed(load(path) as PackedScene)
	for frame: int in 60:
		await process_frame
		if current_scene != null and current_scene.scene_file_path == path:
			break
	if changed != OK or current_scene == null or current_scene.scene_file_path != path:
		_failures.append("%s did not load" % path.get_file())
		return null
	return current_scene


func _await_navigation() -> void:
	for frame: int in 900:
		if NavigationServer3D.map_get_iteration_id(slice.navigation_map()) > 0:
			break
		await physics_frame
	await _settle(10)


func _forward() -> Vector3:
	var facing: Vector3 = slice.route_forward()
	facing.y = 0.0
	return facing.normalized()


func _stand_facing(at: Vector3, facing: Vector3) -> void:
	slice.player.global_position = Vector3(at.x, 0.0, at.z)
	slice.player.velocity = Vector3.ZERO
	slice.player.clear_movement_intent("verification", false)
	slice.camera_rig.focus = slice.player.global_position
	slice.player.face_instantly(facing)


func _until_neutral() -> void:
	for frame: int in 60:
		if not slice.player.awaiting_neutral:
			return
		await physics_frame


func _kill(enemy: PrototypeGraveblade) -> void:
	enemy.receive_damage(DamageEvent.physical(_use(), slice.player, enemy, enemy.life + 1000.0))
	_expect_quiet(not enemy.is_alive(), "%s did not die from a lethal hit" % enemy.name)


func _note(text: String) -> void:
	if not _staged.has(text):
		_staged.append(text)


func _log_count(token: String) -> int:
	var count: int = 0
	for line: String in slice.log_lines:
		if line.contains(token):
			count += 1
	return count


func _last_log(token: String) -> String:
	for index: int in range(slice.log_lines.size() - 1, -1, -1):
		if slice.log_lines[index].contains(token):
			return slice.log_lines[index]
	return ""


func _named(panel: Control, node_name: String) -> Button:
	for node: Node in panel.find_children(node_name, "Button", true, false):
		return node as Button
	_failures.append("no button named %s in %s" % [node_name, panel.name])
	return null


func _planar_gap(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()


func _n(value: float) -> String:
	if is_equal_approx(value, roundf(value)):
		return "%d" % roundi(value)
	return "%.2f" % value


func _use() -> int:
	_next_use_id += 1
	return _next_use_id


func _argument_value(flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


# --- The pointer, the keyboard and the controller ---------------------------------------------

## Window coordinates for a point in the viewport's own space: the stretch transform, applied the way
## the operating system's pointer arrives through it.
func _window_point(local: Vector2) -> Vector2:
	return root.get_final_transform() * local


func _motion_event(local: Vector2) -> InputEventMouseMotion:
	var motion: InputEventMouseMotion = InputEventMouseMotion.new()
	var at: Vector2 = _window_point(local)
	motion.device = HARNESS_DEVICE
	motion.position = at
	motion.global_position = at
	return motion


func _button_event(local: Vector2, index: MouseButton, pressed: bool) -> InputEventMouseButton:
	var click: InputEventMouseButton = InputEventMouseButton.new()
	var at: Vector2 = _window_point(local)
	click.device = HARNESS_DEVICE
	click.button_index = index
	click.pressed = pressed
	click.position = at
	click.global_position = at
	return click


## One real left press and release at `local` through `Input.parse_input_event()`, delivered at the next
## frame's input flush; counts what reached the ground-item nameplate.
func _parse_press_at(local: Vector2) -> Dictionary:
	var nameplate: Button = slice._nameplate
	var hits: Array = [0, 0]
	var on_down: Callable = func() -> void: hits[0] = int(hits[0]) + 1
	var on_pressed: Callable = func() -> void: hits[1] = int(hits[1]) + 1
	nameplate.button_down.connect(on_down)
	nameplate.pressed.connect(on_pressed)
	Input.parse_input_event(_motion_event(local))
	Input.parse_input_event(_button_event(local, MOUSE_BUTTON_LEFT, true))
	Input.parse_input_event(_button_event(local, MOUSE_BUTTON_LEFT, false))
	await _await_process_frames(2)
	var result: Dictionary = {"down": hits[0], "pressed": hits[1]}
	nameplate.button_down.disconnect(on_down)
	nameplate.pressed.disconnect(on_pressed)
	return result


func _push_key(keycode: Key, pressed: bool) -> void:
	var event: InputEventKey = InputEventKey.new()
	event.keycode = keycode
	event.physical_keycode = keycode
	event.pressed = pressed
	root.push_input(event)


## One joypad button pushed into the root viewport, the way a connected controller's arrives.
func _push_joy(button: JoyButton, pressed: bool) -> void:
	var event: InputEventJoypadButton = InputEventJoypadButton.new()
	event.device = 0
	event.button_index = button
	event.pressed = pressed
	event.pressure = 1.0 if pressed else 0.0
	root.push_input(event)


## One joypad axis pushed into the root viewport only. The Input singleton never sees it, so the
## InputMap's stick actions — which the character moves by — stay at rest.
func _push_axis(axis: JoyAxis, value: float) -> void:
	var event: InputEventJoypadMotion = InputEventJoypadMotion.new()
	event.device = 0
	event.axis = axis
	event.axis_value = value
	root.push_input(event)


func _settle(frames: int) -> void:
	for frame: int in frames:
		await physics_frame


func _await_process_frames(frames: int) -> void:
	for frame: int in frames:
		await process_frame


# --- Evidence ---------------------------------------------------------------------------------

## Adds no assertion: the rendered runs pin the same count as the headless one. Returns the saved path
## and the frame's size, or "" when no `--shots` directory was given.
func _capture(stem: String) -> String:
	if _shot_dir.is_empty():
		return ""
	await _await_process_frames(2)
	for i: int in 3:
		await RenderingServer.frame_post_draw
	var path: String = "%s/%s.png" % [_shot_dir, stem]
	var image: Image = root.get_texture().get_image()
	if image == null or image.save_png(path) != OK:
		_failures.append("could not write the evidence frame %s" % path)
		return ""
	return "%s (%dx%d)" % [path, image.get_width(), image.get_height()]


# --- Source readings --------------------------------------------------------------------------

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
