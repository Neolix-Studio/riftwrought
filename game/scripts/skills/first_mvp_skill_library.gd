class_name FirstMvpSkillLibrary
extends RefCounted
## First-MVP — Gate 1E: the four Skills this character can know (D-219).
##
## Quick Strike plus the three Foundation Cache directions. `design/SKILLS_AND_
## SKILL_MODIFICATION.md`'s roster has eight; Void Lance, Cinder Field, Rift
## Step and Void Attunement are outside Gate 1E and each is named in its
## exclusion list.
##
## QUICK STRIKE IS READ, NOT RESTATED. The canonical
## `data/prototype_zero/quick_strike.tres` still owns every mechanical number —
## 0.80 s, marker 0.325, 1.65 m reach, 100 deg arc, 5 Mana, the D-178 65 deg
## cone. `quick_strike_record()` READS that file and copies those numbers into a
## `FirstMvpSkillData` view, so there is exactly one authored source and a
## change there shows up here. The first-MVP layer adds only what Prototype Zero
## had no reason to know: a WEAPON REQUIREMENT, because the brief says "Quick
## Strike remains learned and can be used whenever its weapon requirements are
## met" and Prototype Zero's record has no such field.
##
## That view is for the interface and the requirement check. The RUNNING Quick
## Strike is still `QuickStrikeAction` on its own untouched record — this
## library never feeds a `FirstMvpSkillAction` a Quick Strike record, and the
## machine refuses one anyway (its MELEE_SINGLE guard).
##
## THE ANIMATION MAPPING IS A HONEST PLACEHOLDER AND IS RECORDED AS ONE. The
## project has exactly SEVEN medium-rig clips (`Idle_A`, `Running_A`, `Hit_A`,
## `Death_A`, `PickUp`, `Melee_1H_Attack_Chop`, `Melee_1H_Attack_Slice_Horizontal`),
## and no bow draw and no cast gesture exists anywhere in it. Extracting one
## would move a third-party inventory pinned in six runners and needs its own
## authorization, and the brief forbids a new asset search. So:
##
##   HEAVY_MELEE      -> Melee_1H_Attack_Chop           APPROPRIATE. Canon calls
##                       Faultbreaker "a committed heavy slam or strike using
##                       the heavy-melee animation family", and Gate D measured
##                       that Chop cannot honestly carry a 1.65 m contact reach
##                       — which is a defect for a lunge and exactly right for a
##                       committed overhead impact centred on the character.
##   RANGED_DRAW      -> PickUp                          PLACEHOLDER. A forward
##                       reach reads closer to drawing a bow than a sword swing
##                       does. It is not a bow draw.
##   ONE_HANDED_CAST  -> Melee_1H_Attack_Slice_Horizontal PLACEHOLDER. An arm
##                       sweeping forward reads as a cast gesture. It is not one.
##
## All three are distinct on screen, which is what stops the three Skills
## reading as one. Two of the three are stand-ins pending a real animation set,
## and the Gate 1E report says so rather than leaving it to be discovered.
##
## The clip is played at a speed scale computed from the clip's OWN length, so
## the action time in the record drives the visual rather than the imported
## clip length driving the action — the reason `MediumRigVisual.play()` has a
## `speed_scale` parameter at all.

const QUICK_STRIKE_RECORD: String = "res://data/prototype_zero/quick_strike.tres"

const FAULTBREAKER_PATH: String = "res://data/first_mvp/skills/faultbreaker.tres"
const SPLINTER_SHOT_PATH: String = "res://data/first_mvp/skills/splinter_shot.tres"
const EMBERBOLT_PATH: String = "res://data/first_mvp/skills/emberbolt.tres"

const QUICK_STRIKE_ID: StringName = &"quick_strike"
const FAULTBREAKER_ID: StringName = &"faultbreaker"
const SPLINTER_SHOT_ID: StringName = &"splinter_shot"
const EMBERBOLT_ID: StringName = &"emberbolt"

## Quick Strike's first-MVP weapon requirement. Canon calls it "the flexible
## light-weapon foundation"; the light melee families in
## design/ITEMS_AND_RARITY_STRUCTURE.md §4.1 are the one-handed sword, the
## one-handed axe and the dagger.
const QUICK_STRIKE_FAMILIES: Array[StringName] = [
	FirstMvpSkillData.FAMILY_ONE_HANDED_SWORD,
	FirstMvpSkillData.FAMILY_ONE_HANDED_AXE,
	FirstMvpSkillData.FAMILY_DAGGER,
]

## The three available medium-rig clips a Skill can present with. See the header
## for which two are placeholders.
const CLIP_FOR_FAMILY: Dictionary = {
	FirstMvpSkillData.AnimationFamily.LIGHT_MELEE: &"Melee_1H_Attack_Slice_Horizontal",
	FirstMvpSkillData.AnimationFamily.HEAVY_MELEE: &"Melee_1H_Attack_Chop",
	FirstMvpSkillData.AnimationFamily.RANGED_DRAW: &"PickUp",
	FirstMvpSkillData.AnimationFamily.ONE_HANDED_CAST: &"Melee_1H_Attack_Slice_Horizontal",
}

## Which mappings above are honest stand-ins rather than the right animation.
const PLACEHOLDER_FAMILIES: Array[int] = [
	FirstMvpSkillData.AnimationFamily.RANGED_DRAW,
	FirstMvpSkillData.AnimationFamily.ONE_HANDED_CAST,
]

var records: Dictionary = {}
var problems: PackedStringArray = PackedStringArray()


func _init() -> void:
	_add(FirstMvpSkillLibrary.quick_strike_record())
	_add(load(FAULTBREAKER_PATH) as FirstMvpSkillData)
	_add(load(SPLINTER_SHOT_PATH) as FirstMvpSkillData)
	_add(load(EMBERBOLT_PATH) as FirstMvpSkillData)


func _add(record: FirstMvpSkillData) -> void:
	if record == null:
		problems.append("a Skill record failed to load")
		return
	var problem: String = record.problem()
	if not problem.is_empty():
		problems.append(problem)
		return
	if records.has(record.skill_id):
		problems.append("duplicate skill_id %s" % record.skill_id)
		return
	records[record.skill_id] = record


## Builds the first-MVP view of Quick Strike by READING the canonical Prototype
## Zero record. Every number below is copied from that file rather than typed
## here, so the two can never disagree; the verification asserts exactly that.
static func quick_strike_record() -> FirstMvpSkillData:
	var canonical: QuickStrikeData = load(QUICK_STRIKE_RECORD) as QuickStrikeData
	assert(canonical != null, "FirstMvpSkillLibrary: the canonical Quick Strike record failed to load")
	var view: FirstMvpSkillData = FirstMvpSkillData.new()
	view.skill_id = QUICK_STRIKE_ID
	view.display_name = canonical.display_name
	view.tags = [
		FirstMvpSkillData.TAG_ATTACK, FirstMvpSkillData.TAG_MELEE,
		FirstMvpSkillData.TAG_HIT, FirstMvpSkillData.TAG_PHYSICAL,
	]
	view.identity = "The flexible light-weapon foundation. Fast, responsive, and the Skill the Riftmarked already knows."
	view.archetype = FirstMvpSkillData.Archetype.MELEE_SINGLE
	view.damage_source = FirstMvpSkillData.DamageSource.WEAPON
	view.animation_family = FirstMvpSkillData.AnimationFamily.LIGHT_MELEE
	view.damage_type = canonical.damage_type
	view.action_time = canonical.action_time
	view.release_marker_normalized = canonical.release_marker_normalized
	view.release_window = canonical.release_window
	view.input_buffer = canonical.input_buffer
	view.weapon_damage_scale = 1.0
	view.reach = canonical.reach
	view.release_arc_degrees = canonical.release_arc_degrees
	view.maximum_targets = canonical.maximum_targets
	view.approach_stop_margin = canonical.approach_stop_margin
	view.mana_cost = canonical.mana_cost
	view.soft_target_distance = canonical.soft_target_distance
	view.soft_target_cone_degrees = canonical.soft_target_cone_degrees
	view.soft_target_angle_tie_degrees = canonical.soft_target_angle_tie_degrees
	view.soft_target_retention = canonical.soft_target_retention
	view.required_weapon_families = QUICK_STRIKE_FAMILIES.duplicate()
	view.requirement_text = "Requires a one-handed sword, one-handed axe, or dagger"
	return view


func has(skill_id: StringName) -> bool:
	return records.has(skill_id)


func record(skill_id: StringName) -> FirstMvpSkillData:
	return records.get(skill_id, null)


func skill_ids() -> Array[StringName]:
	var ids: Array[StringName] = []
	for key: StringName in records.keys():
		ids.append(key)
	return ids


## The three Foundation Cache Skills, in the canonical order the cache presents
## them (design/FIRST_MVP_CAMPAIGN_AND_PROGRESSION_JOURNEY.md §7).
func foundation_records() -> Array[FirstMvpSkillData]:
	var found: Array[FirstMvpSkillData] = []
	for id: StringName in [FAULTBREAKER_ID, SPLINTER_SHOT_ID, EMBERBOLT_ID]:
		var entry: FirstMvpSkillData = record(id)
		if entry != null:
			found.append(entry)
	return found


static func clip_for(record_data: FirstMvpSkillData) -> StringName:
	return CLIP_FOR_FAMILY.get(record_data.animation_family, &"Melee_1H_Attack_Slice_Horizontal")


static func clip_is_placeholder(record_data: FirstMvpSkillData) -> bool:
	return int(record_data.animation_family) in PLACEHOLDER_FAMILIES


func is_coherent() -> bool:
	return problems.is_empty()


func describe() -> String:
	return "%d Skill(s): %s%s" % [
		records.size(), ", ".join(Array(skill_ids()).map(func(id: StringName) -> String: return String(id))),
		"" if is_coherent() else " — %d PROBLEM(S)" % problems.size(),
	]
