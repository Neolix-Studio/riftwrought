class_name PassiveAllocation
extends RefCounted
## First-MVP — Gate 1E: allocation, legality, preview, and free refund (D-219).
##
## This is the rules half of the Passive Web. `PassiveGraph` says what the Web
## IS; this says what one character has taken and what they may take next, and
## it is the only place a Passive point is ever spent or returned.
##
## THE FOUR RULES, ALL FROM `design/PASSIVE_PROGRESSION.md` AND THE GATE 1E BRIEF.
##
##   1. The class Origin is FREE and always allocated. It is placed by
##      `_init()` and can never be refunded, so the Web is never disconnected
##      from its own entry.
##   2. A node is legal-next when it is adjacent to something already allocated
##      and the character can pay for it. Gate 1E's brief says "permit any legal
##      first allocation", and with one point that is exactly the three arc
##      openings: First Fracture, Orbiting Guard, Hastened Echo.
##   3. Refunds are FREE in first-MVP safe states, and a refund must leave every
##      remaining allocation still connected to the Origin. Refunding a node
##      that something else hangs off is refused with a reason naming what
##      would be stranded — the canonical "Branch refunds preview every
##      disconnection ... before confirmation" rule, at the scale Gate 1E has.
##   4. POINTS ARE CONSERVED. `spent()` is always exactly the number of
##      allocated non-free nodes, and `available()` is `earned - spent()`. There
##      is no separate counter that could drift, because a second counter is
##      exactly how a refund loop mints points.
##
## PREVIEW BEFORE CONFIRM. `preview(node_id)` answers what one allocation would
## cost and produce WITHOUT changing anything, so the interface can show the
## consequence before the player commits. It is a pure function of the current
## state; calling it a thousand times changes nothing.
##
## NOT IN GATE 1E, deliberately, per the brief: no full 66-node Web, no
## Might/Finesse/Will clusters, no Keystones, no search, no Plan Mode, no bulk
## route allocation, no Build Lens, no advanced pathing. `shortest_legal_route()`
## below is NOT bulk allocation — it is a one-step legality answer that a later
## multi-step router replaces; it never allocates anything.

var graph: PassiveGraph
var effects: PassiveEffects = PassiveEffects.new()

## Points the character has EARNED (milestone + Level). Owned by CharacterState;
## mirrored here so legality can be answered without a back-reference.
var earned_points: int = 0

## Every allocated node id, including the free Origin, in allocation order.
var allocated: Array[StringName] = []

var refusals: int = 0
var last_refusal: String = "none"

signal allocated_node(node_id: StringName)
signal refunded_node(node_id: StringName)


func _init(passive_graph: PassiveGraph = null) -> void:
	graph = passive_graph if passive_graph != null else PassiveGraph.new()
	assert(graph.is_coherent(), "PassiveAllocation: the Passive graph is not coherent: %s" % ", ".join(graph.problems))
	allocated.append(PassiveGraph.ORIGIN_ID)
	effects.recompute(graph, allocated)


# --- Points --------------------------------------------------------------------

## Non-free nodes currently allocated. Derived, never stored.
func spent() -> int:
	var total: int = 0
	for node_id: StringName in allocated:
		var record: PassiveNodeData = graph.node(node_id)
		if record != null:
			total += record.point_cost
	return total


func available() -> int:
	return earned_points - spent()


func set_earned_points(value: int) -> void:
	earned_points = maxi(value, 0)


# --- Queries -------------------------------------------------------------------

func is_allocated(node_id: StringName) -> bool:
	return node_id in allocated


## Adjacent to something allocated, not itself allocated, and affordable.
func is_legal_next(node_id: StringName) -> bool:
	if is_allocated(node_id):
		return false
	var record: PassiveNodeData = graph.node(node_id)
	if record == null:
		return false
	if record.point_cost > available():
		return false
	return _is_adjacent_to_allocated(node_id)


## Adjacent and connected, but NOT affordable. The interface draws these
## differently from unreachable nodes, because "you cannot afford it yet" and
## "you cannot get there from here" are different answers to the player.
func is_adjacent_but_unaffordable(node_id: StringName) -> bool:
	if is_allocated(node_id):
		return false
	var record: PassiveNodeData = graph.node(node_id)
	if record == null:
		return false
	return _is_adjacent_to_allocated(node_id) and record.point_cost > available()


func legal_next() -> Array[StringName]:
	var found: Array[StringName] = []
	for node_id: StringName in graph.node_ids():
		if is_legal_next(node_id):
			found.append(node_id)
	return found


func _is_adjacent_to_allocated(node_id: StringName) -> bool:
	for neighbour: StringName in graph.neighbours(node_id):
		if is_allocated(neighbour):
			return true
	return false


# --- Preview -------------------------------------------------------------------

## Pure. Answers what allocating `node_id` would do, and changes nothing.
func preview(node_id: StringName) -> Dictionary:
	var record: PassiveNodeData = graph.node(node_id)
	if record == null:
		return {"legal": false, "reason": "unknown node", "cost": 0, "points_after": available()}
	if is_allocated(node_id):
		return {
			"legal": false, "reason": "already allocated", "cost": 0,
			"points_after": available(), "node": record,
		}
	if not _is_adjacent_to_allocated(node_id):
		return {
			"legal": false,
			"reason": "not connected to anything you have allocated yet",
			"cost": record.point_cost, "points_after": available(), "node": record,
		}
	if record.point_cost > available():
		return {
			"legal": false,
			"reason": "costs %d point(s); you have %d" % [record.point_cost, available()],
			"cost": record.point_cost, "points_after": available(), "node": record,
		}
	var live: bool = PassiveEffects.is_live(record)
	return {
		"legal": true,
		"reason": "%s — %s" % [record.effect_text, (
			PassiveEffects.active_reason(record) if live else PassiveEffects.inactive_reason(record)
		)],
		"cost": record.point_cost,
		"points_after": available() - record.point_cost,
		"node": record,
		"live": live,
	}


## Pure. Answers what refunding `node_id` would do, including exactly which
## other allocations it would strand.
func refund_preview(node_id: StringName) -> Dictionary:
	var record: PassiveNodeData = graph.node(node_id)
	if record == null:
		return {"legal": false, "reason": "unknown node", "refunded": 0}
	if not is_allocated(node_id):
		return {"legal": false, "reason": "not allocated", "refunded": 0, "node": record}
	if record.is_free():
		return {
			"legal": false, "reason": "the Riftmarked Origin is free and cannot be refunded",
			"refunded": 0, "node": record,
		}
	var stranded: Array[StringName] = _would_strand(node_id)
	if not stranded.is_empty():
		var names: PackedStringArray = PackedStringArray()
		for other: StringName in stranded:
			names.append(graph.node(other).display_name)
		return {
			"legal": false,
			"reason": "refunding it would disconnect %s" % " and ".join(names),
			"refunded": 0, "node": record, "stranded": stranded,
		}
	return {
		"legal": true,
		"reason": "returns %d point(s); respecialization is free in first-MVP safe states" % record.point_cost,
		"refunded": record.point_cost, "node": record, "stranded": stranded,
	}


## Which currently-allocated nodes would lose their route to the Origin if
## `node_id` were removed. Measured by traversal from the Origin over the
## remaining set, never inferred from tier or arc.
func _would_strand(node_id: StringName) -> Array[StringName]:
	var remaining: Dictionary = {}
	for other: StringName in allocated:
		if other != node_id:
			remaining[other] = true
	var reached: Dictionary = {}
	var frontier: Array[StringName] = [PassiveGraph.ORIGIN_ID]
	while not frontier.is_empty():
		var current: StringName = frontier.pop_back()
		if reached.has(current) or not remaining.has(current):
			continue
		reached[current] = true
		for neighbour: StringName in graph.neighbours(current):
			if remaining.has(neighbour) and not reached.has(neighbour):
				frontier.append(neighbour)
	var stranded: Array[StringName] = []
	for other: StringName in allocated:
		if other != node_id and not reached.has(other):
			stranded.append(other)
	return stranded


# --- Mutation ------------------------------------------------------------------

func allocate(node_id: StringName) -> bool:
	var check: Dictionary = preview(node_id)
	if not bool(check.get("legal", false)):
		return _refuse("%s: %s" % [node_id, check.get("reason", "refused")])
	allocated.append(node_id)
	effects.recompute(graph, allocated)
	allocated_node.emit(node_id)
	return true


func refund(node_id: StringName) -> bool:
	var check: Dictionary = refund_preview(node_id)
	if not bool(check.get("legal", false)):
		return _refuse("%s: %s" % [node_id, check.get("reason", "refused")])
	allocated.erase(node_id)
	effects.recompute(graph, allocated)
	refunded_node.emit(node_id)
	return true


## Returns every non-free allocation. Used by "Refund all" in a safe state and
## by `CharacterSave` when it reconstructs a saved allocation from scratch.
func refund_all() -> int:
	var returned: int = 0
	# Refund from the outside in, so no intermediate step is ever refused for
	# stranding something that is about to be refunded too.
	var ordered: Array[StringName] = allocated.duplicate()
	ordered.reverse()
	for node_id: StringName in ordered:
		var record: PassiveNodeData = graph.node(node_id)
		if record == null or record.is_free():
			continue
		if refund(node_id):
			returned += record.point_cost
	return returned


## Replaces the whole allocation with `wanted`, which must be a legal set
## reachable in some order. Used ONLY by save reconstruction — ordinary play
## goes through `allocate()` one node at a time. Returns "" on success, or the
## first problem, so a corrupted save is reported rather than half-applied.
func restore(wanted: Array[StringName]) -> String:
	refund_all()
	var pending: Array[StringName] = []
	for node_id: StringName in wanted:
		if node_id != PassiveGraph.ORIGIN_ID:
			pending.append(node_id)
	# Repeatedly take whatever is legal now. A set that is genuinely reachable
	# drains completely; anything left over was never reachable.
	var guard: int = pending.size() + 1
	while not pending.is_empty() and guard > 0:
		guard -= 1
		var progressed: bool = false
		for node_id: StringName in pending.duplicate():
			if allocate(node_id):
				pending.erase(node_id)
				progressed = true
		if not progressed:
			break
	if pending.is_empty():
		return ""
	var names: PackedStringArray = PackedStringArray()
	for node_id: StringName in pending:
		names.append(String(node_id))
	return "could not restore %s (unreachable, unaffordable, or unknown)" % ", ".join(names)


func _refuse(reason: String) -> bool:
	refusals += 1
	last_refusal = reason
	return false


func allocated_ids_without_origin() -> Array[StringName]:
	var found: Array[StringName] = []
	for node_id: StringName in allocated:
		if node_id != PassiveGraph.ORIGIN_ID:
			found.append(node_id)
	return found


func describe() -> String:
	return "%d point(s) earned, %d spent, %d available; allocated: %s" % [
		earned_points, spent(), available(),
		"Origin only" if allocated.size() <= 1 else ", ".join(
			Array(allocated_ids_without_origin()).map(func(id: StringName) -> String:
				return graph.node(id).display_name)
		),
	]
