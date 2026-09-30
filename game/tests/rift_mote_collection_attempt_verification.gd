extends SceneTree
## Riftwrought — Roguelite Foundation H3 verification: a stat-aware single-mote
## collection attempt.
##
## ONE FOCUSED HEADLESS TEST. Foundation H3 is two pure-logic scripts under
## `scripts/pickups/` — a stateless coordinator that attempts to collect one
## supplied Experience Mote from one supplied world position, and the three-state
## result it answers with. It runs as a `SceneTree` script exactly as every earlier
## foundation suite does.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching its
## LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## THE HARNESS NEVER PERFORMS THE ATTEMPT IT CHECKS. Every collection below was
## made by the coordinator under test. The only awards the harness makes itself
## go through the run's own public award path, to reach an active offer and a
## Magnetism build the way a real run reaches them — and the Magnetism card is
## OFFERED and CHOSEN, never injected. The one private read — the run's current
## lifecycle, by name — only shows that an out-of-range answer or a refusal left
## the run where it was; nothing is written.
##
## EVERY EXPECTED MEASUREMENT IS EITHER A TYPED LITERAL OR THE ACCEPTED
## PICKUP-RANGE QUERY'S OWN ANSWER, asked directly with the same inputs — never a
## distance or radius this file computed.
##
## THE VALUE 25 IS TEST EVIDENCE ONLY. It is not an enemy-experience value.
##
## IT READS NO OTHER SUITE. It names no file under `tests/` but its own, which the
## runner asserts.

# --- The files ----------------------------------------------------------------------

const ATTEMPT_FILE: String = "res://scripts/pickups/rift_mote_collection_attempt.gd"
const RESULT_FILE: String = "res://scripts/pickups/rift_mote_collection_result.gd"
const THIS_FILE: String = "res://tests/rift_mote_collection_attempt_verification.gd"

const H3_FILES: Array[String] = [ATTEMPT_FILE, RESULT_FILE]

const ATTEMPT_CLASS: String = "RiftMoteCollectionAttempt"
const RESULT_CLASS: String = "RiftMoteCollectionResult"

## `scripts/pickups/` after H3: its two scripts and H2's two — and since D-277
## Foundation H4's drop, and since D-279 Foundation H5's field and its sweep result
## — and nothing else. A directory pin only: `H3_FILES` above is the own-file
## exemption, and widening it would have exempted the drop and the field from the
## unwired scan below as a side effect of sharing the directory.
const PICKUP_SCRIPTS: Array[String] = [
	"res://scripts/pickups/rift_mote_collection_attempt.gd",
	"res://scripts/pickups/rift_mote_collection_result.gd",
	"res://scripts/pickups/rift_mote_drop.gd",
	"res://scripts/pickups/rift_mote_field.gd",
	"res://scripts/pickups/rift_mote_pickup_query.gd",
	"res://scripts/pickups/rift_mote_pickup_reading.gd",
	"res://scripts/pickups/rift_mote_sweep_result.gd",
]

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]
const PROJECT_SETTINGS_FILE: String = "res://project.godot"

## THE ONLY FILES OUTSIDE H3 THAT MAY NAME THE ATTEMPT OR ITS RESULT, PER FILE AND
## PER TOKEN. D-277: Foundation H4's drop hands its whole collection to the attempt
## and answers with the result it returns, so it is granted both class names — and
## never either file name. Nothing that runs creates a drop. This replaces the
## blanket "no other file" one for one: the same single assertion is made either
## way, and the pinned count does not move.
## D-279: Foundation H5's field reads the result each of its drops answers with,
## to count it; it never calls the attempt, so it is granted the result's class
## alone — never the attempt's, and never either file name. Nothing that runs
## creates a field.
const AUTHORIZED_READERS: Array = [
	["res://scripts/pickups/rift_mote_drop.gd", ["RiftMoteCollectionAttempt", "RiftMoteCollectionResult"]],
	["res://scripts/pickups/rift_mote_field.gd", ["RiftMoteCollectionResult"]],
]

## THE ONLY PROJECT CLASSES EACH FILE MAY NAME, checked against the engine's own
## global class list in both directions. The attempt names itself, its result,
## the mote it is handed (H1), the run it is handed (G4), the accumulator it asks
## that run's build copy for (C1), and the query and reading it asks (H2) — and
## deliberately not the build itself, whose class it never needs to write down.
## The result names itself and nothing else.
const ATTEMPT_NAMES: Array[String] = [
	"PlayerStatTotals", "RiftExperienceMote", "RiftMoteCollectionAttempt",
	"RiftMoteCollectionResult", "RiftMotePickupQuery", "RiftMotePickupReading",
	"RiftRunLevelCoordinator",
]
const RESULT_NAMES: Array[String] = ["RiftMoteCollectionResult"]

const EXPECTED_ATTEMPT_SIGNATURES: Array[String] = [
	"attempt(player_position: Vector3, mote_position: Vector3, mote: Object, run: Object) -> Object",
]

const EXPECTED_RESULT_SIGNATURES: Array[String] = [
	"refused(reason: String) -> Object",
	"out_of_range(for_planar_distance: float, for_effective_radius: float) -> Object",
	"collected(for_planar_distance: float, for_effective_radius: float) -> Object",
	"is_refused() -> bool",
	"is_out_of_range() -> bool",
	"is_collected() -> bool",
	"problem() -> String",
	"describe() -> String",
]

## THE RESULT'S WHOLE STATE, IN ORDER: the outcome, the reason, the measurement.
## No object reference of any kind.
const EXPECTED_RESULT_FIELDS: Array[String] = [
	"outcome", "failure_reason", "planar_distance", "effective_radius",
]

## THE ATTEMPT ORDER, AS THE CODE MUST SPELL IT, first occurrence to first
## occurrence inside `attempt()`, each exactly once.
const ATTEMPT_ORDER: Array[String] = [
	"if mote == null:",
	"if run == null:",
	"var invalid: String = mote.problem()",
	"if not invalid.is_empty():",
	"return RiftMoteCollectionResult.refused(invalid)",
	"if mote.is_collected():",
	"var totals: PlayerStatTotals = run.run_build().stat_totals()",
	"var reading: RiftMotePickupReading = RiftMotePickupQuery.evaluate(player_position, mote_position, totals)",
	"if not reading.ok:",
	"return RiftMoteCollectionResult.refused(reading.failure_reason)",
	"if not reading.in_range:",
	"return RiftMoteCollectionResult.out_of_range(reading.planar_distance, reading.effective_radius)",
	"var refusal: String = mote.collect_into(run)",
	"if not refusal.is_empty():",
	"return RiftMoteCollectionResult.refused(refusal)",
	"return RiftMoteCollectionResult.collected(reading.planar_distance, reading.effective_radius)",
]

## Every gate, each of which must return on its very next line.
const RETURNING_GATES: Array[String] = [
	"if mote == null:", "if run == null:", "if not invalid.is_empty():", "if mote.is_collected():",
	"if not reading.ok:", "if not reading.in_range:", "if not refusal.is_empty():",
]

## Content, formula constants and the run's other operations. Scanned RAW over the
## attempt, comments included — D-215's lesson: an illustrative name in a comment
## breaches the rule just as a real one does.
const FORBIDDEN_TOKENS: Array[String] = [
	"card_", "Magnetism", "magnetism", "quick_strike", "reaching_edge", "sweeping_edge",
	"Graveblade", "PICKUP_RADIUS", "EXPERIENCE_GAIN", "BASE_PICKUP_RADIUS",
	"next_level_coordinator", "rift_experience_mote", "open_current_offer",
	"award_experience", ".tscn", "scenes/",
]

## A pure coordinator reads no ambient state and asks no physics, collision,
## navigation or scene question. Scanned raw, over both files.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
	"preload(", "load(", "get_tree", "get_node", "Node3D", "Area3D", "CollisionShape",
	"PhysicsServer", "NavigationServer", "NavigationAgent", "distance_to",
	"distance_squared_to", "length(", "global_position", "Transform3D",
]

## What the attempt must not do, as tokens over CODE lines only: no formula, no
## second radius or distance, no experience arithmetic, no mutation of a build or
## ledger, no scan, no object creation, no signal.
const RESTATEMENT_TOKENS: Array[String] = [
	"value_of", "total_for", "contributions_for", "apply", "scale", "clamp", "min(",
	"max(", "pow(", "sqrt(", "abs(", ".x", ".y", ".z", "acquire", "rank_support",
	".add(", "consume", "choose(", "duplicate", "Array", "Dictionary",
	".new(", "signal", "emit", "connect(", "Node", "Area", "Shape",
]

# --- The fixtures, stated independently -----------------------------------------------

## Test evidence only.
const TEST_MOTE: float = 25.0
const FORWARDED_BASES: Array[float] = [25.0, 0.1, 7.5]
const FIRST_REQUIREMENT: float = 100.0

## The greybox base and the +25% radius, typed here rather than read from H2.
const BASE_RADIUS: float = 2.5
const MAGNETISM_RADIUS: float = 3.125
const MAGNETISM_TOTAL: float = 0.25

## Run seed 0 offers the shipped Pickup Radius card in its Level 1 Utility lane —
## measured before this suite was written, and asserted below rather than assumed.
const MAGNETISM_SEED: int = 0
const MAGNETISM_CARD: StringName = &"card_magnetism"

## The spacing of this engine's world-position components between 2 m and 4 m:
## 2^-22 m. Positions there are exactly this far apart, so the boundary is driven
## with `==` and no tolerance.
const SPACING_2_TO_4: float = 1.0 / 4194304.0

const ORIGIN: Vector3 = Vector3.ZERO

## A player away from the origin and off the ground, and two motes measured from
## them on the ground plane: 1.5 m along z, and 3.0 m along x.
const PLAYER: Vector3 = Vector3(10.0, 0.5, -6.0)
const NEAR_MOTE: Vector3 = Vector3(10.0, 0.5, -4.5)
const THREE_METRE_MOTE: Vector3 = Vector3(13.0, 0.5, -6.0)
const NEAR_DISTANCE: float = 1.5
const THREE_METRES: float = 3.0

const AXES: Array[Vector3] = [
	Vector3(1.0, 0.0, 0.0), Vector3(-1.0, 0.0, 0.0),
	Vector3(0.0, 0.0, 1.0), Vector3(0.0, 0.0, -1.0),
]

## The accepted refusal wording this suite quotes, typed independently.
const OFFER_OPEN_REFUSAL: String = "an offer is open; it must be resolved before further experience is recorded"

const UNUSABLE_BASES: Array = [
	["zero", 0.0], ["negative", -25.0], ["not a number", NAN],
	["positive infinity", INF], ["negative infinity", -INF],
]

## Every contradictory shape a result can be tampered into. Each row starts from a
## coherent result built by one constructor and overwrites the named fields.
const TAMPERINGS: Array = [
	["a refusal with no reason", "refused", {"failure_reason": ""}],
	["a refusal with a blank reason", "refused", {"failure_reason": "   "}],
	["a refusal carrying a finite distance", "refused", {"planar_distance": 3.0}],
	["a refusal carrying a zero distance", "refused", {"planar_distance": 0.0}],
	["a refusal carrying a NaN distance", "refused", {"planar_distance": NAN}],
	["a refusal carrying a negative infinite distance", "refused", {"planar_distance": -INF}],
	["a refusal carrying a radius", "refused", {"effective_radius": 2.5}],
	["a refusal carrying a NaN radius", "refused", {"effective_radius": NAN}],
	["a refusal relabelled out of range", "refused", {"outcome": RiftMoteCollectionResult.Outcome.OUT_OF_RANGE}],
	["a refusal relabelled collected", "refused", {"outcome": RiftMoteCollectionResult.Outcome.COLLECTED}],
	["out of range with a reason", "out_of_range", {"failure_reason": "stray"}],
	["out of range exactly on the radius", "out_of_range", {"planar_distance": 2.5}],
	["out of range inside the radius", "out_of_range", {"planar_distance": 1.0}],
	["out of range at a negative distance", "out_of_range", {"planar_distance": -3.0}],
	["out of range at an infinite distance", "out_of_range", {"planar_distance": INF}],
	["out of range at a NaN distance", "out_of_range", {"planar_distance": NAN}],
	["out of range with a zero radius", "out_of_range", {"effective_radius": 0.0}],
	["out of range with a negative radius", "out_of_range", {"effective_radius": -2.5}],
	["out of range with an infinite radius", "out_of_range", {"effective_radius": INF}],
	["out of range with a NaN radius", "out_of_range", {"effective_radius": NAN}],
	["out of range relabelled collected", "out_of_range", {"outcome": RiftMoteCollectionResult.Outcome.COLLECTED}],
	["out of range relabelled refused", "out_of_range", {"outcome": RiftMoteCollectionResult.Outcome.REFUSED}],
	["collected with a reason", "collected", {"failure_reason": "stray"}],
	["collected beyond the radius", "collected", {"planar_distance": 3.0}],
	["collected at a negative distance", "collected", {"planar_distance": -1.0}],
	["collected at an infinite distance", "collected", {"planar_distance": INF}],
	["collected at a NaN distance", "collected", {"planar_distance": NAN}],
	["collected with a zero radius", "collected", {"effective_radius": 0.0}],
	["collected with a negative radius", "collected", {"effective_radius": -2.5}],
	["collected with an infinite radius", "collected", {"effective_radius": INF}],
	["collected with a NaN radius", "collected", {"effective_radius": NAN}],
	["collected relabelled out of range", "collected", {"outcome": RiftMoteCollectionResult.Outcome.OUT_OF_RANGE}],
	["collected relabelled refused", "collected", {"outcome": RiftMoteCollectionResult.Outcome.REFUSED}],
	["an unknown outcome 3", "collected", {"outcome": 3}],
	["an unknown outcome -1", "collected", {"outcome": -1}],
	["a bare new result", "bare", {}],
]

const OWED_CHECKS: Array[String] = [
	"an_in_range_mote_collects_once_with_h2s_measurement_and_its_exact_award",
	"a_collected_mote_refuses_before_any_spatial_query_and_awards_nothing",
	"a_three_metre_mote_is_out_of_range_at_baseline_and_nothing_moves",
	"the_inclusive_boundary_is_preserved_through_the_attempt",
	"an_active_offer_refuses_in_range_and_is_never_reached_out_of_range",
	"magnetism_chosen_through_a_real_run_collects_the_three_metre_mote",
	"missing_invalid_and_non_finite_inputs_refuse_in_order_with_nothing_measured",
	"two_equal_motes_remain_independent",
	"every_contradictory_result_shape_is_caught_by_problem",
	"the_attempt_holds_nothing_between_calls",
	"the_attempt_restates_nothing_and_names_only_what_it_composes",
	"nothing_that_runs_calls_the_attempt_and_the_directory_holds_seven_scripts",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0
var _out_of_range: int = 0
var _collections: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation H3 — Stat-Aware Single-Mote Collection Attempt (D-275) ===")

	_check_an_in_range_mote()
	_check_a_collected_mote()
	_check_a_three_metre_mote()
	_check_the_inclusive_boundary()
	_check_an_active_offer()
	_check_magnetism()
	_check_refusals_in_order()
	_check_two_equal_motes()
	_check_tampering()
	_check_statelessness()
	_check_the_shape()
	_check_nothing_runs_it()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT MOTE COLLECTION ATTEMPT VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT MOTE COLLECTION ATTEMPT VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. An in-range mote --------------------------------------------------------------------

func _check_an_in_range_mote() -> void:
	print("")
	print("--- 1. An in-range baseline mote collects once, with H2's own measurement and its exact award")
	var shown: PackedStringArray = PackedStringArray()
	for base: float in FORWARDED_BASES:
		var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(MAGNETISM_SEED)
		var mote: RiftExperienceMote = RiftExperienceMote.new(base)
		var expected: RiftMotePickupReading = RiftMotePickupQuery.evaluate(
			PLAYER, NEAR_MOTE, run.run_build().stat_totals())
		var result: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(PLAYER, NEAR_MOTE, mote, run)
		_expect_collected(result, "the in-range mote of %s" % _exact(base))
		_expect(result.planar_distance == expected.planar_distance and result.planar_distance == NEAR_DISTANCE,
			"the mote of %s reports a distance of %s, where H2 measures %s" % [
				_exact(base), _exact(result.planar_distance), _exact(expected.planar_distance)])
		_expect(result.effective_radius == expected.effective_radius and result.effective_radius == BASE_RADIUS,
			"the mote of %s reports a radius of %s, where H2 measures %s" % [
				_exact(base), _exact(result.effective_radius), _exact(expected.effective_radius)])
		_expect(mote.is_collected() and mote.base_experience() == base,
			"after collection the mote reads %s" % _mote(mote))
		_expect(run.experience() == base and run.level() == 1 and not run.is_offer_active(),
			"the mote of %s left the run at %s" % [_exact(base), _snapshot(run)])
		shown.append(_exact(base))
	print("  %s: each collected at %s m within the %s m baseline radius, equal to H2's own reading; each award exactly its base"
		% [", ".join(shown), _exact(NEAR_DISTANCE), _exact(BASE_RADIUS)])
	_done("an_in_range_mote_collects_once_with_h2s_measurement_and_its_exact_award")


# --- 2. A collected mote -----------------------------------------------------------------------

func _check_a_collected_mote() -> void:
	print("")
	print("--- 2. A collected mote refuses before anything is measured, and awards nothing")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(MAGNETISM_SEED)
	var mote: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	_expect_collected(RiftMoteCollectionAttempt.attempt(PLAYER, NEAR_MOTE, mote, run), "the mote")
	var awarded: float = run.experience()
	_expect(awarded == TEST_MOTE, "the first collection delivered %s" % _exact(awarded))
	var run_before: String = _snapshot(run)
	var mote_before: String = _mote(mote)
	var lifecycle: int = _lifecycle_of(run).get_instance_id()

	var retry: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(PLAYER, NEAR_MOTE, mote, run)
	_expect_refused(retry, "the same mote retried at the same position")
	_expect(retry.failure_reason.contains("already been collected"), "the retry answered: %s" % retry.failure_reason)
	_expect(_snapshot(run) == run_before and _mote(mote) == mote_before
			and _lifecycle_of(run).get_instance_id() == lifecycle,
		"the refused retry moved something: %s | %s" % [_snapshot(run), _mote(mote)])

	## NO SPATIAL QUERY IS ASKED: offered positions that are not numbers at all, a
	## collected mote still answers that it is collected — the pickup query would
	## have refused both positions first.
	var garbage: Vector3 = Vector3(NAN, NAN, NAN)
	var unmeasured: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(garbage, garbage, mote, run)
	_expect_refused(unmeasured, "the collected mote at positions that are not numbers")
	_expect(unmeasured.failure_reason == retry.failure_reason,
		"a collected mote at non-finite positions answered '%s', not that it is collected"
			% unmeasured.failure_reason)
	_expect(not RiftMotePickupQuery.evaluate(garbage, garbage, run.run_build().stat_totals()).ok,
		"the pickup query accepted non-finite positions, so this proves nothing")

	## A COLLECTED MOTE IS COLLECTED EVERYWHERE: a second run receives nothing.
	var other: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(MAGNETISM_SEED)
	var other_before: String = _snapshot(other)
	_expect_refused(RiftMoteCollectionAttempt.attempt(PLAYER, NEAR_MOTE, mote, other), "the collected mote into a second run")
	_expect(_snapshot(other) == other_before and other.experience() == 0.0,
		"a collected mote moved a second run: %s" % _snapshot(other))
	print("  the retry refused ('%s'), and refused identically at non-finite positions; the run, the mote and a second run unmoved; %s awarded once"
		% [retry.failure_reason, _exact(run.experience())])
	_done("a_collected_mote_refuses_before_any_spatial_query_and_awards_nothing")


# --- 3. A 3.0 m mote at baseline ---------------------------------------------------------------

func _check_a_three_metre_mote() -> void:
	print("")
	print("--- 3. A baseline mote at 3.0 m is out of range, stays uncollected, and awards nothing")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(MAGNETISM_SEED)
	var mote: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	var run_before: String = _snapshot(run)
	var lifecycle: int = _lifecycle_of(run).get_instance_id()
	var answers: PackedStringArray = PackedStringArray()
	var last: RiftMoteCollectionResult = null
	for attempt: int in 3:
		var result: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(PLAYER, THREE_METRE_MOTE, mote, run)
		_expect_out_of_range(result, "the 3.0 m mote, attempt %d" % (attempt + 1))
		_expect(result.planar_distance == THREE_METRES and result.effective_radius == BASE_RADIUS,
			"the 3.0 m mote reads %s" % result.describe())
		answers.append(result.describe())
		last = result
	_expect(answers[0] == answers[1] and answers[1] == answers[2], "three identical attempts answered: %s" % " | ".join(answers))
	_expect(not mote.is_collected() and _snapshot(run) == run_before and run.experience() == 0.0
			and _lifecycle_of(run).get_instance_id() == lifecycle,
		"an out-of-range answer moved something: %s | %s" % [_snapshot(run), _mote(mote)])

	## THE SAME MOTE IS STILL AVAILABLE: brought within range, it pays once.
	_expect_collected(RiftMoteCollectionAttempt.attempt(PLAYER, NEAR_MOTE, mote, run), "the same mote within range")
	_expect(run.experience() == TEST_MOTE, "the mote then delivered %s" % _exact(run.experience()))
	print("  baseline 3.0 m: out of range at %s m against %s m, three times; the mote uncollected and the run unmoved; brought within range it paid %s once"
		% [_exact(last.planar_distance), _exact(last.effective_radius), _exact(run.experience())])
	_done("a_three_metre_mote_is_out_of_range_at_baseline_and_nothing_moves")


# --- 4. The inclusive boundary ------------------------------------------------------------------

func _check_the_inclusive_boundary() -> void:
	print("")
	print("--- 4. H2's inclusive boundary is preserved through the attempt, with no tolerance")
	## The spacing is measured before anything relies on it.
	var stepped: Vector3 = Vector3(BASE_RADIUS + SPACING_2_TO_4, 0.0, 0.0)
	var halved: Vector3 = Vector3(BASE_RADIUS + SPACING_2_TO_4 / 2.0, 0.0, 0.0)
	_expect(stepped.x > BASE_RADIUS and halved.x == BASE_RADIUS,
		"positions near 2.5 m are not 2^-22 m apart: %s / %s" % [_exact(stepped.x), _exact(halved.x)])
	var on_boundary: int = 0
	var outside: int = 0
	var inside: int = 0
	var outside_distances: Dictionary = {}
	var inside_distances: Dictionary = {}
	for axis: Vector3 in AXES:
		var on_result: RiftMoteCollectionResult = _fresh_attempt(ORIGIN, axis * BASE_RADIUS)
		_expect_collected(on_result, "a mote exactly on the boundary along %s" % axis)
		if on_result.planar_distance == on_result.effective_radius and on_result.effective_radius == BASE_RADIUS:
			on_boundary += 1
		var out_result: RiftMoteCollectionResult = _fresh_attempt(ORIGIN, axis * (BASE_RADIUS + SPACING_2_TO_4))
		_expect_out_of_range(out_result, "a mote one spacing outside along %s" % axis)
		if out_result.planar_distance > out_result.effective_radius:
			outside += 1
		outside_distances[_exact(out_result.planar_distance)] = true
		var in_result: RiftMoteCollectionResult = _fresh_attempt(ORIGIN, axis * (BASE_RADIUS - SPACING_2_TO_4))
		_expect_collected(in_result, "a mote one spacing inside along %s" % axis)
		if in_result.planar_distance < in_result.effective_radius:
			inside += 1
		inside_distances[_exact(in_result.planar_distance)] = true
	## A 3-4-5 diagonal, from a player away from the origin.
	var diagonal: RiftMoteCollectionResult = _fresh_attempt(PLAYER, PLAYER + Vector3(1.5, 0.0, 2.0))
	_expect_collected(diagonal, "a mote on the 3-4-5 diagonal boundary")
	if diagonal.planar_distance == BASE_RADIUS and diagonal.effective_radius == BASE_RADIUS:
		on_boundary += 1
	_expect(on_boundary == 5 and outside == 4 and inside == 4,
		"%d of 5 on the boundary, %d of 4 just outside and %d of 4 just inside behaved" % [on_boundary, outside, inside])
	_expect(outside_distances.size() == 1 and inside_distances.size() == 1,
		"the four axes measured different distances: %s / %s" % [str(outside_distances.keys()), str(inside_distances.keys())])
	print("  baseline boundary: %d on-boundary motes collected at distance == radius == %s m; %d at %s m out of range; %d at %s m collected"
		% [on_boundary, _exact(diagonal.effective_radius), outside, ", ".join(PackedStringArray(outside_distances.keys())),
			inside, ", ".join(PackedStringArray(inside_distances.keys()))])
	_done("the_inclusive_boundary_is_preserved_through_the_attempt")


# --- 5. An active offer -------------------------------------------------------------------------

func _check_an_active_offer() -> void:
	print("")
	print("--- 5. While an offer stands: in range is refused with G4's own reason; out of range never reaches the mote")
	var run: RiftRunLevelCoordinator = _run_with_an_open_offer()
	var control: RiftRunLevelCoordinator = _run_with_an_open_offer()
	var standing: String = _snapshot(run)
	var lifecycle: int = _lifecycle_of(run).get_instance_id()

	## OUT OF RANGE IS STILL A VALID ANSWER, BECAUSE THE MOTE IS NEVER ASKED. Had
	## it been, the run would have refused it — exactly as the in-range attempt
	## below is refused — and the attempt turns every such refusal into REFUSED.
	var far_mote: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	var far: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(PLAYER, THREE_METRE_MOTE, far_mote, run)
	_expect_out_of_range(far, "a 3.0 m mote while the offer stands")
	_expect(far.planar_distance == THREE_METRES and far.effective_radius == BASE_RADIUS,
		"the far mote reads %s" % far.describe())
	_expect(not far_mote.is_collected() and _snapshot(run) == standing and run.is_offer_active(),
		"the out-of-range answer moved something: %s" % _snapshot(run))

	## IN RANGE REACHES THE MOTE, AND THE RUN'S REFUSAL IS PASSED ON WORD FOR WORD.
	var near_mote: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	var refusals: PackedStringArray = PackedStringArray()
	for attempt: int in 2:
		var near: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(PLAYER, NEAR_MOTE, near_mote, run)
		_expect_refused(near, "an in-range mote while the offer stands, attempt %d" % (attempt + 1))
		_expect(near.failure_reason == OFFER_OPEN_REFUSAL, "the active offer answered: %s" % near.failure_reason)
		refusals.append(near.failure_reason)
	## The mote's own answer in an identical run, asked directly of a control mote.
	var direct: String = RiftExperienceMote.new(TEST_MOTE).collect_into(control)
	_expect(refusals[0] == direct and refusals[1] == direct,
		"the attempt answered '%s' where the mote itself answers '%s'" % [refusals[0], direct])
	_expect(not near_mote.is_collected() and _snapshot(run) == standing
			and _lifecycle_of(run).get_instance_id() == lifecycle and run.is_offer_active(),
		"a refused in-range attempt moved something: %s | %s" % [_snapshot(run), _mote(near_mote)])

	## RESOLVED, THE SAME MOTE AT THE SAME POSITION PAYS ONCE.
	var outcome: RiftRunLevelUpResult = run.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect(outcome.succeeded() and run.level() == 2 and run.experience() == 0.0 and not run.is_offer_active(),
		"resolving the offer left %s (%s)" % [_snapshot(run), outcome.failure_reason()])
	var paid: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(PLAYER, NEAR_MOTE, near_mote, run)
	_expect_collected(paid, "the same mote at the same position after the choice")
	_expect(paid.planar_distance == NEAR_DISTANCE and paid.effective_radius == BASE_RADIUS
			and run.experience() == TEST_MOTE and near_mote.is_collected(),
		"the retry read %s and delivered %s" % [paid.describe(), _exact(run.experience())])
	## The far mote is still out of range — the Combat lane grants no Pickup Radius.
	_expect_out_of_range(RiftMoteCollectionAttempt.attempt(PLAYER, THREE_METRE_MOTE, far_mote, run),
		"the far mote after the choice")
	_expect(not far_mote.is_collected(), "the far mote was collected")
	print("  while the offer stood: %s m out of range with the mote never asked; in range refused twice ('%s'), equal to the mote's own answer; after the choice the same mote at the same position paid %s once"
		% [_exact(far.planar_distance), refusals[0], _exact(run.experience())])
	_done("an_active_offer_refuses_in_range_and_is_never_reached_out_of_range")


# --- 6. Magnetism, through a real run ---------------------------------------------------------------

func _check_magnetism() -> void:
	print("")
	print("--- 6. Magnetism, offered and chosen through the run, collects the 3.0 m mote at 3.125 m")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(MAGNETISM_SEED)
	var early: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	var baseline: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(PLAYER, THREE_METRE_MOTE, early, run)
	_expect_out_of_range(baseline, "the 3.0 m mote on the fresh run")
	_expect(baseline.planar_distance == THREE_METRES and baseline.effective_radius == BASE_RADIUS
			and not early.is_collected(),
		"the baseline 3.0 m mote reads %s" % baseline.describe())

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
		"the build's Pickup Radius total is %s, not %s" % [
			_exact(build.total_for(PlayerStats.PICKUP_RADIUS)), _exact(MAGNETISM_TOTAL)])
	_expect(build.total_for(PlayerStats.EXPERIENCE_GAIN) == 0.0,
		"the build holds Experience Gain %s" % _exact(build.total_for(PlayerStats.EXPERIENCE_GAIN)))

	## A FRESH MOTE AT THE SAME 3.0 m IS NOW COLLECTED, AT H2's OWN 3.125 m.
	var expected: RiftMotePickupReading = RiftMotePickupQuery.evaluate(
		PLAYER, THREE_METRE_MOTE, run.run_build().stat_totals())
	var fresh: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	var collected: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(PLAYER, THREE_METRE_MOTE, fresh, run)
	_expect_collected(collected, "a fresh 3.0 m mote on the Magnetism build")
	_expect(collected.planar_distance == THREE_METRES and collected.effective_radius == MAGNETISM_RADIUS
			and collected.effective_radius == expected.effective_radius
			and collected.planar_distance == expected.planar_distance,
		"the Magnetism attempt reads %s, where H2 reads %s" % [collected.describe(), expected.describe()])
	## PICKUP RANGE, NOT EXPERIENCE GAIN: the award is exactly the mote's base.
	var awarded: float = run.experience()
	_expect(awarded == TEST_MOTE and fresh.is_collected(),
		"the Magnetism build turned a mote of %s into %s" % [_exact(TEST_MOTE), _exact(awarded)])

	## The mote the baseline left uncollected is collectable now, from the same spot.
	_expect_collected(RiftMoteCollectionAttempt.attempt(PLAYER, THREE_METRE_MOTE, early, run),
		"the mote the baseline left out of range")
	_expect(run.experience() == TEST_MOTE + TEST_MOTE, "two motes delivered %s" % _exact(run.experience()))
	## The baseline answer already given is unmoved: it holds no reference to anything.
	_expect(baseline.is_out_of_range() and baseline.effective_radius == BASE_RADIUS,
		"the answer given before the card now reads %s" % baseline.describe())

	## The boundary moves with the radius: exactly 3.125 m in, one spacing beyond out.
	var on_boundary: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(
		ORIGIN, Vector3(MAGNETISM_RADIUS, 0.0, 0.0), RiftExperienceMote.new(TEST_MOTE), run)
	_expect_collected(on_boundary, "a mote exactly on the 3.125 m boundary")
	_expect(on_boundary.planar_distance == MAGNETISM_RADIUS and on_boundary.effective_radius == MAGNETISM_RADIUS,
		"the 3.125 m boundary mote reads %s" % on_boundary.describe())
	var beyond: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(
		ORIGIN, Vector3(MAGNETISM_RADIUS + SPACING_2_TO_4, 0.0, 0.0), RiftExperienceMote.new(TEST_MOTE), run)
	_expect_out_of_range(beyond, "a mote one spacing beyond 3.125 m")
	print("  run seed %d, level 1 Utility lane: %s chosen; Pickup Radius total %s; Experience Gain %s"
		% [MAGNETISM_SEED, MAGNETISM_CARD, _exact(build.total_for(PlayerStats.PICKUP_RADIUS)),
			_exact(build.total_for(PlayerStats.EXPERIENCE_GAIN))])
	print("  %s m: out of range at %s m before the card; collected at %s m after it, equal to H2's own reading; the award stayed exactly %s"
		% [_exact(collected.planar_distance), _exact(baseline.effective_radius), _exact(collected.effective_radius),
			_exact(awarded)])
	print("  the %s m boundary collected; %s m out of range" % [
		_exact(on_boundary.planar_distance), _exact(beyond.planar_distance)])
	_done("magnetism_chosen_through_a_real_run_collects_the_three_metre_mote")


# --- 7. Refusals, in order ------------------------------------------------------------------------

func _check_refusals_in_order() -> void:
	print("")
	print("--- 7. Missing, invalid and non-finite inputs refuse in the contract order, with nothing measured")
	var garbage: Vector3 = Vector3(NAN, INF, -INF)
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(MAGNETISM_SEED)
	var untouched: String = _snapshot(run)

	## 1 BEFORE 2 BEFORE 3, AND ALL THREE BEFORE ANY MEASUREMENT.
	var no_mote: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(garbage, garbage, null, null)
	_expect_refused(no_mote, "no mote and no run")
	_expect(no_mote.failure_reason.contains("needs an Experience Mote"), "no mote answered: %s" % no_mote.failure_reason)
	var valid: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	var no_run: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(garbage, garbage, valid, null)
	_expect_refused(no_run, "a valid mote and no run")
	_expect(no_run.failure_reason.contains("a run to collect into") and not valid.is_collected(),
		"no run answered: %s" % no_run.failure_reason)
	var named: PackedStringArray = PackedStringArray()
	for row: Array in UNUSABLE_BASES:
		var mote: RiftExperienceMote = RiftExperienceMote.new(float(row[1]))
		var problem: String = mote.problem()
		_expect(not problem.is_empty(), "the %s mote is a valid record" % String(row[0]))
		var before_run: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(garbage, garbage, mote, null)
		_expect_refused(before_run, "the %s mote with no run" % String(row[0]))
		_expect(before_run.failure_reason == no_run.failure_reason,
			"the %s mote with no run answered '%s', not the missing run" % [String(row[0]), before_run.failure_reason])
		var invalid: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(garbage, garbage, mote, run)
		_expect_refused(invalid, "the %s mote" % String(row[0]))
		_expect(invalid.failure_reason == problem,
			"the %s mote answered '%s', not its own problem '%s'" % [String(row[0]), invalid.failure_reason, problem])
		_expect(not mote.is_collected(), "the %s mote was collected" % String(row[0]))
		named.append(String(row[0]))
	_expect(_snapshot(run) == untouched, "an unusable input moved the run: %s" % _snapshot(run))

	## EVERY NON-FINITE COMPONENT OF EITHER POSITION: H2's reason, word for word.
	var cases: int = 0
	var quoted: int = 0
	for which: String in ["player", "mote"]:
		for component: int in 3:
			for bad: float in [NAN, INF, -INF]:
				var player: Vector3 = PLAYER
				var place: Vector3 = NEAR_MOTE
				if which == "player":
					player[component] = bad
				else:
					place[component] = bad
				var h2: RiftMotePickupReading = RiftMotePickupQuery.evaluate(player, place, run.run_build().stat_totals())
				var result: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(player, place, valid, run)
				_expect_refused(result, "the %s position with %s in component %d" % [which, _exact(bad), component])
				_expect(not h2.ok, "the pickup query accepted %s %s" % [which, str(player if which == "player" else place)])
				if result.failure_reason == h2.failure_reason:
					quoted += 1
				cases += 1
	_expect(cases == 18 and quoted == 18, "%d of %d non-finite refusals quoted H2 verbatim" % [quoted, cases])
	_expect(not valid.is_collected() and _snapshot(run) == untouched,
		"a non-finite refusal moved something: %s | %s" % [_snapshot(run), _mote(valid)])
	## Refused for its positions, the same mote is still available.
	_expect_collected(RiftMoteCollectionAttempt.attempt(PLAYER, NEAR_MOTE, valid, run), "the same mote at finite positions")
	_expect(run.experience() == TEST_MOTE, "the retried mote delivered %s" % _exact(run.experience()))
	print("  order: no mote before no run before an invalid mote before any measurement; %s: each refused with its own problem"
		% ", ".join(named))
	print("  %d non-finite components (NaN, +inf, -inf in x, y and z of either position): %d refused quoting H2 verbatim with nothing measured; the mote then collected"
		% [cases, quoted])
	_done("missing_invalid_and_non_finite_inputs_refuse_in_order_with_nothing_measured")


# --- 8. Two equal motes ----------------------------------------------------------------------------

func _check_two_equal_motes() -> void:
	print("")
	print("--- 8. Two separate motes of the same value at the same position remain independent")
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(MAGNETISM_SEED)
	var first: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	var second: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	_expect(first != second, "two constructions answered one object")
	## An out-of-range answer for one says nothing about the other.
	_expect_out_of_range(RiftMoteCollectionAttempt.attempt(PLAYER, THREE_METRE_MOTE, second, run), "the second mote at 3.0 m")
	_expect_collected(RiftMoteCollectionAttempt.attempt(PLAYER, NEAR_MOTE, first, run), "the first mote")
	_expect(first.is_collected() and not second.is_collected(),
		"collecting the first moved the second: %s / %s" % [_mote(first), _mote(second)])
	_expect_collected(RiftMoteCollectionAttempt.attempt(PLAYER, NEAR_MOTE, second, run), "the second, equal mote")
	_expect(run.experience() == TEST_MOTE + TEST_MOTE, "two equal motes delivered %s" % _exact(run.experience()))
	var settled: String = _snapshot(run)
	_expect_refused(RiftMoteCollectionAttempt.attempt(PLAYER, NEAR_MOTE, first, run), "the first mote again")
	_expect_refused(RiftMoteCollectionAttempt.attempt(PLAYER, NEAR_MOTE, second, run), "the second mote again")
	_expect(_snapshot(run) == settled, "a repeat moved the run: %s" % _snapshot(run))
	print("  2 motes of %s at one position: %s delivered, each once; one's out-of-range answer left the other alone; both repeats refused"
		% [_exact(TEST_MOTE), _exact(run.experience())])
	_done("two_equal_motes_remain_independent")


# --- 9. Tampering ------------------------------------------------------------------------------------

func _check_tampering() -> void:
	print("")
	print("--- 9. Every contradictory result shape is caught by the result's own problem()")
	## THE NON-VALUES ARE H2's OWN.
	_expect(RiftMoteCollectionResult.NO_DISTANCE == RiftMotePickupReading.NO_DISTANCE
			and is_inf(RiftMoteCollectionResult.NO_DISTANCE) and RiftMoteCollectionResult.NO_DISTANCE > 0.0,
		"the refused distance is %s" % _exact(RiftMoteCollectionResult.NO_DISTANCE))
	_expect(RiftMoteCollectionResult.NO_RADIUS == RiftMotePickupReading.NO_RADIUS
			and RiftMoteCollectionResult.NO_RADIUS == 0.0,
		"the refused radius is %s" % _exact(RiftMoteCollectionResult.NO_RADIUS))

	## COHERENT CONTROLS: each built by its constructor, each exactly one outcome.
	var controls: Array[RiftMoteCollectionResult] = [
		RiftMoteCollectionResult.refused("a stated reason"),
		RiftMoteCollectionResult.refused("  "),
		RiftMoteCollectionResult.out_of_range(THREE_METRES, BASE_RADIUS),
		RiftMoteCollectionResult.out_of_range(BASE_RADIUS + SPACING_2_TO_4, BASE_RADIUS),
		RiftMoteCollectionResult.collected(0.0, BASE_RADIUS),
		RiftMoteCollectionResult.collected(BASE_RADIUS, BASE_RADIUS),
	]
	var coherent: int = 0
	for control: RiftMoteCollectionResult in controls:
		var exclusive: int = int(control.is_refused()) + int(control.is_out_of_range()) + int(control.is_collected())
		if control.problem().is_empty() and exclusive == 1:
			coherent += 1
	_expect(coherent == controls.size(), "%d of %d constructor-built results are coherent with one outcome" % [
		coherent, controls.size()])
	_expect(not controls[1].failure_reason.strip_edges().is_empty(), "a blank refusal reason was kept blank")

	var caught: int = 0
	var missed: PackedStringArray = PackedStringArray()
	for row: Array in TAMPERINGS:
		var result: RiftMoteCollectionResult = _tampering_base(String(row[1]))
		var overrides: Dictionary = row[2]
		for field: String in overrides:
			result.set(field, overrides[field])
		if result.problem().is_empty():
			missed.append(String(row[0]))
		else:
			caught += 1
	_expect(missed.is_empty(), "problem() accepted: %s" % ", ".join(missed))
	print("  %d of %d tampered results caught; %d constructor-built controls coherent with exactly one outcome; the refused distance is %s and the refused radius %s, as H2's"
		% [caught, TAMPERINGS.size(), coherent, _exact(RiftMoteCollectionResult.NO_DISTANCE),
			_exact(RiftMoteCollectionResult.NO_RADIUS)])
	_done("every_contradictory_result_shape_is_caught_by_problem")


func _tampering_base(kind: String) -> RiftMoteCollectionResult:
	match kind:
		"refused":
			return RiftMoteCollectionResult.refused("a tampering fixture")
		"out_of_range":
			return RiftMoteCollectionResult.out_of_range(THREE_METRES, BASE_RADIUS)
		"collected":
			return RiftMoteCollectionResult.collected(NEAR_DISTANCE, BASE_RADIUS)
	return RiftMoteCollectionResult.new()


# --- 10. Statelessness -------------------------------------------------------------------------------

func _check_statelessness() -> void:
	print("")
	print("--- 10. The attempt holds nothing, and retains nothing between calls")
	var script: GDScript = load(ATTEMPT_FILE) as GDScript
	var instance_fields: PackedStringArray = _fields_of(RiftMoteCollectionAttempt.new())
	_expect(instance_fields.is_empty(), "the attempt carries fields: %s" % ", ".join(instance_fields))
	var script_properties: PackedStringArray = PackedStringArray()
	for entry: Dictionary in script.get_script_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			script_properties.append(String(entry.get("name", "")))
	_expect(script_properties.is_empty(), "the attempt declares script variables: %s" % ", ".join(script_properties))
	var constants: Dictionary = script.get_script_constant_map()
	_expect(constants.is_empty(), "the attempt declares constants: %s" % str(constants))
	var signatures: PackedStringArray = _signatures_of(ATTEMPT_FILE)
	_expect(", ".join(signatures) == ", ".join(PackedStringArray(EXPECTED_ATTEMPT_SIGNATURES)),
		"the attempt declares: %s" % ", ".join(signatures))

	## THE SAME OUT-OF-RANGE QUESTION A HUNDRED TIMES, ON ONE MOTE AND ONE RUN.
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(MAGNETISM_SEED)
	var mote: RiftExperienceMote = RiftExperienceMote.new(TEST_MOTE)
	var before: String = _snapshot(run)
	var first: String = _whole(RiftMoteCollectionAttempt.attempt(PLAYER, THREE_METRE_MOTE, mote, run))
	var drifted: int = 0
	for _index: int in 100:
		if _whole(RiftMoteCollectionAttempt.attempt(PLAYER, THREE_METRE_MOTE, mote, run)) != first:
			drifted += 1
	_expect(drifted == 0, "%d of 100 identical questions were answered differently" % drifted)
	_expect(_snapshot(run) == before and not mote.is_collected(), "100 out-of-range answers moved something")

	## BETWEEN OTHER ANSWERS: a refusal, a collection and a far miss change nothing.
	var _refused_between: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(PLAYER, NEAR_MOTE, null, run)
	var _collected_between: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(
		PLAYER, NEAR_MOTE, RiftExperienceMote.new(TEST_MOTE), run)
	var _far_between: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(
		PLAYER, PLAYER + Vector3(100.0, 0.0, 0.0), RiftExperienceMote.new(TEST_MOTE), run)
	_expect(_whole(RiftMoteCollectionAttempt.attempt(PLAYER, THREE_METRE_MOTE, mote, run)) == first,
		"a question asked after three others was answered differently")

	## THE RESULT IS FOUR SCALARS, IN THE DECLARED ORDER, AND NO OBJECT.
	var result: RiftMoteCollectionResult = RiftMoteCollectionAttempt.attempt(PLAYER, THREE_METRE_MOTE, mote, run)
	var result_fields: PackedStringArray = _fields_of(result)
	_expect(", ".join(result_fields) == ", ".join(PackedStringArray(EXPECTED_RESULT_FIELDS)),
		"the result carries: %s" % ", ".join(result_fields))
	var object_fields: PackedStringArray = PackedStringArray()
	for entry: Dictionary in result.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0 and int(entry.get("type", 0)) == TYPE_OBJECT:
			object_fields.append(String(entry.get("name", "")))
	_expect(object_fields.is_empty(), "the result holds object references: %s" % ", ".join(object_fields))
	var result_signatures: PackedStringArray = _signatures_of(RESULT_FILE)
	_expect(", ".join(result_signatures) == ", ".join(PackedStringArray(EXPECTED_RESULT_SIGNATURES)),
		"the result declares: %s" % ", ".join(result_signatures))
	var result_constants: PackedStringArray = PackedStringArray((load(RESULT_FILE) as GDScript).get_script_constant_map().keys())
	result_constants.sort()
	_expect(", ".join(result_constants) == "NO_DISTANCE, NO_RADIUS, Outcome",
		"the result's constants are %s" % ", ".join(result_constants))
	print("  %d instance fields, %d script variables, %d constants, %d method; %d of 100 identical questions disagree, and one asked after three others agrees"
		% [instance_fields.size(), script_properties.size(), constants.size(), signatures.size(), drifted])
	print("  the result holds %d fields (%s) and %d object references; %d methods"
		% [result_fields.size(), ", ".join(result_fields), object_fields.size(), result_signatures.size()])
	_done("the_attempt_holds_nothing_between_calls")


# --- 11. The shape ---------------------------------------------------------------------------------------

func _check_the_shape() -> void:
	print("")
	print("--- 11. The attempt restates nothing, and each file names only what it composes")
	var attempt_raw: String = FileAccess.get_file_as_string(ATTEMPT_FILE)
	var result_raw: String = FileAccess.get_file_as_string(RESULT_FILE)
	var attempt_code: String = _code_only(attempt_raw)
	var result_code: String = _code_only(result_raw)
	_expect(attempt_raw.length() > 2000 and attempt_code.length() > 500 and attempt_code.length() < attempt_raw.length(),
		"the attempt read as %d / %d characters" % [attempt_raw.length(), attempt_code.length()])
	_expect(result_raw.length() > 2000 and result_code.length() > 500 and result_code.length() < result_raw.length(),
		"the result read as %d / %d characters" % [result_raw.length(), result_code.length()])

	## THE ORDER, EACH STEP ONCE, EACH GATE RETURNING ON ITS NEXT LINE.
	var body: PackedStringArray = _method_code(attempt_code, "static func attempt(")
	var previous: int = -1
	var ordered: bool = true
	for step: String in ATTEMPT_ORDER:
		var at: int = body.find(step)
		if at <= previous or body.count(step) != 1:
			ordered = false
		previous = at
	_expect(ordered, "attempt() does not spell its steps in order, each once: %s" % " | ".join(body))
	var returning: int = 0
	for gate: String in RETURNING_GATES:
		var at: int = body.find(gate)
		if at >= 0 and at + 1 < body.size() and body[at + 1].begins_with("return "):
			returning += 1
	_expect(returning == RETURNING_GATES.size(), "%d of %d gates return on their next line" % [
		returning, RETURNING_GATES.size()])
	## The mote is asked to collect itself only after the in-range gate has returned
	## every miss.
	_expect(body.find("var refusal: String = mote.collect_into(run)")
			== body.find("return RiftMoteCollectionResult.out_of_range(reading.planar_distance, reading.effective_radius)") + 1,
		"the collection is not the step immediately after the out-of-range return")
	_expect(attempt_code.count(".collect_into(") == 1 and attempt_code.count("RiftMotePickupQuery.evaluate(") == 1
			and attempt_code.count(".run_build()") == 1 and attempt_code.count(".stat_totals()") == 1
			and attempt_code.count(".problem()") == 1 and attempt_code.count(".is_collected()") == 1,
		"the attempt asks its mechanisms the wrong number of times")
	_expect(attempt_code.count("RiftMoteCollectionResult.refused(") == 6
			and attempt_code.count("RiftMoteCollectionResult.out_of_range(") == 1
			and attempt_code.count("RiftMoteCollectionResult.collected(") == 1,
		"the attempt builds its answers %d / %d / %d times" % [
			attempt_code.count("RiftMoteCollectionResult.refused("),
			attempt_code.count("RiftMoteCollectionResult.out_of_range("),
			attempt_code.count("RiftMoteCollectionResult.collected(")])

	## NO ARITHMETIC, NO LITERAL, NO DECLARATION AT THE TOP LEVEL, NO CONSTRUCTOR.
	var hits: PackedStringArray = PackedStringArray()
	for operator: String in ["*", "/", "+", "&", "|", "^", "<<", ">>", "%"]:
		if attempt_code.contains(operator):
			hits.append("attempt: %s" % operator)
	if attempt_code.replace("->", "").contains("-"):
		hits.append("attempt: -")
	for operator: String in ["*", "/", "+", "&", "|", "^", "<<", ">>"]:
		if result_code.contains(operator):
			hits.append("result: %s" % operator)
	if result_code.replace("->", "").contains("-"):
		hits.append("result: -")
	var attempt_literals: PackedStringArray = _numeric_literals(attempt_code)
	var result_literals: PackedStringArray = _numeric_literals(result_code)
	if not attempt_literals.is_empty():
		hits.append("attempt literals %s" % str(attempt_literals))
	if ", ".join(result_literals) != "0.0":
		hits.append("result literals %s" % str(result_literals))
	for line: String in attempt_code.split("\n"):
		for opener: String in ["var ", "static var ", "const ", "@", "func _init", "signal "]:
			if line.begins_with(opener):
				hits.append("attempt declares: %s" % line)
		if line.strip_edges().begins_with("for ") or line.strip_edges().begins_with("while "):
			hits.append("attempt loops: %s" % line)
	for line: String in result_code.split("\n"):
		if line.begins_with("static var ") or line.begins_with("signal ") or line.begins_with("func _init"):
			hits.append("result declares: %s" % line)
		if line.strip_edges().begins_with("for ") or line.strip_edges().begins_with("while "):
			hits.append("result loops: %s" % line)

	## SCANS: content and formula constants raw, ambient reads raw, restatement in code.
	for token: String in FORBIDDEN_TOKENS:
		if attempt_raw.contains(token):
			hits.append("attempt: %s" % token)
		if result_raw.contains(token):
			hits.append("result: %s" % token)
	for token: String in AMBIENT_TOKENS:
		if attempt_raw.contains(token):
			hits.append("attempt: %s" % token)
		if result_raw.contains(token):
			hits.append("result: %s" % token)
	for token: String in RESTATEMENT_TOKENS:
		if attempt_code.contains(token):
			hits.append("attempt code: %s" % token)
	if result_raw.contains("collect_into("):
		hits.append("result: collect_into(")
	_expect(hits.is_empty(), "the H3 files name or do: %s" % ", ".join(hits))

	## PER-FILE CLASS ALLOWLIST FROM THE ENGINE'S OWN CLASS LIST, BOTH DIRECTIONS.
	var all_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		all_classes.append(String(entry.get("class", "")))
	_expect(all_classes.size() > 100 and all_classes.has(ATTEMPT_CLASS) and all_classes.has(RESULT_CLASS),
		"%d project classes were enumerated, the two H3 classes %s" % [
			all_classes.size(), "among them" if all_classes.has(ATTEMPT_CLASS) and all_classes.has(RESULT_CLASS) else "NOT both among them"])
	var collisions: PackedStringArray = PackedStringArray()
	for class_id: String in all_classes:
		for own: String in [ATTEMPT_CLASS, RESULT_CLASS]:
			if class_id != own and (class_id.contains(own) or own.contains(class_id)):
				collisions.append("%s / %s" % [class_id, own])
	_expect(collisions.is_empty(), "an H3 class name overlaps another class name: %s" % ", ".join(collisions))
	for row: Array in [[attempt_raw, ATTEMPT_NAMES, "the attempt"], [result_raw, RESULT_NAMES, "the result"]]:
		var raw: String = row[0]
		var granted: Array = row[1]
		var outside: PackedStringArray = PackedStringArray()
		var unearned: PackedStringArray = PackedStringArray()
		for class_id: String in all_classes:
			if raw.contains(class_id) and not granted.has(class_id):
				outside.append(class_id)
		for class_id: String in granted:
			if not raw.contains(class_id):
				unearned.append(class_id)
		_expect(outside.is_empty() and unearned.is_empty(),
			"%s names unauthorized [%s] or is granted but does not name [%s]" % [
				String(row[2]), ", ".join(outside), ", ".join(unearned)])
	print("  %d attempt steps in order, each once; %d gates each return on the next line; the mote is asked only after the out-of-range return; literals attempt %s, result %s"
		% [ATTEMPT_ORDER.size(), RETURNING_GATES.size(), str(attempt_literals), str(result_literals)])
	print("  %d hits for percentages, base radii, distance formulas, experience formulas, cards, Skills, mutations, stored positions, scans, nodes, areas, shapes or signals"
		% hits.size())
	print("  the attempt names only %s; the result names only %s" % [
		", ".join(PackedStringArray(ATTEMPT_NAMES)), ", ".join(PackedStringArray(RESULT_NAMES))])
	_done("the_attempt_restates_nothing_and_names_only_what_it_composes")


# --- 12. Unwired -------------------------------------------------------------------------------------------

func _check_nothing_runs_it() -> void:
	print("")
	print("--- 12. Nothing that runs calls the attempt, and scripts/pickups/ holds seven scripts")
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			project_files += 1
			if H3_FILES.has(path):
				continue
			var text: String = FileAccess.get_file_as_string(path)
			for token: String in [ATTEMPT_CLASS, RESULT_CLASS, ATTEMPT_FILE.get_file(), RESULT_FILE.get_file()]:
				if text.contains(token) and not _reader_may_name(path, token):
					referenced.append("%s names %s" % [path.get_file(), token])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for token: String in [ATTEMPT_CLASS, RESULT_CLASS, "scripts/pickups"]:
		if settings.contains(token):
			referenced.append("project.godot names %s" % token)
	_expect(referenced.is_empty(), "something that runs names H3: %s" % ", ".join(referenced))
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
	print("  %d unauthorized project files name the attempt or its result (%d readers granted by file and token); scripts/pickups/ holds %d scripts; %d actions; %d files scanned"
		% [referenced.size(), AUTHORIZED_READERS.size(), pickup_scripts.size(), actions, project_files])
	print("  %d refusals, %d out-of-range answers and %d collections were driven across this suite"
		% [_refusals, _out_of_range, _collections])
	_done("nothing_that_runs_calls_the_attempt_and_the_directory_holds_seven_scripts")


## Whether `path` is granted `token` in `AUTHORIZED_READERS`.
func _reader_may_name(path: String, token: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) == path:
			return (row[1] as Array).has(token)
	return false


# --- Fixtures ---------------------------------------------------------------------------------------------

func _open(run: RiftRunLevelCoordinator) -> String:
	return run.open_current_offer(
		SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(),
		PassiveCardCatalogue.records()
	)


## A run at level 1 holding exactly its requirement and a standing offer, reached
## through the run's own public award and open.
func _run_with_an_open_offer() -> RiftRunLevelCoordinator:
	var run: RiftRunLevelCoordinator = RiftRunLevelCoordinator.new(MAGNETISM_SEED)
	_expect_accepted(run.award_experience(FIRST_REQUIREMENT), "the offer fixture's award")
	_expect_accepted(_open(run), "the offer fixture's open")
	_expect(run.is_offer_active() and run.level() == 1, "the offer fixture did not open: %s" % _snapshot(run))
	return run


## One fresh mote of the test value attempted into one fresh baseline run.
func _fresh_attempt(player: Vector3, place: Vector3) -> RiftMoteCollectionResult:
	return RiftMoteCollectionAttempt.attempt(
		player, place, RiftExperienceMote.new(TEST_MOTE), RiftRunLevelCoordinator.new(MAGNETISM_SEED))


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


func _mote(mote: RiftExperienceMote) -> String:
	return "base=%s collected=%s" % [_exact(mote.base_experience()), str(mote.is_collected())]


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
## rendering the accepted H1, H2 and G4 pins use.
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
