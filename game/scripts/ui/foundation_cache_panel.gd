class_name FoundationCachePanel
extends FirstMvpModal
## First-MVP — Gate 1E: the Foundation Cache (D-219).
##
## Three packages, exactly as `design/FIRST_MVP_CAMPAIGN_AND_PROGRESSION_
## JOURNEY.md` §7 and `design/FIRST_MVP_CONTENT_AND_REWARD_CATALOGUE.md` §4.1
## name them:
##
##   Faultbreaker   + Garrison Greatsword   heavy melee
##   Splinter Shot  + Marrow Bow            projectile
##   Emberbolt      + Cantor Wand           spell
##
## THE MOST IMPORTANT THING ON THIS SCREEN IS NOT A PACKAGE. It is the sentence
## saying this is not a class choice. The brief lists four things the interface
## must state BEFORE confirmation, and all four are on screen at once rather
## than behind a tooltip:
##
##   * this is the direction explored first
##   * it is NOT a class choice
##   * it is NOT a permanent lock
##   * the other two Skills and suitable ordinary equipment become
##     deterministically available through the next two Survey milestones
##
## and a fifth from §7 itself: Quick Strike remains learned and usable whenever
## its weapon requirements are met.
##
## The canon is unambiguous about why this matters: "This is not a class choice
## or permanent build lock. The unchosen Skills and ordinary compatible
## foundations become deterministically available through the next two survey
## milestones. The interface says so before confirmation."
##
## THE WEAPON IS GRANTED AS OWNED, NOT EQUIPPED. Equipping is a separate,
## deliberate step at the equipment station — the same line Gate 1D drew for the
## Watchsteel Sword, and the reason `PlayerLoadout` distinguishes `owned_items`
## from `equipped_weapon` at all. The card says what would be displaced and that
## nothing is destroyed.
##
## ONCE PER CHARACTER. `CharacterState.choose_foundation_package()` latches, and
## the runtime refuses to open this panel again once it has. Reloading cannot
## grant a second package because the latch is saved.
##
## Every package card is a focusable `Button` with an explicit focus graph, so
## mouse and controller are both complete with no InputMap action added.

const CARD_WIDTH: float = 268.0
const CARD_HEIGHT: float = 236.0

var _cards: Array[Button] = []
var _packages: Array[Dictionary] = []
var _detail_title: Label
var _detail_body: Label
var _promise_lines: Array[Label] = []
var _confirm: Button
var _close: Button

## THE COMMITTED CHOICE — what "Choose" acts on. Set only by a click or by
## controller focus, never by the mouse merely passing over a card.
var selected_index: int = -1
## What the detail panel is previewing. Hover moves this and nothing else.
##
## THE DEFECT THIS SEPARATION EXISTS TO PREVENT was real and permanent: with one
## field, moving the mouse from a card toward the Choose button crosses the other
## cards, each `mouse_entered` re-selected, and Choose committed whichever card
## the pointer happened to leave last. `choose_foundation_package()` latches for
## the life of the character, so the player would have been given a package they
## never picked, with no way back.
var hovered_index: int = -1
var confirmations: int = 0


func modal_name() -> String:
	return "the Foundation Cache"


func default_focus() -> Control:
	return _close


func cancel_closes() -> bool:
	return true


func _runtime() -> CanonicalOpeningRuntime:
	return room as CanonicalOpeningRuntime


func build_contents() -> void:
	var panel: PanelContainer = make_panel(920)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	add_child(panel)

	var column: VBoxContainer = VBoxContainer.new()
	column.add_theme_constant_override("separation", 12)
	panel.add_child(column)

	column.add_child(make_title("Foundation Cache"))
	column.add_child(make_line("Choose what you explore first.", 14, TEXT))
	column.add_child(make_rule())

	var row: HBoxContainer = HBoxContainer.new()
	row.name = "PackageRow"
	row.add_theme_constant_override("separation", 16)
	column.add_child(row)
	_cards.clear()
	for index: int in 3:
		var card: Button = _make_card(index)
		row.add_child(card)
		_cards.append(card)

	column.add_child(make_rule())
	_detail_title = make_line("", 16, COPPER)
	_detail_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_detail_title)
	_detail_body = make_line("", 14, TEXT)
	_detail_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_detail_body.custom_minimum_size = Vector2(0, 62)
	column.add_child(_detail_body)

	column.add_child(make_rule())
	# THE FOUR REQUIRED STATEMENTS, ON SCREEN, BEFORE CONFIRMATION.
	_promise_lines.clear()
	for text: String in [
		"This chooses the direction you explore FIRST. It is not a class choice.",
		"It is not a permanent lock. Nothing here is closed off to you.",
		"The other two Skills — and ordinary equipment that suits them — become available through the next two Survey milestones. Not by chance: deterministically.",
		"Quick Strike stays learned. You can use it whenever its weapon requirements are met.",
	]:
		var line: Label = make_line("·  %s" % text, 13, TEXT_DIM)
		line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		column.add_child(line)
		_promise_lines.append(line)

	var actions: HBoxContainer = HBoxContainer.new()
	actions.alignment = BoxContainer.ALIGNMENT_END
	actions.add_theme_constant_override("separation", 12)
	column.add_child(actions)

	_close = make_button("Not yet", &"ui_cancel")
	_close.pressed.connect(func() -> void: close("closed without choosing"))
	actions.add_child(_close)

	_confirm = make_button("Choose", &"ui_confirm")
	_confirm.pressed.connect(_on_confirm)
	actions.add_child(_confirm)

	_wire_focus_graph()


func _make_card(index: int) -> Button:
	var card: Button = Button.new()
	card.name = "Package%d" % index
	card.focus_mode = Control.FOCUS_ALL
	card.custom_minimum_size = Vector2(CARD_WIDTH, CARD_HEIGHT)
	for state: String in ["normal", "hover", "pressed", "focus", "disabled"]:
		var style: StyleBoxFlat = StyleBoxFlat.new()
		style.bg_color = SLATE_DEEP if state != "focus" else Color(0.12, 0.13, 0.15, 1.0)
		style.border_color = COPPER if state == "focus" or state == "hover" else IRON
		style.set_border_width_all(2 if state == "focus" else 1)
		style.set_corner_radius_all(2)
		style.set_content_margin_all(12)
		card.add_theme_stylebox_override(state, style)

	var inner: VBoxContainer = VBoxContainer.new()
	inner.name = "Card"
	inner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inner.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	inner.add_theme_constant_override("separation", 5)
	for entry: Array in [["Kind", 12, TEXT_DIM], ["SkillName", 16, COPPER], ["Tags", 11, TEXT_DIM],
		["WeaponName", 14, TEXT], ["WeaponLine", 11, TEXT_DIM], ["Identity", 12, TEXT]]:
		var label: Label = make_line("", int(entry[1]), entry[2] as Color)
		label.name = String(entry[0])
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		inner.add_child(label)
	card.add_child(inner)

	# A click COMMITS. Controller focus commits too, because focus IS the
	# controller's selection and it only moves on a deliberate press.
	card.pressed.connect(func() -> void: _select(index))
	card.focus_entered.connect(func() -> void: _select(index))
	# The mouse only PREVIEWS. Passing over a card must never change what
	# Choose will act on.
	card.mouse_entered.connect(func() -> void: _hover(index))
	card.mouse_exited.connect(func() -> void: _hover(selected_index))
	return card


func _wire_focus_graph() -> void:
	for index: int in _cards.size():
		var card: Button = _cards[index]
		if index > 0:
			card.focus_neighbor_left = _cards[index - 1].get_path()
		if index + 1 < _cards.size():
			card.focus_neighbor_right = _cards[index + 1].get_path()
		card.focus_neighbor_bottom = _confirm.get_path()
	_close.focus_neighbor_right = _confirm.get_path()
	_confirm.focus_neighbor_left = _close.get_path()
	if not _cards.is_empty():
		_close.focus_neighbor_top = _cards[0].get_path()
		_confirm.focus_neighbor_top = _cards[0].get_path()


func refresh_contents() -> void:
	var runtime: CanonicalOpeningRuntime = _runtime()
	if runtime == null:
		return
	_packages = runtime.foundation_packages()
	for index: int in mini(_cards.size(), _packages.size()):
		_fill_card(_cards[index], _packages[index])
	if selected_index < 0 and not _packages.is_empty():
		_select(0)
	else:
		_refresh_detail()


func _fill_card(card: Button, package: Dictionary) -> void:
	var skill: FirstMvpSkillData = package["skill"]
	var weapon: FirstMvpWeaponRecord = package["weapon"]
	_set_card_label(card, "Kind", CharacterState.package_name(
		package["package"] as CharacterState.FoundationPackage).to_upper())
	_set_card_label(card, "SkillName", skill.display_name)
	_set_card_label(card, "Tags", skill.tag_line())
	_set_card_label(card, "WeaponName", weapon.display_name)
	_set_card_label(card, "WeaponLine", "%s · %s · %.0f %s" % [
		weapon.base_type, weapon.hands_name(), weapon.physical_damage, weapon.damage_type,
	])
	_set_card_label(card, "Identity", skill.identity)


func _set_card_label(card: Button, label_name: String, text: String) -> void:
	var label: Label = card.get_node_or_null("Card/%s" % label_name) as Label
	if label != null:
		label.text = text


func _select(index: int) -> void:
	selected_index = index
	hovered_index = index
	_refresh_detail()


## Preview only. Never touches `selected_index`, so `_on_confirm()` cannot be
## steered by the pointer's path across the panel.
func _hover(index: int) -> void:
	hovered_index = index if index >= 0 else selected_index
	_refresh_detail()


## Every factual consequence of the selected package, computed rather than
## written down: what the Skill costs, what it needs, what it would deal, what
## the weapon is, and what equipping it would displace.
func _refresh_detail() -> void:
	var runtime: CanonicalOpeningRuntime = _runtime()
	var shown: int = hovered_index if hovered_index >= 0 else selected_index
	if runtime == null or shown < 0 or shown >= _packages.size():
		return
	var package: Dictionary = _packages[shown]
	var skill: FirstMvpSkillData = package["skill"]
	var weapon: FirstMvpWeaponRecord = package["weapon"]
	_detail_title.text = "%s  ·  %s" % [skill.display_name, weapon.display_name]

	var equipped: PrototypeWeaponData = runtime.character.equipment.equipped_weapon
	var lines: PackedStringArray = PackedStringArray()
	lines.append("%s — %s. %.2f s action, %.0f Mana." % [
		skill.tag_line(), skill.requirement_line().to_lower(), skill.action_time, skill.mana_cost,
	])
	if skill.is_spell():
		lines.append("Spell damage: %.0f %s per Hit, defined by the Skill rather than by the weapon." % [
			skill.spell_damage, skill.damage_type,
		])
	else:
		lines.append("Attack damage: %.0f %s per Hit with the %s (%.0f x %.2f)." % [
			skill.hit_damage(weapon), skill.damage_type, weapon.display_name,
			weapon.physical_damage, skill.weapon_damage_scale,
		])
	lines.append("%s is added to your items. %s stays yours and stays equipped until you change it." % [
		weapon.display_name, equipped.display_name if equipped != null else "Your current weapon",
	])
	if weapon.occupies_off_hand():
		lines.append("Two-handed: it occupies Main Hand and Off Hand together.")
	lines.append("Implicit: %s" % weapon.implicit_text)
	_detail_body.text = "\n".join(lines)

	# WHEN HOVER AND CHOICE DISAGREE, SAY SO. Otherwise the panel would show one
	# package's numbers above a button that takes a different one.
	if shown != selected_index and selected_index >= 0 and selected_index < _packages.size():
		var committed: FirstMvpSkillData = _packages[selected_index]["skill"]
		lines.append("Previewing this. Choose will take %s — click this card to change that." % committed.display_name)
		_detail_body.text = "\n".join(lines)
	var granted: bool = runtime.character.foundation_package_granted
	_confirm.disabled = granted or selected_index < 0
	if granted:
		_detail_title.text = "%s — already chosen" % _detail_title.text


func _on_confirm() -> void:
	var runtime: CanonicalOpeningRuntime = _runtime()
	if runtime == null or selected_index < 0 or selected_index >= _packages.size():
		return
	var package: CharacterState.FoundationPackage = _packages[selected_index]["package"]
	if runtime.choose_foundation_package(package):
		confirmations += 1
		close("chose %s" % CharacterState.package_name(package))
	else:
		_refresh_detail()


# --- Readable state, for the checks --------------------------------------------

func promise_text() -> String:
	var parts: PackedStringArray = PackedStringArray()
	for label: Label in _promise_lines:
		parts.append(label.text)
	return "\n".join(parts)


func card_text(index: int) -> String:
	if index < 0 or index >= _cards.size():
		return ""
	var parts: PackedStringArray = PackedStringArray()
	_collect(_cards[index], parts)
	return "\n".join(parts)


func detail_text() -> String:
	return "%s\n%s" % [_detail_title.text, _detail_body.text]


func card_count() -> int:
	return _cards.size()


func select_for_verification(index: int) -> void:
	_select(index)


func hover_for_verification(index: int) -> void:
	_hover(index)


func confirm_for_verification() -> void:
	_on_confirm()


func _collect(node: Node, into: PackedStringArray) -> void:
	for child: Node in node.get_children():
		var label: Label = child as Label
		if label != null and not label.text.strip_edges().is_empty():
			into.append(label.text)
		_collect(child, into)
