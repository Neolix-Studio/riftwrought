class_name RogueliteExperienceReviewHud
extends Control
## Riftwrought — Roguelite Experience Collection Greybox Review: the review panel
## (decision D-288).
##
## A DIAGNOSTIC REVIEW SURFACE, NOT FINAL UI. It shows what the review is asking
## the project owner to judge — the run seed, the Rift level, experience against
## the current requirement, how many Graveblades are registered, how many motes
## exist and what became of them, whether automatic pickup is on, and the last
## refusal — and, once experience reaches the requirement, that a level-up is
## ready and that this scene deliberately stops there.
##
## IT READS ONE DICTIONARY OF PLAIN SCALARS AND WRITES NOTHING BACK. Every number
## comes from the review, which asks the accepted mechanisms; this panel names no
## foundation class, holds no runtime, and computes nothing but a bar's width.
##
## PLACEMENT, MEASURED RATHER THAN ASSUMED. Bottom-right, growing UPWARD from a
## fixed bottom edge, so the two level-up lines never push it off the screen. That
## corner is clear of the combat HUD's bottom-left Life and Mana, its centre-top
## hover panel, its centre-bottom item prompt and its top-left messages; of the
## run banner's top-right panel and centre-bottom gate prompt; and of the centre
## of the screen. It is added directly after the run banner, so every modal and
## its backdrop draws over it. The review's verification measures each of those
## rectangles on screen rather than trusting this paragraph.
##
## The same restrained flat placeholder language as the run banner beside it.

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.90)
const IRON: Color = Color(0.28, 0.30, 0.35)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const TEXT_DIM: Color = Color(0.55, 0.58, 0.64)
const MOTE_VIOLET: Color = Color(0.74, 0.56, 1.00)
const REFUSAL: Color = Color(0.88, 0.46, 0.40)
const BAR_EMPTY: Color = Color(0.16, 0.17, 0.20)

const PANEL_WIDTH: float = 300.0
const EDGE_MARGIN: float = 24.0
const CONTENT_MARGIN: float = 12.0
const BAR_WIDTH: float = PANEL_WIDTH - 2.0 * CONTENT_MARGIN
const BAR_HEIGHT: float = 6.0

const LEVEL_UP_TEXT: String = "LEVEL-UP READY"
const LEVEL_UP_NOTE: String = "The three-card offer is the next review; this scene does not open it."

var review: RogueliteExperienceCollectionReview
var panel: PanelContainer

var _title: Label
var _seed: Label
var _level: Label
var _experience: Label
var _bar_fill: ColorRect
var _registered: Label
var _motes: Label
var _pickup: Label
var _refusal: Label
var _level_up_rule: Panel
var _level_up_title: Label
var _level_up_note: Label


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()


func bind_review(owner_review: RogueliteExperienceCollectionReview) -> void:
	review = owner_review
	refresh()


func _build() -> void:
	panel = PanelContainer.new()
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = SLATE
	style.border_color = IRON
	style.set_border_width_all(1)
	style.set_corner_radius_all(3)
	style.set_content_margin_all(CONTENT_MARGIN)
	panel.add_theme_stylebox_override("panel", style)
	panel.custom_minimum_size = Vector2(PANEL_WIDTH, 0.0)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	## Anchored to the bottom-right corner with a zero-height rectangle, growing
	## toward the top-left: the bottom edge stays put however tall it becomes.
	panel.anchor_left = 1.0
	panel.anchor_right = 1.0
	panel.anchor_top = 1.0
	panel.anchor_bottom = 1.0
	panel.offset_left = -EDGE_MARGIN - PANEL_WIDTH
	panel.offset_right = -EDGE_MARGIN
	panel.offset_top = -EDGE_MARGIN
	panel.offset_bottom = -EDGE_MARGIN
	panel.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	panel.grow_vertical = Control.GROW_DIRECTION_BEGIN

	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE

	_title = _line("Rift Experience — Greybox Review", 15, COPPER)
	_seed = _line("", 12, TEXT_DIM)
	_level = _line("", 13, TEXT)
	_experience = _line("", 17, TEXT)
	_registered = _line("", 12, TEXT)
	_motes = _line("", 12, TEXT)
	_pickup = _line("", 12, TEXT)
	_refusal = _line("", 12, TEXT_DIM)
	_refusal.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_level_up_rule = _rule()
	_level_up_title = _line(LEVEL_UP_TEXT, 20, MOTE_VIOLET)
	_level_up_note = _line(LEVEL_UP_NOTE, 12, TEXT_DIM)
	_level_up_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	box.add_child(_title)
	box.add_child(_seed)
	box.add_child(_rule())
	box.add_child(_level)
	box.add_child(_experience)
	box.add_child(_bar())
	box.add_child(_registered)
	box.add_child(_motes)
	box.add_child(_pickup)
	box.add_child(_refusal)
	box.add_child(_level_up_rule)
	box.add_child(_level_up_title)
	box.add_child(_level_up_note)
	panel.add_child(box)
	add_child(panel)


func refresh() -> void:
	if review == null or _title == null:
		return
	var reading: Dictionary = review.experience_review_reading()
	_seed.text = "%s %s" % [String(reading.get("seed_label", "")), String(reading.get("seed", ""))]
	var pickup_on: bool = bool(reading.get("automatic_pickup", false))
	_pickup.text = "Automatic pickup %s — F8 toggles" % ("ON" if pickup_on else "OFF")
	_pickup.add_theme_color_override("font_color", TEXT if pickup_on else COPPER)
	var refusal: String = String(reading.get("last_refusal", ""))
	_refusal.text = "Last refusal: %s" % ("none" if refusal.is_empty() else refusal)
	_refusal.add_theme_color_override("font_color", TEXT_DIM if refusal.is_empty() else REFUSAL)

	if not bool(reading.get("active", false)):
		_level.text = "No expedition in progress"
		_experience.text = "XP —"
		_bar_fill.size = Vector2(0.0, BAR_HEIGHT)
		_registered.text = "Registered enemies 0"
		_motes.text = "Motes 0 total · 0 uncollected · 0 collected"
		_show_level_up(false)
		return

	_level.text = "Rift level %d" % int(reading["level"])
	var experience: float = float(reading["experience"])
	if bool(reading["requirement_ok"]):
		var requirement: int = int(reading["requirement"])
		_experience.text = "XP %s / %d" % [_amount(experience), requirement]
		_bar_fill.size = Vector2(BAR_WIDTH * clampf(experience / float(requirement), 0.0, 1.0), BAR_HEIGHT)
	else:
		_experience.text = "XP %s / — (no requirement: %s)" % [
			_amount(experience), String(reading["requirement_refusal"]),
		]
		_bar_fill.size = Vector2(0.0, BAR_HEIGHT)
	_registered.text = "Registered enemies %d" % int(reading["registered"])
	_motes.text = "Motes %d total · %d uncollected · %d collected" % [
		int(reading["drops"]), int(reading["uncollected"]), int(reading["collected"]),
	]
	_show_level_up(bool(reading["level_up_ready"]))


func _show_level_up(value: bool) -> void:
	_level_up_rule.visible = value
	_level_up_title.visible = value
	_level_up_note.visible = value


## A whole amount is shown as a whole number, anything else to one decimal place —
## never rounded into looking whole.
static func _amount(value: float) -> String:
	if value == floorf(value):
		return "%d" % int(value)
	return "%.1f" % value


# --- Restrained placeholder builders ----------------------------------------

func _line(text: String, size: int, colour: Color) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", colour)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _rule() -> Panel:
	var rule: Panel = Panel.new()
	rule.custom_minimum_size = Vector2(0.0, 1.0)
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = IRON
	rule.add_theme_stylebox_override("panel", style)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rule


func _bar() -> Control:
	var holder: Control = Control.new()
	holder.custom_minimum_size = Vector2(BAR_WIDTH, BAR_HEIGHT)
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var empty: ColorRect = ColorRect.new()
	empty.color = BAR_EMPTY
	empty.size = Vector2(BAR_WIDTH, BAR_HEIGHT)
	empty.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(empty)
	_bar_fill = ColorRect.new()
	_bar_fill.color = MOTE_VIOLET
	_bar_fill.size = Vector2(0.0, BAR_HEIGHT)
	_bar_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(_bar_fill)
	return holder


## Every text control this surface owns, for the on-screen measurement. Gate F
## shipped a HUD nobody could see while every text assertion passed, so the
## property that matters is a rectangle inside the viewport, not a string.
func text_controls() -> Array[Label]:
	return [_title, _seed, _level, _experience, _registered, _motes, _pickup, _refusal,
		_level_up_title, _level_up_note]
