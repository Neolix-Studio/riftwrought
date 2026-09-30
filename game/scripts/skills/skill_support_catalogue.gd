class_name SkillSupportCatalogue
extends RefCounted
## Riftwrought — Roguelite Foundation A: the concrete records the project holds
## today — one Skill's tag profile, and the eligibility of the two currently
## relevant spatial supports (decision D-224).
##
## THIS IS THE ONLY FILE IN THE FOUNDATION THAT NAMES ANYTHING. `SkillTags`,
## `SkillTagProfile` and `SupportEligibility` are class-agnostic and name no
## Skill and no support at all; every concrete statement lives here, so a second
## class's Skill and a third support are RECORDS added to this file rather than
## code added anywhere.
##
## QUICK STRIKE IS THE FIRST MELEE CLASS'S CURRENT SKILL AND NOTHING MORE.
## Nothing above this file assumes it exists, assumes a class owns it, or
## assumes a Skill is melee. It is the one entry here because it is the one
## Skill the review can equip today.
##
## ITS TAGS ARE READ, NOT RETYPED. `FirstMvpSkillLibrary.quick_strike_record()`
## already builds the first-MVP view of Quick Strike by reading the canonical
## `data/prototype_zero/quick_strike.tres`, and that view already carries
## Attack, Melee, Hit and Physical. Those four are taken from it, so the
## foundation cannot drift from the record; only the additions below are
## declared, and this file owns the reason for each.
##
## WHY THE TWO ADDITIONS ARE MADE HERE RATHER THAN IN THE GATE 1E RECORD.
## `FirstMvpSkillData.tag_line()` is DISPLAYED — the Foundation Cache and the
## Skill line put a Skill's tags on screen — so writing Strike and Area into
## `quick_strike_record()` would change on-screen text inside a delivered gate.
## This foundation is not authorized to change any UI, so the record is read and
## extended rather than edited. Consolidating the two statements into one is a
## later, separately authorized edit to Gate 1E.
##
## THE ONE ADDITION IS `STRIKE`, AND `AREA` WAS REMOVED BY OWNER RULING (D-225).
## The first delivery also added `Area`, on the reasoning that the release
## sweeps a 100-degree arc and an arc is a swept region. The project owner ruled
## otherwise, and the ruling is now the governing tag contract in
## `design/ATTRIBUTES_AND_DAMAGE_MODEL.md` §11: **a candidate-search arc is not
## an area of effect.** `QuickStrikeData.maximum_targets` is 1 and its own
## `problem()` enforces exactly 1, so this Skill resolves one target however
## wide the arc it searches, and §11 says a tag is a mechanical contract — so
## carrying `Area` asserted something untrue about the Skill.
##
## `STRIKE` is canonical since D-225 and is owned by `FirstMvpSkillData` like
## every other tag id. It names exactly what
## `FirstMvpSkillData.Archetype.MELEE_SINGLE` already models — a contact release
## resolved against ONE target inside a reach and an arc — which `Melee` alone
## cannot distinguish from a melee Area Skill.
##
## FOUNDATION B ADDED A WEIGHT TO EACH OF THE TWO SUPPORTS, AND THE TWO ARE
## DELIBERATELY EQUAL (D-227). A weight says how often a selection system should
## reach for a support; it says nothing about whether the support is legal,
## which is what the eligibility rule above decides. The two shipped values are
## EQUAL so that the one Skill this project can equip today is offered both with
## exactly the same probability — a foundation that arrived already preferring
## one of them would be shipping a balance opinion inside a mechanism. **These
## are review weights, not final balance**, and neither carries a tag bonus.
##
## UNTIL ROGUELITE I3 NOTHING HERE CHANGED A GAMEPLAY VALUE; SINCE I3 THREE NUMBERS
## DID (D-295), AND SINCE ROGUELITE I4 EXACTLY SIX DO (D-298). The eligibility rules,
## the profiles and the weights still write no reach, arc, cone, damage or timing.
## The six support values at the end of this file — three at rank one, three at rank
## two — are GREYBOX REVIEW VALUES, NOT FINAL BALANCE: the one run-build application
## seam reads them to set Quick Strike's live PRIVATE record while a pair is held at
## exactly that rank, and nothing else in the running game reads them.
## `RogueliteUpgrade` still does not reference this file, and this file still names
## nothing of it: the review values are stated here, not imported from there.
##
## SINCE ROGUELITE FOUNDATION I5 (D-300) EACH DEFINITION ALSO CARRIES A MAXIMUM RANK,
## AND IT IS READ OUT OF THE RANK TABLE RATHER THAN TYPED BESIDE IT. See
## `support_maximum_rank()` below: the number is derived from the exact applied-rank
## records at the end of this file, so the table stays the one place a rank is
## written, and a record for a further rank would move the maximum with it.

## Stable support identifiers. They are the foundation's own ids and are
## deliberately NOT `RogueliteUpgrade.Kind` values: the eligibility of a support
## is a Skill-facing fact that must outlive one temporary review instrument.
const REACHING_EDGE_ID: StringName = &"reaching_edge"
const SWEEPING_EDGE_ID: StringName = &"sweeping_edge"

## The display names, which must agree with the review that offers them. They
## are repeated here rather than imported so the foundation does not depend on a
## temporary review; the verification pins the agreement in both directions,
## which is the same discipline the Zone Composer palette keeps against the
## accepted asset records.
const REACHING_EDGE_NAME: String = "Reaching Edge"
const SWEEPING_EDGE_NAME: String = "Sweeping Edge"

## THE TWO SHIPPED REVIEW WEIGHTS, AND THEY ARE EQUAL ON PURPOSE (D-227). Both
## are plain positive integers with no tag bonus, so both supports carry the
## same effective weight for any Skill either of them accepts. The value 100 is
## a round base to express a later preference against — a support judged twice
## as likely would be written 200 — and carries no other meaning.
const REACHING_EDGE_BASE_WEIGHT: int = 100
const SWEEPING_EDGE_BASE_WEIGHT: int = 100

## Neither shipped support declares a tag bonus. The empty dictionaries are
## written out rather than defaulted, because "no bonus" is a statement this
## record makes and not an omission.
const REACHING_EDGE_TAG_BONUSES: Dictionary = {}
const SWEEPING_EDGE_TAG_BONUSES: Dictionary = {}

## The one form tag the Gate 1E Quick Strike view does not yet state. `Area` was
## here at first delivery and was REMOVED by the D-225 owner ruling; see the
## header. The resolved profile is Attack, Hit, Melee, Strike, Physical.
const QUICK_STRIKE_ADDITIONAL_TAGS: Array[StringName] = [SkillTags.STRIKE]


# --- The Skill profiles the project holds today -------------------------------

## Quick Strike's tag profile: the Gate 1E record's own tags, plus the two form
## tags above. Every one of the record's tags is preserved — this is a union,
## never a replacement.
static func quick_strike_profile() -> SkillTagProfile:
	var record: FirstMvpSkillData = FirstMvpSkillLibrary.quick_strike_record()
	if record == null:
		return SkillTagProfile.of(&"", "", [])
	return SkillTagProfile.extending(
		record.skill_id, record.display_name, record.tags, QUICK_STRIKE_ADDITIONAL_TAGS
	)


static func skill_profiles() -> Array[SkillTagProfile]:
	var out: Array[SkillTagProfile] = []
	out.append(quick_strike_profile())
	return out


static func skill_profile(skill_id: StringName) -> SkillTagProfile:
	for profile: SkillTagProfile in skill_profiles():
		if profile.skill_id == skill_id:
			return profile
	return null


# --- The supports whose eligibility this foundation states --------------------

## REACHING EDGE lengthens the reach a contact release resolves within. That is
## a Strike's own geometry: a melee Area Skill resolves inside a radius rather
## than at a reach, and a Projectile Skill has a range rather than a reach, so
## neither is what this support describes.
static func reaching_edge() -> SupportEligibility:
	return SupportEligibility.of(
		REACHING_EDGE_ID,
		REACHING_EDGE_NAME,
		[SkillTags.MELEE, SkillTags.STRIKE] as Array[StringName],
		[] as Array[StringName],
		[SkillTags.PROJECTILE] as Array[StringName]
	)


## SWEEPING EDGE widens the horizontal arc a melee release sweeps. Its
## eligibility is `Melee + Strike` by owner ruling (D-225) and DELIBERATELY DOES
## NOT DEPEND ON A BASELINE `Area` TAG: the first delivery asked for Strike OR
## Area, which made a support's eligibility rest on a tag the Skill should never
## have carried. A rule must not require a tag in order to make a Skill it was
## written for pass.
##
## ITS RUNTIME EFFECTS, AND WHICH OF THEM EXIST. When a Sweeping Edge modifier is
## APPLIED to a Skill instance it may:
##
##   * add the `Area` tag to that MODIFIED INSTANCE — which is exactly the
##     distinction §11 now draws, since a modifier may grant Area while the
##     baseline Skill does not carry it;
##   * increase that instance's maximum target count;
##   * widen its release arc.
##
## ROGUELITE I3 (D-295) APPLIES ONLY THE THIRD, AT RANK ONE, AND ROGUELITE I4
## (D-298) THE SAME THIRD AT RANK TWO: the release arc widens, and the controller
## soft-target cone widens with it so aim assistance can look where the wider
## swing now reaches — the four values are at the end of this file. The first two
## still do not exist at either rank: no tag is added to anything, no target count
## moves, and Quick Strike stays a single-target Strike whose real candidate-search
## arc is wider. Multi-target and Area behaviour are separately deferred, and this
## block remains the record of that intent.
static func sweeping_edge() -> SupportEligibility:
	return SupportEligibility.of(
		SWEEPING_EDGE_ID,
		SWEEPING_EDGE_NAME,
		[SkillTags.MELEE, SkillTags.STRIKE] as Array[StringName],
		[] as Array[StringName],
		[SkillTags.PROJECTILE] as Array[StringName]
	)


# --- The same two supports, as weighted definitions (Foundation B) ------------
#
# A definition is an eligibility rule plus a weight. It DERIVES its id and its
# display name from the rule it holds rather than restating them, so a
# definition and its rule cannot disagree about what support they describe.
#
# Since Foundation I5 (D-300) it also carries a maximum rank, and that is DERIVED
# too: from the applied-rank records at the end of this file, through
# `support_maximum_rank()`, never typed here as a second copy of the table.


static func reaching_edge_definition() -> SupportDefinition:
	return SupportDefinition.of(
		reaching_edge(), REACHING_EDGE_BASE_WEIGHT, REACHING_EDGE_TAG_BONUSES,
		support_maximum_rank(REACHING_EDGE_ID)
	)


static func sweeping_edge_definition() -> SupportDefinition:
	return SupportDefinition.of(
		sweeping_edge(), SWEEPING_EDGE_BASE_WEIGHT, SWEEPING_EDGE_TAG_BONUSES,
		support_maximum_rank(SWEEPING_EDGE_ID)
	)


static func support_definitions() -> Array[SupportDefinition]:
	var out: Array[SupportDefinition] = []
	out.append(reaching_edge_definition())
	out.append(sweeping_edge_definition())
	return out


static func support_definition(support_id: StringName) -> SupportDefinition:
	for definition: SupportDefinition in support_definitions():
		if definition.support_id() == support_id:
			return definition
	return null


## THE TWO CURRENTLY RELEVANT SPATIAL SUPPORTS, AND DELIBERATELY ONLY THOSE TWO.
## Expedition Blade and Quickened Edge are not migrated: one is a weapon granted
## through an accepted pickup path and the other writes an attack-speed field,
## and neither is a spatial question. Migrating them is separate work.
static func supports() -> Array[SupportEligibility]:
	var out: Array[SupportEligibility] = []
	out.append(reaching_edge())
	out.append(sweeping_edge())
	return out


static func support(support_id: StringName) -> SupportEligibility:
	for rule: SupportEligibility in supports():
		if rule.support_id == support_id:
			return rule
	return null


## Which of the catalogued supports accept `profile`, through the one query.
static func eligible_supports_for(profile: SkillTagProfile) -> Array[SupportEligibility]:
	var out: Array[SupportEligibility] = []
	for rule: SupportEligibility in supports():
		if rule.allows(profile):
			out.append(rule)
	return out


# --- Support rank values (Roguelite I3, D-295; rank two, Roguelite I4, D-298) ----
#
# THE ONLY CONCRETE SUPPORT VALUES IN THE PROJECT, AND THEY ARE GREYBOX REVIEW
# VALUES, NOT FINAL BALANCE. Each is the value a Skill's live private record holds
# while one support is held on it at one exact rank: an ABSOLUTE value rather than
# an increment, so applying one build twice lands on the same number and nothing
# can compound.
#
# THE RANK TABLE IS THE AUTHORITY, AND IT HOLDS EXACTLY TWO ROWS PER SUPPORT
# (D-298). Rank one resolves its rank-one record and rank two resolves its rank-two
# record. Every value is typed out below as its own literal and no record is
# computed from another: there is no per-rank formula, no scaling rule, no
# interpolation and no fallback. Rank zero is not an acquired support, and rank
# three or any higher rank has no reviewed effect — so a pair or a rank this table
# holds no record for is answered with nothing, and the caller must refuse it
# rather than invent one. How rank three will scale is deliberately NOT decided
# here.

## The two ranks the table holds records for, named so the table reads as one.
## Neither is derived from the other.
const RANK_ONE: int = 1
const RANK_TWO: int = 2

## The Skill quantities a support may set, named as the live record's own fields.
const STRIKE_REACH: StringName = &"reach"
const STRIKE_RELEASE_ARC_DEGREES: StringName = &"release_arc_degrees"
const STRIKE_SOFT_TARGET_CONE_DEGREES: StringName = &"soft_target_cone_degrees"

## REVIEW VALUES — Quick Strike's reach while Reaching Edge is held, against the
## canonical 1.65 m: 2.65 m at rank one (I3), 3.65 m at rank two (I4).
const REACHING_EDGE_RANK_ONE_REACH: float = 2.65
const REACHING_EDGE_RANK_TWO_REACH: float = 3.65

## REVIEW VALUES — Quick Strike's TOTAL release arc and TOTAL controller soft-target
## cone while Sweeping Edge is held, against the canonical 100 and 65 degrees. At
## rank one (I3) 180 total is plus or minus 90 and 110 total is plus or minus 55; at
## rank two (I4) 260 total is plus or minus 130 and 155 total is plus or minus 77.5,
## still inside the record's own 89-degree half-angle guard. Neither rank adds a
## target or a tag.
const SWEEPING_EDGE_RANK_ONE_RELEASE_ARC_DEGREES: float = 180.0
const SWEEPING_EDGE_RANK_ONE_SOFT_TARGET_CONE_DEGREES: float = 110.0
const SWEEPING_EDGE_RANK_TWO_RELEASE_ARC_DEGREES: float = 260.0
const SWEEPING_EDGE_RANK_TWO_SOFT_TARGET_CONE_DEGREES: float = 155.0


## The quantities `support_id` sets on `skill_id`'s live record while it is held at
## exactly `rank`, as a fresh dictionary of quantity -> value. EMPTY for any pair or
## rank the table holds no record for — rank zero, rank three and every rank above
## it among them — which says that nothing is known, and is never a default.
static func support_rank_values(skill_id: StringName, support_id: StringName, rank: int) -> Dictionary:
	var records: Dictionary = _rank_records(skill_id, support_id)
	if not records.has(rank):
		return {}
	var record: Dictionary = records[rank]
	return record.duplicate()


## The exact ranks the table holds a record for on one pair, ascending: rank one and
## rank two for each shipped support on Quick Strike, and none for any other pair.
## READ FROM THE TABLE rather than stated beside it, so the ranks a refusal names
## and the records a caller receives cannot disagree.
static func reviewed_support_ranks(skill_id: StringName, support_id: StringName) -> Array[int]:
	var ranks: Array[int] = []
	for held: Variant in _rank_records(skill_id, support_id):
		ranks.append(int(held))
	ranks.sort()
	return ranks


## THE RANK TABLE: rank -> record for one pair, every record typed out and none
## computed. Built afresh on every call, so no caller can reach the table itself.
static func _rank_records(skill_id: StringName, support_id: StringName) -> Dictionary:
	if skill_id != quick_strike_profile().skill_id:
		return {}
	if support_id == REACHING_EDGE_ID:
		return {
			RANK_ONE: {STRIKE_REACH: REACHING_EDGE_RANK_ONE_REACH},
			RANK_TWO: {STRIKE_REACH: REACHING_EDGE_RANK_TWO_REACH},
		}
	if support_id == SWEEPING_EDGE_ID:
		return {
			RANK_ONE: {
				STRIKE_RELEASE_ARC_DEGREES: SWEEPING_EDGE_RANK_ONE_RELEASE_ARC_DEGREES,
				STRIKE_SOFT_TARGET_CONE_DEGREES: SWEEPING_EDGE_RANK_ONE_SOFT_TARGET_CONE_DEGREES,
			},
			RANK_TWO: {
				STRIKE_RELEASE_ARC_DEGREES: SWEEPING_EDGE_RANK_TWO_RELEASE_ARC_DEGREES,
				STRIKE_SOFT_TARGET_CONE_DEGREES: SWEEPING_EDGE_RANK_TWO_SOFT_TARGET_CONE_DEGREES,
			},
		}
	return {}


# --- The maximum rank each support declares (Roguelite Foundation I5, D-300) ------
#
# DERIVED FROM THE RANK TABLE ABOVE, NEVER TYPED BESIDE IT. A support's maximum rank
# is the highest rank its applied-rank records reach, and those records are the one
# place the project writes what a rank does — so the number is read out of them
# rather than retyped as a second fact that could drift from the first.
#
# IT IS PUBLISHED ONLY WHEN THE RECORDS SUPPORT IT, AND OTHERWISE IT FAILS CLOSED.
# For every Skill this catalogue holds that the support is eligible for, that exact
# pair's records must begin at rank one, run without a gap, and each be non-empty;
# and every such pair must reach the same highest rank. A support no held Skill
# accepts, a pair with no record, a pair whose ranks skip one, an empty record and
# two pairs that disagree are each refused in plain language, and the definition is
# then handed `SupportDefinition.UNDECLARED_MAXIMUM_RANK`, which the rank-increase
# selection refuses. The largest rank seen anywhere is deliberately NOT taken as the
# answer: that would make a pair with a missing effect selectable for a rank
# nothing has written.


## The maximum rank `support_id` declares, derived from its applied-rank records, or
## `SupportDefinition.UNDECLARED_MAXIMUM_RANK` when no honest maximum exists.
static func support_maximum_rank(support_id: StringName) -> int:
	return int(_maximum_rank_derivation(support_id)["maximum"])


## "" when `support_id`'s maximum rank is derivable from its records, or the reason
## it is not.
static func support_maximum_rank_problem(support_id: StringName) -> String:
	return String(_maximum_rank_derivation(support_id)["problem"])


## THE RULE, AS A PURE FUNCTION OF THE RECORDS IT IS HANDED. `applied` maps a label
## for each applicable Skill/support pair to that pair's own rank -> record table, in
## exactly the shape `_rank_records()` answers. Returns `{"maximum", "problem"}`: the
## one maximum every pair's records support and "", or
## `SupportDefinition.UNDECLARED_MAXIMUM_RANK` and the reason no honest maximum
## exists. It reads nothing but its argument, which is what lets the refusing
## branches be driven against records this catalogue does not hold — the shipped
## table exercises only the branch that passes.
static func maximum_rank_from(applied: Dictionary) -> Dictionary:
	var labels: Array[String] = []
	var by_label: Dictionary = {}
	for key: Variant in applied:
		labels.append(String(key))
		by_label[String(key)] = applied[key]
	labels.sort()
	if labels.is_empty():
		return _no_maximum("no applicable Skill holds an applied-rank record")
	var maximum: int = SupportDefinition.UNDECLARED_MAXIMUM_RANK
	var reached_by: String = ""
	for label: String in labels:
		var table: Variant = by_label[label]
		if typeof(table) != TYPE_DICTIONARY or (table as Dictionary).is_empty():
			return _no_maximum("%s has no applied-rank record at all" % label)
		var held_ranks: Array[int] = []
		for key: Variant in table:
			if typeof(key) != TYPE_INT:
				return _no_maximum("%s holds an applied-rank record under %s, which is not a rank" % [
					label, str(key),
				])
			held_ranks.append(int(key))
		held_ranks.sort()
		if held_ranks.front() != RANK_ONE:
			return _no_maximum("%s has applied ranks %s, which do not begin at rank one" % [
				label, str(held_ranks),
			])
		if held_ranks.back() != held_ranks.size():
			return _no_maximum("%s has applied ranks %s, which skip a rank" % [label, str(held_ranks)])
		for held: int in held_ranks:
			var record: Variant = (table as Dictionary)[held]
			if typeof(record) != TYPE_DICTIONARY or (record as Dictionary).is_empty():
				return _no_maximum("%s has an empty applied-rank record" % label)
		var highest: int = int(held_ranks.back())
		if reached_by.is_empty():
			maximum = highest
			reached_by = label
		elif highest != maximum:
			return _no_maximum(
				"%s reaches %d applied ranks and %s reaches %d, so no one maximum is honest for the support"
					% [reached_by, maximum, label, highest]
			)
	return {"maximum": maximum, "problem": ""}


## One support's applicable records gathered from the table and handed to the rule.
static func _maximum_rank_derivation(support_id: StringName) -> Dictionary:
	var rule: SupportEligibility = support(support_id)
	if rule == null:
		return _no_maximum("%s is not a support this catalogue holds" % support_id)
	var applied: Dictionary = {}
	for profile: SkillTagProfile in skill_profiles():
		if rule.allows(profile):
			applied["%s on %s" % [support_id, profile.skill_id]] = _rank_records(
				profile.skill_id, support_id
			)
	if applied.is_empty():
		return _no_maximum("no Skill this catalogue holds accepts %s" % support_id)
	return maximum_rank_from(applied)


static func _no_maximum(reason: String) -> Dictionary:
	return {"maximum": SupportDefinition.UNDECLARED_MAXIMUM_RANK, "problem": reason}


## Every problem in every record this catalogue holds. Empty when coherent.
static func problems() -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	for profile: SkillTagProfile in skill_profiles():
		var profile_problem: String = profile.problem()
		if not profile_problem.is_empty():
			found.append(profile_problem)
	var seen: Array[StringName] = []
	for rule: SupportEligibility in supports():
		var rule_problem: String = rule.problem()
		if not rule_problem.is_empty():
			found.append(rule_problem)
		if seen.has(rule.support_id):
			found.append("duplicate support_id %s" % rule.support_id)
		seen.append(rule.support_id)
		## Each support's maximum rank must be derivable from its own records.
		var maximum_problem: String = support_maximum_rank_problem(rule.support_id)
		if not maximum_problem.is_empty():
			found.append(maximum_problem)
	## The weighted definitions are validated here too, so one call answers for
	## every record this catalogue holds rather than for the eligibility half of
	## them. A weight that cannot be selected against is a broken record exactly
	## as a rule that nothing can satisfy is — and since D-301 a definition's own
	## `problem()` also refuses a maximum rank nothing can be held at.
	for definition: SupportDefinition in support_definitions():
		var definition_problem: String = definition.problem()
		if not definition_problem.is_empty():
			found.append(definition_problem)
	return found
