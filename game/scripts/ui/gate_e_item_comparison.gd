class_name GateEItemComparison
extends GateEModal
## Prototype Zero — Gate E: the ground item comparison (specification §16.1,
## §13, decision D-184).
##
## It shows EXACTLY what D-184 lists and nothing else:
##
##   the current weapon name
##   the candidate weapon name
##   Quick Strike Physical Hit   100 -> 150
##   Hits to this Graveblade       3 -> 2
##   Attack Time                0.80 -> 0.80 s
##   Equip and Close
##
## EVERY NUMBER IS COMPUTED, never written down. The two damages come from the
## two weapon records, the hit counts from those records divided into the
## Graveblade's own `max_life`, and the two action times from the Quick Strike
## record under each weapon's own attack-speed contribution. A later edit to any
## of those records changes this panel, which is the only way a comparison can be
## trusted to be stating a fact.
##
## "Hits to this Graveblade" is deliberately worded as a controlled lab
## comparison (specification §13). It is not a promise that final item UI
## predicts every enemy.
##
## WHAT IT DOES NOT CONTAIN, because Gate E does not build it: an Item Power
## score, a universal upgrade verdict, a rarity frame, an affix list, affix
## ranges or Tiers, Local/Global scope, requirements, an inventory grid, an
## equipment paper doll, Advanced Details, Build Lens, Favorite, Mark for
## Salvage, or a Field Pack position. Those are first-MVP systems.
##
## Close leaves the sword safely on the ground. Equip replaces the deterministic
## prototype weapon directly; there is no inventory, no pickup capacity, and
## nothing is lost.

var _drop: PrototypeSwordDrop = null

var _current_name: Label
var _candidate_name: Label
var _rows: Array[Dictionary] = []
var _equip: Button
var _close: Button
var _note: Label


func modal_name() -> String:
	return "comparison"


## The safe, non-destructive control takes focus first. Equip is the progression
## action and stays plainly reachable one step away, exactly as specification
## §20.1 words the same rule for the Fallen overlay.
func default_focus() -> Control:
	return _close


func build_contents() -> void:
	var panel: PanelContainer = make_panel(560)
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)

	box.add_child(make_title("Ground item"))

	var names: VBoxContainer = VBoxContainer.new()
	names.add_theme_constant_override("separation", 4)
	_current_name = make_line("Current — …", 15, TEXT_DIM)
	_candidate_name = make_line("Candidate — …", 17, COPPER)
	names.add_child(_candidate_name)
	names.add_child(_current_name)
	box.add_child(names)

	box.add_child(make_rule())

	# The three factual rows, in the exact order D-184 states them.
	var grid: GridContainer = GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 8)
	for label: String in ["Quick Strike Physical Hit", "Hits to this Graveblade", "Attack Time"]:
		var caption: Label = make_line(label, 15, TEXT)
		caption.custom_minimum_size = Vector2(250, 0)
		var from: Label = make_line("—", 15, UNCHANGED)
		from.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		from.custom_minimum_size = Vector2(66, 0)
		var arrow: Label = make_line("→", 15, TEXT_DIM)
		var to: Label = make_line("—", 15, UNCHANGED)
		to.custom_minimum_size = Vector2(96, 0)
		grid.add_child(caption)
		grid.add_child(from)
		grid.add_child(arrow)
		grid.add_child(to)
		_rows.append({"from": from, "to": to})
	box.add_child(grid)

	box.add_child(make_rule())

	_note = make_line("", 12, TEXT_DIM)
	_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_note)

	var buttons: HBoxContainer = HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_END
	buttons.add_theme_constant_override("separation", 12)
	_close = make_button("Close", &"ui_cancel")
	_equip = make_button("Equip", &"ui_confirm")
	_close.pressed.connect(_on_close_pressed)
	_equip.pressed.connect(_on_equip_pressed)
	buttons.add_child(_close)
	buttons.add_child(_equip)
	box.add_child(buttons)

	panel.add_child(box)
	add_child(panel)

	# Explicit focus neighbours, so controller navigation is a graph rather than
	# a guess (the canon: controller navigation cannot depend on hover). Set
	# AFTER both buttons are in the tree, because a NodePath to a node outside
	# one has nothing to point at.
	_close.focus_neighbor_right = _close.get_path_to(_equip)
	_close.focus_next = _close.get_path_to(_equip)
	_equip.focus_neighbor_left = _equip.get_path_to(_close)
	_equip.focus_previous = _equip.get_path_to(_close)


## Opened by a click on the drop's nameplate, or by the controller's interact
## button from inside the drop's interaction range.
func open_for(drop: PrototypeSwordDrop) -> void:
	_drop = drop
	open()


func refresh_contents() -> void:
	if _drop == null or room == null:
		return
	var current: PrototypeWeaponData = room.player.weapon
	var candidate: PrototypeWeaponData = _drop.weapon
	var enemy_life: float = room.graveblade_max_life()
	var base_action: float = room.player.attack.data.action_time
	var passive: float = room.director.progress.increased_attack_speed()

	_current_name.text = "Current — %s" % current.display_name
	_candidate_name.text = "Candidate — %s" % candidate.display_name

	_set_row(0, "%.0f" % current.physical_damage, "%.0f" % candidate.physical_damage,
		candidate.physical_damage > current.physical_damage)
	# Computed from the Graveblade's OWN record, so the panel cannot state a
	# relationship the enemy no longer has.
	var hits_now: int = current.hits_to_defeat(enemy_life)
	var hits_next: int = candidate.hits_to_defeat(enemy_life)
	_set_row(1, str(hits_now), str(hits_next), hits_next < hits_now)
	# Computed from each record's own attack-speed contribution, which is zero
	# for both prototype swords — so this row honestly reads unchanged.
	var time_now: float = current.effective_action_time(base_action, passive)
	var time_next: float = candidate.effective_action_time(base_action, passive)
	_set_row(2, "%.2f" % time_now, "%.2f s" % time_next, false)

	_equip.disabled = room.director.progress.honed_sword_equipped
	_note.text = "Close leaves it on the ground. Equipping replaces the prototype weapon directly — nothing is carried and nothing is lost."


func _set_row(index: int, from_text: String, to_text: String, improved: bool) -> void:
	var row: Dictionary = _rows[index]
	var from: Label = row["from"]
	var to: Label = row["to"]
	from.text = from_text
	to.text = to_text
	# Colour states a direction, not a verdict: there is no score and no
	# "upgrade / downgrade" judgement anywhere in this panel.
	to.add_theme_color_override("font_color", IMPROVED if improved else UNCHANGED)


func _on_close_pressed() -> void:
	close("closed — the sword is still on the ground")


func _on_equip_pressed() -> void:
	# `equip_honed_sword()` is idempotent: a second press, a re-opened panel, or
	# a duplicated signal all get false and change nothing.
	if room.director.equip_honed_sword():
		close("equipped")
		return
	close("already equipped")
