extends SceneTree
## First-MVP Gameplay J9 — Gate 1D Guaranteed-Drop Defeated-Enemy Binding V1: automated verification (decision D-338).
##
## THE ONE QUESTION: does Gate 1D's guaranteed-drop callback count the Graveblade whose `died` signal called
## it, and nothing else? Before J9 it did not. `_on_first_graveblade_died()` read `DamageEvent.source` — the
## ATTACKER — as the rewarded enemy, so the first kill marked the PLAYER as rewarded. Only one Graveblade's
## `died` is connected, so no second call ever arrived and the defect stayed latent; it was recorded at the
## Roguelite Core Loop review, whose runtime already binds the emitting enemy.
##
## THE SLICE IS THE ONLY PRODUCTION FILE J9 MOVES: its one connection binds the first Graveblade, and the
## callback receives that Graveblade and no longer reads `event.source`. That is proved by reconstruction:
## with J9's two changes put back it is, byte for byte, the D-337 file.
##
## GATE 1D'S OWN `broken_watch_slice.tscn`, LOADED AS IT SHIPS. The first Graveblade is killed by the
## player's own Quick Strikes; the connection, the rewarded set, the drop and its placement are then read
## from the live production objects. The harness decides nothing about who is rewarded: the slice's own
## callback does, and the harness reads what it did. What the harness does itself is stated where it does it:
##   - both Graveblades are quieted and placed; each Quick Strike is aimed through the slice's seam
##     `force_next_aim_for_verification()`; each Graveblade attack on the player is begun through
##     `begin_attack_for_verification()`;
##   - SUPPLEMENTARY, after the real death: the first Graveblade's `died` is emitted once more by the harness,
##     with an event naming the SECOND Graveblade as the attacker;
##   - the controller is made the live family by one stick deflection pushed into the root viewport, and
##     (A), Escape, Enter and F5 are pushed into it the way a device's arrive.
##
## The Roguelite Core Loop's own scene is then loaded as it ships and its connections are read: it binds its
## own enemies, and none is connected to Gate 1D's callback. Gate 1E's inheritance is read from source only;
## its scene is never loaded here.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Input is simulated, which is not physical-device certification. It
## opens no window of its own and writes no file.
##
## Run: godot --headless --path game --script res://tests/guaranteed_drop_defeated_enemy_binding_verification.gd

const THIS_FILE: String = "res://tests/guaranteed_drop_defeated_enemy_binding_verification.gd"
const SLICE_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
const SLICE_SCENE: String = "res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
const CORE_LOOP_SCRIPT: String = "res://scripts/roguelite/roguelite_core_loop_runtime.gd"
const CORE_LOOP_SCENE: String = "res://scenes/roguelite/roguelite_core_loop.tscn"
const REPLAYABILITY_SCRIPT: String = "res://scripts/roguelite/replayability/roguelite_replayability_runtime.gd"
const OPENING_SCRIPT: String = "res://scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
const WATCHSTEEL_SWORD: String = "res://data/first_mvp/severed_threshold/broken_watch/watchsteel_sword.tres"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31
const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]
const CALLBACK: String = "_on_first_graveblade_died"
const CORE_LOOP_CALLBACK: String = "_on_encounter_enemy_died"

## The slice as D-337 left it, whole, and J9's two changes to it. Each pair is [as J9 wrote it, as D-337 left
## it]; each carries a line beside the change so that it is unique.
const PRE_J9_SLICE_SHA256: String = "f83e94367fd69a98833017554cc034ac87cb250047cc64eb286627e106dbbbc2"
const J9_SLICE_PREFIX: String = "942aee83"
const J9_COMMENT: String = "\t# First-MVP Gameplay J9 (decision D-338): the Graveblade that emits `died` is\n\t# bound, because `DamageEvent.source` is the attacker, not the enemy that died.\n"
const J9_CONNECTION: String = "\tgraveblades[0].died.connect(_on_first_graveblade_died.bind(graveblades[0]))\n"
const PRE_J9_CONNECTION: String = "\tgraveblades[0].died.connect(_on_first_graveblade_died)\n"
const J9_SIGNATURE: String = "func _on_first_graveblade_died(event: DamageEvent, enemy: PrototypeGraveblade) -> void:\n"
const PRE_J9_SIGNATURE: String = "func _on_first_graveblade_died(event: DamageEvent) -> void:\n"
const PRE_J9_ATTACKER_READ: String = "\tvar enemy: Node = event.source\n"
const KEYED_LINE: String = "\tif _rewarded_enemies.has(enemy.get_instance_id()):\n"
const J9_SLICE_MOVES: Array = [
	[J9_COMMENT + J9_CONNECTION, PRE_J9_CONNECTION],
	[J9_SIGNATURE + KEYED_LINE, PRE_J9_SIGNATURE + PRE_J9_ATTACKER_READ + KEYED_LINE],
]

## `_spawn_graveblades()` and `_on_first_graveblade_died()`, code line for code line, after J9.
const SPAWN_LINES: Array[String] = [
	"graveblades.append(_spawn_graveblade(\"FirstGraveblade\", broken_watch.first_encounter_spawn()))",
	"graveblades.append(_spawn_graveblade(\"SecondGraveblade\", broken_watch.second_encounter_spawn()))",
	"graveblades[0].died.connect(_on_first_graveblade_died.bind(graveblades[0]))",
]
const PRE_J9_SPAWN_LAST: String = "graveblades[0].died.connect(_on_first_graveblade_died)"
const CALLBACK_LINES: Array[String] = [
	"if _rewarded_enemies.has(enemy.get_instance_id()):",
	"log_event(\"reward refused\", \"duplicate kill signal from an already-rewarded enemy\")", "return",
	"_rewarded_enemies[enemy.get_instance_id()] = true",
	"if _drop_granted:", "log_event(\"reward refused\", \"the guaranteed drop was already granted\")", "return",
	"_drop_granted = true",
	"_place_drop(event.target.global_position if event.target != null else broken_watch.first_encounter_spawn())",
]
const PRE_J9_ATTACKER_LINE: String = "var enemy: Node = event.source"

## The slice's declarations, as D-337 left them (J3's, J4's and J5's own counts).
const SLICE_FIELDS: int = 35
const SLICE_EXPORTS: int = 8
const SLICE_FUNCTIONS: int = 53
const SLICE_CONSTANTS: int = 12

## The log lines the slice's own callback and restart write, and the drop's placement line.
const DUPLICATE_LINE: String = "duplicate kill signal from an already-rewarded enemy"
const LATCH_LINE: String = "the guaranteed drop was already granted"
const PLACED_LINE: String = "placed near the fallen Graveblade"
const KILLING_SOURCE: String = "Graveblade — Melee Hit — 125 Physical Damage"

## Verification Maintenance V1 (decision D-342): every pair list this suite uses to put a file back lives in
## the flat, content-addressed provenance store under res://tests/provenance/, named by the SHA-256 of its
## listing. Each `*_ROWS` and `*_MOVE_IDS` constant below names its pair lists, and the variable of the old name
## holds them resolved, so every check reads exactly as before. They are resolved through the one engine there,
## and only while it is at the SHA-256 pinned here; a pair list the store cannot prove resolves to nothing.
const PROVENANCE_ENGINE: String = "res://tests/provenance/accepted_suite_provenance.gd"
const PROVENANCE_ENGINE_SHA256: String = "fadbdfeba32546d03bffe876c2b8be7a96dfe966ff9f5d4f720199d664b23dc4"

## The fourteen accepted suite files J9 moved, each put back to exactly what it was at the end of D-337. Each
## row is [path, its J9 prefix, its D-337 SHA-256, pairs of (as J9 wrote it, as D-337 left it)].
const MOVED_SUITE_ROWS: Array = [
	["res://tests/first_mvp_modal_left_click_verification.gd", "acbd3892", "8c0e290c1dd74906769666fa0bc63a0cb6693f7ba6d6d67d9fb0ea280d69cb47", "fb8d9401ba6c004b0d1e1997f866d76602e5b423be361ff06b383bafc3cc1749"],
	["res://tests/fallen_modal_life_state_verification.gd", "6acc1e0c", "d5407c7cc138dfc64e885d5cbda5bffa0f14bed25bf48c16ed71e299a1a24ce0", "fb8d9401ba6c004b0d1e1997f866d76602e5b423be361ff06b383bafc3cc1749"],
	["res://tests/pending_fallen_restart_verification.gd", "dc9be60f", "1062c1db771d7f18c9cf2a0e5326ca4d056d89b7dec2e01ea0be359995673704", "1a4d7f01639d1180ba3e70a49c8ce4e9c0a1843a82055d515465b366aecc64d8"],
	["res://tests/pending_fallen_restart_smoke.sh", "ec5bc37f", "689284cc77892b7a49ea313fb03612244bdfacb9ff21d62dcd2f81c33b4261ed", "d4f4a6ada9acac4c6a846830bc9283e4d5c4537f03d7a61b32b185a18dad22fb"],
	["res://tests/fallen_delay_item_interaction_verification.gd", "eff592af", "3deeb26ae8c7a049c4e18b89de2169d2cfd8084997ec80d7215921ce35bb7cfd", "155bdaf5bb4dd9b2169b9e4139f9fe758fd3bf98e82add80617e3443f37d5639"],
	["res://tests/fallen_delay_item_interaction_smoke.sh", "e14e996b", "cb5203698a3564198df9c110510a3a16799bfce0a36daaefbb806ffc94fb0d17", "cec36c2a16824f2215ee25fae06ada08a06280f275458c0013c362e50f33d2c9"],
	["res://tests/fallen_delay_drop_highlight_verification.gd", "b735e6c7", "c9648eeabbaceb5913a1ce782f465d64f1c3aee0f16728b1f22067df58eca39d", "2f98d83b3abfcaf89832fd0cdf85f33821a4d19b71be7245eb44ea4b86f48c9a"],
	["res://tests/fallen_delay_drop_highlight_smoke.sh", "fea9988e", "d277237304974262532f922ce652b49f84100cd8f4d9e7019282938f46ced61b", "8cb05e6397960b68217afa5590a8afa96d4dfaf7b96a6f4696575569624b2ae8"],
	["res://tests/combat_hud_fractional_fill_verification.gd", "d38624c8", "333c16743212b30100059f5449f9417da46061016458b71aa22ac2ba08253e53", "86abd8bd53ea5d192fa12a838124423248a3c1680cec3a94a48ecac028f0737b"],
	["res://tests/combat_hud_fractional_fill_smoke.sh", "a444af4b", "a5744db690b13bcb569c39fa2178acd2c182f86e28e830867e724104958306e0", "7b137652580a630468db24b8f3a1580f5fa3b4d9565e6d389c16739f94d1e4c3"],
	["res://tests/enemy_hover_life_fractional_fill_verification.gd", "2187ccb1", "fde101def0406b2bcc5dfaa98de67b3f4849bf516c16b34fbba4f523f734e71f", "44167fbbce75ad4fd4f58849b6170b163ad74cd85c9c5cb5cedcce25bda094c4"],
	["res://tests/enemy_hover_life_fractional_fill_smoke.sh", "22a95042", "5aa1ec83510353bbc590a260146526f80946d7266170e32e3717331c5f171d79", "7922a0ed566ffb229e9f5cb79b5ad2490e3bd06c22e7c38f80061b41947637c1"],
	["res://tests/combat_hud_safe_bottom_placement_verification.gd", "c980d240", "117ab87b66426d48b6b07ca1a8095267ca17102ea82177e00a1b22121b269200", "f37188d6f4f5dee2f3741105a17d7cca6e0249900ae84b1d589f72c7e25ffd47"],
	["res://tests/combat_hud_safe_bottom_placement_smoke.sh", "8c13aa43", "cc7e665a6ee5b81d67e8affacefdd632e86e551148557950cc01ac85f1011cf4", "83737b5715b8f8f3d70e7f56195f598b5be367515a315d0f842039ad4d57d156"],
]
var MOVED_SUITES: Array = _stored(MOVED_SUITE_ROWS)
const MOVED_SUITE_COUNT: int = 14

## First-MVP Gameplay J10 (D-340) moved the slice and the fourteen suite files above again, one for one, when Gate 1D's
## slice's restart came to end the movement command it carried. Each is first put back to where D-339 left it
## and then read exactly as before: `J10_PREFIXES` holds each file's J10 prefix, and `J10_MOVES` its pairs of
## [as J10 wrote it, as D-339 left it], applied to that file alone.
const J10_PREFIXES: Dictionary = {
	SLICE_SCRIPT: "883ef25e",
	"res://tests/first_mvp_modal_left_click_verification.gd": "75f26486",
	"res://tests/fallen_modal_life_state_verification.gd": "935a37e9",
	"res://tests/pending_fallen_restart_verification.gd": "53c37976",
	"res://tests/pending_fallen_restart_smoke.sh": "9a860bca",
	"res://tests/fallen_delay_item_interaction_verification.gd": "5c8e9b07",
	"res://tests/fallen_delay_item_interaction_smoke.sh": "0fd60eb7",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "dceea6f9",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "b1b456bd",
	"res://tests/combat_hud_fractional_fill_verification.gd": "f7144aac",
	"res://tests/combat_hud_fractional_fill_smoke.sh": "6cf22e7d",
	"res://tests/enemy_hover_life_fractional_fill_verification.gd": "0b816f06",
	"res://tests/enemy_hover_life_fractional_fill_smoke.sh": "0dbde2d8",
	"res://tests/combat_hud_safe_bottom_placement_verification.gd": "b709813c",
	"res://tests/combat_hud_safe_bottom_placement_smoke.sh": "900c8d9e",
}
const J10_MOVE_IDS: Dictionary = {
	SLICE_SCRIPT: "0f3be56df737115f62f10f15bcee4d1ead68b785b0465eb9c6d7fd804540a413",
	"res://tests/first_mvp_modal_left_click_verification.gd": "26ba84a3fd1582fd17708ff4b49d5522cfbf6142a558114d9c519a6f24ab0250",
	"res://tests/fallen_modal_life_state_verification.gd": "26ba84a3fd1582fd17708ff4b49d5522cfbf6142a558114d9c519a6f24ab0250",
	"res://tests/pending_fallen_restart_verification.gd": "d9ffd11477b4bfd3b1c1f297ab77ad7b4ce71a117d1acbd1872907bc18d0fe7a",
	"res://tests/pending_fallen_restart_smoke.sh": "58b1cc938d16d1b2bef63f0552efc11c7596ea019e4bb55e98972b4f9494757d",
	"res://tests/fallen_delay_item_interaction_verification.gd": "bab624db6148b8252317457295986ea7fcdbd0337bc63e5cd1b080eccc80286e",
	"res://tests/fallen_delay_item_interaction_smoke.sh": "8d4a99d6cc235c0be4eb36dc8b9c9518d3ca17e98153302fdf794e950c8a3b16",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "5e3a771c3ee4e816d68cb6cbbd419bd6654f56642c1a8f292ae7cbdb41716bd1",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "7e13fd06e30bb30412f0f1cd1d81b4e61bdafdcbe2a8f14e6b8f8f42b997b9f5",
	"res://tests/combat_hud_fractional_fill_verification.gd": "0a55f82e83f57d33955f8b95d5727ab4e7a1a324e84180953a1fdbaa19ecde42",
	"res://tests/combat_hud_fractional_fill_smoke.sh": "f114f35ef32266ae3f23674555ae7a5f37e643391dbd31a075aa709158a42f88",
	"res://tests/enemy_hover_life_fractional_fill_verification.gd": "9e04ae8f656916e43630abe66bb77343a9ff811bf467b3d3a817c6f8d3213801",
	"res://tests/enemy_hover_life_fractional_fill_smoke.sh": "0b3c44793f61c3e40eb9e75c195e05619a356fa83a691eed75192dcbd9e6a28a",
	"res://tests/combat_hud_safe_bottom_placement_verification.gd": "82050c7e28ac6904a4660ba42adc5d2a2e44d76f4efd75ef2407388481f311e2",
	"res://tests/combat_hud_safe_bottom_placement_smoke.sh": "19f1cdaa102717d795a153a0544a75c46bf7fb5078016211f74e6fdbf2669ee0",
}
var J10_MOVES: Dictionary = _stored(J10_MOVE_IDS)

## Verification Maintenance V1 (D-342) moved nine of the files above again, one for one, when their put-back pairs
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
}
var J11_MOVES: Dictionary = _stored(J11_MOVE_IDS)

## Everything J9 stands beside, at the SHA-256 prefix each held before the first J9 edit.
const UNCHANGED_HASHES: Array = [
	["res://scripts/actors/prototype_player.gd", "80e38838"],
	["res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn", "e9d16993"],
	["res://scripts/actors/prototype_graveblade.gd", "0ae1374b"],
	["res://scripts/actors/graveblade_target_area.gd", "5604633c"],
	["res://scenes/actors/prototype_graveblade.tscn", "752db86c"],
	["res://scenes/actors/prototype_player.tscn", "3078a215"],
	["res://scripts/combat/damage_event.gd", "3b3185c4"],
	["res://scripts/combat/quick_strike_action.gd", "e6514705"],
	["res://scripts/combat/attack_coordinator.gd", "9ee63381"],
	["res://scripts/combat/target_acquisition.gd", "bf4c14d4"],
	["res://scripts/combat/prototype_targetable.gd", "af29e970"],
	["res://scripts/movement/prototype_ground_pointer.gd", "ee7ab5ad"],
	["res://scripts/movement/prototype_locomotion.gd", "c71de58f"],
	["res://scripts/input/input_family_tracker.gd", "8b721355"],
	["res://scripts/items/first_mvp_item_drop.gd", "dbd5594d"],
	["res://scripts/items/player_loadout.gd", "d79b63df"],
	["res://scripts/ui/first_mvp_modal.gd", "1cfe9c73"],
	["res://scripts/ui/first_mvp_item_comparison.gd", "3607f9f7"],
	["res://scripts/ui/first_mvp_fallen_overlay.gd", "de5e1ab0"],
	["res://scripts/ui/first_mvp_combat_hud.gd", "ee485029"],
	## First-MVP Gameplay J10 (D-340) moved Broken Watch's layout one for one, from `79c2b3a5`, so that its entry
	## socket stands clear of Riftfall Landing's Watch Breach far cap. Same count.
	["res://scripts/first_mvp/severed_threshold/broken_watch_layout.gd", "cac924df"],
	["res://scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd", "601e5901"],
	["res://scripts/roguelite/roguelite_core_loop_runtime.gd", "a76cec3d"],
	["res://scripts/roguelite/replayability/roguelite_replayability_runtime.gd", "ef236cec"],
	["res://scripts/roguelite/build_variety/roguelite_build_variety_runtime.gd", "e9abb336"],
	["res://scripts/roguelite/experience/roguelite_experience_collection_review.gd", "150509d5"],
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", "128103b4"],
	["res://scripts/roguelite/live_effects/roguelite_live_effect_review.gd", "75cb02b9"],
	["res://scripts/prototype_zero/prototype_zero.gd", "21b41e49"],
	["res://scenes/first_mvp/canonical_opening/canonical_opening.tscn", "b1d9f2e4"],
	["res://scenes/roguelite/roguelite_core_loop.tscn", "6bdf5388"],
	["res://data/prototype_zero/graveblade.tres", "56317f5f"],
	["res://data/roguelite/graveblade_elite.tres", "6eb3d792"],
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
	["res://tests/global_damage_live_application_smoke.sh", "ccef4a26"],
	["res://tests/maximum_life_live_application_smoke.sh", "e3887f96"],
]

const KILL_SPOT: float = 6.0
const NEAR_DROP: float = 1.0
const NEAR: float = 1.2

const OWED_CHECKS: Array[String] = [
	"the_production_diff_is_exactly_the_bound_emitter",
	"the_accepted_suites_moved_only_their_pins_and_reconstructions",
	"only_the_connection_and_the_callbacks_first_lines_changed",
	"the_callback_is_named_and_connected_only_by_the_slice",
	"no_combat_scene_input_map_or_project_behaviour_changed",
	"a_real_first_graveblade_death_names_the_player_as_source_and_the_graveblade_as_target",
	"the_production_connection_carries_the_exact_first_graveblade",
	"the_rewarded_set_holds_the_defeated_graveblade_and_not_the_attacker",
	"exactly_one_watchsteel_drop_lies_where_the_unchanged_route_resolves_it",
	"a_repeated_death_signal_naming_another_attacker_is_refused_as_the_same_graveblade",
	"the_second_graveblade_stays_outside_the_guaranteed_drop_connection",
	"a_restart_revives_both_and_a_second_real_kill_is_refused_without_a_second_drop",
	"the_fallen_delay_item_interaction_and_highlight_behave_as_accepted",
	"the_roguelite_core_loop_binds_its_own_enemies_and_never_connects_the_callback",
	"gate_1e_inherits_the_binding_by_structure_only_and_is_not_run",
]

var arguments: PackedStringArray = PackedStringArray()
var slice: BrokenWatchSlice

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _staged: PackedStringArray = PackedStringArray()
var _token: String = ""

var _drops_created: int = 0
var _opening_nodes: int = 0
var _use_id: int = 900000
var _supplementary: bool = false
var _first_deaths: Array = []
var _second_deaths: Array = []
var _player_id: int = 0
var _first_id: int = 0
var _second_id: int = 0
var _starting_weapon: String = ""
var _drop_position: Vector3 = Vector3.INF
var _play: Dictionary = {}
var _loop: Dictionary = {}


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	_token = _argument_value("--run-token")
	print("")
	print("=== First-MVP Gameplay J9 — Gate 1D Guaranteed-Drop Defeated-Enemy Binding V1 verification (D-338) ===")
	print("  run token: %s" % (_token if not _token.is_empty() else "none given"))
	node_added.connect(_on_node_added)

	_check_the_production_diff_is_exactly_the_bound_emitter()
	_check_the_accepted_suites_moved_only_their_pins_and_reconstructions()
	_check_only_the_connection_and_the_callbacks_first_lines_changed()
	_check_the_callback_is_named_and_connected_only_by_the_slice()
	_check_no_combat_scene_input_map_or_project_behaviour_changed()

	await _play_the_slice()
	if slice != null and not _play.is_empty():
		_check_a_real_first_graveblade_death_names_the_player_as_source_and_the_graveblade_as_target()
		_check_the_production_connection_carries_the_exact_first_graveblade()
		_check_the_rewarded_set_holds_the_defeated_graveblade_and_not_the_attacker()
		_check_exactly_one_watchsteel_drop_lies_where_the_unchanged_route_resolves_it()
		_check_a_repeated_death_signal_naming_another_attacker_is_refused_as_the_same_graveblade()
		_check_the_second_graveblade_stays_outside_the_guaranteed_drop_connection()
		_check_a_restart_revives_both_and_a_second_real_kill_is_refused_without_a_second_drop()
		_check_the_fallen_delay_item_interaction_and_highlight_behave_as_accepted()

	await _play_the_core_loop()
	if not _loop.is_empty():
		_check_the_roguelite_core_loop_binds_its_own_enemies_and_never_connects_the_callback()
	_check_gate_1e_inherits_the_binding_by_structure_only_and_is_not_run()

	_check_every_check_ran()
	if node_added.is_connected(_on_node_added):
		node_added.disconnect(_on_node_added)
	await process_frame

	print("")
	print("  staged: %s" % "; ".join(_staged))
	if _failures.is_empty():
		print("GUARANTEED DROP DEFEATED ENEMY BINDING VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("GUARANTEED DROP DEFEATED ENEMY BINDING VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		quit(1)


# --- 1–5. Structure: the one file, its two changes, its reach ------------------------------------

func _check_the_production_diff_is_exactly_the_bound_emitter() -> void:
	print("")
	print("--- 1. Exactly one production file moved — Gate 1D's slice — and it is the D-337 file with its one connection binding the first Graveblade and the callback receiving it")
	var source: String = _before_j10(SLICE_SCRIPT, _before_j11(SLICE_SCRIPT, FileAccess.get_file_as_string(SLICE_SCRIPT)))
	var digest: String = source.sha256_text()
	var rebuilt: Dictionary = _put_back(source, J9_SLICE_MOVES)
	var pre_text: String = String(rebuilt["text"])
	var lines_now: int = source.count("\n")
	var lines_then: int = pre_text.count("\n")
	var reads_now: int = _bare(source).count("event.source")
	var reads_then: int = _bare(pre_text).count("event.source")
	_expect(FileAccess.get_sha256(SLICE_SCRIPT).begins_with(String(J11_PREFIXES[SLICE_SCRIPT]))
			and _before_j11(SLICE_SCRIPT, FileAccess.get_file_as_string(SLICE_SCRIPT)).sha256_text().begins_with(String(J10_PREFIXES[SLICE_SCRIPT]))
			and digest.begins_with(J9_SLICE_PREFIX) and bool(rebuilt["unique"]) and pre_text.sha256_text() == PRE_J9_SLICE_SHA256
			and (pre_text + "x").sha256_text() != PRE_J9_SLICE_SHA256,
		"the slice hashes %s, not its J9 prefix %s; J9's two changes are in it: %s; put back it hashes %s, not the D-337 %s"
			% [digest.left(8), J9_SLICE_PREFIX, str(rebuilt["unique"]), pre_text.sha256_text().left(8), PRE_J9_SLICE_SHA256.left(8)])
	_expect(source.count(J9_COMMENT + J9_CONNECTION) == 1 and source.count(J9_SIGNATURE) == 1
			and not source.contains(PRE_J9_CONNECTION) and not source.contains(PRE_J9_SIGNATURE) and not source.contains(PRE_J9_ATTACKER_READ)
			and lines_now == lines_then + 1 and reads_now == 0 and reads_then == 1,
		"J9's connection occurs %d time(s) and signature %d; the D-337 connection %d, signature %d and attacker read %d; %d lines against %d; event.source read %d time(s) against D-337's %d"
			% [source.count(J9_COMMENT + J9_CONNECTION), source.count(J9_SIGNATURE), source.count(PRE_J9_CONNECTION),
				source.count(PRE_J9_SIGNATURE), source.count(PRE_J9_ATTACKER_READ), lines_now, lines_then, reads_now, reads_then])
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in UNCHANGED_HASHES:
		var held: String = FileAccess.get_sha256(String(row[0]))
		if not held.begins_with(String(row[1])):
			moved.append("%s %s" % [String(row[0]).get_file(), held.left(8)])
	_expect(moved.is_empty() and UNCHANGED_HASHES.size() == 45, "moved: %s" % ", ".join(moved))
	print("  the slice is at its J9 hash %s, %d lines; with J9's 2 comment lines and bound connection put back to the one connection they replaced, and the callback's signature put back with the attacker read it lost, it is, byte for byte, the D-337 file %s, %d lines — once J10's clearing line (D-340) is put back"
		% [digest.left(8), lines_now, PRE_J9_SLICE_SHA256.left(8), lines_then])
	print("  event.source is read %d times in the slice's code; the D-337 slice read it %d time, as the rewarded enemy" % [reads_now, reads_then])
	print("  %d files J9 stands beside hold the hashes they held before the first J9 edit: the player, the slice's scene, the Graveblade, its target area and both actor scenes, the damage event, the combat, movement and input kernels, the drop, the loadout, the modal contract, the comparison, the Fallen overlay, the HUD, the layout, all 7 descendants of the slice, Prototype Zero's room, two scenes, four records, project.godot and nine accepted suite files; Broken Watch's layout since moved by J10 (D-340)"
		% UNCHANGED_HASHES.size())
	_done("the_production_diff_is_exactly_the_bound_emitter")


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


## Puts a file J10 moved back to where D-339 left it (First-MVP Gameplay J10, D-340).
func _before_j10(path: String, text: String) -> String:
	for pair: Array in J10_MOVES.get(path, []):
		text = text.replace(String(pair[0]), String(pair[1]))
	return text


func _check_the_accepted_suites_moved_only_their_pins_and_reconstructions() -> void:
	print("")
	print("--- 2. The fourteen accepted suite files J9 had to move moved only their pins, reconstructions and truthful clauses, one for one, at unchanged counts")
	var faults: PackedStringArray = PackedStringArray()
	var blocks: int = 0
	var back: PackedStringArray = PackedStringArray()
	for row: Array in MOVED_SUITES:
		var path: String = row[0]
		var j10_text: String = _before_vm1(path, _before_j11(path, FileAccess.get_file_as_string(path)))
		var j9_text: String = _before_j10(path, j10_text)
		var rebuilt: Dictionary = _put_back(j9_text, row[3])
		blocks += (row[3] as Array).size()
		back.append(String(row[2]).left(8))
		if not (FileAccess.get_sha256(path).begins_with(String(J11_PREFIXES.get(path, VM1_PREFIXES.get(path, J10_PREFIXES[path]))))
				and j10_text.sha256_text().begins_with(String(J10_PREFIXES[path])) and j9_text.sha256_text().begins_with(String(row[1]))
				and bool(rebuilt["unique"]) and not (row[3] as Array).is_empty()
				and String(rebuilt["text"]).sha256_text() == String(row[2])
				and (String(rebuilt["text"]) + "x").sha256_text() != String(row[2])):
			faults.append("%s at %s rebuilds to %s" % [path.get_file(), FileAccess.get_sha256(path).left(8), String(rebuilt["text"]).sha256_text().left(8)])
	_expect(faults.is_empty() and MOVED_SUITES.size() == MOVED_SUITE_COUNT,
		"%d of %d moved suite files described; %s" % [MOVED_SUITES.size(), MOVED_SUITE_COUNT, "; ".join(faults)])
	print("  J1's, J2's, J6's, J7's and J8's verifications moved their slice row; J3's to J8's verifications and runners their pins of the slice and of the suites J9 moved before them, and J3's to J8's verifications learned to put back what J9 moved before reading as before; J6's, J7's and J8's runners their production digest: put back, the %d are byte for byte %s (%d replaced blocks)"
		% [MOVED_SUITES.size(), ", ".join(back), blocks])
	_done("the_accepted_suites_moved_only_their_pins_and_reconstructions")


func _check_only_the_connection_and_the_callbacks_first_lines_changed() -> void:
	print("")
	print("--- 3. Only _spawn_graveblades() and the callback's first lines changed: the connection binds the first Graveblade, the callback receives it; no field, signal, accessor, helper, branch or per-frame work was added")
	var source: String = _before_j10(SLICE_SCRIPT, _before_j11(SLICE_SCRIPT, FileAccess.get_file_as_string(SLICE_SCRIPT)))
	var pre_text: String = String(_put_back(source, J9_SLICE_MOVES)["text"])
	var spawn: PackedStringArray = _code_lines(_function_body(source, "_spawn_graveblades"))
	var pre_spawn: PackedStringArray = _code_lines(_function_body(pre_text, "_spawn_graveblades"))
	var callback: PackedStringArray = _code_lines(_function_body(source, CALLBACK))
	var pre_callback: PackedStringArray = _code_lines(_function_body(pre_text, CALLBACK))
	var expected_pre_spawn: PackedStringArray = PackedStringArray(SPAWN_LINES)
	expected_pre_spawn[2] = PRE_J9_SPAWN_LAST
	var expected_pre_callback: PackedStringArray = PackedStringArray([PRE_J9_ATTACKER_LINE])
	expected_pre_callback.append_array(PackedStringArray(CALLBACK_LINES))
	_expect(spawn == PackedStringArray(SPAWN_LINES) and pre_spawn == expected_pre_spawn,
		"_spawn_graveblades() reads %s; D-337's %s" % [str(spawn), str(pre_spawn)])
	_expect(callback == PackedStringArray(CALLBACK_LINES) and pre_callback == expected_pre_callback
			and source.count(J9_SIGNATURE) == 1 and source.count("func %s(" % CALLBACK) == 1,
		"the callback reads %s; D-337's %s" % [str(callback), str(pre_callback)])
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
	_expect(functions == pre_functions and differing == PackedStringArray(["_spawn_graveblades", CALLBACK])
			and fields == SLICE_FIELDS and exports == SLICE_EXPORTS and functions.size() == SLICE_FUNCTIONS
			and constants == SLICE_CONSTANTS and signals == 0 and enums == 0
			and code.count(".bind(") == 1 and code.count("died.connect(") == 1 and code.count("_rewarded_enemies") == 3,
		"functions in D-337's order: %s; bodies differing: %s; %d fields, %d exports, %d functions, %d constants, %d signals, %d enums; .bind( %d, died.connect( %d, _rewarded_enemies %d"
			% [str(functions == pre_functions), str(differing), fields, exports, functions.size(), constants, signals, enums,
				code.count(".bind("), code.count("died.connect("), code.count("_rewarded_enemies")])
	var lost: PackedStringArray = PackedStringArray()
	for line: String in pre_callback:
		if not callback.has(line):
			lost.append(line)
	print("  _spawn_graveblades(): %d code lines; the D-337 third — %s — now reads %s"
		% [spawn.size(), pre_spawn[2] if pre_spawn.size() == 3 else "?", spawn[2] if spawn.size() == 3 else "?"])
	print("  %s(): %d code lines where D-337 had %d; the line(s) it lost: %s; the signature now reads %s"
		% [CALLBACK, callback.size(), pre_callback.size(), ", ".join(lost), J9_SIGNATURE.strip_edges() if source.count(J9_SIGNATURE) == 1 else "its D-337 form"])
	print("  %d fields, %d exports, %d functions in D-337's order, %d constants, no signal and no enum; every body but those two is byte for byte the D-337 one; one .bind(, one died.connect(, _rewarded_enemies named 3 times as before — once J10's clearing line (D-340) is put back"
		% [fields, exports, functions.size(), constants])
	_done("only_the_connection_and_the_callbacks_first_lines_changed")


func _check_the_callback_is_named_and_connected_only_by_the_slice() -> void:
	print("")
	print("--- 4. What the change reaches (structural): the slice alone names and connects the callback; Gate 1E runs the slice's _ready(); the roguelite does not, and binds its own enemies")
	var classes: Dictionary = {}
	var parents: Dictionary = {}
	var sources: Dictionary = {}
	var scanned: int = 0
	var namers: PackedStringArray = PackedStringArray()
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd"]):
			scanned += 1
			var code: String = _bare(FileAccess.get_file_as_string(path))
			sources[path] = code
			var named: RegExMatch = RegEx.create_from_string("(?m)^class_name (\\w+)").search(code)
			var parent: RegExMatch = RegEx.create_from_string("(?m)^extends (\\w+)").search(code)
			classes[path] = named.get_string(1) if named != null else ""
			parents[path] = parent.get_string(1) if parent != null else ""
			if code.contains(CALLBACK):
				namers.append("%s x%d" % [path.get_file(), code.count(CALLBACK)])
	var lineage: PackedStringArray = PackedStringArray(["BrokenWatchSlice"])
	var descendants: PackedStringArray = PackedStringArray()
	for pass_index: int in 8:
		for path: Variant in sources.keys():
			if lineage.has(String(parents[path])) and not descendants.has(String(path)):
				descendants.append(String(path))
				lineage.append(String(classes[path]))
	descendants.sort()
	## `_spawn_graveblades(` inside the slice's own family, and anywhere else only as a script's own,
	## unrelated function of the same name — a script outside the family that declares its own.
	var spawners: PackedStringArray = PackedStringArray()
	var unrelated: PackedStringArray = PackedStringArray()
	for path: Variant in sources.keys():
		var code: String = String(sources[path])
		if not code.contains("_spawn_graveblades("):
			continue
		var entry: String = "%s x%d" % [String(path).get_file(), code.count("_spawn_graveblades(")]
		if (String(path) != SLICE_SCRIPT and not descendants.has(String(path)) and code.contains("func _spawn_graveblades(")
				and String(classes[path]) != "BrokenWatchSlice"):
			unrelated.append("%s (extends %s)" % [entry, String(parents[path])])
		else:
			spawners.append(entry)
	unrelated.sort()
	var names: PackedStringArray = PackedStringArray()
	var redeclarers: PackedStringArray = PackedStringArray()
	for path: String in descendants:
		names.append(path.get_file())
		for name: String in [CALLBACK, "_spawn_graveblades", "_place_drop"]:
			if String(sources[path]).contains("func %s(" % name):
				redeclarers.append("%s %s" % [path.get_file(), name])
	var opening: String = String(sources.get(OPENING_SCRIPT, ""))
	var loop: String = String(sources.get(CORE_LOOP_SCRIPT, ""))
	var replay: String = String(sources.get(REPLAYABILITY_SCRIPT, ""))
	var opening_ready: String = _function_body(opening, "_ready")
	var loop_ready: String = _function_body(loop, "_ready")
	_expect(scanned > 100 and namers == PackedStringArray(["broken_watch_slice.gd x2"])
			and spawners == PackedStringArray(["broken_watch_slice.gd x2"]),
		"names the callback: %s; names _spawn_graveblades( in the slice's family: %s; elsewhere, as its own function: %s"
			% [str(namers), str(spawners), str(unrelated)])
	_expect(descendants.size() == 7 and redeclarers.is_empty() and String(parents.get(OPENING_SCRIPT, "")) == "BrokenWatchSlice"
			and String(parents.get(CORE_LOOP_SCRIPT, "")) == "BrokenWatchSlice"
			and opening_ready.contains("await super._ready()") and not loop_ready.contains("super")
			and loop.count("died.connect(") == 1 and loop.contains("enemy.died.connect(%s.bind(index, enemy))" % CORE_LOOP_CALLBACK)
			and replay.count("died.connect(") == 1 and replay.contains("enemy.died.connect(_on_variant_enemy_died.bind(module, enemy))"),
		"descendants %s; redeclared %s; Gate 1E's _ready() calls super: %s; the core loop's does not: %s"
			% [str(names), str(redeclarers), str(opening_ready.contains("await super._ready()")), str(not loop_ready.contains("super"))])
	print("  of %d running scripts only broken_watch_slice.gd names %s() — its declaration and its one connection; of the slice and its descendants only it names _spawn_graveblades() — its declaration and the call in its _ready(); elsewhere %s, each declaring its own unrelated function of that name"
		% [scanned, CALLBACK, ", ".join(unrelated) if not unrelated.is_empty() else "nothing"])
	print("  %d descend from BrokenWatchSlice: %s; none redeclares %s(), _spawn_graveblades() or _place_drop()" % [descendants.size(), ", ".join(names), CALLBACK])
	print("  canonical_opening_runtime.gd's _ready() awaits super._ready(), so Gate 1E builds the same bound connection; roguelite_core_loop_runtime.gd's does not call super, connects each enemy to %s() with the enemy bound, and the replayability runtime binds its own the same way" % CORE_LOOP_CALLBACK)
	_done("the_callback_is_named_and_connected_only_by_the_slice")


func _check_no_combat_scene_input_map_or_project_behaviour_changed() -> void:
	print("")
	print("--- 5. The InputMap, the entrypoint and project.godot are untouched; the Graveblade, the damage event, the drop, the scenes and the records hold their D-337 hashes (check 1)")
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	_expect(actions == EXPECTED_ACTIONS and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT
			and not settings.contains("[autoload]") and not settings.contains("guaranteed_drop_defeated"),
		"%d actions, or project.godot moved" % actions)
	print("  %d actions; the entrypoint is %s; project.godot declares no [autoload] and names nothing of J9" % [actions, ENTRYPOINT.get_file()])
	_done("no_combat_scene_input_map_or_project_behaviour_changed")


# --- The play, in Gate 1D's own slice ---------------------------------------------------------

func _play_the_slice() -> void:
	slice = await _load(SLICE_SCENE) as BrokenWatchSlice
	if slice == null:
		return
	await _await_navigation(slice)
	_quiet()
	var first: PrototypeGraveblade = slice.graveblades[0]
	var second: PrototypeGraveblade = slice.graveblades[1]
	_player_id = slice.player.get_instance_id()
	_first_id = first.get_instance_id()
	_second_id = second.get_instance_id()
	_starting_weapon = String(slice.loadout.equipped_weapon.weapon_id)
	(slice.get_node("Actors") as Node).child_entered_tree.connect(func(node: Node) -> void:
		if node is FirstMvpItemDrop:
			_drops_created += 1)
	var record: Dictionary = {}
	record["connections_at_load"] = {"first": _bound_connections(first, CALLBACK), "second": _bound_connections(second, CALLBACK)}
	first.died.connect(_on_first_died)
	second.died.connect(_on_second_died)
	_note("Gate 1D's two Graveblades quieted; the harness listens to each Graveblade's died signal after the slice does, and counts every FirstMvpItemDrop that enters the slice's Actors")

	record["first_kill"] = await _kill_by_quick_strikes(first, _first_deaths)
	record["after_first_kill"] = _state()
	if slice._active_drop == null:
		_failures.append("no guaranteed drop was created, so nothing after it can be measured")
		return
	_drop_position = slice._active_drop.global_position
	record["drop"] = {
		"name": String(slice._active_drop.name), "weapon": slice._active_drop.weapon.resource_path if slice._active_drop.weapon != null else "",
		"display": slice._active_drop.display_name(), "range": slice._active_drop.interaction_range, "at": _drop_position,
	}

	record["re_emission"] = await _re_emit_with_another_attacker(first, second)

	var before_second: Dictionary = _state()
	var second_kill: Dictionary = await _kill_by_quick_strikes(second, _second_deaths)
	second_kill["before"] = before_second
	second_kill["after"] = _state()
	record["second_kill"] = second_kill
	record["connections_after_second_kill"] = {"first": _bound_connections(first, CALLBACK), "second": _bound_connections(second, CALLBACK)}

	record["f5"] = await _restart_by_f5()

	var before_again: Dictionary = _state()
	var kill_again: Dictionary = await _kill_by_quick_strikes(first, _first_deaths)
	kill_again["before"] = before_again
	kill_again["after"] = _state()
	record["kill_again"] = kill_again

	record["alive_interaction"] = await _interact("before the Fallen")
	var fallen: Dictionary = await _fall_near_the_drop()
	record["fallen"] = fallen
	if bool(fallen.get("dead", false)):
		record["overlay_restart"] = await _restart_by_confirm()
		record["restart_interaction"] = await _interact("after the Fallen restart")
	record["connections_at_end"] = {"first": _bound_connections(first, CALLBACK), "second": _bound_connections(second, CALLBACK)}
	_play = record


## The first Graveblade's `died`, heard after the slice's own callback has run. What the unchanged production
## route resolves the fallen position to is read here too, at the moment the slice placed its drop.
func _on_first_died(event: DamageEvent) -> void:
	var target: Node3D = event.target as Node3D
	var at: Vector3 = target.global_position if target != null else Vector3.INF
	var expected: Vector3 = Vector3.INF
	if target != null:
		var resolved: Dictionary = PrototypeGroundPointer.resolve_to_navigation(slice.navigation_map(), at)
		var point: Vector3 = resolved["point"]
		expected = Vector3(point.x, 0.0, point.z)
	_first_deaths.append({
		"source_id": event.source.get_instance_id() if event.source != null else 0,
		"target_id": event.target.get_instance_id() if event.target != null else 0,
		"at": at, "expected_drop": expected, "supplementary": _supplementary,
		"rewarded": _sorted(slice._rewarded_enemies.keys()), "drops": _drops_created,
	})


func _on_second_died(event: DamageEvent) -> void:
	_second_deaths.append({
		"source_id": event.source.get_instance_id() if event.source != null else 0,
		"target_id": event.target.get_instance_id() if event.target != null else 0,
		"supplementary": _supplementary,
	})


## What the slice holds and has written, by value.
func _state() -> Dictionary:
	var drop: FirstMvpItemDrop = slice._active_drop
	return {
		"rewarded": _sorted(slice._rewarded_enemies.keys()), "granted": slice._drop_granted,
		"drop_id": drop.get_instance_id() if drop != null and is_instance_valid(drop) else 0, "drops": _drops_created,
		"duplicate_lines": _log_count(DUPLICATE_LINE), "latch_lines": _log_count(LATCH_LINE),
		"refused_lines": _log_count("reward refused"), "placed_lines": _log_count(PLACED_LINE),
		"restarts": _log_count("slice restarted"),
	}


## STAGED aim, real attack: the Graveblade placed on Riftfall Landing's route and struck by the player's own
## Quick Strikes, aimed through the slice's seam, until it dies.
func _kill_by_quick_strikes(enemy: PrototypeGraveblade, heard: Array) -> Dictionary:
	var player: PrototypePlayer = slice.player
	var area: PrototypeTargetable = enemy.get_node("TargetArea") as PrototypeTargetable
	var forward: Vector3 = _forward()
	await _until_neutral()
	_quiet()
	enemy.place_at(slice.landing_layout.player_start() + forward * KILL_SPOT)
	enemy.face_instantly(-forward)
	await _settle(2)
	var heard_before: int = heard.size()
	var trail: Array = [enemy.life]
	for hit: int in 6:
		if not enemy.is_alive():
			break
		_stand_facing(enemy.global_position - forward * 1.0, forward)
		await _settle(1)
		var before: float = enemy.life
		slice.force_next_aim_for_verification(area)
		player.attack.press()
		player.attack.release_input()
		for frame: int in 120:
			await physics_frame
			if enemy.life < before and player.attack.phase == QuickStrikeAction.Phase.READY:
				break
		trail.append(enemy.life)
	await _settle(3)
	await _await_process_frames(3)
	_note("each kill: the Graveblade placed %.0f m up Riftfall Landing's route and struck by the player's own Quick Strikes, aimed through force_next_aim_for_verification()" % KILL_SPOT)
	return {"trail": trail, "dead": not enemy.is_alive(), "heard": heard.slice(heard_before), "damage": player.weapon.physical_damage}


## SUPPLEMENTARY, after the real death: the harness emits the first Graveblade's `died` once more, with an
## event whose source is the SECOND Graveblade. The slice's callback decides what to do with it.
func _re_emit_with_another_attacker(first: PrototypeGraveblade, second: PrototypeGraveblade) -> Dictionary:
	var before: Dictionary = _state()
	var heard_before: int = _first_deaths.size()
	_use_id += 1
	var event: DamageEvent = DamageEvent.physical(_use_id, second, first, 0.0)
	_supplementary = true
	first.died.emit(event)
	_supplementary = false
	await _settle(2)
	await _await_process_frames(2)
	_note("SUPPLEMENTARY: after the real death the harness emitted the first Graveblade's died signal once more, carrying an event whose source is the second Graveblade; the slice's own callback handled it")
	return {"before": before, "after": _state(), "heard": _first_deaths.slice(heard_before),
		"source_is_second": event.source == second, "target_is_first": event.target == first}


## F5, pushed into the root viewport the way the keyboard's arrives: the slice's own quick restart.
func _restart_by_f5() -> Dictionary:
	var before: Dictionary = _state()
	await _until_neutral()
	_push_key(KEY_F5, true)
	_quiet()
	_push_key(KEY_F5, false)
	await _settle(3)
	await _await_process_frames(3)
	var first: PrototypeGraveblade = slice.graveblades[0]
	var second: PrototypeGraveblade = slice.graveblades[1]
	return {
		"before": before, "after": _state(), "reason": _last_log("slice restarted"),
		"first": [first.is_alive(), first.life, first.data.max_life], "second": [second.is_alive(), second.life, second.data.max_life],
		"player": [slice.player.is_alive(), slice.player.life, slice.player.max_life],
		"countdown": slice._fallen_countdown, "pending_null": slice._pending_fallen_event == null,
	}


## The controller live, the character 1.0 m from the drop: the highlight and nameplate read, then (A) pressed
## to open the comparison and Escape pressed to close it.
func _interact(tag: String) -> Dictionary:
	var player: PrototypePlayer = slice.player
	var forward: Vector3 = _forward()
	await _until_neutral()
	_quiet()
	_stand_facing(_drop_position + forward * NEAR_DROP, forward)
	await _settle(2)
	await _to_controller()
	await _await_process_frames(4)
	var drop: FirstMvpItemDrop = slice._active_drop
	var result: Dictionary = {
		"tag": tag, "controller": slice.input_family.family == InputFamilyTracker.Family.CONTROLLER,
		"in_range": drop != null and drop.player_is_in_range(player.global_position),
		"highlight": drop != null and drop.soft_selected, "nameplate": slice._nameplate.visible, "prompt": _prompt(),
	}
	var opens: int = slice.item_comparison.opens
	var logged: int = _log_count("item comparison opened")
	_push_joy(JOY_BUTTON_A, true)
	_push_joy(JOY_BUTTON_A, false)
	await _await_process_frames(3)
	result["opened"] = slice.item_comparison.is_open and slice.item_comparison.opens == opens + 1 and _log_count("item comparison opened") == logged + 1
	result["paused_while_open"] = paused
	var closes: int = slice.item_comparison.closes
	_push_key(KEY_ESCAPE, true)
	_push_key(KEY_ESCAPE, false)
	await _await_process_frames(3)
	result["closed"] = not slice.item_comparison.is_open and slice.item_comparison.closes == closes + 1 and not paused
	result["equipped"] = String(slice.loadout.equipped_weapon.weapon_id)
	result["drop_kept"] = drop != null and is_instance_valid(drop) and slice._active_drop == drop
	_note("%s: the controller made live, the character placed %.1f m from the drop, (A) pushed to open the comparison and Escape to close it" % [tag, NEAR_DROP])
	return result


## STAGED start, real Hits: the controller live, the character 1.0 m from the drop and the second Graveblade
## 1.2 m ahead of it, each attack begun through its own seam. Inside the delay (A) is pushed; then the
## overlay is left to open by itself.
func _fall_near_the_drop() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var killer: PrototypeGraveblade = slice.graveblades[1]
	var forward: Vector3 = _forward()
	var stand: Vector3 = _drop_position + forward * NEAR_DROP
	await _until_neutral()
	_quiet()
	_stand_facing(stand, forward)
	killer.place_at(stand + forward * NEAR)
	killer.face_instantly(-forward)
	await _settle(2)
	await _to_controller()
	await _await_process_frames(4)
	var drop: FirstMvpItemDrop = slice._active_drop
	var record: Dictionary = {
		"began": 0, "trail": [], "living_highlight": drop != null and drop.soft_selected, "living_nameplate": slice._nameplate.visible,
		"controller": slice.input_family.family == InputFamilyTracker.Family.CONTROLLER,
	}
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
	record["dead"] = not player.is_alive()
	record["from_killer"] = event != null and event.source == killer
	if not bool(record["dead"]):
		return record
	await _await_process_frames(3)
	record["in_delay"] = {
		"countdown": slice._fallen_countdown, "overlay": slice.fallen_overlay.is_open, "paused": paused,
		"nameplate": slice._nameplate.visible, "highlight": drop != null and drop.soft_selected, "prompt": _prompt(),
	}
	var opens: int = slice.item_comparison.opens
	var logged: int = _log_count("item comparison opened")
	_push_joy(JOY_BUTTON_A, true)
	_push_joy(JOY_BUTTON_A, false)
	await _await_process_frames(2)
	record["a_in_delay"] = {
		"opened": slice.item_comparison.is_open or slice.item_comparison.opens != opens, "logged": _log_count("item comparison opened") - logged,
		"countdown": slice._fallen_countdown, "overlay": slice.fallen_overlay.is_open,
	}
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var overlay_opens: int = overlay.opens
	for frame: int in 900:
		if overlay.is_open:
			break
		await process_frame
	var focus: Control = overlay.default_focus()
	record["overlay"] = {
		"open": overlay.is_open, "once": overlay.opens == overlay_opens + 1, "source": overlay.killing_source, "paused": paused,
		"focused": focus != null and root.gui_get_focus_owner() == focus,
	}
	_note("the Fallen: the second Graveblade placed %.1f m ahead of the character, who stood %.1f m from the drop with the controller live, each attack begun through begin_attack_for_verification(); (A) pushed inside the delay" % [NEAR, NEAR_DROP])
	return record


## Enter on the overlay's focused Restart — J3's accepted route.
func _restart_by_confirm() -> Dictionary:
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var before: Dictionary = _state()
	var restarts: int = _log_count("slice restarted")
	var closes: int = overlay.closes
	_push_key(KEY_ENTER, true)
	var result: Dictionary = {
		"closed_once": not overlay.is_open and overlay.closes == closes + 1, "restarted_once": _log_count("slice restarted") == restarts + 1,
		"alive": slice.player.is_alive(), "countdown": slice._fallen_countdown, "pending_null": slice._pending_fallen_event == null,
	}
	_quiet()
	_push_key(KEY_ENTER, false)
	await _settle(3)
	await _await_process_frames(3)
	var first: PrototypeGraveblade = slice.graveblades[0]
	var second: PrototypeGraveblade = slice.graveblades[1]
	result["before"] = before
	result["after"] = _state()
	result["enemies"] = [first.is_alive() and is_equal_approx(first.life, first.data.max_life), second.is_alive() and is_equal_approx(second.life, second.data.max_life)]
	result["player"] = [slice.player.life, slice.player.max_life]
	return result


# --- 6–13. What the play in Gate 1D measured ------------------------------------------------------

func _check_a_real_first_graveblade_death_names_the_player_as_source_and_the_graveblade_as_target() -> void:
	print("")
	print("--- 6. A real death: the player's own Quick Strikes kill the first Graveblade, and the event it dies with names the player as its source and the Graveblade as its target")
	var kill: Dictionary = _play["first_kill"]
	var heard: Array = kill["heard"]
	var death: Dictionary = heard[0] if heard.size() == 1 else {}
	_expect(bool(kill["dead"]) and _floats(kill["trail"]) == "300, 200, 100, 0" and is_equal_approx(float(kill["damage"]), 100.0)
			and heard.size() == 1 and not bool(death.get("supplementary", true))
			and int(death.get("source_id", 0)) == _player_id and int(death.get("target_id", 0)) == _first_id,
		"dead %s, Life %s at %s damage; %d emission(s) heard; source is the player: %s; target is the first Graveblade: %s"
			% [str(kill["dead"]), _floats(kill["trail"]), str(kill["damage"]), heard.size(),
				str(int(death.get("source_id", 0)) == _player_id), str(int(death.get("target_id", 0)) == _first_id)])
	print("  3 real Quick Strikes at %s damage took the first Graveblade %s; it emitted died once, with an event whose source is the player — the attacker — and whose target is the first Graveblade"
		% [_n(float(kill["damage"])), _floats(kill["trail"]).replace(", ", " -> ")])
	_done("a_real_first_graveblade_death_names_the_player_as_source_and_the_graveblade_as_target")


func _check_the_production_connection_carries_the_exact_first_graveblade() -> void:
	print("")
	print("--- 7. The production connection: the first Graveblade's died is connected to the callback exactly once, carrying that same Graveblade as its one bound argument; the second is not connected")
	var slice_id: int = slice.get_instance_id()
	var faults: PackedStringArray = PackedStringArray()
	for when: String in ["connections_at_load", "connections_after_second_kill", "connections_at_end"]:
		var connections: Dictionary = _play[when]
		var first: Array = connections["first"]
		var second: Array = connections["second"]
		var one: Dictionary = first[0] if first.size() == 1 else {}
		if not (first.size() == 1 and int(one.get("object_id", 0)) == slice_id and int(one.get("count", -1)) == 1
				and (one.get("bound", []) as Array) == [_first_id] and second.is_empty()):
			faults.append("%s: first %s, second %s" % [when, _connection_words(first), _connection_words(second)])
	_expect(faults.is_empty(), "%s — the connection must carry the first Graveblade itself" % "; ".join(faults))
	var at_load: Dictionary = _play["connections_at_load"]
	var carried: Array = at_load["first"]
	var same: bool = carried.size() == 1 and ((carried[0] as Dictionary)["bound"] as Array) == [_first_id]
	print("  at load, after the second Graveblade's kill and at the end: the first Graveblade's died -> %s() on the slice, %s — %s; the second Graveblade's: %s"
		% [CALLBACK, _connection_words(carried), "the first Graveblade itself, by instance id" if same else "NOT the first Graveblade", _connection_words(at_load["second"])])
	_done("the_production_connection_carries_the_exact_first_graveblade")


func _check_the_rewarded_set_holds_the_defeated_graveblade_and_not_the_attacker() -> void:
	print("")
	print("--- 8. After the real death the rewarded set holds the defeated Graveblade's instance id and not the player's")
	var after: Dictionary = _play["after_first_kill"]
	var kill: Dictionary = _play["first_kill"]
	var heard: Array = kill["heard"]
	var at_emission: Array = (heard[0] as Dictionary).get("rewarded", []) if heard.size() == 1 else []
	var rewarded: Array = after["rewarded"]
	_expect(rewarded == [_first_id] and at_emission == [_first_id] and not rewarded.has(_player_id) and bool(after["granted"]),
		"the rewarded set holds %s; the first Graveblade is %d and the player — the attacker — %d; at the emission it held %s"
			% [str(rewarded), _first_id, _player_id, str(at_emission)])
	print("  the rewarded set holds %s as the slice's callback left it, and held %s when the died emission reached the harness; the drop latch is %s"
		% [_who(rewarded), _who(at_emission), "set" if bool(after["granted"]) else "NOT set"])
	_done("the_rewarded_set_holds_the_defeated_graveblade_and_not_the_attacker")


func _check_exactly_one_watchsteel_drop_lies_where_the_unchanged_route_resolves_it() -> void:
	print("")
	print("--- 9. Exactly one guaranteed Watchsteel drop, placed by the unchanged route: the fallen Graveblade's position resolved onto the navigation mesh")
	var after: Dictionary = _play["after_first_kill"]
	var drop: Dictionary = _play["drop"]
	var kill: Dictionary = _play["first_kill"]
	var heard: Array = kill["heard"]
	var death: Dictionary = heard[0] if heard.size() == 1 else {}
	var at: Vector3 = drop["at"]
	var expected: Vector3 = death.get("expected_drop", Vector3.INF)
	var fallen: Vector3 = death.get("at", Vector3.INF)
	var resolved_gap: float = _planar_gap(at, expected) if expected != Vector3.INF else -1.0
	var fallen_gap: float = _planar_gap(at, fallen) if fallen != Vector3.INF else -1.0
	_expect(int(after["drops"]) == 1 and int(after["placed_lines"]) == 1 and int(death.get("drops", 0)) == 1
			and String(drop["name"]) == "GuaranteedDrop" and String(drop["weapon"]) == WATCHSTEEL_SWORD and String(drop["display"]) == "Watchsteel Sword"
			and is_equal_approx(float(drop["range"]), 2.20) and resolved_gap >= 0.0 and resolved_gap < 0.001 and is_zero_approx(at.y)
			and fallen_gap >= 0.0 and fallen_gap < 1.0,
		"%d drop(s) created, %d placement line(s); %s carrying %s; %.4f m from the resolved point, %.3f m from the fallen Graveblade"
			% [int(after["drops"]), int(after["placed_lines"]), String(drop["name"]), String(drop["weapon"]).get_file(), resolved_gap, fallen_gap])
	print("  1 drop created and 1 placement line; GuaranteedDrop carries the Watchsteel Sword, interaction range %.2f m; it lies %.4f m from the point PrototypeGroundPointer.resolve_to_navigation() gives for the fallen Graveblade's position, on the ground, %.3f m from where it fell"
		% [float(drop["range"]), resolved_gap, fallen_gap])
	_done("exactly_one_watchsteel_drop_lies_where_the_unchanged_route_resolves_it")


func _check_a_repeated_death_signal_naming_another_attacker_is_refused_as_the_same_graveblade() -> void:
	print("")
	print("--- 10. SUPPLEMENTARY: the same Graveblade's died emitted again with the SECOND Graveblade as the attacker is refused as that Graveblade's duplicate, with no second drop and no reward mutation")
	var record: Dictionary = _play["re_emission"]
	var before: Dictionary = record["before"]
	var after: Dictionary = record["after"]
	var heard: Array = record["heard"]
	var death: Dictionary = heard[0] if heard.size() == 1 else {}
	_expect(bool(record["source_is_second"]) and bool(record["target_is_first"]) and heard.size() == 1 and bool(death.get("supplementary", false))
			and int(death.get("source_id", 0)) == _second_id and int(death.get("target_id", 0)) == _first_id,
		"the emission was not the one described: %s" % str(death))
	_expect((after["rewarded"] as Array) == (before["rewarded"] as Array) and (after["rewarded"] as Array) == [_first_id]
			and int(after["duplicate_lines"]) == int(before["duplicate_lines"]) + 1 and int(after["latch_lines"]) == int(before["latch_lines"]),
		"the rewarded set went %s -> %s; the duplicate refusal was written %d time(s) and the latch refusal %d — a new attacker was counted as a new rewarded enemy"
			% [str(before["rewarded"]), str(after["rewarded"]), int(after["duplicate_lines"]) - int(before["duplicate_lines"]),
				int(after["latch_lines"]) - int(before["latch_lines"])])
	_expect(int(after["drops"]) == int(before["drops"]) and int(after["placed_lines"]) == int(before["placed_lines"])
			and int(after["drop_id"]) == int(before["drop_id"]) and int(after["drop_id"]) != 0 and bool(after["granted"]),
		"%d drop(s) created and %d placement line(s) added; the same drop: %s; latched: %s"
			% [int(after["drops"]) - int(before["drops"]), int(after["placed_lines"]) - int(before["placed_lines"]),
				str(int(after["drop_id"]) == int(before["drop_id"])), str(after["granted"])])
	print("  the harness emitted it; the slice's callback wrote '%s' %d more time(s) and '%s' %d; the rewarded set went from %s to %s"
		% [DUPLICATE_LINE, int(after["duplicate_lines"]) - int(before["duplicate_lines"]), LATCH_LINE,
			int(after["latch_lines"]) - int(before["latch_lines"]), _who(before["rewarded"]), _who(after["rewarded"])])
	print("  %d drop(s) created and %d placement line(s) written; the same drop still lies there: %s; the latch is %s"
		% [int(after["drops"]) - int(before["drops"]), int(after["placed_lines"]) - int(before["placed_lines"]),
			str(int(after["drop_id"]) == int(before["drop_id"])), "set" if bool(after["granted"]) else "NOT set"])
	_done("a_repeated_death_signal_naming_another_attacker_is_refused_as_the_same_graveblade")


func _check_the_second_graveblade_stays_outside_the_guaranteed_drop_connection() -> void:
	print("")
	print("--- 11. The second Graveblade stays outside the connection: its real death reaches no reward")
	var kill: Dictionary = _play["second_kill"]
	var before: Dictionary = kill["before"]
	var after: Dictionary = kill["after"]
	var heard: Array = kill["heard"]
	var death: Dictionary = heard[0] if heard.size() == 1 else {}
	var at_load: Array = (_play["connections_at_load"] as Dictionary)["second"]
	var afterwards: Array = (_play["connections_after_second_kill"] as Dictionary)["second"]
	_expect(at_load.is_empty() and afterwards.is_empty() and bool(kill["dead"]) and _floats(kill["trail"]) == "300, 200, 100, 0"
			and heard.size() == 1 and int(death.get("source_id", 0)) == _player_id and int(death.get("target_id", 0)) == _second_id,
		"connections %s / %s; dead %s, Life %s; %d emission(s)" % [str(at_load), str(afterwards), str(kill["dead"]), _floats(kill["trail"]), heard.size()])
	_expect((after["rewarded"] as Array) == (before["rewarded"] as Array) and int(after["refused_lines"]) == int(before["refused_lines"])
			and int(after["placed_lines"]) == int(before["placed_lines"]) and int(after["drops"]) == int(before["drops"])
			and int(after["drop_id"]) == int(before["drop_id"]),
		"the second Graveblade's death changed the rewarded set %s -> %s, refusals %d, placements %d, drops %d"
			% [str(before["rewarded"]), str(after["rewarded"]), int(after["refused_lines"]) - int(before["refused_lines"]),
				int(after["placed_lines"]) - int(before["placed_lines"]), int(after["drops"]) - int(before["drops"])])
	print("  the second Graveblade's died has no connection to %s(); 3 real Quick Strikes took it %s and its death — the player as source — changed nothing: the same set, no refusal, no placement, no drop"
		% [CALLBACK, _floats(kill["trail"]).replace(", ", " -> ")])
	_done("the_second_graveblade_stays_outside_the_guaranteed_drop_connection")


func _check_a_restart_revives_both_and_a_second_real_kill_is_refused_without_a_second_drop() -> void:
	print("")
	print("--- 12. F5 restarts the slice as accepted, keeping the drop and the latch; a second real kill of the first Graveblade is refused as its duplicate")
	var f5: Dictionary = _play["f5"]
	var before: Dictionary = f5["before"]
	var after: Dictionary = f5["after"]
	var first: Array = f5["first"]
	var second: Array = f5["second"]
	var player: Array = f5["player"]
	_expect(int(after["restarts"]) == int(before["restarts"]) + 1 and String(f5["reason"]).contains("quick restart")
			and bool(first[0]) and is_equal_approx(float(first[1]), float(first[2])) and bool(second[0]) and is_equal_approx(float(second[1]), float(second[2]))
			and bool(player[0]) and is_equal_approx(float(player[1]), float(player[2]))
			and float(f5["countdown"]) < 0.0 and bool(f5["pending_null"]),
		"restarts %d -> %d (%s); first %s, second %s, player %s; countdown %s" % [int(before["restarts"]), int(after["restarts"]),
			String(f5["reason"]), str(first), str(second), str(player), str(f5["countdown"])])
	_expect((after["rewarded"] as Array) == (before["rewarded"] as Array) and bool(after["granted"]) and int(after["drop_id"]) == int(before["drop_id"])
			and int(after["drop_id"]) != 0 and int(after["drops"]) == int(before["drops"]),
		"the restart moved the set %s -> %s, the latch %s, the drop %s, drops %d"
			% [str(before["rewarded"]), str(after["rewarded"]), str(after["granted"]), str(int(after["drop_id"]) == int(before["drop_id"])),
				int(after["drops"]) - int(before["drops"])])
	var again: Dictionary = _play["kill_again"]
	var a_before: Dictionary = again["before"]
	var a_after: Dictionary = again["after"]
	var heard: Array = again["heard"]
	var death: Dictionary = heard[0] if heard.size() == 1 else {}
	_expect(bool(again["dead"]) and _floats(again["trail"]) == "300, 200, 100, 0" and heard.size() == 1
			and int(death.get("source_id", 0)) == _player_id and int(death.get("target_id", 0)) == _first_id
			and int(a_after["duplicate_lines"]) == int(a_before["duplicate_lines"]) + 1 and int(a_after["latch_lines"]) == int(a_before["latch_lines"])
			and int(a_after["placed_lines"]) == int(a_before["placed_lines"]) and int(a_after["drops"]) == int(a_before["drops"])
			and (a_after["rewarded"] as Array) == (a_before["rewarded"] as Array) and int(a_after["drop_id"]) == int(a_before["drop_id"]),
		"second kill: dead %s, Life %s; duplicate %d, latch %d, placements %d, drops %d; set %s -> %s"
			% [str(again["dead"]), _floats(again["trail"]), int(a_after["duplicate_lines"]) - int(a_before["duplicate_lines"]),
				int(a_after["latch_lines"]) - int(a_before["latch_lines"]), int(a_after["placed_lines"]) - int(a_before["placed_lines"]),
				int(a_after["drops"]) - int(a_before["drops"]), str(a_before["rewarded"]), str(a_after["rewarded"])])
	print("  F5 restarted the slice once ('quick restart'): both Graveblades and the player back at full Life, no Fallen armed; the same drop, the latch and the rewarded set kept")
	print("  3 real Quick Strikes took the revived first Graveblade %s; its death was refused as a duplicate of the same Graveblade — no second drop, no placement, the same set" % _floats(again["trail"]).replace(", ", " -> "))
	_done("a_restart_revives_both_and_a_second_real_kill_is_refused_without_a_second_drop")


func _check_the_fallen_delay_item_interaction_and_highlight_behave_as_accepted() -> void:
	print("")
	print("--- 13. The Fallen delay, item interaction and the drop's highlight behave as accepted: in range with the controller live the drop is highlighted and (A) opens the comparison; inside the delay the highlight and nameplate clear and (A) opens nothing; after Restart all of it is back")
	var alive: Dictionary = _play["alive_interaction"]
	var fallen: Dictionary = _play["fallen"]
	_expect(_interaction_true(alive), "before the Fallen: %s" % str(alive))
	var in_delay: Dictionary = fallen.get("in_delay", {})
	var a_in_delay: Dictionary = fallen.get("a_in_delay", {})
	var overlay: Dictionary = fallen.get("overlay", {})
	_expect(bool(fallen.get("dead", false)) and bool(fallen.get("from_killer", false)) and int(fallen.get("began", 0)) == 4
			and _floats(fallen.get("trail", [])) == "375, 250, 125, 0" and bool(fallen.get("living_highlight", false)) and bool(fallen.get("living_nameplate", false))
			and bool(fallen.get("controller", false)),
		"the Fallen: dead %s, by the killer %s, %d attacks, Life %s, highlight before %s" % [str(fallen.get("dead")), str(fallen.get("from_killer")),
			int(fallen.get("began", 0)), _floats(fallen.get("trail", [])), str(fallen.get("living_highlight"))])
	_expect(float(in_delay.get("countdown", -1.0)) > 0.0 and float(in_delay.get("countdown", -1.0)) <= 0.90 and not bool(in_delay.get("overlay", true))
			and not bool(in_delay.get("paused", true)) and not bool(in_delay.get("nameplate", true)) and not bool(in_delay.get("highlight", true))
			and String(in_delay.get("prompt", "x")).is_empty()
			and not bool(a_in_delay.get("opened", true)) and int(a_in_delay.get("logged", 1)) == 0 and float(a_in_delay.get("countdown", -1.0)) > 0.0
			and not bool(a_in_delay.get("overlay", true)),
		"inside the delay: %s; (A): %s" % [str(in_delay), str(a_in_delay)])
	_expect(bool(overlay.get("open", false)) and bool(overlay.get("once", false)) and String(overlay.get("source", "")) == KILLING_SOURCE
			and bool(overlay.get("paused", false)) and bool(overlay.get("focused", false)),
		"the overlay: %s" % str(overlay))
	var restart: Dictionary = _play.get("overlay_restart", {})
	var r_before: Dictionary = restart.get("before", {})
	var r_after: Dictionary = restart.get("after", {})
	var restored: Dictionary = _play.get("restart_interaction", {})
	_expect(bool(restart.get("closed_once", false)) and bool(restart.get("restarted_once", false)) and bool(restart.get("alive", false))
			and float(restart.get("countdown", 0.0)) < 0.0 and bool(restart.get("pending_null", false))
			and (restart.get("enemies", []) as Array) == [true, true] and not r_after.is_empty()
			and (r_after["rewarded"] as Array) == (r_before["rewarded"] as Array) and bool(r_after["granted"])
			and int(r_after["drop_id"]) == int(r_before["drop_id"]) and int(r_after["drops"]) == int(r_before["drops"])
			and _interaction_true(restored),
		"Restart: %s; after it: %s" % [str(restart), str(restored)])
	print("  before the Fallen, controller live and %.1f m from the drop: the drop highlighted, its nameplate shown, (A) opened the comparison (the world paused) and Escape closed it; the %s stayed equipped and the drop stayed" % [NEAR_DROP, _starting_weapon])
	print("  4 real Graveblade Hits took Life %s; inside the delay, %.3f s left and the overlay not open, the highlight and nameplate were cleared, the prompt empty, and (A) opened nothing"
		% [_floats(fallen.get("trail", [])).replace(", ", " -> "), float(in_delay.get("countdown", -1.0))])
	print("  the overlay then opened once by itself — \"%s\", paused, its restart focused; Enter restarted the slice once, both Graveblades and the player alive, the same drop, latch and set" % String(overlay.get("source", "")))
	print("  after the Restart, controller live and %.1f m from the drop: highlighted again, the nameplate shown, (A) opened the comparison and Escape closed it" % NEAR_DROP)
	_done("the_fallen_delay_item_interaction_and_highlight_behave_as_accepted")


func _interaction_true(result: Dictionary) -> bool:
	return (bool(result.get("controller", false)) and bool(result.get("in_range", false)) and bool(result.get("highlight", false))
		and bool(result.get("nameplate", false)) and String(result.get("prompt", "")).contains("(A) Inspect")
		and bool(result.get("opened", false)) and bool(result.get("paused_while_open", false)) and bool(result.get("closed", false))
		and String(result.get("equipped", "")) == _starting_weapon and bool(result.get("drop_kept", false)))


# --- 14–15. The roguelite, played; Gate 1E, read ------------------------------------------------

## The Roguelite Core Loop's own scene, loaded as it ships; every enemy's died connections read.
func _play_the_core_loop() -> void:
	slice = null
	var loop: RogueliteCoreLoopRuntime = await _load(CORE_LOOP_SCENE) as RogueliteCoreLoopRuntime
	if loop == null:
		return
	await _await_navigation(loop)
	var enemies: Array = []
	var total: int = 0
	for index: int in loop.room_enemies.size():
		for enemy: PrototypeGraveblade in loop.room_enemies[index]:
			total += 1
			enemies.append({
				"name": String(enemy.name), "index": index, "id": enemy.get_instance_id(),
				"gate_1d": _bound_connections(enemy, CALLBACK), "own": _bound_connections(enemy, CORE_LOOP_CALLBACK),
			})
	var drops: int = 0
	for node: Node in (loop.get_node("Actors") as Node).get_children():
		if node is FirstMvpItemDrop:
			drops += 1
	_loop = {
		"loop_id": loop.get_instance_id(), "enemies": enemies, "total": total, "listed": loop.graveblades.size(),
		"broken_watch_null": loop.broken_watch == null, "granted": loop._drop_granted, "rewarded": loop._rewarded_enemies.size(), "drops": drops,
	}
	_note("the Roguelite Core Loop's own scene loaded as it ships after Gate 1D's, and every enemy's died connections read")


func _check_the_roguelite_core_loop_binds_its_own_enemies_and_never_connects_the_callback() -> void:
	print("")
	print("--- 14. The Roguelite Core Loop, loaded as it ships: every enemy is bound into its own %s(), and none is connected to Gate 1D's %s()" % [CORE_LOOP_CALLBACK, CALLBACK])
	var faults: PackedStringArray = PackedStringArray()
	for entry: Variant in _loop["enemies"] as Array:
		var enemy: Dictionary = entry
		var own: Array = enemy["own"]
		var one: Dictionary = own[0] if own.size() == 1 else {}
		if not ((enemy["gate_1d"] as Array).is_empty() and own.size() == 1 and int(one.get("object_id", 0)) == int(_loop["loop_id"])
				and int(one.get("count", -1)) == 2 and (one.get("bound", []) as Array) == [int(enemy["index"]), int(enemy["id"])]):
			faults.append("%s: gate 1d %s, own %s" % [String(enemy["name"]), _connection_words(enemy["gate_1d"]), _connection_words(own)])
	_expect(faults.is_empty() and int(_loop["total"]) > 0 and int(_loop["total"]) == int(_loop["listed"]),
		"%s; %d enemies in rooms, %d listed" % ["; ".join(faults), int(_loop["total"]), int(_loop["listed"])])
	_expect(bool(_loop["broken_watch_null"]) and not bool(_loop["granted"]) and int(_loop["rewarded"]) == 0 and int(_loop["drops"]) == 0,
		"broken_watch null %s, latch %s, rewarded %d, drops %d" % [str(_loop["broken_watch_null"]), str(_loop["granted"]), int(_loop["rewarded"]), int(_loop["drops"])])
	print("  %d enemies across its rooms: each died connected once to %s() on the runtime, with 2 bound arguments — its room index and the enemy itself — and none to %s()"
		% [int(_loop["total"]), CORE_LOOP_CALLBACK, CALLBACK])
	print("  broken_watch is null, the inherited drop latch unset, the rewarded set empty and no ground item placed: Gate 1D's guaranteed drop is not reachable from this scene")
	_done("the_roguelite_core_loop_binds_its_own_enemies_and_never_connects_the_callback")


func _check_gate_1e_inherits_the_binding_by_structure_only_and_is_not_run() -> void:
	print("")
	print("--- 15. Gate 1E inherits the bound connection by structure only; its scene is not run here and nothing of it is measured")
	var code: String = _bare(FileAccess.get_file_as_string(OPENING_SCRIPT))
	var ready: PackedStringArray = _code_lines(_function_body(code, "_ready"))
	var experience: String = _function_body(code, "_connect_experience")
	var super_at: int = ready.find("await super._ready()")
	var experience_at: int = ready.find("_connect_experience()")
	_expect(code.contains("extends BrokenWatchSlice") and super_at >= 0 and experience_at > super_at
			and not code.contains("func %s(" % CALLBACK) and not code.contains("func _spawn_graveblades(") and not code.contains(CALLBACK)
			and experience.contains("enemy.died.connect(func(") and _opening_nodes == 0,
		"extends %s; super at %d, _connect_experience at %d; the scene entered the tree %d time(s)"
			% [str(code.contains("extends BrokenWatchSlice")), super_at, experience_at, _opening_nodes])
	print("  canonical_opening_runtime.gd extends BrokenWatchSlice and awaits super._ready() before _connect_experience(): the slice's bound connection is made first and its own experience listeners after, as before; it redeclares neither the callback nor _spawn_graveblades()")
	print("  structural only: Gate 1E's scene never entered the tree in this run, and nothing of Gate 1E is measured here")
	_done("gate_1e_inherits_the_binding_by_structure_only_and_is_not_run")


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


# --- Readings ----------------------------------------------------------------------------------

## Every connection of `enemy`'s died to `method`: the object it calls, how many arguments it carries bound,
## and each bound argument — an Object by its instance id, anything else as it is.
func _bound_connections(enemy: PrototypeGraveblade, method: String) -> Array:
	var found: Array = []
	for connection: Dictionary in enemy.died.get_connections():
		var callable: Callable = connection["callable"]
		if callable.get_method() != method:
			continue
		var bound: Array = []
		for value: Variant in callable.get_bound_arguments():
			if value is Object:
				bound.append((value as Object).get_instance_id())
			else:
				bound.append(value)
		found.append({"object_id": callable.get_object_id(), "count": callable.get_bound_arguments_count(), "bound": bound})
	return found


func _connection_words(connections: Array) -> String:
	if connections.is_empty():
		return "none"
	var words: PackedStringArray = PackedStringArray()
	for entry: Variant in connections:
		var one: Dictionary = entry
		words.append("%d bound %s" % [int(one["count"]), str(one["bound"])])
	return ", ".join(words)


## A set of instance ids, named by what each one is in this run.
func _who(ids: Array) -> String:
	if ids.is_empty():
		return "nothing"
	var names: PackedStringArray = PackedStringArray()
	for id: Variant in ids:
		if int(id) == _first_id:
			names.append("the first Graveblade's id")
		elif int(id) == _player_id:
			names.append("the PLAYER's id — the attacker")
		elif int(id) == _second_id:
			names.append("the SECOND Graveblade's id")
		else:
			names.append("an unknown id %d" % int(id))
	return "[%s]" % ", ".join(names)


func _prompt() -> String:
	return slice.hud._prompt_label.text if slice.hud._prompt_panel.visible else ""


func _sorted(values: Array) -> Array:
	var copy: Array = values.duplicate()
	copy.sort()
	return copy


func _floats(values: Variant) -> String:
	var words: PackedStringArray = PackedStringArray()
	for value: Variant in values as Array:
		words.append(_n(float(value)))
	return ", ".join(words)


func _n(value: float) -> String:
	if is_equal_approx(value, roundf(value)):
		return "%d" % roundi(value)
	return "%.2f" % value


func _planar_gap(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()


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


func _on_node_added(node: Node) -> void:
	if node is CanonicalOpeningRuntime:
		_opening_nodes += 1


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


func _await_navigation(room: BrokenWatchSlice) -> void:
	for frame: int in 900:
		if NavigationServer3D.map_get_iteration_id(room.navigation_map()) > 0:
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


# --- The keyboard and the controller -------------------------------------------------------------

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


## One joypad axis pushed into the root viewport only. The Input singleton never sees it, so the InputMap's
## stick actions — which the character moves by — stay at rest.
func _push_axis(axis: JoyAxis, value: float) -> void:
	var event: InputEventJoypadMotion = InputEventJoypadMotion.new()
	event.device = 0
	event.axis = axis
	event.axis_value = value
	root.push_input(event)


## The input-family tracker ignores a change inside its own anti-flicker cooldown; wait it out.
func _family_cooldown() -> void:
	var tracker: InputFamilyTracker = slice.input_family
	for frame: int in 60:
		if tracker._time_since_switch > tracker.switch_cooldown_seconds + 0.02:
			return
		await process_frame


## STAGED: one left-stick deflection past the tracker's 0.20 threshold, and its return to rest, pushed into
## the root viewport. The Input singleton never sees it, so the character does not move.
func _to_controller() -> void:
	if slice.input_family.family == InputFamilyTracker.Family.CONTROLLER:
		return
	await _family_cooldown()
	_push_axis(JOY_AXIS_LEFT_X, 0.5)
	_push_axis(JOY_AXIS_LEFT_X, 0.0)
	for frame: int in 30:
		if slice.input_family.family == InputFamilyTracker.Family.CONTROLLER:
			break
		await process_frame
	_note("the controller made the live family by one left-stick deflection pushed into the root viewport, which the Input singleton never sees")


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
