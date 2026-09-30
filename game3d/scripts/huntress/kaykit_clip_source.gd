class_name KayKitClipSource
extends RefCounted

## ============================================================================
## PORTED UNDER D-392 FROM THE ACCEPTED D-388 SPIKE -- TEMPORARY PLACEHOLDER.
## ============================================================================
## Source: game3d_huntress_spike/scripts/spike/kaykit_clip_source.gd, accepted under D-389 as
## PROTOTYPE FEASIBILITY EVIDENCE ("viable for prototype only"). The owner's
## D-392 ruling: "The CC0 KayKit bow clips and the D-388 retarget/hand-contact
## approach may be ported only as explicitly temporary placeholder animation.
## Preserve provenance. Do not present them as final production animation or fix
## the five accepted polish debts." NOTHING here is final animation. The spike
## itself is NOT edited and NOT referenced at runtime: this is a copy, adapted as
## stated below, and every value it reads lives in HuntressConfig.
## ADAPTED: it reads HuntressConfig, and it authorizes FIVE clips (the spike authorized seven;
## the two `_Up` clips are not needed on a planar simulation and are REFUSED here).
## (The paragraphs below are the spike's own documentation, kept as provenance;
## where they say "the spike" they mean the source this was ported from.)

## THE SOURCE: the KayKit 23-joint rig and the SEVEN authorized bow clips.
##
## ============================================================================
## SOURCE DATA IS READ, NEVER WRITTEN.
## ============================================================================
## The owner's ruling: "Do not edit animation source data destructively." Every
## pose is read through `Animation.*_track_interpolate`, and the suite checksums
## the seven clips' key data at start and end (A-13).
##
## ============================================================================
## ONLY THE AUTHORIZED CLIPS MAY BE SAMPLED (FIVE HERE; SEVEN IN THE SPIKE). THE
## REST ARE PRESENT AND REFUSED.
## ============================================================================
## The two imported files hold 33 clips (T-Pose is in both). A request for any
## clip outside `HuntressConfig.AUTHORIZED_CLIPS` is REFUSED and counted (I-06).
##
## ============================================================================
## THE EMBEDDED KAYKIT MANNEQUIN NEVER ENTERS THE SCENE.
## ============================================================================
## Each animation file carries a six-part mannequin. The files are instantiated
## OFF-TREE, read, and freed; only their skeleton's rest data and the seven
## Animation resources are kept (I-07).

var bone_names: Array[String] = []
var parent: PackedInt32Array = PackedInt32Array()
var rest: Array[Transform3D] = []          ## local rest, per source bone
var rest_global: Array[Transform3D] = []   ## model-space rest
var order: PackedInt32Array = PackedInt32Array()   ## parents before children
var index_of: Dictionary = {}              ## name -> index

## clip name -> Animation (only the seven authorized)
var clips: Dictionary = {}
## clip name -> {bone_idx: [pos_track, rot_track, scl_track]}
var _tracks: Dictionary = {}
## Every clip the two files contain: [file label, clip name]
## (D-392: the spike called this `inventory`. The accepted foundation check F64
## bans any runtime declaration so named -- this project has no item inventory --
## and it caught the port on its first run. It is a CATALOGUE OF CLIPS, and is
## named for what it is.)
var clip_catalogue: Array = []
## Rest differences between the two files' skeletons, measured by name.
var rest_mismatch_max_m: float = 0.0
var rest_mismatch_max_deg: float = 0.0

var refused_requests: int = 0
var refused_names: Array[String] = []
var samples_taken: int = 0
## Every clip name ever sampled -- the suite asserts it is a subset of the seven.
var sampled_names: Dictionary = {}
## While true (set only by the verification suite's OFFLINE measurements), a
## sample is recorded in `measured_names` instead -- so "what the runtime
## played" and "what the suite measured" never mix (V72).
var measuring: bool = false
var measured_names: Dictionary = {}

func load_all() -> bool:
	var combat := _open(AssetManifest.KAYKIT_COMBAT_RANGED, "Rig_Medium_CombatRanged")
	var movement := _open(AssetManifest.KAYKIT_MOVEMENT_ADVANCED, "Rig_Medium_MovementAdvanced")
	if combat.is_empty() or movement.is_empty():
		return false
	var sk: Skeleton3D = combat["skeleton"]
	for i in sk.get_bone_count():
		bone_names.append(sk.get_bone_name(i))
		index_of[sk.get_bone_name(i)] = i
		parent.append(sk.get_bone_parent(i))
		rest.append(sk.get_bone_rest(i))
	order = _topological_order(parent)
	rest_global = _fk_rest()
	# The second file's skeleton must describe the SAME rig, by name.
	var sk2: Skeleton3D = movement["skeleton"]
	for j in sk2.get_bone_count():
		var n := sk2.get_bone_name(j)
		if not index_of.has(n):
			rest_mismatch_max_m = INF
			continue
		var a: Transform3D = rest[int(index_of[n])]
		var b: Transform3D = sk2.get_bone_rest(j)
		rest_mismatch_max_m = maxf(rest_mismatch_max_m, a.origin.distance_to(b.origin))
		rest_mismatch_max_deg = maxf(rest_mismatch_max_deg,
			rad_to_deg(a.basis.get_rotation_quaternion().angle_to(b.basis.get_rotation_quaternion())))
	for entry in [[combat, "CombatRanged"], [movement, "MovementAdvanced"]]:
		var ap: AnimationPlayer = entry[0]["player"]
		for c in ap.get_animation_list():
			clip_catalogue.append([String(entry[1]), String(c)])
			if HuntressConfig.AUTHORIZED_CLIPS.has(String(c)):
				var anim := ap.get_animation(c)
				clips[String(c)] = anim
				_tracks[String(c)] = _map_tracks(anim)
	(combat["root"] as Node).free()
	(movement["root"] as Node).free()
	return clips.size() == HuntressConfig.AUTHORIZED_CLIPS.size()

func _open(path: String, label: String) -> Dictionary:
	var ps := load(path) as PackedScene
	if ps == null:
		push_error("D-392: %s failed to load (%s)" % [label, path])
		return {}
	var root := ps.instantiate()
	var ap := RigCorpus.find_animation_player(root)
	var sk := RigCorpus.find_skeleton(root)
	if ap == null or sk == null:
		push_error("D-392: %s has no AnimationPlayer or no Skeleton3D" % label)
		root.free()
		return {}
	return {"root": root, "player": ap, "skeleton": sk}

func _map_tracks(anim: Animation) -> Dictionary:
	var m := {}
	for t in anim.get_track_count():
		var np := anim.track_get_path(t)
		var bone := String(np.get_concatenated_subnames())
		if not index_of.has(bone):
			continue
		var bi: int = index_of[bone]
		if not m.has(bi):
			m[bi] = [-1, -1, -1]
		match anim.track_get_type(t):
			Animation.TYPE_POSITION_3D: m[bi][0] = t
			Animation.TYPE_ROTATION_3D: m[bi][1] = t
			Animation.TYPE_SCALE_3D: m[bi][2] = t
	return m

static func _topological_order(par: PackedInt32Array) -> PackedInt32Array:
	var out := PackedInt32Array()
	var done := {}
	var guard := 0
	while out.size() < par.size() and guard < 1000:
		guard += 1
		for i in par.size():
			if done.has(i):
				continue
			if par[i] < 0 or done.has(par[i]):
				out.append(i)
				done[i] = true
	return out

func _fk_rest() -> Array[Transform3D]:
	var g: Array[Transform3D] = []
	g.resize(rest.size())
	for i in order:
		g[i] = rest[i] if parent[i] < 0 else g[parent[i]] * rest[i]
	return g

func bone_count() -> int:
	return bone_names.size()

func length_of(clip: String) -> float:
	return (clips[clip] as Animation).length if clips.has(clip) else 0.0

## The REST pose as a BonePose.
func rest_pose() -> BonePose:
	var p := BonePose.sized(bone_count())
	for i in bone_count():
		p.pos[i] = rest[i].origin
		p.rot[i] = rest[i].basis.get_rotation_quaternion()
		p.scl[i] = rest[i].basis.get_scale()
	return p

## Samples one AUTHORIZED clip at time `t` (wrapped when `wrap`). Bones the clip
## has no track for take their rest value -- which is what an imported clip
## whose constant-at-rest tracks were removed means. RETURNS NULL AND COUNTS
## THE REFUSAL for any clip outside the seven.
func sample(clip: String, t: float, wrap: bool = false) -> BonePose:
	if not HuntressConfig.AUTHORIZED_CLIPS.has(clip) or not clips.has(clip):
		refused_requests += 1
		if not refused_names.has(clip):
			refused_names.append(clip)
		return null
	var anim: Animation = clips[clip]
	var tt := t
	if wrap and anim.length > 0.0:
		tt = fposmod(t, anim.length)
	tt = clampf(tt, 0.0, anim.length)
	samples_taken += 1
	if measuring:
		measured_names[clip] = true
	else:
		sampled_names[clip] = true
	var p := rest_pose()
	var m: Dictionary = _tracks[clip]
	for bi in m.keys():
		var tr: Array = m[bi]
		var bits := 0
		if int(tr[0]) >= 0:
			p.pos[bi] = anim.position_track_interpolate(int(tr[0]), tt)
			bits |= 1
		if int(tr[1]) >= 0:
			p.rot[bi] = anim.rotation_track_interpolate(int(tr[1]), tt).normalized()
			bits |= 2
		if int(tr[2]) >= 0:
			p.scl[bi] = anim.scale_track_interpolate(int(tr[2]), tt)
			bits |= 4
		p.tracked[bi] = bits
	return p

## Model-space transforms of a local pose.
func globals(p: BonePose) -> Array[Transform3D]:
	var g: Array[Transform3D] = []
	g.resize(bone_count())
	for i in order:
		var l := p.local_transform(i)
		g[i] = l if parent[i] < 0 else g[parent[i]] * l
	return g

## A SHA-256 over every key of every track of one authorized clip. Reading the
## keys changes nothing; the suite compares this at start and end (A-13).
func checksum(clip: String) -> String:
	if not clips.has(clip):
		return ""
	var anim: Animation = clips[clip]
	var ctx := HashingContext.new()
	ctx.start(HashingContext.HASH_SHA256)
	for t in anim.get_track_count():
		ctx.update(String(anim.track_get_path(t)).to_utf8_buffer())
		for k in anim.track_get_key_count(t):
			ctx.update(var_to_bytes(anim.track_get_key_time(t, k)))
			ctx.update(var_to_bytes(anim.track_get_key_value(t, k)))
	return ctx.finish().hex_encode()

## The clips present in the files and NOT authorized, by file.
func unused_clips() -> Array:
	var out: Array = []
	for e in clip_catalogue:
		if not HuntressConfig.AUTHORIZED_CLIPS.has(String(e[1])):
			out.append(e)
	return out
