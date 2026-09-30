class_name GateEPassiveCard
extends GateEModal
## Prototype Zero — Gate E: the one contained passive prompt (specification
## §16.2, decision D-184).
##
## It shows EXACTLY four things:
##
##   Quickened Form
##   25% increased Attack Speed
##   Quick Strike Attack Time: 0.80 s -> 0.64 s
##   Confirm
##
## Specification §16.2: "It does not show Passive points, paths, attributes,
## regions, sockets, refunds, search, or Build Lens." It is one reward card, not
## a tree, and there is no Passive Web anywhere in Prototype Zero.
##
## The two times are COMPUTED from the Quick Strike record and the progression
## record — `0.80` and `0.80 / (1 + 0.25)` — so the card cannot claim a change
## the kernel will not make.
##
## Confirmation is deliberate. `ui_cancel` does not dismiss this card: there is
## one option, the XP that earned it is already spent, and quietly closing it
## would leave the lab in a stage with no way forward.

var _effect: Label
var _timing: Label
var _confirm: Button


func modal_name() -> String:
	return "passive"


func default_focus() -> Control:
	return _confirm


## One option, deliberately confirmed. Cancel does not dismiss it.
func cancel_closes() -> bool:
	return false


## Refuses to present an already-confirmed passive at all.
##
## The milestone latch in `LabProgress` always refused the second confirmation,
## so nothing could ever be granted twice — but refusing the GRANT while still
## opening the SURFACE left a card on screen with a disabled Confirm and the
## world paused behind it, with no way forward. Idempotence has to cover the
## surface as well as the reward.
func open() -> void:
	if room != null and room.director.progress.quickened_form_active:
		room.log_progression("passive card refused", "%s is already active" % room.director.data.passive_name)
		return
	super()


func build_contents() -> void:
	var panel: PanelContainer = make_panel(480)
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)

	box.add_child(make_line("20 / 20 XP", 13, TEXT_DIM))
	box.add_child(make_title("Quickened Form"))
	_effect = make_line("25% increased Attack Speed", 16, TEXT)
	box.add_child(_effect)
	box.add_child(make_rule())
	_timing = make_line("Quick Strike Attack Time: 0.80 s → 0.64 s", 15, IMPROVED)
	box.add_child(_timing)

	var buttons: HBoxContainer = HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_END
	_confirm = make_button("Confirm", &"ui_confirm")
	_confirm.pressed.connect(_on_confirm_pressed)
	buttons.add_child(_confirm)
	box.add_child(buttons)

	panel.add_child(box)
	add_child(panel)


func refresh_contents() -> void:
	if room == null:
		return
	var progression: LabProgressionData = room.director.data
	var base_action: float = room.player.attack.data.action_time
	# The card states the passive's own name and effect line from the record, and
	# both action times from the arithmetic the kernel will actually perform.
	_effect.text = progression.passive_effect_line
	_timing.text = "Quick Strike Attack Time: %.2f s → %.2f s" % [
		base_action, progression.quickened_action_time(base_action),
	]
	_confirm.disabled = room.director.progress.quickened_form_active


func _on_confirm_pressed() -> void:
	# `confirm_quickened_form()` is idempotent: a second press, a re-opened card,
	# or a duplicated signal all get false and change nothing.
	room.director.confirm_quickened_form()
	close("confirmed")
