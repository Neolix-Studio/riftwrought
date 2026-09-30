class_name PrototypeTitleScreen
extends Control
## Prototype Zero — Gate F: the title surface (specification §7.1, §20.3,
## decision D-189).
##
## §7.1 gives the persistent app exactly four things to offer, and this is them:
##
##   Start New Lab
##   Continue Lab            only when a VALID saved state exists
##   Settings
##   Quit where supported
##
## IT TELLS THE TRUTH ABOUT THE SAVE. §20.3: "If the file is invalid, show a
## small truthful recovery message and offer Reset Lab Progress. Do not silently
## claim an exact resume." So there are three states here, not two:
##
##   no file          Continue is disabled and says why: nothing has been saved.
##   valid file       Continue is enabled and NAMES the state it will rebuild —
##                    the stage, the XP, the sword, and the passive — so the
##                    player can see before pressing whether it is the run they
##                    remember.
##   invalid file     Continue is disabled, the exact fault is printed, and
##                    Reset Lab Progress is offered right there. Nothing is
##                    silently repaired and no resume is promised.
##
## START NEW LAB ASKS FIRST when a valid save exists, because it destroys the
## same thing Reset Lab Progress destroys and §21 puts that behind a deliberate
## confirmation. The confirmation's default answer is Cancel.
##
## Presentation is the same restrained Wroughtstone-adjacent placeholder the rest
## of the prototype uses: broad dark slate, an iron rule, one muted copper
## accent, and a standing line saying it is not final UI. No logo, no promotional
## art, no store, no login, no rotating advertisement, and no daily reward — the
## canonical session-flow rules forbid all of those and Prototype Zero has no
## business inventing any of them.

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.96)
const SLATE_DEEP: Color = Color(0.055, 0.060, 0.072, 0.99)
const IRON: Color = Color(0.28, 0.30, 0.35)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const TEXT_DIM: Color = Color(0.55, 0.58, 0.64)
const WARN: Color = Color(0.92, 0.62, 0.36)

var app: Node
var settings: PrototypeSettings
var lab_state: PrototypeLabState
var audio: PrototypeAudioDirector
var display: PrototypeDisplayManager
var input_family: InputFamilyTracker

var _menu_page: Control
var _settings_page: Control
var _settings_panel: PrototypeSettingsPanel
var _confirm_page: Control
var _confirm_body: Label
var _confirm_cancel: Button
var _confirm_accept: Button
var _pending_confirm: Callable = Callable()

var _continue: Button
var _start: Button
var _settings_button: Button
var _quit: Button
var _reset: Button
var _save_line: Label
var _notice: Label

# --- Instrumentation ---------------------------------------------------------
var page: String = "menu"


func _ready() -> void:
	# `set_anchors_and_offsets_preset`, not `set_anchors_preset`. The latter sets
	# the anchors and leaves the OFFSETS where they were, which for a Control
	# created in code is (0, 0, 0, 0) — a full-rect anchor over a zero-size rect.
	# Everything anchored inside it then collapses to the origin or off the top of
	# the screen. The scene-instanced Gate E surfaces never hit this because their
	# `.tscn` writes both.
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build()


func configure(
	owner_app: Node,
	store: PrototypeSettings,
	state: PrototypeLabState,
	audio_director: PrototypeAudioDirector,
	display_manager: PrototypeDisplayManager,
	tracker: InputFamilyTracker
) -> void:
	app = owner_app
	settings = store
	lab_state = state
	audio = audio_director
	display = display_manager
	input_family = tracker
	_settings_panel.configure(store, display_manager, audio_director, tracker, false)
	_settings_panel.back_requested.connect(_on_settings_back)
	_settings_panel.apply_display_requested.connect(_on_apply_display)
	tracker.family_changed.connect(_on_family_changed)
	refresh()


# --- Build -------------------------------------------------------------------

func _build() -> void:
	var background: ColorRect = ColorRect.new()
	background.name = "Background"
	background.color = Color(0.035, 0.038, 0.046, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(background)

	_build_menu()
	_build_settings_page()
	_build_confirm_page()

	var tag: Label = _line(
		"Prototype presentation, not final UI. Prototype Zero is a contained laboratory, not the first MVP.",
		11, TEXT_DIM
	)
	tag.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	tag.position = Vector2(32, -44)
	add_child(tag)


func _build_menu() -> void:
	_menu_page = Control.new()
	_menu_page.name = "Menu"
	_menu_page.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_menu_page.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_menu_page)

	var panel: PanelContainer = _panel()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	panel.custom_minimum_size = Vector2(560, 0)
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)

	var title: Label = _line("Riftwrought", 40, COPPER)
	box.add_child(title)
	box.add_child(_line("Prototype Zero — contained combat and improvement-loop laboratory", 13, TEXT_DIM))
	box.add_child(_rule())

	_save_line = _line("", 12, TEXT_DIM)
	_save_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_save_line.custom_minimum_size = Vector2(504, 0)
	box.add_child(_save_line)

	_notice = _line("", 12, WARN)
	_notice.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_notice.custom_minimum_size = Vector2(504, 0)
	_notice.visible = false
	box.add_child(_notice)

	var buttons: VBoxContainer = VBoxContainer.new()
	buttons.add_theme_constant_override("separation", 8)
	_continue = _button("Continue Lab")
	_continue.pressed.connect(_on_continue)
	_start = _button("Start New Lab")
	_start.pressed.connect(_on_start)
	_settings_button = _button("Settings")
	_settings_button.pressed.connect(_on_settings)
	_reset = _button("Reset Lab Progress…")
	_reset.add_theme_color_override("font_color", WARN)
	_reset.pressed.connect(_on_reset)
	_reset.visible = false
	_quit = _button("Quit")
	_quit.pressed.connect(_on_quit)
	for button: Button in [_continue, _start, _settings_button, _reset, _quit]:
		buttons.add_child(button)
	box.add_child(buttons)
	panel.add_child(box)
	_menu_page.add_child(panel)


func _build_settings_page() -> void:
	_settings_page = Control.new()
	_settings_page.name = "SettingsPage"
	_settings_page.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_settings_page.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_settings_page.visible = false
	add_child(_settings_page)

	var panel: PanelContainer = _panel()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	panel.custom_minimum_size = Vector2(780, 0)
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	box.add_child(_line("Settings", 22, COPPER))
	box.add_child(_line(
		"Prototype Zero settings only. Full remapping, input profiles, captions, colour-vision tools, and the detailed mix are first-MVP scope.",
		11, TEXT_DIM
	))
	box.add_child(_rule())
	var scroll: ScrollContainer = ScrollContainer.new()
	scroll.name = "SettingsScroll"
	scroll.follow_focus = true
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.custom_minimum_size = Vector2(736, 520)
	_settings_panel = PrototypeSettingsPanel.new()
	_settings_panel.name = "Rows"
	_settings_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_settings_panel)
	box.add_child(scroll)
	panel.add_child(box)
	_settings_page.add_child(panel)


func _build_confirm_page() -> void:
	_confirm_page = Control.new()
	_confirm_page.name = "ConfirmPage"
	_confirm_page.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_confirm_page.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_confirm_page.visible = false
	add_child(_confirm_page)

	var panel: PanelContainer = _panel()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	panel.custom_minimum_size = Vector2(520, 0)
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	box.add_child(_line("Discard the saved laboratory?", 20, COPPER))
	_confirm_body = _line("", 13, TEXT)
	_confirm_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_confirm_body.custom_minimum_size = Vector2(470, 0)
	box.add_child(_confirm_body)
	box.add_child(_rule())
	var row: HBoxContainer = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_END
	row.add_theme_constant_override("separation", 10)
	_confirm_cancel = _button("Cancel")
	_confirm_cancel.custom_minimum_size = Vector2(150, 40)
	_confirm_cancel.pressed.connect(_on_confirm_cancel)
	_confirm_accept = _button("Confirm")
	_confirm_accept.custom_minimum_size = Vector2(150, 40)
	_confirm_accept.pressed.connect(_on_confirm_accept)
	row.add_child(_confirm_cancel)
	row.add_child(_confirm_accept)
	box.add_child(row)
	panel.add_child(box)
	_confirm_page.add_child(panel)


# --- State -------------------------------------------------------------------

func refresh() -> void:
	if lab_state == null:
		return
	var can_continue: bool = lab_state.exists and lab_state.valid
	_continue.disabled = not can_continue
	_reset.visible = lab_state.exists
	if not lab_state.exists:
		_save_line.text = "No saved laboratory yet. Start New Lab begins at the first Graveblade."
		_notice.visible = false
	elif not lab_state.valid:
		_save_line.text = "Continue is unavailable."
		_notice.text = "%s  Reset Lab Progress removes the file and starts the complete path again. Your settings are stored separately and are not affected." % lab_state.problem
		_notice.visible = true
	else:
		_save_line.text = "Saved laboratory: %s" % lab_state.describe()
		_notice.visible = false
	_focus_default()


## Shown after a startup display recovery, so the player is told rather than
## quietly corrected.
func show_notice(message: String) -> void:
	_notice.text = message
	_notice.visible = true


func _focus_default() -> void:
	if page != "menu":
		return
	if not _continue.disabled:
		_continue.grab_focus()
		return
	_start.grab_focus()


func _show_page(name: String) -> void:
	page = name
	_menu_page.visible = name == "menu"
	_settings_page.visible = name == "settings"
	_confirm_page.visible = name == "confirm"
	match name:
		"settings":
			_settings_panel.resync_staged()
			var focus: Control = _settings_panel.first_focus()
			if focus != null:
				focus.grab_focus()
		"confirm":
			# The safe answer takes focus.
			_confirm_cancel.grab_focus()
		_:
			_focus_default()


# --- Handlers ----------------------------------------------------------------

func _on_continue() -> void:
	_click()
	app.call("continue_lab")


func _on_start() -> void:
	_click()
	if lab_state.exists and lab_state.valid:
		_ask(
			"Start New Lab discards the saved laboratory: %s.\n\nSettings are stored in a separate file and are not affected." % lab_state.describe(),
			Callable(app, "start_new_lab")
		)
		return
	app.call("start_new_lab")


func _on_settings() -> void:
	_click()
	_show_page("settings")


func _on_settings_back() -> void:
	_show_page("menu")


func _on_apply_display(mode: PrototypeSettings.WindowMode, resolution_index: int) -> void:
	display.request_change(mode, resolution_index)
	_settings_panel.resync_staged()


func _on_reset() -> void:
	_click()
	_ask(
		"Reset Lab Progress permanently removes the saved laboratory state.\n\nSettings are stored in a separate file and are not affected.",
		Callable(app, "reset_lab_progress_from_title")
	)


func _on_quit() -> void:
	_click()
	app.call("quit_application", "title screen")


func _ask(body: String, action: Callable) -> void:
	_confirm_body.text = body
	_pending_confirm = action
	_show_page("confirm")


func _on_confirm_cancel() -> void:
	_click()
	_pending_confirm = Callable()
	_show_page("menu")


func _on_confirm_accept() -> void:
	_click()
	var action: Callable = _pending_confirm
	_pending_confirm = Callable()
	_show_page("menu")
	if action.is_valid():
		action.call()


func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if not event.is_action_pressed(&"ui_cancel"):
		return
	if page == "menu":
		return
	get_viewport().set_input_as_handled()
	_pending_confirm = Callable()
	_show_page("menu")


func _on_family_changed(_family: InputFamilyTracker.Family, _reason: String) -> void:
	pass


func _click() -> void:
	if audio != null:
		audio.play("menu_confirm")


# --- Builders ----------------------------------------------------------------

func _panel() -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = SLATE
	style.border_color = IRON
	style.set_border_width_all(1)
	style.set_corner_radius_all(3)
	style.set_content_margin_all(26)
	panel.add_theme_stylebox_override("panel", style)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	return panel


func _rule() -> Panel:
	var rule: Panel = Panel.new()
	rule.custom_minimum_size = Vector2(0, 1)
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = IRON
	rule.add_theme_stylebox_override("panel", style)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rule


func _line(text: String, size: int, colour: Color) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", colour)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _button(text: String) -> Button:
	var button: Button = Button.new()
	button.name = text.replace(" ", "").replace("…", "")
	button.text = text
	button.focus_mode = Control.FOCUS_ALL
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.custom_minimum_size = Vector2(504, 42)
	button.add_theme_font_size_override("font_size", 16)
	button.add_theme_color_override("font_color", TEXT)
	button.add_theme_color_override("font_focus_color", Color(1, 1, 1))
	button.add_theme_color_override("font_hover_color", Color(1, 1, 1))
	button.add_theme_color_override("font_disabled_color", Color(0.38, 0.40, 0.44))
	for state: String in ["normal", "hover", "pressed", "focus", "disabled"]:
		var style: StyleBoxFlat = StyleBoxFlat.new()
		style.bg_color = SLATE_DEEP if state != "focus" else Color(0.12, 0.13, 0.15, 1.0)
		style.border_color = COPPER if state == "focus" or state == "hover" else IRON
		style.set_border_width_all(2 if state == "focus" else 1)
		style.set_corner_radius_all(2)
		style.set_content_margin_all(9)
		button.add_theme_stylebox_override(state, style)
	return button
