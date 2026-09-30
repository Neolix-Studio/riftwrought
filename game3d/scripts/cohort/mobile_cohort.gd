class_name MobileCohort
extends RefCounted

## THE SHARED MOBILE-MINION COHORT (D-398) — where each mobile persistent minion
## stands and how fast it moves, and nothing about whom it fights.
##
## ============================================================================
## ONE SHARED SYSTEM. KINDRED HOUNDS ARE ITS ONLY PRODUCTION CONSUMER.
## ============================================================================
## The owner: "Build a shared cohort system with Kindred Hounds as its only
## production consumer." So nothing in this file names a hound: it reads the
## MEMBER CONTRACT below, and a later mobile minion that honours the contract --
## in a separately authorized stage -- joins the same cohort.
##
## ---------------------------------------------------------------------------
## THE MEMBER CONTRACT (duck-typed; checked at `join()`)
## ---------------------------------------------------------------------------
## A member is a Node3D that supplies:
##   combat_id: String       -- its combat-entity ID in the AREA registry (an ALLY)
##   cohort_role: int        -- a `FormationProfile.Role`; it must be the profile's
##   cohort_params: Dict     -- its own body and movement facts:
##       base_speed, arrive, resume, gain, separation, push_speed, body_radius
##   cohort_mode: int        -- its own `Mode`, which IT writes every step
##   velocity: Vector3, global_position, is_fallen()
## The cohort WRITES NOTHING on a member. A member ASKS -- `formation_velocity()`,
## `attack_position()`, `recovery_check()`, `recovery_slot()` -- and acts.
##
## ---------------------------------------------------------------------------
## WHAT IT DOES
## ---------------------------------------------------------------------------
##   * STABLE SLOTS: members are RANKED by combat-entity ID (`precedes()`), and
##     rank k holds slot k. A fallen or recovering member keeps its rank; adding
##     members appends slots. Nothing reads a name, a tree order or memory.
##   * A LOOSE MULTI-RING VANGUARD round a PREDICTIVE ANCHOR slightly ahead of
##     her, turned toward her travel at a rate, every slot clamped to walkable
##     ground along the straight line from the anchor.
##   * PACE AND CATCH-UP: a feed-forward of the slot's own velocity keeps pace;
##     the cap rises with her speed and with the distance behind.
##   * CONGESTION: a crowded, returning or catching-up member ignores separation
##     and her clearance; a settled or travelling one keeps both (visual only --
##     no member can block her: its layer is masked by nothing).
##   * SOFT RECOVERY decisions and the choice of a VALID, UNOCCUPIED slot.
##   * TARGET-RELATIVE MELEE POSITIONS, one `AttackPositions` table per target.
##
## EVERY NUMBER IT USES IS PROVISIONAL (`CohortConfig.registry()`), or is the
## member's own accepted value.

enum Mode { FORMATION, ENGAGED, REGROUP, RECOVER, FALLEN }
const MODE_NAMES := ["FORMATION", "ENGAGED", "REGROUP", "RECOVER", "FALLEN"]

const CAUSE_PATH := "PATH FAILURE"
const CAUSE_FAR := "FAR BEHIND"
const CAUSE_REGROUP := "REGROUP TIMEOUT"

## One member's movement bookkeeping. Kept HERE, so the member needs none.
class Track extends RefCounted:
	var member: Node3D = null
	var slot: Vector3 = Vector3.INF
	var ideal: Vector3 = Vector3.INF
	var prev_slot: Vector3 = Vector3.INF
	var slot_velocity: Vector3 = Vector3.ZERO
	var settled: bool = false
	var follower := NavService.PathFollower.new()
	var direct: bool = true
	var steer_t: float = 1000.0
	var path_ok: bool = true
	var path_fail_t: float = 0.0
	var stall_t: float = 0.0
	var stall_from: Vector3 = Vector3.INF
	var stalled: bool = false
	var far_t: float = 0.0
	var regroup_t: float = 0.0
	var congested: bool = false
	var neighbours: int = 0
	var lag: float = 0.0
	## Diagnostics: frames in which separation and her clearance were ignored, and
	## path queries made for this member.
	var passed_through: int = 0
	var path_queries: int = 0
	var direct_frames: int = 0
	var path_frames: int = 0

var leader: Node3D = null
var registry: CombatEntityRegistry = null
var profile: FormationProfile = null
var first_radius: float = 1.0
var map: RID
## In RANK order: sorted by combat-entity ID.
var tracks: Array = []
var offsets: Array = []

var heading := Vector3(0, 0, 1)
var lead := Vector3.ZERO
var anchor := Vector3.ZERO
var leader_velocity := Vector3.ZERO
var leader_speed: float = 0.0
var _prev_leader := Vector3.INF
var _frame: int = -1
## target combat-entity ID -> AttackPositions
var attack: Dictionary = {}

## Diagnostics the suite and the HUD read. LOGS, not control state.
var updates: int = 0
var teleports: int = 0
var recoveries := {CAUSE_PATH: 0, CAUSE_FAR: 0, CAUSE_REGROUP: 0}
var recovery_log: Array = []
var furthest_lag: float = 0.0
var furthest_lag_id: String = ""
var farthest_from_her: float = 0.0
var mode_counts := {}
var formation_state: String = "SETTLED"
var joins_refused: int = 0
var last_refusal: String = ""

## TEST SEAMS. False in normal play; the D-398 suite asserts so, and uses each
## only to prove the property it removes is doing the work.
var debug_disable_pass_through: bool = false
var debug_disable_feed_forward: bool = false

func _init(p_leader: Node3D, p_registry: CombatEntityRegistry, p_profile: FormationProfile,
		p_first_radius: float, p_map: RID) -> void:
	leader = p_leader
	registry = p_registry
	profile = p_profile
	first_radius = p_first_radius
	map = p_map
	if leader != null:
		var f := leader.global_transform.basis.z
		f.y = 0.0
		if f.length() > 0.01:
			heading = f.normalized()

# =============================================================================
# MEMBERSHIP — ranked by combat-entity ID
# =============================================================================

func join(member: Node3D) -> bool:
	var id := String(member.get("combat_id")) if member.get("combat_id") != null else ""
	if id == "":
		return _refuse("a member without a combat-entity ID cannot join: its rank would be undefined")
	if member.get("cohort_role") == null or int(member.get("cohort_role")) != profile.role:
		return _refuse("a member of another role cannot join a %s cohort" % profile.profile_name)
	if track_of(member) != null:
		return _refuse("already a member")
	var t := Track.new()
	t.member = member
	tracks.append(t)
	_rank()
	return true

func _refuse(reason: String) -> bool:
	joins_refused += 1
	last_refusal = reason
	return false

func leave(member: Node3D) -> void:
	var t := track_of(member)
	if t == null:
		return
	for tid in attack.keys().duplicate():
		var tab: AttackPositions = attack[tid]
		if tab.claims.has(String(member.get("combat_id"))):
			tab.release(String(member.get("combat_id")), _positions(), Vector3.ZERO, Callable(registry, "precedes"))
			if tab.holders() == 0:
				attack.erase(tid)
	tracks.erase(t)
	_rank()

## RANK = order of combat-entity ID. An insertion sort through the registry's ONE
## ordering; the offsets are rebuilt for the new count (appending).
func _rank() -> void:
	var sorted: Array = []
	for t in tracks:
		var id := String((t as Track).member.get("combat_id"))
		var at := sorted.size()
		for i in sorted.size():
			if registry.precedes(id, String((sorted[i] as Track).member.get("combat_id"))):
				at = i
				break
		sorted.insert(at, t)
	tracks = sorted
	offsets = CohortFormation.slot_offsets(profile, first_radius, tracks.size())

func track_of(member: Node3D) -> Track:
	for t in tracks:
		if (t as Track).member == member:
			return t
	return null

func rank_of(member: Node3D) -> int:
	for i in tracks.size():
		if (tracks[i] as Track).member == member:
			return i
	return -1

func members() -> Array:
	var out: Array = []
	for t in tracks:
		out.append((t as Track).member)
	return out

func size() -> int:
	return tracks.size()

# =============================================================================
# THE STEP — once per physics frame, before the members move
# =============================================================================

func ensure_updated(delta: float) -> void:
	var f := Engine.get_physics_frames()
	if f != _frame:
		_frame = f
		update(delta)

func update(delta: float) -> void:
	if leader == null or not is_instance_valid(leader) or not leader.is_inside_tree():
		return
	# A map the navigation server has not synchronised yet FAILS a query with an
	# engine error and answers nothing (measured at D-396), so until it has, the
	# cohort does not move its slots.
	if not map.is_valid() or NavigationServer3D.map_get_iteration_id(map) == 0:
		return
	updates += 1
	var pos := Vector3(leader.global_position.x, 0.0, leader.global_position.z)
	var v: Vector3 = leader.get("velocity") if leader.get("velocity") != null else Vector3.ZERO
	v.y = 0.0
	leader_velocity = v
	leader_speed = v.length()
	# A TELEPORT -- a jump her velocity cannot explain -- resets the lead.
	if _prev_leader != Vector3.INF:
		var expected := _prev_leader + v * delta
		if CohortFormation.planar(pos, expected) > CohortConfig.TELEPORT_JUMP_M:
			teleports += 1
			lead = Vector3.ZERO
			for t in tracks:
				(t as Track).prev_slot = Vector3.INF
	_prev_leader = pos
	# THE HEADING AND THE LEAD FOLLOW HER WHILE SHE MOVES, AND FREEZE WHILE SHE
	# STANDS -- so a settled pack does not creep back and restart.
	if leader_speed > CohortConfig.LEADER_MOVING_MPS:
		heading = CohortFormation.turn_heading(heading, v / leader_speed,
			deg_to_rad(CohortConfig.HEADING_TURN_DEG_PER_S) * delta)
		var want := CohortFormation.lead_target(v, CohortConfig.LEAD_TIME_S, CohortConfig.LEAD_MAX_M)
		lead = lead.lerp(want, clampf(delta / CohortConfig.LEAD_BLEND_S, 0.0, 1.0))
	anchor = CohortFormation.walkable_toward(map, pos, pos + lead)
	# THE SLOTS, by rank, each clamped along the straight line from the anchor.
	for rank in tracks.size():
		var t: Track = tracks[rank]
		t.ideal = CohortFormation.to_world(anchor, heading, offsets[rank])
		var s := CohortFormation.walkable_toward(map, anchor, t.ideal)
		if t.prev_slot != Vector3.INF and delta > 0.0:
			t.slot_velocity = (s - t.prev_slot) / delta
			t.slot_velocity.y = 0.0
		else:
			t.slot_velocity = Vector3.ZERO
		t.prev_slot = s
		t.slot = s
	_measure()

## Congestion, the lag and the formation state -- read every step by the HUD.
func _measure() -> void:
	furthest_lag = 0.0
	furthest_lag_id = ""
	farthest_from_her = 0.0
	mode_counts = {}
	var lpos := Vector3(leader.global_position.x, 0.0, leader.global_position.z)
	var unsettled := 0
	for t in tracks:
		var tt: Track = t
		var m := tt.member
		if m == null or not is_instance_valid(m):
			continue
		var mode := int(m.get("cohort_mode"))
		mode_counts[mode] = int(mode_counts.get(mode, 0)) + 1
		tt.neighbours = 0
		if mode != Mode.FALLEN:
			for o in tracks:
				var ot: Track = o
				if ot == tt or ot.member == null or not is_instance_valid(ot.member):
					continue
				if int(ot.member.get("cohort_mode")) == Mode.FALLEN:
					continue
				if CohortFormation.planar(m.global_position, ot.member.global_position) < CohortConfig.CONGESTION_RADIUS_M:
					tt.neighbours += 1
		tt.congested = tt.neighbours >= CohortConfig.CONGESTION_NEIGHBOURS
		if mode == Mode.FALLEN:
			continue
		farthest_from_her = maxf(farthest_from_her, CohortFormation.planar(m.global_position, lpos))
		if mode == Mode.FORMATION or mode == Mode.REGROUP or mode == Mode.RECOVER:
			tt.lag = CohortFormation.planar(m.global_position, tt.slot)
			if tt.lag > furthest_lag:
				furthest_lag = tt.lag
				furthest_lag_id = String(m.get("combat_id"))
			if not tt.settled:
				unsettled += 1
	if int(mode_counts.get(Mode.REGROUP, 0)) > 0:
		formation_state = "REGROUPING"
	elif int(mode_counts.get(Mode.RECOVER, 0)) > 0:
		formation_state = "RECOVERING"
	elif int(mode_counts.get(Mode.ENGAGED, 0)) > 0:
		formation_state = "IN COMBAT"
	elif leader_speed > CohortConfig.LEADER_MOVING_MPS:
		formation_state = "TRAVELLING"
	elif unsettled > 0:
		formation_state = "REFORMING"
	else:
		formation_state = "SETTLED"

func count_in(mode: int) -> int:
	return int(mode_counts.get(mode, 0))

# =============================================================================
# SLOTS
# =============================================================================

## The member's formation slot, as of this step.
func slot_of(member: Node3D) -> Vector3:
	var t := track_of(member)
	if t == null:
		return Vector3(leader.global_position.x, 0.0, leader.global_position.z)
	if t.slot == Vector3.INF:
		return spawn_point_for_rank(rank_of(member))
	return t.slot

## A slot round HER -- the anchor's lead is NOT applied -- where a summoned,
## resummoned or returning member appears: at her side.
func spawn_point_for_rank(rank: int) -> Vector3:
	var pos := Vector3(leader.global_position.x, 0.0, leader.global_position.z)
	if rank < 0 or rank >= offsets.size():
		return pos
	var ideal := CohortFormation.to_world(pos, heading, offsets[rank])
	# UNTIL THE MAP CAN VALIDATE A POINT -- not yet synchronised, or synchronised
	# without its polygons, so not even her own spot reads as walkable -- the member
	# appears where SHE stands, the one place known to be walkable, and walks out
	# to its slot.
	# (D-398 delivery correction, recorded: before the first synchronisation this
	# returned the raw, unvalidated slot -- true when written. The rendered doorway
	# staging summoned members then, one slot lay off the mesh, and a soft recovery
	# had to rescue it. Headless runs synchronise before any summon and never showed it.)
	if not NavigationServer3D.map_get_iteration_id(map) > 0 or not CohortFormation.on_mesh(map, pos):
		return pos
	return CohortFormation.walkable_toward(map, pos, ideal)

func spawn_point(member: Node3D) -> Vector3:
	return spawn_point_for_rank(rank_of(member))

# =============================================================================
# MOVEMENT — "keep pace", "catch up", "never body-block her"
# =============================================================================

## The velocity that keeps a member in formation: settling with hysteresis while
## she stands, tracking with a feed-forward while she moves, returning at the
## catch-up cap. `returning` is true while the member regroups or recovers.
func formation_velocity(member: Node3D, delta: float, returning: bool) -> Vector3:
	var t := track_of(member)
	if t == null:
		return Vector3.ZERO
	var p: Dictionary = member.get("cohort_params")
	var pos := Vector3(member.global_position.x, 0.0, member.global_position.z)
	var slot := slot_of(member)
	var err_vec := slot - pos
	err_vec.y = 0.0
	var err := err_vec.length()
	var cap := CohortConfig.catchup_cap(float(p["base_speed"]), leader_speed, err)
	var catching := err > CohortConfig.CATCHUP_START_M
	var pass_through := (returning or catching or t.congested) and not debug_disable_pass_through
	if pass_through:
		t.passed_through += 1
	var moving := leader_speed > CohortConfig.LEADER_MOVING_MPS
	var v := Vector3.ZERO
	if not moving and not returning:
		# SHE STANDS: settle once, resume only past the resume distance.
		if t.settled:
			if err > float(p["resume"]):
				t.settled = false
		elif err <= float(p["arrive"]):
			t.settled = true
		if t.settled:
			return _local_push(member, t, pass_through) * float(p["push_speed"])
		var dir := _steer_dir(member, t, slot, delta)
		v = dir * minf(float(p["gain"]) * err, cap)
	else:
		t.settled = false
		var ff := t.slot_velocity * CohortConfig.PACE_RATIO
		if debug_disable_feed_forward:
			ff = Vector3.ZERO
		var dir2 := _steer_dir(member, t, slot, delta)
		if t.direct:
			v = ff + err_vec * float(p["gain"])
		else:
			v = dir2 * CohortFormation.tracking_speed(ff.length(), float(p["gain"]), err, cap)
		v = v.limit_length(cap)
	if not pass_through:
		v = (v + _local_push(member, t, false) * float(p["push_speed"])).limit_length(cap)
	v.y = 0.0
	return v

## Local visual separation from the other members and a visual clearance from her.
## A unit-bounded push; nothing here can move HER.
func _local_push(member: Node3D, t: Track, ignore: bool) -> Vector3:
	if ignore:
		return Vector3.ZERO
	var p: Dictionary = member.get("cohort_params")
	var sep := float(p["separation"])
	var push := Vector3.ZERO
	var my_rank := rank_of(member)
	for o in tracks:
		var ot: Track = o
		if ot == t or ot.member == null or not is_instance_valid(ot.member):
			continue
		if int(ot.member.get("cohort_mode")) == Mode.FALLEN:
			continue
		var away: Vector3 = member.global_position - ot.member.global_position
		away.y = 0.0
		var d := away.length()
		if d >= sep:
			continue
		if d < 0.0001:
			# Coincident: a direction by RANK, never by memory.
			away = Vector3(1, 0, 0).rotated(Vector3.UP, float(my_rank) * 2.39996)
			d = 0.0
		push += away.normalized() * (1.0 - d / sep)
	var from_her: Vector3 = member.global_position - leader.global_position
	from_her.y = 0.0
	var dh := from_her.length()
	if dh < CohortConfig.PLAYER_CLEARANCE_M and dh > 0.0001:
		push += from_her.normalized() * (1.0 - dh / CohortConfig.PLAYER_CLEARANCE_M)
	return push.limit_length(1.0)

## The steering direction toward `goal`: STRAIGHT when the line is walkable (no
## path query), else along a path -- re-evaluated on the accepted repath cadence.
## Records whether a path reaches the goal, for the path-failure test.
func _steer_dir(member: Node3D, t: Track, goal: Vector3, delta: float) -> Vector3:
	var pos := Vector3(member.global_position.x, 0.0, member.global_position.z)
	t.steer_t += delta
	if t.steer_t >= ProdConfig.REPATH_INTERVAL_S or (not t.direct and t.follower.finished()):
		t.steer_t = 0.0
		t.direct = CohortFormation.straight_walkable(map, pos, goal)
		if t.direct:
			t.path_ok = true
		else:
			t.follower.repath(map, pos, goal)
			t.path_queries += 1
			t.path_ok = _path_serves(t.follower.points, pos, goal)
	var to := goal - pos
	to.y = 0.0
	if t.direct:
		t.direct_frames += 1
		return to.normalized() if to.length() > 0.001 else Vector3.ZERO
	t.path_frames += 1
	var d := t.follower.steer(pos)
	if d == Vector3.ZERO:
		d = to.normalized() if to.length() > 0.001 else Vector3.ZERO
	return d

## A path SERVES when it starts where the member stands and ends at the goal --
## "every socket is on the mesh" and "you can walk there" are different claims.
static func _path_serves(points: PackedVector3Array, from: Vector3, goal: Vector3) -> bool:
	if points.size() < 2:
		return false
	return CohortFormation.planar(points[0], from) <= CohortConfig.PATH_END_TOLERANCE_M \
		and CohortFormation.planar(points[points.size() - 1], goal) <= CohortConfig.PATH_END_TOLERANCE_M

# =============================================================================
# SOFT RECOVERY — the decision and the destination
# =============================================================================

## Returns the cause of a soft recovery due NOW, or "". Called by a member in
## formation or regrouping, every step.
func recovery_check(member: Node3D, delta: float, regrouping: bool) -> String:
	var t := track_of(member)
	if t == null:
		return ""
	var p: Dictionary = member.get("cohort_params")
	var pos := Vector3(member.global_position.x, 0.0, member.global_position.z)
	# 1. PATH FAILURE: no path serves its slot, it stands off the mesh, or it stalls
	#    -- judged ONLY while it still has somewhere to go. A member AT its slot
	#    (settled, or within the resume distance) asks for no path, so its last
	#    path verdict is STALE and is not a failure.
	#    (D-398 delivery correction, recorded: this read `if t.path_ok: reset else
	#    accumulate` -- true when written. Found by LOOKING at the rendered frames:
	#    they showed 4 and 12 path-failure recoveries during staging. On the first
	#    synced frame the map had no polygons yet, one path evaluation failed, the
	#    member then SETTLED -- and a settled member never re-evaluates its path --
	#    so the stale verdict ran out the grace and relocated a member that was
	#    already in its slot. Headless runs never showed it.)
	var wants_to_move := t.lag > float(p["resume"]) and not t.settled
	if t.path_ok or not wants_to_move:
		t.path_fail_t = 0.0
	else:
		t.path_fail_t += delta
	if wants_to_move:
		if t.stall_from == Vector3.INF:
			t.stall_from = pos
			t.stall_t = 0.0
		t.stall_t += delta
		if t.stall_t >= CohortConfig.STALL_WINDOW_S:
			t.stalled = CohortFormation.planar(pos, t.stall_from) < CohortConfig.STALL_MIN_MOVE_M
			t.stall_from = pos
			t.stall_t = 0.0
	else:
		t.stall_from = Vector3.INF
		t.stall_t = 0.0
		t.stalled = false
	if t.path_fail_t >= CohortConfig.PATH_FAIL_GRACE_S or t.stalled:
		return CAUSE_PATH
	# 2. FAR BEHIND.
	if CohortFormation.planar(pos, leader.global_position) > CohortConfig.FAR_BEHIND_M:
		t.far_t += delta
	else:
		t.far_t = 0.0
	if t.far_t >= CohortConfig.FAR_BEHIND_GRACE_S:
		return CAUSE_FAR
	# 3. REGROUPING TOO LONG.
	if regrouping:
		t.regroup_t += delta
	else:
		t.regroup_t = 0.0
	if t.regroup_t > CohortConfig.REGROUP_TIMEOUT_S:
		return CAUSE_REGROUP
	return ""

## Counts a recovery that has begun and clears the member's timers.
func note_recovery(member: Node3D, cause: String) -> void:
	recoveries[cause] = int(recoveries.get(cause, 0)) + 1
	var t := track_of(member)
	if t != null:
		t.path_fail_t = 0.0
		t.far_t = 0.0
		t.regroup_t = 0.0
		t.stall_from = Vector3.INF
		t.stall_t = 0.0
		t.stalled = false
		t.path_ok = true
		t.direct = true
		t.steer_t = 1000.0
		t.follower = NavService.PathFollower.new()

func total_recoveries() -> int:
	var n := 0
	for k in recoveries.keys():
		n += int(recoveries[k])
	return n

## THE DESTINATION: its own slot if valid and unoccupied, else the nearest valid,
## unoccupied formation slot to it -- an exact tie to the lower rank, which is the
## lower combat-entity ID. Valid: walkable within tolerance of its ideal point, and
## reachable from HER by a path without a large detour. Unoccupied: no other
## living member's BODY would overlap one placed there (centres closer than twice
## the member's body radius). Recorded in `recovery_log`.
##
## (D-398 delivery correction, recorded: this read "no other living member within
## the member's separation" -- true when written. Found by C22's own-slot control:
## a neighbour SETTLED at its own adjacent slot stood 0.78 m from this one, inside
## the 0.95 m separation, so a free slot read as occupied. The loose rings space
## slots about 1.03 m apart at the closest, so the separation is the wrong radius
## for "someone is standing in it". No new number: the body radius is D-396's.)
func recovery_slot(member: Node3D) -> Vector3:
	var p: Dictionary = member.get("cohort_params")
	var my_rank := rank_of(member)
	var lpos := Vector3(leader.global_position.x, 0.0, leader.global_position.z)
	# The formation's slots, plus a spare ring's worth, all round the anchor.
	var cand_offsets := CohortFormation.slot_offsets(profile, first_radius, maxi(tracks.size(), 1) + 8)
	var own := CohortFormation.to_world(anchor, heading, cand_offsets[maxi(my_rank, 0)])
	var ranked: Array = []
	for i in cand_offsets.size():
		var ideal := CohortFormation.to_world(anchor, heading, cand_offsets[i])
		ranked.append({"i": i, "ideal": ideal, "d": 0.0 if i == my_rank else CohortFormation.planar(ideal, own)})
	ranked.sort_custom(func(a, b) -> bool:
		if float(a["d"]) != float(b["d"]):
			return float(a["d"]) < float(b["d"])
		return int(a["i"]) < int(b["i"]))
	for c in ranked:
		var ideal: Vector3 = c["ideal"]
		var at := CohortFormation.walkable_toward(map, anchor, ideal)
		if CohortFormation.planar(at, ideal) > CohortConfig.SLOT_VALID_TOLERANCE_M:
			continue
		if not _reachable_from_her(lpos, at):
			continue
		if _occupied(member, at, 2.0 * float(p["body_radius"])):
			continue
		recovery_log.append({"id": String(member.get("combat_id")), "slot": int(c["i"]), "own": int(c["i"]) == my_rank,
			"at": at, "frame": Engine.get_physics_frames()})
		return at
	# NOTHING VALID AND FREE (a wall on every side): the walkable point beside her.
	var fallback := CohortFormation.walkable_toward(map, lpos, lpos - heading * first_radius)
	recovery_log.append({"id": String(member.get("combat_id")), "slot": -1, "own": false, "at": fallback,
		"frame": Engine.get_physics_frames()})
	return fallback

func _reachable_from_her(lpos: Vector3, at: Vector3) -> bool:
	var r := NavService.reachable(map, lpos, at, CohortConfig.PATH_END_TOLERANCE_M)
	if not bool(r["reachable"]):
		return false
	return float(r["path_length"]) <= float(r["straight"]) * CohortConfig.PATH_DETOUR_RATIO + CohortConfig.PATH_DETOUR_SLACK_M

func _occupied(member: Node3D, at: Vector3, overlap: float) -> bool:
	for o in tracks:
		var m: Node3D = (o as Track).member
		if m == member or m == null or not is_instance_valid(m):
			continue
		if int(m.get("cohort_mode")) == Mode.FALLEN:
			continue
		if CohortFormation.planar(m.global_position, at) < overlap:
			return true
	return false

# =============================================================================
# TARGET-RELATIVE MELEE POSITIONS
# =============================================================================

## The member's attack position round a target: {"position", "inner", "index"}.
func attack_position(member: Node3D, target_id: String, target_pos: Vector3, radius: float) -> Dictionary:
	var tab: AttackPositions = attack.get(target_id, null)
	if tab == null:
		var p: Dictionary = member.get("cohort_params")
		tab = AttackPositions.new(target_id, radius, float(p["separation"]))
		attack[target_id] = tab
	var idx := tab.claim(String(member.get("combat_id")), member.global_position, target_pos,
		Callable(self, "_walkable_point"))
	return {"position": tab.position_of(idx, target_pos), "inner": tab.is_inner(idx), "index": idx}

func release_attack(member: Node3D, target_id: String, target_pos: Vector3) -> void:
	var tab: AttackPositions = attack.get(target_id, null)
	if tab == null:
		return
	tab.release(String(member.get("combat_id")), _positions(), target_pos, Callable(registry, "precedes"))
	if tab.holders() == 0:
		attack.erase(target_id)

func _walkable_point(p: Vector3) -> bool:
	return CohortFormation.on_mesh(map, p)

func _positions() -> Dictionary:
	var out := {}
	for t in tracks:
		var m: Node3D = (t as Track).member
		if m != null and is_instance_valid(m):
			out[String(m.get("combat_id"))] = m.global_position
	return out

# =============================================================================
# COST — for the suite's bound
# =============================================================================

func path_queries() -> int:
	var n := 0
	for t in tracks:
		n += (t as Track).path_queries
	return n

func passed_through_frames() -> int:
	var n := 0
	for t in tracks:
		n += (t as Track).passed_through
	return n
