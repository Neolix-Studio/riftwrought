class_name RogueliteRunHud
extends Control
## Riftwrought — Roguelite Core Loop Review: the run banner (decision D-220).
##
## A SECOND, THIN SURFACE BESIDE `FirstMvpCombatHud` RATHER THAN AN EDIT TO IT.
## Gate 1D's HUD owns Life, Mana, hover info, the ground-item prompt and the
## transient message line, and it is an accepted, playtested file this review
## must not touch. This one owns only what a RUN has and a slice does not: the
## run's visible identity, where the player is in the expedition, what is left
## alive, and what the gate ahead is doing. It reads the runtime and writes
## nothing back — the same relationship `CanonicalOpeningHud` has with Gate 1E.
##
## It is deliberately placed clear of every region Gate 1D's HUD already uses:
## that one holds bottom-left (resources), centre-top (hover), centre-bottom at
## -140 (item prompt) and top-left at (24, 24) (messages), so the run banner
## takes TOP-RIGHT and the gate prompt sits at centre-bottom ABOVE the item
## prompt. Nothing overlaps, and the review's own verification measures every
## visible label's rectangle on screen rather than trusting that.
##
## NOT FINAL UI. The same restrained flat placeholder language every prior
## gate's instrumentation used — broad dark slate, iron edges, muted copper.

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.90)
const IRON: Color = Color(0.28, 0.30, 0.35)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const TEXT_DIM: Color = Color(0.55, 0.58, 0.64)
const SEALED: Color = Color(0.88, 0.46, 0.40)
const OPEN: Color = Color(0.68, 0.55, 0.95)

var runtime: RogueliteCoreLoopRuntime

var _where: Label
var _subtitle: Label
var _progress: Label
var _threat: Label
var _identity: Label
var _selection: Label
var _reward: Label
var _gate_panel: PanelContainer
var _gate_label: Label


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()


func bind_runtime(owner_runtime: RogueliteCoreLoopRuntime) -> void:
	runtime = owner_runtime
	refresh()


func _build() -> void:
	var panel: PanelContainer = _panel(268)
	panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	panel.position = Vector2(-292, 24)
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE

	_where = _line("Rift Nexus", 17, COPPER)
	_subtitle = _line("", 12, TEXT_DIM)
	_subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_progress = _line("", 13, TEXT)
	_threat = _line("", 13, TEXT)
	_reward = _line("", 12, TEXT_DIM)
	_identity = _line("", 12, TEXT_DIM)
	_selection = _line("", 11, TEXT_DIM)
	_selection.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	box.add_child(_where)
	box.add_child(_subtitle)
	box.add_child(_rule())
	box.add_child(_progress)
	box.add_child(_threat)
	box.add_child(_reward)
	box.add_child(_rule())
	box.add_child(_identity)
	box.add_child(_selection)
	panel.add_child(box)
	add_child(panel)

	_gate_panel = _panel(330)
	_gate_panel.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_gate_panel.position = Vector2(-165, -196)
	_gate_panel.visible = false
	_gate_label = _line("", 14, TEXT)
	_gate_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_gate_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_gate_panel.add_child(_gate_label)
	add_child(_gate_panel)


## THE STATE IS PASSED IN, NEVER INFERRED FROM THE COPY. The first version
## chose the colour with `text.contains("open")`, which painted the hub's own
## always-open Rift Gate in the SEALED colour — inverting the very language the
## rooms teach — and would have broken again the first time the sentence was
## reworded.
func show_gate_prompt(text: String, open: bool) -> void:
	if _gate_panel == null:
		return
	_gate_label.text = text
	_gate_panel.visible = not text.is_empty()
	_gate_label.add_theme_color_override("font_color", OPEN if open else SEALED)


func refresh() -> void:
	if runtime == null or _where == null:
		return
	var state: RogueliteRunState = runtime.run_state
	_identity.text = "%s · seed 0x%08X" % [state.plan.run_id(), state.plan.seed_value & 0xFFFFFFFF]
	_selection.text = "Rooms: %s" % state.plan.selection_mode()

	if runtime.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN:
		var index: int = state.current_room_index
		var module: RogueliteRoomModule = runtime.room_modules[index]
		_where.text = module.display_name()
		_subtitle.text = module.subtitle()
		_progress.text = "Room %d of %d" % [state.room_number(), state.total_rooms()]
		var alive: int = runtime._enemies_alive_in(index)
		_threat.text = ("Cleared — the Rift Gate is open" if alive == 0
			else "Enemies remaining: %d" % alive)
		_threat.add_theme_color_override("font_color", OPEN if alive == 0 else TEXT)
	else:
		_where.text = "Rift Nexus"
		_subtitle.text = ("Expedition complete." if runtime.loop_state == RogueliteCoreLoopRuntime.LoopState.RUN_COMPLETE
			else "Safe. No combat here.")
		_progress.text = "Not in a run — %d room(s) ahead" % state.total_rooms()
		_threat.text = "Walk into the Rift Gate to begin"
		_threat.add_theme_color_override("font_color", TEXT)

	_reward.text = _describe_reward(state)


static func _describe_reward(state: RogueliteRunState) -> String:
	if state.reward_equipped:
		return "Run reward: equipped (temporary)"
	if state.reward_granted:
		return "Run reward: on the ground, not equipped"
	return "Run reward: not yet earned"


# --- Restrained placeholder builders ----------------------------------------

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
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return panel


func _line(text: String, size: int, colour: Color) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", colour)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label


func _rule() -> Panel:
	var rule: Panel = Panel.new()
	rule.custom_minimum_size = Vector2(0, 1)
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = IRON
	rule.add_theme_stylebox_override("panel", style)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rule


## Every visible label this surface owns, for the on-screen measurement the
## review's verification runs. Gate F shipped a HUD and four modals nobody
## could see while every text assertion passed, so the property that matters
## is a non-empty rectangle inside the viewport, not a non-empty string.
func text_controls() -> Array[Label]:
	return [_where, _subtitle, _progress, _threat, _reward, _identity, _selection, _gate_label]
