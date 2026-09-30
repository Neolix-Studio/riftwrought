extends SceneTree
## Riftwrought — Roguelite Foundation F1 verification: ranked support ownership.
##
## ONE FOCUSED HEADLESS TEST. F1 is a state extension to two accepted pure-logic
## scripts — the acquisition record under `scripts/skills/` and the run-build
## state under `scripts/runs/` — so it needs no scene, no camera, no navigation,
## no rendering and no evidence frame, and it deliberately gets none. It runs as
## a `SceneTree` script exactly as all eight earlier foundations' suites do.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## THE ATOMICITY PROOFS COMPARE THE WHOLE STATE, NOT THE PART THAT WAS TOUCHED,
## AND THE SNAPSHOT NOW CARRIES THE RANK. Every refusal below is checked against
## a COMPLETE snapshot taken immediately before it — every pair AND ITS RANK,
## every card count, every recorded mechanical identity, every stat total
## rendered to seventeen significant digits, and every contribution count. A
## refusal that created a rank without a pair, or moved a rank without moving
## anything else, is caught by the same assertion that catches a refusal which
## changed everything.
##
## THE STATE IS SEEDED BEFORE EVERY ATOMICITY PROOF, ON PURPOSE. "Nothing
## changed" is nearly free to satisfy on an empty record; it is a real claim only
## when there is something there to disturb.
##
## THE ONE TRAP THIS FOUNDATION MAKES EASY, AND IT IS WHY CHECK 3 IS SHAPED THE
## WAY IT IS. `acquire()` must leave an already-held pair's rank exactly where it
## was — and an implementation that writes rank 1 BEFORE asking whether the pair
## is held passes every re-acquisition test performed on a rank-1 pair, because
## 1 overwritten with 1 is 1. So the duplicate refusal is driven against a pair
## RAISED TO RANK 3 first. This is D-241's, D-242's and D-244's lesson in a
## fourth shape: a guard proved only against inputs that would have looked
## correct anyway proves nothing about the guard.
##
## THE TEST DATA IS NOT CONTENT. Every fabricated Skill id, support id, tag
## profile and support definition below lives inside this file only, is
## registered in no catalogue, ships in no scene, no `.tres` and no library, and
## is not canon. The six shipped passive cards appear here as the FIXTURE the
## project can actually author today.

## The two files F1 extends. Both are scanned RAW, comments included — D-215's
## lesson: an illustrative name in a comment breaches the rule just as surely as
## a real one, because the rule exists so a reader can trust the file holds no
## such knowledge.
const RECORD_FILE: String = "res://scripts/skills/acquired_supports.gd"
const RUN_BUILD_FILE: String = "res://scripts/runs/rift_run_build.gd"

const F1_FILES: Array[String] = [
	"res://scripts/skills/acquired_supports.gd",
	"res://scripts/runs/rift_run_build.gd",
]

## The six member names F1 introduces. Nothing that runs may call any of them
## except an authorized caller below: rank effects, rank refunds and every
## run-state rank operation are still later decisions.
const F1_MEMBERS: Array[String] = [
	"rank_for(", "increase_rank(", "total_ranks(",
	"rank_support(", "support_rank_for(", "total_support_ranks(",
]

## THE FILES AUTHORIZED TO CALL A FOUNDATION F1 MEMBER, AND THE EXACT MEMBERS
## EACH MAY CALL (Foundation F3, decision D-255). The accepted three-lane offer composer freezes
## the rank transition its support lane offers, and it MEASURES that transition
## rather than calculating it: it stages the decided operation on a private
## duplicate of the supplied acquisition record and reads the rank back off it on
## either side. Reading a rank and applying the decided operation is the whole of
## that, so it is granted exactly `rank_for(` and `increase_rank(` — and
## `total_ranks(`, the run-build rank raise and both run-build readings are still
## refused to it by the same row that refuses every other file.
##
## THIS REPLACES THE BLANKET "nothing that runs may call any of them" ONE FOR
## ONE: the same single assertion is made either way, it still fails for any
## other file AND for any member a listed file is not granted, and the pinned
## count does not move. THE GRANT IS EARNED FROM THE OTHER SIDE — the Foundation
## F3 suite proves that the composer really does stage through both of these
## members, which is what keeps this exemption from becoming a claim about
## nothing, and it does so where that boundary belongs rather than here.
##
## TWO MORE CALLERS SINCE FOUNDATION F4 (decision D-257), AND EACH IS GRANTED
## EXACTLY WHAT IT USES. The accepted choice transaction CONSUMES the progression
## an offer froze: it reads the run's current rank for the offered pair, applies
## the operation the offer declared through the run build's own rank raise, and
## reads the rank back to check it landed where the offer promised — so it is
## granted `support_rank_for(` and `rank_support(`. The choice RESULT re-asks the
## build it carries whether that pair really holds the rank the choice says it
## consumed, so it is granted `support_rank_for(` alone: it applies nothing.
##
## ONE SUBSTRING IS RECORDED RATHER THAN LEFT TO BE FOUND: `rank_for(` is
## contained in `support_rank_for(`, so a file calling the run-build reading is
## reported as calling the acquisition record's reading too, and a grant for the
## first must carry the second. It costs nothing here, because NEITHER file may
## name `AcquiredSupports` at all — the Foundation D3 suite's per-file class
## allowlist refuses it — so there is no way for either to reach the record's own
## reading however this row is written.
##
## `increase_rank(`, `total_ranks(` AND `total_support_ranks(` STAY REFUSED TO
## BOTH. The transaction must go through the run build rather than around it to
## the acquisition record, and neither the distinct-pair count nor the rank sum is
## anything a choice needs.
##
## ONE OF THOSE THREE MOVED UNDER ROGUELITE FOUNDATION I8 (D-308), FOR THE
## TRANSACTION ALONE. Taking a passive-fallback Support lane must prove it moved no
## support rank, and the run build's own rank sum, read before and after the
## acquisition beside its pair list, is how it reads that — through the run build,
## never around it. `total_support_ranks(` is granted to the transaction and to
## nothing else; its result is still refused it, and `increase_rank(` and
## `total_ranks(` stay refused to both. Same single assertion, same count.
##
## THE GRANTS ARE EARNED FROM THE OTHER SIDE, exactly as the composer's are: the
## Foundation F4 suite proves the transaction really routes to both operations and
## really performs the read-back, and the shell half of this suite requires every
## granted member to be reached.
const AUTHORIZED_CALLERS: Array = [
	["res://scripts/offers/rift_offer_composition.gd", ["rank_for(", "increase_rank("]],
	["res://scripts/choices/rift_offer_choice.gd", [
		"support_rank_for(", "rank_support(", "rank_for(", "total_support_ranks(",
	]],
	["res://scripts/choices/rift_offer_choice_result.gd", [
		"support_rank_for(", "rank_for(",
	]],
	## Roguelite I3 (decision D-295): the one run-build application seam reads, for each
	## pair the build holds on the equipped Skill, the rank the build holds it at, so the
	## catalogue's rank-one value is read for exactly that rank and every other rank is
	## refused. It is granted `support_rank_for(` alone, with the `rank_for(` substring
	## that rides along, and raises, refunds and sums nothing. It names no acquisition
	## record, so the ride-along reaches nothing. Added one for one, and the pinned count
	## does not move.
	["res://scripts/roguelite/live_effects/rift_build_application.gd", [
		"support_rank_for(", "rank_for(",
	]],
	## Roguelite Foundation I5 (decision D-300): the accepted weighted selector's
	## rank-increase draw reads the rank each held pair is at, so a pair already at its
	## support's maximum rank owns no ticket and a pair held above it is refused. It is
	## granted `rank_for(` alone: it raises, sums and refunds nothing, and it reads a
	## rank only to decide whether a pair is a candidate — never to weigh one. Added one
	## for one, and the pinned count does not move.
	["res://scripts/skills/support_selection.gd", ["rank_for("]],
]

## Concrete Skill, support, card, catalogue and instrument names, plus the two
## presentation fields. The same list the eight earlier foundations are held to.
const FORBIDDEN_TOKENS: Array[String] = [
	"QuickStrike", "quick_strike", "Quick Strike",
	"PrototypePlayer", "PrototypeWeaponData", "PrototypeGraveblade",
	"PassiveEffects", "PassiveGraph", "PassiveNodeData",
	"RogueliteUpgrade", "RogueliteRunBoon", "RogueliteBuildState", "RogueliteRunPlan",
	"SkillSupportCatalogue", "PassiveCardCatalogue", "PassiveCardSelection",
	"RiftOffer", "RiftOfferComposition", "RiftLevelUpCoordinator",
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

## THE BALANCE VOCABULARY F1 DELIBERATELY DOES NOT INTRODUCE, as member-name
## tokens, scanned over CODE LINES ONLY. Both headers say in plain English that
## there is no gameplay maximum rank and no diminishing return, so a raw scan for
## those words would be red on exactly the files that promise none of them —
## Gate 1C's lesson, kept. The concrete-name scan above stays RAW, where the
## opposite rule applies.
const DEFERRED_MEMBER_TOKENS: Array[String] = [
	"rank_cap", "max_rank", "maximum_rank", "diminish", "tier", "rarity",
	"effect", "multiplier", "continuation", "exhaust",
	"save", "persist", "storage", "schema",
]

## The methods each extended class declares, IN DECLARATION ORDER. Pinned by name
## rather than by count, because the fault this guards against — a rank
## decrement, a rank setter, a public reading of the nested map — arrives as an
## extra method with a plausible name.
const EXPECTED_RECORD_METHODS: Array[String] = [
	"acquire", "increase_rank", "release", "has", "rank_for",
	"for_skill", "skill_count", "size", "total_ranks", "is_empty",
	"pairs", "duplicated", "describe",
	"_ranks_for", "_sorted",
]

const EXPECTED_BUILD_METHODS: Array[String] = [
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

## One field on the record and three on the state, all private. F1 stores its
## ranks INSIDE the existing nested map rather than beside it, so neither class
## gained a field — which is what keeps a rank and its pair from ever drifting
## apart.
const EXPECTED_RECORD_FIELDS: Array[String] = ["_by_skill"]
const EXPECTED_BUILD_FIELDS: Array[String] = ["_supports", "_totals", "_card_holds"]

const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]

const PROJECT_SETTINGS_FILE: String = "res://project.godot"

# --- Test-only identities ------------------------------------------------------
#
# `zz_` prefixed so they can never be mistaken for content, and so a future
# catalogue entry cannot collide with one.

const SKILL_ALPHA: StringName = &"zz_skill_alpha"
const SKILL_BETA: StringName = &"zz_skill_beta"
const SKILL_GAMMA: StringName = &"zz_skill_gamma"
const SUPPORT_REACH: StringName = &"zz_support_reach"
const SUPPORT_SWEEP: StringName = &"zz_support_sweep"
const SUPPORT_HASTE: StringName = &"zz_support_haste"
const ABSENT_SUPPORT: StringName = &"zz_support_absent"

## The generic Skills and support the Foundation B selection proof is made
## against. Named as B's own suite names them so a reader comparing the two sees
## the same fixture rather than a second one.
const SELECT_SKILL_ONE: StringName = &"s1_contact"
const SELECT_SKILL_TWO: StringName = &"s2_contact"
const SELECT_SUPPORT: StringName = &"t1_any_melee"

## How many first-stage tickets the availability sweep walks. Every ticket, not a
## sample: an excluded Skill must be UNREACHABLE rather than merely unlikely.
const SWEEP_TICKETS: int = 600

## How many times check 15 raises one pair. Large enough that "+1 each time" is a
## claim about a long run rather than about three calls, and astronomically short
## of the representational ceiling — which is the point it is making.
const LONG_RUN_RAISES: int = 1000

## Nothing a run could ever reach. Used only to state that the representational
## ceiling is not a gameplay number in disguise.
const IMPLAUSIBLE_GAMEPLAY_RANK: int = 1_000_000_000_000_000_000

const OWED_CHECKS: Array[String] = [
	"an_empty_record_and_an_empty_build_report_zero_pairs_and_zero_ranks",
	"a_first_acquisition_begins_at_rank_one",
	"a_duplicate_acquisition_is_refused_and_leaves_the_rank_untouched",
	"ranking_an_existing_pair_produces_rank_two_and_then_three",
	"ranking_an_absent_pair_refuses_atomically_and_creates_no_ghost_pair",
	"blank_identifiers_refuse_without_mutation_at_the_run_build_boundary",
	"one_support_on_two_skills_and_two_supports_on_one_skill_rank_independently",
	"distinct_pairs_and_total_ranks_are_different_numbers",
	"stable_listings_do_not_depend_on_acquisition_or_ranking_order",
	"duplicating_preserves_every_rank_and_shares_no_storage",
	"releasing_a_ranked_pair_removes_the_pair_and_all_of_its_ranks",
	"ranking_moves_no_passive_total_no_count_and_no_card_identity",
	"an_acquired_pair_is_unavailable_to_selection_at_every_rank",
	"first_acquisition_behaviour_at_the_run_build_boundary_is_unchanged",
	"the_rank_ceiling_is_the_representational_boundary_and_is_unreachable",
	"the_two_records_are_generic_read_nothing_ambient_and_are_unwired",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation F1 — Ranked Support Ownership ===")

	_check_an_empty_record_and_an_empty_build_report_zero_pairs_and_zero_ranks()
	_check_a_first_acquisition_begins_at_rank_one()
	_check_a_duplicate_acquisition_is_refused_and_leaves_the_rank_untouched()
	_check_ranking_an_existing_pair_produces_rank_two_and_then_three()
	_check_ranking_an_absent_pair_refuses_atomically_and_creates_no_ghost_pair()
	_check_blank_identifiers_refuse_without_mutation_at_the_run_build_boundary()
	_check_one_support_on_two_skills_and_two_supports_on_one_skill_rank_independently()
	_check_distinct_pairs_and_total_ranks_are_different_numbers()
	_check_stable_listings_do_not_depend_on_acquisition_or_ranking_order()
	_check_duplicating_preserves_every_rank_and_shares_no_storage()
	_check_releasing_a_ranked_pair_removes_the_pair_and_all_of_its_ranks()
	_check_ranking_moves_no_passive_total_no_count_and_no_card_identity()
	_check_an_acquired_pair_is_unavailable_to_selection_at_every_rank()
	_check_first_acquisition_behaviour_at_the_run_build_boundary_is_unchanged()
	_check_the_rank_ceiling_is_the_representational_boundary_and_is_unreachable()
	_check_the_two_records_are_generic_read_nothing_ambient_and_are_unwired()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RANKED SUPPORT OWNERSHIP VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RANKED SUPPORT OWNERSHIP VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. Empty means zero pairs AND zero ranks ----------------------------------

func _check_an_empty_record_and_an_empty_build_report_zero_pairs_and_zero_ranks() -> void:
	print("")
	print("--- 1. A new record and a new run build hold zero pairs and zero ranks")

	## The two named constants first, because every answer below is one of them
	## and a suite that compared numbers to themselves would prove nothing.
	_expect(AcquiredSupports.ABSENT_RANK == 0,
		"an absent pair reports rank %d, not 0" % AcquiredSupports.ABSENT_RANK)
	_expect(AcquiredSupports.FIRST_RANK == 1,
		"a first acquisition begins at rank %d, not 1" % AcquiredSupports.FIRST_RANK)
	_expect(AcquiredSupports.FIRST_RANK > AcquiredSupports.ABSENT_RANK,
		"a held pair's first rank does not outrank an absent one")

	var record: AcquiredSupports = AcquiredSupports.new()
	_expect(record.is_empty(), "a new record does not report itself empty")
	_expect(record.size() == 0, "a new record holds %d pairs" % record.size())
	_expect(record.skill_count() == 0, "a new record holds %d Skills" % record.skill_count())
	_expect(record.total_ranks() == 0, "a new record holds %d ranks" % record.total_ranks())
	_expect(record.pairs().is_empty(),
		"a new record reports the pairs %s" % ", ".join(record.pairs()))
	_expect(record.describe() == "no supports acquired",
		"a new record describes itself as '%s'" % record.describe())
	_expect(not record.has(SKILL_ALPHA, SUPPORT_REACH), "a new record claims to hold a pair")
	_expect(record.rank_for(SKILL_ALPHA, SUPPORT_REACH) == AcquiredSupports.ABSENT_RANK,
		"a pair the record never heard of reports rank %d"
			% record.rank_for(SKILL_ALPHA, SUPPORT_REACH))
	_expect(record.for_skill(SKILL_ALPHA).is_empty(),
		"a new record lists supports for a Skill it has never heard of")

	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.is_empty(), "a new run build does not report itself empty")
	_expect(build.support_count() == 0,
		"a new run build holds %d pairs" % build.support_count())
	_expect(build.total_support_ranks() == 0,
		"a new run build holds %d support ranks" % build.total_support_ranks())
	_expect(build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH) == 0,
		"a new run build reports rank %d for a pair it never acquired"
			% build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH))
	_expect(build.support_pairs().is_empty(),
		"a new run build reports the pairs %s" % ", ".join(build.support_pairs()))
	_expect(not build.has_support(SKILL_ALPHA, SUPPORT_REACH),
		"a new run build claims to hold a pair")

	## The copy it hands out is empty too, ranks included.
	var exposed: AcquiredSupports = build.acquired_supports()
	_expect(exposed != null and exposed.is_empty() and exposed.total_ranks() == 0,
		"the copy a new run build hands out is missing or not empty")

	print("  a new record and a new run build: 0 pairs, 0 ranks, 0 Skills; absent reports rank 0")
	_done("an_empty_record_and_an_empty_build_report_zero_pairs_and_zero_ranks")


# --- 2. A first acquisition begins at rank 1 -----------------------------------

func _check_a_first_acquisition_begins_at_rank_one() -> void:
	print("")
	print("--- 2. The first acquisition of a pair succeeds and begins at rank 1")

	var record: AcquiredSupports = AcquiredSupports.new()
	_expect(record.acquire(SKILL_ALPHA, SUPPORT_REACH), "the first acquisition was refused")
	_expect(record.has(SKILL_ALPHA, SUPPORT_REACH), "the acquired pair is not recorded")
	_expect(record.rank_for(SKILL_ALPHA, SUPPORT_REACH) == 1,
		"a first acquisition recorded rank %d, not 1"
			% record.rank_for(SKILL_ALPHA, SUPPORT_REACH))
	_expect(record.size() == 1, "the record holds %d pairs, not 1" % record.size())
	_expect(record.total_ranks() == 1, "the record holds %d ranks, not 1" % record.total_ranks())
	_expect(record.skill_count() == 1, "the record holds %d Skills, not 1" % record.skill_count())
	_expect(not record.is_empty(), "a record holding one pair reports itself empty")
	_expect(_ids_line(record.for_skill(SKILL_ALPHA)) == String(SUPPORT_REACH),
		"the Skill lists %s" % _ids_line(record.for_skill(SKILL_ALPHA)))
	_expect(", ".join(record.pairs()) == "%s -> %s" % [SKILL_ALPHA, SUPPORT_REACH],
		"the record lists the pairs %s" % ", ".join(record.pairs()))
	_expect(record.describe() == "%s -> %s" % [SKILL_ALPHA, SUPPORT_REACH],
		"the record describes itself as '%s'" % record.describe())

	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"the run build refused a first acquisition")
	_expect(build.support_count() == 1,
		"the run build holds %d pairs, not 1" % build.support_count())
	_expect(build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH) == 1,
		"the run build recorded rank %d, not 1"
			% build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH))
	_expect(build.total_support_ranks() == 1,
		"the run build holds %d ranks, not 1" % build.total_support_ranks())
	_expect(build.has_support(SKILL_ALPHA, SUPPORT_REACH),
		"the run build does not hold the pair it just acquired")

	## The exact three numbers the brief names for a newly acquired pair.
	_expect(build.support_count() == 1 and build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH) == 1
			and build.total_support_ranks() == 1,
		"a newly acquired pair reports count %d, rank %d, total %d" % [
			build.support_count(), build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH),
			build.total_support_ranks(),
		])

	## The copy agrees, which is what makes the reading and the record one fact.
	var exposed: AcquiredSupports = build.acquired_supports()
	_expect(exposed.rank_for(SKILL_ALPHA, SUPPORT_REACH) == 1 and exposed.total_ranks() == 1,
		"the exposed copy disagrees about the rank: %s" % _record_snapshot(exposed))

	print("  first acquisition: count 1, rank 1, total ranks 1, at the record and the run build")
	_done("a_first_acquisition_begins_at_rank_one")


# --- 3. A duplicate acquisition never touches the rank -------------------------

func _check_a_duplicate_acquisition_is_refused_and_leaves_the_rank_untouched() -> void:
	print("")
	print("--- 3. A duplicate acquisition is refused and leaves the existing rank alone")

	## FIRST AT RANK 1, WHICH IS THE CASE THE BRIEF NAMES.
	var record: AcquiredSupports = AcquiredSupports.new()
	_expect(record.acquire(SKILL_ALPHA, SUPPORT_REACH), "the first acquisition was refused")
	_expect(not record.acquire(SKILL_ALPHA, SUPPORT_REACH),
		"the same pair was acquired twice")
	_expect(record.rank_for(SKILL_ALPHA, SUPPORT_REACH) == 1,
		"a refused duplicate moved the rank to %d"
			% record.rank_for(SKILL_ALPHA, SUPPORT_REACH))
	_expect(record.size() == 1 and record.total_ranks() == 1,
		"a refused duplicate changed the record to %s" % _record_snapshot(record))

	## AND THEN AT RANK 3, WHICH IS THE CASE THAT CAN ACTUALLY FAIL. An
	## implementation that writes rank 1 before asking whether the pair is held
	## passes every assertion above — 1 overwritten with 1 is 1 — and silently
	## resets a raised pair here.
	_expect(record.increase_rank(SKILL_ALPHA, SUPPORT_REACH), "the first raise was refused")
	_expect(record.increase_rank(SKILL_ALPHA, SUPPORT_REACH), "the second raise was refused")
	_expect(record.rank_for(SKILL_ALPHA, SUPPORT_REACH) == 3,
		"the pair reached rank %d, not 3" % record.rank_for(SKILL_ALPHA, SUPPORT_REACH))
	var before_raised: String = _record_snapshot(record)
	_expect(not record.acquire(SKILL_ALPHA, SUPPORT_REACH),
		"a rank-3 pair was acquired again")
	_expect(record.rank_for(SKILL_ALPHA, SUPPORT_REACH) == 3,
		"a refused duplicate RESET a rank-3 pair to %d"
			% record.rank_for(SKILL_ALPHA, SUPPORT_REACH))
	_expect(_record_snapshot(record) == before_raised,
		"a refused duplicate changed the record from %s to %s" % [
			before_raised, _record_snapshot(record),
		])

	## THE SAME TWO CASES AT THE RUN-BUILD BOUNDARY, where the refusal must also
	## keep the exact accepted sentence D-241 shipped.
	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"the run build refused a first acquisition")
	var seeded: String = _snapshot(build)
	var refusal: String = build.acquire_support(SKILL_ALPHA, SUPPORT_REACH)
	_expect_refusal(refusal, "a duplicate acquisition of a rank-1 pair")
	_expect(refusal.contains("is already acquired for that Skill"),
		"the duplicate refusal reads '%s'" % refusal)
	_expect(_snapshot(build) == seeded,
		"a refused duplicate changed the run build from %s to %s" % [seeded, _snapshot(build)])

	_expect(build.rank_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(), "the first raise was refused")
	_expect(build.rank_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(), "the second raise was refused")
	_expect(build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH) == 3,
		"the run build reached rank %d, not 3"
			% build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH))
	var raised: String = _snapshot(build)
	var refusal_again: String = build.acquire_support(SKILL_ALPHA, SUPPORT_REACH)
	_expect_refusal(refusal_again, "a duplicate acquisition of a rank-3 pair")
	_expect(build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH) == 3,
		"a refused duplicate RESET the run build's rank to %d"
			% build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH))
	_expect(_snapshot(build) == raised,
		"a refused duplicate changed the run build from %s to %s" % [raised, _snapshot(build)])

	print("  a duplicate is refused at rank 1 AND at rank 3; neither rank moved")
	_done("a_duplicate_acquisition_is_refused_and_leaves_the_rank_untouched")


# --- 4. Ranking produces 2 and then 3 -------------------------------------------

func _check_ranking_an_existing_pair_produces_rank_two_and_then_three() -> void:
	print("")
	print("--- 4. Raising a held pair produces rank 2 and then rank 3")

	var record: AcquiredSupports = AcquiredSupports.new()
	_expect(record.acquire(SKILL_ALPHA, SUPPORT_REACH), "the acquisition was refused")
	_expect(record.increase_rank(SKILL_ALPHA, SUPPORT_REACH), "the raise to 2 was refused")
	_expect(record.rank_for(SKILL_ALPHA, SUPPORT_REACH) == 2,
		"the first raise produced rank %d, not 2" % record.rank_for(SKILL_ALPHA, SUPPORT_REACH))
	_expect(record.size() == 1, "raising a rank changed the pair count to %d" % record.size())
	_expect(record.total_ranks() == 2, "the record holds %d ranks, not 2" % record.total_ranks())
	_expect(record.increase_rank(SKILL_ALPHA, SUPPORT_REACH), "the raise to 3 was refused")
	_expect(record.rank_for(SKILL_ALPHA, SUPPORT_REACH) == 3,
		"the second raise produced rank %d, not 3" % record.rank_for(SKILL_ALPHA, SUPPORT_REACH))
	_expect(record.size() == 1, "raising a rank changed the pair count to %d" % record.size())
	_expect(record.total_ranks() == 3, "the record holds %d ranks, not 3" % record.total_ranks())

	## THE LISTING DOES NOT MOVE, and that is an accepted-output claim rather than
	## a decorative one: `pairs()` is what every earlier foundation compares.
	_expect(", ".join(record.pairs()) == "%s -> %s" % [SKILL_ALPHA, SUPPORT_REACH],
		"raising a rank changed the pair listing to %s" % ", ".join(record.pairs()))
	_expect(record.describe() == "%s -> %s" % [SKILL_ALPHA, SUPPORT_REACH],
		"raising a rank changed the description to '%s'" % record.describe())
	_expect(record.skill_count() == 1,
		"raising a rank changed the Skill count to %d" % record.skill_count())

	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"the run build refused the acquisition")
	var first_pairs: String = ", ".join(build.support_pairs())
	_expect(build.rank_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"the run build refused the raise to 2")
	_expect(build.support_count() == 1 and build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH) == 2
			and build.total_support_ranks() == 2,
		"after one raise the run build reports count %d, rank %d, total %d" % [
			build.support_count(), build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH),
			build.total_support_ranks(),
		])
	_expect(build.rank_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"the run build refused the raise to 3")
	_expect(build.support_count() == 1 and build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH) == 3
			and build.total_support_ranks() == 3,
		"after two raises the run build reports count %d, rank %d, total %d" % [
			build.support_count(), build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH),
			build.total_support_ranks(),
		])
	_expect(", ".join(build.support_pairs()) == first_pairs,
		"raising a rank changed the run build's pair listing to %s"
			% ", ".join(build.support_pairs()))
	_expect(build.has_support(SKILL_ALPHA, SUPPORT_REACH),
		"a raised pair is no longer held")

	print("  one pair raised twice: 1 -> 2 -> 3; count stays 1; the listing never moved")
	_done("ranking_an_existing_pair_produces_rank_two_and_then_three")


# --- 5. Ranking an absent pair creates nothing ---------------------------------

func _check_ranking_an_absent_pair_refuses_atomically_and_creates_no_ghost_pair() -> void:
	print("")
	print("--- 5. Raising a pair that is not held refuses and creates nothing at all")

	## A POSITIVE CONTROL FIRST. A guard that refuses everything protects nothing.
	var control: AcquiredSupports = AcquiredSupports.new()
	_expect(control.acquire(SKILL_ALPHA, SUPPORT_REACH), "the control acquisition was refused")
	_expect(control.increase_rank(SKILL_ALPHA, SUPPORT_REACH),
		"the control raise was refused, so no refusal below proves anything")

	## An entirely empty record: no pair, and no Skill entry either.
	var empty: AcquiredSupports = AcquiredSupports.new()
	_expect(not empty.increase_rank(SKILL_ALPHA, SUPPORT_REACH),
		"an absent pair was raised")
	_expect(empty.is_empty() and empty.size() == 0 and empty.total_ranks() == 0
			and empty.skill_count() == 0,
		"a refused raise created state: %s" % _record_snapshot(empty))
	_expect(not empty.has(SKILL_ALPHA, SUPPORT_REACH),
		"a refused raise created the pair it refused")
	_expect(empty.rank_for(SKILL_ALPHA, SUPPORT_REACH) == 0,
		"a refused raise left rank %d behind" % empty.rank_for(SKILL_ALPHA, SUPPORT_REACH))

	## A record holding a DIFFERENT support for the SAME Skill. This is the case
	## that could create a ghost entry inside an inner map that already exists.
	var seeded: AcquiredSupports = _seeded_record()
	var before: String = _record_snapshot(seeded)
	_expect(not seeded.increase_rank(SKILL_ALPHA, ABSENT_SUPPORT),
		"an unheld support was raised for a Skill that holds another")
	_expect(_record_snapshot(seeded) == before,
		"a refused raise changed the record from %s to %s" % [
			before, _record_snapshot(seeded),
		])
	_expect(not seeded.has(SKILL_ALPHA, ABSENT_SUPPORT),
		"a refused raise created a ghost pair on an existing Skill")

	## And an unheld SKILL, which could create an empty Skill entry.
	_expect(not seeded.increase_rank(SKILL_GAMMA, SUPPORT_REACH),
		"a pair on an unheld Skill was raised")
	_expect(_record_snapshot(seeded) == before,
		"a refused raise on an unheld Skill changed the record to %s"
			% _record_snapshot(seeded))
	_expect(seeded.for_skill(SKILL_GAMMA).is_empty(),
		"a refused raise created an entry for an unheld Skill")

	## THE SAME THREE CASES AT THE RUN-BUILD BOUNDARY, each atomic against the
	## COMPLETE snapshot rather than against the field it was about.
	var build: RiftRunBuild = _seeded_build()
	var snapshot: String = _snapshot(build)
	var cases: Array = [
		["an unheld support on a held Skill", SKILL_ALPHA, ABSENT_SUPPORT],
		["a pair on a Skill the run never acquired", SKILL_GAMMA, SUPPORT_REACH],
		["a pair on a Skill and support it never acquired", SKILL_GAMMA, ABSENT_SUPPORT],
	]
	for row: Array in cases:
		var described: String = String(row[0])
		var refusal: String = build.rank_support(row[1] as StringName, row[2] as StringName)
		_expect_refusal(refusal, described)
		_expect(refusal.contains("has not been acquired for that Skill"),
			"%s was refused with '%s'" % [described, refusal])
		_expect(_snapshot(build) == snapshot,
			"%s changed the run build to %s" % [described, _snapshot(build)])
		_expect(build.support_rank_for(row[1] as StringName, row[2] as StringName) == 0,
			"%s left rank %d behind" % [
				described, build.support_rank_for(row[1] as StringName, row[2] as StringName),
			])

	## A pair that WAS held and has been released is absent again, which is the
	## same refusal reached from the other direction.
	var released: RiftRunBuild = _seeded_build()
	var exposed: AcquiredSupports = released.acquired_supports()
	_expect(exposed.release(SKILL_ALPHA, SUPPORT_REACH),
		"the exposed copy could not release the pair")
	_expect(released.rank_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"releasing on a COPY made the run build refuse its own held pair")

	print("  3 absent-pair refusals at the run build and 3 at the record; 0 ghost pairs created")
	_done("ranking_an_absent_pair_refuses_atomically_and_creates_no_ghost_pair")


# --- 6. Blank identifiers refuse without mutation -------------------------------

func _check_blank_identifiers_refuse_without_mutation_at_the_run_build_boundary() -> void:
	print("")
	print("--- 6. A blank Skill or support identifier refuses without changing anything")

	var build: RiftRunBuild = _seeded_build()
	_expect(build.rank_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"the positive control raise was refused, so no refusal below proves anything")
	var snapshot: String = _snapshot(build)

	var rows: Array = [
		["an empty Skill id", &"", SUPPORT_REACH],
		["a whitespace Skill id", &"   ", SUPPORT_REACH],
		["an empty support id", SKILL_ALPHA, &""],
		["a whitespace support id", SKILL_ALPHA, &"   "],
		["both identifiers empty", &"", &""],
	]
	for row: Array in rows:
		var described: String = String(row[0])
		var refusal: String = build.rank_support(row[1] as StringName, row[2] as StringName)
		_expect_refusal(refusal, "%s in a rank increase" % described)
		_expect(refusal.contains("must name"),
			"%s was refused with '%s'" % [described, refusal])
		_expect(_snapshot(build) == snapshot,
			"%s changed the run build to %s" % [described, _snapshot(build)])

	## The accepted acquisition refusals are unchanged by F1, driven on the same
	## seeded state so a regression in either operation is visible here.
	for row: Array in rows:
		var described: String = String(row[0])
		var refusal: String = build.acquire_support(row[1] as StringName, row[2] as StringName)
		_expect_refusal(refusal, "%s in an acquisition" % described)
		_expect(_snapshot(build) == snapshot,
			"%s in an acquisition changed the run build to %s" % [described, _snapshot(build)])

	_expect(build.support_count() == 2,
		"the seeded run build holds %d pairs after 10 refusals" % build.support_count())

	print("  5 blank-identifier rank refusals and 5 acquisition refusals; the state never moved")
	_done("blank_identifiers_refuse_without_mutation_at_the_run_build_boundary")


# --- 7. Ranks are scoped to the pair --------------------------------------------

func _check_one_support_on_two_skills_and_two_supports_on_one_skill_rank_independently() -> void:
	print("")
	print("--- 7. One support on two Skills, and two supports on one Skill, rank independently")

	## ONE SUPPORT, TWO SKILLS: two pairs, two ranks, and neither reaches the other.
	var across: RiftRunBuild = RiftRunBuild.new()
	_expect(across.acquire_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"the first cross-Skill acquisition was refused")
	_expect(across.acquire_support(SKILL_BETA, SUPPORT_REACH).is_empty(),
		"the same support was refused for a second Skill")
	_expect(across.support_count() == 2,
		"one support on two Skills is %d pairs, not 2" % across.support_count())
	_expect(across.total_support_ranks() == 2,
		"two fresh pairs hold %d ranks, not 2" % across.total_support_ranks())
	_expect(across.rank_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(), "raise one was refused")
	_expect(across.rank_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(), "raise two was refused")
	_expect(across.support_rank_for(SKILL_ALPHA, SUPPORT_REACH) == 3,
		"the raised pair is at rank %d, not 3"
			% across.support_rank_for(SKILL_ALPHA, SUPPORT_REACH))
	_expect(across.support_rank_for(SKILL_BETA, SUPPORT_REACH) == 1,
		"raising one Skill's pair moved the other Skill's to rank %d"
			% across.support_rank_for(SKILL_BETA, SUPPORT_REACH))
	_expect(across.support_count() == 2,
		"raising a rank changed the pair count to %d" % across.support_count())
	_expect(across.total_support_ranks() == 4,
		"3 + 1 reported as %d total ranks" % across.total_support_ranks())

	## AND THE OTHER DIRECTION, because one direction alone would miss a record
	## that wrote every rank into the first Skill it saw.
	_expect(across.rank_support(SKILL_BETA, SUPPORT_REACH).is_empty(),
		"the second Skill's raise was refused")
	_expect(across.support_rank_for(SKILL_BETA, SUPPORT_REACH) == 2
			and across.support_rank_for(SKILL_ALPHA, SUPPORT_REACH) == 3,
		"raising the second Skill moved the first: %s" % _snapshot(across))

	## TWO SUPPORTS, ONE SKILL: two pairs on one Skill entry, ranked separately.
	var within: RiftRunBuild = RiftRunBuild.new()
	_expect(within.acquire_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"the first same-Skill acquisition was refused")
	_expect(within.acquire_support(SKILL_ALPHA, SUPPORT_SWEEP).is_empty(),
		"the second same-Skill acquisition was refused")
	_expect(within.support_count() == 2,
		"two supports on one Skill is %d pairs, not 2" % within.support_count())
	_expect(within.rank_support(SKILL_ALPHA, SUPPORT_SWEEP).is_empty(),
		"the same-Skill raise was refused")
	_expect(within.support_rank_for(SKILL_ALPHA, SUPPORT_SWEEP) == 2,
		"the raised support is at rank %d, not 2"
			% within.support_rank_for(SKILL_ALPHA, SUPPORT_SWEEP))
	_expect(within.support_rank_for(SKILL_ALPHA, SUPPORT_REACH) == 1,
		"raising one support moved the other on the same Skill to rank %d"
			% within.support_rank_for(SKILL_ALPHA, SUPPORT_REACH))
	_expect(within.total_support_ranks() == 3,
		"2 + 1 reported as %d total ranks" % within.total_support_ranks())
	_expect(within.rank_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"the other same-Skill raise was refused")
	_expect(within.support_rank_for(SKILL_ALPHA, SUPPORT_REACH) == 2
			and within.support_rank_for(SKILL_ALPHA, SUPPORT_SWEEP) == 2,
		"the two same-Skill supports did not rank independently: %s" % _snapshot(within))

	## A record that keyed on a separator would merge two different pairs. F1
	## stores a rank inside the same nested map, so it cannot.
	var tricky: AcquiredSupports = AcquiredSupports.new()
	_expect(tricky.acquire(&"a|b", &"c"), "the separator-bearing pair was refused")
	_expect(tricky.increase_rank(&"a|b", &"c"), "the separator-bearing pair could not be raised")
	_expect(tricky.rank_for(&"a", &"b|c") == 0,
		"two different pairs collided through a joined key at rank %d"
			% tricky.rank_for(&"a", &"b|c"))
	_expect(tricky.size() == 1 and tricky.total_ranks() == 2,
		"the separator-bearing record reads %s" % _record_snapshot(tricky))

	print("  one support on 2 Skills: ranks 3 and 2; two supports on 1 Skill: ranks 2 and 2")
	_done("one_support_on_two_skills_and_two_supports_on_one_skill_rank_independently")


# --- 8. Pairs and ranks are different numbers -----------------------------------

func _check_distinct_pairs_and_total_ranks_are_different_numbers() -> void:
	print("")
	print("--- 8. The pair count counts pairs and the rank total counts ranks")

	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(), "acquisition 1 refused")
	_expect(build.acquire_support(SKILL_ALPHA, SUPPORT_SWEEP).is_empty(), "acquisition 2 refused")
	_expect(build.acquire_support(SKILL_BETA, SUPPORT_HASTE).is_empty(), "acquisition 3 refused")
	_expect(build.support_count() == 3,
		"three pairs report as %d" % build.support_count())
	_expect(build.total_support_ranks() == 3,
		"three fresh pairs report %d ranks" % build.total_support_ranks())
	_expect(build.support_count() == build.total_support_ranks(),
		"the two counts disagree before anything has been raised")

	## Raise the second pair once and the third three times: 1 + 2 + 4 = 7 ranks
	## over 3 pairs.
	_expect(build.rank_support(SKILL_ALPHA, SUPPORT_SWEEP).is_empty(), "raise refused")
	for _index: int in 3:
		_expect(build.rank_support(SKILL_BETA, SUPPORT_HASTE).is_empty(), "raise refused")
	_expect(build.support_count() == 3,
		"four raises changed the pair count to %d" % build.support_count())
	_expect(build.total_support_ranks() == 7,
		"1 + 2 + 4 reported as %d total ranks" % build.total_support_ranks())
	_expect(build.support_count() != build.total_support_ranks(),
		"the pair count and the rank total are the same number after four raises")
	_expect(build.support_pairs().size() == 3,
		"the pair listing carries %d rows, not 3" % build.support_pairs().size())

	## The same distinction one level down, where the two functions live.
	var record: AcquiredSupports = build.acquired_supports()
	_expect(record.size() == 3, "the record reports %d pairs, not 3" % record.size())
	_expect(record.total_ranks() == 7, "the record reports %d ranks, not 7" % record.total_ranks())
	_expect(record.skill_count() == 2,
		"three pairs over two Skills report %d Skills" % record.skill_count())
	_expect(record.for_skill(SKILL_ALPHA).size() == 2,
		"the first Skill lists %d supports, not 2" % record.for_skill(SKILL_ALPHA).size())

	## The individual ranks, so "7" cannot be right for the wrong reason.
	_expect(build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH) == 1
			and build.support_rank_for(SKILL_ALPHA, SUPPORT_SWEEP) == 2
			and build.support_rank_for(SKILL_BETA, SUPPORT_HASTE) == 4,
		"the three ranks read %d / %d / %d, not 1 / 2 / 4" % [
			build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH),
			build.support_rank_for(SKILL_ALPHA, SUPPORT_SWEEP),
			build.support_rank_for(SKILL_BETA, SUPPORT_HASTE),
		])

	print("  3 distinct pairs at ranks 1 / 2 / 4 = 7 total ranks; the two counts are not the same")
	_done("distinct_pairs_and_total_ranks_are_different_numbers")


# --- 9. Order cannot move a listing ---------------------------------------------

func _check_stable_listings_do_not_depend_on_acquisition_or_ranking_order() -> void:
	print("")
	print("--- 9. Acquisition order and ranking order move no listing and no rank")

	## Four pairs, four different acquisition orders, and a DIFFERENT ranking
	## order in each — so a listing that depended on either would disagree.
	var pairs: Array = [
		[SKILL_BETA, SUPPORT_SWEEP, 1],
		[SKILL_ALPHA, SUPPORT_HASTE, 4],
		[SKILL_ALPHA, SUPPORT_REACH, 2],
		[SKILL_BETA, SUPPORT_HASTE, 3],
	]
	var orders: Array = [
		[0, 1, 2, 3],
		[3, 2, 1, 0],
		[2, 3, 0, 1],
		[1, 3, 0, 2],
	]

	var listings: PackedStringArray = PackedStringArray()
	var snapshots: PackedStringArray = PackedStringArray()
	for order: Array in orders:
		var build: RiftRunBuild = RiftRunBuild.new()
		for index: int in order:
			var row: Array = pairs[index]
			_expect(build.acquire_support(row[0] as StringName, row[1] as StringName).is_empty(),
				"an acquisition was refused while building an order")
		## Ranking runs in the REVERSE of the acquisition order, so the two
		## orders differ from each other as well as between rows.
		for offset: int in order.size():
			var row: Array = pairs[order[order.size() - 1 - offset]]
			for _raise: int in int(row[2]) - 1:
				_expect(build.rank_support(row[0] as StringName, row[1] as StringName).is_empty(),
					"a raise was refused while building an order")
		listings.append(", ".join(build.support_pairs()))
		snapshots.append(_snapshot(build))

	var first_listing: String = listings[0]
	var first_snapshot: String = snapshots[0]
	var listing_drift: int = 0
	var snapshot_drift: int = 0
	for index: int in listings.size():
		if listings[index] != first_listing:
			listing_drift += 1
		if snapshots[index] != first_snapshot:
			snapshot_drift += 1
	_expect(listing_drift == 0,
		"%d of %d orders produced a different listing: %s" % [
			listing_drift, listings.size(), " || ".join(listings),
		])
	_expect(snapshot_drift == 0,
		"%d of %d orders produced a different complete state: %s" % [
			snapshot_drift, snapshots.size(), " || ".join(snapshots),
		])

	## The listing is the accepted one — Skills alphabetically, then supports
	## alphabetically — and carries no rank, which is what keeps every earlier
	## foundation's comparison meaning what it meant.
	_expect(first_listing == "%s -> %s, %s -> %s, %s -> %s, %s -> %s" % [
			SKILL_ALPHA, SUPPORT_HASTE, SKILL_ALPHA, SUPPORT_REACH,
			SKILL_BETA, SUPPORT_HASTE, SKILL_BETA, SUPPORT_SWEEP,
		],
		"the stable listing reads %s" % first_listing)
	_expect(not first_listing.contains("rank") and not first_listing.contains("x2"),
		"the pair listing carries a rank: %s" % first_listing)
	_expect(first_snapshot.contains("ranks=10"),
		"1 + 2 + 3 + 4 did not report 10 total ranks: %s" % first_snapshot)

	print("  4 acquisition orders x 4 ranking orders: 0 listing drift, 0 state drift")
	_done("stable_listings_do_not_depend_on_acquisition_or_ranking_order")


# --- 10. Duplication preserves ranks and shares nothing -------------------------

func _check_duplicating_preserves_every_rank_and_shares_no_storage() -> void:
	print("")
	print("--- 10. Duplicating preserves every rank and shares no storage, in both directions")

	## THE ENGINE PROBE FIRST, AND WITHOUT IT EVERY ASSERTION BELOW WOULD BE
	## SATISFIED BY AN ENGINE THAT COPIED ANYWAY. D-249 learned this in the
	## packed-array shape; a Dictionary read out of a Dictionary is the same
	## Dictionary, which is exactly why each inner rank map has to be duplicated.
	var outer: Dictionary = {}
	var inner: Dictionary = {}
	inner[&"probe"] = 1
	outer[&"skill"] = inner
	var read_back: Dictionary = outer[&"skill"]
	read_back[&"probe"] = 5
	_expect(int((outer[&"skill"] as Dictionary)[&"probe"]) == 5,
		"the engine copied a Dictionary read out of a Dictionary, so these proofs are vacuous")
	var duplicated_inner: Dictionary = (outer[&"skill"] as Dictionary).duplicate()
	duplicated_inner[&"probe"] = 9
	_expect(int((outer[&"skill"] as Dictionary)[&"probe"]) == 5,
		"duplicate() did not detach the inner map, so nothing below can be proved")

	## THE RECORD. Three pairs at ranks 1, 3 and 5.
	var original: AcquiredSupports = AcquiredSupports.new()
	_expect(original.acquire(SKILL_ALPHA, SUPPORT_REACH), "acquisition 1 refused")
	_expect(original.acquire(SKILL_ALPHA, SUPPORT_SWEEP), "acquisition 2 refused")
	_expect(original.acquire(SKILL_BETA, SUPPORT_HASTE), "acquisition 3 refused")
	for _index: int in 2:
		_expect(original.increase_rank(SKILL_ALPHA, SUPPORT_SWEEP), "a raise was refused")
	for _index: int in 4:
		_expect(original.increase_rank(SKILL_BETA, SUPPORT_HASTE), "a raise was refused")
	var original_state: String = _record_snapshot(original)
	_expect(original_state.contains("ranks=9"),
		"1 + 3 + 5 did not report 9 total ranks: %s" % original_state)

	var copy: AcquiredSupports = original.duplicated()
	_expect(_record_snapshot(copy) == original_state,
		"the duplicate reads %s, not %s" % [_record_snapshot(copy), original_state])
	_expect(copy.rank_for(SKILL_ALPHA, SUPPORT_SWEEP) == 3
			and copy.rank_for(SKILL_BETA, SUPPORT_HASTE) == 5,
		"the duplicate lost an exact rank: %s" % _record_snapshot(copy))

	## Ranking the duplicate cannot move the original.
	_expect(copy.increase_rank(SKILL_ALPHA, SUPPORT_SWEEP), "the duplicate refused a raise")
	_expect(copy.acquire(SKILL_GAMMA, SUPPORT_REACH), "the duplicate refused a new pair")
	_expect(copy.release(SKILL_ALPHA, SUPPORT_REACH), "the duplicate refused a release")
	_expect(_record_snapshot(original) == original_state,
		"changing the duplicate changed the original to %s" % _record_snapshot(original))

	## And ranking the original cannot move the duplicate — one direction alone
	## would miss a copy that shares its internals.
	var copy_state: String = _record_snapshot(copy)
	_expect(original.increase_rank(SKILL_BETA, SUPPORT_HASTE), "the original refused a raise")
	_expect(original.release(SKILL_ALPHA, SUPPORT_SWEEP), "the original refused a release")
	_expect(_record_snapshot(copy) == copy_state,
		"changing the original changed the duplicate to %s" % _record_snapshot(copy))

	## THE RUN BUILD, on the same terms.
	var build: RiftRunBuild = _seeded_build()
	for _index: int in 3:
		_expect(build.rank_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(), "a raise was refused")
	_expect(build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH) == 4,
		"the seeded pair is at rank %d, not 4"
			% build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH))
	var build_state: String = _snapshot(build)
	var build_copy: RiftRunBuild = build.duplicated()
	_expect(_snapshot(build_copy) == build_state,
		"the duplicated run build reads %s, not %s" % [_snapshot(build_copy), build_state])

	_expect(build_copy.rank_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"the duplicated run build refused a raise")
	_expect(build_copy.support_rank_for(SKILL_ALPHA, SUPPORT_REACH) == 5,
		"the duplicated run build is at rank %d, not 5"
			% build_copy.support_rank_for(SKILL_ALPHA, SUPPORT_REACH))
	_expect(_snapshot(build) == build_state,
		"ranking the duplicate moved the original to %s" % _snapshot(build))

	var copy_build_state: String = _snapshot(build_copy)
	_expect(build.rank_support(SKILL_ALPHA, SUPPORT_SWEEP).is_empty(),
		"the original run build refused a raise")
	_expect(_snapshot(build_copy) == copy_build_state,
		"ranking the original moved the duplicate to %s" % _snapshot(build_copy))

	## AND THE COPY THE RUN BUILD HANDS OUT IS A COPY FOR RANKS TOO. A later
	## selector is given this to ask what is still available; that question must
	## not be able to answer itself.
	var exposed: AcquiredSupports = build.acquired_supports()
	var exposed_state: String = _snapshot(build)
	_expect(exposed.increase_rank(SKILL_ALPHA, SUPPORT_REACH),
		"the exposed record refused a raise")
	_expect(exposed.release(SKILL_ALPHA, SUPPORT_SWEEP),
		"the exposed record refused a release")
	_expect(_snapshot(build) == exposed_state,
		"changing the exposed record changed the run build to %s" % _snapshot(build))

	## The array `for_skill()` answers is a copy as well, ranks or no ranks.
	var listed: Array[StringName] = build.supports_for(SKILL_ALPHA)
	listed.append(ABSENT_SUPPORT)
	_expect(build.supports_for(SKILL_ALPHA).size() == 2,
		"mutating a returned list changed the run build to %s" % _snapshot(build))

	print("  ranks 1 / 3 / 5 duplicated exactly; 6 mutations across both directions moved nothing")
	_done("duplicating_preserves_every_rank_and_shares_no_storage")


# --- 11. Release removes the pair and all of its ranks --------------------------

func _check_releasing_a_ranked_pair_removes_the_pair_and_all_of_its_ranks() -> void:
	print("")
	print("--- 11. Releasing a ranked pair removes the pair and every rank it accumulated")

	var record: AcquiredSupports = AcquiredSupports.new()
	_expect(record.acquire(SKILL_ALPHA, SUPPORT_REACH), "acquisition 1 refused")
	_expect(record.acquire(SKILL_ALPHA, SUPPORT_SWEEP), "acquisition 2 refused")
	_expect(record.acquire(SKILL_BETA, SUPPORT_HASTE), "acquisition 3 refused")
	for _index: int in 3:
		_expect(record.increase_rank(SKILL_ALPHA, SUPPORT_REACH), "a raise was refused")
	_expect(record.increase_rank(SKILL_BETA, SUPPORT_HASTE), "a raise was refused")
	_expect(record.rank_for(SKILL_ALPHA, SUPPORT_REACH) == 4
			and record.rank_for(SKILL_ALPHA, SUPPORT_SWEEP) == 1
			and record.rank_for(SKILL_BETA, SUPPORT_HASTE) == 2,
		"the seeded ranks read %s" % _record_snapshot(record))
	_expect(record.size() == 3 and record.total_ranks() == 7,
		"the seeded record reads %s" % _record_snapshot(record))

	_expect(record.release(SKILL_ALPHA, SUPPORT_REACH), "the release was refused")
	_expect(not record.has(SKILL_ALPHA, SUPPORT_REACH), "the released pair is still held")
	_expect(record.rank_for(SKILL_ALPHA, SUPPORT_REACH) == 0,
		"the released pair still reports rank %d"
			% record.rank_for(SKILL_ALPHA, SUPPORT_REACH))
	_expect(record.size() == 2, "the record holds %d pairs after one release" % record.size())
	_expect(record.total_ranks() == 3,
		"releasing a rank-4 pair left %d ranks, not 3" % record.total_ranks())

	## THE OTHER PAIRS ARE UNTOUCHED, EXACTLY.
	_expect(record.rank_for(SKILL_ALPHA, SUPPORT_SWEEP) == 1
			and record.rank_for(SKILL_BETA, SUPPORT_HASTE) == 2,
		"a release moved another pair's rank: %s" % _record_snapshot(record))
	_expect(", ".join(record.pairs()) == "%s -> %s, %s -> %s" % [
			SKILL_ALPHA, SUPPORT_SWEEP, SKILL_BETA, SUPPORT_HASTE,
		],
		"the listing after one release reads %s" % ", ".join(record.pairs()))

	## RE-ACQUIRING BEGINS AT RANK 1 AGAIN, which is the sharpest available proof
	## that the ranks were removed rather than remembered.
	_expect(record.acquire(SKILL_ALPHA, SUPPORT_REACH), "the pair could not be re-acquired")
	_expect(record.rank_for(SKILL_ALPHA, SUPPORT_REACH) == 1,
		"a re-acquired pair came back at rank %d, not 1"
			% record.rank_for(SKILL_ALPHA, SUPPORT_REACH))
	_expect(record.total_ranks() == 4,
		"the record holds %d ranks after re-acquisition, not 4" % record.total_ranks())

	## A SECOND RELEASE OF THE SAME PAIR IS REFUSED AND CHANGES NOTHING.
	_expect(record.release(SKILL_BETA, SUPPORT_HASTE), "the second release was refused")
	var after: String = _record_snapshot(record)
	_expect(not record.release(SKILL_BETA, SUPPORT_HASTE),
		"a pair was released twice")
	_expect(_record_snapshot(record) == after,
		"a refused release changed the record to %s" % _record_snapshot(record))

	## Releasing a Skill's last support removes the Skill entry rather than
	## leaving an empty one behind.
	_expect(record.skill_count() == 1,
		"the record holds %d Skills after releasing the last of one" % record.skill_count())
	_expect(record.for_skill(SKILL_BETA).is_empty(),
		"an emptied Skill still lists %s" % _ids_line(record.for_skill(SKILL_BETA)))

	print("  a rank-4 pair released: 3 pairs / 7 ranks -> 2 pairs / 3 ranks; re-acquired at rank 1")
	_done("releasing_a_ranked_pair_removes_the_pair_and_all_of_its_ranks")


# --- 12. Ranking touches no passive ---------------------------------------------

func _check_ranking_moves_no_passive_total_no_count_and_no_card_identity() -> void:
	print("")
	print("--- 12. Raising a support rank moves no stat total, no card count and no identity")

	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(), "acquisition refused")
	_expect(build.acquire_support(SKILL_BETA, SUPPORT_SWEEP).is_empty(), "acquisition refused")
	for card_id: StringName in PassiveCardCatalogue.ALL:
		_expect(build.acquire_passive_card(PassiveCardCatalogue.record(card_id)).is_empty(),
			"%s was refused while seeding the passive side" % card_id)
	## One card twice, so a count and a repeat identity are both in play.
	_expect(build.acquire_passive_card(
			PassiveCardCatalogue.record(PassiveCardCatalogue.ALL[0])).is_empty(),
		"the repeat acquisition was refused")

	var passives_before: String = _passive_snapshot(build)
	var supports_before: String = _support_line(build)
	_expect(build.passive_acquisitions() == PassiveCardCatalogue.ALL.size() + 1,
		"the seeded run build holds %d passive acquisitions" % build.passive_acquisitions())

	for _index: int in 5:
		_expect(build.rank_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(), "a raise was refused")
	_expect(build.rank_support(SKILL_BETA, SUPPORT_SWEEP).is_empty(), "a raise was refused")

	## THE POSITIVE CONTROL: the support side really did move, so "nothing
	## changed" below is a claim about the passive side rather than about a run
	## in which nothing happened at all.
	_expect(_support_line(build) != supports_before,
		"six raises moved nothing on the support side: %s" % _support_line(build))
	_expect(build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH) == 6
			and build.support_rank_for(SKILL_BETA, SUPPORT_SWEEP) == 2,
		"the two ranks read %d and %d, not 6 and 2" % [
			build.support_rank_for(SKILL_ALPHA, SUPPORT_REACH),
			build.support_rank_for(SKILL_BETA, SUPPORT_SWEEP),
		])

	## EVERY declared stat, every contribution count, every card count and every
	## recorded mechanical identity — enumerated rather than sampled.
	_expect(_passive_snapshot(build) == passives_before,
		"raising a rank changed the passive side from %s to %s" % [
			passives_before, _passive_snapshot(build),
		])
	_expect(build.support_count() == 2,
		"six raises changed the pair count to %d" % build.support_count())
	_expect(build.total_support_ranks() == 8,
		"6 + 2 reported as %d total ranks" % build.total_support_ranks())

	## And the reverse: acquiring a passive card moves no support rank.
	var ranks_before: String = _support_line(build)
	_expect(build.acquire_passive_card(
			PassiveCardCatalogue.record(PassiveCardCatalogue.ALL[1])).is_empty(),
		"a passive acquisition after ranking was refused")
	_expect(_support_line(build) == ranks_before,
		"acquiring a passive card changed the support side to %s" % _support_line(build))

	print("  6 raises: 6 stat totals, %d card counts and every card identity unchanged"
		% build.acquired_card_ids().size())
	_done("ranking_moves_no_passive_total_no_count_and_no_card_identity")


# --- 13. A held pair is unavailable at every rank -------------------------------

func _check_an_acquired_pair_is_unavailable_to_selection_at_every_rank() -> void:
	print("")
	print("--- 13. Foundation B treats a held pair as unavailable whatever its rank")

	var profiles: Array[SkillTagProfile] = []
	profiles.append(_profile(SELECT_SKILL_ONE, [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.STRIKE, SkillTags.PHYSICAL,
	] as Array[StringName]))
	profiles.append(_profile(SELECT_SKILL_TWO, [
		SkillTags.ATTACK, SkillTags.HIT, SkillTags.MELEE, SkillTags.PHYSICAL,
	] as Array[StringName]))
	var definitions: Array[SupportDefinition] = []
	definitions.append(_definition(SELECT_SUPPORT, [SkillTags.MELEE] as Array[StringName], 10))

	## A POSITIVE CONTROL FIRST: both Skills are eligible before anything is held.
	var before: SupportSelectionResult = SupportSelection.select_with_tickets(
		profiles, definitions, null, 0, 0
	)
	_expect(before.ok and before.eligible_skill_count == 2,
		"before acquisition %d Skills were eligible, not 2" % before.eligible_skill_count)

	var acquired: AcquiredSupports = AcquiredSupports.new()
	_expect(acquired.acquire(SELECT_SKILL_ONE, SELECT_SUPPORT), "the acquisition was refused")

	## THE SWEEP IS REPEATED AT EVERY RANK, NOT ONLY AT RANK 1. A record that
	## reported availability from the RANK rather than from the presence of the
	## pair would answer differently as the rank climbed.
	var ranks: Array[int] = [1, 2, 3, 7]
	var reachable_drift: int = 0
	for target_rank: int in ranks:
		while acquired.rank_for(SELECT_SKILL_ONE, SELECT_SUPPORT) < target_rank:
			_expect(acquired.increase_rank(SELECT_SKILL_ONE, SELECT_SUPPORT),
				"a raise toward rank %d was refused" % target_rank)
		_expect(acquired.rank_for(SELECT_SKILL_ONE, SELECT_SUPPORT) == target_rank,
			"the held pair is at rank %d, not %d" % [
				acquired.rank_for(SELECT_SKILL_ONE, SELECT_SUPPORT), target_rank,
			])
		var counts: Dictionary = _sweep_skill_tickets(profiles, definitions, acquired)
		if counts.size() != 1 or int(counts.get(SELECT_SKILL_TWO, -1)) != SWEEP_TICKETS:
			reachable_drift += 1
		_expect(counts.size() == 1 and int(counts.get(SELECT_SKILL_TWO, -1)) == SWEEP_TICKETS,
			"at rank %d the sweep produced %s" % [target_rank, counts])
		var after: SupportSelectionResult = SupportSelection.select_with_tickets(
			profiles, definitions, acquired, 0, 0
		)
		_expect(after.ok and after.skill_id == SELECT_SKILL_TWO,
			"at rank %d the selection produced %s" % [target_rank, after.skill_id])
	_expect(reachable_drift == 0,
		"%d of %d ranks changed which Skills were reachable" % [reachable_drift, ranks.size()])

	## THE EXHAUSTION REASON COUNTS PAIRS, NOT RANKS — which is exactly what
	## would break if `size()` had quietly been changed to answer the rank sum.
	_expect(acquired.size() == 1 and acquired.total_ranks() == 7,
		"the rank-7 record reads %s" % _record_snapshot(acquired))
	_expect(acquired.acquire(SELECT_SKILL_TWO, SELECT_SUPPORT),
		"the second Skill's acquisition was refused")
	var exhausted: SupportSelectionResult = SupportSelection.select_with_tickets(
		profiles, definitions, acquired, 0, 0
	)
	_expect_refusal(exhausted.failure_reason, "an exhausted catalogue")
	_expect(not exhausted.ok, "an exhausted catalogue still returned a selection")
	_expect(exhausted.failure_reason.contains("2 pair(s) already acquired"),
		"the exhaustion reason reads '%s' while the record holds %d pairs and %d ranks" % [
			exhausted.failure_reason, acquired.size(), acquired.total_ranks(),
		])
	_expect(acquired.total_ranks() == 8,
		"the exhausted record holds %d ranks, not 8" % acquired.total_ranks())

	print("  ranks 1 / 2 / 3 / 7: the held pair is unreachable across all %d tickets each time"
		% SWEEP_TICKETS)
	print("  and the exhaustion reason still counts 2 PAIRS while the record holds 8 ranks")
	_done("an_acquired_pair_is_unavailable_to_selection_at_every_rank")


# --- 14. The accepted D2 first-acquisition behaviour ----------------------------

func _check_first_acquisition_behaviour_at_the_run_build_boundary_is_unchanged() -> void:
	print("")
	print("--- 14. Every accepted first-acquisition behaviour is unchanged")

	var build: RiftRunBuild = RiftRunBuild.new()

	## A new pair is accepted with an empty refusal, and adds NOTHING to the
	## passive side — the lane property D-244 measured, restated here because F1
	## touches the file that owns it.
	_expect(build.acquire_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"a first acquisition was refused")
	_expect(build.passive_acquisitions() == 0,
		"acquiring a support recorded %d passive acquisitions" % build.passive_acquisitions())
	var contributed: PackedStringArray = PackedStringArray()
	for stat_id: StringName in PlayerStats.ALL:
		if build.total_for(stat_id) != 0.0 or build.contribution_count_for(stat_id) != 0:
			contributed.append("%s=%s(%d)" % [
				stat_id, _exact(build.total_for(stat_id)),
				build.contribution_count_for(stat_id),
			])
	_expect(contributed.is_empty(),
		"acquiring a support granted stat contributions: %s" % ", ".join(contributed))
	_expect(build.acquired_card_ids().is_empty(),
		"acquiring a support recorded card ids: %s" % _ids_line(build.acquired_card_ids()))

	## The same support for a second Skill is a second pair, not a refusal.
	_expect(build.acquire_support(SKILL_BETA, SUPPORT_REACH).is_empty(),
		"the same support was refused for a second Skill")
	_expect(build.support_count() == 2,
		"one support on two Skills is %d pairs, not 2" % build.support_count())

	## The accepted refusal sentences, word for word where D-241 shipped them.
	var duplicate: String = build.acquire_support(SKILL_ALPHA, SUPPORT_REACH)
	_expect_refusal(duplicate, "a duplicate acquisition")
	_expect(duplicate == "%s: %s is already acquired for that Skill" % [
			SKILL_ALPHA, SUPPORT_REACH,
		],
		"the duplicate refusal reads '%s'" % duplicate)
	var blank_skill: String = build.acquire_support(&"", SUPPORT_REACH)
	_expect_refusal(blank_skill, "a blank Skill id in an acquisition")
	_expect(blank_skill == "a support acquisition must name the Skill it is attached to",
		"the blank-Skill refusal reads '%s'" % blank_skill)
	var blank_support: String = build.acquire_support(SKILL_ALPHA, &"")
	_expect_refusal(blank_support, "a blank support id in an acquisition")
	_expect(blank_support == "%s: a support acquisition must name the support it records"
			% SKILL_ALPHA,
		"the blank-support refusal reads '%s'" % blank_support)

	## The accepted readings.
	_expect(build.has_support(SKILL_ALPHA, SUPPORT_REACH), "a held pair reports as unheld")
	_expect(_ids_line(build.supports_for(SKILL_ALPHA)) == String(SUPPORT_REACH),
		"the Skill lists %s" % _ids_line(build.supports_for(SKILL_ALPHA)))
	_expect(", ".join(build.support_pairs()) == "%s -> %s, %s -> %s" % [
			SKILL_ALPHA, SUPPORT_REACH, SKILL_BETA, SUPPORT_REACH,
		],
		"the pair listing reads %s" % ", ".join(build.support_pairs()))
	_expect(build.describe().begins_with("%s -> %s; %s -> %s" % [
			SKILL_ALPHA, SUPPORT_REACH, SKILL_BETA, SUPPORT_REACH,
		]),
		"the run build describes itself as '%s'" % build.describe())
	_expect(not build.is_empty(), "a run build holding two pairs reports itself empty")

	## And an empty state's own accepted description, which F1 must not have
	## changed by adding a rank to anything.
	var fresh: RiftRunBuild = RiftRunBuild.new()
	_expect(fresh.describe().begins_with("no supports acquired"),
		"an empty run build describes itself as '%s'" % fresh.describe())

	print("  the accepted acquisition, refusal and listing behaviour is unchanged at 2 pairs")
	_done("first_acquisition_behaviour_at_the_run_build_boundary_is_unchanged")


# --- 15. The ceiling is representational ----------------------------------------

func _check_the_rank_ceiling_is_the_representational_boundary_and_is_unreachable() -> void:
	print("")
	print("--- 15. The rank ceiling is the machine's boundary, not a balance value")

	## THE BOUNDARY IS MEASURED FROM THE ENGINE, NOT ASSUMED. "No larger positive
	## integer rank is representable" is exactly the statement that adding one to
	## the ceiling does not produce a larger positive integer.
	_expect(AcquiredSupports.MAXIMUM_RECORDABLE_RANK > 0,
		"the ceiling is %d, which is not a positive rank at all"
			% AcquiredSupports.MAXIMUM_RECORDABLE_RANK)
	var beyond: int = AcquiredSupports.MAXIMUM_RECORDABLE_RANK + 1
	_expect(beyond <= 0,
		"a rank above the ceiling is representable as %d, so the ceiling is arbitrary" % beyond)
	_expect(beyond < AcquiredSupports.MAXIMUM_RECORDABLE_RANK,
		"adding one to the ceiling produced the larger value %d" % beyond)

	## AND IT IS NOT A GAMEPLAY NUMBER IN DISGUISE. A balance cap would be small
	## enough to reach; this one is not reachable by any run that could exist.
	_expect(AcquiredSupports.MAXIMUM_RECORDABLE_RANK > IMPLAUSIBLE_GAMEPLAY_RANK,
		"the ceiling %d is small enough to be a balance value"
			% AcquiredSupports.MAXIMUM_RECORDABLE_RANK)

	## THE REACHABLE HALF: ordinary ranking is +1 every time over a long run and
	## goes nowhere near the boundary.
	var record: AcquiredSupports = AcquiredSupports.new()
	_expect(record.acquire(SKILL_ALPHA, SUPPORT_REACH), "the acquisition was refused")
	var refused_raises: int = 0
	var wrong_step: int = 0
	for index: int in LONG_RUN_RAISES:
		var expected: int = index + 2
		if not record.increase_rank(SKILL_ALPHA, SUPPORT_REACH):
			refused_raises += 1
		if record.rank_for(SKILL_ALPHA, SUPPORT_REACH) != expected:
			wrong_step += 1
	_expect(refused_raises == 0,
		"%d of %d ordinary raises were refused" % [refused_raises, LONG_RUN_RAISES])
	_expect(wrong_step == 0,
		"%d of %d raises did not step by exactly one" % [wrong_step, LONG_RUN_RAISES])
	_expect(record.rank_for(SKILL_ALPHA, SUPPORT_REACH) == LONG_RUN_RAISES + 1,
		"%d raises produced rank %d" % [
			LONG_RUN_RAISES, record.rank_for(SKILL_ALPHA, SUPPORT_REACH),
		])
	_expect(record.size() == 1 and record.total_ranks() == LONG_RUN_RAISES + 1,
		"a long run of raises reads %s" % _record_snapshot(record))

	## THE REFUSAL BRANCH IS PINNED STRUCTURALLY, AND THE LIMITATION IS STATED
	## RATHER THAN GLOSSED. The ceiling sits at the largest integer the machine
	## can hold, so it cannot be reached by calling this record — the only way to
	## drive the branch would be a production seam that let a test write a rank
	## directly, and the brief forbids manufacturing one. So the guard is pinned
	## by its expression, and the SHAPE of the guard is pinned too: it must refuse
	## BEFORE adding, because noticing a wraparound afterwards is not a guard.
	var source: String = FileAccess.get_file_as_string(RECORD_FILE)
	var code: String = _code_only(source)
	_expect(code.contains("if current >= MAXIMUM_RECORDABLE_RANK:"),
		"the record does not compare against the recordable ceiling before adding")
	var guard_at: int = code.find("if current >= MAXIMUM_RECORDABLE_RANK:")
	var add_at: int = code.find("held[support_id] = current + 1")
	_expect(add_at > 0 and guard_at > 0 and guard_at < add_at,
		"the ceiling is checked at %d and the increment written at %d" % [guard_at, add_at])
	_expect(not code.contains("< 0") and not code.contains("< FIRST_RANK"),
		"the record detects an overflow after the fact instead of refusing before it")

	print("  the ceiling is %d; +1 wraps to %d, so no larger positive rank exists"
		% [AcquiredSupports.MAXIMUM_RECORDABLE_RANK, beyond])
	print("  %d ordinary raises each stepped by exactly 1; the refusal branch is pinned"
		% LONG_RUN_RAISES)
	print("  STATED LIMITATION: the ceiling refusal is NOT driven behaviourally, because")
	print("  reaching it would require a production seam this foundation refuses to add")
	_done("the_rank_ceiling_is_the_representational_boundary_and_is_unreachable")


# --- 16. Generic, ambient-free, unwired -----------------------------------------

func _check_the_two_records_are_generic_read_nothing_ambient_and_are_unwired() -> void:
	print("")
	print("--- 16. Both extended records name nothing concrete and nothing calls F1")

	var named: PackedStringArray = PackedStringArray()
	var ambient: PackedStringArray = PackedStringArray()
	var deferred: PackedStringArray = PackedStringArray()
	for path: String in F1_FILES:
		var raw: String = FileAccess.get_file_as_string(path)
		_expect(raw.length() > 2000,
			"%s read as %d characters, so these scans prove nothing" % [
				path.get_file(), raw.length(),
			])
		var code: String = _code_only(raw)
		_expect(code.length() > 500 and code.length() < raw.length(),
			"comment stripping produced %d characters from %d for %s" % [
				code.length(), raw.length(), path.get_file(),
			])
		for token: String in FORBIDDEN_TOKENS:
			if raw.contains(token):
				named.append("%s names %s" % [path.get_file(), token])
		for token: String in AMBIENT_TOKENS:
			if raw.contains(token):
				ambient.append("%s reads %s" % [path.get_file(), token])
		for token: String in DEFERRED_MEMBER_TOKENS:
			if code.contains(token):
				deferred.append("%s carries %s" % [path.get_file(), token])
	_expect(named.is_empty(), "a record names something concrete: %s" % ", ".join(named))
	_expect(ambient.is_empty(), "a record reads ambient state: %s" % ", ".join(ambient))
	_expect(deferred.is_empty(), "a record carries a deferred member: %s" % ", ".join(deferred))

	## THE SCAN IS PROVED CAPABLE OF FAILING, by finding its own tokens where they
	## legitimately live. A scan that has never found anything is indistinguishable
	## from a scan that cannot.
	var own_source: String = FileAccess.get_file_as_string(get_script().resource_path)
	var found_here: int = 0
	for token: String in FORBIDDEN_TOKENS:
		if own_source.contains(token):
			found_here += 1
	_expect(found_here > 20,
		"the forbidden-token scan found only %d of its own tokens in this file" % found_here)

	## THE METHOD AND FIELD PINS, for BOTH classes.
	_expect(", ".join(_methods_of(RECORD_FILE)) == ", ".join(EXPECTED_RECORD_METHODS),
		"the acquisition record declares: %s" % ", ".join(_methods_of(RECORD_FILE)))
	_expect(", ".join(_methods_of(RUN_BUILD_FILE)) == ", ".join(EXPECTED_BUILD_METHODS),
		"the run-build state declares: %s" % ", ".join(_methods_of(RUN_BUILD_FILE)))

	var record_fields: PackedStringArray = _fields_of(AcquiredSupports.new())
	_expect(", ".join(record_fields) == ", ".join(EXPECTED_RECORD_FIELDS),
		"the acquisition record carries the fields: %s" % ", ".join(record_fields))
	var build_fields: PackedStringArray = _fields_of(RiftRunBuild.new())
	_expect(", ".join(build_fields) == ", ".join(EXPECTED_BUILD_FIELDS),
		"the run-build state carries the fields: %s" % ", ".join(build_fields))

	## THE ONE PROPERTY THIS SUITE PINS STRUCTURALLY RATHER THAN BEHAVIOURALLY,
	## AND THE REASON IS MEASURED RATHER THAN GLOSSED. `rank_support()` stages the
	## acquisition record and commits the copy only after the delegated raise has
	## succeeded — and the accepted record is ALREADY fail-closed, refusing before
	## it writes in both of its branches, so replacing the staged copy with the
	## live record changes NO observable answer. That mutation was driven and this
	## suite stayed green at every assertion, which is the honest account of it:
	## the staging is defence in depth, exactly as D-241 recorded for the staging
	## beside it, and it is caught here and nowhere else. A structural pin that
	## says what it is beats a behavioural test that cannot exist.
	var build_source: String = _code_only(FileAccess.get_file_as_string(RUN_BUILD_FILE))
	_expect(build_source.count("var staged: AcquiredSupports = _supports.duplicated()") == 2,
		"the run-build state stages an acquisition record %d times, not twice"
			% build_source.count("var staged: AcquiredSupports = _supports.duplicated()"))
	_expect(build_source.contains("if not staged.increase_rank(skill_id, support_id):"),
		"the rank increase is not made against the staged copy")
	_expect(not build_source.contains("_supports.increase_rank"),
		"the rank increase is made against the live acquisition record")

	var exposed: PackedStringArray = PackedStringArray()
	for field: String in record_fields:
		if not field.begins_with("_"):
			exposed.append("record.%s" % field)
	for field: String in build_fields:
		if not field.begins_with("_"):
			exposed.append("build.%s" % field)
	_expect(exposed.is_empty(), "F1 exposes the field(s) %s directly" % ", ".join(exposed))

	## THE NESTED MAP NEVER LEAVES. No public method answers a Dictionary, which
	## is asked of the ENGINE's return types rather than read off the source.
	var dictionary_returns: PackedStringArray = PackedStringArray()
	for path: String in F1_FILES:
		var script: GDScript = load(path) as GDScript
		for entry: Dictionary in script.get_script_method_list():
			var method_name: String = String(entry.get("name", ""))
			if method_name.begins_with("_"):
				continue
			var returns: Dictionary = entry.get("return", {}) as Dictionary
			if int(returns.get("type", TYPE_NIL)) == TYPE_DICTIONARY:
				dictionary_returns.append("%s.%s" % [path.get_file(), method_name])
	_expect(dictionary_returns.is_empty(),
		"a public method hands out a live map: %s" % ", ".join(dictionary_returns))

	## NOTHING CALLS F1 EXCEPT AN AUTHORIZED CALLER. Rank effects, rank refunds and
	## every run-state rank operation are still later decisions, so every one of
	## the six new members must be reachable from no running code at all but the
	## exact members the allowlist above grants.
	var project_files: int = 0
	var callers: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if F1_FILES.has(path):
				continue
			project_files += 1
			var source: String = FileAccess.get_file_as_string(path)
			for member: String in F1_MEMBERS:
				if not source.contains(member):
					continue
				if _is_authorized_caller(path, member):
					continue
				callers.append("%s calls %s" % [path.get_file(), member])
	_expect(callers.is_empty(), "Foundation F1 is called by code that runs: %s" % ", ".join(callers))
	_expect(project_files > 100,
		"only %d project files were scanned, so the scan proves nothing" % project_files)

	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	_expect(not settings.contains("[autoload]"), "project.godot declares an [autoload] section")
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

	print("  0 forbidden tokens, 0 ambient reads, 0 deferred members across 2 files")
	print("  the rank increase is staged; that staging is DEFENCE IN DEPTH and is pinned")
	print("  structurally, because the accepted record is already fail-closed and no")
	print("  behavioural test can distinguish the alternative")
	print("  %d + %d methods and %d + %d fields pinned, every field private, 0 live maps returned"
		% [
			EXPECTED_RECORD_METHODS.size(), EXPECTED_BUILD_METHODS.size(),
			EXPECTED_RECORD_FIELDS.size(), EXPECTED_BUILD_FIELDS.size(),
		])
	print("  %d project files scanned, only the authorized composer calls any of the 6 new "
		% project_files + "members; 31 actions")
	print("  %d refusals were driven across this suite" % _refusals)
	_done("the_two_records_are_generic_read_nothing_ambient_and_are_unwired")


# --- Fixtures and helpers ------------------------------------------------------

## Whether `path` is granted `member` by the allowlist above. An exact per-file,
## per-member test: a file not listed is granted nothing, and a listed file is
## granted only the members written beside it.
func _is_authorized_caller(path: String, member: String) -> bool:
	for row: Array in AUTHORIZED_CALLERS:
		if String(row[0]) != path:
			continue
		for granted: String in row[1]:
			if granted == member:
				return true
		return false
	return false


## A record holding two pairs on one Skill, so an atomicity claim is made against
## something rather than against nothing.
func _seeded_record() -> AcquiredSupports:
	var record: AcquiredSupports = AcquiredSupports.new()
	_expect(record.acquire(SKILL_ALPHA, SUPPORT_REACH), "the seeded record refused a pair")
	_expect(record.acquire(SKILL_ALPHA, SUPPORT_SWEEP), "the seeded record refused a pair")
	_expect(record.increase_rank(SKILL_ALPHA, SUPPORT_SWEEP), "the seeded record refused a raise")
	return record


## A run build holding two pairs, one card and one raised rank.
func _seeded_build() -> RiftRunBuild:
	var build: RiftRunBuild = RiftRunBuild.new()
	_expect(build.acquire_support(SKILL_ALPHA, SUPPORT_REACH).is_empty(),
		"the seeded run build refused a pair")
	_expect(build.acquire_support(SKILL_ALPHA, SUPPORT_SWEEP).is_empty(),
		"the seeded run build refused a pair")
	_expect(build.acquire_passive_card(
			PassiveCardCatalogue.record(PassiveCardCatalogue.ALL[0])).is_empty(),
		"the seeded run build refused its card")
	return build


func _profile(id: StringName, tags: Array[StringName]) -> SkillTagProfile:
	return SkillTagProfile.of(id, "Test Skill %s" % id, tags)


## THE MAXIMUM RANK THE FABRICATED DEFINITION DECLARES (Foundation I5, D-301). A
## usable maximum is part of a definition's validity, and a pair held ABOVE its
## maximum is an invalid acquisition state every selection refuses — so check 13's
## sweep, which holds the pair at ranks up to 7, needs a maximum above every rank it
## holds. Test data, not balance.
const FIXTURE_MAXIMUM_RANK: int = 1000


func _definition(
	id: StringName, required_all: Array[StringName], weight: int
) -> SupportDefinition:
	return SupportDefinition.of(
		SupportEligibility.of(id, "Test Support %s" % id, required_all,
			[] as Array[StringName], [] as Array[StringName]),
		weight, {}, FIXTURE_MAXIMUM_RANK
	)


## Every first-stage ticket, counted by the Skill it produced. Refusals are
## counted under their own key so an exhausted pool cannot look like a clean
## sweep.
func _sweep_skill_tickets(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	acquired: AcquiredSupports
) -> Dictionary:
	var counts: Dictionary = {}
	for ticket: int in SWEEP_TICKETS:
		var result: SupportSelectionResult = SupportSelection.select_with_tickets(
			profiles, definitions, acquired, ticket, 0
		)
		if not result.ok:
			counts[&"<refused>"] = int(counts.get(&"<refused>", 0)) + 1
			continue
		counts[result.skill_id] = int(counts.get(result.skill_id, 0)) + 1
	return counts


## The COMPLETE acquisition record as one line, RANKS INCLUDED.
func _record_snapshot(record: AcquiredSupports) -> String:
	var parts: PackedStringArray = PackedStringArray()
	parts.append("pairs[%s]" % ", ".join(record.pairs()))
	parts.append("ranked[%s]" % _ranked_line(record))
	parts.append("size=%d" % record.size())
	parts.append("ranks=%d" % record.total_ranks())
	parts.append("skills=%d" % record.skill_count())
	parts.append("empty=%s" % record.is_empty())
	return " | ".join(parts)


## Every pair and its rank, read back through the public readings in the record's
## own stable order.
func _ranked_line(record: AcquiredSupports) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for line: String in record.pairs():
		var halves: PackedStringArray = line.split(" -> ")
		if halves.size() != 2:
			parts.append("UNREADABLE(%s)" % line)
			continue
		parts.append("%s@%d" % [
			line, record.rank_for(StringName(halves[0]), StringName(halves[1])),
		])
	return ", ".join(parts)


## The support half of a run build, ranks included.
func _support_line(build: RiftRunBuild) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for line: String in build.support_pairs():
		var halves: PackedStringArray = line.split(" -> ")
		if halves.size() != 2:
			parts.append("UNREADABLE(%s)" % line)
			continue
		parts.append("%s@%d" % [
			line, build.support_rank_for(StringName(halves[0]), StringName(halves[1])),
		])
	return "pairs=%d ranks=%d [%s]" % [
		build.support_count(), build.total_support_ranks(), ", ".join(parts),
	]


## The passive half of a run build: every card count, every recorded mechanical
## identity, and every declared stat's total and contribution count.
func _passive_snapshot(build: RiftRunBuild) -> String:
	var parts: PackedStringArray = PackedStringArray()
	var cards: PackedStringArray = PackedStringArray()
	for card_id: StringName in build.acquired_card_ids():
		cards.append("%s x%d {%s}" % [
			card_id, build.acquisitions_for(card_id), build.mechanical_identity_for(card_id),
		])
	parts.append("cards[%s]" % ", ".join(cards))
	parts.append("acquisitions=%d" % build.passive_acquisitions())
	for stat_id: StringName in PlayerStats.ALL:
		parts.append("%s=%s(%d)" % [
			stat_id, _exact(build.total_for(stat_id)), build.contribution_count_for(stat_id),
		])
	return " | ".join(parts)


## The COMPLETE run build as one line: the support half with its ranks, and the
## passive half. Every atomicity claim in this suite is a comparison of two of
## these.
func _snapshot(build: RiftRunBuild) -> String:
	return "%s | %s | empty=%s" % [_support_line(build), _passive_snapshot(build), build.is_empty()]


## Seventeen decimal places, which is more than the seventeen significant digits
## it takes to separate any two distinct doubles this foundation can carry.
func _exact(value: float) -> String:
	return String.num(value, 17)


func _ids_line(values: Array[StringName]) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for value: StringName in values:
		parts.append(String(value))
	return ", ".join(parts)


## Every line that is not a whole-line comment. See `DEFERRED_MEMBER_TOKENS` for
## why exactly this treatment exists.
func _code_only(source: String) -> String:
	var out: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


func _methods_of(path: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var script: GDScript = load(path) as GDScript
	if script == null:
		return out
	for entry: Dictionary in script.get_script_method_list():
		out.append(String(entry.get("name", "")))
	return out


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
