extends SceneTree
## Riftwrought — Roguelite Foundation E2 verification: the single Rift level-up
## coordinator.
##
## ONE FOCUSED HEADLESS TEST. The foundation is two pure-logic scripts under
## `scripts/levels/`, so it needs no scene, no camera, no navigation, no
## rendering and no evidence frame, and it deliberately gets none. It runs as a
## `SceneTree` script exactly as all nine earlier foundations' suites do.
##
## IT PORTS D-211's OWED-SET DISCIPLINE. Every check function records reaching
## its LAST line, and the suite compares that set against what it owes in BOTH
## directions, so a check that dies half way cannot leave a green run behind it.
##
## EVERY ATOMICITY PROOF COMPARES THE WHOLE LIFECYCLE. A complete snapshot — the
## level, the experience to seventeen significant digits, the completed flag,
## whether an offer stands, its root seed, the frozen requirement, every lane
## identity, the whole run build and the whole ledger — is taken immediately
## before each attempt and compared afterwards. Checking only the field the
## operation was about is how a partial mutation survives a green suite.
##
## AND THE COORDINATOR IS SEEDED BEFORE EVERY ATOMICITY PROOF, ON PURPOSE.
## "Nothing changed" is nearly free to satisfy on a lifecycle that has never been
## touched; it is a real claim only when there is something there to disturb.
##
## IT DELIBERATELY DOES NOT RE-TEST THE FOUNDATIONS IT COMPOSES. Each of the
## five owns its own suite and its own pinned count. What is tested here is the
## ORDER — which operation is legal when, what is frozen while an offer stands,
## and whether a refusal anywhere in the sequence can leave a partial lifecycle
## behind. Where an accepted refusal is quoted, it is quoted to prove it was
## quoted verbatim rather than restated, not to prove the refusal is correct.
##
## TWO PROPERTIES THE BRIEF ASKS FOR ARE MEASURED AS UNREACHABLE RATHER THAN
## DRESSED UP AS PROOFS, AND BOTH ARE RECORDED IN THE DELIVERY. A stale support
## pair cannot reach the choice transaction through this coordinator, because the
## composition is asked against this run's OWN acquisition snapshot — so the
## offered pair is never one the run holds, which check 15 measures over a corpus
## rather than argues. And an advance cannot refuse after a successful staged
## choice, because the requirement was validated and found reached when the offer
## opened and no award can have moved the progress since. D-247's accepted rule
## applies to both: a guard whose failure cannot be observed is reported as
## unobservable, never given a manufactured assertion.

# --- The two scripts this foundation owns ---------------------------------------

const COORDINATOR_FILE: String = "res://scripts/levels/rift_level_up_coordinator.gd"
const RESULT_FILE: String = "res://scripts/levels/rift_level_up_result.gd"

const E2_FILES: Array[String] = [
	"res://scripts/levels/rift_level_up_coordinator.gd",
	"res://scripts/levels/rift_level_up_result.gd",
]

## The two global class names this foundation introduces. NOTHING that runs may
## reference either of them except an authorized reader below: E2 coordinates one
## level-up and is deliberately unwired — no experience source, no level curve,
## no offer presentation, no scene, no persistence.
const E2_CLASSES: Array[String] = [
	"RiftLevelUpCoordinator", "RiftLevelUpResult",
]

## THE FILES AUTHORIZED TO NAME AN E2 CLASS, AND THE EXACT CLASSES EACH MAY NAME
## (Foundation G4, decision D-269). The repeated run-level coordinator OWNS one
## current one-level lifecycle, forwards every award, open and choice to it,
## replaces it with its own continuation after each success, and reads the
## one-level receipt each choice returns — so it names both classes. The run-level
## record carries a copy of that receipt and names the receipt and NOT the
## coordinator, which is what keeps it a value rather than a view of a lifecycle.
## Neither is itself called by anything that runs.
##
## THIS REPLACES THE BLANKET "no file that runs may name either class" ONE FOR
## ONE, exactly as D-248 did for D3 and E1: the same single assertion is made
## either way, it still fails for any other file AND for any class a listed file
## is not granted, and the pinned count does not move.
const AUTHORIZED_READERS: Array = [
	["res://scripts/levels/rift_run_level_coordinator.gd", [
		"RiftLevelUpCoordinator", "RiftLevelUpResult",
	]],
	["res://scripts/levels/rift_run_level_up_result.gd", ["RiftLevelUpResult"]],
	## Roguelite I2 (decision D-293): the Playable Three-Lane Level-Up Choice Review — an
	## isolated scene launched by name — reads the one-level receipt a successful choice's
	## run-level record carries, to present which lane was taken, what it granted and
	## the progression it consumed. It names the receipt and NOT the coordinator. Added
	## one for one: the same single assertion is made, and the pinned count does not move.
	["res://scripts/roguelite/level_up/roguelite_level_up_choice_review.gd", ["RiftLevelUpResult"]],
]

## The two Foundation G4 scripts that share `scripts/levels/` with E2's two.
const RUN_LEVEL_FILES: Array[String] = [
	"res://scripts/levels/rift_run_level_coordinator.gd",
	"res://scripts/levels/rift_run_level_up_result.gd",
]

## Concrete Skill, support, card, catalogue, character-class and instrument
## names, the presentation and weight fields a record carries, and the four
## constants the unrelated first-MVP character curve is written in. Scanned RAW,
## comments included — D-215's lesson: an illustrative name in a comment breaches
## the rule just as surely as a real one, because the rule exists so a reader can
## trust the file holds no content knowledge at all.
##
## THE CURVE CONSTANTS ARE IN THIS LIST FOR THE SAME REASON THEY ARE IN E1's.
## "E2 owns no level curve" is the easiest promise here to break by accident,
## because the project already has one and copying a number from it in as a
## default would look like helpfulness rather than like a balance decision.
const FORBIDDEN_TOKENS: Array[String] = [
	"card_power", "card_celerity", "card_vitality",
	"card_fleetness", "card_insight", "card_magnetism",
	"Celerity", "Vitality", "Fleetness", "Insight", "Magnetism",
	"display_name", "base_weight",
	"QuickStrike", "quick_strike", "Quick Strike",
	"reaching_edge", "Reaching Edge", "sweeping_edge", "Sweeping Edge",
	"Faultbreaker", "Splinter Shot", "Emberbolt", "Marrowshot", "Graveblade",
	"Expedition Blade", "Quickened Edge", "Quickened Form",
	"First Fracture", "first_fracture", "Riftmarked",
	"PrototypePlayer", "PrototypeWeaponData", "PrototypeGraveblade",
	"PassiveEffects", "PassiveGraph", "PassiveNodeData", "PassiveAllocation",
	"RogueliteUpgrade", "RogueliteRunBoon", "RogueliteBuildState", "RogueliteRunPlan",
	"RogueliteRoomModule", "RogueliteRoomLibrary",
	"SkillSupportCatalogue", "SkillTags", "SupportEligibility",
	"SupportSelection", "SupportSelectionResult", "AcquiredSupports",
	"PassiveCardCatalogue", "PassiveCardSelection", "PassiveCardSelectionResult",
	"PlayerStats", "PlayerStatDefinition", "PlayerStatValue", "PlayerStatTotals",
	"FirstMvpSkill", "CharacterState", "ExperienceTable", "PlayerLoadout",
	"TOTAL_FOR_LEVEL", "MAX_DEFINED_LEVEL", "POINTS_PER_LEVEL", "GRAVEBLADE_EXPERIENCE",
]

## A pure coordinator may read no ambient state whatsoever.
const AMBIENT_TOKENS: Array[String] = [
	"randi", "randf", "randomize", "RandomNumberGenerator", "rand_from_seed",
	"Time.", "OS.", "Engine.", "ProjectSettings", "InputMap",
	"FileAccess", "ConfigFile", "ResourceSaver", "ResourceLoader", "user://",
]

## THE SYSTEMS THIS FOUNDATION DEFERS, AS MEMBER-NAME TOKENS.
##
## SCANNED OVER CODE LINES ONLY, AND THE REASON IS A DEFECT GATE 1C ALREADY
## FOUND: a guard whose token is too crude fires on the sentence that makes the
## claim. Both files say in plain English that they hold no curve, spawn no
## pickup, apply nothing to anything that lives and have no reset or persistence
## — so a raw scan for those words would be red on exactly the files that promise
## none of them. The concrete-name scan above stays RAW, where the opposite rule
## applies.
##
## `experience`, `level`, `offer`, `lane`, `seed`, `choice`, `requirement`,
## `award`, `complete`, `build`, `ledger` and `consume` are absent from this list
## on purpose: they are this foundation's own vocabulary rather than a deferred
## system's, which is why D1's, D3's and E1's lists could not simply be copied
## across.
const DEFERRED_MEMBER_TOKENS: Array[String] = [
	"mote", "pickup", "spawn", "collect", "radius",
	"curve", "table", "threshold_for", "requirement_for", "cost_for",
	"stack", "second_offer", "next_offer", "exhaust", "fallback", "eligib",
	"save", "persist", "storage", "schema", "migrat",
	"reset", "reuse", "clear", "death", "nexus", "abandon",
	"apply", "actor", "base_value", "current_life",
	"input", "controller", "viewport", "canvas", "pause", "node",
	"xp", "skip", "ban", "lock", "luck", "rank", "rarity", "pity", "affix", "reroll",
]

## THE SHORT TOKENS ABOVE ARE MATCHED AS IDENTIFIER WORDS RATHER THAN AS BARE
## SUBSTRINGS, PORTED FROM D-244 AND E1 WITH THE REASON INTACT. `xp` as a
## substring is contained in `expose` AND in `experience`, and both files use
## both words in code; `node` is contained in nothing this project writes but is
## word-matched for the same class of reason. A letter or a digit on either side
## is a boundary; an UNDERSCORE is not, so `award_xp`, `experience_mote`,
## `support_rank`, `skip_offer` and `lock_offer` are all still caught while
## `expose`, `experience`, `remote` and `block` are not. The matcher is proved in
## both directions in the last check.
const WORD_MATCHED_TOKENS: Array[String] = [
	"xp", "mote", "skip", "ban", "lock", "luck", "rank", "table", "clear", "node",
]

## ONE DEFERRED TOKEN STOPPED BEING DEFERRED FOR ONE FILE, AND FOR NO OTHER
## (Foundation F5, decision D-260). The receipt now carries the Support
## progression its choice consumed — `support_rank_before` and
## `support_rank_after` — so the result type must name `rank`, which the word
## matcher above catches through the underscore. The COORDINATOR is still held
## to the whole list: it hands the successful choice result to the receipt's
## constructor and reads no rank of its own, and keeping `rank` forbidden to it
## is the structural half of "copied, never re-derived".
##
## THIS MOVES NO COUNT, AND THE PERMISSION IS EARNED. The per-file deferred
## assertion is still exactly one per file; for a file granted a token it now
## ALSO fails if that file no longer names the token, so the permission cannot
## quietly become a claim about nothing while still passing — the same rule the
## class allowlist below applies to its grants.
##
## A SECOND TOKEN STOPPED BEING DEFERRED FOR THE SAME ONE FILE, AND FOR NO OTHER
## (Roguelite Foundation I9, decision D-310). The receipt now records which kind of
## content a Support choice consumed and, for a consumed passive fallback, its
## category — `support_fallback_category`, `carries_support_fallback()` and the offer
## contract's `PASSIVE_FALLBACK` — so it must name `fallback`. The exhausted-support
## fallback is no longer a deferred system: I6 selects it, I7 offers it and I8
## consumes it, and the receipt only records what was consumed. The coordinator is
## still held to the whole list, the grant is earned inside the same single
## assertion exactly as `rank`'s is, and no count moves.
##
## AND THAT SECOND TOKEN STOPPED BEING DEFERRED FOR THE COORDINATOR, AND FOR NO OTHER
## TOKEN (Roguelite I10, decision D-312). Its two new readings answer the STANDING
## offer's stored Support content kind and, for a passive fallback, the category the
## offer's fallback result drew from — so the coordinator must name `fallback`. It is
## still held to every other token, `rank` included, the grant is earned inside the
## same single assertion, and no count moves.
const PERMITTED_DEFERRED_TOKENS: Array = [
	["res://scripts/levels/rift_level_up_result.gd", ["rank", "fallback"]],
	["res://scripts/levels/rift_level_up_coordinator.gd", ["fallback"]],
]

## A PERMIT MAY BE SCOPED TO NAMED FUNCTIONS, AND THE COORDINATOR'S IS (Roguelite I10,
## decision D-313 ruling 6). Its `fallback` holds only inside its two read-only readings of
## the standing offer; anywhere else in its code the token is as deferred as it ever was,
## so the coordinator can neither select, reconstruct nor apply fallback content, nor branch
## any gameplay behaviour on it. Checked inside the same single assertion; no count moves.
const PERMITTED_DEFERRED_SCOPES: Array = [
	["res://scripts/levels/rift_level_up_coordinator.gd", "fallback",
		["offer_support_content_kind", "offer_support_fallback_category"]],
]

## The arithmetic this coordinator must be unable to do. Every percentage is
## added by the accepted accumulator, every threshold subtraction is the accepted
## track's, and the only count anywhere below it is an integer the accepted run
## build keeps — so this source multiplies nothing, divides nothing, adds nothing
## and carries no floating-point literal but zero.
const FORBIDDEN_OPERATORS: Array[String] = ["*", "/", "+"]

## The only floating-point literal either file may carry.
const PERMITTED_FLOAT_LITERAL: String = "0.0"

## The only project classes each E2 file may name. An ALLOWLIST derived from the
## engine's own global class list, PER FILE — not a denylist of remembered
## names, and not one shared list, because a shared list would hand the
## composition mechanism to the result type as a side effect of granting it to
## the coordinator.
##
## THE RESULT TYPE IS GRANTED SIX THINGS AND THE COORDINATOR THIRTEEN — four
## until Foundation F5, see below — AND THE
## GAP IS THE POINT OF SPLITTING THEM. A report of what one choice granted needs
## the lane vocabulary and the one place a lane's identity shape is written; it
## needs no track, no build, no ledger and no composer, and the day it names one
## of those it has started deciding something. It also names the COORDINATOR not
## at all, which is what keeps it a value rather than a view of one.
##
## ONE SUBSTRING IS RECORDED RATHER THAN LEFT TO BE FOUND, exactly as D1's and
## D3's suites record theirs. `RiftOfferChoice` is contained in
## `RiftOfferChoiceResult`, so a file that names only the result is reported as
## naming the transaction too; both files here genuinely name both, and the
## coordinator's use of each is asserted separately below.
##
## THE RESULT TYPE GAINED ONE CLASS UNDER FOUNDATION F5 (decision D-260), AND IT
## IS THE NARROW ONE THE CHOICE RESULT ALREADY HOLDS. The receipt now carries the
## Support progression its choice consumed and renders it through the accepted
## continuation record's own `kind_label()`, so a decision, an offer, a choice and
## its level-up cannot name one operation four different ways — the dependency
## D-258 ruling 3 kept for the choice result. `SupportContinuation`, the SELECTOR,
## rides in only as a substring of the record's name, exactly as it does in the
## Foundation F2 suite's own reader grant; the receipt CALLS nothing of either,
## which the Foundation F5 suite asserts by name. The coordinator gained nothing:
## it hands the whole successful choice result to the receipt's constructor and
## names no progression vocabulary at all.
const AUTHORIZED_CLASSES: Array = [
	["res://scripts/levels/rift_level_up_coordinator.gd", [
		"RiftLevelUpCoordinator", "RiftLevelUpResult",
		"RiftExperienceTrack", "RiftExperienceReading",
		"RiftRunBuild", "RiftConsumptionLedger",
		"RiftOffer", "RiftOfferComposition",
		"RiftOfferChoice", "RiftOfferChoiceResult",
		"SkillTagProfile", "SupportDefinition", "PassiveCardDefinition",
	]],
	["res://scripts/levels/rift_level_up_result.gd", [
		"RiftLevelUpResult", "RiftOffer", "RiftOfferChoice", "RiftOfferChoiceResult",
		"SupportContinuationResult", "SupportContinuation",
	]],
]

## `res://addons` IS SCANNED TOO. An editor plugin is code that runs; a reference
## from one would load these classes while a scripts/scenes/data scan reported
## nothing. `project.godot` is checked separately, because an `[autoload]` entry
## names a class from a file no extension filter would reach.
const SCANNED_ROOTS: Array[String] = [
	"res://scripts", "res://scenes", "res://data", "res://addons",
]

const PROJECT_SETTINGS_FILE: String = "res://project.godot"

## THE SEVEN ACCEPTED SUITES WHOSE SCOPE ASSERTIONS E2 MOVED ONE FOR ONE, the E2
## scripts each must now authorize by path, and the exact classes that grant is
## for. Read from the suites' own sources: a grant nobody can see is a grant that
## quietly stops meaning anything, and a grant for a class the file no longer
## names is a claim about nothing that still passes.
##
## FOUNDATION C1 IS DELIBERATELY NOT IN THIS LIST, and that is a design decision
## rather than an omission. This coordinator forwards the run build's stat-totals
## snapshot straight into the accepted award without ever naming its type: it
## does not read a total, construct one or interpret one, so naming the
## accumulator would be claiming knowledge it does not need and would have cost
## an eighth accepted suite an allowlist row for nothing.
const AUTHORIZING_SUITES: Array = [
	["res://tests/skill_tag_eligibility_verification.gd", "A",
		["res://scripts/levels/rift_level_up_coordinator.gd"],
		["SkillTagProfile"]],
	["res://tests/support_selection_verification.gd", "B",
		["res://scripts/levels/rift_level_up_coordinator.gd"],
		["SupportDefinition"]],
	["res://tests/passive_card_records_verification.gd", "C2",
		["res://scripts/levels/rift_level_up_coordinator.gd"],
		["PassiveCardDefinition"]],
	["res://tests/rift_offer_composition_verification.gd", "D1",
		["res://scripts/levels/rift_level_up_coordinator.gd"],
		["RiftOffer", "RiftOfferComposition"]],
	## TWO ROWS FOR ONE SUITE, BECAUSE THE TWO FILES ARE GRANTED DIFFERENT
	## CLASSES. The result type is granted the OFFER and refused the COMPOSER, so
	## folding both files into one row would assert something false about it — and
	## would be exactly the blanket exemption the per-class grant exists to avoid.
	["res://tests/rift_offer_composition_verification.gd", "D1",
		["res://scripts/levels/rift_level_up_result.gd"],
		["RiftOffer"]],
	["res://tests/rift_run_build_verification.gd", "D2",
		["res://scripts/levels/rift_level_up_coordinator.gd"],
		["RiftRunBuild"]],
	["res://tests/rift_offer_choice_verification.gd", "D3",
		["res://scripts/levels/rift_level_up_coordinator.gd",
			"res://scripts/levels/rift_level_up_result.gd"],
		["RiftOfferChoice", "RiftOfferChoiceResult"]],
	["res://tests/rift_experience_track_verification.gd", "E1",
		["res://scripts/levels/rift_level_up_coordinator.gd"],
		["RiftExperienceTrack", "RiftExperienceReading"]],
]

## THE PROOF A TOKEN SCAN CANNOT GIVE. A second offer, a level curve, a support
## fallback, an actor application or a persistence step need name nothing
## forbidden at all — each arrives as an extra method with a plausible name. So
## each script's methods are enumerated from the engine and pinned BY NAME, IN
## ORDER, WITH THEIR FULL SIGNATURES, which is also the half that proves no
## content can reach the lifecycle: there is no argument anywhere of a shape that
## could carry a level cost, a drop value or a derived seed.
##
## FOUNDATION G3 (decision D-267) MOVED THIS PIN BY EXACTLY ONE ROW, ADDED AND
## NOT REPLACED: `next_level_coordinator()`, declared after the choice section.
## It takes no argument, so it too can carry no level cost and no derived seed;
## it answers null or a new coordinator built through `with_state()`, and its own
## suite proves both halves. No other row moved and the field pin did not move.
##
## ROGUELITE I10 (decision D-312) MOVED IT BY EXACTLY TWO ROWS, ADDED AND NOT REPLACED:
## `offer_support_content_kind()` and `offer_support_fallback_category()`, declared
## right after `offer_identity_for()`. Each takes no argument and answers an int read
## from the standing offer — its stored Support content kind, and a passive fallback's
## category — so neither can carry a level cost or a derived seed. No other row moved
## and the field pin did not move.
const EXPECTED_COORDINATOR_SIGNATURES: Array[String] = [
	"with_state(track: Object, build: Object, ledger: Object) -> Object",
	"level() -> int",
	"experience() -> float",
	"is_completed() -> bool",
	"is_offer_active() -> bool",
	"offer_root_seed() -> int",
	"offer_lanes() -> type 28",
	"offer_identity_for(lane: int) -> type 34",
	"offer_support_content_kind() -> int",
	"offer_support_fallback_category() -> int",
	"frozen_requirement() -> float",
	"reading_for(requirement: float) -> Object",
	"run_build() -> Object",
	"consumption_ledger() -> Object",
	"award_experience(base_experience: float) -> String",
	"open_offer(requirement: float, profiles: type 28, definitions: type 28,"
		+ " cards: type 28, root_seed: int) -> String",
	"choose(lane: int) -> Object",
	"_no_offer_reason() -> String",
	"next_level_coordinator() -> Object",
	"describe() -> String",
	"_lifecycle_line() -> String",
]

## FOUNDATION F5 (decision D-260) MOVED THIS PIN BY EXACTLY THREE ROWS. `taken()`
## now takes the successful choice result WHOLE rather than its seed, lane and
## identity separately — one row replaced one for one — and the receipt gained
## the two progression readings its brief names, each in the position the
## accepted choice result declares its own.
##
## FOUNDATION G4 (decision D-269) MOVED IT BY EXACTLY ONE ROW, ADDED AND NOT
## REPLACED: `duplicated()`, declared after `problem()`. It takes no argument and
## adds no field; it answers an independent copy of the receipt, which the
## Foundation G4 suite proves field by field. No other row moved.
##
## ROGUELITE FOUNDATION I9 (decision D-310) MOVED IT BY EXACTLY TWO ROWS, ADDED AND
## NOT REPLACED: `carries_support_fallback()` after `carries_support_progression()`
## and `support_fallback_line()` after `support_progression_line()` — the positions
## the accepted choice result and offer give their own. Neither takes an argument,
## so neither can carry a level cost or a derived seed. No other row moved.
const EXPECTED_RESULT_SIGNATURES: Array[String] = [
	"refused_without_a_seed(reason: String, requested_lane: int) -> Object",
	"refused(reason: String, for_root_seed: int, requested_lane: int) -> Object",
	"taken(from_choice: Object) -> Object",
	"granted_identity() -> type 34",
	"carries_support_progression() -> bool",
	"carries_support_fallback() -> bool",
	"problem() -> String",
	"duplicated() -> Object",
	"identity_line() -> String",
	"support_progression_line() -> String",
	"support_fallback_line() -> String",
	"describe() -> String",
	"_stated(reason: String) -> String",
]

## SIX FIELDS, ALL PRIVATE, AND NO SEVENTH. The brief names exactly these six as
## the coordinator's whole state, and the pin is what makes that true rather than
## intended: a cached stat snapshot, a second level counter, a retained lane, a
## kept offer history or a saved schema version would each arrive here.
const EXPECTED_COORDINATOR_FIELDS: Array[String] = [
	"_track", "_build", "_ledger", "_offer", "_requirement", "_completed",
]

## EIGHT PUBLIC SCALARS AND ONE PRIVATE COLLECTION, AND THE ASYMMETRY IS A
## MEASUREMENT RATHER THAN A PREFERENCE. A packed array read out of a script
## VARIABLE aliases rather than copying, so a public field of that type is one a
## caller can rewrite through a reference it was only given to read — driven on a
## probe in the last check, in both directions.
##
## THE THREE PROGRESSION SCALARS ARRIVED WITH FOUNDATION F5 (decision D-260), in
## the position the accepted choice result declares them. Still no build, no
## ledger, no track, no offer, no level and no experience: the receipt is a
## compact historical record, and the pin is what keeps it one.
##
## THE TWO SUPPORT-CONTENT SCALARS ARRIVED WITH ROGUELITE FOUNDATION I9 (decision
## D-310), appended after every accepted field in the order the accepted choice
## result declares them: ten public scalars and the one private collection. Still
## no build, no ledger, no track, no offer, no choice result, no level and no
## experience.
const EXPECTED_RESULT_FIELDS: Array[String] = [
	"ok", "failure_reason", "root_seed", "root_seed_known", "lane",
	"support_progression_kind", "support_rank_before", "support_rank_after",
	"_granted_identity",
	"support_content_kind", "support_fallback_category",
]

# --- The worked lifecycle, typed independently -----------------------------------
#
# The two awards, the requirement and the root seed come from the brief.
# Everything derived from them was measured against the accepted mechanisms
# before it was written down here, and each is exact: 50 and 100 are integers a
# double represents precisely, and so is their sum.

const BASE_AWARD: float = 50.0

## Exact: two unmodified awards of 50 are precisely 100.
const REACHED_REQUIREMENT: float = 100.0

## The brief's root offer seed. Zero is a perfectly ordinary seed and is used on
## purpose — it is also the value `offer_root_seed()` answers when no offer
## stands, so a check that only ever asked for a seed of zero could not tell a
## standing offer from an absent one. Every such assertion below is paired with
## `is_offer_active()`, which is the authority.
const ROOT_SEED: int = 0

## The three lane seeds root seed zero derives, pinned from the accepted
## composition mechanism's own published corpus rather than read back out of the
## offer being checked.
const EXPECTED_SUPPORT_LANE_SEED: int = 2074702303
const EXPECTED_COMBAT_LANE_SEED: int = 856502828
const EXPECTED_UTILITY_LANE_SEED: int = 83415710

## What the shipped records must produce at that seed. Typed here rather than
## read from the catalogues being exercised: a check that takes its expected
## answer from the thing it is checking proves only that a file agrees with
## itself.
const EXPECTED_SKILL: StringName = &"quick_strike"
const EXPECTED_SUPPORT: StringName = &"reaching_edge"
const EXPECTED_OTHER_SUPPORT: StringName = &"sweeping_edge"
const EXPECTED_COMBAT_CARD: StringName = &"card_vitality"
const EXPECTED_COMBAT_STAT: StringName = &"maximum_life"
const EXPECTED_COMBAT_MAGNITUDE: float = 0.15
const EXPECTED_UTILITY_CARD: StringName = &"card_magnetism"
const EXPECTED_UTILITY_STAT: StringName = &"pickup_radius"
const EXPECTED_UTILITY_MAGNITUDE: float = 0.25

## The canonical Utility card whose id a test-only record carries while declaring
## a Combat and Defence stat. It is what makes the choice transaction's
## category-disagreement refusal REACHABLE through this coordinator: the offer is
## composed against the fabricated record set a caller supplies, and the
## transaction resolves the canonical one.
const CANONICAL_UTILITY_ID: StringName = &"card_insight"

## The shipped card that grants Experience Gain, found by STAT rather than by id
## so this suite does not hard-code which record grants it, and the level this
## foundation's one advance must reach.
const EXPECTED_LEVEL_AFTER: int = 2

## The third award, and what it leaves behind after one requirement is taken.
## Exact: 150 minus 100 is precisely 50.
const OVERFLOW_TOTAL: float = 150.0
const EXPECTED_OVERFLOW: float = 50.0

## A lane value outside the declared set.
const UNDECLARED_LANE: int = 7

const PROBE_WEIGHT: int = 100
const PROBE_MAGNITUDE: float = 0.10
const PROBE_LABEL: String = "Zz Probe Card"

## How many root seeds the held-pair measurement is made over. Deliberately
## modest: the property is structural, and the corpus exists to show the
## structure holds rather than to search for a counterexample.
const SEED_SAMPLES: int = 64

const OWED_CHECKS: Array[String] = [
	"a_default_coordinator_is_level_one_with_no_offer_and_empty_state",
	"two_awards_of_fifty_reach_the_supplied_requirement",
	"opening_the_root_seed_produces_the_accepted_three_lane_offer",
	"an_open_offer_freezes_the_level_and_refuses_awards_and_a_second_open",
	"taking_the_support_lane_reaches_level_two_with_one_pair_and_no_passive",
	"taking_the_combat_lane_reaches_level_two_with_its_canonical_contribution",
	"taking_the_utility_lane_reaches_level_two_with_its_canonical_contribution",
	"the_three_lanes_are_independent_from_identical_pre_choice_snapshots",
	"experience_gain_already_held_raises_only_the_awards_that_follow",
	"overflow_experience_survives_the_advance",
	"opening_below_the_threshold_or_against_no_requirement_refuses_atomically",
	"a_composition_refusal_leaves_no_offer_open_and_the_coordinator_usable",
	"an_undeclared_lane_refuses_and_leaves_the_offer_available",
	"a_catalogue_disagreement_refuses_without_advancing_or_consuming",
	"a_composed_offer_never_names_a_pair_this_run_already_holds",
	"a_finished_coordinator_refuses_every_operation_without_mutation",
	"supplied_state_and_every_returned_copy_are_independent",
	"the_coordinator_is_generic_reads_nothing_ambient_and_is_unwired",
]

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}
var _refusals: int = 0

## The shipped Experience Gain card and magnitude, found by STAT.
var _gain_card: StringName = &""
var _gain_magnitude: float = 0.0


func _initialize() -> void:
	print("")
	print("=== Roguelite Foundation E2 — Single Rift Level-Up Coordinator (D-248) ===")

	if not _load_shipped_experience_gain():
		printerr("  FAIL: no shipped passive card grants Experience Gain")
		printerr("RIFT LEVEL-UP COORDINATOR VERIFICATION: 1 FAILURE(S) of 0 checks")
		quit(1)
		return

	_check_a_default_coordinator_is_level_one()
	_check_two_awards_reach_the_supplied_requirement()
	_check_opening_produces_the_accepted_three_lane_offer()
	_check_an_open_offer_freezes_the_level()
	_check_taking_the_support_lane()
	_check_taking_the_combat_lane()
	_check_taking_the_utility_lane()
	_check_the_three_lanes_are_independent()
	_check_experience_gain_raises_only_later_awards()
	_check_overflow_survives_the_advance()
	_check_opening_below_the_threshold_refuses_atomically()
	_check_a_composition_refusal_leaves_no_offer_open()
	_check_an_undeclared_lane_leaves_the_offer_available()
	_check_a_catalogue_disagreement_refuses_atomically()
	_check_a_composed_offer_never_names_a_held_pair()
	_check_a_finished_coordinator_refuses_everything()
	_check_supplied_state_and_returned_copies_are_independent()
	_check_the_coordinator_is_generic_and_unwired()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("RIFT LEVEL-UP COORDINATOR VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("RIFT LEVEL-UP COORDINATOR VERIFICATION: %d FAILURE(S) of %d checks" % [
			_failures.size(), _checks,
		])
		quit(1)


# --- 1. A default coordinator ------------------------------------------------------

func _check_a_default_coordinator_is_level_one() -> void:
	print("")
	print("--- 1. A default coordinator: Level 1, no experience, nothing held, no offer")
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()

	_expect(lifecycle.level() == 1, "a default coordinator is at level %d" % lifecycle.level())
	_expect(lifecycle.level() == RiftExperienceTrack.STARTING_LEVEL,
		"a default coordinator does not start at the accepted track's own starting level")
	## `==` against the typed zero rather than `is_zero_approx`: a lifecycle that
	## began at a value merely close to zero would be a different thing, and a
	## tolerance is exactly what would hide it.
	_expect(lifecycle.experience() == 0.0,
		"a default coordinator holds %s experience" % _exact(lifecycle.experience()))
	_expect(not lifecycle.is_completed(), "a default coordinator reports itself finished")
	_expect(not lifecycle.is_offer_active(), "a default coordinator already holds an offer")
	_expect(lifecycle.run_build().is_empty(), "a default coordinator's run build is not empty")
	_expect(lifecycle.consumption_ledger().is_empty(),
		"a default coordinator's ledger is not empty")
	_expect(lifecycle.consumption_ledger().count() == 0,
		"a default coordinator's ledger holds %d seeds" % lifecycle.consumption_ledger().count())

	## THE FROZEN REQUIREMENT AND THE ROOT SEED, BOTH IN THE ABSENT DIRECTION.
	## Zero could never have been frozen, because the accepted track refuses any
	## requirement that is not strictly positive — asserted here rather than
	## assumed, so the constant is a value that means "none" for a reason.
	_expect(lifecycle.frozen_requirement() == RiftLevelUpCoordinator.NO_REQUIREMENT,
		"a default coordinator has frozen %s" % _exact(lifecycle.frozen_requirement()))
	_expect(not RiftExperienceTrack.requirement_problem(
			RiftLevelUpCoordinator.NO_REQUIREMENT).is_empty(),
		"the no-requirement value is one the accepted track would accept as a requirement")
	_expect(lifecycle.offer_root_seed() == RiftLevelUpCoordinator.UNSTATED_ROOT_SEED,
		"a default coordinator reports root seed %d" % lifecycle.offer_root_seed())
	_expect(lifecycle.offer_lanes().is_empty(),
		"a default coordinator reports %d lanes" % lifecycle.offer_lanes().size())
	for lane: int in RiftOffer.LANE_ORDER:
		_expect(lifecycle.offer_identity_for(lane).is_empty(),
			"a default coordinator names an identity for lane %d" % lane)

	## Two default coordinators are the same lifecycle and neither is the other.
	var second: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()
	_expect(_snapshot(second) == _snapshot(lifecycle),
		"two default coordinators differ:\n    %s\n    %s" % [
			_snapshot(second), _snapshot(lifecycle),
		])
	_expect(second != lifecycle, "two separately constructed coordinators are one object")

	## AND `with_state()` GIVEN NOTHING IS THE SAME LIFECYCLE, which is what makes
	## the verification entry point safe to use as a starting point rather than a
	## second construction path with its own defaults.
	var supplied: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, null, null)
	_expect(_snapshot(supplied) == _snapshot(lifecycle),
		"with_state(null, null, null) is not a default coordinator: %s" % _snapshot(supplied))

	print("  a default coordinator: %s" % _snapshot(lifecycle))
	_done("a_default_coordinator_is_level_one_with_no_offer_and_empty_state")


# --- 2. Two awards reach the requirement -------------------------------------------

func _check_two_awards_reach_the_supplied_requirement() -> void:
	print("")
	print("--- 2. Two base awards of 50 reach a supplied requirement of 100")
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()

	_expect_accepted(lifecycle.award_experience(BASE_AWARD), "the first award of 50")
	_expect(lifecycle.experience() == BASE_AWARD,
		"one award of 50 left %s" % _exact(lifecycle.experience()))
	var half: RiftExperienceReading = lifecycle.reading_for(REACHED_REQUIREMENT)
	_expect(half.ok and not half.ready,
		"one award of 50 was reported ready for a requirement of 100")
	_expect(half.remaining == BASE_AWARD,
		"one award of 50 leaves %s of 100 remaining" % _exact(half.remaining))

	_expect_accepted(lifecycle.award_experience(BASE_AWARD), "the second award of 50")
	## EXACT, not approximate: fifty and one hundred are integers a double
	## represents precisely, and so is their sum.
	_expect(lifecycle.experience() == REACHED_REQUIREMENT,
		"two awards of 50 came to %s" % _exact(lifecycle.experience()))
	var whole: RiftExperienceReading = lifecycle.reading_for(REACHED_REQUIREMENT)
	_expect(whole.ok and whole.ready,
		"two awards of 50 were not reported ready for a requirement of 100")
	_expect(whole.remaining == 0.0,
		"two awards of 50 leave %s remaining of 100" % _exact(whole.remaining))
	_expect(whole.problem().is_empty(), "the reading reports: %s" % whole.problem())

	## THE READING IS PURE. Asking whether a level-up is available must not open
	## one, spend anything or move the lifecycle at all.
	var before: String = _snapshot(lifecycle)
	for repeat: int in range(3):
		lifecycle.reading_for(REACHED_REQUIREMENT)
	_expect(_snapshot(lifecycle) == before,
		"asking for a reading moved the lifecycle:\n    before %s\n    after  %s" % [
			before, _snapshot(lifecycle),
		])
	_expect(lifecycle.level() == 1,
		"reaching the requirement advanced the level to %d on its own" % lifecycle.level())

	print("  50 -> %s, 50 -> %s; ready for 100 with %s remaining; the level never moved" % [
		_exact(BASE_AWARD), _exact(lifecycle.experience()), _exact(whole.remaining),
	])
	_done("two_awards_of_fifty_reach_the_supplied_requirement")


# --- 3. Opening the one offer ------------------------------------------------------

func _check_opening_produces_the_accepted_three_lane_offer() -> void:
	print("")
	print("--- 3. Opening root seed 0 produces the accepted three-lane offer")
	var lifecycle: RiftLevelUpCoordinator = _ready_coordinator()

	_expect_accepted(_open(lifecycle, REACHED_REQUIREMENT, _shipped_cards(), ROOT_SEED),
		"opening root seed 0 against a requirement of 100")
	_expect(lifecycle.is_offer_active(), "no offer stands after a successful open")
	_expect(lifecycle.offer_root_seed() == ROOT_SEED,
		"the standing offer reports root seed %d" % lifecycle.offer_root_seed())
	_expect(lifecycle.frozen_requirement() == REACHED_REQUIREMENT,
		"the frozen requirement is %s" % _exact(lifecycle.frozen_requirement()))

	## THE LANE ORDER IS ASSERTED MEMBER FOR MEMBER, NOT BY LENGTH. A three-entry
	## array in the wrong order is exactly the failure a length test cannot see —
	## D1's own lesson, and the reason this coordinator forwards the offer's order
	## rather than restating it.
	var lanes: Array[int] = lifecycle.offer_lanes()
	_expect(lanes.size() == RiftOffer.LANE_ORDER.size(),
		"the standing offer carries %d lanes" % lanes.size())
	var order_matches: bool = lanes.size() == RiftOffer.LANE_ORDER.size()
	if order_matches:
		for index: int in range(lanes.size()):
			if lanes[index] != RiftOffer.LANE_ORDER[index]:
				order_matches = false
	_expect(order_matches, "the lane order is %s, not the composed order %s" % [
		str(lanes), str(RiftOffer.LANE_ORDER),
	])

	## THE THREE IDENTITIES, EACH KEYED ON ITS LANE MEMBER.
	var support: PackedStringArray = lifecycle.offer_identity_for(RiftOffer.Lane.SUPPORT)
	_expect(support.size() == 2, "the support lane names %d identifiers" % support.size())
	_expect(support.size() == 2 and StringName(support[0]) == EXPECTED_SKILL,
		"the support lane names the Skill %s" % " -> ".join(support))
	_expect(support.size() == 2 and StringName(support[1]) == EXPECTED_SUPPORT,
		"the support lane names the support %s" % " -> ".join(support))
	var combat: PackedStringArray = lifecycle.offer_identity_for(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect(combat.size() == 1 and StringName(combat[0]) == EXPECTED_COMBAT_CARD,
		"the Combat and Defence lane names %s" % " -> ".join(combat))
	var utility: PackedStringArray = lifecycle.offer_identity_for(RiftOffer.Lane.UTILITY)
	_expect(utility.size() == 1 and StringName(utility[0]) == EXPECTED_UTILITY_CARD,
		"the Utility lane names %s" % " -> ".join(utility))
	_expect(lifecycle.offer_identity_for(UNDECLARED_LANE).is_empty(),
		"an undeclared lane names an identity in a standing offer")

	## AND THE OFFER IS THE ACCEPTED MECHANISM'S OWN, COMPOSED FROM THE SAME
	## THREE LANE SEEDS. The coordinator is proved to have DELEGATED rather than
	## arrived at the same answer some other way, by re-deriving each lane seed
	## from the published contract and comparing the whole composition against
	## the accepted composer called directly with this run's own snapshot.
	_expect(RiftOfferComposition.lane_seed_for(ROOT_SEED, RiftOffer.Lane.SUPPORT)
			== EXPECTED_SUPPORT_LANE_SEED,
		"the support lane seed is %d" % RiftOfferComposition.lane_seed_for(
			ROOT_SEED, RiftOffer.Lane.SUPPORT))
	_expect(RiftOfferComposition.lane_seed_for(ROOT_SEED, RiftOffer.Lane.COMBAT_DEFENCE)
			== EXPECTED_COMBAT_LANE_SEED,
		"the Combat and Defence lane seed is %d" % RiftOfferComposition.lane_seed_for(
			ROOT_SEED, RiftOffer.Lane.COMBAT_DEFENCE))
	_expect(RiftOfferComposition.lane_seed_for(ROOT_SEED, RiftOffer.Lane.UTILITY)
			== EXPECTED_UTILITY_LANE_SEED,
		"the Utility lane seed is %d" % RiftOfferComposition.lane_seed_for(
			ROOT_SEED, RiftOffer.Lane.UTILITY))
	var directly: RiftOffer = RiftOfferComposition.compose(
		SkillSupportCatalogue.skill_profiles(), SkillSupportCatalogue.support_definitions(),
		AcquiredSupports.new(), _shipped_cards(), ROOT_SEED
	)
	_expect(directly.ok, "the accepted composer refused root seed 0: %s" % directly.failure_reason)
	_expect(directly.describe() == _offer_line(lifecycle),
		"the coordinator's offer is not the composer's:\n    %s\n    %s" % [
			_offer_line(lifecycle), directly.describe(),
		])

	## OPENING THE OFFER GRANTS NOTHING. Not a pair, not a card, not a modifier,
	## not a consumption, not a level — an offer is the question.
	_expect(lifecycle.level() == 1,
		"opening an offer advanced the level to %d" % lifecycle.level())
	_expect(lifecycle.experience() == REACHED_REQUIREMENT,
		"opening an offer moved the experience to %s" % _exact(lifecycle.experience()))
	_expect(lifecycle.run_build().is_empty(), "opening an offer changed the run build")
	_expect(lifecycle.consumption_ledger().is_empty(), "opening an offer consumed a seed")
	_expect(not lifecycle.is_completed(), "opening an offer finished the lifecycle")

	print("  root seed 0 [Support %d, Combat and Defence %d, Utility %d] -> %s | %s | %s" % [
		EXPECTED_SUPPORT_LANE_SEED, EXPECTED_COMBAT_LANE_SEED, EXPECTED_UTILITY_LANE_SEED,
		" -> ".join(support), " -> ".join(combat), " -> ".join(utility),
	])
	_done("opening_the_root_seed_produces_the_accepted_three_lane_offer")


# --- 4. The active-offer boundary --------------------------------------------------

func _check_an_open_offer_freezes_the_level() -> void:
	print("")
	print("--- 4. While an offer stands: no award, no second offer, no level")
	var lifecycle: RiftLevelUpCoordinator = _open_coordinator()
	var before: String = _snapshot(lifecycle)

	_expect_atomic_refusal(lifecycle, before,
		lifecycle.award_experience(BASE_AWARD), "an award while an offer stands")
	_expect_atomic_refusal(lifecycle, before,
		lifecycle.award_experience(OVERFLOW_TOTAL), "a second award while an offer stands")
	_expect_atomic_refusal(lifecycle, before,
		_open(lifecycle, REACHED_REQUIREMENT, _shipped_cards(), ROOT_SEED),
		"reopening the same offer")
	_expect_atomic_refusal(lifecycle, before,
		_open(lifecycle, REACHED_REQUIREMENT, _shipped_cards(), ROOT_SEED + 1),
		"opening a different offer while one stands")

	## THE REFUSED AWARD IS REFUSED BY THE BOUNDARY RATHER THAN BY THE AWARD, and
	## the positive control is what proves it: exactly the same award is accepted
	## by an otherwise identical coordinator with no offer standing.
	var control: RiftLevelUpCoordinator = _ready_coordinator()
	_expect_accepted(control.award_experience(BASE_AWARD),
		"the same award on a coordinator with no offer standing")

	## AND THE OFFER IS STILL THE ONE THAT WAS COMPOSED. A refused reopen that
	## quietly replaced the standing offer would leave every scalar above intact.
	_expect(lifecycle.offer_root_seed() == ROOT_SEED,
		"the standing offer now reports root seed %d" % lifecycle.offer_root_seed())
	_expect(lifecycle.frozen_requirement() == REACHED_REQUIREMENT,
		"the frozen requirement is now %s" % _exact(lifecycle.frozen_requirement()))
	_expect(lifecycle.level() == 1,
		"the level moved to %d while an offer stood" % lifecycle.level())

	print("  4 operations refused while the offer stood; the whole lifecycle is unmoved at %s"
		% _snapshot(lifecycle))
	_done("an_open_offer_freezes_the_level_and_refuses_awards_and_a_second_open")


# --- 5. The support lane ------------------------------------------------------------

func _check_taking_the_support_lane() -> void:
	print("")
	print("--- 5. Taking the Support lane: Level 2, one pair, no passive contribution")
	var lifecycle: RiftLevelUpCoordinator = _open_coordinator()
	var offered: PackedStringArray = lifecycle.offer_identity_for(RiftOffer.Lane.SUPPORT)
	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.SUPPORT)

	_expect_taken(outcome, RiftOffer.Lane.SUPPORT, "taking the Support lane")
	_expect(outcome.granted_identity().size() == 2,
		"the Support lane granted %d identifiers" % outcome.granted_identity().size())
	_expect(outcome.granted_identity().size() == 2
			and StringName(outcome.granted_identity()[0]) == EXPECTED_SKILL
			and StringName(outcome.granted_identity()[1]) == EXPECTED_SUPPORT,
		"the Support lane granted %s" % outcome.identity_line())


	## AND THE GRANTED IDENTITY SURVIVES THE RELEASE OF THE OFFER, WHICH IS THE
	## ONE THING THIS RESULT TYPE EXISTS FOR. The commit releases the offer, so
	## the coordinator can no longer answer what that lane offered — and the
	## result still reports exactly what the offer had named before it was spent.
	_expect(" -> ".join(outcome.granted_identity()) == " -> ".join(offered),
		"the Support lane granted %s but the offer had named %s" % [
			outcome.identity_line(), " -> ".join(offered),
		])
	_expect(lifecycle.offer_identity_for(RiftOffer.Lane.SUPPORT).is_empty(),
		"the released offer still names an identity for the lane that was taken")

	_expect_finished_at_level_two(lifecycle, "the Support lane")

	var build: RiftRunBuild = lifecycle.run_build()
	_expect(build.support_count() == 1,
		"the run build holds %d pairs" % build.support_count())
	_expect(build.has_support(EXPECTED_SKILL, EXPECTED_SUPPORT),
		"the run build does not hold the offered pair: %s" % str(build.support_pairs()))
	## NO PASSIVE CONTRIBUTION AT ALL, asserted three ways because a support lane
	## that quietly acquired a card would move only one of them.
	_expect(build.passive_acquisitions() == 0,
		"the Support lane recorded %d passive acquisitions" % build.passive_acquisitions())
	_expect(build.acquired_card_ids().is_empty(),
		"the Support lane recorded the card(s) %s" % str(build.acquired_card_ids()))
	_expect(build.stat_totals().is_empty(),
		"the Support lane contributed stat totals: %s" % build.stat_totals().describe())
	_expect(build.total_for(EXPECTED_COMBAT_STAT) == 0.0
			and build.total_for(EXPECTED_UTILITY_STAT) == 0.0,
		"the Support lane moved a passive stat: %s" % build.describe())

	print("  Support: %s; %s" % [outcome.identity_line(), build.describe()])
	_done("taking_the_support_lane_reaches_level_two_with_one_pair_and_no_passive")


# --- 6. The Combat and Defence lane -------------------------------------------------

func _check_taking_the_combat_lane() -> void:
	print("")
	print("--- 6. Taking the Combat and Defence lane: Level 2 and exactly its magnitude")
	var lifecycle: RiftLevelUpCoordinator = _open_coordinator()
	var offered: PackedStringArray = lifecycle.offer_identity_for(
		RiftOffer.Lane.COMBAT_DEFENCE)
	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.COMBAT_DEFENCE)

	_expect_taken(outcome, RiftOffer.Lane.COMBAT_DEFENCE, "taking the Combat and Defence lane")
	_expect(outcome.granted_identity().size() == 1
			and StringName(outcome.granted_identity()[0]) == EXPECTED_COMBAT_CARD,
		"the Combat and Defence lane granted %s" % outcome.identity_line())


	## AND THE GRANTED IDENTITY SURVIVES THE RELEASE OF THE OFFER, WHICH IS THE
	## ONE THING THIS RESULT TYPE EXISTS FOR. The commit releases the offer, so
	## the coordinator can no longer answer what that lane offered — and the
	## result still reports exactly what the offer had named before it was spent.
	_expect(" -> ".join(outcome.granted_identity()) == " -> ".join(offered),
		"the Combat and Defence lane granted %s but the offer had named %s" % [
			outcome.identity_line(), " -> ".join(offered),
		])
	_expect(lifecycle.offer_identity_for(RiftOffer.Lane.COMBAT_DEFENCE).is_empty(),
		"the released offer still names an identity for the lane that was taken")

	_expect_finished_at_level_two(lifecycle, "the Combat and Defence lane")
	_expect_only_this_passive(lifecycle.run_build(), EXPECTED_COMBAT_CARD,
		EXPECTED_COMBAT_STAT, EXPECTED_COMBAT_MAGNITUDE, EXPECTED_UTILITY_STAT,
		"the Combat and Defence lane")

	print("  Combat and Defence: %s -> %s %s" % [
		outcome.identity_line(), EXPECTED_COMBAT_STAT,
		_exact(lifecycle.run_build().total_for(EXPECTED_COMBAT_STAT)),
	])
	_done("taking_the_combat_lane_reaches_level_two_with_its_canonical_contribution")


# --- 7. The Utility lane -------------------------------------------------------------

func _check_taking_the_utility_lane() -> void:
	print("")
	print("--- 7. Taking the Utility lane: Level 2 and exactly its magnitude")
	var lifecycle: RiftLevelUpCoordinator = _open_coordinator()
	var offered: PackedStringArray = lifecycle.offer_identity_for(RiftOffer.Lane.UTILITY)
	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.UTILITY)

	_expect_taken(outcome, RiftOffer.Lane.UTILITY, "taking the Utility lane")
	_expect(outcome.granted_identity().size() == 1
			and StringName(outcome.granted_identity()[0]) == EXPECTED_UTILITY_CARD,
		"the Utility lane granted %s" % outcome.identity_line())


	## AND THE GRANTED IDENTITY SURVIVES THE RELEASE OF THE OFFER, WHICH IS THE
	## ONE THING THIS RESULT TYPE EXISTS FOR. The commit releases the offer, so
	## the coordinator can no longer answer what that lane offered — and the
	## result still reports exactly what the offer had named before it was spent.
	_expect(" -> ".join(outcome.granted_identity()) == " -> ".join(offered),
		"the Utility lane granted %s but the offer had named %s" % [
			outcome.identity_line(), " -> ".join(offered),
		])
	_expect(lifecycle.offer_identity_for(RiftOffer.Lane.UTILITY).is_empty(),
		"the released offer still names an identity for the lane that was taken")

	_expect_finished_at_level_two(lifecycle, "the Utility lane")
	_expect_only_this_passive(lifecycle.run_build(), EXPECTED_UTILITY_CARD,
		EXPECTED_UTILITY_STAT, EXPECTED_UTILITY_MAGNITUDE, EXPECTED_COMBAT_STAT,
		"the Utility lane")

	print("  Utility: %s -> %s %s" % [
		outcome.identity_line(), EXPECTED_UTILITY_STAT,
		_exact(lifecycle.run_build().total_for(EXPECTED_UTILITY_STAT)),
	])
	_done("taking_the_utility_lane_reaches_level_two_with_its_canonical_contribution")


# --- 8. Three lanes, one pre-choice state --------------------------------------------

func _check_the_three_lanes_are_independent() -> void:
	print("")
	print("--- 8. From identical pre-choice snapshots, the three lanes are independent")
	var lifecycles: Array[RiftLevelUpCoordinator] = []
	for lane: int in RiftOffer.LANE_ORDER:
		lifecycles.append(_open_coordinator())

	## THE PRE-CHOICE STATES ARE PROVED IDENTICAL FIRST. Without this, three
	## different outcomes could be three different starting points rather than
	## three different choices, and the whole check would prove nothing.
	var reference: String = _snapshot(lifecycles[0])
	for index: int in range(lifecycles.size()):
		_expect(_snapshot(lifecycles[index]) == reference,
			"pre-choice state %d differs:\n    %s\n    %s" % [
				index, _snapshot(lifecycles[index]), reference,
			])

	var after: PackedStringArray = PackedStringArray()
	for index: int in range(RiftOffer.LANE_ORDER.size()):
		var lane: int = RiftOffer.LANE_ORDER[index]
		var outcome: RiftLevelUpResult = lifecycles[index].choose(lane)
		_expect(outcome.ok and outcome.problem().is_empty(),
			"lane %d refused from the shared state: %s" % [lane, outcome.failure_reason])
		after.append(_snapshot(lifecycles[index]))

	## EVERY OUTCOME DIFFERS FROM EVERY OTHER, AND FROM THE STATE THEY SHARED.
	for index: int in range(after.size()):
		_expect(after[index] != reference,
			"lane %d left the lifecycle exactly as it found it" % RiftOffer.LANE_ORDER[index])
		for other: int in range(index + 1, after.size()):
			_expect(after[index] != after[other],
				"lanes %d and %d produced identical lifecycles:\n    %s" % [
					RiftOffer.LANE_ORDER[index], RiftOffer.LANE_ORDER[other], after[index],
				])

	## AND EACH ONE CARRIES ONLY ITS OWN LANE'S EFFECT. The unchosen lanes are
	## asserted absent by NAME rather than by counting, because a build holding
	## one pair and one card would have the same totals count as one holding two
	## cards.
	var support_build: RiftRunBuild = lifecycles[0].run_build()
	var combat_build: RiftRunBuild = lifecycles[1].run_build()
	var utility_build: RiftRunBuild = lifecycles[2].run_build()
	_expect(support_build.acquisitions_for(EXPECTED_COMBAT_CARD) == 0
			and support_build.acquisitions_for(EXPECTED_UTILITY_CARD) == 0,
		"the Support choice acquired an unchosen card: %s" % support_build.describe())
	_expect(combat_build.support_count() == 0
			and combat_build.acquisitions_for(EXPECTED_UTILITY_CARD) == 0,
		"the Combat and Defence choice took an unchosen lane: %s" % combat_build.describe())
	_expect(utility_build.support_count() == 0
			and utility_build.acquisitions_for(EXPECTED_COMBAT_CARD) == 0,
		"the Utility choice took an unchosen lane: %s" % utility_build.describe())

	## ALL THREE SPEND THE SAME ONE SEED, EXACTLY ONCE.
	for index: int in range(lifecycles.size()):
		var ledger: RiftConsumptionLedger = lifecycles[index].consumption_ledger()
		_expect(ledger.count() == 1 and ledger.has_consumed(ROOT_SEED),
			"lane %d consumed %s" % [RiftOffer.LANE_ORDER[index], ledger.describe()])

	print("  one pre-choice state, three outcomes, three distinct lifecycles:")
	for index: int in range(after.size()):
		print("    %s: %s" % [RiftOffer.lane_label(RiftOffer.LANE_ORDER[index]), after[index]])
	_done("the_three_lanes_are_independent_from_identical_pre_choice_snapshots")


# --- 9. Experience Gain reaches only later awards -------------------------------------

func _check_experience_gain_raises_only_later_awards() -> void:
	print("")
	print("--- 9. Experience Gain held before an award raises that award and no earlier one")
	var held: RiftRunBuild = RiftRunBuild.new()
	_expect_accepted(held.acquire_passive_card(PassiveCardCatalogue.record(_gain_card)),
		"acquiring the shipped Experience Gain card into the initial build")
	_expect(held.total_for(PlayerStats.EXPERIENCE_GAIN) == _gain_magnitude,
		"the initial build totals %s of Experience Gain"
			% _exact(held.total_for(PlayerStats.EXPERIENCE_GAIN)))

	var boosted: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(null, held, null)
	var plain: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()
	_expect_accepted(boosted.award_experience(BASE_AWARD), "an award of 50 with Gain held")
	_expect_accepted(plain.award_experience(BASE_AWARD), "an award of 50 with nothing held")

	## THE EXPECTED VALUE IS DERIVED THROUGH THE ACCEPTED CALCULATION PATH RATHER
	## THAN TYPED. Fifty at the shipped grant is not the decimal a reader would
	## write, and a typed constant would fail for a reason that has nothing to do
	## with this coordinator — D-246's sharpest lesson, applied.
	var expected: PlayerStatValue = held.stat_totals().value_of(
		PlayerStats.EXPERIENCE_GAIN, BASE_AWARD)
	_expect(expected.ok, "the accepted path could not evaluate the boosted award")
	_expect(boosted.experience() == expected.value,
		"a boosted award of 50 came to %s, not the accepted path's %s" % [
			_exact(boosted.experience()), _exact(expected.value),
		])
	_expect(boosted.experience() > plain.experience(),
		"Experience Gain did not raise the award: %s against %s" % [
			_exact(boosted.experience()), _exact(plain.experience()),
		])
	_expect(plain.experience() == BASE_AWARD,
		"an unmodified award of 50 came to %s" % _exact(plain.experience()))

	## AND IT IS NOT RETROACTIVE, PROVED FROM THE INITIAL SNAPSHOT'S OWN
	## INDEPENDENCE. Granting the caller's build more Gain after the coordinator
	## was built cannot reach any award, past or future, because the coordinator
	## duplicated it — and the accumulator really did change, so the claim is not
	## vacuous.
	var before_more: String = _snapshot(boosted)
	_expect_accepted(held.acquire_passive_card(PassiveCardCatalogue.record(_gain_card)),
		"granting the supplied build a second Experience Gain card")
	_expect(held.acquisitions_for(_gain_card) == 2,
		"the supplied build did not take a second Gain card: %d"
			% held.acquisitions_for(_gain_card))
	_expect(_snapshot(boosted) == before_more,
		"mutating the supplied build moved the coordinator:\n    before %s\n    after  %s" % [
			before_more, _snapshot(boosted),
		])
	_expect_accepted(boosted.award_experience(BASE_AWARD), "a second boosted award of 50")
	var twice: PlayerStatValue = held.stat_totals().value_of(
		PlayerStats.EXPERIENCE_GAIN, BASE_AWARD)
	_expect(twice.ok and boosted.experience() != twice.value,
		"the later grant reached the coordinator's own award")

	print("  50 unmodified -> %s; 50 at the shipped Gain -> %s; two boosted awards -> %s" % [
		_exact(plain.experience()), _exact(expected.value), _exact(boosted.experience()),
	])
	_done("experience_gain_already_held_raises_only_the_awards_that_follow")


# --- 10. Overflow survives the advance -------------------------------------------------

func _check_overflow_survives_the_advance() -> void:
	print("")
	print("--- 10. Overflow experience is retained after the one advance")
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()
	for repeat: int in range(3):
		_expect_accepted(lifecycle.award_experience(BASE_AWARD),
			"award %d of 50 toward the overflow case" % repeat)
	_expect(lifecycle.experience() == OVERFLOW_TOTAL,
		"three awards of 50 came to %s" % _exact(lifecycle.experience()))

	_expect_accepted(_open(lifecycle, REACHED_REQUIREMENT, _shipped_cards(), ROOT_SEED),
		"opening against 100 with 150 accumulated")
	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.UTILITY)
	_expect_taken(outcome, RiftOffer.Lane.UTILITY, "taking a lane with a surplus standing")

	_expect(lifecycle.level() == EXPECTED_LEVEL_AFTER,
		"the level reached %d, not %d" % [lifecycle.level(), EXPECTED_LEVEL_AFTER])
	## EXACT: one hundred and fifty minus one hundred is precisely fifty. Exactly
	## ONE requirement was taken, which the surviving surplus is what proves —
	## two would have left nothing and reported the same level.
	_expect(lifecycle.experience() == EXPECTED_OVERFLOW,
		"the retained overflow is %s, not %s" % [
			_exact(lifecycle.experience()), _exact(EXPECTED_OVERFLOW),
		])
	_expect(lifecycle.is_completed(), "the lifecycle did not finish")
	_expect(lifecycle.frozen_requirement() == RiftLevelUpCoordinator.NO_REQUIREMENT,
		"the requirement %s is still frozen after the commit"
			% _exact(lifecycle.frozen_requirement()))

	## AND THE SURPLUS DOES NOT BUY A SECOND LEVEL, however large it is. The
	## retained reading says a further requirement is already met, and the
	## coordinator still refuses to open one — which is the whole reason this
	## foundation stops at one.
	var again: RiftExperienceReading = lifecycle.reading_for(EXPECTED_OVERFLOW)
	_expect(again.ok and again.ready,
		"the retained %s is not reported as meeting a requirement of the same size"
			% _exact(lifecycle.experience()))
	_expect_refused(_open(lifecycle, EXPECTED_OVERFLOW, _shipped_cards(), ROOT_SEED + 1),
		"opening a second offer the retained surplus would pay for")
	_expect(lifecycle.level() == EXPECTED_LEVEL_AFTER,
		"a second level was reached at %d" % lifecycle.level())

	print("  150 against 100 -> Level %d with %s retained; a second offer is still refused" % [
		lifecycle.level(), _exact(lifecycle.experience()),
	])
	_done("overflow_experience_survives_the_advance")


# --- 11. Opening below the threshold ----------------------------------------------------

func _check_opening_below_the_threshold_refuses_atomically() -> void:
	print("")
	print("--- 11. Opening below the threshold, or against no requirement, refuses atomically")
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()
	_expect_accepted(lifecycle.award_experience(BASE_AWARD), "the seeding award of 50")
	var before: String = _snapshot(lifecycle)

	var short_refusal: String = _open(
		lifecycle, REACHED_REQUIREMENT, _shipped_cards(), ROOT_SEED)
	_expect_atomic_refusal(lifecycle, before, short_refusal,
		"opening against 100 with only 50 accumulated")
	_expect(not lifecycle.is_offer_active(), "a refused open left an offer standing")
	## THE REASON IS THE ACCEPTED TRACK'S OWN MEASUREMENT, QUOTED. A refusal that
	## restated the shortfall here would be a second place for one number to be
	## computed.
	var reading: RiftExperienceReading = lifecycle.reading_for(REACHED_REQUIREMENT)
	_expect(short_refusal.contains(reading.describe()),
		"the refusal does not quote the accepted reading: %s" % short_refusal)

	## EVERY UNUSABLE REQUIREMENT, ON THE ONE ROUTE THAT TAKES ONE, with the
	## accepted validator's own reason quoted rather than restated.
	for requirement: float in [0.0, -1.0, -REACHED_REQUIREMENT, INF, -INF, NAN]:
		var refusal: String = _open(lifecycle, requirement, _shipped_cards(), ROOT_SEED)
		_expect_atomic_refusal(lifecycle, before, refusal,
			"opening against the requirement %s" % _shown(requirement))
		_expect(refusal == RiftExperienceTrack.requirement_problem(requirement),
			"the refusal of %s is not the accepted validator's own: %s" % [
				_shown(requirement), refusal,
			])
		_expect(not lifecycle.is_offer_active(),
			"the requirement %s left an offer standing" % _shown(requirement))

	## AND THE COORDINATOR IS STILL USABLE AFTERWARDS, which is what makes the
	## atomicity claim about a refusal rather than about a broken object.
	_expect_accepted(lifecycle.award_experience(BASE_AWARD),
		"an award after every refused open")
	_expect_accepted(_open(lifecycle, REACHED_REQUIREMENT, _shipped_cards(), ROOT_SEED),
		"opening once the requirement is genuinely reached")
	_expect(lifecycle.is_offer_active(), "the offer did not open after the refusals")

	print("  1 short open and 6 unusable requirements refused; the lifecycle stayed at %s"
		% before)
	_done("opening_below_the_threshold_or_against_no_requirement_refuses_atomically")


# --- 12. A composition refusal -----------------------------------------------------------

func _check_a_composition_refusal_leaves_no_offer_open() -> void:
	print("")
	print("--- 12. A composition refusal leaves no offer standing and the coordinator usable")

	## THE SUPPORT LANE REFUSES ON A REAL CONDITION RATHER THAN ON A FABRICATED
	## FAULT, AND THE CONDITION MOVED — recorded here rather than quietly edited.
	## A run that holds both shipped pairs used to leave the support lane with
	## nothing to offer. Since Foundation F3 that composes ONE FURTHER RANK of a
	## held pair instead, so the fixture below still holds both pairs — which is
	## exactly what proves holding them is no longer the cause — and the refusal
	## now comes from there being no support definition at all, which the accepted
	## composition mechanism still fails honestly on rather than inventing a
	## fallback. Nothing about this coordinator's own behaviour moved: it is still
	## handed a composition that refused, at the same lane, and must leave no
	## offer standing.
	var exhausted: RiftRunBuild = RiftRunBuild.new()
	_expect_accepted(exhausted.acquire_support(EXPECTED_SKILL, EXPECTED_SUPPORT),
			"pre-acquiring the first pair")
	_expect_accepted(exhausted.acquire_support(EXPECTED_SKILL, EXPECTED_OTHER_SUPPORT),
			"pre-acquiring the second pair")
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(
		null, exhausted, null)
	_expect_accepted(lifecycle.award_experience(REACHED_REQUIREMENT), "the seeding award of 100")
	var before: String = _snapshot(lifecycle)

	var no_supports: Array[SupportDefinition] = []
	var refusal: String = lifecycle.open_offer(
		REACHED_REQUIREMENT, SkillSupportCatalogue.skill_profiles(), no_supports,
		_shipped_cards(), ROOT_SEED)
	_expect_atomic_refusal(lifecycle, before, refusal,
		"opening with no support definition at all")
	_expect(not lifecycle.is_offer_active(), "a refused composition left an offer standing")
	_expect(lifecycle.frozen_requirement() == RiftLevelUpCoordinator.NO_REQUIREMENT,
		"a refused composition froze %s" % _exact(lifecycle.frozen_requirement()))

	## THE D1 REASON IS QUOTED, NOT RESTATED, and it names the lane that refused.
	var direct: RiftOffer = RiftOfferComposition.compose(
		SkillSupportCatalogue.skill_profiles(), no_supports,
		exhausted.acquired_supports(), _shipped_cards(), ROOT_SEED
	)
	_expect(not direct.ok, "the accepted composer accepted an empty support pool")
	_expect(refusal.contains(direct.failure_reason),
		"the refusal does not quote the composer's own reason:\n    %s\n    %s" % [
			refusal, direct.failure_reason,
		])
	_expect(refusal.contains(RiftOffer.lane_label(RiftOffer.Lane.SUPPORT)),
		"the refusal does not name the lane that refused: %s" % refusal)

	## A SECOND COMPOSITION REFUSAL FROM A DIFFERENT DIRECTION: a record set with
	## no card in one of the two passive categories. Two independent causes prove
	## the coordinator refuses on the composer's answer rather than on one
	## remembered condition.
	var one_sided: Array[PassiveCardDefinition] = []
	one_sided.append(PassiveCardCatalogue.record(EXPECTED_UTILITY_CARD))
	var narrow: RiftLevelUpCoordinator = _ready_coordinator()
	var narrow_before: String = _snapshot(narrow)
	_expect_atomic_refusal(narrow, narrow_before,
		_open(narrow, REACHED_REQUIREMENT, one_sided, ROOT_SEED),
		"opening with no Combat and Defence card in the supplied set")
	_expect(not narrow.is_offer_active(), "a one-sided record set left an offer standing")

	## AND BOTH COORDINATORS ARE STILL USABLE, so a refused open is a refusal
	## rather than a broken lifecycle.
	_expect_accepted(lifecycle.award_experience(BASE_AWARD),
		"an award after the exhausted composition")
	_expect_accepted(_open(narrow, REACHED_REQUIREMENT, _shipped_cards(), ROOT_SEED),
		"opening the narrow coordinator with the complete record set")
	_expect(narrow.is_offer_active(), "the narrow coordinator's offer did not open")

	print("  2 composition refusals, both quoted from the composer; no offer stood after either")
	_done("a_composition_refusal_leaves_no_offer_open_and_the_coordinator_usable")


# --- 13. An undeclared lane ----------------------------------------------------------------

func _check_an_undeclared_lane_leaves_the_offer_available() -> void:
	print("")
	print("--- 13. An undeclared lane refuses and leaves the standing offer available")
	var lifecycle: RiftLevelUpCoordinator = _open_coordinator()
	var before: String = _snapshot(lifecycle)

	for lane: int in [UNDECLARED_LANE, RiftOffer.UNRESOLVED_LANE, -1, 3]:
		var outcome: RiftLevelUpResult = lifecycle.choose(lane)
		_expect_refused_result(outcome, lane, "taking lane %d" % lane)
		## THE REFUSAL ECHOES THE QUESTION AND NOTHING MORE. It names the seed the
		## attempt was made against, because an offer stood to read one from.
		_expect(outcome.root_seed_known and outcome.root_seed == ROOT_SEED,
			"the refusal of lane %d names root seed %d (known %s)" % [
				lane, outcome.root_seed, str(outcome.root_seed_known),
			])
		_expect(outcome.lane == lane,
			"the refusal reports lane %d, not the requested %d" % [outcome.lane, lane])
		_expect(_snapshot(lifecycle) == before,
			"taking lane %d moved the lifecycle:\n    before %s\n    after  %s" % [
				lane, before, _snapshot(lifecycle),
			])

	## THE OFFER IS STILL TAKEABLE, WHICH IS THE HALF THAT MATTERS. A refusal
	## that quietly ended the lifecycle would satisfy every "nothing changed"
	## assertion about the build and the ledger.
	_expect(lifecycle.is_offer_active(), "the standing offer was ended by an undeclared lane")
	_expect(not lifecycle.is_completed(), "an undeclared lane finished the lifecycle")
	var legal: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect_taken(legal, RiftOffer.Lane.COMBAT_DEFENCE,
		"taking a declared lane after four undeclared refusals")
	_expect(lifecycle.level() == EXPECTED_LEVEL_AFTER,
		"the level after a legal lane is %d" % lifecycle.level())

	print("  4 undeclared lanes refused; the same offer then paid out %s" % legal.identity_line())
	_done("an_undeclared_lane_refuses_and_leaves_the_offer_available")


# --- 14. A catalogue disagreement ----------------------------------------------------------

func _check_a_catalogue_disagreement_refuses_atomically() -> void:
	print("")
	print("--- 14. A choice the transaction refuses commits neither build nor ledger")

	## THE ONE REACHABLE STAGING REFUSAL, AND IT IS REACHABLE THROUGH THIS
	## COORDINATOR'S OWN DOOR. The card record set is supplied by the caller, so
	## an offer can be composed against a record that disagrees with the canonical
	## catalogue; the accepted transaction resolves the offered ID through the
	## CANONICAL catalogue and refuses it for the category it actually derives.
	var swapped: Array[PassiveCardDefinition] = []
	swapped.append(PassiveCardDefinition.of(
		CANONICAL_UTILITY_ID, PROBE_LABEL, EXPECTED_COMBAT_STAT,
		PROBE_MAGNITUDE, PROBE_WEIGHT, true
	))
	swapped.append(PassiveCardCatalogue.record(EXPECTED_UTILITY_CARD))

	var lifecycle: RiftLevelUpCoordinator = _ready_coordinator()
	_expect_accepted(_open(lifecycle, REACHED_REQUIREMENT, swapped, ROOT_SEED),
		"opening against a record set that disagrees with the catalogue")
	var offered: PackedStringArray = lifecycle.offer_identity_for(
		RiftOffer.Lane.COMBAT_DEFENCE)
	_expect(offered.size() == 1 and StringName(offered[0]) == CANONICAL_UTILITY_ID,
		"the Combat and Defence lane offers %s" % " -> ".join(offered))
	var before: String = _snapshot(lifecycle)

	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect_refused_result(outcome, RiftOffer.Lane.COMBAT_DEFENCE,
		"taking a lane whose card the catalogue miscategorises")
	_expect(outcome.failure_reason.contains(String(CANONICAL_UTILITY_ID)),
		"the refusal does not name the card it refused: %s" % outcome.failure_reason)

	## NOTHING WAS COMMITTED, ASSERTED FIELD BY FIELD AS WELL AS BY SNAPSHOT.
	_expect(_snapshot(lifecycle) == before,
		"a refused choice moved the lifecycle:\n    before %s\n    after  %s" % [
			before, _snapshot(lifecycle),
		])
	_expect(lifecycle.level() == 1, "a refused choice advanced the level to %d" % lifecycle.level())
	_expect(lifecycle.experience() == REACHED_REQUIREMENT,
		"a refused choice moved the experience to %s" % _exact(lifecycle.experience()))
	_expect(lifecycle.run_build().is_empty(), "a refused choice committed a run build")
	_expect(lifecycle.consumption_ledger().is_empty(), "a refused choice consumed the root seed")
	_expect(lifecycle.consumption_ledger().count() == 0,
		"a refused choice recorded %d seeds" % lifecycle.consumption_ledger().count())
	_expect(not lifecycle.is_completed(), "a refused choice finished the lifecycle")
	_expect(lifecycle.is_offer_active(), "a refused choice ended the standing offer")
	_expect(lifecycle.frozen_requirement() == REACHED_REQUIREMENT,
		"a refused choice released the frozen requirement: %s"
			% _exact(lifecycle.frozen_requirement()))

	## AND THE SAME STILL-STANDING OFFER PAYS OUT A LEGAL LANE, which is the
	## strongest available statement that the refusal spent nothing: the root seed
	## was still there to spend.
	var legal: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.UTILITY)
	_expect_taken(legal, RiftOffer.Lane.UTILITY, "taking the Utility lane after the refusal")
	_expect(lifecycle.level() == EXPECTED_LEVEL_AFTER,
		"the level after the recovered choice is %d" % lifecycle.level())
	var ledger: RiftConsumptionLedger = lifecycle.consumption_ledger()
	_expect(ledger.count() == 1 and ledger.has_consumed(ROOT_SEED),
		"the recovered choice consumed %s" % ledger.describe())

	## THE ADVANCE CANNOT REFUSE AFTER A SUCCESSFUL STAGED CHOICE, AND THAT IS
	## MEASURED RATHER THAN ASSERTED. Both conditions the accepted advance can
	## refuse on are shown to be unreachable at the moment it is called: the
	## frozen requirement is one the validator accepts, and the reading against it
	## is ready — with no award possible in between, because check 4 proves the
	## boundary refuses one.
	var poised: RiftLevelUpCoordinator = _open_coordinator()
	_expect(RiftExperienceTrack.requirement_problem(poised.frozen_requirement()).is_empty(),
		"the frozen requirement is one the accepted validator refuses: %s"
			% RiftExperienceTrack.requirement_problem(poised.frozen_requirement()))
	var poised_reading: RiftExperienceReading = poised.reading_for(poised.frozen_requirement())
	_expect(poised_reading.ok and poised_reading.ready,
		"the frozen requirement is not reached while the offer stands: %s"
			% poised_reading.describe())
	_expect(RiftExperienceTrack.level_can_increment(poised.level()),
		"level %d cannot take another" % poised.level())

	print("  the transaction refused %s; nothing advanced, nothing consumed, the offer stood"
		% outcome.failure_reason)
	print("  the advance's own two refusals are unreachable while an offer stands"
		+ " — reported as unobservable, not proved")
	_done("a_catalogue_disagreement_refuses_without_advancing_or_consuming")


# --- 15. A composed offer never names a held pair --------------------------------------------

func _check_a_composed_offer_never_names_a_held_pair() -> void:
	print("")
	print("--- 15. A composed offer never names a pair this run already holds")

	## THIS IS WHY THE TRANSACTION'S STALE-SUPPORT REFUSAL IS UNREACHABLE THROUGH
	## THIS COORDINATOR, AND IT IS MEASURED RATHER THAN ARGUED. The composition is
	## asked against this run's OWN acquisition snapshot, and the accepted support
	## selector excludes every pair that snapshot holds — so the offered pair is
	## never one the run holds, and no award can change the run between the open
	## and the choice.
	var held: RiftRunBuild = RiftRunBuild.new()
	_expect_accepted(held.acquire_support(EXPECTED_SKILL, EXPECTED_SUPPORT),
		"pre-acquiring one pair into the initial build")

	var offered: Dictionary = {}
	var opened: int = 0
	var stale: int = 0
	for seed_value: int in range(SEED_SAMPLES):
		var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(
			null, held, null)
		if not lifecycle.award_experience(REACHED_REQUIREMENT).is_empty():
			continue
		if not _open(lifecycle, REACHED_REQUIREMENT, _shipped_cards(), seed_value).is_empty():
			continue
		opened += 1
		var identity: PackedStringArray = lifecycle.offer_identity_for(RiftOffer.Lane.SUPPORT)
		offered[" -> ".join(identity)] = true
		if identity.size() == 2 and lifecycle.run_build().has_support(
				StringName(identity[0]), StringName(identity[1])):
			stale += 1

	## THE CORPUS MUST HAVE MEASURED SOMETHING. A loop that opened nothing would
	## report zero stale offers and prove nothing whatsoever.
	_expect(opened == SEED_SAMPLES,
		"only %d of %d seeds opened an offer, so the measurement is incomplete" % [
			opened, SEED_SAMPLES,
		])
	_expect(stale == 0,
		"%d of %d offers named a pair the run already held" % [stale, opened])
	## AND THE ONE PAIR THAT IS OFFERED IS THE OTHER ONE, so the exclusion is a
	## real exclusion rather than an empty pool answering nothing.
	_expect(offered.size() == 1,
		"the corpus offered %d distinct pairs: %s" % [offered.size(), str(offered.keys())])
	_expect(offered.has("%s -> %s" % [EXPECTED_SKILL, EXPECTED_OTHER_SUPPORT]),
		"the corpus did not offer the unheld pair: %s" % str(offered.keys()))
	_expect(not offered.has("%s -> %s" % [EXPECTED_SKILL, EXPECTED_SUPPORT]),
		"the corpus offered the held pair")

	## THE POSITIVE CONTROL: with nothing held, the same seeds DO offer that pair,
	## so the exclusion above is caused by what the run holds rather than by the
	## seeds happening to agree.
	var unheld: RiftLevelUpCoordinator = _ready_coordinator()
	_expect_accepted(_open(unheld, REACHED_REQUIREMENT, _shipped_cards(), ROOT_SEED),
		"opening with nothing held")
	var control: PackedStringArray = unheld.offer_identity_for(RiftOffer.Lane.SUPPORT)
	_expect(control.size() == 2 and StringName(control[1]) == EXPECTED_SUPPORT,
		"with nothing held, root seed 0 offers %s" % " -> ".join(control))

	print("  %d offers over %d seeds with one pair held: %d stale, and only %s offered" % [
		opened, SEED_SAMPLES, stale, str(offered.keys()),
	])
	_done("a_composed_offer_never_names_a_pair_this_run_already_holds")


# --- 16. A finished coordinator ---------------------------------------------------------------

func _check_a_finished_coordinator_refuses_everything() -> void:
	print("")
	print("--- 16. A finished coordinator refuses every operation without mutation")
	var lifecycle: RiftLevelUpCoordinator = _open_coordinator()
	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect_taken(outcome, RiftOffer.Lane.COMBAT_DEFENCE, "the one level-up")
	var before: String = _snapshot(lifecycle)

	## THE TWO CONDITIONS CANNOT BOTH HOLD, which is what makes the order of the
	## two award gates unobservable and is asserted rather than reasoned about.
	_expect(lifecycle.is_completed() and not lifecycle.is_offer_active(),
		"a finished coordinator still holds an offer: %s" % before)

	_expect_atomic_refusal(lifecycle, before,
		lifecycle.award_experience(BASE_AWARD), "an award after the level-up")
	_expect_atomic_refusal(lifecycle, before,
		_open(lifecycle, REACHED_REQUIREMENT, _shipped_cards(), ROOT_SEED),
		"reopening the spent offer")
	_expect_atomic_refusal(lifecycle, before,
		_open(lifecycle, REACHED_REQUIREMENT, _shipped_cards(), ROOT_SEED + 1),
		"opening a fresh offer after the level-up")

	for lane: int in [RiftOffer.Lane.SUPPORT, RiftOffer.Lane.COMBAT_DEFENCE,
			RiftOffer.Lane.UTILITY, UNDECLARED_LANE]:
		var refused: RiftLevelUpResult = lifecycle.choose(lane)
		_expect_refused_result(refused, lane, "taking lane %d after the level-up" % lane)
		## NO SEED IS CLAIMED, because there is no standing offer to read one
		## from — the one case the seedless refusal exists for.
		_expect(not refused.root_seed_known,
			"a refusal after the level-up claims root seed %d" % refused.root_seed)
		_expect(_snapshot(lifecycle) == before,
			"taking lane %d after the level-up moved the lifecycle:\n    before %s\n    after  %s"
				% [lane, before, _snapshot(lifecycle)])

	## THE RETAINED STATE IS STILL THERE AND STILL CORRECT, which is the half a
	## "nothing changed" assertion cannot make on its own.
	_expect(lifecycle.level() == EXPECTED_LEVEL_AFTER,
		"the finished level is %d" % lifecycle.level())
	_expect(lifecycle.run_build().acquisitions_for(EXPECTED_COMBAT_CARD) == 1,
		"the finished run build holds %d of the chosen card"
			% lifecycle.run_build().acquisitions_for(EXPECTED_COMBAT_CARD))
	_expect(lifecycle.consumption_ledger().count() == 1,
		"the finished ledger holds %d seeds" % lifecycle.consumption_ledger().count())
	_expect(lifecycle.offer_lanes().is_empty(),
		"a finished coordinator still reports %d lanes" % lifecycle.offer_lanes().size())

	print("  7 operations refused after the level-up; the lifecycle is unmoved at %s" % before)
	_done("a_finished_coordinator_refuses_every_operation_without_mutation")


# --- 17. Independence of everything supplied and everything returned -----------------------------

func _check_supplied_state_and_returned_copies_are_independent() -> void:
	print("")
	print("--- 17. Supplied state and every returned copy are independent")

	var track: RiftExperienceTrack = RiftExperienceTrack.new()
	_expect_accepted(track.award(REACHED_REQUIREMENT, PlayerStatTotals.new()),
		"seeding the supplied track")
	var build: RiftRunBuild = RiftRunBuild.new()
	_expect_accepted(build.acquire_support(EXPECTED_SKILL, EXPECTED_SUPPORT),
		"seeding the supplied build")
	var ledger: RiftConsumptionLedger = RiftConsumptionLedger.new()
	_expect(ledger.consume(ROOT_SEED - 1), "seeding the supplied ledger")

	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.with_state(
		track, build, ledger)
	_expect(lifecycle.experience() == REACHED_REQUIREMENT,
		"the supplied track was not adopted: %s" % _exact(lifecycle.experience()))
	_expect(lifecycle.run_build().has_support(EXPECTED_SKILL, EXPECTED_SUPPORT),
		"the supplied build was not adopted")
	_expect(lifecycle.consumption_ledger().has_consumed(ROOT_SEED - 1),
		"the supplied ledger was not adopted")
	var before: String = _snapshot(lifecycle)

	## MUTATING WHAT WAS HANDED IN CANNOT REACH THE COORDINATOR, and each mutation
	## is separately proved to BE a mutation, because "nothing moved" is worthless
	## if nothing happened.
	_expect_accepted(track.award(BASE_AWARD, PlayerStatTotals.new()),
		"mutating the supplied track afterwards")
	_expect_accepted(build.acquire_support(EXPECTED_SKILL, EXPECTED_OTHER_SUPPORT),
		"mutating the supplied build afterwards")
	_expect(ledger.consume(ROOT_SEED), "mutating the supplied ledger afterwards")
	_expect(track.progress() != REACHED_REQUIREMENT and build.support_count() == 2
			and ledger.count() == 2,
		"the supplied values were not actually mutated")
	_expect(_snapshot(lifecycle) == before,
		"mutating the supplied values moved the coordinator:\n    before %s\n    after  %s" % [
			before, _snapshot(lifecycle),
		])

	## AND EVERY RETURNED COPY IS INDEPENDENT IN BOTH DIRECTIONS.
	var handed_build: RiftRunBuild = lifecycle.run_build()
	var handed_ledger: RiftConsumptionLedger = lifecycle.consumption_ledger()
	_expect(handed_build != lifecycle.run_build(),
		"two calls to run_build() answered one object")
	_expect(handed_ledger != lifecycle.consumption_ledger(),
		"two calls to consumption_ledger() answered one object")
	_expect_accepted(handed_build.acquire_support(EXPECTED_SKILL, EXPECTED_OTHER_SUPPORT),
		"mutating a returned run build")
	_expect(handed_ledger.consume(ROOT_SEED), "mutating a returned ledger")
	_expect(_snapshot(lifecycle) == before,
		"mutating a returned copy moved the coordinator:\n    before %s\n    after  %s" % [
			before, _snapshot(lifecycle),
		])

	## THE STANDING OFFER'S OWN READINGS ARE COPIES TOO. Reordering the lane array
	## a caller was handed must not reorder the contract.
	_expect_accepted(_open(lifecycle, REACHED_REQUIREMENT, _shipped_cards(), ROOT_SEED),
		"opening an offer on the supplied-state coordinator")
	var lanes: Array[int] = lifecycle.offer_lanes()
	lanes.reverse()
	var identity: PackedStringArray = lifecycle.offer_identity_for(RiftOffer.Lane.SUPPORT)
	identity.append("zz_injected")
	_expect(lifecycle.offer_lanes()[0] == RiftOffer.LANE_ORDER[0],
		"reversing a returned lane array reordered the standing offer")
	_expect(lifecycle.offer_identity_for(RiftOffer.Lane.SUPPORT).size() == 2,
		"appending to a returned identity changed the standing offer")

	## AND THE RESULT A CHOICE RETURNS CARRIES NO LIVE STATE AT ALL — no build, no
	## ledger, no track — which is exactly why this foundation returns its own
	## result rather than the transaction's.
	var outcome: RiftLevelUpResult = lifecycle.choose(RiftOffer.Lane.COMBAT_DEFENCE)
	_expect_taken(outcome, RiftOffer.Lane.COMBAT_DEFENCE, "the choice on supplied state")
	var carried: PackedStringArray = _fields_of(outcome)
	var leaked: PackedStringArray = PackedStringArray()
	for field: String in carried:
		if outcome.get(field) is Object:
			leaked.append(field)
	_expect(leaked.is_empty(), "the result carries the live object field(s) %s"
		% ", ".join(leaked))
	## AND THE GRANTED IDENTITY IS A COPY, PROVED IN BOTH DIRECTIONS AGAINST THE
	## ENGINE BEHAVIOUR THAT MAKES THE ACCESSOR NECESSARY. A packed array read
	## out of a script VARIABLE aliases rather than copying, which is the
	## opposite of what it is usually believed to do — so the probe below is what
	## turns "the accessor duplicates" from a claim into a measurement, and what
	## stops the guard from being decorative.
	var probe: AliasProbe = AliasProbe.new()
	probe.carried = PackedStringArray(["zz_one"])
	var aliased: PackedStringArray = probe.carried
	aliased.append("zz_two")
	_expect(probe.carried.size() == 2,
		"a packed array read out of a script variable no longer aliases,"
			+ " so the accessor below proves nothing")
	var granted: PackedStringArray = outcome.granted_identity()
	granted.append("zz_injected")
	_expect(outcome.granted_identity().size() == 1,
		"appending to a read granted identity changed the result: %s"
			% str(outcome.granted_identity()))
	_expect(outcome.granted_identity() != granted,
		"the accessor answered the very array that was appended to")
	_expect(outcome.problem().is_empty(),
		"the result stopped being coherent after a caller read it: %s" % outcome.problem())

	print("  3 supplied values and 5 returned copies proved independent in both directions")
	_done("supplied_state_and_every_returned_copy_are_independent")


# --- 18. Generic, ambient-free and unwired ----------------------------------------------------

func _check_the_coordinator_is_generic_and_unwired() -> void:
	print("")
	print("--- 18. The coordinator names nothing concrete, reads nothing ambient, is unwired")

	var scanned: int = 0
	var forbidden_total: int = 0
	var ambient_total: int = 0
	var deferred_total: int = 0
	var operator_total: int = 0
	var literal_total: int = 0
	for path: String in E2_FILES:
		var raw: String = FileAccess.get_file_as_string(path)
		_expect(not raw.is_empty(), "%s could not be read" % path.get_file())
		scanned += 1
		var found: PackedStringArray = PackedStringArray()
		for token: String in FORBIDDEN_TOKENS:
			if raw.contains(token):
				found.append(token)
		forbidden_total += found.size()
		_expect(found.is_empty(),
			"%s names the concrete token(s) %s" % [path.get_file(), ", ".join(found)])

		var ambient: PackedStringArray = PackedStringArray()
		for token: String in AMBIENT_TOKENS:
			if raw.contains(token):
				ambient.append(token)
		ambient_total += ambient.size()
		_expect(ambient.is_empty(),
			"%s reads the ambient state %s" % [path.get_file(), ", ".join(ambient)])

		var code: String = _code_only(raw)
		var permitted: Array = _permitted_deferred_tokens(path)
		var deferred: PackedStringArray = PackedStringArray()
		for token: String in DEFERRED_MEMBER_TOKENS:
			if permitted.has(token):
				continue
			if _names_deferred_member(code, token):
				deferred.append(token)
		## A SCOPED PERMIT (D-313) HOLDS ONLY INSIDE ITS FUNCTIONS.
		for scope: Array in PERMITTED_DEFERRED_SCOPES:
			if String(scope[0]) == path \
					and _names_deferred_member(_code_outside(code, scope[2]), String(scope[1])):
				deferred.append("%s outside %s" % [String(scope[1]), ", ".join(scope[2])])
		deferred_total += deferred.size()
		## THE PERMISSION IS EARNED INSIDE THE SAME ASSERTION (D-260), so the count
		## does not move and a permitted token the file stopped naming still fails.
		var unearned_permits: PackedStringArray = PackedStringArray()
		for token: String in permitted:
			if not _names_deferred_member(code, token):
				unearned_permits.append(token)
		_expect(deferred.is_empty() and unearned_permits.is_empty(),
			"%s names the deferred member token(s) [%s] or no longer names its permitted token(s) [%s]" % [
				path.get_file(), ", ".join(deferred), ", ".join(unearned_permits),
			])

		## IT PERFORMS NO ARITHMETIC AT ALL. Every percentage, every threshold
		## subtraction and every count belongs to a foundation below this one, so
		## the source multiplies nothing, divides nothing and adds nothing — which
		## is the strongest available form of "it restates no arithmetic".
		var operators: PackedStringArray = PackedStringArray()
		for token: String in FORBIDDEN_OPERATORS:
			if code.contains(token):
				operators.append(token)
		operator_total += operators.size()
		_expect(operators.is_empty(),
			"%s performs the arithmetic %s" % [path.get_file(), ", ".join(operators)])

		## AND THE ONLY FLOATING-POINT LITERAL IS ZERO. A level curve, an
		## experience value or a cap would arrive as exactly one of these while
		## naming nothing forbidden at all.
		var strays: PackedStringArray = PackedStringArray()
		for literal: String in _float_literals(code):
			if literal != PERMITTED_FLOAT_LITERAL:
				strays.append(literal)
		literal_total += strays.size()
		_expect(strays.is_empty(),
			"%s carries the floating-point literal(s) %s" % [
				path.get_file(), ", ".join(strays),
			])

	_expect(scanned == E2_FILES.size(),
		"%d of %d E2 files were scanned" % [scanned, E2_FILES.size()])

	## EVERY SCAN IS PROVED CAPABLE OF FAILING, by finding its own tokens where
	## they legitimately live: in this file. A scan that can only ever report zero
	## is not a guard.
	var self_source: String = FileAccess.get_file_as_string(
		"res://tests/rift_level_up_coordinator_verification.gd")
	var found_here: int = 0
	for token: String in FORBIDDEN_TOKENS:
		if self_source.contains(token):
			found_here += 1
	_expect(found_here > 20,
		"the forbidden-token scan found only %d of its own tokens in this file" % found_here)

	## AND THE WORD-BOUNDARY MATCHER IS PROVED IN BOTH DIRECTIONS, on the exact
	## pairs that make it necessary here: `xp` must still catch a member named for
	## a deferred concept and must not fire on the two ordinary words both E2
	## files use in code.
	_expect(_names_deferred_member("func award_xp() -> void:", "xp"),
		"the word matcher no longer catches a member named for a deferred system")
	_expect(not _names_deferred_member("must expose no granted identity", "xp"),
		"the word matcher fires on the sentence that makes the claim")
	_expect(not _names_deferred_member("the accumulated experience", "xp"),
		"the word matcher fires on this foundation's own vocabulary")
	_expect(_names_deferred_member("var level_table: Array = []", "table"),
		"the word matcher no longer catches a member named for the deferred curve")
	_expect(not _names_deferred_member("could no longer be representable", "table"),
		"the word matcher fires on an ordinary word containing a token")

	## AN ALLOWLIST, NOT ONLY A DENYLIST, AND PER FILE. The token list above can
	## only refuse names somebody remembered to add; this asks the ENGINE which
	## project classes exist and requires each file to name none of them but the
	## ones written beside its own path.
	var all_classes: PackedStringArray = PackedStringArray()
	for entry: Dictionary in ProjectSettings.get_global_class_list():
		var class_id: String = String(entry.get("class", ""))
		if not class_id.is_empty():
			all_classes.append(class_id)
	_expect(all_classes.size() > 20,
		"only %d project classes were enumerated; the allowlist may be inert"
			% all_classes.size())
	for row: Array in AUTHORIZED_CLASSES:
		var path: String = String(row[0])
		var granted: Array = row[1]
		var raw: String = FileAccess.get_file_as_string(path)
		var outside: PackedStringArray = PackedStringArray()
		for class_id: String in all_classes:
			if granted.has(class_id):
				continue
			if raw.contains(class_id):
				outside.append(class_id)
		_expect(outside.is_empty(),
			"%s names unauthorized project class(es): %s" % [
				path.get_file(), ", ".join(outside),
			])
		## THE GRANT IS EARNED. A file granted a class it no longer names turns
		## the exemption into a claim about nothing while still passing.
		var unearned: PackedStringArray = PackedStringArray()
		for class_id: String in granted:
			if not raw.contains(class_id):
				unearned.append(class_id)
		_expect(unearned.is_empty(),
			"%s is granted but does not name: %s" % [path.get_file(), ", ".join(unearned)])

	## THE RESULT TYPE CALLS NEITHER THE COMPOSER NOR THE TRANSACTION, AND THE
	## COORDINATOR CALLS BOTH — so the allowlist above cannot be passing merely
	## by finding nothing.
	var result_raw: String = FileAccess.get_file_as_string(RESULT_FILE)
	var coordinator_raw: String = FileAccess.get_file_as_string(COORDINATOR_FILE)
	_expect(not result_raw.contains("RiftOfferComposition"),
		"the result type names the composition mechanism")
	_expect(not result_raw.contains("RiftLevelUpCoordinator"),
		"the result type names the coordinator")
	_expect(not result_raw.contains("RiftOfferChoice.choose"),
		"the result type calls the choice transaction")
	_expect(coordinator_raw.contains("RiftOfferComposition.compose"),
		"the coordinator does not call the accepted composer")
	_expect(coordinator_raw.contains("RiftOfferChoice.choose"),
		"the coordinator does not call the accepted choice transaction")
	_expect(coordinator_raw.contains("advance_one_level"),
		"the coordinator does not call the accepted single advance")
	_expect(not coordinator_raw.contains("PassiveCardCatalogue"),
		"the coordinator resolves card ids itself instead of leaving that to the transaction")

	## THE SIGNATURE AND FIELD PINS. A second offer, a level curve, a support
	## fallback or a persistence step arrives as an extra method with a plausible
	## name rather than as a forbidden token — and an argument that could carry
	## content arrives inside an existing one.
	_expect(", ".join(_signatures_of(COORDINATOR_FILE))
			== ", ".join(EXPECTED_COORDINATOR_SIGNATURES),
		"the coordinator declares: %s" % ", ".join(_signatures_of(COORDINATOR_FILE)))
	_expect(", ".join(_signatures_of(RESULT_FILE)) == ", ".join(EXPECTED_RESULT_SIGNATURES),
		"the result declares: %s" % ", ".join(_signatures_of(RESULT_FILE)))

	var coordinator_fields: PackedStringArray = _fields_of(RiftLevelUpCoordinator.new())
	_expect(", ".join(coordinator_fields) == ", ".join(EXPECTED_COORDINATOR_FIELDS),
		"the coordinator carries the fields: %s" % ", ".join(coordinator_fields))
	var exposed: PackedStringArray = PackedStringArray()
	for field: String in coordinator_fields:
		if not field.begins_with("_"):
			exposed.append(field)
	_expect(exposed.is_empty(),
		"the coordinator exposes the field(s) %s directly" % ", ".join(exposed))
	var result_fields: PackedStringArray = _fields_of(RiftLevelUpResult.new())
	_expect(", ".join(result_fields) == ", ".join(EXPECTED_RESULT_FIELDS),
		"the result carries the fields: %s" % ", ".join(result_fields))

	## NOTHING BUT AN AUTHORIZED READER REFERENCES IT. There is no experience
	## source, no level curve, no offer presentation, no scene and no persistence;
	## the only files that may name either class are the two themselves and the
	## readers in `AUTHORIZED_READERS`, each granted exactly the classes beside its
	## own path — and nothing that runs calls either reader.
	var project_files: int = 0
	var referenced: PackedStringArray = PackedStringArray()
	for root: String in SCANNED_ROOTS:
		for path: String in _files_under(root, [".gd", ".tscn", ".tres"]):
			if E2_FILES.has(path):
				continue
			project_files += 1
			var source: String = FileAccess.get_file_as_string(path)
			for name: String in E2_CLASSES:
				if source.contains(name) and not _reader_may_name(path, name):
					referenced.append("%s names %s" % [path.get_file(), name])
	var settings: String = FileAccess.get_file_as_string(PROJECT_SETTINGS_FILE)
	for name: String in E2_CLASSES:
		if settings.contains(name):
			referenced.append("project.godot names %s" % name)
	_expect(referenced.is_empty(),
		"Foundation E2 is referenced by code that runs: %s" % ", ".join(referenced))
	_expect(project_files > 100,
		"only %d project files were scanned, so the scan proves nothing" % project_files)
	_expect(_files_under("res://addons", [".gd"]).size() > 0,
		"the addons root was scanned and held no script, so widening the scan proved nothing")
	_expect(not settings.contains("[autoload]"),
		"project.godot declares an [autoload] section")

	## `scripts/levels/` HOLDS EXACTLY WHAT IT SHOULD. A scratch probe left
	## behind is a project file nobody meant to ship, and every scan above that
	## filters on a known path is blind to it. Since Foundation G4 (D-269) that is
	## E2's two scripts and G4's two — the same single assertion, widened by
	## exactly the two files that decision added.
	var level_scripts: PackedStringArray = _files_under("res://scripts/levels", [".gd"])
	level_scripts.sort()
	var expected_scripts: PackedStringArray = PackedStringArray(E2_FILES + RUN_LEVEL_FILES)
	expected_scripts.sort()
	_expect(", ".join(level_scripts) == ", ".join(expected_scripts),
		"scripts/levels/ holds: %s" % ", ".join(level_scripts))

	## THE SEVEN EXEMPTIONS THE ACCEPTED SUITES GRANT THESE FILES ARE VISIBLE AND
	## EARNED. Each suite proves nothing names its classes except an authorized
	## reader; if a file stopped naming a class it was granted, the exemption
	## would quietly become a claim about nothing while still passing.
	var authorized_rows: int = 0
	for row: Array in AUTHORIZING_SUITES:
		var suite_source: String = FileAccess.get_file_as_string(String(row[0]))
		var label: String = String(row[1])
		var granted_paths: Array = row[2]
		var granted_classes: Array = row[3]
		_expect(not suite_source.is_empty(),
			"the Foundation %s suite could not be read" % label)
		var listed: int = 0
		for path: String in granted_paths:
			if suite_source.contains(path):
				listed += 1
		_expect(listed == granted_paths.size(),
			"the Foundation %s suite authorizes %d of the %d E2 scripts it must" % [
				label, listed, granted_paths.size(),
			])
		var unearned: PackedStringArray = PackedStringArray()
		for path: String in granted_paths:
			var source: String = FileAccess.get_file_as_string(path)
			for class_id: String in granted_classes:
				if not source.contains(class_id):
					unearned.append("%s does not name %s" % [path.get_file(), class_id])
		_expect(unearned.is_empty(),
			"the Foundation %s exemption is unearned: %s" % [label, ", ".join(unearned)])
		authorized_rows += 1
	_expect(authorized_rows == AUTHORIZING_SUITES.size(),
		"%d of %d authorizing suites were read" % [
			authorized_rows, AUTHORIZING_SUITES.size(),
		])

	## THE ONE ACCEPTED SUITE THAT WAS DELIBERATELY NOT EDITED, ASSERTED IN THE
	## NEGATIVE DIRECTION. This coordinator forwards a stat-totals snapshot
	## without naming its type, so Foundation C1's allowlist needed no row — and
	## if either file ever names a C1 class, this turns red rather than that
	## suite silently doing so.
	for path: String in E2_FILES:
		var source: String = FileAccess.get_file_as_string(path)
		for class_id: String in ["PlayerStats", "PlayerStatTotals", "PlayerStatValue",
				"PlayerStatDefinition"]:
			_expect(not source.contains(class_id),
				"%s names the Foundation C1 class %s" % [path.get_file(), class_id])

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

	print("  %d scripts scanned raw: %d forbidden tokens, %d ambient reads, %d deferred members,"
		% [scanned, forbidden_total, ambient_total, deferred_total]
		+ " %d arithmetic operators, %d stray float literals" % [operator_total, literal_total])
	print("  %d method signatures and %d fields pinned; %d project files name no E2 class outside the %d reader grants" % [
		EXPECTED_COORDINATOR_SIGNATURES.size() + EXPECTED_RESULT_SIGNATURES.size(),
		coordinator_fields.size() + result_fields.size(), project_files,
		AUTHORIZED_READERS.size(),
	])
	var distinct_suites: Dictionary = {}
	for row: Array in AUTHORIZING_SUITES:
		distinct_suites[String(row[0])] = true
	print("  %d grants in %d accepted suites authorize these two files by path and by class"
		% [AUTHORIZING_SUITES.size(), distinct_suites.size()])
	print("  %d refusals were driven across this suite" % _refusals)
	_done("the_coordinator_is_generic_reads_nothing_ambient_and_is_unwired")


## A MINIMAL OBJECT CARRYING A PACKED ARRAY IN A SCRIPT VARIABLE, and nothing
## else. It exists so that the engine behaviour the result type's accessor guards
## against can be DRIVEN rather than described — and driven on a purpose-built
## probe rather than on an accepted foundation's own file, which is exactly why it
## kept working when that file WAS corrected under D-249. A proof of a guard's
## necessity must not depend on the defect still existing somewhere.
class AliasProbe extends RefCounted:
	var carried: PackedStringArray = PackedStringArray()


# --- Fixtures and helpers ---------------------------------------------------------------
#
# Every fabricated record below is test data only: it is in no catalogue, no
# scene and no `.tres`, and it is not canon. The `Zz ` label prefix is so that
# none of them can be mistaken for content.

## Finds the shipped Experience Gain card BY STAT rather than by id, so this
## suite does not hard-code which record grants it.
func _load_shipped_experience_gain() -> bool:
	for record: PassiveCardDefinition in PassiveCardCatalogue.records():
		if record.stat_id == PlayerStats.EXPERIENCE_GAIN:
			_gain_card = record.card_id
			_gain_magnitude = record.magnitude
			return true
	return false


## The complete shipped card record set, rebuilt on every call so no check can
## alter what a later one is handed.
func _shipped_cards() -> Array[PassiveCardDefinition]:
	return PassiveCardCatalogue.records()


## A coordinator with the requirement reached and no offer standing.
func _ready_coordinator() -> RiftLevelUpCoordinator:
	var lifecycle: RiftLevelUpCoordinator = RiftLevelUpCoordinator.new()
	_expect(lifecycle.award_experience(BASE_AWARD).is_empty(),
		"a fixture's first award of 50 was refused")
	_expect(lifecycle.award_experience(BASE_AWARD).is_empty(),
		"a fixture's second award of 50 was refused")
	return lifecycle


## A coordinator with the one offer standing at root seed 0.
func _open_coordinator() -> RiftLevelUpCoordinator:
	var lifecycle: RiftLevelUpCoordinator = _ready_coordinator()
	_expect(_open(lifecycle, REACHED_REQUIREMENT, _shipped_cards(), ROOT_SEED).is_empty(),
		"a fixture's offer did not open")
	return lifecycle


## Opens an offer with the shipped Skill profiles and support definitions and the
## supplied card record set. One place, so no check can differ from another about
## what "the shipped inputs" are.
func _open(
	lifecycle: RiftLevelUpCoordinator,
	requirement: float,
	cards: Array[PassiveCardDefinition],
	root_seed: int
) -> String:
	return lifecycle.open_offer(
		requirement,
		SkillSupportCatalogue.skill_profiles(),
		SkillSupportCatalogue.support_definitions(),
		cards, root_seed
	)


## The offer a standing coordinator describes, read from its own presentation so
## a comparison against the accepted composer's is a comparison of two
## derivations rather than of two formatters.
func _offer_line(lifecycle: RiftLevelUpCoordinator) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for lane: int in lifecycle.offer_lanes():
		parts.append("%s: %s" % [
			RiftOffer.lane_label(lane),
			" -> ".join(lifecycle.offer_identity_for(lane)),
		])
	return "root seed %d [%s] — %s" % [
		lifecycle.offer_root_seed(), _seed_line(lifecycle), "; ".join(parts),
	]


func _seed_line(lifecycle: RiftLevelUpCoordinator) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for lane: int in lifecycle.offer_lanes():
		parts.append("%s %d" % [
			RiftOffer.lane_label(lane),
			RiftOfferComposition.lane_seed_for(lifecycle.offer_root_seed(), lane),
		])
	return ", ".join(parts)


# --- Assertions ---------------------------------------------------------------------------

func _expect_accepted(refusal: String, described: String) -> void:
	_expect(refusal.is_empty(), "%s was refused: %s" % [described, refusal])


## One refusal, counted, and checked for the property every refusal owes: a
## stated reason rather than merely a non-empty string.
func _expect_refused(refusal: String, described: String) -> void:
	_refusals += 1
	_expect(not refusal.strip_edges().is_empty(), "%s was accepted" % described)


## A refusal that also left the WHOLE lifecycle exactly as it was. The snapshot
## is complete on purpose: a refusal that consumed a seed without advancing is
## caught by the same comparison that catches one which did both.
func _expect_atomic_refusal(
	lifecycle: RiftLevelUpCoordinator, before: String, refusal: String, described: String
) -> void:
	_expect_refused(refusal, described)
	_expect(_snapshot(lifecycle) == before,
		"the refusal of %s changed the lifecycle:\n    before %s\n    after  %s" % [
			described, before, _snapshot(lifecycle),
		])


## A refused choice, counted, and checked for every property a refused result
## owes: a reason, no granted identity, the requested lane, and coherence in its
## own right.
func _expect_refused_result(
	outcome: RiftLevelUpResult, requested_lane: int, described: String
) -> void:
	_refusals += 1
	_expect(not outcome.ok, "%s was accepted" % described)
	_expect(not outcome.failure_reason.strip_edges().is_empty(),
		"%s was refused with no stated reason" % described)
	_expect(outcome.granted_identity().is_empty(),
		"%s was refused and still granted %s" % [described, outcome.identity_line()])
	_expect(outcome.lane == requested_lane,
		"%s reports lane %d, not the requested %d" % [
			described, outcome.lane, requested_lane,
		])
	_expect(outcome.problem().is_empty(),
		"%s produced an incoherent refusal: %s" % [described, outcome.problem()])


## A successful choice, and every property a success owes.
func _expect_taken(outcome: RiftLevelUpResult, lane: int, described: String) -> void:
	_expect(outcome.ok, "%s was refused: %s" % [described, outcome.failure_reason])
	_expect(outcome.problem().is_empty(),
		"%s produced an incoherent result: %s" % [described, outcome.problem()])
	_expect(outcome.failure_reason.is_empty(),
		"%s succeeded and still stated: %s" % [described, outcome.failure_reason])
	_expect(outcome.root_seed_known and outcome.root_seed == ROOT_SEED,
		"%s spent root seed %d (known %s)" % [
			described, outcome.root_seed, str(outcome.root_seed_known),
		])
	_expect(outcome.lane == lane, "%s reports lane %d, not %d" % [described, outcome.lane, lane])


## What every one of the three lanes owes after it is taken: the level advanced by
## exactly one, the offer released, the requirement released, the lifecycle
## finished, and the one root seed spent exactly once.
func _expect_finished_at_level_two(
	lifecycle: RiftLevelUpCoordinator, described: String
) -> void:
	_expect(lifecycle.level() == EXPECTED_LEVEL_AFTER,
		"%s reached level %d, not %d" % [
			described, lifecycle.level(), EXPECTED_LEVEL_AFTER,
		])
	_expect(lifecycle.experience() == 0.0,
		"%s left %s experience of an exactly met requirement" % [
			described, _exact(lifecycle.experience()),
		])
	_expect(lifecycle.is_completed(), "%s did not finish the lifecycle" % described)
	_expect(not lifecycle.is_offer_active(), "%s left the offer standing" % described)
	_expect(lifecycle.frozen_requirement() == RiftLevelUpCoordinator.NO_REQUIREMENT,
		"%s left %s frozen" % [described, _exact(lifecycle.frozen_requirement())])
	var ledger: RiftConsumptionLedger = lifecycle.consumption_ledger()
	_expect(ledger.count() == 1, "%s consumed %d seeds" % [described, ledger.count()])
	_expect(ledger.has_consumed(ROOT_SEED),
		"%s did not consume the root seed: %s" % [described, ledger.describe()])
	var spent: PackedInt64Array = ledger.consumed_seeds()
	_expect(spent.size() == 1 and spent[0] == ROOT_SEED,
		"%s recorded the seeds %s" % [described, str(spent)])


## What a passive lane owes: exactly one acquisition of exactly its own card, its
## exact canonical magnitude on exactly its own stat, one contribution, and
## nothing at all on the other lane's stat or in the support record.
func _expect_only_this_passive(
	build: RiftRunBuild,
	card_id: StringName,
	stat_id: StringName,
	magnitude: float,
	other_stat: StringName,
	described: String
) -> void:
	_expect(build.acquisitions_for(card_id) == 1,
		"%s recorded %d acquisitions of %s" % [
			described, build.acquisitions_for(card_id), card_id,
		])
	_expect(build.passive_acquisitions() == 1,
		"%s recorded %d passive acquisitions" % [described, build.passive_acquisitions()])
	## `==` AGAINST THE TYPED MAGNITUDE, not a tolerance: one contribution of a
	## card's own normalized magnitude is bit-identical to the literal that
	## record was built from, and a tolerance is exactly what would hide a second
	## contribution of a very small one.
	_expect(build.total_for(stat_id) == magnitude,
		"%s totalled %s on %s, not %s" % [
			described, _exact(build.total_for(stat_id)), stat_id, _exact(magnitude),
		])
	_expect(build.contribution_count_for(stat_id) == 1,
		"%s made %d contributions to %s" % [
			described, build.contribution_count_for(stat_id), stat_id,
		])
	_expect(build.total_for(other_stat) == 0.0,
		"%s moved the other lane's stat %s to %s" % [
			described, other_stat, _exact(build.total_for(other_stat)),
		])
	_expect(build.support_count() == 0,
		"%s acquired %d support pairs" % [described, build.support_count()])
	_expect(build.stat_totals().size() == 1,
		"%s moved %d stats" % [described, build.stat_totals().size()])


# --- Formatting --------------------------------------------------------------------------

## The COMPLETE lifecycle as one line. Every atomicity claim in this suite is a
## comparison of two of these, which is why it carries the level, the experience
## to seventeen significant digits, both flags, the offer's whole identity, the
## frozen requirement, and both retained values rather than only the field the
## operation under test was about.
func _snapshot(lifecycle: RiftLevelUpCoordinator) -> String:
	if lifecycle == null:
		return "no coordinator"
	var lanes: PackedStringArray = PackedStringArray()
	for lane: int in lifecycle.offer_lanes():
		lanes.append("%d:%s" % [lane, " -> ".join(lifecycle.offer_identity_for(lane))])
	return ("level=%d experience=%s finished=%s offer=%s seed=%d requirement=%s"
		+ " lanes=[%s] | %s | %s") % [
			lifecycle.level(), _exact(lifecycle.experience()),
			str(lifecycle.is_completed()), str(lifecycle.is_offer_active()),
			lifecycle.offer_root_seed(), _exact(lifecycle.frozen_requirement()),
			", ".join(lanes),
			lifecycle.run_build().describe(), lifecycle.consumption_ledger().describe(),
		]


## Seventeen decimal places, which is more than the seventeen significant digits
## it takes to separate any two distinct doubles in this lifecycle's range.
func _exact(value: float) -> String:
	return String.num(value, 17)


## The compact form, for values ordinary printing renders as "0.0" or as three
## hundred digits.
func _shown(value: float) -> String:
	return String.num_scientific(value)


## Every line that is not a whole-line comment. See `DEFERRED_MEMBER_TOKENS` for
## why exactly this treatment exists, and `FORBIDDEN_TOKENS` for why the
## concrete-name scan deliberately does NOT get it.
func _code_only(source: String) -> String:
	var out: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		out.append(line)
	return "\n".join(out)


## Every `<digits>.<digits>` run in `code`. A level curve, an experience value or
## a cap would arrive as exactly one of these.
func _float_literals(code: String) -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	var index: int = 0
	while index < code.length():
		if not _is_digit(code[index]):
			index += 1
			continue
		var start: int = index
		while index < code.length() and _is_digit(code[index]):
			index += 1
		if index >= code.length() or code[index] != ".":
			continue
		var dot: int = index
		index += 1
		if index >= code.length() or not _is_digit(code[index]):
			index = dot + 1
			continue
		while index < code.length() and _is_digit(code[index]):
			index += 1
		out.append(code.substr(start, index - start))
	return out


func _is_digit(character: String) -> bool:
	return character.length() == 1 and character >= "0" and character <= "9"


## Whether `code` names `token` as a deferred member. Tokens listed in
## `WORD_MATCHED_TOKENS` must appear at an identifier-word boundary — a letter or
## a digit on either side disqualifies the match, while an underscore does not —
## and every other token is an ordinary substring.
func _names_deferred_member(code: String, token: String) -> bool:
	if not WORD_MATCHED_TOKENS.has(token):
		return code.contains(token)
	var from: int = 0
	while true:
		var at: int = code.find(token, from)
		if at < 0:
			return false
		var before_ok: bool = at == 0 or not _is_word_character(code[at - 1])
		var after: int = at + token.length()
		var after_ok: bool = after >= code.length() or not _is_word_character(code[after])
		if before_ok and after_ok:
			return true
		from = at + 1
	return false


## The deferred tokens `path` is permitted to name, from `PERMITTED_DEFERRED_TOKENS`.
## An exact per-file lookup: a file not listed is permitted nothing.
func _permitted_deferred_tokens(path: String) -> Array:
	for row: Array in PERMITTED_DEFERRED_TOKENS:
		if String(row[0]) == path:
			return row[1]
	return []


## `code` without the top-level functions named in `functions`: each is dropped from its
## declaration to the next unindented line (D-313).
func _code_outside(code: String, functions: Array) -> String:
	var kept: PackedStringArray = PackedStringArray()
	var skipping: bool = false
	for line: String in code.split("\n"):
		var declares: bool = false
		for name: Variant in functions:
			if line.begins_with("func %s(" % String(name)):
				declares = true
		if declares:
			skipping = true
			continue
		if skipping and (line.is_empty() or line.begins_with("\t") or line.begins_with(" ")):
			continue
		skipping = false
		kept.append(line)
	return "\n".join(kept)


## Whether `path` is an authorized reader that is granted `name` (D-269). Per file
## AND per class — the shape E1's and D3's suites use — so a file listed for one
## class is still refused every other.
func _reader_may_name(path: String, name: String) -> bool:
	for row: Array in AUTHORIZED_READERS:
		if String(row[0]) != path:
			continue
		for granted: String in row[1]:
			if granted == name:
				return true
		return false
	return false


## A letter or a digit. The underscore is deliberately NOT one: `award_xp` must
## be caught and `expose` must not.
func _is_word_character(character: String) -> bool:
	return character.length() == 1 and (
		(character >= "a" and character <= "z")
		or (character >= "A" and character <= "Z")
		or (character >= "0" and character <= "9")
	)


## Every method as `name(arg: Type, ...) -> Type`, in declaration order.
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
