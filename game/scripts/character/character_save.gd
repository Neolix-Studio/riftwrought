class_name CharacterSave
extends RefCounted
## First-MVP — Gate 1E: the versioned local character store (D-219).
##
## THE THIRD FILE, AND IT MUST NEVER BE EITHER OF THE OTHER TWO. Prototype Zero
## owns `user://prototype_settings.cfg` (comfort choices) and
## `user://prototype_zero.cfg` (the laboratory milestone). This is
## `user://riftwrought_character.cfg`, and the brief is explicit: "Never write
## over Prototype Zero's save. Do not reuse Prototype Zero's progression record
## as the canonical character save."
##
## That is enforced rather than intended. `set_storage_path()` refuses any path
## that resolves onto either production file, asked through
## `PrototypeStoragePaths.same_file()` — the D-192 calculator that resolves
## `user://`, relative paths, `.`, `..`, symlinks AND case-folding, because the
## first version of that guard compared path TEXT and would have accepted the
## real file spelled a different way. Nothing here re-implements that
## comparison; there is exactly one in the project and this asks it.
##
## WHERE THIS FILE LIVES, AND WHY IT IS NOT UNDER `scripts/first_mvp/`.
## Four closed runners (`gate_1a_scale_hall_smoke.sh`, both Gate 1B runners, and
## `gate_1c_riftfall_landing_smoke.sh`) each `grep -rlE 'user://|ConfigFile|
## ResourceSaver'` over `scripts/first_mvp`, `scenes/first_mvp` and
## `data/first_mvp` and REQUIRE the count to be zero. A character store placed
## there would turn four closed gates red for naming its own storage. It lives
## in `scripts/character/` for the same reason Gate 1D put `first_mvp_modal.gd`
## under `scripts/ui/`.
##
## ATOMIC WRITE, AND IT IS NEW BEHAVIOUR RATHER THAN "THE EXISTING PATTERN".
## Neither Prototype Zero store does this: both call `ConfigFile.save()`
## straight onto the live path, so a crash mid-write leaves a truncated file.
## That was acceptable for comfort choices and a five-value laboratory record;
## it is not acceptable for a character. This writes to a sibling `.tmp`, closes
## it, and only then renames over the target — a rename within one directory is
## atomic on APFS, so a reader sees either the whole old file or the whole new
## one and never a half-written one. The two Prototype Zero stores are
## deliberately NOT retrofitted: every gate runner fingerprints their files, and
## changing how they write is not what this gate authorizes.
##
## EVERY VALUE IS VALIDATED ON LOAD, following `PrototypeSettings` exactly.
## An unknown schema version is not silently reinterpreted — it resets to a
## fresh character and says so. Out-of-range numbers are clamped, unknown
## Passive nodes and unknown Skill ids are dropped with a correction recorded,
## and an allocation that is not reachable in the graph is refused rather than
## half-applied. A save that loads with corrections says which.
##
## NOT THE FULL SAVE ARCHITECTURE, and the brief says so: "Do not build complete
## Local Profiles, Character Select, Archive/Restore, export/import, or
## rolling-backup UI yet. The underlying save format should not deliberately
## block those future systems." So the file carries a `[meta]` section with a
## schema version and a `[character]` section keyed by name — a profile layer
## later becomes another section or another file, not a rewrite.

## The PRODUCTION path, and the default every ordinary launch uses. A constant,
## so the shipped application cannot choose a different one by accident.
const PATH: String = "user://riftwrought_character.cfg"
## The bare file name, so an injected storage directory produces the same file
## under a different root rather than a second naming convention.
const FILE_NAME: String = "riftwrought_character.cfg"
## The suffix the atomic write lands on before the rename.
const TEMP_SUFFIX: String = ".tmp"
## Bump only when a stored key changes MEANING. A file from an older schema is
## reset to a fresh character rather than reinterpreted.
const SCHEMA_VERSION: int = 1

## Where this instance actually reads and writes. Injectable for exactly the
## reason `PrototypeSettings.storage_path` is: the verification writes real
## files — fresh saves, round trips, a deliberately corrupted file, a stale
## schema — and until D-191 the Prototype Zero suite wrote all of those onto the
## project owner's own record. There is deliberately no "fall back to
## production" branch: a harness that cannot get isolated storage must fail.
var storage_path: String = PATH

var last_save_status: String = "never saved"
var last_load_status: String = "never loaded"
var last_corrections: PackedStringArray = PackedStringArray()
var saves_written: int = 0
var saves_refused: int = 0


## Refuses an empty path, and any path that resolves onto EITHER Prototype Zero
## production file however it is spelled. Returns true when the path was
## accepted.
func set_storage_path(new_path: String) -> bool:
	var wanted: String = new_path.strip_edges()
	if wanted.is_empty():
		saves_refused += 1
		last_save_status = "refused an empty storage path"
		return false
	if PrototypeStoragePaths.is_production_file(wanted):
		saves_refused += 1
		last_save_status = "refused %s: it resolves onto a Prototype Zero production file" % wanted
		return false
	if PrototypeStoragePaths.same_file(wanted, PATH):
		# Accepting the production character file is correct; this branch exists
		# so the intent is explicit rather than implied by falling through.
		storage_path = PATH
		return true
	storage_path = wanted
	return true


## True when this instance is pointed at the real character file. Asked through
## the one comparator, never by comparing path text.
func uses_production_storage() -> bool:
	return PrototypeStoragePaths.same_file(storage_path, PATH)


## True when this instance could reach either Prototype Zero file. Must always
## be false; the verification asserts it in both directions.
func would_touch_prototype_zero() -> bool:
	return PrototypeStoragePaths.is_production_file(storage_path)


func exists() -> bool:
	return FileAccess.file_exists(storage_path)


# --- Write ---------------------------------------------------------------------

func save(state: CharacterState) -> bool:
	if state == null:
		saves_refused += 1
		last_save_status = "refused: no character state"
		return false
	if would_touch_prototype_zero():
		saves_refused += 1
		last_save_status = "refused: the storage path resolves onto a Prototype Zero file"
		return false

	var config: ConfigFile = ConfigFile.new()
	config.set_value("meta", "schema_version", SCHEMA_VERSION)

	config.set_value("character", "name", state.character_name)
	config.set_value("character", "class", state.character_class)
	config.set_value("character", "level", state.level)
	config.set_value("character", "total_experience", state.total_experience)
	config.set_value("character", "milestone", int(state.milestone))

	config.set_value("progress", "awarded_encounters", PackedStringArray(
		Array(state.awarded_encounters.keys()).map(func(key: StringName) -> String: return String(key))
	))
	config.set_value("progress", "watchsteel_granted", state.watchsteel_granted)
	config.set_value("progress", "watchsteel_equipped_once", state.watchsteel_equipped_once)
	config.set_value("progress", "broken_watch_complete", state.broken_watch_complete)
	config.set_value("progress", "nexus_recognition_complete", state.nexus_recognition_complete)
	config.set_value("progress", "mara_first_conversation_complete", state.mara_first_conversation_complete)
	config.set_value("progress", "milestone_passive_point_claimed", state.milestone_passive_point_claimed)
	config.set_value("progress", "foundation_package", int(state.foundation_package))
	config.set_value("progress", "foundation_package_granted", state.foundation_package_granted)

	config.set_value("passives", "milestone_points", state.milestone_points)
	config.set_value("passives", "level_points", state.level_points)
	config.set_value("passives", "allocated", PackedStringArray(
		Array(state.passives.allocated_ids_without_origin()).map(
			func(id: StringName) -> String: return String(id))
	))

	config.set_value("skills", "learned", PackedStringArray(
		Array(state.learned_skills).map(func(id: StringName) -> String: return String(id))
	))
	config.set_value("skills", "bindings", state.bindings.to_string_array())

	if state.equipment != null:
		config.set_value("items", "owned", PackedStringArray(
			Array(state.equipment.owned_ids()).map(func(id: StringName) -> String: return String(id))
		))
		var equipped: FirstMvpWeaponRecord = state.equipment.equipped_record()
		config.set_value("items", "equipped", String(
			equipped.item_id if equipped != null else state.equipment.equipped_weapon.weapon_id
		))

	return _write_atomically(config)


## Writes to `<path>.tmp`, closes it, then renames over the target. A rename
## within one directory is atomic, so a crash can leave the old file or the new
## file and never a half-written one.
func _write_atomically(config: ConfigFile) -> bool:
	var temp: String = storage_path + TEMP_SUFFIX
	var error: Error = config.save(temp)
	if error != OK:
		saves_refused += 1
		last_save_status = "could not write %s (error %d)" % [temp, error]
		return false
	var directory: DirAccess = DirAccess.open(storage_path.get_base_dir())
	if directory == null:
		saves_refused += 1
		last_save_status = "could not open %s to rename into" % storage_path.get_base_dir()
		return false
	error = directory.rename(temp.get_file(), storage_path.get_file())
	if error != OK:
		saves_refused += 1
		last_save_status = "could not rename %s over %s (error %d)" % [
			temp.get_file(), storage_path.get_file(), error,
		]
		return false
	saves_written += 1
	last_save_status = "saved schema %d to %s" % [SCHEMA_VERSION, storage_path]
	return true


# --- Read ----------------------------------------------------------------------

## Loads into `state`, which the caller has already constructed with its
## starting weapon. Returns true when a saved character was applied; false when
## there was nothing to load or the file could not be trusted. Either way
## `last_load_status` says exactly what happened.
##
## `library` resolves Skill ids and `weapon_records` maps a saved item id back
## to its authored record, so this class never holds a resource path.
func load_into(
	state: CharacterState, library: FirstMvpSkillLibrary, weapon_records: Dictionary
) -> bool:
	last_corrections = PackedStringArray()
	if not FileAccess.file_exists(storage_path):
		last_load_status = "no saved character at %s" % storage_path
		return false

	var config: ConfigFile = ConfigFile.new()
	var error: Error = config.load(storage_path)
	if error != OK:
		last_load_status = "%s could not be read (error %d); a fresh character was started" % [storage_path, error]
		state.start_fresh()
		return false

	var version: int = int(config.get_value("meta", "schema_version", -1))
	if version != SCHEMA_VERSION:
		last_load_status = "character schema %d is not %d; a fresh character was started" % [version, SCHEMA_VERSION]
		state.start_fresh()
		return false

	state.start_fresh()

	var stored_name: Variant = config.get_value("character", "name", CharacterState.DEFAULT_NAME)
	state.character_name = str(stored_name)
	if state.character_name.strip_edges().is_empty():
		state.character_name = CharacterState.DEFAULT_NAME
		_correct("the saved name was empty")
	state.character_class = CharacterState.CLASS_NAME_CANONICAL

	state.total_experience = maxi(int(config.get_value("character", "total_experience", 0)), 0)
	# LEVEL IS DERIVED, NEVER TRUSTED FROM THE FILE. A hand-edited level would
	# otherwise mint Passive points; the curve is the only authority.
	var stored_level: int = int(config.get_value("character", "level", ExperienceTable.STARTING_LEVEL))
	state.level = ExperienceTable.level_for_total(state.total_experience)
	if stored_level != state.level:
		_correct("the stored Level %d did not match %d XP; the curve decides" % [stored_level, state.total_experience])

	var milestone: int = int(config.get_value("character", "milestone", 0))
	state.milestone = _clamped_milestone(milestone)
	if int(state.milestone) != milestone:
		_correct("milestone %d is not a known milestone" % milestone)

	for encounter: String in _string_list(config, "progress", "awarded_encounters"):
		state.awarded_encounters[StringName(encounter)] = true
	state.watchsteel_granted = bool(config.get_value("progress", "watchsteel_granted", false))
	state.watchsteel_equipped_once = bool(config.get_value("progress", "watchsteel_equipped_once", false))
	state.broken_watch_complete = bool(config.get_value("progress", "broken_watch_complete", false))
	state.nexus_recognition_complete = bool(config.get_value("progress", "nexus_recognition_complete", false))
	state.mara_first_conversation_complete = bool(config.get_value("progress", "mara_first_conversation_complete", false))
	state.milestone_passive_point_claimed = bool(config.get_value("progress", "milestone_passive_point_claimed", false))
	state.foundation_package = _clamped_package(int(config.get_value("progress", "foundation_package", 0)))
	state.foundation_package_granted = bool(config.get_value("progress", "foundation_package_granted", false))

	# THE ONE CROSS-FIELD RULE THE FILE CANNOT BE ALLOWED TO BREAK: a claimed
	# milestone point that was never earned would be a free point on every
	# reload. The claim is only honoured when the recognition it belongs to
	# actually happened.
	if state.milestone_passive_point_claimed and not state.nexus_recognition_complete:
		state.milestone_passive_point_claimed = false
		_correct("a claimed Nexus recognition point had no recognition behind it")

	state.milestone_points = clampi(int(config.get_value("passives", "milestone_points", 0)), 0, 4)
	# MILESTONE POINTS ARE DERIVED FROM THE LATCHES, NOT TRUSTED. Gate 1E can
	# only ever have granted the one recognition point.
	var owed_milestone_points: int = 1 if state.milestone_passive_point_claimed else 0
	if state.milestone_points != owed_milestone_points:
		_correct("stored %d milestone point(s); the claimed milestones account for %d" % [
			state.milestone_points, owed_milestone_points,
		])
		state.milestone_points = owed_milestone_points
	# LEVEL POINTS ARE DERIVED FROM THE LEVEL, for the same reason.
	var owed_level_points: int = (state.level - ExperienceTable.STARTING_LEVEL) * ExperienceTable.POINTS_PER_LEVEL
	var stored_level_points: int = int(config.get_value("passives", "level_points", 0))
	if stored_level_points != owed_level_points:
		_correct("stored %d Level point(s); Level %d accounts for %d" % [
			stored_level_points, state.level, owed_level_points,
		])
	state.level_points = owed_level_points
	state.passives.set_earned_points(state.earned_passive_points())

	var wanted: Array[StringName] = []
	for node_id: String in _string_list(config, "passives", "allocated"):
		if state.passives.graph.has(StringName(node_id)):
			wanted.append(StringName(node_id))
		else:
			_correct("unknown Passive node %s was dropped" % node_id)
	var restore_problem: String = state.passives.restore(wanted)
	if not restore_problem.is_empty():
		_correct("the saved allocation was not reachable: %s" % restore_problem)

	for skill_id: String in _string_list(config, "skills", "learned"):
		if library != null and not library.has(StringName(skill_id)):
			_correct("unknown Skill %s was dropped" % skill_id)
			continue
		state.learn_skill(StringName(skill_id))
	var binding_problem: String = state.bindings.from_string_array(
		_string_list(config, "skills", "bindings")
	)
	if not binding_problem.is_empty():
		_correct("the saved bindings were rebuilt: %s" % binding_problem)
		state.bindings = FirstMvpActiveBindings.new()

	_restore_items(state, config, weapon_records)

	if last_corrections.is_empty():
		last_load_status = "loaded schema %d, every value in range" % SCHEMA_VERSION
	else:
		last_load_status = "loaded schema %d; corrected %s" % [SCHEMA_VERSION, ", ".join(last_corrections)]
	return true


## READS A LIST KEY WITHOUT TRUSTING ITS TYPE.
##
## `PackedStringArray(config.get_value(...))` is a CONVERSION, and a hand-edited
## or older file whose key holds an int, a Dictionary or a bare String makes it
## throw. A throw inside `load_into()` aborts the whole function — the D-200
## lesson, where one bad `Resource.get()` silently skipped six of seven
## assertions while the suite still printed PASS. Here the consequence would be
## worse than a skipped check: the half-applied character is kept, reported as a
## new one, and the next autosave writes it back over the real save.
##
## So the type is CHECKED, a wrong one is dropped with a recorded correction, and
## the load continues with an empty list rather than stopping.
func _string_list(config: ConfigFile, section: String, key: String) -> PackedStringArray:
	var raw: Variant = config.get_value(section, key, PackedStringArray())
	var kind: int = typeof(raw)
	if kind == TYPE_PACKED_STRING_ARRAY:
		return raw as PackedStringArray
	if kind == TYPE_ARRAY:
		var out: PackedStringArray = PackedStringArray()
		for entry: Variant in (raw as Array):
			out.append(str(entry))
		return out
	_correct("%s/%s was not a list of strings; it was dropped" % [section, key])
	return PackedStringArray()


func _restore_items(state: CharacterState, config: ConfigFile, weapon_records: Dictionary) -> void:
	if state.equipment == null:
		_correct("this character had no equipment record to restore into")
		return
	for item_id: String in _string_list(config, "items", "owned"):
		var record: PrototypeWeaponData = weapon_records.get(StringName(item_id), null)
		if record == null:
			# The starting weapon is already owned by construction, so its id
			# appearing here is expected rather than a correction.
			if state.equipment.find_owned(StringName(item_id)) == null:
				_correct("unknown item %s was dropped" % item_id)
			continue
		state.equipment.pick_up(record)
	var equipped_id: StringName = StringName(str(config.get_value("items", "equipped", "")))
	if String(equipped_id).is_empty():
		return
	var wanted: PrototypeWeaponData = state.equipment.find_owned(equipped_id)
	if wanted == null:
		_correct("the equipped item %s is not owned; the starting weapon stayed equipped" % equipped_id)
		return
	state.equipment.equip(wanted)


func _clamped_milestone(value: int) -> CharacterState.Milestone:
	var highest: int = CharacterState.Milestone.READY_FOR_FIRST_FOOTING
	return clampi(value, 0, highest) as CharacterState.Milestone


func _clamped_package(value: int) -> CharacterState.FoundationPackage:
	var highest: int = CharacterState.FoundationPackage.SPELL
	return clampi(value, 0, highest) as CharacterState.FoundationPackage


func _correct(reason: String) -> void:
	last_corrections.append(reason)


# --- Start Fresh ---------------------------------------------------------------

## Removes the character file, and NOTHING else. It cannot reach either
## Prototype Zero file: `storage_path` was already refused if it resolved onto
## one, and this asks the guard again rather than trusting that it was.
func delete_saved_character() -> bool:
	if would_touch_prototype_zero():
		saves_refused += 1
		last_save_status = "refused to delete: the storage path resolves onto a Prototype Zero file"
		return false
	if not FileAccess.file_exists(storage_path):
		last_save_status = "nothing to delete at %s" % storage_path
		return true
	var directory: DirAccess = DirAccess.open(storage_path.get_base_dir())
	if directory == null:
		last_save_status = "could not open %s" % storage_path.get_base_dir()
		return false
	var error: Error = directory.remove(storage_path.get_file())
	if error != OK:
		last_save_status = "could not delete %s (error %d)" % [storage_path, error]
		return false
	last_save_status = "deleted %s" % storage_path
	return true


func describe() -> String:
	return "%s — %d save(s) written, %d refused; %s" % [
		storage_path, saves_written, saves_refused, last_load_status,
	]
