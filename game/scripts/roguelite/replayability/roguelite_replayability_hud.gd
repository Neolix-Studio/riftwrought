class_name RogueliteReplayabilityHud
extends RogueliteRunHud
## Riftwrought — Roguelite Replayability V1: the accepted run banner, plus the
## two things a seeded run has that a fixed one does not (decision D-222).
##
## AN EXTENSION OF THE ACCEPTED BANNER, NOT A SECOND ONE. `RogueliteRunHud` is
## an accepted, playtested surface that already owns where the player is, what
## is left alive, the run identifier, the seed, the selection mode and the gate
## prompt, and it is not edited here. This subclass calls its `_build()` and
## `refresh()` and adds exactly two things:
##
##   THE SELECTED ROOM SEQUENCE, which is the whole point of the review. The
##   brief asks for the seed AND the selected room sequence to be displayed
##   clearly, and a seed with no visible consequence would make the review
##   unaskable — the owner could not tell two runs apart except by feel.
##
##   THE ACTIVE BOON, because the accepted banner's reward line is computed
##   from `reward_granted` / `reward_equipped` alone, and that pair cannot
##   describe a boon which is not an item at all. Left unchanged it would have
##   read "on the ground, not equipped" for a Quickened Edge that is neither.
##
## WHICH PLAN THE ROUTE IS READ FROM IS DELIBERATE AND IS LABELLED ON SCREEN.
## Inside a run it is the run's own plan; in the Nexus it is `runtime.plan`,
## which is the plan the NEXT expedition will actually use — the accepted
## runtime advances the plan when a run ends, so the Nexus already advertises
## the next identifier and the route now agrees with it. The heading says
## "Route" or "Next route" rather than leaving the reader to infer which.
##
## NOT FINAL UI. The same restrained flat placeholder language every prior
## gate's instrumentation used.

const CURRENT: Color = Color(0.68, 0.55, 0.95)
const DONE: Color = Color(0.62, 0.86, 0.58)

var _boon: Label
var _route_heading: Label
var _route_steps: Array[Label] = []


func _build() -> void:
	super()
	var box: VBoxContainer = _selection.get_parent() as VBoxContainer

	_boon = _line("", 12, TEXT_DIM)
	_boon.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_boon)
	box.move_child(_boon, _reward.get_index() + 1)

	box.add_child(_rule())
	_route_heading = _line("Route", 12, COPPER)
	box.add_child(_route_heading)
	for step: int in RogueliteRoomLibrary.BEAT_ORDER.size():
		var label: Label = _line("", 12, TEXT)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(label)
		_route_steps.append(label)


func refresh() -> void:
	super()
	if runtime == null or _route_heading == null:
		return
	_refresh_route()
	_refresh_boon()


func _refresh_route() -> void:
	var replay: RogueliteReplayabilityRuntime = runtime as RogueliteReplayabilityRuntime
	var in_run: bool = runtime.loop_state == RogueliteCoreLoopRuntime.LoopState.IN_RUN
	## Inside a run, the run's own plan; otherwise the plan the next expedition
	## will use. Never inferred — the heading says which.
	var plan: RogueliteRunPlan = runtime.run_state.plan if in_run else runtime.plan
	var seeded: RogueliteSeededRunPlan = plan as RogueliteSeededRunPlan
	_route_heading.text = ("Route — seeded" if in_run else "Next route — seeded")
	if seeded == null:
		for label: Label in _route_steps:
			label.text = ""
		return

	var selected: Array[StringName] = seeded.ordered_modules()
	var here: int = runtime.run_state.current_room_index if in_run else -1
	for step: int in _route_steps.size():
		var label: Label = _route_steps[step]
		if step >= selected.size():
			label.text = ""
			continue
		var caption: String = RogueliteRoomLibrary.beat_caption(RogueliteRoomLibrary.BEAT_ORDER[step])
		var room: String = RogueliteRoomLibrary.display_name_of(selected[step])
		var mark: String = ""
		var colour: Color = TEXT_DIM
		if step == here:
			mark = "  ← here"
			colour = CURRENT
		elif in_run and runtime.run_state.is_cleared(step):
			mark = "  ✓"
			colour = DONE
		label.text = "%d · %s — %s%s" % [step + 1, caption, room, mark]
		label.add_theme_color_override("font_color", colour)
	if replay != null and replay.awaiting_boon_choice():
		_route_heading.text = "Route — seeded · cache open"


## Replaces the accepted banner's reward line wholesale rather than adding
## beside it, because that line is computed from two item flags that cannot
## describe a boon which is not an item.
func _refresh_boon() -> void:
	var replay: RogueliteReplayabilityRuntime = runtime as RogueliteReplayabilityRuntime
	if replay == null:
		return
	var boon: RogueliteRunBoon = replay.run_boon
	if boon == null or boon.is_none():
		_reward.text = ("Run reward: choosing…" if replay.awaiting_boon_choice()
			else "Run reward: not yet earned")
		_boon.text = ""
		return
	if boon.is_weapon():
		_reward.text = ("Run reward: %s, equipped" % boon.display_name()
			if runtime.run_state.reward_equipped
			else "Run reward: %s, on the ground" % boon.display_name())
		_boon.text = replay.boon_effect_line()
		return
	_reward.text = "Run reward: %s, active" % boon.display_name()
	_boon.text = replay.boon_effect_line()


func text_controls() -> Array[Label]:
	var found: Array[Label] = super()
	found.append(_boon)
	found.append(_route_heading)
	for label: Label in _route_steps:
		found.append(label)
	return found
