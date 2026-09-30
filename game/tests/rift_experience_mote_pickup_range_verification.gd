extends SceneTree
## Riftwrought — Roguelite Foundation H2 verification: planar Experience Mote
## pickup range.
##
## ONE FOCUSED HEADLESS TEST. Foundation H2 is two pure-logic scripts under
## `scripts/pickups/` — a stateless query that answers whether a world position is
## within the player's effective Experience Mote Pickup Radius, and the reading it
## answers with. It runs as a `SceneTree` script exactly as every earlier
## foundation suite does.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching its
## LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## THE BOUNDARY IS DRIVEN WITH NO TOLERANCE AT ALL. This engine stores a world
## position's components in single precision, so between 2 m and 4 m the positions
## it can express are exactly 2^-22 m apart. The suite measures that spacing, then
## puts motes exactly ON the boundary and exactly ONE SPACING either side of it, and
## compares with `==`. An exclusive comparison refuses every on-boundary mote here,
## and a comparison with even a micrometre of slack admits every just-outside one —
## the suite shows both, so it cannot be passed by either.
##
## THE +25% IS A DIRECTLY CONSTRUCTED ACCUMULATOR CONTRIBUTION. The shipped card
## that grants it belongs to Foundation C2, which owns its record and magnitude;
## this suite names no card.
##
## THE HARNESS NEVER CALCULATES THE RADIUS IT CHECKS. Every expected radius is
## either an independently typed literal or the accepted stat calculation's own
## answer, asked directly — never a percentage this file applied itself.
##
## IT READS NO OTHER SUITE. It names no file under `tests/` but its own, which the
## runner asserts.

# --- The files ----------------------------------------------------------------------

const QUERY_FILE: String = "res://scripts/pickups/rift_mote_pickup_query.gd"
const READING_FILE: String = "res://scripts/pickups/rift_mote_pickup_reading.gd"
const THIS_FILE: String = "res://tests/rift_experience_mote_pickup_range_verification.gd"

## H2's own two files: the only files that may name the query or its reading
## without a grant below.
const PICKUP_SCRIPTS: Array[String] = [QUERY_FILE, READING_FILE]

## `scripts/pickups/` since D-275: H2's two scripts and Foundation H3's two — and
## since D-277 Foundation H4's drop, and since D-279 Foundation H5's field and its
## sweep result — and nothing else. KEPT SEPARATE from `PICKUP_SCRIPTS` on purpose —
## widening that list instead would have exempted H3's, H4's and H5's files from
## every scan below as a side effect of sharing the directory.
const PICKUP_DIRECTORY_SCRIPTS: Array[String] = [
	"res://scripts/pickups/rift_mote_collection_attempt.gd",
	"res://scripts/pickups/rift_mote_collection_result.gd",
	"res://scripts/pickups/rift_mote_drop.gd",
	"res://scripts/pickups/rift_mote_field.gd",
	QUERY_FILE,
	READING_FILE,
	"res://scripts/pickups/rift_mote_sweep_result.gd",
]

const QUERY_CLASS: String = "RiftMotePickupQuery"
const READING_CLASS: String = "RiftMotePickupReading"

## Foundation H1's mote, and the three tokens that would mean something names or
## collects one. Typed here independently; H1's own suite is not read.
const MOTE_FILE: String = "res://scripts/experience/rift_experience_mote.gd"
const MOTE_TOKENS: Array[String] = ["RiftExperienceMote", "rift_experience_mote", "collect_into("]

## THE ONLY FILES OUTSIDE THEIR OWNERS THAT MAY NAME THE QUERY, ITS READING OR THE
## MOTE, OR CALL A COLLECTION, PER FILE AND PER TOKEN. D-275: Foundation H3's
## collection attempt asks the query one question, reads the reading it answers
## with, and — only when the mote is within range — asks the mote to collect
## itself; it is granted exactly those four tokens, and never the mote's file name.
## Its result names none of them and is listed nowhere here. Nothing that runs
## calls the attempt. This replaces the blanket "no other file" one for one: the
## same single assertion is made either way, and the pinned count does not move.
## D-277: Foundation H4's drop makes and holds one mote and hands it to the
## attempt; it asks neither the query nor the mote to collect, so it is granted the
## mote's class alone. Nothing that runs creates a drop.
## D-281: Foundation H6's enemy mote emission makes a temporary mote only to ask that
## mote's own problem; it asks neither the query nor a mote to collect, so it is
## granted the mote's class alone. Nothing that runs creates an emission.
const AUTHORIZED_READERS: Array = [
	["res://scripts/pickups/rift_mote_collection_attempt.gd",
		["RiftMotePickupQuery", "RiftMotePickupReading", "RiftExperienceMote", "collect_into("]],
	["res://scripts/pickups/rift_mote_drop.gd", ["RiftExperienceMote"]],
	["res://scripts/experience/rift_enemy_mote_emission.gd", ["RiftExperienceMote"]],
]

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]
const PROJECT_SETTINGS_FILE: String = "res://project.godot"

## THE ONLY PROJECT CLASSES EACH FILE MAY NAME, checked against the engine's own
## global class list in both directions. The query names itself, its reading, and
## the three accepted stat classes it asks — the vocabulary for the stat id, the
## accumulator it is handed, and the value it is answered with. The reading names
## itself and nothing else: it holds no reference to any stat class at all.
const QUERY_NAMES: Array[String] = [
	"PlayerStatTotals", "PlayerStatValue", "PlayerStats",
	"RiftMotePickupQuery", "RiftMotePickupReading",
]
const READING_NAMES: Array[String] = ["RiftMotePickupReading"]

const EXPECTED_QUERY_SIGNATURES: Array[String] = [
	"evaluate(player_position: Vector3, mote_position: Vector3, totals: Object) -> Object",
]

const EXPECTED_READING_SIGNATURES: Array[String] = [
	"refused(for_player_position: Vector3, for_mote_position: Vector3, reason: String) -> Object",
	"measured(for_player_position: Vector3, for_mote_position: Vector3, for_base_radius: float, for_effective_radius: float, for_planar_distance: float, for_in_range: bool) -> Object",
	"problem() -> String",
	"describe() -> String",
	"_shown(value: float) -> String",
]

## THE READING'S WHOLE STATE, IN ORDER: the flag, the reason, the question, and the
## measurement. No object reference of any kind.
const EXPECTED_READING_FIELDS: Array[String] = [
	"ok", "failure_reason", "player_position", "mote_position",
	"base_radius", "effective_radius", "planar_distance", "in_range",
]

## Other foundations, content, actors, scenes and the run. Scanned RAW, comments
## included — D-215's lesson.
const FORBIDDEN_TOKENS: Array[String] = [
	"RiftExperienceMote", "rift_experience_mote", "collect_into", "award_experience",
	"RiftRunLevelCoordinator", "RiftRunLevelUpResult", "RiftRunBuild", "stat_totals",
	"RiftLevelUp", "RiftExperienceTrack", "RiftExperienceReading", "RiftOffer",
	"PassiveCard", "card_", "Magnetism", "magnetism", "interaction_range",
	"PrototypePlayer", "CalibrationHallPlayer", "RogueliteCoreLoop", "BrokenWatch",
	"Graveblade", "graveblade", "Skeleton", "enemy", "quick_strike", ".tscn", "scenes/",
]

## A pure query reads no ambient state and asks no physics, collision, navigation
## or scene question. Scanned raw.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
	"preload(", "load(", "get_tree", "get_node", "Node3D", "Area3D", "CollisionShape",
	"PhysicsServer", "NavigationServer", "NavigationAgent", "distance_to",
	"distance_squared_to", "length(", "length_squared", "global_position", "Transform3D",
]

## What the query must not do to a percentage, as tokens over CODE lines only: no
## second sum, no application, no scale, no cap, no floor, no curve.
const RESTATEMENT_TOKENS: Array[String] = [
	"total_for", "contributions_for", "apply", "scale", "1.0 +", "clamp", "minf", "maxf",
	"min(", "max(", "pow(", "log(", "exp(",
]

# --- The fixtures, stated independently -----------------------------------------------

## The greybox base the brief fixes, typed here rather than read from the query.
const BASE_RADIUS: float = 2.5

## The +25% magnitude, normalized, and the radius the brief states it produces.
const PLUS_25_PERCENT: float = 0.25
const RADIUS_AT_PLUS_25: float = 3.125

## The spacing of this engine's world-position components between 2 m and 4 m:
## 2^-22 m, measured below before anything relies on it.
const SPACING_2_TO_4: float = 1.0 / 4194304.0

## A slack no boundary test here may be passable with: one micrometre.
const SLACK: float = 1.0e-6

## +25% applied twice as a compounding modifier would give this; additively it is
## 3.75. Typed, never computed.
const COMPOUNDED_TWICE: float = 3.90625

const ORIGIN: Vector3 = Vector3.ZERO

const AXES: Array[Vector3] = [
	Vector3(1.0, 0.0, 0.0), Vector3(-1.0, 0.0, 0.0),
	Vector3(0.0, 0.0, 1.0), Vector3(0.0, 0.0, -1.0),
]

## Every ordering of the same three modifiers — chosen because, summed naively in
## insertion order, they do NOT all give the same radius (measured below), so one
## answer across all six is something the accumulator earns rather than a
## coincidence of these numbers.
const PERMUTATIONS: Array = [
	[0.1, 0.3, 0.7], [0.1, 0.7, 0.3], [0.3, 0.1, 0.7],
	[0.3, 0.7, 0.1], [0.7, 0.1, 0.3], [0.7, 0.3, 0.1],
]

## +110% on the 2.5 m base, typed: the radius all six orderings must give.
const RADIUS_AT_PLUS_110: float = 5.25

const OWED_CHECKS: Array[String] = [
	"with_no_modifier_the_radius_is_the_accepted_calculation_from_the_base",
	"plus_25_percent_follows_the_accepted_path_to_3_125",
	"the_inclusive_boundary_is_driven_from_both_sides",
	"distance_is_planar_and_height_is_ignored",
	"swapping_and_translating_preserve_distance_and_verdict",
	"every_non_finite_component_and_missing_totals_refuse_with_nothing_measured",
	"an_invalid_totals_calculation_refuses_without_inventing_a_radius",
	"repeated_and_reordered_contributions_give_one_answer_through_the_accumulator",
	"the_query_holds_nothing_and_retains_nothing_between_calls",
	"the_query_restates_nothing_and_names_only_what_it_reads",
	"h1_stays_unwired_and_nothing_that_runs_calls_the_query",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0
var _measurements: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation H2 — Planar Experience Mote Pickup Range (D-273) ===")

	_check_no_modifier()
	_check_plus_25_percent()
	_check_the_inclusive_boundary()
	_check_planar_distance()
	_check_swap_and_translation()
	_check_non_finite_and_missing_totals()
	_check_an_invalid_calculation()
	_check_repeated_and_reordered_contributions()
	_check_statelessness()
	_check_the_shape()
	_check_nothing_runs_it()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT EXPERIENCE MOTE PICKUP RANGE VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT EXPERIENCE MOTE PICKUP RANGE VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. No modifier ---------------------------------------------------------------------

func _check_no_modifier() -> void:
	print("")
	print("--- 1. With no modifier, the radius is the accepted calculation from the 2.5 m base")
	_expect(RiftMotePickupQuery.BASE_PICKUP_RADIUS == BASE_RADIUS,
		"the query's base is %s, not the specified %s" % [
			_exact(RiftMotePickupQuery.BASE_PICKUP_RADIUS), _exact(BASE_RADIUS)])

	var totals: PlayerStatTotals = PlayerStatTotals.new()
	var accepted: PlayerStatValue = totals.value_of(PlayerStats.PICKUP_RADIUS, BASE_RADIUS)
	_expect(accepted.ok and accepted.problem().is_empty(),
		"the accepted calculation refused the unmodified base: %s" % accepted.failure_reason)
	var reading: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, Vector3(1.0, 0.0, 0.0), totals)
	_expect_measured(reading, "an unmodified query")
	_expect(reading.base_radius == BASE_RADIUS, "the reading carries a base of %s" % _exact(reading.base_radius))
	_expect(reading.effective_radius == accepted.value,
		"the effective radius %s is not the accepted calculation's own %s" % [
			_exact(reading.effective_radius), _exact(accepted.value)])
	_expect(reading.effective_radius == BASE_RADIUS,
		"with no modifier the effective radius is %s, not %s" % [
			_exact(reading.effective_radius), _exact(BASE_RADIUS)])

	## ONLY PICKUP RADIUS REACHES IT. Large modifiers to three other stats leave the
	## radius exactly where it was.
	var others: PlayerStatTotals = _totals([
		[PlayerStats.GLOBAL_DAMAGE, 1.0],
		[PlayerStats.EXPERIENCE_GAIN, 0.10],
		[PlayerStats.MOVEMENT_SPEED, 0.50],
	])
	var unmoved: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, Vector3(1.0, 0.0, 0.0), others)
	_expect_measured(unmoved, "a query holding only other stats' modifiers")
	_expect(unmoved.effective_radius == BASE_RADIUS,
		"modifiers to other stats moved the radius to %s" % _exact(unmoved.effective_radius))

	print("  baseline: effective radius %s m from base %s m, equal to the accepted calculation's own answer; modifiers to 3 other stats leave it at %s m"
		% [_exact(reading.effective_radius), _exact(reading.base_radius), _exact(unmoved.effective_radius)])
	_done("with_no_modifier_the_radius_is_the_accepted_calculation_from_the_base")


# --- 2. +25% -------------------------------------------------------------------------------

func _check_plus_25_percent() -> void:
	print("")
	print("--- 2. +25% Pickup Radius follows the accepted path to 3.125 m")
	var totals: PlayerStatTotals = _plus_25()
	var accepted: PlayerStatValue = totals.value_of(PlayerStats.PICKUP_RADIUS, BASE_RADIUS)
	_expect(accepted.ok and accepted.problem().is_empty(),
		"the accepted calculation refused +25%%: %s" % accepted.failure_reason)
	var reading: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, Vector3(1.0, 0.0, 0.0), totals)
	_expect_measured(reading, "a +25% query")
	_expect(reading.base_radius == BASE_RADIUS, "the reading carries a base of %s" % _exact(reading.base_radius))
	_expect(reading.effective_radius == accepted.value,
		"the effective radius %s is not the accepted calculation's own %s" % [
			_exact(reading.effective_radius), _exact(accepted.value)])
	_expect(reading.effective_radius == RADIUS_AT_PLUS_25,
		"+25%% gives %s, not %s" % [_exact(reading.effective_radius), _exact(RADIUS_AT_PLUS_25)])
	print("  +25%% Pickup Radius: effective radius %s m from base %s m, equal to the accepted calculation's own answer (scale %s)"
		% [_exact(reading.effective_radius), _exact(reading.base_radius), _exact(accepted.scale)])
	_done("plus_25_percent_follows_the_accepted_path_to_3_125")


# --- 3. The inclusive boundary --------------------------------------------------------------

func _check_the_inclusive_boundary() -> void:
	print("")
	print("--- 3. The boundary is inclusive, driven exactly on it and one position either side")

	## THE SPACING IS MEASURED, NOT ASSUMED. One spacing above 2.5 m and 3.125 m is
	## a position the engine can hold exactly; half a spacing is not, and falls back
	## onto the boundary — so one spacing really is "immediately" outside.
	_expect(Vector3(BASE_RADIUS + SPACING_2_TO_4, 0.0, 0.0).x == BASE_RADIUS + SPACING_2_TO_4
			and Vector3(BASE_RADIUS - SPACING_2_TO_4, 0.0, 0.0).x == BASE_RADIUS - SPACING_2_TO_4
			and Vector3(BASE_RADIUS + SPACING_2_TO_4 / 2.0, 0.0, 0.0).x == BASE_RADIUS
			and Vector3(RADIUS_AT_PLUS_25 + SPACING_2_TO_4, 0.0, 0.0).x == RADIUS_AT_PLUS_25 + SPACING_2_TO_4
			and Vector3(RADIUS_AT_PLUS_25 + SPACING_2_TO_4 / 2.0, 0.0, 0.0).x == RADIUS_AT_PLUS_25,
		"the engine's position spacing near the boundary is not 2^-22 m")

	var on_boundary: int = 0
	var just_outside: int = 0
	var just_inside: int = 0
	var worst_excess: float = 0.0
	## What the two wrong implementations would have answered on these very
	## readings: an exclusive `<` on each on-boundary mote, and `<=` with a
	## micrometre of slack on each just-outside one.
	var exclusive_refuses: int = 0
	var slack_admits: int = 0
	## Each case carries its 3-4-5 diagonal, typed: (1.5, 2.0) lies exactly 2.5 m
	## out and (1.875, 2.5) exactly 3.125 m.
	for case: Array in [
		[PlayerStatTotals.new(), BASE_RADIUS, "baseline", 1.5, 2.0],
		[_plus_25(), RADIUS_AT_PLUS_25, "+25%", 1.875, 2.5],
	]:
		var totals: PlayerStatTotals = case[0]
		var radius: float = case[1]
		var label: String = case[2]
		var across: float = case[3]
		var along: float = case[4]
		var points: Array = []
		for axis: Vector3 in AXES:
			points.append([axis * radius, axis * (radius + SPACING_2_TO_4), axis * (radius - SPACING_2_TO_4),
				"%s axis %s" % [label, axis]])
		points.append([Vector3(across, 0.0, along), Vector3(across, 0.0, along + SPACING_2_TO_4),
			Vector3(across, 0.0, along - SPACING_2_TO_4), "%s diagonal" % label])
		for point: Array in points:
			var described: String = String(point[3])
			var on: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, point[0], totals)
			_expect_measured(on, "%s on the boundary" % described)
			_expect(on.effective_radius == radius and on.planar_distance == radius and on.in_range,
				"%s: a mote exactly on the boundary reads %s" % [described, on.describe()])
			if not (on.planar_distance < on.effective_radius):
				exclusive_refuses += 1
			on_boundary += 1
			var out: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, point[1], totals)
			_expect_measured(out, "%s just outside" % described)
			var excess: float = out.planar_distance - out.effective_radius
			_expect(not out.in_range and excess > 0.0 and excess <= SPACING_2_TO_4 and excess < SLACK,
				"%s: a mote one position outside reads %s" % [described, out.describe()])
			if out.planar_distance <= out.effective_radius + SLACK:
				slack_admits += 1
			worst_excess = maxf(worst_excess, excess)
			just_outside += 1
			var inside: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, point[2], totals)
			_expect_measured(inside, "%s just inside" % described)
			_expect(inside.in_range and inside.planar_distance < radius,
				"%s: a mote one position inside reads %s" % [described, inside.describe()])
			just_inside += 1

	## THE 3.0 m MOTE: out at the base, in at +25%.
	var three_base: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, Vector3(3.0, 0.0, 0.0), PlayerStatTotals.new())
	var three_25: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, Vector3(3.0, 0.0, 0.0), _plus_25())
	_expect_measured(three_base, "the 3.0 m mote at baseline")
	_expect_measured(three_25, "the 3.0 m mote at +25%")
	_expect(three_base.planar_distance == 3.0 and not three_base.in_range,
		"the 3.0 m mote at baseline reads %s" % three_base.describe())
	_expect(three_25.planar_distance == 3.0 and three_25.in_range,
		"the 3.0 m mote at +25%% reads %s" % three_25.describe())

	## WHAT THOSE TWO PROPERTIES RULE OUT: an exclusive comparison refuses every
	## on-boundary mote, and a micrometre of slack admits every just-outside one, so
	## neither could pass this check.
	_expect(on_boundary == 10 and exclusive_refuses == on_boundary,
		"an exclusive comparison would refuse %d of %d on-boundary motes" % [exclusive_refuses, on_boundary])
	_expect(just_outside == 10 and slack_admits == just_outside,
		"a %s m slack would admit %d of %d just-outside motes" % [_exact(SLACK), slack_admits, just_outside])
	print("  baseline boundary: %s m in range, %s m out, %s m in, on 4 axes and a 3-4-5 diagonal"
		% [_exact(BASE_RADIUS), _exact(BASE_RADIUS + SPACING_2_TO_4), _exact(BASE_RADIUS - SPACING_2_TO_4)])
	print("  +25%% boundary: %s m in range, %s m out, %s m in, on 4 axes and a 3-4-5 diagonal"
		% [_exact(RADIUS_AT_PLUS_25), _exact(RADIUS_AT_PLUS_25 + SPACING_2_TO_4),
			_exact(RADIUS_AT_PLUS_25 - SPACING_2_TO_4)])
	print("  a %s m mote: %s at baseline, %s at +25%%" % [
		_exact(three_base.planar_distance), _verdict(three_base), _verdict(three_25)])
	print("  %d on-boundary readings carry distance == radius exactly (an exclusive < refuses all %d); %d just-outside readings exceed it by at most %s m (a %s m slack admits all %d); %d just-inside in range"
		% [on_boundary, exclusive_refuses, just_outside, _exact(worst_excess),
			_exact(SLACK), slack_admits, just_inside])
	_done("the_inclusive_boundary_is_driven_from_both_sides")


# --- 4. Planar distance ------------------------------------------------------------------------

func _check_planar_distance() -> void:
	print("")
	print("--- 4. Distance is measured on the X/Z plane and height is ignored")
	var baseline: PlayerStatTotals = PlayerStatTotals.new()

	## X/Z DIAGONALS against independently typed answers.
	var diagonals: Array = [
		[ORIGIN, Vector3(1.5, 0.0, 2.0), 2.5],
		[ORIGIN, Vector3(-1.5, 0.0, -2.0), 2.5],
		[ORIGIN, Vector3(3.0, 0.0, 4.0), 5.0],
		[Vector3(10.0, 0.0, -4.0), Vector3(13.0, 0.0, 0.0), 5.0],
		[Vector3(-0.75, 0.0, 0.25), Vector3(1.125, 0.0, 2.75), 3.125],
	]
	var measured_diagonals: PackedStringArray = PackedStringArray()
	for diagonal: Array in diagonals:
		var from: Vector3 = diagonal[0]
		var to: Vector3 = diagonal[1]
		var reading: RiftMotePickupReading = RiftMotePickupQuery.evaluate(from, to, baseline)
		_expect_measured(reading, "the diagonal %s -> %s" % [from, to])
		_expect(reading.planar_distance == float(diagonal[2]),
			"%s -> %s measured %s, not %s" % [from, to,
				_exact(reading.planar_distance), _exact(float(diagonal[2]))])
		measured_diagonals.append("(%s, %s) -> %s m" % [
			_exact(to.x - from.x), _exact(to.z - from.z), _exact(reading.planar_distance)])

	## HEIGHT, INCLUDING THE LARGEST HEIGHT A POSITION CAN HOLD. The same X/Z pair on
	## the boundary and one position outside it, at fifteen combinations of player
	## and mote height, must give one distance and one verdict each.
	var largest: float = _largest_position_component()
	_expect(is_finite(largest) and Vector3(0.0, largest, 0.0).y == largest,
		"the largest position component %s did not survive storage" % _exact(largest))
	var on_plane: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, Vector3(1.5, 0.0, 2.0), baseline)
	var out_plane: RiftMotePickupReading = RiftMotePickupQuery.evaluate(
		ORIGIN, Vector3(1.5, 0.0, 2.0 + SPACING_2_TO_4), baseline)
	_expect_measured(on_plane, "the level boundary mote")
	_expect_measured(out_plane, "the level just-outside mote")
	var height_pairs: int = 0
	for player_height: float in [0.0, largest, -12.5]:
		for mote_height: float in [0.0, 1.75, -1000.0, 3.0e38, -largest]:
			var on: RiftMotePickupReading = RiftMotePickupQuery.evaluate(
				Vector3(0.0, player_height, 0.0), Vector3(1.5, mote_height, 2.0), baseline)
			var out: RiftMotePickupReading = RiftMotePickupQuery.evaluate(
				Vector3(0.0, player_height, 0.0), Vector3(1.5, mote_height, 2.0 + SPACING_2_TO_4), baseline)
			_expect_measured(on, "the boundary mote at heights %s / %s" % [_exact(player_height), _exact(mote_height)])
			_expect_measured(out, "the outside mote at heights %s / %s" % [_exact(player_height), _exact(mote_height)])
			_expect(on.planar_distance == on_plane.planar_distance and on.in_range == on_plane.in_range
					and out.planar_distance == out_plane.planar_distance and out.in_range == out_plane.in_range,
				"heights %s / %s changed the answer: %s | %s" % [
					_exact(player_height), _exact(mote_height), on.describe(), out.describe()])
			height_pairs += 1

	## WHAT A 3D DISTANCE WOULD HAVE SAID about the boundary mote 1.75 m up.
	var raised: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, Vector3(1.5, 1.75, 2.0), baseline)
	var euclidean: float = sqrt(1.5 * 1.5 + 1.75 * 1.75 + 2.0 * 2.0)
	_expect(raised.in_range and euclidean > BASE_RADIUS,
		"the raised boundary mote reads %s against a 3D distance of %s" % [raised.describe(), _exact(euclidean)])

	## AN IGNORED HEIGHT STILL HAS TO BE A NUMBER. A height beyond what a position can
	## hold is stored as infinity, and is refused like any other.
	var beyond: Vector3 = Vector3(1.5, 1.0e39, 2.0)
	var refused: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, beyond, baseline)
	_expect(is_inf(beyond.y), "a height of 1e39 was stored as %s" % _exact(beyond.y))
	_expect_refused(refused, "a mote 1e39 m up")
	_expect(refused.failure_reason.contains("mote position"),
		"the over-range height was refused as: %s" % refused.failure_reason)

	## THE LARGEST SEPARATION A PAIR OF POSITIONS CAN HOLD is still a finite distance,
	## which is why no success can ever carry the reading's infinite non-value.
	var farthest: RiftMotePickupReading = RiftMotePickupQuery.evaluate(
		Vector3(-largest, 0.0, -largest), Vector3(largest, 0.0, largest), baseline)
	_expect_measured(farthest, "the farthest pair")
	_expect(is_finite(farthest.planar_distance) and not farthest.in_range,
		"the farthest pair reads %s" % farthest.describe())

	print("  planar (x, z) separations: %s" % ", ".join(measured_diagonals))
	print("  height ignored across %d height pairs up to %s m: %s m %s and %s m %s every time; a 3D distance would put the 1.75 m-high boundary mote at %s m, out of range"
		% [height_pairs, _exact(largest), _exact(on_plane.planar_distance), _verdict(on_plane),
			_exact(out_plane.planar_distance), _verdict(out_plane), _exact(euclidean)])
	print("  a 1e39 m height is stored as %s and refused; the farthest expressible pair is %s m apart, %s"
		% [_exact(beyond.y), _exact(farthest.planar_distance), _verdict(farthest)])
	_done("distance_is_planar_and_height_is_ignored")


# --- 5. Swap and translation ------------------------------------------------------------------------

func _check_swap_and_translation() -> void:
	print("")
	print("--- 5. Swapping and translating the two positions preserve distance and verdict")
	var totals_cases: Array = [PlayerStatTotals.new(), _plus_25()]
	## Every component here is a multiple of 1/8 m, so each translation below lands
	## on a position the engine can hold exactly.
	var exact_pairs: Array = [
		[ORIGIN, Vector3(2.5, 0.0, 0.0)],
		[ORIGIN, Vector3(3.0, 0.0, 0.0)],
		[ORIGIN, Vector3(1.5, 0.5, 2.0)],
		[Vector3(10.0, 0.0, -4.0), Vector3(13.0, 1.0, 0.0)],
		[Vector3(-0.75, 2.0, 0.25), Vector3(1.125, -3.0, 2.75)],
	]
	## Swapped only: components with no exact binary form.
	var inexact_pairs: Array = [
		[Vector3(0.1, 0.7, -0.3), Vector3(2.2, 5.0, 1.3)],
		[Vector3(-7.3, 0.0, 4.1), Vector3(-5.9, 0.0, 6.2)],
	]
	var offsets: Array[Vector3] = [
		Vector3(1024.0, -37.5, -2048.0),
		Vector3(-1048576.0, 3.0e38, 1048576.0),
		Vector3(0.125, 0.0, -0.125),
	]

	var swapped: int = 0
	for pair: Array in exact_pairs + inexact_pairs:
		for totals: PlayerStatTotals in totals_cases:
			var forward: RiftMotePickupReading = RiftMotePickupQuery.evaluate(pair[0], pair[1], totals)
			var backward: RiftMotePickupReading = RiftMotePickupQuery.evaluate(pair[1], pair[0], totals)
			_expect_measured(forward, "%s -> %s" % [pair[0], pair[1]])
			_expect_measured(backward, "%s -> %s swapped" % [pair[0], pair[1]])
			_expect(backward.planar_distance == forward.planar_distance and backward.in_range == forward.in_range
					and backward.player_position == pair[1] and backward.mote_position == pair[0],
				"swapping %s and %s changed the answer: %s | %s" % [
					pair[0], pair[1], forward.describe(), backward.describe()])
			swapped += 1

	var translated: int = 0
	var inexact_translations: int = 0
	for pair: Array in exact_pairs:
		var from: Vector3 = pair[0]
		var to: Vector3 = pair[1]
		for offset: Vector3 in offsets:
			var player: Vector3 = from + offset
			var mote: Vector3 = to + offset
			## The ground-plane components must have landed exactly, or this would be
			## a test of the position type's rounding rather than of the query.
			if player.x - offset.x != from.x or player.z - offset.z != from.z \
					or mote.x - offset.x != to.x or mote.z - offset.z != to.z:
				inexact_translations += 1
				continue
			for totals: PlayerStatTotals in totals_cases:
				var original: RiftMotePickupReading = RiftMotePickupQuery.evaluate(from, to, totals)
				var moved: RiftMotePickupReading = RiftMotePickupQuery.evaluate(player, mote, totals)
				_expect_measured(moved, "%s -> %s moved by %s" % [from, to, offset])
				_expect(moved.planar_distance == original.planar_distance and moved.in_range == original.in_range,
					"moving %s -> %s by %s changed the answer: %s | %s" % [
						from, to, offset, original.describe(), moved.describe()])
				translated += 1
	_expect(inexact_translations == 0,
		"%d translations did not land exactly on the ground plane" % inexact_translations)
	_expect(translated == exact_pairs.size() * offsets.size() * totals_cases.size(),
		"%d translated comparisons were made" % translated)

	## THE HONEST LIMIT. A translation that does NOT land exactly is not the same
	## question: 1024 m out, positions are 2^-13 m apart, so the just-outside mote is
	## stored exactly on the boundary — the position type moved it, not the query.
	var far_player: Vector3 = Vector3(1024.0, 0.0, 0.0)
	var far_mote: Vector3 = Vector3(BASE_RADIUS + SPACING_2_TO_4, 0.0, 0.0) + far_player
	var far: RiftMotePickupReading = RiftMotePickupQuery.evaluate(far_player, far_mote, PlayerStatTotals.new())
	_expect_measured(far, "the just-outside mote moved 1024 m")
	_expect(far_mote.x == 1026.5 and far.planar_distance == BASE_RADIUS and far.in_range,
		"the just-outside mote moved 1024 m is stored at %s and reads %s" % [_exact(far_mote.x), far.describe()])

	print("  swap: %d pairs x 2 radii, each distance bit-identical and each verdict unchanged" % (swapped / 2))
	print("  translation by 3 offsets up to 1048576 m (and a 3e+38 m height): %d comparisons, each distance bit-identical and each verdict unchanged"
		% translated)
	print("  limit: translating the %s m mote by 1024 m stores it at %s m (spacing 2^-13 m there), exactly on the boundary and in range"
		% [_exact(BASE_RADIUS + SPACING_2_TO_4), _exact(far_mote.x)])
	_done("swapping_and_translating_preserve_distance_and_verdict")


# --- 6. Non-finite components and missing totals -------------------------------------------------------

func _check_non_finite_and_missing_totals() -> void:
	print("")
	print("--- 6. Every non-finite component and missing totals refuse, with nothing measured")
	_expect(RiftMotePickupReading.NO_RADIUS == 0.0,
		"the radius non-value is %s" % _exact(RiftMotePickupReading.NO_RADIUS))
	_expect(is_inf(RiftMotePickupReading.NO_DISTANCE) and RiftMotePickupReading.NO_DISTANCE > 0.0,
		"the distance non-value is %s" % _exact(RiftMotePickupReading.NO_DISTANCE))

	var totals: PlayerStatTotals = _plus_25()
	var good_player: Vector3 = Vector3(0.5, 0.25, -0.5)
	var good_mote: Vector3 = Vector3(1.5, 0.25, 2.0)
	var component_refusals: int = 0
	for which: String in ["player", "mote"]:
		for component: int in 3:
			for bad: float in [NAN, INF, -INF]:
				var player: Vector3 = good_player
				var mote: Vector3 = good_mote
				if which == "player":
					player[component] = bad
				else:
					mote[component] = bad
				var described: String = "a %s position with component %d = %s" % [which, component, bad]
				var reading: RiftMotePickupReading = RiftMotePickupQuery.evaluate(player, mote, totals)
				_expect_refused(reading, described)
				_expect(reading.failure_reason.contains("%s position" % which)
						and reading.failure_reason.contains("finite"),
					"%s was refused as: %s" % [described, reading.failure_reason])
				_expect(str(reading.player_position) == str(player) and str(reading.mote_position) == str(mote),
					"%s did not keep the question: %s / %s" % [described, reading.player_position, reading.mote_position])
				component_refusals += 1

	var missing: RiftMotePickupReading = RiftMotePickupQuery.evaluate(good_player, good_mote, null)
	_expect_refused(missing, "missing totals")
	_expect(missing.failure_reason.contains("stat totals"), "missing totals were refused as: %s" % missing.failure_reason)
	_expect(missing.player_position == good_player and missing.mote_position == good_mote,
		"missing totals did not keep the question")

	## THE ORDER: player, then mote, then totals.
	var bad_player: Vector3 = Vector3(NAN, 0.0, 0.0)
	var bad_mote: Vector3 = Vector3(0.0, 0.0, INF)
	var first: RiftMotePickupReading = RiftMotePickupQuery.evaluate(bad_player, bad_mote, null)
	var second: RiftMotePickupReading = RiftMotePickupQuery.evaluate(good_player, bad_mote, null)
	_expect_refused(first, "everything wrong at once")
	_expect_refused(second, "a bad mote and missing totals")
	_expect(first.failure_reason.contains("player position") and second.failure_reason.contains("mote position"),
		"the refusal order is wrong: '%s' then '%s'" % [first.failure_reason, second.failure_reason])

	## THE READING'S OWN GUARD CATCHES A PARTIAL MEASUREMENT. Each tampered value
	## below is built with the reading's own constructors and then altered.
	var tampered: int = 0
	var carrying_distance: RiftMotePickupReading = RiftMotePickupReading.refused(ORIGIN, ORIGIN, "tampered")
	carrying_distance.planar_distance = 0.0
	var carrying_radius: RiftMotePickupReading = RiftMotePickupReading.refused(ORIGIN, ORIGIN, "tampered")
	carrying_radius.effective_radius = BASE_RADIUS
	var carrying_verdict: RiftMotePickupReading = RiftMotePickupReading.refused(ORIGIN, ORIGIN, "tampered")
	carrying_verdict.in_range = true
	var lying_verdict: RiftMotePickupReading = RiftMotePickupReading.measured(
		ORIGIN, Vector3(3.0, 0.0, 0.0), BASE_RADIUS, BASE_RADIUS, 3.0, true)
	var no_radius: RiftMotePickupReading = RiftMotePickupReading.measured(
		ORIGIN, ORIGIN, BASE_RADIUS, 0.0, 0.0, true)
	var infinite_distance: RiftMotePickupReading = RiftMotePickupReading.measured(
		ORIGIN, ORIGIN, BASE_RADIUS, BASE_RADIUS, INF, false)
	for bad_reading: RiftMotePickupReading in [
		carrying_distance, carrying_radius, carrying_verdict, lying_verdict, no_radius, infinite_distance,
	]:
		_expect(not bad_reading.problem().is_empty(),
			"the reading's guard accepted a tampered value: %s" % bad_reading.describe())
		tampered += 1
	var unstated: RiftMotePickupReading = RiftMotePickupReading.refused(ORIGIN, ORIGIN, "  ")
	_expect(not unstated.failure_reason.strip_edges().is_empty() and unstated.problem().is_empty(),
		"a blank refusal reason was kept as: '%s'" % unstated.failure_reason)

	print("  %d non-finite components (NaN, +inf, -inf in x, y and z of either position) and missing totals: each refused with radius %s, distance %s, in range %s, the question kept"
		% [component_refusals, _exact(missing.effective_radius), _exact(missing.planar_distance), str(missing.in_range)])
	print("  order: player before mote before totals; %d tampered readings caught by the reading's own guard" % tampered)
	_done("every_non_finite_component_and_missing_totals_refuse_with_nothing_measured")


# --- 7. An invalid calculation -----------------------------------------------------------------------------

func _check_an_invalid_calculation() -> void:
	print("")
	print("--- 7. A stat calculation the accepted path refuses is refused, and no radius is invented")
	## LAWFUL AT THE ACCUMULATOR, REFUSED BY THE CALCULATION. +1e308 is a finite
	## modifier the accumulator records; applied to the 2.5 m base it is not a
	## finite radius, and the accepted path says so.
	var totals: PlayerStatTotals = PlayerStatTotals.new()
	var added: String = totals.add(PlayerStats.PICKUP_RADIUS, 1.0e308)
	_expect(added.is_empty(), "the accumulator refused +1e308: %s" % added)
	var direct: PlayerStatValue = totals.value_of(PlayerStats.PICKUP_RADIUS, BASE_RADIUS)
	_expect(not direct.ok and not direct.failure_reason.is_empty(),
		"the accepted calculation accepted +1e308 as %s" % direct.describe())

	## A MOTE AT THE PLAYER'S OWN POSITION is in range under every positive radius
	## there is — so a query that substituted any radius at all would say "in range"
	## here. It must not.
	var reading: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, ORIGIN, totals)
	_expect_refused(reading, "a mote at the player's feet under +1e308")
	_expect(reading.failure_reason == "the effective Pickup Radius could not be calculated: %s" % direct.failure_reason,
		"the refusal does not quote the accepted calculation verbatim: %s" % reading.failure_reason)
	var again: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, Vector3(0.5, 0.0, 0.0), totals)
	_expect_refused(again, "a second mote under +1e308")

	## AND NOTHING CARRIES OVER: the same question with valid totals is answered.
	var after: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, ORIGIN, PlayerStatTotals.new())
	_expect_measured(after, "the same question with valid totals")
	_expect(after.in_range and after.planar_distance == 0.0 and after.effective_radius == BASE_RADIUS,
		"the same question with valid totals reads %s" % after.describe())

	print("  +1e308: the accumulator %s it; the query refused ('%s…'), quoting the accepted calculation verbatim; the mote at the player's own position in range: %s"
		% ["accepted" if added.is_empty() else "refused", reading.failure_reason.left(95), str(reading.in_range)])
	_done("an_invalid_totals_calculation_refuses_without_inventing_a_radius")


# --- 8. Repeated and reordered contributions --------------------------------------------------------------------

func _check_repeated_and_reordered_contributions() -> void:
	print("")
	print("--- 8. Repeated and reordered contributions give one answer, through the accumulator")
	var probe: Vector3 = Vector3(4.0, 0.0, 0.0)

	## A MOTE EXACTLY ON THE +110% BOUNDARY, 5.25 m out, in every ordering.
	var boundary: Vector3 = Vector3(RADIUS_AT_PLUS_110, 0.0, 0.0)
	var first_radius: float = NAN
	var disagreeing: int = 0
	var out_of_range: int = 0
	var naive_radii: Dictionary = {}
	for ordering: Array in PERMUTATIONS:
		var contributions: Array = []
		for modifier: float in ordering:
			contributions.append([PlayerStats.PICKUP_RADIUS, modifier])
		var totals: PlayerStatTotals = _totals(contributions)
		var reading: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, boundary, totals)
		_expect_measured(reading, "the ordering %s" % str(ordering))
		_expect(reading.effective_radius == totals.value_of(PlayerStats.PICKUP_RADIUS, BASE_RADIUS).value,
			"the ordering %s is not the accepted calculation's own answer" % str(ordering))
		if is_nan(first_radius):
			first_radius = reading.effective_radius
		elif reading.effective_radius != first_radius:
			disagreeing += 1
		if not reading.in_range:
			out_of_range += 1
		## THE COUNTERFACTUAL: the same three modifiers summed in insertion order —
		## which is what a query that added them up itself would do — applied through
		## the accepted calculation, so the harness still applies no percentage.
		var naive_total: float = (float(ordering[0]) + float(ordering[1])) + float(ordering[2])
		naive_radii[PlayerStats.apply(PlayerStats.PICKUP_RADIUS, BASE_RADIUS, naive_total).value] = true
	_expect(disagreeing == 0 and first_radius == RADIUS_AT_PLUS_110,
		"%d of 6 orderings gave a different radius; the first gave %s" % [disagreeing, _exact(first_radius)])
	_expect(out_of_range == 0, "the 5.25 m boundary mote was out of range in %d of 6 orderings" % out_of_range)
	_expect(naive_radii.size() > 1,
		"summed naively the six orderings give one radius, so this check would prove nothing: %s" % str(naive_radii.keys()))
	var naive_shown: PackedStringArray = PackedStringArray()
	for naive: Variant in naive_radii:
		naive_shown.append(_exact(float(naive)))
	naive_shown.sort()

	## REPEATED, AND ADDITIVE: +25% twice is +50%, never 1.25 x 1.25. A mote at 3.8 m
	## sits between the two answers, so it tells them apart.
	var twice: PlayerStatTotals = _totals([[PlayerStats.PICKUP_RADIUS, PLUS_25_PERCENT], [PlayerStats.PICKUP_RADIUS, PLUS_25_PERCENT]])
	var between: Vector3 = Vector3(3.8, 0.0, 0.0)
	var twice_reading: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, between, twice)
	_expect_measured(twice_reading, "+25% twice")
	_expect(twice_reading.effective_radius == 3.75 and twice_reading.effective_radius != COMPOUNDED_TWICE,
		"+25%% twice gives %s" % _exact(twice_reading.effective_radius))
	_expect(between.x > 3.75 and between.x < COMPOUNDED_TWICE and not twice_reading.in_range,
		"the %s m mote reads %s" % [_exact(between.x), twice_reading.describe()])

	var thrice: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, probe,
		_totals([[PlayerStats.PICKUP_RADIUS, 0.25], [PlayerStats.PICKUP_RADIUS, 0.25], [PlayerStats.PICKUP_RADIUS, 0.25]]))
	var one_way: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, probe,
		_totals([[PlayerStats.PICKUP_RADIUS, 0.25], [PlayerStats.PICKUP_RADIUS, 0.5]]))
	var other_way: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, probe,
		_totals([[PlayerStats.PICKUP_RADIUS, 0.5], [PlayerStats.PICKUP_RADIUS, 0.25]]))
	_expect(thrice.effective_radius == 4.375 and one_way.effective_radius == 4.375
			and other_way.effective_radius == one_way.effective_radius,
		"+25%% three times, and +25%% with +50%% both ways, give %s, %s and %s" % [
			_exact(thrice.effective_radius), _exact(one_way.effective_radius), _exact(other_way.effective_radius)])

	## NO CAP AND NO DIMINISHING RETURN: large totals reach the radius in full, and a
	## mote exactly on each boundary is in range.
	var three_hundred: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, Vector3(6.0, 0.0, 8.0),
		_totals([[PlayerStats.PICKUP_RADIUS, 3.0]]))
	var thousandfold: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, Vector3(2502.5, 0.0, 0.0),
		_totals([[PlayerStats.PICKUP_RADIUS, 1000.0]]))
	_expect_measured(three_hundred, "+300%")
	_expect_measured(thousandfold, "+100000%")
	_expect(three_hundred.effective_radius == 10.0 and three_hundred.planar_distance == 10.0 and three_hundred.in_range,
		"+300%% reads %s" % three_hundred.describe())
	_expect(thousandfold.effective_radius == 2502.5 and thousandfold.planar_distance == 2502.5 and thousandfold.in_range,
		"+100000%% reads %s" % thousandfold.describe())

	print("  6 orderings of +0.1/+0.3/+0.7: one radius, %s m, each the accepted calculation's own answer, and the 5.25 m boundary mote in range in all 6 (summed naively they give %s m)"
		% [_exact(first_radius), " and ".join(naive_shown)])
	print("  +25%% twice: %s m (compounding would give %s m), so a %s m mote is out; +25%% three times, and +25%% with +50%% either way: %s m"
		% [_exact(twice_reading.effective_radius), _exact(COMPOUNDED_TWICE), _exact(between.x), _exact(thrice.effective_radius)])
	print("  no cap: +300%% -> %s m, +100000%% -> %s m, each boundary mote in range"
		% [_exact(three_hundred.effective_radius), _exact(thousandfold.effective_radius)])
	_done("repeated_and_reordered_contributions_give_one_answer_through_the_accumulator")


# --- 9. Stateless ---------------------------------------------------------------------------------------------------

func _check_statelessness() -> void:
	print("")
	print("--- 9. The query holds nothing, and retains nothing between calls")
	var script: GDScript = load(QUERY_FILE) as GDScript
	var instance_fields: PackedStringArray = _fields_of(RiftMotePickupQuery.new())
	_expect(instance_fields.is_empty(), "the query carries fields: %s" % ", ".join(instance_fields))
	## Static state as well as instance state: every script variable the script
	## itself declares.
	var script_properties: PackedStringArray = PackedStringArray()
	for entry: Dictionary in script.get_script_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			script_properties.append(String(entry.get("name", "")))
	_expect(script_properties.is_empty(), "the query declares script variables: %s" % ", ".join(script_properties))
	var constants: Dictionary = script.get_script_constant_map()
	_expect(constants.size() == 1 and constants.has("BASE_PICKUP_RADIUS")
			and float(constants["BASE_PICKUP_RADIUS"]) == BASE_RADIUS,
		"the query's constants are %s" % str(constants))
	var signatures: PackedStringArray = _signatures_of(QUERY_FILE)
	_expect(", ".join(signatures) == ", ".join(PackedStringArray(EXPECTED_QUERY_SIGNATURES)),
		"the query declares: %s" % ", ".join(signatures))

	## THE SAME QUESTION, A HUNDRED TIMES, AND BETWEEN OTHER QUESTIONS.
	var totals: PlayerStatTotals = _plus_25()
	var mote: Vector3 = Vector3(1.875, 0.25, 2.5)
	var first: String = _whole(RiftMotePickupQuery.evaluate(ORIGIN, mote, totals))
	var drifted: int = 0
	for _index: int in 100:
		if _whole(RiftMotePickupQuery.evaluate(ORIGIN, mote, totals)) != first:
			drifted += 1
	_expect(drifted == 0, "%d of 100 identical questions were answered differently" % drifted)
	var _refused_between: RiftMotePickupReading = RiftMotePickupQuery.evaluate(Vector3(NAN, 0.0, 0.0), mote, totals)
	var _far_between: RiftMotePickupReading = RiftMotePickupQuery.evaluate(
		ORIGIN, Vector3(100.0, 0.0, 0.0), PlayerStatTotals.new())
	var _missing_between: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, mote, null)
	_expect(_whole(RiftMotePickupQuery.evaluate(ORIGIN, mote, totals)) == first,
		"a question asked after three others was answered differently")

	## THE TOTALS ARE READ, NEVER WRITTEN, AND NEVER KEPT.
	var before: String = "%s | %s" % [totals.describe(), str(totals.contributions_for(PlayerStats.PICKUP_RADIUS))]
	var kept: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, mote, totals)
	_expect("%s | %s" % [totals.describe(), str(totals.contributions_for(PlayerStats.PICKUP_RADIUS))] == before,
		"the query changed the totals it was handed")
	_expect(totals.add(PlayerStats.PICKUP_RADIUS, PLUS_25_PERCENT).is_empty(), "the accumulator refused a second +25%")
	_expect(kept.effective_radius == RADIUS_AT_PLUS_25 and kept.in_range,
		"a later modifier reached an answer already given: %s" % kept.describe())
	var later: RiftMotePickupReading = RiftMotePickupQuery.evaluate(ORIGIN, mote, totals)
	_expect(later.effective_radius == 3.75, "the next question reads %s" % later.describe())

	## THE READING IS SCALARS AND POSITIONS, IN THE DECLARED ORDER.
	var reading_fields: PackedStringArray = _fields_of(kept)
	_expect(", ".join(reading_fields) == ", ".join(PackedStringArray(EXPECTED_READING_FIELDS)),
		"the reading carries: %s" % ", ".join(reading_fields))
	var object_fields: PackedStringArray = PackedStringArray()
	for entry: Dictionary in kept.get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0 and int(entry.get("type", 0)) == TYPE_OBJECT:
			object_fields.append(String(entry.get("name", "")))
	_expect(object_fields.is_empty(), "the reading holds object references: %s" % ", ".join(object_fields))
	var reading_signatures: PackedStringArray = _signatures_of(READING_FILE)
	_expect(", ".join(reading_signatures) == ", ".join(PackedStringArray(EXPECTED_READING_SIGNATURES)),
		"the reading declares: %s" % ", ".join(reading_signatures))

	print("  %d instance fields, %d script variables, %d constant (%s), %d method; %d of 100 identical questions disagree, and one asked after three others agrees"
		% [instance_fields.size(), script_properties.size(), constants.size(), str(constants),
			signatures.size(), drifted])
	print("  the totals unchanged by the query; an answer already given unmoved by a later modifier; the reading holds %d fields and 0 object references"
		% reading_fields.size())
	_done("the_query_holds_nothing_and_retains_nothing_between_calls")


# --- 10. The shape ---------------------------------------------------------------------------------------------------

func _check_the_shape() -> void:
	print("")
	print("--- 10. The query restates nothing, and each file names only what it reads")
	var query_raw: String = FileAccess.get_file_as_string(QUERY_FILE)
	var reading_raw: String = FileAccess.get_file_as_string(READING_FILE)
	var query_code: String = _code_only(query_raw)
	var reading_code: String = _code_only(reading_raw)
	_expect(query_raw.length() > 2000 and query_code.length() > 500 and query_code.length() < query_raw.length(),
		"the query read as %d / %d characters" % [query_raw.length(), query_code.length()])
	_expect(reading_raw.length() > 2000 and reading_code.length() > 500 and reading_code.length() < reading_raw.length(),
		"the reading read as %d / %d characters" % [reading_raw.length(), reading_code.length()])

	## ONE QUESTION TO THE ACCEPTED CALCULATION, FOR ONE STAT, FROM ONE BASE.
	_expect(query_code.count("value_of(") == 1
			and query_code.count("totals.value_of(PlayerStats.PICKUP_RADIUS, BASE_PICKUP_RADIUS)") == 1,
		"the query asks the accepted calculation %d times" % query_code.count("value_of("))
	_expect(query_code.count("const BASE_PICKUP_RADIUS: float = 2.5") == 1,
		"the base radius is not declared exactly once as 2.5")

	## THE PLANE: x and z are read, height never is.
	_expect(query_code.contains(".x") and query_code.contains(".z") and not query_code.contains(".y"),
		"the query reads a height component, or not both ground components")
	_expect(query_code.count("sqrt(") == 1 and query_code.count("*") == 2
			and query_code.count(" + ") == 1 and query_code.replace("->", "").count("-") == 2,
		"the query's arithmetic is not exactly the planar distance: %d sqrt, %d *, %d +, %d -" % [
			query_code.count("sqrt("), query_code.count("*"), query_code.count(" + "),
			query_code.replace("->", "").count("-")])
	_expect(query_code.count("planar_distance <= radius.value") == 1 and not query_code.contains(" < "),
		"the comparison is not the single inclusive one")
	_expect(", ".join(_numeric_literals(query_code)) == "0.0, 2.5",
		"the query carries the literals %s" % str(_numeric_literals(query_code)))

	## THE READING DOES NO ARITHMETIC AT ALL.
	_expect(not reading_code.contains("sqrt(") and not reading_code.contains("*")
			and not reading_code.contains(" + ") and not reading_code.replace("->", "").contains(" - "),
		"the reading performs arithmetic")
	_expect(", ".join(_numeric_literals(reading_code)) == "0.0",
		"the reading carries the literals %s" % str(_numeric_literals(reading_code)))

	## NO FIELD, NO STATIC STATE: no declaration at the top level of either file
	## but the reading's eight fields.
	var query_declarations: int = 0
	for line: String in query_code.split("\n"):
		if line.begins_with("var ") or line.begins_with("static var ") or line.begins_with("@"):
			query_declarations += 1
	_expect(query_declarations == 0, "the query declares %d top-level variables" % query_declarations)
	_expect(not reading_code.contains("static var"), "the reading declares static state")

	## SCANS: other foundations, content and ambient reads raw; restatement in code.
	var hits: PackedStringArray = PackedStringArray()
	for token: String in FORBIDDEN_TOKENS + AMBIENT_TOKENS:
		if query_raw.contains(token):
			hits.append("query: %s" % token)
		if reading_raw.contains(token):
			hits.append("reading: %s" % token)
	for token: String in RESTATEMENT_TOKENS:
		if query_code.contains(token):
			hits.append("query code: %s" % token)
		if reading_code.contains(token):
			hits.append("reading code: %s" % token)
	if reading_raw.contains("PlayerStat"):
		hits.append("reading: PlayerStat")
	_expect(hits.is_empty(), "the pickup files name or do: %s" % ", ".join(hits))

	## PER-FILE CLASS ALLOWLIST FROM THE ENGINE'S OWN CLASS LIST, BOTH DIRECTIONS.
	var all_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		all_classes.append(String(entry.get("class", "")))
	_expect(all_classes.size() > 100 and all_classes.has(QUERY_CLASS) and all_classes.has(READING_CLASS),
		"%d project classes were enumerated, the two pickup classes %s" % [
			all_classes.size(), "among them" if all_classes.has(QUERY_CLASS) and all_classes.has(READING_CLASS) else "NOT both among them"])
	var collisions: PackedStringArray = PackedStringArray()
	for class_id: String in all_classes:
		for own: String in [QUERY_CLASS, READING_CLASS]:
			if class_id != own and (class_id.contains(own) or own.contains(class_id)):
				collisions.append("%s / %s" % [class_id, own])
	_expect(collisions.is_empty(), "a pickup class name overlaps another class name: %s" % ", ".join(collisions))
	for row: Array in [[query_raw, QUERY_NAMES, "the query"], [reading_raw, READING_NAMES, "the reading"]]:
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

	print("  the query asks the accepted calculation once, reads x and z and never y, compares once with <=; literals %s; the reading performs no arithmetic"
		% str(_numeric_literals(query_code)))
	print("  the query names only %s; the reading names only %s" % [
		", ".join(PackedStringArray(QUERY_NAMES)), ", ".join(PackedStringArray(READING_NAMES))])
	_done("the_query_restates_nothing_and_names_only_what_it_reads")


# --- 11. Unwired ---------------------------------------------------------------------------------------------------------

func _check_nothing_runs_it() -> void:
	print("")
	print("--- 11. H1 stays unwired, nothing that runs calls the query, and scripts/pickups/ holds seven scripts")
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			project_files += 1
			var text: String = FileAccess.get_file_as_string(path)
			if not PICKUP_SCRIPTS.has(path):
				for token: String in [QUERY_CLASS, READING_CLASS]:
					if text.contains(token) and not _reader_may_name(path, token):
						referenced.append("%s names %s" % [path.get_file(), token])
			if path != MOTE_FILE:
				for token: String in MOTE_TOKENS:
					if text.contains(token) and not _reader_may_name(path, token):
						referenced.append("%s names %s" % [path.get_file(), token])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for token: String in [QUERY_CLASS, READING_CLASS, "scripts/pickups", "RiftExperienceMote", "rift_experience_mote"]:
		if settings.contains(token):
			referenced.append("project.godot names %s" % token)
	_expect(referenced.is_empty(), "something that runs names the query, the reading or the mote: %s" % ", ".join(referenced))
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
	_expect(", ".join(pickup_scripts) == ", ".join(PackedStringArray(PICKUP_DIRECTORY_SCRIPTS)),
		"scripts/pickups/ holds: %s" % ", ".join(pickup_scripts))
	print("  0 unauthorized project files name the pickup query or its reading, or name or collect the Experience Mote beside its own file (%d readers granted by file and token); scripts/pickups/ holds 7 scripts; %d files scanned"
		% [AUTHORIZED_READERS.size(), project_files])
	print("  %d refusals and %d measurements were driven across this suite" % [_refusals, _measurements])
	_done("h1_stays_unwired_and_nothing_that_runs_calls_the_query")


## Whether `path` is granted `token` in `AUTHORIZED_READERS`.
func _reader_may_name(path: String, token: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) == path:
			return (row[1] as Array).has(token)
	return false


# --- Fixtures -----------------------------------------------------------------------------------------------------------------

## A directly constructed accumulator holding exactly `contributions`, each
## required to be accepted.
func _totals(contributions: Array) -> PlayerStatTotals:
	var totals: PlayerStatTotals = PlayerStatTotals.new()
	for entry: Array in contributions:
		var refusal: String = totals.add(entry[0] as StringName, float(entry[1]))
		_expect(refusal.is_empty(), "the accumulator refused %s %s: %s" % [entry[0], entry[1], refusal])
	return totals


func _plus_25() -> PlayerStatTotals:
	return _totals([[PlayerStats.PICKUP_RADIUS, PLUS_25_PERCENT]])


## The largest finite single-precision number, (2 - 2^-23) x 2^127, built by
## arithmetic rather than typed.
func _largest_position_component() -> float:
	return (2.0 - 1.0 / 8388608.0) * pow(2.0, 127.0)


# --- Assertions -----------------------------------------------------------------------------------------------------------------

func _expect_measured(reading: RiftMotePickupReading, described: String) -> void:
	_measurements += 1
	_expect(reading.ok, "%s was refused: %s" % [described, reading.failure_reason])
	_expect(reading.problem().is_empty(), "%s is incoherent: %s" % [described, reading.problem()])


## A refusal must carry a reason and NOTHING MEASURED: no base, no effective
## radius, the infinite distance, never in range — and the two stored numbers
## compared carelessly must not read as in range either.
func _expect_refused(reading: RiftMotePickupReading, described: String) -> void:
	_refusals += 1
	_expect(not reading.ok and not reading.failure_reason.strip_edges().is_empty(),
		"%s was not refused: %s" % [described, reading.describe()])
	_expect(reading.problem().is_empty(), "%s is an incoherent refusal: %s" % [described, reading.problem()])
	_expect(reading.base_radius == 0.0 and reading.effective_radius == 0.0
			and is_inf(reading.planar_distance) and reading.planar_distance > 0.0 and not reading.in_range,
		"%s carries a partial measurement: base %s, radius %s, distance %s, in range %s" % [
			described, _exact(reading.base_radius), _exact(reading.effective_radius),
			_exact(reading.planar_distance), str(reading.in_range)])
	_expect(not (reading.planar_distance <= reading.effective_radius),
		"%s reads as in range to a careless comparison" % described)


# --- Snapshots --------------------------------------------------------------------------------------------------------------------

func _verdict(reading: RiftMotePickupReading) -> String:
	if not reading.ok:
		return "refused"
	return "in range" if reading.in_range else "out of range"


func _whole(reading: RiftMotePickupReading) -> String:
	return "ok=%s reason=%s player=%s mote=%s base=%s radius=%s distance=%s in=%s" % [
		str(reading.ok), reading.failure_reason, reading.player_position, reading.mote_position,
		_exact(reading.base_radius), _exact(reading.effective_radius),
		_exact(reading.planar_distance), str(reading.in_range),
	]


func _exact(value: float) -> String:
	if is_nan(value) or is_inf(value) or absf(value) >= 1.0e17 or (value != 0.0 and absf(value) < 1.0e-6):
		return String.num_scientific(value)
	return String.num(value, 17)


# --- Source reading ---------------------------------------------------------------------------------------------------------------

func _code_only(source: String) -> String:
	var out: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


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
## rendering the accepted H1 and G4 pins use, with the position type added.
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


# --- The owed set -----------------------------------------------------------------------------------------------------------------

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
