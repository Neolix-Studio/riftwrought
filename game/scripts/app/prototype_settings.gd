class_name PrototypeSettings
extends RefCounted
## Prototype Zero — Gate F: the small versioned settings store (specification
## §21, decision D-189).
##
## SEPARATE FROM THE LAB STATE, DELIBERATELY. Specification §20.3: "Settings use
## a separate small versioned file so resetting the lab does not erase comfort
## choices." Two files, two schemas, two validators, and the Gate F suite asserts
## that Reset Lab Progress leaves every value here untouched.
##
##   user://prototype_settings.cfg   this file — comfort choices
##   user://prototype_zero.cfg       `PrototypeLabState` — the lab milestone
##
## Specification §21 lists exactly what Prototype Zero is allowed to have, and
## this is exactly that list and nothing else:
##
##   Controls       detected input family (read-only), controller deadzone
##                  (0.20), aim assistance (70 / 100), vibration
##   Presentation   damage numbers On/Off, screen shake, bright flashes
##   Audio          Master volume
##   Display        Windowed / Fullscreen, safe resolutions with timed Keep/Revert
##   General        Restore Defaults, Reset Lab Progress behind confirmation
##
## There is no remapping table, no input profile, no caption setting, no
## colour-vision tool, no per-bus mix, and no accessibility panel: §21 says those
## "are not P0 blockers" and building them would be scope Gate F does not have.
##
## EVERY VALUE IS VALIDATED ON LOAD. A hand-edited or truncated file cannot put
## an out-of-range deadzone into the player or an unknown display mode into the
## window: unknown keys are ignored, out-of-range numbers are clamped, and the
## whole load reports what it had to correct so the recovery message can be
## truthful rather than reassuring.

## The PRODUCTION path, and the default every ordinary launch uses. It is a
## constant because the shipped application must never be able to choose a
## different one by accident.
const PATH: String = "user://prototype_settings.cfg"
## The bare file name, so an injected storage directory produces the same file
## under a different root rather than a second naming convention.
const FILE_NAME: String = "prototype_settings.cfg"
## Bump only when a stored key changes meaning. A file from an older schema is
## not silently reinterpreted; it is reset to defaults and says so.
const SCHEMA_VERSION: int = 1

## WHERE THIS INSTANCE ACTUALLY READS AND WRITES, and why it is injectable.
##
## The Gate F verification writes real settings files: defaults, round trips, a
## deliberately corrupted file, a stale schema, and four display-recovery states.
## Until D-191 it wrote all of them to `PATH` — the project owner's own file —
## so a successful test run replaced their real comfort choices, and a run that
## crashed halfway through left one of the deliberately broken files behind.
##
## The path is therefore a property of the INSTANCE rather than of the class.
## Ordinary launches leave it at `PATH` and nothing about them changes; the
## verification is handed a unique temporary directory by `gate_f_smoke.sh` and
## refuses to run at all if it did not get one (see `PrototypeApp` and
## `gate_f_verification.gd`). There is deliberately no "fall back to production"
## branch anywhere: a harness that cannot get isolated storage must fail, not
## quietly borrow the real files.
var storage_path: String = PATH

## Standard / Reduced / Off, used by shake, flashes, and vibration alike so the
## three comfort controls share one vocabulary.
enum Level {
	STANDARD,
	REDUCED,
	OFF,
}

enum WindowMode {
	WINDOWED,
	FULLSCREEN,
}

## Specification §21: "safe resolution choices". Every entry is at or above the
## §4.3 minimum tested window of 1280 x 720 and at or below the 1920 x 1080
## logical UI reference, so no choice can make the HUD illegible or push the
## window off a laptop display.
const SAFE_RESOLUTIONS: Array[Vector2i] = [
	Vector2i(1280, 720),
	Vector2i(1440, 810),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
]

## The exact §21 defaults. `DEFAULTS` is the single source: `restore_defaults()`,
## a missing file, an unreadable file, and a stale schema all come back here.
const DEFAULTS: Dictionary = {
	"controller_deadzone": 0.20,
	"aim_assistance": 70,
	"vibration": Level.STANDARD,
	"damage_numbers": true,
	"screen_shake": Level.STANDARD,
	"bright_flashes": Level.STANDARD,
	"master_volume": 0.80,
	"window_mode": WindowMode.WINDOWED,
	"resolution_index": 0,
}

## §21 Controls. 0.20 is the value D-175 approved and Gate B asserts; the range
## exists so a drifting stick can be compensated without letting a value through
## that would make the character unresponsive or uncontrollable.
const DEADZONE_RANGE: Vector2 = Vector2(0.05, 0.40)
## §21 Controls: "aim assistance, default 70 / 100".
const AIM_ASSIST_RANGE: Vector2i = Vector2i(0, 100)

var controller_deadzone: float = float(DEFAULTS["controller_deadzone"])
var aim_assistance: int = int(DEFAULTS["aim_assistance"])
var vibration: Level = DEFAULTS["vibration"]
var damage_numbers: bool = bool(DEFAULTS["damage_numbers"])
var screen_shake: Level = DEFAULTS["screen_shake"]
var bright_flashes: Level = DEFAULTS["bright_flashes"]
var master_volume: float = float(DEFAULTS["master_volume"])
var window_mode: WindowMode = DEFAULTS["window_mode"]
var resolution_index: int = int(DEFAULTS["resolution_index"])

# --- Startup-safe display recovery -------------------------------------------
# Specification §4.3 and §21: "Resolution changes require a timed keep/revert
# confirmation so a bad display choice cannot trap the user", and §23.6's pass
# condition adds "display or save failure cannot strand the test".
#
# A timed prompt only protects the user while the process is alive. If the game
# is force-quit, crashes, or is closed while a black or off-screen mode is on
# screen, the timer never fires and the bad mode is what boots next time. So the
# ATTEMPT is written to disk BEFORE it is applied, together with the display
# settings that were known good. On the next start, a pending attempt means the
# last one was never confirmed: the known-good values are applied instead, the
# marker is cleared, and the player is told.
var display_attempt_pending: bool = false
var safe_window_mode: WindowMode = DEFAULTS["window_mode"]
var safe_resolution_index: int = int(DEFAULTS["resolution_index"])

# --- Instrumentation (specification §22) -------------------------------------
var loads: int = 0
var saves: int = 0
var last_load_status: String = "not loaded"
var last_save_status: String = "not saved"
## Every value the loader had to correct, so the recovery message can name them.
var corrections: PackedStringArray = PackedStringArray()

signal changed(key: String)


# --- Load and save -----------------------------------------------------------

## Points this instance at a different file. Used by the verification harness so
## its real reads and writes land in a temporary directory, and by nothing else.
##
## It REFUSES two things and returns false rather than pretending, because a
## caller that asks for isolated storage and does not get it must find out: an
## empty path, and any path that is the production file `PATH` wearing a
## different spelling. The second refusal is the D-192 correction and it is a
## second, independent line of defence — `PrototypeApp` has already refused the
## same request one layer up, and this refuses it again for anything that ever
## reaches the store another way.
func set_storage_path(new_path: String) -> bool:
	var wanted: String = new_path.strip_edges()
	if wanted.is_empty():
		push_error("PrototypeSettings: an empty storage path is not a storage path")
		return false
	if PrototypeStoragePaths.same_file(wanted, PATH):
		push_error(
			"PrototypeSettings: '%s' is the production settings file %s; refusing it as injected storage"
			% [wanted, PATH]
		)
		return false
	storage_path = wanted
	return true


## True when this instance is reading and writing the project owner's real file.
##
## THE COMPARISON IS STRUCTURAL, NOT TEXTUAL (D-192). Until this correction it
## asked `storage_path == PATH`, which is a question about spelling: the same
## file named by its absolute path, through `..`, or through a symlink is a
## different STRING and the same FILE, so an injected "isolated" store sitting on
## the project owner's own settings would have answered false. Every spelling is
## now resolved to one canonical real path before the comparison.
func uses_production_storage() -> bool:
	return PrototypeStoragePaths.same_file(storage_path, PATH)


## Reads the settings file. Never fails: an absent, unreadable, stale, or
## corrupted file leaves the §21 defaults in place and records WHY.
func load_from_disk() -> void:
	loads += 1
	corrections.clear()
	restore_defaults(false)

	if not FileAccess.file_exists(storage_path):
		last_load_status = "no settings file yet; §21 defaults in use"
		return

	var config: ConfigFile = ConfigFile.new()
	var error: int = config.load(storage_path)
	if error != OK:
		last_load_status = "settings file unreadable (error %d); §21 defaults restored" % error
		corrections.append("the whole file could not be parsed")
		return

	var version: int = int(config.get_value("meta", "schema_version", -1))
	if version != SCHEMA_VERSION:
		last_load_status = "settings schema %d is not %d; §21 defaults restored" % [version, SCHEMA_VERSION]
		corrections.append("schema version %d" % version)
		return

	controller_deadzone = _clamped_float(
		config, "controls", "controller_deadzone", DEADZONE_RANGE.x, DEADZONE_RANGE.y
	)
	aim_assistance = _clamped_int(
		config, "controls", "aim_assistance", AIM_ASSIST_RANGE.x, AIM_ASSIST_RANGE.y
	)
	vibration = _level(config, "controls", "vibration")
	damage_numbers = _boolean(config, "presentation", "damage_numbers")
	screen_shake = _level(config, "presentation", "screen_shake")
	bright_flashes = _level(config, "presentation", "bright_flashes")
	master_volume = _clamped_float(config, "audio", "master_volume", 0.0, 1.0)
	window_mode = (
		WindowMode.FULLSCREEN
		if _clamped_int(config, "display", "window_mode", 0, 1) == int(WindowMode.FULLSCREEN)
		else WindowMode.WINDOWED
	)
	resolution_index = _clamped_int(
		config, "display", "resolution_index", 0, SAFE_RESOLUTIONS.size() - 1
	)
	display_attempt_pending = bool(config.get_value("display", "attempt_pending", false))
	safe_window_mode = (
		WindowMode.FULLSCREEN
		if int(config.get_value("display", "safe_window_mode", int(DEFAULTS["window_mode"]))) == int(WindowMode.FULLSCREEN)
		else WindowMode.WINDOWED
	)
	safe_resolution_index = clampi(
		int(config.get_value("display", "safe_resolution_index", int(DEFAULTS["resolution_index"]))),
		0, SAFE_RESOLUTIONS.size() - 1
	)

	if corrections.is_empty():
		last_load_status = "loaded schema %d, every value in range" % SCHEMA_VERSION
	else:
		last_load_status = "loaded schema %d; corrected %s" % [SCHEMA_VERSION, ", ".join(corrections)]


func save_to_disk() -> bool:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("meta", "schema_version", SCHEMA_VERSION)
	config.set_value("controls", "controller_deadzone", controller_deadzone)
	config.set_value("controls", "aim_assistance", aim_assistance)
	config.set_value("controls", "vibration", int(vibration))
	config.set_value("presentation", "damage_numbers", damage_numbers)
	config.set_value("presentation", "screen_shake", int(screen_shake))
	config.set_value("presentation", "bright_flashes", int(bright_flashes))
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("display", "window_mode", int(window_mode))
	config.set_value("display", "resolution_index", resolution_index)
	config.set_value("display", "attempt_pending", display_attempt_pending)
	config.set_value("display", "safe_window_mode", int(safe_window_mode))
	config.set_value("display", "safe_resolution_index", safe_resolution_index)
	var error: int = config.save(storage_path)
	saves += 1
	if error == OK:
		last_save_status = "saved schema %d to %s" % [SCHEMA_VERSION, storage_path]
		return true
	last_save_status = "could not save settings (error %d)" % error
	return false


## §21 General: "Restore Defaults". Display choices are included, because a bad
## display choice is exactly the kind of thing a Restore Defaults is for.
func restore_defaults(notify: bool = true) -> void:
	controller_deadzone = float(DEFAULTS["controller_deadzone"])
	aim_assistance = int(DEFAULTS["aim_assistance"])
	vibration = DEFAULTS["vibration"]
	damage_numbers = bool(DEFAULTS["damage_numbers"])
	screen_shake = DEFAULTS["screen_shake"]
	bright_flashes = DEFAULTS["bright_flashes"]
	master_volume = float(DEFAULTS["master_volume"])
	window_mode = DEFAULTS["window_mode"]
	resolution_index = int(DEFAULTS["resolution_index"])
	display_attempt_pending = false
	safe_window_mode = DEFAULTS["window_mode"]
	safe_resolution_index = int(DEFAULTS["resolution_index"])
	if notify:
		changed.emit("all")


func is_default() -> bool:
	return (
		is_equal_approx(controller_deadzone, float(DEFAULTS["controller_deadzone"]))
		and aim_assistance == int(DEFAULTS["aim_assistance"])
		and vibration == DEFAULTS["vibration"]
		and damage_numbers == bool(DEFAULTS["damage_numbers"])
		and screen_shake == DEFAULTS["screen_shake"]
		and bright_flashes == DEFAULTS["bright_flashes"]
		and is_equal_approx(master_volume, float(DEFAULTS["master_volume"]))
		and window_mode == DEFAULTS["window_mode"]
		and resolution_index == int(DEFAULTS["resolution_index"])
	)


# --- Setters, each of which announces itself --------------------------------

func set_controller_deadzone(value: float) -> void:
	var clamped: float = clampf(value, DEADZONE_RANGE.x, DEADZONE_RANGE.y)
	if is_equal_approx(clamped, controller_deadzone):
		return
	controller_deadzone = clamped
	changed.emit("controller_deadzone")


func set_aim_assistance(value: int) -> void:
	var clamped: int = clampi(value, AIM_ASSIST_RANGE.x, AIM_ASSIST_RANGE.y)
	if clamped == aim_assistance:
		return
	aim_assistance = clamped
	changed.emit("aim_assistance")


func set_vibration(value: Level) -> void:
	if value == vibration:
		return
	vibration = value
	changed.emit("vibration")


func set_damage_numbers(value: bool) -> void:
	if value == damage_numbers:
		return
	damage_numbers = value
	changed.emit("damage_numbers")


func set_screen_shake(value: Level) -> void:
	if value == screen_shake:
		return
	screen_shake = value
	changed.emit("screen_shake")


func set_bright_flashes(value: Level) -> void:
	if value == bright_flashes:
		return
	bright_flashes = value
	changed.emit("bright_flashes")


func set_master_volume(value: float) -> void:
	var clamped: float = clampf(value, 0.0, 1.0)
	if is_equal_approx(clamped, master_volume):
		return
	master_volume = clamped
	changed.emit("master_volume")


func set_window_mode(value: WindowMode) -> void:
	if value == window_mode:
		return
	window_mode = value
	changed.emit("window_mode")


func set_resolution_index(value: int) -> void:
	var clamped: int = clampi(value, 0, SAFE_RESOLUTIONS.size() - 1)
	if clamped == resolution_index:
		return
	resolution_index = clamped
	changed.emit("resolution_index")


# --- Derived values the rest of the prototype reads -------------------------

## Multiplier for camera impulse magnitude. §18: "Screen shake and bright flashes
## must be reducible or disabled", and Off must be genuinely zero rather than
## small.
func shake_scale() -> float:
	return _level_scale(screen_shake)


## Multiplier for impact flash and release-flash opacity.
func flash_scale() -> float:
	return _level_scale(bright_flashes)


## Multiplier for controller rumble strength.
func vibration_scale() -> float:
	return _level_scale(vibration)


static func _level_scale(level: Level) -> float:
	match level:
		Level.STANDARD:
			return 1.0
		Level.REDUCED:
			return 0.40
		_:
			return 0.0


## §21 Controls, "aim assistance, default 70 / 100", applied to the ONE piece of
## assistance Prototype Zero actually has: the controller soft-target cone and
## its acquisition distance. The mouse has no assistance at all and this value
## does not touch it — the cursor picks exactly what it is over.
##
## THE DEFAULT IS EXACTLY 1.000x, BY CONSTRUCTION. D-178 locked the cone at 65
## degrees total and D-180 accepted it at that width, so 70 / 100 must reproduce
## that number to the last digit and it does: the curve is two straight lines
## that meet at (70, 1.000). Below 70 assistance narrows toward 0.60x; above it
## widens to 1.20x at 100. The Gate F suite asserts the default is bit-for-bit
## the accepted 65.0 degrees and 5.0 m.
##
## The SHAPE of the curve away from the default is a Claude choice, not a project
## decision, and it is an open question in the Gate F report: nothing in the
## canon says what 0 or 100 ought to mean.
func aim_assist_scale() -> float:
	if aim_assistance <= 70:
		return 0.60 + 0.40 * (float(aim_assistance) / 70.0)
	return 1.00 + 0.20 * (float(aim_assistance - 70) / 30.0)


func level_name(level: Level) -> String:
	match level:
		Level.STANDARD:
			return "Standard"
		Level.REDUCED:
			return "Reduced"
		_:
			return "Off"


func window_mode_name() -> String:
	return "Fullscreen" if window_mode == WindowMode.FULLSCREEN else "Windowed"


func resolution() -> Vector2i:
	return SAFE_RESOLUTIONS[clampi(resolution_index, 0, SAFE_RESOLUTIONS.size() - 1)]


func resolution_name() -> String:
	var size: Vector2i = resolution()
	return "%d × %d" % [size.x, size.y]


func describe() -> String:
	return "deadzone %.2f, aim assist %d, vibration %s | numbers %s, shake %s, flashes %s | master %.0f%% | %s %s" % [
		controller_deadzone, aim_assistance, level_name(vibration),
		"On" if damage_numbers else "Off", level_name(screen_shake), level_name(bright_flashes),
		master_volume * 100.0, window_mode_name(), resolution_name(),
	]


# --- Validation helpers ------------------------------------------------------

func _clamped_float(config: ConfigFile, section: String, key: String, low: float, high: float) -> float:
	var fallback: float = float(DEFAULTS[key])
	var raw: Variant = config.get_value(section, key, fallback)
	if not (raw is float or raw is int):
		corrections.append("%s was not a number" % key)
		return fallback
	var value: float = float(raw)
	var clamped: float = clampf(value, low, high)
	if not is_equal_approx(clamped, value):
		corrections.append("%s was %.3f, clamped to %.3f" % [key, value, clamped])
	return clamped


func _clamped_int(config: ConfigFile, section: String, key: String, low: int, high: int) -> int:
	var fallback: int = int(DEFAULTS[key])
	var raw: Variant = config.get_value(section, key, fallback)
	if not (raw is int or raw is float):
		corrections.append("%s was not a number" % key)
		return fallback
	var value: int = int(raw)
	var clamped: int = clampi(value, low, high)
	if clamped != value:
		corrections.append("%s was %d, clamped to %d" % [key, value, clamped])
	return clamped


func _level(config: ConfigFile, section: String, key: String) -> Level:
	var fallback: int = int(DEFAULTS[key])
	var raw: Variant = config.get_value(section, key, fallback)
	if not (raw is int or raw is float):
		corrections.append("%s was not a level" % key)
		return fallback as Level
	var value: int = int(raw)
	if value < 0 or value > int(Level.OFF):
		corrections.append("%s was %d, not a known level" % [key, value])
		return fallback as Level
	return value as Level


func _boolean(config: ConfigFile, section: String, key: String) -> bool:
	var fallback: bool = bool(DEFAULTS[key])
	var raw: Variant = config.get_value(section, key, fallback)
	if not (raw is bool):
		corrections.append("%s was not true or false" % key)
		return fallback
	return bool(raw)
