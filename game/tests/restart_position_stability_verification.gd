extends SceneTree
## First-MVP Gameplay J10 — Gate 1D Restart Position Stability V1: automated verification (decision D-340).
##
## THE ONE QUESTION: after every Gate 1D restart, does the character stand at Broken Watch's entry, facing the
## route, and stay there with nothing left over to move it? Before J10 it did not. D-325 ruling 3 recorded it
## moving 1.377 m on the next physics frame and settling 1.401 m along the route. J10's diagnosis measured two
## separate causes, and each is corrected in its own file:
##   - THE ENTRY SOCKET LAY INSIDE A SOLID. `BrokenWatchLayout.ENTRY_POINT` (3, -33) sat 1.0 m inside Riftfall
##     Landing Greybox V2's "Watch Breach" far cap — a tall boundary mass at x 1-9, z -34 to -30 in the same
##     local frame — so the first `move_and_slide()` after a restart pushed the body out through the nearest
##     face. The owner authorized moving the socket (D-340): it now stands at (3, -34.75), 0.75 m past that
##     face, on the navigation mesh and still inside the Watch Threshold.
##   - THE REVIVAL KEPT THE OLD MOVEMENT COMMAND. `revive_for_testing()` restores Life, Mana and the action
##     state and sets the neutral latch, but it keeps the navigation destination, the locomotion reading, an
##     attack in progress and any suspension it holds, so F5 during a click-to-move sent the character walking
##     back toward the old destination from the entry. The restart now ends all of it through
##     `clear_movement_intent()`, the project's one neutralization authority, with `require_neutral = false`,
##     so the latch the revival has just set is kept exactly as it was.
##
## Both production changes are proved by reconstruction: with J10's changes put back, the slice and the layout
## are, byte for byte, the files D-339 left.
##
## GATE 1D'S OWN `broken_watch_slice.tscn`, LOADED AS IT SHIPS. Every restart reaches `restart_current_slice()`
## through a production path — F5 pushed into the root viewport, Enter on the Fallen overlay's focused Restart
## button, or one real left click on that button through `Input.parse_input_event()` — and every movement input
## is real input: a left click or a held left button through `Input.parse_input_event()`, a right press for
## Quick Strike the same way, and the left stick held through the InputMap's own stick action. What the harness
## does itself is stated where it does it:
##   - each route begins with the character stood in Riftfall Landing's Watch Forecourt, about 18 m up the
##     route from the entry, with every intent cleared and both Graveblades quieted;
##   - the first Graveblade is killed by the player's own Quick Strikes aimed through the slice's seam, and the
##     player is killed by the second Graveblade's own attacks begun through its seam;
##   - ISOLATION: once a restart has been read in its own call, both Graveblades are quieted and the first is
##     placed on Riftfall Landing's player start, more than 30 m from the entry, before the stability window.
##     One further restart is measured with both Graveblades exactly where the restart put them.
##
## The Roguelite Core Loop's own scene is then loaded as it ships and its own reset is measured. Gate 1E is read
## from source only; its scene is never loaded here.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Input is simulated, which is not physical-device certification. It
## opens no window of its own and writes no file.
##
## Run: godot --headless --path game --script res://tests/restart_position_stability_verification.gd

const THIS_FILE: String = "res://tests/restart_position_stability_verification.gd"
const SLICE_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
const LAYOUT_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_layout.gd"
const PLAYER_SCRIPT: String = "res://scripts/actors/prototype_player.gd"
const SLICE_SCENE: String = "res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
const CORE_LOOP_SCRIPT: String = "res://scripts/roguelite/roguelite_core_loop_runtime.gd"
const CORE_LOOP_SCENE: String = "res://scenes/roguelite/roguelite_core_loop.tscn"
const EXPERIENCE_SCRIPT: String = "res://scripts/roguelite/experience/roguelite_experience_collection_review.gd"
const OPENING_SCRIPT: String = "res://scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31
const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]
const CALLBACK: String = "_on_first_graveblade_died"

## The slice and the layout as D-339 left them, whole, and J10's one change to each. Each pair is [as J10 wrote
## it, as D-339 left it]; each carries a line beside the change so that it is unique.
const PRE_J10_SLICE_SHA256: String = "942aee836be7402f5da5698887263039aae279721aa9ace54771f488a256b0b5"
const PRE_J10_LAYOUT_SHA256: String = "79c2b3a57b04309bbbb1c5a1aacb2aaf18b04e49de0ed6eaf61d73fc764d9219"
const J10_SLICE_PREFIX: String = "883ef25e"
## First-MVP Gameplay J11 (D-344) moved the slice again, so the LIVE file is at this prefix and J10's own
## state is reached through `_before_j11()`.
const J11_SLICE_PREFIX: String = "d4e839fb"
const J10_LAYOUT_PREFIX: String = "cac924df"
const ENTRY_LINE: String = "\tplayer.global_position = broken_watch.entry()\n"
const J10_CLEARING: String = "\t# First-MVP Gameplay J10 (decision D-340): the revival keeps the old destination,\n\t# locomotion and attack, so the one neutralization authority ends them at the entry.\n\tplayer.clear_movement_intent(reason, false)\n"
const SOCKET_HEADER: String = "## `RiftfallLandingGreyboxLayout`'s own `PLAYER_START`/`WAY_OUT` are stored).\n"
const PRE_J10_ENTRY_CONSTANT: String = "const ENTRY_POINT: Vector2 = Vector2(3.0, -33.0)\n"
const J10_ENTRY_CONSTANT: String = "## First-MVP Gameplay J10 (decision D-340): the entry was (3, -33), 1.0 m inside the\n## Landing's Watch Breach far cap (a solid at x 1-9, z -34 to -30 in this same frame),\n## so a body placed there was pushed 1.40 m out. It now stands 0.75 m past that cap's\n## face, clear of it and on the navigation mesh, still inside the Watch Threshold.\nconst ENTRY_POINT: Vector2 = Vector2(3.0, -34.75)\n"
const PRE_J10_ENTRY_LOCAL: Vector2 = Vector2(3.0, -33.0)
const J10_ENTRY_LOCAL: Vector2 = Vector2(3.0, -34.75)
const CAPSULE_RADIUS: float = 0.40
const CAP_RECT: Rect2 = Rect2(Vector2(1.0, -34.0), Vector2(8.0, 4.0))

## `restart_current_slice()`'s code lines after J10: J3's accepted body with J10's clearing directly after the
## entry and before the facing.
const RESTART_LINES: Array[String] = [
	"log_event(\"slice restarted\", reason)", "_fallen_countdown = -1.0", "_pending_fallen_event = null",
	"player.revive_for_testing()", "player.global_position = broken_watch.entry()",
	"player.clear_movement_intent(reason, false)", "player.face_instantly(route_forward())",
	"for enemy: PrototypeGraveblade in graveblades:", "enemy.set_ai_enabled(true)", "enemy.reset_encounter()",
	"attack_coordinator.reset()", "_soft_target = null", "marker.hide_destination()",
]
const CLEARING_LINE: String = "player.clear_movement_intent(reason, false)"
## What the one neutralization authority clears, read from the unchanged player.
const AUTHORITY_LINES: Array[String] = [
	"attack.clear(reason)", "_movement_suspended_by_attack = false", "has_destination = false",
	"_agent.target_position = global_position", "_locomotion.reset()", "velocity = Vector3.ZERO",
]

## The slice's declarations, counted at D-339.
const SLICE_FIELDS: int = 35
const SLICE_EXPORTS: int = 8
const SLICE_FUNCTIONS: int = 53
const SLICE_CONSTANTS: int = 12

## Everything J10 stands beside, at the SHA-256 prefix each held before the first J10 edit.
const UNCHANGED_HASHES: Array = [
	["res://scripts/first_mvp/greybox/riftfall_landing_greybox_layout.gd", "21afae31"],
	["res://scripts/actors/prototype_player.gd", "80e38838"],
	["res://scripts/movement/prototype_locomotion.gd", "c71de58f"],
	["res://scripts/movement/prototype_mouse_hold.gd", "089e8dd5"],
	["res://scripts/movement/prototype_ground_pointer.gd", "ee7ab5ad"],
	["res://scripts/ui/first_mvp_modal.gd", "1cfe9c73"],
	["res://scripts/ui/first_mvp_fallen_overlay.gd", "de5e1ab0"],
	["res://scripts/ui/first_mvp_item_comparison.gd", "3607f9f7"],
	["res://scripts/ui/first_mvp_combat_hud.gd", "ee485029"],
	["res://scripts/prototype_zero/destination_marker.gd", "59a3e86d"],
	["res://scripts/camera/prototype_camera_rig.gd", "80c02363"],
	["res://scripts/input/input_family_tracker.gd", "8b721355"],
	["res://scripts/actors/prototype_graveblade.gd", "0ae1374b"],
	["res://scripts/combat/quick_strike_action.gd", "e6514705"],
	["res://scripts/combat/attack_coordinator.gd", "9ee63381"],
	["res://scripts/combat/damage_event.gd", "3b3185c4"],
	["res://scripts/combat/target_acquisition.gd", "bf4c14d4"],
	["res://scripts/combat/prototype_targetable.gd", "af29e970"],
	["res://scripts/items/first_mvp_item_drop.gd", "dbd5594d"],
	["res://scripts/items/player_loadout.gd", "d79b63df"],
	["res://scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd", "601e5901"],
	["res://scripts/roguelite/roguelite_core_loop_runtime.gd", "a76cec3d"],
	["res://scripts/roguelite/replayability/roguelite_replayability_runtime.gd", "ef236cec"],
	["res://scripts/roguelite/build_variety/roguelite_build_variety_runtime.gd", "e9abb336"],
	["res://scripts/roguelite/experience/roguelite_experience_collection_review.gd", "150509d5"],
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", "128103b4"],
	["res://scripts/roguelite/live_effects/roguelite_live_effect_review.gd", "75cb02b9"],
	["res://scripts/prototype_zero/prototype_zero.gd", "21b41e49"],
	["res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn", "e9d16993"],
	["res://scenes/first_mvp/canonical_opening/canonical_opening.tscn", "b1d9f2e4"],
	["res://scenes/roguelite/roguelite_core_loop.tscn", "6bdf5388"],
	["res://scenes/actors/prototype_player.tscn", "3078a215"],
	["res://scenes/actors/prototype_graveblade.tscn", "752db86c"],
	["res://data/prototype_zero/graveblade.tres", "56317f5f"],
	["res://data/first_mvp/severed_threshold/broken_watch/starting_sword.tres", "08e97d2e"],
	["res://data/first_mvp/severed_threshold/broken_watch/watchsteel_sword.tres", "e67730b2"],
	["res://project.godot", "55351038"],
	["res://tests/gate_1d_broken_watch_verification.gd", "9393f97a"],
	["res://tests/gate_1d_broken_watch_smoke.sh", "6f2878f7"],
	["res://tests/gate_1e_canonical_opening_verification.gd", "cef72cb6"],
	["res://tests/roguelite_core_loop_verification.gd", "1c8e60d7"],
	["res://tests/roguelite_core_loop_smoke.sh", "cefd79b5"],
	["res://tests/first_mvp_modal_left_click_smoke.sh", "977c05bd"],
	["res://tests/fallen_modal_life_state_smoke.sh", "9e0977fb"],
]

## Verification Maintenance V1 (decision D-342): every pair list this suite uses to put a file back lives in
## the flat, content-addressed provenance store under res://tests/provenance/, named by the SHA-256 of its
## listing. Each `*_ROWS` and `*_MOVE_IDS` constant below names its pair lists, and the variable of the old name
## holds them resolved, so every check reads exactly as before. They are resolved through the one engine there,
## and only while it is at the SHA-256 pinned here; a pair list the store cannot prove resolves to nothing.
const PROVENANCE_ENGINE: String = "res://tests/provenance/accepted_suite_provenance.gd"
const PROVENANCE_ENGINE_SHA256: String = "fadbdfeba32546d03bffe876c2b8be7a96dfe966ff9f5d4f720199d664b23dc4"

## The sixteen accepted suite files J10 had to move, each [path, J10 prefix, D-339 SHA-256, pairs]. Each pair is
## [as J10 wrote it, as D-339 left it]; with every pair put back once, the file is, byte for byte, the D-339 one.
const MOVED_SUITE_COUNT: int = 16
const MOVED_SUITE_ROWS: Array = [
	["res://tests/first_mvp_modal_left_click_verification.gd", "75f26486", "acbd3892ddbbb4dd6fd61035c3bb0167053afe3d37e4256c0104c4870c6f9d2f", "26ba84a3fd1582fd17708ff4b49d5522cfbf6142a558114d9c519a6f24ab0250"],
	["res://tests/fallen_modal_life_state_verification.gd", "935a37e9", "6acc1e0c04a9f944701e25fa02256d04d1d45c618d965d47954f08b819475755", "26ba84a3fd1582fd17708ff4b49d5522cfbf6142a558114d9c519a6f24ab0250"],
	["res://tests/pending_fallen_restart_verification.gd", "53c37976", "dc9be60fe9dade25eb491050a6bc578697a98b234574422d1c9a0c9c4edda7b3", "d9ffd11477b4bfd3b1c1f297ab77ad7b4ce71a117d1acbd1872907bc18d0fe7a"],
	["res://tests/pending_fallen_restart_smoke.sh", "9a860bca", "ec5bc37fe170dc30f81c3b4ba1f31f9ad7eef5ab5d77516ca68bcd8d109f4858", "58b1cc938d16d1b2bef63f0552efc11c7596ea019e4bb55e98972b4f9494757d"],
	["res://tests/fallen_delay_item_interaction_verification.gd", "5c8e9b07", "eff592afaf4247a0d3a791a61ab88dc3d2b24154441c70a627db3eae653e15a9", "bab624db6148b8252317457295986ea7fcdbd0337bc63e5cd1b080eccc80286e"],
	["res://tests/fallen_delay_item_interaction_smoke.sh", "0fd60eb7", "e14e996b6cbb99d8bcff522e3d082505ff7544068bfc061997dbe0f5f2088baf", "8d4a99d6cc235c0be4eb36dc8b9c9518d3ca17e98153302fdf794e950c8a3b16"],
	["res://tests/fallen_delay_drop_highlight_verification.gd", "dceea6f9", "b735e6c77ded6b0fa5b376285a0994a2441820a575965f49486432ea0f2e1df1", "5e3a771c3ee4e816d68cb6cbbd419bd6654f56642c1a8f292ae7cbdb41716bd1"],
	["res://tests/fallen_delay_drop_highlight_smoke.sh", "b1b456bd", "fea9988e5aafaf8f72698bc8b070053dcb4f9858cb406936f933d0910aeea435", "7e13fd06e30bb30412f0f1cd1d81b4e61bdafdcbe2a8f14e6b8f8f42b997b9f5"],
	["res://tests/combat_hud_fractional_fill_verification.gd", "f7144aac", "d38624c84039c39a8f58d75902b0b61d88fe03e3463858f88a0fead80dad029d", "0a55f82e83f57d33955f8b95d5727ab4e7a1a324e84180953a1fdbaa19ecde42"],
	["res://tests/combat_hud_fractional_fill_smoke.sh", "6cf22e7d", "a444af4bea6a2c2eba2978e181babbf6f60ad29a9df839f7e86acc4e61a2e27a", "f114f35ef32266ae3f23674555ae7a5f37e643391dbd31a075aa709158a42f88"],
	["res://tests/enemy_hover_life_fractional_fill_verification.gd", "0b816f06", "2187ccb1950560e613a92859ed9c2a0f4e1e3c39866e83e83706b8de7b3d3340", "9e04ae8f656916e43630abe66bb77343a9ff811bf467b3d3a817c6f8d3213801"],
	["res://tests/enemy_hover_life_fractional_fill_smoke.sh", "0dbde2d8", "22a950423c15b0f810504136b914e7cd8693cd9977d747c13e7222dc858511c3", "0b3c44793f61c3e40eb9e75c195e05619a356fa83a691eed75192dcbd9e6a28a"],
	["res://tests/combat_hud_safe_bottom_placement_verification.gd", "b709813c", "c980d240c7e64dcf351b306fefc9b9356e7fe393535ae5fa33453a6e2b43acaa", "82050c7e28ac6904a4660ba42adc5d2a2e44d76f4efd75ef2407388481f311e2"],
	["res://tests/combat_hud_safe_bottom_placement_smoke.sh", "900c8d9e", "8c13aa439e5579cca3b0b7fafb08de56632f4f9e320180b238f6e9f52a463935", "19f1cdaa102717d795a153a0544a75c46bf7fb5078016211f74e6fdbf2669ee0"],
	["res://tests/guaranteed_drop_defeated_enemy_binding_verification.gd", "ae964685", "368f584e6721dffef20bdc62b0156316cb0123bf84dc56b073b1797b15cd05ed", "c98dfb77e2e9bf70f9cfeee07dd291b00e9fdedc42f1aaf29f406f6efefe7eb9"],
	["res://tests/guaranteed_drop_defeated_enemy_binding_smoke.sh", "1f2a43b1", "56258899ee65fdaf0b7322144b7bd51ae85e431f94af8447cda1aa47fc72db6d", "ff4ca0fc8b5e87dd34189b030233afe113939b99fcd5e869077ae3dff1b0bf43"],
]
var MOVED_SUITES: Array = _stored(MOVED_SUITE_ROWS)

## Verification Maintenance V1 (D-342) moved eleven of the files above again, one for one, when their put-back pairs
## moved into the flat provenance store. Each is first put back to where D-341 left it and then read exactly
## as before: `VM1_PREFIXES` holds each file's D-342 prefix, and `VM1_MOVES` its pairs of [as D-342 wrote it,
## as D-341 left it], named in `VM1_MOVE_IDS` and applied to that file alone.
const VM1_PREFIXES: Dictionary = {
	"res://tests/fallen_delay_item_interaction_verification.gd": "15352d8a",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "6204a260",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "08aa2d0b",
	"res://tests/combat_hud_fractional_fill_verification.gd": "d23c5fdc",
	"res://tests/combat_hud_fractional_fill_smoke.sh": "be9f6f47",
	"res://tests/enemy_hover_life_fractional_fill_verification.gd": "09e25736",
	"res://tests/enemy_hover_life_fractional_fill_smoke.sh": "85a49a22",
	"res://tests/combat_hud_safe_bottom_placement_verification.gd": "bfab962c",
	"res://tests/combat_hud_safe_bottom_placement_smoke.sh": "95506b40",
	"res://tests/guaranteed_drop_defeated_enemy_binding_verification.gd": "e526397b",
	"res://tests/guaranteed_drop_defeated_enemy_binding_smoke.sh": "22544403",
}
const VM1_MOVE_IDS: Dictionary = {
	"res://tests/fallen_delay_item_interaction_verification.gd": "e48a940f496b486a4e3d29945413a32e72c92d04cc1b53079b43b091c391d8ac",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "b3d27bc2dfc663e6044e81edefed212ca94fac1bcc6efd90695f63ef7729b948",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "6c2fd3b783af50c704bf5eadd9ef796f0d6f633b26e674cf5f653c37ce6a3487",
	"res://tests/combat_hud_fractional_fill_verification.gd": "9f53188f095270661035ffaa398236fd02494e252d347aad0fa108759fe2a35c",
	"res://tests/combat_hud_fractional_fill_smoke.sh": "d014f5ed85cb9a293875956a2606972b00398e1f4be9eeb51fb123a470b82662",
	"res://tests/enemy_hover_life_fractional_fill_verification.gd": "8f8804a3e2969b275a632186b8a886da3a0c8e115c37d0de1ceddd209b9be71a",
	"res://tests/enemy_hover_life_fractional_fill_smoke.sh": "d9d34c41ca3a049ffd0b7fe664806ce399309123362f05e01c8097cdc43ccd9c",
	"res://tests/combat_hud_safe_bottom_placement_verification.gd": "9c2613e527b72cc0163b820733b6ea7db5d14099d07cfe55007687b369cabc4d",
	"res://tests/combat_hud_safe_bottom_placement_smoke.sh": "39db2eeef1b4187331222c05fc9c39070379dccf6ab25695fab42cb6062ee0be",
	"res://tests/guaranteed_drop_defeated_enemy_binding_verification.gd": "bb4d428220fa79ffcc366f3a6db706fd5eace2e51df1edffb8002d6f8ed6493e",
	"res://tests/guaranteed_drop_defeated_enemy_binding_smoke.sh": "c7acc3087d5572686d64967fc227df848a9359d4c899d64a4ab4adca27860fb4",
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
	"res://tests/fallen_delay_drop_highlight_verification.gd": "beb94aa0",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "6f792a38",
	"res://tests/combat_hud_fractional_fill_verification.gd": "8c653002",
	"res://tests/combat_hud_fractional_fill_smoke.sh": "51d64a23",
	"res://tests/enemy_hover_life_fractional_fill_verification.gd": "bf92c1ec",
	"res://tests/enemy_hover_life_fractional_fill_smoke.sh": "64a84a9d",
	"res://tests/combat_hud_safe_bottom_placement_verification.gd": "2ca75553",
	"res://tests/combat_hud_safe_bottom_placement_smoke.sh": "f562e165",
	"res://tests/guaranteed_drop_defeated_enemy_binding_verification.gd": "aaa9e1d3",
	"res://tests/guaranteed_drop_defeated_enemy_binding_smoke.sh": "94b5e6c9",
}
const J11_MOVE_IDS: Dictionary = {
	"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd": "f0f7cf747a8cc738a5e9477ea2028e6d863d9d83d3cc6799d39032a0275db868",
	"res://tests/first_mvp_modal_left_click_verification.gd": "e7b62a6207638ff89cd8732cc9bbcfd57503f83f8877662c7a4806a709fdc3c8",
	"res://tests/fallen_modal_life_state_verification.gd": "e7b62a6207638ff89cd8732cc9bbcfd57503f83f8877662c7a4806a709fdc3c8",
	"res://tests/pending_fallen_restart_verification.gd": "eab887b6ceea266bb06554728df7227e3c47fb0338990a0f9e3209f733f9b6c2",
	"res://tests/pending_fallen_restart_smoke.sh": "a7a5214f7f0fd6e1f4d32fc539df430b11312aee42ad845ee135cbdba73cecd2",
	"res://tests/fallen_delay_item_interaction_verification.gd": "7b773bea4b14e0ff94ae58afcf898e9d269834c1c8bd257ad10717becf55fc07",
	"res://tests/fallen_delay_item_interaction_smoke.sh": "a089abfb62d27e1a1f9d8f3e523c12d8da6f930056aba5d3daa0a7a687f5ce2b",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "93e92c6cdfd494daf85285c7abaa06f5229b1bea0e7e4de67d3b6f02f253f182",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "a0d7525a31de8048a66815277d6eb7c67b76dc6d90bbfe2eccb519057cd525fa",
	"res://tests/combat_hud_fractional_fill_verification.gd": "fd86747b7f850c99c998632fb24898b79daa9dd06b2a9e199331a1162a6e40a6",
	"res://tests/combat_hud_fractional_fill_smoke.sh": "ca348c34762f8640fa88bf6629f35c15aaaa7b9a495972800d4dcd94d4074845",
	"res://tests/enemy_hover_life_fractional_fill_verification.gd": "bf9b61b11d9e56be4dff793b83d133f56bcdcf4ffdd8db0cc2ee5e8de0715d5a",
	"res://tests/enemy_hover_life_fractional_fill_smoke.sh": "abb783d1bb48944f378110a2d21d02ba0f6367ad5958c99b4f6de19cbeb49188",
	"res://tests/combat_hud_safe_bottom_placement_verification.gd": "8cdb1c4ac20a56377ccde3a23dc95da5de60cacb66b1777b88ed3cc2ee0f8f18",
	"res://tests/combat_hud_safe_bottom_placement_smoke.sh": "95680171a31d73eac1122c03ce51baba10096ecc56f80691ff6476e132b58383",
	"res://tests/guaranteed_drop_defeated_enemy_binding_verification.gd": "130d65f893fd3c07d1d6261bf850557fb3d45fb71ca060ff70c65914c90dc5b3",
	"res://tests/guaranteed_drop_defeated_enemy_binding_smoke.sh": "769d2d53f0f88c9fcf5bc50e135e4b8ad73245459e92799fbbd041437fff1b4c",
}
var J11_MOVES: Dictionary = _stored(J11_MOVE_IDS)

## Staging. The Watch Forecourt point is in Riftfall Landing's own local frame.
const STAGE_LOCAL: Vector2 = Vector2(4.0, -16.5)
const CLICK_AHEAD: float = 4.0
const KILL_SPOT: float = 6.0
const NEAR: float = 1.2
const MIDDLE_REMAINING: float = 0.45
const RESTART_CAPTION: String = "Restart Broken Watch"
const REFUSED_STATUS: String = "rejected: awaiting neutral input"
const ENCOUNTER_RESET: String = "encounter reset"

## The owner's measure: within 0.010 m of the entry for at least 120 physics frames, with planar velocity
## effectively zero. The window is longer than that and longer than the Fallen delay and fade together.
const WINDOW_FRAMES: int = 150
const STABLE_METRES: float = 0.010
const STILL_SPEED: float = 0.0001
const ISOLATION_METRES: float = 30.0
const NEW_COMMAND_METRES: float = 0.5
const NEW_COMMAND_FRAMES: int = 30

const OWED_CHECKS: Array[String] = [
	"the_production_diff_is_exactly_the_clearing_line_and_the_moved_socket",
	"the_accepted_suites_moved_only_their_pins_reconstructions_and_j3s_ruled_line_list",
	"restart_current_slice_ends_the_movement_intent_after_the_entry_and_nothing_else_moved",
	"the_entry_socket_left_the_landing_cap_and_nothing_else_in_the_layout_moved",
	"the_reach_is_gate_1d_gate_1e_by_structure_and_not_the_roguelite",
	"the_d339_entry_sat_inside_the_cap_and_the_new_entry_is_clear_on_the_mesh_and_reachable",
	"a_real_first_graveblade_kill_keeps_j9s_binding_and_one_drop",
	"route_1_f5_with_an_active_click_destination",
	"route_2_f5_with_the_stick_held",
	"route_2_f5_with_the_left_button_held",
	"route_2_f5_during_a_quick_strike_that_suspended_a_held_stick",
	"route_3_f5_inside_the_fallen_delay",
	"route_4_fallen_restart_by_keyboard_confirm",
	"route_5_fallen_restart_by_a_real_left_click",
	"a_restart_with_both_graveblades_present_resets_both_and_the_player_stays",
	"every_restart_kept_the_drop_latch_and_j9s_rewarded_set",
	"the_roguelite_core_loop_keeps_its_own_reset",
	"gate_1e_inherits_by_structure_only_and_is_not_run",
]

var arguments: PackedStringArray = PackedStringArray()
var slice: BrokenWatchSlice

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _staged: PackedStringArray = PackedStringArray()
var _token: String = ""

var _opening_nodes: int = 0
var _drops_created: int = 0
var _use_id: int = 340000
var _commands: Array[String] = []
var _fired: Dictionary = {}
var _watched: Array[Dictionary] = []
var _player_id: int = 0
var _first_id: int = 0
var _geometry: Dictionary = {}
var _kill: Dictionary = {}
var _latch_start: Dictionary = {}
var _latch_end: Dictionary = {}
var _routes: Dictionary = {}
var _loop: Dictionary = {}


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	_token = _argument_value("--run-token")
	print("")
	print("=== First-MVP Gameplay J10 — Gate 1D Restart Position Stability V1 verification (D-340) ===")
	print("  run token: %s" % (_token if not _token.is_empty() else "none given"))
	node_added.connect(_on_node_added)

	_check_the_production_diff_is_exactly_the_clearing_line_and_the_moved_socket()
	_check_the_accepted_suites_moved_only_their_pins_reconstructions_and_j3s_ruled_line_list()
	_check_restart_current_slice_ends_the_movement_intent_after_the_entry_and_nothing_else_moved()
	_check_the_entry_socket_left_the_landing_cap_and_nothing_else_in_the_layout_moved()
	_check_the_reach_is_gate_1d_gate_1e_by_structure_and_not_the_roguelite()

	await _play_the_slice()
	if slice != null and not _geometry.is_empty():
		_check_the_d339_entry_sat_inside_the_cap_and_the_new_entry_is_clear_on_the_mesh_and_reachable()
	if slice != null and not _kill.is_empty():
		_check_a_real_first_graveblade_kill_keeps_j9s_binding_and_one_drop()
	if slice != null and _routes.has("both"):
		_check_route_1_f5_with_an_active_click_destination()
		_check_route_2_f5_with_the_stick_held()
		_check_route_2_f5_with_the_left_button_held()
		_check_route_2_f5_during_a_quick_strike_that_suspended_a_held_stick()
		_check_route_3_f5_inside_the_fallen_delay()
		_check_route_4_fallen_restart_by_keyboard_confirm()
		_check_route_5_fallen_restart_by_a_real_left_click()
		_check_a_restart_with_both_graveblades_present_resets_both_and_the_player_stays()
		_check_every_restart_kept_the_drop_latch_and_j9s_rewarded_set()

	await _play_the_core_loop()
	if not _loop.is_empty():
		_check_the_roguelite_core_loop_keeps_its_own_reset()
	_check_gate_1e_inherits_by_structure_only_and_is_not_run()

	_check_every_check_ran()
	if node_added.is_connected(_on_node_added):
		node_added.disconnect(_on_node_added)
	await process_frame

	print("")
	print("  staged: %s" % "; ".join(_staged))
	if _failures.is_empty():
		print("RESTART POSITION STABILITY VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RESTART POSITION STABILITY VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		quit(1)


# --- 1–5. Structure: the two files, their one change each, their reach ---------------------------

func _slice_moves() -> Array:
	return [[ENTRY_LINE + J10_CLEARING, ENTRY_LINE]]


func _layout_moves() -> Array:
	return [[SOCKET_HEADER + J10_ENTRY_CONSTANT, SOCKET_HEADER + PRE_J10_ENTRY_CONSTANT]]


func _check_the_production_diff_is_exactly_the_clearing_line_and_the_moved_socket() -> void:
	print("")
	print("--- 1. Exactly two production files moved — Gate 1D's slice and Broken Watch's layout — and each is its D-339 file with J10's one change")
	var slice_text: String = _before_j11(SLICE_SCRIPT, FileAccess.get_file_as_string(SLICE_SCRIPT))
	var layout_text: String = FileAccess.get_file_as_string(LAYOUT_SCRIPT)
	var slice_back: Dictionary = _put_back(slice_text, _slice_moves())
	var layout_back: Dictionary = _put_back(layout_text, _layout_moves())
	var slice_then: String = String(slice_back["text"])
	var layout_then: String = String(layout_back["text"])
	_expect(FileAccess.get_sha256(SLICE_SCRIPT).begins_with(J11_SLICE_PREFIX)
			and slice_text.sha256_text().begins_with(J10_SLICE_PREFIX) and bool(slice_back["unique"])
			and slice_then.sha256_text() == PRE_J10_SLICE_SHA256 and (slice_then + "x").sha256_text() != PRE_J10_SLICE_SHA256
			and slice_text.count(J10_CLEARING) == 1 and slice_text.count("\n") == slice_then.count("\n") + 3,
		"the slice hashes %s, not its J10 prefix %s; J10's lines are in it once: %s; put back it hashes %s, not the D-339 %s"
			% [slice_text.sha256_text().left(8), J10_SLICE_PREFIX, str(slice_back["unique"]),
				slice_then.sha256_text().left(8), PRE_J10_SLICE_SHA256.left(8)])
	_expect(FileAccess.get_sha256(LAYOUT_SCRIPT).begins_with(J10_LAYOUT_PREFIX) and bool(layout_back["unique"])
			and layout_then.sha256_text() == PRE_J10_LAYOUT_SHA256 and (layout_then + "x").sha256_text() != PRE_J10_LAYOUT_SHA256
			and not layout_text.contains(PRE_J10_ENTRY_CONSTANT) and layout_text.count("\n") == layout_then.count("\n") + 4,
		"the layout hashes %s, not its J10 prefix %s; J10's socket is in it once: %s; put back it hashes %s, not the D-339 %s"
			% [FileAccess.get_sha256(LAYOUT_SCRIPT).left(8), J10_LAYOUT_PREFIX, str(layout_back["unique"]),
				layout_then.sha256_text().left(8), PRE_J10_LAYOUT_SHA256.left(8)])
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in UNCHANGED_HASHES:
		var held: String = FileAccess.get_sha256(String(row[0]))
		if not held.begins_with(String(row[1])):
			moved.append("%s %s" % [String(row[0]).get_file(), held.left(8)])
	_expect(moved.is_empty() and UNCHANGED_HASHES.size() == 44, "moved: %s" % ", ".join(moved))
	print("  the slice is at its J10 hash %s, %d lines; with J10's 2 comment lines and 1 clearing line put back it is, byte for byte, the D-339 file %s, %d lines"
		% [slice_text.sha256_text().left(8), slice_text.count("\n"), PRE_J10_SLICE_SHA256.left(8), slice_then.count("\n")])
	print("  the layout is at its J10 hash %s, %d lines; with J10's 4 comment lines removed and ENTRY_POINT put back to Vector2(3.0, -33.0) it is, byte for byte, the D-339 file %s, %d lines"
		% [FileAccess.get_sha256(LAYOUT_SCRIPT).left(8), layout_text.count("\n"), PRE_J10_LAYOUT_SHA256.left(8), layout_then.count("\n")])
	print("  %d files J10 stands beside hold the hashes they held before the first J10 edit: Riftfall Landing's greybox layout, the player, the locomotion, mouse-hold and ground-pointer kernels, the modal contract, the Fallen overlay, the comparison, the HUD, the marker, camera and input tracker, the Graveblade and the combat kernels, the drop and the loadout, Gate 1E's runtime, the core loop and its five descendants, Prototype Zero's room, five scenes, three records, project.godot, and the accepted suites beside this one"
		% UNCHANGED_HASHES.size())
	_done("the_production_diff_is_exactly_the_clearing_line_and_the_moved_socket")


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


func _check_the_accepted_suites_moved_only_their_pins_reconstructions_and_j3s_ruled_line_list() -> void:
	print("")
	print("--- 2. The sixteen accepted suite files J10 had to move moved only their pins, reconstructions, comments and truthful clauses — and J3's line list, by the owner's ruling — one for one, at unchanged counts")
	var faults: PackedStringArray = PackedStringArray()
	var blocks: int = 0
	var back: PackedStringArray = PackedStringArray()
	for row: Array in MOVED_SUITES:
		var path: String = row[0]
		var j10_text: String = _before_vm1(path, _before_j11(path, FileAccess.get_file_as_string(path)))
		var rebuilt: Dictionary = _put_back(j10_text, row[3])
		blocks += (row[3] as Array).size()
		back.append(String(row[2]).left(8))
		if not (FileAccess.get_sha256(path).begins_with(String(J11_PREFIXES.get(path, VM1_PREFIXES.get(path, row[1]))))
				and j10_text.sha256_text().begins_with(String(row[1])) and bool(rebuilt["unique"]) and not (row[3] as Array).is_empty()
				and String(rebuilt["text"]).sha256_text() == String(row[2])
				and (String(rebuilt["text"]) + "x").sha256_text() != String(row[2])):
			faults.append("%s at %s rebuilds to %s" % [path.get_file(), FileAccess.get_sha256(path).left(8), String(rebuilt["text"]).sha256_text().left(8)])
	_expect(faults.is_empty() and MOVED_SUITES.size() == MOVED_SUITE_COUNT,
		"%d of %d moved suite files described; %s" % [MOVED_SUITES.size(), MOVED_SUITE_COUNT, "; ".join(faults)])
	print("  J1's and J2's verifications moved their slice row; J3's to J9's verifications and runners their pins of the slice, the layout and the suites J10 moved before them, and learned to put back what J10 moved before reading as before; J5's to J9's runners their production digest; J3's line list and its print by the owner's ruling: put back, the %d are byte for byte %s (%d replaced blocks)"
		% [MOVED_SUITES.size(), ", ".join(back), blocks])
	_done("the_accepted_suites_moved_only_their_pins_reconstructions_and_j3s_ruled_line_list")


func _check_restart_current_slice_ends_the_movement_intent_after_the_entry_and_nothing_else_moved() -> void:
	print("")
	print("--- 3. restart_current_slice() gains one call, directly after the entry: clear_movement_intent(reason, false); nothing else in the slice moved")
	var source: String = _before_j11(SLICE_SCRIPT, FileAccess.get_file_as_string(SLICE_SCRIPT))
	var pre_text: String = String(_put_back(source, _slice_moves())["text"])
	var lines: PackedStringArray = _code_lines(_function_body(source, "restart_current_slice"))
	var pre_lines: PackedStringArray = _code_lines(_function_body(pre_text, "restart_current_slice"))
	var expected_pre: PackedStringArray = PackedStringArray(RESTART_LINES)
	expected_pre.remove_at(expected_pre.find(CLEARING_LINE))
	var entry_at: int = lines.find("player.global_position = broken_watch.entry()")
	var clear_at: int = lines.find(CLEARING_LINE)
	var face_at: int = lines.find("player.face_instantly(route_forward())")
	var functions: PackedStringArray = _declared_functions(source)
	var pre_functions: PackedStringArray = _declared_functions(pre_text)
	var differing: PackedStringArray = PackedStringArray()
	for name: String in functions:
		if _function_body(source, name) != _function_body(pre_text, name):
			differing.append(name)
	var fields: int = RegEx.create_from_string("(?m)^var ").search_all(source).size()
	var exports: int = RegEx.create_from_string("(?m)^@export var ").search_all(source).size()
	var constants: int = RegEx.create_from_string("(?m)^const ").search_all(source).size()
	var signals: int = RegEx.create_from_string("(?m)^signal ").search_all(source).size()
	var enums: int = RegEx.create_from_string("(?m)^enum ").search_all(source).size()
	var code: String = _bare(source)
	var pre_code: String = _bare(pre_text)
	var authority: PackedStringArray = _code_lines(_function_body(_bare(FileAccess.get_file_as_string(PLAYER_SCRIPT)), "clear_movement_intent"))
	var covered: bool = true
	for line: String in AUTHORITY_LINES:
		covered = covered and authority.has(line)
	_expect(lines == PackedStringArray(RESTART_LINES) and pre_lines == expected_pre
			and entry_at >= 0 and clear_at == entry_at + 1 and face_at == clear_at + 1 and lines.find("player.revive_for_testing()") == 3,
		"restart_current_slice reads %s; D-339's %s" % [str(lines), str(pre_lines)])
	_expect(functions == pre_functions and differing == PackedStringArray(["restart_current_slice"])
			and fields == SLICE_FIELDS and exports == SLICE_EXPORTS and functions.size() == SLICE_FUNCTIONS
			and constants == SLICE_CONSTANTS and signals == 0 and enums == 0
			and code.count("clear_movement_intent(") == 2 and pre_code.count("clear_movement_intent(") == 1
			and code.count("clear_movement_intent(reason, false)") == 1,
		"functions in D-339's order: %s; bodies differing: %s; %d fields, %d exports, %d functions, %d constants, %d signals, %d enums; clear_movement_intent( %d time(s), D-339 %d"
			% [str(functions == pre_functions), str(differing), fields, exports, functions.size(), constants, signals, enums,
				code.count("clear_movement_intent("), pre_code.count("clear_movement_intent(")])
	_expect(covered and authority.has("if require_neutral:") and authority.has("if action_state != ActionState.FALLEN:"),
		"clear_movement_intent() in the unchanged player reads %s" % str(authority))
	print("  %d code lines: J3's accepted body with clear_movement_intent(reason, false) directly after player.global_position = broken_watch.entry() and before the facing; D-339 had %d"
		% [lines.size(), pre_lines.size()])
	print("  %d fields, %d exports, %d functions in D-339's order, %d constants, no signal and no enum; only restart_current_slice() differs from D-339; clear_movement_intent( appears %d times in the slice's code, where D-339 had %d — neutralize_for_modal()'s"
		% [fields, exports, functions.size(), constants, code.count("clear_movement_intent("), pre_code.count("clear_movement_intent(")])
	print("  the unchanged authority, read in the player: it clears the attack, the suspension, the destination, the agent's target, the locomotion reading and the velocity, keeps FALLEN, and re-arms the neutral latch only when asked — J10 passes false, so the latch the revival set stands")
	_done("restart_current_slice_ends_the_movement_intent_after_the_entry_and_nothing_else_moved")


func _check_the_entry_socket_left_the_landing_cap_and_nothing_else_in_the_layout_moved() -> void:
	print("")
	print("--- 4. Broken Watch's entry socket moved out of Riftfall Landing's Watch Breach far cap, to a point clear of every solid; nothing else in the layout moved")
	var source: String = FileAccess.get_file_as_string(LAYOUT_SCRIPT)
	var pre_text: String = String(_put_back(source, _layout_moves())["text"])
	var differing: PackedStringArray = PackedStringArray()
	for name: String in _declared_functions(source):
		if _function_body(source, name) != _function_body(pre_text, name):
			differing.append(name)
	var constants: PackedStringArray = PackedStringArray()
	for found: RegExMatch in RegEx.create_from_string("(?m)^const .*$").search_all(source):
		constants.append(found.get_string())
	var pre_constants: PackedStringArray = PackedStringArray()
	for found: RegExMatch in RegEx.create_from_string("(?m)^const .*$").search_all(pre_text):
		pre_constants.append(found.get_string())
	var changed_constants: PackedStringArray = PackedStringArray()
	for index: int in mini(constants.size(), pre_constants.size()):
		if constants[index] != pre_constants[index]:
			changed_constants.append(constants[index])
	var containing: Array = []
	var nearest_mass: float = INF
	for entry: Dictionary in RiftfallLandingGreyboxLayout.BOUNDARY_MASSES:
		var rect: Rect2 = entry["rect"]
		if rect.has_point(PRE_J10_ENTRY_LOCAL):
			containing.append(entry)
		nearest_mass = minf(nearest_mass, _rect_distance(rect, J10_ENTRY_LOCAL))
	var nearest_wall: float = INF
	for entry: Dictionary in BrokenWatchLayout.BOUNDARY_WALLS:
		nearest_wall = minf(nearest_wall, _rect_distance(entry["rect"] as Rect2, J10_ENTRY_LOCAL))
	var cap: Dictionary = containing[0] if containing.size() == 1 else {}
	var code: String = _bare(source)
	_expect(BrokenWatchLayout.ENTRY_POINT == J10_ENTRY_LOCAL and pre_text.contains(PRE_J10_ENTRY_CONSTANT)
			and differing.is_empty() and constants.size() == pre_constants.size()
			and changed_constants == PackedStringArray([J10_ENTRY_CONSTANT.get_slice("\n", 4)])
			and code.count("ENTRY_POINT") == 4,
		"ENTRY_POINT %s; bodies differing %s; constants changed %s; ENTRY_POINT named %d times"
			% [str(BrokenWatchLayout.ENTRY_POINT), str(differing), str(changed_constants), code.count("ENTRY_POINT")])
	_expect(containing.size() == 1 and (cap.get("rect", Rect2()) as Rect2) == CAP_RECT and bool(cap.get("tall", false))
			and not CAP_RECT.has_point(J10_ENTRY_LOCAL) and nearest_mass >= CAPSULE_RADIUS and nearest_wall >= CAPSULE_RADIUS
			and BrokenWatchLayout.WATCH_THRESHOLD.has_point(J10_ENTRY_LOCAL) and BrokenWatchLayout.WATCH_THRESHOLD.has_point(PRE_J10_ENTRY_LOCAL),
		"the D-339 entry lies in %d boundary mass(es); the new entry is %.2f m from the nearest mass and %.2f m from the nearest wall"
			% [containing.size(), nearest_mass, nearest_wall])
	print("  ENTRY_POINT is %s; every function body and every other constant is D-339's; ENTRY_POINT is still named 4 times — its declaration, its socket marker and entry()'s two reads" % str(BrokenWatchLayout.ENTRY_POINT))
	print("  the D-339 entry %s lies inside exactly one of Riftfall Landing Greybox V2's boundary masses — the tall Watch Breach far cap %s, in the same local frame"
		% [str(PRE_J10_ENTRY_LOCAL), str(CAP_RECT)])
	print("  the new entry is %.2f m from the nearest boundary mass and %.2f m from the nearest Broken Watch wall — both beyond the capsule's %.2f m radius — and still inside the Watch Threshold"
		% [nearest_mass, nearest_wall, CAPSULE_RADIUS])
	_done("the_entry_socket_left_the_landing_cap_and_nothing_else_in_the_layout_moved")


func _check_the_reach_is_gate_1d_gate_1e_by_structure_and_not_the_roguelite() -> void:
	print("")
	print("--- 5. What the two changes reach (structural): Gate 1D, and Gate 1E by inheritance and by its own reading of the socket; the roguelite overrides the restart and never builds Broken Watch")
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
		for path: Variant in classes.keys():
			if lineage.has(String(parents[path])) and not lineage.has(String(classes[path])) and not String(classes[path]).is_empty():
				lineage.append(String(classes[path]))
				descendants.append(String(path).get_file())
	descendants.sort()
	var declarers: PackedStringArray = PackedStringArray()
	var entry_readers: PackedStringArray = PackedStringArray()
	var socket_readers: PackedStringArray = PackedStringArray()
	for path: Variant in sources.keys():
		var code: String = String(sources[path])
		if code.contains("func restart_current_slice("):
			declarers.append(String(path).get_file())
		for index: int in code.count("broken_watch.entry()"):
			entry_readers.append(String(path).get_file())
		if String(path) != LAYOUT_SCRIPT and code.contains("BrokenWatchLayout.ENTRY_POINT"):
			socket_readers.append(String(path).get_file())
	declarers.sort()
	entry_readers.sort()
	var loop_body: String = _function_body(String(sources[CORE_LOOP_SCRIPT]), "restart_current_slice")
	var experience_body: PackedStringArray = _code_lines(_function_body(String(sources[EXPERIENCE_SCRIPT]), "restart_current_slice"))
	var opening_body: PackedStringArray = _code_lines(_function_body(String(sources[OPENING_SCRIPT]), "restart_current_slice"))
	var spawn_body: String = _function_body(String(sources[OPENING_SCRIPT]), "_spawn_for_milestone")
	var project: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	var actions: int = _input_action_count(project)
	_expect(scanned > 100 and descendants == PackedStringArray(["canonical_opening_runtime.gd", "roguelite_build_variety_runtime.gd",
				"roguelite_core_loop_runtime.gd", "roguelite_experience_collection_review.gd", "roguelite_level_up_choice_review.gd",
				"roguelite_live_effect_review.gd", "roguelite_replayability_runtime.gd"])
			and declarers == PackedStringArray(["broken_watch_slice.gd", "canonical_opening_runtime.gd",
				"roguelite_core_loop_runtime.gd", "roguelite_experience_collection_review.gd"]),
		"descendants %s; declarers %s" % [str(descendants), str(declarers)])
	_expect(not loop_body.contains("super") and not loop_body.contains("broken_watch") and loop_body.contains("_enter_hub(reason)")
			and String(parents[EXPERIENCE_SCRIPT]) == "RogueliteCoreLoopRuntime" and experience_body.has("super(reason)")
			and not opening_body.is_empty() and opening_body[0] == "super.restart_current_slice(reason)"
			and spawn_body.contains("return broken_watch.entry()")
			and entry_readers == PackedStringArray(["broken_watch_slice.gd", "canonical_opening_runtime.gd"]) and socket_readers.is_empty(),
		"core loop restart has super %s, names broken_watch %s; experience %s; Gate 1E's first line %s; entry readers %s; socket readers %s"
			% [str(loop_body.contains("super")), str(loop_body.contains("broken_watch")), str(experience_body), str(opening_body.slice(0, 1)),
				str(entry_readers), str(socket_readers)])
	_expect(actions == EXPECTED_ACTIONS and project.contains("run/main_scene=\"%s\"" % ENTRYPOINT) and not project.contains("[autoload]"),
		"%d actions; entrypoint present %s; autoload present %s" % [actions, str(project.contains(ENTRYPOINT)), str(project.contains("[autoload]"))])
	print("  of %d running scripts, 7 descend from BrokenWatchSlice: %s" % [scanned, ", ".join(descendants)])
	print("  restart_current_slice() is declared by %s: Gate 1E's calls super first, so it inherits the clearing and the new socket; the core loop's overrides it without super and names no broken_watch; the experience review's calls super into the core loop's"
		% ", ".join(declarers))
	print("  broken_watch.entry() is read twice in running code: the slice's restart and Gate 1E's _spawn_for_milestone(), which continues a character at the BROKEN_WATCH milestone there; no other script reads BrokenWatchLayout.ENTRY_POINT")
	print("  %d actions; the entrypoint is prototype_app.tscn; project.godot declares no [autoload]" % actions)
	_done("the_reach_is_gate_1d_gate_1e_by_structure_and_not_the_roguelite")


# --- The slice, played ---------------------------------------------------------------------------

func _play_the_slice() -> void:
	slice = await _load(SLICE_SCENE) as BrokenWatchSlice
	if slice == null:
		return
	await _await_navigation(slice)
	_quiet()
	_player_id = slice.player.get_instance_id()
	_first_id = slice.graveblades[0].get_instance_id()
	(slice.get_node("Actors") as Node).child_entered_tree.connect(func(node: Node) -> void:
		if node is FirstMvpItemDrop:
			_drops_created += 1)
	slice.player.movement_command_resolved.connect(_on_command)
	_geometry = _measure_geometry()
	var stage: Dictionary = _stage_soundness()
	if not bool(stage["sound"]):
		_failures.append("harness staging: the Watch Forecourt point is not a sound place to begin a route: %s" % str(stage))
		return
	_note("each route began with the character stood at Riftfall Landing's Watch Forecourt (local %s, %.1f m from the entry), every intent cleared and both Graveblades quieted"
		% [str(STAGE_LOCAL), _planar_gap(_stage_point(), slice.broken_watch.entry())])
	_kill = await _kill_first_graveblade()
	_latch_start = _latch_state()
	_routes["1"] = await _route_click_destination()
	_routes["2a"] = await _route_stick_held()
	_routes["2b"] = await _route_left_button_held()
	_routes["2c"] = await _route_quick_strike_over_held_stick()
	_routes["3"] = await _route_f5_in_fallen_delay()
	_routes["4"] = await _route_fallen_confirm()
	_routes["5"] = await _route_fallen_click()
	_routes["both"] = await _route_with_both_graveblades_present()
	_latch_end = _latch_state()
	_quiet()


func _on_command(status: String, _requested: Vector3, _resolved: Vector3) -> void:
	_commands.append(status)


func _measure_geometry() -> Dictionary:
	var watch: BrokenWatchLayout = slice.broken_watch
	var entry: Vector3 = watch.entry()
	var old: Vector3 = watch.global_transform * Vector3(PRE_J10_ENTRY_LOCAL.x, 0.0, PRE_J10_ENTRY_LOCAL.y)
	var map: RID = slice.navigation_map()
	var start: Vector3 = slice.landing_layout.player_start()
	var path: PackedVector3Array = NavigationServer3D.map_get_path(map, start, entry, true)
	var length: float = 0.0
	for index: int in range(1, path.size()):
		length += _planar_gap(path[index], path[index - 1])
	return {
		"entry_local": Vector2(watch.to_local(entry).x, watch.to_local(entry).z), "old": old,
		"old_overlaps": _overlaps(old), "entry_overlaps": _overlaps(entry),
		"nav_gap": _planar_gap(NavigationServer3D.map_get_closest_point(map, entry), entry),
		"old_nav_gap": _planar_gap(NavigationServer3D.map_get_closest_point(map, old), old),
		"path_points": path.size(), "path_length": length,
		"path_end_gap": _planar_gap(path[path.size() - 1], entry) if path.size() > 0 else INF,
	}


func _stage_soundness() -> Dictionary:
	var map: RID = slice.navigation_map()
	var stage: Vector3 = _stage_point()
	var ahead: Vector3 = stage + _stage_forward() * CLICK_AHEAD
	var tall: int = 0
	for hit: Dictionary in _overlaps(stage):
		if bool(hit["tall"]):
			tall += 1
	var reading: Dictionary = {
		"tall_overlaps": tall, "nav_gap": _planar_gap(NavigationServer3D.map_get_closest_point(map, stage), stage),
		"ahead_nav_gap": _planar_gap(NavigationServer3D.map_get_closest_point(map, ahead), ahead),
		"from_entry": _planar_gap(stage, slice.broken_watch.entry()),
	}
	reading["sound"] = (tall == 0 and float(reading["nav_gap"]) <= 0.05 and float(reading["ahead_nav_gap"]) <= 0.05
		and float(reading["from_entry"]) >= 15.0)
	return reading


## STAGED aim, real attack: the first Graveblade placed on Riftfall Landing's route, 6 m from its player start,
## and struck by the player's own Quick Strikes, aimed through the slice's seam, until it dies.
func _kill_first_graveblade() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var first: PrototypeGraveblade = slice.graveblades[0]
	var area: PrototypeTargetable = first.get_node("TargetArea") as PrototypeTargetable
	var forward: Vector3 = _route()
	var connections: Array = _bound_connections(first)
	await _until_neutral()
	_quiet()
	first.place_at(slice.landing_layout.player_start() + forward * KILL_SPOT)
	first.face_instantly(-forward)
	await _settle(2)
	var heard: Array = []
	var on_died: Callable = func(event: DamageEvent) -> void:
		heard.append({
			"source_id": event.source.get_instance_id() if event.source != null else 0,
			"target_id": event.target.get_instance_id() if event.target != null else 0,
			"rewarded": _sorted(slice._rewarded_enemies.keys()),
		})
	first.died.connect(on_died)
	var trail: Array = [first.life]
	for hit: int in 6:
		if not first.is_alive():
			break
		_stand_facing(first.global_position - forward * 1.0, forward)
		await _settle(1)
		var before: float = first.life
		slice.force_next_aim_for_verification(area)
		player.attack.press()
		player.attack.release_input()
		for frame: int in 120:
			await physics_frame
			if first.life < before and player.attack.phase == QuickStrikeAction.Phase.READY:
				break
		trail.append(first.life)
	await _settle(3)
	await _await_process_frames(3)
	first.died.disconnect(on_died)
	_note("the first Graveblade placed %.0f m up Riftfall Landing's route and killed by the player's own Quick Strikes, aimed through force_next_aim_for_verification()" % KILL_SPOT)
	return {
		"trail": trail, "dead": not first.is_alive(), "heard": heard, "connections": connections,
		"rewarded": _sorted(slice._rewarded_enemies.keys()), "granted": slice._drop_granted, "drops": _drops_created,
		"damage": player.weapon.physical_damage,
	}


func _latch_state() -> Dictionary:
	var drop: FirstMvpItemDrop = slice._active_drop
	return {
		"drop_id": drop.get_instance_id() if drop != null and is_instance_valid(drop) else 0,
		"drop_at": drop.global_position if drop != null and is_instance_valid(drop) else Vector3.INF,
		"granted": slice._drop_granted, "drops": _drops_created, "rewarded": _sorted(slice._rewarded_enemies.keys()),
		"placed": _log_count("placed near the fallen Graveblade"), "refused": _log_count("reward refused"),
	}


# --- The routes ----------------------------------------------------------------------------------

## Route 1: the character walking to a real click destination 4 m ahead, then F5.
func _route_click_destination() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var record: Dictionary = {}
	await _stage()
	var marks: int = _commands.size()
	var screen: Vector2 = _screen(_stage_point() + _stage_forward() * CLICK_AHEAD)
	Input.parse_input_event(_motion_event(screen))
	Input.parse_input_event(_button_event(screen, MOUSE_BUTTON_LEFT, true))
	Input.parse_input_event(_button_event(screen, MOUSE_BUTTON_LEFT, false))
	await _await_process_frames(2)
	await _settle(12)
	record["before"] = {
		"destination": player.has_destination, "moving": _planar_speed(player) > 1.0,
		"accepted": _accepted_since(marks), "mode": player.movement_mode_name(),
	}
	var restarts: int = _log_count("slice restarted")
	_push_key(KEY_F5, true)
	record["call"] = _reading("quick restart", restarts)
	_push_key(KEY_F5, false)
	record["isolated"] = _isolate()
	record["window"] = await _window(WINDOW_FRAMES)
	record["after"] = await _new_click_command()
	_note("route 1: a real left press and release through Input.parse_input_event() on the ground 4 m ahead, then F5 pushed into the root viewport while walking to it")
	return record


## Route 2, stick: the left stick held forward through the InputMap's own stick action, then F5 with it still held.
func _route_stick_held() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var record: Dictionary = {}
	await _stage()
	Input.action_press(&"move_vector_forward", 1.0)
	await _settle(12)
	record["before"] = {"moving": _planar_speed(player) > 1.0, "mode": player.movement_mode_name()}
	var restarts: int = _log_count("slice restarted")
	_push_key(KEY_F5, true)
	record["call"] = _reading("quick restart", restarts)
	_push_key(KEY_F5, false)
	record["isolated"] = _isolate()
	record["window"] = await _window(WINDOW_FRAMES)
	Input.action_release(&"move_vector_forward")
	record["release"] = await _after_release()
	record["after"] = await _new_stick_command()
	_note("route 2: the left stick held forward through Input.action_press(\"move_vector_forward\"), which the slice reads every physics frame; released through Input.action_release()")
	return record


## Route 2, left button: the left button held down on the ground ahead, then F5 with it still held.
func _route_left_button_held() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var record: Dictionary = {}
	await _stage()
	var marks: int = _commands.size()
	var screen: Vector2 = _screen(_stage_point() + _stage_forward() * CLICK_AHEAD)
	Input.parse_input_event(_motion_event(screen))
	Input.parse_input_event(_button_event(screen, MOUSE_BUTTON_LEFT, true))
	await _await_process_frames(2)
	await _settle(12)
	record["before"] = {
		"destination": player.has_destination, "moving": _planar_speed(player) > 1.0, "hold": slice._mouse_hold.active,
		"accepted": _accepted_since(marks), "pressed": Input.is_action_pressed(&"move_point"),
	}
	var restarts: int = _log_count("slice restarted")
	_push_key(KEY_F5, true)
	record["call"] = _reading("quick restart", restarts)
	_push_key(KEY_F5, false)
	record["isolated"] = _isolate()
	var window_marks: int = _commands.size()
	record["window"] = await _window(WINDOW_FRAMES)
	record["refused"] = _commands.slice(window_marks).count(REFUSED_STATUS)
	record["held_to_end"] = Input.is_action_pressed(&"move_point")
	Input.parse_input_event(_button_event(screen, MOUSE_BUTTON_LEFT, false))
	record["release"] = await _after_release()
	record["hold_after_release"] = slice._mouse_hold.active
	record["after"] = await _new_click_command()
	_note("route 2: the left button pressed on the ground 4 m ahead through Input.parse_input_event() and held across F5, then released the same way")
	return record


## Route 2, attack: the stick held, then a real right press for Quick Strike, which suspends the held stick; F5
## during the wind-up with both still held.
func _route_quick_strike_over_held_stick() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var record: Dictionary = {}
	await _stage()
	Input.action_press(&"move_vector_forward", 1.0)
	await _settle(12)
	var screen: Vector2 = _screen(_stage_point() + _stage_forward() * CLICK_AHEAD)
	var started: int = player.attack.uses_started
	Input.parse_input_event(_motion_event(screen))
	Input.parse_input_event(_button_event(screen, MOUSE_BUTTON_RIGHT, true))
	for frame: int in 10:
		await process_frame
		if player.attack.phase == QuickStrikeAction.Phase.WINDUP:
			break
	record["before"] = {
		"windup": player.attack.phase == QuickStrikeAction.Phase.WINDUP, "suspended": player.movement_is_suspended_by_attack(),
		"started": player.attack.uses_started - started, "phase": player.attack.phase_name(),
	}
	var released: int = player.attack.uses_released
	var restarts: int = _log_count("slice restarted")
	_push_key(KEY_F5, true)
	record["call"] = _reading("quick restart", restarts)
	_push_key(KEY_F5, false)
	record["isolated"] = _isolate()
	record["window"] = await _window(WINDOW_FRAMES)
	record["released_after"] = player.attack.uses_released - released
	Input.parse_input_event(_button_event(screen, MOUSE_BUTTON_RIGHT, false))
	Input.action_release(&"move_vector_forward")
	record["release"] = await _after_release()
	record["released_after_release"] = player.attack.uses_released - released
	_note("route 2: the stick held, then a real right press through Input.parse_input_event() began a Quick Strike that suspended it; F5 inside the wind-up with both held, then both released")
	return record


## Route 3: a real Graveblade kill, then F5 at the middle of the Fallen delay.
func _route_f5_in_fallen_delay() -> Dictionary:
	var record: Dictionary = await _kill_player()
	if not bool(record["dead"]):
		return record
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var opens: int = overlay.opens
	for frame: int in 120:
		if slice._fallen_countdown > 0.0 and slice._fallen_countdown <= MIDDLE_REMAINING:
			break
		await process_frame
	record["armed"] = slice._fallen_countdown > 0.0 and slice._pending_fallen_event != null and not overlay.is_open and overlay.opens == opens
	var restarts: int = _log_count("slice restarted")
	_push_key(KEY_F5, true)
	record["call"] = _reading("quick restart", restarts)
	_push_key(KEY_F5, false)
	record["isolated"] = _isolate()
	record["window"] = await _window(WINDOW_FRAMES)
	_note("route 3: F5 pushed into the root viewport with no more than %.2f s of the 0.90 s Fallen delay left" % MIDDLE_REMAINING)
	return record


## Route 4: a real Graveblade kill, the overlay opening by itself, and Enter on its focused Restart button.
func _route_fallen_confirm() -> Dictionary:
	var record: Dictionary = await _kill_player()
	if not bool(record["dead"]):
		return record
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	record["opened"] = await _wait_for_overlay()
	var closes: int = overlay.closes
	var opens: int = overlay.opens
	var focused: Control = root.gui_get_focus_owner()
	record["focused"] = focused != null and String(focused.name) == RESTART_CAPTION
	var restarts: int = _log_count("slice restarted")
	_push_key(KEY_ENTER, true)
	record["call"] = _reading("Fallen", restarts)
	record["closed_once"] = not overlay.is_open and overlay.closes == closes + 1 and overlay.opens == opens
	_push_key(KEY_ENTER, false)
	record["isolated"] = _isolate()
	record["window"] = await _window(WINDOW_FRAMES)
	_note("route 4: Enter pushed into the root viewport while the Fallen overlay stood with its Restart button focused")
	return record


## Route 5: a real Graveblade kill, the overlay opening by itself, and one real left click on its Restart button.
func _route_fallen_click() -> Dictionary:
	var record: Dictionary = await _kill_player()
	if not bool(record["dead"]):
		return record
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	record["opened"] = await _wait_for_overlay()
	var closes: int = overlay.closes
	var opens: int = overlay.opens
	var marks: int = _commands.size()
	var restarts: int = _log_count("slice restarted")
	## The click is readable only after the next frame's input flush, and by then the neutral latch has already
	## been lifted, because the click's own release arrived with it. The latch is read where the revival emits
	## `life_changed` — inside the restart, after the latch is set.
	var at_revival: Dictionary = {}
	var on_life: Callable = func(_current: float, _maximum: float) -> void:
		if at_revival.is_empty():
			at_revival["latch"] = slice.player.awaiting_neutral
			at_revival["reason"] = slice.player.neutral_reason
	slice.player.life_changed.connect(on_life)
	record["click"] = await _parse_click(overlay, _named(overlay, RESTART_CAPTION))
	slice.player.life_changed.disconnect(on_life)
	var reading: Dictionary = _reading("Fallen", restarts)
	reading["latch_after_flush"] = reading["latch"]
	reading["latch"] = bool(at_revival.get("latch", false))
	reading["latch_reason"] = String(at_revival.get("reason", ""))
	record["call"] = reading
	record["closed_once"] = not overlay.is_open and overlay.closes == closes + 1 and overlay.opens == opens
	record["commands_at_click"] = _commands.size() - marks
	record["hold_at_click"] = slice._mouse_hold.active
	record["pressed_at_click"] = Input.is_action_pressed(&"move_point")
	record["isolated"] = _isolate()
	record["window"] = await _window(WINDOW_FRAMES)
	record["commands_after"] = _commands.size() - marks
	record["hold_after"] = slice._mouse_hold.active
	_note("route 5: one left press and release through Input.parse_input_event() over the Fallen overlay's Restart button; readable only after the next frame's input flush, so its reading is two process frames after the restart rather than in its own call")
	return record


## One further F5 with both Graveblades exactly where the restart puts them, active.
func _route_with_both_graveblades_present() -> Dictionary:
	var record: Dictionary = {}
	await _stage()
	var restarts: int = _log_count("slice restarted")
	_push_key(KEY_F5, true)
	record["call"] = _reading("quick restart", restarts)
	_push_key(KEY_F5, false)
	record["window"] = await _window(WINDOW_FRAMES)
	var spawns: Array[Vector3] = [slice.broken_watch.first_encounter_spawn(), slice.broken_watch.second_encounter_spawn()]
	var enemies: Array = []
	for index: int in slice.graveblades.size():
		var enemy: PrototypeGraveblade = slice.graveblades[index]
		enemies.append({
			"alive": enemy.is_alive(), "full": enemy.life == enemy.data.max_life, "active": enemy.ai_enabled,
			"aware": enemy.aware, "spawn_gap": _planar_gap(enemy.global_position, spawns[index]),
			"from_entry": _planar_gap(enemy.global_position, slice.broken_watch.entry()),
		})
	record["enemies_after"] = enemies
	record["holder_free_after"] = slice.attack_coordinator.holder() == null
	_quiet()
	_note("one further F5 with neither Graveblade moved or quieted after the restart")
	return record


## STAGED placement, real attacks: the second Graveblade 1.2 m ahead of the character in the Watch Forecourt,
## its own attack begun through its seam until the character falls.
func _kill_player() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var killer: PrototypeGraveblade = slice.graveblades[1]
	await _stage()
	var forward: Vector3 = _stage_forward()
	killer.place_at(_stage_point() + forward * NEAR)
	killer.face_instantly(-forward)
	await _settle(2)
	var trail: Array = [player.life]
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
		for frame: int in 180:
			await physics_frame
			if player.damage_taken_events > taken:
				break
		trail.append(player.life)
	var event: DamageEvent = player.last_damage_taken
	_note("each death: the second Graveblade placed %.1f m ahead of the character in the Watch Forecourt and its own attack begun through begin_attack_for_verification()" % NEAR)
	return {
		"trail": trail, "dead": not player.is_alive(), "from_killer": event != null and event.source == killer,
		"killing_source": FirstMvpFallenOverlay.describe_killing_source(event),
	}


func _wait_for_overlay() -> bool:
	for frame: int in 600:
		if slice.fallen_overlay.is_open:
			break
		await process_frame
	await _await_process_frames(2)
	return slice.fallen_overlay.is_open and paused


## What the restart left, read in its own call: the character, the command it carried, the room and both
## Graveblades.
func _reading(reason: String, restarts_before: int) -> Dictionary:
	var player: PrototypePlayer = slice.player
	var entry: Vector3 = slice.broken_watch.entry()
	var spawns: Array[Vector3] = [slice.broken_watch.first_encounter_spawn(), slice.broken_watch.second_encounter_spawn()]
	var enemies_ok: bool = true
	for index: int in slice.graveblades.size():
		var enemy: PrototypeGraveblade = slice.graveblades[index]
		enemies_ok = (enemies_ok and enemy.is_alive() and enemy.life == enemy.data.max_life and enemy.ai_enabled
			and _planar_gap(enemy.global_position, spawns[index]) < 0.6)
	return {
		"reason": reason,
		"restarted_once": _log_count("slice restarted") == restarts_before + 1 and _last_log("slice restarted").ends_with(reason),
		"gap": _planar_gap(player.global_position, entry),
		"alive": player.is_alive() and player.action_state == PrototypePlayer.ActionState.IDLE,
		"full": player.life == player.max_life and player.mana == player.max_mana,
		"life": player.life, "max_life": player.max_life, "mana": player.mana, "max_mana": player.max_mana,
		"facing": player.facing_direction().dot(_route()),
		"destination": player.has_destination, "agent_gap": _planar_gap(player._agent.target_position, entry),
		"mode": player.movement_mode_name(), "speed": _planar_speed(player), "stick": player.stick_magnitude,
		"latch": player.awaiting_neutral, "latch_reason": player.neutral_reason,
		"attack_ready": player.attack.phase == QuickStrikeAction.Phase.READY, "attack_phase": player.attack.phase_name(),
		"attack_target_null": player.attack.target == null, "buffered": player.attack.buffered, "holding": player.attack.holding,
		"suspended": player.movement_is_suspended_by_attack(),
		"marker_hidden": not slice.marker.visible or slice.marker._fading,
		"soft_target_null": slice._soft_target == null, "holder_free": slice.attack_coordinator.holder() == null,
		"countdown": slice._fallen_countdown, "pending_null": slice._pending_fallen_event == null,
		"enemies": enemies_ok, "overlay_closed": not slice.fallen_overlay.is_open, "paused": paused,
	}


## ISOLATION: both Graveblades quieted and the first placed on Riftfall Landing's player start.
func _isolate() -> Dictionary:
	_quiet()
	var first: PrototypeGraveblade = slice.graveblades[0]
	first.place_at(slice.landing_layout.player_start())
	var entry: Vector3 = slice.broken_watch.entry()
	return {
		"first": _planar_gap(first.global_position, entry),
		"second": _planar_gap(slice.graveblades[1].global_position, entry),
	}


## WINDOW_FRAMES physics frames after the restart, every one sampled.
func _window(frames: int) -> Dictionary:
	var player: PrototypePlayer = slice.player
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var entry: Vector3 = slice.broken_watch.entry()
	var opens: int = overlay.opens
	var restarts: int = _log_count("slice restarted")
	var marks: int = _commands.size()
	var max_gap: float = 0.0
	var max_speed: float = 0.0
	var first_gap: float = -1.0
	var latched: int = 0
	var faults: PackedStringArray = PackedStringArray()
	for frame: int in frames:
		await physics_frame
		var gap: float = _planar_gap(player.global_position, entry)
		if frame == 0:
			first_gap = gap
		max_gap = maxf(max_gap, gap)
		max_speed = maxf(max_speed, _planar_speed(player))
		if player.awaiting_neutral:
			latched += 1
		if (player.has_destination or not player.is_alive() or overlay.is_open or overlay.opens != opens or paused
				or _log_count("slice restarted") != restarts or player.attack.busy() or player.movement_is_suspended_by_attack()
				or player.movement_mode != PrototypePlayer.MovementMode.NONE):
			if faults.size() < 3:
				faults.append("frame %d: destination %s, alive %s, overlay %s (+%d), paused %s, restarts +%d, attack %s, suspended %s, mode %s"
					% [frame + 1, str(player.has_destination), str(player.is_alive()), str(overlay.is_open), overlay.opens - opens,
						str(paused), _log_count("slice restarted") - restarts, player.attack.phase_name(),
						str(player.movement_is_suspended_by_attack()), player.movement_mode_name()])
	return {
		"frames": frames, "first_gap": first_gap, "max_gap": max_gap, "max_speed": max_speed, "latched": latched,
		"faults": faults, "end_gap": _planar_gap(player.global_position, entry), "facing_end": player.facing_direction().dot(_route()),
		"marker_hidden_end": not slice.marker.visible, "accepted": _accepted_since(marks),
		"alive_end": player.is_alive() and player.life == player.max_life and player.mana == player.max_mana,
		"first_end": _planar_gap(slice.graveblades[0].global_position, entry),
	}


## After a held input is released: how many process frames until the latch the revival set is lifted, and
## whether the character is still where the restart put it.
func _after_release() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var frames: int = -1
	for frame: int in 30:
		await process_frame
		if not player.awaiting_neutral:
			frames = frame + 1
			break
	await _settle(10)
	return {"frames": frames, "gap": _planar_gap(player.global_position, slice.broken_watch.entry()),
		"destination": player.has_destination, "speed": _planar_speed(player)}


## A genuinely new click after neutral: the ground 3 m on from the entry, pressed and released.
func _new_click_command() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var marks: int = _commands.size()
	var entry: Vector3 = slice.broken_watch.entry()
	var screen: Vector2 = _screen(entry + _entry_forward() * 3.0)
	Input.parse_input_event(_motion_event(screen))
	Input.parse_input_event(_button_event(screen, MOUSE_BUTTON_LEFT, true))
	Input.parse_input_event(_button_event(screen, MOUSE_BUTTON_LEFT, false))
	await _await_process_frames(2)
	var destination: bool = player.has_destination
	await _settle(NEW_COMMAND_FRAMES)
	return {"accepted": _accepted_since(marks), "destination": destination,
		"moved": _planar_gap(player.global_position, entry), "latch": player.awaiting_neutral}


## A genuinely new stick deflection after neutral.
func _new_stick_command() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var entry: Vector3 = slice.broken_watch.entry()
	Input.action_press(&"move_vector_forward", 1.0)
	await _settle(NEW_COMMAND_FRAMES)
	var moved: float = _planar_gap(player.global_position, entry)
	var mode: String = player.movement_mode_name()
	Input.action_release(&"move_vector_forward")
	await _settle(10)
	return {"moved": moved, "mode": mode}


# --- 6–16. The measurements ------------------------------------------------------------------------

func _check_the_d339_entry_sat_inside_the_cap_and_the_new_entry_is_clear_on_the_mesh_and_reachable() -> void:
	print("")
	print("--- 6. Measured in the running slice: the D-339 entry sat inside a tall Landing solid; the new entry is clear of every solid, on the navigation mesh, and reached by path from Riftfall Landing's player start")
	var old_tall: PackedStringArray = PackedStringArray()
	for hit: Dictionary in _geometry["old_overlaps"] as Array:
		if bool(hit["tall"]):
			old_tall.append("%s %s" % [String(hit["path"]), str(hit["size"])])
	var entry_tall: PackedStringArray = PackedStringArray()
	for hit: Dictionary in _geometry["entry_overlaps"] as Array:
		if bool(hit["tall"]):
			entry_tall.append("%s %s" % [String(hit["path"]), str(hit["size"])])
	var local: Vector2 = _geometry["entry_local"]
	# First-MVP Gameplay J11 (decision D-344) opens Riftfall Landing's Watch Breach far cap IN THIS
	# COMPOSITION, and that cap is the very solid this check used to find the D-339 socket inside. The
	# measurement read the running world rather than a file, so no put-back can restore it. What J10
	# proved is asserted where it is still true: the cap is the ONE Landing boundary mass authored over
	# Broken Watch's rooms, the D-339 socket lies inside its footprint, and the slice removes exactly it
	# — so a capsule at that socket now meets nothing tall and the mesh reaches it. J10's own fix, the
	# moved socket, is asserted unchanged below.
	var authored_cap: Rect2 = Rect2()
	var authored_over_broken_watch: int = 0
	for mass: Dictionary in RiftfallLandingGreyboxLayout.BOUNDARY_MASSES:
		var rect: Rect2 = mass["rect"]
		for room: Rect2 in BrokenWatchLayout.WALKABLE:
			if rect.intersects(room):
				authored_cap = rect
				authored_over_broken_watch += 1
				break
	_expect(authored_over_broken_watch == 1 and authored_cap == Rect2(Vector2(1.0, -34.0), Vector2(8.0, 4.0))
			and authored_cap.has_point(PRE_J10_ENTRY_LOCAL) and old_tall.is_empty()
			and float(_geometry["old_nav_gap"]) <= STABLE_METRES,
		"%d Landing boundary mass(es) stand over Broken Watch; the cap is %s and holds the D-339 entry: %s; a capsule at that entry meets %s and the mesh lies %.4f m from it"
			% [authored_over_broken_watch, str(authored_cap), str(authored_cap.has_point(PRE_J10_ENTRY_LOCAL)), str(old_tall), float(_geometry["old_nav_gap"])])
	_expect(local.distance_to(J10_ENTRY_LOCAL) < 0.001 and entry_tall.is_empty() and float(_geometry["nav_gap"]) <= STABLE_METRES
			and int(_geometry["path_points"]) > 1 and float(_geometry["path_end_gap"]) <= STABLE_METRES,
		"entry() is local %s; its capsule meets %s; the mesh lies %.4f m from it; the path has %d points and ends %.4f m from it"
			% [str(local), str(entry_tall), float(_geometry["nav_gap"]), int(_geometry["path_points"]), float(_geometry["path_end_gap"])])
	print("  the D-339 entry (%.2f, %.2f) lies inside Riftfall Landing's ONE authored boundary mass over Broken Watch — the Watch Breach far cap %s — which First-MVP Gameplay J11 (D-344) now opens in this composition, so a capsule there meets nothing tall and the navigation mesh lies %.4f m from it"
		% [PRE_J10_ENTRY_LOCAL.x, PRE_J10_ENTRY_LOCAL.y, str(authored_cap), float(_geometry["old_nav_gap"])])
	print("  entry() now answers local %s: the same capsule there meets only ground plates, the navigation mesh lies %.4f m from it, and a path from Riftfall Landing's player start reaches it in %d points and %.2f m, ending %.4f m from it"
		% ["(%.2f, %.2f)" % [local.x, local.y], float(_geometry["nav_gap"]), int(_geometry["path_points"]), float(_geometry["path_length"]), float(_geometry["path_end_gap"])])
	_done("the_d339_entry_sat_inside_the_cap_and_the_new_entry_is_clear_on_the_mesh_and_reachable")


func _check_a_real_first_graveblade_kill_keeps_j9s_binding_and_one_drop() -> void:
	print("")
	print("--- 7. J9 stands: a real first-Graveblade kill is counted as that Graveblade, bound into its one connection, and places one Watchsteel drop")
	var heard: Array = _kill["heard"]
	var one: Dictionary = heard[0] if heard.size() == 1 else {}
	var connections: Array = _kill["connections"]
	var bound: Dictionary = connections[0] if connections.size() == 1 else {}
	_expect(bool(_kill["dead"]) and _floats(_kill["trail"]) == "300 -> 200 -> 100 -> 0"
			and int(one.get("source_id", 0)) == _player_id and int(one.get("target_id", 0)) == _first_id
			and int(bound.get("count", -1)) == 1 and (bound.get("bound", []) as Array) == [_first_id]
			and (_kill["rewarded"] as Array) == [_first_id] and bool(_kill["granted"]) and int(_kill["drops"]) == 1,
		"trail %s; heard %s; connection %s; rewarded %s; latch %s; drops %d"
			% [_floats(_kill["trail"]), str(heard), str(connections), str(_kill["rewarded"]), str(_kill["granted"]), int(_kill["drops"])])
	print("  %d real Quick Strikes at %.0f damage took the first Graveblade %s; its died reached the slice's %s() through the one connection, with 1 bound argument — the first Graveblade itself"
		% [(_kill["trail"] as Array).size() - 1, float(_kill["damage"]), _floats(_kill["trail"]), CALLBACK])
	print("  the event named the player as source and the first Graveblade as target; the rewarded set holds the first Graveblade's id and not the player's; the latch is set and 1 drop was created")
	_done("a_real_first_graveblade_kill_keeps_j9s_binding_and_one_drop")


## Every fault the in-call reading shows.
func _call_faults(r: Dictionary) -> PackedStringArray:
	var f: PackedStringArray = PackedStringArray()
	if r.is_empty():
		f.append("no reading")
		return f
	if not bool(r["restarted_once"]):
		f.append("not exactly one restart for '%s'" % String(r["reason"]))
	if float(r["gap"]) > STABLE_METRES:
		f.append("%.4f m from the entry at the reading" % float(r["gap"]))
	if not bool(r["alive"]) or not bool(r["full"]):
		f.append("not alive and IDLE at full Life and Mana")
	if float(r["facing"]) < 0.9999:
		f.append("facing %.4f of the route" % float(r["facing"]))
	if bool(r["destination"]) or float(r["agent_gap"]) > STABLE_METRES or String(r["mode"]) != "none":
		f.append("a movement command survived: destination %s, the agent's target %.2f m from the entry, mode '%s'"
			% [str(r["destination"]), float(r["agent_gap"]), String(r["mode"])])
	if float(r["speed"]) > STILL_SPEED:
		f.append("planar speed %.4f m/s" % float(r["speed"]))
	if not bool(r["latch"]) or String(r["latch_reason"]) != ENCOUNTER_RESET:
		f.append("neutral latch %s '%s'" % [str(r["latch"]), String(r["latch_reason"])])
	if not bool(r["attack_ready"]) or not bool(r["attack_target_null"]) or bool(r["buffered"]) or bool(r["holding"]):
		f.append("the attack survived: %s, target %s, buffered %s, holding %s"
			% [String(r["attack_phase"]), "none" if bool(r["attack_target_null"]) else "held", str(r["buffered"]), str(r["holding"])])
	if bool(r["suspended"]):
		f.append("a movement suspension survived")
	if not bool(r["marker_hidden"]):
		f.append("the destination marker is shown")
	if not bool(r["soft_target_null"]) or not bool(r["holder_free"]):
		f.append("a soft target or attack permission is held")
	if float(r["countdown"]) != -1.0 or not bool(r["pending_null"]):
		f.append("a Fallen is still armed")
	if not bool(r["enemies"]):
		f.append("a Graveblade is not back at its spawn, alive, full and active")
	if not bool(r["overlay_closed"]) or bool(r["paused"]):
		f.append("an overlay is open or the tree is paused")
	return f


## Every fault the stability window shows.
func _window_faults(w: Dictionary) -> PackedStringArray:
	var f: PackedStringArray = PackedStringArray()
	if w.is_empty():
		f.append("no window")
		return f
	if float(w["max_gap"]) > STABLE_METRES:
		f.append("%.4f m from the entry at most over %d physics frames (%.4f m on the first, %.4f m at the end)"
			% [float(w["max_gap"]), int(w["frames"]), float(w["first_gap"]), float(w["end_gap"])])
	if float(w["max_speed"]) > STILL_SPEED:
		f.append("planar speed up to %.4f m/s" % float(w["max_speed"]))
	f.append_array(w["faults"] as PackedStringArray)
	if int(w["accepted"]) != 0:
		f.append("%d movement command(s) accepted during the window" % int(w["accepted"]))
	if not bool(w["marker_hidden_end"]) or float(w["facing_end"]) < 0.9999 or not bool(w["alive_end"]):
		f.append("at the end: marker hidden %s, facing %.4f, alive at full %s"
			% [str(w["marker_hidden_end"]), float(w["facing_end"]), str(w["alive_end"])])
	return f


func _isolation_faults(i: Dictionary) -> PackedStringArray:
	var f: PackedStringArray = PackedStringArray()
	if i.is_empty() or float(i["first"]) < ISOLATION_METRES:
		f.append("the first Graveblade was not isolated: %s" % str(i))
	return f


func _route_record(key: String) -> Dictionary:
	return _routes.get(key, {}) as Dictionary


func _call_text(r: Dictionary) -> String:
	return "%.4f m from the entry, alive and IDLE at %s / %s Life and %s / %s Mana, facing the route; no destination, the agent's target %.4f m from the entry, no movement mode, planar speed %.4f m/s; no attack in progress, buffered or held, and no suspension; the marker hidden; the neutral latch set as '%s'; no Fallen armed; both Graveblades back at their spawns, alive and active" % [
		float(r["gap"]), _n(float(r["life"])), _n(float(r["max_life"])), _n(float(r["mana"])), _n(float(r["max_mana"])),
		float(r["agent_gap"]), float(r["speed"]), String(r["latch_reason"])]


func _window_text(w: Dictionary) -> String:
	return "over %d physics frames at most %.4f m from the entry and %.4f m/s, %.4f m at the end; no destination, restart, Fallen or attack; the marker hidden and the character facing the route at full Life at the end" % [
		int(w["frames"]), float(w["max_gap"]), float(w["max_speed"]), float(w["end_gap"])]


func _check_route_1_f5_with_an_active_click_destination() -> void:
	print("")
	print("--- 8. Route 1: F5 while the living character walks to a real click destination")
	var record: Dictionary = _route_record("1")
	var before: Dictionary = record.get("before", {})
	var after: Dictionary = record.get("after", {})
	var faults: PackedStringArray = PackedStringArray()
	if not (bool(before.get("destination", false)) and bool(before.get("moving", false)) and int(before.get("accepted", 0)) == 1):
		faults.append("staging: the click did not set the character walking: %s" % str(before))
	faults.append_array(_call_faults(record.get("call", {})))
	faults.append_array(_isolation_faults(record.get("isolated", {})))
	faults.append_array(_window_faults(record.get("window", {})))
	if not (int(after.get("accepted", 0)) == 1 and bool(after.get("destination", false)) and float(after.get("moved", 0.0)) > NEW_COMMAND_METRES):
		faults.append("a new click after neutral did not move the character: %s" % str(after))
	_expect(faults.is_empty(), "route 1: %s" % "; ".join(faults))
	if faults.is_empty():
		print("  route 1: staged walking to a click destination %.1f m ahead: the destination held and the character moving" % CLICK_AHEAD)
		print("  route 1: in F5's own call: %s" % _call_text(record["call"]))
		print("  route 1: isolated, the first Graveblade %.1f m from the entry: %s" % [float((record["isolated"] as Dictionary)["first"]), _window_text(record["window"])])
		print("  route 1: after neutral, a new click 3.0 m on was accepted and moved the character more than %.2f m in %d physics frames" % [NEW_COMMAND_METRES, NEW_COMMAND_FRAMES])
	_done("route_1_f5_with_an_active_click_destination")


func _check_route_2_f5_with_the_stick_held() -> void:
	print("")
	print("--- 9. Route 2: F5 with the left stick held forward; the held stick is refused until it returns to neutral")
	var record: Dictionary = _route_record("2a")
	var before: Dictionary = record.get("before", {})
	var window: Dictionary = record.get("window", {})
	var release: Dictionary = record.get("release", {})
	var after: Dictionary = record.get("after", {})
	var faults: PackedStringArray = PackedStringArray()
	if not bool(before.get("moving", false)):
		faults.append("staging: the held stick did not move the character: %s" % str(before))
	faults.append_array(_call_faults(record.get("call", {})))
	faults.append_array(_isolation_faults(record.get("isolated", {})))
	faults.append_array(_window_faults(window))
	if int(window.get("latched", 0)) != WINDOW_FRAMES:
		faults.append("the neutral latch was lifted while the stick was still held: %d of %d frames latched" % [int(window.get("latched", 0)), WINDOW_FRAMES])
	if not (int(release.get("frames", -1)) >= 1 and float(release.get("gap", 9.0)) <= STABLE_METRES and not bool(release.get("destination", true))):
		faults.append("after the stick's release: %s" % str(release))
	if not (float(after.get("moved", 0.0)) > NEW_COMMAND_METRES and String(after.get("mode", "")) == "controller direct"):
		faults.append("a new deflection after neutral did not move the character: %s" % str(after))
	_expect(faults.is_empty(), "route 2, stick: %s" % "; ".join(faults))
	if faults.is_empty():
		print("  route 2, stick: staged with the stick held forward and the character moving")
		print("  route 2, stick: in F5's own call: %s" % _call_text(record["call"]))
		print("  route 2, stick: isolated, the first Graveblade %.1f m from the entry, the stick still held: %s; the latch held on all %d frames" % [float((record["isolated"] as Dictionary)["first"]), _window_text(window), WINDOW_FRAMES])
		print("  route 2, stick: released: the latch lifted within %d process frame(s), the character still %.4f m from the entry; a new deflection then moved it more than %.2f m in %d physics frames, in controller direct mode"
			% [int(release["frames"]), float(release["gap"]), NEW_COMMAND_METRES, NEW_COMMAND_FRAMES])
	_done("route_2_f5_with_the_stick_held")


func _check_route_2_f5_with_the_left_button_held() -> void:
	print("")
	print("--- 10. Route 2: F5 with the left button held on the ground; every held re-issue is refused until the button is released")
	var record: Dictionary = _route_record("2b")
	var before: Dictionary = record.get("before", {})
	var window: Dictionary = record.get("window", {})
	var release: Dictionary = record.get("release", {})
	var after: Dictionary = record.get("after", {})
	var faults: PackedStringArray = PackedStringArray()
	if not (bool(before.get("destination", false)) and bool(before.get("moving", false)) and bool(before.get("hold", false)) and bool(before.get("pressed", false))):
		faults.append("staging: the held button did not set the character walking: %s" % str(before))
	faults.append_array(_call_faults(record.get("call", {})))
	faults.append_array(_isolation_faults(record.get("isolated", {})))
	faults.append_array(_window_faults(window))
	if int(window.get("latched", 0)) != WINDOW_FRAMES or int(record.get("refused", 0)) < 1 or not bool(record.get("held_to_end", false)):
		faults.append("while held: %d of %d frames latched, %d re-issue(s) refused, held to the end %s"
			% [int(window.get("latched", 0)), WINDOW_FRAMES, int(record.get("refused", 0)), str(record.get("held_to_end", false))])
	if not (int(release.get("frames", -1)) >= 1 and float(release.get("gap", 9.0)) <= STABLE_METRES and not bool(release.get("destination", true))
			and not bool(record.get("hold_after_release", true))):
		faults.append("after the button's release: %s, hold %s" % [str(release), str(record.get("hold_after_release", true))])
	if not (int(after.get("accepted", 0)) == 1 and bool(after.get("destination", false)) and float(after.get("moved", 0.0)) > NEW_COMMAND_METRES):
		faults.append("a new click after neutral did not move the character: %s" % str(after))
	_expect(faults.is_empty(), "route 2, left button: %s" % "; ".join(faults))
	if faults.is_empty():
		print("  route 2, left button: staged with the left button held on the ground %.1f m ahead: the hold re-issuing, the destination held and the character moving" % CLICK_AHEAD)
		print("  route 2, left button: in F5's own call: %s" % _call_text(record["call"]))
		print("  route 2, left button: isolated, the first Graveblade %.1f m from the entry, the button still held: %s; the latch held on all %d frames and every held re-issue was refused as '%s'"
			% [float((record["isolated"] as Dictionary)["first"]), _window_text(window), WINDOW_FRAMES, REFUSED_STATUS])
		print("  route 2, left button: released: the hold ended and the latch lifted within %d process frame(s), the character still %.4f m from the entry; a new click then moved it more than %.2f m in %d physics frames"
			% [int(release["frames"]), float(release["gap"]), NEW_COMMAND_METRES, NEW_COMMAND_FRAMES])
	_done("route_2_f5_with_the_left_button_held")


func _check_route_2_f5_during_a_quick_strike_that_suspended_a_held_stick() -> void:
	print("")
	print("--- 11. Route 2: F5 inside a real Quick Strike's wind-up that suspended a held stick; nothing of the attack or the suspension survives")
	var record: Dictionary = _route_record("2c")
	var before: Dictionary = record.get("before", {})
	var release: Dictionary = record.get("release", {})
	var faults: PackedStringArray = PackedStringArray()
	if not (bool(before.get("windup", false)) and bool(before.get("suspended", false)) and int(before.get("started", 0)) == 1):
		faults.append("staging: the right press did not begin a wind-up over a suspended stick: %s" % str(before))
	faults.append_array(_call_faults(record.get("call", {})))
	faults.append_array(_isolation_faults(record.get("isolated", {})))
	faults.append_array(_window_faults(record.get("window", {})))
	if int(record.get("released_after", -1)) != 0 or int(record.get("released_after_release", -1)) != 0:
		faults.append("the interrupted Quick Strike released %d time(s) in the window and %d by the end"
			% [int(record.get("released_after", -1)), int(record.get("released_after_release", -1))])
	if not (int(release.get("frames", -1)) >= 1 and float(release.get("gap", 9.0)) <= STABLE_METRES and not bool(release.get("destination", true))):
		faults.append("after both releases: %s" % str(release))
	_expect(faults.is_empty(), "route 2, attack: %s" % "; ".join(faults))
	if faults.is_empty():
		print("  route 2, attack: staged with the stick held, then one real right press: a Quick Strike in its wind-up, the held stick suspended")
		print("  route 2, attack: in F5's own call: %s" % _call_text(record["call"]))
		print("  route 2, attack: isolated, the first Graveblade %.1f m from the entry, the stick and the right button still held: %s; the interrupted Quick Strike never released"
			% [float((record["isolated"] as Dictionary)["first"]), _window_text(record["window"])])
		print("  route 2, attack: released: the latch lifted within %d process frame(s), the character still %.4f m from the entry, and no Quick Strike released" % [int(release["frames"]), float(release["gap"])])
	_done("route_2_f5_during_a_quick_strike_that_suspended_a_held_stick")


func _check_route_3_f5_inside_the_fallen_delay() -> void:
	print("")
	print("--- 12. Route 3: F5 inside the Fallen delay after a real Graveblade kill; Fallen never opens")
	var record: Dictionary = _route_record("3")
	var faults: PackedStringArray = _death_faults(record)
	if not bool(record.get("armed", false)):
		faults.append("staging: the Fallen delay was not armed and waiting when F5 arrived")
	faults.append_array(_call_faults(record.get("call", {})))
	faults.append_array(_isolation_faults(record.get("isolated", {})))
	faults.append_array(_window_faults(record.get("window", {})))
	_expect(faults.is_empty(), "route 3: %s" % "; ".join(faults))
	if faults.is_empty():
		print("  route 3: %d real Graveblade Hits took Life %s — \"%s\" — and the delay was armed and waiting" % [(record["trail"] as Array).size() - 1, _floats(record["trail"]), String(record["killing_source"])])
		print("  route 3: in F5's own call: %s" % _call_text(record["call"]))
		print("  route 3: isolated, the first Graveblade %.1f m from the entry: %s — longer than the delay and the fade together, and Fallen never opened"
			% [float((record["isolated"] as Dictionary)["first"]), _window_text(record["window"])])
	_done("route_3_f5_inside_the_fallen_delay")


func _check_route_4_fallen_restart_by_keyboard_confirm() -> void:
	print("")
	print("--- 13. Route 4: the Fallen overlay's Restart, by Enter on its focused button")
	var record: Dictionary = _route_record("4")
	var faults: PackedStringArray = _death_faults(record)
	if not (bool(record.get("opened", false)) and bool(record.get("focused", false))):
		faults.append("staging: the overlay did not stand, paused, with Restart focused")
	if not bool(record.get("closed_once", false)):
		faults.append("the overlay did not close exactly once")
	faults.append_array(_call_faults(record.get("call", {})))
	faults.append_array(_isolation_faults(record.get("isolated", {})))
	faults.append_array(_window_faults(record.get("window", {})))
	_expect(faults.is_empty(), "route 4: %s" % "; ".join(faults))
	if faults.is_empty():
		print("  route 4: %d real Graveblade Hits took Life %s; the overlay opened by itself, paused, with \"%s\" focused" % [(record["trail"] as Array).size() - 1, _floats(record["trail"]), RESTART_CAPTION])
		print("  route 4: Enter: the overlay closed once and in the restart's own call: %s" % _call_text(record["call"]))
		print("  route 4: isolated, the first Graveblade %.1f m from the entry: %s" % [float((record["isolated"] as Dictionary)["first"]), _window_text(record["window"])])
	_done("route_4_fallen_restart_by_keyboard_confirm")


func _check_route_5_fallen_restart_by_a_real_left_click() -> void:
	print("")
	print("--- 14. Route 5: the Fallen overlay's Restart, by one real left click; the overlay takes the click and nothing of it reaches the world")
	var record: Dictionary = _route_record("5")
	var click: Dictionary = record.get("click", {})
	var faults: PackedStringArray = _death_faults(record)
	if not bool(record.get("opened", false)):
		faults.append("staging: the overlay did not stand, paused")
	if not (bool(click.get("under", false)) and int(click.get("fired", 0)) == 1 and int(click.get("others", 1)) == 0):
		faults.append("the click was not one press on the Restart button: %s" % str(click))
	if not bool(record.get("closed_once", false)):
		faults.append("the overlay did not close exactly once")
	if (int(record.get("commands_at_click", 1)) != 0 or int(record.get("commands_after", 1)) != 0 or bool(record.get("hold_at_click", true))
			or bool(record.get("hold_after", true)) or bool(record.get("pressed_at_click", true))):
		faults.append("the click reached the world: %d command(s) at the click and %d by the end, hold %s / %s, move_point held %s"
			% [int(record.get("commands_at_click", 1)), int(record.get("commands_after", 1)), str(record.get("hold_at_click", true)),
				str(record.get("hold_after", true)), str(record.get("pressed_at_click", true))])
	faults.append_array(_call_faults(record.get("call", {})))
	faults.append_array(_isolation_faults(record.get("isolated", {})))
	faults.append_array(_window_faults(record.get("window", {})))
	_expect(faults.is_empty(), "route 5: %s" % "; ".join(faults))
	if faults.is_empty():
		print("  route 5: %d real Graveblade Hits took Life %s; the overlay opened by itself, paused" % [(record["trail"] as Array).size() - 1, _floats(record["trail"])])
		print("  route 5: one left press and release through Input.parse_input_event(): one pressed, on \"%s\", and on no other button; the overlay closed once" % RESTART_CAPTION)
		print("  route 5: two process frames after the restart: %s — the latch read at the revival, inside the restart; by the flush it was %s, the click's release having already arrived"
			% [_call_text(record["call"]), "still set" if bool((record["call"] as Dictionary)["latch_after_flush"]) else "lifted"])
		print("  route 5: isolated, the first Graveblade %.1f m from the entry: %s; no movement command was issued, refused or accepted from the click to the end, the mouse hold never started and move_point was never held"
			% [float((record["isolated"] as Dictionary)["first"]), _window_text(record["window"])])
	_done("route_5_fallen_restart_by_a_real_left_click")


func _death_faults(record: Dictionary) -> PackedStringArray:
	var f: PackedStringArray = PackedStringArray()
	if not (bool(record.get("dead", false)) and bool(record.get("from_killer", false)) and _floats(record.get("trail", [])) == "500 -> 375 -> 250 -> 125 -> 0"
			and String(record.get("killing_source", "")) == "Graveblade — Melee Hit — 125 Physical Damage"):
		f.append("staging: the character was not killed by the Graveblade's four Hits: %s, %s" % [_floats(record.get("trail", [])), String(record.get("killing_source", ""))])
	return f


func _check_a_restart_with_both_graveblades_present_resets_both_and_the_player_stays() -> void:
	print("")
	print("--- 15. With both Graveblades exactly where the restart put them, active: both are reset and the character stays")
	var record: Dictionary = _route_record("both")
	var faults: PackedStringArray = PackedStringArray()
	faults.append_array(_call_faults(record.get("call", {})))
	faults.append_array(_window_faults(record.get("window", {})))
	var words: PackedStringArray = PackedStringArray()
	for entry: Variant in record.get("enemies_after", []) as Array:
		var enemy: Dictionary = entry
		words.append("%.2f m" % float(enemy["from_entry"]))
		if not (bool(enemy["alive"]) and bool(enemy["full"]) and bool(enemy["active"]) and not bool(enemy["aware"]) and float(enemy["spawn_gap"]) < 0.6):
			faults.append("a Graveblade after the window: %s" % str(enemy))
	if (record.get("enemies_after", []) as Array).size() != 2 or not bool(record.get("holder_free_after", false)):
		faults.append("the Graveblades or the permission after the window: %s" % str(record.get("enemies_after", [])))
	_expect(faults.is_empty(), "both Graveblades present: %s" % "; ".join(faults))
	if faults.is_empty():
		print("  both Graveblades present: in F5's own call: %s" % _call_text(record["call"]))
		print("  both Graveblades present: nothing moved or quieted after it: %s" % _window_text(record["window"]))
		print("  both Graveblades present: at the end both Graveblades still stood at their spawns — %s from the entry — alive, at full Life, active and unaware, and no attack permission was held" % " and ".join(words))
	_done("a_restart_with_both_graveblades_present_resets_both_and_the_player_stays")


func _check_every_restart_kept_the_drop_latch_and_j9s_rewarded_set() -> void:
	print("")
	print("--- 16. Across every restart above, the guaranteed drop, its latch and J9's rewarded set are unchanged")
	var restarts: int = _log_count("slice restarted")
	_expect(not _latch_start.is_empty() and _latch_end == _latch_start and int(_latch_start["drop_id"]) != 0 and bool(_latch_start["granted"])
			and int(_latch_start["drops"]) == 1 and (_latch_start["rewarded"] as Array) == [_first_id] and int(_latch_start["placed"]) == 1
			and int(_latch_start["refused"]) == 0 and restarts == 8,
		"before %s; after %s; %d restarts" % [str(_latch_start), str(_latch_end), restarts])
	print("  %d restarts, 1 drop created and 1 placement line; the same drop still lies there, the latch is set, the rewarded set is still [the first Graveblade's id], and no reward was refused" % restarts)
	_done("every_restart_kept_the_drop_latch_and_j9s_rewarded_set")


# --- 17–18. The roguelite and Gate 1E ------------------------------------------------------------

func _play_the_core_loop() -> void:
	slice = null
	var loop: RogueliteCoreLoopRuntime = await _load(CORE_LOOP_SCENE) as RogueliteCoreLoopRuntime
	if loop == null:
		return
	await _await_navigation(loop)
	for enemy: PrototypeGraveblade in loop.graveblades:
		enemy.set_ai_enabled(false)
	var player: PrototypePlayer = loop.player
	var hub_entry: Vector3 = loop.hub_module.entry_point()
	var at_load: float = _planar_gap(player.global_position, hub_entry)
	var run_before: String = loop.plan.run_id()
	var ended: int = _count(loop, "run ended")
	var resets: int = _count(loop, "run reset")
	var forward: Vector3 = loop.route_forward()
	player.global_position = hub_entry + forward * 3.0
	player.velocity = Vector3.ZERO
	player.clear_movement_intent("verification", false)
	player.face_instantly(forward)
	await _settle(3)
	var away: float = _planar_gap(player.global_position, hub_entry)
	_push_key(KEY_F5, true)
	var call_gap: float = _planar_gap(player.global_position, hub_entry)
	var call_state: Dictionary = {
		"ended": _count(loop, "run ended") - ended, "resets": _count(loop, "run reset") - resets,
		"hub": loop.loop_state == RogueliteCoreLoopRuntime.LoopState.HUB, "advanced": loop.plan.run_id() != run_before,
		"alive": player.is_alive() and player.life == player.max_life, "destination": player.has_destination,
	}
	_push_key(KEY_F5, false)
	var max_gap: float = 0.0
	var max_speed: float = 0.0
	for frame: int in WINDOW_FRAMES:
		await physics_frame
		max_gap = maxf(max_gap, _planar_gap(player.global_position, hub_entry))
		max_speed = maxf(max_speed, _planar_speed(player))
	var watch_nodes: int = 0
	for node: Node in loop.find_children("*", "", true, false):
		if node is BrokenWatchLayout or node is RiftfallLandingGreyboxLayout:
			watch_nodes += 1
	_loop = {
		"at_load": at_load, "away": away, "call_gap": call_gap, "call": call_state, "max_gap": max_gap, "max_speed": max_speed,
		"broken_watch_null": loop.broken_watch == null and loop.landing_layout == null, "watch_nodes": watch_nodes,
		"run_before": run_before, "run_after": loop.plan.run_id(), "ended_total": _count(loop, "run ended") - ended,
	}
	_note("the Roguelite Core Loop's own scene loaded as it ships; its character stood 3 m into the Nexus, then F5 pushed into the root viewport")


func _check_the_roguelite_core_loop_keeps_its_own_reset() -> void:
	print("")
	print("--- 17. The Roguelite Core Loop, loaded as it ships: its own override still answers F5, returning the character to the Nexus entry, and no Broken Watch exists there")
	var call: Dictionary = _loop["call"]
	_expect(float(_loop["at_load"]) <= STABLE_METRES and float(_loop["away"]) > 2.0 and float(_loop["call_gap"]) <= STABLE_METRES
			and int(call["ended"]) == 1 and int(call["resets"]) == 1 and bool(call["hub"]) and bool(call["advanced"]) and bool(call["alive"])
			and not bool(call["destination"]) and int(_loop["ended_total"]) == 1
			and float(_loop["max_gap"]) <= STABLE_METRES and float(_loop["max_speed"]) <= STILL_SPEED
			and bool(_loop["broken_watch_null"]) and int(_loop["watch_nodes"]) == 0,
		"loop %s" % str(_loop))
	print("  F5 with the character %.2f m into the Nexus: 'run ended' and 'run reset' once each, the plan advanced once, the loop in HUB; in the call the character stood %.4f m from the Nexus entry, alive at full Life, with no destination"
		% [float(_loop["away"]), float(_loop["call_gap"])])
	print("  over %d physics frames at most %.4f m from the Nexus entry and %.4f m/s — the core loop's own _place_player_at() teleport, as before" % [WINDOW_FRAMES, float(_loop["max_gap"]), float(_loop["max_speed"])])
	print("  broken_watch and landing_layout are null and no node of either layout class exists in its tree: Broken Watch's socket cannot reach this scene")
	_done("the_roguelite_core_loop_keeps_its_own_reset")


func _check_gate_1e_inherits_by_structure_only_and_is_not_run() -> void:
	print("")
	print("--- 18. Gate 1E inherits both changes by structure only; its scene is not run here and nothing of it is measured")
	var code: String = _bare(FileAccess.get_file_as_string(OPENING_SCRIPT))
	var restart: PackedStringArray = _code_lines(_function_body(code, "restart_current_slice"))
	_expect(code.contains("extends BrokenWatchSlice") and not restart.is_empty() and restart[0] == "super.restart_current_slice(reason)"
			and _function_body(code, "_spawn_for_milestone").contains("return broken_watch.entry()") and _opening_nodes == 0,
		"extends %s; restart %s; the scene entered the tree %d time(s)" % [str(code.contains("extends BrokenWatchSlice")), str(restart.slice(0, 1)), _opening_nodes])
	print("  canonical_opening_runtime.gd extends BrokenWatchSlice and its restart_current_slice() calls super first, so it runs the clearing and returns to the moved socket; _spawn_for_milestone() continues a BROKEN_WATCH character at broken_watch.entry()")
	print("  structural only: Gate 1E's scene never entered the tree in this run, and nothing of Gate 1E is measured here")
	_done("gate_1e_inherits_by_structure_only_and_is_not_run")


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


# --- Readings --------------------------------------------------------------------------------------

## Every connection of `enemy`'s died to the slice's callback: how many arguments it carries bound, and each
## bound argument — an Object by its instance id.
func _bound_connections(enemy: PrototypeGraveblade) -> Array:
	var found: Array = []
	for connection: Dictionary in enemy.died.get_connections():
		var callable: Callable = connection["callable"]
		if callable.get_method() != CALLBACK:
			continue
		var bound: Array = []
		for value: Variant in callable.get_bound_arguments():
			bound.append((value as Object).get_instance_id() if value is Object else value)
		found.append({"count": callable.get_bound_arguments_count(), "bound": bound})
	return found


## Every shape a capsule the player's size, standing at `at`, overlaps on the player's own collision mask.
func _overlaps(at: Vector3) -> Array:
	var shape: CapsuleShape3D = CapsuleShape3D.new()
	shape.radius = CAPSULE_RADIUS
	shape.height = 1.8
	var query: PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
	query.shape = shape
	query.transform = Transform3D(Basis.IDENTITY, Vector3(at.x, 0.9, at.z))
	query.collision_mask = slice.player.collision_mask
	query.exclude = [slice.player.get_rid()]
	var found: Array = []
	for hit: Dictionary in slice.get_world_3d().direct_space_state.intersect_shape(query, 16):
		var body: CollisionObject3D = hit["collider"] as CollisionObject3D
		var size: Vector3 = Vector3.ZERO
		var path: String = "?"
		if body != null:
			path = str(body.get_path())
			var owner: CollisionShape3D = body.shape_owner_get_owner(body.shape_find_owner(int(hit["shape"]))) as CollisionShape3D
			if owner != null and owner.shape is BoxShape3D:
				size = (owner.shape as BoxShape3D).size
		found.append({"path": path, "size": size, "tall": size == Vector3.ZERO or size.y > 0.3})
	return found


func _rect_distance(rect: Rect2, point: Vector2) -> float:
	var dx: float = maxf(maxf(rect.position.x - point.x, 0.0), point.x - rect.end.x)
	var dy: float = maxf(maxf(rect.position.y - point.y, 0.0), point.y - rect.end.y)
	return Vector2(dx, dy).length()


func _input_action_count(project: String) -> int:
	var inside: bool = false
	var count: int = 0
	for line: String in project.split("\n"):
		if line.begins_with("["):
			inside = line == "[input]"
			continue
		if inside and RegEx.create_from_string("^[A-Za-z_0-9]+=").search(line) != null:
			count += 1
	return count


func _accepted_since(mark: int) -> int:
	var count: int = 0
	for status: String in _commands.slice(mark):
		if status == "accepted" or status == "adjusted":
			count += 1
	return count


func _sorted(values: Array) -> Array:
	var copy: Array = values.duplicate()
	copy.sort()
	return copy


func _floats(values: Variant) -> String:
	var words: PackedStringArray = PackedStringArray()
	for value: Variant in values as Array:
		words.append(_n(float(value)))
	return " -> ".join(words)


func _n(value: float) -> String:
	if is_equal_approx(value, roundf(value)):
		return "%d" % roundi(value)
	return "%.2f" % value


func _planar_gap(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()


func _planar_speed(body: CharacterBody3D) -> float:
	return Vector2(body.velocity.x, body.velocity.z).length()


func _log_count(token: String) -> int:
	return _count(slice, token)


func _count(room: BrokenWatchSlice, token: String) -> int:
	var count: int = 0
	for line: String in room.log_lines:
		if line.contains(token):
			count += 1
	return count


func _last_log(token: String) -> String:
	for index: int in range(slice.log_lines.size() - 1, -1, -1):
		if slice.log_lines[index].contains(token):
			return slice.log_lines[index]
	return ""


func _on_node_added(node: Node) -> void:
	if node is CanonicalOpeningRuntime:
		_opening_nodes += 1


# --- The world -----------------------------------------------------------------------------------

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


func _await_navigation(room: BrokenWatchSlice) -> void:
	for frame: int in 900:
		if NavigationServer3D.map_get_iteration_id(room.navigation_map()) > 0:
			break
		await physics_frame
	await _settle(10)


func _route() -> Vector3:
	var facing: Vector3 = slice.route_forward()
	facing.y = 0.0
	return facing.normalized()


func _stage_point() -> Vector3:
	return slice.landing_layout.global_transform * Vector3(STAGE_LOCAL.x, 0.0, STAGE_LOCAL.y)


## Riftfall Landing's local -Z in the world: the way its route runs.
func _stage_forward() -> Vector3:
	var forward: Vector3 = slice.landing_layout.global_transform.basis * Vector3(0.0, 0.0, -1.0)
	forward.y = 0.0
	return forward.normalized()


## Broken Watch's local -Z in the world: the way its rooms run from the entry.
func _entry_forward() -> Vector3:
	var forward: Vector3 = slice.broken_watch.global_transform.basis * Vector3(0.0, 0.0, -1.0)
	forward.y = 0.0
	return forward.normalized()


## STAGED: the character stood at the Watch Forecourt point facing up the route, every intent cleared through
## the production authority, the camera put on it, both Graveblades quieted.
func _stage() -> void:
	await _until_neutral()
	_quiet()
	_stand_facing(_stage_point(), _stage_forward())
	slice.camera_rig.set_target(slice.player)
	await _settle(2)
	await _await_process_frames(2)


func _stand_facing(at: Vector3, facing: Vector3) -> void:
	slice.player.global_position = Vector3(at.x, 0.0, at.z)
	slice.player.velocity = Vector3.ZERO
	slice.player.clear_movement_intent("verification", false)
	slice.camera_rig.focus = slice.player.global_position
	slice.player.face_instantly(facing)


func _quiet() -> void:
	for enemy: PrototypeGraveblade in slice.graveblades:
		enemy.set_ai_enabled(false)


func _until_neutral() -> void:
	for frame: int in 60:
		if not slice.player.awaiting_neutral:
			return
		await physics_frame


func _note(text: String) -> void:
	if not _staged.has(text):
		_staged.append(text)


func _argument_value(flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


func _named(panel: Control, node_name: String) -> Button:
	for node: Node in panel.find_children(node_name, "Button", true, false):
		return node as Button
	_failures.append("no button named %s in %s" % [node_name, panel.name])
	return null


# --- The pointer and the keyboard -----------------------------------------------------------------

func _screen(world: Vector3) -> Vector2:
	return slice.camera_rig.camera.unproject_position(world)


## Window coordinates for a point in the viewport's own space: the stretch transform, applied the way the
## operating system's pointer arrives through it.
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


## One real left click on `button` through `Input.parse_input_event()`, the path the operating system's own
## events take; it is delivered at the next frame's input flush.
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


## Counts `pressed` on every button in `panel`. The production connections stay exactly as they are; this only
## listens beside them.
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


func _push_key(keycode: Key, pressed: bool) -> void:
	var event: InputEventKey = InputEventKey.new()
	event.keycode = keycode
	event.physical_keycode = keycode
	event.pressed = pressed
	root.push_input(event)


func _settle(frames: int) -> void:
	for frame: int in frames:
		await physics_frame


func _await_process_frames(frames: int) -> void:
	for frame: int in frames:
		await process_frame


# --- Source readings -------------------------------------------------------------------------------

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


## Code with every comment line removed, string literals kept.
func _uncommented(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


## Code with every comment line removed and every string literal emptied.
func _bare(source: String) -> String:
	var strings: RegEx = RegEx.create_from_string("\"([^\"\\\\]|\\\\.)*\"")
	return strings.sub(_uncommented(source), "\"\"", true)


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


func _done(check_name: String) -> void:
	_reached[check_name] = true
