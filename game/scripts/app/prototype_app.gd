class_name PrototypeApp
extends Node
## Prototype Zero — Gate F: the persistent application root (specification §7.1,
## §20.2, §20.3, §21, decision D-189).
##
## §7.1: "`prototype_app.tscn` is the project main scene and owns Start New Lab /
## Continue Lab, Settings, Quit where supported, the small prototype settings
## store, the small prototype test-state store, input-family tracking and glyph
## selection, and loading or replacing the lab scene. This persistent root avoids
## Autoloads for Prototype Zero."
##
## It owns exactly that list. It owns no gameplay: the room still owns the room.
##
## THE TWO FILES ARE SEPARATE AND SO ARE THEIR LIVES.
##
##   `user://prototype_settings.cfg`   comfort choices. Survives Reset Lab
##                                     Progress, survives Start New Lab, and is
##                                     saved whenever a setting changes.
##   `user://prototype_zero.cfg`       the six-value lab milestone. Written ONLY
##                                     on a milestone commit and on a deliberate
##                                     clean exit (§20.3), and deleted by Reset
##                                     Lab Progress without touching the other.
##
## THE ROOM IS LOADED, NOT AUTOLOADED. Start New Lab and Continue Lab both
## instantiate `prototype_zero.tscn` fresh, hand it the settings store, the audio
## director, the display manager, and the app's own input-family tracker, and let
## it run. Quit to Title frees it. Nothing survives across that boundary except
## the four stores above, which is what makes "reconstruct the nearest valid
## beginning of the saved stage" a real reconstruction rather than a resume of
## something that was never torn down.
##
## THE APP OWNS THE ONLY INPUT-FAMILY TRACKER in the shipped flow. The room still
## carries its own so it can be run standalone by the Gate A-E suites, but when
## the app loads it, the room adopts the app's tracker and frees its own — so the
## title screen, the settings panel, the pause menu, and the HUD all read one
## answer to "which glyphs?" rather than four that agree by luck.

const ROOM_SCENE: String = "res://scenes/prototype_zero/prototype_zero.tscn"

## VERIFICATION STORAGE ISOLATION (D-191).
##
## `--state-dir <directory>` moves BOTH versioned files into that directory for
## the life of the process. It exists for one reason: the Gate F verification
## writes, corrupts, and deletes real settings and lab files, and until D-191 it
## wrote them to the project owner's own `user://` paths — so a successful test
## run replaced their comfort settings and erased their laboratory progress, and
## a run that died halfway through could leave a deliberately broken file behind.
##
## Ordinary launches never pass it and are completely unaffected: without the
## flag both stores keep their `user://` defaults. WITH the flag and a directory
## that does not exist, cannot be written, or IS the project owner's own user
## data directory under any spelling, the process REFUSES TO START rather than
## falling back — a harness that asks for isolated storage and silently gets the
## real files is the defect this exists to prevent.
const STATE_DIR_ARGUMENT: String = "--state-dir"

## THE NON-WRITING GUARD PROBE (D-192).
##
## `--check-state-dir` resolves the request exactly as a real launch would,
## prints the storage decision, and quits — before a store is constructed, before
## a file is opened, and before the writability probe. It exists so the refusals
## above can be PROVED: `gate_f_smoke.sh` points it at the production directory
## and at eleven aliases of it — absolute, `.`, `..`, a doubled separator,
## another case on a volume that folds case, a directory inside it, and a
## symlink — and asserts the process refuses every one, and not a single byte is
## read or written anywhere while it does that. The destructive
## Gate F verification does not run unless all of those passed first.
const STATE_DIR_PROBE_ARGUMENT: String = "--check-state-dir"

var settings: PrototypeSettings
var lab_state: PrototypeLabState
var audio: PrototypeAudioDirector
var display: PrototypeDisplayManager
var input_family: InputFamilyTracker
var title: PrototypeTitleScreen
var display_prompt: PrototypeDisplayPrompt

var room: PrototypeZeroRoom = null

## Empty on every ordinary launch, which is what makes the two stores use their
## production `user://` paths. Non-empty only under `--state-dir`, and then it is
## the CANONICAL REAL path rather than whatever was typed: resolved absolute,
## `.` and `..` removed, every symlink followed (D-192).
var storage_root: String = ""
## Exactly what the command line asked for, kept beside the resolved answer so a
## log line or a refusal can show both spellings of the same directory.
var storage_root_requested: String = ""

# --- Instrumentation (specification §22) -------------------------------------
var lab_starts: int = 0
var lab_continues: int = 0
var returns_to_title: int = 0
var state_saves: int = 0
var state_save_reasons: PackedStringArray = PackedStringArray()
var log_lines: PackedStringArray = PackedStringArray()
var startup_notice: String = ""

var _world: Node
var _verifying: bool = false

signal room_loaded(new_room: PrototypeZeroRoom)
signal room_unloaded()
signal lab_state_saved(reason: String)


func _ready() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	# BEFORE ANYTHING TOUCHES DISK. A bad, aliased, or dangerous `--state-dir`
	# stops the process here, with nothing read and nothing written.
	if not _resolve_storage_root(arguments):
		return
	# The guard's own test drives THIS path: it resolves, reports, and quits
	# without constructing a store, opening a file, or starting a verification —
	# so proving that the refusal works can never itself run against production.
	if arguments.has(STATE_DIR_PROBE_ARGUMENT):
		_report_storage_decision()
		return

	# The APP runs while paused — it owns the title screen, the settings surfaces,
	# the audio director, and the input-family tracking that a paused menu needs.
	process_mode = Node.PROCESS_MODE_ALWAYS
	_world = $World
	# THE WORLD DOES NOT. `PROCESS_MODE_INHERIT` would hand the loaded room the
	# app's ALWAYS, and a room that cannot be paused is a room where pause is a
	# picture of a pause: the coordinator's clocks, the wave countdown, and every
	# attack phase would keep running behind the menu. One line, and it is the
	# line that makes `get_tree().paused` mean what §21 says it means.
	_world.process_mode = Node.PROCESS_MODE_PAUSABLE
	input_family = $InputFamilyTracker
	audio = $AudioDirector
	display = $DisplayManager
	title = $CanvasLayer/TitleScreen
	display_prompt = $CanvasLayer/DisplayPrompt

	settings = PrototypeSettings.new()
	lab_state = PrototypeLabState.new()
	if storage_root != "":
		# Each store refuses a production file independently of the check above,
		# so a spelling that somehow slipped past `_resolve_storage_root()` is
		# caught by the object that would have done the writing (D-192).
		var settings_accepted: bool = settings.set_storage_path(
			storage_root.path_join(PrototypeSettings.FILE_NAME)
		)
		var lab_accepted: bool = lab_state.set_storage_path(
			storage_root.path_join(PrototypeLabState.FILE_NAME)
		)
		if not (settings_accepted and lab_accepted):
			_refuse_storage_root(
				"a store refused the requested state directory %s (settings accepted: %s, lab accepted: %s)"
				% [storage_root, str(settings_accepted), str(lab_accepted)]
			)
			return
	# §22: say where the two files are, every launch. It is the one piece of
	# information a reader needs to check the claim that a verification run went
	# somewhere else, and the project owner is entitled to know where their own
	# save lives.
	log_event("state files", "%s | %s%s" % [
		settings.storage_path, lab_state.storage_path,
		"" if storage_root == "" else "   (isolated verification storage)",
	])
	log_event("production state files", "%s | %s" % [
		ProjectSettings.globalize_path(PrototypeSettings.PATH),
		ProjectSettings.globalize_path(PrototypeLabState.PATH),
	])
	# D-192: the CANONICAL production locations, which is the form every storage
	# guard actually compares against. Printed beside the globalized paths so a
	# reader can see that the two agree rather than take it on trust.
	log_event("production, resolved", "%s | %s" % [
		PrototypeStoragePaths.production_settings_file(),
		PrototypeStoragePaths.production_lab_file(),
	])
	if storage_root != "":
		log_event("state directory", "%s -> %s" % [storage_root_requested, storage_root])
	settings.load_from_disk()
	lab_state.load_from_disk()
	log_event("settings loaded", settings.last_load_status)
	log_event("lab state loaded", lab_state.last_load_status)

	audio.set_log_sink(Callable(self, "log_event"))
	audio.apply_master_volume(settings.master_volume)
	log_event("audio ready", "%d of %d authored cue variants loaded across %d families" % [
		audio.loaded_variant_count(), PrototypeCueCatalogue.total_variants(),
		PrototypeCueCatalogue.FAMILIES.size(),
	])
	if not audio.is_complete():
		push_warning("PrototypeApp: authored audio is incomplete; run build_prototype_audio.gd")

	display.bind(settings, Callable(self, "log_event"))
	display_prompt.bind(display, audio)
	startup_notice = display.apply_on_startup()

	settings.changed.connect(_on_setting_changed)

	title.configure(self, settings, lab_state, audio, display, input_family)
	if startup_notice != "":
		title.show_notice(startup_notice)

	log_event("app ready", "title screen; %s" % lab_state.describe())

	if arguments.has("--verify-f"):
		_start_verification(arguments)


## Reads `--state-dir` and either sets `storage_root` or stops the process.
## Returns false when the caller must abandon `_ready()`.
##
## Every failure path quits with a non-zero code. There is deliberately no branch
## that reports a problem and carries on with `user://`: a silent fall back to
## production storage is exactly the defect D-191 corrects.
##
## THE ORDER OF THE CHECKS BELOW IS PART OF THE GUARD (D-192).
##
## The request is canonicalized FIRST and compared against the production
## locations SECOND, before existence and before writability. Two reasons:
##
##   * a path is only safe if it is not the project owner's own storage under
##     ANY spelling, and `--state-dir <the real user data directory>` is a
##     different STRING naming the same two files — which D-191's textual guard
##     would have accepted;
##   * putting the production refusal before the existence check means a machine
##     where the user data directory does not exist yet still refuses it for the
##     right reason, so the automated refusal check cannot pass by accident.
##
## Every comparison is made on canonical real paths: `user://` globalized,
## relative paths resolved, `.` and `..` removed, every symlinked component
## followed. The FILES are compared as well as the directory, so a symlink named
## `prototype_settings.cfg` inside an otherwise innocent directory is caught too.
func _resolve_storage_root(arguments: PackedStringArray) -> bool:
	var index: int = arguments.find(STATE_DIR_ARGUMENT)
	if index == -1:
		return true

	if index + 1 >= arguments.size():
		return _refuse_storage_root("%s was given with no directory after it" % STATE_DIR_ARGUMENT)
	var requested: String = arguments[index + 1].strip_edges()
	if requested.is_empty():
		return _refuse_storage_root("%s was given an empty directory" % STATE_DIR_ARGUMENT)
	if requested.begins_with("--"):
		return _refuse_storage_root("%s was followed by '%s', which is another flag" % [
			STATE_DIR_ARGUMENT, requested,
		])

	var resolved: String = PrototypeStoragePaths.real_path(requested)
	if resolved.is_empty():
		return _refuse_storage_root("%s could not be resolved to a real path: %s" % [
			STATE_DIR_ARGUMENT, requested,
		])
	var production_directory: String = PrototypeStoragePaths.production_directory()

	if PrototypeStoragePaths.is_production_directory(resolved):
		return _refuse_storage_root(
			"%s is the project owner's own user data directory: '%s' resolves to %s"
			% [STATE_DIR_ARGUMENT, requested, resolved]
		)
	if PrototypeStoragePaths.is_inside_production_directory(resolved):
		return _refuse_storage_root(
			"%s is inside the project owner's own user data directory %s: '%s' resolves to %s"
			% [STATE_DIR_ARGUMENT, production_directory, requested, resolved]
		)
	for candidate: String in PrototypeStoragePaths.files_in(resolved):
		if PrototypeStoragePaths.is_production_file(candidate):
			return _refuse_storage_root(
				"%s would put a state file onto the project owner's own user data directory file %s: '%s' resolves to %s"
				% [STATE_DIR_ARGUMENT, candidate, requested, resolved]
			)

	if not DirAccess.dir_exists_absolute(resolved):
		return _refuse_storage_root("the requested state directory does not exist: %s" % (
			PrototypeStoragePaths.describe(requested)
		))

	if arguments.has(STATE_DIR_PROBE_ARGUMENT):
		# `--check-state-dir` writes NOTHING, anywhere, including the writability
		# probe below. That is what makes it safe to point at the production
		# directory in order to prove the refusals above actually fire.
		storage_root_requested = requested
		storage_root = resolved
		return true

	# Existence is not permission. A directory that cannot be written would send
	# every save down the "could not save" path and the run would look like a
	# behavioural failure rather than a harness one, so it is proved writable
	# here, once, with a probe that is removed again.
	var probe_path: String = resolved.path_join(".riftwrought_state_probe")
	var probe: FileAccess = FileAccess.open(probe_path, FileAccess.WRITE)
	if probe == null:
		return _refuse_storage_root("the requested state directory is not writable (error %d): %s" % [
			FileAccess.get_open_error(), resolved,
		])
	probe.store_string("riftwrought")
	probe.close()
	DirAccess.remove_absolute(probe_path)

	storage_root_requested = requested
	storage_root = resolved
	return true


func _refuse_storage_root(reason: String) -> bool:
	printerr("PrototypeApp: %s" % reason)
	printerr("PrototypeApp: refusing to start. %s never falls back to the production %s and %s." % [
		STATE_DIR_ARGUMENT, PrototypeSettings.PATH, PrototypeLabState.PATH,
	])
	get_tree().quit(2)
	return false


## The `--check-state-dir` report, and the whole of that startup path.
##
## It is reached only after `_resolve_storage_root()` ACCEPTED the request,
## because every refusal already quit with a non-zero code. Nothing above it
## opened, wrote, or removed a file, and nothing below it runs: no store is
## constructed, no settings or lab state is read, and no verification is started.
## That is precisely what lets the refusal checks be pointed at the production
## directory safely.
func _report_storage_decision() -> void:
	print("[gate-f] state directory probe   accepted")
	if storage_root.is_empty():
		print("  requested: <none>; this is an ordinary launch")
		print("  settings:  %s" % PrototypeSettings.PATH)
		print("  lab state: %s" % PrototypeLabState.PATH)
	else:
		print("  requested: %s" % storage_root_requested)
		print("  resolved:  %s" % storage_root)
		print("  settings:  %s" % storage_root.path_join(PrototypeSettings.FILE_NAME))
		print("  lab state: %s" % storage_root.path_join(PrototypeLabState.FILE_NAME))
	print("  production directory: %s" % PrototypeStoragePaths.production_directory())
	print("  production files:     %s | %s" % [
		PrototypeStoragePaths.production_settings_file(),
		PrototypeStoragePaths.production_lab_file(),
	])
	print("  nothing was read, written, or removed by this probe")
	get_tree().quit(0)


func _start_verification(arguments: PackedStringArray) -> void:
	_verifying = true
	var verifier: Node = (load("res://scripts/tools/gate_f_verification.gd") as GDScript).new()
	verifier.name = "GateFVerification"
	verifier.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(verifier)
	verifier.call("run", self, arguments)


func is_verifying() -> bool:
	return _verifying


func _input(event: InputEvent) -> void:
	# Null only on the `--state-dir` refusal path, where `_ready()` returned
	# before building anything and the process is already on its way out.
	if input_family == null:
		return
	# One tracker, fed once. The room adopts this one rather than keeping its own
	# when the app is what loaded it.
	input_family.observe(event)


# --- Title actions -----------------------------------------------------------

## Start New Lab. §20.3 has no "new game" ceremony: the lab file is removed, the
## settings file is not touched, and the room is built at the first Graveblade.
func start_new_lab() -> void:
	lab_starts += 1
	lab_state.delete_from_disk()
	log_event("start new lab", "lab state cleared; settings retained (%s)" % settings.describe())
	_load_room(null)


## Continue Lab. §20.3: "On Continue, reconstruct the nearest valid beginning of
## the saved stage." An invalid file never reaches here — the title screen keeps
## Continue disabled and prints the fault instead.
func continue_lab() -> void:
	if not (lab_state.exists and lab_state.valid):
		log_event("continue refused", lab_state.problem if lab_state.exists else "no saved lab state")
		return
	lab_continues += 1
	log_event("continue lab", lab_state.describe())
	_load_room(lab_state)


## §21 General, from the title screen. It removes the lab file and nothing else.
func reset_lab_progress_from_title() -> void:
	lab_state.delete_from_disk()
	log_event("reset lab progress", "%s; settings untouched" % lab_state.last_save_status)
	title.refresh()


func quit_application(reason: String) -> void:
	save_lab_state("quit (%s)" % reason)
	settings.save_to_disk()
	log_event("quit", reason)
	get_tree().quit(0)


# --- Room lifecycle ----------------------------------------------------------

func _load_room(saved: PrototypeLabState) -> void:
	if room != null:
		_unload_room("replaced")
	var scene: PackedScene = load(ROOM_SCENE) as PackedScene
	var instance: PrototypeZeroRoom = scene.instantiate() as PrototypeZeroRoom
	# Configured BEFORE it enters the tree, so the room's own `_ready` already
	# sees the app's stores and never builds a second set.
	instance.configure_app(self, settings, audio, display, input_family, saved)
	_world.add_child(instance)
	room = instance
	title.visible = false
	log_event("room loaded", "%s" % ("continued from %s" % saved.milestone if saved != null else "new laboratory"))
	room_loaded.emit(instance)


func _unload_room(reason: String) -> void:
	if room == null:
		return
	var leaving: PrototypeZeroRoom = room
	room = null
	_world.remove_child(leaving)
	leaving.queue_free()
	get_tree().paused = false
	audio.stop_all()
	log_event("room unloaded", reason)
	room_unloaded.emit()


## §21: "Quit to Title". A deliberate clean exit, so §20.3's second save point
## fires here.
func quit_to_title(reason: String) -> void:
	returns_to_title += 1
	save_lab_state("quit to title (%s)" % reason)
	_unload_room(reason)
	title.refresh()
	title.visible = true
	audio.play("menu_close")
	log_event("returned to title", reason)


# --- Saving ------------------------------------------------------------------

## §20.3: "Save only on milestone transitions and deliberate clean exit."
##
## There is no autosave timer, no per-kill write, no per-frame write, and no
## write on pause. The room calls this from the four milestone commits and from
## entering the repeat loop; the app calls it from Quit to Title and Quit.
func save_lab_state(reason: String) -> bool:
	if room == null or room.director == null or room.director.progress == null:
		return false
	if not room.director.active:
		# A suspended director is a Gate B/C/D arrangement, not a laboratory.
		return false
	lab_state.capture(room.director.progress, room.player.weapon)
	var saved: bool = lab_state.save_to_disk()
	state_saves += 1
	state_save_reasons.append(reason)
	if state_save_reasons.size() > 32:
		state_save_reasons.remove_at(0)
	log_event("lab state saved", "%s — %s" % [reason, lab_state.last_save_status])
	lab_state_saved.emit(reason)
	return saved


## Called by the room when Reset Lab Progress is confirmed in play. The file goes
## and the settings stay, which is the whole reason they are two files.
func reset_lab_progress_in_play() -> void:
	lab_state.delete_from_disk()
	log_event("reset lab progress", "%s; settings untouched" % lab_state.last_save_status)


# --- Settings ----------------------------------------------------------------

## Every setting change is persisted at once. Settings are comfort choices, not
## progress: losing them to a crash would be an irritation with no upside, and
## §20.3's save-point restriction is about the LAB file.
func _on_setting_changed(key: String) -> void:
	settings.save_to_disk()
	if key == "master_volume" or key == "all":
		audio.apply_master_volume(settings.master_volume)
	if room != null:
		room.apply_settings(key)
	log_event("setting changed", "%s — %s" % [key, settings.describe()])


func apply_display_change(
	mode: PrototypeSettings.WindowMode, resolution_index: int
) -> bool:
	return display.request_change(mode, resolution_index)


# --- Structured local log (specification §22) --------------------------------

func log_event(event: String, detail: String) -> void:
	print("[gate-f] %-28s %s" % [event, detail])
	log_lines.append("%s — %s" % [event, detail])
	if log_lines.size() > 24:
		log_lines.remove_at(0)


func describe() -> String:
	return "%d starts, %d continues, %d returns to title, %d lab saves | %s" % [
		lab_starts, lab_continues, returns_to_title, state_saves, lab_state.describe(),
	]
