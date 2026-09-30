class_name GateELabOverlay
extends Control
## Prototype Zero — Gate E: the lab-progression surface (specification §17 in its
## minimum form, §22, decision D-184).
##
## D-184: "Add only the minimum XP, weapon, ground interaction, comparison,
## passive, stage, wave, and transient presentation necessary to judge Gate E."
##
## So this carries exactly that:
##
##   an XP bar with its value, reading Complete at 20 / 20
##   the quiet weapon inspection line (specification §17)
##   the current stage and, in the repeat loop, the wave and the kill count
##   the ground drop's readable nameplate, which is what the mouse CLICKS
##   compact transient messages for Equip, passive applied, and the kill count
##
## IT IS NOT THE §17 HUD AND NOT GATE F. There is no Wroughtglass Life or Mana
## reservoir, no Mana Guard boundary, no Rift Shard, no Skill bank, no minimap,
## no objective tracker, no equipment paper doll, no inventory grid, no rarity
## frame, no damage number, and no damage-number setting. Life and Mana are still
## the Gate C and Gate D instrumentation cards.
##
## The F3 panel is development instrumentation and carries the ONE debug control
## D-184 permits here: the force-wave-size selector, which specification §22
## allows and which is deliberately unreachable without F3. Nothing in the
## player-facing loop needs it.

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.88)
const IRON: Color = Color(0.24, 0.26, 0.30)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const COPPER_DIM: Color = Color(0.58, 0.42, 0.26)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const TEXT_DIM: Color = Color(0.55, 0.58, 0.64)
const XP_FILL: Color = Color(0.72, 0.66, 0.36)
const XP_COMPLETE: Color = Color(0.62, 0.86, 0.58)

var room: PrototypeZeroRoom

var _xp_label: Label
var _xp_bar: ProgressBar
var _weapon_line: Label
var _stage_line: Label
var _message: Label
var _message_left: float = 0.0

## The ground nameplate: a real Button, so a mouse click on it is a UI click the
## room already absorbs rather than a world command that leaks through
## (specification §9.3).
var _nameplate: Button
var _nameplate_name: Label
var _nameplate_glyph: Label

var _debug_panel: PanelContainer
var _debug_text: RichTextLabel
var _wave_buttons: Array[Button] = []

## Gate F. The Gate E card duplicates what the §17 HUD now shows — the XP bar,
## the quiet weapon line, and the stage — so the app hides the CARD and F3 brings
## it back. The NAMEPLATE is deliberately not part of that: it is the surface the
## mouse clicks to open the comparison, so hiding it would remove a player-facing
## interaction rather than an instrumentation one.
##
## The labels keep updating either way, because `_process` does not care whether
## a Control is visible — which is also what keeps the Gate E evergreen-copy
## assertions reading live text rather than a frozen string.
var _card: PanelContainer


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	# The card stays legible behind a modal, which pauses everything else.
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build()


func bind_room(owner_room: PrototypeZeroRoom) -> void:
	room = owner_room
	room.director.transient_message.connect(_on_message)
	room.input_family.family_changed.connect(_on_family_changed)
	_refresh_glyph()


func toggle_detail() -> void:
	_debug_panel.visible = not _debug_panel.visible


func set_detail_visible(value: bool) -> void:
	_debug_panel.visible = value


## Gate F: hides the instrumentation card and its transient message while leaving
## the clickable ground nameplate alone.
func set_card_visible(value: bool) -> void:
	if _card != null:
		_card.visible = value
	if _message != null:
		_message.visible = value and _message_left > 0.0


func nameplate() -> Button:
	return _nameplate


func _build() -> void:
	# Specification §17 puts the XP bar "across or near the lower center". The
	# exact column was MEASURED against what is already down there rather than
	# guessed: Gate B's card runs to x = 928 and Gate C's begins at x = 1450 on
	# the 1920-wide UI reference, so 948 to 1428 is the free lower band.
	var card: PanelContainer = _panel()
	card.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	card.position = Vector2(948, -150)
	card.custom_minimum_size = Vector2(480, 0)
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)

	_xp_label = _label("XP 0 / 20", 14, TEXT)
	_xp_bar = ProgressBar.new()
	_xp_bar.show_percentage = false
	_xp_bar.custom_minimum_size = Vector2(0, 12)
	var fill: StyleBoxFlat = StyleBoxFlat.new()
	fill.bg_color = XP_FILL
	fill.set_corner_radius_all(2)
	_xp_bar.add_theme_stylebox_override("fill", fill)
	box.add_child(_xp_label)
	box.add_child(_xp_bar)

	_weapon_line = _label("Prototype Training Sword — 100 Physical per Quick Strike", 13, TEXT_DIM)
	box.add_child(_weapon_line)
	_stage_line = _label("STARTER_FIGHT", 12, COPPER_DIM)
	box.add_child(_stage_line)
	card.add_child(box)
	add_child(card)
	_card = card

	# Transient messages sit just above the card, so Equip, the passive, and the
	# kill count are read where the eye already is.
	_message = _label("", 15, COPPER)
	_message.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	_message.position = Vector2(948, -186)
	_message.custom_minimum_size = Vector2(480, 0)
	_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_message.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_message)

	_build_nameplate()
	_build_debug_panel()


## The ground drop's readable nameplate. It is placed over the drop each frame,
## so it stays legible from the fixed 55-degree camera at any distance — which a
## world-space label at this scale would not.
func _build_nameplate() -> void:
	_nameplate = Button.new()
	_nameplate.name = "GroundNameplate"
	_nameplate.focus_mode = Control.FOCUS_ALL
	_nameplate.mouse_filter = Control.MOUSE_FILTER_STOP
	_nameplate.visible = false
	for state: String in ["normal", "hover", "pressed", "focus", "disabled"]:
		var style: StyleBoxFlat = StyleBoxFlat.new()
		style.bg_color = Color(0.075, 0.082, 0.098, 0.90)
		style.border_color = COPPER if state != "normal" else COPPER_DIM
		style.set_border_width_all(2 if state != "normal" else 1)
		style.set_corner_radius_all(2)
		style.set_content_margin_all(7)
		_nameplate.add_theme_stylebox_override(state, style)
	var row: HBoxContainer = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 10)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.set_anchors_preset(Control.PRESET_FULL_RECT)
	_nameplate_name = _label("Prototype Honed Sword", 14, COPPER)
	_nameplate_name.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_nameplate_glyph = _label("Left click", 12, TEXT_DIM)
	_nameplate_glyph.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(_nameplate_name)
	row.add_child(_nameplate_glyph)
	_nameplate.add_child(row)
	_nameplate.pressed.connect(_on_nameplate_pressed)
	add_child(_nameplate)


func _build_debug_panel() -> void:
	# Right column, below the Gate D trace panel (which ends near y = 600) and
	# above the Gate C card in the lower right. With every F3 panel open the
	# surfaces are dense — four gates of instrumentation are stacked here, and
	# Gate F replaces all of it with the real HUD.
	_debug_panel = _panel()
	_debug_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_debug_panel.position = Vector2(-486, 604)
	_debug_panel.custom_minimum_size = Vector2(458, 0)
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	_debug_text = RichTextLabel.new()
	_debug_text.bbcode_enabled = true
	_debug_text.fit_content = true
	_debug_text.scroll_active = false
	_debug_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_debug_text.add_theme_font_size_override("normal_font_size", 12)
	_debug_text.add_theme_font_size_override("bold_font_size", 12)
	_debug_text.add_theme_color_override("default_color", TEXT)
	box.add_child(_debug_text)

	# Specification §22: "force wave size 1, 2, or 3 after the main sequence".
	# D-184: "A force-wave-size 1/2/3 selector is allowed ONLY in F3 debug UI."
	# It lives here and nowhere else, and nothing in the loop requires it.
	var row: HBoxContainer = HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	row.add_child(_label("force wave size", 12, TEXT_DIM))
	for size: int in [0, 1, 2, 3]:
		var button: Button = Button.new()
		button.name = "ForceWave%d" % size
		button.text = "auto" if size == 0 else str(size)
		button.custom_minimum_size = Vector2(52, 26)
		button.focus_mode = Control.FOCUS_ALL
		button.add_theme_font_size_override("font_size", 12)
		button.pressed.connect(_on_force_wave.bind(size))
		row.add_child(button)
		_wave_buttons.append(button)
	box.add_child(row)
	_debug_panel.add_child(box)
	_debug_panel.visible = false
	add_child(_debug_panel)


func _process(delta: float) -> void:
	if room == null or room.director == null or room.director.progress == null:
		return
	_message_left = maxf(_message_left - delta, 0.0)
	_message.visible = _message_left > 0.0 and (_card == null or _card.visible)
	_message.modulate.a = clampf(_message_left / 0.6, 0.0, 1.0)
	_update_card()
	_update_nameplate()
	if _debug_panel.visible:
		_update_debug()


func _update_card() -> void:
	var progress: LabProgress = room.director.progress
	var data: LabProgressionData = room.director.data
	_xp_bar.max_value = float(data.experience_maximum)
	_xp_bar.value = float(progress.experience)
	_xp_label.text = progress.experience_line()
	_xp_label.add_theme_color_override(
		"font_color", XP_COMPLETE if progress.experience_is_complete() else TEXT
	)
	var fill: StyleBoxFlat = _xp_bar.get_theme_stylebox("fill") as StyleBoxFlat
	fill.bg_color = XP_COMPLETE if progress.experience_is_complete() else XP_FILL

	# Specification §17: "current weapon name in a quiet inspection line".
	var weapon: PrototypeWeaponData = room.player.weapon
	_weapon_line.text = "%s — %.0f %s per Quick Strike, %.2f s Attack Time%s" % [
		weapon.display_name, weapon.physical_damage, weapon.damage_type,
		room.player.attack.effective_action_time(),
		"   •   %s" % data.passive_name if progress.quickened_form_active else "",
	]

	var stage: String = progress.stage_name()
	if progress.stage == LabProgress.Stage.REPEAT_LOOP:
		var pending: String = ""
		if room.director.wave_countdown > 0.0:
			pending = "   next wave of %d in %.2f s" % [
				room.director.forced_wave_size if room.director.forced_wave_size > 0 else progress.next_wave_size(),
				room.director.wave_countdown,
			]
		stage = "REPEAT_LOOP   wave %d   %d kill%s%s" % [
			progress.waves_started, progress.repeat_loop_kills,
			"" if progress.repeat_loop_kills == 1 else "s", pending,
		]
	_stage_line.text = stage


func _update_nameplate() -> void:
	var drop: PrototypeSwordDrop = room.director.drop()
	# Hidden while a modal is open, so a reopen is impossible from behind it.
	if drop == null or room.any_modal_is_open():
		if _nameplate.visible:
			_nameplate.visible = false
			if drop != null:
				drop.set_soft_targeted(false)
		return
	var camera: Camera3D = room.camera_rig.camera
	var anchor: Vector3 = drop.label_anchor()
	if camera.is_position_behind(anchor):
		_nameplate.visible = false
		return
	var screen: Vector2 = camera.unproject_position(anchor)
	_nameplate.visible = true
	_nameplate.size = _nameplate.get_combined_minimum_size()
	_nameplate.position = screen - Vector2(_nameplate.size.x * 0.5, _nameplate.size.y + 6.0)
	_nameplate_name.text = drop.display_name()

	# The controller opens the comparison from inside the drop's interaction
	# range; the cursor may click the nameplate from anywhere, because a cursor
	# already IS a reach. The nameplate says which, live.
	var controller: bool = room.input_family.family == InputFamilyTracker.Family.CONTROLLER
	var in_range: bool = drop.player_is_in_range(room.player.global_position)
	drop.set_soft_targeted(controller and in_range)
	if controller:
		_nameplate_glyph.text = "(A)" if in_range else "walk closer"
		_nameplate_glyph.add_theme_color_override("font_color", COPPER if in_range else TEXT_DIM)
	else:
		_nameplate_glyph.text = "Left click"
		_nameplate_glyph.add_theme_color_override("font_color", TEXT_DIM)


func _update_debug() -> void:
	var progress: LabProgress = room.director.progress
	var data: LabProgressionData = room.director.data
	var lines: PackedStringArray = PackedStringArray()
	lines.append("[color=#d9954c][b]Gate E lab progression (F3)[/b][/color]")
	lines.append("stage        %s" % progress.stage_name())
	lines.append("XP           %d / %d%s" % [
		progress.experience, data.experience_maximum,
		"   Complete" if progress.experience_is_complete() else "",
	])
	lines.append("weapon       %s   %.0f Physical   action %.3f s" % [
		room.player.weapon.display_name, room.player.weapon.physical_damage,
		room.player.attack.effective_action_time(),
	])
	lines.append("attack speed %+.0f%% increased   (%s)" % [
		progress.increased_attack_speed() * 100.0,
		"%s active" % data.passive_name if progress.quickened_form_active else "no passive",
	])
	lines.append("milestones   starter %s   upgraded %s   equipped %s   passive %s" % [
		_tick(progress.starter_kill_rewarded), _tick(progress.upgraded_kill_rewarded),
		_tick(progress.honed_sword_equipped), _tick(progress.quickened_form_active),
	])
	lines.append("duplicates   %d refused   last: %s" % [
		progress.duplicate_attempts_refused, progress.last_refusal,
	])
	lines.append("waves        %d started   next size %d   %d repeat kills   countdown %s" % [
		progress.waves_started, progress.next_wave_size(), progress.repeat_loop_kills,
		"—" if room.director.wave_countdown < 0.0 else "%.2f s" % room.director.wave_countdown,
	])
	lines.append("enemies      %d alive of %d present" % [
		room.living_graveblade_count(), room.graveblades.size(),
	])
	for enemy: PrototypeGraveblade in room.graveblades:
		if not is_instance_valid(enemy):
			continue
		lines.append("  %-12s %-26s Life %5.0f  %5.2f m  %s" % [
			enemy.name, enemy.state_name(), enemy.life, enemy.distance_to_player(),
			"PERMISSION" if room.attack_coordinator.holds_permission(enemy) else "",
		])
	# D-186: group cadence is a Gate E concern, so the window is legible from the
	# panel that owns the waves as well as from the Gate D coordinator card.
	lines.append("group handoff %s   %d started, %d refused" % [
		"idle" if not room.attack_coordinator.group_handoff_active()
			else "%.2f s of %.2f s remaining" % [
				room.attack_coordinator.group_handoff_remaining(),
				room.attack_coordinator.group_handoff_delay,
			],
		room.attack_coordinator.handoffs_started, room.attack_coordinator.handoff_refusals,
	])
	var plan: Dictionary = room.director.last_spawn_plan
	if not plan.is_empty():
		lines.append("last spawn   cluster %d   nearest player %.2f m   apart %.2f m   spread %.0f deg   %s" % [
			int(plan["cluster"]), float(plan["minimum_player_distance"]),
			float(plan["minimum_separation"]), float(plan["spread_degrees"]),
			"safe" if bool(plan["safe"]) else "UNSAFE",
		])
	lines.append("audio cues   %d emitted (silent by design)   last: %s" % [
		room.director.audio_cues_emitted, room.director.last_audio_cue,
	])
	_debug_text.text = "\n".join(lines)


func _tick(value: bool) -> String:
	return "yes" if value else "no"


func _on_message(text: String) -> void:
	_message.text = text
	_message_left = room.director.data.message_seconds


func _on_family_changed(_family: InputFamilyTracker.Family, _reason: String) -> void:
	_refresh_glyph()


func _refresh_glyph() -> void:
	if room == null:
		return
	_nameplate_glyph.text = (
		"(A)" if room.input_family.family == InputFamilyTracker.Family.CONTROLLER else "Left click"
	)


func _on_nameplate_pressed() -> void:
	room.open_item_comparison("nameplate clicked")


func _on_force_wave(size: int) -> void:
	room.director.set_forced_wave_size(size)


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
