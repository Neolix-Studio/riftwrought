class_name SkillTags
extends RefCounted
## Riftwrought — Roguelite Foundation A: the ONE mechanical tag vocabulary and
## the set semantics every tag question is answered with (decision D-224).
##
## WHY THIS FILE EXISTS. `design/SKILLS_AND_SKILL_MODIFICATION.md` §10 says
## "Skills and Augments use the canonical mechanical tags defined by the damage
## model", and `design/ATTRIBUTES_AND_DAMAGE_MODEL.md` §11 defines them: a
## source, a delivery, a mechanical form, and a damage type. Until now the
## project wrote a subset of those ids down inside `FirstMvpSkillData`, next to
## the first-MVP Skill record that happened to need them first. A support
## eligibility question is not a first-MVP question and is not a melee question,
## so the vocabulary is lifted to one class-agnostic place here.
##
## IT IS NOT A SECOND RECORD, AND THAT IS ENFORCED RATHER THAN PROMISED. Every
## id the project had already persisted is ALIASED from the constant that
## already owned it, which is the idiom this project already uses when one
## accepted value must exist once rather than twice. Aliasing makes drift
## impossible instead of merely detectable.
##
## (The illustrative reference that used to sit in this paragraph named a
## review's own class, and the verification's raw source scan refused it — a
## class-agnostic file may not name a support even in a comment, because the
## rule exists so a reader can trust the file holds no such knowledge. The
## comment was rewritten and the guard was left alone.)
##
## THE ID CONVENTION WAS INHERITED, NOT CHOSEN. `data/first_mvp/skills/*.tres`
## already persist `&"Attack"`, `&"Melee"`, `&"Area"`, `&"Hit"`, `&"Physical"`,
## `&"Projectile"`, `&"Spell"` and `&"Fire"` in saved records, so those exact
## StringNames ARE the stable identifiers; inventing a snake_case parallel set
## would have invalidated three shipped records to gain nothing. Presentation is
## separate and lives in `line()` and in each record's own display name.
##
## FAIL-SAFE IS A PROPERTY OF THE PRIMITIVES, NOT OF THE CALLER. `satisfies()`
## answers a REQUIREMENT and is vocabulary-gated: an unrecognised tag can never
## satisfy anything, so a misspelling or a tag from a system that does not exist
## yet denies rather than admits. `carries()` answers literal membership and is
## used for EXCLUSIONS, where honouring an unrecognised tag also denies. Both
## primitives fail in the safe direction, which is why the direction never has
## to be remembered at a call site.
##
## NOTHING HERE RESOLVES A MODIFIER. This is a vocabulary and a set algebra. No
## Augment, Support, conversion, ailment, Shaping, Configuration or Rift Echo
## behaviour reads it, and naming a damage type below implements nothing: the
## first MVP still implements Physical and Fire only, and `FirstMvpSkillData`
## still enforces exactly that.

# --- Source: what produced the damage (damage model §11) ----------------------

const ATTACK: StringName = FirstMvpSkillData.TAG_ATTACK
const SPELL: StringName = FirstMvpSkillData.TAG_SPELL
const MINION: StringName = &"Minion"
const TRIGGERED: StringName = &"Triggered"
const ENVIRONMENT: StringName = &"Environment"

# --- Delivery: how the damage is dealt ----------------------------------------

const HIT: StringName = FirstMvpSkillData.TAG_HIT
const DAMAGE_OVER_TIME: StringName = &"Damage over Time"

# --- Mechanical form: what behaviour or geometry the effect uses --------------

const MELEE: StringName = FirstMvpSkillData.TAG_MELEE
const PROJECTILE: StringName = FirstMvpSkillData.TAG_PROJECTILE
const AREA: StringName = FirstMvpSkillData.TAG_AREA
const CHANNEL: StringName = &"Channel"
const GROUND: StringName = &"Ground"
const SECONDARY: StringName = &"Secondary"

## CANONICAL SINCE D-225, and owned exactly like the other eight rather than
## specially. The project owner ruled `Strike` a canonical mechanical form tag,
## it is now registered in `design/ATTRIBUTES_AND_DAMAGE_MODEL.md` §11, and its
## id moved into `FirstMvpSkillData` — the record class that already owned every
## other canonical tag id — so this line is an alias and not a second statement.
##
## It names a contact release that resolves against a SINGLE target inside a
## reach and an arc: the distinction the project already draws as
## `FirstMvpSkillData.Archetype.MELEE_SINGLE` versus `MELEE_AREA`, and the one
## thing `Melee` alone cannot say. It is a refinement of Melee, never a
## replacement — a Strike effect carries both.
const STRIKE: StringName = FirstMvpSkillData.TAG_STRIKE

# --- Damage types (damage model §11) ------------------------------------------
#
# All six canonical types are named because a vocabulary that listed only the
# two the first MVP implements would BE the second, narrower vocabulary this
# file exists to prevent. Naming a type here implements no system.

const PHYSICAL: StringName = FirstMvpSkillData.TAG_PHYSICAL
const FIRE: StringName = FirstMvpSkillData.TAG_FIRE
const COLD: StringName = &"Cold"
const LIGHTNING: StringName = &"Lightning"
const TOXIC: StringName = &"Toxic"
const VOID: StringName = &"Void"


## Every recognised tag, in the canonical reading order of damage model §11 —
## source, delivery, form, damage type. `normalize()` emits this order, so any
## two orderings of the same tags produce one identical normalized list.
const ALL: Array[StringName] = [
	ATTACK, SPELL, MINION, TRIGGERED, ENVIRONMENT,
	HIT, DAMAGE_OVER_TIME,
	MELEE, PROJECTILE, AREA, CHANNEL, GROUND, SECONDARY, STRIKE,
	PHYSICAL, FIRE, COLD, LIGHTNING, TOXIC, VOID,
]

## Tags recognised here but not yet written into the governing tag contract at
## `design/ATTRIBUTES_AND_DAMAGE_MODEL.md` §11.
##
## IT IS EMPTY, AND THE VERIFICATION REQUIRES IT TO STAY EMPTY. D-225 canonized
## the one entry it ever held. Keeping the list rather than deleting it gives a
## future project-introduced tag a home AND makes adding one a deliberate act:
## a non-empty list turns the suite red until the tag is either canonized in the
## damage model or removed, which is the whole point of `SKILLS_AND_SKILL_MODIFICATION.md`
## §10 calling a tag a mechanical contract.
const PENDING_CANONICAL_REGISTRATION: Array[StringName] = []


static func is_known(tag: StringName) -> bool:
	return ALL.has(tag)


## Literal membership. Used for EXCLUSIONS, where honouring a tag whose meaning
## is unknown still denies, which is the safe direction.
static func carries(tags: Array[StringName], tag: StringName) -> bool:
	return tags.has(tag)


## Requirement membership: true only when `tag` is RECOGNISED and present. An
## unrecognised tag has no defined mechanical contract, so no eligibility
## decision may rest on one; it can never satisfy a requirement, not even when
## a Skill literally carries the same unrecognised spelling.
static func satisfies(tags: Array[StringName], tag: StringName) -> bool:
	return is_known(tag) and tags.has(tag)


static func satisfies_all(tags: Array[StringName], required: Array[StringName]) -> bool:
	for tag: StringName in required:
		if not satisfies(tags, tag):
			return false
	return true


static func satisfies_any(tags: Array[StringName], required: Array[StringName]) -> bool:
	for tag: StringName in required:
		if satisfies(tags, tag):
			return true
	return false


## The tags in `tags` this vocabulary does not recognise, deduplicated and in a
## stable alphabetical order. Sorted through `PackedStringArray` rather than by
## sorting StringNames directly, because StringName ordering is an
## implementation detail and a diagnostic list must be reproducible.
static func unknown(tags: Array[StringName]) -> Array[StringName]:
	var found: PackedStringArray = PackedStringArray()
	for tag: StringName in tags:
		var text: String = String(tag)
		if not is_known(tag) and not found.has(text):
			found.append(text)
	found.sort()
	var out: Array[StringName] = []
	for text: String in found:
		out.append(StringName(text))
	return out


## The same set of tags, always in the same order, with duplicates removed and
## unrecognised tags kept — never silently dropped — after the recognised ones.
## This is what makes tag order and duplicate tags unable to change any answer:
## two lists holding the same tags normalize to one identical list.
static func normalize(tags: Array[StringName]) -> Array[StringName]:
	var out: Array[StringName] = []
	for tag: StringName in ALL:
		if tags.has(tag):
			out.append(tag)
	out.append_array(unknown(tags))
	return out


## The union of two tag lists, normalized. Order-independent by construction.
static func union(first: Array[StringName], second: Array[StringName]) -> Array[StringName]:
	var joined: Array[StringName] = []
	joined.append_array(first)
	joined.append_array(second)
	return normalize(joined)


## The tags in `first` that are absent from `second`, normalized.
static func difference(first: Array[StringName], second: Array[StringName]) -> Array[StringName]:
	var kept: Array[StringName] = []
	for tag: StringName in first:
		if not second.has(tag):
			kept.append(tag)
	return normalize(kept)


## True when both lists hold exactly the same tags, whatever their order and
## however often a tag is repeated.
static func same_set(first: Array[StringName], second: Array[StringName]) -> bool:
	return normalize(first) == normalize(second)


## Display form. Presentation is deliberately separate from the ids above.
static func line(tags: Array[StringName]) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for tag: StringName in normalize(tags):
		parts.append(String(tag))
	if parts.is_empty():
		return "no tags"
	return ", ".join(parts)
