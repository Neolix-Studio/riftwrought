class_name PreyState
extends Node

## PREY, FOR THIS SPIKE — combat state, not lock-on.
##
## ============================================================================
## WHAT CANON SAYS, AND WHAT THIS SPIKE DOES WITH IT
## ============================================================================
## `design/CHARACTER_CLASS_PHILOSOPHY.md` §0.5.3 (D-385). For this spike:
##   * a valid DIRECT arrow Hit designates its target;
##   * a Hit on the other target SWITCHES Prey;
##   * there is exactly ONE Prey at a time;
##   * death or removal CLEARS it;
##   * NO damage bonus, NO auto-aim, NO lock-on -- nothing here is read by aiming,
##     and nothing here touches damage;
##   * ONLY A DIRECT USE CAN DESIGNATE. A minion's bite is REFUSED and counted.
##
## NOT IMPLEMENTED, BECAUSE CANON LEAVES THEM OWED AND A SPIKE MUST NOT INVENT
## THEM: the multi-target tie-break (OWED #1 -- never triggered here, projectiles
## Hit one target each), Prey's timeout (OWED #14 -- no number exists), and
## "when she leaves the area" (the spike has no areas). Printed as DF-01..DF-03.

signal prey_changed(target: Node)

const DIRECT_USE := "direct_use"

var current: TargetDummy = null
var designations: int = 0
var switches: int = 0
var refreshes: int = 0
var clears_death: int = 0
var clears_removal: int = 0
var refused_non_direct: int = 0
var refused_invalid: int = 0
## [physics frame, event, target name]
var history: Array = []
var _watched: Array = []

func watch(t: TargetDummy) -> void:
	if _watched.has(t):
		return
	_watched.append(t)
	t.died_target.connect(_on_died)
	t.tree_exiting.connect(_on_removed.bind(t))

## THE ONLY WAY PREY MOVES. `source_kind` must be DIRECT_USE.
func designate(t: Node, source_kind: String, use_id: int = -1) -> bool:
	if source_kind != DIRECT_USE:
		refused_non_direct += 1
		history.append([Engine.get_physics_frames(), "REFUSED:%s" % source_kind, _name(t)])
		return false
	if t == null or not is_instance_valid(t) or not (t is TargetDummy) or not bool(t.get("alive")):
		refused_invalid += 1
		return false
	var td := t as TargetDummy
	if td == current:
		refreshes += 1
		history.append([Engine.get_physics_frames(), "REFRESH use %d" % use_id, td.label_text])
		return true
	if current != null:
		current.set_prey(false)
		switches += 1
	current = td
	current.set_prey(true)
	designations += 1
	history.append([Engine.get_physics_frames(), "DESIGNATE use %d" % use_id, td.label_text])
	prey_changed.emit(current)
	return true

func _on_died(t: TargetDummy) -> void:
	if t == current:
		_clear("death")
		clears_death += 1

func _on_removed(t: TargetDummy) -> void:
	_watched.erase(t)
	if t == current:
		_clear("removal")
		clears_removal += 1

func _clear(why: String) -> void:
	if current != null and is_instance_valid(current):
		current.set_prey(false)
	history.append([Engine.get_physics_frames(), "CLEAR:%s" % why, _name(current)])
	current = null
	prey_changed.emit(null)

func is_prey(t: Node) -> bool:
	return t != null and t == current

func current_name() -> String:
	return current.label_text if current != null else "none"

## How many targets are showing the Prey marker right now (must be 0 or 1).
func marked_count() -> int:
	var n := 0
	for t in _watched:
		if is_instance_valid(t) and (t as TargetDummy).is_marked():
			n += 1
	return n

func _name(t) -> String:
	if t == null or not is_instance_valid(t):
		return "none"
	return String(t.get("label_text")) if t.get("label_text") != null else String(t.name)
