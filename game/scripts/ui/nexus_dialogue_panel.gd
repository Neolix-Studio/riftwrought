class_name NexusDialoguePanel
extends FirstMvpModal
## First-MVP — Gate 1E: the first conversation on screen (D-219).
##
## Subclasses Gate 1D's `FirstMvpModal` with NO edit to it, because
## `CanonicalOpeningRuntime` IS a `BrokenWatchSlice` and that is the owner type
## the base declares. So the whole proven contract — pause, neutralize, safe
## focus, neutral-input arming, live glyphs — is inherited rather than copied a
## third time.
##
## TEXT-FIRST, SKIPPABLE, REPLAY-SAFE, all three required by the brief and by
## `design/NARRATIVE_WORLD_AND_FIRST_REGION.md` §20 ("Text-first dialogue and a
## small reusable pose and gesture set are sufficient. Full voice acting is not
## required").
##
##   CONTINUE  advances one line, and on the last line closes.
##   SKIP      jumps to the last line. Skipping still counts as having read it.
##
## There is no player line, no choice, no branch, and no timer. The brief: "Do
## not add unnecessary player dialogue branches."
##
## REPLAYING GRANTS NOTHING, and that is a property of where the reward lives
## rather than of anything this panel remembers. `CharacterState`'s latches own
## the milestone; this panel just shows words. Opening it a second time shows
## the same four lines again and changes no number anywhere.
##
## CONTINUE IS THE DEFAULT FOCUS because it is the safe, non-destructive
## control — the same rule every modal in this project follows.

var conversation: FirstMvpDialogue

var _speaker: Label
var _line: Label
var _progress: Label
var _continue: Button
var _skip: Button

var lines_read: int = 0


func modal_name() -> String:
	return "the first conversation"


func default_focus() -> Control:
	return _continue


func cancel_closes() -> bool:
	return true


func build_contents() -> void:
	var panel: PanelContainer = make_panel(640)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	add_child(panel)

	var column: VBoxContainer = VBoxContainer.new()
	column.add_theme_constant_override("separation", 14)
	panel.add_child(column)

	_speaker = make_title("Mara Veyl")
	column.add_child(_speaker)
	var subtitle: Label = make_line("the Last Surveyor", 13, TEXT_DIM)
	column.add_child(subtitle)
	column.add_child(make_rule())

	_line = make_line("", 17, TEXT)
	_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_line.custom_minimum_size = Vector2(0, 92)
	column.add_child(_line)

	_progress = make_line("", 12, TEXT_DIM)
	column.add_child(_progress)
	column.add_child(make_rule())

	var row: HBoxContainer = HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_END
	row.add_theme_constant_override("separation", 12)
	column.add_child(row)

	_skip = make_button("Skip", &"ui_cancel")
	_skip.pressed.connect(_on_skip)
	row.add_child(_skip)

	_continue = make_button("Continue", &"ui_confirm")
	_continue.pressed.connect(_on_continue)
	row.add_child(_continue)

	# Controller focus moves between exactly two controls, so the graph is
	# stated rather than left to Godot's spatial guess.
	_skip.focus_neighbor_right = _continue.get_path()
	_continue.focus_neighbor_left = _skip.get_path()
	_skip.focus_next = _continue.get_path()
	_continue.focus_previous = _skip.get_path()


func open_conversation(which: FirstMvpDialogue) -> void:
	conversation = which
	conversation.begin()
	open()


func refresh_contents() -> void:
	if conversation == null:
		return
	_speaker.text = conversation.current_speaker()
	_line.text = conversation.current_line()
	_progress.text = conversation.progress_line()
	_continue.text = "Close" if conversation.is_last_line() else "Continue"
	var caption: Label = _first_label_in(_continue)
	if caption != null:
		caption.text = _continue.text
	# HIDING A FOCUSED CONTROL RELEASES FOCUS AND DEAD-ENDS THE CONTROLLER.
	# On the last line Skip disappears; if it held focus at that moment the modal
	# would have no focus owner at all and `ui_confirm` would activate nothing.
	# Focus is moved BEFORE the control goes away.
	var skip_should_show: bool = not conversation.is_last_line()
	if not skip_should_show and _skip.has_focus():
		_continue.grab_focus()
	_skip.visible = skip_should_show


func _first_label_in(button: Button) -> Label:
	for child: Node in button.get_children():
		for grandchild: Node in child.get_children():
			var label: Label = grandchild as Label
			if label != null:
				return label
	return null


func _on_continue() -> void:
	if conversation == null:
		close("no conversation")
		return
	lines_read += 1
	if conversation.advance():
		refresh_contents()
		return
	_finish()


func _on_skip() -> void:
	if conversation == null:
		return
	conversation.skip_to_end()
	refresh_contents()


func _finish() -> void:
	var runtime: CanonicalOpeningRuntime = room as CanonicalOpeningRuntime
	if runtime != null:
		runtime.on_dialogue_finished()
	close("read through")
