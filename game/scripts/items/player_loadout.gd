class_name PlayerLoadout
extends RefCounted
## First-MVP — Gate 1D: the smallest TRUTHFUL item-ownership path (D-217).
##
## Prototype Zero's Gate E deliberately faked this: "Equip" replaced the
## player's weapon reference directly and there was never any concept of
## OWNING an item independent of equipping it — the sword on the ground and
## the sword in hand were the only two states, and picking one up equipped it
## on the same click. Gate 1D's brief calls that shortcut out by name and asks
## for the smallest path that does not reproduce it: notice a drop, pick it
## up, see it compared against what is equipped, and choose to equip it as a
## SEPARATE step.
##
## So this class draws the one line Prototype Zero's item loop did not:
## `owned_items` (what the player is carrying) is distinct from
## `equipped_weapon` (what Quick Strike actually swings). `pick_up()` only
## ever appends to the first; `equip()` is the only thing that ever changes
## the second, and it requires the item to already be owned.
##
## STILL DELIBERATELY NOT THE FIELD PACK. No grid, no cell position, no
## rotation, no stack, no rarity frame, no Favorite, no Mark for Salvage. It is
## a flat list standing in for the real inventory, structured so a future
## Field Pack can become the concrete implementation behind `owned_items`
## without changing `pick_up()`/`equip()`'s call sites — the boundary this
## file exists to keep honest is named in its own report rather than silently
## assumed away.
##
## Idempotence mirrors the two proven patterns this project already validated:
## `PrototypePlayer.equip_weapon()`'s "already equipped is a no-op" rule, and
## `LabProgress`'s reward-door pattern of refusing a duplicate and counting it
## rather than silently repeating it. Equipping never mutates a shared
## canonical `.tres` — it only ever reassigns which loaded Resource reference
## `equipped_weapon` points at (the D-191 rule every prior gate's item code
## already keeps).
##
## Records are `PrototypeWeaponData` — the exact type `PrototypePlayer.weapon`
## is declared as, so `PrototypePlayer` and `QuickStrikeAction` are reused
## completely unmodified rather than forking a parallel player class merely to
## carry a differently-typed record. See `game/data/first_mvp/severed_threshold/
## broken_watch/` for Gate 1D's own two records — new data, not a reuse of
## Prototype Zero's `starter_sword.tres` / `honed_sword.tres`.

var equipped_weapon: PrototypeWeaponData = null
var owned_items: Array[PrototypeWeaponData] = []

## Refusal instrumentation, in the same spirit as `LabProgress.duplicate_attempts_refused`.
var duplicate_attempts_refused: int = 0
var last_refusal: String = "none"

signal weapon_equipped(record: PrototypeWeaponData)
signal item_picked_up(record: PrototypeWeaponData)


func _init(starting_weapon: PrototypeWeaponData) -> void:
	var problem: String = "no starting weapon record" if starting_weapon == null else starting_weapon.problem()
	assert(problem.is_empty(), "PlayerLoadout: %s" % problem)
	equipped_weapon = starting_weapon
	owned_items.append(starting_weapon)


## Adds `record` to what the player is carrying. Idempotent against the SAME
## record instance being offered twice (e.g. a duplicated pickup signal) —
## ownership is decided by object identity, exactly as `LabProgress` decides
## kill-reward eligibility by an enemy's instance id rather than by name.
func pick_up(record: PrototypeWeaponData) -> bool:
	if record == null:
		return _refuse("a null item cannot be picked up")
	if owned_items.has(record):
		return _refuse("%s is already owned; duplicate pickup refused" % record.display_name)
	owned_items.append(record)
	item_picked_up.emit(record)
	return true


func is_owned(record: PrototypeWeaponData) -> bool:
	return record != null and owned_items.has(record)


func is_equipped(record: PrototypeWeaponData) -> bool:
	return record != null and record == equipped_weapon


## Equips an OWNED record. Refuses a record the player does not own — equip
## can never be used as a second pickup path — and is a no-op by construction
## when the record is already equipped, mirroring
## `PrototypePlayer.equip_weapon()`'s own `if record == weapon: return` rule.
func equip(record: PrototypeWeaponData) -> bool:
	if record == null:
		return _refuse("a null item cannot be equipped")
	if not owned_items.has(record):
		return _refuse("%s is not owned; equip refused" % record.display_name)
	if record == equipped_weapon:
		return _refuse("%s is already equipped" % record.display_name)
	equipped_weapon = record
	weapon_equipped.emit(record)
	return true


func _refuse(reason: String) -> bool:
	duplicate_attempts_refused += 1
	last_refusal = reason
	return false


func describe() -> String:
	return "equipped %s; %d item(s) owned; %d duplicate attempt(s) refused" % [
		equipped_weapon.display_name if equipped_weapon != null else "nothing",
		owned_items.size(), duplicate_attempts_refused,
	]
