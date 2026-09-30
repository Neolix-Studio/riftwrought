class_name OriginRingPanel
extends FirstMvpModal
## First-MVP — Gate 1E: the first Passive Web interaction (D-219).
##
## `design/FIRST_MVP_CAMPAIGN_AND_PROGRESSION_JOURNEY.md` §7 lists exactly what
## the first Web interaction does, and this panel does that list and nothing
## more:
##
##   * identifies the free Riftmarked Origin
##   * shows Generate, Hold and Shape as three directions
##   * permits one adjacent allocation
##   * explains that respecialization is free in first-MVP safe states
##   * offers planning without demanding a long-term commitment
##
## IT IS DRAWN FROM THE GRAPH, NOT HARD-CODED. The brief: "Do not hard-code a
## one-off nine-button menu that must be thrown away." Every row below is built
## by walking `PassiveGraph.arc_nodes()`; the arcs, the tiers, the effect text,
## the adjacency, the point cost and the live/inert classification all come from
## `PassiveNodeData` records. Adding the 57 remaining canonical nodes adds
## records, and this panel would draw them — a full-Web VIEW is a different
## interface, but the DATA underneath it is already the right shape.
##
## THE HONESTY CONDITION, ON SCREEN, IN WORDS.
## Eight of the nine Origin Ring effects are written in terms of Rift Shards or
## Rift Echo, and neither system exists. Each of those rows says so plainly —
## "No effect yet — Rift Shards are not available yet. You may still allocate it
## and plan ahead." — rather than showing a number that does nothing. The one
## live node, First Fracture, says why it is live: its condition is "while
## holding no Rift Shards", and a character with no Shard system holds none.
##
## Nothing here secretly activates Rift Shards to make the other eight useful.
## The brief forbids exactly that, and `PassiveEffects` refuses to contribute a
## number for a node whose system is absent.
##
## PREVIEW BEFORE CONFIRM. Focusing or hovering a row shows what allocating it
## would cost and produce WITHOUT changing anything; a second, separate press
## commits. `PassiveAllocation.preview()` is pure.
##
## FREE REFUND IN A SAFE STATE. The Nexus is safe, so every allocated node
## offers Refund, and a refund that would strand another allocation is refused
## with a reason naming what it would disconnect.
##
## MOUSE AND CONTROLLER BOTH COMPLETE. Every row is a focusable `Button`, the
## focus graph is wired explicitly up and down each arc and left/right between
## arcs, and the action buttons carry live glyphs through the inherited
## `register_glyph()`. Controller navigation follows Godot's own focus graph,
## which the base class already drives from `ui_up`/`ui_down`/`ui_left`/
## `ui_right`; no InputMap action was added.
##
## DELIBERATELY ABSENT, every one named in the Gate 1E exclusion list: the full
## 66-node Web, the Might/Finesse/Will clusters, Keystones, search, Plan Mode,
## bulk route allocation, Build Lens, and advanced pathing.

const ARC_COLUMN_WIDTH: float = 244.0
const LIVE: Color = Color(0.62, 0.86, 0.58)
const INERT: Color = Color(0.62, 0.60, 0.72)
const ALLOCATED: Color = Color(0.85, 0.58, 0.30)
const LEGAL: Color = Color(0.55, 0.78, 0.92)
const LOCKED: Color = Color(0.42, 0.44, 0.50)

var _points_label: Label
var _origin_label: Label
var _preview_title: Label
var _preview_body: Label
var _safe_state_label: Label
var _allocate: Button
var _refund: Button
var _close: Button

var _rows: Dictionary = {}
var _row_order: Array[StringName] = []
## THE COMMITTED ROW — what Allocate and Refund act on. Set only by a click or by
## controller focus.
var selected: StringName = &""
## What the preview is showing. Hover moves this and nothing else.
##
## With one field, moving the mouse from a row down to the Allocate button
## crossed the other rows, each `mouse_entered` re-selected, and Allocate ended
## up disabled against whichever row the pointer left last — which for the first
## point is almost always an unaffordable tier-2 node. The button appeared broken.
var hovered: StringName = &""

var allocations_made: int = 0
var refunds_made: int = 0


func modal_name() -> String:
	return "the Origin Ring"


func default_focus() -> Control:
	# The safe, non-destructive control. Close changes nothing.
	return _close


func cancel_closes() -> bool:
	return true


func _runtime() -> CanonicalOpeningRuntime:
	return room as CanonicalOpeningRuntime


func _allocation() -> PassiveAllocation:
	var runtime: CanonicalOpeningRuntime = _runtime()
	return runtime.character.passives if runtime != null and runtime.character != null else null


func build_contents() -> void:
	var panel: PanelContainer = make_panel(880)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	add_child(panel)

	var column: VBoxContainer = VBoxContainer.new()
	column.add_theme_constant_override("separation", 12)
	panel.add_child(column)

	column.add_child(make_title("Riftmarked Origin Ring"))
	column.add_child(make_line("Spend Passive Points", 13, TEXT_DIM))
	_origin_label = make_line("", 14, ALLOCATED)
	column.add_child(_origin_label)
	_points_label = make_line("", 15, TEXT)
	column.add_child(_points_label)
	column.add_child(make_rule())

	var arcs: HBoxContainer = HBoxContainer.new()
	arcs.add_theme_constant_override("separation", 18)
	column.add_child(arcs)
	# ONE LOCAL GRAPH FOR ALL THREE ARCS, AND IT IS LOCAL FOR A STRUCTURAL REASON.
	# `build_contents()` is called from `FirstMvpModal._ready()`, which runs BEFORE
	# `bind_room()`, so `room` — and therefore the character's own allocation graph
	# — is still null here. The rows are drawn from this local copy purely to get
	# the canonical arc/tier/name structure; every lookup afterwards goes through
	# `_allocation().graph` by NODE ID, never by object identity, so the two graphs
	# holding different `PassiveNodeData` instances cannot matter. Building one
	# graph rather than one per arc keeps that reasoning to a single place.
	var layout_graph: PassiveGraph = PassiveGraph.new()
	_build_arc(arcs, layout_graph, PassiveNodeData.Arc.GENERATE, "Generate",
		"changes or broadens how Rift Shards are created")
	_build_arc(arcs, layout_graph, PassiveNodeData.Arc.HOLD, "Hold",
		"grants benefits while Shards remain unspent")
	_build_arc(arcs, layout_graph, PassiveNodeData.Arc.SHAPE, "Shape",
		"modifies Rift Echo and other Shaping behavior")

	column.add_child(make_rule())
	_preview_title = make_line("Select a node to preview it", 16, COPPER)
	_preview_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_preview_title)
	_preview_body = make_line("", 14, TEXT)
	_preview_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_preview_body.custom_minimum_size = Vector2(0, 56)
	column.add_child(_preview_body)

	_safe_state_label = make_line(
		"Respecialization is free in first-MVP safe states. You can change this here, now, as often as you like.",
		13, TEXT_DIM
	)
	_safe_state_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_safe_state_label)

	var actions: HBoxContainer = HBoxContainer.new()
	actions.alignment = BoxContainer.ALIGNMENT_END
	actions.add_theme_constant_override("separation", 12)
	column.add_child(actions)

	# NO GLYPH ON REFUND. `FirstMvpModal._input()` swallows `quick_strike` without
	# dispatching it, so advertising that control would promise a button press
	# that does nothing. Refund is reached by focusing it and confirming, like any
	# other control in the panel, and it says so rather than claiming a shortcut.
	_refund = make_button("Refund", &"")
	_refund.pressed.connect(_on_refund)
	actions.add_child(_refund)

	_allocate = make_button("Allocate", &"interact")
	_allocate.pressed.connect(_on_allocate)
	actions.add_child(_allocate)

	_close = make_button("Close", &"ui_cancel")
	_close.pressed.connect(func() -> void: close("closed"))
	actions.add_child(_close)

	_wire_focus_graph()


func _build_arc(
	into: HBoxContainer, graph: PassiveGraph, arc: PassiveNodeData.Arc,
	title: String, subtitle: String
) -> void:
	var column: VBoxContainer = VBoxContainer.new()
	column.name = title
	column.custom_minimum_size = Vector2(ARC_COLUMN_WIDTH, 0)
	column.add_theme_constant_override("separation", 6)
	into.add_child(column)

	column.add_child(make_line(title, 16, COPPER))
	var caption: Label = make_line(subtitle, 12, TEXT_DIM)
	caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(caption)

	for record: PassiveNodeData in graph.arc_nodes(arc):
		var button: Button = _make_node_row(record)
		column.add_child(button)
		_rows[record.node_id] = button
		_row_order.append(record.node_id)


func _make_node_row(record: PassiveNodeData) -> Button:
	var button: Button = Button.new()
	button.name = String(record.node_id)
	button.focus_mode = Control.FOCUS_ALL
	button.custom_minimum_size = Vector2(ARC_COLUMN_WIDTH, 56)
	button.clip_text = false
	button.add_theme_font_size_override("font_size", 14)
	for state: String in ["normal", "hover", "pressed", "focus", "disabled"]:
		var style: StyleBoxFlat = StyleBoxFlat.new()
		style.bg_color = SLATE_DEEP if state != "focus" else Color(0.12, 0.13, 0.15, 1.0)
		style.border_color = COPPER if state == "focus" or state == "hover" else IRON
		style.set_border_width_all(2 if state == "focus" else 1)
		style.set_corner_radius_all(2)
		style.set_content_margin_all(8)
		button.add_theme_stylebox_override(state, style)

	var inner: VBoxContainer = VBoxContainer.new()
	# Named explicitly rather than left to Godot's auto-name, because both
	# `_refresh_row()` and `row_state_text()` resolve through this path and a
	# default name is an invisible coupling between two files.
	inner.name = "Rows"
	inner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inner.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	inner.add_theme_constant_override("separation", 1)
	var name_label: Label = make_line(record.display_name, 14, TEXT)
	name_label.name = "NodeName"
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inner.add_child(name_label)
	var state_label: Label = make_line("", 11, TEXT_DIM)
	state_label.name = "NodeState"
	state_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inner.add_child(state_label)
	button.add_child(inner)

	# A click COMMITS; controller focus commits, because focus IS the controller's
	# selection. The mouse only PREVIEWS.
	button.pressed.connect(func() -> void: _select(record.node_id))
	button.focus_entered.connect(func() -> void: _select(record.node_id))
	button.mouse_entered.connect(func() -> void: _hover(record.node_id))
	button.mouse_exited.connect(func() -> void: _hover(selected))
	return button


## Up and down within an arc, left and right between arcs, and down from the
## bottom of every arc into the action row. Written out rather than left to
## Godot's spatial guess, because a controller must never reach a dead end.
func _wire_focus_graph() -> void:
	var arcs: Array[Array] = [
		[&"first_fracture", &"rift_rhythm", &"fractured_cadence"],
		[&"orbiting_guard", &"quiet_reservoir", &"shardbound_aegis"],
		[&"hastened_echo", &"refined_reflection", &"resonant_shape"],
	]
	for column_index: int in arcs.size():
		var ids: Array = arcs[column_index]
		for row_index: int in ids.size():
			var button: Button = _rows.get(ids[row_index], null)
			if button == null:
				continue
			if row_index > 0:
				button.focus_neighbor_top = (_rows[ids[row_index - 1]] as Button).get_path()
			if row_index + 1 < ids.size():
				button.focus_neighbor_bottom = (_rows[ids[row_index + 1]] as Button).get_path()
			else:
				button.focus_neighbor_bottom = _allocate.get_path()
			if column_index > 0:
				var left: Button = _rows.get(arcs[column_index - 1][row_index], null)
				if left != null:
					button.focus_neighbor_left = left.get_path()
			if column_index + 1 < arcs.size():
				var right: Button = _rows.get(arcs[column_index + 1][row_index], null)
				if right != null:
					button.focus_neighbor_right = right.get_path()
	_refund.focus_neighbor_right = _allocate.get_path()
	_allocate.focus_neighbor_left = _refund.get_path()
	_allocate.focus_neighbor_right = _close.get_path()
	_close.focus_neighbor_left = _allocate.get_path()
	var first: Button = _rows.get(&"first_fracture", null)
	if first != null:
		_allocate.focus_neighbor_top = first.get_path()
		_refund.focus_neighbor_top = first.get_path()
		_close.focus_neighbor_top = first.get_path()


# --- Selection and preview -----------------------------------------------------

func _select(node_id: StringName) -> void:
	selected = node_id
	hovered = node_id
	_refresh_preview()
	_refresh_actions()


## Preview only. `_refresh_actions()` is deliberately NOT called, so Allocate and
## Refund keep answering for the committed row while the pointer wanders.
func _hover(node_id: StringName) -> void:
	hovered = node_id if not String(node_id).is_empty() else selected
	_refresh_preview()


## Pure: it asks `preview()` and `refund_preview()`, which change nothing.
func _refresh_preview() -> void:
	var allocation: PassiveAllocation = _allocation()
	var shown: StringName = hovered if not String(hovered).is_empty() else selected
	if allocation == null or String(shown).is_empty():
		return
	var record: PassiveNodeData = allocation.graph.node(shown)
	if record == null:
		return
	_preview_title.text = "%s — %s %s" % [
		record.display_name, record.arc_name(), record.kind_name().to_lower(),
	]
	var live: bool = PassiveEffects.is_live(record)
	var status: String = PassiveEffects.active_reason(record) if live else PassiveEffects.inactive_reason(record)
	var lines: PackedStringArray = PackedStringArray([record.effect_text, status])
	if allocation.is_allocated(record.node_id):
		var refund: Dictionary = allocation.refund_preview(record.node_id)
		lines.append("Allocated. %s" % refund.get("reason", ""))
	else:
		var preview: Dictionary = allocation.preview(record.node_id)
		if bool(preview.get("legal", false)):
			lines.append("Costs %d point. You would have %d left." % [
				int(preview["cost"]), int(preview["points_after"]),
			])
		else:
			lines.append("Cannot allocate: %s" % preview.get("reason", ""))
	# WHEN HOVER AND CHOICE DISAGREE, SAY SO, so the preview above can never be
	# read as describing what the buttons will do.
	if shown != selected and not String(selected).is_empty():
		var committed: PassiveNodeData = allocation.graph.node(selected)
		if committed != null:
			lines.append("Previewing this. Allocate and Refund still act on %s — click to change that." % committed.display_name)
	_preview_body.text = "\n".join(lines)


func _refresh_actions() -> void:
	var allocation: PassiveAllocation = _allocation()
	if allocation == null:
		return
	var has_selection: bool = not String(selected).is_empty()
	_allocate.disabled = not (has_selection and bool(allocation.preview(selected).get("legal", false)))
	_refund.disabled = not (has_selection and bool(allocation.refund_preview(selected).get("legal", false)))


func refresh_contents() -> void:
	var allocation: PassiveAllocation = _allocation()
	if allocation == null:
		return
	var origin: PassiveNodeData = allocation.graph.origin()
	_origin_label.text = "%s — free, already yours. The Rift Shard mechanic works without spending a point on it." % origin.display_name
	var available: int = allocation.available()
	_points_label.text = "%d Passive point%s available · %d spent of %d earned" % [
		available, "" if available == 1 else "s", allocation.spent(), allocation.earned_points,
	]
	for node_id: StringName in _row_order:
		_refresh_row(node_id, allocation)
	if String(selected).is_empty() and not _row_order.is_empty():
		_select(_row_order[0])
	else:
		_refresh_preview()
		_refresh_actions()


## Allocated, legal-next, and locked are distinguished by COLOUR AND BY WORDS,
## never by colour alone — `design/UI_AND_USER_EXPERIENCE.md` is explicit that
## state must not be a colour-only system.
func _refresh_row(node_id: StringName, allocation: PassiveAllocation) -> void:
	var button: Button = _rows.get(node_id, null)
	if button == null:
		return
	var record: PassiveNodeData = allocation.graph.node(node_id)
	var name_label: Label = button.get_node_or_null("Rows/NodeName") as Label
	var state_label: Label = button.get_node_or_null("Rows/NodeState") as Label
	if name_label == null or state_label == null:
		return
	var live: bool = PassiveEffects.is_live(record)
	if allocation.is_allocated(node_id):
		name_label.add_theme_color_override("font_color", ALLOCATED)
		state_label.text = "ALLOCATED · %s" % ("active" if live else "awaiting its system")
		state_label.add_theme_color_override("font_color", LIVE if live else INERT)
	elif allocation.is_legal_next(node_id):
		name_label.add_theme_color_override("font_color", LEGAL)
		state_label.text = "AVAILABLE NOW · 1 point"
		state_label.add_theme_color_override("font_color", LEGAL)
	if node_id == selected:
		# In WORDS as well as colour, per the canonical no-colour-only rule.
		state_label.text = "%s  ← selected" % state_label.text
	elif allocation.is_adjacent_but_unaffordable(node_id):
		name_label.add_theme_color_override("font_color", LOCKED)
		state_label.text = "NEEDS A POINT"
		state_label.add_theme_color_override("font_color", LOCKED)
	else:
		name_label.add_theme_color_override("font_color", LOCKED)
		state_label.text = "NOT CONNECTED YET"
		state_label.add_theme_color_override("font_color", LOCKED)


# --- Commit --------------------------------------------------------------------

func _on_allocate() -> void:
	var runtime: CanonicalOpeningRuntime = _runtime()
	if runtime == null or String(selected).is_empty():
		return
	if runtime.allocate_passive(selected):
		allocations_made += 1
	refresh_contents()


func _on_refund() -> void:
	var runtime: CanonicalOpeningRuntime = _runtime()
	if runtime == null or String(selected).is_empty():
		return
	if runtime.refund_passive(selected):
		refunds_made += 1
	refresh_contents()


## Every row, for the checks.
func row_ids() -> Array[StringName]:
	return _row_order.duplicate()


func row_state_text(node_id: StringName) -> String:
	var button: Button = _rows.get(node_id, null)
	if button == null:
		return ""
	var state_label: Label = button.get_node_or_null("Rows/NodeState") as Label
	return state_label.text if state_label != null else ""


func preview_text() -> String:
	return "%s\n%s" % [_preview_title.text, _preview_body.text]


func safe_state_text() -> String:
	return _safe_state_label.text


func select_for_verification(node_id: StringName) -> void:
	_select(node_id)


func hover_for_verification(node_id: StringName) -> void:
	_hover(node_id)
