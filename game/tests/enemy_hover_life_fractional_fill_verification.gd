extends SceneTree
## First-MVP UI J7 — Enemy Hover-Life Fractional Fill Truthfulness V1: automated verification (decision D-334).
##
## THE ONE QUESTION: when the pointer rests on a living enemy, does the combat HUD's hover Life fill draw
## the enemy's own fraction — the whole 190 px at 300 / 300, 126.67 px at 200 / 300, 63.33 px at 100 / 300 —
## on the first laid-out update after the panel appears, and on every update and every layout pass after
## that? Before J7 it did not, for two separately measured reasons (D-332, D-333): when the panel appeared,
## the PanelContainer's sort stretched the fill across its whole 196 px track; on every later update the
## fill's own fixed 190 x 10 minimum size stopped `show_hover()`'s smaller write.
##
## THE HUD IS THE ONLY PRODUCTION FILE J7 MOVES, by two layout lines and their comments — one in `_build()`,
## one in `show_hover()` — and that is proved by reconstruction: with the insertions removed it is, byte for
## byte, the D-333 file.
##
## BOTH CAUSES ARE MEASURED IN EVERY RUN, NOT ONLY IN THE BASELINE. The pre-J7 HUD is rebuilt from that
## reconstruction, bound to the same player and laid out beside the live one on its own canvas layer, far
## below the window. Whenever the live panel is shown, the harness shows the pre-J7 one the same enemy in the
## same update. Every sort of each hover track is recorded with the width it left: the pre-J7 fill is
## stretched to its track when the panel appears and held at 190 px after, and the live fill keeps the
## width its minimum gives it. Every other rect, colour, border and label of the two HUDs is compared.
##
## GATE 1D'S OWN `broken_watch_slice.tscn`, LOADED AS IT SHIPS. The hover is opened by the pointer's own
## route — a harness pointer movement over the enemy, which the slice's own `_update_hover_info()` reads and
## answers with `show_hover()` — and the enemy's Life is taken by the player's own Quick Strikes.
##
## GEOMETRY IS READ AFTER LAYOUT. A harness node before every other node reads both HUDs at the start of each
## process update — the state the previous frame's layout flush left, which is the state that frame drew.
##
## STAGED, AND STATED WHERE IT HAPPENS:
##   - both Graveblades are quieted; the first is placed 1.0 m ahead of the player and struck by the
##     player's own Quick Strikes, aimed through the slice's seam `force_next_aim_for_verification()`;
##   - every mouse event the harness sends carries its own device id, and a filter holds back every other;
##   - extra layout passes are forced with `queue_sort()` and `update_minimum_size()`;
##   - the pre-J7 comparison HUD is shown by the harness, the same enemy, whenever the live panel is shown;
##   - SUPPLEMENTAL CLAMP COVERAGE ONLY: a fixture Graveblade outside the slice is given Life values play
##     cannot produce and shown through the live HUD's own `show_hover()`, and `show_hover()` is called
##     directly with the dead Graveblade and with null;
##   - in a window, where the slice reads the operating system's own cursor and the harness never moves it,
##     the harness calls `show_hover()` after the slice on each update instead — the pointer-route
##     measurement is then the headless run's, and the run says so.
##
## Input is simulated, which is not physical-device certification. With `--shots <dir>` the run also saves
## three evidence frames; they add no assertion, so the rendered runs pin the same count.
##
## IT PORTS D-211's OWED-SET DISCIPLINE.
##
## Run: godot --headless --path game --script res://tests/enemy_hover_life_fractional_fill_verification.gd

const THIS_FILE: String = "res://tests/enemy_hover_life_fractional_fill_verification.gd"
const HUD_SCRIPT: String = "res://scripts/ui/first_mvp_combat_hud.gd"
const SLICE_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
const SLICE_SCENE: String = "res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
const GRAVEBLADE_SCENE: String = "res://scenes/actors/prototype_graveblade.tscn"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31
const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]

## The HUD as D-333 left it, whole, and J7's two insertions. Each pair is [as J7 wrote it, as D-333 left
## it]; it carries the lines around its insertion so that it is unique.
const PRE_J7_HUD_SHA256: String = "aff939f37124666bcbf63e887ab8685f9e867d935741377a01ba397379a326f5"
const J7_HUD_PREFIX: String = "38c485cb"
const J7_BUILD_INSERT: String = "\t# First-MVP UI J7 (decision D-334): the hover fill keeps the width its own\n\t# minimum size gives it, as the resource fills have since J6. The PanelContainer\n\t# stretched a filling child across the whole bar whenever it sorted, so the\n\t# panel appeared with a full-width fill.\n\t_hover_fill.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN\n"
const J7_SHOW_INSERT: String = "\t# First-MVP UI J7 (decision D-334): the minimum size follows the fraction. A\n\t# fixed 190 x 10 minimum held the fill at 190 px against the write below.\n\t_hover_fill.custom_minimum_size = Vector2(190.0 * fraction, 10.0)\n"
const J7_LAYOUT_LINE: String = "_hover_fill.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN"
const J7_MINIMUM_LINE: String = "_hover_fill.custom_minimum_size = Vector2(190.0 * fraction, 10.0)"
const J7_HUD_MOVES: Array = [
	["\t_hover_fill.custom_minimum_size = Vector2(190, 10)\n\t# First-MVP UI J7 (decision D-334): the hover fill keeps the width its own\n\t# minimum size gives it, as the resource fills have since J6. The PanelContainer\n\t# stretched a filling child across the whole bar whenever it sorted, so the\n\t# panel appeared with a full-width fill.\n\t_hover_fill.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN\n\thover_bar_bg.add_child(_hover_fill)\n",
		"\t_hover_fill.custom_minimum_size = Vector2(190, 10)\n\thover_bar_bg.add_child(_hover_fill)\n"],
	["\tvar fraction: float = clampf(enemy.life / maxf(enemy.data.max_life, 0.0001), 0.0, 1.0)\n\t# First-MVP UI J7 (decision D-334): the minimum size follows the fraction. A\n\t# fixed 190 x 10 minimum held the fill at 190 px against the write below.\n\t_hover_fill.custom_minimum_size = Vector2(190.0 * fraction, 10.0)\n\t_hover_fill.size.x = 190.0 * fraction\n",
		"\tvar fraction: float = clampf(enemy.life / maxf(enemy.data.max_life, 0.0001), 0.0, 1.0)\n\t_hover_fill.size.x = 190.0 * fraction\n"],
]
## The HUD's declarations, as D-333 left them.
const HUD_FIELDS: int = 12
const HUD_FUNCTIONS: int = 12
const HUD_CONSTANTS: int = 10
## `show_hover()`'s code lines after J7: the D-333 body with the minimum-size write before the width write.
const SHOW_HOVER_LINES: Array[String] = [
	"if enemy == null or not enemy.is_alive():", "_hover_panel.visible = false", "return",
	"_hover_panel.visible = true",
	"_hover_name.text = enemy.data.display_name if enemy.data != null else \"Graveblade\"",
	"var fraction: float = clampf(enemy.life / maxf(enemy.data.max_life, 0.0001), 0.0, 1.0)",
	"_hover_fill.custom_minimum_size = Vector2(190.0 * fraction, 10.0)",
	"_hover_fill.size.x = 190.0 * fraction",
]
## The slice's `_update_hover_info()`, code line for code line, as accepted (Gate 1D, D-217): a fresh ray
## under the pointer and one call of `show_hover()`, writing nothing an attack reads.
const HOVER_INFO_LINES: Array[String] = [
	"if input_family.family == InputFamilyTracker.Family.CONTROLLER:", "hud.show_hover(null)", "return",
	"var camera: Camera3D = camera_rig.camera", "var screen: Vector2 = get_viewport().get_mouse_position()",
	"var from: Vector3 = camera.project_ray_origin(screen)", "var direction: Vector3 = camera.project_ray_normal(screen)",
	"var hovered: PrototypeTargetable = acquisition.fixture_under_ray(from, direction)", "var enemy: PrototypeGraveblade = null",
	"if hovered != null:", "var actor: Node = hovered.combat_actor()", "enemy = actor as PrototypeGraveblade", "hud.show_hover(enemy)",
]
## The accepted look, typed independently of the code that draws it.
const ACCEPTED_HOVER_WIDTH: float = 190.0
const ACCEPTED_TRACK_MINIMUM: Vector2 = Vector2(190.0, 10.0)
const ACCEPTED_PANEL_MINIMUM: Vector2 = Vector2(220.0, 0.0)
const ACCEPTED_PANEL_OFFSET: Vector2 = Vector2(-110.0, 18.0)
const ACCEPTED_TRACK: Color = Color(0.10, 0.11, 0.13)
const ACCEPTED_BAR_WIDTH: float = 260.0
const ACCEPTED_LIFE: Color = Color(0.78, 0.26, 0.24)
const ACCEPTED_MANA: Color = Color(0.30, 0.52, 0.82)
const ACCEPTED_SLATE: Color = Color(0.075, 0.082, 0.098, 0.90)
const ACCEPTED_IRON: Color = Color(0.28, 0.30, 0.35)
const ACCEPTED_TEXT: Color = Color(0.84, 0.86, 0.90)
const ENEMY_NAME: String = "Graveblade"
## Measured widths are compared to 190 x fraction within this many pixels.
const WIDTH_TOLERANCE: float = 0.01

## Verification Maintenance V1 (decision D-342): every pair list this suite uses to put a file back lives in
## the flat, content-addressed provenance store under res://tests/provenance/, named by the SHA-256 of its
## listing. Each `*_ROWS` and `*_MOVE_IDS` constant below names its pair lists, and the variable of the old name
## holds them resolved, so every check reads exactly as before. They are resolved through the one engine there,
## and only while it is at the SHA-256 pinned here; a pair list the store cannot prove resolves to nothing.
const PROVENANCE_ENGINE: String = "res://tests/provenance/accepted_suite_provenance.gd"
const PROVENANCE_ENGINE_SHA256: String = "fadbdfeba32546d03bffe876c2b8be7a96dfe966ff9f5d4f720199d664b23dc4"

## The eleven accepted suite files J7 moved, each put back to exactly what it was at the end of D-333. Each
## row is [path, its J7 prefix, its D-333 SHA-256, pairs of (as J7 wrote it, as D-333 left it)].
const MOVED_SUITE_ROWS: Array = [
	["res://tests/fallen_modal_life_state_verification.gd", "eb7f4153", "f065a48d15a33ee3e127913b2b595c98492b7ae611dbfc83d013c81870c4507f", "3e7c3a327c2fcb3b5ae9daf1a554e1101538d0308bd5394087552c3136fb4d0b"],
	["res://tests/pending_fallen_restart_verification.gd", "520d9543", "68a1227ec9d87c67de7cda196a39b069c2c38db46b2296050d83cc7de002352f", "1c516c4733d0b37638eac8a9e7544bf35b85b9fd7ffa1eb649c6674aa51c612d"],
	["res://tests/pending_fallen_restart_smoke.sh", "67cf7ba9", "f7b48202618f98ddd3082cb33a28761fb1621e9b6d1be29e5ac09dbc62b6ae74", "e9b16d35e517a196779b81c5e027cf5fe5b93969503000e1e3ba6f33a0d2c242"],
	["res://tests/fallen_delay_item_interaction_verification.gd", "611891a3", "308fe51a4111b041dc6ceb016e55522f4ca53138ebf86771c7311a449187b12c", "7164b12714b6238ffa4470cd4d958e1d3ea17605a789432c534024ece612592b"],
	["res://tests/fallen_delay_item_interaction_smoke.sh", "d7cf4498", "b7ff3d666e674f5e01c6c3404f12c52a1e75bdf265555ad43b85de66fb8b2824", "89640d63fe43de273c4d04748dedc71f2ef0c6fa712641bf510daa676ab9e5b2"],
	["res://tests/fallen_delay_drop_highlight_verification.gd", "44ed4bdf", "733d4af8c633df902528af159c4714c290353e6c7263ed412ab1ab145b178acf", "bc591361c2f29bcfd0c88cef4081cc0f981d47c021e733492f430d56eefe8d7d"],
	["res://tests/fallen_delay_drop_highlight_smoke.sh", "aeba508d", "f5451331ff2798605bf0bff54b361e09708d8f5d9e0f97ef385a6a6788f72fd5", "238d9c7f30be51ff33cf01b0173dcb5be82ec831c837d9cf3a856d4febcebb55"],
	["res://tests/combat_hud_fractional_fill_verification.gd", "423858a2", "c5a873fd3f06ff63c1681984486308c3c2b20456190a357b5c33d5baa586846a", "f47ffa06764308e1bf41c621fc1c85866fee8cb67ad349be2be56bd86a07a771"],
	["res://tests/combat_hud_fractional_fill_smoke.sh", "1c2f1d12", "d69585af10075c7f2a2195d5b23e96ab87cf6eb2b9b153ab9760d9ef11ac72aa", "4a991d9a93e6f619054d27fc167cef3c12fc9a13180939f40286ba17005920d5"],
	["res://tests/global_damage_live_application_smoke.sh", "803b8a7f", "4f8cad92833da5c931bdc1f5a2ffe70d3a8617bf49321ef95d394d0fd60dac2c", "9e9110bf4430e1f2ca2cd11454c836975f9d6ca57b3e87dbb317dc5933afc6b2"],
	["res://tests/maximum_life_live_application_smoke.sh", "657c0b17", "e5d90d8ef3a2c215f9462d6340e2fd14e25b3296a02247681f153e4097e3ccff", "9e9110bf4430e1f2ca2cd11454c836975f9d6ca57b3e87dbb317dc5933afc6b2"],
]
var MOVED_SUITES: Array = _stored(MOVED_SUITE_ROWS)
const MOVED_SUITE_COUNT: int = 11

## First-MVP UI J8 (D-336) moved the combat HUD again and, with it, the eleven suite files above. Each is
## first put back to where J7 left it and then read exactly as before: `J8_PREFIXES` holds each file's J8
## prefix, and `J8_MOVES` its pairs of [as J8 wrote it, as J7 left it], applied to that file alone.
const J8_PREFIXES: Dictionary = {
	HUD_SCRIPT: "ee485029",
	"res://tests/fallen_modal_life_state_verification.gd": "d5407c7c",
	"res://tests/pending_fallen_restart_verification.gd": "1062c1db",
	"res://tests/pending_fallen_restart_smoke.sh": "689284cc",
	"res://tests/fallen_delay_item_interaction_verification.gd": "3deeb26a",
	"res://tests/fallen_delay_item_interaction_smoke.sh": "cb520369",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "c9648eea",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "d2772373",
	"res://tests/combat_hud_fractional_fill_verification.gd": "333c1674",
	"res://tests/combat_hud_fractional_fill_smoke.sh": "a5744db6",
	"res://tests/global_damage_live_application_smoke.sh": "ccef4a26",
	"res://tests/maximum_life_live_application_smoke.sh": "e3887f96",
}
const J8_MOVE_IDS: Dictionary = {
	HUD_SCRIPT: "34944fab68a4c79848821e870a472483448c1671cf8ce625af57eca32cc4db19",
	"res://tests/fallen_modal_life_state_verification.gd": "3cfd6d4749e5e801664da0874fa7f571855f0c1c4d08a671cab93b6317b27503",
	"res://tests/pending_fallen_restart_verification.gd": "da1e53b3a7be5c836b449eca6af9d6e422484f5f6b87c7dbde858f1b24e91e70",
	"res://tests/pending_fallen_restart_smoke.sh": "3ac248809645192bb948960935d03919041698fc4db7f88ca5f870e21a321cc6",
	"res://tests/fallen_delay_item_interaction_verification.gd": "1b66d63242bdd82fa624b7795247d40b5d49999ac005af40d8c6f9e110d8b4fd",
	"res://tests/fallen_delay_item_interaction_smoke.sh": "604de133e29e7eef2e1abf4ea9985e367acebef9edffb68acffd93037a9cd1cd",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "2f183d917da224b1f1c738cecdb042c1b6914458223313b9ccab9c172342cab7",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "91be8fd4c3616aeb9c7eba0c78b18d0ab1a69976bd32e02381fece5c5b07da06",
	"res://tests/combat_hud_fractional_fill_verification.gd": "61a6826eb355330ffe0f0a1b01de1a5a00610dffe228fe4281334edc306b20c6",
	"res://tests/combat_hud_fractional_fill_smoke.sh": "44e7bb67e3e3a4c915521426a40b746124ccdc9fd1e565f94f946e2f2dec76d7",
	"res://tests/global_damage_live_application_smoke.sh": "728cbef5f603dffb7ad472008dd703ad760ab628ce803675b6d7ff118687b2c2",
	"res://tests/maximum_life_live_application_smoke.sh": "728cbef5f603dffb7ad472008dd703ad760ab628ce803675b6d7ff118687b2c2",
}
var J8_MOVES: Dictionary = _stored(J8_MOVE_IDS)

## First-MVP Gameplay J9 (D-338) moved nine of the eleven suite files above again, one for one, when Gate 1D's
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
}
var J9_MOVES: Dictionary = _stored(J9_MOVE_IDS)

## First-MVP Gameplay J10 (D-340) moved nine of the eleven suite files above again, one for one, when Gate 1D's
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
}
var J10_MOVES: Dictionary = _stored(J10_MOVE_IDS)

## Verification Maintenance V1 (D-342) moved five of the files above again, one for one, when their put-back pairs
## moved into the flat provenance store. Each is first put back to where D-341 left it and then read exactly
## as before: `VM1_PREFIXES` holds each file's D-342 prefix, and `VM1_MOVES` its pairs of [as D-342 wrote it,
## as D-341 left it], named in `VM1_MOVE_IDS` and applied to that file alone.
const VM1_PREFIXES: Dictionary = {
	"res://tests/fallen_delay_item_interaction_verification.gd": "15352d8a",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "6204a260",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "08aa2d0b",
	"res://tests/combat_hud_fractional_fill_verification.gd": "d23c5fdc",
	"res://tests/combat_hud_fractional_fill_smoke.sh": "be9f6f47",
}
const VM1_MOVE_IDS: Dictionary = {
	"res://tests/fallen_delay_item_interaction_verification.gd": "e48a940f496b486a4e3d29945413a32e72c92d04cc1b53079b43b091c391d8ac",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "b3d27bc2dfc663e6044e81edefed212ca94fac1bcc6efd90695f63ef7729b948",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "6c2fd3b783af50c704bf5eadd9ef796f0d6f633b26e674cf5f653c37ce6a3487",
	"res://tests/combat_hud_fractional_fill_verification.gd": "9f53188f095270661035ffaa398236fd02494e252d347aad0fa108759fe2a35c",
	"res://tests/combat_hud_fractional_fill_smoke.sh": "d014f5ed85cb9a293875956a2606972b00398e1f4be9eeb51fb123a470b82662",
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
}
var J11_MOVES: Dictionary = _stored(J11_MOVE_IDS)

## Everything J7 stands beside, at the SHA-256 prefix each held before the first J7 edit.
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
## The scenes that instance the HUD, by path.
const HUD_SCENES: Array[String] = [
	"res://scenes/first_mvp/canonical_opening/canonical_opening.tscn",
	"res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn",
	"res://scenes/roguelite/roguelite_build_variety_review.tscn",
	"res://scenes/roguelite/roguelite_core_loop.tscn",
	"res://scenes/roguelite/roguelite_replayability_review.tscn",
]

## The fixture's Life values for the supplemental clamp coverage, of its 300: above the maximum, half of it,
## zero and below zero while it is still alive, and back at full.
const CLAMP_LIVES: Array[float] = [450.0, 150.0, 0.0, -50.0, 300.0]
## Where the harness's pre-J7 HUD is drawn: far below the window, so it is never seen and never hovered.
const SHADOW_OFFSET: Vector2 = Vector2(0.0, 100000.0)

const PROBE_SOURCE: String = "extends Node\nvar ticks: int = 0\nvar on_tick: Callable\n\nfunc _process(_delta: float) -> void:\n\tticks += 1\n\tif on_tick.is_valid():\n\t\ton_tick.call(ticks)\n"
const HARNESS_DEVICE: int = 3300
const FILTER_SOURCE: String = "extends Node\nvar device: int = 0\nvar held: int = 0\n\nfunc _input(event: InputEvent) -> void:\n\tif event is InputEventMouse and event.device != device:\n\t\theld += 1\n\t\tget_viewport().set_input_as_handled()\n"

const OWED_CHECKS: Array[String] = [
	"the_production_diff_is_exactly_the_authorized_hover_fill_correction",
	"the_accepted_suites_moved_only_their_hud_pins",
	"only_build_and_show_hover_gained_one_line_each",
	"the_hud_reaches_gate_1d_and_its_runtimes_by_instancing_only",
	"no_player_combat_scene_input_map_or_project_behaviour_changed",
	"the_pointer_route_shows_full_life_as_the_whole_190_px_fill",
	"real_quick_strikes_take_the_graveblade_to_two_thirds_one_third_and_death",
	"at_two_thirds_the_first_laid_out_update_is_already_truthful",
	"later_updates_and_forced_layout_passes_keep_the_truthful_width",
	"hiding_and_reopening_while_partial_never_restores_a_full_fill",
	"at_one_third_the_fill_is_truthful_from_the_first_update_on",
	"both_measured_causes_are_gone",
	"the_fill_stays_clamped_inside_its_track",
	"a_dead_or_null_enemy_still_hides_the_panel",
	"hover_never_changes_targeting_or_acquisition",
	"the_player_life_and_mana_bars_stay_as_j6_left_them",
	"labels_colours_geometry_borders_and_placement_are_unchanged_but_the_hover_fill_width",
]

var arguments: PackedStringArray = PackedStringArray()
var slice: BrokenWatchSlice

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _staged: PackedStringArray = PackedStringArray()
var _next_use_id: int = 334000
var _shot_dir: String = ""
var _shots: PackedStringArray = PackedStringArray()

var _pre: Node = null
var _post: Node = null
var _filter: Node = null
var _stage: Node3D = null
## The harness's pre-J7 HUD and the canvas layer it lives on.
var _shadow: Control = null
var _shadow_layer: CanvasLayer = null
var _shadow_built: Dictionary = {}

## How this run opens the hover: "pointer" when the slice reads the harness's pointer, "staged" when it
## reads the operating system's own cursor instead.
var _route: String = ""
var _route_point: Vector2 = Vector2.INF
var _route_read_back: Vector2 = Vector2.INF
## While true, the post-slice probe calls the live HUD's `show_hover()` with `_staged_target` (STAGED).
var _staging: bool = false
var _staged_target: PrototypeGraveblade = null
## The enemy the pre-J7 HUD is shown whenever the live panel is shown.
var _mirror_enemy: PrototypeGraveblade = null

## Every reading the pre-slice probe takes, and every sort of both hover tracks, in order.
var _sampling: bool = false
var _samples: Array = []
var _sorts: Array = []

var _readings: Dictionary = {}
var _cycles: Dictionary = {}
var _strikes: Array = []
var _dead: Dictionary = {}
var _clamp: Dictionary = {}


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	_shot_dir = _argument_value("--shots")
	print("")
	print("=== First-MVP UI J7 — Enemy Hover-Life Fractional Fill Truthfulness V1 verification (D-334) ===")

	_check_the_production_diff_is_exactly_the_authorized_hover_fill_correction()
	_check_the_accepted_suites_moved_only_their_hud_pins()
	_check_only_build_and_show_hover_gained_one_line_each()
	_check_the_hud_reaches_gate_1d_and_its_runtimes_by_instancing_only()
	_check_no_player_combat_scene_input_map_or_project_behaviour_changed()

	await _play()
	if slice != null:
		_check_the_pointer_route_shows_full_life_as_the_whole_190_px_fill()
		_check_real_quick_strikes_take_the_graveblade_to_two_thirds_one_third_and_death()
		_check_at_two_thirds_the_first_laid_out_update_is_already_truthful()
		_check_later_updates_and_forced_layout_passes_keep_the_truthful_width()
		_check_hiding_and_reopening_while_partial_never_restores_a_full_fill()
		_check_at_one_third_the_fill_is_truthful_from_the_first_update_on()
		_check_both_measured_causes_are_gone()
		_check_the_fill_stays_clamped_inside_its_track()
		_check_a_dead_or_null_enemy_still_hides_the_panel()
		_check_hover_never_changes_targeting_or_acquisition()
		_check_the_player_life_and_mana_bars_stay_as_j6_left_them()
		_check_labels_colours_geometry_borders_and_placement_are_unchanged_but_the_hover_fill_width()

	_check_every_check_ran()
	_sampling = false
	_staging = false
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
		print("ENEMY HOVER LIFE FRACTIONAL FILL VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("ENEMY HOVER LIFE FRACTIONAL FILL VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		quit(1)


# --- 1–5. Structure: the one file, its two lines, its reach ---------------------------------------

func _check_the_production_diff_is_exactly_the_authorized_hover_fill_correction() -> void:
	print("")
	print("--- 1. Exactly one production file moved — the combat HUD — and it is the D-333 file plus two layout lines and their comments")
	var source: String = _before_j8(HUD_SCRIPT, FileAccess.get_file_as_string(HUD_SCRIPT))
	var digest: String = source.sha256_text()
	var rebuilt: Dictionary = _put_back(source, J7_HUD_MOVES)
	var pre_text: String = String(rebuilt["text"])
	var removed: String = source.replace(J7_BUILD_INSERT, "").replace(J7_SHOW_INSERT, "")
	var inserted: int = J7_BUILD_INSERT.count("\n") + J7_SHOW_INSERT.count("\n")
	var lines_now: int = source.count("\n")
	var lines_then: int = pre_text.count("\n")
	_expect(FileAccess.get_sha256(HUD_SCRIPT).begins_with(String(J8_PREFIXES[HUD_SCRIPT]))
			and digest.begins_with(J7_HUD_PREFIX) and bool(rebuilt["unique"]) and pre_text.sha256_text() == PRE_J7_HUD_SHA256
			and source.count(J7_BUILD_INSERT) == 1 and source.count(J7_SHOW_INSERT) == 1 and lines_now == lines_then + inserted
			and removed.sha256_text() == PRE_J7_HUD_SHA256 and (pre_text + "x").sha256_text() != PRE_J7_HUD_SHA256,
		"the HUD hashes %s; the two insertions occur %d and %d time(s); the reconstruction is unique: %s and hashes %s; with the insertions removed it hashes %s"
			% [digest.left(8), source.count(J7_BUILD_INSERT), source.count(J7_SHOW_INSERT), str(rebuilt["unique"]), pre_text.sha256_text().left(8),
				removed.sha256_text().left(8)])
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in UNCHANGED_HASHES:
		var held: String = FileAccess.get_sha256(String(row[0]))
		if not held.begins_with(String(row[1])):
			moved.append("%s %s" % [String(row[0]).get_file(), held.left(8)])
	_expect(moved.is_empty() and UNCHANGED_HASHES.size() == 54, "moved: %s" % ", ".join(moved))
	print("  the HUD is at its J7 hash %s, %d lines; with J7's %d inserted lines removed it is, byte for byte, the D-333 file %s, %d lines — both once J8's replaced line (D-336) is put back"
		% [J7_HUD_PREFIX, lines_now, inserted, PRE_J7_HUD_SHA256.left(8), lines_then])
	print("  %d files J7 stands beside hold the hashes they held before the first J7 edit: the player, Gate 1D's slice, the modal contract, both Fallen overlays, the comparison, the two HUDs beside this one, the drop, the loadout, all 7 descendants of the slice, Prototype Zero's room, the Graveblade and its target area, the combat, movement, camera and input kernels, the five scenes that instance the HUD and two more, four records, project.godot and nine accepted suite files; Gate 1D's slice and J1's verification since moved by J9 (D-338); the slice and J1's verification again, and Broken Watch's layout, since moved by J10 (D-340)"
		% UNCHANGED_HASHES.size())
	_done("the_production_diff_is_exactly_the_authorized_hover_fill_correction")


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


func _check_the_accepted_suites_moved_only_their_hud_pins() -> void:
	print("")
	print("--- 2. The eleven accepted suite files J7 had to move moved only their pins and reconstructions, one for one, at unchanged counts")
	var faults: PackedStringArray = PackedStringArray()
	var blocks: int = 0
	var back: PackedStringArray = PackedStringArray()
	for row: Array in MOVED_SUITES:
		var path: String = row[0]
		var j10_text: String = _before_vm1(path, _before_j11(path, FileAccess.get_file_as_string(path)))
		var j9_text: String = _before_j10(path, j10_text)
		var j8_text: String = _before_j9(path, j9_text)
		var j7_text: String = _before_j8(path, j8_text)
		var rebuilt: Dictionary = _put_back(j7_text, row[3])
		blocks += (row[3] as Array).size()
		back.append(String(row[2]).left(8))
		if not (FileAccess.get_sha256(path).begins_with(String(J11_PREFIXES.get(path, VM1_PREFIXES.get(path, J10_PREFIXES.get(path, J9_PREFIXES.get(path, J8_PREFIXES.get(path, row[1])))))))
				and j10_text.sha256_text().begins_with(String(J10_PREFIXES.get(path, J9_PREFIXES.get(path, J8_PREFIXES.get(path, row[1])))))
				and j9_text.sha256_text().begins_with(String(J9_PREFIXES.get(path, J8_PREFIXES.get(path, row[1]))))
				and j8_text.sha256_text().begins_with(String(J8_PREFIXES.get(path, row[1]))) and j7_text.sha256_text().begins_with(String(row[1]))
				and bool(rebuilt["unique"]) and not (row[3] as Array).is_empty()
				and String(rebuilt["text"]).sha256_text() == String(row[2])
				and (String(rebuilt["text"]) + "x").sha256_text() != String(row[2])):
			faults.append("%s at %s rebuilds to %s" % [path.get_file(), FileAccess.get_sha256(path).left(8), String(rebuilt["text"]).sha256_text().left(8)])
	_expect(faults.is_empty() and MOVED_SUITES.size() == MOVED_SUITE_COUNT,
		"%d of %d moved suites described; %s" % [MOVED_SUITES.size(), MOVED_SUITE_COUNT, "; ".join(faults)])
	print("  J2's, J3's, J4's, J5's and J6's verifications moved their HUD pins, and J3's to J6's learned to put back what J7 moved before reading as before; J3's, J4's, J5's and J6's runners moved their hash rows, J5's its production digest and J6's its HUD reconstruction; I13's and I14's runners their HUD row: put back, the %d are byte for byte %s (%d replaced blocks)"
		% [MOVED_SUITES.size(), ", ".join(back), blocks])
	_done("the_accepted_suites_moved_only_their_hud_pins")


func _check_only_build_and_show_hover_gained_one_line_each() -> void:
	print("")
	print("--- 3. Only _build() and show_hover() changed, each by one layout line; the hover's null-and-dead branch, the player bars and every other function are the D-333 ones")
	var source: String = _before_j8(HUD_SCRIPT, FileAccess.get_file_as_string(HUD_SCRIPT))
	var pre_text: String = String(_put_back(source, J7_HUD_MOVES)["text"])
	var functions: PackedStringArray = _declared_functions(source)
	var differing: PackedStringArray = PackedStringArray()
	for name: String in functions:
		if not name in ["_build", "show_hover"] and _function_body(source, name) != _function_body(pre_text, name):
			differing.append(name)
	var build_now: PackedStringArray = _code_lines(_function_body(source, "_build"))
	var build_then: PackedStringArray = _code_lines(_function_body(pre_text, "_build"))
	var at_build: int = build_then.find("hover_bar_bg.add_child(_hover_fill)")
	if at_build >= 0:
		build_then.insert(at_build, J7_LAYOUT_LINE)
	var show_now: PackedStringArray = _code_lines(_function_body(source, "show_hover"))
	var show_then: PackedStringArray = _code_lines(_function_body(pre_text, "show_hover"))
	var at_show: int = show_then.find("_hover_fill.size.x = 190.0 * fraction")
	if at_show >= 0:
		show_then.insert(at_show, J7_MINIMUM_LINE)
	var code: String = _bare(source)
	var pre_code: String = _bare(pre_text)
	var fields: int = RegEx.create_from_string("(?m)^var ").search_all(source).size()
	var constants: int = RegEx.create_from_string("(?m)^const ").search_all(source).size()
	var signals: int = RegEx.create_from_string("(?m)^signal ").search_all(source).size()
	var inserted_code: PackedStringArray = _code_lines(J7_BUILD_INSERT + J7_SHOW_INSERT)
	_expect(differing.is_empty() and at_build >= 0 and at_show >= 0 and build_now == build_then and show_now == show_then
			and show_now == PackedStringArray(SHOW_HOVER_LINES) and functions == _declared_functions(pre_text)
			and functions.size() == HUD_FUNCTIONS and fields == HUD_FIELDS and constants == HUD_CONSTANTS and signals == 0
			and inserted_code == PackedStringArray([J7_LAYOUT_LINE, J7_MINIMUM_LINE]) and code.count("size_flags") == 2
			and code.count("_hover_panel.visible") == pre_code.count("_hover_panel.visible") and code.count("_hover_panel.visible") == 3
			and code.count("_hover_fill.") == pre_code.count("_hover_fill.") + 2
			and not code.to_lower().contains("fallen") and not code.contains("player.is_alive"),
		"differing %s; _build %d lines against %d (at %d); show_hover %s against %s; %d functions, %d fields, %d constants, %d signals; inserted code %s; size_flags %d"
			% [str(differing), build_now.size(), build_then.size(), at_build, str(show_now), str(show_then), functions.size(), fields, constants, signals,
				str(inserted_code), code.count("size_flags")])
	print("  _build(): the accepted %d code lines plus exactly one, before the fill joins its track: %s — as J7 left it; J8 (D-336) has since replaced one of those lines for the resource column's placement" % [build_now.size() - 1, J7_LAYOUT_LINE])
	print("  show_hover(): the accepted %d code lines plus exactly one, before the width write: %s; its null-and-dead branch is still its first three lines" % [show_now.size() - 1, J7_MINIMUM_LINE])
	print("  the other %d functions are byte for byte the D-333 ones — _bar_row(), _on_life_changed() and _on_mana_changed() among them; %d functions, %d fields, %d constants, no signal; the HUD names no life state and never hides a fill"
		% [functions.size() - 2, functions.size(), fields, constants])
	_done("only_build_and_show_hover_gained_one_line_each")


func _check_the_hud_reaches_gate_1d_and_its_runtimes_by_instancing_only() -> void:
	print("")
	print("--- 4. What the two lines reach (structural): every scene that instances the HUD, and one caller of show_hover()")
	var scenes: PackedStringArray = PackedStringArray()
	for path: String in _files_under("res://scenes", [".tscn"]):
		if FileAccess.get_file_as_string(path).contains("path=\"%s\"" % HUD_SCRIPT):
			scenes.append(path)
	scenes.sort()
	var subclasses: PackedStringArray = PackedStringArray()
	var readers: PackedStringArray = PackedStringArray()
	var callers: PackedStringArray = PackedStringArray()
	var scanned: int = 0
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd"]):
			if path == HUD_SCRIPT:
				continue
			scanned += 1
			var code: String = _bare(FileAccess.get_file_as_string(path))
			if code.contains("extends FirstMvpCombatHud"):
				subclasses.append(path.get_file())
			for token: String in ["_hover_fill", "_hover_panel", "_hover_name"]:
				if code.contains(token):
					readers.append("%s:%s" % [path.get_file(), token])
			for index: int in code.count("show_hover("):
				callers.append(path.get_file())
	_expect(scenes == PackedStringArray(HUD_SCENES) and subclasses.is_empty() and readers.is_empty()
			and callers == PackedStringArray(["broken_watch_slice.gd", "broken_watch_slice.gd"]) and scanned > 100,
		"scenes %s; subclasses %s; readers %s; callers %s" % [str(scenes), str(subclasses), str(readers), str(callers)])
	print("  %d scenes instance the HUD: %s" % [scenes.size(), ", ".join(Array(scenes).map(func(p: String) -> String: return p.get_file()))])
	print("  of %d other running scripts none extends FirstMvpCombatHud or names its hover fill, panel or name; show_hover() is called twice, both in broken_watch_slice.gd's _update_hover_info()"
		% scanned)
	print("  canonical_opening.tscn is Gate 1E's scene, and the roguelite runtimes extend the slice: each inherits the correction by instancing the same script — structural only, not measured here")
	_done("the_hud_reaches_gate_1d_and_its_runtimes_by_instancing_only")


func _check_no_player_combat_scene_input_map_or_project_behaviour_changed() -> void:
	print("")
	print("--- 5. The InputMap, the entrypoint and project.godot are untouched; the slice's hover route is the accepted one and the rest hold their pre-J7 hashes (check 1)")
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	var naming: PackedStringArray = PackedStringArray()
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd", ".tscn", ".tres"]):
			if FileAccess.get_file_as_string(path).contains("enemy_hover_life_fractional_fill"):
				naming.append(path)
	var hover_info: PackedStringArray = _code_lines(_function_body(FileAccess.get_file_as_string(SLICE_SCRIPT), "_update_hover_info"))
	_expect(actions == EXPECTED_ACTIONS and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT
			and not settings.contains("[autoload]") and not settings.contains("enemy_hover_life_fractional_fill") and naming.is_empty()
			and hover_info == PackedStringArray(HOVER_INFO_LINES),
		"%d actions, or project.godot moved, or a running file names the harness: %s; _update_hover_info reads %s" % [actions, str(naming), str(hover_info)])
	print("  %d actions; the entrypoint is %s; project.godot declares no [autoload]; nothing that runs names the J7 harness" % [actions, ENTRYPOINT.get_file()])
	print("  the slice's _update_hover_info() is its %d accepted code lines: a fresh ray under the pointer, then show_hover() — it writes nothing an attack reads" % hover_info.size())
	_done("no_player_combat_scene_input_map_or_project_behaviour_changed")


# --- The play, in Gate 1D's own slice ---------------------------------------------------------

func _play() -> void:
	slice = await _load(SLICE_SCENE) as BrokenWatchSlice
	if slice == null:
		return
	await _await_navigation()
	_stage = Node3D.new()
	_stage.name = "J7FixtureStage"
	root.add_child(_stage)
	_install_probes()
	_install_shadow()
	_watch_sorts()
	_quiet()
	_note("Gate 1D's two Graveblades quieted; two harness nodes read every process update, one before the slice and one after it")
	var window: Vector2i = DisplayServer.window_get_size()
	var visible: Vector2 = root.get_visible_rect().size
	print("  display %s, window %dx%d, visible %dx%d" % [DisplayServer.get_name(), window.x, window.y, roundi(visible.x), roundi(visible.y)])
	if _shadow == null:
		return

	var first: PrototypeGraveblade = slice.graveblades[0]
	var forward: Vector3 = _forward()
	first.place_at(slice.landing_layout.player_start() + forward * 6.0)
	first.face_instantly(-forward)
	await _settle(2)
	_stand_facing(first.global_position - forward * 1.0, forward)
	await _settle(10)
	await _await_process_frames(3)
	_note("the first Graveblade placed on Riftfall Landing's route and the player 1.0 m behind it, facing it")
	_sampling = true
	_readings["start"] = {"live": _hover(slice.hud), "shadow": _hover(_shadow), "family": _family()}

	_cycles["full"] = await _cycle("full", first, "01_hover_full_300_of_300")
	_strikes.append(await _strike(first))
	_cycles["two"] = await _cycle("two thirds", first, "02_hover_two_thirds_200_of_300")
	_strikes.append(await _strike(first))
	_cycles["one"] = await _cycle("one third", first, "03_hover_one_third_100_of_300")
	_strikes.append(await _strike(first))
	_note("the first Graveblade struck by the player's own Quick Strikes, aimed through force_next_aim_for_verification()")
	_dead = await _dead_session(first)
	_clamp = await _staged_clamp(first)
	_sampling = false


func _install_probes() -> void:
	var script: GDScript = GDScript.new()
	script.source_code = PROBE_SOURCE
	script.reload()
	_pre = Node.new()
	_pre.name = "J7ProbeBeforeTheSlice"
	_pre.set_script(script)
	_pre.process_priority = -1000000
	_pre.process_mode = Node.PROCESS_MODE_ALWAYS
	_pre.set("on_tick", _on_pre_tick)
	_post = Node.new()
	_post.name = "J7ProbeAfterTheSlice"
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
	_filter.name = "J7ForeignPointerFilter"
	_filter.set_script(filter)
	_filter.set("device", HARNESS_DEVICE)
	_filter.process_mode = Node.PROCESS_MODE_ALWAYS
	root.add_child(_filter)
	_note("every mouse event the harness sends carries device id %d, and a harness node ahead of the slice holds back every other mouse event" % HARNESS_DEVICE)


## The pre-J7 HUD: the D-333 source reconstructed from the file on disk, its `class_name` line dropped so it
## does not collide with the live class, bound to the same room, on its own canvas layer far below the
## window. It is a comparison instrument only; nothing in the slice knows it exists.
func _install_shadow() -> void:
	# First-MVP UI J8 (D-336): the comparison keeps J8's column placement, so that both columns stand in one place
	# and every rect below is still compared whole; J8's line is put back as well to prove the D-333 source.
	var kept: String = String(_put_back(FileAccess.get_file_as_string(HUD_SCRIPT), J7_HUD_MOVES)["text"])
	var source: String = _before_j8(HUD_SCRIPT, kept)
	_shadow_built = {"hash": source.sha256_text(), "class_line": source.count("class_name FirstMvpCombatHud\n")}
	if source.sha256_text() != PRE_J7_HUD_SHA256:
		_failures.append("the pre-J7 HUD could not be reconstructed (%s), so the comparison instrument was not built" % source.sha256_text().left(8))
		return
	var script: GDScript = GDScript.new()
	script.source_code = kept.replace("class_name FirstMvpCombatHud\n", "")
	var compiled: Error = script.reload()
	_shadow_built["compiled"] = compiled
	if compiled != OK:
		_failures.append("the pre-J7 HUD did not compile (%d)" % compiled)
		return
	_shadow_layer = CanvasLayer.new()
	_shadow_layer.name = "J7PreJ7HudLayer"
	_shadow_layer.offset = SHADOW_OFFSET
	root.add_child(_shadow_layer)
	_shadow = Control.new()
	_shadow.name = "PreJ7Hud"
	_shadow.set_script(script)
	_shadow_layer.add_child(_shadow)
	_shadow.call("bind_room", slice)
	_note("the pre-J7 HUD, reconstructed from the HUD file with J7's insertions removed, J8's column placement (D-336) kept — %s once J8's line is put back too — bound to the same player on a canvas layer offset %d px below the window and shown the same enemy whenever the live panel is shown, as a comparison instrument"
		% [PRE_J7_HUD_SHA256.left(8), int(SHADOW_OFFSET.y)])


## Every `sort_children` of both hover tracks: whose, the width it left, the minimum it laid out, and the
## enemy the harness is showing.
func _watch_sorts() -> void:
	if _shadow == null:
		return
	for pair: Array in [["live", slice.hud], ["shadow", _shadow]]:
		var hud: Control = pair[1]
		var fill: ColorRect = hud.get("_hover_fill")
		var track: Container = fill.get_parent() as Container
		var panel: Control = hud.get("_hover_panel")
		var who: String = String(pair[0])
		track.sort_children.connect(func() -> void:
			var enemy: PrototypeGraveblade = _mirror_enemy
			var valid: bool = enemy != null and is_instance_valid(enemy)
			_sorts.append({"who": who, "fill": fill.size.x, "min": fill.custom_minimum_size.x, "track": track.size.x,
				"visible": panel.visible, "pre": _pre_ticks(), "drawn": Engine.get_frames_drawn(),
				"life": enemy.life if valid else -1.0, "max": enemy.data.max_life if valid else -1.0}))


func _on_pre_tick(tick: int) -> void:
	if not _sampling or slice == null or _shadow == null:
		return
	var enemy: PrototypeGraveblade = _mirror_enemy
	var valid: bool = enemy != null and is_instance_valid(enemy)
	var player: PrototypePlayer = slice.player
	_samples.append({
		"tick": tick, "drawn": Engine.get_frames_drawn(), "live": _hover(slice.hud), "shadow": _hover(_shadow),
		"life": enemy.life if valid else -1.0, "max": enemy.data.max_life if valid else -1.0, "alive": valid and enemy.is_alive(),
		"life_bar": _bar(slice.hud, "life"), "mana_bar": _bar(slice.hud, "mana"),
		"shadow_life_bar": _bar(_shadow, "life"), "shadow_mana_bar": _bar(_shadow, "mana"), "player_life": player.life, "player_max": player.max_life,
		"mana": player.mana, "max_mana": player.max_mana, "targeting": _targeting_key(), "family": _family(),
	})


## After the slice has processed: the staged call, when this run stages its hover, and the pre-J7 HUD shown
## the same enemy whenever the live panel is shown.
func _on_post_tick(_tick: int) -> void:
	if slice == null or _shadow == null:
		return
	if _staging:
		slice.hud.show_hover(_staged_target)
	var enemy: PrototypeGraveblade = _mirror_enemy
	if enemy != null and not is_instance_valid(enemy):
		enemy = null
	var shown: bool = slice.hud._hover_panel.visible
	_shadow.call("show_hover", enemy if shown else null)


func _pre_ticks() -> int:
	return int(_pre.get("ticks")) if _pre != null else -1


# --- The hover, by the pointer's own route -----------------------------------------------------

## One Life stage: the pointer over the enemy, away, and back over it, with extra layout passes forced
## while the panel stands, then away again. The targeting state is read before and after.
func _cycle(tag: String, enemy: PrototypeGraveblade, stem: String) -> Dictionary:
	var record: Dictionary = {"tag": tag, "life": enemy.life, "max": enemy.data.max_life,
		"truthful": ACCEPTED_HOVER_WIDTH * clampf(enemy.life / maxf(enemy.data.max_life, 0.0001), 0.0, 1.0),
		"before": _targeting_key(), "mark": _samples.size()}
	_mirror_enemy = enemy
	record["first"] = await _open(enemy, 8)
	var shot: String = await _capture(stem)
	if not shot.is_empty():
		_shots.append("%s — %s" % [shot, _shot_words(enemy)])
	record["away"] = await _away(4)
	record["reopened"] = await _open(enemy, 6)
	record["forced"] = await _force_layout(tag)
	record["after_forced"] = await _hold(4)
	record["last_away"] = await _away(4)
	record["after"] = _targeting_key()
	record["end"] = _samples.size()
	return record


## Moves the pointer over `enemy` — the slice then reads it on its own — and reads the next `updates`.
func _open(enemy: PrototypeGraveblade, updates: int) -> Dictionary:
	var mark: int = _samples.size()
	var sort_mark: int = _sorts.size()
	await _point_at(enemy)
	await _await_process_frames(updates)
	return {"samples": _samples.slice(mark), "sorts": _sorts.slice(sort_mark)}


func _away(updates: int) -> Dictionary:
	var mark: int = _samples.size()
	var sort_mark: int = _sorts.size()
	if _route == "staged":
		_staged_target = null
	else:
		var size: Vector2 = root.get_visible_rect().size
		var motion: InputEventMouseMotion = _motion_event(Vector2(size.x * 0.8, size.y * 0.3))
		motion.relative = Vector2(8.0, 0.0)
		Input.parse_input_event(motion)
	await _await_process_frames(updates)
	return {"samples": _samples.slice(mark), "sorts": _sorts.slice(sort_mark)}


func _hold(updates: int) -> Dictionary:
	var mark: int = _samples.size()
	var sort_mark: int = _sorts.size()
	await _await_process_frames(updates)
	return {"samples": _samples.slice(mark), "sorts": _sorts.slice(sort_mark)}


## One pointer movement over the enemy's body through `Input.parse_input_event()`. The first one also
## decides this run's route: headless, the slice reads the pointer the event placed; in a window it reads
## the operating system's own cursor, which the harness never moves, and the run then stages the hover.
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


## STAGED extra layout passes on both HUDs' hover panels: the track, its box and the panel re-sorted, and
## the fill's minimum size re-announced; read after the engine has run them.
func _force_layout(tag: String) -> Dictionary:
	var mark: int = _sorts.size()
	var sample_mark: int = _samples.size()
	for hud: Control in [slice.hud, _shadow]:
		var fill: ColorRect = hud.get("_hover_fill")
		var track: Container = fill.get_parent() as Container
		track.queue_sort()
		(track.get_parent() as Container).queue_sort()
		(hud.get("_hover_panel") as Container).queue_sort()
		fill.update_minimum_size()
	await _await_process_frames(2)
	_note("extra layout passes forced with the panel standing, on both HUDs, with queue_sort() on the hover track, its box and the panel, and update_minimum_size() on the fill")
	return {"tag": tag, "sorts": _sorts.slice(mark), "samples": _samples.slice(sample_mark)}


## STAGED aim, real attack: the player's own Quick Strike, aimed at the enemy through the slice's seam.
func _strike(enemy: PrototypeGraveblade) -> Dictionary:
	var player: PrototypePlayer = slice.player
	var forward: Vector3 = _forward()
	var area: PrototypeTargetable = enemy.get_node("TargetArea") as PrototypeTargetable
	_stand_facing(enemy.global_position - forward * 1.0, forward)
	await _settle(1)
	var before: float = enemy.life
	var events: int = enemy.damage_taken_events
	var dealt: int = player.attack.damage_events
	slice.force_next_aim_for_verification(area)
	player.attack.press()
	player.attack.release_input()
	for frame: int in 120:
		await physics_frame
		if enemy.life < before and player.attack.phase == QuickStrikeAction.Phase.READY:
			break
	await _settle(3)
	await _await_process_frames(3)
	var event: DamageEvent = enemy.last_damage_taken
	return {"before": before, "after": enemy.life, "events": enemy.damage_taken_events - events, "dealt": player.attack.damage_events - dealt,
		"from_player": event != null and event.source == player, "raw": event.raw_physical_damage if event != null else -1.0, "alive": enemy.is_alive()}


## The dead Graveblade under the pointer's own route, and what the slice's own ray found there.
func _dead_session(enemy: PrototypeGraveblade) -> Dictionary:
	await _settle(2)
	await _await_process_frames(2)
	var record: Dictionary = {"alive": enemy.is_alive(), "life": enemy.life, "before": _targeting_key(), "mark": _samples.size()}
	record["open"] = await _open(enemy, 6)
	var ray: String = "not read: this run stages its hover"
	if _route == "pointer":
		var camera: Camera3D = slice.camera_rig.camera
		var screen: Vector2 = slice.get_viewport().get_mouse_position()
		var hovered: PrototypeTargetable = slice.acquisition.fixture_under_ray(camera.project_ray_origin(screen), camera.project_ray_normal(screen))
		if hovered == null:
			ray = "no target — a dead Graveblade is not a valid target"
		elif hovered.combat_actor() == enemy:
			ray = "the dead Graveblade's own target area"
		else:
			ray = "another target, %s" % hovered.name
	record["ray"] = ray
	record["away"] = await _away(3)
	record["after"] = _targeting_key()
	record["end"] = _samples.size()
	return record


## SUPPLEMENTAL CLAMP COVERAGE ONLY: a fixture Graveblade outside the slice, its processing disabled, given
## Life values play cannot produce and shown through the live HUD's own `show_hover()`; then
## `show_hover()` called directly with the dead Graveblade and with null.
func _staged_clamp(dead: PrototypeGraveblade) -> Dictionary:
	var fixture: PrototypeGraveblade = (load(GRAVEBLADE_SCENE) as PackedScene).instantiate() as PrototypeGraveblade
	fixture.name = "J7ClampFixture"
	fixture.position = Vector3(400.0, 40.0, 400.0)
	_stage.add_child(fixture)
	fixture.set_ai_enabled(false)
	fixture.process_mode = Node.PROCESS_MODE_DISABLED
	var staging_before: bool = _staging
	var mark: int = _samples.size()
	var sort_mark: int = _sorts.size()
	_mirror_enemy = fixture
	_staged_target = fixture
	_staging = true
	var cases: Array = []
	for life: float in CLAMP_LIVES:
		fixture.life = life
		await _await_process_frames(3)
		cases.append({"life": life, "max": fixture.data.max_life, "alive": fixture.is_alive(), "live": _hover(slice.hud), "shadow": _hover(_shadow)})
	slice.hud.show_hover(dead)
	var after_dead: bool = slice.hud._hover_panel.visible
	await _await_process_frames(2)
	var reshown: bool = slice.hud._hover_panel.visible
	slice.hud.show_hover(null)
	var after_null: bool = slice.hud._hover_panel.visible
	_staged_target = null
	await _await_process_frames(2)
	var hidden: bool = not slice.hud._hover_panel.visible
	_staging = staging_before
	_mirror_enemy = dead
	var record: Dictionary = {"cases": cases, "after_dead": after_dead, "reshown": reshown, "after_null": after_null, "hidden": hidden,
		"dead_alive": dead.is_alive(), "samples": _samples.slice(mark), "sorts": _sorts.slice(sort_mark)}
	fixture.queue_free()
	await _await_process_frames(1)
	_note("SUPPLEMENTAL: a fixture Graveblade outside the slice, its processing disabled, given Life 450, 150, 0, -50 and 300 of 300 and shown through the live HUD's own show_hover(); then show_hover() called directly with the dead Graveblade and with null")
	return record


# --- 6–17. What the play measured -------------------------------------------------------------

func _check_the_pointer_route_shows_full_life_as_the_whole_190_px_fill() -> void:
	print("")
	print("--- 6. Full Life, 300 / 300: the pointer's own route opens the hover panel, and from its first laid-out update the fill is the whole 190 px")
	var cycle: Dictionary = _cycles.get("full", {})
	var opening: Dictionary = cycle.get("first", {})
	var samples: Array = opening.get("samples", [])
	var shown: Array = _shown(samples)
	var faults: PackedStringArray = _untruthful(shown)
	var first: Dictionary = shown[0] if not shown.is_empty() else {}
	var sort: Dictionary = _first_visible_sort(opening.get("sorts", []), "live")
	var start: Dictionary = _readings.get("start", {})
	var headless: bool = DisplayServer.get_name() == "headless"
	_expect(float(cycle.get("life", 0.0)) == 300.0 and float(cycle.get("max", 0.0)) == 300.0 and shown.size() >= 5 and faults.is_empty()
			and not samples.is_empty() and not bool(samples[0]["live"]["visible"]) and not bool((start.get("live", {}) as Dictionary).get("visible", true))
			and start.get("family", "") == "mouse"
			and not first.is_empty() and absf(float(first["live"]["fill"]) - ACCEPTED_HOVER_WIDTH) <= WIDTH_TOLERANCE
			and not sort.is_empty() and absf(float(sort["fill"]) - ACCEPTED_HOVER_WIDTH) <= WIDTH_TOLERANCE
			and (_route == "pointer" if headless else not _route.is_empty()),
		"full: %d of %d updates shown; faults %s; first %s; first sort %s; route %s"
			% [shown.size(), samples.size(), "; ".join(faults), str(first.get("live", {})), str(sort), _route])
	print("  hover route: %s" % _route_words())
	print("  the pointer over the first Graveblade at 300 / 300: the panel was hidden on the update the pointer moved and shown on %d of the %d after it; the first laid-out update: \"%s\" %s"
		% [shown.size(), samples.size(), String(first.get("live", {}).get("name", "")), _geometry(first.get("live", {}))])
	print("  the first sort of the track after the panel appeared left the fill %s px; the updates read %s" % [_n(float(sort.get("fill", -1.0))), _widths(shown)])
	_done("the_pointer_route_shows_full_life_as_the_whole_190_px_fill")


func _check_real_quick_strikes_take_the_graveblade_to_two_thirds_one_third_and_death() -> void:
	print("")
	print("--- 7. Between the hover stages, the player's own Quick Strikes take the first Graveblade 300 -> 200 -> 100 -> 0, one Hit of 100 each")
	var expected: Array = [[300.0, 200.0, true], [200.0, 100.0, true], [100.0, 0.0, false]]
	var faults: PackedStringArray = PackedStringArray()
	var trail: PackedStringArray = PackedStringArray(["300"])
	for index: int in _strikes.size():
		var strike: Dictionary = _strikes[index]
		trail.append(_n(float(strike["after"])))
		var ok: bool = (index < expected.size() and float(strike["before"]) == float(expected[index][0])
			and float(strike["after"]) == float(expected[index][1]) and bool(strike["alive"]) == bool(expected[index][2])
			and int(strike["events"]) == 1 and int(strike["dealt"]) == 1 and bool(strike["from_player"]) and float(strike["raw"]) == 100.0)
		if not ok:
			faults.append(str(strike))
	_expect(_strikes.size() == 3 and faults.is_empty(), "%d strikes; %s" % [_strikes.size(), "; ".join(faults)])
	print("  3 real Quick Strikes, aimed through force_next_aim_for_verification(): Life %s, each one damage record of raw 100 from the player; the third killed it"
		% " -> ".join(trail))
	_done("real_quick_strikes_take_the_graveblade_to_two_thirds_one_third_and_death")


func _check_at_two_thirds_the_first_laid_out_update_is_already_truthful() -> void:
	print("")
	print("--- 8. Two thirds, 200 / 300: the truthful fill is 126.67 px of 190, and the first laid-out update after the panel appears already reads it")
	var cycle: Dictionary = _cycles.get("two", {})
	var opening: Dictionary = cycle.get("first", {})
	var samples: Array = opening.get("samples", [])
	var shown: Array = _shown(samples)
	var first: Dictionary = shown[0] if not shown.is_empty() else {}
	var sort: Dictionary = _first_visible_sort(opening.get("sorts", []), "live")
	var truthful: float = float(cycle.get("truthful", -1.0))
	_expect(float(cycle.get("life", 0.0)) == 200.0 and float(cycle.get("max", 0.0)) == 300.0 and absf(truthful - 380.0 / 3.0) < 0.0001
			and not samples.is_empty() and not bool(samples[0]["live"]["visible"])
			and not first.is_empty() and _hover_true(first["live"], 200.0, 300.0)
			and not sort.is_empty() and absf(float(sort["fill"]) - truthful) <= WIDTH_TOLERANCE,
		"two thirds: first %s; first sort %s" % [str(first.get("live", {})), str(sort)])
	print("  at 200 / 300 the truthful fill is %s px: the first laid-out update after the pointer moved over the Graveblade: \"%s\" %s"
		% [_n(truthful), String(first.get("live", {}).get("name", "")), _geometry(first.get("live", {}))])
	print("  the first sort of the track after the panel appeared left the live fill %s px; the pre-J7 HUD, shown the same enemy in the same update, read %s px on that update"
		% [_n(float(sort.get("fill", -1.0))), _n(float(first.get("shadow", {}).get("fill", -1.0)))])
	_done("at_two_thirds_the_first_laid_out_update_is_already_truthful")


func _check_later_updates_and_forced_layout_passes_keep_the_truthful_width() -> void:
	print("")
	print("--- 9. Every later update, and every sort of three forced layout passes, keeps the truthful width at each Life stage")
	var faults: PackedStringArray = PackedStringArray()
	var later: int = 0
	var forced_sorts: int = 0
	var forced_shadow: PackedStringArray = PackedStringArray()
	var widths: PackedStringArray = PackedStringArray()
	for key: String in ["full", "two", "one"]:
		var cycle: Dictionary = _cycles.get(key, {})
		var truthful: float = float(cycle.get("truthful", -1.0))
		for which: String in ["first", "reopened", "after_forced"]:
			var shown: Array = _shown((cycle.get(which, {}) as Dictionary).get("samples", []))
			var rest: Array = shown if which == "after_forced" else shown.slice(1)
			later += rest.size()
			faults.append_array(_untruthful(rest))
		var forced: Dictionary = cycle.get("forced", {})
		faults.append_array(_untruthful(_shown(forced.get("samples", []))))
		var live_here: int = 0
		for sort: Dictionary in forced.get("sorts", []):
			if String(sort["who"]) == "live":
				live_here += 1
				if not bool(sort["visible"]) or absf(float(sort["fill"]) - truthful) > WIDTH_TOLERANCE:
					faults.append("%s forced sort %s" % [key, str(sort)])
			elif bool(sort["visible"]):
				forced_shadow.append(_n(float(sort["fill"])))
		if live_here < 1:
			faults.append("%s: no forced sort of the live track was recorded" % key)
		forced_sorts += live_here
		widths.append(_n(truthful))
	_expect(faults.is_empty() and later >= 30 and forced_sorts >= 3 and _cycles.size() == 3,
		"%d later updates, %d forced live sorts; faults %s" % [later, forced_sorts, "; ".join(faults)])
	print("  %d later updates across the three stages, each read before the slice processed: every fill the truthful width, %s px" % [later, ", ".join(widths)])
	print("  3 forced layout passes, one per stage, with the panel standing: %d sorts of the live track, each leaving the fill at that stage's truthful width; the pre-J7 HUD's forced sorts left its fill %s px"
		% [forced_sorts, ", ".join(forced_shadow)])
	_done("later_updates_and_forced_layout_passes_keep_the_truthful_width")


func _check_hiding_and_reopening_while_partial_never_restores_a_full_fill() -> void:
	print("")
	print("--- 10. The pointer moves away and back: the panel hides, and when it reappears no sort and no update restores a full-width fill")
	var faults: PackedStringArray = PackedStringArray()
	var firsts: PackedStringArray = PackedStringArray()
	var shadow_firsts: PackedStringArray = PackedStringArray()
	var drawn: int = 0
	var headless: bool = DisplayServer.get_name() == "headless"
	for key: String in ["full", "two", "one"]:
		var cycle: Dictionary = _cycles.get(key, {})
		var truthful: float = float(cycle.get("truthful", -1.0))
		var partial: bool = key != "full"
		var away: Array = (cycle.get("away", {}) as Dictionary).get("samples", [])
		if away.is_empty() or bool(away[-1]["live"]["visible"]):
			faults.append("%s: the panel did not hide when the pointer moved away" % key)
		var reopened: Dictionary = cycle.get("reopened", {})
		var samples: Array = reopened.get("samples", [])
		var shown: Array = _shown(samples)
		if samples.is_empty() or bool(samples[0]["live"]["visible"]) or shown.is_empty():
			faults.append("%s: the reopening was not observed from a hidden panel" % key)
		else:
			firsts.append(_n(float(shown[0]["live"]["fill"])))
			shadow_firsts.append(_n(float(shown[0]["shadow"]["fill"])))
			faults.append_array(_untruthful(shown))
			if samples.size() >= 2:
				drawn += int(samples[-1]["drawn"]) - int(samples[0]["drawn"])
		for which: String in ["first", "reopened", "forced", "after_forced"]:
			for sort: Dictionary in (cycle.get(which, {}) as Dictionary).get("sorts", []):
				if String(sort["who"]) != "live" or not bool(sort["visible"]):
					continue
				if absf(float(sort["fill"]) - truthful) > WIDTH_TOLERANCE or (partial and float(sort["fill"]) >= ACCEPTED_HOVER_WIDTH - 1.0):
					faults.append("%s %s sort %s" % [key, which, str(sort)])
	_expect(faults.is_empty() and firsts.size() == 3 and (headless or drawn >= 3),
		"reopened first %s; drawn %d (%s); faults %s" % [", ".join(firsts), drawn, DisplayServer.get_name(), "; ".join(faults)])
	print("  after the pointer moved away the panel hid; when it moved back, the first laid-out update read %s px at 300, 200 and 100 of 300, and no live sort or update in between reached the full 190 px while the Graveblade was damaged"
		% ", ".join(firsts))
	print("  the pre-J7 HUD, reopened the same way in the same updates, read %s px on its first update each time" % ", ".join(shadow_firsts))
	if headless:
		print("  headless: the engine draws no frames, so the claim rests on the updates read and the sorts recorded")
	else:
		print("  %d frames were drawn across the three reopenings, each after a layout that left the truthful width" % drawn)
	_done("hiding_and_reopening_while_partial_never_restores_a_full_fill")


func _check_at_one_third_the_fill_is_truthful_from_the_first_update_on() -> void:
	print("")
	print("--- 11. One third, 100 / 300: the truthful fill is 63.33 px of 190, from the first laid-out update on")
	var cycle: Dictionary = _cycles.get("one", {})
	var opening: Dictionary = cycle.get("first", {})
	var samples: Array = opening.get("samples", [])
	var shown: Array = _shown(samples)
	var faults: PackedStringArray = _untruthful(shown)
	var first: Dictionary = shown[0] if not shown.is_empty() else {}
	var sort: Dictionary = _first_visible_sort(opening.get("sorts", []), "live")
	var truthful: float = float(cycle.get("truthful", -1.0))
	_expect(float(cycle.get("life", 0.0)) == 100.0 and absf(truthful - 190.0 / 3.0) < 0.0001 and shown.size() >= 5 and faults.is_empty()
			and not samples.is_empty() and not bool(samples[0]["live"]["visible"])
			and not first.is_empty() and _hover_true(first["live"], 100.0, 300.0)
			and not sort.is_empty() and absf(float(sort["fill"]) - truthful) <= WIDTH_TOLERANCE,
		"one third: first %s; first sort %s; faults %s" % [str(first.get("live", {})), str(sort), "; ".join(faults)])
	print("  at 100 / 300 the truthful fill is %s px: the first laid-out update: \"%s\" %s" % [_n(truthful), String(first.get("live", {}).get("name", "")),
		_geometry(first.get("live", {}))])
	print("  the first sort left the live fill %s px, and the updates read %s; the pre-J7 HUD read %s px on the first update" % [_n(float(sort.get("fill", -1.0))),
		_widths(shown), _n(float(first.get("shadow", {}).get("fill", -1.0)))])
	_done("at_one_third_the_fill_is_truthful_from_the_first_update_on")


func _check_both_measured_causes_are_gone() -> void:
	print("")
	print("--- 12. Both measured causes are gone: no sort stretches the live fill to its track, and its minimum follows the fraction — while the pre-J7 HUD beside it, shown the same enemy, still shows both")
	var faults: PackedStringArray = PackedStringArray()
	var lines: PackedStringArray = PackedStringArray()
	var flags: String = ""
	for key: String in ["full", "two", "one"]:
		var cycle: Dictionary = _cycles.get(key, {})
		var truthful: float = float(cycle.get("truthful", -1.0))
		var partial: bool = key != "full"
		for which: String in ["first", "reopened"]:
			var opening: Dictionary = cycle.get(which, {})
			var live: Dictionary = _first_visible_sort(opening.get("sorts", []), "live")
			var shadow: Dictionary = _first_visible_sort(opening.get("sorts", []), "shadow")
			var shown: Array = _shown(opening.get("samples", []))
			var after: Array = shown.slice(1)
			if live.is_empty() or shadow.is_empty() or after.is_empty():
				faults.append("%s %s: a sort or the updates after it were not recorded" % [key, which])
				continue
			# Cause 1: at the sort when the panel appears, the pre-J7 fill fills its track; the live one does not.
			if (absf(float(live["fill"]) - truthful) > WIDTH_TOLERANCE or absf(float(live["fill"]) - float(live["min"])) > WIDTH_TOLERANCE
					or float(live["fill"]) > float(live["track"]) - 1.0 or absf(float(shadow["fill"]) - float(shadow["track"])) > WIDTH_TOLERANCE):
				faults.append("%s %s: live sort %s, pre-J7 sort %s" % [key, which, str(live), str(shadow)])
			# Cause 2: on the updates after, the pre-J7 fill is held at its fixed 190 minimum; the live minimum follows.
			for sample: Dictionary in after:
				var own: Dictionary = sample["live"]
				var old: Dictionary = sample["shadow"]
				if (absf((own["min"] as Vector2).x - truthful) > WIDTH_TOLERANCE or not bool(old["visible"])
						or absf(float(old["fill"]) - ACCEPTED_HOVER_WIDTH) > WIDTH_TOLERANCE or absf((old["min"] as Vector2).x - ACCEPTED_HOVER_WIDTH) > WIDTH_TOLERANCE):
					faults.append("%s %s tick %d: live %s at minimum %s, pre-J7 %s at minimum %s" % [key, which, int(sample["tick"]), _n(float(own["fill"])),
						_n((own["min"] as Vector2).x), _n(float(old["fill"])), _n((old["min"] as Vector2).x)])
					break
			var own_last: Dictionary = (after[-1] as Dictionary)["live"]
			var old_last: Dictionary = (after[-1] as Dictionary)["shadow"]
			if flags.is_empty():
				flags = "live %d / pre-J7 %d" % [int(own_last["flags"]), int(old_last["flags"])]
				if int(own_last["flags"]) != Control.SIZE_SHRINK_BEGIN or int(old_last["flags"]) != Control.SIZE_FILL:
					faults.append("size flags %s" % flags)
			lines.append("%s / 300, %s: at the first sort after the panel appeared the pre-J7 fill %s px (its track %s px), the live fill %s px; on the %d updates after it the pre-J7 fill %s px at a minimum of %s%s, the live fill %s px at a minimum of %s"
				% [_n(float(cycle.get("life", 0.0))), "appearing" if which == "first" else "reappearing", _n(float(shadow["fill"])), _n(float(shadow["track"])),
					_n(float(live["fill"])), after.size(), _n(float(old_last["fill"])), _n((old_last["min"] as Vector2).x),
					" — held there" if partial else "", _n(float(own_last["fill"])), _n((own_last["min"] as Vector2).x)])
	_expect(faults.is_empty() and lines.size() == 6 and not flags.is_empty(), "%d mechanism lines; faults %s" % [lines.size(), "; ".join(faults)])
	for line: String in lines:
		print("  mechanism: %s" % line)
	print("  the layout difference is the fill's horizontal size flag (%s: SIZE_SHRINK_BEGIN against SIZE_FILL) and its minimum width" % flags)
	_done("both_measured_causes_are_gone")


func _check_the_fill_stays_clamped_inside_its_track() -> void:
	print("")
	print("--- 13. The live fill stays between empty and 190 px and inside its track on every reading and every sort — and, supplementally, at Life values play cannot produce")
	var faults: PackedStringArray = PackedStringArray()
	var readings: int = 0
	var overrun: float = -INF
	for sample: Dictionary in _samples:
		var hover: Dictionary = sample["live"]
		if not bool(hover["visible"]):
			continue
		readings += 1
		var fill: Rect2 = hover["fill_rect"]
		var content: Rect2 = hover["content"]
		overrun = maxf(overrun, fill.end.x - content.end.x)
		if (fill.size.x < -WIDTH_TOLERANCE or fill.size.x > ACCEPTED_HOVER_WIDTH + WIDTH_TOLERANCE or not fill.position.is_equal_approx(content.position)
				or fill.end.x > content.end.x + WIDTH_TOLERANCE or not is_equal_approx(fill.size.y, content.size.y)):
			faults.append("tick %d: %s" % [int(sample["tick"]), _geometry(hover)])
			if faults.size() >= 3:
				break
	var sorted: int = 0
	for sort: Dictionary in _sorts:
		if String(sort["who"]) != "live":
			continue
		sorted += 1
		if (float(sort["fill"]) < -WIDTH_TOLERANCE or float(sort["fill"]) > ACCEPTED_HOVER_WIDTH + WIDTH_TOLERANCE
				or absf(float(sort["fill"]) - float(sort["min"])) > WIDTH_TOLERANCE or float(sort["fill"]) > float(sort["track"]) + WIDTH_TOLERANCE):
			faults.append("sort %s" % str(sort))
			break
	var staged: PackedStringArray = PackedStringArray()
	var old: PackedStringArray = PackedStringArray()
	var cases: Array = _clamp.get("cases", [])
	for case: Dictionary in cases:
		var expected: float = ACCEPTED_HOVER_WIDTH * clampf(float(case["life"]) / float(case["max"]), 0.0, 1.0)
		var hover: Dictionary = case["live"]
		var fill: Rect2 = hover["fill_rect"]
		var content: Rect2 = hover["content"]
		staged.append("%s / %s -> %s px" % [_n(float(case["life"])), _n(float(case["max"])), _n(fill.size.x)])
		old.append(_n(float((case["shadow"] as Dictionary)["fill"])))
		if (not bool(case["alive"]) or not bool(hover["visible"]) or absf(fill.size.x - expected) > WIDTH_TOLERANCE
				or fill.end.x > content.end.x + WIDTH_TOLERANCE or not fill.position.is_equal_approx(content.position)):
			faults.append("staged %s" % str(case))
	_expect(faults.is_empty() and readings > 60 and sorted >= 10 and cases.size() == CLAMP_LIVES.size() and bool(_clamp.get("hidden", false)),
		"%d readings, %d sorts, %d staged cases; faults %s" % [readings, sorted, cases.size(), "; ".join(faults)])
	print("  %d live hover readings and %d sorts of the live track: every fill between 0 and 190 px, at its own minimum width, starting at its track's left edge; the fill never passed its track's right edge — at its widest it ended %s px inside it"
		% [readings, sorted, _n(-overrun)])
	print("  staged, supplemental: a fixture Graveblade shown through the HUD's own show_hover() at %s; the pre-J7 HUD read %s px; then hidden again"
		% [", ".join(staged), ", ".join(old)])
	_done("the_fill_stays_clamped_inside_its_track")


func _check_a_dead_or_null_enemy_still_hides_the_panel() -> void:
	print("")
	print("--- 14. A dead or null enemy still hides the panel: the pointer over the dead Graveblade, and show_hover() called directly with it and with null")
	var open: Dictionary = _dead.get("open", {})
	var samples: Array = open.get("samples", [])
	var shown: Array = _shown(samples)
	_expect(samples.size() >= 5 and shown.is_empty() and not bool(_dead.get("alive", true)) and float(_dead.get("life", -1.0)) == 0.0
			and not bool(_clamp.get("after_dead", true)) and bool(_clamp.get("reshown", false)) and not bool(_clamp.get("after_null", true))
			and bool(_clamp.get("hidden", false)) and not bool(_clamp.get("dead_alive", true)),
		"dead: %d samples, %d shown; clamp %s" % [samples.size(), shown.size(), str({"after_dead": _clamp.get("after_dead"), "reshown": _clamp.get("reshown"), "after_null": _clamp.get("after_null"), "hidden": _clamp.get("hidden")})])
	print("  the first Graveblade dead at 0 / 300: the pointer over its body for %d updates — the slice's own ray found %s — and the panel hidden on every one"
		% [samples.size(), String(_dead.get("ray", ""))])
	print("  show_hover() called directly with the dead Graveblade while the fixture's panel stood: hidden in the same call; shown again by the next update's staged call; then show_hover(null): hidden in the same call — the branch is D-333's, unchanged (check 3)")
	_done("a_dead_or_null_enemy_still_hides_the_panel")


func _check_hover_never_changes_targeting_or_acquisition() -> void:
	print("")
	print("--- 15. Hover is information only: through every hover, the slice's soft target and forced aim, the attack's target, aim, phase and counts, and every Graveblade's soft-target ring stay exactly as they were")
	var faults: PackedStringArray = PackedStringArray()
	var read: int = 0
	var records: Array = [_cycles.get("full", {}), _cycles.get("two", {}), _cycles.get("one", {}), _dead]
	for record: Dictionary in records:
		if record.is_empty():
			faults.append("a hover stage is missing")
			continue
		var before: String = String(record["before"])
		if String(record["after"]) != before:
			faults.append("before %s, after %s" % [before, String(record["after"])])
		for sample: Dictionary in _samples.slice(int(record["mark"]), int(record["end"])):
			read += 1
			if String(sample["targeting"]) != before or String(sample["family"]) != "mouse":
				faults.append("tick %d: %s, family %s" % [int(sample["tick"]), String(sample["targeting"]), String(sample["family"])])
				break
	_expect(faults.is_empty() and read > 80, "%d updates read; faults %s" % [read, "; ".join(faults)])
	print("  across %d updates of the three Life stages and the dead Graveblade, the slice's soft target and forced aim, the attack's target, aim, phase, use, release and query counts and last acquisition, the player's destination and state and both Graveblades' soft-target rings read exactly what they read before the pointer moved; the mouse stayed the live family"
		% read)
	print("  that holds through the pointer's own route — the slice's unchanged _update_hover_info() (check 5) — and through the staged calls alike")
	_done("hover_never_changes_targeting_or_acquisition")


func _check_the_player_life_and_mana_bars_stay_as_j6_left_them() -> void:
	print("")
	print("--- 16. The player's Life and Mana bars stay as J6 left them: on every update read, each fill is BAR_WIDTH x value / maximum inside its content")
	var faults: PackedStringArray = PackedStringArray()
	var lowest: float = INF
	var lowest_width: float = -1.0
	for sample: Dictionary in _samples:
		if not _bar_true(sample["life_bar"], float(sample["player_life"]), float(sample["player_max"]), "Life", ACCEPTED_LIFE):
			faults.append("tick %d life %s" % [int(sample["tick"]), _bar_geometry(sample["life_bar"])])
		if not _bar_true(sample["mana_bar"], float(sample["mana"]), float(sample["max_mana"]), "Mana", ACCEPTED_MANA):
			faults.append("tick %d mana %s" % [int(sample["tick"]), _bar_geometry(sample["mana_bar"])])
		if float(sample["mana"]) < lowest:
			lowest = float(sample["mana"])
			lowest_width = ((sample["mana_bar"] as Dictionary)["fill"] as Rect2).size.x
		if faults.size() >= 3:
			break
	var full: bool = not _samples.is_empty() and float((_samples[0] as Dictionary)["player_life"]) == 500.0
	_expect(faults.is_empty() and _samples.size() > 100 and lowest < 100.0 and lowest_width < ACCEPTED_BAR_WIDTH and full,
		"%d updates; lowest Mana %s at %s px; faults %s" % [_samples.size(), _n(lowest), _n(lowest_width), "; ".join(faults)])
	print("  %d updates read: the Life fill 260 px at 500 / 500 throughout, and the Mana fill always 260 x Mana / 100 within 0.01 px — down to %s px at %s / 100 after the Quick Strikes, back up with regeneration"
		% [_samples.size(), _n(lowest_width), _n(lowest)])
	_done("the_player_life_and_mana_bars_stay_as_j6_left_them")


func _check_labels_colours_geometry_borders_and_placement_are_unchanged_but_the_hover_fill_width() -> void:
	print("")
	print("--- 17. The hover panel's labels, colours, nominal dimensions, placement and borders, and both player bars, are the pre-J7 HUD's exactly; only the hover fill's width differs")
	var faults: PackedStringArray = PackedStringArray()
	var compared: int = 0
	for sample: Dictionary in _samples:
		var own: Dictionary = sample["live"]
		var old: Dictionary = sample["shadow"]
		if not (bool(own["visible"]) and bool(old["visible"])):
			continue
		compared += 1
		var differences: PackedStringArray = _same_hover(own, old)
		differences.append_array(_same_bars(sample))
		if not differences.is_empty():
			faults.append("tick %d: %s" % [int(sample["tick"]), "; ".join(differences)])
			if faults.size() >= 3:
				break
	var start: Dictionary = _readings.get("start", {})
	var live: Dictionary = start.get("live", {})
	var width: float = slice.hud.size.x
	var nominal: bool = (not live.is_empty() and live["panel_min"] == ACCEPTED_PANEL_MINIMUM
		and (live["panel"] as Rect2).position.is_equal_approx(Vector2(width * 0.5 + ACCEPTED_PANEL_OFFSET.x, ACCEPTED_PANEL_OFFSET.y))
		and live["panel_anchor"] == [0.5, 0.0, 0.5, 0.0] and live["track_min"] == ACCEPTED_TRACK_MINIMUM
		and (live["track_bg"] as Color).is_equal_approx(ACCEPTED_TRACK) and int(live["track_radius"]) == 2
		and (live["panel_bg"] as Color).is_equal_approx(ACCEPTED_SLATE) and (live["panel_border"] as Color).is_equal_approx(ACCEPTED_IRON)
		and int(live["panel_border_width"]) == 1 and int(live["panel_radius"]) == 3 and is_equal_approx(float(live["panel_margin"]), 12.0)
		and int(live["name_font"]) == 15 and (live["name_colour"] as Color).is_equal_approx(ACCEPTED_TEXT)
		and int(live["name_align"]) == HORIZONTAL_ALIGNMENT_CENTER and (live["colour"] as Color).is_equal_approx(ACCEPTED_LIFE))
	_expect(faults.is_empty() and compared >= 20 and nominal, "%d compared; nominal %s; faults %s" % [compared, str(nominal), "; ".join(faults)])
	print("  %d updates compared with both panels shown, live against pre-J7: the panel's rect, minimum, anchors and style, the name's rect, text, size, colour and alignment, the track's rect, minimum and style, the fill's colour, origin and height, both player bars and their labels, and the resources column — identical"
		% compared)
	print("  nominal: the panel %s x %s at (centre - 110, 18) = (%s, %s), SLATE with a 1 px IRON border, radius 3, margins 12; the name 15 px, centred; the track %s x %s minimum, (0.10, 0.11, 0.13), radius 2; the fill LIFE (0.78, 0.26, 0.24)"
		% [_n((live.get("panel", Rect2()) as Rect2).size.x), _n((live.get("panel", Rect2()) as Rect2).size.y), _n((live.get("panel", Rect2()) as Rect2).position.x),
			_n((live.get("panel", Rect2()) as Rect2).position.y), _n(ACCEPTED_TRACK_MINIMUM.x), _n(ACCEPTED_TRACK_MINIMUM.y)])
	print("  the differences are the hover fill's width, its minimum width and its horizontal size flag — the correction itself")
	_done("labels_colours_geometry_borders_and_placement_are_unchanged_but_the_hover_fill_width")


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

## A PanelContainer's content rect: its own rect less its style box's margins.
func _content(background: Control) -> Rect2:
	var style: StyleBox = background.get_theme_stylebox("panel")
	var outer: Rect2 = background.get_global_rect()
	var left: float = style.get_margin(SIDE_LEFT)
	var top: float = style.get_margin(SIDE_TOP)
	return Rect2(outer.position + Vector2(left, top),
		outer.size - Vector2(left + style.get_margin(SIDE_RIGHT), top + style.get_margin(SIDE_BOTTOM)))


## Everything the hover panel draws, read from one HUD.
func _hover(hud: Control) -> Dictionary:
	var fill: ColorRect = hud.get("_hover_fill")
	var track: PanelContainer = fill.get_parent() as PanelContainer
	var panel: PanelContainer = hud.get("_hover_panel")
	var name_label: Label = hud.get("_hover_name")
	var track_style: StyleBoxFlat = track.get_theme_stylebox("panel") as StyleBoxFlat
	var panel_style: StyleBoxFlat = panel.get_theme_stylebox("panel") as StyleBoxFlat
	return {
		"visible": panel.visible, "name": name_label.text, "fill": fill.size.x, "fill_rect": fill.get_global_rect(),
		"min": fill.custom_minimum_size, "flags": fill.size_flags_horizontal, "colour": fill.color,
		"track": track.get_global_rect(), "content": _content(track), "track_min": track.custom_minimum_size,
		"track_bg": track_style.bg_color if track_style != null else Color(), "track_radius": track_style.corner_radius_top_left if track_style != null else -1,
		"panel": panel.get_global_rect(), "panel_min": panel.custom_minimum_size,
		"panel_anchor": [panel.anchor_left, panel.anchor_top, panel.anchor_right, panel.anchor_bottom],
		"panel_bg": panel_style.bg_color if panel_style != null else Color(), "panel_border": panel_style.border_color if panel_style != null else Color(),
		"panel_border_width": panel_style.border_width_left if panel_style != null else -1,
		"panel_radius": panel_style.corner_radius_top_left if panel_style != null else -1,
		"panel_margin": panel_style.content_margin_left if panel_style != null else -1.0,
		"name_rect": name_label.get_global_rect(), "name_font": name_label.get_theme_font_size("font_size"),
		"name_colour": name_label.get_theme_color("font_color"), "name_align": name_label.horizontal_alignment,
		"resources": (hud.get_node("Resources") as Control).get_global_rect(), "prompt_min": (hud.get("_prompt_panel") as Control).custom_minimum_size,
	}


## Does this hover reading draw exactly the fraction of `life` over `maximum`, inside its track, in LIFE?
func _hover_true(hover: Dictionary, life: float, maximum: float) -> bool:
	var expected: float = ACCEPTED_HOVER_WIDTH * clampf(life / maxf(maximum, 0.0001), 0.0, 1.0)
	var fill: Rect2 = hover["fill_rect"]
	var content: Rect2 = hover["content"]
	return (bool(hover["visible"]) and absf(fill.size.x - expected) <= WIDTH_TOLERANCE and fill.position.is_equal_approx(content.position)
		and is_equal_approx(fill.size.y, content.size.y) and fill.end.x <= content.end.x + WIDTH_TOLERANCE
		and (hover["colour"] as Color).is_equal_approx(ACCEPTED_LIFE) and String(hover["name"]) == ENEMY_NAME)


func _shown(samples: Array) -> Array:
	return samples.filter(func(sample: Dictionary) -> bool: return bool((sample["live"] as Dictionary)["visible"]))


## Up to three shown readings whose live fill is not the truthful width of the Life read with it.
func _untruthful(shown: Array) -> PackedStringArray:
	var faults: PackedStringArray = PackedStringArray()
	for sample: Dictionary in shown:
		if not _hover_true(sample["live"], float(sample["life"]), float(sample["max"])):
			faults.append("tick %d at %s / %s: %s" % [int(sample["tick"]), _n(float(sample["life"])), _n(float(sample["max"])), _geometry(sample["live"])])
			if faults.size() >= 3:
				break
	return faults


## The first sort of `who`'s hover track, among `sorts`, made with its panel shown.
func _first_visible_sort(sorts: Array, who: String) -> Dictionary:
	for sort: Dictionary in sorts:
		if String(sort["who"]) == who and bool(sort["visible"]):
			return sort
	return {}


func _widths(shown: Array) -> String:
	var values: PackedStringArray = PackedStringArray()
	for sample: Dictionary in shown:
		values.append(_n(float(sample["live"]["fill"])))
	if values.is_empty():
		return "nothing"
	var same: bool = true
	for value: String in values:
		same = same and value == values[0]
	return ("%s px on all %d" % [values[0], values.size()]) if same else ", ".join(values)


func _geometry(hover: Dictionary) -> String:
	if hover.is_empty():
		return "not read"
	var fill: Rect2 = hover["fill_rect"]
	var track: Rect2 = hover["track"]
	var panel: Rect2 = hover["panel"]
	return "fill %s x %s at x %s in a %s x %s track: %.1f%% of 190; the panel %s, %s x %s at (%s, %s)" % [_n(fill.size.x), _n(fill.size.y), _n(fill.position.x),
		_n(track.size.x), _n(track.size.y), 100.0 * fill.size.x / ACCEPTED_HOVER_WIDTH, "shown" if bool(hover["visible"]) else "hidden",
		_n(panel.size.x), _n(panel.size.y), _n(panel.position.x), _n(panel.position.y)]


func _shot_words(enemy: PrototypeGraveblade) -> String:
	var hover: Dictionary = _hover(slice.hud)
	return "%s / %s: \"%s\" %s; route %s" % [_n(enemy.life), _n(enemy.data.max_life), String(hover["name"]), _geometry(hover), _route]


## Everything but the fill's width, minimum and size flag, compared between the two hover panels.
func _same_hover(a: Dictionary, b: Dictionary) -> PackedStringArray:
	var differences: PackedStringArray = PackedStringArray()
	for key: String in ["panel", "track", "content", "name_rect", "resources"]:
		if not (a[key] as Rect2).is_equal_approx(b[key] as Rect2):
			differences.append("%s %s / %s" % [key, str(a[key]), str(b[key])])
	for key: String in ["name", "name_font", "name_align", "panel_min", "panel_anchor", "track_min", "track_radius", "panel_border_width",
			"panel_radius", "panel_margin", "prompt_min", "visible"]:
		if a[key] != b[key]:
			differences.append("%s %s / %s" % [key, str(a[key]), str(b[key])])
	for key: String in ["colour", "track_bg", "panel_bg", "panel_border", "name_colour"]:
		if not (a[key] as Color).is_equal_approx(b[key] as Color):
			differences.append(key)
	var fa: Rect2 = a["fill_rect"]
	var fb: Rect2 = b["fill_rect"]
	if not fa.position.is_equal_approx(fb.position) or not is_equal_approx(fa.size.y, fb.size.y):
		differences.append("fill origin or height %s / %s" % [str(fa), str(fb)])
	return differences


## Both player bars, live against pre-J7, in one reading taken by the pre-slice probe: both HUDs carry
## J6's correction, so each bar must match whole, its fill included.
func _same_bars(sample: Dictionary) -> PackedStringArray:
	var differences: PackedStringArray = PackedStringArray()
	for which: String in ["life", "mana"]:
		var a: Dictionary = sample["%s_bar" % which]
		var b: Dictionary = sample["shadow_%s_bar" % which]
		for key: String in ["fill", "outer", "content", "label"]:
			if not (a[key] as Rect2).is_equal_approx(b[key] as Rect2):
				differences.append("%s %s %s / %s" % [which, key, str(a[key]), str(b[key])])
		for key: String in ["text", "font", "bar_minimum", "minimum", "flags", "border_width", "radius", "shown"]:
			if a[key] != b[key]:
				differences.append("%s %s %s / %s" % [which, key, str(a[key]), str(b[key])])
		for key: String in ["colour", "bg", "border", "font_colour"]:
			if not (a[key] as Color).is_equal_approx(b[key] as Color):
				differences.append("%s %s" % [which, key])
	return differences


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


func _bar_geometry(bar: Dictionary) -> String:
	var fill: Rect2 = bar["fill"]
	var outer: Rect2 = bar["outer"]
	return "\"%s\" fill %s x %s in a %s x %s bar" % [String(bar["text"]), _n(fill.size.x), _n(fill.size.y), _n(outer.size.x), _n(outer.size.y)]


## Everything an attack or the controller's soft targeting reads or writes, as one comparable text.
func _targeting() -> Dictionary:
	var attack: QuickStrikeAction = slice.player.attack
	var rings: Array = []
	for enemy: PrototypeGraveblade in slice.graveblades:
		var ring: Node3D = enemy.get_node_or_null("TargetArea/SoftTargetRing") as Node3D
		rings.append(ring != null and ring.visible)
	return {
		"soft": _id(slice._soft_target), "soft_since": slice._soft_target_since_msec, "forced": _id(slice._forced_aim_target_for_verification),
		"target": _id(attack.target), "phase": attack.phase_name(), "aim": var_to_str(attack.aim), "in_place": attack.attack_in_place,
		"holding": attack.holding, "buffered": attack.buffered, "uses": attack.uses_started, "released": attack.uses_released,
		"queries": attack.release_queries, "acquisition": attack.last_acquisition, "destination": slice.player.has_destination,
		"state": slice.player.action_state_name(), "rings": rings,
	}


func _targeting_key() -> String:
	return var_to_str(_targeting())


func _id(object: Object) -> int:
	return object.get_instance_id() if object != null and is_instance_valid(object) else 0


func _route_words() -> String:
	if _route == "pointer":
		return "the pointer's own route — each harness pointer movement moved the pointer the slice reads (read back at (%d, %d) for the harness's (%d, %d)), and the slice's own _update_hover_info() called show_hover()" % [
			roundi(_route_read_back.x), roundi(_route_read_back.y), roundi(_route_point.x), roundi(_route_point.y)]
	return "STAGED — the slice read the operating system's own cursor at (%d, %d), not the harness's pointer at (%d, %d); in a window the harness never moves that cursor, so it calls the live HUD's show_hover() after the slice on each update, and the pointer-route measurement is the headless run's" % [
		roundi(_route_read_back.x), roundi(_route_read_back.y), roundi(_route_point.x), roundi(_route_point.y)]


func _family() -> String:
	return "controller" if slice.input_family.family == InputFamilyTracker.Family.CONTROLLER else "mouse"


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


# --- The pointer --------------------------------------------------------------------------------

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


func _done(check_name: String) -> void:
	_reached[check_name] = true
