class_name LabProgress
extends RefCounted
## Prototype Zero — Gate E: THE authoritative lab-progress record
## (specification §15.2, decision D-184).
##
## D-184: "Gate E commits milestones to one authoritative IN-MEMORY lab-progress
## record only. It does NOT write `user://` files and does not implement Start
## New, Continue, versioned save migration, or recovery from invalid files; those
## belong to Gate F. Here, specification wording such as 'save the milestone'
## means commit the in-session state so current-stage resets and repeated events
## cannot rewind or duplicate it."
##
## So this class has no `save`, no `load`, no `user://` path, no schema version,
## no ConfigFile, and no FileAccess — asserted by name in `gate_e_verification.gd`
## rather than merely intended.
##
## THE CONTRACT THIS FILE EXISTS TO KEEP
##
## Every reward is granted through a method that returns FALSE when it has
## already been granted, and each of those methods is the ONLY way to reach the
## state it owns. The stage machine, the kill signal, the ground drop, the
## comparison, and the passive card all go through these five doors:
##
##   grant_starter_kill_reward()    +10 XP and the one guaranteed sword
##   grant_upgraded_kill_reward()   +10 XP, reaching exactly 20 / 20
##   equip_honed_sword()            the equipped record becomes the Honed Sword
##   confirm_quickened_form()       25% increased Attack Speed becomes active
##   count_repeat_loop_kill()       the ten-kill exit-test counter only
##
## A duplicate kill signal, contact with a corpse, a repeated button press, a
## reopened modal, or a debug current-stage reset can call any of them as often
## as it likes. The second call is a no-op that returns false and says so.
##
## `reset_lab_progress()` is the ONE deliberate clearing door, reached only from
## a clearly labelled debug control (D-184, specification §15.2).

## Specification §15, exactly.
enum Stage {
	STARTER_FIGHT,
	UPGRADE_ON_GROUND,
	UPGRADED_FIGHT,
	PASSIVE_READY,
	REPEAT_LOOP,
}

var data: LabProgressionData

var stage: Stage = Stage.STARTER_FIGHT
var experience: int = 0

# --- The four milestone latches ----------------------------------------------
# Each is written in exactly one place, by the method named after it.
var starter_kill_rewarded: bool = false
var upgraded_kill_rewarded: bool = false
var honed_sword_equipped: bool = false
var quickened_form_active: bool = false

## True while the guaranteed drop is on the ground and has not been equipped.
var sword_on_ground: bool = false

# --- Repeat loop -------------------------------------------------------------
var repeat_loop_kills: int = 0
var wave_index: int = 0
var waves_started: int = 0

# --- Refusal instrumentation (specification §22) ------------------------------
## Every duplicate attempt that was refused, so the idempotence contract is a
## COUNTED fact in the debug surface rather than a silent absence.
var duplicate_attempts_refused: int = 0
var last_refusal: String = "none"
## Eligible enemies that have already paid out, keyed by instance id. This is the
## per-enemy half of §15.2: "Each eligible enemy may reward at most once."
var _rewarded_enemies: Dictionary = {}

signal stage_changed(from: Stage, to: Stage)
signal experience_changed(current: int, maximum: int)
signal milestone_committed(name: String)


func _init(progression: LabProgressionData) -> void:
	data = progression
	var problem: String = "progression data is missing" if data == null else data.problem()
	assert(problem.is_empty(), "LabProgress: %s" % problem)


# --- Stage -------------------------------------------------------------------

func enter_stage(next: Stage) -> void:
	if next == stage:
		return
	var previous: Stage = stage
	stage = next
	stage_changed.emit(previous, next)


func stage_name() -> String:
	match stage:
		Stage.STARTER_FIGHT:
			return "STARTER_FIGHT"
		Stage.UPGRADE_ON_GROUND:
			return "UPGRADE_ON_GROUND"
		Stage.UPGRADED_FIGHT:
			return "UPGRADED_FIGHT"
		Stage.PASSIVE_READY:
			return "PASSIVE_READY"
		_:
			return "REPEAT_LOOP"


# --- Per-enemy reward eligibility --------------------------------------------

## Specification §15.2. Returns true the FIRST time it is asked about a given
## enemy and false every time afterwards, so a duplicate `died` signal, a second
## lethal DamageEvent, or a swing at a corpse cannot pay twice.
##
## The key is the enemy's instance id, which is unique for as long as the body
## exists. The entry is dropped only when the body is freed, and a freed body can
## never emit another kill.
func claim_kill_reward(enemy: Node) -> bool:
	if enemy == null:
		return _refuse("a null enemy claimed a kill reward")
	var key: int = enemy.get_instance_id()
	if _rewarded_enemies.has(key):
		return _refuse("%s already paid its reward; duplicate kill signal refused" % enemy.name)
	_rewarded_enemies[key] = true
	return true


func forget_enemy(enemy: Node) -> void:
	if enemy != null:
		_rewarded_enemies.erase(enemy.get_instance_id())


func rewarded_enemy_count() -> int:
	return _rewarded_enemies.size()


# --- The five reward doors ---------------------------------------------------

## The first eligible kill: exactly 10 XP and the one guaranteed Honed Sword.
func grant_starter_kill_reward() -> bool:
	if starter_kill_rewarded:
		return _refuse("the starter kill reward was already granted")
	starter_kill_rewarded = true
	sword_on_ground = true
	_add_experience(data.experience_per_eligible_kill)
	milestone_committed.emit("starter kill: %d XP and one guaranteed Prototype Honed Sword" % data.experience_per_eligible_kill)
	return true


## The second eligible kill: exactly 10 more XP, reaching exactly 20 / 20.
func grant_upgraded_kill_reward() -> bool:
	if upgraded_kill_rewarded:
		return _refuse("the upgraded kill reward was already granted")
	upgraded_kill_rewarded = true
	_add_experience(data.experience_per_eligible_kill)
	milestone_committed.emit("upgraded kill: %d XP, reaching %d / %d" % [
		data.experience_per_eligible_kill, experience, data.experience_maximum,
	])
	return true


## Equipping directly replaces the deterministic prototype weapon. There is no
## inventory, no pickup capacity, and nothing is destroyed: the Training Sword
## simply stops being the equipped record.
func equip_honed_sword() -> bool:
	if honed_sword_equipped:
		return _refuse("the Honed Sword is already equipped")
	if not starter_kill_rewarded:
		return _refuse("no Honed Sword has been granted yet")
	honed_sword_equipped = true
	sword_on_ground = false
	milestone_committed.emit("equipped the Prototype Honed Sword")
	return true


## Deliberate confirmation of the one contained passive.
func confirm_quickened_form() -> bool:
	if quickened_form_active:
		return _refuse("%s is already active" % data.passive_name)
	if experience < data.experience_maximum:
		return _refuse("%s needs %d / %d XP" % [
			data.passive_name, data.experience_maximum, data.experience_maximum,
		])
	quickened_form_active = true
	milestone_committed.emit("confirmed %s: %s" % [data.passive_name, data.passive_effect_line])
	return true


## The repeat-loop counter for the specification §23.5 ten-kill test. It is a
## count, not a reward: it grants nothing and unlocks nothing.
func count_repeat_loop_kill() -> void:
	repeat_loop_kills += 1


# --- Derived state the room and the player read ------------------------------

## Total increased attack speed from every contained Gate E source. There is
## exactly one source.
func increased_attack_speed() -> float:
	return data.passive_increased_attack_speed if quickened_form_active else 0.0


func experience_is_complete() -> bool:
	return experience >= data.experience_maximum


func experience_line() -> String:
	if experience_is_complete():
		return "XP %d / %d — Complete" % [experience, data.experience_maximum]
	return "XP %d / %d" % [experience, data.experience_maximum]


func next_wave_size() -> int:
	return data.wave_size_for(wave_index)


func advance_wave() -> void:
	wave_index += 1
	waves_started += 1


# --- The one deliberate clearing door ----------------------------------------

## D-184 and specification §15.2: "A clearly labelled debug Reset Lab Progress
## may deliberately clear the in-session sequence." Everything else in this class
## refuses to rewind.
func reset_lab_progress() -> void:
	var previous: Stage = stage
	stage = Stage.STARTER_FIGHT
	experience = 0
	starter_kill_rewarded = false
	upgraded_kill_rewarded = false
	honed_sword_equipped = false
	quickened_form_active = false
	sword_on_ground = false
	repeat_loop_kills = 0
	wave_index = 0
	waves_started = 0
	duplicate_attempts_refused = 0
	last_refusal = "none"
	_rewarded_enemies.clear()
	if previous != Stage.STARTER_FIGHT:
		stage_changed.emit(previous, stage)
	experience_changed.emit(experience, data.experience_maximum)


func describe() -> String:
	return "%s   %s   sword %s   %s   repeat kills %d   waves %d   %d duplicate attempts refused" % [
		stage_name(), experience_line(),
		"Honed (equipped)" if honed_sword_equipped else ("on the ground" if sword_on_ground else "Training"),
		"%s active" % data.passive_name if quickened_form_active else "no passive",
		repeat_loop_kills, waves_started, duplicate_attempts_refused,
	]


# --- Internals ---------------------------------------------------------------

func _add_experience(amount: int) -> void:
	experience = mini(experience + amount, data.experience_maximum)
	experience_changed.emit(experience, data.experience_maximum)


func _refuse(reason: String) -> bool:
	duplicate_attempts_refused += 1
	last_refusal = reason
	return false
