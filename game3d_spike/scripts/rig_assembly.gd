class_name RigAssembly
extends RefCounted

## Character / outfit / animation assembly for the D-366 feasibility spike.
##
## THE MEASURED COMPATIBILITY FACTS THIS FILE RELIES ON:
##   * Female_Ranger.gltf, Superhero_Female_FullBody.gltf and UAL2_Standard.glb
##     all carry an IDENTICAL 65-joint skeleton -- same names, no extras.
##     => UAL2 clips drive the Ranger with NO retargeting.
##   * Imp.glb carries 55 joints which are a STRICT SUBSET of those 65
##     (missing 8 pinky bones + 2 ball_leaf bones, zero extra).
##     => UAL2 clips drive the Imp too; 10 tracks simply have no target.
##   * All three share the node path "Armature/Skeleton3D", which is exactly
##     what UAL2's animation tracks address.
##   * Imp.glb and Puglin.glb contain ZERO animations of their own.

const OUTFIT_RANGER := "res://assets/third_party/quaternius/modular_character_outfits_fantasy/Female_Ranger.gltf"
const BASE_FEMALE := "res://assets/third_party/quaternius/universal_base_characters/Superhero_Female_FullBody.gltf"
const UAL2 := "res://assets/third_party/quaternius/universal_animation_library_2/UAL2_Standard.glb"
const IMP := "res://assets/third_party/quaternius/bestiary_dungeon_monsters/Imp.glb"
const BOW := "res://assets/third_party/quaternius/medieval_weapons/Bow_Wooden.obj"
const ARROW := "res://assets/third_party/quaternius/medieval_weapons/Arrow.obj"

## Pulls the 43-clip library out of the imported UAL2 scene.
static func load_ual2_library() -> AnimationLibrary:
	var ps := load(UAL2) as PackedScene
	if ps == null:
		push_error("SPIKE: UAL2 PackedScene failed to load")
		return null
	var inst: Node = ps.instantiate()
	var ap: AnimationPlayer = inst.get_node_or_null("AnimationPlayer")
	if ap == null:
		push_error("SPIKE: UAL2 scene has no AnimationPlayer")
		inst.free()
		return null
	var lib: AnimationLibrary = ap.get_animation_library(&"")
	var copy: AnimationLibrary = lib.duplicate(true)
	inst.free()
	return copy

## Attaches a fresh AnimationPlayer carrying the UAL2 library to a character
## root whose child path "Armature/Skeleton3D" matches the UAL2 track paths.
static func attach_player(char_root: Node3D, lib: AnimationLibrary) -> AnimationPlayer:
	var ap := AnimationPlayer.new()
	ap.name = "SpikeAnimationPlayer"
	char_root.add_child(ap)
	ap.add_animation_library(&"", lib)
	ap.root_node = NodePath("..")
	# Deterministic blending so locomotion reads smoothly. PROVISIONAL.
	ap.playback_default_blend_time = 0.16
	return ap

static func find_skeleton(root: Node) -> Skeleton3D:
	if root is Skeleton3D:
		return root as Skeleton3D
	for c in root.get_children():
		var s := find_skeleton(c)
		if s != null:
			return s
	return null

## Builds the Huntress PLACEHOLDER visual.
##
## THE PACK'S OWN COMPATIBILITY INSTRUCTION, QUOTED VERBATIM:
##   "These outfits work together with the Universal Base Character kit. When
##    using the clothing, only the head of the model is required. Using the
##    full body will result in clipping."
##
## MEASURED OBSTACLE: in the Standard/FREE tier the base character's entire
## body INCLUDING the head is ONE skinned mesh ("Superhero_Female"). There is
## no separate head mesh to keep, and editing source meshes is forbidden here.
##
## HOW THE INSTRUCTION IS HONOURED ANYWAY: the outfit is self-contained (hood,
## body, arms with their own skin material, legs, feet, pauldrons, belts), so
## THE FULL BASE BODY IS NEVER INSTANTIATED. That achieves the readme's actual
## purpose -- no hidden body, therefore no clipping -- by the only route the
## free files allow. `add_eyes` optionally borrows ONLY the base character's
## separate `Eyes`/`Eyebrows` meshes, which is the pack's sanctioned head
## detail source and adds no body geometry.
static func build_huntress_visual(lib: AnimationLibrary, add_eyes: bool) -> Dictionary:
	var ps := load(OUTFIT_RANGER) as PackedScene
	var root: Node3D = ps.instantiate()
	root.name = "RangerOutfit"
	var skel := find_skeleton(root)
	var ap := attach_player(root, lib)

	var eye_meshes := 0
	if add_eyes and skel != null:
		var bps := load(BASE_FEMALE) as PackedScene
		var binst: Node3D = bps.instantiate()
		var bskel := find_skeleton(binst)
		if bskel != null:
			for want in ["Eyes", "Eyebrows"]:
				var src: MeshInstance3D = bskel.get_node_or_null(want)
				if src == null:
					continue
				var copy := MeshInstance3D.new()
				copy.name = want
				copy.mesh = src.mesh
				copy.skin = src.skin
				copy.transform = src.transform
				skel.add_child(copy)
				copy.skeleton = NodePath("..")
				eye_meshes += 1
		binst.free()

	# Bow on the LEFT hand: a right-handed archer holds the bow left, draws right.
	var bow_att := BoneAttachment3D.new()
	bow_att.name = "BowHand"
	skel.add_child(bow_att)
	bow_att.bone_name = SpikeConfig.BONE_BOW_HAND
	var bow := MeshInstance3D.new()
	bow.name = "Bow"
	bow.mesh = load(BOW)
	bow_att.add_child(bow)

	# Orientation is COMPUTED, not eyeballed -- see HuntressSpike.align_bow(),
	# which solves it against the LIVE animated pose of the hand bone once the
	# idle clip is running. Scale is the measured 0.22 factor.
	bow.scale = Vector3.ONE * SpikeConfig.WEAPON_SCALE

	return {
		"root": root, "skeleton": skel, "anim": ap,
		"bow_attachment": bow_att, "bow": bow, "eye_meshes": eye_meshes,
	}

static func build_imp_visual(lib: AnimationLibrary) -> Dictionary:
	var ps := load(IMP) as PackedScene
	var root: Node3D = ps.instantiate()
	root.name = "ImpVisual"
	var skel := find_skeleton(root)
	var ap := attach_player(root, lib)
	return {"root": root, "skeleton": skel, "anim": ap}

## Applies the spike's PROVISIONAL material treatment.
## THESE ARE RUNTIME OVERRIDES. NO SOURCE MESH IS EDITED.
##
## `rules` is an Array of Dictionaries:
##   {match:String, color:Color, rough:float, metal:float,
##    emission:Color (optional), energy:float (optional)}
## The first rule whose `match` appears in the source material's name wins.
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

## Adjusts ONLY the emission channel of a character's OWN imported PBR material.
##
## The character packs ship real PBR maps (BaseColor / Normal / ORM, and for the
## Imp an Emissive mask). REPLACING those with flat colours throws the packs'
## actual quality away and would make this spike measure the wrong thing. So
## characters KEEP their imported materials, and the violet Rift accent is
## applied by duplicating each material and touching emission alone -- the
## Imp's own emissive mask decides WHERE it lands.
static func retint_emission(node: Node, col: Color, energy: float) -> int:
	var n := 0
	if node is MeshInstance3D:
		var mi := node as MeshInstance3D
		if mi.mesh != null:
			for s in range(mi.mesh.get_surface_count()):
				var src := mi.mesh.surface_get_material(s)
				if src == null or not (src is BaseMaterial3D):
					continue
				var m: BaseMaterial3D = src.duplicate()
				m.emission_enabled = true
				m.emission = col
				m.emission_energy_multiplier = energy
				mi.set_surface_override_material(s, m)
				n += 1
	for c in node.get_children():
		n += retint_emission(c, col, energy)
	return n

## Records every clip this spike asked for and could not find.
## A MISSING CLIP MUST NEVER BE A SILENT NO-OP. The verification suite asserts
## this list is empty, and the guard is proved able to refuse a planted bad name.
static var missing_clips: Array[String] = []

static func play_guarded(ap: AnimationPlayer, clip: String) -> bool:
	if ap == null or clip == "":
		return false
	if not ap.has_animation(clip):
		if not missing_clips.has(clip):
			missing_clips.append(clip)
			push_error("SPIKE: requested animation clip '%s' DOES NOT EXIST in the "
				% clip + "imported UAL2 library. Refusing to fail silently.")
		return false
	if ap.current_animation != clip:
		ap.play(clip)
	return true

## Applies the violet Rift accent WITHOUT discarding the pack's PBR maps:
## albedo_color MODULATES the existing albedo texture, and emission is retinted
## so the pack's own emissive mask decides where the glow lands.
static func apply_rift_accent(node: Node, albedo_mod: Color, emis: Color,
		energy: float) -> int:
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
				if m.emission_texture != null:
					m.emission_enabled = true
					m.emission = emis
					m.emission_energy_multiplier = energy
				mi.set_surface_override_material(s, m)
				n += 1
	for c in node.get_children():
		n += apply_rift_accent(c, albedo_mod, emis, energy)
	return n
