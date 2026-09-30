class_name PlayerStats
extends RefCounted
## Riftwrought — Roguelite Foundation C1: the ONE shared player stat vocabulary
## and the ONE place a percentage becomes a value (decision D-229).
##
## WHY THIS FILE EXISTS. A future offer that says "+10% Global Damage" needs two
## things that do not exist anywhere in this project yet: an identifier for the
## quantity it moves, and an agreed rule for what happens when a second one
## arrives. Today every modifier the project ships is written directly against a
## kernel field, which is correct for one modifier and has no answer at all for
## two — nothing in the running game can currently add two percentages together
## and say what they mean. This file answers exactly that, for a deliberately
## small set of stats, and stops.
##
## SIX STATS, AND THE SET IS CLOSED. Three combat and defence, three utility.
## They are SHARED PLAYER STATS rather than Skill or class properties: none of
## them names a Skill, none requires a Skill to exist, and a future class may
## value them differently without any of them changing meaning.
##
## THE ARITHMETIC IS THE CANONICAL ONE, NOT A NEW ONE.
## `design/ATTRIBUTES_AND_DAMAGE_MODEL.md` section 17 already fixes it: "All
## applicable Increased and Reduced modifiers combine additively" and "= 60%
## increased Damage / = a multiplier of 1.60". So percentages ADD first and the
## sum is applied ONCE. +10% and +20% are +30%, a multiplier of 1.30 — never two
## multiplications producing 1.32. The difference is small at two modifiers and
## enormous at ten, and it is the single most common way a stat system quietly
## becomes a different game.
##
## THE RATE MODE IS THE SAME CANONICAL RELATIONSHIP READ THE OTHER WAY.
## `design/PASSIVE_PROGRESSION.md` section 14 names it: "Effective interval =
## Base interval / (1 + total Increased Generation Rate)", "the ordinary rate
## relationship". A duration produced by a rate is DIVIDED, so an increase makes
## it shorter. This is also exactly the relationship the project's own accepted
## combat records already use to turn an increased-speed fraction into an action
## time, which is why the rate mode is a restatement rather than an invention.
##
## ONE CONCEPT, ONE IDENTIFIER, AND THE RECONCILIATION IS WRITTEN DOWN. Five of
## these six quantities already have a base value somewhere in the project and
## exactly one of them already has an increase. This file introduces NO second
## field for any of them: it names the quantity and computes a number, and it is
## the eventual integration's job to hand that number to the field that already
## exists. The existing base fields, in the project's own spelling, are
## `physical_damage`, `action_time`, `max_life`, `max_speed` and
## `total_experience`; the one existing increase is `increased_attack_speed`,
## aggregated one layer up as `increased_attack_and_cast_speed`, which is the
## quantity `skill_speed` names. `pickup_radius` is the one stat with no
## existing character-owned base at all — today's `interaction_range` belongs to
## the dropped item rather than to the character — and that gap is recorded as a
## deferred question rather than closed by inventing a base here.
##
## IT REFUSES WHERE THE SHIPPED KERNEL CLAMPS, AND THE DIVERGENCE IS STATED
## RATHER THAN HIDDEN. The accepted combat records floor an increase at -0.95 so
## their divisor can never reach zero. This foundation instead REFUSES any total
## that would make `1 + total` zero or negative, because a silent clamp turns a
## data error into a plausible number and this layer has no player waiting on an
## answer. Nothing is retrofitted and no accepted value moves: the two rules
## cannot disagree today, because nothing in the running game calls this file.
## Reconciling them belongs to runtime integration and is deferred.
##
## THE PROJECT OWNER ACCEPTED THAT DIVERGENCE AND SAID WHERE SANITIZATION MAY
## HAPPEN (D-230). Invalid arithmetic continues to FAIL here rather than being
## silently clamped, and a runtime layer may SANITIZE before calling this file.
## `design/ATTRIBUTES_AND_DAMAGE_MODEL.md` section 17's own floor — "the
## resulting multiplier cannot reduce a component below zero damage" —
## constrains a damage component's RESULT, so it belongs to that runtime layer
## rather than here. THE TWO STILL OWE A RECONCILIATION, which the paragraph
## above defers: for a magnitude stat this file computes exactly section 17's
## multiplier, so a total of -1.5 is zero damage by canon and a refusal here.
## Saying they "cannot collide" would retire a live task by assertion, and a
## floor on a result cannot be delivered by clamping an input in any case. A
## NEGATIVE BASE VALUE REMAINS INVALID for all six stats, confirmed rather than
## newly decided.
##
## NORMALIZED VALUES THROUGHOUT. 0.10 is 10% increased, everywhere, in every
## field and every argument. Percent-typed values are a presentation concern and
## are produced only by the clearly separated presentation section at the end of
## this file; nothing in the calculation path reads or writes a formatted
## string.
##
## STILL ABSENT, AND DELIBERATELY: no card, no offer, no pool, no weight, no XP
## drop, no collectible, no cap, no diminishing return, no "more" or "less"
## multiplier, no flat added value, no conversion, no condition, no duration, no
## per-run state, no persistence, no UI, and no default base value for any stat.
## Every one of those is its own decision with its own authorization. This file
## names six quantities and applies one percentage to one number.

# --- The six stable identifiers -----------------------------------------------
#
# snake_case, mechanical, never displayed. Nothing persists them yet, so they
# are free to be chosen well rather than inherited; once anything holds one they
# stop being free, which is why the presentation name is a separate field.

const GLOBAL_DAMAGE: StringName = &"global_damage"
const SKILL_SPEED: StringName = &"skill_speed"
const MAXIMUM_LIFE: StringName = &"maximum_life"
const MOVEMENT_SPEED: StringName = &"movement_speed"
const EXPERIENCE_GAIN: StringName = &"experience_gain"
const PICKUP_RADIUS: StringName = &"pickup_radius"

## Every stat, in the canonical reading order the vocabulary is declared in —
## combat and defence first, utility second, each in its declared order. Every
## list this file emits uses this order, so two callers can never disagree about
## which stat comes first.
const ALL: Array[StringName] = [
	GLOBAL_DAMAGE, SKILL_SPEED, MAXIMUM_LIFE,
	MOVEMENT_SPEED, EXPERIENCE_GAIN, PICKUP_RADIUS,
]

## The exclusive lower bound on a total increased percentage. At exactly -1.0 the
## scale is zero, which erases a magnitude and divides by zero; below it the
## scale is negative, which reverses one and produces a negative duration for the
## other. Both are refused rather than clamped — see the divergence note above.
const MINIMUM_TOTAL_INCREASED: float = -1.0


## The six definitions, built fresh on every call so a caller cannot alter the
## vocabulary through a reference it was only given to read.
##
## THIS IS THE ONLY PLACE A STAT'S CATEGORY, MODE OR UNIT IS WRITTEN. The
## category lists below are DERIVED from these records rather than typed a
## second time, so a stat cannot be filed under one category here and another
## there; drift is made impossible instead of merely detectable.
static func definitions() -> Array[PlayerStatDefinition]:
	var out: Array[PlayerStatDefinition] = []

	## Scales the damage a Hit deals. Canon writes the modifier as "increased
	## Damage" and the resulting multiplier as 1.60 for +60%
	## (`design/ATTRIBUTES_AND_DAMAGE_MODEL.md` section 17).
	out.append(PlayerStatDefinition.of(
		GLOBAL_DAMAGE, "Global Damage",
		PlayerStatDefinition.Category.COMBAT_DEFENCE,
		PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
		PlayerStatDefinition.Unit.DAMAGE_POINTS
	))

	## Shortens the time one Skill use takes. A RATE, so it divides: the value
	## that comes out is an action time in seconds, and more of the stat means
	## less of the value.
	##
	## IT IS A DELIBERATE UMBRELLA, AND THE TWO STATS IT COVERS STAY DISTINCT
	## (D-230). Skill Speed connects Attack Speed and Cast Speed WHERE IT IS
	## EXPLICITLY APPLIED; it does not merge or replace them, and each remains
	## its own stat with its own modifiers and its own equipment ownership.
	## `design/SKILLS_AND_SKILL_MODIFICATION.md` section 15 says "Attack Speed
	## and Cast Speed remain separate unless a mechanic deliberately connects
	## them" — that sentence is a permission, and this is the mechanic that
	## deliberately connects them, so nothing in canon is contradicted by it.
	##
	## WHAT IT DOES NOT REACH (D-230). Skill Speed does not inherently alter
	## cooldown recovery, periodic-effect tick rates, movement, trigger
	## schedules or minion speeds. Each of those is a separate canonical
	## quantity rather than an omission: cooldown recovery is its own affix
	## family with its own slot ownership, a trigger's activation-rate limit
	## belongs to the trigger contract, movement is its own stat, and a minion
	## carries its own statistics.
	##
	## THE CHANNEL CASE IS SETTLED, AND IT IS AN INCLUSION RATHER THAN AN
	## EXCEPTION (D-232). Skill Speed AFFECTS Channel cadence when a Channel
	## explicitly derives that cadence from Attack Speed or Cast Speed.
	## `design/SKILLS_AND_SKILL_MODIFICATION.md` section 15's `## Channeled
	## Skills` states "Channel rate scales with Attack Speed or Cast Speed
	## according to whether the Skill is an Attack or Spell", so such a Channel's
	## cadence is defined against the two stats the umbrella connects — it is
	## reached BY the umbrella rather than let through the exclusion list above.
	## The trigger is the EXPLICIT derivation: a Channel that does not derive its
	## cadence from either stat is not reached.
	##
	## AND THREE THINGS IT STILL DOES NOT DO, STATED SO THEY CANNOT BE INFERRED.
	## Moving a Channel's cadence does NOT make individual pulses separate Skill
	## Uses — the same canonical section already says pulses do not count as
	## repeated uses. It does NOT cause Rift Shard generation per pulse. And it
	## does NOT affect Damage-over-Time tick rates, which stay outside this stat
	## exactly as the exclusion list above says.
	out.append(PlayerStatDefinition.of(
		SKILL_SPEED, "Skill Speed",
		PlayerStatDefinition.Category.COMBAT_DEFENCE,
		PlayerStatDefinition.Mode.INCREASED_RATE,
		PlayerStatDefinition.Unit.SECONDS
	))

	## Scales the character's maximum Life. Canon's own formula is
	## "(Base Maximum Life + flat added Maximum Life) x (1 + total increased
	## Maximum Life)" — this foundation implements only the second half of that,
	## because flat added values are not in scope.
	out.append(PlayerStatDefinition.of(
		MAXIMUM_LIFE, "Maximum Life",
		PlayerStatDefinition.Category.COMBAT_DEFENCE,
		PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
		PlayerStatDefinition.Unit.LIFE_POINTS
	))

	## Scales how fast the character moves, in metres per second. A speed is a
	## magnitude here rather than a rate producing a duration: the value that
	## comes out is the speed itself, so it multiplies.
	out.append(PlayerStatDefinition.of(
		MOVEMENT_SPEED, "Movement Speed",
		PlayerStatDefinition.Category.UTILITY,
		PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
		PlayerStatDefinition.Unit.METRES_PER_SECOND
	))

	## Scales experience awarded. It moves the AMOUNT, never the requirement:
	## nothing here touches a level curve.
	out.append(PlayerStatDefinition.of(
		EXPERIENCE_GAIN, "Experience Gain",
		PlayerStatDefinition.Category.UTILITY,
		PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
		PlayerStatDefinition.Unit.EXPERIENCE_POINTS
	))

	## Scales the RADIUS, in metres, and deliberately not the covered area. The
	## two are different stats wearing one name: +100% radius is exactly twice
	## the radius and four times the ground, while +100% area would be about
	## +41% radius. Doubling the radius is the honest reading of the words on the
	## card, it is the one a player can see, and the unit below says metres so
	## that the choice is declared rather than left to be inferred from a number.
	##
	## WHAT IT MOVES, AND ONLY THAT (D-230; the resource named under D-232).
	## Pickup Radius applies to **Experience Motes** — one Experience Mote, many
	## Experience Motes — the presentation name for an automatically collected
	## experience pickup, and to future run resources EXPLICITLY CLASSIFIED for
	## automatic pickup. Explicit classification is the rule rather than
	## resemblance: a resource is reached by this stat because something says it
	## is, not because it happens to be small and on the ground.
	##
	## IT DOES NOT REACH GEAR PICKUP, manual interaction distance, or mouse click
	## range. `design/UI_AND_USER_EXPERIENCE.md` section 27 governs ground-item
	## inspection and pickup, and both of its manual routes — the mouse ground
	## label and the controller proximity aid — are untouched by this stat.
	##
	## THE NAME IS TERMINOLOGY ONLY AND NOTHING WAS BUILT FOR IT. "Mote" was
	## chosen over the working phrase "XP shard" because `Shard` is the signature
	## Rift Shard, which canon prints unqualified on screen; a second referent on
	## that noun would collide with the class identity itself. No Experience Mote
	## exists in the project: no pickup, no collector, no drop, no counter and no
	## scene.
	## `design/UI_AND_USER_EXPERIENCE.md` section 27 governs ground-item
	## inspection and pickup, and both of its manual routes — the mouse ground
	## label and the controller proximity aid — are deliberately untouched by
	## this stat.
	##
	## IT IS STILL A RESERVATION RATHER THAN A DESCRIPTION OF SHIPPED BEHAVIOUR,
	## AND NAMING THE RESOURCE DID NOT CREATE IT. Canon states no collection
	## radius anywhere; its one automatic-collection sentence puts crafting
	## materials into a ledger and gives no distance for it. The project itself
	## collects NOTHING automatically — it holds no ledger and no run resource at
	## all, and the one pickup it does have is manual on both devices. So this
	## stat still names a quantity a later mechanic must supply a base for, and
	## that base is still the deferred question recorded when the vocabulary was
	## delivered.
	out.append(PlayerStatDefinition.of(
		PICKUP_RADIUS, "Pickup Radius",
		PlayerStatDefinition.Category.UTILITY,
		PlayerStatDefinition.Mode.INCREASED_MULTIPLIER,
		PlayerStatDefinition.Unit.METRES
	))

	return out


static func is_known(stat_id: StringName) -> bool:
	return ALL.has(stat_id)


## The definition for `stat_id`, or null when the vocabulary does not recognise
## it. Null rather than a placeholder: a stat that does not exist must not be
## quietly given default arithmetic.
static func definition(stat_id: StringName) -> PlayerStatDefinition:
	for record: PlayerStatDefinition in definitions():
		if record.stat_id == stat_id:
			return record
	return null


## The ids in one category, in canonical order. Derived from the records, never
## from a second list.
static func in_category(category: PlayerStatDefinition.Category) -> Array[StringName]:
	var out: Array[StringName] = []
	for record: PlayerStatDefinition in definitions():
		if record.category == category:
			out.append(record.stat_id)
	return out


## Every problem with the shipped vocabulary, or an empty array. It is a whole
## list rather than a first problem, because a vocabulary is validated once and
## a reader wants every fault at once rather than one per run.
static func problems() -> PackedStringArray:
	var found: PackedStringArray = PackedStringArray()
	var seen: Array[StringName] = []
	var records: Array[PlayerStatDefinition] = definitions()
	for record: PlayerStatDefinition in records:
		var record_problem: String = record.problem()
		if not record_problem.is_empty():
			found.append(record_problem)
		if seen.has(record.stat_id):
			found.append("duplicate stat id %s" % record.stat_id)
		seen.append(record.stat_id)
		if not ALL.has(record.stat_id):
			found.append("%s is defined but is not in the canonical order" % record.stat_id)
	for stat_id: StringName in ALL:
		if not seen.has(stat_id):
			found.append("%s is in the canonical order but has no definition" % stat_id)
	if records.size() != ALL.size():
		found.append("%d definitions against %d canonical ids" % [records.size(), ALL.size()])
	return found


# --- The one calculation path --------------------------------------------------
#
# EVERY number this foundation produces comes out of `apply()`. It is pure,
# total and static: it reads no field, no clock, no random source and no file,
# it names no class outside this foundation, and calling it twice with the same
# three arguments always returns the same number.

## Applies `total_increased` to `base_value` for `stat_id`, using that stat's
## declared mode. `total_increased` is the ALREADY-SUMMED total: adding
## percentages is the accumulator's job, and doing it here as well is how a
## modifier ends up counted twice.
##
## Returns a value that either carries the whole derivation or carries a stated
## reason and nothing else. It never returns a partly-filled result and it never
## substitutes a default for an input it could not use.
##
## It is a LOOKUP in front of `apply_definition()` and holds no arithmetic of
## its own, so there is still exactly one place a percentage becomes a value.
static func apply(
	stat_id: StringName,
	base_value: float,
	total_increased: float
) -> PlayerStatValue:
	var record: PlayerStatDefinition = definition(stat_id)
	if record == null:
		return PlayerStatValue.failed(
			"%s is not a recognised player stat" % _named(stat_id))
	return apply_definition(record, base_value, total_increased)


## The calculation itself, against a definition rather than an id.
##
## IT TAKES A RECORD SO THAT AN INVALID ONE CAN ACTUALLY REACH IT. Every
## definition `definition()` can return is built from the constants above and is
## therefore valid, so a refusal that only the id-based entry point could deliver
## would be a guard nothing can reach — and a guard nothing can reach proves
## nothing. This entry point is the one a future caller holding its own record
## will use, and it is the one the invalid-definition refusals are driven
## through.
static func apply_definition(
	record: PlayerStatDefinition,
	base_value: float,
	total_increased: float
) -> PlayerStatValue:
	if record == null:
		return PlayerStatValue.failed("a calculation needs a stat definition")
	var stat_id: StringName = record.stat_id
	var record_problem: String = record.problem()
	if not record_problem.is_empty():
		return PlayerStatValue.failed(record_problem)
	if not is_finite(base_value):
		return PlayerStatValue.failed(
			"%s: the base value is not a finite number" % stat_id)
	if not is_finite(total_increased):
		return PlayerStatValue.failed(
			"%s: the total increased is not a finite number" % stat_id)
	## Every stat in this vocabulary measures a magnitude, a duration or a
	## distance, and none of the six can be negative before a percentage is
	## applied. Refusing here is what makes "a rate can never produce a negative
	## action time" a property of the arithmetic rather than a hope about inputs:
	## a non-negative base and a strictly positive scale cannot produce one.
	if base_value < 0.0:
		return PlayerStatValue.failed(
			"%s: the base value %.6f is negative" % [stat_id, base_value])
	var scale: float = 1.0 + total_increased
	if scale <= 0.0:
		return PlayerStatValue.failed(
			"%s: a total of %.6f increased would make the scale %.6f, and a scale must be positive"
				% [stat_id, total_increased, scale])
	var computed: float = 0.0
	match record.mode:
		PlayerStatDefinition.Mode.INCREASED_MULTIPLIER:
			computed = base_value * scale
		PlayerStatDefinition.Mode.INCREASED_RATE:
			computed = base_value / scale
		_:
			## DEFENCE IN DEPTH, AND DELIBERATELY UNREACHABLE FROM HERE: an
			## unrecognised mode is already refused by `problem()` a few lines
			## above, so this branch cannot fire today and the suite does not
			## pretend to drive it. It stays because a `match` on a mode with no
			## default is how a mode added later starts returning a silent
			## default value instead of an error.
			return PlayerStatValue.failed(
				"%s: declares calculation mode %d, which this vocabulary cannot apply"
					% [stat_id, record.mode])
	if not is_finite(computed):
		return PlayerStatValue.failed(
			"%s: base %.6f at a scale of %.6f did not produce a finite value"
				% [stat_id, base_value, scale])
	return PlayerStatValue.computed(
		stat_id, base_value, total_increased, scale, record.mode, computed)


# --- Presentation -------------------------------------------------------------
#
# Deliberately separate from the ids and the arithmetic above, and reached by
# nothing in the calculation path. A formatted string is never compared, parsed
# or fed back into a number.

## A normalized total as a percentage, for display only. 0.10 becomes "+10%".
static func format_increased(total_increased: float) -> String:
	if not is_finite(total_increased):
		return "an unusable total"
	return "%+.0f%%" % (total_increased * 100.0)


static func format_value(stat_id: StringName, value: float) -> String:
	var record: PlayerStatDefinition = definition(stat_id)
	if record == null:
		return "%.2f" % value
	return "%.2f %s" % [value, record.unit_name()]


## One stat's declared facts as a line. Used for diagnostics; nothing reads it
## back.
static func line(stat_id: StringName) -> String:
	var record: PlayerStatDefinition = definition(stat_id)
	if record == null:
		return "%s is not a recognised player stat" % _named(stat_id)
	return record.describe()


static func lines() -> PackedStringArray:
	var out: PackedStringArray = PackedStringArray()
	for record: PlayerStatDefinition in definitions():
		out.append(record.describe())
	return out


# --- Internals ----------------------------------------------------------------

## An empty id reads as nothing at all inside a refusal, which makes the reason
## unreadable exactly when it matters most.
static func _named(stat_id: StringName) -> String:
	var text: String = String(stat_id)
	return text if not text.strip_edges().is_empty() else "<an unnamed stat>"
