class_name GateCCombatOverlay
extends Control
## Prototype Zero — Gate C combat instrumentation (specification §22).
##
## Development instrumentation, NOT the Prototype HUD from §17: there is no
## Wroughtglass reservoir, no Skill bank, no Rift Shards, no objective, and no
## minimap, because none of those exist yet. The Mana readout here is a debug
## number with a bar behind it, not the HUD's lower-right reservoir.
##
## It exists so the Gate C contract can be READ while playing: state transitions,
## the Skill Use ID, the release-query count, cancellation timing, the targeting
## decision and why it was made, Mana spending, and the repeat cadence.
##
## The instruction card is always visible; the detailed block is behind F3, so the
## room can be played without a wall of numbers.

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.88)
const IRON: Color = Color(0.24, 0.26, 0.30)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const DIM: Color = Color(0.55, 0.58, 0.64)

var room: PrototypeZeroRoom

var _instructions: RichTextLabel
var _detail_panel: PanelContainer
var _detail: RichTextLabel
var _mana_bar: ProgressBar
var _mana_label: Label


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()


func bind_room(owner_room: PrototypeZeroRoom) -> void:
	room = owner_room


func toggle_detail() -> void:
	_detail_panel.visible = not _detail_panel.visible


func set_detail_visible(value: bool) -> void:
	_detail_panel.visible = value


func _build() -> void:
	var card: PanelContainer = _panel()
	card.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	card.position = Vector2(-470, -250)
	card.custom_minimum_size = Vector2(430, 0)
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	box.add_child(_label("Gate C — Quick Strike kernel", 17, COPPER))
	_instructions = _rich(14)
	box.add_child(_instructions)

	var mana_row: VBoxContainer = VBoxContainer.new()
	mana_row.add_theme_constant_override("separation", 2)
	_mana_label = _label("Mana 100 / 100", 14, TEXT)
	_mana_bar = ProgressBar.new()
	_mana_bar.max_value = 100.0
	_mana_bar.value = 100.0
	_mana_bar.show_percentage = false
	_mana_bar.custom_minimum_size = Vector2(0, 10)
	mana_row.add_child(_mana_label)
	mana_row.add_child(_mana_bar)
	box.add_child(mana_row)
	card.add_child(box)
	add_child(card)

	# Left column, below the Gate B instruction panels and above the calibration
	# readout. The right column already
	# carries the leak-test panel and the Gate B F3 block, and stacking a third
	# panel there overlapped it.
	_detail_panel = _panel()
	_detail_panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	_detail_panel.position = Vector2(28, 468)
	_detail_panel.custom_minimum_size = Vector2(430, 0)
	_detail = _rich(13)
	_detail_panel.add_child(_detail)
	_detail_panel.visible = false
	add_child(_detail_panel)


func _process(_delta: float) -> void:
	if room == null or room.player == null or room.player.attack == null:
		return
	_update_instructions()
	_update_mana()
	if _detail_panel.visible:
		_update_detail()


func _update_instructions() -> void:
	var controller: bool = room.input_family.family == InputFamilyTracker.Family.CONTROLLER
	var data: QuickStrikeData = room.player.attack.data
	if controller:
		_instructions.text = (
			"[color=#d6dae1][b]West face button[/b] — Quick Strike.[/color]\n" +
			"[color=#7b828d]Aim with the left stick. The ringed post is the current\n" +
			"soft target: %.0f m, %.0f deg total (%.1f deg either side), facing\n" % [
				data.soft_target_distance, data.soft_target_cone_total_degrees(),
				data.soft_target_cone_half_degrees(),
			] +
			"when neutral. A post already inside the %.2f m reach wins first.\n" % data.reach +
			"Hold to repeat. Move during the wind-up to cancel it.[/color]"
		)
	else:
		_instructions.text = (
			"[color=#d6dae1][b]Right click[/b] a post to strike it; it walks into reach first.\n" +
			"[b]Right click[/b] the floor to swing where the cursor points.[/color]\n" +
			"[color=#7b828d]Hold right mouse to repeat. Hold [b]Shift[/b] to attack in place\n" +
			"with no approach. Move during the wind-up to cancel it.[/color]"
		)


func _update_mana() -> void:
	var player: PrototypePlayer = room.player
	_mana_bar.max_value = player.max_mana
	_mana_bar.value = player.mana
	_mana_label.text = "Mana %.0f / %.0f    (+%.0f/s, Quick Strike costs %.0f)" % [
		player.mana, player.max_mana, player.mana_regeneration, player.attack.data.mana_cost,
	]
	_mana_label.add_theme_color_override(
		"font_color", COPPER if player.mana < player.attack.data.mana_cost else TEXT
	)


func _update_detail() -> void:
	var player: PrototypePlayer = room.player
	var action: QuickStrikeAction = player.attack
	var data: QuickStrikeData = action.data
	var animation_position: float = player.quick_strike_animation_position()
	var release: Dictionary = action.last_release

	_detail.text = (
		"[color=#d9954c][b]Gate C combat (F3)[/b][/color]\n" +
		"state / phase    %s / %s  %.3f s\n" % [
			player.action_state_name(), action.phase_name(), action.phase_time,
		] +
		"skill use id     %s\n" % (str(action.use_id) if action.use_id > 0 else "none") +
		"action time      %.3f s  (%.3f / %.3f / %.3f)  +%.0f%% speed\n" % [
			action.effective_action_time(), action.windup_time(),
			action.release_window_time(), action.recovery_time(),
			action.increased_attack_speed * 100.0,
		] +
		"normalised time  %.3f   marker %.3f   clip %s\n" % [
			action.action_normalized_time(), data.release_marker_normalized,
			"%.3f" % animation_position if animation_position >= 0.0 else "n/a",
		] +
		"held / stale     %s / %s   buffered %s   in place %s\n" % [
			str(action.holding), str(action.holding_stale), str(action.buffered), str(action.attack_in_place),
		] +
		"target / soft    %s / %s\n" % [
			action.target.target_display_name() if action.target != null else "none",
			room.soft_target.target_display_name() if room.soft_target != null else "none",
		] +
		"aim decision     %s\n" % room.last_aim_reason +
		"aim source       %s   (group %s)\n" % [room.last_aim_source, room.last_aim_group] +
		"uses             %d started, %d released, %d cancelled pre-release\n" % [
			action.uses_started, action.uses_released, action.uses_cancelled_before_release,
		] +
		"release queries  %d   (must equal uses released)\n" % action.release_queries +
		"recoveries cut   %d   buffered used %d   repeat %.3f s\n" % [
			action.recoveries_cancelled, action.buffered_consumed, action.last_repeat_interval,
		] +
		"mana spent       %.0f total   %d refused for Mana\n" % [
			action.mana_spent_total, action.rejected_for_mana,
		] +
		"last cancel      %s\n" % action.last_cancel +
		"last release     %s\n" % (
			"use %d %s — %s" % [release["use_id"], release["outcome"], release["reason"]]
			if not release.is_empty() else "none"
		) +
		"posts struck     %s   slow motion %s" % [
			_fixture_summary(), "on (0.25x)" if room.slow_motion else "off",
		]
	)


func _fixture_summary() -> String:
	var parts: PackedStringArray = PackedStringArray()
	for fixture: PrototypeTargetFixture in room.fixtures:
		parts.append("%s %d%s" % [
			fixture.fixture_name.replace("Practice Post ", ""), fixture.release_hits,
			"" if fixture.active else " (absent)",
		])
	return ", ".join(parts)


# --- Small builders ----------------------------------------------------------

func _panel() -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = SLATE
	style.border_color = IRON
	style.set_border_width_all(1)
	style.set_corner_radius_all(3)
	style.set_content_margin_all(12)
	panel.add_theme_stylebox_override("panel", style)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	return panel


func _label(text: String, size: int, colour: Color) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", colour)
	return label


func _rich(size: int) -> RichTextLabel:
	var rich: RichTextLabel = RichTextLabel.new()
	rich.bbcode_enabled = true
	rich.fit_content = true
	rich.scroll_active = false
	rich.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rich.add_theme_font_size_override("normal_font_size", size)
	rich.add_theme_font_size_override("bold_font_size", size)
	rich.add_theme_color_override("default_color", TEXT)
	return rich
