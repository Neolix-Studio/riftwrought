class_name HuntressConfig
extends RefCounted

## RIFTWROUGHT — THE HUNTRESS SPLINTER SHOT STAGE: its own registry (D-392).
##
## ============================================================================
## THE FIRST BOUNDED HUNTRESS IMPLEMENTATION STAGE. IT IS NOT P2, NOT CAMPAIGN
## PRODUCTION, NOT FINAL ANIMATION, NOT FINAL VFX AND NOT THE FULL HUNTRESS.
## ============================================================================
## The owner's ruling, verbatim: "This is explicit owner authorization for one
## bounded first Huntress implementation stage inside game3d/. It is not P2,
## campaign production, final animation, final VFX or full Huntress
## implementation."
##
## It implements ONE canonical Skill -- Splinter Shot, her ordinary shot (D-391
## ruling 1) -- through the ACCEPTED Imprint architecture, with the ruled facing
## snap (D-391 ruling 2), one arrow resolved by time of impact (D-391 ruling 5),
## enemy (Hit) eligibility (D-391 ruling 4, a general combat rule) and a stable
## combat-entity ID (D-392 clarification 3). The owner's D-393 correction removed
## the class's former signature mechanic from the design and from this stage.
##
## ---------------------------------------------------------------------------
## THIS IS A THIRD REGISTRY, NOT A REPLACEMENT.
## ---------------------------------------------------------------------------
## `ProdConfig` holds the accepted D-373 baseline and `ImprintConfig` the accepted
## D-375/D-380 stages; NOT ONE OF THEIR VALUES IS CHANGED. Every value this stage
## introduces is registered here, printed at runtime, and asserted PROVISIONAL,
## DERIVED or MEASURED by the D-392 suite. NONE IS A LOCK.

const DECISION := "D-392"
const DATE := "2026-09-19"
const STAGE := "HUNTRESS SPLINTER SHOT STAGE"

# =============================================================================
# SPLINTER SHOT — TIMING. THE RULING: "Use approximately 0.5 seconds to release
# ONLY as the next provisional review candidate. Do not lock timing, playback
# rate, attack-speed scaling or recovery length."
# =============================================================================

## The release, from the start of the Skill Use. D-390 ruling 1's candidate
## (roughly the D-388 spike's x2.00), made Splinter Shot's by D-391 ruling 1.
## A PROVISIONAL REVIEW CANDIDATE. NOT a lock, NOT attack speed.
const SPLINTER_RELEASE_S := 0.50

## The mechanical recovery after the release, DERIVED rather than chosen: the
## accepted diagnostic bolt's own post-release share of its action --
## ATTACK_COOLDOWN_S x (1 - ATTACK_RELEASE_MARKER) = 0.45 x 0.64 = 0.288 s -- the
## recovery the owner judged "immediate and fluid" at D-373. PROVISIONAL.
static func splinter_recovery_s() -> float:
	return ProdConfig.ATTACK_COOLDOWN_S * (1.0 - ProdConfig.ATTACK_RELEASE_MARKER)

## The whole mechanical action: release + recovery. DERIVED.
static func splinter_action_s() -> float:
	return SPLINTER_RELEASE_S + splinter_recovery_s()

## The release as a fraction of the action -- what the ACCEPTED commitment is
## handed. DERIVED; mechanical timing, never animation timing.
static func splinter_release_marker() -> float:
	return SPLINTER_RELEASE_S / splinter_action_s()

# =============================================================================
# SPLINTER SHOT — COMBAT. Every value PROVISIONAL. None is a balance lock.
# =============================================================================
## Canon: "a bow-fired Physical projectile with straightforward baseline
## behavior" (SKILLS section 16). The damage is sized so an ordinary enemy takes
## several shots -- long enough to REVIEW designation and replacement.
const SPLINTER_DAMAGE_AT_RANK_1 := 20.0
const SPLINTER_DAMAGE_PER_RANK := 1.2
## Canon: "A reasonable early primary skill should generally be sustainable"
## (ATTRIBUTES, Mana Design Goals). At one use per action this is well inside
## the prototype's regeneration.
const SPLINTER_MANA_AT_RANK_1 := 6.0
const SPLINTER_MANA_PER_RANK := 0.2
## An Attack paced by its action time: "holding a repeatable skill continues
## using it" (combat section 12). No separate cooldown.
const SPLINTER_COOLDOWN_S := 0.0

# --- The arrow. PROVISIONAL. --------------------------------------------------
## Carried from the D-388 spike's DIAGNOSTIC value and relabelled PROVISIONAL.
const ARROW_SPEED_MPS := 28.0
const ARROW_RANGE_M := 18.0
## The arrow's own collision radius on the plane.
const ARROW_RADIUS_M := 0.10
## D-391 ruling 5: "A mathematical tie within collision tolerance is resolved by
## a stable combat-entity ID ... No tolerance value is locked." Measured along
## the swept path, in metres.
const COLLISION_TIE_TOLERANCE_M := 0.001
## The height at which WORLD GEOMETRY is swept. The simulation is a plane (combat
## section 0.2): this is a probe height inside every blocking collider, never a
## gameplay coordinate.
const WALL_PROBE_HEIGHT_M := 0.5
const TRAIL_SECONDS := 0.14

# --- Facing. D-391 ruling 2: "No turn speed or blend duration is locked." ------
## The release-time tolerance within which the VISUAL counts as aligned with the
## MECHANICAL facing. The blend itself is the ACCEPTED continuous yaw at
## ProdConfig.YAW_RATE_DEG_PER_S (720, PROVISIONAL) -- no second turn rate.
const VISUAL_ALIGN_TOLERANCE_DEG := 1.0

# =============================================================================
# THE PLACEHOLDER ANIMATION — ported from the accepted D-388 spike.
# =============================================================================
## The owner: "The CC0 KayKit bow clips and the D-388 retarget/hand-contact
## approach may be ported only as explicitly temporary placeholder animation.
## Preserve provenance. Do not present them as final production animation or fix
## the five accepted polish debts."
const ANIMATION_LABEL := "TEMPORARY PLACEHOLDER ANIMATION — KayKit bow clips (CC0), retargeted onto the current 65-joint Huntress with the D-388 approach — NOT final animation"
const PRESENTATION_LABEL := "PLACEHOLDER bow, procedural string, arrow, trail and impact — NOT final art, attachment or VFX"

const CLIP_BOW_IDLE := "Ranged_Bow_Idle"
const CLIP_AIM_IDLE := "Ranged_Bow_Aiming_Idle"
const CLIP_DRAW := "Ranged_Bow_Draw"
const CLIP_RELEASE := "Ranged_Bow_Release"
const CLIP_RUN_BOW := "Running_HoldingBow"
## THE ONLY CLIPS THAT MAY BE SAMPLED. Every other clip in the two files -- and
## D-388's two `_Up` clips, which this stage does not need -- is REFUSED.
const AUTHORIZED_CLIPS := [CLIP_BOW_IDLE, CLIP_AIM_IDLE, CLIP_DRAW, CLIP_RELEASE, CLIP_RUN_BOW]

## Profile bone (SkeletonProfileHumanoid) -> KayKit Medium rig bone. D-388's map,
## unchanged: KayKit `chest` is mapped to UpperChest, the bone both rigs hang
## their arms from.
const MAP_KAYKIT := {
	"Root": "root", "Hips": "hips", "Spine": "spine", "UpperChest": "chest", "Head": "head",
	"LeftUpperArm": "upperarm.l", "LeftLowerArm": "lowerarm.l", "LeftHand": "hand.l",
	"RightUpperArm": "upperarm.r", "RightLowerArm": "lowerarm.r", "RightHand": "hand.r",
	"LeftUpperLeg": "upperleg.l", "LeftLowerLeg": "lowerleg.l", "LeftFoot": "foot.l", "LeftToes": "toes.l",
	"RightUpperLeg": "upperleg.r", "RightLowerLeg": "lowerleg.r", "RightFoot": "foot.r", "RightToes": "toes.r",
}
## Profile bone -> the Huntress's (Quaternius, UE-mannequin naming) bone.
const MAP_HUNTRESS := {
	"Root": "root", "Hips": "pelvis", "Spine": "spine_01", "Chest": "spine_02", "UpperChest": "spine_03",
	"Neck": "neck_01", "Head": "Head",
	"LeftShoulder": "clavicle_l", "LeftUpperArm": "upperarm_l", "LeftLowerArm": "lowerarm_l", "LeftHand": "hand_l",
	"RightShoulder": "clavicle_r", "RightUpperArm": "upperarm_r", "RightLowerArm": "lowerarm_r", "RightHand": "hand_r",
	"LeftThumbMetacarpal": "thumb_01_l", "LeftThumbProximal": "thumb_02_l", "LeftThumbDistal": "thumb_03_l",
	"LeftIndexProximal": "index_01_l", "LeftIndexIntermediate": "index_02_l", "LeftIndexDistal": "index_03_l",
	"LeftMiddleProximal": "middle_01_l", "LeftMiddleIntermediate": "middle_02_l", "LeftMiddleDistal": "middle_03_l",
	"LeftRingProximal": "ring_01_l", "LeftRingIntermediate": "ring_02_l", "LeftRingDistal": "ring_03_l",
	"LeftLittleProximal": "pinky_01_l", "LeftLittleIntermediate": "pinky_02_l", "LeftLittleDistal": "pinky_03_l",
	"RightThumbMetacarpal": "thumb_01_r", "RightThumbProximal": "thumb_02_r", "RightThumbDistal": "thumb_03_r",
	"RightIndexProximal": "index_01_r", "RightIndexIntermediate": "index_02_r", "RightIndexDistal": "index_03_r",
	"RightMiddleProximal": "middle_01_r", "RightMiddleIntermediate": "middle_02_r", "RightMiddleDistal": "middle_03_r",
	"RightRingProximal": "ring_01_r", "RightRingIntermediate": "ring_02_r", "RightRingDistal": "ring_03_r",
	"RightLittleProximal": "pinky_01_r", "RightLittleIntermediate": "pinky_02_r", "RightLittleDistal": "pinky_03_r",
	"LeftUpperLeg": "thigh_l", "LeftLowerLeg": "calf_l", "LeftFoot": "foot_l", "LeftToes": "ball_l",
	"RightUpperLeg": "thigh_r", "RightLowerLeg": "calf_r", "RightFoot": "foot_r", "RightToes": "ball_r",
}
## DERIVED bones: [huntress bone, profile neighbour A, profile neighbour B].
const DERIVED := [
	["spine_02", "Spine", "UpperChest"],
	["neck_01", "UpperChest", "Head"],
]
const UNMAPPED_SOURCE := {
	"wrist.l": "absorbed — the mapped hand.l's model-space rotation already includes it",
	"wrist.r": "absorbed — the mapped hand.r's model-space rotation already includes it",
	"handslot.l": "an attachment reference on the KayKit rig; not used here",
	"handslot.r": "an attachment reference on the KayKit rig; not used here",
}

## The draw timeline's MEASUREMENT RULE and presentation values, carried from the
## D-388 spike and relabelled PROVISIONAL. Authored-time seconds unless noted.
const FULL_DRAW_SPEED_MPS := 0.15
const HOLD_S := 0.10
const XFADE_INTO_DRAW_S := 0.25
const XFADE_DRAW_TO_HOLD_S := 0.10
const XFADE_HOLD_TO_RELEASE_LEGS_S := 0.10
## Real seconds, from the pose on screen into locomotion (a cancel or a new order).
const XFADE_CANCEL_TO_LOCO_S := 0.15
const XFADE_LOCO_S := 0.20
const RELEASE_SNAP_WINDOW_S := 0.10
const BOW_LENGTH_PER_HEIGHT := 0.78
const ARROW_OVERHANG_M := 0.10
const STRING_RADIUS_M := 0.0045
const ANCHOR_REST_MODEL := Vector3(-0.035, 1.53, 0.075)
const BOW_ARM_REACH_FRACTION := 0.96
const IK_RAMP_S := 0.30
const IK_POLE_HINT_LEFT := Vector3(0.35, -1.0, 0.0)
const IK_POLE_HINT_RIGHT := Vector3(-0.6, -0.5, -0.6)
const IK_POLE_HINT_M := 0.04
## A STATIC grip pose, NOT finger animation -- D-389 accepted debt 1 ("finger")
## is CARRIED, not fixed.
const GRIP_BOW_HAND := {"index": [55.0, 70.0, 45.0], "middle": [60.0, 75.0, 45.0],
	"ring": [62.0, 75.0, 45.0], "pinky": [65.0, 75.0, 45.0], "thumb": [10.0, 25.0, 20.0]}
const GRIP_STRING_HAND := {"index": [25.0, 60.0, 40.0], "middle": [25.0, 60.0, 40.0],
	"ring": [30.0, 60.0, 40.0], "pinky": [60.0, 75.0, 50.0], "thumb": [20.0, 35.0, 25.0]}

# =============================================================================
# COMBAT ENTITIES AND ELIGIBILITY — categories, not content.
# =============================================================================
## D-391 ruling 4: "This includes ordinary enemies, elites, bosses and hostile
## summons ... It excludes allies, dead or dying actors, scenery, destructibles
## and enemies currently untargetable or invulnerable." ONLY ordinary enemies
## exist in game3d/; the other categories are PROVED with test-only stub records
## and NO content is added.
const HOSTILE_CATEGORIES := ["ordinary", "elite", "boss", "hostile_summon"]
const ALLY_CATEGORIES := ["ally"]
## Refused at registration: NO scenery or destructible SYSTEM exists here, and
## whether an arrow would stop at a destructible is NOT decided (D-391 section 5
## item 6). The exclusions NAME CONDITIONS; they create no state.
const REFUSED_CATEGORIES := ["scenery", "destructible"]

const SPLINTER_ACTION_LABEL := "SPLINTER SHOT (CANONICAL SKILL — PROVISIONAL TIMING)"
const HUD_TITLE := "SPLINTER SHOT REVIEW HUD · review tooling, NOT a UI foundation"

# =============================================================================
# THE REGISTRY — printed at runtime, asserted by the D-392 suite.
# =============================================================================
static func registry() -> Array:
	return [
		["Splinter Shot release from use start (s)", SPLINTER_RELEASE_S, "PROVISIONAL REVIEW CANDIDATE (D-390 r1 / D-391 r1) — NOT a lock, NOT attack speed"],
		["Splinter Shot recovery after release (s)", snappedf(splinter_recovery_s(), 0.0001), "PROVISIONAL — DERIVED from the accepted bolt: 0.45 x (1 - 0.36)"],
		["Splinter Shot action (s)", snappedf(splinter_action_s(), 0.0001), "PROVISIONAL — DERIVED: release + recovery"],
		["Splinter Shot release marker (normalised)", snappedf(splinter_release_marker(), 0.0001), "PROVISIONAL — DERIVED: release / action"],
		["Splinter Shot damage at rank 1", SPLINTER_DAMAGE_AT_RANK_1, "PROVISIONAL — not balance"],
		["Splinter Shot damage per rank", SPLINTER_DAMAGE_PER_RANK, "PROVISIONAL — not balance"],
		["Splinter Shot Mana at rank 1", SPLINTER_MANA_AT_RANK_1, "PROVISIONAL — sized to be sustainable (canon)"],
		["Splinter Shot Mana per rank", SPLINTER_MANA_PER_RANK, "PROVISIONAL — rank moves cost, not only damage"],
		["Splinter Shot cooldown (s)", SPLINTER_COOLDOWN_S, "PROVISIONAL — none: paced by the action time"],
		["arrow speed (m/s)", ARROW_SPEED_MPS, "PROVISIONAL — carried from the D-388 spike's DIAGNOSTIC value"],
		["arrow range (m)", ARROW_RANGE_M, "PROVISIONAL"],
		["arrow collision radius (m)", ARROW_RADIUS_M, "PROVISIONAL"],
		["collision tie tolerance (m)", COLLISION_TIE_TOLERANCE_M, "PROVISIONAL — D-391 r5: no tolerance is locked"],
		["world-geometry probe height (m)", WALL_PROBE_HEIGHT_M, "PROVISIONAL — a probe inside blockers, never a coordinate"],
		["visual alignment tolerance at release (deg)", VISUAL_ALIGN_TOLERANCE_DEG, "PROVISIONAL — D-391 r2: no blend duration is locked"],
		["full-draw speed threshold (m/s)", FULL_DRAW_SPEED_MPS, "PROVISIONAL — the D-388 rule that MEASURES the full draw"],
		["aiming hold (s, authored)", HOLD_S, "PROVISIONAL presentation"],
		["crossfade into draw (s, authored)", XFADE_INTO_DRAW_S, "PROVISIONAL presentation"],
		["crossfade draw -> hold (s, authored)", XFADE_DRAW_TO_HOLD_S, "PROVISIONAL presentation"],
		["crossfade hold -> release, legs (s, authored)", XFADE_HOLD_TO_RELEASE_LEGS_S, "PROVISIONAL presentation"],
		["crossfade cancel -> locomotion (s)", XFADE_CANCEL_TO_LOCO_S, "PROVISIONAL presentation"],
		["crossfade idle <-> run (s)", XFADE_LOCO_S, "PROVISIONAL presentation"],
		["release snap window (s, authored)", RELEASE_SNAP_WINDOW_S, "PROVISIONAL presentation"],
		["bow length / standing height", BOW_LENGTH_PER_HEIGHT, "PROVISIONAL presentation"],
		["arrow overhang past the grip (m)", ARROW_OVERHANG_M, "PROVISIONAL presentation"],
		["jaw anchor at rest (model m)", ANCHOR_REST_MODEL, "PROVISIONAL presentation — the IK's full-draw anchor"],
		["bow-arm reach fraction", BOW_ARM_REACH_FRACTION, "PROVISIONAL presentation"],
		["IK ramp into the draw (s, authored)", IK_RAMP_S, "PROVISIONAL presentation"],
		["IK elbow pole hint (m)", IK_POLE_HINT_M, "PROVISIONAL presentation"],
		["arrow trail (s)", TRAIL_SECONDS, "PROVISIONAL presentation — code-generated, NOT final VFX"],
	]

## The canonical rules this stage implements, each cited. Printed at runtime.
static func canonical_rulings() -> Array:
	return [
		["D-390 r1 / D-391 r1", "Splinter Shot is her ordinary shot; release at the ~0.5 s candidate; recovery cancellable", "IMPLEMENTED — PROVISIONAL timing"],
		["D-390 r2 / D-391 r2", "aim and facing sampled at start; mechanical facing snaps; the visual may blend but aligns before release", "IMPLEMENTED"],
		["D-390 r4", "an unmodified ordinary arrow hits the first eligible target and stops", "IMPLEMENTED"],
		["D-391 r4", "enemy eligibility, a general combat rule: alive, hostile, targetable, able to legally receive the Hit", "IMPLEMENTED"],
		["D-391 r5", "one arrow: earliest time of impact; a tie within tolerance by stable combat-entity ID", "IMPLEMENTED"],
		["D-392 CL-3", "a combat-entity ID: opaque, immutable, unique in the area, deterministic, never name or memory", "IMPLEMENTED as far as this slice needs"],
		["D-393", "Prey is removed from the Huntress design: no designation, preference, marker or label exists", "IMPLEMENTED — removed"],
	]

## The three accepted clarifications, RECORDED. Two are NOT implemented here.
static func clarifications() -> Array:
	return [
		["CL-1", "Void Lance uses the same sampled-facing snap by default; its longer commitment, not delayed turning, makes it heavier.", "RECORDED — Void Lance is OUT OF SCOPE"],
		# D-396 (first act): the disposition read "RECORDED — Kindred Hounds are OUT
		# OF SCOPE" until D-396 -- true when written, and still true OF THE D-392
		# STAGE. D-394 ruling 3 accepted the rule and D-396 implements it.
		["CL-2", "Kindred Hounds retain their current valid target, else select the nearest reachable eligible enemy to the hound among those inside the Huntress-centred acquisition range; ties by combat-entity ID. (D-393: its first clause, a valid Prey, is superseded.)", "RECORDED — Kindred Hounds were OUT OF SCOPE of the D-392 stage; D-394 ruling 3 accepted the rule and the D-396 stage implements it"],
		["CL-3", "A combat-entity ID is an opaque, immutable gameplay identifier, unique within the active area, assigned deterministically, never from engine iteration order, object name or memory identity; storage/serialization not canonized.", "RECORDED and IMPLEMENTED for this slice"],
	]

## What this stage denies, individually. Printed every run.
static func denials() -> Array:
	return [
		"The D-392 stage IS NOT P2 and AUTHORIZES NO P2.",
		"The D-392 stage IS NOT campaign production and adds NO campaign, loot, Passive or enemy content.",
		# D-396 (first act): this read "ONLY Splinter Shot exists. Kindred Hounds,
		# Coursing Hounds, ... are NOT implemented." until D-396 -- TRUE WHEN WRITTEN.
		# It is now stated OF THE D-392 STAGE, which is what it always described.
		"The D-392 stage IS NOT the full Huntress: it implemented ONLY Splinter Shot, and NO Kindred Hounds, Coursing Hounds, Sinew Ballista, Cinder Field, Void Lance, Rift Step or Void Attunement (true of the D-392 stage; D-396, a later stage, adds Kindred Hounds and nothing else of the roster).",
		"The D-392 stage IMPLEMENTS NO RIFT SHARDS.",
		"The D-392 stage's animation is a TEMPORARY PLACEHOLDER — KayKit bow clips (CC0) retargeted with the D-388 approach — and IS NOT final animation.",
		"The D-392 stage's bow, string, arrow, trail and impact are PLACEHOLDERS: NOT final art, attachment or VFX. NO VFX package is read or used.",
		"The D-392 stage does NOT use the paid Quaternius Source edition.",
		"The D-392 stage fixes NONE of the five accepted D-389 polish debts: finger, shoulder, string, hood-intersection, foot-sliding.",
		"The D-392 stage LOCKS NO NUMBER: the ~0.5 s release, the recovery, the playback rate, the damage, the cost, every distance, tolerance and turn rate are PROVISIONAL.",
		"The D-392 stage implements NO Prey: the owner removed it from the Huntress design under D-393, and the multi-target Prey tie-break is discharged by that removal, not by a rule.",
		"Huntress's Mark is a recorded FUTURE concept (D-393) and is NOT implemented: no Mark state, marking or damage bonus exists.",
		"The D-392 stage enables NO Pierce, Chain, Fork, additional projectile, explosion or other multi-target resolution.",
		"The Splinter Shot review HUD is review tooling and IS NOT a UI foundation.",
		"The D-392 stage modifies NO accepted spike, and NO accepted D-373 or D-375/D-380 tuning value.",
		# D-396 (first act): this read "The D-392 stage delivers OPEN pending owner
		# live review; it does NOT accept itself." until D-396 -- TRUE WHEN WRITTEN,
		# and the state the stage was accepted in. The fact is unchanged: the stage
		# never accepted itself; the OWNER accepted it, under D-394.
		"The D-392 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-394 (its runtime said it delivers OPEN pending owner live review until D-396 reconciled the line — true when written).",
	]

## Printed every run. NONE IS A PASS.
static func deferred_rows() -> Array:
	return [
		["SD-04 final HUD / VFX presentation (OWED item 6)", "DEFERRED",
		 "The review HUD's lines, the trail and the impact are PLACEHOLDER presentation. RETURNS TO: a UI foundation and VFX work."],
		["SD-05 final animation sources (OWED item 5)", "DEFERRED",
		 "The KayKit bow clips are TEMPORARY PLACEHOLDER animation. RETURNS TO: final animation."],
		["SD-06 final bow attachment and orientation (OWED item 7)", "DEFERRED",
		 "The D-388 full-draw solve is ported, not resolved. RETURNS TO: final art and animation."],
		["SD-07 the five accepted D-389 polish debts — finger, shoulder, string, hood-intersection, foot-sliding", "CARRIED — NOT FIXED",
		 "Owner: non-blocking production-polish debts. RETURNS TO: a separately authorized production-polish pass."],
		["SD-08 Attack Speed and a bow's base Attack Time scaling of Splinter Shot; how the blend stays ahead of release as they compress it", "DEFERRED",
		 "No attack-speed stat exists; the timing is a PROVISIONAL candidate. RETURNS TO: tuning / a stats stage."],
		["SD-09 Kindred Hounds (the D-392 target-choice clarification is RECORDED, not implemented)", "OUT OF SCOPE",
		 "Excluded by the ruling. RETURNS TO: its own authorized stage. (D-396: that stage is authorized and delivered OPEN; this row describes the D-392 stage's scope and is kept as written.)"],
		["SD-10 Void Lance (the D-392 facing clarification is RECORDED, not implemented), Coursing Hounds, Sinew Ballista, Cinder Field, Rift Step, Void Attunement", "OUT OF SCOPE",
		 "Excluded by the ruling. RETURNS TO: their own authorized stages."],
		["SD-11 Rift-Shard generation on Splinter Shot's release (canon §0.5.8)", "OUT OF SCOPE",
		 "Rift Shards are excluded by the ruling. RETURNS TO: its own stage."],
		["SD-12 whether an arrow stops at a destructible", "NOT DECIDED",
		 "D-391 §5 item 6. No destructible system exists, and the registry refuses to register one. RETURNS TO: an owner ruling if one ever exists."],
		["SD-13 the controller shifted-bank mapping of the eight bindings (the Imprint suite's DF-01)", "DEFERRED",
		 "Binding 6 carries only the ordinary attack's pad button 7. RETURNS TO: the UI/input foundation."],
		["SD-14 the ordinary attack's pad button 7 is L3, not RT (the Imprint suite's DF-14)", "DEFERRED",
		 "Moved WITH the ordinary attack to binding 6, deliberately NOT rebound. RETURNS TO: the UI/input foundation."],
		["SD-15 Always Use Without Moving, Attack in Place, and canon's short Skill input buffer (§15)", "DEFERRED",
		 "Not implemented: a press during a committed action is refused; HOLDING repeats at the action time. RETURNS TO: a later stage."],
		["SD-16 controller HARDWARE behaviour", "DEFERRED",
		 "No gamepad can be attached here. RETURNS TO: owner live review."],
		["SD-17 audio", "DEFERRED",
		 "ZERO audio assets and hooks. RETURNS TO: an audio pass."],
		["SD-18 the closed D-388 spike runner's K08 compares its verbatim copies with game3d/'s LIVE modules", "DECLARED — NOT REPAIRED",
		 "D-392 changes prod_config.gd (the owner-ordered reconciliation) and player_controller.gd (the facing seam); re-run, K08 would report both. The spike is preserved, not continued, and NOT edited. RETURNS TO: nowhere — declared."],
	]

## Printed every run. NOT a pass and NOT a failure: the owner's live review.
##
## ============================================================================
## EMPTY SINCE D-396, AS ITS FIRST ACT — the four rows were ANSWERED UNDER D-394.
## ============================================================================
## From D-393 until D-396 this returned SO-01, SO-02, SO-03 and SO-05 -- TRUE WHEN
## WRITTEN, and the state the stage was accepted in. The owner's D-394 live review
## answered all four directly: "SO-01, SO-02, SO-03 and SO-05 are satisfactory
## based on my live review; the correction did not change those behaviours." They
## MOVED -- original text preserved verbatim -- to `discharged_rows()`. 4 - 4 = 0
## owed; 0 + 4 = 4 discharged; 0 deleted.
static func owed_to_owner() -> Array:
	return []

## The rows the owner ANSWERED, printed every run -- NOT passes. Each row is
## [id, the ORIGINAL owed-row text VERBATIM, disposition, the answer || the
## original text again, in the form every earlier stage's discharged rows use].
const D394_ANSWER := "THE OWNER'S D-394 LIVE REVIEW: ANSWERED DIRECTLY — \"SO-01, SO-02, SO-03 and SO-05 are satisfactory based on my live review; the correction did not change those behaviours.\" \"Satisfactory\" is an OBSERVATION at the PROVISIONAL values, not a lock on any of them."

static func discharged_rows() -> Array:
	var originals := [
		["SO-01", "Splinter Shot's responsiveness at the provisional release timing."],
		["SO-02", "Whether the facing snap and visual blend feel natural."],
		["SO-03", "Whether draw and release read at normal gameplay zoom."],
		["SO-05", "Whether projectile collision behaves predictably when targets overlap."],
	]
	var out: Array = []
	for r in originals:
		out.append([String(r[0]), String(r[1]), "DISCHARGED — D-394",
			D394_ANSWER + " || ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + String(r[1]) + "'"])
	return out

## Reused or ported implementation, declared truthfully. NOTHING here loads a
## file outside game3d/; these are CONCEPTS and CODE carried in, and each says so.
static func reuse_declaration() -> Array:
	return [
		["BonePose", "game3d_huntress_spike/scripts/spike/bone_pose.gd",
		 "PORTED VERBATIM in behaviour (class unchanged). Accepted D-389 as prototype feasibility evidence."],
		["KayKitClipSource", "game3d_huntress_spike/scripts/spike/kaykit_clip_source.gd",
		 "PORTED and ADAPTED: reads HuntressConfig; authorizes FIVE clips (the spike authorized seven; the two _Up clips are not needed)."],
		["BowRetargeter (rest-relative model-space transfer, derived bones, static grip, hand-contact IK)", "game3d_huntress_spike/scripts/spike/bow_retargeter.gd",
		 "PORTED and ADAPTED: reads HuntressConfig. The five accepted polish debts are carried, NOT fixed."],
		["BowPresentation (stringless bow, procedural string, nocked arrow)", "game3d_huntress_spike/scripts/spike/bow_presentation.gd",
		 "PORTED and ADAPTED: one visual only (the KayKit Ranger comparator is NOT ported)."],
		["HuntressBowAnimator (the draw/hold/release/recovery timeline)", "game3d_huntress_spike/scripts/spike/bow_pose_driver.gd",
		 "PORTED and ADAPTED: the release lands on the ACCEPTED commitment's marker at the D-392 candidate time; applied through a SkeletonModifier3D over the accepted AnimationPlayer."],
		["ImpactFlash (code-generated ring and flash)", "game3d_huntress_spike/scripts/spike/impact_effect.gd",
		 "PORTED: engine primitives only; NOT final VFX."],
		["the arrow's trail and planar flight", "game3d_huntress_spike/scripts/spike/arrow_projectile.gd",
		 "PORTED IN PART: the trail and planar flight. The collision is NEW (swept time of impact + combat-entity ID) — the spike's 'nearer, ties by name' is NOT carried."],
		["the point-blank rule", "game3d/scripts/combat/diagnostic_bolt.gd (accepted)",
		 "CONCEPT REUSED: a projectile tests what it already overlaps — here as a first sweep from her ground point."],
		["the accepted STOP commitment and recovery cancellation", "game3d/scripts/control/action_commitment.gd (accepted, UNCHANGED)",
		 "REUSED UNCHANGED through the D-375 `commit_subsystem_action` seam."],
	]

## What this stage does that no earlier stage did. Recorded so it is never
## mistaken for discharging an older obligation.
static func new_here() -> Array:
	return [
		"ONE canonical Skill Imprint in the live Imprint Library: Splinter Shot, learned at rank 1 / 0 XP.",
		"A mechanical facing SNAP distinct from the visual yaw, through a minimal facing-hold seam on the accepted controller.",
		"Swept arrow collision by exact planar time of impact, with a combat-entity-ID tie-break.",
		"A per-area combat-entity registry: opaque, immutable, unique, deterministic IDs.",
		"Enemy (Hit) eligibility as one predicate: an arrow's first eligible target, every refusal with its reason.",
		"World geometry stopping an arrow without a Hit (combat section 0.2: no projectile passes over a wall).",
		"Hold-to-repeat on the binding that holds Splinter Shot.",
	]
