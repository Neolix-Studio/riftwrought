class_name PrototypeLabState
extends RefCounted
## Prototype Zero — Gate F: the one versioned lab test-state file (specification
## §20.3, decision D-189).
##
## "This is not the future local-profile or active-run save system." It is six
## values on disk, and the list is closed:
##
##   schema_version         so a later shape cannot be silently reinterpreted
##   milestone              which of the five §15 stages to reconstruct
##   experience             0, 10, or 20
##   equipped_weapon_id     `training_sword` or `honed_sword`
##   quickened_form         whether the one contained passive is active
##   repeat_loop_kills      the §23.5 ten-kill counter, "if useful"
##
## D-189: "Do not serialize enemies, positions, current Life/Mana, attack phase,
## targets, permission state, or active hit queries." Nothing here can, because
## `ALLOWED_KEYS` below is the whole vocabulary and the Gate F suite reads the
## written file back and asserts that its key set is exactly that.
##
## IT DOES NOT TOUCH `LabProgress`. D-184 put the authoritative record in memory
## and Gate E asserted, by field name and by a comment-stripped source scan, that
## `lab_progress.gd` has no save, load, serialize, schema_version, ConfigFile,
## FileAccess, or `user://` anywhere in it. Gate F did not weaken that: this
## class reads a SNAPSHOT out of `LabProgress` and reconstructs a saved state by
## calling the same five idempotent reward doors ordinary play calls, so
## Continue physically cannot duplicate XP, the sword, or the passive — the doors
## refuse a second grant whoever knocks.
##
## SAVE POINTS. Specification §20.3: "Save only on milestone transitions and
## deliberate clean exit." The app writes on the four milestone commits, on
## entering the repeat loop, and on Quit to Title / Quit. It does not write per
## frame, per kill, per Hit, or on pause.

## The PRODUCTION path, and the default every ordinary launch uses. It is a
## constant because the shipped application must never be able to choose a
## different one by accident.
const PATH: String = "user://prototype_zero.cfg"
## The bare file name, so an injected storage directory produces the same file
## under a different root rather than a second naming convention.
const FILE_NAME: String = "prototype_zero.cfg"
## Bump only when a stored key changes meaning. A file from another schema is
## reported as unreadable rather than guessed at (specification §20.3: "Do not
## silently claim an exact resume").
const SCHEMA_VERSION: int = 1

## WHERE THIS INSTANCE ACTUALLY READS AND WRITES, and why it is injectable.
##
## The Gate F verification saves, loads, corrupts, and DELETES real lab files —
## an authored state at every one of the five milestones, four deliberately
## invalid files, and a Reset Lab Progress. Until D-191 it did all of that to
## `PATH`, so a successful test run erased the project owner's real laboratory
## progress, and a crash halfway through could leave a deliberately broken file
## where their save used to be.
##
## The path is therefore a property of the INSTANCE. Ordinary launches leave it
## at `PATH`; the verification is handed a unique temporary directory and refuses
## to run without one. There is no "fall back to production" branch: a harness
## that cannot get isolated storage must fail rather than borrow the real file.
var storage_path: String = PATH

## The complete, closed vocabulary. `section/key` form, so the assertion can be
## made against the file as written rather than against intention.
const ALLOWED_KEYS: Array[String] = [
	"meta/schema_version",
	"lab/milestone",
	"lab/experience",
	"lab/equipped_weapon_id",
	"lab/quickened_form",
	"lab/repeat_loop_kills",
]

## Words that must never appear in the file, whatever a later gate does to this
## class. The Gate F suite scans the written bytes for them.
const FORBIDDEN_WORDS: Array[String] = [
	"enemy", "graveblade", "position", "life", "mana", "phase",
	"target", "permission", "query", "velocity", "transform", "wave_index",
]

const MILESTONES: Array[String] = [
	"STARTER_FIGHT", "UPGRADE_ON_GROUND", "UPGRADED_FIGHT", "PASSIVE_READY", "REPEAT_LOOP",
]

const TRAINING_ID: StringName = &"training_sword"
const HONED_ID: StringName = &"honed_sword"

## True when a file exists AND every value in it is coherent.
var exists: bool = false
var valid: bool = false
## A truthful, player-readable sentence. Specification §20.3: "If the file is
## invalid, show a small truthful recovery message and offer Reset Lab Progress."
var problem: String = ""

var milestone: String = "STARTER_FIGHT"
var experience: int = 0
var equipped_weapon_id: StringName = TRAINING_ID
var quickened_form: bool = false
var repeat_loop_kills: int = 0

# --- Instrumentation (specification §22) -------------------------------------
var loads: int = 0
var saves: int = 0
var last_load_status: String = "not loaded"
var last_save_status: String = "not saved"


# --- Load --------------------------------------------------------------------

## Points this instance at a different file. Used by the verification harness so
## its real saves, loads, corruptions, and deletions land in a temporary
## directory, and by nothing else.
##
## It REFUSES an empty path and, since D-192, any path that is the production
## file `PATH` under a different spelling — returning false rather than
## pretending. This store DELETES files, so accepting an alias of the real lab
## file would be the worst version of the D-191 defect; `PrototypeApp` refuses
## the same request one layer up, and this is the independent second refusal.
func set_storage_path(new_path: String) -> bool:
	var wanted: String = new_path.strip_edges()
	if wanted.is_empty():
		push_error("PrototypeLabState: an empty storage path is not a storage path")
		return false
	if PrototypeStoragePaths.same_file(wanted, PATH):
		push_error(
			"PrototypeLabState: '%s' is the production lab-state file %s; refusing it as injected storage"
			% [wanted, PATH]
		)
		return false
	storage_path = wanted
	return true


## True when this instance is reading and writing the project owner's real file.
##
## THE COMPARISON IS STRUCTURAL, NOT TEXTUAL (D-192). `storage_path == PATH` was
## a question about spelling, and the absolute path, a `..` round trip, and a
## symlink are all different strings naming the same file. Every spelling is now
## resolved to one canonical real path first.
func uses_production_storage() -> bool:
	return PrototypeStoragePaths.same_file(storage_path, PATH)


## Reads the file if there is one. Sets `exists`, `valid`, and `problem`; never
## throws and never guesses.
func load_from_disk() -> void:
	loads += 1
	_clear()

	if not FileAccess.file_exists(storage_path):
		exists = false
		valid = false
		problem = ""
		last_load_status = "no lab-state file; Continue is unavailable"
		return

	exists = true
	var config: ConfigFile = ConfigFile.new()
	var error: int = config.load(storage_path)
	if error != OK:
		valid = false
		problem = "The saved lab state could not be read (error %d)." % error
		last_load_status = problem
		return

	var version: int = int(config.get_value("meta", "schema_version", -1))
	if version != SCHEMA_VERSION:
		valid = false
		problem = "The saved lab state was written by a different version (schema %s, this build expects %d)." % [
			str(version), SCHEMA_VERSION,
		]
		last_load_status = problem
		return

	milestone = String(config.get_value("lab", "milestone", ""))
	experience = int(config.get_value("lab", "experience", -1))
	equipped_weapon_id = StringName(String(config.get_value("lab", "equipped_weapon_id", "")))
	quickened_form = bool(config.get_value("lab", "quickened_form", false))
	repeat_loop_kills = int(config.get_value("lab", "repeat_loop_kills", 0))

	var fault: String = _incoherence()
	if not fault.is_empty():
		valid = false
		problem = "The saved lab state is not a state this laboratory can reach: %s" % fault
		last_load_status = problem
		return

	valid = true
	problem = ""
	last_load_status = "loaded %s, %d XP, %s%s, %d repeat kills" % [
		milestone, experience, equipped_weapon_id,
		", Quickened Form" if quickened_form else "", repeat_loop_kills,
	]


## The coherence rule. Every legal combination is a state the five-stage loop
## actually produces; anything else is a hand-edited or truncated file, and
## reconstructing "the nearest valid beginning" of a state that never existed
## would be exactly the silent false resume §20.3 forbids.
func _incoherence() -> String:
	if not MILESTONES.has(milestone):
		return "'%s' is not one of the five laboratory stages" % milestone
	if experience < 0 or experience > 20 or experience % 10 != 0:
		return "%d XP is not 0, 10, or 20" % experience
	if equipped_weapon_id != TRAINING_ID and equipped_weapon_id != HONED_ID:
		return "'%s' is not a prototype weapon" % equipped_weapon_id
	if repeat_loop_kills < 0:
		return "a negative repeat-loop kill count"

	var honed: bool = equipped_weapon_id == HONED_ID
	match milestone:
		"STARTER_FIGHT":
			if experience != 0 or honed or quickened_form or repeat_loop_kills != 0:
				return "the starter fight cannot already carry XP, the Honed Sword, the passive, or repeat kills"
		"UPGRADE_ON_GROUND":
			if experience != 10 or honed or quickened_form or repeat_loop_kills != 0:
				return "the sword is on the ground, so exactly 10 XP is earned and nothing is equipped yet"
		"UPGRADED_FIGHT":
			if experience != 10 or not honed or quickened_form or repeat_loop_kills != 0:
				return "the upgraded fight needs 10 XP and the equipped Honed Sword, and no passive"
		"PASSIVE_READY":
			if experience != 20 or not honed or quickened_form or repeat_loop_kills != 0:
				return "the passive card needs 20 / 20 XP, the Honed Sword, and an unconfirmed passive"
		"REPEAT_LOOP":
			if experience != 20 or not honed or not quickened_form:
				return "the repeat loop needs 20 / 20 XP, the Honed Sword, and a confirmed Quickened Form"
	return ""


# --- Save --------------------------------------------------------------------

## Takes a snapshot of the live in-memory record and writes exactly the six
## allowlisted values. `LabProgress` is READ here and never asked to serialize
## itself, which is what keeps D-184's in-memory guarantee intact.
func capture(progress: LabProgress, weapon: PrototypeWeaponData) -> void:
	milestone = progress.stage_name()
	experience = progress.experience
	equipped_weapon_id = weapon.weapon_id if weapon != null else TRAINING_ID
	quickened_form = progress.quickened_form_active
	repeat_loop_kills = progress.repeat_loop_kills
	exists = true
	valid = true
	problem = ""


func save_to_disk() -> bool:
	var config: ConfigFile = ConfigFile.new()
	config.set_value("meta", "schema_version", SCHEMA_VERSION)
	config.set_value("lab", "milestone", milestone)
	config.set_value("lab", "experience", experience)
	config.set_value("lab", "equipped_weapon_id", String(equipped_weapon_id))
	config.set_value("lab", "quickened_form", quickened_form)
	config.set_value("lab", "repeat_loop_kills", repeat_loop_kills)
	var error: int = config.save(storage_path)
	saves += 1
	if error == OK:
		last_save_status = "saved %s, %d XP, %s at %s" % [
			milestone, experience, equipped_weapon_id, storage_path,
		]
		return true
	last_save_status = "could not save lab state (error %d)" % error
	return false


## Specification §21 General and §15.2: Reset Lab Progress. It deletes the lab
## file and NOTHING else — the settings file is a separate file and is not
## touched, which the Gate F suite asserts by reading it back afterwards.
func delete_from_disk() -> bool:
	_clear()
	if not FileAccess.file_exists(storage_path):
		last_save_status = "no lab-state file to remove"
		return true
	var error: int = DirAccess.remove_absolute(ProjectSettings.globalize_path(storage_path))
	if error == OK:
		last_save_status = "removed %s; settings were not touched" % storage_path
		return true
	last_save_status = "could not remove the lab-state file (error %d)" % error
	return false


# --- Reconstruction ----------------------------------------------------------

## Specification §20.3: "On Continue, reconstruct the nearest valid beginning of
## the saved stage."
##
## It does that by walking the SAME five idempotent reward doors ordinary play
## walks, in the order ordinary play walks them, and stopping at the saved
## milestone. Two consequences follow, and both are the point:
##
##   * Continue cannot duplicate anything. Each door returns false the second
##     time it is called, whoever is calling it, so a Continue into a record that
##     already holds a milestone changes nothing.
##   * There is no second code path to keep in step with the first. If the loop's
##     rules change, Continue changes with them automatically.
##
## Returns the list of doors it actually opened, for the log and the checks.
func reconstruct_into(progress: LabProgress) -> PackedStringArray:
	var opened: PackedStringArray = PackedStringArray()
	if not valid:
		return opened

	var index: int = MILESTONES.find(milestone)
	if index >= MILESTONES.find("UPGRADE_ON_GROUND") and progress.grant_starter_kill_reward():
		opened.append("starter kill reward (+10 XP, one guaranteed Honed Sword)")
	if index >= MILESTONES.find("UPGRADED_FIGHT") and progress.equip_honed_sword():
		opened.append("equipped the Prototype Honed Sword")
	if index >= MILESTONES.find("PASSIVE_READY") and progress.grant_upgraded_kill_reward():
		opened.append("upgraded kill reward (+10 XP, reaching 20 / 20)")
	if index >= MILESTONES.find("REPEAT_LOOP") and progress.confirm_quickened_form():
		opened.append("confirmed Quickened Form")
	for _kill: int in repeat_loop_kills:
		progress.count_repeat_loop_kill()
	if repeat_loop_kills > 0:
		opened.append("restored %d repeat-loop kill%s" % [
			repeat_loop_kills, "" if repeat_loop_kills == 1 else "s",
		])
	return opened


## The stage the reconstruction should leave the laboratory in. It is the SAVED
## milestone except for one deliberate correction: `UPGRADE_ON_GROUND` saved the
## sword lying on the floor at a position that is not persisted, so the nearest
## valid BEGINNING of that stage is the fight that produces it. Continuing there
## re-fights one Graveblade rather than inventing a drop location, and the
## already-granted 10 XP is retained because the door refuses to pay twice.
func stage_to_enter() -> String:
	if milestone == "UPGRADE_ON_GROUND":
		return "UPGRADE_ON_GROUND"
	return milestone


func describe() -> String:
	if not exists:
		return "no saved lab state"
	if not valid:
		return "invalid saved lab state — %s" % problem
	return "%s, %d / 20 XP, %s%s, %d repeat kills" % [
		milestone, experience, equipped_weapon_id,
		", Quickened Form active" if quickened_form else "", repeat_loop_kills,
	]


func _clear() -> void:
	exists = false
	valid = false
	problem = ""
	milestone = "STARTER_FIGHT"
	experience = 0
	equipped_weapon_id = TRAINING_ID
	quickened_form = false
	repeat_loop_kills = 0
