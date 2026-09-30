class_name FirstMvpSkillData
extends Resource
## First-MVP — Gate 1E: the reusable Skill definition contract (D-219).
##
## THE PROBLEM THIS FILE EXISTS TO PREVENT, in the brief's own words: "The
## purpose of these three baselines is also to stop the game from acquiring
## three unrelated hand-coded abilities." Faultbreaker, Splinter Shot, and
## Emberbolt are a heavy melee Area Attack, a Physical Projectile Attack, and a
## Fire Projectile Spell. Written separately they would become three state
## machines, three release queries, three cost paths, and three animation hooks
## that drift apart. Written as data over one machine, they are three records.
##
## MODELLED ON `QuickStrikeData`, NOT REPLACING IT. Prototype Zero's record and
## its `QuickStrikeAction` are closed, accepted, and playtested; migrating Quick
## Strike onto this contract would edit a proven kernel to gain nothing this
## gate needs. So Quick Strike keeps running on its own record, and this
## contract deliberately reuses its field names and semantics — `action_time`,
## `release_marker_normalized`, `release_window`, `input_buffer`, `mana_cost`,
## `soft_target_*` — so a later consolidation is a merge rather than a
## translation. The first-MVP layer over Quick Strike is
## `FirstMvpSkillLibrary`, which reads the canonical `quick_strike.tres` for its
## numbers and adds only what the first MVP knows that Prototype Zero did not:
## a weapon requirement.
##
## EVERY DIRECT SKILL FOLLOWS Input -> Wind-up -> Release -> Recovery, and the
## brief fixes two rules on top: "Costs are checked/paid at use start" and
## "Movement normally cannot cancel committed wind-up but may cancel unnecessary
## recovery after release." Both are properties of `FirstMvpSkillAction`, not of
## any one record, which is exactly why they cannot be got wrong per-Skill.
##
## WHAT IS DELIBERATELY ABSENT. No Augment slots, no facets, no Transform, no
## Configuration, no Shaping, no Rift Echo payload, no Reservation, no tag-based
## modifier resolution, no conversion, no ailment, no Pierce/Chain/Return/count.
## Those are the Skill Modification system and every one of them is named in the
## Gate 1E exclusion list. `tags` below is the canonical tag vocabulary written
## down so a later modifier system has something true to read; nothing in Gate
## 1E resolves a modifier against it.

## Canonical tags (design/SKILLS_AND_SKILL_MODIFICATION.md).
const TAG_ATTACK: StringName = &"Attack"
const TAG_SPELL: StringName = &"Spell"
const TAG_MELEE: StringName = &"Melee"
const TAG_PROJECTILE: StringName = &"Projectile"
const TAG_AREA: StringName = &"Area"
## Canonized by D-225 as a mechanical form tag: a contact release that resolves
## against a SINGLE target inside a reach and an arc. It is a refinement of
## Melee and never a replacement, so a Strike effect carries both. No shipped
## `.tres` record carries it yet and nothing here reads it, so no displayed tag
## line moves; consolidating it into the persisted records is separate work.
const TAG_STRIKE: StringName = &"Strike"
const TAG_HIT: StringName = &"Hit"
const TAG_PHYSICAL: StringName = &"Physical"
const TAG_FIRE: StringName = &"Fire"

## Weapon families, the vocabulary a requirement is stated in
## (design/ITEMS_AND_RARITY_STRUCTURE.md §4.1).
const FAMILY_ONE_HANDED_SWORD: StringName = &"one_handed_sword"
const FAMILY_ONE_HANDED_AXE: StringName = &"one_handed_axe"
const FAMILY_DAGGER: StringName = &"dagger"
const FAMILY_TWO_HANDED_SWORD: StringName = &"two_handed_sword"
const FAMILY_TWO_HANDED_AXE: StringName = &"two_handed_axe"
const FAMILY_BOW: StringName = &"bow"
const FAMILY_CROSSBOW: StringName = &"crossbow"
const FAMILY_WAND: StringName = &"wand"
const FAMILY_STAFF: StringName = &"staff"

enum Archetype {
	## Resolves against one target inside a reach and arc, like Quick Strike.
	MELEE_SINGLE,
	## Resolves against every target inside a radius centred on the character.
	MELEE_AREA,
	## Spawns one travelling projectile that resolves on collision.
	PROJECTILE,
}

enum DamageSource {
	## An Attack: damage comes from the equipped weapon
	## (`PrototypeWeaponData.physical_damage`), scaled by `weapon_damage_scale`.
	WEAPON,
	## A Spell: damage is defined by the Skill itself, in `spell_damage`.
	SPELL,
}

## Which of the seven available medium-rig clips presents this Skill. See
## `FirstMvpSkillLibrary.CLIP_FOR_FAMILY` — the mapping, and which entries are
## honest placeholders, are recorded there rather than here.
enum AnimationFamily {
	LIGHT_MELEE,
	HEAVY_MELEE,
	RANGED_DRAW,
	ONE_HANDED_CAST,
}

@export_group("Identity")
@export var skill_id: StringName = &""
@export var display_name: String = ""
## Canonical tags, e.g. ["Attack", "Melee", "Area", "Hit", "Physical"].
@export var tags: Array[StringName] = []
## One short sentence of canonical identity, for the Foundation Cache and the
## Skill line. Quoted or paraphrased from SKILLS_AND_SKILL_MODIFICATION.md.
@export_multiline var identity: String = ""

@export_group("Behaviour")
@export var archetype: Archetype = Archetype.MELEE_SINGLE
@export var damage_source: DamageSource = DamageSource.WEAPON
@export var animation_family: AnimationFamily = AnimationFamily.LIGHT_MELEE
## The damage type the Hit deals. Physical for both Attacks; Fire for Emberbolt.
@export var damage_type: String = "Physical"

@export_group("Timing, seconds")
## Total Input -> Wind-up -> Release -> Recovery duration at no increased speed.
@export var action_time: float = 0.80
## Where inside the action the single release query fires, normalized 0..1. It
## is also the normalized pose the rig is driven to immediately before the
## query, exactly as Quick Strike does it.
@export var release_marker_normalized: float = 0.325
@export var release_window: float = 0.06
@export var input_buffer: float = 0.12

@export_group("Weapon-derived damage")
## Multiplies the equipped weapon's damage for a WEAPON-source Skill. 1.00 means
## "exactly one weapon Hit"; Faultbreaker is heavier and slower than that.
@export var weapon_damage_scale: float = 1.0

@export_group("Spell-defined damage")
## Flat damage for a SPELL-source Skill. Ignored when `damage_source` is WEAPON.
@export var spell_damage: float = 0.0

@export_group("Melee geometry, metres and degrees")
@export var reach: float = 1.65
@export var release_arc_degrees: float = 100.0
## MELEE_AREA only: the radius the Area Hit covers, centred on the character.
@export var area_radius: float = 0.0
## How many targets one release may Hit. 1 for single-target Skills.
@export var maximum_targets: int = 1
@export var approach_stop_margin: float = 0.10

@export_group("Projectile")
@export var projectile_speed: float = 0.0
@export var projectile_range: float = 0.0
@export var projectile_radius: float = 0.22
## Baseline is ONE projectile for both projectile Skills. Additional Projectiles
## is an Augment and is outside Gate 1E.
@export var projectile_count: int = 1

@export_group("Cost")
@export var mana_cost: float = 0.0

@export_group("Weapon requirement")
## Families that satisfy this Skill. EMPTY means no weapon requirement at all.
@export var required_weapon_families: Array[StringName] = []
## The plain-language line the interface shows when the requirement is not met.
@export var requirement_text: String = ""

@export_group("Controller soft targeting")
## Reuses D-178's accepted semantics: a TOTAL cone width, halved through
## `soft_target_cone_half_degrees()`. Never widen these past what D-178 accepted
## for contact melee without a decision.
@export var soft_target_distance: float = 5.0
@export var soft_target_cone_degrees: float = 65.0
@export var soft_target_angle_tie_degrees: float = 12.0
@export var soft_target_retention: float = 0.35

const _MAXIMUM_CONE_HALF_DEGREES: float = 89.0


# --- Derived timing, identical in shape to QuickStrikeData ---------------------

func windup_time() -> float:
	return action_time * release_marker_normalized


func recovery_time() -> float:
	return maxf(action_time - windup_time() - release_window, 0.0)


func effective_action_time(increased_attack_speed: float) -> float:
	return action_time / (1.0 + maxf(increased_attack_speed, -0.95))


func release_arc_half_radians() -> float:
	return deg_to_rad(clampf(release_arc_degrees, 0.0, 360.0) * 0.5)


func soft_target_cone_half_degrees() -> float:
	return minf(soft_target_cone_degrees * 0.5, _MAXIMUM_CONE_HALF_DEGREES)


func soft_target_cone_half_radians() -> float:
	return deg_to_rad(soft_target_cone_half_degrees())


func soft_target_cone_total_degrees() -> float:
	return soft_target_cone_half_degrees() * 2.0


# --- Classification ------------------------------------------------------------

func is_attack() -> bool:
	return damage_source == DamageSource.WEAPON


func is_spell() -> bool:
	return damage_source == DamageSource.SPELL


func is_projectile() -> bool:
	return archetype == Archetype.PROJECTILE


func is_area() -> bool:
	return archetype == Archetype.MELEE_AREA


func has_weapon_requirement() -> bool:
	return not required_weapon_families.is_empty()


## True when `family` satisfies this Skill. A Skill with no requirement accepts
## anything, including nothing equipped.
func accepts_weapon_family(family: StringName) -> bool:
	if not has_weapon_requirement():
		return true
	return family in required_weapon_families


## The damage one Hit of this Skill deals with `weapon` equipped. This is the
## ONE place a Skill's damage is computed, so an Attack and a Spell cannot drift
## into two different conventions.
func hit_damage(weapon: PrototypeWeaponData) -> float:
	if damage_source == DamageSource.SPELL:
		return spell_damage
	if weapon == null:
		return 0.0
	return weapon.physical_damage * weapon_damage_scale


## Hits needed to defeat `target_life`, for the Skill line and the checks.
func hits_to_defeat(target_life: float, weapon: PrototypeWeaponData) -> int:
	var per_hit: float = hit_damage(weapon)
	if per_hit <= 0.0:
		return 0
	return int(ceil(target_life / per_hit))


func tag_line() -> String:
	var parts: PackedStringArray = PackedStringArray()
	for tag: StringName in tags:
		parts.append(String(tag))
	return ", ".join(parts)


## Display names for the weapon families, written out rather than derived from
## the id: `String(&"one_handed_sword").replace("_", " ").capitalize()` produces
## "One Handed Sword", which is neither the canonical spelling nor readable in a
## sentence.
const FAMILY_DISPLAY_NAMES: Dictionary = {
	FAMILY_ONE_HANDED_SWORD: "one-handed sword",
	FAMILY_ONE_HANDED_AXE: "one-handed axe",
	FAMILY_DAGGER: "dagger",
	FAMILY_TWO_HANDED_SWORD: "two-handed sword",
	FAMILY_TWO_HANDED_AXE: "two-handed axe",
	FAMILY_BOW: "bow",
	FAMILY_CROSSBOW: "crossbow",
	FAMILY_WAND: "wand",
	FAMILY_STAFF: "staff",
}


static func family_display_name(family: StringName) -> String:
	return String(FAMILY_DISPLAY_NAMES.get(family, String(family).replace("_", " ")))


func requirement_line() -> String:
	if not has_weapon_requirement():
		return "No weapon requirement"
	var names: PackedStringArray = PackedStringArray()
	for family: StringName in required_weapon_families:
		names.append(FirstMvpSkillData.family_display_name(family))
	if names.size() <= 2:
		return "Requires a %s" % " or a ".join(names)
	var last: String = names[names.size() - 1]
	names.remove_at(names.size() - 1)
	return "Requires a %s, or a %s" % [", a ".join(names), last]


## Returns "" when the record is coherent, or the first problem found. Called on
## setup so a bad edit fails loudly rather than quietly producing a Skill that
## deals no damage or never releases (the same rule every prior gate's data
## record keeps).
func problem() -> String:
	if String(skill_id).strip_edges().is_empty():
		return "skill_id must not be empty"
	if display_name.strip_edges().is_empty():
		return "%s: display_name must not be empty" % skill_id
	if tags.is_empty():
		return "%s: a Skill must carry its canonical tags" % skill_id
	if (TAG_ATTACK in tags) == (TAG_SPELL in tags):
		return "%s: a Skill is exactly one of Attack or Spell" % skill_id
	if (TAG_ATTACK in tags) != (damage_source == DamageSource.WEAPON):
		return "%s: the Attack/Spell tag and the damage source must agree" % skill_id
	if action_time <= 0.0:
		return "%s: action_time must be positive" % skill_id
	if release_marker_normalized <= 0.0 or release_marker_normalized >= 1.0:
		return "%s: release_marker_normalized must lie strictly inside the action" % skill_id
	if release_window <= 0.0:
		return "%s: release_window must be positive" % skill_id
	if windup_time() + release_window > action_time + 0.0001:
		return "%s: wind-up plus release window exceeds the action time" % skill_id
	if input_buffer < 0.0:
		return "%s: input_buffer must not be negative" % skill_id
	if mana_cost < 0.0:
		return "%s: mana_cost must not be negative" % skill_id
	if damage_source == DamageSource.SPELL and spell_damage <= 0.0:
		return "%s: a Spell's damage is Skill-defined and must be positive" % skill_id
	if damage_source == DamageSource.WEAPON and weapon_damage_scale <= 0.0:
		return "%s: an Attack scales its weapon's damage by a positive factor" % skill_id
	if archetype == Archetype.MELEE_AREA and area_radius <= 0.0:
		return "%s: an Area Skill needs a positive area_radius" % skill_id
	if archetype == Archetype.MELEE_AREA and maximum_targets < 2:
		return "%s: an Area Skill that can Hit at most one target is not an Area Skill" % skill_id
	if archetype == Archetype.PROJECTILE:
		if projectile_speed <= 0.0:
			return "%s: a Projectile Skill needs a positive projectile_speed" % skill_id
		if projectile_range <= 0.0:
			return "%s: a Projectile Skill needs a positive projectile_range" % skill_id
		if projectile_count != 1:
			return "%s: Gate 1E's projectile baseline is exactly one projectile" % skill_id
		if not (TAG_PROJECTILE in tags):
			return "%s: a Projectile Skill must carry the Projectile tag" % skill_id
	if archetype != Archetype.PROJECTILE and projectile_speed > 0.0:
		return "%s: a non-projectile Skill must not declare a projectile speed" % skill_id
	if damage_type != "Physical" and damage_type != "Fire":
		return "%s: the first MVP implements Physical and Fire only" % skill_id
	if (TAG_FIRE in tags) != (damage_type == "Fire"):
		return "%s: the Fire tag and the damage type must agree" % skill_id
	if has_weapon_requirement() and requirement_text.strip_edges().is_empty():
		return "%s: a weapon requirement must be stated in plain language" % skill_id
	return ""


func describe() -> String:
	return "%s [%s] — %.2f s action, release at %.3f, %.0f Mana; %s" % [
		display_name, tag_line(), action_time, release_marker_normalized, mana_cost,
		requirement_line(),
	]
