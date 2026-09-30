extends SceneTree
## First-MVP Gameplay J11 — Gate 1D Landing-to-Broken-Watch Route Continuity V1: automated verification
## (decision D-344).
##
## THE ONE QUESTION: in Gate 1D's composed scene, can the character actually walk from Riftfall Landing into
## Broken Watch along the route the two layouts were drawn for? Before J11 it could not. Riftfall Landing
## Greybox V2 ends in a tall boundary mass its own source calls "the far cap beyond the landing, so the space
## closes rather than trailing into open void" — right for a Landing that ends there. Broken Watch's Watch
## Threshold occupies local x -3 to 9, z -35 to -27, and the two layouts are siblings under one
## `NavigationRegion3D` in ONE shared local frame, so that cap — x 1 to 9, z -34 to -30 — stands INSIDE the
## Threshold, 32.00 m^2 of it.
##
## WHAT WAS MEASURED BEFORE THE EDIT, AND IT IS NOT WHAT THE BRIEF ASSUMED. The cap did not SEAL the route: it
## blocked the intended line and forced an unintended detour. On the Landing's own centreline (local x = 3) a
## player-sized capsule met `Landing/WorldCollision/Boundary_10_-340` at every station from z = -30.0 to
## z = -34.0, and the navigation mesh was 2.55 m away at z = -32. A path from Way Out (3, -27) to the entry
## (3, -34.75) existed — 9 points, 10.93 m — but only by swinging west to local x = 0.45 and back, through the
## 4 m channel between the cap's west face and the Threshold's west wall. That dogleg is in neither layout's
## design. After J11 the same path is 3 points and 7.75 m, straight down x = 3.00.
##
## THE OPENING IS COMPOSITION-LOCAL, exactly as `CanonicalOpeningRuntime._open_broken_watch_far_cap()` is.
## `riftfall_landing_greybox_layout.gd` is untouched and still builds the cap, so the standalone Landing review
## is unchanged; `BrokenWatchSlice._ready()` removes the cap's three built nodes from ITS OWN instance, before
## the navigation bake. The cap is found from AUTHORED STRUCTURAL DATA — the only Landing boundary mass whose
## footprint overlaps a Broken Watch walkable rectangle, which is the defect written as a predicate — and
## exactly one must qualify and exactly three nodes must go, or it fails loudly through `push_error()` as well
## as `assert()`, because `assert()` is stripped in release builds.
##
## GATE 1D'S OWN `broken_watch_slice.tscn`, LOADED AS IT SHIPS, then the accepted standalone Landing greybox
## review, loaded second so that no navigation state of the first can answer for it. The traversal proof uses
## the production movement chain: `PrototypeGroundPointer.resolve_to_navigation()` and
## `PrototypePlayer.command_move_to()` — the two lines `_issue_move_command()` itself runs — and, separately,
## the InputMap's own stick action held forward through `Input.action_press()`. Nothing is teleported,
## depenetrated or nudged during a traversal window, and the first Graveblade is moved more than 30 m away
## before each one so neither its collision nor its AI can touch the result.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. It opens no window and writes no file.
##
## Run: godot --headless --path game --script res://tests/landing_broken_watch_route_continuity_verification.gd

const THIS_FILE: String = "res://tests/landing_broken_watch_route_continuity_verification.gd"
const SLICE_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
const LANDING_SCRIPT: String = "res://scripts/first_mvp/greybox/riftfall_landing_greybox_layout.gd"
const LAYOUT_SCRIPT: String = "res://scripts/first_mvp/severed_threshold/broken_watch_layout.gd"
const OPENING_SCRIPT: String = "res://scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd"
const CORE_LOOP_SCRIPT: String = "res://scripts/roguelite/roguelite_core_loop_runtime.gd"
const SLICE_SCENE: String = "res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
const LANDING_REVIEW_SCENE: String = "res://scenes/first_mvp/greybox/riftfall_landing_greybox_review.tscn"
const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]

## The provenance engine and the two store files, pinned. D-344 wrote its own file and rewrote neither the
## engine nor D-342's (decision D-343 ruling 4).
const PROVENANCE_ENGINE: String = "res://tests/provenance/accepted_suite_provenance.gd"
const PROVENANCE_ENGINE_SHA256: String = "fadbdfeba32546d03bffe876c2b8be7a96dfe966ff9f5d4f720199d664b23dc4"
const STORE_DIRECTORY: String = "res://tests/provenance"
const D342_STORE: String = "d342_accepted_suite_history.provenance"
const D344_STORE: String = "d344_gate_1d_route_continuity.provenance"

## The Landing's far cap, as `RiftfallLandingGreyboxLayout` authors it, and the three nodes it builds from it.
const CAP_RECT: Rect2 = Rect2(Vector2(1.0, -34.0), Vector2(8.0, 4.0))
const CAP_STEM: String = "Boundary_10_-340"
const CAP_HEIGHT: float = 3.60
const CAP_OVERLAP: float = 32.00
const LANDING_BOUNDARY_MASSES: int = 11
const LANDING_WALKABLE_RECTS: int = 15
const BROKEN_WATCH_ROOMS: int = 5

## The seam, in the two layouts' one shared local frame.
const SEAM_X: float = 3.0
const NORTH_OF_CAP: float = -28.0
const CAP_NEAR_FACE: float = -30.0
const CAP_FAR_FACE: float = -34.0
const ENTRY_LOCAL: Vector2 = Vector2(3.0, -34.75)
const WALK_START: Vector2 = Vector2(3.0, -22.0)
const ON_MESH: float = 0.05
const ARRIVED: float = 0.30
const OFF_MESH_LIMIT: float = 0.60
const WALK_FRAMES: int = 600
const STICK_FRAMES: int = 420
const ISOLATION_METRES: float = 30.0
const SEAM_STATIONS: int = 15
const STEP_TOLERANCE: float = 1.5

## J10's accepted measure, re-read here unchanged.
const WINDOW_FRAMES: int = 150
const STABLE_METRES: float = 0.010
const STILL_SPEED: float = 0.0001
const RESTART_CAPTION: String = "Restart Broken Watch"
const ENCOUNTER_RESET: String = "encounter reset"
const CALLBACK: String = "_on_first_graveblade_died"

## Gate 1D’s slice as D-343 left it, and J11’s one change to it, whole.
const PRE_J11_SLICE_SHA256: String = "883ef25e0cf401607e38094b0d303820da6dc8114ad849f1616869941d328a55"
const J11_SLICE_PREFIX: String = "d4e839fb"
const LANDING_SHA256: String = "21afae31779c11fe5baaf6e7fbeec0a674ef229f702d9d20856fa5170f4daa8c"
const LAYOUT_SHA256: String = "cac924df44705faa5fd4f16c23fadb808ec1d2bfe67f6b0863e8d6a46a998c3e"
const J11_OPENING: String = "\t# First-MVP Gameplay J11 (decision D-344): RIFTFALL LANDING CLOSED ITS OWN FAR END,\n\t# AND THAT CLOSURE IS FALSE IN THIS COMPOSITION. The Landing's accepted Greybox V2\n\t# ends in a tall boundary mass its own source calls \"the far cap beyond the landing,\n\t# so the space closes rather than trailing into open void\" -- exactly right for a\n\t# Landing that ends there, and a solid standing inside Broken Watch's Watch Threshold\n\t# here, because the two layouts are siblings in one shared local frame. On the route's\n\t# own centreline it stopped a player-sized body outright and the navigation mesh\n\t# carried no surface at all, so the seam was passable only by a detour the design\n\t# never drew. It is removed from THIS instance, before the bake, exactly as\n\t# `CanonicalOpeningRuntime` removes Broken Watch's own far cap toward the Nexus\n\t# Threshold: `riftfall_landing_greybox_layout.gd` is untouched, and the standalone\n\t# Landing review still builds the cap, because a Landing that ends there needs it.\n\t#\n\t# THE CAP IS FOUND FROM AUTHORED STRUCTURAL DATA, NOT FROM A NODE NAME: it is the only\n\t# Riftfall Landing boundary mass whose footprint overlaps a Broken Watch walkable\n\t# rectangle -- the defect itself, written as a predicate over both layouts' own\n\t# constants. Exactly one must qualify, and exactly its three built nodes must go: the\n\t# visual, the collision shape and the navigation carve. Anything else is a real change\n\t# to one of the two layouts, and it must fail loudly rather than quietly reseal the\n\t# route or quietly take more of the Landing down with it.\n\tvar landing_caps: Array[Rect2] = []\n\tfor mass: Dictionary in RiftfallLandingGreyboxLayout.BOUNDARY_MASSES:\n\t\tvar rect: Rect2 = mass[\"rect\"]\n\t\tfor room: Rect2 in BrokenWatchLayout.WALKABLE:\n\t\t\tif rect.intersects(room):\n\t\t\t\tlanding_caps.append(rect)\n\t\t\t\tbreak\n\tvar cap_nodes_removed: int = 0\n\tfor rect: Rect2 in landing_caps:\n\t\tvar stem: String = \"Boundary_%d_%d\" % [int(rect.position.x * 10.0), int(rect.position.y * 10.0)]\n\t\tfor built: String in [\"Visuals/%s\" % stem, \"WorldCollision/%s\" % stem,\n\t\t\t\t\"NavigationObstacles/%sCarve\" % stem]:\n\t\t\tvar node: Node = landing_layout.get_node_or_null(built)\n\t\t\tif node != null:\n\t\t\t\tnode.free()\n\t\t\t\tcap_nodes_removed += 1\n\tvar cap_fault: String = \"BrokenWatchSlice: expected exactly 1 Riftfall Landing far cap overlapping Broken Watch and its 3 built nodes, found %d and %d\" % [landing_caps.size(), cap_nodes_removed]\n\tif landing_caps.size() != 1 or cap_nodes_removed != 3:\n\t\t# `assert()` is stripped in release builds; `push_error()` is not, so both are used.\n\t\tpush_error(cap_fault)\n\tassert(landing_caps.size() == 1 and cap_nodes_removed == 3, cap_fault)\n\tlog_event(\"landing cap opened\", \"%d Riftfall Landing boundary mass overlaps Broken Watch; its %d built nodes are removed in THIS composition, before the bake\" % [landing_caps.size(), cap_nodes_removed])\n\n"

## The two store files, and the union they parse to.
const D342_SHA256: String = "3b38ca4d6576dcafd8267650fefb9acfe4ea5ecc5aae712b1c7105e120ff3c3c"
const D342_BYTES: int = 412215
const D344_SHA256: String = "0ab807ed2ffb6e925039f0eeb40d3a5ba8003a62f6971d3125f21984b00e7007"
const D344_BYTES: int = 83610
const UNION_TEXTS: int = 737
const UNION_PAIR_LISTS: int = 104
const UNION_EDGES: int = 165

## The slice’s declarations, as every accepted suite pins them, and what each layout builds.
const SLICE_FIELDS: int = 35
const SLICE_EXPORTS: int = 8
const SLICE_FUNCTIONS: int = 53
const SLICE_CONSTANTS: int = 12
const LANDING_VISUALS: int = 35
const LANDING_COLLIDERS: int = 31
const LANDING_CARVES: int = 16
const WATCH_VISUALS: int = 25
const WATCH_COLLIDERS: int = 24
const WATCH_CARVES: int = 19
## The furthest a body at the accepted 5.0 m/s may move in one 60 Hz physics step, with a margin.
const ACCEPTED_STEP: float = 0.1500

## Everything J11 stands beside, at the SHA-256 prefix each held before the first J11 edit.
const UNCHANGED_HASHES: Array = [
	["res://scripts/actors/prototype_player.gd", "80e38838"],
	["res://scripts/actors/prototype_graveblade.gd", "0ae1374b"],
	["res://scripts/combat/quick_strike_action.gd", "e6514705"],
	["res://scripts/combat/attack_coordinator.gd", "9ee63381"],
	["res://scripts/combat/target_acquisition.gd", "bf4c14d4"],
	["res://scripts/combat/damage_event.gd", "3b3185c4"],
	["res://scripts/movement/prototype_ground_pointer.gd", "ee7ab5ad"],
	["res://scripts/movement/prototype_locomotion.gd", "c71de58f"],
	["res://scripts/items/first_mvp_item_drop.gd", "dbd5594d"],
	["res://scripts/ui/first_mvp_combat_hud.gd", "ee485029"],
	["res://scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd", "601e5901"],
	["res://scripts/roguelite/roguelite_core_loop_runtime.gd", "a76cec3d"],
	["res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn", "e9d16993"],
	["res://scenes/first_mvp/greybox/riftfall_landing_greybox_review.tscn", "46121c2a"],
	["res://tests/gate_1d_broken_watch_verification.gd", "9393f97a"],
	["res://project.godot", "55351038"],
]

## The engine, pinned, and the eighteen accepted suite files J11 moved: [path, its J11 prefix, the
## SHA-256 D-343 left it at, the pair list in the D-344 store that puts J11 back].
const MOVED_SUITE_ROWS: Array = [
	["res://tests/first_mvp_modal_left_click_verification.gd", "d12ad271", "75f2648650da8e9d3a97e205eb97a843b1ed2a4d6b8b04824f46d56d30cd5130", "e7b62a6207638ff89cd8732cc9bbcfd57503f83f8877662c7a4806a709fdc3c8"],
	["res://tests/fallen_modal_life_state_verification.gd", "72e39a8a", "935a37e9a13cc47d383bbaf4dab0af90d790dfbb7f87509e0b8b9307f724520c", "e7b62a6207638ff89cd8732cc9bbcfd57503f83f8877662c7a4806a709fdc3c8"],
	["res://tests/pending_fallen_restart_verification.gd", "7d0e3f08", "53c379761fa52afb1b8c28306c04daca87791eccc6416c9d3b536c21a1653fe1", "eab887b6ceea266bb06554728df7227e3c47fb0338990a0f9e3209f733f9b6c2"],
	["res://tests/pending_fallen_restart_smoke.sh", "54a4464a", "9a860bca0646e71afa06bbca104d9e16319993babd57100ba3b5b0bcf0cb12d1", "a7a5214f7f0fd6e1f4d32fc539df430b11312aee42ad845ee135cbdba73cecd2"],
	["res://tests/fallen_delay_item_interaction_verification.gd", "8aad4262", "15352d8a50b10ad98768d76c3c1dd68acad57753cb5900fc72d77b2c83517291", "7b773bea4b14e0ff94ae58afcf898e9d269834c1c8bd257ad10717becf55fc07"],
	["res://tests/fallen_delay_item_interaction_smoke.sh", "939d9b48", "0fd60eb7d1cb15544cf1a17102ab5cec1516e55ef1e0b1556fa2c8fe04485cfc", "a089abfb62d27e1a1f9d8f3e523c12d8da6f930056aba5d3daa0a7a687f5ce2b"],
	["res://tests/fallen_delay_drop_highlight_verification.gd", "beb94aa0", "6204a260e42a042a5407e5b13d8bb105a8899df286b4fddff043ac35710722b8", "93e92c6cdfd494daf85285c7abaa06f5229b1bea0e7e4de67d3b6f02f253f182"],
	["res://tests/fallen_delay_drop_highlight_smoke.sh", "6f792a38", "08aa2d0b359a9a350a4b2b07dda138200f57faea5a5ef60c60a5849f66e1ded8", "a0d7525a31de8048a66815277d6eb7c67b76dc6d90bbfe2eccb519057cd525fa"],
	["res://tests/combat_hud_fractional_fill_verification.gd", "8c653002", "d23c5fdc1b708c7c87e48b430ead753cdc5c08875983bf7cfab4db898b1797bf", "fd86747b7f850c99c998632fb24898b79daa9dd06b2a9e199331a1162a6e40a6"],
	["res://tests/combat_hud_fractional_fill_smoke.sh", "51d64a23", "be9f6f47ceb3e79d9b784fe1e8766639cec351add0c52c99e2f4a3a9686b0144", "ca348c34762f8640fa88bf6629f35c15aaaa7b9a495972800d4dcd94d4074845"],
	["res://tests/enemy_hover_life_fractional_fill_verification.gd", "bf92c1ec", "09e25736956a9f750331a44f6f973344a7fe59cdcb7bf1e9265e6fc635a197e6", "bf9b61b11d9e56be4dff793b83d133f56bcdcf4ffdd8db0cc2ee5e8de0715d5a"],
	["res://tests/enemy_hover_life_fractional_fill_smoke.sh", "64a84a9d", "85a49a224612711fd9e7964449538afc19f3eda586f9d106f70a3c81e18b6333", "abb783d1bb48944f378110a2d21d02ba0f6367ad5958c99b4f6de19cbeb49188"],
	["res://tests/combat_hud_safe_bottom_placement_verification.gd", "2ca75553", "bfab962cb08b9466b33cdfc9de3802e4cbc224a3f1eb3a865c7cc2c63d0d5e3f", "8cdb1c4ac20a56377ccde3a23dc95da5de60cacb66b1777b88ed3cc2ee0f8f18"],
	["res://tests/combat_hud_safe_bottom_placement_smoke.sh", "f562e165", "95506b40c3274ced5143436e468205cd3fb6326bf2a029f2581f6e867fa34fe7", "95680171a31d73eac1122c03ce51baba10096ecc56f80691ff6476e132b58383"],
	["res://tests/guaranteed_drop_defeated_enemy_binding_verification.gd", "aaa9e1d3", "e526397bf360dab81887bb63936be6827fe8a2823258d3eec83bad7c89d70248", "130d65f893fd3c07d1d6261bf850557fb3d45fb71ca060ff70c65914c90dc5b3"],
	["res://tests/guaranteed_drop_defeated_enemy_binding_smoke.sh", "94b5e6c9", "2254440306d58e20079532cd3577e9df48bc2e3bb0d4831a332f91ef64deae20", "769d2d53f0f88c9fcf5bc50e135e4b8ad73245459e92799fbbd041437fff1b4c"],
	["res://tests/restart_position_stability_verification.gd", "1588cff8", "bf25715a79af9f3ec30d6988b9d477a38a79cc6e0f61de10fd9d0c7e167c5a7e", "05bc9f20bd2e1d051921151955555d334bd6361c712413293bdb582e70d60d6c"],
	["res://tests/restart_position_stability_smoke.sh", "34db74ce", "02f03162742af697c56cb76aefd0f9262bac26c92e6a479a5d618c8b55967681", "8e17e436ffeefd7232f1e9ecd29fdf596cc7fd3d192aeea3d5bf2a3f2a24c082"],
]
var MOVED_SUITES: Array = _stored(MOVED_SUITE_ROWS)

## Verification Maintenance V1’s own two files. Their pairs are INLINE here rather than in the store,
## for a structural reason: each names the D-344 store’s own SHA-256, and a record inside that store
## could not contain the hash of the file it is part of. Nothing reconstructs THIS suite, so nothing
## can nest on them.
const MAINTENANCE_MOVES: Array = [
	["res://tests/non_nesting_accepted_suite_reconstruction_verification.gd", "03c174ad", "a9844935dd52e66a52825e34edeac910a4ea12536062341905e5baad832d7189", [
		["var anchor: String = \"## Everything J3 stands beside\"\n\t\t_edit(edit, anchor, \"## J3's own layer for a later cascade, modelled by the D-344 dry run: J3 still carries its pairs inline.\\nconst J12_MOVES: Array = [\\n\"",
			"var anchor: String = \"## Everything J3 stands beside\"\n\t\t_edit(edit, anchor, \"## J3's own layer for a later cascade, modelled by the D-342 dry run: J3 still carries its pairs inline.\\nconst J11_MOVES: Array = [\\n\""],
		["_edit(edit, read, read.replace(\"FileAccess.get_file_as_string(path)\", \"_before_j12(path, FileAccess.get_file_as_string(path))\"))",
			"_edit(edit, read, read.replace(\"FileAccess.get_file_as_string(path)\", \"_before_j11(path, FileAccess.get_file_as_string(path))\"))"],
		["for read: String in [\"_before_j11(path, FileAccess.get_file_as_string(path))\", \"_before_vm1(path, FileAccess.get_file_as_string(path))\", \"_before_j10(path, FileAccess.get_file_as_string(path))\"]:",
			"for read: String in [\"_before_vm1(path, FileAccess.get_file_as_string(path))\", \"_before_j10(path, FileAccess.get_file_as_string(path))\"]:"],
		["\"\\n\\n## Puts a file the modelled later cascade moved back to where D-344 left it.\\nfunc _before_j12(path: String, text: String) -> String:\\n\\tfor pair: Array in J12_MOVES.get(path, []):\\n\\t\\ttext = text.replace(String(pair[0]), String(pair[1]))\\n\\treturn text\\n\"",
			"\"\\n\\n## Puts a file the modelled later cascade moved back to where D-342 left it.\\nfunc _before_j11(path: String, text: String) -> String:\\n\\tfor pair: Array in J11_MOVES.get(path, []):\\n\\t\\ttext = text.replace(String(pair[0]), String(pair[1]))\\n\\treturn text\\n\""],
		["for candidate: String in [\"var J11_MOVES: Dictionary = _stored(J11_MOVE_IDS)\\n\", \"var VM1_MOVES: Dictionary = _stored(VM1_MOVE_IDS)\\n\", \"var J10_MOVES: Dictionary = _stored(J10_MOVE_IDS)\\n\"]:",
			"for candidate: String in [\"var VM1_MOVES: Dictionary = _stored(VM1_MOVE_IDS)\\n\", \"var J10_MOVES: Dictionary = _stored(J10_MOVE_IDS)\\n\"]:"],
		["block += \"}\\nvar J12_MOVES: Dictionary = _stored(J12_MOVE_IDS)\\n\"",
			"block += \"}\\nvar J11_MOVES: Dictionary = _stored(J11_MOVE_IDS)\\n\""],
		["block += \"}\\nconst J12_MOVE_IDS: Dictionary = {\\n\"",
			"block += \"}\\nconst J11_MOVE_IDS: Dictionary = {\\n\""],
		["\"\\n## A later cascade's layer, modelled by the D-344 dry run.\\nconst J12_PREFIXES: Dictionary = {\\n\"",
			"\"\\n## A later cascade's layer, modelled by the D-342 dry run.\\nconst J11_PREFIXES: Dictionary = {\\n\""],
		["const SYNTHETIC_LINE: String = \"\\t# Synthetic dry run (D-344): one line, written only to temporary storage.\\n\"",
			"const SYNTHETIC_LINE: String = \"\\t# Synthetic dry run (D-342): one line, written only to temporary storage.\\n\""],
		["\"# Synthetic dry run (D-344): the NEXT decision's store file, written only to temporary storage.\"",
			"\"# Synthetic dry run (D-342): a later decision's store file, written only to temporary storage.\""],
		["d345_synthetic_dry_run.provenance",
			"d343_synthetic_dry_run.provenance"],
		["const SYNTHETIC_DECISION: String = \"D-345\"\n",
			"const SYNTHETIC_DECISION: String = \"D-343\"\n"],
		["## Only the `find` lines of a production walk — what is walked, as against what its digest is pinned at.\nfunc _find_lines(lines: PackedStringArray) -> PackedStringArray:\n\tvar kept: PackedStringArray = PackedStringArray()\n\tfor line: String in lines:\n\t\tif line.contains(WALK_MARK):\n\t\t\tkept.append(line)\n\treturn kept\n\n\n## Every line that differs between two listings, in either direction.",
			"## Every line that differs between two listings, in either direction."],
		["## Every line that differs between two listings, in either direction.\nfunc _line_difference(now: PackedStringArray, then: PackedStringArray) -> PackedStringArray:\n\tvar differing: PackedStringArray = PackedStringArray()\n\tfor line: String in now:\n\t\tif not then.has(line):\n\t\t\tdiffering.append(line)\n\tfor line: String in then:\n\t\tif not now.has(line):\n\t\t\tdiffering.append(line)\n\treturn differing\n\n\n## Whether every differing line is accounted for by a pair the moving decision recorded for that file: each\n## line now present must lie inside some pair's `after`, and each line no longer present inside its `before`\n## (decision D-344). A file no decision has moved may not differ at all.\nfunc _moves_are_recorded(path: String, now: PackedStringArray, then: PackedStringArray) -> bool:\n\tif not J11_MOVE_IDS.has(path):\n\t\treturn _line_difference(now, then).is_empty()\n\tvar pairs: Array = engine.pairs_of(loaded, String(J11_MOVE_IDS[path]))\n\tif pairs.is_empty():\n\t\treturn false\n\tfor line: String in now:\n\t\tif then.has(line):\n\t\t\tcontinue\n\t\tvar held: bool = false\n\t\tfor pair: Array in pairs:\n\t\t\theld = held or String(pair[0]).contains(line)\n\t\tif not held:\n\t\t\treturn false\n\tfor line: String in then:\n\t\tif now.has(line):\n\t\t\tcontinue\n\t\tvar held: bool = false\n\t\tfor pair: Array in pairs:\n\t\t\theld = held or String(pair[1]).contains(line)\n\t\tif not held:\n\t\t\treturn false\n\treturn true\n\n\nfunc _check_every_check_ran() -> void:",
			"func _check_every_check_ran() -> void:"],
		["\t# First-MVP Gameplay J11 (decision D-344): the last suite in a chain is read by no accepted suite, so its\n\t# pair list is pinned here instead — this maintenance suite is a trust root in its own right.\n\tfor path: Variant in J11_MOVE_IDS:\n\t\tpinned[String(J11_MOVE_IDS[path])] = true\n\tvar by_suites: int = pinned.size()\n",
			"\tvar by_suites: int = pinned.size()\n"],
		["\tprint(\"  %d production-walk lines across the accepted runners are exactly D-341's; every EXPECTED_PRODUCTION line is D-341's or moved inside a pair D-344 records\" % walks)",
			"\tprint(\"  %d production-walk lines across the accepted runners, and every EXPECTED_PRODUCTION line, are exactly D-341's\" % walks)"],
		["\t\tvar now: PackedStringArray = _walk_lines(_text(path))\n\t\tvar then: PackedStringArray = _walk_lines(_d341_text(path))\n\t\t# First-MVP Gameplay J11 (decision D-344): the `find` lines themselves must still be D-341’s, byte\n\t\t# for byte — nobody may quietly change what is walked. A pinned EXPECTED_PRODUCTION value may move,\n\t\t# and only inside a pair the decision that moved it records.\n\t\tif _find_lines(now) != _find_lines(then) or not _moves_are_recorded(path, now, then):\n\t\t\tmoved.append(path.get_file())\n",
			"\t\tvar now: PackedStringArray = _walk_lines(_text(path))\n\t\tvar then: PackedStringArray = _walk_lines(_d341_text(path))\n\t\tif now != then:\n\t\t\tmoved.append(path.get_file())\n"],
		["\tprint(\"  the %d verifications keep every owed-check list and their %d _expect calls, as at D-341; %d functional or measured line(s) moved in all, every one inside a pair D-344 records\"\n\t\t% [verifications, expects, moved_lines])",
			"\tprint(\"  the %d verifications keep every _expect, _done, print and quit line and every owed-check list, byte for byte: %d _expect calls in all, as at D-341\" % [verifications, expects])"],
		["\t\t\tif kept_now != kept_then and not _moves_are_recorded(path, kept_now, kept_then):\n\t\t\t\tfaults.append(\"%s moved beyond its hash rows, its comment lines and the pairs its cascade records\" % path.get_file())\n\t\t\telif kept_now != kept_then:\n\t\t\t\tmoved_lines += _line_difference(kept_now, kept_then).size()",
			"\t\t\tif kept_now != kept_then:\n\t\t\t\tfaults.append(\"%s moved beyond its hash rows and one comment line\" % path.get_file())"],
		["\t\t\t\tif not (row_regex.search(line) != null or line.begins_with(\"# Verification Maintenance V1 (D-342) moved \")\n\t\t\t\t\t\tor line.begins_with(\"# First-MVP Gameplay J11 (D-344) moved \")):\n\t\t\t\t\tkept_now.append(line)",
			"\t\t\t\tif not (row_regex.search(line) != null or line.begins_with(\"# Verification Maintenance V1 (D-342) moved \")):\n\t\t\t\t\tkept_now.append(line)"],
		["\tvar row_regex: RegEx = RegEx.create_from_string(\"^\\\\t\\\"\\\\$[A-Z0-9_]+\\\\|[0-9a-f]{8}\\\"$\")\n\tvar moved_lines: int = 0",
			"\tvar row_regex: RegEx = RegEx.create_from_string(\"^\\\\t\\\"\\\\$[A-Z0-9_]+\\\\|[0-9a-f]{8}\\\"$\")"],
		["\t\t\tvar lines_then: PackedStringArray = _functional_lines(then)\n\t\t\tvar calls_then: int = 0\n\t\t\tfor line: String in lines_then:\n\t\t\t\tif line.strip_edges().begins_with(\"_expect(\"):\n\t\t\t\t\tcalls_then += 1\n\t\t\t# First-MVP Gameplay J11 (decision D-344, owner ruling): a cascade that moves a file a suite pins by\n\t\t\t# its LIVE SHA-256 cannot leave that conjunct alone, so a functional line may move — but only inside\n\t\t\t# a pair the moving decision records, and never the assertion count or the owed set.\n\t\t\tif calls != calls_then or _owed_block(now) != _owed_block(then) or _owed_block(now).is_empty():\n\t\t\t\tfaults.append(\"%s's assertion count or owed set moved\" % path.get_file())\n\t\t\telif not _moves_are_recorded(path, lines_now, lines_then):\n\t\t\t\tfaults.append(\"%s's assertions or prints moved outside the pairs its cascade records\" % path.get_file())\n\t\t\telse:\n\t\t\t\tmoved_lines += _line_difference(lines_now, lines_then).size()",
			"\t\t\tif lines_now != _functional_lines(then) or _owed_block(now) != _owed_block(then) or _owed_block(now).is_empty():\n\t\t\t\tfaults.append(\"%s's assertions, prints or owed set moved\" % path.get_file())"],
		["\t\t[SLICE, [11, 10, 9, 5, 4], [\"J11_SLICE_PREFIX\", \"J10_SLICE_PREFIX\", \"J9_SLICE_PREFIX\", \"J5_SLICE_PREFIX\", \"J4_SLICE_PREFIX\"], \"J3_PREFIX\"],\n\t\t[J1_VERIFICATION, [11, 10, 9, 5, 4], [\"J11_J1_PREFIX\", \"J10_J1_PREFIX\", \"J9_J1_PREFIX\", \"J5_J1_PREFIX\", \"J4_J1_PREFIX\"], \"J1_PREFIX\"],\n\t\t[J2_VERIFICATION, [11, 10, 9, 8, 7, 6, 5, 4], [\"J11_J2_PREFIX\", \"J10_J2_PREFIX\", \"J9_J2_PREFIX\", \"J8_J2_PREFIX\", \"J7_J2_PREFIX\", \"J6_J2_PREFIX\", \"J5_J2_PREFIX\", \"J4_J2_PREFIX\"], \"J2_PREFIX\"],",
			"\t\t[SLICE, [10, 9, 5, 4], [\"J10_SLICE_PREFIX\", \"J9_SLICE_PREFIX\", \"J5_SLICE_PREFIX\", \"J4_SLICE_PREFIX\"], \"J3_PREFIX\"],\n\t\t[J1_VERIFICATION, [10, 9, 5, 4], [\"J10_J1_PREFIX\", \"J9_J1_PREFIX\", \"J5_J1_PREFIX\", \"J4_J1_PREFIX\"], \"J1_PREFIX\"],\n\t\t[J2_VERIFICATION, [10, 9, 8, 7, 6, 5, 4], [\"J10_J2_PREFIX\", \"J9_J2_PREFIX\", \"J8_J2_PREFIX\", \"J7_J2_PREFIX\", \"J6_J2_PREFIX\", \"J5_J2_PREFIX\", \"J4_J2_PREFIX\"], \"J2_PREFIX\"],"],
		["\tfor moves: String in _layers(constants):\n\t\tvar prefixes: String = moves.replace(\"_MOVE_IDS\", \"_PREFIXES\")\n\t\tif not (constants[moves] as Dictionary).has(path):",
			"\tfor layer: int in _layers(constants):\n\t\tvar moves: String = \"VM1_MOVE_IDS\" if layer == 342 else \"J%d_MOVE_IDS\" % layer\n\t\tvar prefixes: String = \"VM1_PREFIXES\" if layer == 342 else \"J%d_PREFIXES\" % layer\n\t\tif not (constants[moves] as Dictionary).has(path):"],
		["## The layers a migrated suite holds, newest first, named by their own constants. They are ordered by the\n## DECISION each one puts back, never by its J-number: First-MVP Gameplay J11 is D-344 and so is NEWER than\n## D-342's `VM1`, which a numeric J-key could not express (decision D-344).\nconst LAYER_DECISIONS: Dictionary = {\n\t\"J11_MOVE_IDS\": 344, \"VM1_MOVE_IDS\": 342, \"J10_MOVE_IDS\": 340, \"J9_MOVE_IDS\": 338, \"J8_MOVE_IDS\": 336,\n\t\"J7_MOVE_IDS\": 334, \"J6_MOVE_IDS\": 332, \"J5_MOVE_IDS\": 330, \"J4_MOVE_IDS\": 328,\n}\nfunc _layers(constants: Dictionary) -> Array[String]:\n\tvar found: Array = []\n\tfor key: String in constants:\n\t\tif key.ends_with(\"_MOVE_IDS\") and LAYER_DECISIONS.has(key):\n\t\t\tfound.append([int(LAYER_DECISIONS[key]), key])\n\tfound.sort_custom(func(a: Array, b: Array) -> bool: return int(a[0]) > int(b[0]))\n\tvar names: Array[String] = []\n\tfor entry: Array in found:\n\t\tnames.append(String(entry[1]))\n\treturn names\n",
			"## The layers a migrated suite holds, newest first: 342 for D-342's, then k for each J<k>'s.\nfunc _layers(constants: Dictionary) -> Array[int]:\n\tvar layers: Array[int] = []\n\tfor key: String in constants:\n\t\tif key == \"VM1_MOVE_IDS\":\n\t\t\tlayers.append(342)\n\t\telif key.begins_with(\"J\") and key.ends_with(\"_MOVE_IDS\"):\n\t\t\tlayers.append(int(key.substr(1, key.length() - 10)))\n\tlayers.sort()\n\tlayers.reverse()\n\treturn layers\n"],
		["\"res://tests/pending_fallen_restart_verification.gd\": [\"J4_MOVES\", \"J5_MOVES\", \"J6_MOVES\", \"J7_MOVES\", \"J8_MOVES\", \"J9_MOVES\", \"J10_MOVES\", \"J11_MOVES\"],",
			"\"res://tests/pending_fallen_restart_verification.gd\": [\"J4_MOVES\", \"J5_MOVES\", \"J6_MOVES\", \"J7_MOVES\", \"J8_MOVES\", \"J9_MOVES\", \"J10_MOVES\"],"],
		["if not (text.sha256_text() == String(row[1]) and FileAccess.get_sha256(path) == _now(path) and (text + \"x\").sha256_text() != String(row[1])",
			"if not (text.sha256_text() == String(row[1]) and FileAccess.get_sha256(path) == String(row[1]) and (text + \"x\").sha256_text() != String(row[1])"],
		["\tfor row: Array in MIGRATED:\n\t\tvar path: String = row[0]\n\t\t# First-MVP Gameplay J11 (D-344) moved every one of these again, so D-342's own state is reached\n\t\t# through J11's pairs first; the live file is pinned through `SUITES` beside it.\n\t\tvar text: String = _d343_text(path)\n\t\tvar pairs: Array = engine.pairs_of(loaded, String(row[3]))",
			"\tfor row: Array in MIGRATED:\n\t\tvar path: String = row[0]\n\t\tvar text: String = _text(path)\n\t\tvar pairs: Array = engine.pairs_of(loaded, String(row[3]))"],
		["func _d341_text(path: String) -> String:\n\tvar text: String = _d343_text(path)\n\tfor row: Array in MIGRATED:\n\t\tif String(row[0]) == path:\n\t\t\treturn String(engine.apply(text, engine.pairs_of(loaded, String(row[3])))[\"text\"])\n\treturn text\n\n\n## A suite file's text as D-343 left it: the file as it stands for the two J11 did not move, and with J11's own\n## pairs put back for the eighteen it did (decision D-344).\nfunc _d343_text(path: String) -> String:\n\tif not J11_MOVE_IDS.has(path):\n\t\treturn _text(path)\n\treturn String(engine.apply(_text(path), engine.pairs_of(loaded, String(J11_MOVE_IDS[path])))[\"text\"])\n\n\n## The SHA-256 a suite file holds now, as `SUITES` pins it.\nfunc _now(path: String) -> String:\n\tfor row: Array in SUITES:\n\t\tif String(row[0]) == path:\n\t\t\treturn String(row[1])\n\treturn \"\"\n",
			"func _d341_text(path: String) -> String:\n\tfor row: Array in MIGRATED:\n\t\tif String(row[0]) == path:\n\t\t\treturn String(engine.apply(_text(path), engine.pairs_of(loaded, String(row[3])))[\"text\"])\n\treturn _text(path)\n"],
		["\n## First-MVP Gameplay J11 (decision D-344) moved Gate 1D's slice and eighteen of the twenty accepted suite\n## files again, and recorded its own delta in `d344_gate_1d_route_continuity.provenance`. Every read of an accepted\n## suite's D-342 or D-341 bytes puts J11's pairs back first, by the pair-list name this table holds.\nconst J11_MOVE_IDS: Dictionary = {\n\t\"res://scripts/first_mvp/severed_threshold/broken_watch_slice.gd\": \"f0f7cf747a8cc738a5e9477ea2028e6d863d9d83d3cc6799d39032a0275db868\",\n\t\"res://tests/first_mvp_modal_left_click_verification.gd\": \"e7b62a6207638ff89cd8732cc9bbcfd57503f83f8877662c7a4806a709fdc3c8\",\n\t\"res://tests/fallen_modal_life_state_verification.gd\": \"e7b62a6207638ff89cd8732cc9bbcfd57503f83f8877662c7a4806a709fdc3c8\",\n\t\"res://tests/pending_fallen_restart_verification.gd\": \"eab887b6ceea266bb06554728df7227e3c47fb0338990a0f9e3209f733f9b6c2\",\n\t\"res://tests/pending_fallen_restart_smoke.sh\": \"a7a5214f7f0fd6e1f4d32fc539df430b11312aee42ad845ee135cbdba73cecd2\",\n\t\"res://tests/fallen_delay_item_interaction_verification.gd\": \"7b773bea4b14e0ff94ae58afcf898e9d269834c1c8bd257ad10717becf55fc07\",\n\t\"res://tests/fallen_delay_item_interaction_smoke.sh\": \"a089abfb62d27e1a1f9d8f3e523c12d8da6f930056aba5d3daa0a7a687f5ce2b\",\n\t\"res://tests/fallen_delay_drop_highlight_verification.gd\": \"93e92c6cdfd494daf85285c7abaa06f5229b1bea0e7e4de67d3b6f02f253f182\",\n\t\"res://tests/fallen_delay_drop_highlight_smoke.sh\": \"a0d7525a31de8048a66815277d6eb7c67b76dc6d90bbfe2eccb519057cd525fa\",\n\t\"res://tests/combat_hud_fractional_fill_verification.gd\": \"fd86747b7f850c99c998632fb24898b79daa9dd06b2a9e199331a1162a6e40a6\",\n\t\"res://tests/combat_hud_fractional_fill_smoke.sh\": \"ca348c34762f8640fa88bf6629f35c15aaaa7b9a495972800d4dcd94d4074845\",\n\t\"res://tests/enemy_hover_life_fractional_fill_verification.gd\": \"bf9b61b11d9e56be4dff793b83d133f56bcdcf4ffdd8db0cc2ee5e8de0715d5a\",\n\t\"res://tests/enemy_hover_life_fractional_fill_smoke.sh\": \"abb783d1bb48944f378110a2d21d02ba0f6367ad5958c99b4f6de19cbeb49188\",\n\t\"res://tests/combat_hud_safe_bottom_placement_verification.gd\": \"8cdb1c4ac20a56377ccde3a23dc95da5de60cacb66b1777b88ed3cc2ee0f8f18\",\n\t\"res://tests/combat_hud_safe_bottom_placement_smoke.sh\": \"95680171a31d73eac1122c03ce51baba10096ecc56f80691ff6476e132b58383\",\n\t\"res://tests/guaranteed_drop_defeated_enemy_binding_verification.gd\": \"130d65f893fd3c07d1d6261bf850557fb3d45fb71ca060ff70c65914c90dc5b3\",\n\t\"res://tests/guaranteed_drop_defeated_enemy_binding_smoke.sh\": \"769d2d53f0f88c9fcf5bc50e135e4b8ad73245459e92799fbbd041437fff1b4c\",\n\t\"res://tests/restart_position_stability_verification.gd\": \"05bc9f20bd2e1d051921151955555d334bd6361c712413293bdb582e70d60d6c\",\n\t\"res://tests/restart_position_stability_smoke.sh\": \"8e17e436ffeefd7232f1e9ecd29fdf596cc7fd3d192aeea3d5bf2a3f2a24c082\",\n}\nconst J3_VERIFICATION: String =",
			"const J3_VERIFICATION: String ="],
		["const SUITES: Array = [\n\t[\"res://tests/first_mvp_modal_left_click_verification.gd\", \"d12ad27160a6577b89a7d482364a86e4c662572749e05c47a3f45ac8c429d698\", \"75f2648650da8e9d3a97e205eb97a843b1ed2a4d6b8b04824f46d56d30cd5130\", \"644\"],\n\t[\"res://tests/first_mvp_modal_left_click_smoke.sh\", \"977c05bdcc7a79961a411b5dfa487294c28028866973ca1f2f795d43ef017f54\", \"977c05bdcc7a79961a411b5dfa487294c28028866973ca1f2f795d43ef017f54\", \"755\"],\n\t[\"res://tests/fallen_modal_life_state_verification.gd\", \"72e39a8af345f213ebcddc9866e69ce1a0384ef6efb042e125e7afbce75b6356\", \"935a37e9a13cc47d383bbaf4dab0af90d790dfbb7f87509e0b8b9307f724520c\", \"644\"],\n\t[\"res://tests/fallen_modal_life_state_smoke.sh\", \"9e0977fb279108312082961b25a7b9466917782be095d4eb6d3b02b682967663\", \"9e0977fb279108312082961b25a7b9466917782be095d4eb6d3b02b682967663\", \"755\"],\n\t[\"res://tests/pending_fallen_restart_verification.gd\", \"7d0e3f086f52e86debf0b451a16d3142e89a70e62dd9aaf13ae167c9704e15f6\", \"53c379761fa52afb1b8c28306c04daca87791eccc6416c9d3b536c21a1653fe1\", \"644\"],\n\t[\"res://tests/pending_fallen_restart_smoke.sh\", \"54a4464a7cbe400a205f3d8a5d5b3a1d81ef6b0ef8dcc726558a9de67b0e517e\", \"9a860bca0646e71afa06bbca104d9e16319993babd57100ba3b5b0bcf0cb12d1\", \"755\"],\n\t[\"res://tests/fallen_delay_item_interaction_verification.gd\", \"8aad426265c3040f065b2dc828cb0452cf2be43c496de1827b7faa771dd1f730\", \"5c8e9b07d27177b696d17eb803f1bd2a04582b8c55de4f18eab848be9055e48c\", \"644\"],\n\t[\"res://tests/fallen_delay_item_interaction_smoke.sh\", \"939d9b4815d46b5ba73161f65e630fe75c086d585025e53ebd995628c1d25942\", \"0fd60eb7d1cb15544cf1a17102ab5cec1516e55ef1e0b1556fa2c8fe04485cfc\", \"755\"],\n\t[\"res://tests/fallen_delay_drop_highlight_verification.gd\", \"beb94aa05c3dd99d9874ec8d5f4c5b5cd781054c5334ae60dd3b4b8d557d80cf\", \"dceea6f96d81a8ce3fb0bd5d857cf93addc5d0601f001dc211e7e9873e2d59af\", \"644\"],\n\t[\"res://tests/fallen_delay_drop_highlight_smoke.sh\", \"6f792a386aaefacf714684f041c567eefa7b74720f95da77336c902db7a2880a\", \"b1b456bd4b97f6992d9a873e19250f158835e30934e17581cf19eb81db3b8121\", \"755\"],\n\t[\"res://tests/combat_hud_fractional_fill_verification.gd\", \"8c653002bdc47f0a35497da88756a29622ff398c5d4b510648f2dd7f5bd5a814\", \"f7144aaceb577549ebc4ac28f9cd0bef972b09d4dd3751015701b8631b3f53d9\", \"644\"],\n\t[\"res://tests/combat_hud_fractional_fill_smoke.sh\", \"51d64a23890eb758f71a4e5d66f07590dec1a6f32e37b2a782a030cb0f430d76\", \"6cf22e7dab55e1f90aded60b9edc4f374231d0e517df937fa88876f3bd83be95\", \"755\"],\n\t[\"res://tests/enemy_hover_life_fractional_fill_verification.gd\", \"bf92c1ecfa8dd995a6e6c42c531487511deffb53473edb116cf5b066ef14afb1\", \"0b816f062982c7b9009820aac3b7a2533a41c0c9723d473c9eb2f96a87cd0e9a\", \"644\"],\n\t[\"res://tests/enemy_hover_life_fractional_fill_smoke.sh\", \"64a84a9d9d0c6ea3d32b0343e0af77329093be57ee0b79dddb2015e1a43d766a\", \"0dbde2d8d5d82c7a4bcc759495f8beebda4b3e4b48323a4cffc073cd0cae0f70\", \"755\"],\n\t[\"res://tests/combat_hud_safe_bottom_placement_verification.gd\", \"2ca7555313e5ee462a2fbc2738a478cf58161580adaba1b67015efa4c6fafd0b\", \"b709813c49907eb160dcdcc6c20eca8750106e59d64f2f5158c2cd35d5e80cbd\", \"644\"],\n\t[\"res://tests/combat_hud_safe_bottom_placement_smoke.sh\", \"f562e165d90170679e5bf35e0c0ce65b92d51d759d14359ed2dd1a507500abde\", \"900c8d9e13a5bf172293ea8c3657c67136a8c4172d8f7f483bdbbee1ba8ff6b4\", \"755\"],\n\t[\"res://tests/guaranteed_drop_defeated_enemy_binding_verification.gd\", \"aaa9e1d332a2e297b77c6256801eceb982d5fb7511423e1ea0c9c0639728ea37\", \"ae964685880aad6bc00894c04e1e90f997a6167c75a603a3cf6ef87c450f05aa\", \"644\"],\n\t[\"res://tests/guaranteed_drop_defeated_enemy_binding_smoke.sh\", \"94b5e6c914aabcd1959694d8cd0b2a8e80ef22088f46c44e8b85687a393bd19b\", \"1f2a43b1ae097d63bc6ffd0ad4fb6e183329ce2d4c6017f4c77300e1304aa426\", \"755\"],\n\t[\"res://tests/restart_position_stability_verification.gd\", \"1588cff8b91e3c3a4bc1f23180968e9981aebda279691256dcd947e4985136d0\", \"51108a47c4c0b120e3909e5a804266bd0234cd2fe0788a87ab9406c43c6ed5bc\", \"644\"],\n\t[\"res://tests/restart_position_stability_smoke.sh\", \"34db74ce3fa60f0be7e33e460a30219188b267294c49feb3ad25864d5238c3f2\", \"20b7a56294345a3c49dd98dfa47283e0c278d623d51ba21cd6ed0b3f8711dcd6\", \"755\"],\n]\n",
			"const SUITES: Array = [\n\t[\"res://tests/first_mvp_modal_left_click_verification.gd\", \"75f2648650da8e9d3a97e205eb97a843b1ed2a4d6b8b04824f46d56d30cd5130\", \"75f2648650da8e9d3a97e205eb97a843b1ed2a4d6b8b04824f46d56d30cd5130\", \"644\"],\n\t[\"res://tests/first_mvp_modal_left_click_smoke.sh\", \"977c05bdcc7a79961a411b5dfa487294c28028866973ca1f2f795d43ef017f54\", \"977c05bdcc7a79961a411b5dfa487294c28028866973ca1f2f795d43ef017f54\", \"755\"],\n\t[\"res://tests/fallen_modal_life_state_verification.gd\", \"935a37e9a13cc47d383bbaf4dab0af90d790dfbb7f87509e0b8b9307f724520c\", \"935a37e9a13cc47d383bbaf4dab0af90d790dfbb7f87509e0b8b9307f724520c\", \"644\"],\n\t[\"res://tests/fallen_modal_life_state_smoke.sh\", \"9e0977fb279108312082961b25a7b9466917782be095d4eb6d3b02b682967663\", \"9e0977fb279108312082961b25a7b9466917782be095d4eb6d3b02b682967663\", \"755\"],\n\t[\"res://tests/pending_fallen_restart_verification.gd\", \"53c379761fa52afb1b8c28306c04daca87791eccc6416c9d3b536c21a1653fe1\", \"53c379761fa52afb1b8c28306c04daca87791eccc6416c9d3b536c21a1653fe1\", \"644\"],\n\t[\"res://tests/pending_fallen_restart_smoke.sh\", \"9a860bca0646e71afa06bbca104d9e16319993babd57100ba3b5b0bcf0cb12d1\", \"9a860bca0646e71afa06bbca104d9e16319993babd57100ba3b5b0bcf0cb12d1\", \"755\"],\n\t[\"res://tests/fallen_delay_item_interaction_verification.gd\", \"15352d8a50b10ad98768d76c3c1dd68acad57753cb5900fc72d77b2c83517291\", \"5c8e9b07d27177b696d17eb803f1bd2a04582b8c55de4f18eab848be9055e48c\", \"644\"],\n\t[\"res://tests/fallen_delay_item_interaction_smoke.sh\", \"0fd60eb7d1cb15544cf1a17102ab5cec1516e55ef1e0b1556fa2c8fe04485cfc\", \"0fd60eb7d1cb15544cf1a17102ab5cec1516e55ef1e0b1556fa2c8fe04485cfc\", \"755\"],\n\t[\"res://tests/fallen_delay_drop_highlight_verification.gd\", \"6204a260e42a042a5407e5b13d8bb105a8899df286b4fddff043ac35710722b8\", \"dceea6f96d81a8ce3fb0bd5d857cf93addc5d0601f001dc211e7e9873e2d59af\", \"644\"],\n\t[\"res://tests/fallen_delay_drop_highlight_smoke.sh\", \"08aa2d0b359a9a350a4b2b07dda138200f57faea5a5ef60c60a5849f66e1ded8\", \"b1b456bd4b97f6992d9a873e19250f158835e30934e17581cf19eb81db3b8121\", \"755\"],\n\t[\"res://tests/combat_hud_fractional_fill_verification.gd\", \"d23c5fdc1b708c7c87e48b430ead753cdc5c08875983bf7cfab4db898b1797bf\", \"f7144aaceb577549ebc4ac28f9cd0bef972b09d4dd3751015701b8631b3f53d9\", \"644\"],\n\t[\"res://tests/combat_hud_fractional_fill_smoke.sh\", \"be9f6f47ceb3e79d9b784fe1e8766639cec351add0c52c99e2f4a3a9686b0144\", \"6cf22e7dab55e1f90aded60b9edc4f374231d0e517df937fa88876f3bd83be95\", \"755\"],\n\t[\"res://tests/enemy_hover_life_fractional_fill_verification.gd\", \"09e25736956a9f750331a44f6f973344a7fe59cdcb7bf1e9265e6fc635a197e6\", \"0b816f062982c7b9009820aac3b7a2533a41c0c9723d473c9eb2f96a87cd0e9a\", \"644\"],\n\t[\"res://tests/enemy_hover_life_fractional_fill_smoke.sh\", \"85a49a224612711fd9e7964449538afc19f3eda586f9d106f70a3c81e18b6333\", \"0dbde2d8d5d82c7a4bcc759495f8beebda4b3e4b48323a4cffc073cd0cae0f70\", \"755\"],\n\t[\"res://tests/combat_hud_safe_bottom_placement_verification.gd\", \"bfab962cb08b9466b33cdfc9de3802e4cbc224a3f1eb3a865c7cc2c63d0d5e3f\", \"b709813c49907eb160dcdcc6c20eca8750106e59d64f2f5158c2cd35d5e80cbd\", \"644\"],\n\t[\"res://tests/combat_hud_safe_bottom_placement_smoke.sh\", \"95506b40c3274ced5143436e468205cd3fb6326bf2a029f2581f6e867fa34fe7\", \"900c8d9e13a5bf172293ea8c3657c67136a8c4172d8f7f483bdbbee1ba8ff6b4\", \"755\"],\n\t[\"res://tests/guaranteed_drop_defeated_enemy_binding_verification.gd\", \"e526397bf360dab81887bb63936be6827fe8a2823258d3eec83bad7c89d70248\", \"ae964685880aad6bc00894c04e1e90f997a6167c75a603a3cf6ef87c450f05aa\", \"644\"],\n\t[\"res://tests/guaranteed_drop_defeated_enemy_binding_smoke.sh\", \"2254440306d58e20079532cd3577e9df48bc2e3bb0d4831a332f91ef64deae20\", \"1f2a43b1ae097d63bc6ffd0ad4fb6e183329ce2d4c6017f4c77300e1304aa426\", \"755\"],\n\t[\"res://tests/restart_position_stability_verification.gd\", \"bf25715a79af9f3ec30d6988b9d477a38a79cc6e0f61de10fd9d0c7e167c5a7e\", \"51108a47c4c0b120e3909e5a804266bd0234cd2fe0788a87ab9406c43c6ed5bc\", \"644\"],\n\t[\"res://tests/restart_position_stability_smoke.sh\", \"02f03162742af697c56cb76aefd0f9262bac26c92e6a479a5d618c8b55967681\", \"20b7a56294345a3c49dd98dfa47283e0c278d623d51ba21cd6ed0b3f8711dcd6\", \"755\"],\n]\n"],
		["const EXPECTED_STATES: int = 132\n",
			"const EXPECTED_STATES: int = 113\n"],
		["const EXPECTED_EDGES: int = 165\n",
			"const EXPECTED_EDGES: int = 146\n"],
		["const EXPECTED_PAIR_LISTS: int = 104\n",
			"const EXPECTED_PAIR_LISTS: int = 86\n"],
		["const EXPECTED_TEXTS: int = 737\n",
			"const EXPECTED_TEXTS: int = 582\n"],
		["\t[\"d342_accepted_suite_history.provenance\", \"3b38ca4d6576dcafd8267650fefb9acfe4ea5ecc5aae712b1c7105e120ff3c3c\", 412215],\n\t## First-MVP Gameplay J11 (decision D-344) added its own file beside it, under D-343 ruling 4. The older\n\t## file is not rewritten: this one carries J11's delta alone, with no reference segment of any kind.\n\t[\"d344_gate_1d_route_continuity.provenance\", \"0ab807ed2ffb6e925039f0eeb40d3a5ba8003a62f6971d3125f21984b00e7007\", 83610],\n",
			"\t[\"d342_accepted_suite_history.provenance\", \"3b38ca4d6576dcafd8267650fefb9acfe4ea5ecc5aae712b1c7105e120ff3c3c\", 412215],\n"],
	]],
	["res://tests/non_nesting_accepted_suite_reconstruction_smoke.sh", "64daa9bf", "7b9796615bb726d57bb128bd98f2f5193d0e7939e6398c5e43889a276947f11f", [
		["# First-MVP Gameplay J11 (D-344) moved this runner's rows again, one for one, when Gate 1D's slice came to open Riftfall Landing's Watch Breach far cap in its own composition.\nD342_ROWS=(",
			"D342_ROWS=("],
		["the moved suite files grow by 17711 bytes in all, 3828 at most (restart_position_stability_verification.gd); no earlier text, pair list or suite body is escaped into any of it\n",
			"the moved suite files grow by 17495 bytes in all, 3612 at most (restart_position_stability_verification.gd); no earlier text, pair list or suite body is escaped into any of it\n"],
		["the new store file: 41140 bytes, 37 texts, 18 pair lists, 19 edges — every text one literal segment, 0 references, and no existing record rewritten\n",
			"the new store file: 43870 bytes, 63 texts, 18 pair lists, 19 edges — every text one literal segment, 0 references, and no existing record rewritten\n"],
		["the 10 verifications keep every owed-check list and their 259 _expect calls, as at D-341; 54 functional or measured line(s) moved in all, every one inside a pair D-344 records\n",
			"the 10 verifications keep every _expect, _done, print and quit line and every owed-check list, byte for byte: 259 _expect calls in all, as at D-341\n"],
		["6 production-walk lines across the accepted runners are exactly D-341's; every EXPECTED_PRODUCTION line is D-341's or moved inside a pair D-344 records\n",
			"6 production-walk lines across the accepted runners, and every EXPECTED_PRODUCTION line, are exactly D-341's\n"],
		["the longest line in any accepted suite file is 3015 characters; at D-341 it was 1335201\n",
			"the longest line in any accepted suite file is 1531 characters; at D-341 it was 1335201\n"],
		["pair text is still held inline only by J3's own seven layers — edits to the slice, J1 and J2, which hold no pair text themselves — and by six suites' own production pairs: 74 strings, 12951 bytes, none of them nesting a stored text or pair list\n",
			"pair text is still held inline only by J3's own seven layers — edits to the slice, J1 and J2, which hold no pair text themselves — and by six suites' own production pairs: 70 strings, 9407 bytes, none of them nesting a stored text or pair list\n"],
		["history: restart_position_stability_verification.gd: now 1588cff8, D-344 put back bf25715a, D-342 put back 51108a47\n",
			"history: restart_position_stability_verification.gd: now bf25715a, D-342 put back 51108a47\n"],
		["history: restart_position_stability_smoke.sh: now 34db74ce, D-344 put back 02f03162, D-342 put back 20b7a562\n",
			"history: restart_position_stability_smoke.sh: now 02f03162, D-342 put back 20b7a562\n"],
		["history: pending_fallen_restart_verification.gd: now 7d0e3f08, D-344 put back 53c37976, D-340 put back dc9be60f, D-338 put back 1062c1db, D-336 put back 520d9543, D-334 put back 68a1227e, D-332 put back b2cfc253, D-330 put back 565a0a4f, D-328 put back 51c8560c\n",
			"history: pending_fallen_restart_verification.gd: now 53c37976, D-340 put back dc9be60f, D-338 put back 1062c1db, D-336 put back 520d9543, D-334 put back 68a1227e, D-332 put back b2cfc253, D-330 put back 565a0a4f, D-328 put back 51c8560c\n"],
		["history: pending_fallen_restart_smoke.sh: now 54a4464a, D-344 put back 9a860bca, D-340 put back ec5bc37f, D-338 put back 689284cc, D-336 put back 67cf7ba9, D-334 put back f7b48202, D-332 put back 6e4120a3, D-330 put back 5c45961b, D-328 put back 1789de06\n",
			"history: pending_fallen_restart_smoke.sh: now 9a860bca, D-340 put back ec5bc37f, D-338 put back 689284cc, D-336 put back 67cf7ba9, D-334 put back f7b48202, D-332 put back 6e4120a3, D-330 put back 5c45961b, D-328 put back 1789de06\n"],
		["history: guaranteed_drop_defeated_enemy_binding_verification.gd: now aaa9e1d3, D-344 put back e526397b, D-342 put back ae964685, D-340 put back 368f584e\n",
			"history: guaranteed_drop_defeated_enemy_binding_verification.gd: now e526397b, D-342 put back ae964685, D-340 put back 368f584e\n"],
		["history: guaranteed_drop_defeated_enemy_binding_smoke.sh: now 94b5e6c9, D-344 put back 22544403, D-342 put back 1f2a43b1, D-340 put back 56258899\n",
			"history: guaranteed_drop_defeated_enemy_binding_smoke.sh: now 22544403, D-342 put back 1f2a43b1, D-340 put back 56258899\n"],
		["history: first_mvp_modal_left_click_verification.gd: now d12ad271, D-344 put back 75f26486, D-340 put back acbd3892, D-338 put back 8c0e290c, D-330 put back c6fe40f1, D-328 put back 2f5a32ca\n",
			"history: first_mvp_modal_left_click_verification.gd: now 75f26486, D-340 put back acbd3892, D-338 put back 8c0e290c, D-330 put back c6fe40f1, D-328 put back 2f5a32ca\n"],
		["history: fallen_modal_life_state_verification.gd: now 72e39a8a, D-344 put back 935a37e9, D-340 put back 6acc1e0c, D-338 put back d5407c7c, D-336 put back eb7f4153, D-334 put back f065a48d, D-332 put back ca594f7d, D-330 put back a3f97de5, D-328 put back b04b0a1e\n",
			"history: fallen_modal_life_state_verification.gd: now 935a37e9, D-340 put back 6acc1e0c, D-338 put back d5407c7c, D-336 put back eb7f4153, D-334 put back f065a48d, D-332 put back ca594f7d, D-330 put back a3f97de5, D-328 put back b04b0a1e\n"],
		["history: fallen_delay_item_interaction_verification.gd: now 8aad4262, D-344 put back 15352d8a, D-342 put back 5c8e9b07, D-340 put back eff592af, D-338 put back 3deeb26a, D-336 put back 611891a3, D-334 put back 308fe51a, D-332 put back 7ad7dd67, D-330 put back 409b540d\n",
			"history: fallen_delay_item_interaction_verification.gd: now 15352d8a, D-342 put back 5c8e9b07, D-340 put back eff592af, D-338 put back 3deeb26a, D-336 put back 611891a3, D-334 put back 308fe51a, D-332 put back 7ad7dd67, D-330 put back 409b540d\n"],
		["history: fallen_delay_item_interaction_smoke.sh: now 939d9b48, D-344 put back 0fd60eb7, D-340 put back e14e996b, D-338 put back cb520369, D-336 put back d7cf4498, D-334 put back b7ff3d66, D-332 put back ffbb4b7b, D-330 put back 8b55c045\n",
			"history: fallen_delay_item_interaction_smoke.sh: now 0fd60eb7, D-340 put back e14e996b, D-338 put back cb520369, D-336 put back d7cf4498, D-334 put back b7ff3d66, D-332 put back ffbb4b7b, D-330 put back 8b55c045\n"],
		["history: fallen_delay_drop_highlight_verification.gd: now beb94aa0, D-344 put back 6204a260, D-342 put back dceea6f9, D-340 put back b735e6c7, D-338 put back c9648eea, D-336 put back 44ed4bdf, D-334 put back 733d4af8, D-332 put back d782328a\n",
			"history: fallen_delay_drop_highlight_verification.gd: now 6204a260, D-342 put back dceea6f9, D-340 put back b735e6c7, D-338 put back c9648eea, D-336 put back 44ed4bdf, D-334 put back 733d4af8, D-332 put back d782328a\n"],
		["history: fallen_delay_drop_highlight_smoke.sh: now 6f792a38, D-344 put back 08aa2d0b, D-342 put back b1b456bd, D-340 put back fea9988e, D-338 put back d2772373, D-336 put back aeba508d, D-334 put back f5451331, D-332 put back 36583a6d\n",
			"history: fallen_delay_drop_highlight_smoke.sh: now 08aa2d0b, D-342 put back b1b456bd, D-340 put back fea9988e, D-338 put back d2772373, D-336 put back aeba508d, D-334 put back f5451331, D-332 put back 36583a6d\n"],
		["history: enemy_hover_life_fractional_fill_verification.gd: now bf92c1ec, D-344 put back 09e25736, D-342 put back 0b816f06, D-340 put back 2187ccb1, D-338 put back fde101de, D-336 put back 5063a690\n",
			"history: enemy_hover_life_fractional_fill_verification.gd: now 09e25736, D-342 put back 0b816f06, D-340 put back 2187ccb1, D-338 put back fde101de, D-336 put back 5063a690\n"],
		["history: enemy_hover_life_fractional_fill_smoke.sh: now 64a84a9d, D-344 put back 85a49a22, D-342 put back 0dbde2d8, D-340 put back 22a95042, D-338 put back 5aa1ec83, D-336 put back ab84b56b\n",
			"history: enemy_hover_life_fractional_fill_smoke.sh: now 85a49a22, D-342 put back 0dbde2d8, D-340 put back 22a95042, D-338 put back 5aa1ec83, D-336 put back ab84b56b\n"],
		["history: combat_hud_safe_bottom_placement_verification.gd: now 2ca75553, D-344 put back bfab962c, D-342 put back b709813c, D-340 put back c980d240, D-338 put back 117ab87b\n",
			"history: combat_hud_safe_bottom_placement_verification.gd: now bfab962c, D-342 put back b709813c, D-340 put back c980d240, D-338 put back 117ab87b\n"],
		["history: combat_hud_safe_bottom_placement_smoke.sh: now f562e165, D-344 put back 95506b40, D-342 put back 900c8d9e, D-340 put back 8c13aa43, D-338 put back cc7e665a\n",
			"history: combat_hud_safe_bottom_placement_smoke.sh: now 95506b40, D-342 put back 900c8d9e, D-340 put back 8c13aa43, D-338 put back cc7e665a\n"],
		["history: combat_hud_fractional_fill_verification.gd: now 8c653002, D-344 put back d23c5fdc, D-342 put back f7144aac, D-340 put back d38624c8, D-338 put back 333c1674, D-336 put back 423858a2, D-334 put back c5a873fd\n",
			"history: combat_hud_fractional_fill_verification.gd: now d23c5fdc, D-342 put back f7144aac, D-340 put back d38624c8, D-338 put back 333c1674, D-336 put back 423858a2, D-334 put back c5a873fd\n"],
		["history: combat_hud_fractional_fill_smoke.sh: now 51d64a23, D-344 put back be9f6f47, D-342 put back 6cf22e7d, D-340 put back a444af4b, D-338 put back a5744db6, D-336 put back 1c2f1d12, D-334 put back d69585af\n",
			"history: combat_hud_fractional_fill_smoke.sh: now be9f6f47, D-342 put back 6cf22e7d, D-340 put back a444af4b, D-338 put back a5744db6, D-336 put back 1c2f1d12, D-334 put back d69585af\n"],
		["history: broken_watch_slice.gd: now d4e839fb, D-344 put back 883ef25e, D-340 put back 942aee83, D-338 put back f83e9436, D-330 put back c204a087\n",
			"history: broken_watch_slice.gd: now 883ef25e, D-340 put back 942aee83, D-338 put back f83e9436, D-330 put back c204a087\n"],
		["all 165 edges hold from the live files: every one of the 132 stored states rebuilds, byte for byte, from the file as it stands\n",
			"all 146 edges hold from the live files: every one of the 113 stored states rebuilds, byte for byte, from the file as it stands\n"],
		["every one of the 104 stored pair lists is pinned, and every stored text belongs to a pair list or a reference: nothing in the store is unaccounted for\n",
			"every one of the 86 stored pair lists is pinned, and every stored text belongs to a pair list or a reference: nothing in the store is unaccounted for\n"],
		["the migrated verifications pin 334 pair lists by SHA-256 (102 distinct), each stored and applied by an edge to the very file it names; the other 2 are D-342's put-backs for J10's verification and runner, which no accepted suite reads and this suite pins\n",
			"the migrated verifications pin 263 pair lists by SHA-256 (84 distinct), each stored and applied by an edge to the very file it names; the other 2 are D-342's put-backs for J10's verification and runner, which no accepted suite reads and this suite pins\n"],
		["the version graph is acyclic: 132 file states over 22 files, the longest chain 8 steps, every step putting back an older decision than the one before it\n",
			"the version graph is acyclic: 113 file states over 22 files, the longest chain 7 steps, every step putting back an older decision than the one before it\n"],
		["parsed and re-serialised, each of the 2 store file(s) is its own bytes: the format is canonical\n",
			"parsed and re-serialised, each of the 1 store file(s) is its own bytes: the format is canonical\n"],
		["737 texts, 104 pair lists and 165 edges, every one hashing to its name; 281951 literal bytes, 381 whole pair lists written as one `%` line each and 13 texts as one `&` line each\n",
			"582 texts, 86 pair lists and 146 edges, every one hashing to its name; 238917 literal bytes, 381 whole pair lists written as one `%` line each and 13 texts as one `&` line each\n"],
		["res://tests/provenance/ holds exactly the engine and 2 store file(s) (.DS_Store pruned), and no directory\n",
			"res://tests/provenance/ holds exactly the engine and 1 store file(s) (.DS_Store pruned), and no directory\n"],
		["the engine is at fadbdfeb, 20280 bytes; 2 store file(s): d342_accepted_suite_history.provenance at 3b38ca4d, 412215 bytes, d344_gate_1d_route_continuity.provenance at 0ab807ed, 83610 bytes\n",
			"the engine is at fadbdfeb, 20280 bytes; 1 store file(s): d342_accepted_suite_history.provenance at 3b38ca4d, 412215 bytes\n"],
		["EXPECTED_PRODUCTION_DIGEST=\"770fc7a255dc75f94a45026d749cfdccc2f072aac50ab8ec4b3c48255e0de42d\"\n",
			"EXPECTED_PRODUCTION_DIGEST=\"603c23af1f7d087e56cc1548611638e667b75392b5b8148573b885b61e9833c1\"\n"],
		["if [[ \"$stored\" == \"./$(basename \"$ENGINE\") ./$(basename \"$STORE\") ./$(basename \"$STORE_J11\")\" ]]; then\n\tpass \"$PROVENANCE_DIR/ holds exactly the engine and the two store files (.DS_Store pruned)\"\n",
			"if [[ \"$stored\" == \"./$(basename \"$ENGINE\") ./$(basename \"$STORE\")\" ]]; then\n\tpass \"$PROVENANCE_DIR/ holds exactly the engine and the one store file (.DS_Store pruned)\"\n"],
		["\t\"$THIS_VERIFICATION|03c174ad\"\n",
			"\t\"$THIS_VERIFICATION|a9844935\"\n"],
		["\t\"$J10_SMOKE|34db74ce\"\n",
			"\t\"$J10_SMOKE|02f03162\"\n"],
		["\t\"$J10_VERIFICATION|1588cff8\"\n",
			"\t\"$J10_VERIFICATION|bf25715a\"\n"],
		["\t\"$J9_SMOKE|94b5e6c9\"\n",
			"\t\"$J9_SMOKE|22544403\"\n"],
		["\t\"$J9_VERIFICATION|aaa9e1d3\"\n",
			"\t\"$J9_VERIFICATION|e526397b\"\n"],
		["\t\"$J8_SMOKE|f562e165\"\n",
			"\t\"$J8_SMOKE|95506b40\"\n"],
		["\t\"$J8_VERIFICATION|2ca75553\"\n",
			"\t\"$J8_VERIFICATION|bfab962c\"\n"],
		["\t\"$J7_SMOKE|64a84a9d\"\n",
			"\t\"$J7_SMOKE|85a49a22\"\n"],
		["\t\"$J7_VERIFICATION|bf92c1ec\"\n",
			"\t\"$J7_VERIFICATION|09e25736\"\n"],
		["\t\"$J6_SMOKE|51d64a23\"\n",
			"\t\"$J6_SMOKE|be9f6f47\"\n"],
		["\t\"$J6_VERIFICATION|8c653002\"\n",
			"\t\"$J6_VERIFICATION|d23c5fdc\"\n"],
		["\t\"$J5_SMOKE|6f792a38\"\n",
			"\t\"$J5_SMOKE|08aa2d0b\"\n"],
		["\t\"$J5_VERIFICATION|beb94aa0\"\n",
			"\t\"$J5_VERIFICATION|6204a260\"\n"],
		["\t\"$J4_SMOKE|939d9b48\"\n",
			"\t\"$J4_SMOKE|0fd60eb7\"\n"],
		["\t\"$J4_VERIFICATION|8aad4262\"\n",
			"\t\"$J4_VERIFICATION|15352d8a\"\n"],
		["\t\"$J3_SMOKE|54a4464a\"\n",
			"\t\"$J3_SMOKE|9a860bca\"\n"],
		["\t\"$J3_VERIFICATION|7d0e3f08\"\n",
			"\t\"$J3_VERIFICATION|53c37976\"\n"],
		["\t\"$J2_VERIFICATION|72e39a8a\"\n",
			"\t\"$J2_VERIFICATION|935a37e9\"\n"],
		["\t\"$J1_VERIFICATION|d12ad271\"\n",
			"\t\"$J1_VERIFICATION|75f26486\"\n"],
		["\t\"$STORE\"\n\t\"$STORE_J11\"\n",
			"\t\"$STORE\"\n"],
		["\t\"$STORE|3b38ca4d\"\n\t\"$STORE_J11|0ab807ed\"\n",
			"\t\"$STORE|3b38ca4d\"\n"],
		["STORE=\"tests/provenance/d342_accepted_suite_history.provenance\"\n# First-MVP Gameplay J11 (decision D-344) added a second, immutable store file beside the first.\nSTORE_J11=\"tests/provenance/d344_gate_1d_route_continuity.provenance\"\n",
			"STORE=\"tests/provenance/d342_accepted_suite_history.provenance\"\n"],
	]],
]

const OWED_CHECKS: Array[String] = [
	"the_production_diff_is_exactly_the_composition_local_cap_opening",
	"the_slice_declares_nothing_new_and_only_ready_differs_from_d343",
	"the_accepted_suites_moved_only_their_pins_and_read_back_layers",
	"the_d342_store_is_untouched_and_the_d344_store_is_flat_and_content_addressed",
	"the_provenance_records_refuse_mutation_omission_duplication_reordering_and_wrong_targets",
	"the_reach_is_gate_1d_and_gate_1e_by_structure_and_not_the_roguelite",
	"exactly_one_landing_boundary_mass_qualifies_and_only_its_three_nodes_are_removed",
	"the_opening_precedes_the_bake_and_one_continuous_map_is_baked",
	"the_seam_is_navigable_through_the_former_cap_footprint_on_both_faces",
	"the_path_continues_to_the_entry_and_to_the_first_encounter_area",
	"a_real_player_body_walks_the_seam_under_ordinary_movement",
	"j10s_entry_socket_and_restart_stability_are_unchanged",
	"j9s_binding_the_drop_latch_and_the_encounter_reset_are_unchanged",
	"the_standalone_landing_keeps_its_far_cap_its_boundary_list_and_its_sockets",
]

var arguments: PackedStringArray = PackedStringArray()
var slice: BrokenWatchSlice

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _staged: PackedStringArray = PackedStringArray()
var _token: String = ""

var _engine: Variant = null
var _loaded: Dictionary = {}
var _nodes: Dictionary = {}
var _seam: Dictionary = {}
var _walked: Dictionary = {}
var _stick: Dictionary = {}
var _j10: Dictionary = {}
var _j9: Dictionary = {}
var _standalone: Dictionary = {}
var _drops_created: int = 0
var _bake_order: Array[String] = []


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	_token = _argument_value("--run-token")
	print("")
	print("=== First-MVP Gameplay J11 — Gate 1D Landing-to-Broken-Watch Route Continuity V1 verification (D-344) ===")
	print("  run token: %s" % (_token if not _token.is_empty() else "none given"))
	if FileAccess.get_sha256(PROVENANCE_ENGINE) == PROVENANCE_ENGINE_SHA256:
		_engine = load(PROVENANCE_ENGINE)
		_loaded = _engine.parse(_engine.read_directory(STORE_DIRECTORY))

	_check_the_production_diff_is_exactly_the_composition_local_cap_opening()
	_check_the_slice_declares_nothing_new_and_only_ready_differs_from_d343()
	_check_the_accepted_suites_moved_only_their_pins_and_read_back_layers()
	_check_the_d342_store_is_untouched_and_the_d344_store_is_flat_and_content_addressed()
	_check_the_provenance_records_refuse_mutation_omission_duplication_reordering_and_wrong_targets()
	_check_the_reach_is_gate_1d_and_gate_1e_by_structure_and_not_the_roguelite()

	await _play_the_slice()
	if slice != null:
		_check_exactly_one_landing_boundary_mass_qualifies_and_only_its_three_nodes_are_removed()
		_check_the_opening_precedes_the_bake_and_one_continuous_map_is_baked()
		_check_the_seam_is_navigable_through_the_former_cap_footprint_on_both_faces()
		_check_the_path_continues_to_the_entry_and_to_the_first_encounter_area()
		_check_a_real_player_body_walks_the_seam_under_ordinary_movement()
		_check_j10s_entry_socket_and_restart_stability_are_unchanged()
		_check_j9s_binding_the_drop_latch_and_the_encounter_reset_are_unchanged()

	await _play_the_standalone_landing()
	if not _standalone.is_empty():
		_check_the_standalone_landing_keeps_its_far_cap_its_boundary_list_and_its_sockets()

	_check_every_check_ran()
	await process_frame
	print("")
	print("  staged: %s" % "; ".join(_staged))
	if _failures.is_empty():
		print("LANDING TO BROKEN WATCH ROUTE CONTINUITY VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("LANDING TO BROKEN WATCH ROUTE CONTINUITY VERIFICATION: %d FAILURE(S) of %d checks"
			% [_failures.size(), _checks])
		quit(1)


# --- 1–6. Structure: the one production file, the cascade, the store, the reach ------------------

func _check_the_production_diff_is_exactly_the_composition_local_cap_opening() -> void:
	print("")
	print("--- 1. Exactly one production file moved — Gate 1D's slice — and it is the D-343 file plus one composition-local opening")
	var source: String = FileAccess.get_file_as_string(SLICE_SCRIPT)
	var rebuilt: String = source.replace(J11_OPENING, "")
	var landing: String = FileAccess.get_sha256(LANDING_SCRIPT)
	var layout: String = FileAccess.get_sha256(LAYOUT_SCRIPT)
	_expect(FileAccess.get_sha256(SLICE_SCRIPT).begins_with(J11_SLICE_PREFIX)
			and source.count(J11_OPENING) == 1 and rebuilt.sha256_text() == PRE_J11_SLICE_SHA256
			and (rebuilt + "x").sha256_text() != PRE_J11_SLICE_SHA256
			and source.count("\n") == rebuilt.count("\n") + 43,
		"the slice hashes %s, not %s; the opening occurs %d time(s); put back it hashes %s, not the D-343 %s"
			% [FileAccess.get_sha256(SLICE_SCRIPT).left(8), J11_SLICE_PREFIX, source.count(J11_OPENING),
				rebuilt.sha256_text().left(8), PRE_J11_SLICE_SHA256.left(8)])
	_expect(landing == LANDING_SHA256 and layout == LAYOUT_SHA256,
		"Riftfall Landing's greybox layout is %s (want %s) and Broken Watch's layout %s (want %s)"
			% [landing.left(8), LANDING_SHA256.left(8), layout.left(8), LAYOUT_SHA256.left(8)])
	var moved: PackedStringArray = PackedStringArray()
	for row: Array in UNCHANGED_HASHES:
		var held: String = FileAccess.get_sha256(String(row[0]))
		if not held.begins_with(String(row[1])):
			moved.append("%s %s" % [String(row[0]).get_file(), held.left(8)])
	_expect(moved.is_empty() and UNCHANGED_HASHES.size() == 16, "moved: %s" % ", ".join(moved))
	print("  the slice is at its J11 hash %s, %d lines; with J11's %d-line opening put back it is, byte for byte, the D-343 file %s, %d lines"
		% [FileAccess.get_sha256(SLICE_SCRIPT).left(8), source.count("\n"), 43, PRE_J11_SLICE_SHA256.left(8), rebuilt.count("\n")])
	print("  `riftfall_landing_greybox_layout.gd` is untouched at %s and `broken_watch_layout.gd` at %s — the cap is NOT deleted from the Landing, and J10's socket did not move"
		% [landing.left(8), layout.left(8)])
	print("  %d file(s) J11 stands beside hold the hashes they held before the first J11 edit" % UNCHANGED_HASHES.size())
	_done("the_production_diff_is_exactly_the_composition_local_cap_opening")


func _check_the_slice_declares_nothing_new_and_only_ready_differs_from_d343() -> void:
	print("")
	print("--- 2. No slice field, export, function, constant, signal or enum was added; only _ready() differs from D-343, and the opening runs before the bake")
	var source: String = FileAccess.get_file_as_string(SLICE_SCRIPT)
	var before: String = source.replace(J11_OPENING, "")
	var fields: int = RegEx.create_from_string("(?m)^var ").search_all(source).size()
	var exports: int = RegEx.create_from_string("(?m)^@export var ").search_all(source).size()
	var constants: int = RegEx.create_from_string("(?m)^const ").search_all(source).size()
	var signals: int = RegEx.create_from_string("(?m)^signal ").search_all(source).size()
	var enums: int = RegEx.create_from_string("(?m)^enum ").search_all(source).size()
	var functions: PackedStringArray = _declared_functions(source)
	var differing: PackedStringArray = PackedStringArray()
	for name: String in functions:
		if _function_body(source, name) != _function_body(before, name):
			differing.append(name)
	var body: PackedStringArray = _code_lines(_function_body(source, "_ready"))
	var opened_at: int = body.find("var landing_caps: Array[Rect2] = []")
	var configured_at: int = body.find("_configure_navigation()")
	var baked_at: int = body.find("bake_navigation()")
	var resolved_at: int = body.find("landing_layout = $Composition/NavigationRegion3D/Landing")
	_expect(fields == SLICE_FIELDS and exports == SLICE_EXPORTS and constants == SLICE_CONSTANTS
			and functions.size() == SLICE_FUNCTIONS and signals == 0 and enums == 0
			and functions == _declared_functions(before) and differing == PackedStringArray(["_ready"]),
		"%d fields, %d exports, %d functions, %d constants, %d signals, %d enums; bodies differing: %s"
			% [fields, exports, functions.size(), constants, signals, enums, str(differing)])
	_expect(resolved_at >= 0 and opened_at > resolved_at and configured_at > opened_at and baked_at == configured_at + 1,
		"in _ready(): the Landing is resolved at %d, the opening begins at %d, _configure_navigation() at %d and bake_navigation() at %d"
			% [resolved_at, opened_at, configured_at, baked_at])
	_expect(source.count("RiftfallLandingGreyboxLayout.BOUNDARY_MASSES") == 1
			and source.count("BrokenWatchLayout.WALKABLE") == 1 and source.count("push_error(cap_fault)") == 1
			and source.count("assert(landing_caps.size() == 1 and cap_nodes_removed == 3, cap_fault)") == 1
			and not source.contains("Boundary_10_-340"),
		"the predicate reads both layouts' own constants and names no node literally: %d, %d; it fails loudly: %d push_error, %d assert"
			% [source.count("RiftfallLandingGreyboxLayout.BOUNDARY_MASSES"), source.count("BrokenWatchLayout.WALKABLE"),
				source.count("push_error(cap_fault)"), source.count("assert(landing_caps.size() == 1 and cap_nodes_removed == 3, cap_fault)")])
	print("  %d fields, %d exports, %d functions in D-343's order, %d constants, no signal and no enum — the counts every accepted suite pins; only _ready() differs from D-343"
		% [fields, exports, functions.size(), constants])
	print("  the Landing is resolved, then the cap is opened, then the navigation is configured and baked: code lines %d, %d, %d, %d of _ready()"
		% [resolved_at, opened_at, configured_at, baked_at])
	print("  the cap is found from both layouts' own authored constants, never from the node name Boundary_10_-340, and a wrong count fails through push_error() as well as assert(), which release builds strip")
	_done("the_slice_declares_nothing_new_and_only_ready_differs_from_d343")


func _check_the_accepted_suites_moved_only_their_pins_and_read_back_layers() -> void:
	print("")
	print("--- 3. The eighteen accepted suite files J11 moved rebuild to their D-343 bytes through the store; the two maintenance files rebuild through this suite's own inline pairs")
	var faults: PackedStringArray = PackedStringArray()
	var blocks: int = 0
	var back: PackedStringArray = PackedStringArray()
	for row: Array in MOVED_SUITES:
		var path: String = row[0]
		var rebuilt: Dictionary = _put_back(FileAccess.get_file_as_string(path), row[3])
		blocks += (row[3] as Array).size()
		back.append(String(row[2]).left(8))
		if not (FileAccess.get_sha256(path).begins_with(String(row[1])) and not (row[3] as Array).is_empty()
				and String(rebuilt["text"]).sha256_text() == String(row[2])
				and (String(rebuilt["text"]) + "x").sha256_text() != String(row[2])):
			faults.append("%s at %s rebuilds to %s, not %s"
				% [path.get_file(), FileAccess.get_sha256(path).left(8), String(rebuilt["text"]).sha256_text().left(8), String(row[2]).left(8)])
	_expect(faults.is_empty() and MOVED_SUITES.size() == 18, "; ".join(faults))
	var maintenance: PackedStringArray = PackedStringArray()
	var maintenance_blocks: int = 0
	for row: Array in MAINTENANCE_MOVES:
		var path: String = row[0]
		var rebuilt: Dictionary = _put_back(FileAccess.get_file_as_string(path), row[3])
		maintenance_blocks += (row[3] as Array).size()
		maintenance.append(String(row[2]).left(8))
		if not (FileAccess.get_sha256(path).begins_with(String(row[1]))
				and String(rebuilt["text"]).sha256_text() == String(row[2])
				and (String(rebuilt["text"]) + "x").sha256_text() != String(row[2])):
			faults.append("%s at %s rebuilds to %s" % [path.get_file(), FileAccess.get_sha256(path).left(8), String(rebuilt["text"]).sha256_text().left(8)])
	_expect(faults.is_empty() and MAINTENANCE_MOVES.size() == 2, "; ".join(faults))
	print("  put back through the store, the 18 are byte for byte %s (%d replaced blocks)" % [", ".join(back), blocks])
	print("  the two Verification Maintenance V1 files rebuild to %s through %d inline blocks — they are inline because each names the D-344 store's own SHA-256, which a record inside that store could not"
		% [", ".join(maintenance), maintenance_blocks])
	_done("the_accepted_suites_moved_only_their_pins_and_read_back_layers")


func _check_the_d342_store_is_untouched_and_the_d344_store_is_flat_and_content_addressed() -> void:
	print("")
	print("--- 4. D-342's store is byte-identical; D-344's is a new, flat, content-addressed file that copies no earlier text, pair list or suite body")
	if _engine == null:
		_expect(false, "the provenance engine is not at its pinned SHA-256, so nothing here could be read")
		_expect(false, "and the store could not be parsed")
		_expect(false, "and no reference count could be taken")
		_done("the_d342_store_is_untouched_and_the_d344_store_is_flat_and_content_addressed")
		return
	var d342: String = STORE_DIRECTORY.path_join(D342_STORE)
	var d344: String = STORE_DIRECTORY.path_join(D344_STORE)
	var listed: PackedStringArray = DirAccess.get_files_at(STORE_DIRECTORY)
	listed.sort()
	_expect(FileAccess.get_sha256(d342) == D342_SHA256 and FileAccess.get_file_as_bytes(d342).size() == D342_BYTES
			and FileAccess.get_sha256(d344) == D344_SHA256 and FileAccess.get_file_as_bytes(d344).size() == D344_BYTES
			and listed == PackedStringArray([PROVENANCE_ENGINE.get_file(), D342_STORE, D344_STORE])
			and DirAccess.get_directories_at(STORE_DIRECTORY).is_empty(),
		"d342 is %s (%d bytes), d344 %s (%d bytes); the directory holds %s"
			% [FileAccess.get_sha256(d342).left(8), FileAccess.get_file_as_bytes(d342).size(),
				FileAccess.get_sha256(d344).left(8), FileAccess.get_file_as_bytes(d344).size(), ", ".join(listed)])
	var alone: Dictionary = _engine.parse({D344_STORE: FileAccess.get_file_as_bytes(d344)})
	var references: int = 0
	var literals: int = 0
	for id: String in alone["segments"]:
		for part: Array in alone["segments"][id]:
			if String(part[0]) == "=":
				literals += 1
			else:
				references += 1
	var misnamed: int = 0
	for id: String in alone["segments"]:
		var content: String = ""
		for part: Array in alone["segments"][id]:
			content += String(part[1]) if String(part[0]) == "=" else ""
		if content.sha256_text() != id:
			misnamed += 1
	var d344_edges: Array = []
	for edge: Dictionary in _loaded["edges"]:
		if String(edge["decision"]) == "D-344":
			d344_edges.append(edge)
	_expect(bool(_loaded["valid"]) and references == 0 and misnamed == 0
			and (alone["listings"] as Dictionary).size() == 18 and d344_edges.size() == 19
			and (_loaded["texts"] as Dictionary).size() == UNION_TEXTS
			and (_loaded["pairs"] as Dictionary).size() == UNION_PAIR_LISTS
			and (_loaded["edges"] as Array).size() == UNION_EDGES,
		"the whole store is valid: %s; d344 holds %d texts (%d misnamed), %d pair lists, %d edges and %d reference segment(s); the union is %d / %d / %d"
			% [str(_loaded["valid"]), (alone["segments"] as Dictionary).size(), misnamed,
				(alone["listings"] as Dictionary).size(), d344_edges.size(), references,
				(_loaded["texts"] as Dictionary).size(), (_loaded["pairs"] as Dictionary).size(), (_loaded["edges"] as Array).size()])
	# Nothing of the older store or of any accepted suite is copied into the new file.
	var d344_text: String = FileAccess.get_file_as_string(d344)
	var escaped: int = 0
	for path: String in _all_suite_paths():
		var body: String = FileAccess.get_file_as_string(path)
		if d344_text.contains(body) or d344_text.contains(_engine.escape(body)):
			escaped += 1
	var d342_text: String = FileAccess.get_file_as_string(d342)
	var copied: int = 0
	for id: String in (_engine.parse({D342_STORE: FileAccess.get_file_as_bytes(d342)})["listings"] as Dictionary):
		if d344_text.contains(id):
			copied += 1
	var holds: bool = true
	for edge: Dictionary in d344_edges:
		var now: String = FileAccess.get_file_as_string(String(edge["path"]))
		var after: Dictionary = _engine.apply(now, _engine.pairs_of(_loaded, String(edge["pairs"])))
		holds = holds and now.sha256_text() == String(edge["from"]) and String(after["text"]).sha256_text() == String(edge["to"])
	_expect(escaped == 0 and copied == 0 and holds and not d344_text.contains(d342_text.substr(0, 4000)),
		"%d suite body/bodies and %d D-342 pair-list name(s) appear in the new file; every new edge holds: %s"
			% [escaped, copied, str(holds)])
	print("  %s is byte-identical at %s, %d bytes — D-344 rewrote nothing" % [D342_STORE, D342_SHA256.left(8), D342_BYTES])
	print("  %s is %s, %d bytes: %d texts each one literal `=` segment and each hashing to its name, %d pair lists, %d edges, and ZERO `%%` or `&` reference lines"
		% [D344_STORE, D344_SHA256.left(8), D344_BYTES, (alone["segments"] as Dictionary).size(), (alone["listings"] as Dictionary).size(), d344_edges.size()])
	print("  the union is %d texts, %d pair lists and %d edges, and all %d D-344 edges put their file back to the bytes D-343 left"
		% [(_loaded["texts"] as Dictionary).size(), (_loaded["pairs"] as Dictionary).size(), (_loaded["edges"] as Array).size(), d344_edges.size()])
	print("  no accepted suite's body, raw or escaped, and no D-342 pair-list name is inside the new file: the graph is flat and non-nesting")
	_done("the_d342_store_is_untouched_and_the_d344_store_is_flat_and_content_addressed")


func _check_the_provenance_records_refuse_mutation_omission_duplication_reordering_and_wrong_targets() -> void:
	print("")
	print("--- 5. Every tamper case against the new store is refused, and a guard that accepted them would prove nothing")
	if _engine == null:
		_expect(false, "the provenance engine is not at its pinned SHA-256")
		_expect(false, "so no mutation could be put to it")
		_done("the_provenance_records_refuse_mutation_omission_duplication_reordering_and_wrong_targets")
		return
	var bytes: PackedByteArray = FileAccess.get_file_as_bytes(STORE_DIRECTORY.path_join(D344_STORE))
	var text: String = bytes.get_string_from_utf8()
	var cases: Array = []
	var flipped: PackedByteArray = bytes.duplicate()
	var at: int = text.find("=", text.find("@text ")) + 8
	flipped[at] = 88 if flipped[at] != 88 else 89
	cases.append(["one ASCII byte changed inside a literal", flipped])
	cases.append(["truncated to half its bytes", bytes.slice(0, bytes.size() / 2)])
	var appended: PackedByteArray = bytes.duplicate()
	appended.append(120)
	cases.append(["one byte appended", appended])
	cases.append(["its final newline removed", bytes.slice(0, bytes.size() - 1)])
	var lines: PackedStringArray = text.split("\n")
	var first_text: int = 0
	for index: int in lines.size():
		if lines[index].begins_with("@text "):
			first_text = index
			break
	var second_text: int = first_text
	for index: int in range(first_text + 1, lines.size()):
		if lines[index].begins_with("@text "):
			second_text = index
			break
	var omitted: PackedStringArray = lines.duplicate()
	for _drop: int in range(second_text - first_text):
		omitted.remove_at(first_text)
	cases.append(["a text a pair list names, omitted", "\n".join(omitted).to_utf8_buffer()])
	var duplicated: PackedStringArray = lines.duplicate()
	for offset: int in range(second_text - first_text):
		duplicated.insert(second_text + offset, lines[first_text + offset])
	cases.append(["the same text held twice", "\n".join(duplicated).to_utf8_buffer()])
	var third_text: int = second_text
	for index: int in range(second_text + 1, lines.size()):
		if lines[index].begins_with("@text "):
			third_text = index
			break
	var swapped: PackedStringArray = PackedStringArray()
	swapped.append_array(lines.slice(0, first_text))
	swapped.append_array(lines.slice(second_text, third_text))
	swapped.append_array(lines.slice(first_text, second_text))
	swapped.append_array(lines.slice(third_text))
	cases.append(["the first two texts swapped", "\n".join(swapped).to_utf8_buffer()])
	var misnamed: PackedStringArray = lines.duplicate()
	var name: String = misnamed[first_text].substr(6)
	misnamed[first_text] = "@text " + name.substr(0, 63) + ("0" if name[63] != "0" else "1")
	cases.append(["a text under a name one character off its own", "\n".join(misnamed).to_utf8_buffer()])
	var reversed_pairs: PackedStringArray = lines.duplicate()
	var pairs_at: int = 0
	for index: int in lines.size():
		if lines[index].begins_with("@pairs "):
			pairs_at = index
			break
	var pair_end: int = pairs_at
	for index: int in range(pairs_at + 1, lines.size()):
		if lines[index] == "@end":
			pair_end = index
			break
	if pair_end - pairs_at >= 3:
		var body: PackedStringArray = lines.slice(pairs_at + 1, pair_end)
		body.reverse()
		var reordered: PackedStringArray = PackedStringArray()
		reordered.append_array(lines.slice(0, pairs_at + 1))
		reordered.append_array(body)
		reordered.append_array(lines.slice(pair_end))
		cases.append(["a pair list's own lines reversed", "\n".join(reordered).to_utf8_buffer()])
	var unreferenced: PackedStringArray = lines.duplicate()
	unreferenced.insert(first_text, "@end")
	unreferenced.insert(first_text, "=1\nq")
	unreferenced.insert(first_text, "@text %s" % "q".sha256_text())
	cases.append(["an unreferenced text added", "\n".join(unreferenced).to_utf8_buffer()])
	var refused: PackedStringArray = PackedStringArray()
	var accepted: PackedStringArray = PackedStringArray()
	for entry: Array in cases:
		var parsed: Dictionary = _engine.parse({D342_STORE: FileAccess.get_file_as_bytes(STORE_DIRECTORY.path_join(D342_STORE)),
			D344_STORE: entry[1]})
		if bool(parsed["valid"]):
			accepted.append(String(entry[0]))
		else:
			refused.append("%s: %s" % [entry[0], String((parsed["refusals"] as Array)[0]).substr(0, 90)])
	# A wrong target and a wrong file: an edge claimed for a state its pair list does not reach.
	var wrong_target: bool = false
	var wrong_file: bool = false
	for edge: Dictionary in _loaded["edges"]:
		if String(edge["decision"]) != "D-344":
			continue
		var pairs: Array = _engine.pairs_of(_loaded, String(edge["pairs"]))
		var other: String = ""
		for candidate: Dictionary in _loaded["edges"]:
			if String(candidate["decision"]) == "D-344" and String(candidate["path"]) != String(edge["path"]):
				other = String(candidate["path"])
				break
		wrong_target = String(_engine.apply(FileAccess.get_file_as_string(String(edge["path"])), pairs)["text"]).sha256_text() != String(edge["from"])
		wrong_file = String(_engine.apply(FileAccess.get_file_as_string(other), pairs)["text"]).sha256_text() != String(edge["to"])
		break
	# A moved pin resolves to nothing, so the read that needs it fails.
	var moved_pin: Array = _engine.pairs_of(_loaded, "0" + String(MOVED_SUITE_ROWS[0][3]).substr(1))
	# A moved engine is refused by this suite's own guard.
	var moved_engine: Variant = _stored(String(MOVED_SUITE_ROWS[0][3])) if FileAccess.get_sha256(PROVENANCE_ENGINE) == PROVENANCE_ENGINE_SHA256 else []
	_expect(accepted.is_empty() and refused.size() == cases.size(),
		"accepted without complaint: %s" % ", ".join(accepted))
	_expect(wrong_target and wrong_file and moved_pin.is_empty() and not (moved_engine as Array).is_empty(),
		"wrong target refused: %s; wrong file refused: %s; a moved pin resolves to %d pair(s); the engine's own pin still resolves %d"
			% [str(wrong_target), str(wrong_file), moved_pin.size(), (moved_engine as Array).size()])
	for line: String in refused:
		print("  refused — %s" % line)
	print("  %d mutation case(s) refused and none accepted; a wrong target state and a wrong target file are both refused; a pin one character off resolves to nothing"
		% refused.size())
	_done("the_provenance_records_refuse_mutation_omission_duplication_reordering_and_wrong_targets")


func _check_the_reach_is_gate_1d_and_gate_1e_by_structure_and_not_the_roguelite() -> void:
	print("")
	print("--- 6. What the opening reaches, read from source: Gate 1D directly, Gate 1E through super._ready(), and no roguelite runtime at all")
	var slice_source: String = _bare(FileAccess.get_file_as_string(SLICE_SCRIPT))
	var opening_source: String = _bare(FileAccess.get_file_as_string(OPENING_SCRIPT))
	var loop_source: String = _bare(FileAccess.get_file_as_string(CORE_LOOP_SCRIPT))
	var descendants: PackedStringArray = PackedStringArray()
	var second_opening: PackedStringArray = PackedStringArray()
	var scanned: int = 0
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd"]):
			scanned += 1
			var code: String = _bare(FileAccess.get_file_as_string(path))
			if RegEx.create_from_string("(?m)^extends BrokenWatchSlice").search(code) != null:
				descendants.append(path.get_file())
			if path == SLICE_SCRIPT:
				continue
			if code.contains("RiftfallLandingGreyboxLayout.BOUNDARY_MASSES") or code.contains("Boundary_10_-340"):
				second_opening.append(path.get_file())
	descendants.sort()
	var opening_ready: PackedStringArray = _code_lines(_function_body(opening_source, "_ready"))
	var loop_ready: PackedStringArray = _code_lines(_function_body(loop_source, "_ready"))
	_expect(slice_source.contains("landing_caps") and descendants == PackedStringArray(["canonical_opening_runtime.gd", "roguelite_core_loop_runtime.gd"]) and second_opening.is_empty(),
		"the slice holds the opening; %d direct descendant(s) of BrokenWatchSlice: %s; a second Landing-cap opening in: %s"
			% [descendants.size(), ", ".join(descendants), ", ".join(second_opening)])
	_expect(opening_ready.has("await super._ready()") and opening_source.contains("func _open_broken_watch_far_cap() -> void:")
			and opening_source.contains("BrokenWatchLayout.CAP_HEIGHT") and not opening_source.contains("landing_caps"),
		"CanonicalOpeningRuntime._ready() calls super: %s; it still removes Broken Watch's own far cap: %s"
			% [str(opening_ready.has("await super._ready()")), str(opening_source.contains("func _open_broken_watch_far_cap() -> void:"))])
	_expect(not loop_ready.has("await super._ready()") and not loop_ready.has("super._ready()")
			and not loop_source.contains("RiftfallLandingGreybox") and not loop_source.contains("BrokenWatchLayout"),
		"the core loop's _ready() calls super: %s; it names a Landing or Broken Watch layout: %s"
			% [str(loop_ready.has("await super._ready()")), str(loop_source.contains("RiftfallLandingGreybox"))])
	print("  %d script(s) scanned; exactly %d extend BrokenWatchSlice directly: %s — and no script but the slice itself names RiftfallLandingGreyboxLayout.BOUNDARY_MASSES or the cap node" % [scanned, descendants.size(), ", ".join(descendants)])
	print("  Gate 1D runs the opening in its own _ready(); Gate 1E's CanonicalOpeningRuntime inherits it through `await super._ready()` and creates NO second Landing-cap opening — it still removes Broken Watch's opposite far cap toward the Nexus Threshold, by CAP_HEIGHT, in its own _open_broken_watch_far_cap()")
	print("  the Roguelite Core Loop extends the slice for the TYPE and deliberately does not call super._ready(), and names neither layout, so it never composes the Landing with Broken Watch and is untouched")
	print("  structural only: Gate 1E's scene never entered the tree in this run, and nothing of Gate 1E is measured here")
	_done("the_reach_is_gate_1d_and_gate_1e_by_structure_and_not_the_roguelite")


# --- 7–13. Gate 1D's own scene ----------------------------------------------------------------

func _check_exactly_one_landing_boundary_mass_qualifies_and_only_its_three_nodes_are_removed() -> void:
	print("")
	print("--- 7. Exactly one authored Landing boundary mass stands over Broken Watch, and exactly its three built nodes are gone")
	var qualifying: Array[Rect2] = []
	var overlap: float = 0.0
	for mass: Dictionary in RiftfallLandingGreyboxLayout.BOUNDARY_MASSES:
		var rect: Rect2 = mass["rect"]
		for room: Rect2 in BrokenWatchLayout.WALKABLE:
			if rect.intersects(room):
				qualifying.append(rect)
				overlap += rect.intersection(room).get_area()
				break
	_expect(qualifying.size() == 1 and qualifying[0] == CAP_RECT and is_equal_approx(overlap, CAP_OVERLAP)
			and RiftfallLandingGreyboxLayout.BOUNDARY_MASSES.size() == LANDING_BOUNDARY_MASSES
			and BrokenWatchLayout.WALKABLE.size() == BROKEN_WATCH_ROOMS,
		"%d of %d Landing boundary mass(es) overlap one of Broken Watch's %d rooms, by %.2f m^2"
			% [qualifying.size(), RiftfallLandingGreyboxLayout.BOUNDARY_MASSES.size(), BrokenWatchLayout.WALKABLE.size(), overlap])
	_expect(int(_nodes["cap_visual"]) == 0 and int(_nodes["cap_collision"]) == 0 and int(_nodes["cap_carve"]) == 0,
		"the cap's three nodes are still present: visual %d, collision %d, carve %d"
			% [int(_nodes["cap_visual"]), int(_nodes["cap_collision"]), int(_nodes["cap_carve"])])
	_expect(int(_nodes["landing_visuals"]) == LANDING_VISUALS - 1 and int(_nodes["landing_collision"]) == LANDING_COLLIDERS - 1
			and int(_nodes["landing_carves"]) == LANDING_CARVES - 1
			and int(_nodes["watch_visuals"]) == WATCH_VISUALS and int(_nodes["watch_collision"]) == WATCH_COLLIDERS
			and int(_nodes["watch_carves"]) == WATCH_CARVES,
		"the Landing holds %d visuals, %d colliders and %d carves (want %d/%d/%d); Broken Watch %d, %d and %d (want %d/%d/%d)"
			% [int(_nodes["landing_visuals"]), int(_nodes["landing_collision"]), int(_nodes["landing_carves"]),
				LANDING_VISUALS - 1, LANDING_COLLIDERS - 1, LANDING_CARVES - 1,
				int(_nodes["watch_visuals"]), int(_nodes["watch_collision"]), int(_nodes["watch_carves"]),
				WATCH_VISUALS, WATCH_COLLIDERS, WATCH_CARVES])
	print("  %d of %d Riftfall Landing boundary masses overlaps a Broken Watch walkable rectangle: the Watch Breach far cap %s, %.2f m^2 of the Watch Threshold"
		% [qualifying.size(), RiftfallLandingGreyboxLayout.BOUNDARY_MASSES.size(), str(CAP_RECT), overlap])
	print("  its three built nodes are gone — Visuals/%s, WorldCollision/%s and NavigationObstacles/%sCarve — and every other Landing solid remains: %d visuals, %d colliders, %d carves, one of each fewer than the Landing builds alone"
		% [CAP_STEM, CAP_STEM, CAP_STEM, int(_nodes["landing_visuals"]), int(_nodes["landing_collision"]), int(_nodes["landing_carves"])])
	print("  Broken Watch is untouched: %d visuals, %d colliders and %d carves, every one of them still there"
		% [int(_nodes["watch_visuals"]), int(_nodes["watch_collision"]), int(_nodes["watch_carves"])])
	_done("exactly_one_landing_boundary_mass_qualifies_and_only_its_three_nodes_are_removed")


func _check_the_opening_precedes_the_bake_and_one_continuous_map_is_baked() -> void:
	print("")
	print("--- 8. The opening is logged before the bake, and the whole slice is one continuous navigation map from exactly one bake")
	var opened_at: int = -1
	var baked_at: int = -1
	for index: int in slice.log_lines.size():
		if slice.log_lines[index].contains("landing cap opened") and opened_at < 0:
			opened_at = index
		if slice.log_lines[index].contains("navigation baked") and baked_at < 0:
			baked_at = index
	_expect(opened_at >= 0 and baked_at > opened_at and slice.bake_count == 1
			and NavigationServer3D.map_get_regions(slice.navigation_map()).size() == 1,
		"the opening is logged at %d and the bake at %d; %d bake(s), %d region(s)"
			% [opened_at, baked_at, slice.bake_count, NavigationServer3D.map_get_regions(slice.navigation_map()).size()])
	_expect(slice.navmesh_polygon_count > 0 and slice.navmesh_area > 1800.0,
		"the baked mesh is %d polygons over %.2f m^2" % [slice.navmesh_polygon_count, slice.navmesh_area])
	print("  the cap is opened at log line %d and the navigation baked at %d — before, not after — in %d bake over %d region: %d polygons, %.2f m^2 walkable"
		% [opened_at, baked_at, slice.bake_count, NavigationServer3D.map_get_regions(slice.navigation_map()).size(),
			slice.navmesh_polygon_count, slice.navmesh_area])
	_done("the_opening_precedes_the_bake_and_one_continuous_map_is_baked")


func _check_the_seam_is_navigable_through_the_former_cap_footprint_on_both_faces() -> void:
	print("")
	print("--- 9. The navigation mesh now covers the former cap's footprint, and a path crosses BOTH of its former faces rather than resolving to one side")
	var stations: Array = _seam["stations"]
	var off: PackedStringArray = PackedStringArray()
	for station: Dictionary in stations:
		if float(station["gap"]) > ON_MESH:
			off.append("z %.2f is %.4f m off" % [float(station["z"]), float(station["gap"])])
	var blocked: PackedStringArray = PackedStringArray()
	for station: Dictionary in stations:
		if int(station["tall"]) > 0:
			blocked.append("z %.2f meets %s" % [float(station["z"]), String(station["names"])])
	var path: Dictionary = _seam["through"]
	_expect(off.is_empty() and blocked.is_empty() and stations.size() == SEAM_STATIONS,
		"%d of %d station(s) off the mesh: %s; %d blocked: %s" % [off.size(), stations.size(), ", ".join(off), blocked.size(), ", ".join(blocked)])
	_expect(bool(path["crossed_near"]) and bool(path["crossed_far"]) and bool(path["inside_cap"])
			and float(path["end_gap"]) <= ON_MESH and int(path["points"]) >= 2
			and float(path["max_lateral"]) <= 1.0,
		"the path from local (3, %.1f) to the entry: %d points, %.2f m, ends %.4f m away; crossed the near face %s and the far face %s; a waypoint inside the cap footprint %s; furthest from x = 3: %.2f m"
			% [NORTH_OF_CAP, int(path["points"]), float(path["length"]), float(path["end_gap"]),
				str(path["crossed_near"]), str(path["crossed_far"]), str(path["inside_cap"]), float(path["max_lateral"])])
	print("  %d stations along the route's own centreline, local x = %.1f from z = %.1f to z = %.1f in 0.5 m steps: every one ON the navigation mesh (at most %.4f m) and none meeting any tall solid"
		% [stations.size(), SEAM_X, NORTH_OF_CAP, ENTRY_LOCAL.y - 0.25, float(_seam["worst_gap"])])
	print("  a path from local (%.1f, %.1f) to the entry runs %d points and %.2f m, straight through the former cap: it crosses the near face z = %.1f AND the far face z = %.1f, holds a waypoint inside the old footprint, and never leaves x = %.1f by more than %.2f m"
		% [SEAM_X, NORTH_OF_CAP, int(path["points"]), float(path["length"]), CAP_NEAR_FACE, CAP_FAR_FACE, SEAM_X, float(path["max_lateral"])])
	print("  before the edit the same query answered 9 points and 10.93 m, swinging west to local x = 0.45 around the cap, and the mesh was 2.55 m away at z = -32.00")
	_done("the_seam_is_navigable_through_the_former_cap_footprint_on_both_faces")


func _check_the_path_continues_to_the_entry_and_to_the_first_encounter_area() -> void:
	print("")
	print("--- 10. One path runs from Riftfall Landing's own player start through the seam to Broken Watch's entry, and on to the first encounter")
	var to_entry: Dictionary = _seam["to_entry"]
	var to_first: Dictionary = _seam["to_first"]
	var to_exit: Dictionary = _seam["to_exit"]
	_expect(float(to_entry["end_gap"]) <= ON_MESH and int(to_entry["points"]) > 1 and bool(to_entry["inside_cap"]),
		"player start -> entry: %d points, %.2f m, ends %.4f m away; through the old footprint: %s"
			% [int(to_entry["points"]), float(to_entry["length"]), float(to_entry["end_gap"]), str(to_entry["inside_cap"])])
	_expect(float(to_first["end_gap"]) <= ON_MESH and int(to_first["points"]) > 1
			and float(to_exit["end_gap"]) <= ON_MESH and int(to_exit["points"]) > 1,
		"player start -> first encounter: %d points, %.2f m, ends %.4f m away; -> Broken Watch's exit: %d points, %.2f m, ends %.4f m away"
			% [int(to_first["points"]), float(to_first["length"]), float(to_first["end_gap"]),
				int(to_exit["points"]), float(to_exit["length"]), float(to_exit["end_gap"])])
	print("  Riftfall Landing's player start -> Broken Watch's entry: %d points, %.2f m, ending %.4f m from it, with a waypoint inside the former cap footprint — before the edit it was 38 points and 62.78 m around the cap"
		% [int(to_entry["points"]), float(to_entry["length"]), float(to_entry["end_gap"])])
	print("  on to the first encounter area: %d points, %.2f m, ending %.4f m from FirstEncounterSpawn; and to Broken Watch's exit socket: %d points, %.2f m"
		% [int(to_first["points"]), float(to_first["length"]), float(to_first["end_gap"]), int(to_exit["points"]), float(to_exit["length"])])
	_done("the_path_continues_to_the_entry_and_to_the_first_encounter_area")


func _check_a_real_player_body_walks_the_seam_under_ordinary_movement() -> void:
	print("")
	print("--- 11. A real PrototypePlayer walks the seam under ordinary movement — the production command chain, then the stick alone — with no teleport, no depenetration and no bypass")
	var walk: Dictionary = _walked
	var stick: Dictionary = _stick
	_expect(float(walk["end_gap"]) <= ARRIVED and int(walk["frames"]) < WALK_FRAMES and bool(walk["crossed_near"])
			and bool(walk["crossed_far"]) and bool(walk["inside_cap"]),
		"click-to-move: the command resolved '%s' (neutral latch %s, mode %s); the arrival signal fired %s; %.4f m from the entry after %d physics frames; crossed the near face %s, the far face %s, inside the old footprint %s"
			% [String(walk["status"]), str(walk["neutral"]), String(walk["mode"]), str(walk["arrived"]),
				float(walk["end_gap"]), int(walk["frames"]), str(walk["crossed_near"]),
				str(walk["crossed_far"]), str(walk["inside_cap"])])
	_expect(float(walk["max_step"]) <= ACCEPTED_STEP and float(walk["max_off_mesh"]) <= OFF_MESH_LIMIT
			and int(walk["stalls"]) == 0 and float(walk["max_lateral"]) <= 1.5 and float(walk["max_y"]) <= 0.35,
		"the largest single-frame step was %.4f m (limit %.4f), the body was at most %.4f m off the mesh, it stalled %d time(s), swung %.2f m off x = 3 and %.3f m in y"
			% [float(walk["max_step"]), ACCEPTED_STEP, float(walk["max_off_mesh"]), int(walk["stalls"]),
				float(walk["max_lateral"]), float(walk["max_y"])])
	_expect(bool(stick["passed_near"]) and bool(stick["passed_far"]) and float(stick["reached_z"]) <= CAP_FAR_FACE - 0.25
			and float(stick["max_step"]) <= ACCEPTED_STEP and int(stick["stalls"]) == 0,
		"the stick alone: passed z = %.1f %s and z = %.1f %s, reaching local z = %.2f in %d frames; largest step %.4f m, %d stall(s)"
			% [CAP_NEAR_FACE, str(stick["passed_near"]), CAP_FAR_FACE, str(stick["passed_far"]),
				float(stick["reached_z"]), int(stick["frames"]), float(stick["max_step"]), int(stick["stalls"])])
	print("  click-to-move through the production chain — PrototypeGroundPointer.resolve_to_navigation() then PrototypePlayer.command_move_to(), the two lines _issue_move_command() itself runs — from local (%.1f, %.1f) to the entry: the body reached it in %d physics frames and stood %.4f m from it, having crossed z = %.1f and z = %.1f and passed through the former cap footprint"
		% [WALK_START.x, WALK_START.y, int(walk["frames"]), float(walk["end_gap"]), CAP_NEAR_FACE, CAP_FAR_FACE])
	print("  nothing was teleported: the largest single physics step was %.4f m against the %.4f m an accepted 5.0 m/s body can take, the body never left the navigation mesh by more than %.4f m, never stalled, never rose more than %.3f m, and no position was written during the window"
		% [float(walk["max_step"]), ACCEPTED_STEP, float(walk["max_off_mesh"]), float(walk["max_y"])])
	print("  and with the navigation agent given nothing at all — the InputMap's own move_vector_forward held through Input.action_press(), direct physics against real collision — the body still passed both former faces, reaching local z = %.2f in %d frames"
		% [float(stick["reached_z"]), int(stick["frames"])])
	print("  the first Graveblade stood %.1f m away and quiet for both windows, so neither its collision nor its AI could touch the result" % float(walk["enemy_distance"]))
	_done("a_real_player_body_walks_the_seam_under_ordinary_movement")


func _check_j10s_entry_socket_and_restart_stability_are_unchanged() -> void:
	print("")
	print("--- 12. J10 stands: the entry socket is still (3, -34.75), the restart still clears through the one authority, and the character still stays put")
	var f5: Dictionary = _j10["f5"]
	var fallen: Dictionary = _j10["fallen"]
	var slice_source: String = FileAccess.get_file_as_string(SLICE_SCRIPT)
	var restart: PackedStringArray = _code_lines(_function_body(slice_source, "restart_current_slice"))
	var entry_at: int = restart.find("player.global_position = broken_watch.entry()")
	var clear_at: int = restart.find("player.clear_movement_intent(reason, false)")
	_expect(BrokenWatchLayout.ENTRY_POINT == ENTRY_LOCAL and clear_at == entry_at + 1 and entry_at >= 0,
		"ENTRY_POINT is %s; the clearing sits at code line %d and the entry at %d"
			% [str(BrokenWatchLayout.ENTRY_POINT), clear_at, entry_at])
	for label: String in ["f5", "fallen"]:
		var route: Dictionary = _j10[label]
		_expect(float(route["call_gap"]) <= STABLE_METRES and float(route["max_gap"]) <= STABLE_METRES
				and float(route["end_gap"]) <= STABLE_METRES and float(route["max_speed"]) <= STILL_SPEED
				and not bool(route["destination"]) and String(route["latch"]) == ENCOUNTER_RESET
				and bool(route["alive"]) and not bool(route["attacking"]),
			"route %s: opened %s, Life trail %s; %.4f m from the entry in the restart's own call, at most %.4f m and %.4f m/s over %d frames, ending %.4f m away; destination %s; latch '%s'"
				% [label, str(route.get("opened", "n/a")), str(route.get("trail", [])), float(route["call_gap"]), float(route["max_gap"]), float(route["max_speed"]),
					WINDOW_FRAMES, float(route["end_gap"]), str(route["destination"]), String(route["latch"])])
	print("  BrokenWatchLayout.ENTRY_POINT is still %s and restart_current_slice() still calls clear_movement_intent(reason, false) directly after the entry"
		% str(BrokenWatchLayout.ENTRY_POINT))
	print("  F5 with a stale click destination %.1f m ahead: in the restart's own call %.4f m from the entry, and over %d physics frames at most %.4f m and %.4f m/s, ending %.4f m away, with no destination and the latch still '%s'"
		% [float(f5["staged_distance"]), float(f5["call_gap"]), WINDOW_FRAMES, float(f5["max_gap"]), float(f5["max_speed"]), float(f5["end_gap"]), String(f5["latch"])])
	print("  a real Fallen Restart, four Graveblade Hits then Enter on the focused \"%s\": the overlay closed once and the character stood %.4f m from the entry, at most %.4f m over %d frames"
		% [RESTART_CAPTION, float(fallen["call_gap"]), float(fallen["max_gap"]), WINDOW_FRAMES])
	_done("j10s_entry_socket_and_restart_stability_are_unchanged")


func _check_j9s_binding_the_drop_latch_and_the_encounter_reset_are_unchanged() -> void:
	print("")
	print("--- 13. J9 stands: the first Graveblade's own death is counted as its own, one drop is placed, the latch holds across restarts and both encounters reset")
	var heard: Array = _j9["heard"]
	var one: Dictionary = heard[0] if heard.size() == 1 else {}
	var connections: Array = _j9["connections"]
	var bound: Dictionary = connections[0] if connections.size() == 1 else {}
	_expect(bool(_j9["dead"]) and _floats(_j9["trail"]) == "300 -> 200 -> 100 -> 0" and connections.size() == 1
			and int(bound.get("arguments", -1)) == 1 and int(bound.get("first", 0)) == int(_j9["first_id"]),
		"the first Graveblade died: %s, Life %s; %d connection(s) with %s bound"
			% [str(_j9["dead"]), _floats(_j9["trail"]), connections.size(), str(bound)])
	_expect(int(one.get("source_id", 0)) == int(_j9["player_id"]) and int(one.get("target_id", 0)) == int(_j9["first_id"])
			and (one.get("rewarded", []) as Array) == [int(_j9["first_id"])] and bool(_j9["latch"]) and _drops_created == 1,
		"the event named source %d and target %d; the rewarded set is %s; the latch is %s and %d drop(s) were created"
			% [int(one.get("source_id", 0)), int(one.get("target_id", 0)), str(one.get("rewarded", [])), str(_j9["latch"]), _drops_created])
	_expect(bool(_j9["latch_after"]) and _drops_created == 1 and int(_j9["rewarded_after"]) == 1
			and bool(_j9["both_reset"]) and int(_j9["restarts"]) >= 2,
		"after %d restart(s): the latch is %s, %d drop(s) exist, the rewarded set holds %d, both Graveblades back at their spawns: %s"
			% [int(_j9["restarts"]), str(_j9["latch_after"]), _drops_created, int(_j9["rewarded_after"]), str(_j9["both_reset"])])
	print("  three real Quick Strikes at 100 damage took the first Graveblade %s; its died reached the slice's %s through the one connection, whose 1 bound argument is that Graveblade itself"
		% [_floats(_j9["trail"]), CALLBACK])
	print("  the event named the player as source and the first Graveblade as target; the rewarded set holds the first Graveblade's id and not the player's; the latch is set and exactly 1 drop was created")
	print("  after %d restarts the same drop still lies there, the latch is still set, the rewarded set still holds 1 id, and both Graveblades are back at their spawns, alive and active"
		% int(_j9["restarts"]))
	_done("j9s_binding_the_drop_latch_and_the_encounter_reset_are_unchanged")


# --- 14. The accepted standalone Riftfall Landing review ---------------------------------------

func _check_the_standalone_landing_keeps_its_far_cap_its_boundary_list_and_its_sockets() -> void:
	print("")
	print("--- 14. Instanced on its own, the accepted Riftfall Landing greybox review still builds the far cap, and every measurement and socket is unchanged")
	_expect(bool(_standalone["visual"]) and bool(_standalone["collision"]) and bool(_standalone["carve"]),
		"standalone: the cap's visual %s, its collision %s, its navigation carve %s"
			% [str(_standalone["visual"]), str(_standalone["collision"]), str(_standalone["carve"])])
	_expect(int(_standalone["boundary_masses"]) == LANDING_BOUNDARY_MASSES
			and int(_standalone["visuals"]) == LANDING_VISUALS and int(_standalone["colliders"]) == LANDING_COLLIDERS
			and int(_standalone["carves"]) == LANDING_CARVES
			and is_equal_approx(float(_standalone["cap_height"]), CAP_HEIGHT)
			and Rect2(_standalone["cap_rect"]) == CAP_RECT,
		"standalone: %d authored boundary masses, %d visuals, %d colliders, %d carves; the cap is %s at height %.2f m"
			% [int(_standalone["boundary_masses"]), int(_standalone["visuals"]), int(_standalone["colliders"]),
				int(_standalone["carves"]), str(_standalone["cap_rect"]), float(_standalone["cap_height"])])
	_expect(is_equal_approx(float(_standalone["footprint"]), 1201.00)
			and is_equal_approx(float(_standalone["breach"]), 8.000)
			and is_equal_approx(float(_standalone["narrowest"]), 8.000)
			and Vector2(_standalone["player_start"]) == RiftfallLandingGreyboxLayout.PLAYER_START
			and Vector2(_standalone["way_out"]) == RiftfallLandingGreyboxLayout.WAY_OUT
			and int(_standalone["sockets"]) == 2,
		"standalone: footprint %.2f m^2, breach %.3f m, narrowest %.3f m, PlayerStart %s, WayOut %s, %d socket(s)"
			% [float(_standalone["footprint"]), float(_standalone["breach"]), float(_standalone["narrowest"]),
				str(_standalone["player_start"]), str(_standalone["way_out"]), int(_standalone["sockets"])])
	print("  instanced by itself, the accepted review still holds Visuals/%s, WorldCollision/%s and NavigationObstacles/%sCarve — the cap is NOT deleted, only opened inside Gate 1D's own composition"
		% [CAP_STEM, CAP_STEM, CAP_STEM])
	print("  its authored boundary list is unchanged at %d masses, and it builds %d visuals, %d colliders and %d carves — one of each MORE than Gate 1D's composed instance"
		% [int(_standalone["boundary_masses"]), int(_standalone["visuals"]), int(_standalone["colliders"]), int(_standalone["carves"])])
	print("  its measurements are the accepted ones: %.2f m^2 walkable, an %.3f m Watch Breach clearance and an %.3f m narrowest clearance, with PlayerStart %s and WayOut %s exactly where they were"
		% [float(_standalone["footprint"]), float(_standalone["breach"]), float(_standalone["narrowest"]),
			str(_standalone["player_start"]), str(_standalone["way_out"])])
	_done("the_standalone_landing_keeps_its_far_cap_its_boundary_list_and_its_sockets")


# --- The two scenes ------------------------------------------------------------------------------

func _play_the_slice() -> void:
	slice = await _load(SLICE_SCENE) as BrokenWatchSlice
	if slice == null:
		return
	await _await_navigation()
	_quiet()
	(slice.get_node("Actors") as Node).child_entered_tree.connect(func(node: Node) -> void:
		if node is FirstMvpItemDrop:
			_drops_created += 1)
	_nodes = _count_nodes()
	_seam = _measure_seam()
	_walked = await _walk_the_seam()
	_stick = await _push_the_seam_with_the_stick()
	_j9 = await _kill_the_first_graveblade()
	_j10 = {"f5": await _route_f5_with_a_stale_destination(), "fallen": await _route_fallen_restart()}
	_j9["latch_after"] = slice._drop_granted
	_j9["rewarded_after"] = (slice._rewarded_enemies as Dictionary).size()
	_j9["restarts"] = _log_count("slice restarted")
	var reset: bool = true
	for index: int in slice.graveblades.size():
		var enemy: PrototypeGraveblade = slice.graveblades[index]
		var home: Vector3 = slice.broken_watch.first_encounter_spawn() if index == 0 else slice.broken_watch.second_encounter_spawn()
		reset = reset and _planar_gap(enemy.global_position, home) < 0.05
	_j9["both_reset"] = bool(_j10["fallen"].get("both_reset", false)) or bool(_j10["f5"].get("both_reset", false))
	_quiet()


func _play_the_standalone_landing() -> void:
	var review: Node = await _load(LANDING_REVIEW_SCENE)
	if review == null:
		return
	await _settle(4)
	var layout: RiftfallLandingGreyboxLayout = null
	for node: Node in _descend(review):
		if node is RiftfallLandingGreyboxLayout:
			layout = node as RiftfallLandingGreyboxLayout
			break
	if layout == null:
		_failures.append("the accepted Riftfall Landing greybox review holds no RiftfallLandingGreyboxLayout")
		return
	var cap: MeshInstance3D = layout.get_node_or_null("Visuals/%s" % CAP_STEM) as MeshInstance3D
	var rect: Rect2 = CAP_RECT
	var height: float = 0.0
	if cap != null and cap.mesh is BoxMesh:
		var size: Vector3 = (cap.mesh as BoxMesh).size
		height = size.y
		rect = Rect2(Vector2(cap.position.x - size.x * 0.5, cap.position.z - size.z * 0.5), Vector2(size.x, size.z))
	_standalone = {
		"visual": cap != null,
		"collision": layout.get_node_or_null("WorldCollision/%s" % CAP_STEM) != null,
		"carve": layout.get_node_or_null("NavigationObstacles/%sCarve" % CAP_STEM) != null,
		"boundary_masses": RiftfallLandingGreyboxLayout.BOUNDARY_MASSES.size(),
		"visuals": _children_of(layout, "Visuals"), "colliders": _children_of(layout, "WorldCollision"),
		"carves": _children_of(layout, "NavigationObstacles"),
		"cap_rect": rect, "cap_height": height,
		"footprint": layout.footprint_area(), "breach": layout.breach_clearance(),
		"narrowest": layout.narrowest_clearance(),
		"player_start": RiftfallLandingGreyboxLayout.PLAYER_START,
		"way_out": RiftfallLandingGreyboxLayout.WAY_OUT,
		"sockets": _children_of(layout, "Markers") / 2,
	}
	_note("the accepted standalone review was loaded SECOND, through change_scene_to_packed(), so no navigation state of Gate 1D's scene could answer for it")


# --- Readings ------------------------------------------------------------------------------------

func _count_nodes() -> Dictionary:
	var landing: Node = slice.landing_layout
	var watch: Node = slice.broken_watch
	return {
		"cap_visual": 1 if landing.get_node_or_null("Visuals/%s" % CAP_STEM) != null else 0,
		"cap_collision": 1 if landing.get_node_or_null("WorldCollision/%s" % CAP_STEM) != null else 0,
		"cap_carve": 1 if landing.get_node_or_null("NavigationObstacles/%sCarve" % CAP_STEM) != null else 0,
		"landing_visuals": _children_of(landing, "Visuals"),
		"landing_collision": _children_of(landing, "WorldCollision"),
		"landing_carves": _children_of(landing, "NavigationObstacles"),
		"watch_visuals": _children_of(watch, "Visuals"),
		"watch_collision": _children_of(watch, "WorldCollision"),
		"watch_carves": _children_of(watch, "NavigationObstacles"),
	}


## Every half metre down the route's own centreline, from north of the cap to the entry: how far the navigation
## mesh is, and what a player-sized capsule meets.
func _measure_seam() -> Dictionary:
	var stations: Array = []
	var worst: float = 0.0
	var z: float = NORTH_OF_CAP
	while z >= ENTRY_LOCAL.y - 0.25:
		var at: Vector3 = _local(Vector3(SEAM_X, 0.0, z))
		var gap: float = _planar_gap(NavigationServer3D.map_get_closest_point(slice.navigation_map(), at), at)
		worst = maxf(worst, gap)
		var tall: int = 0
		var names: PackedStringArray = PackedStringArray()
		for hit: Dictionary in _overlaps(at):
			if bool(hit["tall"]):
				tall += 1
				names.append(String(hit["path"]).get_file())
		stations.append({"z": z, "gap": gap, "tall": tall, "names": ", ".join(names)})
		z -= 0.5
	return {
		"stations": stations, "worst_gap": worst,
		"through": _path(_local(Vector3(SEAM_X, 0.0, NORTH_OF_CAP)), slice.broken_watch.entry()),
		"to_entry": _path(slice.landing_layout.player_start(), slice.broken_watch.entry()),
		"to_first": _path(slice.landing_layout.player_start(), slice.broken_watch.first_encounter_spawn()),
		"to_exit": _path(slice.landing_layout.player_start(), slice.broken_watch.exit_to_nexus_threshold()),
	}


func _path(from: Vector3, to: Vector3) -> Dictionary:
	var points: PackedVector3Array = NavigationServer3D.map_get_path(slice.navigation_map(), from, to, true)
	var length: float = 0.0
	for index: int in range(1, points.size()):
		length += _planar_gap(points[index], points[index - 1])
	var near: bool = false
	var far: bool = false
	var inside: bool = false
	var lateral: float = 0.0
	var previous: Vector2 = Vector2.ZERO
	for index: int in points.size():
		var here: Vector3 = _to_local(points[index])
		var flat: Vector2 = Vector2(here.x, here.z)
		if index > 0:
			if (previous.y > CAP_NEAR_FACE) != (flat.y > CAP_NEAR_FACE):
				near = true
			if (previous.y > CAP_FAR_FACE) != (flat.y > CAP_FAR_FACE):
				far = true
			# The line itself must pass through the old footprint: a waypoint need not land inside it.
			for step: int in 21:
				var along: Vector2 = previous.lerp(flat, float(step) / 20.0)
				if CAP_RECT.has_point(along):
					inside = true
					lateral = maxf(lateral, absf(along.x - SEAM_X))
		previous = flat
	return {
		"points": points.size(), "length": length,
		"end_gap": _planar_gap(points[points.size() - 1], to) if points.size() > 0 else INF,
		"crossed_near": near, "crossed_far": far, "inside_cap": inside, "max_lateral": lateral,
	}


## THE TRAVERSAL PROOF. The character is STAGED at the Landing side of the seam before the window opens — that
## placement is stated, not hidden — and then nothing writes its position again. The command is the production
## chain's own two lines, and every physics frame of the window is sampled.
func _walk_the_seam() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var first: PrototypeGraveblade = slice.graveblades[0]
	_quiet()
	# The character is staged FIRST and the Graveblade moved away AFTER: placing the enemy on the Landing's
	# player start while the character still stood there put it on top of the body and pinned it, which is
	# exactly the interference this isolation exists to remove.
	_stand_facing(_local(Vector3(WALK_START.x, 0.0, WALK_START.y)), _route())
	await _settle(2)
	first.place_at(slice.landing_layout.player_start())
	await _settle(8)
	await _until_neutral()
	var distance: float = _planar_gap(first.global_position, player.global_position)
	_note("both traversal windows began with the character stood on Riftfall Landing's own route at local %s, every intent cleared, and the first Graveblade quieted and placed %.1f m away on the Landing's player start"
		% [str(WALK_START), distance])
	var target: Vector3 = slice.broken_watch.entry()
	var resolution: Dictionary = PrototypeGroundPointer.resolve_to_navigation(slice.navigation_map(), target)
	var arrived: bool = false
	var status: Array = []
	var on_arrived: Callable = func(_point: Vector3) -> void: arrived = true
	var on_resolved: Callable = func(answer: String, _requested: Vector3, _resolved: Vector3) -> void: status.append(answer)
	player.arrived_at_destination.connect(on_arrived)
	player.movement_command_resolved.connect(on_resolved)
	player.command_move_to(resolution["point"], target, bool(resolution["adjusted"]))
	var previous: Vector3 = player.global_position
	var max_step: float = 0.0
	var max_off: float = 0.0
	var max_lateral: float = 0.0
	var max_y: float = 0.0
	var stalls: int = 0
	var near: bool = false
	var far: bool = false
	var inside: bool = false
	var frames: int = 0
	var was: Vector2 = Vector2(_to_local(player.global_position).x, _to_local(player.global_position).z)
	for frame: int in WALK_FRAMES:
		await physics_frame
		frames += 1
		var now: Vector3 = player.global_position
		var step: float = _planar_gap(now, previous)
		max_step = maxf(max_step, step)
		var here: Vector3 = _to_local(now)
		var flat: Vector2 = Vector2(here.x, here.z)
		if CAP_RECT.has_point(flat):
			inside = true
			max_lateral = maxf(max_lateral, absf(flat.x - SEAM_X))
		if (was.y > CAP_NEAR_FACE) != (flat.y > CAP_NEAR_FACE):
			near = true
		if (was.y > CAP_FAR_FACE) != (flat.y > CAP_FAR_FACE):
			far = true
		max_y = maxf(max_y, absf(now.y))
		max_off = maxf(max_off, _planar_gap(NavigationServer3D.map_get_closest_point(slice.navigation_map(), now), now))
		# A stall is a frame on which a body that has NOT yet reached the entry did not move.
		if step < 0.0005 and frame > 8 and _planar_gap(now, target) > ARRIVED:
			stalls += 1
		was = flat
		previous = now
		if _planar_gap(now, target) <= ARRIVED:
			break
	player.arrived_at_destination.disconnect(on_arrived)
	player.movement_command_resolved.disconnect(on_resolved)
	return {
		"status": ", ".join(PackedStringArray(status)), "neutral": player.awaiting_neutral,
		"mode": player.movement_mode_name(), "arrived": arrived, "frames": frames,
		"end_gap": _planar_gap(player.global_position, target),
		"max_step": max_step, "max_off_mesh": max_off, "stalls": stalls, "max_lateral": max_lateral,
		"max_y": max_y, "crossed_near": near, "crossed_far": far, "inside_cap": inside,
		"enemy_distance": distance,
	}


## The same seam with the navigation agent given nothing: the InputMap's own stick action held forward, which
## the slice reads every physics frame, driving `move_and_slide()` straight into the former cap's footprint.
func _push_the_seam_with_the_stick() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var first: PrototypeGraveblade = slice.graveblades[0]
	_quiet()
	_stand_facing(_local(Vector3(WALK_START.x, 0.0, WALK_START.y)), _route())
	await _settle(2)
	first.place_at(slice.landing_layout.player_start())
	await _settle(6)
	await _until_neutral()
	Input.action_press(&"move_vector_forward", 1.0)
	_note("the stick window held move_vector_forward through Input.action_press(), which the slice reads in its own _physics_process; no destination and no navigation agent target were set")
	var previous: Vector3 = player.global_position
	var max_step: float = 0.0
	var stalls: int = 0
	var near: bool = false
	var far: bool = false
	var reached: float = _to_local(player.global_position).z
	var frames: int = 0
	var was: float = reached
	for frame: int in STICK_FRAMES:
		await physics_frame
		frames += 1
		var now: Vector3 = player.global_position
		max_step = maxf(max_step, _planar_gap(now, previous))
		var here: float = _to_local(now).z
		if (was > CAP_NEAR_FACE) != (here > CAP_NEAR_FACE):
			near = true
		if (was > CAP_FAR_FACE) != (here > CAP_FAR_FACE):
			far = true
		if _planar_gap(now, previous) < 0.0005 and frame > 8:
			stalls += 1
		reached = minf(reached, here)
		was = here
		previous = now
		if here <= CAP_FAR_FACE - 0.40:
			break
	Input.action_release(&"move_vector_forward")
	await _settle(4)
	await _until_neutral()
	return {"passed_near": near, "passed_far": far, "reached_z": reached, "frames": frames,
		"max_step": max_step, "stalls": stalls}


## J9's proof, made exactly as J10 makes it: the first Graveblade placed on the Landing's route and killed by
## the player's own Quick Strikes, aimed through the slice's own verification seam.
func _kill_the_first_graveblade() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var first: PrototypeGraveblade = slice.graveblades[0]
	var area: PrototypeTargetable = first.get_node("TargetArea") as PrototypeTargetable
	var forward: Vector3 = _route()
	var connections: Array = []
	for connection: Dictionary in first.died.get_connections():
		var callable: Callable = connection["callable"]
		if callable.get_method() == CALLBACK:
			var bound: Array = callable.get_bound_arguments()
			connections.append({"arguments": bound.size(),
				"first": (bound[0] as Object).get_instance_id() if bound.size() == 1 and bound[0] is Object else 0})
	_quiet()
	await _until_neutral()
	first.place_at(slice.landing_layout.player_start() + forward * 6.0)
	first.face_instantly(-forward)
	await _settle(2)
	var heard: Array = []
	first.died.connect(func(event: DamageEvent) -> void:
		heard.append({
			"source_id": event.source.get_instance_id() if event.source != null else 0,
			"target_id": event.target.get_instance_id() if event.target != null else 0,
			"rewarded": _sorted((slice._rewarded_enemies as Dictionary).keys()),
		}))
	var trail: Array = [first.life]
	for attempt: int in 6:
		if not first.is_alive():
			break
		_stand_facing(first.global_position - forward * 1.0, forward)
		await _settle(1)
		var before: float = first.life
		slice.force_next_aim_for_verification(area)
		player.attack.press()
		player.attack.release_input()
		for frame: int in 180:
			await physics_frame
			if first.life < before and player.attack.phase == QuickStrikeAction.Phase.READY:
				break
		if first.life != float(trail[trail.size() - 1]):
			trail.append(first.life)
	await _settle(20)
	return {"dead": not first.is_alive(), "trail": trail, "heard": heard, "connections": connections,
		"player_id": player.get_instance_id(), "first_id": first.get_instance_id(), "latch": slice._drop_granted}


func _route_f5_with_a_stale_destination() -> Dictionary:
	var player: PrototypePlayer = slice.player
	_quiet()
	await _until_neutral()
	var ahead: Vector3 = player.global_position + _route() * 4.0
	var resolution: Dictionary = PrototypeGroundPointer.resolve_to_navigation(slice.navigation_map(), ahead)
	player.command_move_to(resolution["point"], ahead, bool(resolution["adjusted"]))
	await _settle(10)
	var staged: float = _planar_gap(player.global_position, slice.broken_watch.entry())
	slice.restart_current_slice("quick restart")
	var record: Dictionary = _reading()
	record["both_reset"] = _both_at_their_spawns()
	record["staged_distance"] = 4.0
	record["call_gap"] = record["gap"]
	_isolate()
	var window: Dictionary = await _window()
	record.merge(window, true)
	return record


func _route_fallen_restart() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var second: PrototypeGraveblade = slice.graveblades[1]
	_quiet()
	await _until_neutral()
	_stand_facing(slice.broken_watch.entry(), _route())
	second.place_at(slice.broken_watch.entry() + _route() * 1.2)
	second.face_instantly(-_route())
	await _settle(2)
	for guard: int in 8:
		if not player.is_alive():
			break
		var taken: int = player.damage_taken_events
		var began: bool = false
		for attempt: int in 120:
			began = second.begin_attack_for_verification()
			if began:
				break
			await physics_frame
		if not began:
			break
		for frame: int in 180:
			await physics_frame
			if player.damage_taken_events > taken:
				break
	_quiet()
	for frame: int in 240:
		await _await_process_frames(1)
		if slice.fallen_overlay.is_open:
			break
	var opened: bool = slice.fallen_overlay.is_open
	var latched: Array = []
	var on_cleared: Callable = func(reason: String) -> void: latched.append("%s|%s" % [reason, player.neutral_reason])
	player.movement_intent_cleared.connect(on_cleared)
	if opened:
		_push_key(KEY_ENTER, true)
		_push_key(KEY_ENTER, false)
		await _await_process_frames(2)
	player.movement_intent_cleared.disconnect(on_cleared)
	var record: Dictionary = _reading()
	for entry: String in latched:
		if entry.get_slice("|", 1) == ENCOUNTER_RESET:
			record["latch"] = ENCOUNTER_RESET
	record["opened"] = opened
	record["trail"] = [player.life]
	record["both_reset"] = _both_at_their_spawns()
	record["call_gap"] = record["gap"]
	_isolate()
	var window: Dictionary = await _window()
	record.merge(window, true)
	return record


func _both_at_their_spawns() -> bool:
	var reset: bool = true
	for index: int in slice.graveblades.size():
		var home: Vector3 = slice.broken_watch.first_encounter_spawn() if index == 0 else slice.broken_watch.second_encounter_spawn()
		reset = reset and _planar_gap(slice.graveblades[index].global_position, home) < 0.05
	return reset


func _reading() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var entry: Vector3 = slice.broken_watch.entry()
	return {
		"gap": _planar_gap(player.global_position, entry), "alive": player.is_alive(),
		"destination": player.has_destination, "latch": player.neutral_reason,
		"attacking": player.attack != null and player.attack.busy(),
	}


func _isolate() -> void:
	_quiet()
	slice.graveblades[0].place_at(slice.landing_layout.player_start())


func _window() -> Dictionary:
	var player: PrototypePlayer = slice.player
	var entry: Vector3 = slice.broken_watch.entry()
	var worst: float = 0.0
	var fastest: float = 0.0
	for frame: int in WINDOW_FRAMES:
		await physics_frame
		worst = maxf(worst, _planar_gap(player.global_position, entry))
		fastest = maxf(fastest, Vector2(player.velocity.x, player.velocity.z).length())
	return {"max_gap": worst, "max_speed": fastest, "end_gap": _planar_gap(player.global_position, entry)}


# --- Helpers ---------------------------------------------------------------------------------------

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


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true


func _note(text: String) -> void:
	if not _staged.has(text):
		_staged.append(text)


func _argument_value(flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


## Applies each [after, before] pair once; `unique` is false if any `after` does not occur at all.
func _put_back(text: String, pairs: Array) -> Dictionary:
	var unique: bool = true
	for pair: Array in pairs:
		if text.count(String(pair[0])) < 1:
			unique = false
		text = text.replace(String(pair[0]), String(pair[1]))
	return {"text": text, "unique": unique}


## Verification Maintenance V1's own resolver (decision D-342): a pair-list name resolves through the one
## provenance engine, and only while that engine is at its pinned SHA-256; otherwise every name resolves to an
## empty list, so every reconstruction that needs one fails.
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


func _all_suite_paths() -> PackedStringArray:
	var paths: PackedStringArray = PackedStringArray()
	for row: Array in MOVED_SUITE_ROWS:
		paths.append(String(row[0]))
	for row: Array in MAINTENANCE_MOVES:
		paths.append(String(row[0]))
	paths.append(SLICE_SCRIPT)
	return paths


func _load(path: String) -> Node:
	var changed: Error = change_scene_to_packed(load(path) as PackedScene)
	for frame: int in 90:
		await process_frame
		if current_scene != null and current_scene.scene_file_path == path:
			break
	if changed != OK or current_scene == null or current_scene.scene_file_path != path:
		_failures.append("%s did not load" % path.get_file())
		return null
	return current_scene


## Waits until the map answers for THIS scene, not merely until some map has an iteration: the entry's own
## closest point must land on it.
func _await_navigation() -> void:
	for frame: int in 900:
		if NavigationServer3D.map_get_regions(slice.navigation_map()).size() == 1:
			var entry: Vector3 = slice.broken_watch.entry()
			if _planar_gap(NavigationServer3D.map_get_closest_point(slice.navigation_map(), entry), entry) < 0.05:
				break
		await physics_frame
	await _settle(10)


func _settle(frames: int) -> void:
	for frame: int in frames:
		await physics_frame


func _await_process_frames(frames: int) -> void:
	for frame: int in frames:
		await process_frame


func _until_neutral() -> void:
	for frame: int in 90:
		if not slice.player.awaiting_neutral:
			return
		await physics_frame


## Staging, exactly as J10 stages: the position is written BEFORE a window opens, never inside one.
func _stand_facing(at: Vector3, facing: Vector3) -> void:
	slice.player.global_position = Vector3(at.x, 0.0, at.z)
	slice.player.velocity = Vector3.ZERO
	slice.player.clear_movement_intent("verification staging", false)
	slice.camera_rig.focus = slice.player.global_position
	slice.player.face_instantly(facing)


func _quiet() -> void:
	for enemy: PrototypeGraveblade in slice.graveblades:
		enemy.set_ai_enabled(false)


func _local(at: Vector3) -> Vector3:
	return slice.landing_layout.global_transform * at


func _to_local(at: Vector3) -> Vector3:
	return slice.landing_layout.global_transform.affine_inverse() * at


func _route() -> Vector3:
	return slice.route_forward()


func _planar_gap(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()


func _overlaps(at: Vector3) -> Array:
	var shape: CapsuleShape3D = CapsuleShape3D.new()
	shape.radius = 0.40
	shape.height = 1.80
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
			if owner != null:
				path = owner.name
				if owner.shape is BoxShape3D:
					size = (owner.shape as BoxShape3D).size
		found.append({"path": path, "size": size, "tall": size == Vector3.ZERO or size.y > 0.3})
	return found


func _children_of(node: Node, container: String) -> int:
	var holder: Node = node.get_node_or_null(container)
	return 0 if holder == null else holder.get_child_count()


func _descend(node: Node) -> Array:
	var all: Array = [node]
	for child: Node in node.get_children():
		all.append_array(_descend(child))
	return all


func _log_count(token: String) -> int:
	var count: int = 0
	for line: String in slice.log_lines:
		if line.contains(token):
			count += 1
	return count


func _push_key(key: Key, pressed: bool) -> void:
	var event: InputEventKey = InputEventKey.new()
	event.keycode = key
	event.physical_keycode = key
	event.pressed = pressed
	Input.parse_input_event(event)


func _sorted(values: Array) -> Array:
	var copy: Array = values.duplicate()
	copy.sort()
	return copy


func _floats(values: Array) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for value: Variant in values:
		parts.append("%d" % int(round(float(value))))
	return " -> ".join(parts)


func _bare(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


func _declared_functions(source: String) -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	var pattern: RegEx = RegEx.create_from_string("(?m)^(?:static )?func ([A-Za-z0-9_]+)\\(")
	for found: RegExMatch in pattern.search_all(source):
		names.append(found.get_string(1))
	return names


func _function_body(source: String, name: String) -> String:
	var body: PackedStringArray = PackedStringArray()
	var inside: bool = false
	for line: String in source.split("\n"):
		if line.begins_with("func %s(" % name) or line.begins_with("static func %s(" % name):
			inside = true
			continue
		if inside and not line.is_empty() and not line.begins_with("\t"):
			break
		if inside:
			body.append(line)
	return "\n".join(body)


func _code_lines(body: String) -> PackedStringArray:
	var lines: PackedStringArray = PackedStringArray()
	for line: String in body.split("\n"):
		var stripped: String = line.strip_edges()
		if stripped.is_empty() or stripped.begins_with("#"):
			continue
		lines.append(stripped)
	return lines


func _files_under(root: String, extensions: Array[String]) -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	var directory: DirAccess = DirAccess.open(root)
	if directory == null:
		return found
	for name: String in directory.get_files():
		for extension: String in extensions:
			if name.ends_with(extension):
				found.append(root.path_join(name))
	for name: String in directory.get_directories():
		found.append_array(_files_under(root.path_join(name), extensions))
	return found
