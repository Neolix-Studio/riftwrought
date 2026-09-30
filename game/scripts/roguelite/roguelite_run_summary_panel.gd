class_name RogueliteRunSummaryPanel
extends FirstMvpModal
## Riftwrought — Roguelite Core Loop Review: the run-complete state (D-220).
##
## The brief asks for "a simple run-complete state/message" when the last room
## returns the player to the Nexus, and this is deliberately no more than that:
## which run it was, which rooms it cleared, and what happened to the one
## temporary reward. It is built on `FirstMvpModal` — the accepted Gate 1D
## contract — so it pauses, neutralizes through the room's own path, focuses a
## safe control first, refuses a control that was already held, and follows the
## live input family for its glyphs, all without a third copy of any of that
## existing anywhere.
##
## EVERY LINE IS COMPUTED FROM `RogueliteRunState`, NEVER WRITTEN DOWN. There
## is no stored verdict, no score, no rating, no grade and no "run quality"
## number — the project's standing rule against a universal verdict applies to
## a run exactly as it applies to an item.
##
## AND IT AWARDS NOTHING. Completing a run advances no counter that survives
## it: no experience, no currency, no unlock, no mastery, no pursuit progress,
## no permanent record. `design/LONG_TERM_AND_ENDGAME_PROGRESSION.md` §2's
## promise that "every successful endgame run advances at least one visible
## persistent goal" is a first-MVP endgame promise about a game that saves;
## this review has no persistence at all, so it neither honours nor breaks it,
## and that is said here rather than left for a reader to wonder about.

var _headline: Label
var _identity: Label
var _rooms: Label
var _reward: Label
var _note: Label
var _again: Button

var _state: RogueliteRunState = null


func modal_name() -> String:
	return "run summary"


func default_focus() -> Control:
	return _again


func build_contents() -> void:
	var panel: PanelContainer = make_panel(560)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)

	_headline = make_line("Expedition complete", 28, Color(0.68, 0.86, 0.62))
	box.add_child(_headline)
	box.add_child(make_rule())

	_identity = make_line("", 14, TEXT)
	box.add_child(_identity)
	_rooms = make_line("", 14, TEXT)
	box.add_child(_rooms)
	_reward = make_line("", 14, TEXT)
	box.add_child(_reward)

	box.add_child(make_rule())
	_note = make_line("", 12, TEXT_DIM)
	_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_note)

	var buttons: HBoxContainer = HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_END
	_again = make_button("Back to the Nexus", &"ui_confirm")
	# `FirstMvpModal.make_button()` sets a 168 px minimum, sized for Gate 1D's
	# one-word captions ("Close", "Equip"). This caption plus its glyph
	# overflows that, and the rendered evidence showed the glyph printed past
	# the button's own right edge.
	_again.custom_minimum_size = Vector2(272, 42)
	_again.pressed.connect(_on_close_pressed)
	buttons.add_child(_again)
	box.add_child(buttons)

	panel.add_child(box)
	add_child(panel)


func open_for(state: RogueliteRunState) -> void:
	_state = state
	open()


func refresh_contents() -> void:
	if _state == null:
		return
	_identity.text = "%s · seed 0x%08X" % [_state.plan.run_id(), _state.plan.seed_value & 0xFFFFFFFF]
	_rooms.text = "Rooms cleared: %d of %d" % [_state.cleared_rooms.size(), _state.total_rooms()]
	_reward.text = "Temporary reward: %s" % _describe_reward(_state)
	_note.text = ("Nothing here is kept. The next expedition starts from the Worn Blade with a new "
		+ "run identifier, and this review saves nothing to disk at all.")


static func _describe_reward(state: RogueliteRunState) -> String:
	if state.reward_equipped:
		return "Expedition Blade, equipped — and it ends with the run"
	if state.reward_granted:
		return "Expedition Blade granted, left on the ground"
	return "none granted"


func _on_close_pressed() -> void:
	close("acknowledged")


## Every visible control this surface owns, for the on-screen measurement.
func text_controls() -> Array[Control]:
	return [_headline, _identity, _rooms, _reward, _note, _again]
