extends SceneTree
## Riftwrought — Roguelite Foundation G1 verification: the deterministic greybox
## level-requirement curve.
##
## ONE FOCUSED HEADLESS TEST. The foundation is two pure-logic scripts under
## `scripts/level_requirements/`, so it needs no scene, no camera, no navigation,
## no rendering and no evidence frame, and it deliberately gets none. It runs as a
## `SceneTree` script exactly as every earlier foundation's suite does.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## EVERY EXPECTED NUMBER IS AN INDEPENDENT LITERAL. The curve is never checked
## against a second copy of its own formula. The named examples, the anchors at
## both ends of both consecutive windows, the representation bound, the largest
## supported level and its requirement, the first refused level's would-be
## requirement and the three wrap-around levels were all calculated OUTSIDE this
## engine before they were typed here. The consecutive windows are then walked
## one level at a time, and a window whose first and last values are both typed
## literals, and in which every adjacent step is exactly 25, pins every value
## inside it without this file restating the rule that produced them.
##
## THE ONE PLACE THIS FILE MULTIPLIES BY 25 IS A DEMONSTRATION OF THE ENGINE, NOT
## OF THE CURVE: it shows that whole-number multiplication here wraps silently,
## which is the hazard the curve's guards exist to prevent. It never adds the
## base, and it never produces a requirement.

# --- The two scripts this foundation owns ------------------------------------------

const CURVE_FILE: String = "res://scripts/level_requirements/rift_level_requirement_curve.gd"
const READING_FILE: String = "res://scripts/level_requirements/rift_level_requirement_reading.gd"

const G1_FILES: Array[String] = [
	"res://scripts/level_requirements/rift_level_requirement_curve.gd",
	"res://scripts/level_requirements/rift_level_requirement_reading.gd",
]

## The two global class names this foundation introduces. NOTHING that runs may
## reference either of them except an authorized reader below.
const G1_CLASSES: Array[String] = [
	"RiftLevelRequirementCurve", "RiftLevelRequirementReading",
]

## THE ONE FILE AUTHORIZED TO NAME A G1 CLASS, AND THE EXACT CLASSES IT MAY NAME
## (Foundation G4, decision D-269). The repeated run-level coordinator asks this
## curve for the current level's requirement before it opens that level's offer,
## and reads the answer's `ok` before converting it — so it names the curve and the
## reading. It is itself called by nothing that runs; the run-level record beside
## it names no G1 class at all.
##
## THIS REPLACES THE BLANKET "nothing that runs may name either class" ONE FOR
## ONE: the same single assertion is made either way, it still fails for any other
## file AND for any class a listed file is not granted, and the pinned count does
## not move.
##
## D-288: the Roguelite Experience Collection Greybox Review — an isolated scene
## launched by name — displays the current Rift level's requirement beside its
## experience, so it asks this curve for it and reads the answer's `ok` before using
## it, naming the curve and the reading. It restates no part of the formula. The
## same single assertion is made, and the pinned count does not move.
const AUTHORIZED_READERS: Array = [
	["res://scripts/levels/rift_run_level_coordinator.gd", [
		"RiftLevelRequirementCurve", "RiftLevelRequirementReading",
	]],
	["res://scripts/roguelite/experience/roguelite_experience_collection_review.gd", [
		"RiftLevelRequirementCurve", "RiftLevelRequirementReading",
	]],
]

## The only project classes each G1 file may name, PER FILE, checked against the
## engine's own global class list. The reading is granted nothing but itself:
## the curve names the reading because it builds one, and the reading must never
## name the curve, or the two files would each hold half of the other's rule.
const AUTHORIZED_CLASSES: Array = [
	["res://scripts/level_requirements/rift_level_requirement_curve.gd", [
		"RiftLevelRequirementCurve", "RiftLevelRequirementReading",
	]],
	["res://scripts/level_requirements/rift_level_requirement_reading.gd", [
		"RiftLevelRequirementReading",
	]],
]

## The accepted PRODUCTION files this foundation stands beside. Only production
## files: no other suite's source is read by this one, so nothing another suite
## names, formats or moves can change a result here (decision D-263).
const E1_TRACK_FILE: String = "res://scripts/experience/rift_experience_track.gd"
const E1_READING_FILE: String = "res://scripts/experience/rift_experience_reading.gd"
const E2_COORDINATOR_FILE: String = "res://scripts/levels/rift_level_up_coordinator.gd"
const E2_RESULT_FILE: String = "res://scripts/levels/rift_level_up_result.gd"

## THE LEVEL-1 REQUIREMENT AS THE SPECIFICATION STATES IT, typed independently.
## It is the same 100 the accepted level-up coordinator was accepted against, and
## that agreement is proved by BEHAVIOUR against the accepted track below — not by
## reading another suite's source, which D-263 removed.
const LEVEL_ONE_REQUIREMENT: int = 100
const LEVEL_ONE_AS_EXPERIENCE: float = 100.0

## The three accumulations Level 1 is measured against, and what each leaves.
const EXACTLY_ENOUGH: float = 100.0
const SHORT_OF_IT: float = 75.0
const SHORT_BY: float = 25.0
const MORE_THAN_ENOUGH: float = 130.0
const KEPT_AFTER_ONE_LEVEL: float = 30.0

## The requirement-taking members E1 was accepted with. Each must still be there,
## with the requirement still supplied by the caller as a plain number.
const E1_REQUIREMENT_SIGNATURES: Array[String] = [
	"requirement_problem(requirement: float) -> String",
	"reading_for(requirement: float) -> Object",
	"is_ready(requirement: float) -> bool",
	"remaining(requirement: float) -> float",
	"advance_one_level(requirement: float) -> String",
]

## Names the accepted E1 and E2 files must still not carry. Each was confirmed
## absent from all four before this foundation was written.
const G1_NAMES_E1_E2_MUST_NOT_CARRY: Array[String] = [
	"RiftLevelRequirementCurve", "RiftLevelRequirementReading",
	"requirement_for", "MAX_SUPPORTED_LEVEL", "REQUIREMENT_STEP", "BASE_REQUIREMENT",
	"LARGEST_EXACT_REQUIREMENT",
]

# --- Independent expectations ------------------------------------------------------
#
# Calculated outside this engine. Nothing below was produced by running the curve.

## [current level, requirement as a whole number, requirement as experience].
const NAMED_EXAMPLES: Array = [
	[1, 100, 100.0],
	[2, 125, 125.0],
	[3, 150, 150.0],
	[5, 200, 200.0],
	[10, 325, 325.0],
	[25, 700, 700.0],
	[100, 2575, 2575.0],
]

## Levels that must refuse because they are below the first level. The last is
## the most negative whole number there is: subtracting one from it wraps to the
## most positive, which is why the floor must be checked before the subtraction.
const BELOW_ONE: Array[int] = [0, -1, -24, -100, -1000000, -9223372036854775808]

## Every level is 25 more than the one before it.
const ADJACENT_STEP: int = 25
const ADJACENT_STEP_AS_EXPERIENCE: float = 25.0

## 2^53 - 1, and 2^53.
const EXPECTED_LARGEST_EXACT: int = 9007199254740991
const TWO_TO_THE_FIFTY_THIRD: int = 9007199254740992

## floor((9007199254740991 - 100) / 25) = 360287970189635 steps past Level 1.
const EXPECTED_MAX_LEVEL: int = 360287970189636
## 100 + 25 x 360287970189635.
##
## TYPED AS A WHOLE NUMBER AND NEVER AS A DECIMAL, AND THE REASON WAS MEASURED.
## This engine's decimal parser does not read every large decimal exactly: the
## literal `9007199254740975.0` parses as 9007199254740974, and
## `9007199254740991.0` as 9007199254740990 — `String.to_float()` on the same
## text does the same — while whole-number literals and the whole-number to
## double conversion are exact. So the expected double at the boundary is this
## exact whole number converted, not a typed decimal. The curve's own
## conversion is the same whole-number conversion, which is exactly why its
## production code writes no floating-point literal at all.
const EXPECTED_MAX_REQUIREMENT: int = 9007199254740975
## The whole numbers either side of it, whose doubles must both differ from its.
const BELOW_MAX_REQUIREMENT: int = 9007199254740974
const ABOVE_MAX_REQUIREMENT: int = 9007199254740976

## The first refused level, and what it WOULD require: 100 + 25 x 360287970189636.
const FIRST_UNSUPPORTED_LEVEL: int = 360287970189637
const FIRST_UNSUPPORTED_WOULD_REQUIRE: int = 9007199254741000
## And what the level after it would require. Odd, and above 2^53.
const SECOND_UNSUPPORTED_WOULD_REQUIRE: int = 9007199254741025

## The refusal band between the two representation guards. Levels up to this one
## pass the multiplication guard and are refused by the addition guard, because
## floor(9007199254740991 / 25) = 360287970189639 steps is the most the product
## may take.
const LAST_ADDITION_GUARD_LEVEL: int = 360287970189640
const FIRST_MULTIPLICATION_GUARD_LEVEL: int = 360287970189641

## [level, what unguarded arithmetic would report]. For each, 25 x (level - 1) is
## an exact multiple of 2^64 plus a small remainder — 2^64 + 9, 2 x 2^64 + 18 and
## 3 x 2^64 + 2 — so wrapping arithmetic followed by the base would report a
## small, positive, exactly representable and completely wrong requirement.
const WRAP_LEVELS: Array = [
	[737869762948382066, 109],
	[1475739525896764131, 118],
	[2213609288845146195, 102],
]
## The product 25 x 737869762948382065 wraps to exactly this.
const FIRST_WRAPPED_PRODUCT: int = 9

const INT64_MAX: int = 9223372036854775807
const INT64_MIN: int = -9223372036854775808

## Two consecutive windows of this many levels each: one from Level 1, and one
## ending exactly at the largest supported level.
const WINDOW_SIZE: int = 10000
const LOW_WINDOW_FIRST: int = 1
const LOW_WINDOW_FIRST_REQUIREMENT: int = 100
## 100 + 25 x 9999.
const LOW_WINDOW_LAST_REQUIREMENT: int = 250075
const HIGH_WINDOW_FIRST: int = 360287970179637
## 9007199254740975 - 25 x 9999.
const HIGH_WINDOW_FIRST_REQUIREMENT: int = 9007199254491000

## Levels far beyond anything a run will reach, each with its requirement. None
## of them is refused, because there is no designed maximum level.
const FAR_SAMPLE: Array = [
	[1000000, 25000075],
	[1000000000, 25000000075],
	[1000000000000, 25000000000075],
	[100000000000000, 2500000000000075],
	[300000000000000, 7500000000000075],
]

## Finite progress values a careless `progress >= converted` comparison could be
## asked about: zero (where every new track starts), fractions, the review
## values, the boundary requirement itself, very large finite values, and two
## negatives for completeness. The largest finite double is added at run time,
## BUILT BY ARITHMETIC rather than typed, because this engine's decimal parser is
## not exact at large magnitudes (see `EXPECTED_MAX_REQUIREMENT`).
const FINITE_PROGRESS_PROBES: Array[float] = [
	0.0, 0.5, 1.0, 75.0, 100.0, 2575.0,
	1.0e15, 1.0e300, -1.0, -1.0e300,
]

# --- Pins -------------------------------------------------------------------------

const EXPECTED_CURVE_SIGNATURES: Array[String] = [
	"requirement_for(level: int) -> Object",
	"_beyond_representation(level: int) -> String",
]

const EXPECTED_READING_SIGNATURES: Array[String] = [
	"refused(for_level: int, reason: String) -> Object",
	"measured(for_level: int, for_requirement: int) -> Object",
	"experience_requirement() -> float",
	"problem() -> String",
	"describe() -> String",
]

const EXPECTED_CURVE_CONSTANTS: Array[String] = [
	"FIRST_LEVEL", "BASE_REQUIREMENT", "REQUIREMENT_STEP", "MAX_SUPPORTED_LEVEL",
	"_BEYOND_REPRESENTATION",
]

const EXPECTED_READING_CONSTANTS: Array[String] = [
	"EXACT_INTEGER_BITS", "LARGEST_EXACT_REQUIREMENT", "NO_REQUIREMENT",
]

const EXPECTED_READING_FIELDS: Array[String] = [
	"ok", "failure_reason", "level", "requirement",
]

## The only whole-number literals each file's code may contain. A cap, a table of
## per-level values, a curve version or a schema number would arrive as exactly
## one more of these while naming nothing forbidden at all.
const EXPECTED_CURVE_INTEGERS: Array[String] = ["1", "100", "25"]
const EXPECTED_READING_INTEGERS: Array[String] = ["0", "1", "53"]

## Concrete card, Skill and instrument names, record fields a card carries, and
## the constants the unrelated first-MVP character curve is written in. Scanned
## RAW, comments included — D-215's lesson: an illustrative name in a comment
## breaches the rule just as surely as a real one.
const FORBIDDEN_TOKENS: Array[String] = [
	"card_power", "card_celerity", "card_vitality",
	"card_fleetness", "card_insight", "card_magnetism",
	"display_name", "base_weight", "magnitude",
	"QuickStrike", "quick_strike", "Quick Strike",
	"reaching_edge", "sweeping_edge", "Graveblade", "Riftmarked",
	"ExperienceTable", "CharacterState",
	"TOTAL_FOR_LEVEL", "MAX_DEFINED_LEVEL", "POINTS_PER_LEVEL", "GRAVEBLADE_EXPERIENCE",
]

## A pure rule may read no ambient state whatsoever. Scanned RAW.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
	"get_tree", "get_node", "Node", "Performance",
]

## THE SYSTEMS THIS FOUNDATION DEFERS, AS CODE TOKENS. Scanned over code lines
## only, because both files say in plain English that they keep no cumulative
## total, derive no seed and have no cap — and a raw scan would be red on exactly
## the sentences that promise it. The short ones are matched as whole identifier
## words; see `_names_deferred_member()`.
const DEFERRED_MEMBER_TOKENS: Array[String] = [
	"cumulative", "lifetime", "total", "table", "cache", "memo", "history",
	"seed", "offer", "lane", "choice", "card", "support", "rank",
	"progress", "award", "advance", "pending", "next_level", "level_up",
	"mote", "enemy", "difficulty", "intensity",
	"save", "persist", "storage", "schema", "version",
	"level_cap", "max_level", "maximum_level", "ceiling", "clamp", "mini", "maxi",
	"scene", "input", "ui", "signal",
]

const WORD_MATCHED_TOKENS: Array[String] = [
	"total", "table", "cache", "memo", "seed", "offer", "lane", "card", "support",
	"rank", "mote", "save", "mini", "maxi", "scene", "input", "ui", "signal",
]

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]

const PROJECT_SETTINGS_FILE: String = "res://project.godot"

const OWED_CHECKS: Array[String] = [
	"levels_below_one_refuse_with_no_usable_requirement",
	"the_named_examples_are_exact",
	"level_one_is_the_specified_100_and_the_accepted_track_takes_it",
	"a_long_consecutive_range_is_positive_finite_and_strictly_increasing",
	"every_adjacent_requirement_differs_by_exactly_25",
	"repeated_calls_are_bit_identical",
	"call_order_does_not_affect_results",
	"the_curve_carries_no_instance_state",
	"the_reading_catches_contradictory_shapes",
	"the_largest_supported_level_succeeds_exactly",
	"the_first_unsupported_level_refuses_atomically",
	"no_result_exceeds_the_exact_integer_boundary",
	"every_operation_is_guarded_before_it_runs",
	"nothing_calls_the_curve_and_e1_e2_still_take_supplied_requirements",
	"no_maximum_no_cumulative_table_no_seed_and_no_loop",
	"a_refused_conversion_fails_safe",
	"every_successful_conversion_is_finite_positive_and_exact",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0
var _successes: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation G1 — Deterministic Greybox Level-Requirement Curve (D-262) ===")

	_check_levels_below_one_refuse()
	_check_the_named_examples_are_exact()
	_check_level_one_is_the_specified_100()
	_check_a_long_consecutive_range_is_increasing()
	_check_every_adjacent_requirement_differs_by_25()
	_check_repeated_calls_are_bit_identical()
	_check_call_order_does_not_affect_results()
	_check_the_curve_carries_no_instance_state()
	_check_the_reading_catches_contradictory_shapes()
	_check_the_largest_supported_level_succeeds_exactly()
	_check_the_first_unsupported_level_refuses_atomically()
	_check_no_result_exceeds_the_exact_integer_boundary()
	_check_every_operation_is_guarded_before_it_runs()
	_check_nothing_calls_the_curve()
	_check_no_maximum_no_table_no_seed_no_loop()
	_check_a_refused_conversion_fails_safe()
	_check_every_successful_conversion_is_exact()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT LEVEL REQUIREMENT CURVE VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT LEVEL REQUIREMENT CURVE VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. Below the first level --------------------------------------------------------

func _check_levels_below_one_refuse() -> void:
	print("")
	print("--- 1. Levels below 1 refuse with no usable requirement")
	for level: int in BELOW_ONE:
		var reading: RiftLevelRequirementReading = _ask(level)
		_expect_refusal(reading, level, "level %d" % level)
		_expect(reading.failure_reason.contains("level %d" % level),
			"the refusal of level %d does not name it: %s" % [level, reading.failure_reason])
		## REFUSED AS BELOW THE FIRST LEVEL, NOT AS A REPRESENTATION LIMIT. For the
		## most negative level that distinction is the whole proof that the floor
		## is asked before the subtraction, because that subtraction would wrap it
		## to the most positive level there is and a later guard would then refuse
		## it for the wrong reason.
		_expect(not reading.failure_reason.contains(str(EXPECTED_LARGEST_EXACT)),
			"level %d was refused as a representation limit rather than as below Level 1: %s"
				% [level, reading.failure_reason])

	## THE POSITIVE CONTROL: a floor that refused everything would pass every row
	## above.
	var first: RiftLevelRequirementReading = _ask(1)
	_expect(first.ok, "level 1 was refused: %s" % first.failure_reason)
	_expect(RiftLevelRequirementReading.NO_REQUIREMENT == 0,
		"the no-requirement stand-in is %d, not 0" % RiftLevelRequirementReading.NO_REQUIREMENT)

	print("  %d levels below 1 refused, down to %d; each stored requirement 0 and converted to positive infinity; level 1 answers"
		% [BELOW_ONE.size(), INT64_MIN])
	_done("levels_below_one_refuse_with_no_usable_requirement")


# --- 2. The named examples -----------------------------------------------------------

func _check_the_named_examples_are_exact() -> void:
	print("")
	print("--- 2. The named review values are exact")
	var shown: PackedStringArray = PackedStringArray()
	for row: Array in NAMED_EXAMPLES:
		var level: int = int(row[0])
		var reading: RiftLevelRequirementReading = _ask(level)
		_expect_success(reading, level, int(row[1]), float(row[2]), "level %d" % level)
		shown.append("%d -> %d" % [level, reading.requirement])
	print("  level %s" % ", ".join(shown))
	_done("the_named_examples_are_exact")


# --- 3. Level 1 is the specified 100, and the accepted track takes it --------------

func _check_level_one_is_the_specified_100() -> void:
	print("")
	print("--- 3. Level 1 is the specified 100, and the accepted track takes it as a supplied requirement")
	var first: RiftLevelRequirementReading = _ask(1)
	_expect_success(first, 1, LEVEL_ONE_REQUIREMENT, LEVEL_ONE_AS_EXPERIENCE, "level 1")
	var supplied: float = first.experience_requirement()

	## THE LEVEL A NEW TRACK BEGINS AT IS THE LEVEL WHOSE REQUIREMENT THIS IS.
	## Ordinary consistency, not a dependency — the curve does not name the track.
	_expect(RiftLevelRequirementCurve.FIRST_LEVEL == RiftExperienceTrack.STARTING_LEVEL,
		"the curve's first level %d is not the track's starting level %d" % [
			RiftLevelRequirementCurve.FIRST_LEVEL, RiftExperienceTrack.STARTING_LEVEL,
		])
	_expect(RiftExperienceTrack.new().level() == RiftLevelRequirementCurve.FIRST_LEVEL,
		"a new track does not begin at the curve's first level")
	_expect(RiftExperienceTrack.requirement_problem(supplied).is_empty(),
		"the accepted track refuses the level-1 answer: %s"
			% RiftExperienceTrack.requirement_problem(supplied))

	## READY AT EXACTLY 100, with nothing left, and one advance keeps nothing over.
	var exact: RiftExperienceTrack = _track_holding(EXACTLY_ENOUGH)
	var at_exact: RiftExperienceReading = exact.reading_for(supplied)
	_expect(at_exact.ok and at_exact.ready and at_exact.remaining == 0.0
			and at_exact.requirement == LEVEL_ONE_AS_EXPERIENCE,
		"100 against the level-1 answer reads: %s" % at_exact.describe())
	_expect_accepted(exact.advance_one_level(supplied), "advancing 100 against the level-1 answer")
	_expect(_track_line(exact) == "level=2 progress=0.0",
		"100 advanced to %s" % _track_line(exact))

	## NOT READY AT 75: 25 still needed, and an advance is refused without moving
	## anything.
	var short: RiftExperienceTrack = _track_holding(SHORT_OF_IT)
	var at_short: RiftExperienceReading = short.reading_for(supplied)
	_expect(at_short.ok and not at_short.ready and at_short.remaining == SHORT_BY,
		"75 against the level-1 answer reads: %s" % at_short.describe())
	var before_short: String = _track_line(short)
	_expect(not short.advance_one_level(supplied).is_empty(),
		"75 advanced against the level-1 answer")
	_expect(_track_line(short) == before_short,
		"a refused advance at 75 moved the track to %s" % _track_line(short))

	## 130 ADVANCES EXACTLY ONCE AND KEEPS THE 30 OVER — and a second advance
	## against the same requirement is refused, because 30 is short of 100.
	var over: RiftExperienceTrack = _track_holding(MORE_THAN_ENOUGH)
	_expect_accepted(over.advance_one_level(supplied), "advancing 130 against the level-1 answer")
	_expect(over.level() == 2 and over.progress() == KEPT_AFTER_ONE_LEVEL,
		"130 advanced to %s" % _track_line(over))
	var after_one: String = _track_line(over)
	_expect(not over.advance_one_level(supplied).is_empty(),
		"30 advanced a second time against the level-1 answer")
	_expect(_track_line(over) == after_one,
		"the refused second advance moved the track to %s" % _track_line(over))

	print("  level 1 -> %d, converted %s; the accepted track: 100 ready with 0.0 left, 75 not ready with 25.0 still needed, 130 advances once to Level 2 keeping 30.0"
		% [first.requirement, _exact(supplied)])
	_done("level_one_is_the_specified_100_and_the_accepted_track_takes_it")


# --- 4. Positive, finite and strictly increasing --------------------------------------

func _check_a_long_consecutive_range_is_increasing() -> void:
	print("")
	print("--- 4. Two consecutive windows are positive, finite and strictly increasing")
	var windows: Array = [
		["from Level 1", LOW_WINDOW_FIRST, LOW_WINDOW_FIRST_REQUIREMENT, LOW_WINDOW_LAST_REQUIREMENT],
		["ending at the boundary", HIGH_WINDOW_FIRST, HIGH_WINDOW_FIRST_REQUIREMENT,
			EXPECTED_MAX_REQUIREMENT],
	]
	## The high window really does end at the boundary. Two literals, checked
	## against each other, so that neither can quietly drift.
	_expect(HIGH_WINDOW_FIRST + WINDOW_SIZE - 1 == EXPECTED_MAX_LEVEL,
		"the high window does not end at the largest supported level")
	for window: Array in windows:
		var label: String = String(window[0])
		var first_level: int = int(window[1])
		var examined: int = 0
		var refused: int = 0
		var not_positive: int = 0
		var not_finite: int = 0
		var not_increasing: int = 0
		var not_increasing_as_experience: int = 0
		var first_requirement: int = 0
		var last_requirement: int = 0
		var previous_requirement: int = 0
		var previous_experience: float = 0.0
		for offset: int in WINDOW_SIZE:
			var reading: RiftLevelRequirementReading = _ask(first_level + offset)
			examined += 1
			if not reading.ok or not reading.problem().is_empty():
				refused += 1
				continue
			var experience: float = reading.experience_requirement()
			if reading.requirement <= 0 or experience <= 0.0:
				not_positive += 1
			if not is_finite(experience):
				not_finite += 1
			if offset == 0:
				first_requirement = reading.requirement
			else:
				if reading.requirement <= previous_requirement:
					not_increasing += 1
				if experience <= previous_experience:
					not_increasing_as_experience += 1
			last_requirement = reading.requirement
			previous_requirement = reading.requirement
			previous_experience = experience
		_expect(examined == WINDOW_SIZE,
			"the window %s examined %d levels, not %d" % [label, examined, WINDOW_SIZE])
		_expect(refused == 0, "the window %s refused %d levels" % [label, refused])
		_expect(not_positive == 0, "the window %s held %d non-positive values" % [label, not_positive])
		_expect(not_finite == 0, "the window %s held %d non-finite values" % [label, not_finite])
		_expect(not_increasing == 0,
			"the window %s failed to increase %d times" % [label, not_increasing])
		_expect(not_increasing_as_experience == 0,
			"the window %s failed to increase as experience %d times"
				% [label, not_increasing_as_experience])
		_expect(first_requirement == int(window[2]),
			"the window %s begins at %d, not %d" % [label, first_requirement, int(window[2])])
		_expect(last_requirement == int(window[3]),
			"the window %s ends at %d, not %d" % [label, last_requirement, int(window[3])])
		print("  %d consecutive levels %s: %d -> %d, every one positive, finite and larger than the last"
			% [examined, label, first_requirement, last_requirement])
	_done("a_long_consecutive_range_is_positive_finite_and_strictly_increasing")


# --- 5. Exactly 25 apart ---------------------------------------------------------------

func _check_every_adjacent_requirement_differs_by_25() -> void:
	print("")
	print("--- 5. Every adjacent requirement differs by exactly 25")
	for first_level: int in [LOW_WINDOW_FIRST, HIGH_WINDOW_FIRST]:
		var steps: int = 0
		var wrong: int = 0
		var wrong_as_experience: int = 0
		var previous: RiftLevelRequirementReading = _ask(first_level)
		for offset: int in range(1, WINDOW_SIZE):
			var reading: RiftLevelRequirementReading = _ask(first_level + offset)
			steps += 1
			if reading.requirement - previous.requirement != ADJACENT_STEP:
				wrong += 1
			## AS THE TRACK'S OWN NUMBER TOO, where it matters most: at the top of the
			## exact range the doubles are one apart, so a requirement that had lost
			## precision would show up here as a step of 24 or 26.
			if reading.experience_requirement() - previous.experience_requirement() \
					!= ADJACENT_STEP_AS_EXPERIENCE:
				wrong_as_experience += 1
			previous = reading
		_expect(steps == WINDOW_SIZE - 1,
			"%d steps were measured from level %d, not %d" % [steps, first_level, WINDOW_SIZE - 1])
		_expect(wrong == 0, "%d steps from level %d were not exactly 25" % [wrong, first_level])
		_expect(wrong_as_experience == 0,
			"%d steps from level %d were not exactly 25.0 as experience"
				% [wrong_as_experience, first_level])
		print("  from level %d: %d adjacent steps, every one exactly 25 and exactly 25.0"
			% [first_level, steps])
	_done("every_adjacent_requirement_differs_by_exactly_25")


# --- 6. Bit-identical repetition -------------------------------------------------------

func _check_repeated_calls_are_bit_identical() -> void:
	print("")
	print("--- 6. Repeated calls return bit-identical results")
	var sample: Array[int] = _sample_levels()
	var identical: int = 0
	for level: int in sample:
		var a: RiftLevelRequirementReading = _ask(level)
		var b: RiftLevelRequirementReading = _ask(level)
		var c: RiftLevelRequirementReading = _ask(level)
		if _bits(a) == _bits(b) and _bits(b) == _bits(c):
			identical += 1
		else:
			_expect(false, "level %d answered %s, then %s, then %s" % [
				level, _bits(a), _bits(b), _bits(c),
			])
		## A FRESH VALUE EACH TIME, never a cached one.
		_expect(a != b and b != c and a != c,
			"the curve handed out one reading object twice for level %d" % level)
	_expect(identical == sample.size(),
		"%d of %d sampled levels repeated bit for bit" % [identical, sample.size()])

	## A RETURNED READING IS THE CALLER'S OWN. Tampering with every field of one
	## reaches nothing the next call answers.
	var before: String = _bits(_ask(5))
	var tampered: RiftLevelRequirementReading = _ask(5)
	tampered.ok = false
	tampered.failure_reason = "zz tampered"
	tampered.level = 6
	tampered.requirement = 1
	_expect(_bits(_ask(5)) == before,
		"tampering with a returned reading changed the next answer to %s" % _bits(_ask(5)))

	print("  %d sampled levels asked three times each: every answer bit-identical and a fresh value; a tampered reading reached nothing"
		% sample.size())
	_done("repeated_calls_are_bit_identical")


# --- 7. Order independence -------------------------------------------------------------

func _check_call_order_does_not_affect_results() -> void:
	print("")
	print("--- 7. Call order does not affect results")
	var sample: Array[int] = _sample_levels()

	var forward: Dictionary = {}
	for level: int in sample:
		forward[level] = _bits(_ask(level))

	var backward: Dictionary = {}
	for index: int in range(sample.size() - 1, -1, -1):
		backward[sample[index]] = _bits(_ask(sample[index]))

	## FROM BOTH ENDS AT ONCE, with a refusal from each end of the domain asked
	## between every pair — a curve that remembered its last refusal would show it.
	var interleaved: Dictionary = {}
	var low: int = 0
	var high: int = sample.size() - 1
	while low <= high:
		_ask(INT64_MIN)
		interleaved[sample[low]] = _bits(_ask(sample[low]))
		_ask(INT64_MAX)
		interleaved[sample[high]] = _bits(_ask(sample[high]))
		low += 1
		high -= 1

	## THROUGH TWO SEPARATE INSTANCES, alternately. There is nothing an instance
	## could hold, and this is the behaviour that says so.
	var one: RiftLevelRequirementCurve = RiftLevelRequirementCurve.new()
	var two: RiftLevelRequirementCurve = RiftLevelRequirementCurve.new()
	var through_instances: Dictionary = {}
	for index: int in sample.size():
		var curve: RiftLevelRequirementCurve = one if index % 2 == 0 else two
		through_instances[sample[index]] = _bits(
			curve.call("requirement_for", sample[index]) as RiftLevelRequirementReading)

	var disagreements: int = 0
	for level: int in sample:
		for other: Dictionary in [backward, interleaved, through_instances]:
			if String(other.get(level, "")) != String(forward[level]):
				disagreements += 1
				_expect(false, "level %d answered %s in one order and %s in another" % [
					level, String(forward[level]), String(other.get(level, "")),
				])
	_expect(disagreements == 0, "%d answers depended on call order" % disagreements)
	_expect(forward.size() == sample.size() and interleaved.size() == sample.size(),
		"an ordering pass skipped a level")

	print("  %d levels asked forwards, backwards, from both ends between refusals, and through two instances: 0 answers moved"
		% sample.size())
	_done("call_order_does_not_affect_results")


# --- 8. No instance state --------------------------------------------------------------

func _check_the_curve_carries_no_instance_state() -> void:
	print("")
	print("--- 8. The curve carries zero instance fields")
	var curve_fields: PackedStringArray = _fields_of(RiftLevelRequirementCurve.new())
	_expect(curve_fields.is_empty(),
		"the curve carries the field(s) %s" % ", ".join(curve_fields))

	## THE SCRIPT'S OWN PROPERTY LIST, FILTERED TO VARIABLES. Unfiltered it is never
	## empty: the engine lists the script's category header as a property entry,
	## which is a heading and not state — this check's first form compared the
	## unfiltered list and failed on that heading alone.
	var script: GDScript = load(CURVE_FILE) as GDScript
	_expect(script != null, "the curve script could not be loaded")
	var script_variables: PackedStringArray = PackedStringArray()
	for entry: Dictionary in script.get_script_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			script_variables.append(String(entry.get("name", "")))
	_expect(script_variables.is_empty(),
		"the curve script declares variables: %s" % ", ".join(script_variables))

	## AND NOT A STATIC ONE EITHER: a static variable is state that outlives every
	## call and would never show up on an instance.
	var declared: PackedStringArray = PackedStringArray()
	for line: String in _code_only(FileAccess.get_file_as_string(CURVE_FILE)).split("\n"):
		if line.begins_with("var ") or line.begins_with("static var ") \
				or line.begins_with("@onready") or line.begins_with("@export"):
			declared.append(line.strip_edges())
	_expect(declared.is_empty(), "the curve declares state: %s" % " | ".join(declared))

	var not_static: PackedStringArray = PackedStringArray()
	var methods: int = 0
	for entry: Dictionary in script.get_script_method_list():
		methods += 1
		if int(entry.get("flags", 0)) & METHOD_FLAG_STATIC == 0:
			not_static.append(String(entry.get("name", "")))
	_expect(methods > 0, "the curve declares no methods, so this proves nothing")
	_expect(not_static.is_empty(),
		"the curve has instance method(s): %s" % ", ".join(not_static))

	var reading_fields: PackedStringArray = _fields_of(RiftLevelRequirementReading.new())
	_expect(", ".join(reading_fields) == ", ".join(EXPECTED_READING_FIELDS),
		"the reading carries the fields: %s" % ", ".join(reading_fields))

	print("  curve: 0 instance fields, 0 declared variables, %d of %d methods static; reading: %d fields — %s"
		% [methods - not_static.size(), methods, reading_fields.size(), ", ".join(reading_fields)])
	_done("the_curve_carries_no_instance_state")


# --- 9. Contradictory shapes -----------------------------------------------------------

func _check_the_reading_catches_contradictory_shapes() -> void:
	print("")
	print("--- 9. The reading catches contradictory success and failure shapes")
	var caught: int = 0

	## EACH TAMPERING STARTS FROM A GENUINE ANSWER AND CHANGES ONE FIELD, and each
	## is restored and shown to be coherent again — so it is the tampered field and
	## nothing else that problem() objected to.
	var success_cases: Array = [
		["a success with a failure reason", "failure_reason", "zz stray reason"],
		["a success with no requirement", "requirement", 0],
		["a success with a negative requirement", "requirement", -25],
		["a success beyond the exact bound", "requirement", TWO_TO_THE_FIFTY_THIRD],
		["a success for level 0", "level", 0],
		["a success for a negative level", "level", -3],
		["a success reporting failure", "ok", false],
	]
	for row: Array in success_cases:
		var reading: RiftLevelRequirementReading = _ask(5)
		_expect(reading.problem().is_empty(), "the genuine level-5 answer is incoherent")
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
		["a refusal carrying a requirement", "requirement", 100],
		["a refusal carrying a negative requirement", "requirement", -1],
		["a refusal reporting success", "ok", true],
	]
	for row: Array in refusal_cases:
		var reading: RiftLevelRequirementReading = _ask(0)
		_expect(reading.problem().is_empty(), "the genuine level-0 refusal is incoherent")
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
	var bare: RiftLevelRequirementReading = RiftLevelRequirementReading.new()
	_expect(not bare.problem().is_empty(), "a default-constructed reading is coherent")
	if not bare.problem().is_empty():
		caught += 1

	## THE REFUSAL CONSTRUCTOR NEVER LEAVES A REASON BLANK, so a caller cannot build
	## an incoherent refusal through it.
	var unstated: RiftLevelRequirementReading = RiftLevelRequirementReading.refused(7, "  ")
	_expect(not unstated.failure_reason.strip_edges().is_empty() and unstated.problem().is_empty(),
		"a refusal built with a blank reason is incoherent: %s" % unstated.problem())

	## POSITIVE CONTROLS AT BOTH EDGES OF WHAT A SUCCESS MAY HOLD: the bound is
	## inclusive, and the smallest possible level and requirement are coherent.
	var at_bound: RiftLevelRequirementReading = RiftLevelRequirementReading.measured(
		EXPECTED_MAX_LEVEL, EXPECTED_LARGEST_EXACT)
	_expect(at_bound.problem().is_empty(),
		"a success holding exactly the bound is refused: %s" % at_bound.problem())
	var smallest: RiftLevelRequirementReading = RiftLevelRequirementReading.measured(1, 1)
	_expect(smallest.problem().is_empty(),
		"the smallest coherent success is refused: %s" % smallest.problem())

	var expected_caught: int = success_cases.size() + refusal_cases.size() + 1
	_expect(caught == expected_caught,
		"%d of %d contradictory shapes were caught" % [caught, expected_caught])
	print("  %d contradictory shapes caught by problem(); each restored reading is coherent again; the bound itself is coherent"
		% caught)
	_done("the_reading_catches_contradictory_shapes")


# --- 10. The largest supported level ---------------------------------------------------

func _check_the_largest_supported_level_succeeds_exactly() -> void:
	print("")
	print("--- 10. The largest supported level succeeds exactly")
	## THE BOUND ITSELF, derived from the representation rather than typed in
	## production, and confirmed here against 2^53 computed independently.
	_expect(RiftLevelRequirementReading.EXACT_INTEGER_BITS == 53,
		"the exact-integer width is %d bits" % RiftLevelRequirementReading.EXACT_INTEGER_BITS)
	_expect((1 << 53) == TWO_TO_THE_FIFTY_THIRD, "the typed 2^53 is wrong")
	_expect(RiftLevelRequirementReading.LARGEST_EXACT_REQUIREMENT == EXPECTED_LARGEST_EXACT,
		"the largest exact requirement is %d, not 2^53 - 1 = %d" % [
			RiftLevelRequirementReading.LARGEST_EXACT_REQUIREMENT, EXPECTED_LARGEST_EXACT,
		])
	_expect(RiftLevelRequirementCurve.MAX_SUPPORTED_LEVEL == EXPECTED_MAX_LEVEL,
		"the largest supported level is %d, not %d" % [
			RiftLevelRequirementCurve.MAX_SUPPORTED_LEVEL, EXPECTED_MAX_LEVEL,
		])

	var reading: RiftLevelRequirementReading = _ask(EXPECTED_MAX_LEVEL)
	_expect_success(reading, EXPECTED_MAX_LEVEL, EXPECTED_MAX_REQUIREMENT,
		float(EXPECTED_MAX_REQUIREMENT), "the largest supported level")
	_expect(reading.requirement <= EXPECTED_LARGEST_EXACT,
		"its requirement %d exceeds the bound" % reading.requirement)
	var experience: float = reading.experience_requirement()
	_expect(is_finite(experience) and experience > 0.0,
		"its requirement converts to %s" % _exact(experience))
	_expect(int(experience) == reading.requirement,
		"its requirement does not survive the conversion: %d -> %d" % [
			reading.requirement, int(experience),
		])
	## EXACT AND DISTINCT: at this height the doubles are one apart, and this one
	## is neither of its neighbours.
	_expect(experience != float(BELOW_MAX_REQUIREMENT)
			and experience != float(ABOVE_MAX_REQUIREMENT),
		"its requirement collapsed onto a neighbouring double")

	print("  largest supported level %d -> %d, below the bound %d; converts exactly to %s"
		% [reading.level, reading.requirement, RiftLevelRequirementReading.LARGEST_EXACT_REQUIREMENT,
			_exact(experience)])
	_done("the_largest_supported_level_succeeds_exactly")


# --- 11. One level beyond --------------------------------------------------------------

func _check_the_first_unsupported_level_refuses_atomically() -> void:
	print("")
	print("--- 11. The first unsupported level refuses, atomically, and can be invoked directly")
	## IT CAN BE INVOKED: the boundary is nowhere near the top of the integer range,
	## so there is no limitation to explain away and no seam to manufacture.
	_expect(FIRST_UNSUPPORTED_LEVEL == EXPECTED_MAX_LEVEL + 1,
		"the typed first unsupported level is not one past the boundary")
	_expect(FIRST_UNSUPPORTED_LEVEL < INT64_MAX,
		"the first unsupported level cannot be passed as a whole number")

	var before: String = _bits(_ask(EXPECTED_MAX_LEVEL))
	var beyond: RiftLevelRequirementReading = _ask(FIRST_UNSUPPORTED_LEVEL)
	_expect_refusal(beyond, FIRST_UNSUPPORTED_LEVEL, "the first unsupported level")
	## IT NAMES THE BOUNDARY USEFULLY: the requested level, the bound, and the
	## largest level inside it.
	for named: int in [FIRST_UNSUPPORTED_LEVEL, EXPECTED_LARGEST_EXACT, EXPECTED_MAX_LEVEL]:
		_expect(beyond.failure_reason.contains(str(named)),
			"the refusal does not name %d: %s" % [named, beyond.failure_reason])
	## AND NOTHING WAS DISTURBED: there is no state to disturb, and the boundary
	## answer is identical before and after the refusal.
	_expect(_bits(_ask(EXPECTED_MAX_LEVEL)) == before,
		"the refusal changed the boundary answer")

	## WHY THE BOUNDARY IS THE CONTIGUOUS ONE. The would-be requirement is above
	## both 2^53 - 1 and 2^53, so the choice between those two conventions does not
	## move it — and it is itself EXACTLY REPRESENTABLE, so a per-value test would
	## have accepted this level. The next one's would-be requirement is not. A
	## per-value rule would therefore have produced a supported range with holes.
	_expect(FIRST_UNSUPPORTED_WOULD_REQUIRE > EXPECTED_LARGEST_EXACT
			and FIRST_UNSUPPORTED_WOULD_REQUIRE > TWO_TO_THE_FIFTY_THIRD,
		"the first unsupported level's requirement is within the bound")
	_expect(int(float(FIRST_UNSUPPORTED_WOULD_REQUIRE)) == FIRST_UNSUPPORTED_WOULD_REQUIRE,
		"9007199254741000 does not survive conversion, so the per-value point is unproven")
	_expect(int(float(SECOND_UNSUPPORTED_WOULD_REQUIRE)) != SECOND_UNSUPPORTED_WOULD_REQUIRE,
		"9007199254741025 survives conversion, so the per-value point is unproven")

	## THE WHOLE REFUSAL BAND, BOTH GUARDS: the four levels the multiplication guard
	## lets through and the addition guard refuses, then the first the
	## multiplication guard refuses, the three wrap-around levels and the top of the
	## integer range. Every one carries no requirement.
	var band: Array[int] = []
	for level: int in range(FIRST_UNSUPPORTED_LEVEL, LAST_ADDITION_GUARD_LEVEL + 1):
		band.append(level)
	band.append(FIRST_MULTIPLICATION_GUARD_LEVEL)
	for row: Array in WRAP_LEVELS:
		band.append(int(row[0]))
	band.append(INT64_MAX)
	for level: int in band:
		var reading: RiftLevelRequirementReading = _ask(level)
		_expect_refusal(reading, level, "level %d" % level)
		_expect(reading.failure_reason.contains(str(EXPECTED_LARGEST_EXACT)),
			"level %d was not refused as a representation limit: %s" % [level, reading.failure_reason])
	_expect(band.size() == 9, "the refusal band holds %d levels, not 9" % band.size())

	print("  level %d refused, storing requirement 0 and converting to positive infinity; it would need %d, exactly representable yet past the bound"
		% [FIRST_UNSUPPORTED_LEVEL, FIRST_UNSUPPORTED_WOULD_REQUIRE])
	print("  the %d-level refusal band across both guards, from %d to %d, all refused with no requirement; the boundary answer unmoved"
		% [band.size(), FIRST_UNSUPPORTED_LEVEL, INT64_MAX])
	_done("the_first_unsupported_level_refuses_atomically")


# --- 12. Nothing past the exact bound --------------------------------------------------

func _check_no_result_exceeds_the_exact_integer_boundary() -> void:
	print("")
	print("--- 12. No result exceeds the exact-integer boundary")
	## THE BOUNDARY IS WHERE THIS ENGINE'S DOUBLES STOP HOLDING EVERY WHOLE NUMBER:
	## 2^53 + 1 is the same double as 2^53, and 2^53 - 1 is not the same as 2^53 - 2.
	_expect(float(TWO_TO_THE_FIFTY_THIRD + 1) == float(TWO_TO_THE_FIFTY_THIRD),
		"2^53 + 1 is a distinct double here, so the bound is misplaced")
	_expect(float(EXPECTED_LARGEST_EXACT) != float(EXPECTED_LARGEST_EXACT - 1),
		"2^53 - 1 and 2^53 - 2 are the same double here, so the bound is misplaced")

	var levels: Array[int] = []
	for offset: int in WINDOW_SIZE:
		levels.append(LOW_WINDOW_FIRST + offset)
		levels.append(HIGH_WINDOW_FIRST + offset)
	for row: Array in NAMED_EXAMPLES:
		levels.append(int(row[0]))
	for row: Array in FAR_SAMPLE:
		levels.append(int(row[0]))

	var successes: int = 0
	var over: int = 0
	var lossy: int = 0
	var largest: int = 0
	for level: int in levels:
		var reading: RiftLevelRequirementReading = _ask(level)
		if not reading.ok:
			continue
		successes += 1
		if reading.requirement > EXPECTED_LARGEST_EXACT:
			over += 1
		if int(reading.experience_requirement()) != reading.requirement:
			lossy += 1
		if reading.requirement > largest:
			largest = reading.requirement
	_expect(successes == levels.size(),
		"%d of %d examined levels succeeded" % [successes, levels.size()])
	_expect(over == 0, "%d results exceeded the bound" % over)
	_expect(lossy == 0, "%d results did not survive conversion exactly" % lossy)
	_expect(largest == EXPECTED_MAX_REQUIREMENT,
		"the largest result examined is %d, not the boundary's %d" % [largest, EXPECTED_MAX_REQUIREMENT])

	print("  %d results examined: 0 above %d, 0 changed by conversion; the largest is %d"
		% [successes, EXPECTED_LARGEST_EXACT, largest])
	_done("no_result_exceeds_the_exact_integer_boundary")


# --- 13. Guarded before it runs --------------------------------------------------------

func _check_every_operation_is_guarded_before_it_runs() -> void:
	print("")
	print("--- 13. No multiplication or addition runs before its guard")

	## THE HAZARD IS REAL IN THIS ENGINE. Whole-number arithmetic wraps silently in
	## all three directions — no error, no warning, no infinity. The product below
	## is the engine's own answer for the first wrap-around level's steps; it is
	## shown and never turned into a requirement.
	var top: int = INT64_MAX
	var bottom: int = INT64_MIN
	_expect(top + 1 == INT64_MIN, "adding past the top does not wrap here")
	_expect(bottom - 1 == INT64_MAX, "subtracting past the bottom does not wrap here")
	var wrap_steps: int = int(WRAP_LEVELS[0][0]) - 1
	var wrapped_product: int = wrap_steps * ADJACENT_STEP
	_expect(wrapped_product == FIRST_WRAPPED_PRODUCT,
		"the product at the first wrap level is %d here, not %d" % [wrapped_product, FIRST_WRAPPED_PRODUCT])

	## AND A CHECK MADE ON THE RESULT COULD NOT HAVE CAUGHT IT. The requirement
	## wrapping arithmetic would report is a perfectly coherent-looking answer: the
	## reading's own shape check accepts it. Only a guard that runs first refuses.
	for row: Array in WRAP_LEVELS:
		var level: int = int(row[0])
		var would_report: int = int(row[1])
		var disguised: RiftLevelRequirementReading = RiftLevelRequirementReading.measured(
			level, would_report)
		_expect(disguised.problem().is_empty(),
			"the shape check objects to %d for level %d, so this row proves less than it says"
				% [would_report, level])
		var answered: RiftLevelRequirementReading = _ask(level)
		_expect(not answered.ok and answered.requirement == 0,
			"level %d answered %d — the wrapped value got through" % [level, answered.requirement])

	## THE STRUCTURAL HALF: in the one function that computes, each operation sits
	## after its own guard, each guard returns a refusal, and the formula's one
	## multiplication and one addition appear exactly once.
	var raw: String = FileAccess.get_file_as_string(CURVE_FILE)
	var body: PackedStringArray = _function_body(raw, "static func requirement_for(")
	_expect(body.size() > 5, "the requirement function body was not found")
	var floor_guard: int = _line_index(body, "if level < FIRST_LEVEL:")
	var subtraction: int = _line_index(body, "level - FIRST_LEVEL")
	var product_guard: int = _line_index(body, "if steps > ")
	var product: int = _line_index(body, "*")
	var sum_guard: int = _line_index(body, "if growth > ")
	var sum: int = _line_index(body, " + ")
	var order: Array[int] = [floor_guard, subtraction, product_guard, product, sum_guard, sum]
	var ordered: bool = not order.has(-1)
	for index: int in range(1, order.size()):
		if order[index] <= order[index - 1]:
			ordered = false
	_expect(ordered,
		"the guard and operation lines are out of order or missing: %s" % str(order))
	for guard: int in [floor_guard, product_guard, sum_guard]:
		_expect(guard >= 0 and guard + 1 < body.size()
				and body[guard + 1].strip_edges().begins_with("return RiftLevelRequirementReading.refused("),
			"the guard at body line %d does not refuse on the line after it" % guard)
	_expect(_lines_containing(body, "*") == 1,
		"the requirement function multiplies on %d lines, not 1" % _lines_containing(body, "*"))
	_expect(_lines_containing(body, " + ") == 1,
		"the requirement function adds on %d lines, not 1" % _lines_containing(body, " + "))
	## ONE FORMULA IN PRODUCTION: the curve's only multiplication is that one, and
	## the result type does no multiplication or addition at all.
	var curve_code: String = _code_only(raw)
	_expect(curve_code.count("*") == 1,
		"the curve's code multiplies %d times, not once" % curve_code.count("*"))
	var reading_code: String = _code_only(FileAccess.get_file_as_string(READING_FILE))
	_expect(not reading_code.contains("*") and not reading_code.contains(" + "),
		"the result type multiplies or adds")

	print("  the engine wraps: %d x 25 = %d; %d wrap-around levels that a result check would accept were refused by guards that run first"
		% [wrap_steps, wrapped_product, WRAP_LEVELS.size()])
	print("  floor guard, subtraction, product guard, product, sum guard, sum at body lines %s; 1 multiplication and 1 addition in production"
		% str(order))
	_done("every_operation_is_guarded_before_it_runs")


# --- 14. Unwired, and E1 and E2 untouched ----------------------------------------------

func _check_nothing_calls_the_curve() -> void:
	print("")
	print("--- 14. Nothing calls the curve; E1 and E2 still take a supplied requirement")
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if G1_FILES.has(path):
				continue
			project_files += 1
			var source: String = FileAccess.get_file_as_string(path)
			for name: String in G1_CLASSES:
				if source.contains(name) and not _reader_may_name(path, name):
					referenced.append("%s names %s" % [path.get_file(), name])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for name: String in G1_CLASSES:
		if settings.contains(name):
			referenced.append("project.godot names %s" % name)
	_expect(referenced.is_empty(),
		"Foundation G1 is referenced by code that runs: %s" % ", ".join(referenced))
	_expect(project_files > 100,
		"only %d project files were scanned, so the scan proves nothing" % project_files)
	_expect(_files_under("res://addons", [".gd"]).size() > 0,
		"the addons root held no script, so widening the scan proved nothing")
	_expect(not settings.contains("[autoload]"), "project.godot declares an [autoload] section")
	## THE SCAN CAN FIND WHAT IT LOOKS FOR: the curve itself names the reading.
	_expect(FileAccess.get_file_as_string(CURVE_FILE).contains("RiftLevelRequirementReading"),
		"the curve does not name the reading, so the scan is untested")

	## E1 AND E2 ARE UNCHANGED IN THE WAY THAT MATTERS HERE: every requirement-taking
	## member is still there, still takes a plain number from its caller, and none
	## of the four files names anything this foundation introduced.
	var e1_signatures: PackedStringArray = _signatures_of(E1_TRACK_FILE)
	var missing: PackedStringArray = PackedStringArray()
	for signature: String in E1_REQUIREMENT_SIGNATURES:
		if not e1_signatures.has(signature):
			missing.append(signature)
	_expect(missing.is_empty(), "E1 no longer declares: %s" % ", ".join(missing))
	var e2_signatures: PackedStringArray = _signatures_of(E2_COORDINATOR_FILE)
	_expect(e2_signatures.has("reading_for(requirement: float) -> Object"),
		"E2 no longer reads a supplied requirement")
	var opens_with_requirement: bool = false
	for signature: String in e2_signatures:
		if signature.begins_with("open_offer(requirement: float, "):
			opens_with_requirement = true
	_expect(opens_with_requirement, "E2 no longer opens an offer against a supplied requirement")
	var carried: PackedStringArray = PackedStringArray()
	for path: String in [E1_TRACK_FILE, E1_READING_FILE, E2_COORDINATOR_FILE, E2_RESULT_FILE]:
		var source: String = FileAccess.get_file_as_string(path)
		_expect(source.length() > 1000, "%s could not be read" % path.get_file())
		for name: String in G1_NAMES_E1_E2_MUST_NOT_CARRY:
			if source.contains(name):
				carried.append("%s names %s" % [path.get_file(), name])
	_expect(carried.is_empty(), "an accepted foundation names G1: %s" % ", ".join(carried))

	print("  %d project files scanned" % project_files)
	print("  no scanned file outside the G4 grant and the experience collection review's grant, and not project.godot, names a G1 class; E1 keeps its %d requirement-taking members and E2 its 2; 4 accepted files name nothing G1 introduced"
		% E1_REQUIREMENT_SIGNATURES.size())
	_done("nothing_calls_the_curve_and_e1_e2_still_take_supplied_requirements")


## Whether `path` is an authorized reader that is granted `name` (D-269). Per file
## AND per class, so the one listed file is still refused any class it is not
## granted.
func _reader_may_name(path: String, name: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) == path:
			return (row[1] as Array).has(name)
	return false


# --- 15. No maximum, no table, no seed, no loop ----------------------------------------

func _check_no_maximum_no_table_no_seed_no_loop() -> void:
	print("")
	print("--- 15. No level maximum, cumulative table, seed derivation or loop was introduced")
	var forbidden_total: int = 0
	var ambient_total: int = 0
	var deferred_total: int = 0
	for path: String in G1_FILES:
		var raw: String = FileAccess.get_file_as_string(path)
		_expect(raw.length() > 1000,
			"%s read as %d characters, so these scans prove nothing" % [path.get_file(), raw.length()])
		var code: String = _code_only(raw)
		_expect(code.length() > 300 and code.length() < raw.length(),
			"%s: comment stripping produced %d characters from %d" % [
				path.get_file(), code.length(), raw.length(),
			])

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
		_expect(deferred.is_empty(),
			"%s carries deferred members: %s" % [path.get_file(), ", ".join(deferred)])

		## NO LOOP OF ANY KIND: one call answers one level, and a loop is the shape a
		## cumulative total, a table or a run of level-ups would arrive in.
		var loops: PackedStringArray = PackedStringArray()
		for line: String in code.split("\n"):
			var stripped: String = line.strip_edges()
			if stripped.begins_with("for ") or stripped.begins_with("while "):
				loops.append(stripped)
		_expect(loops.is_empty(), "%s loops: %s" % [path.get_file(), " | ".join(loops)])

		## NO FLOATING-POINT LITERAL AT ALL: the arithmetic is whole-number throughout,
		## and the one conversion is written as a conversion.
		var floats: PackedStringArray = _float_literals(code)
		_expect(floats.is_empty(),
			"%s carries floating-point literal(s): %s" % [path.get_file(), ", ".join(floats)])

	## THE ONLY WHOLE NUMBERS ARE THE ONES THE REVIEW FORMULA AND THE REPRESENTATION
	## ARE WRITTEN IN.
	var curve_integers: PackedStringArray = _integer_literals(
		_code_only(FileAccess.get_file_as_string(CURVE_FILE)))
	_expect(", ".join(curve_integers) == ", ".join(EXPECTED_CURVE_INTEGERS),
		"the curve's code holds the whole numbers: %s" % ", ".join(curve_integers))
	var reading_integers: PackedStringArray = _integer_literals(
		_code_only(FileAccess.get_file_as_string(READING_FILE)))
	_expect(", ".join(reading_integers) == ", ".join(EXPECTED_READING_INTEGERS),
		"the reading's code holds the whole numbers: %s" % ", ".join(reading_integers))
	_expect(RiftLevelRequirementCurve.FIRST_LEVEL == 1
			and RiftLevelRequirementCurve.BASE_REQUIREMENT == 100
			and RiftLevelRequirementCurve.REQUIREMENT_STEP == 25,
		"the review formula's constants moved")

	## THE SCANS CAN FAIL: they find their own tokens where those tokens legitimately
	## live, in this file, and the word matcher is proved in both directions.
	var self_source: String = FileAccess.get_file_as_string(
		"res://tests/rift_level_requirement_curve_verification.gd")
	var found_here: int = 0
	for token: String in FORBIDDEN_TOKENS:
		if self_source.contains(token):
			found_here += 1
	_expect(found_here == FORBIDDEN_TOKENS.size(),
		"the forbidden-token scan found %d of its %d tokens in this file" % [
			found_here, FORBIDDEN_TOKENS.size(),
		])
	_expect(_names_deferred_member("var cumulative_total: int = 0", "total"),
		"the word matcher no longer catches a member named for a cumulative total")
	_expect(not _names_deferred_member("the largest supported level", "support"),
		"the word matcher fires on the sentence that names the supported level")
	_expect(_names_deferred_member("static func seed_for(level: int) -> int:", "seed"),
		"the word matcher no longer catches a seed derivation")
	_expect(not _names_deferred_member("var requirement: int", "ui"),
		"the word matcher fires on a word that merely contains a token")
	_expect(_integer_literals("const LEVEL_CAP_ZZ: int = 50").has("50"),
		"the whole-number scan no longer finds a typed cap")
	_expect(_float_literals("return 1.5").has("1.5"),
		"the floating-point scan no longer finds a literal")

	## A PER-FILE ALLOWLIST OF PROJECT CLASSES, taken from the engine's own list.
	var all_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var class_id: String = String(entry.get("class", ""))
		if not class_id.is_empty():
			all_classes.append(class_id)
	_expect(all_classes.size() > 20,
		"only %d project classes were enumerated; the allowlist may be inert" % all_classes.size())
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
		_expect(unearned.is_empty(),
			"%s is granted but does not name: %s" % [path.get_file(), ", ".join(unearned)])

	## THE SIGNATURE, CONSTANT AND FIELD PINS. A cumulative table, a seed derivation,
	## a multiple-level step or a cap arrives as an extra method or constant with a
	## plausible name rather than as a forbidden token — and no method here takes or
	## returns anything that could carry a seed, a list of levels or a total.
	_expect(", ".join(_signatures_of(CURVE_FILE)) == ", ".join(EXPECTED_CURVE_SIGNATURES),
		"the curve declares: %s" % ", ".join(_signatures_of(CURVE_FILE)))
	_expect(", ".join(_signatures_of(READING_FILE)) == ", ".join(EXPECTED_READING_SIGNATURES),
		"the reading declares: %s" % ", ".join(_signatures_of(READING_FILE)))
	var curve_constants: PackedStringArray = _constants_of(CURVE_FILE)
	_expect(", ".join(curve_constants) == ", ".join(EXPECTED_CURVE_CONSTANTS),
		"the curve declares the constants: %s" % ", ".join(curve_constants))
	var reading_constants: PackedStringArray = _constants_of(READING_FILE)
	_expect(", ".join(reading_constants) == ", ".join(EXPECTED_READING_CONSTANTS),
		"the reading declares the constants: %s" % ", ".join(reading_constants))

	## AND BEHAVIOURALLY, THERE IS NO DESIGNED MAXIMUM: levels far past anything a
	## run could reach all answer, and the only refusals above Level 1 are the
	## representation refusals proved in check 11.
	var far: PackedStringArray = PackedStringArray()
	for row: Array in FAR_SAMPLE:
		var level: int = int(row[0])
		var reading: RiftLevelRequirementReading = _ask(level)
		_expect_success(reading, level, int(row[1]), float(int(row[1])), "level %d" % level)
		far.append("%d -> %d" % [level, reading.requirement])

	print("  2 scripts scanned: %d forbidden tokens, %d ambient reads, %d deferred members, 0 loops, 0 float literals"
		% [forbidden_total, ambient_total, deferred_total])
	print("  whole numbers: curve %s, reading %s; %d signatures, %d constants and %d fields pinned"
		% [", ".join(curve_integers), ", ".join(reading_integers),
			EXPECTED_CURVE_SIGNATURES.size() + EXPECTED_READING_SIGNATURES.size(),
			curve_constants.size() + reading_constants.size(), EXPECTED_READING_FIELDS.size()])
	print("  no designed maximum: %s" % ", ".join(far))
	print("  %d successes and %d refusals were driven across this suite" % [_successes, _refusals])
	_done("no_maximum_no_cumulative_table_no_seed_and_no_loop")


# --- 16. A refused conversion fails safe ------------------------------------------

func _check_a_refused_conversion_fails_safe() -> void:
	print("")
	print("--- 16. A refused conversion fails safe: stored zero, converted positive infinity")

	## EVERY ROUTE BY WHICH A REFUSAL ARISES: the floor, the addition guard, the
	## multiplication guard, the wrap-around levels and the top of the integer
	## range through the curve, and the refusal constructor directly — with a
	## stated reason and with a blank one.
	var refusals: Array[RiftLevelRequirementReading] = []
	for level: int in BELOW_ONE:
		refusals.append(_ask(level))
	for level: int in range(FIRST_UNSUPPORTED_LEVEL, LAST_ADDITION_GUARD_LEVEL + 1):
		refusals.append(_ask(level))
	refusals.append(_ask(FIRST_MULTIPLICATION_GUARD_LEVEL))
	for row: Array in WRAP_LEVELS:
		refusals.append(_ask(int(row[0])))
	refusals.append(_ask(INT64_MAX))
	refusals.append(RiftLevelRequirementReading.refused(5, "zz a refusal built directly"))
	refusals.append(RiftLevelRequirementReading.refused(5, "  "))
	_expect(refusals.size() == 17, "the refusal corpus holds %d readings, not 17" % refusals.size())

	## PROOFS 1 AND 2: every refusal STORES zero and CONVERTS to positive infinity,
	## and each wrong conversion is counted under its own name.
	var accepted: int = 0
	var stored_nonzero: int = 0
	var as_positive_infinity: int = 0
	var as_zero: int = 0
	var as_negative_infinity: int = 0
	var as_nan: int = 0
	var as_finite: int = 0
	for reading: RiftLevelRequirementReading in refusals:
		if reading.ok:
			accepted += 1
		if reading.requirement != 0:
			stored_nonzero += 1
		var converted: float = reading.experience_requirement()
		if is_nan(converted):
			as_nan += 1
		elif converted == 0.0:
			as_zero += 1
		elif is_inf(converted) and converted < 0.0:
			as_negative_infinity += 1
		elif is_inf(converted):
			as_positive_infinity += 1
		else:
			as_finite += 1
	_expect(accepted == 0, "%d readings in the refusal corpus were accepted" % accepted)
	_expect(stored_nonzero == 0, "%d refusals stored a requirement other than 0" % stored_nonzero)
	_expect(as_positive_infinity == refusals.size(),
		"%d of %d refusals converted to positive infinity" % [as_positive_infinity, refusals.size()])
	_expect(as_zero == 0, "%d refusals converted to zero" % as_zero)
	_expect(as_negative_infinity == 0, "%d refusals converted to negative infinity" % as_negative_infinity)
	_expect(as_nan == 0, "%d refusals converted to NaN" % as_nan)
	_expect(as_finite == 0, "%d refusals converted to a finite number" % as_finite)

	## THE CONVERSION ANSWERS FROM `ok` ALONE. A refusal whose stored requirement
	## has been tampered to look usable still converts to positive infinity, so no
	## stray stored value can leak out through the conversion.
	var tampered: RiftLevelRequirementReading = RiftLevelRequirementReading.refused(1, "zz tampered")
	tampered.requirement = LEVEL_ONE_REQUIREMENT
	var tampered_converted: float = tampered.experience_requirement()
	_expect(is_inf(tampered_converted) and tampered_converted > 0.0,
		"a refusal tampered to store %d converted to %s" % [
			LEVEL_ONE_REQUIREMENT, _exact(tampered_converted),
		])

	## PROOF 3: THE CARELESS COMPARISON. Finite progress values — zero, fractions,
	## the review values, the boundary requirement, the top of the integer range and
	## the largest finite double — never satisfy `progress >= converted`.
	var probes: Array[float] = []
	probes.append_array(FINITE_PROGRESS_PROBES)
	probes.append(float(EXPECTED_MAX_REQUIREMENT))
	probes.append(float(INT64_MAX))
	var largest_finite: float = pow(2.0, 1023.0) * (2.0 - pow(2.0, -52.0))
	probes.append(largest_finite)
	var not_finite: int = 0
	for probe: float in probes:
		if not is_finite(probe):
			not_finite += 1
	_expect(not_finite == 0, "%d progress probes are not finite, so they prove nothing" % not_finite)
	_expect(is_inf(largest_finite * 2.0),
		"the largest probe is not the largest finite double")
	var comparisons: int = 0
	var satisfied: int = 0
	for reading: RiftLevelRequirementReading in refusals:
		var converted: float = reading.experience_requirement()
		for probe: float in probes:
			comparisons += 1
			if probe >= converted:
				satisfied += 1
	_expect(comparisons == refusals.size() * probes.size(),
		"%d careless comparisons were made, not %d" % [comparisons, refusals.size() * probes.size()])
	_expect(satisfied == 0,
		"%d careless comparisons read a refusal as already satisfied" % satisfied)
	## AND WHY ZERO WAS UNSAFE, shown on the same probes rather than argued: the
	## same careless comparison against a zero conversion is satisfied by every
	## probe that is not negative — including the 0.0 a new track holds.
	var satisfied_by_zero: int = 0
	var negatives: int = 0
	for probe: float in probes:
		if probe < 0.0:
			negatives += 1
		if probe >= 0.0:
			satisfied_by_zero += 1
	_expect(negatives == 2 and satisfied_by_zero == probes.size() - negatives,
		"a zero conversion would be satisfied by %d of %d probes" % [satisfied_by_zero, probes.size()])

	## PROOF 4: HANDED TO THE ACCEPTED TRACK, the conversion is refused at every
	## route that takes a requirement, and no level or progress moves — on a new
	## track, on one holding progress, on one holding an enormous finite amount, and
	## on one that has already gained a level.
	var gained: RiftExperienceTrack = _track_holding(MORE_THAN_ENOUGH)
	_expect_accepted(gained.advance_one_level(LEVEL_ONE_AS_EXPERIENCE), "the Level 2 fixture's advance")
	var tracks: Array[RiftExperienceTrack] = [
		RiftExperienceTrack.new(), _track_holding(SHORT_OF_IT), _track_holding(1.0e300), gained,
	]
	var sources: Array[RiftLevelRequirementReading] = [
		_ask(0), _ask(FIRST_UNSUPPORTED_LEVEL), _ask(INT64_MAX),
	]
	var handed: int = 0
	var moved: int = 0
	for source: RiftLevelRequirementReading in sources:
		var converted: float = source.experience_requirement()
		_expect(not RiftExperienceTrack.requirement_problem(converted).is_empty(),
			"the accepted track would accept a refused conversion as a requirement")
		for track: RiftExperienceTrack in tracks:
			handed += 1
			var before: String = _track_line(track)
			var reading: RiftExperienceReading = track.reading_for(converted)
			_expect(not reading.ok and not reading.ready
					and not reading.failure_reason.strip_edges().is_empty(),
				"the accepted track read a refused conversion as: %s" % reading.describe())
			_expect(not track.is_ready(converted),
				"the accepted track reports ready against a refused conversion")
			var left: float = track.remaining(converted)
			_expect(is_inf(left) and left > 0.0,
				"the accepted track reports %s remaining against a refused conversion" % _exact(left))
			_expect(not track.advance_one_level(converted).is_empty(),
				"the accepted track advanced against a refused conversion")
			if _track_line(track) != before:
				moved += 1
				_expect(false, "a refused conversion moved the track from %s to %s" % [
					before, _track_line(track),
				])
	_expect(handed == sources.size() * tracks.size(),
		"%d hand-overs were made, not %d" % [handed, sources.size() * tracks.size()])
	_expect(moved == 0, "%d hand-overs moved the track" % moved)

	print("  %d refusals from the floor, both guards and the constructor: every one stored 0 and converted to positive infinity; 0 to zero, 0 to negative infinity, 0 to NaN, 0 finite"
		% refusals.size())
	print("  %d careless comparisons against %d finite progress values up to the largest finite double: 0 satisfied; a zero conversion would have satisfied %d of the %d"
		% [comparisons, probes.size(), satisfied_by_zero, probes.size()])
	print("  %d refused conversions handed to %d accepted tracks: every reading, readiness, remaining and advance refused; 0 tracks moved"
		% [handed, tracks.size()])
	_done("a_refused_conversion_fails_safe")


# --- 17. Every successful conversion is exact --------------------------------------

func _check_every_successful_conversion_is_exact() -> void:
	print("")
	print("--- 17. Every successful conversion is finite, positive and bit-identical to its whole number")
	var levels: Array[int] = []
	for offset: int in WINDOW_SIZE:
		levels.append(LOW_WINDOW_FIRST + offset)
		levels.append(HIGH_WINDOW_FIRST + offset)
	for row: Array in NAMED_EXAMPLES:
		levels.append(int(row[0]))
	for row: Array in FAR_SAMPLE:
		levels.append(int(row[0]))

	var converted_count: int = 0
	var refused: int = 0
	var not_finite: int = 0
	var not_positive: int = 0
	var not_bit_identical: int = 0
	var not_round_trip: int = 0
	for level: int in levels:
		var reading: RiftLevelRequirementReading = _ask(level)
		if not reading.ok:
			refused += 1
			continue
		converted_count += 1
		var converted: float = reading.experience_requirement()
		if not is_finite(converted):
			not_finite += 1
		if converted <= 0.0:
			not_positive += 1
		if _double_bytes(converted) != _double_bytes(float(reading.requirement)):
			not_bit_identical += 1
		if int(converted) != reading.requirement:
			not_round_trip += 1
	_expect(refused == 0, "%d of the examined levels were refused" % refused)
	_expect(converted_count == levels.size(),
		"%d of %d levels were converted" % [converted_count, levels.size()])
	_expect(not_finite == 0, "%d successful conversions were not finite" % not_finite)
	_expect(not_positive == 0, "%d successful conversions were not positive" % not_positive)
	_expect(not_bit_identical == 0,
		"%d successful conversions were not bit-identical to their whole number" % not_bit_identical)
	_expect(not_round_trip == 0,
		"%d successful conversions did not round-trip to their whole number" % not_round_trip)

	## AND AGAINST INDEPENDENT EXPECTATIONS, BYTE FOR BYTE: the named examples'
	## typed doubles, and the boundary's exact whole-number literal converted.
	var matched: int = 0
	for row: Array in NAMED_EXAMPLES:
		if _double_bytes(_ask(int(row[0])).experience_requirement()) == _double_bytes(float(row[2])):
			matched += 1
	_expect(matched == NAMED_EXAMPLES.size(),
		"%d of %d named examples converted byte for byte to their typed double"
			% [matched, NAMED_EXAMPLES.size()])
	_expect(_double_bytes(_ask(EXPECTED_MAX_LEVEL).experience_requirement())
			== _double_bytes(float(EXPECTED_MAX_REQUIREMENT)),
		"the boundary's conversion is not the exact whole number's double")

	print("  %d successful conversions: every one finite, positive and byte-identical to its exact whole number; %d named examples and the boundary match independent expectations byte for byte"
		% [converted_count, matched])
	_done("every_successful_conversion_is_finite_positive_and_exact")


# --- Fixtures and helpers ----------------------------------------------------------

## A new accepted track holding `amount` of effective experience, awarded with no
## modifier. Used only to measure how that track treats a supplied requirement.
func _track_holding(amount: float) -> RiftExperienceTrack:
	var track: RiftExperienceTrack = RiftExperienceTrack.new()
	_expect_accepted(track.award(amount, PlayerStatTotals.new()),
		"a track award of %s" % _exact(amount))
	return track


func _track_line(track: RiftExperienceTrack) -> String:
	return "level=%d progress=%s" % [track.level(), _exact(track.progress())]

func _ask(level: int) -> RiftLevelRequirementReading:
	return RiftLevelRequirementCurve.requirement_for(level)


## The levels checks 6 and 7 ask about: the named examples, both edges of the
## boundary, both refusal routes, the wrap-around levels and the far sample.
func _sample_levels() -> Array[int]:
	var levels: Array[int] = []
	for row: Array in NAMED_EXAMPLES:
		levels.append(int(row[0]))
	for row: Array in FAR_SAMPLE:
		levels.append(int(row[0]))
	levels.append_array([
		EXPECTED_MAX_LEVEL - 1, EXPECTED_MAX_LEVEL, FIRST_UNSUPPORTED_LEVEL,
		FIRST_MULTIPLICATION_GUARD_LEVEL, INT64_MAX, 0, -1, INT64_MIN,
	])
	for row: Array in WRAP_LEVELS:
		levels.append(int(row[0]))
	return levels


# --- Assertions --------------------------------------------------------------------

func _expect_accepted(refusal: String, described: String) -> void:
	_expect(refusal.is_empty(), "%s was refused: %s" % [described, refusal])


## One success, counted, with every field checked against an independent
## expectation — including the conversion, against a typed double.
func _expect_success(
	reading: RiftLevelRequirementReading,
	level: int,
	requirement: int,
	experience: float,
	described: String
) -> void:
	_successes += 1
	_expect(reading != null, "%s returned nothing" % described)
	if reading == null:
		return
	_expect(reading.ok, "%s was refused: %s" % [described, reading.failure_reason])
	_expect(reading.failure_reason.is_empty(),
		"%s succeeded with a reason: %s" % [described, reading.failure_reason])
	_expect(reading.level == level, "%s answered for level %d" % [described, reading.level])
	_expect(reading.requirement == requirement,
		"%s requires %d, not %d" % [described, reading.requirement, requirement])
	_expect(reading.experience_requirement() == experience,
		"%s converts to %s, not %s" % [
			described, _exact(reading.experience_requirement()), _exact(experience),
		])
	_expect(reading.problem().is_empty(), "%s is incoherent: %s" % [described, reading.problem()])


## One refusal, counted, checked for everything a refusal owes: the question kept,
## a stated reason, and no usable requirement in either form.
func _expect_refusal(reading: RiftLevelRequirementReading, level: int, described: String) -> void:
	_refusals += 1
	_expect(reading != null, "%s returned nothing" % described)
	if reading == null:
		return
	_expect(not reading.ok, "%s was accepted with %d" % [described, reading.requirement])
	_expect(not reading.failure_reason.strip_edges().is_empty(),
		"%s was refused without a reason" % described)
	_expect(reading.level == level,
		"%s was recorded as level %d" % [described, reading.level])
	## STORED ZERO, CONVERTED POSITIVE INFINITY (D-263): the two halves of one
	## refusal, asserted separately because they are deliberately different.
	_expect(reading.requirement == 0,
		"%s stored the partial requirement %d" % [described, reading.requirement])
	var converted: float = reading.experience_requirement()
	_expect(is_inf(converted) and converted > 0.0,
		"%s converted to %s, not positive infinity" % [described, _exact(converted)])
	_expect(reading.problem().is_empty(), "%s is incoherent: %s" % [described, reading.problem()])


# --- Formatting --------------------------------------------------------------------

## The COMPLETE reading as one line, with the conversion as its exact eight bytes,
## so that "the same" means bit-identical rather than equal to display precision.
func _bits(reading: RiftLevelRequirementReading) -> String:
	if reading == null:
		return "no reading"
	return "ok=%s level=%d requirement=%d experience=%s reason=%s" % [
		str(reading.ok), reading.level, reading.requirement,
		_double_bytes(reading.experience_requirement()),
		reading.failure_reason,
	]


## A double as its exact eight bytes, so two values are compared bit for bit
## rather than to display precision.
func _double_bytes(value: float) -> String:
	return PackedFloat64Array([value]).to_byte_array().hex_encode()


func _exact(value: float) -> String:
	return String.num(value, 1)


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


## Every distinct standalone whole-number literal in `code`, sorted: a run of
## digits that is not part of an identifier and not part of a decimal.
func _integer_literals(code: String) -> PackedStringArray:
	var found: Dictionary = {}
	var index: int = 0
	while index < code.length():
		if not _is_digit(code[index]):
			index += 1
			continue
		var start: int = index
		while index < code.length() and _is_digit(code[index]):
			index += 1
		var before_ok: bool = start == 0 or not _is_identifier_character(code[start - 1])
		var after_ok: bool = index >= code.length() \
			or (not _is_identifier_character(code[index]) and code[index] != ".")
		if before_ok and after_ok:
			found[code.substr(start, index - start)] = true
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
			args.append("%s: %s" % [
				String(argument.get("name", "")),
				_type_name(int(argument.get("type", 0))),
			])
		var returns: Dictionary = entry.get("return", {}) as Dictionary
		out.append("%s(%s) -> %s" % [
			String(entry.get("name", "")), ", ".join(args),
			_type_name(int(returns.get("type", 0))),
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
