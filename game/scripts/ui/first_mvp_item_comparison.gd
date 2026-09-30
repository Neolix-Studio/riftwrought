class_name FirstMvpItemComparison
extends FirstMvpModal
## First-MVP — Gate 1D: the item comparison / equip panel (decision D-217).
##
## The same three-row shape Prototype Zero's `GateEItemComparison` proved:
## current weapon name, candidate weapon name, and every number COMPUTED live
## from the two records rather than written down — never a stored verdict.
##
##   Quick Strike Physical Hit
##   Hits to this Graveblade
##   Attack Time
##
## No "green = better" universal verdict anywhere: a row's colour states a
## measured DIRECTION (numerically improved / unchanged), never a build
## judgement, exactly as the Gate 1D brief requires ("the interface may
## highlight factual increases/decreases, but the game must not make a general
## build judgment").
##
## THE DIFFERENCE FROM GATE E'S SHORTCUT: Equip does not just reassign the
## player's weapon reference — it goes through `PlayerLoadout.pick_up()` (the
## item becomes OWNED, a separate fact from being equipped) and then
## `PlayerLoadout.equip()`, so a player who closes this panel without
## equipping still keeps the item and can equip it later without walking back
## to the drop. Both doors are idempotent; a duplicated signal or a reopened
## panel changes nothing twice.

var _drop: FirstMvpItemDrop = null

var _current_name: Label
var _candidate_name: Label
var _rows: Array[Dictionary] = []
var _equip: Button
var _close: Button
var _note: Label


func modal_name() -> String:
	return "comparison"


func default_focus() -> Control:
	return _close


func build_contents() -> void:
	var panel: PanelContainer = make_panel(560)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
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

	_close.focus_neighbor_right = _close.get_path_to(_equip)
	_close.focus_next = _close.get_path_to(_equip)
	_equip.focus_neighbor_left = _equip.get_path_to(_close)
	_equip.focus_previous = _equip.get_path_to(_close)


func open_for(drop: FirstMvpItemDrop) -> void:
	_drop = drop
	open()


func refresh_contents() -> void:
	if _drop == null or room == null:
		return
	var current: PrototypeWeaponData = room.loadout.equipped_weapon
	var candidate: PrototypeWeaponData = _drop.weapon
	var enemy_life: float = room.graveblade_max_life()
	var base_action: float = room.player.attack.data.action_time

	_current_name.text = "Current — %s" % current.display_name
	_candidate_name.text = "Candidate — %s" % candidate.display_name

	_set_row(0, "%.0f" % current.physical_damage, "%.0f" % candidate.physical_damage,
		candidate.physical_damage > current.physical_damage)
	var hits_now: int = current.hits_to_defeat(enemy_life)
	var hits_next: int = candidate.hits_to_defeat(enemy_life)
	_set_row(1, str(hits_now), str(hits_next), hits_next < hits_now)
	var time_now: float = current.effective_action_time(base_action, 0.0)
	var time_next: float = candidate.effective_action_time(base_action, 0.0)
	_set_row(2, "%.2f" % time_now, "%.2f s" % time_next, false)

	_equip.disabled = room.loadout.is_equipped(candidate)
	_note.text = "Close leaves it on the ground. Equipping picks it up and makes it the weapon Quick Strike swings; nothing is destroyed either way."


func _set_row(index: int, from_text: String, to_text: String, improved: bool) -> void:
	var row: Dictionary = _rows[index]
	var from: Label = row["from"]
	var to: Label = row["to"]
	from.text = from_text
	to.text = to_text
	to.add_theme_color_override("font_color", IMPROVED if improved else UNCHANGED)


func _on_close_pressed() -> void:
	close("closed — the item is still on the ground")


func _on_equip_pressed() -> void:
	# `pick_up()` first: the item becomes OWNED, separate from being equipped —
	# the truthful path Gate 1D's brief asks for, unlike Gate E's single-click
	# pickup-and-equip. Both doors are idempotent, so a duplicated press or a
	# reopened panel changes nothing twice.
	room.loadout.pick_up(_drop.weapon)
	if room.loadout.equip(_drop.weapon):
		room.on_weapon_equipped(_drop)
		close("equipped")
		return
	close("already equipped")
