class_name GravebladeData
extends Resource
## Prototype Zero — Graveblade tuning record (specification §14.1, decision
## D-181).
##
## Every number the one Gate D enemy obeys lives here, not inside an animation
## length, a navigation agent, or a visual transform (specification §4.4).
##
## As with `QuickStrikeData`, the ACTION TIME is derived from its three parts
## rather than stored separately, so anticipation, release, and recovery cannot
## stop adding up. The release marker is then that anticipation expressed in
## normalised action time — which is also normalised time in the retimed local
## attack clip, which is what makes the visible contact pose and the release
## query the same instant.
##
##     action time    = 0.55 + 0.08 + 0.62 = 1.25 s
##     release marker = 0.55 / 1.25        = 0.44
##
## The XP reward is carried as inert data for later canon compatibility and is
## deliberately NOT awarded: Gate D has no XP, and `gate_d_verification.gd`
## asserts that nothing consumes it.

@export_group("Identity")
@export var display_name: String = "Graveblade"
## Prototype Zero is Physical only. There is no damage-type system yet.
@export var damage_type: String = "Physical"
## Gate F, specification §20.1: Fallen must show the accurate killing source
## `Graveblade — Melee Hit — 125 Physical Damage`. Every field of that line is
## read from this record and the DamageEvent rather than written into the overlay
## as a literal, so a changed number changes the line. This is a PRESENTATION
## string only: no timing, damage, reach, arc, or movement value moved with it.
@export var attack_display_name: String = "Melee Hit"

@export_group("Life and damage")
@export var max_life: float = 300.0
## Four successful Hits defeat the 500-Life player: 500 -> 375 -> 250 -> 125 -> 0.
@export var physical_damage: float = 125.0

@export_group("Movement and awareness, metres")
@export var move_speed: float = 3.4
## Beyond this the Graveblade has not noticed the player.
@export var awareness_distance: float = 10.0
## Where the chase stops. Comfortably inside the reach, so an ordinary commitment
## does not begin exactly on the boundary.
@export var preferred_attack_distance: float = 1.40
## Measured from the actor's centre, planar, exactly as Quick Strike's is.
@export var attack_reach: float = 1.65
## TOTAL horizontal arc the release sweeps, centred on the COMMITTED direction —
## not on the current facing, which is the whole point of committing.
@export var attack_arc_degrees: float = 90.0

@export_group("Attack timing, seconds")
## The readable telegraph. Long on purpose: it is the window the player answers.
@export var anticipation: float = 0.55
@export var release_window: float = 0.08
@export var recovery: float = 0.62
## Specification §14.1: "minimum interval before next commitment". Counted from
## the end of recovery, so consecutive wind-ups can never start closer together
## than `action_time() + this`.
@export var minimum_commitment_interval: float = 0.35
## Fraction of the anticipation spent tracking the player before the release
## direction is LOCKED. The remainder is the visible commitment: the Graveblade
## has chosen where it will strike and can no longer follow the player there,
## which is what makes repositioning produce a genuine miss.
@export_range(0.0, 1.0, 0.01) var commit_at_anticipation_fraction: float = 0.60

@export_group("Spawn")
## A short beat between spawning and noticing anything, so the encounter does not
## begin mid-stride.
@export var spawn_settle: float = 0.30

@export_group("Rewards — inert in Gate D")
## Carried for later canon compatibility (specification §14.1: "XP reward 10").
## Gate D awards NO XP; Gate E owns the XP bar and Quickened Form.
@export var experience_reward: int = 10


func action_time() -> float:
	return anticipation + release_window + recovery


## Where the release lands, in normalised action time — and in normalised time in
## the retimed clip `Graveblade_Attack`.
func release_marker_normalized() -> float:
	return anticipation / action_time()


## When the release direction stops tracking the player, in seconds from the
## start of the wind-up.
func commit_time() -> float:
	return anticipation * commit_at_anticipation_fraction


## How long the committed direction is visibly locked before contact.
func committed_lead_time() -> float:
	return anticipation - commit_time()


func attack_arc_half_radians() -> float:
	return deg_to_rad(attack_arc_degrees * 0.5)


## Hits needed to defeat a full-Life Graveblade with a given per-Hit damage.
## The Gate D starter relationship is `hits_to_defeat(100.0) == 3`.
func hits_to_defeat(per_hit: float) -> int:
	if per_hit <= 0.0:
		return 0
	return int(ceil(max_life / per_hit))


## Returns "" when the record is coherent, or the first problem found. Called by
## the Graveblade on ready so a bad edit fails loudly instead of quietly
## retuning combat (specification §25).
func problem() -> String:
	if max_life <= 0.0:
		return "max_life must be positive"
	if physical_damage <= 0.0:
		return "physical_damage must be positive"
	if move_speed <= 0.0:
		return "move_speed must be positive"
	if awareness_distance <= attack_reach:
		return "awareness_distance must exceed attack_reach or the enemy can never approach"
	if preferred_attack_distance <= 0.0 or preferred_attack_distance > attack_reach:
		return "preferred_attack_distance must be a positive distance inside attack_reach"
	if attack_arc_degrees <= 0.0 or attack_arc_degrees > 360.0:
		return "attack_arc_degrees must be a real arc"
	if anticipation <= 0.0:
		return "anticipation must be positive"
	if release_window <= 0.0:
		return "release_window must be positive"
	if recovery <= 0.0:
		return "recovery must be positive"
	if minimum_commitment_interval < 0.0:
		return "minimum_commitment_interval cannot be negative"
	if commit_at_anticipation_fraction <= 0.0 or commit_at_anticipation_fraction >= 1.0:
		return "the commit point must sit strictly inside the anticipation"
	return ""


func describe() -> String:
	return "%s — %.0f Life, %.0f %s damage, %.1f m/s, aware at %.1f m, holds at %.2f m, %.2f m reach, %.0f deg arc; %.2f / %.2f / %.2f s (%.2f s action, marker %.3f), commits at %.2f s, %.2f s before another" % [
		display_name, max_life, physical_damage, damage_type, move_speed,
		awareness_distance, preferred_attack_distance, attack_reach, attack_arc_degrees,
		anticipation, release_window, recovery, action_time(), release_marker_normalized(),
		commit_time(), minimum_commitment_interval,
	]
