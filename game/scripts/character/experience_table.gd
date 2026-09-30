class_name ExperienceTable
extends RefCounted
## First-MVP — Gate 1E: the smallest truthful Level/XP curve (D-219).
##
## PROVISIONAL BALANCE DATA, STATED AS SUCH. The brief: "exact XP requirements
## remain provisional balance data" and "Do not retune the accepted Broken
## Watch combat merely to force Level 2." Nothing here is a locked value; it is
## a first curve chosen so that the canonical opening produces an honest
## result rather than a staged one.
##
## THE ONE DESIGN DECISION, AND ITS CONSEQUENCE FOR THIS GATE.
##
## `design/FIRST_MVP_CAMPAIGN_AND_PROGRESSION_JOURNEY.md` §7 says the Passive
## Web "opens because the character now owns a point, not because a tutorial
## schedule says it is time", and explicitly allows either outcome: "If the
## character already reached Level 2, the player may have an ordinary Level
## point as well ... Otherwise the first Web interaction may contain only the
## one Nexus-recognition milestone point."
##
## The canonical opening contains exactly TWO Graveblades (Gate 1D's accepted
## encounters). Prototype Zero's Gate E awarded 10 XP per Graveblade kill as a
## calibration reference. The Level 2 requirement below is **25 XP**, which the
## two authored opening kills (2 x 10 = 20) deliberately do NOT reach.
##
## That is the honest choice, and it is the brief's own instruction: "Do not
## artificially force two points merely to demonstrate the system." Setting the
## requirement at 20 would have made Level 2 arrive exactly on the last
## scripted kill — a schedule wearing a curve's clothing. Setting it at 25
## means the first Web interaction carries the ONE milestone point the canon
## guarantees, the XP bar visibly moves to 20 / 25, and the second point
## arrives from real play in First Footing.
##
## The whole system nonetheless works at two points: `PassiveAllocation` has no
## special case for one, `CharacterState.award_level_point()` exists and is
## exercised by the verification with synthetic XP, and reaching Level 2 by any
## route grants its point through the ordinary path.

## Levels this table defines. Beyond it the character simply stops levelling;
## the first MVP's real curve is a later balance pass with its own authorization.
const MAX_DEFINED_LEVEL: int = 5

## Cumulative XP required to REACH each level. Index 0 is unused so the array
## reads as `TOTAL_FOR_LEVEL[level]`.
const TOTAL_FOR_LEVEL: Array[int] = [0, 0, 25, 70, 140, 240]

## One ordinary Passive point per Level gained after the starting Level, per
## `design/PASSIVE_PROGRESSION.md`'s ordinary-point model.
const POINTS_PER_LEVEL: int = 1

const STARTING_LEVEL: int = 1

## Provisional XP for one ordinary Graveblade, reusing the exact number
## Prototype Zero's Gate E validated for this role. A calibration reference,
## not a rule.
const GRAVEBLADE_EXPERIENCE: int = 10


static func total_required_for(level: int) -> int:
	if level <= STARTING_LEVEL:
		return 0
	if level > MAX_DEFINED_LEVEL:
		return TOTAL_FOR_LEVEL[MAX_DEFINED_LEVEL]
	return TOTAL_FOR_LEVEL[level]


## The level a given total XP corresponds to.
static func level_for_total(total_experience: int) -> int:
	var level: int = STARTING_LEVEL
	for candidate: int in range(STARTING_LEVEL + 1, MAX_DEFINED_LEVEL + 1):
		if total_experience >= TOTAL_FOR_LEVEL[candidate]:
			level = candidate
		else:
			break
	return level


## XP inside the current level, and what the next level needs, for the HUD.
## Returns `{"into": int, "span": int, "next_level": int, "at_maximum": bool}`.
static func progress_for(total_experience: int) -> Dictionary:
	var level: int = level_for_total(total_experience)
	if level >= MAX_DEFINED_LEVEL:
		return {"into": 0, "span": 0, "next_level": level, "at_maximum": true}
	var floor_xp: int = total_required_for(level)
	var next_xp: int = total_required_for(level + 1)
	return {
		"into": total_experience - floor_xp,
		"span": next_xp - floor_xp,
		"next_level": level + 1,
		"at_maximum": false,
	}


static func describe(total_experience: int) -> String:
	var progress: Dictionary = progress_for(total_experience)
	if bool(progress["at_maximum"]):
		return "Level %d (maximum defined level)" % level_for_total(total_experience)
	return "Level %d — %d / %d XP toward Level %d" % [
		level_for_total(total_experience), progress["into"], progress["span"], progress["next_level"],
	]


## Returns "" when the table is coherent. A non-monotonic curve would make
## `level_for_total()` answer nonsense, so it is checked rather than assumed.
static func problem() -> String:
	if TOTAL_FOR_LEVEL.size() != MAX_DEFINED_LEVEL + 1:
		return "TOTAL_FOR_LEVEL must hold one entry per level from 0 to %d" % MAX_DEFINED_LEVEL
	for level: int in range(STARTING_LEVEL + 1, MAX_DEFINED_LEVEL + 1):
		if TOTAL_FOR_LEVEL[level] <= TOTAL_FOR_LEVEL[level - 1]:
			return "level %d requires no more XP than level %d" % [level, level - 1]
	if GRAVEBLADE_EXPERIENCE <= 0:
		return "GRAVEBLADE_EXPERIENCE must be positive"
	return ""
