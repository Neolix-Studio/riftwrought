class_name RiftMoteSweepResult
extends RefCounted
## Riftwrought — Roguelite Foundation H5: the answer to one sweep of one Experience
## Mote field, as a pure VALUE.
##
## TWO SHAPES, AND `ok` SAYS WHICH. A sweep was REFUSED as a whole — nothing was
## attempted — or it COMPLETED, having visited every stored drop once. `ok` is the
## authority: nothing else here may be read as an answer until it has been asked.
##
## WHAT EACH SHAPE CARRIES.
##
##   - REFUSED: the single plain-language reason and the number of drops the field
##     held when it was asked. No drop was skipped, attempted, collected, found out
##     of range or refused, so every one of those counts is zero, the collected
##     indices are empty and no item refusal reason is kept — a caller cannot read
##     a plausible partial sweep off a refusal.
##   - COMPLETED: no reason; the number of drops stored; how many were skipped
##     because they were already collected and how many were attempted; the index
##     of every drop collected, ascending; how many were out of range and how many
##     refused; and the first refused drop's reason, kept exactly when at least one
##     was refused.
##
## THE INDICES ARE PRIVATE AND EVERY READING IS A COPY. The value keeps its own copy
## of the indices it was built with and hands out a fresh copy each time, so
## neither the caller who built it nor any caller who reads it can change the
## answer it gives.
##
## Scalars and values only. It holds no field, no drop, no mote, no run, no
## collection attempt result, no node and no other object: it describes a sweep
## that has already happened, and nothing that changes afterwards can change it.
##
##
## IT OWNS NO FORMULA
## ---------------------------------------------------------------------------
## Whether a drop is collected, out of range or refused belongs to accepted
## mechanisms elsewhere. `problem()` checks this value's SHAPE and the
## relationships between its own counts — skipped and attempted make up the stored
## drops; collected, out of range and refused make up the attempted; the collected
## indices are unique, ascending and within the stored range; and a first item
## refusal reason is kept exactly when a drop was refused. It re-derives nothing.
##
## IT IS INERT. No node, no signal, no clock, no random source, no file.

## True when the sweep completed; false when it was refused as a whole. THE
## AUTHORITY.
var ok: bool = false

## Non-empty exactly when the whole sweep was refused: the single plain-language
## reason.
var failure_reason: String = ""

## How many drops the field held when the sweep was asked.
var total_count: int = 0

## How many stored drops were skipped because they were already collected.
var skipped_count: int = 0

## How many stored drops were asked to attempt their collection.
var attempted_count: int = 0

## How many attempted drops were out of range.
var out_of_range_count: int = 0

## How many attempted drops were refused.
var item_refusal_count: int = 0

## The first refused drop's reason, exactly as it was refused; empty when no drop
## was refused.
var first_item_refusal_reason: String = ""

## The index of every drop this sweep collected, ascending. Never handed out; read
## it through `collected_indices()`, which answers a copy.
var _collected_indices: PackedInt32Array = PackedInt32Array()


## A sweep refused as a whole: the reason and the number of drops held, and
## nothing counted.
static func refused(reason: String, for_total_count: int) -> RiftMoteSweepResult:
	var result: RiftMoteSweepResult = RiftMoteSweepResult.new()
	result.ok = false
	result.failure_reason = reason if not reason.strip_edges().is_empty() \
		else "the sweep was refused for an unstated reason"
	result.total_count = for_total_count
	result.skipped_count = 0
	result.attempted_count = 0
	result.out_of_range_count = 0
	result.item_refusal_count = 0
	result.first_item_refusal_reason = ""
	result._collected_indices = PackedInt32Array()
	return result


## A sweep that visited every stored drop once. The indices are copied in, so the
## caller's array is not the value's.
static func completed(
	for_total_count: int,
	for_skipped_count: int,
	for_attempted_count: int,
	for_collected_indices: PackedInt32Array,
	for_out_of_range_count: int,
	for_item_refusal_count: int,
	for_first_item_refusal_reason: String
) -> RiftMoteSweepResult:
	var result: RiftMoteSweepResult = RiftMoteSweepResult.new()
	result.ok = true
	result.failure_reason = ""
	result.total_count = for_total_count
	result.skipped_count = for_skipped_count
	result.attempted_count = for_attempted_count
	result.out_of_range_count = for_out_of_range_count
	result.item_refusal_count = for_item_refusal_count
	result.first_item_refusal_reason = for_first_item_refusal_reason
	result._collected_indices = for_collected_indices.duplicate()
	return result


## A fresh copy of the collected indices, ascending. Changing it changes nothing
## here.
func collected_indices() -> PackedInt32Array:
	return _collected_indices.duplicate()


func collected_count() -> int:
	return _collected_indices.size()


## Returns "" when this value is internally coherent, or the first inconsistency
## found, as the header states.
func problem() -> String:
	if not ok:
		if failure_reason.strip_edges().is_empty():
			return "a refused sweep must state a reason"
		if total_count < 0:
			return "a refused sweep must carry a stored count that is not negative, not %d" % total_count
		if skipped_count != 0 or attempted_count != 0:
			return "a refused sweep must have skipped and attempted nothing, not %d and %d" % [
				skipped_count, attempted_count,
			]
		if not _collected_indices.is_empty() or out_of_range_count != 0 or item_refusal_count != 0:
			return "a refused sweep must carry no collected, out-of-range or refused drop"
		if not first_item_refusal_reason.is_empty():
			return "a refused sweep must keep no item refusal reason"
		return ""
	if not failure_reason.is_empty():
		return "a completed sweep must state no failure reason"
	if total_count < 0 or skipped_count < 0 or attempted_count < 0 \
			or out_of_range_count < 0 or item_refusal_count < 0:
		return "a completed sweep must carry no negative count"
	if skipped_count + attempted_count != total_count:
		return "a completed sweep skipped %d and attempted %d, which is not the %d drops stored" % [
			skipped_count, attempted_count, total_count,
		]
	if _collected_indices.size() + out_of_range_count + item_refusal_count != attempted_count:
		return "a completed sweep collected %d, found %d out of range and had %d refused, which is not the %d attempted" % [
			_collected_indices.size(), out_of_range_count, item_refusal_count, attempted_count,
		]
	var previous: int = -1
	for index: int in _collected_indices:
		if index <= previous or index >= total_count:
			return "a completed sweep's collected indices must be unique, ascending and below %d, not %s" % [
				total_count, _collected_indices,
			]
		previous = index
	if item_refusal_count > 0 and first_item_refusal_reason.strip_edges().is_empty():
		return "a completed sweep with a refused drop must keep the first refusal's reason"
	if item_refusal_count == 0 and not first_item_refusal_reason.is_empty():
		return "a completed sweep with no refused drop must keep no item refusal reason"
	return ""


# --- Presentation -------------------------------------------------------------
#
# Deliberately separate from the answer above, and reached by nothing in it.

func describe() -> String:
	if not ok:
		return "sweep refused — %s" % failure_reason
	return "sweep of %d drops: %d skipped as already collected, %d attempted — %d collected %s, %d out of range, %d refused" % [
		total_count, skipped_count, attempted_count, _collected_indices.size(), _collected_indices,
		out_of_range_count, item_refusal_count,
	]
