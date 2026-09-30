class_name AttackCoordinator
extends Node
## Prototype Zero — Gate D attack-permission boundary (specification §14.3),
## corrected for group cadence under D-186.
##
## "The AttackCoordinator permits only one Graveblade to begin wind-up at a time
##  during the first group test and enforces a minimum 0.25-second gap between
##  enemy release starts. This is a P0 readability tool, not the future complete
##  pack coordinator."
##
## Gate D contained exactly one Graveblade, so nothing here was load-bearing.
## It existed anyway because D-181 asks for the BOUNDARY: the enemy must ask
## before it commits, and the answer must be able to be no. Building it then
## meant the rule was proven with one enemy, where it can be read, rather than
## discovered with three.
##
## Gate E made it load-bearing, and the project owner's playtest found what one
## enemy could not show. A lone Graveblade finishes its 1.25-second action and
## owes 0.35 seconds before it may commit again, so its wind-ups and releases sit
## about 1.60 seconds apart. In a group that interval was owed by the ATTACKER
## and by nobody else, so a waiting Graveblade inherited the slot the instant the
## previous holder's recovery ended and the group's releases fell to about 1.25
## seconds apart. The group was not merely adding bodies; it was bypassing the
## breathing window the single-enemy fight was accepted with.
##
## D-186 closes that by moving the same 0.35 seconds onto the SLOT. After a
## holder finishes an attack action — or dies still holding it — no wind-up is
## granted to anyone until the window expires. It runs CONCURRENTLY with the
## attacker's own interval rather than after it, so:
##
##   * one Graveblade is completely unaffected: its own 0.35-second interval and
##     this 0.35-second window start on the same frame and end on the same frame,
##     so it asks at exactly the moment it always did;
##   * a different Graveblade can no longer make the group faster than the
##     accepted one-enemy rhythm, moving different-attacker release starts from
##     about 1.25 s to 0.70 + 0.35 + 0.55 = about 1.60 s.
##
## The 0.25-second release gap is UNCHANGED and stays as the lower safety bound
## underneath it. It cannot bind in ordinary play — the single slot alone is
## already stricter — and the handoff is now stricter still, which is exactly why
## the gap is a floor rather than the rhythm rule.
##
## It is not an event bus and not a scheduler. It owns one permission slot and
## one clock, and it never moves, damages, or animates anything.
##
## THE CLOCK IS SIMULATION TIME, NOT WALL-CLOCK TIME. Both windows are counted
## down in `_physics_process`, so a paused world — every Gate E modal sets
## `get_tree().paused` — cannot spend a breathing window the player never played
## through. That also makes both windows measurable in frames rather than in
## whatever the host machine happened to do while the game was stopped.

## Why a permission holder gave the slot back. The coordinator decides whether a
## release starts the group handoff from THIS value and never from the
## human-readable reason string, which exists for logs and instrumentation only.
enum ReleaseCause {
	## The holder's attack action ended normally, recovery included. D-186: this
	## is the moment the group owes its breathing window.
	ACTION_COMPLETED,
	## The holder died while still holding the slot. Its action is over as
	## finally as it can be, so the group owes the same window: without this a
	## killed attacker would hand the next Graveblade a free, immediate strike.
	ATTACKER_DIED,
	## The holder gave the slot back without completing an attack — it walked out
	## of range before committing. Nothing was spent, so nothing is owed.
	WITHDRAWN,
	## Teardown, removal, or a debug reset. Not a fight event at all, and D-186
	## explicitly does not start the window for these.
	ADMINISTRATIVE,
}

## Only one attacker may hold permission at a time. The single `owner_node` slot
## below IS that enforcement; this is here so the number is inspectable and so a
## later gate that wants two has one obvious place to start.
@export var simultaneous_attackers: int = 1
## Specification §14.3: a minimum gap between the release commitments of
## DIFFERENT attackers, so a group cannot land two strikes on the same frame.
## Unchanged by D-186, which keeps it as the lower safety bound.
@export var minimum_release_gap: float = 0.25
## D-186: the group breathing window after any holder's attack action ends. It is
## deliberately the SAME 0.35 seconds the Graveblade already owes itself
## (`GravebladeData.minimum_commitment_interval`), because the accepted
## single-enemy rhythm is exactly what the group is being held to.
@export var group_handoff_delay: float = 0.35

var owner_node: Node = null
var granted_at_sim: float = 0.0
var last_release_started_sim: float = -100000.0

# --- Instrumentation (specification §22) -------------------------------------
var requests: int = 0
var grants: int = 0
var refusals: int = 0
var releases: int = 0
var handoffs_started: int = 0
var handoff_refusals: int = 0
var last_decision: String = "none"
var last_handoff_source: String = "none"

var _simulation_time: float = 0.0
var _group_handoff_remaining: float = 0.0
var _log: Callable = Callable()

signal permission_granted(to: Node)
signal permission_released(from: Node, reason: String)


## The room hands its structured encounter log in, so the group handoff appears
## in the trace rather than only in a live panel. Optional: the coordinator works
## without one, which is what lets a pure check construct it in isolation.
func set_log_sink(sink: Callable) -> void:
	_log = sink


func _physics_process(delta: float) -> void:
	_simulation_time += delta
	if _group_handoff_remaining <= 0.0:
		return
	# Counted down with EXACTLY the arithmetic the Graveblade uses for its own
	# `_commitment_cooldown`, from exactly the same starting value, on the same
	# physics tick. Two windows that must expire together are kept together by
	# doing the identical thing to both, not by comparing two accumulated clocks
	# that would drift apart in the last significant digit.
	_group_handoff_remaining = maxf(_group_handoff_remaining - delta, 0.0)
	if _group_handoff_remaining <= 0.0:
		_emit("group handoff expired", "%.2f s after %s; a wind-up may be granted again" % [
			group_handoff_delay, last_handoff_source,
		])


## Ask to begin an attack commitment. Returns true when the caller now holds the
## permission slot; the caller MUST release it when its action ends or it dies.
func request(requester: Node) -> bool:
	assert(simultaneous_attackers == 1,
		"AttackCoordinator: Prototype Zero permits exactly one simultaneous attacker")
	requests += 1
	if requester == null:
		return _refuse("a null requester")
	if owner_node == requester:
		# Already holding it. Re-asking is not an error and is not a new grant.
		last_decision = "%s already holds permission" % requester.name
		return true
	if owner_node != null:
		return _refuse("%s already holds permission" % owner_node.name)
	# D-186, checked before the release gap because it is the longer window and
	# the one a player can feel. Whichever is reported, both must be clear.
	if _group_handoff_remaining > 0.0:
		handoff_refusals += 1
		return _refuse("%.3f s of the %.2f s group handoff after %s remain" % [
			_group_handoff_remaining, group_handoff_delay, last_handoff_source,
		])
	var since_release: float = _simulation_time - last_release_started_sim
	if since_release < minimum_release_gap:
		return _refuse("only %.3f s since the last release start, gap is %.2f s" % [
			since_release, minimum_release_gap,
		])

	owner_node = requester
	granted_at_sim = _simulation_time
	grants += 1
	last_decision = "granted to %s" % requester.name
	permission_granted.emit(requester)
	return true


## Called by the holder when its release actually begins, so the gap between
## different attackers' releases can be enforced.
func note_release_started(from: Node) -> void:
	if owner_node != from:
		return
	releases += 1
	last_release_started_sim = _simulation_time


## Give the slot back, saying WHY in a value the coordinator can act on. Safe to
## call when not holding it, which is what lets death and reset paths call it
## unconditionally — and an irrelevant non-holder starts no window, because this
## returns before the cause is ever consulted.
func release(from: Node, cause: ReleaseCause, reason: String = "") -> void:
	if owner_node != from or from == null:
		return
	owner_node = null
	var described: String = reason if not reason.is_empty() else cause_name(cause)
	last_decision = "%s released permission (%s)" % [from.name, described]
	if cause_starts_group_handoff(cause):
		_start_group_handoff("%s (%s)" % [from.name, described])
	permission_released.emit(from, described)


## Hard clear, for player death and the debug encounter reset. It never STARTS a
## group handoff — nothing was fought to a finish — and it clears a running one,
## because the encounter it belonged to is being taken apart.
func revoke_all(reason: String) -> void:
	_clear_group_handoff("revoked: %s" % reason)
	if owner_node != null:
		var previous: Node = owner_node
		owner_node = null
		last_decision = "revoked from %s (%s)" % [previous.name, reason]
		permission_released.emit(previous, reason)
	else:
		last_decision = "revoked, nobody held it (%s)" % reason


func holder() -> Node:
	return owner_node


func holds_permission(who: Node) -> bool:
	return owner_node != null and owner_node == who


## D-186: seconds of the group breathing window still owed. Zero when a wind-up
## may be granted. Read by the F3 instrumentation and by the checks.
func group_handoff_remaining() -> float:
	return maxf(_group_handoff_remaining, 0.0)


func group_handoff_active() -> bool:
	return _group_handoff_remaining > 0.0


## Simulation seconds since this coordinator entered the tree. Monotonic, and
## deliberately NOT rewound by `reset()`: it timestamps events, so a check that
## measures a cadence across a reset still measures a cadence.
func simulation_time() -> float:
	return _simulation_time


## Whether a release for this reason owes the group its breathing window. Public
## so the checks can assert the mapping itself rather than infer it from
## behaviour, and so no caller has to encode the rule at its own call site.
static func cause_starts_group_handoff(cause: ReleaseCause) -> bool:
	return cause == ReleaseCause.ACTION_COMPLETED or cause == ReleaseCause.ATTACKER_DIED


static func cause_name(cause: ReleaseCause) -> String:
	match cause:
		ReleaseCause.ACTION_COMPLETED:
			return "action completed"
		ReleaseCause.ATTACKER_DIED:
			return "attacker died"
		ReleaseCause.WITHDRAWN:
			return "withdrawn"
		ReleaseCause.ADMINISTRATIVE:
			return "administrative"
		_:
			return "unknown"


func reset() -> void:
	_clear_group_handoff("coordinator reset")
	owner_node = null
	granted_at_sim = _simulation_time
	last_release_started_sim = _simulation_time - 100000.0
	requests = 0
	grants = 0
	refusals = 0
	releases = 0
	handoffs_started = 0
	handoff_refusals = 0
	last_handoff_source = "none"
	last_decision = "reset"


func _start_group_handoff(source: String) -> void:
	if group_handoff_delay <= 0.0:
		return
	_group_handoff_remaining = group_handoff_delay
	last_handoff_source = source
	handoffs_started += 1
	_emit("group handoff started", "%s; no Graveblade may begin a wind-up for %.2f s" % [
		source, group_handoff_delay,
	])


func _clear_group_handoff(reason: String) -> void:
	if _group_handoff_remaining <= 0.0:
		return
	var cleared: float = _group_handoff_remaining
	_group_handoff_remaining = 0.0
	_emit("group handoff cleared", "%.3f s of the window dropped — %s" % [cleared, reason])


func _refuse(reason: String) -> bool:
	refusals += 1
	last_decision = "refused: %s" % reason
	return false


func _emit(event: String, detail: String) -> void:
	if _log.is_valid():
		_log.call(event, detail)
