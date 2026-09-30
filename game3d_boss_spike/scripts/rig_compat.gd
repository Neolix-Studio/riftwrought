class_name RigCompat
extends RefCounted

## Rig compatibility, clip loading and clip ATTRIBUTION for the D-368 gate.
##
## ============================================================================
## THE OWNER'S INSTRUCTION, VERBATIM:
##   "Use UAL1 and UAL2 only after measuring and proving skeleton compatibility.
##    Do not assume compatibility."
## ============================================================================
##
## So nothing in this file assumes it. `measure_subset()` computes the set
## difference IN BOTH DIRECTIONS at runtime, and the verification suite proves
## that test refuses a planted incompatible rig. The numbers below are recorded
## as MEASURED EXPECTATIONS -- they are compared against a live measurement, not
## substituted for one.
##
## MEASURED (Godot 4.7.2, scratchpad probe, before this project existed):
##   * Puglin.glb  -> 55 joints at node path "Armature/Skeleton3D"
##   * Imp.glb     -> 55 joints, the same set
##   * UAL1        -> 65 joints, 43 clips
##   * UAL2        -> 65 joints, 43 clips, IDENTICAL bone set to UAL1
##   * Puglin's 55 are a STRICT SUBSET of the 65: 10 absent, ZERO extra.
##   * Puglin.glb and Imp.glb contain ZERO animations of their own.

const PUGLIN := "res://assets/third_party/quaternius/bestiary_dungeon_monsters/Puglin.glb"
const IMP := "res://assets/third_party/quaternius/bestiary_dungeon_monsters/Imp.glb"
const PUGLIN_VARIANT_2 := "res://assets/third_party/quaternius/bestiary_dungeon_monsters/T_Puglin_BaseColor_2.png"
const UAL1 := "res://assets/third_party/quaternius/universal_animation_library/UAL1_Standard.glb"
const UAL2 := "res://assets/third_party/quaternius/universal_animation_library_2/UAL2_Standard.glb"
const OUTFIT_RANGER := "res://assets/third_party/quaternius/modular_character_outfits_fantasy/Female_Ranger.gltf"
const AXE := "res://assets/third_party/quaternius/medieval_weapons/Axe_Double.obj"
const SHIELD := "res://assets/third_party/quaternius/medieval_weapons/Shield_Heater.obj"
const BOW := "res://assets/third_party/quaternius/medieval_weapons/Bow_Wooden.obj"
const ARROW := "res://assets/third_party/quaternius/medieval_weapons/Arrow.obj"
const RUINS := "res://assets/third_party/quaternius/ultimate_modular_ruins/%s.obj"

const SKELETON_NODE_PATH := "Armature/Skeleton3D"

## Bone names used for attachment and procedural layers, from the shared rig.
const BONE_WEAPON_HAND := "hand_r"
const BONE_SHIELD_ARM := "lowerarm_l"
const BONE_BOW_HAND := "hand_l"
const BONE_HEAD := "Head"
const BONE_UPPER_SPINE := "spine_03"

## MEASURED EXPECTATIONS -- compared against live measurement, never substituted.
const EXPECT_UAL_BONES := 65
const EXPECT_BESTIARY_BONES := 55
const EXPECT_ABSENT_BONES := 10
const EXPECT_EXTRA_BONES := 0
const EXPECT_CLIPS_PER_LIBRARY := 43
const EXPECT_COMBINED_DISTINCT_CLIPS := 85

# --------------------------------------------------------------- loading ----

## Derived clip -> source-library attribution. Built by READING each library's
## own animation list, never from a hand-written table. A hand-written
## attribution would be the project's "compares path text rather than identity"
## defect class wearing a different hat.
static var clip_source: Dictionary = {}
static var collisions: Array[String] = []
static var library_clip_counts: Dictionary = {}

static func _library_from(path: String, label: String) -> AnimationLibrary:
	var ps := load(path) as PackedScene
	if ps == null:
		push_error("GATE: %s failed to load as PackedScene (%s)" % [label, path])
		return null
	var inst: Node = ps.instantiate()
	var ap: AnimationPlayer = _find_ap(inst)
	if ap == null:
		push_error("GATE: %s scene has no AnimationPlayer" % label)
		inst.free()
		return null
	var lib: AnimationLibrary = ap.get_animation_library(&"")
	var copy: AnimationLibrary = lib.duplicate(true)
	inst.free()
	return copy

## Merges UAL1 and UAL2 into ONE library and records, per clip, which library it
## actually came from. Collisions are RECORDED, never silently overwritten.
static func build_corpus() -> AnimationLibrary:
	clip_source = {}
	collisions = []
	library_clip_counts = {}
	var merged := AnimationLibrary.new()
	for entry in [[UAL1, "UAL1"], [UAL2, "UAL2"]]:
		var lib := _library_from(entry[0], entry[1])
		if lib == null:
			continue
		var names := lib.get_animation_list()
		library_clip_counts[entry[1]] = names.size()
		for n in names:
			var key := String(n)
			if merged.has_animation(key):
				# Present in both libraries. Record it; do not pretend otherwise.
				if not collisions.has(key):
					collisions.append(key)
				clip_source[key] = "%s+%s" % [clip_source[key], entry[1]]
				continue
			merged.add_animation(key, lib.get_animation(key))
			clip_source[key] = entry[1]
	return merged

## The clip's SOURCE LIBRARY, derived. Returns "" when unknown -- and "unknown"
## is reported, never guessed.
static func attribute(clip: String) -> String:
	return String(clip_source.get(clip, ""))

static func _find_ap(n: Node) -> AnimationPlayer:
	if n is AnimationPlayer:
		return n as AnimationPlayer
	for c in n.get_children():
		var a := _find_ap(c)
		if a != null:
			return a
	return null

static func find_skeleton(root: Node) -> Skeleton3D:
	if root is Skeleton3D:
		return root as Skeleton3D
	for c in root.get_children():
		var s := find_skeleton(c)
		if s != null:
			return s
	return null

static func bone_names(skel: Skeleton3D) -> Array[String]:
	var out: Array[String] = []
	if skel == null:
		return out
	for i in skel.get_bone_count():
		out.append(skel.get_bone_name(i))
	return out

# --------------------------------------------------- compatibility, MEASURED --

## Computes the set difference IN BOTH DIRECTIONS.
##   absent  = in `reference` but not in `subject`  (tracks with no target)
##   extra   = in `subject` but not in `reference`  (bones no clip can drive)
## `compatible` is true only when `extra` is EMPTY -- a strict subset. A rig with
## extra bones is NOT driven correctly by the reference corpus, and saying so is
## the whole job of this function.
static func measure_subset(subject: Array, reference: Array) -> Dictionary:
	var absent: Array[String] = []
	for n in reference:
		if not subject.has(n):
			absent.append(String(n))
	var extra: Array[String] = []
	for n in subject:
		if not reference.has(n):
			extra.append(String(n))
	return {
		"subject_count": subject.size(),
		"reference_count": reference.size(),
		"absent": absent,
		"extra": extra,
		"compatible": extra.is_empty() and not subject.is_empty(),
	}

## Attaches a fresh AnimationPlayer carrying the merged corpus to a character
## root whose child path "Armature/Skeleton3D" matches the corpus track paths.
static func attach_player(char_root: Node3D, lib: AnimationLibrary,
		blend: float) -> AnimationPlayer:
	var ap := AnimationPlayer.new()
	ap.name = "GateAnimationPlayer"
	char_root.add_child(ap)
	ap.add_animation_library(&"", lib)
	ap.root_node = NodePath("..")
	ap.playback_default_blend_time = blend
	# ANIMATION ADVANCES WITH PHYSICS, DELIBERATELY.
	#
	# MECHANICAL TIMING IS AUTHORITATIVE OVER ANIMATION TIMING (CLAUDE.md 5),
	# and the gate's release markers are driven by physics-stepped timers. With
	# the default idle/process mode the clip advanced against render frames
	# instead, which made every timing measurement noisy -- the playback-speed
	# check measured a x25 ratio where the arithmetic says x5, purely because
	# the number of render frames inside a fixed span varies. Stepping the
	# animation with the simulation makes those measurements exact and
	# deterministic, which is the only basis on which they mean anything.
	ap.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_PHYSICS
	return ap

# ------------------------------------------------------------ clip guard ----

## Every clip this gate asked for and could not find. A MISSING CLIP MUST NEVER
## BE A SILENT NO-OP -- that is the project's named "silent animation fallback"
## defect class, and this gate composes far more clips than the D-366 spike, so
## the guard matters more here, not less.
static var missing_clips: Array[String] = []

static func play_guarded(ap: AnimationPlayer, clip: String,
		speed: float = 1.0, blend: float = -1.0, restart: bool = false) -> bool:
	if ap == null or clip == "":
		return false
	if not ap.has_animation(clip):
		if not missing_clips.has(clip):
			missing_clips.append(clip)
			push_error("GATE: requested animation clip '%s' DOES NOT EXIST in the "
				% clip + "merged UAL1+UAL2 corpus. Refusing to fail silently.")
		return false
	if restart or ap.current_animation != clip:
		# `custom_speed` is deliberately LEFT AT 1.0 and the rate is carried
		# solely by `speed_scale`.
		#
		# MEASURED, in two steps, and worth recording because the first reading
		# was wrong. Passing the rate only as `custom_speed` appeared to do
		# nothing -- but that measurement was taken while the AnimationPlayer
		# advanced on render frames, so it was unreliable rather than
		# informative. Setting BOTH then made the rate apply TWICE and multiply:
		# a clip asked for x0.30 advanced at x0.09, and x1.50 advanced at x2.25.
		# The suite caught it because it measures the actual advance instead of
		# trusting the assignment.
		#
		# ONE MECHANISM ONLY, therefore. `speed_scale` is also what
		# `live_speed()` reads, so the rate on the debug overlay is the rate in
		# effect rather than a separate number that can drift from it.
		ap.play(clip, blend)
	if not is_equal_approx(ap.speed_scale, speed):
		ap.speed_scale = speed
	return true

## Verifies every required clip up front, so a typo cannot surface as a boss
## that simply stands still.
static func verify_required(ap: AnimationPlayer, required: Array) -> Array[String]:
	var missing: Array[String] = []
	for c in required:
		if not ap.has_animation(String(c)):
			missing.append(String(c))
	return missing

# ------------------------------------------------------- material treatment --

## Applies the gate's PROVISIONAL treatment to a character.
## THESE ARE RUNTIME OVERRIDES. NO SOURCE MESH OR TEXTURE IS EDITED.
##
## The Bestiary creatures ship real PBR maps (BaseColor / Normal / ORM /
## Emissive). Replacing them with flat colours would throw the packs' actual
## quality away and make the gate measure the wrong thing, so the imported
## material is DUPLICATED and only albedo modulation and emission are touched.
## The pack's own emissive mask therefore decides WHERE the violet Rift accent
## lands -- on the creature, never on the architecture.
static func apply_creature_treatment(node: Node, albedo_mod: Color,
		emission: Color, energy: float, albedo_override: Texture2D = null) -> int:
	var n := 0
	if node is MeshInstance3D:
		var mi := node as MeshInstance3D
		if mi.mesh != null:
			for s in range(mi.mesh.get_surface_count()):
				var src := mi.mesh.surface_get_material(s)
				if src == null or not (src is BaseMaterial3D):
					continue
				var m: BaseMaterial3D = src.duplicate()
				m.albedo_color = albedo_mod
				# An OFFICIAL pack colour variant, swapped at runtime. The source
				# PNG is untouched; only which texture the material samples moves.
				if albedo_override != null:
					m.albedo_texture = albedo_override
				if m.emission_texture != null:
					m.emission_enabled = true
					m.emission = emission
					m.emission_energy_multiplier = energy
				mi.set_surface_override_material(s, m)
				n += 1
	for c in node.get_children():
		n += apply_creature_treatment(c, albedo_mod, emission, energy, albedo_override)
	return n

## Flat treatment for the stock environment / prop geometry, which ships no PBR
## maps. `rules` is an Array of {match, color, rough, metal, emission?, energy?};
## the first rule whose `match` appears in the source material name wins.
static func tint_all(node: Node, rules: Array, default_col: Variant = null) -> int:
	var touched := 0
	if node is MeshInstance3D:
		var mi := node as MeshInstance3D
		if mi.mesh != null:
			for s in range(mi.mesh.get_surface_count()):
				var base_mat := mi.mesh.surface_get_material(s)
				var mat_name := ""
				if base_mat != null:
					mat_name = base_mat.resource_name
				var hit: Dictionary = {}
				for r in rules:
					if mat_name.findn(String(r["match"])) >= 0:
						hit = r
						break
				var col: Variant = default_col
				if not hit.is_empty():
					col = hit["color"]
				if col == null:
					continue
				var m := StandardMaterial3D.new()
				m.albedo_color = col
				m.roughness = float(hit.get("rough", 0.88))
				m.metallic = float(hit.get("metal", 0.0))
				m.metallic_specular = float(hit.get("spec", 0.22))
				if hit.has("emission"):
					m.emission_enabled = true
					m.emission = hit["emission"]
					m.emission_energy_multiplier = float(hit.get("energy", 1.0))
				mi.set_surface_override_material(s, m)
				touched += 1
	for c in node.get_children():
		touched += tint_all(c, rules, default_col)
	return touched

## Measures a node's posed extent from BONE positions rather than from a
## rest-pose AABB, because a T-pose AABB is not a measurement of a standing
## creature. Returns metres in the skeleton's own global frame.
static func posed_height(skel: Skeleton3D) -> float:
	if skel == null or skel.get_bone_count() == 0:
		return 0.0
	var lo := INF
	var hi := -INF
	for i in skel.get_bone_count():
		var p := (skel.global_transform * skel.get_bone_global_pose(i)).origin
		lo = minf(lo, p.y)
		hi = maxf(hi, p.y)
	return hi - lo

## The uniform scale a source prop needs to reach a wanted metric size.
## MEASURED, not guessed -- the Medieval Weapons pack is authored at roughly 4x
## the character packs' metric scale, so a hard-coded factor copied from
## elsewhere would be wrong here.
static func prop_scale_for(mesh: Mesh, want_longest_m: float) -> Dictionary:
	if mesh == null:
		return {"scale": 1.0, "source_longest": 0.0}
	var a := mesh.get_aabb()
	var longest: float = maxf(a.size.x, maxf(a.size.y, a.size.z))
	if longest <= 0.0:
		return {"scale": 1.0, "source_longest": 0.0}
	return {"scale": want_longest_m / longest, "source_longest": longest}
