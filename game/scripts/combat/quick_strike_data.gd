class_name QuickStrikeData
extends Resource
## Prototype Zero — Quick Strike tuning record (specification §11.2, §12.1, §12.4).
##
## Every number the Quick Strike kernel obeys lives here, not inside an animation
## length, a particle lifetime, or a visual transform (specification §4.4). The
## locked values are decision D-168 (timing and cost), D-169 (targeting), and
## D-178, which settled that the soft-target cone is 65 degrees TOTAL — 32.5
## either side — and that a candidate already inside `reach` outranks any
## candidate that would need an approach.
##
## The wind-up, release window, and recovery are DERIVED from the total action
## time and the release marker rather than stored separately, because they must
## always add up. The marker is stored in normalised action time, which is also
## normalised time in the retimed local animation copy — see
## `scripts/tools/build_quick_strike_animation.gd`.

@export_group("Identity")
@export var display_name: String = "Quick Strike"
## Prototype Zero is Physical only. There is no damage type system yet.
@export var damage_type: String = "Physical"

@export_group("Timing, seconds")
## Total base action time. 0.80 s is locked by D-168; Quickened Form (Gate E)
## divides it by 1.25 to reach 0.64 s.
@export var action_time: float = 0.80
## Where the release lands, in normalised action time. 0.26 / 0.80 = 0.325.
## This is also the normalised position of the visible contact pose in
## `Quick_Strike_Slice`, which is what makes the marker and the query agree.
@export var release_marker_normalized: float = 0.325
## How long the release state lasts after the marker fires.
@export var release_window: float = 0.06
## Forgiveness for a press that arrives just before the action becomes legal
## again. Deliberately NOT scaled by attack speed: a human's early press does not
## get shorter because the character got faster.
@export var input_buffer: float = 0.12

@export_group("Reach and arc")
## Measured from the actor's centre, planar.
@export var reach: float = 1.65
## Total horizontal arc the release sweeps, centred on facing.
@export var release_arc_degrees: float = 100.0
## Prototype Zero resolves at most one target per use (specification §11.3).
@export var maximum_targets: int = 1
## Approach stops this far inside valid reach, so the next release connects
## rather than landing exactly on the boundary (specification §10).
@export var approach_stop_margin: float = 0.10

@export_group("Cost")
@export var mana_cost: float = 5.0

@export_group("Controller soft targeting")
## D-169 acquisition distance. With 1 unit = 1 m this is 6.25 player diameters.
@export var soft_target_distance: float = 5.0
## TOTAL cone width, in degrees, centred on the intended direction. D-178 settled
## the D-169 ambiguity: "65-degree cone around intended direction" means 65
## degrees TOTAL, so a candidate may sit at most HALF of this — 32.5 degrees —
## either side. Read the half-angle through `soft_target_cone_half_degrees()`
## rather than halving this at the call site, so one place owns the conversion.
## `_MAXIMUM_CONE_HALF_DEGREES` still forbids anything that could read as a
## backwards snap even if this value is edited upward.
@export var soft_target_cone_degrees: float = 65.0
## Candidates whose angles are within this of the best are treated as equally
## well aimed, so the NEARER one wins. This is what stops a barely-better angle
## five metres away from beating the enemy at arm's length.
@export var soft_target_angle_tie_degrees: float = 12.0
## How long an already chosen soft target keeps its place. This is the
## "may preserve the current target BRIEFLY while it remains SENSIBLE" permission
## in specification §11.2, and both halves of that sentence are enforced:
## `soft_target_angle_tie_degrees` decides whether the previous target is still
## sensible, and this decides how long "briefly" lasts. Past the window the
## choice is made freshly even between near-ties, so a stale pick cannot be
## pinned by having been chosen first. Zero disables retention.
##
## It deliberately does NOT hold a target the player has clearly aimed away from:
## once the previous target falls outside the tie band it is released at once.
@export var soft_target_retention: float = 0.35

## An aim assistance that can select behind the player is not assistance. This is
## a HALF-angle guard, so it caps the total cone at 178 degrees.
const _MAXIMUM_CONE_HALF_DEGREES: float = 89.0


func windup_time() -> float:
	return action_time * release_marker_normalized


func recovery_time() -> float:
	return action_time - windup_time() - release_window


## Effective total action time under an increased-attack-speed modifier
## (specification §12.2). Gate C always passes 0.0; Gate E owns the passive that
## changes it. The formula exists here so no later gate has to reopen the kernel.
func effective_action_time(increased_attack_speed: float) -> float:
	return action_time / (1.0 + maxf(increased_attack_speed, -0.95))


func release_arc_half_radians() -> float:
	return deg_to_rad(release_arc_degrees * 0.5)


## Half of the total cone: the largest angle a candidate may sit from the
## intended direction. 65 degrees total is 32.5 degrees either side (D-178).
func soft_target_cone_half_degrees() -> float:
	return minf(soft_target_cone_degrees * 0.5, _MAXIMUM_CONE_HALF_DEGREES)


func soft_target_cone_half_radians() -> float:
	return deg_to_rad(soft_target_cone_half_degrees())


## The total cone actually enforced, after the backwards-snap guard. Debug
## geometry and overlays draw THIS, so the picture cannot disagree with the test.
func soft_target_cone_total_degrees() -> float:
	return soft_target_cone_half_degrees() * 2.0


## Returns "" when the record is coherent, or the first problem found. Called by
## the action on ready so a bad edit fails loudly instead of quietly retuning
## combat (specification §25, "small internal assertions ... and invalid data").
func problem() -> String:
	if action_time <= 0.0:
		return "action_time must be positive"
	if release_marker_normalized <= 0.0 or release_marker_normalized >= 1.0:
		return "release_marker_normalized must sit strictly inside the action"
	if release_window <= 0.0:
		return "release_window must be positive"
	if recovery_time() <= 0.0:
		return "wind-up plus release window exceeds the total action time"
	if reach <= 0.0:
		return "reach must be positive"
	if release_arc_degrees <= 0.0 or release_arc_degrees > 360.0:
		return "release_arc_degrees must be a real arc"
	if maximum_targets != 1:
		return "Prototype Zero resolves exactly one target per use"
	if soft_target_distance <= 0.0:
		return "soft_target_distance must be positive"
	if soft_target_cone_degrees <= 0.0:
		return "soft_target_cone_degrees must be positive"
	if soft_target_cone_degrees > 360.0:
		return "soft_target_cone_degrees is a TOTAL cone width, not a half-angle"
	if approach_stop_margin < 0.0 or approach_stop_margin >= reach:
		return "approach_stop_margin must be a small distance inside reach"
	return ""


func describe() -> String:
	return "%s — %.2f m reach, %.0f deg arc, %.2f / %.2f / %.2f s, %.0f Mana; soft target %.1f m, %.0f deg total (+/-%.1f deg), in-reach first (D-178)" % [
		display_name, reach, release_arc_degrees,
		windup_time(), release_window, recovery_time(), mana_cost,
		soft_target_distance, soft_target_cone_total_degrees(), soft_target_cone_half_degrees(),
	]
