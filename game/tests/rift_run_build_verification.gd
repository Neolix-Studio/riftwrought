extends SceneTree
## Riftwrought — Roguelite Foundation D2 verification: the temporary Rift
## run-build state (decision D-241).
##
## ONE FOCUSED HEADLESS TEST. The foundation is a single pure-logic script under
## `scripts/runs/`, so it needs no scene, no camera, no navigation, no rendering
## and no evidence frame, and it deliberately gets none. It runs as a `SceneTree`
## script exactly as all six earlier foundations' suites do.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## THE ATOMICITY PROOFS COMPARE THE WHOLE STATE, NOT THE PART THAT WAS TOUCHED.
## Every refusal in this suite is checked against a COMPLETE snapshot taken
## immediately before it — every support pair, every card count, every stat total
## rendered to seventeen significant digits, and every contribution count — so a
## refusal that recorded a card count without its modifier, or a modifier without
## its count, is caught by the same assertion that catches a refusal that
## recorded everything. Checking only the field the operation was about is how a
## partial mutation survives a green suite.
##
## THE STATE IS SEEDED BEFORE EVERY ATOMICITY PROOF, ON PURPOSE. "Nothing
## changed" is nearly free to satisfy on an empty record; it is a real claim only
## when there is something there to disturb.
##
## THE TEST DATA IS NOT CONTENT. Every fabricated Skill id, support id and card
## record built below lives inside this file only, is registered in no catalogue,
## ships in no scene, no `.tres` and no library, and is not canon. The six
## shipped cards appear here as the FIXTURE the project can actually author
## today; no production file names any of them, which is the property check 11
## proves for the run-build state itself.

## The one script this foundation owns. It may name no concrete Skill, support,
## card, catalogue or presentation label. Scanned RAW, comments included —
## D-215's lesson: an illustrative name in a comment breaches the rule just as
## surely as a real one.
const RUN_BUILD_FILE: String = "res://scripts/runs/rift_run_build.gd"

const D2_FILES: Array[String] = ["res://scripts/runs/rift_run_build.gd"]

## The one global class name this foundation introduces. Nothing that runs may
## reference it except an authorized reader below: D2 accumulates, and
## accumulating is still all it does — no offer, no experience, no level, no
## application to any actor, no scene.
const D2_CLASSES: Array[String] = ["RiftRunBuild"]

## THE FILES AUTHORIZED TO NAME THE FOUNDATION D2 CLASS, AND THE EXACT CLASSES
## EACH MAY NAME (D-244). The Foundation D3 choice transaction DUPLICATES the
## supplied run build and stages one offered lane onto the copy through this
## state's own accepted operations; its result type carries the new build the
## transaction produced. Both therefore name the state for the same reason: it is
## the value they are handed and the value they return. The consumption ledger
## beside them names it not at all, which is what keeps that file's own boundary
## — it records which offers were spent and nothing about what they granted.
##
## THIS REPLACES D-241's BLANKET "no file that runs may name this class" ONE FOR
## ONE: the same single assertion is made either way, it still fails for any
## other file AND for any class a listed file is not granted, and the pinned
## count does not move.
const AUTHORIZED_READERS: Array = [
	["res://scripts/choices/rift_offer_choice.gd", ["RiftRunBuild"]],
	["res://scripts/choices/rift_offer_choice_result.gd", ["RiftRunBuild"]],
	## D-248: the Foundation E2 level-up coordinator OWNS one of these for the
	## lifecycle it coordinates — it stages a copy, hands that copy to the
	## accepted choice transaction, commits the new one the transaction returns,
	## and answers every reading about it with a duplicate. It therefore names
	## the state for the same reason the transaction does: it is the value it
	## holds and the value it hands out. Added one for one, and the pinned count
	## does not move.
	["res://scripts/levels/rift_level_up_coordinator.gd", ["RiftRunBuild"]],
	## Foundation G4 (decision D-269): the repeated run-level coordinator answers
	## its run-build reading by handing on the duplicate its current one-level
	## lifecycle makes. It holds no build of its own and mutates none; it names the
	## state because it is the type of the copy it hands out. Added one for one,
	## and the pinned count does not move.
	["res://scripts/levels/rift_run_level_coordinator.gd", ["RiftRunBuild"]],
	## Roguelite I3 (decision D-295): three running files name the state, each for the
	## reason written beside it. The H8 Experience-Mote runtime's one build reading hands
	## on the copy its run makes; it holds no build and mutates none. The one run-build
	## application seam is HANDED a complete snapshot and reads its totals, pairs and
	## ranks; it constructs none and changes none. The live-effect review asks the
	## runtime for that copy after a choice, and makes one EMPTY build to restore every
	## baseline when an expedition ends. Added one for one: the same single assertion is
	## made either way, it still fails for any other file AND for any class a listed file
	## is not granted, and the pinned count does not move.
	["res://scripts/experience/rift_mote_runtime.gd", ["RiftRunBuild"]],
	["res://scripts/roguelite/live_effects/rift_build_application.gd", ["RiftRunBuild"]],
	["res://scripts/roguelite/live_effects/roguelite_live_effect_review.gd", ["RiftRunBuild"]],
]

## Concrete Skill, support, card, catalogue and instrument names, plus the two
## presentation fields. The same list the six earlier foundations are held to.
const FORBIDDEN_TOKENS: Array[String] = [
	"QuickStrike", "quick_strike", "Quick Strike",
	"PrototypePlayer", "PrototypeWeaponData", "PrototypeGraveblade",
	"PassiveEffects", "PassiveGraph", "PassiveNodeData",
	"RogueliteUpgrade", "RogueliteRunBoon", "RogueliteBuildState", "RogueliteRunPlan",
	"SkillSupportCatalogue", "SkillTags", "SupportEligibility", "SkillTagProfile",
	"SupportDefinition", "SupportSelection", "SupportSelectionResult",
	"PassiveCardCatalogue", "PassiveCardSelection", "PassiveCardSelectionResult",
	"RiftOffer", "RiftOfferComposition",
	"PlayerStats", "PlayerStatDefinition", "PlayerStatValue",
	"FirstMvpSkill", "CharacterState", "ExperienceTable", "PlayerLoadout",
	"Faultbreaker", "Splinter Shot", "Emberbolt", "Marrowshot",
	"Reaching Edge", "reaching_edge", "Sweeping Edge", "sweeping_edge",
	"Expedition Blade", "Quickened Edge", "Quickened Form",
	"First Fracture", "first_fracture", "Graveblade", "Riftmarked",
	"card_power", "card_celerity", "card_vitality",
	"card_fleetness", "card_insight", "card_magnetism",
	"display_name", "base_weight",
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
## claim. The run-build state's own header says in plain English that it does not
## validate eligibility, holds no experience and has no reset — so a raw scan for
## `eligib`, `experience` or `reset` would be red on exactly the file that
## promises none of them. The concrete-name scan above stays RAW, where the
## opposite rule applies: an illustrative card id in a comment is still a card id.
##
## ONE TOKEN MOVED FORWARD BY AUTHORIZATION, AND IT IS RECORDED RATHER THAN
## QUIETLY DROPPED. Foundation F1 authorizes exactly one thing this list used to
## forbid — a RANK on an already-acquired Skill/support pair — so the blanket
## `"rank"` became false for this file the moment that was authorized. It is
## replaced ONE FOR ONE by the three balance concepts F1 explicitly excludes and
## that remain deferred: a gameplay maximum rank, a per-rank cap and a
## diminishing return. The same single assertion is made either way, the guard is
## not weakened into vacuity, and the pinned count does not move. Ranked-offer
## SELECTION and rank EFFECTS are still forbidden here by `"offer"`, `"lane"` and
## `"apply"`, which did not move.
const DEFERRED_MEMBER_TOKENS: Array[String] = [
	"experience", "mote", "level", "xp",
	"offer", "lane", "reroll", "skip", "ban", "lock", "luck", "rarity", "pity",
	"eligib", "exhaust", "refine",
	"rank_cap", "max_rank", "maximum_rank", "diminish",
	"save", "persist", "storage", "schema",
	"reset", "abandon", "death", "nexus",
	"apply", "actor", "base_value", "current_life",
]

## The arithmetic this file must be unable to do. Percentages are added by the
## accepted accumulator and applied by nothing here, so the source multiplies
## nothing, divides nothing and carries no floating-point literal at all — the
## strongest available form of "it performs no percentage arithmetic itself".
const FORBIDDEN_OPERATORS: Array[String] = ["*", "/"]

## The only project classes the run-build state may name. An ALLOWLIST derived
## from the engine's own global class list, not a denylist of remembered names:
## the Zone Composer found that a denylist cannot see a class nobody thought to
## add to it.
const AUTHORIZED_CLASSES: Array[String] = [
	"RiftRunBuild", "AcquiredSupports", "PlayerStatTotals", "PassiveCardDefinition",
]

## `res://addons` IS SCANNED TOO. An editor plugin is code that runs; a reference
## from one would load this class while a scripts/scenes/data scan reported
## nothing. `project.godot` is checked separately, because an `[autoload]` entry
## names a class from a file no extension filter would reach.
const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]

const PROJECT_SETTINGS_FILE: String = "res://project.godot"

## THE PROOF A TOKEN SCAN CANNOT GIVE. A reset rule, a persistence step, an
## experience counter or a second accumulator need name nothing forbidden at all
## — each arrives as an extra method with a plausible name. So the script's
## methods are enumerated from the engine and pinned BY NAME, in order.
## F1 ADDED EXACTLY THREE, IN DECLARATION ORDER: one mutation beside
## `acquire_support` and two scalar readings beside `support_count`. No method
## was removed and no field was added, so the state is still three fields, all
## private.
const EXPECTED_METHODS: Array[String] = [
	"acquire_support", "rank_support", "acquire_passive_card",
	"has_support", "supports_for", "support_pairs", "support_count",
	"support_rank_for", "total_support_ranks",
	"acquired_supports",
	"acquisitions_for", "mechanical_identity_for", "acquired_card_ids",
	"passive_acquisitions",
	"total_for", "contribution_count_for", "stat_totals",
	"is_empty", "duplicated", "describe", "_passive_line",
	"_fingerprint_of", "_fingerprint_for", "_mechanical_conflict",
]

## The three fields it carries, in order. Pinned as NAMES rather than as a count,
## because the fault this guards against — a cached total, a spent counter, a
## remembered offer — arrives as a fourth field with a plausible name.
const EXPECTED_FIELDS: Array[String] = ["_supports", "_totals", "_card_holds"]

# --- Test-only identities ------------------------------------------------------
#
# `zz_` prefixed so they can never be mistaken for content, and so a future
# catalogue entry cannot collide with one.

const SKILL_ALPHA: StringName = &"zz_skill_alpha"
const SKILL_BETA: StringName = &"zz_skill_beta"
const SUPPORT_REACH: StringName = &"zz_support_reach"
const SUPPORT_SWEEP: StringName = &"zz_support_sweep"

## The test-only NON-REPEATABLE card. The six shipped review cards are all
## repeatable, and D-241 forbids changing them, so the generic once-only rule is
## proved against a record built here — which is also why its own validity is
## asserted FIRST: a refusal for the wrong reason would look identical.
const ONCE_ID: StringName = &"zz_probe_bulwark"

## The three ids check 7 binds. Separate from `ONCE_ID` so that check's state and
## this one's can never answer for each other.
const TWIN_ID: StringName = &"zz_probe_twin"
const SEALED_ID: StringName = &"zz_probe_sealed"
const DIVERGENT_ID: StringName = &"zz_probe_divergent"
const ONCE_MAGNITUDE: float = 0.05

## The shipped magnitude two acquisitions of Power are measured against, typed
## here rather than read from the catalogue: a check that takes its expected
## answer from the thing it is checking proves only that a file agrees with
## itself.
const POWER_MAGNITUDE: float = 0.10

## A magnitude that is finite, positive and therefore VALID on its own, and whose
## sum with a second copy of itself is not finite. It is the only input the card
## record accepts and the accumulator refuses, and check 7 uses it to reach the
## one branch where the staged commit is load-bearing.
const HUGE_MAGNITUDE: float = 1.0e308

## What two additive +10% modifiers must come to, and what they must NOT come to.
## The second is computed below from the multiplicative rule the accumulator
## exists to prevent, rather than typed as 0.21, so the foil is the actual wrong
## answer rather than a rounded description of it.
const EXPECTED_POWER_TOTAL: float = 0.20

## A second magnitude, used only to build a record that disagrees with a
## recorded fingerprint. It is a shipped value elsewhere and is not one here.
const OTHER_MAGNITUDE: float = 0.15

## The offer weight every probe record carries, and the DIFFERENT one used to
## prove a reweighting is not a mechanical change.
const PROBE_WEIGHT: int = 100
const REWEIGHTED_PROBE_WEIGHT: int = 7

const OWED_CHECKS: Array[String] = [
	"a_new_state_is_completely_empty",
	"one_pair_is_acquired_and_the_identical_pair_is_refused_atomically",
	"the_same_support_attaches_independently_to_another_skill",
	"empty_skill_and_support_ids_refuse_atomically",
	"two_power_acquisitions_add_to_exactly_twenty_percent",
	"a_non_repeatable_card_succeeds_once_and_then_refuses_atomically",
	"one_card_id_is_one_mechanical_passive_for_the_run",
	"every_invalid_card_refuses_without_changing_any_part_of_the_state",
	"acquisition_order_cannot_change_the_counts_or_the_totals",
	"nothing_live_ever_leaves_the_state",
	"the_state_is_generic_reads_nothing_ambient_and_is_unwired",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation D2 — Temporary Rift Run-Build State (D-241) ===")

	_check_a_new_state_is_completely_empty()
	_check_one_pair_is_acquired_and_the_identical_pair_is_refused_atomically()
	_check_the_same_support_attaches_independently_to_another_skill()
	_check_empty_skill_and_support_ids_refuse_atomically()
	_check_two_power_acquisitions_add_to_exactly_twenty_percent()
	_check_a_non_repeatable_card_succeeds_once_and_then_refuses_atomically()
	_check_one_card_id_is_one_mechanical_passive_for_the_run()
	_check_every_invalid_card_refuses_without_changing_any_part_of_the_state()
	_check_acquisition_order_cannot_change_the_counts_or_the_totals()
	_check_nothing_live_ever_leaves_the_state()
	_check_the_state_is_generic_reads_nothing_ambient_and_is_unwired()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT RUN BUILD VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT RUN BUILD VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. A new state is completely empty ----------------------------------------

func _check_a_new_state_is_completely_empty() -> void:
	print("")
	print("--- 1. A newly constructed state holds nothing at all")

	var build: RiftRunBuild = RiftRunBuild.new()

	_expect(build.is_empty(), "a new state does not report itself empty")
	_expect(build.support_count() == 0,
		"a new state holds %d support pairs" % build.support_count())
	_expect(build.support_pairs().is_empty(),
		"a new state reports the pairs %s" % ", ".join(build.support_pairs()))
	_expect(build.passive_acquisitions() == 0,
		"a new state holds %d passive acquisitions" % build.passive_acquisitions())
	_expect(build.acquired_card_ids().is_empty(),
		"a new state reports acquired cards: %s" % _ids_line(build.acquired_card_ids()))

	## Asked about things it has never heard of, it answers zero rather than
	## refusing: "nothing has been acquired" is the honest answer for a card this
	## run never took AND for one that does not exist.
	_expect(build.acquisitions_for(ONCE_ID) == 0,
		"an unacquired card reports %d acquisitions" % build.acquisitions_for(ONCE_ID))
	_expect(not build.has_support(SKILL_ALPHA, SUPPORT_REACH),
		"a new state claims to hold a pair")
	_expect(build.supports_for(SKILL_ALPHA).is_empty(),
		"a new state reports supports for a Skill it has never heard of")

	## EVERY declared stat, not a sample: a zero that is only true for the one
	## stat somebody thought to check is not a proof that nothing was granted.
	var nonzero: PackedStringArray = PackedStringArray()
	for stat_id: StringName in PlayerStats.ALL:
		if build.total_for(stat_id) != 0.0 or build.contribution_count_for(stat_id) != 0:
			nonzero.append("%s=%s(%d)" % [
				stat_id, _exact(build.total_for(stat_id)),
				build.contribution_count_for(stat_id),
			])
	_expect(nonzero.is_empty(),
		"a new state already carries stat contributions: %s" % ", ".join(nonzero))

	## The two exposed copies are empty too, and they are COPIES rather than the
	## live records — proved in check 9, asserted here only to be non-null.
	var supports: AcquiredSupports = build.acquired_supports()
	var totals: PlayerStatTotals = build.stat_totals()
	_expect(supports != null and supports.is_empty(),
		"the exposed acquisition record is missing or not empty")
	_expect(totals != null and totals.is_empty(),
		"the exposed accumulator is missing or not empty")

	var described: String = build.describe()
	_expect(described.contains("no supports acquired")
			and described.contains("no passive cards acquired")
			and described.contains("no modifiers"),
		"a new state describes itself as '%s'" % described)

	print("  %s" % _snapshot(build))
	print("  a new state is empty across %d stats, 0 pairs and 0 card acquisitions"
		% PlayerStats.ALL.size())
	_done("a_new_state_is_completely_empty")


# --- 2. One pair, and the identical pair refused --------------------------------

func _check_one_pair_is_acquired_and_the_identical_pair_is_refused_atomically() -> void:
	print("")
	print("--- 2. One pair is acquired; the identical pair is refused and changes nothing")

	var build: RiftRunBuild = RiftRunBuild.new()

	var accepted: String = build.acquire_support(SKILL_ALPHA, SUPPORT_REACH)
	_expect(accepted.is_empty(), "the first acquisition was refused: %s" % accepted)
	_expect(build.has_support(SKILL_ALPHA, SUPPORT_REACH),
		"the acquired pair is not held")
	_expect(build.support_count() == 1,
		"one acquisition produced %d pairs" % build.support_count())
	_expect(", ".join(build.support_pairs()) == "%s -> %s" % [SKILL_ALPHA, SUPPORT_REACH],
		"the pairs read %s" % ", ".join(build.support_pairs()))
	_expect(not build.is_empty(), "a state holding a pair reports itself empty")

	## THE SEED: one card as well, so "nothing changed" below is a claim about the
	## WHOLE state rather than about the one field the refusal was about.
	var seeded: String = build.acquire_passive_card(_shipped(&"card_power"))
	_expect(seeded.is_empty(), "the seeding card was refused: %s" % seeded)

	var before: String = _snapshot(build)
	var refusal: String = build.acquire_support(SKILL_ALPHA, SUPPORT_REACH)
	_expect_refusal(refusal, "the identical pair a second time")
	_expect(refusal.contains(String(SKILL_ALPHA)) and refusal.contains(String(SUPPORT_REACH)),
		"the refusal names neither the Skill nor the support: %s" % refusal)
	_expect(_snapshot(build) == before,
		"a refused repeat changed the state:\n    before %s\n    after  %s" % [
			before, _snapshot(build),
		])
	_expect(build.support_count() == 1,
		"a refused repeat left %d pairs" % build.support_count())

	print("  refused: %s" % refusal)
	print("  1 pair held after a refused repeat; the complete state is unchanged")
	_done("one_pair_is_acquired_and_the_identical_pair_is_refused_atomically")


# --- 3. The same support, a second Skill ----------------------------------------

func _check_the_same_support_attaches_independently_to_another_skill() -> void:
	print("")
	print("--- 3. One support attaches independently to two Skills")

	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"the first Skill was refused the support")
	var second: String = build.acquire_support(SKILL_BETA, SUPPORT_REACH)
	_expect(second.is_empty(),
		"the same support was refused for a second Skill: %s" % second)

	_expect(build.support_count() == 2,
		"two Skills holding one support is %d pairs, not 2" % build.support_count())
	_expect(build.has_support(SKILL_ALPHA, SUPPORT_REACH)
			and build.has_support(SKILL_BETA, SUPPORT_REACH),
		"one of the two Skills lost the support the other acquired")
	_expect(_ids_line(build.supports_for(SKILL_ALPHA)) == String(SUPPORT_REACH),
		"the first Skill holds %s" % _ids_line(build.supports_for(SKILL_ALPHA)))
	_expect(_ids_line(build.supports_for(SKILL_BETA)) == String(SUPPORT_REACH),
		"the second Skill holds %s" % _ids_line(build.supports_for(SKILL_BETA)))

	## AND THE REPORTED ORDER DOES NOT DEPEND ON THE ORDER THEY ARRIVED IN.
	var reversed_build: RiftRunBuild = RiftRunBuild.new()
	_expect(reversed_build.acquire_support(SKILL_BETA, SUPPORT_REACH).is_empty(),
		"the reversed acquisition was refused")
	_expect(reversed_build.acquire_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"the reversed acquisition was refused")
	_expect(_snapshot(reversed_build) == _snapshot(build),
		"acquisition order changed the reported pairs:\n    %s\n    %s" % [
			_snapshot(build), _snapshot(reversed_build),
		])

	## A DIFFERENT SUPPORT ON THE SAME SKILL IS ALSO INDEPENDENT.
	_expect(build.acquire_support(SKILL_ALPHA, SUPPORT_SWEEP).is_empty(),
		"a second support was refused for a Skill that already holds one")
	_expect(build.support_count() == 3,
		"three pairs became %d" % build.support_count())
	_expect(_ids_line(build.supports_for(SKILL_ALPHA))
			== "%s, %s" % [SUPPORT_REACH, SUPPORT_SWEEP],
		"the first Skill holds %s" % _ids_line(build.supports_for(SKILL_ALPHA)))

	print("  %s" % ", ".join(build.support_pairs()))
	print("  1 support across 2 Skills is 2 pairs; 3 pairs over 2 Skills report in a stable order")
	_done("the_same_support_attaches_independently_to_another_skill")


# --- 4. Empty identifiers -------------------------------------------------------

func _check_empty_skill_and_support_ids_refuse_atomically() -> void:
	print("")
	print("--- 4. An empty Skill or support id is refused, and changes nothing")

	var build: RiftRunBuild = _seeded_state()
	var before: String = _snapshot(build)

	var rows: Array = [
		[&"", SUPPORT_REACH, "an empty Skill id"],
		[&"   ", SUPPORT_REACH, "a whitespace-only Skill id"],
		[SKILL_ALPHA, &"", "an empty support id"],
		[SKILL_ALPHA, &"   ", "a whitespace-only support id"],
		[&"", &"", "two empty ids"],
	]
	for row: Array in rows:
		var refusal: String = build.acquire_support(row[0] as StringName, row[1] as StringName)
		_expect_refusal(refusal, String(row[2]))
		_expect(_snapshot(build) == before,
			"%s changed the state:\n    before %s\n    after  %s" % [
				String(row[2]), before, _snapshot(build),
			])

	## A REFUSAL MUST NOT CREATE THE KEY IT REFUSED. An implementation that
	## reaches for the Skill's list before validating leaves an empty entry
	## behind, which a pair COUNT cannot see.
	_expect(build.supports_for(&"").is_empty(),
		"an empty Skill id acquired a list of its own")
	_expect(build.support_count() == 1,
		"the seeded state holds %d pairs after 5 refusals" % build.support_count())

	print("  %d empty-identifier refusals, each leaving the complete state unchanged" % rows.size())
	print("  %s" % _snapshot(build))
	_done("empty_skill_and_support_ids_refuse_atomically")


# --- 5. Two Power acquisitions ---------------------------------------------------

func _check_two_power_acquisitions_add_to_exactly_twenty_percent() -> void:
	print("")
	print("--- 5. Two acquisitions of one repeatable card ADD; they do not multiply")

	var power: PassiveCardDefinition = _shipped(&"card_power")
	_expect(power != null and power.problem().is_empty(),
		"the shipped card under test is not a valid record")
	_expect(power.repeatable, "the shipped card under test is not repeatable")
	_expect(power.magnitude == POWER_MAGNITUDE,
		"the shipped magnitude is %s, not the %s this check is written against" % [
			_exact(power.magnitude), _exact(POWER_MAGNITUDE),
		])

	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_passive_card(power).is_empty(), "the first acquisition was refused")
	_expect(build.acquire_passive_card(power).is_empty(), "the second acquisition was refused")

	_expect(build.acquisitions_for(power.card_id) == 2,
		"two acquisitions recorded %d" % build.acquisitions_for(power.card_id))
	_expect(build.passive_acquisitions() == 2,
		"the run reports %d total acquisitions" % build.passive_acquisitions())
	_expect(_ids_line(build.acquired_card_ids()) == String(power.card_id),
		"the acquired cards read %s" % _ids_line(build.acquired_card_ids()))

	var total: float = build.total_for(power.stat_id)

	## THE LOAD-BEARING ASSERTION, AND IT IS EXACT RATHER THAN APPROXIMATE.
	_expect(total == EXPECTED_POWER_TOTAL,
		"two +10%% cards came to %s, not %s" % [_exact(total), _exact(EXPECTED_POWER_TOTAL)])

	## AND THE FOIL IS THE ACTUAL WRONG ANSWER, COMPUTED HERE FROM THE
	## MULTIPLICATIVE RULE the accumulator exists to prevent — not typed as a
	## rounded 0.21, which a near-miss could satisfy.
	var multiplicative: float = ((1.0 + POWER_MAGNITUDE) * (1.0 + POWER_MAGNITUDE)) - 1.0
	_expect(total != multiplicative,
		"the total is the MULTIPLICATIVE %s" % _exact(multiplicative))
	_expect(_exact(multiplicative) != _exact(EXPECTED_POWER_TOTAL),
		"the multiplicative foil %s is indistinguishable from the additive answer"
			% _exact(multiplicative))

	## THE INDIVIDUAL CONTRIBUTIONS SURVIVE THE REPEAT. A repeat that replaced a
	## contribution instead of adding one would leave the count at 1 and, for two
	## equal magnitudes, would still look almost right in the total.
	_expect(build.contribution_count_for(power.stat_id) == 2,
		"two acquisitions left %d contributions" % build.contribution_count_for(power.stat_id))
	var contributions: PackedFloat64Array = build.stat_totals().contributions_for(power.stat_id)
	_expect(_floats_line(contributions) == "%s, %s" % [
			_exact(POWER_MAGNITUDE), _exact(POWER_MAGNITUDE),
		],
		"the preserved contributions read [%s]" % _floats_line(contributions))

	## NO OTHER STAT MOVED.
	var strays: PackedStringArray = PackedStringArray()
	for stat_id: StringName in PlayerStats.ALL:
		if stat_id == power.stat_id:
			continue
		if build.total_for(stat_id) != 0.0 or build.contribution_count_for(stat_id) != 0:
			strays.append(String(stat_id))
	_expect(strays.is_empty(), "unrelated stats moved: %s" % ", ".join(strays))

	var two_acquisitions: int = build.acquisitions_for(power.card_id)

	## A THIRD ACQUISITION KEEPS ADDING, AND THE ANSWER IS THE ACCUMULATOR'S OWN.
	## Compared against an independently built accumulator rather than against a
	## typed constant, because three tenths is not exactly representable and a
	## typed 0.30 would fail for a reason that has nothing to do with this state.
	_expect(build.acquire_passive_card(power).is_empty(), "the third acquisition was refused")
	var reference: PlayerStatTotals = PlayerStatTotals.new()
	for repeat: int in 3:
		_expect(reference.add(power.stat_id, POWER_MAGNITUDE).is_empty(),
			"the reference accumulator refused a modifier")
	_expect(_exact(build.total_for(power.stat_id)) == _exact(reference.total_for(power.stat_id)),
		"three acquisitions came to %s where the accumulator answers %s" % [
			_exact(build.total_for(power.stat_id)), _exact(reference.total_for(power.stat_id)),
		])
	_expect(build.acquisitions_for(power.card_id) == 3,
		"three acquisitions recorded %d" % build.acquisitions_for(power.card_id))

	print("  2 acquisitions of %s: %d recorded, total %s, contributions [%s]" % [
		power.card_id, two_acquisitions,
		_exact(EXPECTED_POWER_TOTAL), _floats_line(contributions),
	])
	print("  the multiplicative answer would have been %s and is refused"
		% _exact(multiplicative))
	_done("two_power_acquisitions_add_to_exactly_twenty_percent")


# --- 6. A non-repeatable card ----------------------------------------------------

func _check_a_non_repeatable_card_succeeds_once_and_then_refuses_atomically() -> void:
	print("")
	print("--- 6. A non-repeatable card is taken once and then refused")

	## THE SHIPPED SIX ARE ALL REPEATABLE AND STAY THAT WAY. The generic rule is
	## therefore proved against a record built here, and this row is what makes
	## the choice visible instead of implied.
	var repeatable_shipped: int = 0
	for card: PassiveCardDefinition in PassiveCardCatalogue.records():
		if card.repeatable:
			repeatable_shipped += 1
	_expect(repeatable_shipped == PassiveCardCatalogue.ALL.size(),
		"%d of %d shipped cards are repeatable" % [
			repeatable_shipped, PassiveCardCatalogue.ALL.size(),
		])

	var once: PassiveCardDefinition = _once_only_card()

	## ITS OWN VALIDITY FIRST. A refusal for the wrong reason — a malformed record
	## rather than a repeat — would look identical from the outside.
	_expect(once.problem().is_empty(),
		"the test-only non-repeatable card is not valid: %s" % once.problem())
	_expect(not once.repeatable, "the test-only card is repeatable")

	var build: RiftRunBuild = _seeded_state()
	var accepted: String = build.acquire_passive_card(once)
	_expect(accepted.is_empty(), "the first acquisition was refused: %s" % accepted)
	_expect(build.acquisitions_for(ONCE_ID) == 1,
		"the first acquisition recorded %d" % build.acquisitions_for(ONCE_ID))
	_expect(build.total_for(once.stat_id) == ONCE_MAGNITUDE,
		"the granted total is %s" % _exact(build.total_for(once.stat_id)))

	var before: String = _snapshot(build)
	var refusal: String = build.acquire_passive_card(once)
	_expect_refusal(refusal, "a second acquisition of a non-repeatable card")
	_expect(refusal.contains(String(ONCE_ID)),
		"the refusal does not name the card: %s" % refusal)
	_expect(_snapshot(build) == before,
		"a refused repeat changed the state:\n    before %s\n    after  %s" % [
			before, _snapshot(build),
		])
	_expect(build.acquisitions_for(ONCE_ID) == 1,
		"a refused repeat left %d acquisitions" % build.acquisitions_for(ONCE_ID))
	_expect(build.contribution_count_for(once.stat_id) == 1,
		"a refused repeat left %d contributions" % build.contribution_count_for(once.stat_id))

	## AND IT REFUSES ONLY ITSELF: a different card for the same stat still works,
	## so the rule is keyed on the card rather than on what the card moves.
	var other: PassiveCardDefinition = PassiveCardDefinition.of(
		&"zz_probe_second", "Probe Second", once.stat_id, ONCE_MAGNITUDE, 100, false
	)
	_expect(other.problem().is_empty(), "the second test-only card is not valid")
	_expect(build.acquire_passive_card(other).is_empty(),
		"a different non-repeatable card on the same stat was refused")
	_expect(build.contribution_count_for(once.stat_id) == 2,
		"two different cards on one stat left %d contributions"
			% build.contribution_count_for(once.stat_id))

	print("  refused: %s" % refusal)
	print("  %d of %d shipped cards are repeatable and are unchanged; the once-only rule is generic"
		% [repeatable_shipped, PassiveCardCatalogue.ALL.size()])
	_done("a_non_repeatable_card_succeeds_once_and_then_refuses_atomically")


# --- 7. One card id is one mechanical passive ------------------------------------

func _check_one_card_id_is_one_mechanical_passive_for_the_run() -> void:
	print("")
	print("--- 7. One card id is bound to one mechanical passive for the life of the run")

	## TWO SEPARATELY CONSTRUCTED, MECHANICALLY IDENTICAL RECORDS ARE ONE CARD.
	## Check 5 acquires the same OBJECT twice, which cannot tell "the id is bound
	## to an identity" from "the caller happened to pass the same object"; these
	## two records only agree.
	var first: PassiveCardDefinition = _probe_card(
		TWIN_ID, "Probe Twin", PlayerStats.GLOBAL_DAMAGE,
		POWER_MAGNITUDE, PROBE_WEIGHT, true)
	var twin: PassiveCardDefinition = _probe_card(
		TWIN_ID, "Probe Twin", PlayerStats.GLOBAL_DAMAGE,
		POWER_MAGNITUDE, PROBE_WEIGHT, true)
	_expect(first.get_instance_id() != twin.get_instance_id(),
		"the two records under test are the same object, so agreement proves nothing")

	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_passive_card(first).is_empty(), "the first record was refused")
	var bound: String = build.mechanical_identity_for(TWIN_ID)
	_expect(not bound.is_empty(), "the first acquisition bound no mechanical identity")
	_expect(build.acquire_passive_card(twin).is_empty(),
		"a mechanically identical record under the same id was refused")
	_expect(build.acquisitions_for(TWIN_ID) == 2,
		"two identical records recorded %d acquisitions" % build.acquisitions_for(TWIN_ID))
	_expect(build.total_for(PlayerStats.GLOBAL_DAMAGE) == EXPECTED_POWER_TOTAL,
		"two identical +10%% records came to %s, not %s" % [
			_exact(build.total_for(PlayerStats.GLOBAL_DAMAGE)),
			_exact(EXPECTED_POWER_TOTAL),
		])
	_expect(build.contribution_count_for(PlayerStats.GLOBAL_DAMAGE) == 2,
		"two identical records left %d contributions"
			% build.contribution_count_for(PlayerStats.GLOBAL_DAMAGE))

	## PRESENTATION AND OFFER WEIGHT ARE NOT MECHANICAL, AND BOTH ARE DRIVEN.
	## A renamed record must stay compatible or copy could never be rewritten
	## mid-run; a reweighted one must stay compatible or a selection-time number
	## would become a migration.
	var renamed: PassiveCardDefinition = _probe_card(
		TWIN_ID, "A Completely Different Label", PlayerStats.GLOBAL_DAMAGE,
		POWER_MAGNITUDE, PROBE_WEIGHT, true)
	var reweighted: PassiveCardDefinition = _probe_card(
		TWIN_ID, "Probe Twin", PlayerStats.GLOBAL_DAMAGE,
		POWER_MAGNITUDE, REWEIGHTED_PROBE_WEIGHT, true)
	_expect(renamed.display_name != first.display_name,
		"the renamed record carries the same presentation name, so it proves nothing")
	_expect(reweighted.base_weight != first.base_weight,
		"the reweighted record carries the same offer weight, so it proves nothing")
	_expect(build.acquire_passive_card(renamed).is_empty(),
		"a renamed record with identical mechanical fields was refused")
	_expect(build.acquire_passive_card(reweighted).is_empty(),
		"a reweighted record with identical mechanical fields was refused")
	_expect(build.acquisitions_for(TWIN_ID) == 4,
		"four compatible records recorded %d acquisitions"
			% build.acquisitions_for(TWIN_ID))
	_expect(build.contribution_count_for(PlayerStats.GLOBAL_DAMAGE) == 4,
		"four compatible records left %d contributions"
			% build.contribution_count_for(PlayerStats.GLOBAL_DAMAGE))
	_expect(build.mechanical_identity_for(TWIN_ID) == bound,
		"a rename or a reweight moved the bound identity from %s to %s" % [
			bound, build.mechanical_identity_for(TWIN_ID),
		])

	## EACH MECHANICAL FIELD, DISAGREED WITH ON ITS OWN. One row per field, each
	## differing from the bound record in exactly one thing, so a refusal cannot
	## be right for the wrong reason.
	var before: String = _snapshot(build)
	var conflicts: Array = [
		[_probe_card(TWIN_ID, "Probe Twin", PlayerStats.MAXIMUM_LIFE,
			POWER_MAGNITUDE, PROBE_WEIGHT, true), "stat_id", "a different stat"],
		[_probe_card(TWIN_ID, "Probe Twin", PlayerStats.GLOBAL_DAMAGE,
			OTHER_MAGNITUDE, PROBE_WEIGHT, true), "magnitude", "a different magnitude"],
		[_probe_card(TWIN_ID, "Probe Twin", PlayerStats.GLOBAL_DAMAGE,
			POWER_MAGNITUDE, PROBE_WEIGHT, false), "repeatable", "a different repeat flag"],
	]
	for row: Array in conflicts:
		var candidate: PassiveCardDefinition = row[0] as PassiveCardDefinition
		var field: String = String(row[1])
		var described: String = String(row[2])
		## VALID ON ITS OWN, which is the whole difficulty: this is not a
		## malformed record being caught by the record layer.
		_expect(candidate.problem().is_empty(),
			"%s is not a valid record, so its refusal would prove nothing" % described)
		var refusal: String = build.acquire_passive_card(candidate)
		_expect_refusal(refusal, described)
		_expect(refusal.contains(String(TWIN_ID)),
			"the refusal for %s does not name the card id: %s" % [described, refusal])
		_expect(refusal.contains(field),
			"the refusal for %s does not name the conflicting field %s: %s" % [
				described, field, refusal,
			])
		_expect(_snapshot(build) == before,
			"%s changed the state:\n    before %s\n    after  %s" % [
				described, before, _snapshot(build),
			])

	## AND A COMPATIBLE RECORD IS STILL ACCEPTED AFTERWARDS, so the three
	## refusals above refused the record rather than sealing the card.
	_expect(build.acquire_passive_card(twin).is_empty(),
		"a compatible record was refused after three conflicts were rejected")
	_expect(build.acquisitions_for(TWIN_ID) == 5,
		"the compatible record recorded %d acquisitions"
			% build.acquisitions_for(TWIN_ID))

	## THE BYPASS THIS INVARIANT EXISTS TO CLOSE. Without a recorded fingerprint,
	## a once-only card could be taken again simply by presenting a second record
	## that claims to be repeatable, because the repeat rule would be read from
	## whatever arrived last.
	var sealed_state: RiftRunBuild = RiftRunBuild.new()
	var sealed: PassiveCardDefinition = _probe_card(
		SEALED_ID, "Probe Sealed", PlayerStats.MOVEMENT_SPEED,
		ONCE_MAGNITUDE, PROBE_WEIGHT, false)
	var pretender: PassiveCardDefinition = _probe_card(
		SEALED_ID, "Probe Sealed", PlayerStats.MOVEMENT_SPEED,
		ONCE_MAGNITUDE, PROBE_WEIGHT, true)
	_expect(pretender.problem().is_empty(),
		"the pretending record is not valid, so its refusal would prove nothing")
	_expect(sealed_state.acquire_passive_card(sealed).is_empty(),
		"the once-only record was refused")
	var sealed_before: String = _snapshot(sealed_state)
	var bypass: String = sealed_state.acquire_passive_card(pretender)
	_expect_refusal(bypass, "a once-only card presented again as repeatable")
	_expect(bypass.contains(String(SEALED_ID)) and bypass.contains("repeatable"),
		"the bypass refusal does not name the card id and the flag: %s" % bypass)
	_expect(_snapshot(sealed_state) == sealed_before,
		"the bypass attempt changed the state")
	_expect(sealed_state.acquisitions_for(SEALED_ID) == 1,
		"the bypass attempt left %d acquisitions"
			% sealed_state.acquisitions_for(SEALED_ID))

	## And the ordinary once-only refusal still holds, read from the fingerprint.
	_expect_refusal(sealed_state.acquire_passive_card(sealed),
		"the once-only record a second time")
	_expect(_snapshot(sealed_state) == sealed_before,
		"the second once-only acquisition changed the state")

	## THE FINGERPRINT TRAVELS WITH A DUPLICATE AND IS NOT SHARED WITH IT.
	## Both halves matter and neither implies the other: a duplicate that LOST
	## the fingerprint would silently accept a conflicting record, and one that
	## SHARED it would let either state rewrite what an id means for both.
	var origin: RiftRunBuild = RiftRunBuild.new()
	_expect(origin.acquire_passive_card(first).is_empty(), "the origin refused its record")
	var copy: RiftRunBuild = origin.duplicated()
	var origin_before: String = _snapshot(origin)
	_expect(copy.mechanical_identity_for(TWIN_ID) == bound,
		"the duplicate carries the identity %s, not %s" % [
			copy.mechanical_identity_for(TWIN_ID), bound,
		])
	_expect_refusal(copy.acquire_passive_card(conflicts[0][0] as PassiveCardDefinition),
		"a conflicting record presented to a duplicate")
	_expect(copy.acquire_passive_card(twin).is_empty(),
		"the duplicate refused a compatible record")
	_expect(copy.acquisitions_for(TWIN_ID) == 2,
		"the duplicate holds %d acquisitions" % copy.acquisitions_for(TWIN_ID))
	_expect(_snapshot(origin) == origin_before,
		"acquiring through the duplicate changed the original:\n    %s\n    %s" % [
			origin_before, _snapshot(origin),
		])

	## THE SHARPEST HALF: an id bound only in the duplicate must be unknown to
	## the original, which is then free to bind it to something else entirely. A
	## shared map would refuse this.
	var fresh_in_copy: PassiveCardDefinition = _probe_card(
		DIVERGENT_ID, "Probe Divergent", PlayerStats.PICKUP_RADIUS,
		POWER_MAGNITUDE, PROBE_WEIGHT, true)
	var same_id_other_stat: PassiveCardDefinition = _probe_card(
		DIVERGENT_ID, "Probe Divergent", PlayerStats.EXPERIENCE_GAIN,
		POWER_MAGNITUDE, PROBE_WEIGHT, true)
	_expect(copy.acquire_passive_card(fresh_in_copy).is_empty(),
		"the duplicate refused a new card")
	_expect(origin.acquisitions_for(DIVERGENT_ID) == 0,
		"a card acquired in the duplicate appeared in the original")
	_expect(origin.acquire_passive_card(same_id_other_stat).is_empty(),
		"the original was bound by an identity only the duplicate ever recorded")
	_expect(copy.mechanical_identity_for(DIVERGENT_ID)
			!= origin.mechanical_identity_for(DIVERGENT_ID),
		"the two states report one identity for an id they bound differently")

	print("  %s is bound to [%s]; 2 identical, 1 renamed and 1 reweighted record all compatible"
		% [TWIN_ID, bound])
	print("  3 mechanical conflicts refused by name, 1 once-only bypass refused, "
		+ "and a duplicate that neither lost nor shares its fingerprints")
	_done("one_card_id_is_one_mechanical_passive_for_the_run")


# --- 8. Invalid cards -------------------------------------------------------------

func _check_every_invalid_card_refuses_without_changing_any_part_of_the_state() -> void:
	print("")
	print("--- 8. Every refused card leaves every part of the state unchanged")

	var build: RiftRunBuild = _seeded_state()
	_expect(build.acquire_passive_card(_shipped(&"card_vitality")).is_empty(),
		"the seeding card was refused")
	var before: String = _snapshot(build)

	var rows: Array = [
		[null, "a null record"],
		[PassiveCardDefinition.of(&"", "Nameless", PlayerStats.GLOBAL_DAMAGE,
			0.10, 100, true), "an empty card id"],
		[PassiveCardDefinition.of(&"Zz_Probe", "Capitalised", PlayerStats.GLOBAL_DAMAGE,
			0.10, 100, true), "an illegal card id"],
		[PassiveCardDefinition.of(&"zz_probe", "   ", PlayerStats.GLOBAL_DAMAGE,
			0.10, 100, true), "a blank presentation name"],
		[PassiveCardDefinition.of(&"zz_probe", "Probe", &"",
			0.10, 100, true), "an empty stat id"],
		[PassiveCardDefinition.of(&"zz_probe", "Probe", &"zz_not_a_stat",
			0.10, 100, true), "an unknown stat"],
		[PassiveCardDefinition.of(&"zz_probe", "Probe", PlayerStats.GLOBAL_DAMAGE,
			INF, 100, true), "an infinite magnitude"],
		[PassiveCardDefinition.of(&"zz_probe", "Probe", PlayerStats.GLOBAL_DAMAGE,
			NAN, 100, true), "a magnitude that is not a number"],
		[PassiveCardDefinition.of(&"zz_probe", "Probe", PlayerStats.GLOBAL_DAMAGE,
			0.0, 100, true), "a zero magnitude"],
		[PassiveCardDefinition.of(&"zz_probe", "Probe", PlayerStats.GLOBAL_DAMAGE,
			-0.10, 100, true), "a negative magnitude"],
		[PassiveCardDefinition.of(&"zz_probe", "Probe", PlayerStats.GLOBAL_DAMAGE,
			0.10, 0, true), "a zero base offer weight"],
	]
	for row: Array in rows:
		var refusal: String = build.acquire_passive_card(row[0] as PassiveCardDefinition)
		_expect_refusal(refusal, String(row[1]))
		_expect(_snapshot(build) == before,
			"%s changed the state:\n    before %s\n    after  %s" % [
				String(row[1]), before, _snapshot(build),
			])

	## THE REFUSALS MUST NOT HAVE COUNTED ANYTHING. A count that moved without a
	## modifier — or a modifier without a count — is exactly the half-applied
	## state the staged commit exists to make impossible, and neither is visible
	## in a check that only asks whether the call returned a reason.
	_expect(build.acquisitions_for(&"zz_probe") == 0,
		"a refused card was counted %d times" % build.acquisitions_for(&"zz_probe"))
	_expect(build.passive_acquisitions() == 2,
		"the seeded state holds %d acquisitions after %d refusals" % [
			build.passive_acquisitions(), rows.size(),
		])
	_expect(build.support_count() == 1,
		"a refused card disturbed the %d support pair(s)" % build.support_count())

	## THE ONE REFUSAL THAT ARRIVES AFTER THE RECORD LAYER HAS ACCEPTED THE CARD,
	## AND THEREFORE THE ONLY ONE THE STAGED COMMIT IS LOAD-BEARING FOR.
	##
	## THIS BLOCK EXISTS BECAUSE THE SUITE WAS MEASURED AND FOUND UNABLE TO SEE
	## THE FAULT IT CLAIMED TO GUARD. Committing the card count BEFORE the
	## delegated mutation left this suite green, because every row above is
	## refused before anything is committed at all — so the eleven of them proved
	## validate-before-mutate and nothing whatever about the commit ORDER. A
	## magnitude that is finite on its own but whose SUM with what is already held
	## is not is the one input the card record accepts and the accumulator
	## refuses, and it is the only way to reach that branch from a valid record.
	## With this block present, swapping those two lines fails three assertions.
	## It runs on a SEPARATE seeded state, because the magnitude it needs renders
	## to three hundred digits and would drown every snapshot printed here.
	var overflow_state: RiftRunBuild = _seeded_state()
	var enormous: PassiveCardDefinition = PassiveCardDefinition.of(
		&"zz_probe_enormous", "Probe Enormous", PlayerStats.PICKUP_RADIUS,
		HUGE_MAGNITUDE, 100, true
	)
	_expect(enormous.problem().is_empty(),
		"the overflow probe is not a valid card record: %s" % enormous.problem())
	_expect(overflow_state.acquire_passive_card(enormous).is_empty(),
		"the first enormous acquisition was refused, so the overflow is unreachable")
	var staged_before: String = _snapshot(overflow_state)
	var overflow: String = overflow_state.acquire_passive_card(enormous)
	_expect_refusal(overflow, "a magnitude whose SUM is not finite")
	_expect(_snapshot(overflow_state) == staged_before,
		"an accumulator refusal changed the state")
	_expect(overflow_state.acquisitions_for(&"zz_probe_enormous") == 1,
		"an accumulator refusal left %d acquisitions of a card taken once"
			% overflow_state.acquisitions_for(&"zz_probe_enormous"))
	_expect(overflow_state.contribution_count_for(PlayerStats.PICKUP_RADIUS) == 1,
		"an accumulator refusal left %d contributions"
			% overflow_state.contribution_count_for(PlayerStats.PICKUP_RADIUS))
	_expect(overflow_state.passive_acquisitions() == 2,
		"an accumulator refusal left %d total acquisitions"
			% overflow_state.passive_acquisitions())

	print("  %d invalid records refused, each leaving the complete state unchanged" % rows.size())
	print("  and the one refusal the record layer cannot see — a non-finite SUM — counts nothing")
	print("  %s" % _snapshot(build))
	_done("every_invalid_card_refuses_without_changing_any_part_of_the_state")


# --- 9. Order independence --------------------------------------------------------

func _check_acquisition_order_cannot_change_the_counts_or_the_totals() -> void:
	print("")
	print("--- 9. The same acquisitions in any order produce identical counts and bit-identical totals")

	## Every shipped card, with two of them taken twice, so the comparison covers
	## repeats as well as distinct cards.
	var sequence: Array[StringName] = [
		&"card_power", &"card_celerity", &"card_vitality",
		&"card_fleetness", &"card_insight", &"card_magnetism",
		&"card_power", &"card_vitality",
	]

	var canonical: RiftRunBuild = _built_from(sequence)
	var reversed_order: RiftRunBuild = _built_from(_reversed(sequence))
	var rotated: RiftRunBuild = _built_from(_rotated(sequence, 3))
	var interleaved: RiftRunBuild = _built_from(_interleaved(sequence))

	var reference: String = _snapshot(canonical)
	for row: Array in [
		[reversed_order, "reversed"], [rotated, "rotated by 3"], [interleaved, "interleaved"],
	]:
		var other: RiftRunBuild = row[0] as RiftRunBuild
		_expect(_snapshot(other) == reference,
			"the %s order produced a different state:\n    %s\n    %s" % [
				String(row[1]), reference, _snapshot(other),
			])

	_expect(canonical.passive_acquisitions() == sequence.size(),
		"%d acquisitions recorded %d" % [sequence.size(), canonical.passive_acquisitions()])
	_expect(canonical.acquisitions_for(&"card_power") == 2
			and canonical.acquisitions_for(&"card_vitality") == 2
			and canonical.acquisitions_for(&"card_insight") == 1,
		"the repeated cards were not counted twice")

	## AND THE TOTALS ARE THE ACCUMULATOR'S OWN, which is the behavioural half of
	## "it delegates and computes nothing itself". Built here in a DIFFERENT order
	## again, so agreement cannot come from repeating the same sequence.
	var expected: PlayerStatTotals = PlayerStatTotals.new()
	for card_id: StringName in _reversed(sequence):
		var card: PassiveCardDefinition = _shipped(card_id)
		_expect(expected.add(card.stat_id, card.magnitude).is_empty(),
			"the reference accumulator refused %s" % card_id)
	var drift: PackedStringArray = PackedStringArray()
	for stat_id: StringName in PlayerStats.ALL:
		if _exact(canonical.total_for(stat_id)) != _exact(expected.total_for(stat_id)):
			drift.append("%s %s against %s" % [
				stat_id, _exact(canonical.total_for(stat_id)),
				_exact(expected.total_for(stat_id)),
			])
	_expect(drift.is_empty(),
		"the state disagrees with the accumulator: %s" % ", ".join(drift))

	print("  %s" % reference)
	print("  4 acquisition orders over %d cards agree on every count and every total (0 drift)"
		% sequence.size())
	_done("acquisition_order_cannot_change_the_counts_or_the_totals")


# --- 10. Nothing live ever leaves ---------------------------------------------------

func _check_nothing_live_ever_leaves_the_state() -> void:
	print("")
	print("--- 10. Every exposed value is a copy, and mutating one cannot reach the original")

	var build: RiftRunBuild = _seeded_state()
	_expect(build.acquire_passive_card(_shipped(&"card_power")).is_empty(),
		"the seeding card was refused")
	var before: String = _snapshot(build)

	## THE ACQUISITION RECORD. A caller handed the live object could add a pair
	## this run never acquired — and could remove one it did.
	var supports: AcquiredSupports = build.acquired_supports()
	_expect(supports.acquire(SKILL_BETA, SUPPORT_SWEEP), "the exposed copy refused a new pair")
	_expect(supports.release(SKILL_ALPHA, SUPPORT_REACH), "the exposed copy refused a release")
	_expect(_snapshot(build) == before,
		"mutating the exposed acquisition record changed the state:\n    %s\n    %s" % [
			before, _snapshot(build),
		])
	var supports_again: AcquiredSupports = build.acquired_supports()
	_expect(supports.get_instance_id() != supports_again.get_instance_id(),
		"two calls returned the same acquisition-record instance")

	## THE ACCUMULATOR. Same reasoning, and the sharper case: a caller could add a
	## modifier no card ever granted.
	var totals: PlayerStatTotals = build.stat_totals()
	_expect(totals.add(PlayerStats.GLOBAL_DAMAGE, 5.0).is_empty(),
		"the exposed copy refused a modifier")
	totals.clear()
	_expect(_snapshot(build) == before,
		"mutating the exposed accumulator changed the state:\n    %s\n    %s" % [
			before, _snapshot(build),
		])
	var totals_again: PlayerStatTotals = build.stat_totals()
	_expect(totals.get_instance_id() != totals_again.get_instance_id(),
		"two calls returned the same accumulator instance")

	## THE RETURNED ARRAYS.
	var per_skill: Array[StringName] = build.supports_for(SKILL_ALPHA)
	per_skill.append(SUPPORT_SWEEP)
	per_skill.append(&"zz_support_fabricated")
	var ids: Array[StringName] = build.acquired_card_ids()
	ids.clear()
	var pairs: PackedStringArray = build.support_pairs()
	pairs.append("zz_skill_ghost -> zz_support_ghost")
	_expect(_snapshot(build) == before,
		"mutating a returned array changed the state:\n    %s\n    %s" % [
			before, _snapshot(build),
		])

	## THE WHOLE-STATE DUPLICATE, IN BOTH DIRECTIONS. One direction alone would
	## miss a copy that shares its internals with the original.
	var copy: RiftRunBuild = build.duplicated()
	_expect(_snapshot(copy) == before,
		"the duplicate does not match the original:\n    %s\n    %s" % [
			before, _snapshot(copy),
		])
	_expect(copy.acquire_support(SKILL_BETA, SUPPORT_SWEEP).is_empty(),
		"the duplicate refused a new pair")
	_expect(copy.acquire_passive_card(_shipped(&"card_magnetism")).is_empty(),
		"the duplicate refused a card")
	_expect(_snapshot(build) == before,
		"changing the duplicate changed the original:\n    %s\n    %s" % [
			before, _snapshot(build),
		])
	var copy_after: String = _snapshot(copy)
	_expect(build.acquire_support(SKILL_BETA, SUPPORT_REACH).is_empty(),
		"the original refused a new pair")
	_expect(build.acquire_passive_card(_shipped(&"card_insight")).is_empty(),
		"the original refused a card")
	_expect(_snapshot(copy) == copy_after,
		"changing the original changed the duplicate:\n    %s\n    %s" % [
			copy_after, _snapshot(copy),
		])

	print("  6 exposed values mutated; the original state is unchanged in both directions")
	_done("nothing_live_ever_leaves_the_state")


# --- 11. Generic, ambient-free, unwired ---------------------------------------------

func _check_the_state_is_generic_reads_nothing_ambient_and_is_unwired() -> void:
	print("")
	print("--- 11. The state names nothing concrete, computes no percentage and is unwired")

	var raw: String = FileAccess.get_file_as_string(RUN_BUILD_FILE)
	_expect(raw.length() > 2000,
		"the run-build source read as %d characters, so these scans prove nothing"
			% raw.length())
	var code: String = _code_only(raw)
	_expect(code.length() > 1000 and code.length() < raw.length(),
		"comment stripping produced %d characters from %d" % [code.length(), raw.length()])

	var named: PackedStringArray = PackedStringArray()
	for token: String in FORBIDDEN_TOKENS:
		if raw.contains(token):
			named.append(token)
	_expect(named.is_empty(), "the run-build state names: %s" % ", ".join(named))

	var ambient: PackedStringArray = PackedStringArray()
	for token: String in AMBIENT_TOKENS:
		if raw.contains(token):
			ambient.append(token)
	_expect(ambient.is_empty(), "the run-build state reads ambient state: %s" % ", ".join(ambient))

	var deferred: PackedStringArray = PackedStringArray()
	for token: String in DEFERRED_MEMBER_TOKENS:
		if code.contains(token):
			deferred.append(token)
	_expect(deferred.is_empty(),
		"the run-build state carries deferred members: %s" % ", ".join(deferred))

	## NO PERCENTAGE ARITHMETIC OF ITS OWN, ASSERTED FROM THE SOURCE. No
	## multiplication, no division, and no floating-point literal anywhere in the
	## code — the only float that passes through the file is the magnitude it
	## hands to the accumulator.
	var operators: PackedStringArray = PackedStringArray()
	for token: String in FORBIDDEN_OPERATORS:
		if code.contains(token):
			operators.append(token)
	_expect(operators.is_empty(),
		"the run-build state performs arithmetic with: %s" % ", ".join(operators))
	var float_literals: PackedStringArray = PackedStringArray()
	var digits: String = "0123456789"
	for index: int in range(1, code.length() - 1):
		if code[index] != ".":
			continue
		if digits.contains(code[index - 1]) and digits.contains(code[index + 1]):
			float_literals.append(code.substr(maxi(0, index - 6), 12))
	_expect(float_literals.is_empty(),
		"the run-build state carries floating-point literal(s): %s" % ", ".join(float_literals))

	## AND THE MAGNITUDE IS READ EXACTLY ONCE, WHICH IS THE STRUCTURAL FORM OF
	## "it is handed straight to the accumulator". A file that read it twice would
	## have somewhere to do something with it.
	_expect(raw.count(".magnitude") == 1,
		"the magnitude is read %d times, not once" % raw.count(".magnitude"))
	_expect(raw.count(".stat_id") == 1,
		"the stat is read %d times, not once" % raw.count(".stat_id"))
	_expect(raw.count(".repeatable") == 1,
		"the repeat flag is read %d times, not once" % raw.count(".repeatable"))

	## THE ONE PROPERTY THIS SUITE PINS STRUCTURALLY RATHER THAN BEHAVIOURALLY,
	## AND THE REASON IS RECORDED RATHER THAN GLOSSED. The repeat rule must read
	## the RECORDED fingerprint, not the record that just arrived — but past the
	## mismatch gate the two are provably identical, so no input can tell them
	## apart and no behavioural assertion could. Reading from the supplied record
	## is caught here, by the pin above and by this one naming the expression, and
	## nowhere else. A structural pin that says what it is beats a behavioural
	## test that cannot exist.
	_expect(code.contains("identity[FIELD_REPEATABLE]"),
		"the repeat rule does not read the recorded fingerprint")
	_expect(code.contains("identity[FIELD_STAT]") and code.contains("identity[FIELD_MAGNITUDE]"),
		"the modifier handed to the accumulator does not come from the recorded fingerprint")

	## AN ALLOWLIST, NOT ONLY A DENYLIST. The token list above can only refuse
	## names somebody remembered to add; this asks the ENGINE which project
	## classes exist and requires the state to name none of them but the four it
	## is entitled to.
	var project_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var class_id: String = String(entry.get("class", ""))
		if not class_id.is_empty() and not AUTHORIZED_CLASSES.has(class_id):
			project_classes.append(class_id)
	_expect(project_classes.size() > 20,
		"only %d project classes were enumerated; the allowlist may be inert"
			% project_classes.size())
	var outside: PackedStringArray = PackedStringArray()
	for class_id: String in project_classes:
		if raw.contains(class_id):
			outside.append(class_id)
	_expect(outside.is_empty(),
		"the run-build state names unauthorized project class(es): %s" % ", ".join(outside))

	## THE METHOD AND FIELD PINS.
	var methods: PackedStringArray = _methods_of(RUN_BUILD_FILE)
	_expect(", ".join(methods) == ", ".join(EXPECTED_METHODS),
		"the run-build state declares: %s" % ", ".join(methods))
	var fields: PackedStringArray = PackedStringArray()
	for entry: Dictionary in RiftRunBuild.new().get_property_list():
		if int(entry.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			fields.append(String(entry.get("name", "")))
	_expect(", ".join(fields) == ", ".join(EXPECTED_FIELDS),
		"the run-build state carries the fields: %s" % ", ".join(fields))
	var exposed: PackedStringArray = PackedStringArray()
	for field: String in fields:
		if not field.begins_with("_"):
			exposed.append(field)
	_expect(exposed.is_empty(),
		"the run-build state exposes the field(s) %s directly" % ", ".join(exposed))

	## NOTHING REFERENCES IT BUT ITS AUTHORIZED READERS, each granted per file and per
	## class above — since Roguelite I3 (D-295), the one run-build application seam
	## among them. Every other file that runs is still refused.
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if D2_FILES.has(path):
				continue
			project_files += 1
			var source: String = FileAccess.get_file_as_string(path)
			for name: String in D2_CLASSES:
				if not source.contains(name):
					continue
				if _is_authorized_reader(path, name):
					continue
				referenced.append("%s names %s" % [path.get_file(), name])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for name: String in D2_CLASSES:
		if settings.contains(name):
			referenced.append("project.godot names %s" % name)
	_expect(referenced.is_empty(),
		"Foundation D2 is referenced by code that runs: %s" % ", ".join(referenced))
	_expect(project_files > 100,
		"only %d project files were scanned, so the scan proves nothing" % project_files)
	_expect(not settings.contains("[autoload]"),
		"project.godot declares an [autoload] section")

	## `scripts/runs/` HOLDS EXACTLY WHAT IT SHOULD. A scratch probe left behind
	## is a project file nobody meant to ship, and every scan above that filters
	## on a known path is blind to it.
	var run_scripts: PackedStringArray = _files_under("res://scripts/runs", [".gd"])
	_expect(", ".join(run_scripts) == RUN_BUILD_FILE,
		"scripts/runs/ holds: %s" % ", ".join(run_scripts))

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

	print("  0 forbidden tokens, 0 ambient reads, 0 deferred members, 0 operators, 0 float literals")
	print("  %d methods and %d fields pinned, all %d fields private; %d project files scanned, 0 name it"
		% [methods.size(), fields.size(), fields.size(), project_files])
	print("  %d refusals were driven across this suite" % _refusals)
	_done("the_state_is_generic_reads_nothing_ambient_and_is_unwired")


# --- Fixtures and helpers ----------------------------------------------------------

## A state holding one pair and one card, so an atomicity claim is made against
## something rather than against nothing.
func _seeded_state() -> RiftRunBuild:
	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"the seeded state could not acquire its support pair")
	_expect(build.acquire_passive_card(_shipped(&"card_celerity")).is_empty(),
		"the seeded state could not acquire its card")
	return build


func _once_only_card() -> PassiveCardDefinition:
	return PassiveCardDefinition.of(
		ONCE_ID, "Probe Bulwark", PlayerStats.MAXIMUM_LIFE, ONCE_MAGNITUDE, 100, false
	)


## A test-only record. Every argument is explicit so a row can differ from
## another in exactly one field and nothing else.
func _probe_card(
	card_id: StringName, presentation: String, stat_id: StringName,
	magnitude: float, weight: int, repeatable: bool
) -> PassiveCardDefinition:
	return PassiveCardDefinition.of(
		card_id, presentation, stat_id, magnitude, weight, repeatable
	)


func _shipped(card_id: StringName) -> PassiveCardDefinition:
	return PassiveCardCatalogue.record(card_id)


func _built_from(sequence: Array[StringName]) -> RiftRunBuild:
	var build: RiftRunBuild = RiftRunBuild.new()
	for card_id: StringName in sequence:
		var refusal: String = build.acquire_passive_card(_shipped(card_id))
		_expect(refusal.is_empty(), "%s was refused while building a sequence: %s" % [
			card_id, refusal,
		])
	return build


## The COMPLETE state as one line, to seventeen significant digits. Every
## atomicity claim in this suite is a comparison of two of these.
func _snapshot(build: RiftRunBuild) -> String:
	var parts: PackedStringArray = PackedStringArray()
	parts.append("pairs[%s]" % ", ".join(build.support_pairs()))
	parts.append("pair_count=%d" % build.support_count())
	var cards: PackedStringArray = PackedStringArray()
	for card_id: StringName in build.acquired_card_ids():
		cards.append("%s x%d {%s}" % [
			card_id, build.acquisitions_for(card_id),
			build.mechanical_identity_for(card_id),
		])
	parts.append("cards[%s]" % ", ".join(cards))
	parts.append("acquisitions=%d" % build.passive_acquisitions())
	for stat_id: StringName in PlayerStats.ALL:
		parts.append("%s=%s(%d)" % [
			stat_id, _exact(build.total_for(stat_id)),
			build.contribution_count_for(stat_id),
		])
	parts.append("empty=%s" % build.is_empty())
	return " | ".join(parts)


## Seventeen decimal places. Every magnitude this foundation carries is well
## below 1, so seventeen places is more than the seventeen significant digits it
## takes to separate any two distinct doubles — which is what makes a comparison
## of these strings a bit-for-bit comparison of the values.
func _exact(value: float) -> String:
	return String.num(value, 17)


func _floats_line(values: PackedFloat64Array) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for value: float in values:
		parts.append(_exact(value))
	return ", ".join(parts)


func _ids_line(values: Array[StringName]) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for value: StringName in values:
		parts.append(String(value))
	return ", ".join(parts)


func _reversed(values: Array[StringName]) -> Array[StringName]:
	var out: Array[StringName] = []
	for index: int in values.size():
		out.append(values[values.size() - 1 - index])
	return out


func _rotated(values: Array[StringName], by: int) -> Array[StringName]:
	var out: Array[StringName] = []
	for index: int in values.size():
		out.append(values[(index + by) % values.size()])
	return out


## Front, back, front, back — an order that is neither the original nor its
## reverse nor a rotation of either.
func _interleaved(values: Array[StringName]) -> Array[StringName]:
	var out: Array[StringName] = []
	var low: int = 0
	var high: int = values.size() - 1
	while low <= high:
		out.append(values[low])
		if low != high:
			out.append(values[high])
		low += 1
		high -= 1
	return out


## Every line that is not a whole-line comment. See `DEFERRED_MEMBER_TOKENS` for
## why exactly this treatment exists.
func _code_only(source: String) -> String:
	var out: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


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


func _methods_of(path: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var script: GDScript = load(path) as GDScript
	if script == null:
		return out
	for entry: Dictionary in script.get_script_method_list():
		out.append(String(entry.get("name", "")))
	return out


## One refusal, counted. A refusal that returned no reason is a refusal a caller
## cannot report, so the reason is required rather than merely expected.
func _expect_refusal(refusal: String, described: String) -> void:
	_refusals += 1
	_expect(not refusal.strip_edges().is_empty(),
		"%s was accepted, or refused without a reason" % described)


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
