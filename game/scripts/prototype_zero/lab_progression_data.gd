class_name LabProgressionData
extends Resource
## Prototype Zero — Gate E: the progression director's tuning record
## (specification §15, decision D-184).
##
## Every number the contained improvement loop obeys lives here rather than
## inside a timer, a wave list literal, or a UI string (specification §4.4).
##
## THIS IS NOT A PROGRESSION SYSTEM. There is no level, no level curve, no
## experience table, no attribute, no Passive point, no Passive path, no skill
## point, no reward table, and no drop rate. Gate E's whole progression is:
## twenty XP earned in two ten-XP steps, one guaranteed sword, one contained
## Boolean passive, and a deterministic 1 -> 2 -> 3 wave pattern.

@export_group("Experience")
## Specification §14.1 carries this as the Graveblade's XP reward; Gate D held it
## as inert data and Gate E is the gate that finally reads it. The value here is
## asserted against `graveblade.tres` so the two can never disagree.
@export var experience_per_eligible_kill: int = 10
## Specification §15.1: "XP begins at 0 / 20" and 20 / 20 opens the passive
## prompt. XP never exceeds this and is marked Complete once it arrives.
@export var experience_maximum: int = 20

@export_group("Quickened Form — the one contained passive")
@export var passive_name: String = "Quickened Form"
@export var passive_effect_line: String = "25% increased Attack Speed"
## Specification §12.2: 0.80 / (1 + 0.25) = 0.64 s. It is applied through the
## kernel's existing `increased_attack_speed`, so every phase, the animation
## rate, the repeat cadence, and the cancel windows compress together.
@export var passive_increased_attack_speed: float = 0.25

@export_group("Repeat loop")
## Specification §15.1: "spawn one Graveblade, then two, then three; after those
## waves, repeat the deterministic 1 -> 2 -> 3 pattern."
@export var wave_pattern: PackedInt32Array = PackedInt32Array([1, 2, 3])
## Specification §15.1: "delay the next wave approximately 1.25 seconds after the
## previous threat is gone."
@export var wave_delay: float = 1.25

@export_group("Spawn safety, metres")
## Specification §14.3: "Enemy spawn points must avoid body overlap and must not
## surround the player before control returns." All three are MEASURED by
## `PrototypeProgressionDirector.measure_spawn_plan()` before a wave is placed,
## and the Gate E suite asserts the measurements on the same function ordinary
## play uses.
##
## Two 0.80 m bodies need 0.80 m centre to centre merely not to intersect. 1.60 m
## is a full body diameter of clearance on top of that.
@export var minimum_spawn_separation: float = 1.60
## Far enough that a 3.4 m/s Graveblade cannot reach its 1.40 m holding distance
## before control has returned: (6.50 - 1.40) / 3.4 = 1.50 s, and that ignores
## its acceleration and its 0.55 s anticipation.
@export var minimum_player_distance: float = 6.50
## The widest angle, measured at the player, that a wave's spawn points may span.
## A wave arrives from one side of the room; it does not encircle.
@export var maximum_spawn_spread_degrees: float = 120.0
## Keeps a spawn point off the wall faces so the body settles cleanly on the
## navigation mesh.
@export var spawn_floor_margin: float = 1.00

@export_group("Presentation")
## How long a defeated Graveblade's body remains before it is removed. Longer
## than the 0.80 s `Death_A` clip so the collapse finishes, shorter than
## `wave_delay` so the floor is clear before the next wave arrives.
@export var corpse_linger: float = 1.10
## How long a transient Equip / passive-applied / wave message stays on screen.
@export var message_seconds: float = 3.0


## The wave size for a zero-based repeat-loop index.
func wave_size_for(index: int) -> int:
	if wave_pattern.is_empty():
		return 1
	return wave_pattern[index % wave_pattern.size()]


func largest_wave() -> int:
	var largest: int = 1
	for size: int in wave_pattern:
		largest = maxi(largest, size)
	return largest


## Effective Quick Strike action time once Quickened Form is active.
func quickened_action_time(base_action_time: float) -> float:
	return base_action_time / (1.0 + passive_increased_attack_speed)


## Returns "" when the record is coherent, or the first problem found.
func problem() -> String:
	if experience_per_eligible_kill <= 0:
		return "experience_per_eligible_kill must be positive"
	if experience_maximum <= 0:
		return "experience_maximum must be positive"
	if experience_maximum % experience_per_eligible_kill != 0:
		return "the XP maximum must be a whole number of eligible kills"
	if experience_maximum / experience_per_eligible_kill != 2:
		return "specification §15.1: exactly two eligible kills reach the maximum"
	if not is_equal_approx(passive_increased_attack_speed, 0.25):
		return "specification §16.2: Quickened Form is 25% increased Attack Speed"
	if wave_pattern.size() != 3 or wave_pattern[0] != 1 or wave_pattern[1] != 2 or wave_pattern[2] != 3:
		return "specification §15.1: the repeat loop is the deterministic 1 -> 2 -> 3 pattern"
	if wave_delay <= 0.0:
		return "wave_delay must be positive"
	if corpse_linger <= 0.0 or corpse_linger >= wave_delay:
		return "corpse_linger must be positive and shorter than wave_delay"
	if minimum_spawn_separation <= 0.80:
		return "minimum_spawn_separation must exceed one body diameter"
	if minimum_player_distance <= 0.0:
		return "minimum_player_distance must be positive"
	if maximum_spawn_spread_degrees <= 0.0 or maximum_spawn_spread_degrees >= 360.0:
		return "maximum_spawn_spread_degrees must be a real spread"
	return ""


func describe() -> String:
	return "lab progression — %d XP per eligible kill to %d, %s (%s), waves %s every %.2f s after the threat is gone" % [
		experience_per_eligible_kill, experience_maximum, passive_name, passive_effect_line,
		str(Array(wave_pattern)), wave_delay,
	]
