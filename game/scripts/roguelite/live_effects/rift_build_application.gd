class_name RiftBuildApplication
extends RefCounted
## Riftwrought — Roguelite I3: the one seam through which a run's temporary build
## reaches the playable character (decision D-295).
##
## THE ONE THING IT DOES. Handed a COMPLETE run-build snapshot, the playable player
## and the playable loop's accepted movement baseline, it derives every covered live
## value from that whole build and from the accepted baselines, refuses before
## writing anything if a single required fact is incoherent, and only then writes
## the covered values — all of them, every time.
##
##
## WHAT IS COVERED, AND EXACTLY WHERE EACH VALUE GOES
## ---------------------------------------------------------------------------
##   * GLOBAL DAMAGE — the build's WHOLE total, through C1's accepted `value_of()`
##     against the equipped weapon's RAW damage — never against the player's
##     already modified outgoing damage — handed to the player's one entry point,
##     `PrototypePlayer.set_increased_global_damage()`, as the normalized total and
##     never as a damage number (Roguelite I13, D-318). Every Hit the player
##     produces is evaluated through that total BY THE PLAYER when the Hit is
##     committed; the derivation carried here is the Quick Strike reading of it, the
##     one the receipt states.
##   * SKILL SPEED — the build's WHOLE total, through C1's accepted `value_of()`
##     against the canonical action time, handed to the accepted kernel through
##     `PrototypePlayer.set_increased_attack_speed()`: the single entry point every
##     phase, the animation position, the repeat cadence and the cancel windows are
##     already derived from. The kernel's own timing of that total is asked as well
##     and must agree to the last bit with the stat path, or nothing is written.
##   * MAXIMUM LIFE — the build's WHOLE total, through C1's accepted `value_of()`
##     against the player's UNMODIFIED baseline — never against a maximum a total has
##     already moved, which would compound — handed to the player's one entry point,
##     `PrototypePlayer.set_increased_maximum_life()`, as the normalized total and never
##     as a Life number (Roguelite I14, D-320). The player moves current Life with it,
##     keeping its FRACTION by the player's own one rule; the transition that rule makes
##     is derived and checked here first, carried by the result, and refused before
##     anything moves.
##   * MOVEMENT SPEED — the build's whole total, through `value_of()` against the
##     accepted movement baseline, written to the player's `max_speed`. Acceleration,
##     braking, arrival tolerance and the controls are not touched.
##   * SUPPORT EFFECTS — for every Skill/support pair the build holds, at the rank it
##     holds it, the catalogue's own record for EXACTLY that rank — rank one's since
##     I3, and rank two's since Roguelite I4 (D-298) — written to Quick Strike's
##     PRIVATE runtime record: reach, release arc, soft-target cone. Nothing else. A
##     rank the catalogue holds no record for — rank three or any higher — is refused,
##     and the refusal names the Skill, the support, the rank and the exact ranks the
##     catalogue does hold.
##
##
## WHAT IS NOT COVERED, AND IS SAID RATHER THAN SILENTLY CLAIMED
## ---------------------------------------------------------------------------
##   * Nothing the build holds is deferred any longer. Global Damage was held here until
##     Roguelite I13 (D-318) made it live, and Maximum Life, the last, until Roguelite
##     I14 (D-320). `deferred_stats()` stays, empty, for the readers that ask it.
##   * Experience Gain and Pickup Radius are ALREADY live through the run's own
##     accepted mote path, which evaluates them from the run's own build at the moment
##     a mote pays and a sweep measures. The result lists them as such, and they are
##     NOT reimplemented: nothing here awards, sweeps or measures a distance.
##
##
## BASELINES ARE READ, NEVER REMEMBERED, AND NEVER TAKEN FROM A VALUE AN APPLICATION WROTE
## ---------------------------------------------------------------------------
## Quick Strike's baselines are the canonical record the action keeps beside its
## private copy (D-191) — read, never written. Skill Speed's baseline is no increase
## at all. Movement's baseline is handed in by the owner of the playable loop, which
## set the player's speed from that same number when it spawned them. Global Damage's
## base is the equipped weapon's RAW damage, which no application writes: it is read
## from the weapon the player carries, never from the player's outgoing damage, which
## already carries a total (Roguelite I13, D-318). Maximum Life's base is the player's
## own unmodified baseline, which no application writes: the player captures it from its
## configured maximum before a total first moves it (Roguelite I14, D-320). No value is
## derived from anything an application wrote, so nothing can compound: one build applied twice leaves identical
## values, and an EMPTY build restores every baseline without knowing — or needing to
## know — what was applied before it.
##
## THE WHOLE BUILD, NEVER THE NEWEST CARD. The build is the only authority. No
## receipt, card, lane or offer is read here. Two acquisitions of one card are one
## total of their sum, and a support is read from the pair and the rank the build
## holds.
##
##
## IT REFUSES BEFORE IT WRITES, AND A REFUSAL WRITES NOTHING
## ---------------------------------------------------------------------------
## Every candidate value is derived first, into a result. The candidate Quick Strike
## record is a DETACHED copy of the canonical one and must pass the record's own
## `problem()`. A pair held on a Skill the player does not equip, a rank the
## catalogue holds no value for, two supports setting one quantity, a stat path that
## refuses — Global Damage's and Maximum Life's included — a current Life or maximum that
## is not coherent, a kernel that would time the Skill differently from the stat path,
## and a live record that is still the canonical one rather than a private copy are each
## refused with a reason — and in every one of those cases no live value moves. The two
## writes the player itself can refuse, the Global Damage total and then the Maximum Life
## total, are made FIRST. If the second is refused the first is put back — silently,
## because that write signals nothing — so even that refusal leaves every covered value,
## and everything observable from the player, where it stood (Roguelite I14, D-320).
##
## WHAT IT NEVER DOES. It writes no canonical record or file, adds no tag, moves no target
## count, scales no rank, writes no weapon — it only reads the equipped weapon's raw
## damage — and touches no cooldown, trigger or animation asset. It moves Life only
## through the player's one Maximum-Life entry point, which keeps Life's fraction and so
## never heals, damages, kills or revives. It computes no final damage number and writes
## none, and it saves nothing. It is not a node: no scene, no signal, no clock, no file.


# --- Which stats this seam covers, and which it names without applying ---------------

## The four stats whose whole totals are applied to the playable character — Global
## Damage's since Roguelite I13 (D-318) and Maximum Life's since Roguelite I14 (D-320) —
## in the vocabulary's canonical order.
static func covered_stats() -> Array[StringName]:
	var out: Array[StringName] = [
		PlayerStats.GLOBAL_DAMAGE, PlayerStats.SKILL_SPEED, PlayerStats.MAXIMUM_LIFE, PlayerStats.MOVEMENT_SPEED,
	]
	return out


## The two stats the run's own accepted mote path already applies. Named, never
## applied here.
static func run_path_stats() -> Array[StringName]:
	var out: Array[StringName] = [PlayerStats.EXPERIENCE_GAIN, PlayerStats.PICKUP_RADIUS]
	return out


## The stats this review holds and deliberately does not apply — now none. Global Damage
## left this list for `covered_stats()` under Roguelite I13 (D-318), and Maximum Life,
## the last, under Roguelite I14 (D-320). It stays, empty, for the readers that ask it.
static func deferred_stats() -> Array[StringName]:
	var out: Array[StringName] = []
	return out


## The Skill quantities a support may set, as the catalogue names them.
static func covered_quantities() -> Array[StringName]:
	var out: Array[StringName] = [
		SkillSupportCatalogue.STRIKE_REACH,
		SkillSupportCatalogue.STRIKE_RELEASE_ARC_DEGREES,
		SkillSupportCatalogue.STRIKE_SOFT_TARGET_CONE_DEGREES,
	]
	return out


# --- Deriving ---------------------------------------------------------------------

## Everything `build` would make live on `player`, derived and checked, and NOTHING
## written. A refusal carries its reason and no partial value.
static func derive(
	build: RiftRunBuild, player: PrototypePlayer, movement_baseline: float
) -> RiftBuildApplicationResult:
	if build == null:
		return RiftBuildApplicationResult.refused(
			"an application needs a run build, and none was given")
	if player == null:
		return RiftBuildApplicationResult.refused(
			"an application needs the playable player, and none was given")
	var action: QuickStrikeAction = player.attack
	if action == null:
		return RiftBuildApplicationResult.refused(
			"the player holds no Quick Strike action for a build to reach")
	var canonical: QuickStrikeData = action.canonical_data
	if action.data == null or canonical == null:
		return RiftBuildApplicationResult.refused(
			"Quick Strike holds no live record, or no canonical record beside it")
	if not action.data_is_private():
		return RiftBuildApplicationResult.refused(
			"Quick Strike's live record is its canonical record rather than a private runtime copy; writing it would write the canonical record, so nothing was applied")
	var canonical_problem: String = canonical.problem()
	if not canonical_problem.is_empty():
		return RiftBuildApplicationResult.refused(
			"the canonical Quick Strike record is incoherent: %s" % canonical_problem)
	if not is_finite(movement_baseline) or movement_baseline <= 0.0:
		return RiftBuildApplicationResult.refused(
			"the movement baseline %s is not a positive finite speed" % str(movement_baseline))

	## THE ONE EQUIPPED SKILL. The catalogue's Quick Strike profile is built from the
	## same canonical record the player's action keeps beside its copy, so the two
	## must name the same Skill.
	var equipped_id: StringName = SkillSupportCatalogue.quick_strike_profile().skill_id
	var equipped_name: String = SkillSupportCatalogue.quick_strike_profile().display_name
	if String(equipped_id).is_empty() or canonical.display_name != equipped_name:
		return RiftBuildApplicationResult.refused(
			"the player's Quick Strike record is '%s', not the catalogue's '%s'"
				% [canonical.display_name, equipped_name])

	## THE STATS: the build's whole totals, through the one calculation path.
	var totals: PlayerStatTotals = build.stat_totals()
	## GLOBAL DAMAGE FIRST (Roguelite I13, D-318): the build's whole total against the
	## equipped weapon's RAW damage — never against the player's outgoing damage, which
	## already carries a total and would apply this one on top of it.
	var damage: PlayerStatValue = totals.value_of(PlayerStats.GLOBAL_DAMAGE, player.physical_damage)
	if not damage.ok:
		return RiftBuildApplicationResult.refused("Global Damage: %s" % damage.failure_reason)
	var speed: PlayerStatValue = totals.value_of(PlayerStats.SKILL_SPEED, canonical.action_time)
	if not speed.ok:
		return RiftBuildApplicationResult.refused("Skill Speed: %s" % speed.failure_reason)
	var kernel_time: float = canonical.effective_action_time(speed.total_increased)
	if kernel_time != speed.value:
		return RiftBuildApplicationResult.refused(
			"Quick Strike's kernel would take %.9f s where the stat path answers %.9f s for %s increased Skill Speed; nothing was applied"
				% [kernel_time, speed.value, PlayerStats.format_increased(speed.total_increased)])
	## MAXIMUM LIFE (Roguelite I14, D-320): the build's whole total against the player's
	## UNMODIFIED baseline, and the Life transition the player's own rule would make from
	## the Life and maximum it holds now — refused here, before anything moves, whenever
	## the player's own entry point would refuse it.
	var maximum: PlayerStatValue = totals.value_of(PlayerStats.MAXIMUM_LIFE, player.maximum_life_baseline())
	if not maximum.ok:
		return RiftBuildApplicationResult.refused("Maximum Life: %s" % maximum.failure_reason)
	var life_now: float = player.life
	var maximum_now: float = player.max_life
	var transition: String = PrototypePlayer.life_transition_problem(life_now, maximum_now, maximum.value)
	if not transition.is_empty():
		return RiftBuildApplicationResult.refused("Maximum Life: %s; nothing was applied" % transition)
	var life_next: float = PrototypePlayer.preserved_life(life_now, maximum_now, maximum.value)
	var movement: PlayerStatValue = totals.value_of(PlayerStats.MOVEMENT_SPEED, movement_baseline)
	if not movement.ok:
		return RiftBuildApplicationResult.refused("Movement Speed: %s" % movement.failure_reason)

	var run_path: Array[StringName] = []
	var deferred: Array[StringName] = []
	for stat_id: StringName in totals.stats():
		if covered_stats().has(stat_id):
			continue
		if run_path_stats().has(stat_id):
			run_path.append(stat_id)
		elif deferred_stats().has(stat_id):
			deferred.append(stat_id)
		else:
			return RiftBuildApplicationResult.refused(
				"%s is held by the build, and this seam does not know whether it is live" % stat_id)

	## THE SUPPORTS: every pair the build holds, at the rank it holds it.
	var held: Array[StringName] = build.supports_for(equipped_id)
	if build.support_count() != held.size():
		return RiftBuildApplicationResult.refused(
			"the build holds %d Skill/support pair(s), and only %d belong to %s, the one Skill the player equips; nothing was applied"
				% [build.support_count(), held.size(), equipped_id])
	var set_by: Dictionary = {}
	var values: Dictionary = {}
	var applied: PackedStringArray = PackedStringArray()
	for support_id: StringName in held:
		var rank: int = build.support_rank_for(equipped_id, support_id)
		var rank_values: Dictionary = SkillSupportCatalogue.support_rank_values(equipped_id, support_id, rank)
		if rank_values.is_empty():
			return RiftBuildApplicationResult.refused(
				"%s on %s is held at rank %d, and the catalogue holds %s; nothing was applied"
					% [support_id, equipped_id, rank, _reviewed_ranks_phrase(
						SkillSupportCatalogue.reviewed_support_ranks(equipped_id, support_id))])
		for quantity: Variant in rank_values:
			var named: StringName = quantity as StringName
			if not covered_quantities().has(named):
				return RiftBuildApplicationResult.refused(
					"%s sets %s, which this seam does not cover; nothing was applied" % [support_id, named])
			if set_by.has(named):
				return RiftBuildApplicationResult.refused(
					"%s and %s both set %s; nothing was applied" % [set_by[named], support_id, named])
			set_by[named] = support_id
			values[named] = float(rank_values[quantity])
		applied.append("%s -> %s rank %d" % [equipped_id, support_id, rank])

	## THE CANDIDATE RECORD: a detached copy of the canonical one, carrying the covered
	## values, which must pass the record's own coherence rule before anything is live.
	var candidate: QuickStrikeData = canonical.duplicate(true) as QuickStrikeData
	candidate.resource_path = ""
	candidate.reach = float(values.get(SkillSupportCatalogue.STRIKE_REACH, canonical.reach))
	candidate.release_arc_degrees = float(values.get(
		SkillSupportCatalogue.STRIKE_RELEASE_ARC_DEGREES, canonical.release_arc_degrees))
	candidate.soft_target_cone_degrees = float(values.get(
		SkillSupportCatalogue.STRIKE_SOFT_TARGET_CONE_DEGREES, canonical.soft_target_cone_degrees))
	var candidate_problem: String = candidate.problem()
	if not candidate_problem.is_empty():
		return RiftBuildApplicationResult.refused(
			"the candidate Quick Strike record would be incoherent: %s; nothing was applied" % candidate_problem)

	return RiftBuildApplicationResult.derived(
		equipped_id, damage, speed, maximum, life_now, maximum_now, life_next, movement, canonical, candidate,
		applied, run_path, deferred, totals)


# --- Applying ---------------------------------------------------------------------

## Derives, and only when the derivation succeeded writes every covered value to the
## player's runtime state and Quick Strike's private record. Returns the derivation
## either way; `committed` says whether anything was written.
##
## The Global Damage total is written FIRST (Roguelite I13, D-318) and the Maximum Life
## total SECOND (Roguelite I14, D-320): they are the two writes the player itself can
## refuse, so either refusal leaves every covered value where it stood. The Global Damage
## write signals nothing, so when the Maximum Life write is refused the previous Global
## Damage total is simply written back — a total the player already accepted once, which
## it therefore accepts again — and nothing observable from the player has moved. The
## derivation above already asked the same calculation path and the player's own Life
## rule about the same totals and the same Life, so neither refusal is expected; each is
## handled rather than assumed.
static func apply(
	build: RiftRunBuild, player: PrototypePlayer, movement_baseline: float
) -> RiftBuildApplicationResult:
	var result: RiftBuildApplicationResult = derive(build, player, movement_baseline)
	if not result.ok:
		return result
	var previous_damage: float = player.increased_global_damage()
	var refusal: String = player.set_increased_global_damage(result.increased_global_damage)
	if not refusal.is_empty():
		return RiftBuildApplicationResult.refused(
			"the player refused the Global Damage total: %s; nothing was applied" % refusal)
	refusal = player.set_increased_maximum_life(result.increased_maximum_life)
	if not refusal.is_empty():
		player.set_increased_global_damage(previous_damage)
		return RiftBuildApplicationResult.refused(
			"the player refused the Maximum Life total: %s; nothing was applied" % refusal)
	var live: QuickStrikeData = player.attack.data
	live.reach = result.reach
	live.release_arc_degrees = result.release_arc_degrees
	live.soft_target_cone_degrees = result.soft_target_cone_degrees
	player.set_increased_attack_speed(result.increased_skill_speed)
	player.max_speed = result.movement_speed
	result.committed = true
	return result


# --- Naming the reviewed ranks ----------------------------------------------------

## What a refusal says the catalogue DOES hold for one pair, from the catalogue's own
## ascending list: "reviewed values only for ranks 1 and 2", "a reviewed value only for
## rank 1", or "no reviewed value for it at any rank". It joins the ranks it is handed
## and computes none of them.
static func _reviewed_ranks_phrase(ranks: Array[int]) -> String:
	if ranks.is_empty():
		return "no reviewed value for it at any rank"
	var last: int = ranks.back()
	var earlier: PackedStringArray = PackedStringArray()
	for each: int in ranks:
		if each != last:
			earlier.append(str(each))
	if earlier.is_empty():
		return "a reviewed value only for rank %d" % last
	return "reviewed values only for ranks %s and %d" % [", ".join(earlier), last]
