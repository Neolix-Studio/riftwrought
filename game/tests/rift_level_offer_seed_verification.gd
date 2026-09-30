extends SceneTree
## Riftwrought — Roguelite Foundation G2 verification: deterministic per-level
## offer-seed derivation.
##
## ONE FOCUSED HEADLESS TEST. The foundation is two pure-logic scripts under
## `scripts/level_seeds/`, so it needs no scene, no camera, no navigation, no
## rendering and no evidence frame, and it deliberately gets none. It runs as a
## `SceneTree` script exactly as every earlier foundation's suite does.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## EVERY EXPECTED SEED IS AN INDEPENDENT LITERAL. The derivation is never checked
## against a second copy of its own formula. The owner's eleven required examples,
## the extended corpus, both ends of every consecutive window, the wrap and period
## values, the arithmetic bounds, both modular inverses, the collisions, the D1
## lane seeds of derived roots and the four aggregates over the 20,416-result
## sweep were all calculated OUTSIDE this engine — by a re-implementation retyped
## from the brief, cross-checked against a logical-shift reading of the same
## formula — before they were typed here. A window whose first value is a typed
## literal and in which every adjacent step is exactly `LEVEL_STEP` modulo 2^32
## pins every value inside it without this file restating the rule.
##
## THE FEW PLACES THIS FILE MULTIPLIES BY A FROZEN STEP ARE DEMONSTRATIONS OF THE
## ENGINE OR OF MODULAR ARITHMETIC, NEVER A SECOND DERIVATION: a wrapping product
## shown to agree with the masked one (which is why masking order can only be
## pinned structurally), a modular inverse checked against 1, and an even-step
## contrast that is not the production step.
##
## IT READS NO OTHER SUITE. It names no file under `tests/` but its own, which the
## runner asserts, so nothing another suite names, formats or moves can change a
## result here. It reads accepted PRODUCTION files and calls the accepted offer
## composer's public, pure lane-seed derivation, because proving that composer's
## root-seed behaviour unchanged is one of this foundation's obligations.

# --- The two scripts this foundation owns ------------------------------------------

const DERIVATION_FILE: String = "res://scripts/level_seeds/rift_level_offer_seed_derivation.gd"
const READING_FILE: String = "res://scripts/level_seeds/rift_level_offer_seed_reading.gd"

const G2_FILES: Array[String] = [
	"res://scripts/level_seeds/rift_level_offer_seed_derivation.gd",
	"res://scripts/level_seeds/rift_level_offer_seed_reading.gd",
]

## The two global class names this foundation introduces. NOTHING that runs may
## reference either of them except an authorized reader below.
const G2_CLASSES: Array[String] = [
	"RiftLevelOfferSeedDerivation", "RiftLevelOfferSeedReading",
]

## THE FILES AUTHORIZED TO NAME A G2 CLASS, AND THE EXACT CLASSES EACH MAY NAME
## (Foundation G4, decision D-269). The repeated run-level coordinator asks this
## derivation for the current level's root seed from the run seed, and asks the
## reading's `ok` before it reads or forwards the seed (D-266 ruling 1); the
## run-level record re-derives its own root through it to check its provenance.
## Both therefore name the derivation and the reading. Neither is itself called by
## anything that runs.
##
## THIS REPLACES THE BLANKET "nothing that runs may name either class" ONE FOR
## ONE: the same single assertion is made either way, it still fails for any other
## file AND for any class a listed file is not granted, and the pinned count does
## not move.
const AUTHORIZED_READERS: Array = [
	["res://scripts/levels/rift_run_level_coordinator.gd", [
		"RiftLevelOfferSeedDerivation", "RiftLevelOfferSeedReading",
	]],
	["res://scripts/levels/rift_run_level_up_result.gd", [
		"RiftLevelOfferSeedDerivation", "RiftLevelOfferSeedReading",
	]],
]

## The only project classes each G2 file may name, PER FILE, checked against the
## engine's own global class list. The derivation names the reading because it
## builds one; the reading must never name the derivation, or the two files would
## each hold half of the other's rule.
const AUTHORIZED_CLASSES: Array = [
	["res://scripts/level_seeds/rift_level_offer_seed_derivation.gd", [
		"RiftLevelOfferSeedDerivation", "RiftLevelOfferSeedReading",
	]],
	["res://scripts/level_seeds/rift_level_offer_seed_reading.gd", [
		"RiftLevelOfferSeedReading",
	]],
]

## The accepted PRODUCTION files this foundation stands beside. Production files
## only: no other suite's source is read by this one.
const D1_COMPOSER_FILE: String = "res://scripts/offers/rift_offer_composition.gd"
const D1_OFFER_FILE: String = "res://scripts/offers/rift_offer.gd"
const E2_COORDINATOR_FILE: String = "res://scripts/levels/rift_level_up_coordinator.gd"
const E2_RESULT_FILE: String = "res://scripts/levels/rift_level_up_result.gd"
const G1_CURVE_FILE: String = "res://scripts/level_requirements/rift_level_requirement_curve.gd"
const G1_READING_FILE: String = "res://scripts/level_requirements/rift_level_requirement_reading.gd"

## Names G2 introduced that no accepted D1, E2 or G1 file may carry. Each was
## confirmed absent from all six before this foundation was written.
## `UNRESOLVED_SEED` is deliberately NOT in this list: the accepted offer already
## declares a constant of that name, for the same -1 convention, and sharing a
## word is not a dependency.
const G2_NAMES_OTHERS_MUST_NOT_CARRY: Array[String] = [
	"RiftLevelOfferSeedDerivation", "RiftLevelOfferSeedReading",
	"offer_root_seed_for", "RUN_HIGH_FOLD_STEP", "LEVEL_STEP", "MASK_32",
	"LARGEST_OFFER_ROOT_SEED", "UNSIGNED_SEED_BITS", "level_index", "run_key",
]

## G1's vocabulary, which no G2 file may carry: the two foundations answer
## different questions and neither is an input to the other.
const G1_NAMES_G2_MUST_NOT_CARRY: Array[String] = [
	"RiftLevelRequirementCurve", "RiftLevelRequirementReading", "requirement_for",
	"MAX_SUPPORTED_LEVEL", "REQUIREMENT_STEP", "BASE_REQUIREMENT",
	"LARGEST_EXACT_REQUIREMENT", "EXACT_INTEGER_BITS",
]

# --- Independent expectations ------------------------------------------------------
#
# Calculated outside this engine. Nothing below was produced by running G2.

## The three frozen constants, as the owner's brief states them.
const FROZEN_MASK: int = 4294967295
const FROZEN_FOLD_STEP: int = 65537
const FROZEN_LEVEL_STEP: int = 1000003

## The exact source spellings the brief freezes.
const FROZEN_DECLARATIONS: Array[String] = [
	"const MASK_32: int = 0xFFFF_FFFF",
	"const RUN_HIGH_FOLD_STEP: int = 65_537",
	"const LEVEL_STEP: int = 1_000_003",
]

const INT64_MAX: int = 9223372036854775807
const INT64_MIN: int = -9223372036854775808
const TWO_TO_THE_32: int = 4294967296

## [run seed, level, offer root seed] — the owner's eleven required examples.
const REQUIRED_EXAMPLES: Array = [
	[0, 1, 0],
	[0, 2, 1000003],
	[0, 3, 2000006],
	[99, 1, 99],
	[99, 2, 1000102],
	[404, 1, 404],
	[404, 10, 9000431],
	[-1, 1, 4294901758],
	[-1, 2, 934465],
	[9223372036854775807, 1, 2147418110],
	[-9223372036854775808, 1, 2147483648],
]

## [run seed, level, offer root seed] — the extended corpus: small, 32-bit-edge,
## 33-bit, negative and 64-bit-edge run seeds at Levels 1 and 2, three run seeds
## across levels at every boundary this foundation has, and a few rows elsewhere.
## No row repeats a required example.
const EXTENDED_CORPUS: Array = [
	[1, 1, 1], [1, 2, 1000004],
	[2, 1, 2], [2, 2, 1000005],
	[404, 2, 1000407],
	[12345, 1, 12345], [12345, 2, 1012348],
	[65535, 1, 65535], [65535, 2, 1065538],
	[65536, 1, 65536], [65536, 2, 1065539],
	[65537, 1, 65537], [65537, 2, 1065540],
	[2147483647, 1, 2147483647], [2147483647, 2, 2148483650],
	[2147483648, 1, 2147483648], [2147483648, 2, 2148483651],
	[4294967294, 1, 4294967294], [4294967294, 2, 1000001],
	[4294967295, 1, 4294967295], [4294967295, 2, 1000002],
	[4294967296, 1, 65537], [4294967296, 2, 1065540],
	[4294967297, 1, 65538], [4294967297, 2, 1065541],
	[4294901758, 1, 4294901758], [4294901758, 2, 934465],
	[-2, 1, 4294901757], [-2, 2, 934464],
	[-65537, 1, 4294836222], [-65537, 2, 868929],
	[-4294967296, 1, 4294901759], [-4294967296, 2, 934466],
	[-4294967297, 1, 4294836221], [-4294967297, 2, 868928],
	[9223372036854775807, 2, 2148418113],
	[-9223372036854775808, 2, 2148483651],
	[-9223372036854775807, 1, 2147483649], [-9223372036854775807, 2, 2148483652],
	[9223372036854775806, 1, 2147418109], [9223372036854775806, 2, 2148418112],
	[1311768467463790320, 1, 57226600], [1311768467463790320, 2, 58226603],
	[-1311768467463790320, 1, 4237675159], [-1311768467463790320, 2, 4238675162],
	[-1, 3, 1934468], [9223372036854775807, 3, 2149418116],
	[0, 10, 9000027], [-1, 10, 8934489], [9223372036854775807, 10, 2156418137],
	[0, 4295, 4294012882], [-1, 4295, 4293947344], [9223372036854775807, 4295, 2146463696],
	[0, 4296, 45589], [-1, 4296, 4294947347], [9223372036854775807, 4296, 2147463699],
	[0, 2147483648, 2146483645], [-1, 2147483648, 2146418107],
	[9223372036854775807, 2147483648, 4293901755],
	[0, 2147483649, 2147483648],
	[0, 4294967295, 4292967290], [-1, 4294967295, 4292901752],
	[9223372036854775807, 4294967295, 2145418104],
	[0, 4294967296, 4293967293], [-1, 4294967296, 4293901755],
	[9223372036854775807, 4294967296, 2146418107],
	[0, 4294967297, 0], [-1, 4294967297, 4294901758],
	[9223372036854775807, 4294967297, 2147418110],
	[0, 4294967298, 1000003], [-1, 4294967298, 934465],
	[9223372036854775807, 4294967298, 2148418113],
	[0, 8589934593, 0], [-1, 8589934593, 4294901758],
	[9223372036854775807, 8589934593, 2147418110],
	[0, 9223372036854775807, 4292967290], [-1, 9223372036854775807, 4292901752],
	[9223372036854775807, 9223372036854775807, 2145418104],
	[0, 360287970189636, 1026112137], [0, 360287970189637, 1027112140],
	[-1, 360287970189637, 1027046602],
	[9223372036854775807, 7, 2153418128], [-4294967297, 7, 5868943],
	[4294967296, 404, 403066746],
]

## Levels that must refuse, down to the most negative whole number there is:
## subtracting one from it wraps to the most positive, which is why the floor is
## checked before the subtraction.
const BELOW_ONE: Array[int] = [0, -1, -2, -1000000, -9223372036854775808]

## The run seeds each below-one level is asked with, so a refusal is shown to echo
## whatever run seed it was handed — the extremes included.
const REFUSAL_RUN_SEEDS: Array[int] = [0, 99, -1, 9223372036854775807, -9223372036854775808]

## Non-negative 32-bit run seeds whose Level-1 root must be the run seed itself.
const SMALL_SEEDS: Array[int] = [
	0, 1, 2, 99, 404, 12345, 65535, 65536, 65537, 1000003,
	2147483647, 2147483648, 4294901758, 4294967294, 4294967295,
]
## A stride across the whole 32-bit range: `i x 2^20 + (i & 1023)` for i < 4096.
const STRIDE_COUNT: int = 4096

## [run seed, level-1 root] just outside the non-negative 32-bit range, where the
## Level-1 root is the folded run key and NOT the run seed.
const OUTSIDE_SMALL: Array = [
	[4294967296, 65537],
	[-1, 4294901758],
	[9223372036854775807, 2147418110],
]

## [seed A, seed B, shared run key]: distinct run seeds that fold to one run key,
## and therefore to one root seed at EVERY level. No collision freedom is claimed.
const COLLISIONS: Array = [
	[65537, 4294967296, 65537],
	[-1, 4294901758, 4294901758],
	[-9223372036854775808, 2147483648, 2147483648],
]
## The levels each collision is shown at.
const COLLISION_LEVELS: Array[int] = [1, 2, 7, 99, 4296, 4294967296, 9223372036854775807]

## The two run seeds the offer composer's own 32-bit mask CONFLATES, which G2
## separates because it folds the high half in: [seed, composer's mask, G2 Level 1].
const COMPOSER_CONFLATED: Array = [
	[-1, 4294967295, 4294901758],
	[9223372036854775807, 4294967295, 2147418110],
]

## [run seed, level, root] rows where the addition wraps past 2^32 - 1.
const WRAP_ROWS: Array = [
	[4294967295, 1, 4294967295],
	[4294967295, 2, 1000002],
	[4294967294, 2, 1000001],
	[4294000000, 2, 32707],
	[0, 4295, 4294012882],
	[0, 4296, 45589],
]
## The first level whose index times the step reaches 2^32 for run key 0.
const FIRST_LEVEL_STEP_WRAP: int = 4296

## [run seed, level, root] rows at the period and at the largest level.
const PERIOD_ROWS: Array = [
	[0, 4294967296, 4293967293],
	[0, 4294967297, 0],
	[-1, 4294967297, 4294901758],
	[9223372036854775807, 4294967297, 2147418110],
	[0, 8589934593, 0],
	[0, 9223372036854775807, 4292967290],
]

## Two consecutive windows of this many levels per run seed, from Level 1.
const ADJACENCY_WINDOW: int = 10000
## [run seed, root at Level 1, root at Level 10000].
const ADJACENCY_ANCHORS: Array = [
	[0, 0, 1409095405],
	[-1, 4294901758, 1409029867],
	[9223372036854775807, 2147418110, 3556513515],
	[12345, 12345, 1409107750],
]
## Level pairs straddling the period boundary and the top of the level range.
const ADJACENT_EDGE_LEVELS: Array[int] = [4294967295, 4294967296, 9223372036854775806]

const UNIQUE_WINDOW: int = 65536
## [run seed, root at Level 1, root at Level 65536].
const UNIQUE_ANCHORS: Array = [
	[0, 0, 1110687165],
	[-1, 4294901758, 1110621627],
	[9223372036854775807, 2147418110, 3258105275],
	[12345, 12345, 1110699510],
]
## A window of 65,536 consecutive levels straddling the first period boundary.
const STRADDLE_FIRST_LEVEL: int = 4294934529
const STRADDLE_LAST_LEVEL: int = 4295000064
const STRADDLE_FIRST_ROOT: int = 1591640064
const STRADDLE_LAST_ROOT: int = 2702327229

## Both modular inverses modulo 2^32, found outside the engine.
const LEVEL_STEP_INVERSE: int = 2021759595
const FOLD_STEP_INVERSE: int = 4294901761

## The largest intermediate values, with the frozen constants.
const FOLD_PRODUCT_MAX: int = 281479271612415
const FOLD_SUM_MAX: int = 281483566579710
const LEVEL_PRODUCT_MAX: int = 4294980179901885
const LEVEL_SUM_MAX: int = 4294984474869180
const LEVEL_SUM_HEADROOM: int = 2147
const FOLD_SUM_HEADROOM: int = 32767
## (INT64_MAX - 1) x 1,000,003, as this engine's wrapping arithmetic reports it.
const WRAPPED_UNMASKED_PRODUCT: int = 9223372036852775802

## The four lane-domain values D-240 froze, and D-239's two documented example
## rows: [root seed, [Support, Combat and Defence, Utility] lane seeds].
const D1_FROZEN_DOMAINS: Array[int] = [0x6A09_E667, 0xBB67_AE85, 0x3C6E_F372]
const D1_DOCUMENTED_ROWS: Array = [
	[12345, [1009438761, 612468971, 1162198605]],
	[0, [2074702303, 856502828, 83415710]],
]
## [run seed, level, G2 root, [three D1 lane seeds of that root]] — computed by the
## same outside re-implementation, whose finalizer reproduces D-239's two
## documented rows exactly.
const G2_THROUGH_D1: Array = [
	[0, 2, 1000003, [2292283729, 947827100, 1771346622]],
	[-1, 1, 4294901758, [1741800899, 649659684, 4189526877]],
	[-1, 2, 934465, [1489837836, 21737076, 906185958]],
	[9223372036854775807, 1, 2147418110, [2625456106, 152125393, 2972848337]],
	[-9223372036854775808, 1, 2147483648, [2777110460, 460993806, 2836240306]],
	[404, 10, 9000431, [959342645, 2110333086, 1290806548]],
]
const THROUGH_D1_WINDOW: int = 16384

## G1's accepted representation boundary, as D-264 records it.
const G1_MAX_SUPPORTED_LEVEL: int = 360287970189636

## THE SWEEP, defined identically outside the engine: every high half below times
## 2^32 plus every low half below, in that order, at every sweep level in order.
const SWEEP_HIGH_HALVES: Array[int] = [
	-2147483648, -2147483647, -1073741824, -65537, -65536, -2, -1, 0, 1, 2,
	65535, 65536, 65537, 1073741823, 2147483646, 2147483647,
]
const SWEEP_LOW_HALVES: Array[int] = [
	0, 1, 2, 65535, 65536, 65537, 1000002, 1000003, 2147483647, 2147483648,
	4294901758, 4294967294, 4294967295,
]
const SWEEP_LEVELS: Array[int] = [
	1, 2, 3, 4, 10, 100, 4295, 4296, 65536, 1000003, 2147483647, 2147483648,
	2147483649, 4294967295, 4294967296, 4294967297, 8589934592, 8589934593,
	1099511627776, 4611686018427387904, 9223372036854775806, 9223372036854775807,
]
const SWEEP_SEEDS: int = 928
const SWEEP_RESULTS: int = 20416
const SWEEP_SUM: int = 44516600168232
const SWEEP_XOR: int = 3145776
const SWEEP_WEIGHTED_SUM: int = 446334862375735476
const SWEEP_DISTINCT: int = 5604

# --- Pins -------------------------------------------------------------------------

const EXPECTED_DERIVATION_SIGNATURES: Array[String] = [
	"offer_root_seed_for(run_seed: int, level: int) -> Object",
]

const EXPECTED_READING_SIGNATURES: Array[String] = [
	"refused(for_run_seed: int, for_level: int, reason: String) -> Object",
	"derived(for_run_seed: int, for_level: int, for_offer_root_seed: int) -> Object",
	"problem() -> String",
	"describe() -> String",
]

const EXPECTED_DERIVATION_CONSTANTS: Array[String] = [
	"FIRST_LEVEL", "MASK_32", "RUN_HIGH_FOLD_STEP", "LEVEL_STEP", "_BELOW_FIRST_LEVEL",
]

const EXPECTED_READING_CONSTANTS: Array[String] = [
	"UNSIGNED_SEED_BITS", "LARGEST_OFFER_ROOT_SEED", "UNRESOLVED_SEED",
]

const EXPECTED_READING_FIELDS: Array[String] = [
	"ok", "failure_reason", "run_seed", "level", "offer_root_seed",
]

## The only numeric literals each file's code may contain, normalized to decimal
## (underscores removed, hexadecimal converted) and sorted as text. A cap, a
## table, a salt, a version or a second step would arrive as exactly one more of
## these while naming nothing forbidden at all. The reading's 0 is the default of
## its two integer question fields; its 1 builds 2^32 - 1 and the -1 stand-in.
const EXPECTED_DERIVATION_NUMBERS: Array[String] = ["1", "1000003", "32", "4294967295", "65537"]
const EXPECTED_READING_NUMBERS: Array[String] = ["0", "1", "32"]

## Concrete names, and every spelling of the accepted composer's finalizer
## multipliers and frozen lane domains. G2 must neither restate that composer's
## mixer nor its domains. Scanned RAW, comments included — D-215's lesson.
const FORBIDDEN_TOKENS: Array[String] = [
	"card_power", "card_celerity", "card_vitality",
	"card_fleetness", "card_insight", "card_magnetism",
	"display_name", "base_weight", "magnitude",
	"QuickStrike", "quick_strike", "Graveblade", "reaching_edge", "sweeping_edge",
	"7FEB352D", "7FEB_352D", "7feb352d", "846CA68B", "846C_A68B", "846ca68b",
	"2146121005", "2221713035",
	"6A09", "BB67", "3C6E", "1779033703", "3144134277", "1013904242",
]

## A pure rule may read no ambient state whatsoever. Scanned RAW.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
	"get_tree", "get_node", "Node", "Performance", "hash(",
]

## THE SYSTEMS THIS FOUNDATION DEFERS, AS CODE TOKENS. Scanned over code lines
## only, because both files say in plain English that they keep no queue, mix
## nothing and cap nothing — and a raw scan would be red on exactly the sentences
## that promise it. The short ones are matched as whole identifier words.
const DEFERRED_MEMBER_TOKENS: Array[String] = [
	"experience", "requirement", "curve", "queue", "pending", "multiple",
	"level_up", "next_level", "mote", "enemy", "support", "rank", "card", "lane",
	"domain", "mix", "finalizer", "avalanche", "choice", "build", "ledger", "track",
	"award", "save", "persist", "storage", "schema", "version", "scene", "input",
	"ui", "signal", "cache", "memo", "history", "table", "cap", "clamp", "mini",
	"maxi", "random", "hash", "balance", "difficulty", "intensity", "reroll", "skip",
]

const WORD_MATCHED_TOKENS: Array[String] = [
	"mote", "rank", "card", "lane", "mix", "build", "track", "save", "scene", "input",
	"ui", "signal", "cache", "memo", "table", "cap", "mini", "maxi", "hash", "skip",
]

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]

const PROJECT_SETTINGS_FILE: String = "res://project.godot"
const SELF_FILE: String = "res://tests/rift_level_offer_seed_verification.gd"

const OWED_CHECKS: Array[String] = [
	"levels_below_one_refuse_with_no_usable_seed",
	"the_exact_examples_match_independent_literals",
	"level_one_preserves_small_non_negative_run_seeds",
	"both_halves_of_the_run_seed_reach_the_run_key",
	"negative_run_seeds_are_handled_reproducibly",
	"every_result_is_an_unsigned_32_bit_seed",
	"repeated_calls_are_bit_identical",
	"call_order_does_not_affect_results",
	"rebuilt_equivalent_inputs_produce_identical_results",
	"adjacent_levels_differ_by_exactly_the_level_step",
	"the_wrap_from_the_top_of_the_32_bit_range_is_correct",
	"levels_2_to_the_32_apart_share_a_root_seed",
	"a_consecutive_level_window_holds_no_duplicate",
	"the_odd_level_step_permutes_the_32_bit_residues",
	"both_masked_products_and_their_sums_stay_inside_signed_64_bits",
	"masking_happens_before_multiplication",
	"the_reading_catches_contradictory_shapes",
	"nothing_calls_g2_and_e2_still_takes_an_explicit_root_seed",
	"d1_lane_domains_mixer_and_root_seed_behaviour_are_unchanged",
	"g1_remains_independent",
	"the_derivation_is_stateless_scheduling_with_no_mixer",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0
var _successes: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation G2 — Deterministic Per-Level Offer-Seed Derivation ===")

	_check_levels_below_one_refuse()
	_check_the_exact_examples()
	_check_level_one_preserves_small_seeds()
	_check_both_halves_reach_the_run_key()
	_check_negative_seeds_are_reproducible()
	_check_every_result_is_unsigned_32_bit()
	_check_repeated_calls_are_bit_identical()
	_check_call_order_does_not_affect_results()
	_check_rebuilt_inputs_are_identical()
	_check_adjacent_levels_differ_by_the_step()
	_check_the_wrap_from_the_top()
	_check_the_period()
	_check_a_consecutive_window_is_unique()
	_check_the_step_permutes_the_residues()
	_check_the_arithmetic_stays_inside_64_bits()
	_check_masking_happens_before_multiplication()
	_check_the_reading_catches_contradictory_shapes()
	_check_nothing_calls_g2()
	_check_d1_is_unchanged()
	_check_g1_remains_independent()
	_check_stateless_scheduling_with_no_mixer()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT LEVEL OFFER SEED VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT LEVEL OFFER SEED VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. Below the first level --------------------------------------------------------

func _check_levels_below_one_refuse() -> void:
	print("")
	print("--- 1. Levels zero and below refuse with no usable seed")
	var driven: int = 0
	for level: int in BELOW_ONE:
		for run_seed: int in REFUSAL_RUN_SEEDS:
			var reading: RiftLevelOfferSeedReading = _ask(run_seed, level)
			_expect_refusal(reading, run_seed, level, "run seed %d at level %d" % [run_seed, level])
			driven += 1
			_expect(reading.failure_reason.contains("level %d" % level),
				"the refusal of level %d does not name it: %s" % [level, reading.failure_reason])
	## THE MOST NEGATIVE LEVEL IS REFUSED AS BELOW LEVEL 1, WHICH IS THE WHOLE PROOF
	## THAT THE FLOOR IS ASKED BEFORE THE SUBTRACTION: subtracting one from it first
	## would wrap it to the most positive level there is — a perfectly valid level,
	## which would then have been answered with a seed.
	var bottom: RiftLevelOfferSeedReading = _ask(0, INT64_MIN)
	_expect(not bottom.ok and bottom.failure_reason.contains("level %d" % INT64_MIN),
		"the most negative level was not refused as below Level 1: %s" % bottom.describe())
	_expect(_ask(0, INT64_MAX).ok,
		"the most positive level is refused, so the INT64_MIN row proves less than it says")

	## THE POSITIVE CONTROL: a floor that refused everything would pass every row
	## above.
	var first: RiftLevelOfferSeedReading = _ask(0, 1)
	_expect(first.ok, "level 1 was refused: %s" % first.failure_reason)
	_expect(RiftLevelOfferSeedReading.UNRESOLVED_SEED == -1,
		"the unresolved stand-in is %d, not -1" % RiftLevelOfferSeedReading.UNRESOLVED_SEED)

	print("  %d refusals across %d levels below 1, down to %d, and %d run seeds: each echoed both inputs, named its level and carried -1"
		% [driven, BELOW_ONE.size(), INT64_MIN, REFUSAL_RUN_SEEDS.size()])
	_done("levels_below_one_refuse_with_no_usable_seed")


# --- 2. The exact examples -------------------------------------------------------------

func _check_the_exact_examples() -> void:
	print("")
	print("--- 2. The required examples and the extended corpus match independent literals")
	var shown: PackedStringArray = PackedStringArray()
	for row: Array in REQUIRED_EXAMPLES:
		var reading: RiftLevelOfferSeedReading = _ask(int(row[0]), int(row[1]))
		_expect_success(reading, int(row[0]), int(row[1]), int(row[2]),
			"required example run seed %d at level %d" % [int(row[0]), int(row[1])])
		shown.append("(%d, %d) -> %d" % [int(row[0]), int(row[1]), reading.offer_root_seed])
	var matched: int = 0
	for row: Array in EXTENDED_CORPUS:
		var reading: RiftLevelOfferSeedReading = _ask(int(row[0]), int(row[1]))
		if reading.ok and reading.offer_root_seed == int(row[2]):
			matched += 1
		_expect_success(reading, int(row[0]), int(row[1]), int(row[2]),
			"corpus run seed %d at level %d" % [int(row[0]), int(row[1])])
	_expect(matched == EXTENDED_CORPUS.size(),
		"%d of %d corpus rows matched" % [matched, EXTENDED_CORPUS.size()])

	## THE CORPUS NEVER REPEATS A QUESTION, so its size is the number of distinct
	## answers it checks.
	var questions: Dictionary = {}
	for row: Array in REQUIRED_EXAMPLES + EXTENDED_CORPUS:
		questions["%d@%d" % [int(row[0]), int(row[1])]] = true
	_expect(questions.size() == REQUIRED_EXAMPLES.size() + EXTENDED_CORPUS.size(),
		"the independent corpus repeats a question")

	print("  %d of %d required examples exact: %s" % [
		REQUIRED_EXAMPLES.size(), REQUIRED_EXAMPLES.size(), ", ".join(shown)])
	print("  %d of %d extended corpus rows exact; %d distinct independently calculated questions"
		% [matched, EXTENDED_CORPUS.size(), questions.size()])
	_done("the_exact_examples_match_independent_literals")


# --- 3. Level 1 preserves small non-negative seeds --------------------------------------

func _check_level_one_preserves_small_seeds() -> void:
	print("")
	print("--- 3. Level 1 preserves every non-negative 32-bit run seed exactly")
	var preserved: int = 0
	var asked: int = 0
	var seeds: Array[int] = []
	seeds.append_array(SMALL_SEEDS)
	for i: int in STRIDE_COUNT:
		seeds.append(i * 1048576 + (i & 1023))
	for run_seed: int in seeds:
		asked += 1
		_expect(run_seed >= 0 and run_seed <= FROZEN_MASK,
			"the stride produced %d, outside the 32-bit range" % run_seed)
		var reading: RiftLevelOfferSeedReading = _ask(run_seed, 1)
		if reading.ok and reading.offer_root_seed == run_seed:
			preserved += 1
	_expect(preserved == asked, "%d of %d small run seeds were preserved at Level 1" % [preserved, asked])
	## THE STRIDE REACHES THE TOP OF THE RANGE, so "preserved" is not a property of
	## small numbers only.
	_expect(seeds.max() > 4290000000, "the stride stopped at %d" % seeds.max())

	## EXACTLY THE NON-NEGATIVE 32-BIT RANGE: one past it on either side, Level 1 is
	## the folded run key instead, and the rows below say so with literals.
	var outside: PackedStringArray = PackedStringArray()
	for row: Array in OUTSIDE_SMALL:
		var reading: RiftLevelOfferSeedReading = _ask(int(row[0]), 1)
		_expect_success(reading, int(row[0]), 1, int(row[1]), "run seed %d at Level 1" % int(row[0]))
		_expect(reading.offer_root_seed != int(row[0]),
			"run seed %d was preserved at Level 1 although it is outside 0 … 2^32 - 1" % int(row[0]))
		outside.append("%d -> %d" % [int(row[0]), reading.offer_root_seed])

	print("  %d of %d non-negative 32-bit run seeds, up to %d, are their own Level-1 root; outside that range: %s"
		% [preserved, asked, seeds.max(), ", ".join(outside)])
	_done("level_one_preserves_small_non_negative_run_seeds")


# --- 4. Both halves matter; collisions are real -------------------------------------------

func _check_both_halves_reach_the_run_key() -> void:
	print("")
	print("--- 4. Both halves of the run seed reach the run key; different run seeds can still collide")
	## THE LEVEL-1 ROOT IS THE RUN KEY, because the level index is zero there. So
	## every one of a seed's 64 bits is flipped in turn and the Level-1 root read.
	## For a low bit the key moves by +/-2^b; for a high bit by +/-2^(b-32) x 65,537
	## modulo 2^32 — never zero, because the fold step is odd. Measured anyway.
	var bases: Array[int] = [0, 12345, -1, INT64_MAX, INT64_MIN, 1311768467463790320]
	var flips: int = 0
	var unchanged: int = 0
	var low_flips: int = 0
	var high_flips: int = 0
	for base: int in bases:
		var key: int = _ask(base, 1).offer_root_seed
		for bit: int in 64:
			var flipped: int = base ^ (1 << bit)
			var moved_key: int = _ask(flipped, 1).offer_root_seed
			flips += 1
			if bit < 32:
				low_flips += 1
			else:
				high_flips += 1
			if moved_key == key:
				unchanged += 1
				_expect(false, "flipping bit %d of run seed %d left the run key at %d" % [bit, base, key])
	_expect(flips == bases.size() * 64 and low_flips == high_flips,
		"the flip sweep covered %d flips (%d low, %d high)" % [flips, low_flips, high_flips])

	## THE DIRECT HALF: the fold step is odd and has a modular inverse, so for a
	## fixed low half the map from high half to run key is a bijection — no two
	## high halves share a key. That algebra is proved in check 14; here it is
	## exercised: 4,096 high halves beside one low half give 4,096 keys.
	var keys: Dictionary = {}
	for high: int in 4096:
		var high_half: int = high * 1048573 % TWO_TO_THE_32
		var high_signed: int = high_half - TWO_TO_THE_32 if high_half >= 2147483648 else high_half
		keys[_ask(high_signed * TWO_TO_THE_32 + 12345, 1).offer_root_seed] = true
	_expect(keys.size() == 4096, "4,096 high halves beside one low half gave %d run keys" % keys.size())

	## AND THE LIMITATION, STATED WITH LITERALS: sixty-four bits fold into
	## thirty-two, so distinct run seeds can share a run key — and then EVERY level
	## of the two runs receives the same root seed. A collision needs both halves to
	## differ, which is exactly what each pair below does.
	var collided: PackedStringArray = PackedStringArray()
	for row: Array in COLLISIONS:
		var a: int = int(row[0])
		var b: int = int(row[1])
		_expect(a != b, "a collision row names one run seed twice")
		_expect((a & FROZEN_MASK) != (b & FROZEN_MASK) and ((a >> 32) & FROZEN_MASK) != ((b >> 32) & FROZEN_MASK),
			"collision %d / %d does not differ in both halves" % [a, b])
		for level: int in COLLISION_LEVELS:
			var reading_a: RiftLevelOfferSeedReading = _ask(a, level)
			var reading_b: RiftLevelOfferSeedReading = _ask(b, level)
			_expect(reading_a.offer_root_seed == reading_b.offer_root_seed,
				"run seeds %d and %d differ at level %d" % [a, b, level])
			_expect(reading_a.run_seed == a and reading_b.run_seed == b,
				"a colliding reading lost the run seed it was asked with")
		_expect(_ask(a, 1).offer_root_seed == int(row[2]),
			"collision %d / %d shares run key %d, not %d" % [a, b, _ask(a, 1).offer_root_seed, int(row[2])])
		collided.append("%d and %d share run key %d" % [a, b, int(row[2])])

	## THE OFFER COMPOSER'S OWN MASK CONFLATES TWO SEEDS G2 SEPARATES: D-239 records
	## -1 and INT64_MAX as one question under that mask, and G2 folds the high half
	## in, so they are two different questions here.
	for row: Array in COMPOSER_CONFLATED:
		_expect((int(row[0]) & FROZEN_MASK) == int(row[1]),
			"the composer's mask of %d is not %d" % [int(row[0]), int(row[1])])
		_expect(_ask(int(row[0]), 1).offer_root_seed == int(row[2]),
			"run seed %d's Level-1 root is not %d" % [int(row[0]), int(row[2])])
	_expect(int(COMPOSER_CONFLATED[0][2]) != int(COMPOSER_CONFLATED[1][2]),
		"G2 conflates -1 and INT64_MAX as the composer's mask does")

	print("  %d single-bit flips over %d run seeds (%d low, %d high): %d left the run key unchanged; 4096 high halves beside one low half gave %d run keys"
		% [flips, bases.size(), low_flips, high_flips, unchanged, keys.size()])
	print("  collisions exist and are not hidden: %s — at all %d levels asked" % [
		"; ".join(collided), COLLISION_LEVELS.size()])
	print("  -1 and 9223372036854775807 are one question under the composer's mask (4294967295) and two under G2 (4294901758, 2147418110)")
	_done("both_halves_of_the_run_seed_reach_the_run_key")


# --- 5. Negative seeds ---------------------------------------------------------------------

func _check_negative_seeds_are_reproducible() -> void:
	print("")
	print("--- 5. Negative run seeds are handled reproducibly")
	## THIS ENGINE'S RIGHT SHIFT KEEPS THE SIGN, measured rather than assumed — and
	## the second mask is exactly what makes that irrelevant: arithmetic and logical
	## readings of the shift agree once the result is masked to 32 bits, which is why
	## the outside re-implementation was checked against both.
	var minus_one: int = -1
	var bottom: int = INT64_MIN
	_expect((minus_one >> 32) == -1, "the right shift of -1 by 32 is %d here, not -1" % (minus_one >> 32))
	_expect(((minus_one >> 32) & FROZEN_MASK) == 4294967295,
		"the masked high half of -1 is %d" % ((minus_one >> 32) & FROZEN_MASK))
	_expect(((bottom >> 32) & FROZEN_MASK) == 2147483648,
		"the masked high half of INT64_MIN is %d" % ((bottom >> 32) & FROZEN_MASK))

	var negatives: int = 0
	var repeated: int = 0
	for row: Array in REQUIRED_EXAMPLES + EXTENDED_CORPUS:
		var run_seed: int = int(row[0])
		if run_seed >= 0:
			continue
		negatives += 1
		var first: String = _bits(_ask(run_seed, int(row[1])))
		var again: String = _bits(_ask(run_seed, int(row[1])))
		if first == again and _ask(run_seed, int(row[1])).offer_root_seed == int(row[2]):
			repeated += 1
		else:
			_expect(false, "negative run seed %d at level %d answered %s then %s" % [
				run_seed, int(row[1]), first, again])
	_expect(negatives >= 20, "only %d negative corpus rows exist, so this proves little" % negatives)
	_expect(repeated == negatives, "%d of %d negative rows reproduced exactly" % [repeated, negatives])

	## A NEGATIVE SEED IS NEVER REFUSED AND NEVER YIELDS A NEGATIVE ROOT.
	var fine: int = 0
	for high: int in [-2147483648, -1073741825, -65537, -2, -1]:
		for low: int in [0, 1, 65537, 2147483648, 4294967295]:
			var reading: RiftLevelOfferSeedReading = _ask(high * TWO_TO_THE_32 + low, 3)
			if reading.ok and reading.offer_root_seed >= 0:
				fine += 1
	_expect(fine == 25, "%d of 25 constructed negative run seeds answered a non-negative root" % fine)

	print("  the engine's right shift keeps the sign (-1 >> 32 = -1); masked, the high half of -1 is 4294967295 and of -9223372036854775808 is 2147483648")
	print("  %d negative corpus rows reproduced exactly, twice each; %d of 25 constructed negative run seeds answered a non-negative root"
		% [repeated, fine])
	_done("negative_run_seeds_are_handled_reproducibly")


# --- 6. The output range ---------------------------------------------------------------------

func _check_every_result_is_unsigned_32_bit() -> void:
	print("")
	print("--- 6. Every result of a substantial seed and level sweep is an unsigned 32-bit seed")
	## THE SWEEP IS PINNED WHOLE, NOT ONLY BOUNDED. Its count, sum, exclusive-or and
	## position-weighted sum were calculated outside the engine over the identical
	## definition, so every one of its results is checked against an independent
	## source, and not merely against the range.
	var seeds: Array[int] = _sweep_seeds()
	_expect(seeds.size() == SWEEP_SEEDS, "the sweep built %d run seeds, not %d" % [seeds.size(), SWEEP_SEEDS])
	var index: int = 0
	var total: int = 0
	var folded: int = 0
	var weighted: int = 0
	var lowest: int = INT64_MAX
	var highest: int = INT64_MIN
	var outside: int = 0
	var refused: int = 0
	var incoherent: int = 0
	var distinct: Dictionary = {}
	for run_seed: int in seeds:
		for level: int in SWEEP_LEVELS:
			var reading: RiftLevelOfferSeedReading = _ask(run_seed, level)
			index += 1
			if not reading.ok:
				refused += 1
				continue
			if not reading.problem().is_empty() or reading.run_seed != run_seed or reading.level != level:
				incoherent += 1
			var root: int = reading.offer_root_seed
			if root < 0 or root > FROZEN_MASK:
				outside += 1
			total += root
			folded ^= root
			weighted += index * root
			lowest = mini(lowest, root)
			highest = maxi(highest, root)
			distinct[root] = true
	_expect(index == SWEEP_RESULTS, "the sweep examined %d results, not %d" % [index, SWEEP_RESULTS])
	_expect(refused == 0, "%d sweep questions were refused; every run seed and positive level is valid" % refused)
	_expect(incoherent == 0, "%d sweep readings were incoherent or lost their question" % incoherent)
	_expect(outside == 0, "%d sweep results fell outside 0 … 4294967295" % outside)
	_expect(total == SWEEP_SUM, "the sweep sums to %d, not %d" % [total, SWEEP_SUM])
	_expect(folded == SWEEP_XOR, "the sweep folds to %d, not %d" % [folded, SWEEP_XOR])
	_expect(weighted == SWEEP_WEIGHTED_SUM,
		"the sweep's weighted sum is %d, not %d" % [weighted, SWEEP_WEIGHTED_SUM])
	_expect(distinct.size() == SWEEP_DISTINCT,
		"the sweep holds %d distinct roots, not %d" % [distinct.size(), SWEEP_DISTINCT])
	## BOTH ENDS OF THE RANGE ARE REACHED, so the range is not merely respected but
	## used.
	_expect(lowest == 0 and highest == FROZEN_MASK,
		"the sweep's roots run from %d to %d" % [lowest, highest])
	_expect(RiftLevelOfferSeedReading.LARGEST_OFFER_ROOT_SEED == FROZEN_MASK,
		"the reading's largest seed is %d" % RiftLevelOfferSeedReading.LARGEST_OFFER_ROOT_SEED)
	_expect(RiftLevelOfferSeedReading.UNSIGNED_SEED_BITS == 32,
		"the reading's seed width is %d bits" % RiftLevelOfferSeedReading.UNSIGNED_SEED_BITS)

	print("  %d run seeds x %d levels = %d results: 0 refused, 0 incoherent, 0 outside 0 … 4294967295; lowest %d, highest %d"
		% [seeds.size(), SWEEP_LEVELS.size(), index, lowest, highest])
	print("  sweep sum %d, xor %d, weighted sum %d and %d distinct roots — all four match the outside calculation"
		% [total, folded, weighted, distinct.size()])
	_done("every_result_is_an_unsigned_32_bit_seed")


# --- 7. Repetition -----------------------------------------------------------------------------

func _check_repeated_calls_are_bit_identical() -> void:
	print("")
	print("--- 7. Repeated calls return bit-identical results")
	var sample: Array = _sample_questions()
	var identical: int = 0
	for question: Array in sample:
		var a: RiftLevelOfferSeedReading = _ask(int(question[0]), int(question[1]))
		var b: RiftLevelOfferSeedReading = _ask(int(question[0]), int(question[1]))
		var c: RiftLevelOfferSeedReading = _ask(int(question[0]), int(question[1]))
		if _bits(a) == _bits(b) and _bits(b) == _bits(c):
			identical += 1
		else:
			_expect(false, "%s answered %s, then %s, then %s" % [str(question), _bits(a), _bits(b), _bits(c)])
		## A FRESH VALUE EACH TIME, never a cached one.
		_expect(a != b and b != c and a != c,
			"the derivation handed out one reading object twice for %s" % str(question))
	_expect(identical == sample.size(),
		"%d of %d sampled questions repeated bit for bit" % [identical, sample.size()])

	## A RETURNED READING IS THE CALLER'S OWN. Tampering with every field of one
	## reaches nothing the next call answers.
	var before: String = _bits(_ask(404, 10))
	var tampered: RiftLevelOfferSeedReading = _ask(404, 10)
	tampered.ok = false
	tampered.failure_reason = "zz tampered"
	tampered.run_seed = 405
	tampered.level = 11
	tampered.offer_root_seed = 1
	_expect(_bits(_ask(404, 10)) == before,
		"tampering with a returned reading changed the next answer to %s" % _bits(_ask(404, 10)))

	print("  %d sampled questions asked three times each: every answer bit-identical and a fresh value; a tampered reading reached nothing"
		% sample.size())
	_done("repeated_calls_are_bit_identical")


# --- 8. Order independence ---------------------------------------------------------------------

func _check_call_order_does_not_affect_results() -> void:
	print("")
	print("--- 8. Call order does not affect results")
	var sample: Array = _sample_questions()

	var forward: Dictionary = {}
	for question: Array in sample:
		forward[_key(question)] = _bits(_ask(int(question[0]), int(question[1])))

	var backward: Dictionary = {}
	for index: int in range(sample.size() - 1, -1, -1):
		var question: Array = sample[index]
		backward[_key(question)] = _bits(_ask(int(question[0]), int(question[1])))

	## FROM BOTH ENDS AT ONCE, with a refusal and an extreme success asked between
	## every pair — a derivation that remembered its last answer would show it.
	var interleaved: Dictionary = {}
	var low: int = 0
	var high: int = sample.size() - 1
	while low <= high:
		_ask(INT64_MIN, INT64_MIN)
		interleaved[_key(sample[low])] = _bits(_ask(int(sample[low][0]), int(sample[low][1])))
		_ask(INT64_MAX, INT64_MAX)
		interleaved[_key(sample[high])] = _bits(_ask(int(sample[high][0]), int(sample[high][1])))
		low += 1
		high -= 1

	## THROUGH TWO SEPARATE INSTANCES, alternately. There is nothing an instance
	## could hold, and this is the behaviour that says so.
	var one: RiftLevelOfferSeedDerivation = RiftLevelOfferSeedDerivation.new()
	var two: RiftLevelOfferSeedDerivation = RiftLevelOfferSeedDerivation.new()
	var through_instances: Dictionary = {}
	for index: int in sample.size():
		var derivation: RiftLevelOfferSeedDerivation = one if index % 2 == 0 else two
		var question: Array = sample[index]
		through_instances[_key(question)] = _bits(
			derivation.call("offer_root_seed_for", int(question[0]), int(question[1])) as RiftLevelOfferSeedReading)

	var disagreements: int = 0
	for question: Array in sample:
		var key: String = _key(question)
		for other: Dictionary in [backward, interleaved, through_instances]:
			if String(other.get(key, "")) != String(forward[key]):
				disagreements += 1
				_expect(false, "%s answered %s in one order and %s in another" % [
					key, String(forward[key]), String(other.get(key, "")),
				])
	_expect(disagreements == 0, "%d answers depended on call order" % disagreements)
	_expect(forward.size() == sample.size() and interleaved.size() == sample.size()
			and backward.size() == sample.size() and through_instances.size() == sample.size(),
		"an ordering pass skipped a question")

	print("  %d questions asked forwards, backwards, from both ends between extremes, and through two instances: 0 answers moved"
		% sample.size())
	_done("call_order_does_not_affect_results")


# --- 9. Rebuilt equivalent inputs ----------------------------------------------------------------

func _check_rebuilt_inputs_are_identical() -> void:
	print("")
	print("--- 9. Rebuilding equivalent inputs produces identical results")
	## EACH INPUT IS WRITTEN SEVERAL WAYS — a decimal literal, a hexadecimal
	## literal, its two halves recombined, parsed from text, or built by an
	## operation — and every spelling must reach the same answer, which is typed.
	var rebuilt: Array = [
		["INT64_MAX as decimal", 9223372036854775807, 7, 2153418128],
		["INT64_MAX as hexadecimal", 0x7FFF_FFFF_FFFF_FFFF, 7, 2153418128],
		["INT64_MAX from its halves", 2147483647 * TWO_TO_THE_32 + 4294967295, 7, 2153418128],
		["INT64_MAX from text", "9223372036854775807".to_int(), 7, 2153418128],
		["-1 as a literal", -1, 2, 934465],
		["-1 as the complement of zero", ~0, 2, 934465],
		["-1 from its halves", -1 * TWO_TO_THE_32 + 4294967295, 2, 934465],
		["-1 from text", "-1".to_int(), 2, 934465],
		["-4294967297 as a literal", -4294967297, 7, 5868943],
		["-4294967297 from its halves", -2 * TWO_TO_THE_32 + 4294967295, 7, 5868943],
		["-4294967297 from text", "-4294967297".to_int(), 7, 5868943],
		["2^32 as a literal", 4294967296, 404, 403066746],
		["2^32 as a shift", 1 << 32, 404, 403066746],
		["2^32 from its halves", 1 * TWO_TO_THE_32 + 0, 404, 403066746],
		["level 404 from text", 4294967296, "404".to_int(), 403066746],
		["level 404 by addition", 4294967296, 400 + 4, 403066746],
	]
	var agreed: int = 0
	for row: Array in rebuilt:
		var reading: RiftLevelOfferSeedReading = _ask(int(row[1]), int(row[2]))
		if reading.ok and reading.offer_root_seed == int(row[3]):
			agreed += 1
		else:
			_expect(false, "%s answered %s, not %d" % [String(row[0]), reading.describe(), int(row[3])])
	_expect(agreed == rebuilt.size(), "%d of %d rebuilt spellings agreed" % [agreed, rebuilt.size()])

	## A READING IS ITS OWN REPRODUCTION RECEIPT: asking again with nothing but the
	## run seed and level it carries gives the identical answer — for successes and
	## refusals alike.
	var receipts: int = 0
	for question: Array in _sample_questions():
		var original: RiftLevelOfferSeedReading = _ask(int(question[0]), int(question[1]))
		var again: RiftLevelOfferSeedReading = _ask(original.run_seed, original.level)
		if _bits(again) == _bits(original):
			receipts += 1
		else:
			_expect(false, "re-asking from %s gave %s" % [_bits(original), _bits(again)])
	_expect(receipts == _sample_questions().size(),
		"%d of %d readings reproduced from their own question" % [receipts, _sample_questions().size()])

	print("  %d of %d rebuilt spellings agreed with typed answers; %d of %d readings reproduced from their own run seed and level"
		% [agreed, rebuilt.size(), receipts, _sample_questions().size()])
	_done("rebuilt_equivalent_inputs_produce_identical_results")


# --- 10. Adjacent levels ---------------------------------------------------------------------------

func _check_adjacent_levels_differ_by_the_step() -> void:
	print("")
	print("--- 10. Adjacent levels differ by exactly LEVEL_STEP modulo 2^32")
	var steps: int = 0
	var exact: int = 0
	var shown: PackedStringArray = PackedStringArray()
	for row: Array in ADJACENCY_ANCHORS:
		var run_seed: int = int(row[0])
		var previous: int = _ask(run_seed, 1).offer_root_seed
		_expect(previous == int(row[1]), "run seed %d starts its window at %d, not %d" % [
			run_seed, previous, int(row[1])])
		var last: int = previous
		for level: int in range(2, ADJACENCY_WINDOW + 1):
			var current: int = _ask(run_seed, level).offer_root_seed
			steps += 1
			if ((current - previous) & FROZEN_MASK) == FROZEN_LEVEL_STEP:
				exact += 1
			previous = current
			last = current
		_expect(last == int(row[2]), "run seed %d ends its window at %d, not %d" % [
			run_seed, last, int(row[2])])
		shown.append("%d: %d -> %d" % [run_seed, int(row[1]), last])
	_expect(exact == steps, "%d of %d adjacent steps were exactly the level step" % [exact, steps])
	_expect(steps == ADJACENCY_ANCHORS.size() * (ADJACENCY_WINDOW - 1),
		"the windows walked %d steps" % steps)

	## AND AT THE EDGES: across the period boundary and at the very top of the level
	## range, the next level is still exactly one step on, modulo 2^32.
	var edges: int = 0
	for level: int in ADJACENT_EDGE_LEVELS:
		for run_seed: int in [0, -1, INT64_MAX]:
			var here: int = _ask(run_seed, level).offer_root_seed
			var next: int = _ask(run_seed, level + 1).offer_root_seed
			_expect(((next - here) & FROZEN_MASK) == FROZEN_LEVEL_STEP,
				"level %d to %d for run seed %d moved by %d" % [level, level + 1, run_seed, (next - here) & FROZEN_MASK])
			edges += 1

	print("  %d windows of %d levels: %s" % [ADJACENCY_ANCHORS.size(), ADJACENCY_WINDOW, "; ".join(shown)])
	print("  %d of %d adjacent steps exactly 1000003 modulo 2^32; %d edge steps across the period and at the top of the level range also exact"
		% [exact, steps, edges])
	_done("adjacent_levels_differ_by_exactly_the_level_step")


# --- 11. The wrap ------------------------------------------------------------------------------------

func _check_the_wrap_from_the_top() -> void:
	print("")
	print("--- 11. The wrap from the top of the 32-bit range is correct")
	var shown: PackedStringArray = PackedStringArray()
	for row: Array in WRAP_ROWS:
		var reading: RiftLevelOfferSeedReading = _ask(int(row[0]), int(row[1]))
		_expect_success(reading, int(row[0]), int(row[1]), int(row[2]),
			"wrap row run seed %d at level %d" % [int(row[0]), int(row[1])])
		shown.append("(%d, %d) -> %d" % [int(row[0]), int(row[1]), reading.offer_root_seed])
	## THE WRAP REALLY HAPPENED: the unmasked sum for run seed 2^32 - 1 at Level 2
	## exceeds the mask, and the answer is that sum less 2^32.
	_expect(FROZEN_MASK + FROZEN_LEVEL_STEP > FROZEN_MASK
			and FROZEN_MASK + FROZEN_LEVEL_STEP - TWO_TO_THE_32 == 1000002,
		"the Level-2 sum for run seed 2^32 - 1 did not cross the top of the range")
	## AND THE FIRST LEVEL WHOSE PRODUCT ALONE CROSSES 2^32 FOR RUN KEY 0 IS THE
	## ONE THE OUTSIDE CALCULATION NAMED: the level before it stays below.
	var before: RiftLevelOfferSeedReading = _ask(0, FIRST_LEVEL_STEP_WRAP - 1)
	var at: RiftLevelOfferSeedReading = _ask(0, FIRST_LEVEL_STEP_WRAP)
	_expect(before.offer_root_seed > at.offer_root_seed,
		"level %d does not wrap below level %d" % [FIRST_LEVEL_STEP_WRAP, FIRST_LEVEL_STEP_WRAP - 1])

	print("  %s; the first level-step wrap for run key 0 is at level %d" % [
		", ".join(shown), FIRST_LEVEL_STEP_WRAP])
	_done("the_wrap_from_the_top_of_the_32_bit_range_is_correct")


# --- 12. The period ------------------------------------------------------------------------------------

func _check_the_period() -> void:
	print("")
	print("--- 12. Levels 2^32 apart share a root seed — the schedule's stated period")
	for row: Array in PERIOD_ROWS:
		_expect_success(_ask(int(row[0]), int(row[1])), int(row[0]), int(row[1]), int(row[2]),
			"period row run seed %d at level %d" % [int(row[0]), int(row[1])])
	var repeats: int = 0
	var asked: int = 0
	for run_seed: int in [0, 99, -1, INT64_MAX, INT64_MIN, 12345]:
		for level: int in [1, 2, 3, 1000, 4296, 65536]:
			var here: RiftLevelOfferSeedReading = _ask(run_seed, level)
			var once: RiftLevelOfferSeedReading = _ask(run_seed, level + TWO_TO_THE_32)
			var twice: RiftLevelOfferSeedReading = _ask(run_seed, level + 2 * TWO_TO_THE_32)
			asked += 1
			if here.offer_root_seed == once.offer_root_seed and once.offer_root_seed == twice.offer_root_seed:
				repeats += 1
			else:
				_expect(false, "run seed %d: levels %d, %d and %d answered %d, %d and %d" % [
					run_seed, level, level + TWO_TO_THE_32, level + 2 * TWO_TO_THE_32,
					here.offer_root_seed, once.offer_root_seed, twice.offer_root_seed])
			## The period shares the SEED and nothing else: each reading still carries
			## the level it was asked about.
			_expect(once.level == level + TWO_TO_THE_32, "a period reading lost its level")
	_expect(repeats == asked, "%d of %d level triples 2^32 apart repeated" % [repeats, asked])
	## THE TOP OF THE LEVEL RANGE IS ONE MORE MEMBER OF THE SAME RESIDUE CLASS: the
	## largest positive level answers what level 2^32 - 1 answers.
	_expect(_ask(0, INT64_MAX).offer_root_seed == _ask(0, 4294967295).offer_root_seed,
		"the largest level does not share level 4294967295's root seed")
	## AND ONE PERIOD IS NOT A GAMEPLAY LIMIT: levels far beyond it all answer.
	_expect(_ask(0, 1 << 40).ok and _ask(0, 1 << 62).ok and _ask(0, INT64_MAX).ok,
		"a level beyond one period was refused")

	print("  level 1 and level 4294967297 share root 0 for run seed 0; %d of %d level triples 2^32 and 2 x 2^32 apart repeated; level 9223372036854775807 shares level 4294967295's root"
		% [repeats, asked])
	print("  THE SCHEDULE REPEATS EVERY 4294967296 LEVELS — a stated representation fact of the 32-bit seed domain, not a level cap")
	_done("levels_2_to_the_32_apart_share_a_root_seed")


# --- 13. A consecutive window is unique ----------------------------------------------------------

func _check_a_consecutive_window_is_unique() -> void:
	print("")
	print("--- 13. A substantial consecutive level window holds no duplicate root seed")
	var walked: int = 0
	var duplicates: int = 0
	for row: Array in UNIQUE_ANCHORS:
		var run_seed: int = int(row[0])
		var seen: Dictionary = {}
		var first: int = -1
		var last: int = -1
		for level: int in range(1, UNIQUE_WINDOW + 1):
			var root: int = _ask(run_seed, level).offer_root_seed
			if level == 1:
				first = root
			last = root
			if seen.has(root):
				duplicates += 1
			seen[root] = true
			walked += 1
		_expect(seen.size() == UNIQUE_WINDOW,
			"run seed %d: %d distinct roots over %d levels" % [run_seed, seen.size(), UNIQUE_WINDOW])
		_expect(first == int(row[1]) and last == int(row[2]),
			"run seed %d's window runs %d -> %d, not %d -> %d" % [run_seed, first, last, int(row[1]), int(row[2])])

	## ONE WINDOW STRADDLES THE FIRST PERIOD BOUNDARY: 65,536 levels contain no two
	## that are 2^32 apart, so they must still be distinct across the boundary.
	var straddle: Dictionary = {}
	var straddle_first: int = -1
	var straddle_last: int = -1
	for level: int in range(STRADDLE_FIRST_LEVEL, STRADDLE_LAST_LEVEL + 1):
		var root: int = _ask(0, level).offer_root_seed
		if level == STRADDLE_FIRST_LEVEL:
			straddle_first = root
		straddle_last = root
		if straddle.has(root):
			duplicates += 1
		straddle[root] = true
		walked += 1
	_expect(straddle.size() == UNIQUE_WINDOW,
		"the straddling window holds %d distinct roots" % straddle.size())
	_expect(straddle_first == STRADDLE_FIRST_ROOT and straddle_last == STRADDLE_LAST_ROOT,
		"the straddling window runs %d -> %d" % [straddle_first, straddle_last])
	_expect(duplicates == 0, "%d duplicates were found" % duplicates)

	## THE DETECTOR CAN FIND A DUPLICATE: levels 2^32 apart, placed in one window,
	## are reported — so the zero above is a measurement, not a blind spot.
	var control: Dictionary = {}
	var control_duplicates: int = 0
	for level: int in [1, 2, 3, 1 + TWO_TO_THE_32]:
		var root: int = _ask(0, level).offer_root_seed
		if control.has(root):
			control_duplicates += 1
		control[root] = true
	_expect(control_duplicates == 1, "the duplicate detector found %d in a window built to hold 1" % control_duplicates)

	print("  %d consecutive levels from Level 1 for each of %d run seeds, and %d straddling level 4294967296: %d levels walked, 0 duplicates; the detector finds the 1 planted"
		% [UNIQUE_WINDOW, UNIQUE_ANCHORS.size(), UNIQUE_WINDOW, walked])
	_done("a_consecutive_level_window_holds_no_duplicate")


# --- 14. The permutation, proved directly ------------------------------------------------------------

func _check_the_step_permutes_the_residues() -> void:
	print("")
	print("--- 14. The odd level step permutes the 32-bit residues — proved, not sampled")
	var step: int = RiftLevelOfferSeedDerivation.LEVEL_STEP
	var fold: int = RiftLevelOfferSeedDerivation.RUN_HIGH_FOLD_STEP
	_expect(step == FROZEN_LEVEL_STEP and fold == FROZEN_FOLD_STEP
			and RiftLevelOfferSeedDerivation.MASK_32 == FROZEN_MASK,
		"the frozen constants moved: %d, %d, %d" % [RiftLevelOfferSeedDerivation.MASK_32, fold, step])
	_expect((step & 1) == 1 and (fold & 1) == 1, "a step is even")
	_expect(_gcd(step, TWO_TO_THE_32) == 1 and _gcd(fold, TWO_TO_THE_32) == 1,
		"a step shares a factor with 2^32")

	## THE PROOF. For one run key k, level index i reaches (k + i x S) mod 2^32. If
	## two indices reach one seed, (i - j) x S = 0 modulo 2^32; multiplying both
	## sides by S's inverse gives i - j = 0 modulo 2^32. So the map is injective on
	## the 2^32 residues, and an injective map of a finite set into itself is a
	## permutation. The inverse EXISTS — exhibited here, found outside the engine,
	## and its product with the step checked to be 1 modulo 2^32. That product is
	## below 2^51, so computing it cannot overflow.
	_expect(LEVEL_STEP_INVERSE <= INT64_MAX / step, "the inverse product could overflow")
	_expect((step * LEVEL_STEP_INVERSE) & FROZEN_MASK == 1,
		"1000003 x %d is not 1 modulo 2^32" % LEVEL_STEP_INVERSE)
	_expect((fold * FOLD_STEP_INVERSE) & FROZEN_MASK == 1,
		"65537 x %d is not 1 modulo 2^32" % FOLD_STEP_INVERSE)
	## The overflow-free modular product the inversion below uses is itself checked
	## against three independently known answers first.
	_expect(_mul_mod_2_32(step, LEVEL_STEP_INVERSE) == 1
			and _mul_mod_2_32(FROZEN_MASK, FROZEN_MASK) == 1
			and _mul_mod_2_32(FROZEN_MASK, step) == 4293967293,
		"the modular product helper is wrong")

	## AND THE INVERSE UNDOES THE SCHEDULE: from nothing but a derived seed and its
	## run key, the level index comes back. A run seed in 0 … 2^32 - 1 is its own
	## run key (check 3), so each run key below is asked as that run seed.
	var recovered: int = 0
	var asked: int = 0
	for run_key: int in [0, 1, 12345, 2147418110, 4294901758, 4294967295]:
		for index: int in [0, 1, 2, 4294, 4295, 65535, 2147483647, 2147483648, 4294967294, 4294967295]:
			var root: int = _ask(run_key, index + 1).offer_root_seed
			var back: int = _mul_mod_2_32((root - run_key) & FROZEN_MASK, LEVEL_STEP_INVERSE)
			asked += 1
			if back == index:
				recovered += 1
			else:
				_expect(false, "run key %d, index %d gave root %d, which inverts to %d" % [run_key, index, root, back])
	_expect(recovered == asked, "%d of %d level indices were recovered" % [recovered, asked])

	## WHY ODD MATTERS, SHOWN ON A STEP THAT IS NOT THE PRODUCTION ONE: an even step
	## sends index 0 and index 2^31 to one seed, while the frozen odd step sends
	## index 2^31 to the seed 2^31 away from index 0's.
	var even_step: int = FROZEN_LEVEL_STEP - 1
	_expect(_mul_mod_2_32(2147483648, even_step) == 0,
		"an even step does not collapse index 2^31 onto index 0")
	_expect(_ask(0, 2147483649).offer_root_seed == 2147483648,
		"the frozen step sends index 2^31 to %d" % _ask(0, 2147483649).offer_root_seed)

	print("  1000003 and 65537 are odd and coprime to 2^32; 1000003 x 2021759595 = 1 and 65537 x 4294901761 = 1 modulo 2^32")
	print("  so level index -> root seed is a permutation of the 2^32 residues for every run key; %d of %d indices recovered by the inverse; an even step would collapse index 2^31 onto index 0"
		% [recovered, asked])
	_done("the_odd_level_step_permutes_the_32_bit_residues")


# --- 15. Safe arithmetic ------------------------------------------------------------------------------

func _check_the_arithmetic_stays_inside_64_bits() -> void:
	print("")
	print("--- 15. Both masked products and their largest sums stay inside signed 64-bit arithmetic")
	var mask: int = RiftLevelOfferSeedDerivation.MASK_32
	var fold: int = RiftLevelOfferSeedDerivation.RUN_HIGH_FOLD_STEP
	var step: int = RiftLevelOfferSeedDerivation.LEVEL_STEP

	## THE HAZARD IS REAL IN THIS ENGINE: whole-number arithmetic wraps silently.
	var top: int = INT64_MAX
	_expect(top + 1 == INT64_MIN, "adding past the top does not wrap here")

	## PROVED BY DIVISION BEFORE ANYTHING IS MULTIPLIED, so the proof itself cannot
	## overflow: the largest masked operand is at most INT64_MAX / step, so the
	## product fits; and the product leaves room for the largest masked addend.
	_expect(mask <= INT64_MAX / fold, "the largest high half times the fold step could overflow")
	_expect(mask <= INT64_MAX / step, "the largest level index times the level step could overflow")
	_expect(mask * fold <= INT64_MAX - mask, "the fold sum could overflow")
	_expect(mask * step <= INT64_MAX - mask, "the level sum could overflow")

	## AND THE EXACT BOUNDS, against outside literals.
	var fold_product: int = mask * fold
	var fold_sum: int = mask + fold_product
	var level_product: int = mask * step
	var level_sum: int = mask + level_product
	_expect(fold_product == FOLD_PRODUCT_MAX and fold_sum == FOLD_SUM_MAX,
		"the fold bounds are %d and %d" % [fold_product, fold_sum])
	_expect(level_product == LEVEL_PRODUCT_MAX and level_sum == LEVEL_SUM_MAX,
		"the level bounds are %d and %d" % [level_product, level_sum])
	_expect(fold_sum < INT64_MAX and level_sum < INT64_MAX, "a bound reaches INT64_MAX")
	_expect(INT64_MAX / level_sum == LEVEL_SUM_HEADROOM and INT64_MAX / fold_sum == FOLD_SUM_HEADROOM,
		"the headroom is %d and %d times" % [INT64_MAX / level_sum, INT64_MAX / fold_sum])

	## THE LARGEST INTERMEDIATES ARE ACTUALLY REACHED by one question: run seed -1
	## has both halves at the mask, and level 2^32 has the largest level index.
	_expect_success(_ask(-1, TWO_TO_THE_32), -1, TWO_TO_THE_32, 4293901755,
		"the question reaching both largest intermediates")

	## WITHOUT THE MASK THE LEVEL PRODUCT WOULD NOT FIT: the largest unmasked level
	## index is far beyond INT64_MAX / step, so it is the mask — not luck — that
	## keeps the arithmetic inside the range.
	_expect(INT64_MAX - 1 > INT64_MAX / step, "an unmasked level index would fit, so the mask proves nothing")

	print("  high x 65537 <= %d, + low <= %d; level_index x 1000003 <= %d, + run_key <= %d"
		% [fold_product, fold_sum, level_product, level_sum])
	print("  INT64_MAX is 9223372036854775807: %d times the largest level sum and %d times the largest fold sum; each bound proved by division before any product is formed"
		% [INT64_MAX / level_sum, INT64_MAX / fold_sum])
	_done("both_masked_products_and_their_sums_stay_inside_signed_64_bits")


# --- 16. Masking before multiplication ----------------------------------------------------------

func _check_masking_happens_before_multiplication() -> void:
	print("")
	print("--- 16. Masking happens before multiplication")
	var raw: String = FileAccess.get_file_as_string(DERIVATION_FILE)
	var body: PackedStringArray = _function_body(raw, "static func offer_root_seed_for(")
	_expect(body.size() >= 8, "the derivation function body was not found (%d lines)" % body.size())
	var floor_guard: int = _line_index(body, "if level < FIRST_LEVEL:")
	var low_line: int = _line_index(body, "var low: int = run_seed & MASK_32")
	var high_line: int = _line_index(body, "var high: int = (run_seed >> 32) & MASK_32")
	var fold_line: int = _line_index(body, "high * RUN_HIGH_FOLD_STEP")
	var index_line: int = _line_index(body, "var level_index: int = (level - FIRST_LEVEL) & MASK_32")
	var level_line: int = _line_index(body, "level_index * LEVEL_STEP")
	var answer_line: int = _line_index(body, "return RiftLevelOfferSeedReading.derived(")
	var order: Array[int] = [floor_guard, low_line, high_line, fold_line, index_line, level_line, answer_line]
	var ordered: bool = not order.has(-1)
	for index: int in range(1, order.size()):
		if order[index] <= order[index - 1]:
			ordered = false
	_expect(ordered, "the guard, masks and products are out of order or missing: %s" % str(order))
	_expect(floor_guard >= 0 and floor_guard + 1 < body.size()
			and body[floor_guard + 1].strip_edges().begins_with("return RiftLevelOfferSeedReading.refused("),
		"the floor guard does not refuse on the line after it")

	## EXACTLY TWO MULTIPLICATIONS, and each multiplies a value whose own line has
	## already masked it: `high` and `level_index`, never the raw seed or level.
	_expect(_lines_containing(body, "*") == 2,
		"the derivation multiplies on %d lines, not 2" % _lines_containing(body, "*"))
	_expect(fold_line >= 0 and body[fold_line].contains("(low + high * RUN_HIGH_FOLD_STEP) & MASK_32"),
		"the fold line multiplies something other than the masked high half")
	_expect(level_line >= 0 and body[level_line].contains("(run_key + level_index * LEVEL_STEP) & MASK_32"),
		"the level line multiplies something other than the masked level index")
	_expect(not raw.contains("run_seed * ") and not raw.contains("level * ")
			and not raw.contains("* run_seed") and not raw.contains("* level"),
		"a raw input is multiplied")
	## Every assignment in the body ends in the 32-bit mask: five of them.
	_expect(_lines_containing(body, "& MASK_32") == 5,
		"%d body lines mask to 32 bits, not 5" % _lines_containing(body, "& MASK_32"))
	var code: String = _code_only(raw)
	_expect(code.count("*") == 2 and code.count(">>") == 1 and code.count(" - ") == 1
			and code.count(" + ") == 2,
		"the derivation's code holds %d products, %d shifts, %d subtractions and %d additions"
			% [code.count("*"), code.count(">>"), code.count(" - "), code.count(" + ")])
	var reading_code: String = _code_only(FileAccess.get_file_as_string(READING_FILE))
	_expect(not reading_code.contains("*") and not reading_code.contains(" + "),
		"the result type multiplies or adds")

	## THE HONEST LIMITATION, MEASURED RATHER THAN ARGUED. Wraparound modulo 2^64 is
	## also congruent modulo 2^32, so an UNMASKED version would happen to give the
	## same answers. Shown on the worst case: the unmasked level product for the
	## largest level wraps — to exactly the value the outside calculation named —
	## and still reduces to the production answer. No behavioural test can tell the
	## two orders apart, which is precisely why the order is pinned structurally
	## above: the answer must be right by construction, not by a cancelled overflow.
	var wrapped: int = (INT64_MAX - 1) * FROZEN_LEVEL_STEP
	_expect(wrapped == WRAPPED_UNMASKED_PRODUCT,
		"the unmasked product wrapped to %d, not %d" % [wrapped, WRAPPED_UNMASKED_PRODUCT])
	_expect(wrapped / FROZEN_LEVEL_STEP != INT64_MAX - 1, "the unmasked product did not wrap")
	_expect((wrapped & FROZEN_MASK) == _ask(0, INT64_MAX).offer_root_seed,
		"the wrapping version disagrees with the masked one, so the limitation is misstated")
	var minus_one: int = -1
	_expect(((minus_one & FROZEN_MASK) + (minus_one >> 32) * FROZEN_FOLD_STEP) & FROZEN_MASK
			== _ask(-1, 1).offer_root_seed,
		"an unmasked high half disagrees with the masked one for run seed -1")

	print("  floor guard, low mask, high mask, fold product, level-index mask, level product, answer at body lines %s; 2 products, both of masked values; 5 masks"
		% str(order))
	print("  an unmasked, wrapping version would answer the same 4292967290 at level 9223372036854775807 (its product wraps to %d), so masking order is not observable in any answer and is pinned structurally"
		% wrapped)
	_done("masking_happens_before_multiplication")


# --- 17. Contradictory shapes --------------------------------------------------------------------

func _check_the_reading_catches_contradictory_shapes() -> void:
	print("")
	print("--- 17. The reading catches contradictory success and refusal shapes")
	var caught: int = 0

	## EACH TAMPERING STARTS FROM A GENUINE ANSWER AND CHANGES ONE FIELD, and each
	## is restored and shown to be coherent again — so it is the tampered field and
	## nothing else that problem() objected to.
	var success_cases: Array = [
		["a success with a failure reason", "failure_reason", "zz stray reason"],
		["a success carrying the unresolved seed", "offer_root_seed", -1],
		["a success carrying a negative seed", "offer_root_seed", -2],
		["a success one past the 32-bit range", "offer_root_seed", 4294967296],
		["a success carrying the largest integer", "offer_root_seed", INT64_MAX],
		["a success for level 0", "level", 0],
		["a success for a negative level", "level", -3],
		["a success reporting failure", "ok", false],
	]
	for row: Array in success_cases:
		var reading: RiftLevelOfferSeedReading = _ask(99, 2)
		_expect(reading.problem().is_empty(), "the genuine answer for run seed 99 at level 2 is incoherent")
		var field: String = String(row[1])
		var original: Variant = reading.get(field)
		reading.set(field, row[2])
		var objection: String = reading.problem()
		_expect(not objection.is_empty(), "problem() accepted %s" % String(row[0]))
		if not objection.is_empty():
			caught += 1
		reading.set(field, original)
		_expect(reading.problem().is_empty(),
			"restoring %s did not restore coherence: %s" % [String(row[0]), reading.problem()])

	var refusal_cases: Array = [
		["a refusal with no reason", "failure_reason", ""],
		["a refusal with a blank reason", "failure_reason", "   "],
		["a refusal carrying seed 0", "offer_root_seed", 0],
		["a refusal carrying the largest seed", "offer_root_seed", 4294967295],
		["a refusal carrying another negative", "offer_root_seed", -2],
		["a refusal reporting success", "ok", true],
	]
	for row: Array in refusal_cases:
		var reading: RiftLevelOfferSeedReading = _ask(99, 0)
		_expect(reading.problem().is_empty(), "the genuine refusal of level 0 is incoherent")
		var field: String = String(row[1])
		var original: Variant = reading.get(field)
		reading.set(field, row[2])
		var objection: String = reading.problem()
		_expect(not objection.is_empty(), "problem() accepted %s" % String(row[0]))
		if not objection.is_empty():
			caught += 1
		reading.set(field, original)
		_expect(reading.problem().is_empty(),
			"restoring %s did not restore coherence: %s" % [String(row[0]), reading.problem()])

	## A BARE VALUE IS NOT AN ANSWER: it is a refusal that states no reason.
	var bare: RiftLevelOfferSeedReading = RiftLevelOfferSeedReading.new()
	_expect(not bare.problem().is_empty(), "a default-constructed reading is coherent")
	if not bare.problem().is_empty():
		caught += 1
	_expect(not bare.ok and bare.offer_root_seed == -1,
		"a default-constructed reading carries %s" % bare.describe())

	## THE REFUSAL CONSTRUCTOR NEVER LEAVES A REASON BLANK.
	var unstated: RiftLevelOfferSeedReading = RiftLevelOfferSeedReading.refused(7, 0, "  ")
	_expect(not unstated.failure_reason.strip_edges().is_empty() and unstated.problem().is_empty()
			and unstated.run_seed == 7 and unstated.level == 0 and unstated.offer_root_seed == -1,
		"a refusal built with a blank reason is incoherent: %s" % unstated.problem())

	## POSITIVE CONTROLS AT EVERY EDGE OF WHAT A SUCCESS MAY HOLD: both ends of the
	## seed range, the smallest and largest level, and the most extreme run seeds —
	## which are never judged, because every signed 64-bit run seed is valid.
	var controls: Array = [
		[0, 1, 0], [0, 1, 4294967295], [INT64_MIN, INT64_MAX, 12345], [INT64_MAX, 1, 0],
	]
	var coherent: int = 0
	for row: Array in controls:
		var control: RiftLevelOfferSeedReading = RiftLevelOfferSeedReading.derived(
			int(row[0]), int(row[1]), int(row[2]))
		if control.problem().is_empty():
			coherent += 1
		else:
			_expect(false, "a coherent success was refused: %s" % control.problem())
	_expect(coherent == controls.size(), "%d of %d edge successes were coherent" % [coherent, controls.size()])

	var expected_caught: int = success_cases.size() + refusal_cases.size() + 1
	_expect(caught == expected_caught,
		"%d of %d contradictory shapes were caught" % [caught, expected_caught])
	print("  %d contradictory shapes caught by problem(); each restored reading is coherent again; %d edge successes coherent"
		% [caught, coherent])
	_done("the_reading_catches_contradictory_shapes")


# --- 18. Unwired -------------------------------------------------------------------------------------

func _check_nothing_calls_g2() -> void:
	print("")
	print("--- 18. No existing production file calls G2; E2 and D1 still take an explicit root seed")
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if G2_FILES.has(path):
				continue
			project_files += 1
			var source: String = FileAccess.get_file_as_string(path)
			for name: String in G2_CLASSES:
				if source.contains(name) and not _reader_may_name(path, name):
					referenced.append("%s names %s" % [path.get_file(), name])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for name: String in G2_CLASSES:
		if settings.contains(name):
			referenced.append("project.godot names %s" % name)
	_expect(referenced.is_empty(),
		"Foundation G2 is referenced by code that runs: %s" % ", ".join(referenced))
	_expect(project_files > 100,
		"only %d project files were scanned, so the scan proves nothing" % project_files)
	_expect(_files_under("res://addons", [".gd"]).size() > 0,
		"the addons root held no script, so widening the scan proved nothing")
	_expect(not settings.contains("[autoload]"), "project.godot declares an [autoload] section")
	## THE SCAN CAN FIND WHAT IT LOOKS FOR: the derivation itself names the reading.
	_expect(FileAccess.get_file_as_string(DERIVATION_FILE).contains("RiftLevelOfferSeedReading"),
		"the derivation does not name the reading, so the scan is untested")

	## THE ACCEPTED COORDINATOR AND COMPOSER STILL RECEIVE THEIR ROOT SEED FROM THEIR
	## CALLER, as a plain integer, exactly as accepted.
	var opens_with_seed: bool = false
	for signature: String in _signatures_of(E2_COORDINATOR_FILE):
		if signature.begins_with("open_offer(requirement: float, ") \
				and signature.ends_with(", root_seed: int) -> String"):
			opens_with_seed = true
	_expect(opens_with_seed, "E2 no longer opens its offer from an explicit root seed")
	_expect(_signatures_of(E2_COORDINATOR_FILE).has("offer_root_seed() -> int"),
		"E2 no longer reports the root seed of the offer it holds")
	var composes_with_seed: bool = false
	for signature: String in _signatures_of(D1_COMPOSER_FILE):
		if signature.begins_with("compose(") and signature.ends_with(", root_seed: int) -> Object"):
			composes_with_seed = true
	_expect(composes_with_seed, "D1 no longer composes from an explicit root seed")

	var carried: PackedStringArray = PackedStringArray()
	for path: String in [D1_COMPOSER_FILE, D1_OFFER_FILE, E2_COORDINATOR_FILE, E2_RESULT_FILE,
			G1_CURVE_FILE, G1_READING_FILE]:
		var source: String = FileAccess.get_file_as_string(path)
		_expect(source.length() > 1000, "%s could not be read" % path.get_file())
		for name: String in G2_NAMES_OTHERS_MUST_NOT_CARRY:
			if source.contains(name):
				carried.append("%s names %s" % [path.get_file(), name])
	_expect(carried.is_empty(), "an accepted foundation names G2: %s" % ", ".join(carried))

	print("  %d project files scanned" % project_files)
	print("  no scanned file outside the two G4 grants and not project.godot names a G2 class; E2 opens and D1 composes from an explicit root seed; 6 accepted D1, E2 and G1 files name nothing G2 introduced")
	_done("nothing_calls_g2_and_e2_still_takes_an_explicit_root_seed")


## Whether `path` is an authorized reader that is granted `name` (D-269). Per file
## AND per class, so a listed file is still refused any class it is not granted.
func _reader_may_name(path: String, name: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) == path:
			return (row[1] as Array).has(name)
	return false


# --- 19. D1 unchanged --------------------------------------------------------------------------------

func _check_d1_is_unchanged() -> void:
	print("")
	print("--- 19. D1's lane domains, mixer and documented root-seed behaviour are unchanged")
	var lanes: Array[int] = [RiftOffer.Lane.SUPPORT, RiftOffer.Lane.COMBAT_DEFENCE, RiftOffer.Lane.UTILITY]
	## THE FROZEN DOMAINS (D-240 ruling 1).
	var domains: Array[int] = [
		RiftOfferComposition.SUPPORT_LANE_DOMAIN,
		RiftOfferComposition.COMBAT_DEFENCE_LANE_DOMAIN,
		RiftOfferComposition.UTILITY_LANE_DOMAIN,
	]
	for index: int in 3:
		_expect(domains[index] == D1_FROZEN_DOMAINS[index],
			"lane domain %d is %d, not the frozen %d" % [index, domains[index], D1_FROZEN_DOMAINS[index]])
		_expect(RiftOfferComposition.lane_domain_for(lanes[index]) == D1_FROZEN_DOMAINS[index],
			"lane %d is paired with the wrong domain" % index)
	_expect(_signatures_of(D1_COMPOSER_FILE).has("lane_seed_for(root_seed: int, lane: int) -> int"),
		"D1's public lane-seed derivation changed shape")

	## THE MIXER AND DOMAINS TOGETHER, AGAINST D-239's TWO DOCUMENTED ROWS.
	for row: Array in D1_DOCUMENTED_ROWS:
		var expected: Array = row[1]
		for index: int in 3:
			_expect(RiftOfferComposition.lane_seed_for(int(row[0]), lanes[index]) == int(expected[index]),
				"root %d lane %d no longer reproduces D-239's documented %d" % [
					int(row[0]), index, int(expected[index])])

	## THE DOCUMENTED ROOT-SEED BEHAVIOUR: the composer masks a root to its low 32
	## bits. So a root, the root plus or minus 2^32, and — as D-239 records — -1 and
	## INT64_MAX are each one question to it.
	var masked_equal: int = 0
	var mask_cases: Array = [
		[12345, 12345 + TWO_TO_THE_32], [12345, 12345 - TWO_TO_THE_32],
		[0, TWO_TO_THE_32], [-1, 4294967295], [-1, INT64_MAX], [INT64_MIN, 0],
	]
	for pair: Array in mask_cases:
		var same: bool = true
		for lane: int in lanes:
			if RiftOfferComposition.lane_seed_for(int(pair[0]), lane) \
					!= RiftOfferComposition.lane_seed_for(int(pair[1]), lane):
				same = false
		if same:
			masked_equal += 1
		else:
			_expect(false, "the composer no longer treats %d and %d as one question" % [int(pair[0]), int(pair[1])])
	_expect(masked_equal == mask_cases.size(),
		"%d of %d mask-equivalent roots are still one question" % [masked_equal, mask_cases.size()])

	## EVERY DERIVED ROOT IS A FIXED POINT OF THAT MASK, so nothing G2 derives is
	## lost when the composer reads it.
	var fixed: int = 0
	for row: Array in REQUIRED_EXAMPLES + EXTENDED_CORPUS:
		var root: int = _ask(int(row[0]), int(row[1])).offer_root_seed
		if (root & 0xFFFFFFFF) == root:
			fixed += 1
	_expect(fixed == REQUIRED_EXAMPLES.size() + EXTENDED_CORPUS.size(),
		"%d corpus roots survive the composer's mask unchanged" % fixed)

	## END TO END, AGAINST OUTSIDE LITERALS: run seed and level -> G2 root -> three
	## D1 lane seeds, with nothing wired. This is a measurement, not a connection.
	var through: int = 0
	for row: Array in G2_THROUGH_D1:
		var root: int = _ask(int(row[0]), int(row[1])).offer_root_seed
		_expect(root == int(row[2]), "run seed %d at level %d derived %d" % [int(row[0]), int(row[1]), root])
		var expected: Array = row[3]
		var all_lanes: bool = true
		for index: int in 3:
			if RiftOfferComposition.lane_seed_for(root, lanes[index]) != int(expected[index]):
				all_lanes = false
		if all_lanes:
			through += 1
		else:
			_expect(false, "root %d no longer gives the lane seeds %s" % [root, str(expected)])
	_expect(through == G2_THROUGH_D1.size(), "%d of %d end-to-end rows matched" % [through, G2_THROUGH_D1.size()])

	## DISTINCT ROOTS STAY DISTINCT THROUGH THE COMPOSER, because its finalizer is a
	## bijection: over a consecutive window, every lane receives a different seed
	## at every level.
	var per_lane: Array[Dictionary] = [{}, {}, {}]
	for level: int in range(1, THROUGH_D1_WINDOW + 1):
		var root: int = _ask(0, level).offer_root_seed
		for index: int in 3:
			per_lane[index][RiftOfferComposition.lane_seed_for(root, lanes[index])] = true
	for index: int in 3:
		_expect(per_lane[index].size() == THROUGH_D1_WINDOW,
			"lane %d received %d distinct seeds over %d levels" % [index, per_lane[index].size(), THROUGH_D1_WINDOW])

	## THE UNRESOLVED SEED IS NOT SAFE TO HAND ONWARD, measured rather than hidden.
	## The composer reads -1 as 2^32 - 1, which G2 itself derives for run seed
	## 2^32 - 1 at Level 1 — so a refusal whose -1 were passed on without asking
	## `ok` would compose a real offer. `ok` is the authority.
	var unresolved: int = RiftLevelOfferSeedReading.UNRESOLVED_SEED
	var aliased: bool = true
	for lane: int in lanes:
		if RiftOfferComposition.lane_seed_for(unresolved, lane) != RiftOfferComposition.lane_seed_for(4294967295, lane):
			aliased = false
	_expect(aliased, "the composer no longer reads -1 as 2^32 - 1, so this finding is misstated")
	_expect(_ask(4294967295, 1).ok and _ask(4294967295, 1).offer_root_seed == 4294967295,
		"4294967295 is not a derived root, so the finding is misstated")
	_expect(RiftOffer.UNRESOLVED_SEED == unresolved,
		"the accepted offer's unresolved lane-seed stand-in is %d, not G2's %d" % [RiftOffer.UNRESOLVED_SEED, unresolved])

	print("  3 frozen lane domains unchanged; D-239's documented rows 12345 and 0 reproduce all 6 lane seeds; %d of %d mask-equivalent roots are still one question"
		% [masked_equal, mask_cases.size()])
	print("  %d corpus roots survive the composer's mask unchanged; %d of %d end-to-end rows run seed -> root -> 3 lane seeds match; %d consecutive levels give %d distinct seeds in every lane"
		% [fixed, through, G2_THROUGH_D1.size(), THROUGH_D1_WINDOW, per_lane[0].size()])
	print("  finding: a refusal's -1, handed onward without asking ok, composes exactly the offer of root 4294967295 — a root G2 itself derives for run seed 4294967295 at Level 1")
	_done("d1_lane_domains_mixer_and_root_seed_behaviour_are_unchanged")


# --- 20. G1 independent --------------------------------------------------------------------------

func _check_g1_remains_independent() -> void:
	print("")
	print("--- 20. G1 remains independent: neither foundation names the other")
	var carried: PackedStringArray = PackedStringArray()
	for path: String in G2_FILES:
		var raw: String = FileAccess.get_file_as_string(path)
		for name: String in G1_NAMES_G2_MUST_NOT_CARRY:
			if raw.contains(name):
				carried.append("%s names %s" % [path.get_file(), name])
		var code: String = _code_only(raw)
		for word: String in ["requirement", "experience"]:
			if code.contains(word):
				carried.append("%s's code names %s" % [path.get_file(), word])
	_expect(carried.is_empty(), "G2 reaches into G1: %s" % ", ".join(carried))
	for path: String in [G1_CURVE_FILE, G1_READING_FILE]:
		var raw: String = FileAccess.get_file_as_string(path)
		_expect(raw.length() > 1000, "%s could not be read" % path.get_file())
		for name: String in G2_NAMES_OTHERS_MUST_NOT_CARRY:
			if raw.contains(name):
				carried.append("%s names %s" % [path.get_file(), name])
	_expect(carried.is_empty(), "G1 names G2: %s" % ", ".join(carried))

	## THE TWO BOUNDARIES ARE SEPARATE REPRESENTATION FACTS. G1's largest supported
	## level is an exact-experience boundary; G2's period is a 32-bit seed boundary.
	## G2 answers at, and beyond, G1's boundary — it imposes nothing on levels G1
	## refuses, and G1 imposes nothing here.
	_expect(RiftLevelRequirementCurve.MAX_SUPPORTED_LEVEL == G1_MAX_SUPPORTED_LEVEL,
		"G1's accepted representation boundary moved to %d" % RiftLevelRequirementCurve.MAX_SUPPORTED_LEVEL)
	_expect(_ask(0, G1_MAX_SUPPORTED_LEVEL).ok and _ask(0, G1_MAX_SUPPORTED_LEVEL + 1).ok,
		"G2 refuses at G1's boundary")
	## ONE ORDINAL CONVENTION, WRITTEN TWICE ON PURPOSE: both foundations say a Rift
	## level begins at 1. Ordinary consistency, not a dependency — neither file names
	## the other's constant.
	_expect(RiftLevelRequirementCurve.FIRST_LEVEL == RiftLevelOfferSeedDerivation.FIRST_LEVEL,
		"the two foundations disagree about the first Rift level")

	print("  G2 names no G1 class, constant or requirement; G1 names nothing G2 introduced; both begin at Level 1")
	print("  separate boundaries: G1's exact-experience limit is level 360287970189636, G2's seed period is 4294967296 levels, and G2 answers at and beyond G1's limit")
	_done("g1_remains_independent")


# --- 21. Stateless scheduling, no mixer -----------------------------------------------------------

func _check_stateless_scheduling_with_no_mixer() -> void:
	print("")
	print("--- 21. The derivation is stateless scheduling: no state, no mixer, nothing deferred")
	var derivation_fields: PackedStringArray = _fields_of(RiftLevelOfferSeedDerivation.new())
	_expect(derivation_fields.is_empty(),
		"the derivation carries the field(s) %s" % ", ".join(derivation_fields))
	var script: GDScript = load(DERIVATION_FILE) as GDScript
	_expect(script != null, "the derivation script could not be loaded")
	var script_variables: PackedStringArray = PackedStringArray()
	for entry: Dictionary in script.get_script_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			script_variables.append(String(entry.get("name", "")))
	_expect(script_variables.is_empty(),
		"the derivation script declares variables: %s" % ", ".join(script_variables))
	## AND NOT A STATIC ONE EITHER: D-262 measured that a static variable is
	## invisible to both property enumerations, so the source is read as well.
	var declared: PackedStringArray = PackedStringArray()
	for line: String in _code_only(FileAccess.get_file_as_string(DERIVATION_FILE)).split("\n"):
		if line.begins_with("var ") or line.begins_with("static var ") \
				or line.begins_with("@onready") or line.begins_with("@export"):
			declared.append(line.strip_edges())
	_expect(declared.is_empty(), "the derivation declares state: %s" % " | ".join(declared))
	var not_static: PackedStringArray = PackedStringArray()
	var methods: int = 0
	for entry: Dictionary in script.get_script_method_list():
		methods += 1
		if int(entry.get("flags", 0)) & METHOD_FLAG_STATIC == 0:
			not_static.append(String(entry.get("name", "")))
	_expect(methods > 0, "the derivation declares no methods, so this proves nothing")
	_expect(not_static.is_empty(), "the derivation has instance method(s): %s" % ", ".join(not_static))

	## THE READING EXPOSES SCALARS ONLY: no collection and no object reference.
	var reading: RiftLevelOfferSeedReading = RiftLevelOfferSeedReading.new()
	var reading_fields: PackedStringArray = _fields_of(reading)
	_expect(", ".join(reading_fields) == ", ".join(EXPECTED_READING_FIELDS),
		"the reading carries the fields: %s" % ", ".join(reading_fields))
	var non_scalar: PackedStringArray = PackedStringArray()
	for entry: Dictionary in reading.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE == 0:
			continue
		var type_id: int = int(entry.get("type", 0))
		if type_id != TYPE_BOOL and type_id != TYPE_INT and type_id != TYPE_STRING:
			non_scalar.append(String(entry.get("name", "")))
	_expect(non_scalar.is_empty(), "the reading exposes non-scalar field(s): %s" % ", ".join(non_scalar))

	var forbidden_total: int = 0
	var ambient_total: int = 0
	var deferred_total: int = 0
	for path: String in G2_FILES:
		var raw: String = FileAccess.get_file_as_string(path)
		_expect(raw.length() > 1000,
			"%s read as %d characters, so these scans prove nothing" % [path.get_file(), raw.length()])
		var code: String = _code_only(raw)
		_expect(code.length() > 300 and code.length() < raw.length(),
			"%s: comment stripping produced %d characters from %d" % [path.get_file(), code.length(), raw.length()])
		var named: PackedStringArray = PackedStringArray()
		for token: String in FORBIDDEN_TOKENS:
			if raw.contains(token):
				named.append(token)
		forbidden_total += named.size()
		_expect(named.is_empty(), "%s names: %s" % [path.get_file(), ", ".join(named)])
		var ambient: PackedStringArray = PackedStringArray()
		for token: String in AMBIENT_TOKENS:
			if raw.contains(token):
				ambient.append(token)
		ambient_total += ambient.size()
		_expect(ambient.is_empty(), "%s reads ambient state: %s" % [path.get_file(), ", ".join(ambient)])
		var deferred: PackedStringArray = PackedStringArray()
		for token: String in DEFERRED_MEMBER_TOKENS:
			if _names_deferred_member(code, token):
				deferred.append(token)
		deferred_total += deferred.size()
		_expect(deferred.is_empty(), "%s carries deferred members: %s" % [path.get_file(), ", ".join(deferred)])
		## NO LOOP OF ANY KIND: one call answers one level, and a loop is the shape a
		## queue of offers or a run of level-ups would arrive in.
		var loops: PackedStringArray = PackedStringArray()
		for line: String in code.split("\n"):
			var stripped: String = line.strip_edges()
			if stripped.begins_with("for ") or stripped.begins_with("while "):
				loops.append(stripped)
		_expect(loops.is_empty(), "%s loops: %s" % [path.get_file(), " | ".join(loops)])
		var floats: PackedStringArray = _float_literals(code)
		_expect(floats.is_empty(), "%s carries floating-point literal(s): %s" % [path.get_file(), ", ".join(floats)])

	## NO FINALIZER: the derivation's code shifts exactly once, by 32, and holds no
	## xor at all — the shape every avalanche step is built from. (The three
	## multiplier and domain constants of the composer's mixer are refused above in
	## every spelling.)
	var derivation_code: String = _code_only(FileAccess.get_file_as_string(DERIVATION_FILE))
	_expect(derivation_code.count(">>") == 1 and derivation_code.contains(">> 32"),
		"the derivation shifts %d times" % derivation_code.count(">>"))
	_expect(not derivation_code.contains("^") and not derivation_code.contains("<<"),
		"the derivation xors or shifts left, which is the shape of a mixer")

	## THE FROZEN CONSTANTS, AS SPELLED IN THE BRIEF, and the only numbers present.
	var derivation_raw: String = FileAccess.get_file_as_string(DERIVATION_FILE)
	for declaration: String in FROZEN_DECLARATIONS:
		_expect(derivation_raw.contains(declaration), "the derivation does not declare: %s" % declaration)
	var derivation_numbers: PackedStringArray = _numeric_literals(derivation_code)
	_expect(", ".join(derivation_numbers) == ", ".join(EXPECTED_DERIVATION_NUMBERS),
		"the derivation's code holds the numbers: %s" % ", ".join(derivation_numbers))
	var reading_numbers: PackedStringArray = _numeric_literals(
		_code_only(FileAccess.get_file_as_string(READING_FILE)))
	_expect(", ".join(reading_numbers) == ", ".join(EXPECTED_READING_NUMBERS),
		"the reading's code holds the numbers: %s" % ", ".join(reading_numbers))
	_expect(RiftLevelOfferSeedDerivation.FIRST_LEVEL == 1, "the first level moved")

	## THE SCANS CAN FAIL: they find their own tokens where those tokens legitimately
	## live, in this file, and each matcher is proved in both directions.
	var self_source: String = FileAccess.get_file_as_string(SELF_FILE)
	var found_here: int = 0
	for token: String in FORBIDDEN_TOKENS:
		if self_source.contains(token):
			found_here += 1
	_expect(found_here == FORBIDDEN_TOKENS.size(),
		"the forbidden-token scan found %d of its %d tokens in this file" % [found_here, FORBIDDEN_TOKENS.size()])
	_expect(_names_deferred_member("static func mix(value: int) -> int:", "mix"),
		"the word matcher no longer catches a mixer")
	_expect(not _names_deferred_member("var level_index: int", "mix"),
		"the word matcher fires on a word that merely contains a token")
	_expect(_names_deferred_member("var pending_offers: Array = []", "pending"),
		"the matcher no longer catches a pending-offer queue")
	_expect(_numeric_literals("const SALT: int = 0x9E37_79B9").has("2654435769"),
		"the numeric scan no longer finds an underscored hexadecimal salt")
	_expect(_numeric_literals("const CAP_ZZ: int = 1_000").has("1000"),
		"the numeric scan no longer finds an underscored decimal")
	_expect(_float_literals("return 1.5").has("1.5"), "the floating-point scan no longer finds a literal")

	## A PER-FILE ALLOWLIST OF PROJECT CLASSES, taken from the engine's own list.
	var all_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var class_id: String = String(entry.get("class", ""))
		if not class_id.is_empty():
			all_classes.append(class_id)
	_expect(all_classes.size() > 20,
		"only %d project classes were enumerated; the allowlist may be inert" % all_classes.size())
	_expect(all_classes.has("RiftLevelOfferSeedDerivation") and all_classes.has("RiftLevelOfferSeedReading"),
		"the engine has not registered G2's two classes")
	for row: Array in AUTHORIZED_CLASSES:
		var path: String = String(row[0])
		var granted: Array = row[1]
		var raw: String = FileAccess.get_file_as_string(path)
		var outside: PackedStringArray = PackedStringArray()
		for class_id: String in all_classes:
			if not granted.has(class_id) and raw.contains(class_id):
				outside.append(class_id)
		_expect(outside.is_empty(),
			"%s names unauthorized project class(es): %s" % [path.get_file(), ", ".join(outside)])
		var unearned: PackedStringArray = PackedStringArray()
		for class_id: String in granted:
			if not raw.contains(class_id):
				unearned.append(class_id)
		_expect(unearned.is_empty(), "%s is granted but does not name: %s" % [path.get_file(), ", ".join(unearned)])

	## THE SIGNATURE, CONSTANT AND FIELD PINS. A queue, a multiple-level step, a
	## supplied-lane-seed entry point or a second derivation arrives as an extra
	## method or constant with a plausible name rather than as a forbidden token.
	_expect(", ".join(_signatures_of(DERIVATION_FILE)) == ", ".join(EXPECTED_DERIVATION_SIGNATURES),
		"the derivation declares: %s" % ", ".join(_signatures_of(DERIVATION_FILE)))
	_expect(", ".join(_signatures_of(READING_FILE)) == ", ".join(EXPECTED_READING_SIGNATURES),
		"the reading declares: %s" % ", ".join(_signatures_of(READING_FILE)))
	var derivation_constants: PackedStringArray = _constants_of(DERIVATION_FILE)
	_expect(", ".join(derivation_constants) == ", ".join(EXPECTED_DERIVATION_CONSTANTS),
		"the derivation declares the constants: %s" % ", ".join(derivation_constants))
	var reading_constants: PackedStringArray = _constants_of(READING_FILE)
	_expect(", ".join(reading_constants) == ", ".join(EXPECTED_READING_CONSTANTS),
		"the reading declares the constants: %s" % ", ".join(reading_constants))

	print("  derivation: 0 instance fields, 0 declared variables, %d of %d methods static; reading: %d scalar fields — %s"
		% [methods - not_static.size(), methods, reading_fields.size(), ", ".join(reading_fields)])
	print("  2 scripts scanned: %d forbidden tokens, %d ambient reads, %d deferred members, 0 loops, 0 float literals; 1 shift, by 32; 0 xors; 0 mixer or lane-domain constants in any spelling"
		% [forbidden_total, ambient_total, deferred_total])
	print("  numbers: derivation %s, reading %s; %d signatures, %d constants and %d fields pinned"
		% [", ".join(derivation_numbers), ", ".join(reading_numbers),
			EXPECTED_DERIVATION_SIGNATURES.size() + EXPECTED_READING_SIGNATURES.size(),
			derivation_constants.size() + reading_constants.size(), EXPECTED_READING_FIELDS.size()])
	print("  %d successes and %d refusals were driven through the counting helpers" % [_successes, _refusals])
	_done("the_derivation_is_stateless_scheduling_with_no_mixer")


# --- Questions ------------------------------------------------------------------------------

func _ask(run_seed: int, level: int) -> RiftLevelOfferSeedReading:
	return RiftLevelOfferSeedDerivation.offer_root_seed_for(run_seed, level)


## The questions checks 7, 8 and 9 ask: the required examples, the wrap and period
## rows, the collisions, and refusals at both ends of the domain.
func _sample_questions() -> Array:
	var questions: Array = []
	for row: Array in REQUIRED_EXAMPLES + WRAP_ROWS + PERIOD_ROWS:
		questions.append([int(row[0]), int(row[1])])
	for row: Array in COLLISIONS:
		questions.append([int(row[0]), 7])
		questions.append([int(row[1]), 7])
	questions.append_array([[0, 0], [-1, -1], [INT64_MAX, INT64_MIN], [INT64_MIN, 0]])
	return questions


func _key(question: Array) -> String:
	return "%d@%d" % [int(question[0]), int(question[1])]


## The sweep's run seeds, built exactly as the outside calculation built them.
func _sweep_seeds() -> Array[int]:
	var highs: Array[int] = []
	highs.append_array(SWEEP_HIGH_HALVES)
	for i: int in 16:
		var value: int = -2147483648 + i * 268435456 + 4097
		if not highs.has(value):
			highs.append(value)
	var lows: Array[int] = []
	lows.append_array(SWEEP_LOW_HALVES)
	for i: int in 16:
		var value: int = i * 268435456 + 12345
		if not lows.has(value):
			lows.append(value)
	var seeds: Array[int] = []
	for high: int in highs:
		for low: int in lows:
			seeds.append(high * TWO_TO_THE_32 + low)
	return seeds


# --- Assertions --------------------------------------------------------------------

## One success, counted, with every field checked against an independent
## expectation.
func _expect_success(
	reading: RiftLevelOfferSeedReading,
	run_seed: int,
	level: int,
	offer_root_seed: int,
	described: String
) -> void:
	_successes += 1
	_expect(reading != null, "%s returned nothing" % described)
	if reading == null:
		return
	_expect(reading.ok, "%s was refused: %s" % [described, reading.failure_reason])
	_expect(reading.failure_reason.is_empty(), "%s succeeded with a reason: %s" % [described, reading.failure_reason])
	_expect(reading.run_seed == run_seed, "%s echoed run seed %d" % [described, reading.run_seed])
	_expect(reading.level == level, "%s answered for level %d" % [described, reading.level])
	_expect(reading.offer_root_seed == offer_root_seed,
		"%s derived %d, not %d" % [described, reading.offer_root_seed, offer_root_seed])
	_expect(reading.problem().is_empty(), "%s is incoherent: %s" % [described, reading.problem()])


## One refusal, counted, checked for everything a refusal owes: both inputs kept,
## a stated reason, and no usable seed.
func _expect_refusal(reading: RiftLevelOfferSeedReading, run_seed: int, level: int, described: String) -> void:
	_refusals += 1
	_expect(reading != null, "%s returned nothing" % described)
	if reading == null:
		return
	_expect(not reading.ok, "%s was accepted with %d" % [described, reading.offer_root_seed])
	_expect(not reading.failure_reason.strip_edges().is_empty(), "%s was refused without a reason" % described)
	_expect(reading.run_seed == run_seed, "%s was recorded as run seed %d" % [described, reading.run_seed])
	_expect(reading.level == level, "%s was recorded as level %d" % [described, reading.level])
	_expect(reading.offer_root_seed == -1, "%s carried the usable seed %d" % [described, reading.offer_root_seed])
	_expect(reading.problem().is_empty(), "%s is incoherent: %s" % [described, reading.problem()])


# --- Arithmetic helpers --------------------------------------------------------------

## (a x b) modulo 2^32 for a and b in 0 … 2^32 - 1, WITHOUT an intermediate above
## 2^49: a is split into 16-bit halves, and only the low 16 bits of the high half's
## product can survive being moved up 16 places modulo 2^32.
func _mul_mod_2_32(a: int, b: int) -> int:
	var a_low: int = a & 0xFFFF
	var a_high: int = (a >> 16) & 0xFFFF
	return (a_low * b + (((a_high * b) & 0xFFFF) << 16)) & 0xFFFFFFFF


func _gcd(a: int, b: int) -> int:
	var x: int = a
	var y: int = b
	while y != 0:
		var remainder: int = x % y
		x = y
		y = remainder
	return x


# --- Formatting --------------------------------------------------------------------

## The COMPLETE reading as one line, so that "the same" means every field.
func _bits(reading: RiftLevelOfferSeedReading) -> String:
	if reading == null:
		return "no reading"
	return "ok=%s run=%d level=%d seed=%d reason=%s" % [
		str(reading.ok), reading.run_seed, reading.level, reading.offer_root_seed, reading.failure_reason,
	]


# --- Source readers ----------------------------------------------------------------

## Every line that is not a whole-line comment.
func _code_only(source: String) -> String:
	var out: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


## The code lines of the function whose declaration begins with `declaration`, up
## to the next line that is not indented.
func _function_body(source: String, declaration: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var inside: bool = false
	for line: String in _code_only(source).split("\n"):
		if not inside:
			if line.begins_with(declaration):
				inside = true
			continue
		if not line.is_empty() and not line.begins_with("\t") and not line.begins_with(" "):
			break
		if not line.strip_edges().is_empty():
			out.append(line)
	return out


func _line_index(lines: PackedStringArray, fragment: String) -> int:
	for index: int in lines.size():
		if lines[index].contains(fragment):
			return index
	return -1


func _lines_containing(lines: PackedStringArray, fragment: String) -> int:
	var found: int = 0
	for line: String in lines:
		if line.contains(fragment):
			found += 1
	return found


## Every `<digits>.<digits>` run in `code`.
func _float_literals(code: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var index: int = 0
	while index < code.length():
		if not _is_digit(code[index]):
			index += 1
			continue
		var start: int = index
		while index < code.length() and _is_digit(code[index]):
			index += 1
		if index >= code.length() or code[index] != ".":
			continue
		var dot: int = index
		index += 1
		if index >= code.length() or not _is_digit(code[index]):
			index = dot + 1
			continue
		while index < code.length() and _is_digit(code[index]):
			index += 1
		out.append(code.substr(start, index - start))
	return out


## Every distinct standalone numeric literal in `code`, NORMALIZED — underscores
## removed and hexadecimal converted to decimal — and sorted as text. A literal
## begins at a digit that is not part of an identifier; the brief's frozen
## constants are written with underscore separators and one in hexadecimal, which
## a digits-only scanner would silently skip.
func _numeric_literals(code: String) -> PackedStringArray:
	var found: Dictionary = {}
	var index: int = 0
	while index < code.length():
		if not _is_digit(code[index]) or (index > 0 and _is_identifier_character(code[index - 1])):
			index += 1
			continue
		var start: int = index
		while index < code.length() and (_is_word_character(code[index]) or code[index] == "_"):
			index += 1
		var token: String = code.substr(start, index - start).replace("_", "")
		var value: int = 0
		if token.begins_with("0x") or token.begins_with("0X"):
			value = token.substr(2).hex_to_int()
		else:
			value = token.to_int()
		found[str(value)] = true
	var out: PackedStringArray = PackedStringArray()
	for key: Variant in found:
		out.append(String(key))
	out.sort()
	return out


func _is_digit(character: String) -> bool:
	return character.length() == 1 and character >= "0" and character <= "9"


func _is_identifier_character(character: String) -> bool:
	return _is_word_character(character) or character == "_" or character == "."


## Whether `code` names `token` as a deferred member. Tokens listed in
## `WORD_MATCHED_TOKENS` must appear at an identifier-word boundary — a letter or
## a digit on either side disqualifies the match, while an underscore does not —
## and every other token is an ordinary substring.
func _names_deferred_member(code: String, token: String) -> bool:
	if not WORD_MATCHED_TOKENS.has(token):
		return code.contains(token)
	var from: int = 0
	while true:
		var at: int = code.find(token, from)
		if at < 0:
			return false
		var before_ok: bool = at == 0 or not _is_word_character(code[at - 1])
		var after: int = at + token.length()
		var after_ok: bool = after >= code.length() or not _is_word_character(code[after])
		if before_ok and after_ok:
			return true
		from = at + 1
	return false


## A letter or a digit. The underscore is deliberately NOT one.
func _is_word_character(character: String) -> bool:
	return character.length() == 1 and (
		(character >= "a" and character <= "z")
		or (character >= "A" and character <= "Z")
		or (character >= "0" and character <= "9")
	)


## Every method as `name(arg: Type, ...) -> Type`, in declaration order.
func _signatures_of(path: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var script: GDScript = load(path) as GDScript
	if script == null:
		return out
	for entry: Dictionary in script.get_script_method_list():
		var args: PackedStringArray = PackedStringArray()
		for argument: Dictionary in entry.get("args", []):
			args.append("%s: %s" % [String(argument.get("name", "")), _type_name(int(argument.get("type", 0)))])
		var returns: Dictionary = entry.get("return", {}) as Dictionary
		out.append("%s(%s) -> %s" % [
			String(entry.get("name", "")), ", ".join(args), _type_name(int(returns.get("type", 0))),
		])
	return out


func _constants_of(path: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var script: GDScript = load(path) as GDScript
	if script == null:
		return out
	for key: Variant in script.get_script_constant_map():
		out.append(String(key))
	return out


func _type_name(type_id: int) -> String:
	match type_id:
		TYPE_NIL:
			return "void"
		TYPE_BOOL:
			return "bool"
		TYPE_INT:
			return "int"
		TYPE_FLOAT:
			return "float"
		TYPE_STRING:
			return "String"
		TYPE_OBJECT:
			return "Object"
		_:
			return "type %d" % type_id


func _fields_of(instance: Object) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for entry: Dictionary in instance.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			out.append(String(entry.get("name", "")))
	return out


func _files_under(root: String, extensions: Array[String]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open(root)
	if dir == null:
		return out
	dir.list_dir_begin()
	var entry: String = dir.get_next()
	while not entry.is_empty():
		if entry != "." and entry != "..":
			var full: String = root.path_join(entry)
			if dir.current_is_dir():
				out.append_array(_files_under(full, extensions))
			else:
				for extension: String in extensions:
					if entry.ends_with(extension):
						out.append(full)
						break
		entry = dir.get_next()
	dir.list_dir_end()
	return out


func _check_every_check_ran() -> void:
	print("")
	print("--- Every check this suite owes actually reached its last line")
	var missing: PackedStringArray = PackedStringArray()
	for owed: String in OWED_CHECKS:
		if not _reached.has(owed):
			missing.append(owed)
	var extra: PackedStringArray = PackedStringArray()
	for ran: Variant in _reached:
		if not OWED_CHECKS.has(String(ran)):
			extra.append(String(ran))
	_expect(missing.is_empty(), "check(s) never completed: %s" % ", ".join(missing))
	_expect(extra.is_empty(), "check(s) ran that the suite does not owe: %s" % ", ".join(extra))
	print("  %d of %d owed checks completed" % [_reached.size(), OWED_CHECKS.size()])


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
