class_name RiftBuildApplicationResult
extends RefCounted
## Riftwrought — Roguelite I3: the complete derivation of one run-build application
## (decision D-295).
##
## A LIVE VALUE THAT CANNOT BE CHECKED CANNOT BE REVIEWED. "The swing feels no wider"
## fits a build that holds nothing, a pair the catalogue has no value for, a
## derivation that was refused and an application that was never written equally
## well. So a result carries everything: whether it was derived, why not if not,
## whether it was written, the four stat derivations exactly as C1's calculation path
## returned them — Global Damage's since Roguelite I13 (D-318) and Maximum Life's since
## Roguelite I14 (D-320) — the Life transition Maximum Life carries, every Quick Strike
## quantity beside its canonical baseline, the pairs it applied, and the stats the
## build holds that are not applied here.
##
## SUCCESS AND FAILURE ARE ONE TYPE AND CANNOT BE CONFUSED. A refusal carries its
## reason and no partial value: every number is zero, every list is empty and
## `committed` is false — so a caller that reads a value without reading `ok` gets a
## number that is obviously wrong rather than one that is quietly plausible.
##
## IT IS INERT. No node, no signal, no clock, no file. It describes a derivation that
## has already happened; `committed` is the only field set after it is made, and only
## by the seam that wrote what it describes.

var ok: bool = false

## Non-empty exactly when `ok` is false.
var failure_reason: String = ""

## Whether the seam went on to write every covered value. Always false for a
## derivation that was only derived, and for every refusal.
var committed: bool = false

## The one Skill the covered support values were applied to.
var skill_id: StringName = &""

# --- Skill Speed ---------------------------------------------------------------

## C1's derivation: the canonical action time as its base, the build's whole Skill
## Speed total, and the effective action time as its value. Null for a refusal.
var skill_speed: PlayerStatValue = null

## The build's whole Skill Speed total, handed to the kernel's one entry point.
var increased_skill_speed: float = 0.0

# --- Movement Speed ---------------------------------------------------------------

## C1's derivation: the accepted movement baseline as its base, the build's whole
## Movement Speed total, and the live speed as its value. Null for a refusal.
var movement: PlayerStatValue = null

var movement_speed: float = 0.0

# --- Global Damage ---------------------------------------------------------------

## C1's derivation: the equipped weapon's RAW damage as its base, the build's whole
## Global Damage total, and a Quick Strike Hit's damage as its value — the reading the
## receipt states (Roguelite I13, D-318). Null for a refusal. A derivation, never a
## stored damage number: every Hit is evaluated from its own base when it is committed.
var global_damage: PlayerStatValue = null

## The build's whole Global Damage total, normalized — the one number handed to the
## character. Never a final damage number.
var increased_global_damage: float = 0.0

# --- Maximum Life ---------------------------------------------------------------

## C1's derivation: the character's UNMODIFIED Maximum Life as its base, the build's
## whole Maximum Life total, and the new maximum as its value (Roguelite I14, D-320).
## Null for a refusal.
var maximum_life: PlayerStatValue = null

## The build's whole Maximum Life total, normalized — the one number handed to the
## character. Never a Life number.
var increased_maximum_life: float = 0.0

## The Life transition, read before anything moved: the current Life and maximum as the
## derivation found them, and the Life and maximum the application leaves. The maximum
## after is C1's answer and the Life after is the preservation rule's; `problem()`
## re-derives each rather than trusting it.
var life_before: float = 0.0
var maximum_life_before: float = 0.0
var life_after: float = 0.0
var maximum_life_after: float = 0.0

# --- Quick Strike's covered quantities, each beside its canonical baseline ----------

var reach_baseline: float = 0.0
var reach: float = 0.0
var release_arc_baseline: float = 0.0
var release_arc_degrees: float = 0.0
var soft_target_cone_baseline: float = 0.0
var soft_target_cone_degrees: float = 0.0

## Read from the candidate record and never written: a support that widens the arc
## does not add a target.
var maximum_targets: int = 0

# --- What the build holds beyond the covered values ----------------------------------

## Every pair applied, as "skill -> support rank N".
var supports_applied: PackedStringArray = PackedStringArray()

## Held stats the run's own mote path applies, and held stats this review defers.
var run_path_stats: Array[StringName] = []
var deferred_stats: Array[StringName] = []

## An independent copy of the build's modifier totals, for presenting the stats the
## lists above name. Null for a refusal.
var held_totals: PlayerStatTotals = null


## The only way to build a refusal. It sets nothing but the reason.
static func refused(reason: String) -> RiftBuildApplicationResult:
	var result: RiftBuildApplicationResult = RiftBuildApplicationResult.new()
	result.ok = false
	result.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "the application was refused for an unstated reason"
	return result


static func derived(
	for_skill_id: StringName,
	damage: PlayerStatValue,
	speed: PlayerStatValue,
	maximum: PlayerStatValue,
	life_now: float,
	maximum_now: float,
	life_next: float,
	speed_of_movement: PlayerStatValue,
	canonical: QuickStrikeData,
	candidate: QuickStrikeData,
	applied: PackedStringArray,
	run_path: Array[StringName],
	deferred: Array[StringName],
	totals: PlayerStatTotals
) -> RiftBuildApplicationResult:
	var result: RiftBuildApplicationResult = RiftBuildApplicationResult.new()
	result.ok = true
	result.skill_id = for_skill_id
	result.global_damage = damage
	result.increased_global_damage = damage.total_increased
	result.skill_speed = speed
	result.increased_skill_speed = speed.total_increased
	result.maximum_life = maximum
	result.increased_maximum_life = maximum.total_increased
	result.life_before = life_now
	result.maximum_life_before = maximum_now
	result.life_after = life_next
	result.maximum_life_after = maximum.value
	result.movement = speed_of_movement
	result.movement_speed = speed_of_movement.value
	result.reach_baseline = canonical.reach
	result.reach = candidate.reach
	result.release_arc_baseline = canonical.release_arc_degrees
	result.release_arc_degrees = candidate.release_arc_degrees
	result.soft_target_cone_baseline = canonical.soft_target_cone_degrees
	result.soft_target_cone_degrees = candidate.soft_target_cone_degrees
	result.maximum_targets = candidate.maximum_targets
	result.supports_applied = applied.duplicate()
	result.run_path_stats = run_path.duplicate()
	result.deferred_stats = deferred.duplicate()
	result.held_totals = totals.duplicated()
	return result


# --- Reading the derivation -------------------------------------------------------

func action_time_baseline() -> float:
	return skill_speed.base_value if skill_speed != null else 0.0


func effective_action_time() -> float:
	return skill_speed.value if skill_speed != null else 0.0


func movement_baseline() -> float:
	return movement.base_value if movement != null else 0.0


## Returns "" when the result is internally coherent, or the first inconsistency. The
## four stat derivations are RE-CHECKED by their own rule rather than trusted, the
## numbers copied out of them must still be theirs, and the Life transition is
## re-derived through the same rule that made it. `committed` exempts nothing: a written
## result is held to exactly the same structure as one only derived.
func problem() -> String:
	if not ok:
		if failure_reason.strip_edges().is_empty():
			return "a refused application must state a reason"
		if committed or skill_speed != null or movement != null or global_damage != null \
				or maximum_life != null or not supports_applied.is_empty() or not is_zero_approx(movement_speed) \
				or not is_zero_approx(reach) or increased_global_damage != 0.0 or increased_maximum_life != 0.0 \
				or life_before != 0.0 or maximum_life_before != 0.0 or life_after != 0.0 or maximum_life_after != 0.0:
			return "a refused application must carry no partial value"
		return ""
	if not failure_reason.is_empty():
		return "a derived application must state no failure reason"
	if skill_speed == null or movement == null or held_totals == null:
		return "a derived application is missing its derivation"
	if global_damage == null:
		return "a derived application is missing its Global Damage derivation"
	if maximum_life == null:
		return "a derived application is missing its Maximum Life derivation"
	for derivation: PlayerStatValue in [global_damage, skill_speed, maximum_life, movement]:
		var inconsistent: String = derivation.problem()
		if not derivation.ok or not inconsistent.is_empty():
			return "a stat derivation is not coherent: %s" % inconsistent
	if skill_speed.stat_id != PlayerStats.SKILL_SPEED or movement.stat_id != PlayerStats.MOVEMENT_SPEED:
		return "the stat derivations name %s and %s" % [skill_speed.stat_id, movement.stat_id]
	if global_damage.stat_id != PlayerStats.GLOBAL_DAMAGE:
		return "the Global Damage derivation names %s" % global_damage.stat_id
	if increased_global_damage != global_damage.total_increased \
			or global_damage.total_increased != held_totals.total_for(PlayerStats.GLOBAL_DAMAGE):
		return "the Global Damage total %s is not the build's own %s" % [
			PlayerStats.format_increased(increased_global_damage),
			PlayerStats.format_increased(held_totals.total_for(PlayerStats.GLOBAL_DAMAGE))]
	## RE-DERIVED TO THE LAST BIT rather than trusted: a copied value that merely rounds
	## to C1's answer is still not C1's answer.
	var answer: PlayerStatValue = PlayerStats.apply(
		PlayerStats.GLOBAL_DAMAGE, global_damage.base_value, global_damage.total_increased)
	if not answer.ok or answer.value != global_damage.value:
		return "the Global Damage value %.12f is not C1's own answer %.12f" % [global_damage.value, answer.value]
	## Roguelite I14 (D-320): the Maximum Life derivation, its total, C1's answer to the
	## last bit, and the Life transition — each re-derived rather than trusted.
	if maximum_life.stat_id != PlayerStats.MAXIMUM_LIFE:
		return "the Maximum Life derivation names %s" % maximum_life.stat_id
	if increased_maximum_life != maximum_life.total_increased \
			or maximum_life.total_increased != held_totals.total_for(PlayerStats.MAXIMUM_LIFE):
		return "the Maximum Life total %s is not the build's own %s" % [
			PlayerStats.format_increased(increased_maximum_life),
			PlayerStats.format_increased(held_totals.total_for(PlayerStats.MAXIMUM_LIFE))]
	var ceiling: PlayerStatValue = PlayerStats.apply(
		PlayerStats.MAXIMUM_LIFE, maximum_life.base_value, maximum_life.total_increased)
	if not ceiling.ok or ceiling.value != maximum_life.value:
		return "the Maximum Life value %.12f is not C1's own answer %.12f" % [maximum_life.value, ceiling.value]
	if maximum_life_after != ceiling.value:
		return "the final Maximum Life %.12f is not C1's own answer %.12f" % [maximum_life_after, ceiling.value]
	var transition: String = PrototypePlayer.life_transition_problem(life_before, maximum_life_before, maximum_life_after)
	if not transition.is_empty():
		return "the Life transition is not coherent: %s" % transition
	var preserved: float = PrototypePlayer.preserved_life(life_before, maximum_life_before, maximum_life_after)
	if life_after != preserved:
		return "the Life after %.12f is not the preserved %.12f" % [life_after, preserved]
	if increased_skill_speed != skill_speed.total_increased or movement_speed != movement.value:
		return "the applied numbers are not the derivations' own"
	if maximum_targets != 1:
		return "an applied Quick Strike resolves %d targets, not 1" % maximum_targets
	return ""


# --- Presentation -------------------------------------------------------------------
#
# Reached by nothing above and by nothing in the seam. No formatted string is compared,
# parsed or fed back into a number.

## Every line the derivation can state: each live change, then each held stat this seam
## does not make live, in that order. It is the whole account and NOT a receipt's live
## line — its held lines are not live — so a receipt reads `applied_lines()` and
## `held_lines()` apart and never puts the second under a live heading (D-297).
func live_lines() -> PackedStringArray:
	if not ok:
		return PackedStringArray(["not applied — %s" % failure_reason])
	var lines: PackedStringArray = applied_lines()
	lines.append_array(held_lines())
	return lines


## One line per value the seam actually wrote to the character, and nothing else.
## Empty for a refusal, and for a build that moves no covered value.
func applied_lines() -> PackedStringArray:
	var lines: PackedStringArray = PackedStringArray()
	if not ok:
		return lines
	var geometry: PackedStringArray = PackedStringArray()
	if reach != reach_baseline:
		geometry.append("reach %.2f m → %.2f m" % [reach_baseline, reach])
	if release_arc_degrees != release_arc_baseline:
		geometry.append("arc %.0f° → %.0f°" % [release_arc_baseline, release_arc_degrees])
	if soft_target_cone_degrees != soft_target_cone_baseline:
		geometry.append("cone %.0f° → %.0f°" % [soft_target_cone_baseline, soft_target_cone_degrees])
	if not geometry.is_empty():
		geometry.append("one target" if maximum_targets == 1 else "%d targets" % maximum_targets)
		lines.append(" · ".join(geometry))
	if effective_action_time() != action_time_baseline():
		lines.append("action time %.2f s → %.3f s" % [action_time_baseline(), effective_action_time()])
	if movement_speed != movement_baseline():
		lines.append("movement speed %.1f m/s → %.1f m/s" % [movement_baseline(), movement_speed])
	## Roguelite I13 (D-318): a Quick Strike Hit's damage, from the weapon's raw base to
	## C1's answer at the build's whole total. No card is named: the total is the build's.
	if global_damage != null and global_damage.value != global_damage.base_value:
		lines.append("damage %.0f → %.0f" % [global_damage.base_value, global_damage.value])
	## Roguelite I14 (D-320): the maximum, from the unmodified baseline to C1's answer at
	## the build's whole total, and the fraction of Life the transition kept. No card is
	## named, and no number in it is typed here.
	if maximum_life != null and maximum_life.value != maximum_life.base_value:
		lines.append("%s %s → %s · Life preserved at %s%%" % [
			_display_name(PlayerStats.MAXIMUM_LIFE), _compact(maximum_life.base_value),
			_compact(maximum_life.value), _compact(life_before / maximum_life_before * PERCENT)])
	return lines


## One line per stat the build holds that the seam did NOT make live on the character —
## first those this review defers, then those the run's own mote path applies — each
## line saying which. Empty for a refusal.
func held_lines() -> PackedStringArray:
	var lines: PackedStringArray = PackedStringArray()
	if not ok:
		return lines
	for stat_id: StringName in deferred_stats:
		lines.append("%s held — not applied in this review" % _held(stat_id))
	for stat_id: StringName in run_path_stats:
		lines.append("%s — applied by the run's own mote path" % _held(stat_id))
	return lines


## The whole derivation as one diagnostic line. Roguelite I14's correction (D-321) added the
## Maximum Life derivation and the Life transition it carries beside the other stat diagnostics,
## before the Quick Strike geometry, read from this result's own facts.
func describe() -> String:
	if not ok:
		return "refused: %s" % failure_reason
	return "%s; skill speed %s -> %.9f s; movement %s -> %.3f m/s; global damage %s -> %.3f from %.3f; maximum life %s -> %.3f from %.3f; life %.3f/%.3f -> %.3f/%.3f; reach %.2f m, arc %.0f deg, cone %.0f deg, %d target(s); supports [%s]; run path [%s]; deferred [%s]%s" % [
		skill_id, PlayerStats.format_increased(increased_skill_speed), effective_action_time(),
		PlayerStats.format_increased(movement.total_increased), movement_speed,
		PlayerStats.format_increased(increased_global_damage), global_damage.value, global_damage.base_value,
		PlayerStats.format_increased(increased_maximum_life), maximum_life.value, maximum_life.base_value,
		life_before, maximum_life_before, life_after, maximum_life_after,
		reach, release_arc_degrees, soft_target_cone_degrees, maximum_targets,
		", ".join(supports_applied), _joined(run_path_stats), _joined(deferred_stats),
		"; committed" if committed else "; derived only",
	]


func _held(stat_id: StringName) -> String:
	var total: float = held_totals.total_for(stat_id) if held_totals != null else 0.0
	return "%s %s" % [_display_name(stat_id), PlayerStats.format_increased(total)]


static func _display_name(stat_id: StringName) -> String:
	var shown: String = String(stat_id)
	var record: Variant = PlayerStats.definition(stat_id)
	if record != null:
		shown = record.display_name
	return shown


## Hundredths make a fraction a percentage, and six decimal places are the most a receipt
## number is ever given (Roguelite I14, D-320). Presentation only.
const PERCENT: float = 100.0
const MOST_PLACES: int = 6


## A number as the receipt shows it: with the fewest decimal places — at least one — that
## do not read as a whole number, so a value short of whole never reads as whole: Life
## kept at 99.96% does not read "100%". A value that still reads as whole at six places
## differs from a whole number only by arithmetic noise, and is shown whole. It formats;
## nothing reads it back.
static func _compact(value: float) -> String:
	var places: int = 1
	var shown: String = String.num(value, places)
	while places < MOST_PLACES and _reads_whole(shown):
		places += 1
		shown = String.num(value, places)
	return String.num(value, 0) if _reads_whole(shown) else shown


static func _reads_whole(shown: String) -> bool:
	return shown.to_float() == roundf(shown.to_float())


static func _joined(ids: Array[StringName]) -> String:
	var parts: PackedStringArray = PackedStringArray()
	for id: StringName in ids:
		parts.append(String(id))
	return ", ".join(parts)
