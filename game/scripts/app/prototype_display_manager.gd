class_name PrototypeDisplayManager
extends Node
## Prototype Zero — Gate F: safe Windowed / Fullscreen and resolution changes
## (specification §4.3, §21 Display, §23.6, decision D-189).
##
## Specification §4.3: "Resolution changes require a timed keep/revert
## confirmation so a bad display choice cannot trap the user."
## Specification §23.6 pass condition: "display or save failure cannot strand
## the test."
##
## TWO PROTECTIONS, BECAUSE ONE IS NOT ENOUGH.
##
##   THE TIMED PROMPT protects a user who is still there. Applying a change opens
##   a countdown whose DEFAULT FOCUS IS REVERT, so pressing the confirm button
##   without reading reverts, and letting the timer run out reverts. Only a
##   deliberate move to Keep keeps it.
##
##   THE STARTUP MARKER protects a user who is not. A timer cannot fire if the
##   process is force-quit, crashes, or is closed while the screen is unreadable,
##   and the bad mode would then be what boots next time. So the attempt is
##   written to the settings file BEFORE it is applied, together with the display
##   values that were known good. `recover_if_interrupted()` runs on startup: a
##   pending marker means the last attempt was never confirmed, so the known-good
##   values are applied, the marker is cleared, and the app is told to say so.
##
## Nothing here writes the lab state. Display is a comfort setting and lives in
## the settings file only.

## Specification §21 asks for a "timed" confirmation and does not name the
## number. Ten seconds is long enough to find a keyboard on a screen you cannot
## read and short enough that walking away resolves it.
const CONFIRM_SECONDS: float = 10.0

var settings: PrototypeSettings

var pending: bool = false
var seconds_left: float = 0.0
## The values to go back to if the change is rejected, timed out, or abandoned.
var previous_mode: PrototypeSettings.WindowMode = PrototypeSettings.WindowMode.WINDOWED
var previous_resolution_index: int = 0

# --- Instrumentation (specification §22) -------------------------------------
var changes_applied: int = 0
var changes_kept: int = 0
var changes_reverted: int = 0
var timeouts: int = 0
var startup_recoveries: int = 0
var last_status: String = "no display change yet"

var _log: Callable = Callable()

signal confirmation_opened(seconds: float)
signal confirmation_ticked(seconds_left: float)
signal confirmation_closed(kept: bool, reason: String)
signal recovered(message: String)


func _ready() -> void:
	# The countdown must run while the settings panel has the world paused.
	process_mode = Node.PROCESS_MODE_ALWAYS


func bind(store: PrototypeSettings, log_sink: Callable) -> void:
	settings = store
	_log = log_sink


## True on a real windowing system. Headless verification runs return false, and
## every path below then records what it WOULD have done rather than pretending
## a window changed.
func has_window() -> bool:
	return DisplayServer.get_name() != "headless"


# --- Startup -----------------------------------------------------------------

## Applies the stored display settings, or recovers from an unconfirmed attempt.
## Returns a truthful message when it had to recover, and "" when it did not.
func apply_on_startup() -> String:
	if settings == null:
		return ""
	if settings.display_attempt_pending:
		startup_recoveries += 1
		settings.window_mode = settings.safe_window_mode
		settings.resolution_index = settings.safe_resolution_index
		settings.display_attempt_pending = false
		settings.save_to_disk()
		_apply(settings.window_mode, settings.resolution_index)
		var message: String = (
			"The last display change was never confirmed, so the display was returned to %s %s."
			% [settings.window_mode_name(), settings.resolution_name()]
		)
		last_status = message
		_emit("display recovered", message)
		recovered.emit(message)
		return message
	_apply(settings.window_mode, settings.resolution_index)
	last_status = "startup display: %s %s" % [settings.window_mode_name(), settings.resolution_name()]
	_emit("display applied", last_status)
	return ""


# --- Changing ----------------------------------------------------------------

## Applies a display change and opens the timed confirmation. Returns false when
## the request would change nothing.
func request_change(
	mode: PrototypeSettings.WindowMode, resolution_index: int
) -> bool:
	if settings == null or pending:
		return false
	if mode == settings.window_mode and resolution_index == settings.resolution_index:
		return false

	previous_mode = settings.window_mode
	previous_resolution_index = settings.resolution_index

	# WRITTEN BEFORE IT IS APPLIED. If the process dies on the next line, the
	# marker on disk is what saves the next boot.
	settings.display_attempt_pending = true
	settings.safe_window_mode = previous_mode
	settings.safe_resolution_index = previous_resolution_index
	settings.window_mode = mode
	settings.resolution_index = resolution_index
	settings.save_to_disk()

	_apply(mode, resolution_index)
	changes_applied += 1
	pending = true
	seconds_left = CONFIRM_SECONDS
	last_status = "applied %s %s; %.0f s to keep it" % [
		settings.window_mode_name(), settings.resolution_name(), CONFIRM_SECONDS,
	]
	_emit("display change applied", last_status)
	confirmation_opened.emit(CONFIRM_SECONDS)
	return true


func keep() -> void:
	if not pending:
		return
	pending = false
	changes_kept += 1
	settings.display_attempt_pending = false
	settings.safe_window_mode = settings.window_mode
	settings.safe_resolution_index = settings.resolution_index
	settings.save_to_disk()
	last_status = "kept %s %s" % [settings.window_mode_name(), settings.resolution_name()]
	_emit("display change kept", last_status)
	confirmation_closed.emit(true, "kept")


func revert(reason: String = "reverted") -> void:
	if not pending:
		return
	pending = false
	changes_reverted += 1
	settings.window_mode = previous_mode
	settings.resolution_index = previous_resolution_index
	settings.display_attempt_pending = false
	settings.safe_window_mode = previous_mode
	settings.safe_resolution_index = previous_resolution_index
	settings.save_to_disk()
	_apply(previous_mode, previous_resolution_index)
	last_status = "%s; display returned to %s %s" % [
		reason, settings.window_mode_name(), settings.resolution_name(),
	]
	_emit("display change reverted", last_status)
	confirmation_closed.emit(false, reason)


func _process(delta: float) -> void:
	if not pending:
		return
	seconds_left = maxf(seconds_left - delta, 0.0)
	confirmation_ticked.emit(seconds_left)
	if seconds_left <= 0.0:
		timeouts += 1
		revert("the confirmation timed out")


## Verification seam: advances the countdown without waiting ten real seconds.
## Ordinary play never calls it.
func advance_for_verification(seconds: float) -> void:
	if not pending:
		return
	seconds_left = maxf(seconds_left - seconds, 0.0)
	confirmation_ticked.emit(seconds_left)
	if seconds_left <= 0.0:
		timeouts += 1
		revert("the confirmation timed out")


# --- The actual window -------------------------------------------------------

func _apply(mode: PrototypeSettings.WindowMode, resolution_index: int) -> void:
	if not has_window():
		return
	var size: Vector2i = PrototypeSettings.SAFE_RESOLUTIONS[
		clampi(resolution_index, 0, PrototypeSettings.SAFE_RESOLUTIONS.size() - 1)
	]
	if mode == PrototypeSettings.WindowMode.FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		return
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(size)
	# Recentre, so a window that grew past the screen edge cannot end up with its
	# title bar off the top — which on macOS is a window that cannot be moved.
	var screen: Rect2i = DisplayServer.screen_get_usable_rect(DisplayServer.window_get_current_screen())
	DisplayServer.window_set_position(
		screen.position + (screen.size - size) / 2
	)


func describe() -> String:
	if settings == null:
		return "display manager is unbound"
	var live: String = "headless" if not has_window() else "%d × %d" % [
		DisplayServer.window_get_size().x, DisplayServer.window_get_size().y,
	]
	return "%s %s (window %s)%s — %d applied, %d kept, %d reverted, %d timed out, %d startup recoveries" % [
		settings.window_mode_name(), settings.resolution_name(), live,
		"  CONFIRMING %.1f s" % seconds_left if pending else "",
		changes_applied, changes_kept, changes_reverted, timeouts, startup_recoveries,
	]


func _emit(event: String, detail: String) -> void:
	if _log.is_valid():
		_log.call(event, detail)
