class_name PassiveEffects
extends RefCounted
## First-MVP — Gate 1E: what an allocated Passive actually DOES right now (D-219).
##
## THE HONESTY CONDITION THE BRIEF ASKS FOR, AND THE MEASUREMENT BEHIND IT.
##
## The brief: "Several Origin nodes affect Rift Shards/Rift Echo, which are
## intentionally not active yet. If such a node currently has no gameplay
## effect because Shards/Echo are not unlocked, the UI must say that clearly.
## Do not secretly activate Rift Shards early just to make those Passives
## useful."
##
## Read against the canonical §15 effects, that is not a matter of taste — it
## is decidable, node by node, and it comes out **1 live of 9**:
##
##   First Fracture       "10% increased Attack and Cast Speed WHILE HOLDING
##                         NO RIFT SHARDS"                              LIVE
##   Rift Rhythm          increased Rift Shard Generation Rate          inert
##   Fractured Cadence    ignores the Shard generation interval         inert
##   Orbiting Guard       Armor/Evasion PER HELD RIFT SHARD             inert
##   Quiet Reservoir      Mana Regeneration PER HELD RIFT SHARD         inert
##   Shardbound Aegis     +1 maximum Rift Shard                         inert
##   Hastened Echo        reduced Rift Echo delay                       inert
##   Refined Reflection   increased Rift Echo Effectiveness             inert
##   Resonant Shape       more Rift Echo Effectiveness                  inert
##
## First Fracture is live for exactly the reason the others are not: its
## condition is "while holding no Rift Shards", and a character in a build with
## no Rift Shard system holds none. It is satisfied BY the absence, not in
## spite of it. Granting it is therefore the honest reading of the canonical
## text, and refusing it would be its own small lie.
##
## The eight inert nodes are allocated, saved, refunded, and displayed exactly
## like the live one. They simply say what is true: their system is not
## available yet. The player may plan ahead; nothing pretends.
##
## WHERE THE LIVE EFFECT LANDS. `increased_attack_and_cast_speed` is handed to
## `QuickStrikeAction.increased_attack_speed` — the SAME single field Gate E's
## Quickened Form used and the same one `PrototypeWeaponData.effective_action_time()`
## divides by, so there is still exactly one place in the project where
## "increased attack speed" becomes a time (Prototype Zero specification §12.2).
## Nothing new was added to the kernel to make this work.

## Systems the first MVP has not implemented yet. A node whose `depends_on`
## names any of these cannot have a live effect, and the interface says so in
## these words.
const INACTIVE_SYSTEMS: Dictionary = {
	"rift_shards": "Rift Shards are not available yet",
	"rift_echo": "Rift Echo is not available yet",
	"shaping": "Skill Shaping is not available yet",
}

const FIRST_FRACTURE_INCREASE: float = 0.10

## Summed increased Attack and Cast Speed from allocated passives, as a
## fraction (0.10 = 10% increased). Gate 1E's only live contribution.
var increased_attack_and_cast_speed: float = 0.0
## Node ids that contributed nothing because their system does not exist.
var inert_nodes: PackedStringArray = PackedStringArray()
## Node ids that contributed a real, measurable effect.
var live_nodes: PackedStringArray = PackedStringArray()
## Node ids whose systems all exist but which this class has no implementation
## for. It must always be EMPTY, and the verification asserts that — see the note
## in `recompute()` for why this is a recorded array rather than an assert.
var unimplemented_live_nodes: PackedStringArray = PackedStringArray()


## Recomputes from scratch every time. There is deliberately no incremental
## "apply one node" path: D-191's lesson in this project was that a value
## scaled in place compounds silently, and the fix was always to recompute from
## the authored baseline. Allocation and refund therefore both call this.
func recompute(graph: PassiveGraph, allocated: Array[StringName]) -> void:
	increased_attack_and_cast_speed = 0.0
	inert_nodes = PackedStringArray()
	live_nodes = PackedStringArray()
	unimplemented_live_nodes = PackedStringArray()
	for node_id: StringName in allocated:
		var record: PassiveNodeData = graph.node(node_id)
		if record == null or record.is_free():
			continue
		if not PassiveEffects.is_live(record):
			inert_nodes.append(String(node_id))
			continue
		match node_id:
			&"first_fracture":
				# "while holding no Rift Shards" — with no Shard system the
				# character holds none, so the condition is satisfied.
				increased_attack_and_cast_speed += FIRST_FRACTURE_INCREASE
				live_nodes.append(String(node_id))
			_:
				# A NODE CLASSIFIED LIVE WITH NO IMPLEMENTATION IS A DEFECT, AND
				# THIS IS DELIBERATELY NOT AN `assert`. `assert()` is STRIPPED IN
				# RELEASE BUILDS — the same reason `FirstMvpSkillAction` backs its
				# double-release guard with a real boolean rather than an assert —
				# so an assert here would crash in the editor and, in a shipped
				# build, silently show the player an "Active now" effect that does
				# nothing at all. That is the worse of the two failures.
				#
				# So it is RECORDED instead: the node is counted as inert (which
				# is what it actually is), `push_error` reports it in every build,
				# and the array below is a fact a check can assert on. It must
				# always be empty.
				unimplemented_live_nodes.append(String(node_id))
				inert_nodes.append(String(node_id))
				push_error("PassiveEffects: %s is classified live but has no implementation" % node_id)


## True when every system this node's effect depends on exists.
static func is_live(record: PassiveNodeData) -> bool:
	for system: String in record.depends_on:
		if INACTIVE_SYSTEMS.has(system):
			return false
	return true


## The plain-language line the interface shows under an inert node's canonical
## effect text. Returns "" for a live node.
static func inactive_reason(record: PassiveNodeData) -> String:
	var reasons: PackedStringArray = PackedStringArray()
	for system: String in record.depends_on:
		if INACTIVE_SYSTEMS.has(system):
			var reason: String = String(INACTIVE_SYSTEMS[system])
			if not (reason in reasons):
				reasons.append(reason)
	if reasons.is_empty():
		return ""
	return "No effect yet — %s. You may still allocate it and plan ahead." % " and ".join(reasons)


## The plain-language line the interface shows under a LIVE node, stating the
## measurable consequence rather than repeating the canonical text.
static func active_reason(record: PassiveNodeData) -> String:
	match record.node_id:
		&"first_fracture":
			return "Active now — you hold no Rift Shards, so this applies to every Skill."
		_:
			return "Active now."


func describe() -> String:
	return "+%.0f%% Attack and Cast Speed; %d live node(s), %d awaiting their system%s" % [
		increased_attack_and_cast_speed * 100.0, live_nodes.size(), inert_nodes.size(),
		"" if unimplemented_live_nodes.is_empty()
			else "; %d UNIMPLEMENTED" % unimplemented_live_nodes.size(),
	]
