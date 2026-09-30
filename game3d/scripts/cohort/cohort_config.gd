class_name CohortConfig
extends RefCounted

## RIFTWROUGHT — THE MOBILE MINION COHESION STAGE: its own registry (D-398).
##
## ============================================================================
## ONE BOUNDED SHARED MOBILE-MINION COHESION STAGE. IT IS NOT P2, NOT A PACK-SIZE
## INCREASE, NOT A NEW SKILL, NOT FINAL MINION AI, NOT ART, NOT VFX, NOT TUNING.
## ============================================================================
## The owner's ruling, verbatim: "This is explicit owner authorization for one
## bounded shared mobile-minion cohesion stage inside game3d/. This stage
## establishes reusable movement, formation, catch-up and congestion behaviour
## for mobile persistent minions. It is not P2, a pack-size increase, a new
## Skill, final minion AI, art production, VFX work or numerical tuning."
##
## It builds ONE shared cohort system with Kindred Hounds as its ONLY production
## consumer: stable formation slots by combat-entity ID, a loose multi-ring
## Vanguard formation round a predictive anchor, catch-up that scales with her
## speed and the distance behind, congestion pass-through, a harmless soft
## recovery, target-relative melee positions, and regrouping.
##
## ---------------------------------------------------------------------------
## THIS IS A FIFTH REGISTRY, NOT A REPLACEMENT.
## ---------------------------------------------------------------------------
## `ProdConfig` (D-373), `ImprintConfig` (D-376 / D-383), `HuntressConfig`
## (D-394) and `HoundConfig` (D-397) are UNCHANGED in every numeric value. Every
## value THIS stage introduces is registered below, printed at runtime and
## asserted PROVISIONAL by the D-398 suite. NONE IS A LOCK: the owner, "Every
## distance and lead value is provisional" and "Lock no multiplier or threshold."

const DECISION := "D-398"
const DATE := "2026-09-19"
const STAGE := "MOBILE MINION COHESION STAGE"

# =============================================================================
# THE VANGUARD PROFILE — "biased toward the player's movement direction and
# flanks, reducing the likelihood that the player consistently enters danger
# first." Its FIRST-RING RADIUS is the member's own follow distance (for Kindred
# Hounds the accepted D-396 1.7 m), so the ordinary pack stays at her side.
# =============================================================================

## An open lane ahead of her travel: no slot within this half-angle, so she never
## runs into her own pack.
const VANGUARD_LANE_HALF_DEG := 28.0
## The first ring reaches to her flanks ...
const VANGUARD_ARC_HALF_DEG := 100.0
## ... and each further ring wraps this much further round her, to at most:
const VANGUARD_ARC_WIDEN_DEG := 25.0
const VANGUARD_ARC_MAX_DEG := 150.0
## Rings this far apart; slots this far apart along a ring (arc length).
const RING_STEP_M := 1.2
const SLOT_SPACING_M := 1.2
## LOOSE, NOT A RIGID CIRCLE: a fixed, deterministic jitter per slot.
const JITTER_TANGENT_M := 0.12
const JITTER_RADIAL_M := 0.15

# =============================================================================
# THE PREDICTIVE ANCHOR AND THE HEADING — "slightly ahead of the moving player".
# =============================================================================

## Her velocity times this, clamped to the maximum lead, blended in over the blend
## time. While she stands the lead FREEZES; a teleport RESETS it.
const LEAD_TIME_S := 0.25
const LEAD_MAX_M := 1.5
const LEAD_BLEND_S := 0.20
## She counts as moving above this planar speed.
const LEADER_MOVING_MPS := 0.30
## The formation turns toward her travel at this rate -- a reversal SWINGS round
## her, it never flips in one step.
const HEADING_TURN_DEG_PER_S := 300.0
## A jump of her ground point this much farther than her velocity explains, in one
## step, is a TELEPORT: the lead resets and the slots snap.
const TELEPORT_JUMP_M := 0.75

# =============================================================================
# SPEED — "Normal follow movement must keep pace with the player. Catch-up speed
# scales with player speed and separation distance. Lock no multiplier or
# threshold." The tracking gain, arrival and resume values are the MEMBER's own
# (for Kindred Hounds the accepted D-396 3.0 /s, 0.30 m, 0.90 m).
# =============================================================================

## The feed-forward: a member moves with its slot's own velocity times this.
const PACE_RATIO := 1.0
## The catch-up cap: max(the member's base speed, her speed times this) ...
const CATCHUP_SPEED_RATIO := 1.35
## ... times (1 + BOOST x how far behind beyond START, over SPAN, at most 1).
const CATCHUP_DISTANCE_BOOST := 0.6
const CATCHUP_START_M := 1.5
const CATCHUP_SPAN_M := 6.0

# =============================================================================
# CONGESTION — "Preserve local visual separation, but mobile minions must never
# body-block the player. They may ignore minion/minion and minion/player
# collision when congested, returning or catching up."
# =============================================================================

## A member with at least this many other members inside this radius is congested.
const CONGESTION_RADIUS_M := 1.2
const CONGESTION_NEIGHBOURS := 3
## A settled or travelling member keeps this far from her -- VISUAL only; she is
## never stopped by a minion (layer 16 is masked by nothing).
const PLAYER_CLEARANCE_M := 0.8

# =============================================================================
# SOFT RECOVERY — "When pathfinding fails or a minion falls unreasonably far
# behind, perform a harmless soft recovery into a valid unoccupied formation
# slot. It cannot attack or deal damage during that recovery."
# =============================================================================

## Path failure: no path ends within tolerance of its goal, it stands off the
## mesh, or it stalls -- continuously for this long.
const PATH_FAIL_GRACE_S := 0.5
## A path "ends at" its goal within this; a member farther than this from the
## mesh stands off it.
const PATH_END_TOLERANCE_M := 0.6
## A stall: it moved less than this in this window while trying to move.
const STALL_WINDOW_S := 1.2
const STALL_MIN_MOVE_M := 0.35
## Far behind: farther than this from her for this long ...
const FAR_BEHIND_M := 14.0
const FAR_BEHIND_GRACE_S := 0.25
## ... or regrouping for longer than this.
const REGROUP_TIMEOUT_S := 3.5
## The recovery fades out where it stands, is relocated, and fades in.
const RECOVERY_OUT_S := 0.15
const RECOVERY_IN_S := 0.35
## A slot is VALID when walkable within this of its ideal point, and reachable
## from her by a path no longer than RATIO x the straight distance + SLACK.
const SLOT_VALID_TOLERANCE_M := 0.6
const PATH_DETOUR_RATIO := 1.6
const PATH_DETOUR_SLACK_M := 1.5

# =============================================================================
# TARGET-RELATIVE MELEE POSITIONS — "Melee minions use stable target-relative
# attack positions rather than stacking at one point inside the target." The
# ring radius is the member's approach distance and the spacing its separation
# (for Kindred Hounds the accepted D-396 values).
# =============================================================================

## Members beyond the ring's capacity WAIT on a ring this much farther out.
const ATTACK_WAIT_STEP_M := 0.9
## A member is at its attack position within this.
const ATTACK_ARRIVE_M := 0.2

# =============================================================================
# WALKABLE GROUND — a slot is clamped along the straight line from the anchor.
# =============================================================================

const WALKABLE_SAMPLE_M := 0.35
const ON_MESH_M := 0.12

# =============================================================================
# THE DIAGNOSTIC MODES — "diagnostic stress modes for 2, 6, 10 and 15 mobile
# minions and provisional travel-speed modes representing ordinary, fast and
# extreme late-game movement. These modes must not change the canonical pack
# size, reservation, Capacity, damage or Skill definition."
# =============================================================================

## The four populations. The first is the ordinary pack: NO stress minion.
const POPULATIONS := [2, 6, 10, 15]
## Her accepted top speed times these. ORDINARY is exactly the accepted speed.
const SPEED_SCALE_FAST := 1.8
const SPEED_SCALE_EXTREME := 3.0

## The two diagnostic review controls. NOT commands: nothing in scripts/hounds/
## reads them, and neither addresses a minion.
const POPULATION_ACTION := "diagnostic_stress_population"
const SPEED_ACTION := "diagnostic_travel_speed"
const CONTROL_SOURCE := "DIAGNOSTIC REVIEW CONTROL — a stress-test mode for the owner's review; not a command"

## The damage-ledger source of a DIAGNOSTIC STRESS MINION's bite, so the
## canonical `kindred_hound` ledger only ever holds Kindred Hounds.
const STRESS_LEDGER_SOURCE := "diagnostic_stress_minion"
const STRESS_LABEL := "DIAGNOSTIC STRESS MINION — the Kindred Hound stand-in, NOT a pack-size change"
const HUD_TITLE := "COHESION REVIEW HUD (D-398) · review tooling, NOT a UI foundation"

## THE STAGE'S READING OF RULING ITEM 9, disclosed for the owner to overrule.
##
## D-399 RULED ON IT, 2026-09-20: "The 9 m disengage / 6 m reacquire
## interpretation of regrouping overriding combat is accepted." THE SHAPE of the
## rule is canon -- disengage at the accepted leash, reacquire at the accepted
## acquisition range, the band between them giving the hysteresis -- and THE TWO
## DISTANCES ARE NOT LOCKED. The text below is PRESERVED VERBATIM as the reading
## that was put and accepted; it is no longer an open question.
const REGROUP_READING := "REGROUP READING (D-398, for the owner to confirm or overrule): 'When the player exceeds the leash, regrouping overrides combat' is read as — when SHE is farther than the accepted leash from the MEMBER, it abandons its target and acquires nothing until it is back inside the accepted acquisition range of her. No new distance is introduced; a member inside the leash keeps D-396's behaviour exactly."

## ADDED UNDER D-400, AS THE FIRST ACT: the reading's STATUS, printed beside it.
const REGROUP_READING_STATUS := "REGROUP READING STATUS (D-399, 2026-09-20): RULED. The owner: \"The 9 m disengage / 6 m reacquire interpretation of regrouping overriding combat is accepted.\" The SHAPE of the rule is canon — disengage at the accepted leash, reacquire at the accepted acquisition range, the band between them giving the hysteresis. THE TWO DISTANCES THEMSELVES ARE NOT LOCKED, and no new distance was ever introduced."

static func speed_modes() -> Array:
	return [["ORDINARY", 1.0], ["FAST", SPEED_SCALE_FAST], ["EXTREME", SPEED_SCALE_EXTREME]]

# =============================================================================
# DERIVED — each from a registered value, never a new number.
# =============================================================================

## The cap on a member's speed: it rises with her speed and with how far behind
## its slot the member is. PURE. The suite proves it monotonic both ways.
static func catchup_cap(base_speed: float, leader_speed: float, behind_m: float) -> float:
	var base := maxf(base_speed, leader_speed * CATCHUP_SPEED_RATIO)
	var boost := clampf((behind_m - CATCHUP_START_M) / CATCHUP_SPAN_M, 0.0, 1.0)
	return base * (1.0 + CATCHUP_DISTANCE_BOOST * boost)

# =============================================================================
# THE REGISTRY — printed at runtime, asserted by the D-398 suite.
# =============================================================================
static func registry() -> Array:
	return [
		["Vanguard open lane ahead (half-angle, deg)", VANGUARD_LANE_HALF_DEG, "PROVISIONAL — no slot inside it"],
		["Vanguard first-ring arc (half-angle, deg)", VANGUARD_ARC_HALF_DEG, "PROVISIONAL — reaches her flanks"],
		["Vanguard arc widening per ring (deg)", VANGUARD_ARC_WIDEN_DEG, "PROVISIONAL — density-aware"],
		["Vanguard arc limit (half-angle, deg)", VANGUARD_ARC_MAX_DEG, "PROVISIONAL"],
		["ring step (m)", RING_STEP_M, "PROVISIONAL"],
		["slot spacing along a ring (m)", SLOT_SPACING_M, "PROVISIONAL"],
		["slot jitter, tangential (m)", JITTER_TANGENT_M, "PROVISIONAL — loose, deterministic"],
		["slot jitter, radial (m)", JITTER_RADIAL_M, "PROVISIONAL — loose, deterministic"],
		["anchor lead time (s)", LEAD_TIME_S, "PROVISIONAL — a lead value; NOT a lock"],
		["anchor maximum lead (m)", LEAD_MAX_M, "PROVISIONAL — a lead value; NOT a lock"],
		["anchor lead blend (s)", LEAD_BLEND_S, "PROVISIONAL"],
		["she counts as moving above (m/s)", LEADER_MOVING_MPS, "PROVISIONAL"],
		["formation turn rate (deg/s)", HEADING_TURN_DEG_PER_S, "PROVISIONAL"],
		["teleport jump (m)", TELEPORT_JUMP_M, "PROVISIONAL"],
		["pace ratio (feed-forward)", PACE_RATIO, "PROVISIONAL — a multiplier; NOT a lock"],
		["catch-up speed ratio to hers", CATCHUP_SPEED_RATIO, "PROVISIONAL — a multiplier; NOT a lock"],
		["catch-up distance boost", CATCHUP_DISTANCE_BOOST, "PROVISIONAL — a multiplier; NOT a lock"],
		["catch-up starts behind (m)", CATCHUP_START_M, "PROVISIONAL — a threshold; NOT a lock"],
		["catch-up boost span (m)", CATCHUP_SPAN_M, "PROVISIONAL — a threshold; NOT a lock"],
		["congestion radius (m)", CONGESTION_RADIUS_M, "PROVISIONAL — a threshold; NOT a lock"],
		["congestion neighbours", CONGESTION_NEIGHBOURS, "PROVISIONAL — a threshold; NOT a lock"],
		["clearance from her, visual (m)", PLAYER_CLEARANCE_M, "PROVISIONAL — never stops her"],
		["path-failure grace (s)", PATH_FAIL_GRACE_S, "PROVISIONAL — a threshold; NOT a lock"],
		["path end / off-mesh tolerance (m)", PATH_END_TOLERANCE_M, "PROVISIONAL"],
		["stall window (s)", STALL_WINDOW_S, "PROVISIONAL"],
		["stall minimum movement (m)", STALL_MIN_MOVE_M, "PROVISIONAL"],
		["far behind her (m)", FAR_BEHIND_M, "PROVISIONAL — a threshold; NOT a lock"],
		["far-behind grace (s)", FAR_BEHIND_GRACE_S, "PROVISIONAL"],
		["regroup timeout (s)", REGROUP_TIMEOUT_S, "PROVISIONAL — a threshold; NOT a lock"],
		["soft recovery fade-out (s)", RECOVERY_OUT_S, "PROVISIONAL — presentation-length; NOT final VFX"],
		["soft recovery fade-in (s)", RECOVERY_IN_S, "PROVISIONAL — presentation-length; NOT final VFX"],
		["valid slot tolerance (m)", SLOT_VALID_TOLERANCE_M, "PROVISIONAL"],
		["path detour ratio", PATH_DETOUR_RATIO, "PROVISIONAL"],
		["path detour slack (m)", PATH_DETOUR_SLACK_M, "PROVISIONAL"],
		["waiting ring beyond the attack ring (m)", ATTACK_WAIT_STEP_M, "PROVISIONAL"],
		["attack position arrival (m)", ATTACK_ARRIVE_M, "PROVISIONAL"],
		["walkable sample step (m)", WALKABLE_SAMPLE_M, "PROVISIONAL"],
		["on-mesh tolerance (m)", ON_MESH_M, "PROVISIONAL"],
		["FAST travel speed (x her 3.889 m/s)", SPEED_SCALE_FAST, "PROVISIONAL DIAGNOSTIC MODE — NOT her speed; NOT a lock"],
		["EXTREME travel speed (x her 3.889 m/s)", SPEED_SCALE_EXTREME, "PROVISIONAL DIAGNOSTIC MODE — NOT her speed; NOT a lock"],
	]

## The owner's twelve items, each cited with its disposition. Printed at runtime.
static func canonical_rulings() -> Array:
	return [
		["D-398 item 1", "mobile persistent minions occupy stable formation slots, not one point in a line", "IMPLEMENTED"],
		["D-398 item 2", "loose, density-aware multi-ring formations — not a rigid perfect circle", "IMPLEMENTED — every value PROVISIONAL"],
		["D-398 item 3", "Kindred Hounds use a Vanguard profile biased toward her movement direction and flanks", "IMPLEMENTED — PROVISIONAL"],
		["D-398 item 4", "the travelling formation rests on a predictive anchor slightly ahead of the moving player", "IMPLEMENTED — every distance and lead PROVISIONAL"],
		["D-398 item 5", "stable combat-entity IDs determine slot assignment and exact ties", "IMPLEMENTED — members registered in the area as ALLIES"],
		["D-398 item 6", "normal follow keeps pace; catch-up scales with her speed and the separation distance", "IMPLEMENTED — no multiplier or threshold locked"],
		["D-398 item 7", "local visual separation; never body-block her; ignore minion/minion and minion/player collision when congested, returning or catching up", "IMPLEMENTED"],
		["D-398 item 8", "path failure or unreasonably far behind: a harmless soft recovery into a valid unoccupied formation slot; no attack or damage during it", "IMPLEMENTED — PROVISIONAL"],
		["D-398 item 9", "in combat, minions leave formation under D-396's accepted target-selection and leash rules; when she exceeds the leash, regrouping overrides combat", "IMPLEMENTED — the regroup READING is disclosed"],
		["D-398 item 10", "melee minions use stable target-relative attack positions, no stacking", "IMPLEMENTED — PROVISIONAL"],
		["D-398 item 11", "after combat, minions reform without a command", "IMPLEMENTED"],
		["D-398 item 12", "D-396's ordinary two-hound pack and its provisional values unchanged; higher populations diagnostic only", "PRESERVED — proved by the D-398 suite"],
	]

## What this stage denies, individually. Printed every run.
static func denials() -> Array:
	return [
		"The D-398 stage IS NOT P2 and AUTHORIZES NO P2.",
		"The D-398 stage IS NOT a pack-size increase: the canonical Kindred Hounds pack stays TWO, and populations of 6, 10 and 15 are DIAGNOSTIC STRESS MODES only.",
		"The D-398 stage adds NO Additional Minion and NO real pack-size progression.",
		"The D-398 stage IS NOT a new Skill: no Coursing Hounds, Sinew Ballista or other Skill exists.",
		"The D-398 stage implements NO Ranged or Support minion behaviour: the profile type and the role enum are the extension point, and only the MELEE Vanguard exists.",
		"The D-398 stage IS NOT final minion AI: it is a movement, formation, catch-up and congestion foundation.",
		"The D-398 stage adds NO designation or target preference of any kind, and does NOT implement Huntress's Mark.",
		"The D-398 stage adds NO command, stance, feeding or pet management; the two diagnostic controls are REVIEW CONTROLS and NOT commands.",
		"The D-398 stage changes NO minion damage, reservation, Capacity or recovery value, and NO accepted constant.",
		"The D-398 stage adds NO final minion model, animation, audio or VFX; the soft-recovery fade is a PLACEHOLDER.",
		"The D-398 stage adds NO Rift Shards, Passives, equipment, loot or campaign content.",
		"The D-398 stage LOCKS NO NUMBER: every formation, lead, turn, catch-up, congestion, recovery and attack-position value is PROVISIONAL.",
		"The D-398 travel-speed modes are DIAGNOSTIC: her accepted 3.889 m/s is unchanged, and ORDINARY is exactly it.",
		"The D-398 stage decides NO distribution or focus rule: each member still chooses its own target by the accepted rule.",
		"The mobile minion cohesion review HUD is review tooling and IS NOT a UI foundation.",
		"The D-398 stage modifies NO accepted spike and has NO runtime dependency outside game3d/.",
		"The D-398 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-399. (This row read 'The D-398 stage delivers OPEN pending owner live review; it does NOT accept itself.' from D-398 until D-400's first act, and it was TRUE WHEN WRITTEN.)",
	]

## Printed every run by the D-398 suite. NONE IS A PASS.
static func deferred_rows() -> Array:
	return [
		["CD-01 final minion AI", "DEFERRED",
		 "The cohort is a movement, formation, catch-up and congestion foundation, not the final behaviour. RETURNS TO: a later stage."],
		["CD-02 Ranged and Support minion profiles", "OUT OF SCOPE",
		 "An extension point only — the profile type and the role enum; none exists. RETURNS TO: their own stages."],
		["CD-03 Additional Minion and any real pack-size progression (KD-06 stands)", "OUT OF SCOPE",
		 "Populations above 2 are DIAGNOSTIC STRESS MODES only. RETURNS TO: an owner ruling and tuning."],
		["CD-04 numerical tuning of every formation, lead, turn, catch-up, congestion, recovery and attack-position value", "DEFERRED",
		 "None is locked. RETURNS TO: a tuning pass."],
		["CD-05 final minion models, animation, audio and VFX, the soft-recovery fade included", "DEFERRED",
		 "The stand-ins and the fade are PLACEHOLDERS. RETURNS TO: an asset, animation, audio and VFX pass."],
		["CD-06 performance at production scale", "DEFERRED",
		 "Measured here only in the test arena, with one pack. RETURNS TO: a performance pass."],
		["CD-07 a distribution / focus rule for many minions on one target", "NOT DECIDED",
		 "The waiting ring is structure, not a distribution rule. RETURNS TO: the owner."],
		["CD-08 D-371's crowd-avoidance / density risk (enemy crowds)", "CARRIED — NOT DISCHARGED",
		 "Related to, not the same as, the pack-cohesion risk this stage addresses. RETURNS TO: a crowd-avoidance stage."],
		["CD-09 controller HARDWARE behaviour of the two new diagnostic inputs", "DEFERRED",
		 "No gamepad can be attached here. RETURNS TO: owner live review."],
		["CD-10 the D-396 runner's Y15, the D-392 runner's W17 and the D-380 runner's T17 are delivery-time claims", "DECLARED — NOT REPAIRED",
		 "Each proves its own stage's change set against a listing taken before it; none can pass after D-398. tests/cohesion_smoke.sh Z16 proves D-398's. RETURNS TO: nowhere — declared."],
		["CD-11 the closed D-388 spike runner's K08 compares its verbatim copies with game3d/'s LIVE modules", "DECLARED — NOT REPAIRED",
		 "D-398 changes prod_config.gd (the first act) and player_controller.gd (the travel-speed seam); SD-18 and KD-15 already declare both. The spike is preserved, not continued, and NOT edited. RETURNS TO: nowhere — declared."],
		["CD-12 the camera at extreme speed", "DEFERRED",
		 "Its accepted follow lag is not tuned for it. RETURNS TO: a camera pass."],
		["CD-13 the pack after the character's death and area transitions (KD-03)", "DEFERRED",
		 "No death flow and no area transition exists in game3d/. RETURNS TO: a stage that has them."],
		["CD-14 enemy attacks, hazards and the Warden's behaviour toward minions (KD-04, KD-05)", "DEFERRED",
		 "None exists here. RETURNS TO: enemy content and a boss stage."],
		["CD-15 minion/enemy distinguishability in PRODUCTION (KD-11)", "CARRIED — NOT DISCHARGED",
		 "Fifteen stand-ins read by shape at review zoom; that settles nothing for production art. RETURNS TO: a presentation pass."],
		["CD-16 the pre-existing 36 / 35 LIFE CONVERSION overflow in the accepted D-392 loadout", "DECLARED — NOT REPAIRED",
		 "Disclosed at D-396 and not authorized for repair. RETURNS TO: a later stage, if authorized."],
	]

## ============================================================================
## MOVED UNDER D-400, AS THE FIRST ACT OF THE PLAYER LOCOMOTION REDIRECTION
## STAGE. 5 - 5 = 0 owed; 0 + 5 = 5 discharged; 0 DELETED.
## ============================================================================
## THE OWNER ANSWERED THESE FIVE DIRECTLY, UNDER D-399, and D-400's ruling
## authorizes the reconciliation: "First reconcile D-398's accepted state and
## update all related truthfulness pins together." So the five rows move, with
## their ORIGINAL TEXT PRESERVED VERBATIM, to `discharged_rows()`, each carrying
## the owner's OWN WORDS -- including the qualifiers "appropriately",
## "problematic" and "acceptably", which are preserved as given and NOT smoothed.
static func owed_to_owner() -> Array:
	return []

## ============================================================================
## THE OWNER'S OWN WORDS, AT THE LEVEL THEY WERE GIVEN AT.
## ============================================================================
## D-399's ruling, verbatim: "The pack stays appropriately around or ahead of me,
## avoids problematic trailing, handles congestion acceptably, transitions
## cleanly between combat and travel, and recovers unobtrusively at extreme
## speed." Each clause answers one row, in order, and THE QUALIFIERS ARE
## PRESERVED AS GIVEN -- "appropriately", "problematic", "acceptably" are the
## owner's words and are not smoothed into unqualified praise.
##
## D-399 also bounds what the answers do NOT do: "No diagnostic population,
## speed, formation, leash, recovery or other numerical value is locked", and
## "Doorway bunching, target obscuration, wall-lopsided formations and HUD
## overlap remain findings rather than blockers."
const D399_ANSWER := "THE OWNER'S D-399 LIVE REVIEW: ANSWERED DIRECTLY. \"No diagnostic population, speed, formation, leash, recovery or other numerical value is locked\", and \"doorway bunching, target obscuration, wall-lopsided formations and HUD overlap remain findings rather than blockers.\""

## The rows the owner's acceptance closed, printed every run -- NOT passes. Each
## row is [id, the ORIGINAL owed-row text VERBATIM, disposition, the answer ||
## the original text again, in the form every earlier stage's discharged rows use].
static func discharged_rows() -> Array:
	var originals := [
		["CO-01", "Whether the pack stays around or ahead of her.",
		 "the pack \"stays appropriately around or ahead of me\""],
		["CO-02", "Whether it avoids trailing behind.",
		 "it \"avoids problematic trailing\""],
		["CO-03", "Whether it handles congestion.",
		 "it \"handles congestion acceptably\""],
		["CO-04", "Whether it transitions cleanly between combat and travel.",
		 "it \"transitions cleanly between combat and travel\""],
		["CO-05", "Whether it recovers unobtrusively at extreme speed.",
		 "it \"recovers unobtrusively at extreme speed\""],
	]
	var out: Array = []
	for r in originals:
		out.append([String(r[0]), String(r[1]), "DISCHARGED — D-399",
			"THE OWNER'S ANSWER, VERBATIM: " + String(r[2]) + ". " + D399_ANSWER
			+ " || ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + String(r[1]) + "'"])
	return out

## The accepted D-396 values the cohort uses or supersedes, declared.
static func d396_values_declaration() -> Array:
	return [
		["HoundConfig.FOLLOW_DISTANCE_M (1.7 m)", "IN USE — the Vanguard's first-ring radius"],
		["HoundConfig.FOLLOW_ARRIVE_M / FOLLOW_RESUME_M / FOLLOW_GAIN_PER_S (0.30 m / 0.90 m / 3.0 per s)", "IN USE — the member's settle and tracking values"],
		["HoundConfig.SPEED_MPS (5.2 m/s)", "IN USE — the member's base speed, the engage speed and the floor of the catch-up cap"],
		["HoundConfig.SEPARATION_M (0.95 m)", "IN USE — local visual separation and the attack-position spacing"],
		["HoundConfig.SIDESTEP_MPS (1.6 m/s)", "IN USE — the rest push and the step to an attack position"],
		["HoundConfig.FOLLOW_SIDE_DEG (55 deg from behind)", "SUPERSEDED FOR TRAVEL — the trailing slot is gone; kept as the accepted D-396 record and NO LONGER READ"],
		["HoundConfig.ACQUISITION_RANGE_M / LEASH_RANGE_M (6.0 m / 9.0 m)", "IN USE — the accepted rule, and the regroup trigger and release (no new distance)"],
		["every other HoundConfig value", "UNCHANGED and used as accepted"],
	]

## Reused or informing implementation, declared truthfully. NOTHING here loads a
## file outside game3d/.
static func reuse_declaration() -> Array:
	return [
		["the accepted Kindred Hounds actor, targeting rule, bites, recovery and review loadout", "game3d/scripts/hounds/ (accepted D-397)",
		 "REUSED: the hound stays the consumer — it chooses, bites and falls by the accepted rules; it asks the cohort where to stand and how fast to move."],
		["CombatEntityRegistry and HitEligibility", "game3d/scripts/huntress/ (accepted D-394)",
		 "USED UNCHANGED: members are registered as ALLIES; the general rule refuses them."],
		["NavService, PathFollower and the navigation map", "game3d/scripts/world/nav_service.gd (accepted D-373)",
		 "USED UNCHANGED: walkable clamps, reachability and paths."],
		["the accepted locomotion and top speed", "game3d/scripts/control/ (accepted D-373)",
		 "USED UNCHANGED at 1.0: one declared diagnostic scale on the controller for the speed modes."],
	]

## What this stage does that no earlier stage did.
static func new_here() -> Array:
	return [
		"A shared mobile-minion cohort: stable formation slots by combat-entity ID round a predictive anchor, in a loose multi-ring Vanguard formation.",
		"Pace-keeping by feed-forward, and a catch-up cap that rises with her speed and the distance behind.",
		"Congestion pass-through, local visual separation, and a visual clearance from her that never stops her.",
		"A harmless soft recovery into a valid, unoccupied formation slot on path failure or when far behind.",
		"Stable target-relative melee attack positions with a waiting ring, and regrouping that overrides combat when she exceeds the leash.",
		"Diagnostic stress populations (2, 6, 10, 15) and travel speeds (ordinary, fast, extreme) with two review controls and a compact review HUD.",
	]
