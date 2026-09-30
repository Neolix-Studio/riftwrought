extends SceneTree
## Riftwrought — Roguelite Foundation G4 verification: repeated run-level
## coordination.
##
## ONE FOCUSED HEADLESS TEST. Foundation G4 is two pure-logic scripts under
## `scripts/levels/` — a run-level coordinator holding one run seed and one current
## one-level lifecycle, and the run-level record of one choice — plus one copying
## method on the accepted one-level receipt. It runs as a `SceneTree` script
## exactly as every earlier foundation suite does.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching its
## LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## EVERY "NOTHING MOVED" CLAIM COMPARES A WHOLE-RUN SNAPSHOT, and the snapshot
## reads every pair's RANK and every card's COUNT and MECHANICAL IDENTITY one by
## one — D-267 measured that the run build's own `describe()` renders two ranks of
## one pair as the same line.
##
## THE EXPECTED VALUES ARE STATED INDEPENDENTLY. Every requirement, root seed,
## level and retained experience below was calculated outside the engine from the
## two accepted formulas as the owner's briefs spell them, and typed here; the
## pairs, cards and ranks were measured against the accepted mechanisms before
## being written down. Neither formula is restated in this file: G1 and G2 are
## CALLED here only to show they agree with the literals, never to produce one.
##
## TWO STATES ARE REACHABLE ONLY BY FABRICATION, AND ONE OF THEM IS FABRICATED ON
## PURPOSE. A spent root seed cannot come round again inside one run for 2^32
## levels, so the spent-seed preflight is unreachable through the run's public
## interface. The verification therefore builds a one-level lifecycle holding a
## spent seed through the ACCEPTED `with_state()` seam and writes it into the run's
## private `_current` field by name — a test-only write; production has no seam for
## it. G1's and G2's refusals would need a lifecycle below Level 1 or hundreds of
## trillions of levels up, which no accepted constructor can build, so those two
## gates are proved STRUCTURALLY and reported as unreachable rather than given a
## manufactured assertion (D-247's rule).
##
## IT READS NO OTHER SUITE. It names no file under `tests/` but its own, which the
## runner asserts.

# --- The files ----------------------------------------------------------------------

const COORDINATOR_FILE: String = "res://scripts/levels/rift_run_level_coordinator.gd"
const RESULT_FILE: String = "res://scripts/levels/rift_run_level_up_result.gd"
const E2_COORDINATOR_FILE: String = "res://scripts/levels/rift_level_up_coordinator.gd"
const E2_RESULT_FILE: String = "res://scripts/levels/rift_level_up_result.gd"
const THIS_FILE: String = "res://tests/rift_run_level_coordinator_verification.gd"

const G4_FILES: Array[String] = [
	"res://scripts/levels/rift_run_level_coordinator.gd",
	"res://scripts/levels/rift_run_level_up_result.gd",
]

const G4_CLASSES: Array[String] = ["RiftRunLevelCoordinator", "RiftRunLevelUpResult"]

## THE ONLY FILES OUTSIDE G4 THAT MAY NAME A G4 CLASS, PER FILE AND PER CLASS.
## D-271: Foundation H1's Experience Mote is collected into a run through the
## coordinator's public award contract, so it is granted the coordinator — and
## not the run-level record, which it never sees. Nothing that runs creates a mote.
## D-275: Foundation H3's collection attempt is handed a run, asks it for a copy of
## its build, and hands it to the mote to be collected into. It is granted the
## coordinator for the same reason and, like the mote, never the run-level record.
## Nothing that runs calls the attempt.
## D-277: Foundation H4's drop is offered a run, compares the run's seed with its
## own, and hands the run to the attempt. It is granted the coordinator for the
## same reason and never the run-level record. Nothing that runs creates a drop.
## D-279: Foundation H5's field is swept into a run, compares the run's seed with
## its own, and hands the run to each of its drops. It is granted the coordinator
## for the same reason and never the run-level record. Nothing that runs creates a
## field.
## D-286: Foundation H8's Experience Mote runtime makes and owns the one run of its
## mote subsystem, reads its scalars and sweeps its field into it. It is granted the
## coordinator for the same reason and never the run-level record. Nothing that runs
## creates a runtime.
## D-291: Foundation I1 gave that runtime six one-line delegations to the run's own
## offer operations, and its lane choice hands back the run's own run-level record
## unchanged — so that one row, and no other, now grants the record as well.
## D-293: the Roguelite I2 Playable Three-Lane Level-Up Choice Review — an isolated
## scene launched by name — calls those delegations through the runtime it inherits
## to open its one offer and take one lane, and reads the run-level record the choice
## hands back. It is granted that record and never the coordinator.
const AUTHORIZED_READERS: Array = [
	["res://scripts/experience/rift_experience_mote.gd", ["RiftRunLevelCoordinator"]],
	["res://scripts/pickups/rift_mote_collection_attempt.gd", ["RiftRunLevelCoordinator"]],
	["res://scripts/pickups/rift_mote_drop.gd", ["RiftRunLevelCoordinator"]],
	["res://scripts/pickups/rift_mote_field.gd", ["RiftRunLevelCoordinator"]],
	["res://scripts/experience/rift_mote_runtime.gd", ["RiftRunLevelCoordinator", "RiftRunLevelUpResult"]],
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", ["RiftRunLevelUpResult"]],
]

## `scripts/levels/` after G4: E2's two scripts and G4's two, and nothing else.
const LEVEL_SCRIPTS: Array[String] = [
	"res://scripts/levels/rift_level_up_coordinator.gd",
	"res://scripts/levels/rift_level_up_result.gd",
	"res://scripts/levels/rift_run_level_coordinator.gd",
	"res://scripts/levels/rift_run_level_up_result.gd",
]

## Where G1 and G2 live. Their classes are found by this path in the engine's
## global class list, so the wiring measurement cannot pass by naming the wrong
## ones.
const G1_DIRECTORY: String = "res://scripts/level_requirements/"
const G2_DIRECTORY: String = "res://scripts/level_seeds/"

## D-288: the one file outside G4 that may name G1's classes — the Roguelite
## Experience Collection Greybox Review, an isolated scene launched by name, which
## asks G1 for the current level's requirement to display it. It names G1's two
## classes and no G2 class. Measured by the same single wiring assertion, whose
## pinned count does not move.
const EXPERIENCE_REVIEW_FILE: String = "res://scripts/roguelite/experience/roguelite_experience_collection_review.gd"

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]
const PROJECT_SETTINGS_FILE: String = "res://project.godot"

## THE ONLY PROJECT CLASSES EACH G4 FILE MAY NAME, PER FILE, and each must name
## every one of them. The result is refused the build, the ledger, the track's
## reading, every coordinator, the curve and every record type: a report of one
## choice needs the receipt it carries and the derivation that places it, and
## nothing else.
const AUTHORIZED_CLASSES: Array = [
	["res://scripts/levels/rift_run_level_coordinator.gd", [
		"RiftRunLevelCoordinator", "RiftRunLevelUpResult",
		"RiftLevelUpCoordinator", "RiftLevelUpResult",
		"RiftLevelRequirementCurve", "RiftLevelRequirementReading",
		"RiftLevelOfferSeedDerivation", "RiftLevelOfferSeedReading",
		"RiftExperienceReading", "RiftRunBuild", "RiftConsumptionLedger",
		"SkillTagProfile", "SupportDefinition", "PassiveCardDefinition",
	]],
	["res://scripts/levels/rift_run_level_up_result.gd", [
		"RiftRunLevelUpResult", "RiftLevelUpResult",
		"RiftLevelOfferSeedDerivation", "RiftLevelOfferSeedReading",
	]],
]

## THE COORDINATOR'S WHOLE STATE: TWO PRIVATE FIELDS AND NO THIRD.
const EXPECTED_COORDINATOR_FIELDS: Array[String] = ["_run_seed", "_current"]
const EXPECTED_RESULT_FIELDS: Array[String] = ["run_seed", "source_level", "_level_up"]

## Every method, in declaration order, with its full signature. The engine reports
## a constructor's return as an object, whatever the source declares — measured,
## and the one row this suite's first draft had wrong.
const EXPECTED_COORDINATOR_SIGNATURES: Array[String] = [
	"_init(for_run_seed: int) -> Object",
	"run_seed() -> int",
	"level() -> int",
	"experience() -> float",
	"requirement_reading() -> Object",
	"is_offer_active() -> bool",
	"offer_root_seed() -> int",
	"offer_lanes() -> type 28",
	"offer_identity_for(lane: int) -> type 34",
	## Roguelite I10 (decision D-312): two one-line delegations to the current
	## lifecycle's own readings of the standing offer, added in their place.
	"offer_support_content_kind() -> int",
	"offer_support_fallback_category() -> int",
	"frozen_requirement() -> float",
	"run_build() -> Object",
	"consumption_ledger() -> Object",
	"award_experience(base_experience: float) -> String",
	"open_current_offer(profiles: type 28, definitions: type 28, cards: type 28) -> String",
	"choose(lane: int) -> Object",
	"describe() -> String",
]
const EXPECTED_RESULT_SIGNATURES: Array[String] = [
	"recorded(for_run_seed: int, at_source_level: int, from_level_up: Object) -> Object",
	"succeeded() -> bool",
	"failure_reason() -> String",
	"level_up() -> Object",
	"problem() -> String",
	"describe() -> String",
	"_named_root() -> String",
]

## The accepted one-level receipt's surface, retyped from its accepted pin, and
## the ONE row G4 adds to it, in its place after `problem()`.
##
## ROGUELITE FOUNDATION I9 (decision D-310) extended the receipt by exactly two rows —
## `carries_support_fallback()` after `carries_support_progression()` and
## `support_fallback_line()` after `support_progression_line()` — and two appended
## fields, the Support content kind and the fallback category, which `duplicated()`
## must assign exactly as it assigns the others. The same assertions read the moved
## lists; G4's own row is still inserted after `problem()`.
const ACCEPTED_E2_RESULT_SIGNATURES: Array[String] = [
	"refused_without_a_seed(reason: String, requested_lane: int) -> Object",
	"refused(reason: String, for_root_seed: int, requested_lane: int) -> Object",
	"taken(from_choice: Object) -> Object",
	"granted_identity() -> type 34",
	"carries_support_progression() -> bool",
	"carries_support_fallback() -> bool",
	"problem() -> String",
	"identity_line() -> String",
	"support_progression_line() -> String",
	"support_fallback_line() -> String",
	"describe() -> String",
	"_stated(reason: String) -> String",
]
const ACCEPTED_E2_RESULT_FIELDS: Array[String] = [
	"ok", "failure_reason", "root_seed", "root_seed_known", "lane",
	"support_progression_kind", "support_rank_before", "support_rank_after",
	"_granted_identity",
	"support_content_kind", "support_fallback_category",
]
const COPY_SIGNATURE: String = "duplicated() -> Object"
const COPY_FOLLOWS: String = "problem() -> String"

## THE OPENING ORDER, AS THE CODE MUST SPELL IT, first occurrence to first
## occurrence inside `open_current_offer()`.
const OPENING_ORDER: Array[String] = [
	"_current.is_offer_active()",
	"requirement_reading()",
	"if not needed.ok:",
	"needed.experience_requirement()",
	"_current.reading_for(",
	"RiftLevelOfferSeedDerivation.offer_root_seed_for(",
	"if not seed_reading.ok:",
	"seed_reading.offer_root_seed",
	".has_consumed(root_seed)",
	"_current.open_offer(",
]

## Concrete Skill, support, card, catalogue and instrument names, plus the
## presentation and weight fields a record carries. Scanned RAW, comments
## included — D-215's lesson.
const FORBIDDEN_TOKENS: Array[String] = [
	"card_power", "card_celerity", "card_vitality",
	"card_fleetness", "card_insight", "card_magnetism",
	"display_name", "base_weight", "magnitude",
	"QuickStrike", "quick_strike", "Quick Strike",
	"reaching_edge", "Reaching Edge", "sweeping_edge", "Sweeping Edge",
	"Graveblade", "Riftmarked", "Expedition Blade", "Quickened",
	"SkillSupportCatalogue", "PassiveCardCatalogue", "AcquiredSupports",
	"SupportContinuation", "PlayerStat", "RiftExperienceTrack", "RiftOffer",
	"ExperienceTable", "CharacterState", "RogueliteUpgrade", "RogueliteRunPlan",
	"rank_for(", "with_state(",
]

## A pure coordinator reads no ambient state. Scanned raw.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
	"get_tree", "get_node",
]

## What the brief defers, as member-name tokens over CODE lines only — the files
## say in plain English what they do not do, and a raw scan would fire on the
## sentence making the claim (Gate 1C's lesson). Matched as identifier words: a
## letter or digit on either side breaks a match, an underscore does not.
const DEFERRED_MEMBER_TOKENS: Array[String] = [
	"queue", "pending", "auto", "loop", "history", "recursive",
	"mote", "enemy", "spawn", "save", "persist", "load", "reset", "clear",
	"death", "abandon", "resurrect", "withdraw", "cancel",
	"input", "scene", "node", "pause", "display", "generate",
	"effect", "apply", "actor", "balance", "signal", "await",
	"rank", "progression", "curve", "table", "mask", "fold", "step",
]

## G1's and G2's vocabulary. Neither formula may be restated here, so neither
## file may name one of its constants.
const FORMULA_TOKENS: Array[String] = [
	"BASE_REQUIREMENT", "REQUIREMENT_STEP", "MAX_SUPPORTED_LEVEL",
	"LARGEST_EXACT_REQUIREMENT", "EXACT_INTEGER_BITS",
	"MASK_32", "RUN_HIGH_FOLD_STEP", "LEVEL_STEP", "LARGEST_OFFER_ROOT_SEED",
	"UNSIGNED_SEED_BITS", "UNRESOLVED_SEED", "FIRST_LEVEL", "run_key", "level_index",
]

# --- The worked run, stated independently ------------------------------------------
#
# Calculated outside the engine from `requirement(level) = 100 + 25 x (level - 1)`
# and the frozen per-level derivation, and typed here.

const WORKED_SEED: int = 99
const WORKED_AWARD: float = 375.0
const WORKED_ROOTS: Array[int] = [99, 1000102, 2000105]
const WORKED_REQUIREMENTS: Array[int] = [100, 125, 150]
const WORKED_RETAINED: Array[float] = [275.0, 150.0, 0.0]
const LEVEL_FOUR_REQUIREMENT: int = 175

## Measured against the accepted mechanisms before being written here.
const SKILL: StringName = &"quick_strike"
const REACHING: StringName = &"reaching_edge"
const SWEEPING: StringName = &"sweeping_edge"
const SUPPORT_TAKEN: Array[StringName] = [&"sweeping_edge", &"reaching_edge", &"reaching_edge"]
const PASSIVE_LANES: Array[int] = [
	RiftOffer.Lane.COMBAT_DEFENCE, RiftOffer.Lane.UTILITY, RiftOffer.Lane.COMBAT_DEFENCE,
]
const PASSIVE_TAKEN: Array[StringName] = [&"card_celerity", &"card_magnetism", &"card_vitality"]

## The extreme run seeds, and their first two roots, calculated outside the
## engine. Run seed -1 at Level 2 wraps past 2^32.
const EXTREME_SEEDS: Array = [
	[-1, 4294901758, 934465],
	[9223372036854775807, 2147418110, 2148418113],
	[-9223372036854775808, 2147483648, 2148483651],
]

## The Experience Gain fixture: run seed 10 offers the shipped Experience Gain card
## in its Level 1 Utility lane.
const GAIN_SEED: int = 10
const GAIN_FIRST_AWARD: float = 150.0
const GAIN_KEPT: float = 50.0
const GAIN_SECOND_AWARD: float = 50.0
const GAIN_UNBOOSTED_TOTAL: float = 100.0

## The accepted refusal wordings this suite quotes, typed independently.
const E2_OFFER_OPEN_AWARD_REFUSAL: String = "an offer is open; it must be resolved before further experience is recorded"
const E2_NO_OFFER_REASON: String = "no offer is open; one must be opened before a lane may be taken"
const D3_SPENT_REASON: String = "root seed %d has already been consumed by this run"

const UNDECLARED_LANES: Array[int] = [7, -1, 3]
const UNRELATED_SPENT_SEED: int = 12345
const MISMATCHED_ROOT: int = 12345

const OWED_CHECKS: Array[String] = [
	"a_new_run_keeps_its_exact_seed_and_begins_one_fresh_lifecycle",
	"the_requirement_comes_from_g1_and_the_root_seed_from_g2_for_the_current_level",
	"three_explicit_choices_advance_three_levels_and_keep_every_surplus",
	"the_support_lane_takes_both_new_pairs_then_raises_a_held_pair",
	"every_derived_root_is_consumed_exactly_once_and_carried_forward",
	"passive_choices_grant_cards_and_carry_no_support_progression",
	"experience_gain_is_read_at_award_time_and_never_retroactive",
	"an_active_offer_blocks_awards_and_a_second_open",
	"a_refused_choice_keeps_the_same_lifecycle_its_offer_and_the_whole_run",
	"opening_waits_for_the_requirement_and_quotes_the_lifecycle_verbatim",
	"the_spent_seed_preflight_refuses_before_a_dead_offer_can_open",
	"refused_g1_and_g2_readings_cannot_reach_the_lifecycle",
	"the_run_record_carries_the_reproduction_pair_and_only_copies",
	"the_run_record_is_coherent_only_where_g2_derives_its_root",
	"extreme_run_seeds_keep_exact_provenance_through_g2",
	"returned_copies_cannot_move_the_run",
	"the_coordinator_holds_two_fields_and_restates_no_formula",
	"nothing_that_runs_calls_g4_and_the_directory_holds_four_scripts",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0
var _successes: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation G4 — Repeated Run-Level Coordination (D-269) ===")

	_check_a_new_run()
	_check_g1_and_g2_supply_the_current_level()
	_check_three_explicit_choices()
	_check_the_support_lane_continuation()
	_check_every_root_is_consumed_once()
	_check_passive_choices()
	_check_experience_gain()
	_check_an_active_offer_blocks()
	_check_a_refused_choice()
	_check_opening_waits_and_quotes()
	_check_the_spent_seed_preflight()
	_check_refused_readings_cannot_reach_e2()
	_check_the_record_carries_only_copies()
	_check_the_record_coherence()
	_check_extreme_run_seeds()
	_check_returned_copies()
	_check_the_coordinator_shape()
	_check_nothing_calls_g4()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT RUN LEVEL COORDINATOR VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT RUN LEVEL COORDINATOR VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. A new run ------------------------------------------------------------------

func _check_a_new_run() -> void:
	print("")
	print("--- 1. A new run keeps its exact seed and begins one fresh one-level lifecycle")
	var shown: PackedStringArray = PackedStringArray()
	for run_seed: int in [WORKED_SEED, 0, -1, 9223372036854775807, -9223372036854775808]:
		var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(run_seed)
		_expect(run.run_seed() == run_seed, "run seed %d reads back as %d" % [run_seed, run.run_seed()])
		_expect(run.get("_run_seed") == run_seed, "run seed %d is stored as %s" % [run_seed, str(run.get("_run_seed"))])
		_expect(run.level() == 1 and run.experience() == 0.0 and not run.is_offer_active()
				and run.offer_lanes().is_empty() and run.frozen_requirement() == 0.0
				and run.offer_root_seed() == RiftLevelUpCoordinator.UNSTATED_ROOT_SEED
				and run.run_build().is_empty() and run.consumption_ledger().is_empty(),
			"run seed %d does not begin fresh: %s" % [run_seed, _snapshot(run)])
		var needed: RiftLevelRequirementReading = run.requirement_reading()
		_expect(needed.ok and needed.level == 1 and needed.requirement == WORKED_REQUIREMENTS[0]
				and needed.experience_requirement() == float(WORKED_REQUIREMENTS[0]),
			"run seed %d's first requirement reads %s" % [run_seed, needed.describe()])
		var lifecycle: RiftLevelUpCoordinator = _lifecycle_of(run)
		_expect(lifecycle != null and not lifecycle.is_completed() and not lifecycle.is_offer_active(),
			"run seed %d's lifecycle is missing, completed or holds an offer" % run_seed)
		shown.append(str(run_seed))
	var first: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	var second: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_expect(_lifecycle_of(first) != _lifecycle_of(second),
		"two runs share one lifecycle")
	_expect(first.describe().begins_with("run seed 99; Level 1"),
		"a new run describes itself as: %s" % first.describe())
	print("  run seeds %s each read back exactly, at level=1 experience=0.0 offer=false with one unfinished lifecycle; the first requirement is 100"
		% ", ".join(shown))
	_done("a_new_run_keeps_its_exact_seed_and_begins_one_fresh_lifecycle")


# --- 2. G1 and G2 supply the current level -----------------------------------------

func _check_g1_and_g2_supply_the_current_level() -> void:
	print("")
	print("--- 2. The requirement comes from G1 and the root seed from G2, for the current level")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_expect_accepted(run.award_experience(WORKED_AWARD), "the worked award")
	var shown: PackedStringArray = PackedStringArray()
	for index: int in WORKED_ROOTS.size():
		var level: int = index + 1
		var needed: RiftLevelRequirementReading = run.requirement_reading()
		_expect(needed.ok and needed.level == level and needed.requirement == WORKED_REQUIREMENTS[index],
			"level %d requires %s, not %d" % [level, needed.describe(), WORKED_REQUIREMENTS[index]])
		## G1 AND G2 AGREE WITH THE LITERALS. Called only to show agreement.
		var curve: RiftLevelRequirementReading = RiftLevelRequirementCurve.requirement_for(level)
		var derived: RiftLevelOfferSeedReading = RiftLevelOfferSeedDerivation.offer_root_seed_for(
			WORKED_SEED, level)
		_expect(curve.ok and curve.requirement == WORKED_REQUIREMENTS[index]
				and derived.ok and derived.offer_root_seed == WORKED_ROOTS[index],
			"G1 or G2 disagrees with the independent literals at level %d" % level)
		_expect_accepted(_open(run), "the level %d offer" % level)
		_expect(run.is_offer_active() and run.offer_root_seed() == WORKED_ROOTS[index]
				and run.frozen_requirement() == float(WORKED_REQUIREMENTS[index])
				and run.level() == level,
			"level %d opened as %s" % [level, _snapshot(run)])
		shown.append("L%d %d/%d" % [level, WORKED_REQUIREMENTS[index], WORKED_ROOTS[index]])
		var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.SUPPORT)
		_expect_success(outcome, WORKED_SEED, level, WORKED_ROOTS[index], "the level %d choice" % level)
	print("  run seed 99, requirement/root per level: %s — each asked for the current level, never supplied"
		% ", ".join(shown))
	_done("the_requirement_comes_from_g1_and_the_root_seed_from_g2_for_the_current_level")


# --- 3. Three explicit choices -----------------------------------------------------

func _check_three_explicit_choices() -> void:
	print("")
	print("--- 3. Three explicit opens and choices advance exactly three levels, keeping every surplus")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_expect_accepted(run.award_experience(WORKED_AWARD), "the worked award")
	_expect(run.experience() == WORKED_AWARD and run.level() == 1,
		"the award left %s" % _snapshot(run))
	var shown: PackedStringArray = PackedStringArray()
	var surplus_held: int = 0
	for index: int in WORKED_ROOTS.size():
		var level: int = index + 1
		_expect(not run.is_offer_active(), "an offer stood before level %d's explicit open" % level)
		_expect_accepted(_open(run), "the level %d offer" % level)
		var source: RiftLevelUpCoordinator = _lifecycle_of(run)
		var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.SUPPORT)
		_expect_success(outcome, WORKED_SEED, level, WORKED_ROOTS[index], "the level %d choice" % level)

		## EXACTLY ONE LEVEL, EXACTLY ONE REQUIREMENT TAKEN OFF.
		_expect(run.level() == level + 1 and run.experience() == WORKED_RETAINED[index],
			"after level %d the run reads level %d with %s, not level %d with %s" % [
				level, run.level(), _exact(run.experience()), level + 1, _exact(WORKED_RETAINED[index])])

		## THE COMPLETED LIFECYCLE WAS REPLACED BY ONE FRESH ONE, AND IS NO LONGER THE RUN'S.
		var successor: RiftLevelUpCoordinator = _lifecycle_of(run)
		_expect(source.is_completed() and successor != source and successor != null
				and not successor.is_completed() and not successor.is_offer_active()
				and successor.frozen_requirement() == RiftLevelUpCoordinator.NO_REQUIREMENT,
			"after level %d the run holds %s" % [level, _snapshot(run)])
		_expect(source.level() == level + 1 and successor.level() == level + 1,
			"the source or the successor is not at level %d" % (level + 1))

		## SURPLUS NEVER ADVANCES BY ITSELF: ready again, and still nothing opened.
		var needed: RiftLevelRequirementReading = run.requirement_reading()
		if needed.ok and run.experience() >= needed.experience_requirement():
			surplus_held += 1
			_expect(not run.is_offer_active() and run.level() == level + 1,
				"a surplus meeting level %d's requirement advanced or opened by itself" % (level + 1))
		shown.append("L%d -> L%d with %s" % [level, run.level(), String.num(run.experience())])

	_expect(surplus_held == 2,
		"%d of the first two successors held a surplus meeting their own requirement, not 2" % surplus_held)
	var level_four: RiftLevelRequirementReading = run.requirement_reading()
	_expect(level_four.ok and level_four.requirement == LEVEL_FOUR_REQUIREMENT,
		"level 4 requires %s" % level_four.describe())
	var before: String = _snapshot(run)
	_expect_refused(_open(run), "level 4's open with nothing retained")
	_expect(_snapshot(run) == before, "the refused level 4 open moved the run")
	print("  375.0: %s; 2 successors already met their next requirement and neither advanced nor opened until asked; level 4 requires 175 and does not open"
		% "; ".join(shown))
	_done("three_explicit_choices_advance_three_levels_and_keep_every_surplus")


# --- 4. The support lane continuation ----------------------------------------------

func _check_the_support_lane_continuation() -> void:
	print("")
	print("--- 4. The Support lane takes both eligible new pairs, then raises a held pair")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_expect_accepted(run.award_experience(WORKED_AWARD), "the worked award")
	var shown: PackedStringArray = PackedStringArray()
	var new_pairs: PackedStringArray = PackedStringArray()
	for index: int in WORKED_ROOTS.size():
		_expect_accepted(_open(run), "offer %d" % (index + 1))
		var held_before: int = run.run_build().support_rank_for(SKILL, SUPPORT_TAKEN[index])
		var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.SUPPORT)
		var receipt: RiftLevelUpResult = outcome.level_up()
		var identity: PackedStringArray = receipt.granted_identity()
		_expect(identity.size() == 2 and StringName(identity[0]) == SKILL
				and StringName(identity[1]) == SUPPORT_TAKEN[index],
			"choice %d granted [%s]" % [index + 1, ", ".join(identity)])
		var build: RiftRunBuild = run.run_build()
		var rank_after: int = build.support_rank_for(SKILL, StringName(identity[1]))
		## THE FROZEN PROGRESSION AGREES WITH THE BUILD IT PRODUCED.
		_expect(receipt.carries_support_progression()
				and receipt.support_rank_before == held_before
				and receipt.support_rank_after == rank_after,
			"choice %d froze %d -> %d where the build moved %d -> %d" % [
				index + 1, receipt.support_rank_before, receipt.support_rank_after,
				held_before, rank_after])
		if index < 2:
			_expect(receipt.support_progression_kind == SupportContinuationResult.Kind.NEW_PAIR
					and held_before == 0 and rank_after == 1,
				"choice %d was not a new pair: %s" % [index + 1, receipt.support_progression_line()])
			new_pairs.append(identity[1])
		else:
			_expect(receipt.support_progression_kind == SupportContinuationResult.Kind.RANK_INCREASE
					and held_before == 1 and rank_after == 2,
				"choice 3 was not a rank increase of a held pair: %s" % receipt.support_progression_line())
		_expect(build.support_count() == mini(index + 1, 2) and build.total_support_ranks() == index + 1,
			"after choice %d the build holds %d pairs and %d ranks" % [
				index + 1, build.support_count(), build.total_support_ranks()])
		shown.append("%s %s" % [identity[1], receipt.support_progression_line()])

	## THE TWO NEW PAIRS ARE EXACTLY THE TWO THE SHIPPED CATALOGUE MAKES ELIGIBLE,
	## in whichever order the accepted selector owns.
	var eligible: PackedStringArray = PackedStringArray()
	for support: SupportEligibility in SkillSupportCatalogue.eligible_supports_for(
			SkillSupportCatalogue.skill_profile(SKILL)):
		eligible.append(String(support.support_id))
	eligible.sort()
	var taken: PackedStringArray = new_pairs.duplicate()
	taken.sort()
	_expect(eligible.size() == 2 and taken == eligible and new_pairs[0] != new_pairs[1],
		"the new pairs %s are not the eligible pairs %s" % [str(new_pairs), str(eligible)])
	var final_build: RiftRunBuild = run.run_build()
	_expect(final_build.support_rank_for(SKILL, REACHING) == 2
			and final_build.support_rank_for(SKILL, SWEEPING) == 1,
		"the run ends holding %s" % _held(run))
	print("  %s" % "; ".join(shown))
	_done("the_support_lane_takes_both_new_pairs_then_raises_a_held_pair")


# --- 5. Every root consumed once ---------------------------------------------------

func _check_every_root_is_consumed_once() -> void:
	print("")
	print("--- 5. Every derived root is consumed exactly once and carried forward")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_expect_accepted(run.award_experience(WORKED_AWARD), "the worked award")
	for index: int in WORKED_ROOTS.size():
		_expect(not run.consumption_ledger().has_consumed(WORKED_ROOTS[index]),
			"root %d was spent before its level" % WORKED_ROOTS[index])
		_expect_accepted(_open(run), "offer %d" % (index + 1))
		_expect(run.consumption_ledger().count() == index,
			"opening offer %d spent a seed" % (index + 1))
		var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.COMBAT_DEFENCE)
		_expect(outcome.succeeded(), "choice %d was refused: %s" % [index + 1, outcome.failure_reason()])
		var ledger: RiftConsumptionLedger = run.consumption_ledger()
		var expected: PackedInt64Array = PackedInt64Array()
		for spent: int in WORKED_ROOTS.slice(0, index + 1):
			expected.append(spent)
		expected.sort()
		_expect(ledger.consumed_seeds() == expected and ledger.count() == index + 1,
			"after choice %d the ledger reads %s" % [index + 1, ledger.describe()])
	var final_ledger: RiftConsumptionLedger = run.consumption_ledger()
	var appearances: int = 0
	for spent: int in final_ledger.consumed_seeds():
		if WORKED_ROOTS.has(spent):
			appearances += 1
	_expect(appearances == 3 and final_ledger.count() == 3,
		"the three roots appear %d times in %s" % [appearances, final_ledger.describe()])
	print("  %s; opening never spent a seed" % final_ledger.describe())
	_done("every_derived_root_is_consumed_exactly_once_and_carried_forward")


# --- 6. Passive choices -------------------------------------------------------------

func _check_passive_choices() -> void:
	print("")
	print("--- 6. Passive choices grant cards and carry no support progression")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_expect_accepted(run.award_experience(WORKED_AWARD), "the worked award")
	var shown: PackedStringArray = PackedStringArray()
	for index: int in PASSIVE_LANES.size():
		_expect_accepted(_open(run), "offer %d" % (index + 1))
		var outcome: RiftRunLevelUpResult = run.choose(PASSIVE_LANES[index])
		_expect_success(outcome, WORKED_SEED, index + 1, WORKED_ROOTS[index], "passive choice %d" % (index + 1))
		var receipt: RiftLevelUpResult = outcome.level_up()
		var identity: PackedStringArray = receipt.granted_identity()
		_expect(identity.size() == 1 and StringName(identity[0]) == PASSIVE_TAKEN[index],
			"passive choice %d granted [%s]" % [index + 1, ", ".join(identity)])
		_expect(not receipt.carries_support_progression()
				and receipt.support_progression_kind == RiftOffer.UNRESOLVED_PROGRESSION_KIND
				and receipt.support_rank_before == RiftOfferChoiceResult.NO_RANK
				and receipt.support_rank_after == RiftOfferChoiceResult.NO_RANK,
			"passive choice %d carries %s" % [index + 1, receipt.support_progression_line()])
		_expect(run.run_build().acquisitions_for(PASSIVE_TAKEN[index]) == 1
				and run.run_build().passive_acquisitions() == index + 1
				and run.run_build().support_count() == 0,
			"after passive choice %d the build reads %s" % [index + 1, run.run_build().describe()])
		_expect(run.experience() == WORKED_RETAINED[index],
			"passive choice %d kept %s" % [index + 1, _exact(run.experience())])
		shown.append(String(PASSIVE_TAKEN[index]))
	print("  %s: 3 cards, 0 pairs, no support progression on any receipt; the same levels and surplus as the Support run"
		% ", ".join(shown))
	_done("passive_choices_grant_cards_and_carry_no_support_progression")


# --- 7. Experience Gain -------------------------------------------------------------

func _check_experience_gain() -> void:
	print("")
	print("--- 7. Experience Gain is read at award time and is never retroactive")
	var gain_card: StringName = &""
	for record: PassiveCardDefinition in PassiveCardCatalogue.records():
		if record.stat_id == PlayerStats.EXPERIENCE_GAIN:
			gain_card = record.card_id
	_expect(gain_card != &"", "no shipped card grants Experience Gain")

	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(GAIN_SEED)
	_expect_accepted(run.award_experience(GAIN_FIRST_AWARD), "the first award")
	_expect_accepted(_open(run), "the gain offer")
	var offered: PackedStringArray = run.offer_identity_for(RiftOffer.Lane.UTILITY)
	_expect(offered.size() == 1 and StringName(offered[0]) == gain_card,
		"run seed 10's Utility lane offers [%s], not %s" % [", ".join(offered), gain_card])
	var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.UTILITY)
	_expect_success(outcome, GAIN_SEED, 1, GAIN_SEED, "the gain choice")

	## NOT RETROACTIVE: what was already held is exactly what it was.
	_expect(run.experience() == GAIN_KEPT, "taking the gain card moved the retained %s" % _exact(run.experience()))

	## REFUSED AWARDS MOVE NOTHING, EVEN WITH GAIN HELD.
	var before: String = _snapshot(run)
	for refused: float in [-5.0, 0.0, INF, NAN]:
		_expect_refused(run.award_experience(refused), "an award of %s" % str(refused))
		_expect(_snapshot(run) == before, "a refused award of %s moved the run" % str(refused))

	## READ AT AWARD TIME: the next award is boosted, exactly as an independent
	## accepted track is when handed the same build's totals at the same moment.
	_expect_accepted(run.award_experience(GAIN_SECOND_AWARD), "the boosted award")
	var independent: RiftExperienceTrack = RiftExperienceTrack.new()
	_expect_accepted(independent.award(GAIN_FIRST_AWARD, PlayerStatTotals.new()), "the independent award")
	_expect_accepted(independent.advance_one_level(float(WORKED_REQUIREMENTS[0])), "the independent advance")
	_expect_accepted(independent.award(GAIN_SECOND_AWARD, run.run_build().stat_totals()), "the independent boosted award")
	_expect(run.experience() == independent.progress() and run.experience() != GAIN_UNBOOSTED_TOTAL,
		"the boosted total is %s where an independent track reads %s (unboosted %s)" % [
			_exact(run.experience()), _exact(independent.progress()), _exact(GAIN_UNBOOSTED_TOTAL)])
	print("  run seed 10 took %s at level 1; 50.0 retained stayed %s; 4 refused awards moved nothing; the next 50 came to %s, equal to an independent track"
		% [gain_card, _exact(GAIN_KEPT), _exact(run.experience())])
	_done("experience_gain_is_read_at_award_time_and_never_retroactive")


# --- 8. An active offer blocks ------------------------------------------------------

func _check_an_active_offer_blocks() -> void:
	print("")
	print("--- 8. An active offer blocks awards and a second open")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_expect_accepted(run.award_experience(WORKED_AWARD), "the worked award")
	_expect_accepted(_open(run), "the offer")
	var lifecycle: RiftLevelUpCoordinator = _lifecycle_of(run)
	var before: String = _snapshot(run)
	var award: String = run.award_experience(50.0)
	_expect_refused(award, "an award while the offer stands")
	_expect(award == E2_OFFER_OPEN_AWARD_REFUSAL, "the award refusal was restated: %s" % award)
	var second: String = _open(run)
	_expect_refused(second, "a second open while the offer stands")
	_expect(second.contains("already has an offer open"), "the second open refused with: %s" % second)
	_expect(_snapshot(run) == before and _lifecycle_of(run) == lifecycle,
		"a blocked operation moved the run:\n    before %s\n    after  %s" % [before, _snapshot(run)])
	var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.UTILITY)
	_expect_success(outcome, WORKED_SEED, 1, WORKED_ROOTS[0], "the lane of the standing offer")
	print("  2 operations refused while the offer stood; the award quoted verbatim; the same offer then paid out")
	_done("an_active_offer_blocks_awards_and_a_second_open")


# --- 9. A refused choice ------------------------------------------------------------

func _check_a_refused_choice() -> void:
	print("")
	print("--- 9. A refused choice keeps the same lifecycle, its offer, and the whole run")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_expect_accepted(run.award_experience(WORKED_AWARD), "the worked award")

	## NO OFFER YET: a refusal that knows no root, still placed in the run.
	var lifecycle: RiftLevelUpCoordinator = _lifecycle_of(run)
	var before: String = _snapshot(run)
	var early: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.SUPPORT)
	_refusals += 1
	_expect(not early.succeeded() and early.failure_reason() == E2_NO_OFFER_REASON
			and early.run_seed == WORKED_SEED and early.source_level == 1
			and not early.level_up().root_seed_known and early.problem().is_empty(),
		"a choice with no offer answered %s / '%s'" % [early.describe(), early.problem()])
	_expect(_snapshot(run) == before and _lifecycle_of(run) == lifecycle,
		"a choice with no offer moved the run")

	## WITH AN OFFER: every undeclared lane refused, the offer kept.
	_expect_accepted(_open(run), "the offer")
	before = _snapshot(run)
	for lane: int in UNDECLARED_LANES:
		var refused: RiftRunLevelUpResult = run.choose(lane)
		_refusals += 1
		var receipt: RiftLevelUpResult = refused.level_up()
		_expect(not refused.succeeded() and not refused.failure_reason().is_empty()
				and refused.run_seed == WORKED_SEED and refused.source_level == 1
				and receipt.root_seed_known and receipt.root_seed == WORKED_ROOTS[0]
				and receipt.lane == lane and receipt.granted_identity().is_empty()
				and refused.problem().is_empty(),
			"lane %d answered %s / '%s'" % [lane, refused.describe(), refused.problem()])
		_expect(_snapshot(run) == before and _lifecycle_of(run) == lifecycle and run.is_offer_active(),
			"the refusal of lane %d moved the run:\n    before %s\n    after  %s" % [
				lane, before, _snapshot(run)])
	var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.SUPPORT)
	_expect_success(outcome, WORKED_SEED, 1, WORKED_ROOTS[0], "the declared lane after three refusals")
	_expect(_lifecycle_of(run) != lifecycle, "the successful choice kept the completed lifecycle")
	print("  1 refusal with no offer and %d undeclared lanes refused; each carried run seed 99 at level 1, nothing moved, the same offer then paid out"
		% UNDECLARED_LANES.size())
	_done("a_refused_choice_keeps_the_same_lifecycle_its_offer_and_the_whole_run")


# --- 10. Opening waits, and quotes ---------------------------------------------------

func _check_opening_waits_and_quotes() -> void:
	print("")
	print("--- 10. Opening waits for the requirement and quotes the lifecycle verbatim")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_expect_accepted(run.award_experience(75.0), "a short award")
	var before: String = _snapshot(run)
	var short: String = _open(run)
	_expect_refused(short, "an open 25 short")
	var track: RiftExperienceTrack = RiftExperienceTrack.new()
	_expect_accepted(track.award(75.0, PlayerStatTotals.new()), "the independent short award")
	var quoted: String = "no offer opens yet for level 1 — %s" % track.reading_for(100.0).describe()
	_expect(short == quoted, "the short open refused with '%s', not '%s'" % [short, quoted])
	_expect(_snapshot(run) == before and run.consumption_ledger().is_empty(),
		"the short open moved the run")

	## A COMPOSITION REFUSAL IS THE LIFECYCLE'S OWN, returned verbatim — and it is
	## exactly what the accepted one-level coordinator answers for the same state,
	## requirement and root seed.
	_expect_accepted(run.award_experience(25.0), "the completing award")
	var no_cards: Array[PassiveCardDefinition] = []
	before = _snapshot(run)
	var composed: String = run.open_current_offer(
		SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(), no_cards)
	_expect_refused(composed, "an open with no card records")
	var alone: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()
	_expect_accepted(alone.award_experience(100.0), "the independent lifecycle's award")
	var direct: String = alone.open_offer(100.0, SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(), no_cards, WORKED_ROOTS[0])
	_expect(composed == direct and composed.begins_with("no offer composed: "),
		"the composition refusal reads '%s' where the lifecycle answers '%s'" % [composed, direct])
	_expect(_snapshot(run) == before and not run.is_offer_active(), "the composition refusal moved the run")
	_expect_accepted(_open(run), "the open once everything is supplied")
	print("  a short open quoted the track's own reading; a composition refusal equalled the one-level coordinator's own; nothing moved; the open then succeeded")
	_done("opening_waits_for_the_requirement_and_quotes_the_lifecycle_verbatim")


# --- 11. The spent-seed preflight ----------------------------------------------------

func _check_the_spent_seed_preflight() -> void:
	print("")
	print("--- 11. The spent-seed preflight refuses before a dead offer can open")

	## WHY IT EXISTS, MEASURED ON THE ACCEPTED ONE-LEVEL COORDINATOR ALONE: it opens
	## an offer on a spent seed, and then no lane of it can ever be taken (D-267).
	var alone: RiftLevelUpCoordinator = _spent_lifecycle(WORKED_ROOTS[0])
	_expect_accepted(alone.open_offer(100.0, SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(), PassiveCardCatalogue.records(), WORKED_ROOTS[0]),
		"the one-level coordinator opening on its own spent seed")
	var dead: int = 0
	for lane: int in [RiftOffer.Lane.SUPPORT, RiftOffer.Lane.COMBAT_DEFENCE, RiftOffer.Lane.UTILITY]:
		var outcome: RiftLevelUpResult = alone.choose(lane)
		if not outcome.ok and outcome.failure_reason == D3_SPENT_REASON % WORKED_ROOTS[0]:
			dead += 1
	_expect(dead == 3 and alone.is_offer_active(), "the control offer is not dead: %d lanes refused" % dead)

	## THE RUN REFUSES THE SAME STATE BEFORE ASKING THE LIFECYCLE TO OPEN. The
	## lifecycle is built through the accepted seam and written into the private
	## field by name: a test-only write, because no run can reach it for 2^32 levels.
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	var installed: RiftLevelUpCoordinator = _spent_lifecycle(WORKED_ROOTS[0])
	run.set("_current", installed)
	_expect(_lifecycle_of(run) == installed, "the fabricated lifecycle was not installed")
	var before: String = _snapshot(run)
	var refusal: String = _open(run)
	_expect_refused(refusal, "an open on a spent derived seed")
	_expect(refusal == "level 1's offer root seed 99 has already been consumed by this run; no offer opens",
		"the preflight refused with: %s" % refusal)
	_expect(not run.is_offer_active() and not installed.is_offer_active()
			and _snapshot(run) == before and _lifecycle_of(run) == installed,
		"the preflight left an offer or moved the run:\n    before %s\n    after  %s" % [before, _snapshot(run)])

	## POSITIVE CONTROL: the same fabrication with an UNRELATED spent seed opens, at
	## the derived root — so the refusal was caused by the seed, not by the fabrication.
	var control: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	control.set("_current", _spent_lifecycle(UNRELATED_SPENT_SEED))
	_expect_accepted(_open(control), "the control open")
	_expect(control.is_offer_active() and control.offer_root_seed() == WORKED_ROOTS[0],
		"the control opened at %d" % control.offer_root_seed())
	var paid: RiftRunLevelUpResult = control.choose(RiftOffer.Lane.UTILITY)
	_expect_success(paid, WORKED_SEED, 1, WORKED_ROOTS[0], "the control's choice")

	## AND THE ORDER, STRUCTURALLY: see check 12, which pins it for every gate.
	print("  the one-level coordinator alone opened on spent seed 99 and refused all 3 lanes; the run refused that state before opening, left no offer and moved nothing; an unrelated spent seed opened at 99 and paid out")
	_done("the_spent_seed_preflight_refuses_before_a_dead_offer_can_open")


# --- 12. Refused G1 and G2 readings --------------------------------------------------

func _check_refused_readings_cannot_reach_e2() -> void:
	print("")
	print("--- 12. Refused G1 and G2 readings cannot reach the lifecycle, and the order is pinned")
	var code: String = _code_only(FileAccess.get_file_as_string(COORDINATOR_FILE))
	var body: PackedStringArray = _method_code(code, "func open_current_offer(")
	var text: String = "\n".join(body)
	_expect(body.size() > 10, "open_current_offer() read as %d lines" % body.size())

	## EVERY GATE IN ITS PLACE, AND EACH EXACTLY ONCE.
	var positions: Array[int] = []
	var repeated: PackedStringArray = PackedStringArray()
	for marker: String in OPENING_ORDER:
		positions.append(text.find(marker))
		if text.count(marker) != 1:
			repeated.append("%s x%d" % [marker, text.count(marker)])
	var ordered: bool = not positions.has(-1)
	for index: int in range(1, positions.size()):
		if positions[index] <= positions[index - 1]:
			ordered = false
	_expect(ordered and repeated.is_empty(),
		"the opening order is %s; repeated or missing: %s" % [str(positions), ", ".join(repeated)])

	## EACH REFUSING GATE RETURNS ON THE VERY NEXT LINE, before anything it guards.
	var gates: Array[String] = ["if _current.is_offer_active():", "if not needed.ok:",
		"if not (readiness.ok and readiness.ready):", "if not seed_reading.ok:",
		"if _current.consumption_ledger().has_consumed(root_seed):"]
	for gate: String in gates:
		var at: int = body.find(gate)
		_expect(at >= 0 and at + 1 < body.size() and body[at + 1].begins_with("return "),
			"the gate '%s' does not refuse on the next line" % gate)
	## THE REFUSED READINGS' REASONS ARE QUOTED, NOT RESTATED.
	_expect(text.contains("needed.failure_reason") and text.contains("seed_reading.failure_reason"),
		"a refused reading's own reason is not quoted")
	## THE STAND-INS ARE NEVER READ ANYWHERE ELSE: the requirement is converted once
	## and the derived seed read once, each only after its `ok`.
	var field_reads: int = RegEx.create_from_string(
		"\\.offer_root_seed(?![A-Za-z0-9_(])").search_all(code).size()
	_expect(code.count("experience_requirement()") == 1 and field_reads == 1
			and code.count("seed_reading.offer_root_seed") == 1,
		"a reading's value is read %d times or outside its gate" % field_reads)
	## THE LIFECYCLE IS ASKED TO OPEN WITH EXACTLY THE REQUIREMENT AND SEED JUST DERIVED.
	_expect(body[body.size() - 1] == "return _current.open_offer(requirement, profiles, definitions, cards, root_seed)",
		"the method ends: %s" % body[body.size() - 1])

	## WHY THE TWO READING GATES ARE UNREACHABLE TODAY, MEASURED. G2 refuses only
	## below Level 1, and G1 refuses every one of those first; a lifecycle begins at
	## Level 1 and gains one level per choice, and the first level G1 refuses above
	## it is its representation boundary.
	var shadowed: int = 0
	for level: int in [0, -1, -9223372036854775808]:
		if not RiftLevelRequirementCurve.requirement_for(level).ok \
				and not RiftLevelOfferSeedDerivation.offer_root_seed_for(WORKED_SEED, level).ok:
			shadowed += 1
	_expect(shadowed == 3, "%d of 3 sub-first levels are refused by both G1 and G2" % shadowed)
	_expect(RiftLevelRequirementCurve.requirement_for(1).ok
			and RiftLevelOfferSeedDerivation.offer_root_seed_for(WORKED_SEED, 1).ok
			and RiftLevelRequirementCurve.requirement_for(RiftLevelRequirementCurve.MAX_SUPPORTED_LEVEL).ok,
		"G1 or G2 refuses a level a run can hold")
	print("  %d opening steps in order, each once; %d refusing gates each return on the next line; both readings' reasons quoted; the G2 refusal is shadowed by G1 at all 3 sub-first levels asked"
		% [OPENING_ORDER.size(), gates.size()])
	_done("refused_g1_and_g2_readings_cannot_reach_the_lifecycle")


# --- 13. The record carries only copies ---------------------------------------------

func _check_the_record_carries_only_copies() -> void:
	print("")
	print("--- 13. The run record carries the reproduction pair and only copies of its receipt")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_expect_accepted(run.award_experience(WORKED_AWARD), "the worked award")
	var no_offer: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.SUPPORT)
	_expect_accepted(_open(run), "the offer")
	var refused: RiftRunLevelUpResult = run.choose(7)
	var support: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.SUPPORT)
	_expect_accepted(_open(run), "the second offer")
	var passive: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.UTILITY)

	## THE RECEIPT'S OWN COPY: every field, and an independent identity.
	var copied: int = 0
	for record: RiftRunLevelUpResult in [no_offer, refused, support, passive]:
		var original: RiftLevelUpResult = record.level_up()
		var copy: RiftLevelUpResult = original.duplicated()
		_expect(copy != original and _receipt_fields(copy) == _receipt_fields(original)
				and copy.problem() == original.problem(),
			"the copy of %s reads %s" % [_receipt_fields(original), _receipt_fields(copy)])
		## BOTH PRIVATE ARRAYS ARE MUTATED IN PLACE, and each mutation is proved to
		## have happened, so "neither sees the other's" is not a claim about nothing.
		copy._granted_identity.append("zz_copy_extra")
		original._granted_identity.append("zz_original_extra")
		_expect(copy.granted_identity().has("zz_copy_extra")
				and original.granted_identity().has("zz_original_extra")
				and not copy.granted_identity().has("zz_original_extra")
				and not original.granted_identity().has("zz_copy_extra"),
			"a receipt and its copy share an identity array")
		copied += 1
	## A COPY COPIES AND JUDGES NOTHING: an incoherent receipt stays incoherent.
	var tampered: RiftLevelUpResult = support.level_up()
	tampered.failure_reason = "zz tampered"
	_expect(not tampered.problem().is_empty() and tampered.duplicated().problem() == tampered.problem(),
		"copying an incoherent receipt changed its verdict")

	## THE RECORD: constructor input, stored value and returned value all independent.
	var input: RiftLevelUpResult = support.level_up()
	var record: RiftRunLevelUpResult = RiftRunLevelUpResult.recorded(WORKED_SEED, 1, input)
	var line: String = _receipt_fields(record.level_up())
	input.ok = false
	input.root_seed = 5
	input.lane = 9
	input.support_rank_after = 99
	input._granted_identity.append("zz_input_extra")
	_expect(input.granted_identity().has("zz_input_extra") and _receipt_fields(input) != line,
		"the constructor's input was not actually mutated")
	_expect(_receipt_fields(record.level_up()) == line and record.problem().is_empty()
			and record.succeeded(),
		"mutating the constructor's input moved the record to %s" % _receipt_fields(record.level_up()))
	var handed: RiftLevelUpResult = record.level_up()
	handed.ok = false
	handed.failure_reason = "zz rewritten"
	handed._granted_identity.append("zz_handed_extra")
	_expect(handed.granted_identity().has("zz_handed_extra") and _receipt_fields(handed) != line,
		"the handed-out receipt was not actually mutated")
	_expect(_receipt_fields(record.level_up()) == line and record.level_up() != record.level_up()
			and record.level_up() != handed,
		"a returned receipt reached the stored one")
	_expect(record.get("_level_up") != input and record.get("_level_up") != handed,
		"the record stores a receipt somebody else holds")

	## SUCCESS AND REFUSAL READINGS COME FROM THE RECEIPT, AND A RECORD OF NOTHING SAYS SO.
	_expect(support.succeeded() and support.failure_reason().is_empty()
			and not refused.succeeded() and refused.failure_reason() == refused.level_up().failure_reason,
		"the readings disagree with the receipts")
	var empty: RiftRunLevelUpResult = RiftRunLevelUpResult.recorded(WORKED_SEED, 1, null)
	_expect(empty.level_up() == null and not empty.succeeded() and not empty.failure_reason().is_empty()
			and not empty.problem().is_empty(),
		"a record of nothing answered succeeded=%s '%s'" % [empty.succeeded(), empty.problem()])

	## THE RECORD HOLDS TWO SCALARS AND ONE PRIVATE RECEIPT — NO LIVE NESTED VALUE.
	var fields: PackedStringArray = _fields_of(record)
	var objects: PackedStringArray = PackedStringArray()
	for entry: Dictionary in record.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0 \
				and int(entry.get("type", TYPE_NIL)) == TYPE_OBJECT:
			objects.append(String(entry.get("name", "")))
	_expect(", ".join(fields) == ", ".join(PackedStringArray(EXPECTED_RESULT_FIELDS))
			and ", ".join(objects) == "_level_up",
		"the record carries %s with object fields %s" % [", ".join(fields), ", ".join(objects)])
	print("  %d receipts copied field for field with independent identities; the record's input, store and hand-out are three separate receipts; a record of nothing is incoherent"
		% copied)
	_done("the_run_record_carries_the_reproduction_pair_and_only_copies")


# --- 14. Record coherence -------------------------------------------------------------

func _check_the_record_coherence() -> void:
	print("")
	print("--- 14. The run record is coherent only where G2 derives its root")
	var caught: int = 0
	var coherent: int = 0

	## GENUINE RECORDS ARE COHERENT.
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_expect_accepted(run.award_experience(WORKED_AWARD), "the worked award")
	_expect_accepted(_open(run), "the first offer")
	var first: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.SUPPORT)
	_expect_accepted(_open(run), "the second offer")
	var second: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.SUPPORT)
	for record: RiftRunLevelUpResult in [first, second]:
		_expect(record.problem().is_empty(), "a genuine record is incoherent: %s" % record.problem())
		coherent += 1

	## A SUCCESS FROM ANOTHER ROOT: incoherent at run seed 99, coherent at the run
	## seed that derives that root.
	var elsewhere: RiftLevelUpResult = _success_at_root(MISMATCHED_ROOT)
	_expect_incoherent(RiftRunLevelUpResult.recorded(WORKED_SEED, 1, elsewhere), "derives root seed 99", "a success from root 12345 at run seed 99")
	caught += 1
	_expect(RiftRunLevelUpResult.recorded(MISMATCHED_ROOT, 1, elsewhere).problem().is_empty(),
		"a success from root 12345 at run seed 12345, level 1, is incoherent")
	coherent += 1

	## A REFUSAL THAT KNOWS A ROOT MUST KNOW THE DERIVED ONE; ONE THAT KNOWS NONE IS
	## COHERENT FOR ANY RUN SEED.
	_expect_incoherent(RiftRunLevelUpResult.recorded(WORKED_SEED, 1,
		RiftLevelUpResult.refused("zz refused", 5, 7)), "names root seed 5", "a refusal naming the wrong root")
	caught += 1
	_expect(RiftRunLevelUpResult.recorded(5, 1, RiftLevelUpResult.refused("zz refused", 5, 7)).problem().is_empty(),
		"a refusal naming the derived root is incoherent")
	coherent += 1
	for run_seed: int in [WORKED_SEED, -1, 9223372036854775807]:
		_expect(RiftRunLevelUpResult.recorded(run_seed, 3,
			RiftLevelUpResult.refused_without_a_seed("zz before any offer", 1)).problem().is_empty(),
			"a refusal knowing no root is incoherent at run seed %d" % run_seed)
		coherent += 1

	## THE SOURCE LEVEL, THE RECEIPT AND THE RECEIPT'S OWN RULE.
	for level: int in [0, -1]:
		_expect_incoherent(RiftRunLevelUpResult.recorded(WORKED_SEED, level, first.level_up()),
			"positive level", "source level %d" % level)
		caught += 1
	_expect_incoherent(RiftRunLevelUpResult.recorded(WORKED_SEED, 1, null), "must carry", "no receipt")
	caught += 1
	var broken: RiftLevelUpResult = first.level_up()
	broken.failure_reason = "zz tampered"
	_expect_incoherent(RiftRunLevelUpResult.recorded(WORKED_SEED, 1, broken), "incoherent", "an incoherent receipt")
	caught += 1

	## TAMPERED PROVENANCE ON A GENUINE RECORD, each restored to coherence.
	second.run_seed = WORKED_SEED + 1
	_expect_incoherent(second, "derives root seed", "a record whose run seed moved")
	caught += 1
	second.run_seed = WORKED_SEED
	second.source_level = 3
	_expect_incoherent(second, "derives root seed", "a record whose source level moved")
	caught += 1
	second.source_level = 2
	_expect(second.problem().is_empty(), "the restored record is incoherent: %s" % second.problem())
	coherent += 1

	## THE RE-DERIVATION IS G2's, INCLUDING ITS WRAP: run seed -1 at Level 2.
	var wrapped: RiftLevelUpResult = _success_at_root(934465)
	_expect(RiftRunLevelUpResult.recorded(-1, 2, wrapped).problem().is_empty(),
		"root 934465 is not coherent at run seed -1, level 2")
	coherent += 1
	print("  %d contradictions caught by problem(); %d coherent records, including refusals that know no root and G2's wrap at run seed -1, level 2"
		% [caught, coherent])
	_done("the_run_record_is_coherent_only_where_g2_derives_its_root")


# --- 15. Extreme run seeds -------------------------------------------------------------

func _check_extreme_run_seeds() -> void:
	print("")
	print("--- 15. Negative and maximum signed run seeds keep exact provenance through G2")
	var shown: PackedStringArray = PackedStringArray()
	for row: Array in EXTREME_SEEDS:
		var run_seed: int = int(row[0])
		var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(run_seed)
		_expect_accepted(run.award_experience(225.0), "run seed %d's award" % run_seed)
		for index: int in 2:
			_expect_accepted(_open(run), "run seed %d's level %d offer" % [run_seed, index + 1])
			_expect(run.offer_root_seed() == int(row[index + 1]),
				"run seed %d at level %d opened at %d, not %d" % [
					run_seed, index + 1, run.offer_root_seed(), int(row[index + 1])])
			var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.COMBAT_DEFENCE)
			_expect_success(outcome, run_seed, index + 1, int(row[index + 1]),
				"run seed %d's level %d choice" % [run_seed, index + 1])
		_expect(run.run_seed() == run_seed and run.level() == 3 and run.experience() == 0.0,
			"run seed %d ended at %s" % [run_seed, _snapshot(run)])
		var expected: PackedInt64Array = PackedInt64Array([int(row[1]), int(row[2])])
		expected.sort()
		_expect(run.consumption_ledger().consumed_seeds() == expected,
			"run seed %d spent %s" % [run_seed, run.consumption_ledger().describe()])
		shown.append("%d -> %d, %d" % [run_seed, int(row[1]), int(row[2])])
	print("  %s; every record kept its run seed unmasked" % "; ".join(shown))
	_done("extreme_run_seeds_keep_exact_provenance_through_g2")


# --- 16. Returned copies ------------------------------------------------------------------

func _check_returned_copies() -> void:
	print("")
	print("--- 16. Returned copies cannot move the run")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_expect_accepted(run.award_experience(WORKED_AWARD), "the worked award")
	_expect_accepted(_open(run), "the first offer")
	_expect(run.choose(RiftOffer.Lane.SUPPORT).succeeded(), "the first choice was refused")
	_expect_accepted(_open(run), "the second offer")
	var before: String = _snapshot(run)
	var mutations: int = 0

	var build: RiftRunBuild = run.run_build()
	_expect_accepted(build.acquire_passive_card(PassiveCardCatalogue.records()[0]), "mutating a build copy")
	mutations += 1
	var ledger: RiftConsumptionLedger = run.consumption_ledger()
	_expect(ledger.consume(777), "mutating a ledger copy")
	mutations += 1
	var lanes: Array[int] = run.offer_lanes()
	lanes.reverse()
	lanes.append(7)
	mutations += 1
	var identity: PackedStringArray = run.offer_identity_for(RiftOffer.Lane.SUPPORT)
	identity.append("zz_extra")
	mutations += 1
	var needed: RiftLevelRequirementReading = run.requirement_reading()
	needed.requirement = 1
	mutations += 1
	_expect(_snapshot(run) == before and run.requirement_reading().requirement == WORKED_REQUIREMENTS[1],
		"a returned copy moved the run:\n    before %s\n    after  %s" % [before, _snapshot(run)])
	_expect(run.run_build() != run.run_build() and run.consumption_ledger() != run.consumption_ledger()
			and run.requirement_reading() != run.requirement_reading(),
		"two readings answered one object")
	print("  %d handed-out copies mutated — build, ledger, lanes, identity, requirement reading — and the run did not move"
		% mutations)
	_done("returned_copies_cannot_move_the_run")


# --- 17. The shape ------------------------------------------------------------------------

func _check_the_coordinator_shape() -> void:
	print("")
	print("--- 17. The coordinator holds two fields, delegates every reading and restates no formula")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	var fields: PackedStringArray = _fields_of(run)
	_expect(", ".join(fields) == ", ".join(PackedStringArray(EXPECTED_COORDINATOR_FIELDS)),
		"the coordinator carries the fields: %s" % ", ".join(fields))
	var signatures: PackedStringArray = _signatures_of(COORDINATOR_FILE)
	_expect(", ".join(signatures) == ", ".join(PackedStringArray(EXPECTED_COORDINATOR_SIGNATURES)),
		"the coordinator declares: %s" % ", ".join(signatures))
	var result_signatures: PackedStringArray = _signatures_of(RESULT_FILE)
	_expect(", ".join(result_signatures) == ", ".join(PackedStringArray(EXPECTED_RESULT_SIGNATURES)),
		"the record declares: %s" % ", ".join(result_signatures))

	## THE ONE-LEVEL RECEIPT GAINED EXACTLY ONE MEMBER, IN ITS PLACE, AND NO FIELD.
	var e2_signatures: PackedStringArray = _signatures_of(E2_RESULT_FILE)
	var expected_e2: PackedStringArray = PackedStringArray(ACCEPTED_E2_RESULT_SIGNATURES)
	expected_e2.insert(expected_e2.find(COPY_FOLLOWS) + 1, COPY_SIGNATURE)
	_expect(", ".join(e2_signatures) == ", ".join(expected_e2),
		"the one-level receipt declares: %s" % ", ".join(e2_signatures))
	_expect(", ".join(_fields_of(RiftLevelUpResult.new())) == ", ".join(PackedStringArray(ACCEPTED_E2_RESULT_FIELDS)),
		"the one-level receipt carries: %s" % ", ".join(_fields_of(RiftLevelUpResult.new())))
	var copy_code: PackedStringArray = _method_code(
		_code_only(FileAccess.get_file_as_string(E2_RESULT_FILE)), "func duplicated(")
	var assigned: int = 0
	for field: String in ACCEPTED_E2_RESULT_FIELDS:
		for line: String in copy_code:
			if line.begins_with("copy.%s = " % field):
				assigned += 1
	_expect(assigned == ACCEPTED_E2_RESULT_FIELDS.size()
			and copy_code.has("copy._granted_identity = _granted_identity.duplicate()"),
		"duplicated() assigns %d of %d fields, or shares the identity" % [assigned, ACCEPTED_E2_RESULT_FIELDS.size()])

	## PER-FILE CLASS ALLOWLIST FROM THE ENGINE'S OWN CLASS LIST, BOTH DIRECTIONS.
	var all_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		all_classes.append(String(entry.get("class", "")))
	_expect(all_classes.size() > 100, "only %d project classes were enumerated" % all_classes.size())
	for row: Array in AUTHORIZED_CLASSES:
		var raw: String = FileAccess.get_file_as_string(String(row[0]))
		var outside: PackedStringArray = PackedStringArray()
		var unearned: PackedStringArray = PackedStringArray()
		for class_id: String in all_classes:
			if raw.contains(class_id) and not (row[1] as Array).has(class_id):
				outside.append(class_id)
		for class_id: String in row[1]:
			if not raw.contains(class_id):
				unearned.append(class_id)
		_expect(outside.is_empty() and unearned.is_empty(),
			"%s names unauthorized [%s] or is granted but does not name [%s]" % [
				String(row[0]).get_file(), ", ".join(outside), ", ".join(unearned)])

	## SCANS: concrete names and ambient reads raw; deferred members, formula
	## vocabulary, arithmetic, bit operations, numeric literals and loops in code.
	var shown: PackedStringArray = PackedStringArray()
	for path: String in G4_FILES:
		var raw: String = FileAccess.get_file_as_string(path)
		var code: String = _code_only(raw)
		_expect(raw.length() > 2000 and code.length() > 500 and code.length() < raw.length(),
			"%s read as %d / %d characters" % [path.get_file(), raw.length(), code.length()])
		var hits: PackedStringArray = PackedStringArray()
		for token: String in FORBIDDEN_TOKENS + AMBIENT_TOKENS:
			if raw.contains(token):
				hits.append(token)
		for token: String in DEFERRED_MEMBER_TOKENS:
			if _names_word(code, token):
				hits.append(token)
		for token: String in FORMULA_TOKENS:
			if raw.contains(token):
				hits.append(token)
		for operator: String in ["*", "/", "+", "&", "<<", ">>", "^", "|"]:
			if code.contains(operator):
				hits.append(operator)
		for line: String in code.split("\n"):
			var stripped: String = line.strip_edges()
			if stripped.begins_with("for ") or stripped.begins_with("while "):
				hits.append("loop: %s" % stripped)
		var literals: PackedStringArray = _numeric_literals(code)
		var permitted: PackedStringArray = PackedStringArray(["0"]) if path == RESULT_FILE else PackedStringArray()
		for literal: String in literals:
			if not permitted.has(literal):
				hits.append("literal %s" % literal)
		_expect(hits.is_empty(), "%s names or does: %s" % [path.get_file(), ", ".join(hits)])
		shown.append("%s %s" % [path.get_file(), str(literals)])

	## THE CALLS THAT MAKE IT A COORDINATOR RATHER THAN A SECOND COPY.
	var code: String = _code_only(FileAccess.get_file_as_string(COORDINATOR_FILE))
	var choose_body: PackedStringArray = _method_code(code, "func choose(")
	_expect(code.count("next_level_coordinator()") == 1
			and choose_body.has("if outcome.ok:")
			and choose_body.find("_current = _current.next_level_coordinator()") == choose_body.find("if outcome.ok:") + 1,
		"the continuation is not asked exactly once, only after a success")
	_expect(_identifier_count(code, "_current") > 10 and code.count("_current = ") == 1
			and code.count("_run_seed = ") == 1,
		"the coordinator writes _current %d times and _run_seed %d times" % [
			code.count("_current = "), code.count("_run_seed = ")])
	_expect(code.count("RiftLevelUpCoordinator.new()") == 1 and code.count("RiftLevelUpResult.") == 0,
		"the coordinator builds a lifecycle or a receipt itself")
	_expect(code.count("RiftLevelRequirementCurve.requirement_for(") == 1
			and code.count("RiftLevelOfferSeedDerivation.offer_root_seed_for(") == 1
			and code.count("_current.open_offer(") == 1 and code.count("_current.choose(") == 1,
		"G1, G2, the open or the choice is asked more than once")
	var result_code: String = _code_only(FileAccess.get_file_as_string(RESULT_FILE))
	_expect(result_code.count(".duplicated()") == 2 and result_code.count("offer_root_seed_for(") == 1
			and result_code.count("RiftLevelUpResult.new") == 0,
		"the record copies %d times or derives %d times" % [
			result_code.count(".duplicated()"), result_code.count("offer_root_seed_for(")])
	print("  2 fields; %d coordinator and %d record methods pinned; the one-level receipt gained duplicated() and no field under G4, and its two Support-content fields and two readings under I9; literals %s"
		% [signatures.size(), result_signatures.size(), "; ".join(shown)])
	_done("the_coordinator_holds_two_fields_and_restates_no_formula")


# --- 18. Unwired ---------------------------------------------------------------------------

func _check_nothing_calls_g4() -> void:
	print("")
	print("--- 18. Nothing that runs calls G4, and scripts/levels/ holds four scripts")
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	var continuation_callers: PackedStringArray = PackedStringArray()
	var wirings: Dictionary = {}
	var g1_g2: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var path: String = String(entry.get("path", ""))
		if path.begins_with(G1_DIRECTORY) or path.begins_with(G2_DIRECTORY):
			g1_g2.append(String(entry.get("class", "")))
	g1_g2.sort()
	_expect(g1_g2.size() == 4, "%d G1/G2 classes were found by directory" % g1_g2.size())
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			project_files += 1
			var text: String = FileAccess.get_file_as_string(path)
			if not G4_FILES.has(path):
				for name: String in G4_CLASSES:
					if text.contains(name) and not _reader_may_name(path, name):
						referenced.append("%s names %s" % [path.get_file(), name])
			if path != E2_COORDINATOR_FILE and text.contains("next_level_coordinator"):
				continuation_callers.append(path.get_file())
			if path.begins_with(G1_DIRECTORY) or path.begins_with(G2_DIRECTORY):
				continue
			for name: String in g1_g2:
				if text.contains(name):
					var named: Array = wirings.get(path.get_file(), [])
					named.append(name)
					wirings[path.get_file()] = named
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for name: String in G4_CLASSES:
		if settings.contains(name):
			referenced.append("project.godot names %s" % name)
	_expect(referenced.is_empty(), "G4 is referenced by code that runs: %s" % ", ".join(referenced))
	_expect(project_files > 100, "only %d project files were scanned" % project_files)
	_expect(not settings.contains("[autoload]"), "project.godot declares an [autoload] section")
	_expect(", ".join(continuation_callers) == COORDINATOR_FILE.get_file(),
		"the continuation is called by: %s" % ", ".join(continuation_callers))
	_expect(wirings.size() == 3
			and str(wirings.get(COORDINATOR_FILE.get_file(), [])) == str(Array(g1_g2))
			and str(wirings.get(RESULT_FILE.get_file(), [])) == str(["RiftLevelOfferSeedDerivation", "RiftLevelOfferSeedReading"])
			and str(wirings.get(EXPERIENCE_REVIEW_FILE.get_file(), [])) == str(["RiftLevelRequirementCurve", "RiftLevelRequirementReading"]),
		"G1 and G2 are named outside their directories by: %s" % str(wirings))

	var level_scripts: PackedStringArray = _files_under("res://scripts/levels", [".gd"])
	level_scripts.sort()
	_expect(", ".join(level_scripts) == ", ".join(PackedStringArray(LEVEL_SCRIPTS)),
		"scripts/levels/ holds: %s" % ", ".join(level_scripts))
	_expect(String(ProjectSettings.get_setting("application/run/main_scene", ""))
			== "res://scenes/app/prototype_app.tscn",
		"the entrypoint moved")
	print("  0 unauthorized files name G4 (%d readers granted by file and class); the continuation is called only by %s; G1 and G2 are named outside their directories only by the 2 G4 files and, for G1 alone, the experience collection review; scripts/levels/ holds 4 scripts"
		% [AUTHORIZED_READERS.size(), COORDINATOR_FILE.get_file()])
	print("  %d refusals and %d successes were driven across this suite" % [_refusals, _successes])
	_done("nothing_that_runs_calls_g4_and_the_directory_holds_four_scripts")


## Whether `path` is granted `name` in `AUTHORIZED_READERS`.
func _reader_may_name(path: String, name: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) == path:
			return (row[1] as Array).has(name)
	return false


# --- Fixtures ---------------------------------------------------------------------------------

func _open(run: RiftRunLevelCoordinator) -> String:
	return run.open_current_offer(
		SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(),
		PassiveCardCatalogue.records()
	)


## The run's current lifecycle, READ by name. Never handed out by the run itself.
func _lifecycle_of(run: RiftRunLevelCoordinator) -> RiftLevelUpCoordinator:
	return run.get("_current") as RiftLevelUpCoordinator


## A Level 1 lifecycle holding 100 experience and a ledger that has already spent
## `spent` — built through the accepted `with_state()` seam.
func _spent_lifecycle(spent: int) -> RiftLevelUpCoordinator:
	var track: RiftExperienceTrack = RiftExperienceTrack.new()
	_expect_accepted(track.award(100.0, PlayerStatTotals.new()), "the fabricated track's award")
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	_expect(ledger.consume(spent), "the fabricated ledger's seed")
	return RiftLevelUpCoordinator.with_state(track, null, ledger)


## A genuine, coherent one-level success spent at `root_seed`, from an empty build.
func _success_at_root(root_seed: int) -> RiftLevelUpResult:
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()
	_expect_accepted(lifecycle.award_experience(100.0), "the fixture award")
	_expect_accepted(lifecycle.open_offer(100.0, SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(), PassiveCardCatalogue.records(), root_seed),
		"the fixture offer at %d" % root_seed)
	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect(outcome.ok and outcome.root_seed == root_seed, "the fixture choice at %d was refused" % root_seed)
	return outcome


# --- Assertions ---------------------------------------------------------------------------------

func _expect_accepted(refusal: String, described: String) -> void:
	_expect(refusal.is_empty(), "%s was refused: %s" % [described, refusal])


func _expect_refused(refusal: String, described: String) -> void:
	_refusals += 1
	_expect(not refusal.strip_edges().is_empty(), "%s was accepted" % described)


## A success, carrying exactly the reproduction pair and the derived root.
func _expect_success(
	outcome: RiftRunLevelUpResult, run_seed: int, source_level: int, root_seed: int, described: String
) -> void:
	_successes += 1
	var receipt: RiftLevelUpResult = outcome.level_up()
	_expect(outcome.succeeded() and outcome.failure_reason().is_empty() and receipt != null and receipt.ok,
		"%s was refused: %s" % [described, outcome.failure_reason()])
	_expect(outcome.run_seed == run_seed and outcome.source_level == source_level,
		"%s carries run seed %d at level %d, not %d at %d" % [
			described, outcome.run_seed, outcome.source_level, run_seed, source_level])
	_expect(receipt != null and receipt.root_seed_known and receipt.root_seed == root_seed,
		"%s spent %s, not %d" % [described, outcome.describe(), root_seed])
	_expect(outcome.problem().is_empty(), "%s is incoherent: %s" % [described, outcome.problem()])


func _expect_incoherent(record: RiftRunLevelUpResult, fragment: String, described: String) -> void:
	var problem: String = record.problem()
	_expect(not problem.is_empty() and problem.contains(fragment),
		"%s answered '%s', not a problem naming '%s'" % [described, problem, fragment])


# --- Snapshots ---------------------------------------------------------------------------------

## THE WHOLE RUN AS ONE LINE: the seed, the level, the experience to seventeen
## places, the offer's whole identity, the frozen requirement, the current
## requirement, and everything `_held()` reads.
func _snapshot(run: RiftRunLevelCoordinator) -> String:
	var lanes: PackedStringArray = PackedStringArray()
	for lane: int in run.offer_lanes():
		lanes.append("%d:%s" % [lane, " -> ".join(run.offer_identity_for(lane))])
	return "seed=%d level=%d experience=%s offer=%s root=%d frozen=%s lanes=[%s] needs=%s | %s" % [
		run.run_seed(), run.level(), _exact(run.experience()), str(run.is_offer_active()),
		run.offer_root_seed(), _exact(run.frozen_requirement()), ", ".join(lanes),
		run.requirement_reading().describe(), _held(run),
	]


## Every pair's RANK and every card's COUNT and MECHANICAL IDENTITY, one by one,
## and the ledger.
func _held(run: RiftRunLevelCoordinator) -> String:
	var build: RiftRunBuild = run.run_build()
	var ranks: PackedStringArray = PackedStringArray()
	for pair: String in build.support_pairs():
		var parts: PackedStringArray = pair.split(" -> ")
		ranks.append("%s@%d" % [pair, build.support_rank_for(StringName(parts[0]), StringName(parts[1]))])
	var cards: PackedStringArray = PackedStringArray()
	for card_id: StringName in build.acquired_card_ids():
		cards.append("%s x%d {%s}" % [
			card_id, build.acquisitions_for(card_id), build.mechanical_identity_for(card_id)])
	return "ranks [%s] | cards [%s] | seeds %s" % [
		", ".join(ranks), ", ".join(cards), str(run.consumption_ledger().consumed_seeds()),
	]


## All nine fields of a one-level receipt, as one line.
func _receipt_fields(receipt: RiftLevelUpResult) -> String:
	return "ok=%s reason=%s seed=%d known=%s lane=%d kind=%d ranks=%d->%d ids=[%s]" % [
		str(receipt.ok), receipt.failure_reason, receipt.root_seed, str(receipt.root_seed_known),
		receipt.lane, receipt.support_progression_kind, receipt.support_rank_before,
		receipt.support_rank_after, ", ".join(receipt.granted_identity()),
	]


func _exact(value: float) -> String:
	return String.num(value, 17)


# --- Source reading ------------------------------------------------------------------------------

func _code_only(source: String) -> String:
	var out: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


## The non-blank, stripped code lines of one method, from its declaration to the
## next declaration.
func _method_code(code: String, declaration: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var start: int = code.find(declaration)
	if start < 0:
		return out
	var end: int = code.length()
	for marker: String in ["\nfunc ", "\nstatic func ", "\nclass "]:
		var next: int = code.find(marker, start + 1)
		if next >= 0 and next < end:
			end = next
	for line: String in code.substr(start, end - start).split("\n"):
		if not line.strip_edges().is_empty():
			out.append(line.strip_edges())
	return out


## Whether `token` occurs in `code` with no letter or digit touching it on either
## side. An underscore does not break a match, so `auto_open` is still caught.
func _names_word(code: String, token: String) -> bool:
	var bounded: RegEx = RegEx.create_from_string("(?<![A-Za-z0-9])%s(?![A-Za-z0-9])" % token)
	return bounded.search(code) != null


## How many times `identifier` occurs with no letter, digit or underscore touching it.
func _identifier_count(code: String, identifier: String) -> int:
	var bounded: RegEx = RegEx.create_from_string(
		"(?<![A-Za-z0-9_])%s(?![A-Za-z0-9_])" % identifier)
	return bounded.search_all(code).size()


## Every numeric literal in code OUTSIDE string literals, deduplicated and sorted.
func _numeric_literals(code: String) -> PackedStringArray:
	var without_strings: String = RegEx.create_from_string("\"([^\"\\\\]|\\\\.)*\"").sub(code, "\"\"", true)
	var found: Dictionary = {}
	var number: RegEx = RegEx.create_from_string("(?<![A-Za-z0-9_.])[0-9][0-9_.]*(?![A-Za-z0-9_])")
	for hit: RegExMatch in number.search_all(without_strings):
		found[hit.get_string()] = true
	var out: PackedStringArray = PackedStringArray()
	for key: Variant in found:
		out.append(String(key))
	out.sort()
	return out


## Every method as `name(arg: Type, ...) -> Type`, in declaration order — the same
## rendering the accepted E2, F5 and G3 pins use.
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


# --- The owed set -----------------------------------------------------------------------------------

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
