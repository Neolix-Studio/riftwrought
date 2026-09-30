class_name CinderContent
extends RefCounted

## THE CINDER FIELD CONTENT OF THE D-402 STAGE — exactly ONE canonical ACTIVE
## Skill Imprint, its ONE unmodified Configuration, and the loadout plan.
##
## ============================================================================
## THROUGH THE ACCEPTED ARCHITECTURE, NOT BESIDE IT.
## ============================================================================
## The owner: "Implement Cinder Field as a real canonical Active Skill Imprint
## inside the accepted Imprint system ... Implement it at rank 1 with 0 XP and no
## Augments."
##
## So it is a SKILL IMPRINT (`Imprint.Kind.SKILL`), LEARNED into the live
## `ImprintLibrary` by the ordinary `learn()` -- which, since D-380, takes no rank
## and records rank 1 / 0 XP -- and it is NEVER diagnostic-seeded. It sits in a
## `SkillConfiguration` with ZERO modifiers, bound to one of the EIGHT canonical
## bindings, and used through `SkillRuntime.use_binding()`.
##
## ---------------------------------------------------------------------------
## IT IS CANONICAL, AND IT SAYS SO — WITH A WORKING NAME AND PROVISIONAL NUMBERS.
## ---------------------------------------------------------------------------
## Its id carries no `DIAG`, its label says CANONICAL, and the name is canon's
## own WORKING name (SKILLS section 0.13: "Acceptance fixes identities and roster
## roles — not names, numbers, animation or VFX").

const SKILL_CINDER_FIELD := "SKILL_IMPRINT_CINDER_FIELD"
const CFG_CINDER_FIELD := "CFG_CINDER_FIELD"
const DISPLAY_NAME := "Cinder Field"

## THE EXHAUSTIVE SET OF IMPRINTS THIS STAGE ADDS. ONE.
const ALL_IMPRINTS := [SKILL_CINDER_FIELD]
const ALL_CONFIGURATIONS := [CFG_CINDER_FIELD]

const CANONICAL_CITATION := "D-385 roster, D-385 trap delivery, D-402 stage"

## ============================================================================
## THE BINDING: 7 (index 6). MEASURED FIRST, AND THE REASON IS RECORDED.
## ============================================================================
## The owner: "Put Cinder Field on the next appropriate free binding after
## measuring the current loadout."
##
## MEASURED, before anything was bound (and re-measured live by the D-402 suite):
## the accepted D-396 review loadout holds
##   1 Storm Volley · 2 Ward Ballista · 3 Beasts · 4 EMPTY · 5 Tempest ·
##   6 SPLINTER SHOT · 7 EMPTY · 8 EMPTY,
## with Kindred Hounds as its one Persistent, at 32 / 35 Capacity reserving Mana
## and 33 / 35 in LIFE CONVERSION.
##
## THREE bindings are free, and 7 is the appropriate one:
##   * binding 4 is empty BECAUSE D-396 unbound the low-rank Storm twin to buy
##     Capacity headroom. Refilling it would spend exactly the headroom this
##     stage needs, so its emptiness is kept;
##   * binding 7 is the next free binding AFTER Splinter Shot's 6, which keeps
##     the two canonical Huntress Skills contiguous;
##   * `imprint_binding_7` is an ALREADY ACCEPTED input action (key 7), so NO
##     input action is added and the project's 29 stay 29.
const BINDING_INDEX := 6

## Cinder Field is NOT repeatable-when-held: it is a deliberate placement, not a
## fluid baseline, and only Splinter Shot is repeatable (D-392).
static func is_repeatable(_skill_imprint_id: String) -> bool:
	return false

static func is_canonical(imprint_id: String) -> bool:
	return ALL_IMPRINTS.has(imprint_id)

## The Skill Imprint. Canon (D-385): a ground-targeted Fire SPELL delivered as a
## TRAP, tagged `Spell, Trap, Area, Ground, Fire`, castable with any equipment
## that does not prevent casting -- INCLUDING A BOW IN HAND.
##
## It is a SECONDARY Configuration class: not her primary verb (that is Splinter
## Shot) and not Persistent. The class decides only its Capacity cost through the
## accepted pipeline, and that cost is the ACCEPTED secondary base -- nothing
## about Capacity is changed for it.
static func make_cinder_field() -> Imprint:
	var i := Imprint.new(SKILL_CINDER_FIELD, DISPLAY_NAME, Imprint.Kind.SKILL)
	i.canonical = true
	i.canonical_citation = CANONICAL_CITATION
	i.skill_class = Imprint.SkillClass.SECONDARY
	i.provides_tags.assign(CinderConfig.BASE_TAGS)
	i.targeting = "ground-targeted"
	# RANK MOVES MORE THAN RAW DAMAGE: the Mana cost moves too.
	i.rank_moves.assign(["eruption damage", "burning Ground damage", "Mana cost"])
	i.summary = ("THE HUNTRESS'S TRAP (D-385 roster, Trapper pillar): a ground-targeted Fire Spell "
		+ "PLACED as a dormant trap. After a PROVISIONAL arming delay an eligible enemy entering its "
		+ "trigger radius causes ONE eruption — an initial Fire Hit and a lingering, NON-STACKING "
		+ "burning Ground. The eruption is a DELAYED COMPONENT of the original Skill Use, NOT a "
		+ "Triggered Skill. UNMODIFIED in this slice. A CANONICAL Skill with a WORKING name; "
		+ "every number PROVISIONAL. " + CinderConfig.DESIGNATES_NOTHING_NOTE)
	return i

## LEARNS Cinder Field into a library at rank 1 / 0 XP. NEVER SEEDED.
static func learn_into(lib: ImprintLibrary) -> bool:
	return lib.learn(make_cinder_field())

## The ONE Configuration: exactly one Skill Imprint and ZERO modifiers. Every step
## is checked; a refusal is returned, never swallowed.
static func build_configuration(lib: ImprintLibrary) -> Dictionary:
	var c := SkillConfiguration.new(CFG_CINDER_FIELD, lib)
	var r := c.set_skill(SKILL_CINDER_FIELD)
	return {"configuration": c, "ok": bool(r["ok"]), "reason": String(r["reason"])}

# =============================================================================
# THE REVIEW LOADOUT PLAN
# =============================================================================

## ============================================================================
## THE D-402 REVIEW LOADOUT — the accepted D-396 one plus Cinder Field on 7.
## ============================================================================
## The owner: "Do not increase Capacity merely to make the review loadout fit.
## Replace or disable diagnostic content if necessary and disclose exactly what
## changed."
##
## NOTHING had to be replaced or disabled, and the disclosure is that nothing
## did: Cinder Field is a SECONDARY Configuration with ZERO modifiers, so it
## costs the ACCEPTED secondary base of 2, and the D-396 review loadout had 3
## free reserving Mana and 2 free in LIFE CONVERSION. 32 + 2 = 34 / 35 and
## 33 + 2 = 35 / 35. The budget is untouched at 30 + 5 = 35.
##
## Every other position is the accepted D-396 plan, byte for byte: the same five
## diagnostic Configurations, the same empty binding 4, Splinter Shot on 6,
## Kindred Hounds as the one Persistent, and the D-381 reservation cycle still
## pointed at Kindred Hounds.
static func review_loadout_plan() -> Dictionary:
	var base := HoundContent.review_loadout_plan()
	var b: Array = (base["bindings"] as Array).duplicate()
	b[BINDING_INDEX] = CFG_CINDER_FIELD
	return {
		"label": CinderConfig.REVIEW_LOADOUT_LABEL,
		"bindings": b,
		"persistent": (base["persistent"] as Array).duplicate(),
		"cycle": String(base["cycle"]),
	}
