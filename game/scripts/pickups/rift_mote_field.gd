class_name RiftMoteField
extends RefCounted
## Riftwrought — Roguelite Foundation H5: the Experience Mote drops of one run,
## held together as a pure in-memory field, and one deterministic sweep that
## attempts every drop not yet collected, in the order the drops were made.
##
## THE ONE THING IT PROVES. A field belongs to exactly one run — the run whose
## seed it was made with. It makes its own drops (Foundation H4) from positions
## and amounts a caller supplies, keeps them in the order it made them, and hands
## out none of them. Swept into its own run, it asks every drop not yet collected
## to attempt its own collection exactly once, first to last, and reports what
## happened to the whole field as one value. Swept into any other run, it refuses
## before a single drop is asked anything.
##
##
## IT HOLDS TWO THINGS, AND NOTHING ELSE
## ---------------------------------------------------------------------------
## The run seed, exactly as it was given, and the drops, in the order they were
## made. There is no stored count, cursor, history, player position, radius,
## timestamp, owner object, run reference or result: every count is derived from
## the drops on the moment it is asked, and a second copy of any of it here would
## be a second thing that could be wrong.
##
## THE RUN SEED IS COMPARED WHOLE. Every signed 64-bit integer is a run seed the
## accepted run answers for, so none is masked, folded, normalized or refused here.
## Two seeds that agree only in their low 32 bits belong to two different runs.
##
## THE FIELD MAKES ITS OWN DROPS AND HANDS NONE OUT. A drop is made here, with this
## field's own run seed, from the position and amount the caller supplies; no
## caller can hand the field a drop, and no reading returns one. The drop decides
## whether that position and amount make a valid drop — this file adds no rule of
## its own about either, and transforms neither. A drop the accepted drop calls
## invalid is not kept, and the field does not change.
##
## ENTRIES ARE ONLY EVER APPENDED. A collected drop stays exactly where it was, at
## the same index, and later sweeps skip it. Nothing is removed, replaced,
## reordered, pruned, cleared, reset, copied, transferred, saved or torn down.
##
##
## THE SWEEP ORDER IS THE CONTRACT
## ---------------------------------------------------------------------------
## 1. A missing run refuses the whole sweep.
## 2. A field that is not coherent refuses the whole sweep, with its own problem.
## 3. The field's run seed is compared with the run's, whole. If they differ, the
##    whole sweep is refused HERE, naming both seeds, before any drop is asked
##    anything — so no drop, and not the run, can move.
## 4. Only then is every stored drop visited, by ascending index — the order the
##    drops were made in, and no other. The order is never sorted, shuffled or
##    chosen by nearness.
## 5. A drop already collected is skipped, and is never asked again.
## 6. Every other drop is asked to attempt its own collection exactly once, with
##    the player's position and the run, and its answer is counted: collected (its
##    index is recorded), out of range, or refused (the first refusal's reason is
##    kept). A refused drop does not stop the sweep: every later drop is still
##    asked.
##
## EACH ATTEMPT IS ATOMIC; THE SWEEP IS NOT. Every drop's attempt either pays its
## whole amount into the run or moves nothing, exactly as the accepted attempt
## guarantees. The sweep adds no transaction around them: a later refusal never
## undoes an earlier collection, and nothing is retried.
##
## THE SWEEP NEVER LEVELS ANYTHING UP. Experience that reaches or passes the
## current requirement during a sweep opens nothing and advances nothing; the
## sweep carries on through every entry, and opening and choosing stay the
## caller's explicit steps through the run.
##
## WHAT IT DOES NOT DO. It measures no distance, reads no radius, computes no
## percentage and no experience, derives no requirement and no offer seed, and
## names no content and no balance value — every amount is the caller's. It scans
## no world, spawns nothing on its own, moves nothing, attracts nothing, and never
## decides when to sweep. No node, no signal, no scene, no physics, no clock, no
## random source, no file. Nothing that runs creates a field.

## The seed of the one run every drop in this field belongs to, exactly as it was
## given.
var _run_seed: int

## Every drop this field has made, in the order it made them. Only ever appended;
## never handed out.
var _drops: Array[RiftMoteDrop]


## A new, empty field belonging to the run seeded `for_run_seed`.
func _init(for_run_seed: int) -> void:
	_run_seed = for_run_seed


# --- Making a drop ----------------------------------------------------------------

## Makes one new drop of this field's run, lying at `drop_position` and worth
## `base_experience`, and appends it at the end. Returns "" when it was appended,
## or the new drop's own problem, verbatim, when it was not — in which case nothing
## was appended and the field is exactly as it was.
func spawn_drop(drop_position: Vector3, base_experience: float) -> String:
	var drop: RiftMoteDrop = RiftMoteDrop.new(_run_seed, drop_position, base_experience)
	var invalid: String = drop.problem()
	if not invalid.is_empty():
		return invalid
	_drops.append(drop)
	return ""


# --- Reading the field ------------------------------------------------------------
#
# Scalars only, every one derived from the drops at the moment it is asked, and
# deliberately no setter and no way to reach a drop.

func run_seed() -> int:
	return _run_seed


func drop_count() -> int:
	return _drops.size()


func uncollected_count() -> int:
	var uncollected: int = 0
	for drop: RiftMoteDrop in _drops:
		if not drop.is_collected():
			uncollected += 1
	return uncollected


## Derived, never stored: every stored drop is either collected or not.
func collected_count() -> int:
	return _drops.size() - uncollected_count()


## Returns "" when every stored entry holds a drop, every drop is a valid record by
## its own rule, and every drop belongs to this field's exact run seed — or the
## first entry that does not, as one plain-language reason.
func problem() -> String:
	for index: int in _drops.size():
		var drop: RiftMoteDrop = _drops[index]
		if drop == null:
			return "entry %d of this Experience Mote field holds no drop" % index
		var invalid: String = drop.problem()
		if not invalid.is_empty():
			return "entry %d of this Experience Mote field is not a valid drop: %s" % [index, invalid]
		if drop.run_seed() != _run_seed:
			return "entry %d of this Experience Mote field belongs to run seed %d, not to the field's run seed %d" % [
				index, drop.run_seed(), _run_seed,
			]
	return ""


# --- Sweeping ---------------------------------------------------------------------

## Sweeps this field into `run`, for a player standing at `player_position`, in the
## order the header states. Always answers one whole-sweep value: refused, or
## completed with the count of every outcome.
func sweep_collection(player_position: Vector3, run: RiftRunLevelCoordinator) -> RiftMoteSweepResult:
	if run == null:
		return RiftMoteSweepResult.refused(
			"an Experience Mote field must be swept into a run, and none was given", _drops.size())
	var incoherent: String = problem()
	if not incoherent.is_empty():
		return RiftMoteSweepResult.refused(incoherent, _drops.size())
	if run.run_seed() != _run_seed:
		return RiftMoteSweepResult.refused(
			"this Experience Mote field belongs to run seed %d, not to run seed %d; it may be swept only into the run that dropped its motes" % [
				_run_seed, run.run_seed(),
			], _drops.size())
	var skipped: int = 0
	var attempted: int = 0
	var collected: PackedInt32Array = PackedInt32Array()
	var out_of_range: int = 0
	var item_refusals: int = 0
	var first_item_refusal: String = ""
	for index: int in _drops.size():
		var drop: RiftMoteDrop = _drops[index]
		if drop.is_collected():
			skipped += 1
			continue
		attempted += 1
		var answer: RiftMoteCollectionResult = drop.attempt_collection(player_position, run)
		if answer.is_collected():
			collected.append(index)
		elif answer.is_out_of_range():
			out_of_range += 1
		else:
			item_refusals += 1
			if first_item_refusal.is_empty():
				first_item_refusal = answer.failure_reason
	return RiftMoteSweepResult.completed(
		_drops.size(), skipped, attempted, collected, out_of_range, item_refusals, first_item_refusal)


# --- Presentation -----------------------------------------------------------------
#
# Reached by nothing above.

func describe() -> String:
	return "Experience Mote field of run seed %d: %d drops, %d collected, %d not collected" % [
		_run_seed, drop_count(), collected_count(), uncollected_count(),
	]
