class_name AttackPositions
extends RefCounted

## STABLE TARGET-RELATIVE MELEE POSITIONS ROUND ONE TARGET (D-398).
##
## ============================================================================
## "Melee minions use stable target-relative attack positions rather than
## stacking at one point inside the target."
## ============================================================================
##   * AN ATTACK RING round the target, at the members' approach distance (where
##     a member bites from), its positions spaced by the members' separation --
##     so two biting members never overlap and none stands inside the target;
##   * STABLE: the ring's base angle is fixed by the FIRST claimant's bearing and
##     kept while any claim is held; positions are in the world frame and move
##     with the target without rotating; a claim is held until it is released;
##   * OVERFLOW: members beyond the ring's capacity WAIT on a ring farther out and
##     bite nothing. A freed attack position goes to the NEAREST waiter; an EXACT
##     tie goes to the lower combat-entity ID, through the area registry's one
##     ordering -- never a name, a tree order or memory.
##
## THIS IS STRUCTURE, NOT A DISTRIBUTION RULE. Each member still chooses its own
## target by the accepted rule; nothing here moves a member to another target.

var target_id: String = ""
var radius: float = 0.0
var spacing: float = 0.0
var base_angle: float = NAN
var inner_capacity: int = 0
var outer_radius: float = 0.0
var outer_capacity: int = 0
## member combat-entity ID -> position index. 0 .. inner-1 attack; beyond, waiting.
var claims: Dictionary = {}

## Diagnostics the suite reads. LOGS, not control state.
var promotions: int = 0
var ties_resolved: int = 0

func _init(p_target_id: String, p_radius: float, p_spacing: float) -> void:
	target_id = p_target_id
	radius = p_radius
	spacing = p_spacing
	inner_capacity = maxi(1, int(floor(TAU * radius / spacing)))
	outer_radius = radius + CohortConfig.ATTACK_WAIT_STEP_M
	outer_capacity = maxi(1, int(floor(TAU * outer_radius / spacing)))

func is_inner(index: int) -> bool:
	return index >= 0 and index < inner_capacity

## The world position of a position index round the target's ground point.
func position_of(index: int, target_pos: Vector3) -> Vector3:
	var a := base_angle if not is_nan(base_angle) else 0.0
	var r := radius
	var n := inner_capacity
	var k := index
	if not is_inner(index):
		r = outer_radius
		n = outer_capacity
		k = index - inner_capacity
	var ang := a + TAU * float(k) / float(n)
	return Vector3(target_pos.x + sin(ang) * r, 0.0, target_pos.z + cos(ang) * r)

## The member's position index, claiming one if it holds none: the free attack
## position nearest the member, else the free waiting position nearest it. An
## exact tie between two positions goes to the lower index. `walkable`, when
## given, refuses a position inside a wall (a Callable taking a Vector3); a
## position is only ever skipped for that reason.
func claim(member_id: String, member_pos: Vector3, target_pos: Vector3, walkable: Callable = Callable()) -> int:
	if claims.has(member_id):
		return int(claims[member_id])
	if claims.is_empty():
		var d := Vector2(member_pos.x - target_pos.x, member_pos.z - target_pos.z)
		base_angle = atan2(d.x, d.y) if d.length() > 0.0001 else 0.0
	var taken := {}
	for m in claims.keys():
		taken[int(claims[m])] = true
	var best := _nearest_free(0, inner_capacity, taken, member_pos, target_pos, walkable)
	if best < 0:
		best = _nearest_free(inner_capacity, inner_capacity + outer_capacity, taken, member_pos, target_pos, walkable)
	if best < 0:
		best = _nearest_free(0, inner_capacity + outer_capacity, taken, member_pos, target_pos, Callable())
	if best < 0:
		best = inner_capacity + outer_capacity + claims.size()
	claims[member_id] = best
	return best

func _nearest_free(from_i: int, to_i: int, taken: Dictionary, member_pos: Vector3, target_pos: Vector3,
		walkable: Callable) -> int:
	var best := -1
	var best_d := INF
	for i in range(from_i, to_i):
		if taken.has(i):
			continue
		var p := position_of(i, target_pos)
		if walkable.is_valid() and not bool(walkable.call(p)):
			continue
		var d := CohortFormation.planar(member_pos, p)
		if d < best_d:
			best = i
			best_d = d
	return best

## Releases a member's claim. If it freed an ATTACK position, the nearest waiter
## takes it -- an exact tie to the lower combat-entity ID. `positions` maps member
## ID -> ground point; `precedes` is the area registry's ordering.
func release(member_id: String, positions: Dictionary, target_pos: Vector3, precedes: Callable) -> String:
	if not claims.has(member_id):
		return ""
	var freed := int(claims[member_id])
	claims.erase(member_id)
	if claims.is_empty():
		base_angle = NAN
		return ""
	if not is_inner(freed):
		return ""
	var spot := position_of(freed, target_pos)
	var best := ""
	var best_d := INF
	var tied := false
	for m in claims.keys():
		if is_inner(int(claims[m])) or not positions.has(m):
			continue
		var d := CohortFormation.planar(positions[m], spot)
		if best == "" or d < best_d:
			best = String(m)
			best_d = d
			tied = false
		elif d == best_d:
			tied = true
			if bool(precedes.call(String(m), best)):
				best = String(m)
	if best != "":
		claims[best] = freed
		promotions += 1
		if tied:
			ties_resolved += 1
	return best

func holders() -> int:
	return claims.size()
