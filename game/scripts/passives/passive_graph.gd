class_name PassiveGraph
extends RefCounted
## First-MVP — Gate 1E: the shared Passive Web graph (D-219).
##
## Gate 1E builds exactly the free Riftmarked Origin plus the nine Origin Ring
## nodes of `design/PASSIVE_PROGRESSION.md` §15, and nothing else. That is a
## deliberate scope boundary, not an architectural one: this class is a general
## graph over `PassiveNodeData` records, and the remaining 57 canonical nodes
## (9 attribute travel, 9 clusters of 5, 3 Keystones) become records rather
## than code.
##
## The brief's own words: "The Origin Ring should be architected as data/graph-
## based production functionality capable of expanding into the full Web later.
## Do not hard-code a one-off nine-button menu that must be thrown away."
##
## CANONICAL TOPOLOGY, §15 read exactly as written:
##
##   "The class Origin itself is free. Each of the three arcs contains two
##    Small Passives and one optional Notable. The second Small Passive opens
##    the route toward its associated attribute region. The Notable branches
##    beside that route."
##
## So each arc is a chain Origin -> Small 1 -> Small 2, with the Notable
## branching off Small 2 rather than continuing it, and Small 2 also being the
## node a later attribute-travel record would attach to:
##
##   Riftmarked Origin ──┬── First Fracture ─── Rift Rhythm ──┬── Fractured Cadence
##                       │                                     └── (Finesse travel, later)
##                       ├── Orbiting Guard ─── Quiet Reservoir ┬── Shardbound Aegis
##                       │                                      └── (Might travel, later)
##                       └── Hastened Echo ─── Refined Reflection ┬── Resonant Shape
##                                                                └── (Will travel, later)
##
## The arc-to-region pairing follows §16's own cluster map, where the Hold arc
## routes toward Might, Generate toward Finesse, and Shape toward Will. Gate 1E
## records that pairing on the nodes and builds none of those travel nodes.
##
## EDGES ARE UNDIRECTED AND PROVED SYMMETRIC. `_index()` refuses to finish if A
## lists B without B listing A. A one-way edge is exactly the defect that makes
## "which nodes may I take next" and "is this node still connected after a
## refund" quietly disagree, and it is invisible until a player refunds
## something.

const ORIGIN_ID: StringName = &"riftmarked_origin"

var nodes: Array[PassiveNodeData] = []
var problems: PackedStringArray = PackedStringArray()

var _by_id: Dictionary = {}


func _init(records: Array[PassiveNodeData] = []) -> void:
	if records.is_empty():
		records = PassiveGraph.origin_ring_records()
	nodes = records
	_index()


# --- Canonical content ---------------------------------------------------------

## The ten Gate 1E records, built in code rather than as ten `.tres` files.
##
## That is a deliberate choice and worth stating: this project's convention is
## that authored TUNING lives in `.tres` (weapon damage, Skill timing) while a
## canonical STRUCTURE that the design document fixes lives in a typed script
## the verification can read directly — exactly as `approved_environment_palette.gd`
## holds the D-215 palette and `exterior_asset_catalogue.gd` holds the Gate 1B
## catalogue. The nine effect strings here are quoted from §15 and are asserted
## character for character; a `.tres` would put the same canonical strings one
## indirection further from the document they must match.
static func origin_ring_records() -> Array[PassiveNodeData]:
	var built: Array[PassiveNodeData] = []
	built.append(_record(
		ORIGIN_ID, "Riftmarked Origin", PassiveNodeData.Kind.ORIGIN, PassiveNodeData.Arc.NONE,
		PassiveNodeData.Region.ORIGIN, 0,
		"The class entry. It is free, and the base Rift Shard mechanic functions without passive investment.",
		PackedStringArray(),
		PackedStringArray(["first_fracture", "orbiting_guard", "hastened_echo"]), 0
	))

	# --- Generate arc, routing toward Finesse ---------------------------------
	built.append(_record(
		&"first_fracture", "First Fracture", PassiveNodeData.Kind.SMALL, PassiveNodeData.Arc.GENERATE,
		PassiveNodeData.Region.FINESSE, 1,
		"10% increased Attack and Cast Speed while holding no Rift Shards",
		PackedStringArray(),
		PackedStringArray([String(ORIGIN_ID), "rift_rhythm"]), 1
	))
	built.append(_record(
		&"rift_rhythm", "Rift Rhythm", PassiveNodeData.Kind.SMALL, PassiveNodeData.Arc.GENERATE,
		PassiveNodeData.Region.FINESSE, 2,
		"15% increased Rift Shard Generation Rate",
		PackedStringArray(["rift_shards"]),
		PackedStringArray(["first_fracture", "fractured_cadence"]), 1
	))
	built.append(_record(
		&"fractured_cadence", "Fractured Cadence", PassiveNodeData.Kind.NOTABLE, PassiveNodeData.Arc.GENERATE,
		PassiveNodeData.Region.FINESSE, 3,
		"Every third qualifying direct Skill Use ignores the remaining generation interval; the use still generates at most one Shard",
		PackedStringArray(["rift_shards"]),
		PackedStringArray(["rift_rhythm"]), 1
	))

	# --- Hold arc, routing toward Might ---------------------------------------
	built.append(_record(
		&"orbiting_guard", "Orbiting Guard", PassiveNodeData.Kind.SMALL, PassiveNodeData.Arc.HOLD,
		PassiveNodeData.Region.MIGHT, 1,
		"3% increased Armor and Evasion per held Rift Shard",
		PackedStringArray(["rift_shards"]),
		PackedStringArray([String(ORIGIN_ID), "quiet_reservoir"]), 1
	))
	built.append(_record(
		&"quiet_reservoir", "Quiet Reservoir", PassiveNodeData.Kind.SMALL, PassiveNodeData.Arc.HOLD,
		PassiveNodeData.Region.MIGHT, 2,
		"4% increased Mana Regeneration per held Rift Shard",
		PackedStringArray(["rift_shards"]),
		PackedStringArray(["orbiting_guard", "shardbound_aegis"]), 1
	))
	built.append(_record(
		&"shardbound_aegis", "Shardbound Aegis", PassiveNodeData.Kind.NOTABLE, PassiveNodeData.Arc.HOLD,
		PassiveNodeData.Region.MIGHT, 3,
		"+1 maximum Rift Shard; 5% less Damage Taken while at maximum Shards",
		PackedStringArray(["rift_shards"]),
		PackedStringArray(["quiet_reservoir"]), 1
	))

	# --- Shape arc, routing toward Will ---------------------------------------
	built.append(_record(
		&"hastened_echo", "Hastened Echo", PassiveNodeData.Kind.SMALL, PassiveNodeData.Arc.SHAPE,
		PassiveNodeData.Region.WILL, 1,
		"15% reduced Rift Echo delay",
		PackedStringArray(["rift_echo"]),
		PackedStringArray([String(ORIGIN_ID), "refined_reflection"]), 1
	))
	built.append(_record(
		&"refined_reflection", "Refined Reflection", PassiveNodeData.Kind.SMALL, PassiveNodeData.Arc.SHAPE,
		PassiveNodeData.Region.WILL, 2,
		"15% increased Rift Echo Effectiveness",
		PackedStringArray(["rift_echo"]),
		PackedStringArray(["hastened_echo", "resonant_shape"]), 1
	))
	built.append(_record(
		&"resonant_shape", "Resonant Shape", PassiveNodeData.Kind.NOTABLE, PassiveNodeData.Arc.SHAPE,
		PassiveNodeData.Region.WILL, 3,
		"20% more Rift Echo Effectiveness; the Shaped Skill costs 10% more when it consumes Shards",
		PackedStringArray(["rift_echo", "shaping"]),
		PackedStringArray(["refined_reflection"]), 1
	))
	return built


static func _record(
	id: StringName, display: String, kind: PassiveNodeData.Kind, arc: PassiveNodeData.Arc,
	region: PassiveNodeData.Region, tier: int, effect: String,
	depends: PackedStringArray, connections: PackedStringArray, cost: int
) -> PassiveNodeData:
	var record: PassiveNodeData = PassiveNodeData.new()
	record.node_id = id
	record.display_name = display
	record.kind = kind
	record.arc = arc
	record.region = region
	record.tier = maxi(tier, 1)
	record.effect_text = effect
	record.depends_on = depends
	record.connections = connections
	record.point_cost = cost
	return record


# --- Indexing and integrity ----------------------------------------------------

func _index() -> void:
	_by_id.clear()
	problems.clear()
	for record: PassiveNodeData in nodes:
		var problem: String = record.problem()
		if not problem.is_empty():
			problems.append(problem)
			continue
		if _by_id.has(record.node_id):
			problems.append("duplicate node_id %s" % record.node_id)
			continue
		_by_id[record.node_id] = record
	if not _by_id.has(ORIGIN_ID):
		problems.append("the graph has no free class Origin (%s)" % ORIGIN_ID)
	for record: PassiveNodeData in nodes:
		for other_id: String in record.connections:
			if not _by_id.has(StringName(other_id)):
				problems.append("%s connects to unknown node %s" % [record.node_id, other_id])
				continue
			var other: PassiveNodeData = _by_id[StringName(other_id)]
			if not (String(record.node_id) in other.connections):
				problems.append("edge %s -> %s is not symmetric" % [record.node_id, other_id])
	# A node the Origin cannot reach can never be allocated, which is a graph
	# defect rather than a design choice. Measured by traversal, not assumed
	# from the way the records happen to be written above.
	if _by_id.has(ORIGIN_ID):
		var reached: Dictionary = {}
		var frontier: Array[StringName] = [ORIGIN_ID]
		while not frontier.is_empty():
			var current: StringName = frontier.pop_back()
			if reached.has(current):
				continue
			reached[current] = true
			var record: PassiveNodeData = _by_id.get(current, null)
			if record == null:
				continue
			for other_id: String in record.connections:
				frontier.append(StringName(other_id))
		for record: PassiveNodeData in nodes:
			if not reached.has(record.node_id):
				problems.append("%s is unreachable from the Origin" % record.node_id)


func is_coherent() -> bool:
	return problems.is_empty()


# --- Queries -------------------------------------------------------------------

func has(node_id: StringName) -> bool:
	return _by_id.has(node_id)


func node(node_id: StringName) -> PassiveNodeData:
	return _by_id.get(node_id, null)


func origin() -> PassiveNodeData:
	return _by_id.get(ORIGIN_ID, null)


func node_ids() -> Array[StringName]:
	var ids: Array[StringName] = []
	for record: PassiveNodeData in nodes:
		ids.append(record.node_id)
	return ids


func neighbours(node_id: StringName) -> Array[StringName]:
	var found: Array[StringName] = []
	var record: PassiveNodeData = node(node_id)
	if record == null:
		return found
	for other_id: String in record.connections:
		found.append(StringName(other_id))
	return found


## Every node of one arc, in canonical tier order. The interface draws its three
## directions from this rather than from the record order.
func arc_nodes(arc: PassiveNodeData.Arc) -> Array[PassiveNodeData]:
	var found: Array[PassiveNodeData] = []
	for record: PassiveNodeData in nodes:
		if record.arc == arc:
			found.append(record)
	found.sort_custom(func(a: PassiveNodeData, b: PassiveNodeData) -> bool: return a.tier < b.tier)
	return found


func allocatable_count() -> int:
	var total: int = 0
	for record: PassiveNodeData in nodes:
		if not record.is_free():
			total += 1
	return total


func describe() -> String:
	return "%d node(s): 1 free Origin + %d allocatable across %d arc(s)%s" % [
		nodes.size(), allocatable_count(), 3,
		"" if is_coherent() else "; %d PROBLEM(S)" % problems.size(),
	]
