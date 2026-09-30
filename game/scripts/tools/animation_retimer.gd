class_name AnimationRetimer
extends RefCounted
## Piecewise-linear animation time warp, shared by the Prototype Zero attack
## clips.
##
## Both Quick Strike (Gate C) and the Graveblade attack (Gate D) face the same
## problem: a registered KayKit clip whose authored length and authored contact
## moment do not match the locked action timing, and a release query that has to
## fire at the visible contact rather than near it.
##
## The answer in both cases is the same, so it lives in one place:
##
##   * normalise the clip to a 1.000-second length, so clip time IS normalised
##     action time and the release marker is literally the same number in both;
##   * warp key TIMES piecewise-linearly about the measured contact, leaving key
##     VALUES untouched, so every authored pose survives exactly and only its
##     pacing changes;
##   * insert a key at the contact time itself before warping, because the warp
##     is linear only WITHIN a segment — a segment straddling the breakpoint
##     would otherwise be reparametrised unevenly. Skipping this drifted the
##     Quick Strike marker pose by a measured 0.20 m, which is why the callers
##     validate rather than assume.
##
## Tooling only. Nothing in the player-facing loop uses it.

## A bone is still moving while its key differs from the previous one by more
## than this. Below it the difference is import noise, not authored motion.
const STILL_ANGLE_DEGREES: float = 0.05
const STILL_DISTANCE: float = 0.0002

var _contact: float
var _settle: float
var _marker: float
var _length: float

## `contact` and `settle` are times in the SOURCE clip; `marker` is where the
## contact must land in the normalised output, and `length` is the output length.
func _init(contact: float, settle: float, marker: float, length: float = 1.0) -> void:
	_contact = contact
	_settle = settle
	_marker = marker
	_length = length


## Source time -> output time.
func warp(t: float) -> float:
	if t <= _contact:
		return t / _contact * _marker * _length
	var after: float = minf(t, _settle)
	return (_marker + (after - _contact) / (_settle - _contact) * (1.0 - _marker)) * _length


func retime(source: Animation, clip_name: StringName) -> Animation:
	var out: Animation = Animation.new()
	out.resource_name = clip_name
	out.length = _length
	out.loop_mode = Animation.LOOP_NONE
	out.step = 0.0

	for track: int in source.get_track_count():
		var type: int = source.track_get_type(track)
		var index: int = out.add_track(type)
		out.track_set_path(index, source.track_get_path(track))
		out.track_set_interpolation_type(index, source.track_get_interpolation_type(track))
		out.track_set_interpolation_loop_wrap(index, false)

		var times: PackedFloat64Array = PackedFloat64Array()
		for key: int in source.track_get_key_count(track):
			var time: float = source.track_get_key_time(track, key)
			if time <= _settle + 0.0001:
				times.append(time)
		times.append(_contact)
		times.append(_settle)
		times.sort()

		var written: int = 0
		var previous: float = -1.0
		var last_value: Variant = null
		for time: float in times:
			if absf(time - previous) < 0.00005:
				continue
			previous = time
			last_value = sample(source, track, type, time)
			if last_value == null:
				continue
			insert(out, index, type, warp(time), last_value)
			written += 1
		# Hold the settled pose to the end of the normalised clip, so recovery
		# ends on a real pose instead of extrapolating off the last key.
		if written > 0 and last_value != null and _settle < source.length - 0.0001:
			insert(out, index, type, _length, last_value)
	return out


## Value of a track at an arbitrary time, so a key can be introduced anywhere.
static func sample(source: Animation, track: int, type: int, time: float) -> Variant:
	match type:
		Animation.TYPE_POSITION_3D:
			return source.position_track_interpolate(track, time)
		Animation.TYPE_ROTATION_3D:
			return source.rotation_track_interpolate(track, time)
		Animation.TYPE_SCALE_3D:
			return source.scale_track_interpolate(track, time)
	var key: int = source.track_find_key(track, time, Animation.FIND_MODE_NEAREST)
	return source.track_get_key_value(track, key) if key != -1 else null


static func insert(animation: Animation, track: int, type: int, time: float, value: Variant) -> void:
	match type:
		Animation.TYPE_POSITION_3D:
			animation.position_track_insert_key(track, time, value)
		Animation.TYPE_ROTATION_3D:
			animation.rotation_track_insert_key(track, time, value)
		Animation.TYPE_SCALE_3D:
			animation.scale_track_insert_key(track, time, value)
		_:
			animation.track_insert_key(track, time, value)


## The last key at which any track still changes, and which track that was.
## Everything after it is a held pose that would otherwise eat part of the
## action's time budget.
static func measure_settle(source: Animation) -> Dictionary:
	var settle: float = 0.0
	var latest_track: int = -1
	var per_track: Array[Dictionary] = []
	for track: int in source.get_track_count():
		var stops_at: float = 0.0
		for key: int in range(source.track_get_key_count(track) - 1, 0, -1):
			if values_differ(source.track_get_key_value(track, key), source.track_get_key_value(track, key - 1)):
				stops_at = source.track_get_key_time(track, key)
				break
		per_track.append({"track": track, "stops_at": stops_at})
		if stops_at > settle:
			settle = stops_at
			latest_track = track
	return {"settle": settle, "track": latest_track, "per_track": per_track}


static func values_differ(a: Variant, b: Variant) -> bool:
	if a is Quaternion and b is Quaternion:
		return rad_to_deg((a as Quaternion).angle_to(b as Quaternion)) > STILL_ANGLE_DEGREES
	if a is Vector3 and b is Vector3:
		return (a as Vector3).distance_to(b as Vector3) > STILL_DISTANCE
	return a != b
