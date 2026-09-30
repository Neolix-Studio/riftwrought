class_name RigCorpus
extends RefCounted

## THE SPIKE'S OWN RIG HELPERS — NOT A COPY OF `game3d/scripts/assets/rig_corpus.gd`.
##
## ============================================================================
## WHY A CLASS OF THIS NAME EXISTS HERE AT ALL
## ============================================================================
## The accepted controller, `scripts/control/player_controller.gd`, is copied
## VERBATIM from game3d/ so that the accepted STOP / recovery-cancellation
## behaviour is the accepted CODE rather than a re-implementation of it. That
## file calls `RigCorpus.find_skeleton`, `RigCorpus.attach_player` and
## `RigCorpus.play_guarded` by name, so a class called RigCorpus must exist.
##
## game3d/'s own rig_corpus.gd is NOT copied: its `build_corpus()` loads the UAL1
## and UAL2 libraries, which this spike is not authorized to import. So those
## three functions are RE-IMPLEMENTED here, declared as such, and nothing else in
## this file pretends to be the accepted module.
##
## ONE DELIBERATE DIFFERENCE: `attach_player()` returns NULL when it is given no
## library. The spike drives the Huntress's pose itself, from mechanical time,
## through `BowRetargeter` -- so an AnimationPlayer on her would be an inert node
## that could only mislead a reader.

## Every clip this spike asked `play_guarded` for and could not find.
static var missing_clips: Array[String] = []

static func find_skeleton(root: Node) -> Skeleton3D:
	if root is Skeleton3D:
		return root as Skeleton3D
	for c in root.get_children():
		var s := find_skeleton(c)
		if s != null:
			return s
	return null

static func find_animation_player(n: Node) -> AnimationPlayer:
	if n is AnimationPlayer:
		return n as AnimationPlayer
	for c in n.get_children():
		var a := find_animation_player(c)
		if a != null:
			return a
	return null

static func bone_names(skel: Skeleton3D) -> Array[String]:
	var out: Array[String] = []
	if skel == null:
		return out
	for i in skel.get_bone_count():
		out.append(skel.get_bone_name(i))
	return out

## The set difference IN BOTH DIRECTIONS. Technique carried from game3d/ (itself
## carried from game3d_boss_spike/), re-implemented.
static func measure_subset(subject: Array, reference: Array) -> Dictionary:
	var absent: Array[String] = []
	for n in reference:
		if not subject.has(n):
			absent.append(String(n))
	var extra: Array[String] = []
	for n in subject:
		if not reference.has(n):
			extra.append(String(n))
	var shared: Array[String] = []
	for n in subject:
		if reference.has(n):
			shared.append(String(n))
	return {
		"subject_count": subject.size(),
		"reference_count": reference.size(),
		"absent": absent,
		"extra": extra,
		"shared": shared,
		"compatible": extra.is_empty() and not subject.is_empty(),
	}

## Returns NULL when no library is supplied -- see the header. With a library it
## behaves as the accepted helper does: physics-stepped playback.
static func attach_player(char_root: Node3D, lib: AnimationLibrary, blend: float) -> AnimationPlayer:
	if lib == null:
		return null
	var ap := AnimationPlayer.new()
	ap.name = "SpikeAnimationPlayer"
	char_root.add_child(ap)
	ap.add_animation_library(&"", lib)
	ap.root_node = NodePath("..")
	ap.playback_default_blend_time = blend
	ap.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS
	return ap

## A missing clip is NEVER a silent no-op. With no player, it refuses and says
## nothing -- the spike's probe overrides `_play` and never reaches this.
static func play_guarded(ap: AnimationPlayer, clip: String,
		speed: float = 1.0, blend: float = -1.0, restart: bool = false) -> bool:
	if ap == null or clip == "":
		return false
	if not ap.has_animation(clip):
		if not missing_clips.has(clip):
			missing_clips.append(clip)
			push_error("SPIKE: requested clip '%s' does not exist. Refusing to fail silently." % clip)
		return false
	if restart or ap.current_animation != clip:
		ap.play(clip, blend)
	if not is_equal_approx(ap.speed_scale, speed):
		ap.speed_scale = speed
	return true

## The standing height of a visual, from the union of its meshes' rest AABBs.
static func mesh_height(root: Node) -> float:
	var lo := INF
	var hi := -INF
	for mi in _meshes(root):
		var a: AABB = (mi as MeshInstance3D).get_aabb()
		lo = minf(lo, a.position.y)
		hi = maxf(hi, a.position.y + a.size.y)
	return hi - lo if hi > lo else 0.0

static func _meshes(n: Node) -> Array:
	var out: Array = []
	if n is MeshInstance3D:
		out.append(n)
	for c in n.get_children():
		out.append_array(_meshes(c))
	return out

static func meshes_of(root: Node) -> Array:
	return _meshes(root)
