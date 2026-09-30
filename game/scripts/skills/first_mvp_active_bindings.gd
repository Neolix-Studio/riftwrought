class_name FirstMvpActiveBindings
extends RefCounted
## First-MVP — Gate 1E: the active Skill bindings (D-219).
##
## The brief: "A simple production active-binding model sufficient for Quick
## Strike + the chosen Foundation Skill is authorized. Make it extendable to the
## eventual eight active bindings without building that whole interface now."
##
## So this is eight slots in two banks of four — the exact canonical shape
## (`design/UI_AND_USER_EXPERIENCE.md`: "eight visible Skill bindings in two
## banks of four") — of which Gate 1E fills two and leaves six empty. That
## costs nothing and means the eventual Shaping Board edits a model that already
## has the right number of slots rather than replacing one that does not.
##
## NO PHYSICAL INPUT IS BOUND IN GATE 1E, AND THAT IS DELIBERATE RATHER THAN
## UNFINISHED. Declaring an InputMap action for a second Skill would move two
## CLOSED gate counts with no old assertion becoming false: Gate E and Gate F
## each walk `InputMap.get_actions()` and emit one assertion per key event, so
## one new action takes Gate E from 713 to 715 and Gate F from 1008 to 1010.
## Gate 1A set the precedent by reading its two developer toggles as PHYSICAL
## KEYS for exactly this reason, and Gate 1C and Gate 1D followed it.
##
## Gate 1E does not need a binding anyway: the brief states that "the chosen
## Foundation Skill receives its real first combat use during First Footing",
## and that damaging Skill execution may be disabled in the safe Nexus. The
## developer practice scene drives the three Skills from physical keys. When
## First Footing needs a real second combat binding, that is an explicit
## authorization with the arithmetic stated — not a side effect of this gate.
##
## NOT THE SHAPING BOARD. There is no Configuration, no Augment facet, no
## Transform, no Persistent Loadout, no Reservation, no Shaped Skill, and no
## editor interface. Each of those is named in Gate 1E's exclusion list.

const SLOT_COUNT: int = 8
const BANK_SIZE: int = 4
const EMPTY: StringName = &""

## Slot 0 is the first bank's first binding, where Quick Strike sits from
## character creation.
const PRIMARY_SLOT: int = 0
## Slot 1 is where the chosen Foundation Skill lands.
const FOUNDATION_SLOT: int = 1

var slots: Array[StringName] = []


func _init() -> void:
	slots.resize(SLOT_COUNT)
	slots.fill(EMPTY)
	slots[PRIMARY_SLOT] = &"quick_strike"


func bind(slot: int, skill_id: StringName) -> bool:
	if slot < 0 or slot >= SLOT_COUNT:
		return false
	slots[slot] = skill_id
	return true


func unbind(slot: int) -> bool:
	return bind(slot, EMPTY)


func skill_in(slot: int) -> StringName:
	if slot < 0 or slot >= SLOT_COUNT:
		return EMPTY
	return slots[slot]


func slot_of(skill_id: StringName) -> int:
	return slots.find(skill_id)


func is_bound(skill_id: StringName) -> bool:
	return slot_of(skill_id) >= 0


func bound_count() -> int:
	var total: int = 0
	for entry: StringName in slots:
		if entry != EMPTY:
			total += 1
	return total


## Which bank a slot belongs to, 0 or 1. The canonical interface shows one bank
## at a time and reveals the second through a held Skill layer.
static func bank_of(slot: int) -> int:
	return slot / BANK_SIZE


func bank(index: int) -> Array[StringName]:
	var found: Array[StringName] = []
	for slot: int in range(index * BANK_SIZE, mini((index + 1) * BANK_SIZE, SLOT_COUNT)):
		found.append(slots[slot])
	return found


## Save form: the eight slots as plain strings, empty slots included, so the
## saved array's LENGTH is meaningful and a later ninth slot cannot be mistaken
## for a shifted eighth.
func to_string_array() -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for entry: StringName in slots:
		out.append(String(entry))
	return out


## Restores from the save form. Returns "" on success or a problem string; a
## wrong-length array is refused rather than padded, because padding a corrupted
## record silently invents a binding.
func from_string_array(values: PackedStringArray) -> String:
	if values.size() != SLOT_COUNT:
		return "expected %d binding slots, found %d" % [SLOT_COUNT, values.size()]
	for slot: int in SLOT_COUNT:
		slots[slot] = StringName(values[slot])
	return ""


func describe() -> String:
	var parts: PackedStringArray = PackedStringArray()
	for slot: int in SLOT_COUNT:
		if slots[slot] != EMPTY:
			parts.append("%d:%s" % [slot + 1, slots[slot]])
	return "%d of %d binding(s) filled — %s" % [
		bound_count(), SLOT_COUNT, ", ".join(parts) if not parts.is_empty() else "none",
	]
