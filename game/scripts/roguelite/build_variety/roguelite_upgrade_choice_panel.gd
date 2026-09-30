class_name RogueliteUpgradeChoicePanel
extends FirstMvpModal
## Riftwrought — Roguelite Build Variety V1: one temporary-upgrade choice, of
## exactly two, offered twice per expedition (decision D-223).
##
## IT IS BUILT ON `FirstMvpModal`, THE ACCEPTED GATE 1D CONTRACT — the same
## base the accepted D-222 boon panel is built on, and for the same reason: it
## pauses, neutralizes through the room's own path, focuses first, refuses a
## control that was already held when it opened, and follows the live input
## family for its glyphs, with NO further copy of any of that existing anywhere.
##
## IT EXTENDS THE MODAL AND NOT `RogueliteBoonChoicePanel`, WHICH IS A CHOICE
## WORTH STATING. That panel's `build_contents()` builds one block per entry of
## the fixed two-item `RogueliteRunBoon.offered_kinds()` and ASSERTS there are
## two of them, and its `refresh_contents()` walks three rows whose meaning it
## owns. A subclass here would have had to override both of those wholesale,
## which is copying with extra steps while inheriting an assert about a list it
## no longer uses. `FirstMvpModal` is the contract; this is a second surface on
## it, not a third copy of it.
##
##
## THE BLOCKS ARE BUILT ONCE AND REPOPULATED, AND THE BUTTONS BIND A SLOT
## ---------------------------------------------------------------------------
## `FirstMvpModal` builds its contents once, on `_ready()`. The offers are not
## known then — they are not even the same at the two choices — so the two
## blocks are built empty and filled by `open_for()`.
##
## Each button therefore binds its SLOT INDEX, never an upgrade kind. Binding
## the kind at build time would have frozen the first offer into the buttons for
## the life of the scene: the second choice would have displayed its own two
## options and granted the first choice's. That is the same family as the Gate
## 1E defect where hovering a Foundation Cache card silently re-selected it —
## a control whose visible meaning and bound meaning drift apart.
##
## TWO COMMITTING BUTTONS, NO HOVER SELECTION. Each choice IS its own button, so
## there is no selection state for a pointer to change and the Gate 1E class of
## defect cannot occur here at all.
##
## CANCEL DOES NOT CLOSE IT, AND THE PANEL SAYS SO ON SCREEN. The room's Rift
## Gate stays sealed until the choice is made, so a dismissible panel would
## strand the run behind a gate with no way to open it. Neither button is
## destructive — both grant something — so "the safe control focuses first" has
## no meaning here; the first offered option focuses.
##
## EVERY NUMBER IS COMPUTED FROM THE LIVE RECORDS, NEVER WRITTEN DOWN, and the
## "before" column is the CURRENT state rather than the baseline — so at the
## second choice the panel shows what the first upgrade already did, which is
## the only honest way to present a compounding build. There is no stored
## verdict, no score, no rating and no "recommended" mark: four upgrades on four
## different axes have no common scale, and the project's standing rule against
## a universal upgrade verdict applies to an upgrade exactly as it applies to an
## item.

## The rows every block shows, in order: the caption, and the key the runtime's
## value dictionaries answer it with. Written once so the two blocks, the
## before column and the after column cannot disagree about what a row means.
const ROWS: Array[Dictionary] = [
	{"caption": "Quick Strike Physical Hit", "key": "damage", "format": "%.0f", "higher_is_better": true},
	{"caption": "Hits to this Graveblade", "key": "hits", "format": "%d", "higher_is_better": false},
	{"caption": "Quick Strike action time", "key": "action_time", "format": "%.2f s", "higher_is_better": false},
	{"caption": "Quick Strike reach", "key": "reach", "format": "%.2f m", "higher_is_better": true},
	{"caption": "Quick Strike release arc", "key": "arc", "format": "%.0f°", "higher_is_better": true},
]

var _runtime: RogueliteBuildVarietyRuntime = null

var _title: Label
var _subtitle: Label
var _note: Label
var _blocks: Array[Dictionary] = []
var _buttons: Array[Button] = []

## The offer currently on screen. Replaced on every `open_for()`.
var _offered: Array[int] = []
var _choice_index: int = 0

signal chosen(kind: int)


func modal_name() -> String:
	return "upgrade choice"


func cancel_closes() -> bool:
	return false


func default_focus() -> Control:
	return _buttons[0] if not _buttons.is_empty() else null


func bind_room(owner_room: BrokenWatchSlice) -> void:
	super(owner_room)
	_runtime = owner_room as RogueliteBuildVarietyRuntime


func build_contents() -> void:
	var panel: PanelContainer = make_panel(760)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)

	_title = make_title("A cache opens")
	box.add_child(_title)
	_subtitle = make_line("", 13, TEXT_DIM)
	_subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_subtitle)
	box.add_child(make_rule())

	## Exactly `OPTIONS_PER_CHOICE` blocks, built from the plan's own constant
	## rather than from a literal two, so the panel and the selection cannot
	## disagree about how many options a choice has.
	for slot: int in RogueliteBuildVarietyRunPlan.OPTIONS_PER_CHOICE:
		box.add_child(_build_block(slot))

	box.add_child(make_rule())
	_note = make_line("", 12, TEXT_DIM)
	_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_note)

	panel.add_child(box)
	add_child(panel)

	## Controller navigation is Godot's own focus graph, wired explicitly in
	## both directions so a stick or a D-pad reaches both options and neither
	## button is a dead end — the Gate 1E "Skip hid itself while focused"
	## lesson, which dead-ended the controller.
	for index: int in _buttons.size():
		var here: Button = _buttons[index]
		var there: Button = _buttons[(index + 1) % _buttons.size()]
		here.focus_neighbor_bottom = here.get_path_to(there)
		here.focus_neighbor_top = here.get_path_to(there)
		here.focus_next = here.get_path_to(there)
		here.focus_previous = here.get_path_to(there)


func _build_block(slot: int) -> PanelContainer:
	var block: PanelContainer = PanelContainer.new()
	block.name = "Option%d" % (slot + 1)
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = SLATE_DEEP
	style.border_color = IRON
	style.set_border_width_all(1)
	style.set_corner_radius_all(2)
	style.set_content_margin_all(14)
	block.add_theme_stylebox_override("panel", style)

	var column: VBoxContainer = VBoxContainer.new()
	column.add_theme_constant_override("separation", 6)

	var heading: Label = make_line("", 18, COPPER)
	column.add_child(heading)
	var summary: Label = make_line("", 13, TEXT)
	summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(summary)
	var delivery: Label = make_line("", 12, TEXT_DIM)
	delivery.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(delivery)

	var grid: GridContainer = GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 5)
	var rows: Array[Dictionary] = []
	for row_record: Dictionary in ROWS:
		var caption: Label = make_line(String(row_record["caption"]), 14, TEXT)
		caption.custom_minimum_size = Vector2(250, 0)
		var from: Label = make_line("—", 14, UNCHANGED)
		from.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		from.custom_minimum_size = Vector2(90, 0)
		var arrow: Label = make_line("→", 14, TEXT_DIM)
		var to: Label = make_line("—", 14, UNCHANGED)
		to.custom_minimum_size = Vector2(120, 0)
		grid.add_child(caption)
		grid.add_child(from)
		grid.add_child(arrow)
		grid.add_child(to)
		rows.append({"caption": caption, "from": from, "to": to, "record": row_record})
	column.add_child(grid)

	var footnote: Label = make_line("", 11, TEXT_DIM)
	footnote.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(footnote)

	var button: Button = make_button("Take it", &"ui_confirm")
	button.custom_minimum_size = Vector2(320, 40)
	## THE SLOT IS BOUND, NEVER THE KIND. See the class header.
	button.pressed.connect(_on_choice_pressed.bind(slot))
	var row: HBoxContainer = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_END
	row.add_child(button)
	column.add_child(row)
	_buttons.append(button)

	block.add_child(column)
	_blocks.append({
		"slot": slot, "heading": heading, "summary": summary,
		"delivery": delivery, "footnote": footnote, "rows": rows,
	})
	return block


## The one way this panel is opened. The offer is checked here rather than
## trusted, because "exactly two distinct options, none of them held" is the
## rule the whole review rests on and the surface that shows it should owe it
## too — a guard only in the selection would pass a panel that displayed
## something else.
func open_for(offer: Array[int], choice_index: int, held: Array[int]) -> void:
	assert(offer.size() == RogueliteBuildVarietyRunPlan.OPTIONS_PER_CHOICE,
		"RogueliteUpgradeChoicePanel: a choice offers exactly %d options, not %d" % [
			RogueliteBuildVarietyRunPlan.OPTIONS_PER_CHOICE, offer.size()])
	assert(offer[0] != offer[1],
		"RogueliteUpgradeChoicePanel: both options are %s" % RogueliteUpgrade.name_of(offer[0]))
	for kind: int in offer:
		assert(not held.has(kind),
			"RogueliteUpgradeChoicePanel: %s is already held and must not be offered" % (
				RogueliteUpgrade.name_of(kind)))
	_offered = offer.duplicate()
	_choice_index = choice_index
	open()


func offered_kinds() -> Array[int]:
	return _offered.duplicate()


func choice_index() -> int:
	return _choice_index


func refresh_contents() -> void:
	if _runtime == null or _offered.size() < _blocks.size():
		return
	_title.text = "A cache opens — choice %d of %d" % [
		_choice_index + 1, RogueliteBuildVarietyRunPlan.CHOICES_PER_RUN,
	]
	_subtitle.text = ("Choose one. It lasts for this expedition only, and the Rift Gate stays "
		+ "sealed until you do. You will not be offered anything you already hold.")

	var current: Dictionary = _runtime.live_combat_values()
	for block: Dictionary in _blocks:
		var kind: int = _offered[int(block["slot"])]
		var projected: Dictionary = _runtime.projected_combat_values(kind)
		(block["heading"] as Label).text = RogueliteUpgrade.name_of(kind)
		(block["summary"] as Label).text = RogueliteUpgrade.summary_of(kind)
		(block["delivery"] as Label).text = RogueliteUpgrade.delivery_of(kind)
		var footnote: Label = block["footnote"]
		footnote.text = _footnote_for(kind, current, projected)
		## Hidden rather than left as an empty label: the review's on-screen
		## measurement requires every VISIBLE text control to have a real
		## rectangle, and an empty label is a visible control with none.
		footnote.visible = not footnote.text.is_empty()
		for row: Dictionary in block["rows"]:
			_set_row(row, current, projected)
		_set_button_caption(_button_for(int(block["slot"])),
			"Take the %s" % RogueliteUpgrade.name_of(kind))

	_note.text = ("Nothing you choose is kept. It goes when the expedition does — on death, on "
		+ "abandon, and when the next expedition begins. There is no saving and no permanent "
		+ "progression in this review.")


## The one row the grid cannot carry, stated per option rather than as a
## general footnote: Sweeping Edge moves a SECOND field, and a panel that
## reported only the arc would be quietly incomplete about what it does.
static func _footnote_for(kind: int, current: Dictionary, projected: Dictionary) -> String:
	if kind != RogueliteUpgrade.Kind.SWEEPING_EDGE:
		return ""
	return ("Controller aim assistance widens with it: soft-target cone %.0f° → %.0f° total, "
		+ "so the stick can reach what the wider swing now hits.") % [
		float(current.get("soft_cone", 0.0)), float(projected.get("soft_cone", 0.0)),
	]


func _set_row(row: Dictionary, current: Dictionary, projected: Dictionary) -> void:
	var record: Dictionary = row["record"]
	var key: String = String(record["key"])
	var format: String = String(record["format"])
	var higher_is_better: bool = bool(record["higher_is_better"])
	var from_value: float = float(current.get(key, 0.0))
	var to_value: float = float(projected.get(key, 0.0))
	var from: Label = row["from"]
	var to: Label = row["to"]
	from.text = _format(format, from_value)
	to.text = _format(format, to_value)
	var improved: bool = (to_value > from_value) if higher_is_better else (to_value < from_value)
	## A measured DIRECTION, never a build judgement: green states that this
	## number moved in the player's favour, and says nothing about whether the
	## option is the better one.
	to.add_theme_color_override("font_color", IMPROVED if improved else UNCHANGED)


static func _format(format: String, value: float) -> String:
	return (format % int(round(value))) if format.contains("%d") else (format % value)


func _button_for(slot: int) -> Button:
	return _buttons[slot]


## `FirstMvpModal.make_button()` builds `Button -> HBoxContainer -> Label`, so a
## button's visible caption is a descendant Label's text and writing
## `Button.text` would change nothing anyone can see.
static func _set_button_caption(button: Button, caption: String) -> void:
	for child: Node in button.get_children():
		for grandchild: Node in child.get_children():
			var label: Label = grandchild as Label
			if label != null:
				label.text = caption
				return
	button.text = caption


func _on_choice_pressed(slot: int) -> void:
	if slot >= _offered.size():
		return
	var kind: int = _offered[slot]
	close("chose %s" % RogueliteUpgrade.name_of(kind))
	chosen.emit(kind)


func option_count() -> int:
	return _buttons.size()


func choice_buttons() -> Array[Button]:
	return _buttons


## Every visible control this surface owns, for the on-screen measurement the
## review's verification runs — Gate F shipped a HUD and four modals nobody
## could see while every text assertion passed.
func text_controls() -> Array[Control]:
	var found: Array[Control] = [_title, _subtitle, _note]
	for block: Dictionary in _blocks:
		found.append(block["heading"])
		found.append(block["summary"])
		found.append(block["delivery"])
		found.append(block["footnote"])
		for row: Dictionary in block["rows"]:
			found.append(row["caption"])
			found.append(row["from"])
			found.append(row["to"])
	for button: Button in _buttons:
		found.append(button)
	return found
