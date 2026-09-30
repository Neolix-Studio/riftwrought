extends Node
## Prototype Zero — Gate F automated verification (specification §§17–22, §25,
## decision D-189).
##
## Specification §25 forbids a test framework and states plainly that automated
## tests cannot certify feel. These checks assert only what a machine CAN settle
## about the feedback, death, settings, and test-state layer:
##
##   the §21 settings defaults, their ranges, their persistence, and the fact
##     that resetting the lab does not touch them;
##   that a paused world is genuinely stopped — position, attack phase,
##     coordinator clocks, and the wave countdown all frozen;
##   that every boundary re-arms the neutral-input doors and that an input held
##     across one cannot act;
##   that Fallen reports the exact §20.1 killing source, built from the event;
##   that Restart restores the current fight without duplicating a reward;
##   that the lab file is written only at milestones, holds only the six
##     allowlisted values, and is reconstructed at every one of them;
##   that an invalid file produces a truthful refusal rather than a false resume;
##   that a display change is protected by a timed Keep/Revert AND by a startup
##     marker that survives a process that never got to answer it;
##   that damage numbers Off suppress the NUMBER and nothing else;
##   that the improved Hit is measurably heavier and measurably NOT brighter,
##     read from the authored audio itself;
##   that the cue families route, vary, and rate-limit, and that Master volume
##     applies immediately;
##   that the §21 aim assistance recomputes from the canonical record instead of
##     compounding across laboratories, and never writes to it (D-191);
##   that the harness's own storage is isolated — decided by resolving every path
##     to one canonical real path rather than by comparing path text, so an
##     absolute, `..`, or symlinked spelling of the production directory cannot
##     pass as isolated storage — and that the project owner's real settings and
##     lab files are byte-for-byte untouched by the run (D-191, D-192);
##   and that nothing outside Gate F was built.
##
## WHAT IT CANNOT SETTLE, and does not pretend to: whether any of it FEELS right.
## D-189 closes only after the project owner has played the complete path with
## mouse and controller, judged 100 against 150 with damage numbers Off and the
## effects Reduced or Off, listened on speakers and headphones, and accepted it.
##
## It runs against the APP rather than the room, because Gate F's subject is the
## persistent flow: Start New Lab, Continue Lab, Quit to Title, and the two files.
##
## IT REFUSES TO RUN WITHOUT ISOLATED STORAGE (D-191). The checks below write,
## corrupt, and DELETE real settings and lab-state files. Until D-191 they wrote
## them to `user://prototype_settings.cfg` and `user://prototype_zero.cfg` — the
## project owner's own files — so a successful run replaced their comfort
## settings and erased their laboratory progress. `gate_f_smoke.sh` now creates a
## unique `mktemp -d` directory and passes it in with `--state-dir`; if it is
## missing or invalid the app refuses to start and this suite refuses to run.
## There is deliberately no fall back to the production paths.
##
## Run:  godot --headless --path game -- --verify-f --state-dir <dir>
##       godot --path game --resolution 1280x720 -- --verify-f --state-dir <dir> --shots <dir>

const TICK: float = 1.0 / 60.0
## The authored Quick Strike record. Read here only to prove it is never written.
const CANONICAL_QUICK_STRIKE: String = "res://data/prototype_zero/quick_strike.tres"

var app: PrototypeApp
var room: PrototypeZeroRoom
var player: PrototypePlayer
var action: QuickStrikeAction
var director: PrototypeProgressionDirector
var progress: LabProgress
var settings: PrototypeSettings
var lab_state: PrototypeLabState
var audio: PrototypeAudioDirector
var display: PrototypeDisplayManager
var hud: PrototypeHUD
var feedback: PrototypeCombatFeedback

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _shot_dir: String = ""
## What the project owner's own two files looked like before this run touched
## anything, so the same question can be asked again at the end.
var _production_before: Dictionary = {}


func run(owner_app: PrototypeApp, arguments: PackedStringArray) -> void:
	app = owner_app
	settings = owner_app.settings
	lab_state = owner_app.lab_state
	audio = owner_app.audio
	display = owner_app.display
	_shot_dir = _argument_value(arguments, "--shots")

	print("")
	print("=== Gate F verification ===")
	await _settle(4)

	# BEFORE ANY WRITE. This suite writes, corrupts, and deletes real files; if
	# it is not pointed at isolated storage it stops here rather than doing that
	# to the project owner's own settings and laboratory progress (D-191).
	if not _require_isolated_storage():
		return
	_capture_production_fingerprint()
	_check_storage_alias_refusals()

	# The suite writes real files. It starts from a clean slate so a previous
	# run cannot make a check pass, and it says so.
	_wipe_state_files()
	settings.load_from_disk()
	lab_state.load_from_disk()
	app.title.refresh()

	_check_title_and_files()
	_check_surface_is_on_screen(app.title, "the title screen")
	_check_settings_contract()
	_check_authored_audio()
	await _check_audio_routing_and_variation()
	_check_master_volume()
	await _check_start_new_lab()
	await _check_hud_contract()
	await _check_damage_numbers()
	await _check_hit_grammar()
	await _check_pause_is_safe()
	await _check_neutral_doors()
	await _check_milestone_saves()
	await _check_fallen()
	await _check_restart()
	await _check_continue_at_every_milestone()
	await _check_invalid_file_recovery()
	await _check_reset_keeps_settings()
	_check_display_keep_revert()
	_check_display_startup_recovery()
	await _check_aim_assistance()
	await _check_scope()

	if _shot_dir != "":
		await _capture_evidence()

	# LAST, so it spans the complete run including the rendered evidence.
	_check_production_state_untouched()

	print("")
	if _failures.is_empty():
		print("GATE F VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("GATE F VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		get_tree().quit(1)


# --- 0. The harness's own storage, and the owner's own files -----------------

## D-191, made structural under D-192. The suite writes, corrupts, and DELETES
## real files. Before it does any of that it proves it was handed somewhere else
## to do it — and stops the whole run if it was not. There is no branch here that
## reports a problem and carries on with `user://`: a silent fall back to
## production storage IS the defect.
##
## THE QUESTION IS NOW ABOUT IDENTITY RATHER THAN SPELLING. D-191's guard asked
## whether the store's path string equalled the literal `user://…` constant. Hand
## `--state-dir` the real user data directory and the resulting path is a
## different STRING naming the same FILE, so the guard would have called the
## project owner's own storage isolated and everything below would have run
## against it. Every question here is asked of the canonical real path instead:
## globalized, `.` and `..` removed, every symlinked component followed.
func _require_isolated_storage() -> bool:
	print("")
	print("--- Verification storage is isolated (D-191), by identity rather than by spelling (D-192)")
	var production_directory: String = PrototypeStoragePaths.production_directory()
	var production_settings: String = PrototypeStoragePaths.production_settings_file()
	var production_lab: String = PrototypeStoragePaths.production_lab_file()
	var resolved_root: String = PrototypeStoragePaths.real_path(app.storage_root)
	var resolved_settings: String = PrototypeStoragePaths.real_path(settings.storage_path)
	var resolved_lab: String = PrototypeStoragePaths.real_path(lab_state.storage_path)

	var problems: PackedStringArray = PackedStringArray()
	if app.storage_root.is_empty():
		problems.append("no %s was given" % PrototypeApp.STATE_DIR_ARGUMENT)
	elif not DirAccess.dir_exists_absolute(app.storage_root):
		problems.append("the requested state directory does not exist: %s" % app.storage_root)
	if settings.uses_production_storage():
		problems.append("the settings store resolves onto the production file %s" % production_settings)
	if lab_state.uses_production_storage():
		problems.append("the lab store resolves onto the production file %s" % production_lab)
	if not app.storage_root.is_empty():
		if resolved_root == production_directory:
			problems.append("the state directory resolves to the production user data directory %s" % (
				production_directory
			))
		if PrototypeStoragePaths.is_inside_production_directory(app.storage_root):
			problems.append("the state directory resolves inside the production user data directory %s" % (
				production_directory
			))
		var wanted_settings: String = app.storage_root.path_join(PrototypeSettings.FILE_NAME)
		var wanted_lab: String = app.storage_root.path_join(PrototypeLabState.FILE_NAME)
		if settings.storage_path != wanted_settings:
			problems.append("the settings store is at %s, not %s" % [settings.storage_path, wanted_settings])
		if lab_state.storage_path != wanted_lab:
			problems.append("the lab store is at %s, not %s" % [lab_state.storage_path, wanted_lab])
	for row: Array in [["settings", resolved_settings], ["lab", resolved_lab]]:
		var resolved: String = String(row[1])
		if resolved == production_settings or resolved == production_lab:
			problems.append("the %s store resolves onto a production file: %s" % [String(row[0]), resolved])

	if not problems.is_empty():
		for problem: String in problems:
			printerr("  FAIL: %s" % problem)
		printerr("GATE F VERIFICATION: refusing to run without isolated storage.")
		printerr("  Run it through game/tests/gate_f_smoke.sh, or pass %s <directory> yourself." % (
			PrototypeApp.STATE_DIR_ARGUMENT
		))
		get_tree().quit(1)
		return false

	print("  state directory: %s" % app.storage_root)
	print("  settings:        %s" % settings.storage_path)
	print("  lab state:       %s" % lab_state.storage_path)
	print("  production:      %s | %s" % [
		ProjectSettings.globalize_path(PrototypeSettings.PATH),
		ProjectSettings.globalize_path(PrototypeLabState.PATH),
	])
	print("  production directory (resolved): %s" % production_directory)
	print("  production files (resolved):     %s | %s" % [production_settings, production_lab])
	print("  this run's files (resolved):     %s | %s" % [resolved_settings, resolved_lab])
	_expect(not app.storage_root.is_empty(), "the verification ran without an isolated state directory")
	_expect(not settings.uses_production_storage(), "the settings store is on the production path")
	_expect(not lab_state.uses_production_storage(), "the lab store is on the production path")
	_expect(settings.storage_path != lab_state.storage_path,
		"both stores were pointed at the same file")
	# D-192. Each of these is a question D-191's text comparison could not ask.
	_expect(resolved_root != production_directory,
		"the state directory resolves to the production user data directory %s" % production_directory)
	_expect(not PrototypeStoragePaths.is_inside_production_directory(app.storage_root),
		"the state directory resolves inside the production user data directory %s" % production_directory)
	_expect(resolved_settings != production_settings and resolved_settings != production_lab,
		"the settings store resolves onto a production file: %s" % resolved_settings)
	_expect(resolved_lab != production_settings and resolved_lab != production_lab,
		"the lab store resolves onto a production file: %s" % resolved_lab)
	_expect(resolved_settings != resolved_lab,
		"both stores resolve to the same file: %s" % resolved_settings)
	# The path calculator holds its own copies of the two production constants so
	# it never has to import the stores it guards. That duplication is only safe
	# while the two agree, so the agreement is asserted rather than assumed.
	_expect(PrototypeStoragePaths.PRODUCTION_SETTINGS == PrototypeSettings.PATH,
		"PrototypeStoragePaths.PRODUCTION_SETTINGS (%s) is not PrototypeSettings.PATH (%s)" % [
			PrototypeStoragePaths.PRODUCTION_SETTINGS, PrototypeSettings.PATH,
		])
	_expect(PrototypeStoragePaths.PRODUCTION_LAB == PrototypeLabState.PATH,
		"PrototypeStoragePaths.PRODUCTION_LAB (%s) is not PrototypeLabState.PATH (%s)" % [
			PrototypeStoragePaths.PRODUCTION_LAB, PrototypeLabState.PATH,
		])
	_expect(PrototypeStoragePaths.SETTINGS_FILE_NAME == PrototypeSettings.FILE_NAME,
		"PrototypeStoragePaths.SETTINGS_FILE_NAME is not PrototypeSettings.FILE_NAME")
	_expect(PrototypeStoragePaths.LAB_FILE_NAME == PrototypeLabState.FILE_NAME,
		"PrototypeStoragePaths.LAB_FILE_NAME is not PrototypeLabState.FILE_NAME")
	return true


## D-192. Every spelling of the production directory that D-191's text comparison
## would have accepted, asked of the guard in this process.
##
## IT IS A PURE CALCULATION. Nothing here reads a file's contents, writes one, or
## removes a real one: it asks `PrototypeStoragePaths` what a path resolves to.
## The two symlinks it needs are created inside this run's own isolated
## directory, under names deliberately unlike either state file so nothing in any
## suite could ever write through them, and they are removed again.
##
## The END-TO-END refusal — the application quitting with a non-zero code rather
## than starting — is checked from the shell in `gate_f_smoke.sh` step 2b on the
## non-writing `--check-state-dir` path, and the destructive half of this suite
## does not run unless that step passed first.
func _check_storage_alias_refusals() -> void:
	print("")
	print("--- Every spelling of the production directory is one directory (D-192)")
	var production_directory: String = PrototypeStoragePaths.production_directory()
	var absolute_root: String = ProjectSettings.globalize_path(PrototypeSettings.PATH).get_base_dir()

	# The engine's two answers must agree before either is worth comparing to.
	print("  user:// resolves to      %s" % production_directory)
	print("  globalized PATH's parent %s" % absolute_root)
	_expect(PrototypeStoragePaths.real_path(absolute_root) == production_directory,
		"the globalized settings path's directory (%s) is not the resolved user:// root (%s)" % [
			absolute_root, production_directory,
		])

	# WHETHER THIS FILESYSTEM FOLDS CASE IS MEASURED HERE, not assumed, so the
	# case spellings below are a test of something on any machine. If the volume
	# is case-sensitive the lower-case directory simply does not exist and the
	# rule must say so; if it folds, it does and the rule must say that.
	var lower_root: String = absolute_root.to_lower()
	var upper_leaf: String = absolute_root.get_base_dir().path_join(absolute_root.get_file().to_upper())
	var folds_case: bool = DirAccess.dir_exists_absolute(lower_root)
	print("  this volume folds case: %s (the lower-case directory %s)" % [
		str(folds_case), "exists" if folds_case else "does not exist",
	])
	_expect(PrototypeStoragePaths.compares_paths_case_insensitively() == folds_case,
		"the path comparison rule says case-insensitive=%s, but the filesystem says %s" % [
			str(PrototypeStoragePaths.compares_paths_case_insensitively()), str(folds_case),
		])

	var aliases: Array[Array] = [
		["the Godot user:// root", PrototypeSettings.PATH.get_base_dir()],
		["its absolute path", absolute_root],
		["a trailing separator", "%s/" % absolute_root],
		["a '.' component", "%s/./" % absolute_root],
		["a doubled separator", "%s//" % absolute_root],
		["a '..' round trip", absolute_root.path_join("..").path_join(absolute_root.get_file())],
	]
	if folds_case:
		# The alias the first D-192 guard accepted, and its relatives. They are
		# only added when the volume folds case, because on a case-sensitive one
		# they would be different directories and refusing them would be wrong.
		aliases.append_array([
			["all lower case", lower_root],
			["all upper case", upper_leaf],
			["lower case with '..'", lower_root.path_join("..").path_join(lower_root.get_file())],
			["upper case with '.'", "%s/./" % upper_leaf],
		])
	for row: Array in aliases:
		var label: String = String(row[0])
		var alias: String = String(row[1])
		print("  %-24s -> %s" % [label, PrototypeStoragePaths.real_path(alias)])
		_expect(PrototypeStoragePaths.is_production_directory(alias),
			"%s was not recognised as the production user data directory: %s" % [label, alias])
		_expect(PrototypeStoragePaths.is_production_file(alias.path_join(PrototypeSettings.FILE_NAME)),
			"the settings file under %s was not recognised as the production file" % label)
		_expect(PrototypeStoragePaths.is_production_file(alias.path_join(PrototypeLabState.FILE_NAME)),
			"the lab file under %s was not recognised as the production file" % label)

	# A symlink is the spelling a purely syntactic resolver cannot see through,
	# so it is made and asked about rather than assumed unreachable.
	var probe_directory: String = app.storage_root.path_join("alias_probe")
	DirAccess.make_dir_recursive_absolute(probe_directory)
	var links: DirAccess = DirAccess.open(probe_directory)
	var directory_link: String = probe_directory.path_join("production_directory_alias")
	var file_link: String = probe_directory.path_join("production_settings_alias.link")
	var linked: bool = false
	if links != null:
		DirAccess.remove_absolute(directory_link)
		DirAccess.remove_absolute(file_link)
		var directory_error: int = links.create_link(absolute_root, directory_link)
		var file_error: int = links.create_link(
			absolute_root.path_join(PrototypeSettings.FILE_NAME), file_link
		)
		linked = directory_error == OK and file_error == OK
	print("  symlink aliases created: %s" % str(linked))
	_expect(linked, "the symlink aliases could not be created, so that spelling is untested")
	if linked:
		print("  a symlinked directory    -> %s" % PrototypeStoragePaths.real_path(directory_link))
		print("  a symlinked file         -> %s" % PrototypeStoragePaths.real_path(file_link))
		_expect(PrototypeStoragePaths.is_production_directory(directory_link),
			"a symlink to the production directory was not recognised as it")
		_expect(PrototypeStoragePaths.is_production_file(
				directory_link.path_join(PrototypeSettings.FILE_NAME)),
			"the settings file under a symlinked production directory was not recognised")
		_expect(PrototypeStoragePaths.is_production_file(file_link),
			"a symlink to the production settings file was not recognised as it")
		_expect(PrototypeStoragePaths.same_file(file_link, PrototypeSettings.PATH),
			"a symlink to the production settings file was not the same file as user://")
		DirAccess.remove_absolute(directory_link)
		DirAccess.remove_absolute(file_link)
	DirAccess.remove_absolute(probe_directory)
	_expect(not FileAccess.file_exists(file_link), "the symlink alias probe was left behind")

	# The descendant question is asked through the same comparison, so a
	# differently-cased path INSIDE the user data directory is inside it too.
	var inside: String = absolute_root.path_join("logs")
	print("  a directory inside it    -> %s" % PrototypeStoragePaths.real_path(inside))
	_expect(PrototypeStoragePaths.is_inside_production_directory(inside),
		"a directory inside the user data directory was not recognised as inside it")
	_expect(not PrototypeStoragePaths.is_production_directory(inside),
		"a directory inside the user data directory was mistaken for the directory itself")
	_expect(not PrototypeStoragePaths.is_descendant(absolute_root, absolute_root),
		"the user data directory was treated as a descendant of itself")
	if folds_case:
		_expect(PrototypeStoragePaths.is_inside_production_directory(inside.to_lower()),
			"a lower-case directory inside the user data directory was not recognised as inside it")
		_expect(PrototypeStoragePaths.same_path(absolute_root, lower_root),
			"the user data directory and its lower-case spelling were treated as two directories")
		_expect(PrototypeStoragePaths.is_production_file(
				lower_root.path_join(PrototypeSettings.FILE_NAME.to_upper())),
			"an upper-case production settings file name was not recognised as the production file")

	# A guard that refuses everything protects nothing. This run's own storage
	# must be recognised as NOT production, or the whole suite would refuse to
	# run for the wrong reason.
	_expect(not PrototypeStoragePaths.is_production_directory(app.storage_root),
		"this run's own isolated directory was mistaken for the production one")
	_expect(not PrototypeStoragePaths.is_production_directory(app.storage_root.to_lower()),
		"this run's own isolated directory, lower-cased, was mistaken for the production one")
	_expect(not PrototypeStoragePaths.is_inside_production_directory(app.storage_root),
		"this run's own isolated directory was placed inside the production one")
	_expect(not PrototypeStoragePaths.is_production_file(settings.storage_path),
		"this run's settings file was mistaken for the production one")
	_expect(not PrototypeStoragePaths.is_production_file(lab_state.storage_path),
		"this run's lab file was mistaken for the production one")
	_expect(PrototypeStoragePaths.same_file(
			PrototypeSettings.PATH, absolute_root.path_join(PrototypeSettings.FILE_NAME)),
		"the same settings file spelled two ways was not recognised as one file")
	_expect(not PrototypeStoragePaths.same_file(PrototypeSettings.PATH, PrototypeLabState.PATH),
		"the settings file and the lab file were treated as the same file")

	# And the stores refuse it themselves, independently of the app (D-192).
	# These probes are constructed and thrown away; not one of them is ever asked
	# to read, write, or delete anything.
	print("  the engine ERROR lines that follow ARE the refusals: each store says")
	print("  out loud that it will not be pointed at a production file, in any case")
	var settings_probe: PrototypeSettings = PrototypeSettings.new()
	_expect(not settings_probe.set_storage_path(absolute_root.path_join(PrototypeSettings.FILE_NAME)),
		"the settings store accepted the production file, spelled absolutely, as injected storage")
	if folds_case:
		_expect(not settings_probe.set_storage_path(lower_root.path_join(PrototypeSettings.FILE_NAME)),
			"the settings store accepted the production settings file in another case")
	_expect(settings_probe.uses_production_storage(),
		"a refused settings store did not stay on its production default")
	_expect(not settings_probe.set_storage_path(""),
		"the settings store accepted an empty storage path")
	_expect(settings_probe.set_storage_path(settings.storage_path),
		"the settings store refused this run's own isolated file")
	var lab_probe: PrototypeLabState = PrototypeLabState.new()
	_expect(not lab_probe.set_storage_path(absolute_root.path_join(PrototypeLabState.FILE_NAME)),
		"the lab store accepted the production file, spelled absolutely, as injected storage")
	if folds_case:
		_expect(not lab_probe.set_storage_path(lower_root.path_join(PrototypeLabState.FILE_NAME)),
			"the lab store accepted the production lab-state file in another case")
	_expect(lab_probe.uses_production_storage(),
		"a refused lab store did not stay on its production default")
	_expect(not lab_probe.set_storage_path(""),
		"the lab store accepted an empty storage path")
	_expect(lab_probe.set_storage_path(lab_state.storage_path),
		"the lab store refused this run's own isolated file")
	print("  both stores refuse the production file and accept this run's isolated file")


func _capture_production_fingerprint() -> void:
	_production_before = _production_fingerprint()
	print("  the project owner's own files, before this run:")
	print("    %s  %s" % [PrototypeSettings.PATH, String(_production_before["settings"])])
	print("    %s  %s" % [PrototypeLabState.PATH, String(_production_before["lab"])])


func _production_fingerprint() -> Dictionary:
	return {
		"settings": _file_fingerprint(PrototypeSettings.PATH),
		"lab": _file_fingerprint(PrototypeLabState.PATH),
	}


## "absent" is a legitimate answer and must stay legitimate: the point is that
## the run changes NOTHING, not that a file has to exist.
func _file_fingerprint(path: String) -> String:
	if not FileAccess.file_exists(path):
		return "absent"
	return "%d bytes, sha256 %s" % [
		FileAccess.get_file_as_bytes(path).size(), FileAccess.get_sha256(path),
	]


## Runs LAST, after the rendered evidence, so it spans everything this process
## did. Byte-for-byte identical, or absent at both ends.
func _check_production_state_untouched() -> void:
	print("")
	print("--- The project owner's own files were never touched (D-191)")
	var after: Dictionary = _production_fingerprint()
	for row: Array in [
		["settings", PrototypeSettings.PATH],
		["lab", PrototypeLabState.PATH],
	]:
		var key: String = String(row[0])
		var path: String = String(row[1])
		print("  %s" % path)
		print("    before %s" % String(_production_before[key]))
		print("    after  %s" % String(after[key]))
		_expect(String(after[key]) == String(_production_before[key]),
			"%s changed during the run: %s -> %s" % [
				path, String(_production_before[key]), String(after[key]),
			])


# --- 1. The title surface and the two files ----------------------------------

func _check_title_and_files() -> void:
	print("")
	print("--- Start New Lab / Continue Lab / Settings / Quit (specification §7.1)")
	print("  verification state files at start: settings %s, lab %s" % [
		str(FileAccess.file_exists(settings.storage_path)),
		str(FileAccess.file_exists(lab_state.storage_path)),
	])
	_expect(app.title.visible, "the app did not open on the title screen")
	_expect(app.room == null, "a lab was loaded before Start New Lab was chosen")
	_expect(not lab_state.exists, "a lab-state file survived the clean slate")
	_expect(lab_state.problem.is_empty(), "an absent lab file reported a problem: %s" % lab_state.problem)

	# The four §7.1 offers exist by name on the surface that offers them.
	var captions: PackedStringArray = _button_captions(app.title)
	print("  title offers: %s" % ", ".join(captions))
	for wanted: String in ["Continue Lab", "Start New Lab", "Settings", "Quit"]:
		_expect(captions.has(wanted), "the title screen does not offer '%s'" % wanted)
	# And nothing the canonical session rules forbid.
	for forbidden: String in ["Login", "Sign in", "Store", "Shop", "Battle Pass", "Daily"]:
		_expect(not captions.has(forbidden), "the title screen offers '%s'" % forbidden)

	# §20.3: Continue is unavailable, and it says why rather than pretending.
	_expect(_button_named(app.title, "ContinueLab").disabled,
		"Continue Lab is enabled with no saved laboratory")
	var text: String = _visible_text_in(app.title)
	_expect(text.contains("No saved laboratory yet"),
		"the title screen does not say that nothing has been saved")
	_expect(text.to_lower().contains("not final ui"),
		"the title screen does not identify itself as prototype presentation")


# --- 2. §21 settings ---------------------------------------------------------

func _check_settings_contract() -> void:
	print("")
	print("--- The §21 settings, their defaults, and their ranges")
	settings.restore_defaults(false)
	print("  defaults: %s" % settings.describe())
	for row: Array in [
		["controller deadzone", settings.controller_deadzone, 0.20],
		["aim assistance", float(settings.aim_assistance), 70.0],
		["master volume", settings.master_volume, 0.80],
	]:
		_expect(is_equal_approx(float(row[1]), float(row[2])),
			"%s defaults to %.3f, not the §21 value %.3f" % [String(row[0]), float(row[1]), float(row[2])])
	_expect(settings.damage_numbers, "§17: damage numbers must default to On")
	_expect(settings.vibration == PrototypeSettings.Level.STANDARD, "vibration does not default to Standard")
	_expect(settings.screen_shake == PrototypeSettings.Level.STANDARD, "screen shake does not default to Standard")
	_expect(settings.bright_flashes == PrototypeSettings.Level.STANDARD, "bright flashes do not default to Standard")
	_expect(settings.window_mode == PrototypeSettings.WindowMode.WINDOWED, "§4.3: the default window mode is windowed")
	_expect(settings.is_default(), "a freshly restored settings store does not read as default")

	# §18: "Screen shake and bright flashes must be reducible or disabled", and
	# Off must be exactly zero rather than nearly zero.
	for level: PrototypeSettings.Level in [
		PrototypeSettings.Level.STANDARD, PrototypeSettings.Level.REDUCED, PrototypeSettings.Level.OFF,
	]:
		settings.set_screen_shake(level)
		settings.set_bright_flashes(level)
		settings.set_vibration(level)
		print("  %-9s shake %.2f  flashes %.2f  vibration %.2f" % [
			settings.level_name(level), settings.shake_scale(),
			settings.flash_scale(), settings.vibration_scale(),
		])
		var wanted: float = [1.0, 0.40, 0.0][int(level)]
		_expect(is_equal_approx(settings.shake_scale(), wanted), "shake at %s is not %.2f" % [settings.level_name(level), wanted])
		_expect(is_equal_approx(settings.flash_scale(), wanted), "flashes at %s is not %.2f" % [settings.level_name(level), wanted])
		_expect(is_equal_approx(settings.vibration_scale(), wanted), "vibration at %s is not %.2f" % [settings.level_name(level), wanted])
	_expect(is_zero_approx(PrototypeSettings._level_scale(PrototypeSettings.Level.OFF)),
		"Off is not exactly zero")
	settings.restore_defaults(false)

	# Ranges. An out-of-range write is clamped rather than accepted.
	settings.set_controller_deadzone(9.0)
	_expect(is_equal_approx(settings.controller_deadzone, PrototypeSettings.DEADZONE_RANGE.y),
		"a deadzone of 9.0 was not clamped")
	settings.set_controller_deadzone(-1.0)
	_expect(is_equal_approx(settings.controller_deadzone, PrototypeSettings.DEADZONE_RANGE.x),
		"a negative deadzone was not clamped")
	settings.set_aim_assistance(500)
	_expect(settings.aim_assistance == 100, "aim assistance above 100 was not clamped")
	settings.set_master_volume(4.0)
	_expect(is_equal_approx(settings.master_volume, 1.0), "master volume above 1.0 was not clamped")
	settings.restore_defaults(false)

	# §21 aim assistance, and the promise that its DEFAULT changes nothing the
	# project owner already accepted.
	print("  aim assistance 0 / 70 / 100 -> cone scale %.3f / %.3f / %.3f" % [
		_assist_scale(0), _assist_scale(70), _assist_scale(100),
	])
	_expect(is_equal_approx(_assist_scale(70), 1.0),
		"the default 70 / 100 aim assistance is not exactly 1.000x; D-178's accepted cone would move")
	_expect(_assist_scale(0) < 1.0 and _assist_scale(100) > 1.0,
		"aim assistance does not narrow below the default and widen above it")

	# Persistence, and the round trip.
	settings.set_damage_numbers(false)
	settings.set_screen_shake(PrototypeSettings.Level.OFF)
	settings.set_master_volume(0.33)
	settings.set_controller_deadzone(0.27)
	_expect(settings.save_to_disk(), "the settings file could not be written: %s" % settings.last_save_status)
	var reloaded: PrototypeSettings = _settings_probe()
	reloaded.load_from_disk()
	print("  round trip: %s" % reloaded.describe())
	_expect(not reloaded.damage_numbers, "damage numbers Off did not survive the round trip")
	_expect(reloaded.screen_shake == PrototypeSettings.Level.OFF, "shake Off did not survive the round trip")
	_expect(is_equal_approx(reloaded.master_volume, 0.33), "master volume did not survive the round trip")
	_expect(is_equal_approx(reloaded.controller_deadzone, 0.27), "the deadzone did not survive the round trip")
	_expect(reloaded.corrections.is_empty(), "a clean settings file reported corrections: %s" % ", ".join(reloaded.corrections))

	# A corrupt settings file falls back to the §21 defaults and SAYS what it had
	# to correct, rather than pushing a nonsense value into the player.
	var broken: ConfigFile = ConfigFile.new()
	broken.set_value("meta", "schema_version", PrototypeSettings.SCHEMA_VERSION)
	broken.set_value("controls", "controller_deadzone", 12.5)
	broken.set_value("presentation", "damage_numbers", "yes please")
	broken.set_value("presentation", "screen_shake", 99)
	broken.save(settings.storage_path)
	var repaired: PrototypeSettings = _settings_probe()
	repaired.load_from_disk()
	print("  corrupt file: %s" % repaired.last_load_status)
	_expect(repaired.corrections.size() >= 3, "a corrupt settings file reported %d corrections" % repaired.corrections.size())
	_expect(is_equal_approx(repaired.controller_deadzone, PrototypeSettings.DEADZONE_RANGE.y),
		"a 12.5 deadzone was not clamped on load")
	_expect(repaired.damage_numbers, "a non-boolean damage-number value did not fall back to the default")
	_expect(repaired.screen_shake == PrototypeSettings.Level.STANDARD, "an unknown level did not fall back to Standard")

	# A file from another schema is RESET, never reinterpreted.
	var stale: ConfigFile = ConfigFile.new()
	stale.set_value("meta", "schema_version", PrototypeSettings.SCHEMA_VERSION + 7)
	stale.set_value("audio", "master_volume", 0.01)
	stale.save(settings.storage_path)
	var migrated: PrototypeSettings = _settings_probe()
	migrated.load_from_disk()
	print("  stale schema: %s" % migrated.last_load_status)
	_expect(migrated.is_default(), "a settings file from another schema was partially adopted")

	settings.restore_defaults(false)
	settings.save_to_disk()


func _assist_scale(value: int) -> float:
	var probe: PrototypeSettings = PrototypeSettings.new()
	probe.set_aim_assistance(value)
	return probe.aim_assist_scale()


# --- 3. The authored audio ---------------------------------------------------

func _check_authored_audio() -> void:
	print("")
	print("--- Project-authored audio (specification §19, D-189)")
	print("  %d families, %d variants declared; %d loaded" % [
		PrototypeCueCatalogue.FAMILIES.size(), PrototypeCueCatalogue.total_variants(),
		audio.loaded_variant_count(),
	])
	_expect(audio.is_complete(),
		"%d declared cue variants are missing: %s" % [
			audio.missing_streams.size(), ", ".join(audio.missing_streams),
		])

	# §19's required cue families, by name. This is the list the specification
	# prints, and every one of them has an authored take.
	for required: String in [
		"footstep", "quick_strike_commit", "quick_strike_release",
		"impact_bone_ordinary", "impact_bone_improved",
		"graveblade_anticipation", "graveblade_release",
		"player_damage", "graveblade_death",
		"sword_drop", "comparison_open", "equip",
		"passive_confirm", "menu_confirm", "invalid_action", "fallen",
	]:
		_expect(PrototypeCueCatalogue.FAMILIES.has(required),
			"specification §19 requires a '%s' cue family and there is none" % required)
		_expect(PrototypeCueCatalogue.variant_count(required) >= 1,
			"the '%s' cue family has no authored take" % required)

	# NOTHING WAS DOWNLOADED OR IMPORTED. No sound file of any kind exists under
	# the prototype audio tree: every cue is a generated Godot resource.
	var samples: PackedStringArray = PackedStringArray()
	for extension: String in [".wav", ".ogg", ".mp3", ".flac", ".aiff", ".aif", ".m4a"]:
		samples.append_array(_files_under("res://assets/prototype/audio", extension))
	var generated: PackedStringArray = _files_under("res://assets/prototype/audio", ".res")
	print("  %d generated cue resources, %d imported sound files" % [generated.size(), samples.size()])
	_expect(samples.is_empty(), "imported sound files exist: %s" % ", ".join(samples))
	_expect(generated.size() == PrototypeCueCatalogue.total_variants(),
		"%d generated cue resources on disk against %d declared" % [
			generated.size(), PrototypeCueCatalogue.total_variants(),
		])
	# Every file on disk is declared, so nothing can be shipped that the
	# catalogue and the derivation note do not describe.
	var declared: PackedStringArray = PrototypeCueCatalogue.all_variant_paths()
	for path: String in generated:
		_expect(declared.has(path), "%s exists on disk but is not in the catalogue" % path)
	_expect(FileAccess.file_exists(PrototypeCueCatalogue.DERIVATION_NOTE),
		"the audio derivation note is missing")
	var note: String = FileAccess.get_file_as_string(PrototypeCueCatalogue.DERIVATION_NOTE)
	for family: String in PrototypeCueCatalogue.family_names():
		_expect(note.contains("`%s`" % family), "the derivation note does not describe '%s'" % family)

	# §19: "Music is absent." Nothing here loops, and the longest cue is the
	# 1.60-second Fallen — there is no bed, no loop, and no track.
	var longest: float = 0.0
	var longest_name: String = ""
	for family: String in PrototypeCueCatalogue.family_names():
		for index: int in PrototypeCueCatalogue.variant_count(family):
			var stream: AudioStreamWAV = load(PrototypeCueCatalogue.variant_path(family, index)) as AudioStreamWAV
			_expect(stream != null, "%s is not an AudioStreamWAV" % PrototypeCueCatalogue.variant_path(family, index))
			if stream == null:
				continue
			_expect(stream.loop_mode == AudioStreamWAV.LOOP_DISABLED,
				"the '%s' cue loops; music is absent by specification §19" % family)
			_expect(stream.mix_rate == PrototypeCueCatalogue.MIX_RATE,
				"the '%s' cue is not at the declared %d Hz" % [family, PrototypeCueCatalogue.MIX_RATE])
			var seconds: float = _stream_seconds(stream)
			if seconds > longest:
				longest = seconds
				longest_name = family
	print("  longest cue: %s at %.2f s; no cue loops" % [longest_name, longest])
	_expect(longest <= 2.5, "the longest cue is %.2f s; that is a bed, not a cue" % longest)


# --- 4. Routing, variation, and rate limiting --------------------------------

func _check_audio_routing_and_variation() -> void:
	print("")
	print("--- Cue routing, variation, and rate limiting (specification §19)")
	for family: String in PrototypeCueCatalogue.family_names():
		var bus: String = String(PrototypeCueCatalogue.field(family, "bus", ""))
		_expect(AudioServer.get_bus_index(bus) > 0,
			"the '%s' cue routes to bus '%s', which is not one of the Gate A buses" % [family, bus])

	# Aliases resolve, so a surface that names itself reaches an authored cue.
	for alias: String in PrototypeCueCatalogue.ALIASES.keys():
		var resolved: String = PrototypeCueCatalogue.resolve(alias)
		_expect(PrototypeCueCatalogue.FAMILIES.has(resolved),
			"the alias '%s' resolves to '%s', which is not an authored family" % [alias, resolved])

	# VARIATION. `footstep` has four authored takes; a shuffle bag must play all
	# four before repeating any, and must never repeat one back to back.
	var family_name: String = "footstep"
	var takes: int = PrototypeCueCatalogue.variant_count(family_name)
	var minimum: float = float(PrototypeCueCatalogue.field(family_name, "min_interval", 0.0))
	var played: PackedInt32Array = PackedInt32Array()
	for i: int in takes * 3:
		var chosen: int = audio.play(family_name)
		if chosen >= 0:
			played.append(chosen)
		await _wait_seconds(minimum + 0.02)
	print("  %s take order over %d plays: %s" % [family_name, played.size(), str(Array(played))])
	_expect(played.size() >= takes * 2, "only %d of %d footstep plays were accepted" % [played.size(), takes * 3])
	var seen: Dictionary = {}
	for value: int in played:
		seen[value] = true
	_expect(seen.size() == takes, "%d of the %d authored footstep takes were ever chosen" % [seen.size(), takes])
	var immediate_repeats: int = 0
	for i: int in range(1, played.size()):
		if played[i] == played[i - 1]:
			immediate_repeats += 1
	print("  immediate repeats: %d" % immediate_repeats)
	_expect(immediate_repeats == 0, "%d footstep plays repeated the previous take back to back" % immediate_repeats)

	# RATE LIMITING. Two plays inside the family's own minimum interval: the
	# second is dropped, not layered.
	var before_dropped: int = audio.cues_dropped
	audio.play("impact_bone_ordinary")
	var second: int = audio.play("impact_bone_ordinary")
	print("  two impacts inside the %.2f s limit: second returned %d, drops %d -> %d" % [
		float(PrototypeCueCatalogue.field("impact_bone_ordinary", "min_interval", 0.0)),
		second, before_dropped, audio.cues_dropped,
	])
	_expect(second == -1 and audio.cues_dropped == before_dropped + 1,
		"a second impact inside the rate limit was not dropped")

	# The voices are real, they are the only ones, and they are on their buses.
	print("  %d voices across the Combat and UI buses" % audio.voice_count())
	_expect(audio.voice_count() == PrototypeAudioDirector.COMBAT_VOICES + PrototypeAudioDirector.UI_VOICES,
		"the voice pool is %d, not the declared %d" % [
			audio.voice_count(),
			PrototypeAudioDirector.COMBAT_VOICES + PrototypeAudioDirector.UI_VOICES,
		])


func _check_master_volume() -> void:
	print("")
	print("--- Master volume applies immediately (specification §19, §21)")
	var bus: int = AudioServer.get_bus_index("Master")
	for value: float in [1.0, 0.5, 0.25]:
		audio.apply_master_volume(value)
		var live: float = AudioServer.get_bus_volume_db(bus)
		print("  %.2f -> %+.2f dB on the Master bus, muted=%s" % [value, live, str(AudioServer.is_bus_mute(bus))])
		_expect(is_equal_approx(live, linear_to_db(value)),
			"master %.2f produced %+.2f dB, not %+.2f dB" % [value, live, linear_to_db(value)])
		_expect(not AudioServer.is_bus_mute(bus), "the Master bus is muted at %.2f" % value)
	audio.apply_master_volume(0.0)
	print("  0.00 -> the Master bus is muted outright, not merely quiet")
	_expect(AudioServer.is_bus_mute(bus), "master volume 0 did not mute the Master bus")
	audio.apply_master_volume(0.8)


# --- 5. Start New Lab --------------------------------------------------------

func _check_start_new_lab() -> void:
	print("")
	print("--- Start New Lab (specification §7.1)")
	app.start_new_lab()
	await _await_room()
	print("  %s, XP %d, %s" % [progress.stage_name(), progress.experience, player.weapon.display_name])
	_expect(room != null, "Start New Lab did not load the laboratory")
	_expect(not app.title.visible, "the title screen is still visible over the laboratory")
	_expect(progress.stage == LabProgress.Stage.STARTER_FIGHT, "a new laboratory did not start at STARTER_FIGHT")
	_expect(progress.experience == 0, "a new laboratory started with %d XP" % progress.experience)
	_expect(player.weapon == room.starter_sword, "a new laboratory did not start with the Training Sword")
	_expect(room.director.active, "the progression director is suspended in the shipped flow")

	# The app owns the one input-family tracker (§7.1).
	_expect(room.input_family == app.input_family,
		"the room kept its own input-family tracker instead of adopting the app's")
	_expect(_count_nodes_of_type(room, "InputFamilyTracker") == 0,
		"a second input-family tracker survives inside the room")


# --- 6. The §17 HUD ----------------------------------------------------------

func _check_hud_contract() -> void:
	print("")
	print("--- The restrained §17 HUD")
	await _settle(4)
	var text: String = _visible_text_in(hud)
	print("  on screen: %s" % text.replace("\n", " | "))
	for required: String in ["LIFE", "MANA", "XP", "Quick Strike"]:
		_expect(text.contains(required), "the HUD does not show '%s'" % required)
	_expect(text.contains(player.weapon.display_name), "the HUD does not show the equipped weapon name")
	_expect(text.contains("%.0f / %.0f" % [player.life, player.max_life]),
		"the HUD does not show current and maximum Life")
	_expect(text.to_lower().contains("not final ui"),
		"the HUD does not identify itself as prototype presentation")

	# §17's exclusions, by the words they would use.
	for forbidden: String in ["Rarity", "Rift Shard", "Minimap", "Objective", "Inventory", "Slot"]:
		_expect(not text.contains(forbidden), "the HUD shows '%s', which §17 excludes" % forbidden)

	# AND IT IS ACTUALLY ON SCREEN. Reading the right words out of a Control tree
	# proves the words exist, not that anyone can see them — a surface whose root
	# has a zero-size rect reports perfect text while every panel anchored inside
	# it sits at the origin or off the top of the screen. That is precisely the
	# failure this check was added to catch, and it caught it.
	_check_surface_is_on_screen(hud, "the HUD")

	# A HUD that absorbed the pointer would break click-to-move, which §9.3
	# protects. Nothing in it may stop a mouse.
	var stoppers: PackedStringArray = _mouse_stopping_controls(hud)
	print("  mouse-absorbing controls in the HUD: %d" % stoppers.size())
	_expect(stoppers.is_empty(), "the HUD absorbs the pointer at: %s" % ", ".join(stoppers))

	# §22: the debug overlay is not player-facing, so the four gates of
	# instrumentation start hidden and F3 reveals them.
	_expect(not room.instrumentation_visible,
		"the Gate B-E instrumentation cards are visible in the shipped flow")
	room.set_instrumentation_visible(true)
	_expect(room.instrumentation_visible, "F3 did not reveal the instrumentation")
	room.set_instrumentation_visible(false)
	# The Gate E ground nameplate is NOT instrumentation: it is what the mouse
	# clicks, so hiding the cards must leave it reachable.
	_expect(room.lab_overlay.call("nameplate") != null,
		"the ground nameplate was removed with the instrumentation")


# --- 7. Damage numbers On and Off --------------------------------------------

func _check_damage_numbers() -> void:
	print("")
	print("--- Damage numbers On and Off (specification §17, §18)")
	await _await_living_enemy(4.0)
	settings.set_damage_numbers(true)
	await _settle(2)

	var enemy: PrototypeGraveblade = room.graveblade
	var before: Dictionary = _feedback_snapshot()
	var life_before: float = enemy.life
	await _strike_enemy_once(enemy)
	await _settle(3)
	# Life is restored after each measured Hit. This check is about the NUMBER,
	# not about the kill, and killing the starter Graveblade here would leave the
	# next check — pause — with no enemy whose attack phase it could watch freeze.
	# A frozen clock on an absent enemy is exactly the kind of assertion that
	# passes for the wrong reason.
	var life_after_first: float = enemy.life
	var after_on: Dictionary = _feedback_snapshot()
	print("  numbers On:  Life %.0f -> %.0f, %d numbers spawned, %d suppressed, %d hits shown" % [
		life_before, life_after_first,
		int(after_on["spawned"]) - int(before["spawned"]),
		int(after_on["suppressed"]) - int(before["suppressed"]),
		int(after_on["hits"]) - int(before["hits"]),
	])
	_expect(is_equal_approx(life_after_first, life_before - 100.0), "the Hit did not deal exactly 100")
	enemy.life = enemy.data.max_life
	_expect(int(after_on["spawned"]) > int(before["spawned"]), "damage numbers On produced no number")
	_expect(int(after_on["shown"]) > int(before["shown"]), "the feedback layer did not count the number it showed")

	# OFF. Everything else must still happen: this is the check that proves the
	# suppression touches the NUMBER and nothing else (specification §23.5).
	settings.set_damage_numbers(false)
	await _settle(2)
	var life_mid: float = enemy.life
	var before_off: Dictionary = _feedback_snapshot()
	await _strike_enemy_once(enemy)
	await _settle(3)
	var life_after_second: float = enemy.life
	enemy.life = enemy.data.max_life
	var after_off: Dictionary = _feedback_snapshot()
	print("  numbers Off: Life %.0f -> %.0f, %d numbers spawned, %d suppressed, %d hits, %d impacts heard, %d camera impulses" % [
		life_mid, life_after_second,
		int(after_off["spawned"]) - int(before_off["spawned"]),
		int(after_off["suppressed"]) - int(before_off["suppressed"]),
		int(after_off["hits"]) - int(before_off["hits"]),
		int(after_off["impact_cues"]) - int(before_off["impact_cues"]),
		int(after_off["impulses"]) - int(before_off["impulses"]),
	])
	_expect(is_equal_approx(life_after_second, life_mid - 100.0),
		"damage numbers Off changed the damage: %.0f instead of 100" % (life_mid - life_after_second))
	_expect(int(after_off["spawned"]) == int(before_off["spawned"]),
		"damage numbers Off still spawned a number")
	_expect(int(after_off["suppressed"]) > int(before_off["suppressed"]),
		"damage numbers Off did not record the suppression")
	_expect(int(after_off["hits"]) > int(before_off["hits"]),
		"damage numbers Off suppressed the Hit feedback as well as the number")
	_expect(int(after_off["impact_cues"]) > int(before_off["impact_cues"]),
		"damage numbers Off suppressed the impact SOUND, which is the channel §26 asks to be judged without them")
	_expect(int(after_off["impulses"]) > int(before_off["impulses"]),
		"damage numbers Off suppressed the camera impulse")

	# F2 reaches the same store, so the key and the panel can never disagree.
	room.toggle_damage_numbers()
	_expect(settings.damage_numbers, "F2 did not switch damage numbers back On")
	room.toggle_damage_numbers()
	_expect(not settings.damage_numbers, "F2 did not switch damage numbers back Off")
	settings.set_damage_numbers(true)

	# Shake, flashes, and vibration Off must be exactly zero in the live layer.
	settings.set_screen_shake(PrototypeSettings.Level.OFF)
	settings.set_bright_flashes(PrototypeSettings.Level.OFF)
	settings.set_vibration(PrototypeSettings.Level.OFF)
	await _settle(2)
	var impulses_before: int = room.camera_rig.impulses_applied
	var life_low: float = enemy.life
	await _strike_enemy_once(enemy)
	await _settle(3)
	enemy.life = enemy.data.max_life
	print("  every effect Off: Life %.0f struck, camera impulses %d -> %d, impulse offset %.4f m" % [
		life_low, impulses_before, room.camera_rig.impulses_applied,
		room.camera_rig.impulse_offset().length(),
	])
	_expect(room.camera_rig.impulses_applied == impulses_before,
		"screen shake Off still moved the camera")
	_expect(is_zero_approx(feedback.shake_scale()) and is_zero_approx(feedback.flash_scale()),
		"Off is not exactly zero in the live feedback layer")
	settings.restore_defaults(false)
	await _settle(2)


# --- 8. 100 against 150, measured -------------------------------------------

func _check_hit_grammar() -> void:
	print("")
	print("--- The improved Hit is heavier, not brighter (specification §18)")
	# Read from the AUTHORED AUDIO rather than from intention. Both cues are
	# profiled the same way and compared on three axes.
	var ordinary: Dictionary = _profile_family("impact_bone_ordinary")
	var improved: Dictionary = _profile_family("impact_bone_improved")
	print("  ordinary  %.3f s  rms %.4f  low-band %.3f  zero-crossings %.0f/s" % [
		float(ordinary["seconds"]), float(ordinary["rms"]),
		float(ordinary["low_ratio"]), float(ordinary["zcr"]),
	])
	print("  improved  %.3f s  rms %.4f  low-band %.3f  zero-crossings %.0f/s" % [
		float(improved["seconds"]), float(improved["rms"]),
		float(improved["low_ratio"]), float(improved["zcr"]),
	])
	_expect(float(improved["seconds"]) > float(ordinary["seconds"]),
		"the improved impact is not longer than the ordinary one")
	_expect(float(improved["low_ratio"]) > float(ordinary["low_ratio"]),
		"the improved impact carries no more low-frequency weight than the ordinary one")
	# NOT BRIGHTER. Zero-crossing rate is a cheap, honest brightness proxy: an
	# elemental cue — a ring, a shimmer, a bell — raises it. A heavier sword does
	# not. This is the machine-checkable half of "must not masquerade as a new
	# elemental effect".
	_expect(float(improved["zcr"]) <= float(ordinary["zcr"]),
		"the improved impact is BRIGHTER than the ordinary one (%0.f vs %.0f zero-crossings/s); that reads as an element, not as a heavier sword" % [
			float(improved["zcr"]), float(ordinary["zcr"]),
		])
	_expect(float(improved["gain_db"]) > float(ordinary["gain_db"]),
		"the improved impact is not louder")
	_expect(float(improved["gain_db"]) - float(ordinary["gain_db"]) < 6.0,
		"the improved impact is %.1f dB louder; that is a different event, not a stronger layer" % (
			float(improved["gain_db"]) - float(ordinary["gain_db"])
		))

	# And the visual half: the same grammar, four scalars larger.
	print("  camera impulse %.2f -> %.2f, flash %.2f -> %.2f, recoil %.2f -> %.2f m" % [
		PrototypeCombatFeedback.IMPULSE_HIT_ORDINARY, PrototypeCombatFeedback.IMPULSE_HIT_IMPROVED,
		PrototypeCombatFeedback.FLASH_HIT_ORDINARY, PrototypeCombatFeedback.FLASH_HIT_IMPROVED,
		PrototypeCombatFeedback.RECOIL_ORDINARY, PrototypeCombatFeedback.RECOIL_IMPROVED,
	])
	_expect(PrototypeCombatFeedback.IMPULSE_HIT_IMPROVED > PrototypeCombatFeedback.IMPULSE_HIT_ORDINARY,
		"the improved Hit does not knock the camera harder")
	_expect(PrototypeCombatFeedback.FLASH_HIT_IMPROVED > PrototypeCombatFeedback.FLASH_HIT_ORDINARY,
		"the improved Hit does not flash harder")
	_expect(PrototypeCombatFeedback.RECOIL_IMPROVED > PrototypeCombatFeedback.RECOIL_ORDINARY,
		"the improved Hit does not recoil the target further")

	# §18's capped camera impulse is genuinely capped.
	print("  camera impulse cap %.3f m; largest produced this run %.4f m" % [
		room.camera_rig.maximum_impulse_metres, room.camera_rig.largest_impulse,
	])
	_expect(room.camera_rig.largest_impulse <= room.camera_rig.maximum_impulse_metres + 0.0001,
		"the camera impulse exceeded its cap")
	_expect(room.camera_rig.maximum_impulse_metres <= 0.25,
		"the camera impulse cap is %.2f m; §18 asks for a SMALL capped impulse" % room.camera_rig.maximum_impulse_metres)


# --- 9. Pause genuinely stops the world --------------------------------------

func _check_pause_is_safe() -> void:
	print("")
	print("--- Pause stops the simulation and every clock (specification §21, §9.2)")
	await _release_all_inputs()
	await _await_living_enemy(6.0)
	# The roster can empty between waves, and a corpse is freed after its linger.
	# The enemy-specific measurements below are taken only when there really is
	# one, so a between-waves moment cannot make this check crash — or, worse,
	# pass for the wrong reason.
	var enemy: PrototypeGraveblade = room.graveblade
	var have_enemy: bool = enemy != null and is_instance_valid(enemy) and enemy.is_alive()
	# Required, not optional: a frozen attack phase measured on an absent enemy is
	# an assertion that passes because nothing happened.
	_expect(have_enemy, "the pause check needs a living Graveblade whose clocks it can watch freeze")
	room.open_pause("verification")
	await _settle(2)
	_expect(room.pause_menu.is_open, "the pause menu did not open")
	_expect(get_tree().paused, "the pause menu did not pause the tree")

	var captions: PackedStringArray = _button_captions(room.pause_menu)
	print("  pause offers: %s" % ", ".join(captions))
	for wanted: String in [
		"Resume", "Restart Current Fight", "Settings", "Reset Lab Progress…", "Quit to Title",
	]:
		_expect(captions.has(wanted), "§21 requires pause to expose '%s'" % wanted)
	# The safe option takes focus.
	_expect(room.pause_menu.last_focus_name == "Resume",
		"pause focused '%s' first, not the non-destructive Resume" % room.pause_menu.last_focus_name)
	_check_surface_is_on_screen(room.pause_menu, "the pause menu")

	# Forty paused frames: nothing may advance.
	var before: Dictionary = {
		"position": player.global_position,
		"enemy": enemy.global_position if have_enemy else Vector3.ZERO,
		"state_time": enemy.state_time if have_enemy else 0.0,
		"simulation": room.attack_coordinator.simulation_time(),
		"handoff": room.attack_coordinator.group_handoff_remaining(),
		"countdown": director.wave_countdown,
		"life": player.life,
		"mana": player.mana,
	}
	for i: int in 40:
		await _step()
	var enemy_moved: float = (
		enemy.global_position.distance_to(before["enemy"] as Vector3) if have_enemy else 0.0
	)
	var enemy_state_time: float = enemy.state_time if have_enemy else 0.0
	print("  40 paused frames: player moved %.6f m, enemy moved %.6f m, enemy state time %.4f -> %.4f%s" % [
		player.global_position.distance_to(before["position"] as Vector3),
		enemy_moved, float(before["state_time"]), enemy_state_time,
		"" if have_enemy else "   (no living Graveblade at this moment)",
	])
	print("  coordinator simulation clock %.4f -> %.4f s; wave countdown %.4f -> %.4f s" % [
		float(before["simulation"]), room.attack_coordinator.simulation_time(),
		float(before["countdown"]), director.wave_countdown,
	])
	_expect(player.global_position.distance_to(before["position"] as Vector3) < 0.0001,
		"the player moved while paused")
	_expect(enemy_moved < 0.0001, "a Graveblade moved while paused")
	_expect(is_equal_approx(enemy_state_time, float(before["state_time"])),
		"a Graveblade's attack phase advanced while paused")
	_expect(is_equal_approx(room.attack_coordinator.simulation_time(), float(before["simulation"])),
		"the coordinator's simulation clock advanced while paused")
	_expect(is_equal_approx(room.attack_coordinator.group_handoff_remaining(), float(before["handoff"])),
		"the D-186 group handoff window was spent while paused")
	_expect(is_equal_approx(director.wave_countdown, float(before["countdown"])),
		"the wave countdown advanced while paused")
	_expect(is_equal_approx(player.mana, float(before["mana"])),
		"Mana regenerated while paused")

	room.pause_menu.close("verification resumed")
	# Judged BEFORE any frame runs. With nothing held, the room's own latch lifts
	# on the very next `_process`, so settling first would only prove that a latch
	# nobody is holding releases — which is not the guarantee. The guarantee that
	# a HELD control keeps it armed is measured in the next check.
	_expect(player.awaiting_neutral, "resuming did not re-arm the neutral-input latch")
	await _settle(2)
	_expect(not get_tree().paused, "closing the pause menu did not resume the world")
	await _release_all_inputs()


# --- 10. Neutral-input doors -------------------------------------------------

func _check_neutral_doors() -> void:
	print("")
	print("--- Every boundary re-arms the neutral-input doors (specification §9.2)")
	await _release_all_inputs()

	# A control already held when a surface opens cannot act on it.
	Input.action_press(&"ui_confirm")
	await _settle(2)
	room.open_pause("held-input probe")
	await _settle(2)
	_expect(room.pause_menu.is_open, "the held-input probe could not open pause")
	print("  ui_confirm held on the way in: armed=%s" % str(room.pause_menu.inputs_are_armed()))
	_expect(not room.pause_menu.inputs_are_armed(),
		"a control held when pause opened was treated as at rest")
	var refused_before: int = room.pause_menu.held_inputs_refused
	room.pause_menu._input(_confirm_event())
	print("  a synthetic confirm from that held control: refusals %d -> %d" % [
		refused_before, room.pause_menu.held_inputs_refused,
	])
	_expect(room.pause_menu.held_inputs_refused > refused_before,
		"the held confirm was accepted by the surface it opened")
	Input.action_release(&"ui_confirm")
	await _settle(2)
	room.pause_menu._input(_release_event(&"ui_confirm"))
	_expect(room.pause_menu.inputs_are_armed(),
		"releasing the held control did not re-arm the surface")
	room.pause_menu.close("probe finished")
	await _release_all_inputs()

	# A held movement control does not resume the character until it is released.
	Input.action_press(&"move_point")
	room.open_pause("held movement probe")
	await _settle(2)
	room.pause_menu.close("probe finished")
	await _settle(4)
	print("  left button still down after resume: awaiting neutral = %s" % str(player.awaiting_neutral))
	_expect(player.awaiting_neutral, "a held movement control resumed the character immediately")
	Input.action_release(&"move_point")
	await _release_all_inputs()
	_expect(not player.awaiting_neutral, "the latch did not lift once the control returned to neutral")


# --- 11. Milestone saves -----------------------------------------------------

func _check_milestone_saves() -> void:
	print("")
	print("--- The lab file is written at milestones only (specification §20.3)")
	await _release_all_inputs()
	# Start clean so the sequence below is the whole sequence.
	room.reset_lab_progress()
	app.reset_lab_progress_in_play()
	await _settle(6)
	_expect(not FileAccess.file_exists(lab_state.storage_path),
		"the lab file survived Reset Lab Progress")

	var saves_before: int = app.state_saves
	for i: int in 30:
		await _step()
	print("  30 ordinary frames with no milestone: %d saves" % (app.state_saves - saves_before))
	_expect(app.state_saves == saves_before,
		"the lab file was written %d times without a milestone" % (app.state_saves - saves_before))

	# 1. The starter kill.
	await _await_living_enemy(5.0)
	await _kill_every_living_graveblade()
	await _settle(6)
	_expect_saved_state("STARTER kill", "UPGRADE_ON_GROUND", 10, "training_sword", false)

	# 2. Equip.
	await _release_all_inputs()
	room.open_item_comparison("verification")
	await _settle(2)
	_press(room.item_comparison, "Equip")
	await _settle(6)
	_expect_saved_state("Equip", "UPGRADED_FIGHT", 10, "honed_sword", false)

	# 3. The upgraded kill.
	await _await_living_enemy(5.0)
	await _kill_every_living_graveblade()
	await _settle(6)
	_expect_saved_state("upgraded kill", "PASSIVE_READY", 20, "honed_sword", false)

	# 4. Quickened Form.
	await _release_all_inputs()
	_press(room.passive_card, "Confirm")
	await _settle(6)
	_expect_saved_state("Quickened Form", "REPEAT_LOOP", 20, "honed_sword", true)

	# The written file holds ONLY the six allowlisted values, read back from disk.
	var written: ConfigFile = ConfigFile.new()
	_expect(written.load(lab_state.storage_path) == OK, "the written lab file could not be read back")
	var keys: PackedStringArray = PackedStringArray()
	for section: String in written.get_sections():
		for key: String in written.get_section_keys(section):
			keys.append("%s/%s" % [section, key])
	keys.sort()
	print("  the file holds exactly: %s" % ", ".join(keys))
	_expect(keys.size() == PrototypeLabState.ALLOWED_KEYS.size(),
		"the lab file holds %d values, not the six on the allowlist" % keys.size())
	for key: String in keys:
		_expect(PrototypeLabState.ALLOWED_KEYS.has(key),
			"the lab file holds '%s', which is not on the Gate F allowlist" % key)

	# D-189: nothing about enemies, positions, Life, Mana, phases, targets, or
	# permissions. Asserted against the BYTES, so a later key cannot slip in.
	var raw: String = FileAccess.get_file_as_string(lab_state.storage_path).to_lower()
	for word: String in PrototypeLabState.FORBIDDEN_WORDS:
		_expect(not raw.contains(word),
			"the lab file mentions '%s'; §20.3 forbids serializing it" % word)
	print("  and mentions none of: %s" % ", ".join(PrototypeLabState.FORBIDDEN_WORDS))

	# A repeat-loop kill is a counter, not a milestone, so it does not write.
	var before_repeat: int = app.state_saves
	await _await_living_enemy(6.0)
	await _kill_every_living_graveblade()
	await _settle(6)
	print("  a repeat-loop kill: %d additional saves" % (app.state_saves - before_repeat))
	_expect(app.state_saves == before_repeat,
		"a repeat-loop kill wrote the lab file %d times" % (app.state_saves - before_repeat))


func _expect_saved_state(
	what: String, milestone: String, experience: int, weapon: String, quickened: bool
) -> void:
	var reloaded: PrototypeLabState = _lab_probe()
	reloaded.load_from_disk()
	print("  after %-16s -> %s" % [what, reloaded.describe()])
	_expect(reloaded.exists and reloaded.valid, "%s did not write a valid lab file" % what)
	_expect(reloaded.milestone == milestone,
		"%s saved milestone '%s', expected '%s'" % [what, reloaded.milestone, milestone])
	_expect(reloaded.experience == experience,
		"%s saved %d XP, expected %d" % [what, reloaded.experience, experience])
	_expect(String(reloaded.equipped_weapon_id) == weapon,
		"%s saved weapon '%s', expected '%s'" % [what, reloaded.equipped_weapon_id, weapon])
	_expect(reloaded.quickened_form == quickened,
		"%s saved Quickened Form %s" % [what, str(reloaded.quickened_form)])


# --- 12. Fallen --------------------------------------------------------------

func _check_fallen() -> void:
	print("")
	print("--- Fallen (specification §20.1)")
	await _release_all_inputs()
	await _await_living_enemy(6.0)
	var enemy: PrototypeGraveblade = room.graveblade

	# A control HELD through death must not act afterwards.
	Input.action_press(&"quick_strike")
	Input.action_press(&"move_point")
	player.command_move_to(Vector3(4.0, 0.0, 0.0), Vector3(4.0, 0.0, 0.0), false)
	await _settle(2)

	var lethal: DamageEvent = DamageEvent.physical(
		9901, enemy, player, enemy.data.physical_damage
	)
	player.life = enemy.data.physical_damage
	player.receive_damage(lethal)
	await _settle(2)

	# Everything §20.1 requires on the LETHAL FRAME, before the surface exists.
	print("  on the lethal frame: alive=%s, destination=%s, attack=%s, buffered=%s, permission holder=%s" % [
		str(player.is_alive()), str(player.has_destination), action.phase_name(),
		str(action.buffered), str(room.attack_coordinator.holder()),
	])
	_expect(not player.is_alive(), "the player is still alive after a lethal Hit")
	_expect(not player.has_destination, "a navigation destination survived death")
	_expect(action.phase == QuickStrikeAction.Phase.READY, "an attack phase survived death")
	_expect(not action.buffered, "a buffered attack survived death")
	_expect(action.target == null, "an attack target survived death")
	_expect(room.attack_coordinator.holder() == null, "an enemy still holds attack permission")
	_expect(player.awaiting_neutral, "death did not arm the neutral-input latch")
	var suspended: int = 0
	for other: PrototypeGraveblade in room.graveblades:
		if is_instance_valid(other) and not other.ai_enabled:
			suspended += 1
	print("  offline combat paused: %d of %d Graveblades suspended" % [suspended, room.graveblades.size()])
	_expect(suspended == room.graveblades.size(), "a Graveblade kept chasing a dead player")

	# Damage eligibility is gone: a second lethal event changes nothing.
	var life_after: float = player.life
	player.receive_damage(DamageEvent.physical(9902, enemy, player, 999.0))
	_expect(is_equal_approx(player.life, life_after), "a dead player took more damage")

	# §20.1: the death response plays FIRST, then Fallen fades in.
	_expect(not room.fallen_overlay.is_open,
		"Fallen appeared on the lethal frame, over the death response")
	await _wait_seconds(PrototypeZeroRoom.FALLEN_DELAY + 0.15)
	print("  Fallen opened %.2f s after the fall, faded in over %.2f s" % [
		PrototypeZeroRoom.FALLEN_DELAY, PrototypeFallenOverlay.FADE_SECONDS,
	])
	_expect(room.fallen_overlay.is_open, "Fallen never appeared")
	_expect(get_tree().paused, "Fallen did not pause the world")

	# THE KILLING SOURCE, exactly as §20.1 prints it, and built from the event.
	print("  killing source: \"%s\"" % room.fallen_overlay.killing_source)
	_expect(room.fallen_overlay.killing_source == "Graveblade — Melee Hit — 125 Physical Damage",
		"the killing source reads \"%s\"" % room.fallen_overlay.killing_source)
	_check_surface_is_on_screen(room.fallen_overlay, "the Fallen overlay")
	var on_screen: String = _visible_text_in(room.fallen_overlay)
	_expect(on_screen.contains("Fallen"), "the Fallen surface does not say Fallen")
	_expect(on_screen.contains(room.fallen_overlay.killing_source),
		"the killing source is not on the Fallen surface")
	# Built from the event, not written down: a different number changes the line.
	var other_line: String = PrototypeFallenOverlay.describe_killing_source(
		DamageEvent.physical(1, enemy, player, 999.0)
	)
	print("  the same line for a 999-damage event: \"%s\"" % other_line)
	_expect(other_line.contains("999"), "the killing source ignores the event's damage")

	# Neutral, non-destructive focus first; Restart plainly reachable.
	print("  default focus: %s" % room.fallen_overlay.last_focus_name)
	_expect(room.fallen_overlay.last_focus_name == "Review Death",
		"Fallen focused '%s' first, not a neutral non-destructive element" % room.fallen_overlay.last_focus_name)
	var captions: PackedStringArray = _button_captions(room.fallen_overlay)
	_expect(captions.has("Restart Current Fight"), "Fallen does not offer Restart")
	_expect(not room.fallen_overlay.was_reviewed(), "Review Death ran without being pressed")

	# An action HELD through death is refused by the surface it lands on.
	print("  quick_strike and move_point were held through the fall: armed=%s" % str(
		room.fallen_overlay.inputs_are_armed()
	))
	_expect(not room.fallen_overlay.inputs_are_armed(),
		"controls held through death were treated as at rest by Fallen")
	var refused_before: int = room.fallen_overlay.held_inputs_refused
	room.fallen_overlay._input(_confirm_event())
	_expect(room.fallen_overlay.held_inputs_refused >= refused_before,
		"Fallen accepted an action from a control held through death")

	# §20.1 has no Anchors, no Recovery Cache, and no run rewards.
	for forbidden: String in ["Anchor", "Recovery", "Reward", "Seal", "Pursuit"]:
		_expect(not on_screen.contains(forbidden), "Fallen mentions '%s'" % forbidden)
	# And it does not close on cancel: there is nothing behind it.
	_expect(not room.fallen_overlay.cancel_closes(), "Escape dismisses Fallen")


# --- 13. Restart -------------------------------------------------------------

func _check_restart() -> void:
	print("")
	print("--- Restart Current Fight (specification §20.2)")
	var stage_before: LabProgress.Stage = progress.stage
	var xp_before: int = progress.experience
	var weapon_before: PrototypeWeaponData = player.weapon
	var passive_before: bool = progress.quickened_form_active
	var kills_before: int = progress.repeat_loop_kills
	var wave_size: int = director.current_wave_size

	# The latch is judged while a control is STILL HELD, which is the case §20.2
	# is about: an input held through death must not act on the rebuilt fight.
	# Releasing first and then checking would only prove that a latch nobody is
	# holding lifts, which is not the guarantee.
	Input.action_release(&"quick_strike")
	room.restart_current_fight("verification")
	await _settle(8)
	print("  left button still held across the Restart: awaiting neutral = %s" % str(player.awaiting_neutral))
	_expect(player.awaiting_neutral,
		"a control held through death and Restart was obeyed on the rebuilt fight")
	Input.action_release(&"move_point")
	await _settle(6)

	print("  Life %.0f / %.0f, Mana %.0f / %.0f, %s, wave of %d rebuilt, XP %d" % [
		player.life, player.max_life, player.mana, player.max_mana,
		progress.stage_name(), room.living_graveblade_count(), progress.experience,
	])
	_expect(player.is_alive(), "Restart did not revive the player")
	_expect(is_equal_approx(player.life, player.max_life), "Restart did not restore full Life")
	_expect(is_equal_approx(player.mana, player.max_mana), "Restart did not restore full Mana")
	_expect(not room.fallen_overlay.is_open, "Fallen survived the Restart")
	_expect(not get_tree().paused, "the world is still paused after Restart")
	_expect(progress.stage == stage_before, "Restart moved the laboratory to another stage")
	_expect(progress.experience == xp_before,
		"Restart changed XP from %d to %d" % [xp_before, progress.experience])
	_expect(player.weapon == weapon_before, "Restart changed the equipped weapon")
	_expect(progress.quickened_form_active == passive_before, "Restart changed the passive")
	_expect(progress.repeat_loop_kills == kills_before, "Restart changed the repeat-loop kill count")
	_expect(room.living_graveblade_count() == wave_size,
		"Restart rebuilt %d Graveblades, not the %d of the current wave" % [
			room.living_graveblade_count(), wave_size,
		])
	for enemy: PrototypeGraveblade in room.graveblades:
		if is_instance_valid(enemy):
			_expect(is_equal_approx(enemy.life, enemy.data.max_life),
				"a rebuilt Graveblade is not at full Life")
			_expect(enemy.ai_enabled, "a rebuilt Graveblade is still suspended from the fall")
	_expect(not player.awaiting_neutral,
		"the latch did not lift once every control returned to neutral after Restart")

	# NO REWARD DUPLICATION. The four latches are exactly where they were.
	print("  milestones after Restart: %s" % progress.describe())
	_expect(progress.experience <= 20, "Restart pushed XP past the maximum")
	var saves_before: int = app.state_saves
	room.restart_current_fight("verification, again")
	await _settle(8)
	_expect(progress.experience == xp_before, "a second Restart changed XP")
	_expect(app.state_saves == saves_before, "Restart wrote the lab file; it is not a milestone")
	await _release_all_inputs()


# --- 14. Continue at every milestone -----------------------------------------

func _check_continue_at_every_milestone() -> void:
	print("")
	print("--- Continue reconstructs every milestone without duplicating (specification §20.3)")
	for row: Array in [
		["STARTER_FIGHT", 0, "training_sword", false, 0],
		["UPGRADE_ON_GROUND", 10, "training_sword", false, 0],
		["UPGRADED_FIGHT", 10, "honed_sword", false, 0],
		["PASSIVE_READY", 20, "honed_sword", false, 0],
		["REPEAT_LOOP", 20, "honed_sword", true, 4],
	]:
		await _continue_into(String(row[0]), int(row[1]), String(row[2]), bool(row[3]), int(row[4]))


func _continue_into(
	milestone: String, experience: int, weapon: String, quickened: bool, repeat_kills: int
) -> void:
	app.quit_to_title("verification")
	await _settle(4)
	var written: PrototypeLabState = _lab_probe()
	written.milestone = milestone
	written.experience = experience
	written.equipped_weapon_id = StringName(weapon)
	written.quickened_form = quickened
	written.repeat_loop_kills = repeat_kills
	written.save_to_disk()
	lab_state.load_from_disk()
	app.title.refresh()
	_expect(lab_state.valid, "the authored %s state was rejected: %s" % [milestone, lab_state.problem])
	_expect(not _button_named(app.title, "ContinueLab").disabled,
		"Continue Lab is disabled with a valid %s state" % milestone)

	app.continue_lab()
	await _await_room()
	await _settle(6)
	print("  %-18s -> %s, XP %d, %s%s, %d repeat kills, %d duplicate attempts refused" % [
		milestone, progress.stage_name(), progress.experience, player.weapon.display_name,
		", Quickened Form" if progress.quickened_form_active else "",
		progress.repeat_loop_kills, progress.duplicate_attempts_refused,
	])
	_expect(progress.stage_name() == milestone,
		"Continue into %s reconstructed %s" % [milestone, progress.stage_name()])
	_expect(progress.experience == experience,
		"Continue into %s produced %d XP, not %d" % [milestone, progress.experience, experience])
	_expect(String(player.weapon.weapon_id) == weapon,
		"Continue into %s equipped '%s', not '%s'" % [milestone, player.weapon.weapon_id, weapon])
	_expect(progress.quickened_form_active == quickened,
		"Continue into %s produced the wrong passive state" % milestone)
	_expect(progress.repeat_loop_kills == repeat_kills,
		"Continue into %s restored %d repeat kills, not %d" % [
			milestone, progress.repeat_loop_kills, repeat_kills,
		])

	# NO DUPLICATION: continuing again into the same record changes nothing.
	var opened_again: PackedStringArray = lab_state.reconstruct_into(progress)
	_expect(opened_again.is_empty() or progress.experience == experience,
		"a second reconstruction changed the record")
	_expect(progress.experience == experience,
		"a second reconstruction pushed XP to %d" % progress.experience)

	# The stage's own start condition is rebuilt, not merely its label.
	match milestone:
		"UPGRADE_ON_GROUND":
			_expect(director.drop() != null, "UPGRADE_ON_GROUND was continued without the sword on the ground")
			_expect(room.living_graveblade_count() == 0, "UPGRADE_ON_GROUND was continued with an enemy present")
		"STARTER_FIGHT", "UPGRADED_FIGHT":
			await _await_living_enemy(4.0)
			_expect(room.living_graveblade_count() == 1, "%s was continued without its Graveblade" % milestone)
		"PASSIVE_READY":
			_expect(room.passive_card.is_open, "PASSIVE_READY was continued without the passive card")
			room.passive_card.close("verification")
			await _settle(2)
		"REPEAT_LOOP":
			_expect(director.wave_countdown > 0.0 or room.living_graveblade_count() > 0,
				"REPEAT_LOOP was continued with no wave pending")
	await _release_all_inputs()


# --- 15. Invalid file recovery -----------------------------------------------

func _check_invalid_file_recovery() -> void:
	print("")
	print("--- An invalid lab file is refused truthfully (specification §20.3)")
	app.quit_to_title("verification")
	await _settle(4)

	# Four different ways for the file to be wrong, and every one of them must
	# produce a refusal that NAMES the fault rather than a silent repair.
	var cases: Array[Dictionary] = [
		{"what": "unparseable bytes", "raw": "this is not a config file [[[ ]]] = = ="},
		{"what": "another schema", "config": {"meta/schema_version": 99}},
		{"what": "an unknown milestone", "config": {
			"meta/schema_version": PrototypeLabState.SCHEMA_VERSION,
			"lab/milestone": "THE_CROWNLESS_WARDEN", "lab/experience": 10,
			"lab/equipped_weapon_id": "training_sword", "lab/quickened_form": false,
			"lab/repeat_loop_kills": 0,
		}},
		{"what": "a state the loop cannot reach", "config": {
			"meta/schema_version": PrototypeLabState.SCHEMA_VERSION,
			"lab/milestone": "STARTER_FIGHT", "lab/experience": 20,
			"lab/equipped_weapon_id": "honed_sword", "lab/quickened_form": true,
			"lab/repeat_loop_kills": 99,
		}},
	]
	for case: Dictionary in cases:
		if case.has("raw"):
			var file: FileAccess = FileAccess.open(lab_state.storage_path, FileAccess.WRITE)
			file.store_string(String(case["raw"]))
			file.close()
		else:
			var config: ConfigFile = ConfigFile.new()
			for key: String in (case["config"] as Dictionary):
				var parts: PackedStringArray = key.split("/")
				config.set_value(parts[0], parts[1], (case["config"] as Dictionary)[key])
			config.save(lab_state.storage_path)
		lab_state.load_from_disk()
		app.title.refresh()
		print("  %-28s -> %s" % [String(case["what"]), lab_state.problem])
		_expect(lab_state.exists, "%s: the file was not even seen" % case["what"])
		_expect(not lab_state.valid, "%s was accepted as a valid laboratory" % case["what"])
		_expect(not lab_state.problem.is_empty(), "%s produced no truthful message" % case["what"])
		_expect(_button_named(app.title, "ContinueLab").disabled,
			"%s left Continue Lab enabled" % case["what"])
		var notice: String = _visible_text_in(app.title)
		_expect(notice.contains("Reset Lab Progress"),
			"%s did not offer Reset Lab Progress" % case["what"])
		# And Continue refuses even when called directly.
		var before_continues: int = app.lab_continues
		app.continue_lab()
		await _settle(2)
		_expect(app.lab_continues == before_continues and app.room == null,
			"%s was continued anyway" % case["what"])


# --- 16. Reset keeps settings ------------------------------------------------

func _check_reset_keeps_settings() -> void:
	print("")
	print("--- Reset Lab Progress does not erase comfort settings (specification §20.3)")
	settings.set_damage_numbers(false)
	settings.set_screen_shake(PrototypeSettings.Level.REDUCED)
	settings.set_master_volume(0.42)
	settings.save_to_disk()
	var fingerprint: String = settings.describe()

	app.reset_lab_progress_from_title()
	lab_state.load_from_disk()
	await _settle(2)
	var after: PrototypeSettings = _settings_probe()
	after.load_from_disk()
	print("  before: %s" % fingerprint)
	print("  after:  %s" % after.describe())
	_expect(not FileAccess.file_exists(lab_state.storage_path),
		"Reset Lab Progress left the lab file on disk")
	_expect(FileAccess.file_exists(settings.storage_path),
		"Reset Lab Progress deleted the settings file")
	_expect(after.describe() == fingerprint, "Reset Lab Progress changed a comfort setting")
	_expect(not after.damage_numbers and after.screen_shake == PrototypeSettings.Level.REDUCED,
		"the comfort settings did not survive Reset Lab Progress")
	_expect(is_equal_approx(after.master_volume, 0.42), "master volume did not survive Reset Lab Progress")
	settings.restore_defaults(false)
	settings.save_to_disk()
	audio.apply_master_volume(settings.master_volume)


# --- 17. Display Keep / Revert -----------------------------------------------

func _check_display_keep_revert() -> void:
	print("")
	print("--- Display changes are protected by a timed Keep / Revert (specification §4.3)")
	print("  windowing system: %s" % ("present" if display.has_window() else "headless (the change is recorded, not shown)"))
	settings.restore_defaults(false)
	settings.save_to_disk()

	# 1. A change opens the confirmation, and the marker is on disk BEFORE the
	#    change is applied, so a process that dies now is still protected.
	var changed: bool = display.request_change(PrototypeSettings.WindowMode.WINDOWED, 3)
	_expect(changed, "a real display change was refused")
	_expect(display.pending, "the display change did not open a confirmation")
	_expect(is_equal_approx(display.seconds_left, PrototypeDisplayManager.CONFIRM_SECONDS),
		"the confirmation did not start at %.0f s" % PrototypeDisplayManager.CONFIRM_SECONDS)
	var on_disk: PrototypeSettings = _settings_probe()
	on_disk.load_from_disk()
	print("  applied %s, marker on disk = %s, safe fallback = %s %d" % [
		settings.resolution_name(), str(on_disk.display_attempt_pending),
		on_disk.window_mode_name(), PrototypeSettings.SAFE_RESOLUTIONS[on_disk.safe_resolution_index].x,
	])
	_expect(on_disk.display_attempt_pending,
		"the unconfirmed display attempt was not written to disk before it was applied")
	_expect(on_disk.safe_resolution_index == 0,
		"the safe fallback recorded on disk is not the resolution that was known good")
	_expect(app.display_prompt.is_open, "the timed confirmation surface did not appear")

	# 2. Letting it time out reverts.
	display.advance_for_verification(PrototypeDisplayManager.CONFIRM_SECONDS + 0.1)
	print("  timed out: %s" % display.last_status)
	_expect(not display.pending, "the confirmation is still open after the countdown")
	_expect(display.timeouts == 1, "the timeout was not recorded")
	_expect(settings.resolution_index == 0, "the timeout did not revert the resolution")
	on_disk.load_from_disk()
	_expect(not on_disk.display_attempt_pending, "the marker survived the revert")

	# 3. Rejecting it explicitly reverts.
	display.request_change(PrototypeSettings.WindowMode.WINDOWED, 2)
	display.revert("verification rejected it")
	print("  rejected: %s" % display.last_status)
	_expect(settings.resolution_index == 0, "an explicit Revert did not restore the resolution")
	_expect(display.changes_reverted == 2, "the explicit revert was not recorded")

	# 4. Keeping it persists, and clears the marker.
	display.request_change(PrototypeSettings.WindowMode.WINDOWED, 1)
	display.keep()
	on_disk.load_from_disk()
	print("  kept: %s, marker = %s" % [settings.resolution_name(), str(on_disk.display_attempt_pending)])
	_expect(settings.resolution_index == 1, "Keep did not persist the new resolution")
	_expect(on_disk.resolution_index == 1, "Keep did not write the new resolution to disk")
	_expect(not on_disk.display_attempt_pending, "Keep left the attempt marker set")
	_expect(on_disk.safe_resolution_index == 1, "Keep did not adopt the new resolution as the safe one")

	# The prompt's default answer is the safe one.
	_expect(not app.display_prompt.is_open, "the confirmation surface is still on screen")

	# Every offered resolution is safe: at or above 1280 x 720 and at or below
	# the 1920 x 1080 logical UI reference (specification §4.3).
	for size: Vector2i in PrototypeSettings.SAFE_RESOLUTIONS:
		_expect(size.x >= 1280 and size.y >= 720,
			"%d x %d is below the minimum tested window" % [size.x, size.y])
		_expect(size.x <= 1920 and size.y <= 1080,
			"%d x %d is above the logical UI reference" % [size.x, size.y])
	settings.restore_defaults(false)
	settings.save_to_disk()


func _check_display_startup_recovery() -> void:
	print("")
	print("--- A display change that was never answered cannot survive a restart")
	# Exactly the state a force-quit or a crash mid-confirmation leaves behind.
	settings.window_mode = PrototypeSettings.WindowMode.FULLSCREEN
	settings.resolution_index = 3
	settings.display_attempt_pending = true
	settings.safe_window_mode = PrototypeSettings.WindowMode.WINDOWED
	settings.safe_resolution_index = 0
	settings.save_to_disk()

	var recovered: PrototypeSettings = _settings_probe()
	recovered.load_from_disk()
	var manager: PrototypeDisplayManager = PrototypeDisplayManager.new()
	add_child(manager)
	manager.bind(recovered, Callable())
	var message: String = manager.apply_on_startup()
	print("  %s" % message)
	_expect(not message.is_empty(), "an unconfirmed display attempt produced no recovery message")
	_expect(recovered.window_mode == PrototypeSettings.WindowMode.WINDOWED,
		"the unconfirmed fullscreen attempt survived the restart")
	_expect(recovered.resolution_index == 0,
		"the unconfirmed resolution survived the restart")
	_expect(not recovered.display_attempt_pending, "the marker was not cleared on recovery")
	_expect(manager.startup_recoveries == 1, "the startup recovery was not recorded")

	# A clean start says nothing and changes nothing.
	var clean: PrototypeSettings = _settings_probe()
	clean.load_from_disk()
	var quiet: String = manager.apply_on_startup()
	print("  a clean start says: \"%s\"" % quiet)
	_expect(quiet.is_empty(), "a clean start produced a recovery message")
	# Freed immediately rather than queued: the suite may quit before the next
	# frame flushes the queue, and a probe left in the tree at exit is reported as
	# a leak that has nothing to do with the code under test.
	remove_child(manager)
	manager.free()
	settings.restore_defaults(false)
	settings.save_to_disk()


# --- 17a. Aim assistance never compounds (D-191) -----------------------------

## §21 requires an aim-assistance setting defaulting to 70 / 100, and Prototype
## Zero has exactly one piece of assistance to attach it to: the D-178 controller
## soft-target cone and its acquisition distance. Gate F scaled those two numbers
## IN PLACE on `data/prototype_zero/quick_strike.tres` — and Godot's resource
## cache hands every laboratory in a process the same object, so the write went
## through to the canonical record and the next room scaled the already-scaled
## numbers again:
##
##   assistance 100:  first room 78.0 deg / 6.00 m,  next room 93.6 deg / 7.20 m
##   assistance   0:  first room 39.0 deg / 3.00 m,  next room 23.4 deg / 1.80 m
##
## The default hid it completely, because 70 / 100 scales by exactly 1.000.
##
## The action now owns a private runtime copy and the scaling recomputes from the
## canonical record every time. This section proves all of that by measurement.
func _check_aim_assistance() -> void:
	print("")
	print("--- §21 aim assistance recomputes from the canonical record (D-191)")
	# The previous section left the app on the title screen with no room, so the
	# laboratory is rebuilt before anything reaches into it.
	app.quit_to_title("aim assistance")
	await _settle(4)
	app.start_new_lab()
	await _await_room()
	await _settle(4)
	await _release_all_inputs()

	# 1. The action obeys a PRIVATE record and keeps the canonical one read-only.
	print("  runtime record  %d  path '%s'" % [
		action.data.get_instance_id(), action.data.resource_path,
	])
	print("  canonical record %d  path '%s'" % [
		action.canonical_data.get_instance_id(), action.canonical_data.resource_path,
	])
	_expect(action.canonical_data != null, "the Quick Strike action kept no canonical record")
	_expect(action.data_is_private(), "the Quick Strike action is still obeying the shared canonical record")
	_expect(action.data != action.canonical_data,
		"the runtime record and the canonical record are the same object")
	_expect(action.data.resource_path.is_empty(),
		"the runtime copy still carries the canonical file's resource path")
	_expect(action.canonical_data.resource_path == CANONICAL_QUICK_STRIKE,
		"the canonical record is not %s" % CANONICAL_QUICK_STRIKE)

	# 2. THE HAZARD IS REAL, and this states it rather than assuming it: the
	#    object the action kept is the very object Godot's cache hands anyone who
	#    loads that file. Writing to it would have been writing to the canon.
	var cached: QuickStrikeData = load(CANONICAL_QUICK_STRIKE) as QuickStrikeData
	_expect(cached.get_instance_id() == action.canonical_data.get_instance_id(),
		"the cached resource is not the record the action kept; the isolation claim is untested")

	# 3. The canonical record still holds the authored, D-178-accepted numbers.
	for row: Array in [
		["the record the action kept", action.canonical_data],
		["a fresh read from disk", ResourceLoader.load(
			CANONICAL_QUICK_STRIKE, "QuickStrikeData", ResourceLoader.CACHE_MODE_IGNORE
		)],
	]:
		var record: QuickStrikeData = row[1] as QuickStrikeData
		print("  canonical, %-24s %8.4f deg total, %.4f m" % [
			String(row[0]), record.soft_target_cone_degrees, record.soft_target_distance,
		])
		_expect(record.soft_target_cone_degrees == 65.0,
			"%s: the canonical cone is %.4f, not 65.0" % [String(row[0]), record.soft_target_cone_degrees])
		_expect(record.soft_target_distance == 5.0,
			"%s: the canonical acquisition distance is %.4f, not 5.0" % [
				String(row[0]), record.soft_target_distance,
			])

	# 4. The three named values, and the default bit for bit.
	for value: int in [0, 70, 100]:
		await _set_assistance(value)
		_expect_assist(value, "first setting")

	# 5. Repeated changes in ONE room always recalculate from 65.0 / 5.0 — this
	#    is the sequence the in-place scaling could not survive.
	for round_index: int in 3:
		for value: int in [0, 100, 70]:
			await _set_assistance(value)
			_expect_assist(value, "cycle %d" % (round_index + 1))

	# 6. Room replacements. Start New Lab three consecutive times, then Continue,
	#    then Restart, all at assistance 100 — the value whose defect was largest.
	await _set_assistance(100)
	for pass_index: int in 3:
		app.quit_to_title("aim assistance replacement %d" % (pass_index + 1))
		await _settle(4)
		app.start_new_lab()
		await _await_room()
		await _settle(4)
		_expect_assist(100, "Start New Lab, replacement %d" % (pass_index + 1))

	app.quit_to_title("aim assistance continue")
	await _settle(4)
	var written: PrototypeLabState = _lab_probe()
	written.milestone = "UPGRADED_FIGHT"
	written.experience = 10
	written.equipped_weapon_id = PrototypeLabState.HONED_ID
	written.quickened_form = false
	written.repeat_loop_kills = 0
	written.save_to_disk()
	lab_state.load_from_disk()
	app.title.refresh()
	app.continue_lab()
	await _await_room()
	await _settle(4)
	_expect_assist(100, "Continue Lab")

	room.restart_current_fight("aim assistance")
	await _settle(8)
	_expect_assist(100, "Restart Current Fight")

	# And 0 after all of that is still 39.0 / 3.00, not 23.4 / 1.80.
	await _set_assistance(0)
	_expect_assist(0, "after the whole journey")

	# 7. The canonical record is untouched by every one of those changes.
	for row: Array in [
		["the record the action kept", action.canonical_data],
		["a fresh read from disk", ResourceLoader.load(
			CANONICAL_QUICK_STRIKE, "QuickStrikeData", ResourceLoader.CACHE_MODE_IGNORE
		)],
	]:
		var record: QuickStrikeData = row[1] as QuickStrikeData
		print("  canonical, %-24s %8.4f deg total, %.4f m" % [
			String(row[0]), record.soft_target_cone_degrees, record.soft_target_distance,
		])
		_expect(record.soft_target_cone_degrees == 65.0,
			"%s: the canonical cone is %.4f, not 65.0" % [String(row[0]), record.soft_target_cone_degrees])
		_expect(record.soft_target_distance == 5.0,
			"%s: the canonical acquisition distance is %.4f, not 5.0" % [
				String(row[0]), record.soft_target_distance,
			])

	# 8. Two separately instantiated players cannot reach each other's numbers.
	var holder: Node3D = Node3D.new()
	holder.name = "SeparatePlayers"
	# Disabled, so the two probes enter the tree — which is what gives each of
	# them its private record — without running a physics frame of their own.
	holder.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(holder)
	var scene: PackedScene = load("res://scenes/actors/prototype_player.tscn") as PackedScene
	var first: PrototypePlayer = scene.instantiate() as PrototypePlayer
	var second: PrototypePlayer = scene.instantiate() as PrototypePlayer
	first.name = "ProbePlayerA"
	second.name = "ProbePlayerB"
	holder.add_child(first)
	holder.add_child(second)
	print("  two separately instantiated players: records %d and %d, canonical %d" % [
		first.attack.data.get_instance_id(), second.attack.data.get_instance_id(),
		first.attack.canonical_data.get_instance_id(),
	])
	_expect(first.attack.data != second.attack.data,
		"two separately instantiated players share one Quick Strike record")
	_expect(first.attack.data != action.data,
		"a freshly instantiated player shares the laboratory player's record")
	_expect(first.attack.canonical_data == second.attack.canonical_data,
		"the two probes did not resolve the same canonical record")
	first.attack.data.soft_target_cone_degrees = 12.0
	first.attack.data.soft_target_distance = 1.0
	_expect(second.attack.data.soft_target_cone_degrees == 65.0,
		"writing to one player's record moved another player's cone to %.4f" % (
			second.attack.data.soft_target_cone_degrees
		))
	_expect(second.attack.data.soft_target_distance == 5.0,
		"writing to one player's record moved another player's acquisition distance")
	_expect(action.canonical_data.soft_target_cone_degrees == 65.0,
		"writing to one player's record moved the canonical cone")
	holder.remove_child(first)
	holder.remove_child(second)
	first.free()
	second.free()
	remove_child(holder)
	holder.free()

	# 9. The MOUSE is untouched by the setting, and the controller is not — so
	#    "the mouse is unaffected" is a measurement rather than a vacuous truth.
	await _check_mouse_is_unassisted()

	await _set_assistance(70)
	_expect_assist(70, "restored to the §21 default")


## Sets the setting through the ordinary store, so the app pushes it into the
## room exactly as the settings panel does.
func _set_assistance(value: int) -> void:
	settings.set_aim_assistance(value)
	await _settle(2)


const _ASSIST_EXPECTED: Dictionary = {
	0: [39.0, 3.0],
	70: [65.0, 5.0],
	100: [78.0, 6.0],
}


func _expect_assist(value: int, note: String) -> void:
	var wanted: Array = _ASSIST_EXPECTED[value]
	var cone: float = float(wanted[0])
	var distance: float = float(wanted[1])
	var live: QuickStrikeData = action.data
	print("  assistance %3d -> %8.4f deg total (+/-%.4f), %.4f m   %s" % [
		value, live.soft_target_cone_degrees, live.soft_target_cone_half_degrees(),
		live.soft_target_distance, note,
	])
	_expect(absf(live.soft_target_cone_degrees - cone) < 0.000000001,
		"assistance %d produced a %.4f deg cone, not %.1f (%s)" % [
			value, live.soft_target_cone_degrees, cone, note,
		])
	_expect(absf(live.soft_target_distance - distance) < 0.000000001,
		"assistance %d produced a %.4f m acquisition distance, not %.1f (%s)" % [
			value, live.soft_target_distance, distance, note,
		])
	if value == 70:
		# D-178's accepted numbers must come back BIT FOR BIT at the default, not
		# approximately, which is why the curve is built to meet 1.000 exactly.
		_expect(live.soft_target_cone_degrees == 65.0,
			"the default aim assistance does not restore 65.0 exactly (%s)" % note)
		_expect(live.soft_target_distance == 5.0,
			"the default aim assistance does not restore 5.0 m exactly (%s)" % note)
		_expect(live.soft_target_cone_half_degrees() == 32.5,
			"the default aim assistance does not restore the +/-32.50 deg half-angle (%s)" % note)


## The mouse has no cone, no acquisition distance, and no aim assistance at all.
## Measured against a practice post the CONTROLLER refuses at assistance 0 and
## accepts at 70 and 100, so the mouse result being identical means something.
func _check_mouse_is_unassisted() -> void:
	# Park every Graveblade far away so the geometry under test is the posts.
	await _await_living_enemy(6.0)
	for enemy: PrototypeGraveblade in room.graveblades:
		if is_instance_valid(enemy):
			enemy.set_ai_enabled(false)
			enemy.place_at(Vector3(8.0, 0.0, -6.0))
	await _teleport(Vector3.ZERO)
	player.face_instantly(Vector3(0.0, 0.0, 1.0))
	await _settle(2)

	# Practice Post C sits at (0, 0, 4.2): dead ahead, 4.20 m away. It is inside
	# the 5.0 m default acquisition distance and outside the 3.0 m one.
	var post: PrototypeTargetable = null
	for fixture: PrototypeTargetFixture in room.fixtures:
		if fixture.fixture_name == "Practice Post C":
			post = fixture
	_expect(post != null, "Practice Post C is missing; the mouse comparison has no subject")
	if post == null:
		return
	var distance: float = post.global_position.distance_to(player.global_position)
	print("  Practice Post C is %.2f m dead ahead" % distance)

	room.set_cursor_override(room.camera_rig.camera.unproject_position(post.targeting_point()))
	for value: int in [0, 70, 100]:
		await _set_assistance(value)

		room.input_family.family = InputFamilyTracker.Family.MOUSE_KEYBOARD
		var mouse: Dictionary = room.resolve_quick_strike_aim()
		var mouse_target: PrototypeTargetable = mouse.get("target", null) as PrototypeTargetable

		# The stick stays NEUTRAL so §11.2's "current facing supplies intended
		# direction" branch runs: the camera yaw is 45 degrees, so a stick
		# direction would put the intended direction 45 degrees off the post and
		# the comparison would be measuring the camera rather than the setting.
		room.input_family.family = InputFamilyTracker.Family.CONTROLLER
		room.set_stick_override(null)
		player.face_instantly(Vector3(0.0, 0.0, 1.0))
		# Let the 0.35 s retention window lapse first, so the controller's answer
		# is a fresh acquisition under the current setting rather than a target
		# kept from the mouse query a moment earlier.
		var guard: int = 0
		while room.soft_target_retention_remaining() > 0.0 and guard < 150:
			await _step()
			guard += 1
		await _settle(2)
		var pad: Dictionary = room.resolve_quick_strike_aim()
		var pad_target: PrototypeTargetable = pad.get("target", null) as PrototypeTargetable

		print("  assistance %3d -> mouse picks %-8s | controller picks %-8s (%s)" % [
			value,
			"Post C" if mouse_target == post else str(mouse_target),
			"Post C" if pad_target == post else ("nothing" if pad_target == null else str(pad_target)),
			String(pad.get("reason", "")),
		])
		_expect(mouse_target == post,
			"assistance %d changed what the cursor picks; the mouse has no assistance" % value)
		_expect(String(mouse.get("group", "")) == "cursor",
			"the mouse answer at assistance %d did not come from the cursor path" % value)
		if value == 0:
			_expect(pad_target == null,
				"assistance 0 should narrow the controller past a 4.20 m post, and did not")
		else:
			_expect(pad_target == post,
				"assistance %d should let the controller reach a 4.20 m post, and did not" % value)

	room.set_cursor_override(null)
	room.input_family.family = InputFamilyTracker.Family.MOUSE_KEYBOARD
	await _settle(2)


# --- 18. Scope ---------------------------------------------------------------

func _check_scope() -> void:
	print("")
	print("--- Scope: Gate F did not start Gate G or any first-MVP system")
	app.start_new_lab()
	await _await_room()
	await _settle(4)

	for forbidden: String in [
		"inventory", "equipment", "slots", "field_pack", "stash", "vault", "rarity",
		"affix", "prefix", "suffix", "tier", "item_level", "craft", "forge",
		"passive_web", "passive_points", "notable", "keystone", "attributes",
		"strength", "dexterity", "intelligence", "armour", "armor", "evasion",
		"block", "resistance", "mana_guard", "ailment", "critical",
	]:
		_expect(not (forbidden in room), "the room has a '%s' member; that is first-MVP" % forbidden)
		_expect(not (forbidden in player), "the player has a '%s' member; that is first-MVP" % forbidden)
		_expect(not (forbidden in app), "the app has a '%s' member; that is first-MVP" % forbidden)
	print("  no inventory, equipment slot, rarity, affix, crafting, Passive Web, attribute, or defence")

	# Gate G is the EXIT REVIEW and nothing in the BUILD may pretend to be it.
	# D-193 authorizes Gate G, so the exit report now exists by authorization; the
	# four member checks below are unaffected, because Gate G is a documentation
	# review and adds no code. The file-absence assertion is replaced ONE FOR ONE
	# with the boundary that still holds: first-MVP production has not begun.
	for forbidden: String in ["exit_review", "test_report", "gate_g", "sign_off"]:
		_expect(not (forbidden in app), "the app has a '%s' member; Gate G adds no code" % forbidden)
	_expect(not FileAccess.file_exists("res://../docs/testing/FIRST_MVP_VERTICAL_SLICE_REPORT.md"),
		"a first-MVP vertical-slice report exists; first-MVP production is not authorized")
	print("  Gate G adds no code, and first-MVP production has not begun")

	# The two files are still exactly two, and the state one is still six values.
	print("  persisted in play: %s and %s" % [PrototypeSettings.PATH, PrototypeLabState.PATH])
	print("  written by this run: %s and %s" % [settings.storage_path, lab_state.storage_path])
	_expect(PrototypeLabState.ALLOWED_KEYS.size() == 6,
		"the lab allowlist holds %d keys, not six" % PrototypeLabState.ALLOWED_KEYS.size())

	# D-184's in-memory guarantee is UNCHANGED: Gate F put the disk on the app's
	# side of the line, and `LabProgress` still has no way to reach it. Scanned
	# with comment lines stripped, so a promise cannot be mistaken for the breach.
	for forbidden: String in ["save", "load", "write", "serialize", "schema_version", "migrate"]:
		_expect(not (forbidden in progress),
			"LabProgress has a '%s' member; D-184 keeps it purely in memory" % forbidden)
	for path: String in [
		"res://scripts/prototype_zero/lab_progress.gd",
		"res://scripts/prototype_zero/lab_progression_data.gd",
		"res://scripts/combat/prototype_weapon_data.gd",
	]:
		var source: String = _code_only(FileAccess.get_file_as_string(path))
		_expect(not source.contains("user://"), "%s names a user:// path in code" % path.get_file())
		_expect(not source.contains("ConfigFile"), "%s uses ConfigFile" % path.get_file())
		_expect(not source.contains("FileAccess"), "%s reaches FileAccess" % path.get_file())
	print("  LabProgress is still in memory only; the disk lives on the app")

	# No WASD, still (specification §9.1).
	var bound: PackedStringArray = PackedStringArray()
	for action_name: StringName in InputMap.get_actions():
		for event: InputEvent in InputMap.action_get_events(action_name):
			var key: InputEventKey = event as InputEventKey
			if key == null:
				continue
			if [KEY_W, KEY_A, KEY_S, KEY_D].has(key.physical_keycode):
				bound.append(String(action_name))
			_expect(not [KEY_W, KEY_A, KEY_S, KEY_D].has(key.physical_keycode),
				"'%s' binds a WASD key; Prototype Zero has no WASD movement" % action_name)
	print("  WASD bindings: %d" % bound.size())

	# The three §9.1 actions Gate F owed are declared.
	for required: StringName in [&"pause", &"quick_restart", &"toggle_damage_numbers"]:
		_expect(InputMap.has_action(required),
			"specification §9.1 requires a '%s' action" % required)
	print("  pause, quick_restart, and toggle_damage_numbers are declared named actions")

	# The Gate B calibration is untouched.
	print("  navigation mesh still %d polygons, %.1f m^2; camera %.0f m / %.0f deg / %.0f deg" % [
		room.navmesh_polygon_count, room.navmesh_area,
		room.camera_rig.distance_metres, room.camera_rig.pitch_degrees, room.camera_rig.fov_degrees,
	])
	_expect(room.navmesh_polygon_count == 2 and absf(room.navmesh_area - 218.7) < 1.0,
		"the navigation mesh changed: %d polygons, %.1f m^2" % [room.navmesh_polygon_count, room.navmesh_area])
	_expect(is_equal_approx(room.camera_rig.distance_metres, 19.0)
		and is_equal_approx(room.camera_rig.pitch_degrees, 55.0)
		and is_equal_approx(room.camera_rig.fov_degrees, 45.0),
		"the D-175 camera calibration moved")
	# And the D-178 targeting values, which the default aim assistance must not
	# have touched.
	print("  soft target %.1f m, %.1f deg total (+/-%.2f deg) at the default aim assistance" % [
		action.data.soft_target_distance, action.data.soft_target_cone_degrees,
		action.data.soft_target_cone_half_degrees(),
	])
	_expect(is_equal_approx(action.data.soft_target_cone_degrees, 65.0),
		"the accepted D-178 cone is %.2f degrees at the default aim assistance" % action.data.soft_target_cone_degrees)
	_expect(is_equal_approx(action.data.soft_target_distance, 5.0),
		"the accepted D-169 acquisition distance moved")


# --- Helpers -----------------------------------------------------------------

## A visible surface has to occupy real pixels, and its text has to land inside
## the window. Three things are asserted: the root covers the viewport, every
## visible piece of text has a non-empty rect, and every one of those rects
## intersects the screen.
##
## This exists because a check that reads `Label.text` out of a Control tree
## proves the words EXIST, not that anyone can see them. `set_anchors_preset()`
## on a Control built in code sets the anchors and leaves the offsets at zero, so
## a full-rect anchor over a zero-size rect reports flawless text while every
## panel anchored inside it collapses to the origin. The HUD and all four Gate F
## modals shipped that way until this check was written.
func _check_surface_is_on_screen(root: Control, what: String) -> void:
	var view: Rect2 = get_viewport().get_visible_rect()
	var rect: Rect2 = root.get_global_rect()
	var offscreen: PackedStringArray = PackedStringArray()
	var total: int = _collect_offscreen_text(root, view, offscreen)
	print("  %-22s root %.0f x %.0f in a %.0f x %.0f window; %d text controls, %d off screen" % [
		what, rect.size.x, rect.size.y, view.size.x, view.size.y, total, offscreen.size(),
	])
	_expect(rect.size.x >= view.size.x - 1.0 and rect.size.y >= view.size.y - 1.0,
		"%s root is %.0f x %.0f, not the %.0f x %.0f viewport" % [
			what, rect.size.x, rect.size.y, view.size.x, view.size.y,
		])
	_expect(total > 0, "%s shows no text at all" % what)
	_expect(offscreen.is_empty(), "%s draws text off screen or at zero size: %s" % [
		what, ", ".join(offscreen),
	])


func _collect_offscreen_text(node: Node, view: Rect2, into: PackedStringArray) -> int:
	var total: int = 0
	for child: Node in node.get_children():
		var control: Control = child as Control
		if control != null and control.is_visible_in_tree():
			var text: String = ""
			var label: Label = control as Label
			if label != null:
				text = label.text
			var button: Button = control as Button
			if button != null and text.is_empty():
				text = button.text
			if not text.strip_edges().is_empty():
				total += 1
				var rect: Rect2 = control.get_global_rect()
				if rect.size.x <= 0.0 or rect.size.y <= 0.0 or not view.intersects(rect):
					into.append("%s at (%.0f, %.0f) %.0f x %.0f" % [
						control.name, rect.position.x, rect.position.y, rect.size.x, rect.size.y,
					])
		total += _collect_offscreen_text(child, view, into)
	return total


func _await_room() -> void:
	var waited: int = 0
	while waited < 600:
		if app.room != null and app.room.lab_begun:
			_bind_room()
			await _settle(2)
			return
		await _step()
		waited += 1
	push_error("Gate F verification: the laboratory never finished loading")


func _bind_room() -> void:
	room = app.room
	player = room.player
	action = player.attack
	director = room.director
	progress = director.progress
	hud = room.hud
	feedback = room.feedback


func _feedback_snapshot() -> Dictionary:
	return {
		"spawned": hud.numbers_spawned,
		"shown": feedback.numbers_shown,
		"suppressed": feedback.numbers_suppressed,
		"hits": feedback.hits_shown,
		"impact_cues": int(audio.play_counts.get("impact_bone_ordinary", 0))
			+ int(audio.play_counts.get("impact_bone_improved", 0)),
		"impulses": room.camera_rig.impulses_applied,
	}


## Decodes a generated cue and measures it. Everything here is read from the
## authored PCM rather than from the recipe, so the recipe cannot be wrong about
## its own result.
func _profile_family(family: String) -> Dictionary:
	var seconds: float = 0.0
	var rms: float = 0.0
	var low_ratio: float = 0.0
	var zcr: float = 0.0
	var takes: int = PrototypeCueCatalogue.variant_count(family)
	for index: int in takes:
		var stream: AudioStreamWAV = load(PrototypeCueCatalogue.variant_path(family, index)) as AudioStreamWAV
		var profile: Dictionary = _profile_stream(stream)
		seconds += float(profile["seconds"])
		rms += float(profile["rms"])
		low_ratio += float(profile["low_ratio"])
		zcr += float(profile["zcr"])
	return {
		"seconds": seconds / float(takes),
		"rms": rms / float(takes),
		"low_ratio": low_ratio / float(takes),
		"zcr": zcr / float(takes),
		"gain_db": float(PrototypeCueCatalogue.field(family, "gain_db", 0.0)),
	}


func _profile_stream(stream: AudioStreamWAV) -> Dictionary:
	var bytes: PackedByteArray = stream.data
	var count: int = bytes.size() / 2
	var rate: float = float(stream.mix_rate)
	var sum_squares: float = 0.0
	var crossings: int = 0
	var previous: float = 0.0
	# A one-pole low-pass at 250 Hz gives the low-band energy without an FFT.
	var alpha: float = 1.0 - exp(-TAU * 250.0 / rate)
	var low_state: float = 0.0
	var low_squares: float = 0.0
	for i: int in count:
		var sample: float = float(bytes.decode_s16(i * 2)) / 32768.0
		sum_squares += sample * sample
		low_state += alpha * (sample - low_state)
		low_squares += low_state * low_state
		if (sample >= 0.0) != (previous >= 0.0):
			crossings += 1
		previous = sample
	return {
		"seconds": float(count) / rate,
		"rms": sqrt(sum_squares / maxf(float(count), 1.0)),
		"low_ratio": low_squares / maxf(sum_squares, 0.000001),
		"zcr": float(crossings) / maxf(float(count) / rate, 0.0001),
	}


func _stream_seconds(stream: AudioStreamWAV) -> float:
	return float(stream.data.size() / 2) / float(stream.mix_rate)


func _files_under(root: String, extension: String) -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	var directory: DirAccess = DirAccess.open(root)
	if directory == null:
		return found
	for file: String in directory.get_files():
		if file.ends_with(extension):
			found.append("%s/%s" % [root, file])
	for child: String in directory.get_directories():
		found.append_array(_files_under("%s/%s" % [root, child], extension))
	return found


## Clears the ISOLATED files only. `_require_isolated_storage()` has already
## proved these are not the production paths before this can run.
func _wipe_state_files() -> void:
	for path: String in [settings.storage_path, lab_state.storage_path]:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	print("  starting from a clean slate in %s" % settings.storage_path.get_base_dir())


## Probes read the same isolated files the suite writes. Constructing one without
## the injected path would silently read the project owner's real settings, so a
## store that REFUSES the injected path is fatal rather than ignorable: it would
## leave the probe sitting on the production default (D-192).
func _settings_probe() -> PrototypeSettings:
	var probe: PrototypeSettings = PrototypeSettings.new()
	if not probe.set_storage_path(settings.storage_path):
		printerr("  FAIL: a settings probe could not be pointed at %s" % settings.storage_path)
		_failures.append("a settings probe could not be pointed at the isolated settings file")
	return probe


func _lab_probe() -> PrototypeLabState:
	var probe: PrototypeLabState = PrototypeLabState.new()
	if not probe.set_storage_path(lab_state.storage_path):
		printerr("  FAIL: a lab probe could not be pointed at %s" % lab_state.storage_path)
		_failures.append("a lab probe could not be pointed at the isolated lab file")
	return probe


func _strike_enemy_once(enemy: PrototypeGraveblade) -> void:
	player.mana = player.max_mana
	player.life = player.max_life
	await _teleport(enemy.global_position - Vector3(1.20, 0.0, 0.0))
	player.face_instantly(Vector3(1.0, 0.0, 0.0))
	await _step()
	Input.action_press(&"attack_in_place")
	room.set_cursor_override(
		room.camera_rig.camera.unproject_position(
			(enemy.get_node("TargetArea") as PrototypeTargetable).targeting_point()
		)
	)
	room.press_quick_strike()
	action.release_input()
	await _await_action_ready(3.0)
	Input.action_release(&"attack_in_place")
	room.set_cursor_override(null)
	await _step()


func _kill_every_living_graveblade() -> void:
	var ids: Array[int] = []
	for enemy: PrototypeGraveblade in room.graveblades:
		if is_instance_valid(enemy):
			ids.append(enemy.get_instance_id())
	for id: int in ids:
		var target: Object = instance_from_id(id)
		if target == null or not is_instance_valid(target):
			continue
		var enemy: PrototypeGraveblade = target as PrototypeGraveblade
		if enemy == null or not enemy.is_alive():
			continue
		enemy.set_ai_enabled(false)
		var guard: int = 0
		while is_instance_valid(enemy) and enemy.is_alive() and guard < 6:
			await _strike_enemy_once(enemy)
			guard += 1
	await _settle(2)


func _teleport(to: Vector3) -> void:
	player.clear_movement_intent("verification teleport", false)
	player.global_position = Vector3(to.x, 0.0, to.z)
	player.velocity = Vector3.ZERO
	await _settle(4)


func _release_all_inputs() -> void:
	for action_name: StringName in [
		&"quick_strike", &"move_point", &"attack_in_place", &"interact",
		&"ui_confirm", &"ui_cancel", &"pause",
	]:
		if Input.is_action_pressed(action_name):
			Input.action_release(action_name)
	action.release_input()
	room.set_stick_override(null)
	room.set_cursor_override(null)
	await _settle(2)
	var waited: int = 0
	while player.awaiting_neutral and player.is_alive() and waited < 30:
		player.release_neutral_latch()
		await _step()
		waited += 1


func _press(surface: Node, caption: String) -> void:
	var button: Button = _button_with_caption(surface, caption)
	if button == null:
		_expect(false, "no button captioned '%s' on %s" % [caption, surface.name])
		return
	button.emit_signal("pressed")


func _button_named(root: Node, node_name: String) -> Button:
	for child: Node in root.get_children():
		var button: Button = child as Button
		if button != null and button.name == node_name:
			return button
		var found: Button = _button_named(child, node_name)
		if found != null:
			return found
	return null


func _button_with_caption(root: Node, caption: String) -> Button:
	for child: Node in root.get_children():
		var button: Button = child as Button
		if button != null and _caption_of(button) == caption:
			return button
		var found: Button = _button_with_caption(child, caption)
		if found != null:
			return found
	return null


func _button_captions(root: Node) -> PackedStringArray:
	var captions: PackedStringArray = PackedStringArray()
	_collect_captions(root, captions)
	return captions


func _collect_captions(root: Node, into: PackedStringArray) -> void:
	for child: Node in root.get_children():
		var button: Button = child as Button
		if button != null:
			var caption: String = _caption_of(button)
			if not caption.is_empty():
				into.append(caption)
		_collect_captions(child, into)


## The caption of a button, whether it carries its own `text` or the Gate E
## modal's caption-plus-glyph row.
func _caption_of(button: Button) -> String:
	if not button.text.strip_edges().is_empty():
		return button.text
	for child: Node in button.get_children():
		for grandchild: Node in child.get_children():
			var label: Label = grandchild as Label
			if label != null:
				return label.text
	return ""


func _visible_text_in(node: Node) -> String:
	var parts: PackedStringArray = PackedStringArray()
	_collect_text(node, parts)
	return "\n".join(parts)


func _collect_text(node: Node, into: PackedStringArray) -> void:
	for child: Node in node.get_children():
		var label: Label = child as Label
		if label != null and not label.text.strip_edges().is_empty():
			into.append(label.text)
		var rich: RichTextLabel = child as RichTextLabel
		if rich != null and not rich.get_parsed_text().strip_edges().is_empty():
			into.append(rich.get_parsed_text())
		var button: Button = child as Button
		if button != null and not button.text.strip_edges().is_empty():
			into.append(button.text)
		_collect_text(child, into)


## Controls that would absorb the pointer. §9.3: "Clicking UI never leaks a
## ground command into the world" — and the mirror of that is that a HUD must
## never absorb a ground command either.
func _mouse_stopping_controls(root: Node) -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	for child: Node in root.get_children():
		var control: Control = child as Control
		if control != null and control.mouse_filter != Control.MOUSE_FILTER_IGNORE:
			found.append(control.name)
		found.append_array(_mouse_stopping_controls(child))
	return found


func _count_nodes_of_type(node: Node, type_name: String) -> int:
	var total: int = 0
	for child: Node in node.get_children():
		if child.is_class(type_name):
			total += 1
		total += _count_nodes_of_type(child, type_name)
	return total


func _code_only(source: String) -> String:
	var kept: PackedStringArray = PackedStringArray()
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


func _confirm_event() -> InputEventAction:
	var event: InputEventAction = InputEventAction.new()
	event.action = &"ui_confirm"
	event.pressed = true
	return event


func _release_event(action_name: StringName) -> InputEventAction:
	var event: InputEventAction = InputEventAction.new()
	event.action = action_name
	event.pressed = false
	return event


func _step() -> void:
	await get_tree().physics_frame


func _settle(frames: int) -> void:
	for i: int in frames:
		await _step()


func _wait_seconds(seconds: float) -> void:
	var frames: int = maxi(int(ceil(seconds / TICK)), 1)
	await _settle(frames)


func _await_action_ready(timeout: float) -> float:
	var elapsed: float = 0.0
	while elapsed < timeout:
		await _step()
		elapsed += TICK
		if not action.busy():
			return elapsed
	return timeout


func _await_living_enemy(timeout: float) -> float:
	var elapsed: float = 0.0
	while elapsed < timeout:
		if room.living_graveblade_count() > 0:
			return elapsed
		await _step()
		elapsed += TICK
	return -1.0


func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _argument_value(arguments: PackedStringArray, flag: String) -> String:
	var index: int = arguments.find(flag)
	if index == -1 or index + 1 >= arguments.size():
		return ""
	return arguments[index + 1]


# --- Rendered evidence -------------------------------------------------------

func _capture_evidence() -> void:
	print("")
	print("--- Rendered evidence")
	await _release_all_inputs()

	# 1. The title screen with no saved laboratory.
	app.quit_to_title("evidence")
	app.reset_lab_progress_from_title()
	lab_state.load_from_disk()
	app.title.refresh()
	await _settle(8)
	_expect(app.title.visible, "the title evidence shot was taken without the title screen")
	await _shoot("gate_f_title_new", 4)

	# 2. The title screen refusing an invalid file, truthfully.
	var broken: FileAccess = FileAccess.open(lab_state.storage_path, FileAccess.WRITE)
	broken.store_string("not a laboratory")
	broken.close()
	lab_state.load_from_disk()
	app.title.refresh()
	await _settle(6)
	await _shoot("gate_f_title_invalid_state", 4)
	app.reset_lab_progress_from_title()
	lab_state.load_from_disk()
	app.title.refresh()
	await _settle(4)

	# 3. The §17 HUD in an ordinary fight, with no instrumentation.
	app.start_new_lab()
	await _await_room()
	await _await_living_enemy(5.0)
	var enemy: PrototypeGraveblade = room.graveblade
	enemy.set_ai_enabled(false)
	enemy.place_at(Vector3(2.6, 0.0, -1.4))
	await _teleport(Vector3(-0.4, 0.0, 0.4))
	await _settle(8)
	_expect(not room.instrumentation_visible, "the HUD evidence shot has instrumentation over it")
	await _shoot("gate_f_hud", 4)

	# 4. A Hit landing, with the damage number on.
	settings.set_damage_numbers(true)
	await _strike_enemy_once(enemy)
	await _settle(2)
	await _shoot("gate_f_hit_numbers_on", 1)

	# 5. The same Hit with numbers Off — the shot the feel review is about.
	settings.set_damage_numbers(false)
	await _settle(2)
	await _strike_enemy_once(enemy)
	await _settle(2)
	await _shoot("gate_f_hit_numbers_off", 1)
	settings.set_damage_numbers(true)

	# 6. Pause.
	await _release_all_inputs()
	room.open_pause("evidence")
	await _settle(6)
	await _shoot("gate_f_pause", 2)

	# 7. Settings.
	room.pause_menu.close("evidence")
	await _settle(2)
	room.open_settings("evidence")
	await _settle(6)
	await _shoot("gate_f_settings", 2)
	room.settings_modal.return_to_pause = false
	room.settings_modal.close("evidence")
	room.settings_modal.return_to_pause = true
	await _release_all_inputs()

	# 8. Fallen, with the exact killing source.
	await _await_living_enemy(6.0)
	var killer: PrototypeGraveblade = room.graveblade
	player.life = killer.data.physical_damage
	player.receive_damage(DamageEvent.physical(9999, killer, player, killer.data.physical_damage))
	await _wait_seconds(PrototypeZeroRoom.FALLEN_DELAY + PrototypeFallenOverlay.FADE_SECONDS + 0.2)
	await _shoot("gate_f_fallen", 2)
	room.restart_current_fight("evidence")
	await _settle(8)
	await _release_all_inputs()

	# 9. The instrumentation F3 still reveals.
	room.set_instrumentation_visible(true)
	room.set_debug_panels(true)
	await _settle(6)
	await _shoot("gate_f_instrumentation", 2)
	room.set_instrumentation_visible(false)
	room.set_debug_panels(false)


func _shoot(name: String, settle: int) -> void:
	await _settle(settle)
	await RenderingServer.frame_post_draw
	var image: Image = get_viewport().get_texture().get_image()
	var path: String = "%s/%s.png" % [_shot_dir, name]
	# Asserted on the SAVE RESULT rather than on `FileAccess.file_exists`, which
	# resolves a relative path against `res://` and would report a miss for a
	# screenshot that was written perfectly well somewhere else. `--shots` is
	# given an absolute directory by `gate_f_smoke.sh`; this makes the check
	# correct either way.
	var error: int = image.save_png(path)
	print("  wrote %s" % path)
	_expect(error == OK, "the %s screenshot could not be written to %s (error %d)" % [
		name, path, error,
	])
