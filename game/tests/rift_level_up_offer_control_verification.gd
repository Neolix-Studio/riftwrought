extends SceneTree
## Riftwrought — Roguelite Foundation I1 verification: run-owned level-up offer
## control on the accepted H8 Experience-Mote runtime (decision D-291).
##
## WHAT IS PROVED. The owner of one `RiftMoteRuntime` can explicitly open the current
## Rift level's three-lane offer, inspect it through copies and scalars, explicitly
## take one lane, and receive the run's own accepted level-up record — and every one
## of those answers is the run's (Foundation G4), handed back unchanged.
##
## EXPERIENCE ARRIVES THROUGH THE ACCEPTED MOTE PATH AND NO OTHER. Every point of
## experience a runtime here holds was dropped by a real production Graveblade's own
## mechanical death — every hit through its public `receive_damage()` — and paid by
## an explicit sweep of the runtime's own field. The runtime has no award shortcut and
## this harness asks for none. The 25.0, 24.0 and 1.0 amounts are REVIEW-ONLY TEST
## EVIDENCE, never balance.
##
## EVERY EXPECTED ANSWER IS THE ACCEPTED MECHANISM'S OWN, asked directly. Beside each
## runtime stands a TWIN: a G4 run and an H5 field made directly with the same seed,
## given the same drops at the same places and swept from the same places — so the
## twin's experience arrives by the same accepted path, and its answers to opening,
## reading, choosing and sweeping are what the runtime's must equal. G1 is asked for
## the requirement and G2 for the root seed directly, and D1's own fixed lane order is
## read, never retyped. The shipped catalogues and the Quick Strike profile are read
## through their existing public accessors.
##
## THE HARNESS NEVER REACHES INSIDE THE RUNTIME. It reads and writes no private member
## of the runtime or of anything it owns. It reads the runtime's property LIST to count
## its fields, and its source to read its bodies.
##
## IT PORTS D-211's OWED-SET DISCIPLINE, and the one check that lets frames pass runs
## LAST among the behavioural checks.
##
## IT READS NO OTHER SUITE. It names no file under `tests/` but its own.

# --- The files -------------------------------------------------------------------------

const RUNTIME_FILE: String = "res://scripts/experience/rift_mote_runtime.gd"
const THIS_FILE: String = "res://tests/rift_level_up_offer_control_verification.gd"
const RUNTIME_CLASS: String = "RiftMoteRuntime"

## The one running file granted the runtime's class (D-288): the Experience Collection
## Greybox Review. It must call none of Foundation I1's operations.
const REVIEW_FILE: String = "res://scripts/roguelite/experience/roguelite_experience_collection_review.gd"

## Roguelite I2 (decision D-293): the one running file granted Foundation I1's
## operations — the Playable Three-Lane Level-Up Choice Review, an isolated scene
## launched by name. It reaches the runtime only through the field it inherits from
## the review above, never by naming the runtime's class, and calls exactly these four
## of the six: it opens the one offer, reads its lanes and each lane's identity, and
## takes one lane. Check 14 makes the same single assertion, it still fails for any
## other file and for any operation this file is not granted, and the pinned count
## does not move.
const LEVEL_UP_REVIEW_FILE: String = "res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd"
const LEVEL_UP_REVIEW_CALLS: Array[String] = [
	"open_level_up_offer", "offer_lanes", "offer_identity_for", "choose_level_up_lane",
]

const GRAVEBLADE_SCENE: String = "res://scenes/actors/prototype_graveblade.tscn"

const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data", "res://addons"]
const PROJECT_SETTINGS_FILE: String = "res://project.godot"

# --- What Foundation I1 added, and what each hands its question to ------------------------

const I1_METHODS: Array[String] = [
	"open_level_up_offer", "offer_root_seed", "offer_lanes", "offer_identity_for",
	"frozen_offer_requirement", "choose_level_up_lane",
]

## EACH DELEGATION'S WHOLE BODY, and the accepted G4 method that owns its answer.
const DELEGATIONS: Array = [
	["open_level_up_offer", "return _run.open_current_offer(profiles, definitions, cards)", "open_current_offer"],
	["offer_root_seed", "return _run.offer_root_seed()", "offer_root_seed"],
	["offer_lanes", "return _run.offer_lanes()", "offer_lanes"],
	["offer_identity_for", "return _run.offer_identity_for(lane)", "offer_identity_for"],
	["frozen_offer_requirement", "return _run.frozen_requirement()", "frozen_requirement"],
	["choose_level_up_lane", "return _run.choose(lane)", "choose"],
]

## H8's accepted state: three private fields and no fourth.
const RUNTIME_FIELDS: Array[String] = ["_run", "_field", "_bindings"]

## What the runtime must never do itself, because an accepted foundation owns it:
## G1's requirement, G2's seed, D1's composition and lane order, D2's build, D3's
## ledger, E2's lifecycle and receipt, G4's record constructor — and any copying of
## its own. Read over CODE with its comments removed and its strings emptied.
const BYPASS_TOKENS: Array[String] = [
	"RiftLevelRequirement", "requirement_for", "RiftLevelOfferSeed", "offer_root_seed_for",
	"RiftOffer", "LANE_ORDER", "Lane.", "compose", "reading_for", "has_consumed",
	"consumption_ledger", "run_build", "RiftRunBuild", "acquire", "advance_one_level",
	"award_experience", "next_level_coordinator", "RiftLevelUpCoordinator", "open_offer(",
	"RiftLevelUpResult", ".recorded(", "duplicate", "identity_size_for", "Catalogue",
	"level() ==", "experience() >=", "if _run.",
]

# --- The accepted wordings, typed independently and also asked of the twin -------------------

const NOT_YET_PREFIX: String = "no offer opens yet for level 1 — "
const NOT_YET_LEVEL_TWO_PREFIX: String = "no offer opens yet for level 2 — "
const ALREADY_OPEN: String = "level 1 already has an offer open; only a lane of that offer may be taken"
const NO_OFFER: String = "no offer is open; one must be opened before a lane may be taken"
const OFFER_OPEN_AWARD: String = "an offer is open; it must be resolved before further experience is recorded"
const NOTHING_COMPOSED_PREFIX: String = "no offer composed: "

# --- The fixtures, stated independently -------------------------------------------------------

const OWNER_SEED: int = 99

## G4's accepted Experience-Gain seed (D-270): its Level-1 Utility lane offers the card
## that raises Experience Gain — the one build change a runtime's own sweep can show.
const GAIN_SEED: int = 10

## Test evidence only: 100 is the accepted starter Quick Strike's Physical damage.
const HIT: float = 100.0
const TEST_MOTE: float = 25.0
const SHORT_MOTE: float = 24.0
const TOP_UP_MOTE: float = 1.0

const UNDECLARED_LANES: Array[int] = [7, -1, 3]

## How many refused records the checks before the tally hand it: one choice with no
## offer, three undeclared lanes, one repeated choice per lane after its success, and
## one repeated choice after the copy check's success.
const EXPECTED_REFUSED_RECORDS: int = 8

const OWED_CHECKS: Array[String] = [
	"opening_below_the_requirement_refuses_with_g4s_own_words_and_moves_nothing",
	"reaching_the_requirement_through_motes_opens_nothing_on_its_own",
	"explicit_opening_at_the_requirement_matches_a_directly_driven_g4_twin",
	"a_second_opening_while_the_offer_stands_refuses_unchanged",
	"an_undeclared_lane_is_refused_and_the_same_offer_stands",
	"a_composition_refusal_comes_back_word_for_word",
	"each_lane_succeeds_from_its_own_identical_runtime_and_advances_once",
	"the_surplus_is_retained_exactly_and_no_next_offer_opens",
	"a_standing_offer_refuses_a_mote_until_a_lane_is_taken_then_it_collects_once",
	"a_passive_taken_through_the_runtime_moves_the_runtimes_own_run",
	"every_offer_reading_and_every_record_is_an_independent_copy",
	"every_refused_record_invents_no_identity_and_no_advancement",
	"the_runtime_holds_three_fields_and_only_delegates",
	"nothing_that_runs_calls_the_new_operations",
	"no_offer_opens_and_nothing_pauses_while_frames_pass",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0
var _successes: int = 0
var _deaths_driven: int = 0
var _sweeps: int = 0
var _use: int = 0
var _serial: int = 0

var _stage: Node3D

## Refused records handed to the tally, each with the level its runtime stood at
## when it was refused and afterwards: [record, level before, level after, where].
var _refused_records: Array = []

## THE SHARED NARRATIVE OF CHECKS 1–5 AND 9, stated rather than hidden: one runtime of
## run seed 99 and its twin walk 0 → 25 → 50 → 75 → 99 → 100, open, refuse, and then
## take a lane with a mote left uncollected. Every other check builds its own.
var _main: RiftMoteRuntime
var _main_run: RiftRunLevelCoordinator
var _main_field: RiftMoteField


func _initialize() -> void:
	_run()


func _run() -> void:
	await process_frame
	print("")
	print("=== Roguelite Foundation I1 — Run-Owned Level-Up Offer Control (D-291) ===")
	_stage = Node3D.new()
	_stage.name = "I1Stage"
	root.add_child(_stage)
	_expect(root.is_inside_tree() and _stage.is_inside_tree(), "the stage did not enter the tree")

	_check_opening_below_the_requirement()
	_check_reaching_the_requirement()
	_check_explicit_opening()
	_check_a_second_opening()
	_check_undeclared_lanes()
	_check_a_composition_refusal()
	_check_each_lane()
	_check_the_surplus()
	_check_the_standing_offer_and_a_mote()
	_check_a_passive_moves_the_runtimes_own_run()
	_check_copies()
	_check_refused_records()
	_check_the_shape()
	_check_nothing_calls_it()
	await _check_frames()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT LEVEL-UP OFFER CONTROL VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT LEVEL-UP OFFER CONTROL VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. Below the requirement ------------------------------------------------------------------

func _check_opening_below_the_requirement() -> void:
	print("")
	print("--- 1. At 0, 25, 50, 75 and 99 experience, opening refuses with G4's own words and moves nothing; a choice with no offer is refused")
	_main = RiftMoteRuntime.new(OWNER_SEED)
	_main_run = RiftRunLevelCoordinator.new(OWNER_SEED)
	_main_field = RiftMoteField.new(OWNER_SEED)
	var amounts: Array[float] = [TEST_MOTE, TEST_MOTE, TEST_MOTE, SHORT_MOTE]
	var ladder: PackedStringArray = PackedStringArray()
	var verbatim: int = 0
	for step: int in amounts.size() + 1:
		if step > 0:
			var fell: Vector3 = _drop(_main, _main_field, amounts[step - 1], Vector3(12.0 * step, 0.0, 0.0))
			_sweep_both(_main, _main_run, _main_field, fell)
		var before: String = _state(_main)
		var answer: String = _main.open_level_up_offer(_profiles(), _definitions(), _cards())
		var twin_answer: String = _main_run.open_current_offer(_profiles(), _definitions(), _cards())
		var after: String = _state(_main)
		_refusals += 1
		var held: bool = (answer == twin_answer and answer.begins_with(NOT_YET_PREFIX) and after == before
			and not _main.is_offer_active() and _main.level() == 1 and _run_state(_main) == _twin_state(_main_run))
		_expect(held, "at %s the runtime answered '%s' where G4 answered '%s'; it moved %s -> %s" % [
			_exact(_main.experience()), answer, twin_answer, before, after])
		if held:
			verbatim += 1
		ladder.append("%s -> '%s'" % [_exact(_main.experience()), answer])

	## A CHOICE WITH NO OFFER is refused, exactly as the run refuses it, and moves nothing.
	var before_choice: String = _state(_main)
	var early: RiftRunLevelUpResult = _main.choose_level_up_lane(RiftOffer.Lane.SUPPORT)
	var twin_early: RiftRunLevelUpResult = _main_run.choose(RiftOffer.Lane.SUPPORT)
	_note_refused(early, 1, _main.level(), "a choice before any offer")
	_expect(_record(early) == _record(twin_early) and early.failure_reason() == NO_OFFER
			and early.run_seed == OWNER_SEED and early.source_level == 1
			and not early.level_up().root_seed_known and _state(_main) == before_choice,
		"a choice with no offer answered %s where G4 answered %s" % [_record(early), _record(twin_early)])
	print("  %d of %d refusals word for word as G4's: %s" % [verbatim, amounts.size() + 1, "; ".join(ladder)])
	print("  a choice with no offer: '%s', run seed %d at level %d, no root seed known — and nothing moved"
		% [early.failure_reason(), early.run_seed, early.source_level])
	_done("opening_below_the_requirement_refuses_with_g4s_own_words_and_moves_nothing")


# --- 2. Reaching the requirement ------------------------------------------------------------------

func _check_reaching_the_requirement() -> void:
	print("")
	print("--- 2. The top-up mote reaches exactly 100 through a sweep; nothing opens, advances, pauses or appears")
	var children_before: int = root.get_child_count()
	var fell: Vector3 = _drop(_main, _main_field, TOP_UP_MOTE, Vector3(60.0, 0.0, 0.0))
	var result: RiftMoteSweepResult = _sweep_both(_main, _main_run, _main_field, fell)
	var needed: RiftLevelRequirementReading = RiftLevelRequirementCurve.requirement_for(1)
	var requirement: float = needed.experience_requirement() if needed.ok else -1.0
	_expect(result.collected_indices() == PackedInt32Array([4]) and _main.experience() == requirement
			and requirement == 100.0 and _main.level() == 1 and not _main.is_offer_active()
			and _main.offer_lanes().is_empty() and _main.frozen_offer_requirement() == _main_run.frozen_requirement()
			and _main.offer_root_seed() == _main_run.offer_root_seed() and _run_state(_main) == _twin_state(_main_run),
		"at the requirement the runtime reads %s against G1's %s" % [_state(_main), _exact(requirement)])
	_expect(not paused and root.get_child_count() == children_before,
		"reaching the requirement paused the tree (%s) or added a node (%d -> %d)" % [
			str(paused), children_before, root.get_child_count()])
	print("  the sweep collected %s: experience %s = G1's Level 1 requirement %s; level %d, offer %s, lanes %s, paused %s, %d root children before and after"
		% [str(result.collected_indices()), _exact(_main.experience()), _exact(requirement), _main.level(),
			str(_main.is_offer_active()), str(_main.offer_lanes()), str(paused), root.get_child_count()])
	_done("reaching_the_requirement_through_motes_opens_nothing_on_its_own")


# --- 3. Explicit opening --------------------------------------------------------------------------

func _check_explicit_opening() -> void:
	print("")
	print("--- 3. Explicit opening at 100 succeeds, and every reading equals the directly driven G4 twin's, G1's, G2's and D1's")
	var before: String = _state(_main)
	var answer: String = _main.open_level_up_offer(_profiles(), _definitions(), _cards())
	var twin_answer: String = _main_run.open_current_offer(_profiles(), _definitions(), _cards())
	_expect(answer.is_empty() and twin_answer.is_empty() and _main.is_offer_active() and _main_run.is_offer_active(),
		"opening answered '%s' where G4 answered '%s'" % [answer, twin_answer])

	var seed_reading: RiftLevelOfferSeedReading = RiftLevelOfferSeedDerivation.offer_root_seed_for(OWNER_SEED, 1)
	var needed: RiftLevelRequirementReading = RiftLevelRequirementCurve.requirement_for(1)
	_expect(seed_reading.ok and _main.offer_root_seed() == seed_reading.offer_root_seed
			and _main.offer_root_seed() == _main_run.offer_root_seed(),
		"the root seed reads %d, the twin %d, G2 %d" % [
			_main.offer_root_seed(), _main_run.offer_root_seed(), seed_reading.offer_root_seed])
	_expect(needed.ok and _main.frozen_offer_requirement() == needed.experience_requirement()
			and _main.frozen_offer_requirement() == _main_run.frozen_requirement(),
		"the frozen requirement reads %s, the twin %s, G1 %s" % [
			_exact(_main.frozen_offer_requirement()), _exact(_main_run.frozen_requirement()),
			_exact(needed.experience_requirement())])
	var lanes: Array[int] = _main.offer_lanes()
	_expect(lanes == RiftOffer.LANE_ORDER and lanes == _main_run.offer_lanes() and lanes.size() == 3
			and lanes[0] == RiftOffer.Lane.SUPPORT and lanes[1] == RiftOffer.Lane.COMBAT_DEFENCE
			and lanes[2] == RiftOffer.Lane.UTILITY,
		"the lanes read %s, the twin %s, D1's order %s" % [str(lanes), str(_main_run.offer_lanes()), str(RiftOffer.LANE_ORDER)])
	var shapes: int = 0
	var contents: PackedStringArray = PackedStringArray()
	for lane: int in lanes:
		var identity: PackedStringArray = _main.offer_identity_for(lane)
		if identity == _main_run.offer_identity_for(lane) and identity.size() == RiftOfferChoiceResult.identity_size_for(lane):
			shapes += 1
		contents.append("%s [%s]" % [RiftOffer.lane_label(lane), ", ".join(identity)])
	_expect(shapes == 3, "%d of 3 lanes read the twin's identity at D3's own size" % shapes)
	_expect(_offer(_main) == _twin_offer(_main_run), "the offer reads %s where the twin reads %s" % [
		_offer(_main), _twin_offer(_main_run)])

	## OPENING IS NOT CHOOSING AND NOT ADVANCING.
	_expect(_main.level() == 1 and _main.experience() == 100.0 and _main.drop_count() == 5
			and _main.collected_count() == 5 and _main.uncollected_count() == 0
			and _run_state(_main) == _twin_state(_main_run) and before.begins_with("seed=99 level=1 experience=100.0"),
		"opening moved the runtime from %s to %s" % [before, _state(_main)])
	_successes += 1
	print("  open_level_up_offer(): '%s' — root seed %d (G2: %d), frozen requirement %s (G1: %s), lanes %s (D1: %s)"
		% [answer, _main.offer_root_seed(), seed_reading.offer_root_seed, _exact(_main.frozen_offer_requirement()),
			_exact(needed.experience_requirement()), str(lanes), str(RiftOffer.LANE_ORDER)])
	print("  seed 99's Level 1 offer: %s — %d of 3 identical to the twin's, at D3's own sizes" % ["; ".join(contents), shapes])
	print("  opening chose nothing and advanced nothing: level %d, experience %s, 5 drops all collected" % [
		_main.level(), _exact(_main.experience())])
	_done("explicit_opening_at_the_requirement_matches_a_directly_driven_g4_twin")


# --- 4. A second opening ----------------------------------------------------------------------------

func _check_a_second_opening() -> void:
	print("")
	print("--- 4. Opening again while the offer stands refuses with G4's own words and moves nothing")
	var before: String = _state(_main)
	var answer: String = _main.open_level_up_offer(_profiles(), _definitions(), _cards())
	var twin_answer: String = _main_run.open_current_offer(_profiles(), _definitions(), _cards())
	_refusals += 1
	_expect(answer == twin_answer and answer == ALREADY_OPEN and _state(_main) == before and _main.is_offer_active(),
		"a second opening answered '%s' where G4 answered '%s'; %s -> %s" % [answer, twin_answer, before, _state(_main)])
	print("  a second opening answered '%s', as G4 does; the offer and the run are unchanged" % answer)
	_done("a_second_opening_while_the_offer_stands_refuses_unchanged")


# --- 5. Undeclared lanes -------------------------------------------------------------------------------

func _check_undeclared_lanes() -> void:
	print("")
	print("--- 5. An undeclared lane is refused with the run's own reason; the same offer still stands and nothing moved")
	var before: String = _state(_main)
	var twin_before: String = _twin_state(_main_run)
	var kept: int = 0
	var reasons: PackedStringArray = PackedStringArray()
	for lane: int in UNDECLARED_LANES:
		var refused: RiftRunLevelUpResult = _main.choose_level_up_lane(lane)
		var twin_refused: RiftRunLevelUpResult = _main_run.choose(lane)
		_note_refused(refused, 1, _main.level(), "undeclared lane %d" % lane)
		var receipt: RiftLevelUpResult = refused.level_up()
		var held: bool = (_record(refused) == _record(twin_refused) and not refused.succeeded()
			and refused.run_seed == OWNER_SEED and refused.source_level == 1 and receipt.root_seed_known
			and receipt.root_seed == _main.offer_root_seed() and receipt.lane == lane
			and _state(_main) == before and _twin_state(_main_run) == twin_before and _main.is_offer_active())
		_expect(held, "lane %d answered %s where G4 answered %s; %s -> %s" % [
			lane, _record(refused), _record(twin_refused), before, _state(_main)])
		if held:
			kept += 1
		reasons.append("%d: '%s'" % [lane, refused.failure_reason()])
	print("  %d of %d undeclared lanes refused exactly as G4 refuses them, each naming run seed 99 at level 1 and root seed %d; the same offer still stands"
		% [kept, UNDECLARED_LANES.size(), _main.offer_root_seed()])
	print("  %s" % reasons[0])
	_done("an_undeclared_lane_is_refused_and_the_same_offer_stands")


# --- 6. A composition refusal ------------------------------------------------------------------------------

func _check_a_composition_refusal() -> void:
	print("")
	print("--- 6. Opening with nothing to compose from is refused with the run's own words; the same runtime then opens with the shipped catalogues")
	var runtime: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_fill(runtime, run, field, 4, Vector3(0.0, 0.0, 100.0))
	var no_profiles: Array[SkillTagProfile] = []
	var no_definitions: Array[SupportDefinition] = []
	var no_cards: Array[PassiveCardDefinition] = []
	var before: String = _state(runtime)
	var answer: String = runtime.open_level_up_offer(no_profiles, no_definitions, no_cards)
	var twin_answer: String = run.open_current_offer(no_profiles, no_definitions, no_cards)
	_refusals += 1
	_expect(answer == twin_answer and answer.begins_with(NOTHING_COMPOSED_PREFIX) and _state(runtime) == before
			and not runtime.is_offer_active(),
		"an empty opening answered '%s' where G4 answered '%s'; %s -> %s" % [answer, twin_answer, before, _state(runtime)])
	var opened: String = runtime.open_level_up_offer(_profiles(), _definitions(), _cards())
	var twin_opened: String = run.open_current_offer(_profiles(), _definitions(), _cards())
	_expect(opened.is_empty() and twin_opened.is_empty() and _offer(runtime) == _twin_offer(run),
		"after the refusal the shipped opening answered '%s' / '%s'" % [opened, twin_opened])
	_successes += 1
	print("  with no profiles, definitions or cards the runtime answered G4's own '%s' and moved nothing; the same runtime then opened ('%s')"
		% [answer, opened])
	_done("a_composition_refusal_comes_back_word_for_word")


# --- 7. Each lane, from its own runtime ------------------------------------------------------------------

func _check_each_lane() -> void:
	print("")
	print("--- 7. Each lane, taken from its own independently built identical runtime, succeeds exactly as G4 takes it and advances exactly one level")
	var succeeded: int = 0
	for lane: int in RiftOffer.LANE_ORDER:
		var runtime: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
		var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
		var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
		_fill(runtime, run, field, 4, Vector3(0.0, 0.0, 200.0 + 60.0 * lane))
		_expect_accepted(runtime.open_level_up_offer(_profiles(), _definitions(), _cards()), "lane %d's opening" % lane)
		_expect_accepted(run.open_current_offer(_profiles(), _definitions(), _cards()), "lane %d's twin opening" % lane)
		var identity: PackedStringArray = runtime.offer_identity_for(lane)
		var root_seed: int = runtime.offer_root_seed()

		var outcome: RiftRunLevelUpResult = runtime.choose_level_up_lane(lane)
		var twin_outcome: RiftRunLevelUpResult = run.choose(lane)
		_successes += 1
		var receipt: RiftLevelUpResult = outcome.level_up()
		_expect(outcome.succeeded() and outcome.problem().is_empty() and outcome.run_seed == OWNER_SEED
				and outcome.source_level == 1 and receipt.ok and receipt.lane == lane and receipt.root_seed_known
				and receipt.root_seed == root_seed and receipt.granted_identity() == identity
				and _record(outcome) == _record(twin_outcome),
			"lane %d answered %s where G4 answered %s" % [lane, _record(outcome), _record(twin_outcome)])

		## THE CONSUMED OPERATION, COPIED THROUGH F5 — never read out of a build here.
		var build: RiftRunBuild = run.run_build()
		var change: String = ""
		if lane == RiftOffer.Lane.SUPPORT:
			var skill: StringName = StringName(identity[0])
			var support: StringName = StringName(identity[1])
			_expect(receipt.carries_support_progression()
					and receipt.support_progression_kind == SupportContinuationResult.Kind.NEW_PAIR
					and receipt.support_rank_before == 0 and receipt.support_rank_after == 1
					and build.support_rank_for(skill, support) == 1 and build.support_count() == 1
					and build.passive_acquisitions() == 0,
				"the Support lane carried %s; the twin's build reads %s" % [receipt.support_progression_line(), build.describe()])
			change = "%s; the twin's build holds %s -> %s at rank %d" % [
				receipt.support_progression_line(), skill, support, build.support_rank_for(skill, support)]
		else:
			var card: StringName = StringName(identity[0])
			_expect(not receipt.carries_support_progression()
					and receipt.support_progression_kind == RiftOffer.UNRESOLVED_PROGRESSION_KIND
					and receipt.support_rank_before == RiftOfferChoiceResult.NO_RANK
					and receipt.support_rank_after == RiftOfferChoiceResult.NO_RANK
					and build.acquisitions_for(card) == 1 and build.passive_acquisitions() == 1
					and build.support_count() == 0,
				"the %s lane carried %s; the twin's build reads %s" % [
					RiftOffer.lane_label(lane), receipt.support_progression_line(), build.describe()])
			change = "%s; the twin's build holds %s x%d" % [
				receipt.support_progression_line(), card, build.acquisitions_for(card)]

		## EXACTLY ONE LEVEL, THE OFFER CLOSED, THE SEED SPENT ONCE, NOTHING FURTHER OPENED.
		_expect(runtime.level() == 2 and runtime.experience() == 0.0 and not runtime.is_offer_active()
				and runtime.offer_lanes().is_empty() and _run_state(runtime) == _twin_state(run)
				and run.consumption_ledger().count() == 1 and run.consumption_ledger().has_consumed(root_seed),
			"after lane %d the runtime reads %s and the twin's ledger %s" % [lane, _state(runtime), run.consumption_ledger().describe()])
		var again: RiftRunLevelUpResult = runtime.choose_level_up_lane(lane)
		var twin_again: RiftRunLevelUpResult = run.choose(lane)
		_note_refused(again, 2, runtime.level(), "lane %d taken a second time" % lane)
		var next_open: String = runtime.open_level_up_offer(_profiles(), _definitions(), _cards())
		var twin_next_open: String = run.open_current_offer(_profiles(), _definitions(), _cards())
		_refusals += 1
		_expect(_record(again) == _record(twin_again) and again.failure_reason() == NO_OFFER and runtime.level() == 2
				and next_open == twin_next_open and next_open.begins_with(NOT_YET_LEVEL_TWO_PREFIX)
				and not runtime.is_offer_active() and run.consumption_ledger().count() == 1,
			"lane %d taken again answered %s and opening answered '%s'" % [lane, _record(again), next_open])
		if outcome.succeeded() and _record(outcome) == _record(twin_outcome):
			succeeded += 1
		print("  %s: granted [%s] from root seed %d — %s; then level %d, experience %s, no offer; taken again: '%s'; opening: '%s'"
			% [RiftOffer.lane_label(lane), ", ".join(receipt.granted_identity()), receipt.root_seed, change,
				runtime.level(), _exact(runtime.experience()), again.failure_reason(), next_open])
	print("  %d of 3 lanes succeeded from 3 independently built runtimes, each record identical to G4's, each advancing exactly one level with the root seed spent once"
		% succeeded)
	_done("each_lane_succeeds_from_its_own_identical_runtime_and_advances_once")


# --- 8. The surplus -------------------------------------------------------------------------------------------

func _check_the_surplus() -> void:
	print("")
	print("--- 8. With 125 experience a choice keeps a surplus of exactly 25, and no next offer opens on its own or when asked")
	var runtime: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_fill(runtime, run, field, 5, Vector3(0.0, 0.0, 400.0))
	_expect(runtime.experience() == 125.0 and runtime.level() == 1 and not runtime.is_offer_active(),
		"five motes left %s" % _state(runtime))
	_expect_accepted(runtime.open_level_up_offer(_profiles(), _definitions(), _cards()), "the 125 opening")
	_expect_accepted(run.open_current_offer(_profiles(), _definitions(), _cards()), "the 125 twin opening")
	var outcome: RiftRunLevelUpResult = runtime.choose_level_up_lane(RiftOffer.Lane.COMBAT_DEFENCE)
	var twin_outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_successes += 1
	var after_choice: String = _state(runtime)
	_expect(outcome.succeeded() and _record(outcome) == _record(twin_outcome) and runtime.level() == 2
			and runtime.experience() == 25.0 and not runtime.is_offer_active() and _run_state(runtime) == _twin_state(run),
		"after the choice the runtime reads %s" % after_choice)
	var asked: String = runtime.open_level_up_offer(_profiles(), _definitions(), _cards())
	var twin_asked: String = run.open_current_offer(_profiles(), _definitions(), _cards())
	_refusals += 1
	_expect(asked == twin_asked and asked.begins_with(NOT_YET_LEVEL_TWO_PREFIX) and _state(runtime) == after_choice,
		"asked to open at level 2 with 25 the runtime answered '%s' where G4 answered '%s'" % [asked, twin_asked])
	print("  125.0 -> choice -> level %d with %s retained, no offer; asked to open: '%s', as G4 answers"
		% [runtime.level(), _exact(runtime.experience()), asked])
	print("  and with exactly 100.0 (check 7) every one of the three lanes retained 0.0")
	_done("the_surplus_is_retained_exactly_and_no_next_offer_opens")


# --- 9. A standing offer and a mote ------------------------------------------------------------------------------

func _check_the_standing_offer_and_a_mote() -> void:
	print("")
	print("--- 9. While the offer stands an in-range mote is refused through H5 and G4 and stays uncollected; after a lane is taken the same mote collects once")
	var offer_before: String = _offer(_main)
	var fell: Vector3 = _drop(_main, _main_field, TEST_MOTE, Vector3(72.0, 0.0, 0.0))
	var dropped: String = _state(_main)
	var refused: RiftMoteSweepResult = _sweep_both(_main, _main_run, _main_field, fell)
	_refusals += 1
	_expect(refused.ok and refused.attempted_count == 1 and refused.collected_indices().is_empty()
			and refused.item_refusal_count == 1 and refused.first_item_refusal_reason == OFFER_OPEN_AWARD
			and _main.experience() == 100.0 and _main.uncollected_count() == 1 and _main.is_offer_active()
			and _offer(_main) == offer_before and _state(_main) == dropped,
		"the sweep under a standing offer answered %s and the runtime reads %s" % [_sweep(refused), _state(_main)])

	var outcome: RiftRunLevelUpResult = _main.choose_level_up_lane(RiftOffer.Lane.UTILITY)
	var twin_outcome: RiftRunLevelUpResult = _main_run.choose(RiftOffer.Lane.UTILITY)
	_successes += 1
	_expect(outcome.succeeded() and _record(outcome) == _record(twin_outcome) and _main.level() == 2
			and _main.experience() == 0.0 and _main.uncollected_count() == 1,
		"the choice answered %s and the runtime reads %s" % [_record(outcome), _state(_main)])
	var collected: RiftMoteSweepResult = _sweep_both(_main, _main_run, _main_field, fell)
	_expect(collected.ok and collected.collected_indices() == PackedInt32Array([5]) and collected.item_refusal_count == 0
			and _main.experience() == TEST_MOTE and _main.level() == 2 and _main.uncollected_count() == 0
			and not _main.is_offer_active() and _run_state(_main) == _twin_state(_main_run),
		"after the choice the same place answered %s and the runtime reads %s" % [_sweep(collected), _state(_main)])
	var again: RiftMoteSweepResult = _sweep_both(_main, _main_run, _main_field, fell)
	_expect(again.ok and again.skipped_count == 6 and again.attempted_count == 0 and _main.experience() == TEST_MOTE,
		"a further sweep answered %s" % _sweep(again))
	print("  under the standing offer: attempted %d, collected %s, refused %d with '%s'; experience %s, %d uncollected, the same offer standing"
		% [refused.attempted_count, str(refused.collected_indices()), refused.item_refusal_count,
			refused.first_item_refusal_reason, _exact(100.0), 1])
	print("  after %s was taken (level %d, experience 0.0) the same place collected %s and paid %s; a further sweep skipped %d and paid nothing"
		% [RiftOffer.lane_label(RiftOffer.Lane.UTILITY), _main.level(), str(collected.collected_indices()),
			_exact(_main.experience()), again.skipped_count])
	_done("a_standing_offer_refuses_a_mote_until_a_lane_is_taken_then_it_collects_once")


# --- 10. A passive moves the runtime's own run ----------------------------------------------------------------------

## Seed 99's three Level 1 effects — a support pair, Skill Speed and Movement Speed —
## are none of them visible through the runtime's readings, and the runtime deliberately
## hands out no run build. Experience Gain is the one effect its own sweep pays through,
## so G4's accepted gain seed shows that the choice moved THE RUNTIME'S OWN run, not
## only a twin's.
func _check_a_passive_moves_the_runtimes_own_run() -> void:
	print("")
	print("--- 10. The Experience Gain card, taken through the runtime, raises what the runtime's OWN next sweep pays; a runtime that took another lane is paid the base")
	var gain_card: StringName = &""
	for record: PassiveCardDefinition in PassiveCardCatalogue.records():
		if record.stat_id == PlayerStats.EXPERIENCE_GAIN:
			gain_card = record.card_id
	var paid: Array[float] = []
	var twin_paid: Array[float] = []
	var granted: PackedStringArray = PackedStringArray()
	for lane: int in [RiftOffer.Lane.UTILITY, RiftOffer.Lane.COMBAT_DEFENCE]:
		var runtime: RiftMoteRuntime = RiftMoteRuntime.new(GAIN_SEED)
		var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(GAIN_SEED)
		var field: RiftMoteField = RiftMoteField.new(GAIN_SEED)
		_fill(runtime, run, field, 4, Vector3(0.0, 0.0, 500.0 + 60.0 * lane))
		_expect_accepted(runtime.open_level_up_offer(_profiles(), _definitions(), _cards()), "gain lane %d's opening" % lane)
		_expect_accepted(run.open_current_offer(_profiles(), _definitions(), _cards()), "gain lane %d's twin opening" % lane)
		var outcome: RiftRunLevelUpResult = runtime.choose_level_up_lane(lane)
		_expect(outcome.succeeded() and _record(outcome) == _record(run.choose(lane)), "gain lane %d answered %s" % [lane, _record(outcome)])
		_successes += 1
		granted.append(", ".join(outcome.level_up().granted_identity()))
		var fell: Vector3 = _drop(runtime, field, TEST_MOTE, Vector3(48.0, 0.0, 500.0 + 60.0 * lane))
		_sweep_both(runtime, run, field, fell)
		paid.append(runtime.experience())
		twin_paid.append(run.experience())
	_expect(gain_card != &"" and granted[0] == String(gain_card) and paid == twin_paid
			and paid[1] == TEST_MOTE and paid[0] > paid[1],
		"the gain card %s was granted as [%s]; the runtime's next sweeps paid %s, the twins' %s" % [
			gain_card, granted[0], str(paid), str(twin_paid)])
	print("  run seed %d: Utility granted [%s] (the catalogue's Experience Gain card) and the runtime's own next 25.0 mote paid %s; Combat and Defence granted [%s] and paid %s — each exactly as its twin"
		% [GAIN_SEED, granted[0], _exact(paid[0]), granted[1], _exact(paid[1])])
	_done("a_passive_taken_through_the_runtime_moves_the_runtimes_own_run")


# --- 11. Copies ----------------------------------------------------------------------------------------------------

func _check_copies() -> void:
	print("")
	print("--- 11. Every offer reading is an independent copy, and the record a choice answers is the caller's — rewriting either moves nothing")
	var runtime: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_fill(runtime, run, field, 4, Vector3(0.0, 0.0, 700.0))
	_expect_accepted(runtime.open_level_up_offer(_profiles(), _definitions(), _cards()), "the copy check's opening")
	var offer_before: String = _offer(runtime)

	var lanes: Array[int] = runtime.offer_lanes()
	lanes.append(7)
	lanes[0] = RiftOffer.Lane.UTILITY
	var lanes_again: Array[int] = runtime.offer_lanes()
	_expect(lanes_again == RiftOffer.LANE_ORDER and not is_same(lanes, lanes_again) and lanes != lanes_again,
		"a rewritten lane reading (%s) reached the offer: it now reads %s" % [str(lanes), str(lanes_again)])

	var support_identity: PackedStringArray = runtime.offer_identity_for(RiftOffer.Lane.SUPPORT)
	var written: String = ", ".join(support_identity)
	var rewritten: PackedStringArray = runtime.offer_identity_for(RiftOffer.Lane.SUPPORT)
	rewritten.append("invented_support")
	rewritten.set(0, "invented_skill")
	_expect(", ".join(runtime.offer_identity_for(RiftOffer.Lane.SUPPORT)) == written
			and ", ".join(rewritten) != written and _offer(runtime) == offer_before,
		"a rewritten identity reading reached the offer: it now reads %s" % _offer(runtime))

	var outcome: RiftRunLevelUpResult = runtime.choose_level_up_lane(RiftOffer.Lane.SUPPORT)
	_successes += 1
	_expect(outcome.succeeded() and ", ".join(outcome.level_up().granted_identity()) == written,
		"the choice granted [%s], not the offer's own [%s]" % [", ".join(outcome.level_up().granted_identity()), written])
	var recorded: String = _record(outcome)
	var copy: RiftLevelUpResult = outcome.level_up()
	copy.ok = false
	copy.lane = 7
	copy.support_rank_after = 9
	var copied_identity: PackedStringArray = outcome.level_up().granted_identity()
	copied_identity.append("invented")
	_expect(_record(outcome) == recorded and not is_same(copy, outcome.level_up()),
		"rewriting a copy of the receipt changed the record to %s" % _record(outcome))

	var runtime_after: String = _state(runtime)
	outcome.run_seed = 0
	outcome.source_level = 42
	var next: RiftRunLevelUpResult = runtime.choose_level_up_lane(RiftOffer.Lane.SUPPORT)
	_note_refused(next, 2, runtime.level(), "the copy check's repeated choice")
	_expect(_state(runtime) == runtime_after and runtime.run_seed() == OWNER_SEED and runtime.level() == 2
			and not is_same(next, outcome) and next.run_seed == OWNER_SEED and next.source_level == 2,
		"rewriting the returned record moved the runtime to %s, or the next record was %s" % [_state(runtime), _record(next)])

	var fields: PackedStringArray = _script_fields(runtime)
	_expect(fields == PackedStringArray(RUNTIME_FIELDS),
		"after opening and choosing, the runtime holds %s" % ", ".join(fields))
	print("  a lane reading rewritten to %s left the offer reading %s; an identity reading rewritten to [%s] left it [%s]"
		% [str(lanes), str(lanes_again), ", ".join(rewritten), written])
	print("  the choice granted the offer's own [%s]; a copy of its receipt rewritten and the record's own run seed and level rewritten moved nothing; the next record is a new one (run seed %d, level %d); the runtime still holds %s"
		% [written, next.run_seed, next.source_level, ", ".join(fields)])
	_done("every_offer_reading_and_every_record_is_an_independent_copy")


# --- 12. Refused records ------------------------------------------------------------------------------------------

func _check_refused_records() -> void:
	print("")
	print("--- 12. Every refused record handed back invents no identity, no support operation and no advancement")
	var clean: int = 0
	for row: Array in _refused_records:
		var record: RiftRunLevelUpResult = row[0] as RiftRunLevelUpResult
		var receipt: RiftLevelUpResult = record.level_up()
		var held: bool = (record != null and not record.succeeded() and not record.failure_reason().is_empty()
			and receipt != null and not receipt.ok and receipt.granted_identity().is_empty()
			and receipt.identity_line() == "nothing granted" and not receipt.carries_support_progression()
			and receipt.support_progression_kind == RiftOffer.UNRESOLVED_PROGRESSION_KIND
			and receipt.support_rank_before == RiftOfferChoiceResult.NO_RANK
			and receipt.support_rank_after == RiftOfferChoiceResult.NO_RANK
			and record.problem().is_empty() and record.source_level == int(row[1]) and int(row[2]) == int(row[1]))
		_expect(held, "%s: %s — the level stood at %d and then %d" % [String(row[3]), _record(record), int(row[1]), int(row[2])])
		if held:
			clean += 1
	_expect(_refused_records.size() == EXPECTED_REFUSED_RECORDS,
		"%d refused records reached the tally, not %d" % [_refused_records.size(), EXPECTED_REFUSED_RECORDS])
	print("  %d of %d refused records granted nothing, carried no support operation, were coherent, and left their runtime at the level they were asked at"
		% [clean, _refused_records.size()])
	_done("every_refused_record_invents_no_identity_and_no_advancement")


# --- 13. The shape -------------------------------------------------------------------------------------------------

func _check_the_shape() -> void:
	print("")
	print("--- 13. The runtime still holds exactly three fields; each new operation is one line handing its question to G4's own method; it names no catalogue and restates nothing")
	var raw: String = FileAccess.get_file_as_string(RUNTIME_FILE)
	var code: String = _code_only(raw)
	var bare: String = RegEx.create_from_string("\"([^\"\\\\]|\\\\.)*\"").sub(code, "\"\"", true)
	_expect(raw.length() > 3000, "the runtime reads as %d characters" % raw.length())

	var probe: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var fields: PackedStringArray = _script_fields(probe)
	var script: GDScript = load(RUNTIME_FILE) as GDScript
	_expect(fields == PackedStringArray(RUNTIME_FIELDS) and script.get_script_constant_map().is_empty()
			and script.get_script_signal_list().is_empty(),
		"the runtime holds %s, or declares constants or signals" % ", ".join(fields))

	## EACH DELEGATION IS ITS ONE LINE, AND G4 OWNS A METHOD OF THAT NAME.
	var g4_methods: PackedStringArray = PackedStringArray()
	for entry: Dictionary in (load("res://scripts/levels/rift_run_level_coordinator.gd") as GDScript).get_script_method_list():
		g4_methods.append(String(entry.get("name", "")))
	var delegating: int = 0
	var mapping: PackedStringArray = PackedStringArray()
	for row: Array in DELEGATIONS:
		var body: PackedStringArray = _body_after_declaration(code, "func %s(" % String(row[0]))
		var owner: String = String(row[2])
		if body == PackedStringArray([String(row[1])]) and g4_methods.has(owner):
			delegating += 1
		mapping.append("%s -> G4 %s" % [String(row[0]), owner])
	_expect(delegating == DELEGATIONS.size(), "%d of %d new operations are one line handing their question to G4" % [
		delegating, DELEGATIONS.size()])

	## ONLY THE CHOICE ANSWERS AN OBJECT AMONG THEM, AND NO OTHER MEMBER HANDS ONE OUT.
	var object_answers: PackedStringArray = PackedStringArray()
	var names: PackedStringArray = PackedStringArray()
	for entry: Dictionary in script.get_script_method_list():
		var method: String = String(entry.get("name", ""))
		names.append(method)
		if int((entry.get("return", {}) as Dictionary).get("type", 0)) == TYPE_OBJECT:
			object_answers.append(method)
	var present: int = 0
	for method: String in I1_METHODS:
		if names.has(method):
			present += 1
	## Roguelite I3 (decision D-295) added exactly one member after I1's six: the
	## one-line build reading, which answers the run's own copied build. The same single
	## assertion is made, with that one member counted and named. Roguelite I10 (decision
	## D-312) added exactly two more, its readings of the standing offer's Support content
	## kind and passive-fallback category; each answers an int, so the object answers do
	## not move, and the same assertion counts 25.
	_expect(present == I1_METHODS.size() and names.size() == 25
			and object_answers == PackedStringArray(["_init", "sweep_at", "choose_level_up_lane", "run_build"]),
		"the runtime declares %d methods (%d of the six), and these answer an object: %s" % [
			names.size(), present, ", ".join(object_answers)])

	## NOTHING RESTATED, NOTHING COPIED, NO CATALOGUE AND NO CONCRETE ID. D2's build is
	## the one bypass token Roguelite I3 (D-295) grants, and only as the two exact lines
	## of its one-line reading: they alone are lifted out before the scan, so a second
	## mention of the build anywhere in the code still fails exactly as any did before.
	var i3_build_reading: PackedStringArray = PackedStringArray([
		"func run_build() -> RiftRunBuild:", "return _run.run_build()",
	])
	var scanned_lines: PackedStringArray = PackedStringArray()
	for line: String in bare.split("\n"):
		if not i3_build_reading.has(line.strip_edges()):
			scanned_lines.append(line)
	var scanned_code: String = "\n".join(scanned_lines)
	var restated: PackedStringArray = PackedStringArray()
	for token: String in BYPASS_TOKENS:
		if scanned_code.contains(token):
			restated.append(token)
	var ids: PackedStringArray = PackedStringArray()
	for profile: SkillTagProfile in SkillSupportCatalogue.skill_profiles():
		ids.append(String(profile.skill_id))
	for definition: SupportDefinition in SkillSupportCatalogue.support_definitions():
		ids.append(String(definition.support_id()))
	for record: PassiveCardDefinition in PassiveCardCatalogue.records():
		ids.append(String(record.card_id))
	for id: String in ids:
		if raw.contains(id):
			restated.append("id %s" % id)
	_expect(restated.is_empty() and ids.size() == 9, "the runtime names %s (of %d ids read from the catalogues)" % [
		", ".join(restated), ids.size()])
	print("  %d fields (%s); %s; each one line; only _init, sweep_at, choose_level_up_lane and Roguelite I3's run_build answer an object"
		% [fields.size(), ", ".join(fields), "; ".join(mapping)])
	print("  0 of %d owner-bypassing tokens in its code; 0 of %d catalogue ids anywhere in the file; no catalogue named"
		% [BYPASS_TOKENS.size(), ids.size()])
	_done("the_runtime_holds_three_fields_and_only_delegates")


# --- 14. Nothing calls it --------------------------------------------------------------------------------------------

func _check_nothing_calls_it() -> void:
	print("")
	print("--- 14. Nothing that runs calls Foundation I1 but the one granted review: the runtime's one running reader names none of its operations")
	var readers: PackedStringArray = PackedStringArray()
	var callers: PackedStringArray = PackedStringArray()
	var scanned: int = 0
	for root_path: String in SCANNED_ROOTS:
		for path: String in _files_under(root_path, [".gd", ".tscn", ".tres"]):
			if path == RUNTIME_FILE:
				continue
			scanned += 1
			var text: String = FileAccess.get_file_as_string(path)
			if text.contains(RUNTIME_CLASS):
				readers.append(path)
			## D-293: the one granted file is read separately below, for exactly its grant.
			if path == LEVEL_UP_REVIEW_FILE:
				continue
			for method: String in ["open_level_up_offer", "frozen_offer_requirement", "choose_level_up_lane"]:
				if text.contains(method):
					callers.append("%s names %s" % [path.get_file(), method])
	## The operations sharing a name with G4's own are reachable only through a runtime,
	## so every file that names the runtime is read for all six.
	for path: String in readers:
		var text: String = FileAccess.get_file_as_string(path)
		for method: String in I1_METHODS:
			if text.contains(method + "("):
				callers.append("%s calls %s" % [path.get_file(), method])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for method: String in I1_METHODS:
		if settings.contains(method):
			callers.append("project.godot names %s" % method)
	## The granted file calls exactly the operations it is granted, and no other.
	var granted_calls: PackedStringArray = PackedStringArray()
	var granted_source: String = FileAccess.get_file_as_string(LEVEL_UP_REVIEW_FILE)
	for method: String in I1_METHODS:
		if granted_source.contains(method + "("):
			granted_calls.append(method)
	_expect(readers == PackedStringArray([REVIEW_FILE]) and callers.is_empty() and scanned > 100
			and not settings.contains("[autoload]") and granted_calls == PackedStringArray(LEVEL_UP_REVIEW_CALLS),
		"the runtime is read by %s; the new operations are named by %s; the granted review calls %s (%d files scanned)" % [
			", ".join(readers), ", ".join(callers), ", ".join(granted_calls), scanned])
	var review: String = FileAccess.get_file_as_string(REVIEW_FILE)
	_expect(review.contains("is_offer_active()") and review.contains("LEVEL-UP READY"),
		"the review no longer reads the offer flag or shows LEVEL-UP READY, so its silence proves nothing")
	print("  %d project files scanned; the runtime's only running reader is %s, which names none of the six and still reads is_offer_active() and shows LEVEL-UP READY; the one file granted its operations, %s, calls exactly %s; project.godot names none"
		% [scanned, REVIEW_FILE.get_file(), LEVEL_UP_REVIEW_FILE.get_file(), ", ".join(granted_calls)])
	_done("nothing_that_runs_calls_the_new_operations")


# --- 15. Frames -----------------------------------------------------------------------------------------------------

## The one check that lets frames pass. It runs LAST among the behavioural checks.
func _check_frames() -> void:
	print("")
	print("--- 15. A runtime at its requirement opens nothing, pauses nothing and adds nothing while process and physics frames pass; only the explicit ask opens")
	var runtime: RiftMoteRuntime = RiftMoteRuntime.new(OWNER_SEED)
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var field: RiftMoteField = RiftMoteField.new(OWNER_SEED)
	_fill(runtime, run, field, 4, Vector3(0.0, 0.0, 800.0))
	var before: String = _state(runtime)
	var children: int = root.get_child_count()
	var stage_children: int = _stage.get_child_count()
	var process_before: int = Engine.get_process_frames()
	var physics_before: int = Engine.get_physics_frames()
	for _frame: int in 3:
		await process_frame
	for _frame: int in 3:
		await physics_frame
	var processed: int = Engine.get_process_frames() - process_before
	var stepped: int = Engine.get_physics_frames() - physics_before
	_expect(processed >= 3 and stepped >= 3 and _state(runtime) == before and not runtime.is_offer_active()
			and runtime.level() == 1 and runtime.experience() == 100.0 and not paused
			and root.get_child_count() == children and _stage.get_child_count() == stage_children,
		"after %d process and %d physics frames the runtime moved from %s to %s, or the tree changed" % [
			processed, stepped, before, _state(runtime)])
	var opened: String = runtime.open_level_up_offer(_profiles(), _definitions(), _cards())
	_successes += 1
	_expect(opened.is_empty() and runtime.is_offer_active() and runtime.level() == 1 and not paused,
		"the explicit ask answered '%s'" % opened)
	print("  %s held while frames passed — no offer, not paused, no node added; then the explicit ask opened it ('%s') and it still did not pause (%d process and %d physics frames)"
		% [before.get_slice(" |", 0), opened, processed, stepped])
	print("  %d refusals were asserted, %d lane or opening successes driven, %d Graveblade deaths driven and %d sweeps made across this suite"
		% [_refusals, _successes, _deaths_driven, _sweeps])
	_done("no_offer_opens_and_nothing_pauses_while_frames_pass")


# --- The accepted catalogues, through their existing public accessors --------------------------

func _profiles() -> Array[SkillTagProfile]:
	return SkillSupportCatalogue.skill_profiles()


func _definitions() -> Array[SupportDefinition]:
	return SkillSupportCatalogue.support_definitions()


func _cards() -> Array[PassiveCardDefinition]:
	return PassiveCardCatalogue.records()


# --- Fixtures ----------------------------------------------------------------------------------

## One production Graveblade, placed at `at` before it enters the tree.
func _graveblade(at: Vector3) -> PrototypeGraveblade:
	_serial += 1
	var enemy: PrototypeGraveblade = (load(GRAVEBLADE_SCENE) as PackedScene).instantiate() as PrototypeGraveblade
	enemy.name = "I1Graveblade%d" % _serial
	enemy.position = at
	_stage.add_child(enemy)
	return enemy


## Registers one live Graveblade with `runtime` for `amount`, kills it through its own
## public `receive_damage()`, and gives the TWIN field the same drop where it fell.
## Returns where it fell.
func _drop(runtime: RiftMoteRuntime, twin_field: RiftMoteField, amount: float, at: Vector3) -> Vector3:
	var enemy: PrototypeGraveblade = _graveblade(at)
	_expect_accepted(runtime.register_graveblade(enemy, amount), "a registration for %s" % _exact(amount))
	for _attempt: int in 20:
		if not enemy.is_alive():
			break
		_use += 1
		enemy.receive_damage(DamageEvent.physical(_use, enemy, enemy, HIT))
	_deaths_driven += 1
	_expect(not enemy.is_alive() and runtime.has_observed_death(enemy) and runtime.emission_answer(enemy).is_empty(),
		"a Graveblade registered for %s did not die into a drop" % _exact(amount))
	var fell: Vector3 = enemy.global_position
	_expect_accepted(twin_field.spawn_drop(fell, amount), "the twin's drop for %s" % _exact(amount))
	return fell


## One explicit sweep of the runtime at `at`, and the same sweep of the twin field into
## the twin run; the two answers must be the same answer.
func _sweep_both(runtime: RiftMoteRuntime, twin_run: RiftRunLevelCoordinator, twin_field: RiftMoteField, at: Vector3) -> RiftMoteSweepResult:
	var result: RiftMoteSweepResult = runtime.sweep_at(at)
	var twin_result: RiftMoteSweepResult = twin_field.sweep_collection(at, twin_run)
	_sweeps += 1
	_expect(_sweep(result) == _sweep(twin_result) and runtime.experience() == twin_run.experience(),
		"a sweep at %s answered %s where the twin answered %s" % [str(at), _sweep(result), _sweep(twin_result)])
	return result


## `count` motes of 25.0, each dropped by its own Graveblade 12 m apart along +X from
## `origin` and collected by its own sweep, in the runtime and its twin alike.
func _fill(runtime: RiftMoteRuntime, twin_run: RiftRunLevelCoordinator, twin_field: RiftMoteField, count: int, origin: Vector3) -> void:
	for index: int in count:
		var fell: Vector3 = _drop(runtime, twin_field, TEST_MOTE, origin + Vector3(12.0 * index, 0.0, 0.0))
		var result: RiftMoteSweepResult = _sweep_both(runtime, twin_run, twin_field, fell)
		_expect(result.collected_indices() == PackedInt32Array([index]),
			"mote %d was not collected by its own sweep: %s" % [index, _sweep(result)])


# --- Readings ------------------------------------------------------------------------------------

## The lanes every offer reading is asked for: D1's three and two undeclared ones.
func _probed_lanes() -> Array[int]:
	var lanes: Array[int] = RiftOffer.LANE_ORDER.duplicate()
	lanes.append(7)
	lanes.append(-1)
	return lanes


## Every offer reading of the runtime, as one line.
func _offer(runtime: RiftMoteRuntime) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for lane: int in _probed_lanes():
		parts.append("%d:[%s]" % [lane, ", ".join(runtime.offer_identity_for(lane))])
	return "active=%s root=%d frozen=%s lanes=%s %s" % [
		str(runtime.is_offer_active()), runtime.offer_root_seed(), _exact(runtime.frozen_offer_requirement()),
		str(runtime.offer_lanes()), " ".join(parts)]


## The same readings asked of a directly driven G4 run, in the same shape.
func _twin_offer(run: RiftRunLevelCoordinator) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for lane: int in _probed_lanes():
		parts.append("%d:[%s]" % [lane, ", ".join(run.offer_identity_for(lane))])
	return "active=%s root=%d frozen=%s lanes=%s %s" % [
		str(run.is_offer_active()), run.offer_root_seed(), _exact(run.frozen_requirement()),
		str(run.offer_lanes()), " ".join(parts)]


## The run's own readings through the runtime, and every offer reading.
func _run_state(runtime: RiftMoteRuntime) -> String:
	return "seed=%d level=%d experience=%s | %s" % [
		runtime.run_seed(), runtime.level(), _exact(runtime.experience()), _offer(runtime)]


func _twin_state(run: RiftRunLevelCoordinator) -> String:
	return "seed=%d level=%d experience=%s | %s" % [
		run.run_seed(), run.level(), _exact(run.experience()), _twin_offer(run)]


## Everything the runtime answers, as one line.
func _state(runtime: RiftMoteRuntime) -> String:
	return "seed=%d level=%d experience=%s bindings=%d drops=%d collected=%d uncollected=%d problem='%s' | %s" % [
		runtime.run_seed(), runtime.level(), _exact(runtime.experience()), runtime.binding_count(),
		runtime.drop_count(), runtime.collected_count(), runtime.uncollected_count(), runtime.problem(),
		_offer(runtime)]


## Every field of a run-level record and the copy of the receipt it carries, as one line.
func _record(record: RiftRunLevelUpResult) -> String:
	if record == null:
		return "no record"
	var receipt: RiftLevelUpResult = record.level_up()
	if receipt == null:
		return "run_seed=%d source=%d no receipt" % [record.run_seed, record.source_level]
	return "run_seed=%d source=%d succeeded=%s reason='%s' | ok=%s known=%s root=%d lane=%d identity=[%s] kind=%d ranks=%d->%d | problem='%s'" % [
		record.run_seed, record.source_level, str(record.succeeded()), record.failure_reason(),
		str(receipt.ok), str(receipt.root_seed_known), receipt.root_seed, receipt.lane,
		", ".join(receipt.granted_identity()), receipt.support_progression_kind, receipt.support_rank_before,
		receipt.support_rank_after, record.problem()]


func _sweep(result: RiftMoteSweepResult) -> String:
	return "ok=%s reason='%s' total=%d skipped=%d attempted=%d collected=%s out=%d refused=%d first='%s' problem='%s'" % [
		str(result.ok), result.failure_reason, result.total_count, result.skipped_count, result.attempted_count,
		result.collected_indices(), result.out_of_range_count, result.item_refusal_count, result.first_item_refusal_reason,
		result.problem(),
	]


## The script variables an instance holds, read through its property list.
func _script_fields(instance: Object) -> PackedStringArray:
	var names: PackedStringArray = PackedStringArray()
	for entry: Dictionary in instance.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			names.append(String(entry.get("name", "")))
	return names


func _note_refused(record: RiftRunLevelUpResult, level_before: int, level_after: int, where: String) -> void:
	_refusals += 1
	_refused_records.append([record, level_before, level_after, where])


func _exact(value: float) -> String:
	if is_nan(value) or is_inf(value) or absf(value) >= 1.0e17 or (value != 0.0 and absf(value) < 1.0e-6):
		return String.num_scientific(value)
	return String.num(value, 17)


# --- Source reading ------------------------------------------------------------------------------

func _code_only(source: String) -> String:
	var out: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


## The stripped statement lines of one method AFTER its declaration — which may span
## several lines, ending at the first line ending in ":" — up to the next declaration.
func _body_after_declaration(code: String, declaration: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var start: int = code.find(declaration)
	if start < 0:
		return out
	var end: int = code.length()
	for marker: String in ["\nfunc ", "\nstatic func ", "\nclass "]:
		var next: int = code.find(marker, start + 1)
		if next >= 0 and next < end:
			end = next
	var in_body: bool = false
	for line: String in code.substr(start, end - start).split("\n"):
		var stripped: String = line.strip_edges()
		if stripped.is_empty():
			continue
		if in_body:
			out.append(stripped)
		elif stripped.ends_with(":"):
			in_body = true
	return out


func _files_under(root_path: String, extensions: Array[String]) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var dir: DirAccess = DirAccess.open(root_path)
	if dir == null:
		return out
	dir.list_dir_begin()
	var entry: String = dir.get_next()
	while not entry.is_empty():
		if entry != "." and entry != "..":
			var full: String = root_path.path_join(entry)
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


# --- The owed set and the assertions ------------------------------------------------------------------

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


func _expect_accepted(refusal: String, described: String) -> void:
	_expect(refusal.is_empty(), "%s was refused: %s" % [described, refusal])


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _done(check_name: String) -> void:
	_reached[check_name] = true
