class_name ImprintConfig
extends RefCounted

## RIFTWROUGHT — GLOBAL IMPRINT SYSTEM PROTOTYPE CONFIGURATION (D-375, 2026-09-17)
##
## ============================================================================
## EVERY TUNING NUMBER IN THIS FILE IS PROVISIONAL. NOTHING HERE IS FINAL.
## ============================================================================
## The owner's ruling for this stage is explicit about what it does NOT settle:
##   "does not finalize the Huntress roster, Rift Shards, slot counts, rank cap,
##    Capacity values, XP curve, reservation values or final balance."
##
## So every value below is registered in `provisional_registry()`, printed at
## runtime, printed by the verification suite, and asserted to be labelled.
##
## ---------------------------------------------------------------------------
## THIS FILE IS A SECOND REGISTRY, NOT A REPLACEMENT FOR THE FIRST.
## ---------------------------------------------------------------------------
## `ProdConfig` remains the registry for the ACCEPTED D-373 foundation baseline,
## and NOT ONE OF ITS VALUES IS MODIFIED HERE. This file registers only the
## values this stage introduces. Both registries are printed together at runtime
## and in both suites, so `ProdConfig`'s own stated invariant -- "a value that is
## not in that registry and is not structural is a defect" -- still holds across
## the union of the two.
##
## ---------------------------------------------------------------------------
## CANONICAL VALUES ARE SEPARATED FROM PROVISIONAL CANDIDATES, DELIBERATELY.
## ---------------------------------------------------------------------------
## Some numbers here come from canonical design and are NOT this stage's to
## choose (the four modifier slots, the one-Transform limit, the eight active
## bindings). Others are PROVISIONAL CANDIDATES the owner put under review (six
## equipped Active Configurations, four Persistent Configurations). Mixing the
## two would be exactly the drift this project exists to prevent, so they are in
## separate blocks and the suite asserts the separation. (D-380: BOTH candidates
## are GONE -- the four withdrawn by D-376, the six amended by D-378 OD-09 -- and
## a THIRD block, `working_baseline_registry()`, keeps the working baseline apart
## from canon AND from tunable numbers.)
##
## ============================================================================
## ALIGNED WITH THE D-378 RULINGS UNDER D-380 (2026-09-18). NOTHING IS LOCKED.
## ============================================================================
## The owner: "This is a semantic alignment stage, not Huntress implementation,
## not progression tuning, and not authorization for P2 or another Machinations
## model." So D-380 changed RULES, and introduced a number only where a new rule
## needed one to execute -- each DERIVED from a value already here, registered
## PROVISIONAL, and never one of D-378's test candidates:
##   * the six-Active candidate cap is GONE (OD-09): up to eight, one per binding;
##   * the four-Persistent candidate cap is GONE (D-376 withdrew it; OD-07);
##   * regeneration is a rate of UNRESERVED MAXIMUM Mana, not a flat 22/s (OD-05);
##   * Mana->Life conversion is PROPORTIONAL, and the flat Life tithe is GONE (OD-06);
##   * purely beneficial Augments are LEGAL (OD-12);
##   * a newly learned Imprint starts at Mastered Rank 1 / 0 XP, and the start-up
##     ranks are DECLARED DIAGNOSTIC SEEDING (OD-01).
## `d378_alignment()` maps EVERY D-378 ruling to exactly one of four dispositions
## and is printed on every run.

const DECISION := "D-375"
const DATE := "2026-09-17"
const STAGE := "GLOBAL IMPRINT SYSTEM PROTOTYPE"
## The stage that aligned this prototype with D-378. A THIRD stage of game3d/,
## not a new prototype: the D-375 architecture it aligns is canon since D-376.
const ALIGNMENT_DECISION := "D-380"
const ALIGNMENT_DATE := "2026-09-18"
const ALIGNMENT_STAGE := "D-378 ALIGNMENT STAGE"

# =============================================================================
# CANONICAL — NOT THIS STAGE'S TO CHOOSE, AND NOT PROVISIONAL
# =============================================================================

## `design/SKILLS_AND_SKILL_MODIFICATION.md` section 6 and section 18:
## "The initial maximum target is four Augments per configuration."
## A Transform occupies one of these four; it is NOT a fifth position.
const CANON_MODIFIER_SLOTS_MAX := 4

## Same document, section 8 and section 18: "A Skill Configuration may normally
## contain no more than one Transform Augment."
const CANON_TRANSFORMS_MAX_PER_CONFIGURATION := 1

## Same document, section 11; `design/UI_AND_USER_EXPERIENCE.md`; and D-079:
## "eight active combat bindings arranged as primary and shifted banks of four."
##
## THE OWNER'S INSTRUCTION FOR THIS STAGE IS EXACT:
##   "Preserve eight possible active input bindings."
##   "Do not silently rewrite eight bindings into six."
const CANON_ACTIVE_BINDINGS := 8

## The canonical tag vocabulary, from `design/ATTRIBUTES_AND_DAMAGE_MODEL.md`
## section 11 and section 16. THE COMPATIBILITY SYSTEM MAY USE NOTHING ELSE
## except the declared extension below, and the suite asserts that.
const CANON_TAGS_SOURCE := ["Attack", "Spell", "Minion", "Triggered", "Environment"]
const CANON_TAGS_DELIVERY := ["Hit", "Damage over Time"]
const CANON_TAGS_FORM := ["Melee", "Strike", "Projectile", "Area", "Channel", "Ground", "Secondary"]
const CANON_TAGS_TYPE := ["Physical", "Fire", "Cold", "Lightning", "Toxic", "Void"]

## ============================================================================
## ONE DECLARED TAG EXTENSION, MEASURED AND CITED RATHER THAN ASSUMED.
## ============================================================================
## `ATTRIBUTES_AND_DAMAGE_MODEL.md` section 11 lists source, delivery and form
## tags, and "Duration" is NOT among them -- but `SKILLS_AND_SKILL_MODIFICATION.md`
## section 15 titles a whole behaviour family "Duration and Ground Skills", and
## its sixteen-Augment package contains "Increased Duration". Canon therefore
## USES Duration as a mechanical category while never listing it as a tag.
##
## Rather than silently widen the vocabulary or silently refuse a canonical
## Augment family, the extension is DECLARED, CITED and PRINTED.
const DECLARED_TAG_EXTENSIONS := [
	["Duration",
	 "design/SKILLS_AND_SKILL_MODIFICATION.md section 15 ('Duration and Ground Skills') and "
	 + "its 'Increased Duration' Augment. NOT listed among the source/delivery/form tags of "
	 + "ATTRIBUTES_AND_DAMAGE_MODEL.md section 11. DECLARED HERE, not assumed."],
]

## ============================================================================
## CANON'S D-385 VOCABULARY ADDITIONS — QUOTED UNDER D-396, WITH THEIR CITATION.
## ============================================================================
## The four lists above quote ATTRIBUTES_AND_DAMAGE_MODEL.md section 11 as it
## stood at D-375. D-385 then AMENDED that section: "`Trap` (Mechanical Form) ·
## `Emplacement` (Mechanical Form, on a Minion) · `Beast` (Minion descriptor --
## so that an effect may reach beasts and not emplacements)". The quotation was
## stale from D-385 until D-396 -- true of canon, and harmless while no Imprint
## used the words. D-396's Kindred Hounds carry canon's own tags, `Beast` among
## them, so the quotation is brought up to canon. These are CANON, NOT a declared
## extension: the one extension is still `Duration`, and I16 still says so.
const CANON_TAGS_D385_ADDITIONS := ["Trap", "Emplacement", "Beast"]
const CANON_TAGS_D385_CITATION := "design/ATTRIBUTES_AND_DAMAGE_MODEL.md section 11, amended under D-385 (2026-09-18)"

static func canonical_tags() -> Array:
	var out: Array = []
	out.append_array(CANON_TAGS_SOURCE)
	out.append_array(CANON_TAGS_DELIVERY)
	out.append_array(CANON_TAGS_FORM)
	out.append_array(CANON_TAGS_TYPE)
	out.append_array(CANON_TAGS_D385_ADDITIONS)
	for row in DECLARED_TAG_EXTENSIONS:
		out.append(String(row[0]))
	return out

## The four canonical targeting archetypes, `SKILLS_AND_SKILL_MODIFICATION.md`
## section 11: "Every active Skill Configuration declares one canonical
## targeting archetype."
const CANON_TARGETING := ["directional", "ground-targeted", "contact-targeted", "self-centered"]

# =============================================================================
# THE TWO SLOT CANDIDATES ARE GONE — history, preserved
# =============================================================================

## ============================================================================
## THERE IS NO SEPARATE CAP ON EQUIPPED ACTIVE CONFIGURATIONS. (D-378, OD-09)
## ============================================================================
## From D-375 until D-380 this file declared `CANDIDATE_ACTIVE_CONFIGURATIONS
## := 6`, a PROVISIONAL CANDIDATE cap enforced by `ImprintLoadout.bind()`. TRUE
## WHEN WRITTEN: D-376 made six the working baseline. D-378 OD-09 AMENDED it:
## "up to EIGHT equipped Active Configurations; one Configuration per binding;
## empty bindings valid; NO separate arbitrary six-Configuration cap; global
## Capacity limits how deeply the loadout can be modified."
##
## SO THE CONSTANT IS REMOVED, not re-valued to 8. A second number that merely
## equals the binding count would be a cap waiting to drift away from it. The
## ONLY structural limit is now the eight bindings themselves -- one
## Configuration each -- and the limit on DEPTH is the global Capacity budget.
## Bindings and equipped Configurations REMAIN DISTINCT CONCEPTS: the limit now
## coincides with the binding count; the two are not merged. The working
## baseline is REGISTERED AS A WORKING BASELINE in `working_baseline_registry()`.
##
## ============================================================================
## THERE IS NO ARBITRARY PERSISTENT SLOT CAP. (D-079, D-376 X-02, D-378 OD-07)
## ============================================================================
## From D-375 until D-380 this file declared `CANDIDATE_PERSISTENT_CONFIGURATIONS
## := 4`, enforced by `ImprintLoadout.add_persistent()`, with conflict X-02
## printed beside it. D-376 RESOLVED X-02 AGAINST THE CANDIDATE -- D-079's
## refusal stands and the four-slot cap "MUST NOT become the production rule" --
## but D-376 changed nothing in this project, so the runtime KEPT ENFORCING IT.
## D-380 MEASURED that and REMOVED it. Persistent Skills are now limited
## NATURALLY: by reservation, compatibility and Configuration Capacity.

# --- The rank prototype ------------------------------------------------------
# "Implement a deliberately provisional 1-20 rank model." DELIBERATELY
# PROVISIONAL is the owner's own word, and the cap is explicitly not finalized.
const RANK_MIN := 1
const RANK_MAX := 20

## XP to advance FROM rank r TO rank r+1. A deliberately plain linear curve:
## the ruling says the exact curve is provisional, so an elaborate one would only
## be a more expensive guess.
const XP_PER_RANK_STEP := 120.0

## ============================================================================
## AWARDED COMBAT PROGRESS. THE ONLY THING THAT GRANTS XP.
## ============================================================================
## The owner: "Equipped Imprints receive combat XP from awarded combat progress,
## NOT from button-use frequency." So there is exactly one award event in this
## prototype -- an enemy defeated -- and no code path from a Skill use to the
## library's `grant_xp`. PROVISIONAL, and no progression pacing is implemented.
const COMBAT_PROGRESS_PER_ENEMY_DEFEATED := 60.0

## ============================================================================
## THE BOUNDED CATCH-UP RULE. "Its exact curve is provisional."
## ============================================================================
## Canon requires it: `SKILLS_AND_SKILL_MODIFICATION.md` section 4 -- "Skills do
## not require hours of use-based experience before they become viable on an
## established character" -- and section 18 makes it a locked decision.
##
## BOUNDED IS THE POINT. An unbounded multiplier would make a newly learned
## Imprint level faster than an invested one, which is a different unfairness.
const CATCHUP_PER_RANK_BEHIND := 0.5
const CATCHUP_MULTIPLIER_MAX := 4.0

# --- Configuration Capacity --------------------------------------------------
# "Most base Capacity comes from character progression. Gear may contribute a
#  modest bonus, represented diagnostically; do not build an equipment system."
#
# MEASURED SHARES, so "most" and "modest" are arithmetic rather than adjectives:
#   progression 30 of 35 = 85.7 %   ·   gear 5 of 35 = 14.3 %
const CAPACITY_FROM_PROGRESSION := 30
const CAPACITY_GEAR_BONUS_DIAGNOSTIC := 5

## Capacity cost by Skill class. The ruling: "A primary Skill may consume more
## Capacity than a movement, utility or secondary Skill."
const CAPACITY_BASE_PRIMARY := 3
const CAPACITY_BASE_SECONDARY := 2
const CAPACITY_BASE_PERSISTENT := 1
const CAPACITY_PER_MODIFIER_PRIMARY := 2
const CAPACITY_PER_MODIFIER_SECONDARY := 2
const CAPACITY_PER_MODIFIER_PERSISTENT := 1

# --- Resources ---------------------------------------------------------------
# Mana maximum matches the canonical worked example in
# `SKILLS_AND_SKILL_MODIFICATION.md` section 15 (500 maximum, 20 % reserved).
# Life maximum matches the player probe's EXISTING accepted `Damageable(300.0)`
# so the two do not disagree -- this pool models the RESERVATION CEILING and the
# Mana spend; the accepted `Damageable` remains the live Life ledger.
const MANA_MAX := 500.0
const LIFE_MAX := 300.0

## ============================================================================
## BASE MANA REGENERATION IS A RATE OF *UNRESERVED MAXIMUM* MANA. (D-378, OD-05)
## ============================================================================
## The owner: "Base Mana regeneration is calculated from UNRESERVED MAXIMUM MANA
## ... never from fluctuating current Mana. The stronger reservation pressure is
## intentional." Worked example: 100 maximum, 20 reserved, 80 unreserved, 2 % ->
## 1.6 Mana/s. THE BASIS IS THE RULE. THE RATE IS PROVISIONAL.
##
## From D-375 until D-380 this was `MANA_REGEN_PER_S := 22.0`, a FLAT rate with no
## reservation basis -- true when written, and the divergence D-378 recorded.
##
## THE RATE IS DERIVED, NOT CHOSEN: 22.0 / 500.0 = 0.044 per second, so a pool
## with NOTHING reserved regenerates EXACTLY as the accepted prototype did, and
## the only thing that changes is the one thing the ruling changes -- reservation
## now costs regeneration as well as buffer. It is the D-377 model's own `PC-07`
## reference. NOT A LOCK.
const MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S := 0.044

# --- The Persistent aura -----------------------------------------------------
const AURA_RESERVE_FRACTION_AT_RANK_1 := 0.18
const AURA_RESERVE_FRACTION_PER_RANK := 0.006

## ============================================================================
## MANA->LIFE CONVERSION IS PROPORTIONAL. THE FLAT LIFE TITHE IS GONE. (OD-06)
## ============================================================================
## The owner: "All Persistent reservation is percentage-based, not flat.
## Mana->Life reservation conversion is proportional; the ratio is provisional
## (~2x may be tested, not locked). No flat Life tithe."
##
## From D-375 until D-380 the conversion modifier reserved a FIXED fraction of
## maximum Life -- 26 % at rank 1, -0.4 %/rank -- WHATEVER THE SIZE OF THE EFFECT
## IT CONVERTED (`LIFE_TITHE_FRACTION_AT_RANK_1` / `_PER_RANK`). True when
## written; that is the flat Life tithe the ruling removes, and both constants
## are GONE.
##
## NOW: Life reserved = (the fraction of maximum MANA the effect would have
## reserved, after its own modifiers) x RATIO(rank) x maximum Life, where
## RATIO(rank) = RATIO_AT_RANK_1 x (1 + RATIO_PER_RANK x (rank - 1)).
##
## THE RATIO IS DERIVED FROM THE PROTOTYPE'S OWN FIGURES, NOT FROM THE CANDIDATE:
## 0.26 / 0.18 = 1.444 at rank 1 -- the old tithe against the aura it converted,
## so the rank-1 relationship the owner reviewed live is preserved -- and -0.4 %
## of 26 % = -1.54 % of the ratio per rank, so the Imprint still becomes more
## efficient as it ranks. BOTH ARE THE D-377 MODEL'S `PC-08` REFERENCE.
## THE ~2x TEST CANDIDATE IS DELIBERATELY NOT ADOPTED. NOT A LOCK.
const LIFE_CONVERSION_RATIO_AT_RANK_1 := 1.444
const LIFE_CONVERSION_RATIO_PER_RANK := -0.0154
## What the aura does for the beasts, so PS-08 is a measurement and not a claim.
const AURA_BEAST_DAMAGE_BONUS_AT_RANK_1 := 0.20
const AURA_BEAST_DAMAGE_BONUS_PER_RANK := 0.02

# --- The three diagnostic builds --------------------------------------------
# ============================================================================
# NONE OF THESE IS A HUNTRESS SKILL, A ROSTER ENTRY, FINAL ART OR FINAL BALANCE.
# ============================================================================
# The ruling: "These three examples are diagnostic content, not the complete
# Huntress roster, final names, final values, final VFX or final balance."

# Storm-shot family
const STORM_DAMAGE_AT_RANK_1 := 26.0
const STORM_DAMAGE_PER_RANK := 3.1
const STORM_MANA_AT_RANK_1 := 12.0
const STORM_MANA_PER_RANK := 0.36
const STORM_COOLDOWN_AT_RANK_1 := 0.55
const STORM_COOLDOWN_PER_RANK := -0.0055
const STORM_ACTION_DURATION := 0.50
const STORM_PROJECTILE_SPEED := 26.0
const STORM_PROJECTILE_RANGE := 17.0
const STORM_PROJECTILE_RADIUS := 0.30

# Ward-ballista family
const BALLISTA_DAMAGE_AT_RANK_1 := 11.0
const BALLISTA_DAMAGE_PER_RANK := 1.05
const BALLISTA_MANA_AT_RANK_1 := 26.0
const BALLISTA_MANA_PER_RANK := 0.9
const BALLISTA_COOLDOWN := 2.60
const BALLISTA_ACTION_DURATION := 0.55
const BALLISTA_DURATION_AT_RANK_1 := 7.0
const BALLISTA_DURATION_PER_RANK := 0.55
const BALLISTA_FIRE_INTERVAL := 0.85
const BALLISTA_ACQUIRE_RANGE := 12.0
const BALLISTA_INSTANCES_MAX := 2
const BALLISTA_PLACE_RANGE := 9.0

# Beast-pack family
const BEAST_DAMAGE_AT_RANK_1 := 7.0
const BEAST_DAMAGE_PER_RANK := 0.62
const BEAST_MANA_AT_RANK_1 := 34.0
const BEAST_MANA_PER_RANK := 1.1
const BEAST_COOLDOWN := 4.00
const BEAST_ACTION_DURATION := 0.60
const BEAST_ATTACK_INTERVAL := 1.05
const BEAST_ATTACK_RANGE := 1.60
const BEAST_ACQUIRE_RANGE := 13.0
const BEAST_FOLLOW_DISTANCE := 2.40
const BEAST_SPEED_MPS := 4.30
const BEAST_BODY_RADIUS := 0.34
const BEAST_VISUAL_SCALE := 0.62
const BEAST_COUNT_AT_RANK_1 := 1
const BEAST_COUNT_RANK_STEP := 7

# Reusable modifier magnitudes
const SPLIT_VOLLEY_EXTRA_AT_RANK_1 := 1
const SPLIT_VOLLEY_RANK_STEP := 7
const SPLIT_VOLLEY_SPREAD_DEG := 13.0
const SPLIT_VOLLEY_MANA_SURCHARGE_AT_RANK_1 := 4.0
const SPLIT_VOLLEY_MANA_SURCHARGE_PER_RANK := 0.22
const FORK_CHILDREN := 2
const FORK_MAX_GENERATIONS := 1
const FORK_ANGLE_DEG := 34.0
const FORK_DAMAGE_FRACTION_AT_RANK_1 := 0.42
const FORK_DAMAGE_FRACTION_PER_RANK := 0.011
const FORK_MANA_SURCHARGE := 5.0
const FORK_MANA_SURCHARGE_PER_RANK := 0.30
const TEMPERED_MORE_DAMAGE_AT_RANK_1 := 0.18
const TEMPERED_MORE_DAMAGE_PER_RANK := 0.012
const TEMPERED_MANA_SURCHARGE_AT_RANK_1 := 6.0
const TEMPERED_MANA_SURCHARGE_PER_RANK := 0.3
const TEMPERED_ACTION_DURATION_ADD := 0.08
const SUREFOOT_LESS_DAMAGE_AT_RANK_1 := 0.16
const SUREFOOT_LESS_DAMAGE_PER_RANK := -0.006
const SUREFOOT_ACTION_DURATION_MULT := 0.74
const SUREFOOT_ACTION_DURATION_MULT_PER_RANK := -0.004
const SUREFOOT_MANA_SURCHARGE := 3.0
const EXTENDED_WARD_DURATION_MULT_AT_RANK_1 := 1.30
const EXTENDED_WARD_DURATION_MULT_PER_RANK := 0.02
const EXTENDED_WARD_MANA_SURCHARGE := 7.0
const EXTENDED_WARD_MANA_PER_RANK := 0.40
const PACK_INSTINCT_EXTRA_BEASTS := 1
const PACK_INSTINCT_LESS_DAMAGE_AT_RANK_1 := 0.22
const PACK_INSTINCT_LESS_DAMAGE_PER_RANK := -0.009
const PACK_INSTINCT_MANA_SURCHARGE := 9.0
const PACK_INSTINCT_MANA_PER_RANK := -0.25

# Transform magnitudes
const ORBIT_DURATION_AT_RANK_1 := 2.4
const ORBIT_DURATION_PER_RANK := 0.13
const ORBIT_PULSE_INTERVAL_AT_RANK_1 := 0.46
const ORBIT_PULSE_INTERVAL_PER_RANK := -0.009
const ORBIT_RADIUS := 3.10
const ORBIT_MANA_SURCHARGE := 11.0
const RAIN_VOLLEYS_AT_RANK_1 := 2
const RAIN_VOLLEY_RANK_STEP := 5
const RAIN_MANA_SURCHARGE := 9.0
const RAIN_MANA_PER_RANK := 0.45
const ANCHOR_DURATION_MULT := 3.40
const ANCHOR_MANA_SURCHARGE := 13.0
const ANCHOR_MANA_PER_RANK := 0.90

# --- Colours (PROVISIONAL, and NOT final VFX) --------------------------------
const COL_STORM := Color(0.596, 0.812, 1.0)
const COL_BALLISTA := Color(1.0, 0.760, 0.372)
const COL_BEAST := Color(0.478, 0.902, 0.588)
const COL_AURA := Color(0.404, 0.952, 0.690)
const COL_INVALID := Color(1.0, 0.392, 0.392)

# =============================================================================
# THE PROVISIONAL REGISTRY FOR THIS STAGE
# =============================================================================

## ============================================================================
## D-380: FIVE ROWS LEFT THIS REGISTRY AND THREE ARRIVED. 68 - 5 + 3 = 66.
## ============================================================================
## LEFT, because the value no longer exists: "candidate active Configurations"
## (6, OD-09), "candidate Persistent Configurations" (4, D-376 X-02), "Mana
## regeneration (per s)" (22, OD-05), "Life tithe reservation at rank 1" and
## "... per rank" (0.26 / -0.004, OD-06). ARRIVED, each DERIVED from a value that
## was already here: the regeneration rate of unreserved maximum Mana, and the
## two conversion-ratio terms. NONE OF THE THREE IS A D-378 TEST CANDIDATE.
static func provisional_registry() -> Array:
	return [
		["rank minimum", RANK_MIN, "PROVISIONAL"],
		["rank maximum (the cap)", RANK_MAX, "PROVISIONAL — the rank cap is explicitly NOT finalized"],
		["xp per rank step", XP_PER_RANK_STEP, "PROVISIONAL — the XP curve is explicitly NOT finalized"],
		["combat progress per enemy defeated", COMBAT_PROGRESS_PER_ENEMY_DEFEATED,
		 "PROVISIONAL — the ONLY XP source. Button use grants nothing"],
		["catch-up per rank behind", CATCHUP_PER_RANK_BEHIND, "PROVISIONAL — the catch-up curve is provisional"],
		["catch-up multiplier ceiling", CATCHUP_MULTIPLIER_MAX, "PROVISIONAL — and BOUNDED on purpose"],
		["Capacity from progression", CAPACITY_FROM_PROGRESSION, "PROVISIONAL — Capacity values are explicitly NOT finalized"],
		["Capacity gear bonus (diagnostic)", CAPACITY_GEAR_BONUS_DIAGNOSTIC,
		 "PROVISIONAL — a DIAGNOSTIC scalar. There is NO equipment system here"],
		["Capacity base, primary Skill", CAPACITY_BASE_PRIMARY, "PROVISIONAL"],
		["Capacity base, secondary Skill", CAPACITY_BASE_SECONDARY, "PROVISIONAL"],
		["Capacity base, persistent Skill", CAPACITY_BASE_PERSISTENT, "PROVISIONAL"],
		["Capacity per modifier, primary", CAPACITY_PER_MODIFIER_PRIMARY, "PROVISIONAL"],
		["Capacity per modifier, secondary", CAPACITY_PER_MODIFIER_SECONDARY, "PROVISIONAL"],
		["Capacity per modifier, persistent", CAPACITY_PER_MODIFIER_PERSISTENT, "PROVISIONAL"],
		["maximum Mana", MANA_MAX, "PROVISIONAL — matches the canonical worked example's 500"],
		["maximum Life", LIFE_MAX, "PROVISIONAL — matches the player probe's existing accepted 300.0"],
		["Mana regeneration rate (of UNRESERVED maximum, per s)", MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S,
		 "PROVISIONAL — D-380. The BASIS is the accepted D-378 OD-05 rule; the RATE is DERIVED (22 / 500) and is NOT a lock"],
		["aura reservation at rank 1", AURA_RESERVE_FRACTION_AT_RANK_1, "PROVISIONAL — reservation values are explicitly NOT finalized"],
		["aura reservation per rank", AURA_RESERVE_FRACTION_PER_RANK, "PROVISIONAL"],
		["Mana->Life conversion ratio at rank 1", LIFE_CONVERSION_RATIO_AT_RANK_1,
		 "PROVISIONAL — D-380. PROPORTIONAL conversion is the D-378 OD-06 rule; the ratio is DERIVED (0.26 / 0.18) and the ~2x candidate is NOT adopted"],
		["Mana->Life conversion ratio change per rank (relative)", LIFE_CONVERSION_RATIO_PER_RANK,
		 "PROVISIONAL — D-380. DERIVED from the old -0.4 %/rank of 26 %; NOT a lock"],
		["aura beast damage bonus at rank 1", AURA_BEAST_DAMAGE_BONUS_AT_RANK_1, "PROVISIONAL"],
		["storm damage at rank 1", STORM_DAMAGE_AT_RANK_1, "PROVISIONAL — NOT final balance"],
		["storm damage per rank", STORM_DAMAGE_PER_RANK, "PROVISIONAL — NOT final balance"],
		["storm Mana cost at rank 1", STORM_MANA_AT_RANK_1, "PROVISIONAL"],
		["storm cooldown at rank 1", STORM_COOLDOWN_AT_RANK_1, "PROVISIONAL"],
		["storm cooldown per rank", STORM_COOLDOWN_PER_RANK, "PROVISIONAL"],
		["storm action duration", STORM_ACTION_DURATION, "PROVISIONAL — a NEW value; the accepted 0.4500 s is NOT modified"],
		["storm projectile speed", STORM_PROJECTILE_SPEED, "PROVISIONAL"],
		["ballista damage at rank 1", BALLISTA_DAMAGE_AT_RANK_1, "PROVISIONAL — NOT final balance"],
		["ballista duration at rank 1", BALLISTA_DURATION_AT_RANK_1, "PROVISIONAL"],
		["ballista duration per rank", BALLISTA_DURATION_PER_RANK, "PROVISIONAL"],
		["ballista fire interval", BALLISTA_FIRE_INTERVAL, "PROVISIONAL"],
		["ballista instances maximum", BALLISTA_INSTANCES_MAX, "PROVISIONAL"],
		["ballista action duration", BALLISTA_ACTION_DURATION, "PROVISIONAL"],
		["beast damage at rank 1", BEAST_DAMAGE_AT_RANK_1, "PROVISIONAL — NOT final balance"],
		["beast damage per rank", BEAST_DAMAGE_PER_RANK, "PROVISIONAL — NOT final balance"],
		["beast count at rank 1", BEAST_COUNT_AT_RANK_1, "PROVISIONAL"],
		["beast count rank step", BEAST_COUNT_RANK_STEP, "PROVISIONAL"],
		["beast speed (m/s)", BEAST_SPEED_MPS, "PROVISIONAL — the player's 3.889 m/s is NOT modified"],
		["beast attack interval", BEAST_ATTACK_INTERVAL, "PROVISIONAL"],
		["beast action duration", BEAST_ACTION_DURATION, "PROVISIONAL"],
		["split volley extra at rank 1", SPLIT_VOLLEY_EXTRA_AT_RANK_1, "PROVISIONAL — but the BEHAVIOUR is complete at rank 1"],
		["split volley rank step", SPLIT_VOLLEY_RANK_STEP, "PROVISIONAL"],
		["fork children", FORK_CHILDREN, "PROVISIONAL — but the BEHAVIOUR is complete at rank 1"],
		["fork maximum generations", FORK_MAX_GENERATIONS, "PROVISIONAL — and BOUNDED, so a fork cannot chain forever"],
		["fork damage fraction at rank 1", FORK_DAMAGE_FRACTION_AT_RANK_1, "PROVISIONAL"],
		["tempered more damage at rank 1", TEMPERED_MORE_DAMAGE_AT_RANK_1, "PROVISIONAL"],
		["tempered action duration add", TEMPERED_ACTION_DURATION_ADD, "PROVISIONAL"],
		["surefoot less damage at rank 1", SUREFOOT_LESS_DAMAGE_AT_RANK_1, "PROVISIONAL"],
		["surefoot action duration multiplier", SUREFOOT_ACTION_DURATION_MULT, "PROVISIONAL"],
		["extended ward duration multiplier", EXTENDED_WARD_DURATION_MULT_AT_RANK_1, "PROVISIONAL"],
		["pack instinct extra beasts", PACK_INSTINCT_EXTRA_BEASTS, "PROVISIONAL — but the BEHAVIOUR is complete at rank 1"],
		["pack instinct less damage at rank 1", PACK_INSTINCT_LESS_DAMAGE_AT_RANK_1, "PROVISIONAL"],
		["orbit duration at rank 1", ORBIT_DURATION_AT_RANK_1, "PROVISIONAL"],
		["orbit pulse interval at rank 1", ORBIT_PULSE_INTERVAL_AT_RANK_1, "PROVISIONAL"],
		["orbit radius", ORBIT_RADIUS, "PROVISIONAL"],
		["rain volleys at rank 1", RAIN_VOLLEYS_AT_RANK_1, "PROVISIONAL"],
		["anchor duration multiplier", ANCHOR_DURATION_MULT, "PROVISIONAL"],
		["surefoot duration multiplier per rank", SUREFOOT_ACTION_DURATION_MULT_PER_RANK, "PROVISIONAL"],
		["fork Mana surcharge per rank", FORK_MANA_SURCHARGE_PER_RANK, "PROVISIONAL"],
		["extended ward Mana per rank", EXTENDED_WARD_MANA_PER_RANK, "PROVISIONAL"],
		["pack instinct Mana per rank", PACK_INSTINCT_MANA_PER_RANK, "PROVISIONAL"],
		["rain Mana per rank", RAIN_MANA_PER_RANK, "PROVISIONAL"],
		["rain volley rank step", RAIN_VOLLEY_RANK_STEP, "PROVISIONAL"],
		["anchor Mana per rank", ANCHOR_MANA_PER_RANK, "PROVISIONAL"],
	]

## The values this stage declares CANONICAL rather than provisional, each with
## its canonical citation. The suite asserts none of them appears in the
## provisional registry, and that each citation is non-empty -- so a canonical
## claim can never be made without naming its source.
static func canonical_registry() -> Array:
	return [
		["modifier slots per Configuration", CANON_MODIFIER_SLOTS_MAX,
		 "design/SKILLS_AND_SKILL_MODIFICATION.md section 6 and section 18"],
		["Transforms per Configuration", CANON_TRANSFORMS_MAX_PER_CONFIGURATION,
		 "design/SKILLS_AND_SKILL_MODIFICATION.md section 8 and section 18"],
		["active input bindings", CANON_ACTIVE_BINDINGS,
		 "design/SKILLS_AND_SKILL_MODIFICATION.md section 11, design/UI_AND_USER_EXPERIENCE.md, and D-079"],
	]

## ============================================================================
## THE THIRD CATEGORY, KEPT APART FROM THE OTHER TWO: A CURRENT WORKING BASELINE.
## ============================================================================
## D-376's four categories -- ACCEPTED ARCHITECTURE · CURRENT WORKING BASELINE ·
## PROVISIONAL NUMERICAL VALUE · DIAGNOSTIC-ONLY -- must never be collapsed. A
## working baseline is NOT canon (so it is not in `canonical_registry()`) and is
## NOT a tunable number (so it is not in `provisional_registry()`): it is the
## present SHAPE, "explicitly amendable by later live build testing".
##
## It is a STATEMENT, not an enforced constant. Nothing reads a number from it:
## the eight-per-binding limit is the binding array itself.
static func working_baseline_registry() -> Array:
	return [
		["equipped Active Configurations",
		 "up to 8 — ONE per binding; empty bindings valid; NO separate six cap",
		 "CURRENT WORKING BASELINE (D-378 OD-09, amending D-376's six) — NOT a lock; to be reconsidered once there is content for multi-hour build testing. Global Capacity limits how deeply the loadout is modified"],
		["Persistent Configurations",
		 "no arbitrary slot cap — limited by reservation, compatibility and Capacity",
		 "ACCEPTED ARCHITECTURE since D-376 (D-079 stands; the four-slot candidate WITHDRAWN), restated by D-378 OD-07 — the runtime cap was REMOVED under D-380"],
	]

## ============================================================================
## THE MEASURED CONFLICTS, PRINTED AT RUNTIME AND NOT ONLY IN A DOCUMENT.
## ============================================================================
## The owner's instruction: "Measure and report any conflict before resolving
## it." A conflict recorded only in a report drifts away from the code that
## carries it; printed every run, it cannot.
##
## ---------------------------------------------------------------------------
## X-02, X-03 AND X-04 WERE RESOLVED BY THE OWNER UNDER D-376. They still print,
## now as RESOLVED, with the D-375 measurement kept after "HISTORY:" -- the same
## discipline as a discharged row: the current state first, the record kept.
## ---------------------------------------------------------------------------
static func declared_conflicts() -> Array:
	return [
		["X-02", "FOUR PERSISTENT CONFIGURATIONS vs D-079 — RESOLVED BY D-376",
		 "RESOLVED AGAINST THE CANDIDATE: D-079's refusal of an arbitrary Persistent-slot cap STANDS and "
		 + "the four-slot cap is WITHDRAWN; D-380 REMOVED it from the runtime, so Persistents are limited "
		 + "only by reservation, compatibility and Capacity. HISTORY: D-079 permits NO ARBITRARY first-MVP "
		 + "Persistent-slot cap, and SKILLS_AND_SKILL_MODIFICATION.md section 15 repeats it. The candidate "
		 + "cap of 4 was IMPLEMENTED AS A CANDIDATE and canon was NOT amended. THE DECISION WAS THE OWNER'S."],
		["X-03", "LEVELABLE AUGMENT IMPRINTS vs canon's refusal of use-based Augment progression — RESOLVED BY D-376",
		 "RESOLVED, AND NOT AS A CONTRADICTION: combat-XP progression is NOT use-based, so canon's refusal "
		 + "of use-based progression stands unchanged. Unequipped progression is a D-378 TEST CANDIDATE "
		 + "(OD-11) and is NOT implemented. HISTORY: SKILLS_AND_SKILL_MODIFICATION.md section 17 and "
		 + "section 18 say an ordinary Augment requires NO use-based experience. Reconciled in part: "
		 + "BEHAVIOURAL IDENTITY IS COMPLETE AT RANK 1 and rank scales NUMBERS ONLY."],
		["X-04", "A GLOBAL CAPACITY BUDGET WITH A GEAR CONTRIBUTION vs canon's progression-only slot model — RESOLVED BY D-376",
		 "RESOLVED: the global budget is ACCEPTED ARCHITECTURE, most Capacity comes from deterministic "
		 + "progression, and GENERIC RANDOMLY ROLLED GEAR CAPACITY IS NOT ACCEPTED as a foundation. The "
		 + "simulated gear toggle remains DIAGNOSTIC EVIDENCE, not an equipment ruling. HISTORY: "
		 + "SKILLS_AND_SKILL_MODIFICATION.md section 17 and section 18 say capacity unlocks globally "
		 + "through deterministic progression and does NOT depend on equipment. The gear figure is a "
		 + "DIAGNOSTIC SCALAR with no item, affix, slot, inventory or randomness behind it."],
		["X-05", "LIGHTNING is canonical but is NOT first-MVP content",
		 "ATTRIBUTES_AND_DAMAGE_MODEL.md section 16 lists six types including Lightning; "
		 + "FIRST_MVP_SCOPE_LOCK_AND_INTEGRATION_AUDIT.md requires first-MVP content for Physical, Fire and "
		 + "Void ONLY. This is DIAGNOSTIC content, not first-MVP content, and no Shock ailment, resistance "
		 + "or affix exists here."],
		["X-06", "MINIONS are designed canon but are NOT first-MVP content, and the Atlas carries a companion guardrail",
		 "The asset-cost half is DISCHARGED BY MEASUREMENT: this stage imports ZERO new assets and the "
		 + "beasts reuse the already-declared Imp. The bounded companion DESIGN review remains OWED, and the "
		 + "guardrail is honoured -- the bow build stands alone and is the primary Skill."],
		["X-08", "CANON FORBIDS CONFIGURATION EDITS DURING ACTIVE COMBAT, and this project has no safe-state model",
		 "MEASURED: no combat-state or safe-state concept exists in any accepted runtime script. The "
		 + "canonical rule is implemented as a bounded, declared approximation and is PROVED TO REFUSE. The "
		 + "DIAGNOSTIC SAFE-STATE OVERRIDE is a DECLARED SEAM, counted, never a silent bypass."],
		["X-15", "CANON'S TAG VOCABULARY CONTAINS NO Persistent OR Reservation TAG",
		 "MEASURED in ATTRIBUTES_AND_DAMAGE_MODEL.md section 11. Reservation compatibility is therefore "
		 + "expressed as a declared CONFIGURATION CLASS rather than by inventing a tag. Compatibility "
		 + "remains tag-driven for everything canon gives a tag for."],
	]

## What this stage denies, individually, so no denial can be lost in a total.
static func denials() -> Array:
	return [
		"This stage COMPLETES NO PHASE in the P0-P7 table.",
		"This stage DOES NOT COMPLETE P1.",
		"This stage DOES NOT COMPLETE the original P1C.",
		"This stage DOES NOT AUTHORIZE P2.",
		"This stage DOES NOT FINALIZE THE HUNTRESS ROSTER. Every Imprint this stage added is DIAGNOSTIC. (D-392 later learned ONE canonical Skill Imprint, Splinter Shot, into the same library — its stage, not this one.)",
		"This stage DOES NOT IMPLEMENT RIFT SHARDS. There is no Generate, Hold, Shape or Rift Echo here.",
		"This stage DOES NOT FINALIZE SLOT COUNTS. Up to eight Active Configurations is a CURRENT WORKING BASELINE (D-378 OD-09), not a lock; the four-Persistent candidate is WITHDRAWN (D-376).",
		"This stage DOES NOT FINALIZE THE RANK CAP. 1-20 is PROVISIONAL.",
		"This stage DOES NOT FINALIZE CAPACITY VALUES.",
		"This stage DOES NOT FINALIZE THE XP CURVE.",
		"This stage DOES NOT FINALIZE RESERVATION VALUES.",
		"This stage DOES NOT FINALIZE BALANCE. No damage, cost, duration or timing here is final.",
		"NO canonical Huntress class specification is written here; one remains a P2 prerequisite.",
		"There is NO equipment system here. The Capacity gear figure is a DIAGNOSTIC SCALAR.",
		"There is NO loot, acquisition, trading or progression pacing here.",
		"NO value here is a production lock.",
		"NO accepted D-373 value is modified by this stage.",
		"The loadout panel is a DEVELOPER surface and is NOT a UI foundation.",
	]

## ============================================================================
## THE D-380 ALIGNMENT STAGE'S OWN DENIALS, individually, for the same reason.
## ============================================================================
static func alignment_denials() -> Array:
	return [
		"The D-380 alignment stage is a SEMANTIC ALIGNMENT STAGE. It IS NOT Huntress implementation and IS NOT progression tuning.",
		"The D-380 alignment stage DOES NOT AUTHORIZE P2 and BUILDS NO Machinations model.",
		"The D-380 alignment stage ADOPTS NO D-378 TEST CANDIDATE: no ~25 % unequipped progression, no ~3 % reservation floor, no ~2x conversion ratio, no milestone Capacity, no 24 or 30-36 Capacity band.",
		"The D-380 alignment stage LOCKS NO NUMBER: not the rank cap, any XP threshold or curve, any catch-up value, any levelling time, any Capacity total or cost, any reservation percentage, any Mana or Life value, or any number of practical Configurations.",
		"The D-380 alignment stage writes NO canonical Huntress class specification and names NO Huntress Skill.",
		"The D-380 alignment stage adds NO Imprint, NO Configuration, NO asset, NO input action, NO Rift Shard, NO item, NO Passive and NO production VFX or UI. (True of the D-380 delivery. The D-381 reviewability correction then added EXACTLY ONE DIAGNOSTIC input action and ONE DIAGNOSTIC review HUD — see its own denials below.)",
		"The D-380 alignment stage MODIFIES NO accepted D-373 value and NO accepted action-commitment or click-to-move behaviour.",
	]

## ============================================================================
## THE D-381 REVIEWABILITY CORRECTION'S OWN DENIALS.
## ============================================================================
## A bounded correction INSIDE the D-380 stage, which stays DELIVERED and OPEN.
## It was requested because the developer panel could not be read while playing.
## (D-392, as its first act: "which stays DELIVERED and OPEN" was TRUE WHEN
## WRITTEN. D-383 ACCEPTED and CLOSED the D-380 stage with these corrections;
## the first denial below read "It re-delivers D-380 OPEN; it accepts nothing."
## until D-392 dated it -- the fact is unchanged, only its tense.)
const REVIEW_CORRECTION_DECISION := "D-381"
const REVIEW_CORRECTION := "D-381 REVIEWABILITY CORRECTION"
## The owner's clarification of D-381 and ruling on AD-11, 2026-09-18.
const HEALTH_RESERVATION_DECISION := "D-382"

static func reviewability_denials() -> Array:
	return [
		"The D-381 reviewability correction was requested because the D-380 debug presentation was NOT HUMAN-REVIEWABLE DURING PLAY. It re-delivered D-380 OPEN and accepted nothing (true when written; D-383 then ACCEPTED and CLOSED the stage, and D-392 reconciled this line as its first act).",
		"The D-381 review HUD is DIAGNOSTIC REVIEW UI. It IS NOT a production UI foundation, NOT a final visual style, and NOT an inventory, Skill menu or character sheet.",
		"The D-381 review HUD OWNS NO NUMBER. Every value it shows is read at draw time from the live gameplay objects: the SkillRuntime ResourcePool and the player's Damageable.",
		"The D-381 correction adds EXACTLY ONE diagnostic input action (diagnostic_reservation_cycle), which cycles OFF -> MANA RESERVATION -> LIFE CONVERSION -> OFF through operations that already existed.",
		"The D-381 correction adds NO Imprint, NO Configuration, NO asset, NO imported VFX, NO gameplay content and NO tuning change, and changes NO D-380 rule.",
		"The D-381 correction HIDES the developer panel by default. The panel is unchanged in content and stays on its existing toggle. (D-382: the F1 overlay ALSO starts hidden; each keeps its own toggle.)",
		"RESOLVED UNDER D-382 (D-381 had it DISCLOSED, NOT FIXED): a Life reservation now lowers live Health in the same transition — current Health = min(current Health, usable Health). Removing or reducing it is NOT healing, and every raise of live Health stays capped by usable Health.",
		"D-382 changes NO tuning value: the conversion ratio, every reservation fraction and every Mana and Life value are unchanged, and NO healing mechanic is added.",
	]

## ============================================================================
## THE D-378 MAP — EVERY RULING, IN EXACTLY ONE OF FOUR DISPOSITIONS.
## ============================================================================
## The owner: "explicitly map every D-378 ruling to implemented, already
## satisfied, deferred because it is only a candidate, or out of scope. Do not
## silently turn a test candidate into a production value."
##
## Rulings with several clauses are SPLIT INTO PARTS, and every part carries ONE
## disposition. Each row is [part, disposition, short label, detail]. The same
## table is in
## docs/testing/D380_ALIGNMENT_OWED_CRITERIA_INVENTORY.md section 3, and the
## runner compares the two ROW FOR ROW, so the document and the runtime cannot
## drift apart unnoticed.
const DISPOSITIONS := ["IMPLEMENTED", "ALREADY SATISFIED", "DEFERRED — CANDIDATE ONLY", "OUT OF SCOPE"]

static func d378_alignment() -> Array:
	return [
		["OD-01.1", "IMPLEMENTED", "new Imprint = Mastered Rank 1 / 0 XP; no floor", "A new Imprint starts at Mastered Rank 1 / 0 XP: learn() takes NO rank, so a floor is unrepresentable; start-up ranks are DECLARED DIAGNOSTIC SEEDING"],
		["OD-01.2", "ALREADY SATISFIED", "identity complete at rank 1", "Complete mechanical identity at rank 1 — unchanged, already proved (I19)"],
		["OD-01.3", "OUT OF SCOPE", "rank-1 kept functional by shared power systems", "Base effectiveness from character level, attributes, weapon, passives, gear — none of those systems exists here"],
		["OD-01.4", "ALREADY SATISFIED", "accelerated catch-up remains", "Accelerated catch-up remains — the bounded catch-up is unchanged and reaches a freshly learned Imprint"],
		["OD-02", "OUT OF SCOPE", "maximum rank slower than the campaign", "Maximum rank slower than the campaign — a pacing direction; the rank cap and curve are unchanged and PROVISIONAL"],
		["OD-03", "OUT OF SCOPE", "no universal rank-power share", "No universal rank-power share — a tuning direction; no such value exists here and none is added"],
		["OD-04.1", "ALREADY SATISFIED", "rational low / middle Effective Ranks", "Rational low / middle ranks — measured: lower Mana cost; a lower-rank aura reserves less and regenerates more"],
		["OD-04.2", "DEFERRED — CANDIDATE ONLY", "stepped Capacity / thresholds / cadence", "Stepped Capacity costs, thresholds, cadence interactions — NOT implemented"],
		["OD-05.1", "IMPLEMENTED", "regeneration from UNRESERVED maximum Mana", "Base regeneration = a PROVISIONAL rate x UNRESERVED MAXIMUM Mana, never current Mana"],
		["OD-05.2", "OUT OF SCOPE", "on-kill / leech / recoup / flat regen; boss test", "Mana on kill, leech, recoup, flat regeneration, a boss sustain test — none exists; owed before final tuning"],
		["OD-06.1", "ALREADY SATISFIED", "all Persistent reservation is a percentage", "Persistent reservation is a percentage — the aura already reserved a fraction of maximum; now guarded"],
		["OD-06.2", "IMPLEMENTED", "PROPORTIONAL Mana->Life; no flat Life tithe", "Mana->Life conversion is PROPORTIONAL; the flat Life tithe is REMOVED"],
		["OD-06.3", "DEFERRED — CANDIDATE ONLY", "~2x conversion ratio", "~2x ratio — NOT adopted; the ratio is the prototype-derived 1.444, PROVISIONAL"],
		["OD-07.1", "DEFERRED — CANDIDATE ONLY", "min Persistent cost 1 and/or ~3 % floor", "Minimum Persistent Capacity cost 1 and/or ~3 % floor — NOT implemented (the base cost of 1 predates D-378)"],
		["OD-07.2", "IMPLEMENTED", "no arbitrary Persistent slot cap", "No arbitrary Persistent slot cap — the D-376-withdrawn four-slot cap is REMOVED from the runtime"],
		["OD-08.1", "OUT OF SCOPE", "full-game maximum character level 100", "Full-game maximum character level 100 — no character level system exists here"],
		["OD-08.2", "DEFERRED — CANDIDATE ONLY", "~24 / 30-36 Capacity bands", "~24 / 30-36 Capacity bands — NOT adopted; the provisional 30 + 5 is unchanged"],
		["OD-09", "IMPLEMENTED", "up to EIGHT Active, one per binding; no six cap", "Up to EIGHT Active Configurations, one per binding; empty valid; NO six cap; Capacity limits depth"],
		["OD-10.1", "ALREADY SATISFIED", "no universal Transform Capacity surcharge", "No universal Transform Capacity surcharge — none ever existed; now guarded"],
		["OD-10.2", "DEFERRED — CANDIDATE ONLY", "rank-scaled Capacity at milestones", "Rank-scaled Capacity at milestones — NOT implemented"],
		["OD-11", "DEFERRED — CANDIDATE ONLY", "~25 % unequipped progression with a boundary", "~25 % unequipped progression with a boundary — NOT implemented; unequipped Imprints receive exactly 0"],
		["OD-12.1", "IMPLEMENTED", "purely beneficial Augments are legal", "Purely beneficial Augments are LEGAL — the free-power refusal is removed; the silent-modifier refusal is kept"],
		["OD-12.2", "OUT OF SCOPE", "avoid mandatory universal more-damage", "Avoid mandatory universal more-damage modifiers — a content-design rule; no content is added"],
		["OD-13", "OUT OF SCOPE", "native Machinations diagram", "The native Machinations diagram — a modelling task, closed under D-379"],
		["OD-14", "OUT OF SCOPE", "Mana Guard and bonus ranks", "Mana Guard and bonus ranks — neither mechanic exists; neither is added"],
		["OD-15", "OUT OF SCOPE", "Machinations-model authorization wording", "Machinations-model authorization wording — no model is built here"],
		["OD-16", "OUT OF SCOPE", "model evidence; one-time runner run", "Evidence acceptance and the one-time runner authorization — spent at D-378"],
	]

## ============================================================================
## WHAT D-380 CHANGED IN THE RUNTIME — before and after, each with its ruling.
## ============================================================================
static func alignment_changes() -> Array:
	return [
		["OD-09", "bind() refused a 7th Active Configuration (candidate cap 6)",
		 "no separate cap: eight bindings, one Configuration each; Capacity limits depth"],
		["D-376 X-02 / OD-07", "add_persistent() refused a 5th Persistent Configuration (candidate cap 4)",
		 "no slot cap: reservation, compatibility and Capacity are the only limits"],
		["OD-05", "regeneration was a flat 22.0 Mana/s",
		 "regeneration = 0.044 x (maximum - reserved) per s; identical when nothing is reserved"],
		["OD-06", "the conversion reserved a FLAT 26 % - 0.4 %/rank of Life, whatever it converted",
		 "Life reserved = the Mana fraction the effect would reserve x 1.444 x (1 - 0.0154 x (rank - 1))"],
		["OD-12", "validate() refused any modifier without a stated tradeoff ('FREE POWER')",
		 "a purely beneficial modifier is legal; a SILENT modifier is still refused"],
		["OD-01", "learn(imprint, mastered_rank) accepted an acquisition rank",
		 "learn(imprint) always starts at rank 1 / 0 XP; start-up ranks are DECLARED DIAGNOSTIC SEEDING"],
	]

## What this stage is new, and what it reuses, declared truthfully -- the same
## obligation D-370 carried, applied to a second stage.
static func reuse_declaration() -> Array:
	return [
		["ActionCommitment STOP / ALLOW", "game3d/scripts/control/action_commitment.gd",
		 "USED UNCHANGED. This is the architecture D-373 ACCEPTED. No third policy is added, and no "
		 + "timing, brake or cancel-window value is modified. Every direct Skill action uses it."],
		["Recovery cancellation, window DERIVED from the release marker", "the same file",
		 "USED UNCHANGED, and NO new cancel-window constant is introduced -- which was the whole point "
		 + "of deriving it at D-372."],
		["NavService.PathFollower planar advance", "game3d/scripts/world/nav_service.gd",
		 "REUSED for the beasts, unchanged. The measured reason it exists -- a 0.30 m vertical gap that "
		 + "stalled NavigationAgent3D -- applies identically to a minion."],
		["Damageable ledger with hit-before-death ordering", "game3d/scripts/combat/damageable.gd",
		 "REUSED unchanged for the ballista's and the beasts' targets."],
		["The point-blank overlap rule: test what you already overlap, BEFORE moving",
		 "game3d/scripts/combat/diagnostic_bolt.gd",
		 "TECHNIQUE REUSED CLOSELY in the new projectile. The project names the defect explicitly and it "
		 + "would recur verbatim in a second projectile implementation."],
		["RigCorpus.play_guarded and apply_character_treatment", "game3d/scripts/assets/rig_corpus.gd",
		 "REUSED unchanged for the beasts. A missing clip is never a silent no-op."],
		["AssetManifest as the single runtime source of truth", "game3d/scripts/assets/asset_manifest.gd",
		 "REUSED unchanged, and ZERO new assets are imported. The beasts reuse the already-declared Imp."],
		["GroundShadow at the GROUND POINT", "game3d/scripts/view/ground_shadow.gd",
		 "REUSED unchanged for beasts and ballistae, for the reason a rendered frame taught D-370: a fixed "
		 + "isometric view with no contact cue cannot tell 'standing here' from 'standing further away'."],
		["The overlay's DESIGN NAME vs SOURCE CLIP separation", "game3d/scripts/debug/debug_overlay.gd",
		 "APPROACH REUSED in the loadout panel: a borrowed clip is never presented as a designed move, and "
		 + "a diagnostic Imprint is never presented as a canonical Skill."],
		["Suite shape: owed list, both-direction comparison, reached-last-line, negative controls",
		 "game3d/tests/foundation_verification.gd",
		 "STRUCTURE REUSED CLOSELY for the new suite, which is a SECOND suite -- the accepted one is not "
		 + "extended, renamed or renumbered."],
	]

static func new_here() -> Array:
	return [
		"An Imprint Library: permanent, per-character, idempotent learning with one mastery record per Imprint.",
		"A Skill Configuration object enforcing the canonical 4-slot and 1-Transform rules, with explicit failures.",
		"Tag-driven compatibility with a stated reason for every refusal, and a declared tag extension.",
		"A Mastered Rank / Effective Rank split, so levelling an Imprint cannot brick it.",
		"Combat-progress XP awarded ONCE per distinct Imprint, however many Configurations use it.",
		"A bounded catch-up multiplier for a newly obtained low-rank Imprint.",
		"A global Configuration Capacity budget with its sources printed and an explicit over-Capacity result.",
		"A separate Persistent Loadout with reservation from EXACTLY ONE resource, Mana or Life.",
		"A reusable projectile spec that the bow Skill and the ballista BOTH consume -- one framework, not two.",
		"Autonomous minions that follow, acquire and attack with NO command input of any kind.",
		"An in-engine loadout panel with explicit focus navigation, no typed text and no drag precision.",
		"A second verification suite, with the accepted one preserved and re-run as a regression.",
	]
