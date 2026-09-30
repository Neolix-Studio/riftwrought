class_name SupportEligibility
extends RefCounted
## Riftwrought — Roguelite Foundation A: a data-driven support eligibility
## description, and the ONE pure query that evaluates it (decision D-224).
##
## THE QUESTION THIS FILE ANSWERS, AND THE ONLY ONE: is this support compatible
## with this Skill's tags? `design/SKILLS_AND_SKILL_MODIFICATION.md` §10 is the
## seam — "Compatibility is checked immediately", "an incompatible Augment
## explains why it cannot be installed", "no Augment silently does nothing", and
## "one reusable behavior should serve every compatible Skill rather than
## requiring a bespoke implementation for each combination". A per-support
## `if` ladder is exactly the bespoke implementation that sentence forbids.
##
## THE DESCRIPTION IS THREE LISTS AND NOTHING ELSE:
##
##   required_all   every one of these tags must be present
##   required_any   at least one of these must be present (empty = no constraint)
##   excluded       none of these may be present, whatever else matches
##
## No weights, no priorities, no scores, no conditional clauses, no expression
## language, no per-support code path. Adding a support is adding a record.
##
## THE QUERY NAMES NO SKILL AND NO SUPPORT. `evaluate()` and `accepts()` are
## static, take tags and a rule, read no field of any Skill class, hold no
## state, touch no clock, no random source, no file and no node, and mutate
## neither argument. The verification asserts by RAW SOURCE SCAN that this file
## names no Skill id at all, because a query that knows one Skill's name is a
## query that can be tuned for it.
##
## IT FAILS CLOSED, IN EVERY DIRECTION, AND THAT IS THE WHOLE SAFETY ARGUMENT:
##
##   * an unrecognised REQUIRED tag can never be satisfied, so the rule denies —
##     even if the Skill literally carries the same unrecognised spelling,
##     because an unrecognised tag has no defined mechanical contract and no
##     eligibility decision may rest on one;
##   * an unrecognised EXCLUDED tag is still honoured literally, so it denies;
##   * a rule that states nothing at all denies rather than accepting
##     everything, because an empty description is a missing description;
##   * an unrecognised tag on the SKILL is inert — it satisfies nothing and
##     excludes nothing — so it can neither create nor destroy an otherwise
##     correct answer.
##
## EXCLUSION IS EVALUATED FIRST, AND THE ORDER IS THE RULE RATHER THAN AN
## ACCIDENT. An excluded tag overrides otherwise matching required tags, so the
## refusal a reader is shown names the exclusion — the actual reason — instead
## of naming whichever requirement happened to be checked first.
##
## THE VERDICT AND THE EXPLANATION CANNOT DISAGREE, because there is one
## evaluator: `evaluate()` returns "" for eligible or the reason for refusal,
## and `accepts()` is that result being empty. A second code path for the
## message is how a UI ends up explaining a decision the engine did not make.

## Stable identifier for the support this rule belongs to.
var support_id: StringName = &""

## Presentation only. Never used to decide anything.
var display_name: String = ""

var required_all: Array[StringName] = []
var required_any: Array[StringName] = []
var excluded: Array[StringName] = []


func _init(
	for_id: StringName = &"",
	for_name: String = "",
	for_required_all: Array[StringName] = [],
	for_required_any: Array[StringName] = [],
	for_excluded: Array[StringName] = []
) -> void:
	support_id = for_id
	display_name = for_name
	required_all = for_required_all.duplicate()
	required_any = for_required_any.duplicate()
	excluded = for_excluded.duplicate()


static func of(
	for_id: StringName,
	for_name: String,
	for_required_all: Array[StringName],
	for_required_any: Array[StringName],
	for_excluded: Array[StringName]
) -> SupportEligibility:
	return SupportEligibility.new(
		for_id, for_name, for_required_all, for_required_any, for_excluded
	)


# --- The pure query -----------------------------------------------------------

## THE compatibility query. Returns "" when `tags` satisfy `rule`, or the single
## plain-language reason they do not. Pure: no state, no side effect, no
## mutation of either argument, and the same answer for the same inputs forever.
static func evaluate(tags: Array[StringName], rule: SupportEligibility) -> String:
	if rule == null:
		return "no eligibility rule was given"
	if rule.required_all.is_empty() and rule.required_any.is_empty() and rule.excluded.is_empty():
		return "%s states no eligibility rule at all" % rule.label()
	for tag: StringName in rule.excluded:
		if SkillTags.carries(tags, tag):
			return "excluded by the %s tag" % tag
	for tag: StringName in rule.required_all:
		if SkillTags.satisfies(tags, tag):
			continue
		if not SkillTags.is_known(tag):
			return "requires %s, which is not a recognised tag" % tag
		return "requires %s, which this Skill does not carry" % tag
	if not rule.required_any.is_empty() and not SkillTags.satisfies_any(tags, rule.required_any):
		return "requires one of %s, and this Skill carries none of them" % SkillTags.line(
			rule.required_any
		)
	return ""


## The same query as a verdict. One evaluator, two faces.
static func accepts(tags: Array[StringName], rule: SupportEligibility) -> bool:
	return evaluate(tags, rule).is_empty()


# --- Profile-facing convenience, still the same one evaluator -----------------

func allows(profile: SkillTagProfile) -> bool:
	if profile == null:
		return false
	return SupportEligibility.accepts(profile.tags, self)


func refusal(profile: SkillTagProfile) -> String:
	if profile == null:
		return "no Skill profile was given"
	return SupportEligibility.evaluate(profile.tags, self)


# --- Record integrity ---------------------------------------------------------

func label() -> String:
	return display_name if not display_name.strip_edges().is_empty() else String(support_id)


## Returns "" when the record is coherent, or the first problem found. This is
## where an unusable rule is reported LOUDLY; at query time it merely denies,
## and a silent denial is hard to read.
func problem() -> String:
	if String(support_id).strip_edges().is_empty():
		return "support_id must not be empty"
	if display_name.strip_edges().is_empty():
		return "%s: display_name must not be empty" % support_id
	if required_all.is_empty() and required_any.is_empty() and excluded.is_empty():
		return "%s: a support must state at least one requirement or exclusion" % support_id
	var dead: Array[StringName] = SkillTags.union(
		SkillTags.unknown(required_all), SkillTags.unknown(required_any)
	)
	if not dead.is_empty():
		return "%s: requires unrecognised tag(s) %s, which nothing can ever satisfy" % [
			support_id, SkillTags.line(dead),
		]
	var unrecognised_exclusions: Array[StringName] = SkillTags.unknown(excluded)
	if not unrecognised_exclusions.is_empty():
		return "%s: excludes unrecognised tag(s) %s" % [
			support_id, SkillTags.line(unrecognised_exclusions),
		]
	var required: Array[StringName] = SkillTags.union(required_all, required_any)
	for tag: StringName in required:
		if excluded.has(tag):
			return "%s: %s is both required and excluded, so nothing is eligible" % [
				support_id, tag,
			]
	return ""


func rule_line() -> String:
	var parts: PackedStringArray = PackedStringArray()
	if not required_all.is_empty():
		parts.append("requires all of [%s]" % SkillTags.line(required_all))
	if not required_any.is_empty():
		parts.append("requires any of [%s]" % SkillTags.line(required_any))
	if not excluded.is_empty():
		parts.append("excludes [%s]" % SkillTags.line(excluded))
	if parts.is_empty():
		return "states no rule"
	return "; ".join(parts)


func describe() -> String:
	return "%s — %s" % [label(), rule_line()]
