class_name PassiveNodeData
extends Resource
## First-MVP — Gate 1E: one allocatable node of the shared Passive Web (D-219).
##
## THIS IS THE WHOLE WEB'S NODE SHAPE, NOT AN ORIGIN-RING-ONLY SHAPE. Gate 1E
## implements only the nine Riftmarked Origin Ring nodes plus the free Origin,
## because that is the only part the character can currently reach and the only
## part the brief authorizes. But `design/PASSIVE_PROGRESSION.md` §16 defines a
## 66-node Web — 9 Origin, 9 attribute travel, 9 shared clusters of 5, and 3
## Keystones — and the whole point of expressing a node as DATA rather than as
## a button is that the remaining 57 are added as records, not as code.
##
## So the fields below deliberately include `kind` values Gate 1E never
## constructs (`ATTRIBUTE_TRAVEL`, `KEYSTONE`) and a `region` field whose only
## current value is `ORIGIN`. They are not speculative generality: they are the
## canonical vocabulary the design document already uses, and leaving them out
## would force the enum to change — and every saved allocation to be
## reinterpreted — the first time a travel node exists.
##
## WHAT A NODE DOES NOT CARRY, AND WHY.
##
##   * No position. The Origin Ring's LAYOUT is a presentation decision that
##     belongs to the interface, and the canonical Web is a graph rather than a
##     picture. `OriginRingPanel` derives its own arc/tier arrangement from
##     `arc` and `tier`; a later full-Web view can lay the same records out
##     completely differently without touching this file.
##   * No numeric effect table. Every Origin Ring effect but one is written in
##     terms of Rift Shards or Rift Echo, which do not exist yet — see
##     `PassiveEffects` for the one live effect and the honest reason the other
##     eight are inert. A numeric table here would be eight fabricated numbers
##     nothing reads.
##   * No allocation state. Which nodes a character has taken belongs to the
##     CHARACTER (`CharacterState.allocated_passives`), not to the shared graph
##     — two characters share this record and must not share an allocation.
##
## The `effect_text` strings are quoted VERBATIM from
## `design/PASSIVE_PROGRESSION.md` §15 and the verification asserts that
## character for character, so a paraphrase in the interface cannot drift away
## from the canonical wording.

enum Kind {
	## The free class entry. Costs no point and is allocated from the start.
	ORIGIN,
	## An ordinary Small Passive.
	SMALL,
	## An arc's single meaningful Notable.
	NOTABLE,
	## Declared for the 9 canonical attribute-travel nodes. Gate 1E builds none.
	ATTRIBUTE_TRAVEL,
	## Declared for the 3 canonical Keystones. Gate 1E builds none.
	KEYSTONE,
}

enum Arc {
	## Not part of a Riftmarked arc (the Origin itself, and everything outside
	## the Origin Ring).
	NONE,
	GENERATE,
	HOLD,
	SHAPE,
}

enum Region {
	ORIGIN,
	## Declared for the canonical Might / Finesse / Will regions. Gate 1E
	## builds none of them.
	MIGHT,
	FINESSE,
	WILL,
}

@export_group("Identity")
## Stable save key. It is written into the character save and must never be
## reused for a different node, because a save from an older build would then
## silently allocate the wrong passive.
@export var node_id: StringName = &""
@export var display_name: String = ""
@export var kind: Kind = Kind.SMALL
@export var arc: Arc = Arc.NONE
@export var region: Region = Region.ORIGIN
## Position within its arc, 1-based. The canonical §15 ordering is
## Small 1 -> Small 2 -> Notable, and the interface reads this rather than the
## order records happen to appear in an array.
@export var tier: int = 1

@export_group("Canonical effect")
## Quoted verbatim from design/PASSIVE_PROGRESSION.md §15.
@export var effect_text: String = ""
## The mechanical systems this effect depends on. When any of them is not yet
## implemented the interface must say so plainly rather than implying the point
## did something. See PassiveEffects.INACTIVE_SYSTEMS.
@export var depends_on: PackedStringArray = PackedStringArray()

@export_group("Graph")
## Node ids this node connects to. Edges are undirected and are asserted
## SYMMETRIC by PassiveGraph — a one-way edge would make "legal next" and
## "still connected after a refund" disagree with each other.
@export var connections: PackedStringArray = PackedStringArray()

@export_group("Cost")
## Every allocatable node costs exactly one ordinary Passive point
## (design/PASSIVE_PROGRESSION.md §3: "Origin Ring nodes use ordinary passive
## points and therefore retain opportunity cost"). The Origin costs zero.
@export var point_cost: int = 1


func is_free() -> bool:
	return kind == Kind.ORIGIN


func arc_name() -> String:
	match arc:
		Arc.GENERATE:
			return "Generate"
		Arc.HOLD:
			return "Hold"
		Arc.SHAPE:
			return "Shape"
		_:
			return "Origin"


func kind_name() -> String:
	match kind:
		Kind.ORIGIN:
			return "Origin"
		Kind.NOTABLE:
			return "Notable"
		Kind.ATTRIBUTE_TRAVEL:
			return "Travel"
		Kind.KEYSTONE:
			return "Keystone"
		_:
			return "Passive"


## Returns "" when the record is coherent, or the first problem found. The graph
## refuses to build if any record answers non-empty, so a bad edit fails loudly
## rather than producing a Web with an unreachable node in it.
func problem() -> String:
	if String(node_id).strip_edges().is_empty():
		return "node_id must not be empty"
	if display_name.strip_edges().is_empty():
		return "%s: display_name must not be empty" % node_id
	if effect_text.strip_edges().is_empty() and kind != Kind.ORIGIN:
		return "%s: effect_text must not be empty" % node_id
	if tier < 1:
		return "%s: tier must be 1 or greater" % node_id
	if kind == Kind.ORIGIN and point_cost != 0:
		return "%s: the class Origin is free and must cost 0 points" % node_id
	if kind != Kind.ORIGIN and point_cost != 1:
		return "%s: an allocatable node costs exactly one ordinary Passive point" % node_id
	if connections.is_empty():
		return "%s: a node with no connections can never be allocated" % node_id
	if String(node_id) in connections:
		return "%s: a node cannot connect to itself" % node_id
	return ""


func describe() -> String:
	return "%s (%s %s, tier %d) — %s" % [
		display_name, arc_name(), kind_name().to_lower(), tier, effect_text,
	]
