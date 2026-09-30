extends SceneTree
## Riftwrought — Roguelite Foundation E1 verification: the temporary Rift
## experience track.
##
## ONE FOCUSED HEADLESS TEST. The foundation is two pure-logic scripts under
## `scripts/experience/`, so it needs no scene, no camera, no navigation, no
## rendering and no evidence frame, and it deliberately gets none. It runs as a
## `SceneTree` script exactly as all eight earlier foundations' suites do.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## EVERY ATOMICITY PROOF COMPARES THE WHOLE TRACK. A complete snapshot — the
## level and the progress to seventeen significant digits — is taken immediately
## before each attempt and compared afterwards. Checking only the number the
## operation was about is how a partial mutation survives a green suite.
##
## THE TRACK IS SEEDED BEFORE EVERY ATOMICITY PROOF, ON PURPOSE. "Nothing
## changed" is nearly free to satisfy on a track that has never been touched; it
## is a real claim only when there is something there to disturb.
##
## AND ITS DECIMAL EXPECTATIONS ARE DERIVED, NOT TYPED, WHEREVER THE BINARY
## RESULT IS NOT THE DECIMAL. This is the single sharpest thing in this suite.
## Of the numbers the brief names — 25, 27.5, 52.5, 0 and 2.5 — FOUR are exactly
## representable outcomes of this arithmetic and are asserted with `==` against
## typed constants. **`27.5` is not one of them.** Twenty-five at the shipped
## +10% is `27.50000000000000355`, because the double nearest 1.1 is a little
## above 1.1; a check that typed `27.5` there would fail for a reason that has
## nothing to do with this track. So that one value is asserted against the
## ACCEPTED calculation path's own answer, bit for bit, and is separately shown
## to be 27.5 to display precision and NOT to be the typed double 27.5 — because
## a reviewer needs to see both halves of that to trust either.

# --- The two scripts this foundation owns ---------------------------------------

const TRACK_FILE: String = "res://scripts/experience/rift_experience_track.gd"
const READING_FILE: String = "res://scripts/experience/rift_experience_reading.gd"

const E1_FILES: Array[String] = [
	"res://scripts/experience/rift_experience_track.gd",
	"res://scripts/experience/rift_experience_reading.gd",
]

## The two global class names this foundation introduces. NOTHING that runs may
## reference either of them: E1 accumulates experience and is deliberately
## unwired — no source, no curve, no offer, no UI, no scene, no persistence.
const E1_CLASSES: Array[String] = [
	"RiftExperienceTrack", "RiftExperienceReading",
]

## `scripts/experience/` after Foundation H1 (D-271): E1's two scripts and the
## Experience Mote, which shares the directory and names neither E1 class.
## D-281: Foundation H6's enemy mote emission shares it too, and names neither.
## D-283: so does Foundation H7's Graveblade mote binding, which names neither.
## D-286: and so does Foundation H8's Experience Mote runtime, which names neither.
const EXPERIENCE_DIRECTORY_SCRIPTS: Array[String] = [
	"res://scripts/experience/rift_experience_track.gd",
	"res://scripts/experience/rift_experience_reading.gd",
	"res://scripts/experience/rift_experience_mote.gd",
	"res://scripts/experience/rift_enemy_mote_emission.gd",
	"res://scripts/experience/rift_graveblade_mote_binding.gd",
	"res://scripts/experience/rift_mote_runtime.gd",
]

## THE FILES AUTHORIZED TO NAME A FOUNDATION E1 CLASS, AND THE EXACT CLASSES EACH
## MAY NAME (D-248). The Foundation E2 level-up coordinator OWNS one track for
## the lifecycle it coordinates: it forwards every award to it, stages a copy to
## advance, and asks it the one authoritative threshold question — which is why
## it is granted the READING as well as the track. It asks for a reading rather
## than for a bool precisely because it must tell "that is not a requirement"
## from "not yet", which is the distinction that type exists for.
##
## THIS REPLACES D-246's BLANKET "no file that runs may name either class" ONE
## FOR ONE: the same single assertion is made either way, it still fails for any
## other file AND for any class a listed file is not granted, and the pinned
## count does not move.
const AUTHORIZED_READERS: Array = [
	["res://scripts/levels/rift_level_up_coordinator.gd", [
		"RiftExperienceTrack", "RiftExperienceReading",
	]],
	## Foundation G4 (decision D-269): the repeated run-level coordinator asks its
	## current one-level lifecycle for the one authoritative threshold reading
	## against the requirement G1 answered, before it derives a seed or opens an
	## offer — so it names the READING. It holds no track and names none: the level
	## and the experience stay with the lifecycle. Added one for one, and the pinned
	## count does not move.
	["res://scripts/levels/rift_run_level_coordinator.gd", ["RiftExperienceReading"]],
]

## Concrete card, Skill, support and instrument names, the record fields a card
## carries, and the four constants the first-MVP character curve is written in.
## Scanned RAW, comments included — D-215's lesson: an illustrative name in a
## comment breaches the rule just as surely as a real one.
##
## THE CURVE CONSTANTS ARE IN THIS LIST FOR A REASON. "E1 owns no level curve" is
## the easiest promise in this foundation to break by accident, because the
## project already has a curve and copying one of its numbers in as a default
## would look like helpfulness rather than like a balance decision.
const FORBIDDEN_TOKENS: Array[String] = [
	"card_power", "card_celerity", "card_vitality",
	"card_fleetness", "card_insight", "card_magnetism",
	"Celerity", "Vitality", "Fleetness", "Insight", "Magnetism",
	"display_name", "base_weight", "repeatable", "magnitude",
	"QuickStrike", "quick_strike", "Quick Strike",
	"reaching_edge", "Reaching Edge", "sweeping_edge", "Sweeping Edge",
	"Faultbreaker", "Splinter Shot", "Emberbolt", "Marrowshot", "Graveblade",
	"Expedition Blade", "Quickened Edge", "Quickened Form", "Riftmarked",
	"PrototypePlayer", "PrototypeWeaponData", "PrototypeGraveblade",
	"PassiveEffects", "PassiveGraph", "PassiveNodeData", "PassiveAllocation",
	"RogueliteUpgrade", "RogueliteRunBoon", "RogueliteBuildState", "RogueliteRunPlan",
	"SkillSupportCatalogue", "SkillTags", "SupportEligibility", "SkillTagProfile",
	"SupportDefinition", "SupportSelection", "SupportSelectionResult",
	"PassiveCardCatalogue", "PassiveCardDefinition",
	"PassiveCardSelection", "PassiveCardSelectionResult",
	"PlayerStatDefinition", "AcquiredSupports",
	"RiftOffer", "RiftOfferComposition", "RiftRunBuild", "RiftConsumptionLedger",
	"FirstMvpSkill", "CharacterState", "ExperienceTable", "PlayerLoadout",
	"TOTAL_FOR_LEVEL", "MAX_DEFINED_LEVEL", "POINTS_PER_LEVEL", "GRAVEBLADE_EXPERIENCE",
]

## A pure value may read no ambient state whatsoever.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
]

## THE SYSTEMS THIS FOUNDATION DEFERS, AS MEMBER-NAME TOKENS.
##
## SCANNED OVER CODE LINES ONLY, AND THE REASON IS A DEFECT GATE 1C ALREADY
## FOUND: a guard whose token is too crude fires on the sentence that makes the
## claim. Both files say in plain English that they hold no curve, spawn no
## pickup, resolve no offer and have no reset or persistence — so a raw scan for
## those words would be red on exactly the files that promise none of them. The
## concrete-name scan above stays RAW, where the opposite rule applies.
##
## `experience`, `level`, `progress`, `requirement`, `award` and `remaining` are
## absent from this list on purpose: they are this foundation's own vocabulary
## rather than a deferred system's, which is the difference between D3's list and
## this one and the reason the two could not simply be copied across.
const DEFERRED_MEMBER_TOKENS: Array[String] = [
	"mote", "pickup", "spawn", "collect", "radius",
	"curve", "table", "threshold_for", "requirement_for",
	"card", "offer", "lane", "seed", "choice", "weight", "support",
	"save", "persist", "storage", "schema", "migrat",
	"reset", "clear", "death", "abandon", "nexus",
	"apply", "actor", "base_value", "current_life", "maximum_life",
	"input", "controller", "viewport", "canvas", "pause",
	"skip", "ban", "lock", "luck", "rank", "rarity", "pity", "affix", "reroll",
]

## THE SHORT TOKENS ABOVE ARE MATCHED AS IDENTIFIER WORDS RATHER THAN AS BARE
## SUBSTRINGS, PORTED FROM D-244 WITH ITS REASON INTACT. A letter or a digit on
## either side is a boundary; an UNDERSCORE is not, so `award_mote`,
## `support_rank` and `lock_level` are all still caught while `remote`, `block`
## and `abandon` are not — and `abandon` is in the list above in its own right.
## The matcher is proved in both directions in the last check.
const WORD_MATCHED_TOKENS: Array[String] = [
	"mote", "ban", "lock", "luck", "rank", "skip", "table", "clear",
]

## The only project classes each E1 file may name. An ALLOWLIST derived from the
## engine's own global class list, PER FILE — not a denylist of remembered
## names, and not one shared list, because a shared list would hand the
## accepted calculation's result type to the reading as a side effect of
## granting it to the track.
##
## THE READING IS GRANTED NOTHING BUT ITSELF, AND THAT IS THE POINT OF SPLITTING
## THEM. A threshold measurement needs no stat vocabulary at all; the day it
## names one, it has started deciding something.
const AUTHORIZED_CLASSES: Array = [
	["res://scripts/experience/rift_experience_track.gd", [
		"RiftExperienceTrack", "RiftExperienceReading",
		"PlayerStats", "PlayerStatTotals", "PlayerStatValue",
	]],
	["res://scripts/experience/rift_experience_reading.gd", ["RiftExperienceReading"]],
]

## `res://addons` IS SCANNED TOO. An editor plugin is code that runs; a reference
## from one would load these classes while a scripts/scenes/data scan reported
## nothing. `project.godot` is checked separately, because an `[autoload]` entry
## names a class from a file no extension filter would reach.
const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]

const PROJECT_SETTINGS_FILE: String = "res://project.godot"

## The one accepted suite whose scope assertion E1 moved, the E1 script it must
## now authorize by path, and the exact classes that grant is for. Read from the
## suite's own source: a grant nobody can see is a grant that quietly stops
## meaning anything, and a grant for a class the file no longer names is a claim
## about nothing that still passes.
const AUTHORIZING_SUITES: Array = [
	["res://tests/player_stat_vocabulary_verification.gd", "C1",
		["res://scripts/experience/rift_experience_track.gd"],
		["PlayerStats", "PlayerStatTotals", "PlayerStatValue"]],
]

## THE PROOF A TOKEN SCAN CANNOT GIVE. A level curve, an experience source, an
## offer hook or a persistence step need name nothing forbidden at all — each
## arrives as an extra method with a plausible name. So each script's methods are
## enumerated from the engine and pinned BY NAME, IN ORDER, WITH THEIR FULL
## SIGNATURES — which is the half that proves a card id, a presentation label, an
## offer weight or a run seed cannot reach the arithmetic, because there is no
## argument anywhere of a shape that could carry one.
const EXPECTED_TRACK_SIGNATURES: Array[String] = [
	"level() -> int",
	"progress() -> float",
	"award(base_experience: float, totals: Object) -> String",
	"requirement_problem(requirement: float) -> String",
	"reading_for(requirement: float) -> Object",
	"is_ready(requirement: float) -> bool",
	"remaining(requirement: float) -> float",
	"level_can_increment(level: int) -> bool",
	"advance_one_level(requirement: float) -> String",
	"duplicated() -> Object",
	"describe() -> String",
	"_shown(value: float) -> String",
]

const EXPECTED_READING_SIGNATURES: Array[String] = [
	"failed(reason: String) -> Object",
	"measured(for_requirement: float, for_progress: float, for_ready: bool,"
		+ " for_remaining: float) -> Object",
	"problem() -> String",
	"describe() -> String",
	"_shown(value: float) -> String",
]

## Two fields, both private, and no third. A stored copy of the build's totals
## would arrive here — and it is exactly what would make Experience Gain
## retroactive.
const EXPECTED_TRACK_FIELDS: Array[String] = ["_level", "_progress"]

const EXPECTED_READING_FIELDS: Array[String] = [
	"ok", "failure_reason", "requirement", "progress", "ready", "remaining",
]

# --- The worked example, typed independently -------------------------------------
#
# The base award and the requirement come from the brief. Everything derived
# from them is computed against the ACCEPTED calculation path rather than typed,
# except where the binary result really is the decimal — and which of the two a
# number is was measured before it was written down here.

const BASE_AWARD: float = 25.0

## Exact: a scale of 1.0 leaves any finite base bit-identical.
const UNMODIFIED_TOTAL: float = 25.0

## Exact, and pleasingly so: 25 plus the inexact 27.50000000000000355 rounds to
## precisely 52.5. The summand is not the decimal and the sum is.
const TWO_AWARD_TOTAL: float = 52.5

const FIRST_REQUIREMENT: float = 50.0

## Exact: 52.5 minus 50 leaves precisely 2.5.
const EXPECTED_OVERFLOW: float = 2.5

## The decimal the brief names for one boosted award, which this arithmetic does
## NOT produce. It is here to be REFUTED, never to be asserted.
const MISLEADING_DECIMAL: float = 27.5

## A second, separately supplied requirement — deliberately a different number
## from the first, because a track that quietly remembered the previous one
## would still pass a check that asked twice with the same value.
const SECOND_REQUIREMENT: float = 40.0

## The large-overflow case: one award far past a small requirement.
const LARGE_AWARD: float = 1000.0
const SMALL_REQUIREMENT: float = 10.0
const LARGE_OVERFLOW: float = 990.0

## Two awards of this each are individually finite and jointly are not.
const OVERFLOWING_AWARD: float = 1.7e308

## The seeded state every atomicity proof is made against.
const SEED_AWARD: float = 7.5

const OWED_CHECKS: Array[String] = [
	"a_new_track_is_level_one_with_no_progress",
	"an_unmodified_award_adds_exactly_its_base",
	"experience_gain_is_applied_through_the_accepted_stat_path",
	"experience_gain_is_evaluated_at_award_time_and_is_not_retroactive",
	"a_threshold_reading_answers_ready_and_remaining",
	"advancing_takes_exactly_one_requirement_and_keeps_the_overflow",
	"insufficient_progress_refuses_without_moving_the_track",
	"a_large_overflow_advances_exactly_one_level_per_call",
	"readiness_is_asked_again_against_the_next_supplied_requirement",
	"every_unusable_award_refuses_atomically",
	"an_award_that_would_overflow_the_progress_refuses_atomically",
	"every_invalid_requirement_is_rejected_on_every_route",
	"duplicating_the_track_is_independent_in_both_directions",
	"names_ids_weights_and_seeds_cannot_reach_the_arithmetic",
	"the_track_is_generic_reads_nothing_ambient_and_is_unwired",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0

## The shipped Experience Gain magnitude, found by STAT rather than by card id,
## so this suite does not hard-code which record grants it.
var _shipped_gain: float = 0.0
var _shipped_gain_card: StringName = &""


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation E1 — Temporary Rift Experience Track (D-246) ===")

	if not _load_shipped_experience_gain():
		printerr("  FAIL: no shipped passive card grants Experience Gain")
		printerr("RIFT EXPERIENCE TRACK VERIFICATION: 1 FAILURE(S) of 0 checks")
		quit(1)
		return

	_check_a_new_track_is_level_one_with_no_progress()
	_check_an_unmodified_award_adds_exactly_its_base()
	_check_experience_gain_is_applied_through_the_accepted_stat_path()
	_check_experience_gain_is_not_retroactive()
	_check_a_threshold_reading_answers_ready_and_remaining()
	_check_advancing_takes_exactly_one_requirement()
	_check_insufficient_progress_refuses_without_moving_the_track()
	_check_a_large_overflow_advances_exactly_one_level_per_call()
	_check_readiness_is_asked_again_against_the_next_requirement()
	_check_every_unusable_award_refuses_atomically()
	_check_an_award_that_would_overflow_refuses_atomically()
	_check_every_invalid_requirement_is_rejected_on_every_route()
	_check_duplicating_the_track_is_independent()
	_check_names_ids_weights_and_seeds_cannot_reach_the_arithmetic()
	_check_the_track_is_generic_and_unwired()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT EXPERIENCE TRACK VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT EXPERIENCE TRACK VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. A new track ---------------------------------------------------------------

func _check_a_new_track_is_level_one_with_no_progress() -> void:
	print("")
	print("--- 1. A new track is Level 1 with exactly zero progress")
	var track: RiftExperienceTrack = RiftExperienceTrack.new()

	_expect(track.level() == 1, "a new track is at level %d" % track.level())
	_expect(track.level() == RiftExperienceTrack.STARTING_LEVEL,
		"a new track does not start at its own declared starting level")
	## `==` against the typed zero rather than `is_zero_approx`: a track that
	## began at a value merely close to zero would be a different thing, and a
	## tolerance is exactly what would hide it.
	_expect(track.progress() == 0.0,
		"a new track holds %s progress" % _exact(track.progress()))
	## A reading against a new track needs the WHOLE requirement, which is the
	## same fact stated where a caller would meet it.
	var opening: RiftExperienceReading = track.reading_for(FIRST_REQUIREMENT)
	_expect(opening.ok and not opening.ready,
		"a new track was reported ready for a requirement of 50")
	_expect(opening.remaining == FIRST_REQUIREMENT,
		"a new track reports %s remaining of 50" % _exact(opening.remaining))

	## Two new tracks are the same track and neither is the other.
	var second: RiftExperienceTrack = RiftExperienceTrack.new()
	_expect(_snapshot(second) == _snapshot(track),
		"two new tracks differ: %s against %s" % [_snapshot(second), _snapshot(track)])
	_expect(second != track, "two separately constructed tracks are one object")

	print("  a new track: %s" % _snapshot(track))
	_done("a_new_track_is_level_one_with_no_progress")


# --- 2. An unmodified award --------------------------------------------------------

func _check_an_unmodified_award_adds_exactly_its_base() -> void:
	print("")
	print("--- 2. 25 base experience with no modifier adds exactly 25")
	var track: RiftExperienceTrack = RiftExperienceTrack.new()
	var empty: PlayerStatTotals = PlayerStatTotals.new()

	_expect(empty.is_empty(), "the control accumulator is not empty")
	_expect(empty.total_for(PlayerStats.EXPERIENCE_GAIN) == 0.0,
		"the control accumulator already totals %s"
			% _exact(empty.total_for(PlayerStats.EXPERIENCE_GAIN)))

	_expect_accepted(track.award(BASE_AWARD, empty), "an award of 25 with no modifier")
	## EXACT, not approximate: a scale of exactly 1.0 leaves any finite base
	## bit-identical, so anything but `==` here would be accepting a defect.
	_expect(track.progress() == UNMODIFIED_TOTAL,
		"25 with no modifier came to %s" % _exact(track.progress()))
	_expect(track.level() == 1, "an award moved the level to %d" % track.level())

	## The fraction is kept rather than rounded, which the whole-number example
	## above cannot show on its own.
	var fractional: RiftExperienceTrack = RiftExperienceTrack.new()
	_expect_accepted(fractional.award(SEED_AWARD, empty), "an award of 7.5 with no modifier")
	_expect(fractional.progress() == SEED_AWARD,
		"7.5 was stored as %s" % _exact(fractional.progress()))

	print("  25 -> %s, 7.5 -> %s; the level never moved"
		% [_exact(track.progress()), _exact(fractional.progress())])
	_done("an_unmodified_award_adds_exactly_its_base")


# --- 3. The accepted stat path -----------------------------------------------------

func _check_experience_gain_is_applied_through_the_accepted_stat_path() -> void:
	print("")
	print("--- 3. Experience Gain is applied through the accepted calculation, not restated")
	var boosted: PlayerStatTotals = PlayerStatTotals.new()
	_expect_accepted(boosted.add(PlayerStats.EXPERIENCE_GAIN, _shipped_gain),
		"granting the shipped Experience Gain magnitude")
	_expect(is_equal_approx(_shipped_gain, 0.10),
		"the shipped Experience Gain magnitude is %s, not +10%%" % _exact(_shipped_gain))

	var track: RiftExperienceTrack = RiftExperienceTrack.new()
	_expect_accepted(track.award(BASE_AWARD, boosted), "an award of 25 at the shipped +10%")

	## THE AUTHORITY IS THE ACCEPTED PATH, NOT A TYPED DECIMAL. This is the
	## assertion the brief's own instruction asks for: 25 at +10% is
	## 27.50000000000000355, and a check that typed 27.5 would be measuring the
	## decimal system rather than this track.
	var accepted: PlayerStatValue = PlayerStats.apply(
		PlayerStats.EXPERIENCE_GAIN, BASE_AWARD, _shipped_gain)
	_expect(accepted.ok, "the accepted path refused the control calculation: %s"
		% accepted.failure_reason)
	_expect(track.progress() == accepted.value,
		"25 at +10%% came to %s, and the accepted path answers %s"
			% [_exact(track.progress()), _exact(accepted.value)])

	## AND BOTH HALVES OF WHY, so a reviewer can trust either. It IS 27.5 to
	## display precision, and it is NOT the double 27.5.
	_expect(is_equal_approx(track.progress(), MISLEADING_DECIMAL),
		"the result %s is not 27.5 even approximately" % _exact(track.progress()))
	_expect(track.progress() != MISLEADING_DECIMAL,
		"the result equals the typed 27.5 exactly, so this suite's own warning is wrong")

	## DELEGATION, MEASURED ACROSS A SWEEP RATHER THAN AT ONE POINT. A restated
	## multiplier would agree at some totals and not at others; every one of
	## these is compared bit for bit.
	var mismatches: PackedStringArray = PackedStringArray()
	var compared: int = 0
	for total: float in [-0.75, -0.5, -0.1, 0.0, 0.05, 0.10, 0.25, 0.5, 1.0, 3.0]:
		for base: float in [1.0, 7.5, 25.0, 100.0, 12345.678]:
			var totals: PlayerStatTotals = PlayerStatTotals.new()
			if total != 0.0:
				var refusal: String = totals.add(PlayerStats.EXPERIENCE_GAIN, total)
				if not refusal.is_empty():
					mismatches.append("the control refused %s: %s" % [_exact(total), refusal])
					continue
			var probe: RiftExperienceTrack = RiftExperienceTrack.new()
			var awarded: String = probe.award(base, totals)
			var expected: PlayerStatValue = PlayerStats.apply(
				PlayerStats.EXPERIENCE_GAIN, base, total)
			compared += 1
			if not awarded.is_empty():
				mismatches.append("%s at %s was refused: %s" % [
					_exact(base), _exact(total), awarded,
				])
			elif probe.progress() != expected.value:
				mismatches.append("%s at %s came to %s, not %s" % [
					_exact(base), _exact(total), _exact(probe.progress()),
					_exact(expected.value),
				])
	_expect(mismatches.is_empty(),
		"the track disagrees with the accepted path: %s" % ", ".join(mismatches))
	_expect(compared == 50, "only %d of the 50 sweep points were compared" % compared)

	## PERCENTAGES ADD BEFORE THEY ARE APPLIED, AND THE FOIL IS COMPUTED RATHER
	## THAN TYPED. Two grants of the shipped magnitude are one sum applied once;
	## a track that applied each award's modifiers twice, or that compounded,
	## would produce the second number.
	var twice: PlayerStatTotals = PlayerStatTotals.new()
	_expect_accepted(twice.add(PlayerStats.EXPERIENCE_GAIN, _shipped_gain), "the first grant")
	_expect_accepted(twice.add(PlayerStats.EXPERIENCE_GAIN, _shipped_gain), "the second grant")
	var additive: RiftExperienceTrack = RiftExperienceTrack.new()
	_expect_accepted(additive.award(100.0, twice), "an award of 100 at two grants")
	var additive_expected: PlayerStatValue = PlayerStats.apply(
		PlayerStats.EXPERIENCE_GAIN, 100.0, twice.total_for(PlayerStats.EXPERIENCE_GAIN))
	var compounded: float = 100.0 * (1.0 + _shipped_gain) * (1.0 + _shipped_gain)
	_expect(additive.progress() == additive_expected.value,
		"100 at two grants came to %s, not the accepted %s"
			% [_exact(additive.progress()), _exact(additive_expected.value)])
	_expect(additive.progress() != compounded,
		"100 at two grants came to the COMPOUNDED %s" % _exact(compounded))

	print("  25 at +%s: %s (the accepted path's own answer; a typed 27.5 is %s)"
		% [_exact(_shipped_gain), _exact(track.progress()), _exact(MISLEADING_DECIMAL)])
	print("  %d sweep points agree with the accepted path bit for bit" % compared)
	print("  100 at two grants: %s additive, and NOT the compounded %s"
		% [_exact(additive.progress()), _exact(compounded)])
	_done("experience_gain_is_applied_through_the_accepted_stat_path")


# --- 4. Not retroactive -------------------------------------------------------------

func _check_experience_gain_is_not_retroactive() -> void:
	print("")
	print("--- 4. Experience Gain is evaluated at award time and is never retroactive")
	var track: RiftExperienceTrack = RiftExperienceTrack.new()
	var before_gain: PlayerStatTotals = PlayerStatTotals.new()

	_expect_accepted(track.award(BASE_AWARD, before_gain), "the award collected before the grant")
	_expect(track.progress() == UNMODIFIED_TOTAL,
		"the first award stored %s" % _exact(track.progress()))

	var after_gain: PlayerStatTotals = PlayerStatTotals.new()
	_expect_accepted(after_gain.add(PlayerStats.EXPERIENCE_GAIN, _shipped_gain),
		"acquiring the shipped Experience Gain passive")
	_expect_accepted(track.award(BASE_AWARD, after_gain), "the award collected after the grant")

	## EXACT. 25 plus the inexact 27.50000000000000355 rounds to precisely 52.5,
	## which was measured before it was typed here.
	_expect(track.progress() == TWO_AWARD_TOTAL,
		"two awards of 25 either side of the grant came to %s" % _exact(track.progress()))

	## THE FOIL IS THE WHOLE CHECK. If the grant had reached backwards, both
	## awards would have been multiplied and the total would be the accepted
	## path's answer for FIFTY at the same magnitude.
	var retroactive: PlayerStatValue = PlayerStats.apply(
		PlayerStats.EXPERIENCE_GAIN, 50.0, _shipped_gain)
	_expect(retroactive.ok, "the retroactive foil could not be computed")
	_expect(track.progress() != retroactive.value,
		"the total is the RETROACTIVE %s" % _exact(retroactive.value))
	_expect(track.progress() < retroactive.value,
		"the honest total %s is not below the retroactive %s"
			% [_exact(track.progress()), _exact(retroactive.value)])

	## AND IT IS STRUCTURAL, NOT MERELY OBSERVED: mutating the accumulator that
	## was handed in cannot move experience already stored, because nothing here
	## kept a reference to it.
	var stored: float = track.progress()
	_expect_accepted(after_gain.add(PlayerStats.EXPERIENCE_GAIN, _shipped_gain),
		"acquiring a second Experience Gain passive after the fact")
	_expect(track.progress() == stored,
		"a later grant moved stored progress from %s to %s"
			% [_exact(stored), _exact(track.progress())])
	_expect(after_gain.total_for(PlayerStats.EXPERIENCE_GAIN) != _shipped_gain,
		"the accumulator was not actually changed, so the claim proves nothing")

	print("  25 before the grant + 25 after = %s; retroactive would be %s"
		% [_exact(track.progress()), _exact(retroactive.value)])
	_done("experience_gain_is_evaluated_at_award_time_and_is_not_retroactive")


# --- 5. Threshold readings ----------------------------------------------------------

func _check_a_threshold_reading_answers_ready_and_remaining() -> void:
	print("")
	print("--- 5. A requirement of 50 reports ready at 52.5 with 0 remaining")
	var track: RiftExperienceTrack = _worked_example_track()

	var reading: RiftExperienceReading = track.reading_for(FIRST_REQUIREMENT)
	_expect(reading != null and reading.ok,
		"the reading was refused: %s" % ("no reading" if reading == null else reading.failure_reason))
	_expect(reading.problem().is_empty(),
		"the reading is incoherent: %s" % reading.problem())
	_expect(reading.ready, "52.5 does not meet a requirement of 50")
	_expect(reading.remaining == 0.0,
		"a met requirement still reports %s remaining" % _exact(reading.remaining))
	_expect(reading.requirement == FIRST_REQUIREMENT,
		"the reading carries the requirement %s" % _exact(reading.requirement))
	_expect(reading.progress == track.progress(),
		"the reading carries progress %s against the track's %s"
			% [_exact(reading.progress), _exact(track.progress())])
	_expect(reading.failure_reason.is_empty(),
		"a successful reading states '%s'" % reading.failure_reason)

	## The two scalar conveniences agree with the reading rather than
	## re-deciding anything.
	_expect(track.is_ready(FIRST_REQUIREMENT), "is_ready disagrees with the reading")
	_expect(track.remaining(FIRST_REQUIREMENT) == 0.0,
		"remaining answers %s" % _exact(track.remaining(FIRST_REQUIREMENT)))

	## A requirement that is NOT met, so "ready" is a measurement rather than a
	## constant. Remaining is exact here too.
	var short: RiftExperienceReading = track.reading_for(60.0)
	_expect(short.ok and short.problem().is_empty(),
		"the unmet reading is refused or incoherent")
	_expect(not short.ready, "52.5 was reported as meeting a requirement of 60")
	_expect(short.remaining == 60.0 - track.progress(),
		"60 short of %s reports %s remaining"
			% [_exact(track.progress()), _exact(short.remaining)])
	_expect(not track.is_ready(60.0), "is_ready reports ready against 60")

	## The exact boundary: a requirement equal to the progress is MET, because
	## "at least" is the rule and an off-by-one here would be invisible in play.
	var exact_boundary: RiftExperienceReading = track.reading_for(track.progress())
	_expect(exact_boundary.ok and exact_boundary.ready,
		"a requirement exactly equal to the progress was not met")
	_expect(exact_boundary.remaining == 0.0,
		"the exact boundary reports %s remaining" % _exact(exact_boundary.remaining))

	## READING CHANGES NOTHING. Three questions were asked; the track is where
	## it was.
	_expect(_snapshot(track) == _worked_example_snapshot(),
		"asking moved the track to %s" % _snapshot(track))

	print("  at %s: requirement 50 ready with 0 remaining; requirement 60 needs %s"
		% [_exact(track.progress()), _exact(short.remaining)])
	_done("a_threshold_reading_answers_ready_and_remaining")


# --- 6. Advancing ---------------------------------------------------------------------

func _check_advancing_takes_exactly_one_requirement() -> void:
	print("")
	print("--- 6. Advancing once produces Level 2 and keeps exactly the overflow")
	var track: RiftExperienceTrack = _worked_example_track()

	_expect_accepted(track.advance_one_level(FIRST_REQUIREMENT), "advancing against 50")
	_expect(track.level() == 2, "advancing produced level %d" % track.level())
	## EXACT: 52.5 minus 50 is precisely 2.5.
	_expect(track.progress() == EXPECTED_OVERFLOW,
		"the overflow is %s" % _exact(track.progress()))

	## THE SUBTRACTION IS EXACTLY ONE REQUIREMENT, derived rather than typed, so
	## this still holds if the worked example ever changes.
	_expect(track.progress() == _worked_example_progress() - FIRST_REQUIREMENT,
		"the overflow %s is not the progress minus exactly one requirement"
			% _exact(track.progress()))

	## THE INCREMENT-SAFETY RULE IS DRIVEN DIRECTLY, because through this value's
	## own interface it is unreachable in any finite run — nine quintillion
	## successful advances — and a guard that only lives inside an unreachable
	## branch has never been tested.
	_expect(RiftExperienceTrack.level_can_increment(RiftExperienceTrack.STARTING_LEVEL),
		"a track at its starting level cannot take another")
	_expect(RiftExperienceTrack.level_can_increment(1000000),
		"a track at a million levels cannot take another")
	_expect(RiftExperienceTrack.level_can_increment(
			RiftExperienceTrack.LEVEL_INCREMENT_LIMIT - 1),
		"a track one below the arithmetic bound cannot take another")
	_expect(not RiftExperienceTrack.level_can_increment(
			RiftExperienceTrack.LEVEL_INCREMENT_LIMIT),
		"a track AT the arithmetic bound was told it can take another")
	## And the bound really is the largest representable level, so the guard is
	## the arithmetic's own limit rather than a balance decision wearing its
	## clothes.
	_expect(RiftExperienceTrack.LEVEL_INCREMENT_LIMIT + 1
			< RiftExperienceTrack.LEVEL_INCREMENT_LIMIT,
		"the declared bound is not the point at which one more level wraps")

	print("  %s -> Level %d with %s kept; the bound refuses only at %d"
		% [_exact(_worked_example_progress()), track.level(), _exact(track.progress()),
			RiftExperienceTrack.LEVEL_INCREMENT_LIMIT])
	_done("advancing_takes_exactly_one_requirement_and_keeps_the_overflow")


# --- 7. Insufficient progress -----------------------------------------------------------

func _check_insufficient_progress_refuses_without_moving_the_track() -> void:
	print("")
	print("--- 7. Insufficient progress refuses and moves neither level nor progress")
	var track: RiftExperienceTrack = _worked_example_track()
	var before: String = _snapshot(track)

	_expect_atomic_refusal(track, before,
		track.advance_one_level(100.0), "advancing against a requirement of 100")

	## The boundary from the other side: one unit past the progress is refused,
	## and the progress itself is not. A rule that used `>` instead of `>=` would
	## pass the first of these and fail the second.
	var just_past: float = track.progress() + 1.0
	_expect_atomic_refusal(track, before,
		track.advance_one_level(just_past), "advancing against one more than the progress")
	_expect_accepted(track.advance_one_level(track.progress()),
		"advancing against exactly the progress")
	_expect(track.level() == 2, "the boundary advance produced level %d" % track.level())
	_expect(track.progress() == 0.0,
		"advancing against exactly the progress left %s" % _exact(track.progress()))

	## And a track with nothing at all refuses everything, without moving.
	var fresh: RiftExperienceTrack = RiftExperienceTrack.new()
	var fresh_before: String = _snapshot(fresh)
	_expect_atomic_refusal(fresh, fresh_before,
		fresh.advance_one_level(SMALL_REQUIREMENT), "advancing an untouched track")

	print("  three short advances refused; the exact-boundary advance succeeded")
	_done("insufficient_progress_refuses_without_moving_the_track")


# --- 8. One level per call ----------------------------------------------------------------

func _check_a_large_overflow_advances_exactly_one_level_per_call() -> void:
	print("")
	print("--- 8. A large overflow advances exactly one level per call")
	var track: RiftExperienceTrack = RiftExperienceTrack.new()
	var empty: PlayerStatTotals = PlayerStatTotals.new()
	_expect_accepted(track.award(LARGE_AWARD, empty), "an award of 1000")

	_expect_accepted(track.advance_one_level(SMALL_REQUIREMENT), "the first advance against 10")
	_expect(track.level() == 2,
		"one call against a hundredfold overflow produced level %d" % track.level())
	_expect(track.progress() == LARGE_OVERFLOW,
		"the first advance left %s" % _exact(track.progress()))

	## IT REPORTS READY AGAIN, AND STILL DOES NOT ADVANCE ON ITS OWN. That pair
	## is the whole rule: a future offer is resolvable between two level gains
	## precisely because the second one waits to be asked for.
	_expect(track.is_ready(SMALL_REQUIREMENT),
		"the surplus no longer meets the same requirement")
	_expect(track.level() == 2, "merely asking advanced the level to %d" % track.level())
	_expect(track.progress() == LARGE_OVERFLOW,
		"merely asking moved the progress to %s" % _exact(track.progress()))

	## Ninety-nine more calls, each taking exactly one requirement.
	var levels: int = 1
	for _index: int in 99:
		if track.advance_one_level(SMALL_REQUIREMENT).is_empty():
			levels += 1
	_expect(levels == 100, "%d of 100 calls advanced" % levels)
	_expect(track.level() == 101, "100 calls produced level %d" % track.level())
	_expect(track.progress() == 0.0,
		"100 calls against 10 left %s of 1000" % _exact(track.progress()))
	_expect_refused(track.advance_one_level(SMALL_REQUIREMENT),
		"the 101st advance against an empty track")

	print("  1000 against 10: one call is one level; 100 calls, level 101, %s left"
		% _exact(track.progress()))
	_done("a_large_overflow_advances_exactly_one_level_per_call")


# --- 9. The next supplied requirement -----------------------------------------------------

func _check_readiness_is_asked_again_against_the_next_requirement() -> void:
	print("")
	print("--- 9. After one advance, readiness is asked against a separately supplied next requirement")
	var track: RiftExperienceTrack = _worked_example_track()
	_expect_accepted(track.advance_one_level(FIRST_REQUIREMENT), "the first advance")
	_expect(track.level() == 2, "the first advance produced level %d" % track.level())

	## THE SECOND REQUIREMENT IS A DIFFERENT NUMBER, ON PURPOSE. A track that
	## quietly remembered the first would still pass a check that asked twice
	## with the same value.
	_expect(SECOND_REQUIREMENT != FIRST_REQUIREMENT,
		"the two requirements are the same number, so this check proves nothing")
	var second: RiftExperienceReading = track.reading_for(SECOND_REQUIREMENT)
	_expect(second.ok and second.problem().is_empty(),
		"the second reading is refused or incoherent")
	_expect(not second.ready, "2.5 was reported as meeting a requirement of 40")
	_expect(second.remaining == SECOND_REQUIREMENT - track.progress(),
		"40 against %s reports %s remaining"
			% [_exact(track.progress()), _exact(second.remaining)])
	_expect(second.requirement == SECOND_REQUIREMENT,
		"the second reading carries the requirement %s" % _exact(second.requirement))

	## And a THIRD requirement, small enough to be met, answered from the same
	## state — so the answer is a function of the argument rather than of the
	## track's history.
	var third: RiftExperienceReading = track.reading_for(1.0)
	_expect(third.ok and third.ready, "2.5 was reported as short of a requirement of 1")
	_expect(third.remaining == 0.0,
		"a met second-level requirement reports %s remaining" % _exact(third.remaining))
	_expect_accepted(track.advance_one_level(1.0), "advancing against the third requirement")
	_expect(track.level() == 3, "the second advance produced level %d" % track.level())
	_expect(track.progress() == EXPECTED_OVERFLOW - 1.0,
		"the second advance left %s" % _exact(track.progress()))

	print("  Level 2 with %s: 40 is not met, 1 is; advancing against 1 gives Level %d"
		% [_exact(EXPECTED_OVERFLOW), track.level()])
	_done("readiness_is_asked_again_against_the_next_supplied_requirement")


# --- 10. Unusable awards ------------------------------------------------------------------

func _check_every_unusable_award_refuses_atomically() -> void:
	print("")
	print("--- 10. Zero, negative, non-finite, absent and worthless awards refuse atomically")
	var refused_before: int = _refusals
	var track: RiftExperienceTrack = _seeded_track()
	var before: String = _snapshot(track)
	var empty: PlayerStatTotals = PlayerStatTotals.new()

	## A POSITIVE CONTROL FIRST, because a guard that refuses everything protects
	## nothing — and specifically on the seeded track, so the refusals below are
	## made against a state that CAN move.
	var control: RiftExperienceTrack = _seeded_track()
	_expect_accepted(control.award(1.0, empty), "the positive control award")
	_expect(control.progress() != SEED_AWARD, "the positive control changed nothing")

	for bad: float in [0.0, -1.0, -BASE_AWARD, NAN, INF, -INF]:
		_expect_atomic_refusal(track, before, track.award(bad, empty),
			"an award of %s" % _shown(bad))

	## A NULL SNAPSHOT IS REFUSED, and refused after the award itself has been
	## found usable, so this row is about the totals rather than about the float.
	_expect_atomic_refusal(track, before, track.award(BASE_AWARD, null),
		"an award with no stat totals")

	## AN AWARD THAT COMES TO NOTHING IS REFUSED, AND THE CASE IS REACHABLE
	## RATHER THAN DEFENSIVE. The smallest positive double halved rounds to zero,
	## and the accepted calculation reports that as an ordinary success — zero is
	## a perfectly good product. Recording it would report that experience was
	## awarded when none was.
	##
	## IT HAS TO BE BUILT BY ARITHMETIC: this engine parses the literal `5e-324`
	## as exactly zero, so a typed constant would be refused one gate earlier and
	## this branch would never run.
	var smallest: float = _smallest_positive_double()
	_expect(smallest > 0.0, "the smallest positive double was built as zero")
	var halving: PlayerStatTotals = PlayerStatTotals.new()
	_expect_accepted(halving.add(PlayerStats.EXPERIENCE_GAIN, -0.5),
		"granting a reduction of one half")
	var worthless: PlayerStatValue = halving.value_of(PlayerStats.EXPERIENCE_GAIN, smallest)
	_expect(worthless.ok and worthless.value == 0.0,
		"the accepted path did not answer zero, so this row proves nothing")
	_expect_atomic_refusal(track, before, track.award(smallest, halving),
		"an award that comes to nothing after Experience Gain")
	## The positive control for exactly that value: the same award with no
	## reduction IS accepted, so the refusal is about the product rather than
	## about the input being small.
	var accepts_smallest: RiftExperienceTrack = RiftExperienceTrack.new()
	_expect_accepted(accepts_smallest.award(smallest, empty),
		"the smallest positive award with no modifier")
	_expect(accepts_smallest.progress() == smallest,
		"the smallest positive award stored %s" % _exact(accepts_smallest.progress()))

	## AND AN AWARD THE ACCEPTED PATH ITSELF REFUSES. Reachable only through a
	## record the vocabulary does not recognise, so it is driven at the one place
	## a caller could produce it — and the reason is carried through rather than
	## replaced.
	var refusing: PlayerStatValue = PlayerStats.apply(&"zz_not_a_stat", BASE_AWARD, 0.0)
	_expect(not refusing.ok, "the unrecognised-stat control was accepted")

	print("  %d unusable awards refused; the track never left %s"
		% [_refusals - refused_before, before])
	_done("every_unusable_award_refuses_atomically")


# --- 11. Progress overflow ---------------------------------------------------------------

func _check_an_award_that_would_overflow_refuses_atomically() -> void:
	print("")
	print("--- 11. An addition that would make the progress unusable refuses atomically")
	var track: RiftExperienceTrack = RiftExperienceTrack.new()
	var empty: PlayerStatTotals = PlayerStatTotals.new()

	## THE FIRST AWARD IS ACCEPTED, and that is what makes this the refusal that
	## happens AFTER every validation has passed — D-241's lesson, which this
	## project has now learned three times: an atomicity proof made only against
	## inputs that fail early proves early failure, not atomicity.
	_expect_accepted(track.award(OVERFLOWING_AWARD, empty), "the first enormous award")
	_expect(is_finite(track.progress()),
		"the first enormous award already produced an unusable progress")
	var before: String = _snapshot(track)

	_expect_atomic_refusal(track, before, track.award(OVERFLOWING_AWARD, empty),
		"a second enormous award")
	_expect(is_finite(track.progress()),
		"the refused award left the progress at %s" % _exact(track.progress()))

	## The sum really would have been unusable, so the refusal is about the
	## arithmetic rather than about the size of the number.
	_expect(not is_finite(OVERFLOWING_AWARD + OVERFLOWING_AWARD),
		"the two awards do not actually sum past the representable range")
	_expect(is_finite(OVERFLOWING_AWARD),
		"the award is not itself finite, so it would be refused a gate earlier")

	## A THIRD ATTEMPT, AND A SMALL ONE, both from the same state: the refusal is
	## not a latch that has now broken the track.
	_expect_atomic_refusal(track, before, track.award(OVERFLOWING_AWARD, empty),
		"a third enormous award")
	_expect_accepted(track.award(1.0, empty), "an ordinary award after the refusals")
	_expect(track.level() == 1, "the refusals moved the level to %d" % track.level())

	print("  two enormous awards: the first stored, the second and third refused, the track usable")
	_done("an_award_that_would_overflow_the_progress_refuses_atomically")


# --- 12. Invalid requirements --------------------------------------------------------------

func _check_every_invalid_requirement_is_rejected_on_every_route() -> void:
	print("")
	print("--- 12. Zero, negative and non-finite requirements are rejected on every route")
	var track: RiftExperienceTrack = _seeded_track()
	var before: String = _snapshot(track)

	## The positive control, on all four routes, before any refusal is counted.
	_expect(RiftExperienceTrack.requirement_problem(1.0).is_empty(),
		"a requirement of 1 was refused")
	_expect(track.reading_for(1.0).ok, "a reading against 1 was refused")
	_expect(track.is_ready(1.0), "the seeded track is not ready for 1")
	_expect(track.remaining(SEED_AWARD + 1.0) == 1.0,
		"remaining against a valid requirement answers %s"
			% _exact(track.remaining(SEED_AWARD + 1.0)))

	for bad: float in [0.0, -1.0, -FIRST_REQUIREMENT, NAN, INF, -INF]:
		var described: String = "a requirement of %s" % _shown(bad)

		var stated: String = RiftExperienceTrack.requirement_problem(bad)
		_refusals += 1
		_expect(not stated.strip_edges().is_empty(),
			"%s was accepted by the shared validation" % described)

		## THE EXPLICIT RESULT PATH. A reading refuses, states the reason, and
		## carries no partial measurement — which is what makes it the honest
		## route the two scalars below cannot be.
		var reading: RiftExperienceReading = track.reading_for(bad)
		_expect(reading != null and not reading.ok, "%s produced a usable reading" % described)
		_expect(reading.failure_reason == stated,
			"%s: the reading states '%s' against '%s'" % [
				described, reading.failure_reason, stated,
			])
		_expect(reading.problem().is_empty(),
			"the refusal of %s is itself incoherent: %s" % [described, reading.problem()])
		_expect(reading.requirement == 0.0 and reading.progress == 0.0
				and reading.remaining == 0.0 and not reading.ready,
			"the refusal of %s carries a partial measurement" % described)

		## THE TWO SCALARS FAIL CLOSED, and specifically not toward the plausible
		## answer. `false` cannot be mistaken for "ready"; infinity cannot be
		## mistaken for "nothing more is needed", which zero would be.
		_expect(not track.is_ready(bad), "%s was reported as ready" % described)
		_expect(track.remaining(bad) == INF,
			"%s answers %s remaining rather than infinity"
				% [described, _exact(track.remaining(bad))])
		_expect(track.remaining(bad) != 0.0,
			"%s silently answers zero remaining" % described)

		## AND ADVANCING REFUSES WITH THE SAME REASON, so the two paths cannot
		## come to two different answers about one number.
		var advanced: String = track.advance_one_level(bad)
		_expect(advanced == stated,
			"%s: advancing states '%s' against '%s'" % [described, advanced, stated])

	_expect(_snapshot(track) == before,
		"the invalid requirements moved the track to %s" % _snapshot(track))

	print("  6 invalid requirements refused on all 4 routes; remaining answers infinity, never zero")
	_done("every_invalid_requirement_is_rejected_on_every_route")


# --- 13. Copies ----------------------------------------------------------------------------

func _check_duplicating_the_track_is_independent() -> void:
	print("")
	print("--- 13. A duplicate is independent in both directions")
	var original: RiftExperienceTrack = _worked_example_track()
	_expect_accepted(original.advance_one_level(FIRST_REQUIREMENT), "advancing the original once")
	var copy: RiftExperienceTrack = original.duplicated()

	_expect(copy != original, "duplicated() returned the same object")
	_expect(_snapshot(copy) == _snapshot(original),
		"the copy starts at %s against %s" % [_snapshot(copy), _snapshot(original)])

	## THE COPY IS CHANGED AND THE ORIGINAL CHECKED.
	var original_before: String = _snapshot(original)
	var empty: PlayerStatTotals = PlayerStatTotals.new()
	_expect_accepted(copy.award(LARGE_AWARD, empty), "awarding to the copy")
	_expect_accepted(copy.advance_one_level(SMALL_REQUIREMENT), "advancing the copy")
	_expect(_snapshot(original) == original_before,
		"changing the copy moved the original to %s" % _snapshot(original))

	## AND THE ORIGINAL IS CHANGED AND THE COPY CHECKED. One direction alone
	## would miss a copy that shares its internals.
	var copy_before: String = _snapshot(copy)
	_expect_accepted(original.award(BASE_AWARD, empty), "awarding to the original")
	_expect_accepted(original.advance_one_level(1.0), "advancing the original again")
	_expect(_snapshot(copy) == copy_before,
		"changing the original moved the copy to %s" % _snapshot(copy))
	_expect(_snapshot(copy) != _snapshot(original),
		"the two tracks are still identical, so neither was actually changed")

	## A duplicate of an untouched track is an untouched track.
	var fresh_copy: RiftExperienceTrack = RiftExperienceTrack.new().duplicated()
	_expect(fresh_copy.level() == 1 and fresh_copy.progress() == 0.0,
		"a duplicate of a new track is %s" % _snapshot(fresh_copy))

	print("  original %s, copy %s; each moved without moving the other"
		% [_snapshot(original), _snapshot(copy)])
	_done("duplicating_the_track_is_independent_in_both_directions")


# --- 14. Content cannot reach the arithmetic -------------------------------------------------

func _check_names_ids_weights_and_seeds_cannot_reach_the_arithmetic() -> void:
	print("")
	print("--- 14. Presentation names, card ids, weights and seeds cannot reach the arithmetic")

	## THE STRUCTURAL HALF, AND IT IS THE STRONGER ONE: the complete signature of
	## every method is pinned below in the last check, and not one argument
	## anywhere is of a shape that could carry an id, a label, a weight or a
	## seed. An award takes a number and an accumulator; every other operation
	## takes a number or nothing.
	var track_instance: RiftExperienceTrack = RiftExperienceTrack.new()
	var strays: PackedStringArray = PackedStringArray()
	for member: String in ["card_id", "card", "display_name", "base_weight", "weight",
		"seed", "root_seed", "offer", "lane", "magnitude", "stat_id", "totals",
		"curve", "requirement", "source", "mote"]:
		if member in track_instance:
			strays.append(member)
	_expect(strays.is_empty(),
		"the track carries the member(s) %s" % ", ".join(strays))

	## THE BEHAVIOURAL HALF, AGAINST THE SHIPPED RECORD RATHER THAN A FIXTURE.
	## The shipped Experience Gain card and a fabrication that agrees with it on
	## the ONE field that reaches arithmetic — and disagrees on its id, its
	## label, its weight and its repeatability — produce byte-identical progress.
	var shipped: PassiveCardDefinition = null
	for record: PassiveCardDefinition in PassiveCardCatalogue.records():
		if record.stat_id == PlayerStats.EXPERIENCE_GAIN:
			shipped = record
	_expect(shipped != null, "no shipped card grants Experience Gain")
	var fabricated: PassiveCardDefinition = PassiveCardDefinition.of(
		&"zz_probe_gain", "Zz Renamed Probe", PlayerStats.EXPERIENCE_GAIN,
		shipped.magnitude, shipped.base_weight + 1, false)
	_expect(fabricated.problem().is_empty(),
		"the fabricated record is invalid: %s" % fabricated.problem())
	_expect(fabricated.card_id != shipped.card_id
			and fabricated.display_name != shipped.display_name
			and fabricated.base_weight != shipped.base_weight
			and fabricated.repeatable != shipped.repeatable,
		"the fabricated record agrees with the shipped one, so this row proves nothing")
	_expect(fabricated.magnitude == shipped.magnitude,
		"the two records disagree about the magnitude, which IS allowed to matter")

	var from_shipped: RiftExperienceTrack = _track_from_card(shipped)
	var from_fabricated: RiftExperienceTrack = _track_from_card(fabricated)
	_expect(_snapshot(from_shipped) == _snapshot(from_fabricated),
		"the shipped record gives %s and the fabrication gives %s"
			% [_snapshot(from_shipped), _snapshot(from_fabricated)])
	_expect(from_shipped.progress() != 0.0,
		"neither record produced any progress, so the comparison is vacuous")

	## AND THE MAGNITUDE REALLY IS WHAT MATTERS, so the invariance above is not
	## simply "nothing reaches it at all".
	var different: PassiveCardDefinition = PassiveCardDefinition.of(
		shipped.card_id, shipped.display_name, PlayerStats.EXPERIENCE_GAIN,
		shipped.magnitude + 0.5, shipped.base_weight, shipped.repeatable)
	var from_different: RiftExperienceTrack = _track_from_card(different)
	_expect(_snapshot(from_different) != _snapshot(from_shipped),
		"a record differing only in magnitude produced the same progress %s"
			% _snapshot(from_different))

	print("  shipped %s and a renamed, re-weighted, once-only fabrication both give %s"
		% [shipped.card_id, _exact(from_shipped.progress())])
	_done("names_ids_weights_and_seeds_cannot_reach_the_arithmetic")


# --- 15. Generic, ambient-free and unwired ---------------------------------------------------

func _check_the_track_is_generic_and_unwired() -> void:
	print("")
	print("--- 15. The two scripts name nothing concrete, read nothing ambient, and nothing calls them")
	var scanned: int = 0
	var forbidden_total: int = 0
	var ambient_total: int = 0
	var deferred_total: int = 0

	for path: String in E1_FILES:
		var raw: String = FileAccess.get_file_as_string(path)
		_expect(raw.length() > 1000,
			"%s read as %d characters, so these scans prove nothing" % [
				path.get_file(), raw.length(),
			])
		var code: String = _code_only(raw)
		_expect(code.length() > 400 and code.length() < raw.length(),
			"%s: comment stripping produced %d characters from %d" % [
				path.get_file(), code.length(), raw.length(),
			])
		scanned += 1

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
		_expect(ambient.is_empty(),
			"%s reads ambient state: %s" % [path.get_file(), ", ".join(ambient)])

		var deferred: PackedStringArray = PackedStringArray()
		for token: String in DEFERRED_MEMBER_TOKENS:
			if _names_deferred_member(code, token):
				deferred.append(token)
		deferred_total += deferred.size()
		_expect(deferred.is_empty(),
			"%s carries deferred members: %s" % [path.get_file(), ", ".join(deferred)])

		## NO PERCENTAGE ARITHMETIC IS RESTATED, ASSERTED FROM THE SOURCE. The
		## multiplier belongs to the accepted path; addition and subtraction are
		## this foundation's own and are deliberately still allowed.
		_expect(not code.contains("*") and not code.contains("/"),
			"%s multiplies or divides" % path.get_file())
		var literals: PackedStringArray = _float_literals(code)
		var wrong: PackedStringArray = PackedStringArray()
		for literal: String in literals:
			if literal != "0.0":
				wrong.append(literal)
		_expect(wrong.is_empty(),
			("%s carries the floating-point literal(s) %s — a curve, a drop value or a"
				+ " cap would arrive as exactly this") % [path.get_file(), ", ".join(wrong)])
		_expect(literals.size() > 0,
			"%s: the float-literal scan found nothing at all, so it proves nothing"
				% path.get_file())
	_expect(scanned == E1_FILES.size(),
		"%d of %d E1 scripts were scanned" % [scanned, E1_FILES.size()])

	## THE SCANS ARE PROVED CAPABLE OF FAILING, by finding their own tokens where
	## those tokens legitimately live: in this file. A scan that can only ever
	## report zero is not a guard.
	var self_source: String = FileAccess.get_file_as_string(
		"res://tests/rift_experience_track_verification.gd")
	var found_here: int = 0
	for token: String in FORBIDDEN_TOKENS:
		if self_source.contains(token):
			found_here += 1
	_expect(found_here > 20,
		"the forbidden-token scan found only %d of its own tokens in this file" % found_here)

	## AND THE WORD-BOUNDARY MATCHER IS PROVED IN BOTH DIRECTIONS, on the exact
	## pair that makes it necessary here: `table` must still catch a member named
	## for the deferred curve, and must not fire on the word this foundation uses
	## to say the bound is an arithmetic one.
	_expect(_names_deferred_member("var level_table: Array = []", "table"),
		"the word matcher no longer catches a member named for a deferred system")
	_expect(not _names_deferred_member("could no longer be representable", "table"),
		"the word matcher fires on the sentence that makes the claim")
	_expect(_names_deferred_member("func award_mote() -> void:", "mote"),
		"the word matcher no longer catches an underscored deferred member")
	_expect(not _names_deferred_member("a remote reading", "mote"),
		"the word matcher fires on an ordinary word containing a token")

	## AN ALLOWLIST, NOT ONLY A DENYLIST, AND PER FILE. The token list above can
	## only refuse names somebody remembered to add; this asks the ENGINE which
	## project classes exist and requires each file to name none of them but the
	## ones written beside its own path.
	var all_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var class_id: String = String(entry.get("class", ""))
		if not class_id.is_empty():
			all_classes.append(class_id)
	_expect(all_classes.size() > 20,
		"only %d project classes were enumerated; the allowlist may be inert"
			% all_classes.size())
	for row: Array in AUTHORIZED_CLASSES:
		var path: String = String(row[0])
		var granted: Array = row[1]
		var raw: String = FileAccess.get_file_as_string(path)
		var outside: PackedStringArray = PackedStringArray()
		for class_id: String in all_classes:
			if granted.has(class_id):
				continue
			if raw.contains(class_id):
				outside.append(class_id)
		_expect(outside.is_empty(),
			"%s names unauthorized project class(es): %s" % [
				path.get_file(), ", ".join(outside),
			])
		## THE GRANT IS EARNED. A file granted a class it no longer names turns
		## the exemption into a claim about nothing while still passing.
		var unearned: PackedStringArray = PackedStringArray()
		for class_id: String in granted:
			if not raw.contains(class_id):
				unearned.append(class_id)
		_expect(unearned.is_empty(),
			"%s is granted but does not name: %s" % [path.get_file(), ", ".join(unearned)])

	## THE SIGNATURE AND FIELD PINS. A level curve, an experience source, an
	## offer hook or a persistence step arrives as an extra method with a
	## plausible name rather than as a forbidden token — and an argument that
	## could carry content arrives inside an existing one.
	_expect(", ".join(_signatures_of(TRACK_FILE)) == ", ".join(EXPECTED_TRACK_SIGNATURES),
		"the track declares: %s" % ", ".join(_signatures_of(TRACK_FILE)))
	_expect(", ".join(_signatures_of(READING_FILE)) == ", ".join(EXPECTED_READING_SIGNATURES),
		"the reading declares: %s" % ", ".join(_signatures_of(READING_FILE)))

	var track_fields: PackedStringArray = _fields_of(RiftExperienceTrack.new())
	_expect(", ".join(track_fields) == ", ".join(EXPECTED_TRACK_FIELDS),
		"the track carries the fields: %s" % ", ".join(track_fields))
	var exposed: PackedStringArray = PackedStringArray()
	for field: String in track_fields:
		if not field.begins_with("_"):
			exposed.append(field)
	_expect(exposed.is_empty(),
		"the track exposes the field(s) %s directly" % ", ".join(exposed))
	var reading_fields: PackedStringArray = _fields_of(RiftExperienceReading.new())
	_expect(", ".join(reading_fields) == ", ".join(EXPECTED_READING_FIELDS),
		"the reading carries the fields: %s" % ", ".join(reading_fields))

	## NOTHING BUT AN AUTHORIZED READER REFERENCES IT. There is still no
	## experience source, no level curve, no UI and no persistence anywhere in
	## this foundation; the only files that may name one of its two classes are
	## the two themselves and the readers named in `AUTHORIZED_READERS`, each
	## granted exactly the classes written beside its own path.
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if E1_FILES.has(path):
				continue
			project_files += 1
			var source: String = FileAccess.get_file_as_string(path)
			for name: String in E1_CLASSES:
				if source.contains(name) and not _reader_may_name(path, name):
					referenced.append("%s names %s" % [path.get_file(), name])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for name: String in E1_CLASSES:
		if settings.contains(name):
			referenced.append("project.godot names %s" % name)
	_expect(referenced.is_empty(),
		"Foundation E1 is referenced by code that runs: %s" % ", ".join(referenced))
	_expect(project_files > 100,
		"only %d project files were scanned, so the scan proves nothing" % project_files)
	_expect(_files_under("res://addons", [".gd"]).size() > 0,
		"the addons root was scanned and held no script, so widening the scan proved nothing")
	_expect(not settings.contains("[autoload]"),
		"project.godot declares an [autoload] section")

	## `scripts/experience/` HOLDS EXACTLY WHAT IT SHOULD. A scratch probe left
	## behind is a project file nobody meant to ship, and every scan above that
	## filters on a known path is blind to it.
	var experience_scripts: PackedStringArray = _files_under("res://scripts/experience", [".gd"])
	experience_scripts.sort()
	var expected_scripts: PackedStringArray = PackedStringArray(EXPERIENCE_DIRECTORY_SCRIPTS)
	expected_scripts.sort()
	_expect(", ".join(experience_scripts) == ", ".join(expected_scripts),
		"scripts/experience/ holds: %s" % ", ".join(experience_scripts))

	## THE EXEMPTION THE ACCEPTED C1 SUITE GRANTS THIS FILE IS EARNED AND THE
	## LISTS AGREE. That suite proves nothing names its classes except an
	## authorized reader; if this file stopped naming a class it was granted, the
	## exemption would quietly become a claim about nothing while still passing.
	for row: Array in AUTHORIZING_SUITES:
		var suite_source: String = FileAccess.get_file_as_string(String(row[0]))
		var label: String = String(row[1])
		var granted_paths: Array = row[2]
		var granted_classes: Array = row[3]
		_expect(not suite_source.is_empty(),
			"the Foundation %s suite could not be read" % label)
		var listed: int = 0
		for path: String in granted_paths:
			if suite_source.contains(path):
				listed += 1
		_expect(listed == granted_paths.size(),
			"the Foundation %s suite authorizes %d of the %d E1 scripts it must" % [
				label, listed, granted_paths.size(),
			])
		var unearned: PackedStringArray = PackedStringArray()
		for path: String in granted_paths:
			var source: String = FileAccess.get_file_as_string(path)
			for class_id: String in granted_classes:
				if not source.contains(class_id):
					unearned.append("%s does not name %s" % [path.get_file(), class_id])
		_expect(unearned.is_empty(),
			"the Foundation %s exemption is unearned: %s" % [label, ", ".join(unearned)])

	## The entrypoint and the InputMap, counted exactly as every existing suite
	## counts them.
	_expect(String(ProjectSettings.get_setting("application/run/main_scene", ""))
			== "res://scenes/app/prototype_app.tscn",
		"the project entrypoint is %s"
			% ProjectSettings.get_setting("application/run/main_scene", ""))
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	_expect(actions == 31, "the InputMap holds %d project actions, not 31" % actions)

	print("  %d scripts scanned raw: %d forbidden tokens, %d ambient reads, %d deferred members"
		% [scanned, forbidden_total, ambient_total, deferred_total])
	print("  %d method signatures and %d fields pinned; %d project files name no E1 class"
		% [
			EXPECTED_TRACK_SIGNATURES.size() + EXPECTED_READING_SIGNATURES.size(),
			track_fields.size() + reading_fields.size(), project_files,
		])
	print("  %d refusals were driven across this suite" % _refusals)
	_done("the_track_is_generic_reads_nothing_ambient_and_is_unwired")


# --- Fixtures and helpers -------------------------------------------------------------
#
# Every fabricated record below is test data only: it is in no catalogue, no
# scene and no `.tres`, and it is not canon. The `zz_` prefix is so that none of
# them can be mistaken for content and so a future catalogue entry cannot collide
# with one.

## Finds the shipped Experience Gain magnitude BY STAT rather than by card id, so
## this suite does not hard-code which record grants it, and then pins which one
## it turned out to be.
func _load_shipped_experience_gain() -> bool:
	for record: PassiveCardDefinition in PassiveCardCatalogue.records():
		if record.stat_id == PlayerStats.EXPERIENCE_GAIN:
			_shipped_gain = record.magnitude
			_shipped_gain_card = record.card_id
			return true
	return false


## The brief's worked example: 25 collected before the grant and 25 after it.
func _worked_example_track() -> RiftExperienceTrack:
	var track: RiftExperienceTrack = RiftExperienceTrack.new()
	var before_gain: PlayerStatTotals = PlayerStatTotals.new()
	_expect(track.award(BASE_AWARD, before_gain).is_empty(),
		"the worked example's first award was refused")
	var after_gain: PlayerStatTotals = PlayerStatTotals.new()
	_expect(after_gain.add(PlayerStats.EXPERIENCE_GAIN, _shipped_gain).is_empty(),
		"the worked example could not grant Experience Gain")
	_expect(track.award(BASE_AWARD, after_gain).is_empty(),
		"the worked example's second award was refused")
	return track


func _worked_example_progress() -> float:
	return TWO_AWARD_TOTAL


func _worked_example_snapshot() -> String:
	return "level=1 progress=%s" % _exact(TWO_AWARD_TOTAL)


## A track holding something, so an atomicity claim is made against a state that
## could visibly move rather than against nothing.
func _seeded_track() -> RiftExperienceTrack:
	var track: RiftExperienceTrack = RiftExperienceTrack.new()
	var empty: PlayerStatTotals = PlayerStatTotals.new()
	_expect(track.award(SEED_AWARD, empty).is_empty(), "the seeded track could not be seeded")
	return track


## One fixed award evaluated against one card's magnitude, so two records can be
## compared on complete outcomes rather than on one number.
func _track_from_card(record: PassiveCardDefinition) -> RiftExperienceTrack:
	var totals: PlayerStatTotals = PlayerStatTotals.new()
	_expect(totals.add(record.stat_id, record.magnitude).is_empty(),
		"a probe record's magnitude was refused by the accumulator")
	var track: RiftExperienceTrack = RiftExperienceTrack.new()
	_expect(track.award(BASE_AWARD, totals).is_empty(), "a probe award was refused")
	return track


## The smallest positive double, BUILT BY ARITHMETIC. This engine parses the
## literal `5e-324` as exactly zero, so a typed constant cannot express it and
## the underflow refusal it makes reachable would never be driven.
func _smallest_positive_double() -> float:
	var value: float = 1e-200
	value = value * 1e-120
	var steps: int = 0
	while value * 0.5 > 0.0 and steps < 2000:
		value = value * 0.5
		steps += 1
	return value


# --- Assertions ------------------------------------------------------------------------

func _expect_accepted(refusal: String, described: String) -> void:
	_expect(refusal.is_empty(), "%s was refused: %s" % [described, refusal])


## One refusal, counted, and checked for the property every refusal owes: a
## stated reason rather than merely a non-empty string.
func _expect_refused(refusal: String, described: String) -> void:
	_refusals += 1
	_expect(not refusal.strip_edges().is_empty(), "%s was accepted" % described)


## A refusal that also left the whole track exactly as it was. The snapshot is
## complete on purpose: a refusal that moved the level without moving the
## progress is caught by the same comparison that catches one which moved both.
func _expect_atomic_refusal(
	track: RiftExperienceTrack, before: String, refusal: String, described: String
) -> void:
	_expect_refused(refusal, described)
	_expect(_snapshot(track) == before,
		"the refusal of %s changed the track:\n    before %s\n    after  %s" % [
			described, before, _snapshot(track),
		])


# --- Formatting ------------------------------------------------------------------------

## The COMPLETE track as one line, to seventeen significant digits. Every
## atomicity claim in this suite is a comparison of two of these.
func _snapshot(track: RiftExperienceTrack) -> String:
	if track == null:
		return "no track"
	return "level=%d progress=%s" % [track.level(), _exact(track.progress())]


## Seventeen decimal places, which is more than the seventeen significant digits
## it takes to separate any two distinct doubles in this example's range.
func _exact(value: float) -> String:
	return String.num(value, 17)


## The compact form, for values ordinary printing renders as "0.0" or as three
## hundred digits.
func _shown(value: float) -> String:
	return String.num_scientific(value)


## Every line that is not a whole-line comment. See `DEFERRED_MEMBER_TOKENS` for
## why exactly this treatment exists.
func _code_only(source: String) -> String:
	var out: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


## Every `<digits>.<digits>` run in `code`. A curve, an experience value or a cap
## would arrive as exactly one of these.
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


func _is_digit(character: String) -> bool:
	return character.length() == 1 and character >= "0" and character <= "9"


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


## A letter or a digit. The underscore is deliberately NOT one: `award_mote` must
## be caught and `remote` must not.
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


## Whether `path` is an authorized reader that is granted `name`. Per file AND
## per class: a file listed for one class is still refused every other, which is
## what keeps the row from becoming a blanket exemption.
func _reader_may_name(path: String, name: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) != path:
			continue
		for granted: String in row[1]:
			if granted == name:
				return true
		return false
	return false


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
