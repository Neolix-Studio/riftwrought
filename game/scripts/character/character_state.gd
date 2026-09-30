class_name CharacterState
extends RefCounted
## First-MVP — Gate 1E: the one authoritative first-MVP character record (D-219).
##
## THIS IS NOT `LabProgress`, AND THE DISTINCTION IS THE POINT. Prototype Zero's
## `LabProgress` is an explicitly in-memory laboratory record that D-184 forbade
## from ever touching disk; its five reward doors describe a contained
## experiment, not a person. This class is the first record in the project that
## belongs to a CHARACTER and survives quitting the game. The brief is explicit:
## "Do not reuse Prototype Zero's progression record as the canonical character
## save."
##
## STATE IS HERE; PERSISTENCE IS IN `CharacterSave`. This class knows nothing
## about files, schemas, or `user://`. That separation is what lets the reward
## doors below be tested without a disk and lets the save format change without
## touching a single rule.
##
## EVERY REWARD IS AN IDEMPOTENT DOOR, and the shape is Prototype Zero's own
## proven one (`LabProgress`): a boolean latch, a refusal that is COUNTED rather
## than silent, and a signal that fires exactly once. The brief lists precisely
## what must not duplicate — the guaranteed Watchsteel, the milestone Passive
## point, the Foundation package, encounter XP — and each of those is one latch
## here. Reloading, restarting, repeating dialogue, changing input device, and
## re-entering a scene all funnel through these same doors, so none of them can
## mint a second reward without the latch being cleared, which only
## `start_fresh()` does.
##
## XP IS ONE-TIME PER ENCOUNTER, BY ENCOUNTER ID, NOT BY KILL. The brief:
## "an encounter grants its canonical XP only once" and "death/restart cannot
## farm the one-time opening encounter through state reset". `awarded_encounters`
## is therefore a set of stable authored ids (`broken_watch_first`,
## `broken_watch_second`) rather than a counter — a Restart respawns the same
## authored Graveblade, and the same authored encounter cannot pay twice.
##
## WHAT THIS DELIBERATELY IS NOT. No Field Pack grid, no rarity, no affix, no
## Wrought Modifier, no crafting ledger, no Rift Shards, no Augments, no
## Configuration, no profile, no second character, no run state. Those are named
## in the Gate 1E brief's own exclusion list and each would have to be added
## here on purpose.

## The safe, irreversible progression points of the canonical opening. Ordered:
## a character is always at exactly one, and it only ever moves forward.
enum Milestone {
	## Created; standing at Riftfall Landing's PlayerStart.
	RIFTFALL_LANDING,
	## Past the Landing, inside Broken Watch.
	BROKEN_WATCH,
	## Broken Watch cleared; the route to the Nexus Threshold is open.
	BROKEN_WATCH_COMPLETE,
	## Inside the Nexus Threshold, which is safe.
	NEXUS_THRESHOLD,
	## The Nexus has responded to the Mark.
	NEXUS_RECOGNITION,
	## Mara's first conversation has been read through at least once.
	MARA_FIRST_CONVERSATION,
	## A Foundation Cache package has been chosen.
	FOUNDATION_CHOSEN,
	## Standing at the closed forward route toward First Footing.
	READY_FOR_FIRST_FOOTING,
}

## The three canonical Foundation Cache directions
## (design/FIRST_MVP_CAMPAIGN_AND_PROGRESSION_JOURNEY.md §7).
enum FoundationPackage {
	NONE,
	HEAVY_MELEE,
	PROJECTILE,
	SPELL,
}

const DEFAULT_NAME: String = "The Survivor"
const CLASS_NAME_CANONICAL: String = "Riftmarked"

# --- Identity ------------------------------------------------------------------
var character_name: String = DEFAULT_NAME
var character_class: String = CLASS_NAME_CANONICAL

# --- Level and experience ------------------------------------------------------
var level: int = ExperienceTable.STARTING_LEVEL
var total_experience: int = 0
## Stable authored encounter ids that have already paid. Never a count.
var awarded_encounters: Dictionary = {}

# --- Passive points ------------------------------------------------------------
## Points from guaranteed story milestones (four across the whole first MVP;
## Gate 1E reaches exactly the first).
var milestone_points: int = 0
## Points from ordinary Levels.
var level_points: int = 0
## The live allocation. Owns the graph, the rules, and the effects.
var passives: PassiveAllocation = PassiveAllocation.new()

# --- Progression ---------------------------------------------------------------
var milestone: Milestone = Milestone.RIFTFALL_LANDING

# --- Reward latches, one per irreversible grant --------------------------------
var watchsteel_granted: bool = false
var watchsteel_equipped_once: bool = false
var broken_watch_complete: bool = false
var nexus_recognition_complete: bool = false
var mara_first_conversation_complete: bool = false
var milestone_passive_point_claimed: bool = false
var foundation_package: FoundationPackage = FoundationPackage.NONE
var foundation_package_granted: bool = false

# --- Skills and bindings -------------------------------------------------------
var learned_skills: Array[StringName] = [&"quick_strike"]
var bindings: FirstMvpActiveBindings = FirstMvpActiveBindings.new()

# --- Items ---------------------------------------------------------------------
## Ownership and equipment. Built by the runtime with the character's starting
## weapon, because `PlayerLoadout` requires one at construction.
var equipment: FirstMvpEquipment = null

# --- Instrumentation, in `LabProgress`'s own spirit ----------------------------
var duplicate_attempts_refused: int = 0
var last_refusal: String = "none"

signal experience_changed(total: int, level: int)
signal level_gained(new_level: int)
signal passive_points_changed(available: int, earned: int)
signal milestone_reached(milestone: Milestone)
signal reward_granted(what: String)


func _init() -> void:
	passives.set_earned_points(0)


## Second-stage construction: the runtime hands the starting weapon in, because
## a character record should not know a resource path.
func adopt_starting_weapon(record: PrototypeWeaponData) -> void:
	equipment = FirstMvpEquipment.new(record)


# --- Experience and Levels -----------------------------------------------------

## Awards `amount` XP for the authored encounter `encounter_id`, exactly once
## for the life of this character. Returns true only when it actually paid.
func award_encounter_experience(encounter_id: StringName, amount: int) -> bool:
	if awarded_encounters.has(encounter_id):
		return _refuse("encounter %s already paid its experience" % encounter_id)
	if amount <= 0:
		return _refuse("encounter %s offered %d experience" % [encounter_id, amount])
	awarded_encounters[encounter_id] = amount
	total_experience += amount
	experience_changed.emit(total_experience, level)
	reward_granted.emit("%d XP for %s" % [amount, encounter_id])
	_apply_levels()
	return true


## Recomputes the level from total XP and grants one ordinary Passive point per
## level gained. Derived rather than incremented, so no path can grant a level's
## point twice — the same rule that makes `PassiveAllocation.spent()` derived.
func _apply_levels() -> void:
	var earned_level: int = ExperienceTable.level_for_total(total_experience)
	while level < earned_level:
		level += 1
		level_points += ExperienceTable.POINTS_PER_LEVEL
		_sync_points()
		level_gained.emit(level)
		reward_granted.emit("Level %d — %d ordinary Passive point" % [level, ExperienceTable.POINTS_PER_LEVEL])


func experience_progress() -> Dictionary:
	return ExperienceTable.progress_for(total_experience)


# --- Passive points ------------------------------------------------------------

func earned_passive_points() -> int:
	return milestone_points + level_points


func available_passive_points() -> int:
	return passives.available()


func _sync_points() -> void:
	passives.set_earned_points(earned_passive_points())
	passive_points_changed.emit(passives.available(), earned_passive_points())


## THE FIRST OF THE FOUR GUARANTEED MILESTONE PASSIVE POINTS
## (design/FIRST_MVP_CAMPAIGN_AND_PROGRESSION_JOURNEY.md §7: "Nexus recognition
## awards the first of four guaranteed milestone Passive points").
##
## Exactly once. Reloading, restarting, repeating the conversation, re-entering
## the Nexus, or changing input device all reach this same latch.
func claim_nexus_recognition_point() -> bool:
	if not nexus_recognition_complete:
		return _refuse("the Nexus has not recognized the Mark yet")
	if milestone_passive_point_claimed:
		return _refuse("the Nexus recognition Passive point was already claimed")
	milestone_passive_point_claimed = true
	milestone_points += 1
	_sync_points()
	reward_granted.emit("Nexus recognition — 1 guaranteed milestone Passive point")
	return true


# --- Milestones ----------------------------------------------------------------

## Milestones only move forward. An earlier one is refused rather than applied,
## so re-entering a space cannot rewind safe irreversible progression — the
## brief's own "Fallen/Restart does not rewind safe irreversible Nexus
## progression" requirement, enforced in one place.
func reach(next: Milestone) -> bool:
	if int(next) <= int(milestone):
		return _refuse("milestone %s is not ahead of %s" % [
			CharacterState.milestone_name(next), CharacterState.milestone_name(milestone),
		])
	milestone = next
	milestone_reached.emit(milestone)
	return true


func has_reached(wanted: Milestone) -> bool:
	return int(milestone) >= int(wanted)


static func milestone_name(value: Milestone) -> String:
	match value:
		Milestone.RIFTFALL_LANDING:
			return "Riftfall Landing"
		Milestone.BROKEN_WATCH:
			return "Broken Watch"
		Milestone.BROKEN_WATCH_COMPLETE:
			return "Broken Watch complete"
		Milestone.NEXUS_THRESHOLD:
			return "Nexus Threshold"
		Milestone.NEXUS_RECOGNITION:
			return "the Nexus recognized the Mark"
		Milestone.MARA_FIRST_CONVERSATION:
			return "Mara's first conversation"
		Milestone.FOUNDATION_CHOSEN:
			return "Foundation Cache chosen"
		_:
			return "ready for First Footing"


# --- The Gate 1D reward, carried into the integrated opening -------------------

## The guaranteed Watchsteel Sword from the first Graveblade. Gate 1D's own
## `_drop_granted` latch is scene-local and dies with the scene; this one
## belongs to the character and is saved, so a reload cannot produce a second.
func grant_watchsteel(record: PrototypeWeaponData) -> bool:
	if watchsteel_granted:
		return _refuse("the guaranteed Watchsteel Sword was already granted")
	if record == null:
		return _refuse("no Watchsteel record was offered")
	watchsteel_granted = true
	reward_granted.emit("guaranteed weapon improvement: %s" % record.display_name)
	return true


func note_watchsteel_equipped() -> void:
	watchsteel_equipped_once = true


func complete_broken_watch() -> bool:
	if broken_watch_complete:
		return _refuse("Broken Watch was already complete")
	broken_watch_complete = true
	reach(Milestone.BROKEN_WATCH_COMPLETE)
	reward_granted.emit("Broken Watch complete")
	return true


# --- The Nexus beats -----------------------------------------------------------

func complete_nexus_recognition() -> bool:
	if nexus_recognition_complete:
		return _refuse("the Nexus already recognized the Mark")
	nexus_recognition_complete = true
	reach(Milestone.NEXUS_RECOGNITION)
	reward_granted.emit("the Nexus recognized the Mark")
	return true


func complete_mara_first_conversation() -> bool:
	if mara_first_conversation_complete:
		return _refuse("Mara's first conversation was already read")
	mara_first_conversation_complete = true
	reach(Milestone.MARA_FIRST_CONVERSATION)
	return true


# --- The Foundation Cache ------------------------------------------------------

## Chooses and grants exactly one package, once per character. The Skill and the
## weapon are handed in by the runtime rather than resolved here, so this record
## stays free of resource paths.
func choose_foundation_package(
	package: FoundationPackage, skill_id: StringName, weapon: FirstMvpWeaponRecord
) -> bool:
	if foundation_package_granted:
		return _refuse("a Foundation Cache package was already chosen")
	if package == FoundationPackage.NONE:
		return _refuse("no Foundation Cache package was chosen")
	if weapon == null:
		return _refuse("the chosen package offered no weapon")
	if equipment == null:
		return _refuse("this character has no equipment record yet")
	foundation_package = package
	foundation_package_granted = true
	learn_skill(skill_id)
	equipment.pick_up(weapon)
	reach(Milestone.FOUNDATION_CHOSEN)
	reward_granted.emit("Foundation Cache: %s and %s" % [skill_id, weapon.display_name])
	return true


static func package_name(package: FoundationPackage) -> String:
	match package:
		FoundationPackage.HEAVY_MELEE:
			return "Heavy melee"
		FoundationPackage.PROJECTILE:
			return "Projectile"
		FoundationPackage.SPELL:
			return "Spell"
		_:
			return "none"


# --- Skills --------------------------------------------------------------------

func learn_skill(skill_id: StringName) -> bool:
	if skill_id in learned_skills:
		return _refuse("%s is already learned" % skill_id)
	learned_skills.append(skill_id)
	reward_granted.emit("learned %s" % skill_id)
	return true


func knows_skill(skill_id: StringName) -> bool:
	return skill_id in learned_skills


# --- Reset ---------------------------------------------------------------------

## Start Fresh Opening. Clears EXACTLY this first-MVP character and nothing
## else: it does not touch `PrototypeSettings`, `PrototypeLabState`, or any
## Prototype Zero file — those live behind `PrototypeStoragePaths` guards that
## `CharacterSave` cannot address in the first place.
func start_fresh() -> void:
	var starting_weapon: PrototypeWeaponData = null
	if equipment != null and not equipment.owned_items.is_empty():
		starting_weapon = equipment.owned_items[0]
	character_name = DEFAULT_NAME
	character_class = CLASS_NAME_CANONICAL
	level = ExperienceTable.STARTING_LEVEL
	total_experience = 0
	awarded_encounters.clear()
	milestone_points = 0
	level_points = 0
	passives = PassiveAllocation.new()
	passives.set_earned_points(0)
	milestone = Milestone.RIFTFALL_LANDING
	watchsteel_granted = false
	watchsteel_equipped_once = false
	broken_watch_complete = false
	nexus_recognition_complete = false
	mara_first_conversation_complete = false
	milestone_passive_point_claimed = false
	foundation_package = FoundationPackage.NONE
	foundation_package_granted = false
	learned_skills = [&"quick_strike"]
	bindings = FirstMvpActiveBindings.new()
	if starting_weapon != null:
		equipment = FirstMvpEquipment.new(starting_weapon)
	duplicate_attempts_refused = 0
	last_refusal = "none"
	_sync_points()


func _refuse(reason: String) -> bool:
	duplicate_attempts_refused += 1
	last_refusal = reason
	return false


func describe() -> String:
	return "%s, %s — %s; %d Passive point(s) available of %d earned; milestone %s; %s" % [
		character_name, character_class, ExperienceTable.describe(total_experience),
		available_passive_points(), earned_passive_points(),
		CharacterState.milestone_name(milestone),
		equipment.describe() if equipment != null else "no equipment record",
	]
