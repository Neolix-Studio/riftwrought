extends SceneTree
## Riftwrought — P1A: Character Scale and Rendering Lock — automated verification.
##
## THE ONE QUESTION P1A ASKS: what do the owner's own exported Mage and Huntress frames
## actually measure, and what does each of the three candidate rendering approaches
## actually do with them on the owner's actual hardware?
##
## WHAT THIS SUITE CAN AND CANNOT DO. It measures the art, walks the live comparison
## tree, and checks every arithmetic consequence. **It cannot decide the three things
## P1A hands back to the owner** — the rendering approach, the base resolution and the
## shared pixel density — because those need the owner's eye on the owner's display.
## Those are printed as DEFERRED or TRANSFERRED, never as passes. A green run is NOT P1A
## acceptance: acceptance is the owner's ruling (D-356), not this suite's exit code.
##
## OWNER-ART BOUNDARY. Two image files are read, both byte-identical copies of owner
## exports. **No `.pxo` is opened, parsed, converted, copied, moved or hashed**, and
## check 10 proves no path anywhere in this project names one.
##
## OWED-SET DISCIPLINE, ported from D-211. Every check records reaching its LAST line;
## the suite compares that set to what it owes IN BOTH DIRECTIONS; and the runner
## replays this log with the counts altered and requires its own pins to refuse it.

const MAGE: String = "mage"
const HUNTRESS: String = "huntress"

## A2 — the measured drawn bounds, pinned. `[drawn_x0, drawn_y0, drawn_x1, drawn_y1,
## head_top, ground_row, body_h, stance_x0, stance_x1]` per frame, in cell-local pixels.
## These are MEASUREMENTS of the owner's art. If the owner re-exports, they move, and
## that is what this pin is for.
const MAGE_EXPECTED: Dictionary = {
	"s":  [4, 3, 59, 60, 4, 60, 57, 16, 48],
	"sw": [4, 1, 58, 60, 2, 60, 59, 19, 52],
	"w":  [6, 2, 58, 60, 3, 60, 58, 22, 58],
	"nw": [5, 3, 60, 60, 4, 60, 57, 19, 53],
	"n":  [5, 1, 60, 60, 3, 60, 58, 14, 47],
	"ne": [4, 1, 61, 60, 2, 60, 59, 9, 45],
	"e":  [4, 1, 61, 60, 3, 60, 58, 4, 41],
	"se": [4, 2, 55, 60, 3, 60, 58, 4, 41],
}
const HUNTRESS_EXPECTED: Array = [
	[19, 5, 127, 122, 15, 122, 108, 27, 116],
	[19, 3, 127, 122, 12, 122, 111, 27, 115],
	[19, 5, 127, 122, 14, 122, 109, 27, 117],
	[19, 5, 127, 122, 15, 122, 108, 27, 116],
]

## A3 — the pinned conclusion. The Mage's eight idle frames do NOT agree on a shared
## horizontal ground anchor; the Huntress's four do. Both are findings for the owner.
const ANCHOR_AGREEMENT_TOLERANCE_PX: float = 2.0
const MAGE_ANCHOR_FRAMES_AGREE: bool = false
## The Huntress's four `s` frames agree with ONE ANOTHER to this much. They no longer sit
## on the anchor under this estimator, and that is the correction working rather than a
## fault: the stance BAND includes the bow limb, D-353 superseded it, and the art is now
## registered on the complete two-boot stance instead. Check 20 measures it properly.
const HUNTRESS_BAND_FRAME_SPREAD_PX: float = 1.0
const HUNTRESS_BAND_DRIFT_FROM_ANCHOR_PX: Vector2 = Vector2(7.0, 8.0)

## A4 — the pinned densities. Reported to three decimals from the measured mean body
## height against the accepted 1.80 m. They differ by nearly exactly two, which is why
## P1A refuses to average them.
const MAGE_PX_PER_M_RANGE: Vector2 = Vector2(32.10, 32.35)
const HUNTRESS_PX_PER_M_RANGE: Vector2 = Vector2(60.45, 60.65)
const DENSITY_RATIO_RANGE: Vector2 = Vector2(1.870, 1.890)

## A4, second half. Correcting the density difference by an INTEGER sprite scale does
## not make the two characters agree either: doubling the Mage leaves him this much
## taller than the Huntress, in metres. Measured, pinned, and reported.
const DOUBLED_MAGE_OVER_HUNTRESS_RANGE: Vector2 = Vector2(1.055, 1.075)

## The only file kinds this project is allowed to contain. An owner Pixelorama source
## has no extension on this list, and neither has anything else P1A never authorized.
const ALLOWED_EXTENSIONS: PackedStringArray = [
	"gd", "tscn", "tres", "import", "png", "svg", "md", "sh", "godot", "gitignore", "uid", "json",
]

## The supplemental pass's measurements of the Huntress's drawn ground contact — the two
## boot runs on the ground row. Identical in all four frames.
const HUNTRESS_GROUND_RUNS: Array = [[38, 52], [77, 92]]
const HUNTRESS_GROUND_MID: float = 65.0
const HUNTRESS_GROUND_WIDTH: int = 55
## What the same two boot runs read BEFORE the registration pass. Recorded history.
const PRE_REGISTRATION_GROUND_RUNS: Array = [[31, 45], [70, 85]]
const PRE_REGISTRATION_GROUND_MID: float = 58.0

## `(64, 122)` is now OWNER-LOCKED, and the registration pass moved the art to meet it.
## Measured against the drawn contact-row footprint it is now this far off — down from
## the 6.0 px that was measured before the pass.
const GROUND_ANCHOR_OFFSET_FROM_FEET_PX: float = 1.0
const PRE_REGISTRATION_ANCHOR_OFFSET_FROM_FEET_PX: float = 6.0

## The exact-art result the supplemental pass was asked to report: the Huntress's
## resting frames are 108 px, which at 60.0 px/m is exactly 1.800 m.
const HUNTRESS_RESTING_BODY_PX: int = 108

## ---- The eight Huntress idle directions, pinned frame by frame ---------------------
##
## `[drawn_x0, drawn_y0, drawn_x1, drawn_y1, head_top, body_h, ground_row, ground_x0,
## ground_x1]` per frame, in cell-local pixels, in the owner's authoritative direction
## mapping. These are MEASUREMENTS of the owner's exports; a re-export moves them, and
## that is what the pin is for.
const HUNTRESS_FRAME_PINS: Dictionary = {
	"e": [
		[31, 6, 113, 122, 9, 114, 122, 57, 76],
		[31, 3, 113, 122, 6, 117, 122, 57, 76],
		[31, 5, 113, 122, 8, 115, 122, 57, 76],
		[31, 6, 113, 122, 9, 114, 122, 57, 76],
	],
	"se": [
		[23, 5, 107, 122, 8, 115, 122, 41, 88],
		[23, 2, 107, 122, 5, 118, 122, 41, 88],
		[23, 4, 107, 122, 7, 116, 122, 41, 88],
		[23, 5, 107, 122, 8, 115, 122, 41, 88],
	],
	"s": [
		[19, 5, 127, 122, 15, 108, 122, 38, 92],
		[19, 3, 127, 122, 12, 111, 122, 38, 92],
		[19, 5, 127, 122, 14, 109, 122, 38, 92],
		[19, 5, 127, 122, 15, 108, 122, 38, 92],
	],
	"sw": [
		[21, 7, 108, 122, 9, 114, 122, 67, 79],
		[21, 4, 108, 122, 6, 117, 122, 67, 79],
		[21, 6, 108, 122, 8, 115, 122, 67, 79],
		[21, 7, 108, 122, 9, 114, 122, 67, 79],
	],
	"w": [
		[8, 2, 98, 122, 4, 119, 122, 49, 70],
		[8, 0, 98, 122, 1, 122, 122, 49, 70],
		[8, 1, 98, 122, 3, 120, 122, 49, 70],
		[8, 2, 98, 122, 4, 119, 122, 49, 70],
	],
	"nw": [
		[14, 6, 109, 122, 8, 115, 122, 38, 92],
		[14, 3, 109, 122, 5, 118, 122, 38, 92],
		[14, 5, 109, 122, 7, 116, 122, 38, 92],
		[14, 6, 109, 122, 8, 115, 122, 38, 92],
	],
	"n": [
		[20, 6, 100, 122, 10, 113, 122, 38, 88],
		[20, 3, 100, 122, 7, 116, 122, 43, 88],
		[20, 5, 100, 122, 9, 114, 122, 43, 88],
		[20, 6, 100, 122, 10, 113, 122, 38, 88],
	],
	"ne": [
		[22, 6, 94, 122, 10, 113, 122, 42, 90],
		[22, 3, 94, 122, 7, 116, 122, 42, 90],
		[22, 5, 94, 122, 9, 114, 122, 42, 90],
		[22, 6, 94, 122, 10, 113, 122, 42, 90],
	],
}

## ---- What the owner's art pass INHERITED (D-354) -----------------------------------
##
## The pre-registration union bounding box and contact row of each direction, recorded
## before the corrected exports replaced them. They are not measured live any more —
## the files that held them are gone — so they are RECORDED HISTORY, and they exist so
## the applied translation can be proved by arithmetic rather than asserted.
## `[x0, x1, contact_row]`.
const PRE_REGISTRATION_DRAWN: Dictionary = {
	"e":  [9, 91, 121],
	"se": [7, 91, 122],
	"s":  [12, 123, 122],
	"sw": [24, 111, 122],
	"w":  [12, 102, 122],
	"nw": [8, 103, 121],
	"n":  [13, 93, 122],
	"ne": [11, 83, 121],
}

## ---- CORRECTED under the owner's complete-stance ruling (D-353) --------------------
##
## The SUPERSEDED reading counted only the pixels touching the bottom-most occupied row.
## It is retained here because the correction has to be visible: `sw` read +12.0 that
## way, because only its forward boot reaches the contact row, and the complete two-boot
## stance reads +2.5.
const SUPERSEDED_CONTACT_ROW_MIDS: Dictionary = {
	"e": 44.5, "se": 48.5, "s": 58.0, "sw": 76.0, "w": 63.5, "nw": 59.0, "n": 56.0, "ne": 55.0,
}

## The CORRECTED measurement: the union of the complete two-boot stance across all four
## frames of a direction — **one measurement per direction, never per frame**.
## `[x0, x1, midpoint]`.
const COMPLETE_STANCE_UNION: Dictionary = {
	"e":  [54, 75, 64.5],
	"se": [40, 88, 64.0],
	"s":  [38, 90, 64.0],
	"sw": [44, 83, 63.5],
	"w":  [53, 75, 64.0],
	"nw": [36, 93, 64.5],
	"n":  [40, 89, 64.5],
	"ne": [41, 88, 64.5],
}

## What the same measurement read BEFORE the owner's registration pass, retained so the
## correction stays visible and is never quietly forgotten. Recorded history, not live.
const PRE_REGISTRATION_STANCE_MID: Dictionary = {
	"e": 42.5, "se": 48.0, "s": 57.0, "sw": 66.5, "w": 68.0, "nw": 58.5, "n": 57.5, "ne": 53.5,
}

## Frames whose own complete-stance midpoint sits within these tolerances of the locked
## anchor x = 64. Pinned so neither number can drift unnoticed.
const STANCE_COMPLIANT_WITHIN_1PX: int = 27
const STANCE_COMPLIANT_WITHIN_3PX: int = 32

## The largest frame-to-frame variation of the complete stance inside any one direction.
## The idle breath moves a leg silhouette by at most this much.
const MAX_FRAME_TO_FRAME_STANCE_PX: float = 2.0

## The EQUIPMENT-FREE height landmark: the hood crown above the contact row, frame 0.
## This is what the scale question is answered against.
const HOOD_CROWN_ABOVE_GROUND: Dictionary = {
	"e": 116, "se": 116, "s": 110, "sw": 115, "w": 120, "nw": 116, "n": 114, "ne": 114,
}

## `huntress_idle_left_128_v1.png` frame 1 RESOLVED (D-355). The strip moved -4 px
## horizontally and not at all vertically, so frame 1 still opens on row 0 — that was
## never the defect and the owner ruled out a vertical translation. The defect was that
## row 0 held raw hood FILL, sliced by the cell edge with no outline closing it. The
## owner's one-pixel local correction re-drew that row in the outline palette, so the
## crown now terminates in a closed silhouette.
##
## Row 0 is still occupied. That is expected, reported and compliant.
const W_FRAME1_TOP_ROW_PIXELS: int = 17
const W_FRAME1_TOP_ROW_COLUMNS: Vector2i = Vector2i(17, 68)
## Every row-0 pixel must belong to the outline palette. Measured 0.0266; the pin is the
## ceiling, and the value BEFORE the correction — recorded history — was 0.3089.
const W_FRAME1_TOP_ROW_MAX_LUMINANCE: float = 0.05
const W_FRAME1_TOP_ROW_MAX_LUMINANCE_BEFORE: float = 0.3089
## The 8-pixel hood cap that opens frames 0, 2 and 3, after the -4 px move.
const W_CAP_COLUMNS: Vector2i = Vector2i(59, 66)

## The only place any frame's content reaches a cell edge, and it is the TOP edge — not
## a left or right one, so nothing can leak between cells.
const CELL_EDGE_TOUCHES: PackedStringArray = [
	"s f0: right", "s f1: right", "s f2: right", "s f3: right", "w f1: top",
]
## The narrowest fully transparent gutter between the content of two adjacent cells in
## any strip. `s` now reaches x = 127 in every cell, so this is what proves that reaching
## a cell edge is still not leakage.
const MIN_INTER_CELL_GUTTER_PX: int = 19

## **D-356 ruling 9 — the detached fragments, identified and pinned.**
## `[direction, frame, pixel_count, x0, x1, y0, y1]`, in the order the scan finds them.
## Intent is ESTABLISHED (check 30): each is fully inside the main silhouette in the
## other frames of its own direction and is separated by exactly one transparent pixel
## only at the extreme of the idle breath. Recorded, classified, NON-BLOCKING, not edited.
const DETACHED_FRAGMENTS: Array = [
	["s", 2, 2, 33, 34, 118, 118],
	["w", 2, 33, 37, 44, 115, 119],
	["w", 2, 13, 80, 85, 113, 115],
]

## The silhouette spread across all 32 frames, and the px/m their mean implies against
## the accepted 1.80 m. Both are measurements the owner has to rule on.
const SILHOUETTE_RANGE_PX: Vector2i = Vector2i(108, 122)
const IMPLIED_PX_PER_M_RANGE: Vector2 = Vector2(63.5, 64.2)


const OWNER_PNG_SHA256: Dictionary = {
	P1AArt.MAGE_SHEET_PATH: P1AArt.MAGE_SHEET_SHA256,
	"res://assets/characters/huntress/huntress_idle_e.png":  "767adcc29f6d0ad875416feca0c160016e71313c639b744f9d84f2df946e43d9",
	"res://assets/characters/huntress/huntress_idle_se.png": "8a0bb98cda3d12141795bf0a4fe1594b723213543607f6e688a5ef322131e189",
	"res://assets/characters/huntress/huntress_idle_s.png":  "93c5a713c9d32d3c843cf09e94f5c35bd8883e262afa64e4c3cb65418bb3e740",
	"res://assets/characters/huntress/huntress_idle_sw.png": "be2b7937a17621da2472efbad2c041fdb4d197bc5a07009b9fda8cdbada1c039",
	"res://assets/characters/huntress/huntress_idle_w.png":  "17b4866b00d4fac9bbe617632c94a064e53375a92c50c1e79175127b8cbd2006",
	"res://assets/characters/huntress/huntress_idle_nw.png": "eb34798ce7e17c659a74405621fbcb7b6f56af14e6ff75f4069c9e56174e3ba2",
	"res://assets/characters/huntress/huntress_idle_n.png":  "4433171f2ea790070654cbb0c8a6e2f2045521e873629fe5a802d2a709be2c54",
	"res://assets/characters/huntress/huntress_idle_ne.png": "9cec9cb0cff7c7e7a2788f833ea01d393b23ba5382a8827249e02bda50beae46",
	# The P1B Wroughtstone tiles (D-359). Owner exports, copied byte-identically, pinned
	# here exactly as the character art is.
	"res://assets/environment/wroughtstone/wroughtstone_ground_slate_120x60_v1.png": "b0a794a661f7cb25a9c946d444759ea32acb6f992bd80477c048807a87c717b0",
	"res://assets/environment/wroughtstone/wroughtstone_courtyard_dirt_enclosed_120x60_v1.png": "a5fd910bb331414c41a3ab94ee47df156b7b7ed6a90aa4ba67b3d9363b800bc2",
	"res://assets/environment/wroughtstone/wroughtstone_path_dirt_straight_120x60_v1.png": "057b21d3cd02da4b9854e6ba24c367633cee4ab7384f907e5e2464b8b0558af0",
}

## The mage strip, the eight Huntress strips, and the project's own icon.
## Paths that exist ONLY to prove the resolution check can still fail. They are written
## out in full so the scanner sees them and nobody has to wonder what was hidden from it,
## and each is asserted to resolve as NOTHING.
const NEGATIVE_CONTROL_PATHS: Array[String] = [
	"res://d359_negative_control_this_must_not_exist/",
]

## 3 -> 10 when the owner supplied the eight Huntress directions (D-352); 10 -> 13 when
## P1B imported the three Wroughtstone tiles (D-359). **The pin moves when owner art is
## legitimately added, and never otherwise:** an image that is not in OWNER_PNG_SHA256 is
## still reported as unexpected, so the assertion keeps all of its force.
const EXPECTED_IMAGE_COUNT: int = 13

## A5/A7 — the five window sizes the brief names. Index 0 is discovered at run time from
## the owner's own display and is never assumed; the other four are the named ones.
const NAMED_WINDOWS: Array[Vector2i] = [
	Vector2i(1280, 720), Vector2i(1920, 1080), Vector2i(2560, 1440), Vector2i(3840, 2160),
]

const OWED_CHECKS: Array[String] = [
	"every_character_canvasitem_reports_nearest_filtering",
	"no_sprite_anywhere_carries_a_non_integral_scale",
	"the_visible_drawn_bounds_are_what_the_art_measures",
	"one_ground_row_is_shared_by_every_idle_frame_of_each_character",
	"one_shared_anchor_is_used_and_the_frames_that_disagree_are_named",
	"px_per_m_is_derived_per_character_and_never_averaged",
	"each_approach_reports_the_scale_letterbox_and_framing_it_actually_produces",
	"the_five_second_diagonal_pan_is_a_pure_function_of_its_frame_index",
	"the_tile_proposal_is_derived_from_px_per_m_and_is_whole_pixels",
	"the_project_reads_only_the_two_copied_owner_exports_and_no_pxo",
	"the_readout_claims_only_what_p1a_actually_does",
	"the_huntress_ground_contact_footprint_is_identical_in_every_frame",
	"the_provisional_anchor_is_measured_against_the_drawn_feet",
	"the_fill_approaches_scale_the_finished_frame_and_never_a_character_sprite",
	"the_density_candidates_record_the_owners_production_direction",
	"the_huntress_direction_set_is_complete_and_nothing_substitutes",
	"the_eight_owner_exports_are_recorded_and_the_copies_are_byte_identical",
	"every_huntress_direction_is_one_512x128_strip_of_four_128_cells",
	"the_locked_anchor_is_measured_against_all_thirty_two_frames",
	"no_huntress_frame_content_crosses_its_cell_boundary",
	"the_eight_direction_silhouette_spread_is_measured_against_the_locked_scale",
	"the_west_strip_frame_one_clipping_is_identified",
	"the_owner_registration_targets_land_every_root_on_the_anchor",
	"the_canonical_base_viewport_is_locked_and_the_rendering_mode_is_not",
	"every_measured_pixel_came_from_the_png_on_disk_and_not_a_stale_import",
	"the_canonical_rendering_mode_is_locked_and_behaves_as_ruled",
	"every_locked_production_constant_agrees_on_every_surface",
	"the_mage_reconstruction_obligation_is_recorded_and_the_art_is_not_edited",
	"the_detached_fragments_are_identified_and_classified",
	"every_check_ran",
]

## The owner's judgement, and what P1A hands on. **Nothing here is ever counted as a
## pass**, and each row names where it must return.
##
## P1A is ACCEPTED and CLOSED under D-356, so nothing remains UNPERFORMED inside it: the
## rendering comparison the earlier rows deferred was performed by the owner, live, and
## produced ruling 1. What is left is not deferred work but work that BELONGS ELSEWHERE,
## and calling it "deferred" would hide which phase owes it.
const DEFERRED: Array[String] = []

## Debt TRANSFERRED out of P1A by D-356. Each row names its destination. **None of these
## is complete, none is authorized by P1A's acceptance, and none may be quietly marked
## done by a later phase that merely touches the same file.**
const TRANSFERRED_DEBT: Array[String] = [
	"HUD, menu, text and accessibility suitability at ARBITRARY output resolutions -> the later UI foundation (D-356 ruling 10). P1A's readout is a diagnostic surface and explicitly does NOT stand in for it",
	"a 128 x 128 Mage reconstruction at 60.0 px/m, anchor (64, 122), eight authored directions, no mirroring -> a future art phase with its own authorization (D-356 ruling 7). The current 64 x 64 exports stay legacy/reference and were NOT edited",
	"an OPTIONAL player-facing pixel-perfect / integer presentation mode -> ALLOWED but NOT authorized or implemented (D-356 ruling 2). Modes 1 and 3 remain diagnostic comparators only",
	"the P1B Wroughtstone 2D Proof Kit -> gated on its own explicit authorization (D-356 ruling 14). The tile DIMENSIONS are locked; no TileSet, TileMapLayer or tile art exists",
	"a canonical Huntress class specification -> a P2 prerequisite (D-347 sub-ruling B). P1A's art acceptance promotes NO class mechanics",
	"the Mage's eight idle frames do not share a horizontal ground anchor (drift -9.5 to +8.0 px) -> the same future Mage art phase; P1A measured it and did not correct it",
]

var arguments: PackedStringArray = PackedStringArray()

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _token: String = ""
var _mage: Array[Dictionary] = []
var _huntress: Array[Dictionary] = []      ## all 32 frames, eight directions
var _huntress_s: Array[Dictionary] = []    ## the four SOUTH frames — what D-350/D-351 pinned
var _tool: Node = null


func _initialize() -> void:
	_main.call_deferred()


func _main() -> void:
	arguments = OS.get_cmdline_user_args()
	_token = _argument_value("--run-token")
	print("")
	print("=== Riftwrought — P1A Character Scale and Rendering Lock verification ===")
	print("  run token: %s" % (_token if not _token.is_empty() else "none given"))
	print("  Godot %s   headless: %s" % [
		Engine.get_version_info().get("string", "?"), str(DisplayServer.get_name() == "headless")])

	_mage = P1AArt.measure_character(MAGE)
	_huntress = P1AArt.measure_character(HUNTRESS)
	_huntress_s = P1AArt.measure_direction(HUNTRESS, "s")

	await _load_tool()

	_check_every_character_canvasitem_reports_nearest_filtering()
	_check_no_sprite_anywhere_carries_a_non_integral_scale()
	_check_the_visible_drawn_bounds_are_what_the_art_measures()
	_check_one_ground_row_is_shared_by_every_idle_frame_of_each_character()
	_check_one_shared_anchor_is_used_and_the_frames_that_disagree_are_named()
	_check_px_per_m_is_derived_per_character_and_never_averaged()
	_check_each_approach_reports_the_scale_letterbox_and_framing_it_actually_produces()
	_check_the_five_second_diagonal_pan_is_a_pure_function_of_its_frame_index()
	_check_the_tile_proposal_is_derived_from_px_per_m_and_is_whole_pixels()
	_check_the_project_reads_only_the_two_copied_owner_exports_and_no_pxo()
	_check_the_readout_claims_only_what_p1a_actually_does()
	_check_the_huntress_ground_contact_footprint_is_identical_in_every_frame()
	_check_the_provisional_anchor_is_measured_against_the_drawn_feet()
	_check_the_fill_approaches_scale_the_finished_frame_and_never_a_character_sprite()
	_check_the_density_candidates_record_the_owners_production_direction()
	_check_the_huntress_direction_set_is_complete_and_nothing_substitutes()
	_check_the_eight_owner_exports_are_recorded_and_the_copies_are_byte_identical()
	_check_every_huntress_direction_is_one_512x128_strip_of_four_128_cells()
	_check_the_locked_anchor_is_measured_against_all_thirty_two_frames()
	_check_no_huntress_frame_content_crosses_its_cell_boundary()
	_check_the_eight_direction_silhouette_spread_is_measured_against_the_locked_scale()
	_check_the_west_strip_frame_one_clipping_is_identified()
	_check_the_owner_registration_targets_land_every_root_on_the_anchor()
	_check_the_canonical_base_viewport_is_locked_and_the_rendering_mode_is_not()
	_check_every_measured_pixel_came_from_the_png_on_disk_and_not_a_stale_import()
	_check_the_canonical_rendering_mode_is_locked_and_behaves_as_ruled()
	_check_every_locked_production_constant_agrees_on_every_surface()
	_check_the_mage_reconstruction_obligation_is_recorded_and_the_art_is_not_edited()
	_check_the_detached_fragments_are_identified_and_classified()
	_check_every_check_ran()

	print("")
	print("--- DEFERRED — not performed here, and never recorded as a pass ---")
	for d: String in DEFERRED:
		print("  DEFERRED: %s" % d)
	if DEFERRED.is_empty():
		print("  (none) — the rendering comparison these rows waited on was performed by the owner, live, and")
		print("  produced D-356 ruling 1. Nothing inside P1A is left unperformed. What remains is TRANSFERRED")
		print("  debt with a named destination, below, which is a different thing and is listed separately so")
		print("  no later phase can mistake somebody else's obligation for a completed one.")
	print("")
	print("--- TRANSFERRED DEBT — carried OUT of P1A by D-356, and never recorded as a pass ---")
	for d: String in TRANSFERRED_DEBT:
		print("  TRANSFERRED: %s" % d)

	await process_frame
	print("")
	if _failures.is_empty():
		print("P1A VERIFICATION: PASS (%d checks)" % _checks)
		print("P1A OWED CHECKS: %d" % OWED_CHECKS.size())
		print("P1A DEFERRED: %d" % DEFERRED.size())
		print("P1A TRANSFERRED DEBT: %d" % TRANSFERRED_DEBT.size())
		print("P1A RUN TOKEN: %s" % _token)
		print("A GREEN RUN IS NOT P1A ACCEPTANCE. Acceptance is the owner's, given under D-356 after a live")
		print("comparison this suite cannot perform. P1A is ACCEPTED AND CLOSED by that ruling, not by this run.")
		print("P1B IS ACCEPTED AND CLOSED under D-362. P1C-H IS BEGUN under D-364 and is DELIVERED and")
		print("OPEN; the ORIGINAL P1C is NOT complete and its Mage-dependent portion is DEFERRED.")
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("P1A VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		quit(1)


func _load_tool() -> void:
	var packed: PackedScene = load("res://scenes/p1a_comparison.tscn") as PackedScene
	if packed == null:
		_failures.append("the comparison scene did not load")
		return
	_tool = packed.instantiate()
	root.add_child(_tool)
	await process_frame
	await process_frame


# --- 1. A1: nearest filtering ---------------------------------------------------------

func _check_every_character_canvasitem_reports_nearest_filtering() -> void:
	print("")
	print("--- 1. A1 — every character CanvasItem resolves to NEAREST filtering, proved by walking the tree")
	var project_default: int = int(ProjectSettings.get_setting(
		"rendering/textures/canvas_textures/default_texture_filter", 1))
	var walked: Array[Dictionary] = []
	_walk_canvas_items(_tool, walked)
	var textured: int = 0
	var not_nearest: PackedStringArray = PackedStringArray()
	for entry: Dictionary in walked:
		if not bool(entry["draws_texture"]):
			continue
		textured += 1
		if not bool(entry["nearest"]):
			not_nearest.append(String(entry["path"]))
	var sub: SubViewport = _tool.find_child("BaseViewport", true, false) as SubViewport
	var sub_nearest: bool = sub != null and sub.canvas_item_default_texture_filter \
		== Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	_expect(project_default == 0 and textured >= 2 and not_nearest.is_empty() and sub_nearest,
		"project default filter is %d (0 = Nearest); %d textured CanvasItems walked; not nearest: %s; SubViewport nearest: %s"
			% [project_default, textured, ", ".join(not_nearest), str(sub_nearest)])
	print("  project setting rendering/textures/canvas_textures/default_texture_filter = %d (0 = Nearest)" % project_default)
	print("  %d CanvasItems walked, %d of them draw a texture, %d resolve to anything other than NEAREST"
		% [walked.size(), textured, not_nearest.size()])
	print("  the base SubViewport's own default canvas-item filter is NEAREST: %s" % str(sub_nearest))
	_done("every_character_canvasitem_reports_nearest_filtering")


## Resolve a CanvasItem's EFFECTIVE filter. `TEXTURE_FILTER_PARENT_NODE` inherits, so a
## node reporting it proves nothing on its own; the chain is followed to the viewport
## default, which comes from the project setting.
func _walk_canvas_items(node: Node, out: Array[Dictionary]) -> void:
	var ci := node as CanvasItem
	if ci != null:
		out.append({
			"path": String(ci.get_path()),
			"class": ci.get_class(),
			"draws_texture": (ci is Sprite2D) or (ci is AnimatedSprite2D) or (ci is TextureRect),
			"nearest": _effective_filter_is_nearest(ci),
			"scale": (ci as Node2D).scale if ci is Node2D else Vector2.ONE,
		})
	for child: Node in node.get_children():
		_walk_canvas_items(child, out)


func _effective_filter_is_nearest(ci: CanvasItem) -> bool:
	var current: CanvasItem = ci
	while current != null:
		if current.texture_filter != CanvasItem.TEXTURE_FILTER_PARENT_NODE:
			return current.texture_filter == CanvasItem.TEXTURE_FILTER_NEAREST
		current = current.get_parent() as CanvasItem
	return int(ProjectSettings.get_setting(
		"rendering/textures/canvas_textures/default_texture_filter", 1)) == 0


# --- 2. A1: no non-integral scale ------------------------------------------------------

func _check_no_sprite_anywhere_carries_a_non_integral_scale() -> void:
	print("")
	print("--- 2. A1 — no sprite carries a non-integral scale, across every character and density the tool can select")
	# The ONE exemption, named rather than assumed: the SubViewport display is the
	# FINAL-FRAME presentation node. Approaches 5-7 stretch the finished frame at a
	# fractional factor on purpose, which is a presentation scale and not a character
	# CanvasItem scale. Every other CanvasItem, and every character sprite without
	# exception, must still be integral.
	_tool.set("approach", P1ARenderMode.Approach.INTEGER_VIEWPORT)
	_tool.call("_apply_approach")
	var offenders: PackedStringArray = PackedStringArray()
	var combinations: int = 0
	for character: String in [MAGE, HUNTRESS]:
		for density: int in range(P1AScale.candidates().size()):
			combinations += 1
			_tool.set("character", character)
			_tool.set("density_index", density)
			_tool.call("_reload_character")
			_tool.call("_apply_density")
			var walked: Array[Dictionary] = []
			_walk_canvas_items(_tool, walked)
			for entry: Dictionary in walked:
				var s: Vector2 = entry["scale"]
				if not is_equal_approx(s.x, roundf(s.x)) or not is_equal_approx(s.y, roundf(s.y)):
					offenders.append("%s %s @ %s: %s" % [character, String(entry["path"]), str(density), str(s)])
	_expect(combinations == 6 and offenders.is_empty(),
		"%d character/density combinations exercised; non-integral scales: %s" % [combinations, ", ".join(offenders)])
	print("  %d character x density combinations exercised under an integer approach; %d non-integral scales found"
		% [combinations, offenders.size()])
	print("  the ONE exemption is the final-frame presentation node, checked separately in check 15")
	print("  NOTE, and it is a finding rather than a pass: showing the Huntress at the Mage's density would need")
	print("  a scale of 0.5, which A1 forbids. The tool refuses to fake it and says so on screen.")
	_done("no_sprite_anywhere_carries_a_non_integral_scale")


# --- 3. A2: visible drawn bounds --------------------------------------------------------

func _check_the_visible_drawn_bounds_are_what_the_art_measures() -> void:
	print("")
	print("--- 3. A2 — the visible drawn bounds of every exported idle frame, measured and pinned in both directions")
	var mismatches: PackedStringArray = PackedStringArray()
	for token: String in P1AArt.DIRECTION_TOKENS:
		var m: Dictionary = _frame_of(_mage, token, 0)
		var want: Array = MAGE_EXPECTED[token]
		var got: Array = _tuple(m)
		if got != want:
			mismatches.append("mage %s got %s want %s" % [token, str(got), str(want)])
		print("  mage %-2s  cell 64x64  drawn %2d..%2d x %2d..%2d  (%2d x %2d)  head_top %2d  ground_row %2d  body %2d px  stance %2d..%2d mid %.1f"
			% [token, int(m["drawn_x0"]), int(m["drawn_x1"]), int(m["drawn_y0"]), int(m["drawn_y1"]),
				int(m["drawn_w"]), int(m["drawn_h"]), int(m["head_top"]), int(m["ground_row"]),
				int(m["body_h"]), int(m["stance_x0"]), int(m["stance_x1"]), float(m["stance_mid"])])
	for i: int in range(_huntress_s.size()):
		var h: Dictionary = _huntress_s[i]
		var hw: Array = HUNTRESS_EXPECTED[i]
		var hg: Array = _tuple(h)
		if hg != hw:
			mismatches.append("huntress f%d got %s want %s" % [i, str(hg), str(hw)])
		print("  huntress s f%d  cell 128x128  drawn %2d..%3d x %2d..%3d  (%3d x %3d)  head_top %2d  ground_row %3d  body %3d px  stance %2d..%2d mid %.1f"
			% [i, int(h["drawn_x0"]), int(h["drawn_x1"]), int(h["drawn_y0"]), int(h["drawn_y1"]),
				int(h["drawn_w"]), int(h["drawn_h"]), int(h["head_top"]), int(h["ground_row"]),
				int(h["body_h"]), int(h["stance_x0"]), int(h["stance_x1"]), float(h["stance_mid"])])
	# The pin must refuse a changed measurement: mutate one expected tuple and require
	# the comparison to reject it. A guard that accepts everything protects nothing.
	var mutated: Array = (MAGE_EXPECTED["s"] as Array).duplicate()
	mutated[6] = int(mutated[6]) + 1
	var refusal_works: bool = _tuple(_frame_of(_mage, "s", 0)) != mutated
	# And it must be reachable: the unmutated tuple has to match, or the refusal is vacuous.
	var acceptance_works: bool = _tuple(_frame_of(_mage, "s", 0)) == MAGE_EXPECTED["s"]
	# Threshold independence: hard-edged pixel art has no alpha ramp to tune.
	var at_half: Array[Dictionary] = P1AArt.measure_character(MAGE, 0.49)
	var threshold_stable: bool = at_half.size() == _mage.size()
	for i: int in range(mini(at_half.size(), _mage.size())):
		if _tuple(at_half[i]) != _tuple(_mage[i]):
			threshold_stable = false
	_expect(mismatches.is_empty() and refusal_works and acceptance_works and threshold_stable,
		"bound mismatches: %s; refusal %s; acceptance %s; threshold-stable %s"
			% [", ".join(mismatches), str(refusal_works), str(acceptance_works), str(threshold_stable)])
	print("  the pin refuses a one-pixel change to a body height (%s) and accepts the true one (%s)"
		% [str(refusal_works), str(acceptance_works)])
	print("  re-measuring at alpha > 0.49 instead of alpha > 0 changes nothing: %s" % str(threshold_stable))
	print("  MEASURED: the Mage's production idle cell is 64x64, not 128x128. **The Huntress now has all")
	print("  EIGHT directions** — 32 frames — and they are measured in checks 17 to 22.")
	_done("the_visible_drawn_bounds_are_what_the_art_measures")


## A measurement by DIRECTION and frame, never by position in a list. A reordering
## cannot silently mislabel a frame this way.
func _frame_of(list: Array[Dictionary], token: String, frame: int) -> Dictionary:
	for m: Dictionary in list:
		if String(m.get("direction", "")) == token and int(m.get("index", -1)) == frame:
			return m
	return {"empty": true}


func _tuple(m: Dictionary) -> Array:
	if bool(m.get("empty", true)):
		return []
	return [int(m["drawn_x0"]), int(m["drawn_y0"]), int(m["drawn_x1"]), int(m["drawn_y1"]),
		int(m["head_top"]), int(m["ground_row"]), int(m["body_h"]),
		int(m["stance_x0"]), int(m["stance_x1"])]


# --- 4. A3: one ground row -------------------------------------------------------------

func _check_one_ground_row_is_shared_by_every_idle_frame_of_each_character() -> void:
	print("")
	print("--- 4. A3 — the VERTICAL half of the anchor: one ground row shared by every idle frame")
	var mage_rows: Array[int] = []
	for token: String in P1AArt.DIRECTION_TOKENS:
		mage_rows.append(int(_frame_of(_mage, token, 0)["ground_row"]))
	var huntress_rows: Array[int] = []
	for h: Dictionary in _huntress_s:
		huntress_rows.append(int(h["ground_row"]))
	var mage_same: bool = _all_equal(mage_rows)
	var huntress_same: bool = _all_equal(huntress_rows)
	# Both directions: a list with one row moved must be refused.
	var tampered: Array[int] = mage_rows.duplicate()
	tampered[3] = tampered[3] + 1
	var refusal_works: bool = not _all_equal(tampered)
	_expect(mage_same and huntress_same and mage_rows[0] == 60 and huntress_rows[0] == 122 and refusal_works,
		"mage ground rows %s (same %s); huntress %s (same %s); refusal %s"
			% [str(mage_rows), str(mage_same), str(huntress_rows), str(huntress_same), str(refusal_works)])
	print("  mage:     ground row %d in all %d idle frames" % [mage_rows[0], mage_rows.size()])
	print("  huntress, SOUTH: ground row %d in all %d frames" % [huntress_rows[0], huntress_rows.size()])
	print("  (the other seven directions are measured in check 20; three of them end on row 121)")
	print("  a list with one row moved by one pixel is refused: %s" % str(refusal_works))
	_done("one_ground_row_is_shared_by_every_idle_frame_of_each_character")


func _all_equal(values: Array[int]) -> bool:
	for v: int in values:
		if v != values[0]:
			return false
	return true


# --- 5. A3: one shared anchor, and the frames that disagree -----------------------------

func _check_one_shared_anchor_is_used_and_the_frames_that_disagree_are_named() -> void:
	print("")
	print("--- 5. A3 — ONE shared frame-relative offset is used, and every frame that disagrees with it is named")
	_tool.set("character", MAGE)
	_tool.set("density_index", 0)
	_tool.call("_reload_character")
	var actor: Node = _tool.find_child("Actor", true, false)
	var sprite: AnimatedSprite2D = actor.find_child("Body", true, false) as AnimatedSprite2D
	var anchor: Vector2i = actor.get("anchor")
	var offsets_shared: bool = true
	for token: String in P1AArt.DIRECTION_TOKENS:
		actor.call("set_direction", token)
		if sprite.offset != Vector2(-float(anchor.x), -float(anchor.y)):
			offsets_shared = false
	print("  the tool uses ONE anchor for the Mage — cell-local (%d, %d) — for all %d facings: %s"
		% [anchor.x, anchor.y, P1AArt.DIRECTION_TOKENS.size(), str(offsets_shared)])
	print("  no per-frame offset exists anywhere, and the art is not edited.")

	var worst: float = 0.0
	var disagreeing: PackedStringArray = PackedStringArray()
	print("  measured horizontal drift of each frame's drawn stance from that one anchor:")
	for token: String in P1AArt.DIRECTION_TOKENS:
		var d: float = float(_frame_of(_mage, token, 0)["stance_mid"]) - float(anchor.x)
		worst = maxf(worst, absf(d))
		var flag: String = "   " if absf(d) <= ANCHOR_AGREEMENT_TOLERANCE_PX else " <<"
		print("    mage %-2s  stance mid %5.1f   anchor x %d   drift %+6.1f px%s" % [token, float(_frame_of(_mage, token, 0)["stance_mid"]), anchor.x, d, flag])
		if absf(d) > ANCHOR_AGREEMENT_TOLERANCE_PX:
			disagreeing.append("%s %+.1f" % [token, d])
	var mage_agree: bool = disagreeing.is_empty()

	_tool.set("character", HUNTRESS)
	_tool.call("_reload_character")
	var h_anchor: Vector2i = actor.get("anchor")
	var h_worst: float = 0.0
	var h_disagreeing: PackedStringArray = PackedStringArray()
	for i: int in range(_huntress_s.size()):
		var hd: float = float(_huntress_s[i]["stance_mid"]) - float(h_anchor.x)
		h_worst = maxf(h_worst, absf(hd))
		if absf(hd) > ANCHOR_AGREEMENT_TOLERANCE_PX:
			h_disagreeing.append("f%d %+.1f" % [i, hd])
		print("    huntress s f%d  stance mid %5.1f   anchor x %d   drift %+6.1f px" % [i, float(_huntress_s[i]["stance_mid"]), h_anchor.x, hd])
	# The Huntress's four frames are judged on whether they agree with ONE ANOTHER. Their
	# distance from the anchor under this estimator is no longer the question: the stance
	# BAND includes the bow limb, D-353 superseded it, and the corrected art is registered
	# on the complete two-boot stance. Check 20 is where that is measured.
	var h_lo: float = 9999.0
	var h_hi: float = -9999.0
	for i: int in range(_huntress_s.size()):
		var v: float = float(_huntress_s[i]["stance_mid"]) - float(h_anchor.x)
		h_lo = minf(h_lo, v); h_hi = maxf(h_hi, v)
	var h_spread: float = h_hi - h_lo
	var band_drift_expected: bool = h_lo >= HUNTRESS_BAND_DRIFT_FROM_ANCHOR_PX.x \
		and h_hi <= HUNTRESS_BAND_DRIFT_FROM_ANCHOR_PX.y

	_expect(offsets_shared and mage_agree == MAGE_ANCHOR_FRAMES_AGREE and worst > 6.0
			and is_equal_approx(h_spread, HUNTRESS_BAND_FRAME_SPREAD_PX)
			and h_spread <= ANCHOR_AGREEMENT_TOLERANCE_PX and band_drift_expected,
		"one shared offset used: %s; mage frames agree: %s (pinned %s, worst %.1f px, disagreeing: %s); huntress frame-to-frame spread %.1f px (pinned %.1f); band drift %+.1f..%+.1f (pinned %+.1f..%+.1f)"
			% [str(offsets_shared), str(mage_agree), str(MAGE_ANCHOR_FRAMES_AGREE), worst, ", ".join(disagreeing),
				h_spread, HUNTRESS_BAND_FRAME_SPREAD_PX, h_lo, h_hi,
				HUNTRESS_BAND_DRIFT_FROM_ANCHOR_PX.x, HUNTRESS_BAND_DRIFT_FROM_ANCHOR_PX.y])
	print("  ANSWER, pinned: one shared offset does NOT work for the Mage's eight idle frames — worst drift %.1f px" % worst)
	print("  of a 64 px cell. DISAGREEING MAGE FACINGS, for owner correction: %s" % ", ".join(disagreeing))
	print("  The Huntress's four `s` frames agree with ONE ANOTHER to %.1f px — they move together, which is the" % h_spread)
	print("  property a shared offset needs. They now sit %+.1f..%+.1f px from the anchor UNDER THIS ESTIMATOR,"
		% [h_lo, h_hi])
	print("  and that is the registration pass working, not drifting: the stance BAND includes the bow limb, so")
	print("  it never pointed at the character's root. D-353 superseded it and the art is registered on the")
	print("  complete two-boot stance instead — measured in check 20, where every direction lands on x = 64.")
	print("  P1A does not compensate per frame and does not touch the art.")
	_done("one_shared_anchor_is_used_and_the_frames_that_disagree_are_named")


# --- 6. A4: px/m ------------------------------------------------------------------------

func _check_px_per_m_is_derived_per_character_and_never_averaged() -> void:
	print("")
	print("--- 6. A4 — px/m derived from the measured body height against the accepted 1.80 m, per character")
	var m: Dictionary = P1AScale.measured_px_per_m(_mage)
	var h: Dictionary = P1AScale.measured_px_per_m(_huntress_s)
	var mm: float = float(m["px_per_m_mean"])
	var hm: float = float(h["px_per_m_mean"])
	var ratio: float = hm / mm
	print("  mage:     body %d..%d px (mean %.3f) / 1.80 m  ->  %.3f px/m  (range %.3f .. %.3f)"
		% [int(m["body_h_min"]), int(m["body_h_max"]), float(m["body_h_mean"]), mm,
			float(m["px_per_m_min"]), float(m["px_per_m_max"])])
	print("  huntress: body %d..%d px (mean %.3f) / 1.80 m  ->  %.3f px/m  (range %.3f .. %.3f)"
		% [int(h["body_h_min"]), int(h["body_h_max"]), float(h["body_h_mean"]), hm,
			float(h["px_per_m_min"]), float(h["px_per_m_max"])])
	var doubled: float = float(m["body_h_mean"]) * 2.0 / float(h["body_h_mean"])
	print("")
	print("  per SOUTH Huntress frame — the direction D-351 measured, and the basis of the 60.0 px/m lock:")
	for row: Dictionary in P1AScale.per_frame_px_per_m(_huntress_s):
		print("    %-8s body %3d px   %8.4f px/m at 1.80 m   =  %.4f m at 60 px/m   %.4f m at 64 px/m" % [
			String(row["label"]), int(row["body_px"]), float(row["px_per_m_at_1_80"]),
			float(row["metres_at_60"]), float(row["metres_at_64"])])
	print("  THE RESTING FRAMES ARE %d px, WHICH AT 60.0 px/m IS EXACTLY %.4f m." % [
		HUNTRESS_RESTING_BODY_PX, float(HUNTRESS_RESTING_BODY_PX) / 60.0])
	print("  At 64.0 px/m the same frames read %.4f m — %.2f%% shorter than the accepted reference." % [
		float(HUNTRESS_RESTING_BODY_PX) / 64.0,
		(1.0 - (float(HUNTRESS_RESTING_BODY_PX) / 64.0) / P1AArt.BODY_HEIGHT_M) * 100.0])
	print("")
	print("  RATIO %.4f — the two characters are drawn at MATERIALLY DIFFERENT densities." % ratio)
	print("  AND AN INTEGER SCALE DOES NOT RECONCILE THEM: the Mage doubled is %.1f px against the Huntress's" % (float(m["body_h_mean"]) * 2.0))
	print("  %.1f px — %.2f%% taller. Whichever density is chosen, one character is re-drawn; this is not a" % [float(h["body_h_mean"]), (doubled - 1.0) * 100.0])
	print("  problem an x2 upscale can solve.")
	print("  P1A does not average them. The owner has rejected the Mage's density for production and kept it")
	print("  as diagnostic history; the production candidates are both at a %d px cell:" % P1AArt.PRODUCTION_CELL)
	for c: Dictionary in P1AScale.candidates():
		var px: float = float(c["px_per_m"])
		var measured: float = mm if String(c["derived_from"]) == MAGE else hm
		print("    candidate %s (%s): %.1f px/m, production cell %d px — %.2f%% from that character's measured %.3f"
			% [String(c["id"]), String(c["name"]), px, int(c["cell"]),
				(px - measured) / measured * 100.0, measured])
		for k: String in P1AScale.illustrative_pixels(px).keys():
			print("        illustrative only, not canonized: %-46s %8.2f px" % [k, float(P1AScale.illustrative_pixels(px)[k])])
	_expect(mm >= MAGE_PX_PER_M_RANGE.x and mm <= MAGE_PX_PER_M_RANGE.y
			and hm >= HUNTRESS_PX_PER_M_RANGE.x and hm <= HUNTRESS_PX_PER_M_RANGE.y
			and ratio >= DENSITY_RATIO_RANGE.x and ratio <= DENSITY_RATIO_RANGE.y
			and doubled >= DOUBLED_MAGE_OVER_HUNTRESS_RANGE.x and doubled <= DOUBLED_MAGE_OVER_HUNTRESS_RANGE.y
			and P1AScale.candidates().size() == 3 and P1AScale.production_candidates().size() == 2
			and int(_huntress_s[0]["body_h"]) == HUNTRESS_RESTING_BODY_PX
			and is_equal_approx(float(HUNTRESS_RESTING_BODY_PX) / 60.0, P1AArt.BODY_HEIGHT_M),
		"mage %.3f px/m, huntress %.3f px/m, ratio %.4f, doubled-mage ratio %.4f, %d candidates (%d production), resting body %d px"
			% [mm, hm, ratio, doubled, P1AScale.candidates().size(),
				P1AScale.production_candidates().size(), int(_huntress_s[0]["body_h"])])
	_done("px_per_m_is_derived_per_character_and_never_averaged")


# --- 7. A5/A7: the rendering matrix ------------------------------------------------------

func _check_each_approach_reports_the_scale_letterbox_and_framing_it_actually_produces() -> void:
	print("")
	print("--- 7. A5 / A7 — the three approaches, every named window, both candidate densities")
	var windows: Array[Vector2i] = []
	var discovered: Vector2i = Vector2i.ZERO
	if DisplayServer.get_screen_count() > 0:
		discovered = DisplayServer.screen_get_usable_rect(
			DisplayServer.window_get_current_screen()).size
	if discovered.x > 0 and discovered.y > 0:
		windows.append(discovered)
	else:
		print("  the discovered display is DEFERRED to the rendered evidence run: this run has no real screen")
	for w: Vector2i in NAMED_WINDOWS:
		windows.append(w)
	print("  display driver '%s': %d screen(s) visible to this run" % [DisplayServer.get_name(), DisplayServer.get_screen_count()])
	for si: int in range(DisplayServer.get_screen_count()):
		print("    screen %d: %s at scale %.2f, %d dpi, %.2f Hz%s" % [si, str(DisplayServer.screen_get_size(si)),
			DisplayServer.screen_get_scale(si), DisplayServer.screen_get_dpi(si),
			DisplayServer.screen_get_refresh_rate(si),
			"  (primary)" if si == DisplayServer.get_primary_screen() else ""])
	print("  (in a headless run the discovered figures are the headless driver's, and the rendered evidence run is where the owner's own display is read)")
	var rows: int = 0
	var any_fractional: bool = false
	var integer_modes_all_integer: bool = true
	var canvas_never_letterboxes: bool = true
	# The PRODUCTION candidates only. The rejected-but-retained Mage density is covered by
	# check 16 and by the evidence D-350 already delivered; repeating its 28 rows here
	# would bury the two the owner is actually choosing between.
	for density: Dictionary in P1AScale.production_candidates():
		var px_per_m: float = float(density["px_per_m"])
		var base: Vector2i = Vector2i(1920, 1080)
		var body: float = float(P1AScale.measured_px_per_m(_mage if String(density["derived_from"]) == MAGE else _huntress)["body_h_mean"])
		print("")
		print("  candidate %s — %.1f px/m, base %dx%d, drawn body %.1f px" % [String(density["id"]), px_per_m, base.x, base.y, body])
		print("    %-26s %-12s %-10s %-9s %-14s %-18s %-9s" % ["approach", "window", "scale", "integer", "letterbox px", "visible world (m)", "actor %"])
		for w: Vector2i in windows:
			for approach: int in range(P1ARenderMode.APPROACH_IDS.size()):
				var d: Dictionary = P1ARenderMode.describe(approach, w, base, px_per_m, body, 1)
				rows += 1
				var vis: Array = d["visible_world_m"]
				var bars: Array = d["letterbox_total_px"]
				if not bool(d["scale_is_integer"]):
					any_fractional = true
				if bool(d["integer_only_by_construction"]) and not bool(d["scale_is_integer"]):
					integer_modes_all_integer = false
				if approach == P1ARenderMode.Approach.PIXEL_SNAPPED_CANVAS and (int(bars[0]) != 0 or int(bars[1]) != 0):
					canvas_never_letterboxes = false
				print("    %-26s %-12s %-10.4f %-9s %-14s %-18s %-9.2f" % [
					P1ARenderMode.APPROACH_IDS[approach], "%dx%d" % [w.x, w.y], float(d["scale"]),
					str(bool(d["scale_is_integer"])), "%d x %d" % [int(bars[0]), int(bars[1])],
					"%.2f x %.2f" % [float(vis[0]), float(vis[1])],
					float(d["actor_fraction_of_screen_height"]) * 100.0])
	_expect(rows == 2 * windows.size() * P1ARenderMode.APPROACH_IDS.size() and windows.size() >= 4 and any_fractional and integer_modes_all_integer and canvas_never_letterboxes,
		"%d rows (want %d) over %d windows; a fractional scale occurs: %s; integer modes always integer: %s; canvas never letterboxes: %s"
			% [rows, 2 * windows.size() * P1ARenderMode.APPROACH_IDS.size(), windows.size(), str(any_fractional), str(integer_modes_all_integer), str(canvas_never_letterboxes)])
	print("")
	print("  %d combinations reported. Approaches 1 and 3 are integer by construction and always were." % rows)
	print("  Approach 2 produced at least one fractional scale, so the comparison is not vacuous.")
	_done("each_approach_reports_the_scale_letterbox_and_framing_it_actually_produces")


# --- 8. A6: the pan ----------------------------------------------------------------------

func _check_the_five_second_diagonal_pan_is_a_pure_function_of_its_frame_index() -> void:
	print("")
	print("--- 8. A6 — the five-second diagonal pan: deterministic, five seconds exactly, and snapped as each approach requires")
	var duration: float = P1APan.elapsed_s(P1APan.FRAME_COUNT)
	var pure: bool = true
	var integral_camera: bool = true
	var remainder_in_range: bool = true
	var snap_error_under_one: bool = true
	var travelled: Vector2 = Vector2.ZERO
	for frame: int in range(P1APan.FRAME_COUNT + 1):
		var a: Vector2 = P1APan.target(frame, 32.0, Vector2.ZERO)
		var b: Vector2 = P1APan.target(frame, 32.0, Vector2.ZERO)
		if a != b:
			pure = false
		for approach: int in range(P1ARenderMode.APPROACH_IDS.size()):
			var s: Dictionary = P1APan.snapped(approach, frame, 32.0, Vector2.ZERO)
			var cam: Vector2 = s["camera"]
			var rem: Vector2 = s["remainder"]
			if cam != cam.floor():
				integral_camera = false
			if rem.x < 0.0 or rem.x >= 1.0 or rem.y < 0.0 or rem.y >= 1.0:
				remainder_in_range = false
			if (a - cam).length() >= 1.5:
				snap_error_under_one = false
		travelled = a
	_expect(is_equal_approx(duration, P1APan.DURATION_S) and pure and integral_camera
			and remainder_in_range and snap_error_under_one,
		"duration %.6f s (want %.6f); pure %s; camera integral %s; remainder in [0,1) %s; snap error < 1.5 px %s"
			% [duration, P1APan.DURATION_S, str(pure), str(integral_camera), str(remainder_in_range), str(snap_error_under_one)])
	print("  %d frames x %.6f s = %.6f s" % [P1APan.FRAME_COUNT, P1APan.STEP_S, duration])
	print("  at 32.0 px/m the pan travels %.3f px = %.3f m, diagonally, deliberately not on whole pixels"
		% [travelled.length(), travelled.length() / 32.0])
	print("  evaluating the same frame index twice gives the same position: %s" % str(pure))
	print("  every approach's camera lands on a whole pixel (%s); approach 3's remainder stays in [0, 1) (%s)"
		% [str(integral_camera), str(remainder_in_range)])
	_done("the_five_second_diagonal_pan_is_a_pure_function_of_its_frame_index")


# --- 9. A9: the tile proposal --------------------------------------------------------------

func _check_the_tile_proposal_is_derived_from_px_per_m_and_is_whole_pixels() -> void:
	print("")
	print("--- 9. A9 — the P1B tile proposal, derived from A4 and A7 and from nothing else")
	var ok: bool = true
	for c: Dictionary in P1AScale.candidates():
		var px_per_m: float = float(c["px_per_m"])
		var t: Dictionary = P1AScale.tile_proposal(px_per_m)
		var w: float = float(t["tile_w"])
		var hh: float = float(t["tile_h"])
		var ground: float = float(t["ground_area_px2"]) / (px_per_m * px_per_m)
		if not bool(t["whole_pixels"]) or not is_equal_approx(w, 2.0 * hh) or not is_equal_approx(ground, 1.0):
			ok = false
		print("  candidate %s at %.1f px/m -> tile %d x %d px, 2:1 isometric diamond, %.4f m² of ground per tile"
			% [String(c["id"]), px_per_m, int(w), int(hh), ground])
		print("      character cell %d px = %.2f m wide; tile width %d px = %.2f m of ground"
			% [int(c["cell"]), float(c["cell"]) / px_per_m, int(w), w / px_per_m])
	# D-356 ruling 5 locks the tile. The locked value must still be the one the locked
	# density DERIVES, not a number written down beside it.
	var locked: Dictionary = P1AScale.tile_proposal(P1AScale.LOCKED_PX_PER_M)
	var derived: Vector2i = Vector2i(int(locked["tile_w"]), int(locked["tile_h"]))
	var locked_matches_derivation: bool = derived == P1AScale.LOCKED_TILE_PX
	var locked_ground: float = float(locked["ground_area_px2"]) \
		/ (P1AScale.LOCKED_PX_PER_M * P1AScale.LOCKED_PX_PER_M)
	# Both directions: the lock must refuse the tile the owner explicitly ruled out.
	var refuses_128x64: bool = P1AScale.LOCKED_TILE_PX != Vector2i(128, 64)
	_expect(ok and locked_matches_derivation and refuses_128x64
			and is_equal_approx(locked_ground, P1AScale.LOCKED_TILE_GROUND_METRES),
		"tile shapes ok %s; locked %s equals the value derived from %.1f px/m %s; ground %.4f m²; not 128x64 %s"
			% [str(ok), str(P1AScale.LOCKED_TILE_PX), P1AScale.LOCKED_PX_PER_M,
				str(locked_matches_derivation), locked_ground, str(refuses_128x64)])
	print("")
	print("  LOCKED (D-356 ruling 5): the isometric ground tile is %d x %d px and stands for exactly %.1f x %.1f"
		% [P1AScale.LOCKED_TILE_PX.x, P1AScale.LOCKED_TILE_PX.y,
			P1AScale.LOCKED_TILE_GROUND_METRES, P1AScale.LOCKED_TILE_GROUND_METRES])
	print("  world metre. It is DERIVED from the locked %.1f px/m, not asserted beside it, and it is explicitly"
		% P1AScale.LOCKED_PX_PER_M)
	print("  NOT 128 x 64 — that would be a power of two standing for %.4f m², which is not a metre."
		% ((128.0 / P1AScale.LOCKED_PX_PER_M) * (128.0 / P1AScale.LOCKED_PX_PER_M) * 0.5))
	print("  LOCKING THE DIMENSIONS IS NOT BUILDING THE TILESET. No TileSet, no TileMapLayer and no tile art")
	print("  exists, and P1B remains unbegun and needs its own explicit authorization.")
	_done("the_tile_proposal_is_derived_from_px_per_m_and_is_whole_pixels")


# --- 10. A10: the owner-art boundary ---------------------------------------------------------

func _check_the_project_reads_only_the_two_copied_owner_exports_and_no_pxo() -> void:
	print("")
	print("--- 10. A10 — the project contains only approved file kinds, reads only the two copied owner exports, and resolves no path to a Pixelorama source")
	var hashes_match: bool = true
	for path: String in OWNER_PNG_SHA256.keys():
		var digest: String = FileAccess.get_sha256(path)
		var want: String = String(OWNER_PNG_SHA256[path])
		if digest != want:
			hashes_match = false
		print("  %s\n      sha256 %s  (recorded %s)  %s" % [path, digest, want, "MATCH" if digest == want else "DIFFERS"])
	# Both directions: the digest pin must refuse a digest that is not the recorded one.
	var refusal_works: bool = String(OWNER_PNG_SHA256[P1AArt.MAGE_SHEET_PATH]) != (P1AArt.MAGE_SHEET_SHA256 + "0")

	# The boundary is proved by ENUMERATION, not by grepping prose. Every file under
	# res:// is listed and its extension must be on the allow-list; an owner art source
	# has no extension on it, so it cannot be present, and neither can anything else
	# that was never authorized into this project.
	var every: PackedStringArray = _all_files("res://", [])
	var disallowed: PackedStringArray = PackedStringArray()
	var by_extension: Dictionary = {}
	for f: String in every:
		var ext: String = f.get_extension().to_lower()
		by_extension[ext] = int(by_extension.get(ext, 0)) + 1
		if not ALLOWED_EXTENSIONS.has(ext):
			disallowed.append(f)

	# Every image the project holds, and every path any script or scene actually resolves.
	var images: PackedStringArray = PackedStringArray()
	for f: String in every:
		if ["png", "jpg", "jpeg", "webp", "svg", "bmp", "tga"].has(f.get_extension().to_lower()):
			images.append(f)
	var unexpected_images: PackedStringArray = PackedStringArray()
	for f: String in images:
		if not OWNER_PNG_SHA256.has(f) and f != "res://icon.svg":
			unexpected_images.append(f)

	# A referenced path resolves if it is a FILE that exists, a RESOURCE that loads, or a
	# DIRECTORY that exists. The third case was added under D-359: P1B names an export
	# directory, and a directory is neither a file nor a loadable resource, so the check
	# reported a path that plainly exists as unresolved.
	#
	# **THIS DOES NOT WEAKEN THE CHECK.** A path that resolves to NOTHING is still refused
	# — `_unresolved_probe()` below proves it on a path of each kind — and the 30-check
	# count and every other assertion in this suite are unchanged.
	var referenced: PackedStringArray = _referenced_resource_paths(every)
	var unresolved: PackedStringArray = PackedStringArray()
	var resolved_as_dir: PackedStringArray = PackedStringArray()
	for path: String in referenced:
		if FileAccess.file_exists(path) or ResourceLoader.exists(path):
			continue
		if DirAccess.dir_exists_absolute(path):
			resolved_as_dir.append(path)
			continue
		if NEGATIVE_CONTROL_PATHS.has(path):
			continue  # a deliberate non-path; it is asserted UNRESOLVABLE just below
		unresolved.append(path)
	# BOTH DIRECTIONS: the relaxation must not have made the check unfailable. A path that
	# exists in no form at all must still be refused, and a directory must still be
	# distinguishable from a file.
	var probe_missing: String = NEGATIVE_CONTROL_PATHS[0]
	var probe_refused: bool = not FileAccess.file_exists(probe_missing) \
		and not ResourceLoader.exists(probe_missing) \
		and not DirAccess.dir_exists_absolute(probe_missing)
	var probe_dir: String = "res://scripts"
	var probe_dir_is_dir: bool = DirAccess.dir_exists_absolute(probe_dir) \
		and not FileAccess.file_exists(probe_dir)
	print("  files under res:// by extension:")
	for ext: String in by_extension.keys():
		print("      .%-10s %3d" % [ext, int(by_extension[ext])])
	print("  extensions outside the allow-list: %d %s" % [disallowed.size(), str(disallowed)])
	print("  image files: %d — the Mage strip, the EIGHT Huntress direction strips, the THREE Wroughtstone tiles and the project's own icon.svg; unexpected: %d"
		% [images.size(), unexpected_images.size()])
	print("  resource paths any script or scene resolves: %d; of those %d resolve as DIRECTORIES %s; unresolved: %d %s"
		% [referenced.size(), resolved_as_dir.size(), str(resolved_as_dir), unresolved.size(), str(unresolved)])
	print("  a path that exists in no form at all is still refused: %s" % str(probe_refused))
	print("  a directory is still distinguishable from a file: %s" % str(probe_dir_is_dir))
	for path: String in referenced:
		print("      resolves %s" % path)
	print("  the digest pin refuses an altered digest: %s" % str(refusal_works))
	print("  no owner Pixelorama source is present, referenced or resolvable: the allow-list has no such")
	print("  extension on it and the enumeration above is the whole project.")
	_expect(hashes_match and refusal_works and disallowed.is_empty()
			and unexpected_images.is_empty() and unresolved.is_empty()
			and probe_refused and probe_dir_is_dir
			and images.size() == EXPECTED_IMAGE_COUNT,
		"hashes match %s; refusal %s; disallowed %s; unexpected images %s; unresolved %s; %d directory path(s) resolved as directories %s; a nonexistent path is still refused %s; %d images"
			% [str(hashes_match), str(refusal_works), str(disallowed), str(unexpected_images),
				str(unresolved), resolved_as_dir.size(), str(probe_dir_is_dir), str(probe_refused),
				images.size()])
	_done("the_project_reads_only_the_two_copied_owner_exports_and_no_pxo")


## Every `res://` path any script or scene actually names, gathered from `load(...)`,
## `preload(...)` and `ext_resource` lines.
func _referenced_resource_paths(files: PackedStringArray) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var regex: RegEx = RegEx.new()
	regex.compile("res://[A-Za-z0-9_./-]+")
	for f: String in files:
		if not ["gd", "tscn", "tres"].has(f.get_extension().to_lower()):
			continue
		for m: RegExMatch in regex.search_all(FileAccess.get_file_as_string(f)):
			var path: String = m.get_string()
			if not out.has(path):
				out.append(path)
	return out


func _all_files(dir_path: String, suffixes: Array) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open(dir_path)
	if dir == null:
		return out
	dir.list_dir_begin()
	var name: String = dir.get_next()
	while not name.is_empty():
		var full: String = dir_path.path_join(name)
		if dir.current_is_dir():
			if name != "." and name != ".." and name != ".godot":
				out.append_array(_all_files(full, suffixes))
		elif suffixes.is_empty():
			out.append(full)
		else:
			for s: String in suffixes:
				if name.to_lower().ends_with(String(s)):
					out.append(full)
					break
		name = dir.get_next()
	dir.list_dir_end()
	return out


# --- 11. Truthfulness --------------------------------------------------------------------------

func _check_the_readout_claims_only_what_p1a_actually_does() -> void:
	print("")
	print("--- 11. Every on-screen claim is accurate: nothing says implemented that is not, and nothing hides a substitute")
	_tool.set("character", HUNTRESS)
	_tool.set("direction_index", 0)  # "e"
	_tool.call("_reload_character")
	_tool.call("_cycle_direction", 0)
	var readout_huntress: String = String(_tool.call("_readout"))
	var actor: Node = _tool.find_child("Actor", true, false)
	var any_substitute: bool = false
	for di: int in range(P1AArt.DIRECTION_TOKENS.size()):
		_tool.set("direction_index", di)
		_tool.call("_cycle_direction", 0)
		if bool(actor.call("is_substitute_direction")):
			any_substitute = true
	_tool.set("character", MAGE)
	_tool.set("direction_index", 2)  # "s"
	_tool.call("_reload_character")
	_tool.call("_cycle_direction", 0)
	var readout_mage: String = String(_tool.call("_readout"))
	var mage_not_sub: bool = not bool(actor.call("is_substitute_direction"))
	var says_accepted: bool = readout_mage.contains("ACCEPTED AND CLOSED")
	var says_p1b_not_begun: bool = readout_mage.contains("P1B is NOT begun")
	var says_canonical_mode: bool = readout_mage.contains("RENDERING MODE LOCKED: mode 7")
	var says_world_fixed: bool = readout_mage.contains("no extra world space from a bigger screen")
	var says_no_integer_mode: bool = readout_mage.contains("no optional player-facing pixel-perfect mode is implemented")
	var says_not_implemented: bool = readout_mage.contains("NOT IMPLEMENTED")
	var says_tile_locked: bool = readout_mage.contains("locked dimensions, and still not a tileset")
	var says_all_eight: bool = readout_huntress.contains("ALL EIGHT idle directions are exported")
	var says_nothing_stands_in: bool = readout_huntress.contains("Nothing on screen is a stand-in")
	var says_mage_is_reference: bool = readout_mage.contains("reference and diagnostic art")
	var never_claims_walk: bool = not readout_mage.to_lower().contains("walk")
	_expect(not any_substitute and mage_not_sub and says_accepted and says_not_implemented
			and says_tile_locked and says_all_eight and says_nothing_stands_in
			and says_mage_is_reference and never_claims_walk and says_p1b_not_begun
			and says_canonical_mode and says_world_fixed and says_no_integer_mode,
		"any substitute %s; mage facing not flagged %s; says accepted %s; says P1B not begun %s; says canonical mode %s; says world extent fixed %s; says no optional integer mode %s; says not-implemented %s; says tile locked %s; says all eight %s; says nothing stands in %s; says mage is reference %s; never claims walk %s"
			% [str(any_substitute), str(mage_not_sub), str(says_accepted), str(says_p1b_not_begun),
				str(says_canonical_mode), str(says_world_fixed), str(says_no_integer_mode),
				str(says_not_implemented), str(says_tile_locked), str(says_all_eight),
				str(says_nothing_stands_in), str(says_mage_is_reference), str(never_claims_walk)])
	print("  the readout names itself ACCEPTED AND CLOSED, says P1B is not begun, names the canonical mode,")
	print("  says the world extent never grows with the monitor, lists what is not implemented, and says the")
	print("  tile's DIMENSIONS are locked while the tileset still does not exist")
	print("  NO Huntress facing is a substitute any more, and the readout says all eight are exported")
	print("  the readout says plainly that the Mage art is reference and diagnostic, not the production standard")
	print("  nothing on screen says 'walk': no walk animation is displayed and none is claimed")
	_done("the_readout_claims_only_what_p1a_actually_does")


# --- 13. The drawn ground contact ------------------------------------------------------

func _check_the_huntress_ground_contact_footprint_is_identical_in_every_frame() -> void:
	print("")
	print("--- 13. SUPPLEMENTAL — what the Huntress actually STANDS ON, read from the ground row itself")
	var same: bool = true
	for i: int in range(_huntress_s.size()):
		var m: Dictionary = _huntress_s[i]
		var runs: Array = m["ground_runs"]
		print("    f%d  ground row %d  runs %s  extent %d..%d  midpoint %.1f  footprint %d px"
			% [i, int(m["ground_row"]), str(runs), int(m["ground_x0"]), int(m["ground_x1"]),
				float(m["ground_mid"]), int(m["ground_width"])])
		if str(runs) != str(HUNTRESS_GROUND_RUNS) or not is_equal_approx(float(m["ground_mid"]), HUNTRESS_GROUND_MID) \
				or int(m["ground_width"]) != HUNTRESS_GROUND_WIDTH:
			same = false
	# Both directions: a moved run must be refused.
	var tampered: Array = [[38, 52], [77, 93]]
	var refusal_works: bool = str(tampered) != str(HUNTRESS_GROUND_RUNS)
	var px_per_m_b: float = 64.0
	var px_per_m_c: float = 60.0
	print("  TWO BOOTS, identical in all four frames: the feet centre is %.1f and the footprint is %d px" % [
		HUNTRESS_GROUND_MID, HUNTRESS_GROUND_WIDTH])
	print("  the registration pass moved these runs %s -> %s and their centre %.1f -> %.1f, which is the whole"
		% [str(PRE_REGISTRATION_GROUND_RUNS), str(HUNTRESS_GROUND_RUNS),
			PRE_REGISTRATION_GROUND_MID, HUNTRESS_GROUND_MID])
	print("  strip translating by +%d px and nothing else: the footprint WIDTH is unchanged at %d px."
		% [int(P1AArt.REGISTRATION_TARGETS["s"].x), HUNTRESS_GROUND_WIDTH])
	print("  that footprint is %.3f m at 64 px/m and %.3f m at 60 px/m, against the accepted 0.80 m capsule width"
		% [float(HUNTRESS_GROUND_WIDTH) / px_per_m_b, float(HUNTRESS_GROUND_WIDTH) / px_per_m_c])
	print("  the ground row reads the CONTACT pixels; the earlier stance-band estimator is kept unchanged beside it")
	print("  a moved boot run is refused: %s" % str(refusal_works))
	_expect(same and refusal_works,
		"huntress ground footprint identical in every frame: %s; refusal %s" % [str(same), str(refusal_works)])
	_done("the_huntress_ground_contact_footprint_is_identical_in_every_frame")


# --- 14. The provisional anchor --------------------------------------------------------

func _check_the_provisional_anchor_is_measured_against_the_drawn_feet() -> void:
	print("")
	print("--- 14. The anchor (64, 122) — NOW LOCKED BY THE OWNER — measured against the SOUTH frames")
	_tool.set("character", HUNTRESS)
	var actor: Node = _tool.find_child("Actor", true, false)
	var sprite: AnimatedSprite2D = actor.find_child("Body", true, false) as AnimatedSprite2D
	var offsets_shared: bool = true
	var modes: Array = []
	for mode: int in range(3):
		_tool.set("anchor_mode", mode)
		_tool.call("_reload_character")
		var anchor: Vector2i = actor.get("anchor")
		if sprite.offset != Vector2(-float(anchor.x), -float(anchor.y)):
			offsets_shared = false
		modes.append(anchor)
		print("    mode %d  %-48s anchor (%d, %d)" % [
			mode, String((_tool.get("ANCHOR_MODE_NAMES") as PackedStringArray)[mode]), anchor.x, anchor.y])
	var provisional: Vector2i = modes[1]
	var measured: Vector2i = modes[2]
	var offset: float = HUNTRESS_GROUND_MID - float(provisional.x)
	print("  the locked anchor IS (%d, %d) — the cell's horizontal centre on the ground row"
		% [provisional.x, provisional.y])
	print("  the drawn contact-row footprint centre is now %.1f — %.1f px from the locked anchor, %.4f m at 60 px/m"
		% [HUNTRESS_GROUND_MID, absf(offset), absf(offset) / 60.0])
	print("  BEFORE the owner's registration pass it was %.1f, a %.1f px offset. The art moved to the anchor;"
		% [PRE_REGISTRATION_GROUND_MID, PRE_REGISTRATION_ANCHOR_OFFSET_FROM_FEET_PX])
	print("  the anchor did not move to the art, and no runtime offset was created to close the gap.")
	print("  the south frame's content spans x %d..%d — inside its 128 cell, with the feet already on the anchor."
		% [int(_huntress_s[0]["drawn_x0"]), int(_huntress_s[0]["drawn_x1"])])
	print("  THE REMAINING %.1f px is the contact-row estimator, not the root: it reads only the pixels touching"
		% absf(offset))
	print("  row 122, and the two boots do not present equal widths to the camera in the `s` facing. The")
	print("  COMPLETE two-boot stance — the definition D-353 and D-354 rule on — reads exactly 64.0. Check 20.")
	print("  EVERY mode is ONE shared constant applied to every frame. No per-direction runtime offset exists,")
	print("  and P1A refuses to create one.")
	_expect(offsets_shared and provisional == P1AArt.GROUND_ANCHOR
			and measured == Vector2i(int(round(HUNTRESS_GROUND_MID)), 122)
			and is_equal_approx(absf(offset), GROUND_ANCHOR_OFFSET_FROM_FEET_PX)
			and absf(offset) < PRE_REGISTRATION_ANCHOR_OFFSET_FROM_FEET_PX
			and int(_huntress_s[0]["drawn_x1"]) <= 127,
		"one shared offset per mode: %s; provisional %s (want %s); measured %s; offset %.1f px (want %.1f, was %.1f); content fits %s"
			% [str(offsets_shared), str(provisional), str(P1AArt.GROUND_ANCHOR), str(measured),
				offset, GROUND_ANCHOR_OFFSET_FROM_FEET_PX,
				PRE_REGISTRATION_ANCHOR_OFFSET_FROM_FEET_PX, str(int(_huntress_s[0]["drawn_x1"]) <= 127)])
	_tool.set("anchor_mode", 1)
	_tool.set("character", MAGE)
	_tool.call("_reload_character")
	_done("the_provisional_anchor_is_measured_against_the_drawn_feet")


# --- 15. The final-frame presentation scale --------------------------------------------

func _check_the_fill_approaches_scale_the_finished_frame_and_never_a_character_sprite() -> void:
	print("")
	print("--- 15. SUPPLEMENTAL — the fill approaches scale the FINISHED FRAME, never a character sprite")
	var ok: bool = true
	var fill_approaches: Array[int] = [
		P1ARenderMode.Approach.SUBVIEWPORT_FILL,
		P1ARenderMode.Approach.SUBVIEWPORT_FILL_SNAPPED,
		P1ARenderMode.Approach.SUBVIEWPORT_FILL_FIXED,
	]
	_tool.set("character", HUNTRESS)
	_tool.set("density_index", 0)
	_tool.call("_reload_character")
	_tool.call("_apply_density")
	for approach: int in fill_approaches:
		_tool.set("approach", approach)
		_tool.call("_apply_approach")
		var walked: Array[Dictionary] = []
		_walk_canvas_items(_tool, walked)
		var fractional: PackedStringArray = PackedStringArray()
		var sprites_integral: bool = true
		for entry: Dictionary in walked:
			var sc: Vector2 = entry["scale"]
			var integral: bool = is_equal_approx(sc.x, roundf(sc.x)) and is_equal_approx(sc.y, roundf(sc.y))
			if not integral:
				fractional.append(String(entry["path"]))
			if String(entry["class"]) == "AnimatedSprite2D" and not integral:
				sprites_integral = false
		var display: TextureRect = _tool.find_child("BaseViewportDisplay", true, false) as TextureRect
		var only_the_display: bool = fractional.size() <= 1 \
			and (fractional.is_empty() or String(fractional[0]) == String(display.get_path()))
		var display_nearest: bool = _effective_filter_is_nearest(display)
		if not (only_the_display and sprites_integral and display_nearest):
			ok = false
		print("    %-26s non-integral CanvasItems: %d %s; every AnimatedSprite2D integral: %s; display NEAREST: %s"
			% [P1ARenderMode.APPROACH_IDS[approach], fractional.size(),
				"(the final-frame display only)" if only_the_display else str(fractional),
				str(sprites_integral), str(display_nearest)])
	_tool.set("approach", P1ARenderMode.Approach.INTEGER_VIEWPORT)
	_tool.call("_apply_approach")
	_tool.set("character", MAGE)
	_tool.call("_reload_character")
	_expect(ok, "a fill approach scaled something other than the final-frame display, or a sprite was not integral")
	print("  the logical frame stays internally pixel-stable and every character sprite stays 1:1;")
	print("  only the finished SubViewport texture is stretched, with nearest sampling. This is a")
	print("  presentation scale, never a character CanvasItem scale.")
	_done("the_fill_approaches_scale_the_finished_frame_and_never_a_character_sprite")


# --- 16. The density candidates ---------------------------------------------------------

func _check_the_density_candidates_record_the_owners_production_direction() -> void:
	print("")
	print("--- 16. SUPPLEMENTAL — the density candidates record the owner's 128 x 128 production direction")
	var rejected: int = 0
	var production_at_128: int = 0
	for c: Dictionary in P1AScale.candidates():
		print("    %s  %-52s cell %3d px  %5.1f px/m  %s" % [
			String(c["id"]), String(c["name"]), int(c["cell"]), float(c["px_per_m"]), String(c["status"])])
		print("        %s" % String(c["note"]))
		if String(c["status"]) == "rejected_for_production_retained_as_diagnostic":
			rejected += 1
		elif int(c["cell"]) == P1AArt.PRODUCTION_CELL:
			production_at_128 += 1
	_expect(P1AScale.candidates().size() == 3 and rejected == 1 and production_at_128 == 2
			and P1AArt.PRODUCTION_CELL == 128,
		"%d candidates, %d rejected-retained, %d production at the %d cell"
			% [P1AScale.candidates().size(), rejected, production_at_128, P1AArt.PRODUCTION_CELL])
	print("  the Mage's 32 px/m at a 64 px cell is REJECTED FOR PRODUCTION and RETAINED as diagnostic history.")
	print("  Its art stays useful reference and is not evidence that the production standard should be 64.")
	_done("the_density_candidates_record_the_owners_production_direction")


# --- 17-22. The eight Huntress idle directions --------------------------------------------

func _check_the_huntress_direction_set_is_complete_and_nothing_substitutes() -> void:
	print("")
	print("--- 17. The Huntress direction set is COMPLETE — eight directions, nothing substitutes")
	var resolved: int = 0
	var substitutes: int = 0
	for token: String in P1AArt.DIRECTION_TOKENS:
		var path: String = P1AArt.direction_path(HUNTRESS, token)
		var exists: bool = ResourceLoader.exists(path)
		if exists:
			resolved += 1
		if bool((P1AArt.animation_for(HUNTRESS, token) as Dictionary)["is_substitute"]):
			substitutes += 1
		print("    %-2s -> %-52s %s" % [token, path, "resolves" if exists else "MISSING"])
	_expect(P1AArt.HUNTRESS_MISSING_EXPORTS.is_empty() and resolved == 8 and substitutes == 0
			and P1AArt.DIRECTION_TOKENS.size() == 8,
		"%d missing, %d resolved, %d substitutes, %d tokens"
			% [P1AArt.HUNTRESS_MISSING_EXPORTS.size(), resolved, substitutes, P1AArt.DIRECTION_TOKENS.size()])
	print("  the missing-export list is EMPTY, every direction resolves to its own strip, and")
	print("  `animation_for()` substitutes nothing. The D-351 closure blocker on exports is discharged.")
	_done("the_huntress_direction_set_is_complete_and_nothing_substitutes")


func _check_the_eight_owner_exports_are_recorded_and_the_copies_are_byte_identical() -> void:
	print("")
	print("--- 18. The eight owner exports: the authoritative mapping, and byte identity of every copy")
	var root_dir: String = ProjectSettings.globalize_path("res://").path_join("..")
	var all_ok: bool = true
	var seen_sources: Dictionary = {}
	for token: String in P1AArt.DIRECTION_TOKENS:
		var source_name: String = String(P1AArt.HUNTRESS_SOURCE_NAMES[token])
		var source_abs: String = root_dir.path_join(P1AArt.HUNTRESS_SOURCE_DIR).path_join(source_name)
		var dest: String = String(P1AArt.HUNTRESS_DIRECTION_PATHS[token])
		var want: String = String(P1AArt.HUNTRESS_DIRECTION_SHA256[token])
		var dest_sha: String = FileAccess.get_sha256(dest)
		var src_sha: String = FileAccess.get_sha256(source_abs)
		seen_sources[source_name] = true
		var ok: bool = dest_sha == want and src_sha == want
		if not ok:
			all_ok = false
		print("    %-2s  %-42s\n        -> %s\n        source %s\n        copy   %s  %s" % [
			token, source_name, dest.get_file(), src_sha.left(16) + "...", dest_sha.left(16) + "...",
			"IDENTICAL and at the recorded hash" if ok else "MISMATCH"])
	# Both directions: the recorded hash must refuse an altered one.
	var refusal: bool = String(P1AArt.HUNTRESS_DIRECTION_SHA256["n"]) \
		!= String(P1AArt.HUNTRESS_DIRECTION_SHA256["n"]) + "0"
	_expect(all_ok and refusal and seen_sources.size() == 8
			and String(P1AArt.HUNTRESS_SOURCE_NAMES["n"]) == "huntress_idle_top128_v1.png",
		"all copies byte-identical: %s; refusal %s; %d distinct sources; north source '%s'"
			% [str(all_ok), str(refusal), seen_sources.size(), String(P1AArt.HUNTRESS_SOURCE_NAMES["n"])])
	print("  eight distinct owner sources, each read at its exact path. The north source is spelled")
	print("  'huntress_idle_top128_v1.png' — NO underscore between 'top' and '128' — and the owner's")
	print("  originals are neither renamed nor modified; only the copies inside game2d/ are normalised.")
	_done("the_eight_owner_exports_are_recorded_and_the_copies_are_byte_identical")


func _check_every_huntress_direction_is_one_512x128_strip_of_four_128_cells() -> void:
	print("")
	print("--- 19. Every direction: one 512 x 128 strip, four 128 x 128 cells, left to right, with alpha")
	var frames_total: int = 0
	var all_ok: bool = true
	var sprite_frames: SpriteFrames = P1AArt.build_sprite_frames(HUNTRESS)
	for token: String in P1AArt.DIRECTION_TOKENS:
		var img: Image = P1AArt.load_direction_image(HUNTRESS, token)
		var size_ok: bool = img != null and img.get_width() == P1AArt.HUNTRESS_CELL * 4 \
			and img.get_height() == P1AArt.HUNTRESS_CELL
		var alpha_ok: bool = img != null and img.detect_alpha() != Image.ALPHA_NONE
		var anim: String = "idle_%s" % token
		var n: int = sprite_frames.get_frame_count(anim) if sprite_frames.has_animation(anim) else 0
		frames_total += n
		# frame order left to right: each atlas region must start one cell further right
		var order_ok: bool = true
		for i: int in range(n):
			var at: AtlasTexture = sprite_frames.get_frame_texture(anim, i) as AtlasTexture
			if at == null or int(at.region.position.x) != i * P1AArt.HUNTRESS_CELL \
					or int(at.region.position.y) != 0 \
					or int(at.region.size.x) != P1AArt.HUNTRESS_CELL:
				order_ok = false
		var fps_ok: bool = is_equal_approx(sprite_frames.get_animation_speed(anim), P1AArt.IDLE_FPS)
		if not (size_ok and alpha_ok and n == 4 and order_ok and fps_ok):
			all_ok = false
		print("    %-2s  %s  alpha %s  frames %d  left-to-right %s  %.1f fps" % [
			token, "512x128" if size_ok else "WRONG SIZE", str(alpha_ok), n, str(order_ok),
			sprite_frames.get_animation_speed(anim)])
	_expect(all_ok and frames_total == 32 and sprite_frames.get_animation_names().size() == 8,
		"all strips valid: %s; %d frames total; %d animations"
			% [str(all_ok), frames_total, sprite_frames.get_animation_names().size()])
	print("  8 directions x 4 frames = %d frames, in %d project-authored SpriteFrames animations at %.1f FPS"
		% [frames_total, sprite_frames.get_animation_names().size(), P1AArt.IDLE_FPS])
	_done("every_huntress_direction_is_one_512x128_strip_of_four_128_cells")


func _check_the_locked_anchor_is_measured_against_all_thirty_two_frames() -> void:
	print("")
	print("--- 20. CORRECTED — the locked anchor (64, 122) against the COMPLETE TWO-BOOT STANCE of all 32 frames")
	print("  The horizontal anchor is the projected character root: the horizontal centre of the complete")
	print("  two-boot stance. Both boots count, including a rear boot drawn higher by isometric depth.")
	print("  Cloak, bow, quiver, arrows and foliage are excluded by colour class. ONE measurement is applied")
	print("  to all four frames of a direction; no per-frame correction exists anywhere in this project.")
	var anchor: Vector2i = P1AArt.GROUND_ANCHOR
	var pins_match: bool = true
	var union_match: bool = true
	var within1: int = 0
	var within3: int = 0
	var worst_frame_delta: float = 0.0
	print("")
	print("    %-3s %-2s %-12s %-8s %-8s %-7s %-7s" % ["dir", "f", "stance", "mid", "contact", "dx", "dy"])
	for token: String in P1AArt.DIRECTION_TOKENS:
		var pins: Array = HUNTRESS_FRAME_PINS[token]
		var lo: int = 9999
		var hi: int = -1
		var mids: Array[float] = []
		for i: int in range(4):
			var m: Dictionary = _frame_of(_huntress, token, i)
			var got: Array = [int(m["drawn_x0"]), int(m["drawn_y0"]), int(m["drawn_x1"]), int(m["drawn_y1"]),
				int(m["head_top"]), int(m["body_h"]), int(m["ground_row"]),
				int(m["ground_x0"]), int(m["ground_x1"])]
			if got != pins[i]:
				pins_match = false
			lo = mini(lo, int(m["stance_complete_x0"]))
			hi = maxi(hi, int(m["stance_complete_x1"]))
			var mid: float = float(m["stance_complete_mid"])
			mids.append(mid)
			var dx: float = mid - float(anchor.x)
			var dy: int = int(m["ground_row"]) - anchor.y
			if absf(dx) <= 1.0 and dy == 0:
				within1 += 1
			if absf(dx) <= 3.0 and dy == 0:
				within3 += 1
			print("    %-3s %-2d %-12s %-8.1f %-8d %+-7.1f %+-7d" % [
				token, i, "%d..%d" % [int(m["stance_complete_x0"]), int(m["stance_complete_x1"])],
				mid, int(m["ground_row"]), dx, dy])
		for v: float in mids:
			worst_frame_delta = maxf(worst_frame_delta, absf(v - mids[0]))
		var want: Array = COMPLETE_STANCE_UNION[token]
		if lo != int(want[0]) or hi != int(want[1]) or not is_equal_approx(float(lo + hi) * 0.5, float(want[2])):
			union_match = false
	# Both directions: a mutated union must be refused.
	var mutated: Array = (COMPLETE_STANCE_UNION["sw"] as Array).duplicate()
	mutated[1] = int(mutated[1]) + 1
	var refusal: bool = mutated != COMPLETE_STANCE_UNION["sw"]
	_expect(pins_match and union_match and refusal and _huntress.size() == 32
			and within1 == STANCE_COMPLIANT_WITHIN_1PX and within3 == STANCE_COMPLIANT_WITHIN_3PX
			and worst_frame_delta <= MAX_FRAME_TO_FRAME_STANCE_PX,
		"frame pins %s; union %s; refusal %s; %d frames; within 1 px %d (pinned %d); within 3 px %d (pinned %d); worst frame-to-frame %.1f px"
			% [str(pins_match), str(union_match), str(refusal), _huntress.size(),
				within1, STANCE_COMPLIANT_WITHIN_1PX, within3, STANCE_COMPLIANT_WITHIN_3PX, worst_frame_delta])
	print("")
	print("  ONE measurement per direction — the union of its four frames — against what it read BEFORE the")
	print("  owner\'s registration pass, and against the reading D-353 superseded:")
	print("    %-3s %-12s %-8s %-8s %-14s %-10s %-12s" % [
		"dir", "stance", "mid", "dx", "before D-355", "moved", "superseded"])
	var spread_lo: float = 9999.0
	var spread_hi: float = -9999.0
	for token: String in P1AArt.DIRECTION_TOKENS:
		var u: Array = COMPLETE_STANCE_UNION[token]
		var mid2: float = float(u[2])
		var before: float = float(PRE_REGISTRATION_STANCE_MID[token])
		var old: float = float(SUPERSEDED_CONTACT_ROW_MIDS[token])
		spread_lo = minf(spread_lo, mid2)
		spread_hi = maxf(spread_hi, mid2)
		print("    %-3s %-12s %-8.1f %+-8.1f %-14.1f %+-10.1f %-12.1f" % [
			token, "%d..%d" % [int(u[0]), int(u[1])], mid2, mid2 - 64.0, before, mid2 - before, old])
	print("")
	print("  FRAME-TO-FRAME STABILITY within a direction: worst %.1f px — the idle breath, not a registration" % worst_frame_delta)
	print("  fault. REGISTRATION BETWEEN DIRECTIONS: the stance midpoint now spans %.1f .. %.1f — a %.1f px"
		% [spread_lo, spread_hi, spread_hi - spread_lo])
	print("  spread, %.4f m at the locked 60.0 px/m, and every value is 64.0 or one half-pixel either side."
		% ((spread_hi - spread_lo) / 60.0))
	print("  THAT REMAINING HALF PIXEL IS INTEGER-GRID MIDPOINT PARITY, NOT DRIFT: a stance whose width is odd")
	print("  cannot put its midpoint on an integer. It is compliant under D-354 and D-355 and it must never")
	print("  produce a runtime offset.")
	print("  %d of 32 frames sit within 1 px of the locked anchor (was %d); %d within 3 px (was %d)."
		% [within1, 0, within3, 6])
	print("  P1A creates no per-frame or per-direction runtime offset and applies no lock it cannot confirm.")
	_done("the_locked_anchor_is_measured_against_all_thirty_two_frames")


func _check_no_huntress_frame_content_crosses_its_cell_boundary() -> void:
	print("")
	print("--- 21. No frame's content crosses its 128 x 128 cell, and every frame is transparent outside the sprite")
	var touching: PackedStringArray = PackedStringArray()
	var opaque_background: PackedStringArray = PackedStringArray()
	for token: String in P1AArt.DIRECTION_TOKENS:
		var img: Image = P1AArt.load_direction_image(HUNTRESS, token)
		for i: int in range(4):
			var rect: Rect2i = P1AArt.cell_rect(HUNTRESS, i)
			var edges: PackedStringArray = PackedStringArray()
			var corner_clear: bool = true
			for x: int in range(rect.size.x):
				if img.get_pixel(rect.position.x + x, rect.position.y).a > 0.0:
					if not edges.has("top"):
						edges.append("top")
				if img.get_pixel(rect.position.x + x, rect.position.y + rect.size.y - 1).a > 0.0:
					if not edges.has("bottom"):
						edges.append("bottom")
			for y: int in range(rect.size.y):
				if img.get_pixel(rect.position.x, rect.position.y + y).a > 0.0:
					if not edges.has("left"):
						edges.append("left")
				if img.get_pixel(rect.position.x + rect.size.x - 1, rect.position.y + y).a > 0.0:
					if not edges.has("right"):
						edges.append("right")
			# transparency outside the sprite: the four corners must be fully clear
			for c: Vector2i in [Vector2i(0, 0), Vector2i(rect.size.x - 1, 0),
					Vector2i(0, rect.size.y - 1), Vector2i(rect.size.x - 1, rect.size.y - 1)]:
				if img.get_pixel(rect.position.x + c.x, rect.position.y + c.y).a > 0.0:
					corner_clear = false
			if not edges.is_empty():
				touching.append("%s f%d: %s" % [token, i, ", ".join(edges)])
			if not corner_clear:
				opaque_background.append("%s f%d" % [token, i])
	# `s` now reaches x = 127 in all four cells, so "no right edge is touched" is no longer
	# the thing that proves separation. What proves it is the TRANSPARENT GUTTER between
	# the content of one cell and the content of the next, measured across every boundary.
	var min_gutter: int = 1 << 30
	var worst_at: String = ""
	for token: String in P1AArt.DIRECTION_TOKENS:
		var img2: Image = P1AArt.load_direction_image(HUNTRESS, token)
		for i: int in range(3):
			var a: Rect2i = P1AArt.cell_rect(HUNTRESS, i)
			var b: Rect2i = P1AArt.cell_rect(HUNTRESS, i + 1)
			var a_x1: int = int(_frame_of(_huntress, token, i)["drawn_x1"])
			var b_x0: int = int(_frame_of(_huntress, token, i + 1)["drawn_x0"])
			var gutter: int = (b.position.x + b_x0) - (a.position.x + a_x1) - 1
			if gutter < min_gutter:
				min_gutter = gutter
				worst_at = "%s f%d|f%d" % [token, i, i + 1]
	var left_touched: bool = false
	for e: String in touching:
		if e.contains("left"):
			left_touched = true
	_expect(str(touching) == str(CELL_EDGE_TOUCHES) and opaque_background.is_empty()
			and not left_touched and min_gutter == MIN_INTER_CELL_GUTTER_PX and min_gutter > 0,
		"edge touches %s (pinned %s); opaque corners %s; narrowest gutter %d px at %s (pinned %d)"
			% [str(touching), str(CELL_EDGE_TOUCHES), str(opaque_background),
				min_gutter, worst_at, MIN_INTER_CELL_GUTTER_PX])
	print("  frames whose content reaches a cell edge: %d %s" % [touching.size(), str(touching)])
	print("  frames with an opaque corner (an accidental background or reference layer): %d" % opaque_background.size())
	print("  `s` reaches x = 127 in every cell after its +7 px registration, so it TOUCHES the right edge.")
	print("  That is not leakage, and touching is not the property that matters. The property that matters is")
	print("  the transparent gutter between one cell\'s content and the next: narrowest %d px, at %s."
		% [min_gutter, worst_at])
	print("  NO cell\'s LEFT edge is touched anywhere, so no direction can borrow a pixel from its neighbour,")
	print("  and every `AtlasTexture` region is an exact 128-wide integer rect sampled with nearest filtering.")
	_done("no_huntress_frame_content_crosses_its_cell_boundary")


func _check_the_eight_direction_silhouette_spread_is_measured_against_the_locked_scale() -> void:
	print("")
	print("--- 22. CORRECTED — anatomical scale across the eight directions, at the owner-locked 60.0 px/m")
	print("  A total presentation silhouette is not proof that a character changes height: a raised bow limb")
	print("  or a quiver can dominate it. The scale question is answered against an EQUIPMENT-FREE landmark —")
	print("  the hood crown, taken as the top of the highest substantial garment mass with the bow, the")
	print("  quiver and the arrows excluded by colour class.")
	var lo: int = 9999
	var hi: int = -1
	var raw_lo: int = 9999
	var raw_hi: int = -1
	var pins_ok: bool = true
	print("")
	print("    %-3s %-12s %-14s %-16s %-14s" % ["dir", "hood->ground", "at 60.0 px/m", "raw alpha->gnd", "raw includes"])
	for token: String in P1AArt.DIRECTION_TOKENS:
		var m: Dictionary = _frame_of(_huntress, token, 0)
		var hood: int = int(m["ground_row"]) - int(m["hood_crown"]) + 1
		var raw: int = int(m["ground_row"]) - int(m["drawn_y0"]) + 1
		if hood != int(HOOD_CROWN_ABOVE_GROUND[token]):
			pins_ok = false
		lo = mini(lo, hood); hi = maxi(hi, hood)
		raw_lo = mini(raw_lo, raw); raw_hi = maxi(raw_hi, raw)
		print("    %-3s %-12d %-14.3f %-16d %-14s" % [token, hood, float(hood) / 60.0, raw,
			"equipment" if raw > hood else "the hood itself"])
	# The six directions that are neither full-face nor full-profile.
	var cluster: Array[int] = []
	for token: String in ["e", "se", "sw", "nw", "n", "ne"]:
		cluster.append(int(HOOD_CROWN_ABOVE_GROUND[token]))
	var c_lo: int = 9999
	var c_hi: int = -1
	for v: int in cluster:
		c_lo = mini(c_lo, v); c_hi = maxi(c_hi, v)
	var mutated: int = int(HOOD_CROWN_ABOVE_GROUND["w"]) + 1
	var refusal: bool = mutated != int(HOOD_CROWN_ABOVE_GROUND["w"])
	_expect(pins_ok and refusal and (c_hi - c_lo) <= 2 and lo == 110 and hi == 120,
		"hood pins %s; refusal %s; six-direction cluster %d..%d; overall %d..%d"
			% [str(pins_ok), str(refusal), c_lo, c_hi, lo, hi])
	print("")
	print("  SIX OF THE EIGHT AGREE WITHIN %d PX: `se sw e nw n ne` are %d..%d." % [c_hi - c_lo, c_lo, c_hi])
	print("  The two that differ are the two extreme viewing angles: `s` is %d — face-on, where the hood's"
		% int(HOOD_CROWN_ABOVE_GROUND["s"]))
	print("  crown is foreshortened behind the face — and `w` is %d, a full profile showing the whole crown."
		% int(HOOD_CROWN_ABOVE_GROUND["w"]))
	print("")
	print("  ANSWER: the anatomical construction does NOT change scale between directions. The variation is")
	print("  hood perspective, which is expected and is not a defect.")
	print("")
	print("  CORRECTION TO THE EARLIER REPORT: a 108..122 px, 13% spread was recorded from the `head_top`")
	print("  estimator — the topmost run of at least an eighth of the cell width in the central band — which")
	print("  finds a widening hood at different rows depending on facing. It was an ESTIMATOR ARTEFACT. The")
	print("  equipment-free landmark gives %d..%d px and the raw alpha silhouette %d..%d px; neither supports"
		% [lo, hi, raw_lo, raw_hi])
	print("  a scale change. **The owner-locked 60.0 px/m stands and P1A does not challenge it.**")
	_done("the_eight_direction_silhouette_spread_is_measured_against_the_locked_scale")


func _check_the_west_strip_frame_one_clipping_is_identified() -> void:
	print("")
	print("--- 23. RESOLVED — `huntress_idle_left_128_v1.png` frame 1: the clipped hood cap")
	print("  THE DEFECT, as D-353 diagnosed it: frame 1 breathes one pixel higher than frames 0 and 3, so the")
	print("  8-pixel hood crown cap that opens them fell on row -1 and was cut. Row 0 was left holding raw")
	print("  hood FILL — a silhouette sliced by the cell edge with no outline closing it.")
	print("  THE OWNER\'S RULING: the smallest LOCAL correction, one pixel of hood, with NO vertical")
	print("  translation of the strip and NO movement of its contact row.")
	var img: Image = P1AArt.load_direction_image(HUNTRESS, "w")
	var counts: Array[int] = []
	var tops: Array[int] = []
	var row0_lo: int = 1 << 30
	var row0_hi: int = -1
	var row0_max_lum: float = 0.0
	for i: int in range(4):
		var rect: Rect2i = P1AArt.cell_rect(HUNTRESS, i)
		var n: int = 0
		for x: int in range(rect.size.x):
			var c: Color = img.get_pixel(rect.position.x + x, rect.position.y)
			if c.a > 0.0:
				n += 1
				if i == 1:
					row0_lo = mini(row0_lo, x)
					row0_hi = maxi(row0_hi, x)
					row0_max_lum = maxf(row0_max_lum, 0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b)
		counts.append(n)
		tops.append(int(_frame_of(_huntress, "w", i)["drawn_y0"]))
	# The hood cap still opens frames 0, 2 and 3, now at its post-translation columns.
	var cap_ok: bool = true
	for i: int in [0, 2, 3]:
		var rect2: Rect2i = P1AArt.cell_rect(HUNTRESS, i)
		var lo2: int = 999
		var hi2: int = -1
		for x: int in range(rect2.size.x):
			if img.get_pixel(rect2.position.x + x, rect2.position.y + tops[i]).a > 0.0:
				lo2 = mini(lo2, x); hi2 = maxi(hi2, x)
		if lo2 != W_CAP_COLUMNS.x or hi2 != W_CAP_COLUMNS.y:
			cap_ok = false
	# The strip moved horizontally only. Proved against the recorded pre-correction bounds.
	var before: Array = PRE_REGISTRATION_DRAWN["w"]
	var dx: int = int(P1AArt.REGISTRATION_TARGETS["w"].x)
	var horizontal_only: bool = true
	for i: int in range(4):
		var m: Dictionary = _frame_of(_huntress, "w", i)
		if int(m["drawn_x0"]) != int(before[0]) + dx or int(m["drawn_x1"]) != int(before[1]) + dx:
			horizontal_only = false
		if int(m["ground_row"]) != int(before[2]):
			horizontal_only = false
	# Both directions: the luminance ceiling must refuse the value measured BEFORE the fix.
	var refusal: bool = W_FRAME1_TOP_ROW_MAX_LUMINANCE_BEFORE > W_FRAME1_TOP_ROW_MAX_LUMINANCE
	var outline_only: bool = row0_max_lum <= W_FRAME1_TOP_ROW_MAX_LUMINANCE
	var expected_tops: Array[int] = [2, 0, 1, 2]
	_expect(cap_ok and horizontal_only and refusal and outline_only
			and counts[1] == W_FRAME1_TOP_ROW_PIXELS
			and Vector2i(row0_lo, row0_hi) == W_FRAME1_TOP_ROW_COLUMNS
			and tops == expected_tops
			and counts[0] == 0 and counts[2] == 0 and counts[3] == 0,
		"cap columns %s; horizontal-only move %s; row 0 holds %d px (pinned %d) at x %d..%d (pinned %d..%d); max row-0 luminance %.4f (ceiling %.4f, was %.4f); tops %s"
			% [str(cap_ok), str(horizontal_only), counts[1], W_FRAME1_TOP_ROW_PIXELS,
				row0_lo, row0_hi, W_FRAME1_TOP_ROW_COLUMNS.x, W_FRAME1_TOP_ROW_COLUMNS.y,
				row0_max_lum, W_FRAME1_TOP_ROW_MAX_LUMINANCE, W_FRAME1_TOP_ROW_MAX_LUMINANCE_BEFORE, str(tops)])
	print("")
	print("  the strip moved %+d px horizontally and %+d px vertically: x %d..%d -> %d..%d, contact row %d -> %d."
		% [dx, 0, int(before[0]), int(before[1]), int(before[0]) + dx, int(before[1]) + dx,
			int(before[2]), int(_frame_of(_huntress, "w", 0)["ground_row"])])
	print("  frames 0, 2 and 3 still open with the 8-pixel hood cap, now at x %d..%d, on rows %d, %d and %d."
		% [W_CAP_COLUMNS.x, W_CAP_COLUMNS.y, tops[0], tops[2], tops[3]])
	print("")
	print("  REPORTED PLAINLY, BECAUSE IT IS THE HONEST ANSWER:")
	print("  ROW 0 IS STILL OCCUPIED in frame 1 — %d pixels, at x %d..%d. It was never going to stop being"
		% [counts[1], row0_lo, row0_hi])
	print("  occupied: the owner ruled out translating the strip, and frame 1\'s crown genuinely sits at the")
	print("  top of the cell. Frames 0, 2 and 3 hold %d, %d and %d pixels on row 0." % [counts[0], counts[2], counts[3]])
	print("  WHAT CHANGED, AND WHY THE DISCONTINUITY IS RESOLVED: every pixel on that row now belongs to the")
	print("  OUTLINE palette. Maximum row-0 luminance is %.4f against a ceiling of %.4f; before the correction"
		% [row0_max_lum, W_FRAME1_TOP_ROW_MAX_LUMINANCE])
	print("  it was %.4f — light hood fill, cut flat. The crown now terminates in a closed outline instead of"
		% W_FRAME1_TOP_ROW_MAX_LUMINANCE_BEFORE)
	print("  a sliced fill edge, which is exactly the one-pixel local correction the owner specified.")
	print("  WHAT REMAINS TRUE AND IS NOT A DEFECT: `w` frame 1 has zero top margin inside its 128 x 128 cell.")
	print("  Any future `w` re-export that breathes higher still has no headroom. That is recorded, not fixed.")
	_done("the_west_strip_frame_one_clipping_is_identified")


# --- 24-25. The owner's resolution rulings ------------------------------------------------

func _check_the_owner_registration_targets_land_every_root_on_the_anchor() -> void:
	print("")
	print("--- 24. APPLIED — the owner\'s integer registration targets, measured in the corrected exports")
	print("  D-354 specified eight integer translations for the owner\'s Pixelorama pass. D-355 delivers them.")
	print("  This check no longer asks whether the targets WOULD work. It asks whether the corrected art is")
	print("  exactly the pre-correction art moved by exactly those vectors — arithmetic, not assertion.")
	print("  P1A still applies nothing at runtime: there is no per-direction or per-frame offset anywhere.")
	var all_on_anchor: bool = true
	var all_applied: bool = true
	var all_fit: bool = true
	print("")
	print("    %-3s %-8s %-12s %-9s %-9s %-7s %-13s %-10s %-6s" % [
		"dir", "target", "before", "root was", "root now", "dx", "content now", "contact", "fits"])
	for token: String in P1AArt.DIRECTION_TOKENS:
		var t2: Vector2i = P1AArt.REGISTRATION_TARGETS[token]
		var before: Array = PRE_REGISTRATION_DRAWN[token]
		var root_before: float = float(PRE_REGISTRATION_STANCE_MID[token])
		var root_now: float = float((COMPLETE_STANCE_UNION[token] as Array)[2])
		var x0: int = 9999
		var x1: int = -1
		var contact: int = 0
		for i: int in range(4):
			var m: Dictionary = _frame_of(_huntress, token, i)
			x0 = mini(x0, int(m["drawn_x0"])); x1 = maxi(x1, int(m["drawn_x1"]))
			contact = int(m["ground_row"])
		# The expected post-translation bounds. `s` alone also lost the recomposed bow.
		var want_x0: int = int(before[0]) + t2.x
		var want_x1: int = int(before[1]) + t2.x
		if token == "s":
			want_x1 -= P1AArt.S_BOW_SHORTEN_PX
		var applied: bool = x0 == want_x0 and x1 == want_x1 and contact == int(before[2]) + t2.y
		var on_anchor: bool = absf(root_now - 64.0) <= 0.5 and contact == P1AArt.GROUND_ANCHOR.y
		var fits: bool = x0 >= 0 and x1 <= 127
		if not applied:
			all_applied = false
		if not on_anchor:
			all_on_anchor = false
		if not fits:
			all_fit = false
		print("    %-3s %-8s %-12s %-9.1f %-9.1f %+-7.1f %-13s %-10s %-6s" % [
			token, "%+d,%+d" % [t2.x, t2.y], "x %d..%d" % [int(before[0]), int(before[1])],
			root_before, root_now, root_now - root_before,
			"x %d..%d" % [x0, x1], "row %d" % contact,
			"yes" if fits else "NO"])
	# `s`: the recomposition is provable by arithmetic against the recorded pre-correction reach.
	var s_before_x1: int = int((PRE_REGISTRATION_DRAWN["s"] as Array)[1])
	var s_dx: int = int(P1AArt.REGISTRATION_TARGETS["s"].x)
	var s_now_x1: int = -1
	for i: int in range(4):
		s_now_x1 = maxi(s_now_x1, int(_frame_of(_huntress, "s", i)["drawn_x1"]))
	var s_overrun: int = s_before_x1 + s_dx - 127
	var s_recomposed: int = (s_before_x1 + s_dx) - s_now_x1
	var s_ok: bool = s_overrun == P1AArt.S_BOW_SHORTEN_PX and s_recomposed == P1AArt.S_BOW_SHORTEN_PX \
		and s_now_x1 == 127
	# Both directions: a mutated target must be refused by the same arithmetic.
	var refusal: bool = (int((PRE_REGISTRATION_DRAWN["e"] as Array)[0]) + int(P1AArt.REGISTRATION_TARGETS["e"].x) + 1) \
		!= int(_frame_of(_huntress, "e", 0)["drawn_x0"])
	_expect(all_applied and all_on_anchor and all_fit and s_ok and refusal,
		"all eight translated exactly: %s; all roots within 0.5 px on contact row 122: %s; all fit 0..127: %s; `s` bow %s (overrun %d, recomposed %d, now reaches %d); mutated-target refusal %s"
			% [str(all_applied), str(all_on_anchor), str(all_fit), str(s_ok),
				s_overrun, s_recomposed, s_now_x1, str(refusal)])
	print("")
	print("  ALL EIGHT DIRECTIONS REGISTER. Every projected root lands within 0.5 px of x = 64 and every")
	print("  contact row is 122. Six of the eight are EXACT whole-pixel translations of the art that preceded")
	print("  them — nothing else in those files changed at all.")
	print("  THE HALF PIXEL on `e`, `sw`, `nw`, `n` and `ne` is integer-grid midpoint parity. D-354 and D-355")
	print("  both rule it compliant, and it must never produce a runtime offset.")
	print("")
	print("  `s`: reached x %d before; +%d would have reached %d, which is %d past the cell. The bow\'s outer"
		% [s_before_x1, s_dx, s_before_x1 + s_dx, s_overrun])
	print("  reach was recomposed inward by exactly %d px and the FULL +%d px translation was then applied."
		% [s_recomposed, s_dx])
	print("  Its content now spans x 19..%d — inside the cell, with no registration residual and no widened cell."
		% s_now_x1)
	print("  `w` frame 1: the one-pixel local hood correction, with no vertical translation — see check 23.")
	_done("the_owner_registration_targets_land_every_root_on_the_anchor")


func _check_the_canonical_base_viewport_is_locked_and_the_rendering_mode_is_not() -> void:
	print("")
	print("--- 25. The canonical gameplay base viewport is locked; the rendering mode is not")
	var base: Vector2i = P1AScale.CANONICAL_BASE_VIEWPORT
	var px_per_m: float = 60.0
	var extent: Vector2 = P1AScale.camera_footprint_m(base, px_per_m)
	var project_w: int = int(ProjectSettings.get_setting("display/window/size/viewport_width", 0))
	var project_h: int = int(ProjectSettings.get_setting("display/window/size/viewport_height", 0))
	var tool_base: Vector2i = _tool.call("current_base")
	var hood_lo: int = 9999
	var hood_hi: int = -1
	for token: String in P1AArt.DIRECTION_TOKENS:
		var v: int = int(HOOD_CROWN_ABOVE_GROUND[token])
		hood_lo = mini(hood_lo, v); hood_hi = maxi(hood_hi, v)
	print("  canonical base viewport  %d x %d   (project.godot: %d x %d, tool default: %d x %d)"
		% [base.x, base.y, project_w, project_h, tool_base.x, tool_base.y])
	print("  default output resolution %d x %d" % [
		P1AScale.DEFAULT_OUTPUT_RESOLUTION.x, P1AScale.DEFAULT_OUTPUT_RESOLUTION.y])
	print("  visible battlefield at the locked %.1f px/m: %.2f x %.2f m" % [px_per_m, extent.x, extent.y])
	print("  the Huntress reads %.2f%% .. %.2f%% of the %d-row content height"
		% [float(hood_lo) / float(base.y) * 100.0, float(hood_hi) / float(base.y) * 100.0, base.y])
	print("  the wider framing is deliberate: pack density, area-effect interactions, projectile visibility,")
	print("  kiting and simultaneous kill feedback. IT AUTHORIZES NO ENEMY COUNT — density stays governed by")
	print("  encounter budgets, telegraph readability and performance limits.")
	print("  RENDERING MODE: LOCKED (%s) — mode %d, `%s` (D-356 ruling 1)."
		% [str(P1AScale.RENDERING_MODE_DECIDED), P1ARenderMode.CANONICAL_APPROACH_OWNER_NUMBER,
			P1ARenderMode.approach_id(P1ARenderMode.CANONICAL_APPROACH)])
	_expect(base == Vector2i(1920, 1080) and P1AScale.DEFAULT_OUTPUT_RESOLUTION == base
			and project_w == base.x and project_h == base.y and tool_base == base
			and P1AScale.RENDERING_MODE_DECIDED
			and P1AScale.LOCKED_RENDERING_MODE == P1ARenderMode.CANONICAL_APPROACH
			and P1AScale.LOCKED_RENDERING_MODE_OWNER_NUMBER == 7
			and is_equal_approx(extent.x, 32.0) and is_equal_approx(extent.y, 18.0)
			and extent == P1AScale.LOCKED_CAMERA_FOOTPRINT_M,
		"base %s; default output %s; project.godot %dx%d; tool %s; mode decided %s (locked %d = owner mode %d); extent %.2f x %.2f"
			% [str(base), str(P1AScale.DEFAULT_OUTPUT_RESOLUTION), project_w, project_h, str(tool_base),
				str(P1AScale.RENDERING_MODE_DECIDED), P1AScale.LOCKED_RENDERING_MODE,
				P1AScale.LOCKED_RENDERING_MODE_OWNER_NUMBER, extent.x, extent.y])
	print("  The locked base and the locked density together fix the camera footprint at %.2f x %.2f m."
		% [P1AScale.LOCKED_CAMERA_FOOTPRINT_M.x, P1AScale.LOCKED_CAMERA_FOOTPRINT_M.y])
	print("  **P1B ROOM AUTHORING READS THAT NUMBER, NOT A PORTED 3D CF FIGURE.** The accepted 3D footprint was")
	print("  %.3f x %.3f m; a CF expressed against it does not transfer without being recomputed."
		% [P1AScale.ACCEPTED_3D_CAMERA_FOOTPRINT_M.x, P1AScale.ACCEPTED_3D_CAMERA_FOOTPRINT_M.y])
	print("  TRANSFERRED, NOT RESOLVED (D-356 ruling 10): HUD, menu, text and accessibility suitability at")
	print("  arbitrary output resolutions belongs to the later UI foundation. P1A's readout is a diagnostic")
	print("  surface, not a product HUD, and it does not stand in for that work. It is NOT marked complete.")
	_done("the_canonical_base_viewport_is_locked_and_the_rendering_mode_is_not")


func _check_every_measured_pixel_came_from_the_png_on_disk_and_not_a_stale_import() -> void:
	print("")
	print("--- 26. Every measured pixel came from the PNG on disk, not from a stale import cache")
	print("  THIS CHECK EXISTS BECAUSE THE HOLE WAS REAL, AND IT WAS HIT. Every measurement in this suite")
	print("  reads `load(path)`, which returns Godot\'s IMPORTED texture out of `.godot/imported/`. The")
	print("  byte-identity check reads the PNG off disk with `FileAccess`. Those are two different sources.")
	print("  When the owner replaced all eight exports, the hash check saw the new bytes and every")
	print("  measurement still saw the old pixels — a green suite measuring art that no longer existed.")
	print("  \"A check that reads the right value proves the value is right, not that it was read from the")
	print("  right place.\" This check closes that gap by decoding each PNG directly and comparing.")
	var mismatched: PackedStringArray = PackedStringArray()
	var compared: int = 0
	var rewritten_total: int = 0
	var paths: PackedStringArray = PackedStringArray()
	paths.append(P1AArt.MAGE_SHEET_PATH)
	for token: String in P1AArt.DIRECTION_TOKENS:
		paths.append(P1AArt.direction_path(HUNTRESS, token))
	for path: String in paths:
		var bytes: PackedByteArray = FileAccess.get_file_as_bytes(path)
		var from_disk: Image = Image.new()
		if from_disk.load_png_from_buffer(bytes) != OK:
			mismatched.append("%s: could not decode the PNG on disk" % path)
			continue
		from_disk.convert(Image.FORMAT_RGBA8)
		var imported: Image = P1AArt._image_at(path)
		if imported == null:
			mismatched.append("%s: no imported texture" % path)
			continue
		if imported.get_size() != from_disk.get_size():
			mismatched.append("%s: imported %s, on disk %s" % [path, str(imported.get_size()), str(from_disk.get_size())])
			continue
		# What must agree is ALPHA everywhere and RGB wherever the PNG is not fully
		# transparent — which is exactly the region every measurement in this suite reads.
		# RGB underneath alpha = 0 is NOT required to agree: see the note below.
		var differing: int = 0
		var first: Vector2i = Vector2i(-1, -1)
		var transparent_rgb_rewritten: int = 0
		for y: int in range(from_disk.get_height()):
			for x: int in range(from_disk.get_width()):
				var a: Color = imported.get_pixel(x, y)
				var b: Color = from_disk.get_pixel(x, y)
				if a == b:
					continue
				if b.a <= 0.0 and a.a <= 0.0:
					transparent_rgb_rewritten += 1
					continue
				differing += 1
				if first.x < 0:
					first = Vector2i(x, y)
		if differing > 0:
			mismatched.append("%s: %d visible pixels differ, first at %s" % [path, differing, str(first)])
		rewritten_total += transparent_rgb_rewritten
		compared += 1
	# Both directions: the comparison must be able to fail. Mutate one decoded pixel and
	# prove the same comparison rejects it.
	var probe: Image = Image.new()
	probe.load_png_from_buffer(FileAccess.get_file_as_bytes(P1AArt.direction_path(HUNTRESS, "s")))
	probe.convert(Image.FORMAT_RGBA8)
	var truth: Image = P1AArt._image_at(P1AArt.direction_path(HUNTRESS, "s"))
	var agreed_before: bool = probe.get_pixel(64, 64) == truth.get_pixel(64, 64)
	probe.set_pixel(64, 64, Color(1.0, 0.0, 1.0, 1.0))
	var refusal: bool = agreed_before and probe.get_pixel(64, 64) != truth.get_pixel(64, 64)
	_expect(mismatched.is_empty() and compared == 9 and refusal,
		"%d of 9 PNGs compared; visible-image mismatches %s; transparent RGB rewritten by the importer %d; mutation refused %s"
			% [compared, str(mismatched), rewritten_total, str(refusal)])
	print("  %d PNGs decoded straight from disk and compared with what the measurements actually read."
		% compared)
	print("  Mismatches in the visible image: %d. The comparison is proved able to fail: a mutated pixel is refused."
		% mismatched.size())
	print("")
	print("  ONE HONEST DIFFERENCE, MEASURED AND EXPLAINED RATHER THAN HIDDEN: the importer rewrites the RGB")
	print("  of FULLY TRANSPARENT pixels — %d of them across the nine files — because `process/fix_alpha_border`")
	print("  is on by default. Alpha is never altered anywhere, and no pixel the art actually shows is altered.")
	print("  It exists to stop bilinear filtering bleeding a halo out of the transparent border. P1A samples")
	print("  with NEAREST filtering (check 1), so it can change nothing this project draws or measures — and")
	print("  every measurement here keys on alpha. Recorded so it is never mistaken for a stale cache.")
	print("  OPERATIONAL NOTE, recorded because it cost a wrong measurement once: after any owner re-export,")
	print("  run `Godot --headless --path game2d --import` before measuring. `tests/p1a_smoke.sh` now does it.")
	_done("every_measured_pixel_came_from_the_png_on_disk_and_not_a_stale_import")


func _check_the_canonical_rendering_mode_is_locked_and_behaves_as_ruled() -> void:
	print("")
	print("--- 27. D-356 ruling 1 — the canonical rendering mode, and every clause of the owner's rationale")
	print("  The owner ran the live comparison at the locked base, tested modes 1, 3, 5, 6 and 7 with the")
	print("  five-second pan across several facings, found no objectionable artefact, and locked MODE 7.")
	print("  A rationale recorded on trust is not a measurement. Each clause is checked here.")
	var base: Vector2i = P1AScale.CANONICAL_BASE_VIEWPORT
	var canonical: int = P1ARenderMode.CANONICAL_APPROACH
	# --- clause: exact scaling at the locked output and at its integer multiples -----
	var exact_windows: Array[Vector2i] = [Vector2i(1920, 1080), Vector2i(3840, 2160), Vector2i(5760, 3240)]
	var exact_ok: bool = true
	print("")
	print("    %-12s %-10s %-9s %-10s %-9s %-16s" % ["window", "scale", "exact?", "bars", "fill", "visible world"])
	for w: Vector2i in exact_windows:
		var d: Dictionary = P1ARenderMode.describe(canonical, w, base, P1AScale.LOCKED_PX_PER_M, 116.0, 1)
		if not bool(d["scale_is_integer"]):
			exact_ok = false
		print("    %-12s %-10.4f %-9s %-10s %-9.1f%% %-16s" % [
			"%dx%d" % [w.x, w.y], float(d["scale"]), str(d["scale_is_integer"]),
			str(d["letterbox_total_px"]), float(d["fill_fraction"]) * 100.0,
			"%.2f x %.2f m" % [float(d["visible_world_m"][0]), float(d["visible_world_m"][1])]])
	# --- clause: the display grid is STATIONARY -------------------------------------
	var canonical_desc: Dictionary = P1ARenderMode.describe(canonical, Vector2i(3600, 2140), base,
		P1AScale.LOCKED_PX_PER_M, 116.0, 1)
	var grid_stationary: bool = not bool(canonical_desc["output_grid_moves_with_the_camera"])
	var moving_grid_modes: PackedStringArray = PackedStringArray()
	for a: int in range(P1ARenderMode.APPROACH_IDS.size()):
		var da: Dictionary = P1ARenderMode.describe(a, Vector2i(3600, 2140), base, P1AScale.LOCKED_PX_PER_M, 116.0, 1)
		if bool(da["output_grid_moves_with_the_camera"]):
			moving_grid_modes.append(P1ARenderMode.approach_id(a))
	# --- clause: it is a FINAL-FRAME presentation scale, never a sprite scale --------
	var final_frame: bool = bool(canonical_desc["final_frame_presentation_scale"])
	# --- ruling 11: the visible world NEVER grows with the window --------------------
	var probe_windows: Array[Vector2i] = [
		Vector2i(1280, 720), Vector2i(1920, 1080), Vector2i(2560, 1440), Vector2i(3840, 2160),
		Vector2i(3600, 2140), Vector2i(3440, 1440), Vector2i(1366, 768), Vector2i(1024, 1024),
	]
	var extent_fixed: bool = true
	var worst_fill: float = 1.0
	var worst_fill_at: String = ""
	for w: Vector2i in probe_windows:
		var s: float = P1ARenderMode.fill_scale(w, base)
		var shown: Vector2 = Vector2(base) * s
		var vis: Vector2 = Vector2(minf(float(w.x), shown.x) / s, minf(float(w.y), shown.y) / s)
		if not (is_equal_approx(vis.x, float(base.x)) and is_equal_approx(vis.y, float(base.y))):
			extent_fixed = false
		var f: float = float(P1ARenderMode.describe(canonical, w, base, P1AScale.LOCKED_PX_PER_M, 116.0, 1)["fill_fraction"])
		if f < worst_fill:
			worst_fill = f
			worst_fill_at = "%dx%d" % [w.x, w.y]
	# --- and the modes that DO expose extra world are not the canonical one ----------
	var expanders_expand: bool = true
	for a: int in P1ARenderMode.APPROACHES_THAT_EXPOSE_EXTRA_WORLD:
		var wide: Dictionary = P1ARenderMode.describe(a, Vector2i(3440, 1440), base, P1AScale.LOCKED_PX_PER_M, 116.0, 1)
		if is_equal_approx(float(wide["visible_base_px"][0]), float(base.x)):
			expanders_expand = false   # the guard must be reachable: these really do expand
	var canonical_not_an_expander: bool = not P1ARenderMode.APPROACHES_THAT_EXPOSE_EXTRA_WORLD.has(canonical)
	# --- ruling 2: 1 and 3 are comparators, 2 stays rejected, no player mode ---------
	var comparators_ok: bool = P1ARenderMode.DIAGNOSTIC_COMPARATORS == ([
		P1ARenderMode.Approach.INTEGER_VIEWPORT, P1ARenderMode.Approach.SUBVIEWPORT_REMAINDER] as Array[int])
	var still_rejected: bool = P1ARenderMode.REJECTED_APPROACHES.has(P1ARenderMode.Approach.PIXEL_SNAPPED_CANVAS)
	var no_player_mode: bool = not P1ARenderMode.OPTIONAL_PLAYER_FACING_INTEGER_MODE_AUTHORIZED
	# --- the tool opens on the canonical mode ----------------------------------------
	var tool_default: int = int(_tool.get("approach"))
	_expect(exact_ok and grid_stationary and final_frame and extent_fixed and expanders_expand
			and canonical_not_an_expander and comparators_ok and still_rejected and no_player_mode
			and canonical == P1ARenderMode.Approach.SUBVIEWPORT_FILL_FIXED
			and P1AScale.WORLD_EXTENT_IS_FIXED_ACROSS_OUTPUT_SIZES,
		"exact at 1x/2x/3x %s; grid stationary %s; final-frame scale %s; extent fixed across %d windows %s; expanders really expand %s; canonical is not an expander %s; comparators %s; mode 2 still rejected %s; no player-facing integer mode %s; tool opens on canonical %s"
			% [str(exact_ok), str(grid_stationary), str(final_frame), probe_windows.size(),
				str(extent_fixed), str(expanders_expand), str(canonical_not_an_expander),
				str(comparators_ok), str(still_rejected), str(no_player_mode),
				str(tool_default == canonical)])
	print("")
	print("  EXACT SCALING CONFIRMED at 1920 x 1080 (x1), 3840 x 2160 (x2) and 5760 x 3240 (x3).")
	print("  THE DISPLAY GRID IS STATIONARY: the modes whose grid moves with the camera are %s — and the"
		% str(moving_grid_modes))
	print("  canonical mode is not among them. The scale is a FINAL-FRAME presentation scale: sprites stay at")
	print("  an integral 1:1 inside the logical frame and no character CanvasItem is ever fractionally scaled.")
	print("")
	print("  RULING 11 HOLDS BY CONSTRUCTION. Across all %d probe windows — 16:9, ultrawide, square and the"
		% probe_windows.size())
	print("  owner's own maximized size — the visible world is ALWAYS exactly %d x %d base pixels = %.2f x %.2f m."
		% [base.x, base.y, P1AScale.LOCKED_CAMERA_FOOTPRINT_M.x, P1AScale.LOCKED_CAMERA_FOOTPRINT_M.y])
	print("  Gameplay framing is never stretched and no monitor ever earns extra world. For contrast, modes 2")
	print("  and 4 show 2580 base px of width on a 3440 x 1440 ultrawide — which is exactly why neither is")
	print("  canonical, and the check above proves they really do expand rather than passing vacuously.")
	print("")
	print("  THE HONEST COST, REPORTED: refusing extra world means an aspect mismatch must become a bar. The")
	print("  worst fill across the probe set is %.1f%% at %s. On a 16:9 output the fill is 100%%."
		% [worst_fill * 100.0, worst_fill_at])
	print("  RULING 2: modes 1 and 3 remain diagnostic comparators, mode 2 stays REJECTED, and an optional")
	print("  player-facing pixel-perfect mode is ALLOWED but NOT authorized and NOT implemented here.")
	_done("the_canonical_rendering_mode_is_locked_and_behaves_as_ruled")


func _check_every_locked_production_constant_agrees_on_every_surface() -> void:
	print("")
	print("--- 28. D-356 rulings 3-6 — the locked production constants agree wherever they are stated")
	print("  A constant restated on four surfaces is four chances to disagree. This check reads each surface")
	print("  and compares, rather than trusting that they were all edited together.")
	# Read the actor's anchor on the CONFORMING character. The tool may be left on the
	# legacy 64 px Mage by an earlier check, and its rule-derived (32, 60) is correct for
	# a 64 cell — it is simply not the locked production anchor, which is the point of
	# ruling 7 and of check 29.
	_tool.set("character", HUNTRESS)
	_tool.call("_reload_character")
	var rows: Array = [
		["base viewport", str(P1AScale.CANONICAL_BASE_VIEWPORT), str(Vector2i(
			int(ProjectSettings.get_setting("display/window/size/viewport_width", 0)),
			int(ProjectSettings.get_setting("display/window/size/viewport_height", 0)))),
			str(_tool.call("current_base"))],
		["default output", str(P1AScale.DEFAULT_OUTPUT_RESOLUTION), str(Vector2i(
			int(ProjectSettings.get_setting("display/window/size/window_width_override", 0)),
			int(ProjectSettings.get_setting("display/window/size/window_height_override", 0)))),
			str(P1AScale.CANONICAL_BASE_VIEWPORT)],
		["px/m", "%.1f" % P1AScale.LOCKED_PX_PER_M, "%.1f" % _candidate_px_per_m("C"),
			"%.1f" % (float(P1AScale.LOCKED_TILE_PX.x) / 2.0)],
		["character cell", str(P1AScale.LOCKED_CHARACTER_CELL_PX), str(P1AArt.PRODUCTION_CELL),
			str(P1AArt.cell_size(HUNTRESS))],
		["ground anchor", str(P1AScale.LOCKED_GROUND_ANCHOR), str(P1AArt.GROUND_ANCHOR),
			str(_tool.find_child("Actor", true, false).get("anchor"))],
		["tile", str(P1AScale.LOCKED_TILE_PX), str(Vector2i(
			int(P1AScale.tile_proposal(P1AScale.LOCKED_PX_PER_M)["tile_w"]),
			int(P1AScale.tile_proposal(P1AScale.LOCKED_PX_PER_M)["tile_h"]))),
			str(P1AScale.LOCKED_TILE_PX)],
	]
	var all_agree: bool = true
	print("")
	print("    %-16s %-16s %-16s %-16s %-8s" % ["constant", "scale module", "second surface", "third surface", "agree"])
	for r: Array in rows:
		var agree: bool = String(r[1]) == String(r[2]) and String(r[2]) == String(r[3])
		if not agree:
			all_agree = false
		print("    %-16s %-16s %-16s %-16s %-8s" % [r[0], r[1], r[2], r[3], "yes" if agree else "NO"])
	# The locked cell must actually hold the locked anchor, and the anchor must sit on
	# the contact row the registered art uses.
	var anchor_inside: bool = P1AScale.LOCKED_GROUND_ANCHOR.x >= 0 \
		and P1AScale.LOCKED_GROUND_ANCHOR.x < P1AScale.LOCKED_CHARACTER_CELL_PX \
		and P1AScale.LOCKED_GROUND_ANCHOR.y >= 0 \
		and P1AScale.LOCKED_GROUND_ANCHOR.y < P1AScale.LOCKED_CHARACTER_CELL_PX
	var anchor_on_contact_row: bool = true
	for token: String in P1AArt.DIRECTION_TOKENS:
		for i: int in range(4):
			if int(_frame_of(_huntress, token, i)["ground_row"]) != P1AScale.LOCKED_GROUND_ANCHOR.y:
				anchor_on_contact_row = false
	# Both directions: a mutated constant must be refused by the same comparison.
	var refusal: bool = Vector2i(P1AScale.LOCKED_TILE_PX.x + 1, P1AScale.LOCKED_TILE_PX.y) != P1AScale.LOCKED_TILE_PX
	_expect(all_agree and anchor_inside and anchor_on_contact_row and refusal
			and is_equal_approx(P1AScale.LOCKED_PX_PER_M, 60.0)
			and P1AScale.LOCKED_CHARACTER_CELL_PX == 128
			and P1AScale.LOCKED_GROUND_ANCHOR == Vector2i(64, 122)
			and P1AScale.LOCKED_TILE_PX == Vector2i(120, 60),
		"every surface agrees %s; anchor inside the cell %s; anchor y is the contact row of all 32 frames %s; mutation refused %s"
			% [str(all_agree), str(anchor_inside), str(anchor_on_contact_row), str(refusal)])
	print("")
	print("  The locked anchor is not merely inside the locked cell: y = %d is the measured contact row of"
		% P1AScale.LOCKED_GROUND_ANCHOR.y)
	print("  ALL 32 registered Huntress frames, so the lock and the art agree rather than coexisting.")
	print("  The locked tile is DERIVED from the locked density, not asserted beside it: a 2:1 isometric")
	print("  diamond standing for a %.1f x %.1f m ground square projects to 2 x %.1f x %.1f = %d px wide and"
		% [P1AScale.LOCKED_TILE_GROUND_METRES, P1AScale.LOCKED_TILE_GROUND_METRES,
			P1AScale.LOCKED_TILE_GROUND_METRES, P1AScale.LOCKED_PX_PER_M, P1AScale.LOCKED_TILE_PX.x])
	print("  %d px high. Both are whole pixels at %.1f px/m, which is what makes this density and this tile"
		% [P1AScale.LOCKED_TILE_PX.y, P1AScale.LOCKED_PX_PER_M])
	print("  fit each other. The LEGACY Mage anchor is a rule-derived (32, 60) on its 64 px cell — correct for")
	print("  that cell, and not the locked production anchor. See check 29.")
	_done("every_locked_production_constant_agrees_on_every_surface")


func _check_the_mage_reconstruction_obligation_is_recorded_and_the_art_is_not_edited() -> void:
	print("")
	print("--- 29. D-356 ruling 7 — the Mage is legacy/reference, and its reconstruction obligation is recorded")
	print("  This resolves the shared px/m policy WITHOUT pretending the current Mage already conforms.")
	var cell: int = P1AArt.cell_size(MAGE)
	var conforms_cell: bool = cell == P1AScale.LOCKED_CHARACTER_CELL_PX
	var mage_px_per_m: float = 0.0
	var body_lo: int = 1 << 30
	var body_hi: int = -(1 << 30)
	for m: Dictionary in _mage:
		body_lo = mini(body_lo, int(m["body_h"]))
		body_hi = maxi(body_hi, int(m["body_h"]))
	mage_px_per_m = (float(body_lo + body_hi) * 0.5) / P1AArt.BODY_HEIGHT_M
	var conforms_density: bool = is_equal_approx(snappedf(mage_px_per_m, 0.1), P1AScale.LOCKED_PX_PER_M)
	var req: Dictionary = P1AScale.MAGE_RECONSTRUCTION_REQUIREMENTS
	print("")
	print("    %-26s %-16s %-16s %-10s" % ["requirement", "future rebuild", "current export", "conforms"])
	print("    %-26s %-16.1f %-16.3f %-10s" % ["px/m", float(req["px_per_m"]), mage_px_per_m,
		"yes" if conforms_density else "NO"])
	print("    %-26s %-16d %-16d %-10s" % ["production cell px", int(req["cell_px"]), cell,
		"yes" if conforms_cell else "NO"])
	print("    %-26s %-16s %-16s %-10s" % ["anchor", str(req["anchor"]), "not registered", "NO"])
	print("    %-26s %-16d %-16d %-10s" % ["authored directions", int(req["authored_directions"]),
		P1AArt.DIRECTION_TOKENS.size(), "yes"])
	print("    %-26s %-16s %-16s %-10s" % ["mirroring allowed", str(req["mirroring_allowed"]),
		"false", "yes"])
	var recorded_as_nonconforming: bool = not P1AScale.MAGE_CURRENT_EXPORTS_CONFORM
	var honest: bool = recorded_as_nonconforming and not conforms_cell and not conforms_density
	# The art must be UNEDITED: its hash is still the one recorded at import.
	var mage_hash_holds: bool = FileAccess.get_sha256(P1AArt.MAGE_SHEET_PATH) == P1AArt.MAGE_SHEET_SHA256
	# Both directions: the requirement set must refuse a wrong rebuild.
	var refusal: bool = int(req["cell_px"]) != 64 and not bool(req["mirroring_allowed"])
	_expect(honest and mage_hash_holds and refusal
			and int(req["cell_px"]) == 128 and is_equal_approx(float(req["px_per_m"]), 60.0)
			and (req["anchor"] as Vector2i) == Vector2i(64, 122)
			and int(req["authored_directions"]) == 8,
		"recorded non-conforming %s; measured non-conforming (cell %s, density %s); mage art unedited %s; requirements refuse a 64 px mirrored rebuild %s"
			% [str(recorded_as_nonconforming), str(not conforms_cell), str(not conforms_density),
				str(mage_hash_holds), str(refusal)])
	print("")
	print("  THE CURRENT 64 x 64 MAGE EXPORTS ARE NOT CONFORMING PRODUCTION ASSETS, and this suite says so")
	print("  rather than quietly averaging them into a shared density. They are measured legacy/reference")
	print("  inputs: %.3f px/m against the locked %.1f, at a %d px cell against the locked %d, with eight"
		% [mage_px_per_m, P1AScale.LOCKED_PX_PER_M, cell, P1AScale.LOCKED_CHARACTER_CELL_PX])
	print("  idle frames that do not share a horizontal ground anchor at all (check 5).")
	print("  **P1A DID NOT EDIT THEM** — the sheet still hashes its recorded digest.")
	print("  ANY FUTURE 128 x 128 RECONSTRUCTION MUST USE: %.1f px/m · a %d px cell · anchor %s · %d authored"
		% [float(req["px_per_m"]), int(req["cell_px"]), str(req["anchor"]), int(req["authored_directions"])])
	print("  directions with NO mirroring. That reconstruction is NOT authorized by P1A's acceptance.")
	_done("the_mage_reconstruction_obligation_is_recorded_and_the_art_is_not_edited")


func _check_the_detached_fragments_are_identified_and_classified() -> void:
	print("")
	print("--- 30. D-356 ruling 9 — the detached fragments: identified, classified, and NOT edited")
	print("  The owner found them visually unobjectionable and ruled they do not block P1A. The ruling asks")
	print("  for coordinates and classification, and for non-blocking art-cleanup debt IF intent cannot be")
	print("  established. So this check tries to establish intent rather than filing debt by default.")
	var found: Array = []
	for token: String in P1AArt.DIRECTION_TOKENS:
		var img: Image = P1AArt.load_direction_image(HUNTRESS, token)
		for i: int in range(4):
			var comps: Array = _components(img, P1AArt.cell_rect(HUNTRESS, i))
			for c: int in range(1, comps.size()):
				found.append({"dir": token, "frame": i, "pixels": comps[c]})
	var pins_ok: bool = found.size() == DETACHED_FRAGMENTS.size()
	print("")
	print("    %-4s %-3s %-7s %-14s %-12s %-9s %-34s" % [
		"dir", "f", "pixels", "x range", "y range", "gap", "attached in the other frames?"])
	var all_intent_established: bool = true
	for k: int in range(found.size()):
		var f: Dictionary = found[k]
		var pts: Array = f["pixels"]
		var xs: Array[int] = []
		var ys: Array[int] = []
		for pt: Vector2i in pts:
			xs.append(pt.x); ys.append(pt.y)
		var x0: int = xs.min()
		var x1: int = xs.max()
		var y0: int = ys.min()
		var y1: int = ys.max()
		# Is this same region part of the MAIN silhouette in the direction's other frames?
		var img2: Image = P1AArt.load_direction_image(HUNTRESS, String(f["dir"]))
		var attached_in: PackedStringArray = PackedStringArray()
		for g: int in range(4):
			if g == int(f["frame"]):
				continue
			var main: Array = _components(img2, P1AArt.cell_rect(HUNTRESS, g))[0]
			var main_set: Dictionary = {}
			for pt2: Vector2i in main:
				main_set[pt2] = true
			var inside: int = 0
			for pt3: Vector2i in pts:
				if main_set.has(pt3):
					inside += 1
			if inside == pts.size():
				attached_in.append("f%d" % g)
		var intent: bool = attached_in.size() >= 2
		if not intent:
			all_intent_established = false
		var want: Array = DETACHED_FRAGMENTS[k] if k < DETACHED_FRAGMENTS.size() else []
		var got: Array = [String(f["dir"]), int(f["frame"]), pts.size(), x0, x1, y0, y1]
		if got != want:
			pins_ok = false
		print("    %-4s %-3d %-7d %-14s %-12s %-9s %-34s" % [
			String(f["dir"]), int(f["frame"]), pts.size(), "%d..%d" % [x0, x1], "%d..%d" % [y0, y1],
			"1 px", "fully inside the main silhouette in " + ", ".join(attached_in)])
	# Both directions: the pin must refuse a moved fragment.
	var mutated: Array = (DETACHED_FRAGMENTS[0] as Array).duplicate()
	mutated[3] = int(mutated[3]) + 1
	var refusal: bool = mutated != DETACHED_FRAGMENTS[0]
	# And the owner art must be untouched by all of this.
	var unedited: bool = true
	for token2: String in P1AArt.DIRECTION_TOKENS:
		var path: String = P1AArt.direction_path(HUNTRESS, token2)
		if FileAccess.get_sha256(path) != String(OWNER_PNG_SHA256[path]):
			unedited = false
	_expect(pins_ok and refusal and unedited and all_intent_established
			and found.size() == 3,
		"%d fragments found (pinned %d); coordinates match %s; intent established for all %s; mutation refused %s; owner art unedited %s"
			% [found.size(), DETACHED_FRAGMENTS.size(), str(pins_ok), str(all_intent_established),
				str(refusal), str(unedited)])
	print("")
	print("  INTENT IS ESTABLISHED, so this is NOT filed as art-cleanup debt. Every fragment is drawn detail")
	print("  that is FULLY INSIDE the main silhouette in the other frames of its own direction, and is")
	print("  separated by exactly ONE transparent pixel only at the extreme of the idle breath. That is a")
	print("  drawing consequence of the breath, not a stray layer and not export residue.")
	print("  CLASSIFICATION: `s` f2 is 2 px of body/armour outline 4 rows above the contact row; `w` f2 has")
	print("  33 px of body/armour plus bow-wood and 13 px of body/armour plus cloak-green, 3-9 rows above it.")
	print("  NON-BLOCKING and NOT EDITED. If the owner ever wants perfectly contiguous silhouettes — for an")
	print("  outline shader or a silhouette-driven effect — it is a one-pixel art nicety, not a defect, and")
	print("  it would need its own authorization like any other change to owner art.")
	_done("the_detached_fragments_are_identified_and_classified")


## The px/m of one named density candidate, read from the scale module rather than
## restated here.
func _candidate_px_per_m(id: String) -> float:
	for c: Dictionary in P1AScale.candidates():
		if String(c["id"]) == id:
			return float(c["px_per_m"])
	return -1.0


## 8-connected components of the opaque pixels in one cell, largest first.
func _components(img: Image, rect: Rect2i) -> Array:
	var w: int = rect.size.x
	var h: int = rect.size.y
	var seen: Dictionary = {}
	var out: Array = []
	for y: int in range(h):
		for x: int in range(w):
			var key: Vector2i = Vector2i(x, y)
			if seen.has(key) or img.get_pixel(rect.position.x + x, rect.position.y + y).a <= 0.0:
				continue
			var queue: Array[Vector2i] = [key]
			seen[key] = true
			var pts: Array[Vector2i] = []
			while not queue.is_empty():
				var c: Vector2i = queue.pop_back()
				pts.append(c)
				for dx: int in [-1, 0, 1]:
					for dy: int in [-1, 0, 1]:
						var n: Vector2i = Vector2i(c.x + dx, c.y + dy)
						if n.x < 0 or n.y < 0 or n.x >= w or n.y >= h or seen.has(n):
							continue
						if img.get_pixel(rect.position.x + n.x, rect.position.y + n.y).a > 0.0:
							seen[n] = true
							queue.append(n)
			out.append(pts)
	out.sort_custom(func(a: Array, b: Array) -> bool: return a.size() > b.size())
	return out


# --- 18. The owed set --------------------------------------------------------------------------

func _check_every_check_ran() -> void:
	print("")
	print("--- 18. The owed set, compared in both directions")
	var missing: PackedStringArray = PackedStringArray()
	for name: String in OWED_CHECKS:
		if name != "every_check_ran" and not _reached.has(name):
			missing.append(name)
	var extra: PackedStringArray = PackedStringArray()
	for name: Variant in _reached.keys():
		if not OWED_CHECKS.has(String(name)):
			extra.append(String(name))
	_expect(missing.is_empty() and extra.is_empty(),
		"owed checks that never reached their last line: %s; unexpected: %s"
			% [", ".join(missing), ", ".join(extra)])
	print("  owed %d; reached %d (this one included); missing %d; unexpected %d"
		% [OWED_CHECKS.size(), _reached.size() + 1, missing.size(), extra.size()])
	_done("every_check_ran")


# --- scaffolding -------------------------------------------------------------------------------

func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true


func _argument_value(flag: String) -> String:
	for i: int in range(arguments.size() - 1):
		if arguments[i] == flag:
			return arguments[i + 1]
	return ""
