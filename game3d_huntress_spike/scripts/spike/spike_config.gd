class_name SpikeConfig
extends RefCounted

## RIFTWROUGHT — HUNTRESS BOW-RETARGETING AND PREY FEASIBILITY SPIKE (D-388)
##
## ============================================================================
## THIS SPIKE'S OWN REGISTRY. EVERY VALUE IN IT IS DIAGNOSTIC, PROVISIONAL OR
## MEASURED, AND NONE IS A LOCK.
## ============================================================================
## The accepted game3d/ values the verbatim controller reads -- 3.889 m/s, the
## 120 m/s^2 action brake, the 0.10 m glide tolerance, the camera -- live in the
## VERBATIM `ProdConfig` and are NOT changed here. That file's prose describes
## game3d/; the spike never prints it as its own claim.
##
## The owner's boundary, verbatim: "This is not P2, not production
## implementation, not final Huntress art, not VFX intake, not tuning and not
## authorization to modify `game3d/` or any accepted project."

const DECISION := "D-388"
const DATE := "2026-09-19"
const STAGE := "HUNTRESS BOW-RETARGETING AND PREY FEASIBILITY SPIKE"
## Fixed in advance by the owed-criteria inventory. THE SPIKE NEVER DELIVERS
## ITSELF AS ACCEPTED.
const STATE := "HUNTRESS BOW-RETARGETING AND PREY FEASIBILITY SPIKE DELIVERED and OPEN pending owner live review (D-388)"

## The runtime never grades its own retargeting. The report does, against
## rendered evidence, and the owner confirms or corrects it.
const CLASSIFICATION_STATE := "RETARGET CLASSIFICATION: OWED — made in the delivery report against RENDERED evidence, and subject to owner live review. The runtime does not classify itself."

const HOUND_LABEL := "DIAGNOSTIC HOUND STAND-IN — NO HOUND ART PROVEN"
const RANGER_LABEL := "NATIVE KAYKIT CONTROL — DIAGNOSTIC COMPARATOR, NOT THE HUNTRESS"
const HUNTRESS_LABEL := "RETARGETED HUNTRESS — KayKit bow clips on the 65-joint Huntress"
const BOW_ACTION_LABEL := "DIAGNOSTIC BOW SHOT"
const BOW_ACTION_DENIAL := "DIAGNOSTIC BOW SHOT — non-canonical; NOT Splinter Shot, NOT a Skill, NOT a roster entry."

static func denials() -> Array:
	return [
		"This spike is NOT P2 and authorizes NO P2.",
		"This spike is NOT production implementation.",
		"This spike is NOT final Huntress art. NO placeholder asset is final.",
		"This spike is NOT VFX intake: NO VFX archive is read or used; the trail and impact are generated in code.",
		"This spike is NOT tuning: every value is DIAGNOSTIC, PROVISIONAL or MEASURED, and NONE is a lock.",
		"This spike does NOT modify game3d/ or any accepted project.",
		"The DIAGNOSTIC BOW SHOT is NOT Splinter Shot, NOT a Huntress Skill and NOT a roster entry.",
		"The KayKit Ranger is a DIAGNOSTIC NATIVE-RIG COMPARATOR ONLY. It is NOT an alternative production Huntress and cannot be accepted silently.",
		"The hound is a PROCEDURAL STAND-IN. NO hound art is proven, and it is NOT the Ultimate Monsters dog.",
		"This spike does NOT resolve the OWED multi-target Prey tie-break; its projectiles Hit one target each.",
		"This spike invents NO hound, ballista, trap or Skill roster, and resolves NO unrelated D-385 debt.",
		"This spike changes NO Huntress canon.",
	]

# --- The seven authorized clips ---------------------------------------------
const CLIP_BOW_IDLE := "Ranged_Bow_Idle"
const CLIP_AIM_IDLE := "Ranged_Bow_Aiming_Idle"
const CLIP_DRAW := "Ranged_Bow_Draw"
const CLIP_DRAW_UP := "Ranged_Bow_Draw_Up"
const CLIP_RELEASE := "Ranged_Bow_Release"
const CLIP_RELEASE_UP := "Ranged_Bow_Release_Up"
const CLIP_RUN_BOW := "Running_HoldingBow"
const AUTHORIZED_CLIPS := [CLIP_BOW_IDLE, CLIP_AIM_IDLE, CLIP_DRAW, CLIP_DRAW_UP,
	CLIP_RELEASE, CLIP_RELEASE_UP, CLIP_RUN_BOW]
## The five the runtime plays. The two `_Up` clips are authorized and NOT
## needed: the simulation is a plane (DF-09).
const PLAYED_CLIPS := [CLIP_BOW_IDLE, CLIP_AIM_IDLE, CLIP_DRAW, CLIP_RELEASE, CLIP_RUN_BOW]

# --- The explicit retarget map, in Godot's own vocabulary --------------------
## Profile bone (SkeletonProfileHumanoid) -> KayKit Medium rig bone.
## KayKit `chest` is mapped to UpperChest, because in BOTH rigs that is the bone
## the arms hang from (Huntress: spine_03 -> clavicle -> upperarm).
const MAP_KAYKIT := {
	"Root": "root", "Hips": "hips", "Spine": "spine", "UpperChest": "chest", "Head": "head",
	"LeftUpperArm": "upperarm.l", "LeftLowerArm": "lowerarm.l", "LeftHand": "hand.l",
	"RightUpperArm": "upperarm.r", "RightLowerArm": "lowerarm.r", "RightHand": "hand.r",
	"LeftUpperLeg": "upperleg.l", "LeftLowerLeg": "lowerleg.l", "LeftFoot": "foot.l", "LeftToes": "toes.l",
	"RightUpperLeg": "upperleg.r", "RightLowerLeg": "lowerleg.r", "RightFoot": "foot.r", "RightToes": "toes.r",
}
## Profile bone -> Huntress (Quaternius, UE-mannequin naming) bone.
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
## DERIVED bones: [huntress bone, profile neighbour A, profile neighbour B] --
## each takes the rotation delta halfway between its two mapped neighbours.
const DERIVED := [
	["spine_02", "Spine", "UpperChest"],
	["neck_01", "UpperChest", "Head"],
]
## Source bones with no Huntress counterpart, and why.
const UNMAPPED_SOURCE := {
	"wrist.l": "absorbed — the mapped hand.l's model-space rotation already includes it",
	"wrist.r": "absorbed — the mapped hand.r's model-space rotation already includes it",
	"handslot.l": "attachment reference only (the native control's bow grip)",
	"handslot.r": "attachment reference only (the native control's nock point)",
}

# --- The bow action timeline (authored time; x the diagnostic rate) -----------
## DIAGNOSTIC PLAYBACK RATES. NOT attack speed, NOT tuning, and they choose
## nothing: they exist so readability can be judged across a range.
const DIAGNOSTIC_RATES := [0.50, 1.00, 1.50, 2.00, 3.00]
const DEFAULT_RATE_INDEX := 1      ## x1.00, the authored rate
## T_full is MEASURED: the first Draw sample after which the string hand's
## rig-space speed stays below this.
const FULL_DRAW_SPEED_MPS := 0.15
const HOLD_S := 0.10                ## PROVISIONAL, DIAGNOSTIC
## 0.25 s, not the first draft's 0.15 s: Draw does NOT start from Bow_Idle's pose
## (D-386: 106.7 degrees at the right upper arm), and at 0.15 s the arm swung
## 17 degrees in a single frame on BOTH bodies. Draw's own first ~0.27 s only
## gathers the hands, which leaves the room. PROVISIONAL presentation.
const XFADE_INTO_DRAW_S := 0.25
const XFADE_DRAW_TO_HOLD_S := 0.10  ## PROVISIONAL
const XFADE_HOLD_TO_RELEASE_LEGS_S := 0.10  ## legs only; the upper body switches at once
const XFADE_CANCEL_TO_LOCO_S := 0.15
const XFADE_LOCO_S := 0.20
## The release snap window: how long the HUD calls the phase RELEASE.
const RELEASE_SNAP_WINDOW_S := 0.10
## Idle vs run, on the verbatim controller's own locomotion design names.
const RUN_CLIP_REFERENCE_SPEED_MPS := 3.889   ## run clip plays x1 at this speed — PROVISIONAL presentation

# --- Presentation (PROVISIONAL) ----------------------------------------------
const BOW_LENGTH_PER_HEIGHT := 0.78
const ARROW_OVERHANG_M := 0.10
const STRING_RADIUS_M := 0.0045
## The arrow-line alignment is MEASURED per visual; these shape its blend only.
const ALIGN_RECOVERY_FRACTION := 1.0

## THE JAW ANCHOR, in Huntress model space AT REST (under the right side of the
## chin, in front of the hood's opening). PROVISIONAL presentation: the IK carries
## it with the Head bone, and the rendered close-ups judge it.
const ANCHOR_REST_MODEL := Vector3(-0.035, 1.53, 0.075)
## How far along its reach the bow arm extends at full draw. PROVISIONAL.
const BOW_ARM_REACH_FRACTION := 0.96
## How fast the hand-contact IK comes in at the start of a draw (authored s).
const IK_RAMP_S := 0.30
## Elbow pole hints, model space of a body facing +Z (left is +X): the bow
## elbow points down and a little out; the string elbow out, back and down.
## They act only where the retargeted elbow's own side degenerates. PROVISIONAL.
const IK_POLE_HINT_LEFT := Vector3(0.35, -1.0, 0.0)
const IK_POLE_HINT_RIGHT := Vector3(-0.6, -0.5, -0.6)
const IK_POLE_HINT_M := 0.04

## Static finger grip, degrees per joint [01, 02, 03]. A STATIC POSE, not
## animation (DF-05). Bow hand: a fist around the grip. String hand: a three-
## finger hook, little finger and thumb tucked.
const GRIP_BOW_HAND := {"index": [55.0, 70.0, 45.0], "middle": [60.0, 75.0, 45.0],
	"ring": [62.0, 75.0, 45.0], "pinky": [65.0, 75.0, 45.0], "thumb": [10.0, 25.0, 20.0]}
const GRIP_STRING_HAND := {"index": [25.0, 60.0, 40.0], "middle": [25.0, 60.0, 40.0],
	"ring": [30.0, 60.0, 40.0], "pinky": [60.0, 75.0, 50.0], "thumb": [20.0, 35.0, 25.0]}

## World labels live on render layer 2, so the diagnostic close-up camera (which
## draws layer 1 only) shows geometry without billboard text filling its frame.
const LABEL_RENDER_LAYER := 2
## Four warm yard lights so the review can see (the yard has no torches).
const YARD_LIGHT_ENERGY := 2.4

# --- Projectile (DIAGNOSTIC) --------------------------------------------------
const ARROW_SPEED_MPS := 28.0
const ARROW_RANGE_M := 20.0
const ARROW_DAMAGE := 25.0
const ARROW_RADIUS_M := 0.22
const TRAIL_SECONDS := 0.14

# --- Targets (DIAGNOSTIC) -----------------------------------------------------
const TARGET_HEALTH := 250.0
const TARGET_RESPAWN_S := 3.0
const TARGET_RADIUS_M := 0.36
const TARGET_A_POS := Vector3(-6.0, 0.0, -2.0)
const TARGET_B_POS := Vector3(6.0, 0.0, -2.0)
const PLAYER_SPAWN := Vector3(0.0, 0.0, 5.0)

# --- The stand-in hound (DIAGNOSTIC) -------------------------------------------
const HOUND_SPEED_MPS := 5.0
## Acquisition reach, measured FROM THE HUNTRESS -- a DIAGNOSTIC choice (see
## StandInHound), NOT a ruling on canon's "normal acquisition reach".
const HOUND_ACQUIRE_M := 8.0
const HOUND_BITE_REACH_M := 0.35      ## beyond the two bodies' radii
const HOUND_BITE_INTERVAL_S := 1.0
const HOUND_BITE_DAMAGE := 8.0
const HOUND_THINK_S := 0.25
const HOUND_RADIUS_M := 0.30

## The registry printed at runtime and asserted labelled (T-03).
static func registry() -> Array:
	return [
		["diagnostic playback rates", str(DIAGNOSTIC_RATES), "DIAGNOSTIC — not attack speed, not tuning"],
		["default playback rate", DIAGNOSTIC_RATES[DEFAULT_RATE_INDEX], "DIAGNOSTIC — the authored rate"],
		["full-draw speed threshold (m/s)", FULL_DRAW_SPEED_MPS, "DIAGNOSTIC — the rule that MEASURES T_full"],
		["aiming hold (s, authored)", HOLD_S, "PROVISIONAL"],
		["crossfade into draw (s)", XFADE_INTO_DRAW_S, "PROVISIONAL"],
		["crossfade draw -> hold (s)", XFADE_DRAW_TO_HOLD_S, "PROVISIONAL"],
		["crossfade hold -> release, legs only (s)", XFADE_HOLD_TO_RELEASE_LEGS_S, "PROVISIONAL"],
		["crossfade cancel -> locomotion (s)", XFADE_CANCEL_TO_LOCO_S, "PROVISIONAL"],
		["crossfade idle <-> run (s)", XFADE_LOCO_S, "PROVISIONAL"],
		["run clip reference speed (m/s)", RUN_CLIP_REFERENCE_SPEED_MPS, "PROVISIONAL presentation"],
		["bow length / standing height", BOW_LENGTH_PER_HEIGHT, "PROVISIONAL"],
		["arrow overhang past the grip (m)", ARROW_OVERHANG_M, "PROVISIONAL"],
		["arrow speed (m/s)", ARROW_SPEED_MPS, "DIAGNOSTIC"],
		["arrow range (m)", ARROW_RANGE_M, "DIAGNOSTIC"],
		["arrow damage", ARROW_DAMAGE, "DIAGNOSTIC — NOT Splinter Shot's"],
		["arrow radius (m)", ARROW_RADIUS_M, "DIAGNOSTIC"],
		["target health", TARGET_HEALTH, "DIAGNOSTIC"],
		["target respawn (s)", TARGET_RESPAWN_S, "DIAGNOSTIC"],
		["hound speed (m/s)", HOUND_SPEED_MPS, "DIAGNOSTIC"],
		["hound acquisition reach (m, from the Huntress)", HOUND_ACQUIRE_M, "DIAGNOSTIC — the reference point is a spike choice, NOT a ruling"],
		["hound bite damage", HOUND_BITE_DAMAGE, "DIAGNOSTIC"],
		["hound bite interval (s)", HOUND_BITE_INTERVAL_S, "DIAGNOSTIC"],
		["hound re-evaluation (s)", HOUND_THINK_S, "DIAGNOSTIC"],
		["jaw anchor at rest (model m)", ANCHOR_REST_MODEL, "PROVISIONAL presentation — the IK's full-draw anchor"],
		["bow-arm reach fraction", BOW_ARM_REACH_FRACTION, "PROVISIONAL"],
		["IK ramp into the draw (s)", IK_RAMP_S, "PROVISIONAL"],
		["IK elbow pole hint (m)", IK_POLE_HINT_M, "PROVISIONAL — only where the retargeted elbow side degenerates"],
		["yard light energy", YARD_LIGHT_ENERGY, "PROVISIONAL — visibility, not a lighting design"],
	]

## Printed every run. NONE IS A PASS.
static func deferred_rows() -> Array:
	return [
		["DF-01", "The deterministic multi-target Prey tie-break and eligibility (class §0.5.11 #1) — NOT triggered here: single-target projectiles.", "a separately authorized design ruling before implementation"],
		["DF-02", "Prey's timeout duration (OWED #14) — NOT implemented; no number invented.", "tuning, with a ruling"],
		["DF-03", "Prey ends when she leaves the area — the spike has no areas.", "a later stage with areas"],
		["DF-04", "Final Prey, minion and hound HUD and VFX presentation (OWED #4, #6).", "UI foundation / VFX work"],
		["DF-05", "Finger ANIMATION — only a static procedural grip exists.", "final animation sources (OWED #5)"],
		["DF-06", "Shooting while moving — NOT owed for the ordinary bow attack (D-387); ALLOW is unused.", "a future ALLOW Skill, if ever authorized"],
		["DF-07", "Final bow attachment and orientation (OWED #7) — ATTEMPTED here, NOT resolved.", "final art/animation"],
		["DF-08", "Hound art (OWED #8).", "sourcing or commissioning"],
		["DF-09", "Elevated aim — Draw_Up / Release_Up authorized and unused; the simulation is planar.", "only if height becomes a coordinate, by ruling"],
		["DF-10", "Attack speed as a stat — the diagnostic playback rates are NOT it.", "tuning"],
		["DF-11", "game3d_boss_spike/'s bow-attachment debt (D-369) — separate and UNCHANGED.", "a later authorized presentation-polish pass"],
		["DF-12", "Minion/enemy distinguishability in production (the D-375 debt) — the world label is a spike measure only.", "a later authorized presentation pass"],
		["DF-13", "Audio — none.", "out of scope (CLAUDE.md §12)"],
	]

## Printed every run. NOT a pass and NOT a failure.
static func owed_to_owner() -> Array:
	return [
		["O-01", "Can the KayKit bow animations be retargeted convincingly onto the current 65-joint Huntress?"],
		["O-02", "Can the bow, hands, arrow and procedural string form a readable draw/release?"],
		["O-03", "Does the accepted STOP/recovery-cancellation behaviour still feel correct with a real bow animation?"],
		["O-04", "Is Prey understandable when switching between two targets?"],
		["O-05", "Does the labelled stand-in hound autonomously prefer the current Prey without pet micromanagement?"],
		["O-06", "Confirm or correct the delivery report's retarget classification."],
	]

## What the verbatim controller is allowed to have overridden -- and nothing else.
const PROBE_OVERRIDES := ["setup", "_play", "_update_attack_input"]
