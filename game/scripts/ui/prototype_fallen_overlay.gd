class_name PrototypeFallenOverlay
extends GateEModal
## Prototype Zero — Gate F: Fallen (specification §20.1, decision D-189).
##
## §20.1, in order:
##
##   cancel movement, navigation, attack, target, buffered input, and enemy
##     attack permissions                     — the player and the room, on the
##                                              lethal frame, before this opens
##   remove player damage eligibility         — `PrototypePlayer._fall()`
##   play the death response                  — the room waits for the collapse
##                                              before this surface appears
##   fade in Fallen                           — `FADE_SECONDS` below
##   show the accurate killing source         — `Graveblade — Melee Hit — 125
##                                              Physical Damage`, built from the
##                                              actual DamageEvent
##   focus a neutral non-destructive element  — `Review Death`, which shows the
##     first, then make Restart plainly         factual trace and changes nothing
##     reachable
##   accept no action from a button that was  — the Gate E modal's `_armed` rule
##     held when death occurred
##
## THE KILLING SOURCE IS BUILT FROM THE EVENT, NEVER FROM A LITERAL. The line the
## specification prints is what this produces when the Graveblade lands its
## 125-damage Hit, but every field comes from the `DamageEvent` and the killer's
## own record, so a changed number changes the line. A death screen that states
## a hard-coded number is a death screen that will eventually lie.
##
## THERE IS NO COUNTDOWN AND NO AUTOMATIC ANYTHING. §20.1 has no Rift Anchors, no
## Recovery Cache, no run rewards, and no story consequence, and the canonical
## death model forbids a forced countdown. Fallen waits.

## §20.1 "fade in Fallen". Long enough to read as arrival rather than as a cut,
## short enough that a player who died on purpose is not kept waiting.
const FADE_SECONDS: float = 0.45

var killing_source: String = ""

var _title: Label
var _source: Label
var _review: Button
var _restart: Button
var _quit: Button
var _detail: Label
var _fade: float = 0.0
var _reviewed: bool = false


func modal_name() -> String:
	return "fallen"


## The neutral, non-destructive element. It shows what happened; it changes
## nothing, spends nothing, and cannot be pressed by accident into a restart.
func default_focus() -> Control:
	return _review


## Escape must not dismiss Fallen. There is nothing behind it to return to.
func cancel_closes() -> bool:
	return false


func build_contents() -> void:
	var panel: PanelContainer = make_panel(560)
	# Genuinely centred: `PRESET_CENTER` alone anchors the top-left corner to the
	# middle and grows down and right.
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
	_detail.visible = false
	box.add_child(_detail)
	box.add_child(make_rule())

	var buttons: VBoxContainer = VBoxContainer.new()
	buttons.add_theme_constant_override("separation", 8)
	_review = _wide("Review Death", &"ui_confirm")
	_review.pressed.connect(_on_review)
	_restart = _wide("Restart Current Fight", &"ui_confirm")
	_restart.pressed.connect(_on_restart)
	_quit = _wide("Quit to Title", &"ui_confirm")
	_quit.pressed.connect(_on_quit)
	for button: Button in [_review, _restart, _quit]:
		buttons.add_child(button)
	box.add_child(buttons)
	box.add_child(make_line("F5 also restarts the current fight.", 11, TEXT_DIM))

	panel.add_child(box)
	add_child(panel)


## Builds the §20.1 line from the event that actually killed the player.
func open_for(event: DamageEvent) -> void:
	killing_source = describe_killing_source(event)
	_reviewed = false
	_fade = 0.0
	modulate.a = 0.0
	open()
	_source.text = killing_source
	_detail.visible = false
	_detail.text = _describe_detail(event)


## `Graveblade — Melee Hit — 125 Physical Damage`, every field from the event.
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
	# Factual only. There is no defence pipeline in Prototype Zero — no Armour,
	# Evasion, Block, Resistance, or Mana Guard exists to trace through — so the
	# honest trace is short, and saying so is better than inventing a breakdown.
	return (
		"Attack use %d dealt %.0f raw Physical; Prototype Zero applies final = raw, so Life took %.0f.\n"
		+ "Life ran %.0f → 0 of %.0f. No Armour, Evasion, Block, Resistance, or Mana Guard exists yet to reduce it."
	) % [
		event.use_id, event.raw_physical_damage, event.final_life_damage,
		event.final_life_damage, room.player.max_life,
	]


func _on_review() -> void:
	_reviewed = true
	_detail.visible = true
	room.note_menu_cue("menu_open")
	room.log_gate_f("fallen reviewed", killing_source)


func _on_restart() -> void:
	room.note_menu_cue("menu_confirm")
	close("restarting")
	room.restart_current_fight("Fallen")


func _on_quit() -> void:
	room.note_menu_cue("menu_confirm")
	close("quitting to title")
	room.quit_to_title("Fallen")


## §9.1: `quick_restart` is F5 "from Fallen or pause". The neutral-input rule
## still applies to it — a key held through death cannot restart the fight.
func _input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed(&"quick_restart"):
		get_viewport().set_input_as_handled()
		if _consume(&"ui_confirm"):
			_on_restart()
		return
	super(event)


## The modal keeps processing while the world is paused, which is what lets the
## fade run at all.
func _process(delta: float) -> void:
	if not is_open:
		return
	if _fade >= 1.0:
		return
	_fade = clampf(_fade + delta / FADE_SECONDS, 0.0, 1.0)
	modulate.a = _fade


func was_reviewed() -> bool:
	return _reviewed


func _wide(text: String, action: StringName) -> Button:
	var button: Button = make_button(text, action)
	button.custom_minimum_size = Vector2(512, 44)
	return button
