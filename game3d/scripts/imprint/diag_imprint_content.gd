class_name DiagImprintContent
extends RefCounted

## THE DIAGNOSTIC IMPRINT CONTENT — the minimum coherent content required to
## exercise the architecture, and NOTHING MORE.
##
## ============================================================================
## THIS IS NOT THE HUNTRESS ROSTER. IT IS NOT FINAL ANYTHING.
## ============================================================================
## The owner's ruling: "Implement only the minimum coherent content required to
## exercise the system" and "These three examples are diagnostic content, not the
## complete Huntress roster, final names, final values, final VFX or final
## balance."
##
## Every id begins with its Imprint type and contains `DIAG`, so no id can be
## mistaken for a canonical Skill in a log, a save or a report.
##
## ---------------------------------------------------------------------------
## AND IT DENIES BEING CANON, AGAINST THE ACTUAL CANONICAL LISTS.
## ---------------------------------------------------------------------------
## `canonical_first_mvp_skill_names()` and `canonical_first_mvp_augment_names()`
## quote canon's EIGHT named base Skills and SIXTEEN named Augments verbatim, so
## the suite can assert that no Imprint here bears one of those names. A denial
## checked against a real list is a boundary; a denial in a comment is not.
##
## ---------------------------------------------------------------------------
## WHY A BALLISTA AND NOT A TRAP.
## ---------------------------------------------------------------------------
## The ruling: "Choose whichever exposes more of the architecture without
## inventing a second framework." A trap would need its own trigger contract,
## which canon defines and this stage is not authorized to implement. A BALLISTA
## exercises FIVE things the architecture already owes and a trap would not:
##   1. the `Duration` family -- duration, instance limit and replacement;
##   2. a Ground targeting archetype, so a second archetype is proved;
##   3. autonomous acquisition WITHOUT it being a Minion;
##   4. REUSE OF THE SAME PROJECTILE AUGMENT the bow Skill uses, on its own
##      bolts -- ONE framework serving two Skills, which is the whole claim;
##   5. a Transform that makes a temporary thing persistent while reducing its
##      number, which is canon's own worked example of a Transform.

# --- Skill Imprints ----------------------------------------------------------
const SKILL_STORM := "SKILL_IMPRINT_DIAG_STORM_SHOT"
const SKILL_BALLISTA := "SKILL_IMPRINT_DIAG_WARD_BALLISTA"
const SKILL_BEASTS := "SKILL_IMPRINT_DIAG_BEAST_PACK"
const SKILL_AURA := "SKILL_IMPRINT_DIAG_PACK_WARD"

# --- Augment Imprints --------------------------------------------------------
const AUG_SPLIT := "AUGMENT_IMPRINT_DIAG_SPLIT_VOLLEY"
const AUG_FORK := "AUGMENT_IMPRINT_DIAG_FORKING"
const AUG_TEMPERED := "AUGMENT_IMPRINT_DIAG_TEMPERED_DRAW"
const AUG_SUREFOOT := "AUGMENT_IMPRINT_DIAG_SUREFOOT_RELEASE"
const AUG_WARD := "AUGMENT_IMPRINT_DIAG_EXTENDED_WARD"
const AUG_PACK := "AUGMENT_IMPRINT_DIAG_PACK_INSTINCT"
const AUG_TITHE := "AUGMENT_IMPRINT_DIAG_LIFE_TITHE"

# --- Transform Imprints ------------------------------------------------------
const XF_ORBIT := "TRANSFORM_IMPRINT_DIAG_TEMPEST_ORBIT"
const XF_RAIN := "TRANSFORM_IMPRINT_DIAG_SPLINTER_RAIN"
const XF_ANCHOR := "TRANSFORM_IMPRINT_DIAG_SIEGE_ANCHOR"

## THE EXHAUSTIVE SET. Pinned in both directions by the suite: an Imprint that
## exists and is not here fails, and an id here that does not exist fails.
const ALL_IMPRINTS := [
	SKILL_STORM, SKILL_BALLISTA, SKILL_BEASTS, SKILL_AURA,
	AUG_SPLIT, AUG_FORK, AUG_TEMPERED, AUG_SUREFOOT, AUG_WARD, AUG_PACK, AUG_TITHE,
	XF_ORBIT, XF_RAIN, XF_ANCHOR,
]

# --- Configurations ----------------------------------------------------------
const CFG_VOLLEY := "CFG_DIAG_STORM_VOLLEY"
const CFG_BALLISTA := "CFG_DIAG_WARD_BALLISTA"
const CFG_BEASTS := "CFG_DIAG_BEAST_PACK"
const CFG_LOW := "CFG_DIAG_STORM_LOW_RANK"
const CFG_TEMPEST := "CFG_DIAG_TEMPEST_ORBIT"
const CFG_AURA := "CFG_DIAG_PACK_WARD"

const ALL_CONFIGURATIONS := [
	CFG_VOLLEY, CFG_BALLISTA, CFG_BEASTS, CFG_LOW, CFG_TEMPEST, CFG_AURA,
]

## The THREE the ruling asked for, named apart from their supporting siblings so
## "three representative builds" is a countable claim rather than a vibe.
const THE_THREE_REPRESENTATIVE := [CFG_VOLLEY, CFG_BALLISTA, CFG_BEASTS]

## Their supporting Configurations, and WHY each exists. Nothing here is extra
## content for its own sake: each one makes a comparison the ruling demands
## possible.
const SUPPORTING_CONFIGURATIONS := [
	[CFG_LOW, "the SAME Storm Shot Imprint at Effective Rank 1, so low and high rank can be compared "
	 + "side by side -- and so the SHARED COOLDOWN across Configurations of one Skill is observable"],
	[CFG_TEMPEST, "the SAME Storm Shot Imprint carrying its materially identity-changing Transform, so "
	 + "the identity change can be measured against the untransformed build"],
	[CFG_AURA, "the Persistent aura, which supports the beasts and carries the reservation prototype"],
]

## Mastered ranks at start-up. DELIBERATELY UNEVEN: a uniform set would make the
## Mastered/Effective distinction invisible, and would hide the catch-up rule.
##
## ============================================================================
## SINCE D-380 THESE ARE APPLIED AS DECLARED DIAGNOSTIC SEEDING, NOT AS A FLOOR.
## ============================================================================
## From D-375 until D-380 each Imprint was LEARNED at this rank --
## `lib.learn(imp, STARTING_MASTERY[id])` -- which D-378 section 2 read as
## "diagnostic seeding". D-378 OD-01 rules out any acquisition-time floor, so
## every Imprint is now LEARNED at rank 1 / 0 XP, and THEN raised to this rank by
## `ImprintLibrary.diagnostic_seed_prior_mastery()`, which stands in for
## progression an established character already EARNED. THE VALUES ARE
## UNCHANGED, so every accepted rank measurement still reads the same numbers.
const STARTING_MASTERY := {
	SKILL_STORM: 20, SKILL_BALLISTA: 12, SKILL_BEASTS: 15, SKILL_AURA: 10,
	AUG_SPLIT: 14, AUG_FORK: 9, AUG_TEMPERED: 11, AUG_SUREFOOT: 6,
	AUG_WARD: 8, AUG_PACK: 13, AUG_TITHE: 4,
	XF_ORBIT: 7, XF_RAIN: 10, XF_ANCHOR: 8,
}

## The diagnostic character progression rank the catch-up rule measures against.
## At 16 it is AHEAD of most Imprints and BEHIND Storm Shot's 20, so both the
## catch-up multiplier AND its absence are observable, and `AUG_TITHE` at rank 4
## is far enough behind to hit the CEILING -- which is the property that matters.
const STARTING_CHARACTER_RANK := 16

# =============================================================================
# CANON, QUOTED SO THE DENIALS CAN BE CHECKED AGAINST IT
# =============================================================================

## `design/SKILLS_AND_SKILL_MODIFICATION.md` section 16 -- the eight named base
## Skills of the first-MVP working roster.
static func canonical_first_mvp_skill_names() -> Array:
	return ["Quick Strike", "Faultbreaker", "Splinter Shot", "Emberbolt",
		"Void Lance", "Cinder Field", "Rift Step", "Void Attunement"]

## The same document -- the sixteen named first-MVP Augments.
static func canonical_first_mvp_augment_names() -> Array:
	return ["Expanded Area", "Concentrated Area", "Additional Projectile", "Pierce",
		"Chain", "Return", "Repeat", "Increased Duration", "Fire Conversion",
		"Void Conversion", "Bleed Emphasis", "Ignite Emphasis", "Unravel Emphasis",
		"Third Passage", "Deep Attunement", "Nova Form"]

# =============================================================================
# THE IMPRINTS
# =============================================================================

static func _skill(id: String, nm: String, cls: int, tags: Array, targeting: String,
		moves: Array, summary: String) -> Imprint:
	var i := Imprint.new(id, nm, Imprint.Kind.SKILL)
	i.skill_class = cls
	i.provides_tags.assign(tags)
	i.targeting = targeting
	i.rank_moves.assign(moves)
	i.summary = summary
	return i

static func _mod(id: String, nm: String, kind: int, requires: Array, affects: Array,
		tradeoff: String, moves: Array, summary: String) -> Imprint:
	var i := Imprint.new(id, nm, kind)
	i.requires_tags.assign(requires)
	i.affects.assign(affects)
	i.tradeoff = tradeoff
	i.rank_moves.assign(moves)
	i.summary = summary
	return i

## Builds the Imprint Library. LEARNING IS PERMANENT AND IDEMPOTENT.
static func build_library() -> ImprintLibrary:
	var lib := ImprintLibrary.new()
	lib.character_progress_rank = STARTING_CHARACTER_RANK

	# --- SKILL IMPRINTS ------------------------------------------------------
	var storm := _skill(SKILL_STORM, "Diagnostic Storm Shot", Imprint.SkillClass.PRIMARY,
		["Attack", "Projectile", "Hit", "Lightning"], "directional",
		["Mana cost", "cooldown"],
		"A bow-fired Lightning projectile. THE PRIMARY Skill of the diagnostic set, and the "
		+ "reason a primary Skill costs more Capacity than a secondary one. Lightning is a "
		+ "CANONICAL damage type that is NOT first-MVP content (conflict X-05).")
	lib.learn(storm)

	# IT CARRIES `Projectile` BECAUSE IT FIRES BOLTS. That is not decoration: it
	# is the tag that makes the SAME learned Split Volley Imprint apply to this
	# emplacement's own bolts, which is the whole "one framework, two Skills"
	# claim. Canon's Fireball example is the precedent -- one Skill, several
	# components, different tags on each.
	# It does NOT carry `Minion`, so Minion Augments correctly do not apply.
	var ballista := _skill(SKILL_BALLISTA, "Diagnostic Ward Ballista", Imprint.SkillClass.SECONDARY,
		["Attack", "Ground", "Projectile", "Hit", "Physical", "Duration"], "ground-targeted",
		["duration", "Mana cost"],
		"A placed, autonomous ballista that acquires and fires on its own. It proves the "
		+ "Imprint/Configuration rules support a NON-DIRECT attack style, and it consumes the "
		+ "SAME projectile Augment the bow Skill does.")
	lib.learn(ballista)

	var beasts := _skill(SKILL_BEASTS, "Diagnostic Beast Pack", Imprint.SkillClass.SECONDARY,
		["Minion", "Hit", "Physical"], "self-centered",
		["beast count", "Mana cost"],
		"Summons autonomous beasts that follow, acquire targets and attack through AI. THEY "
		+ "ARE THE PRIMARY DAMAGE SOURCE of this build, and there is NO command input of any "
		+ "kind. The future rare command beast is NOT created.")
	lib.learn(beasts)

	var aura := _skill(SKILL_AURA, "Diagnostic Pack Ward", Imprint.SkillClass.PERSISTENT,
		["Spell", "Area"], "self-centered",
		["reservation", "beast support"],
		"A Persistent aura that RESERVES Mana and supports the beasts. Higher rank is a "
		+ "stronger aura that reserves MORE -- canon's own Deep Attunement pattern.")
	aura.reserves = true
	lib.learn(aura)

	# --- AUGMENT IMPRINTS ----------------------------------------------------
	var split := _mod(AUG_SPLIT, "Split Volley", Imprint.Kind.AUGMENT,
		["Projectile"], ["projectile count", "Mana cost"],
		"More Mana per use, and the projectiles share the same spread rather than converging",
		["Mana surcharge", "projectile count at rank thresholds"],
		"Additional projectiles. REUSABLE: the same learned Imprint serves the bow Skill AND "
		+ "the ballista's own bolts, with ONE mastery record and ONE XP award.")
	lib.learn(split)

	var fork := _mod(AUG_FORK, "Forking", Imprint.Kind.AUGMENT,
		["Projectile", "Hit"], ["projectile behaviour on impact", "Mana cost"],
		"Forked projectiles deal a FRACTION of the parent's damage, and the fork depth is BOUNDED",
		["Mana surcharge", "fork damage fraction"],
		"On its first impact the projectile forks. THE GENERATION LIMIT IS THE POINT: canon "
		+ "forbids a rule that can create an endless chain, and a fork is the same shape of "
		+ "failure as a self-triggering trigger.")
	lib.learn(fork)

	var tempered := _mod(AUG_TEMPERED, "Tempered Draw", Imprint.Kind.AUGMENT,
		["Hit"], ["damage", "action duration", "Mana cost"],
		"A LONGER action and more Mana for More Damage -- a rhythm cost, not free power",
		["Mana surcharge", "action duration"],
		"More Damage at the cost of a slower action. Installed in THREE Configurations, which "
		+ "is how the no-multiplied-XP rule is measured.")
	lib.learn(tempered)

	var surefoot := _mod(AUG_SUREFOOT, "Surefoot Release", Imprint.Kind.AUGMENT,
		["Hit"], ["action duration", "damage", "Mana cost"],
		"Less Damage, in exchange for a shorter action",
		["action duration multiplier, which improves with rank"],
		"A faster action for less damage. It exists so a Configuration can legally hold FOUR "
		+ "Augments, which is what makes the fifth-modifier refusal unambiguously the SLOT "
		+ "rule rather than a tag rule.")
	lib.learn(surefoot)

	var ward := _mod(AUG_WARD, "Extended Ward", Imprint.Kind.AUGMENT,
		["Duration"], ["duration", "Mana cost"],
		"More Mana per placement",
		["Mana surcharge", "duration multiplier"],
		"Longer duration. It requires the DECLARED `Duration` tag, which the bow Skill does "
		+ "NOT carry -- so it is also the incompatible-tag negative control.")
	lib.learn(ward)

	var pack := _mod(AUG_PACK, "Pack Instinct", Imprint.Kind.AUGMENT,
		["Minion"], ["minion count", "minion damage", "Mana cost"],
		"Each beast deals Less Damage, and the summon costs more Mana",
		["Mana surcharge, which becomes cheaper with rank"],
		"One more beast, each dealing less. More bodies for less damage each is canon's "
		+ "minion-count tradeoff, not an unconditional upgrade.")
	lib.learn(pack)

	# ========================================================================
	# THE MANA->LIFE CONVERSION. PROPORTIONAL SINCE D-380 (D-378 OD-06).
	# ========================================================================
	# From D-375 until D-380 this modifier was "Life Tithe", reserving a FLAT
	# 26 % - 0.4 %/rank of maximum Life whatever it converted. The ruling
	# removes the flat tithe, so the DISPLAY NAME and the text changed with the
	# rule. THE ID IS KEPT (`AUGMENT_IMPRINT_DIAG_LIFE_TITHE`), so the accepted
	# suite's references and the D-375 / D-376 record stay traceable -- an id is
	# an identifier, and the RULE it carries is now proportional.
	var tithe := _mod(AUG_TITHE, "Life Conversion", Imprint.Kind.AUGMENT,
		[], ["reservation resource", "reservation amount"],
		"Life is reserved instead of Mana, IN PROPORTION to the Mana the effect would have reserved; the ratio improves with rank",
		["the conversion ratio, which becomes more efficient with rank"],
		"CONVERTS THE RESERVATION FROM MANA TO LIFE, PROPORTIONALLY: Life reserved = the "
		+ "fraction of maximum Mana the effect would reserve x a PROVISIONAL ratio. Exactly one "
		+ "resource is reserved, never both, and the whole Mana pool is then unreserved for "
		+ "regeneration. It requires a PERSISTENT Configuration -- expressed as a declared class "
		+ "because canon's tag vocabulary has no Reservation tag (X-15).")
	tithe.requires_classes = [Imprint.SkillClass.PERSISTENT]
	lib.learn(tithe)

	# --- TRANSFORM IMPRINTS --------------------------------------------------
	var orbit := _mod(XF_ORBIT, "Tempest Orbit", Imprint.Kind.TRANSFORM,
		["Projectile"], ["delivery", "targeting archetype", "tags", "duration", "Mana cost"],
		"It REMOVES the Projectile tag, so projectile Augments stop applying, and it costs more Mana",
		["orbit duration", "pulse interval"],
		"MATERIALLY IDENTITY-CHANGING: a directional projectile becomes a self-centred "
		+ "orbiting storm. Targeting changes from directional to self-centered and the "
		+ "Projectile tag is REMOVED -- which is exactly how canon's 'enabling tag removed' "
		+ "case is demonstrated without deleting anybody's Augment.")
	orbit.removes_tags.assign(["Projectile"])
	orbit.adds_tags.assign(["Area", "Duration"])
	orbit.sets_targeting = "self-centered"
	lib.learn(orbit)

	var rain := _mod(XF_RAIN, "Splinter Rain", Imprint.Kind.TRANSFORM,
		["Projectile"], ["delivery", "targeting archetype", "tags", "Mana cost"],
		"Ground-targeted volleys arrive on a delay instead of travelling from the character",
		["volley count", "Mana surcharge"],
		"A directional projectile becomes a ground-targeted falling volley. It KEEPS the "
		+ "Projectile tag, so projectile Augments still apply -- the deliberate contrast with "
		+ "Tempest Orbit, and the second Transform that makes the one-Transform refusal "
		+ "testable on a Configuration with slots to spare.")
	rain.adds_tags.assign(["Area"])
	rain.sets_targeting = "ground-targeted"
	lib.learn(rain)

	var anchor := _mod(XF_ANCHOR, "Siege Anchor", Imprint.Kind.TRANSFORM,
		["Duration"], ["instance limit", "duration", "Mana cost"],
		"ONE instance instead of two, and a much larger Mana cost",
		["Mana surcharge"],
		"Canon's own worked example of a Transform: 'make a temporary minion persistent while "
		+ "reducing its number.' One long-lived anchor replaces two short-lived ballistae.")
	lib.learn(anchor)

	# ========================================================================
	# DECLARED DIAGNOSTIC SEEDING — AFTER LEARNING, NEVER AS A FLOOR (OD-01).
	# ========================================================================
	# Every Imprint above was LEARNED at Mastered Rank 1 with 0 XP. These ranks
	# stand in for progression an established character already EARNED, so the
	# live review can see the Mastered / Effective split and the catch-up rule.
	# Iterated in ALL_IMPRINTS order so the seeding order is fixed.
	for id in ALL_IMPRINTS:
		lib.diagnostic_seed_prior_mastery(String(id), int(STARTING_MASTERY[id]))

	return lib

# =============================================================================
# THE CONFIGURATIONS
# =============================================================================

## Builds every Configuration. Returns id -> SkillConfiguration.
##
## EVERY INSTALL IS CHECKED. A build step that silently failed would produce a
## Configuration the panel describes and the runtime does not have, so a refusal
## here is pushed into the returned `problems` list rather than swallowed.
static func build_configurations(lib: ImprintLibrary) -> Dictionary:
	var out: Dictionary = {}
	var problems: Array[String] = []

	var mk := func(cfg_id: String, sid: String, mods: Array, ranks: Dictionary) -> SkillConfiguration:
		var c := SkillConfiguration.new(cfg_id, lib)
		var r := c.set_skill(sid)
		if not r["ok"]:
			problems.append("%s: %s" % [cfg_id, r["reason"]])
		for m in mods:
			var ri := c.install(String(m))
			if not ri["ok"]:
				problems.append("%s: %s" % [cfg_id, ri["reason"]])
		for k in ranks:
			var rr := c.set_effective_rank(String(k), int(ranks[k]))
			if not rr["ok"]:
				problems.append("%s: %s" % [cfg_id, rr["reason"]])
		return c

	out[CFG_VOLLEY] = mk.call(CFG_VOLLEY, SKILL_STORM,
		[AUG_SPLIT, AUG_FORK, AUG_TEMPERED], {})
	out[CFG_BALLISTA] = mk.call(CFG_BALLISTA, SKILL_BALLISTA,
		[AUG_WARD, AUG_SPLIT], {})
	out[CFG_BEASTS] = mk.call(CFG_BEASTS, SKILL_BEASTS,
		[AUG_PACK, AUG_TEMPERED], {})
	# THE LOW-RANK TWIN. Same Skill Imprint, Effective Rank 1, no modifiers.
	out[CFG_LOW] = mk.call(CFG_LOW, SKILL_STORM, [], {SKILL_STORM: 1})
	out[CFG_TEMPEST] = mk.call(CFG_TEMPEST, SKILL_STORM,
		[AUG_TEMPERED, XF_ORBIT], {})
	out[CFG_AURA] = mk.call(CFG_AURA, SKILL_AURA, [], {})

	out["__problems"] = problems
	return out

## The default binding plan. EIGHT bindings; THREE are deliberately EMPTY, so
## "bindings and equipped Configurations are distinct concepts" is visible on
## screen rather than only asserted in prose.
static func default_binding_plan() -> Array:
	return [CFG_VOLLEY, CFG_BALLISTA, CFG_BEASTS, CFG_LOW, CFG_TEMPEST, "", "", ""]

static func default_persistent_plan() -> Array:
	return [CFG_AURA]
