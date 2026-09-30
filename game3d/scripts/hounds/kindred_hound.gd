class_name KindredHound
extends CharacterBody3D

## ONE KINDRED HOUND — an autonomous minion, and NOTHING the player drives.
##
## ============================================================================
## THERE IS NO COMMAND PATH INTO THIS CLASS. THAT IS THE REQUIREMENT.
## ============================================================================
## Canon (D-385 HD-06): "Beasts act autonomously. No routine commands, feeding,
## care loop or ability rotation." So this class exposes NO method that takes a
## target, a destination or an order, and its `target` is CHOSEN in ONE place:
## its own `think()`, through `HoundTargeting.decide()`. Falling and returning
## only CLEAR it (to {}), never set it. The only external mutators are
## `receive_damage()` -- the path any damage takes, enemy or diagnostic -- and
## `revive_at()`, the runtime's low-friction recovery.
##
## ---------------------------------------------------------------------------
## A HOUND DOES NOT OBSTRUCT HER, THE ENEMIES OR NAVIGATION.
## ---------------------------------------------------------------------------
## Structural, not behavioural: it sits on `HoundConfig.COLLISION_LAYER`, which
## NOTHING masks, and it masks the world only -- so walls stop it and it stops
## nobody. It carries no NavigationAgent3D and no obstacle; the navigation mesh
## was baked once, from the arena's static colliders, before any hound existed.
##
## ---------------------------------------------------------------------------
## MECHANICS HERE; PRESENTATION IN `HoundStandIn`, ON THE RENDER FRAME.
## ---------------------------------------------------------------------------
## `step()` decides, moves and bites. Nothing in it touches a mesh, a material or
## an animation -- the stand-in reads this node's state in `_process`.
##
## EVERY NUMBER IT USES IS PROVISIONAL (`HoundConfig.registry()`).
##
## ============================================================================
## D-398: IT MOVES THROUGH THE SHARED MOBILE-MINION COHORT. IT STILL CHOOSES.
## ============================================================================
## The owner's D-398 ruling: "Build a shared cohort system with Kindred Hounds as
## its only production consumer." So WHERE a hound stands and HOW FAST it moves
## come from `MobileCohort` -- a stable Vanguard formation slot by its
## combat-entity ID, round a predictive anchor ahead of her; pace and catch-up;
## pass-through when crowded, returning or catching up; a harmless soft recovery;
## a stable target-relative attack position. WHOM it fights is still ITS OWN
## choice, by the accepted rule in `think()` (D-394 ruling 3) -- the cohort owns
## no targeting rule, and `HoundTargeting` is unchanged.
##
## The D-396 trailing slot ("1.7 m behind her at +/-55 degrees") is GONE; its
## public face `follow_slot()` now answers the formation slot. "When the player
## exceeds the leash, regrouping overrides combat": a hound farther than the
## accepted leash from her REGROUPS -- it drops its target and acquires nothing
## until it is back inside the accepted acquisition range (the stage's READING,
## `CohortConfig.REGROUP_READING`, disclosed for the owner). A hound still inside
## the leash keeps D-396's behaviour exactly.

enum State { FOLLOW, ENGAGE, BITE, FALLEN, REGROUP, RECOVER }
const BEHAVIOUR_NAMES := ["FOLLOW", "ENGAGE", "BITE", "FALLEN", "REGROUP", "RECOVER"]
## D-398: the abandonment code when regrouping overrides combat on a target that
## the accepted rule would still have retained.
const ABANDONED_REGROUP := "ABANDONED — REGROUPING (she is beyond the leash)"
## D-398: the cohort role this minion plays -- the ONE role that exists.
const COHORT_ROLE := FormationProfile.Role.MELEE

## Pack index: 0 is H1, 1 is H2. Fixed at summon. Never a node name. Since D-398
## it no longer decides a follow side: the combat-entity ID decides the slot.
var index: int = 0
var handler: Node3D = null
var registry: CombatEntityRegistry = null
var origin_configuration: String = ""
var bite_damage: float = HoundConfig.BITE_DAMAGE_AT_RANK_1
var life := Damageable.new(HoundConfig.LIFE)

## D-398 -- THE COHORT MEMBER CONTRACT (`MobileCohort`). The cohort reads these;
## it writes none of them.
var combat_id: String = ""
var cohort: MobileCohort = null
var cohort_role: int = COHORT_ROLE
var cohort_mode: int = MobileCohort.Mode.FORMATION
## Its own accepted D-396 body and movement values, handed to the cohort.
var cohort_params: Dictionary = {}
## D-398: a DIAGNOSTIC STRESS MINION -- the same actor, labelled, biting into its
## own diagnostic ledger source. False for the two Kindred Hounds.
var diagnostic_stress: bool = false
var ledger_source: String = HoundConfig.LEDGER_SOURCE

var state: int = State.FOLLOW
## The current target's registry record, or {} -- written ONLY by `think()`.
var target: Dictionary = {}
var reason_code: String = HoundTargeting.NONE
var reason_text: String = "NO TARGET — not yet evaluated"

## Diagnostics the suite and the HUD read. LOGS, not control state.
var thinks: int = 0
var target_changes: int = 0
var acquisitions: int = 0
var abandonments: int = 0
var ties_resolved: int = 0
var bites: int = 0
var damage_dealt: float = 0.0
var last_bite_frame: int = -1
var choice_log: Array = []
var falls: int = 0
var last_damage_source: String = ""
var follow_speed_samples: Array = []
## The most recent abandonment, kept while the hound returns to her and cleared
## when it arrives or takes a new target -- so the HUD can say WHY it is coming
## back for as long as it is coming back.
var abandon_code: String = ""
var abandon_id: String = ""

## D-398 -- regrouping and the soft recovery. LOGS and mode, not commands.
var regrouping: bool = false
var regroups: int = 0
var recover_phase: String = ""
var recover_t: float = 0.0
var recover_cause: String = ""
var recoveries: int = 0
var attack_index: int = -1
var attack_inner: bool = false
var _attack_target: String = ""
var _attack_target_pos: Vector3 = Vector3.ZERO

var follower := NavService.PathFollower.new()
var _think_t: float = 0.0
var _think_now: bool = true
var _bite_cd: float = 0.0
var _repath_t: float = 1000.0
var _repath_goal: Vector3 = Vector3.INF
var _map: RID

func setup(p_index: int, p_handler: Node3D, p_registry: CombatEntityRegistry, damage: float, cfg_id: String) -> void:
	index = p_index
	handler = p_handler
	registry = p_registry
	bite_damage = damage
	origin_configuration = cfg_id
	collision_layer = HoundConfig.COLLISION_LAYER
	collision_mask = HoundConfig.COLLISION_MASK_WORLD
	var cs := CollisionShape3D.new()
	var cyl := CylinderShape3D.new()
	cyl.radius = HoundConfig.BODY_RADIUS_M
	cyl.height = 0.8
	cs.shape = cyl
	cs.position = Vector3(0, 0.4, 0)
	add_child(cs)
	# THE ACCEPTED D-396 VALUES, handed to the cohort -- no new number.
	cohort_params = {
		"base_speed": HoundConfig.SPEED_MPS,
		"arrive": HoundConfig.FOLLOW_ARRIVE_M,
		"resume": HoundConfig.FOLLOW_RESUME_M,
		"gain": HoundConfig.FOLLOW_GAIN_PER_S,
		"separation": HoundConfig.SEPARATION_M,
		"push_speed": HoundConfig.SIDESTEP_MPS,
		"body_radius": HoundConfig.BODY_RADIUS_M,
	}

func state_name() -> String:
	return BEHAVIOUR_NAMES[state]

func is_fallen() -> bool:
	return state == State.FALLEN

func target_id() -> String:
	return String(target.get("id", ""))

func ground_point() -> Vector3:
	return global_position

# =============================================================================
# THE STEP
# =============================================================================

func _physics_process(delta: float) -> void:
	step(delta)

## Separated so the suite can drive exact steps.
func step(delta: float) -> void:
	if state == State.FALLEN:
		velocity = Vector3.ZERO
		cohort_mode = MobileCohort.Mode.FALLEN
		return
	if not _map_ready():
		velocity = Vector3.ZERO
		return
	if cohort != null:
		cohort.ensure_updated(delta)
	_bite_cd = maxf(0.0, _bite_cd - delta)
	# 0. A SOFT RECOVERY IN PROGRESS IS HARMLESS: no choice, no bite, no damage.
	if recover_phase != "":
		_step_recovery(delta)
		move_and_slide()
		global_position.y = 0.0
		return
	# 1. SHE EXCEEDS THE LEASH: REGROUPING OVERRIDES COMBAT (D-398 item 9). The
	#    accepted leash and acquisition ranges give the band -- no new distance.
	var d_her := HoundTargeting.planar(global_position, _handler_pos())
	if not regrouping and d_her > HoundConfig.LEASH_RANGE_M:
		regrouping = true
		regroups += 1
		think()
	elif regrouping and d_her <= HoundConfig.ACQUISITION_RANGE_M:
		regrouping = false
		_think_now = true
	# 2. EVERY STEP: a retained target that died, became ineligible or crossed the
	#    leash is abandoned NOW, and a fresh choice follows on this same step.
	if not target.is_empty():
		var q := HoundTargeting.still_eligible_and_leashed(target, _handler_pos())
		if not bool(q["valid"]):
			_think_now = true
	# 3. THE CHOICE, on the re-evaluation cadence or at once when forced -- never
	#    while regrouping.
	_think_t -= delta
	if not regrouping and (_think_now or _think_t <= 0.0):
		_think_t = HoundConfig.THINK_INTERVAL_S
		_think_now = false
		think()
	# 4. PATH FAILURE OR FAR BEHIND: a harmless soft recovery (D-398 item 8).
	if target.is_empty() and cohort != null:
		var cause := cohort.recovery_check(self, delta, regrouping)
		if cause != "":
			_begin_recovery(cause)
			move_and_slide()
			global_position.y = 0.0
			return
	# 5. MOVE, AND BITE.
	if not target.is_empty():
		_engage(delta)
	else:
		_follow(delta)
	move_and_slide()
	global_position.y = 0.0

## THE ONE PLACE `target` IS WRITTEN.
func think() -> void:
	if registry == null or not is_inside_tree():
		return
	thinks += 1
	var before := target_id()
	var d: Dictionary
	if regrouping:
		d = _regroup_decision()
	else:
		d = HoundTargeting.decide(target, registry.records(), global_position, _handler_pos(),
			registry, Callable(self, "_reachable"))
	var rec: Dictionary = d["record"]
	if String(d["abandoned"]) != "":
		abandonments += 1
		abandon_code = String(d["abandon_code"])
		abandon_id = String(d["abandon_id"])
	target = rec
	reason_code = String(d["code"])
	reason_text = String(d["text"])
	if (d["tie_ids"] as Array).size() > 1:
		ties_resolved += 1
	var after := target_id()
	if after != before:
		target_changes += 1
		if after != "":
			acquisitions += 1
			abandon_code = ""
			abandon_id = ""
		choice_log.append({"frame": Engine.get_physics_frames(), "code": reason_code, "id": after,
			"from": before})
		follower = NavService.PathFollower.new()
		_repath_t = 1000.0
		_release_attack()
	if target.is_empty():
		state = State.FOLLOW

## REGROUPING OVERRIDES COMBAT: nothing is retained and nothing acquired. A current
## target is abandoned with the accepted rule's own code if it is no longer valid
## (no path query), else with the regroup code. The same shape `decide()` returns.
func _regroup_decision() -> Dictionary:
	var her := _handler_pos()
	var d_her := HoundTargeting.planar(global_position, her)
	var abandoned := ""
	var code := ""
	var aid := ""
	if not target.is_empty():
		var q := HoundTargeting.still_eligible_and_leashed(target, her)
		aid = target_id()
		if bool(q["valid"]):
			code = ABANDONED_REGROUP
			abandoned = "%s %s (she is %.2f m from this hound, beyond the %.1f m leash)" \
				% [code, aid, d_her, HoundConfig.LEASH_RANGE_M]
		else:
			code = String(q["code"])
			abandoned = "%s %s (%s)" % [code, aid, String(q["why"])]
	var text := "REGROUPING — she is %.2f m away, beyond the %.1f m leash; combat waits until it is back inside %.1f m of her" \
		% [d_her, HoundConfig.LEASH_RANGE_M, HoundConfig.ACQUISITION_RANGE_M]
	if abandoned != "":
		text = "%s; %s" % [abandoned, text]
	return {"record": {}, "code": HoundTargeting.NONE, "abandoned": abandoned, "abandon_code": code,
		"abandon_id": aid, "text": text, "distance": INF, "tie_ids": []}

## True once the navigation server has synchronised the map at least once. A
## query made before that FAILS WITH AN ENGINE ERROR and answers nothing -- which
## would read as "unreachable" -- so until then a hound neither chooses nor paths.
func _map_ready() -> bool:
	if not _map.is_valid() and is_inside_tree():
		_map = NavService.map_rid_for(self)
	return _map.is_valid() and NavigationServer3D.map_get_iteration_id(_map) > 0

## Reachability BY PATH, from where this hound stands: a path that ENDS within
## bite distance of the target -- the project's "you can walk there" test.
func _reachable(record: Dictionary) -> bool:
	if not _map_ready():
		return false
	var p := HoundTargeting.position_of(record)
	if p == Vector3.INF:
		return false
	var r := NavService.reachable(_map, global_position, p,
		HoundConfig.bite_distance(HoundTargeting.radius_of(record)))
	return bool(r["reachable"])

# =============================================================================
# MOVEMENT — through the shared cohort (D-398)
# =============================================================================

func _handler_pos() -> Vector3:
	return handler.global_position if handler != null and is_instance_valid(handler) else global_position

## This hound's formation slot: its rank by combat-entity ID in the cohort's
## Vanguard formation round the predictive anchor. (Until D-398 this was a slot
## 1.7 m behind her at +/-55 degrees by pack index -- true when written.)
func follow_slot() -> Vector3:
	if cohort != null:
		return cohort.slot_of(self)
	return _handler_pos()

func _follow(delta: float) -> void:
	state = State.REGROUP if regrouping else State.FOLLOW
	cohort_mode = MobileCohort.Mode.REGROUP if regrouping else MobileCohort.Mode.FORMATION
	if cohort == null:
		velocity = Vector3.ZERO
		return
	velocity = cohort.formation_velocity(self, delta, regrouping)
	var speed := Vector2(velocity.x, velocity.z).length()
	if speed > 0.0:
		follow_speed_samples.append(speed)
		if follow_speed_samples.size() > 240:
			follow_speed_samples.pop_front()
	# ARRIVED: the HUD stops saying why it was coming back.
	if abandon_code != "" and not regrouping \
			and HoundTargeting.planar(global_position, cohort.slot_of(self)) <= float(cohort_params["arrive"]):
		abandon_code = ""
		abandon_id = ""

## ENGAGED: it leaves the formation for its STABLE target-relative attack position
## (D-398 item 10) -- the cohort's ring round the target at its approach distance.
## It bites from that ring only; a member beyond the ring's capacity waits.
func _engage(delta: float) -> void:
	cohort_mode = MobileCohort.Mode.ENGAGED
	var tp := HoundTargeting.position_of(target)
	var r := HoundTargeting.radius_of(target)
	var dist := HoundTargeting.planar(global_position, tp)
	var goal := tp
	attack_inner = true
	if cohort != null:
		var a := cohort.attack_position(self, target_id(), tp, HoundConfig.approach_distance(r))
		goal = a["position"]
		attack_inner = bool(a["inner"])
		attack_index = int(a["index"])
		_attack_target = target_id()
		_attack_target_pos = tp
	var to_goal := HoundTargeting.planar(global_position, goal)
	if dist > HoundConfig.bite_distance(r) or not attack_inner:
		state = State.ENGAGE
		# A WAITING member stops at its waiting position; one holding an ATTACK
		# position keeps closing until it is within bite distance -- stopping at the
		# arrival tolerance OUTSIDE the ring would leave it just out of reach
		# (measured in the lab: 0.18 m out, it never bit).
		if to_goal > CohortConfig.ATTACK_ARRIVE_M or attack_inner:
			var dir := _steer_to(goal, delta)
			velocity = dir * minf(HoundConfig.SPEED_MPS, HoundConfig.FOLLOW_GAIN_PER_S * to_goal + HoundConfig.SIDESTEP_MPS)
		else:
			velocity = Vector3.ZERO
	else:
		state = State.BITE
		if to_goal > CohortConfig.ATTACK_ARRIVE_M:
			var to := goal - global_position
			to.y = 0.0
			velocity = to.normalized() * minf(HoundConfig.SIDESTEP_MPS, HoundConfig.FOLLOW_GAIN_PER_S * to_goal)
		else:
			velocity = Vector3.ZERO
	if attack_inner and dist <= HoundConfig.bite_distance(r) and _bite_cd <= 0.0:
		_bite()

## Path to `goal`, repathed on the accepted cadence or when the goal has moved.
func _steer_to(goal: Vector3, delta: float) -> Vector3:
	_repath_t += delta
	if _repath_t >= ProdConfig.REPATH_INTERVAL_S or follower.finished() \
			or HoundTargeting.planar(goal, _repath_goal) > 0.5:
		_repath_t = 0.0
		_repath_goal = goal
		follower.repath(_map, global_position, NavService.nearest_point(_map, goal))
	var dir := follower.steer(global_position)
	if dir == Vector3.ZERO:
		dir = goal - global_position
		dir.y = 0.0
		dir = dir.normalized() if dir.length() > 0.001 else Vector3.ZERO
	return dir

func _release_attack() -> void:
	if _attack_target != "" and cohort != null:
		cohort.release_attack(self, _attack_target, _attack_target_pos)
	_attack_target = ""
	attack_index = -1
	attack_inner = false

# =============================================================================
# THE SOFT RECOVERY (D-398 item 8) — harmless, automatic, not a command
# =============================================================================

## It fades out where it stands, is relocated into a VALID, UNOCCUPIED formation
## slot the cohort chooses, and fades in. It chooses nothing and bites nothing in
## all of that; it is the same hound, with the same ID. No Mana, no reservation.
func _begin_recovery(cause: String) -> void:
	recoveries += 1
	recover_cause = cause
	recover_phase = "OUT"
	recover_t = 0.0
	state = State.RECOVER
	cohort_mode = MobileCohort.Mode.RECOVER
	regrouping = false
	_release_attack()
	velocity = Vector3.ZERO
	if cohort != null:
		cohort.note_recovery(self, cause)

func _step_recovery(delta: float) -> void:
	recover_t += delta
	state = State.RECOVER
	cohort_mode = MobileCohort.Mode.RECOVER
	if recover_phase == "OUT":
		velocity = Vector3.ZERO
		if recover_t >= CohortConfig.RECOVERY_OUT_S:
			var p := cohort.recovery_slot(self) if cohort != null else _handler_pos()
			global_position = Vector3(p.x, 0.0, p.z)
			follower = NavService.PathFollower.new()
			recover_phase = "IN"
			recover_t = 0.0
		return
	velocity = cohort.formation_velocity(self, delta, true) if cohort != null else Vector3.ZERO
	if recover_t >= CohortConfig.RECOVERY_IN_S:
		recover_phase = ""
		recover_t = 0.0
		state = State.FOLLOW
		cohort_mode = MobileCohort.Mode.FORMATION
		_think_now = true

# =============================================================================
# THE BITE
# =============================================================================

## Through the enemy's OWN Hit receiver, attributed in the accepted ledger. It
## carries the registry value at rank -- no aura, no Mark, no other bonus. A
## DIAGNOSTIC STRESS MINION's bite goes to its own diagnostic ledger source.
func _bite() -> void:
	var n = target.get("node", null)
	if n == null or not is_instance_valid(n) or not n.has_method("receive_damage"):
		return
	_bite_cd = HoundConfig.BITE_INTERVAL_S
	n.call("receive_damage", bite_damage, global_position)
	bites += 1
	damage_dealt += bite_damage
	last_bite_frame = Engine.get_physics_frames()
	SkillRuntime.record_damage(ledger_source, bite_damage, origin_configuration)

# =============================================================================
# LIFE, FALLING AND RETURNING
# =============================================================================

## THE ONE DAMAGE PATH. An enemy area attack or hazard would come through here --
## none exists in this slice -- and so does the diagnostic review control.
func receive_damage(amount: float, from: Vector3, source: String = "") -> void:
	if state == State.FALLEN:
		return
	if not life.apply(amount, from):
		return
	last_damage_source = source
	if life.dead:
		_fall()

func _fall() -> void:
	falls += 1
	_release_attack()
	state = State.FALLEN
	cohort_mode = MobileCohort.Mode.FALLEN
	target = {}
	abandon_code = ""
	abandon_id = ""
	regrouping = false
	recover_phase = ""
	recover_t = 0.0
	reason_code = HoundTargeting.NONE
	reason_text = "FALLEN — returning through the low-friction recovery model"
	velocity = Vector3.ZERO
	choice_log.append({"frame": Engine.get_physics_frames(), "code": "FALLEN", "id": "", "from": ""})

## The runtime's low-friction return: at full Life, at the given point, following.
func revive_at(p: Vector3) -> void:
	life.reset()
	global_position = Vector3(p.x, 0.0, p.z)
	state = State.FOLLOW
	cohort_mode = MobileCohort.Mode.FORMATION
	target = {}
	regrouping = false
	recover_phase = ""
	reason_code = HoundTargeting.NONE
	reason_text = "RETURNED — at her side; choosing afresh"
	_think_now = true
	follower = NavService.PathFollower.new()
	_bite_cd = 0.0
