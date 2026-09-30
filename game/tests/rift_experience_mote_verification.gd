extends SceneTree
## Riftwrought — Roguelite Foundation H1 verification: atomic Experience Mote
## collection.
##
## ONE FOCUSED HEADLESS TEST. Foundation H1 is one pure-logic script under
## `scripts/experience/` — a temporary in-memory Experience Mote that carries one
## base-experience amount and whether it has been collected, and delivers that
## amount into the accepted run-level coordinator (Foundation G4) exactly once.
## It runs as a `SceneTree` script exactly as every earlier foundation suite does.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching its
## LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## EVERY "NOTHING MOVED" CLAIM COMPARES A WHOLE-RUN SNAPSHOT — the seed, level,
## experience to seventeen places, the offer's whole identity, the frozen and
## current requirements, every pair's rank, every card's count and mechanical
## identity, and the ledger — beside a snapshot of the mote itself.
##
## THE COLLECTION IS DRIVEN THROUGH THE RUN'S PUBLIC CONTRACT ONLY. The mote is the
## thing under test, so the harness never performs the award it is checking:
## every experience figure below was put there by a mote. The one private read —
## the run's current lifecycle, by name — is used only to show which lifecycle an
## award landed in, never to write anything.
##
## THE VALUE 25 IS TEST EVIDENCE ONLY. It is not an enemy-experience value and no
## balance record is created for it.
##
## IT READS NO OTHER SUITE. It names no file under `tests/` but its own, which the
## runner asserts.

# --- The files ----------------------------------------------------------------------

const MOTE_FILE: String = "res://scripts/experience/rift_experience_mote.gd"
const THIS_FILE: String = "res://tests/rift_experience_mote_verification.gd"

const MOTE_CLASS: String = "RiftExperienceMote"

## `scripts/experience/` after H1: E1's two scripts and the mote, and nothing else.
## D-281: Foundation H6's enemy mote emission shares the directory.
## D-283: Foundation H7's Graveblade mote binding shares it too, and names no mote.
## D-286: so does Foundation H8's Experience Mote runtime, which names no mote either.
const EXPERIENCE_SCRIPTS: Array[String] = [
	"res://scripts/experience/rift_enemy_mote_emission.gd",
	"res://scripts/experience/rift_experience_mote.gd",
	"res://scripts/experience/rift_experience_reading.gd",
	"res://scripts/experience/rift_experience_track.gd",
	"res://scripts/experience/rift_graveblade_mote_binding.gd",
	"res://scripts/experience/rift_mote_runtime.gd",
]

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]
const PROJECT_SETTINGS_FILE: String = "res://project.godot"

## THE ONLY PROJECT CLASSES THE MOTE MAY NAME, and it must name both: itself, and
## the run it is collected into. Checked against the engine's own global class
## list in both directions — the run's record, its lifecycle, the track, the
## reading, the build, the ledger, the curve, the derivation, the offer and every
## stat and card class are all refused.
const AUTHORIZED_CLASSES: Array[String] = ["RiftExperienceMote", "RiftRunLevelCoordinator"]

## THE ONLY FILES OTHER THAN THE MOTE THAT MAY NAME IT OR CALL A COLLECTION, PER
## FILE AND PER TOKEN. D-275: Foundation H3's collection attempt is handed a mote
## and, only when that mote is within range, asks it to collect itself into the
## run it was handed — so it is granted the mote's class and the collection call,
## and never the mote's file name. Nothing that runs calls the attempt. This
## replaces the blanket "no other file" one for one: the same single assertion is
## made either way, and the pinned count does not move.
## D-277: Foundation H4's drop makes one mote from the amount it is given and holds
## it privately; it never asks the mote to collect itself — it hands it to the
## attempt above — so it is granted the mote's class alone: not the collection
## call, and never the mote's file name. Nothing that runs creates a drop.
## D-281: Foundation H6's enemy mote emission makes a temporary mote of its stored
## amount only to ask that mote's own problem, and lets it go; it never asks a mote
## to collect itself, so it is granted the mote's class alone: not the collection
## call, and never the mote's file name. Nothing that runs creates an emission.
const AUTHORIZED_READERS: Array = [
	["res://scripts/pickups/rift_mote_collection_attempt.gd", ["RiftExperienceMote", "collect_into("]],
	["res://scripts/pickups/rift_mote_drop.gd", ["RiftExperienceMote"]],
	["res://scripts/experience/rift_enemy_mote_emission.gd", ["RiftExperienceMote"]],
]

## THE MOTE'S WHOLE STATE: TWO PRIVATE FIELDS AND NO THIRD.
const EXPECTED_FIELDS: Array[String] = ["_base_experience", "_collected"]

## Every method, in declaration order, with its full signature. The engine reports
## a constructor's return as an object, whatever the source declares.
const EXPECTED_SIGNATURES: Array[String] = [
	"_init(for_base_experience: float) -> Object",
	"base_experience() -> float",
	"is_collected() -> bool",
	"problem() -> String",
	"collect_into(run: Object) -> String",
	"describe() -> String",
]

## THE COLLECTION ORDER, AS THE CODE MUST SPELL IT, first occurrence to first
## occurrence inside `collect_into()`, each exactly once.
const COLLECTION_ORDER: Array[String] = [
	"if _collected:",
	"var invalid: String = problem()",
	"if not invalid.is_empty():",
	"return invalid",
	"if run == null:",
	"var refusal: String = run.award_experience(_base_experience)",
	"if not refusal.is_empty():",
	"return refusal",
	"_collected = true",
	"return \"\"",
]

## The refusing gates, each of which must return on its very next line.
const REFUSING_GATES: Array[String] = [
	"if _collected:", "if not invalid.is_empty():", "if run == null:", "if not refusal.is_empty():",
]

## Other foundations' classes and members, content, and the accepted formula
## vocabulary. Scanned RAW, comments included — D-215's lesson.
const FORBIDDEN_TOKENS: Array[String] = [
	"RiftLevelUp", "RiftRunLevelUpResult", "RiftExperienceTrack", "RiftExperienceReading",
	"RiftRunBuild", "RiftConsumptionLedger", "RiftOffer", "RiftLevelRequirement",
	"RiftLevelOfferSeed", "PlayerStat", "PassiveCard", "SkillTagProfile",
	"SupportDefinition", "Catalogue", "card_", "EXPERIENCE_GAIN", "experience_gain",
	"value_of", "open_current_offer", "choose(", "next_level_coordinator", "with_state(",
	"requirement_for", "offer_root_seed", "quick_strike", "Graveblade",
	"ExperienceTable", "CharacterState",
]

## A pure object reads no ambient state and occupies no space. Scanned raw.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
	"get_tree", "get_node", "Node3D", "Area3D", "Vector2", "Vector3", "Transform3D",
	"global_position", "distance_to", "PhysicsServer",
]

## What the brief defers, as identifier words over CODE lines only — the file
## says in plain English what it does not do, and a raw scan would fire on the
## sentence making the claim (Gate 1C's lesson). A letter or digit on either side
## breaks a match; an underscore does not, so `pickup_radius` is still caught.
const DEFERRED_MEMBER_TOKENS: Array[String] = [
	"position", "distance", "radius", "pickup", "attract", "magnet", "move",
	"velocity", "spawn", "enemy", "drop", "loot", "pool", "rarity", "owner", "source",
	"time", "reset", "respawn", "duplicate", "copy", "clone", "save", "persist", "load",
	"requirement", "seed", "offer", "open", "level", "curve", "gain", "percent",
	"multiplier", "scale", "totals", "build", "stat", "node", "signal", "scene",
	"input", "pause", "balance", "result", "id",
]

# --- The fixtures, stated independently -----------------------------------------------

## Test evidence only.
const TEST_MOTE: float = 25.0
const TEST_MOTES_FOR_ONE_LEVEL: int = 4
const FIRST_REQUIREMENT: float = 100.0

## Bases forwarded exactly, including one that is not representable in binary and
## the largest this suite uses.
const FORWARDED_BASES: Array[float] = [25.0, 0.1, 7.5, 1.7e308]

const UNUSABLE_BASES: Array = [
	["zero", 0.0, "positive"],
	["negative", -25.0, "positive"],
	["not a number", NAN, "finite"],
	["positive infinity", INF, "finite"],
	["negative infinity", -INF, "finite"],
]

const WORKED_SEED: int = 99

## Run seed 10 offers the shipped Experience Gain card in its Level 1 Utility lane
## (measured, and the same fixture G4's accepted suite uses).
const GAIN_SEED: int = 10
const GAIN_OPENING_MOTE: float = 150.0
const GAIN_KEPT: float = 50.0
const GAIN_SECOND_MOTE: float = 50.0
const GAIN_BOOSTED_TOTAL: float = 105.0
const GAIN_UNBOOSTED_TOTAL: float = 100.0

## Finite on an unmodified run; not finite once Experience Gain is applied.
const OVERFLOWING_MOTE: float = 1.7e308

## The accepted refusal wordings this suite quotes, typed independently.
const OFFER_OPEN_REFUSAL: String = "an offer is open; it must be resolved before further experience is recorded"
const COMPLETED_LIFECYCLE_REFUSAL: String = "this coordinator has finished its one level-up and records no further experience"

const OWED_CHECKS: Array[String] = [
	"a_valid_mote_forwards_its_exact_base_and_is_collected_only_after_acceptance",
	"two_equal_motes_are_independent_and_each_awards_once",
	"a_second_collection_refuses_and_moves_the_whole_run_nowhere",
	"unusable_motes_and_a_missing_run_refuse_in_the_contract_order",
	"a_valid_mote_the_run_refuses_after_experience_gain_stays_available",
	"experience_gain_is_evaluated_by_the_run_at_collection_time",
	"an_active_offer_refuses_collection_and_the_resolved_offer_then_pays_once",
	"four_test_motes_reach_one_hundred_and_nothing_advances_until_asked",
	"collection_after_a_completed_choice_lands_in_the_fresh_successor",
	"the_collection_order_is_pinned_and_the_mote_restates_nothing",
	"nothing_that_runs_creates_or_collects_a_mote_and_the_directory_holds_six_scripts",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0
var _collections: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation H1 — Atomic Experience Mote Collection (D-271) ===")

	_check_a_valid_mote()
	_check_two_equal_motes()
	_check_a_second_collection()
	_check_unusable_motes()
	_check_a_refusal_after_experience_gain()
	_check_experience_gain_at_collection_time()
	_check_an_active_offer()
	_check_four_motes_reach_one_level()
	_check_the_fresh_successor()
	_check_the_shape()
	_check_nothing_runs_it()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT EXPERIENCE MOTE VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT EXPERIENCE MOTE VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. One valid mote ------------------------------------------------------------------

func _check_a_valid_mote() -> void:
	print("")
	print("--- 1. A valid mote forwards its exact base and is collected only after acceptance")
	var shown: PackedStringArray = PackedStringArray()
	var smallest: float = _smallest_positive_double()
	for base: float in FORWARDED_BASES + [smallest]:
		var mote: RiftExperienceMote = RiftExperienceMote.new(base)
		_expect(mote.base_experience() == base and not mote.is_collected() and mote.problem().is_empty(),
			"a new mote of %s reads %s" % [_exact(base), _mote(mote)])
		var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
		_expect_collected(mote.collect_into(run), "the mote of %s" % _exact(base))
		_expect(mote.is_collected(), "the mote of %s was accepted and is not collected" % _exact(base))
		_expect(run.experience() == base,
			"the mote of %s delivered %s" % [_exact(base), _exact(run.experience())])
		_expect(mote.base_experience() == base,
			"collecting moved the mote's base from %s to %s" % [_exact(base), _exact(mote.base_experience())])
		_expect(run.level() == 1 and not run.is_offer_active(),
			"collecting the mote of %s moved the run to %s" % [_exact(base), _snapshot(run)])
		shown.append(String.num_scientific(base))
	## THE SMALLEST POSITIVE DOUBLE IS A VALID MOTE, AND THE RUN — NOT THE MOTE —
	## DECIDES IT IS RECORDABLE. Built by halving: this engine parses the literal
	## as zero, which D-246 measured.
	_expect(smallest > 0.0 and smallest / 2.0 == 0.0,
		"the halving did not reach the smallest positive double: %s" % _exact(smallest))
	print("  %s: each forwarded exactly, each collected only after the run accepted it" % ", ".join(shown))
	_done("a_valid_mote_forwards_its_exact_base_and_is_collected_only_after_acceptance")


# --- 2. Two equal motes --------------------------------------------------------------------

func _check_two_equal_motes() -> void:
	print("")
	print("--- 2. Two motes of the same value are two objects, and each awards once")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	var first: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	var second: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	_expect(first != second, "two constructions answered one object")
	_expect_collected(first.collect_into(run), "the first mote")
	_expect(first.is_collected() and not second.is_collected(),
		"collecting the first moved the second: %s / %s" % [_mote(first), _mote(second)])
	_expect_collected(second.collect_into(run), "the second, equal mote")
	_expect(run.experience() == TEST_MOTE + TEST_MOTE,
		"two equal motes delivered %s" % _exact(run.experience()))
	var settled: String = _snapshot(run)
	_expect_refused(first.collect_into(run), "the first mote again")
	_expect_refused(second.collect_into(run), "the second mote again")
	_expect(_snapshot(run) == settled, "a repeated collection moved the run: %s" % _snapshot(run))
	print("  2 motes of %s: %s delivered, each once; both repeats refused and nothing moved"
		% [_exact(TEST_MOTE), _exact(run.experience())])
	_done("two_equal_motes_are_independent_and_each_awards_once")


# --- 3. A second collection ------------------------------------------------------------------

func _check_a_second_collection() -> void:
	print("")
	print("--- 3. A second collection of the same mote refuses and moves the complete run nowhere")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	var mote: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	_expect_collected(mote.collect_into(run), "the mote")
	var run_before: String = _snapshot(run)
	var mote_before: String = _mote(mote)
	var lifecycle: int = _lifecycle_of(run).get_instance_id()
	var refusal: String = mote.collect_into(run)
	_expect_refused(refusal, "the same mote a second time")
	_expect(refusal.contains("already been collected"),
		"the second collection answered: %s" % refusal)
	_expect(_snapshot(run) == run_before and _mote(mote) == mote_before
			and _lifecycle_of(run).get_instance_id() == lifecycle,
		"the refused second collection moved something: %s | %s" % [_snapshot(run), _mote(mote)])

	## A COLLECTED MOTE IS COLLECTED EVERYWHERE, NOT PER RUN. A second run offered
	## the same mote gets nothing either.
	var other: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	var other_before: String = _snapshot(other)
	_expect_refused(mote.collect_into(other), "the same mote into a different run")
	_expect(_snapshot(other) == other_before, "a collected mote moved a second run: %s" % _snapshot(other))
	_expect(other.experience() == 0.0, "a second run received %s" % _exact(other.experience()))
	print("  the second collection refused ('%s'); the whole run and the mote unmoved; a second run refused too and received 0.0"
		% refusal)
	_done("a_second_collection_refuses_and_moves_the_whole_run_nowhere")


# --- 4. Unusable motes and a missing run ------------------------------------------------------

func _check_unusable_motes() -> void:
	print("")
	print("--- 4. Unusable motes and a missing run refuse usefully, in the contract order, collecting nothing")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	var untouched: String = _snapshot(run)
	var named: PackedStringArray = PackedStringArray()
	for row: Array in UNUSABLE_BASES:
		var label: String = String(row[0])
		var mote: RiftExperienceMote = RiftExperienceMote.new(float(row[1]))
		var problem: String = mote.problem()
		_expect(not problem.is_empty() and problem.contains(String(row[2])),
			"the %s mote's problem is '%s', not one naming '%s'" % [label, problem, String(row[2])])
		for attempt: int in 2:
			var refusal: String = mote.collect_into(run)
			_expect_refused(refusal, "the %s mote, attempt %d" % [label, attempt + 1])
			_expect(refusal == problem, "the %s mote refused with '%s', not its problem" % [label, refusal])
			_expect(not mote.is_collected(), "the %s mote was marked collected" % label)
		## INVALIDITY IS ASKED BEFORE THE RUN IS: offered no run at all, the mote
		## still answers with its own problem.
		_expect(mote.collect_into(null) == problem,
			"the %s mote with no run answered something other than its problem" % label)
		_refusals += 1
		named.append(label)
	_expect(_snapshot(run) == untouched, "an unusable mote moved the run: %s" % _snapshot(run))

	## A MISSING RUN, THEN A RETRY.
	var mote: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	var missing: String = mote.collect_into(null)
	_expect_refused(missing, "a valid mote with no run")
	_expect(missing.contains("into a run") and not mote.is_collected(),
		"a missing run answered '%s' and left %s" % [missing, _mote(mote)])
	_expect_collected(mote.collect_into(run), "the same mote into a real run")
	_expect(run.experience() == TEST_MOTE, "the retried mote delivered %s" % _exact(run.experience()))

	## COLLECTED IS ASKED BEFORE THE RUN IS: a collected mote offered no run says
	## it is collected, not that the run is missing.
	var collected_reason: String = mote.collect_into(null)
	_expect_refused(collected_reason, "a collected mote with no run")
	_expect(collected_reason.contains("already been collected"),
		"a collected mote with no run answered: %s" % collected_reason)
	print("  %s: each refused twice with its own problem and never collected; the run unmoved" % ", ".join(named))
	print("  order: collected before invalid before a missing run; a valid mote refused for a missing run was then collected")
	_done("unusable_motes_and_a_missing_run_refuse_in_the_contract_order")


# --- 5. Refused after Experience Gain -----------------------------------------------------------

func _check_a_refusal_after_experience_gain() -> void:
	print("")
	print("--- 5. A valid mote the run refuses after Experience Gain stays uncollected and available")
	var run: RiftRunLevelCoordinator = _insight_run()
	var control: RiftRunLevelCoordinator = _insight_run()
	var mote: RiftExperienceMote = RiftExperienceMote.new(OVERFLOWING_MOTE)
	_expect(mote.problem().is_empty(), "the overflowing mote is not a valid record: %s" % mote.problem())
	var before: String = _snapshot(run)
	var lifecycle: int = _lifecycle_of(run).get_instance_id()
	var refusal: String = mote.collect_into(run)
	_expect_refused(refusal, "the overflowing mote into a run holding Experience Gain")

	## QUOTED VERBATIM. The control run, in the identical state, is asked the award
	## directly — the one place this suite performs an award itself, and only to
	## learn what the accepted path says.
	var accepted_answer: String = control.award_experience(OVERFLOWING_MOTE)
	_expect(not accepted_answer.is_empty() and refusal == accepted_answer,
		"the mote answered '%s' where the run's own path answers '%s'" % [refusal, accepted_answer])
	_expect(refusal.contains("could not be evaluated") and refusal.contains("did not produce a finite value"),
		"the refusal is not the Experience Gain evaluation's: %s" % refusal)
	_expect(not mote.is_collected() and mote.base_experience() == OVERFLOWING_MOTE,
		"a refused award left %s" % _mote(mote))
	_expect(_snapshot(run) == before and _lifecycle_of(run).get_instance_id() == lifecycle,
		"a refused award moved the run: %s" % _snapshot(run))

	## AVAILABLE FOR RETRY. The same run still holds Experience Gain and still
	## refuses; a run without it accepts the very same mote, exactly once.
	_expect_refused(mote.collect_into(run), "the same mote retried into the same run")
	_expect(not mote.is_collected() and _snapshot(run) == before,
		"the second refused attempt moved something")
	var unmodified: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_expect_collected(mote.collect_into(unmodified), "the same mote into an unmodified run")
	_expect(unmodified.experience() == OVERFLOWING_MOTE and mote.is_collected(),
		"the retry delivered %s and left %s" % [_exact(unmodified.experience()), _mote(mote)])
	_expect_refused(mote.collect_into(RiftRunLevelCoordinator.new(WORKED_SEED)), "the same mote a third time")
	print("  1.7e+308 on a run holding Experience Gain: refused, quoting the run's own evaluation; uncollected; refused again; then collected once into an unmodified run")
	_done("a_valid_mote_the_run_refuses_after_experience_gain_stays_available")


# --- 6. Experience Gain at collection time ----------------------------------------------------------

func _check_experience_gain_at_collection_time() -> void:
	print("")
	print("--- 6. Experience Gain is evaluated by the run when the mote is collected, and never by the mote")
	var run: RiftRunLevelCoordinator = _insight_run()
	var control: RiftRunLevelCoordinator = _insight_run()
	_expect(run.experience() == GAIN_KEPT, "the fixture kept %s, not %s" % [
		_exact(run.experience()), _exact(GAIN_KEPT)])
	## The opening mote was collected BEFORE the card was held; taking the card did
	## not raise it.
	var mote: RiftExperienceMote = RiftExperienceMote.new(GAIN_SECOND_MOTE)
	_expect_collected(mote.collect_into(run), "the mote collected while holding Experience Gain")
	_expect(mote.base_experience() == GAIN_SECOND_MOTE,
		"the mote's own base moved to %s" % _exact(mote.base_experience()))
	_expect_accepted(control.award_experience(GAIN_SECOND_MOTE), "the control run's direct award")
	_expect(run.experience() == control.experience(),
		"the mote came to %s where the run's own path comes to %s" % [
			_exact(run.experience()), _exact(control.experience())])
	_expect(run.experience() == GAIN_BOOSTED_TOTAL and run.experience() != GAIN_UNBOOSTED_TOTAL,
		"the boosted total is %s" % _exact(run.experience()))
	print("  %s kept before the card; a mote of %s collected while holding it came to %s, equal to the run's own path and not %s"
		% [_exact(GAIN_KEPT), _exact(GAIN_SECOND_MOTE), _exact(run.experience()), _exact(GAIN_UNBOOSTED_TOTAL)])
	_done("experience_gain_is_evaluated_by_the_run_at_collection_time")


# --- 7. An active offer -------------------------------------------------------------------------------

func _check_an_active_offer() -> void:
	print("")
	print("--- 7. An active offer refuses collection; resolving it lets the same mote pay once")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_collect_many(run, TEST_MOTES_FOR_ONE_LEVEL, TEST_MOTE)
	_expect_accepted(_open(run), "the offer")
	_expect(run.is_offer_active(), "the offer did not open")
	var standing: String = _snapshot(run)
	var lifecycle: int = _lifecycle_of(run).get_instance_id()

	var mote: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	var refusal: String = mote.collect_into(run)
	_expect_refused(refusal, "a mote while the offer stands")
	_expect(refusal == OFFER_OPEN_REFUSAL, "the active offer answered: %s" % refusal)
	_expect(not mote.is_collected(), "a refused mote was marked collected")
	_expect(_snapshot(run) == standing and _lifecycle_of(run).get_instance_id() == lifecycle,
		"a refused collection moved the run or its offer: %s" % _snapshot(run))
	_expect_refused(mote.collect_into(run), "the same mote again while the offer stands")
	_expect(_snapshot(run) == standing and not mote.is_collected(), "a second refused attempt moved something")

	var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect(outcome.succeeded(), "the offer could not be resolved: %s" % outcome.failure_reason())
	_expect(run.level() == 2 and run.experience() == 0.0 and not run.is_offer_active(),
		"resolving the offer left %s" % _snapshot(run))
	_expect_collected(mote.collect_into(run), "the same mote after the offer was resolved")
	_expect(run.experience() == TEST_MOTE and mote.is_collected(),
		"the retry delivered %s" % _exact(run.experience()))
	var paid: String = _snapshot(run)
	_expect_refused(mote.collect_into(run), "the same mote once more")
	_expect(_snapshot(run) == paid, "the repeat moved the run: %s" % _snapshot(run))
	print("  refused twice while the offer stood ('%s'); the offer and run unchanged; after the choice the same mote paid %s once"
		% [refusal, _exact(TEST_MOTE)])
	_done("an_active_offer_refuses_collection_and_the_resolved_offer_then_pays_once")


# --- 8. Four test motes -------------------------------------------------------------------------------

func _check_four_motes_reach_one_level() -> void:
	print("")
	print("--- 8. Four test motes of 25 make exactly 100, and nothing advances or opens until asked")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	var motes: Array[RiftExperienceMote] = _collect_many(run, TEST_MOTES_FOR_ONE_LEVEL, TEST_MOTE)
	_expect(run.experience() == FIRST_REQUIREMENT, "four motes delivered %s" % _exact(run.experience()))
	_expect(run.requirement_reading().ok and run.requirement_reading().experience_requirement() == FIRST_REQUIREMENT,
		"the first requirement is %s" % run.requirement_reading().describe())
	_expect(run.level() == 1 and not run.is_offer_active(),
		"reaching the requirement moved the run by itself: %s" % _snapshot(run))
	var collected: int = 0
	for mote: RiftExperienceMote in motes:
		if mote.is_collected():
			collected += 1
	_expect(collected == TEST_MOTES_FOR_ONE_LEVEL, "%d of the four motes read collected" % collected)
	var waiting: String = _snapshot(run)
	for mote: RiftExperienceMote in motes:
		_expect_refused(mote.collect_into(run), "a collected test mote again")
	_expect(_snapshot(run) == waiting, "re-collecting a test mote moved the run")

	## THE CALLER STILL ASKS. Opening is a separate call and moves no level.
	_expect_accepted(_open(run), "the explicit open")
	_expect(run.is_offer_active() and run.level() == 1 and run.experience() == FIRST_REQUIREMENT,
		"opening moved the run: %s" % _snapshot(run))
	var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect(outcome.succeeded() and run.level() == 2 and run.experience() == 0.0,
		"the explicit choice left %s (%s)" % [_snapshot(run), outcome.failure_reason()])
	print("  4 x 25.0 = %s at level 1 with no offer; the open and the choice were each asked for; level 2 with %s"
		% [_exact(FIRST_REQUIREMENT), _exact(run.experience())])
	_done("four_test_motes_reach_one_hundred_and_nothing_advances_until_asked")


# --- 9. The fresh successor ---------------------------------------------------------------------------

func _check_the_fresh_successor() -> void:
	print("")
	print("--- 9. Collection after a completed choice lands in the run's fresh successor lifecycle")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_collect_many(run, TEST_MOTES_FOR_ONE_LEVEL, TEST_MOTE)
	_expect_accepted(_open(run), "the offer")
	var source: RiftLevelUpCoordinator = _lifecycle_of(run)
	var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect(outcome.succeeded(), "the choice was refused: %s" % outcome.failure_reason())
	var successor: RiftLevelUpCoordinator = _lifecycle_of(run)
	_expect(successor != source and source.is_completed() and not successor.is_completed(),
		"the run did not replace its completed lifecycle")
	var source_experience: float = source.experience()

	var mote: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	_expect_collected(mote.collect_into(run), "the mote after the completed choice")
	_expect(_lifecycle_of(run) == successor and successor.experience() == TEST_MOTE and run.level() == 2,
		"the mote did not land in the successor: %s" % _snapshot(run))
	_expect(source.experience() == source_experience,
		"the completed source moved from %s to %s" % [_exact(source_experience), _exact(source.experience())])
	## The completed source would refuse the award outright — so the mote could not
	## have been paid into it. Asked of a throwaway completed lifecycle, never of the
	## run's own.
	var spare: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(WORKED_SEED)
	_collect_many(spare, TEST_MOTES_FOR_ONE_LEVEL, TEST_MOTE)
	_expect_accepted(_open(spare), "the spare offer")
	var spare_source: RiftLevelUpCoordinator = _lifecycle_of(spare)
	_expect(spare.choose(RiftOffer.Lane.COMBAT_DEFENCE).succeeded(), "the spare choice")
	_expect(spare_source.award_experience(TEST_MOTE) == COMPLETED_LIFECYCLE_REFUSAL,
		"a completed lifecycle accepted an award")
	print("  the completed level-1 lifecycle stayed at %s; the mote landed in the level-2 successor, which now holds %s"
		% [_exact(source.experience()), _exact(successor.experience())])
	_done("collection_after_a_completed_choice_lands_in_the_fresh_successor")


# --- 10. The shape --------------------------------------------------------------------------------------

func _check_the_shape() -> void:
	print("")
	print("--- 10. The collection order is pinned, the amount is required, and the mote restates nothing")
	var mote: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	var fields: PackedStringArray = _fields_of(mote)
	_expect(", ".join(fields) == ", ".join(PackedStringArray(EXPECTED_FIELDS)),
		"the mote carries the fields: %s" % ", ".join(fields))
	var signatures: PackedStringArray = _signatures_of(MOTE_FILE)
	_expect(", ".join(signatures) == ", ".join(PackedStringArray(EXPECTED_SIGNATURES)),
		"the mote declares: %s" % ", ".join(signatures))

	## THE AMOUNT IS REQUIRED: NO METHOD DEFAULTS AN ARGUMENT, AND THE FIELD HAS NO
	## INITIALIZER. `RiftExperienceMote.new()` with no amount is therefore refused
	## by the language, not by a check this suite would have to trigger.
	var defaulted: PackedStringArray = PackedStringArray()
	var script: GDScript = load(MOTE_FILE) as GDScript
	for entry: Dictionary in script.get_script_method_list():
		if not (entry.get("default_args", []) as Array).is_empty():
			defaulted.append(String(entry.get("name", "")))
	_expect(defaulted.is_empty(), "these methods default an argument: %s" % ", ".join(defaulted))

	var raw: String = FileAccess.get_file_as_string(MOTE_FILE)
	var code: String = _code_only(raw)
	_expect(raw.length() > 2000 and code.length() > 500 and code.length() < raw.length(),
		"the mote read as %d / %d characters" % [raw.length(), code.length()])
	var lines: PackedStringArray = PackedStringArray()
	for line: String in code.split("\n"):
		lines.append(line.strip_edges())
	_expect(lines.has("var _base_experience: float") and lines.count("var _base_experience: float") == 1,
		"the base-experience field is not declared bare, exactly once")
	_expect(code.count("_base_experience = ") == 1 and code.count("_collected = ") == 1
			and code.count("_collected = true") == 1,
		"the fields are written %d and %d times" % [code.count("_base_experience = "), code.count("_collected = ")])

	## THE ORDER, EACH STEP ONCE, EACH GATE RETURNING ON ITS NEXT LINE.
	var body: PackedStringArray = _method_code(code, "func collect_into(")
	var previous: int = -1
	var ordered: bool = true
	for step: String in COLLECTION_ORDER:
		var at: int = body.find(step)
		if at <= previous or body.count(step) != 1:
			ordered = false
		previous = at
	_expect(ordered, "collect_into() does not spell its steps in order, each once: %s" % " | ".join(body))
	var returning: int = 0
	for gate: String in REFUSING_GATES:
		var at: int = body.find(gate)
		if at >= 0 and at + 1 < body.size() and body[at + 1].begins_with("return "):
			returning += 1
	_expect(returning == REFUSING_GATES.size(), "%d of %d gates return on their next line" % [
		returning, REFUSING_GATES.size()])
	_expect(body.find("_collected = true") == body.find("return refusal") + 1
			and body.find("return \"\"") == body.find("_collected = true") + 1,
		"the mote is not marked collected immediately after the run's acceptance")
	_expect(code.count(".award_experience(") == 1,
		"the run's award path is asked %d times" % code.count(".award_experience("))

	## PER-FILE CLASS ALLOWLIST FROM THE ENGINE'S OWN CLASS LIST, BOTH DIRECTIONS.
	var all_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		all_classes.append(String(entry.get("class", "")))
	_expect(all_classes.size() > 100 and all_classes.has(MOTE_CLASS),
		"%d project classes were enumerated, the mote %s among them" % [
			all_classes.size(), "is" if all_classes.has(MOTE_CLASS) else "is NOT"])
	var outside: PackedStringArray = PackedStringArray()
	var unearned: PackedStringArray = PackedStringArray()
	for class_id: String in all_classes:
		if raw.contains(class_id) and not AUTHORIZED_CLASSES.has(class_id):
			outside.append(class_id)
	for class_id: String in AUTHORIZED_CLASSES:
		if not raw.contains(class_id):
			unearned.append(class_id)
	_expect(outside.is_empty() and unearned.is_empty(),
		"the mote names unauthorized [%s] or is granted but does not name [%s]" % [
			", ".join(outside), ", ".join(unearned)])

	## SCANS: other foundations and ambient reads raw; deferred members, arithmetic
	## and numeric literals in code.
	var hits: PackedStringArray = PackedStringArray()
	for token: String in FORBIDDEN_TOKENS + AMBIENT_TOKENS:
		if raw.contains(token):
			hits.append(token)
	for token: String in DEFERRED_MEMBER_TOKENS:
		if _names_word(code, token):
			hits.append(token)
	for operator: String in ["*", "/", "+", "&", "|", "^", "<<", ">>"]:
		if code.contains(operator):
			hits.append(operator)
	if code.replace("->", "").contains("-"):
		hits.append("-")
	for line: String in lines:
		if line.begins_with("for ") or line.begins_with("while "):
			hits.append("loop: %s" % line)
	var literals: PackedStringArray = _numeric_literals(code)
	for literal: String in literals:
		if literal != "0.0":
			hits.append("literal %s" % literal)
	_expect(hits.is_empty(), "the mote names or does: %s" % ", ".join(hits))
	print("  2 fields; %d methods pinned, none defaulting an argument; %d collection steps in order; %d gates each return on the next line; literals %s"
		% [signatures.size(), COLLECTION_ORDER.size(), REFUSING_GATES.size(), str(literals)])
	print("  0 percentage operations, requirements, seeds, offers, positions, distances or pickup queries; names only %s"
		% ", ".join(PackedStringArray(AUTHORIZED_CLASSES)))
	_done("the_collection_order_is_pinned_and_the_mote_restates_nothing")


# --- 11. Unwired -----------------------------------------------------------------------------------------

func _check_nothing_runs_it() -> void:
	print("")
	print("--- 11. Nothing that runs creates or collects a mote, and scripts/experience/ holds six scripts")
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if path == MOTE_FILE:
				continue
			project_files += 1
			var text: String = FileAccess.get_file_as_string(path)
			for token: String in [MOTE_CLASS, "collect_into(", MOTE_FILE.get_file()]:
				if text.contains(token) and not _reader_may_name(path, token):
					referenced.append("%s names %s" % [path.get_file(), token])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for token: String in [MOTE_CLASS, MOTE_FILE.get_file()]:
		if settings.contains(token):
			referenced.append("project.godot names %s" % token)
	_expect(referenced.is_empty(), "a mote is created or collected by code that runs: %s" % ", ".join(referenced))
	_expect(project_files > 100, "only %d project files were scanned" % project_files)
	_expect(not settings.contains("[autoload]"), "project.godot declares an [autoload] section")
	_expect(String(ProjectSettings.get_setting("application/run/main_scene", ""))
			== "res://scenes/app/prototype_app.tscn",
		"the entrypoint moved")

	var experience_scripts: PackedStringArray = _files_under("res://scripts/experience", [".gd"])
	experience_scripts.sort()
	_expect(", ".join(experience_scripts) == ", ".join(PackedStringArray(EXPERIENCE_SCRIPTS)),
		"scripts/experience/ holds: %s" % ", ".join(experience_scripts))
	print("  0 unauthorized project files create or collect a mote (%d readers granted by file and token); scripts/experience/ holds 6 scripts; %d files scanned"
		% [AUTHORIZED_READERS.size(), project_files])
	print("  %d refusals and %d collections were driven across this suite" % [_refusals, _collections])
	_done("nothing_that_runs_creates_or_collects_a_mote_and_the_directory_holds_six_scripts")


## Whether `path` is granted `token` in `AUTHORIZED_READERS`.
func _reader_may_name(path: String, token: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) == path:
			return (row[1] as Array).has(token)
	return false


# --- Fixtures -----------------------------------------------------------------------------------------------

func _open(run: RiftRunLevelCoordinator) -> String:
	return run.open_current_offer(
		SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(),
		PassiveCardCatalogue.records()
	)


## `count` new motes of `base`, each collected into `run` and each required to be
## accepted.
func _collect_many(run: RiftRunLevelCoordinator, count: int, base: float) -> Array[RiftExperienceMote]:
	var motes: Array[RiftExperienceMote] = []
	for index: int in count:
		var mote: RiftExperienceMote = RiftExperienceMote.new(base)
		_expect_collected(mote.collect_into(run), "test mote %d of %d" % [index + 1, count])
		motes.append(mote)
	return motes


## Run seed 10 after a mote of 150, an explicit open and the Utility lane: Level 2
## holding the shipped Experience Gain card, with 50 kept.
func _insight_run() -> RiftRunLevelCoordinator:
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(GAIN_SEED)
	_expect_collected(RiftExperienceMote.new(GAIN_OPENING_MOTE).collect_into(run), "the Experience Gain fixture's mote")
	_expect_accepted(_open(run), "the Experience Gain fixture's offer")
	var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.UTILITY)
	var gain_held: bool = run.run_build().stat_totals().total_for(PlayerStats.EXPERIENCE_GAIN) > 0.0
	_expect(outcome.succeeded() and gain_held and run.experience() == GAIN_KEPT,
		"the Experience Gain fixture is not holding the card with %s kept: %s" % [
			_exact(GAIN_KEPT), _snapshot(run)])
	return run


## The run's current lifecycle, READ by name — never written. The run itself never
## hands it out.
func _lifecycle_of(run: RiftRunLevelCoordinator) -> RiftLevelUpCoordinator:
	return run.get("_current") as RiftLevelUpCoordinator


func _smallest_positive_double() -> float:
	var value: float = 1.0
	while value / 2.0 > 0.0:
		value = value / 2.0
	return value


# --- Assertions -----------------------------------------------------------------------------------------------

func _expect_accepted(refusal: String, described: String) -> void:
	_expect(refusal.is_empty(), "%s was refused: %s" % [described, refusal])


func _expect_collected(refusal: String, described: String) -> void:
	_collections += 1
	_expect(refusal.is_empty(), "%s was not collected: %s" % [described, refusal])


func _expect_refused(refusal: String, described: String) -> void:
	_refusals += 1
	_expect(not refusal.strip_edges().is_empty(), "%s was accepted" % described)


# --- Snapshots -------------------------------------------------------------------------------------------------

## THE WHOLE RUN AS ONE LINE: the seed, the level, the experience to seventeen
## places, the offer's whole identity, the frozen requirement, the current
## requirement, every pair's rank, every card's count and identity, and the ledger.
func _snapshot(run: RiftRunLevelCoordinator) -> String:
	var lanes: PackedStringArray = PackedStringArray()
	for lane: int in run.offer_lanes():
		lanes.append("%d:%s" % [lane, " -> ".join(run.offer_identity_for(lane))])
	var build: RiftRunBuild = run.run_build()
	var ranks: PackedStringArray = PackedStringArray()
	for pair: String in build.support_pairs():
		var parts: PackedStringArray = pair.split(" -> ")
		ranks.append("%s@%d" % [pair, build.support_rank_for(StringName(parts[0]), StringName(parts[1]))])
	var cards: PackedStringArray = PackedStringArray()
	for card_id: StringName in build.acquired_card_ids():
		cards.append("%s x%d {%s}" % [
			card_id, build.acquisitions_for(card_id), build.mechanical_identity_for(card_id)])
	return "seed=%d level=%d experience=%s offer=%s root=%d frozen=%s lanes=[%s] needs=%s | ranks [%s] | cards [%s] | seeds %s" % [
		run.run_seed(), run.level(), _exact(run.experience()), str(run.is_offer_active()),
		run.offer_root_seed(), _exact(run.frozen_requirement()), ", ".join(lanes),
		run.requirement_reading().describe(), ", ".join(ranks), ", ".join(cards),
		str(run.consumption_ledger().consumed_seeds()),
	]


func _mote(mote: RiftExperienceMote) -> String:
	return "base=%s collected=%s" % [_exact(mote.base_experience()), str(mote.is_collected())]


func _exact(value: float) -> String:
	if is_nan(value) or is_inf(value) or absf(value) >= 1.0e17 or (value != 0.0 and absf(value) < 1.0e-6):
		return String.num_scientific(value)
	return String.num(value, 17)


# --- Source reading ------------------------------------------------------------------------------------------------

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
## side. An underscore does not break a match, so `pickup_radius` is still caught.
func _names_word(code: String, token: String) -> bool:
	var bounded: RegEx = RegEx.create_from_string("(?<![A-Za-z0-9])%s(?![A-Za-z0-9])" % token)
	return bounded.search(code) != null


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
## rendering the accepted G4 pin uses.
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


# --- The owed set -----------------------------------------------------------------------------------------------------

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
