extends SceneTree
## Riftwrought — Roguelite Foundation H4 verification: run-owned Experience Mote
## drop state.
##
## ONE FOCUSED HEADLESS TEST. Foundation H4 is one pure-logic script under
## `scripts/pickups/` — an in-memory drop binding one exact signed run seed, one
## fixed world position and one privately owned Experience Mote, which may be
## collected only into the run whose seed owns it. It runs as a `SceneTree` script
## exactly as every earlier foundation suite does.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching its
## LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## THE HARNESS NEVER PERFORMS THE ATTEMPT IT CHECKS, AND WRITES NO PRIVATE STATE.
## Every drop collection below was made by the drop under test. The only awards
## the harness makes itself go through the run's own public award path, to reach
## an active offer and a Magnetism build the way a real run reaches them — and the
## Magnetism card is OFFERED and CHOSEN, never injected. The one private read — the
## run's current lifecycle, by name — only shows that a refusal left the run where
## it was; nothing is written, into the run or into a drop.
##
## EVERY EXPECTED ANSWER IS EITHER A TYPED LITERAL OR THE ACCEPTED MECHANISM'S OWN
## ANSWER, asked directly with the same inputs — the pickup-range query's reading,
## the collection attempt's result on a control mote, or the mote's own problem.
## Never a distance, radius or seed comparison this file computed for the drop.
##
## THE VALUE 25 IS TEST EVIDENCE ONLY. It is not an enemy-experience value.
##
## IT READS NO OTHER SUITE. It names no file under `tests/` but its own, which the
## runner asserts.

# --- The files ----------------------------------------------------------------------

const DROP_FILE: String = "res://scripts/pickups/rift_mote_drop.gd"
const THIS_FILE: String = "res://tests/rift_experience_mote_drop_verification.gd"

## D-278: named so that it neither contains nor is contained in any other project
## class name — in particular not the mote's, so a file naming only the drop can
## never match a scan for the mote's class.
const DROP_CLASS: String = "RiftMoteDrop"

## `scripts/pickups/` after H4: H2's two scripts, H3's two and H4's one — and since
## D-279 Foundation H5's field and its sweep result. A directory pin only: the drop
## file is the only own-file exemption below, and sharing the directory exempts
## nothing.
const PICKUP_SCRIPTS: Array[String] = [
	"res://scripts/pickups/rift_mote_collection_attempt.gd",
	"res://scripts/pickups/rift_mote_collection_result.gd",
	"res://scripts/pickups/rift_mote_drop.gd",
	"res://scripts/pickups/rift_mote_field.gd",
	"res://scripts/pickups/rift_mote_pickup_query.gd",
	"res://scripts/pickups/rift_mote_pickup_reading.gd",
	"res://scripts/pickups/rift_mote_sweep_result.gd",
]

## THE ONLY FILES OUTSIDE H4 THAT MAY NAME THE DROP OR ASK ONE TO COLLECT, PER FILE
## AND PER TOKEN. D-279: Foundation H5's field makes its drops, keeps them, and asks
## each uncollected one to attempt its own collection; it is granted the drop's
## class and the collection call — and never the drop's file name. Nothing that
## runs creates a field. This replaces the blanket "no other file" one for one: the
## same single assertion is made either way, and the pinned count does not move.
const AUTHORIZED_READERS: Array = [
	["res://scripts/pickups/rift_mote_field.gd", ["RiftMoteDrop", "attempt_collection("]],
]

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]
const PROJECT_SETTINGS_FILE: String = "res://project.godot"

## THE ONLY PROJECT CLASSES THE DROP MAY NAME, checked against the engine's own
## global class list in both directions: itself, the mote it makes and holds (H1),
## the attempt it delegates to and the result it answers with (H3), and the run it
## is offered (G4). Not the pickup-range query or reading, not the stat totals, not
## the build, not the run-level record, not the curve or the seed derivation.
const DROP_NAMES: Array[String] = [
	"RiftExperienceMote", "RiftMoteCollectionAttempt", "RiftMoteCollectionResult",
	"RiftMoteDrop", "RiftRunLevelCoordinator",
]

## Every method, in declaration order, with its full signature. The engine reports
## a constructor's return as an object, whatever the source declares.
const EXPECTED_SIGNATURES: Array[String] = [
	"_init(for_run_seed: int, for_position: Vector3, for_base_experience: float) -> Object",
	"run_seed() -> int",
	"position() -> Vector3",
	"base_experience() -> float",
	"is_collected() -> bool",
	"problem() -> String",
	"attempt_collection(player_position: Vector3, run: Object) -> Object",
	"describe() -> String",
]

## THE DROP'S WHOLE STATE: THREE PRIVATE FIELDS AND NO FOURTH, each declared bare.
const EXPECTED_FIELDS: Array[String] = ["_run_seed", "_position", "_mote"]
const EXPECTED_DECLARATIONS: Array[String] = [
	"var _run_seed: int",
	"var _position: Vector3",
	"var _mote: RiftExperienceMote",
]

## Every code line that touches the private mote, exactly: the declaration, the
## one construction, the three delegated readings, the defensive existence check,
## and the one hand-over to the attempt. No line returns the mote itself.
const MOTE_LINES: Array[String] = [
	"var _mote: RiftExperienceMote",
	"_mote = RiftExperienceMote.new(for_base_experience)",
	"return _mote.base_experience()",
	"return _mote.is_collected()",
	"if _mote == null:",
	"return _mote.problem()",
	"return RiftMoteCollectionAttempt.attempt(player_position, _position, _mote, run)",
]

## THE CONSTRUCTOR, THE VALIDITY RULE AND THE COLLECTION ORDER, AS THE CODE MUST
## SPELL THEM, first occurrence to first occurrence inside each method, each once.
const CONSTRUCTOR_ORDER: Array[String] = [
	"_run_seed = for_run_seed",
	"_position = for_position",
	"_mote = RiftExperienceMote.new(for_base_experience)",
]
const PROBLEM_ORDER: Array[String] = [
	"if not _position.is_finite():",
	"if _mote == null:",
	"return _mote.problem()",
]
const COLLECTION_ORDER: Array[String] = [
	"var invalid: String = problem()",
	"if not invalid.is_empty():",
	"return RiftMoteCollectionResult.refused(invalid)",
	"if run == null:",
	"if run.run_seed() != _run_seed:",
	"return RiftMoteCollectionAttempt.attempt(player_position, _position, _mote, run)",
]

## Every gate, each of which must return on its very next line.
const RETURNING_GATES: Array[String] = [
	"if not _position.is_finite():", "if _mote == null:",
	"if not invalid.is_empty():", "if run == null:", "if run.run_seed() != _run_seed:",
]

## Content, formula constants, other mechanisms' members and the mote's guarded
## tokens. Scanned RAW over the drop, comments included — D-215's lesson.
const FORBIDDEN_TOKENS: Array[String] = [
	"card_", "Magnetism", "magnetism", "quick_strike", "reaching_edge", "sweeping_edge",
	"Graveblade", "PICKUP_RADIUS", "EXPERIENCE_GAIN", "BASE_PICKUP_RADIUS",
	"RiftMotePickupQuery", "RiftMotePickupReading", "PlayerStat", "RiftRunBuild",
	"RiftRunLevelUpResult", "RiftLevelRequirement", "RiftLevelOfferSeed", "requirement_for",
	"offer_root_seed", "open_current_offer", "award_experience", "next_level_coordinator",
	"collect_into", "rift_experience_mote", ".tscn", "scenes/",
]

## A pure record reads no ambient state and asks no physics, collision,
## navigation or scene question. Scanned raw.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
	"preload(", "load(", "get_tree", "get_node", "Node3D", "Area3D", "CollisionShape",
	"PhysicsServer", "NavigationServer", "NavigationAgent", "distance_to",
	"distance_squared_to", "length(", "global_position", "Transform3D",
]

## What the drop must not do, as tokens over CODE lines only: no distance or
## radius formula, no coordinate read, no stat or build question, no offer step, no
## collection, no scan, no copy, no setter, no signal, no node.
const RESTATEMENT_TOKENS: Array[String] = [
	"sqrt(", "abs(", "pow(", "min(", "max(", "clamp", "value_of", "total_for", ".x", ".y", ".z",
	"stat_totals", "run_build", "choose(", "open_", "evaluate(", "Array", "Dictionary",
	"duplicate", "set(", "setget", "signal", "emit", "connect(", "Node", "Area", "Shape",
	"Skill", "enemy", "Enemy", "free(",
]

## Member names that would mean a drop can be reset, copied, moved, re-owned,
## spawned, pooled or stored — none may name a method.
const DEFERRED_MEMBER_TOKENS: Array[String] = [
	"reset", "duplicate", "clone", "copy", "move", "set_", "transfer", "owner", "assign",
	"teleport", "attract", "velocity", "spawn", "pool", "save", "load", "register", "reseed",
	"rebind", "free", "tick", "process",
]

# --- The fixtures, stated independently -----------------------------------------------

## Test evidence only.
const TEST_MOTE: float = 25.0
const STORED_BASES: Array[float] = [25.0, 0.1, 7.5]
const FIRST_REQUIREMENT: float = 100.0

## An ordinary owning run and one run that does not own the drop.
const OWNER_SEED: int = 99
const STRANGER_SEED: int = 100

## The greybox base and the +25% radius, typed here rather than read from H2.
const BASE_RADIUS: float = 2.5
const MAGNETISM_RADIUS: float = 3.125
const MAGNETISM_TOTAL: float = 0.25

## Run seed 0 offers the shipped Pickup Radius card in its Level 1 Utility lane —
## measured under D-275 and asserted below rather than assumed.
const MAGNETISM_SEED: int = 0
const MAGNETISM_CARD: StringName = &"card_magnetism"

## 2^32: agrees with 0 in every one of its low 32 bits.
const TWO_TO_THE_32: int = 4294967296

## SIX SIGNED SEEDS IN TWO FAMILIES THAT AGREE IN THEIR LOW 32 BITS, each with its
## exact decimal spelling typed here. The first three all read 0 in their low 32
## bits; the last three all read 4,294,967,295.
const SEED_FAMILIES: Array = [
	[0, "0"],
	[4294967296, "4294967296"],
	[-9223372036854775808, "-9223372036854775808"],
	[-1, "-1"],
	[4294967295, "4294967295"],
	[9223372036854775807, "9223372036854775807"],
]
const LOW_32_MASK: int = 0xFFFFFFFF

## The spacing of this engine's world-position components between 2 m and 4 m:
## 2^-22 m.
const SPACING_2_TO_4: float = 1.0 / 4194304.0

const ORIGIN: Vector3 = Vector3.ZERO

## A player away from the origin and off the ground, and two drop positions
## measured from them on the ground plane: 1.5 m along z, and 3.0 m along x.
const PLAYER: Vector3 = Vector3(10.0, 0.5, -6.0)
const NEAR_DROP: Vector3 = Vector3(10.0, 0.5, -4.5)
const THREE_METRE_DROP: Vector3 = Vector3(13.0, 0.5, -6.0)
const NEAR_DISTANCE: float = 1.5
const THREE_METRES: float = 3.0

## The accepted wordings this suite quotes, typed independently.
const OFFER_OPEN_REFUSAL: String = "an offer is open; it must be resolved before further experience is recorded"
const COLLECTED_REFUSAL: String = "this Experience Mote has already been collected; no pickup range is measured for it"
const NO_RUN_REFUSAL: String = "an Experience Mote drop must be collected into a run, and none was given"

const UNUSABLE_BASES: Array = [
	["zero", 0.0], ["negative", -25.0], ["not a number", NAN],
	["positive infinity", INF], ["negative infinity", -INF],
]

const OWED_CHECKS: Array[String] = [
	"a_valid_drop_stores_its_exact_seed_position_and_base",
	"the_owning_run_collects_an_in_range_drop_exactly_once",
	"the_owning_run_answers_out_of_range_exactly_as_h3_does",
	"a_wrong_run_refuses_before_any_measurement_and_moves_nothing",
	"seeds_agreeing_in_their_low_32_bits_are_distinct_owners",
	"every_signed_seed_keeps_exact_ownership",
	"an_invalid_position_refuses_before_delegation",
	"an_invalid_base_stays_invalid_and_uncollectable",
	"an_active_offer_refuses_and_the_same_drop_collects_after_the_choice",
	"magnetism_moves_the_boundary_through_the_drop_without_the_drop_naming_it",
	"the_position_is_a_value_and_never_moves",
	"no_reading_hands_out_the_mote",
	"the_drop_holds_three_fields_and_no_reset_copy_move_or_transfer",
	"the_drop_restates_nothing_and_names_only_what_it_composes",
	"nothing_that_runs_creates_a_drop_and_the_directory_holds_seven_scripts",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0
var _out_of_range: int = 0
var _collections: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation H4 — Run-Owned Experience Mote Drop State (D-277) ===")

	_check_valid_construction()
	_check_the_owning_run_collects_once()
	_check_the_owning_run_out_of_range()
	_check_a_wrong_run()
	_check_low_32_bit_owners()
	_check_every_signed_seed()
	_check_an_invalid_position()
	_check_an_invalid_base()
	_check_an_active_offer()
	_check_magnetism()
	_check_the_position_never_moves()
	_check_no_reading_hands_out_the_mote()
	_check_the_fields_and_members()
	_check_the_shape()
	_check_nothing_runs_it()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT EXPERIENCE MOTE DROP VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT EXPERIENCE MOTE DROP VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. Valid construction ---------------------------------------------------------------------

func _check_valid_construction() -> void:
	print("")
	print("--- 1. A valid drop stores its exact signed run seed, its position and its base experience")
	var shown: PackedStringArray = PackedStringArray()
	var stored: int = 0
	for row: Array in SEED_FAMILIES:
		for base: float in STORED_BASES:
			var owned_seed: int = int(row[0])
			var drop: RiftMoteDrop = RiftMoteDrop.new(owned_seed, NEAR_DROP, base)
			_expect(drop.run_seed() == owned_seed and str(drop.run_seed()) == String(row[1]),
				"a drop made with run seed %s reads %d" % [String(row[1]), drop.run_seed()])
			_expect(drop.position() == NEAR_DROP, "a drop made at %s reads %s" % [NEAR_DROP, drop.position()])
			_expect(drop.base_experience() == base, "a drop of %s reads %s" % [_exact(base), _exact(drop.base_experience())])
			_expect(not drop.is_collected() and drop.problem().is_empty(),
				"a fresh drop reads %s (%s)" % [_drop(drop), drop.problem()])
			stored += 1
	for base: float in STORED_BASES:
		shown.append(_exact(base))
	## An off-origin position with no exact binary form reads back exactly as the
	## same position the caller built.
	var awkward: Vector3 = Vector3(0.1, -0.2, 1024.3)
	var off: RiftMoteDrop = RiftMoteDrop.new(OWNER_SEED, awkward, TEST_MOTE)
	_expect(off.position() == awkward and off.position() == Vector3(0.1, -0.2, 1024.3),
		"a drop made at %s reads %s" % [awkward, off.position()])
	print("  %d drops over %d signed seeds and the bases %s: each reads back its exact seed, position and base, uncollected and valid"
		% [stored, SEED_FAMILIES.size(), ", ".join(shown)])
	_done("a_valid_drop_stores_its_exact_seed_position_and_base")


# --- 2. The owning run, in range ---------------------------------------------------------------

func _check_the_owning_run_collects_once() -> void:
	print("")
	print("--- 2. The owning run collects an in-range drop exactly once, and H3's answer is returned unchanged")
	var shown: PackedStringArray = PackedStringArray()
	for base: float in STORED_BASES:
		var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
		var drop: RiftMoteDrop = RiftMoteDrop.new(OWNER_SEED, NEAR_DROP, base)
		## H3's own answer to the same question, on a control mote in an identical run.
		var control: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(
			PLAYER, NEAR_DROP, RiftExperienceMote.new(base), RiftRunLevelCoordinator.new(OWNER_SEED))
		var result: RiftMoteCollectionResult = drop.attempt_collection(PLAYER, run)
		_expect_collected(result, "the in-range drop of %s" % _exact(base))
		_expect(_whole(result) == _whole(control),
			"the drop answered %s where H3 answers %s" % [_whole(result), _whole(control)])
		_expect(result.planar_distance == NEAR_DISTANCE and result.effective_radius == BASE_RADIUS,
			"the drop of %s reads %s" % [_exact(base), result.describe()])
		_expect(drop.is_collected() and drop.base_experience() == base,
			"after collection the drop reads %s" % _drop(drop))
		_expect(run.experience() == base and run.level() == 1 and not run.is_offer_active(),
			"the drop of %s left the run at %s" % [_exact(base), _snapshot(run)])
		shown.append(_exact(base))

	## A SECOND ATTEMPT CANNOT PAY TWICE: refused by the accepted path, word for word.
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var drop: RiftMoteDrop = RiftMoteDrop.new(OWNER_SEED, NEAR_DROP, TEST_MOTE)
	_expect_collected(drop.attempt_collection(PLAYER, run), "the drop")
	var run_before: String = _snapshot(run)
	var drop_before: String = _drop(drop)
	var lifecycle: int = _lifecycle_of(run).get_instance_id()
	var control_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var control_mote: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	_expect_collected(RiftMoteCollectionAttempt.attempt(PLAYER, NEAR_DROP, control_mote, control_run), "the control mote")
	var control_retry: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(PLAYER, NEAR_DROP, control_mote, control_run)
	var retries: PackedStringArray = PackedStringArray()
	for attempt: int in 2:
		var retry: RiftMoteCollectionResult = drop.attempt_collection(PLAYER, run)
		_expect_refused(retry, "the collected drop, retry %d" % (attempt + 1))
		_expect(retry.failure_reason == COLLECTED_REFUSAL and _whole(retry) == _whole(control_retry),
			"the retry answered '%s' where H3 answers '%s'" % [retry.failure_reason, control_retry.failure_reason])
		retries.append(retry.failure_reason)
	_expect(_snapshot(run) == run_before and _drop(drop) == drop_before
			and _lifecycle_of(run).get_instance_id() == lifecycle and run.experience() == TEST_MOTE,
		"a refused retry moved something: %s | %s" % [_snapshot(run), _drop(drop)])
	print("  %s: each collected once by its owning run at %s m within %s m, equal to H3's own answer; each award exactly its base"
		% [", ".join(shown), _exact(NEAR_DISTANCE), _exact(BASE_RADIUS)])
	print("  a second and third attempt refused through H3 ('%s'), equal to H3's own answer; %s paid once; the run and the drop unmoved"
		% [retries[0], _exact(run.experience())])
	_done("the_owning_run_collects_an_in_range_drop_exactly_once")


# --- 3. The owning run, out of range -----------------------------------------------------------

func _check_the_owning_run_out_of_range() -> void:
	print("")
	print("--- 3. The owning run answers a 3.0 m drop OUT_OF_RANGE, exactly as H3 does, and nothing moves")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var drop: RiftMoteDrop = RiftMoteDrop.new(OWNER_SEED, THREE_METRE_DROP, TEST_MOTE)
	var control: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(
		PLAYER, THREE_METRE_DROP, RiftExperienceMote.new(TEST_MOTE), RiftRunLevelCoordinator.new(OWNER_SEED))
	var run_before: String = _snapshot(run)
	var lifecycle: int = _lifecycle_of(run).get_instance_id()
	var first: RiftMoteCollectionResult = drop.attempt_collection(PLAYER, run)
	_expect_out_of_range(first, "the 3.0 m drop")
	_expect(_whole(first) == _whole(control), "the drop answered %s where H3 answers %s" % [_whole(first), _whole(control)])
	_expect(first.planar_distance == THREE_METRES and first.effective_radius == BASE_RADIUS,
		"the 3.0 m drop reads %s" % first.describe())
	var drifted: int = 0
	for _index: int in 100:
		if _whole(drop.attempt_collection(PLAYER, run)) != _whole(first):
			drifted += 1
	_expect(drifted == 0, "%d of 100 identical attempts were answered differently" % drifted)
	_expect(not drop.is_collected() and _snapshot(run) == run_before and run.experience() == 0.0
			and _lifecycle_of(run).get_instance_id() == lifecycle and drop.position() == THREE_METRE_DROP,
		"an out-of-range answer moved something: %s | %s" % [_snapshot(run), _drop(drop)])
	## The drop does not move to the player: the player moves to the drop.
	var closer: RiftMoteCollectionResult = drop.attempt_collection(THREE_METRE_DROP + Vector3(0.0, 0.0, NEAR_DISTANCE), run)
	_expect_collected(closer, "the same drop with the player 1.5 m from it")
	_expect(run.experience() == TEST_MOTE and drop.position() == THREE_METRE_DROP,
		"the drop then delivered %s and reads %s" % [_exact(run.experience()), drop.position()])
	print("  out of range at %s m against %s m, equal to H3's own answer; %d of 100 repeats disagree; the drop and the run unmoved; with the player beside it the same drop paid %s once"
		% [_exact(first.planar_distance), _exact(first.effective_radius), drifted, _exact(run.experience())])
	_done("the_owning_run_answers_out_of_range_exactly_as_h3_does")


# --- 4. A wrong run -----------------------------------------------------------------------------

func _check_a_wrong_run() -> void:
	print("")
	print("--- 4. A run that does not own the drop is refused before any measurement, and nothing moves")
	var owner: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var stranger: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(STRANGER_SEED)
	var drop: RiftMoteDrop = RiftMoteDrop.new(OWNER_SEED, NEAR_DROP, TEST_MOTE)
	var expected: String = _ownership_sentence("99", "100")
	var owner_before: String = _snapshot(owner)
	var stranger_before: String = _snapshot(stranger)
	var drop_before: String = _drop(drop)
	var lifecycle: int = _lifecycle_of(stranger).get_instance_id()

	## IN RANGE, THE WRONG RUN IS REFUSED BY THE DROP, NAMING BOTH SEEDS.
	var refused: RiftMoteCollectionResult = drop.attempt_collection(PLAYER, stranger)
	_expect_refused(refused, "the in-range drop offered to run seed 100")
	_expect(refused.failure_reason == expected, "the wrong run answered: %s" % refused.failure_reason)

	## NO RANGE QUERY WAS ASKED: at a player position that is not a number at all the
	## answer is the same — the pickup query would have refused that position first.
	var garbage: Vector3 = Vector3(NAN, INF, -INF)
	var unmeasured: RiftMoteCollectionResult = drop.attempt_collection(garbage, stranger)
	_expect_refused(unmeasured, "the drop offered to run seed 100 from a non-finite player position")
	_expect(unmeasured.failure_reason == expected, "at non-finite positions the wrong run answered '%s'" % unmeasured.failure_reason)
	var h3_garbage: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(
		garbage, NEAR_DROP, RiftExperienceMote.new(TEST_MOTE), RiftRunLevelCoordinator.new(OWNER_SEED))
	_expect(h3_garbage.is_refused() and h3_garbage.failure_reason != expected,
		"H3 answers non-finite positions '%s', so this proves nothing" % h3_garbage.failure_reason)

	## THE MOTE WAS NOT ASKED: a wrong run holding an open offer would refuse the
	## mote with its own sentence, and the drop answers ownership instead.
	var busy: RiftRunLevelCoordinator = _run_with_an_open_offer(STRANGER_SEED)
	var busy_before: String = _snapshot(busy)
	var busy_answer: RiftMoteCollectionResult = drop.attempt_collection(PLAYER, busy)
	_expect_refused(busy_answer, "the drop offered to run seed 100 while its offer stands")
	_expect(busy_answer.failure_reason == expected and busy_answer.failure_reason != OFFER_OPEN_REFUSAL,
		"the busy wrong run answered '%s'" % busy_answer.failure_reason)
	_expect(_snapshot(busy) == busy_before and busy.is_offer_active(), "the busy wrong run moved: %s" % _snapshot(busy))

	_expect(_snapshot(stranger) == stranger_before and stranger.experience() == 0.0
			and _lifecycle_of(stranger).get_instance_id() == lifecycle,
		"the wrong run moved: %s" % _snapshot(stranger))
	_expect(_snapshot(owner) == owner_before and _drop(drop) == drop_before and not drop.is_collected(),
		"the owning run or the drop moved: %s | %s" % [_snapshot(owner), _drop(drop)])

	## AFTER THE REFUSALS, THE OWNING RUN STILL COLLECTS THE SAME DROP, ONCE.
	_expect_collected(drop.attempt_collection(PLAYER, owner), "the same drop into its owning run")
	_expect(owner.experience() == TEST_MOTE and stranger.experience() == 0.0,
		"the owning run holds %s and the wrong run %s" % [_exact(owner.experience()), _exact(stranger.experience())])

	## A COLLECTED DROP OFFERED TO THE WRONG RUN IS STILL REFUSED FOR OWNERSHIP —
	## H3 would have answered that the mote is collected, so H3 was not asked.
	var late: RiftMoteCollectionResult = drop.attempt_collection(PLAYER, stranger)
	_expect_refused(late, "the collected drop offered to run seed 100")
	_expect(late.failure_reason == expected and late.failure_reason != COLLECTED_REFUSAL,
		"the collected drop in the wrong run answered '%s'" % late.failure_reason)
	_expect(_snapshot(stranger) == stranger_before, "the wrong run moved after the collection: %s" % _snapshot(stranger))
	var owned_answers: int = 0
	for answer: RiftMoteCollectionResult in [refused, unmeasured, busy_answer, late]:
		if answer.failure_reason == expected and is_inf(answer.planar_distance) and answer.effective_radius == 0.0:
			owned_answers += 1
	_expect(owned_answers == 4, "%d of 4 wrong-run answers carried the ownership refusal and nothing measured" % owned_answers)
	print("  run seed 100 refused ('%s')" % refused.failure_reason)
	print("  %d of 4 wrong-run attempts answered exactly that with distance %s and radius %s — in range, at %s, against an open offer, and after collection — where H3 answers '%s', the offer '%s' and the collected mote '%s'; the owning run then collected %s once"
		% [owned_answers, _exact(late.planar_distance), _exact(late.effective_radius), garbage, h3_garbage.failure_reason,
			OFFER_OPEN_REFUSAL, COLLECTED_REFUSAL, _exact(owner.experience())])
	_done("a_wrong_run_refuses_before_any_measurement_and_moves_nothing")


# --- 5. Low 32 bits ------------------------------------------------------------------------------

func _check_low_32_bit_owners() -> void:
	print("")
	print("--- 5. Run seeds 0 and 4,294,967,296 agree in their low 32 bits and are still two owners")
	_expect(TWO_TO_THE_32 & LOW_32_MASK == 0 and MAGNETISM_SEED & LOW_32_MASK == 0 and TWO_TO_THE_32 != 0,
		"0 and 2^32 do not agree in their low 32 bits: %d / %d" % [0 & LOW_32_MASK, TWO_TO_THE_32 & LOW_32_MASK])
	var zero_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(0)
	var wide_run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(TWO_TO_THE_32)
	var zero_drop: RiftMoteDrop = RiftMoteDrop.new(0, NEAR_DROP, TEST_MOTE)
	var wide_drop: RiftMoteDrop = RiftMoteDrop.new(TWO_TO_THE_32, NEAR_DROP, TEST_MOTE)

	var crossed_a: RiftMoteCollectionResult = zero_drop.attempt_collection(PLAYER, wide_run)
	_expect_refused(crossed_a, "the seed-0 drop offered to run seed 4294967296")
	_expect(crossed_a.failure_reason == _ownership_sentence("0", "4294967296"),
		"the seed-0 drop answered: %s" % crossed_a.failure_reason)
	var crossed_b: RiftMoteCollectionResult = wide_drop.attempt_collection(PLAYER, zero_run)
	_expect_refused(crossed_b, "the seed-4294967296 drop offered to run seed 0")
	_expect(crossed_b.failure_reason == _ownership_sentence("4294967296", "0"),
		"the seed-4294967296 drop answered: %s" % crossed_b.failure_reason)
	var crossed: int = int(crossed_a.is_refused()) + int(crossed_b.is_refused())
	_expect(zero_run.experience() == 0.0 and wide_run.experience() == 0.0
			and not zero_drop.is_collected() and not wide_drop.is_collected(),
		"a crossed attempt moved something: %s | %s" % [_snapshot(zero_run), _snapshot(wide_run)])

	_expect_collected(zero_drop.attempt_collection(PLAYER, zero_run), "the seed-0 drop into run seed 0")
	_expect_collected(wide_drop.attempt_collection(PLAYER, wide_run), "the seed-4294967296 drop into its own run")
	_expect(zero_run.experience() == TEST_MOTE and wide_run.experience() == TEST_MOTE,
		"the two owners hold %s and %s" % [_exact(zero_run.experience()), _exact(wide_run.experience())])
	print("  both seeds read %d in their low 32 bits; %d of 2 crossed attempts refused ('%s' / '%s'); each run then collected %s and %s from its own drop"
		% [TWO_TO_THE_32 & LOW_32_MASK, crossed, crossed_a.failure_reason, crossed_b.failure_reason,
			_exact(zero_run.experience()), _exact(wide_run.experience())])
	_done("seeds_agreeing_in_their_low_32_bits_are_distinct_owners")


# --- 6. Every signed seed ------------------------------------------------------------------------

func _check_every_signed_seed() -> void:
	print("")
	print("--- 6. Negative, minimum and maximum signed seeds keep exact ownership, pair by pair")
	## The two families really do collide in their low 32 bits.
	var low: PackedStringArray = PackedStringArray()
	for row: Array in SEED_FAMILIES:
		low.append(str(int(row[0]) & LOW_32_MASK))
	_expect(", ".join(low) == "0, 0, 0, 4294967295, 4294967295, 4294967295",
		"the six seeds' low 32 bits read %s" % ", ".join(low))

	var collected: int = 0
	var refused: int = 0
	var colliding_refused: int = 0
	var misfits: PackedStringArray = PackedStringArray()
	for drop_row: Array in SEED_FAMILIES:
		for run_row: Array in SEED_FAMILIES:
			var drop_seed: int = int(drop_row[0])
			var run_seed: int = int(run_row[0])
			var drop: RiftMoteDrop = RiftMoteDrop.new(drop_seed, NEAR_DROP, TEST_MOTE)
			var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(run_seed)
			var result: RiftMoteCollectionResult = drop.attempt_collection(PLAYER, run)
			if String(drop_row[1]) == String(run_row[1]):
				_expect_collected(result, "the drop of run seed %s into its own run" % String(drop_row[1]))
				if result.is_collected() and run.experience() == TEST_MOTE and drop.is_collected():
					collected += 1
				else:
					misfits.append("%s -> %s" % [String(drop_row[1]), String(run_row[1])])
			else:
				_expect_refused(result, "the drop of run seed %s into run seed %s" % [String(drop_row[1]), String(run_row[1])])
				var sentence: String = _ownership_sentence(String(drop_row[1]), String(run_row[1]))
				if result.failure_reason == sentence and run.experience() == 0.0 and not drop.is_collected():
					refused += 1
					if drop_seed & LOW_32_MASK == run_seed & LOW_32_MASK:
						colliding_refused += 1
				else:
					misfits.append("%s -> %s: %s" % [String(drop_row[1]), String(run_row[1]), result.failure_reason])
			_expect(drop.run_seed() == drop_seed and run.run_seed() == run_seed,
				"a seed moved: drop %d, run %d" % [drop.run_seed(), run.run_seed()])
	_expect(misfits.is_empty(), "these pairs misbehaved: %s" % ", ".join(misfits))
	_expect(collected == 6 and refused == 30 and colliding_refused == 12,
		"%d owners collected, %d strangers refused, %d of them colliding in the low 32 bits" % [
			collected, refused, colliding_refused])
	var spelled: PackedStringArray = PackedStringArray()
	for row: Array in SEED_FAMILIES:
		spelled.append(String(row[1]))
	print("  seeds %s: %d of %d drop-run pairs collected (each drop by its own run); %d refused naming both seeds in full, %d of them seeds that agree in their low 32 bits"
		% [", ".join(spelled), collected, SEED_FAMILIES.size() * SEED_FAMILIES.size(), refused, colliding_refused])
	_done("every_signed_seed_keeps_exact_ownership")


# --- 7. An invalid position -------------------------------------------------------------------------

func _check_an_invalid_position() -> void:
	print("")
	print("--- 7. A drop whose stored position is not finite refuses before anything is delegated")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var stranger: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(STRANGER_SEED)
	var untouched: String = _snapshot(run)
	var cases: int = 0
	var own: int = 0
	for component: int in 3:
		for bad: float in [NAN, INF, -INF]:
			var place: Vector3 = NEAR_DROP
			place[component] = bad
			var drop: RiftMoteDrop = RiftMoteDrop.new(OWNER_SEED, place, TEST_MOTE)
			var problem: String = drop.problem()
			_expect(problem.contains("position must have a finite x, y and z"),
				"the drop at %s reads its problem as '%s'" % [place, problem])
			## H3, asked the same question directly, would have answered with H2's reason.
			var h3: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(
				PLAYER, place, RiftExperienceMote.new(TEST_MOTE), RiftRunLevelCoordinator.new(OWNER_SEED))
			var answers: Array[RiftMoteCollectionResult] = [
				drop.attempt_collection(PLAYER, run),
				drop.attempt_collection(PLAYER, null),
				drop.attempt_collection(PLAYER, stranger),
			]
			var all_own: bool = true
			for answer: RiftMoteCollectionResult in answers:
				_expect_refused(answer, "the drop at %s" % place)
				if answer.failure_reason != problem:
					all_own = false
			_expect(all_own, "the drop at %s did not answer its own problem first" % place)
			_expect(h3.is_refused() and h3.failure_reason != problem,
				"H3 answers the drop at %s with '%s', so this proves nothing" % [place, h3.failure_reason])
			_expect(not drop.is_collected() and drop.base_experience() == TEST_MOTE,
				"the drop at %s reads %s" % [place, _drop(drop)])
			if all_own:
				own += 1
			cases += 1
	_expect(_snapshot(run) == untouched and stranger.experience() == 0.0,
		"an invalid drop moved a run: %s" % _snapshot(run))
	## A valid drop offered no run answers the missing run, before any seed is compared.
	var valid: RiftMoteDrop = RiftMoteDrop.new(OWNER_SEED, NEAR_DROP, TEST_MOTE)
	var no_run: RiftMoteCollectionResult = valid.attempt_collection(PLAYER, null)
	_expect_refused(no_run, "a valid drop with no run")
	_expect(no_run.failure_reason == NO_RUN_REFUSAL and not valid.is_collected(),
		"a valid drop with no run answered: %s" % no_run.failure_reason)
	print("  %d non-finite components (NaN, +inf, -inf in x, y and z): %d refused with the drop's own problem, before a missing run and before ownership, never H3's; the run unmoved"
		% [cases, own])
	print("  order: an invalid drop before a missing run ('%s') before ownership before delegation; H3 would have answered the drop at %s with '%s'"
		% [no_run.failure_reason, Vector3(NAN, 0.5, -4.5), RiftMoteCollectionAttempt.attempt(PLAYER, Vector3(NAN, 0.5, -4.5),
			RiftExperienceMote.new(TEST_MOTE), RiftRunLevelCoordinator.new(OWNER_SEED)).failure_reason])
	_done("an_invalid_position_refuses_before_delegation")


# --- 8. An invalid base --------------------------------------------------------------------------------

func _check_an_invalid_base() -> void:
	print("")
	print("--- 8. A drop whose base experience is not a valid mote amount stays invalid and uncollectable")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var untouched: String = _snapshot(run)
	var named: PackedStringArray = PackedStringArray()
	var echoed: int = 0
	for row: Array in UNUSABLE_BASES:
		var base: float = float(row[1])
		var drop: RiftMoteDrop = RiftMoteDrop.new(OWNER_SEED, NEAR_DROP, base)
		var mote_problem: String = RiftExperienceMote.new(base).problem()
		_expect(not mote_problem.is_empty() and drop.problem() == mote_problem,
			"the %s drop's problem is '%s', where the mote's own is '%s'" % [String(row[0]), drop.problem(), mote_problem])
		for attempt: int in 2:
			var answer: RiftMoteCollectionResult = drop.attempt_collection(PLAYER, run)
			_expect_refused(answer, "the %s drop, attempt %d" % [String(row[0]), attempt + 1])
			_expect(answer.failure_reason == mote_problem, "the %s drop answered '%s'" % [String(row[0]), answer.failure_reason])
			if answer.failure_reason == mote_problem and drop.problem() == mote_problem:
				echoed += 1
		_expect(not drop.is_collected(), "the %s drop was collected" % String(row[0]))
		var read: float = drop.base_experience()
		_expect((is_nan(base) and is_nan(read)) or read == base,
			"the %s drop reads its base as %s" % [String(row[0]), _exact(read)])
		named.append(String(row[0]))
	_expect(_snapshot(run) == untouched, "an invalid drop moved the run: %s" % _snapshot(run))
	## The position is asked before the amount.
	var both: RiftMoteDrop = RiftMoteDrop.new(OWNER_SEED, Vector3(NAN, 0.0, 0.0), 0.0)
	_expect(both.problem().contains("position"), "a drop wrong in both answers '%s'" % both.problem())
	_expect(echoed == 2 * UNUSABLE_BASES.size(), "%d of %d refusals echoed the mote's own problem" % [echoed, 2 * UNUSABLE_BASES.size()])
	print("  %s: %d of %d refusals quoted the mote's own problem word for word, never collected; the run unmoved; a drop wrong in both answers '%s'"
		% [", ".join(named), echoed, 2 * UNUSABLE_BASES.size(), both.problem()])
	_done("an_invalid_base_stays_invalid_and_uncollectable")


# --- 9. An active offer ----------------------------------------------------------------------------------

func _check_an_active_offer() -> void:
	print("")
	print("--- 9. While its owning run holds an offer the drop is refused with G4's own reason, and collects after the choice")
	var run: RiftRunLevelCoordinator = _run_with_an_open_offer(MAGNETISM_SEED)
	var control: RiftRunLevelCoordinator = _run_with_an_open_offer(MAGNETISM_SEED)
	var standing: String = _snapshot(run)
	var lifecycle: int = _lifecycle_of(run).get_instance_id()

	var far: RiftMoteDrop = RiftMoteDrop.new(MAGNETISM_SEED, THREE_METRE_DROP, TEST_MOTE)
	var far_answer: RiftMoteCollectionResult = far.attempt_collection(PLAYER, run)
	_expect_out_of_range(far_answer, "a 3.0 m drop while the offer stands")

	var near: RiftMoteDrop = RiftMoteDrop.new(MAGNETISM_SEED, NEAR_DROP, TEST_MOTE)
	var direct: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(
		PLAYER, NEAR_DROP, RiftExperienceMote.new(TEST_MOTE), control)
	var refusals: PackedStringArray = PackedStringArray()
	for attempt: int in 2:
		var answer: RiftMoteCollectionResult = near.attempt_collection(PLAYER, run)
		_expect_refused(answer, "the in-range drop while the offer stands, attempt %d" % (attempt + 1))
		_expect(answer.failure_reason == OFFER_OPEN_REFUSAL and _whole(answer) == _whole(direct),
			"the drop answered '%s' where H3 answers '%s'" % [answer.failure_reason, direct.failure_reason])
		refusals.append(answer.failure_reason)
	_expect(not near.is_collected() and not far.is_collected() and _snapshot(run) == standing
			and _lifecycle_of(run).get_instance_id() == lifecycle and run.is_offer_active(),
		"a refused attempt moved something: %s | %s" % [_snapshot(run), _drop(near)])

	## RESOLVED, THE SAME DROP AT THE SAME POSITION PAYS ONCE.
	var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect(outcome.succeeded() and run.level() == 2 and run.experience() == 0.0 and not run.is_offer_active(),
		"resolving the offer left %s (%s)" % [_snapshot(run), outcome.failure_reason()])
	var paid: RiftMoteCollectionResult = near.attempt_collection(PLAYER, run)
	_expect_collected(paid, "the same drop after the choice")
	_expect(run.experience() == TEST_MOTE and near.is_collected() and near.position() == NEAR_DROP,
		"the retry delivered %s and left %s" % [_exact(run.experience()), _drop(near)])
	_expect_refused(near.attempt_collection(PLAYER, run), "the same drop once more")
	_expect(run.experience() == TEST_MOTE, "a repeat delivered %s" % _exact(run.experience()))
	print("  while the offer stood: the 3.0 m drop out of range at %s m; the in-range drop refused twice ('%s'), equal to H3's own answer, uncollected; after the choice the same drop paid %s once"
		% [_exact(far_answer.planar_distance), refusals[0], _exact(run.experience())])
	_done("an_active_offer_refuses_and_the_same_drop_collects_after_the_choice")


# --- 10. Magnetism ----------------------------------------------------------------------------------------

func _check_magnetism() -> void:
	print("")
	print("--- 10. Magnetism, offered and chosen through the owning run, moves the 3.0 m boundary through the drop")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(MAGNETISM_SEED)
	var drop: RiftMoteDrop = RiftMoteDrop.new(MAGNETISM_SEED, THREE_METRE_DROP, TEST_MOTE)
	var baseline: RiftMoteCollectionResult = drop.attempt_collection(PLAYER, run)
	_expect_out_of_range(baseline, "the 3.0 m drop on the fresh run")
	_expect(baseline.planar_distance == THREE_METRES and baseline.effective_radius == BASE_RADIUS,
		"the baseline drop reads %s" % baseline.describe())

	## THE ACCEPTED RUN PATH: an explicit award, an explicit open, an explicit
	## choice of the lane that OFFERS the card. Nothing is injected.
	_expect_accepted(run.award_experience(FIRST_REQUIREMENT), "the award that reaches level 1's requirement")
	_expect_accepted(_open(run), "the level 1 offer")
	var offered: PackedStringArray = run.offer_identity_for(RiftOffer.Lane.UTILITY)
	_expect(offered == PackedStringArray([String(MAGNETISM_CARD)]),
		"run seed %d's level 1 Utility lane offers %s, not %s" % [MAGNETISM_SEED, str(offered), MAGNETISM_CARD])
	var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.UTILITY)
	_expect(outcome.succeeded() and run.level() == 2 and run.experience() == 0.0,
		"the Utility choice left %s (%s)" % [_snapshot(run), outcome.failure_reason()])
	var build: RiftRunBuild = run.run_build()
	_expect(build.acquired_card_ids().size() == 1 and build.acquired_card_ids()[0] == MAGNETISM_CARD,
		"the build holds the cards %s" % str(build.acquired_card_ids()))
	_expect(build.total_for(PlayerStats.PICKUP_RADIUS) == MAGNETISM_TOTAL,
		"the build's Pickup Radius total is %s" % _exact(build.total_for(PlayerStats.PICKUP_RADIUS)))

	## A drop of another run, in the Magnetism range, is still not this run's.
	var foreign: RiftMoteDrop = RiftMoteDrop.new(TWO_TO_THE_32, THREE_METRE_DROP, TEST_MOTE)
	var foreign_answer: RiftMoteCollectionResult = foreign.attempt_collection(PLAYER, run)
	_expect_refused(foreign_answer, "a 3.0 m drop of run seed 4294967296 on the Magnetism run")
	_expect(foreign_answer.failure_reason == _ownership_sentence("4294967296", "0") and run.experience() == 0.0,
		"the foreign drop answered '%s'" % foreign_answer.failure_reason)

	## THE SAME DROP, UNMOVED, IS NOW COLLECTED AT H2's OWN 3.125 m.
	var expected: RiftMotePickupReading = RiftMotePickupQuery.evaluate(PLAYER, THREE_METRE_DROP, run.run_build().stat_totals())
	var collected: RiftMoteCollectionResult = drop.attempt_collection(PLAYER, run)
	_expect_collected(collected, "the same 3.0 m drop on the Magnetism build")
	_expect(collected.planar_distance == THREE_METRES and collected.effective_radius == MAGNETISM_RADIUS
			and collected.effective_radius == expected.effective_radius
			and collected.planar_distance == expected.planar_distance,
		"the Magnetism attempt reads %s, where H2 reads %s" % [collected.describe(), expected.describe()])
	_expect(run.experience() == TEST_MOTE and drop.position() == THREE_METRE_DROP,
		"the Magnetism build turned a drop of %s into %s, and the drop reads %s" % [
			_exact(TEST_MOTE), _exact(run.experience()), drop.position()])
	_expect(baseline.is_out_of_range() and baseline.effective_radius == BASE_RADIUS,
		"the answer given before the card now reads %s" % baseline.describe())

	## The boundary moves with the radius: exactly 3.125 m in, one spacing beyond out.
	var on_boundary: RiftMoteCollectionResult = RiftMoteDrop.new(
		MAGNETISM_SEED, Vector3(MAGNETISM_RADIUS, 0.0, 0.0), TEST_MOTE).attempt_collection(ORIGIN, run)
	_expect_collected(on_boundary, "a drop exactly on the 3.125 m boundary")
	var beyond: RiftMoteCollectionResult = RiftMoteDrop.new(
		MAGNETISM_SEED, Vector3(MAGNETISM_RADIUS + SPACING_2_TO_4, 0.0, 0.0), TEST_MOTE).attempt_collection(ORIGIN, run)
	_expect_out_of_range(beyond, "a drop one spacing beyond 3.125 m")
	print("  run seed %d, level 1 Utility lane: %s chosen; Pickup Radius total %s"
		% [MAGNETISM_SEED, MAGNETISM_CARD, _exact(build.total_for(PlayerStats.PICKUP_RADIUS))])
	print("  the same drop at %s m: out of range at %s m before the card, collected at %s m after it, equal to H2's own reading; the award stayed exactly %s"
		% [_exact(collected.planar_distance), _exact(baseline.effective_radius), _exact(collected.effective_radius),
			_exact(TEST_MOTE)])
	print("  the %s m boundary collected; %s m out of range; a drop of run seed 4294967296 in that range refused for ownership"
		% [_exact(on_boundary.planar_distance), _exact(beyond.planar_distance)])
	_done("magnetism_moves_the_boundary_through_the_drop_without_the_drop_naming_it")


# --- 11. The position ----------------------------------------------------------------------------------------

func _check_the_position_never_moves() -> void:
	print("")
	print("--- 11. Reading the position hands out a value; nothing moves the stored position or the seed")
	var drop: RiftMoteDrop = RiftMoteDrop.new(OWNER_SEED, THREE_METRE_DROP, TEST_MOTE)
	var read: Vector3 = drop.position()
	read.x = 1000.0
	read += Vector3(1.0, 1.0, 1.0)
	read = Vector3.ZERO
	_expect(drop.position() == THREE_METRE_DROP, "changing a reading moved the drop to %s" % drop.position())

	## Every kind of answer leaves the position and the seed exactly where they were.
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var stranger: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(STRANGER_SEED)
	var answers: PackedStringArray = PackedStringArray()
	for pair: Array in [[PLAYER, stranger], [PLAYER, null], [PLAYER, run], [Vector3(NAN, 0.0, 0.0), run],
			[THREE_METRE_DROP, run], [THREE_METRE_DROP, run]]:
		var answer: RiftMoteCollectionResult = drop.attempt_collection(pair[0], pair[1])
		answers.append(answer.describe().get_slice(":", 0).get_slice(" —", 0))
		_expect(drop.position() == THREE_METRE_DROP and drop.run_seed() == OWNER_SEED,
			"an attempt moved the drop to %s, seed %d" % [drop.position(), drop.run_seed()])
	_expect(drop.is_collected() and run.experience() == TEST_MOTE, "the drop reads %s" % _drop(drop))
	print("  a reading changed three ways left the drop at %s; after answers [%s] it still lies at %s with run seed %d"
		% [THREE_METRE_DROP, ", ".join(answers), drop.position(), drop.run_seed()])
	_done("the_position_is_a_value_and_never_moves")


# --- 12. The mote stays inside ------------------------------------------------------------------------------------

func _check_no_reading_hands_out_the_mote() -> void:
	print("")
	print("--- 12. No reading hands out the private mote, and two equal drops hold two motes")
	var drop: RiftMoteDrop = RiftMoteDrop.new(OWNER_SEED, NEAR_DROP, TEST_MOTE)
	var script: GDScript = load(DROP_FILE) as GDScript
	var readings: int = 0
	var objects: PackedStringArray = PackedStringArray()
	for entry: Dictionary in script.get_script_method_list():
		var name: String = String(entry.get("name", ""))
		if name == "_init" or not (entry.get("args", []) as Array).is_empty():
			continue
		var value: Variant = drop.call(name)
		readings += 1
		if typeof(value) == TYPE_OBJECT:
			objects.append(name)
	_expect(readings == 6 and objects.is_empty(), "%d readings; these answer an object: %s" % [readings, ", ".join(objects)])
	## The one method that answers an object answers H3's result — a value holding no
	## object reference — and never the mote.
	var answered: Variant = drop.call("attempt_collection", PLAYER, RiftRunLevelCoordinator.new(OWNER_SEED))
	_expect(answered is RiftMoteCollectionResult and not (answered is RiftExperienceMote),
		"attempt_collection answered %s" % str(answered))
	if answered is RiftMoteCollectionResult:
		_expect_collected(answered as RiftMoteCollectionResult, "the drop's one object-answering method")
	var references: int = 0
	for entry: Dictionary in (answered as Object).get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0 and int(entry.get("type", 0)) == TYPE_OBJECT:
			references += 1
	_expect(references == 0, "the answer holds %d object references" % references)

	## Two drops of the same value at the same place pay independently: each made its
	## own mote.
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(OWNER_SEED)
	var first: RiftMoteDrop = RiftMoteDrop.new(OWNER_SEED, NEAR_DROP, TEST_MOTE)
	var second: RiftMoteDrop = RiftMoteDrop.new(OWNER_SEED, NEAR_DROP, TEST_MOTE)
	_expect_collected(first.attempt_collection(PLAYER, run), "the first of two equal drops")
	_expect(first.is_collected() and not second.is_collected(),
		"collecting one drop collected the other: %s / %s" % [_drop(first), _drop(second)])
	_expect_collected(second.attempt_collection(PLAYER, run), "the second, equal drop")
	_expect(run.experience() == TEST_MOTE + TEST_MOTE, "two equal drops delivered %s" % _exact(run.experience()))
	print("  %d argument-free readings answer %d objects; the collection attempt answers H3's result with %d object references; 2 equal drops delivered %s, each once"
		% [readings, objects.size(), references, _exact(run.experience())])
	_done("no_reading_hands_out_the_mote")


# --- 13. Fields and members --------------------------------------------------------------------------------------

func _check_the_fields_and_members() -> void:
	print("")
	print("--- 13. Three private fields, eight methods, no default, and no reset, copy, move or transfer")
	var drop: RiftMoteDrop = RiftMoteDrop.new(OWNER_SEED, NEAR_DROP, TEST_MOTE)
	var fields: PackedStringArray = _fields_of(drop)
	_expect(", ".join(fields) == ", ".join(PackedStringArray(EXPECTED_FIELDS)), "the drop carries: %s" % ", ".join(fields))
	var types: PackedStringArray = PackedStringArray()
	for entry: Dictionary in drop.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			types.append("%s:%s%s" % [String(entry.get("name", "")), _type_name(int(entry.get("type", 0))),
				"" if String(entry.get("class_name", "")).is_empty() else "<%s>" % String(entry.get("class_name", ""))])
	_expect(", ".join(types) == "_run_seed:int, _position:Vector3, _mote:Object<RiftExperienceMote>",
		"the drop's fields are typed %s" % ", ".join(types))

	var script: GDScript = load(DROP_FILE) as GDScript
	var signatures: PackedStringArray = _signatures_of(DROP_FILE)
	_expect(", ".join(signatures) == ", ".join(PackedStringArray(EXPECTED_SIGNATURES)),
		"the drop declares: %s" % ", ".join(signatures))
	var defaults: PackedStringArray = PackedStringArray()
	var deferred: PackedStringArray = PackedStringArray()
	for entry: Dictionary in script.get_script_method_list():
		var name: String = String(entry.get("name", ""))
		if not (entry.get("default_args", []) as Array).is_empty():
			defaults.append(name)
		for token: String in DEFERRED_MEMBER_TOKENS:
			if name.contains(token):
				deferred.append(name)
	_expect(defaults.is_empty(), "these methods default an argument: %s" % ", ".join(defaults))
	_expect(deferred.is_empty(), "these methods reset, copy, move, re-own or store: %s" % ", ".join(deferred))
	_expect(script.get_script_constant_map().is_empty(), "the drop declares constants: %s" % str(script.get_script_constant_map()))
	_expect(script.get_script_signal_list().is_empty(), "the drop declares signals")

	var raw: String = FileAccess.get_file_as_string(DROP_FILE)
	var code: String = _code_only(raw)
	var missing: PackedStringArray = PackedStringArray()
	for declaration: String in EXPECTED_DECLARATIONS:
		if not (code.split("\n") as PackedStringArray).has(declaration):
			missing.append(declaration)
	var top_level: PackedStringArray = PackedStringArray()
	for line: String in code.split("\n"):
		for opener: String in ["var ", "static ", "const ", "@", "signal ", "enum ", "class "]:
			if line.begins_with(opener) and not EXPECTED_DECLARATIONS.has(line):
				top_level.append(line)
	_expect(missing.is_empty() and top_level.is_empty(),
		"the fields are not declared bare [%s], or the drop declares [%s]" % [", ".join(missing), " | ".join(top_level)])
	## Neither the language nor a setter moves a field: no `set` block, no setter
	## method, and the constructor is the only place any field is written.
	var writes: PackedStringArray = PackedStringArray()
	for line: String in code.split("\n"):
		var stripped: String = line.strip_edges()
		for field: String in EXPECTED_FIELDS:
			if stripped.begins_with(field + " =") or stripped.begins_with(field + "="):
				writes.append(stripped)
	_expect(", ".join(writes) == ", ".join(PackedStringArray(CONSTRUCTOR_ORDER)),
		"the fields are written by: %s" % " | ".join(writes))
	_expect(RiftMoteDrop.new(-1, Vector3(1.0, 2.0, 3.0), TEST_MOTE).run_seed() == -1,
		"a drop built with seed -1 does not read -1")
	print("  %d fields (%s), each declared bare and written only by the constructor; %d methods pinned, none defaulting an argument; 0 reset, copy, move, transfer, setter or signal members"
		% [fields.size(), ", ".join(types), signatures.size()])
	_done("the_drop_holds_three_fields_and_no_reset_copy_move_or_transfer")


# --- 14. The shape ------------------------------------------------------------------------------------------------

func _check_the_shape() -> void:
	print("")
	print("--- 14. The drop restates nothing, and names only what it composes")
	var raw: String = FileAccess.get_file_as_string(DROP_FILE)
	var code: String = _code_only(raw)
	_expect(raw.length() > 2000 and code.length() > 500 and code.length() < raw.length(),
		"the drop read as %d / %d characters" % [raw.length(), code.length()])

	## THE ORDERS, EACH STEP ONCE, EACH GATE RETURNING ON ITS NEXT LINE.
	var ordered: PackedStringArray = PackedStringArray()
	for row: Array in [["func _init(", CONSTRUCTOR_ORDER], ["func problem(", PROBLEM_ORDER],
			["func attempt_collection(", COLLECTION_ORDER]]:
		var body: PackedStringArray = _method_code(code, String(row[0]))
		var previous: int = -1
		for step: String in row[1]:
			var at: int = body.find(step)
			if at <= previous or body.count(step) != 1:
				ordered.append("%s: %s" % [String(row[0]), step])
			previous = at
	_expect(ordered.is_empty(), "steps out of order or repeated: %s" % " | ".join(ordered))
	var lines: PackedStringArray = PackedStringArray()
	for line: String in code.split("\n"):
		if not line.strip_edges().is_empty():
			lines.append(line.strip_edges())
	var returning: int = 0
	for gate: String in RETURNING_GATES:
		var at: int = lines.find(gate)
		if at >= 0 and at + 1 < lines.size() and lines[at + 1].begins_with("return "):
			returning += 1
	_expect(returning == RETURNING_GATES.size(), "%d of %d gates return on their next line" % [returning, RETURNING_GATES.size()])
	## The hand-over is the last statement of the attempt, and the only one.
	var collection: PackedStringArray = _method_code(code, "func attempt_collection(")
	_expect(collection.size() > 0 and collection[collection.size() - 1] == COLLECTION_ORDER[COLLECTION_ORDER.size() - 1],
		"the attempt does not end by handing over to H3: %s" % " | ".join(collection))
	_expect(code.count("RiftMoteCollectionAttempt.attempt(") == 1 and code.count(".new(") == 1
			and code.count("RiftExperienceMote.new(") == 1 and code.count("run.run_seed()") == 2
			and code.count("RiftMoteCollectionResult.refused(") == 3,
		"the drop asks its mechanisms the wrong number of times")

	## THE MOTE: every line that touches it, exactly.
	var mote_lines: PackedStringArray = PackedStringArray()
	for line: String in lines:
		if line.contains("_mote"):
			mote_lines.append(line)
	_expect(", ".join(mote_lines) == ", ".join(PackedStringArray(MOTE_LINES)),
		"the lines touching the mote are: %s" % " | ".join(mote_lines))

	## NO ARITHMETIC, NO LITERAL, NO LOOP; `%` ONLY AS STRING FORMATTING.
	var hits: PackedStringArray = PackedStringArray()
	for operator: String in ["*", "/", "+", "&", "|", "^", "<<", ">>"]:
		if code.contains(operator):
			hits.append(operator)
	if code.replace("->", "").contains("-"):
		hits.append("-")
	var without_strings: String = RegEx.create_from_string("\"([^\"\\\\]|\\\\.)*\"").sub(code, "\"\"", true)
	var formats: int = RegEx.create_from_string("\"\"\\s*%").search_all(without_strings).size()
	if without_strings.count("%") != formats:
		hits.append("%% outside formatting (%d of %d)" % [without_strings.count("%") - formats, without_strings.count("%")])
	var literals: PackedStringArray = _numeric_literals(code)
	if not literals.is_empty():
		hits.append("literals %s" % str(literals))
	for line: String in lines:
		if line.begins_with("for ") or line.begins_with("while ") or line.begins_with("match "):
			hits.append("loop: %s" % line)
	for token: String in FORBIDDEN_TOKENS + AMBIENT_TOKENS:
		if raw.contains(token):
			hits.append(token)
	for token: String in RESTATEMENT_TOKENS:
		if code.contains(token):
			hits.append("code: %s" % token)
	_expect(hits.is_empty(), "the drop names or does: %s" % ", ".join(hits))

	## PER-FILE CLASS ALLOWLIST FROM THE ENGINE'S OWN CLASS LIST, BOTH DIRECTIONS.
	var all_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		all_classes.append(String(entry.get("class", "")))
	_expect(all_classes.size() > 100 and all_classes.has(DROP_CLASS),
		"%d project classes were enumerated, the drop %s among them" % [
			all_classes.size(), "is" if all_classes.has(DROP_CLASS) else "is NOT"])
	## NO CLASS NAME CONTAINS THE DROP'S, AND THE DROP'S CONTAINS NONE — the mote's
	## included (D-278).
	var overlaps: PackedStringArray = PackedStringArray()
	for class_id: String in all_classes:
		if class_id != DROP_CLASS and (class_id.contains(DROP_CLASS) or DROP_CLASS.contains(class_id)):
			overlaps.append(class_id)
	_expect(overlaps.is_empty(), "the drop's class name overlaps: %s" % ", ".join(overlaps))
	var outside: PackedStringArray = PackedStringArray()
	var unearned: PackedStringArray = PackedStringArray()
	for class_id: String in all_classes:
		if raw.contains(class_id) and not DROP_NAMES.has(class_id):
			outside.append(class_id)
	for class_id: String in DROP_NAMES:
		if not raw.contains(class_id):
			unearned.append(class_id)
	_expect(outside.is_empty() and unearned.is_empty(),
		"the drop names unauthorized [%s] or is granted but does not name [%s]" % [", ".join(outside), ", ".join(unearned)])
	print("  %d constructor, %d validity and %d collection steps in order, each once; %d gates each return on the next line; the hand-over to H3 is the last statement; %d lines touch the mote, none returning it; literals %s"
		% [CONSTRUCTOR_ORDER.size(), PROBLEM_ORDER.size(), COLLECTION_ORDER.size(), RETURNING_GATES.size(),
			mote_lines.size(), str(literals)])
	print("  %d hits for distance formulas, Pickup Radius, percentages, requirements, offer seeds, cards, Skills, enemies, nodes, signals, scenes, collision, files, arrays, scans or setters"
		% hits.size())
	print("  the drop names only %s; its name overlaps %d other class names; %d project classes read"
		% [", ".join(PackedStringArray(DROP_NAMES)), overlaps.size(), all_classes.size()])
	_done("the_drop_restates_nothing_and_names_only_what_it_composes")


# --- 15. Unwired ---------------------------------------------------------------------------------------------------

func _check_nothing_runs_it() -> void:
	print("")
	print("--- 15. Nothing that runs creates a drop, and scripts/pickups/ holds seven scripts")
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if path == DROP_FILE:
				continue
			project_files += 1
			var text: String = FileAccess.get_file_as_string(path)
			for token: String in [DROP_CLASS, DROP_FILE.get_file().get_basename(), "attempt_collection("]:
				if text.contains(token) and not _reader_may_name(path, token):
					referenced.append("%s names %s" % [path.get_file(), token])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for token: String in [DROP_CLASS, DROP_FILE.get_file().get_basename()]:
		if settings.contains(token):
			referenced.append("project.godot names %s" % token)
	_expect(referenced.is_empty(), "something that runs creates or collects a drop: %s" % ", ".join(referenced))
	_expect(project_files > 100, "only %d project files were scanned" % project_files)
	_expect(not settings.contains("[autoload]"), "project.godot declares an [autoload] section")
	_expect(String(ProjectSettings.get_setting("application/run/main_scene", ""))
			== "res://scenes/app/prototype_app.tscn",
		"the entrypoint moved")
	var actions: int = 0
	for action: StringName in InputMap.get_actions():
		if String(action).begins_with("ui_") and not String(action) in ["ui_confirm", "ui_cancel"]:
			continue
		actions += 1
	_expect(actions == 31, "the InputMap holds %d project actions, not 31" % actions)

	var pickup_scripts: PackedStringArray = _files_under("res://scripts/pickups", [".gd"])
	pickup_scripts.sort()
	_expect(", ".join(pickup_scripts) == ", ".join(PackedStringArray(PICKUP_SCRIPTS)),
		"scripts/pickups/ holds: %s" % ", ".join(pickup_scripts))
	print("  %d unauthorized project files create or collect a drop (%d reader granted by file and token); scripts/pickups/ holds %d scripts; %d actions; %d files scanned"
		% [referenced.size(), AUTHORIZED_READERS.size(), pickup_scripts.size(), actions, project_files])
	print("  %d refusals, %d out-of-range answers and %d collections were driven across this suite"
		% [_refusals, _out_of_range, _collections])
	_done("nothing_that_runs_creates_a_drop_and_the_directory_holds_seven_scripts")


## Whether `path` is granted `token` in `AUTHORIZED_READERS`.
func _reader_may_name(path: String, token: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) == path:
			return (row[1] as Array).has(token)
	return false


# --- Fixtures ---------------------------------------------------------------------------------------------

## The drop's ownership refusal, typed here from the two seeds' exact spellings.
func _ownership_sentence(drop_seed: String, run_seed: String) -> String:
	return "this Experience Mote drop belongs to run seed " + drop_seed + ", not to run seed " + run_seed \
		+ "; it may be collected only into the run that dropped it"


func _open(run: RiftRunLevelCoordinator) -> String:
	return run.open_current_offer(
		SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(),
		PassiveCardCatalogue.records()
	)


## A run at level 1 holding exactly its requirement and a standing offer, reached
## through the run's own public award and open.
func _run_with_an_open_offer(for_seed: int) -> RiftRunLevelCoordinator:
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(for_seed)
	_expect_accepted(run.award_experience(FIRST_REQUIREMENT), "the offer fixture's award")
	_expect_accepted(_open(run), "the offer fixture's open")
	_expect(run.is_offer_active() and run.level() == 1, "the offer fixture did not open: %s" % _snapshot(run))
	return run


## The run's current lifecycle, READ by name — never written. The run itself never
## hands it out.
func _lifecycle_of(run: RiftRunLevelCoordinator) -> RiftLevelUpCoordinator:
	return run.get("_current") as RiftLevelUpCoordinator


# --- Assertions -------------------------------------------------------------------------------------------

func _expect_accepted(refusal: String, described: String) -> void:
	_expect(refusal.is_empty(), "%s was refused: %s" % [described, refusal])


func _expect_collected(result: RiftMoteCollectionResult, described: String) -> void:
	_collections += 1
	_expect(result.is_collected() and not result.is_out_of_range() and not result.is_refused(),
		"%s was not collected: %s" % [described, result.describe()])
	_expect(result.problem().is_empty() and result.failure_reason.is_empty(),
		"%s is incoherent: %s" % [described, result.problem()])


func _expect_out_of_range(result: RiftMoteCollectionResult, described: String) -> void:
	_out_of_range += 1
	_expect(result.is_out_of_range() and not result.is_collected() and not result.is_refused(),
		"%s was not out of range: %s" % [described, result.describe()])
	_expect(result.problem().is_empty() and result.failure_reason.is_empty()
			and result.planar_distance > result.effective_radius,
		"%s is incoherent: %s" % [described, result.problem()])


## A refusal must carry a reason and NOTHING MEASURED — and the two stored numbers
## compared carelessly must not read as within range either.
func _expect_refused(result: RiftMoteCollectionResult, described: String) -> void:
	_refusals += 1
	_expect(result.is_refused() and not result.is_out_of_range() and not result.is_collected()
			and not result.failure_reason.strip_edges().is_empty(),
		"%s was not refused: %s" % [described, result.describe()])
	_expect(result.problem().is_empty(), "%s is an incoherent refusal: %s" % [described, result.problem()])
	_expect(is_inf(result.planar_distance) and result.planar_distance > 0.0 and result.effective_radius == 0.0,
		"%s carries a partial measurement: distance %s, radius %s" % [
			described, _exact(result.planar_distance), _exact(result.effective_radius)])
	_expect(not (result.planar_distance <= result.effective_radius),
		"%s reads as within range to a careless comparison" % described)


# --- Snapshots -----------------------------------------------------------------------------------------------

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


func _drop(drop: RiftMoteDrop) -> String:
	return "seed=%d position=%s base=%s collected=%s" % [
		drop.run_seed(), drop.position(), _exact(drop.base_experience()), str(drop.is_collected())]


func _whole(result: RiftMoteCollectionResult) -> String:
	return "outcome=%d reason=%s distance=%s radius=%s" % [
		result.outcome, result.failure_reason, _exact(result.planar_distance), _exact(result.effective_radius),
	]


func _exact(value: float) -> String:
	if is_nan(value) or is_inf(value) or absf(value) >= 1.0e17 or (value != 0.0 and absf(value) < 1.0e-6):
		return String.num_scientific(value)
	return String.num(value, 17)


# --- Source reading ------------------------------------------------------------------------------------------

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
## rendering the accepted H1, H2, H3 and G4 pins use.
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
		TYPE_VECTOR3:
			return "Vector3"
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


# --- The owed set -----------------------------------------------------------------------------------------------

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
