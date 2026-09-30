class_name PrototypeSettingsModal
extends GateEModal
## Prototype Zero — Gate F: Settings reached from Pause (specification §21,
## decision D-189).
##
## A host, not a second settings screen. The rows live in
## `PrototypeSettingsPanel`, which the title screen also hosts, so the two paths
## into the same §21 list cannot diverge.
##
## It inherits the Gate E modal contract for the same reason Pause does: the
## world genuinely stops, held intent is neutralised, focus is safe, glyphs
## follow the live input family, and an input held on the way in cannot press a
## button here. Master volume still applies on the frame the slider moves, which
## is audible precisely because this surface keeps processing while paused.

var panel_content: PrototypeSettingsPanel

## Where to go when the surface closes: back to Pause, or back to nothing.
var return_to_pause: bool = true


func modal_name() -> String:
	return "settings"


func default_focus() -> Control:
	return panel_content.first_focus() if panel_content != null else null


func cancel_closes() -> bool:
	return true


func build_contents() -> void:
	var panel: PanelContainer = make_panel(780)
	# Genuinely centred. `PRESET_CENTER` alone anchors the top-left corner to the
	# middle and grows down and right, which pushes a tall panel off the bottom of
	# a 1280 x 720 window.
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	box.add_child(make_title("Settings"))
	box.add_child(make_line(
		"Prototype Zero settings only. Full remapping, input profiles, captions, colour-vision tools, and the detailed mix are first-MVP scope.",
		11, TEXT_DIM
	))
	box.add_child(make_rule())

	# §21's list is taller than the minimum tested window, so it scrolls — and
	# `follow_focus` is what makes that controller-complete: moving focus down the
	# rows scrolls them into view without a mouse anywhere near the scrollbar.
	var scroll: ScrollContainer = ScrollContainer.new()
	scroll.name = "SettingsScroll"
	scroll.follow_focus = true
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.custom_minimum_size = Vector2(736, 520)
	panel_content = PrototypeSettingsPanel.new()
	panel_content.name = "Rows"
	panel_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(panel_content)
	box.add_child(scroll)

	panel.add_child(box)
	add_child(panel)


func bind_room(owner_room: PrototypeZeroRoom) -> void:
	super(owner_room)
	panel_content.configure(
		owner_room.settings, owner_room.display, owner_room.audio, owner_room.input_family, true
	)
	panel_content.back_requested.connect(_on_back)
	panel_content.reset_lab_requested.connect(_on_reset_lab)
	panel_content.apply_display_requested.connect(_on_apply_display)


func refresh_contents() -> void:
	if panel_content != null:
		panel_content.resync_staged()


func close(reason: String = "closed") -> void:
	var was_open: bool = is_open
	super(reason)
	if not was_open:
		return
	# Settings is always entered FROM somewhere. Closing returns there rather
	# than dropping the player into an unpaused fight they did not ask to rejoin.
	if return_to_pause and room != null and reason != "opening a confirmation":
		room.open_pause("returned from settings")


func _on_back() -> void:
	room.note_menu_cue("menu_close")
	close("closed")


func _on_reset_lab() -> void:
	return_to_pause = false
	close("opening a confirmation")
	return_to_pause = true
	room.confirm_reset_lab_progress("settings")


func _on_apply_display(
	mode: PrototypeSettings.WindowMode, resolution_index: int
) -> void:
	room.apply_display_change(mode, resolution_index)
	panel_content.resync_staged()
