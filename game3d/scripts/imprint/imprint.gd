class_name Imprint
extends RefCounted

## ONE IMPRINT — the acquisition/progression object of the D-375 stage.
##
## ============================================================================
## THE THREE TYPES ARE THE OWNER'S AUTHORIZED TERMINOLOGY, AND THERE ARE THREE.
## ============================================================================
##   SKILL IMPRINT     — the permanently learned mechanical foundation.
##   AUGMENT IMPRINT   — a learned reusable modifier.
##   TRANSFORM IMPRINT — a modifier that fundamentally changes delivery, rhythm
##                       or purpose. It occupies ONE of the four modifier slots
##                       and is NEVER a fifth position.
##
## ---------------------------------------------------------------------------
## EVERY IMPRINT IN THIS PROJECT IS DIAGNOSTIC.
## ---------------------------------------------------------------------------
## None is a canonical Huntress Skill. None is one of canon's eight first-MVP
## roster Skills or sixteen named Augments. None is final art, final naming,
## final VFX or final balance. `label()` says so, and the suite asserts it.
##
## ---------------------------------------------------------------------------
## AN IMPRINT'S BEHAVIOURAL IDENTITY IS COMPLETE AT EFFECTIVE RANK 1.
## ---------------------------------------------------------------------------
## `design/SKILLS_AND_SKILL_MODIFICATION.md` section 17: "Behavioral identity is
## never delivered fractionally. Additional Projectile, for example, provides its
## defining projectile behavior when equipped rather than requiring several
## partial upgrades before functioning."
##
## THAT RULE IS OBEYED EXACTLY. Rank scales NUMBERS; it never gates behaviour,
## and `identity_complete_at_rank_1` records the claim so a check can test it.

enum Kind { SKILL, AUGMENT, TRANSFORM }

## The Skill classes this stage uses for Capacity and for reservation
## compatibility. `NONE` is for modifiers, which have no class of their own.
##
## THIS IS NOT A TAG, AND IT IS DELIBERATELY NOT PRETENDING TO BE ONE.
## MEASURED: `design/ATTRIBUTES_AND_DAMAGE_MODEL.md` section 11's tag vocabulary
## contains NO Persistent and NO Reservation tag, so expressing "this modifier
## only fits a Persistent Configuration" as a tag would mean inventing one.
## Declared as a class instead, and recorded as conflict X-15.
enum SkillClass { NONE, PRIMARY, SECONDARY, UTILITY, PERSISTENT }

const KIND_NAMES := ["SKILL IMPRINT", "AUGMENT IMPRINT", "TRANSFORM IMPRINT"]
const CLASS_NAMES := ["none", "primary", "secondary", "utility", "persistent"]

var id: String = ""
var display_name: String = ""
var kind: int = Kind.SKILL

# --- Skill Imprints only -----------------------------------------------------
var skill_class: int = SkillClass.NONE
var provides_tags: Array[String] = []
var targeting: String = ""
var reserves: bool = false

# --- Modifier Imprints only --------------------------------------------------
## ALL of these tags must be present on the Configuration's RESOLVED tags.
var requires_tags: Array[String] = []
## The Configuration's Skill class must be one of these, when non-empty.
var requires_classes: Array[int] = []
## Tag changes, stated explicitly -- canon: "Any Augment that adds, removes, or
## transforms tags states the change explicitly."
var adds_tags: Array[String] = []
var removes_tags: Array[String] = []
## A Transform may change the canonical targeting archetype. When it does, it
## says which archetype it changes it TO.
var sets_targeting: String = ""

## ============================================================================
## WHAT THIS MODIFIER ACTUALLY CHANGES. "No Augment silently does nothing."
## ============================================================================
## Canon, section 10: "A compatible Augment explains which components it
## modifies" and "No Augment silently does nothing." A modifier with an empty
## `affects` list is a defect, and the suite asserts every installed modifier
## reports at least one entry.
var affects: Array[String] = []

## The cost or condition this modifier imposes, IF IT IMPOSES ONE.
##
## From D-375 until D-380 this comment read "A modifier with no stated tradeoff is
## a defect here", and `validate()` refused one as "FREE POWER" -- true when
## written, reading canon section 9's "Augments are not free power" literally.
## D-378 OD-12 clarified it: "Purely beneficial Augments are allowed ... the
## modifier slot and global Capacity are already opportunity costs." An EMPTY
## tradeoff is therefore LEGAL. What stays a defect is an empty `affects` list.
var tradeoff: String = ""

## ============================================================================
## THE NON-DAMAGE PROPERTY RANK MOVES, NAMED PER IMPRINT.
## ============================================================================
## The ruling: "Rank must affect more than raw damage where appropriate: cost,
## reservation, duration, cooldown, thresholds or another relevant property."
## The name is here so a check can require it AND measure it, rather than
## trusting a comment.
var rank_moves: Array[String] = []

## The claim that behaviour is whole at rank 1. Recorded so it is testable.
var identity_complete_at_rank_1: bool = true

## ============================================================================
## CANONICAL — ADDED UNDER D-392. FALSE FOR EVERY DIAGNOSTIC IMPRINT.
## ============================================================================
## From D-375 until D-392 every Imprint in this project was DIAGNOSTIC, and the
## paragraph above says so -- true when written. D-392 authorizes ONE canonical
## Skill Imprint, Splinter Shot (`HuntressContent`). It is flagged here, and its
## label says CANONICAL instead of DIAGNOSTIC, so no reader can mistake either
## kind for the other. Every diagnostic Imprint keeps this false.
var canonical: bool = false

## ============================================================================
## THE CANON A CANONICAL IMPRINT'S LABEL CITES — ADDED UNDER D-396.
## ============================================================================
## From D-392 until D-396 `label()` cited "D-385 roster, D-391 ordinary shot" for
## every canonical Imprint -- true when written, because Splinter Shot was the
## only one. D-396 adds Kindred Hounds, which is NOT an ordinary shot, so each
## canonical Imprint may name its own citation. EMPTY keeps the D-392 wording
## exactly, so Splinter Shot's label is byte-for-byte what it was.
var canonical_citation: String = ""

var summary: String = ""

func _init(p_id: String, p_name: String, p_kind: int) -> void:
	id = p_id
	display_name = p_name
	kind = p_kind

func kind_name() -> String:
	return KIND_NAMES[kind] if kind >= 0 and kind < KIND_NAMES.size() else "UNKNOWN"

func class_name_text() -> String:
	return CLASS_NAMES[skill_class] if skill_class >= 0 and skill_class < CLASS_NAMES.size() else "none"

func is_modifier() -> bool:
	return kind == Kind.AUGMENT or kind == Kind.TRANSFORM

func is_transform() -> bool:
	return kind == Kind.TRANSFORM

## Every Imprint's runtime label. A DIAGNOSTIC Imprint's label ALWAYS contains the
## word DIAGNOSTIC, and the suite asserts that for every one of them. (Until D-392
## this said "IT ALWAYS CONTAINS THE WORD DIAGNOSTIC" of every Imprint -- true when
## written.) The ONE canonical Imprint says CANONICAL, names itself a WORKING
## name, and denies that any of its numbers is final.
func label() -> String:
	if canonical:
		var cites := canonical_citation if canonical_citation != "" else "D-385 roster, D-391 ordinary shot"
		return "CANONICAL — %s '%s' (a WORKING name; %s) — every number PROVISIONAL" \
			% [kind_name(), display_name, cites]
	return "DIAGNOSTIC — %s, non-canonical, not a Huntress Skill" % kind_name()
