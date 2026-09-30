class_name LocomotionConfig
extends RefCounted

## RIFTWROUGHT — THE PLAYER LOCOMOTION REDIRECTION STAGE: its own registry (D-400).
##
## ============================================================================
## ONE BOUNDED PLAYER-LOCOMOTION REDIRECTION STAGE. IT IS NOT MOVEMENT-SPEED
## TUNING, NOT A CONTROL-SCHEME CHANGE AND NOT AUTHORIZATION FOR OTHER CONTENT.
## ============================================================================
## The owner's ruling, verbatim: "This is explicit owner authorization for one
## bounded player-locomotion redirection stage inside game3d/. Its purpose is to
## remove unwanted directional sliding at high movement speed while preserving
## accepted click-to-move, navigation, combat commitment and independent aiming.
## It is not movement-speed tuning, a control-scheme change or authorization for
## other content."
##
## ---------------------------------------------------------------------------
## THIS STAGE INTRODUCES TWO NUMBERS. EVERYTHING ELSE IS DERIVED.
## ---------------------------------------------------------------------------
## That is the point, not an accident: the ruling says "Lock no numerical value",
## and the safest way to lock none is to introduce almost none. The redirection
## itself has no tunable at all -- it is an arithmetic identity. The rate scale is
## a RATIO against the accepted top speed. The arrival ceiling is derived from the
## already-registered acceleration rate and the already-accepted arrival
## tolerance. BOTH values below are PROVISIONAL and neither is a lock.
##
## ---------------------------------------------------------------------------
## THIS IS A SIXTH REGISTRY, NOT A REPLACEMENT.
## ---------------------------------------------------------------------------
## `ProdConfig` (D-373), `ImprintConfig` (D-376 / D-383), `HuntressConfig`
## (D-394), `HoundConfig` (D-397) and `CohortConfig` (D-400) are UNCHANGED in
## every numeric value. The D-400 suite asserts that directly.

const DECISION := "D-400"
const DATE := "2026-09-20"
const STAGE := "PLAYER LOCOMOTION REDIRECTION STAGE"

# =============================================================================
# THE ONLY TWO NUMBERS.
# =============================================================================

## A wish vector shorter than this asks for NO direction, and the motor brakes
## instead of steering. CARRIED UNCHANGED from the accepted D-373 motor, where
## it was an unnamed literal in two places; naming it changes no behaviour.
const WISH_EPSILON := 0.001

## The speed the acceleration and ordinary-braking rates are QUOTED AT.
##
## Ruling item 6: "Scale acceleration and ordinary braking with the current
## maximum movement speed so their response time remains consistent when movement
## speed changes." A rate quoted at a reference speed, scaled by
## current / reference, holds the RESPONSE TIME constant -- which is what the
## ruling asks for -- while leaving the accepted rates exactly as accepted at the
## accepted speed.
##
## IT IS THE ACCEPTED CONSTANT ITSELF, BY REFERENCE, NEVER A RE-TYPED LITERAL.
## A second copy of 3.889 would be a second source of truth, and this project has
## the rule that says so. `ProdConfig.TOP_SPEED_MPS` is NOT changed by this stage,
## and remains D-367's PROVISIONAL STARTING CANDIDATE.
const RATE_REFERENCE_MPS := ProdConfig.TOP_SPEED_MPS

# =============================================================================
# THE REGISTRY — printed at runtime, asserted by the D-400 suite.
# =============================================================================
static func registry() -> Array:
	return [
		["wish-direction epsilon", WISH_EPSILON,
		 "PROVISIONAL — carried unchanged from the accepted D-373 motor; naming it changed no behaviour"],
		["rate reference speed (m/s)", RATE_REFERENCE_MPS,
		 "PROVISIONAL — ProdConfig.TOP_SPEED_MPS BY REFERENCE, not a second value; at it the scale is exactly 1.0 and the accepted rates are unchanged"],
	]

## The owner's eleven behaviour items, each cited with its disposition. Printed
## at runtime and proved identical to the D-400 inventory row for row.
static func canonical_rulings() -> Array:
	return [
		["D-400 item 1", "ground movement has scalar speed but no directional inertia", "IMPLEMENTED"],
		["D-400 item 2", "when the navigation/path direction changes, redirect the horizontal velocity vector to the new direction in the same physics frame", "IMPLEMENTED"],
		["D-400 item 3", "preserve the current scalar speed through redirection, clamped to the current allowed maximum; no speed burst and no unnecessary slowdown", "IMPLEMENTED"],
		["D-400 item 4", "apply this to new click orders, sharp path corners and abrupt 180 degree reversals", "IMPLEMENTED"],
		["D-400 item 5", "starting from rest still accelerates; releasing or completing the movement order still brakes to rest", "PRESERVED — proved by the D-400 suite"],
		["D-400 item 6", "scale acceleration and ordinary braking with the current maximum movement speed so their response time stays consistent; lock no rate or time", "IMPLEMENTED — every value PROVISIONAL"],
		["D-400 item 7", "preserve collision response and legitimate sliding along walls; remove only residual travel in the obsolete movement direction", "PRESERVED"],
		["D-400 item 8", "preserve click-to-move and the absence of WASD movement", "PRESERVED"],
		["D-400 item 9", "preserve independent aim, sampled Splinter Shot facing, STOP action commitment, buffered pre-release movement and post-release recovery cancellation", "PRESERVED"],
		["D-400 item 10", "prevent destination overshoot and path-corner cutting at every diagnostic speed", "IMPLEMENTED — derived from registered values, no new tunable"],
		["D-400 item 11", "do not alter accepted top speed, diagnostic speed multipliers, camera, zoom, Skill timing, minion movement or navigation geometry", "PRESERVED — proved by the D-400 suite"],
	]

## What this stage denies, individually. Printed every run.
static func denials() -> Array:
	return [
		"The D-400 stage IS NOT P2 and AUTHORIZES NO P2.",
		"The D-400 stage IS NOT movement-speed tuning: ProdConfig.TOP_SPEED_MPS is unchanged at its accepted value and stays D-367's PROVISIONAL STARTING CANDIDATE.",
		"The D-400 stage IS NOT a control-scheme change: click-to-move is still the canonical mouse scheme and there is still NO W/A/S/D binding.",
		"The D-400 stage adds NO input action: the project's 29 accepted actions stay 29.",
		"The D-400 stage adds NO player-facing or review surface and IS NOT a UI foundation.",
		"The D-400 stage changes NO diagnostic travel-speed multiplier: ORDINARY, FAST and EXTREME are the accepted D-398 modes.",
		"The D-400 stage changes NO camera, zoom, Skill timing, damage, minion movement or navigation geometry value.",
		"The D-400 stage changes NO minion locomotion: the shared cohort owns its own movement and is untouched.",
		"The D-400 stage adds NO Skill, Imprint, Configuration, action entry point, content, asset, animation, audio or VFX.",
		"The D-400 stage adds NO Rift Shards, Passives, equipment, loot or campaign content.",
		"The D-400 stage introduces EXACTLY TWO numbers and derives everything else; it LOCKS NO NUMBER, rate or response time.",
		"The D-400 stage does NOT scale the ACTION brake: the ruling names acceleration and ORDINARY braking, and the action brake is a separate accepted rate (LD-02 declares the consequence).",
		"The D-400 stage modifies NO accepted spike and has NO runtime dependency outside game3d/.",
		# D-402 (first act): this read "The D-400 stage delivers OPEN pending owner
		# live review; it does NOT accept itself." -- TRUE WHEN WRITTEN, and the
		# state the stage was ACCEPTED IN. D-401 accepted and closed it; D-401
		# section 6 recommended this reconciliation for the next stage's first act,
		# and the D-402 ruling authorizes it. The history is preserved, not deleted.
		"The D-400 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-401 (its runtime said it delivers OPEN pending owner live review until D-402 reconciled the line — true when written).",
	]

## Printed every run by the D-400 suite. NONE IS A PASS.
static func deferred_rows() -> Array:
	return [
		["LD-01 numerical tuning of every locomotion value this stage touches", "DEFERRED",
		 "Nothing is locked: the two values it introduces and the accepted rates it scales are all PROVISIONAL. RETURNS TO: a tuning pass."],
		# ====================================================================
		# RE-CLASSIFIED BY THE OWNER UNDER D-401, AND RE-CLASSIFICATION IS NOT
		# DISCHARGE. Reconciled here as D-402's first act, exactly as D-401 §6
		# recommended and this ruling authorizes.
		# ====================================================================
		# From D-400 until D-402 this row read "DECLARED — NOT REPAIRED", with
		# "RETURNS TO: the owner" -- TRUE WHEN WRITTEN, and the state the stage
		# was ACCEPTED IN. The owner then reviewed the very case it describes --
		# entering Splinter Shot while moving at high speed -- and ruled: "The
		# current ACTION-brake behaviour feels acceptable; do not replace it with
		# an instantaneous speed clear and do not scale it in this accepted stage.
		# Preserve LD-02 as a measured provisional finding rather than a defect or
		# locked rule." IT IS NOT DISCHARGED: it stays carried and measured.
		["LD-02 the ACTION brake is NOT scaled with the maximum speed", "CARRIED — PROVISIONAL FINDING",
		 "RE-CLASSIFIED BY THE OWNER (D-401): a MEASURED PROVISIONAL FINDING — NOT a defect awaiting repair, and NOT a rule anyone may cite. 120.0 m/s² IS NOT A LOCK. Two standing prohibitions travel with it, in the owner's own words: \"do not replace it with an instantaneous speed clear\" and \"do not scale it in this accepted stage\". Its stop distance still grows with the diagnostic speed, and the D-400 suite MEASURES it at every mode, every run. RETURNS TO: nowhere — carried and measured."],
		["LD-03 camera behaviour at extreme speed (CD-12)", "CARRIED — NOT DISCHARGED",
		 "Its accepted follow lag is not tuned for it, and a sharper reversal is a harder case for it, not an easier one. RETURNS TO: a camera pass."],
		["LD-04 D-371's crowd-avoidance / density risk (CD-08)", "CARRIED — NOT DISCHARGED",
		 "Unrelated to leader locomotion and untouched here. RETURNS TO: a crowd-avoidance stage."],
		["LD-05 minion/enemy distinguishability in PRODUCTION (KD-11, CD-15)", "CARRIED — NOT DISCHARGED",
		 "Untouched here. RETURNS TO: a presentation pass."],
		["LD-06 the pre-existing 36 / 35 LIFE CONVERSION overflow in the accepted D-392 loadout (CD-16)", "DECLARED — NOT REPAIRED",
		 "Disclosed at D-396 and never authorized for repair. RETURNS TO: a later stage, if authorized."],
		["LD-07 the five accepted D-389 production-polish debts (SD-07)", "CARRIED — NOT DISCHARGED",
		 "Finger, shoulder, string, hood-intersection and foot-sliding. RETURNS TO: a production-polish pass."],
		["LD-08 the D-398 runner's Z16, the D-396 runner's Y15, the D-392 runner's W17 and the D-380 runner's T17 are delivery-time claims", "DECLARED — NOT REPAIRED",
		 "Each proves its own stage's change set against a listing taken before it; none can pass after D-400. tests/locomotion_smoke.sh N16 proves D-400's. RETURNS TO: nowhere — declared."],
		["LD-09 the closed D-388 spike runner's K08 compares its verbatim copies with game3d/'s LIVE modules", "DECLARED — NOT REPAIRED",
		 "D-400 changes prod_config.gd and player_controller.gd again; SD-18, KD-15 and CD-11 already declare both. The spike is preserved, not continued, and NOT edited. RETURNS TO: nowhere — declared."],
		["LD-10 minion locomotion is NOT redirected by this stage", "OUT OF SCOPE",
		 "The shared cohort owns its own movement and ruling item 11 forbids altering it. RETURNS TO: a minion stage, if ever authorized."],
		["LD-11 controller HARDWARE behaviour under redirection", "DEFERRED",
		 "No gamepad can be attached here; the stick path is driven through the intent seam instead. RETURNS TO: owner live review."],
		["LD-12 performance at production scale", "DEFERRED",
		 "Measured here only in the test arena. RETURNS TO: a performance pass."],
		["LD-13 a locomotion review HUD or on-screen readout", "OUT OF SCOPE",
		 "None was asked for, and the accepted D-398 cohesion HUD already prints the live diagnostic speed mode, its multiplier and the unchanged accepted speed. RETURNS TO: nowhere — not wanted."],
		["LD-14 the cohort's own catch-up and formation values are NOT retuned for the sharper leader reversal", "DEFERRED",
		 "The D-398 suite is re-run whole and its behaviour is measured, not adjusted. RETURNS TO: a tuning pass."],
	]

## Printed every run by the D-400 suite. NOT a pass and NOT a failure.
##
## ============================================================================
## EMPTY SINCE D-402, AS ITS FIRST ACT — the four rows were ANSWERED UNDER D-401.
## ============================================================================
## From D-400 until D-402 this returned LO-01 ... LO-04 -- TRUE WHEN WRITTEN, and
## the state the stage was accepted in. The owner's D-401 live review answered all
## four directly, in the owner's own words: "works well, I like it." They MOVED --
## original text preserved VERBATIM -- to `discharged_rows()`. 4 - 4 = 0 owed;
## 0 + 4 = 4 discharged; 0 deleted.
##
## NOTHING MORE IS READ INTO THE ANSWER. No acceleration, braking, response time,
## arrival ceiling, diagnostic multiplier or other value became a lock, and LD-02
## is NOT discharged by it: D-401 RE-CLASSIFIED it as a MEASURED PROVISIONAL
## FINDING -- "not a defect or locked rule" -- and it stays carried and measured.
static func owed_to_owner() -> Array:
	return []

## The rows the owner ANSWERED, printed every run -- NOT passes. Each row is
## [id, the ORIGINAL owed-row text VERBATIM, disposition, the answer || the
## original text again, in the form every earlier stage's discharged rows use.]
const D401_ANSWER := "THE OWNER'S D-401 LIVE REVIEW: ANSWERED DIRECTLY — \"works well, I like it.\" Nothing more is inferred: no acceleration, braking, response time, arrival, diagnostic-multiplier or other value became a lock, and LD-02 stays CARRIED as a measured provisional finding rather than a defect or a rule."

static func discharged_rows() -> Array:
	var originals := [
		["LO-01", "Whether abrupt direction changes feel immediate and controlled at ORDINARY speed."],
		["LO-02", "Whether they feel immediate and controlled at FAST speed."],
		["LO-03", "Whether they feel immediate and controlled at EXTREME speed."],
		["LO-04", "Whether starts and stops still feel natural."],
	]
	var out: Array = []
	for r in originals:
		out.append([String(r[0]), String(r[1]), "DISCHARGED — D-401",
			D401_ANSWER + " || ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + String(r[1]) + "'"])
	return out

## Reused or informing implementation, declared truthfully. NOTHING here loads a
## file outside game3d/.
static func reuse_declaration() -> Array:
	return [
		["the accepted acceleration and ordinary-braking rates", "game3d/scripts/core/prod_config.gd (accepted D-373)",
		 "USED UNCHANGED as CONSTANTS and re-quoted as rates at the accepted reference speed: at that speed the scale is exactly 1.0 and the measured response is the accepted one."],
		["the accepted arrival tolerance and PathFollower", "game3d/scripts/world/nav_service.gd and prod_config.gd (accepted D-373)",
		 "USED UNCHANGED: the arrival ceiling reads the follower's own remaining path length and the accepted tolerance still clears the order."],
		["the accepted action-movement commitment and its separate brake", "game3d/scripts/control/action_commitment.gd (accepted D-373)",
		 "USED UNCHANGED and deliberately NOT scaled: a committed action still brakes at ProdConfig.ACTION_BRAKE_MPS2 (LD-02)."],
		["the accepted diagnostic travel-speed seam", "game3d/scripts/control/player_controller.gd (accepted D-398)",
		 "USED UNCHANGED: one declared scale, 1.0 in normal play, written only by CohortDiagnostics."],
	]

## What this stage does that no earlier stage did.
static func new_here() -> Array:
	return [
		"Ground movement carried as a SCALAR SPEED on a commanded direction, with no directional inertia at all.",
		"Same-frame redirection of the horizontal velocity onto a new navigation, path or stick direction, preserving the scalar speed and clamping it to the current allowed maximum.",
		"Acceleration and ordinary braking quoted at a reference speed and scaled with the current maximum, so the response TIME is the same at every diagnostic speed.",
		"An arrival speed ceiling derived from the registered acceleration rate and the live remaining path length, which introduces no tunable and never binds at the accepted speed.",
	]
