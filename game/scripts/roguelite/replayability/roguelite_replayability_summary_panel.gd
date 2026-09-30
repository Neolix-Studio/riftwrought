class_name RogueliteReplayabilitySummaryPanel
extends RogueliteRunSummaryPanel
## Riftwrought — Roguelite Replayability V1: the accepted run-complete panel,
## plus the route it was run on and the boon it was run with (D-222).
##
## AN EXTENSION, NOT A SECOND PANEL. `RogueliteRunSummaryPanel` is accepted and
## playtested; it already reports which run it was, how many rooms cleared, and
## states plainly that nothing is kept. It is not edited. This subclass adds
## the two facts a replayability review exists to make visible — WHICH rooms
## this run used, and WHICH of the two boons was taken — and adds them where a
## reader will look for them, immediately under the reward line, rather than
## appending them after the button.
##
## EVERY LINE IS STILL COMPUTED, NEVER WRITTEN DOWN, and the panel still awards
## nothing: no experience, no currency, no unlock, no mastery, no pursuit
## progress and no permanent record. It reports a finished run and offers one
## way out of itself.

var _route: Label
var _boon: Label


func build_contents() -> void:
	super()
	var box: VBoxContainer = _reward.get_parent() as VBoxContainer

	_route = make_line("", 14, TEXT)
	_route.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_route)
	box.move_child(_route, _rooms.get_index() + 1)

	_boon = make_line("", 14, TEXT)
	_boon.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_boon)
	box.move_child(_boon, _reward.get_index() + 1)


func refresh_contents() -> void:
	super()
	if _state == null or _route == null:
		return
	var seeded: RogueliteSeededRunPlan = _state.plan as RogueliteSeededRunPlan
	_route.text = "Route: %s" % (seeded.route_line() if seeded != null else "unknown")
	var replay: RogueliteReplayabilityRuntime = room as RogueliteReplayabilityRuntime
	var boon: RogueliteRunBoon = replay.completed_run_boon if replay != null else null
	## The accepted reward line describes the ground item, which is only one of
	## the two ways this review's reward can arrive; this states what was
	## actually taken, including when it was the one that is not an item.
	_boon.text = "Boon taken: %s" % ("none" if boon == null or boon.is_none() else boon.one_line())


func text_controls() -> Array[Control]:
	var found: Array[Control] = super()
	found.append(_route)
	found.append(_boon)
	return found
