class_name FirstMvpFallenOverlay
extends FirstMvpModal
## First-MVP — Gate 1D: Fallen (decision D-217).
##
## The same minimal, proven Fallen contract Prototype Zero's Gate F delivered
## (`PrototypeFallenOverlay`), reused as a pattern: fade in, show the accurate
## killing source built from the actual `DamageEvent` (never a literal), focus
## the neutral non-destructive control first, accept no action from a control
## that was already held when death occurred.
##
## GATE 1D's BOUNDARY, STATED EXPLICITLY: this is the "already-proven minimal
## Fallen / Restart behavior" the brief asks for, not the complete first-MVP
## Anchor/death/recovery system. There is no Rift Anchor, no Recovery Cache,
## no run reward, and no story consequence. Restart returns the bounded
## Broken Watch slice to a valid deterministic state — see
## `BrokenWatchSlice.restart_current_slice()` — WITHOUT duplicating the
## guaranteed drop or re-granting a reward already claimed, and WITHOUT
## writing anything to disk: this scene never constructs a settings or
## lab-state store, so restarting here can never touch `user://`.

const FADE_SECONDS: float = 0.45

var killing_source: String = ""

var _title: Label
var _source: Label
var _restart: Button
var _detail: Label
var _fade: float = 0.0


func modal_name() -> String:
	return "fallen"


func default_focus() -> Control:
	return _restart


func cancel_closes() -> bool:
	return false


func build_contents() -> void:
	var panel: PanelContainer = make_panel(560)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)

	_title = make_line("Fallen", 34, Color(0.90, 0.36, 0.32))
	box.add_child(_title)
	box.add_child(make_rule())

	box.add_child(make_line("Killed by", 12, TEXT_DIM))
	_source = make_line("—", 17, TEXT)
	box.add_child(_source)

	_detail = make_line("", 12, TEXT_DIM)
	_detail.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_detail)
	box.add_child(make_rule())

	_restart = _wide("Restart Broken Watch", &"ui_confirm")
	_restart.pressed.connect(_on_restart)
	box.add_child(_restart)
	box.add_child(make_line("F5 also restarts.", 11, TEXT_DIM))

	panel.add_child(box)
	add_child(panel)


func open_for(event: DamageEvent) -> void:
	killing_source = describe_killing_source(event)
	_fade = 0.0
	modulate.a = 0.0
	open()
	_source.text = killing_source
	_detail.text = _describe_detail(event)


static func describe_killing_source(event: DamageEvent) -> String:
	if event == null:
		return "Unknown — no recorded damage event"
	var attacker: String = event.source_name()
	var kind: String = "Physical"
	var action: String = "Hit"
	var enemy: PrototypeGraveblade = event.source as PrototypeGraveblade
	if enemy != null and enemy.data != null:
		attacker = enemy.data.display_name
		kind = enemy.data.damage_type
		action = enemy.data.attack_display_name
	return "%s — %s — %.0f %s Damage" % [attacker, action, event.raw_physical_damage, kind]


func _describe_detail(event: DamageEvent) -> String:
	if event == null or room == null:
		return ""
	return "Life ran %.0f → 0 of %.0f. No Armour, Evasion, Block, Resistance, or Mana Guard exists yet to reduce it." % [
		event.final_life_damage, room.player.max_life,
	]


func _on_restart() -> void:
	close("restarting")
	room.restart_current_slice("Fallen")


func _input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed(&"quick_restart"):
		get_viewport().set_input_as_handled()
		if _consume(&"ui_confirm"):
			_on_restart()
		return
	super(event)


func _process(delta: float) -> void:
	if not is_open:
		return
	if _fade >= 1.0:
		return
	_fade = clampf(_fade + delta / FADE_SECONDS, 0.0, 1.0)
	modulate.a = _fade


func _wide(text: String, action: StringName) -> Button:
	var button: Button = make_button(text, action)
	button.custom_minimum_size = Vector2(512, 44)
	return button
