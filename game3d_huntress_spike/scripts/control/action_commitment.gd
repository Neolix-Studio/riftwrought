class_name ActionCommitment
extends RefCounted

## AN ACTION-MOVEMENT COMMITMENT POLICY. Deliberately minimal.
##
## ============================================================================
## THIS IS NOT A SKILL SYSTEM, AND IT MUST NOT BECOME ONE.
## ============================================================================
## The owner's live-review instruction was explicit: *"Implement a minimal,
## reusable action-movement commitment policy without inventing a Skill system"*
## and *"Do not implement speculative additional policies or a full ability
## framework yet."*
##
## So this object knows FOUR things — how long an action lasts, where its release
## marker sits inside that, whether the action suppresses translation, and how
## far through it is. It knows nothing about damage, cost, cooldown, targeting,
## input, animation or class mechanics, and **nothing here defines a Huntress
## Skill.**
##
## ---------------------------------------------------------------------------
## EXACTLY TWO POLICIES. There is no third, and none may be added speculatively.
## ---------------------------------------------------------------------------
##   STOP  — the action suppresses translation for its whole duration.
##   ALLOW — the action does not.
##
## **The ALLOW branch exists because the architecture must PERMIT a future action
## to choose**, and the verification suite exercises it directly so it is not a
## branch that cannot fail. **No action in this foundation uses ALLOW.**
##
## ---------------------------------------------------------------------------
## FACING IS NEVER SUPPRESSED, BY EITHER POLICY.
## ---------------------------------------------------------------------------
## The instruction: *"Allow the player to face the sampled aim direction during
## the action."* A commitment stops the feet, not the head — so there is no
## policy switch for facing and there must not be one.
##
## EVERY TIMING VALUE THAT PASSES THROUGH HERE IS PROVISIONAL.

enum Movement { STOP, ALLOW }

## The two policies, named, so the suite can assert there are exactly two.
const POLICIES := ["STOP", "ALLOW"]

var active: bool = false
var policy: int = Movement.STOP
var label: String = ""
var elapsed: float = 0.0
var duration: float = 0.0
var release_marker: float = 0.0

## Diagnostics the suite and the overlay read.
var commits: int = 0
var completions: int = 0
var recovery_cancels: int = 0
var cancels_refused: int = 0

## Begins a committed action. `p_release_marker` is a fraction of `p_duration`
## — MECHANICAL TIMING, not animation timing.
func begin(p_label: String, p_duration: float, p_release_marker: float,
		p_policy: int = Movement.STOP) -> void:
	active = true
	label = p_label
	duration = maxf(0.0001, p_duration)
	release_marker = clampf(p_release_marker, 0.0, 1.0)
	policy = p_policy
	elapsed = 0.0
	commits += 1

## Advances the action. Returns true on the frame the action ENDS, so the caller
## can act on recovery finishing without polling for a state change.
func advance(delta: float) -> bool:
	if not active:
		return false
	elapsed += delta
	if elapsed >= duration:
		active = false
		completions += 1
		return true
	return false

## Whether translation is suppressed RIGHT NOW.
func suppresses_translation() -> bool:
	return active and policy == Movement.STOP

# ---------------------------------------------------- the cancel window ----
#
# ============================================================================
# THIS IS ANIMATION RECOVERY CANCELLATION. IT IS NOT ATTACK CANCELLATION.
# ============================================================================
# The owner's instruction, at the D-370 live re-review: after the projectile has
# been released, a new movement command may cancel the REMAINING RECOVERY and
# return the character to locomotion -- and "cancelling the remaining animation
# must never cancel, retract or duplicate the already-released projectile."
#
# THE WINDOW IS DERIVED FROM THE EXISTING RELEASE MARKER AND ADDS NO NEW
# TUNABLE. The instruction was to add "only the minimal phase/cancel-window
# behaviour required by the existing release marker", so the window opens exactly
# where the release fires and there is nothing extra to tune or to forget.

## True once the action has passed its release marker.
func cancel_window_open() -> bool:
	return active and elapsed >= duration * release_marker

## Cancels the REMAINING RECOVERY. Returns true only if it actually cancelled.
##
## BEFORE THE RELEASE MARKER THIS REFUSES, and records the refusal. That refusal
## is the whole safety property: an attack must never be cancellable before it
## has done its work, or a movement command during wind-up would eat the shot.
func cancel_recovery() -> bool:
	if not active:
		return false
	if not cancel_window_open():
		cancels_refused += 1
		return false
	active = false
	recovery_cancels += 1
	return true

## Facing is never suppressed, by either policy. Stated as a function rather than
## left implicit so the rule is testable.
func allows_facing() -> bool:
	return true

## The point in the action, for the debug overlay. Purely descriptive: nothing
## branches on it, so it cannot drift away from the timing that matters.
func phase() -> String:
	if not active:
		return "none"
	if elapsed < duration * release_marker:
		return "windup"
	if elapsed < duration * release_marker + 0.0001:
		return "release"
	return "recovery"

func policy_name() -> String:
	return POLICIES[policy] if policy >= 0 and policy < POLICIES.size() else "UNKNOWN"

## A hard reset, for test setup ONLY. GAMEPLAY NEVER CALLS THIS -- gameplay uses
## `cancel_recovery()`, which can refuse. It is named `reset` rather than
## `cancel` so that nothing reads like an escape hatch from the refusal above.
func reset() -> void:
	active = false
	elapsed = 0.0
