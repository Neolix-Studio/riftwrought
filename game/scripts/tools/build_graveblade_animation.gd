extends SceneTree
## Prototype Zero — Gate D: compare the two candidate Graveblade attack clips and
## build the local editable copy of the chosen one.
##
## Decision D-181 sets the task exactly:
##
##   "Compare `Melee_1H_Attack_Chop` and `Melee_1H_Attack_Slice_Horizontal` in the
##    real Graveblade approach and attack context. Prefer Chop because it should
##    provide a distinct enemy silhouette from the player's horizontal Quick
##    Strike, but only if measured Skeleton Blade motion supports the locked
##    anticipation, release, reach, and readable contact. Measure both candidate
##    release poses and document the comparison."
##
## So this tool measures BOTH clips on the Skeleton Warrior rig carrying the
## registered Skeleton Blade, prints the comparison, applies the stated
## acceptance criteria to the preferred clip, and only then writes the retimed
## local copy. If the preferred clip cannot support the locked contract it fails
## loudly with the numbers rather than quietly retiming a dishonest contact or
## quietly changing the combat contract.
##
## WHY THE CONTACT DEFINITION IS NOT THE GATE C ONE
##
## Gate C defined Quick Strike's visible contact as "the blade tip crosses the
## character's forward axis during the fastest sweep". That is exactly right for
## a horizontal slice and meaningless for an overhead chop, whose tip sweeps in
## the vertical plane and may never cross the forward axis at all. Using it here
## would have decided the comparison by the shape of the definition rather than
## by the motion.
##
## The definition used instead works for either silhouette and is closer to the
## physical question anyway:
##
##   Model the victim as the same capsule the player actually has — 0.80 m across,
##   1.80 m tall — standing `preferred_attack_distance` straight ahead. Model the
##   weapon as its ACTUAL MESH: every vertex of the imported Skeleton_Blade, plus
##   the midpoint of every triangle edge so a long low-poly edge cannot slip past
##   the capsule between two vertices. The visible contact is the moment of
##   DEEPEST penetration of that weapon into that capsule, taken inside the clip's
##   fastest sweep.
##
## The mesh rather than a centreline matters: a chop that comes down beside the
## body would still graze it with the flat of the blade, and the decision must
## not turn on which simplification was picked.
##
## Both Gate C signals are still measured and printed for both clips, so the
## comparison can be read against the Quick Strike record rather than only
## against itself.
##
## Regenerate with:
##   godot --headless --path game --script res://scripts/tools/build_graveblade_animation.gd
## Add `-- --table` for the per-sample measurement table of the chosen clip.

const SOURCE_GLB: String = "res://assets/third_party/kaykit/animations/Rig_Medium_CombatMelee.glb"
const RIG_SCENE: String = "res://scenes/actors/graveblade_rig.tscn"
const SKELETON_PATH: String = "Skeleton_Warrior/Rig_Medium/Skeleton3D"
const WEAPON_SCENE: String = "res://assets/third_party/kaykit/skeleton/Skeleton_Blade.gltf"
const OUTPUT_PATH: String = "res://assets/prototype/animation/graveblade_prototype_animation.res"
const OUTPUT_CLIP: StringName = &"Graveblade_Attack"
const SOCKET_BONE: StringName = &"handslot.r"

## D-181's candidates, preferred first.
const PREFERRED_CLIP: StringName = &"Melee_1H_Attack_Chop"
const ALTERNATIVE_CLIP: StringName = &"Melee_1H_Attack_Slice_Horizontal"

## The locked Gate D attack contract (D-181). Kept here as literals rather than
## read from graveblade.tres, so the tool and the data record cross-check each
## other instead of agreeing by construction; `gate_d_verification.gd` asserts the
## resource against the same numbers.
const ANTICIPATION: float = 0.55
const RELEASE_WINDOW: float = 0.08
const RECOVERY: float = 0.62
const ACTION_TIME: float = ANTICIPATION + RELEASE_WINDOW + RECOVERY  ## 1.25 s
const RELEASE_MARKER: float = ANTICIPATION / ACTION_TIME             ## 0.44
const ATTACK_REACH: float = 1.65
const PREFERRED_DISTANCE: float = 1.40

## The victim capsule: the player's own collision shape, 0.80 m across and 1.80 m
## tall, so "would this swing hit a body standing there" means the same thing
## here as it does in the physics world.
const VICTIM_RADIUS: float = 0.40
const VICTIM_HEIGHT: float = 1.80
## A deliberately over-generous victim, 25% wider than the player, used only to
## show that a rejection is not an artefact of the capsule model.
const GENEROUS_RADIUS: float = 0.50

## The retimed copy is normalised to one second so clip time reads directly as
## normalised action time, exactly as the Quick Strike copy does.
const OUTPUT_LENGTH: float = 1.0
const SAMPLES: int = 1067

var _failures: int = 0


func _initialize() -> void:
	print("=== Riftwrought Gate D — Graveblade attack animation build ===")
	var show_table: bool = OS.get_cmdline_user_args().has("--table")

	var rig: Node3D = (load(RIG_SCENE) as PackedScene).instantiate() as Node3D
	var skeleton: Skeleton3D = rig.get_node(SKELETON_PATH) as Skeleton3D
	var socket: int = skeleton.find_bone(SOCKET_BONE)
	var blade: Dictionary = _blade_geometry()
	var tip_local: Vector3 = blade["centreline"]
	var corner_local: Vector3 = blade["corner"]
	var blade_points: PackedVector3Array = blade["points"]

	print("")
	print("--- Body and weapon (registered KayKit, measured not assumed)")
	print("  body                  Skeleton_Warrior.glb")
	print("  weapon                Skeleton_Blade.gltf")
	print("  socket bone           %s (index %d on the Skeleton Warrior)" % [SOCKET_BONE, socket])
	print("  blade bounding box    %s to %s in socket space" % [
		str((blade["aabb"] as AABB).position), str((blade["aabb"] as AABB).end),
	])
	print("  tip, AABB corner      (%.3f, %.3f, %.3f), %.3f m from the socket   (the Gate C method)" % [
		corner_local.x, corner_local.y, corner_local.z, corner_local.length(),
	])
	print("  tip, blade centreline (%.3f, %.3f, %.3f), %.3f m from the socket   (tracked below)" % [
		tip_local.x, tip_local.y, tip_local.z, tip_local.length(),
	])
	print("  weapon test points    %d  (every mesh vertex plus every triangle-edge midpoint)" % blade_points.size())
	print("  victim modelled as    the player capsule: %.2f m across, %.2f m tall, %.2f m ahead" % [
		VICTIM_RADIUS * 2.0, VICTIM_HEIGHT, PREFERRED_DISTANCE,
	])

	var candidates: Array[Dictionary] = []
	for clip_name: StringName in [PREFERRED_CLIP, ALTERNATIVE_CLIP]:
		var source: Animation = _load_clip(clip_name)
		if source == null:
			continue
		candidates.append(_measure_candidate(skeleton, source, clip_name, socket, tip_local, blade_points))

	if candidates.size() != 2:
		_fail("both candidate clips are required for the D-181 comparison")
		rig.free()
		_finish()
		return

	_print_comparison(candidates)

	# D-181's preference is applied first and only its OWN criteria decide it.
	# When the preferred clip fails, the fallback is the other clip specification
	# §6.3 already names for this attack — never a changed reach, arc, or timing.
	# Selecting between two approved clips is the choice §6.3 left open;
	# rewriting the locked contract to rescue a clip is not.
	var chosen: Dictionary = candidates[0]
	if not _judge(candidates[0], candidates[1]):
		printerr("")
		printerr("  FALLING BACK to the specification §6.3 alternative, %s." % candidates[1]["name"])
		printerr("  The locked contract is UNCHANGED: %.2f m reach, %.2f s anticipation," % [
			ATTACK_REACH, ANTICIPATION,
		])
		printerr("  %.2f s release window, %.2f s recovery. Only the clip choice moved." % [
			RELEASE_WINDOW, RECOVERY,
		])
		printerr("  This costs the distinct enemy silhouette D-181 wanted and is a FEEL")
		printerr("  QUESTION FOR THE PROJECT OWNER, recorded in the Gate D report.")
		printerr("")
		_failures -= 1  ## the preferred clip's rejection is reported, not a build failure
		if not _judge(candidates[1], candidates[0]):
			rig.free()
			_finish()
			return
		chosen = candidates[1]

	if show_table:
		_print_table(chosen["rows"])

	var source: Animation = chosen["animation"]
	var contact: float = float(chosen["contact_time"])
	var settle: float = float(chosen["settle"])
	var retimer: AnimationRetimer = AnimationRetimer.new(contact, settle, RELEASE_MARKER, OUTPUT_LENGTH)
	var retimed: Animation = retimer.retime(source, OUTPUT_CLIP)
	_report_rates(chosen, retimer)
	_validate(skeleton, source, retimed, socket, tip_local, blade_points, chosen, retimer)

	var library: AnimationLibrary = AnimationLibrary.new()
	library.add_animation(OUTPUT_CLIP, retimed)
	var error: Error = ResourceSaver.save(library, OUTPUT_PATH)
	if error != OK:
		_fail("could not save %s (error %d)" % [OUTPUT_PATH, error])
	else:
		print("")
		print("  wrote %s" % OUTPUT_PATH)
		print("  clip '%s': %.4f s, %d tracks, loop=%d   (retimed from %s)" % [
			OUTPUT_CLIP, retimed.length, retimed.get_track_count(), retimed.loop_mode, chosen["name"],
		])
	rig.free()
	_finish()


func _finish() -> void:
	print("")
	if _failures == 0:
		print("GRAVEBLADE ANIMATION BUILD: PASS")
		quit(0)
	else:
		printerr("GRAVEBLADE ANIMATION BUILD: %d FAILURE(S)" % _failures)
		quit(1)


func _fail(message: String) -> void:
	_failures += 1
	printerr("  FAIL: %s" % message)


# --- Sources -----------------------------------------------------------------

func _load_clip(clip_name: StringName) -> Animation:
	var packed: PackedScene = load(SOURCE_GLB) as PackedScene
	if packed == null:
		_fail("cannot load %s" % SOURCE_GLB)
		return null
	var root: Node = packed.instantiate()
	var player: AnimationPlayer = _find_player(root)
	if player == null or not player.has_animation(clip_name):
		_fail("clip '%s' not found in %s" % [clip_name, SOURCE_GLB])
		root.free()
		return null
	var animation: Animation = (player.get_animation(clip_name) as Animation).duplicate(true)
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


## Blade geometry in weapon-local space. The Skeleton Blade sits on the socket at
## identity, so these are also offsets from the socket.
##
## Returns three things:
##
##   `corner`     the furthest mesh-AABB corner from the socket, which is what
##                the Gate C tool uses for the player's sword. For a HORIZONTAL
##                sweep its lateral error is tangential to the motion, so the
##                contact instant barely moves. For a vertical chop it is 0.29 m
##                out to the side of the actual blade, because the AABB is as
##                wide as the crossguard for its whole length — and lateral
##                offset is exactly the quantity a chop is judged on.
##   `centreline` the centre of the far face along the blade's long axis. Used as
##                the single representative point for speed, silhouette, and
##                forward reach, where one consistent point is what is wanted.
##   `points`     every mesh vertex plus every triangle-edge midpoint. Used for
##                the capsule test, so "does this swing hit a body standing
##                there" is answered by the weapon's real geometry rather than by
##                a chosen simplification.
func _blade_geometry() -> Dictionary:
	var weapon: Node3D = (load(WEAPON_SCENE) as PackedScene).instantiate() as Node3D
	var corner: Vector3 = Vector3.ZERO
	var union: AABB = AABB()
	var seen: bool = false
	var points: PackedVector3Array = PackedVector3Array()
	var stack: Array[Node] = [weapon]
	while not stack.is_empty():
		var current: Node = stack.pop_back()
		for child: Node in current.get_children():
			stack.append(child)
		if current is MeshInstance3D:
			var instance: MeshInstance3D = current as MeshInstance3D
			var to_root: Transform3D = _relative_transform(weapon, instance)
			var box: AABB = to_root * instance.mesh.get_aabb()
			union = box if not seen else union.merge(box)
			seen = true
			for index: int in 8:
				var endpoint: Vector3 = box.get_endpoint(index)
				if endpoint.length() > corner.length():
					corner = endpoint
			_collect_points(instance.mesh, to_root, points)
	weapon.free()

	# The blade's long axis is whichever axis of its bounding box is longest.
	var size: Vector3 = union.size
	var axis: int = 0
	if size.y > size[axis]:
		axis = 1
	if size.z > size[axis]:
		axis = 2
	var centreline: Vector3 = union.get_center()
	centreline[axis] = union.end[axis] if absf(union.end[axis]) > absf(union.position[axis]) else union.position[axis]
	return {"corner": corner, "centreline": centreline, "aabb": union, "axis": axis, "points": points}


func _collect_points(mesh: Mesh, to_root: Transform3D, into: PackedVector3Array) -> void:
	for surface: int in mesh.get_surface_count():
		var arrays: Array = mesh.surface_get_arrays(surface)
		var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
		for vertex: Vector3 in vertices:
			into.append(to_root * vertex)
		var indices: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
		if indices.is_empty():
			continue
		# Edge midpoints, so a long low-poly edge cannot pass through the capsule
		# between two vertices that both sit outside it.
		var seen_edges: Dictionary = {}
		for triangle: int in indices.size() / 3:
			var a: int = indices[triangle * 3]
			var b: int = indices[triangle * 3 + 1]
			var c: int = indices[triangle * 3 + 2]
			for edge: Array in [[a, b], [b, c], [c, a]]:
				var key: int = mini(edge[0], edge[1]) * 100000 + maxi(edge[0], edge[1])
				if seen_edges.has(key):
					continue
				seen_edges[key] = true
				into.append(to_root * ((vertices[edge[0]] + vertices[edge[1]]) * 0.5))


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

## Everything the D-181 comparison needs about one candidate clip. The medium rig
## faces +Z at identity (SOURCE_AND_LICENSE.md §3.6), so +Z here is "ahead".
func _measure_candidate(
	skeleton: Skeleton3D, source: Animation, clip_name: StringName, socket: int,
	tip_local: Vector3, blade_points: PackedVector3Array
) -> Dictionary:
	var sampler: AnimationBoneSampler = AnimationBoneSampler.new(skeleton, source)
	var rows: Array[Dictionary] = []
	for i: int in SAMPLES:
		var t: float = float(i) / float(SAMPLES - 1) * source.length
		var pose: Transform3D = sampler.bone_global_pose(socket, t)
		var tip: Vector3 = pose * tip_local
		rows.append({
			"t": t,
			"n": t / source.length,
			"grip": pose.origin,
			"tip": tip,
			"tip_angle": rad_to_deg(atan2(tip.x, tip.z)),
			"speed": 0.0,
			"penetration": _penetration(pose, blade_points, PREFERRED_DISTANCE),
		})
	for i: int in range(1, rows.size()):
		var step: float = float(rows[i]["t"]) - float(rows[i - 1]["t"])
		rows[i]["speed"] = (rows[i]["tip"] as Vector3).distance_to(rows[i - 1]["tip"]) / maxf(step, 0.000001)
	rows[0]["speed"] = rows[1]["speed"]

	# The strike is the contiguous run of samples still moving at half the peak
	# tip speed. Everything before it is anticipation, everything after is
	# follow-through.
	var fastest: int = 0
	for i: int in rows.size():
		if float(rows[i]["speed"]) > float(rows[fastest]["speed"]):
			fastest = i
	var peak: float = float(rows[fastest]["speed"])
	var first: int = fastest
	while first > 0 and float(rows[first - 1]["speed"]) > peak * 0.5:
		first -= 1
	var last: int = fastest
	while last < rows.size() - 1 and float(rows[last + 1]["speed"]) > peak * 0.5:
		last += 1

	# Contact: deepest penetration of the blade into the victim capsule, inside
	# the strike window.
	var contact_index: int = first
	for i: int in range(first, last + 1):
		if float(rows[i]["penetration"]) > float(rows[contact_index]["penetration"]):
			contact_index = i

	# The Gate C signals, measured for both clips so the two records compare.
	var crossing: float = -1.0
	for i: int in range(maxi(first, 1), last + 1):
		var a: float = float(rows[i - 1]["tip_angle"])
		var b: float = float(rows[i]["tip_angle"])
		if a == 0.0 or signf(a) == signf(b) or absf(a) > 100.0 or absf(b) > 100.0:
			continue
		crossing = lerpf(float(rows[i - 1]["t"]), float(rows[i]["t"]), absf(a) / maxf(absf(a) + absf(b), 0.000001))
		break
	var furthest: int = 0
	for i: int in rows.size():
		if (rows[i]["tip"] as Vector3).z > (rows[furthest]["tip"] as Vector3).z:
			furthest = i

	# Silhouette: how much of the strike's tip travel is vertical against
	# horizontal. A chop should be dominated by vertical travel and the player's
	# horizontal slice by horizontal travel; that difference IS the readability
	# argument D-181 makes for preferring Chop.
	var vertical: float = 0.0
	var horizontal: float = 0.0
	for i: int in range(first + 1, last + 1):
		var step_vector: Vector3 = (rows[i]["tip"] as Vector3) - (rows[i - 1]["tip"] as Vector3)
		vertical += absf(step_vector.y)
		horizontal += Vector2(step_vector.x, step_vector.z).length()

	var settle: Dictionary = AnimationRetimer.measure_settle(source)
	return {
		"name": String(clip_name),
		"animation": source,
		"rows": rows,
		"length": source.length,
		"peak_speed": peak,
		"peak_time": rows[fastest]["t"],
		"strike_from": rows[first]["t"],
		"strike_to": rows[last]["t"],
		"strike_first": first,
		"strike_last": last,
		"contact_time": rows[contact_index]["t"],
		"contact_normalized": rows[contact_index]["n"],
		"contact_penetration": rows[contact_index]["penetration"],
		"contact_tip": rows[contact_index]["tip"],
		"contact_forward": (rows[contact_index]["tip"] as Vector3).z,
		"contact_height": (rows[contact_index]["tip"] as Vector3).y,
		"maximum_contact_distance": _maximum_contact_distance(sampler, socket, blade_points, rows, first, last),
		"minimum_lateral_miss": _minimum_lateral_miss(sampler, socket, blade_points, rows, first, last),
		# The same reach question asked of a deliberately GENEROUS victim, 25%
		# wider than the player actually is. A clip that still cannot reach the
		# locked distance against this cannot be argued into working by quibbling
		# with the capsule model.
		"generous_contact_distance": _maximum_contact_distance(
			sampler, socket, blade_points, rows, first, last, GENEROUS_RADIUS),
		"forward_axis_crossing": crossing,
		"furthest_forward_time": rows[furthest]["t"],
		"furthest_forward": (rows[furthest]["tip"] as Vector3).z,
		"vertical_travel": vertical,
		"horizontal_travel": horizontal,
		"settle": settle["settle"],
		"settle_track": settle["track"],
	}


## How far the weapon penetrates a victim capsule standing `distance` straight
## ahead, at this instant. Negative means it does not reach.
##
## The capsule's spine is the vertical segment from y = radius to y = height -
## radius at (0, ., distance); a point is inside when it is within `radius` of
## that spine, which is exactly what the physics capsule means.
func _penetration(socket_pose: Transform3D, points: PackedVector3Array, distance: float) -> float:
	var nearest: float = INF
	for point: Vector3 in points:
		var world: Vector3 = socket_pose * point
		var spine_y: float = clampf(world.y, VICTIM_RADIUS, VICTIM_HEIGHT - VICTIM_RADIUS)
		nearest = minf(nearest, Vector3(world.x, world.y - spine_y, world.z - distance).length())
	return VICTIM_RADIUS - nearest


## The largest distance at which this swing would still touch a player-sized
## body. This is the honest answer to "does the clip support the locked reach?",
## because the mechanical reach is measured centre-to-centre exactly as this is.
##
## Closed form rather than a scan: a weapon point p can reach a victim centred at
## (0, ., d) when its lateral miss (its x, plus any vertical overshoot past the
## spine's ends) is inside the radius, and the furthest such d is
## p.z + sqrt(radius^2 - lateral^2).
func _maximum_contact_distance(
	sampler: AnimationBoneSampler, socket: int, points: PackedVector3Array,
	rows: Array[Dictionary], first: int, last: int, radius: float = VICTIM_RADIUS
) -> float:
	var best: float = 0.0
	for i: int in range(first, last + 1):
		var pose: Transform3D = sampler.bone_global_pose(socket, float(rows[i]["t"]))
		for point: Vector3 in points:
			var world: Vector3 = pose * point
			var spine_y: float = clampf(world.y, VICTIM_RADIUS, VICTIM_HEIGHT - VICTIM_RADIUS)
			var lateral: float = Vector2(world.x, world.y - spine_y).length()
			if lateral > radius:
				continue
			best = maxf(best, world.z + sqrt(radius * radius - lateral * lateral))
	return best


## How close the weapon ever gets to the character's own forward axis during the
## strike, measured sideways at the victim's spine height. Against the 0.40 m
## capsule radius this one number decides whether a swing can connect with a body
## standing dead ahead AT ALL, at any distance — which is precisely the question
## an overhead one-handed chop can fail.
func _minimum_lateral_miss(
	sampler: AnimationBoneSampler, socket: int, points: PackedVector3Array,
	rows: Array[Dictionary], first: int, last: int
) -> float:
	var closest: float = INF
	for i: int in range(first, last + 1):
		var pose: Transform3D = sampler.bone_global_pose(socket, float(rows[i]["t"]))
		for point: Vector3 in points:
			var world: Vector3 = pose * point
			var spine_y: float = clampf(world.y, VICTIM_RADIUS, VICTIM_HEIGHT - VICTIM_RADIUS)
			closest = minf(closest, Vector2(world.x, world.y - spine_y).length())
	return closest


# --- Reporting ---------------------------------------------------------------

func _print_comparison(candidates: Array[Dictionary]) -> void:
	print("")
	print("--- D-181 candidate comparison, both measured on the Skeleton Warrior")
	var labels: Array[Array] = [
		["clip length, s", "length", "%9.4f"],
		["peak blade-tip speed, m/s", "peak_speed", "%9.2f"],
		["peak speed at, s", "peak_time", "%9.4f"],
		["strike window from, s", "strike_from", "%9.4f"],
		["strike window to, s", "strike_to", "%9.4f"],
		["CONTACT at, s", "contact_time", "%9.4f"],
		["CONTACT normalised", "contact_normalized", "%9.4f"],
		["penetration at contact, m", "contact_penetration", "%9.4f"],
		["blade tip forward at contact, m", "contact_forward", "%9.3f"],
		["blade tip height at contact, m", "contact_height", "%9.3f"],
		["maximum contact distance, m", "maximum_contact_distance", "%9.3f"],
		["closest lateral miss, m", "minimum_lateral_miss", "%9.3f"],
		["reach vs a 25% wider victim, m", "generous_contact_distance", "%9.3f"],
		["tip crosses forward axis at, s", "forward_axis_crossing", "%9.4f"],
		["furthest forward tip, m", "furthest_forward", "%9.3f"],
		["strike vertical travel, m", "vertical_travel", "%9.3f"],
		["strike horizontal travel, m", "horizontal_travel", "%9.3f"],
		["authored motion stops at, s", "settle", "%9.4f"],
	]
	print("  %-33s %-24s %-24s" % ["", candidates[0]["name"], candidates[1]["name"]])
	for label: Array in labels:
		var format: String = "  %-33s " + label[2] + "               " + label[2]
		print(format % [label[0], candidates[0][label[1]], candidates[1][label[1]]])
	for candidate: Dictionary in candidates:
		var vertical: float = float(candidate["vertical_travel"])
		var horizontal: float = float(candidate["horizontal_travel"])
		print("  %-33s %s" % [
			"silhouette of %s" % candidate["name"],
			"%.0f%% vertical / %.0f%% horizontal tip travel across the strike" % [
				vertical / maxf(vertical + horizontal, 0.0001) * 100.0,
				horizontal / maxf(vertical + horizontal, 0.0001) * 100.0,
			],
		])


## D-181's acceptance criteria. "Prefer Chop ... but only if measured Skeleton
## Blade motion supports the locked anticipation, release, reach, and readable
## contact."
##
## Those four are the HARD criteria and they are all that decides acceptance. The
## distinct silhouette is D-181's REASON for preferring Chop, not a requirement a
## clip must meet, so it is measured and reported but never rejects a clip — if
## it did, the fallback could not be judged at all.
func _judge(candidate: Dictionary, other: Dictionary) -> bool:
	print("")
	print("--- Applying the D-181 acceptance criteria to %s" % candidate["name"])
	var reasons: PackedStringArray = PackedStringArray()

	# 1. Reach. The mechanical reach may never claim more than the picture shows.
	var reach_ok: bool = float(candidate["maximum_contact_distance"]) >= ATTACK_REACH
	print("  reach                 touches a player-sized body out to %.3f m, against the locked %.2f m  -> %s" % [
		candidate["maximum_contact_distance"], ATTACK_REACH, "OK" if reach_ok else "FAILS",
	])
	if not reach_ok:
		reasons.append("its swing reaches %.3f m against the locked %.2f m attack reach" % [
			candidate["maximum_contact_distance"], ATTACK_REACH,
		])

	# 2. Honest contact. The weapon must genuinely be inside the victim at the
	# instant the release query runs, not merely near it.
	var contact_ok: bool = float(candidate["contact_penetration"]) > 0.0
	print("  contact               %.3f m INSIDE the victim capsule at the contact instant  -> %s" % [
		candidate["contact_penetration"], "OK" if contact_ok else "FAILS",
	])
	print("  closest lateral miss  %.3f m from the character's own forward axis, against the %.2f m capsule radius" % [
		candidate["minimum_lateral_miss"], VICTIM_RADIUS,
	])
	print("  same, generous victim %.3f m reach against a victim 25%% wider than the player (%.2f m radius)" % [
		candidate["generous_contact_distance"], GENEROUS_RADIUS,
	])
	if not contact_ok:
		reasons.append(
			"the weapon never enters a body standing on the forward axis: its closest lateral approach is %.3f m, %.3f m outside the %.2f m capsule" % [
				candidate["minimum_lateral_miss"],
				float(candidate["minimum_lateral_miss"]) - VICTIM_RADIUS, VICTIM_RADIUS,
			])
		if float(candidate["generous_contact_distance"]) < ATTACK_REACH:
			reasons.append(
				"and the rejection is not a modelling artefact: against a victim 25%% wider than the player it still only reaches %.3f m of the locked %.2f m" % [
					candidate["generous_contact_distance"], ATTACK_REACH,
				])

	# 3. The contact must sit inside the moving part of the clip, or the retime
	# has nothing to warp.
	var inside_ok: bool = float(candidate["contact_time"]) < float(candidate["settle"])
	print("  retimeable            contact %.4f s sits inside authored motion ending %.4f s  -> %s" % [
		candidate["contact_time"], candidate["settle"], "OK" if inside_ok else "FAILS",
	])
	if not inside_ok:
		reasons.append("the contact is not inside the moving part of the clip")

	# 4. Readable anticipation. The 0.55 s wind-up is the whole point of a
	# telegraphed enemy attack, so the authored anticipation must not have to be
	# stretched or crushed beyond recognition to fill it.
	var anticipation_rate: float = float(candidate["contact_time"]) / ANTICIPATION
	var anticipation_ok: bool = anticipation_rate >= 0.35 and anticipation_rate <= 2.0
	print("  anticipation          %.4f s authored -> %.2f s played  (%.3fx authored rate)  -> %s" % [
		candidate["contact_time"], ANTICIPATION, anticipation_rate, "OK" if anticipation_ok else "FAILS",
	])
	if not anticipation_ok:
		reasons.append("filling the locked %.2f s anticipation would play the authored wind-up at %.2fx" % [
			ANTICIPATION, anticipation_rate,
		])

	# Reported, never rejected on: this is the REASON D-181 prefers Chop, so it is
	# measured rather than asserted.
	var mine: float = _vertical_share(candidate)
	var theirs: float = _vertical_share(other)
	print("  silhouette            %.0f%% vertical against %s at %.0f%%  -> %s" % [
		mine * 100.0, other["name"], theirs * 100.0,
		"distinct" if mine > theirs + 0.10 else "NOT distinct (reported, not a rejection)",
	])

	if reasons.is_empty():
		print("  VERDICT               %s accepted for the Graveblade" % candidate["name"])
		return true

	printerr("")
	printerr("  VERDICT: %s CANNOT support the locked Gate D contract." % candidate["name"])
	for reason: String in reasons:
		printerr("    - %s" % reason)
	printerr("  For comparison %s measures: reach %.3f m, penetration %.3f m, lateral miss %.3f m." % [
		other["name"], other["maximum_contact_distance"],
		other["contact_penetration"], other["minimum_lateral_miss"],
	])
	_failures += 1
	return false


func _vertical_share(candidate: Dictionary) -> float:
	var vertical: float = float(candidate["vertical_travel"])
	var horizontal: float = float(candidate["horizontal_travel"])
	return vertical / maxf(vertical + horizontal, 0.0001)


func _report_rates(chosen: Dictionary, _retimer: AnimationRetimer) -> void:
	var contact: float = float(chosen["contact_time"])
	var settle: float = float(chosen["settle"])
	print("")
	print("--- Retiming %s against the locked %.2f s Graveblade action" % [chosen["name"], ACTION_TIME])
	print("  release marker        %.4f of the clip  (%.2f s anticipation / %.2f s action)" % [
		RELEASE_MARKER, ANTICIPATION, ACTION_TIME,
	])
	print("  measured contact was  %.4f of the source clip" % float(chosen["contact_normalized"]))
	print("  anticipation          %.4f s authored -> %.4f s played  (%.3fx authored rate)" % [
		contact, ANTICIPATION, contact / ANTICIPATION,
	])
	print("  follow-through        %.4f s authored -> %.4f s played  (%.3fx authored rate)" % [
		settle - contact, (1.0 - RELEASE_MARKER) * ACTION_TIME,
		(settle - contact) / ((1.0 - RELEASE_MARKER) * ACTION_TIME),
	])
	print("  playback speed_scale  %.4f at the locked %.2f s action" % [OUTPUT_LENGTH / ACTION_TIME, ACTION_TIME])


# --- Validation --------------------------------------------------------------

## The whole point of the retime is that the pose at the release marker is the
## pose that used to be at the measured contact. Prove it, do not assert it.
func _validate(
	skeleton: Skeleton3D, source: Animation, retimed: Animation, socket: int,
	tip_local: Vector3, blade_points: PackedVector3Array,
	chosen: Dictionary, retimer: AnimationRetimer
) -> void:
	print("")
	print("--- Validation: the retimed clip preserves the swing")
	var contact: float = float(chosen["contact_time"])
	var settle: float = float(chosen["settle"])
	var before: AnimationBoneSampler = AnimationBoneSampler.new(skeleton, source)
	var after: AnimationBoneSampler = AnimationBoneSampler.new(skeleton, retimed)

	var probes: Array[float] = [0.0, contact * 0.5, contact, contact + (settle - contact) * 0.5, settle]
	var worst: float = 0.0
	for source_time: float in probes:
		var wanted: Vector3 = before.bone_global_pose(socket, source_time) * tip_local
		var got: Vector3 = after.bone_global_pose(socket, retimer.warp(source_time)) * tip_local
		var error: float = wanted.distance_to(got)
		worst = maxf(worst, error)
		print("  source %.4f s -> retimed %.4f  blade tip (%.3f, %.3f, %.3f)  error %.5f m" % [
			source_time, retimer.warp(source_time), got.x, got.y, got.z, error,
		])
		if error > 0.002:
			_fail("retimed pose at source time %.4f s differs by %.4f m" % [source_time, error])

	var marker_pose: Transform3D = after.bone_global_pose(socket, RELEASE_MARKER * OUTPUT_LENGTH)
	var marker_tip: Vector3 = marker_pose * tip_local
	var contact_tip: Vector3 = before.bone_global_pose(socket, contact) * tip_local
	var penetration: float = _penetration(marker_pose, blade_points, PREFERRED_DISTANCE)
	print("  blade tip at the release marker: (%.3f, %.3f, %.3f), %.3f m ahead, %.3f m high" % [
		marker_tip.x, marker_tip.y, marker_tip.z, marker_tip.z, marker_tip.y,
	])
	print("  at the marker the blade is %.3f m inside a body standing %.2f m ahead" % [
		penetration, PREFERRED_DISTANCE,
	])
	if marker_tip.distance_to(contact_tip) > 0.002:
		_fail("the release marker does not land on the measured contact pose")
	if penetration <= 0.0:
		_fail("the release marker pose does not visibly connect with the victim")
	print("  worst pose error across the clip: %.5f m" % worst)


func _print_table(rows: Array[Dictionary]) -> void:
	print("")
	print("   n        t      tip x      y      z    tip ang   speed m/s   penetration")
	for i: int in rows.size():
		if i % 10 != 0:
			continue
		print("%6.4f %7.4f %9.3f %6.3f %6.3f %9.1f %11.2f %13.4f" % [
			rows[i]["n"], rows[i]["t"], (rows[i]["tip"] as Vector3).x, (rows[i]["tip"] as Vector3).y,
			(rows[i]["tip"] as Vector3).z, rows[i]["tip_angle"], rows[i]["speed"], rows[i]["penetration"],
		])
