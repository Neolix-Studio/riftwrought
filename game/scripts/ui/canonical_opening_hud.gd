class_name CanonicalOpeningHud
extends Control
## First-MVP — Gate 1E: the character line above Gate 1D's combat HUD (D-219).
##
## Gate 1D's `FirstMvpCombatHud` already owns Life, Mana, the hover panel and
## the item prompt, and it is reused UNMODIFIED — this runtime IS a
## `BrokenWatchSlice`, so that HUD binds to it with no edit at all. This adds
## only what Gate 1E's character has that Gate 1D's did not: a Level, an
## experience bar, available Passive points, and a prompt line for the Nexus
## stations.
##
## RESTRAINED, AND NOT THE CANONICAL HUD.
## `design/UI_AND_USER_EXPERIENCE.md` specifies Wroughtglass Life and Mana
## Reservoirs, three central Rift Shards, eight Skill bindings in two banks,
## upper-left objectives, upper-centre Elite identity, and an upper-right
## minimap. None of that is built here and none of it is faked: Rift Shards do
## not exist, there is no second binding to show, and there is no map. This is
## the same restrained flat placeholder language every prior gate's
## instrumentation used — broad dark slate, iron edges, muted copper — and it is
## not final UI.
##
## BUILT IN CODE, WITH `set_anchors_and_offsets_preset()` RATHER THAN
## `set_anchors_preset()`. That distinction is the documented Gate F defect:
## anchors without offsets over a zero-size rect collapsed the whole HUD and
## every modal to the origin while every text-content check still passed,
## because reading the right words out of a Control tree proves the words exist
## and not that anyone can see them.

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.92)
const IRON: Color = Color(0.28, 0.30, 0.35)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const VIOLET: Color = Color(0.70, 0.45, 0.95)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const TEXT_DIM: Color = Color(0.55, 0.58, 0.64)

const MESSAGE_SECONDS: float = 3.4

var runtime: CanonicalOpeningRuntime

var _level_label: Label
var _experience_fill: ColorRect
var _experience_label: Label
var _points_label: Label
var _message_label: Label
var _message_timer: float = 0.0
var _boundary_panel: PanelContainer
var _boundary_title: Label
var _boundary_detail: Label

var messages_shown: int = 0
var last_message: String = ""


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()


func bind_runtime(owner_runtime: CanonicalOpeningRuntime) -> void:
	runtime = owner_runtime
	refresh()


func _build() -> void:
	# The character strip, upper LEFT, clear of Gate 1D's own HUD which owns the
	# lower corners and the upper centre.
	var panel: PanelContainer = PanelContainer.new()
	panel.name = "CharacterStrip"
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = SLATE
	style.border_color = IRON
	style.set_border_width_all(1)
	style.set_corner_radius_all(3)
	style.set_content_margin_all(10)
	panel.add_theme_stylebox_override("panel", style)
	panel.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	panel.position = Vector2(18, 16)
	panel.custom_minimum_size = Vector2(268, 0)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(panel)

	var column: VBoxContainer = VBoxContainer.new()
	column.add_theme_constant_override("separation", 5)
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_child(column)

	_level_label = _line("Level 1", 17, COPPER)
	column.add_child(_level_label)

	var track: Panel = Panel.new()
	track.name = "ExperienceTrack"
	track.custom_minimum_size = Vector2(244, 7)
	var track_style: StyleBoxFlat = StyleBoxFlat.new()
	track_style.bg_color = Color(0.04, 0.045, 0.055, 1.0)
	track_style.border_color = IRON
	track_style.set_border_width_all(1)
	track.add_theme_stylebox_override("panel", track_style)
	track.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(track)

	_experience_fill = ColorRect.new()
	_experience_fill.name = "ExperienceFill"
	_experience_fill.color = COPPER
	_experience_fill.position = Vector2(1, 1)
	_experience_fill.size = Vector2(0, 5)
	_experience_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	track.add_child(_experience_fill)

	_experience_label = _line("0 / 25 XP", 12, TEXT_DIM)
	column.add_child(_experience_label)

	_points_label = _line("", 14, VIOLET)
	column.add_child(_points_label)

	# The transient message line, upper centre-left under the strip.
	_message_label = _line("", 15, TEXT)
	_message_label.name = "OpeningMessage"
	_message_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	_message_label.position = Vector2(18, 132)
	_message_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_message_label)

	_build_boundary_panel()


## The First Footing boundary card. Centred, and it stays until dismissed
## because it is the end of the slice rather than a passing message.
func _build_boundary_panel() -> void:
	_boundary_panel = PanelContainer.new()
	_boundary_panel.name = "BoundaryCard"
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.055, 0.060, 0.072, 0.97)
	style.border_color = COPPER
	style.set_border_width_all(1)
	style.border_width_top = 3
	style.set_corner_radius_all(3)
	style.set_content_margin_all(22)
	_boundary_panel.add_theme_stylebox_override("panel", style)
	_boundary_panel.set_anchors_preset(Control.PRESET_CENTER)
	# PRESET_CENTER anchors the TOP-LEFT corner to the middle and grows down and
	# right unless the grow directions say otherwise — the Gate F defect that
	# produced four modals nobody could see.
	_boundary_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_boundary_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	_boundary_panel.custom_minimum_size = Vector2(560, 0)
	_boundary_panel.visible = false
	_boundary_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_boundary_panel)

	var column: VBoxContainer = VBoxContainer.new()
	column.add_theme_constant_override("separation", 10)
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_boundary_panel.add_child(column)
	_boundary_title = _line("", 20, COPPER)
	_boundary_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_boundary_title)
	_boundary_detail = _line("", 15, TEXT)
	_boundary_detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_boundary_detail)


func _line(text: String, size: int, colour: Color) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", colour)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


# --- Live values ---------------------------------------------------------------

func refresh() -> void:
	if runtime == null or runtime.character == null:
		return
	var character: CharacterState = runtime.character
	_level_label.text = "Level %d — the %s" % [character.level, character.character_class]
	var progress: Dictionary = character.experience_progress()
	if bool(progress["at_maximum"]):
		_experience_label.text = "maximum defined Level"
		_experience_fill.size.x = 242
	else:
		var into: int = int(progress["into"])
		var span: int = int(progress["span"])
		_experience_label.text = "%d / %d XP toward Level %d" % [into, span, int(progress["next_level"])]
		_experience_fill.size.x = 242.0 * clampf(float(into) / maxf(float(span), 1.0), 0.0, 1.0)
	var available: int = character.available_passive_points()
	if available > 0:
		_points_label.text = "%d Passive point%s available — F1" % [available, "" if available == 1 else "s"]
		_points_label.visible = true
	else:
		_points_label.visible = false


func flash(message: String) -> void:
	messages_shown += 1
	last_message = message
	_message_label.text = message
	_message_timer = MESSAGE_SECONDS
	refresh()


func show_boundary(title: String, detail: String) -> void:
	_boundary_title.text = title
	_boundary_detail.text = detail
	_boundary_panel.visible = true


func boundary_is_shown() -> bool:
	return _boundary_panel != null and _boundary_panel.visible


func _process(delta: float) -> void:
	if _message_timer > 0.0:
		_message_timer -= delta
		if _message_timer <= 0.0:
			_message_label.text = ""
	refresh()


## Every piece of visible text, for the on-screen checks. Reading the words
## proves they exist; the checks pair this with a non-empty rect test, because
## Gate F proved that reading the right words is not the same as anyone being
## able to see them.
func visible_text() -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	_collect_text(self, found)
	return found


func _collect_text(node: Node, into: PackedStringArray) -> void:
	for child: Node in node.get_children():
		var label: Label = child as Label
		if label != null and label.visible and not label.text.strip_edges().is_empty():
			into.append(label.text)
		if child is CanvasItem and (child as CanvasItem).visible:
			_collect_text(child, into)
