class_name RogueliteBoonChoicePanel
extends FirstMvpModal
## Riftwrought — Roguelite Replayability V1: the one temporary-reward choice
## (decision D-222).
##
## EXACTLY TWO CHOICES, AND THE PANEL PROVES IT RATHER THAN ASSUMING IT. It
## builds one block per entry in `RogueliteRunBoon.offered_kinds()` and asserts
## that there are two of them, so a third choice cannot arrive by accident. The
## review's brief asks for exactly two readable choices and this is the file
## that owes that.
##
## IT IS BUILT ON `FirstMvpModal`, THE ACCEPTED GATE 1D CONTRACT, so it pauses,
## neutralizes through the room's own path, focuses first, refuses a control
## that was already held when it opened, and follows the live input family for
## its glyphs — with no third copy of any of that existing anywhere.
##
## EVERY NUMBER IS COMPUTED FROM THE RECORDS, NEVER WRITTEN DOWN. Damage per
## Hit and Hits-to-defeat come from `PrototypeWeaponData` itself; the attack
## time comes from `QuickStrikeData.effective_action_time()`, the same function
## the kernel obeys. There is no stored verdict, no score, no rating and no
## "recommended" mark: one choice changes damage per Hit and the other changes
## Hits per second, they are not comparable on one axis, and the project's
## standing rule against a universal upgrade verdict applies to a boon exactly
## as it applies to an item.
##
## TWO COMMITTING BUTTONS, NO HOVER SELECTION, AND THAT IS A DEFECT AVOIDED BY
## CONSTRUCTION. Gate 1E's Foundation Cache used selectable cards plus a
## separate Choose button, and its adversarial review found that HOVERING a
## card silently re-selected it — so moving the mouse toward Choose committed
## whichever card the pointer had left last, and that choice latched for the
## character's life. Here each choice IS its own button: there is no selection
## state for a pointer to change, so the class of defect cannot occur.
##
## CANCEL DOES NOT CLOSE IT, AND THE PANEL SAYS SO ON SCREEN. The reward beat's
## Rift Gate stays sealed until the choice is made, so a panel that could be
## dismissed would strand the run behind a gate with no way to open it. Neither
## button is destructive — both grant something — so "the safe control focuses
## first" has no meaning here; the first offered choice focuses, and the panel
## states plainly that a choice is required.

## Which Graveblade the "Hits to" row is computed against. Read from the live
## roster through the runtime, never written down, so the row states the enemy
## the player is actually about to meet.
var _runtime: RogueliteReplayabilityRuntime = null

var _title: Label
var _subtitle: Label
var _note: Label
var _blocks: Array[Dictionary] = []
var _buttons: Array[Button] = []

signal chosen(kind: int)


func modal_name() -> String:
	return "boon choice"


func cancel_closes() -> bool:
	return false


func default_focus() -> Control:
	return _buttons[0] if not _buttons.is_empty() else null


func bind_room(owner_room: BrokenWatchSlice) -> void:
	super(owner_room)
	_runtime = owner_room as RogueliteReplayabilityRuntime


func build_contents() -> void:
	var offered: Array[int] = RogueliteRunBoon.offered_kinds()
	assert(offered.size() == 2,
		"RogueliteBoonChoicePanel: the brief asks for exactly two choices, not %d" % offered.size())

	var panel: PanelContainer = make_panel(680)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)

	_title = make_title("The cache opens")
	box.add_child(_title)
	_subtitle = make_line(
		"Choose one. It lasts for this expedition only, and the Rift Gate stays sealed until you do.",
		13, TEXT_DIM
	)
	_subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_subtitle)
	box.add_child(make_rule())

	for kind: int in offered:
		box.add_child(_build_block(kind))

	box.add_child(make_rule())
	_note = make_line("", 12, TEXT_DIM)
	_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_note)

	panel.add_child(box)
	add_child(panel)

	## Controller navigation is Godot's own focus graph, wired explicitly in
	## both directions so a stick or a D-pad reaches both choices and neither
	## button is a dead end — the Gate 1E "Skip hid itself while focused"
	## lesson, which dead-ended the controller.
	for index: int in _buttons.size():
		var here: Button = _buttons[index]
		var there: Button = _buttons[(index + 1) % _buttons.size()]
		here.focus_neighbor_bottom = here.get_path_to(there)
		here.focus_neighbor_top = here.get_path_to(there)
		here.focus_next = here.get_path_to(there)
		here.focus_previous = here.get_path_to(there)


func _build_block(kind: int) -> PanelContainer:
	var block: PanelContainer = PanelContainer.new()
	block.name = "Choice_%s" % RogueliteRunBoon.name_of(kind).replace(" ", "")
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = SLATE_DEEP
	style.border_color = IRON
	style.set_border_width_all(1)
	style.set_corner_radius_all(2)
	style.set_content_margin_all(14)
	block.add_theme_stylebox_override("panel", style)

	var column: VBoxContainer = VBoxContainer.new()
	column.add_theme_constant_override("separation", 6)

	var heading: Label = make_line(RogueliteRunBoon.name_of(kind), 18, COPPER)
	column.add_child(heading)
	var delivery: Label = make_line(RogueliteRunBoon.delivery_of(kind), 12, TEXT_DIM)
	delivery.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(delivery)

	var grid: GridContainer = GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 6)
	var rows: Array[Dictionary] = []
	for caption_text: String in ["Quick Strike Physical Hit", "Hits to this Graveblade", "Quick Strike action time"]:
		var caption: Label = make_line(caption_text, 14, TEXT)
		caption.custom_minimum_size = Vector2(250, 0)
		var from: Label = make_line("—", 14, UNCHANGED)
		from.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		from.custom_minimum_size = Vector2(80, 0)
		var arrow: Label = make_line("→", 14, TEXT_DIM)
		var to: Label = make_line("—", 14, UNCHANGED)
		to.custom_minimum_size = Vector2(110, 0)
		grid.add_child(caption)
		grid.add_child(from)
		grid.add_child(arrow)
		grid.add_child(to)
		rows.append({"caption": caption, "from": from, "to": to})
	column.add_child(grid)

	var button: Button = make_button("Take the %s" % RogueliteRunBoon.name_of(kind), &"ui_confirm")
	button.custom_minimum_size = Vector2(300, 40)
	button.pressed.connect(_on_choice_pressed.bind(kind))
	var row: HBoxContainer = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_END
	row.add_child(button)
	column.add_child(row)
	_buttons.append(button)

	block.add_child(column)
	_blocks.append({"kind": kind, "heading": heading, "delivery": delivery, "rows": rows})
	return block


func refresh_contents() -> void:
	if _runtime == null:
		return
	var worn: PrototypeWeaponData = _runtime.worn_blade_record()
	var blade: PrototypeWeaponData = _runtime.expedition_blade_record()
	var strike: QuickStrikeData = _runtime.canonical_quick_strike_record()
	var life: float = _runtime.graveblade_max_life()
	var base_time: float = strike.action_time

	for block: Dictionary in _blocks:
		var kind: int = int(block["kind"])
		var candidate: PrototypeWeaponData = blade if kind == RogueliteRunBoon.Kind.EXPEDITION_BLADE else worn
		var increase: float = (RogueliteRunBoon.QUICKENED_INCREASE
			if kind == RogueliteRunBoon.Kind.QUICKENED_EDGE else 0.0)
		var rows: Array = block["rows"]
		_set_row(rows[0], "%.0f" % worn.physical_damage, "%.0f" % candidate.physical_damage,
			candidate.physical_damage > worn.physical_damage)
		_set_row(rows[1], "%d" % worn.hits_to_defeat(life), "%d" % candidate.hits_to_defeat(life),
			candidate.hits_to_defeat(life) < worn.hits_to_defeat(life))
		## Computed through the record's own function, which is the one the
		## kernel obeys — never a literal, and never a second formula.
		_set_row(rows[2], "%.2f s" % base_time,
			"%.2f s" % strike.effective_action_time(increase), increase > 0.0)

	_note.text = ("Nothing you choose is kept. It goes when the expedition does — on death, on "
		+ "abandon, and when the next expedition begins. There is no saving and no permanent "
		+ "progression in this review.")


static func _set_row(row: Dictionary, from_text: String, to_text: String, improved: bool) -> void:
	var from: Label = row["from"]
	var to: Label = row["to"]
	from.text = from_text
	to.text = to_text
	## A measured DIRECTION, never a build judgement: green states that this
	## number moved in the player's favour, and says nothing about whether the
	## choice is the better one.
	to.add_theme_color_override("font_color", IMPROVED if improved else UNCHANGED)


func _on_choice_pressed(kind: int) -> void:
	close("chose %s" % RogueliteRunBoon.name_of(kind))
	chosen.emit(kind)


func choice_count() -> int:
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
		found.append(block["delivery"])
		for row: Dictionary in block["rows"]:
			found.append(row["caption"])
			found.append(row["from"])
			found.append(row["to"])
	for button: Button in _buttons:
		found.append(button)
	return found
