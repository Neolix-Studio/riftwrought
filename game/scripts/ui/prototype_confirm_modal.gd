class_name PrototypeConfirmModal
extends GateEModal
## Prototype Zero — Gate F: the deliberate confirmation (specification §21
## General, decision D-189).
##
## §21: "Reset Lab Progress behind a deliberate confirmation."
##
## Deliberate means four things here, and all four are enforced rather than
## implied:
##
##   * The destructive option is NEVER the default focus. `Cancel` takes focus,
##     so a confirm pressed without reading cancels.
##   * `ui_cancel` cancels, so the reflex to back out works.
##   * A control that was already held when this opened cannot act on it — the
##     Gate E modal's `_armed` rule, which is why pressing Reset in the menu
##     underneath cannot carry through into pressing Confirm here.
##   * The body says exactly what will be destroyed and what will NOT be, so the
##     player is confirming a known thing. Resetting the lab does not touch the
##     settings file, and the panel says so.
##
## It is reused rather than duplicated: one confirmation, whatever is being
## confirmed, so a later destructive action cannot arrive with weaker guards.

var _title: Label
var _body: Label
var _confirm: Button
var _cancel: Button
var _on_confirmed: Callable = Callable()
var _confirm_label: String = "Confirm"

# --- Instrumentation ---------------------------------------------------------
var confirmations: int = 0
var cancellations: int = 0


func modal_name() -> String:
	return "confirm"


## The safe option, always.
func default_focus() -> Control:
	return _cancel


func cancel_closes() -> bool:
	return true


func build_contents() -> void:
	var panel: PanelContainer = make_panel(520)
	# Genuinely centred: `PRESET_CENTER` alone anchors the top-left corner to the
	# middle and grows down and right.
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	_title = make_title("Confirm")
	box.add_child(_title)
	_body = make_line("", 14, TEXT)
	_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_body.custom_minimum_size = Vector2(470, 0)
	box.add_child(_body)
	box.add_child(make_rule())

	var buttons: HBoxContainer = HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_END
	buttons.add_theme_constant_override("separation", 10)
	_cancel = make_button("Cancel", &"ui_cancel")
	_cancel.pressed.connect(_on_cancel)
	_confirm = make_button("Confirm", &"ui_confirm")
	_confirm.pressed.connect(_on_confirm)
	buttons.add_child(_cancel)
	buttons.add_child(_confirm)
	box.add_child(buttons)
	panel.add_child(box)
	add_child(panel)


func ask(title: String, body: String, confirm_text: String, on_confirmed: Callable) -> void:
	_title.text = title
	_body.text = body
	_confirm_label = confirm_text
	_on_confirmed = on_confirmed
	open()
	# The caption is set after `open()` because `refresh_contents()` runs there.
	_set_confirm_caption(confirm_text)


func refresh_contents() -> void:
	_set_confirm_caption(_confirm_label)


## `GateEModal.make_button` builds `Button -> HBoxContainer -> [caption, glyph]`.
## The caption is the FIRST Label in that row; the glyph is the second and is
## owned by the modal's glyph registry, which rewrites it whenever the input
## family changes. Rewriting only the first keeps the two from fighting.
func _set_confirm_caption(text: String) -> void:
	if _confirm == null:
		return
	for child: Node in _confirm.get_children():
		for grandchild: Node in child.get_children():
			var label: Label = grandchild as Label
			if label != null:
				label.text = text
				return


func _on_confirm() -> void:
	confirmations += 1
	room.note_menu_cue("menu_confirm")
	var action: Callable = _on_confirmed
	_on_confirmed = Callable()
	close("confirmed")
	if action.is_valid():
		action.call()


func _on_cancel() -> void:
	cancellations += 1
	room.note_menu_cue("menu_close")
	_on_confirmed = Callable()
	close("cancelled")
