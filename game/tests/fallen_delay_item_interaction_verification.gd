extends SceneTree
## First-MVP UI J4 — Fallen-Delay Item-Interaction Gating V1: automated verification (decision D-328).
##
## THE ONE QUESTION: while the character is not alive — from the lethal Hit, through the 0.90 s Fallen
## delay, and behind the Fallen overlay — can any ground-item presentation or interaction open or
## operate the item comparison? After J4 it cannot. `open_item_comparison()`, `_try_interact_with_drop()`
## and `_update_drop_nameplate()` each ask `player.is_alive()`, and nothing else.
##
## THE SLICE IS THE ONLY PRODUCTION FILE J4 MOVES, and that is proved by reconstruction: with J4's three
## comments and three guards removed it is, byte for byte, the file J3 left.
##
## GATE 1D'S OWN `broken_watch_slice.tscn`, LOADED AS IT SHIPS AND GIVEN NO FLAG OF ITS OWN. The drop is
## earned by the player's own Quick Strikes, every death is dealt by the production Graveblade's own
## attacks, and every press reaches the slice through the root viewport.
##
## SAME FRAME, THEN THE FIRST PROCESS UPDATE. The nameplate is placed and shown by
## `_update_drop_nameplate()`, which runs in the slice's `_process`, so on the lethal frame it still stands
## where the last living update left it. The press that proves the opener's own refusal is made in a
## DEFERRED call on the player's own `fell` — after the lethal call stack has returned and before the
## slice processes again — and goes straight into the root viewport with `push_input()`, because
## `Input.parse_input_event()` would hold it until the next frame's input flush, after the nameplate had
## already been hidden. Two harness nodes count every process update, one before the slice and one after
## it; the second reads what the slice left.
##
## STAGED, AND STATED WHERE IT HAPPENS:
##   - both Graveblades are quieted; the first is placed, and the player's Quick Strike is aimed at it
##     through the slice's own verification seam `force_next_aim_for_verification()`;
##   - before each death the player is placed near the drop and the second Graveblade 1.2 m in front of
##     it; each attack is begun through `begin_attack_for_verification()`;
##   - before each living interaction the player is placed at a measured distance from the drop;
##   - two harness nodes read every process update; the direct opener is called exactly once, for the
##     direct-entry refusal; the first Graveblade is killed once more through `receive_damage()` at the
##     end, to read the drop latch.
##
## Mouse input is simulated — the lethal-frame press through `push_input()`, every other click through
## `Input.parse_input_event()` (J1's route) — and controller input is joypad events pushed into the root
## viewport. None of it is physical-device certification. Headless; no screenshot.
##
## IT PORTS D-211's OWED-SET DISCIPLINE.
##
## Run: godot --headless --path game --script res://tests/fallen_delay_item_interaction_verification.gd

const THIS_FILE: String = "res://tests/fallen_delay_item_interaction_verification.gd"
const SLICE_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
const SLICE_SCENE: String = "res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
const OPENING_SCRIPT: String = "res://scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
const PROTOTYPE_ROOM_SCRIPT: String = "res://scripts/prototype_zero/prototype_zero.gd"
const GRAVEBLADE_RECORD: String = "res://data/prototype_zero/graveblade.tres"
const STARTING_SWORD: String = "res://data/first_mvp/severed_threshold/broken_watch/starting_sword.tres"
const WATCHSTEEL_SWORD: String = "res://data/first_mvp/severed_threshold/broken_watch/watchsteel_sword.tres"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31
const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]

## The slice as J3 left it, whole, and J4's six insertions into it, exactly as written. Each pair is
## [as J4 wrote it, as J3 left it]; the guards carry the line after them so that each is unique.
const J3_SLICE_SHA256: String = "b35e04a6cad4d665bd92e7b3cdd2bad1ee284f10a46095b31430fd25a5229848"
const J4_PREFIX: String = "c204a087"
const OPEN_COMMENT: String = "## The one funnel into the item comparison: the nameplate's click and the\n## controller's interact both arrive here. It refuses a character that is not\n## alive (First-MVP UI J4, decision D-328), asking `player.is_alive()` and\n## nothing else, so a press that reaches the nameplate on the lethal frame —\n## before `_update_drop_nameplate()` has run again to hide it — opens nothing.\n"
const INTERACT_COMMENT: String = "## The controller's route to the comparison. A character that is not alive is\n## refused before the range is measured or a message is written (J4, D-328).\n"
const NAMEPLATE_COMMENT: String = "## While the character is not alive the nameplate is hidden and the prompt\n## cleared (J4, D-328). That takes effect from the first process update after\n## the lethal frame; a press before it is refused by `open_item_comparison()`.\n"
const J4_SLICE_MOVES: Array = [
	[OPEN_COMMENT, ""],
	[INTERACT_COMMENT, ""],
	[NAMEPLATE_COMMENT, ""],
	["\tif not player.is_alive():\n\t\treturn\n\tlog_event(\"item comparison opened\", reason)\n",
		"\tlog_event(\"item comparison opened\", reason)\n"],
	["\tif not player.is_alive():\n\t\treturn\n\tif not _active_drop.player_is_in_range(player.global_position):\n",
		"\tif not _active_drop.player_is_in_range(player.global_position):\n"],
	["\tif not player.is_alive():\n\t\t_nameplate.visible = false\n\t\thud.show_item_prompt(\"\")\n\t\treturn\n", ""],
]

## The three functions' code lines after J4.
const OPEN_LINES: Array[String] = [
	"if _active_drop == null:", "return", "if item_comparison.is_open or fallen_overlay.is_open:", "return",
	"if not player.is_alive():", "return", "log_event(\"item comparison opened\", reason)", "item_comparison.open_for(_active_drop)",
]
const INTERACT_LINES: Array[String] = [
	"if _active_drop == null:", "return", "if item_comparison.is_open or fallen_overlay.is_open:", "return",
	"if not player.is_alive():", "return", "if not _active_drop.player_is_in_range(player.global_position):",
	"hud.show_message(\"Walk closer to inspect it\")", "return", "open_item_comparison(\"controller interact\")",
]
const NAMEPLATE_HEAD: Array[String] = [
	"if _active_drop == null or _nameplate == null:", "if _nameplate != null:", "_nameplate.visible = false",
	"hud.show_item_prompt(\"\")", "return", "if not player.is_alive():", "_nameplate.visible = false",
	"hud.show_item_prompt(\"\")", "return", "var camera: Camera3D = camera_rig.camera",
]
const SIGNATURES: Array[String] = [
	"func open_item_comparison(reason: String) -> void:", "func _try_interact_with_drop() -> void:",
	"func _update_drop_nameplate() -> void:",
]
## Words a Life-state inference would need. None may appear in the three functions.
const INFERENCE_WORDS: Array[String] = ["life", "_fallen_countdown", "_pending_fallen_event", "action_state", "FALLEN", "awaiting_neutral"]

## The slice's declarations, as J3 left them.
const SLICE_FIELDS: int = 35
const SLICE_EXPORTS: int = 8
const SLICE_FUNCTIONS: int = 53
const SLICE_CONSTANTS: int = 12

## The four accepted suites J4 moved, each put back to exactly what it was before the first J4 edit.
## Each pair is [as J4 wrote it, as it stood before]; filled in from the finished edits.
const J1_VERIFICATION: String = "res://tests/first_mvp_modal_left_click_verification.gd"
const J2_VERIFICATION: String = "res://tests/fallen_modal_life_state_verification.gd"
const J3_VERIFICATION: String = "res://tests/pending_fallen_restart_verification.gd"
const J3_SMOKE: String = "res://tests/pending_fallen_restart_smoke.sh"

## Verification Maintenance V1 (decision D-342): every pair list this suite uses to put a file back lives in
## the flat, content-addressed provenance store under res://tests/provenance/, named by the SHA-256 of its
## listing. Each `*_ROWS` and `*_MOVE_IDS` constant below names its pair lists, and the variable of the old name
## holds them resolved, so every check reads exactly as before. They are resolved through the one engine there,
## and only while it is at the SHA-256 pinned here; a pair list the store cannot prove resolves to nothing.
const PROVENANCE_ENGINE: String = "res://tests/provenance/accepted_suite_provenance.gd"
const PROVENANCE_ENGINE_SHA256: String = "fadbdfeba32546d03bffe876c2b8be7a96dfe966ff9f5d4f720199d664b23dc4"

const MOVED_SUITE_ROWS: Array = [
	[J1_VERIFICATION, "c6fe40f1", "2f5a32ca57fa0a6f9184632ae2c209442d8f4490e557dd9cd5a7d41147cc1649", "e7c6a280965ce30c24f15af9293c569e1c2a772ee7b42dc64994bc242c956173"],
	[J2_VERIFICATION, "a3f97de5", "b04b0a1e6e7807d888b51e4a960e7601c508374b82f6676f3962e361577e1f41", "3f7cad03ff1f196393d3f592bbba200cb9b88b50dc3b867e2a3559c9cd493e08"],
	[J3_VERIFICATION, "565a0a4f", "51c8560c8cf3cfa09ccfd49786b5dbb6c00bd3bfac08ef7f59fc4de174442bb4", "babdbbc9a93baa7a82e63f5ef4f9017ee58f826dbc2d1bffca0a3e4e5a62dfce"],
	[J3_SMOKE, "5c45961b", "1789de068e06789162016d0722408a9a0b3b076d1f964fd580d71501711a8a9c", "0536dabb9945ab805e2a9330ebb96d26dbd8958ef77e7f1ec44a2475a1e09f27"],
]
var MOVED_SUITES: Array = _stored(MOVED_SUITE_ROWS)

## First-MVP UI J5 (D-330) moved the slice and the four suite files above again, one for one. Each is
## first put back to where J4 left it and then read exactly as before: `J5_PREFIXES` holds each file's J5
## prefix, and `J5_MOVES` its pairs of [as J5 wrote it, as J4 left it], applied to that file alone.
const J5_PREFIXES: Dictionary = {
	SLICE_SCRIPT: "f83e9436", J1_VERIFICATION: "8c0e290c", J2_VERIFICATION: "ca594f7d", J3_VERIFICATION: "b2cfc253", J3_SMOKE: "6e4120a3",
}
const J5_MOVE_IDS: Dictionary = {
	SLICE_SCRIPT: "918257a747a48675614c57e494946cbdd6feadbccdad165f662e0e4e4eea2833",
	J1_VERIFICATION: "dcea2ecadfaf8db30ef7aa47f23bf1325d0d221bec227f73b90ba23fbabf10af",
	J2_VERIFICATION: "7c500ad9962e46cb63f786ff17959b5969778e6d19012a8aaff910039a2ae0a2",
	J3_VERIFICATION: "81703bcc9a60c18ae723589abf5b6b0f1a696bd11a8c97e2bfe742998fdcb01c",
	J3_SMOKE: "32358e8c607db638a7c579bfc26409d692192636d657d0e0e61cc76ede0b944b",
}
var J5_MOVES: Dictionary = _stored(J5_MOVE_IDS)

## First-MVP UI J6 (D-332) moved J2's and J3's verifications and J3's runner again, one for one, when the
## combat HUD moved. Each is first put back to where J5 left it and then read exactly as before:
## `J6_PREFIXES` holds each file's J6 prefix, and `J6_MOVES` its pairs of [as J6 wrote it, as J5 left
## it], applied to that file alone.
const J6_PREFIXES: Dictionary = {
	J2_VERIFICATION: "f065a48d", J3_VERIFICATION: "68a1227e", J3_SMOKE: "f7b48202",
}
const J6_MOVE_IDS: Dictionary = {
	J2_VERIFICATION: "c50dea62f9b616092198b2e91c26bca6a89d98bafdcb0a05f188a99a2aa8799e",
	J3_VERIFICATION: "0cc650ce57c2472c01b53f90a47eedba9c7acec9574185d76b1877fdbcf80356",
	J3_SMOKE: "2016a5c2988311560e3403a1363641fa22a730bf2e3230e4526d953c278bc4da",
}
var J6_MOVES: Dictionary = _stored(J6_MOVE_IDS)

## First-MVP UI J7 (D-334) moved J2's and J3's verifications and J3's runner again, one for one, when the
## combat HUD moved. Each is first put back to where J6 left it and then read exactly as before:
## `J7_PREFIXES` holds each file's J7 prefix, and `J7_MOVES` its pairs of [as J7 wrote it, as J6 left
## it], applied to that file alone.
const J7_PREFIXES: Dictionary = {
	J2_VERIFICATION: "eb7f4153", J3_VERIFICATION: "520d9543", J3_SMOKE: "67cf7ba9",
}
const J7_MOVE_IDS: Dictionary = {
	J2_VERIFICATION: "3e7c3a327c2fcb3b5ae9daf1a554e1101538d0308bd5394087552c3136fb4d0b",
	J3_VERIFICATION: "1c516c4733d0b37638eac8a9e7544bf35b85b9fd7ffa1eb649c6674aa51c612d",
	J3_SMOKE: "e9b16d35e517a196779b81c5e027cf5fe5b93969503000e1e3ba6f33a0d2c242",
}
var J7_MOVES: Dictionary = _stored(J7_MOVE_IDS)

## First-MVP UI J8 (D-336) moved J2's and J3's verifications and J3's runner again, one for one, when the
## combat HUD moved. Each is first put back to where J7 left it and then read exactly as before:
## `J8_PREFIXES` holds each file's J8 prefix, and `J8_MOVES` its pairs of [as J8 wrote it, as J7 left
## it], applied to that file alone.
const J8_PREFIXES: Dictionary = {
	J2_VERIFICATION: "d5407c7c", J3_VERIFICATION: "1062c1db", J3_SMOKE: "689284cc",
}
const J8_MOVE_IDS: Dictionary = {
	J2_VERIFICATION: "3cfd6d4749e5e801664da0874fa7f571855f0c1c4d08a671cab93b6317b27503",
	J3_VERIFICATION: "da1e53b3a7be5c836b449eca6af9d6e422484f5f6b87c7dbde858f1b24e91e70",
	J3_SMOKE: "3ac248809645192bb948960935d03919041698fc4db7f88ca5f870e21a321cc6",
}
var J8_MOVES: Dictionary = _stored(J8_MOVE_IDS)

## First-MVP Gameplay J9 (D-338) moved the slice and the four suite files above again, one for one, when the
## slice's connection came to bind the first Graveblade. Each is first put back to where D-337 left it and
## then read exactly as before: `J9_PREFIXES` holds each file's J9 prefix, and `J9_MOVES` its pairs of [as
## J9 wrote it, as D-337 left it], applied to that file alone.
const J9_PREFIXES: Dictionary = {
	SLICE_SCRIPT: "942aee83", J1_VERIFICATION: "acbd3892", J2_VERIFICATION: "6acc1e0c", J3_VERIFICATION: "dc9be60f", J3_SMOKE: "ec5bc37f",
}
const J9_MOVE_IDS: Dictionary = {
	SLICE_SCRIPT: "d678256ed00a877dddccb3783fc44d1367824b3b8c97beb41f6ac4155930997f",
	J1_VERIFICATION: "fb8d9401ba6c004b0d1e1997f866d76602e5b423be361ff06b383bafc3cc1749",
	J2_VERIFICATION: "fb8d9401ba6c004b0d1e1997f866d76602e5b423be361ff06b383bafc3cc1749",
	J3_VERIFICATION: "1a4d7f01639d1180ba3e70a49c8ce4e9c0a1843a82055d515465b366aecc64d8",
	J3_SMOKE: "d4f4a6ada9acac4c6a846830bc9283e4d5c4537f03d7a61b32b185a18dad22fb",
}
var J9_MOVES: Dictionary = _stored(J9_MOVE_IDS)

## First-MVP Gameplay J10 (D-340) moved the slice and the four suite files above again, one for one, when Gate 1D's
## slice's restart came to end the movement command it carried. Each is first put back to where D-339 left it
## and then read exactly as before: `J10_PREFIXES` holds each file's J10 prefix, and `J10_MOVES` its pairs of
## [as J10 wrote it, as D-339 left it], applied to that file alone.
const J10_PREFIXES: Dictionary = {
	SLICE_SCRIPT: "883ef25e", J1_VERIFICATION: "75f26486", J2_VERIFICATION: "935a37e9", J3_VERIFICATION: "53c37976", J3_SMOKE: "9a860bca",
}
const J10_MOVE_IDS: Dictionary = {
	SLICE_SCRIPT: "0f3be56df737115f62f10f15bcee4d1ead68b785b0465eb9c6d7fd804540a413",
	J1_VERIFICATION: "26ba84a3fd1582fd17708ff4b49d5522cfbf6142a558114d9c519a6f24ab0250",
	J2_VERIFICATION: "26ba84a3fd1582fd17708ff4b49d5522cfbf6142a558114d9c519a6f24ab0250",
	J3_VERIFICATION: "d9ffd11477b4bfd3b1c1f297ab77ad7b4ce71a117d1acbd1872907bc18d0fe7a",
	J3_SMOKE: "58b1cc938d16d1b2bef63f0552efc11c7596ea019e4bb55e98972b4f9494757d",
}
var J10_MOVES: Dictionary = _stored(J10_MOVE_IDS)

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
}
const J11_MOVE_IDS: Dictionary = {
	"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd": "f0f7cf747a8cc738a5e9477ea2028e6d863d9d83d3cc6799d39032a0275db868",
	"res://tests/first_mvp_modal_left_click_verification.gd": "e7b62a6207638ff89cd8732cc9bbcfd57503f83f8877662c7a4806a709fdc3c8",
	"res://tests/fallen_modal_life_state_verification.gd": "e7b62a6207638ff89cd8732cc9bbcfd57503f83f8877662c7a4806a709fdc3c8",
	"res://tests/pending_fallen_restart_verification.gd": "eab887b6ceea266bb06554728df7227e3c47fb0338990a0f9e3209f733f9b6c2",
	"res://tests/pending_fallen_restart_smoke.sh": "a7a5214f7f0fd6e1f4d32fc539df430b11312aee42ad845ee135cbdba73cecd2",
}
var J11_MOVES: Dictionary = _stored(J11_MOVE_IDS)

## Everything J4 stands beside, at the SHA-256 prefix each held before the first J4 edit.
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
const CLOSE_REASON: String = "closed — the item is still on the ground"

## Distances from the drop, along the route: inside and outside its 2.20 m interaction range.
const NEAR_DROP: float = 1.0
const LIVING_NEAR: float = 1.5
const FAR_DROP: float = 4.0
const NEAR: float = 1.2
## Where each attempt lands inside the 0.90 s delay: the first frame with no more than this much left.
const PLAN_A: Array = [
	{"at": 0.78, "kind": "click"}, {"at": 0.66, "kind": "click"}, {"at": 0.54, "kind": "interact"},
	{"at": 0.42, "kind": "direct"}, {"at": 0.30, "kind": "click"},
]
const PLAN_B: Array = [{"at": 0.60, "kind": "interact"}]
const F5_AT: float = 0.45
const WINDOW_SECONDS: float = BrokenWatchSlice.FALLEN_DELAY + FirstMvpFallenOverlay.FADE_SECONDS + 0.4

## A harness node that counts process updates. One runs before every other node, one after.
const PROBE_SOURCE: String = "extends Node\nvar ticks: int = 0\nvar on_tick: Callable\n\nfunc _process(_delta: float) -> void:\n\tticks += 1\n\tif on_tick.is_valid():\n\t\ton_tick.call(ticks)\n"

const OWED_CHECKS: Array[String] = [
	"the_production_scope_is_exactly_the_slice",
	"the_accepted_suites_moved_only_their_slice_pins",
	"only_the_three_functions_changed_each_by_one_life_guard",
	"the_slice_declares_nothing_new",
	"the_reach_is_gate_1d_and_its_descendants_by_inheritance",
	"no_scene_input_map_or_presentation_changed",
	"a_production_graveblade_death_creates_the_guaranteed_drop",
	"production_graveblade_attacks_kill_the_player_and_arm_the_delay",
	"a_lethal_frame_nameplate_press_opens_nothing",
	"the_first_process_update_hides_the_nameplate_and_prompt",
	"repeated_nameplate_presses_in_the_delay_change_nothing",
	"controller_interact_in_the_delay_opens_nothing_and_says_nothing",
	"the_direct_opener_refuses_a_fallen_player",
	"the_delay_runs_on_and_opens_fallen_once_on_the_original_hit",
	"behind_the_fallen_overlay_item_interaction_is_still_refused",
	"a_living_player_sees_the_nameplate_and_opens_and_closes_it_by_left_click",
	"a_living_out_of_range_controller_interact_still_says_walk_closer",
	"a_living_player_opens_it_by_controller_and_equips_once",
	"f5_in_a_later_delay_still_cancels_before_the_revival",
	"the_guaranteed_drop_latch_still_permits_one_drop",
]

var arguments: PackedStringArray = PackedStringArray()
var slice: BrokenWatchSlice

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _staged: PackedStringArray = PackedStringArray()
var _next_use_id: int = 328000

var _pre: Node = null
var _post: Node = null
## Where the post-slice probe appends its readings while a death is being watched.
var _tick_sink: Array = []
var _sinking: bool = false

var _drop_position: Vector3 = Vector3.INF
var _drops_created: int = 0
var _earned: Dictionary = {}
var _deaths: Dictionary = {}
var _living: Dictionary = {}
var _latch: Dictionary = {}
var _opened_pending: Array = []
## How often the harness had to close a comparison that should never have opened.
var _cleanups: int = 0

var _fired: Dictionary = {}
var _watched: Array[Dictionary] = []


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	print("")
	print("=== First-MVP UI J4 — Fallen-Delay Item-Interaction Gating V1 verification (D-328) ===")

	_check_the_production_scope_is_exactly_the_slice()
	_check_the_accepted_suites_moved_only_their_slice_pins()
	_check_only_the_three_functions_changed_each_by_one_life_guard()
	_check_the_slice_declares_nothing_new()
	_check_the_reach_is_gate_1d_and_its_descendants_by_inheritance()
	_check_no_scene_input_map_or_presentation_changed()

	await _play()
	if slice != null:
		_check_a_production_graveblade_death_creates_the_guaranteed_drop()
		_check_production_graveblade_attacks_kill_the_player_and_arm_the_delay()
		_check_a_lethal_frame_nameplate_press_opens_nothing()
		_check_the_first_process_update_hides_the_nameplate_and_prompt()
		_check_repeated_nameplate_presses_in_the_delay_change_nothing()
		_check_controller_interact_in_the_delay_opens_nothing_and_says_nothing()
		_check_the_direct_opener_refuses_a_fallen_player()
		_check_the_delay_runs_on_and_opens_fallen_once_on_the_original_hit()
		_check_behind_the_fallen_overlay_item_interaction_is_still_refused()
		_check_a_living_player_sees_the_nameplate_and_opens_and_closes_it_by_left_click()
		_check_a_living_out_of_range_controller_interact_still_says_walk_closer()
		_check_a_living_player_opens_it_by_controller_and_equips_once()
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
	if _failures.is_empty():
		print("FALLEN DELAY ITEM INTERACTION VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("FALLEN DELAY ITEM INTERACTION VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		quit(1)


# --- 1–6. Structure: the one file, its three functions, its reach ------------------------------

func _check_the_production_scope_is_exactly_the_slice() -> void:
	print("")
	print("--- 1. Exactly one production file moved — Gate 1D's slice — and it is J3's file plus three comments and three guards")
	var source: String = _before_j5(SLICE_SCRIPT, _before_j9(SLICE_SCRIPT, _before_j10(SLICE_SCRIPT, _before_j11(SLICE_SCRIPT, FileAccess.get_file_as_string(SLICE_SCRIPT)))))
	var digest: String = source.sha256_text()
	var rebuilt: Dictionary = _put_back(source, J4_SLICE_MOVES)
	_expect(FileAccess.get_sha256(SLICE_SCRIPT).begins_with(String(J11_PREFIXES[SLICE_SCRIPT]))
			and _before_j11(SLICE_SCRIPT, FileAccess.get_file_as_string(SLICE_SCRIPT)).sha256_text().begins_with(String(J10_PREFIXES[SLICE_SCRIPT]))
			and _before_j10(SLICE_SCRIPT, _before_j11(SLICE_SCRIPT, FileAccess.get_file_as_string(SLICE_SCRIPT))).sha256_text().begins_with(String(J9_PREFIXES[SLICE_SCRIPT]))
			and _before_j9(SLICE_SCRIPT, _before_j10(SLICE_SCRIPT, _before_j11(SLICE_SCRIPT, FileAccess.get_file_as_string(SLICE_SCRIPT)))).sha256_text().begins_with(String(J5_PREFIXES[SLICE_SCRIPT]))
			and digest.begins_with(J4_PREFIX) and bool(rebuilt["unique"]) and String(rebuilt["text"]).sha256_text() == J3_SLICE_SHA256,
		"the slice hashes %s; each insertion occurs once: %s; the reconstruction hashes %s"
			% [digest.left(8), str(rebuilt["unique"]), String(rebuilt["text"]).sha256_text().left(8)])
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in UNCHANGED_HASHES:
		var held: String = FileAccess.get_sha256(String(row[0]))
		if not held.begins_with(String(row[1])):
			moved.append("%s %s" % [String(row[0]).get_file(), held.left(8)])
	_expect(moved.is_empty() and UNCHANGED_HASHES.size() == 48, "moved: %s" % ", ".join(moved))
	print("  the slice is at its J5 hash %s; with J5's one line removed, at its J4 hash %s; with J4's 3 comments (%d lines) and its 3 guards (8 lines) removed it is, byte for byte, J3's file %s — once J9's two changes (D-338) are put back, and J10's clearing line (D-340) before them"
		% [String(J5_PREFIXES[SLICE_SCRIPT]), J4_PREFIX, OPEN_COMMENT.count("\n") + INTERACT_COMMENT.count("\n") + NAMEPLATE_COMMENT.count("\n"), J3_SLICE_SHA256.left(8)])
	print("  %d files J4 stands beside hold the hashes they held before the first J4 edit: the player, the modal contract, both Fallen overlays, the comparison, the HUD, the drop, the loadout, all 7 descendants of the slice, Prototype Zero's room, the combat, movement and camera kernels, five scenes, three records, project.godot and nine accepted suites; the HUD since moved by J6 (D-332); Broken Watch's layout since moved by J10 (D-340)"
		% UNCHANGED_HASHES.size())
	_done("the_production_scope_is_exactly_the_slice")


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


## Puts a file J5 moved back to where J4 left it (First-MVP UI J5, D-330).
func _before_j5(path: String, text: String) -> String:
	for pair: Array in J5_MOVES.get(path, []):
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


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


func _check_the_accepted_suites_moved_only_their_slice_pins() -> void:
	print("")
	print("--- 2. The four accepted suites that pinned the slice moved only their pins, one for one, at unchanged counts")
	var faults: PackedStringArray = PackedStringArray()
	var lines: int = 0
	for row: Array in MOVED_SUITES:
		var path: String = row[0]
		var j9_text: String = _before_j10(path, _before_j11(path, FileAccess.get_file_as_string(path)))
		var j8_text: String = _before_j9(path, j9_text)
		var j7_text: String = _before_j8(path, j8_text)
		var j6_text: String = _before_j7(path, j7_text)
		var j5_text: String = _before_j6(path, j6_text)
		var j4_text: String = _before_j5(path, j5_text)
		var rebuilt: Dictionary = _put_back(j4_text, row[3])
		lines += (row[3] as Array).size()
		if not (FileAccess.get_sha256(path).begins_with(String(J11_PREFIXES.get(path, J10_PREFIXES.get(path, J9_PREFIXES.get(path, J8_PREFIXES.get(path, J7_PREFIXES.get(path, J6_PREFIXES.get(path, J5_PREFIXES[path]))))))))
				and j9_text.sha256_text().begins_with(String(J9_PREFIXES.get(path, J8_PREFIXES.get(path, J7_PREFIXES.get(path, J6_PREFIXES.get(path, J5_PREFIXES[path]))))))
				and j8_text.sha256_text().begins_with(String(J8_PREFIXES.get(path, J7_PREFIXES.get(path, J6_PREFIXES.get(path, J5_PREFIXES[path])))))
				and j7_text.sha256_text().begins_with(String(J7_PREFIXES.get(path, J6_PREFIXES.get(path, J5_PREFIXES[path]))))
				and j6_text.sha256_text().begins_with(String(J6_PREFIXES.get(path, J5_PREFIXES[path])))
				and j5_text.sha256_text().begins_with(String(J5_PREFIXES[path])) and j4_text.sha256_text().begins_with(String(row[1]))
				and bool(rebuilt["unique"]) and not (row[3] as Array).is_empty()
				and String(rebuilt["text"]).sha256_text() == String(row[2])):
			faults.append("%s at %s rebuilds to %s" % [path.get_file(), FileAccess.get_sha256(path).left(8), String(rebuilt["text"]).sha256_text().left(8)])
	_expect(faults.is_empty() and MOVED_SUITES.size() == 4, "; ".join(faults))
	print("  J1's and J2's verifications moved their slice row and the clause naming who moved it; J3's verification and runner moved their slice, J1 and J2 pins and the lines printing them: put back, the four are byte for byte %s, %s, %s and %s (%d replaced blocks)"
		% [String(MOVED_SUITES[0][2]).left(8), String(MOVED_SUITES[1][2]).left(8), String(MOVED_SUITES[2][2]).left(8), String(MOVED_SUITES[3][2]).left(8), lines])
	_done("the_accepted_suites_moved_only_their_slice_pins")


func _check_only_the_three_functions_changed_each_by_one_life_guard() -> void:
	print("")
	print("--- 3. Only the three authorized functions changed, each by one guard asking player.is_alive() and nothing else")
	var source: String = _before_j5(SLICE_SCRIPT, _before_j11(SLICE_SCRIPT, FileAccess.get_file_as_string(SLICE_SCRIPT)))
	var open: PackedStringArray = _code_lines(_function_body(source, "open_item_comparison"))
	var interact: PackedStringArray = _code_lines(_function_body(source, "_try_interact_with_drop"))
	var nameplate: PackedStringArray = _code_lines(_function_body(source, "_update_drop_nameplate"))
	var code: String = _bare(source)
	var guard_owners: PackedStringArray = PackedStringArray()
	for name: String in _declared_functions(source):
		var body: String = _function_body(code, name)
		for index: int in body.count("player.is_alive()"):
			guard_owners.append(name)
	var inferences: PackedStringArray = PackedStringArray()
	for name: String in ["open_item_comparison", "_try_interact_with_drop", "_update_drop_nameplate"]:
		var body: String = _function_body(code, name)
		for word: String in INFERENCE_WORDS:
			if body.contains(word):
				inferences.append("%s reads %s" % [name, word])
	var signatures_ok: bool = true
	for signature: String in SIGNATURES:
		signatures_ok = signatures_ok and source.count(signature) == 1
	_expect(open == PackedStringArray(OPEN_LINES) and interact == PackedStringArray(INTERACT_LINES)
			and nameplate.slice(0, NAMEPLATE_HEAD.size()) == PackedStringArray(NAMEPLATE_HEAD)
			and guard_owners == PackedStringArray(["open_item_comparison", "_try_interact_with_drop", "_update_drop_nameplate"])
			and inferences.is_empty() and signatures_ok
			and source.contains(OPEN_COMMENT + SIGNATURES[0]) and source.contains(INTERACT_COMMENT + SIGNATURES[1])
			and source.contains(NAMEPLATE_COMMENT + SIGNATURES[2]),
		"open %s; interact %s; nameplate %s; is_alive() in %s; inferences %s"
			% [str(open), str(interact), str(nameplate.slice(0, NAMEPLATE_HEAD.size())), str(guard_owners), str(inferences)])
	print("  open_item_comparison(): the third refusal, after the missing drop and the open modal, before the log line and open_for() — %d code lines" % open.size())
	print("  _try_interact_with_drop(): the third refusal, after the same two, before the range check and \"Walk closer\" — %d code lines" % interact.size())
	print("  _update_drop_nameplate(): the second branch, after the missing drop or nameplate, before the camera read, placement, prompt and soft-selection writes — it hides the nameplate and clears the prompt")
	print("  player.is_alive() occurs %d times in the slice's code, once in each of the three; none reads Life, the countdown, the pending event, the action state or the neutral latch; the three signatures are unchanged"
		% guard_owners.size())
	_done("only_the_three_functions_changed_each_by_one_life_guard")


func _check_the_slice_declares_nothing_new() -> void:
	print("")
	print("--- 4. No field, export, function, constant, signal, enum or accessor was added to the slice")
	var source: String = _before_j11(SLICE_SCRIPT, FileAccess.get_file_as_string(SLICE_SCRIPT))
	var fields: int = RegEx.create_from_string("(?m)^var ").search_all(source).size()
	var exports: int = RegEx.create_from_string("(?m)^@export var ").search_all(source).size()
	var constants: int = RegEx.create_from_string("(?m)^const ").search_all(source).size()
	var signals: int = RegEx.create_from_string("(?m)^signal ").search_all(source).size()
	var enums: int = RegEx.create_from_string("(?m)^enum ").search_all(source).size()
	var functions: PackedStringArray = _declared_functions(source)
	var before: PackedStringArray = _declared_functions(String(_put_back(source, J4_SLICE_MOVES)["text"]))
	_expect(fields == SLICE_FIELDS and exports == SLICE_EXPORTS and functions.size() == SLICE_FUNCTIONS
			and constants == SLICE_CONSTANTS and signals == 0 and enums == 0 and functions == before,
		"%d fields, %d exports, %d functions, %d constants, %d signals, %d enums" % [fields, exports, functions.size(), constants, signals, enums])
	print("  %d fields, %d exports, %d functions in J3's order, %d constants, no signal and no enum — the counts J3 left"
		% [fields, exports, functions.size(), constants])
	_done("the_slice_declares_nothing_new")


func _check_the_reach_is_gate_1d_and_its_descendants_by_inheritance() -> void:
	print("")
	print("--- 5. What the three guards reach (structural): Gate 1D, and every descendant of the slice by inheritance")
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
	var declarers: Dictionary = {"open_item_comparison": [], "_try_interact_with_drop": [], "_update_drop_nameplate": []}
	for path: String in sources.keys():
		for name: String in declarers.keys():
			if String(sources[path]).contains("func %s(" % name):
				(declarers[name] as Array).append(String(path).get_file())
	for name: String in declarers.keys():
		(declarers[name] as Array).sort()
	var no_super: PackedStringArray = PackedStringArray()
	for path: String in descendants:
		for name: String in ["_process", "_unhandled_input"]:
			var body: String = _function_body(String(sources[path]), name)
			if String(sources[path]).contains("func %s(" % name) and not body.contains("super"):
				no_super.append("%s.%s" % [path.get_file(), name])
	var opening: PackedStringArray = _code_lines(_function_body(String(sources.get(OPENING_SCRIPT, "")), "open_item_comparison"))
	var names: PackedStringArray = PackedStringArray()
	for path: String in descendants:
		names.append(path.get_file())
	_expect(scanned > 100 and descendants.size() == 7
			and declarers["open_item_comparison"] == ["broken_watch_slice.gd", "canonical_opening_runtime.gd", "prototype_zero.gd"]
			and declarers["_try_interact_with_drop"] == ["broken_watch_slice.gd", "prototype_zero.gd"]
			and declarers["_update_drop_nameplate"] == ["broken_watch_slice.gd"]
			and opening == PackedStringArray(["if _any_modal_open():", "return", "_hide_world_nameplates()", "super.open_item_comparison(reason)"])
			and no_super.is_empty() and not String(sources.get(PROTOTYPE_ROOM_SCRIPT, "")).contains("extends BrokenWatchSlice"),
		"descendants %s; declarers %s; Gate 1E's opener %s; overrides without super %s" % [str(names), str(declarers), str(opening), str(no_super)])
	print("  of %d running scripts, %d descend from BrokenWatchSlice: %s" % [scanned, descendants.size(), ", ".join(names)])
	print("  none overrides _try_interact_with_drop() or _update_drop_nameplate(); every _process and _unhandled_input override among them calls super")
	print("  Gate 1E alone overrides open_item_comparison(): its own modal test, then _hide_world_nameplates(), then super — so the guard still decides; prototype_zero.gd declares its own opener and interact and does not extend the slice")
	_done("the_reach_is_gate_1d_and_its_descendants_by_inheritance")


func _check_no_scene_input_map_or_presentation_changed() -> void:
	print("")
	print("--- 6. The InputMap, the entrypoint and project.godot are untouched; scenes, overlays, comparison and HUD hold their pre-J4 hashes (check 1)")
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	_expect(actions == EXPECTED_ACTIONS and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT
			and not settings.contains("[autoload]") and not settings.contains("fallen_delay"),
		"%d actions, or project.godot moved" % actions)
	print("  %d actions; the entrypoint is %s; project.godot declares no [autoload] and names nothing of J4" % [actions, ENTRYPOINT.get_file()])
	_done("no_scene_input_map_or_presentation_changed")


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

	await _earn_the_drop()
	if slice._active_drop == null:
		_failures.append("no guaranteed drop was created, so nothing after it can be measured")
		return
	_drop_position = slice._active_drop.global_position

	var a: Dictionary = await _strike_player("A", _drop_position + _forward() * NEAR_DROP, true)
	await _through_the_delay(a, PLAN_A)
	await _behind_the_overlay(a)
	await _restart_by_confirm(a)
	_deaths["A"] = a

	var b: Dictionary = await _strike_player("B", _drop_position + _forward() * FAR_DROP, false)
	await _through_the_delay(b, PLAN_B)
	await _restart_by_confirm(b)
	_deaths["B"] = b

	await _living_phase()

	var c: Dictionary = await _strike_player("C", slice.landing_layout.player_start(), false)
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
	_pre.name = "J4ProbeBeforeTheSlice"
	_pre.set_script(script)
	_pre.process_priority = -1000000
	_pre.process_mode = Node.PROCESS_MODE_ALWAYS
	_post = Node.new()
	_post.name = "J4ProbeAfterTheSlice"
	_post.set_script(script)
	_post.process_priority = 1000000
	_post.process_mode = Node.PROCESS_MODE_ALWAYS
	_post.set("on_tick", _on_post_tick)
	root.add_child(_pre)
	root.add_child(_post)


## What the slice left, read after every other node has processed.
func _on_post_tick(tick: int) -> void:
	if not _sinking or slice == null:
		return
	_tick_sink.append({
		"tick": tick, "nameplate": slice._nameplate.visible, "prompt": _prompt(), "panel": slice.hud._prompt_panel.visible,
		"paused": paused, "countdown": slice._fallen_countdown, "alive": slice.player.is_alive(),
		"comparison": slice.item_comparison.is_open, "overlay": slice.fallen_overlay.is_open,
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


## STAGED start, real Hits: the player is placed at `stand` facing the route and the second Graveblade
## 1.2 m in front of it; each attack is begun through the Graveblade's own verification seam. `fell` is
## heard twice: at once, to count the process updates at the lethal Hit, and DEFERRED — after the lethal
## call stack has returned and before the slice processes again — to read, and for death A to press.
func _strike_player(label: String, stand: Vector3, press: bool) -> Dictionary:
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
		"label": label, "counts": counts, "emissions": emissions, "trail": [], "began": 0, "press": press,
		"life_before": player.life, "killer": killer, "ticks": [],
		"record_damage": float((load(GRAVEBLADE_RECORD) as Resource).get("physical_damage")),
		"living": {
			"nameplate": slice._nameplate.visible, "prompt": _prompt(), "alive": player.is_alive(),
			"gap": _planar_gap(player.global_position, _drop_position) if _drop_position != Vector3.INF else -1.0,
			"in_range": slice._active_drop != null and slice._active_drop.player_is_in_range(player.global_position),
		},
		"restarts_at_start": _log_count("slice restarted"),
	}
	var on_life: Callable = func(current: float, maximum: float) -> void:
		emissions.append({"life": current, "max": maximum, "state": player.action_state_name(),
			"countdown": slice._fallen_countdown, "pending_null": slice._pending_fallen_event == null})
	var on_damage: Callable = func(_event: DamageEvent) -> void: counts["took_damage"] = int(counts["took_damage"]) + 1
	var on_fell: Callable = func(event: DamageEvent) -> void:
		counts["fell"] = int(counts["fell"]) + 1
		record["at_kill"] = {"pre": _pre_ticks(), "physics": Engine.is_in_physics_frame(),
			"countdown": slice._fallen_countdown, "pending": slice._pending_fallen_event == event}
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


## The lethal frame: the deferred call on `fell`, before the slice has processed again. For death A, one
## left press and release on the still-visible nameplate, pushed straight into the root viewport.
func _on_lethal_frame(record: Dictionary, event: DamageEvent) -> void:
	var player: PrototypePlayer = slice.player
	var at_kill: Dictionary = record.get("at_kill", {})
	var reading: Dictionary = {
		"same_step": _pre_ticks() == int(at_kill.get("pre", -1)),
		"state": player.action_state_name(), "alive": player.is_alive(), "life": player.life,
		"nameplate": slice._nameplate.visible, "prompt": _prompt(), "paused": paused,
		"countdown": slice._fallen_countdown, "pending": slice._pending_fallen_event == event,
		"overlay": slice.fallen_overlay.is_open, "before": _item_state(),
	}
	if bool(record["press"]):
		var rect: Rect2 = slice._nameplate.get_global_rect()
		var centre: Vector2 = rect.get_center()
		var hits: Array = [0, 0]
		var on_down: Callable = func() -> void: hits[0] = int(hits[0]) + 1
		var on_pressed: Callable = func() -> void: hits[1] = int(hits[1]) + 1
		slice._nameplate.button_down.connect(on_down)
		slice._nameplate.pressed.connect(on_pressed)
		root.push_input(_button_event(centre, MOUSE_BUTTON_LEFT, true))
		root.push_input(_button_event(centre, MOUSE_BUTTON_LEFT, false))
		slice._nameplate.button_down.disconnect(on_down)
		slice._nameplate.pressed.disconnect(on_pressed)
		reading["centre"] = centre
		reading["down"] = hits[0]
		reading["pressed"] = hits[1]
		reading["inside"] = rect.has_point(centre) and rect.size.x > 0.0
	reading["after"] = _item_state()
	reading["comparison"] = slice.item_comparison.is_open
	reading["paused_after"] = paused
	reading["countdown_after"] = slice._fallen_countdown
	reading["pending_after"] = slice._pending_fallen_event == event
	reading["same_step_after"] = _pre_ticks() == int(at_kill.get("pre", -1))
	record["lethal"] = reading


## Samples every process frame of the delay until the overlay opens by itself, making each planned
## attempt at the first frame with no more than its time left. A comparison that opened anyway is closed
## so the run can go on, and counted.
func _through_the_delay(record: Dictionary, plan: Array) -> void:
	var player: PrototypePlayer = slice.player
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var event: DamageEvent = record["event"]
	var opens: int = overlay.opens
	var opened_mark: int = _opened_pending.size()
	var samples: Array = []
	var attempts: Array = []
	var next: int = 0
	for frame: int in 900:
		if overlay.is_open:
			break
		samples.append({"remaining": slice._fallen_countdown, "paused": paused, "alive": player.is_alive(), "life": player.life,
			"pending": slice._pending_fallen_event == event, "comparison": slice.item_comparison.is_open})
		if slice.item_comparison.is_open:
			slice.item_comparison.close("verification cleanup")
			_cleanups += 1
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


## One attempt at the item from inside the delay: a left click where the nameplate stood (J1's route), the
## controller's interact, or — once — the opener itself.
func _attempt(record: Dictionary, kind: String) -> Dictionary:
	var player: PrototypePlayer = slice.player
	var event: DamageEvent = record["event"]
	var before: Dictionary = _item_state()
	var message: Dictionary = _hud_message()
	var remaining: float = slice._fallen_countdown
	var logs: int = slice.log_lines.size()
	var result: Dictionary = {"kind": kind, "remaining": remaining}
	match kind:
		"click":
			var centre: Vector2 = (record.get("lethal", {}) as Dictionary).get("centre", slice._nameplate.get_global_rect().get_center())
			result["press"] = await _parse_press_at(centre, null)
		"interact":
			result["in_range"] = slice._active_drop != null and slice._active_drop.player_is_in_range(player.global_position)
			_push_joy(JOY_BUTTON_A, true)
			result["synchronous"] = _synchronous(remaining, message)
			_push_joy(JOY_BUTTON_A, false)
		"direct":
			slice.open_item_comparison("verification")
			result["synchronous"] = _synchronous(remaining, message)
			_note("the opener called directly once, inside death A's delay, for the direct-entry refusal")
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
	result["new_logs"] = slice.log_lines.slice(logs)
	return result


## Read in the same call as the attempt, before any frame can pass.
func _synchronous(remaining: float, message: Dictionary) -> Dictionary:
	return {
		"comparison": slice.item_comparison.is_open, "paused": paused, "countdown_same": slice._fallen_countdown == remaining,
		"message_same": _hud_message() == message, "message": _hud_message(), "opened_logs": _log_count("item comparison opened"),
	}


## Behind the standing overlay: 10 paused physics and 5 idle frames read, then one left click where the
## nameplate stood, through J1's route.
func _behind_the_overlay(record: Dictionary) -> void:
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var before: Dictionary = _item_state()
	var restarts: int = _log_count("slice restarted")
	var faults: PackedStringArray = PackedStringArray()
	for frame: int in 10:
		await physics_frame
		if not _behind_ok():
			faults.append("physics frame %d" % frame)
	for frame: int in 5:
		await process_frame
		if not _behind_ok():
			faults.append("idle frame %d" % frame)
	var centre: Vector2 = (record.get("lethal", {}) as Dictionary).get("centre", Vector2.ZERO)
	var restart_button: Button = _named(overlay, RESTART_CAPTION)
	var press: Dictionary = await _parse_press_at(centre, overlay)
	record["behind"] = {
		"faults": faults, "press": press, "comparison": slice.item_comparison.is_open, "overlay": overlay.is_open, "paused": paused,
		"restarts_same": _log_count("slice restarted") == restarts, "same": _same_items(before, _item_state()),
		"nameplate": slice._nameplate.visible, "prompt": _prompt(), "alive": slice.player.is_alive(),
		"on_restart": restart_button != null and restart_button.get_global_rect().has_point(centre),
	}


func _behind_ok() -> bool:
	return (slice.fallen_overlay.is_open and paused and not slice.item_comparison.is_open and not slice._nameplate.visible
		and _prompt().is_empty() and not slice.player.is_alive())


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

## STAGED positions, real input: the living character is placed at measured distances from the drop; the
## nameplate is clicked and the comparison closed through J1's route, and the controller's interact,
## focus move and confirm are joypad events pushed into the root viewport.
func _living_phase() -> void:
	var player: PrototypePlayer = slice.player
	var comparison: FirstMvpItemComparison = slice.item_comparison
	var forward: Vector3 = _forward()
	var reasons: Array = []
	var on_closed: Callable = func(reason: String) -> void: reasons.append(reason)
	comparison.closed.connect(on_closed)

	await _until_neutral()
	_quiet()
	_stand_facing(_drop_position + forward * LIVING_NEAR, forward)
	await _settle(2)
	await _await_process_frames(3)
	await _point_with_the_mouse(slice._nameplate.get_global_rect().get_center())
	var drop_name: String = slice._active_drop.display_name() if slice._active_drop != null else ""
	var seen: Dictionary = {
		"alive": player.is_alive(), "nameplate": slice._nameplate.visible, "text": slice._nameplate.text, "prompt": _prompt(),
		"panel": slice.hud._prompt_panel.visible, "name": drop_name, "gap": _planar_gap(player.global_position, _drop_position),
		"mouse": slice.input_family.family == InputFamilyTracker.Family.MOUSE_KEYBOARD,
	}
	var before: Dictionary = _item_state()
	var opens: int = comparison.opens
	var click: Dictionary = await _parse_press_at(slice._nameplate.get_global_rect().get_center(), null)
	var by_click: Dictionary = {
		"click": click, "open": comparison.is_open, "opens": comparison.opens - opens, "paused": paused,
		"log": _last_log("item comparison opened").ends_with("nameplate clicked"),
		"focus": root.gui_get_focus_owner() == comparison.default_focus() and comparison.default_focus() != null,
	}
	var close: Dictionary = await _parse_click(comparison, _named(comparison, "Close"))
	by_click["close"] = close
	by_click["closed"] = not comparison.is_open and reasons == [CLOSE_REASON] and not paused
	by_click["kept"] = _same_ownership(before, _item_state()) and slice._active_drop != null
	_living["seen"] = seen
	_living["by_click"] = by_click

	await _until_neutral()
	_stand_facing(_drop_position + forward * FAR_DROP, forward)
	await _settle(2)
	await _await_process_frames(3)
	var far: Dictionary = _item_state()
	var walk: Dictionary = {"gap": _planar_gap(player.global_position, _drop_position), "opens_before": comparison.opens}
	await _family_cooldown()
	_push_joy(JOY_BUTTON_A, true)
	walk["message"] = _hud_message()
	walk["comparison"] = comparison.is_open
	walk["paused"] = paused
	_push_joy(JOY_BUTTON_A, false)
	await _await_process_frames(2)
	walk["prompt"] = _prompt()
	walk["same"] = _same_items(far, _item_state())
	walk["controller"] = slice.input_family.family == InputFamilyTracker.Family.CONTROLLER
	_living["walk"] = walk

	_stand_facing(_drop_position + forward * LIVING_NEAR, forward)
	await _settle(2)
	await _await_process_frames(3)
	var near: Dictionary = _item_state()
	var by_pad: Dictionary = {"prompt": _prompt(), "gap": _planar_gap(player.global_position, _drop_position)}
	var pad_opens: int = comparison.opens
	_push_joy(JOY_BUTTON_A, true)
	by_pad["open"] = comparison.is_open
	by_pad["opens"] = comparison.opens - pad_opens
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
	_note("the living character placed %.1f m and %.1f m from the drop for each living interaction" % [LIVING_NEAR, FAR_DROP])


# --- 7–20. What the play measured -------------------------------------------------------------

func _check_a_production_graveblade_death_creates_the_guaranteed_drop() -> void:
	print("")
	print("--- 7. A production Graveblade, killed by the player's own Quick Strike, creates the guaranteed drop through the slice's own route")
	_expect(_floats(_earned.get("trail", [])) == "300, 200, 100, 0" and int(_earned.get("uses", 0)) == 3 and bool(_earned.get("dead", false))
			and bool(_earned.get("by_player", false)) and float(_earned.get("damage", 0.0)) == 100.0 and int(_earned.get("created", 0)) == 1
			and int(_earned.get("lines", 0)) == 1 and bool(_earned.get("latched", false)) and bool(_earned.get("drop", false))
			and String(_earned.get("equipped", "")) == STARTING_SWORD and float(_earned.get("gap", 9.0)) < 0.6,
		"earned %s" % str(_earned))
	print("  3 Quick Strikes at 100: Life %s; the Graveblade's own died, from the player, gave one guaranteed drop — the Watchsteel Sword, %.2f m from where it fell — one 'guaranteed drop' line, the latch set, the Worn Sword still equipped"
		% [_floats(_earned.get("trail", [])).replace(", ", " -> "), float(_earned.get("gap", 0.0))])
	_done("a_production_graveblade_death_creates_the_guaranteed_drop")


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
	print("--- 8. Three deaths, each to 4 of the second Graveblade's own attacks, each arming the normal 0.90 s delay on the lethal frame")
	var faults: PackedStringArray = PackedStringArray()
	var steps: PackedStringArray = PackedStringArray()
	for label: String in ["A", "B", "C"]:
		var record: Dictionary = _deaths.get(label, {})
		if record.is_empty() or not _death_ok(record):
			faults.append("%s: lethal %s, at kill %s, trail %s" % [label, str(record.get("lethal", {})), str(record.get("at_kill", {})), str(record.get("trail", []))])
		else:
			steps.append("%s %s" % [label, "physics" if bool(record["at_kill"]["physics"]) else "process"])
	var a: Dictionary = (_deaths.get("A", {}) as Dictionary).get("living", {})
	var b: Dictionary = (_deaths.get("B", {}) as Dictionary).get("living", {})
	_expect(faults.is_empty() and bool(a.get("nameplate", false)) and bool(a.get("in_range", false))
			and bool(b.get("nameplate", false)) and not bool(b.get("in_range", true)),
		"%s; before A %s; before B %s" % ["; ".join(faults), str(a), str(b)])
	print("  3 deaths: Life 500 -> 375 -> 250 -> 125 -> 0 each; on each lethal frame FALLEN, not alive, no overlay, not paused, the countdown armed at exactly 0.90 s and the pending event the killing Hit itself; one took_damage per Hit and one fell")
	print("  death A stood %.2f m from the drop (in range) and death B %.2f m (out of range), each with the nameplate showing before the first Hit; death C came after the drop was equipped"
		% [float(a.get("gap", 0.0)), float(b.get("gap", 0.0))])
	print("  timing: the lethal Hit landed in the %s step" % ", ".join(steps))
	_done("production_graveblade_attacks_kill_the_player_and_arm_the_delay")


func _check_a_lethal_frame_nameplate_press_opens_nothing() -> void:
	print("")
	print("--- 9. On the lethal frame, before the slice processes again, a real left press on the still-visible nameplate reaches that button and opens nothing")
	var lethal: Dictionary = (_deaths.get("A", {}) as Dictionary).get("lethal", {})
	_expect(bool(lethal.get("same_step", false)) and bool(lethal.get("same_step_after", false)) and bool(lethal.get("nameplate", false))
			and bool(lethal.get("inside", false)) and int(lethal.get("down", 0)) == 1 and int(lethal.get("pressed", 0)) == 1
			and not bool(lethal.get("comparison", true)) and not bool(lethal.get("paused_after", true))
			and is_equal_approx(float(lethal.get("countdown_after", 0.0)), BrokenWatchSlice.FALLEN_DELAY) and bool(lethal.get("pending_after", false))
			and _same_items(lethal.get("before", {}), lethal.get("after", {})),
		"lethal %s" % str(lethal))
	print("  FALLEN and not alive, no process update since the lethal Hit, the nameplate still visible: one left press and release at its centre %s through push_input() — one button_down and one pressed, on the nameplate"
		% str(lethal.get("centre", Vector2.ZERO)))
	print("  the comparison did not open, no 'item comparison opened' line was added, the tree stayed unpaused, the countdown still read 0.90 s with the killing Hit pending, and the drop, loadout and equipped weapon were unchanged")
	_done("a_lethal_frame_nameplate_press_opens_nothing")


func _first_update(record: Dictionary) -> Dictionary:
	var owed: int = int((record.get("at_kill", {}) as Dictionary).get("pre", -9)) + 1
	for reading: Dictionary in record.get("ticks", []):
		if int(reading["tick"]) == owed:
			return reading
	return {}


func _check_the_first_process_update_hides_the_nameplate_and_prompt() -> void:
	print("")
	print("--- 10. By the first process update after the lethal frame the nameplate is hidden and the prompt empty, and so on every update after it until the restart")
	var faults: PackedStringArray = PackedStringArray()
	var read: int = 0
	for label: String in ["A", "B", "C"]:
		var record: Dictionary = _deaths.get(label, {})
		var first: Dictionary = _first_update(record)
		if first.is_empty() or bool(first["nameplate"]) or not String(first["prompt"]).is_empty() or bool(first["panel"]) or bool(first["alive"]):
			faults.append("%s first update %s" % [label, str(first)])
		var owed: int = int((record.get("at_kill", {}) as Dictionary).get("pre", -9)) + 1
		for reading: Dictionary in record.get("ticks", []):
			if int(reading["tick"]) >= owed:
				read += 1
				if bool(reading["nameplate"]) or not String(reading["prompt"]).is_empty() or bool(reading["panel"]):
					faults.append("%s tick %d %s" % [label, int(reading["tick"]), str(reading)])
					break
	_expect(faults.is_empty() and read > 60, "%s; %d readings" % ["; ".join(faults), read])
	print("  in all 3 deaths, read after the slice's own first process update past the lethal frame: nameplate hidden, prompt text empty, prompt panel hidden")
	print("  and on every one of the %d process updates read after that, through the delay, behind the overlay and up to each restart" % read)
	_done("the_first_process_update_hides_the_nameplate_and_prompt")


func _attempts(kind: String) -> Array:
	var found: Array = []
	for label: String in ["A", "B"]:
		for attempt: Dictionary in (_deaths.get(label, {}) as Dictionary).get("attempts", []):
			if attempt["kind"] == kind:
				found.append(attempt)
	return found


func _attempt_left_nothing(attempt: Dictionary) -> bool:
	return (not bool(attempt["comparison"]) and not bool(attempt["paused"]) and bool(attempt["same"]) and bool(attempt["pending"])
		and attempt["state"] == "FALLEN" and not bool(attempt["destination"]) and not bool(attempt["nameplate"])
		and String(attempt["prompt"]).is_empty())


func _check_repeated_nameplate_presses_in_the_delay_change_nothing() -> void:
	print("")
	print("--- 11. Repeated left clicks where the nameplate stood, later in the delay (J1's route), change nothing")
	var clicks: Array = _attempts("click")
	var faults: PackedStringArray = PackedStringArray()
	var times: PackedStringArray = PackedStringArray()
	var lines: PackedStringArray = PackedStringArray()
	for attempt: Dictionary in clicks:
		var press: Dictionary = attempt["press"]
		if not (_attempt_left_nothing(attempt) and int(press["down"]) == 0 and int(press["pressed"]) == 0
				and float(attempt["countdown_after"]) < float(attempt["remaining"]) and float(attempt["countdown_after"]) > 0.0):
			faults.append(str(attempt))
		times.append("%.3f" % float(attempt["remaining"]))
		for line: String in attempt["new_logs"]:
			lines.append(line.substr(15).strip_edges())
	_expect(clicks.size() == 3 and faults.is_empty(), "%d clicks; %s" % [clicks.size(), "; ".join(faults)])
	print("  3 left presses and releases through Input.parse_input_event() at the nameplate's last centre: none reached the nameplate, which stayed hidden; no comparison, no pause, the countdown still falling, the killing Hit still pending, the character FALLEN with no destination, and the drop, loadout and equipped weapon unchanged")
	print("  timing: pressed with %s s of 0.90 left" % ", ".join(times))
	print("  the slice logged, in all: %s" % ("nothing" if lines.is_empty() else "; ".join(lines)))
	_done("repeated_nameplate_presses_in_the_delay_change_nothing")


func _check_controller_interact_in_the_delay_opens_nothing_and_says_nothing() -> void:
	print("")
	print("--- 12. The controller's interact inside the delay, in range and out of it, opens no comparison and writes no \"Walk closer\"")
	var pads: Array = _attempts("interact")
	var faults: PackedStringArray = PackedStringArray()
	var ranges: PackedStringArray = PackedStringArray()
	for attempt: Dictionary in pads:
		var now: Dictionary = attempt["synchronous"]
		if not (_attempt_left_nothing(attempt) and not bool(now["comparison"]) and not bool(now["paused"]) and bool(now["countdown_same"])
				and bool(now["message_same"]) and String((now["message"] as Dictionary)["text"]) != WALK_CLOSER and (attempt["new_logs"] as Array).is_empty()):
			faults.append(str(attempt))
		ranges.append("in range" if bool(attempt["in_range"]) else "out of range")
	_expect(pads.size() == 2 and ranges == PackedStringArray(["in range", "out of range"]) and faults.is_empty(),
		"%d attempts (%s); %s" % [pads.size(), ", ".join(ranges), "; ".join(faults)])
	print("  one joypad (A) press and release in death A, in range, and one in death B, out of range: read in the same call, no comparison, no pause, the countdown not moved, the HUD message untouched; nothing logged")
	print("  afterwards the drop, ownership, loadout and equipped weapon were unchanged and the countdown kept falling")
	_done("controller_interact_in_the_delay_opens_nothing_and_says_nothing")


func _check_the_direct_opener_refuses_a_fallen_player() -> void:
	print("")
	print("--- 13. The shared opener, called directly while FALLEN, refuses with no state movement")
	var direct: Array = _attempts("direct")
	var ok: bool = direct.size() == 1
	if ok:
		var attempt: Dictionary = direct[0]
		var now: Dictionary = attempt["synchronous"]
		ok = (_attempt_left_nothing(attempt) and not bool(now["comparison"]) and not bool(now["paused"]) and bool(now["countdown_same"])
			and bool(now["message_same"]) and (attempt["new_logs"] as Array).is_empty())
	_expect(ok, "direct %s" % str(direct))
	print("  open_item_comparison(\"verification\") with %.3f s of the delay left: no comparison, no log line, no pause, the countdown and the killing Hit untouched, the drop and loadout unchanged"
		% (float((direct[0] as Dictionary)["remaining"]) if direct.size() == 1 else -1.0))
	_done("the_direct_opener_refuses_a_fallen_player")


func _check_the_delay_runs_on_and_opens_fallen_once_on_the_original_hit() -> void:
	print("")
	print("--- 14. After every attempt the delay runs on, and the Fallen overlay opens exactly once, on the original killing Hit")
	var faults: PackedStringArray = PackedStringArray()
	var frames: PackedStringArray = PackedStringArray()
	var ticked: PackedStringArray = PackedStringArray()
	for label: String in ["A", "B"]:
		var record: Dictionary = _deaths.get(label, {})
		var samples: Array = record.get("samples", [])
		var previous: float = INF
		for sample: Dictionary in samples:
			if (bool(sample["paused"]) or bool(sample["alive"]) or float(sample["life"]) != 0.0 or not bool(sample["pending"])
					or bool(sample["comparison"]) or float(sample["remaining"]) > previous or float(sample["remaining"]) <= 0.0):
				faults.append("%s sample %s" % [label, str(sample)])
				break
			previous = float(sample["remaining"])
		## Strictly falling is read where the slice has just ticked it: after each of its own process
		## updates, from the lethal frame until the overlay opened.
		previous = INF
		var updates: int = 0
		var owed: int = int((record.get("at_kill", {}) as Dictionary).get("pre", -9)) + 1
		for reading: Dictionary in record.get("ticks", []):
			if int(reading["tick"]) < owed or bool(reading["overlay"]):
				continue
			updates += 1
			if bool(reading["paused"]) or float(reading["countdown"]) >= previous or float(reading["countdown"]) <= 0.0:
				faults.append("%s update %s" % [label, str(reading)])
				break
			previous = float(reading["countdown"])
		ticked.append("%s %d" % [label, updates])
		var opened: Dictionary = record.get("opened", {})
		var restart: Dictionary = record.get("restart", {})
		if not (bool(opened.get("once", false)) and bool(opened.get("with_event", false)) and opened.get("source", "") == KILLING_SOURCE
				and opened.get("state", "") == "FALLEN" and bool(opened.get("paused", false)) and float(opened.get("countdown", 0.0)) == -1.0
				and bool(opened.get("pending_is_event", false)) and bool(opened.get("focused", false))
				and int(record.get("planned", -1)) == (record.get("attempts", []) as Array).size()
				and bool(restart.get("closed_once", false)) and bool(restart.get("restarted_once", false)) and bool(restart.get("alive", false))
				and float(restart.get("countdown", 0.0)) == -1.0 and bool(restart.get("pending_null", false))):
			faults.append("%s opened %s restart %s" % [label, str(opened), str(restart)])
		frames.append("%s %d" % [label, samples.size()])
	_expect(faults.is_empty() and _cleanups == 0 and _opened_pending.size() == 2 and slice.fallen_overlay.opens == 2,
		"%s; cleanups %d; the overlay opened %d time(s)" % ["; ".join(faults), _cleanups, slice.fallen_overlay.opens])
	print("  on every sampled frame of both delays: not paused, FALLEN at 0, the killing Hit pending, no comparison, and the countdown strictly falling; the harness's cleanup path ran %d times" % _cleanups)
	print("  each delay then opened Fallen exactly once, the room's pending event at that moment the original killing Hit, \"%s\" on the overlay, its restart button focused; over the whole run it opened twice" % KILLING_SOURCE)
	print("  and read after each of the slice's own process updates in both delays, the countdown strictly fell every time and the tree was never paused")
	print("  timing: %s frames sampled per delay; %s process updates read" % [", ".join(frames), ", ".join(ticked)])
	_done("the_delay_runs_on_and_opens_fallen_once_on_the_original_hit")


func _check_behind_the_fallen_overlay_item_interaction_is_still_refused() -> void:
	print("")
	print("--- 15. Behind the Fallen overlay, item interaction is refused exactly as before")
	var behind: Dictionary = (_deaths.get("A", {}) as Dictionary).get("behind", {})
	var press: Dictionary = behind.get("press", {})
	_expect(not behind.is_empty() and (behind["faults"] as PackedStringArray).is_empty() and int(press.get("down", -1)) == 0
			and int(press.get("pressed", -1)) == 0 and int(press.get("panel_fired", -1)) == 0 and not bool(behind["comparison"])
			and bool(behind["overlay"]) and bool(behind["paused"]) and bool(behind["restarts_same"]) and bool(behind["same"])
			and not bool(behind["nameplate"]) and String(behind["prompt"]).is_empty() and not bool(behind["alive"]) and not bool(behind["on_restart"]),
		"behind %s" % str(behind))
	print("  10 paused physics and 5 idle frames: the overlay standing, the tree paused, the nameplate hidden, the prompt empty, no comparison")
	print("  one left click through J1's route where the nameplate stood landed on the overlay's own panel, not its Restart button: no button pressed, no comparison, no restart, the drop and loadout unchanged")
	_done("behind_the_fallen_overlay_item_interaction_is_still_refused")


func _check_a_living_player_sees_the_nameplate_and_opens_and_closes_it_by_left_click() -> void:
	print("")
	print("--- 16. After a normal restart a living character sees the nameplate and prompt, opens the comparison with a real left click, and closes it without taking the item")
	var seen: Dictionary = _living.get("seen", {})
	var by_click: Dictionary = _living.get("by_click", {})
	var click: Dictionary = by_click.get("click", {})
	var name: String = String(seen.get("name", ""))
	_expect(bool(seen.get("alive", false)) and bool(seen.get("nameplate", false)) and name == "Watchsteel Sword" and seen.get("text", "") == name
			and seen.get("prompt", "") == "%s — Left click" % name and bool(seen.get("panel", false)) and bool(seen.get("mouse", false))
			and int(click.get("down", 0)) == 1 and int(click.get("pressed", 0)) == 1 and bool(by_click.get("open", false))
			and int(by_click.get("opens", 0)) == 1 and bool(by_click.get("log", false)) and bool(by_click.get("paused", false))
			and bool(by_click.get("focus", false)) and _one_press(by_click.get("close", {})) and bool(by_click.get("closed", false))
			and bool(by_click.get("kept", false)),
		"seen %s; by click %s" % [str(seen), str(by_click)])
	print("  alive, %.2f m from the drop: the nameplate showing \"%s\" and the prompt \"%s — Left click\"" % [float(seen.get("gap", 0.0)), name, name])
	print("  one left press and release on the nameplate through Input.parse_input_event(): one pressed; the comparison opened once ('nameplate clicked'), paused, Close focused")
	print("  one left click on Close: closed once, \"%s\"; the drop still on the ground, nothing owned or equipped changed" % CLOSE_REASON)
	_done("a_living_player_sees_the_nameplate_and_opens_and_closes_it_by_left_click")


func _check_a_living_out_of_range_controller_interact_still_says_walk_closer() -> void:
	print("")
	print("--- 17. A living character out of range still gets the accepted \"Walk closer to inspect it\" from the controller's interact")
	var walk: Dictionary = _living.get("walk", {})
	var message: Dictionary = walk.get("message", {})
	var name: String = String((_living.get("seen", {}) as Dictionary).get("name", ""))
	_expect(float(walk.get("gap", 0.0)) > BrokenWatchSlice.ITEM_INTERACTION_RANGE and message.get("text", "") == WALK_CLOSER and bool(message.get("visible", false))
			and is_equal_approx(float(message.get("timer", 0.0)), FirstMvpCombatHud.MESSAGE_SECONDS) and not bool(walk.get("comparison", true))
			and not bool(walk.get("paused", true)) and walk.get("prompt", "") == "%s — walk closer" % name and bool(walk.get("same", false))
			and bool(walk.get("controller", false)),
		"walk %s" % str(walk))
	print("  %.2f m from the drop, one joypad (A) press: \"%s\" shown for %.1f s, no comparison, no pause; the prompt then read \"%s — walk closer\""
		% [float(walk.get("gap", 0.0)), WALK_CLOSER, FirstMvpCombatHud.MESSAGE_SECONDS, name])
	_done("a_living_out_of_range_controller_interact_still_says_walk_closer")


func _check_a_living_player_opens_it_by_controller_and_equips_once() -> void:
	print("")
	print("--- 18. A living character in range opens the comparison with the controller's interact and equips through the existing path exactly once")
	var by_pad: Dictionary = _living.get("by_pad", {})
	var again: Dictionary = by_pad.get("again", {})
	var name: String = String((_living.get("seen", {}) as Dictionary).get("name", ""))
	_expect(by_pad.get("prompt", "") == "%s — (A) Inspect" % name and bool(by_pad.get("open", false)) and int(by_pad.get("opens", 0)) == 1
			and bool(by_pad.get("log", false)) and bool(by_pad.get("paused", false)) and bool(by_pad.get("focus", false))
			and bool(by_pad.get("equip_focused", false)) and int(by_pad.get("equips", 0)) == 1 and bool(by_pad.get("closed", false))
			and bool(by_pad.get("drop_gone", false)) and int(by_pad.get("owned", 0)) == 1 and bool(by_pad.get("equipped", false))
			and bool(by_pad.get("weapon", false)) and int(by_pad.get("lines", 0)) == 1
			and int(again.get("opens", -1)) == 0 and int(again.get("equips", -1)) == 1 and not bool(again.get("open", true)),
		"by pad %s" % str(by_pad))
	print("  %.2f m from the drop the prompt read \"%s — (A) Inspect\"; one joypad (A) press opened the comparison once ('controller interact'), paused, Close focused"
		% [float(by_pad.get("gap", 0.0)), name])
	print("  joypad right moved focus to Equip and (A) pressed it: one weapon_changed, one 'weapon equipped' line, the comparison closed as 'equipped', the drop gone, one more item owned, the Watchsteel Sword equipped and swung; one more (A) opened nothing")
	_done("a_living_player_opens_it_by_controller_and_equips_once")


func _check_f5_in_a_later_delay_still_cancels_before_the_revival() -> void:
	print("")
	print("--- 19. J3 intact: F5 inside a later delay cancels the pending Fallen before the revival, and no old overlay opens afterwards")
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
	print("--- 20. The guaranteed-drop latch still permits exactly the accepted single drop")
	_expect(int(_latch.get("refused", 0)) == 1 and int(_latch.get("granted", -1)) == 0 and int(_latch.get("created", -1)) == 0
			and int(_latch.get("created_total", 0)) == 1 and bool(_latch.get("latched", false)) and bool(_latch.get("active", false))
			and int(_latch.get("lines", 0)) == 1,
		"latch %s" % str(_latch))
	print("  one drop was ever created, through 3 deaths, 3 restarts and one equip; one more kill of the first Graveblade was refused ('reward refused') with no second drop and no second 'guaranteed drop' line")
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


func _same_ownership(a: Dictionary, b: Dictionary) -> bool:
	for key: String in ["drops", "active", "owned", "equipped", "weapon", "equipped_logs"]:
		if a.get(key) != b.get(key):
			return false
	return true


func _same_items(a: Dictionary, b: Dictionary) -> bool:
	return _same_ownership(a, b) and a.get("open") == b.get("open") and a.get("opens") == b.get("opens") and a.get("opened_logs") == b.get("opened_logs")


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
## call the mouse the live family, so the prompt read next is the mouse's.
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
	_note("one pointer movement made the mouse the live input family before the living nameplate was read")


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


# --- The pointer, the keyboard and the controller ---------------------------------------------

## Window coordinates for a point in the viewport's own space: the stretch transform, applied the way
## the operating system's pointer arrives through it.
func _window_point(local: Vector2) -> Vector2:
	return root.get_final_transform() * local


func _motion_event(local: Vector2) -> InputEventMouseMotion:
	var motion: InputEventMouseMotion = InputEventMouseMotion.new()
	var at: Vector2 = _window_point(local)
	motion.position = at
	motion.global_position = at
	return motion


func _button_event(local: Vector2, index: MouseButton, pressed: bool) -> InputEventMouseButton:
	var click: InputEventMouseButton = InputEventMouseButton.new()
	var at: Vector2 = _window_point(local)
	click.button_index = index
	click.pressed = pressed
	click.position = at
	click.global_position = at
	return click


## One real left press and release at `local` through `Input.parse_input_event()`, delivered at the next
## frame's input flush; counts what reached the ground-item nameplate and, with `panel`, its buttons.
func _parse_press_at(local: Vector2, panel: Control) -> Dictionary:
	var nameplate: Button = slice._nameplate
	var hits: Array = [0, 0]
	var on_down: Callable = func() -> void: hits[0] = int(hits[0]) + 1
	var on_pressed: Callable = func() -> void: hits[1] = int(hits[1]) + 1
	nameplate.button_down.connect(on_down)
	nameplate.pressed.connect(on_pressed)
	if panel != null:
		_watch(panel)
	Input.parse_input_event(_motion_event(local))
	Input.parse_input_event(_button_event(local, MOUSE_BUTTON_LEFT, true))
	Input.parse_input_event(_button_event(local, MOUSE_BUTTON_LEFT, false))
	await _await_process_frames(2)
	var result: Dictionary = {"down": hits[0], "pressed": hits[1], "panel_fired": _total_fired() if panel != null else 0}
	nameplate.button_down.disconnect(on_down)
	nameplate.pressed.disconnect(on_pressed)
	_unwatch()
	return result


## One real left click on `button` through `Input.parse_input_event()` — J1's route.
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


## One joypad button pushed into the root viewport, the way a connected controller's arrives.
func _push_joy(button: JoyButton, pressed: bool) -> void:
	var event: InputEventJoypadButton = InputEventJoypadButton.new()
	event.device = 0
	event.button_index = button
	event.pressed = pressed
	event.pressure = 1.0 if pressed else 0.0
	root.push_input(event)


func _settle(frames: int) -> void:
	for frame: int in frames:
		await physics_frame


func _await_process_frames(frames: int) -> void:
	for frame: int in frames:
		await process_frame


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
