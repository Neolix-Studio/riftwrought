class_name RogueliteBuildVarietySummaryPanel
extends RogueliteReplayabilitySummaryPanel
## Riftwrought — Roguelite Build Variety V1: the accepted run-complete panel,
## plus the BUILD the run was finished with (decision D-223).
##
## AN EXTENSION, NOT A THIRD PANEL. `RogueliteRunSummaryPanel` (D-220) reports
## which run it was, how many rooms cleared, and states plainly that nothing is
## kept. `RogueliteReplayabilitySummaryPanel` (D-222) added the route. Neither
## is edited. This subclass replaces the single "Boon taken" line — which can
## only name one thing, and this review takes two — with the concise final build
## summary the brief asks for, and adds the four numbers that build ended on.
##
## IT READS A SNAPSHOT, AND THE SNAPSHOT EXISTS BECAUSE THE RESET RUNS FIRST.
## `_complete_run()` deliberately clears the run's state BEFORE opening this
## panel, so the Nexus banner behind it is already telling the truth about what
## the player is holding. That means the live kernel values at the moment this
## panel is read are the BASELINE ones, not the ones the run was played with.
## The runtime therefore captures the live values into `RogueliteBuildState`
## immediately before the reset, and this panel reports that capture — the same
## device `RogueliteReplayabilityRuntime.completed_run_boon` uses, for the same
## reason.
##
## THE BASELINE IS PRINTED BESIDE IT ON PURPOSE. "Nothing here is kept" is a
## sentence; "you finished at 2.65 m and you are back to 1.65 m" is the same
## claim in numbers the player can check against the banner behind the panel.
##
## THE PANEL STILL AWARDS NOTHING: no experience, no currency, no unlock, no
## mastery, no pursuit progress and no permanent record. It reports a finished
## run and offers one way out of itself.

var _build_heading: Label
var _build_values: Label
var _baseline_values: Label


func build_contents() -> void:
	super()
	var box: VBoxContainer = _boon.get_parent() as VBoxContainer

	_build_heading = make_line("", 14, TEXT)
	_build_heading.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_build_heading)
	box.move_child(_build_heading, _boon.get_index() + 1)

	_build_values = make_line("", 13, TEXT_DIM)
	_build_values.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_build_values)
	box.move_child(_build_values, _build_heading.get_index() + 1)

	_baseline_values = make_line("", 13, TEXT_DIM)
	_baseline_values.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_baseline_values)
	box.move_child(_baseline_values, _build_values.get_index() + 1)


func refresh_contents() -> void:
	super()
	if _build_heading == null:
		return
	var runner: RogueliteBuildVarietyRuntime = room as RogueliteBuildVarietyRuntime
	var finished: RogueliteBuildState = runner.completed_build if runner != null else null

	## Replaces the inherited single-boon line. It cannot describe two upgrades
	## and would have read "Boon taken: none" for every run of this review.
	_boon.text = "Build taken: %s" % (
		"nothing" if finished == null or finished.is_empty() else finished.build_line())

	## AND THE INHERITED REWARD LINE IS RETITLED, BECAUSE THIS REVIEW MADE IT
	## AMBIGUOUS. It is computed from the two ITEM flags, so on a run that took
	## two edges and no weapon it read "Temporary reward: none granted" directly
	## above "Build taken: Reaching Edge + Sweeping Edge" — two lines about
	## rewards, one of them saying nothing was granted. Only a rendered frame
	## showed how that reads. The line is true; it is about the WEAPON, and it
	## now says so.
	_reward.text = "Ground weapon: %s" % (
		"the Expedition Blade was not part of this build"
		if finished == null or not finished.held(RogueliteUpgrade.Kind.EXPEDITION_BLADE)
		else ("Expedition Blade, equipped — and it ends with the run"
			if _state != null and _state.reward_equipped
			else "Expedition Blade granted, left on the ground"))

	if finished == null or not finished.has_capture():
		_build_heading.text = ""
		_build_heading.visible = false
		_build_values.text = ""
		_build_values.visible = false
		_baseline_values.text = ""
		_baseline_values.visible = false
		return

	_build_heading.text = "%d of %d upgrade(s) taken" % [
		finished.count(), RogueliteBuildVarietyRunPlan.CHOICES_PER_RUN,
	]
	_build_heading.visible = true
	_build_values.text = "Quick Strike at the end: %s" % _values_line(finished.final_values)
	_build_values.visible = true
	_baseline_values.text = "Back to baseline now: %s" % (
		_values_line(runner.baseline_combat_values()) if runner != null else "unknown")
	_baseline_values.visible = true


## One line, four numbers, in the same order and the same formats the run banner
## uses — so a reader comparing the panel with the banner behind it is comparing
## like with like.
static func _values_line(values: Dictionary) -> String:
	return "%.0f Physical · %.2f s · %.2f m · %.0f°" % [
		float(values.get("damage", 0.0)), float(values.get("action_time", 0.0)),
		float(values.get("reach", 0.0)), float(values.get("arc", 0.0)),
	]


func text_controls() -> Array[Control]:
	var found: Array[Control] = super()
	found.append(_build_heading)
	found.append(_build_values)
	found.append(_baseline_values)
	return found
