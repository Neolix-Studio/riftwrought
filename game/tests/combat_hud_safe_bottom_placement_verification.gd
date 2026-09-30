extends SceneTree
## First-MVP UI J8 — Player Resource Column Safe-Bottom Placement V1: automated verification (decision D-336).
##
## THE ONE QUESTION: is the combat HUD's player resource column — the Life and Mana labels and bars — wholly
## inside the window, 24 px in from its left and bottom edges, from its first laid-out frame on, and does it
## stay there through every update, forced layout pass, Life and Mana change, the Fallen delay and a
## restart? Before J8 it was not (D-333): the 94 px column's top edge was written 80 px above the bottom
## edge, so its lowest 14 px — most of the 24 px Mana bar — lay below the window.
##
## THE HUD IS THE ONLY PRODUCTION FILE J8 MOVES, by one line of `_build()` replaced with a comment and five
## layout lines, and that is proved by reconstruction: with the replacement put back it is, byte for byte,
## the D-335 file.
##
## THE DEFECT IS MEASURED IN EVERY RUN, NOT ONLY IN THE BASELINE. The pre-J8 HUD is rebuilt from that
## reconstruction, bound to the same player and laid out beside the live one on its own canvas layer, far
## below the window, where its column still reaches 14 px past its viewport's bottom edge. Every rect inside
## the two columns is compared: only the column's vertical position may differ.
##
## GATE 1D'S OWN `broken_watch_slice.tscn`, LOADED AS IT SHIPS. Mana is spent by the player's own Quick
## Strikes, Life is taken by the production Graveblade's own attacks, Fallen and Restart are the slice's, the
## hover is opened by the pointer's own route, and the prompt and the message are written by the slice.
##
## GEOMETRY IS READ FROM THE COLUMN'S BIRTH. A harness hook sees the live column enter the tree and records
## every rect it takes and every sort it runs; a harness node before every other node reads both HUDs at the
## start of each process update — the state the previous frame's layout flush left, which is the state that
## frame drew.
##
## STAGED, AND STATED WHERE IT HAPPENS:
##   - both Graveblades are quieted; the first is placed ahead of the player and struck by the player's own
##     Quick Strikes, aimed through the slice's seam `force_next_aim_for_verification()`; the second is
##     placed 1.2 m ahead of the player before its attacks, each begun through `begin_attack_for_verification()`;
##   - the player's `mana_regeneration` is held at 0 from the first Quick Strike until the restart, so that
##     Mana stands at 85 / 100 through the Life readings, and again while Mana is spent to zero after the
##     restart; each time it is put back;
##   - every mouse event the harness sends carries its own device id, and a filter holds back every other;
##   - the controller is made the live family by one left-stick deflection pushed into the root viewport;
##   - extra layout passes are forced with `queue_sort()` and `update_minimum_size()`;
##   - the pre-J8 comparison HUD is shown the same hover enemy, prompt and message as the live one;
##   - in a window, where the slice reads the operating system's own cursor and the harness never moves it,
##     the harness calls `show_hover()` after the slice on each update instead — the pointer-route hover
##     measurement is then the headless run's, and the run says so.
##
## Input is simulated, which is not physical-device certification. With `--shots <dir>` the run also saves
## three evidence frames; they add no assertion, so the rendered runs pin the same count.
##
## IT PORTS D-211's OWED-SET DISCIPLINE.
##
## Run: godot --headless --path game --script res://tests/combat_hud_safe_bottom_placement_verification.gd

const THIS_FILE: String = "res://tests/combat_hud_safe_bottom_placement_verification.gd"
const HUD_SCRIPT: String = "res://scripts/ui/first_mvp_combat_hud.gd"
const SLICE_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
const SLICE_SCENE: String = "res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31
const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]

## The HUD as D-335 left it, whole, and J8's one replaced line. The pair is [as J8 wrote it, as D-335 left it];
## it carries the lines around the replacement so that it is unique.
const PRE_J8_HUD_SHA256: String = "38c485cb76ee34ad42f885289a193bb5a5c812e41bc74c4a47793da09e95218d"
const J8_HUD_PREFIX: String = "ee485029"
const J8_REPLACED_LINE: String = "resources.position = Vector2(24, -80)"
const J8_BLOCK: String = "\t# First-MVP UI J8 (decision D-336): the column is anchored by its bottom edge,\n\t# 24 px above the viewport's, and grows upward to its own height. A top edge\n\t# 80 px above the bottom left the 94 px column's last 14 px below the window.\n\tresources.offset_left = 24.0\n\tresources.offset_top = -24.0\n\tresources.offset_right = 24.0\n\tresources.offset_bottom = -24.0\n\tresources.grow_vertical = Control.GROW_DIRECTION_BEGIN\n"
const J8_CODE_LINES: Array[String] = [
	"resources.offset_left = 24.0", "resources.offset_top = -24.0", "resources.offset_right = 24.0",
	"resources.offset_bottom = -24.0", "resources.grow_vertical = Control.GROW_DIRECTION_BEGIN",
]
const J8_HUD_MOVES: Array = [
	["\tresources.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)\n\t# First-MVP UI J8 (decision D-336): the column is anchored by its bottom edge,\n\t# 24 px above the viewport's, and grows upward to its own height. A top edge\n\t# 80 px above the bottom left the 94 px column's last 14 px below the window.\n\tresources.offset_left = 24.0\n\tresources.offset_top = -24.0\n\tresources.offset_right = 24.0\n\tresources.offset_bottom = -24.0\n\tresources.grow_vertical = Control.GROW_DIRECTION_BEGIN\n\tresources.add_theme_constant_override(\"separation\", 6)\n",
		"\tresources.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)\n\tresources.position = Vector2(24, -80)\n\tresources.add_theme_constant_override(\"separation\", 6)\n"],
]
## The HUD's declarations, as D-335 left them.
const HUD_FIELDS: int = 12
const HUD_FUNCTIONS: int = 12
const HUD_CONSTANTS: int = 10

## The accepted look, typed independently of the code that draws it. J8 moves only the column's vertical
## placement: 24 px from the left edge as before, and now 24 px above the bottom edge.
const ACCEPTED_LEFT_INSET: float = 24.0
const ACCEPTED_BOTTOM_INSET: float = 24.0
## Where the pre-J8 HUD wrote the column's top edge, above the bottom edge.
const PRE_J8_TOP: float = 80.0
const ACCEPTED_COLUMN_HEIGHT: float = 94.0
const ACCEPTED_SEPARATION: int = 6
const ACCEPTED_BAR_WIDTH: float = 260.0
const ACCEPTED_BAR_HEIGHT: float = 22.0
const ACCEPTED_HOVER_WIDTH: float = 190.0
const ACCEPTED_LIFE: Color = Color(0.78, 0.26, 0.24)
const ACCEPTED_MANA: Color = Color(0.30, 0.52, 0.82)
const ACCEPTED_SLATE: Color = Color(0.075, 0.082, 0.098, 0.90)
const ACCEPTED_IRON: Color = Color(0.28, 0.30, 0.35)
const ACCEPTED_TEXT_DIM: Color = Color(0.55, 0.58, 0.64)
## The three other surfaces, each from its own anchor: the prompt from the bottom centre, the message from the
## top-left corner and the hover panel from the top centre.
const ACCEPTED_PROMPT_OFFSET: Vector2 = Vector2(-150.0, -140.0)
const ACCEPTED_MESSAGE_POSITION: Vector2 = Vector2(24.0, 24.0)
const ACCEPTED_HOVER_OFFSET: Vector2 = Vector2(-110.0, 18.0)
## Measured widths are compared to their truthful widths within this many pixels, and edges to their
## accepted places within this many.
const WIDTH_TOLERANCE: float = 0.01
const PLACE_TOLERANCE: float = 0.01

## Verification Maintenance V1 (decision D-342): every pair list this suite uses to put a file back lives in
## the flat, content-addressed provenance store under res://tests/provenance/, named by the SHA-256 of its
## listing. Each `*_ROWS` and `*_MOVE_IDS` constant below names its pair lists, and the variable of the old name
## holds them resolved, so every check reads exactly as before. They are resolved through the one engine there,
## and only while it is at the SHA-256 pinned here; a pair list the store cannot prove resolves to nothing.
const PROVENANCE_ENGINE: String = "res://tests/provenance/accepted_suite_provenance.gd"
const PROVENANCE_ENGINE_SHA256: String = "fadbdfeba32546d03bffe876c2b8be7a96dfe966ff9f5d4f720199d664b23dc4"

## The thirteen accepted suite files J8 moved, each put back to exactly what it was at the end of D-335. Each
## row is [path, its J8 prefix, its D-335 SHA-256, pairs of (as J8 wrote it, as D-335 left it)].
const MOVED_SUITE_ROWS: Array = [
	["res://tests/fallen_modal_life_state_verification.gd", "d5407c7c", "eb7f41539d9ebd4949c487748e8566d8b1503be78ca639951a8c2e3f63ea51b6", "3cfd6d4749e5e801664da0874fa7f571855f0c1c4d08a671cab93b6317b27503"],
	["res://tests/pending_fallen_restart_verification.gd", "1062c1db", "520d954315e360b93d96155ae68576ac8d951127656d892ef5553cd194e77e08", "da1e53b3a7be5c836b449eca6af9d6e422484f5f6b87c7dbde858f1b24e91e70"],
	["res://tests/pending_fallen_restart_smoke.sh", "689284cc", "67cf7ba9cd468401870b88977ba45d97db62f61c0201b6da0aca7dbcfb8ff2f8", "3ac248809645192bb948960935d03919041698fc4db7f88ca5f870e21a321cc6"],
	["res://tests/fallen_delay_item_interaction_verification.gd", "3deeb26a", "611891a30e8c16e1315c320b9d6d76b525bdd3fd5526a5c44a8508aa75c70cec", "1b66d63242bdd82fa624b7795247d40b5d49999ac005af40d8c6f9e110d8b4fd"],
	["res://tests/fallen_delay_item_interaction_smoke.sh", "cb520369", "d7cf44986c6a3e1adbcb7ca48b1f9a5756c43df05f197f24a6f35198bff2c122", "604de133e29e7eef2e1abf4ea9985e367acebef9edffb68acffd93037a9cd1cd"],
	["res://tests/fallen_delay_drop_highlight_verification.gd", "c9648eea", "44ed4bdf8a1ea10fd32fd6a0af22ad3f750d4b289cab6fa040bc5c0abac9726e", "2f183d917da224b1f1c738cecdb042c1b6914458223313b9ccab9c172342cab7"],
	["res://tests/fallen_delay_drop_highlight_smoke.sh", "d2772373", "aeba508d2f1a5d5a2257ca1ad86cd92b4bf3eb1b15cb34808b377ffb5f2ff271", "91be8fd4c3616aeb9c7eba0c78b18d0ab1a69976bd32e02381fece5c5b07da06"],
	["res://tests/combat_hud_fractional_fill_verification.gd", "333c1674", "423858a2871b9dbffbf407872fb0e3b6046bdc23e4ebad8d5d5693c8833a1564", "61a6826eb355330ffe0f0a1b01de1a5a00610dffe228fe4281334edc306b20c6"],
	["res://tests/combat_hud_fractional_fill_smoke.sh", "a5744db6", "1c2f1d125b146ccd0bdb6cd50bbdb7e49eb05aee24bad3193ec6d8067d5825fb", "44e7bb67e3e3a4c915521426a40b746124ccdc9fd1e565f94f946e2f2dec76d7"],
	["res://tests/enemy_hover_life_fractional_fill_verification.gd", "fde101de", "5063a690c40a7082e56b3d07bf27e3da12e74268a43718bd06681b7063ade577", "2139302d665ea92358793a55e54d10f245292ad1124c2ab3b7fd0f501e14e6e1"],
	["res://tests/enemy_hover_life_fractional_fill_smoke.sh", "5aa1ec83", "ab84b56b73b2b9e9fbe2c54b2d2053a70d07de74f0249eaae826f6678033d7ed", "077311bd4c853b03eda8fb1e2eb6ab37830a1b8844f2b09132581db672b8c112"],
	["res://tests/global_damage_live_application_smoke.sh", "ccef4a26", "803b8a7facb3ce39a646d53d9a9a0670380e0cfb2f74499be58acf502f832b60", "728cbef5f603dffb7ad472008dd703ad760ab628ce803675b6d7ff118687b2c2"],
	["res://tests/maximum_life_live_application_smoke.sh", "e3887f96", "657c0b1786106a65a00dd3b3a994fe662b35c15b10c6205bfc76e1cbdf65279f", "728cbef5f603dffb7ad472008dd703ad760ab628ce803675b6d7ff118687b2c2"],
]
var MOVED_SUITES: Array = _stored(MOVED_SUITE_ROWS)
const MOVED_SUITE_COUNT: int = 13

## First-MVP Gameplay J9 (D-338) moved eleven of the thirteen files above again, one for one, when Gate 1D's
## slice moved. Each is first put back to where D-337 left it and then read exactly as before: `J9_PREFIXES`
## holds each file's J9 prefix, and `J9_MOVES` its pairs of [as J9 wrote it, as D-337 left it], applied to that
## file alone.
const J9_PREFIXES: Dictionary = {
	"res://tests/fallen_modal_life_state_verification.gd": "6acc1e0c",
	"res://tests/pending_fallen_restart_verification.gd": "dc9be60f",
	"res://tests/pending_fallen_restart_smoke.sh": "ec5bc37f",
	"res://tests/fallen_delay_item_interaction_verification.gd": "eff592af",
	"res://tests/fallen_delay_item_interaction_smoke.sh": "e14e996b",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "b735e6c7",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "fea9988e",
	"res://tests/combat_hud_fractional_fill_verification.gd": "d38624c8",
	"res://tests/combat_hud_fractional_fill_smoke.sh": "a444af4b",
	"res://tests/enemy_hover_life_fractional_fill_verification.gd": "2187ccb1",
	"res://tests/enemy_hover_life_fractional_fill_smoke.sh": "22a95042",
}
const J9_MOVE_IDS: Dictionary = {
	"res://tests/fallen_modal_life_state_verification.gd": "fb8d9401ba6c004b0d1e1997f866d76602e5b423be361ff06b383bafc3cc1749",
	"res://tests/pending_fallen_restart_verification.gd": "1a4d7f01639d1180ba3e70a49c8ce4e9c0a1843a82055d515465b366aecc64d8",
	"res://tests/pending_fallen_restart_smoke.sh": "d4f4a6ada9acac4c6a846830bc9283e4d5c4537f03d7a61b32b185a18dad22fb",
	"res://tests/fallen_delay_item_interaction_verification.gd": "155bdaf5bb4dd9b2169b9e4139f9fe758fd3bf98e82add80617e3443f37d5639",
	"res://tests/fallen_delay_item_interaction_smoke.sh": "cec36c2a16824f2215ee25fae06ada08a06280f275458c0013c362e50f33d2c9",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "2f98d83b3abfcaf89832fd0cdf85f33821a4d19b71be7245eb44ea4b86f48c9a",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "8cb05e6397960b68217afa5590a8afa96d4dfaf7b96a6f4696575569624b2ae8",
	"res://tests/combat_hud_fractional_fill_verification.gd": "86abd8bd53ea5d192fa12a838124423248a3c1680cec3a94a48ecac028f0737b",
	"res://tests/combat_hud_fractional_fill_smoke.sh": "7b137652580a630468db24b8f3a1580f5fa3b4d9565e6d389c16739f94d1e4c3",
	"res://tests/enemy_hover_life_fractional_fill_verification.gd": "44167fbbce75ad4fd4f58849b6170b163ad74cd85c9c5cb5cedcce25bda094c4",
	"res://tests/enemy_hover_life_fractional_fill_smoke.sh": "7922a0ed566ffb229e9f5cb79b5ad2490e3bd06c22e7c38f80061b41947637c1",
}
var J9_MOVES: Dictionary = _stored(J9_MOVE_IDS)

## First-MVP Gameplay J10 (D-340) moved eleven of the thirteen files above again, one for one, when Gate 1D's
## slice's restart came to end the movement command it carried. Each is first put back to where D-339 left it
## and then read exactly as before: `J10_PREFIXES` holds each file's J10 prefix, and `J10_MOVES` its pairs of
## [as J10 wrote it, as D-339 left it], applied to that file alone.
const J10_PREFIXES: Dictionary = {
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
}
const J10_MOVE_IDS: Dictionary = {
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
}
var J10_MOVES: Dictionary = _stored(J10_MOVE_IDS)

## Verification Maintenance V1 (D-342) moved seven of the files above again, one for one, when their put-back pairs
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
}
const VM1_MOVE_IDS: Dictionary = {
	"res://tests/fallen_delay_item_interaction_verification.gd": "e48a940f496b486a4e3d29945413a32e72c92d04cc1b53079b43b091c391d8ac",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "b3d27bc2dfc663e6044e81edefed212ca94fac1bcc6efd90695f63ef7729b948",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "6c2fd3b783af50c704bf5eadd9ef796f0d6f633b26e674cf5f653c37ce6a3487",
	"res://tests/combat_hud_fractional_fill_verification.gd": "9f53188f095270661035ffaa398236fd02494e252d347aad0fa108759fe2a35c",
	"res://tests/combat_hud_fractional_fill_smoke.sh": "d014f5ed85cb9a293875956a2606972b00398e1f4be9eeb51fb123a470b82662",
	"res://tests/enemy_hover_life_fractional_fill_verification.gd": "8f8804a3e2969b275a632186b8a886da3a0c8e115c37d0de1ceddd209b9be71a",
	"res://tests/enemy_hover_life_fractional_fill_smoke.sh": "d9d34c41ca3a049ffd0b7fe664806ce399309123362f05e01c8097cdc43ccd9c",
}
var VM1_MOVES: Dictionary = _stored(VM1_MOVE_IDS)

## First-MVP Gameplay J11 (D-344) moved Gate 1D's slice and the accepted suite files above again, one for one,
## when the slice came to open Riftfall Landing's Watch Breach far cap in this composition. Each is first put
## back to where D-343 left it and then read exactly as before: `J11_PREFIXES` holds each file's J11 prefix, and
## `J11_MOVES` its pairs of [as J11 wrote it, as D-343 left it], named in `J11_MOVE_IDS` and applied to that file
## alone.
const J11_PREFIXES: Dictionary = {
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
}
const J11_MOVE_IDS: Dictionary = {
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
}
var J11_MOVES: Dictionary = _stored(J11_MOVE_IDS)

## Everything J8 stands beside, at the SHA-256 prefix each held before the first J8 edit.
const UNCHANGED_HASHES: Array = [
	["res://scripts/actors/prototype_player.gd", "80e38838"],
	## First-MVP Gameplay J9 (D-338) moved Gate 1D's slice one for one, from `f83e9436`, so that its guaranteed
	## drop counts the Graveblade that died rather than the attacker. Same count.
	## First-MVP Gameplay J10 (D-340) moved it again, from `942aee83`, so that a restart leaves the character
	## standing at Broken Watch's entry. Same count.
	## First-MVP Gameplay J11 (D-344) moved it again, from `883ef25e`, so that Riftfall Landing's Watch Breach
	## far cap no longer seals the composed route into Broken Watch. Same count.
	["res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd", "d4e839fb"],
	["res://scripts/ui/first_mvp_modal.gd", "1cfe9c73"],
	["res://scripts/ui/first_mvp_fallen_overlay.gd", "de5e1ab0"],
	["res://scripts/roguelite/roguelite_fallen_overlay.gd", "1753e7b7"],
	["res://scripts/ui/first_mvp_item_comparison.gd", "3607f9f7"],
	["res://scripts/ui/canonical_opening_hud.gd", "9cb0d622"],
	["res://scripts/roguelite/roguelite_run_hud.gd", "7f0ac70c"],
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
	["res://scripts/actors/graveblade_target_area.gd", "5604633c"],
	["res://scripts/combat/quick_strike_action.gd", "e6514705"],
	["res://scripts/combat/quick_strike_data.gd", "50bfabfc"],
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
	["res://scenes/roguelite/roguelite_replayability_review.tscn", "c8c9ec68"],
	["res://scenes/roguelite/roguelite_build_variety_review.tscn", "32b4beff"],
	["res://data/prototype_zero/graveblade.tres", "56317f5f"],
	["res://data/prototype_zero/quick_strike.tres", "76060315"],
	["res://data/first_mvp/severed_threshold/broken_watch/starting_sword.tres", "08e97d2e"],
	["res://data/first_mvp/severed_threshold/broken_watch/watchsteel_sword.tres", "e67730b2"],
	["res://project.godot", "55351038"],
	["res://tests/gate_1d_broken_watch_verification.gd", "9393f97a"],
	["res://tests/gate_1d_broken_watch_smoke.sh", "6f2878f7"],
	["res://tests/gate_1e_canonical_opening_verification.gd", "cef72cb6"],
	## First-MVP Gameplay J9 (D-338) moved J1's verification one for one, from `8c0e290c`, when Gate 1D's
	## slice moved. Same count.
	## First-MVP Gameplay J10 (D-340) moved it again, from `acbd3892`, when Gate 1D's slice moved. Same count.
	["res://tests/first_mvp_modal_left_click_verification.gd", "d12ad271"],
	["res://tests/first_mvp_modal_left_click_smoke.sh", "977c05bd"],
	["res://tests/fallen_modal_life_state_smoke.sh", "9e0977fb"],
	["res://tests/roguelite_core_loop_verification.gd", "1c8e60d7"],
	["res://tests/global_damage_live_application_verification.gd", "6fb05fb7"],
	["res://tests/maximum_life_live_application_verification.gd", "d2cd143b"],
]
## The scenes that instance the HUD, by path, and the HUDs that share the screen with it in Gate 1E and the
## roguelite runtimes.
const HUD_SCENES: Array[String] = [
	"res://scenes/first_mvp/canonical_opening/canonical_opening.tscn",
	"res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn",
	"res://scenes/roguelite/roguelite_build_variety_review.tscn",
	"res://scenes/roguelite/roguelite_core_loop.tscn",
	"res://scenes/roguelite/roguelite_replayability_review.tscn",
]
const NEIGHBOUR_HUDS: Array[String] = [
	"res://scripts/ui/canonical_opening_hud.gd", "res://scripts/roguelite/roguelite_run_hud.gd",
	"res://scripts/roguelite/replayability/roguelite_replayability_hud.gd", "res://scripts/roguelite/build_variety/roguelite_build_variety_hud.gd",
]

## The accepted words, typed independently of the code that shows them.
const KILLING_SOURCE: String = "Graveblade — Melee Hit — 125 Physical Damage"
const RESTART_CAPTION: String = "Restart Broken Watch"
const WALK_CLOSER: String = "Walk closer to inspect it"
const DROP_NAME: String = "Watchsteel Sword"

const NEAR_DROP: float = 1.0
const FAR_DROP: float = 4.0
const NEAR: float = 1.2
const FAR_AWAY: float = 14.0
## Inside the delay: the evidence frame, then a forced layout pass, each at the first frame with no more
## than this much of the delay left.
const SHOT_AT: float = 0.85
const LAYOUT_AT: float = 0.62
## Where the harness's pre-J8 HUD is drawn: far below the window, so it is never seen and never hovered.
const SHADOW_OFFSET: Vector2 = Vector2(0.0, 100000.0)

const PROBE_SOURCE: String = "extends Node\nvar ticks: int = 0\nvar on_tick: Callable\n\nfunc _process(_delta: float) -> void:\n\tticks += 1\n\tif on_tick.is_valid():\n\t\ton_tick.call(ticks)\n"
const HARNESS_DEVICE: int = 3360
const FILTER_SOURCE: String = "extends Node\nvar device: int = 0\nvar held: int = 0\n\nfunc _input(event: InputEvent) -> void:\n\tif event is InputEventMouse and event.device != device:\n\t\theld += 1\n\t\tget_viewport().set_input_as_handled()\n"

const OWED_CHECKS: Array[String] = [
	"the_production_diff_is_exactly_the_authorized_column_placement",
	"the_accepted_suites_moved_only_their_pins_and_reconstructions",
	"only_build_changed_and_the_column_is_placed_by_its_anchors_offsets_and_grow_alone",
	"the_hud_reaches_gate_1d_and_its_runtimes_by_instancing_only",
	"no_player_combat_scene_input_map_or_project_behaviour_changed",
	"the_pre_j8_reconstruction_still_clips_the_lowest_14_px",
	"from_its_first_laid_out_frame_the_whole_column_is_inside_the_window",
	"later_updates_and_forced_layout_passes_never_move_the_column",
	"full_partial_and_zero_life_and_mana_keep_their_j6_fill_widths",
	"the_enemy_hover_life_fill_keeps_its_j7_widths",
	"the_fallen_delay_and_the_overlay_neither_move_nor_clip_the_column",
	"a_normal_restart_restores_full_resources_without_moving_the_column",
	"the_columns_internal_geometry_is_the_pre_j8_huds",
	"the_prompt_message_and_hover_surfaces_keep_their_positions",
]

var arguments: PackedStringArray = PackedStringArray()
var slice: BrokenWatchSlice

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _staged: PackedStringArray = PackedStringArray()
var _shot_dir: String = ""
var _shots: PackedStringArray = PackedStringArray()
var _token: String = ""

var _pre: Node = null
var _post: Node = null
var _filter: Node = null
## The harness's pre-J8 HUD and the canvas layer it lives on.
var _shadow: Control = null
var _shadow_layer: CanvasLayer = null
var _shadow_built: Dictionary = {}

## The live column's entry into the tree, every rect it took after that and every sort it ran; and every
## reading the pre-slice probe took of both HUDs, in order.
var _birth: Dictionary = {}
var _column_rects: Array = []
var _column_sorts: Array = []
var _sampling: bool = false
var _samples: Array = []

var _readings: Dictionary = {}
var _forced: Array = []
var _hovers: Dictionary = {}
var _strikes: Array = []
var _death: Dictionary = {}
var _message: Dictionary = {}
var _drain: Dictionary = {}
var _drop_position: Vector3 = Vector3.INF
var _regeneration: float = 0.0

## How this run opens the hover: "pointer" when the slice reads the harness's pointer, "staged" when it reads
## the operating system's own cursor instead.
var _route: String = ""
var _route_point: Vector2 = Vector2.INF
var _route_read_back: Vector2 = Vector2.INF
## While true, the post-slice probe calls the live HUD's `show_hover()` with `_staged_target` (STAGED).
var _staging: bool = false
var _staged_target: PrototypeGraveblade = null
## The enemy the pre-J8 HUD is shown whenever the live panel is shown.
var _mirror_enemy: PrototypeGraveblade = null


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	_shot_dir = _argument_value("--shots")
	_token = _argument_value("--run-token")
	print("")
	print("=== First-MVP UI J8 — Player Resource Column Safe-Bottom Placement V1 verification (D-336) ===")
	print("  run token: %s" % (_token if not _token.is_empty() else "none given"))

	_check_the_production_diff_is_exactly_the_authorized_column_placement()
	_check_the_accepted_suites_moved_only_their_pins_and_reconstructions()
	_check_only_build_changed_and_the_column_is_placed_by_its_anchors_offsets_and_grow_alone()
	_check_the_hud_reaches_gate_1d_and_its_runtimes_by_instancing_only()
	_check_no_player_combat_scene_input_map_or_project_behaviour_changed()

	await _play()
	if slice != null:
		_check_the_pre_j8_reconstruction_still_clips_the_lowest_14_px()
		_check_from_its_first_laid_out_frame_the_whole_column_is_inside_the_window()
		_check_later_updates_and_forced_layout_passes_never_move_the_column()
		_check_full_partial_and_zero_life_and_mana_keep_their_j6_fill_widths()
		_check_the_enemy_hover_life_fill_keeps_its_j7_widths()
		_check_the_fallen_delay_and_the_overlay_neither_move_nor_clip_the_column()
		_check_a_normal_restart_restores_full_resources_without_moving_the_column()
		_check_the_columns_internal_geometry_is_the_pre_j8_huds()
		_check_the_prompt_message_and_hover_surfaces_keep_their_positions()

	_check_every_check_ran()
	_sampling = false
	_staging = false
	if node_added.is_connected(_on_node_added):
		node_added.disconnect(_on_node_added)
	if _post != null:
		_post.set("on_tick", Callable())
		_pre.set("on_tick", Callable())
		_pre.queue_free()
		_post.queue_free()
	if _shadow_layer != null:
		_shadow_layer.queue_free()
	await process_frame

	print("")
	print("  staged: %s" % "; ".join(_staged))
	if _filter != null:
		print("  foreign pointer events held back: %d — any from a real pointer on the window" % int(_filter.get("held")))
	for shot: String in _shots:
		print("  screenshot: %s" % shot)
	if _failures.is_empty():
		print("COMBAT HUD SAFE BOTTOM PLACEMENT VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("COMBAT HUD SAFE BOTTOM PLACEMENT VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		quit(1)


# --- 1–5. Structure: the one file, its one replaced line, its reach -------------------------------

func _check_the_production_diff_is_exactly_the_authorized_column_placement() -> void:
	print("")
	print("--- 1. Exactly one production file moved — the combat HUD — and it is the D-335 file with one line of _build() replaced by a comment and five layout lines")
	var source: String = FileAccess.get_file_as_string(HUD_SCRIPT)
	var digest: String = FileAccess.get_sha256(HUD_SCRIPT)
	var rebuilt: Dictionary = _put_back(source, J8_HUD_MOVES)
	var pre_text: String = String(rebuilt["text"])
	var lines_now: int = source.count("\n")
	var lines_then: int = pre_text.count("\n")
	_expect(digest.begins_with(J8_HUD_PREFIX) and bool(rebuilt["unique"]) and pre_text.sha256_text() == PRE_J8_HUD_SHA256
			and source.count(J8_BLOCK) == 1 and not source.contains(J8_REPLACED_LINE) and pre_text.count(J8_REPLACED_LINE) == 1
			and lines_now == lines_then + J8_BLOCK.count("\n") - 1 and (pre_text + "x").sha256_text() != PRE_J8_HUD_SHA256,
		"the HUD hashes %s; J8's block occurs %d time(s) and the replaced line %d time(s); the reconstruction is unique: %s and hashes %s"
			% [digest.left(8), source.count(J8_BLOCK), source.count(J8_REPLACED_LINE), str(rebuilt["unique"]), pre_text.sha256_text().left(8)])
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in UNCHANGED_HASHES:
		var held: String = FileAccess.get_sha256(String(row[0]))
		if not held.begins_with(String(row[1])):
			moved.append("%s %s" % [String(row[0]).get_file(), held.left(8)])
	_expect(moved.is_empty() and UNCHANGED_HASHES.size() == 54, "moved: %s" % ", ".join(moved))
	print("  the HUD is at its J8 hash %s, %d lines; with J8's %d lines put back to the one line they replaced it is, byte for byte, the D-335 file %s, %d lines"
		% [J8_HUD_PREFIX, lines_now, J8_BLOCK.count("\n"), PRE_J8_HUD_SHA256.left(8), lines_then])
	print("  %d files J8 stands beside hold the hashes they held before the first J8 edit: the player, Gate 1D's slice, the modal contract, both Fallen overlays, the comparison, the two HUDs beside this one, the drop, the loadout, all 7 descendants of the slice, Prototype Zero's room, the Graveblade and its target area, the combat, movement, camera and input kernels, the five scenes that instance the HUD and two more, four records, project.godot and nine accepted suite files; Gate 1D's slice and J1's verification since moved by J9 (D-338); the slice and J1's verification again, and Broken Watch's layout, since moved by J10 (D-340)"
		% UNCHANGED_HASHES.size())
	_done("the_production_diff_is_exactly_the_authorized_column_placement")


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


func _check_the_accepted_suites_moved_only_their_pins_and_reconstructions() -> void:
	print("")
	print("--- 2. The thirteen accepted suite files J8 had to move moved only their pins, reconstructions and truthful clauses, one for one, at unchanged counts — and J6's check 17 its placement assertion, by the owner's ruling")
	var faults: PackedStringArray = PackedStringArray()
	var blocks: int = 0
	var back: PackedStringArray = PackedStringArray()
	for row: Array in MOVED_SUITES:
		var path: String = row[0]
		var j10_text: String = _before_vm1(path, _before_j11(path, FileAccess.get_file_as_string(path)))
		var j9_text: String = _before_j10(path, j10_text)
		var j8_text: String = _before_j9(path, j9_text)
		var rebuilt: Dictionary = _put_back(j8_text, row[3])
		blocks += (row[3] as Array).size()
		back.append(String(row[2]).left(8))
		if not (FileAccess.get_sha256(path).begins_with(String(J11_PREFIXES.get(path, VM1_PREFIXES.get(path, J10_PREFIXES.get(path, J9_PREFIXES.get(path, row[1]))))))
				and j10_text.sha256_text().begins_with(String(J10_PREFIXES.get(path, J9_PREFIXES.get(path, row[1]))))
				and j9_text.sha256_text().begins_with(String(J9_PREFIXES.get(path, row[1]))) and j8_text.sha256_text().begins_with(String(row[1]))
				and bool(rebuilt["unique"]) and not (row[3] as Array).is_empty()
				and String(rebuilt["text"]).sha256_text() == String(row[2])
				and (String(rebuilt["text"]) + "x").sha256_text() != String(row[2])):
			faults.append("%s at %s rebuilds to %s" % [path.get_file(), FileAccess.get_sha256(path).left(8), String(rebuilt["text"]).sha256_text().left(8)])
	_expect(faults.is_empty() and MOVED_SUITES.size() == MOVED_SUITE_COUNT,
		"%d of %d moved suites described; %s" % [MOVED_SUITES.size(), MOVED_SUITE_COUNT, "; ".join(faults)])
	print("  J2's to J7's verifications moved their HUD pins, and J3's to J7's learned to put back what J8 moved before reading as before; J3's to J7's runners moved their hash rows, J5's its production digest and J6's and J7's their HUD reconstructions; I13's and I14's runners their HUD row: put back, the %d are byte for byte %s (%d replaced blocks)"
		% [MOVED_SUITES.size(), ", ".join(back), blocks])
	_done("the_accepted_suites_moved_only_their_pins_and_reconstructions")


func _check_only_build_changed_and_the_column_is_placed_by_its_anchors_offsets_and_grow_alone() -> void:
	print("")
	print("--- 3. Only _build() changed, by one line replaced with five layout lines: no branch, no viewport or window query and no per-frame placement; every other function is the D-335 one")
	var source: String = FileAccess.get_file_as_string(HUD_SCRIPT)
	var pre_text: String = String(_put_back(source, J8_HUD_MOVES)["text"])
	var functions: PackedStringArray = _declared_functions(source)
	var differing: PackedStringArray = PackedStringArray()
	for name: String in functions:
		if name != "_build" and _function_body(source, name) != _function_body(pre_text, name):
			differing.append(name)
	var build_now: PackedStringArray = _code_lines(_function_body(source, "_build"))
	var build_then: PackedStringArray = _code_lines(_function_body(pre_text, "_build"))
	var at: int = build_then.find(J8_REPLACED_LINE)
	var expected: PackedStringArray = build_then.duplicate()
	if at >= 0:
		expected.remove_at(at)
		for index: int in J8_CODE_LINES.size():
			expected.insert(at + index, J8_CODE_LINES[index])
	var inserted: PackedStringArray = _code_lines(J8_BLOCK)
	var tokens: PackedStringArray = PackedStringArray()
	for line: String in inserted:
		for token: String in ["if ", "match ", "get_viewport", "get_visible_rect", "size", "DisplayServer", "window", "1920", "1080", "1280", "720", "deferred", "_process"]:
			if line.contains(token):
				tokens.append("%s in %s" % [token, line])
	var code: String = _bare(source)
	var pre_code: String = _bare(pre_text)
	var fields: int = RegEx.create_from_string("(?m)^var ").search_all(source).size()
	var constants: int = RegEx.create_from_string("(?m)^const ").search_all(source).size()
	var signals: int = RegEx.create_from_string("(?m)^signal ").search_all(source).size()
	_expect(differing.is_empty() and at >= 0 and build_now == expected and functions == _declared_functions(pre_text)
			and functions.size() == HUD_FUNCTIONS and fields == HUD_FIELDS and constants == HUD_CONSTANTS and signals == 0
			and inserted == PackedStringArray(J8_CODE_LINES) and tokens.is_empty()
			and code.count("resources.") == pre_code.count("resources.") + J8_CODE_LINES.size() - 1
			and code.count("grow_vertical") == 1 and code.count("offset_") == 4 and not code.contains("resources.position")
			and not code.to_lower().contains("fallen") and not code.contains("player.is_alive"),
		"differing %s; _build %d lines against %d (at %d); %d functions, %d fields, %d constants, %d signals; inserted code %s; tokens %s"
			% [str(differing), build_now.size(), expected.size(), at, functions.size(), fields, constants, signals, str(inserted), str(tokens)])
	print("  _build(): the accepted %d code lines with exactly one replaced — %s — by five: %s" % [build_then.size(), J8_REPLACED_LINE, "; ".join(J8_CODE_LINES)])
	print("  the replacement reads no viewport, window or size, names no resolution, branches on nothing and defers nothing; the other %d functions are byte for byte the D-335 ones — _bar_row(), both width writers, show_hover() and _process() among them; %d functions, %d fields, %d constants, no signal"
		% [functions.size() - 1, functions.size(), fields, constants])
	_done("only_build_changed_and_the_column_is_placed_by_its_anchors_offsets_and_grow_alone")


func _check_the_hud_reaches_gate_1d_and_its_runtimes_by_instancing_only() -> void:
	print("")
	print("--- 4. What the line reaches (structural): every scene that instances the HUD, nothing that reaches its column, and nothing beside it anchored to the bottom-left corner")
	var scenes: PackedStringArray = PackedStringArray()
	for path: String in _files_under("res://scenes", [".tscn"]):
		if FileAccess.get_file_as_string(path).contains("path=\"%s\"" % HUD_SCRIPT):
			scenes.append(path)
	scenes.sort()
	var subclasses: PackedStringArray = PackedStringArray()
	var reachers: PackedStringArray = PackedStringArray()
	var corner: PackedStringArray = PackedStringArray()
	var scanned: int = 0
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd"]):
			if path == HUD_SCRIPT:
				continue
			scanned += 1
			var code: String = _uncommented(FileAccess.get_file_as_string(path))
			if code.contains("extends FirstMvpCombatHud"):
				subclasses.append(path.get_file())
			for token: String in ["get_node(\"Resources\")", "$Resources", "find_child(\"Resources\"", "get_node_or_null(\"Resources\")"]:
				if code.contains(token):
					reachers.append("%s:%s" % [path.get_file(), token])
			if NEIGHBOUR_HUDS.has(path):
				for preset: String in ["PRESET_BOTTOM_LEFT", "PRESET_BOTTOM_WIDE", "PRESET_LEFT_WIDE"]:
					if code.contains(preset):
						corner.append("%s:%s" % [path.get_file(), preset])
	_expect(scenes == PackedStringArray(HUD_SCENES) and subclasses.is_empty() and reachers.is_empty() and corner.is_empty() and scanned > 100,
		"scenes %s; subclasses %s; reaching the column %s; bottom-left neighbours %s" % [str(scenes), str(subclasses), str(reachers), str(corner)])
	print("  %d scenes instance the HUD: %s" % [scenes.size(), ", ".join(Array(scenes).map(func(p: String) -> String: return p.get_file()))])
	print("  of %d other running scripts none extends FirstMvpCombatHud or reaches its Resources column; of the %d HUDs that share the screen with it — canonical_opening_hud.gd, roguelite_run_hud.gd and its two extensions — none anchors anything to the bottom-left corner or the bottom or left edge"
		% [scanned, NEIGHBOUR_HUDS.size()])
	print("  canonical_opening.tscn is Gate 1E's scene, and the roguelite runtimes extend the slice: each inherits the new placement by instancing the same script — structural only, not measured here")
	_done("the_hud_reaches_gate_1d_and_its_runtimes_by_instancing_only")


func _check_no_player_combat_scene_input_map_or_project_behaviour_changed() -> void:
	print("")
	print("--- 5. The InputMap, the entrypoint and project.godot are untouched; the player, combat, scenes and records hold their pre-J8 hashes (check 1)")
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	var naming: PackedStringArray = PackedStringArray()
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd", ".tscn", ".tres"]):
			if FileAccess.get_file_as_string(path).contains("combat_hud_safe_bottom_placement"):
				naming.append(path)
	_expect(actions == EXPECTED_ACTIONS and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT
			and not settings.contains("[autoload]") and not settings.contains("combat_hud_safe_bottom_placement") and naming.is_empty(),
		"%d actions, or project.godot moved, or a running file names the harness: %s" % [actions, str(naming)])
	print("  %d actions; the entrypoint is %s; project.godot declares no [autoload]; nothing that runs names the J8 harness" % [actions, ENTRYPOINT.get_file()])
	_done("no_player_combat_scene_input_map_or_project_behaviour_changed")


# --- The play, in Gate 1D's own slice ---------------------------------------------------------

func _play() -> void:
	node_added.connect(_on_node_added)
	_install_probes()
	_sampling = true
	slice = await _load(SLICE_SCENE) as BrokenWatchSlice
	if slice == null:
		return
	await _await_navigation()
	_install_shadow()
	_install_filter()
	_quiet()
	_note("Gate 1D's two Graveblades quieted; a harness hook watched the live column enter the tree, and two harness nodes read every process update, one before the slice and one after it")
	var window: Vector2i = DisplayServer.window_get_size()
	var visible: Vector2 = root.get_visible_rect().size
	print("  display %s, window %dx%d, visible %dx%d" % [DisplayServer.get_name(), window.x, window.y, roundi(visible.x), roundi(visible.y)])
	if _shadow == null:
		return

	await _settle(2)
	await _await_process_frames(3)
	_readings["start"] = _read("start")
	_forced.append(await _force_layout("with both bars full"))
	var shot: String = await _capture("01_full_life_and_mana")
	if not shot.is_empty():
		_shots.append("%s — %s" % [shot, _shot_words()])

	await _mana_and_hover()
	if slice._active_drop == null:
		_failures.append("no guaranteed drop was created, so nothing after it can be measured")
		return
	_drop_position = slice._active_drop.global_position
	_death = await _strike_player()
	if not bool(_death.get("dead", false)):
		_failures.append("the second Graveblade's attacks did not kill the player, so the delay and the restart cannot be measured")
		return
	await _through_the_delay(_death)
	await _behind_the_overlay(_death)
	slice.player.mana_regeneration = _regeneration
	await _restart_by_confirm(_death)
	await _settle(3)
	await _await_process_frames(3)
	_readings["restart"] = _read("restart")
	await _walk_closer_message()
	await _drain_mana()
	_sampling = false


## The live column entering the tree: its anchors, offsets and grow directions as it arrives, and a record
## of every rect it takes and every sort it runs from then on.
func _on_node_added(node: Node) -> void:
	if not _birth.is_empty() or not (node is Control) or node.name != "Resources" or not (node.get_parent() is FirstMvpCombatHud):
		return
	var column: Control = node as Control
	_birth = {
		"process": Engine.get_process_frames(), "drawn": Engine.get_frames_drawn(), "rect": column.get_global_rect(),
		"viewport": root.get_visible_rect().size,
		"anchors": [column.anchor_left, column.anchor_top, column.anchor_right, column.anchor_bottom],
		"offsets": [column.offset_left, column.offset_top, column.offset_right, column.offset_bottom],
		"grow": [column.grow_horizontal, column.grow_vertical],
	}
	column.item_rect_changed.connect(func() -> void:
		_column_rects.append({"rect": column.get_global_rect(), "process": Engine.get_process_frames(), "drawn": Engine.get_frames_drawn(),
			"sample": _samples.size()}))
	column.sort_children.connect(func() -> void:
		_column_sorts.append({"rect": column.get_global_rect(), "process": Engine.get_process_frames(), "drawn": Engine.get_frames_drawn(),
			"sample": _samples.size()}))


func _install_probes() -> void:
	var script: GDScript = GDScript.new()
	script.source_code = PROBE_SOURCE
	script.reload()
	_pre = Node.new()
	_pre.name = "J8ProbeBeforeTheSlice"
	_pre.set_script(script)
	_pre.process_priority = -1000000
	_pre.process_mode = Node.PROCESS_MODE_ALWAYS
	_pre.set("on_tick", _on_pre_tick)
	_post = Node.new()
	_post.name = "J8ProbeAfterTheSlice"
	_post.set_script(script)
	_post.process_priority = 1000000
	_post.process_mode = Node.PROCESS_MODE_ALWAYS
	_post.set("on_tick", _on_post_tick)
	root.add_child(_pre)
	root.add_child(_post)


func _install_filter() -> void:
	var filter: GDScript = GDScript.new()
	filter.source_code = FILTER_SOURCE
	filter.reload()
	_filter = Node.new()
	_filter.name = "J8ForeignPointerFilter"
	_filter.set_script(filter)
	_filter.set("device", HARNESS_DEVICE)
	_filter.process_mode = Node.PROCESS_MODE_ALWAYS
	root.add_child(_filter)
	_note("every mouse event the harness sends carries device id %d, and a harness node ahead of the slice holds back every other mouse event" % HARNESS_DEVICE)


## The pre-J8 HUD: the D-335 source reconstructed from the file on disk, its `class_name` line dropped so it
## does not collide with the live class, bound to the same room, on its own canvas layer far below the
## window. It is a comparison instrument only; nothing in the slice knows it exists.
func _install_shadow() -> void:
	var source: String = String(_put_back(FileAccess.get_file_as_string(HUD_SCRIPT), J8_HUD_MOVES)["text"])
	_shadow_built = {"hash": source.sha256_text(), "class_line": source.count("class_name FirstMvpCombatHud\n")}
	if source.sha256_text() != PRE_J8_HUD_SHA256:
		_failures.append("the pre-J8 HUD could not be reconstructed (%s), so the comparison instrument was not built" % source.sha256_text().left(8))
		return
	var script: GDScript = GDScript.new()
	script.source_code = source.replace("class_name FirstMvpCombatHud\n", "")
	var compiled: Error = script.reload()
	_shadow_built["compiled"] = compiled
	if compiled != OK:
		_failures.append("the pre-J8 HUD did not compile (%d)" % compiled)
		return
	_shadow_layer = CanvasLayer.new()
	_shadow_layer.name = "J8PreJ8HudLayer"
	_shadow_layer.offset = SHADOW_OFFSET
	root.add_child(_shadow_layer)
	_shadow = Control.new()
	_shadow.name = "PreJ8Hud"
	_shadow.set_script(script)
	_shadow_layer.add_child(_shadow)
	_shadow.call("bind_room", slice)
	_note("the pre-J8 HUD, reconstructed from the HUD file with J8's replacement put back (%s), bound to the same player on a canvas layer offset %d px below the window and shown the same hover enemy, prompt and message as the live one, as a comparison instrument"
		% [PRE_J8_HUD_SHA256.left(8), int(SHADOW_OFFSET.y)])


func _on_pre_tick(tick: int) -> void:
	if not _sampling:
		return
	var scene: BrokenWatchSlice = current_scene as BrokenWatchSlice
	if scene == null or scene.hud == null or not scene.hud.is_inside_tree() or scene.hud.get_node_or_null("Resources") == null:
		return
	var player: PrototypePlayer = scene.player
	_samples.append({
		"tick": tick, "process": Engine.get_process_frames(), "drawn": Engine.get_frames_drawn(), "viewport": root.get_visible_rect().size,
		"live": _hud(scene.hud), "shadow": _hud(_shadow) if _shadow != null else {},
		"life": player.life, "max_life": player.max_life, "mana": player.mana, "max_mana": player.max_mana,
		"state": player.action_state_name(), "overlay": scene.fallen_overlay.is_open, "paused": paused, "countdown": scene._fallen_countdown,
	})


## After the slice has processed: the staged hover call, when this run stages its hover, and the pre-J8 HUD
## shown the same hover enemy, prompt and message as the live one.
func _on_post_tick(_tick: int) -> void:
	if slice == null or _shadow == null:
		return
	if _staging:
		slice.hud.show_hover(_staged_target)
	var enemy: PrototypeGraveblade = _mirror_enemy
	if enemy != null and not is_instance_valid(enemy):
		enemy = null
	_shadow.call("show_hover", enemy if slice.hud._hover_panel.visible else null)
	_shadow.call("show_item_prompt", slice.hud._prompt_label.text if slice.hud._prompt_panel.visible else "")
	var said: Label = slice.hud._message_label
	var mirrored: Label = _shadow.get("_message_label")
	if said.visible and (not mirrored.visible or mirrored.text != said.text):
		_shadow.call("show_message", said.text)


func _pre_ticks() -> int:
	return int(_pre.get("ticks")) if _pre != null else -1


## The first Graveblade placed ahead of the player; the hover read by the pointer's own route at full Life
## and after each of the first two Quick Strikes, which with the third take it 300 -> 200 -> 100 -> 0.
## Regeneration is held at 0 from the first strike until the restart.
func _mana_and_hover() -> void:
	var player: PrototypePlayer = slice.player
	var first: PrototypeGraveblade = slice.graveblades[0]
	var forward: Vector3 = _forward()
	first.place_at(slice.landing_layout.player_start() + forward * 6.0)
	first.face_instantly(-forward)
	await _settle(2)
	_stand_facing(first.global_position - forward * 1.0, forward)
	await _settle(10)
	await _await_process_frames(3)
	_note("the first Graveblade placed on Riftfall Landing's route and the player 1.0 m behind it, facing it")
	_regeneration = player.mana_regeneration
	player.mana_regeneration = 0.0
	_note("the player's mana_regeneration held at 0 from %s from the first Quick Strike until the restart, so Mana stands at 85 / 100 through the Life readings, then put back" % _n(_regeneration))
	_mirror_enemy = first
	_hovers["full"] = await _hover_stage("full", first)
	for hit: int in 3:
		_strikes.append(await _strike(first, hit + 1))
		if hit == 0:
			_hovers["two"] = await _hover_stage("two thirds", first)
		elif hit == 1:
			_hovers["one"] = await _hover_stage("one third", first)
	_mirror_enemy = null
	_note("the first Graveblade struck by the player's own Quick Strikes, aimed through force_next_aim_for_verification()")
	await _settle(3)
	await _await_process_frames(3)
	_readings["after_strikes"] = _read("after the strikes")


## One hover: the pointer over the enemy for six updates, then away for three.
func _hover_stage(tag: String, enemy: PrototypeGraveblade) -> Dictionary:
	var mark: int = _samples.size()
	var truthful: float = ACCEPTED_HOVER_WIDTH * clampf(enemy.life / maxf(enemy.data.max_life, 0.0001), 0.0, 1.0)
	var life: float = enemy.life
	await _point_at(enemy)
	await _await_process_frames(6)
	var open_end: int = _samples.size()
	await _away(3)
	return {"tag": tag, "life": life, "max": enemy.data.max_life, "truthful": truthful, "open": _samples.slice(mark, open_end),
		"away": _samples.slice(open_end)}


## STAGED aim, real attack: the player's own Quick Strike, aimed at the enemy through the slice's seam.
func _strike(enemy: PrototypeGraveblade, number: int) -> Dictionary:
	var player: PrototypePlayer = slice.player
	var forward: Vector3 = _forward()
	var area: PrototypeTargetable = enemy.get_node("TargetArea") as PrototypeTargetable
	_stand_facing(enemy.global_position - forward * 1.0, forward)
	await _settle(1)
	var before: float = enemy.life
	var spent: float = player.attack.mana_spent_total
	slice.force_next_aim_for_verification(area)
	player.attack.press()
	player.attack.release_input()
	for frame: int in 120:
		await physics_frame
		if enemy.life < before and player.attack.phase == QuickStrikeAction.Phase.READY:
			break
	await _settle(3)
	await _await_process_frames(3)
	var reading: Dictionary = _read("strike %d" % number)
	reading["enemy_before"] = before
	reading["enemy_after"] = enemy.life
	reading["spent"] = player.attack.mana_spent_total - spent
	return reading


## Moves the pointer over `enemy` through `Input.parse_input_event()`. The first time, it also decides this
## run's route: headless, the slice reads the pointer the event placed; in a window it reads the operating
## system's own cursor, which the harness never moves, and the run then stages the hover.
func _point_at(enemy: PrototypeGraveblade) -> void:
	if _route == "staged":
		_staged_target = enemy
		return
	var camera: Camera3D = slice.camera_rig.camera
	var point: Vector2 = camera.unproject_position(enemy.global_position + Vector3(0.0, 0.9, 0.0))
	var motion: InputEventMouseMotion = _motion_event(point)
	motion.relative = Vector2(8.0, 0.0)
	Input.parse_input_event(motion)
	if not _route.is_empty():
		return
	await _await_process_frames(1)
	_route_point = point
	_route_read_back = slice.get_viewport().get_mouse_position()
	if _route_read_back.distance_to(point) <= 1.0:
		_route = "pointer"
		return
	_route = "staged"
	_staging = true
	_staged_target = enemy
	_note("in this window the slice read the operating system's own cursor at (%d, %d), not the harness's pointer at (%d, %d), so every hover here is opened by the harness calling the live HUD's show_hover() after the slice on each update"
		% [roundi(_route_read_back.x), roundi(_route_read_back.y), roundi(point.x), roundi(point.y)])


func _away(updates: int) -> void:
	if _route == "staged":
		_staged_target = null
	else:
		var size: Vector2 = root.get_visible_rect().size
		var motion: InputEventMouseMotion = _motion_event(Vector2(size.x * 0.8, size.y * 0.3))
		motion.relative = Vector2(8.0, 0.0)
		Input.parse_input_event(motion)
	await _await_process_frames(updates)


## STAGED start, real Hits: the second Graveblade 1.2 m ahead of the character, who stands 1.0 m from the
## guaranteed drop; each attack begun through its own seam and each living Hit read three updates later.
func _strike_player() -> Dictionary:
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
	await _await_process_frames(3)
	_note("the living character placed %.1f m from the drop and the second Graveblade %.1f m ahead of it, each of its attacks begun through begin_attack_for_verification()" % [NEAR_DROP, NEAR])
	var record: Dictionary = {"trail": [], "began": 0, "hits": [], "fell": 0, "life_before": player.life, "mana_before": player.mana,
		"near": _read("near the drop")}
	var on_fell: Callable = func(event: DamageEvent) -> void:
		record["fell"] = int(record["fell"]) + 1
		record["at_kill"] = {"sample": _samples.size(), "countdown": slice._fallen_countdown, "pending": slice._pending_fallen_event == event}
	player.fell.connect(on_fell)
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
		if not player.is_alive():
			break
		await _await_process_frames(3)
		(record["hits"] as Array).append(_read("hit %d" % int(record["began"])))
		if int(record["began"]) == 2:
			var shot: String = await _capture("02_partial_life_and_mana")
			if not shot.is_empty():
				_shots.append("%s — %s" % [shot, _shot_words()])
	player.fell.disconnect(on_fell)
	var event: DamageEvent = player.last_damage_taken
	record["dead"] = not player.is_alive()
	record["from_killer"] = event != null and event.source == killer
	return record


## Every process frame of the delay until the overlay opens by itself: the evidence frame and one forced
## layout pass, each at the first frame with no more than its time left.
func _through_the_delay(record: Dictionary) -> void:
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var opens: int = overlay.opens
	var shot_taken: bool = false
	var laid: bool = false
	for frame: int in 900:
		if overlay.is_open:
			break
		if not _shot_dir.is_empty() and not shot_taken and slice._fallen_countdown > 0.0 and slice._fallen_countdown <= SHOT_AT:
			shot_taken = true
			var shot: String = await _capture("03_fallen_life_zero_mana_visible")
			if not shot.is_empty():
				_shots.append("%s — %s, %.3f s of the delay left, overlay %s" % [shot, _shot_words(), slice._fallen_countdown,
					"open" if overlay.is_open else "not open"])
		if not laid and slice._fallen_countdown > 0.0 and slice._fallen_countdown <= LAYOUT_AT:
			laid = true
			_forced.append(await _force_layout("inside the Fallen delay"))
		await process_frame
	record["open_sample"] = _samples.size()
	var focus: Control = overlay.default_focus()
	record["opened"] = {"once": overlay.is_open and overlay.opens == opens + 1, "source": overlay.killing_source, "paused": paused,
		"focused": focus != null and root.gui_get_focus_owner() == focus and focus.name == RESTART_CAPTION}


## Behind the standing overlay: 10 paused physics frames and 5 idle frames, one forced layout pass between.
func _behind_the_overlay(record: Dictionary) -> void:
	var mark: int = _samples.size()
	for frame: int in 10:
		await physics_frame
	_forced.append(await _force_layout("behind the Fallen overlay"))
	for frame: int in 5:
		await process_frame
	record["behind"] = {"mark": mark, "end": _samples.size(), "overlay": slice.fallen_overlay.is_open, "paused": paused}


## Enter on the overlay's focused "Restart Broken Watch" — J3's accepted route.
func _restart_by_confirm(record: Dictionary) -> void:
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var restarts: int = _log_count("slice restarted")
	var closes: int = overlay.closes
	record["restart_sample"] = _samples.size()
	_push_key(KEY_ENTER, true)
	record["restart"] = {
		"closed_once": not overlay.is_open and overlay.closes == closes + 1,
		"restarted_once": _log_count("slice restarted") == restarts + 1, "alive": slice.player.is_alive(),
		"countdown": slice._fallen_countdown, "pending_null": slice._pending_fallen_event == null,
	}
	_push_key(KEY_ENTER, false)
	_quiet()


## The slice's own message: with the controller live, (A) pressed 4.0 m from the drop.
func _walk_closer_message() -> void:
	var forward: Vector3 = _forward()
	await _until_neutral()
	_quiet()
	_stand_facing(_drop_position + forward * FAR_DROP, forward)
	await _settle(2)
	await _await_process_frames(3)
	await _to_controller()
	await _await_process_frames(3)
	var mark: int = _samples.size()
	_push_joy(JOY_BUTTON_A, true)
	_push_joy(JOY_BUTTON_A, false)
	await _await_process_frames(6)
	_message = {"mark": mark, "end": _samples.size(), "text": slice.hud._message_label.text, "visible": slice.hud._message_label.visible,
		"comparison": slice.item_comparison.is_open}
	_note("after the restart the character placed %.1f m from the drop and (A) pressed with the controller live" % FAR_DROP)


## STAGED: both Graveblades moved away behind the character, regeneration held at 0, and the player's own
## Quick Strike swung sideways at nothing until no Mana is left; then regeneration is put back.
func _drain_mana() -> void:
	var player: PrototypePlayer = slice.player
	var forward: Vector3 = _forward()
	var sideways: Vector3 = Vector3(-forward.z, 0.0, forward.x)
	_quiet()
	for enemy: PrototypeGraveblade in slice.graveblades:
		enemy.place_at(player.global_position - sideways * FAR_AWAY)
	await _until_neutral()
	player.face_instantly(sideways)
	await _settle(2)
	player.mana_regeneration = 0.0
	var dealt: int = player.attack.damage_events
	var swings: int = 0
	for swing: int in 30:
		if player.mana < 0.0001:
			break
		var spent: float = player.attack.mana_spent_total
		player.attack.press()
		player.attack.release_input()
		for frame: int in 120:
			await physics_frame
			if player.attack.mana_spent_total > spent and player.attack.phase == QuickStrikeAction.Phase.READY:
				break
		if player.attack.mana_spent_total > spent:
			swings += 1
	await _await_process_frames(3)
	_drain = {"swings": swings, "dealt": player.attack.damage_events - dealt, "reading": _read("Mana spent to zero")}
	player.mana_regeneration = _regeneration
	await _settle(30)
	await _await_process_frames(3)
	_readings["end"] = _read("regenerating after zero")
	_note("both Graveblades moved %.0f m behind the character, regeneration held at 0 and the player's own Quick Strike swung sideways at nothing %d times, then regeneration put back" % [FAR_AWAY, swings])


## STAGED extra layout passes on both HUDs' resource columns: every bar, its row and the column re-sorted,
## and every fill's and the column's minimum size re-announced; read after the engine has run them.
func _force_layout(tag: String) -> Dictionary:
	var sort_mark: int = _column_sorts.size()
	var mark: int = _samples.size()
	for hud: Control in [slice.hud, _shadow]:
		for which: String in ["life", "mana"]:
			var fill: ColorRect = hud.get("_%s_fill" % which)
			var background: Container = fill.get_parent() as Container
			background.queue_sort()
			(background.get_parent() as Container).queue_sort()
			fill.update_minimum_size()
		var column: Container = hud.get_node("Resources") as Container
		column.queue_sort()
		column.update_minimum_size()
	await _await_process_frames(3)
	_note("extra layout passes forced %s, on both HUDs, with queue_sort() on each bar, its row and the column and update_minimum_size() on each fill and the column" % tag)
	return {"tag": tag, "sorts": _column_sorts.slice(sort_mark), "samples": _samples.slice(mark), "reading": _read("forced layout %s" % tag)}


# --- 6–14. What the play measured -------------------------------------------------------------

func _check_the_pre_j8_reconstruction_still_clips_the_lowest_14_px() -> void:
	print("")
	print("--- 6. The pre-J8 HUD, rebuilt beside the live one, still draws its 94 px column from 80 px above the bottom edge: its lowest 14 px — most of the Mana bar — below the window")
	var faults: PackedStringArray = PackedStringArray()
	var compared: int = 0
	var first: Dictionary = {}
	for sample: Dictionary in _samples:
		var old: Dictionary = sample["shadow"]
		if old.is_empty():
			continue
		compared += 1
		if first.is_empty():
			first = sample
		var viewport: Vector2 = sample["viewport"]
		var column: Rect2 = old["column"]
		if (absf(column.position.y - (viewport.y - PRE_J8_TOP)) > PLACE_TOLERANCE or absf(column.size.y - ACCEPTED_COLUMN_HEIGHT) > PLACE_TOLERANCE
				or absf(column.position.x - ACCEPTED_LEFT_INSET) > PLACE_TOLERANCE):
			faults.append("tick %d: %s" % [int(sample["tick"]), str(column)])
			if faults.size() >= 3:
				break
	var below: float = 0.0
	var mana_below: float = 0.0
	var mana_height: float = 0.0
	var mana_top: float = 0.0
	if not first.is_empty():
		var viewport: Vector2 = first["viewport"]
		var old: Dictionary = first["shadow"]
		below = (old["column"] as Rect2).end.y - viewport.y
		var outer: Rect2 = old["mana"]["outer"]
		mana_below = outer.end.y - viewport.y
		mana_height = outer.size.y
		mana_top = outer.position.y
	_expect(faults.is_empty() and compared > 300 and absf(below - (ACCEPTED_COLUMN_HEIGHT - PRE_J8_TOP)) <= PLACE_TOLERANCE
			and absf(mana_height - (ACCEPTED_BAR_HEIGHT + 2.0)) <= PLACE_TOLERANCE and absf(mana_below - below) <= PLACE_TOLERANCE,
		"%d compared; below %s; Mana bar %s tall, %s below; faults %s" % [compared, _n(below), _n(mana_height), _n(mana_below), "; ".join(faults)])
	if not first.is_empty():
		var old: Dictionary = first["shadow"]
		var column: Rect2 = old["column"]
		var viewport: Vector2 = first["viewport"]
		print("  %d readings of the pre-J8 HUD: its column %s x %s at (%s, %s) on every one — its top %s px above the bottom edge and its bottom edge %s px below the %s px window"
			% [compared, _n(column.size.x), _n(column.size.y), _n(column.position.x), _n(column.position.y), _n(PRE_J8_TOP), _n(below), _n(viewport.y)])
		print("  its Mana bar %s px tall from y %s: %s px of it inside the window and %s px below — the fill and the bottom border among them"
			% [_n(mana_height), _n(mana_top), _n(mana_height - mana_below), _n(mana_below)])
	for stage: Array in [["the first reading with both HUDs", _first_shadow_index()], ["the first update after the lethal Hit", _index_after(int((_death.get("at_kill", {}) as Dictionary).get("sample", -1)))],
			["behind the Fallen overlay", int((_death.get("behind", {}) as Dictionary).get("end", 0)) - 1], ["after the restart", _index_of_reading("restart")]]:
		var index: int = int(stage[1])
		if index < 0 or index >= _samples.size() or (_samples[index]["shadow"] as Dictionary).is_empty():
			print("  mechanism: %s: not read" % String(stage[0]))
			continue
		var sample: Dictionary = _samples[index]
		var viewport: Vector2 = sample["viewport"]
		var old: Rect2 = sample["shadow"]["column"]
		var own: Rect2 = sample["live"]["column"]
		print("  mechanism: %s: the pre-J8 column from y %s to %s, %s; the live column from y %s to %s, %s"
			% [String(stage[0]), _n(old.position.y), _n(old.end.y), _edge(old, viewport), _n(own.position.y), _n(own.end.y), _edge(own, viewport)])
	_done("the_pre_j8_reconstruction_still_clips_the_lowest_14_px")


func _check_from_its_first_laid_out_frame_the_whole_column_is_inside_the_window() -> void:
	print("")
	print("--- 7. From its first laid-out frame the whole live column — both labels, both bars, their fills and their borders — is inside the window, 24 px from its left edge and 24 px above its bottom edge")
	var viewport: Vector2 = _birth.get("viewport", Vector2.ZERO)
	var entered: bool = not _birth.is_empty()
	var arrived: bool = (entered and _birth["anchors"] == [0.0, 1.0, 0.0, 1.0]
		and _birth["offsets"] == [ACCEPTED_LEFT_INSET, -ACCEPTED_BOTTOM_INSET, ACCEPTED_LEFT_INSET, -ACCEPTED_BOTTOM_INSET]
		and _birth["grow"] == [Control.GROW_DIRECTION_END, Control.GROW_DIRECTION_BEGIN])
	var anchored: bool = not _column_rects.is_empty()
	var tallest: Rect2 = Rect2()
	var lefts: Dictionary = {}
	var bottoms: Dictionary = {}
	for entry: Dictionary in _column_rects:
		var rect: Rect2 = entry["rect"]
		lefts[_n(rect.position.x)] = true
		bottoms[_n(rect.end.y)] = true
		if rect.size.y > tallest.size.y:
			tallest = rect
		if absf(rect.position.x - ACCEPTED_LEFT_INSET) > PLACE_TOLERANCE or absf(rect.end.y - (viewport.y - ACCEPTED_BOTTOM_INSET)) > PLACE_TOLERANCE:
			anchored = false
	var sort: Dictionary = _column_sorts[0] if not _column_sorts.is_empty() else {}
	var first: Dictionary = _first_laid_out()
	var live: Dictionary = first.get("live", {})
	var mana_bottom: float = (live["mana"]["outer"] as Rect2).end.y if not live.is_empty() else -1.0
	var ok: bool = arrived and anchored and not sort.is_empty() and _placed(sort["rect"], viewport) and not first.is_empty()
	if ok:
		var mana: Dictionary = live["mana"]
		ok = (_placed(live["column"], viewport) and _inside(live, viewport) and int(first["process"]) > int(_birth["process"])
			and absf(mana_bottom - (live["column"] as Rect2).end.y) <= PLACE_TOLERANCE
			and (mana["label"] as Rect2).end.y <= (mana["outer"] as Rect2).position.y + PLACE_TOLERANCE
			and (mana["fill"] as Rect2).end.y <= mana_bottom - 1.0 + PLACE_TOLERANCE)
	_expect(ok, "birth %s; rects %s; first sort %s; first laid-out %s" % [str(_birth), str(_column_rects.slice(0, 4)), str(sort), str(live.get("column", Rect2()))])
	if entered:
		print("  the live column entered the tree at process frame %d with its anchors at the bottom-left corner %s, offsets %s and grow directions %s"
			% [int(_birth["process"]), str(_birth["anchors"]), str(_birth["offsets"]), _grow_words(_birth["grow"])])
		print("  it took %d rects in the whole run, the tallest %s x %s; their left edges at %s and their bottom edges at %s, in a %s px window"
			% [_column_rects.size(), _n(tallest.size.x), _n(tallest.size.y), ", ".join(PackedStringArray(lefts.keys())), ", ".join(PackedStringArray(bottoms.keys())), _n(viewport.y)])
	if not sort.is_empty():
		print("  its first sort, at process frame %d, %d frame(s) drawn since it entered: %s" % [int(sort["process"]), int(sort["drawn"]) - int(_birth.get("drawn", 0)), _rect_words(sort["rect"], viewport)])
	if not live.is_empty():
		var mana: Dictionary = live["mana"]
		print("  the first laid-out update: %s; all %d of its rects inside the %s x %s window" % [_rect_words(live["column"], viewport), (live["parts"] as Dictionary).size() + 1,
			_n(viewport.x), _n(viewport.y)])
		print("  the Mana bar: its label at y %s to %s; the bar %s x %s from y %s to %s, its 1 px border included; the fill %s x %s — the bar's bottom edge %s px above the window's"
			% [_n((mana["label"] as Rect2).position.y), _n((mana["label"] as Rect2).end.y), _n((mana["outer"] as Rect2).size.x), _n((mana["outer"] as Rect2).size.y),
				_n((mana["outer"] as Rect2).position.y), _n(mana_bottom), _n((mana["fill"] as Rect2).size.x), _n((mana["fill"] as Rect2).size.y), _n(viewport.y - mana_bottom)])
	_done("from_its_first_laid_out_frame_the_whole_column_is_inside_the_window")


func _check_later_updates_and_forced_layout_passes_never_move_the_column() -> void:
	print("")
	print("--- 8. On every later update and through every forced layout pass the column keeps its left, top and bottom edges; only its width follows the bars, as the pre-J8 HUD's does")
	var faults: PackedStringArray = PackedStringArray()
	var start: int = _samples.find(_first_laid_out())
	var read: int = 0
	var widths: Dictionary = {}
	var edges: Dictionary = {}
	for index: int in range(maxi(start, 0), _samples.size()):
		var sample: Dictionary = _samples[index]
		var viewport: Vector2 = sample["viewport"]
		var live: Dictionary = sample["live"]
		var column: Rect2 = live["column"]
		read += 1
		edges["left %s, top %s, bottom %s" % [_n(column.position.x), _n(column.position.y), _n(column.end.y)]] = true
		widths[_n(column.size.x)] = true
		var old: Dictionary = sample["shadow"]
		if (not _placed(column, viewport) or not _inside(live, viewport)
				or not (is_equal_approx(column.size.x, ACCEPTED_BAR_WIDTH) or is_equal_approx(column.size.x, ACCEPTED_BAR_WIDTH + 2.0))
				or (not old.is_empty() and not is_equal_approx(column.size.x, (old["column"] as Rect2).size.x))):
			faults.append("tick %d (%s): %s" % [int(sample["tick"]), String(sample["state"]), str(column)])
			if faults.size() >= 3:
				break
	var later: int = 0
	for entry: Dictionary in _column_rects:
		if int(entry["sample"]) > start:
			later += 1
			if not _placed(entry["rect"], _birth.get("viewport", Vector2.ZERO)):
				faults.append("rect %s" % str(entry["rect"]))
	var sorted: int = 0
	var tags: PackedStringArray = PackedStringArray()
	for forced: Dictionary in _forced:
		tags.append(String(forced["tag"]))
		sorted += (forced["sorts"] as Array).size()
		if (forced["sorts"] as Array).is_empty():
			faults.append("%s: the live column did not sort" % String(forced["tag"]))
		for entry: Dictionary in forced["sorts"]:
			if not _placed(entry["rect"], _birth.get("viewport", Vector2.ZERO)):
				faults.append("%s sort %s" % [String(forced["tag"]), str(entry["rect"])])
		var reading: Dictionary = forced["reading"]
		if not _placed(reading["live"]["column"], reading["viewport"]) or not _inside(reading["live"], reading["viewport"]):
			faults.append("%s reading %s" % [String(forced["tag"]), str(reading["live"]["column"])])
	_expect(faults.is_empty() and start >= 0 and read > 600 and _forced.size() == 3 and sorted >= 3 and widths.size() == 2,
		"%d read from %d; %d forced passes, %d sorts; widths %s; faults %s" % [read, start, _forced.size(), sorted, str(widths.keys()), "; ".join(faults)])
	print("  %d updates read from the first laid-out one to the end of the run, through the Quick Strikes, the Hits, the Fallen delay, the overlay, the restart, the message and Mana spent to zero: the column's edges on them — %s"
		% [read, "; ".join(PackedStringArray(edges.keys()))])
	print("  its width %s px, the pre-J8 column's width on the same update each time: 262 while either bar is full, 260 while both are below full" % " or ".join(PackedStringArray(widths.keys())))
	print("  %d forced layout passes — %s — ran %d sorts of the live column, each leaving it where it was; of the %d rects the column took after its first laid-out update, every one kept its left and bottom edges"
		% [_forced.size(), ", ".join(tags), sorted, later])
	_done("later_updates_and_forced_layout_passes_never_move_the_column")


func _check_full_partial_and_zero_life_and_mana_keep_their_j6_fill_widths() -> void:
	print("")
	print("--- 9. Full, partial and zero Life and Mana: every fill is still BAR_WIDTH x value / maximum inside its bar, exactly as J6 left it")
	var faults: PackedStringArray = PackedStringArray()
	var readings: Array = [_readings.get("start", {}), _readings.get("after_strikes", {}), _readings.get("restart", {}),
		(_drain.get("reading", {}) as Dictionary), _readings.get("end", {})]
	readings.append_array(_strikes)
	readings.append_array(_death.get("hits", []))
	var seen: Dictionary = {}
	for reading: Dictionary in readings:
		if reading.is_empty():
			faults.append("a reading is missing")
			continue
		for pair: Array in [["life", "Life", ACCEPTED_LIFE, "max_life"], ["mana", "Mana", ACCEPTED_MANA, "max_mana"]]:
			var value: float = float(reading[String(pair[0])])
			var maximum: float = float(reading[String(pair[3])])
			if not _bar_true(reading["live"][String(pair[0])], value, maximum, String(pair[1]), pair[2]):
				faults.append("%s %s %s" % [String(reading["tag"]), String(pair[0]), _geometry(reading["live"][String(pair[0])])])
			seen["%s %s" % [String(pair[0]), _share(value, maximum)]] = true
	var sampled: int = 0
	for sample: Dictionary in _samples:
		sampled += 1
		for pair: Array in [["life", "Life", ACCEPTED_LIFE, "max_life"], ["mana", "Mana", ACCEPTED_MANA, "max_mana"]]:
			var value: float = float(sample[String(pair[0])])
			if not _bar_true(sample["live"][String(pair[0])], value, float(sample[String(pair[3])]), String(pair[1]), pair[2]):
				faults.append("tick %d %s %s" % [int(sample["tick"]), String(pair[0]), _geometry(sample["live"][String(pair[0])])])
			seen["%s %s" % [String(pair[0]), _share(value, float(sample[String(pair[3])]))]] = true
		if faults.size() >= 4:
			break
	var trail: PackedStringArray = PackedStringArray()
	for strike: Dictionary in _strikes:
		trail.append(_n(float(strike["mana"])))
	var zero: Dictionary = _drain.get("reading", {})
	_expect(faults.is_empty() and sampled > 600 and seen.has("life full") and seen.has("life partial") and seen.has("life zero")
			and seen.has("mana full") and seen.has("mana partial") and seen.has("mana zero") and trail == PackedStringArray(["95", "90", "85"])
			and _floats(_death.get("trail", [])) == "375, 250, 125, 0" and not zero.is_empty() and float(zero["mana"]) == 0.0 and int(_drain.get("dealt", -1)) == 0,
		"sampled %d; seen %s; Mana %s; Life %s; zero %s; faults %s" % [sampled, str(seen.keys()), str(trail), _floats(_death.get("trail", [])), str(zero.get("mana", -1.0)), "; ".join(faults)])
	var start: Dictionary = _readings.get("start", {})
	if not start.is_empty():
		print("  geometry: \"%s\" %s" % [start["live"]["life"]["text"], _geometry(start["live"]["life"])])
		print("  geometry: \"%s\" %s" % [start["live"]["mana"]["text"], _geometry(start["live"]["mana"])])
	print("  3 real Quick Strikes took the first Graveblade 300 -> 200 -> 100 -> 0 and left Mana at %s; 4 real Graveblade Hits took Life %s" % [", ".join(trail), _floats(_death.get("trail", [])).replace(", ", " -> ")])
	for reading: Dictionary in _death.get("hits", []):
		print("  geometry: \"%s\" %s; \"%s\" %s" % [reading["live"]["life"]["text"], _geometry(reading["live"]["life"]), reading["live"]["mana"]["text"], _geometry(reading["live"]["mana"])])
	if not zero.is_empty():
		print("  after the restart, regeneration held at 0 and %d Quick Strikes swung at nothing, which struck nothing: \"%s\" %s" % [int(_drain.get("swings", 0)),
			zero["live"]["mana"]["text"], _geometry(zero["live"]["mana"])])
	print("  %d updates read: every Life and Mana fill true to the value that update read — full, partial and zero each seen for both" % sampled)
	_done("full_partial_and_zero_life_and_mana_keep_their_j6_fill_widths")


func _check_the_enemy_hover_life_fill_keeps_its_j7_widths() -> void:
	print("")
	print("--- 10. The enemy hover Life fill is still 190 x Life / maximum at 300, 200 and 100 of 300, from the first laid-out update after the panel appears, exactly as J7 left it")
	var faults: PackedStringArray = PackedStringArray()
	var lines: PackedStringArray = PackedStringArray()
	var headless: bool = DisplayServer.get_name() == "headless"
	for key: String in ["full", "two", "one"]:
		var stage: Dictionary = _hovers.get(key, {})
		var shown: Array = (stage.get("open", []) as Array).filter(func(sample: Dictionary) -> bool: return bool(sample["live"]["hover"]["visible"]))
		var truthful: float = float(stage.get("truthful", -1.0))
		if shown.size() < 4:
			faults.append("%s: the panel was shown on %d updates" % [key, shown.size()])
			continue
		var widths: PackedStringArray = PackedStringArray()
		for sample: Dictionary in shown:
			var own: Dictionary = sample["live"]["hover"]
			var old: Dictionary = sample["shadow"]["hover"]
			widths.append(_n(float(own["fill"])))
			if (absf(float(own["fill"]) - truthful) > WIDTH_TOLERANCE or absf(float(old["fill"]) - float(own["fill"])) > WIDTH_TOLERANCE
					or not (own["fill_rect"] as Rect2).position.is_equal_approx((own["content"] as Rect2).position)):
				faults.append("%s tick %d: live %s, pre-J8 %s" % [key, int(sample["tick"]), _n(float(own["fill"])), _n(float(old["fill"]))])
				break
		lines.append("%s / %s: %s px on all %d updates shown, the first laid-out one included; the pre-J8 HUD the same" % [_n(float(stage["life"])), _n(float(stage["max"])),
			_n(truthful), shown.size()])
	_expect(faults.is_empty() and lines.size() == 3 and (_route == "pointer" if headless else not _route.is_empty()),
		"route %s; faults %s" % [_route, "; ".join(faults)])
	print("  hover route: %s" % _route_words())
	for line: String in lines:
		print("  hover: %s" % line)
	_done("the_enemy_hover_life_fill_keeps_its_j7_widths")


func _check_the_fallen_delay_and_the_overlay_neither_move_nor_clip_the_column() -> void:
	print("")
	print("--- 11. Through the Fallen delay and behind the overlay the column does not move: \"Life — 0 / 500\" with a zero-width fill, and the whole Mana bar, its bottom border included, inside the window")
	var faults: PackedStringArray = PackedStringArray()
	var from: int = int((_death.get("at_kill", {}) as Dictionary).get("sample", -1))
	var to: int = int(_death.get("open_sample", -1))
	var delay: int = 0
	for index: int in range(maxi(from, 0), maxi(to, 0)):
		var sample: Dictionary = _samples[index]
		if bool(sample["overlay"]) or float(sample["life"]) > 0.0:
			continue
		delay += 1
		faults.append_array(_fallen_faults(sample))
		if faults.size() >= 3:
			break
	var behind: Dictionary = _death.get("behind", {})
	var paused_read: int = 0
	for index: int in range(int(behind.get("mark", 0)), int(behind.get("end", 0))):
		var sample: Dictionary = _samples[index]
		if not bool(sample["overlay"]):
			continue
		paused_read += 1
		faults.append_array(_fallen_faults(sample))
		if faults.size() >= 3:
			break
	var opened: Dictionary = _death.get("opened", {})
	var at_kill: Dictionary = _death.get("at_kill", {})
	_expect(faults.is_empty() and bool(_death.get("dead", false)) and bool(_death.get("from_killer", false)) and int(_death.get("fell", 0)) == 1
			and is_equal_approx(float(at_kill.get("countdown", 0.0)), BrokenWatchSlice.FALLEN_DELAY) and bool(at_kill.get("pending", false))
			and delay > 20 and paused_read >= 5 and bool(opened.get("once", false)) and opened.get("source", "") == KILLING_SOURCE
			and bool(opened.get("paused", false)) and bool(opened.get("focused", false)),
		"delay %d, behind %d; opened %s; faults %s" % [delay, paused_read, str(opened), "; ".join(faults)])
	print("  the fourth Hit killed the character, armed the %.2f s delay and opened Fallen once, \"%s\", paused, its restart button focused" % [BrokenWatchSlice.FALLEN_DELAY, KILLING_SOURCE])
	print("  %d updates of the delay and %d behind the standing overlay, each read before the slice processed: the column in place and inside the window, \"Life — 0 / 500\" with a 0 px fill, and the Mana bar whole, its bottom edge 24 px above the window's"
		% [delay, paused_read])
	_done("the_fallen_delay_and_the_overlay_neither_move_nor_clip_the_column")


func _fallen_faults(sample: Dictionary) -> PackedStringArray:
	var faults: PackedStringArray = PackedStringArray()
	var viewport: Vector2 = sample["viewport"]
	var live: Dictionary = sample["live"]
	var column: Rect2 = live["column"]
	var mana: Rect2 = live["mana"]["outer"]
	if (not _placed(column, viewport) or not _inside(live, viewport) or String(live["life"]["text"]) != "Life — 0 / 500"
			or (live["life"]["fill"] as Rect2).size.x != 0.0 or absf(mana.end.y - (viewport.y - ACCEPTED_BOTTOM_INSET)) > PLACE_TOLERANCE
			or not _bar_true(live["mana"], float(sample["mana"]), float(sample["max_mana"]), "Mana", ACCEPTED_MANA)):
		faults.append("tick %d: %s; \"%s\"; Mana bar %s" % [int(sample["tick"]), str(column), String(live["life"]["text"]), str(mana)])
	return faults


func _check_a_normal_restart_restores_full_resources_without_moving_the_column() -> void:
	print("")
	print("--- 12. Enter on the focused Restart revives the character to 500 / 500 and 100 / 100 with both fills full, and the column stands exactly where it stood before the death")
	var restart: Dictionary = _death.get("restart", {})
	var reading: Dictionary = _readings.get("restart", {})
	var start: Dictionary = _readings.get("start", {})
	var ok: bool = (not reading.is_empty() and not start.is_empty() and float(reading["life"]) == 500.0 and float(reading["mana"]) == 100.0
		and reading["state"] == "IDLE" and _bar_true(reading["live"]["life"], 500.0, 500.0, "Life", ACCEPTED_LIFE)
		and _bar_true(reading["live"]["mana"], 100.0, 100.0, "Mana", ACCEPTED_MANA))
	var faults: PackedStringArray = PackedStringArray()
	var after: int = 0
	for index: int in range(int(_death.get("restart_sample", _samples.size())), _samples.size()):
		var sample: Dictionary = _samples[index]
		after += 1
		if not _placed(sample["live"]["column"], sample["viewport"]):
			faults.append("tick %d %s" % [int(sample["tick"]), str(sample["live"]["column"])])
			break
	_expect(ok and faults.is_empty() and after > 20 and bool(restart.get("closed_once", false)) and bool(restart.get("restarted_once", false))
			and bool(restart.get("alive", false)) and float(restart.get("countdown", 0.0)) == -1.0 and bool(restart.get("pending_null", false))
			and (reading["live"]["column"] as Rect2).is_equal_approx(start["live"]["column"] as Rect2),
		"restart %s; reading %s; faults %s" % [str(restart), str(reading.get("live", {}).get("column", Rect2())), "; ".join(faults)])
	if ok:
		print("  geometry: \"%s\" %s" % [reading["live"]["life"]["text"], _geometry(reading["live"]["life"])])
		print("  geometry: \"%s\" %s" % [reading["live"]["mana"]["text"], _geometry(reading["live"]["mana"])])
		print("  the column after the restart: %s — the rect it had before the first Quick Strike; %d updates after the restart, each in place"
			% [_rect_words(reading["live"]["column"], reading["viewport"]), after])
	_done("a_normal_restart_restores_full_resources_without_moving_the_column")


func _check_the_columns_internal_geometry_is_the_pre_j8_huds() -> void:
	print("")
	print("--- 13. Inside the column nothing moved: every label, bar, fill and row sits where it sits in the pre-J8 HUD's column, at the same size, in the same colours, fonts and borders")
	var faults: PackedStringArray = PackedStringArray()
	var compared: int = 0
	var parts: int = 0
	var shifts: Dictionary = {}
	for sample: Dictionary in _samples:
		var old: Dictionary = sample["shadow"]
		if old.is_empty():
			continue
		compared += 1
		var own: Dictionary = sample["live"]
		var differences: PackedStringArray = _same_inside(own, old)
		shifts[_n((own["column"] as Rect2).position.y - (old["column"] as Rect2).position.y)] = true
		parts = (own["parts"] as Dictionary).size()
		if not differences.is_empty():
			faults.append("tick %d: %s" % [int(sample["tick"]), "; ".join(differences)])
			if faults.size() >= 3:
				break
	var start: Dictionary = _readings.get("start", {})
	var nominal: bool = false
	if not start.is_empty():
		var own: Dictionary = start["live"]
		var life: Dictionary = own["life"]
		nominal = (int(own["separation"]) == ACCEPTED_SEPARATION and life["bar_minimum"] == Vector2(ACCEPTED_BAR_WIDTH, ACCEPTED_BAR_HEIGHT)
			and own["mana"]["bar_minimum"] == Vector2(ACCEPTED_BAR_WIDTH, ACCEPTED_BAR_HEIGHT) and int(life["font"]) == 13 and int(own["mana"]["font"]) == 13
			and (life["colour"] as Color).is_equal_approx(ACCEPTED_LIFE) and (own["mana"]["colour"] as Color).is_equal_approx(ACCEPTED_MANA)
			and (life["bg"] as Color).is_equal_approx(ACCEPTED_SLATE) and (life["border"] as Color).is_equal_approx(ACCEPTED_IRON)
			and (life["font_colour"] as Color).is_equal_approx(ACCEPTED_TEXT_DIM) and int(life["border_width"]) == 1 and int(life["radius"]) == 2
			and String(life["text"]).begins_with("Life — ") and String(own["mana"]["text"]).begins_with("Mana — "))
	_expect(faults.is_empty() and compared > 300 and parts == 8 and nominal,
		"%d compared, %d parts; nominal %s; faults %s" % [compared, parts, str(nominal), "; ".join(faults)])
	print("  %d readings compared, live against pre-J8: the column's left edge and size, and all %d rects inside it relative to its top-left corner — both rows, both labels, both bars and both fills — identical, with the same classes, texts, fonts, colours, borders and radii"
		% [compared, parts])
	print("  nominal: labels 13 px in (0.55, 0.58, 0.64); each bar's minimum 260 x 22, SLATE with a 1 px IRON border, radius 2; Life (0.78, 0.26, 0.24), Mana (0.30, 0.52, 0.82); rows 6 px apart")
	print("  the one difference is where the column stands: the live column's top edge %s px from the pre-J8 column's on every reading" % " or ".join(PackedStringArray(shifts.keys())))
	_done("the_columns_internal_geometry_is_the_pre_j8_huds")


func _check_the_prompt_message_and_hover_surfaces_keep_their_positions() -> void:
	print("")
	print("--- 14. The item prompt, the transient message and the hover panel keep their places — the pre-J8 HUD's, shown the same content — and none of them overlaps the column")
	var faults: PackedStringArray = PackedStringArray()
	var counts: Dictionary = {"prompt": 0, "message": 0, "hover": 0}
	var texts: Dictionary = {}
	for sample: Dictionary in _samples:
		var old: Dictionary = sample["shadow"]
		if old.is_empty():
			continue
		var own: Dictionary = sample["live"]
		var viewport: Vector2 = sample["viewport"]
		var column: Rect2 = own["column"]
		var places: Dictionary = {
			"prompt": Vector2(viewport.x * 0.5 + ACCEPTED_PROMPT_OFFSET.x, viewport.y + ACCEPTED_PROMPT_OFFSET.y),
			"message": ACCEPTED_MESSAGE_POSITION,
			"hover": Vector2(viewport.x * 0.5 + ACCEPTED_HOVER_OFFSET.x, ACCEPTED_HOVER_OFFSET.y),
		}
		for key: String in ["prompt", "message", "hover"]:
			var mine: Dictionary = own[key]
			var theirs: Dictionary = old[key]
			if not (mine["rect"] as Rect2).position.is_equal_approx(places[key]):
				faults.append("tick %d %s at %s" % [int(sample["tick"]), key, str((mine["rect"] as Rect2).position)])
			if not bool(mine["visible"]):
				continue
			if not bool(theirs["visible"]) or String(theirs.get("text", "")) != String(mine.get("text", "")):
				continue
			counts[key] = int(counts[key]) + 1
			if key != "hover":
				texts["%s: %s" % [key, String(mine.get("text", ""))]] = true
			if not (mine["rect"] as Rect2).is_equal_approx(theirs["rect"] as Rect2) or column.intersects(mine["rect"] as Rect2):
				faults.append("tick %d %s: live %s, pre-J8 %s, column %s" % [int(sample["tick"]), key, str(mine["rect"]), str(theirs["rect"]), str(column)])
		if faults.size() >= 3:
			break
	_expect(faults.is_empty() and int(counts["prompt"]) > 20 and int(counts["message"]) >= 3 and int(counts["hover"]) >= 10
			and String(_message.get("text", "")) == WALK_CLOSER and bool(_message.get("visible", false)) and not bool(_message.get("comparison", true)),
		"counts %s; message %s; faults %s" % [str(counts), str(_message), "; ".join(faults)])
	print("  the prompt at (centre - 150, bottom - 140), the message at (24, 24) and the hover panel at (centre - 110, 18) on every reading; shown with the same content, each the pre-J8 HUD's rect exactly, and none overlapping the column")
	print("  shown and compared: the prompt on %d updates, the message on %d and the hover panel on %d — %s" % [int(counts["prompt"]), int(counts["message"]), int(counts["hover"]),
		"; ".join(PackedStringArray(texts.keys()))])
	_done("the_prompt_message_and_hover_surfaces_keep_their_positions")


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


# --- Readings of the two HUDs -----------------------------------------------------------------

func _read(tag: String) -> Dictionary:
	var player: PrototypePlayer = slice.player
	return {"tag": tag, "life": player.life, "max_life": player.max_life, "mana": player.mana, "max_mana": player.max_mana,
		"state": player.action_state_name(), "live": _hud(slice.hud), "shadow": _hud(_shadow) if _shadow != null else {},
		"viewport": root.get_visible_rect().size, "sample": _samples.size()}


## Everything the resource column and the three other surfaces draw, read from one HUD.
func _hud(hud: Control) -> Dictionary:
	var column: Control = hud.get_node("Resources") as Control
	var prompt: Control = hud.get("_prompt_panel")
	var message: Label = hud.get("_message_label")
	var panel: Control = hud.get("_hover_panel")
	var hover_fill: ColorRect = hud.get("_hover_fill")
	return {
		"column": column.get_global_rect(), "parts": _parts(column), "life": _bar(hud, "life"), "mana": _bar(hud, "mana"),
		"separation": column.get_theme_constant("separation"),
		"prompt": {"visible": prompt.visible, "text": (hud.get("_prompt_label") as Label).text, "rect": prompt.get_global_rect()},
		"message": {"visible": message.visible, "text": message.text, "rect": message.get_global_rect()},
		"hover": {"visible": panel.visible, "rect": panel.get_global_rect(), "fill": hover_fill.size.x, "fill_rect": hover_fill.get_global_rect(),
			"content": _content(hover_fill.get_parent() as Control)},
	}


## Every Control inside the column, keyed by its child-index path, with its class, text and rect relative to
## the column's own top-left corner.
func _parts(column: Control) -> Dictionary:
	var parts: Dictionary = {}
	_collect(column, column.get_global_rect().position, "", parts)
	return parts


func _collect(node: Node, origin: Vector2, path: String, parts: Dictionary) -> void:
	for index: int in node.get_child_count():
		var child: Control = node.get_child(index) as Control
		if child == null:
			continue
		var key: String = "%s/%d" % [path, index]
		var rect: Rect2 = child.get_global_rect()
		parts[key] = {"class": child.get_class(), "relative": Rect2(rect.position - origin, rect.size), "global": rect, "visible": child.visible,
			"text": (child as Label).text if child is Label else ""}
		_collect(child, origin, key, parts)


## A PanelContainer's content rect: its own rect less its style box's margins.
func _content(background: Control) -> Rect2:
	var style: StyleBox = background.get_theme_stylebox("panel")
	var outer: Rect2 = background.get_global_rect()
	var left: float = style.get_margin(SIDE_LEFT)
	var top: float = style.get_margin(SIDE_TOP)
	return Rect2(outer.position + Vector2(left, top),
		outer.size - Vector2(left + style.get_margin(SIDE_RIGHT), top + style.get_margin(SIDE_BOTTOM)))


func _bar(hud: Control, which: String) -> Dictionary:
	var fill: ColorRect = hud.get("_%s_fill" % which)
	var label: Label = hud.get("_%s_label" % which)
	var background: Control = fill.get_parent() as Control
	var style: StyleBoxFlat = background.get_theme_stylebox("panel") as StyleBoxFlat
	var content: Rect2 = _content(background)
	var rect: Rect2 = fill.get_global_rect()
	return {
		"text": label.text, "label": label.get_global_rect(), "font": label.get_theme_font_size("font_size"),
		"font_colour": label.get_theme_color("font_color"), "fill": rect, "outer": background.get_global_rect(), "content": content,
		"colour": fill.color, "shown": fill.visible and fill.is_visible_in_tree(), "flags": fill.size_flags_horizontal,
		"minimum": fill.custom_minimum_size, "bar_minimum": background.custom_minimum_size,
		"bg": style.bg_color if style != null else Color(), "border": style.border_color if style != null else Color(),
		"border_width": style.border_width_left if style != null else -1, "radius": style.corner_radius_top_left if style != null else -1,
	}


## Does this bar draw exactly the fraction of `value` over `maximum`, inside its content, in its colour?
func _bar_true(bar: Dictionary, value: float, maximum: float, caption: String, colour: Color) -> bool:
	var expected: float = ACCEPTED_BAR_WIDTH * clampf(value / maxf(maximum, 0.0001), 0.0, 1.0)
	var fill: Rect2 = bar["fill"]
	var content: Rect2 = bar["content"]
	return (absf(fill.size.x - expected) <= WIDTH_TOLERANCE and fill.position.is_equal_approx(content.position)
		and is_equal_approx(fill.size.y, content.size.y) and fill.end.x <= content.end.x + WIDTH_TOLERANCE
		and bool(bar["shown"]) and String(bar["text"]) == "%s — %.0f / %.0f" % [caption, value, maximum]
		and (bar["colour"] as Color).is_equal_approx(colour))


## Is this the J8 placement: the left edge 24 px in, the bottom edge 24 px above the window's, 94 px tall?
func _placed(column: Rect2, viewport: Vector2) -> bool:
	return (absf(column.position.x - ACCEPTED_LEFT_INSET) <= PLACE_TOLERANCE
		and absf(column.end.y - (viewport.y - ACCEPTED_BOTTOM_INSET)) <= PLACE_TOLERANCE
		and absf(column.size.y - ACCEPTED_COLUMN_HEIGHT) <= PLACE_TOLERANCE)


## Are the column and every rect inside it wholly inside the window?
func _inside(hud: Dictionary, viewport: Vector2) -> bool:
	var window: Rect2 = Rect2(Vector2.ZERO, viewport)
	if not window.encloses(hud["column"]):
		return false
	var parts: Dictionary = hud["parts"]
	for key: String in parts:
		if not window.encloses(parts[key]["global"] as Rect2):
			return false
	return true


## Everything inside the column but its vertical position, compared between the live HUD and the pre-J8 HUD.
func _same_inside(own: Dictionary, old: Dictionary) -> PackedStringArray:
	var differences: PackedStringArray = PackedStringArray()
	var a: Rect2 = own["column"]
	var b: Rect2 = old["column"]
	if not is_equal_approx(a.position.x, b.position.x) or not a.size.is_equal_approx(b.size):
		differences.append("column %s / %s" % [str(a), str(b)])
	var mine: Dictionary = own["parts"]
	var theirs: Dictionary = old["parts"]
	if mine.keys() != theirs.keys():
		differences.append("parts %s / %s" % [str(mine.keys()), str(theirs.keys())])
		return differences
	for key: String in mine:
		var x: Dictionary = mine[key]
		var y: Dictionary = theirs[key]
		if x["class"] != y["class"] or not (x["relative"] as Rect2).is_equal_approx(y["relative"] as Rect2) or x["visible"] != y["visible"] or x["text"] != y["text"]:
			differences.append("%s %s %s / %s" % [key, String(x["class"]), str(x["relative"]), str(y["relative"])])
	for which: String in ["life", "mana"]:
		var p: Dictionary = own[which]
		var q: Dictionary = old[which]
		for key: String in ["text", "font", "bar_minimum", "minimum", "flags", "border_width", "radius", "shown"]:
			if p[key] != q[key]:
				differences.append("%s %s %s / %s" % [which, key, str(p[key]), str(q[key])])
		for key: String in ["colour", "bg", "border", "font_colour"]:
			if not (p[key] as Color).is_equal_approx(q[key] as Color):
				differences.append("%s %s" % [which, key])
	if int(own["separation"]) != int(old["separation"]):
		differences.append("separation")
	return differences


## The first reading the pre-slice probe took after the live column entered the tree and a layout flush ran.
func _first_laid_out() -> Dictionary:
	for sample: Dictionary in _samples:
		if not _birth.is_empty() and int(sample["process"]) > int(_birth["process"]):
			return sample
	return {}


func _first_shadow_index() -> int:
	for index: int in _samples.size():
		if not (_samples[index]["shadow"] as Dictionary).is_empty():
			return index
	return -1


func _index_after(mark: int) -> int:
	return mark if mark >= 0 and mark < _samples.size() else -1


func _index_of_reading(key: String) -> int:
	var reading: Dictionary = _readings.get(key, {})
	return mini(int(reading.get("sample", -1)), _samples.size() - 1)


func _geometry(bar: Dictionary) -> String:
	var fill: Rect2 = bar["fill"]
	var outer: Rect2 = bar["outer"]
	var content: Rect2 = bar["content"]
	return "fill %s x %s at (%s, %s) in a %s x %s bar (content %s wide)" % [_n(fill.size.x), _n(fill.size.y), _n(fill.position.x), _n(fill.position.y),
		_n(outer.size.x), _n(outer.size.y), _n(content.size.x)]


func _rect_words(column: Rect2, viewport: Vector2) -> String:
	return "%s x %s at (%s, %s) — its left edge %s px in, its bottom edge %s" % [_n(column.size.x), _n(column.size.y), _n(column.position.x), _n(column.position.y),
		_n(column.position.x), _edge(column, viewport)]


func _edge(column: Rect2, viewport: Vector2) -> String:
	var gap: float = viewport.y - column.end.y
	if gap >= 0.0:
		return "%s px above the window's bottom edge" % _n(gap)
	return "%s px below the window's bottom edge" % _n(-gap)


func _grow_words(grow: Array) -> String:
	var words: PackedStringArray = PackedStringArray()
	for direction: Variant in grow:
		match int(direction):
			Control.GROW_DIRECTION_BEGIN:
				words.append("BEGIN")
			Control.GROW_DIRECTION_END:
				words.append("END")
			_:
				words.append("BOTH")
	return "(horizontal %s, vertical %s)" % [words[0], words[1]] if words.size() == 2 else str(grow)


func _share(value: float, maximum: float) -> String:
	if value <= 0.0:
		return "zero"
	if value >= maximum:
		return "full"
	return "partial"


func _shot_words() -> String:
	var hud: Dictionary = _hud(slice.hud)
	var column: Rect2 = hud["column"]
	var viewport: Vector2 = root.get_visible_rect().size
	return "%s, the column %s x %s at (%s, %s), its bottom edge %s px above the window's; \"%s\" fill %s px; \"%s\" fill %s px" % [
		slice.player.action_state_name(), _n(column.size.x), _n(column.size.y), _n(column.position.x), _n(column.position.y),
		_n(viewport.y - column.end.y), String(hud["life"]["text"]), _n((hud["life"]["fill"] as Rect2).size.x),
		String(hud["mana"]["text"]), _n((hud["mana"]["fill"] as Rect2).size.x)]


func _route_words() -> String:
	if _route == "pointer":
		return "the pointer's own route — each harness pointer movement moved the pointer the slice reads (read back at (%d, %d) for the harness's (%d, %d)), and the slice's own _update_hover_info() called show_hover()" % [
			roundi(_route_read_back.x), roundi(_route_read_back.y), roundi(_route_point.x), roundi(_route_point.y)]
	return "STAGED — the slice read the operating system's own cursor at (%d, %d), not the harness's pointer at (%d, %d); in a window the harness never moves that cursor, so it calls the live HUD's show_hover() after the slice on each update, and the pointer-route measurement is the headless run's" % [
		roundi(_route_read_back.x), roundi(_route_read_back.y), roundi(_route_point.x), roundi(_route_point.y)]


func _floats(values: Array) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for value: Variant in values:
		parts.append(_n(float(value)))
	return ", ".join(parts)


func _log_count(token: String) -> int:
	var count: int = 0
	for line: String in slice.log_lines:
		if line.contains(token):
			count += 1
	return count


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


func _n(value: float) -> String:
	if is_equal_approx(value, roundf(value)):
		return "%d" % roundi(value)
	return "%.2f" % value


func _argument_value(flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


# --- The pointer, the keyboard and the controller ---------------------------------------------

## Window coordinates for a point in the viewport's own space: the stretch transform, applied the way the
## operating system's pointer arrives through it.
func _window_point(local: Vector2) -> Vector2:
	return root.get_final_transform() * local


func _motion_event(local: Vector2) -> InputEventMouseMotion:
	var motion: InputEventMouseMotion = InputEventMouseMotion.new()
	var at: Vector2 = _window_point(local)
	motion.device = HARNESS_DEVICE
	motion.position = at
	motion.global_position = at
	return motion


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


# --- Evidence ---------------------------------------------------------------------------------

## Adds no assertion: the rendered runs pin the same count as the headless one. Returns the saved path and
## the frame's size, or "" when no `--shots` directory was given.
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
