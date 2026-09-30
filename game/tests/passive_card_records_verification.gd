extends SceneTree
## Riftwrought — Roguelite Foundation C2 verification: Passive Card Records
## (decision D-231).
##
## ONE FOCUSED HEADLESS TEST. The foundation is two pure-logic scripts under
## `scripts/stats/` — a card record and a catalogue of six — so it needs no
## scene, no camera, no navigation, no rendering and no evidence frame, and it
## deliberately gets none. It runs as a `SceneTree` script exactly as all three
## earlier foundations' suites do.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## THE EXPECTED SIX ARE WRITTEN OUT HERE, NOT READ FROM THE CATALOGUE. A check
## that takes its expected answer from the thing it is checking proves only that
## a file agrees with itself. Every id, name, stat, magnitude and description
## below is typed independently, so a record that changed would turn this suite
## red rather than move with it.
##
## "DERIVED RATHER THAN DUPLICATED" IS PROVED TWICE, AND THE SECOND WAY IS THE
## ONE THAT MATTERS. Asserting that a card's category equals the vocabulary's is
## satisfied by a card that derives it AND by one that happens to restate it
## correctly today. So the two records are also SCANNED RAW for the ten enum
## members a restatement would have to name, and the scan is proved capable of
## failing by finding all ten in the one file that legitimately holds them.
##
## THE TEST DATA IS NOT CONTENT. Every fabricated card and stat definition built
## below lives inside this file only, is registered in no catalogue, ships in no
## scene, no `.tres` and no library, and is not canon.

## The two scripts this foundation owns. NEITHER may name a concrete class,
## Skill, support or card. Scanned RAW, comments included — D-215's lesson: an
## illustrative name in a comment breaches the rule just as surely as a real one.
const CARD_FILES: Array[String] = [
	"res://scripts/stats/passive_card_definition.gd",
	"res://scripts/stats/passive_card_catalogue.gd",
]

## Concrete class, Skill, support and card names. The same list Foundation C1
## is held to, unchanged, because C2 is held to the same boundary.
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

## A pure record layer may read no ambient state whatsoever.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
]

## The parts of the vocabulary C2 must NOT reach. It RECORDS cards; it never
## accumulates a modifier and never applies one, so the accumulator, the result
## type and the calculation entry point are all out of bounds. Naming them is
## how a record layer quietly becomes a runtime one.
const CALCULATION_TOKENS: Array[String] = [
	"PlayerStatValue", "PlayerStatTotals", "PlayerStats.apply",
]

## The ten enum members a restated category, mode or unit would have to name.
## A record that DERIVES the three cannot contain any of them.
##
## ONE OVERLAP IS RECORDED RATHER THAN LEFT TO BE FOUND: `Unit.METRES` is a
## substring of `Unit.METRES_PER_SECOND`, so the inertness control below counts
## ten members over nine distinct spellings. That makes the scan stricter rather
## than weaker — a file naming only the longer one is reported for both — and it
## is why the property-list assertion, not this scan, is the load-bearing proof.
const RESTATED_FACT_TOKENS: Array[String] = [
	"Category.COMBAT_DEFENCE", "Category.UTILITY",
	"Mode.INCREASED_MULTIPLIER", "Mode.INCREASED_RATE",
	"Unit.DAMAGE_POINTS", "Unit.SECONDS", "Unit.LIFE_POINTS",
	"Unit.METRES_PER_SECOND", "Unit.EXPERIENCE_POINTS", "Unit.METRES",
]

## The one file that legitimately holds all ten, used to prove the scan above is
## not inert.
const VOCABULARY_FILE: String = "res://scripts/stats/player_stats.gd"

## The two global class names this foundation introduces. NOTHING may reference
## either of them: C2 defines records and is deliberately unwired — no selector,
## no offer generator, no runtime application.
const CARD_CLASSES: Array[String] = ["PassiveCardDefinition", "PassiveCardCatalogue"]

## THE FILES AUTHORIZED TO NAME A FOUNDATION C2 CLASS, AND THE EXACT CLASSES EACH
## MAY NAME. Foundation C3's selector and result take card RECORDS as arguments
## and read the category each one derives, so naming the record type is the whole
## point of them rather than a breach of the boundary. This replaces D-231's
## blanket "not one file names either new class" ONE FOR ONE: the same single
## assertion is made either way, it still fails for any other file AND for any
## class a listed file is not granted, and the pinned count does not move.
##
## THE GRANT IS PER FILE AND PER CLASS, WHICH IS WHY THE TABLE HAS THIS SHAPE
## (D-244). It was a flat list of paths beside a flat list of classes until the
## Foundation D3 choice transaction needed the CATALOGUE — and adding the
## catalogue to a flat class list would have handed it to all four earlier
## readers as a side effect of admitting a fifth, which is exactly the boundary
## the comment below exists to keep. The conversion is the same one D-241 made to
## the Foundation C1 suite for the same reason, and it is ONE FOR ONE: the same
## single assertion is made either way and the pinned count does not move.
##
## A SELECTOR THAT NAMED THE CATALOGUE WOULD BE A GENERIC MECHANISM QUIETLY
## BECOMING THE SHIPPED SIX'S OWN, and it is still refused here by the same row
## that refuses any other file. The one file granted the catalogue is granted it
## because resolving a stable card id through the canonical catalogue IS its
## authorized mechanism rather than an incidental convenience.
const AUTHORIZED_READERS: Array = [
	["res://scripts/stats/passive_card_selection.gd", ["PassiveCardDefinition"]],
	["res://scripts/stats/passive_card_selection_result.gd", ["PassiveCardDefinition"]],
	## D-239: the Foundation D1 offer composer takes the complete card record set
	## as an argument and hands it to the accepted selector, so it names the
	## record TYPE for the same reason the selector does. The D1 offer beside it
	## names no Foundation C2 class at all.
	["res://scripts/offers/rift_offer_composition.gd", ["PassiveCardDefinition"]],
	## D-241: the Foundation D2 run-build state is HANDED a card record and asks
	## it whether it is valid, whether it may be repeated, which stat it moves and
	## by how much — so it names the record TYPE for the same reason the selector
	## does, and the catalogue no more than the selector may.
	["res://scripts/runs/rift_run_build.gd", ["PassiveCardDefinition"]],
	## D-244: the Foundation D3 choice transaction is given a card ID by an offer
	## and must resolve it through the CANONICAL catalogue before anything is
	## acquired — the stable id is the choice authority and the registered record
	## is the effect — so it is the one authorized reader that names both. Its
	## result type and the consumption ledger beside it name neither.
	["res://scripts/choices/rift_offer_choice.gd",
		["PassiveCardDefinition", "PassiveCardCatalogue"]],
	## D-248: the Foundation E2 level-up coordinator takes the complete card
	## record set as an argument and hands it to the accepted composition
	## mechanism, so it names the record TYPE for the same reason the composer
	## does — and names the CATALOGUE not at all, because resolving an offered id
	## through the canonical catalogue belongs to the choice transaction and a
	## coordinator that did it too would be a second place for one rule.
	["res://scripts/levels/rift_level_up_coordinator.gd", ["PassiveCardDefinition"]],
	## Foundation G4 (decision D-269): the repeated run-level coordinator takes the
	## complete card record set as an argument and forwards it, unread, to the
	## accepted one-level coordinator when it opens the current level's offer. It
	## names the record TYPE and the catalogue not at all. Added one for one, and
	## the pinned count does not move.
	["res://scripts/levels/rift_run_level_coordinator.gd", ["PassiveCardDefinition"]],
	## Foundation I1 (decision D-291): the H8 Experience-Mote runtime is handed the
	## complete card record set when its owner asks it to open the current level's
	## offer, and hands it, unread, straight to that coordinator. It names the record
	## TYPE, the catalogue not at all, and holds none. Added one for one, and the
	## pinned count does not move.
	["res://scripts/experience/rift_mote_runtime.gd", ["PassiveCardDefinition"]],
	## Roguelite I2 (decision D-293): the Playable Three-Lane Level-Up Choice Review — an
	## isolated scene launched by name — hands the catalogue's complete record set to
	## its one level-up offer, and resolves each passive card the offer holds through
	## the CANONICAL catalogue for the name and the effect line the card shows. Resolving
	## a stable id canonically for display is its authorized presentation, exactly as it
	## is the transaction's mechanism, so it is the second reader granted both. It holds
	## no record. Added one for one, and the pinned count does not move.
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd",
		["PassiveCardDefinition", "PassiveCardCatalogue"]],
	## Roguelite Foundation I6 (decision D-304): the exhausted-support passive
	## fallback is handed the complete card record set, asks the accepted selector
	## whether it is coherent, reads each record's id and DERIVED category to count
	## what remains once the two offered cards are excluded, and hands the set,
	## unchanged, to that selector's exclusion-aware draw. It names the record TYPE
	## and the catalogue not at all; its result names no Foundation C2 class. Added
	## one for one, and the pinned count does not move.
	["res://scripts/fallback/support_exhaustion_passive_fallback.gd", ["PassiveCardDefinition"]],
]

const SCANNED_ROOTS: Array[String] = ["res://scripts", "res://scenes", "res://data"]

## card id, presentation name, stat id, normalized magnitude, effect line, and
## the category, mode and unit the card must DERIVE.
##
## THE LAST THREE ARE TYPED HERE ON PURPOSE. Comparing a card's derived category
## against `PlayerStats.definition(...).category` reads both sides out of the
## same function and cannot fail for any card, correct or not. Pinning them
## against an answer written independently is what makes those assertions
## capable of going red — and it is also what catches a card deriving the wrong
## stat's facts perfectly.
const EXPECTED_CARDS: Array = [
	["card_power", "Power", "global_damage", 0.10, "+10% Global Damage",
		PlayerStatDefinition.Category.COMBAT_DEFENCE,
		PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
		PlayerStatDefinition.Unit.DAMAGE_POINTS],
	["card_celerity", "Celerity", "skill_speed", 0.10, "+10% Skill Speed",
		PlayerStatDefinition.Category.COMBAT_DEFENCE,
		PlayerStatDefinition.Mode.INCREASED_RATE,
		PlayerStatDefinition.Unit.SECONDS],
	["card_vitality", "Vitality", "maximum_life", 0.15, "+15% Maximum Life",
		PlayerStatDefinition.Category.COMBAT_DEFENCE,
		PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
		PlayerStatDefinition.Unit.LIFE_POINTS],
	["card_fleetness", "Fleetness", "movement_speed", 0.10, "+10% Movement Speed",
		PlayerStatDefinition.Category.UTILITY,
		PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
		PlayerStatDefinition.Unit.METRES_PER_SECOND],
	["card_insight", "Insight", "experience_gain", 0.10, "+10% Experience Gain",
		PlayerStatDefinition.Category.UTILITY,
		PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
		PlayerStatDefinition.Unit.EXPERIENCE_POINTS],
	["card_magnetism", "Magnetism", "pickup_radius", 0.25, "+25% Pickup Radius",
		PlayerStatDefinition.Category.UTILITY,
		PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
		PlayerStatDefinition.Unit.METRES],
]

## The six authored fields a record may carry, in order. Pinned as NAMES rather
## than as a count, because the fault this guards against — a cached copy of a
## derived fact — arrives as a seventh field with a plausible name.
const EXPECTED_FIELDS: Array[String] = [
	"card_id", "display_name", "stat_id", "magnitude", "base_weight", "repeatable",
]

## The only project classes the two records may name. An ALLOWLIST derived from
## the engine's own global class list, not a denylist of remembered names: the
## Zone Composer found that a denylist cannot see a class nobody thought to add
## to it.
const AUTHORIZED_CLASSES: Array[String] = [
	"PassiveCardDefinition", "PassiveCardCatalogue", "PlayerStats", "PlayerStatDefinition",
]

## The Foundation C1 suite, which must allow exactly these two files to name its
## vocabulary. Two independently typed copies of one list is how they drift.
const VOCABULARY_SUITE: String = "res://tests/player_stat_vocabulary_verification.gd"

## The classes a RECORD layer must never name, checked against the same C1
## vocabulary these records derive from.
const VOCABULARY_CLASSES: Array[String] = [
	"PlayerStats", "PlayerStatDefinition", "PlayerStatValue", "PlayerStatTotals",
]

## Written out rather than read from the catalogue, for the same reason the
## table above is.
const EXPECTED_WEIGHT: int = 100

const OWED_CHECKS: Array[String] = [
	"all_six_records_resolve_to_the_correct_canonical_stats",
	"category_mode_and_unit_are_derived_rather_than_duplicated",
	"magnitudes_format_correctly",
	"every_base_offer_weight_is_equal",
	"every_review_passive_is_repeatable",
	"every_invalid_record_fails_with_a_reason",
	"card_ids_obey_the_stable_id_contract",
	"the_records_name_no_class_or_concrete_skill",
]

## The stable-id contract, exercised against the owner's literal pattern. Each
## row is an id and whether it is legal. The refused ones are refused for one
## named reason each: a space inside, a leading space, a trailing space, a
## capital, a leading digit, a leading underscore, a hyphen and a dot.
const ID_CASES: Array = [
	["card_power", true],
	["card_power2", true],
	["c", true],
	["card power", false],
	[" card_power", false],
	["card_power ", false],
	["Card_Power", false],
	["1card", false],
	["_card", false],
	["card-power", false],
	["card.power", false],
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation C2 — Passive Card Records (D-231) ===")

	_check_all_six_records_resolve_to_the_correct_canonical_stats()
	_check_category_mode_and_unit_are_derived_rather_than_duplicated()
	_check_magnitudes_format_correctly()
	_check_every_base_offer_weight_is_equal()
	_check_every_review_passive_is_repeatable()
	_check_every_invalid_record_fails_with_a_reason()
	_check_card_ids_obey_the_stable_id_contract()
	_check_the_records_name_no_class_or_concrete_skill()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("PASSIVE CARD RECORDS VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("PASSIVE CARD RECORDS VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. The six records resolve to the right stats -----------------------------

func _check_all_six_records_resolve_to_the_correct_canonical_stats() -> void:
	print("")
	print("--- 1. The six review cards, and the stats they resolve to")

	## POSITIVE CONTROL FIRST. A validator that refuses everything protects
	## nothing, so the shipped catalogue must be clean before any refusal below
	## means anything.
	var shipped: PackedStringArray = PassiveCardCatalogue.problems()
	_expect(shipped.is_empty(), "the shipped catalogue reports: %s" % ", ".join(shipped))

	var records: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	_expect(records.size() == EXPECTED_CARDS.size(),
		"the catalogue holds %d records, not %d" % [records.size(), EXPECTED_CARDS.size()])
	_expect(PassiveCardCatalogue.ALL.size() == EXPECTED_CARDS.size(),
		"the canonical order holds %d ids, not %d" % [
			PassiveCardCatalogue.ALL.size(), EXPECTED_CARDS.size(),
		])

	var covered: Array[StringName] = []
	for row: Array in EXPECTED_CARDS:
		var card_id: StringName = StringName(row[0])
		var card: PassiveCardDefinition = PassiveCardCatalogue.record(card_id)
		if card == null:
			_expect(false, "%s is not in the catalogue" % card_id)
			continue
		_expect(card.display_name == String(row[1]),
			"%s is named '%s', not '%s'" % [card_id, card.display_name, row[1]])
		_expect(String(card.stat_id) == String(row[2]),
			"%s moves %s, not %s" % [card_id, card.stat_id, row[2]])
		var resolved: PlayerStatDefinition = card.stat_definition()
		_expect(resolved != null and resolved.stat_id == card.stat_id,
			"%s does not resolve to the canonical definition of %s" % [card_id, card.stat_id])
		## THE ID IS NOT THE NAME, and not merely a differently-cased copy of it.
		_expect(String(card.card_id).to_lower() != card.display_name.to_lower(),
			"%s and its presentation name '%s' are the same string" % [
				card.card_id, card.display_name,
			])
		covered.append(card.stat_id)

	## EVERY STAT IS COVERED AND NO STAT TWICE — measured in both directions,
	## because "six cards over six stats" is satisfied by five stats and one
	## duplicate.
	var missing_stats: PackedStringArray = PackedStringArray()
	for stat_id: StringName in PlayerStats.ALL:
		if not covered.has(stat_id):
			missing_stats.append(String(stat_id))
	_expect(missing_stats.is_empty(),
		"no review card moves: %s" % ", ".join(missing_stats))
	var duplicated: PackedStringArray = PackedStringArray()
	for stat_id: StringName in PlayerStats.ALL:
		if covered.count(stat_id) > 1:
			duplicated.append(String(stat_id))
	_expect(duplicated.is_empty(), "more than one review card moves: %s" % ", ".join(duplicated))

	_expect(PassiveCardCatalogue.record(&"card_nothing") == null,
		"an unknown card id resolved to a record instead of null")
	_expect(PassiveCardCatalogue.is_known(&"card_power"), "card_power is not known")
	_expect(not PassiveCardCatalogue.is_known(&"card_nothing"),
		"an unknown card id is reported as known")

	var order: PackedStringArray = PackedStringArray()
	for card_id: StringName in PassiveCardCatalogue.ALL:
		order.append(String(card_id))
	var expected_order: PackedStringArray = PackedStringArray()
	for row: Array in EXPECTED_CARDS:
		expected_order.append(String(row[0]))
	_expect(", ".join(order) == ", ".join(expected_order),
		"the canonical order is %s" % ", ".join(order))

	print("  6 review cards over 6 distinct stats; every id differs from its own name")
	_done("all_six_records_resolve_to_the_correct_canonical_stats")


# --- 2. Derived, not duplicated ------------------------------------------------

func _check_category_mode_and_unit_are_derived_rather_than_duplicated() -> void:
	print("")
	print("--- 2. The category, the mode and the unit are read from the vocabulary")

	## PINNED AGAINST INDEPENDENTLY TYPED ANSWERS, never against the vocabulary
	## the card itself reads. Celerity — the one card whose stat DIVIDES — is
	## written in the catalogue exactly like the five that multiply, so this is
	## where that difference has to show up.
	for row: Array in EXPECTED_CARDS:
		var card: PassiveCardDefinition = PassiveCardCatalogue.record(StringName(row[0]))
		if card == null:
			_expect(false, "%s is missing" % row[0])
			continue
		_expect(card.category() == int(row[5]),
			"%s derives category %d, not the expected %d" % [
				card.card_id, card.category(), int(row[5]),
			])
		_expect(card.mode() == int(row[6]),
			"%s derives mode %d, not the expected %d" % [
				card.card_id, card.mode(), int(row[6]),
			])
		_expect(card.unit() == int(row[7]),
			"%s derives unit %d, not the expected %d" % [
				card.card_id, card.unit(), int(row[7]),
			])

	var combat: int = 0
	var utility: int = 0
	for card: PassiveCardDefinition in PassiveCardCatalogue.records():
		if card.category() == PlayerStatDefinition.Category.COMBAT_DEFENCE:
			combat += 1
		elif card.category() == PlayerStatDefinition.Category.UTILITY:
			utility += 1
	_expect(combat == 3, "%d cards derive the combat and defence category, not 3" % combat)
	_expect(utility == 3, "%d cards derive the utility category, not 3" % utility)

	## THE STRUCTURAL PROOF, AND THE ONE THAT ACTUALLY SEPARATES DERIVING FROM
	## RESTATING CORRECTLY. A record that carried its own copy of any of the
	## three would have to NAME one of the ten enum members.
	var restated_total: int = 0
	for path: String in CARD_FILES:
		var source: String = FileAccess.get_file_as_string(path)
		var restated: PackedStringArray = PackedStringArray()
		for token: String in RESTATED_FACT_TOKENS:
			if source.contains(token):
				restated.append(token)
		restated_total += restated.size()
		_expect(restated.is_empty(),
			"%s restates %s" % [path.get_file(), ", ".join(restated)])

	## AND THE PROOF A TOKEN SCAN CANNOT GIVE. A cached copy of a derived fact
	## need name no enum member at all — `var category: int = 0`, assigned at
	## construction, evades every token above. So the record's authored fields
	## are enumerated from the engine and pinned by NAME: six, in order, and no
	## seventh.
	var fields: PackedStringArray = PackedStringArray()
	for entry: Dictionary in PassiveCardDefinition.new().get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			fields.append(String(entry.get("name", "")))
	_expect(", ".join(fields) == ", ".join(EXPECTED_FIELDS),
		"a passive card record carries the fields: %s" % ", ".join(fields))

	var vocabulary: String = FileAccess.get_file_as_string(VOCABULARY_FILE)
	var found_here: int = 0
	for token: String in RESTATED_FACT_TOKENS:
		if vocabulary.contains(token):
			found_here += 1
	_expect(found_here == RESTATED_FACT_TOKENS.size(),
		"the restatement scan found only %d of %d members in the vocabulary and may be inert" % [
			found_here, RESTATED_FACT_TOKENS.size(),
		])

	## A card naming a stat the vocabulary does not hold answers UNRESOLVED
	## rather than a plausible default.
	var stray: PassiveCardDefinition = PassiveCardDefinition.of(
		&"card_stray", "Stray", &"not_a_stat", 0.10, EXPECTED_WEIGHT, true)
	_expect(stray.category() == PassiveCardDefinition.UNRESOLVED
			and stray.mode() == PassiveCardDefinition.UNRESOLVED
			and stray.unit() == PassiveCardDefinition.UNRESOLVED,
		"an unrecognised stat produced a usable category, mode or unit")
	_expect(stray.stat_display_name().is_empty(),
		"an unrecognised stat produced the name '%s'" % stray.stat_display_name())

	print("  categories, modes and units are read from the vocabulary; "
		+ "%d of %d restated members appear in the %d records, %d appear in the vocabulary; "
			% [restated_total, RESTATED_FACT_TOKENS.size(), CARD_FILES.size(), found_here]
		+ "the %d authored fields are exactly the six" % fields.size())
	_done("category_mode_and_unit_are_derived_rather_than_duplicated")


# --- 3. The descriptions -------------------------------------------------------

func _check_magnitudes_format_correctly() -> void:
	print("")
	print("--- 3. The factual description of every card")

	for row: Array in EXPECTED_CARDS:
		var card: PassiveCardDefinition = PassiveCardCatalogue.record(StringName(row[0]))
		if card == null:
			_expect(false, "%s is not in the catalogue" % row[0])
			continue
		_expect(is_equal_approx(card.magnitude, float(row[3])),
			"%s carries the magnitude %.6f, not %.6f" % [card.card_id, card.magnitude, row[3]])
		_expect(card.effect_line() == String(row[4]),
			"%s describes itself as '%s', not '%s'" % [card.card_id, card.effect_line(), row[4]])

	## THE NAME AND THE PERCENTAGE ARE BOTH DERIVED, PROVED AGAINST THE
	## VOCABULARY REACHED INDEPENDENTLY. Asserting that the line ends with the
	## card's own `stat_display_name()` would compare the expression under test
	## with half of itself and could not fail for any card; this composes the
	## line from the vocabulary's own formatter and the vocabulary's own name,
	## fetched through the stat id this suite typed by hand.
	var fleet: PassiveCardDefinition = PassiveCardCatalogue.record(&"card_fleetness")
	var vocabulary_name: String = PlayerStats.definition(PlayerStats.MOVEMENT_SPEED).display_name
	_expect(vocabulary_name == "Movement Speed",
		"the vocabulary now calls movement_speed '%s'" % vocabulary_name)
	_expect(fleet.effect_line() == "%s %s" % [
			PlayerStats.format_increased(0.10), vocabulary_name,
		],
		"Fleetness's line '%s' is not the vocabulary's percentage beside the vocabulary's name"
			% fleet.effect_line())

	## THE STAT NAME, NOT THE CARD NAME. "Power" describes itself as
	## "+10% Global Damage", which is what a player needs to read.
	_expect(not PassiveCardCatalogue.record(&"card_power").effect_line().contains("Power"),
		"Power's description repeats its own presentation name")
	_expect(not PassiveCardCatalogue.record(&"card_magnetism").effect_line().contains("Magnetism"),
		"Magnetism's description repeats its own presentation name")

	var lines: PackedStringArray = PassiveCardCatalogue.effect_lines()
	var expected_lines: PackedStringArray = PackedStringArray()
	for row: Array in EXPECTED_CARDS:
		expected_lines.append(String(row[4]))
	_expect(", ".join(lines) == ", ".join(expected_lines),
		"the catalogue describes itself as: %s" % ", ".join(lines))

	## With no definition to read a name from, the description is the percentage
	## and nothing else — never a percentage beside a guessed name.
	var stray: PassiveCardDefinition = PassiveCardDefinition.of(
		&"card_stray", "Stray", &"not_a_stat", 0.10, EXPECTED_WEIGHT, true)
	_expect(stray.effect_line() == "+10%",
		"an unrecognised stat described itself as '%s'" % stray.effect_line())

	## The two shipped diagnostics helpers are exercised rather than left
	## untested: a format error in a function nothing calls is still a defect,
	## and this suite is the only thing that will ever call them.
	var power_line: String = PassiveCardCatalogue.record(&"card_power").describe()
	_expect(power_line.contains("+10% Global Damage") and power_line.contains("card_power")
			and power_line.contains("repeatable"),
		"Power describes itself as '%s'" % power_line)
	_expect(PassiveCardCatalogue.lines().size() == EXPECTED_CARDS.size(),
		"the catalogue produced %d description lines, not %d" % [
			PassiveCardCatalogue.lines().size(), EXPECTED_CARDS.size(),
		])

	print("  " + " / ".join(lines))
	_done("magnitudes_format_correctly")


# --- 4. The weights ------------------------------------------------------------

func _check_every_base_offer_weight_is_equal() -> void:
	print("")
	print("--- 4. Every base offer weight is the same positive integer")

	var distinct: Array[int] = []
	for card: PassiveCardDefinition in PassiveCardCatalogue.records():
		_expect(card.base_weight == EXPECTED_WEIGHT,
			"%s carries the weight %d, not %d" % [
				card.card_id, card.base_weight, EXPECTED_WEIGHT,
			])
		if not distinct.has(card.base_weight):
			distinct.append(card.base_weight)
	_expect(distinct.size() == 1,
		"the catalogue carries %d distinct weights, not 1" % distinct.size())
	_expect(EXPECTED_WEIGHT >= PassiveCardDefinition.MINIMUM_BASE_WEIGHT,
		"the review weight is below the minimum")
	_expect(PassiveCardDefinition.MINIMUM_BASE_WEIGHT == 1,
		"the minimum base weight is %d, not 1" % PassiveCardDefinition.MINIMUM_BASE_WEIGHT)

	print("  6 of 6 weights are %d; %d distinct weight" % [EXPECTED_WEIGHT, distinct.size()])
	_done("every_base_offer_weight_is_equal")


# --- 5. Repeatable -------------------------------------------------------------

func _check_every_review_passive_is_repeatable() -> void:
	print("")
	print("--- 5. Every review passive is repeatable")

	var repeatable: int = 0
	for card: PassiveCardDefinition in PassiveCardCatalogue.records():
		_expect(card.repeatable, "%s is not repeatable" % card.card_id)
		if card.repeatable:
			repeatable += 1
	_expect(repeatable == EXPECTED_CARDS.size(),
		"%d of %d review passives are repeatable" % [repeatable, EXPECTED_CARDS.size()])

	print("  %d of %d review passives are repeatable" % [repeatable, EXPECTED_CARDS.size()])
	_done("every_review_passive_is_repeatable")


# --- 6. Everything invalid is refused, with a reason ---------------------------

func _check_every_invalid_record_fails_with_a_reason() -> void:
	print("")
	print("--- 6. Every invalid record and every invalid set is refused, by name")

	## POSITIVE CONTROL. A fabricated card built correctly must be accepted, or
	## none of the refusals below distinguishes a rule from a blanket no.
	var control: PassiveCardDefinition = PassiveCardDefinition.of(
		&"card_control", "Control", PlayerStats.GLOBAL_DAMAGE, 0.10, EXPECTED_WEIGHT, true)
	_expect(control.problem().is_empty(),
		"a correctly built card was refused: %s" % control.problem())

	_expect_refusal(
		PassiveCardDefinition.of(&"card_x", "X", &"not_a_stat", 0.10, EXPECTED_WEIGHT, true),
		"not a recognised player stat", "an unknown stat id")
	_expect_refusal(
		PassiveCardDefinition.of(&"", "X", PlayerStats.GLOBAL_DAMAGE, 0.10, EXPECTED_WEIGHT, true),
		"stable id", "a missing card id")
	_expect_refusal(
		PassiveCardDefinition.of(&"card_x", "  ", PlayerStats.GLOBAL_DAMAGE, 0.10,
			EXPECTED_WEIGHT, true),
		"presentation name", "an empty presentation name")
	_expect_refusal(
		PassiveCardDefinition.of(&"card_x", "X", &"", 0.10, EXPECTED_WEIGHT, true),
		"must name the player stat", "a missing stat id")
	_expect_refusal(
		PassiveCardDefinition.of(&"card_x", "X", PlayerStats.GLOBAL_DAMAGE, 0.0,
			EXPECTED_WEIGHT, true),
		"is not positive", "a zero magnitude")
	_expect_refusal(
		PassiveCardDefinition.of(&"card_x", "X", PlayerStats.GLOBAL_DAMAGE, -0.10,
			EXPECTED_WEIGHT, true),
		"is not positive", "a negative magnitude")
	_expect_refusal(
		PassiveCardDefinition.of(&"card_x", "X", PlayerStats.GLOBAL_DAMAGE, INF,
			EXPECTED_WEIGHT, true),
		"finite", "an infinite magnitude")
	_expect_refusal(
		PassiveCardDefinition.of(&"card_x", "X", PlayerStats.GLOBAL_DAMAGE, NAN,
			EXPECTED_WEIGHT, true),
		"finite", "a magnitude that is not a number")
	_expect_refusal(
		PassiveCardDefinition.of(&"card_x", "X", PlayerStats.GLOBAL_DAMAGE, 0.10, 0, true),
		"base weight", "a base weight of zero")
	_expect_refusal(
		PassiveCardDefinition.of(&"card_x", "X", PlayerStats.GLOBAL_DAMAGE, 0.10, -5, true),
		"base weight", "a negative base weight")

	## THE REDUNDANCY RULE, DRIVEN THROUGH THE ENTRY POINT THAT EXISTS FOR IT.
	## A caller restating a stat's facts must agree with the vocabulary about
	## all three, and each disagreement is named separately.
	var fleetness: PassiveCardDefinition = PassiveCardCatalogue.record(&"card_fleetness")
	_expect_refusal_against(fleetness, null,
		"needs a stat definition", "a validation with no definition at all")
	_expect_refusal_against(fleetness,
		PlayerStatDefinition.of(PlayerStats.GLOBAL_DAMAGE, "Global Damage",
			PlayerStatDefinition.Category.COMBAT_DEFENCE,
			PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
			PlayerStatDefinition.Unit.DAMAGE_POINTS),
		"validated against", "a definition for a different stat")
	_expect_refusal_against(fleetness,
		PlayerStatDefinition.of(PlayerStats.MOVEMENT_SPEED, "Movement Speed",
			PlayerStatDefinition.Category.COMBAT_DEFENCE,
			PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
			PlayerStatDefinition.Unit.METRES_PER_SECOND),
		"restates the category", "a restated category")
	_expect_refusal_against(fleetness,
		PlayerStatDefinition.of(PlayerStats.MOVEMENT_SPEED, "Movement Speed",
			PlayerStatDefinition.Category.UTILITY,
			PlayerStatDefinition.Mode.INCREASED_RATE,
			PlayerStatDefinition.Unit.SECONDS),
		"restates the calculation mode", "a restated calculation mode")
	_expect_refusal_against(fleetness,
		PlayerStatDefinition.of(PlayerStats.MOVEMENT_SPEED, "Movement Speed",
			PlayerStatDefinition.Category.UTILITY,
			PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
			PlayerStatDefinition.Unit.METRES),
		"restates the unit", "a restated unit")
	## An incoherent supplied definition is refused by the vocabulary's own rule
	## rather than re-implemented here.
	_expect_refusal_against(fleetness,
		PlayerStatDefinition.of(PlayerStats.MOVEMENT_SPEED, "Movement Speed",
			PlayerStatDefinition.Category.UTILITY,
			PlayerStatDefinition.Mode.INCREASED_RATE,
			PlayerStatDefinition.Unit.METRES_PER_SECOND),
		"must be measured in seconds", "a supplied definition that is itself incoherent")

	## CATALOGUE-LEVEL FAULTS, driven against fabricated sets because the shipped
	## six cannot contain any of them.
	var duplicated: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	duplicated.append(PassiveCardCatalogue.record(&"card_power"))
	_expect_set_refusal(duplicated, "duplicate card id card_power", "a duplicate card id")

	var short_set: Array[PassiveCardDefinition] = []
	for card: PassiveCardDefinition in PassiveCardCatalogue.records():
		if card.card_id != &"card_magnetism":
			short_set.append(card)
	_expect_set_refusal(short_set,
		"card_magnetism is a review card but the catalogue does not hold it",
		"a catalogue missing one of the six")

	var extra: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	extra.append(PassiveCardDefinition.of(
		&"card_intruder", "Intruder", PlayerStats.MAXIMUM_LIFE, 0.10, EXPECTED_WEIGHT, true))
	_expect_set_refusal(extra, "is not one of the six review cards", "a card that does not belong")

	var holed: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	holed.append(null)
	_expect_set_refusal(holed, "empty record", "an empty entry in the set")

	## A FAULTY RECORD INSIDE AN OTHERWISE COMPLETE SET. Every set above is built
	## from valid records, so none of them proves that a record's own fault
	## reaches the catalogue's verdict — which is the propagation the catalogue
	## exists to perform.
	var faulty: Array[PassiveCardDefinition] = []
	for card: PassiveCardDefinition in PassiveCardCatalogue.records():
		if card.card_id == &"card_insight":
			faulty.append(PassiveCardDefinition.of(
				card.card_id, card.display_name, card.stat_id, 0.0,
				card.base_weight, card.repeatable))
		else:
			faulty.append(card)
	_expect_set_refusal(faulty, "card_insight: the magnitude",
		"a complete set holding one faulty record")

	print("  %d invalid records and sets refused, each with a reason that names the fault"
		% _refusals)
	_done("every_invalid_record_fails_with_a_reason")


# --- 7. The stable-id contract -------------------------------------------------

func _check_card_ids_obey_the_stable_id_contract() -> void:
	print("")
	print("--- 7. Every card id is lower_snake_case, and one containing spaces is refused")

	## THE SIX SHIPPED IDS PASS UNCHANGED. The contract was added to describe
	## what the catalogue already does, not to move it, so this is the assertion
	## that would have blocked the rule if it had been the wrong rule.
	var illegal: PackedStringArray = PackedStringArray()
	for card: PassiveCardDefinition in PassiveCardCatalogue.records():
		if not PassiveCardDefinition.is_legal_id(card.card_id):
			illegal.append(String(card.card_id))
	_expect(illegal.is_empty(), "shipped card id(s) break the contract: %s" % ", ".join(illegal))

	## THE OWNER'S LITERAL PATTERN IS THE ORACLE. The production check is a
	## character test so that a record layer allocates nothing per call; running
	## the actual expression over the same table is what proves the two agree,
	## rather than trusting that a hand-written test says what a pattern says.
	var pattern: RegEx = RegEx.new()
	_expect(pattern.compile(PassiveCardDefinition.ID_PATTERN) == OK,
		"the declared id pattern '%s' does not compile" % PassiveCardDefinition.ID_PATTERN)
	var disagreements: PackedStringArray = PackedStringArray()
	for row: Array in ID_CASES:
		var candidate: String = String(row[0])
		var expected: bool = bool(row[1])
		_expect(PassiveCardDefinition.is_legal_id(StringName(candidate)) == expected,
			"'%s' is judged %s by the contract" % [
				candidate, "legal" if not expected else "illegal",
			])
		if (pattern.search(candidate) != null) != expected:
			disagreements.append(candidate)
	_expect(disagreements.is_empty(),
		"the pattern and the character test disagree on: %s" % ", ".join(disagreements))

	## THE NAMED NEGATIVE CASE, DRIVEN END TO END. An id containing spaces must be
	## refused with a reason that names the contract, and must leave NO usable
	## partial result behind it — not at the record, not through the direct
	## validation entry point, and not in a catalogue that holds it.
	var spaced: PassiveCardDefinition = PassiveCardDefinition.of(
		&"card power", "Power", PlayerStats.GLOBAL_DAMAGE, 0.10, EXPECTED_WEIGHT, true)
	_expect_refusal(spaced, "lower_snake_case", "a card id containing a space")
	_expect(spaced.problem().contains("card power"),
		"the refusal '%s' does not quote the offending id" % spaced.problem())
	_expect(not spaced.problem_against(
			PlayerStats.definition(PlayerStats.GLOBAL_DAMAGE)).is_empty(),
		"a spaced id was accepted through the direct validation entry point")

	## NO PARTIAL CATALOGUE RESULT. A set holding it is refused whole, and the
	## catalogue never answers to the illegal id.
	var holding: Array[PassiveCardDefinition] = PassiveCardCatalogue.records()
	holding.append(spaced)
	_expect_set_refusal(holding, "lower_snake_case", "a catalogue holding a spaced id")
	_expect(not PassiveCardCatalogue.is_known(&"card power"),
		"the catalogue reports a spaced id as known")
	_expect(PassiveCardCatalogue.record(&"card power") == null,
		"the catalogue resolved a record for a spaced id")

	print("  6 of 6 shipped ids obey %s; %d id cases agree with the pattern; a spaced id is refused"
		% [PassiveCardDefinition.ID_PATTERN, ID_CASES.size()])
	_done("card_ids_obey_the_stable_id_contract")


# --- 8. The records are generic ------------------------------------------------

func _check_the_records_name_no_class_or_concrete_skill() -> void:
	print("")
	print("--- 8. The two records name no class or Skill, and reach no calculation")

	var scanned: int = 0
	var forbidden_total: int = 0
	var ambient_total: int = 0
	var applied_total: int = 0
	for path: String in CARD_FILES:
		if not FileAccess.file_exists(path):
			_expect(false, "%s is missing" % path)
			continue
		## RAW, comments included.
		var source: String = FileAccess.get_file_as_string(path)
		var named: PackedStringArray = PackedStringArray()
		for token: String in FORBIDDEN_TOKENS:
			if source.contains(token):
				named.append(token)
		forbidden_total += named.size()
		_expect(named.is_empty(), "%s names %s" % [path.get_file(), ", ".join(named)])
		var ambient: PackedStringArray = PackedStringArray()
		for token: String in AMBIENT_TOKENS:
			if source.contains(token):
				ambient.append(token)
		ambient_total += ambient.size()
		_expect(ambient.is_empty(),
			"%s reads ambient state: %s" % [path.get_file(), ", ".join(ambient)])
		## IT RECORDS A CARD AND NEVER APPLIES ONE. No accumulator, no result
		## type, no calculation entry point.
		var applied: PackedStringArray = PackedStringArray()
		for token: String in CALCULATION_TOKENS:
			if source.contains(token):
				applied.append(token)
		applied_total += applied.size()
		_expect(applied.is_empty(),
			"%s reaches the calculation: %s" % [path.get_file(), ", ".join(applied)])
		scanned += 1
	_expect(scanned == CARD_FILES.size(),
		"%d of %d record scripts were scanned" % [scanned, CARD_FILES.size()])

	## THE SCAN IS PROVED CAPABLE OF FAILING, by showing it finding its own
	## tokens in the one file that legitimately holds them: this one.
	var own: String = FileAccess.get_file_as_string(
		"res://tests/passive_card_records_verification.gd")
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

	## NOTHING BUT THE AUTHORIZED READERS REFERENCES IT. There is still no offer
	## generator and no runtime application; the only files that may name a
	## Foundation C2 class are the two records themselves, this suite, and the two
	## Foundation C3 scripts D-234 authorizes to take card records as arguments —
	## and those may name the RECORD only, never the catalogue.
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if CARD_FILES.has(path):
				continue
			project_files += 1
			var source: String = FileAccess.get_file_as_string(path)
			for name: String in CARD_CLASSES:
				if not source.contains(name):
					continue
				if _is_authorized_reader(path, name):
					continue
				referenced.append("%s names %s" % [path.get_file(), name])
	_expect(referenced.is_empty(),
		"Foundation C2 is named by code that is not an authorized reader: %s"
			% ", ".join(referenced))
	_expect(project_files > 100, "only %d project files were scanned" % project_files)

	## AN ALLOWLIST, NOT ONLY A DENYLIST. The token lists above can only refuse
	## names somebody remembered to add; this asks the ENGINE which project
	## classes exist and requires that the two records name none of them but the
	## four they are entitled to. It is the shape the Zone Composer adopted after
	## a denylist was found unable to see a class nobody had listed.
	var project_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var class_id: String = String(entry.get("class", ""))
		if not class_id.is_empty() and not AUTHORIZED_CLASSES.has(class_id):
			project_classes.append(class_id)
	_expect(project_classes.size() > 20,
		"only %d project classes were enumerated; the allowlist may be inert"
			% project_classes.size())
	for path: String in CARD_FILES:
		var source: String = FileAccess.get_file_as_string(path)
		var outside: PackedStringArray = PackedStringArray()
		for class_id: String in project_classes:
			if source.contains(class_id):
				outside.append(class_id)
		_expect(outside.is_empty(),
			"%s names the unauthorized project class(es) %s" % [
				path.get_file(), ", ".join(outside),
			])

	## THE EXEMPTION THE C1 SUITE GRANTS THESE TWO FILES IS EARNED, AND THE TWO
	## LISTS AGREE. C1 skips these paths when it proves nothing names its
	## vocabulary; if a record stopped naming it, that exemption would quietly
	## become a claim about nothing while still passing.
	for path: String in CARD_FILES:
		var source: String = FileAccess.get_file_as_string(path)
		var named: bool = false
		for class_id: String in VOCABULARY_CLASSES:
			if source.contains(class_id):
				named = true
		_expect(named, "%s names no Foundation C1 class, so its exemption is unearned"
			% path.get_file())
	var suite_source: String = FileAccess.get_file_as_string(VOCABULARY_SUITE)
	var listed: int = 0
	for path: String in CARD_FILES:
		if suite_source.contains(path):
			listed += 1
	_expect(listed == CARD_FILES.size(),
		"the Foundation C1 suite authorizes %d of these %d records by path" % [
			listed, CARD_FILES.size(),
		])

	## Determinism, measured rather than argued.
	var first: String = ", ".join(PassiveCardCatalogue.effect_lines())
	var drifted: int = 0
	for _index: int in 100:
		if ", ".join(PassiveCardCatalogue.effect_lines()) != first:
			drifted += 1
	_expect(drifted == 0, "%d of 100 identical catalogue reads disagreed" % drifted)

	print("  %d records scanned raw: %d forbidden tokens, %d ambient reads, %d calculation reaches; "
		% [scanned, forbidden_total, ambient_total, applied_total]
		+ "of %d project files only authorized readers name a Foundation C2 class; %d of 100 identical reads disagree"
			% [project_files, drifted])
	_done("the_records_name_no_class_or_concrete_skill")


# --- Helpers -------------------------------------------------------------------

## A refusal must be non-empty and must NAME the fault rather than merely report
## that there was one. It deliberately does NOT require the reason to carry the
## card's id: the legitimate empty-id refusal has no id to carry, so a blanket
## rule here would be a rule with an exception rather than a rule.
func _expect_refusal(card: PassiveCardDefinition, expected_fragment: String,
		described: String) -> void:
	_refusals += 1
	var reason: String = card.problem()
	_expect(not reason.is_empty(), "%s was accepted" % described)
	_expect(reason.contains(expected_fragment),
		"%s was refused as '%s', which does not name '%s'" % [
			described, reason, expected_fragment,
		])


func _expect_refusal_against(card: PassiveCardDefinition, record: PlayerStatDefinition,
		expected_fragment: String, described: String) -> void:
	_refusals += 1
	var reason: String = card.problem_against(record)
	_expect(not reason.is_empty(), "%s was accepted" % described)
	_expect(reason.contains(expected_fragment),
		"%s was refused as '%s', which does not name '%s'" % [
			described, reason, expected_fragment,
		])


func _expect_set_refusal(candidate: Array[PassiveCardDefinition], expected_fragment: String,
		described: String) -> void:
	_refusals += 1
	var found: PackedStringArray = PassiveCardCatalogue.problems_in(candidate)
	_expect(not found.is_empty(), "%s was accepted" % described)
	_expect(", ".join(found).contains(expected_fragment),
		"%s was refused as '%s', which does not name '%s'" % [
			described, ", ".join(found), expected_fragment,
		])


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
## granted only the classes written beside it.
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
