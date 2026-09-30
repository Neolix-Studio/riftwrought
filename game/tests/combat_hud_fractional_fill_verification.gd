extends SceneTree
## First-MVP UI J6 — Player Resource-Bar Fractional Fill Truthfulness V1: automated verification (decision D-332).
##
## THE ONE QUESTION: does the combat HUD's Life fill, and its Mana fill, draw the fraction its own label
## states — full at full, proportional in between, zero-width at zero — after the engine has finished
## laying the HUD out, and on every layout pass after that? Before J6 it did not: while Fallen the label
## read "Life — 0 / 500" and the red fill spanned the whole bar.
##
## THE HUD IS THE ONLY PRODUCTION FILE J6 MOVES, by one layout line and its comment inside `_bar_row()`,
## and that is proved by reconstruction: with the insertion removed it is, byte for byte, the D-331 file.
##
## THE MECHANISM IS MEASURED IN EVERY RUN, NOT ONLY IN THE BASELINE. The pre-J6 HUD is rebuilt from that
## reconstruction, bound to the same player and laid out beside the live one on its own canvas layer,
## moved off-screen. Both receive the same `life_changed` and `mana_changed` emissions and both write the
## same fractional width; at each bar's next `sort_children` the pre-J6 fill has been stretched back to
## the bar's whole content width and the live fill has kept the width it was given. Every background,
## label and container rect of the two is compared: only the fill width may differ.
##
## GATE 1D'S OWN `broken_watch_slice.tscn`, LOADED AS IT SHIPS. Mana is spent by the player's own Quick
## Strikes, Life is taken by the production Graveblade's own attacks, Fallen and Restart are the slice's.
##
## GEOMETRY IS READ AFTER LAYOUT. A harness node before every other node reads the HUD at the start of
## each process update — the state the previous frame's layout flush left, which is the state that frame
## drew — and every `sort_children` of every bar is recorded with the width it left.
##
## STAGED, AND STATED WHERE IT HAPPENS:
##   - both Graveblades are quieted; the first is placed and struck through the slice's seam
##     `force_next_aim_for_verification()`; the second is placed 1.2 m ahead of the player before its
##     attacks, each begun through `begin_attack_for_verification()`;
##   - the player's `mana_regeneration` (10 per second) is held at 0 while each spend is read, and put
##     back at once after, so regeneration cannot move a reading taken after a spend;
##   - one real Quick Strike is swung at nothing, sideways, while Life is at 250 / 500, to reach the state
##     in which both bars are below full;
##   - the controller is made the live family by one left-stick deflection pushed into the root viewport;
##     every mouse event the harness sends carries its own device id and a filter holds back every other;
##   - extra layout passes are forced with `queue_sort()` and `update_minimum_size()`;
##   - the HUD's own two handlers are called directly with values outside [0, maximum] — which play
##     cannot produce — to read the clamp, and are then called again with the player's true values;
##   - the direct opener is called exactly once.
##
## Input is simulated, which is not physical-device certification. With `--shots <dir>` the run also
## saves three evidence frames; they add no assertion, so the rendered runs pin the same count.
##
## IT PORTS D-211's OWED-SET DISCIPLINE.
##
## Run: godot --headless --path game --script res://tests/combat_hud_fractional_fill_verification.gd

const THIS_FILE: String = "res://tests/combat_hud_fractional_fill_verification.gd"
const HUD_SCRIPT: String = "res://scripts/ui/first_mvp_combat_hud.gd"
const SLICE_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
const SLICE_SCENE: String = "res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
const QUICK_STRIKE_RECORD: String = "res://data/prototype_zero/quick_strike.tres"
const STARTING_SWORD: String = "res://data/first_mvp/severed_threshold/broken_watch/starting_sword.tres"
const WATCHSTEEL_SWORD: String = "res://data/first_mvp/severed_threshold/broken_watch/watchsteel_sword.tres"
const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const ENTRYPOINT: String = "res://scenes/app/prototype_app.tscn"
const EXPECTED_ACTIONS: int = 31
const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]

## The HUD as D-331 left it, whole, and J6's insertion inside `_bar_row()`. The pair is [as J6 wrote it,
## as D-331 left it]; it carries the two lines around the insertion so that it is unique.
const PRE_J6_HUD_SHA256: String = "0bb284a18b1e979529771f098ff0845d9634dabe6c593467f38453108595737f"
const J6_HUD_PREFIX: String = "aff939f3"
const J6_INSERTION: String = "\t# First-MVP UI J6 (decision D-332): the fill keeps the width its own minimum\n\t# size gives it. A PanelContainer lays a filling child across its whole\n\t# content rect on every sort, which overrode the fractional width\n\t# `_on_life_changed()` and `_on_mana_changed()` write and drew every bar full.\n\tfill.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN\n"
const J6_LAYOUT_LINE: String = "fill.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN"
const J6_HUD_MOVES: Array = [
	["\tfill.custom_minimum_size = Vector2(BAR_WIDTH, BAR_HEIGHT)\n\t# First-MVP UI J6 (decision D-332): the fill keeps the width its own minimum\n\t# size gives it. A PanelContainer lays a filling child across its whole\n\t# content rect on every sort, which overrode the fractional width\n\t# `_on_life_changed()` and `_on_mana_changed()` write and drew every bar full.\n\tfill.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN\n\tbackground.add_child(fill)\n",
		"\tfill.custom_minimum_size = Vector2(BAR_WIDTH, BAR_HEIGHT)\n\tbackground.add_child(fill)\n"],
]
## The HUD's declarations, as D-331 left them.
const HUD_FIELDS: int = 12
const HUD_FUNCTIONS: int = 12
const HUD_CONSTANTS: int = 10
## The two width writers, code line for code line, as accepted (Gate 1D, D-217).
const LIFE_WRITER: Array[String] = [
	"var fraction: float = clampf(current / maxf(maximum, 0.0001), 0.0, 1.0)",
	"_life_fill.custom_minimum_size = Vector2(BAR_WIDTH * fraction, BAR_HEIGHT)",
	"_life_fill.size.x = BAR_WIDTH * fraction",
	"_life_label.text = \"Life — %.0f / %.0f\" % [current, maximum]",
]
const MANA_WRITER: Array[String] = [
	"var fraction: float = clampf(current / maxf(maximum, 0.0001), 0.0, 1.0)",
	"_mana_fill.custom_minimum_size = Vector2(BAR_WIDTH * fraction, BAR_HEIGHT)",
	"_mana_fill.size.x = BAR_WIDTH * fraction",
	"_mana_label.text = \"Mana — %.0f / %.0f\" % [current, maximum]",
]
## The accepted look, typed independently of the code that draws it.
const ACCEPTED_BAR_WIDTH: float = 260.0
const ACCEPTED_BAR_HEIGHT: float = 22.0
const ACCEPTED_LIFE: Color = Color(0.78, 0.26, 0.24)
const ACCEPTED_MANA: Color = Color(0.30, 0.52, 0.82)
const ACCEPTED_SLATE: Color = Color(0.075, 0.082, 0.098, 0.90)
const ACCEPTED_IRON: Color = Color(0.28, 0.30, 0.35)
## First-MVP UI J8 (D-336) moved the column from its top-left at (24, bottom - 80), which left its lowest 14 px
## below the window, to its bottom-left at (24, bottom - 24): the placement is the bottom-left corner's now.
const ACCEPTED_PLACEMENT: Vector2 = Vector2(24.0, -24.0)
## Measured widths are compared to BAR_WIDTH x fraction within this many pixels.
const WIDTH_TOLERANCE: float = 0.01

## Verification Maintenance V1 (decision D-342): every pair list this suite uses to put a file back lives in
## the flat, content-addressed provenance store under res://tests/provenance/, named by the SHA-256 of its
## listing. Each `*_ROWS` and `*_MOVE_IDS` constant below names its pair lists, and the variable of the old name
## holds them resolved, so every check reads exactly as before. They are resolved through the one engine there,
## and only while it is at the SHA-256 pinned here; a pair list the store cannot prove resolves to nothing.
const PROVENANCE_ENGINE: String = "res://tests/provenance/accepted_suite_provenance.gd"
const PROVENANCE_ENGINE_SHA256: String = "fadbdfeba32546d03bffe876c2b8be7a96dfe966ff9f5d4f720199d664b23dc4"

## The nine accepted suite files J6 moved, each put back to exactly what it was at the end of D-331. Each
## row is [path, its J6 prefix, its D-331 SHA-256, pairs of (as J6 wrote it, as D-331 left it)].
const MOVED_SUITE_ROWS: Array = [
	["res://tests/fallen_modal_life_state_verification.gd", "f065a48d", "ca594f7d27c03c14af93dec0ab30c414a97b3ff4c4a82de69ae1cc416d74b807", "c50dea62f9b616092198b2e91c26bca6a89d98bafdcb0a05f188a99a2aa8799e"],
	["res://tests/pending_fallen_restart_verification.gd", "68a1227e", "b2cfc25307c758bf95d3d8588953aa180e9ee1f2d3891afacb3135d604983cfd", "0cc650ce57c2472c01b53f90a47eedba9c7acec9574185d76b1877fdbcf80356"],
	["res://tests/pending_fallen_restart_smoke.sh", "f7b48202", "6e4120a35fd73a5cbc08246c3ab3d81666b7d5d3e3b9912057afc030676d237e", "2016a5c2988311560e3403a1363641fa22a730bf2e3230e4526d953c278bc4da"],
	["res://tests/fallen_delay_item_interaction_verification.gd", "308fe51a", "7ad7dd679058178779f0483125bc2bfd087d4c68531c42d48db9127b713d3145", "b3dcb377fe37c67d670bc6a44e2bddf4f58d2b0816adc3360bbd9a5e84eb8eb1"],
	["res://tests/fallen_delay_item_interaction_smoke.sh", "b7ff3d66", "ffbb4b7bab8da209b5ec6d7484a8c28805135099cf11999a03af11899eacd906", "edda6209f05ef611f1152881e42f04f56e5744e9edc62ee3222968d008fc7eb1"],
	["res://tests/fallen_delay_drop_highlight_verification.gd", "733d4af8", "d782328aadf458cdba8687050d2b8cecb31102c79288bb329d47daeb046dca98", "c77262133d67775fce5d3e74870784148974a825e159fda6c3b9f83709e5066c"],
	["res://tests/fallen_delay_drop_highlight_smoke.sh", "f5451331", "36583a6d1575ca31e7b8c1ad0fb051c83c8773302da9fd7b6bd26d8f9149607e", "ad9b2011bbe672de3cfd46c0d014c43c38dfbd9da9ac61970edbc033395846f7"],
	["res://tests/global_damage_live_application_smoke.sh", "4f8cad92", "63722475b6c80bfe4691b4f3aa0a765cabd22a66e405a50c36ac1a021759d2dc", "8786e2b737e296d197de83e4e56202b1cd9cb2cd4cb8fd33932b2d406aec5ef0"],
	["res://tests/maximum_life_live_application_smoke.sh", "e5d90d8e", "12fa3bc4942017e26b5393b8d9f1f3f560df9888058d62e1bb1e6aafbd698867", "8786e2b737e296d197de83e4e56202b1cd9cb2cd4cb8fd33932b2d406aec5ef0"],
]
var MOVED_SUITES: Array = _stored(MOVED_SUITE_ROWS)
const MOVED_SUITE_COUNT: int = 9

## First-MVP UI J7 (D-334) moved the combat HUD again and, with it, the nine suite files above. Each is first
## put back to where J6 left it and then read exactly as before: `J7_PREFIXES` holds each file's J7 prefix,
## and `J7_MOVES` its pairs of [as J7 wrote it, as J6 left it], applied to that file alone.
const J7_PREFIXES: Dictionary = {
	HUD_SCRIPT: "38c485cb",
	"res://tests/fallen_modal_life_state_verification.gd": "eb7f4153",
	"res://tests/pending_fallen_restart_verification.gd": "520d9543",
	"res://tests/pending_fallen_restart_smoke.sh": "67cf7ba9",
	"res://tests/fallen_delay_item_interaction_verification.gd": "611891a3",
	"res://tests/fallen_delay_item_interaction_smoke.sh": "d7cf4498",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "44ed4bdf",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "aeba508d",
	"res://tests/global_damage_live_application_smoke.sh": "803b8a7f",
	"res://tests/maximum_life_live_application_smoke.sh": "657c0b17",
}
const J7_MOVE_IDS: Dictionary = {
	HUD_SCRIPT: "c62d3899896a32c432f63933a18e319fe6dca03a8d28ed70f6bd309fe0566cf5",
	"res://tests/fallen_modal_life_state_verification.gd": "3e7c3a327c2fcb3b5ae9daf1a554e1101538d0308bd5394087552c3136fb4d0b",
	"res://tests/pending_fallen_restart_verification.gd": "1c516c4733d0b37638eac8a9e7544bf35b85b9fd7ffa1eb649c6674aa51c612d",
	"res://tests/pending_fallen_restart_smoke.sh": "e9b16d35e517a196779b81c5e027cf5fe5b93969503000e1e3ba6f33a0d2c242",
	"res://tests/fallen_delay_item_interaction_verification.gd": "7164b12714b6238ffa4470cd4d958e1d3ea17605a789432c534024ece612592b",
	"res://tests/fallen_delay_item_interaction_smoke.sh": "89640d63fe43de273c4d04748dedc71f2ef0c6fa712641bf510daa676ab9e5b2",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "bc591361c2f29bcfd0c88cef4081cc0f981d47c021e733492f430d56eefe8d7d",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "238d9c7f30be51ff33cf01b0173dcb5be82ec831c837d9cf3a856d4febcebb55",
	"res://tests/global_damage_live_application_smoke.sh": "9e9110bf4430e1f2ca2cd11454c836975f9d6ca57b3e87dbb317dc5933afc6b2",
	"res://tests/maximum_life_live_application_smoke.sh": "9e9110bf4430e1f2ca2cd11454c836975f9d6ca57b3e87dbb317dc5933afc6b2",
}
var J7_MOVES: Dictionary = _stored(J7_MOVE_IDS)

## First-MVP UI J8 (D-336) moved the combat HUD again and, with it, the nine suite files above. Each is first
## put back to where J7 left it and then read exactly as before: `J8_PREFIXES` holds each file's J8 prefix,
## and `J8_MOVES` its pairs of [as J8 wrote it, as J7 left it], applied to that file alone.
const J8_PREFIXES: Dictionary = {
	HUD_SCRIPT: "ee485029",
	"res://tests/fallen_modal_life_state_verification.gd": "d5407c7c",
	"res://tests/pending_fallen_restart_verification.gd": "1062c1db",
	"res://tests/pending_fallen_restart_smoke.sh": "689284cc",
	"res://tests/fallen_delay_item_interaction_verification.gd": "3deeb26a",
	"res://tests/fallen_delay_item_interaction_smoke.sh": "cb520369",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "c9648eea",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "d2772373",
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
	"res://tests/global_damage_live_application_smoke.sh": "728cbef5f603dffb7ad472008dd703ad760ab628ce803675b6d7ff118687b2c2",
	"res://tests/maximum_life_live_application_smoke.sh": "728cbef5f603dffb7ad472008dd703ad760ab628ce803675b6d7ff118687b2c2",
}
var J8_MOVES: Dictionary = _stored(J8_MOVE_IDS)

## First-MVP Gameplay J9 (D-338) moved seven of the nine suite files above again, one for one, when Gate 1D's
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
}
const J9_MOVE_IDS: Dictionary = {
	"res://tests/fallen_modal_life_state_verification.gd": "fb8d9401ba6c004b0d1e1997f866d76602e5b423be361ff06b383bafc3cc1749",
	"res://tests/pending_fallen_restart_verification.gd": "1a4d7f01639d1180ba3e70a49c8ce4e9c0a1843a82055d515465b366aecc64d8",
	"res://tests/pending_fallen_restart_smoke.sh": "d4f4a6ada9acac4c6a846830bc9283e4d5c4537f03d7a61b32b185a18dad22fb",
	"res://tests/fallen_delay_item_interaction_verification.gd": "155bdaf5bb4dd9b2169b9e4139f9fe758fd3bf98e82add80617e3443f37d5639",
	"res://tests/fallen_delay_item_interaction_smoke.sh": "cec36c2a16824f2215ee25fae06ada08a06280f275458c0013c362e50f33d2c9",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "2f98d83b3abfcaf89832fd0cdf85f33821a4d19b71be7245eb44ea4b86f48c9a",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "8cb05e6397960b68217afa5590a8afa96d4dfaf7b96a6f4696575569624b2ae8",
}
var J9_MOVES: Dictionary = _stored(J9_MOVE_IDS)

## First-MVP Gameplay J10 (D-340) moved seven of the nine suite files above again, one for one, when Gate 1D's
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
}
const J10_MOVE_IDS: Dictionary = {
	"res://tests/fallen_modal_life_state_verification.gd": "26ba84a3fd1582fd17708ff4b49d5522cfbf6142a558114d9c519a6f24ab0250",
	"res://tests/pending_fallen_restart_verification.gd": "d9ffd11477b4bfd3b1c1f297ab77ad7b4ce71a117d1acbd1872907bc18d0fe7a",
	"res://tests/pending_fallen_restart_smoke.sh": "58b1cc938d16d1b2bef63f0552efc11c7596ea019e4bb55e98972b4f9494757d",
	"res://tests/fallen_delay_item_interaction_verification.gd": "bab624db6148b8252317457295986ea7fcdbd0337bc63e5cd1b080eccc80286e",
	"res://tests/fallen_delay_item_interaction_smoke.sh": "8d4a99d6cc235c0be4eb36dc8b9c9518d3ca17e98153302fdf794e950c8a3b16",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "5e3a771c3ee4e816d68cb6cbbd419bd6654f56642c1a8f292ae7cbdb41716bd1",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "7e13fd06e30bb30412f0f1cd1d81b4e61bdafdcbe2a8f14e6b8f8f42b997b9f5",
}
var J10_MOVES: Dictionary = _stored(J10_MOVE_IDS)

## Verification Maintenance V1 (D-342) moved three of the files above again, one for one, when their put-back pairs
## moved into the flat provenance store. Each is first put back to where D-341 left it and then read exactly
## as before: `VM1_PREFIXES` holds each file's D-342 prefix, and `VM1_MOVES` its pairs of [as D-342 wrote it,
## as D-341 left it], named in `VM1_MOVE_IDS` and applied to that file alone.
const VM1_PREFIXES: Dictionary = {
	"res://tests/fallen_delay_item_interaction_verification.gd": "15352d8a",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "6204a260",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "08aa2d0b",
}
const VM1_MOVE_IDS: Dictionary = {
	"res://tests/fallen_delay_item_interaction_verification.gd": "e48a940f496b486a4e3d29945413a32e72c92d04cc1b53079b43b091c391d8ac",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "b3d27bc2dfc663e6044e81edefed212ca94fac1bcc6efd90695f63ef7729b948",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "6c2fd3b783af50c704bf5eadd9ef796f0d6f633b26e674cf5f653c37ce6a3487",
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
}
const J11_MOVE_IDS: Dictionary = {
	"res://tests/fallen_modal_life_state_verification.gd": "e7b62a6207638ff89cd8732cc9bbcfd57503f83f8877662c7a4806a709fdc3c8",
	"res://tests/pending_fallen_restart_verification.gd": "eab887b6ceea266bb06554728df7227e3c47fb0338990a0f9e3209f733f9b6c2",
	"res://tests/pending_fallen_restart_smoke.sh": "a7a5214f7f0fd6e1f4d32fc539df430b11312aee42ad845ee135cbdba73cecd2",
	"res://tests/fallen_delay_item_interaction_verification.gd": "7b773bea4b14e0ff94ae58afcf898e9d269834c1c8bd257ad10717becf55fc07",
	"res://tests/fallen_delay_item_interaction_smoke.sh": "a089abfb62d27e1a1f9d8f3e523c12d8da6f930056aba5d3daa0a7a687f5ce2b",
	"res://tests/fallen_delay_drop_highlight_verification.gd": "93e92c6cdfd494daf85285c7abaa06f5229b1bea0e7e4de67d3b6f02f253f182",
	"res://tests/fallen_delay_drop_highlight_smoke.sh": "a0d7525a31de8048a66815277d6eb7c67b76dc6d90bbfe2eccb519057cd525fa",
}
var J11_MOVES: Dictionary = _stored(J11_MOVE_IDS)

## Everything J6 stands beside, at the SHA-256 prefix each held before the first J6 edit.
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

## The accepted words, typed independently of the code that shows them.
const KILLING_SOURCE: String = "Graveblade — Melee Hit — 125 Physical Damage"
const RESTART_CAPTION: String = "Restart Broken Watch"
const WALK_CLOSER: String = "Walk closer to inspect it"
const DROP_NAME: String = "Watchsteel Sword"

const NEAR_DROP: float = 1.0
const LIVING_NEAR: float = 1.5
const FAR_DROP: float = 4.0
const NEAR: float = 1.2
## Inside the delay: the controller's interact and the direct opener first, a forced layout pass, and the
## mouse click last. Each lands at the first frame with no more than this much left.
const PLAN_A: Array = [{"at": 0.70, "kind": "interact"}, {"at": 0.62, "kind": "layout"}, {"at": 0.55, "kind": "direct"},
	{"at": 0.40, "kind": "click"}]
const SHOT_AT: float = 0.85
## The drop's own pulse lifts an unselected ring at most this far from COPPER toward COPPER_BRIGHT.
const UNSELECTED_PULSE: float = 0.18
const COLOUR_TOLERANCE: float = 0.002
## Where the harness's pre-J6 HUD is drawn: far below the window, so it is never seen and never hovered.
const SHADOW_OFFSET: Vector2 = Vector2(0.0, 100000.0)

const PROBE_SOURCE: String = "extends Node\nvar ticks: int = 0\nvar on_tick: Callable\n\nfunc _process(_delta: float) -> void:\n\tticks += 1\n\tif on_tick.is_valid():\n\t\ton_tick.call(ticks)\n"
const HARNESS_DEVICE: int = 3300
const FILTER_SOURCE: String = "extends Node\nvar device: int = 0\nvar held: int = 0\n\nfunc _input(event: InputEvent) -> void:\n\tif event is InputEventMouse and event.device != device:\n\t\theld += 1\n\t\tget_viewport().set_input_as_handled()\n"

const OWED_CHECKS: Array[String] = [
	"the_production_diff_is_exactly_the_authorized_hud_layout_correction",
	"the_accepted_suites_moved_only_their_hud_pins",
	"only_bar_row_gained_one_layout_line_and_the_width_writers_are_the_accepted_ones",
	"the_hud_reaches_gate_1d_and_its_runtimes_by_instancing_only",
	"no_player_combat_scene_input_map_or_project_behaviour_changed",
	"the_hud_begins_full_at_500_of_500_and_100_of_100",
	"a_real_quick_strike_spends_its_configured_mana_and_the_fill_follows",
	"natural_mana_regeneration_moves_the_fill_truthfully_back_to_full",
	"four_real_graveblade_hits_step_the_life_fill_to_75_50_25_and_zero",
	"the_written_width_now_survives_the_container_sort",
	"the_lethal_hit_still_arms_fallen_and_its_delay",
	"through_the_fallen_delay_the_label_reads_zero_and_no_red_fill_spans_the_bar",
	"the_zero_width_fill_survives_forced_layout_passes_and_drawn_frames",
	"behind_the_fallen_overlay_the_life_fill_stays_empty",
	"a_normal_restart_restores_500_of_500_and_a_full_fill",
	"both_fills_stay_clamped_between_empty_and_full",
	"labels_colours_dimensions_placement_and_borders_are_unchanged",
	"the_j5_highlight_clearing_and_j4_refusals_still_hold",
	"the_living_prompts_messages_comparison_and_equip_still_work",
	"the_hover_life_bar_is_measured_and_left_unchanged",
]

var arguments: PackedStringArray = PackedStringArray()
var slice: BrokenWatchSlice

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _staged: PackedStringArray = PackedStringArray()
var _next_use_id: int = 332000
var _shot_dir: String = ""
var _shots: PackedStringArray = PackedStringArray()

var _pre: Node = null
var _post: Node = null
var _filter: Node = null
## The harness's pre-J6 HUD and the canvas layer it lives on.
var _shadow: Control = null
var _shadow_layer: CanvasLayer = null
var _shadow_built: Dictionary = {}
## Every sort of every bar, in order, and every Life and Mana emission, in order.
var _sorts: Array = []
var _emissions: Array = []
## Readings the pre-slice probe appends while a window is being watched.
var _pre_sink: Array = []
var _pre_sinking: bool = false
var _tick_sink: Array = []
var _sinking: bool = false
var _hover_sink: Array = []
var _hovering: bool = false

var _drop_position: Vector3 = Vector3.INF
var _readings: Dictionary = {}
var _mana: Dictionary = {}
var _hover: Dictionary = {}
var _selection: Dictionary = {}
var _deaths: Dictionary = {}
var _living: Dictionary = {}
var _clamp: Dictionary = {}
var _opened_pending: Array = []
var _cleanups: int = 0


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	_shot_dir = _argument_value("--shots")
	print("")
	print("=== First-MVP UI J6 — Player Resource-Bar Fractional Fill Truthfulness V1 verification (D-332) ===")

	_check_the_production_diff_is_exactly_the_authorized_hud_layout_correction()
	_check_the_accepted_suites_moved_only_their_hud_pins()
	_check_only_bar_row_gained_one_layout_line_and_the_width_writers_are_the_accepted_ones()
	_check_the_hud_reaches_gate_1d_and_its_runtimes_by_instancing_only()
	_check_no_player_combat_scene_input_map_or_project_behaviour_changed()

	await _play()
	if slice != null:
		_check_the_hud_begins_full_at_500_of_500_and_100_of_100()
		_check_a_real_quick_strike_spends_its_configured_mana_and_the_fill_follows()
		_check_natural_mana_regeneration_moves_the_fill_truthfully_back_to_full()
		_check_four_real_graveblade_hits_step_the_life_fill_to_75_50_25_and_zero()
		_check_the_written_width_now_survives_the_container_sort()
		_check_the_lethal_hit_still_arms_fallen_and_its_delay()
		_check_through_the_fallen_delay_the_label_reads_zero_and_no_red_fill_spans_the_bar()
		_check_the_zero_width_fill_survives_forced_layout_passes_and_drawn_frames()
		_check_behind_the_fallen_overlay_the_life_fill_stays_empty()
		_check_a_normal_restart_restores_500_of_500_and_a_full_fill()
		_check_both_fills_stay_clamped_between_empty_and_full()
		_check_labels_colours_dimensions_placement_and_borders_are_unchanged()
		_check_the_j5_highlight_clearing_and_j4_refusals_still_hold()
		_check_the_living_prompts_messages_comparison_and_equip_still_work()
		_check_the_hover_life_bar_is_measured_and_left_unchanged()

	_check_every_check_ran()
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
		print("  foreign pointer events held back: %d — 1 from the harness's own self-check, any other from a real pointer on the window" % int(_filter.get("held")))
	for shot: String in _shots:
		print("  screenshot: %s" % shot)
	if _failures.is_empty():
		print("COMBAT HUD FRACTIONAL FILL VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("COMBAT HUD FRACTIONAL FILL VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		quit(1)


# --- 1–5. Structure: the one file, its one line, its reach ---------------------------------------

func _check_the_production_diff_is_exactly_the_authorized_hud_layout_correction() -> void:
	print("")
	print("--- 1. Exactly one production file moved — the combat HUD — and it is the D-331 file plus one layout line and its comment")
	var source: String = _before_j7(HUD_SCRIPT, _before_j8(HUD_SCRIPT, FileAccess.get_file_as_string(HUD_SCRIPT)))
	var digest: String = source.sha256_text()
	var rebuilt: Dictionary = _put_back(source, J6_HUD_MOVES)
	var pre_text: String = String(rebuilt["text"])
	var removed: String = source.replace(J6_INSERTION, "")
	var lines_now: int = source.count("\n")
	var lines_then: int = pre_text.count("\n")
	_expect(FileAccess.get_sha256(HUD_SCRIPT).begins_with(String(J8_PREFIXES[HUD_SCRIPT]))
			and _before_j8(HUD_SCRIPT, FileAccess.get_file_as_string(HUD_SCRIPT)).sha256_text().begins_with(String(J7_PREFIXES[HUD_SCRIPT]))
			and digest.begins_with(J6_HUD_PREFIX) and bool(rebuilt["unique"]) and pre_text.sha256_text() == PRE_J6_HUD_SHA256
			and source.count(J6_INSERTION) == 1 and lines_now == lines_then + J6_INSERTION.count("\n")
			and removed.sha256_text() == PRE_J6_HUD_SHA256 and (pre_text + "x").sha256_text() != PRE_J6_HUD_SHA256,
		"the HUD hashes %s; the insertion occurs %d time(s); the reconstruction is unique: %s and hashes %s; with the insertion removed it hashes %s"
			% [digest.left(8), source.count(J6_INSERTION), str(rebuilt["unique"]), pre_text.sha256_text().left(8), removed.sha256_text().left(8)])
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in UNCHANGED_HASHES:
		var held: String = FileAccess.get_sha256(String(row[0]))
		if not held.begins_with(String(row[1])):
			moved.append("%s %s" % [String(row[0]).get_file(), held.left(8)])
	_expect(moved.is_empty() and UNCHANGED_HASHES.size() == 53, "moved: %s" % ", ".join(moved))
	print("  the HUD is at its J6 hash %s, %d lines, once J8's replaced line (D-336) is put back and J7's %d inserted lines (D-334) are removed; with J6's %d inserted lines removed it is, byte for byte, the D-331 file %s, %d lines"
		% [J6_HUD_PREFIX, lines_now, _before_j8(HUD_SCRIPT, FileAccess.get_file_as_string(HUD_SCRIPT)).count("\n") - lines_now, J6_INSERTION.count("\n"), PRE_J6_HUD_SHA256.left(8), lines_then])
	print("  %d files J6 stands beside hold the hashes they held before the first J6 edit: the player, Gate 1D's slice, the modal contract, both Fallen overlays, the comparison, the two HUDs beside this one, the drop, the loadout, all 7 descendants of the slice, Prototype Zero's room, the combat, movement, camera and input kernels, the five scenes that instance the HUD and two more, four records, project.godot and nine accepted suite files; Gate 1D's slice and J1's verification since moved by J9 (D-338); the slice and J1's verification again, and Broken Watch's layout, since moved by J10 (D-340)"
		% UNCHANGED_HASHES.size())
	_done("the_production_diff_is_exactly_the_authorized_hud_layout_correction")


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


func _check_the_accepted_suites_moved_only_their_hud_pins() -> void:
	print("")
	print("--- 2. The nine accepted suite files J6 had to move moved only their pins, one for one, at unchanged counts")
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
		var rebuilt: Dictionary = _put_back(j6_text, row[3])
		blocks += (row[3] as Array).size()
		back.append(String(row[2]).left(8))
		if not (FileAccess.get_sha256(path).begins_with(String(J11_PREFIXES.get(path, VM1_PREFIXES.get(path, J10_PREFIXES.get(path, J9_PREFIXES.get(path, J8_PREFIXES.get(path, J7_PREFIXES.get(path, row[1]))))))))
				and j10_text.sha256_text().begins_with(String(J10_PREFIXES.get(path, J9_PREFIXES.get(path, J8_PREFIXES.get(path, J7_PREFIXES.get(path, row[1]))))))
				and j9_text.sha256_text().begins_with(String(J9_PREFIXES.get(path, J8_PREFIXES.get(path, J7_PREFIXES.get(path, row[1])))))
				and j8_text.sha256_text().begins_with(String(J8_PREFIXES.get(path, J7_PREFIXES.get(path, row[1]))))
				and j7_text.sha256_text().begins_with(String(J7_PREFIXES.get(path, row[1]))) and j6_text.sha256_text().begins_with(String(row[1]))
				and bool(rebuilt["unique"]) and not (row[3] as Array).is_empty()
				and String(rebuilt["text"]).sha256_text() == String(row[2])
				and (String(rebuilt["text"]) + "x").sha256_text() != String(row[2])):
			faults.append("%s at %s rebuilds to %s" % [path.get_file(), FileAccess.get_sha256(path).left(8), String(rebuilt["text"]).sha256_text().left(8)])
	_expect(faults.is_empty() and MOVED_SUITES.size() == MOVED_SUITE_COUNT,
		"%d of %d moved suites described; %s" % [MOVED_SUITES.size(), MOVED_SUITE_COUNT, "; ".join(faults)])
	print("  J2's, J3's, J4's and J5's verifications moved their HUD row and the clause naming who moved it, and J3's, J4's and J5's their pins of the suites moved before them; J3's, J4's and J5's runners their hash rows, J5's its production digest; I13's and I14's runners their HUD row: put back, the %d are byte for byte %s (%d replaced blocks)"
		% [MOVED_SUITES.size(), ", ".join(back), blocks])
	_done("the_accepted_suites_moved_only_their_hud_pins")


func _check_only_bar_row_gained_one_layout_line_and_the_width_writers_are_the_accepted_ones() -> void:
	print("")
	print("--- 3. Only _bar_row() changed, by one layout line; the two width writers, the hover bar and every other function are the accepted ones")
	var source: String = _before_j7(HUD_SCRIPT, _before_j8(HUD_SCRIPT, FileAccess.get_file_as_string(HUD_SCRIPT)))
	var pre_text: String = String(_put_back(source, J6_HUD_MOVES)["text"])
	var functions: PackedStringArray = _declared_functions(source)
	var differing: PackedStringArray = PackedStringArray()
	for name: String in functions:
		if name != "_bar_row" and _function_body(source, name) != _function_body(pre_text, name):
			differing.append(name)
	var bar_now: PackedStringArray = _code_lines(_function_body(source, "_bar_row"))
	var expected: PackedStringArray = _code_lines(_function_body(pre_text, "_bar_row"))
	var at: int = expected.find("background.add_child(fill)")
	if at >= 0:
		expected.insert(at, J6_LAYOUT_LINE)
	var code: String = _bare(source)
	var fields: int = RegEx.create_from_string("(?m)^var ").search_all(source).size()
	var constants: int = RegEx.create_from_string("(?m)^const ").search_all(source).size()
	var signals: int = RegEx.create_from_string("(?m)^signal ").search_all(source).size()
	var inserted_code: PackedStringArray = _code_lines(J6_INSERTION)
	var life: PackedStringArray = _code_lines(_function_body(source, "_on_life_changed"))
	var mana: PackedStringArray = _code_lines(_function_body(source, "_on_mana_changed"))
	var fill_mentions: int = code.count("_life_fill") + code.count("_mana_fill")
	_expect(differing.is_empty() and at >= 0 and bar_now == expected and functions == _declared_functions(pre_text)
			and functions.size() == HUD_FUNCTIONS and fields == HUD_FIELDS and constants == HUD_CONSTANTS and signals == 0
			and inserted_code == PackedStringArray([J6_LAYOUT_LINE]) and code.count("size_flags") == 1
			and life == PackedStringArray(LIFE_WRITER) and mana == PackedStringArray(MANA_WRITER)
			and fill_mentions == _bare(pre_text).count("_life_fill") + _bare(pre_text).count("_mana_fill") and fill_mentions == 8
			and not code.contains("_life_fill.visible") and not code.contains("_mana_fill.visible")
			and not code.contains("player.is_alive") and not code.contains("action_state") and not code.to_lower().contains("fallen"),
		"differing %s; _bar_row %s against %s; %d functions, %d fields, %d constants, %d signals; inserted code %s; size_flags %d; life %s; mana %s; fill mentions %d"
			% [str(differing), str(bar_now), str(expected), functions.size(), fields, constants, signals, str(inserted_code),
				code.count("size_flags"), str(life), str(mana), fill_mentions])
	print("  _bar_row(): the accepted %d code lines plus exactly one, before the fill joins its background: %s" % [bar_now.size() - 1, J6_LAYOUT_LINE])
	print("  the other %d functions are byte for byte the accepted ones — _on_life_changed() and _on_mana_changed() still clamp the fraction and write custom_minimum_size and size.x, and show_hover() and the hover bar are untouched as J6 left them — J7 (D-334) has since moved _build() and show_hover() for the hover fill" % (functions.size() - 1))
	print("  %d functions, %d fields, %d constants, no signal — the counts D-331 left; the HUD names no life state and never hides a fill" % [functions.size(), fields, constants])
	_done("only_bar_row_gained_one_layout_line_and_the_width_writers_are_the_accepted_ones")


func _check_the_hud_reaches_gate_1d_and_its_runtimes_by_instancing_only() -> void:
	print("")
	print("--- 4. What the line reaches (structural): every scene that instances the HUD, and nothing that reaches inside it")
	var scenes: PackedStringArray = PackedStringArray()
	for path: String in _files_under("res://scenes", [".tscn"]):
		if FileAccess.get_file_as_string(path).contains("path=\"%s\"" % HUD_SCRIPT):
			scenes.append(path)
	scenes.sort()
	var subclasses: PackedStringArray = PackedStringArray()
	var reachers: PackedStringArray = PackedStringArray()
	var scanned: int = 0
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd"]):
			if path == HUD_SCRIPT:
				continue
			scanned += 1
			var code: String = _bare(FileAccess.get_file_as_string(path))
			if code.contains("extends FirstMvpCombatHud"):
				subclasses.append(path.get_file())
			for token: String in ["_life_fill", "_mana_fill", "_bar_row", "_life_label", "_mana_label"]:
				if code.contains(token) and not path.get_file() in ["prototype_hud.gd", "gate_c_combat_overlay.gd", "gate_d_encounter_overlay.gd"]:
					reachers.append("%s:%s" % [path.get_file(), token])
	_expect(scenes == PackedStringArray(HUD_SCENES) and subclasses.is_empty() and reachers.is_empty() and scanned > 100,
		"scenes %s; subclasses %s; reaching in %s" % [str(scenes), str(subclasses), str(reachers)])
	print("  %d scenes instance the HUD: %s" % [scenes.size(), ", ".join(Array(scenes).map(func(p: String) -> String: return p.get_file()))])
	print("  of %d other running scripts none extends FirstMvpCombatHud or reads its fills, labels or _bar_row() — Prototype Zero's three HUDs declare their own labels of the same name and never see this one"
		% scanned)
	print("  canonical_opening.tscn is Gate 1E's scene: it inherits the correction by instancing the same script — structural only, not measured here")
	_done("the_hud_reaches_gate_1d_and_its_runtimes_by_instancing_only")


func _check_no_player_combat_scene_input_map_or_project_behaviour_changed() -> void:
	print("")
	print("--- 5. The InputMap, the entrypoint and project.godot are untouched; the player, combat, scenes and records hold their pre-J6 hashes (check 1)")
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	var naming: PackedStringArray = PackedStringArray()
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd", ".tscn", ".tres"]):
			if FileAccess.get_file_as_string(path).contains("combat_hud_fractional_fill"):
				naming.append(path)
	_expect(actions == EXPECTED_ACTIONS and String(ProjectSettings.get_setting("application/run/main_scene", "")) == ENTRYPOINT
			and not settings.contains("[autoload]") and not settings.contains("combat_hud_fractional_fill") and naming.is_empty(),
		"%d actions, or project.godot moved, or a running file names the harness: %s" % [actions, str(naming)])
	print("  %d actions; the entrypoint is %s; project.godot declares no [autoload]; nothing that runs names the J6 harness" % [actions, ENTRYPOINT.get_file()])
	_done("no_player_combat_scene_input_map_or_project_behaviour_changed")


# --- The play, in Gate 1D's own slice ---------------------------------------------------------

func _play() -> void:
	slice = await _load(SLICE_SCENE) as BrokenWatchSlice
	if slice == null:
		return
	await _await_navigation()
	_install_probes()
	_install_shadow()
	_watch_sorts()
	_watch_emissions()
	_quiet()
	slice.fallen_overlay.opened.connect(func() -> void: _opened_pending.append(slice._pending_fallen_event))
	_note("Gate 1D's two Graveblades quieted; two harness nodes count every process update, one before the slice and one after it")
	var window: Vector2i = DisplayServer.window_get_size()
	var visible: Vector2 = root.get_visible_rect().size
	print("  display %s, window %dx%d, visible %dx%d" % [DisplayServer.get_name(), window.x, window.y, roundi(visible.x), roundi(visible.y)])
	if _shadow == null:
		return

	await _settle(3)
	await _await_process_frames(3)
	_readings["start"] = _read("start")
	var shot: String = await _capture("01_full_life_500_of_500")
	if not shot.is_empty():
		_shots.append("%s — %s" % [shot, _shot_words()])

	await _mana_phase()
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
	await _settle(3)
	await _await_process_frames(3)
	_readings["restart"] = _read("restart")

	await _living_after_restart()
	await _clamp_by_the_handlers()
	await _living_equip()


func _install_probes() -> void:
	var script: GDScript = GDScript.new()
	script.source_code = PROBE_SOURCE
	script.reload()
	_pre = Node.new()
	_pre.name = "J6ProbeBeforeTheSlice"
	_pre.set_script(script)
	_pre.process_priority = -1000000
	_pre.process_mode = Node.PROCESS_MODE_ALWAYS
	_pre.set("on_tick", _on_pre_tick)
	_post = Node.new()
	_post.name = "J6ProbeAfterTheSlice"
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
	_filter.name = "J6ForeignPointerFilter"
	_filter.set_script(filter)
	_filter.set("device", HARNESS_DEVICE)
	_filter.process_mode = Node.PROCESS_MODE_ALWAYS
	root.add_child(_filter)
	_note("every mouse event the harness sends carries device id %d; a harness node ahead of the slice holds back every other mouse event, and one foreign pointer movement is sent on purpose to prove it" % HARNESS_DEVICE)


## The pre-J6 HUD: the D-331 source reconstructed from the file on disk, its `class_name` line dropped so
## it does not collide with the live class, bound to the same room, on its own canvas layer far below the
## window. It is a comparison instrument only; nothing in the slice knows it exists.
func _install_shadow() -> void:
	# First-MVP UI J8 (D-336): the comparison keeps J8's column placement, so that both columns stand in one place
	# and every rect below is still compared whole; J8's line is put back as well to prove the D-331 source.
	var kept: String = String(_put_back(_before_j7(HUD_SCRIPT, FileAccess.get_file_as_string(HUD_SCRIPT)), J6_HUD_MOVES)["text"])
	var source: String = _before_j8(HUD_SCRIPT, kept)
	_shadow_built = {"hash": source.sha256_text(), "class_line": source.count("class_name FirstMvpCombatHud\n")}
	if source.sha256_text() != PRE_J6_HUD_SHA256:
		_failures.append("the pre-J6 HUD could not be reconstructed (%s), so the comparison instrument was not built" % source.sha256_text().left(8))
		return
	var script: GDScript = GDScript.new()
	script.source_code = kept.replace("class_name FirstMvpCombatHud\n", "")
	var compiled: Error = script.reload()
	_shadow_built["compiled"] = compiled
	if compiled != OK:
		_failures.append("the pre-J6 HUD did not compile (%d)" % compiled)
		return
	_shadow_layer = CanvasLayer.new()
	_shadow_layer.name = "J6PreJ6HudLayer"
	_shadow_layer.offset = SHADOW_OFFSET
	root.add_child(_shadow_layer)
	_shadow = Control.new()
	_shadow.name = "PreJ6Hud"
	_shadow.set_script(script)
	_shadow_layer.add_child(_shadow)
	_shadow.call("bind_room", slice)
	_note("the pre-J6 HUD, reconstructed from the HUD file with J7's insertions (D-334) and then J6's insertion removed, J8's column placement (D-336) kept — %s once J8's line is put back too — bound to the same player on a canvas layer offset %d px below the window, as a comparison instrument"
		% [PRE_J6_HUD_SHA256.left(8), int(SHADOW_OFFSET.y)])


## Every `sort_children` of the four bars: which bar, whose, and the width the sort left.
func _watch_sorts() -> void:
	if _shadow == null:
		return
	for pair: Array in [["live", slice.hud], ["shadow", _shadow]]:
		for which: String in ["life", "mana"]:
			var hud: Control = pair[1]
			var fill: ColorRect = hud.get("_%s_fill" % which)
			var background: Container = fill.get_parent() as Container
			var who: String = "%s_%s" % [String(pair[0]), which]
			background.sort_children.connect(func() -> void:
				_sorts.append({"who": who, "fill": fill.size.x, "content": _content(background).size.x, "pre": _pre_ticks(),
					"drawn": Engine.get_frames_drawn()}))


## Every Life and Mana emission, read after both HUDs' handlers have run: the value, and the width each
## handler has just written, before any sort.
func _watch_emissions() -> void:
	if _shadow == null:
		return
	var player: PrototypePlayer = slice.player
	var last: Dictionary = {"life": player.life, "mana": player.mana}
	for which: String in ["life", "mana"]:
		var emitted: Signal = player.life_changed if which == "life" else player.mana_changed
		emitted.connect(func(current: float, maximum: float) -> void:
			var kind: String = "same"
			if current < float(last[which]) - 0.0001:
				kind = "down"
			elif current > float(last[which]) + 0.0001:
				kind = "up"
			last[which] = current
			_emissions.append({"which": which, "kind": kind, "value": current, "max": maximum, "mark": _sorts.size(),
				"live": (slice.hud.get("_%s_fill" % which) as ColorRect).size.x, "shadow": (_shadow.get("_%s_fill" % which) as ColorRect).size.x,
				"text": (slice.hud.get("_%s_label" % which) as Label).text}))


func _on_pre_tick(tick: int) -> void:
	if slice == null or _shadow == null:
		return
	if _pre_sinking:
		_pre_sink.append(_quick(tick))
	if _hovering:
		var hud: FirstMvpCombatHud = slice.hud
		_hover_sink.append({"tick": tick, "visible": hud._hover_panel.visible, "name": hud._hover_name.text,
			"fill": hud._hover_fill.size.x, "track": (hud._hover_fill.get_parent() as Control).size.x,
			"life": slice.graveblades[0].life, "max": slice.graveblades[0].data.max_life, "drawn": Engine.get_frames_drawn()})


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
	return int(_pre.get("ticks")) if _pre != null else -1


# --- Readings of the two HUDs -----------------------------------------------------------------

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
		"minimum": fill.custom_minimum_size, "bar_minimum": background.custom_minimum_size, "container": background is PanelContainer,
		"bg": style.bg_color if style != null else Color(), "border": style.border_color if style != null else Color(),
		"border_width": style.border_width_left if style != null else -1, "radius": style.corner_radius_top_left if style != null else -1,
		"share": rect.size.x / content.size.x if content.size.x > 0.0 else -1.0,
	}


func _bars(hud: Control) -> Dictionary:
	var resources: Control = hud.get_node("Resources") as Control
	return {"life": _bar(hud, "life"), "mana": _bar(hud, "mana"), "resources": resources.get_global_rect(),
		"prompt_min": (hud.get("_prompt_panel") as Control).custom_minimum_size, "hover_min": (hud.get("_hover_panel") as Control).custom_minimum_size}


func _read(tag: String) -> Dictionary:
	var player: PrototypePlayer = slice.player
	return {"tag": tag, "life": player.life, "max_life": player.max_life, "mana": player.mana, "max_mana": player.max_mana,
		"state": player.action_state_name(), "live": _bars(slice.hud), "shadow": _bars(_shadow), "sorts": _sorts.size(),
		"pre": _pre_ticks(), "drawn": Engine.get_frames_drawn(), "viewport": root.get_visible_rect().size}


## The lightweight reading the pre-slice probe takes on every update of a watched window.
func _quick(tick: int) -> Dictionary:
	var life: Dictionary = _bar(slice.hud, "life")
	var mana: Dictionary = _bar(slice.hud, "mana")
	return {"tick": tick, "drawn": Engine.get_frames_drawn(), "life": slice.player.life, "max_life": slice.player.max_life,
		"mana": slice.player.mana, "max_mana": slice.player.max_mana, "life_bar": life, "mana_bar": mana,
		"shadow_life": (_shadow.get("_life_fill") as ColorRect).size.x, "overlay": slice.fallen_overlay.is_open,
		"paused": paused, "countdown": slice._fallen_countdown, "state": slice.player.action_state_name()}


## Does this bar draw exactly the fraction of `value` over `maximum`, inside its content, in its colour?
func _bar_true(bar: Dictionary, value: float, maximum: float, caption: String, colour: Color) -> bool:
	var expected: float = ACCEPTED_BAR_WIDTH * clampf(value / maxf(maximum, 0.0001), 0.0, 1.0)
	var fill: Rect2 = bar["fill"]
	var content: Rect2 = bar["content"]
	return (absf(fill.size.x - expected) <= WIDTH_TOLERANCE and fill.position.is_equal_approx(content.position)
		and is_equal_approx(fill.size.y, content.size.y) and fill.end.x <= content.end.x + WIDTH_TOLERANCE
		and bool(bar["shown"]) and String(bar["text"]) == "%s — %.0f / %.0f" % [caption, value, maximum]
		and (bar["colour"] as Color).is_equal_approx(colour))


func _life_true(reading: Dictionary) -> bool:
	return _bar_true(reading["live"]["life"], float(reading["life"]), float(reading["max_life"]), "Life", ACCEPTED_LIFE)


func _mana_true(reading: Dictionary) -> bool:
	return _bar_true(reading["live"]["mana"], float(reading["mana"]), float(reading["max_mana"]), "Mana", ACCEPTED_MANA)


func _geometry(bar: Dictionary) -> String:
	var fill: Rect2 = bar["fill"]
	var outer: Rect2 = bar["outer"]
	var content: Rect2 = bar["content"]
	return "fill %s x %s at x %s in a %s x %s bar (content %s wide): %.1f%%" % [_n(fill.size.x), _n(fill.size.y), _n(fill.position.x),
		_n(outer.size.x), _n(outer.size.y), _n(content.size.x), 100.0 * float(bar["share"])]


func _shot_words() -> String:
	var life: Dictionary = _bar(slice.hud, "life")
	var mana: Dictionary = _bar(slice.hud, "mana")
	return "%s, \"%s\" %s; \"%s\" %s" % [slice.player.action_state_name(), String(life["text"]), _geometry(life), String(mana["text"]), _geometry(mana)]


# --- Mana: three real Quick Strikes, a hover, and regeneration ---------------------------------

## STAGED aim, real attacks: the first Graveblade is placed on the route and struck by the player's own
## Quick Strikes, aimed through the slice's verification seam. Regeneration is held at 0 while each spend
## is read and put back after the kill; the hover is read once, after the first strike.
func _mana_phase() -> void:
	var player: PrototypePlayer = slice.player
	var first: PrototypeGraveblade = slice.graveblades[0]
	var area: PrototypeTargetable = first.get_node("TargetArea") as PrototypeTargetable
	var forward: Vector3 = _forward()
	first.place_at(slice.landing_layout.player_start() + forward * 6.0)
	first.face_instantly(-forward)
	await _settle(2)
	var regeneration: float = player.mana_regeneration
	_mana["regeneration"] = regeneration
	_mana["cost"] = player.attack.data.mana_cost
	_mana["recorded_cost"] = (load(QUICK_STRIKE_RECORD) as QuickStrikeData).mana_cost
	player.mana_regeneration = 0.0
	_note("the player's mana_regeneration held at 0 from %s while each Quick Strike's spend is read, then put back" % _n(regeneration))
	var strikes: Array = []
	var trail: Array = [first.life]
	for hit: int in 6:
		if not first.is_alive():
			break
		_stand_facing(first.global_position - forward * 1.0, forward)
		await _settle(1)
		var spent: float = player.attack.mana_spent_total
		slice.force_next_aim_for_verification(area)
		player.attack.press()
		player.attack.release_input()
		for frame: int in 120:
			await physics_frame
			if float(trail[-1]) > first.life and player.attack.phase == QuickStrikeAction.Phase.READY:
				break
		trail.append(first.life)
		await _await_process_frames(3)
		var reading: Dictionary = _read("strike %d" % (hit + 1))
		reading["spent"] = player.attack.mana_spent_total - spent
		strikes.append(reading)
		if hit == 0:
			await _hover_measurement(first)
	_mana["strikes"] = strikes
	_mana["trail"] = trail
	_mana["dead"] = not first.is_alive()
	await _settle(3)
	_note("the first Graveblade placed on Riftfall Landing's route and struck by the player's own Quick Strikes, aimed through force_next_aim_for_verification()")
	player.mana_regeneration = regeneration
	_mana["regeneration_back"] = player.mana_regeneration
	_mana["regen"] = await _watch_regeneration("regeneration after the kill")


## Every update until Mana is full again and five after, read by the pre-slice probe.
func _watch_regeneration(tag: String) -> Dictionary:
	var player: PrototypePlayer = slice.player
	var started: float = player.mana
	_pre_sink = []
	_pre_sinking = true
	var full_for: int = 0
	for frame: int in 600:
		await process_frame
		if player.mana >= player.max_mana:
			full_for += 1
			if full_for > 5:
				break
	_pre_sinking = false
	var samples: Array = _pre_sink
	_pre_sink = []
	return {"tag": tag, "from": started, "samples": samples, "end": _read(tag)}


## The hover bar, read by the pointer's own route: one real pointer movement over the damaged first
## Graveblade, then away. Measured and reported; J6 does not change it.
func _hover_measurement(first: PrototypeGraveblade) -> void:
	var camera: Camera3D = slice.camera_rig.camera
	var over: Vector2 = camera.unproject_position(first.global_position + Vector3(0.0, 0.9, 0.0))
	await _family_cooldown()
	_hover_sink = []
	_hovering = true
	var motion: InputEventMouseMotion = _motion_event(over)
	motion.relative = Vector2(8.0, 0.0)
	Input.parse_input_event(motion)
	await _await_process_frames(1)
	# What the slice will read: in a window this is the operating system's own cursor, which the harness
	# never moves; headless it is the pointer the event above placed.
	var read_back: Vector2 = slice.get_viewport().get_mouse_position()
	await _await_process_frames(7)
	var away: InputEventMouseMotion = _motion_event(Vector2(root.get_visible_rect().size.x * 0.8, root.get_visible_rect().size.y * 0.3))
	away.relative = Vector2(8.0, 0.0)
	Input.parse_input_event(away)
	await _await_process_frames(4)
	_hovering = false
	_hover = {"samples": _hover_sink, "family": _family(), "point": over, "read_back": read_back, "life": first.life, "max": first.data.max_life}
	_hover_sink = []
	_note("one pointer movement over the damaged first Graveblade and one away from it, to read the hover bar")


# --- Life: four real Hits, Fallen, the delay, the overlay, the restart --------------------------

## STAGED position, real input: the living character stands 1.0 m from the drop, read with the mouse as
## the live family and then with the controller, as J5 read it.
func _controller_selects_the_drop() -> void:
	var player: PrototypePlayer = slice.player
	var forward: Vector3 = _forward()
	await _until_neutral()
	_quiet()
	_stand_facing(_drop_position + forward * NEAR_DROP, forward)
	await _settle(2)
	await _await_process_frames(3)
	var at: Vector3 = player.global_position
	await _to_controller()
	await _await_process_frames(3)
	var on: Dictionary = _reading()
	on["moved"] = _planar_gap(at, player.global_position)
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
	_note("the living character placed %.1f m from the drop before the death" % NEAR_DROP)


## STAGED: one left-stick deflection past the tracker's 0.20 threshold, and its return to rest, pushed
## into the root viewport. The Input singleton never sees it, so the character does not move.
func _to_controller() -> void:
	await _family_cooldown()
	_push_axis(JOY_AXIS_LEFT_X, 0.5)
	_push_axis(JOY_AXIS_LEFT_X, 0.0)
	for frame: int in 30:
		if slice.input_family.family == InputFamilyTracker.Family.CONTROLLER:
			break
		await process_frame
	_note("the controller made the live family by one left-stick deflection pushed into the root viewport, which the Input singleton never sees")


## STAGED start, real Hits: the second Graveblade 1.2 m ahead, each attack begun through its own seam. Each
## living Hit is read after three process updates; after the second, one real Quick Strike swung sideways
## at nothing brings Mana below full too, and regeneration is watched back to full with Life at 250.
## `fell` is heard at once and DEFERRED, as J5 heard it.
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
	var record: Dictionary = {"label": label, "counts": counts, "trail": [], "began": 0, "hits": [], "living": _reading(),
		"life_before": player.life, "ticks": []}
	var on_damage: Callable = func(_event: DamageEvent) -> void: counts["took_damage"] = int(counts["took_damage"]) + 1
	var on_fell: Callable = func(event: DamageEvent) -> void:
		counts["fell"] = int(counts["fell"]) + 1
		record["at_kill"] = {"pre": _pre_ticks(), "physics": Engine.is_in_physics_frame(), "process": Engine.get_process_frames(),
			"drawn": Engine.get_frames_drawn(), "countdown": slice._fallen_countdown, "pending": slice._pending_fallen_event == event,
			"usec": Time.get_ticks_usec()}
		_tick_sink = record["ticks"]
		_sinking = true
		_pre_sink = []
		_pre_sinking = true
	var on_fell_deferred: Callable = func(event: DamageEvent) -> void: _on_lethal_frame(record, event)
	player.took_damage.connect(on_damage)
	player.fell.connect(on_fell)
	player.fell.connect(on_fell_deferred, CONNECT_DEFERRED)
	record["listeners"] = [on_damage, on_fell, on_fell_deferred]

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
			var shot: String = await _capture("02_partial_life_250_of_500")
			if not shot.is_empty():
				_shots.append("%s — %s" % [shot, _shot_words()])
			await _both_below_full(forward)
	var event: DamageEvent = player.last_damage_taken
	record["event"] = event
	record["dead"] = not player.is_alive()
	record["from_killer"] = event != null and event.source == killer
	return record


## Life at 250 / 500 and one real Quick Strike swung sideways, where no Graveblade stands, with
## regeneration held at 0 so the spend can be read; then regeneration is put back and watched to full.
func _both_below_full(forward: Vector3) -> void:
	var player: PrototypePlayer = slice.player
	var regeneration: float = player.mana_regeneration
	var sideways: Vector3 = Vector3(-forward.z, 0.0, forward.x)
	player.mana_regeneration = 0.0
	player.face_instantly(sideways)
	await _settle(1)
	var spent: float = player.attack.mana_spent_total
	var damage_dealt: int = player.attack.damage_events
	player.attack.press()
	player.attack.release_input()
	for frame: int in 120:
		await physics_frame
		if player.attack.mana_spent_total > spent and player.attack.phase == QuickStrikeAction.Phase.READY:
			break
	await _await_process_frames(3)
	var reading: Dictionary = _read("both below full")
	reading["spent"] = player.attack.mana_spent_total - spent
	reading["dealt"] = player.attack.damage_events - damage_dealt
	_mana["both"] = reading
	player.mana_regeneration = regeneration
	_mana["both_regen"] = await _watch_regeneration("regeneration with Life at 250")
	player.face_instantly(forward)
	await _settle(1)
	_note("one real Quick Strike swung sideways at nothing with Life at 250 / 500 and regeneration held at 0, then put back")


## The lethal frame: the deferred call on `fell`, before the slice has processed again.
func _on_lethal_frame(record: Dictionary, event: DamageEvent) -> void:
	var player: PrototypePlayer = slice.player
	var at_kill: Dictionary = record.get("at_kill", {})
	record["lethal"] = {
		"same_step": _pre_ticks() == int(at_kill.get("pre", -1)),
		"process_same": Engine.get_process_frames() == int(at_kill.get("process", -1)),
		"state": player.action_state_name(), "alive": player.is_alive(), "life": player.life,
		"text": slice.hud._life_label.text, "soft": _soft(), "family": _family(), "in_range": _in_range(),
		"nameplate": slice._nameplate.visible, "centre": slice._nameplate.get_global_rect().get_center(), "prompt": _prompt(),
		"paused": paused, "countdown": slice._fallen_countdown, "pending": slice._pending_fallen_event == event,
		"overlay": slice.fallen_overlay.is_open, "comparison": slice.item_comparison.is_open,
	}


## Samples every process frame of the delay until the overlay opens by itself, making each planned
## attempt at the first frame with no more than its time left.
func _through_the_delay(record: Dictionary, plan: Array) -> void:
	var player: PrototypePlayer = slice.player
	var overlay: FirstMvpFallenOverlay = slice.fallen_overlay
	var event: DamageEvent = record["event"]
	var opens: int = overlay.opens
	var opened_mark: int = _opened_pending.size()
	var attempts: Array = []
	var layouts: Array = []
	var next: int = 0
	var shot_taken: bool = false
	for frame: int in 900:
		if overlay.is_open:
			break
		if slice.item_comparison.is_open:
			slice.item_comparison.close("verification cleanup")
			_cleanups += 1
		if not _shot_dir.is_empty() and not shot_taken and slice._fallen_countdown > 0.0 and slice._fallen_countdown <= SHOT_AT:
			shot_taken = true
			var shot: String = await _capture("03_fallen_life_0_of_500")
			if not shot.is_empty():
				_shots.append("%s — %s, %.3f s of the delay left, overlay %s" % [shot, _shot_words(), slice._fallen_countdown,
					"open" if overlay.is_open else "not open"])
		if next < plan.size() and slice._fallen_countdown > 0.0 and slice._fallen_countdown <= float(plan[next]["at"]):
			if String(plan[next]["kind"]) == "layout":
				layouts.append(await _force_layout("inside the delay"))
			else:
				attempts.append(await _attempt(record, String(plan[next]["kind"])))
			next += 1
		await process_frame
	record["open_usec"] = Time.get_ticks_usec()
	record["attempts"] = attempts
	record["layouts"] = layouts
	var at_open: Array = _opened_pending.slice(opened_mark)
	var focus: Control = overlay.default_focus()
	record["opened"] = {
		"once": overlay.is_open and overlay.opens == opens + 1 and at_open.size() == 1,
		"with_event": at_open.size() == 1 and at_open[0] == event, "source": overlay.killing_source,
		"state": player.action_state_name(), "alive": player.is_alive(), "paused": paused,
		"countdown": slice._fallen_countdown, "pending_is_event": slice._pending_fallen_event == event,
		"focused": focus != null and root.gui_get_focus_owner() == focus and focus.name == RESTART_CAPTION,
	}
	record["delay"] = _pre_sink.duplicate()


## STAGED extra layout passes on both HUDs' Life bars: each background, its row and the resources column
## re-sorted, and the fill's minimum size re-announced; read after the engine has run them.
func _force_layout(tag: String) -> Dictionary:
	var mark: int = _sorts.size()
	for hud: Control in [slice.hud, _shadow]:
		var fill: ColorRect = hud.get("_life_fill")
		var background: Container = fill.get_parent() as Container
		background.queue_sort()
		(background.get_parent() as Container).queue_sort()
		(hud.get_node("Resources") as Container).queue_sort()
		fill.update_minimum_size()
	await _await_process_frames(2)
	_note("extra layout passes forced %s with queue_sort() on each Life bar, its row and the resources column, and update_minimum_size() on the fill" % tag)
	return {"tag": tag, "sorts": _sorts.slice(mark), "reading": _read("forced layout %s" % tag)}


## One attempt at the item from inside the delay, as J5 made them.
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
			_note("the opener called directly once, inside the delay, for the direct-entry refusal")
	await _await_process_frames(1)
	result["comparison"] = slice.item_comparison.is_open
	result["paused"] = paused
	result["same"] = _same_items(before, _item_state())
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


func _synchronous(remaining: float, message: Dictionary) -> Dictionary:
	return {
		"comparison": slice.item_comparison.is_open, "paused": paused, "countdown_same": slice._fallen_countdown == remaining,
		"message_same": _hud_message() == message, "message": _hud_message(), "soft": _soft(),
	}


## Behind the standing overlay: 10 paused physics and 5 idle frames, one forced layout pass among them.
func _behind_the_overlay(record: Dictionary) -> void:
	_pre_sink = []
	_pre_sinking = true
	var faults: PackedStringArray = PackedStringArray()
	var read: int = 0
	for frame: int in 10:
		await physics_frame
		read += 1
		if not _behind_ok():
			faults.append("physics frame %d %s" % [frame, str(_reading())])
	var forced: Dictionary = await _force_layout("behind the Fallen overlay")
	read += 2
	for frame: int in 5:
		await process_frame
		read += 1
		if not _behind_ok():
			faults.append("idle frame %d %s" % [frame, str(_reading())])
	_pre_sinking = false
	record["behind"] = {"faults": faults, "read": read, "samples": _pre_sink.duplicate(), "forced": forced,
		"reading": _read("behind the overlay"), "soft": _soft(), "ring": _ring(slice._active_drop)}
	_pre_sink = []


func _behind_ok() -> bool:
	var life: Dictionary = _bar(slice.hud, "life")
	return (slice.fallen_overlay.is_open and paused and not slice.item_comparison.is_open and not slice._nameplate.visible
		and _prompt().is_empty() and not slice.player.is_alive() and not _soft()
		and bool(_ring(slice._active_drop).get("ordinary", false))
		and String(life["text"]) == "Life — 0 / 500" and (life["fill"] as Rect2).size.x == 0.0)


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


# --- The living character, after a normal restart ---------------------------------------------

## STAGED positions, real input: in range with the controller, out of range with one (A) press, back in
## range, then the mouse made live by one real pointer movement.
func _living_after_restart() -> void:
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
	var message: Dictionary = _hud_message()
	_push_joy(JOY_BUTTON_A, true)
	_living["walk_closer"] = {"before": message, "after": _hud_message(), "comparison": slice.item_comparison.is_open}
	_push_joy(JOY_BUTTON_A, false)
	await _await_process_frames(2)
	_stand_facing(_drop_position + forward * LIVING_NEAR, forward)
	await _settle(2)
	await _await_process_frames(3)
	_living["back"] = _reading()
	await _point_with_the_mouse(slice._nameplate.get_global_rect().get_center())
	await _await_process_frames(3)
	_living["mouse"] = _reading()
	_note("the living character placed %.1f m, %.1f m and %.1f m from the drop after the restart" % [LIVING_NEAR, FAR_DROP, LIVING_NEAR])


## STAGED, and only here: the HUD's own two handlers called with values play cannot produce — above the
## maximum and below zero — then called again with the player's true values.
func _clamp_by_the_handlers() -> void:
	var hud: FirstMvpCombatHud = slice.hud
	var player: PrototypePlayer = slice.player
	var cases: Array = [["life", 600.0, 500.0], ["life", -50.0, 500.0], ["mana", 130.0, 100.0], ["mana", -20.0, 100.0]]
	var results: Array = []
	for case: Array in cases:
		if String(case[0]) == "life":
			hud._on_life_changed(float(case[1]), float(case[2]))
		else:
			hud._on_mana_changed(float(case[1]), float(case[2]))
		await _await_process_frames(2)
		results.append({"case": case, "bar": _bar(hud, String(case[0]))})
	hud._on_life_changed(player.life, player.max_life)
	hud._on_mana_changed(player.mana, player.max_mana)
	await _await_process_frames(2)
	_clamp = {"results": results, "restored": _read("restored after the clamp")}
	_note("the HUD's own _on_life_changed() and _on_mana_changed() called directly with 600 / 500, -50 / 500, 130 / 100 and -20 / 100, then with the player's true values")


## The accepted living route: the controller's interact in range opens the comparison, joypad right moves
## focus to Equip and (A) equips.
func _living_equip() -> void:
	var player: PrototypePlayer = slice.player
	var comparison: FirstMvpItemComparison = slice.item_comparison
	await _to_controller()
	await _await_process_frames(3)
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
	by_pad["lines"] = _log_count("weapon equipped") - int(near["equipped_logs"])
	by_pad["message"] = _hud_message()
	by_pad["reading"] = _read("after the equip")
	var after_opens: int = comparison.opens
	_push_joy(JOY_BUTTON_A, true)
	_push_joy(JOY_BUTTON_A, false)
	await _await_process_frames(2)
	by_pad["again"] = {"opens": comparison.opens - after_opens, "equips": equips[0], "open": comparison.is_open}
	player.weapon_changed.disconnect(on_equip)
	comparison.closed.disconnect(on_closed)
	_living["by_pad"] = by_pad


# --- 6–20. What the play measured -------------------------------------------------------------

func _check_the_hud_begins_full_at_500_of_500_and_100_of_100() -> void:
	print("")
	print("--- 6. The HUD begins full: 500 / 500 and 100 / 100, each fill the width of its bar's content")
	var start: Dictionary = _readings.get("start", {})
	var ok: bool = not start.is_empty() and float(start["life"]) == 500.0 and float(start["max_life"]) == 500.0
	ok = ok and float(start["mana"]) == 100.0 and _life_true(start) and _mana_true(start)
	var life: Dictionary = start["live"]["life"] if ok else {}
	var mana: Dictionary = start["live"]["mana"] if ok else {}
	_expect(ok and is_equal_approx((life["fill"] as Rect2).size.x, (life["content"] as Rect2).size.x)
			and is_equal_approx((mana["fill"] as Rect2).size.x, (mana["content"] as Rect2).size.x),
		"start %s" % str(start))
	if ok:
		print("  geometry: \"%s\" %s" % [life["text"], _geometry(life)])
		print("  geometry: \"%s\" %s" % [mana["text"], _geometry(mana)])
	_done("the_hud_begins_full_at_500_of_500_and_100_of_100")


func _check_a_real_quick_strike_spends_its_configured_mana_and_the_fill_follows() -> void:
	print("")
	print("--- 7. Each real Quick Strike spends its configured Mana, and the label and the fill show what is left")
	var strikes: Array = _mana.get("strikes", [])
	var faults: PackedStringArray = PackedStringArray()
	var values: PackedStringArray = PackedStringArray()
	var expected: float = 100.0
	for reading: Dictionary in strikes:
		expected -= float(_mana.get("cost", 0.0))
		values.append(_n(float(reading["mana"])))
		if not (is_equal_approx(float(reading["spent"]), float(_mana.get("cost", -1.0))) and is_equal_approx(float(reading["mana"]), expected)
				and _mana_true(reading) and _life_true(reading)):
			faults.append(str(reading["live"]["mana"]))
	# The steady reading alone cannot tell the two HUDs apart while regeneration is held at 0: the player
	# re-emits the unchanged Mana every physics step, the handler rewrites size.x with no new minimum size,
	# no sort follows, and the pre-J6 fill reads the written width from the second frame on. The FIRST
	# layout after each spend is what separates them, so it is asserted here as well.
	var spends: Array = _emissions.filter(func(emission: Dictionary) -> bool: return emission["which"] == "mana" and emission["kind"] == "down").slice(0, 3)
	var first_layouts: PackedStringArray = PackedStringArray()
	for emission: Dictionary in spends:
		var width: float = ACCEPTED_BAR_WIDTH * float(emission["value"]) / float(emission["max"])
		var sorts: Dictionary = _first_sorts(emission)
		var live: Dictionary = sorts.get("live", {})
		var shadow: Dictionary = sorts.get("shadow", {})
		first_layouts.append("%s: live %s px, pre-J6 %s px" % [_n(float(emission["value"])), _n(float(live.get("fill", -1.0))), _n(float(shadow.get("fill", -1.0)))])
		if (live.is_empty() or shadow.is_empty() or absf(float(live["fill"]) - width) > WIDTH_TOLERANCE
				or absf(float(shadow["fill"]) - float(shadow["content"])) > WIDTH_TOLERANCE or float(shadow["content"]) < width + 1.0):
			faults.append("first layout after %s: %s" % [_n(float(emission["value"])), str(sorts)])
	var steady: PackedStringArray = PackedStringArray()
	for reading: Dictionary in strikes:
		steady.append(_n(((reading["shadow"]["mana"] as Dictionary)["fill"] as Rect2).size.x))
	_expect(faults.is_empty() and strikes.size() == 3 and spends.size() == 3 and float(_mana.get("cost", 0.0)) == 5.0 and float(_mana.get("recorded_cost", 0.0)) == 5.0
			and float(_mana.get("regeneration", 0.0)) == 10.0 and _floats(_mana.get("trail", [])) == "300, 200, 100, 0" and bool(_mana.get("dead", false))
			and slice._drop_granted,
		"%d strikes; cost %s, recorded %s; trail %s; faults %s" % [strikes.size(), str(_mana.get("cost")), str(_mana.get("recorded_cost")),
			_floats(_mana.get("trail", [])), "; ".join(faults)])
	print("  Quick Strike's configured cost is %s Mana — the player's runtime record and quick_strike.tres agree; regeneration %s per second, held at 0 for the readings"
		% [_n(float(_mana.get("cost", 0.0))), _n(float(_mana.get("regeneration", 0.0)))])
	print("  3 real Quick Strikes killed the first Graveblade, Life %s, and left Mana at %s" % [_floats(_mana.get("trail", [])).replace(", ", " -> "), ", ".join(values)])
	for reading: Dictionary in strikes:
		print("  geometry: \"%s\" %s" % [reading["live"]["mana"]["text"], _geometry(reading["live"]["mana"])])
	print("  at the first layout after each spend: %s — the pre-J6 fill stretched to the whole bar, the live fill kept its width" % "; ".join(first_layouts))
	print("  with regeneration held at 0 the pre-J6 fill read %s px three updates later as well: the unchanged Mana is re-emitted every physics step and its width rewritten with no new sort, which is why the first layout, not the steady reading, is what this check leans on"
		% ", ".join(steady))
	_done("a_real_quick_strike_spends_its_configured_mana_and_the_fill_follows")


## Every sample of a regeneration window: the Mana fill true to the Mana that sample read, never shrinking.
func _regen_faults(window: Dictionary) -> PackedStringArray:
	var faults: PackedStringArray = PackedStringArray()
	var previous: float = -1.0
	for sample: Dictionary in window.get("samples", []):
		var bar: Dictionary = sample["mana_bar"]
		var width: float = (bar["fill"] as Rect2).size.x
		if not _bar_true(bar, float(sample["mana"]), float(sample["max_mana"]), "Mana", ACCEPTED_MANA) or width < previous - WIDTH_TOLERANCE:
			faults.append("tick %d: Mana %s, %s" % [int(sample["tick"]), _n(float(sample["mana"])), _geometry(bar)])
			if faults.size() >= 3:
				break
		previous = width
	return faults


func _check_natural_mana_regeneration_moves_the_fill_truthfully_back_to_full() -> void:
	print("")
	print("--- 8. Natural regeneration, put back after the spends, moves the fill with the Mana on every update until it is full")
	var window: Dictionary = _mana.get("regen", {})
	var samples: Array = window.get("samples", [])
	var faults: PackedStringArray = _regen_faults(window)
	var last: Dictionary = samples[-1] if not samples.is_empty() else {}
	var widths: PackedStringArray = PackedStringArray()
	for index: int in [0, samples.size() / 4, samples.size() / 2, 3 * samples.size() / 4]:
		if index < samples.size():
			widths.append("%s -> %s px" % [_n(float(samples[index]["mana"])), _n(((samples[index]["mana_bar"] as Dictionary)["fill"] as Rect2).size.x)])
	_expect(faults.is_empty() and samples.size() > 20 and float(window.get("from", 0.0)) == 85.0
			and float(_mana.get("regeneration_back", 0.0)) == 10.0 and not last.is_empty() and float(last["mana"]) == 100.0
			and is_equal_approx(((last["mana_bar"] as Dictionary)["fill"] as Rect2).size.x, ACCEPTED_BAR_WIDTH),
		"%d samples from %s; faults %s" % [samples.size(), str(window.get("from")), "; ".join(faults)])
	print("  %d updates from 85 / 100 back to 100 / 100, each read before the slice processed: the fill always BAR_WIDTH x Mana / maximum within %.2f px, never shrinking — %s, then %s px at 100"
		% [samples.size(), WIDTH_TOLERANCE, ", ".join(widths), _n(ACCEPTED_BAR_WIDTH)])
	_done("natural_mana_regeneration_moves_the_fill_truthfully_back_to_full")


func _check_four_real_graveblade_hits_step_the_life_fill_to_75_50_25_and_zero() -> void:
	print("")
	print("--- 9. Four real Graveblade Hits take Life 500 -> 375 -> 250 -> 125 -> 0, and the fill follows to 75, 50, 25 per cent and zero width")
	var record: Dictionary = _deaths.get("A", {})
	var hits: Array = record.get("hits", [])
	var delay: Array = record.get("delay", [])
	var shares: Array = [0.75, 0.50, 0.25]
	var faults: PackedStringArray = PackedStringArray()
	for index: int in hits.size():
		var reading: Dictionary = hits[index]
		var bar: Dictionary = reading["live"]["life"]
		if index >= shares.size() or not _life_true(reading) or absf(float(bar["share"]) - float(shares[index])) > 0.01:
			faults.append("hit %d %s" % [index + 1, _geometry(bar)])
	var zero: Dictionary = (delay[0] as Dictionary)["life_bar"] if not delay.is_empty() else {}
	var downs: PackedStringArray = PackedStringArray()
	for emission: Dictionary in _emissions:
		if emission["which"] == "life" and emission["kind"] == "down":
			downs.append(_n(float(emission["value"])))
	_expect(faults.is_empty() and hits.size() == 3 and _floats(record.get("trail", [])) == "375, 250, 125, 0"
			and ", ".join(downs) == "375, 250, 125, 0" and not zero.is_empty() and _bar_true(zero, 0.0, 500.0, "Life", ACCEPTED_LIFE),
		"hits %d; trail %s; emissions %s; faults %s; zero %s" % [hits.size(), _floats(record.get("trail", [])), ", ".join(downs), "; ".join(faults), str(zero)])
	for reading: Dictionary in hits:
		print("  geometry: \"%s\" %s" % [reading["live"]["life"]["text"], _geometry(reading["live"]["life"])])
	if not zero.is_empty():
		print("  geometry: \"%s\" %s — the first update after the lethal Hit" % [zero["text"], _geometry(zero)])
	_done("four_real_graveblade_hits_step_the_life_fill_to_75_50_25_and_zero")


## For one emission, the first sort of that bar after it, for the live HUD and for the pre-J6 HUD.
func _first_sorts(emission: Dictionary) -> Dictionary:
	var found: Dictionary = {}
	for index: int in range(int(emission["mark"]), _sorts.size()):
		var sort: Dictionary = _sorts[index]
		for who: String in ["live", "shadow"]:
			if String(sort["who"]) == "%s_%s" % [who, emission["which"]] and not found.has(who):
				found[who] = sort
	return found


func _check_the_written_width_now_survives_the_container_sort() -> void:
	print("")
	print("--- 10. The mechanism, in this run: both HUDs write the same fractional width; at the bar's next sort the pre-J6 fill is stretched to the whole content and the live fill keeps its width")
	var faults: PackedStringArray = PackedStringArray()
	var lines: PackedStringArray = PackedStringArray()
	var read: int = 0
	for emission: Dictionary in _emissions:
		if emission["kind"] != "down":
			continue
		read += 1
		var expected: float = ACCEPTED_BAR_WIDTH * clampf(float(emission["value"]) / float(emission["max"]), 0.0, 1.0)
		var sorts: Dictionary = _first_sorts(emission)
		var live: Dictionary = sorts.get("live", {})
		var shadow: Dictionary = sorts.get("shadow", {})
		var ok: bool = (absf(float(emission["live"]) - expected) <= WIDTH_TOLERANCE and absf(float(emission["shadow"]) - expected) <= WIDTH_TOLERANCE
			and not live.is_empty() and not shadow.is_empty() and absf(float(live["fill"]) - expected) <= WIDTH_TOLERANCE
			and absf(float(shadow["fill"]) - float(shadow["content"])) <= WIDTH_TOLERANCE and float(shadow["content"]) > expected + 1.0)
		if not ok:
			faults.append("%s %s: %s" % [emission["which"], _n(float(emission["value"])), str(sorts)])
		lines.append("%s %s / %s: written %s px by both; after the sort the pre-J6 fill %s px, the live fill %s px"
			% [String(emission["which"]).capitalize(), _n(float(emission["value"])), _n(float(emission["max"])), _n(expected),
				_n(float(shadow.get("fill", -1.0))), _n(float(live.get("fill", -1.0)))])
	_expect(faults.is_empty() and read == 8, "%d emissions read; faults %s" % [read, "; ".join(faults)])
	for line: String in lines:
		print("  mechanism: %s" % line)
	print("  %d sorts recorded across the four bars in the whole run" % _sorts.size())
	_done("the_written_width_now_survives_the_container_sort")


func _check_the_lethal_hit_still_arms_fallen_and_its_delay() -> void:
	print("")
	print("--- 11. The lethal Hit still arms FALLEN and the accepted 0.90 s delay, and Fallen still opens once, on that Hit, when the countdown runs out")
	var record: Dictionary = _deaths.get("A", {})
	var lethal: Dictionary = record.get("lethal", {})
	var at_kill: Dictionary = record.get("at_kill", {})
	var counts: Dictionary = record.get("counts", {"took_damage": 0, "fell": 0})
	var opened: Dictionary = record.get("opened", {})
	var restart: Dictionary = record.get("restart", {})
	var previous: float = INF
	var updates: int = 0
	var rising: PackedStringArray = PackedStringArray()
	for reading: Dictionary in record.get("ticks", []):
		if bool(reading["overlay"]):
			continue
		if int(reading["tick"]) <= int(at_kill.get("pre", -9)):
			continue
		updates += 1
		if float(reading["countdown"]) >= previous or float(reading["countdown"]) <= 0.0:
			rising.append(str(reading["countdown"]))
		previous = float(reading["countdown"])
	var elapsed: float = float(int(record.get("open_usec", 0)) - int(at_kill.get("usec", 0))) / 1000000.0
	_expect(bool(record.get("dead", false)) and bool(record.get("from_killer", false)) and float(record.get("life_before", 0.0)) == 500.0
			and int(counts["took_damage"]) == 4 and int(record.get("began", 0)) == 4 and int(counts["fell"]) == 1
			and is_equal_approx(float(at_kill.get("countdown", 0.0)), BrokenWatchSlice.FALLEN_DELAY) and bool(at_kill.get("pending", false))
			and lethal.get("state", "") == "FALLEN" and not bool(lethal.get("alive", true)) and float(lethal.get("life", -1.0)) == 0.0
			and lethal.get("text", "") == "Life — 0 / 500" and not bool(lethal.get("overlay", true)) and not bool(lethal.get("paused", true))
			and bool(lethal.get("pending", false)) and bool(lethal.get("same_step", false)) and bool(lethal.get("process_same", false))
			and rising.is_empty() and updates > 20
			and bool(opened.get("once", false)) and bool(opened.get("with_event", false)) and opened.get("source", "") == KILLING_SOURCE
			and opened.get("state", "") == "FALLEN" and bool(opened.get("paused", false)) and float(opened.get("countdown", 0.0)) == -1.0
			and bool(opened.get("focused", false)) and _cleanups == 0 and _opened_pending.size() == 1
			and bool(restart.get("closed_once", false)) and bool(restart.get("restarted_once", false)),
		"lethal %s; at kill %s; counts %s; opened %s; restart %s; countdown faults %s; cleanups %d"
			% [str(lethal), str(at_kill), str(counts), str(opened), str(restart), str(rising), _cleanups])
	print("  on the lethal frame FALLEN, not alive, \"Life — 0 / 500\", no overlay, not paused, the countdown armed at exactly %.2f s and the pending event the killing Hit; one took_damage per Hit and one fell"
		% BrokenWatchSlice.FALLEN_DELAY)
	print("  the countdown fell on every one of the slice's %d updates until Fallen opened exactly once, on the original Hit, \"%s\", its restart button focused" % [updates, KILLING_SOURCE])
	print("  timing: the lethal Hit landed in the %s step; Fallen opened %.3f s of wall-clock time after it (read, not pinned)"
		% ["physics" if bool(at_kill.get("physics", false)) else "process", elapsed])
	_done("the_lethal_hit_still_arms_fallen_and_its_delay")


func _check_through_the_fallen_delay_the_label_reads_zero_and_no_red_fill_spans_the_bar() -> void:
	print("")
	print("--- 12. Through the whole Fallen delay the label reads \"Life — 0 / 500\" and the red fill has zero width, while the bar itself is still drawn")
	var record: Dictionary = _deaths.get("A", {})
	var samples: Array = record.get("delay", [])
	var faults: PackedStringArray = PackedStringArray()
	var read: int = 0
	var stretched: int = 0
	for sample: Dictionary in samples:
		if bool(sample["overlay"]):
			continue
		read += 1
		var bar: Dictionary = sample["life_bar"]
		if float(sample["shadow_life"]) > 250.0:
			stretched += 1
		if (not _bar_true(bar, 0.0, 500.0, "Life", ACCEPTED_LIFE) or (bar["content"] as Rect2).size.x < 250.0
				or float(sample["life"]) != 0.0 or sample["state"] != "FALLEN"):
			faults.append("tick %d %s" % [int(sample["tick"]), _geometry(bar)])
			if faults.size() >= 3:
				break
	var bar: Dictionary = (samples[0] as Dictionary)["life_bar"] if not samples.is_empty() else {}
	_expect(faults.is_empty() and read > 20 and stretched == read,
		"%d samples; %d with the pre-J6 fill stretched; faults %s" % [read, stretched, "; ".join(faults)])
	print("  %d updates of the delay, each read before the slice processed: \"Life — 0 / 500\", the fill still shown, %s px wide, inside a %s px bar — and on every one the pre-J6 HUD's fill spanned its whole bar"
		% [read, _n((bar.get("fill", Rect2()) as Rect2).size.x), _n((bar.get("outer", Rect2()) as Rect2).size.x)])
	_done("through_the_fallen_delay_the_label_reads_zero_and_no_red_fill_spans_the_bar")


func _forced_ok(forced: Dictionary) -> bool:
	var live: int = 0
	var shadow: int = 0
	for sort: Dictionary in forced.get("sorts", []):
		if sort["who"] == "live_life":
			live += 1
			if float(sort["fill"]) != 0.0:
				return false
		elif sort["who"] == "shadow_life":
			shadow += 1
			if absf(float(sort["fill"]) - float(sort["content"])) > WIDTH_TOLERANCE:
				return false
	var reading: Dictionary = forced.get("reading", {})
	return live >= 1 and shadow >= 1 and not reading.is_empty() and (reading["live"]["life"]["fill"] as Rect2).size.x == 0.0


func _check_the_zero_width_fill_survives_forced_layout_passes_and_drawn_frames() -> void:
	print("")
	print("--- 13. The zero width survives extra layout passes forced inside the delay and behind the overlay, and every frame drawn meanwhile")
	var record: Dictionary = _deaths.get("A", {})
	var layouts: Array = record.get("layouts", [])
	var behind: Dictionary = record.get("behind", {})
	var forced: Array = layouts.duplicate()
	if behind.has("forced"):
		forced.append(behind["forced"])
	var faults: PackedStringArray = PackedStringArray()
	var sorted_live: int = 0
	for entry: Dictionary in forced:
		if not _forced_ok(entry):
			faults.append("%s %s" % [entry.get("tag", "?"), str(entry.get("sorts", []))])
		for sort: Dictionary in entry.get("sorts", []):
			if sort["who"] == "live_life":
				sorted_live += 1
	var samples: Array = record.get("delay", [])
	var headless: bool = DisplayServer.get_name() == "headless"
	var drawn: int = 0
	if samples.size() >= 2:
		drawn = int(samples[-1]["drawn"]) - int(samples[0]["drawn"])
	_expect(faults.is_empty() and forced.size() == 2 and (headless or drawn >= 20),
		"%d forced passes; drawn %d (%s); faults %s" % [forced.size(), drawn, DisplayServer.get_name(), "; ".join(faults)])
	print("  2 forced layout passes, one inside the delay and one behind the overlay: %d sorts of the live Life bar, each leaving the fill 0 px; the pre-J6 HUD's sorts, forced the same way, each stretched its fill back to the whole bar"
		% sorted_live)
	if headless:
		print("  headless: the engine draws no frames, so the claim rests on the %d updates read before the slice processed" % samples.size())
	else:
		print("  %d frames were drawn across the delay, every one of them after a layout that left the fill 0 px" % drawn)
	_done("the_zero_width_fill_survives_forced_layout_passes_and_drawn_frames")


func _check_behind_the_fallen_overlay_the_life_fill_stays_empty() -> void:
	print("")
	print("--- 14. Behind the Fallen overlay, with the tree paused, the Life fill stays zero-width and the label \"Life — 0 / 500\"")
	var behind: Dictionary = (_deaths.get("A", {}) as Dictionary).get("behind", {})
	var samples: Array = behind.get("samples", [])
	var faults: PackedStringArray = (behind.get("faults", PackedStringArray(["missing"])) as PackedStringArray).duplicate()
	for sample: Dictionary in samples:
		if not (_bar_true(sample["life_bar"], 0.0, 500.0, "Life", ACCEPTED_LIFE) and bool(sample["overlay"]) and bool(sample["paused"])):
			faults.append("tick %d %s" % [int(sample["tick"]), _geometry(sample["life_bar"])])
	var reading: Dictionary = behind.get("reading", {})
	_expect(faults.is_empty() and int(behind.get("read", 0)) == 17 and samples.size() >= 5 and not reading.is_empty() and _life_true(reading),
		"behind: %d read, %d samples; faults %s" % [int(behind.get("read", 0)), samples.size(), "; ".join(faults)])
	print("  10 paused physics frames, one forced layout pass and 5 idle frames with the overlay standing, %d updates read before the slice: each \"Life — 0 / 500\" and the fill 0 px"
		% samples.size())
	_done("behind_the_fallen_overlay_the_life_fill_stays_empty")


func _check_a_normal_restart_restores_500_of_500_and_a_full_fill() -> void:
	print("")
	print("--- 15. Enter on the focused Restart revives the character to 500 / 500, and both fills are full again")
	var restart: Dictionary = (_deaths.get("A", {}) as Dictionary).get("restart", {})
	var reading: Dictionary = _readings.get("restart", {})
	var ok: bool = not reading.is_empty() and float(reading["life"]) == 500.0 and float(reading["mana"]) == 100.0 and reading["state"] == "IDLE"
	ok = ok and _life_true(reading) and _mana_true(reading)
	_expect(ok and bool(restart.get("closed_once", false)) and bool(restart.get("restarted_once", false)) and bool(restart.get("alive", false))
			and float(restart.get("countdown", 0.0)) == -1.0 and bool(restart.get("pending_null", false))
			and is_equal_approx((reading["live"]["life"]["fill"] as Rect2).size.x, (reading["live"]["life"]["content"] as Rect2).size.x),
		"restart %s; reading %s" % [str(restart), str(reading)])
	if ok:
		print("  geometry: \"%s\" %s" % [reading["live"]["life"]["text"], _geometry(reading["live"]["life"])])
		print("  geometry: \"%s\" %s" % [reading["live"]["mana"]["text"], _geometry(reading["live"]["mana"])])
	_done("a_normal_restart_restores_500_of_500_and_a_full_fill")


## Every live bar the run read, from full readings and from the pre-slice probe's samples.
func _every_live_bar() -> Array:
	var bars: Array = []
	var readings: Array = [_readings.get("start", {}), _readings.get("restart", {}), _mana.get("both", {}),
		(_mana.get("regen", {}) as Dictionary).get("end", {}), (_mana.get("both_regen", {}) as Dictionary).get("end", {})]
	readings.append_array(_mana.get("strikes", []))
	var record: Dictionary = _deaths.get("A", {})
	readings.append_array(record.get("hits", []))
	for reading: Dictionary in readings:
		if not reading.is_empty():
			bars.append(reading["live"]["life"])
			bars.append(reading["live"]["mana"])
	var windows: Array = [(_mana.get("regen", {}) as Dictionary).get("samples", []), (_mana.get("both_regen", {}) as Dictionary).get("samples", []),
		record.get("delay", []), (record.get("behind", {}) as Dictionary).get("samples", [])]
	for window: Array in windows:
		for sample: Dictionary in window:
			bars.append(sample["life_bar"])
			bars.append(sample["mana_bar"])
	return bars


func _check_both_fills_stay_clamped_between_empty_and_full() -> void:
	print("")
	print("--- 16. Both fills stay between empty and full: never narrower than 0, never wider than BAR_WIDTH, never outside their bar's content — with both bars below full as well")
	var faults: PackedStringArray = PackedStringArray()
	var bars: Array = _every_live_bar()
	var overrun: float = -INF
	for bar: Dictionary in bars:
		var fill: Rect2 = bar["fill"]
		var content: Rect2 = bar["content"]
		overrun = maxf(overrun, fill.end.x - content.end.x)
		if (fill.size.x < 0.0 or fill.size.x > ACCEPTED_BAR_WIDTH + WIDTH_TOLERANCE or not fill.position.is_equal_approx(content.position)
				or fill.end.x > content.end.x + WIDTH_TOLERANCE):
			faults.append(_geometry(bar))
			if faults.size() >= 3:
				break
	var both: Dictionary = _mana.get("both", {})
	var both_ok: bool = (not both.is_empty() and float(both["life"]) == 250.0 and float(both["mana"]) == 95.0 and _life_true(both) and _mana_true(both)
		and float(both["spent"]) == 5.0 and int(both["dealt"]) == 0)
	var both_regen: PackedStringArray = _regen_faults(_mana.get("both_regen", {}))
	var staged: PackedStringArray = PackedStringArray()
	var staged_ok: bool = (_clamp.get("results", []) as Array).size() == 4
	for result: Dictionary in _clamp.get("results", []):
		var case: Array = result["case"]
		var bar: Dictionary = result["bar"]
		var expected: float = ACCEPTED_BAR_WIDTH * clampf(float(case[1]) / float(case[2]), 0.0, 1.0)
		var width: float = (bar["fill"] as Rect2).size.x
		staged_ok = staged_ok and absf(width - expected) <= WIDTH_TOLERANCE and (bar["fill"] as Rect2).end.x <= (bar["content"] as Rect2).end.x + WIDTH_TOLERANCE
		staged.append("%s %s / %s -> %s px" % [String(case[0]).capitalize(), _n(float(case[1])), _n(float(case[2])), _n(width)])
	var restored: Dictionary = _clamp.get("restored", {})
	staged_ok = staged_ok and not restored.is_empty() and _life_true(restored) and _mana_true(restored)
	_expect(faults.is_empty() and bars.size() > 200 and both_ok and both_regen.is_empty() and staged_ok,
		"%d bars; faults %s; both %s; both regen %s; staged %s" % [bars.size(), "; ".join(faults), str(both_ok), "; ".join(both_regen), ", ".join(staged)])
	print("  %d live bar readings, every one between 0 and %s px and inside its bar's content; the largest overrun of the content's right edge was %s px"
		% [bars.size(), _n(ACCEPTED_BAR_WIDTH), _n(overrun)])
	if both_ok:
		print("  both below full: \"%s\" %s; \"%s\" %s — one real Quick Strike swung at nothing spent %s and struck nothing"
			% [both["live"]["life"]["text"], _geometry(both["live"]["life"]), both["live"]["mana"]["text"], _geometry(both["live"]["mana"]), _n(float(both["spent"]))])
	print("  %d updates of regeneration from 95 to 100 with Life at 250: each fill true to its Mana and inside its content, never shrinking"
		% ((_mana.get("both_regen", {}) as Dictionary).get("samples", []) as Array).size())
	print("  staged, the HUD's own handlers given values play cannot produce: %s; then the player's true values restored both bars" % ", ".join(staged))
	_done("both_fills_stay_clamped_between_empty_and_full")


## Everything but the fill's width, compared between the live HUD and the pre-J6 HUD.
func _same_frame(live: Dictionary, shadow: Dictionary) -> PackedStringArray:
	var differences: PackedStringArray = PackedStringArray()
	for which: String in ["life", "mana"]:
		var a: Dictionary = live[which]
		var b: Dictionary = shadow[which]
		for key: String in ["outer", "content", "label"]:
			if not (a[key] as Rect2).is_equal_approx(b[key] as Rect2):
				differences.append("%s %s %s / %s" % [which, key, str(a[key]), str(b[key])])
		for key: String in ["text", "font", "bar_minimum", "border_width", "radius", "container", "shown"]:
			if a[key] != b[key]:
				differences.append("%s %s %s / %s" % [which, key, str(a[key]), str(b[key])])
		for key: String in ["colour", "bg", "border", "font_colour"]:
			if not (a[key] as Color).is_equal_approx(b[key] as Color):
				differences.append("%s %s" % [which, key])
		if not (a["fill"] as Rect2).position.is_equal_approx((b["fill"] as Rect2).position) or not is_equal_approx((a["fill"] as Rect2).size.y, (b["fill"] as Rect2).size.y):
			differences.append("%s fill origin or height" % which)
	for key: String in ["resources"]:
		if not (live[key] as Rect2).is_equal_approx(shadow[key] as Rect2):
			differences.append("resources %s / %s" % [str(live[key]), str(shadow[key])])
	for key: String in ["prompt_min", "hover_min"]:
		if live[key] != shadow[key]:
			differences.append(key)
	return differences


func _check_labels_colours_dimensions_placement_and_borders_are_unchanged() -> void:
	print("")
	print("--- 17. Labels, colours, nominal dimensions, placement and borders are the pre-J6 HUD's exactly; only the fill's width differs")
	var readings: Array = [_readings.get("start", {}), _readings.get("restart", {}), _mana.get("both", {}),
		(_mana.get("regen", {}) as Dictionary).get("end", {}), (_mana.get("both_regen", {}) as Dictionary).get("end", {}),
		(_clamp.get("restored", {}) as Dictionary), ((_living.get("by_pad", {}) as Dictionary).get("reading", {}) as Dictionary)]
	readings.append_array(_mana.get("strikes", []))
	var record: Dictionary = _deaths.get("A", {})
	readings.append_array(record.get("hits", []))
	readings.append((record.get("behind", {}) as Dictionary).get("reading", {}))
	for entry: Dictionary in record.get("layouts", []):
		readings.append(entry.get("reading", {}))
	var faults: PackedStringArray = PackedStringArray()
	var compared: int = 0
	var flags: PackedStringArray = PackedStringArray()
	for reading: Dictionary in readings:
		if reading.is_empty():
			faults.append("a reading is missing")
			continue
		compared += 1
		var differences: PackedStringArray = _same_frame(reading["live"], reading["shadow"])
		if not differences.is_empty():
			faults.append("%s: %s" % [reading["tag"], "; ".join(differences)])
	var start: Dictionary = _readings.get("start", {})
	var nominal: bool = false
	var below: float = 0.0
	if not start.is_empty():
		var life: Dictionary = start["live"]["life"]
		var mana: Dictionary = start["live"]["mana"]
		var viewport: Vector2 = start["viewport"]
		var resources: Rect2 = start["live"]["resources"]
		below = resources.end.y - viewport.y
		flags.append("live %d / pre-J6 %d" % [int(life["flags"]), int(start["shadow"]["life"]["flags"])])
		nominal = (FirstMvpCombatHud.BAR_WIDTH == ACCEPTED_BAR_WIDTH and FirstMvpCombatHud.BAR_HEIGHT == ACCEPTED_BAR_HEIGHT
			and life["bar_minimum"] == Vector2(ACCEPTED_BAR_WIDTH, ACCEPTED_BAR_HEIGHT) and mana["bar_minimum"] == Vector2(ACCEPTED_BAR_WIDTH, ACCEPTED_BAR_HEIGHT)
			and (life["colour"] as Color).is_equal_approx(ACCEPTED_LIFE) and (mana["colour"] as Color).is_equal_approx(ACCEPTED_MANA)
			and (life["bg"] as Color).is_equal_approx(ACCEPTED_SLATE) and (life["border"] as Color).is_equal_approx(ACCEPTED_IRON)
			and int(life["border_width"]) == 1 and int(life["radius"]) == 2 and int(life["font"]) == 13
			and Vector2(resources.position.x, resources.end.y).is_equal_approx(Vector2(ACCEPTED_PLACEMENT.x, viewport.y + ACCEPTED_PLACEMENT.y))
			and Rect2(Vector2.ZERO, viewport).encloses(resources)
			and int(life["flags"]) == Control.SIZE_SHRINK_BEGIN and int(start["shadow"]["life"]["flags"]) == Control.SIZE_FILL)
	_expect(faults.is_empty() and compared >= 14 and nominal,
		"%d compared; nominal %s; faults %s" % [compared, str(nominal), "; ".join(faults)])
	print("  %d readings compared, live against pre-J6: every bar's outer and content rect, every label's rect, text, size and colour, the fill's colour, origin and height, the border's colour, width and radius, and the resources column — identical"
		% compared)
	print("  nominal: BAR_WIDTH %s, BAR_HEIGHT %s, each bar's minimum %s x %s, 1 px iron border, radius 2, Life (0.78, 0.26, 0.24), Mana (0.30, 0.52, 0.82), labels 13 px; the column's bottom-left at (24, bottom - 24), wholly inside the window (J8, D-336)"
		% [_n(FirstMvpCombatHud.BAR_WIDTH), _n(FirstMvpCombatHud.BAR_HEIGHT), _n(ACCEPTED_BAR_WIDTH), _n(ACCEPTED_BAR_HEIGHT)])
	print("  the one difference is the fill's horizontal size flag (%s): SIZE_SHRINK_BEGIN against SIZE_FILL" % ", ".join(flags))
	print("  finding, repaired by J8 (D-336): the resources column is %s px tall, its bottom edge %s px above the window's and its top edge %s px above it, so the whole column — the Mana bar included — is inside the window, in the pre-J6 HUD exactly as in the live one, which keeps J8's placement"
		% [_n(((start.get("live", {}) as Dictionary).get("resources", Rect2()) as Rect2).size.y), _n(-below),
			_n(((start.get("live", {}) as Dictionary).get("resources", Rect2()) as Rect2).size.y - below)])
	_done("labels_colours_dimensions_placement_and_borders_are_unchanged")


func _check_the_j5_highlight_clearing_and_j4_refusals_still_hold() -> void:
	print("")
	print("--- 18. J5 and J4 intact: the drop's highlight clears from the first update after death, and every item route inside the delay is refused")
	var record: Dictionary = _deaths.get("A", {})
	var before: Dictionary = record.get("living", {})
	var pad: Dictionary = _selection.get("controller", {})
	var owed: int = int((record.get("at_kill", {}) as Dictionary).get("pre", -9)) + 1
	var first: Dictionary = {}
	var faults: PackedStringArray = PackedStringArray()
	for reading: Dictionary in record.get("ticks", []):
		if int(reading["tick"]) < owed or bool(reading["overlay"]):
			continue
		if first.is_empty():
			first = reading
		if bool(reading["soft"]) or not bool((reading["ring"] as Dictionary).get("ordinary", false)) or bool(reading["nameplate"]):
			faults.append(str(reading))
			break
	var attempts: Array = record.get("attempts", [])
	var kinds: PackedStringArray = PackedStringArray()
	for attempt: Dictionary in attempts:
		kinds.append(String(attempt["kind"]))
		var ok: bool = (not bool(attempt["comparison"]) and not bool(attempt["paused"]) and bool(attempt["same"]) and bool(attempt["pending"])
			and attempt["state"] == "FALLEN" and not bool(attempt["destination"]) and not bool(attempt["nameplate"])
			and String(attempt["prompt"]).is_empty() and not bool(attempt["soft_after"]) and bool(attempt["ordinary_after"])
			and float(attempt["countdown_after"]) < float(attempt["remaining"]) and (attempt["new_logs"] as Array).size() <= 1)
		match String(attempt["kind"]):
			"interact", "direct":
				var now: Dictionary = attempt["synchronous"]
				ok = ok and not bool(now["comparison"]) and not bool(now["paused"]) and bool(now["countdown_same"]) and bool(now["message_same"])
				ok = ok and (attempt["new_logs"] as Array).is_empty()
			"click":
				ok = ok and int(attempt["press"]["down"]) == 0 and int(attempt["press"]["pressed"]) == 0
		if not ok:
			faults.append(str(attempt))
	var behind: Dictionary = record.get("behind", {})
	_expect(faults.is_empty() and bool(before.get("soft", false)) and bool(before.get("in_range", false)) and before.get("family", "") == "controller"
			and bool(pad.get("soft", false)) and int(pad.get("foreign_held", 0)) >= 1 and pad.get("family_after_foreign", "") == "controller"
			and float(pad.get("moved", 9.0)) < 0.01
			and not first.is_empty() and not bool(first.get("soft", true)) and first.get("family", "") == "controller" and bool(first.get("in_range", false))
			and String(first.get("prompt", "x")).is_empty() and kinds == PackedStringArray(["interact", "direct", "click"])
			and not bool(behind.get("soft", true)) and bool((behind.get("ring", {}) as Dictionary).get("ordinary", false)),
		"before %s; first update %s; attempts %s; faults %s" % [str(before), str(first), str(kinds), "; ".join(faults)])
	print("  before the first Hit: alive, in range, the controller live and the drop soft-selected; one foreign pointer movement was held back by the harness's filter")
	print("  from the slice's first update after the lethal Hit until Fallen opened: the drop unselected, its ring ordinary copper, the nameplate hidden and the prompt empty — with the controller live and the character in range")
	print("  one joypad (A) in range, open_item_comparison() called directly and one left click where the nameplate stood: each opened nothing, paused nothing, moved no item, left the countdown falling and did not re-select the drop")
	_done("the_j5_highlight_clearing_and_j4_refusals_still_hold")


func _check_the_living_prompts_messages_comparison_and_equip_still_work() -> void:
	print("")
	print("--- 19. After the restart the living prompts, the \"walk closer\" message, the comparison and the equip work exactly as accepted")
	var near: Dictionary = _living.get("near", {})
	var far: Dictionary = _living.get("far", {})
	var back: Dictionary = _living.get("back", {})
	var mouse: Dictionary = _living.get("mouse", {})
	var walk: Dictionary = _living.get("walk_closer", {})
	var by_pad: Dictionary = _living.get("by_pad", {})
	var again: Dictionary = by_pad.get("again", {})
	var message: Dictionary = by_pad.get("message", {})
	_expect(near.get("prompt", "") == "%s — (A) Inspect" % DROP_NAME and bool(near.get("soft", false)) and near.get("family", "") == "controller"
			and far.get("prompt", "") == "%s — walk closer" % DROP_NAME and not bool(far.get("soft", true))
			and String((walk.get("after", {}) as Dictionary).get("text", "")) == WALK_CLOSER and bool((walk.get("after", {}) as Dictionary).get("visible", false))
			and not bool(walk.get("comparison", true))
			and back.get("prompt", "") == "%s — (A) Inspect" % DROP_NAME and bool(back.get("soft", false))
			and mouse.get("prompt", "") == "%s — Left click" % DROP_NAME and not bool(mouse.get("soft", true)) and mouse.get("family", "") == "mouse"
			and bool(by_pad.get("open", false)) and int(by_pad.get("opens", 0)) == 1 and bool(by_pad.get("log", false)) and bool(by_pad.get("paused", false))
			and bool(by_pad.get("focus", false)) and bool(by_pad.get("equip_focused", false)) and int(by_pad.get("equips", 0)) == 1
			and bool(by_pad.get("closed", false)) and bool(by_pad.get("drop_gone", false)) and int(by_pad.get("owned", 0)) == 1
			and bool(by_pad.get("equipped", false)) and int(by_pad.get("lines", 0)) == 1
			and String(message.get("text", "")) == "Equipped %s" % DROP_NAME and bool(message.get("visible", false))
			and int(again.get("opens", -1)) == 0 and int(again.get("equips", -1)) == 1 and not bool(again.get("open", true)),
		"near %s; far %s; walk %s; back %s; mouse %s; by pad %s" % [str(near), str(far), str(walk), str(back), str(mouse), str(by_pad)])
	print("  1.50 m with the controller: \"%s — (A) Inspect\"; 4.00 m: \"— walk closer\", and (A) there wrote \"%s\"; back at 1.50 m, selected again; one pointer movement: \"— Left click\"" % [DROP_NAME, WALK_CLOSER])
	print("  (A) opened the comparison once ('controller interact'), paused, Close focused; joypad right and (A) equipped once, the message \"Equipped %s\"; one more (A) opened nothing" % DROP_NAME)
	_done("the_living_prompts_messages_comparison_and_equip_still_work")


func _check_the_hover_life_bar_is_measured_and_left_unchanged() -> void:
	print("")
	print("--- 20. The enemy hover Life bar — outside J6 — measured by the pointer's own route and left exactly as it was")
	var source: String = _before_j7(HUD_SCRIPT, FileAccess.get_file_as_string(HUD_SCRIPT))
	var pre_text: String = String(_put_back(source, J6_HUD_MOVES)["text"])
	var samples: Array = _hover.get("samples", [])
	var shown: Array = samples.filter(func(sample: Dictionary) -> bool: return bool(sample["visible"]))
	var widths: PackedStringArray = PackedStringArray()
	for sample: Dictionary in shown:
		widths.append(_n(float(sample["fill"])))
	var truthful: float = 190.0 * float(_hover.get("life", 0.0)) / maxf(float(_hover.get("max", 1.0)), 0.0001)
	var full: int = shown.filter(func(sample: Dictionary) -> bool: return absf(float(sample["fill"]) - float(sample["track"])) <= WIDTH_TOLERANCE).size()
	var floored: int = shown.filter(func(sample: Dictionary) -> bool: return absf(float(sample["fill"]) - 190.0) <= WIDTH_TOLERANCE).size()
	var measured: bool = (not shown.is_empty() and String(shown[0]["name"]) == "Graveblade" and float(_hover.get("life", 0.0)) == 200.0
		and not samples.is_empty() and not bool((samples[-1] as Dictionary)["visible"]))
	# In a window the slice reads the operating system's own cursor, which the harness never moves, so there
	# the hover can be staged only if that cursor happens to follow; otherwise the headless run is the measure.
	var point: Vector2 = _hover.get("point", Vector2.INF)
	var read_back: Vector2 = _hover.get("read_back", Vector2.INF)
	var followed: bool = read_back.distance_to(point) <= 1.0
	var headless: bool = DisplayServer.get_name() == "headless"
	_expect((measured if (headless or followed) else shown.is_empty())
			and _function_body(source, "show_hover") == _function_body(pre_text, "show_hover")
			and _function_body(source, "_build") == _function_body(pre_text, "_build"),
		"hover %s" % str(_hover))
	if not headless and not followed:
		print("  rendered: not measured here — the slice read the pointer at (%d, %d), not at the harness's (%d, %d): in a window get_viewport().get_mouse_position() follows the operating system's own cursor, which the harness does not move; the hover panel stayed hidden on all %d updates, and the measurement below is the headless run's"
			% [roundi(read_back.x), roundi(read_back.y), roundi(point.x), roundi(point.y), samples.size()])
		_done("the_hover_life_bar_is_measured_and_left_unchanged")
		return
	print("  the pointer over the first Graveblade at %s / %s Life: the hover panel showed \"Graveblade\" on %d of %d updates; its fill, read before the slice processed on each, was %s px of a %s px bar"
		% [_n(float(_hover.get("life", 0.0))), _n(float(_hover.get("max", 0.0))), shown.size(), samples.size(), ", ".join(widths),
			_n(float((shown[0] as Dictionary)["track"]) if not shown.is_empty() else 0.0)])
	print("  finding, not repaired: a truthful fill is %s px; on %d of those %d updates the fill spanned the whole bar — the PanelContainer's sort when the panel first appears — and on %d it stood at exactly 190 px, because the fill's own fixed 190 x 10 minimum size stops show_hover()'s smaller size.x write — J7 (D-334) has since repaired both"
		% [_n(truthful), full, shown.size(), floored])
	_done("the_hover_life_bar_is_measured_and_left_unchanged")


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
	var signals: Array[Signal] = [player.took_damage, player.fell, player.fell]
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
