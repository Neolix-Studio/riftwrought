class_name HoundConfig
extends RefCounted

## RIFTWROUGHT — THE KINDRED HOUNDS STAGE: its own registry (D-396).
##
## ============================================================================
## ONE BOUNDED KINDRED HOUNDS STAGE. IT IS NOT P2, NOT FULL BEASTMASTER
## IMPLEMENTATION, NOT FINAL ART, NOT VFX PRODUCTION AND NOT TUNING.
## ============================================================================
## The owner's ruling, verbatim: "This is explicit owner authorization for one
## bounded Kindred Hounds implementation stage inside game3d/. It is not P2, full
## Beastmaster implementation, final art, VFX production or tuning."
##
## It implements ONE canonical Persistent Skill -- Kindred Hounds (D-385 roster,
## `SKILLS_AND_SKILL_MODIFICATION.md` section 16) -- through the ACCEPTED Imprint
## architecture: learned at rank 1 / 0 XP, sustained by the accepted PERCENTAGE
## reservation, autonomous, targeting by the accepted D-394 ruling 3, recovering
## from a fall through canon's low-friction model.
##
## ---------------------------------------------------------------------------
## THIS IS A FOURTH REGISTRY, NOT A REPLACEMENT.
## ---------------------------------------------------------------------------
## `ProdConfig` (D-373), `ImprintConfig` (D-376 / D-383) and `HuntressConfig`
## (D-394) are UNCHANGED in every numeric value. Every value THIS stage introduces
## is registered below, printed at runtime and asserted PROVISIONAL by the D-396
## suite. NONE IS A LOCK: the owner, "Lock no Capacity, reservation, pack-size,
## range, speed, damage, attack-rate or recovery value."

const DECISION := "D-396"
const DATE := "2026-09-19"
const STAGE := "KINDRED HOUNDS STAGE"

# =============================================================================
# THE REVIEW CANDIDATES. "Choose and disclose one provisional review candidate."
# =============================================================================

## RESERVATION. The owner: "Sustain the pack through the accepted percentage-
## reservation architecture. Choose and disclose one provisional review candidate;
## do not lock it." 20 % of maximum Mana is canon's OWN worked example (SKILLS
## section 15: "500 maximum Mana, 20% reserved = 400 usable Mana"). The per-rank
## step makes rank move a NON-DAMAGE property, as the accepted architecture
## requires, and gives a low Effective Rank a rational use (D-378 OD-04:
## "reservation differences"). PROVISIONAL. NOT A LOCK.
const RESERVE_FRACTION_AT_RANK_1 := 0.20
const RESERVE_FRACTION_PER_RANK := 0.005

## PACK SIZE. "Use two hounds as a provisional review candidate so pack following,
## separation and targeting can actually be judged. This is not a pack-size
## decision." NO modifier changes it: Additional Minion is out of scope.
const PACK_SIZE := 2

## THE TWO HUNTRESS-CENTRED RANGES (D-391 ruling 3). "Choose arena-appropriate
## provisional candidates and disclose them; lock neither." The west chamber is
## 20 x 22 m and the default view shows about 25 x 18 m of ground, so a 9.0 m
## leash keeps an engaged hound on screen. The 3.0 m BAND between the two is what
## keeps a target near either boundary from being dropped and re-taken.
const ACQUISITION_RANGE_M := 6.0
const LEASH_RANGE_M := 9.0

## MOVEMENT. Faster than her 3.889 m/s so the pack keeps up and returns.
const SPEED_MPS := 5.2
## Following: a slot this far from her, this many degrees either side of
## "behind", entered with a speed PROPORTIONAL to the remaining distance (so a
## hound neither stop-starts nor jitters), resumed from rest only past RESUME.
## D-398: THE TRAILING SLOT IS GONE. The shared mobile-minion cohort
## (`scripts/cohort/`) places the hounds in a Vanguard formation round a predictive
## anchor. FOLLOW_DISTANCE_M is its FIRST-RING radius and ARRIVE / RESUME / GAIN are
## its settle mechanics for this member; FOLLOW_SIDE_DEG -- "either side of
## behind" -- is SUPERSEDED FOR TRAVEL, kept as the accepted D-396 record, and no
## longer read. NO VALUE HERE CHANGED.
const FOLLOW_DISTANCE_M := 1.7
const FOLLOW_SIDE_DEG := 55.0
const FOLLOW_ARRIVE_M := 0.30
const FOLLOW_RESUME_M := 0.90
const FOLLOW_GAIN_PER_S := 3.0
## Two hounds closer than this push apart; one engaged beside the other steps
## round its target at this speed, the higher pack index yielding.
const SEPARATION_M := 0.95
const SIDESTEP_MPS := 1.6
## How often a hound re-evaluates its choice with a PATH query. Eligibility and
## the leash are checked every physics step, so an abandonment is immediate.
const THINK_INTERVAL_S := 0.20

## BITES. "Damage, attack interval, movement speed and every other number are
## provisional review candidates." 9 per 0.75 s is 12 per second per hound, 24
## for the pack -- beside Splinter Shot's ~25 -- so the owner can judge whether
## the structure could carry a minion-primary build. NOT balance.
const BITE_DAMAGE_AT_RANK_1 := 9.0
const BITE_DAMAGE_PER_RANK := 0.5
const BITE_INTERVAL_S := 0.75
## How far past body contact a bite reaches, and how far inside that a hound
## stops, so it bites from where it stands.
const BITE_REACH_M := 0.40
const BITE_APPROACH_MARGIN_M := 0.12
const BODY_RADIUS_M := 0.30

## LIFE AND RECOVERY. "Implement the canonical low-friction fallen-hound recovery
## behaviour ... Select and disclose a provisional recovery-delay candidate."
const LIFE := 80.0
const RECOVERY_DELAY_S := 4.0

# =============================================================================
# STRUCTURAL — not tuning.
# =============================================================================

## Its own collision layer. NOTHING masks it (player 4|2, enemies 4|1|2, the
## diagnostic beasts 4, bolts and projectiles 2, the arrow's wall probe 4), so a
## hound can obstruct nobody; it masks the WORLD only.
const COLLISION_LAYER := 16
const COLLISION_MASK_WORLD := 4

## THE ONE INPUT ACTION THIS STAGE ADDS: the ruling's "clearly diagnostic review
## control". Ordinary enemies cannot damage hounds in this slice, so the owner
## needs a way to SEE a hound fall and return. It is NOT a command.
const FALL_ACTION := "diagnostic_hound_fall"
const FALL_SOURCE := "DIAGNOSTIC REVIEW CONTROL — stands in for an enemy area attack; not a command"

const STAND_IN_LABEL := "STAND-IN HOUND — procedural primitives, NOT final art, animation or VFX"
const HUD_TITLE := "KINDRED HOUNDS REVIEW HUD · review tooling, NOT a UI foundation"
const REVIEW_LOADOUT_LABEL := "D-396 KINDRED HOUNDS REVIEW LOADOUT — a DIAGNOSTIC review loadout, not a production loadout"
## The damage-ledger source of a bite, beside the accepted "player_direct",
## "ballista" and "beast".
const LEDGER_SOURCE := "kindred_hound"

# =============================================================================
# DERIVED — each from a registered value, never a new number.
# =============================================================================

static func reserve_fraction_at(rank: int) -> float:
	return RESERVE_FRACTION_AT_RANK_1 + RESERVE_FRACTION_PER_RANK * float(rank - 1)

static func bite_damage_at(rank: int) -> float:
	return BITE_DAMAGE_AT_RANK_1 + BITE_DAMAGE_PER_RANK * float(rank - 1)

## Centre-to-centre planar distance at which a bite lands on a body of radius r.
static func bite_distance(target_radius: float) -> float:
	return target_radius + BODY_RADIUS_M + BITE_REACH_M

## Where an engaging hound stops.
static func approach_distance(target_radius: float) -> float:
	return bite_distance(target_radius) - BITE_APPROACH_MARGIN_M

# =============================================================================
# THE REGISTRY — printed at runtime, asserted by the D-396 suite.
# =============================================================================
static func registry() -> Array:
	return [
		["Kindred Hounds reservation at rank 1 (of max)", RESERVE_FRACTION_AT_RANK_1, "PROVISIONAL REVIEW CANDIDATE (D-396) — canon's own 20 % worked example; NOT a lock"],
		["Kindred Hounds reservation per rank", RESERVE_FRACTION_PER_RANK, "PROVISIONAL — rank moves a non-damage property"],
		["pack size", PACK_SIZE, "PROVISIONAL REVIEW CANDIDATE (D-396) — NOT a pack-size decision"],
		["acquisition range from the Huntress (m)", ACQUISITION_RANGE_M, "PROVISIONAL REVIEW CANDIDATE (D-391 r3 range, D-396 value) — NOT a lock"],
		["leash range from the Huntress (m)", LEASH_RANGE_M, "PROVISIONAL REVIEW CANDIDATE (D-391 r3 range, D-396 value) — NOT a lock"],
		["hound speed (m/s)", SPEED_MPS, "PROVISIONAL — her 3.889 m/s is NOT modified; since D-398 the floor of the catch-up cap"],
		["follow distance (m)", FOLLOW_DISTANCE_M, "PROVISIONAL — since D-398 the Vanguard formation's FIRST-RING radius (the trailing slot is gone)"],
		["follow slot angle from behind (deg)", FOLLOW_SIDE_DEG, "PROVISIONAL — SUPERSEDED FOR TRAVEL (D-398): the Vanguard profile replaces the trailing slot; kept as the accepted D-396 record and NO LONGER READ"],
		["follow arrival tolerance (m)", FOLLOW_ARRIVE_M, "PROVISIONAL — since D-398 the settle tolerance at its formation slot"],
		["follow resume distance (m)", FOLLOW_RESUME_M, "PROVISIONAL — since D-398 the resume distance from its formation slot"],
		["follow speed gain (per s)", FOLLOW_GAIN_PER_S, "PROVISIONAL — since D-398 the tracking gain on the distance to its slot"],
		["separation distance (m)", SEPARATION_M, "PROVISIONAL — since D-398 also the spacing of target-relative attack positions"],
		["sidestep speed (m/s)", SIDESTEP_MPS, "PROVISIONAL — since D-398 the rest push and the step to an attack position"],
		["re-evaluation interval (s)", THINK_INTERVAL_S, "PROVISIONAL"],
		["bite damage at rank 1", BITE_DAMAGE_AT_RANK_1, "PROVISIONAL REVIEW CANDIDATE — NOT balance"],
		["bite damage per rank", BITE_DAMAGE_PER_RANK, "PROVISIONAL — NOT balance"],
		["bite interval (s)", BITE_INTERVAL_S, "PROVISIONAL REVIEW CANDIDATE — NOT an attack-rate lock"],
		["bite reach past contact (m)", BITE_REACH_M, "PROVISIONAL"],
		["bite approach margin (m)", BITE_APPROACH_MARGIN_M, "PROVISIONAL"],
		["hound body radius (m)", BODY_RADIUS_M, "PROVISIONAL"],
		["hound Life", LIFE, "PROVISIONAL"],
		["fallen-hound recovery delay (s)", RECOVERY_DELAY_S, "PROVISIONAL REVIEW CANDIDATE (D-396) — NOT a lock"],
	]

## The canonical rules this stage implements, each cited. Printed at runtime.
static func canonical_rulings() -> Array:
	return [
		["D-385 HD-06", "Kindred Hounds: a Persistent pack sustained by percentage reservation; autonomous, no commands, feeding or care loop; a fallen hound returns through the low-friction recovery model; ordinary enemy AI does not select hounds", "IMPLEMENTED — every number PROVISIONAL"],
		["SKILLS §15", "minions do not physically obstruct the player; persistent minions recover or resummon through a low-friction rule; reservation is not spending", "IMPLEMENTED"],
		["D-391 r3", "two Huntress-centred ranges — a smaller acquisition range, a larger leash range; a dead, invalid, unreachable or beyond-leash target is abandoned", "IMPLEMENTED — 6.0 m / 9.0 m PROVISIONAL"],
		["D-391 r4", "an eligible enemy is alive, hostile, targetable and able to legally receive the Hit; hound engagement also needs a reachable navigation path", "IMPLEMENTED — the general HitEligibility and a path"],
		["D-392 CL-3", "the stable combat-entity ID of the active area", "USED — for exact ties"],
		["D-394 r3", "retain a current valid target; otherwise the nearest reachable eligible enemy to the hound inside the Huntress-centred acquisition range; exact ties by combat-entity ID", "IMPLEMENTED"],
		["D-396 item 9", "an abandoned target: return toward the Huntress or acquire another eligible target; no boundary oscillation or constant switching", "IMPLEMENTED — the owner's instruction, recorded in canon"],
	]

## What this stage denies, individually. Printed every run.
static func denials() -> Array:
	return [
		"The D-396 stage IS NOT P2 and AUTHORIZES NO P2.",
		"The D-396 stage IS NOT full Beastmaster implementation: no Coursing Hounds, Additional Minion, Beast aura, command, feeding or pet management exists.",
		"The D-396 stage implements NO other roster Skill: no Sinew Ballista, Cinder Field, Void Lance, Rift Step or Void Attunement.",
		"The D-396 stage IMPLEMENTS NO RIFT SHARDS, Passives, gear, loot or equipment.",
		"The D-396 hounds are PROCEDURAL STAND-INS — NOT final art, animation or VFX. NO asset or VFX archive is read or used, and NO Ultimate Monsters model.",
		"The D-396 stage LOCKS NO NUMBER: the reservation, pack size, both ranges, speed, bite damage and interval, Life and recovery delay are PROVISIONAL review candidates.",
		"The D-396 hounds read NO designation and NO Huntress's Mark state: they choose by the accepted rule alone (D-394 ruling 3). Huntress's Mark remains a FUTURE concept and is NOT implemented.",
		"The D-396 stage adds NO rarity-based targeting: an Elite or boss is chosen exactly like any other eligible enemy.",
		"Ordinary enemies DO NOT select hounds, and the D-396 stage adds NO enemy attack, hazard or aggro system.",
		"The D-396 diagnostic fall control is a REVIEW CONTROL and NOT a command: it stands in for an enemy area attack and orders nothing.",
		"The D-396 review loadout is a DIAGNOSTIC review loadout, not a production loadout; Capacity is NOT increased (30 + 5 = 35).",
		"The Kindred Hounds review HUD is review tooling and IS NOT a UI foundation.",
		"The D-396 stage modifies NO accepted spike and has NO runtime dependency on the closed D-388 spike.",
		# D-398 (first act): this read "The D-396 stage delivers OPEN pending owner
		# live review; it does NOT accept itself." -- TRUE WHEN WRITTEN, and the state
		# the stage was accepted in. D-397 accepted and closed it; D-397 section 6
		# recommended this reconciliation for the next stage's first act.
		"The D-396 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-397 (its runtime said it delivers OPEN pending owner live review until D-398 reconciled the line — true when written).",
	]

## Printed every run by the D-396 suite. NONE IS A PASS.
static func deferred_rows() -> Array:
	return [
		["KD-01 final hound art, animation and VFX (OWED items 5, 6, 8)", "DEFERRED",
		 "The hounds are PROCEDURAL STAND-INS. RETURNS TO: an asset, animation and VFX pass, with licence review before any intake."],
		["KD-02 final minion / hound HUD presentation (OWED item 4)", "DEFERRED",
		 "The review HUD is tooling. RETURNS TO: a UI foundation."],
		["KD-03 the pack restored with its reservation after the character's death and area transitions (canon)", "DEFERRED",
		 "No death flow and no area transition exists in game3d/. RETURNS TO: a stage that has them."],
		["KD-04 enemy area attacks and hazards damaging hounds (canon: they may)", "DEFERRED",
		 "None exists here, and the ruling forbids adding one to demonstrate hound damage. RETURNS TO: enemy content."],
		["KD-05 the Crownless Warden's behaviour toward hounds (OWED item 15)", "DEFERRED",
		 "No boss exists here. RETURNS TO: a boss stage."],
		["KD-06 Additional Minion and the pack-size decision (OWED items 13, 14)", "OUT OF SCOPE",
		 "Two hounds is a review candidate. RETURNS TO: an owner ruling and tuning."],
		["KD-07 Void Attunement reaching the hounds; Beast auras", "OUT OF SCOPE",
		 "Excluded by the ruling. RETURNS TO: their own stages."],
		["KD-08 Coursing Hounds, Sinew Ballista, Cinder Field, Void Lance, Rift Step — the rest of the roster", "OUT OF SCOPE",
		 "Excluded by the ruling. RETURNS TO: their own stages."],
		["KD-09 Huntress's Mark's increased damage from her Beasts", "OUT OF SCOPE",
		 "A FUTURE concept, not implemented. RETURNS TO: its own ruling and stage."],
		["KD-10 the minion-reservation couplings (OWED item 19)", "DEFERRED",
		 "A bounded Machinations model is RECOMMENDED before any tuning and is NOT AUTHORIZED; nothing here is tuned. RETURNS TO: the owner."],
		["KD-11 minion/enemy distinguishability in PRODUCTION (the D-375 carried debt)", "CARRIED — NOT DISCHARGED",
		 "The stand-ins read by shape at review zoom; that settles nothing for production art. RETURNS TO: a presentation pass."],
		["KD-12 controller HARDWARE behaviour of the new diagnostic input", "DEFERRED",
		 "No gamepad can be attached here. RETURNS TO: owner live review."],
		["KD-13 audio", "DEFERRED",
		 "ZERO audio assets and hooks. RETURNS TO: an audio pass."],
		["KD-14 the D-392 runner's W17 and the D-380 runner's T17 are delivery-time claims", "DECLARED — NOT REPAIRED",
		 "Each proves its own stage's change set against a listing taken before it; after D-396 no listing can satisfy either. tests/hounds_smoke.sh Y15 proves D-396's. RETURNS TO: nowhere — declared."],
		["KD-15 the closed D-388 spike runner's K08 compares its verbatim copies with game3d/'s LIVE modules", "DECLARED — NOT REPAIRED",
		 "D-396 changes prod_config.gd again (the first act); SD-18 already declares it. The spike is preserved, not continued, and NOT edited. RETURNS TO: nowhere — declared."],
		["KD-16 the F2 panel's reservation row still addresses the diagnostic aura", "DECLARED — NOT CHANGED",
		 "The R key drives the Persistent under review; the accepted developer panel is left exactly as accepted. RETURNS TO: a later stage, if the panel is kept."],
	]

## Printed every run by the D-396 suite. NOT a pass and NOT a failure.
##
## ============================================================================
## EMPTY SINCE D-398, AS ITS FIRST ACT — the six rows were ANSWERED UNDER D-397.
## ============================================================================
## From D-396 until D-398 this returned KO-01 ... KO-06 -- TRUE WHEN WRITTEN, and
## the state the stage was accepted in. The owner's D-397 live review answered all
## six directly: "KO-01 through KO-06 are satisfactory at the reviewed two-hound
## scale and current movement speed." They MOVED -- original text preserved
## verbatim -- to `discharged_rows()`. 6 - 6 = 0 owed; 0 + 6 = 6 discharged; 0
## deleted.
static func owed_to_owner() -> Array:
	return []

## The rows the owner ANSWERED, printed every run -- NOT passes. Each row is
## [id, the ORIGINAL owed-row text VERBATIM, disposition, the answer || the
## original text again, in the form every earlier stage's discharged rows use].
const D397_ANSWER := "THE OWNER'S D-397 LIVE REVIEW: ANSWERED DIRECTLY — \"KO-01 through KO-06 are satisfactory at the reviewed two-hound scale and current movement speed.\" Bounded by the owner to TWO hounds at the CURRENT speeds; \"No trial value is locked.\""

static func discharged_rows() -> Array:
	var originals := [
		["KO-01", "Whether the hounds feel autonomous rather than managed."],
		["KO-02", "Whether following, acquisition and leash return feel stable."],
		["KO-03", "Whether two stand-ins remain readable at normal gameplay zoom."],
		["KO-04", "Whether reservation and pack state are understandable."],
		["KO-05", "Whether their attacks structurally feel capable of supporting a minion-primary build."],
		["KO-06", "Whether fallen-hound recovery feels sufficiently low-friction."],
	]
	var out: Array = []
	for r in originals:
		out.append([String(r[0]), String(r[1]), "DISCHARGED — D-397",
			D397_ANSWER + " || ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + String(r[1]) + "'"])
	return out

## Reused or informing implementation, declared truthfully. NOTHING here loads a
## file outside game3d/; the closed D-388 spike is INFORMING, never a dependency.
static func reuse_declaration() -> Array:
	return [
		["the accepted Imprint architecture: learn(), SkillConfiguration, ImprintLoadout, ResourcePool", "game3d/scripts/imprint/ (accepted D-376 / D-383)",
		 "USED UNCHANGED in behaviour: Kindred Hounds is one more Skill Imprint and Configuration; its reservation runs through the accepted pipeline, stage 7 and revalidate()."],
		["HitEligibility and CombatEntityRegistry", "game3d/scripts/huntress/ (accepted D-394)",
		 "USED UNCHANGED: the general enemy-eligibility rule and the area's combat-entity IDs."],
		["NavService.reachable and PathFollower", "game3d/scripts/world/nav_service.gd (accepted D-373)",
		 "USED UNCHANGED: 'you can walk there' is a path that ENDS near the target; planar advance."],
		["the no-obstruction layer technique", "game3d/scripts/imprint/diag_beast.gd (accepted D-376)",
		 "APPROACH REUSED on a NEW layer (16): nothing masks it, and it masks the world only."],
		["a procedural hound stand-in: capsule body, box head and snout, four legs, tail, a segmented ally ring, a dashed target line", "game3d_huntress_spike/scripts/spike/stand_in_hound.gd (CLOSED D-388 spike)",
		 "INFORMED BY, RE-IMPLEMENTED HERE: no file of the spike is loaded, copied or referenced at runtime. Ears, a collar and an H1 / H2 label are added; the spike's name tie-break and single radius are NOT carried."],
		["GroundShadow at the ground point", "game3d/scripts/view/ground_shadow.gd (accepted)",
		 "REUSED UNCHANGED."],
	]

## What this stage does that no earlier stage did.
static func new_here() -> Array:
	return [
		"A second canonical Skill Imprint in the live library — the first PERSISTENT one: Kindred Hounds, learned at rank 1 / 0 XP.",
		"An autonomous pack whose existence follows its Persistent Configuration: removed when unequipped, deactivated or unsupported; restored whole when valid again.",
		"Two Huntress-centred ranges, retention before choice, the nearest reachable eligible enemy from the hound, exact ties by combat-entity ID.",
		"Bites through the enemy's own Hit receiver, attributed in the damage ledger.",
		"Canon's low-friction fallen-hound recovery: automatic, costless, at her side.",
		"A labelled review loadout, and the accepted D-392 loadout restorable exactly.",
		"A compact review HUD for the Persistent state, reservation, pack and targeting reasons.",
	]
