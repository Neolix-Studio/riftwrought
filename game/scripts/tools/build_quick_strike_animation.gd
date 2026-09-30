extends SceneTree
## Prototype Zero — Gate C: build the local editable Quick Strike animation.
##
## Specification §12.1 requires the attack to be resolved from "an animation
## release marker placed at the visible contact moment in an editable local
## animation copy", and requires the marker, the damage query, and the visible
## impact to agree. Gate A recorded the obstacle: the registered clip
## `Melee_1H_Attack_Slice_Horizontal` is 1.3667 s against a locked 0.80 s action
## time, so the marker has to live in NORMALISED clip time.
##
## This tool does three things, all from measurement rather than assumption:
##
##   1. Finds the moment the swing actually connects, defined as the frame where
##      the blade tip crosses the character's forward axis during the clip's
##      fastest sweep. That single definition is corroborated by two independent
##      signals: peak angular sweep rate and furthest forward reach.
##   2. Finds where authored motion stops, so the clip's dead tail is not paid
##      for out of the 0.80 s action budget.
##   3. Writes a retimed local copy, normalised to a 1.000 s length so clip time
##      IS normalised action time, with the measured contact warped onto the
##      release marker the locked timing demands.
##
## After that, playing the copy at `speed_scale = 1 / effective_action_time`
## makes the visible contact and the release query coincide BY CONSTRUCTION, at
## any attack speed. `gate_c_verification.gd` then proves it by sampling the
## live AnimationPlayer position at the instant the release query fires.
##
## Regenerate with:
##   godot --headless --path game --script res://scripts/tools/build_quick_strike_animation.gd
## Add `-- --table` for the full per-sample measurement table.

const SOURCE_GLB: String = "res://assets/third_party/kaykit/animations/Rig_Medium_CombatMelee.glb"
const SOURCE_CLIP: StringName = &"Melee_1H_Attack_Slice_Horizontal"
const RIG_SCENE: String = "res://scenes/actors/knight_rig.tscn"
const SWORD_SCENE: String = "res://assets/third_party/kaykit/adventurer/sword_1handed.gltf"
const OUTPUT_PATH: String = "res://assets/prototype/animation/quick_strike_prototype_animation.res"

const OUTPUT_CLIP: StringName = &"Quick_Strike_Slice"
const SOCKET_BONE: StringName = &"handslot.r"

## Where the release marker must land in the retimed clip. This is not a taste
## value: the locked Quick Strike timing is 0.26 s wind-up out of a 0.80 s total
## action (decision D-168 / specification §12.1), and 0.26 / 0.80 = 0.325.
const RELEASE_MARKER: float = 0.26 / 0.80

## The retimed copy is normalised to one second so clip time reads directly as
## normalised action time.
const OUTPUT_LENGTH: float = 1.0

const SAMPLES: int = 1367

var _failures: int = 0
var _settle_detail: Array[Dictionary] = []
var _settle_track: int = -1


func _initialize() -> void:
	print("=== Riftwrought Gate C — Quick Strike animation build ===")
	var show_table: bool = OS.get_cmdline_user_args().has("--table")

	var source: Animation = _load_source()
	if source == null:
		_finish()
		return

	var rig: Node3D = (load(RIG_SCENE) as PackedScene).instantiate() as Node3D
	var skeleton: Skeleton3D = rig.get_node("Knight/Rig_Medium/Skeleton3D") as Skeleton3D
	var sampler: AnimationBoneSampler = AnimationBoneSampler.new(skeleton, source)
	var socket: int = skeleton.find_bone(SOCKET_BONE)
	var tip_local: Vector3 = _blade_tip()

	print("")
	print("--- Source clip")
	print("  clip                  %s" % SOURCE_CLIP)
	print("  source                %s" % SOURCE_GLB.get_file())
	print("  length                %.4f s   (%d tracks, %d animated bones, %.1f fps step)" % [
		source.length, source.get_track_count(), sampler.animated_bone_count(), 1.0 / source.step,
	])
	print("  socket bone           %s (index %d on the Knight)" % [SOCKET_BONE, socket])
	print("  blade tip in socket   (%.3f, %.3f, %.3f), %.3f m from the socket" % [
		tip_local.x, tip_local.y, tip_local.z, tip_local.length(),
	])

	var motion: Array[Dictionary] = _measure_motion(sampler, source, socket, tip_local)
	if show_table:
		_print_table(motion)
	var contact: float = _report_contact(motion)
	var settle: float = _measure_settle(source)
	print("")
	print("--- Where authored motion stops")
	print("  last moving key       %.4f s   (%.1f%% of the clip), on track %d %s" % [
		settle, settle / source.length * 100.0, _settle_track,
		str(source.track_get_path(_settle_track)) if _settle_track != -1 else "",
	])
	print("  frozen tail dropped   %.4f s   (%.1f%% of the clip held a single pose)" % [
		source.length - settle, (source.length - settle) / source.length * 100.0,
	])
	var still_by: Array[String] = []
	for entry: Dictionary in _settle_detail:
		if float(entry["stops_at"]) > settle - 0.34:
			still_by.append("%s @ %.3f s" % [
				String(source.track_get_path(entry["track"]).get_concatenated_subnames()), entry["stops_at"],
			])
	print("  still moving late     %s" % ", ".join(still_by))
	if contact >= settle:
		_fail("the measured contact at %.4f s is not inside the moving part of the clip" % contact)
		_finish()
		return

	var retimed: Animation = _retime(source, contact, settle)
	_report_rates(source, contact, settle)
	_validate(skeleton, source, retimed, socket, tip_local, contact, settle)

	var library: AnimationLibrary = AnimationLibrary.new()
	library.add_animation(OUTPUT_CLIP, retimed)
	var error: Error = ResourceSaver.save(library, OUTPUT_PATH)
	if error != OK:
		_fail("could not save %s (error %d)" % [OUTPUT_PATH, error])
	else:
		print("")
		print("  wrote %s" % OUTPUT_PATH)
		print("  clip '%s': %.4f s, %d tracks, loop=%d" % [
			OUTPUT_CLIP, retimed.length, retimed.get_track_count(), retimed.loop_mode,
		])
	rig.free()
	_finish()


func _finish() -> void:
	print("")
	if _failures == 0:
		print("QUICK STRIKE ANIMATION BUILD: PASS")
		quit(0)
	else:
		printerr("QUICK STRIKE ANIMATION BUILD: %d FAILURE(S)" % _failures)
		quit(1)


func _fail(message: String) -> void:
	_failures += 1
	printerr("  FAIL: %s" % message)


func _load_source() -> Animation:
	var packed: PackedScene = load(SOURCE_GLB) as PackedScene
	if packed == null:
		_fail("cannot load %s" % SOURCE_GLB)
		return null
	var root: Node = packed.instantiate()
	var player: AnimationPlayer = _find_player(root)
	if player == null or not player.has_animation(SOURCE_CLIP):
		_fail("clip '%s' not found in %s" % [SOURCE_CLIP, SOURCE_GLB])
		root.free()
		return null
	var animation: Animation = (player.get_animation(SOURCE_CLIP) as Animation).duplicate(true)
	root.free()
	return animation


func _find_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node as AnimationPlayer
	for child: Node in node.get_children():
		var found: AnimationPlayer = _find_player(child)
		if found != null:
			return found
	return null


## Blade extent in weapon-local space. The starter sword sits on the socket at
## identity, so this is also its offset from the socket.
func _blade_tip() -> Vector3:
	var sword: Node3D = (load(SWORD_SCENE) as PackedScene).instantiate() as Node3D
	var far: Vector3 = Vector3.ZERO
	var stack: Array[Node] = [sword]
	while not stack.is_empty():
		var current: Node = stack.pop_back()
		for child: Node in current.get_children():
			stack.append(child)
		if current is MeshInstance3D:
			var instance: MeshInstance3D = current as MeshInstance3D
			var box: AABB = instance.mesh.get_aabb()
			var to_root: Transform3D = _relative_transform(sword, instance)
			for corner: int in 8:
				var point: Vector3 = to_root * box.get_endpoint(corner)
				if point.length() > far.length():
					far = point
	sword.free()
	return far


func _relative_transform(ancestor: Node3D, descendant: Node3D) -> Transform3D:
	var chain: Array[Node3D] = []
	var walker: Node = descendant
	while walker != null and walker != ancestor:
		if walker is Node3D:
			chain.append(walker as Node3D)
		walker = walker.get_parent()
	chain.reverse()
	var accumulated: Transform3D = Transform3D.IDENTITY
	for node: Node3D in chain:
		accumulated = accumulated * node.transform
	return accumulated


# --- Measurement -------------------------------------------------------------

## Samples the swing. The medium rig faces +Z at identity, so a tip angle of
## zero means the blade points straight down the character's facing.
func _measure_motion(
	sampler: AnimationBoneSampler, source: Animation, socket: int, tip_local: Vector3
) -> Array[Dictionary]:
	var rows: Array[Dictionary] = []
	for i: int in SAMPLES:
		var t: float = float(i) / float(SAMPLES - 1) * source.length
		var pose: Transform3D = sampler.bone_global_pose(socket, t)
		var tip: Vector3 = pose * tip_local
		rows.append({
			"t": t,
			"n": t / source.length,
			"socket": pose.origin,
			"tip": tip,
			"tip_angle": rad_to_deg(atan2(tip.x, tip.z)),
			"sweep": 0.0,
		})
	for i: int in range(1, rows.size()):
		var step: float = rows[i]["t"] - rows[i - 1]["t"]
		rows[i]["sweep"] = rad_to_deg(angle_difference(
			deg_to_rad(rows[i - 1]["tip_angle"]), deg_to_rad(rows[i]["tip_angle"]))) / step
	return rows


func _report_contact(rows: Array[Dictionary]) -> float:
	var fastest: int = 1
	for i: int in range(1, rows.size()):
		if absf(rows[i]["sweep"]) > absf(rows[fastest]["sweep"]):
			fastest = i
	var peak: float = absf(rows[fastest]["sweep"])

	# The contiguous run of samples still sweeping at half the peak rate IS the
	# strike; everything else is anticipation or follow-through.
	var first: int = fastest
	while first > 1 and absf(rows[first - 1]["sweep"]) > peak * 0.5:
		first -= 1
	var last: int = fastest
	while last < rows.size() - 1 and absf(rows[last + 1]["sweep"]) > peak * 0.5:
		last += 1

	var contact: float = -1.0
	var contact_index: int = -1
	for i: int in range(maxi(first, 1), last + 1):
		var a: float = rows[i - 1]["tip_angle"]
		var b: float = rows[i]["tip_angle"]
		if a == 0.0 or signf(a) == signf(b) or absf(a) > 100.0 or absf(b) > 100.0:
			continue
		var mix: float = absf(a) / maxf(absf(a) + absf(b), 0.000001)
		contact = lerpf(rows[i - 1]["t"], rows[i]["t"], mix)
		contact_index = i
		break

	var furthest: int = 0
	for i: int in rows.size():
		if rows[i]["tip"].z > rows[furthest]["tip"].z:
			furthest = i

	print("")
	print("--- Where the swing visibly connects")
	print("  fastest sweep         %.4f s  (n = %.4f) at %.0f deg/s" % [
		rows[fastest]["t"], rows[fastest]["n"], peak,
	])
	print("  strike window         %.4f .. %.4f s   (sweep above half the peak rate)" % [
		rows[first]["t"], rows[last]["t"],
	])
	if contact < 0.0:
		_fail("the blade tip never crosses the forward axis during the fastest sweep")
		return 0.0
	print("  tip crosses forward   %.4f s  (n = %.4f)  <-- CONTACT" % [contact, contact / rows[rows.size() - 1]["t"]])
	print("  reach at contact      %.3f m ahead of the body origin" % rows[contact_index]["tip"].z)
	print("  furthest forward      %.4f s  (n = %.4f) at %.3f m" % [
		rows[furthest]["t"], rows[furthest]["n"], rows[furthest]["tip"].z,
	])
	print("  the three signals agree to within %.4f s" % maxf(
		absf(rows[fastest]["t"] - contact), absf(rows[furthest]["t"] - contact)))
	return contact


## The last key at which any track still changes. Everything after it is a held
## pose that would otherwise eat part of the 0.80 s action. The measurement is
## shared with the Gate D attack build through `AnimationRetimer`.
func _measure_settle(source: Animation) -> float:
	var measured: Dictionary = AnimationRetimer.measure_settle(source)
	_settle_detail = measured["per_track"]
	_settle_track = measured["track"]
	return float(measured["settle"])


# --- Retiming ----------------------------------------------------------------

## Piecewise-linear time warp, shared with the Gate D attack build. Key poses are
## preserved exactly; only the time they are reached changes, so the anticipation
## and the follow-through can be paced independently without editing a pose.
func _warp(t: float, contact: float, settle: float) -> float:
	return AnimationRetimer.new(contact, settle, RELEASE_MARKER, OUTPUT_LENGTH).warp(t)


func _retime(source: Animation, contact: float, settle: float) -> Animation:
	return AnimationRetimer.new(contact, settle, RELEASE_MARKER, OUTPUT_LENGTH).retime(source, OUTPUT_CLIP)


func _report_rates(source: Animation, contact: float, settle: float) -> void:
	var action: float = 0.80
	var anticipation_rate: float = (contact / (RELEASE_MARKER * action))
	var follow_rate: float = ((settle - contact) / ((1.0 - RELEASE_MARKER) * action))
	print("")
	print("--- Retiming, against the locked 0.80 s action time")
	print("  release marker        %.4f of the clip  (0.26 s wind-up / 0.80 s action)" % RELEASE_MARKER)
	print("  measured contact was  %.4f of the source clip" % (contact / source.length))
	print("  anticipation          %.4f s authored -> %.4f s played  (%.3fx authored rate)" % [
		contact, RELEASE_MARKER * action, anticipation_rate,
	])
	print("  follow-through        %.4f s authored -> %.4f s played  (%.3fx authored rate)" % [
		settle - contact, (1.0 - RELEASE_MARKER) * action, follow_rate,
	])
	print("  playback speed_scale  %.4f at 0.80 s,  %.4f at 0.64 s" % [
		OUTPUT_LENGTH / 0.80, OUTPUT_LENGTH / 0.64,
	])


# --- Validation --------------------------------------------------------------

## The whole point of the retime is that the pose at the release marker is the
## pose that used to be at the measured contact. Prove it, do not assert it.
func _validate(
	skeleton: Skeleton3D, source: Animation, retimed: Animation,
	socket: int, tip_local: Vector3, contact: float, settle: float
) -> void:
	print("")
	print("--- Validation: the retimed clip preserves the swing")
	var before: AnimationBoneSampler = AnimationBoneSampler.new(skeleton, source)
	var after: AnimationBoneSampler = AnimationBoneSampler.new(skeleton, retimed)

	var probes: Array[float] = [0.0, contact * 0.5, contact, contact + (settle - contact) * 0.5, settle]
	var worst: float = 0.0
	for source_time: float in probes:
		var wanted: Vector3 = before.bone_global_pose(socket, source_time) * tip_local
		var got: Vector3 = after.bone_global_pose(socket, _warp(source_time, contact, settle)) * tip_local
		var error: float = wanted.distance_to(got)
		worst = maxf(worst, error)
		print("  source %.4f s -> retimed %.4f  blade tip (%.3f, %.3f, %.3f)  error %.5f m" % [
			source_time, _warp(source_time, contact, settle), got.x, got.y, got.z, error,
		])
		if error > 0.002:
			_fail("retimed pose at source time %.4f s differs by %.4f m" % [source_time, error])

	var marker_tip: Vector3 = after.bone_global_pose(socket, RELEASE_MARKER * OUTPUT_LENGTH) * tip_local
	var contact_tip: Vector3 = before.bone_global_pose(socket, contact) * tip_local
	print("  blade tip at the release marker: (%.3f, %.3f, %.3f), %.1f deg off forward, %.3f m ahead" % [
		marker_tip.x, marker_tip.y, marker_tip.z,
		rad_to_deg(atan2(marker_tip.x, marker_tip.z)), marker_tip.z,
	])
	if marker_tip.distance_to(contact_tip) > 0.002:
		_fail("the release marker does not land on the measured contact pose")
	if absf(rad_to_deg(atan2(marker_tip.x, marker_tip.z))) > 5.0:
		_fail("the blade is not pointing forward at the release marker")
	print("  worst pose error across the clip: %.5f m" % worst)


func _print_table(rows: Array[Dictionary]) -> void:
	print("")
	print("   n        t     socket x      z      tip x      z    tip ang   sweep deg/s")
	for i: int in rows.size():
		if i % 10 != 0:
			continue
		print("%6.4f %7.4f %9.3f %6.3f %9.3f %6.3f %9.1f %11.0f" % [
			rows[i]["n"], rows[i]["t"], rows[i]["socket"].x, rows[i]["socket"].z,
			rows[i]["tip"].x, rows[i]["tip"].z, rows[i]["tip_angle"], rows[i]["sweep"],
		])
