class_name RogueliteRunState
extends RefCounted
## Riftwrought — Roguelite Core Loop Review: everything one expedition owns,
## and nothing that outlives it (decision D-220).
##
## THIS OBJECT IS THE DEFINITION OF "TEMPORARY RUN-ONLY REWARD", AND THE WHOLE
## DEATH RULE IS "THROW IT AWAY AND BUILD A NEW ONE". There is no `clear()`
## that has to remember every field, because a `clear()` that forgets one
## field is exactly how the Gate 1E adversarial review found Start Fresh
## writing the old character straight back on the next autosave. The runtime
## replaces the whole object, so a field added later cannot be forgotten.
##
## IT IS DELIBERATELY NOT PROGRESSION, AND THE SHAPE SAYS SO. There is no
## experience, no level, no passive point, no currency, no unlock, no
## permanent record, no profile, and no schema version — each of those is a
## first-MVP system with its own authorization, and none of them is in scope.
## Nothing here is written to disk: this class has no save, load, serialize,
## storage_path or `user://` anywhere in it, and the review's verification
## asserts that by scanning the source.
##
## `design/FIRST_MVP_SCOPE_LOCK_AND_INTEGRATION_AUDIT.md` §11 names exactly
## three save-state buckets — 11.1 Profile-Shared, 11.2 Character-Owned, 11.3
## Active-Run State. Everything in this file is 11.3, which is the one bucket
## `design/DEATH_AND_RECOVERY.md` §12's thirteen prohibitions do not protect:
## §2's promise is that death costs "an opportunity and a completion
## bonus — not equipment, experience, or permanent progress", and a run-scoped
## weapon that never existed outside the run is the opportunity, not the
## equipment.

## The plan this run was assembled from. Its `run_id()` is what the player sees.
var plan: RogueliteRunPlan

## Where the player is in the expedition. -1 means "in the hub, not in a run".
var current_room_index: int = -1

## Room indices whose encounters are all defeated, in the order they cleared.
var cleared_rooms: Array[int] = []

## The one guaranteed reward. `granted` is the door (idempotent, in the
## `LabProgress` reward-door spirit); `equipped` records that the player
## actually chose it, which is a different fact and is displayed separately.
var reward_granted: bool = false
var reward_equipped: bool = false

var run_complete: bool = false

## Refusal instrumentation, the same shape `PlayerLoadout` and `LabProgress`
## both carry: a door that refuses says so and counts it.
var refusals: int = 0
var last_refusal: String = "none"


func _init(for_plan: RogueliteRunPlan) -> void:
	plan = for_plan


func in_run() -> bool:
	return current_room_index >= 0 and not run_complete


func room_number() -> int:
	return current_room_index + 1


func total_rooms() -> int:
	return plan.room_count()


func is_cleared(index: int) -> bool:
	return cleared_rooms.has(index)


## Idempotent by construction: a room already recorded is refused and counted
## rather than appended twice.
func mark_cleared(index: int) -> bool:
	if cleared_rooms.has(index):
		return _refuse("room %d was already cleared" % (index + 1))
	cleared_rooms.append(index)
	return true


func grant_reward() -> bool:
	if reward_granted:
		return _refuse("the guaranteed reward was already granted this run")
	reward_granted = true
	return true


func _refuse(reason: String) -> bool:
	refusals += 1
	last_refusal = reason
	return false


func describe() -> String:
	var where: String = "hub"
	if run_complete:
		where = "hub, run complete"
	elif in_run():
		where = "room %d of %d" % [room_number(), total_rooms()]
	return "%s — %s, %d cleared, reward granted=%s equipped=%s, %d refusal(s)" % [
		plan.run_id(), where, cleared_rooms.size(),
		str(reward_granted), str(reward_equipped), refusals,
	]
