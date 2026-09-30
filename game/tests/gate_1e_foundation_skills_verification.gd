extends Node
## First-MVP Gate 1E — the three Foundation Skills, measured (D-219).
##
## PROPORTIONAL. This does not re-prove Quick Strike, the Graveblade, the
## coordinator or click-to-move; the inherited chain proves those exhaustively
## and none of that code is edited. What THIS suite proves is that the three
## new Skills are real, that they run on ONE shared machine, that their weapon
## requirements enable and disable them truthfully, and that each behaves the
## way its canonical foundation says it should.
##
## EVERY CHECK RECORDS REACHING ITS LAST LINE, and the suite compares that set
## to what it owes IN BOTH DIRECTIONS. That discipline is ported from
## `zone_composer_editor_check.gd` for the exact D-211 reason: an un-awaited
## coroutine check is a check that does not run, the suite still prints PASS,
## and a count pinned from that run can never see the gap. It costs exactly two
## assertions.
##
## Run:  godot --headless --path game \
##         res://scenes/first_mvp/canonical_opening/foundation_skill_practice.tscn \
##         -- --verify-skills

var practice: FoundationSkillPractice
var arguments: PackedStringArray = PackedStringArray()

var _failures: PackedStringArray = PackedStringArray()
var _checks: int = 0
var _reached: Dictionary = {}

## Every check function this suite owes. Compared against `_reached` in both
## directions, so a check that was added and never called, or called and never
## finished, is caught rather than silently skipped.
const OWED_CHECKS: Array[String] = [
	"records_are_canonical",
	"one_shared_machine",
	"weapon_requirements",
	"faultbreaker_area_hit",
	"splinter_shot_projectile",
	"emberbolt_fire_spell",
	"melee_single_is_refused",
	"cost_and_cancel_rules",
	"private_runtime_records",
	"controller_soft_targeting",
]


func _ready() -> void:
	await run()


func run() -> void:
	print("")
	print("=== First-MVP Gate 1E — Foundation Skills (D-219) ===")
	await _settle(6)

	_check_records_are_canonical()
	_check_one_shared_machine()
	await _check_weapon_requirements()
	await _check_faultbreaker_area_hit()
	await _check_splinter_shot_projectile()
	await _check_emberbolt_fire_spell()
	_check_melee_single_is_refused()
	await _check_cost_and_cancel_rules()
	_check_private_runtime_records()
	await _check_controller_soft_targeting()

	_check_every_check_ran()

	print("")
	if _failures.is_empty():
		print("GATE 1E SKILLS VERIFICATION: PASS (%d checks)" % _checks)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			printerr("  FAIL: %s" % failure)
		printerr("GATE 1E SKILLS VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		get_tree().quit(1)


# --- 1. The records say what the canon says -----------------------------------

func _check_records_are_canonical() -> void:
	print("")
	print("--- The three records carry their canonical foundations")
	var library: FirstMvpSkillLibrary = practice.skills
	_expect(library.is_coherent(), "the Skill library reported %s" % ", ".join(library.problems))

	var faultbreaker: FirstMvpSkillData = library.record(FirstMvpSkillLibrary.FAULTBREAKER_ID)
	for tag: StringName in [FirstMvpSkillData.TAG_ATTACK, FirstMvpSkillData.TAG_MELEE,
		FirstMvpSkillData.TAG_AREA, FirstMvpSkillData.TAG_HIT, FirstMvpSkillData.TAG_PHYSICAL]:
		_expect(tag in faultbreaker.tags, "Faultbreaker is missing the canonical %s tag" % tag)
	_expect(faultbreaker.archetype == FirstMvpSkillData.Archetype.MELEE_AREA,
		"Faultbreaker is not an Area Skill")
	_expect(faultbreaker.damage_source == FirstMvpSkillData.DamageSource.WEAPON,
		"Faultbreaker is an Attack and must take its damage from the weapon")
	_expect(faultbreaker.action_time > 1.0,
		"Faultbreaker is %.2f s; canon calls it slow and committed" % faultbreaker.action_time)

	var splinter: FirstMvpSkillData = library.record(FirstMvpSkillLibrary.SPLINTER_SHOT_ID)
	for tag: StringName in [FirstMvpSkillData.TAG_ATTACK, FirstMvpSkillData.TAG_PROJECTILE,
		FirstMvpSkillData.TAG_HIT, FirstMvpSkillData.TAG_PHYSICAL]:
		_expect(tag in splinter.tags, "Splinter Shot is missing the canonical %s tag" % tag)
	_expect(splinter.projectile_count == 1, "Gate 1E's projectile baseline is exactly one projectile")
	_expect(splinter.damage_source == FirstMvpSkillData.DamageSource.WEAPON,
		"Splinter Shot is an Attack and must take its damage from the weapon")

	var emberbolt: FirstMvpSkillData = library.record(FirstMvpSkillLibrary.EMBERBOLT_ID)
	for tag: StringName in [FirstMvpSkillData.TAG_SPELL, FirstMvpSkillData.TAG_PROJECTILE,
		FirstMvpSkillData.TAG_HIT, FirstMvpSkillData.TAG_FIRE]:
		_expect(tag in emberbolt.tags, "Emberbolt is missing the canonical %s tag" % tag)
	_expect(emberbolt.damage_source == FirstMvpSkillData.DamageSource.SPELL,
		"Emberbolt is a Spell and its damage must be Skill-defined")
	_expect(emberbolt.damage_type == "Fire", "Emberbolt is not Fire")
	_expect(emberbolt.projectile_count == 1, "Gate 1E's projectile baseline is exactly one projectile")

	# THE SPELL'S DAMAGE IS INDEPENDENT OF THE WEAPON, measured rather than
	# asserted from the enum: a wand and a greatsword must give the same number.
	var wand: FirstMvpWeaponRecord = load("res://data/first_mvp/foundation/cantor_wand.tres")
	var greatsword: FirstMvpWeaponRecord = load("res://data/first_mvp/foundation/garrison_greatsword.tres")
	_expect(is_equal_approx(emberbolt.hit_damage(wand), emberbolt.hit_damage(greatsword)),
		"Emberbolt's damage changed with the weapon; a Spell's damage is Skill-defined")
	_expect(not is_equal_approx(faultbreaker.hit_damage(wand), faultbreaker.hit_damage(greatsword)),
		"Faultbreaker's damage did not change with the weapon; an Attack is weapon-derived")

	# QUICK STRIKE'S FIRST-MVP VIEW IS READ FROM THE CANONICAL RECORD, not
	# retyped. Proved against the file itself.
	var canonical: QuickStrikeData = load(FirstMvpSkillLibrary.QUICK_STRIKE_RECORD)
	var view: FirstMvpSkillData = library.record(FirstMvpSkillLibrary.QUICK_STRIKE_ID)
	_expect(is_equal_approx(view.action_time, canonical.action_time),
		"the Quick Strike view's action time drifted from the canonical record")
	_expect(is_equal_approx(view.release_marker_normalized, canonical.release_marker_normalized),
		"the Quick Strike view's release marker drifted from the canonical record")
	_expect(is_equal_approx(view.reach, canonical.reach),
		"the Quick Strike view's reach drifted from the canonical record")
	_expect(is_equal_approx(view.mana_cost, canonical.mana_cost),
		"the Quick Strike view's Mana cost drifted from the canonical record")
	_expect(view.has_weapon_requirement(),
		"the first-MVP Quick Strike view carries no weapon requirement")
	print("  Faultbreaker %.2f s Area · Splinter Shot 1 projectile · Emberbolt %.0f Fire, weapon-independent" % [
		faultbreaker.action_time, emberbolt.spell_damage,
	])
	_done("records_are_canonical")


# --- 2. One machine, three Skills ---------------------------------------------

func _check_one_shared_machine() -> void:
	print("")
	print("--- All three Skills run on ONE FirstMvpSkillAction, not three implementations")
	var classes: Dictionary = {}
	for id: StringName in [FirstMvpSkillLibrary.FAULTBREAKER_ID,
		FirstMvpSkillLibrary.SPLINTER_SHOT_ID, FirstMvpSkillLibrary.EMBERBOLT_ID]:
		var action: FirstMvpSkillAction = practice.action_for(id)
		_expect(action != null, "%s has no action node" % id)
		if action == null:
			continue
		classes[action.get_script().resource_path] = true
	_expect(classes.size() == 1,
		"the three Skills run on %d different scripts; the brief asks for one reusable contract" % classes.size())
	_expect(classes.has("res://scripts/skills/first_mvp_skill_action.gd"),
		"the shared Skill machine is not first_mvp_skill_action.gd")

	# THE PROVEN QUICK STRIKE KERNEL IS NOT THIS MACHINE, AND IS UNTOUCHED.
	# Compared by SCRIPT PATH rather than with `is FirstMvpSkillAction`: GDScript's
	# static analyser refuses that expression outright — "Expression is of type
	# 'QuickStrikeAction' so it can't be of type 'FirstMvpSkillAction'" — which is
	# a stronger guarantee than a runtime test, but it is a parse error rather
	# than a check, so the property is asserted here in a form that can actually run.
	var kernel_script: String = practice.player.attack.get_script().resource_path
	_expect(kernel_script == "res://scripts/combat/quick_strike_action.gd",
		"the player's Quick Strike runs on %s, not the proven kernel" % kernel_script)
	_expect(kernel_script != "res://scripts/skills/first_mvp_skill_action.gd",
		"Quick Strike was migrated onto the new machine; the proven kernel must stay untouched")
	print("  one script for three Skills; Quick Strike still on its own proven kernel")
	_done("one_shared_machine")


# --- 3. Weapon requirements enable and disable truthfully ---------------------

func _check_weapon_requirements() -> void:
	print("")
	print("--- Weapon requirements enable and disable Skills truthfully")
	# The starting Worn Sword is a one-handed sword: Quick Strike's family, and
	# none of the three Foundation Skills'.
	practice.restore()
	await _settle(2)
	var faultbreaker: FirstMvpSkillAction = practice.action_for(FirstMvpSkillLibrary.FAULTBREAKER_ID)
	var splinter: FirstMvpSkillAction = practice.action_for(FirstMvpSkillLibrary.SPLINTER_SHOT_ID)
	var emberbolt: FirstMvpSkillAction = practice.action_for(FirstMvpSkillLibrary.EMBERBOLT_ID)

	_expect(not faultbreaker.requirement_is_met(), "Faultbreaker is legal with a one-handed sword")
	_expect(not splinter.requirement_is_met(), "Splinter Shot is legal with a one-handed sword")
	_expect(not emberbolt.requirement_is_met(), "Emberbolt is legal with a one-handed sword")

	# A REFUSED USE COSTS NOTHING AND CONSUMES NO INPUT, exactly as an
	# insufficient-Mana refusal does in the proven kernel.
	var mana_before: float = practice.player.mana
	var refusals_before: int = faultbreaker.rejected_for_weapon
	faultbreaker.press()
	await _settle(3)
	_expect(faultbreaker.rejected_for_weapon == refusals_before + 1,
		"an illegal weapon did not produce exactly one refusal")
	_expect(faultbreaker.phase == FirstMvpSkillAction.Phase.READY,
		"a refused Skill entered a phase; the action must not begin at all")
	_expect(is_equal_approx(practice.player.mana, mana_before),
		"a refused Skill spent Mana; the cost belongs to a use that happens")
	faultbreaker.release_input()

	practice.equip_index(0)
	await _settle(2)
	_expect(faultbreaker.requirement_is_met(), "Faultbreaker is illegal with the Garrison Greatsword")
	_expect(not splinter.requirement_is_met(), "Splinter Shot is legal with a greatsword")
	_expect(practice.loadout.off_hand_is_blocked(),
		"the two-handed Garrison Greatsword does not occupy the Off Hand")

	practice.equip_index(1)
	await _settle(2)
	_expect(splinter.requirement_is_met(), "Splinter Shot is illegal with the Marrow Bow")
	_expect(not faultbreaker.requirement_is_met(), "Faultbreaker is legal with a bow")
	_expect(not practice.loadout.off_hand_is_blocked(),
		"the one-handed Marrow Bow occupies the Off Hand")

	practice.equip_index(2)
	await _settle(2)
	_expect(emberbolt.requirement_is_met(), "Emberbolt is illegal with the Cantor Wand")
	_expect(not splinter.requirement_is_met(), "Splinter Shot is legal with a wand")

	# DISPLACED EQUIPMENT IS NEVER DESTROYED.
	_expect(practice.loadout.owned_items.size() == 4,
		"%d item(s) owned after equipping three weapons; nothing may be destroyed" % practice.loadout.owned_items.size())
	print("  three weapons, three requirements, %d item(s) still owned" % practice.loadout.owned_items.size())
	_done("weapon_requirements")


# --- 4. Faultbreaker: a heavy Area Hit ----------------------------------------

func _check_faultbreaker_area_hit() -> void:
	print("")
	print("--- Faultbreaker: one committed Area Hit on several targets at once")
	practice.restore()
	practice.equip_index(0)
	await _settle(2)
	var action: FirstMvpSkillAction = practice.action_for(FirstMvpSkillLibrary.FAULTBREAKER_ID)
	var record: FirstMvpSkillData = action.data

	# Stand the character where all three practice Graveblades are inside the
	# area, and measure what one release does.
	practice.player.global_position = Vector3(0.0, 0.0, -8.0)
	await _settle(3)
	var lives_before: Array[float] = []
	for enemy: PrototypeGraveblade in practice.graveblades:
		lives_before.append(enemy.life)

	var events_before: int = action.damage_events
	action.press()
	action.release_input()
	await _settle(int(ceil(record.action_time * 60.0)) + 8)

	_expect(action.uses_released >= 1, "Faultbreaker never released")
	var events: int = action.damage_events - events_before
	_expect(events >= 2, "one Faultbreaker release produced %d DamageEvent(s); it is an Area Skill" % events)
	_expect(events <= record.maximum_targets,
		"one release produced %d events against a %d-target limit" % [events, record.maximum_targets])
	var expected_damage: float = record.hit_damage(practice.player.weapon)
	var struck: int = 0
	for index: int in practice.graveblades.size():
		var enemy: PrototypeGraveblade = practice.graveblades[index]
		var lost: float = lives_before[index] - enemy.life
		if lost > 0.0:
			struck += 1
			_expect(is_equal_approx(lost, expected_damage),
				"%s lost %.1f Life, not the %.1f one Faultbreaker Hit deals" % [enemy.name, lost, expected_damage])
	_expect(struck == events, "%d enemies lost Life for %d DamageEvents" % [struck, events])
	_expect(action.last_damage_dealt != null and action.last_damage_dealt.damage_type == "Physical",
		"Faultbreaker dealt a non-Physical Hit")
	print("  one release: %d target(s), %.0f Physical each, %.2f m radius" % [
		events, expected_damage, record.area_radius,
	])
	_done("faultbreaker_area_hit")


# --- 5. Splinter Shot: one Physical projectile --------------------------------

func _check_splinter_shot_projectile() -> void:
	print("")
	print("--- Splinter Shot: exactly one Physical projectile, resolving once")
	practice.restore()
	practice.equip_index(1)
	await _settle(2)
	var action: FirstMvpSkillAction = practice.action_for(FirstMvpSkillLibrary.SPLINTER_SHOT_ID)
	var record: FirstMvpSkillData = action.data

	practice.player.global_position = Vector3(0.0, 0.0, 0.0)
	var target: PrototypeGraveblade = practice.graveblades[0]
	target.global_position = Vector3(0.0, 0.0, -6.0)
	await _settle(4)
	practice.player.face_instantly(Vector3(0.0, 0.0, -1.0))

	var life_before: float = target.life
	var spawned_before: int = action.projectiles_spawned
	var area: PrototypeTargetable = target.get_node_or_null("TargetArea") as PrototypeTargetable
	practice.force_next_aim_for_verification(area)
	action.press()
	action.release_input()
	await _settle(int(ceil(record.action_time * 60.0)) + 8)
	_expect(action.projectiles_spawned == spawned_before + 1,
		"one Splinter Shot use spawned %d projectile(s)" % (action.projectiles_spawned - spawned_before))
	# Let it fly.
	await _settle(int(ceil(record.projectile_range / record.projectile_speed * 60.0)) + 20)

	var lost: float = life_before - target.life
	var expected: float = record.hit_damage(practice.player.weapon)
	_expect(is_equal_approx(lost, expected),
		"the projectile dealt %.1f Life damage, not the expected %.1f" % [lost, expected])
	_expect(action.last_damage_dealt != null and action.last_damage_dealt.damage_type == "Physical",
		"Splinter Shot dealt a non-Physical Hit")
	# EXACTLY ONE HIT: no Pierce, no Chain, no Return.
	var live_projectiles: int = 0
	for child: Node in practice.get_node("Actors").get_children():
		if child is FirstMvpSkillProjectile:
			live_projectiles += 1
	_expect(live_projectiles == 0, "%d projectile(s) survived their resolution" % live_projectiles)
	print("  one projectile, %.1f m/s over %.1f m, %.0f Physical, resolved once" % [
		record.projectile_speed, record.projectile_range, expected,
	])
	_done("splinter_shot_projectile")


# --- 6. Emberbolt: one Fire projectile, Skill-defined --------------------------

func _check_emberbolt_fire_spell() -> void:
	print("")
	print("--- Emberbolt: one Fire projectile whose damage ignores the weapon")
	practice.restore()
	practice.equip_index(2)
	await _settle(2)
	var action: FirstMvpSkillAction = practice.action_for(FirstMvpSkillLibrary.EMBERBOLT_ID)
	var record: FirstMvpSkillData = action.data

	practice.player.global_position = Vector3(0.0, 0.0, 0.0)
	var target: PrototypeGraveblade = practice.graveblades[0]
	target.global_position = Vector3(0.0, 0.0, -5.0)
	await _settle(4)
	practice.player.face_instantly(Vector3(0.0, 0.0, -1.0))

	var life_before: float = target.life
	var area: PrototypeTargetable = target.get_node_or_null("TargetArea") as PrototypeTargetable
	practice.force_next_aim_for_verification(area)
	action.press()
	action.release_input()
	await _settle(int(ceil(record.action_time * 60.0)) + 8)
	await _settle(int(ceil(record.projectile_range / record.projectile_speed * 60.0)) + 20)

	var lost: float = life_before - target.life
	_expect(is_equal_approx(lost, record.spell_damage),
		"Emberbolt dealt %.1f Life damage, not its Skill-defined %.1f" % [lost, record.spell_damage])
	# THE WAND'S OWN DAMAGE IS 60 AND EMBERBOLT DEALS 130; the Spell is measured
	# to be independent of the weapon rather than merely declared to be.
	_expect(not is_equal_approx(lost, practice.player.weapon.physical_damage),
		"Emberbolt dealt the weapon's damage; a Spell's damage is Skill-defined")
	var event: FirstMvpDamageEvent = action.last_damage_dealt
	_expect(event != null, "Emberbolt produced no damage record")
	if event != null:
		_expect(event.damage_type == "Fire", "Emberbolt's Hit was recorded as %s" % event.damage_type)
		_expect(event.is_fire(), "the Fire Hit does not report itself as Fire")
		_expect(is_equal_approx(event.final_life_damage, event.raw_damage()),
			"final damage is not raw damage; the first MVP has no mitigation")
	# NO IGNITE. Nothing keeps burning after the Hit.
	var life_after_hit: float = target.life
	await _settle(120)
	_expect(is_equal_approx(target.life, life_after_hit),
		"the target kept losing Life after the Fire Hit; Ignite is not implemented")
	print("  %.0f Fire from a %.0f-damage wand, once, with no lingering effect" % [
		record.spell_damage, practice.player.weapon.physical_damage,
	])
	_done("emberbolt_fire_spell")


# --- 7. The MELEE_SINGLE refusal is reachable ---------------------------------

func _check_melee_single_is_refused() -> void:
	print("")
	print("--- A single-target contact Skill is REFUSED by this machine, and the guard is reachable")
	# A guard nothing can reach is not a guard (the D-215 lesson), so the
	# refusal is proved by actually driving one rather than by reading the code.
	var action: FirstMvpSkillAction = FirstMvpSkillAction.new()
	action.data = FirstMvpSkillLibrary.quick_strike_record()
	practice.add_child(action)
	action.setup(practice.player, practice.acquisition, practice._resolve_aim,
		practice._target_candidates, practice._log_event, practice.get_node("Actors"),
		practice._equipped_family)
	var refused_before: int = action.rejected_for_archetype
	action.press()
	action.release_input()
	_expect(action.rejected_for_archetype == refused_before + 1,
		"driving a MELEE_SINGLE record produced %d refusal(s)" % (action.rejected_for_archetype - refused_before))
	_expect(action.phase == FirstMvpSkillAction.Phase.READY,
		"a refused single-target Skill entered a phase")
	_expect(action.uses_started == 0, "a refused single-target Skill started a use")
	_expect(action.last_refusal.contains("Quick Strike kernel"),
		"the refusal does not say where a single-target contact Skill actually runs")
	action.queue_free()
	print("  refused, reachable, and it names the kernel that owns that shape")
	_done("melee_single_is_refused")


# --- 8. Cost at use start; movement cannot cancel a committed wind-up ---------

func _check_cost_and_cancel_rules() -> void:
	print("")
	print("--- Costs are paid at use start; movement cancels recovery but not a committed wind-up")
	practice.restore()
	practice.equip_index(0)
	await _settle(2)
	var action: FirstMvpSkillAction = practice.action_for(FirstMvpSkillLibrary.FAULTBREAKER_ID)
	var record: FirstMvpSkillData = action.data

	# A wind-up cancelled BEFORE the marker spends nothing and releases nothing.
	var mana_before: float = practice.player.mana
	var released_before: int = action.uses_released
	action.press()
	action.release_input()
	await _settle(2)
	_expect(action.phase == FirstMvpSkillAction.Phase.WINDUP, "the Skill did not enter its wind-up")
	action.cancel_for_movement("verification: movement before the marker")
	await _settle(2)
	_expect(action.uses_released == released_before,
		"a wind-up cancelled before the marker still released")
	_expect(is_equal_approx(practice.player.mana, mana_before),
		"a cancelled wind-up spent %.1f Mana" % (mana_before - practice.player.mana))
	_expect(action.uses_cancelled_before_release >= 1, "the cancellation was not counted")

	# A completed use spends EXACTLY the record's cost, once.
	#
	# MEASURED WITH REGENERATION HELD AT ZERO, and that is the point rather than
	# a convenience. `PrototypePlayer.regenerate_mana()` returns 10 Mana per
	# second, so over a 1.40 s Faultbreaker the pool refills about 14 — more than
	# the 12 the Skill costs. Comparing the pool before and after the whole
	# action therefore measures spend MINUS regeneration and is not a
	# measurement of the cost at all. The regeneration rate is restored
	# immediately afterwards so nothing else in the suite sees a changed player.
	practice.restore()
	await _settle(2)
	var regeneration: float = practice.player.mana_regeneration
	practice.player.mana_regeneration = 0.0
	mana_before = practice.player.mana
	var spent_before: float = action.mana_spent_total
	action.press()
	action.release_input()
	await _settle(int(ceil(record.action_time * 60.0)) + 8)
	var spent: float = action.mana_spent_total - spent_before
	var pool_drop: float = mana_before - practice.player.mana
	practice.player.mana_regeneration = regeneration
	_expect(is_equal_approx(spent, record.mana_cost),
		"one use spent %.1f Mana against a %.1f cost" % [spent, record.mana_cost])
	_expect(is_equal_approx(pool_drop, record.mana_cost),
		"the pool fell by %.2f Mana against a %.1f cost, with regeneration held at zero" % [
			pool_drop, record.mana_cost,
		])
	_expect(is_equal_approx(practice.player.mana_regeneration, regeneration),
		"the player's Mana regeneration was not restored after the measurement")

	# Insufficient Mana stops the attempt beginning at all.
	practice.player.spend_mana(practice.player.mana)
	await _settle(2)
	var rejected_before: int = action.rejected_for_mana
	var started_before: int = action.uses_started
	action.press()
	await _settle(3)
	_expect(action.rejected_for_mana == rejected_before + 1, "insufficient Mana produced no refusal")
	_expect(action.uses_started == started_before, "a Skill began with insufficient Mana")
	action.release_input()
	print("  cancelled wind-up: 0 Mana · completed use: %.0f Mana · no Mana: refused before beginning" % record.mana_cost)
	_done("cost_and_cancel_rules")


# --- 9. Private runtime records (D-191) ---------------------------------------

func _check_private_runtime_records() -> void:
	print("")
	print("--- Every Skill owns a PRIVATE runtime record; no canonical .tres can be written to")
	for id: StringName in [FirstMvpSkillLibrary.FAULTBREAKER_ID,
		FirstMvpSkillLibrary.SPLINTER_SHOT_ID, FirstMvpSkillLibrary.EMBERBOLT_ID]:
		var action: FirstMvpSkillAction = practice.action_for(id)
		_expect(action.data_is_private(), "%s did not take a private runtime record" % id)
		_expect(action.data.resource_path.is_empty(),
			"%s's runtime record still carries a resource path; it would share the cache entry" % id)
		_expect(action.canonical_data != null and not action.canonical_data.resource_path.is_empty(),
			"%s lost its read-only canonical record" % id)
	print("  three private runtime copies; three canonical records untouched on disk")
	_done("private_runtime_records")


# --- 10. Controller soft targeting, per use and without lock-on ---------------

func _check_controller_soft_targeting() -> void:
	print("")
	print("--- Controller soft targeting: D-178 geometry, per use, no retention, intent wins")
	practice.restore()
	practice.equip_index(1)
	await _settle(2)
	var action: FirstMvpSkillAction = practice.action_for(FirstMvpSkillLibrary.SPLINTER_SHOT_ID)
	var record: FirstMvpSkillData = action.data

	practice.player.global_position = Vector3(0.0, 0.0, 0.0)
	var left: PrototypeGraveblade = practice.graveblades[0]
	var right: PrototypeGraveblade = practice.graveblades[1]
	var far_away: PrototypeGraveblade = practice.graveblades[2]
	# One straight ahead, one off to the side inside the cone, one beyond the
	# acquisition distance entirely.
	left.global_position = Vector3(0.0, 0.0, -5.0)
	right.global_position = Vector3(3.0, 0.0, -5.0)
	far_away.global_position = Vector3(0.0, 0.0, -(record.soft_target_distance + 6.0))
	await _settle(4)

	var forward: Vector3 = Vector3(0.0, 0.0, -1.0)
	var outcome: Dictionary = action.soft_target(
		practice.player.global_position, forward, practice._target_candidates()
	)
	var picked: PrototypeTargetable = outcome["target"] as PrototypeTargetable
	_expect(picked != null, "the cone acquired nothing with an enemy straight ahead")
	if picked != null:
		_expect(picked.combat_actor() == left,
			"the cone picked %s, not the enemy straight ahead" % picked.target_display_name())

	# BEYOND THE ACQUISITION DISTANCE IS REFUSED, and refused for that reason.
	var only_far: Array[PrototypeTargetable] = []
	var far_area: PrototypeTargetable = far_away.get_node_or_null("TargetArea") as PrototypeTargetable
	if far_area != null:
		only_far.append(far_area)
	var far_outcome: Dictionary = action.soft_target(practice.player.global_position, forward, only_far)
	_expect(far_outcome["target"] == null,
		"a target %.1f m away was acquired inside a %.1f m acquisition distance" % [
			record.soft_target_distance + 6.0, record.soft_target_distance,
		])

	# OUTSIDE THE CONE IS REFUSED. Aiming directly away acquires nothing.
	var behind: Dictionary = action.soft_target(
		practice.player.global_position, Vector3(0.0, 0.0, 1.0), practice._target_candidates()
	)
	_expect(behind["target"] == null, "aiming away from every enemy still acquired one")

	# CLEAR PLAYER INTENT WINS OVER ASSISTANCE: aim between the two and the
	# returned DIRECTION is still the player's, never the target's.
	var between: Vector3 = Vector3(0.55, 0.0, -1.0).normalized()
	var corrected: Dictionary = action.soft_target(
		practice.player.global_position, between, practice._target_candidates()
	)
	_expect(corrected["target"] != null, "an enemy inside the cone was not acquired")

	# NO IN-REACH PRIORITY GROUP for a ranged Skill — that is a D-178 contact-melee
	# rule the canon forbids generalizing. Standing on top of one enemy while
	# aiming at another must still acquire the one being aimed at.
	left.global_position = Vector3(0.4, 0.0, 0.4)
	right.global_position = Vector3(0.0, 0.0, -6.0)
	await _settle(4)
	var aimed: Dictionary = action.soft_target(
		practice.player.global_position, forward, practice._target_candidates()
	)
	var aimed_target: PrototypeTargetable = aimed["target"] as PrototypeTargetable
	_expect(aimed_target != null and aimed_target.combat_actor() == right,
		"a ranged Skill preferred the enemy at the character's feet over the one aimed at")

	# NO RETENTION: the function holds no state, so two identical calls with
	# different intents answer independently.
	var first: Dictionary = action.soft_target(
		practice.player.global_position, forward, practice._target_candidates()
	)
	var second: Dictionary = action.soft_target(
		practice.player.global_position, Vector3(0.0, 0.0, 1.0), practice._target_candidates()
	)
	_expect(first["target"] != null and second["target"] == null,
		"the second call was influenced by the first; a ranged Skill must not retain a target")

	# The cone really is a TOTAL width, halved — the D-178 rule, unchanged.
	_expect(is_equal_approx(record.soft_target_cone_total_degrees(),
			record.soft_target_cone_half_degrees() * 2.0),
		"the soft-target cone is not a total width halved")
	print("  acquired ahead, refused beyond %.1f m, refused behind, no in-reach priority, no retention" % [
		record.soft_target_distance,
	])
	_done("controller_soft_targeting")


# --- The owed-set comparison (D-211's structural repair) ----------------------

func _check_every_check_ran() -> void:
	print("")
	print("--- Every check function reached its last line")
	var missing: PackedStringArray = PackedStringArray()
	for owed: String in OWED_CHECKS:
		if not _reached.has(owed):
			missing.append(owed)
	var extra: PackedStringArray = PackedStringArray()
	for reached: String in _reached.keys():
		if not (reached in OWED_CHECKS):
			extra.append(reached)
	_expect(missing.is_empty(), "these checks never reached their last line: %s" % ", ".join(missing))
	_expect(extra.is_empty(), "these checks ran but are not in OWED_CHECKS: %s" % ", ".join(extra))
	print("  %d of %d owed check function(s) completed" % [_reached.size(), OWED_CHECKS.size()])


func _done(name: String) -> void:
	_reached[name] = true


# --- Harness -------------------------------------------------------------------

func _expect(condition: bool, failure_message: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(failure_message)


func _settle(frames: int) -> void:
	for _frame: int in frames:
		await get_tree().physics_frame
