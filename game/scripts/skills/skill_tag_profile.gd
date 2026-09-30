class_name SkillTagProfile
extends RefCounted
## Riftwrought — Roguelite Foundation A: one Skill's stable id and its tags
## (decision D-224).
##
## THE SMALLEST THING THAT CAN ANSWER A COMPATIBILITY QUESTION. A support does
## not need a Skill's timing, geometry, cost, weapon requirement, animation or
## damage: it needs the Skill's identity and its tags. Passing a whole Skill
## record into an eligibility query would make the query depend on a record
## shape, and a record shape is exactly the thing that differs between a melee
## class's Skill, a caster's Skill, and whatever a later class brings.
##
## IT IS CLASS-AGNOSTIC AND IT ASSUMES NOTHING. There is no default Skill, no
## implied archetype, no implied damage source, no implied weapon and no implied
## melee-ness anywhere in this file. A profile is (id, name, tags) and nothing
## else, so the first Skill of a class that does not exist yet is representable
## today.
##
## IT IS A VALUE, NOT A SYSTEM. No level, rank, rarity, tier, affix, Augment,
## Configuration, Reservation, cooldown, charge, unlock, persistence or schema
## version — each of those is a first-MVP system with its own authorization, and
## none of them is in scope.
##
## TAGS ARE HELD AS AUTHORED AND COMPARED AS A SET. The array keeps whatever
## order and repetition it was given, because a record should round-trip what it
## was handed; every question about it goes through `SkillTags`, which
## normalizes first. That is why tag ordering and duplicate tags cannot change
## an answer.

## Stable identifier, e.g. the id a saved record would carry.
var skill_id: StringName = &""

## Presentation only. Never used to decide anything.
var display_name: String = ""

var tags: Array[StringName] = []


func _init(for_id: StringName = &"", for_name: String = "", for_tags: Array[StringName] = []) -> void:
	skill_id = for_id
	display_name = for_name
	tags = for_tags.duplicate()


static func of(for_id: StringName, for_name: String, for_tags: Array[StringName]) -> SkillTagProfile:
	return SkillTagProfile.new(for_id, for_name, for_tags)


## Builds a profile from tags a Skill record already carries, plus any the
## eligibility vocabulary needs and that record does not yet state. The base
## tags are READ rather than retyped, so a profile can never disagree with the
## record it came from; the additions are the only thing declared, and the
## caller declaring them owns the reason.
static func extending(
	for_id: StringName,
	for_name: String,
	recorded_tags: Array[StringName],
	additional_tags: Array[StringName]
) -> SkillTagProfile:
	return SkillTagProfile.new(for_id, for_name, SkillTags.union(recorded_tags, additional_tags))


## Requirement membership — vocabulary-gated, so an unrecognised tag can never
## make a Skill look eligible for anything.
func satisfies(tag: StringName) -> bool:
	return SkillTags.satisfies(tags, tag)


## Literal membership, used where an unrecognised tag must still be honoured.
func carries(tag: StringName) -> bool:
	return SkillTags.carries(tags, tag)


func normalized_tags() -> Array[StringName]:
	return SkillTags.normalize(tags)


func unknown_tags() -> Array[StringName]:
	return SkillTags.unknown(tags)


func tag_line() -> String:
	return SkillTags.line(tags)


## Returns "" when the profile is coherent, or the first problem found — the
## same loud-failure rule every data record in this project keeps. An
## unrecognised tag is reported here rather than at query time, because at query
## time it silently denies and a silent denial is hard to read.
func problem() -> String:
	if String(skill_id).strip_edges().is_empty():
		return "skill_id must not be empty"
	if display_name.strip_edges().is_empty():
		return "%s: display_name must not be empty" % skill_id
	if tags.is_empty():
		return "%s: a Skill profile must carry at least one tag" % skill_id
	var unrecognised: Array[StringName] = unknown_tags()
	if not unrecognised.is_empty():
		return "%s: unrecognised tag(s) %s — they can satisfy no requirement" % [
			skill_id, SkillTags.line(unrecognised),
		]
	return ""


func describe() -> String:
	return "%s [%s]" % [display_name, tag_line()]
