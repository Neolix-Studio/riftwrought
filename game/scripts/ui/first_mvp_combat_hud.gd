class_name FirstMvpCombatHud
extends Control
## First-MVP — Gate 1D: the minimum truthful combat HUD (decision D-217).
##
## Prototype Zero's `PrototypeHUD` is explicitly NOT reused wholesale: it is
## duck-typed against `PrototypeZeroRoom`'s exact member names, hardcodes the
## `"quick_strike"` skill-slot glyph, and shows XP/weapon-comparison assumptions
## that do not apply here (Gate 1D has no Rift Shards, no Skill Configuration,
## no Passive Web). This is a narrower, code-built Control — never scene-
## instanced, exactly like `PrototypeHUD` — showing only what Gate 1D's brief
## calls "the minimum truthful HUD/state needed for this slice":
##
##   current / maximum Life
##   current / maximum Mana
##   a hover-info panel — PRODUCTION mouse rule: hovering an enemy reveals its
##     name and Life bar only. This is INFORMATION, never a mechanical
##     selection; nothing here is written to whatever Quick Strike acquisition
##     reads. See `BrokenWatchSlice._mouse_aim_provider()`.
##   an interaction prompt for the ground item, when one is present
##
## No Character Sheet, no advanced tooltip, no Attributes & Damage Model
## surface — the brief is explicit that those wait for a later gate, and that
## THIS surface must be architected so the wider model can be added later
## without encoding a contradiction (each row below reads a plain float pair;
## nothing here assumes Life/Mana can never gain a second layer).

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.90)
const IRON: Color = Color(0.28, 0.30, 0.35)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const TEXT_DIM: Color = Color(0.55, 0.58, 0.64)
const LIFE_COLOUR: Color = Color(0.78, 0.26, 0.24)
const MANA_COLOUR: Color = Color(0.30, 0.52, 0.82)

var room: BrokenWatchSlice

var _life_fill: ColorRect
var _life_label: Label
var _mana_fill: ColorRect
var _mana_label: Label
var _hover_panel: PanelContainer
var _hover_name: Label
var _hover_fill: ColorRect
var _prompt_panel: PanelContainer
var _prompt_label: Label
var _message_label: Label
var _message_timer: float = 0.0

const MESSAGE_SECONDS: float = 3.0
const BAR_WIDTH: float = 260.0
const BAR_HEIGHT: float = 22.0


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()


func bind_room(owner_room: BrokenWatchSlice) -> void:
	room = owner_room
	room.player.life_changed.connect(_on_life_changed)
	room.player.mana_changed.connect(_on_mana_changed)
	_on_life_changed(room.player.life, room.player.max_life)
	_on_mana_changed(room.player.mana, room.player.max_mana)


func _build() -> void:
	var resources: VBoxContainer = VBoxContainer.new()
	resources.name = "Resources"
	resources.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	# First-MVP UI J8 (decision D-336): the column is anchored by its bottom edge,
	# 24 px above the viewport's, and grows upward to its own height. A top edge
	# 80 px above the bottom left the 94 px column's last 14 px below the window.
	resources.offset_left = 24.0
	resources.offset_top = -24.0
	resources.offset_right = 24.0
	resources.offset_bottom = -24.0
	resources.grow_vertical = Control.GROW_DIRECTION_BEGIN
	resources.add_theme_constant_override("separation", 6)
	resources.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var life_row: Dictionary = _bar_row("Life", LIFE_COLOUR)
	resources.add_child(life_row["row"])
	_life_fill = life_row["fill"]
	_life_label = life_row["label"]

	var mana_row: Dictionary = _bar_row("Mana", MANA_COLOUR)
	resources.add_child(mana_row["row"])
	_mana_fill = mana_row["fill"]
	_mana_label = mana_row["label"]

	add_child(resources)

	# Hover-info panel: name + a quiet Life fraction, upper-centre, above the
	# framing the fixed camera already reserves for objectives. Production
	# rule: this is the ONLY effect hovering an enemy has.
	_hover_panel = _panel(220)
	_hover_panel.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_hover_panel.position = Vector2(-110, 18)
	_hover_panel.visible = false
	var hover_box: VBoxContainer = VBoxContainer.new()
	hover_box.add_theme_constant_override("separation", 4)
	_hover_name = _line("", 15, TEXT)
	_hover_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hover_box.add_child(_hover_name)
	var hover_bar_bg: PanelContainer = PanelContainer.new()
	hover_bar_bg.custom_minimum_size = Vector2(190, 10)
	var hover_style: StyleBoxFlat = StyleBoxFlat.new()
	hover_style.bg_color = Color(0.10, 0.11, 0.13)
	hover_style.set_corner_radius_all(2)
	hover_bar_bg.add_theme_stylebox_override("panel", hover_style)
	_hover_fill = ColorRect.new()
	_hover_fill.color = LIFE_COLOUR
	_hover_fill.custom_minimum_size = Vector2(190, 10)
	# First-MVP UI J7 (decision D-334): the hover fill keeps the width its own
	# minimum size gives it, as the resource fills have since J6. The PanelContainer
	# stretched a filling child across the whole bar whenever it sorted, so the
	# panel appeared with a full-width fill.
	_hover_fill.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	hover_bar_bg.add_child(_hover_fill)
	hover_box.add_child(hover_bar_bg)
	_hover_panel.add_child(hover_box)
	add_child(_hover_panel)

	# Interaction prompt for the ground drop, lower-centre.
	_prompt_panel = _panel(300)
	_prompt_panel.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_prompt_panel.position = Vector2(-150, -140)
	_prompt_panel.visible = false
	_prompt_label = _line("", 14, TEXT)
	_prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_prompt_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_prompt_panel.add_child(_prompt_label)
	add_child(_prompt_panel)

	# A restrained transient message line, upper-left, for refusals and cues
	# ("Not enough Mana", "The Watch lies still ahead") — text only, no toast
	# stack, matching every prior gate's restrained instrumentation.
	_message_label = _line("", 13, TEXT_DIM)
	_message_label.set_anchors_preset(Control.PRESET_TOP_LEFT)
	_message_label.position = Vector2(24, 24)
	_message_label.visible = false
	add_child(_message_label)


func _bar_row(caption: String, fill_colour: Color) -> Dictionary:
	var row: VBoxContainer = VBoxContainer.new()
	row.add_theme_constant_override("separation", 2)
	var label: Label = _line("%s —" % caption, 13, TEXT_DIM)
	row.add_child(label)
	var background: PanelContainer = PanelContainer.new()
	background.custom_minimum_size = Vector2(BAR_WIDTH, BAR_HEIGHT)
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = SLATE
	style.border_color = IRON
	style.set_border_width_all(1)
	style.set_corner_radius_all(2)
	background.add_theme_stylebox_override("panel", style)
	var fill: ColorRect = ColorRect.new()
	fill.color = fill_colour
	fill.custom_minimum_size = Vector2(BAR_WIDTH, BAR_HEIGHT)
	# First-MVP UI J6 (decision D-332): the fill keeps the width its own minimum
	# size gives it. A PanelContainer lays a filling child across its whole
	# content rect on every sort, which overrode the fractional width
	# `_on_life_changed()` and `_on_mana_changed()` write and drew every bar full.
	fill.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	background.add_child(fill)
	row.add_child(background)
	return {"row": row, "fill": fill, "label": label}


func _panel(width: float) -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = SLATE
	style.border_color = IRON
	style.set_border_width_all(1)
	style.set_corner_radius_all(3)
	style.set_content_margin_all(12)
	panel.add_theme_stylebox_override("panel", style)
	panel.custom_minimum_size = Vector2(width, 0)
	return panel


func _line(text: String, size: int, colour: Color) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", colour)
	return label


# --- Live updates --------------------------------------------------------------

func _on_life_changed(current: float, maximum: float) -> void:
	var fraction: float = clampf(current / maxf(maximum, 0.0001), 0.0, 1.0)
	_life_fill.custom_minimum_size = Vector2(BAR_WIDTH * fraction, BAR_HEIGHT)
	_life_fill.size.x = BAR_WIDTH * fraction
	_life_label.text = "Life — %.0f / %.0f" % [current, maximum]


func _on_mana_changed(current: float, maximum: float) -> void:
	var fraction: float = clampf(current / maxf(maximum, 0.0001), 0.0, 1.0)
	_mana_fill.custom_minimum_size = Vector2(BAR_WIDTH * fraction, BAR_HEIGHT)
	_mana_fill.size.x = BAR_WIDTH * fraction
	_mana_label.text = "Mana — %.0f / %.0f" % [current, maximum]


## `enemy` is the currently HOVERED target, or null. This is the whole effect
## of hover — a display update, never a write into acquisition state.
func show_hover(enemy: PrototypeGraveblade) -> void:
	if enemy == null or not enemy.is_alive():
		_hover_panel.visible = false
		return
	_hover_panel.visible = true
	_hover_name.text = enemy.data.display_name if enemy.data != null else "Graveblade"
	var fraction: float = clampf(enemy.life / maxf(enemy.data.max_life, 0.0001), 0.0, 1.0)
	# First-MVP UI J7 (decision D-334): the minimum size follows the fraction. A
	# fixed 190 x 10 minimum held the fill at 190 px against the write below.
	_hover_fill.custom_minimum_size = Vector2(190.0 * fraction, 10.0)
	_hover_fill.size.x = 190.0 * fraction


func show_item_prompt(text: String) -> void:
	_prompt_panel.visible = not text.is_empty()
	_prompt_label.text = text


func show_message(text: String) -> void:
	_message_label.text = text
	_message_label.visible = true
	_message_timer = MESSAGE_SECONDS


func _process(delta: float) -> void:
	if _message_timer <= 0.0:
		return
	_message_timer -= delta
	if _message_timer <= 0.0:
		_message_label.visible = false
