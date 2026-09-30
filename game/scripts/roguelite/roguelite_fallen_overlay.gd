class_name RogueliteFallenOverlay
extends FirstMvpFallenOverlay
## Riftwrought — Roguelite Core Loop Review: Fallen (decision D-220).
##
## A SUBCLASS OF GATE 1D's OVERLAY, NOT AN EDIT TO IT AND NOT A COPY OF IT.
## `FirstMvpFallenOverlay` is accepted, playtested and stays byte-identical
## here; its button reads "Restart Broken Watch" and its caption reads "F5 also
## restarts.", both exactly right for Gate 1D and both a lie in a roguelite.
## Subclassing changes those strings and nothing else: the whole proven
## contract underneath — pause, neutralize through the room's own path, safe
## non-destructive focus first, refusal of a control that was already held when
## death occurred, live input-family glyphs, the fade, and the accurate killing
## source built from the real `DamageEvent` rather than from a literal — is
## inherited unmodified.
##
## THE BUTTON IS WIRED TO THE BASE'S OWN `_on_restart()`, ON PURPOSE. That
## handler closes and then calls `room.restart_current_slice()`, and the base's
## `_input()` routes `F5` (`quick_restart`) to the same handler. Wiring the new
## button anywhere else would give the key and the button two paths that could
## drift apart; wiring it here means they cannot. The runtime overrides
## `restart_current_slice()` to return to the Nexus and throw the whole
## `RogueliteRunState` away, so "death returns to the Nexus and resets
## temporary run-only rewards" is one call reached two ways.
##
## WHAT IT IS NOT: no Rift Anchor, no Anchor spend, no Recovery Cache, no
## Review Death trace, no run-exhausted state, and no persistence of any kind.
## `design/DEATH_AND_RECOVERY.md`'s full model is a first-MVP system with its
## own authorization; this is the already-proven minimal Fallen the review
## needs in order to ask its one question.

func modal_name() -> String:
	return "fallen"


## Replaces the base's contents wholesale — the base's own `build_contents()`
## is deliberately not called, so its two Gate 1D strings never reach the
## screen. Every widget the base's `open_for()` and `default_focus()` reach
## (`_title`, `_source`, `_detail`, `_restart`) is assigned here, so nothing
## inherited is left null.
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

	var note: Label = make_line(
		"The expedition ends here. Whatever it granted was temporary and goes with it. "
			+ "Nothing you brought in is lost, because nothing is kept between runs yet.",
		12, TEXT_DIM
	)
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(note)

	_restart = make_button("Return to the Nexus", &"ui_confirm")
	_restart.custom_minimum_size = Vector2(512, 44)
	_restart.pressed.connect(_on_restart)
	box.add_child(_restart)
	box.add_child(make_line("F5 also abandons the run and returns to the Nexus.", 11, TEXT_DIM))

	panel.add_child(box)
	add_child(panel)


## Every visible label and button this surface owns, for the on-screen
## measurement the review's verification runs — Gate F shipped a HUD and four
## modals nobody could see while every text assertion passed.
func text_controls() -> Array[Control]:
	return [_title, _source, _detail, _restart]
