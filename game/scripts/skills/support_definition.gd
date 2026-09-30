class_name SupportDefinition
extends RefCounted
## Riftwrought — Roguelite Foundation B: one support as the selector sees it —
## its eligibility rule, its base weight, and its declared tag bonuses
## (decision D-227).
##
## WHY THIS IS A SEPARATE RECORD RATHER THAN FOUR MORE FIELDS ON THE RULE.
## `SupportEligibility` answers *may this support be attached to this Skill?*
## and its answer is a mechanical contract: a yes or a no with one stated
## reason. A weight answers a completely different question — *how often should
## an offer system reach for it?* — and it is review tuning rather than a
## contract. Writing a tuning number into the eligibility record would make
## every future weight change an edit to the file that decides legality, which
## is exactly the coupling a later balance pass should not have to touch.
##
## THE ID AND THE NAME ARE DERIVED, NEVER RESTATED. A definition holds an
## eligibility rule, and that rule already owns the stable id and the
## presentation name; `support_id()` and `display_name()` READ them. Restating
## either here would create two places for one fact to be written and therefore
## a way for them to disagree. It is the same aliasing idiom the tag vocabulary
## already uses against the record class that owns the tag ids: drift is made
## impossible rather than merely detectable.
##
## (That sentence originally named the record class outright, and this suite's
## own generic-purity scan refused the file for it — a file that must hold no
## Skill-specific knowledge may not name a Skill record even in a comment,
## because the rule exists so a reader can trust it holds none. The comment was
## rewritten and the guard was left alone, exactly as D-215 did.)
##
## THE WEIGHT MODEL IS DELIBERATELY THE SMALLEST ONE THAT CAN EXPRESS A
## PREFERENCE:
##
##   base_weight    a positive integer; every eligible support has one
##   tag_bonuses    optional, non-negative integer per CANONICAL tag
##
##   effective weight = base_weight + the bonuses for the tags this Skill
##                      actually carries
##
## TAG COUNT ALONE CANNOT MOVE A WEIGHT, AND THAT IS STRUCTURAL RATHER THAN
## REMEMBERED. `effective_weight_for()` iterates the VOCABULARY and asks whether
## the definition declared a bonus for that tag, so a Skill carrying twelve tags
## and a Skill carrying two are treated identically unless a bonus was
## explicitly written for one of the tags they differ by. Iterating the
## vocabulary is also why a duplicated tag on a Skill cannot pay a bonus twice:
## each tag is visited exactly once, whatever the profile's own array looks like.
##
## INTEGERS ONLY, AND A STATED CEILING RATHER THAN A WRAPAROUND CHECK. Every
## weight is an int; there is no float, no percentage and no normalisation, so
## two runs on two machines cannot disagree about a rounding. The ceiling is
## enforced on the MAXIMUM POSSIBLE effective weight at validation time — base
## plus every declared bonus — so a definition that passes `problem()` can never
## produce an effective weight above `MAXIMUM_WEIGHT`, and the selector's own
## total can be guarded by subtraction before any addition happens. Detecting an
## overflow after it has already wrapped is not a guard; refusing long before
## the machine limit is.
##
## A DEFINITION ALSO SAYS HOW FAR A HELD PAIR OF IT MAY BE RAISED, AND THAT IS ONE
## NUMBER RATHER THAN A TABLE (Foundation I5, D-300). `maximum_rank` is the highest
## rank a pair of this support may be held at. A rank-increase selection offers a
## held pair only while its current rank is below that number, so a pair already at
## its maximum stops being a candidate instead of being offered a step nothing has
## defined. What each rank DOES is not a question this record answers, and no rank
## table is written into it: the catalogue that holds the applied-rank records works
## the number out of them and hands it in.
##
## ABSENT IS REFUSED, NEVER DEFAULTED. A definition that declares no maximum holds
## `UNDECLARED_MAXIMUM_RANK`, which is deliberately not a rank a pair can be held
## at. Reading silence as "one rank" would make every undeclared support quietly
## unrankable; reading it as "no ceiling" would offer ranks nobody wrote. So
## `maximum_rank_problem()` names an undeclared, zero or negative maximum.
##
## A USABLE MAXIMUM IS PART OF VALIDITY (D-301). `problem()` asks
## `maximum_rank_problem()` last, so a definition without a positive maximum is an
## invalid definition everywhere: the ordinary new-pair selection, acquisition
## through it, the rank-increase selection, continuation and offer composition all
## refuse it before anything is drawn. The first delivery (D-300) read the maximum
## only when a rank was asked for, which let such a definition pass ordinary
## validation and be acquired at rank 1 — a support that could never be ranked,
## held as if it were well formed. A maximum of 1 is valid and useful: the support is
## acquired once and is then finished.
##
## STILL ABSENT, AND DELIBERATELY: no rarity tier, no luck, no dynamic build
## synergy, no pity counter, no reroll, no affix group, no depth scaling, no
## per-run modification of a weight, and no stacking of an already-acquired
## support. Each is its own decision with its own authorization.

## The smallest legal base weight. A support that cannot be selected at all is
## an absent support, not a zero-weight one, so zero is refused rather than
## treated as "never offer this".
const MINIMUM_BASE_WEIGHT: int = 1

## The stated ceiling on a single definition's maximum possible effective
## weight. Far below the 64-bit limit on purpose: the ceiling exists so that
## arithmetic can be proved safe by construction rather than tested for
## wraparound after the fact.
const MAXIMUM_WEIGHT: int = 1_000_000_000

## What `maximum_rank` holds when nothing declared one. Zero, and deliberately not
## a rank a pair can be held at, so an absent declaration refuses rather than
## quietly reading as a maximum of its own.
const UNDECLARED_MAXIMUM_RANK: int = 0

## The lowest usable maximum: the rank a first acquisition begins at. A support
## that could not be held even at its first rank would be an absent support, not
## one whose maximum is zero.
const MINIMUM_MAXIMUM_RANK: int = AcquiredSupports.FIRST_RANK


## The eligibility rule this support is defined by. It owns the id and the name.
var eligibility: SupportEligibility = null

var base_weight: int = MINIMUM_BASE_WEIGHT

## Canonical tag -> non-negative integer bonus. Empty means "no bonuses", which
## is the ordinary case and is not a problem.
var tag_bonuses: Dictionary = {}

## The highest rank a held pair of this support may be raised to. Positive for a
## definition that can be ranked; `UNDECLARED_MAXIMUM_RANK` when nothing declared
## one, which `maximum_rank_problem()` refuses.
var maximum_rank: int = UNDECLARED_MAXIMUM_RANK


func _init(
	for_eligibility: SupportEligibility = null,
	for_base_weight: int = MINIMUM_BASE_WEIGHT,
	for_tag_bonuses: Dictionary = {},
	for_maximum_rank: int = UNDECLARED_MAXIMUM_RANK
) -> void:
	eligibility = for_eligibility
	base_weight = for_base_weight
	tag_bonuses = for_tag_bonuses.duplicate()
	maximum_rank = for_maximum_rank


## `for_maximum_rank` defaults to `UNDECLARED_MAXIMUM_RANK` so a default or
## fail-closed object can still be constructed — and such an object is INVALID:
## `problem()` refuses it, so every selection refuses it (D-301).
static func of(
	for_eligibility: SupportEligibility,
	for_base_weight: int,
	for_tag_bonuses: Dictionary,
	for_maximum_rank: int = UNDECLARED_MAXIMUM_RANK
) -> SupportDefinition:
	return SupportDefinition.new(
		for_eligibility, for_base_weight, for_tag_bonuses, for_maximum_rank
	)


# --- Derived identity ---------------------------------------------------------

## Read from the eligibility rule, never restated here.
func support_id() -> StringName:
	return eligibility.support_id if eligibility != null else &""


## Read from the eligibility rule, never restated here. Presentation only.
func display_name() -> String:
	return eligibility.display_name if eligibility != null else ""


func label() -> String:
	return eligibility.label() if eligibility != null else "<no rule>"


# --- Eligibility, through the ONE query ---------------------------------------

## Whether this support may be attached to `profile` at all. Delegated in full
## to `SupportEligibility`, so a weighted selection can never accept a pair the
## eligibility contract refuses.
func allows(profile: SkillTagProfile) -> bool:
	if eligibility == null or profile == null:
		return false
	return eligibility.allows(profile)


func refusal(profile: SkillTagProfile) -> String:
	if eligibility == null:
		return "%s has no eligibility rule" % support_id()
	return eligibility.refusal(profile)


# --- The weight model ---------------------------------------------------------

## The bonuses this definition declared for tags `profile` actually carries, in
## the canonical vocabulary order of `SkillTags.ALL` — so the diagnostic a
## caller reads back is reproducible rather than dependent on the order the
## bonuses happened to be written in.
##
## Membership is vocabulary-gated through `SkillTagProfile.satisfies()`, so a
## bonus can never be paid for an unrecognised tag even if a definition somehow
## carried one and the Skill carried the same spelling.
func matching_bonuses_for(profile: SkillTagProfile) -> Dictionary:
	var matched: Dictionary = {}
	if profile == null:
		return matched
	for tag: StringName in SkillTags.ALL:
		if tag_bonuses.has(tag) and profile.satisfies(tag):
			matched[tag] = int(tag_bonuses[tag])
	return matched


## base weight + the bonuses for the tags this Skill carries. Pure, total, and
## bounded by `MAXIMUM_WEIGHT` for any definition that passes `problem()`.
func effective_weight_for(profile: SkillTagProfile) -> int:
	var matched: Dictionary = matching_bonuses_for(profile)
	var total: int = base_weight
	for tag: Variant in matched:
		total += int(matched[tag])
	return total


## The largest effective weight this definition could ever produce: base plus
## every declared bonus, whether or not any Skill carries all of them. This is
## what the ceiling is enforced against, which is what makes the bound hold for
## a Skill that does not exist yet.
func maximum_possible_weight() -> int:
	var total: int = base_weight
	for tag: Variant in tag_bonuses:
		var bonus: Variant = tag_bonuses[tag]
		if typeof(bonus) == TYPE_INT:
			total += int(bonus)
	return total


# --- Record integrity ---------------------------------------------------------

## Returns "" when the definition is coherent, or the FIRST problem found, in
## plain language. Every invalid case the selector refuses is reported here, so
## a caller can find out what is wrong without running a selection.
func problem() -> String:
	if eligibility == null:
		return "a support definition must carry an eligibility rule"
	var rule_problem: String = eligibility.problem()
	if not rule_problem.is_empty():
		return rule_problem
	var id: StringName = support_id()
	if base_weight < MINIMUM_BASE_WEIGHT:
		return "%s: base weight %d is below the minimum of %d" % [
			id, base_weight, MINIMUM_BASE_WEIGHT,
		]
	for tag: Variant in tag_bonuses:
		if typeof(tag) != TYPE_STRING_NAME:
			return "%s: tag bonus key %s is not a tag identifier" % [id, tag]
		var weighted: StringName = tag as StringName
		if not SkillTags.is_known(weighted):
			return "%s: weights %s, which is not a recognised tag" % [id, weighted]
		var bonus: Variant = tag_bonuses[weighted]
		if typeof(bonus) != TYPE_INT:
			return "%s: the bonus for %s is not an integer" % [id, weighted]
		if int(bonus) < 0:
			return "%s: the bonus for %s is %d, and a bonus must not be negative" % [
				id, weighted, int(bonus),
			]
	var ceiling: int = maximum_possible_weight()
	if ceiling > MAXIMUM_WEIGHT:
		return "%s: its maximum possible weight %d exceeds the ceiling of %d" % [
			id, ceiling, MAXIMUM_WEIGHT,
		]
	## ASKED LAST, so every fault this record could already report is still
	## reported first and in the same words (D-301).
	return maximum_rank_problem()


## Returns "" when this definition declares a usable maximum rank, or the reason it
## does not, in plain language. `problem()` asks it last, so every selection refuses
## a definition this answers for — a support that silently could not be ranked would
## otherwise look exactly like one whose pairs had merely reached their maximum.
func maximum_rank_problem() -> String:
	if maximum_rank == UNDECLARED_MAXIMUM_RANK:
		return "%s declares no maximum rank, so a held pair of it cannot be raised" % support_id()
	if maximum_rank < MINIMUM_MAXIMUM_RANK:
		return "%s: maximum rank %d is below the first rank of %d" % [
			support_id(), maximum_rank, MINIMUM_MAXIMUM_RANK,
		]
	return ""


func weight_line() -> String:
	if tag_bonuses.is_empty():
		return "base weight %d" % base_weight
	var parts: PackedStringArray = PackedStringArray()
	for tag: StringName in SkillTags.ALL:
		if tag_bonuses.has(tag):
			parts.append("%s +%d" % [tag, int(tag_bonuses[tag])])
	return "base weight %d; %s" % [base_weight, ", ".join(parts)]


func describe() -> String:
	if eligibility == null:
		return "<a definition with no eligibility rule>"
	return "%s — %s; %s" % [label(), eligibility.rule_line(), weight_line()]
