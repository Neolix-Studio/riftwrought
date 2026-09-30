class_name PrototypeHUD
extends Control
## Prototype Zero — Gate F: the restrained prototype HUD (specification §17,
## decision D-189).
##
## §17 lists exactly what this may contain, and this is that list:
##
##   Life at lower left with current and maximum value
##   Mana at lower right with current and maximum value
##   XP bar across or near the lower center
##   one Quick Strike action slot with its current binding glyph
##   current weapon name in a quiet inspection line
##   target indicator and enemy Life bar only while relevant
##   ground destination marker              (already the Gate B world marker)
##   interaction prompt for the sword
##   optional damage numbers, default On, immediately switchable Off
##   compact transient messages for Equip, Passive applied, and the kill count
##
## §17 also lists what it may NOT contain, and none of it is here: no screenshot,
## no KayKit promotional art, no copied ARPG orb silhouette, no rarity frame, no
## Rift Shard, no minimap, no objective tracker, no equipment paper doll, no
## inventory grid, and no canonical story language.
##
## IT SAYS WHAT IT IS. §17 opens with "flat, restrained Wroughtstone-adjacent
## placeholders anchored to the KayKit palette. It must not attempt final
## decorative UI", and D-189 asks for it to "remain clearly identified as
## prototype presentation rather than final UI". So the surface carries a quiet
## standing line that says so, in the corner, at all times. A placeholder that
## does not admit it is a placeholder is the thing that gets mistaken for a
## decision.
##
## THE PALETTE IS THE ONE THE PROTOTYPE ALREADY USES — the broad dark slate, iron
## edge, and muted copper accent shared with the Gate B, C, D, and E surfaces and
## with `gate_e_modal.gd`. Life is a deep blood red, Mana a cold slate blue, XP
## the same muted gold the Gate E card uses. Bars are flat rectangles with a
## single iron rule: Wroughtstone is "broad dark-slate, stone, iron, muted-copper,
## softly faceted, highly readable shapes", and at prototype fidelity the honest
## reading of that is a readable block, not a decorated one.
##
## EVERY CONTROL HERE IS `MOUSE_FILTER_IGNORE`. A HUD that covered the screen
## with a mouse-absorbing Control would make every click "pointer over
## interface" and silently break click-to-move — which is exactly the §9.3 rule
## the room already enforces. The one clickable surface in the world, the ground
## drop's nameplate, deliberately stays where Gate E put it.

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.86)
const SLATE_DEEP: Color = Color(0.045, 0.050, 0.060, 0.92)
const IRON: Color = Color(0.24, 0.26, 0.30)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const COPPER_DIM: Color = Color(0.58, 0.42, 0.26)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const TEXT_DIM: Color = Color(0.55, 0.58, 0.64)
const LIFE_FILL: Color = Color(0.72, 0.22, 0.20)
const LIFE_LOW: Color = Color(0.92, 0.36, 0.26)
const MANA_FILL: Color = Color(0.34, 0.48, 0.68)
const XP_FILL: Color = Color(0.72, 0.66, 0.36)
const XP_COMPLETE: Color = Color(0.62, 0.86, 0.58)
const ENEMY_FILL: Color = Color(0.78, 0.26, 0.24)

## Damage-number colours. Both Hits are PHYSICAL and both are bone-white; the
## improved Hit is larger and holds longer rather than a different colour,
## because a colour change is exactly how an elemental Hit would read (§18).
const NUMBER_ORDINARY: Color = Color(0.94, 0.93, 0.90)
const NUMBER_IMPROVED: Color = Color(1.00, 0.90, 0.74)
const NUMBER_PLAYER: Color = Color(0.95, 0.45, 0.40)

const NUMBER_SECONDS: float = 0.80
const NUMBER_RISE: float = 74.0
## A hard ceiling, so a future very fast build cannot fill the screen with text.
const MAXIMUM_NUMBERS: int = 24

## How long the target readout stays after the target stops being current.
const TARGET_HOLD: float = 2.0

var room: Node

# --- Instrumentation (specification §22) -------------------------------------
var numbers_spawned: int = 0
var numbers_dropped_at_cap: int = 0
var messages_shown: int = 0

var _life_bar: ProgressBar
var _life_label: Label
var _mana_bar: ProgressBar
var _mana_label: Label
var _xp_bar: ProgressBar
var _xp_label: Label
var _weapon_line: Label
var _skill_name: Label
var _skill_glyph: Label
var _skill_timing: Label
var _target_panel: PanelContainer
var _target_name: Label
var _target_bar: ProgressBar
var _target_left: float = 0.0
var _target_node: Node = null
var _prompt: PanelContainer
var _prompt_label: Label
var _prompt_glyph: Label
var _message: Label
var _message_left: float = 0.0
var _numbers_layer: Control
var _numbers: Array[Dictionary] = []


func _ready() -> void:
	# `set_anchors_and_offsets_preset`, not `set_anchors_preset`. The latter sets
	# the anchors and leaves the OFFSETS where they were, which for a Control
	# created in code is (0, 0, 0, 0) — a full-rect anchor over a zero-size rect.
	# Everything anchored inside it then collapses to the origin or off the top of
	# the screen. The scene-instanced Gate E surfaces never hit this because their
	# `.tscn` writes both.
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	# The HUD stays legible behind a modal, which pauses everything else, so the
	# comparison can be read against the Life and Mana it is talking about.
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build()


func bind_room(owner_room: Node) -> void:
	room = owner_room
	var director: Node = owner_room.get("director") as Node
	if director != null:
		director.connect("transient_message", Callable(self, "_on_message"))
	var tracker: InputFamilyTracker = owner_room.get("input_family") as InputFamilyTracker
	if tracker != null:
		tracker.family_changed.connect(_on_family_changed)
	_refresh_glyphs()


# --- Build -------------------------------------------------------------------

func _build() -> void:
	_build_life()
	_build_mana()
	_build_centre()
	_build_target()
	_build_prompt()
	_build_numbers()
	_build_prototype_tag()
	# Every control, not merely the ones built by hand. A `VBoxContainer` defaults
	# to MOUSE_FILTER_STOP, and one forgotten box anywhere in the HUD would make
	# part of the screen absorb clicks — which silently breaks click-to-move
	# through the §9.3 rule the room already enforces. One sweep, so the property
	# cannot be missed on a control added later.
	_ignore_the_pointer(self)


func _ignore_the_pointer(node: Node) -> void:
	for child: Node in node.get_children():
		var control: Control = child as Control
		if control != null:
			control.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_ignore_the_pointer(child)


func _build_life() -> void:
	var card: PanelContainer = _panel()
	card.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	card.position = Vector2(28, -128)
	card.custom_minimum_size = Vector2(330, 0)
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 5)
	box.add_child(_label("LIFE", 11, COPPER_DIM))
	_life_bar = _bar(LIFE_FILL, 20)
	box.add_child(_life_bar)
	_life_label = _label("500 / 500", 15, TEXT)
	box.add_child(_life_label)
	card.add_child(box)
	add_child(card)


func _build_mana() -> void:
	var card: PanelContainer = _panel()
	card.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	card.position = Vector2(-358, -128)
	card.custom_minimum_size = Vector2(330, 0)
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 5)
	var heading: Label = _label("MANA", 11, COPPER_DIM)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	box.add_child(heading)
	_mana_bar = _bar(MANA_FILL, 20)
	box.add_child(_mana_bar)
	_mana_label = _label("100 / 100", 15, TEXT)
	_mana_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	box.add_child(_mana_label)
	card.add_child(box)
	add_child(card)


## §17: the XP bar "across or near the lower center", the one Quick Strike slot
## with its live binding glyph, and the quiet weapon inspection line. They are
## one column because they are one question: what am I becoming, and with what.
func _build_centre() -> void:
	# ONE card, not three floating rows. The XP label and the weapon line are
	# quiet 12-point text, and quiet text over a bright stone floor is not
	# readable text — Wroughtstone is "broad dark-slate ... highly readable
	# shapes", and the readable shape here is the slate behind the words. It also
	# anchors to the bottom CENTRE and grows outward, so it is correct at the
	# 1280 x 720 minimum tested window as well as at the 1920 x 1080 reference.
	var card: PanelContainer = _panel()
	card.name = "CentreCard"
	card.anchor_left = 0.5
	card.anchor_right = 0.5
	card.anchor_top = 1.0
	card.anchor_bottom = 1.0
	card.grow_horizontal = Control.GROW_DIRECTION_BOTH
	card.grow_vertical = Control.GROW_DIRECTION_BOTH
	card.custom_minimum_size = Vector2(560, 0)
	card.offset_top = -134.0
	card.offset_bottom = -22.0

	var column: VBoxContainer = VBoxContainer.new()
	column.name = "CentreColumn"
	column.add_theme_constant_override("separation", 6)
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# The one Quick Strike slot. A labelled slot, as §17 permits: Prototype Zero
	# has one Skill and inventing an icon for it would be bespoke art the asset
	# rules explicitly refuse at this stage.
	var slot_row: HBoxContainer = HBoxContainer.new()
	slot_row.add_theme_constant_override("separation", 12)
	slot_row.alignment = BoxContainer.ALIGNMENT_CENTER
	slot_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_skill_name = _label("Quick Strike", 16, TEXT)
	_skill_glyph = _label("Right mouse", 13, COPPER)
	_skill_timing = _label("0.80 s", 13, TEXT_DIM)
	slot_row.add_child(_skill_name)
	slot_row.add_child(_skill_glyph)
	slot_row.add_child(_skill_timing)
	column.add_child(slot_row)

	_xp_bar = _bar(XP_FILL, 10)
	column.add_child(_xp_bar)
	_xp_label = _label("XP 0 / 20", 12, TEXT_DIM)
	_xp_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(_xp_label)

	_weapon_line = _label("Prototype Training Sword — 100 Physical per Quick Strike", 12, TEXT_DIM)
	_weapon_line.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(_weapon_line)

	card.add_child(column)
	add_child(card)

	# Transient messages sit above the card, where the eye already is.
	_message = _label("", 17, COPPER)
	_message.anchor_left = 0.5
	_message.anchor_right = 0.5
	_message.anchor_top = 1.0
	_message.anchor_bottom = 1.0
	_message.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_message.grow_vertical = Control.GROW_DIRECTION_BOTH
	_message.custom_minimum_size = Vector2(620, 26)
	_message.offset_top = -166.0
	_message.offset_bottom = -140.0
	_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_message.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_message)


## §17: "target indicator and enemy Life bar only while relevant". Relevant means
## a soft target is chosen, or something was struck within the last two seconds.
## With no target and no recent Hit it is not dimmed — it is gone.
func _build_target() -> void:
	_target_panel = _panel()
	_target_panel.set_anchors_preset(Control.PRESET_CENTER_TOP)
	_target_panel.position = Vector2(-170, 26)
	_target_panel.custom_minimum_size = Vector2(340, 0)
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 5)
	_target_name = _label("Graveblade", 14, TEXT)
	_target_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(_target_name)
	_target_bar = _bar(ENEMY_FILL, 9)
	box.add_child(_target_bar)
	_target_panel.add_child(box)
	_target_panel.visible = false
	add_child(_target_panel)


## §17: "interaction prompt for the sword". It appears only while there is a
## drop and the character can act on it, and it names the live binding.
func _build_prompt() -> void:
	_prompt = _panel(SLATE_DEEP)
	_prompt.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_prompt.position = Vector2(-200, -206)
	_prompt.custom_minimum_size = Vector2(400, 0)
	var row: HBoxContainer = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 10)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_prompt_label = _label("Prototype Honed Sword", 14, COPPER)
	_prompt_glyph = _label("Left click to inspect", 12, TEXT_DIM)
	row.add_child(_prompt_label)
	row.add_child(_prompt_glyph)
	_prompt.add_child(row)
	_prompt.visible = false
	add_child(_prompt)


func _build_numbers() -> void:
	_numbers_layer = Control.new()
	_numbers_layer.name = "DamageNumbers"
	_numbers_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_numbers_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_numbers_layer)


## The standing admission that this is not final UI. §17: "It must not attempt
## final decorative UI"; D-189: it must "remain clearly identified as prototype
## presentation rather than final UI".
func _build_prototype_tag() -> void:
	var tag: Label = _label("Prototype HUD — instrumentation for Prototype Zero, not final UI", 11, TEXT_DIM)
	tag.set_anchors_preset(Control.PRESET_TOP_LEFT)
	tag.position = Vector2(28, 20)
	tag.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tag.modulate.a = 0.75
	add_child(tag)


# --- Per-frame ---------------------------------------------------------------

func _process(delta: float) -> void:
	_tick_numbers(delta)
	if room == null:
		return
	_message_left = maxf(_message_left - delta, 0.0)
	_message.visible = _message_left > 0.0
	_message.modulate.a = clampf(_message_left / 0.6, 0.0, 1.0)
	_update_resources()
	_update_centre()
	_update_target(delta)
	_update_prompt()


func _update_resources() -> void:
	var player: PrototypePlayer = room.get("player") as PrototypePlayer
	if player == null:
		return
	_life_bar.max_value = player.max_life
	_life_bar.value = player.life
	_life_label.text = "%.0f / %.0f" % [player.life, player.max_life]
	var low: bool = player.life <= player.max_life * 0.30
	var life_style: StyleBoxFlat = _life_bar.get_theme_stylebox("fill") as StyleBoxFlat
	life_style.bg_color = LIFE_LOW if low else LIFE_FILL
	_life_label.add_theme_color_override("font_color", LIFE_LOW if low else TEXT)

	_mana_bar.max_value = player.max_mana
	_mana_bar.value = player.mana
	_mana_label.text = "%.0f / %.0f" % [player.mana, player.max_mana]


func _update_centre() -> void:
	var player: PrototypePlayer = room.get("player") as PrototypePlayer
	var director: Node = room.get("director") as Node
	if player == null or director == null:
		return
	var progress: LabProgress = director.get("progress") as LabProgress
	var data: LabProgressionData = director.get("data") as LabProgressionData
	if progress != null and data != null:
		_xp_bar.max_value = float(data.experience_maximum)
		_xp_bar.value = float(progress.experience)
		_xp_label.text = progress.experience_line()
		var complete: bool = progress.experience_is_complete()
		var fill: StyleBoxFlat = _xp_bar.get_theme_stylebox("fill") as StyleBoxFlat
		fill.bg_color = XP_COMPLETE if complete else XP_FILL
		_xp_label.add_theme_color_override("font_color", XP_COMPLETE if complete else TEXT_DIM)

	var weapon: PrototypeWeaponData = player.weapon
	if weapon != null:
		_weapon_line.text = "%s — %.0f %s per Quick Strike" % [
			weapon.display_name, weapon.physical_damage, weapon.damage_type,
		]
	var action_time: float = player.attack.effective_action_time()
	_skill_timing.text = "%.2f s" % action_time
	var quickened: bool = progress != null and progress.quickened_form_active
	_skill_timing.add_theme_color_override("font_color", XP_COMPLETE if quickened else TEXT_DIM)


func _update_target(delta: float) -> void:
	_target_left = maxf(_target_left - delta, 0.0)
	var soft: PrototypeTargetable = room.get("soft_target") as PrototypeTargetable
	var candidate: Node = null
	if soft != null and soft.combat_actor() != null:
		candidate = soft.combat_actor()
	if candidate == null and _target_left > 0.0:
		candidate = _target_node
	if candidate == null or not is_instance_valid(candidate):
		_target_panel.visible = false
		_target_node = null
		return
	var enemy: PrototypeGraveblade = candidate as PrototypeGraveblade
	if enemy == null or not enemy.is_alive():
		_target_panel.visible = false
		_target_node = null
		return
	_target_node = enemy
	_target_panel.visible = true
	_target_name.text = enemy.data.display_name if enemy.data != null else enemy.name
	_target_bar.max_value = enemy.data.max_life if enemy.data != null else 1.0
	_target_bar.value = enemy.life


func _update_prompt() -> void:
	var director: Node = room.get("director") as Node
	if director == null:
		_prompt.visible = false
		return
	var drop: PrototypeSwordDrop = director.call("drop") as PrototypeSwordDrop
	if drop == null or bool(room.call("any_modal_is_open")):
		_prompt.visible = false
		return
	_prompt.visible = true
	_prompt_label.text = drop.display_name()
	var tracker: InputFamilyTracker = room.get("input_family") as InputFamilyTracker
	var controller: bool = tracker != null and tracker.family == InputFamilyTracker.Family.CONTROLLER
	var player: PrototypePlayer = room.get("player") as PrototypePlayer
	var in_range: bool = player != null and drop.player_is_in_range(player.global_position)
	if controller:
		_prompt_glyph.text = "(A) to inspect" if in_range else "walk closer to inspect"
	else:
		_prompt_glyph.text = "Left click its name to inspect"
	_prompt_glyph.add_theme_color_override(
		"font_color", COPPER if (in_range or not controller) else TEXT_DIM
	)


# --- Damage numbers ----------------------------------------------------------

## Called only when the damage-number setting is On; the feedback layer owns that
## decision so the suppression can be counted in one place.
func show_damage_number(at: Vector3, amount: float, kind: String) -> void:
	if _numbers.size() >= MAXIMUM_NUMBERS:
		numbers_dropped_at_cap += 1
		return
	var camera: Camera3D = get_viewport().get_camera_3d()
	if camera == null or camera.is_position_behind(at):
		return
	var label: Label = Label.new()
	label.text = "%.0f" % amount
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	match kind:
		"improved":
			label.add_theme_font_size_override("font_size", 30)
			label.add_theme_color_override("font_color", NUMBER_IMPROVED)
		"player":
			label.add_theme_font_size_override("font_size", 26)
			label.add_theme_color_override("font_color", NUMBER_PLAYER)
		_:
			label.add_theme_font_size_override("font_size", 24)
			label.add_theme_color_override("font_color", NUMBER_ORDINARY)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.75))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	_numbers_layer.add_child(label)
	label.position = camera.unproject_position(at) - Vector2(14, 18)
	_numbers.append({
		"label": label,
		"left": NUMBER_SECONDS * (1.15 if kind == "improved" else 1.0),
		"total": NUMBER_SECONDS * (1.15 if kind == "improved" else 1.0),
	})
	numbers_spawned += 1


func _tick_numbers(delta: float) -> void:
	if _numbers.is_empty():
		return
	var alive: Array[Dictionary] = []
	for entry: Dictionary in _numbers:
		# Validity is checked on the raw Variant, because CASTING a freed object
		# is itself an error.
		if not is_instance_valid(entry["label"]):
			continue
		var label: Label = entry["label"] as Label
		entry["left"] = float(entry["left"]) - delta
		if float(entry["left"]) <= 0.0:
			label.queue_free()
			continue
		var progress: float = 1.0 - float(entry["left"]) / float(entry["total"])
		label.position.y -= NUMBER_RISE * delta
		label.modulate.a = clampf(1.0 - pow(progress, 2.4), 0.0, 1.0)
		alive.append(entry)
	_numbers = alive


func clear_damage_numbers() -> void:
	for entry: Dictionary in _numbers:
		if is_instance_valid(entry["label"]):
			(entry["label"] as Label).queue_free()
	_numbers.clear()


func live_number_count() -> int:
	return _numbers.size()


# --- Messages and glyphs -----------------------------------------------------

func _on_message(text: String) -> void:
	_message.text = text
	_message_left = 3.0
	messages_shown += 1


func note_target(node: Node) -> void:
	_target_node = node
	_target_left = TARGET_HOLD


func _on_family_changed(_family: InputFamilyTracker.Family, _reason: String) -> void:
	_refresh_glyphs()


func _refresh_glyphs() -> void:
	if room == null:
		return
	var tracker: InputFamilyTracker = room.get("input_family") as InputFamilyTracker
	var controller: bool = tracker != null and tracker.family == InputFamilyTracker.Family.CONTROLLER
	_skill_glyph.text = GateEModal.glyph_for(&"quick_strike", controller)


func describe() -> String:
	return "%d damage numbers spawned, %d dropped at the %d cap, %d live, %d messages" % [
		numbers_spawned, numbers_dropped_at_cap, MAXIMUM_NUMBERS, _numbers.size(), messages_shown,
	]


# --- Small builders ----------------------------------------------------------

func _panel(background: Color = SLATE) -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = IRON
	style.set_border_width_all(1)
	style.set_corner_radius_all(3)
	style.set_content_margin_all(11)
	panel.add_theme_stylebox_override("panel", style)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return panel


func _bar(colour: Color, height: int) -> ProgressBar:
	var bar: ProgressBar = ProgressBar.new()
	bar.show_percentage = false
	bar.custom_minimum_size = Vector2(0, height)
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fill: StyleBoxFlat = StyleBoxFlat.new()
	fill.bg_color = colour
	fill.set_corner_radius_all(2)
	bar.add_theme_stylebox_override("fill", fill)
	var background: StyleBoxFlat = StyleBoxFlat.new()
	background.bg_color = Color(0.035, 0.040, 0.048, 0.95)
	background.border_color = IRON
	background.set_border_width_all(1)
	background.set_corner_radius_all(2)
	bar.add_theme_stylebox_override("background", background)
	return bar


func _label(text: String, size: int, colour: Color) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", colour)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label
