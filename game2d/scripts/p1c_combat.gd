class_name P1CCombat
extends RefCounted

## P1C-H — the diagnostic projectile, the enemy cycle and the dropped item.
##
## > **THE HUNTRESS ACTION HERE IS A DIAGNOSTIC, NON-CANONICAL PROJECTILE.**
## > It is **NOT a designed Skill**, it defines no class mechanic, and the runtime says so
## > on screen. D-347 sub-ruling B allows P1 exactly one such action and forbids P1 from
## > defining her class mechanics; a canonical Huntress class specification is a P2
## > prerequisite and this is not it.

const DIAGNOSTIC_LABEL: String = "DIAGNOSTIC, NON-CANONICAL — not a designed Skill"
const IS_DESIGNED_SKILL: bool = false

## Projectile, in metres and seconds. Proposed by this proof; not locks.
const PROJECTILE_SPEED_MPS: float = 14.0
const PROJECTILE_LIFETIME_S: float = 1.2
const PROJECTILE_RADIUS_M: float = 0.12
const TARGET_RADIUS_M: float = 0.40

## Enemy, in metres and seconds. Proposed by this proof; not locks.
const ENEMY_PREFERRED_DISTANCE_M: float = 3.0
const ENEMY_DISTANCE_TOLERANCE_M: float = 0.25
const ENEMY_ANTICIPATION_S: float = 0.45
const ENEMY_RELEASE_S: float = 0.15
const ENEMY_MAX_LIFE: int = 30
const PROJECTILE_DAMAGE: int = 12

enum Phase { PURSUE, HOLD, PERMISSION, ANTICIPATION, COMMIT, RELEASE, OBSTRUCTED, DEAD }
const PHASE_NAMES: Array[String] = [
	"pursue", "hold", "permission", "anticipation", "commit", "release", "obstructed", "dead",
]


## Simulate one diagnostic projectile against one target.
##
## **POINT-BLANK IS A NAMED DEFECT CLASS IN THIS PROJECT** — "a shape query blind to what it
## already overlaps". The overlap is therefore tested BEFORE the first step, so a shot fired
## at an already-overlapping target hits on frame 0 instead of tunnelling past it.
static func fire(origin: Vector2, direction: Vector2, target: Vector2,
		px_per_m: float, dt: float) -> Dictionary:
	var hit_radius_px: float = (PROJECTILE_RADIUS_M + TARGET_RADIUS_M) * px_per_m
	var pos: Vector2 = origin
	var travelled_m: float = 0.0
	var t: float = 0.0
	# Frame 0: already overlapping?
	if pos.distance_to(target) <= hit_radius_px:
		return {"hit": true, "point_blank": true, "travelled_m": 0.0, "time_s": 0.0,
			"expired": false, "steps": 0}
	var step_px: float = PROJECTILE_SPEED_MPS * px_per_m * dt
	var dir: Vector2 = direction.normalized()
	var steps: int = 0
	while t < PROJECTILE_LIFETIME_S:
		pos += dir * step_px
		travelled_m += step_px / px_per_m
		t += dt
		steps += 1
		if pos.distance_to(target) <= hit_radius_px:
			return {"hit": true, "point_blank": false, "travelled_m": travelled_m,
				"time_s": t, "expired": false, "steps": steps}
	# Lifetime reached: the projectile is gone. Nothing survives past its lifetime.
	return {"hit": false, "point_blank": false, "travelled_m": travelled_m, "time_s": t,
		"expired": true, "steps": steps}


## The enemy's full cycle, as an ordered list of phases with the facts each one turned on.
##
## `obstruct_at_phase` optionally forces an obstruction once that phase is reached, so the
## obstruction branch is exercised rather than assumed reachable.
static func enemy_cycle(start_distance_m: float, dt: float,
		obstruct_once: bool = true) -> Dictionary:
	var log: Array[Dictionary] = []
	var phase: int = Phase.PURSUE
	var dist: float = start_distance_m
	var life: int = ENEMY_MAX_LIFE
	var t: float = 0.0
	var timer: float = 0.0
	var obstructed_used: bool = false
	var permission_granted: bool = false
	var commit_visible: bool = false
	var released: bool = false
	var hits_taken: int = 0
	var guard: int = 0
	while phase != Phase.DEAD and guard < 20000:
		guard += 1
		t += dt
		match phase:
			Phase.PURSUE:
				dist = maxf(ENEMY_PREFERRED_DISTANCE_M, dist - 4.0 * dt)
				if absf(dist - ENEMY_PREFERRED_DISTANCE_M) <= ENEMY_DISTANCE_TOLERANCE_M:
					phase = Phase.HOLD
					log.append({"phase": phase, "t": t, "distance_m": dist})
			Phase.HOLD:
				# Holding at the preferred distance, then asking for permission to act.
				phase = Phase.PERMISSION
				log.append({"phase": phase, "t": t, "distance_m": dist})
			Phase.PERMISSION:
				permission_granted = true
				phase = Phase.ANTICIPATION
				timer = 0.0
				log.append({"phase": phase, "t": t, "distance_m": dist})
			Phase.ANTICIPATION:
				timer += dt
				if timer >= ENEMY_ANTICIPATION_S:
					phase = Phase.COMMIT
					commit_visible = true
					log.append({"phase": phase, "t": t, "distance_m": dist})
			Phase.COMMIT:
				if obstruct_once and not obstructed_used:
					obstructed_used = true
					phase = Phase.OBSTRUCTED
					log.append({"phase": phase, "t": t, "distance_m": dist})
				else:
					phase = Phase.RELEASE
					timer = 0.0
					log.append({"phase": phase, "t": t, "distance_m": dist})
			Phase.OBSTRUCTED:
				# The commit was interrupted; it returns to holding rather than firing.
				phase = Phase.HOLD
			Phase.RELEASE:
				timer += dt
				if timer >= ENEMY_RELEASE_S:
					released = true
					# The player's diagnostic projectile lands here.
					life -= PROJECTILE_DAMAGE
					hits_taken += 1
					log.append({"phase": -1, "t": t, "event": "hit", "life": life})
					if life <= 0:
						phase = Phase.DEAD
						log.append({"phase": phase, "t": t, "life": life})
					else:
						phase = Phase.HOLD
	var order: Array[int] = []
	for e: Dictionary in log:
		if int(e.get("phase", -1)) >= 0:
			order.append(int(e["phase"]))
	return {"log": log, "phase_order": order, "hits_taken": hits_taken, "final_life": life,
		"permission_granted": permission_granted, "commit_visible": commit_visible,
		"released": released, "obstructed": obstructed_used, "elapsed_s": t}


## The dropped item's comparison. **Computed facts only** — no adjectives, no verdict, no
## "better"/"worse", because a comparison that editorialises is a comparison the player
## cannot check.
static func compare_items(equipped: Dictionary, candidate: Dictionary) -> Dictionary:
	var lines: Array[String] = []
	var deltas: Dictionary = {}
	var keys: Array = equipped.keys()
	keys.sort()
	for k: String in keys:
		if not candidate.has(k):
			continue
		var a: float = float(equipped[k])
		var b: float = float(candidate[k])
		deltas[k] = b - a
		lines.append("%s %s -> %s (%+.1f)" % [k, str(a), str(b), b - a])
	return {"lines": lines, "deltas": deltas}
