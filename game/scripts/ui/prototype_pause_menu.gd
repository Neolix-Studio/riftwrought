class_name PrototypePauseMenu
extends GateEModal
## Prototype Zero — Gate F: Pause (specification §21, §9.2, decision D-189).
##
## §21: "Pause must expose Resume, Restart Current Fight, Settings, Reset Lab
## Progress, and Quit to Title." That is the whole menu, in that order.
##
## IT REUSES GATE E'S MODAL CONTRACT RATHER THAN INVENTING A SECOND ONE. D-184
## already required the comparison and the passive card to pause the simulation,
## neutralise held intent, take safe focus, follow the live glyph family, and
## refuse an input that was already held when the surface opened — and Gate E
## implemented all five once, in `gate_e_modal.gd`, precisely so a later surface
## could not drift from them. Pause is a later surface. It inherits every one:
##
##   * `get_tree().paused` genuinely stops the world, so no timer, cooldown,
##     attack phase, wave countdown, or coordinator window advances behind it.
##   * Opening clears the destination, the stick, the held mouse button, the
##     attack, its buffer, and its held repeat, through the SAME path focus loss
##     and controller disconnect use.
##   * Resume re-arms the room's neutral latch, so movement and combat return
##     only once every physical control has been released.
##   * The button that was held to open the menu cannot press a button in it.
##
## DEFAULT FOCUS IS RESUME, the one option that changes nothing.

var _resume: Button
var _restart: Button
var _settings: Button
var _reset: Button
var _quit: Button
var _state_line: Label


func modal_name() -> String:
	return "pause"


func default_focus() -> Control:
	return _resume


func cancel_closes() -> bool:
	return true


func build_contents() -> void:
	var panel: PanelContainer = make_panel(430)
	# Genuinely centred: `PRESET_CENTER` alone anchors the top-left corner to the
	# middle and grows down and right.
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)

	box.add_child(make_line("Paused", 13, TEXT_DIM))
	box.add_child(make_title("Prototype Zero laboratory"))
	_state_line = make_line("", 12, TEXT_DIM)
	box.add_child(_state_line)
	box.add_child(make_rule())

	var buttons: VBoxContainer = VBoxContainer.new()
	buttons.add_theme_constant_override("separation", 8)
	_resume = _wide("Resume", &"ui_cancel")
	_resume.pressed.connect(_on_resume)
	_restart = _wide("Restart Current Fight", &"ui_confirm")
	_restart.pressed.connect(_on_restart)
	_settings = _wide("Settings", &"ui_confirm")
	_settings.pressed.connect(_on_settings)
	_reset = _wide("Reset Lab Progress…", &"ui_confirm")
	_reset.pressed.connect(_on_reset)
	_quit = _wide("Quit to Title", &"ui_confirm")
	_quit.pressed.connect(_on_quit)
	for button: Button in [_resume, _restart, _settings, _reset, _quit]:
		buttons.add_child(button)
	box.add_child(buttons)

	box.add_child(make_line("F5 also restarts the current fight.", 11, TEXT_DIM))
	panel.add_child(box)
	add_child(panel)


func refresh_contents() -> void:
	if room == null:
		return
	var progress: LabProgress = room.director.progress
	_state_line.text = "%s   •   %s   •   %s" % [
		progress.stage_name(), progress.experience_line(), room.player.weapon.display_name,
	]


## §9.1 binds `quick_restart` to "F5 from Fallen or pause", so it is answered
## here and in the Fallen overlay rather than globally — a restart key that works
## mid-fight is not the trusted, deliberate flow §20.2 asks for.
func _input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed(&"quick_restart"):
		get_viewport().set_input_as_handled()
		if _consume(&"ui_confirm"):
			_on_restart()
		return
	super(event)


func _on_resume() -> void:
	room.note_menu_cue("menu_close")
	close("resumed")


func _on_restart() -> void:
	room.note_menu_cue("menu_confirm")
	close("restarting")
	room.restart_current_fight("pause menu")


func _on_settings() -> void:
	room.note_menu_cue("menu_open")
	close("opening settings")
	room.open_settings("pause menu")


func _on_reset() -> void:
	room.note_menu_cue("menu_open")
	close("confirming a lab reset")
	room.confirm_reset_lab_progress("pause menu")


func _on_quit() -> void:
	room.note_menu_cue("menu_confirm")
	close("quitting to title")
	room.quit_to_title("pause menu")


func _wide(text: String, action: StringName) -> Button:
	var button: Button = make_button(text, action)
	button.custom_minimum_size = Vector2(386, 42)
	return button
