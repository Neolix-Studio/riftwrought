class_name RiftLevelUpOfferPanel
extends FirstMvpModal
## Riftwrought — Roguelite I2: the three-lane level-up offer, as one modal (decision
## D-293).
##
## IT IS BUILT ON `FirstMvpModal`, THE ACCEPTED GATE 1D CONTRACT, so it pauses the
## world, neutralizes movement and combat intent through the room's own path,
## focuses first, refuses a control already held when it opened, and follows the
## live input family for its glyphs — with no further copy of any of that anywhere.
##
## THREE CARDS, ONE PER LANE OF THE STANDING OFFER, AND NOTHING ELSE. The panel is
## handed plain strings — each lane's label, the card's name and its one detail
## line — and each lane's number, in the offer's own order. It names no Skill,
## support, card, magnitude or foundation class, and it decides nothing: a card
## hands its LANE to the review runtime, and the run's own answer decides whether
## the panel closes.
##
## THE BUTTONS BIND A SLOT, AND A SLOT READS THE LANE THE OFFER PUT THERE. Binding
## a card's content at build time would freeze one offer into the buttons for the
## life of the scene; a slot read at the moment of the press cannot drift from what
## is on screen. That is the lesson the D-223 upgrade panel already records.
##
## EACH CHOICE IS ITS OWN BUTTON, SO HOVER CANNOT SELECT. There is no selection
## state for a pointer to change: moving the mouse over a card focuses nothing and
## chooses nothing — the Gate 1E Foundation Cache defect cannot occur here.
##
## THERE IS NO WAY OUT BUT A CHOICE. No close, skip, reroll or cancel button, and
## cancel/back is refused: `cancel_closes()` answers false, so Esc and (B) leave the
## panel open. Only a successful choice closes it, and the runtime is what closes it —
## or, when that choice has left the run enough experience for its next level, hands it
## that level's own offer to show in place of the one just taken (Roguelite I11, D-314).
##
## A LEFT CLICK REACHES THE CARD UNDER THE POINTER, AND THAT IS INHERITED. The shared
## `FirstMvpModal` contract lets a left PRESS continue to the GUI while a modal is open
## (First-MVP UI J1, decision D-322), so Godot's own hit test delivers the click to the
## card's button and that button's `pressed` connection chooses. From D-293 until J1
## this panel carried its own `_input()` override for exactly that; the rule now lives
## in the contract, and nothing here routes the pointer.

## Exactly the offer's lane count, and the brief's rule: three cards.
const CARD_SLOTS: int = 3

const CARD_WIDTH: float = 320.0
const CARD_SEPARATION: float = 16.0
const REFUSAL: Color = Color(0.88, 0.46, 0.40)

const TITLE_TEXT: String = "Rift level reached — choose one"
const SUBTITLE_TEXT: String = "One card from one lane. A choice is required: there is no skip, reroll or close."
const GREYBOX_NOTE: String = "Choices are recorded in this expedition's temporary build. Applying their effects to the playable character is not part of this review."

var _runtime: RogueliteLevelUpChoiceReview = null

var _title: Label
var _subtitle: Label
var _note: Label
var _refusal: Label
var _cards: Array[Dictionary] = []
var _buttons: Array[Button] = []

## The offer on screen: plain strings, and each slot's lane. Replaced on every open.
var _offered: Array[Dictionary] = []
var _lanes: Array[int] = []

var refusals_shown: int = 0
## Offers shown in place of a just-chosen one while the panel stood (Roguelite I11, D-314).
var replacements: int = 0


func modal_name() -> String:
	return "level-up offer"


func cancel_closes() -> bool:
	return false


func default_focus() -> Control:
	return _buttons[0] if not _buttons.is_empty() else null


func bind_room(owner_room: BrokenWatchSlice) -> void:
	super(owner_room)
	_runtime = owner_room as RogueliteLevelUpChoiceReview


func build_contents() -> void:
	var panel: PanelContainer = make_panel(CARD_SLOTS * CARD_WIDTH + (CARD_SLOTS - 1) * CARD_SEPARATION + 44.0)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)

	_title = make_title(TITLE_TEXT)
	box.add_child(_title)
	_subtitle = make_line(SUBTITLE_TEXT, 13, TEXT_DIM)
	_subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_subtitle)
	box.add_child(make_rule())

	var row: HBoxContainer = HBoxContainer.new()
	row.add_theme_constant_override("separation", int(CARD_SEPARATION))
	for slot: int in CARD_SLOTS:
		row.add_child(_build_card(slot))
	box.add_child(row)

	box.add_child(make_rule())
	_refusal = make_line("", 13, REFUSAL)
	_refusal.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_refusal.visible = false
	box.add_child(_refusal)
	_note = make_line(GREYBOX_NOTE, 12, TEXT_DIM)
	_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_note)

	panel.add_child(box)
	add_child(panel)

	## Controller and keyboard navigation is Godot's own focus graph, wired
	## explicitly in both directions and around the ends, so arrows, a stick or a
	## D-pad reach every card and none is a dead end.
	for index: int in _buttons.size():
		var here: Button = _buttons[index]
		var right: Button = _buttons[(index + 1) % _buttons.size()]
		var left: Button = _buttons[(index + _buttons.size() - 1) % _buttons.size()]
		here.focus_neighbor_right = here.get_path_to(right)
		here.focus_neighbor_left = here.get_path_to(left)
		here.focus_neighbor_top = here.get_path_to(here)
		here.focus_neighbor_bottom = here.get_path_to(here)
		here.focus_next = here.get_path_to(right)
		here.focus_previous = here.get_path_to(left)


func _build_card(slot: int) -> PanelContainer:
	var block: PanelContainer = PanelContainer.new()
	block.name = "Card%d" % (slot + 1)
	block.custom_minimum_size = Vector2(CARD_WIDTH, 0.0)
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = SLATE_DEEP
	style.border_color = IRON
	style.set_border_width_all(1)
	style.set_corner_radius_all(2)
	style.set_content_margin_all(14)
	block.add_theme_stylebox_override("panel", style)

	var column: VBoxContainer = VBoxContainer.new()
	column.add_theme_constant_override("separation", 8)
	var lane: Label = make_line("", 13, TEXT_DIM)
	column.add_child(lane)
	var title: Label = make_line("", 22, TEXT)
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(title)
	var detail: Label = make_line("", 15, COPPER)
	detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(detail)
	var spacer: Control = Control.new()
	spacer.custom_minimum_size = Vector2(0.0, 10.0)
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(spacer)

	var button: Button = make_button("Choose", &"ui_confirm")
	button.name = "Choose%d" % (slot + 1)
	button.custom_minimum_size = Vector2(CARD_WIDTH - 28.0, 42.0)
	## THE SLOT IS BOUND, NEVER THE CONTENT. See the class header.
	button.pressed.connect(_on_card_pressed.bind(slot))
	column.add_child(button)
	_buttons.append(button)

	block.add_child(column)
	_cards.append({"block": block, "lane": lane, "title": title, "detail": detail})
	return block


## The one way this panel shows an offer: one card per lane of the standing offer, in
## its order. Anything other than exactly `CARD_SLOTS` cards is refused rather than
## shown half-filled.
##
## CLOSED, IT OPENS over the offer through the accepted contract.
##
## ALREADY OPEN, IT SHOWS THE NEW OFFER IN PLACE OF THE ONE ON SCREEN (Roguelite I11,
## decision D-314). When a choice leaves the run enough experience for its next level,
## that level's own offer is handed here while the panel still stands, and its three
## cards take the place of the ones just chosen. Nothing is closed, reopened,
## neutralized again or let go, so the world the panel held when it first opened is
## never released between the two offers. What the contract does on opening is done
## again for the new offer — its cards and captions shown, no refusal left over, the
## first card focused — and so is the contract's held-input rule: a control still held
## from the choice that took the previous card cannot act on the new offer until it has
## been released.
func open_for_offer(cards: Array[Dictionary]) -> bool:
	if cards.size() != CARD_SLOTS:
		push_error("RiftLevelUpOfferPanel: an offer is shown as exactly %d cards, not %d" % [CARD_SLOTS, cards.size()])
		return false
	_offered = cards.duplicate(true)
	_lanes.clear()
	for card: Dictionary in _offered:
		_lanes.append(int(card["lane"]))
	_refusal.text = ""
	_refusal.visible = false
	if not is_open:
		open()
		return true
	## The contract's own arming rule, as `open()` applies it, applied to the new offer.
	for action: StringName in _armed.keys():
		_armed[action] = not Input.is_action_pressed(action)
	refresh_contents()
	var focus: Control = default_focus()
	if focus != null:
		focus.grab_focus()
		last_focus_name = focus.name
	replacements += 1
	return true


func refresh_contents() -> void:
	if _offered.size() != _cards.size():
		return
	for slot: int in _cards.size():
		var card: Dictionary = _cards[slot]
		var offered: Dictionary = _offered[slot]
		(card["lane"] as Label).text = String(offered["lane_label"])
		(card["title"] as Label).text = String(offered["title"])
		(card["detail"] as Label).text = String(offered["detail"])
		_set_button_caption(_buttons[slot], "Choose %s" % String(offered["title"]))


## Shows the run's own refusal, word for word, and leaves everything else as it was:
## the panel open, the world paused, the same cards and the focus where it was.
func show_refusal(reason: String) -> void:
	refusals_shown += 1
	_refusal.text = "That choice was refused: %s" % reason
	_refusal.visible = true


## Replaces the greybox note beneath the cards (Roguelite I3, D-295). A review that
## extends this one applies a choice's covered effects, so the default note would be
## false there, and it states its own. Nothing in this review calls it: here the note
## is `GREYBOX_NOTE`, unchanged.
func set_note_text(text: String) -> void:
	_note.text = text


func _on_card_pressed(slot: int) -> void:
	if not is_open or slot < 0 or slot >= _lanes.size() or _runtime == null:
		return
	_runtime.choose_offered_lane(_lanes[slot])


## `FirstMvpModal.make_button()` builds `Button -> HBoxContainer -> Label`, so a
## button's visible caption is its first descendant Label's text.
static func _set_button_caption(button: Button, caption: String) -> void:
	for child: Node in button.get_children():
		for grandchild: Node in child.get_children():
			var label: Label = grandchild as Label
			if label != null:
				label.text = caption
				return
	button.text = caption


# --- Readings for the verification ---------------------------------------------------

func card_count() -> int:
	return _cards.size()


func card_buttons() -> Array[Button]:
	return _buttons


func lane_for_slot(slot: int) -> int:
	return _lanes[slot]


## The three visible lines of card `slot`, as shown.
func card_lines(slot: int) -> PackedStringArray:
	var card: Dictionary = _cards[slot]
	return PackedStringArray([(card["lane"] as Label).text, (card["title"] as Label).text,
		(card["detail"] as Label).text])


func card_block(slot: int) -> Control:
	return _cards[slot]["block"]


func refusal_text() -> String:
	return _refusal.text if _refusal.visible else ""


func note_text() -> String:
	return _note.text


## Every visible control this surface owns, for the on-screen measurement.
func text_controls() -> Array[Control]:
	var found: Array[Control] = [_title, _subtitle]
	for card: Dictionary in _cards:
		found.append(card["lane"])
		found.append(card["title"])
		found.append(card["detail"])
	for button: Button in _buttons:
		found.append(button)
	found.append(_refusal)
	found.append(_note)
	return found
