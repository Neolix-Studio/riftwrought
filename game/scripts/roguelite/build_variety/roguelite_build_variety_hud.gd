class_name RogueliteBuildVarietyHud
extends RogueliteReplayabilityHud
## Riftwrought — Roguelite Build Variety V1: the accepted run banner, plus the
## build the expedition is carrying and the four numbers it moves (D-223).
##
## AN EXTENSION OF TWO ACCEPTED BANNERS, NOT A THIRD ONE. `RogueliteRunHud`
## (D-220) owns where the player is, what is left alive, the run identifier, the
## seed, the selection mode and the gate prompt. `RogueliteReplayabilityHud`
## (D-222) added the selected room sequence. Neither is edited. This subclass
## adds exactly the two things a BUILD has that a route does not:
##
##   THE UPGRADES HELD, both of them, named — because "which two did I take?"
##   is the question the whole review exists to make askable, and a player
##   comparing two runs cannot answer it from feel alone.
##
##   THE FOUR LIVE COMBAT NUMBERS the upgrades move: Quick Strike damage, action
##   time, reach and release arc. They are read from the KERNEL, never derived
##   from the upgrade list — see `_refresh_build()`.
##
## IT REPLACES THE INHERITED REWARD/BOON LINES RATHER THAN ADDING BESIDE THEM.
## `RogueliteRunHud._describe_reward()` is computed from two item flags, and
## `RogueliteReplayabilityHud._refresh_boon()` from a single `RogueliteRunBoon`.
## Neither can describe a build of two upgrades of which at most one is an item;
## left alone, the banner would have read "Run reward: not yet earned" for a
## player holding a Reaching Edge and a Sweeping Edge. The parent calls
## `_refresh_boon()` from its own `refresh()`, so OVERRIDING that one function
## is all it takes — the inherited route panel, gate prompt and identity lines
## keep working untouched.
##
## NOT FINAL UI. The same restrained flat placeholder language every prior
## gate's instrumentation used.

const HELD: Color = Color(0.85, 0.72, 0.42)

var _build_heading: Label
var _build_line: Label
var _stats_heading: Label
var _stat_lines: Array[Label] = []


func _build() -> void:
	super()
	var box: VBoxContainer = _selection.get_parent() as VBoxContainer

	## THE INHERITED THREAT LINE IS GIVEN WRAPPING, AND ONLY THE 1280x720 FRAME
	## SHOWED WHY IT NEEDED IT. `RogueliteRunHud` builds `_threat` with no
	## autowrap because every line it ever writes is short ("Enemies remaining:
	## 2"). The sealed-gate line this subclass writes is much longer, and a
	## non-wrapping Label makes its PanelContainer as wide as its text — which
	## pushed the whole run banner past the right edge of the minimum tested
	## window. The on-screen check did not catch it: a clipped label still
	## intersects the viewport, so the rectangle test was satisfied. Gate F's
	## lesson exactly, at the size Gate F learned it: render at 1280x720 and look
	## at the picture.
	_threat.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	box.add_child(_rule())
	_build_heading = _line("Build — temporary", 12, COPPER)
	box.add_child(_build_heading)
	_build_line = _line("", 12, HELD)
	_build_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(_build_line)

	_stats_heading = _line("Quick Strike — live", 12, COPPER)
	box.add_child(_stats_heading)
	for row: int in 4:
		var label: Label = _line("", 12, TEXT)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(label)
		_stat_lines.append(label)


func refresh() -> void:
	super()
	_refresh_build()


## OVERRIDES THE INHERITED BOON LINE COMPLETELY. `RogueliteReplayabilityHud`
## computes these two lines from `RogueliteReplayabilityRuntime.run_boon`, which
## this review never sets — it grants through `RogueliteBuildState` instead — so
## left alone the banner would have told a player holding two upgrades that no
## run reward had been earned. The parent calls this from its own `refresh()`,
## so replacing it here is the smallest possible change that makes the whole
## inherited banner correct.
func _refresh_boon() -> void:
	var runner: RogueliteBuildVarietyRuntime = runtime as RogueliteBuildVarietyRuntime
	if runner == null or _reward == null:
		return
	var build: RogueliteBuildState = runner.build
	var taken: int = 0 if build == null else build.count()
	if runner.awaiting_upgrade_choice():
		_reward.text = "Upgrades: a cache is open — choose one"
	else:
		_reward.text = "Upgrades: %d of %d taken" % [
			taken, RogueliteBuildVarietyRunPlan.CHOICES_PER_RUN,
		]
	_boon.text = runner.build_effect_line()
	_boon.visible = not _boon.text.is_empty()


## THE NUMBERS COME FROM THE KERNEL, NOT FROM THE UPGRADE LIST, AND THAT IS THE
## WHOLE POINT OF THE LINE. `live_combat_values()` reads
## `player.attack.data` — the private runtime record
## `TargetAcquisition.resolve_release()` is handed on every swing — and
## `player.physical_damage`, which reads the equipped weapon. A banner that
## recomputed these from "I hold a Reaching Edge" would agree with the upgrade
## list and could still disagree with the game; this one cannot, because there
## is nothing else for it to read.
func _refresh_build() -> void:
	var runner: RogueliteBuildVarietyRuntime = runtime as RogueliteBuildVarietyRuntime
	if runner == null or _build_line == null:
		return
	var build: RogueliteBuildState = runner.build
	_build_line.text = ("none yet — %d choice(s) ahead" % RogueliteBuildVarietyRunPlan.CHOICES_PER_RUN
		if build == null or build.is_empty() else build.build_line())
	_build_line.add_theme_color_override("font_color",
		TEXT_DIM if build == null or build.is_empty() else HELD)

	## THE BANNER MUST NOT SAY THE GATE IS OPEN WHILE IT IS SEALED, AND ONLY A
	## RENDERED FRAME SHOWED THAT IT DID. `RogueliteRunHud.refresh()` writes
	## "Cleared — the Rift Gate is open" the moment the last enemy falls,
	## because in the accepted core loop clearing a room IS what opens its gate.
	## Here it is not: a cache beat stays sealed until the choice is taken. Left
	## alone the banner told the player to walk to a gate that would not let
	## them through — the same family as the accepted review's own defect, where
	## the hub's always-open gate was painted in the SEALED colour. This is the
	## LAST write to the line, so it wins over every inherited one.
	if runner.awaiting_upgrade_choice():
		_threat.text = "Cleared — a cache is open.\nThe Rift Gate stays sealed until you choose."
		_threat.add_theme_color_override("font_color", SEALED)

	var live: Dictionary = runner.live_combat_values()
	var base: Dictionary = runner.baseline_combat_values()
	_stat_lines[0].text = _stat("Physical Hit", "%.0f", live, base, "damage")
	_stat_lines[1].text = _stat("Action time", "%.2f s", live, base, "action_time")
	_stat_lines[2].text = _stat("Reach", "%.2f m", live, base, "reach")
	_stat_lines[3].text = _stat("Release arc", "%.0f°", live, base, "arc")
	for index: int in _stat_lines.size():
		var key: String = ["damage", "action_time", "reach", "arc"][index]
		var moved: bool = not is_equal_approx(float(live.get(key, 0.0)), float(base.get(key, 0.0)))
		_stat_lines[index].add_theme_color_override("font_color", HELD if moved else TEXT)


## A live value, and — only when it has moved — the authored baseline beside it,
## so the banner states the CHANGE rather than leaving the reader to remember
## what 1.65 was.
static func _stat(caption: String, format: String, live: Dictionary, base: Dictionary, key: String) -> String:
	var now: float = float(live.get(key, 0.0))
	var was: float = float(base.get(key, 0.0))
	if is_equal_approx(now, was):
		return "%s: %s" % [caption, format % now]
	return "%s: %s (was %s)" % [caption, format % now, format % was]


func text_controls() -> Array[Label]:
	var found: Array[Label] = super()
	found.append(_build_heading)
	found.append(_build_line)
	found.append(_stats_heading)
	for label: Label in _stat_lines:
		found.append(label)
	return found
