class_name PrototypePlayer
extends CharacterBody3D
## Prototype Zero — player locomotion and action state
## (specification §9.3–§9.5, §10, §12.4).
##
## Owns movement intent, movement, facing, the combined action state, and Mana.
## The Quick Strike kernel itself lives in the `QuickStrikeAction` child, which
## owns attack phase, targeting, the Skill Use ID, and the single release query.
##
## Gate D added Life, damage taken, and mechanical death. Gate E added the one
## thing Gate D said it would: the equipped `PrototypeWeaponData` record that now
## carries the Hit damage, plus the single entry point for increased attack
## speed. Still absent, deliberately rather than stubbed: XP, which lives on the
## authoritative `LabProgress` record rather than on the character, and any
## inventory, equipment slot, rarity, or affix. The finished Fallen overlay,
## Restart flow, and test-state save are Gate F.
##
## Roguelite I13 (D-318) added the one Global Damage total a run's temporary build
## makes live, and the one outgoing-damage query every Hit the player produces is
## evaluated through. The total belongs to the character's current build — never to
## a weapon, a Skill, a projectile, a target or a damage record — and it is held as
## a normalized increase, never as a damage number.
##
## Roguelite I14 (D-320) added the one Maximum-Life total a run's temporary build makes
## live. Like Global Damage it is held as a normalized increase, never as a Life number,
## and it is always applied to the character's own UNMODIFIED maximum. Unlike Global
## Damage it moves a value the character already shows, so its one write entry point
## moves current Life with it, keeping the FRACTION of Life the character had: it never
## heals, damages, kills or revives.
##
## Two movement schemes share one body, one collision shape, one acceleration
## model, and one facing rule, exactly as specification §9.4 requires:
##
##   MOUSE_PATH        left click or hold sends a navigation destination and the
##                     character follows a navigation-mesh path to it.
##   CONTROLLER_DIRECT the left stick sets desired planar velocity directly, with
##                     no path following at all.
##
## There is no WASD scheme and no keyboard fallback for either one.

## Specification §10. These are ACTION states, not animation names. FALLEN
## arrived with Gate D, which owns MECHANICAL death: it overrides every other
## state, and everything it turns off stays off. The Fallen overlay, the trusted
## Restart flow, and the test-state save are still Gate F.
enum ActionState {
	IDLE,
	NAVIGATE,
	APPROACH_TARGET,
	ATTACK_WINDUP,
	ATTACK_RELEASE,
	ATTACK_RECOVERY,
	FALLEN,
}

enum MovementMode {
	NONE,
	MOUSE_PATH,
	CONTROLLER_DIRECT,
}

@export_group("Locomotion, metres")
## Approved under D-175: 5.0 m/s maximum speed. Live-adjustable in the room so a
## later gate can be re-judged, and the reset key returns to this value.
@export var max_speed: float = 5.0
@export var acceleration: float = 30.0
@export var braking: float = 40.0
@export var turn_rate_degrees: float = 720.0
## Specification §10: mouse arrival tolerance.
@export var arrival_tolerance: float = 0.20

@export_group("Controller")
## Radial deadzone. Below this the stick is treated as at rest, so drift can
## neither move the character nor steal the input family.
@export var stick_deadzone: float = 0.20
## 1.0 is linear above the deadzone. Raise for finer control near centre.
@export var stick_response_curve: float = 1.0
## Specification §9.5: a post-start direction change this large is a NEW
## movement intent rather than the same held one.
@export var substantial_turn_degrees: float = 35.0

@export_group("Resources")
## Specification §12.4. Four successful 125-damage Graveblade Hits defeat a
## full-Life player: 500 -> 375 -> 250 -> 125 -> 0.
@export var max_life: float = 500.0
@export var max_mana: float = 100.0
@export var mana_regeneration: float = 10.0

@export_group("Weapon")
## Gate E replaced Gate D's bare number with the record Gate D said it would:
## "Gate E replaces it with the Prototype Training Sword and the 150-damage Honed
## Sword record." The character starts with the Training Sword; equipping the
## Honed Sword swaps this reference and nothing else.
##
## It stays OUT of the D-180-locked `quick_strike.tres` because it is the
## WEAPON's number, not the Skill's — which is exactly what lets that record keep
## asserting the values the project owner accepted while the damage changes.
##
## There is no inventory, no equipment slot, and no second hand: Prototype Zero
## has one equipped record at a time and swapping it is the whole of "equip".
@export var weapon: PrototypeWeaponData

## The equipped weapon's RAW Physical base. Backed by the equipped record so there
## is exactly ONE source of truth — 100 with the Training Sword, 150 with the Honed
## Sword — and against a 300-Life Graveblade that is the locked three-Hit
## relationship becoming the locked two-Hit one. It is never a globally modified
## number: a released Quick Strike deals `outgoing_hit_damage()` of this base, which
## is exactly this base while the build holds no Global Damage (Roguelite I13, D-318).
var physical_damage: float:
	get:
		return weapon.physical_damage if weapon != null else 0.0

@export_group("Presentation")
@export var rig_path: NodePath = ^"VisualRoot/KnightRig"
## Local editable copy of the attack clip, retimed so its visible contact sits at
## the release marker. Built by scripts/tools/build_quick_strike_animation.gd.
@export var quick_strike_library: AnimationLibrary
@export var quick_strike_library_name: StringName = &"prototype"
## Speed at which the run cycle plays at its authored rate. Tracks the approved
## D-175 maximum speed so a full-speed run plays the clip at 1.0.
@export var run_cycle_reference_speed: float = 5.0
@export var run_animation_threshold: float = 0.20
@export var idle_animation_threshold: float = 0.10

const IDLE_CLIP: StringName = &"Idle_A"
const RUN_CLIP: StringName = &"Running_A"
const QUICK_STRIKE_CLIP: StringName = &"Quick_Strike_Slice"
const DEATH_CLIP: StringName = &"Death_A"

var action_state: ActionState = ActionState.IDLE
var life: float = 500.0
var mana: float = 100.0
var attack: QuickStrikeAction
var movement_mode: MovementMode = MovementMode.NONE

## Set while an interruption (focus loss, controller disconnect) requires every
## movement control to return to neutral before it is obeyed again.
var awaiting_neutral: bool = false
var neutral_reason: String = ""

var destination: Vector3 = Vector3.ZERO
var has_destination: bool = false
var last_requested_point: Vector3 = Vector3.ZERO
var last_destination_was_adjusted: bool = false

## The ONE shared locomotion kernel (D-195). The §9.5 stick state machine, the
## acceleration model, the braked path arrival, and the measured +Z facing rule
## live in `scripts/movement/prototype_locomotion.gd` so the Gate 1A calibration
## hall reuses this exact behaviour instead of carrying a second copy of it.
## Every public name below is unchanged; only the bodies moved.
var _locomotion: PrototypeLocomotion = PrototypeLocomotion.new()

var stick_raw: Vector2:
	get:
		return _locomotion.raw
	set(value):
		_locomotion.raw = value
var stick_magnitude: float:
	get:
		return _locomotion.magnitude
	set(value):
		_locomotion.magnitude = value

# --- Instrumentation (specification §22) -------------------------------------
var damage_taken_events: int = 0
var last_damage_taken: DamageEvent = null
var fallen_at_msec: int = 0

var _agent: NavigationAgent3D
var _visual_root: Node3D
var _rig: MediumRigVisual
var _current_clip: StringName = &""
var _facing_yaw: float:
	get:
		return _locomotion.facing_yaw
	set(value):
		_locomotion.facing_yaw = value
## Set while an attack has suspended a movement control that is merely still
## held. Cleared at release, so the held intent may resume and end recovery.
var _movement_suspended_by_attack: bool = false
var _quick_strike_clip: StringName = &""
## Guards against one attacker's single use landing twice, whatever the caller
## does. Keyed by source instance id -> last accepted use id.
var _accepted_use_ids: Dictionary = {}

## Roguelite I13 (D-318): the run's temporary build's whole increased Global Damage,
## NORMALIZED — 0.10 is +10% — and never a final damage number. 0.0 until a build says
## otherwise, and an empty build writes it back to 0.0. Written only through
## `set_increased_global_damage()`.
var _increased_global_damage: float = 0.0

## Roguelite I14 (D-320): the run's temporary build's whole increased Maximum Life,
## NORMALIZED — 0.15 is +15% — and never a Life number. 0.0 until a build says
## otherwise, and an empty build writes it back to 0.0. Written only through
## `set_increased_maximum_life()`.
var _increased_maximum_life: float = 0.0

## The configured, UNMODIFIED Maximum Life every total is applied to. While no total is
## held, `max_life` itself is that baseline; it is captured from `max_life` when a total
## is written — before the write moves `max_life` — and a later total is applied to it,
## never to a `max_life` a total has already moved, which is what would compound. Read
## through `maximum_life_baseline()`.
var _maximum_life_baseline: float = 0.0

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)

signal life_changed(current: float, maximum: float)
signal took_damage(event: DamageEvent)
signal fell(event: DamageEvent)
signal mana_changed(current: float, maximum: float)
signal weapon_changed(record: PrototypeWeaponData)
signal attack_speed_changed(increased: float, effective_action_time: float)
signal movement_command_resolved(status: String, requested: Vector3, resolved: Vector3)
signal arrived_at_destination(point: Vector3)
signal movement_intent_cleared(reason: String)
signal movement_mode_changed(mode: MovementMode)


func _ready() -> void:
	_agent = $NavigationAgent3D
	_visual_root = $VisualRoot
	_rig = get_node(rig_path) as MediumRigVisual
	attack = $QuickStrikeAction
	_facing_yaw = _visual_root.rotation.y
	life = max_life
	mana = max_mana
	var weapon_problem: String = "no weapon record is equipped" if weapon == null else weapon.problem()
	assert(weapon_problem.is_empty(), "PrototypePlayer: %s" % weapon_problem)
	_agent.path_desired_distance = 0.40
	_agent.target_desired_distance = arrival_tolerance
	_agent.radius = 0.40
	_agent.avoidance_enabled = false
	_locomotion.configure(stick_deadzone, stick_response_curve, substantial_turn_degrees)
	_register_quick_strike_clip()


## The retimed clip is added at runtime from the player scene rather than being
## written into the Gate A rig scenes, so `knight_rig.tscn`, `graveblade_rig.tscn`
## and the preserved Gate A spike stay byte-for-byte unchanged.
func _register_quick_strike_clip() -> void:
	if _rig == null or quick_strike_library == null:
		return
	var player: AnimationPlayer = _rig.animation_player
	if not player.has_animation_library(quick_strike_library_name):
		player.add_animation_library(quick_strike_library_name, quick_strike_library)
	_quick_strike_clip = StringName("%s/%s" % [quick_strike_library_name, QUICK_STRIKE_CLIP])
	assert(player.has_animation(_quick_strike_clip),
		"PrototypePlayer: retimed clip '%s' is missing; rebuild it with build_quick_strike_animation.gd" % _quick_strike_clip)


## The room hands the camera's ground basis down so stick directions are read in
## screen space, not world space.
func set_ground_basis(forward: Vector3, right: Vector3) -> void:
	_locomotion.set_ground_basis(forward, right)


# --- Intent ------------------------------------------------------------------

## Sends a navigation destination. `point` is already resolved to the navigation
## mesh by the room, which owns the unreachable-point rule.
## `adjusted` records that the clicked point was not itself walkable.
func command_move_to(point: Vector3, requested: Vector3, adjusted: bool) -> void:
	if not is_alive():
		movement_command_resolved.emit("rejected: fallen", requested, point)
		return
	if awaiting_neutral:
		movement_command_resolved.emit("rejected: awaiting neutral input", requested, point)
		return
	last_requested_point = requested
	last_destination_was_adjusted = adjusted
	destination = point
	has_destination = true
	_agent.target_position = point
	_set_mode(MovementMode.MOUSE_PATH)
	# Specification §10: the newest meaningful movement command outranks an old
	# target or an old attack repeat.
	if attack != null and attack.busy():
		attack.cancel_for_movement("new click-to-move command")
	action_state = ActionState.NAVIGATE
	# Specification §9.5: a fresh mouse command outranks a stick that is merely
	# still held. That stick only commands again once it is released, re-crosses
	# the deadzone, or turns substantially.
	_locomotion.supersede_hold()
	movement_command_resolved.emit("adjusted" if adjusted else "accepted", requested, point)


## Raw left-stick reading, fed once per physics frame by the room.
func set_stick_raw(raw: Vector2) -> void:
	# The deadzone is written at runtime by the §21 settings panel, so the kernel
	# is handed the live tuning rather than caching its own copy of it.
	_locomotion.configure(stick_deadzone, stick_response_curve, substantial_turn_degrees)
	_locomotion.set_stick_raw(raw)


## Clears every held movement intent and requires neutral controls before any
## new one is obeyed (specification §9.2).
##
## It clears CONTROLS, never life: a FALLEN character stays FALLEN (First-MVP UI
## J2, decision D-324). Every modal neutralizes through here as it opens, the
## Fallen overlay among them, and the unconditional return to IDLE this used to
## write made `is_alive()` answer true behind that overlay at zero Life (D-315).
## Movement, the attack, targeting, locomotion and velocity are still cleared for
## a fallen character exactly as for a living one; only the return to IDLE is
## withheld. Only `revive_for_testing()` brings a character back.
func clear_movement_intent(reason: String, require_neutral: bool = true) -> void:
	if attack != null:
		attack.clear(reason)
	_movement_suspended_by_attack = false
	has_destination = false
	_agent.target_position = global_position
	_locomotion.reset()
	velocity = Vector3.ZERO
	if action_state != ActionState.FALLEN:
		action_state = ActionState.IDLE
	_set_mode(MovementMode.NONE)
	if require_neutral:
		awaiting_neutral = true
		neutral_reason = reason
	movement_intent_cleared.emit(reason)


## Called by the room once every physical movement control reads neutral.
func release_neutral_latch() -> void:
	if awaiting_neutral:
		awaiting_neutral = false
		neutral_reason = ""


func stick_is_commanding() -> bool:
	return is_alive() and _locomotion.is_commanding() and not awaiting_neutral


## Specification §9.5: pressing Quick Strike while a movement control is already
## held makes the attack the newest intent. The older movement intent is
## SUSPENDED, not cancelled, so the action does not die on the next frame merely
## because the physical control is still down.
func suspend_held_movement_for_attack() -> void:
	_movement_suspended_by_attack = _locomotion.suspend_hold()
	if has_destination:
		has_destination = false
		_movement_suspended_by_attack = true
		movement_intent_cleared.emit("suspended by Quick Strike")


## Specification §9.5: "After release, an already held movement intent may resume
## immediately and cancel remaining recovery."
func revive_held_movement() -> void:
	if not _movement_suspended_by_attack:
		return
	_movement_suspended_by_attack = false
	if _locomotion.magnitude > 0.0:
		_locomotion.stale = false


func movement_is_suspended_by_attack() -> bool:
	return _movement_suspended_by_attack


# --- Life, damage, and mechanical death (specification §12.3, §14.1, §20.1) --

func is_alive() -> bool:
	return action_state != ActionState.FALLEN


## The player's half of the Hit contract, and the mirror of the Graveblade's.
## Life changes exactly once per DamageEvent, the Hit is emitted, and only then —
## from inside the same call — the fall, so ordering is a property of the code
## rather than of two listeners racing.
func receive_damage(event: DamageEvent) -> void:
	if not is_alive():
		return
	var source_key: int = event.source.get_instance_id() if event.source != null else 0
	if _accepted_use_ids.get(source_key, -1) == event.use_id:
		return
	_accepted_use_ids[source_key] = event.use_id

	damage_taken_events += 1
	last_damage_taken = event
	life = maxf(life - event.final_life_damage, 0.0)
	life_changed.emit(life, max_life)
	took_damage.emit(event)
	if life <= 0.0:
		_fall(event)


## Specification §20.1: "cancel movement, navigation, attack, target, buffered
## input, and enemy attack permissions; remove player damage eligibility
## immediately". Gate D owns all of that. The overlay, the Restart flow, and the
## neutral-input handshake around them are Gate F; the room revokes the enemy's
## permission when it hears `fell`.
func _fall(event: DamageEvent) -> void:
	fallen_at_msec = Time.get_ticks_msec()
	if attack != null:
		attack.clear("player fallen")
	has_destination = false
	_agent.target_position = global_position
	_locomotion.reset()
	_movement_suspended_by_attack = false
	velocity = Vector3.ZERO
	_set_mode(MovementMode.NONE)
	action_state = ActionState.FALLEN
	# Nothing may be obeyed again until every control returns to neutral.
	awaiting_neutral = true
	neutral_reason = "fallen"
	movement_intent_cleared.emit("fallen")
	if _rig != null:
		_current_clip = DEATH_CLIP
		_rig.play(DEATH_CLIP, 1.0, 0.10)
		_rig.animation_player.speed_scale = 1.0
	fell.emit(event)


## Debug only. Gate D owns mechanical death; Gate F owns the trusted Restart.
func revive_for_testing() -> void:
	life = max_life
	mana = max_mana
	_accepted_use_ids.clear()
	damage_taken_events = 0
	last_damage_taken = null
	fallen_at_msec = 0
	action_state = ActionState.IDLE
	awaiting_neutral = true
	neutral_reason = "encounter reset"
	velocity = Vector3.ZERO
	if _rig != null:
		_current_clip = IDLE_CLIP
		_rig.play(IDLE_CLIP, 1.0, 0.0)
		_rig.animation_player.speed_scale = 1.0
	life_changed.emit(life, max_life)
	mana_changed.emit(mana, max_mana)


# --- Gate E: the equipped weapon and the one attack-speed modifier -----------

## Equipping replaces the deterministic prototype weapon DIRECTLY. There is no
## inventory, no pickup capacity, no equipment slot, and nothing is destroyed:
## the previous record simply stops being the equipped one.
##
## Idempotence lives in `LabProgress`, not here — this is the mechanical half and
## re-equipping the same record is a no-op by construction.
func equip_weapon(record: PrototypeWeaponData) -> void:
	var problem: String = "a null weapon record" if record == null else record.problem()
	assert(problem.is_empty(), "PrototypePlayer.equip_weapon: %s" % problem)
	if record == weapon:
		return
	var previous: String = weapon.display_name if weapon != null else "nothing"
	weapon = record
	weapon_changed.emit(record)
	_emit_weapon_log(previous)


## The single entry point for increased attack speed (specification §12.2). It
## writes the kernel's own `increased_attack_speed`, which every phase, the
## animation rate, the repeat cadence, and the cancel windows are already derived
## from — so 0.80 s becomes 0.64 s with nothing left locked after the visual, and
## the release stays on its animation-aligned marker at either speed.
##
## Gate C proved that relationship at exactly 25% before any passive existed;
## Quickened Form does not add a second mechanism, it supplies the number.
func set_increased_attack_speed(value: float) -> void:
	if attack == null:
		return
	if is_equal_approx(attack.increased_attack_speed, value):
		return
	attack.increased_attack_speed = value
	attack_speed_changed.emit(value, attack.effective_action_time())


func increased_attack_speed() -> float:
	return attack.increased_attack_speed if attack != null else 0.0


# --- Roguelite I13: the one Global Damage total and the outgoing Hit (D-318) --

## The single write entry point, used by the run-build application seam alone. It
## is handed the build's already-summed total — adding percentages is the build's
## job — so a second call replaces the first rather than stacking on it.
##
## It refuses, returning the reason and changing nothing, any total the stat
## vocabulary's own calculation path would refuse. The total is checked against a
## zero base, so a refusal can only ever be about the total itself.
func set_increased_global_damage(total_increased: float) -> String:
	var check: PlayerStatValue = PlayerStats.apply(PlayerStats.GLOBAL_DAMAGE, 0.0, total_increased)
	if not check.ok:
		return check.failure_reason
	_increased_global_damage = total_increased
	return ""


func increased_global_damage() -> float:
	return _increased_global_damage


## THE ONE OUTGOING-DAMAGE QUERY. Every Hit the player produces asks it at the moment
## the Hit's damage is committed — Quick Strike's release, a Foundation Skill's area
## release or projectile launch — with that Hit's own base: the weapon's raw damage, a
## weapon-derived Skill's scaled share of it, or a Spell's own damage. The answer is the
## vocabulary's own derivation of that base at the held total, returned WHOLE: a caller
## that cannot use a refused answer must not deal a guessed number, so there is no
## fallback to zero, to the base or to a clamp. Nothing here writes a weapon, a Skill
## record or a damage record, and nothing is cached: a new weapon's base is evaluated
## the next time it is asked.
func outgoing_hit_damage(base_damage: float) -> PlayerStatValue:
	return PlayerStats.apply(PlayerStats.GLOBAL_DAMAGE, base_damage, _increased_global_damage)


# --- Roguelite I14: the one Maximum-Life total and the Life it carries (D-320) --

## The single write entry point, used by the run-build application seam alone. It is
## handed the build's already-summed total, so a second call REPLACES the first rather
## than stacking on it: the new maximum is always the vocabulary's own derivation of the
## unmodified baseline at the whole total.
##
## Current Life keeps the fraction of the maximum it held, by `preserved_life()`, so this
## never heals, damages, kills or revives: a character at zero Life stays at zero and
## keeps its action state, and a full one stays full. It refuses, returning the reason
## and changing nothing, a total the vocabulary refuses and any Life state
## `life_transition_problem()` refuses. Nothing is clamped into validity.
##
## `life_changed` is emitted exactly once when Life or its maximum actually moves, and
## not at all when neither does: writing the same total again heals nothing and says
## nothing.
func set_increased_maximum_life(total_increased: float) -> String:
	var baseline: float = maximum_life_baseline()
	var maximum: PlayerStatValue = PlayerStats.apply(PlayerStats.MAXIMUM_LIFE, baseline, total_increased)
	if not maximum.ok:
		return maximum.failure_reason
	var problem: String = life_transition_problem(life, max_life, maximum.value)
	if not problem.is_empty():
		return problem
	var next_life: float = preserved_life(life, max_life, maximum.value)
	var moved: bool = maximum.value != max_life or next_life != life
	_maximum_life_baseline = baseline
	_increased_maximum_life = total_increased
	if not moved:
		return ""
	max_life = maximum.value
	life = next_life
	life_changed.emit(life, max_life)
	return ""


func increased_maximum_life() -> float:
	return _increased_maximum_life


## The unmodified Maximum Life a total is applied to: `max_life` itself while no total is
## held, and the value captured from it before a total first moved it otherwise.
func maximum_life_baseline() -> float:
	return max_life if _increased_maximum_life == 0.0 else _maximum_life_baseline


## THE ONE LIFE-PRESERVATION RULE. The Life a character at `current` of `maximum_before`
## holds once its maximum becomes `maximum_after`: the same FRACTION of the new maximum.
## When the maximum does not move, neither does Life — exactly, because multiplying back
## by the same maximum could move it by a rounding step, which would be a heal nobody
## chose. Pure: it reads no field and writes nothing, so the run-build application's
## result re-derives its answer through this very function.
static func preserved_life(current: float, maximum_before: float, maximum_after: float) -> float:
	if maximum_after == maximum_before:
		return current
	return maximum_after * (current / maximum_before)


## "" when Life may move from `current` of `maximum_before` to a maximum of
## `maximum_after` under `preserved_life()`, or the first reason it may not: a current
## maximum that is not positive and finite, a current Life that is not finite or lies
## outside zero to that maximum, a new maximum that is not positive and finite, and a
## living character the rule would leave with no Life. Pure, and refusing rather than
## clamping: an incoherent state is reported, never repaired.
static func life_transition_problem(current: float, maximum_before: float, maximum_after: float) -> String:
	if not is_finite(maximum_before) or maximum_before <= 0.0:
		return "the current Maximum Life %s is not a positive finite number" % String.num_scientific(maximum_before)
	if not is_finite(current) or current < 0.0 or current > maximum_before:
		return "the current Life %s is not a finite number from 0 to the current Maximum Life %s" % [
			String.num_scientific(current), String.num_scientific(maximum_before)]
	if not is_finite(maximum_after) or maximum_after <= 0.0:
		return "the new Maximum Life %s is not a positive finite number" % String.num_scientific(maximum_after)
	if current > 0.0 and preserved_life(current, maximum_before, maximum_after) <= 0.0:
		return "a living character at %s of %s would keep no Life at a Maximum Life of %s" % [
			String.num_scientific(current), String.num_scientific(maximum_before), String.num_scientific(maximum_after)]
	return ""


func _emit_weapon_log(previous: String) -> void:
	if not is_node_ready():
		return
	print("[gate-e] %-28s %s -> %s (%.0f %s per Quick Strike)" % [
		"weapon equipped", previous, weapon.display_name,
		weapon.physical_damage, weapon.damage_type,
	])


# --- Resources (specification §12.4) -----------------------------------------

func has_mana_for(cost: float) -> bool:
	return mana + 0.0001 >= cost


## Returns what was actually spent, so the caller can record it.
func spend_mana(cost: float) -> float:
	var spent: float = minf(cost, mana)
	mana = maxf(mana - cost, 0.0)
	mana_changed.emit(mana, max_mana)
	return spent


func regenerate_mana(delta: float) -> void:
	if mana >= max_mana:
		return
	mana = minf(mana + mana_regeneration * delta, max_mana)
	mana_changed.emit(mana, max_mana)


func facing_direction() -> Vector3:
	return Vector3(sin(_facing_yaw), 0.0, cos(_facing_yaw))


# --- Movement ----------------------------------------------------------------

func _physics_process(delta: float) -> void:
	# Specification §10: "death overrides every state and enters FALLEN
	# immediately". Nothing below this line runs again until a reset.
	if not is_alive():
		velocity = Vector3.ZERO
		if not is_on_floor():
			velocity.y -= _gravity * delta
			move_and_slide()
		return
	regenerate_mana(delta)
	if attack != null:
		attack.tick(delta)

	var desired: Vector3 = Vector3.ZERO

	# Specification §9.5 and §10. A click is an event and cancels through
	# `command_move_to`; a stick is a continuous state, so the same rule has to be
	# applied here. A stick suspended at the start of the attack is stale and
	# does NOT command, so it cannot cancel; it revives at release, which is
	# exactly what lets a held direction end the recovery and move on.
	if attack != null and attack.busy() and stick_is_commanding():
		attack.cancel_for_movement("controller stick")

	if attack != null and attack.is_attacking():
		# Specification §5 / §10: an ordinary attack briefly stops movement. The
		# body brakes rather than freezing, so a run does not stop dead.
		_set_mode(MovementMode.NONE)
		action_state = _attack_action_state()
	elif attack != null and attack.is_approaching():
		_set_mode(MovementMode.MOUSE_PATH)
		action_state = ActionState.APPROACH_TARGET
		desired = _approach_velocity()
	elif stick_is_commanding():
		if has_destination:
			# A live stick is the newest movement intent and outranks the older
			# navigation destination.
			has_destination = false
			movement_intent_cleared.emit("superseded by controller stick")
		_set_mode(MovementMode.CONTROLLER_DIRECT)
		action_state = ActionState.NAVIGATE
		desired = _locomotion.stick_velocity(max_speed)
	elif has_destination:
		_set_mode(MovementMode.MOUSE_PATH)
		action_state = ActionState.NAVIGATE
		desired = _path_velocity()
	else:
		if action_state != ActionState.IDLE:
			action_state = ActionState.IDLE
		if movement_mode != MovementMode.NONE and _planar_speed() < 0.01:
			_set_mode(MovementMode.NONE)

	_apply_planar_velocity(desired, delta)

	if is_on_floor():
		velocity.y = 0.0
	else:
		velocity.y -= _gravity * delta

	move_and_slide()
	_update_facing(delta)
	_update_animation()


func _attack_action_state() -> ActionState:
	match attack.phase:
		QuickStrikeAction.Phase.WINDUP:
			return ActionState.ATTACK_WINDUP
		QuickStrikeAction.Phase.RELEASE:
			return ActionState.ATTACK_RELEASE
		_:
			return ActionState.ATTACK_RECOVERY


## Automatic approach follows the navigation mesh, in both control schemes, so
## the walk routes around geometry instead of grinding along it. It is movement
## the SKILL asked for, not the player steering, which is why the controller uses
## it here and nowhere else (specification §11.1, §11.2).
func _approach_velocity() -> Vector3:
	var goal: Vector3 = attack.target.global_position
	if _agent.target_position.distance_to(goal) > 0.25:
		_agent.target_position = goal
	var step: Vector3 = _planar(_agent.get_next_path_position() - global_position)
	if step.length() < 0.0001:
		step = _planar(goal - global_position)
	if step.length() < 0.0001:
		return Vector3.ZERO
	return step.normalized() * max_speed


func _path_velocity() -> Vector3:
	var step: Dictionary = PrototypeLocomotion.path_velocity(
		_agent, global_position, destination, max_speed, braking, arrival_tolerance
	)
	if bool(step["arrived"]):
		_arrive()
		return Vector3.ZERO
	return step["velocity"]


## Length of the path still to walk, so braking respects a detour instead of the
## straight-line distance through a wall.
func remaining_path_length() -> float:
	return PrototypeLocomotion.remaining_path_length(_agent, global_position, destination)


func _arrive() -> void:
	if not has_destination:
		return
	has_destination = false
	action_state = ActionState.IDLE
	arrived_at_destination.emit(destination)


func _apply_planar_velocity(desired: Vector3, delta: float) -> void:
	velocity = PrototypeLocomotion.advance_planar_velocity(
		velocity, desired, acceleration, braking, delta
	)


## Verification seam, matching the Gate B `set_stick_override`. It exists so the
## arc and cone checks can start from an exact known facing instead of relying on
## a turn completing inside the wind-up. Ordinary play never calls it.
func face_instantly(direction: Vector3) -> void:
	if not _locomotion.face_instantly(direction):
		return
	_visual_root.rotation.y = _facing_yaw


func _update_facing(delta: float) -> void:
	# Specification §10: the turn rate applies "outside locked release pose". The
	# swing tracks a target through the wind-up and then commits, so the facing
	# used by the release query is the facing the player can see.
	if attack != null and attack.busy():
		if attack.facing_is_locked():
			_visual_root.rotation.y = _facing_yaw
			return
		var aim: Vector3 = attack.aim
		if attack.target != null:
			aim = _planar(attack.target.global_position - global_position)
		if aim.length() > 0.0001:
			_turn_toward(aim.normalized(), delta)
			return

	var planar: Vector3 = _planar(velocity)
	if planar.length() < 0.15:
		_visual_root.rotation.y = _facing_yaw
		return
	var direction: Vector3 = planar.normalized()
	_turn_toward(direction, delta)


func _turn_toward(direction: Vector3, delta: float) -> void:
	# The kernel carries the MEASURED +Z facing rule; see prototype_locomotion.gd.
	_visual_root.rotation.y = _locomotion.turn_toward(direction, turn_rate_degrees, delta)


func _update_animation() -> void:
	if _rig == null or not is_alive():
		return
	var wanted: StringName = _current_clip
	var scale: float = 1.0
	var blend: float = 0.15

	if attack != null and attack.is_attacking() and _quick_strike_clip != &"":
		# The retimed clip is exactly 1.000 s long and its visible contact sits at
		# `release_marker_normalized`, so clip position IS normalised action time.
		# The action drives that position directly rather than letting the clip
		# free-run at a matched rate: at the release marker the swing is sweeping
		# about 2,600 deg/s, where even a single 60 Hz frame of drift would be
		# 43 degrees of blade. Driving it makes the visible contact pose and the
		# release query the same instant at ANY attack speed, and it also means
		# nothing can stay mechanically locked after the visual ends.
		wanted = _quick_strike_clip
		scale = 0.0
		blend = 0.0
	else:
		var speed: float = _planar_speed()
		if speed >= run_animation_threshold:
			wanted = RUN_CLIP
		elif speed <= idle_animation_threshold:
			wanted = IDLE_CLIP
		if wanted == &"" or wanted == _quick_strike_clip:
			wanted = RUN_CLIP if speed >= run_animation_threshold else IDLE_CLIP
		if wanted == RUN_CLIP:
			scale = clampf(speed / maxf(run_cycle_reference_speed, 0.01), 0.45, 1.60)
		blend = 0.10

	if wanted != _current_clip:
		_current_clip = wanted
		# `custom_speed` is passed as 1.0 and the rate is carried ONLY by
		# `speed_scale`. Passing it in both places multiplied them together, so
		# the Gate B run cycle played at rate squared below full speed.
		_rig.play(wanted, 1.0, blend)
	_rig.animation_player.speed_scale = scale
	if wanted == _quick_strike_clip:
		sync_attack_pose(attack.action_normalized_time())


## Places the rig at an exact normalised position in the attack clip. The release
## marker uses this immediately before its query, so the pose the query is
## resolved against is the pose on screen.
func sync_attack_pose(normalized: float) -> void:
	if _rig == null or _quick_strike_clip == &"":
		return
	var player: AnimationPlayer = _rig.animation_player
	if player.current_animation != String(_quick_strike_clip):
		player.play(_quick_strike_clip, 0.0, 1.0)
		player.speed_scale = 0.0
		_current_clip = _quick_strike_clip
	var length: float = player.get_animation(_quick_strike_clip).length
	player.seek(clampf(normalized, 0.0, 1.0) * length, true)


## Where the attack animation actually is, as a fraction of the clip. Used by the
## Gate C verification to prove the visible contact pose and the release query
## agree instead of assuming they do.
func quick_strike_animation_position() -> float:
	if _rig == null or _current_clip != _quick_strike_clip or _quick_strike_clip == &"":
		return -1.0
	var length: float = _rig.animation_player.get_animation(_quick_strike_clip).length
	return _rig.animation_player.current_animation_position / maxf(length, 0.0001)


# --- Small helpers -----------------------------------------------------------

func _planar(v: Vector3) -> Vector3:
	return PrototypeLocomotion.planar(v)


func _planar_speed() -> float:
	return _planar(velocity).length()


func planar_speed() -> float:
	return _planar_speed()


func _set_mode(mode: MovementMode) -> void:
	if mode == movement_mode:
		return
	movement_mode = mode
	movement_mode_changed.emit(mode)


func action_state_name() -> String:
	match action_state:
		ActionState.IDLE:
			return "IDLE"
		ActionState.NAVIGATE:
			return "NAVIGATE"
		ActionState.APPROACH_TARGET:
			return "APPROACH_TARGET"
		ActionState.ATTACK_WINDUP:
			return "ATTACK_WINDUP"
		ActionState.ATTACK_RELEASE:
			return "ATTACK_RELEASE"
		ActionState.ATTACK_RECOVERY:
			return "ATTACK_RECOVERY"
		_:
			return "FALLEN"


func movement_mode_name() -> String:
	match movement_mode:
		MovementMode.MOUSE_PATH:
			return "mouse path"
		MovementMode.CONTROLLER_DIRECT:
			return "controller direct"
		_:
			return "none"


func navigation_status() -> String:
	if not has_destination:
		return "no destination"
	if _agent.is_target_reachable():
		return "reachable, %.2f m of path left" % remaining_path_length()
	return "target unreachable"


func stick_is_stale() -> bool:
	return _locomotion.stale


func current_path() -> PackedVector3Array:
	if not has_destination:
		return PackedVector3Array()
	return _agent.get_current_navigation_path()
