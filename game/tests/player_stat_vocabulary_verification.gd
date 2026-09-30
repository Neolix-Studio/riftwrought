extends SceneTree
## Riftwrought — Roguelite Foundation C1 verification: Core Passive Stat
## Vocabulary (decision D-229).
##
## ONE FOCUSED HEADLESS TEST. The foundation is four pure-logic scripts under
## `scripts/stats/` — a stat record, a vocabulary, an accumulator and a result —
## so it needs no scene, no camera, no navigation, no rendering and no evidence
## frame, and it deliberately gets none. It runs as a `SceneTree` script exactly
## as both earlier foundations' suites do.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## THE ARITHMETIC IS PROVED AGAINST A WRONG ANSWER, NOT ONLY AGAINST A RIGHT
## ONE. "+10% and +20% give 1.30" is satisfied by an implementation that is
## right and by one that is nearly right, so every arithmetic claim below also
## states the number the tempting wrong implementation would have produced —
## 1.32 for compounding, 3.111 m for an area-scaled radius — and asserts the
## result is not that. A check that only knows the right answer cannot tell the
## two apart.
##
## THE ORDERING PROOF IS DELIBERATELY NOT VACUOUS. Summing three floats in six
## orders would be a pointless test if the six orders agreed anyway, so the
## check first proves that the NAIVE insertion-order sums genuinely differ on
## these exact values before asserting that the accumulator's own totals do not.
##
## THE TEST DATA IS NOT CONTENT. Every definition and modifier built below lives
## inside this file only, is registered in no catalogue, ships in no scene, no
## `.tres` and no library, and is not canon.

## The four scripts this foundation owns. NONE of them may name a concrete
## class, Skill, support or card. Scanned RAW, comments included — D-215's
## lesson: an illustrative name in a comment breaches the rule just as surely as
## a real one, because the rule exists so a reader can trust the file holds no
## such knowledge.
const FOUNDATION_FILES: Array[String] = [
	"res://scripts/stats/player_stat_definition.gd",
	"res://scripts/stats/player_stat_value.gd",
	"res://scripts/stats/player_stats.gd",
	"res://scripts/stats/player_stat_totals.gd",
]

## Concrete class, Skill, support and card names. Field names such as
## `max_life` or `increased_attack_speed` are DELIBERATELY ABSENT from this
## list: they name the stat concepts this foundation exists to reconcile with,
## and the header of `player_stats.gd` records that reconciliation on purpose.
## What must not appear is a class, a Skill, a support or a card.
const FORBIDDEN_TOKENS: Array[String] = [
	"QuickStrike", "quick_strike", "Quick Strike",
	"PrototypePlayer", "PrototypeWeaponData", "PrototypeGraveblade",
	"PassiveEffects", "PassiveGraph", "PassiveNodeData",
	"RogueliteUpgrade", "RogueliteRunBoon", "RogueliteBuildState",
	"SkillSupportCatalogue", "SupportDefinition", "SupportSelection", "SkillTags",
	"FirstMvpSkill", "CharacterState", "ExperienceTable", "PlayerLoadout",
	"Faultbreaker", "Splinter Shot", "Emberbolt", "Marrowshot",
	"Reaching Edge", "reaching_edge", "Sweeping Edge", "sweeping_edge",
	"Expedition Blade", "Quickened Edge", "Quickened Form",
	"First Fracture", "first_fracture", "Graveblade", "Riftmarked",
]

## A pure vocabulary may read no ambient state whatsoever.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
]

## The four global class names this foundation introduces. Nothing may reference
## any of them except the authorized readers below: C1 defines a vocabulary and
## is deliberately unwired to everything that runs.
const FOUNDATION_CLASSES: Array[String] = [
	"PlayerStatDefinition", "PlayerStatValue", "PlayerStats", "PlayerStatTotals",
]

## The files D-231 and D-234 authorize to name this vocabulary, and the only
## ones. Foundation C2's two passive card records READ a stat's category, mode
## and unit from C1 rather than carrying their own copy, and Foundation C3's
## selector and result READ the category a card derives and the label that
## category is presented under — so naming it is the whole point of all four
## rather than a breach of the boundary. This replaces D-229's blanket "not one
## file names a Foundation C1 class" ONE FOR ONE: the same single assertion is
## made either way, it still fails for any other file, and the pinned count does
## not move.
## THE EXEMPTION IS PER FILE AND PER CLASS. A passive card record DERIVES a
## stat's declared facts, which needs the vocabulary and the stat record and
## nothing else; a record that started naming the accumulator or the result type
## would be a record layer quietly becoming a runtime one, and it is refused here
## by the same row that refuses any other file. Foundation D2 is the opposite
## case and is why the grant became per file (D-241): a RUN-BUILD state holds an
## accumulator for the run it describes and delegates every total to it, and it
## names the accumulator and nothing else.
##
## D-241 REPLACED A FLAT `AUTHORIZED_CLASSES` LIST WITH THESE ROWS, AND THE MOVE
## IS EXACTLY ONE FOR ONE. Every file listed before is granted precisely the two
## classes the flat list granted it, the same single assertion is made either
## way, and the pinned count does not move. Widening the flat list instead would
## have handed the accumulator to all five earlier readers as a side effect of
## admitting a sixth — which is the boundary the paragraph above exists to keep.
const AUTHORIZED_READERS: Array = [
	["res://scripts/stats/passive_card_definition.gd",
		["PlayerStats", "PlayerStatDefinition"]],
	["res://scripts/stats/passive_card_catalogue.gd",
		["PlayerStats", "PlayerStatDefinition"]],
	["res://scripts/stats/passive_card_selection.gd",
		["PlayerStats", "PlayerStatDefinition"]],
	["res://scripts/stats/passive_card_selection_result.gd",
		["PlayerStats", "PlayerStatDefinition"]],
	## D-239: the Foundation D1 offer holds the passive results its two card lanes
	## produced and re-checks each one against the CATEGORY its lane draws from,
	## which is a member of this vocabulary's own enum. It names the stat
	## definition and nothing else here — not the vocabulary object, not the
	## accumulator, not the value type. The composer beside it names no Foundation
	## C1 class at all, which is why only one D1 file is listed.
	["res://scripts/offers/rift_offer.gd",
		["PlayerStats", "PlayerStatDefinition"]],
	## D-241: the Foundation D2 run-build state accumulates the modifiers its
	## acquired passive cards contributed and computes none of them itself, so it
	## holds an accumulator and names ONLY that — not the vocabulary object, not
	## the stat record, not the value type.
	["res://scripts/runs/rift_run_build.gd", ["PlayerStatTotals"]],
	## D-246: the Foundation E1 experience track evaluates every award through
	## this vocabulary's own calculation path AT THE MOMENT THE AWARD ARRIVES, so
	## it names three things and no more: the vocabulary, for the one stat
	## identifier it asks about; the accumulator, which it is handed and never
	## stores; and the VALUE that path returns, whose `ok`, `failure_reason` and
	## `value` it must read in order to fail closed. It is the first reader
	## granted the result type, and it is deliberately granted the stat RECORD
	## not at all — a track that read a stat's declared category, mode or unit
	## would be re-deriving arithmetic it exists to delegate. The reading type
	## beside it names no class in this vocabulary and is listed nowhere here.
	["res://scripts/experience/rift_experience_track.gd",
		["PlayerStats", "PlayerStatTotals", "PlayerStatValue"]],
	## D-273: the Foundation H2 pickup-range query asks this vocabulary's own
	## calculation path for the effective Pickup Radius from its greybox base AT
	## THE MOMENT IT IS ASKED, so it names the same three things E1's track names
	## and for the same reasons: the vocabulary, for the one stat identifier it asks
	## about; the accumulator, which it is handed and never stores; and the VALUE
	## that path returns, whose `ok`, `failure_reason` and `value` it must read in
	## order to fail closed. It is granted the stat RECORD not at all. The reading
	## type beside it names no class in this vocabulary and is listed nowhere here.
	["res://scripts/pickups/rift_mote_pickup_query.gd",
		["PlayerStats", "PlayerStatTotals", "PlayerStatValue"]],
	## D-275: the Foundation H3 collection attempt asks the run for an independent
	## copy of its build, asks that copy for its accumulator, and hands the
	## accumulator straight to the pickup-range query without reading it. It
	## therefore names the accumulator and NOTHING ELSE here — not the vocabulary,
	## because it asks about no stat; not the value type, because the query, not
	## the attempt, reads the calculation's answer; and not the stat record. The
	## result type beside it names no class in this vocabulary and is listed nowhere
	## here. Added one for one, and the pinned count does not move.
	["res://scripts/pickups/rift_mote_collection_attempt.gd", ["PlayerStatTotals"]],
	## Roguelite I3 (decision D-295): the one run-build application seam applies the
	## build's whole Skill Speed and Movement Speed totals to the playable character
	## through this vocabulary's own calculation path, so it names the vocabulary, for
	## the stat identifiers it asks about and classifies; the accumulator, the copy the
	## build hands it; and the VALUE that path returns, whose `ok`, reason and derivation
	## it must read to fail closed. Its result carries both derivations and a copy of
	## the totals, so it names the same three. Neither is granted the stat RECORD: the
	## result reads a stat's display name through the vocabulary's own lookup, and
	## neither reads a category, mode or unit. Added one for one, and the pinned count
	## does not move.
	["res://scripts/roguelite/live_effects/rift_build_application.gd",
		["PlayerStats", "PlayerStatTotals", "PlayerStatValue"]],
	["res://scripts/roguelite/live_effects/rift_build_application_result.gd",
		["PlayerStats", "PlayerStatTotals", "PlayerStatValue"]],
	## Roguelite Foundation I6 (decision D-304): the exhausted-support passive
	## fallback chooses uniformly between the two canonical passive CATEGORIES, so it
	## names the stat record for exactly one thing, its category enum — which
	## categories exist, and which one each supplied lane selection must have been
	## drawn from. It names not the vocabulary object, not the accumulator and not
	## the value type, and reads no stat, mode or unit; its result names no
	## Foundation C1 class. Added one for one, and the pinned count does not move.
	["res://scripts/fallback/support_exhaustion_passive_fallback.gd", ["PlayerStatDefinition"]],
	## Roguelite I13 (decision D-318): the player holds the build's normalized Global
	## Damage total and evaluates every outgoing Hit's base through this vocabulary's own
	## calculation path at the moment the Hit is committed, so it names the vocabulary,
	## for the one stat identifier and `apply()`, and the VALUE that path returns, which
	## it hands back whole so a caller can fail closed. It holds no accumulator and reads
	## no stat record. The two attack kernels that commit a Hit's damage read that value's
	## `ok`, reason and number, so each names the VALUE type and nothing else here. Added
	## one for one, and the pinned count does not move.
	["res://scripts/actors/prototype_player.gd", ["PlayerStats", "PlayerStatValue"]],
	["res://scripts/combat/quick_strike_action.gd", ["PlayerStatValue"]],
	["res://scripts/skills/first_mvp_skill_action.gd", ["PlayerStatValue"]],
]

const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data"]

const CANONICAL_QUICK_STRIKE: String = "res://data/prototype_zero/quick_strike.tres"

## The accepted action time the rate mode is demonstrated against. Read from the
## canonical record rather than retyped, so this suite cannot disagree with it.
var _accepted_action_time: float = 0.0

const OWED_CHECKS: Array[String] = [
	"the_six_shipped_stats_are_exactly_as_declared",
	"two_percentages_add_before_they_are_applied",
	"skill_speed_divides_and_cannot_produce_a_negative_time",
	"pickup_radius_is_a_radius_and_not_an_area",
	"ordering_and_duplicates_are_deterministic",
	"every_invalid_input_fails_closed",
	"the_foundation_is_generic_and_reads_nothing_ambient",
	"presentation_is_separate_from_the_arithmetic",
	"nothing_existing_changed",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation C1 — Core Passive Stat Vocabulary (D-229) ===")

	_check_the_six_shipped_stats_are_exactly_as_declared()
	_check_two_percentages_add_before_they_are_applied()
	_check_skill_speed_divides_and_cannot_produce_a_negative_time()
	_check_pickup_radius_is_a_radius_and_not_an_area()
	_check_ordering_and_duplicates_are_deterministic()
	_check_every_invalid_input_fails_closed()
	_check_the_foundation_is_generic_and_reads_nothing_ambient()
	_check_presentation_is_separate_from_the_arithmetic()
	_check_nothing_existing_changed()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("PLAYER STAT VOCABULARY VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("PLAYER STAT VOCABULARY VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. The six shipped stats -------------------------------------------------

func _check_the_six_shipped_stats_are_exactly_as_declared() -> void:
	print("")
	print("--- 1. Exactly six stats, each with the declared category, mode and unit")

	var records: Array[PlayerStatDefinition] = PlayerStats.definitions()
	_expect(records.size() == 6, "the vocabulary holds %d definitions, not 6" % records.size())
	_expect(PlayerStats.ALL.size() == 6,
		"the canonical order holds %d ids, not 6" % PlayerStats.ALL.size())
	_expect(PlayerStats.problems().is_empty(),
		"the vocabulary reports problems: %s" % ", ".join(PlayerStats.problems()))

	## The canonical order, written out here so a reordering is a failure rather
	## than a silent change of what "the first stat" means.
	var expected_order: Array[StringName] = [
		PlayerStats.GLOBAL_DAMAGE, PlayerStats.SKILL_SPEED, PlayerStats.MAXIMUM_LIFE,
		PlayerStats.MOVEMENT_SPEED, PlayerStats.EXPERIENCE_GAIN, PlayerStats.PICKUP_RADIUS,
	]
	_expect(PlayerStats.ALL == expected_order,
		"the canonical order is %s" % str(PlayerStats.ALL))

	## THE TABLE THE BRIEF ASKS FOR, ROW BY ROW: id, presentation name, card
	## category, calculation mode, presentation unit.
	var rows: Array[Dictionary] = [
		{
			"id": PlayerStats.GLOBAL_DAMAGE, "name": "Global Damage",
			"category": PlayerStatDefinition.Category.COMBAT_DEFENCE,
			"mode": PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
			"unit": PlayerStatDefinition.Unit.DAMAGE_POINTS,
		},
		{
			"id": PlayerStats.SKILL_SPEED, "name": "Skill Speed",
			"category": PlayerStatDefinition.Category.COMBAT_DEFENCE,
			"mode": PlayerStatDefinition.Mode.INCREASED_RATE,
			"unit": PlayerStatDefinition.Unit.SECONDS,
		},
		{
			"id": PlayerStats.MAXIMUM_LIFE, "name": "Maximum Life",
			"category": PlayerStatDefinition.Category.COMBAT_DEFENCE,
			"mode": PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
			"unit": PlayerStatDefinition.Unit.LIFE_POINTS,
		},
		{
			"id": PlayerStats.MOVEMENT_SPEED, "name": "Movement Speed",
			"category": PlayerStatDefinition.Category.UTILITY,
			"mode": PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
			"unit": PlayerStatDefinition.Unit.METRES_PER_SECOND,
		},
		{
			"id": PlayerStats.EXPERIENCE_GAIN, "name": "Experience Gain",
			"category": PlayerStatDefinition.Category.UTILITY,
			"mode": PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
			"unit": PlayerStatDefinition.Unit.EXPERIENCE_POINTS,
		},
		{
			"id": PlayerStats.PICKUP_RADIUS, "name": "Pickup Radius",
			"category": PlayerStatDefinition.Category.UTILITY,
			"mode": PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
			"unit": PlayerStatDefinition.Unit.METRES,
		},
	]
	for row: Dictionary in rows:
		var stat_id: StringName = row["id"]
		var record: PlayerStatDefinition = PlayerStats.definition(stat_id)
		if record == null:
			_expect(false, "%s has no definition" % stat_id)
			continue
		_expect(record.stat_id == stat_id, "%s does not carry its own id" % stat_id)
		_expect(record.display_name == String(row["name"]),
			"%s is named '%s', not '%s'" % [stat_id, record.display_name, row["name"]])
		_expect(record.category == int(row["category"]),
			"%s is filed under %s" % [stat_id, record.category_name()])
		_expect(record.mode == int(row["mode"]),
			"%s uses the %s mode" % [stat_id, record.mode_name()])
		_expect(record.unit == int(row["unit"]),
			"%s is measured in %s" % [stat_id, record.unit_name()])
		_expect(record.problem().is_empty(), "%s reports: %s" % [stat_id, record.problem()])
		_expect(PlayerStats.is_known(stat_id), "%s is not recognised by the vocabulary" % stat_id)

	## THE TWO CATEGORIES PARTITION THE VOCABULARY: three and three, in canonical
	## order, with nothing in both and nothing in neither. The lists are DERIVED
	## from the records, so this proves the derivation rather than a second list.
	var combat: Array[StringName] = PlayerStats.in_category(
		PlayerStatDefinition.Category.COMBAT_DEFENCE)
	var utility: Array[StringName] = PlayerStats.in_category(
		PlayerStatDefinition.Category.UTILITY)
	var expected_combat: Array[StringName] = [
		PlayerStats.GLOBAL_DAMAGE, PlayerStats.SKILL_SPEED, PlayerStats.MAXIMUM_LIFE,
	]
	var expected_utility: Array[StringName] = [
		PlayerStats.MOVEMENT_SPEED, PlayerStats.EXPERIENCE_GAIN, PlayerStats.PICKUP_RADIUS,
	]
	_expect(combat == expected_combat,
		"the combat and defence category holds %s" % str(combat))
	_expect(utility == expected_utility,
		"the utility category holds %s" % str(utility))
	var joined: Array[StringName] = []
	joined.append_array(combat)
	joined.append_array(utility)
	_expect(joined == PlayerStats.ALL,
		"the two categories do not partition the vocabulary: %s" % str(joined))

	_expect(not PlayerStats.is_known(&"not_a_stat"), "an unknown id is recognised")
	_expect(PlayerStats.definition(&"not_a_stat") == null,
		"an unknown id returned a definition")
	_expect(PlayerStats.definition(&"") == null, "an empty id returned a definition")

	## The vocabulary hands out fresh records, so a caller cannot alter it
	## through a reference it was only given to read.
	var first: PlayerStatDefinition = PlayerStats.definition(PlayerStats.GLOBAL_DAMAGE)
	first.display_name = "Tampered"
	_expect(PlayerStats.definition(PlayerStats.GLOBAL_DAMAGE).display_name == "Global Damage",
		"altering a returned definition altered the vocabulary")

	print("  6 stats: 3 combat and defence, 3 utility; 1 rate, 5 multiplied; 6 distinct units")
	for line: String in PlayerStats.lines():
		print("    %s" % line)
	_done("the_six_shipped_stats_are_exactly_as_declared")


# --- 2. Percentages add before they are applied -------------------------------

func _check_two_percentages_add_before_they_are_applied() -> void:
	print("")
	print("--- 2. Two percentages ADD before application: +10% and +20% is 1.30x, not 1.32x")

	var totals: PlayerStatTotals = PlayerStatTotals.new()
	_expect(totals.add(PlayerStats.GLOBAL_DAMAGE, 0.10).is_empty(), "+10% was refused")
	_expect(totals.add(PlayerStats.GLOBAL_DAMAGE, 0.20).is_empty(), "+20% was refused")
	_expect(totals.count_for(PlayerStats.GLOBAL_DAMAGE) == 2,
		"the record holds %d modifiers, not 2" % totals.count_for(PlayerStats.GLOBAL_DAMAGE))
	_expect(is_equal_approx(totals.total_for(PlayerStats.GLOBAL_DAMAGE), 0.30),
		"the total is %.6f, not 0.30" % totals.total_for(PlayerStats.GLOBAL_DAMAGE))

	var value: PlayerStatValue = totals.value_of(PlayerStats.GLOBAL_DAMAGE, 100.0)
	_expect_coherent(value, "the two-modifier value")
	_expect(is_equal_approx(value.scale, 1.30),
		"the scale is %.6f, not 1.30" % value.scale)
	_expect(is_equal_approx(value.value, 130.0),
		"100 at +30%% produced %.6f, not 130" % value.value)

	## THE WRONG ANSWER, NAMED. Applying each modifier in turn compounds to 1.32
	## and 132 damage, which is what an implementation that scales the running
	## value produces. Asserting only "= 130" would pass for both on a loose
	## tolerance; asserting "and not 132" cannot.
	var compounded: float = 100.0 * 1.10 * 1.20
	_expect(is_equal_approx(compounded, 132.0),
		"the compounding control computed %.6f, not 132" % compounded)
	_expect(absf(value.value - compounded) > 1.0,
		"the value %.6f is indistinguishable from the compounded %.6f" % [
			value.value, compounded,
		])

	## Three modifiers, to prove the rule is not an artefact of there being two.
	var three: PlayerStatTotals = PlayerStatTotals.new()
	for _index: int in 3:
		_expect(three.add(PlayerStats.GLOBAL_DAMAGE, 0.10).is_empty(), "+10% was refused")
	_expect(is_equal_approx(three.total_for(PlayerStats.GLOBAL_DAMAGE), 0.30),
		"three +10%% modifiers total %.6f" % three.total_for(PlayerStats.GLOBAL_DAMAGE))
	_expect(is_equal_approx(three.value_of(PlayerStats.GLOBAL_DAMAGE, 100.0).value, 130.0),
		"three +10%% modifiers produced %.6f, not 130"
			% three.value_of(PlayerStats.GLOBAL_DAMAGE, 100.0).value)
	_expect(absf(three.value_of(PlayerStats.GLOBAL_DAMAGE, 100.0).value - 133.1) > 1.0,
		"three +10%% modifiers compounded to 1.331x")

	## THE CANONICAL WORKED EXAMPLE, from the damage model: "80% increased Damage
	## / 20% reduced Damage / = 60% increased Damage / = a multiplier of 1.60".
	## A reduction is an ordinary negative modifier and joins the same sum.
	var canon: PlayerStatTotals = PlayerStatTotals.new()
	_expect(canon.add(PlayerStats.GLOBAL_DAMAGE, 0.80).is_empty(), "+80% was refused")
	_expect(canon.add(PlayerStats.GLOBAL_DAMAGE, -0.20).is_empty(), "-20% was refused")
	_expect(is_equal_approx(canon.total_for(PlayerStats.GLOBAL_DAMAGE), 0.60),
		"80 increased and 20 reduced total %.6f, not 0.60"
			% canon.total_for(PlayerStats.GLOBAL_DAMAGE))
	var canon_value: PlayerStatValue = canon.value_of(PlayerStats.GLOBAL_DAMAGE, 100.0)
	_expect(is_equal_approx(canon_value.scale, 1.60),
		"the canonical example produced a multiplier of %.6f, not 1.60" % canon_value.scale)
	_expect(is_equal_approx(canon_value.value, 160.0),
		"the canonical example produced %.6f, not 160" % canon_value.value)

	## The same addition rule on a second multiplied stat, so it is a property of
	## the arithmetic rather than of one stat's record.
	var life: PlayerStatTotals = PlayerStatTotals.new()
	life.add(PlayerStats.MAXIMUM_LIFE, 0.10)
	life.add(PlayerStats.MAXIMUM_LIFE, 0.20)
	_expect(is_equal_approx(life.value_of(PlayerStats.MAXIMUM_LIFE, 500.0).value, 650.0),
		"500 Life at +30%% produced %.6f, not 650"
			% life.value_of(PlayerStats.MAXIMUM_LIFE, 500.0).value)

	## Zero modifiers is the identity, and it is a value rather than a refusal.
	var none: PlayerStatValue = PlayerStats.apply(PlayerStats.GLOBAL_DAMAGE, 100.0, 0.0)
	_expect_coherent(none, "the unmodified value")
	_expect(is_equal_approx(none.value, 100.0),
		"an unmodified base produced %.6f, not 100" % none.value)

	print("  +10% and +20% -> total 0.30, scale 1.30, 100 -> 130.00 (compounding would give 132.00)")
	print("  canonical example: +80% and -20% -> 1.60x -> 160.00")
	_done("two_percentages_add_before_they_are_applied")


# --- 3. Skill Speed divides -----------------------------------------------------

func _check_skill_speed_divides_and_cannot_produce_a_negative_time() -> void:
	print("")
	print("--- 3. Skill Speed DIVIDES a duration and can never produce a negative one")

	var record: PlayerStatDefinition = PlayerStats.definition(PlayerStats.SKILL_SPEED)
	_expect(record != null and record.is_rate(), "Skill Speed does not use the rate mode")
	_expect(record.unit == PlayerStatDefinition.Unit.SECONDS,
		"Skill Speed is measured in %s" % record.unit_name())
	_expect(record.formula_line().contains("/"),
		"Skill Speed's stated formula is '%s'" % record.formula_line())

	## Demonstrated against the project's own accepted action time, read from the
	## canonical record rather than retyped here.
	_expect(_accepted_action_time > 0.0 or _load_accepted_action_time(),
		"the canonical action time could not be read")
	var base: float = _accepted_action_time
	_expect(is_equal_approx(base, 0.80), "the canonical action time is %.4f" % base)

	var at_25: PlayerStatValue = PlayerStats.apply(PlayerStats.SKILL_SPEED, base, 0.25)
	_expect_coherent(at_25, "the +25% action time")
	_expect(is_equal_approx(at_25.value, 0.64),
		"%.4f at +25%% produced %.6f, not 0.64" % [base, at_25.value])
	_expect(is_equal_approx(PlayerStats.apply(PlayerStats.SKILL_SPEED, base, 0.0).value, base),
		"an unmodified action time moved")
	_expect(is_equal_approx(PlayerStats.apply(PlayerStats.SKILL_SPEED, base, 1.0).value, 0.40),
		"%.4f at +100%% did not halve" % base)
	_expect(is_equal_approx(PlayerStats.apply(PlayerStats.SKILL_SPEED, base, -0.20).value, 1.0),
		"%.4f at -20%% produced %.6f, not 1.00"
			% [base, PlayerStats.apply(PlayerStats.SKILL_SPEED, base, -0.20).value])

	## THE WRONG MODE, NAMED. Multiplying would make an increase SLOWER: 0.80
	## would become 1.00 at +25%. The two modes must disagree in this direction,
	## and the multiplied stat is used as the control so the comparison is
	## against real behaviour rather than against arithmetic written here.
	var multiplied: PlayerStatValue = PlayerStats.apply(
		PlayerStats.MOVEMENT_SPEED, base, 0.25)
	_expect(is_equal_approx(multiplied.value, 1.0),
		"the multiplied control produced %.6f, not 1.00" % multiplied.value)
	_expect(at_25.value < base and multiplied.value > base,
		"the rate mode and the multiplied mode did not move in opposite directions")

	## EVERY legal total, swept, rather than a handful of chosen ones. A
	## non-negative base and a strictly positive scale cannot produce a negative
	## duration, and this walks the range to show it.
	var swept: int = 0
	var faults: int = 0
	for step: int in 1200:
		var total: float = -0.999 + float(step) * 0.01
		var swept_value: PlayerStatValue = PlayerStats.apply(PlayerStats.SKILL_SPEED, base, total)
		swept += 1
		if not swept_value.ok or swept_value.value <= 0.0 or not is_finite(swept_value.value):
			faults += 1
	_expect(faults == 0,
		"%d of %d swept totals produced a non-positive or non-finite action time" % [
			faults, swept,
		])
	_expect(swept == 1200, "the sweep ran %d steps, not 1200" % swept)

	## A base of zero is the one legal way to reach zero, and it is still not
	## negative.
	_expect(is_zero_approx(PlayerStats.apply(PlayerStats.SKILL_SPEED, 0.0, 3.0).value),
		"a zero base did not produce zero")

	print("  %.2f s at +25%% -> %.4f s; swept %d totals from -0.999 upward, 0 non-positive"
		% [base, at_25.value, swept])
	_done("skill_speed_divides_and_cannot_produce_a_negative_time")


# --- 4. Pickup Radius is a radius ----------------------------------------------

func _check_pickup_radius_is_a_radius_and_not_an_area() -> void:
	print("")
	print("--- 4. Pickup Radius scales the RADIUS, and the area answer is refused by measurement")

	var record: PlayerStatDefinition = PlayerStats.definition(PlayerStats.PICKUP_RADIUS)
	_expect(record != null, "Pickup Radius has no definition")
	_expect(record.display_name == "Pickup Radius",
		"the stat is named '%s'" % record.display_name)
	_expect(record.unit == PlayerStatDefinition.Unit.METRES,
		"Pickup Radius is measured in %s, not metres" % record.unit_name())
	_expect(not record.is_rate(), "Pickup Radius uses the rate mode")

	## A round base in metres, chosen so both answers are easy to read.
	var base: float = 2.20
	var doubled: PlayerStatValue = PlayerStats.apply(PlayerStats.PICKUP_RADIUS, base, 1.00)
	_expect_coherent(doubled, "the +100% radius")
	_expect(is_equal_approx(doubled.value, 4.40),
		"%.2f m at +100%% produced %.6f m, not 4.40" % [base, doubled.value])

	## THE OTHER STAT WEARING THE SAME NAME, NAMED. If the percentage scaled the
	## covered AREA instead, +100% would give a radius of 2.20 x sqrt(2) = 3.111
	## m. Asserting the difference is what makes the choice a measured fact
	## rather than a comment.
	var area_scaled_radius: float = base * sqrt(2.0)
	_expect(is_equal_approx(area_scaled_radius, 3.1112698),
		"the area control computed %.7f" % area_scaled_radius)
	_expect(absf(doubled.value - area_scaled_radius) > 1.0,
		"the radius %.6f is indistinguishable from the area-scaled %.6f" % [
			doubled.value, area_scaled_radius,
		])

	_expect(is_equal_approx(PlayerStats.apply(PlayerStats.PICKUP_RADIUS, base, 0.50).value, 3.30),
		"%.2f m at +50%% did not produce 3.30 m" % base)

	## THE CONSEQUENCE, STATED RATHER THAN LEFT TO BE DISCOVERED: doubling the
	## radius quadruples the ground it covers. That is a real balance property of
	## this choice and it is measured here so it can never be a surprise.
	var ground_factor: float = (doubled.value * doubled.value) / (base * base)
	_expect(is_equal_approx(ground_factor, 4.0),
		"+100%% radius changed the covered ground by %.4fx, not 4x" % ground_factor)

	print("  2.20 m at +100%% -> 4.40 m (an AREA modifier would give 3.111 m); ground x%.2f"
		% ground_factor)
	_done("pickup_radius_is_a_radius_and_not_an_area")


# --- 5. Ordering and duplicates -------------------------------------------------

func _check_ordering_and_duplicates_are_deterministic() -> void:
	print("")
	print("--- 5. Ordering and duplicate handling are deterministic to the last bit")

	## THE CHECK IS PROVED NON-VACUOUS FIRST. These three values are chosen
	## because their naive sums genuinely differ by order in binary floating
	## point; if they did not, six identical totals would prove nothing at all.
	var ascending: float = 0.1 + 0.2 + 0.3
	var descending: float = 0.3 + 0.2 + 0.1
	_expect(ascending != descending,
		"the naive control sums agree, so the ordering proof would be vacuous")

	var values: Array[float] = [0.1, 0.2, 0.3]
	var seen: Array[float] = []
	for a: int in 3:
		for b: int in 3:
			for c: int in 3:
				if a == b or b == c or a == c:
					continue
				var totals: PlayerStatTotals = PlayerStatTotals.new()
				totals.add(PlayerStats.GLOBAL_DAMAGE, values[a])
				totals.add(PlayerStats.GLOBAL_DAMAGE, values[b])
				totals.add(PlayerStats.GLOBAL_DAMAGE, values[c])
				seen.append(totals.total_for(PlayerStats.GLOBAL_DAMAGE))
	_expect(seen.size() == 6, "the permutation sweep ran %d orders, not 6" % seen.size())
	var identical: bool = true
	for total: float in seen:
		if total != seen[0]:
			identical = false
	## Bit-identical, compared with `==` rather than with a tolerance: an
	## approximate comparison would accept exactly the drift this exists to
	## prevent.
	_expect(identical, "six orderings of the same modifiers produced different totals")

	## Duplicates ADD. Two grants of the same size are twice the size.
	var duplicated: PlayerStatTotals = PlayerStatTotals.new()
	for _index: int in 3:
		duplicated.add(PlayerStats.MOVEMENT_SPEED, 0.10)
	_expect(duplicated.count_for(PlayerStats.MOVEMENT_SPEED) == 3,
		"three identical grants recorded %d modifiers"
			% duplicated.count_for(PlayerStats.MOVEMENT_SPEED))
	_expect(is_equal_approx(duplicated.total_for(PlayerStats.MOVEMENT_SPEED), 0.30),
		"three +10%% grants total %.6f" % duplicated.total_for(PlayerStats.MOVEMENT_SPEED))
	_expect(duplicated.size() == 3, "the record holds %d modifiers" % duplicated.size())

	## Insertion order is kept for diagnostics even though it decides nothing.
	var ordered: PlayerStatTotals = PlayerStatTotals.new()
	ordered.add(PlayerStats.GLOBAL_DAMAGE, 0.30)
	ordered.add(PlayerStats.GLOBAL_DAMAGE, 0.10)
	ordered.add(PlayerStats.GLOBAL_DAMAGE, 0.20)
	var contributions: PackedFloat64Array = ordered.contributions_for(PlayerStats.GLOBAL_DAMAGE)
	_expect(contributions.size() == 3, "%d contributions were kept" % contributions.size())
	_expect(is_equal_approx(contributions[0], 0.30) and is_equal_approx(contributions[1], 0.10)
			and is_equal_approx(contributions[2], 0.20),
		"insertion order was not preserved: %s" % str(contributions))

	## The list handed out is a copy, so a caller cannot alter the record through
	## a reference it was only given to read.
	contributions.set(0, 99.0)
	_expect(is_equal_approx(ordered.total_for(PlayerStats.GLOBAL_DAMAGE), 0.60),
		"altering a returned contribution list altered the record")

	## Stats are independent, and `stats()` answers in canonical order whatever
	## order the grants arrived in.
	var mixed: PlayerStatTotals = PlayerStatTotals.new()
	mixed.add(PlayerStats.PICKUP_RADIUS, 0.10)
	mixed.add(PlayerStats.GLOBAL_DAMAGE, 0.20)
	mixed.add(PlayerStats.MOVEMENT_SPEED, 0.30)
	var expected_granted: Array[StringName] = [
		PlayerStats.GLOBAL_DAMAGE, PlayerStats.MOVEMENT_SPEED, PlayerStats.PICKUP_RADIUS,
	]
	_expect(mixed.stats() == expected_granted,
		"the granted stats are reported as %s" % str(mixed.stats()))
	_expect(is_equal_approx(mixed.total_for(PlayerStats.GLOBAL_DAMAGE), 0.20)
			and is_zero_approx(mixed.total_for(PlayerStats.MAXIMUM_LIFE)),
		"granting one stat moved another")
	_expect(is_zero_approx(mixed.total_for(&"not_a_stat")),
		"an unrecognised stat reported a non-zero total")

	## A copy is independent in both directions.
	var copy: PlayerStatTotals = mixed.duplicated()
	copy.add(PlayerStats.GLOBAL_DAMAGE, 0.50)
	_expect(is_equal_approx(mixed.total_for(PlayerStats.GLOBAL_DAMAGE), 0.20),
		"adding to a copy moved the original")
	_expect(is_equal_approx(copy.total_for(PlayerStats.GLOBAL_DAMAGE), 0.70),
		"the copy did not carry the original's modifiers")

	_expect(mixed.clear_stat(PlayerStats.GLOBAL_DAMAGE), "clearing a granted stat reported nothing")
	_expect(not mixed.clear_stat(PlayerStats.GLOBAL_DAMAGE),
		"clearing an already-empty stat reported a removal")
	mixed.clear()
	_expect(mixed.is_empty(), "the record was not emptied")

	print("  6 orderings of 0.1/0.2/0.3 are bit-identical while the naive sums differ; "
		+ "3 duplicates total 0.30")
	_done("ordering_and_duplicates_are_deterministic")


# --- 6. Everything invalid fails closed -----------------------------------------

func _check_every_invalid_input_fails_closed() -> void:
	print("")
	print("--- 6. Every invalid definition and unsafe calculation refuses, with a reason")

	## A POSITIVE CONTROL FIRST, because a guard that refuses everything protects
	## nothing.
	var control: PlayerStatTotals = PlayerStatTotals.new()
	_expect(control.add(PlayerStats.GLOBAL_DAMAGE, 0.15).is_empty(),
		"the positive control was refused")
	_expect(PlayerStats.apply(PlayerStats.GLOBAL_DAMAGE, 100.0, 0.15).ok,
		"the positive control calculation was refused")

	## --- Refusals from the accumulator. A refused modifier is NOT recorded.
	var refusals: Array[Dictionary] = [
		{"what": "an unrecognised stat", "id": &"not_a_stat", "value": 0.10},
		{"what": "an empty stat id", "id": &"", "value": 0.10},
		{"what": "a not-a-number modifier", "id": PlayerStats.GLOBAL_DAMAGE, "value": NAN},
		{"what": "an infinite modifier", "id": PlayerStats.GLOBAL_DAMAGE, "value": INF},
		{"what": "a negatively infinite modifier", "id": PlayerStats.GLOBAL_DAMAGE, "value": -INF},
		{"what": "a modifier reaching a zero scale", "id": PlayerStats.GLOBAL_DAMAGE, "value": -1.0},
		{"what": "a modifier passing a zero scale", "id": PlayerStats.GLOBAL_DAMAGE, "value": -1.5},
	]
	for refusal: Dictionary in refusals:
		var record: PlayerStatTotals = PlayerStatTotals.new()
		var reason: String = record.add(refusal["id"], float(refusal["value"]))
		_expect(not reason.strip_edges().is_empty(),
			"%s was accepted without a reason" % refusal["what"])
		_expect(record.is_empty(),
			"%s left %d modifier(s) recorded" % [refusal["what"], record.size()])

	## The zero-scale refusal must also fire INCREMENTALLY, when no single
	## modifier is illegal but their sum is — which is the case a per-modifier
	## guard would miss entirely.
	var incremental: PlayerStatTotals = PlayerStatTotals.new()
	_expect(incremental.add(PlayerStats.GLOBAL_DAMAGE, -0.50).is_empty(),
		"a legal -50% was refused")
	_expect(not incremental.add(PlayerStats.GLOBAL_DAMAGE, -0.60).is_empty(),
		"a second -60% took the total past -1 and was accepted")
	_expect(incremental.count_for(PlayerStats.GLOBAL_DAMAGE) == 1,
		"the refused modifier was recorded anyway")
	_expect(is_equal_approx(incremental.total_for(PlayerStats.GLOBAL_DAMAGE), -0.50),
		"the total moved to %.6f after a refusal"
			% incremental.total_for(PlayerStats.GLOBAL_DAMAGE))
	## And the legal edge just inside it still works, so the bound is a bound
	## rather than a blanket refusal of large reductions.
	_expect(incremental.add(PlayerStats.GLOBAL_DAMAGE, -0.49).is_empty(),
		"a total of -0.99 was refused")

	## --- Refusals from the calculation.
	var unsafe: Array[Dictionary] = [
		{"what": "an unrecognised stat", "id": &"not_a_stat", "base": 100.0, "total": 0.0},
		{"what": "a not-a-number base", "id": PlayerStats.GLOBAL_DAMAGE, "base": NAN, "total": 0.0},
		{"what": "an infinite base", "id": PlayerStats.GLOBAL_DAMAGE, "base": INF, "total": 0.0},
		{"what": "a not-a-number total", "id": PlayerStats.GLOBAL_DAMAGE, "base": 100.0, "total": NAN},
		{"what": "an infinite total", "id": PlayerStats.GLOBAL_DAMAGE, "base": 100.0, "total": INF},
		{"what": "a negative base", "id": PlayerStats.MAXIMUM_LIFE, "base": -1.0, "total": 0.0},
		{"what": "a zero scale", "id": PlayerStats.SKILL_SPEED, "base": 0.80, "total": -1.0},
		{"what": "a negative scale", "id": PlayerStats.SKILL_SPEED, "base": 0.80, "total": -1.5},
	]
	for case: Dictionary in unsafe:
		var value: PlayerStatValue = PlayerStats.apply(
			case["id"], float(case["base"]), float(case["total"]))
		_expect(not value.ok, "%s produced a value" % case["what"])
		_expect(not value.failure_reason.strip_edges().is_empty(),
			"%s was refused without a reason" % case["what"])
		_expect_no_partial_value(value, String(case["what"]))

	## --- Refusals from an invalid DEFINITION, driven through the calculation
	## path that can actually receive one.
	var invalid: Array[Dictionary] = [
		{
			"what": "no definition at all", "record": null,
		},
		{
			"what": "an empty stat id",
			"record": PlayerStatDefinition.of(&"", "Nameless",
				PlayerStatDefinition.Category.UTILITY,
				PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
				PlayerStatDefinition.Unit.METRES),
		},
		{
			"what": "an empty presentation name",
			"record": PlayerStatDefinition.of(&"probe", "",
				PlayerStatDefinition.Category.UTILITY,
				PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
				PlayerStatDefinition.Unit.METRES),
		},
		{
			"what": "an unrecognised category",
			"record": PlayerStatDefinition.of(&"probe", "Probe",
				(99 as PlayerStatDefinition.Category),
				PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
				PlayerStatDefinition.Unit.METRES),
		},
		{
			"what": "an unsupported calculation mode",
			"record": PlayerStatDefinition.of(&"probe", "Probe",
				PlayerStatDefinition.Category.UTILITY,
				(99 as PlayerStatDefinition.Mode),
				PlayerStatDefinition.Unit.METRES),
		},
		{
			"what": "an unrecognised unit",
			"record": PlayerStatDefinition.of(&"probe", "Probe",
				PlayerStatDefinition.Category.UTILITY,
				PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
				(99 as PlayerStatDefinition.Unit)),
		},
		{
			"what": "a rate stat not measured in seconds",
			"record": PlayerStatDefinition.of(&"probe", "Probe",
				PlayerStatDefinition.Category.UTILITY,
				PlayerStatDefinition.Mode.INCREASED_RATE,
				PlayerStatDefinition.Unit.METRES),
		},
		{
			"what": "a duration declared as multiplied",
			"record": PlayerStatDefinition.of(&"probe", "Probe",
				PlayerStatDefinition.Category.UTILITY,
				PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
				PlayerStatDefinition.Unit.SECONDS),
		},
	]
	for case: Dictionary in invalid:
		var record: PlayerStatDefinition = case["record"]
		if record != null:
			_expect(not record.problem().strip_edges().is_empty(),
				"%s was reported coherent" % case["what"])
		var value: PlayerStatValue = PlayerStats.apply_definition(record, 10.0, 0.10)
		_expect(not value.ok, "%s produced a value" % case["what"])
		_expect(not value.failure_reason.strip_edges().is_empty(),
			"%s was refused without a reason" % case["what"])
		_expect_no_partial_value(value, String(case["what"]))

	## A valid record handed straight to the calculation still works, so the
	## definition-taking entry point is not refusing everything.
	var valid: PlayerStatDefinition = PlayerStatDefinition.of(
		&"probe", "Probe", PlayerStatDefinition.Category.UTILITY,
		PlayerStatDefinition.Mode.INCREASED_MULTIPLIER, PlayerStatDefinition.Unit.METRES)
	var probe_value: PlayerStatValue = PlayerStats.apply_definition(valid, 10.0, 0.10)
	_expect(probe_value.ok and is_equal_approx(probe_value.value, 11.0),
		"a valid definition handed straight in produced %s" % probe_value.describe())

	## A DUPLICATE DEFINITION is reported by the vocabulary's own validation
	## rather than only by the calculation, and the shipped vocabulary carries
	## none.
	_expect(PlayerStats.problems().is_empty(),
		"the shipped vocabulary reports: %s" % ", ".join(PlayerStats.problems()))
	var duplicate_report: PackedStringArray = _problems_for([
		PlayerStatDefinition.of(&"one", "One", PlayerStatDefinition.Category.UTILITY,
			PlayerStatDefinition.Mode.INCREASED_MULTIPLIER, PlayerStatDefinition.Unit.METRES),
		PlayerStatDefinition.of(&"one", "One Again", PlayerStatDefinition.Category.UTILITY,
			PlayerStatDefinition.Mode.INCREASED_MULTIPLIER, PlayerStatDefinition.Unit.METRES),
	])
	_expect(duplicate_report.size() == 1 and String(duplicate_report[0]).contains("duplicate"),
		"a duplicated stat id was reported as %s" % str(duplicate_report))
	_expect(_problems_for([
			PlayerStatDefinition.of(&"one", "One", PlayerStatDefinition.Category.UTILITY,
				PlayerStatDefinition.Mode.INCREASED_MULTIPLIER, PlayerStatDefinition.Unit.METRES),
			PlayerStatDefinition.of(&"two", "Two", PlayerStatDefinition.Category.UTILITY,
				PlayerStatDefinition.Mode.INCREASED_MULTIPLIER, PlayerStatDefinition.Unit.METRES),
		]).is_empty(),
		"two distinct definitions were reported as duplicates")

	## A RESULT THAT DOES NOT MATCH ITS OWN DERIVATION is caught, so the
	## coherence assertion used everywhere above is itself capable of failing.
	var tampered: PlayerStatValue = PlayerStatValue.computed(
		PlayerStats.GLOBAL_DAMAGE, 100.0, 0.30, 1.30,
		PlayerStatDefinition.Mode.INCREASED_MULTIPLIER, 999.0)
	_expect(not tampered.problem().is_empty(),
		"a value that contradicts its own derivation was reported coherent")
	var bad_mode: PlayerStatValue = PlayerStatValue.computed(
		PlayerStats.GLOBAL_DAMAGE, 100.0, 0.30, 1.30,
		(99 as PlayerStatDefinition.Mode), 130.0)
	_expect(not bad_mode.problem().is_empty(),
		"a value carrying an unrecognised mode was reported coherent")
	var partial: PlayerStatValue = PlayerStatValue.failed("a reason")
	partial.stat_id = PlayerStats.GLOBAL_DAMAGE
	_expect(not partial.problem().is_empty(),
		"a failed value carrying a partial selection was reported coherent")
	_expect(PlayerStatValue.failed("").failure_reason.length() > 0,
		"a failure built with no reason states nothing")

	print("  7 accumulator refusals, 8 unsafe calculations, 8 invalid definitions, "
		+ "1 duplicate id, 3 incoherent results — all refused with a reason and no partial value")
	_done("every_invalid_input_fails_closed")


# --- 7. The foundation is generic ----------------------------------------------

func _check_the_foundation_is_generic_and_reads_nothing_ambient() -> void:
	print("")
	print("--- 7. The four scripts name no class, Skill, support or card, and read nothing ambient")

	var scanned: int = 0
	for path: String in FOUNDATION_FILES:
		if not FileAccess.file_exists(path):
			_expect(false, "%s is missing" % path)
			continue
		## RAW, comments included.
		var source: String = FileAccess.get_file_as_string(path)
		var named: PackedStringArray = PackedStringArray()
		for token: String in FORBIDDEN_TOKENS:
			if source.contains(token):
				named.append(token)
		_expect(named.is_empty(), "%s names %s" % [path.get_file(), ", ".join(named)])
		var ambient: PackedStringArray = PackedStringArray()
		for token: String in AMBIENT_TOKENS:
			if source.contains(token):
				ambient.append(token)
		_expect(ambient.is_empty(),
			"%s reads ambient state: %s" % [path.get_file(), ", ".join(ambient)])
		scanned += 1
	_expect(scanned == FOUNDATION_FILES.size(),
		"%d of %d foundation scripts were scanned" % [scanned, FOUNDATION_FILES.size()])

	## THE SCAN IS PROVED CAPABLE OF FAILING, by showing it finding its own
	## tokens in the one file that legitimately holds them: this one.
	var own: String = FileAccess.get_file_as_string(
		"res://tests/player_stat_vocabulary_verification.gd")
	var found_here: int = 0
	for token: String in FORBIDDEN_TOKENS:
		if own.contains(token):
			found_here += 1
	_expect(found_here >= 10,
		"the forbidden-token scan found only %d of its own tokens and may be inert" % found_here)
	var ambient_here: int = 0
	for token: String in AMBIENT_TOKENS:
		if own.contains(token):
			ambient_here += 1
	_expect(ambient_here >= 3,
		"the ambient scan found only %d of its own tokens and may be inert" % ambient_here)

	## Determinism, measured rather than argued: the same three arguments always
	## produce the same number.
	var first: float = PlayerStats.apply(PlayerStats.GLOBAL_DAMAGE, 137.0, 0.37).value
	var drifted: int = 0
	for _index: int in 100:
		if PlayerStats.apply(PlayerStats.GLOBAL_DAMAGE, 137.0, 0.37).value != first:
			drifted += 1
	_expect(drifted == 0, "%d of 100 identical calculations disagreed" % drifted)

	print("  %d scripts scanned raw: 0 forbidden tokens, 0 ambient reads; "
		% scanned + "the scan finds %d of its own; 100 identical calls agree" % found_here)
	_done("the_foundation_is_generic_and_reads_nothing_ambient")


# --- 8. Presentation is separate ------------------------------------------------

func _check_presentation_is_separate_from_the_arithmetic() -> void:
	print("")
	print("--- 8. Presentation formatting is separate from the arithmetic")

	## The calculation section of the vocabulary reaches no formatting helper.
	## Section-delimited rather than whole-file, because the file legitimately
	## holds a presentation section further down.
	var source: String = FileAccess.get_file_as_string("res://scripts/stats/player_stats.gd")
	var start: int = source.find("# --- The one calculation path")
	var end: int = source.find("# --- Presentation")
	_expect(start > 0 and end > start,
		"the calculation and presentation sections could not be located")
	var calculation: String = source.substr(start, end - start)
	_expect(not calculation.contains("format_"),
		"the calculation path formats a value")
	_expect(not calculation.contains("describe("),
		"the calculation path builds a description")
	_expect(calculation.contains("base_value * scale") and calculation.contains("base_value / scale"),
		"the calculation path does not hold both modes")

	## Values are normalized throughout: a successful value carries numbers and
	## no text at all.
	var value: PlayerStatValue = PlayerStats.apply(PlayerStats.GLOBAL_DAMAGE, 100.0, 0.30)
	_expect(value.ok and value.failure_reason.is_empty(),
		"a successful value carries text: '%s'" % value.failure_reason)
	_expect(is_equal_approx(value.total_increased, 0.30),
		"the value stores %.6f rather than the normalized 0.30" % value.total_increased)

	## Formatting is pure and cannot change a number.
	_expect(PlayerStats.format_increased(0.30) == "+30%",
		"0.30 formats as '%s'" % PlayerStats.format_increased(0.30))
	_expect(PlayerStats.format_increased(-0.20) == "-20%",
		"-0.20 formats as '%s'" % PlayerStats.format_increased(-0.20))
	_expect(PlayerStats.format_increased(0.0) == "+0%",
		"0.0 formats as '%s'" % PlayerStats.format_increased(0.0))
	_expect(PlayerStats.format_value(PlayerStats.SKILL_SPEED, 0.64) == "0.64 seconds",
		"a value formats as '%s'" % PlayerStats.format_value(PlayerStats.SKILL_SPEED, 0.64))
	for _index: int in 10:
		PlayerStats.format_increased(0.30)
	_expect(PlayerStats.apply(PlayerStats.GLOBAL_DAMAGE, 100.0, 0.30).value == value.value,
		"formatting changed a subsequent calculation")

	print("  the calculation section names no formatter; 0.30 displays as +30% and stores as 0.30")
	_done("presentation_is_separate_from_the_arithmetic")


# --- 9. Nothing existing changed ------------------------------------------------

func _check_nothing_existing_changed() -> void:
	print("")
	print("--- 9. C1 is unwired, and nothing that already existed moved")

	## NOTHING BUT THE AUTHORIZED READERS REFERENCES IT. C1 defines a vocabulary;
	## no runtime integration is authorized, so the only files that may name any
	## of its four classes are the four themselves, this suite, and the two
	## Foundation C2 records D-231 authorizes to derive from it. Still no scene,
	## no runtime, no selector and no application.
	var scanned: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if FOUNDATION_FILES.has(path):
				continue
			scanned += 1
			var source: String = FileAccess.get_file_as_string(path)
			for name: String in FOUNDATION_CLASSES:
				if not source.contains(name):
					continue
				if _is_authorized_reader(path, name):
					continue
				referenced.append("%s names %s" % [path.get_file(), name])
	_expect(referenced.is_empty(),
		"Foundation C1 is named by code that is not an authorized reader: %s"
			% ", ".join(referenced))
	_expect(scanned > 100, "only %d project files were scanned" % scanned)

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

	## The canonical combat record, untouched — including the action time this
	## suite reads the rate demonstration from.
	var canonical: QuickStrikeData = load(CANONICAL_QUICK_STRIKE) as QuickStrikeData
	_expect(canonical != null, "the canonical Quick Strike record failed to load")
	_expect(is_equal_approx(canonical.action_time, 0.80),
		"action_time moved to %.4f" % canonical.action_time)
	_expect(is_equal_approx(canonical.reach, 1.65), "reach moved to %.4f" % canonical.reach)
	_expect(is_equal_approx(canonical.release_arc_degrees, 100.0),
		"release_arc_degrees moved to %.4f" % canonical.release_arc_degrees)
	_expect(canonical.maximum_targets == 1,
		"maximum_targets moved to %d" % canonical.maximum_targets)

	print("  %d project files scanned, only authorized readers name an authorized Foundation C1 class; 31 actions"
		% scanned)
	_done("nothing_existing_changed")


# --- Helpers -------------------------------------------------------------------

## Reads the accepted action time from the canonical record, so the rate
## demonstration is made against the project's own number rather than a retyped
## copy of it.
func _load_accepted_action_time() -> bool:
	var canonical: QuickStrikeData = load(CANONICAL_QUICK_STRIKE) as QuickStrikeData
	if canonical == null:
		return false
	_accepted_action_time = canonical.action_time
	return true


## Runs the vocabulary's own duplicate and coherence rules over an arbitrary set
## of definitions, so the validation can be driven against records the shipped
## vocabulary cannot contain.
func _problems_for(records: Array[PlayerStatDefinition]) -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	var seen: Array[StringName] = []
	for record: PlayerStatDefinition in records:
		var record_problem: String = record.problem()
		if not record_problem.is_empty():
			found.append(record_problem)
		if seen.has(record.stat_id):
			found.append("duplicate stat id %s" % record.stat_id)
		seen.append(record.stat_id)
	return found


func _expect_coherent(value: PlayerStatValue, described: String) -> void:
	_expect(value.ok, "%s was refused: %s" % [described, value.failure_reason])
	_expect(value.problem().is_empty(),
		"%s is internally incoherent: %s" % [described, value.problem()])


## A refusal must carry NO partial number: no stat id, no base, no total, no
## scale and no value. This is the assertion that stops a caller reading a
## number out of a calculation that never happened.
func _expect_no_partial_value(value: PlayerStatValue, described: String) -> void:
	_expect(value.problem().is_empty(),
		"%s produced a partial value: %s" % [described, value.problem()])
	_expect(String(value.stat_id).is_empty() and is_zero_approx(value.base_value)
			and is_zero_approx(value.total_increased) and is_zero_approx(value.scale)
			and is_zero_approx(value.value),
		"%s left calculation fields populated: %s" % [described, value.describe()])


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


## Whether `path` is granted `name` by the allowlist above. An exact per-file,
## per-class test: a file not listed is granted nothing, and a listed file is
## granted only the classes written beside it. The shape Foundation B's suite
## already uses, adopted here unchanged (D-241).
func _is_authorized_reader(path: String, name: String) -> bool:
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
