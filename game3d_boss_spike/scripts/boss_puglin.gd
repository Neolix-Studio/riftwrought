class_name BossPuglin
extends CharacterBody3D

## THE BOSS CANDIDATE for the D-368 Boss Animation Feasibility Gate.
##
## ============================================================================
## WHAT THIS IS, STATED BEFORE ANYTHING ELSE:
##   A stock Quaternius Bestiary Puglin -- UNMODIFIED mesh, UNMODIFIED 55-joint
##   rig, ZERO animations of its own -- driven entirely by stock clips from the
##   CC0 Universal Animation Library 1 and 2, RECOMPOSED by timing, playback
##   speed, blending, procedural layers, VFX, lighting and sound hooks.
##
##   IT IS NOT the Crownless Warden. IT IS NOT the final campaign boss. IT IS
##   NOT a canonical boss. IT IS NOT final art or final animation. NOT ONE
##   KEYFRAME HERE IS AUTHORED.
## ============================================================================
##
## BOSS IDENTITY DOES NOT COME FROM SCALE. The owner's instruction is explicit,
## and the measurement backs it: the Puglin's posed height is 1.2079 m, which is
## SHORTER than the Imp's 1.4407 m. There is no imposing mesh to lean on. So
## identity is built from, and asserted on, these axes:
##
##   1. SILHOUETTE   -- a double axe on `hand_r` and a heater shield on
##                      `lowerarm_l`, both stock Medieval Weapons meshes,
##                      unmodified; plus a procedural Rift-shard crown (VFX).
##   2. TELEGRAPHS   -- three danger areas of three different GEOMETRIC CLASSES
##                      (cone / annulus / line), not three circles.
##   3. TIMING       -- three anticipations separated by >= 0.40 s, shaped by
##                      playback-speed changes rather than by clip choice alone.
##   4. STAGGER      -- poise-gated. Light hits produce procedural recoil and do
##                      NOT interrupt; only a poise break interrupts. The
##                      ordinary control flinches on EVERY hit. That contrast is
##                      measured, not asserted.
##   5. PHASES       -- two, divided by a real shield-break clip that
##                      PERMANENTLY changes the silhouette.
##   6. YAW          -- continuous, rate-limited and weighty, and it COMMITS at
##                      the attack's commit point.
##
## Scale is applied as SUPPORT for the presentation and is declared as such.

signal event_logged(kind: String, detail: String, at_frame: int)
signal sound_hook(hook: String)

enum State { IDLE, APPROACH, WINDUP, COMMIT, RECOVER, PHASE_BREAK, STAGGER, DYING, DEAD }

## Motion character, DERIVED from the committed geometry and the source clip
## rather than asserted, so the "three motions differ" claim is falsifiable.
enum Motion { HORIZONTAL_SWEEP, VERTICAL_OVERHEAD, STATIONARY_CHANNEL }

var state: State = State.IDLE
var phase: int = 1
var health: float = GateConfig.BOSS_HEALTH
var poise: float = GateConfig.BOSS_POISE
var invulnerable: bool = false

var player: Node3D
var arena: Node3D

# --- test seams. MUST be inert in normal play; asserted by the suite. --------
var debug_forced_attack: int = -1        # -1 = normal selection
var debug_suppress_movement: bool = false
## Stops the STATE MACHINE from driving the AnimDirector, so a check can probe
## the director itself without the AI overwriting the clip underneath it.
## PRESENTATION KEEPS RUNNING -- VFX tick and procedural offsets still decay.
## MUST be false in normal play, and the suite asserts that it is.
var debug_freeze_ai: bool = false

# --- recorded, truthful facts the verification suite reads -------------------
var events: Array = []                    # [kind, detail, frame]
var measured_windup_s: Dictionary = {}     # attack id -> LIVE elapsed seconds
var measured_release_marker: Dictionary = {}  # attack id -> normalized clip pos at release
var attacks_fired: Dictionary = {}
var yaw_samples: Array[float] = []
var telegraph_present_history: Array = []  # [state_name, has_telegraph]
var hit_frames: Array[int] = []
var stagger_frames: Array[int] = []
var interrupted_attack_ids: Array[String] = []
var light_hits_during_windup: int = 0
var death_started_frame: int = -1
var death_clip_started_at: float = -1.0
var death_clip_completed: bool = false
var death_clip_reported_length: float = -1.0
var death_elapsed: float = 0.0
var phase_break_frame: int = -1
var silhouette_attachment_names: Array[String] = []
var vfx_node_count: int = 0
var hooks_fired: Array[String] = []

var _dir: AnimDirector
var _visual: Node3D
var _skel: Skeleton3D
var _ap: AnimationPlayer
var _telegraph: Telegraph
var _yaw: float = 0.0
var _yaw_committed: bool = false
var _attack_idx: int = -1
var _t: float = 0.0                       # phase-local timer
var _cooldown: float = 0.0
var _rift_light: OmniLight3D
var _crown: Node3D
var _crown_shards: Array[MeshInstance3D] = []
var _axe_att: BoneAttachment3D
var _axe_node: MeshInstance3D
var _props_aligned: bool = false
var _align_countdown: int = 6
var _shield_att: BoneAttachment3D
var _shield_mesh: MeshInstance3D
var _beam: MeshInstance3D
var _beam_life: float = 0.0
var _impact_pool: Array[MeshInstance3D] = []

## THE THREE ATTACKS. Declared as data so the suite can interrogate them rather
## than trust prose. Every `clip` is a real, imported, stock clip name.
var attacks: Array = []

func _build_attack_table() -> void:
	attacks = [
		{
			"id": "A1",
			"design": "Sweep",
			"shape": GateConfig.A1_SHAPE,
			"motion": Motion.HORIZONTAL_SWEEP,
			"clip": GateConfig.CLIP_BOSS_A1,
			"windup": GateConfig.A1_WINDUP_S,
			"windup_speed": GateConfig.A1_WINDUP_SPEED,
			"release_speed": GateConfig.A1_RELEASE_SPEED,
			"recovery": GateConfig.A1_RECOVERY_S,
			"damage": GateConfig.A1_DAMAGE,
			"tracks_until": 1.0,
			"hook_tel": "boss_telegraph_sweep",
			"hook_commit": "boss_commit_sweep",
		},
		{
			"id": "A2",
			"design": "Slam",
			"shape": GateConfig.A2_SHAPE,
			"motion": Motion.VERTICAL_OVERHEAD,
			"clip": GateConfig.CLIP_BOSS_A2,
			"windup": GateConfig.A2_WINDUP_S,
			"windup_speed": GateConfig.A2_WINDUP_SPEED,
			"release_speed": GateConfig.A2_RELEASE_SPEED,
			"recovery": GateConfig.A2_RECOVERY_S,
			"damage": GateConfig.A2_DAMAGE,
			"tracks_until": 1.0,
			"hook_tel": "boss_telegraph_slam",
			"hook_commit": "boss_commit_slam",
		},
		{
			"id": "A3",
			"design": "Lance",
			"shape": GateConfig.A3_SHAPE,
			"motion": Motion.STATIONARY_CHANNEL,
			"clip": GateConfig.CLIP_BOSS_A3_CHANNEL,
			"windup": GateConfig.A3_WINDUP_S,
			"windup_speed": GateConfig.A3_WINDUP_SPEED,
			"release_speed": GateConfig.A3_RELEASE_SPEED,
			"recovery": GateConfig.A3_RECOVERY_S,
			"damage": GateConfig.A3_DAMAGE,
			"tracks_until": GateConfig.A3_TRACK_FRACTION,
			"hook_tel": "boss_telegraph_lance",
			"hook_commit": "boss_commit_lance",
		},
	]

static func motion_name(m: Motion) -> String:
	match m:
		Motion.HORIZONTAL_SWEEP: return "HORIZONTAL_SWEEP"
		Motion.VERTICAL_OVERHEAD: return "VERTICAL_OVERHEAD"
		Motion.STATIONARY_CHANNEL: return "STATIONARY_CHANNEL"
	return "UNKNOWN"

# ------------------------------------------------------------------ setup ----

func setup(corpus: AnimationLibrary, arena_root: Node3D) -> void:
	arena = arena_root
	_build_attack_table()
	collision_layer = 2
	collision_mask = 1

	var cs := CollisionShape3D.new()
	var cyl := CylinderShape3D.new()
	cyl.radius = GateConfig.BOSS_BODY_RADIUS
	cyl.height = 3.0
	cs.shape = cyl
	cs.position = Vector3(0, 1.5, 0)
	add_child(cs)

	# --- the stock Puglin, unmodified -------------------------------------
	var ps := load(RigCompat.PUGLIN) as PackedScene
	_visual = ps.instantiate()
	_visual.name = "PuglinVisual"
	add_child(_visual)
	_skel = RigCompat.find_skeleton(_visual)
	_ap = RigCompat.attach_player(_visual, corpus, GateConfig.BLEND_DEFAULT_S)

	# SCALE IS SUPPORT, NOT IDENTITY. Applied to the visual only; the ground
	# point stays the actor's own position.
	_visual.scale = Vector3.ONE * GateConfig.BOSS_VISUAL_SCALE

	# --- treatment: an OFFICIAL pack colour variant, swapped at runtime ----
	# The source PNG is untouched. This is a material override choosing which
	# of the pack's OWN three BaseColor variants the boss samples, which
	# separates it from the olive control with no asset modification at all.
	var variant: Texture2D = load(RigCompat.PUGLIN_VARIANT_2) as Texture2D
	RigCompat.apply_creature_treatment(_visual, GateConfig.BOSS_ALBEDO_MOD,
		GateConfig.COL_RIFT_VIOLET, GateConfig.BOSS_EMISSION_ENERGY_P1, variant)

	_dir = AnimDirector.new()
	_dir.setup(_ap, _skel, _visual)

	_attach_silhouette()
	_build_crown()

	_rift_light = OmniLight3D.new()
	_rift_light.name = "BossRiftLight"
	_rift_light.light_color = GateConfig.COL_RIFT_VIOLET
	_rift_light.light_energy = 1.4
	_rift_light.omni_range = 7.0
	_rift_light.position = Vector3(0, 2.0, 0)
	_rift_light.shadow_enabled = false
	add_child(_rift_light)

	_dir.play("idle", GateConfig.CLIP_BOSS_IDLE, 1.0)
	_log("spawn", "phase 1, health %.0f" % health)

## SILHOUETTE FROM EXISTING ASSETS. Both meshes are stock Medieval Weapons
## `.obj` files, attached to named bones of the shared rig and scaled by a
## MEASURED factor -- the pack is authored at roughly 4x the character packs'
## metric scale, so the factor is computed from each mesh's own AABB rather
## than copied from anywhere.
func _attach_silhouette() -> void:
	silhouette_attachment_names = []
	if _skel == null:
		return

	var axe_mesh: Mesh = load(RigCompat.AXE)
	_axe_att = BoneAttachment3D.new()
	_axe_att.name = "AxeHand"
	_skel.add_child(_axe_att)
	_axe_att.bone_name = RigCompat.BONE_WEAPON_HAND
	var axe := MeshInstance3D.new()
	axe.name = "Axe_Double"
	axe.mesh = axe_mesh
	var axe_fit := RigCompat.prop_scale_for(axe_mesh, 1.85)   # wanted length, metres
	axe.scale = Vector3.ONE * float(axe_fit["scale"])
	axe.position = Vector3(0.0, 0.06, 0.0)
	_axe_att.add_child(axe)
	# The stock material names in this pack are DarkWood / LightWood / Steel /
	# LightSteel / Red / White, so "Metal" alone matched almost nothing and the
	# axe rendered as a near-black pole at the isometric framing. Matching the
	# pack's real names, and lifting the blade value well above the arena stone,
	# is what makes the silhouette read as a weapon.
	RigCompat.tint_all(axe, [
		{"match": "Steel", "color": GateConfig.COL_BLADE, "rough": 0.34, "metal": 0.85},
		{"match": "Metal", "color": GateConfig.COL_BLADE, "rough": 0.34, "metal": 0.85},
		{"match": "Wood", "color": GateConfig.COL_HAFT, "rough": 0.90},
	], GateConfig.COL_BLADE)
	silhouette_attachment_names.append("Axe_Double@" + RigCompat.BONE_WEAPON_HAND)

	var sh_mesh: Mesh = load(RigCompat.SHIELD)
	_shield_att = BoneAttachment3D.new()
	_shield_att.name = "ShieldArm"
	_skel.add_child(_shield_att)
	_shield_att.bone_name = RigCompat.BONE_SHIELD_ARM
	_shield_mesh = MeshInstance3D.new()
	_shield_mesh.name = "Shield_Heater"
	_shield_mesh.mesh = sh_mesh
	var sh_fit := RigCompat.prop_scale_for(sh_mesh, 1.05)
	_shield_mesh.scale = Vector3.ONE * float(sh_fit["scale"])
	_shield_mesh.position = Vector3(0.0, 0.04, -0.05)
	_shield_att.add_child(_shield_mesh)
	RigCompat.tint_all(_shield_mesh, [
		{"match": "Steel", "color": GateConfig.COL_SHIELD_RIM, "rough": 0.40, "metal": 0.7},
		{"match": "Metal", "color": GateConfig.COL_SHIELD_RIM, "rough": 0.40, "metal": 0.7},
		{"match": "Wood", "color": GateConfig.COL_HAFT, "rough": 0.9},
		{"match": "Red", "color": GateConfig.COL_BANNER, "rough": 0.88},
	], GateConfig.COL_SHIELD_FACE)
	silhouette_attachment_names.append("Shield_Heater@" + RigCompat.BONE_SHIELD_ARM)

	_axe_node = axe
	_log("silhouette", "axe source longest %.4f u -> scale %.4f; shield %.4f u -> scale %.4f"
		% [axe_fit["source_longest"], axe_fit["scale"],
		   sh_fit["source_longest"], sh_fit["scale"]])

## Orients the attached props by MEASUREMENT, not by eyeballed Euler angles.
##
## The first version hard-coded rotations and the rendered evidence exposed it
## immediately: the axe lay along the arm and read as a black pole, and the
## shield presented as a flat plate floating behind the body. This sweeps
## candidate orientations, measures each one's WORLD-SPACE vertical extent, and
## keeps the tallest -- an axe and a shield are both carried upright, so the
## tallest candidate is the correct one.
##
## The technique, and the reason for assigning `global_transform` rather than
## composing a local basis by hand, are the accepted D-366 spike's: `Basis.x/.y/
## .z` are ROWS, so hand-built bases agree with themselves while being visibly
## wrong. The picture, not the number, is what settles it.
func align_props() -> void:
	if _props_aligned or _skel == null:
		return
	for entry in [[_axe_node, _axe_att, 1.85], [_shield_mesh, _shield_att, 1.05]]:
		var node: MeshInstance3D = entry[0]
		var att: BoneAttachment3D = entry[1]
		if node == null or not is_instance_valid(node) or att == null:
			continue
		var fit := RigCompat.prop_scale_for(node.mesh, float(entry[2]))
		var scale: float = float(fit["scale"])
		var best_extent := -1.0
		var best: Basis = Basis()
		for ex in [0.0, 90.0, 180.0, 270.0]:
			for ey in [0.0, 90.0, 180.0, 270.0]:
				for ez in [0.0, 90.0, 180.0, 270.0]:
					var cand := Basis.from_euler(Vector3(
						deg_to_rad(ex), deg_to_rad(ey), deg_to_rad(ez)))
					var world := att.global_transform.basis.orthonormalized() * cand
					var ext := _world_y_extent(node.mesh, world.scaled(Vector3.ONE * scale))
					if ext > best_extent:
						best_extent = ext
						best = world
		node.global_transform = Transform3D(
			best.scaled(Vector3.ONE * scale), att.global_transform.origin)
		_log("prop_aligned", "%s -> scale %.4f, world vertical extent %.4f m"
			% [node.name, scale, best_extent])
	_props_aligned = true

## The vertical extent a mesh would occupy in world space under `basis`.
## Exact arithmetic over the AABB's eight corners, not a sampled silhouette.
func _world_y_extent(mesh: Mesh, basis: Basis) -> float:
	if mesh == null:
		return 0.0
	var a := mesh.get_aabb()
	var lo := INF
	var hi := -INF
	for i in 8:
		var c := a.get_endpoint(i)
		var y := (basis * c).y
		lo = minf(lo, y)
		hi = maxf(hi, y)
	return hi - lo

## PROCEDURAL VFX, not an imported asset: a ring of small emissive shards above
## the head. Code-generated geometry, declared as VFX so it is never counted as
## art the owner would have had to make.
func _build_crown() -> void:
	if _skel == null:
		return
	var head_idx := _skel.find_bone(RigCompat.BONE_HEAD)
	if head_idx < 0:
		return
	var att := BoneAttachment3D.new()
	att.name = "CrownAnchor"
	_skel.add_child(att)
	att.bone_name = RigCompat.BONE_HEAD
	_crown = Node3D.new()
	_crown.name = "RiftShardCrown_VFX"
	att.add_child(_crown)
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = GateConfig.COL_RIFT_VIOLET
	mat.emission_enabled = true
	mat.emission = GateConfig.COL_RIFT_VIOLET
	mat.emission_energy_multiplier = 4.0
	for i in 7:
		var m := MeshInstance3D.new()
		var bm := BoxMesh.new()
		bm.size = Vector3(0.035, 0.16 + 0.05 * float(i % 3), 0.035)
		m.mesh = bm
		m.material_override = mat
		var a: float = TAU * (float(i) / 7.0)
		m.position = Vector3(sin(a) * 0.20, 0.20, cos(a) * 0.20)
		m.rotation_degrees = Vector3(18.0, rad_to_deg(a), 0)
		_crown.add_child(m)
		_crown_shards.append(m)
		vfx_node_count += 1

# ------------------------------------------------------------------ damage ---

## `poise_dmg` is separate from `dmg` on purpose. The boss's reaction to being
## hit is governed by POISE, not by damage, which is what lets it acknowledge
## every hit without being interrupted by every hit.
func take_hit(dmg: float, poise_dmg: float, from: Vector3) -> void:
	if state == State.DEAD or state == State.DYING:
		return
	hit_frames.append(Engine.get_physics_frames())
	# PROCEDURAL RECOIL ON EVERY HIT -- the acknowledgement that is always felt.
	_dir.add_recoil(from, global_transform, GateConfig.RECOIL_IMPULSE_DEG)
	_log("hit", "dmg %.0f poise %.0f during %s" % [dmg, poise_dmg, _state_name()])

	if invulnerable:
		_log("hit_absorbed", "invulnerable during %s" % _state_name())
		return

	health -= dmg
	poise -= poise_dmg
	if state == State.WINDUP:
		light_hits_during_windup += 1

	if health <= 0.0:
		_begin_death()
		return

	if poise <= 0.0:
		_begin_stagger()
		return

	# Phase transition is checked AFTER survival, so the boss cannot be killed
	# and transitioned by the same hit.
	if phase == 1 and health <= GateConfig.BOSS_HEALTH * GateConfig.BOSS_PHASE2_AT_HEALTH_FRACTION:
		_begin_phase_break()

func _begin_stagger() -> void:
	# A POISE BREAK INTERRUPTS. This is the only thing that does.
	if state == State.WINDUP and _attack_idx >= 0:
		var aid: String = attacks[_attack_idx]["id"]
		if not interrupted_attack_ids.has(aid):
			interrupted_attack_ids.append(aid)
		_log("attack_interrupted", "%s cancelled by poise break" % aid)
	state = State.STAGGER
	_t = 0.0
	poise = GateConfig.BOSS_POISE
	_clear_telegraph()
	stagger_frames.append(Engine.get_physics_frames())
	_dir.play("stagger", GateConfig.CLIP_BOSS_STAGGER, 1.0,
		GateConfig.BLEND_STAGGER_S, true)
	_hook("boss_stagger")
	_log("stagger", "poise broke; clip %s" % _dir.live_clip())

## THE PHASE TRANSITION. Driven by `Idle_Shield_Break` -- a clip whose REAL
## meaning is exactly what is shown. The shield leaves the arm and stays gone,
## so the silhouette change is permanent rather than a flourish.
func _begin_phase_break() -> void:
	state = State.PHASE_BREAK
	_t = 0.0
	invulnerable = true
	phase_break_frame = Engine.get_physics_frames()
	_clear_telegraph()
	_dir.play("phase_break", GateConfig.CLIP_BOSS_PHASE_BREAK, 1.0,
		GateConfig.BLEND_ATTACK_S, true)
	_hook("boss_phase_break")
	_log("phase_break_begin", "clip %s (%s)" % [_dir.live_clip(), _dir.live_library()])

func _complete_phase_break() -> void:
	phase = 2
	invulnerable = false
	_detach_shield()
	# LIGHTING RESPONDS to the encounter, and the emission ramp is permanent.
	var variant: Texture2D = load(RigCompat.PUGLIN_VARIANT_2) as Texture2D
	RigCompat.apply_creature_treatment(_visual, GateConfig.BOSS_ALBEDO_MOD,
		GateConfig.COL_RIFT_VIOLET, GateConfig.BOSS_EMISSION_ENERGY_P2, variant)
	if _rift_light != null:
		_rift_light.light_energy = 3.1
		_rift_light.omni_range = 9.5
	for s in _crown_shards:
		s.scale = Vector3.ONE * 1.5
	_log("phase_break_complete",
		"phase 2: windups x%.2f, cooldown x%.2f, emission %.1f -> %.1f, attachments %d"
		% [GateConfig.PHASE2_WINDUP_SCALE, GateConfig.PHASE2_COOLDOWN_SCALE,
		   GateConfig.BOSS_EMISSION_ENERGY_P1, GateConfig.BOSS_EMISSION_ENERGY_P2,
		   silhouette_attachment_names.size()])
	if arena != null and arena.has_method("summon_imps"):
		arena.call("summon_imps", GateConfig.IMP_COUNT_SUMMONED_AT_PHASE2)
		_hook("minion_summon")

## The shield is reparented into the arena and left lying on the ground. It is
## not hidden -- hiding it would be a cheaper trick that the rendered evidence
## would expose.
func _detach_shield() -> void:
	if _shield_mesh == null or not is_instance_valid(_shield_mesh):
		return
	var world := _shield_mesh.global_transform
	var host: Node = arena if arena != null else get_parent()
	_shield_att.remove_child(_shield_mesh)
	host.add_child(_shield_mesh)
	_shield_mesh.global_transform = world
	var drop := global_position + (global_transform.basis.x * 1.4)
	_shield_mesh.global_position = Vector3(drop.x, 0.10, drop.z)
	_shield_mesh.rotation_degrees = Vector3(-84.0, 26.0, 0.0)
	silhouette_attachment_names.erase("Shield_Heater@" + RigCompat.BONE_SHIELD_ARM)
	_shield_mesh = null

func _begin_death() -> void:
	state = State.DYING
	death_started_frame = Engine.get_physics_frames()
	death_elapsed = 0.0
	_clear_telegraph()
	collision_layer = 0
	collision_mask = 0
	# THE TRUTHFUL SOURCE DEATH ANIMATION. UAL1 'Death01' is a real death clip,
	# so the gate plays it rather than substituting a code-driven topple. The
	# D-366 spike had to improvise only because UAL2 alone has none.
	_dir.play("death", GateConfig.CLIP_BOSS_DEATH, 1.0, 0.12, true)
	death_clip_started_at = 0.0
	death_clip_reported_length = _dir.live_length()
	_hook("boss_death_start")
	_log("death_begin", "clip %s (%s), reported length %.4f s"
		% [_dir.live_clip(), _dir.live_library(), death_clip_reported_length])

# ----------------------------------------------------------------- process ---

func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return

	_align_countdown -= 1
	if _align_countdown == 0:
		# Aligned once the idle clip has actually posed the rig, so the
		# measurement is against a live pose rather than the rest pose.
		align_props()

	yaw_samples.append(_yaw)
	telegraph_present_history.append([_state_name(), _telegraph != null])
	_tick_vfx(delta)

	if debug_freeze_ai:
		# THE STATE MACHINE IS FROZEN; PRESENTATION IS NOT.
		# Freezing decisions is not the same as freezing the frame. Recoil must
		# still decay and the visual layer must still apply, or a check that
		# probes the director would be measuring a stopped clock -- which is
		# exactly what the recoil check caught when this returned too early.
		_dir.apply_visual_offsets(delta, GateConfig.BOSS_VISUAL_SCALE)
		return

	if state == State.DYING:
		_tick_death(delta)
		_dir.apply_visual_offsets(delta, GateConfig.BOSS_VISUAL_SCALE)
		return

	poise = minf(GateConfig.BOSS_POISE,
		poise + GateConfig.BOSS_POISE_REGEN_PER_S * delta)

	match state:
		State.STAGGER:
			_t += delta
			if _t >= _dir.live_length() or _t > 1.2:
				state = State.IDLE
				_release_yaw_commit()
				_cooldown = maxf(_cooldown, 0.45)
		State.PHASE_BREAK:
			_t += delta
			if _t >= GateConfig.PHASE_BREAK_INVULN_S:
				_complete_phase_break()
				state = State.IDLE
				_release_yaw_commit()
				_cooldown = 0.55
		State.WINDUP:
			_tick_windup(delta)
		State.COMMIT:
			_tick_commit(delta)
		State.RECOVER:
			_t += delta
			if _t >= float(attacks[_attack_idx]["recovery"]) * _phase_scale():
				_clear_telegraph()
				state = State.IDLE
				# THE ATTACK IS OVER, SO THE YAW COMMIT ENDS WITH IT.
				#
				# This was a real defect the suite caught: `_yaw_committed` was
				# only ever cleared when the NEXT windup began, so between
				# attacks the boss stayed frozen facing wherever it had
				# committed and stopped tracking the player entirely. A boss
				# that cannot turn between swings is not weighty, it is broken.
				_release_yaw_commit()
				_cooldown = GateConfig.ATTACK_COOLDOWN_S * _cooldown_scale()
		State.IDLE, State.APPROACH:
			_tick_neutral(delta)

	_tick_yaw(delta)
	# PROCEDURAL TRACKING rides on top of whatever clip is playing.
	if player != null:
		_dir.set_track_target(player.global_position, global_transform, delta)
	_dir.set_lean_from_velocity(velocity, global_transform,
		GateConfig.BOSS_SPEED_MPS, delta)
	_dir.apply_visual_offsets(delta, GateConfig.BOSS_VISUAL_SCALE)

## Ends an attack's yaw commitment and resumes continuous tracking.
func _release_yaw_commit() -> void:
	_yaw_committed = false
	_dir.track_enabled = true

func _phase_scale() -> float:
	return GateConfig.PHASE2_WINDUP_SCALE if phase == 2 else 1.0

func _cooldown_scale() -> float:
	return GateConfig.PHASE2_COOLDOWN_SCALE if phase == 2 else 1.0

func _tick_neutral(delta: float) -> void:
	_cooldown = maxf(0.0, _cooldown - delta)
	var idle_clip := GateConfig.CLIP_BOSS_IDLE if phase == 1 else GateConfig.CLIP_BOSS_IDLE_P2
	if player == null:
		_dir.play("idle", idle_clip, 1.0)
		velocity = Vector3.ZERO
		return
	var to := player.global_position - global_position
	to.y = 0.0
	var dist := to.length()

	if dist > GateConfig.BOSS_AGGRO_RANGE:
		state = State.IDLE
		_dir.play("idle", idle_clip, 1.0)
		velocity = Vector3.ZERO
		return

	if _cooldown > 0.0:
		state = State.IDLE
		_dir.play("idle", idle_clip, 1.0)
		velocity = Vector3.ZERO
		return

	# COMMIT TO THE NEXT ATTACK FIRST, THEN WALK INTO ITS RANGE.
	#
	# The earlier version picked whichever attack happened to reach from where
	# the boss already stood. At 8 m that was ALWAYS the 13 m Lance, so the
	# boss never closed distance and the Sweep and the Slam never fired at all
	# -- and an attack that never executes is DEFERRED, never a pass. Choosing
	# first and approaching second makes all three genuinely occur, and it also
	# reads better: a boss that walks you down is a boss.
	if _pending_attack < 0:
		_pending_attack = _select_attack()
	var desired: float = _preferred_range(_pending_attack)
	if dist > desired and not debug_suppress_movement:
		state = State.APPROACH
		_dir.play("approach", GateConfig.CLIP_BOSS_MOVE, 1.0)
		velocity = to.normalized() * GateConfig.BOSS_SPEED_MPS
		move_and_slide()
		return
	_begin_windup(_pending_attack)
	_pending_attack = -1

## Attack choice. Range-aware so each attack has a reason to exist, with a
## deterministic rotation so no attack can starve -- an attack that never fires
## would be recorded DEFERRED, never as a pass, so the gate makes sure all
## three genuinely occur.
var _rotation_cursor: int = 0
var _pending_attack: int = -1

func _select_attack() -> int:
	if debug_forced_attack >= 0 and debug_forced_attack < attacks.size():
		return debug_forced_attack
	var idx := _rotation_cursor % attacks.size()
	_rotation_cursor = (idx + 1) % attacks.size()
	return idx

func _max_range(idx: int) -> float:
	match idx:
		0: return GateConfig.A1_RADIUS_M
		1: return GateConfig.A2_OUTER_M
		2: return GateConfig.A3_LENGTH_M
	return 0.0

## Where the boss launches this attack from: comfortably inside its reach, so
## the telegraph genuinely covers the player's position at commit time.
func _preferred_range(idx: int) -> float:
	if idx < 0:
		return GateConfig.A1_RADIUS_M * 0.65
	return _max_range(idx) * 0.65

func _begin_windup(idx: int) -> void:
	_attack_idx = idx
	state = State.WINDUP
	_t = 0.0
	_yaw_committed = false
	_dir.track_enabled = true
	var a: Dictionary = attacks[idx]

	# ONE SOURCE OF TRUTH for the danger area: the telegraph object that is
	# DRAWN is the same object that later RESOLVES the hit.
	_telegraph = _make_telegraph(a["shape"])
	add_child(_telegraph)
	_telegraph.set_progress(0.0)

	# PLAYBACK-SPEED-SHAPED ANTICIPATION: the same stock clip, slowed, reads as
	# a weighty wind-up rather than as a fast human swing.
	_dir.play("%s %s — windup" % [a["id"], a["design"]], a["clip"],
		float(a["windup_speed"]), GateConfig.BLEND_ATTACK_S, true)
	if idx == 2:
		# The Lance is a composed three-clip cast: Enter -> Idle(channel) ->
		# Shoot. Its enter clip plays first, at true rate.
		_dir.play("A3 Lance — cast start", GateConfig.CLIP_BOSS_A3_ENTER, 1.0,
			GateConfig.BLEND_ATTACK_S, true)
	_hook(a["hook_tel"])
	_log("windup_begin", "%s shape=%s clip=%s (%s) speed=%.2f windup=%.3f s"
		% [a["id"], Telegraph.shape_name(a["shape"]), _dir.live_clip(),
		   _dir.live_library(), _dir.live_speed(), float(a["windup"]) * _phase_scale()])

func _make_telegraph(shape: GateConfig.Shape) -> Telegraph:
	match shape:
		GateConfig.Shape.CONE:
			return Telegraph.make_cone(GateConfig.A1_CONE_TOTAL_DEG, GateConfig.A1_RADIUS_M)
		GateConfig.Shape.ANNULUS:
			return Telegraph.make_annulus(GateConfig.A2_INNER_M, GateConfig.A2_OUTER_M)
		GateConfig.Shape.LINE:
			return Telegraph.make_line(GateConfig.A3_WIDTH_M, GateConfig.A3_LENGTH_M)
		GateConfig.Shape.DISC:
			return Telegraph.make_disc(GateConfig.A1_RADIUS_M)
	return Telegraph.make_cone(90.0, 1.0)

func _tick_windup(delta: float) -> void:
	velocity = Vector3.ZERO
	_t += delta
	var a: Dictionary = attacks[_attack_idx]
	var total: float = float(a["windup"]) * _phase_scale()
	var frac: float = clampf(_t / total, 0.0, 1.0)
	if _telegraph != null:
		_telegraph.set_progress(frac)

	# Yaw tracks the player only until this attack's stated commit fraction.
	if frac >= float(a["tracks_until"]) and not _yaw_committed:
		_yaw_committed = true
		_dir.track_enabled = false
		_log("yaw_committed", "%s committed at %.2f of windup, yaw %.3f deg"
			% [a["id"], frac, rad_to_deg(_yaw)])

	# The Lance's composed cast: hand over from Enter to the channel clip.
	if _attack_idx == 2 and _dir.live_clip() == GateConfig.CLIP_BOSS_A3_ENTER \
			and _dir.past_normalized(0.92):
		_dir.play("A3 Lance — channel", GateConfig.CLIP_BOSS_A3_CHANNEL, 1.0,
			GateConfig.BLEND_ATTACK_S, true)

	# LIGHTING responds to the anticipation.
	if _rift_light != null:
		var base: float = 3.1 if phase == 2 else 1.4
		_rift_light.light_energy = base + 4.0 * frac

	if _t >= total:
		# ==================================================================
		# MECHANICAL TIMING IS AUTHORITATIVE OVER ANIMATION TIMING.
		# The release fires because THIS TIMER elapsed, never because a clip
		# reached a frame. The clip's own position at this moment is RECORDED,
		# so the suite can prove the marker governs even when the clip is
		# played at a different speed.
		# ==================================================================
		measured_windup_s[a["id"]] = _t
		var l := _dir.live_length()
		if l > 0.0:
			measured_release_marker[a["id"]] = _dir.live_position() / l
		else:
			# The clip had already run to its end before the mechanical release
			# fired. That is recorded truthfully as 1.0 (completed), not as a
			# sentinel -- and it is itself evidence that the TIMER governs the
			# release rather than the animation.
			measured_release_marker[a["id"]] = 1.0
		_commit_attack()

func _commit_attack() -> void:
	state = State.COMMIT
	_t = 0.0
	var a: Dictionary = attacks[_attack_idx]
	attacks_fired[a["id"]] = int(attacks_fired.get(a["id"], 0)) + 1

	if _attack_idx == 2:
		_dir.play("A3 Lance — release", GateConfig.CLIP_BOSS_A3_RELEASE,
			float(a["release_speed"]), GateConfig.BLEND_ATTACK_S, true)
		_spawn_beam()
	else:
		_dir.play("%s %s — release" % [a["id"], a["design"]], a["clip"],
			float(a["release_speed"]), GateConfig.BLEND_ATTACK_S, false)

	if _telegraph != null:
		_telegraph.commit()

	# RESOLUTION USES THE TELEGRAPH ITSELF, so the area that was shown is
	# exactly the area that resolves.
	var hit := false
	if _telegraph != null and player != null:
		hit = _telegraph.contains(player.global_position)
		if hit and player.has_method("take_boss_hit"):
			player.call("take_boss_hit", float(a["damage"]), global_position)
	_spawn_impact(a["shape"])
	_hook(a["hook_commit"])
	_log("commit", "%s resolved: shape=%s player_inside=%s clip=%s (%s) speed=%.2f release_marker=%.3f"
		% [a["id"], Telegraph.shape_name(a["shape"]), str(hit), _dir.live_clip(),
		   _dir.live_library(), _dir.live_speed(),
		   float(measured_release_marker.get(a["id"], -1.0))])

func _tick_commit(delta: float) -> void:
	velocity = Vector3.ZERO
	_t += delta
	if _t >= 0.22:
		state = State.RECOVER
		_t = 0.0
		# THE TELEGRAPH LEAVES ON RECOVERY. A marker that is always on is
		# wallpaper, not a telegraph.
		_clear_telegraph()
		var a: Dictionary = attacks[_attack_idx]
		if _attack_idx != 2:
			_dir.play("%s %s — recovery" % [a["id"], a["design"]], a["clip"],
				0.85, GateConfig.BLEND_DEFAULT_S, false)
		else:
			_dir.play("A3 Lance — recovery", GateConfig.CLIP_BOSS_A3_RELEASE,
				0.7, GateConfig.BLEND_DEFAULT_S, false)

func _tick_death(delta: float) -> void:
	death_elapsed += delta
	velocity = Vector3.ZERO
	# COMPLETENESS IS MEASURED AGAINST THE CLIP'S OWN LENGTH, not a constant.
	var l: float = death_clip_reported_length
	if l > 0.0 and death_elapsed >= l and not death_clip_completed:
		death_clip_completed = true
		_hook("boss_death_end")
		_log("death_complete", "'%s' ran its full %.4f s (elapsed %.4f s)"
			% [GateConfig.CLIP_BOSS_DEATH, l, death_elapsed])
	if _rift_light != null and l > 0.0:
		_rift_light.light_energy = maxf(0.0,
			(3.1 if phase == 2 else 1.4) * (1.0 - clampf(death_elapsed / l, 0.0, 1.0)))
	if death_clip_completed and death_elapsed >= l + 0.35:
		state = State.DEAD
		_log("dead", "terminal; no further action")

func _tick_yaw(delta: float) -> void:
	if player == null:
		return
	# ======================================================================
	# CONTINUOUS 3D YAW (D-367). Rate-limited, never quantised. The pixel-art
	# prototype's eight-direction sector restriction is NOT carried forward --
	# CLAUDE.md 12.1 clause 3 forbids reintroducing it in 3D.
	# ======================================================================
	if _yaw_committed or state == State.COMMIT or state == State.STAGGER \
			or state == State.PHASE_BREAK or state == State.DYING:
		rotation.y = _yaw
		return
	var to := player.global_position - global_position
	to.y = 0.0
	if to.length() < 0.05:
		return
	var want := atan2(to.x, to.z)
	var max_step := deg_to_rad(GateConfig.BOSS_TURN_RATE_DEG) * delta
	var diff := wrapf(want - _yaw, -PI, PI)
	_yaw += clampf(diff, -max_step, max_step)
	rotation.y = _yaw

# ---------------------------------------------------------------- VFX --------

func _spawn_beam() -> void:
	var m := MeshInstance3D.new()
	m.name = "LanceBeam_VFX"
	var bm := BoxMesh.new()
	bm.size = Vector3(GateConfig.A3_WIDTH_M * 0.55, 0.5, GateConfig.A3_LENGTH_M)
	m.mesh = bm
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = Color(GateConfig.COL_RIFT_VIOLET, 0.62)
	mat.emission_enabled = true
	mat.emission = GateConfig.COL_RIFT_VIOLET
	mat.emission_energy_multiplier = 8.0
	m.material_override = mat
	m.position = Vector3(0, 1.1, GateConfig.A3_LENGTH_M * 0.5)
	add_child(m)
	_beam = m
	_beam_life = 0.30
	vfx_node_count += 1

func _spawn_impact(shape: GateConfig.Shape) -> void:
	var m := MeshInstance3D.new()
	m.name = "Impact_VFX"
	var sm := SphereMesh.new()
	sm.radius = 0.5
	sm.height = 1.0
	m.mesh = sm
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	var col := GateConfig.COL_TELEGRAPH_COMMIT if shape != GateConfig.Shape.LINE \
		else GateConfig.COL_RIFT_VIOLET
	mat.albedo_color = Color(col, 0.7)
	mat.emission_enabled = true
	mat.emission = col
	mat.emission_energy_multiplier = 9.0
	m.material_override = mat
	m.position = Vector3(0, 0.6, 1.0)
	add_child(m)
	_impact_pool.append(m)
	vfx_node_count += 1

func _tick_vfx(delta: float) -> void:
	if _crown != null:
		_crown.rotation.y += delta * (1.4 if phase == 2 else 0.6)
	if _beam != null and is_instance_valid(_beam):
		_beam_life -= delta
		var s: float = clampf(_beam_life / 0.30, 0.0, 1.0)
		_beam.scale = Vector3(s, s, 1.0)
		if _beam_life <= 0.0:
			_beam.queue_free()
			_beam = null
	for m in _impact_pool.duplicate():
		if not is_instance_valid(m):
			_impact_pool.erase(m)
			continue
		m.scale += Vector3.ONE * delta * 5.0
		var mat := m.material_override as StandardMaterial3D
		if mat != null:
			var a: float = maxf(0.0, mat.albedo_color.a - delta * 2.4)
			mat.albedo_color.a = a
			if a <= 0.0:
				_impact_pool.erase(m)
				m.queue_free()

# --------------------------------------------------------------- helpers -----

func _clear_telegraph() -> void:
	if _telegraph != null and is_instance_valid(_telegraph):
		_telegraph.queue_free()
	_telegraph = null

func telegraph() -> Telegraph:
	return _telegraph

func director() -> AnimDirector:
	return _dir

func visual() -> Node3D:
	return _visual

func skeleton() -> Skeleton3D:
	return _skel

func current_yaw_deg() -> float:
	return rad_to_deg(_yaw)

func yaw_is_committed() -> bool:
	return _yaw_committed

func attack_count() -> int:
	return attacks.size()

func shape_classes() -> Array[String]:
	var out: Array[String] = []
	for a in attacks:
		out.append(Telegraph.shape_name(a["shape"]))
	return out

func source_clips() -> Array[String]:
	var out: Array[String] = []
	for a in attacks:
		out.append(String(a["clip"]))
	return out

func motion_classes() -> Array[String]:
	var out: Array[String] = []
	for a in attacks:
		out.append(motion_name(a["motion"]))
	return out

func _state_name() -> String:
	match state:
		State.IDLE: return "IDLE"
		State.APPROACH: return "APPROACH"
		State.WINDUP: return "WINDUP"
		State.COMMIT: return "COMMIT"
		State.RECOVER: return "RECOVER"
		State.PHASE_BREAK: return "PHASE_BREAK"
		State.STAGGER: return "STAGGER"
		State.DYING: return "DYING"
		State.DEAD: return "DEAD"
	return "?"

func state_name() -> String:
	return _state_name()

func _log(kind: String, detail: String) -> void:
	var f := Engine.get_physics_frames()
	events.append([kind, detail, f])
	event_logged.emit(kind, detail, f)

func _hook(hook_name: String) -> void:
	# A SOUND HOOK, NOT A SOUND. No audio asset exists in this project.
	hooks_fired.append(hook_name)
	sound_hook.emit(hook_name)
