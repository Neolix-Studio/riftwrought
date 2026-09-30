class_name CinderConfig
extends RefCounted

## RIFTWROUGHT — THE CINDER FIELD STAGE: its own registry (D-402).
##
## ============================================================================
## ONE BOUNDED CINDER FIELD STAGE. IT IS NOT P2, NOT SINEW BALLISTA, NOT ANOTHER
## HUNTRESS SKILL, NOT HUNTRESS'S MARK, NOT RIFT SHARDS, NOT AUGMENTS, NOT
## PRODUCTION VFX, NOT A TUNING LOCK AND NOT A BROADER TRAP FRAMEWORK.
## ============================================================================
## The owner's ruling, verbatim: "This prompt authorizes only the Cinder Field
## stage described below. It does not authorize Sinew Ballista, another Huntress
## Skill, Huntress's Mark, Rift Shards, Augments, production VFX work, tuning
## locks or a broader trap framework."
##
## It implements ONE canonical ACTIVE Skill -- Cinder Field (D-385 roster,
## `SKILLS_AND_SKILL_MODIFICATION.md` section 16 and its Cinder Field section as
## amended by D-385) -- through the ACCEPTED Imprint architecture: learned at
## rank 1 / 0 XP, one unmodified Configuration, bound to one of the EIGHT
## canonical bindings, used through `SkillRuntime.use_binding()`, committed on the
## ACCEPTED STOP policy.
##
## ---------------------------------------------------------------------------
## THIS IS A SEVENTH REGISTRY, NOT A REPLACEMENT.
## ---------------------------------------------------------------------------
## `ProdConfig` (D-373), `ImprintConfig` (D-376 / D-383), `HuntressConfig`
## (D-394), `HoundConfig` (D-397), `CohortConfig` (D-399) and `LocomotionConfig`
## (D-401) are UNCHANGED in every numeric value. The D-402 suite asserts that
## directly, by digest.
##
## EVERY VALUE BELOW IS A PROVISIONAL REVIEW CANDIDATE. NONE IS A LOCK.

const DECISION := "D-402"
const DATE := "2026-09-20"
const STAGE := "CINDER FIELD STAGE"

# =============================================================================
# THE CANONICAL COMPONENT TAGS — DATA, NOT A COMMENT.
# =============================================================================
## `SKILLS_AND_SKILL_MODIFICATION.md`, Cinder Field, as amended by D-385:
## "Tags: `Spell, Trap, Area, Ground, Fire` -- eruption `Spell, Trap, Area, Hit,
## Fire`; burning Ground `Spell, Ground, Damage over Time, Fire, Duration`."
## They are VERBATIM and in canon's order, so a check reads canon rather than a
## paraphrase of it. `Trap` is the D-385 Mechanical Form tag
## (`ATTRIBUTES_AND_DAMAGE_MODEL.md` section 11).
const BASE_TAGS := ["Spell", "Trap", "Area", "Ground", "Fire"]
const ERUPTION_TAGS := ["Spell", "Trap", "Area", "Hit", "Fire"]
const GROUND_TAGS := ["Spell", "Ground", "Damage over Time", "Fire", "Duration"]

# =============================================================================
# THE REVIEW CANDIDATES. Every one PROVISIONAL; not one is a lock.
# =============================================================================

## ARMING. Canon declares an arming delay and leaves its value open. Long enough
## that the owner can SEE the dormant-to-armed transition at gameplay pace and
## that a trap dropped under a charging enemy does not fire instantly; short
## enough that laying one ahead of a pull still works.
const ARMING_DELAY_S := 0.60

## THE TRIGGER RADIUS -- how near an eligible enemy must come to spring it -- and
## the ERUPTION RADIUS, which is larger, so a trap sprung at its edge still
## catches what followed the triggerer in. The BURNING GROUND covers the same
## area as the eruption: one place, one footprint.
const TRIGGER_RADIUS_M := 1.60
const ERUPTION_RADIUS_M := 2.60
const GROUND_RADIUS_M := 2.60

## DURATION AND INSTANCES -- canon's four declarations for a Duration/Ground
## effect. A dormant trap waits this long; the burning Ground lasts this long
## after an eruption; at most this many DORMANT instances exist at once.
const DORMANT_DURATION_S := 12.0
const GROUND_DURATION_S := 4.00
const INSTANCES_MAX := 3
## The shared cadence on which burning Ground damage is applied. One cadence for
## every field is what makes "one contribution per enemy" arithmetic rather than
## a hope: see `CinderRuntime._step_grounds()`.
const GROUND_TICK_S := 0.50

## PLACEMENT. A ground-targeted Skill clamps its destination to its range, and
## refuses a point that is not on walkable ground by more than this tolerance.
## The tolerance is the accepted arrival tolerance's size, chosen so a point a
## hand's breadth off the mesh still places and a point inside a wall does not.
const PLACE_RANGE_M := 9.0
const PLACE_TOLERANCE_M := 0.35

## DAMAGE. The eruption is one Fire Hit; the Ground is Fire damage over time.
## Quoted beside Splinter Shot's ~25 per shot so the owner can judge the SHAPE of
## a trap-primary build, never as balance.
const ERUPTION_DAMAGE_AT_RANK_1 := 46.0
const ERUPTION_DAMAGE_PER_RANK := 3.0
const GROUND_DPS_AT_RANK_1 := 16.0
const GROUND_DPS_PER_RANK := 1.0

## COST AND COOLDOWN. Rank moves the Mana cost as well as the damage, which is
## the accepted architecture's "rank must affect more than raw damage" rule.
const MANA_AT_RANK_1 := 24.0
const MANA_PER_RANK := 0.6
const COOLDOWN_S := 1.60

## ACTION TIMING. The placement leaves the hand at RELEASE_S; the rest is
## recovery, which a movement command may cancel. The ACTION and the RELEASE
## MARKER are DERIVED from these two, never typed twice.
const RELEASE_S := 0.30
const RECOVERY_S := 0.22

## PRESENTATION TIMING. How long the sprung (closed) trap body lingers before it
## is freed, and how long the eruption flash expands for.
const SPRUNG_LINGER_S := 0.45
const ERUPTION_FLASH_S := 0.35

## The placeholder trap's footprint, used to scale the mesh from its OWN AABB.
const TRAP_FOOTPRINT_M := 0.95

## DECAL HEIGHTS. Ground decals sit above the floor's VISUAL surface, never above
## y = 0 -- the accepted D-373 lesson (`ProdConfig.FLOOR_VISUAL_TOP_Y` is 0.033,
## and the accepted telegraph decals sit at 0.065 / 0.075). These sit above all
## of them so a burning field reads over a telegraph rather than inside it.
const GROUND_DECAL_Y := 0.085
const GROUND_RIM_Y := 0.095
const TRIGGER_RING_Y := 0.105
const ERUPTION_RING_Y := 0.115

## PRESENTATION COLOURS — PROVISIONAL, and NEVER the only cue. Each state is
## also distinguished by SHAPE: a filling ring while arming, a complete ring and
## a standing pin when armed, closed jaws and an expanding ring when sprung, and
## a ticked rim that empties as the burning Ground runs out. Canon
## (`CHARACTER_CLASS_PHILOSOPHY.md` section 0.5.5): readable without colour
## alone. They are `Color` values, so they are not numeric constants and the
## registry does not carry them.
const COL_DORMANT := Color(0.42, 0.40, 0.38)
const COL_ARMED := Color(1.00, 0.55, 0.18)
const COL_ERUPTION := Color(1.00, 0.80, 0.38)
const COL_GROUND := Color(0.95, 0.40, 0.13)

# =============================================================================
# STRUCTURAL — not tuning. Excepted from the registry BY NAME in the D-402 suite.
# =============================================================================

## The two damage-ledger sources, beside the accepted "player_direct",
## "ballista", "beast", "kindred_hound" and the D-398 stress source. TWO, because
## the ruling requires the Hit and the Ground damage to stay SEPARATELY
## MEASURABLE.
const LEDGER_SOURCE_HIT := "cinder_field_hit"
const LEDGER_SOURCE_GROUND := "cinder_field_ground"

## The action label the accepted commitment carries, so a reader of the overlay
## sees a CANONICAL Skill with PROVISIONAL timing rather than a bare name.
const ACTION_LABEL := "CINDER FIELD (CANONICAL SKILL — PROVISIONAL TIMING)"

const HUD_TITLE := "CINDER FIELD REVIEW HUD · review tooling, NOT a UI foundation"
const REVIEW_LOADOUT_LABEL := "D-402 CINDER FIELD REVIEW LOADOUT — a DIAGNOSTIC review loadout, not a production loadout"
## The trap's canonical non-designation, as its own constant so the sentence sits
## on a line that BEGINS with a string literal and cites D-393 -- which is the
## narrow, already-established form the accepted D-392 suite exempts for a denial
## that must be able to name what it denies. The identifier deliberately does NOT
## contain the word, so an identifier scan still means something.
const DESIGNATES_NOTHING_NOTE := \
	"It designates nothing — Prey was REMOVED under D-393."

const TRAP_PLACEHOLDER_LABEL := "PLACEHOLDER TRAP BODY — Quaternius `BearTrap_Open` / `BearTrap_Closed` (CC0), NOT final Huntress art"
const VFX_PLACEHOLDER_LABEL := "PROCEDURAL DIAGNOSTIC VFX — restrained primitives, NOT production VFX; no VFX archive is read or used"

## The three states a trap can be in, named so a check and the HUD read the same
## words. A sprung trap is not a fourth kind of object; it is this state.
const PHASE_ARMING := "DORMANT (arming)"
const PHASE_ARMED := "ARMED"
const PHASE_SPRUNG := "SPRUNG"
const PHASE_EXPIRED := "EXPIRED (harmless)"

# =============================================================================
# CANON'S FOUR DECLARATIONS FOR A DURATION / GROUND EFFECT — as DATA.
# =============================================================================
## `SKILLS_AND_SKILL_MODIFICATION.md`, Duration and Ground Skills: every such
## effect declares its duration, its maximum active instances, whether re-use
## refreshes / replaces / adds, whether overlapping effects stack, and what
## happens when the instance limit is exceeded. All five are stated here so a
## check can READ them rather than trust a comment.
static func duration_contract() -> Dictionary:
	return {
		"declares_duration": "the DORMANT trap waits %.2f s; the burning Ground lasts %.2f s after an eruption" \
			% [DORMANT_DURATION_S, GROUND_DURATION_S],
		"maximum_active_instances": "%d DORMANT traps (CinderConfig.INSTANCES_MAX). A SPRUNG trap no longer occupies an instance slot; its burning Ground runs its own Duration." % INSTANCES_MAX,
		"reuse_behaviour": "ADDS an instance until the limit, then REPLACES THE OLDEST — canon's own rule",
		"overlapping_effects_stack": "NO. Identical overlapping Damage over Time Ground effects do not stack: the STRONGEST applicable instance deals the damage, and an enemy receives EXACTLY ONE Cinder Field ground-damage contribution per tick",
		"on_limit_exceeded": "the oldest DORMANT instance is removed HARMLESSLY — no eruption, no Ground — and the event is counted",
		"unsprung_at_expiry": "it ends HARMLESSLY: no Hit, no burning Ground, and nothing enters the damage ledger",
	}

# =============================================================================
# DERIVED — each from a registered value, never a new number.
# =============================================================================

static func action_s() -> float:
	return RELEASE_S + RECOVERY_S

static func release_marker() -> float:
	return RELEASE_S / action_s()

static func eruption_damage_at(rank: int) -> float:
	return ERUPTION_DAMAGE_AT_RANK_1 + ERUPTION_DAMAGE_PER_RANK * float(rank - 1)

static func ground_dps_at(rank: int) -> float:
	return GROUND_DPS_AT_RANK_1 + GROUND_DPS_PER_RANK * float(rank - 1)

static func mana_at(rank: int) -> float:
	return MANA_AT_RANK_1 + MANA_PER_RANK * float(rank - 1)

## What ONE tick of burning Ground deals at a given damage-per-second.
static func ground_tick_damage(dps: float) -> float:
	return dps * GROUND_TICK_S

# =============================================================================
# THE REGISTRY — printed at runtime, asserted by the D-402 suite.
# =============================================================================
static func registry() -> Array:
	return [
		["arming delay (s)", ARMING_DELAY_S, "PROVISIONAL REVIEW CANDIDATE (D-402) — canon declares an arming delay and leaves its value open; NOT a lock"],
		["trigger radius (m)", TRIGGER_RADIUS_M, "PROVISIONAL REVIEW CANDIDATE — NOT a lock"],
		["eruption radius (m)", ERUPTION_RADIUS_M, "PROVISIONAL REVIEW CANDIDATE — NOT a lock"],
		["burning Ground radius (m)", GROUND_RADIUS_M, "PROVISIONAL — the same footprint as the eruption"],
		["dormant Duration (s)", DORMANT_DURATION_S, "PROVISIONAL REVIEW CANDIDATE — canon's declared dormant Duration; NOT a lock"],
		["burning Ground Duration (s)", GROUND_DURATION_S, "PROVISIONAL REVIEW CANDIDATE — NOT a lock"],
		["burning Ground tick (s)", GROUND_TICK_S, "PROVISIONAL — ONE shared cadence, which is what makes non-stacking arithmetic"],
		["maximum DORMANT instances", INSTANCES_MAX, "PROVISIONAL REVIEW CANDIDATE — canon's declared instance cap; NOT a lock"],
		["placement range (m)", PLACE_RANGE_M, "PROVISIONAL — NOT a lock"],
		["placement navigability tolerance (m)", PLACE_TOLERANCE_M, "PROVISIONAL — how far off walkable ground a requested point may be before the use is REFUSED"],
		["eruption damage at rank 1", ERUPTION_DAMAGE_AT_RANK_1, "PROVISIONAL REVIEW CANDIDATE — NOT balance"],
		["eruption damage per rank", ERUPTION_DAMAGE_PER_RANK, "PROVISIONAL — NOT balance"],
		["burning Ground damage per second at rank 1", GROUND_DPS_AT_RANK_1, "PROVISIONAL REVIEW CANDIDATE — NOT balance"],
		["burning Ground damage per second per rank", GROUND_DPS_PER_RANK, "PROVISIONAL — NOT balance"],
		["Mana cost at rank 1", MANA_AT_RANK_1, "PROVISIONAL — NOT balance"],
		["Mana cost per rank", MANA_PER_RANK, "PROVISIONAL — rank moves a NON-damage property too"],
		["cooldown (s)", COOLDOWN_S, "PROVISIONAL REVIEW CANDIDATE — NOT an attack-rate lock"],
		["release from use start (s)", RELEASE_S, "PROVISIONAL REVIEW CANDIDATE — NOT a lock, NOT cast speed"],
		["recovery after release (s)", RECOVERY_S, "PROVISIONAL — movement-cancellable through the ACCEPTED commitment"],
		["sprung body linger (s)", SPRUNG_LINGER_S, "PROVISIONAL PRESENTATION VALUE"],
		["eruption flash (s)", ERUPTION_FLASH_S, "PROVISIONAL PRESENTATION VALUE"],
		["placeholder trap footprint (m)", TRAP_FOOTPRINT_M, "PROVISIONAL PRESENTATION VALUE — the mesh is scaled from its OWN AABB to this"],
		["burning Ground decal height (m)", GROUND_DECAL_Y, "PROVISIONAL PRESENTATION VALUE — above the floor's VISUAL surface, never above y = 0"],
		["burning Ground rim height (m)", GROUND_RIM_Y, "PROVISIONAL PRESENTATION VALUE"],
		["trigger ring height (m)", TRIGGER_RING_Y, "PROVISIONAL PRESENTATION VALUE"],
		["eruption ring height (m)", ERUPTION_RING_Y, "PROVISIONAL PRESENTATION VALUE"],
	]

## The canonical rules this stage implements, each cited. Printed at runtime and
## proved identical to the D-402 inventory row for row.
static func canonical_rulings() -> Array:
	return [
		["SKILLS §Cinder Field (D-385)", "a ground-targeted Fire Spell delivered as a TRAP: placed at a ground point, dormant until an enemy enters its trigger radius, then ONE eruption", "IMPLEMENTED — every number PROVISIONAL"],
		["SKILLS §Cinder Field (D-385)", "the eruption produces an initial Fire HIT and a non-stacking burning GROUND effect", "IMPLEMENTED"],
		["SKILLS §Cinder Field (D-385)", "the eruption is a DELAYED COMPONENT of the original Skill Use, not a Triggered Skill", "IMPLEMENTED — it carries the Skill Use id and begins no new use and no new cooldown"],
		["SKILLS §Cinder Field (D-385)", "base tags Spell, Trap, Area, Ground, Fire; eruption Spell, Trap, Area, Hit, Fire; burning Ground Spell, Ground, Damage over Time, Fire, Duration", "IMPLEMENTED — verbatim, in canon's order, as DATA"],
		["ITEMS §9 / SKILLS §Cinder Field (D-385)", "any equipment that does not prevent casting, INCLUDING A BOW IN HAND", "IMPLEMENTED — nothing in the use path reads a weapon"],
		["SKILLS §Cinder Field (D-385)", "arming delay · trigger by an ENEMY, never an ally · ONE eruption per trap · dormant Duration · maximum instances · re-use adds an instance, oldest replaced · unsprung at expiry it ends HARMLESSLY", "IMPLEMENTED — every value PROVISIONAL"],
		["SKILLS §Duration and Ground Skills", "identical overlapping Damage over Time Ground effects do not stack by default; the STRONGEST applicable instance deals damage", "IMPLEMENTED — ONE arbiter, ONE contribution per enemy per tick"],
		["SKILLS §Duration and Ground Skills", "when an instance limit is exceeded, the OLDEST instance is normally replaced", "IMPLEMENTED — and the replacement is HARMLESS and counted"],
		["CLASS §0.5.5 (D-385)", "not attackable by ordinary enemies in the first MVP; blocks no movement; modifies no navigation; readable without colour alone", "IMPLEMENTED — no collision body, no registry entry, no navigation change"],
		["CLASS §0.5.16 (D-393)", "PREY IS REMOVED: a Cinder Field eruption designates nothing", "OBEYED — no Prey state exists anywhere in game3d/"],
		["D-391 r4 (general since D-393)", "an eligible enemy is alive, hostile, targetable and able to legally receive the Hit", "USED UNCHANGED — the general HitEligibility"],
		["D-392 CL-3", "the stable combat-entity ID of the active area, never engine iteration order, object name or memory identity", "USED — for the exact simultaneous-entry tie-break"],
		["SKILLS §15", "cost checked and paid when the use begins; the cooldown begins on SUCCESSFUL RELEASE; one input activation is one Skill Use", "USED UNCHANGED — the ACCEPTED SkillRuntime path"],
		["D-373 (accepted)", "the STOP action-movement commitment, buffered pre-release movement and post-release recovery cancellation", "USED UNCHANGED — no third policy, no new cancel window, no new tunable"],
	]

## What this stage denies, individually. Printed every run.
static func denials() -> Array:
	return [
		"The D-402 stage IS NOT P2 and AUTHORIZES NO P2.",
		"The D-402 stage implements NO Sinew Ballista and NO other Huntress Skill: no Void Lance, Coursing Hounds, Rift Step or Void Attunement.",
		"The D-402 stage implements NO Huntress's Mark: no Mark state, no marking and no damage bonus exists, and it remains a FUTURE concept.",
		"The D-402 stage introduces NO PREY in any form: no designation, no preference, no marker. Prey was REMOVED under D-393 and stays removed.",
		"The D-402 stage IMPLEMENTS NO RIFT SHARDS: no Generate, Hold, Shape or Rift Echo, and placement generates nothing.",
		"The D-402 stage implements NO AUGMENT and NO TRANSFORM: Cinder Field is UNMODIFIED, and Expanded Area, Increased Duration and Ignite Emphasis are OUT OF SCOPE.",
		"The D-402 stage implements NO IGNITE and NO ailment: no accepted generic system requires one here.",
		"The D-402 stage IS NOT a broader trap or deployable framework: ONE Skill, and no generic system is generalised out of it.",
		"The D-402 stage is NOT production VFX work: the eruption and the burning ground are RESTRAINED PROCEDURAL DIAGNOSTIC visuals, and NO VFX archive is inspected, extracted or imported.",
		"The D-402 trap bodies are PLACEHOLDERS — two CC0 Quaternius ruins models from an ALREADY-DECLARED pack — and NEITHER is final Huntress art.",
		"The D-402 stage LOCKS NO NUMBER: every timing, damage, radius, duration, cost and instance count is a PROVISIONAL review candidate.",
		"The D-402 stage adds NO input action: the project's 29 accepted actions stay 29, and Cinder Field uses the ALREADY ACCEPTED binding-7 action.",
		"The D-402 stage adds NO third action-movement policy and changes NO accepted movement, facing or cancellation architecture.",
		"The D-402 stage increases NO Capacity: the budget stays 30 + 5 = 35, and the review loadout was measured before it was changed.",
		"The D-402 Cinder Field review HUD is review tooling and IS NOT a UI foundation.",
		"The D-402 stage modifies NO accepted spike and has NO runtime dependency outside game3d/.",
		# D-404 (first act): this read "The D-402 stage delivers OPEN pending owner
		# live review; it does NOT accept itself." -- TRUE WHEN WRITTEN, and the
		# state the stage was ACCEPTED IN. D-403 accepted and closed it; the same
		# ruling directs this reconciliation as the D-404 stage's first act. The
		# history is preserved, not deleted.
		"The D-402 stage was delivered OPEN and never accepted itself: the owner ACCEPTED and CLOSED it under D-403 (its runtime said it delivers OPEN pending owner live review until D-404 reconciled the line — true when written).",
	]

## Printed every run by the D-402 suite. NONE IS A PASS.
static func deferred_rows() -> Array:
	return [
		["FD-01 numerical tuning of every Cinder Field value", "DEFERRED",
		 "Nothing is locked: all 26 registry values are PROVISIONAL review candidates. RETURNS TO: a tuning pass."],
		["FD-02 final trap art, animation and VFX", "DEFERRED",
		 "The bodies are PLACEHOLDER ruins models and the eruption and ground are restrained procedural diagnostics. RETURNS TO: an asset, animation and VFX pass, with licence review before any intake."],
		["FD-03 the downloaded VFX archives in the repository's asset directory", "OUT OF SCOPE",
		 "The ruling forbids inspecting or importing them in this stage, and not one is opened, extracted or read. The D-402 inventory section 5 names the directory; this row deliberately does not, because the accepted D-392 scan treats that literal path as a reference. RETURNS TO: a separately authorized VFX intake."],
		["FD-04 Ignite, Ignite Emphasis and the ailment system", "OUT OF SCOPE",
		 "No already-accepted generic system requires Ignite here, so none is implemented. RETURNS TO: a future Augment stage."],
		["FD-05 Expanded Area, Increased Duration and every other Augment", "OUT OF SCOPE",
		 "Cinder Field is UNMODIFIED in this slice. RETURNS TO: an Augment stage."],
		["FD-06 Sinew Ballista, Void Lance, Coursing Hounds, Rift Step, Void Attunement", "OUT OF SCOPE",
		 "Excluded by the ruling. RETURNS TO: their own stages."],
		["FD-07 Huntress's Mark and any signature mechanic", "OUT OF SCOPE",
		 "A FUTURE concept, not implemented, and D-394 ruled she requires no separate signature mechanic. RETURNS TO: its own ruling and stage."],
		["FD-08 the pre-existing 36 / 35 LIFE CONVERSION overflow in the ACCEPTED D-392 loadout", "DECLARED — NOT REPAIRED",
		 "Disclosed at D-396 and never authorized for repair; the D-402 review loadout is sized so it does not occur. RETURNS TO: a later stage, if authorized."],
		["FD-09 a broader trap / deployable framework", "OUT OF SCOPE",
		 "ONE Skill, and nothing is generalised out of it. RETURNS TO: a stage that has a second deployable to share with."],
		["FD-10 enemy AI reacting to, avoiding or attacking traps", "DEFERRED",
		 "Canon says neither deployable is attackable by ordinary enemies in the first MVP, and no avoidance system exists here. RETURNS TO: enemy content."],
		["FD-11 Rift Shard generation on placement (canon: Cinder Field generates on placement)", "OUT OF SCOPE",
		 "No Rift Shard system exists in game3d/. RETURNS TO: a Rift Shard stage."],
		["FD-12 the trap and its Ground across death and area transitions", "DEFERRED",
		 "Neither exists in game3d/. RETURNS TO: a stage that has them."],
		["FD-13 a production UI for the trap, its cap and its timers", "DEFERRED",
		 "The review HUD is tooling and is NOT a UI foundation. RETURNS TO: a UI foundation."],
		["FD-14 audio", "DEFERRED",
		 "ZERO audio assets and ZERO audio hooks. RETURNS TO: an audio pass."],
		["FD-15 controller HARDWARE activation of binding 7", "DECLARED — NOT REPAIRED",
		 "Bindings 7 and 8 carry NO pad event in the accepted input map; this stage adds none, because adding one would change project.godot. A pre-existing gap, disclosed. RETURNS TO: a UI / input foundation."],
		["FD-16 minion/enemy distinguishability in PRODUCTION (KD-11, CD-15, LD-05)", "CARRIED — NOT DISCHARGED",
		 "Untouched here. RETURNS TO: a presentation pass."],
		["FD-17 the five accepted D-389 production-polish debts (SD-07, LD-07)", "CARRIED — NOT DISCHARGED",
		 "Finger, shoulder, string, hood-intersection and foot-sliding. RETURNS TO: a production-polish pass."],
		["FD-18 LD-02, the unscaled ACTION brake", "CARRIED — NOT DISCHARGED",
		 "D-401 RE-CLASSIFIED it as a measured provisional finding -- neither a defect to repair nor a rule to cite -- and this stage neither repairs nor cites it. Cinder Field commits on the same accepted brake. RETURNS TO: nowhere — carried and measured."],
		["FD-19 the earlier runners' delivery-time change-set claims (T17, W17, Y15, Z16, N16) and the closed D-388 spike runner's K08", "DECLARED — NOT REPAIRED",
		 "Each proves its OWN stage's change set against a listing taken before it, so none can pass after D-402; K08 compares the closed spike's verbatim copies with game3d/'s LIVE modules, which this stage changes again. The spikes are preserved, not continued, and NOT edited. tests/cinder_smoke.sh Q18 proves D-402's. RETURNS TO: nowhere — declared."],
	]

## Printed every run by the D-402 suite. NOT a pass and NOT a failure.
##
## ============================================================================
## EMPTY SINCE D-404, AS ITS FIRST ACT — the seven rows were ANSWERED UNDER D-403.
## ============================================================================
## From D-402 until D-404 this returned FO-01 ... FO-07 -- TRUE WHEN WRITTEN, and
## the state the stage was accepted in. The owner's D-403 live review answered
## them with ONE overall sentence: "Looks and feels good." They MOVED -- original
## text preserved VERBATIM -- to `discharged_rows()`. 7 - 7 = 0 owed;
## 0 + 7 = 7 discharged; 0 deleted.
##
## THE ANSWER IS RECORDED AT THE LEVEL IT WAS GIVEN. It was one overall answer,
## so no row-by-row judgment is inferred from it (CLAUDE.md section 6), and no
## number is read into it: no timing, damage, radius, duration, cost, Capacity
## value, instance cap, animation, placeholder model, diagnostic visual or
## presentation detail became a lock. The two findings the owner carried --
## overlapping visuals rendering brighter, and bindings 7 and 8 having no
## controller activation (FD-15) -- are NOT repaired by it.
static func owed_to_owner() -> Array:
	return []

## The rows the owner ANSWERED, printed every run -- NOT passes. Each row is
## [id, the ORIGINAL owed-row text VERBATIM, disposition, the answer || the
## original text again], in the form every earlier stage's discharged rows use.
const D403_ANSWER := "THE OWNER'S D-403 LIVE REVIEW: ANSWERED AS ONE OVERALL ACCEPTANCE — \"Looks and feels good.\" It is recorded at the level it was given: no row-by-row judgment is inferred, and no timing, damage, radius, duration, cost, Capacity value, instance cap, animation, placeholder model, diagnostic visual or presentation detail became a lock. Two findings are CARRIED, not repaired: overlapping diagnostic visuals render brighter, and bindings 7 and 8 have no controller activation (FD-15)."

static func discharged_rows() -> Array:
	var originals := [
		["FO-01", "Does placement feel responsive and accurate while using click-to-move?"],
		["FO-02", "Are dormant, armed and sprung states readable at normal gameplay zoom?"],
		["FO-03", "Do the arming delay and enemy-only trigger feel intuitive?"],
		["FO-04", "Are the initial eruption and lingering burning ground visually distinct?"],
		["FO-05", "Does placing several traps and replacing the oldest behave predictably?"],
		["FO-06", "Does overlapping burning ground clearly avoid multiplying damage?"],
		["FO-07", "Does this feel like a plausible foundation for a trap-focused Huntress build?"],
	]
	var out: Array = []
	for r in originals:
		out.append([String(r[0]), String(r[1]), "DISCHARGED — D-403",
			D403_ANSWER + " || ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + String(r[1]) + "'"])
	return out

## Reused or informing implementation, declared truthfully. NOTHING here loads a
## file outside game3d/.
static func reuse_declaration() -> Array:
	return [
		["the accepted Imprint architecture: learn(), SkillConfiguration, ImprintLoadout, ResourcePool, SkillRuntime.use_binding()", "game3d/scripts/imprint/ (accepted D-376 / D-383 / D-394)",
		 "USED UNCHANGED in behaviour: Cinder Field is one more Skill Imprint and Configuration; its cost, commitment, release and cooldown run through the accepted path."],
		["the accepted STOP commitment, buffered pre-release movement and post-release recovery cancellation", "game3d/scripts/control/action_commitment.gd and player_controller.gd (accepted D-373)",
		 "USED UNCHANGED: no third policy, no new cancel window, no new tunable. `commit_subsystem_action()` is the same seam D-375 added and D-392 used."],
		["HitEligibility and CombatEntityRegistry", "game3d/scripts/huntress/ (accepted D-394)",
		 "USED UNCHANGED: the GENERAL enemy-eligibility rule and the area's combat-entity IDs. An ally -- including a Kindred Hound -- is refused by the same predicate every other effect uses."],
		["time-of-impact arithmetic on the plane, with an exact tie-break by combat-entity ID", "game3d/scripts/huntress/arrow_collision.gd (accepted D-394)",
		 "TECHNIQUE REUSED, RE-IMPLEMENTED for a STATIONARY circle and a MOVING body: the arrow sweeps and the bodies stand still; here the trap stands still and the bodies sweep. The same closed form, the same exact tie-break, and the same refusal to read a name, an instance id or an array order."],
		["the ground-targeted destination validation: clamp to range, then the nearest navigable point", "game3d/scripts/imprint/skill_runtime.gd `_place_ballista` (accepted D-376)",
		 "APPROACH REUSED and MADE REFUSING: the accepted ballista CLAMPS silently; Cinder Field clamps to range and then REFUSES the use outright when the requested point is not walkable, which the ruling requires."],
		["the no-collision, no-navigation placed object", "game3d/scripts/imprint/diag_ballista.gd (accepted D-376)",
		 "APPROACH REUSED: a plain Node3D with meshes and a light, and NO CollisionObject3D at all -- so it cannot block, cannot be hit and cannot change the baked mesh."],
		["prop_scale_for from a mesh's own AABB, and runtime material override instead of editing sources", "game3d/scripts/assets/rig_corpus.gd (accepted D-373)",
		 "REUSED UNCHANGED. No source mesh, .mtl or texture is edited anywhere."],
		["the review-HUD shape: compact, click-through, owning no number", "game3d/scripts/hounds/hound_review_hud.gd and cohort/cohort_review_hud.gd (accepted D-397 / D-399)",
		 "STRUCTURE REUSED, re-implemented for this stage's own facts."],
	]

## What this stage does that no earlier stage did.
static func new_here() -> Array:
	return [
		"A canonical ACTIVE Skill Imprint that places a PERSISTENT WORLD OBJECT rather than firing a projectile: the project's first trap.",
		"A DELAYED COMPONENT of a Skill Use — an eruption that belongs to the use that placed it, carries its Skill Use id, and is NOT a Triggered Skill.",
		"A Skill Use REFUSED for invalid targeting, before any Mana is spent and before any commitment begins.",
		"Deterministic simultaneous-entry resolution by MEASURED entry time within the physics step, with an EXACT tie-break by combat-entity ID.",
		"Two damage components of ONE Skill, separately tagged, separately attributed in the ledger, and separately measurable.",
		"Canon's non-stacking Ground rule as ARITHMETIC: one arbiter, one shared cadence, and exactly one contribution per enemy however many fields overlap.",
		"An instance cap whose oldest member is replaced HARMLESSLY, and an unsprung instance that expires with nothing in the ledger at all.",
	]
