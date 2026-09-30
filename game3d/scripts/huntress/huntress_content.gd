class_name HuntressContent
extends RefCounted

## THE HUNTRESS CONTENT OF THE D-392 STAGE — exactly ONE canonical Skill Imprint,
## Splinter Shot, and its ONE unmodified Configuration.
##
## ============================================================================
## THROUGH THE ACCEPTED ARCHITECTURE, NOT BESIDE IT, AND NOT THE BOLT RENAMED.
## ============================================================================
## The owner: "Splinter Shot becomes the canonical ordinary attack in normal play.
## Integrate it through the accepted Skill/Imprint architecture rather than
## disguising or renaming the diagnostic bolt. A newly learned Splinter Shot
## begins at rank 1 with 0 XP."
##
## So it is a SKILL IMPRINT (`Imprint.Kind.SKILL`), LEARNED into the live
## `ImprintLibrary` by the ordinary `learn()` -- which, since D-380, takes no
## rank and records rank 1 / 0 XP -- and it is NEVER diagnostic-seeded. It sits
## in a `SkillConfiguration` with ZERO modifiers (the ruling: "Keep Splinter Shot
## unmodified in this slice"), bound to one of the EIGHT canonical bindings, and
## used through `SkillRuntime.use_binding()`. The accepted `DiagnosticBolt` is
## untouched and shares no code path with it.
##
## ---------------------------------------------------------------------------
## IT IS CANONICAL, AND IT SAYS SO — WITH A WORKING NAME AND PROVISIONAL NUMBERS.
## ---------------------------------------------------------------------------
## Its id carries no `DIAG`, its label says CANONICAL, and the name is canon's
## own WORKING name (SKILLS section 0.13: "Acceptance fixes identities and roster
## roles — not names, numbers, animation or VFX").

const SKILL_SPLINTER_SHOT := "SKILL_IMPRINT_SPLINTER_SHOT"
const CFG_SPLINTER_SHOT := "CFG_SPLINTER_SHOT"
const DISPLAY_NAME := "Splinter Shot"

## THE EXHAUSTIVE SET OF IMPRINTS THIS STAGE ADDS. ONE.
const ALL_IMPRINTS := [SKILL_SPLINTER_SHOT]
const ALL_CONFIGURATIONS := [CFG_SPLINTER_SHOT]

## The binding it takes: binding 6 (index 5) -- the first EMPTY binding. Bindings
## 1-5 keep their accepted diagnostic Configurations. Right mouse and pad button 7
## (the ordinary attack's accepted events) activate this binding position beside
## key 6: "Input profiles decide which physical controls activate binding
## positions rather than replacing the Skills inside them" (UI section 152).
const BINDING_INDEX := 5

## Repeatable when held (combat sections 2 and 12; Skills section 15). Only
## Splinter Shot is: the diagnostic Configurations keep their accepted
## press-only behaviour.
static func is_repeatable(skill_imprint_id: String) -> bool:
	return skill_imprint_id == SKILL_SPLINTER_SHOT

static func is_canonical(imprint_id: String) -> bool:
	return ALL_IMPRINTS.has(imprint_id)

## The Skill Imprint. Canon: "a bow-fired Physical projectile with
## straightforward baseline behavior" -- in the first MVP "Splinter Shot requires
## a bow" (D-385) -- so: Attack, Projectile, Hit, Physical; directional; PRIMARY.
static func make_splinter_shot() -> Imprint:
	var i := Imprint.new(SKILL_SPLINTER_SHOT, DISPLAY_NAME, Imprint.Kind.SKILL)
	i.canonical = true
	i.skill_class = Imprint.SkillClass.PRIMARY
	i.provides_tags.assign(["Attack", "Projectile", "Hit", "Physical"])
	i.targeting = "directional"
	# RANK MOVES MORE THAN RAW DAMAGE: its Mana cost moves too.
	i.rank_moves.assign(["damage", "Mana cost"])
	i.summary = ("THE HUNTRESS'S ORDINARY SHOT (D-391 ruling 1) — her starting Skill and fluid bow "
		+ "baseline. ONE arrow, the first eligible target, then stop (D-390 ruling 4): UNMODIFIED in "
		+ "this slice. A CANONICAL Skill with a WORKING name; every number PROVISIONAL.")
	return i

## LEARNS Splinter Shot into a library at rank 1 / 0 XP. NEVER SEEDED.
static func learn_into(lib: ImprintLibrary) -> bool:
	return lib.learn(make_splinter_shot())

## The ONE Configuration: exactly one Skill Imprint and ZERO modifiers. Every step
## is checked; a refusal is returned, never swallowed.
static func build_configuration(lib: ImprintLibrary) -> Dictionary:
	var c := SkillConfiguration.new(CFG_SPLINTER_SHOT, lib)
	var r := c.set_skill(SKILL_SPLINTER_SHOT)
	return {"configuration": c, "ok": bool(r["ok"]), "reason": String(r["reason"])}
