class_name HoundContent
extends RefCounted

## THE KINDRED HOUNDS CONTENT OF THE D-396 STAGE — exactly ONE canonical
## Persistent Skill Imprint, its ONE unmodified Configuration, and the two
## loadout plans the stage can apply.
##
## ============================================================================
## THROUGH THE ACCEPTED ARCHITECTURE. A PERSISTENT SKILL WITH NO ACTIVATION.
## ============================================================================
## The owner: "Kindred Hounds becomes a real canonical Persistent Skill Imprint in
## the accepted loadout architecture. A newly learned copy begins at rank 1 with 0
## XP. It has no combat activation button."
##
## So it is a SKILL IMPRINT of the PERSISTENT class, LEARNED into the live
## `ImprintLibrary` by the ordinary `learn()` -- rank 1 / 0 XP, NEVER seeded --
## and placed in the Persistent Loadout, which consumes no binding. It reserves
## through the accepted pipeline (`SkillConfiguration.resolve()`, stage 7) and the
## accepted `ImprintLoadout.revalidate()`. No binding holds it and no input
## activates it.
##
## Canon (`SKILLS_AND_SKILL_MODIFICATION.md` section 16, D-385): "Tags: Minion,
## Beast, Melee, Hit, Physical; a Persistent Configuration. Weapon: none.
## Activation: none in combat -- configured in the Persistent Loadout, sustained by
## percentage reservation after modifiers." The name is canon's WORKING name.

const SKILL_KINDRED_HOUNDS := "SKILL_IMPRINT_KINDRED_HOUNDS"
const CFG_KINDRED_HOUNDS := "CFG_KINDRED_HOUNDS"
const DISPLAY_NAME := "Kindred Hounds"

## THE EXHAUSTIVE SET OF IMPRINTS THIS STAGE ADDS. ONE.
const ALL_IMPRINTS := [SKILL_KINDRED_HOUNDS]
const ALL_CONFIGURATIONS := [CFG_KINDRED_HOUNDS]

## Canon's own tags, verbatim and in canon's order.
const CANON_TAGS := ["Minion", "Beast", "Melee", "Hit", "Physical"]
const CANONICAL_CITATION := "D-385 roster, D-394 targeting rule, D-396 stage"

static func is_canonical(imprint_id: String) -> bool:
	return ALL_IMPRINTS.has(imprint_id)

## The Skill Imprint.
static func make_kindred_hounds() -> Imprint:
	var i := Imprint.new(SKILL_KINDRED_HOUNDS, DISPLAY_NAME, Imprint.Kind.SKILL)
	i.canonical = true
	i.canonical_citation = CANONICAL_CITATION
	i.skill_class = Imprint.SkillClass.PERSISTENT
	i.provides_tags.assign(CANON_TAGS)
	# Canon names no targeting for a Persistent pack; the accepted aura uses the
	# same archetype. The hounds choose their OWN targets (D-394 ruling 3).
	i.targeting = "self-centered"
	i.reserves = true
	# RANK MOVES MORE THAN RAW DAMAGE: the reservation moves too.
	i.rank_moves.assign(["bite damage", "reservation"])
	i.summary = ("THE HUNTRESS'S PERSISTENT PACK (D-385 roster, Beastmaster pillar): two autonomous "
		+ "hounds that follow her, choose their own targets by the accepted rule (D-394 ruling 3) and "
		+ "bite. Sustained by a PERCENTAGE reservation; NO activation. A CANONICAL Skill with a WORKING "
		+ "name; every number PROVISIONAL.")
	return i

## LEARNS Kindred Hounds into a library at rank 1 / 0 XP. NEVER SEEDED.
static func learn_into(lib: ImprintLibrary) -> bool:
	return lib.learn(make_kindred_hounds())

## The ONE Configuration: exactly one Skill Imprint and ZERO modifiers.
static func build_configuration(lib: ImprintLibrary) -> Dictionary:
	var c := SkillConfiguration.new(CFG_KINDRED_HOUNDS, lib)
	var r := c.set_skill(SKILL_KINDRED_HOUNDS)
	return {"configuration": c, "ok": bool(r["ok"]), "reason": String(r["reason"])}

# =============================================================================
# THE TWO LOADOUT PLANS
# =============================================================================

## ============================================================================
## THE D-396 REVIEW LOADOUT — measured first, Capacity NOT increased.
## ============================================================================
## MEASURED before any change: the accepted loadout uses 35 of 35 Capacity, and
## in LIFE CONVERSION it demands 36 and the accepted revalidation deactivates
## Splinter Shot (a pre-existing finding, disclosed). The owner: "Equip it ...
## without increasing Capacity merely to make it fit. Measure the existing loadout
## first; replace or deactivate diagnostic content if necessary." So:
##   * Kindred Hounds REPLACE the diagnostic Pack Ward aura in the Persistent
##     Loadout (1 for 1);
##   * the low-rank Storm twin is UNBOUND from binding 4 (the cheapest binding,
##     3, and the comparison aid with least bearing on hounds);
##   * 32 of 35 reserving Mana, 33 of 35 in LIFE CONVERSION. Nothing is deleted.
## The D-381 reservation cycle drives the Persistent under review.
static func review_loadout_plan() -> Dictionary:
	var D := DiagImprintContent
	return {
		"label": HoundConfig.REVIEW_LOADOUT_LABEL,
		"bindings": [D.CFG_VOLLEY, D.CFG_BALLISTA, D.CFG_BEASTS, "", D.CFG_TEMPEST,
			HuntressContent.CFG_SPLINTER_SHOT, "", ""],
		"persistent": [CFG_KINDRED_HOUNDS],
		"cycle": CFG_KINDRED_HOUNDS,
	}

## ============================================================================
## THE ACCEPTED D-392 LOADOUT — the loadout the four accepted suites measure.
## ============================================================================
## Exactly what D-392 composed and D-394 accepted: the five diagnostic
## Configurations on bindings 1-5, Splinter Shot on 6, bindings 7-8 empty, the
## diagnostic aura as the one Persistent, the cycle on the aura.
static func accepted_d392_loadout_plan() -> Dictionary:
	var b: Array = DiagImprintContent.default_binding_plan().duplicate()
	b[HuntressContent.BINDING_INDEX] = HuntressContent.CFG_SPLINTER_SHOT
	return {
		"label": "the ACCEPTED D-392 loadout (D-394), restored for the accepted suites",
		"bindings": b,
		"persistent": DiagImprintContent.default_persistent_plan().duplicate(),
		"cycle": DiagImprintContent.CFG_AURA,
	}
