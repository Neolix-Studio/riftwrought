extends SceneTree
## Riftwrought — Verification Maintenance V1: Non-Nesting Accepted-Suite Reconstruction: automated verification
## (decision D-342).
##
## THE ONE QUESTION: can every accepted J-suite still rebuild, byte for byte, every file state it promises to —
## and can each file D-342 migrated still be rebuilt to its D-341 bytes — with no accepted suite carrying another
## suite's source any longer? Before D-342, J4 to J10 carried their put-back pairs as string constants, and every
## cascade copied the previous suites' constants, escaped once more, into the next: J10's verification reached
## 2,499,210 bytes. D-342 moved every such pair list into one flat, content-addressed store under
## res://tests/provenance/, read by one engine there, and left each suite naming its pair lists by SHA-256.
##
## WHAT IS PROVED, each against a pin held here or in the suite concerned:
##   1. the engine and every store file at their pinned SHA-256, nothing else in that directory, and every
##      migrated suite pinning that same engine;
##   2. the store parses canonically and every record is what it names;
##   3. no reference cycle and no version cycle;
##   4. every pair list an accepted suite pins exists, and every stored pair list is pinned by a suite or here;
##   5. the thirteen files D-342 migrated rebuild to their D-341 bytes;
##   6. every state every accepted suite promises — J3's, which D-342 did not touch, included — rebuilds from the
##      live files, each step against the prefix and SHA-256 the suite itself pins;
##   7. no accepted suite embeds another suite's body, and no pair text still held inline nests another;
##   8–10. one-byte mutation, truncation, omission, duplication, reordering, misnaming, a wrong target, a wrong path,
##      a moved pin and a moved engine are each refused, in memory;
##   11. the production walks every accepted runner makes — the four legacy ones that still read `.DS_Store`
##      included — are exactly D-341's, and no other runner reads a `.DS_Store`;
##   12. every accepted suite keeps its assertions, owed checks, verdict, permissions and run mode;
##   13. a synthetic one-line production change, cascaded through the migrated mechanism inside the temporary
##      directory the runner hands over with --scratch, grows the store by its own delta alone.
##
## IT LOADS NO SCENE AND OPENS NO WINDOW. It writes only inside the --scratch directory, and removes what it
## writes there. It ports D-211's owed-set discipline.
##
## Run: godot --headless --path game --script res://tests/non_nesting_accepted_suite_reconstruction_verification.gd -- --scratch <dir>

const THIS_FILE: String = "res://tests/non_nesting_accepted_suite_reconstruction_verification.gd"
const THIS_SMOKE: String = "res://tests/non_nesting_accepted_suite_reconstruction_smoke.sh"
const ENGINE: String = "res://tests/provenance/accepted_suite_provenance.gd"
const ENGINE_SHA256: String = "fadbdfeba32546d03bffe876c2b8be7a96dfe966ff9f5d4f720199d664b23dc4"
const STORE_DIRECTORY: String = "res://tests/provenance"
const SLICE: String = "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
const HUD: String = "res://scripts/ui/first_mvp_combat_hud.gd"
const LAYOUT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_layout.gd"

## Every store file: [name, SHA-256, bytes]. Written once by D-342 and never rewritten.
const STORE_FILES: Array = [
	["d342_accepted_suite_history.provenance", "3b38ca4d6576dcafd8267650fefb9acfe4ea5ecc5aae712b1c7105e120ff3c3c", 412215],
	## First-MVP Gameplay J11 (decision D-344) added its own file beside it, under D-343 ruling 4. The older
	## file is not rewritten: this one carries J11's delta alone, with no reference segment of any kind.
	["d344_gate_1d_route_continuity.provenance", "0ab807ed2ffb6e925039f0eeb40d3a5ba8003a62f6971d3125f21984b00e7007", 83610],
]
const EXPECTED_TEXTS: int = 737
const EXPECTED_PAIR_LISTS: int = 104
const EXPECTED_EDGES: int = 165
const EXPECTED_RENDERED: int = 381
const EXPECTED_REFERENCED: int = 13
const EXPECTED_STATES: int = 132

## The twenty accepted J-suite files, oldest first: [path, SHA-256 now, SHA-256 at D-341, mode]. The thirteen
## D-342 migrated differ; the seven it left alone do not.
const SUITES: Array = [
	["res://tests/first_mvp_modal_left_click_verification.gd", "d12ad27160a6577b89a7d482364a86e4c662572749e05c47a3f45ac8c429d698", "75f2648650da8e9d3a97e205eb97a843b1ed2a4d6b8b04824f46d56d30cd5130", "644"],
	["res://tests/first_mvp_modal_left_click_smoke.sh", "977c05bdcc7a79961a411b5dfa487294c28028866973ca1f2f795d43ef017f54", "977c05bdcc7a79961a411b5dfa487294c28028866973ca1f2f795d43ef017f54", "755"],
	["res://tests/fallen_modal_life_state_verification.gd", "72e39a8af345f213ebcddc9866e69ce1a0384ef6efb042e125e7afbce75b6356", "935a37e9a13cc47d383bbaf4dab0af90d790dfbb7f87509e0b8b9307f724520c", "644"],
	["res://tests/fallen_modal_life_state_smoke.sh", "9e0977fb279108312082961b25a7b9466917782be095d4eb6d3b02b682967663", "9e0977fb279108312082961b25a7b9466917782be095d4eb6d3b02b682967663", "755"],
	["res://tests/pending_fallen_restart_verification.gd", "7d0e3f086f52e86debf0b451a16d3142e89a70e62dd9aaf13ae167c9704e15f6", "53c379761fa52afb1b8c28306c04daca87791eccc6416c9d3b536c21a1653fe1", "644"],
	["res://tests/pending_fallen_restart_smoke.sh", "54a4464a7cbe400a205f3d8a5d5b3a1d81ef6b0ef8dcc726558a9de67b0e517e", "9a860bca0646e71afa06bbca104d9e16319993babd57100ba3b5b0bcf0cb12d1", "755"],
	["res://tests/fallen_delay_item_interaction_verification.gd", "8aad426265c3040f065b2dc828cb0452cf2be43c496de1827b7faa771dd1f730", "5c8e9b07d27177b696d17eb803f1bd2a04582b8c55de4f18eab848be9055e48c", "644"],
	["res://tests/fallen_delay_item_interaction_smoke.sh", "939d9b4815d46b5ba73161f65e630fe75c086d585025e53ebd995628c1d25942", "0fd60eb7d1cb15544cf1a17102ab5cec1516e55ef1e0b1556fa2c8fe04485cfc", "755"],
	["res://tests/fallen_delay_drop_highlight_verification.gd", "beb94aa05c3dd99d9874ec8d5f4c5b5cd781054c5334ae60dd3b4b8d557d80cf", "dceea6f96d81a8ce3fb0bd5d857cf93addc5d0601f001dc211e7e9873e2d59af", "644"],
	["res://tests/fallen_delay_drop_highlight_smoke.sh", "6f792a386aaefacf714684f041c567eefa7b74720f95da77336c902db7a2880a", "b1b456bd4b97f6992d9a873e19250f158835e30934e17581cf19eb81db3b8121", "755"],
	["res://tests/combat_hud_fractional_fill_verification.gd", "8c653002bdc47f0a35497da88756a29622ff398c5d4b510648f2dd7f5bd5a814", "f7144aaceb577549ebc4ac28f9cd0bef972b09d4dd3751015701b8631b3f53d9", "644"],
	["res://tests/combat_hud_fractional_fill_smoke.sh", "51d64a23890eb758f71a4e5d66f07590dec1a6f32e37b2a782a030cb0f430d76", "6cf22e7dab55e1f90aded60b9edc4f374231d0e517df937fa88876f3bd83be95", "755"],
	["res://tests/enemy_hover_life_fractional_fill_verification.gd", "bf92c1ecfa8dd995a6e6c42c531487511deffb53473edb116cf5b066ef14afb1", "0b816f062982c7b9009820aac3b7a2533a41c0c9723d473c9eb2f96a87cd0e9a", "644"],
	["res://tests/enemy_hover_life_fractional_fill_smoke.sh", "64a84a9d9d0c6ea3d32b0343e0af77329093be57ee0b79dddb2015e1a43d766a", "0dbde2d8d5d82c7a4bcc759495f8beebda4b3e4b48323a4cffc073cd0cae0f70", "755"],
	["res://tests/combat_hud_safe_bottom_placement_verification.gd", "2ca7555313e5ee462a2fbc2738a478cf58161580adaba1b67015efa4c6fafd0b", "b709813c49907eb160dcdcc6c20eca8750106e59d64f2f5158c2cd35d5e80cbd", "644"],
	["res://tests/combat_hud_safe_bottom_placement_smoke.sh", "f562e165d90170679e5bf35e0c0ce65b92d51d759d14359ed2dd1a507500abde", "900c8d9e13a5bf172293ea8c3657c67136a8c4172d8f7f483bdbbee1ba8ff6b4", "755"],
	["res://tests/guaranteed_drop_defeated_enemy_binding_verification.gd", "aaa9e1d332a2e297b77c6256801eceb982d5fb7511423e1ea0c9c0639728ea37", "ae964685880aad6bc00894c04e1e90f997a6167c75a603a3cf6ef87c450f05aa", "644"],
	["res://tests/guaranteed_drop_defeated_enemy_binding_smoke.sh", "94b5e6c914aabcd1959694d8cd0b2a8e80ef22088f46c44e8b85687a393bd19b", "1f2a43b1ae097d63bc6ffd0ad4fb6e183329ce2d4c6017f4c77300e1304aa426", "755"],
	["res://tests/restart_position_stability_verification.gd", "1588cff8b91e3c3a4bc1f23180968e9981aebda279691256dcd947e4985136d0", "51108a47c4c0b120e3909e5a804266bd0234cd2fe0788a87ab9406c43c6ed5bc", "644"],
	["res://tests/restart_position_stability_smoke.sh", "34db74ce3fa60f0be7e33e460a30219188b267294c49feb3ad25864d5238c3f2", "20b7a56294345a3c49dd98dfa47283e0c278d623d51ba21cd6ed0b3f8711dcd6", "755"],
]
## The thirteen files D-342 migrated: [path, D-342 SHA-256, D-341 SHA-256, the pair list that puts D-342 back,
## its pair count].
const MIGRATED: Array = [
	["res://tests/fallen_delay_item_interaction_verification.gd", "15352d8a50b10ad98768d76c3c1dd68acad57753cb5900fc72d77b2c83517291", "5c8e9b07d27177b696d17eb803f1bd2a04582b8c55de4f18eab848be9055e48c", "e48a940f496b486a4e3d29945413a32e72c92d04cc1b53079b43b091c391d8ac", 8],
	["res://tests/fallen_delay_drop_highlight_verification.gd", "6204a260e42a042a5407e5b13d8bb105a8899df286b4fddff043ac35710722b8", "dceea6f96d81a8ce3fb0bd5d857cf93addc5d0601f001dc211e7e9873e2d59af", "b3d27bc2dfc663e6044e81edefed212ca94fac1bcc6efd90695f63ef7729b948", 9],
	["res://tests/fallen_delay_drop_highlight_smoke.sh", "08aa2d0b359a9a350a4b2b07dda138200f57faea5a5ef60c60a5849f66e1ded8", "b1b456bd4b97f6992d9a873e19250f158835e30934e17581cf19eb81db3b8121", "6c2fd3b783af50c704bf5eadd9ef796f0d6f633b26e674cf5f653c37ce6a3487", 1],
	["res://tests/combat_hud_fractional_fill_verification.gd", "d23c5fdc1b708c7c87e48b430ead753cdc5c08875983bf7cfab4db898b1797bf", "f7144aaceb577549ebc4ac28f9cd0bef972b09d4dd3751015701b8631b3f53d9", "9f53188f095270661035ffaa398236fd02494e252d347aad0fa108759fe2a35c", 8],
	["res://tests/combat_hud_fractional_fill_smoke.sh", "be9f6f47ceb3e79d9b784fe1e8766639cec351add0c52c99e2f4a3a9686b0144", "6cf22e7dab55e1f90aded60b9edc4f374231d0e517df937fa88876f3bd83be95", "d014f5ed85cb9a293875956a2606972b00398e1f4be9eeb51fb123a470b82662", 1],
	["res://tests/enemy_hover_life_fractional_fill_verification.gd", "09e25736956a9f750331a44f6f973344a7fe59cdcb7bf1e9265e6fc635a197e6", "0b816f062982c7b9009820aac3b7a2533a41c0c9723d473c9eb2f96a87cd0e9a", "8f8804a3e2969b275a632186b8a886da3a0c8e115c37d0de1ceddd209b9be71a", 7],
	["res://tests/enemy_hover_life_fractional_fill_smoke.sh", "85a49a224612711fd9e7964449538afc19f3eda586f9d106f70a3c81e18b6333", "0dbde2d8d5d82c7a4bcc759495f8beebda4b3e4b48323a4cffc073cd0cae0f70", "d9d34c41ca3a049ffd0b7fe664806ce399309123362f05e01c8097cdc43ccd9c", 1],
	["res://tests/combat_hud_safe_bottom_placement_verification.gd", "bfab962cb08b9466b33cdfc9de3802e4cbc224a3f1eb3a865c7cc2c63d0d5e3f", "b709813c49907eb160dcdcc6c20eca8750106e59d64f2f5158c2cd35d5e80cbd", "9c2613e527b72cc0163b820733b6ea7db5d14099d07cfe55007687b369cabc4d", 6],
	["res://tests/combat_hud_safe_bottom_placement_smoke.sh", "95506b40c3274ced5143436e468205cd3fb6326bf2a029f2581f6e867fa34fe7", "900c8d9e13a5bf172293ea8c3657c67136a8c4172d8f7f483bdbbee1ba8ff6b4", "39db2eeef1b4187331222c05fc9c39070379dccf6ab25695fab42cb6062ee0be", 1],
	["res://tests/guaranteed_drop_defeated_enemy_binding_verification.gd", "e526397bf360dab81887bb63936be6827fe8a2823258d3eec83bad7c89d70248", "ae964685880aad6bc00894c04e1e90f997a6167c75a603a3cf6ef87c450f05aa", "bb4d428220fa79ffcc366f3a6db706fd5eace2e51df1edffb8002d6f8ed6493e", 5],
	["res://tests/guaranteed_drop_defeated_enemy_binding_smoke.sh", "2254440306d58e20079532cd3577e9df48bc2e3bb0d4831a332f91ef64deae20", "1f2a43b1ae097d63bc6ffd0ad4fb6e183329ce2d4c6017f4c77300e1304aa426", "c7acc3087d5572686d64967fc227df848a9359d4c899d64a4ab4adca27860fb4", 1],
	["res://tests/restart_position_stability_verification.gd", "bf25715a79af9f3ec30d6988b9d477a38a79cc6e0f61de10fd9d0c7e167c5a7e", "51108a47c4c0b120e3909e5a804266bd0234cd2fe0788a87ab9406c43c6ed5bc", "f5ff02cb31de1be16bec3d54d5a3b082a913863553540cf72d3fc1f06cd26ff9", 4],
	["res://tests/restart_position_stability_smoke.sh", "02f03162742af697c56cb76aefd0f9262bac26c92e6a479a5d618c8b55967681", "20b7a56294345a3c49dd98dfa47283e0c278d623d51ba21cd6ed0b3f8711dcd6", "f1b6795905afca056af4f02170e40c3e25300896927dca3255c8bb136dad5dfa", 1],
]

## First-MVP Gameplay J11 (decision D-344) moved Gate 1D's slice and eighteen of the twenty accepted suite
## files again, and recorded its own delta in `d344_gate_1d_route_continuity.provenance`. Every read of an accepted
## suite's D-342 or D-341 bytes puts J11's pairs back first, by the pair-list name this table holds.
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
	"res://tests/restart_position_stability_verification.gd": "05bc9f20bd2e1d051921151955555d334bd6361c712413293bdb582e70d60d6c",
	"res://tests/restart_position_stability_smoke.sh": "8e17e436ffeefd7232f1e9ecd29fdf596cc7fd3d192aeea3d5bf2a3f2a24c082",
}
const J3_VERIFICATION: String = "res://tests/pending_fallen_restart_verification.gd"
const J1_VERIFICATION: String = "res://tests/first_mvp_modal_left_click_verification.gd"
const J2_VERIFICATION: String = "res://tests/fallen_modal_life_state_verification.gd"
const J10_VERIFICATION: String = "res://tests/restart_position_stability_verification.gd"
## Each migrated suite's own production put-back, which D-342 left inline in that suite: [suite, file, pair-list
## constant, the suite's own prefix constant, its target SHA-256 constant]. J10's two are built from constants.
const OWN_PRODUCTION: Array = [
	["res://tests/fallen_delay_item_interaction_verification.gd", SLICE, "J4_SLICE_MOVES", "J4_PREFIX", "J3_SLICE_SHA256"],
	["res://tests/fallen_delay_drop_highlight_verification.gd", SLICE, "J5_SLICE_MOVES", "J5_PREFIX", "J4_SLICE_SHA256"],
	["res://tests/combat_hud_fractional_fill_verification.gd", HUD, "J6_HUD_MOVES", "J6_HUD_PREFIX", "PRE_J6_HUD_SHA256"],
	["res://tests/enemy_hover_life_fractional_fill_verification.gd", HUD, "J7_HUD_MOVES", "J7_HUD_PREFIX", "PRE_J7_HUD_SHA256"],
	["res://tests/combat_hud_safe_bottom_placement_verification.gd", HUD, "J8_HUD_MOVES", "J8_HUD_PREFIX", "PRE_J8_HUD_SHA256"],
	["res://tests/guaranteed_drop_defeated_enemy_binding_verification.gd", SLICE, "J9_SLICE_MOVES", "J9_SLICE_PREFIX", "PRE_J9_SLICE_SHA256"],
]
## Every constant still holding pair text inline, by suite: J3's own layers, which D-342 left alone, and each
## later suite's own production pairs. Nothing else in any accepted suite holds pair text.
const INLINE_PAIRS: Dictionary = {
	"res://tests/pending_fallen_restart_verification.gd": ["J4_MOVES", "J5_MOVES", "J6_MOVES", "J7_MOVES", "J8_MOVES", "J9_MOVES", "J10_MOVES", "J11_MOVES"],
	"res://tests/fallen_delay_item_interaction_verification.gd": ["J4_SLICE_MOVES"],
	"res://tests/fallen_delay_drop_highlight_verification.gd": ["J5_SLICE_MOVES"],
	"res://tests/combat_hud_fractional_fill_verification.gd": ["J6_HUD_MOVES"],
	"res://tests/enemy_hover_life_fractional_fill_verification.gd": ["J7_HUD_MOVES"],
	"res://tests/combat_hud_safe_bottom_placement_verification.gd": ["J8_HUD_MOVES"],
	"res://tests/guaranteed_drop_defeated_enemy_binding_verification.gd": ["J9_SLICE_MOVES"],
}
## The four accepted runners whose production walk still reads `.DS_Store`, under D-338's narrow exception.
const LEGACY_WALKS: Array[String] = [
	"res://tests/fallen_delay_drop_highlight_smoke.sh", "res://tests/combat_hud_fractional_fill_smoke.sh",
	"res://tests/enemy_hover_life_fractional_fill_smoke.sh", "res://tests/combat_hud_safe_bottom_placement_smoke.sh",
]
const WALK_MARK: String = "find scripts scenes data addons assets project.godot"
const REFERENCE_MINIMUM: int = 128
const SYNTHETIC_ANCHOR: String = "\tplayer.clear_movement_intent(reason, false)\n"
const SYNTHETIC_LINE: String = "\t# Synthetic dry run (D-344): one line, written only to temporary storage.\n"
const SYNTHETIC_DECISION: String = "D-345"

const OWED_CHECKS: Array[String] = [
	"the_engine_and_the_store_are_at_their_pinned_hashes_and_nothing_else_is_stored",
	"the_store_parses_canonically_and_every_record_is_what_it_names",
	"the_reference_and_version_graphs_are_acyclic",
	"every_record_is_accounted_for_and_every_pinned_name_resolves",
	"the_thirteen_migrated_files_rebuild_to_their_d341_bytes",
	"every_promised_historical_version_rebuilds_byte_for_byte",
	"no_accepted_suite_embeds_another_suites_body_or_nests_pairs",
	"one_byte_mutation_and_truncation_are_refused",
	"missing_duplicated_reordered_and_misnamed_records_are_refused",
	"a_wrong_target_path_pin_or_engine_is_refused",
	"the_production_walks_and_the_legacy_exception_are_unchanged",
	"every_accepted_suite_keeps_its_assertions_verdict_permissions_and_run_mode",
	"a_synthetic_one_line_change_grows_the_store_by_its_delta_alone",
]

var arguments: PackedStringArray = PackedStringArray()
var engine: Variant = null
var loaded: Dictionary = {}
var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _token: String = ""
var _scratch: String = ""
var _constants_cache: Dictionary = {}
var _texts_cache: Dictionary = {}
var _list_target: Dictionary = {}


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	_token = _argument_value("--run-token")
	_scratch = _argument_value("--scratch")
	print("")
	print("=== Verification Maintenance V1 — Non-Nesting Accepted-Suite Reconstruction verification (D-342) ===")
	print("  run token: %s" % (_token if not _token.is_empty() else "none given"))
	if FileAccess.get_sha256(ENGINE) == ENGINE_SHA256:
		engine = load(ENGINE)
		loaded = engine.parse(engine.read_directory(STORE_DIRECTORY))

	_check_the_engine_and_the_store_are_at_their_pinned_hashes_and_nothing_else_is_stored()
	if engine != null:
		_check_the_store_parses_canonically_and_every_record_is_what_it_names()
		_check_the_reference_and_version_graphs_are_acyclic()
		_check_every_record_is_accounted_for_and_every_pinned_name_resolves()
		_check_the_thirteen_migrated_files_rebuild_to_their_d341_bytes()
		_check_every_promised_historical_version_rebuilds_byte_for_byte()
		_check_no_accepted_suite_embeds_another_suites_body_or_nests_pairs()
		_check_one_byte_mutation_and_truncation_are_refused()
		_check_missing_duplicated_reordered_and_misnamed_records_are_refused()
		_check_a_wrong_target_path_pin_or_engine_is_refused()
		_check_the_production_walks_and_the_legacy_exception_are_unchanged()
		_check_every_accepted_suite_keeps_its_assertions_verdict_permissions_and_run_mode()
		_check_a_synthetic_one_line_change_grows_the_store_by_its_delta_alone()
	else:
		_expect(false, "the engine is not at its pinned SHA-256, so no store was read and nothing after check 1 ran")

	_check_every_check_ran()
	print("")
	if _failures.is_empty():
		print("NON-NESTING ACCEPTED-SUITE RECONSTRUCTION VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("NON-NESTING ACCEPTED-SUITE RECONSTRUCTION VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		quit(1)


# --- 1–4. The engine, the store and its accounting ------------------------------------------------

func _check_the_engine_and_the_store_are_at_their_pinned_hashes_and_nothing_else_is_stored() -> void:
	print("")
	print("--- 1. The one engine and every store file are at their pinned SHA-256, the store directory holds nothing else, and every migrated suite pins that engine")
	var engine_text: String = FileAccess.get_file_as_string(ENGINE)
	_expect(FileAccess.get_sha256(ENGINE) == ENGINE_SHA256 and engine_text.sha256_text() == ENGINE_SHA256
			and (engine_text + "x").sha256_text() != ENGINE_SHA256,
		"the engine hashes %s, not its pinned %s (or its pin accepts a moved engine)" % [FileAccess.get_sha256(ENGINE).left(8), ENGINE_SHA256.left(8)])
	var faults: PackedStringArray = PackedStringArray()
	var expected_names: PackedStringArray = PackedStringArray([ENGINE.get_file()])
	for row: Array in STORE_FILES:
		var path: String = STORE_DIRECTORY.path_join(String(row[0]))
		var bytes: PackedByteArray = FileAccess.get_file_as_bytes(path)
		var moved: PackedByteArray = bytes.duplicate()
		moved.append(120)
		expected_names.append(String(row[0]))
		if FileAccess.get_sha256(path) != String(row[1]) or bytes.size() != int(row[2]) or _sha(moved) == String(row[1]):
			faults.append("%s hashes %s at %d bytes" % [row[0], FileAccess.get_sha256(path).left(8), bytes.size()])
	var listed: PackedStringArray = PackedStringArray()
	for name: String in DirAccess.get_files_at(STORE_DIRECTORY):
		if name != ".DS_Store":
			listed.append(name)
	listed.sort()
	expected_names.sort()
	_expect(faults.is_empty() and listed == expected_names and DirAccess.get_directories_at(STORE_DIRECTORY).is_empty(),
		"store files: %s; the directory holds %s, not %s" % ["; ".join(faults), ", ".join(listed), ", ".join(expected_names)])
	var pinning: PackedStringArray = PackedStringArray()
	var wrong: PackedStringArray = PackedStringArray()
	for row: Array in SUITES:
		var path: String = row[0]
		if not path.ends_with("_verification.gd"):
			continue
		var constants: Dictionary = _constants(path)
		if constants.has("PROVENANCE_ENGINE_SHA256") or constants.has("PROVENANCE_ENGINE"):
			if String(constants.get("PROVENANCE_ENGINE_SHA256", "")) == ENGINE_SHA256 and String(constants.get("PROVENANCE_ENGINE", "")) == ENGINE:
				pinning.append(path.get_file())
			else:
				wrong.append(path.get_file())
	var migrated_verifications: int = 0
	for row: Array in MIGRATED:
		if String(row[0]).ends_with("_verification.gd"):
			migrated_verifications += 1
	_expect(wrong.is_empty() and pinning.size() == migrated_verifications,
		"%d suites pin the engine (%s), %d pin another (%s)" % [pinning.size(), ", ".join(pinning), wrong.size(), ", ".join(wrong)])
	print("  the engine is at %s, %d bytes; %d store file(s): %s" % [ENGINE_SHA256.left(8), engine_text.to_utf8_buffer().size(), STORE_FILES.size(), _store_summary()])
	print("  res://tests/provenance/ holds exactly the engine and %d store file(s) (.DS_Store pruned), and no directory" % STORE_FILES.size())
	print("  the %d migrated verifications pin that engine by SHA-256 and resolve nothing without it; J1's, J2's and J3's pin none" % pinning.size())
	_done("the_engine_and_the_store_are_at_their_pinned_hashes_and_nothing_else_is_stored")


func _check_the_store_parses_canonically_and_every_record_is_what_it_names() -> void:
	print("")
	print("--- 2. The store parses canonically, and every text and pair list hashes to the name it is stored under")
	_expect(bool(loaded["valid"]) and (loaded["refusals"] as PackedStringArray).is_empty(),
		"the store is refused: %s" % "; ".join(loaded["refusals"]))
	var texts: Dictionary = loaded["texts"]
	var listings: Dictionary = loaded["listings"]
	var misnamed: int = 0
	for id: String in texts:
		if String(texts[id]).sha256_text() != id:
			misnamed += 1
	for id: String in listings:
		var listing: String = ""
		for pair: Array in listings[id]:
			listing += "%s %s\n" % [pair[0], pair[1]]
		if listing.sha256_text() != id:
			misnamed += 1
	var rendered: int = 0
	var referenced: int = 0
	var literal_bytes: int = 0
	for id: String in loaded["segments"]:
		for part: Array in loaded["segments"][id]:
			match String(part[0]):
				"%":
					rendered += 1
				"&":
					referenced += 1
				_:
					literal_bytes += String(part[1]).to_utf8_buffer().size()
	var files: Dictionary = engine.read_directory(STORE_DIRECTORY)
	var canonical: int = 0
	for name: String in files:
		if (engine.serialize(loaded, loaded["files"][name]) as String).to_utf8_buffer() == files[name]:
			canonical += 1
	_expect(misnamed == 0 and texts.size() == EXPECTED_TEXTS and listings.size() == EXPECTED_PAIR_LISTS
			and (loaded["edges"] as Array).size() == EXPECTED_EDGES and rendered == EXPECTED_RENDERED and referenced == EXPECTED_REFERENCED,
		"%d misnamed; %d texts, %d pair lists, %d edges, %d rendered pair lists and %d references, not %d, %d, %d, %d and %d"
			% [misnamed, texts.size(), listings.size(), (loaded["edges"] as Array).size(), rendered, referenced,
				EXPECTED_TEXTS, EXPECTED_PAIR_LISTS, EXPECTED_EDGES, EXPECTED_RENDERED, EXPECTED_REFERENCED])
	_expect(canonical == files.size() and files.size() == STORE_FILES.size(),
		"%d of %d store files re-serialise to their own bytes" % [canonical, files.size()])
	print("  %d texts, %d pair lists and %d edges, every one hashing to its name; %d literal bytes, %d whole pair lists written as one `%%` line each and %d texts as one `&` line each"
		% [texts.size(), listings.size(), (loaded["edges"] as Array).size(), literal_bytes, rendered, referenced])
	print("  parsed and re-serialised, each of the %d store file(s) is its own bytes: the format is canonical" % canonical)
	_done("the_store_parses_canonically_and_every_record_is_what_it_names")


func _check_the_reference_and_version_graphs_are_acyclic() -> void:
	print("")
	print("--- 3. No text references itself through any chain, and no file's versions form a cycle")
	var depths: Dictionary = {}
	var cycles: int = 0
	var deepest: int = 0
	for id: String in loaded["segments"]:
		var depth: int = _depth(id, depths, {})
		if depth < 0:
			cycles += 1
		deepest = maxi(deepest, depth)
	var states: Dictionary = {}
	var leaving: Dictionary = {}
	for edge: Dictionary in loaded["edges"]:
		states["%s %s" % [edge["path"], edge["from"]]] = true
		states["%s %s" % [edge["path"], edge["to"]]] = true
		var key: String = "%s %s" % [edge["path"], edge["from"]]
		if not leaving.has(key):
			leaving[key] = []
		(leaving[key] as Array).append(edge)
	var version_cycles: int = 0
	var out_of_order: int = 0
	var longest: int = 0
	for key: String in states:
		var length: int = _chain_length(key, leaving, {})
		if length < 0:
			version_cycles += 1
		longest = maxi(longest, length)
	for edge: Dictionary in loaded["edges"]:
		for next: Dictionary in leaving.get("%s %s" % [edge["path"], edge["to"]], []):
			if _decision_number(String(next["decision"])) >= _decision_number(String(edge["decision"])):
				out_of_order += 1
	_expect(cycles == 0 and version_cycles == 0 and out_of_order == 0 and states.size() == EXPECTED_STATES,
		"%d reference cycles, %d version cycles, %d edges followed by a newer one; %d states, not %d" % [cycles, version_cycles, out_of_order, states.size(), EXPECTED_STATES])
	print("  the reference graph is acyclic: the deepest text reaches %d levels of references, each a line of its own, never an escaped copy" % deepest)
	print("  the version graph is acyclic: %d file states over %d files, the longest chain %d steps, every step putting back an older decision than the one before it"
		% [states.size(), _paths_in_edges().size(), longest])
	_done("the_reference_and_version_graphs_are_acyclic")


func _check_every_record_is_accounted_for_and_every_pinned_name_resolves() -> void:
	print("")
	print("--- 4. Every pair list an accepted suite pins is stored under an edge for the file it names, and every stored pair list is pinned")
	var pinned: Dictionary = {}
	var faults: PackedStringArray = PackedStringArray()
	var pins: int = 0
	for row: Array in SUITES:
		var path: String = row[0]
		if not path.ends_with("_verification.gd"):
			continue
		for use: Array in _pinned_names(path):
			pins += 1
			var name: String = use[1]
			pinned[name] = true
	# First-MVP Gameplay J11 (decision D-344): the last suite in a chain is read by no accepted suite, so its
	# pair list is pinned here instead — this maintenance suite is a trust root in its own right.
	for path: Variant in J11_MOVE_IDS:
		pinned[String(J11_MOVE_IDS[path])] = true
	var by_suites: int = pinned.size()
	for row: Array in SUITES:
		var path: String = row[0]
		if not path.ends_with("_verification.gd"):
			continue
		for use: Array in _pinned_names(path):
			var name: String = use[1]
			if not (loaded["pairs"] as Dictionary).has(name):
				faults.append("%s pins a missing pair list %s" % [path.get_file(), name.left(8)])
			elif not _has_edge(String(use[0]), name):
				faults.append("%s pins %s for %s, which no edge applies to that file" % [path.get_file(), name.left(8), String(use[0]).get_file()])
	for row: Array in MIGRATED:
		pinned[String(row[3])] = true
	var unpinned: PackedStringArray = PackedStringArray()
	for name: String in loaded["pairs"]:
		if not pinned.has(name):
			unpinned.append(name.left(8))
	_expect(faults.is_empty() and unpinned.is_empty() and pins > 0,
		"%s; stored but pinned by no one: %s" % ["; ".join(faults), ", ".join(unpinned)])
	var edge_lists: Dictionary = {}
	for edge: Dictionary in loaded["edges"]:
		edge_lists[String(edge["pairs"])] = true
	_expect(edge_lists.size() == (loaded["pairs"] as Dictionary).size(),
		"%d stored pair lists are used by an edge, of %d" % [edge_lists.size(), (loaded["pairs"] as Dictionary).size()])
	print("  the migrated verifications pin %d pair lists by SHA-256 (%d distinct), each stored and applied by an edge to the very file it names; the other %d are D-342's put-backs for J10's verification and runner, which no accepted suite reads and this suite pins"
		% [pins, by_suites, (loaded["pairs"] as Dictionary).size() - by_suites])
	print("  every one of the %d stored pair lists is pinned, and every stored text belongs to a pair list or a reference: nothing in the store is unaccounted for"
		% (loaded["pairs"] as Dictionary).size())
	_done("every_record_is_accounted_for_and_every_pinned_name_resolves")


# --- 5–6. Reconstruction ------------------------------------------------------------------------------

func _check_the_thirteen_migrated_files_rebuild_to_their_d341_bytes() -> void:
	print("")
	print("--- 5. The thirteen files D-342 migrated are at their D-342 hashes, and each, with D-342's pairs put back, is its D-341 file byte for byte")
	var faults: PackedStringArray = PackedStringArray()
	var back: PackedStringArray = PackedStringArray()
	var blocks: int = 0
	var before_bytes: int = 0
	var after_bytes: int = 0
	for row: Array in MIGRATED:
		var path: String = row[0]
		# First-MVP Gameplay J11 (D-344) moved every one of these again, so D-342's own state is reached
		# through J11's pairs first; the live file is pinned through `SUITES` beside it.
		var text: String = _d343_text(path)
		var pairs: Array = engine.pairs_of(loaded, String(row[3]))
		var rebuilt: Dictionary = engine.apply(text, pairs)
		blocks += pairs.size()
		back.append(String(row[2]).left(8))
		before_bytes += String(rebuilt["text"]).to_utf8_buffer().size()
		after_bytes += text.to_utf8_buffer().size()
		if not (text.sha256_text() == String(row[1]) and FileAccess.get_sha256(path) == _now(path) and (text + "x").sha256_text() != String(row[1])
				and _has_edge_between(path, String(row[1]), String(row[2]), String(row[3])) and pairs.size() == int(row[4])
				and bool(rebuilt["unique"]) and String(rebuilt["text"]).sha256_text() == String(row[2])
				and (String(rebuilt["text"]) + "x").sha256_text() != String(row[2])):
			faults.append("%s at %s rebuilds to %s" % [path.get_file(), text.sha256_text().left(8), String(rebuilt["text"]).sha256_text().left(8)])
	_expect(faults.is_empty() and MIGRATED.size() == 13, "; ".join(faults))
	print("  put back, the %d are byte for byte %s (%d replaced blocks, each unique when its turn comes)" % [MIGRATED.size(), ", ".join(back), blocks])
	print("  together they were %d bytes at D-341 and are %d now" % [before_bytes, after_bytes])
	_done("the_thirteen_migrated_files_rebuild_to_their_d341_bytes")


func _check_every_promised_historical_version_rebuilds_byte_for_byte() -> void:
	print("")
	print("--- 6. Every state an accepted suite promises rebuilds from the live files, each step against the pin that suite holds")
	# Every edge, from the live file.
	var proved: int = 0
	var edge_faults: PackedStringArray = PackedStringArray()
	for edge: Dictionary in loaded["edges"]:
		if _edge_holds(edge):
			proved += 1
		else:
			edge_faults.append("%s %s %s" % [edge["decision"], String(edge["path"]).get_file(), String(edge["pairs"]).left(8)])
	_expect(edge_faults.is_empty() and proved == EXPECTED_EDGES, "edges that do not hold from the live files: %s" % "; ".join(edge_faults))
	# Every migrated suite's own reads, through its own layers and its own prefixes.
	var replays: int = 0
	var faults: PackedStringArray = PackedStringArray()
	for row: Array in SUITES:
		var path: String = row[0]
		if not path.ends_with("_verification.gd") or not _constants(path).has("MOVED_SUITE_ROWS"):
			continue
		var constants: Dictionary = _constants(path)
		for suite_row: Array in constants["MOVED_SUITE_ROWS"]:
			var result: Dictionary = _replay(constants, String(suite_row[0]), engine.pairs_of(loaded, String(suite_row[3])), String(suite_row[1]), String(suite_row[2]))
			replays += 1
			if not bool(result["ok"]):
				faults.append("%s reading %s: %s" % [path.get_file(), String(suite_row[0]).get_file(), result["fault"]])
		for production: Array in OWN_PRODUCTION:
			if String(production[0]) != path:
				continue
			var result: Dictionary = _replay(constants, String(production[1]), constants[String(production[2])], String(constants[String(production[3])]), String(constants[String(production[4])]))
			replays += 1
			if not bool(result["ok"]):
				faults.append("%s reading %s: %s" % [path.get_file(), String(production[1]).get_file(), result["fault"]])
	var j10: Dictionary = _constants(J10_VERIFICATION)
	for own: Array in [[SLICE, [[String(j10["ENTRY_LINE"]) + String(j10["J10_CLEARING"]), String(j10["ENTRY_LINE"])]], "J10_SLICE_PREFIX", "PRE_J10_SLICE_SHA256"],
			[LAYOUT, [[String(j10["SOCKET_HEADER"]) + String(j10["J10_ENTRY_CONSTANT"]), String(j10["SOCKET_HEADER"]) + String(j10["PRE_J10_ENTRY_CONSTANT"])]], "J10_LAYOUT_PREFIX", "PRE_J10_LAYOUT_SHA256"]]:
		var result: Dictionary = _replay(j10, String(own[0]), own[1], String(j10[String(own[2])]), String(j10[String(own[3])]))
		replays += 1
		if not bool(result["ok"]):
			faults.append("J10 reading %s: %s" % [String(own[0]).get_file(), result["fault"]])
	_expect(faults.is_empty(), "; ".join(faults))
	# J3's own promises, through the pairs D-342 left inline in J3.
	var j3: Dictionary = _j3_replay()
	_expect(bool(j3["ok"]), "J3: %s" % j3["fault"])
	print("  all %d edges hold from the live files: every one of the %d stored states rebuilds, byte for byte, from the file as it stands" % [proved, EXPECTED_STATES])
	print("  %d reads of the migrated suites replayed through their own layers — D-342's first — and their own pinned prefixes, each ending at the SHA-256 that suite pins" % replays)
	print("  J3's three reads replayed through the pairs it still carries inline: the slice, J1 and J2 are, byte for byte, %s, %s and %s"
		% [String(_constants(J3_VERIFICATION)["PRE_J3_SHA256"]).left(8), String(_constants(J3_VERIFICATION)["J1_PRE_SHA256"]).left(8), String(_constants(J3_VERIFICATION)["J2_PRE_SHA256"]).left(8)])
	for line: String in _history_lines():
		print("  history: %s" % line)
	_done("every_promised_historical_version_rebuilds_byte_for_byte")


# --- 7. No embedding ------------------------------------------------------------------------------------

func _check_no_accepted_suite_embeds_another_suites_body_or_nests_pairs() -> void:
	print("")
	print("--- 7. No accepted suite holds another suite's body, raw or escaped, and no pair text still held inline nests another")
	var bodies: int = 0
	var embedded: PackedStringArray = PackedStringArray()
	for a: Array in SUITES:
		var escaped: String = engine.escape(_text(String(a[0])))
		for b: Array in SUITES:
			if a == b:
				continue
			bodies += 1
			var held: String = _text(String(b[0]))
			if held.contains(_text(String(a[0]))) or held.contains(escaped):
				embedded.append("%s in %s" % [String(a[0]).get_file(), String(b[0]).get_file()])
	_expect(embedded.is_empty() and bodies == SUITES.size() * (SUITES.size() - 1), "bodies held: %s" % ", ".join(embedded))
	# Which constants still hold pair text inline, suite by suite, and what they target.
	var faults: PackedStringArray = PackedStringArray()
	var inline_bytes: int = 0
	var inline_strings: Array = []
	for row: Array in SUITES:
		var path: String = row[0]
		if not path.ends_with("_verification.gd"):
			continue
		var constants: Dictionary = _constants(path)
		var holding: PackedStringArray = PackedStringArray()
		for name: String in constants:
			if name == "MOVED_SUITES" or name.ends_with("_MOVES"):
				holding.append(name)
				for text: String in _strings_in(constants[name]):
					inline_bytes += text.to_utf8_buffer().size()
					inline_strings.append(text)
			if name == "MOVED_SUITE_ROWS" or name.ends_with("_MOVE_IDS"):
				for value: Variant in _names_in(constants[name]):
					if not _is_name(String(value)):
						faults.append("%s's %s holds %s, not a SHA-256 name" % [path.get_file(), name, String(value).left(12)])
		holding.sort()
		var owed: PackedStringArray = PackedStringArray(INLINE_PAIRS.get(path, []))
		owed.sort()
		if holding != owed:
			faults.append("%s holds pair constants %s, not %s" % [path.get_file(), ", ".join(holding), ", ".join(owed)])
	_expect(faults.is_empty(), "; ".join(faults))
	# None of what is still inline nests: no stored text escaped inside it, and no stored pair list written inside it.
	var nested: int = 0
	var needles: PackedStringArray = _stored_needles()
	for text: String in inline_strings:
		for needle: String in needles:
			if needle.length() <= text.length() and text.contains(needle):
				nested += 1
	var j3_targets: bool = not _constants(J1_VERIFICATION).has("MOVED_SUITE_ROWS") and not _constants(J2_VERIFICATION).has("MOVED_SUITE_ROWS")
	for key: String in _constants(J1_VERIFICATION):
		j3_targets = j3_targets and not (key.ends_with("_MOVES") or key == "MOVED_SUITES")
	for key: String in _constants(J2_VERIFICATION):
		j3_targets = j3_targets and not (key.ends_with("_MOVES") or key == "MOVED_SUITES")
	_expect(nested == 0 and j3_targets, "%d inline pair texts nest a stored text or pair list; J3's targets carry pair constants: %s" % [nested, str(not j3_targets)])
	var longest_now: int = 0
	var longest_then: int = 0
	for row: Array in SUITES:
		longest_now = maxi(longest_now, _longest_line(_text(String(row[0]))))
		longest_then = maxi(longest_then, _longest_line(_d341_text(String(row[0]))))
	print("  none of the %d accepted suite files holds another's body, raw or escaped, in any of the %d pairings" % [SUITES.size(), bodies])
	print("  pair text is still held inline only by J3's own seven layers — edits to the slice, J1 and J2, which hold no pair text themselves — and by six suites' own production pairs: %d strings, %d bytes, none of them nesting a stored text or pair list"
		% [inline_strings.size(), inline_bytes])
	print("  the longest line in any accepted suite file is %d characters; at D-341 it was %d" % [longest_now, longest_then])
	_done("no_accepted_suite_embeds_another_suites_body_or_nests_pairs")


# --- 8–10. Tamper refusal, in memory ----------------------------------------------------------------------

func _check_one_byte_mutation_and_truncation_are_refused() -> void:
	print("")
	print("--- 8. A store with one byte changed, cut short, or one byte longer is refused")
	var name: String = STORE_FILES[0][0]
	var bytes: PackedByteArray = engine.read_directory(STORE_DIRECTORY)[name]
	# One ASCII letter inside the first literal segment becomes another, keeping the file valid UTF-8.
	var at: int = _first_literal_letter(bytes)
	var mutated: PackedByteArray = bytes.duplicate()
	mutated[at] = 120 if mutated[at] != 120 else 121
	var one: String = _refusal({name: mutated})
	var half: String = _refusal({name: bytes.slice(0, bytes.size() >> 1)})
	var longer: PackedByteArray = bytes.duplicate()
	longer.append(120)
	var appended: String = _refusal({name: longer})
	var no_newline: String = _refusal({name: bytes.slice(0, bytes.size() - 1)})
	_expect(one.contains("misnamed") and not half.is_empty() and appended.contains("ends inside a line") and no_newline.contains("ends inside a line")
			and _sha(mutated) != String(STORE_FILES[0][1]) and _sha(longer) != String(STORE_FILES[0][1]),
		"one byte: '%s'; cut in half: '%s'; one byte longer: '%s'; final newline removed: '%s'" % [one.left(120), half.left(120), appended.left(120), no_newline.left(120)])
	print("  one byte changed at offset %d: refused — %s" % [at, _first(one)])
	print("  cut to half its %d bytes: refused — %s" % [bytes.size(), _first(half)])
	print("  one byte appended: refused — %s; its final newline removed: refused — %s" % [_first(appended), _first(no_newline)])
	_done("one_byte_mutation_and_truncation_are_refused")


func _check_missing_duplicated_reordered_and_misnamed_records_are_refused() -> void:
	print("")
	print("--- 9. A store missing a record, holding one twice, holding two out of order, listing a pair list's pairs out of order, or naming a record wrongly is refused")
	var name: String = STORE_FILES[0][0]
	var record: Dictionary = (loaded["files"][name] as Dictionary).duplicate(true)
	var texts: Array = record["texts"]
	var side: String = String((loaded["listings"] as Dictionary).values()[0][0][0])
	var index: int = texts.find(side)
	var without: Dictionary = record.duplicate(true)
	(without["texts"] as Array).remove_at(index)
	var missing: String = _refusal({name: _bytes(loaded, without)})
	var twice: Dictionary = record.duplicate(true)
	(twice["texts"] as Array).insert(index, side)
	var duplicated: String = _refusal({name: _bytes(loaded, twice)})
	var swapped: Dictionary = record.duplicate(true)
	var first: String = (swapped["texts"] as Array)[0]
	(swapped["texts"] as Array)[0] = (swapped["texts"] as Array)[1]
	(swapped["texts"] as Array)[1] = first
	var reordered: String = _refusal({name: _bytes(loaded, swapped)})
	var list_name: String = ""
	for id: String in loaded["listings"]:
		if (loaded["listings"][id] as Array).size() >= 2:
			list_name = id
			break
	var shuffled: Dictionary = loaded.duplicate()
	var listings: Dictionary = (loaded["listings"] as Dictionary).duplicate()
	var reversed: Array = (listings[list_name] as Array).duplicate()
	reversed.reverse()
	listings[list_name] = reversed
	shuffled["listings"] = listings
	var pairs_reordered: String = _refusal({name: _bytes(shuffled, record)})
	var text: String = _bytes(loaded, record).get_string_from_utf8()
	var renamed: String = _refusal({name: text.replace("@text %s\n" % side, "@text %s\n" % _flip(side)).to_utf8_buffer()})
	var without_list: Dictionary = record.duplicate(true)
	var pinned_name: String = String(MIGRATED[0][3])
	(without_list["pairs"] as Array).erase(pinned_name)
	var gone: Dictionary = engine.parse({name: _bytes(loaded, without_list)})
	var extra: Dictionary = loaded.duplicate()
	var segments: Dictionary = (loaded["segments"] as Dictionary).duplicate()
	var orphan: String = "an unaccounted text".sha256_text()
	segments[orphan] = [["=", "an unaccounted text"]]
	extra["segments"] = segments
	var grown: Dictionary = record.duplicate(true)
	(grown["texts"] as Array).append(orphan)
	(grown["texts"] as Array).sort()
	var unaccounted: String = _refusal({name: _bytes(extra, grown)})
	_expect(missing.contains("missing text") and duplicated.contains("duplicated") and reordered.contains("out of order")
			and pairs_reordered.contains("pair list %s is misnamed: its lines hash" % list_name.left(8))
			and renamed.contains("text %s is misnamed: its content hashes" % _flip(side).left(8)) and unaccounted.contains("referenced by nothing")
			and not bool(gone["valid"]) and "; ".join(gone["refusals"]).contains("missing pair list") and engine.pairs_of(gone, pinned_name).is_empty(),
		"missing: '%s'; duplicated: '%s'; reordered: '%s'; pairs reordered: '%s'; renamed: '%s'; unaccounted: '%s'; pair list gone: '%s'"
			% [missing.left(90), duplicated.left(90), reordered.left(90), pairs_reordered.left(90), renamed.left(90), unaccounted.left(90), "; ".join(gone["refusals"]).left(90)])
	print("  a text a pair list names, left out: refused — %s" % _reason(missing, "missing text"))
	print("  the same text held twice: refused — %s" % _reason(duplicated, "duplicated"))
	print("  the first two texts swapped: refused — %s" % _reason(reordered, "out of order"))
	print("  a pair list's %d pairs in reverse order: refused — %s" % [(loaded["listings"][list_name] as Array).size(), _reason(pairs_reordered, "its lines hash")])
	print("  a text stored under a name one character off its own, in the last place: refused — %s" % _reason(renamed, "text %s is misnamed" % _flip(side).left(8)))
	print("  a text nothing names, added: refused — %s" % _reason(unaccounted, "referenced by nothing"))
	print("  the pair list that puts D-342 back for %s, left out: refused — %s — and its name resolves to nothing" % [String(MIGRATED[0][0]).get_file(), _reason("; ".join(gone["refusals"]), "missing pair list")])
	_done("missing_duplicated_reordered_and_misnamed_records_are_refused")


func _check_a_wrong_target_path_pin_or_engine_is_refused() -> void:
	print("")
	print("--- 10. An edge claiming the wrong target or the wrong file, a pair list applied to the wrong state, a moved pin and a moved engine are each refused")
	var edge: Dictionary = {}
	for candidate: Dictionary in loaded["edges"]:
		if String(candidate["decision"]) == "D-342" and String(candidate["path"]) == String(MIGRATED[0][0]):
			edge = candidate
	var wrong_target: Dictionary = edge.duplicate()
	wrong_target["to"] = _flip(String(edge["to"]))
	var wrong_path: Dictionary = edge.duplicate()
	wrong_path["path"] = String(MIGRATED[1][0])
	# A D-340 pair list applied straight to a D-342 file, without D-342 put back first.
	var skipped: String = ""
	var skipped_ok: bool = false
	for candidate: Dictionary in loaded["edges"]:
		if String(candidate["decision"]) == "D-340" and String(candidate["kind"]) == "rows" and _is_migrated(String(candidate["path"])):
			var applied: Dictionary = engine.apply(_text(String(candidate["path"])), engine.pairs_of(loaded, String(candidate["pairs"])))
			skipped = String(candidate["path"]).get_file()
			skipped_ok = String(applied["text"]).sha256_text() == String(candidate["to"])
			break
	# A suite's pinned name with one character moved resolves to nothing, so its read cannot end where it must.
	var constants: Dictionary = _constants(J10_VERIFICATION)
	var row: Array = constants["MOVED_SUITE_ROWS"][0]
	var moved_pin: Dictionary = _replay(constants, String(row[0]), engine.pairs_of(loaded, _flip(String(row[3]))), String(row[1]), String(row[2]))
	var guarded: int = 0
	for suite: Array in MIGRATED:
		if String(suite[0]).ends_with("_verification.gd") and _text(String(suite[0])).contains("\tif FileAccess.get_sha256(PROVENANCE_ENGINE) == PROVENANCE_ENGINE_SHA256:\n\t\treturn load(PROVENANCE_ENGINE).resolve(ids)\n"):
			guarded += 1
	var engine_moved: bool = (FileAccess.get_file_as_string(ENGINE) + "x").sha256_text() != ENGINE_SHA256
	_expect(_edge_holds(edge) and not _edge_holds(wrong_target) and not _edge_holds(wrong_path) and not skipped.is_empty() and not skipped_ok
			and not bool(moved_pin["ok"]) and guarded == 7 and engine_moved,
		"the true edge holds: %s; a wrong target holds: %s; a wrong file holds: %s; a skipped put-back reaches its target: %s; a moved pin rebuilds: %s; %d suites guard the engine"
			% [str(_edge_holds(edge)), str(_edge_holds(wrong_target)), str(_edge_holds(wrong_path)), str(skipped_ok), str(moved_pin["ok"]), guarded])
	print("  D-342's edge for %s holds; the same edge claiming another target, or claimed for %s, does not" % [String(MIGRATED[0][0]).get_file(), String(MIGRATED[1][0]).get_file()])
	print("  J10's own D-340 pairs for %s applied to the file as it stands, without D-342 put back first, do not reach the D-339 file" % skipped)
	print("  J10's pin for %s with one character moved resolves to nothing, and its read fails: %s" % [String(row[0]).get_file(), moved_pin["fault"]])
	print("  all 7 migrated verifications resolve only while the engine hashes to their pin; the engine with one byte appended does not")
	_done("a_wrong_target_path_pin_or_engine_is_refused")


# --- 11–12. The accepted runners and suites, as D-341 left them ---------------------------------------------

func _check_the_production_walks_and_the_legacy_exception_are_unchanged() -> void:
	print("")
	print("--- 11. Every accepted runner's production walk and pinned digest are D-341's, and only the four legacy runners walk a .DS_Store")
	var unpruned: PackedStringArray = PackedStringArray()
	var walks: int = 0
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in SUITES:
		var path: String = row[0]
		if not path.ends_with("_smoke.sh"):
			continue
		var now: PackedStringArray = _walk_lines(_text(path))
		var then: PackedStringArray = _walk_lines(_d341_text(path))
		# First-MVP Gameplay J11 (decision D-344): the `find` lines themselves must still be D-341’s, byte
		# for byte — nobody may quietly change what is walked. A pinned EXPECTED_PRODUCTION value may move,
		# and only inside a pair the decision that moved it records.
		if _find_lines(now) != _find_lines(then) or not _moves_are_recorded(path, now, then):
			moved.append(path.get_file())
		for line: String in now:
			if line.contains(WALK_MARK):
				walks += 1
				if not line.contains("! -name .DS_Store"):
					unpruned.append(path)
	var this_walks: PackedStringArray = PackedStringArray()
	for line: String in _text(THIS_SMOKE).split("\n"):
		if line.contains("find ") and line.contains("-type f") and not line.strip_edges().begins_with("#"):
			this_walks.append(line)
	var this_pruned: bool = not this_walks.is_empty()
	for line: String in this_walks:
		this_pruned = this_pruned and line.contains("! -name .DS_Store")
	var legacy: PackedStringArray = PackedStringArray(LEGACY_WALKS)
	legacy.sort()
	var found: PackedStringArray = PackedStringArray()
	for path: String in unpruned:
		if not found.has(path):
			found.append(path)
	found.sort()
	_expect(moved.is_empty() and found == legacy and this_pruned,
		"walk or digest lines moved in %s; unpruned walks in %s; this runner prunes every walk: %s" % [", ".join(moved), ", ".join(found), str(this_pruned)])
	print("  %d production-walk lines across the accepted runners are exactly D-341's; every EXPECTED_PRODUCTION line is D-341's or moved inside a pair D-344 records" % walks)
	print("  the four legacy runners (%s) still read their seven .DS_Store files under D-338's narrow exception, and no other runner does; every walk this maintenance runner makes prunes them"
		% ", ".join(PackedStringArray(LEGACY_WALKS.map(func(p: String) -> String: return p.get_file()))))
	_done("the_production_walks_and_the_legacy_exception_are_unchanged")


func _check_every_accepted_suite_keeps_its_assertions_verdict_permissions_and_run_mode() -> void:
	print("")
	print("--- 12. Every accepted suite keeps its assertions, owed checks, verdict, permissions and run mode; D-342 touched only pins and reconstruction")
	var faults: PackedStringArray = PackedStringArray()
	var expects: int = 0
	var verifications: int = 0
	var runners: int = 0
	var verdicts: PackedStringArray = PackedStringArray()
	var row_regex: RegEx = RegEx.create_from_string("^\\t\"\\$[A-Z0-9_]+\\|[0-9a-f]{8}\"$")
	var moved_lines: int = 0
	for row: Array in SUITES:
		var path: String = row[0]
		var now: String = _text(path)
		var then: String = _d341_text(path)
		if "%o" % FileAccess.get_unix_permissions(path) != String(row[3]):
			faults.append("%s is %o, not %s" % [path.get_file(), FileAccess.get_unix_permissions(path), row[3]])
		if path.ends_with("_verification.gd"):
			verifications += 1
			var lines_now: PackedStringArray = _functional_lines(now)
			var calls: int = 0
			for line: String in lines_now:
				if line.strip_edges().begins_with("_expect("):
					calls += 1
			expects += calls
			var lines_then: PackedStringArray = _functional_lines(then)
			var calls_then: int = 0
			for line: String in lines_then:
				if line.strip_edges().begins_with("_expect("):
					calls_then += 1
			# First-MVP Gameplay J11 (decision D-344, owner ruling): a cascade that moves a file a suite pins by
			# its LIVE SHA-256 cannot leave that conjunct alone, so a functional line may move — but only inside
			# a pair the moving decision records, and never the assertion count or the owed set.
			if calls != calls_then or _owed_block(now) != _owed_block(then) or _owed_block(now).is_empty():
				faults.append("%s's assertion count or owed set moved" % path.get_file())
			elif not _moves_are_recorded(path, lines_now, lines_then):
				faults.append("%s's assertions or prints moved outside the pairs its cascade records" % path.get_file())
			else:
				moved_lines += _line_difference(lines_now, lines_then).size()
		else:
			runners += 1
			var kept_now: PackedStringArray = PackedStringArray()
			for line: String in now.split("\n"):
				if not (row_regex.search(line) != null or line.begins_with("# Verification Maintenance V1 (D-342) moved ")
						or line.begins_with("# First-MVP Gameplay J11 (D-344) moved ")):
					kept_now.append(line)
			var kept_then: PackedStringArray = PackedStringArray()
			for line: String in then.split("\n"):
				if row_regex.search(line) == null:
					kept_then.append(line)
			if kept_now != kept_then and not _moves_are_recorded(path, kept_now, kept_then):
				faults.append("%s moved beyond its hash rows, its comment lines and the pairs its cascade records" % path.get_file())
			elif kept_now != kept_then:
				moved_lines += _line_difference(kept_now, kept_then).size()
			for line: String in now.split("\n"):
				if line.contains("printf '") and (line.contains("ACCEPTED") or line.contains("VERDICT:") or line.contains("remains OPEN")):
					verdicts.append(line.strip_edges())
	var this_smoke: String = _text(THIS_SMOKE)
	var headless: bool = (not this_smoke.contains("--resolution") and not this_smoke.contains("--shots")
		and not this_smoke.contains("screenshot(") and "%o" % FileAccess.get_unix_permissions(THIS_SMOKE) == "755")
	_expect(faults.is_empty() and headless, "%s; this runner is headless-only and executable: %s" % ["; ".join(faults), str(headless)])
	print("  the %d verifications keep every owed-check list and their %d _expect calls, as at D-341; %d functional or measured line(s) moved in all, every one inside a pair D-344 records"
		% [verifications, expects, moved_lines])
	print("  the %d runners moved nothing but their hash rows and one comment line each; each keeps its verdict lines (%d in all), its mode and its run mode — J1's and J5's still render, the rest are headless"
		% [runners, verdicts.size()])
	print("  every verification is 644 and every runner 755; this maintenance runner is 755, has no rendered mode and takes no screenshot")
	_done("every_accepted_suite_keeps_its_assertions_verdict_permissions_and_run_mode")


# --- 13. The synthetic cascade --------------------------------------------------------------------------

func _check_a_synthetic_one_line_change_grows_the_store_by_its_delta_alone() -> void:
	print("")
	print("--- 13. A synthetic one-line production change, cascaded through the migrated mechanism in temporary storage, adds its own delta and escapes no earlier body")
	if _scratch.is_empty() or not DirAccess.dir_exists_absolute(_scratch):
		_expect(false, "no --scratch directory was handed over, so the dry run has nowhere to write")
		return
	var order: Array[String] = [SLICE]
	for row: Array in SUITES:
		order.append(String(row[0]))
	order.append(THIS_FILE)
	order.append(THIS_SMOKE)
	var tracked: Dictionary = {SLICE: true, J1_VERIFICATION: true, J2_VERIFICATION: true}
	for row: Array in SUITES:
		for use: Array in _pinned_names(String(row[0])):
			tracked[String(use[0])] = true
	for row: Array in MIGRATED:
		tracked[String(row[0])] = true
	var moved: Dictionary = {}
	var synthetic: Dictionary = {}
	var lists: Array = []
	var edges: Array = []
	var grew: Dictionary = {}
	for path: String in order:
		var live: String = _text(path)
		var edit: Dictionary = {"text": live, "pairs": []}
		if path == SLICE:
			_edit(edit, SYNTHETIC_ANCHOR, SYNTHETIC_ANCHOR + SYNTHETIC_LINE)
		else:
			_move_pins(edit, path, moved)
			_add_layer(edit, path, moved, lists)
		var text: String = edit["text"]
		if text == live:
			continue
		synthetic[path] = text
		moved[path] = [live.sha256_text(), text.sha256_text()]
		grew[path] = text.to_utf8_buffer().size() - live.to_utf8_buffer().size()
		if tracked.has(path):
			var pairs: Array = (edit["pairs"] as Array).duplicate()
			pairs.reverse()
			lists.append(pairs)
			_list_target[lists.size() - 1] = path
			edges.append([SYNTHETIC_DECISION, "layer", path, text.sha256_text(), live.sha256_text(), lists.size() - 1])
	var composed: Dictionary = engine.compose(loaded, PackedStringArray(["# Synthetic dry run (D-344): the NEXT decision's store file, written only to temporary storage."]), lists, edges)
	var store_text: String = composed["text"]
	var files: Dictionary = engine.read_directory(STORE_DIRECTORY)
	files["d345_synthetic_dry_run.provenance"] = store_text.to_utf8_buffer()
	var together: Dictionary = engine.parse(files)
	# Every new edge puts its file back to the state it holds now.
	var holding: int = 0
	for edge: Array in edges:
		var pairs: Array = engine.pairs_of(together, String(composed["names"][int(edge[5])]))
		if String(engine.apply(String(synthetic[String(edge[2])]), pairs)["text"]).sha256_text() == String(edge[4]):
			holding += 1
	# Nothing new escapes an earlier text, pair list or body: every text the cascade added — each side of every
	# edit it made to every file — is in the new store file, one literal segment each.
	var parsed_new: Dictionary = engine.parse({"d345_synthetic_dry_run.provenance": store_text.to_utf8_buffer()})
	var references: int = 0
	for id: String in parsed_new["segments"]:
		for part: Array in parsed_new["segments"][id]:
			if String(part[0]) != "=":
				references += 1
	var escaped: int = 0
	for needle: String in _stored_needles():
		if needle.length() <= store_text.length() and store_text.contains(needle):
			escaped += 1
	for row: Array in SUITES:
		var body: String = _text(String(row[0]))
		if store_text.contains(body) or store_text.contains(engine.escape(body)):
			escaped += 1
	# Written, then removed.
	var directory: String = _scratch.path_join("synthetic")
	DirAccess.make_dir_recursive_absolute(directory)
	var written_files: int = 0
	for path: String in synthetic:
		var file: FileAccess = FileAccess.open(directory.path_join(path.get_file()), FileAccess.WRITE)
		file.store_string(synthetic[path])
		file.close()
		written_files += 1
	var store_file: FileAccess = FileAccess.open(directory.path_join("d345_synthetic_dry_run.provenance"), FileAccess.WRITE)
	store_file.store_string(store_text)
	store_file.close()
	written_files += 1
	var listed: int = DirAccess.get_files_at(directory).size()
	for name: String in DirAccess.get_files_at(directory):
		DirAccess.remove_absolute(directory.path_join(name))
	DirAccess.remove_absolute(directory)
	var removed: bool = not DirAccess.dir_exists_absolute(directory)
	var suite_growth: int = 0
	var most: int = 0
	var most_file: String = ""
	for path: String in grew:
		if path == SLICE:
			continue
		suite_growth += int(grew[path])
		if int(grew[path]) > most:
			most = int(grew[path])
			most_file = path.get_file()
	_expect(bool(together["valid"]) and holding == edges.size() and references == 0 and escaped == 0 and written_files == listed and removed
			and FileAccess.get_sha256(STORE_DIRECTORY.path_join(String(STORE_FILES[0][0]))) == String(STORE_FILES[0][1]) and not edges.is_empty(),
		"the store with the synthetic file is valid: %s (%s); %d of %d new edges hold; %d reference lines; %d escaped copies; %d written, %d listed, removed: %s"
			% [str(together["valid"]), "; ".join(together["refusals"]).left(160), holding, edges.size(), references, escaped, written_files, listed, str(removed)])
	var moved_names: PackedStringArray = PackedStringArray()
	for path: String in synthetic:
		moved_names.append(path.get_file())
	print("  one line added to the slice moves %d files: %s" % [synthetic.size(), ", ".join(moved_names)])
	print("  the new store file: %d bytes, %d texts, %d pair lists, %d edges — every text one literal segment, %d references, and no existing record rewritten"
		% [store_text.to_utf8_buffer().size(), (parsed_new["segments"] as Dictionary).size(), (parsed_new["listings"] as Dictionary).size(), edges.size(), references])
	print("  the moved suite files grow by %d bytes in all, %d at most (%s); no earlier text, pair list or suite body is escaped into any of it" % [suite_growth, most, most_file])
	print("  every one of the %d new edges puts its file back to the state it holds now, and the store with the new file beside it is valid" % holding)
	print("  modelled, not written: each later suite's check lines would also nest one `.get(path, ...)` per new layer; constant per reading line")
	print("  %d synthetic files were written to the temporary directory and all removed again" % written_files)
	_done("a_synthetic_one_line_change_grows_the_store_by_its_delta_alone")


## A pin move: every runner hash row, and every [path, prefix] or [path, SHA-256] table row, naming a file that has
## already moved takes that file's new hash, exactly as an accepted cascade re-pins rows.
func _move_pins(edit: Dictionary, path: String, moved: Dictionary) -> void:
	var text: String = edit["text"]
	var keys: Dictionary = {}
	if path.ends_with(".sh"):
		var regex: RegEx = RegEx.create_from_string("(?m)^([A-Z0-9_]+)=\"((?:tests|scripts)/[^\"]+)\"$")
		for found: RegExMatch in regex.search_all(text):
			keys["res://" + found.get_string(2)] = "$" + found.get_string(1)
	for target: String in moved:
		var old: String = moved[target][0]
		var new: String = moved[target][1]
		if path.ends_with(".sh"):
			if keys.has(target):
				var line: String = "\t\"%s|%s\"\n" % [keys[target], old.left(8)]
				if text.contains(line):
					_edit(edit, line, "\t\"%s|%s\"\n" % [keys[target], new.left(8)])
					text = edit["text"]
		else:
			for form: String in ["\t[\"%s\", \"%s\"],\n" % [target, old.left(8)]]:
				if text.contains(form):
					_edit(edit, form, form.replace(old.left(8), new.left(8)))
					text = edit["text"]
			var full: String = "\t[\"%s\", \"%s\"" % [target, old]
			if text.contains(full):
				_edit(edit, full, "\t[\"%s\", \"%s\"" % [target, new])
				text = edit["text"]


## A later cascade's layer, as the migrated mechanism makes one: in each migrated suite reading a moved file, a
## prefix and a pair-list name per file plus a put-back function and one wrapped read; in J3, which D-342 left
## alone, its own inline layer.
func _add_layer(edit: Dictionary, path: String, moved: Dictionary, lists: Array) -> void:
	var constants: Dictionary = _constants(path) if path.ends_with("_verification.gd") and path != THIS_FILE else {}
	var entries: Array = []
	if constants.has("MOVED_SUITE_ROWS"):
		for use: Array in _pinned_names(path):
			var target: String = use[0]
			if moved.has(target) and _synthetic_list(target, lists) >= 0:
				var entry: Array = [target, String(moved[target][1]).left(8), _list_name(lists[_synthetic_list(target, lists)])]
				if not entries.has(entry):
					entries.append(entry)
		if entries.is_empty():
			return
		var block: String = "\n## A later cascade's layer, modelled by the D-344 dry run.\nconst J12_PREFIXES: Dictionary = {\n"
		for entry: Array in entries:
			block += "\t\"%s\": \"%s\",\n" % [entry[0], entry[1]]
		block += "}\nconst J12_MOVE_IDS: Dictionary = {\n"
		for entry: Array in entries:
			block += "\t\"%s\": \"%s\",\n" % [entry[0], entry[2]]
		block += "}\nvar J12_MOVES: Dictionary = _stored(J12_MOVE_IDS)\n"
		var anchor: String = "var MOVED_SUITES: Array = _stored(MOVED_SUITE_ROWS)\n"
		for candidate: String in ["var J11_MOVES: Dictionary = _stored(J11_MOVE_IDS)\n", "var VM1_MOVES: Dictionary = _stored(VM1_MOVE_IDS)\n", "var J10_MOVES: Dictionary = _stored(J10_MOVE_IDS)\n"]:
			if String(edit["text"]).contains(candidate):
				anchor = candidate
				break
		_edit(edit, anchor, anchor + block)
		var function_anchor: String = "\t\trows.append(empty)\n\treturn rows\n"
		_edit(edit, function_anchor, function_anchor + "\n\n## Puts a file the modelled later cascade moved back to where D-344 left it.\nfunc _before_j12(path: String, text: String) -> String:\n\tfor pair: Array in J12_MOVES.get(path, []):\n\t\ttext = text.replace(String(pair[0]), String(pair[1]))\n\treturn text\n")
		for read: String in ["_before_j11(path, FileAccess.get_file_as_string(path))", "_before_vm1(path, FileAccess.get_file_as_string(path))", "_before_j10(path, FileAccess.get_file_as_string(path))"]:
			if String(edit["text"]).contains(read):
				_edit(edit, read, read.replace("FileAccess.get_file_as_string(path)", "_before_j12(path, FileAccess.get_file_as_string(path))"))
				break
	elif path == J3_VERIFICATION:
		var pairs: Array = []
		for target: String in [SLICE, J1_VERIFICATION, J2_VERIFICATION]:
			if moved.has(target) and _synthetic_list(target, lists) >= 0:
				pairs.append_array(lists[_synthetic_list(target, lists)])
		if pairs.is_empty():
			return
		var anchor: String = "## Everything J3 stands beside"
		_edit(edit, anchor, "## J3's own layer for a later cascade, modelled by the D-344 dry run: J3 still carries its pairs inline.\nconst J12_MOVES: Array = [\n" + _render(pairs) + "]\n\n" + anchor)


func _edit(edit: Dictionary, old: String, new: String) -> void:
	edit["text"] = String(edit["text"]).replace(old, new)
	(edit["pairs"] as Array).append([new, old])


## The index of the synthetic pair list that puts `target` back, or -1.
func _synthetic_list(target: String, lists: Array) -> int:
	for index: Variant in _list_target:
		if String(_list_target[index]) == target and int(index) < lists.size():
			return int(index)
	return -1


func _list_name(pairs: Array) -> String:
	var listing: String = ""
	for pair: Array in pairs:
		listing += "%s %s\n" % [String(pair[0]).sha256_text(), String(pair[1]).sha256_text()]
	return listing.sha256_text()


# --- Helpers -----------------------------------------------------------------------------------------------

## Only the `find` lines of a production walk — what is walked, as against what its digest is pinned at.
func _find_lines(lines: PackedStringArray) -> PackedStringArray:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in lines:
		if line.contains(WALK_MARK):
			kept.append(line)
	return kept


## Every line that differs between two listings, in either direction.
func _line_difference(now: PackedStringArray, then: PackedStringArray) -> PackedStringArray:
	var differing: PackedStringArray = PackedStringArray()
	for line: String in now:
		if not then.has(line):
			differing.append(line)
	for line: String in then:
		if not now.has(line):
			differing.append(line)
	return differing


## Whether every differing line is accounted for by a pair the moving decision recorded for that file: each
## line now present must lie inside some pair's `after`, and each line no longer present inside its `before`
## (decision D-344). A file no decision has moved may not differ at all.
func _moves_are_recorded(path: String, now: PackedStringArray, then: PackedStringArray) -> bool:
	if not J11_MOVE_IDS.has(path):
		return _line_difference(now, then).is_empty()
	var pairs: Array = engine.pairs_of(loaded, String(J11_MOVE_IDS[path]))
	if pairs.is_empty():
		return false
	for line: String in now:
		if then.has(line):
			continue
		var held: bool = false
		for pair: Array in pairs:
			held = held or String(pair[0]).contains(line)
		if not held:
			return false
	for line: String in then:
		if now.has(line):
			continue
		var held: bool = false
		for pair: Array in pairs:
			held = held or String(pair[1]).contains(line)
		if not held:
			return false
	return true


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


## A file's text as it stands, read once.
func _text(path: String) -> String:
	if not _texts_cache.has(path):
		_texts_cache[path] = FileAccess.get_file_as_string(path)
	return _texts_cache[path]


## A suite file's text at D-341: the file as it stands for the seven D-342 left alone, and with D-342's pairs put
## back for the thirteen it migrated.
func _d341_text(path: String) -> String:
	var text: String = _d343_text(path)
	for row: Array in MIGRATED:
		if String(row[0]) == path:
			return String(engine.apply(text, engine.pairs_of(loaded, String(row[3])))["text"])
	return text


## A suite file's text as D-343 left it: the file as it stands for the two J11 did not move, and with J11's own
## pairs put back for the eighteen it did (decision D-344).
func _d343_text(path: String) -> String:
	if not J11_MOVE_IDS.has(path):
		return _text(path)
	return String(engine.apply(_text(path), engine.pairs_of(loaded, String(J11_MOVE_IDS[path])))["text"])


## The SHA-256 a suite file holds now, as `SUITES` pins it.
func _now(path: String) -> String:
	for row: Array in SUITES:
		if String(row[0]) == path:
			return String(row[1])
	return ""


## A verification's constants, read by parsing it; a runner has none, and is never handed to the loader.
func _constants(path: String) -> Dictionary:
	if not path.ends_with(".gd"):
		return {}
	if not _constants_cache.has(path):
		var script: Script = load(path)
		_constants_cache[path] = script.get_script_constant_map() if script != null else {}
	return _constants_cache[path]


## Every pair-list name a suite pins, as [the file it is applied to, the name].
func _pinned_names(path: String) -> Array:
	var uses: Array = []
	if not path.ends_with("_verification.gd") or path == THIS_FILE:
		return uses
	var constants: Dictionary = _constants(path)
	if constants.has("MOVED_SUITE_ROWS"):
		for row: Array in constants["MOVED_SUITE_ROWS"]:
			uses.append([String(row[0]), String(row[3])])
	for key: String in constants:
		if key.ends_with("_MOVE_IDS"):
			for target: String in constants[key]:
				uses.append([target, String(constants[key][target])])
	return uses


func _has_edge(path: String, name: String) -> bool:
	for edge: Dictionary in loaded["edges"]:
		if String(edge["path"]) == path and String(edge["pairs"]) == name:
			return true
	return false


func _has_edge_between(path: String, from: String, to: String, name: String) -> bool:
	for edge: Dictionary in loaded["edges"]:
		if String(edge["path"]) == path and String(edge["from"]) == from and String(edge["to"]) == to and String(edge["pairs"]) == name:
			return true
	return false


func _is_migrated(path: String) -> bool:
	for row: Array in MIGRATED:
		if String(row[0]) == path:
			return true
	return false


## Whether an edge holds: its file, rebuilt from the live file to the edge's own starting state through the store,
## and then put back by the edge's pair list, hashes to the edge's target.
func _edge_holds(edge: Dictionary) -> bool:
	var path: String = edge["path"]
	if not FileAccess.file_exists(path):
		return false
	var start: Dictionary = engine.rebuild(loaded, path, _text(path), String(edge["from"]))
	if not bool(start["found"]):
		return false
	var after: Dictionary = engine.apply(String(start["text"]), engine.pairs_of(loaded, String(edge["pairs"])))
	return String(after["text"]).sha256_text() == String(edge["to"])


## One suite's read of `path`, as that suite makes it: every layer it holds newest first — D-342's, then J10's
## down to its oldest — each applied only if it names that file and each checked first against the prefix the
## suite pins for it; then the suite's own prefix; then `pairs`, which must each occur exactly once, to `target`.
func _replay(constants: Dictionary, path: String, pairs: Array, own_prefix: String, target: String) -> Dictionary:
	var text: String = _text(path)
	for moves: String in _layers(constants):
		var prefixes: String = moves.replace("_MOVE_IDS", "_PREFIXES")
		if not (constants[moves] as Dictionary).has(path):
			continue
		if not text.sha256_text().begins_with(String(constants[prefixes][path])):
			return {"ok": false, "text": text, "fault": "before %s it hashes %s, not %s" % [moves, text.sha256_text().left(8), constants[prefixes][path]]}
		text = String(engine.apply(text, engine.pairs_of(loaded, String(constants[moves][path])))["text"])
	if not text.sha256_text().begins_with(own_prefix):
		return {"ok": false, "text": text, "fault": "put back to the suite's own state it hashes %s, not %s" % [text.sha256_text().left(8), own_prefix]}
	var rebuilt: Dictionary = engine.apply(text, pairs)
	if pairs.is_empty() or not bool(rebuilt["unique"]) or String(rebuilt["text"]).sha256_text() != target:
		return {"ok": false, "text": text, "fault": "its own pairs (%d) rebuild %s, not %s" % [pairs.size(), String(rebuilt["text"]).sha256_text().left(8), target.left(8)]}
	return {"ok": true, "text": String(rebuilt["text"]), "fault": ""}


## The layers a migrated suite holds, newest first, named by their own constants. They are ordered by the
## DECISION each one puts back, never by its J-number: First-MVP Gameplay J11 is D-344 and so is NEWER than
## D-342's `VM1`, which a numeric J-key could not express (decision D-344).
const LAYER_DECISIONS: Dictionary = {
	"J11_MOVE_IDS": 344, "VM1_MOVE_IDS": 342, "J10_MOVE_IDS": 340, "J9_MOVE_IDS": 338, "J8_MOVE_IDS": 336,
	"J7_MOVE_IDS": 334, "J6_MOVE_IDS": 332, "J5_MOVE_IDS": 330, "J4_MOVE_IDS": 328,
}
func _layers(constants: Dictionary) -> Array[String]:
	var found: Array = []
	for key: String in constants:
		if key.ends_with("_MOVE_IDS") and LAYER_DECISIONS.has(key):
			found.append([int(LAYER_DECISIONS[key]), key])
	found.sort_custom(func(a: Array, b: Array) -> bool: return int(a[0]) > int(b[0]))
	var names: Array[String] = []
	for entry: Array in found:
		names.append(String(entry[1]))
	return names


## J3's three reads, exactly as J3's own first check makes them, through the pairs it still carries inline.
func _j3_replay() -> Dictionary:
	var j3: Dictionary = _constants(J3_VERIFICATION)
	var reads: Array = [
		[SLICE, [11, 10, 9, 5, 4], ["J11_SLICE_PREFIX", "J10_SLICE_PREFIX", "J9_SLICE_PREFIX", "J5_SLICE_PREFIX", "J4_SLICE_PREFIX"], "J3_PREFIX"],
		[J1_VERIFICATION, [11, 10, 9, 5, 4], ["J11_J1_PREFIX", "J10_J1_PREFIX", "J9_J1_PREFIX", "J5_J1_PREFIX", "J4_J1_PREFIX"], "J1_PREFIX"],
		[J2_VERIFICATION, [11, 10, 9, 8, 7, 6, 5, 4], ["J11_J2_PREFIX", "J10_J2_PREFIX", "J9_J2_PREFIX", "J8_J2_PREFIX", "J7_J2_PREFIX", "J6_J2_PREFIX", "J5_J2_PREFIX", "J4_J2_PREFIX"], "J2_PREFIX"],
	]
	var ends: Array = []
	for read: Array in reads:
		var text: String = _text(String(read[0]))
		for index: int in (read[1] as Array).size():
			var prefix: String = j3[String(read[2][index])]
			if not text.sha256_text().begins_with(prefix):
				return {"ok": false, "fault": "%s hashes %s before J%d's layer, not %s" % [String(read[0]).get_file(), text.sha256_text().left(8), read[1][index], prefix]}
			text = String(engine.apply(text, j3["J%d_MOVES" % int(read[1][index])])["text"])
		if not text.sha256_text().begins_with(String(j3[String(read[3])])):
			return {"ok": false, "fault": "%s put back hashes %s, not %s" % [String(read[0]).get_file(), text.sha256_text().left(8), j3[String(read[3])]]}
		ends.append(text)
	var row_new: String = String(j3["SLICE_ROW_COMMENT"]) + "\t[\"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd\", \"%s\"],\n" % String(j3["J3_PREFIX"])
	var slice_back: String = String(ends[0]).replace(String(j3["J3_ADDED_COMMENT"]), "").replace(String(j3["J3_CANCELLATION"]), "")
	var j1_back: String = String(ends[1]).replace(row_new, String(j3["SLICE_ROW_OLD"])).replace(String(j3["J1_CLAUSE"]), "")
	var j2_back: String = String(ends[2]).replace(row_new, String(j3["SLICE_ROW_OLD"])).replace(String(j3["J2_CLAUSE"]), "")
	if (slice_back.sha256_text() != String(j3["PRE_J3_SHA256"]) or j1_back.sha256_text() != String(j3["J1_PRE_SHA256"])
			or j2_back.sha256_text() != String(j3["J2_PRE_SHA256"])):
		return {"ok": false, "fault": "the slice, J1 and J2 rebuild %s, %s and %s" % [slice_back.sha256_text().left(8), j1_back.sha256_text().left(8), j2_back.sha256_text().left(8)]}
	return {"ok": true, "fault": ""}


## Each stored file's chain of states from the live file, newest first, by decision.
func _history_lines() -> PackedStringArray:
	var lines: PackedStringArray = PackedStringArray()
	for path: String in _paths_in_edges():
		var state: String = _text(path).sha256_text()
		var parts: PackedStringArray = PackedStringArray(["now %s" % state.left(8)])
		var seen: Dictionary = {}
		while not seen.has(state):
			seen[state] = true
			var next: Dictionary = {}
			for edge: Dictionary in loaded["edges"]:
				if String(edge["path"]) == path and String(edge["from"]) == state:
					if next.is_empty() or _decision_number(String(edge["decision"])) > _decision_number(String(next["decision"])):
						next = edge
			if next.is_empty():
				break
			state = next["to"]
			parts.append("%s put back %s" % [next["decision"], state.left(8)])
		lines.append("%s: %s" % [path.get_file(), ", ".join(parts)])
	return lines


func _paths_in_edges() -> PackedStringArray:
	var paths: PackedStringArray = PackedStringArray()
	for edge: Dictionary in loaded["edges"]:
		if not paths.has(String(edge["path"])):
			paths.append(String(edge["path"]))
	paths.sort()
	return paths


func _depth(id: String, depths: Dictionary, visiting: Dictionary) -> int:
	if depths.has(id):
		return depths[id]
	if visiting.has(id) or not (loaded["segments"] as Dictionary).has(id):
		return -1
	visiting[id] = true
	var deepest: int = 0
	for part: Array in loaded["segments"][id]:
		var below: Array[String] = []
		if String(part[0]) == "&":
			below.append(String(part[1]))
		elif String(part[0]) == "%":
			for pair: Array in loaded["listings"][String(part[1])]:
				below.append(String(pair[0]))
				below.append(String(pair[1]))
		for child: String in below:
			var depth: int = _depth(child, depths, visiting)
			if depth < 0:
				return -1
			deepest = maxi(deepest, depth + 1)
	visiting.erase(id)
	depths[id] = deepest
	return deepest


func _chain_length(key: String, leaving: Dictionary, visiting: Dictionary) -> int:
	if visiting.has(key):
		return -1
	visiting[key] = true
	var longest: int = 0
	for edge: Dictionary in leaving.get(key, []):
		var length: int = _chain_length("%s %s" % [edge["path"], edge["to"]], leaving, visiting)
		if length < 0:
			return -1
		longest = maxi(longest, length + 1)
	visiting.erase(key)
	return longest


func _decision_number(decision: String) -> int:
	return int(decision.substr(2))


## What nesting would look like: every stored text of REFERENCE_MINIMUM characters or more, escaped once, and
## every stored pair list written inline, raw and escaped once. Built once.
var _needles: PackedStringArray = PackedStringArray()


func _stored_needles() -> PackedStringArray:
	if _needles.is_empty():
		for id: String in loaded["texts"]:
			var escaped: String = engine.escape(String(loaded["texts"][id]))
			if escaped.length() >= REFERENCE_MINIMUM:
				_needles.append(escaped)
		for id: String in loaded["listings"]:
			var written: String = _render(engine.pairs_of(loaded, id))
			_needles.append(written)
			_needles.append(engine.escape(written))
	return _needles


func _render(pairs: Array) -> String:
	var out: PackedStringArray = PackedStringArray()
	for pair: Array in pairs:
		out.append("\t\t[\"%s\",\n\t\t\t\"%s\"],\n" % [engine.escape(String(pair[0])), engine.escape(String(pair[1]))])
	return "".join(out)


func _strings_in(value: Variant) -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	if value is String:
		found.append(value)
	elif value is Array:
		for item: Variant in value:
			found.append_array(_strings_in(item))
	elif value is Dictionary:
		for key: Variant in value:
			found.append_array(_strings_in(value[key]))
	return found


func _names_in(value: Variant) -> Array:
	var names: Array = []
	if value is Dictionary:
		for key: Variant in value:
			names.append(value[key])
	else:
		for row: Array in value:
			names.append(row[row.size() - 1])
	return names


func _is_name(text: String) -> bool:
	return text.length() == 64 and text.is_valid_hex_number(false)


func _flip(name: String) -> String:
	return name.left(63) + ("0" if name.right(1) != "0" else "1")


func _sha(bytes: PackedByteArray) -> String:
	var context: HashingContext = HashingContext.new()
	context.start(HashingContext.HASH_SHA256)
	context.update(bytes)
	return context.finish().hex_encode()


func _bytes(store: Dictionary, record: Dictionary) -> PackedByteArray:
	return (engine.serialize(store, record) as String).to_utf8_buffer()


func _refusal(files: Dictionary) -> String:
	var parsed: Dictionary = engine.parse(files)
	return "" if bool(parsed["valid"]) else "; ".join(parsed["refusals"])


func _first(refusal: String) -> String:
	return refusal.get_slice("; ", 0).left(110)


## The first refusal that names the class of fault a mutation was made to provoke.
func _reason(refusal: String, word: String) -> String:
	for part: String in refusal.split("; "):
		if part.contains(word):
			return part.left(110)
	return "(none naming %s)" % word


## The byte offset of an ASCII letter inside the store's first literal segment.
func _first_literal_letter(bytes: PackedByteArray) -> int:
	var at: int = 0
	while at < bytes.size():
		var end: int = bytes.find(10, at)
		var line: String = bytes.slice(at, end).get_string_from_utf8()
		at = end + 1
		if line.begins_with("=") and line.substr(1).is_valid_int():
			for offset: int in int(line.substr(1)):
				var byte: int = bytes[at + offset]
				if byte >= 97 and byte <= 122:
					return at + offset
	return -1


func _store_summary() -> String:
	var parts: PackedStringArray = PackedStringArray()
	for row: Array in STORE_FILES:
		parts.append("%s at %s, %d bytes" % [row[0], String(row[1]).left(8), row[2]])
	return ", ".join(parts)


## Every line of a verification that asserts, reports, completes an owed check or ends the run.
func _functional_lines(text: String) -> PackedStringArray:
	var lines: PackedStringArray = PackedStringArray()
	var regex: RegEx = RegEx.create_from_string("^\\t*(_expect|_done|print|quit)\\(")
	for line: String in text.split("\n"):
		if regex.search(line) != null:
			lines.append(line)
	return lines


func _owed_block(text: String) -> String:
	var start: int = text.find("const OWED_CHECKS: Array[String] = [")
	return "" if start < 0 else text.substr(start, text.find("\n]\n", start) - start)


func _walk_lines(text: String) -> PackedStringArray:
	var lines: PackedStringArray = PackedStringArray()
	for line: String in text.split("\n"):
		if line.contains(WALK_MARK) or line.begins_with("EXPECTED_PRODUCTION_"):
			lines.append(line)
	return lines


func _longest_line(text: String) -> int:
	var longest: int = 0
	for line: String in text.split("\n"):
		longest = maxi(longest, line.length())
	return longest


func _argument_value(flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
