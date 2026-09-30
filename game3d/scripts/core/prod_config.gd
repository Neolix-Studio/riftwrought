class_name ProdConfig
extends RefCounted

## RIFTWROUGHT — 3D PRODUCTION FOUNDATION CONFIGURATION (D-370, 2026-09-17)
##
## ============================================================================
## EVERY TUNING NUMBER IN THIS FILE IS PROVISIONAL.
## ============================================================================
##
## The owner's ruling is explicit:
##   "Re-evaluate these values in the production architecture."
##   "Do not lock movement speed, camera pitch, zoom, damage, timings, scale,
##    VFX or other tuning."
##   "Print their provisional status in the runtime and verification output."
##
## So every such value is registered in PROVISIONAL below, printed at runtime,
## printed by the verification suite, and asserted to be labelled. A value that
## is not in that registry and is not structural is a defect.
##
## ---------------------------------------------------------------------------
## NO 2D LOCK IS PROMOTED HERE.
## ---------------------------------------------------------------------------
## The accepted 2D prototype's owner locks (D-356) belong to `game2d/`:
##   60.0 px/m, the 128 x 128 character cell, the 120 x 60 isometric tile, the
##   (64, 122) ground anchor, the FIXED 32.00 x 18.00 m camera footprint, and
##   rendering mode 7.
## They are quoted in FORBIDDEN_2D_LOCKS purely so the suite can prove none of
## them appears as a live value here.
##
## ---------------------------------------------------------------------------
## NO SPIKE VALUE IS PROMOTED TO A LOCK EITHER.
## ---------------------------------------------------------------------------
## D-367 praised the -52 degree pitch and the bounded zoom. PRAISE IS NOT A
## LOCK, and the owner said so directly. Those values are STARTING POINTS the
## ruling told this foundation to begin from and RE-EVALUATE.

const DECISION := "D-370"
const DATE := "2026-09-17"

## ============================================================================
## THE PROJECT'S STATE. RECONCILED UNDER D-375, EXACTLY AS D-373 RECOMMENDED.
## ============================================================================
## This read `"DELIVERED and OPEN pending owner live review"` from D-370 until
## D-375, and IT WAS TRUE WHEN WRITTEN. The foundation stage was then ACCEPTED
## and CLOSED under D-373 -- and D-373 deliberately did NOT change this string,
## because the owner forbade changing anything inside the project to earn its own
## acceptance, and changing it would have forced the runner's R08 truthfulness
## pin (which asserts this very string) to be re-pinned in order to make the
## acceptance fit.
##
## D-373 section 6.1 therefore DECLARED the discrepancy and RECOMMENDED -- while
## explicitly NOT authorizing -- its repair by the next authorized stage, as that
## stage's first act, together with the runner's pins. **THE D-375 RULING
## AUTHORIZES IT**: *"Reconcile the historical DELIVERED AND OPEN runtime state
## and the stale M-04 row as previously recommended. Preserve their history, but
## do not retain false current-state assertions or weaken guards merely to make
## them pass."*
##
## SO IT STATES BOTH FACTS, AND NEITHER IS FALSE:
##   * the bounded FOUNDATION STAGE is ACCEPTED and CLOSED (D-373);
##   * the GLOBAL IMPRINT SYSTEM PROTOTYPE stage is DELIVERED and OPEN (D-375).
##
## The runner's truthfulness pin and its deferred-row count MOVED IN THE SAME
## CHANGE, which is the whole of what D-373 asked for. NO GUARD WAS WEAKENED: the
## pin is now an EXACT-LINE match rather than a substring, which is stricter.
##
## ============================================================================
## RECONCILED AGAIN UNDER D-380, AS ITS FIRST ACT, EXACTLY AS D-376 RECOMMENDED.
## ============================================================================
## From D-375 until D-380 this read:
##   "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE DELIVERED and
##    OPEN pending owner live review (D-375)"
## and IT WAS TRUE WHEN WRITTEN. D-376 then ACCEPTED and CLOSED the Imprint stage
## WITHOUT touching this string, because the owner forbade changing anything
## inside the project to earn its acceptance. D-376 section 7 DECLARED the
## discrepancy and RECOMMENDED -- explicitly NOT authorizing -- its repair by the
## next authorized stage, as that stage's first act, together with the four pins
## that assert it: the Imprint runner's S14, S16 and S17 and the foundation
## runner's R08. THE D-380 RULING AUTHORIZES IT: "update the production
## state/status carried by ProdConfig.STATE ... update and re-pin the associated
## truthfulness guards together, never piecemeal."
##
## SO IT STATES THREE FACTS, AND NONE IS FALSE:
##   * the bounded FOUNDATION STAGE is ACCEPTED and CLOSED (D-373);
##   * the GLOBAL IMPRINT SYSTEM PROTOTYPE stage is ACCEPTED and CLOSED (D-376);
##   * the D-378 ALIGNMENT STAGE is DELIVERED and OPEN (D-380).
## All four pins moved IN THE SAME CHANGE, and each state pin is still an
## EXACT-LINE match. NO GUARD WAS WEAKENED.
##
## ============================================================================
## RECONCILED A THIRD TIME UNDER D-392, AS ITS FIRST ACT, AS D-383 RECOMMENDED.
## ============================================================================
## From D-380 until D-392 this read:
##   "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and
##    CLOSED (D-376) · D-378 ALIGNMENT STAGE DELIVERED and OPEN pending owner
##    live review (D-380)"
## and IT WAS TRUE WHEN WRITTEN. D-383 then ACCEPTED and CLOSED the alignment
## stage WITHOUT touching this string -- "Preserve the artifact exactly as
## reviewed and record any remaining OPEN runtime status as accepted historical
## state rather than re-pinning it" -- and D-383 section 6 RECOMMENDED, NOT
## authorizing, the repair by the next authorized stage as its first act. THE
## D-392 RULING AUTHORIZES IT: "First reconcile game3d/'s accepted D-383 state as
## previously recommended ... re-pin all corresponding truthfulness guards
## together ... Do not weaken a guard merely to make the new state pass."
##
## SO IT STATES FOUR FACTS, AND NONE IS FALSE:
##   * the bounded FOUNDATION STAGE is ACCEPTED and CLOSED (D-373);
##   * the GLOBAL IMPRINT SYSTEM PROTOTYPE stage is ACCEPTED and CLOSED (D-376);
##   * the D-378 ALIGNMENT STAGE is ACCEPTED and CLOSED (D-383);
##   * the HUNTRESS SPLINTER SHOT STAGE is DELIVERED and OPEN (D-392).
## Every pin that asserts it moved IN THE SAME CHANGE (R08, S14, S16, S17, T09,
## T11, T12, T13, T20, A01, A03, A35, I01), each state pin is still an EXACT-LINE
## match, and each GAINED an absence check for the D-380-era line.
##
## ============================================================================
## RECONCILED A FOURTH TIME UNDER D-396, AS ITS FIRST ACT, AS D-394 RECOMMENDED.
## ============================================================================
## From D-392 until D-396 this read:
##   "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and
##    CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) ·
##    HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN pending owner live review
##    (D-392)"
## and IT WAS TRUE WHEN WRITTEN. D-394 then ACCEPTED and CLOSED the Splinter Shot
## stage WITHOUT touching this string -- "Preserve the corrected implementation
## unchanged except for its own permitted status documentation" -- and D-394
## section 7 RECOMMENDED, NOT authorizing, the repair by the next authorized stage
## as its first act. THE D-396 RULING AUTHORIZES IT: "As the first act, reconcile
## the accepted D-392 state in game3d/ ... re-pin every affected truthfulness
## guard together without weakening behavioural checks."
##
## SO IT STATES FIVE FACTS, AND NONE IS FALSE:
##   * the bounded FOUNDATION STAGE is ACCEPTED and CLOSED (D-373);
##   * the GLOBAL IMPRINT SYSTEM PROTOTYPE stage is ACCEPTED and CLOSED (D-376);
##   * the D-378 ALIGNMENT STAGE is ACCEPTED and CLOSED (D-383);
##   * the HUNTRESS SPLINTER SHOT STAGE is ACCEPTED and CLOSED (D-394);
##   * the KINDRED HOUNDS STAGE is DELIVERED and OPEN (D-396).
## Every pin that asserts it moved IN THE SAME CHANGE (R08, S14, S16, S17, T09,
## T11, T12, T13, T20, W05, W10, W11, W13, W14, W15, A01, A03, A35, I01, H01, H03,
## H56), each state pin is still an EXACT-LINE match, and each GAINED an absence
## check for the D-392-era line.
##
## ============================================================================
## RECONCILED A FIFTH TIME UNDER D-398, AS ITS FIRST ACT, AS D-397 RECOMMENDED.
## ============================================================================
## From D-396 until D-398 this read:
##   "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and
##    CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) ·
##    HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS
##    STAGE DELIVERED and OPEN pending owner live review (D-396)"
## and IT WAS TRUE WHEN WRITTEN. D-397 then ACCEPTED and CLOSED the Kindred Hounds
## stage WITHOUT touching this string -- "Preserve the accepted implementation
## unchanged except for permitted status documentation" -- and D-397 section 6
## RECOMMENDED, NOT authorizing, the repair by the next authorized stage as its
## first act. THE D-398 RULING AUTHORIZES IT: "First reconcile D-396's accepted
## state in the runtime and update all corresponding truthfulness pins together
## without weakening behavioural guards. The new state must show D-396 accepted
## and this cohesion stage OPEN."
##
## SO IT STATES SIX FACTS, AND NONE IS FALSE:
##   * the bounded FOUNDATION STAGE is ACCEPTED and CLOSED (D-373);
##   * the GLOBAL IMPRINT SYSTEM PROTOTYPE stage is ACCEPTED and CLOSED (D-376);
##   * the D-378 ALIGNMENT STAGE is ACCEPTED and CLOSED (D-383);
##   * the HUNTRESS SPLINTER SHOT STAGE is ACCEPTED and CLOSED (D-394);
##   * the KINDRED HOUNDS STAGE is ACCEPTED and CLOSED (D-397);
##   * the MOBILE MINION COHESION STAGE is DELIVERED and OPEN (D-398).
## Every pin that asserts it moved IN THE SAME CHANGE, each state pin is still an
## EXACT-LINE match, and each GAINED an absence check for the D-396-era line.
## ============================================================================
## RECONCILED A SIXTH TIME UNDER D-400, AS ITS FIRST ACT, AS THE RULING DIRECTS.
## ============================================================================
## From D-398 until D-400 this read:
##   "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and
##    CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) ·
##    HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS
##    STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE DELIVERED
##    and OPEN pending owner live review (D-398)"
## and IT WAS TRUE WHEN WRITTEN. D-399 (2026-09-20) then ACCEPTED and CLOSED the
## cohesion stage -- a DOCUMENTATION-ONLY closure that deliberately changed no
## runtime, suite or runner file, so the artifact kept printing the state it was
## accepted in. D-399 section 6 DECLARED that discrepancy and RECOMMENDED --
## explicitly NOT authorizing -- its repair by the next authorized stage as that
## stage's first act. THE D-400 RULING AUTHORIZES IT: "First reconcile D-398's
## accepted state and update all related truthfulness pins together. The runtime
## must show D-398 accepted and this locomotion stage OPEN."
##
## THE OWNER'S ANSWERS ARE D-399's, AND THEY ARE QUOTED RATHER THAN SUMMARISED.
## CO-01..CO-05 were answered DIRECTLY -- the pack "stays appropriately around or
## ahead of me", "avoids problematic trailing", "handles congestion acceptably",
## "transitions cleanly between combat and travel", "recovers unobtrusively at
## extreme speed" -- and the qualifiers are preserved as given. D-399 also RULED
## on the regroup reading: "The 9 m disengage / 6 m reacquire interpretation of
## regrouping overriding combat is accepted", with the SHAPE canon and the two
## distances NOT locked.
##
## SO IT STATES SEVEN FACTS, AND NONE IS FALSE:
##   * the bounded FOUNDATION STAGE is ACCEPTED and CLOSED (D-373);
##   * the GLOBAL IMPRINT SYSTEM PROTOTYPE stage is ACCEPTED and CLOSED (D-376);
##   * the D-378 ALIGNMENT STAGE is ACCEPTED and CLOSED (D-383);
##   * the HUNTRESS SPLINTER SHOT STAGE is ACCEPTED and CLOSED (D-394);
##   * the KINDRED HOUNDS STAGE is ACCEPTED and CLOSED (D-397);
##   * the MOBILE MINION COHESION STAGE is ACCEPTED and CLOSED (D-399);
##   * the PLAYER LOCOMOTION REDIRECTION STAGE is DELIVERED and OPEN (D-400).
## Every pin that asserts it moved IN THE SAME CHANGE, each state pin is still an
## EXACT-LINE match, and each GAINED an absence check for the D-398-era line.
##
## ============================================================================
## RECONCILED A SEVENTH TIME UNDER D-402, AS ITS FIRST ACT, AS D-401 RECOMMENDED.
## ============================================================================
## From D-400 until D-402 this read:
##   "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and
##    CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) ·
##    HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS
##    STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED
##    and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN
##    pending owner live review (D-400)"
## and IT WAS TRUE WHEN WRITTEN. D-401 (2026-09-20) then ACCEPTED and CLOSED the
## locomotion stage -- a DOCUMENTATION-ONLY closure that deliberately changed no
## runtime, suite or runner file, so the artifact kept printing the state it was
## accepted in. D-401 section 6 DECLARED that discrepancy and RECOMMENDED --
## explicitly NOT authorizing -- its repair by the next authorized stage as that
## stage's first act. THE D-402 RULING AUTHORIZES IT: "Update ProdConfig.STATE so
## the runtime truthfully reports all seven previous game3d stages accepted and
## this Cinder Field stage OPEN ... Move the runtime state, owed rows, self-denial
## text and every exact test pin together."
##
## THE OWNER'S ANSWER IS D-401's, AND IT IS QUOTED RATHER THAN SUMMARISED.
## LO-01..LO-04 were answered DIRECTLY, in the owner's own words:
##   "works well, I like it."
## Nothing more is read into it: no rate, response time, arrival ceiling or
## diagnostic multiplier became a lock, and LD-02 stays CARRIED as a MEASURED
## PROVISIONAL FINDING -- not a defect awaiting repair, and not a rule.
##
## SO IT STATES EIGHT FACTS, AND NONE IS FALSE:
##   * the bounded FOUNDATION STAGE is ACCEPTED and CLOSED (D-373);
##   * the GLOBAL IMPRINT SYSTEM PROTOTYPE stage is ACCEPTED and CLOSED (D-376);
##   * the D-378 ALIGNMENT STAGE is ACCEPTED and CLOSED (D-383);
##   * the HUNTRESS SPLINTER SHOT STAGE is ACCEPTED and CLOSED (D-394);
##   * the KINDRED HOUNDS STAGE is ACCEPTED and CLOSED (D-397);
##   * the MOBILE MINION COHESION STAGE is ACCEPTED and CLOSED (D-399);
##   * the PLAYER LOCOMOTION REDIRECTION STAGE is ACCEPTED and CLOSED (D-401);
##   * the CINDER FIELD STAGE is DELIVERED and OPEN (D-402).
## Every pin that asserts it moved IN THE SAME CHANGE, each state pin is still an
## EXACT-LINE match, and each GAINED an absence check for the D-400-era line.
##
## ============================================================================
## RECONCILED AN EIGHTH TIME UNDER D-404, AS ITS FIRST ACT, AS THE RULING DIRECTS.
## ============================================================================
## From D-402 until D-404 this read:
##   "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and
##    CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) ·
##    HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS
##    STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED
##    and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and
##    CLOSED (D-401) · CINDER FIELD STAGE DELIVERED and OPEN pending owner live
##    review (D-402)"
## and IT WAS TRUE WHEN WRITTEN. D-403 (2026-09-28) then ACCEPTED and CLOSED the
## Cinder Field stage -- a DOCUMENTATION-ONLY closure that changed no runtime,
## suite or runner file, so the artifact kept printing the state it was accepted
## in. THE SAME RULING directs this reconciliation as the D-404 stage's first
## act: "ProdConfig.STATE must report stages 1-8 accepted and this correction
## stage OPEN ... Move the runtime state, self-denial text and every exact test
## pin together. Do not infer numerical acceptance."
##
## THE OWNER'S ANSWER IS D-403's, AND IT IS QUOTED RATHER THAN SUMMARISED:
##   "Looks and feels good."
## It accepts Cinder Field's ARCHITECTURE and REVIEWED BEHAVIOUR. No timing,
## damage, radius, duration, cost, Capacity value, instance cap, animation,
## placeholder model, diagnostic visual or presentation detail became a lock.
##
## SO IT STATES NINE FACTS, AND NONE IS FALSE:
##   * the bounded FOUNDATION STAGE is ACCEPTED and CLOSED (D-373);
##   * the GLOBAL IMPRINT SYSTEM PROTOTYPE stage is ACCEPTED and CLOSED (D-376);
##   * the D-378 ALIGNMENT STAGE is ACCEPTED and CLOSED (D-383);
##   * the HUNTRESS SPLINTER SHOT STAGE is ACCEPTED and CLOSED (D-394);
##   * the KINDRED HOUNDS STAGE is ACCEPTED and CLOSED (D-397);
##   * the MOBILE MINION COHESION STAGE is ACCEPTED and CLOSED (D-399);
##   * the PLAYER LOCOMOTION REDIRECTION STAGE is ACCEPTED and CLOSED (D-401);
##   * the CINDER FIELD STAGE is ACCEPTED and CLOSED (D-403);
##   * the PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE is DELIVERED and OPEN
##     (D-404).
## Every pin that asserts it moved IN THE SAME CHANGE, each state pin is still an
## EXACT-LINE match, and each GAINED an absence check for the D-402-era line.
const STATE := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE ACCEPTED and CLOSED (D-403) · PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"

## ============================================================================
## THIS REGISTRY IS NOW ONE OF TWO, AND THE INVARIANT SPANS BOTH.
## ============================================================================
## Everything above and below belongs to the ACCEPTED D-373 baseline and NOT ONE
## VALUE OF IT WAS MODIFIED BY D-375. The values the Imprint stage introduces
## live in `ImprintConfig.provisional_registry()`, and BOTH registries are
## printed at runtime and by both suites.
##
## The stated invariant -- "a value that is not in that registry and is not
## structural is a defect" -- therefore holds across the UNION of the two, and
## each suite asserts its own half. Two registries are declared here rather than
## chained together in code, because a cyclic reference between two
## configuration files is a parse-order trap and not a safety property.
const IMPRINT_STAGE_REGISTRY := "ImprintConfig.provisional_registry() — the D-375 stage's own values"
## D-396 added HoundConfig's, D-398 CohortConfig's, and D-400 LocomotionConfig's.
## The invariant spans every one of them, and each suite asserts its own.
const LOCOMOTION_STAGE_REGISTRY := "LocomotionConfig.registry() — the D-400 stage's own values"
## D-402 adds CinderConfig's. Seven registries now; the invariant still spans the
## UNION, and each suite still asserts its own half.
const CINDER_STAGE_REGISTRY := "CinderConfig.registry() — the D-402 stage's own values"
## D-404 adds DirectClickConfig's. Eight registries now; the invariant still spans
## the UNION, and each suite still asserts its own half.
const DIRECT_CLICK_STAGE_REGISTRY := "DirectClickConfig.registry() — the D-404 stage's own values"

# --- Output ------------------------------------------------------------------
# PROVISIONAL. Carried from the accepted spike as the review output.
const OUTPUT_WIDTH := 1920
const OUTPUT_HEIGHT := 1080

# --- Camera ------------------------------------------------------------------
# PROVISIONAL, carried from the accepted D-366 spike exactly as the ruling says
# to ("Begin from the accepted spike's provisional -52 degree camera pitch and
# bounded zoom behaviour"), and RE-EVALUATED here rather than inherited.
const CAM_PITCH_DEG := -52.0
const CAM_YAW_DEG := 45.0
const CAM_ROLL_DEG := 0.0
const CAM_BOOM_DISTANCE := 48.0          # orthographic: affects clipping only
const CAM_SIZE_DEFAULT := 14.0           # vertical extent of the view, metres
const CAM_SIZE_MIN := 11.0               # zoom-in bound
const CAM_SIZE_MAX := 18.0               # zoom-out bound
const CAM_ZOOM_STEP := 0.6
const CAM_FOLLOW_LAG := 8.0

# --- Movement ----------------------------------------------------------------
# ============================================================================
# 3.889 m/s IS A STARTING CANDIDATE. IT IS NOT A VALUE, A TARGET OR A LOCK.
# ============================================================================
# D-367 judged the spike's 5.0 m/s "somewhat too fast" and LOCKED NO REPLACEMENT.
# 3.889 m/s is the framing-matched equivalent D-366 measured, carried forward by
# D-367 as "the next PROVISIONAL STARTING CANDIDATE for later combat tuning".
# The ruling for this foundation says: "Begin movement evaluation at 3.889 m/s"
# and "Re-evaluate these values in the production architecture."
#
# THIS FOUNDATION RUNS AT THE CANDIDATE AND MEASURES IT. IT DOES NOT SETTLE IT.
const TOP_SPEED_MPS := 3.889
const TOP_SPEED_STATUS := "PROVISIONAL STARTING CANDIDATE (D-367) — NOT a lock, NOT settled by being used"
const ACCEL_MPS2 := 30.0
const DECEL_MPS2 := 38.0
const STICK_DEADZONE := 0.2

## Continuous yaw. D-367 closed the 3D facing question: CONTINUOUS YAW, and the
## eight-direction restriction of the pixel-art prototype is NOT preserved.
## The ruling decides a DIRECTION and authorizes no implementation, so this rate
## is PROVISIONAL and is measured, never cited.
const YAW_RATE_DEG_PER_S := 720.0

## Click-to-move arrival tolerance and repath cadence. PROVISIONAL.
const ARRIVE_TOLERANCE_M := 0.35
const REPATH_INTERVAL_S := 0.20

# --- Bodies and navigation ---------------------------------------------------
# PROVISIONAL. The navigation agent radius and the body radius are deliberately
# the SAME number: a navigation mesh eroded by a different radius from the one
# the body actually occupies is how a corridor silently disappears.
const PLAYER_BODY_RADIUS := 0.40
const ENEMY_BODY_RADIUS := 0.42
const NAV_AGENT_RADIUS := 0.40
const NAV_AGENT_HEIGHT := 1.80
const NAV_AGENT_MAX_CLIMB := 0.30
const NAV_AGENT_MAX_SLOPE_DEG := 30.0
const NAV_CELL_SIZE := 0.12
const NAV_CELL_HEIGHT := 0.20
## Everything walkable must sit inside this band around the ground plane.
## A navigation polygon on top of a column is the 3D return of the project's
## own "open-topped box collider baking a walkable interior" defect class, which
## `CLAUDE.md` section 5.2 correctly records that 2D removed -- and 3D restores.
const NAV_GROUND_BAND_M := 0.60

## ============================================================================
## GROUND DECALS SIT ABOVE THE FLOOR'S *VISUAL* SURFACE, NOT ABOVE y = 0.
## ============================================================================
## MEASURED: `Floor_Standard`'s AABB runs from y = -0.253 to y = +0.033, so the
## surface a player actually sees is at +0.033 m -- not at the collision plane.
## Telegraphs and shadows first went in at +0.02 and +0.03, i.e. INSIDE the floor
## slab, and the brick geometry punched through them: a telegraph that should
## have read as a solid wedge rendered as a red hatch.
##
## No check in the suite would ever have caught that. The rendered frame did.
const FLOOR_VISUAL_TOP_Y := 0.033
const DECAL_SHADOW_Y := 0.050
const DECAL_TELEGRAPH_Y := 0.065
const DECAL_TELEGRAPH_RING_Y := 0.075

# --- The ONE diagnostic player attack ----------------------------------------
# CLAUDE.md 3.5 permits P1 exactly ONE explicitly diagnostic, non-canonical
# projectile action, WHICH MUST BE LABELLED DIAGNOSTIC IN THE RUNTIME.
#
# THIS IS THAT ACTION, AND THERE IS EXACTLY ONE OF THEM.
# It is NOT a designed Skill. It is NOT the Huntress's. It is NOT the Mage spell
# (original P1C criterion C9, which remains TRANSFERRED to the future Mage art
# phase and must not be attempted here). It defines NO class mechanic.
const DIAG_ATTACK_DESIGN_NAME := "DIAGNOSTIC PROBE BOLT"
const DIAG_ATTACK_LABEL := "DIAGNOSTIC — non-canonical, not a Skill"
const DIAG_ATTACK_DENIALS := [
	"The diagnostic probe bolt is NOT a Huntress Skill.",
	"The diagnostic probe bolt is NOT the Mage spell (original P1C C9, still TRANSFERRED).",
	"The diagnostic probe bolt is NOT canonical and defines NO class mechanic.",
]
const BOLT_SPEED_MPS := 24.0
const BOLT_RANGE_M := 16.0
const BOLT_DAMAGE := 34.0
const BOLT_RADIUS_M := 0.28
const ATTACK_COOLDOWN_S := 0.45
## MECHANICAL TIMING IS AUTHORITATIVE OVER ANIMATION TIMING. The bolt leaves at
## this fraction of the ACTION's own normalised time, never when the borrowed
## clip happens to look right, and never at a rate the clip's playback speed can
## move. The suite proves that independence.
const ATTACK_RELEASE_MARKER := 0.36

# --- Action-movement commitment ----------------------------------------------
# ============================================================================
# ADDED BY THE D-370 OWNER LIVE REVIEW. THESE ARE TIMING/BRAKING VALUES AND THEY
# ARE PROVISIONAL, exactly like every other value in this file.
# ============================================================================
# The owner's finding: "The player feels too slidey when attacking because
# locomotion continues through the diagnostic attack. Do not reduce global
# movement speed; that speed currently feels good."
#
# So TOP_SPEED_MPS IS UNCHANGED. What changes is that a committed action brakes
# the actor instead of letting the existing DECEL_MPS2 coast it out: at
# 3.889 m/s the ordinary braking rate takes 0.102 s and 0.199 m to stop, which
# is a visible glide across a fifth of a metre. THE BRAKE BELOW IS SEPARATE FROM
# ORDINARY BRAKING and is used only inside a committed action.
const ACTION_BRAKE_MPS2 := 120.0
## The measured allowance for "no visible glide". At the brake above, a stop from
## full speed covers 0.063 m; this is the ceiling the suite asserts against.
const ACTION_GLIDE_TOLERANCE_M := 0.10

# --- The ordinary enemy ------------------------------------------------------
const ENEMY_HEALTH := 120.0
const ENEMY_SPEED_MPS := 2.4
const ENEMY_ACQUIRE_RADIUS_M := 11.0
const ENEMY_DEACQUIRE_RADIUS_M := 15.0
const ENEMY_ATTACK_RANGE_M := 1.9
const ENEMY_WINDUP_S := 0.85           # telegraph is visible for this long
const ENEMY_COMMIT_S := 0.18           # the damaging window
const ENEMY_RECOVER_S := 0.55
const ENEMY_ATTACK_ARC_DEG := 90.0     # TOTAL width, applied as a half-width
const ENEMY_ATTACK_DAMAGE := 12.0
const ENEMY_COOLDOWN_S := 1.30
const ENEMY_COUNT := 4

# --- Palette (PROVISIONAL) ---------------------------------------------------
# The validated direction: ordinary surfaces stay visually quiet; identity
# concentrates in characters, monsters, Skills, VFX and UI.
const COL_STONE_MAIN := Color(0.232, 0.256, 0.318)
const COL_STONE_HIGHLIGHT := Color(0.302, 0.328, 0.392)
const COL_GROUND := Color(0.150, 0.168, 0.214)
const COL_WOOD := Color(0.152, 0.116, 0.092)
const COL_METAL := Color(0.148, 0.156, 0.184)
const COL_TORCH_WARM := Color(1.0, 0.552, 0.212)
const COL_RIFT_VIOLET := Color(0.588, 0.286, 1.0)
const COL_TELEGRAPH := Color(0.92, 0.18, 0.22)

# PROVISIONAL, and REDUCED from the accepted spike's values after looking at
# this arena's own rendered frames: the validated direction asks that ordinary
# surfaces stay visually QUIET, and at the spike's energies this larger,
# nine-torch arena read as the brightest thing on screen.
const TORCH_LIGHT_ENERGY := 10.0
const TORCH_LIGHT_RANGE := 12.0
const AMBIENT_ENERGY := 0.55
const SUN_ENERGY := 0.62

# --- Clip mapping ------------------------------------------------------------
# TRUTHFULNESS: these are the ACTUAL clip names in the merged UAL1 + UAL2
# corpus. Nothing is renamed to suggest it is something it is not, and the
# debug overlay prints the DESIGN name and the SOURCE CLIP name separately so a
# borrowed clip is never presented as a designed move.
#
# Godot's glTF importer STRIPS the "_Loop" suffix and marks those clips looping
# instead, so these are the IMPORTED names, verified against the loaded
# AnimationLibrary rather than against the names inside the .glb.
const CLIP_PLAYER_IDLE := "Idle"             # UAL1 — a real neutral idle
const CLIP_PLAYER_WALK := "Walk"             # UAL1 — a real NEUTRAL walk
const CLIP_PLAYER_RUN := "Jog_Fwd"           # UAL1
const CLIP_PLAYER_ATTACK := "Spell_Simple_Shoot"  # UAL1 — see DIAG_ATTACK_DENIALS
const CLIP_ENEMY_IDLE := "Zombie_Idle"       # UAL2
const CLIP_ENEMY_CHASE := "Zombie_Walk_Fwd"  # UAL2
const CLIP_ENEMY_WINDUP := "Idle_FoldArms"   # UAL2 — held pose during the telegraph
const CLIP_ENEMY_ATTACK := "Zombie_Scratch"  # UAL2
const CLIP_ENEMY_HIT := "Hit_Chest"          # UAL1
const CLIP_ENEMY_DEATH := "Death01"          # UAL1 — a REAL death clip

const REQUIRED_CLIPS := [
	CLIP_PLAYER_IDLE, CLIP_PLAYER_WALK, CLIP_PLAYER_RUN, CLIP_PLAYER_ATTACK,
	CLIP_ENEMY_IDLE, CLIP_ENEMY_CHASE, CLIP_ENEMY_WINDUP, CLIP_ENEMY_ATTACK,
	CLIP_ENEMY_HIT, CLIP_ENEMY_DEATH,
]

## The speed at which the walk clip gives way to the jog. PROVISIONAL.
const LOCOMOTION_RUN_THRESHOLD_MPS := 2.2

# --- Corpus facts, MEASURED (re-measured live on every verification run) ------
const EXPECT_UAL_BONES := 65
const EXPECT_BESTIARY_BONES := 55
const EXPECT_ABSENT_BONES := 10
const EXPECT_EXTRA_BONES := 0
const EXPECT_CLIPS_PER_LIBRARY := 43
const EXPECT_COMBINED_DISTINCT_CLIPS := 85
const SKELETON_NODE_PATH := "Armature/Skeleton3D"

## What the corpus CANNOT supply. Measured against all 85 clips, printed at
## runtime and in the report. Nothing is hidden.
const CORPUS_GAPS := [
	"NO bow / archery / aim-draw / shoot-a-bow clip exists: 0 of 85 match bow/arrow/draw/archer.",
	"  -> This foundation therefore attaches NO weapon to the player probe at all.",
	"  -> The D-369 bow-attachment debt is NOT reproduced here, and is NOT discharged either.",
	"  -> D-392 (stage 4): the Huntress layer now carries a PLACEHOLDER bow, animated from the KayKit (CC0) bow clips -- NOT this corpus. The two lines above describe the FOUNDATION stage and stay true of it.",
	"CORRECTED PREMISE: a NEUTRAL walk DOES exist — 'Walk', 'Jog_Fwd' and 'Sprint', all from UAL1.",
	"  -> D-366's 'no neutral walk' gap D03 was a UAL2-ONLY limitation, exactly as D02 was.",
	"  -> It remains undischarged for a character CARRYING a weapon. This probe carries none.",
	"A REAL death clip exists: 'Death01' (UAL1). No code-driven topple is used or needed.",
	"NO creature-specific clip exists: all 85 target the 65-joint HUMAN rig.",
	"NO facial rig: the 55-joint Bestiary rig has one head bone and no facial bones.",
]

# --- The provisional registry ------------------------------------------------
## Every tuning value the owner told this foundation not to lock, with its live
## value. Printed at runtime and by the suite; the suite asserts the registry is
## non-empty, that each row carries the word PROVISIONAL, and that no forbidden
## lock appears among the live values.
static func provisional_registry() -> Array:
	return [
		["camera pitch (deg)", CAM_PITCH_DEG, "PROVISIONAL — carried from the accepted D-366 spike; praise is not a lock"],
		["camera yaw (deg)", CAM_YAW_DEG, "PROVISIONAL"],
		["ortho size default (m)", CAM_SIZE_DEFAULT, "PROVISIONAL"],
		["zoom bound min (m)", CAM_SIZE_MIN, "PROVISIONAL — carried from the accepted spike"],
		["zoom bound max (m)", CAM_SIZE_MAX, "PROVISIONAL — carried from the accepted spike"],
		["top speed (m/s)", TOP_SPEED_MPS, TOP_SPEED_STATUS],
		["acceleration (m/s^2)", ACCEL_MPS2, "PROVISIONAL"],
		["braking (m/s^2)", DECEL_MPS2, "PROVISIONAL"],
		["yaw rate (deg/s)", YAW_RATE_DEG_PER_S, "PROVISIONAL — D-367 decided the direction, not the rate"],
		["arrival tolerance (m)", ARRIVE_TOLERANCE_M, "PROVISIONAL"],
		["nav agent radius (m)", NAV_AGENT_RADIUS, "PROVISIONAL"],
		["player body radius (m)", PLAYER_BODY_RADIUS, "PROVISIONAL"],
		["enemy body radius (m)", ENEMY_BODY_RADIUS, "PROVISIONAL"],
		["bolt speed (m/s)", BOLT_SPEED_MPS, "PROVISIONAL"],
		["bolt range (m)", BOLT_RANGE_M, "PROVISIONAL"],
		["bolt damage", BOLT_DAMAGE, "PROVISIONAL"],
		["attack cooldown (s)", ATTACK_COOLDOWN_S, "PROVISIONAL"],
		["release marker (normalised)", ATTACK_RELEASE_MARKER, "PROVISIONAL"],
		["action brake (m/s^2)", ACTION_BRAKE_MPS2, "PROVISIONAL — added by the D-370 live review; separate from ordinary braking"],
		["action glide tolerance (m)", ACTION_GLIDE_TOLERANCE_M, "PROVISIONAL — the measured ceiling for 'no visible glide'"],
		["enemy health", ENEMY_HEALTH, "PROVISIONAL"],
		["enemy speed (m/s)", ENEMY_SPEED_MPS, "PROVISIONAL"],
		["enemy acquire radius (m)", ENEMY_ACQUIRE_RADIUS_M, "PROVISIONAL"],
		["enemy windup (s)", ENEMY_WINDUP_S, "PROVISIONAL"],
		["enemy commit (s)", ENEMY_COMMIT_S, "PROVISIONAL"],
		["enemy attack arc (deg, TOTAL)", ENEMY_ATTACK_ARC_DEG, "PROVISIONAL"],
		["enemy attack damage", ENEMY_ATTACK_DAMAGE, "PROVISIONAL"],
		["output width (px)", OUTPUT_WIDTH, "PROVISIONAL REVIEW OUTPUT — not a product lock"],
		["output height (px)", OUTPUT_HEIGHT, "PROVISIONAL REVIEW OUTPUT — not a product lock"],
	]

## The 2D owner locks, quoted ONLY so the suite can prove none of them is live
## here. Each row is [label, value].
static func forbidden_2d_locks() -> Array:
	return [
		["px/m (game2d D-356 lock)", 60.0],
		["character cell px (game2d D-356 lock)", 128.0],
		["iso tile width px (game2d D-356 lock)", 120.0],
		["iso tile height px (game2d D-356 lock)", 60.0],
		["ground anchor x px (game2d D-356 lock)", 64.0],
		["ground anchor y px (game2d D-356 lock)", 122.0],
		["camera footprint width m (game2d D-356 lock)", 32.0],
		["camera footprint height m (game2d D-356 lock)", 18.0],
	]

## The denials this foundation owes. A claim nobody can fail is not a boundary,
## so the suite proves the denial guard itself can fail against a planted claim.
static func denials() -> Array:
	return [
		"This foundation COMPLETES NO PHASE in the P0-P7 table.",
		"This foundation DOES NOT COMPLETE P1.",
		"This foundation DOES NOT COMPLETE the original P1C.",
		"This foundation DOES NOT AUTHORIZE P2.",
		"NO canonical Huntress class specification is written here; one remains a P2 prerequisite.",
		"This is NOT final art and NOT the final Huntress. NO placeholder asset is final.",
		"There is NO production boss here, and NOTHING here may be cited for a non-humanoid boss.",
		"There is NO campaign, prologue or Act I content here. The arena is a TEST ARENA, not a zone.",
		"There is NO loot, economy or progression here.",
		"The action-movement commitment is NOT a Skill system and NOT an ability framework.",
		"NO value here is a production lock.",
		"NO 2D lock from game2d/ is promoted here.",
		"NO value from game3d_spike/ or game3d_boss_spike/ is promoted to a lock here.",
		"The D-375 Imprint stage MODIFIES NO VALUE of this accepted D-373 baseline.",
		"The D-375 Imprint stage FINALIZES NO ROSTER, SLOT COUNT, RANK CAP, CAPACITY VALUE, XP CURVE, RESERVATION VALUE OR BALANCE.",
	]

## Implementation reused from the frozen prototypes, declared truthfully.
## The ruling: "Any directly reused implementation must be identified truthfully."
## There is NO RUNTIME DEPENDENCY on any prototype -- nothing here loads, scans
## or references a file outside game3d/. These are CONCEPTS re-implemented, and
## where a technique was taken close to verbatim it says so.
static func reuse_declaration() -> Array:
	return [
		["iso_camera rotation-lock-every-frame", "game3d_spike/scripts/iso_camera.gd",
		 "TECHNIQUE REUSED CLOSELY. Re-implemented; the boom-offset sign fix (+basis.z, not -basis.z) is carried because the spike had already paid for that mistake."],
		["cursor -> ground plane ray + test seam", "game3d_spike/scripts/iso_camera.gd",
		 "TECHNIQUE REUSED CLOSELY, re-implemented. The debug_cursor_override seam is the same idea."],
		["measure_subset both-directions rig test", "game3d_boss_spike/scripts/rig_compat.gd",
		 "TECHNIQUE REUSED CLOSELY, re-implemented, with the same both-directions semantics."],
		["play_guarded / missing-clip is never a silent no-op", "game3d_boss_spike/scripts/rig_compat.gd",
		 "TECHNIQUE REUSED CLOSELY, re-implemented, including the single-mechanism speed_scale lesson."],
		["ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS", "game3d_boss_spike/scripts/rig_compat.gd",
		 "DECISION REUSED. Stepping animation with the simulation is what makes timing measurements exact."],
		["runtime material override instead of editing sources", "both spikes",
		 "APPROACH REUSED. No source mesh or texture is edited anywhere."],
		["prop_scale_for from a mesh's own AABB", "game3d_boss_spike/scripts/rig_compat.gd",
		 "TECHNIQUE REUSED, re-implemented. Scales are measured, never copied."],
		["yaw-continuity test with a quantised negative control", "game3d_boss_spike/tests/boss_gate_verification.gd",
		 "TECHNIQUE REUSED CLOSELY, re-implemented."],
		["exact orthographic projection instead of unproject_position", "game3d_boss_spike/tests/boss_gate_verification.gd",
		 "TECHNIQUE REUSED CLOSELY, re-implemented."],
		["environment tone response (ACES, exposure 1.30, white 5.0, glow threshold, SSAO radius)",
		 "game3d_spike/scripts/spike_main.gd",
		 "VALUES CARRIED, all PROVISIONAL. The first captures here washed out because Godot's default tonemap_white of 1.0 lifts the whole mid-range; the accepted spike had already solved that and its tone response is reused rather than re-derived."],
		["runner shape: error guard, both-direction pins, isolation baselines", "both spikes' tests/*.sh",
		 "STRUCTURE REUSED CLOSELY and extended with an import pass and a fourth protected project."],
	]

## Everything this foundation does that neither spike did, recorded so it is
## never mistaken for discharging an older obligation.
static func new_here() -> Array:
	return [
		"A REAL baked NavigationMesh. Both spikes chased directly, with none.",
		"Per-prop authored collision. game3d_spike/ used ONE perimeter box and said so.",
		"Path reachability to the CENTRE of every authored walkable rectangle, with a negative control.",
		"Agent-radius erosion measured at the doorway corridor.",
		"A guard that no navigation polygon sits above the ground band (the 3D return of the open-topped-box defect).",
		"Click-to-move as the canonical mouse scheme, with NO WASD binding.",
		"A third-party ingestion SYSTEM: the manifest is the single runtime source of truth and the document is verified against it.",
		"An action-movement commitment policy with EXACTLY TWO options (STOP / ALLOW) — added by the D-370 live review, and deliberately not an ability framework.",
	]
