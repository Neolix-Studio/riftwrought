class_name DirectClickConfig
extends RefCounted

## RIFTWROUGHT — THE PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE: its own registry (D-404).
##
## ============================================================================
## ONE BOUNDED CORRECTION TO PLAYER MOUSE LOCOMOTION. NOTHING ELSE.
## ============================================================================
## The owner, verbatim: "When I click across an obstacle, the current system
## feels magnetic because it routes the player around it. I want the player to
## move directly toward the clicked point and run into the obstacle. The player
## should have to issue additional movement clicks to navigate around it."
##
## MEASURED BEFORE ANY CHANGE, not assumed: a click behind the interior blocker
## was given a 6-point navigation path and the player detoured to |z| = 3.44 m
## round the wall's end; an off-mesh click was snapped 6.56 m onto the mesh; every
## destination sat at y = 0.3, the baked surface, not the clicked ground point.
##
## ---------------------------------------------------------------------------
## WHAT CHANGES: a mouse order goes STRAIGHT at the clicked point, and stops at
## the first thing that blocks it. WHAT DOES NOT: the controller stick, the
## accepted scalar-speed motor and its rates, the arrival tolerance, the action
## commitment and its brake, aiming, facing, enemies, hounds, the cohort, the
## navigation mesh, collision shapes, layers and masks, and Cinder Field's
## placement rules.
## ---------------------------------------------------------------------------
##
## THIS STAGE INTRODUCES THREE NUMBERS AND ONE STRUCTURAL BOUND. EVERY ONE IS
## PROVISIONAL, AND NONE IS A LOCK. The accepted values it reads -- the top speed,
## the rates, the arrival tolerance, the body radius -- are READ, never copied.

const DECISION := "D-404"
const DATE := "2026-09-28"
const STAGE := "PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE"

# =============================================================================
# THE STAGE'S OWN NUMBERS.
# =============================================================================

## A contact whose normal's |y| is BELOW this is a BLOCKER (a wall, a prop, a
## body); at or above it, the FLOOR. The actor's cylinder rests on the floor slab
## and a horizontal sweep can graze it, so "did it collide" is not the question --
## the accepted D-400 suite measured exactly that and uses exactly this rule to
## tell a wall from the floor. Reusing its value keeps one meaning for "wall".
const WALL_NORMAL_MAX_Y := 0.5

## How far the actor may be displaced from the point where a click order was
## BLOCKED before that remembered contact stops applying. While she is still
## there, a new order pointing INTO that blocker stops at once instead of
## sweeping again -- which is what stops a held cursor from CREEPING along a wall
## by the engine's collision margin every frame.
const CONTACT_HOLD_M := 0.005

## A direction "points into" a remembered contact when its dot product with the
## contact normal is below minus this. A direction exactly PARALLEL to the wall
## is therefore not into it, and moves.
const INTO_EPSILON := 0.0001

## STRUCTURAL: the most sweeps one physics step may make. Only a FLOOR graze
## re-sweeps -- a blocker ends the step -- so this bounds a degenerate case, it
## does not tune anything.
const MAX_SWEEPS := 3

# =============================================================================
# THE REGISTRY — printed at runtime, asserted by the D-404 suite.
# =============================================================================
static func registry() -> Array:
	return [
		["wall normal max |y|", WALL_NORMAL_MAX_Y,
		 "PROVISIONAL — the same wall/floor rule the accepted D-400 suite measured and uses (L20); NOT a lock"],
		["contact hold distance (m)", CONTACT_HOLD_M,
		 "PROVISIONAL — how far she may be moved from a blocked stop before that contact stops applying; NOT a lock"],
		["into-contact epsilon (dot)", INTO_EPSILON,
		 "PROVISIONAL — below minus this a direction points INTO a remembered contact; parallel is not into; NOT a lock"],
		["sweeps per step (structural)", MAX_SWEEPS,
		 "PROVISIONAL — STRUCTURAL: a floor graze re-sweeps, a blocker ends the step; bounds a degenerate case"],
	]

## The owner's SEVENTEEN movement items, verbatim in substance, each with EXACTLY
## ONE disposition. Printed at runtime and proved identical to the inventory.
static func canonical_rulings() -> Array:
	return [
		["D-404 item 1", "store the actual clicked ground point as the destination", "IMPLEMENTED"],
		["D-404 item 2", "do not snap that destination to the nearest navigation point", "IMPLEMENTED"],
		["D-404 item 3", "do not ask NavigationServer3D for a player path", "IMPLEMENTED"],
		["D-404 item 4", "do not feed the order through NavService.PathFollower", "IMPLEMENTED"],
		["D-404 item 5", "every movement step points directly from the player's current ground point toward the clicked destination", "IMPLEMENTED"],
		["D-404 item 6", "if nothing blocks the route, retain the accepted acceleration, braking, arrival and same-frame redirection", "PRESERVED — the accepted motor is called unchanged"],
		["D-404 item 7", "if world geometry or another solid body blocks the direct route, stop at the collision", "IMPLEMENTED"],
		["D-404 item 8", "do not steer around, repath around, project movement around or select an alternate route", "IMPLEMENTED"],
		["D-404 item 9", "a click-driven order does not convert blocked motion into tangential wall sliding", "IMPLEMENTED"],
		["D-404 item 10", "clear the order when it hits a blocker; a held button may keep requesting the cursor point without routing, creeping, oscillation or tangential travel", "IMPLEMENTED"],
		["D-404 item 11", "a new valid click away from the obstacle moves the player immediately", "IMPLEMENTED"],
		["D-404 item 12", "preserve direct controller-stick movement unchanged", "PRESERVED — the stick still resolves collision with move_and_slide()"],
		["D-404 item 13", "preserve independent aiming and movement", "PRESERVED"],
		["D-404 item 14", "preserve action commitment, wind-up buffering, recovery cancellation and released-Skill persistence", "PRESERVED"],
		["D-404 item 15", "preserve the accepted scalar-speed / no-directional-inertia model", "PRESERVED"],
		["D-404 item 16", "preserve the accepted top speed and the diagnostic FAST / EXTREME modes", "PRESERVED"],
		["D-404 item 17", "prevent tunnelling at every diagnostic speed", "IMPLEMENTED — every click step is a continuous sweep"],
	]

## The clauses of the ACCEPTED D-400 rulings this stage supersedes FOR CLICK
## ORDERS ONLY. `LocomotionConfig.canonical_rulings()` is left exactly as D-400
## wrote it -- it is the record of D-400 -- and this is where the supersession is
## declared rather than made silently.
static func supersedes() -> Array:
	return [
		["D-400 item 4", "\"sharp path corners\"", "a click order has NO path, so it has no corners; new click orders and 180 degree reversals still redirect in the same frame"],
		["D-400 item 7", "\"legitimate sliding along walls\"", "for a CLICK order only: it stops at the wall instead (D-404 item 9). The STICK still slides, as accepted"],
		["D-400 item 10", "\"path-corner cutting\"", "a click order has NO path to cut; destination overshoot is still prevented at every speed"],
	]

## What this stage denies, individually. Printed every run.
static func denials() -> Array:
	return [
		"The D-404 stage IS NOT P2 and AUTHORIZES NO P2.",
		"The D-404 stage changes ONLY how a MOUSE click order moves the player: straight at the clicked point, stopping at the first blocker.",
		"The D-404 stage does NOT change controller-stick movement: the stick still resolves collision with move_and_slide() and still slides along walls, as accepted.",
		"The D-404 stage does NOT change enemy, Kindred Hound or mobile-minion navigation, targeting, formation, recovery or soft teleport: they still follow their accepted navigation paths.",
		"The D-404 stage does NOT change the navigation mesh, collision shapes, layers, masks, the player radius or any authored obstacle.",
		"The D-404 stage does NOT change Cinder Field's placement rules.",
		"The D-404 stage is NOT movement-speed tuning: ProdConfig.TOP_SPEED_MPS, the acceleration and braking rates, the arrival tolerance and the diagnostic ORDINARY / FAST / EXTREME multipliers are unchanged.",
		"The D-404 stage does NOT scale, replace or clear the ACTION brake: a committed action still brakes at ProdConfig.ACTION_BRAKE_MPS2, gradually (LD-02 stays a measured provisional finding).",
		"The D-404 stage does NOT change the accepted independent movement-and-aim behaviour: facing still follows the aim, not the feet.",
		"The D-404 stage adds NO input action: the project's 29 accepted actions stay 29, and there is still NO W/A/S/D binding.",
		"The D-404 stage adds NO automatic routing, NO shift-click routing and NO path-to-click option: going round an obstacle takes another click.",
		"The D-404 stage adds NO Skill, Imprint, Configuration, action entry point, asset, animation, audio or VFX.",
		"The D-404 stage's review HUD and world markers are review tooling and ARE NOT a UI foundation.",
		"The D-404 stage LOCKS NO NUMBER: its three values and one structural bound are PROVISIONAL.",
		"The D-404 stage modifies NO accepted spike and has NO runtime dependency outside game3d/.",
		"The D-404 stage delivers OPEN pending owner live review; it does NOT accept itself.",
	]

## Printed every run by the D-404 suite. NONE IS A PASS.
static func deferred_rows() -> Array:
	return [
		["DD-01 numerical tuning of every value this stage introduces", "DEFERRED",
		 "Nothing is locked: its three values and one structural bound are all PROVISIONAL. RETURNS TO: a tuning pass."],
		["DD-02 controller HARDWARE behaviour", "DEFERRED",
		 "No gamepad can be attached here; the stick path is driven through the intent seam. RETURNS TO: owner live review."],
		["DD-03 the D-403 finding: overlapping Cinder Field diagnostic visuals render BRIGHTER and can imply more damage", "CARRIED — NOT REPAIRED",
		 "The rule is right and the picture is misleading; repairing the picture is presentation work, not authorized. RETURNS TO: a presentation pass."],
		["DD-04 the D-403 finding: bindings 7 and 8 have NO controller activation (FD-15)", "CARRIED — NOT REPAIRED",
		 "Fixing it would change project.godot's input map, which needs its own ruling. RETURNS TO: a UI / input foundation."],
		["DD-05 any automatic routing, shift-click routing or path-to-click option for the player", "OUT OF SCOPE",
		 "The ruling removes routing; it does not ask for an alternative. RETURNS TO: nowhere, unless the owner asks."],
		["DD-06 enemy, Kindred Hound and mobile-minion locomotion", "OUT OF SCOPE",
		 "Unchanged by instruction; they still follow their accepted navigation paths. RETURNS TO: nowhere."],
		["DD-07 a redesign of controller-stick collision", "OUT OF SCOPE",
		 "The stick keeps move_and_slide() and its accepted sliding. RETURNS TO: nowhere, unless the owner asks."],
		["DD-08 LD-02: the ACTION brake still resolves through move_and_slide(), so an action begun while moving along a wall can slide during its brake", "CARRIED — PROVISIONAL FINDING",
		 "D-401 forbids replacing or scaling that brake. RETURNS TO: nowhere — carried and measured."],
		["DD-09 ordinary braking AFTER an order ends (arrival, or releasing the stick) still resolves through move_and_slide()", "DECLARED",
		 "Open-space braking is accepted behaviour; a COLLIDED stop leaves nothing to brake. RETURNS TO: nowhere — declared."],
		["DD-10 the accepted D-400 captures d400_corner_extreme and d400_doorway_fast depict ROUTED click movement that no longer exists", "DECLARED — NOT REPAIRED",
		 "Frames 43 and 45 are preserved as historical evidence and their capture code is not re-rendered. RETURNS TO: nowhere — declared."],
		["DD-11 the pre-existing 36 / 35 LIFE CONVERSION overflow of the accepted D-392 loadout (FD-08)", "CARRIED — NOT REPAIRED",
		 "Disclosed at D-396 and never authorized for repair. RETURNS TO: a later stage, if authorized."],
		["DD-12 the five accepted D-389 production-polish debts (FD-17)", "CARRIED — NOT DISCHARGED",
		 "Finger, shoulder, string, hood-intersection and foot-sliding. RETURNS TO: a production-polish pass."],
		["DD-13 LD-03: camera behaviour at extreme speed", "CARRIED — NOT DISCHARGED",
		 "Untouched here. RETURNS TO: a camera pass."],
		["DD-14 D-371's crowd-avoidance / density risk", "CARRIED — NOT DISCHARGED",
		 "Untouched here. RETURNS TO: a crowd-avoidance stage."],
		["DD-15 minion/enemy distinguishability in PRODUCTION", "CARRIED — NOT DISCHARGED",
		 "Untouched here. RETURNS TO: a presentation pass."],
		["DD-16 the earlier runners' delivery-time change-set claims (T17, W17, Y15, Z16, N16, Q16) and the closed D-388 spike runner's K08", "DECLARED — NOT REPAIRED",
		 "Each proves its OWN stage against a listing taken before it; tests/direct_click_smoke.sh U16 proves D-404's. The spikes are NOT edited. RETURNS TO: nowhere — declared."],
		["DD-17 the player's NavigationAgent3D is RETAINED", "DECLARED",
		 "MEASURED reason: the accepted F70 reads its radius. It is given no target and routes nothing. RETURNS TO: nowhere — declared."],
		["DD-18 the player's PathFollower FIELD is RETAINED, INERT", "DECLARED",
		 "Accepted fixtures in five suites call its set_path() to clear it. It never receives a path from the player. RETURNS TO: nowhere — declared."],
		["DD-19 the accepted F26's NAME says \"resolves nearest navigable\"", "DECLARED",
		 "Its body asserts only that an in-bounds click is accepted as clicked and arrives, which still holds, so it is NOT replaced. RETURNS TO: nowhere — declared."],
		["DD-20 performance at production scale", "DEFERRED",
		 "Measured here only in the test arena. RETURNS TO: a performance pass."],
		["DD-21 five accepted stage banners (D-392, D-396, D-398, D-400, D-402) still print \"DELIVERED and OPEN pending owner live review\"", "DECLARED — NOT REPAIRED",
		 "Accepted historical wording that no reconciliation has moved; the STATE line carries the current fact. RETURNS TO: nowhere — declared."],
		# ADDED DURING THE D-404 WORK, and disclosed: found by reading canon for
		# every statement about how a click moves the player.
		["DD-22 CANON DISAGREES: design/UI_AND_USER_EXPERIENCE.md section 115 (\"Clicking through an open doorway may path to visible ground beyond it\") and the 2D proposal section 2.9 / section 9 C4 (\"a click resolves to the nearest navigable point\") describe the superseded routed, snapped behaviour", "DECLARED — NOT REPAIRED",
		 "The owner's D-404 ruling outranks them (CLAUDE.md authority order); they were NOT amended, because this stage authorizes no canonical reconciliation. A bounded canonical reconciliation is RECOMMENDED and NOT AUTHORIZED. RETURNS TO: a canonical reconciliation, if authorized."],
	]

## Printed every run by the D-404 suite. NOT a pass and NOT a failure.
## The owner's six live-review questions, VERBATIM.
static func owed_to_owner() -> Array:
	return [
		["DO-01", "Does clicking behind an obstacle now stop the player where expected?"],
		["DO-02", "Is the magnetic automatic routing gone?"],
		["DO-03", "Does angled contact stop cleanly, or does it feel too sticky?"],
		["DO-04", "Does manually clicking around an obstacle feel fluid?"],
		["DO-05", "Does unobstructed click-to-move still feel unchanged?"],
		["DO-06", "Does it remain stable at FAST and EXTREME speeds?"],
	]

## Reused or informing implementation, declared truthfully. NOTHING here loads a
## file outside game3d/.
static func reuse_declaration() -> Array:
	return [
		["the accepted scalar-speed motor and its rates", "game3d/scripts/control/locomotion_motor.gd and scripts/locomotion/ground_motion.gd (accepted D-373 / D-401)",
		 "USED UNCHANGED: a click order still asks the one motor for its velocity, with the same wish, top speed and arrival ceiling; only the COLLISION RESOLUTION of a click step differs."],
		["the accepted arrival tolerance and arrival ceiling", "game3d/scripts/core/prod_config.gd and GroundMotion.arrival_speed_ceiling (accepted D-373 / D-401)",
		 "USED UNCHANGED: the ceiling now reads the STRAIGHT distance left, which is what the accepted controller already fell back to whenever the follower had no path."],
		["the accepted action commitment, buffer and recovery cancellation", "game3d/scripts/control/action_commitment.gd and player_controller.gd (accepted D-373)",
		 "USED UNCHANGED: a buffered click is applied at release as a direct order."],
		["the accepted collision configuration", "game3d/scripts/control/player_controller.gd setup() (accepted D-373)",
		 "USED UNCHANGED: the same body, cylinder, layer and mask; a click step sweeps it with the engine's own move_and_collide()."],
	]

## What this stage does that no earlier stage did.
static func new_here() -> Array:
	return [
		"A mouse order stores the CLICKED ground point, unsnapped, and asks navigation for nothing.",
		"Every click step is one continuous sweep straight at that point; the first blocker ends the order, with no slide, no reroute and no tunnelling.",
		"A remembered contact stops a held cursor from creeping along a wall by the engine's collision margin.",
		"A compact review HUD and world markers: the clicked point, the straight segment, the first blocking contact, the stop reason and zero player path points.",
	]
