class_name CombatEntityRegistry
extends RefCounted

## THE COMBAT-ENTITY REGISTRY OF ONE ACTIVE AREA (D-392).
##
## ============================================================================
## WHAT A COMBAT-ENTITY ID IS — THE OWNER'S CLARIFICATION, IMPLEMENTED LITERALLY.
## ============================================================================
## "A combat-entity ID is an opaque, immutable gameplay identifier, unique within
## the active area, assigned deterministically and never derived from engine
## iteration order, object name or memory identity. Its precise
## storage/serialization implementation is not canonized."
##
##   OPAQUE        -- callers compare IDs only through `precedes()`; nothing
##                    parses the display string, which is display only.
##   IMMUTABLE     -- an entity is registered ONCE; a second registration or a
##                    reassignment is REFUSED and counted.
##   UNIQUE        -- within this registry, which is ONE PER ACTIVE AREA; an ID
##                    is never reused, even after its entity is gone.
##   DETERMINISTIC -- the ordinal is this area's registration SEQUENCE, and
##                    registration happens in the EXPLICIT COMPOSITION ORDER
##                    (the composition root's own spawn loop, or a test's own
##                    calls) -- never inside an engine callback such as `_ready`.
##   NEVER from engine iteration order, an object name or memory identity --
##                    nothing here reads a node's name, its instance id or its
##                    position in a scene tree, and the D-392 suite scans this
##                    file's CODE for exactly that.
##
## ---------------------------------------------------------------------------
## STORAGE AND SERIALIZATION ARE NOT CANONIZED, AND THIS IS NOT A SAVE FORMAT.
## ---------------------------------------------------------------------------
## The string `CE-0001` exists so a HUD and a report can name an entity. It is
## not persisted, not parsed and not promised.
##
## ---------------------------------------------------------------------------
## CATEGORIES ARE DATA, NOT CONTENT.
## ---------------------------------------------------------------------------
## Only ORDINARY enemies exist in game3d/. Elites, bosses, hostile summons and
## allies are categories the eligibility rule must handle correctly, and the
## D-392 suite proves that with test-only stubs -- NO such content is added.
## `scenery` and `destructible` are REFUSED at registration: no such system exists
## here, and whether an arrow stops at a destructible is NOT decided.

var area_id: String = ""

## [{ "ordinal": int, "id": String, "node": Node, "category": String,
##    "faction": String }] -- in REGISTRATION order, which is composition order.
var _records: Array = []
## The node -> record index LOOKUP. A lookup is not a derivation: the ID was
## fixed at registration from the sequence, and this map never produces one.
var _index_of_node: Dictionary = {}
var _next_ordinal: int = 1

## Diagnostics the suite reads.
var registrations: int = 0
var refusals: int = 0
var last_refusal: String = ""

func _init(p_area_id: String) -> void:
	area_id = p_area_id

## Registers ONE entity and returns its ID -- or "" with the refusal recorded.
func register(node: Node, category: String, faction: String) -> String:
	if node == null:
		return _refuse("a null entity cannot be registered")
	if _index_of_node.has(node):
		# IMMUTABLE: the entity already has its ID, and it keeps it.
		return _refuse("'%s' is already registered as %s; an ID is IMMUTABLE and is never reassigned"
			% [category, String(_records[int(_index_of_node[node])]["id"])])
	if HuntressConfig.REFUSED_CATEGORIES.has(category):
		return _refuse("category '%s' is REFUSED: no such system exists here, and whether an arrow stops at one is NOT decided (D-391 §5 item 6)"
			% category)
	if not (HuntressConfig.HOSTILE_CATEGORIES.has(category)
			or HuntressConfig.ALLY_CATEGORIES.has(category)):
		return _refuse("unknown category '%s'" % category)
	if faction != "hostile" and faction != "ally":
		return _refuse("unknown faction '%s'" % faction)
	var ordinal := _next_ordinal
	_next_ordinal += 1
	var rec := {
		"ordinal": ordinal,
		"id": "CE-%04d" % ordinal,
		"node": node,
		"category": category,
		"faction": faction,
	}
	_index_of_node[node] = _records.size()
	_records.append(rec)
	registrations += 1
	return String(rec["id"])

func _refuse(reason: String) -> String:
	refusals += 1
	last_refusal = reason
	return ""

## THE ONE ORDERING. True when `a` precedes `b` -- the lower registration
## sequence. Callers never compare the display strings.
func precedes(a_id: String, b_id: String) -> bool:
	return ordinal_of(a_id) < ordinal_of(b_id)

func ordinal_of(id: String) -> int:
	for rec in _records:
		if String(rec["id"]) == id:
			return int(rec["ordinal"])
	return 0x7fffffff

func record_of(node: Node) -> Dictionary:
	if node == null or not _index_of_node.has(node):
		return {}
	return _records[int(_index_of_node[node])]

func id_of(node: Node) -> String:
	var r := record_of(node)
	return String(r.get("id", ""))

func record_by_id(id: String) -> Dictionary:
	for rec in _records:
		if String(rec["id"]) == id:
			return rec
	return {}

## Every record, in registration order. Its order DECIDES NOTHING: the arrow's
## choice is a minimum over time of impact, then over `precedes()`.
func records() -> Array:
	return _records.duplicate()

func count() -> int:
	return _records.size()
