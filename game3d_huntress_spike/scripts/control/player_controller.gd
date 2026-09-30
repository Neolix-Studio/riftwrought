class_name PlayerController
extends CharacterBody3D

## THE PLAYER — a GROUND-POINT ACTOR.
##
## ============================================================================
## THE ACTOR'S POSITION IS ITS GROUND POINT: THE FEET, NOT THE CENTRE.
## ============================================================================
## Collision, navigation, targeting, reach and distance all read the ACTOR.
## NOTHING READS THE VISUAL'S POSITION, and visual height is never a gameplay
## coordinate. The suite proves the second half by moving the visual alone and
## asserting that no gameplay quantity changes.
##
## ---------------------------------------------------------------------------
## THE ARCHITECTURE IS DELIBERATELY FOUR SMALL PIECES, NOT ONE SCRIPT.
## ---------------------------------------------------------------------------
##   InputIntent     devices -> intent            (knows no movement)
##   LocomotionMotor wish direction -> velocity    (knows no devices)
##   YawDriver       target angle -> facing        (knows neither)
##   PlayerController composes them, and owns navigation and the one diagnostic
##                   action.
## Each of the first three is a plain object the suite can step with an exact
## delta, which is why acceleration, braking and turn rate can be MEASURED here
## rather than sampled off a moving character and hoped about.
##
## ---------------------------------------------------------------------------
## THIS IS NOT THE HUNTRESS.
## ---------------------------------------------------------------------------
## It is a PLAYER PROBE wearing a third-party placeholder body. The Huntress
## remains ART ONLY: no canonical class specification exists, none is written
## here, and one remains a P2 prerequisite. NO WEAPON IS ATTACHED -- see
## `ProdConfig.CORPUS_GAPS`.

signal bolt_released(from: Vector3, dir: Vector3)

## CLAUDE.md 3.5 permits exactly ONE explicitly diagnostic, non-canonical action.
## This list is that permission, made countable.
const DIAGNOSTIC_ACTIONS := [ProdConfig.DIAG_ATTACK_DESIGN_NAME]

var camera: IsoCameraRig
var bolt_parent: Node3D
var intent := InputIntent.new()
var motor := LocomotionMotor.new()
var yaw_driver := YawDriver.new()
## THE ACTION-MOVEMENT COMMITMENT. Added by the D-370 owner live review.
## It is NOT a Skill system and must not become one.
var commitment := ActionCommitment.new()

## ============================================================================
## THE D-375 IMPRINT STAGE'S SKILL RUNTIME, WHEN ONE IS COMPOSED IN.
## ============================================================================
## NULL unless the composition root builds one, so the accepted foundation still
## runs exactly as it did. THE CONTROLLER GAINS NO ATTACK ENTRY POINT FROM THIS:
## `DIAGNOSTIC_ACTIONS` is still ONE, there is still exactly one `begin_`
## function here, and Skill Uses live in `SkillRuntime` because a Skill system is
## a different concern from a locomotion controller.
var skills = null

## A GENERIC PENDING RELEASE FOR AN ACTION BEGUN BY A SUBSYSTEM.
##
## The foundation's own bolt does NOT use it -- `_pending_shot` is untouched, and
## so is every timing, brake and cancel-window value D-373 accepted. This is the
## one seam a subsystem needs in order to use the ACCEPTED commitment rather than
## inventing a second one.
var _pending_release: Callable = Callable()
var life := Damageable.new(300.0)

var agent: NavigationAgent3D
var follower := NavService.PathFollower.new()
var visual: Node3D
var anim: AnimationPlayer
var skeleton: Skeleton3D

## AIM. A world POINT, sampled independently of movement every frame.
var aim_point: Vector3 = Vector3.FORWARD
var aim_dir: Vector3 = Vector3.FORWARD

## MOVEMENT. `move_destination` is set ONLY by a move command. Aiming never
## writes it, and the suite asserts that in both directions.
var move_destination = null                   ## Vector3 or null
var last_command_was_redirected: bool = false
var last_command_redirect_m: float = 0.0
var commands_issued: int = 0
var commands_redirected: int = 0

## Diagnostics the suite reads. These are LOGS, not control state.
var shot_dirs: Array[Vector3] = []
var shots_fired: int = 0
var recoveries: int = 0
var recovery_cancels: int = 0
var buffered_moves: int = 0
var buffered_applied: int = 0
var buffered_discarded: int = 0

## THE WIND-UP MOVEMENT BUFFER.
##
## A movement request during the wind-up must NOT translate and must NOT cancel
## the attack -- but it must not be thrown away either. The NEWEST valid intent
## wins, and it is applied the moment the recovery is cancelled.
var _buffer_kind: String = ""            ## "" | "stick" | "command"
var _buffer_axis: Vector2 = Vector2.ZERO
var _buffer_point: Vector3 = Vector3.ZERO
var live_clip: String = ""
var live_design_name: String = "idle"

var _cooldown: float = 0.0
var _pending_shot: bool = false
## The aim captured AT THE MOMENT THIS USE BEGAN. Targeting is per-use: it is
## written when an attack starts, read once at the release marker, and CLEARED.
## It must be zero between uses, and the suite asserts that.
var _shot_aim_dir: Vector3 = Vector3.ZERO

## Test seams. Null / false in normal play; asserted so by the suite.
var debug_freeze_attack: bool = false
var debug_release_times: Array[float] = []

func setup(corpus: AnimationLibrary) -> void:
	collision_layer = 1
	# World geometry AND enemy bodies. Actors are solid to one another, which is
	# what 'stable collision' has to mean if it means anything.
	collision_mask = 4 | 2
	var cs := CollisionShape3D.new()
	var cyl := CylinderShape3D.new()
	cyl.radius = ProdConfig.PLAYER_BODY_RADIUS
	cyl.height = 1.7
	cs.shape = cyl
	cs.position = Vector3(0, 0.85, 0)       # the SHAPE is offset; the ACTOR is not
	add_child(cs)

	# A NavigationAgent3D is kept so the project's agent RADIUS is declared in the
	# scene graph where the navigation system can see it -- but the STEERING is
	# this project's own PathFollower, for the measured reason recorded in
	# NavService.PathFollower.
	agent = NavigationAgent3D.new()
	agent.name = "NavAgent"
	agent.radius = ProdConfig.NAV_AGENT_RADIUS
	agent.height = ProdConfig.NAV_AGENT_HEIGHT
	agent.avoidance_enabled = false
	add_child(agent)

	var ps := load(AssetManifest.OUTFIT_RANGER) as PackedScene
	visual = ps.instantiate()
	visual.name = "ProbeVisual"
	add_child(visual)
	visual.position = Vector3.ZERO          # the visual's origin IS the ground point
	skeleton = RigCorpus.find_skeleton(visual)
	anim = RigCorpus.attach_player(visual, corpus, 0.16)

	# The pack's own imported PBR materials are KEPT. Overriding them with flat
	# colours would discard the quality the validated direction depends on.
	# A soft shadowless read-light travels with the actor so the player is never
	# lost against a moody environment. PROVISIONAL.
	var key := OmniLight3D.new()
	key.name = "HeroReadLight"
	key.light_color = Color(0.92, 0.94, 1.0)
	key.light_energy = 2.2
	key.omni_range = 4.4
	key.omni_attenuation = 1.8
	key.shadow_enabled = false
	key.position = Vector3(0.0, 2.3, 0.8)
	add_child(key)

	# THE SHADOW STAYS AT THE GROUND POINT (CLAUDE.md section 5). It is a child of
	# the ACTOR, not of the visual, so displacing the visual does not move it.
	GroundShadow.attach_to(self, ProdConfig.PLAYER_BODY_RADIUS)

	_play(ProdConfig.CLIP_PLAYER_IDLE, "idle")

func _play(clip: String, design_name: String, speed: float = 1.0) -> void:
	if RigCorpus.play_guarded(anim, clip, speed):
		live_clip = clip
		live_design_name = design_name

# ------------------------------------------------------------------ input ----

## CLICK-TO-MOVE — the canonical mouse scheme.
##
## The commanded point is resolved to the NEAREST NAVIGABLE POINT, and when that
## resolution actually moves the destination the runtime SAYS SO. An off-mesh
## click that is silently dropped, or silently teleported somewhere else, is a
## defect; being redirected and reporting it is the correct behaviour.
func command_move_to(world_point: Vector3) -> Vector3:
	commands_issued += 1
	var map := NavService.map_rid_for(self)
	var snapped := NavService.nearest_point(map, world_point)
	last_command_redirect_m = NavService.planar_distance(snapped, world_point)
	last_command_was_redirected = last_command_redirect_m > 0.10
	if last_command_was_redirected:
		commands_redirected += 1
	move_destination = snapped
	follower.repath(map, global_position, snapped)
	return snapped

func clear_move_destination() -> void:
	move_destination = null

# ----------------------------------------------------------------- physics ---

func _physics_process(delta: float) -> void:
	step(delta)

## Separated from `_physics_process` so the suite can drive exact steps.
func step(delta: float) -> void:
	intent.sample()
	_cooldown = maxf(0.0, _cooldown - delta)

	# --- AIM. Sampled on its own, every frame. Reading it moves nothing. ------
	_update_aim()

	# --- ACTION. Deliberately resolved BEFORE movement. ----------------------
	#
	# An action begun at the END of a frame does not suppress that frame's
	# translation, and one frame at 3.889 m/s is 0.065 m of glide the owner would
	# still be looking at. Beginning the commitment first makes the suppression
	# take effect on the SAME frame the attack starts.
	_update_attack_input()
	_update_action(delta)

	# --- MOVE. Two canonical schemes, one motor, one commitment policy. ------
	if commitment.suppresses_translation():
		# A committed STOP action brakes at its own rate; it does NOT re-read the
		# movement intent, so a held order cannot leak through the action.
		velocity = motor.brake(ProdConfig.ACTION_BRAKE_MPS2, delta)
	else:
		velocity = motor.step(_wish_direction(), ProdConfig.TOP_SPEED_MPS, delta)
	velocity.y = 0.0
	move_and_slide()
	# The simulation is a PLANE. Height is presentation, never a coordinate.
	global_position.y = 0.0

	# --- FACE. Continuous yaw, rate-limited, toward the AIM. -----------------
	#
	# FACING IS NEVER SUPPRESSED, by either policy: a commitment stops the feet,
	# not the head, and the owner's instruction is explicit that the actor may
	# face the sampled aim direction during the action.
	if visual != null and aim_dir.length() > 0.001 and commitment.allows_facing():
		visual.rotation.y = yaw_driver.step(YawDriver.yaw_to(aim_dir), delta)

	_update_locomotion_clip()

func _update_aim() -> void:
	# Controller right stick takes precedence when it is actually deflected;
	# otherwise the cursor. Both write the same field, and NEITHER writes
	# `move_destination`.
	if intent.aim_axis.length() > 0.001:
		var d := Vector3(intent.aim_axis.x, 0.0, intent.aim_axis.y)
		if camera != null:
			var b := camera.locked_basis()
			var fwd := -b.z; fwd.y = 0.0; fwd = fwd.normalized()
			var right := b.x; right.y = 0.0; right = right.normalized()
			d = (right * intent.aim_axis.x + fwd * -intent.aim_axis.y)
		aim_dir = d.normalized()
		aim_point = global_position + aim_dir * 6.0
		return
	if camera != null:
		aim_point = camera.cursor_ground_point(global_position + aim_dir * 6.0)
	var to := aim_point - global_position
	to.y = 0.0
	if to.length() > 0.08:
		aim_dir = to.normalized()

func _wish_direction() -> Vector3:
	# CONTROLLER: the left stick is a direct, camera-relative direction.
	if intent.move_axis.length() > 0.001 and camera != null:
		var b := camera.locked_basis()
		var fwd := -b.z; fwd.y = 0.0; fwd = fwd.normalized()
		var right := b.x; right.y = 0.0; right = right.normalized()
		clear_move_destination()            # a stick input cancels a click order
		return (right * intent.move_axis.x + fwd * -intent.move_axis.y).limit_length(1.0)

	# MOUSE: click-to-move. A held command re-issues toward the cursor, which is
	# how an ARPG's hold-to-move behaves.
	if intent.move_command_held and camera != null:
		command_move_to(camera.cursor_ground_point(global_position))

	if move_destination == null:
		return Vector3.ZERO
	var dest: Vector3 = move_destination
	if NavService.planar_distance(global_position, dest) <= ProdConfig.ARRIVE_TOLERANCE_M:
		clear_move_destination()
		return Vector3.ZERO
	var dir := follower.steer(global_position)
	if dir == Vector3.ZERO:
		# The path ran out before the destination did, which means the order can
		# no longer be served. Clearing it is honest; standing still while a
		# destination is still set would be a lie the overlay would repeat.
		clear_move_destination()
		return Vector3.ZERO
	return dir

func _update_locomotion_clip() -> void:
	if commitment.active:
		return
	var s := motor.speed()
	if s < 0.20:
		_play(ProdConfig.CLIP_PLAYER_IDLE, "idle")
	elif s < ProdConfig.LOCOMOTION_RUN_THRESHOLD_MPS:
		_play(ProdConfig.CLIP_PLAYER_WALK, "walk")
	else:
		_play(ProdConfig.CLIP_PLAYER_RUN, "run")

# ------------------------------------------------- the ONE diagnostic action --

func diagnostic_label() -> String:
	return ProdConfig.DIAG_ATTACK_LABEL

func _update_attack_input() -> void:
	if intent.attack_held and _cooldown <= 0.0 and not debug_freeze_attack \
			and not commitment.active:
		begin_attack()

func _update_action(delta: float) -> void:
	if not commitment.active:
		return
	# MECHANICAL TIMING IS AUTHORITATIVE OVER ANIMATION TIMING.
	#
	# The release marker is a fraction of the ACTION's own normalised time,
	# advanced by the physics delta. The borrowed clip's playback speed cannot
	# move it, and the suite proves that by running the same action at x0.30,
	# x1.0 and x2.50 and measuring the release time each time.
	var dur := commitment.duration
	var ended := commitment.advance(delta)

	# --- RELEASE. Exactly once, at the mechanical marker. --------------------
	if _pending_shot and commitment.elapsed >= dur * commitment.release_marker:
		_pending_shot = false
		debug_release_times.append(commitment.elapsed)
		_release_bolt()

	# --- A SUBSYSTEM'S RELEASE, at the SAME mechanical marker. ---------------
	#
	# Cleared BEFORE the call, so a callable that somehow re-entered could not
	# fire the same release twice. The D-375 Imprint stage uses this; the
	# foundation's own bolt above does not.
	if _pending_release.is_valid() \
			and commitment.elapsed >= dur * commitment.release_marker:
		var cb := _pending_release
		_pending_release = Callable()
		cb.call()

	if ended:
		_shot_aim_dir = Vector3.ZERO     # per-use: nothing survives the use
		# A subsystem release that never fired is DISCARDED rather than carried
		# into the next action, for the same per-use reason.
		_pending_release = Callable()
		# ============================================================
		# RECOVERY ENDS NATURALLY. MOVEMENT DOES NOT RESUME BY ITSELF.
		# ============================================================
		# `move_destination` was cleared when the action began, so there is no
		# stale order to fall back into. From the next frame, `_wish_direction()`
		# reads the intent afresh: a HELD command or a deflected stick issues a
		# NEW order and movement resumes; nothing held means the actor stays put.
		recoveries += 1
		_apply_move_buffer()
		return

	# ============================================================================
	# BEFORE THE RELEASE: BUFFER, NEVER CANCEL.
	# ============================================================================
	# The owner's instruction is exact -- "Do not translate during the wind-up.
	# Do not cancel the attack before it releases. Release the projectile exactly
	# once. THEN cancel the recovery animation and begin the buffered movement."
	#
	# So a movement request in this window is recorded and nothing else happens.
	# `cancel_recovery()` would refuse here anyway; not calling it at all means
	# the refusal is a guard rather than a routine event.
	if not commitment.cancel_window_open():
		_capture_move_buffer()
		return

	# ============================================================================
	# AFTER THE RELEASE: A MOVEMENT REQUEST CANCELS THE REMAINING RECOVERY.
	# ============================================================================
	# THIS CANCELS AN ANIMATION, NOT AN ATTACK. The bolt already exists, is
	# parented to the world and is stepping under its own physics; nothing here
	# touches it, removes it or creates a second one.
	if _movement_requested() or _buffer_kind != "":
		if commitment.cancel_recovery():
			recovery_cancels += 1
			_shot_aim_dir = Vector3.ZERO
			_apply_move_buffer()

## True when the live intent is asking to move, by either canonical scheme.
func _movement_requested() -> bool:
	return intent.move_axis.length() > 0.001 or intent.move_command_held \
		or intent.move_command_just

## Records the NEWEST valid movement intent seen during the wind-up.
func _capture_move_buffer() -> void:
	if intent.move_axis.length() > 0.001:
		_buffer_kind = "stick"
		_buffer_axis = intent.move_axis
		buffered_moves += 1
	elif intent.move_command_held or intent.move_command_just:
		_buffer_kind = "command"
		_buffer_point = camera.cursor_ground_point(global_position) \
			if camera != null else global_position
		buffered_moves += 1

## Applies the buffered intent, if it is still a movement anyone asked for.
##
## A CLICK ORDER AND A STICK ARE DIFFERENT KINDS OF INTENT, and this is the one
## place the difference matters. A click is DISCRETE -- it was issued, so it is
## honoured, exactly as an ARPG buffers a click through an attack. A stick is
## CONTINUOUS -- if it is no longer deflected, the player is no longer asking to
## move, and D-370's rule 5 already says an actor with nothing held stays put.
## Pretending a released stick is a standing order would invent behaviour.
func _apply_move_buffer() -> void:
	if _buffer_kind == "command":
		command_move_to(_buffer_point)
		buffered_applied += 1
	elif _buffer_kind == "stick":
		if intent.move_axis.length() > 0.001:
			buffered_applied += 1      # the live path resumes it on this frame
		else:
			buffered_discarded += 1
	_buffer_kind = ""
	_buffer_axis = Vector2.ZERO

## ============================================================================
## COMMIT AN ACTION ON BEHALF OF A SUBSYSTEM, USING THE ACCEPTED COMMITMENT.
## ============================================================================
## Deliberately NOT named `begin_*`: this is not an attack and it declares none.
## It is the plumbing that lets the D-375 Imprint stage reuse the STOP / ALLOW
## architecture and the recovery cancellation D-373 ACCEPTED, instead of
## inventing a second commitment that could drift away from it.
##
## It adds NO new policy, NO new cancel window and NO new tunable. The duration
## and the release marker are supplied by the caller, and the marker the Imprint
## stage supplies is the ACCEPTED `ProdConfig.ATTACK_RELEASE_MARKER`.
func commit_subsystem_action(label: String, duration: float, marker: float,
		on_release: Callable) -> bool:
	if commitment.active:
		return false
	_pending_release = on_release
	commitment.begin(label, duration, marker, ActionCommitment.Movement.STOP)
	# THE NAVIGATION ORDER IS ABANDONED, NOT PAUSED -- the same rule the
	# foundation's own action follows, for the same reason.
	clear_move_destination()
	follower.set_path(PackedVector3Array())
	_buffer_kind = ""
	_buffer_axis = Vector2.ZERO
	return true

func begin_attack() -> void:
	_cooldown = ProdConfig.ATTACK_COOLDOWN_S
	_pending_shot = true
	# TARGETING IS PER-USE. The aim is sampled HERE, when this use begins, and
	# is used by this use alone.
	_shot_aim_dir = aim_dir
	# ENTER THE COMMITTED STATE. The policy is STOP: this action suppresses
	# translation for its whole duration. It is a DIAGNOSTIC action, not a Skill.
	commitment.begin(ProdConfig.DIAG_ATTACK_DESIGN_NAME, ProdConfig.ATTACK_COOLDOWN_S,
		ProdConfig.ATTACK_RELEASE_MARKER, ActionCommitment.Movement.STOP)
	# THE NAVIGATION ORDER IS ABANDONED, NOT PAUSED.
	#
	# The owner's rule: after recovery, "do not resume an obsolete navigation
	# path". Clearing it here is the only way to be sure — a destination kept
	# across the action is exactly the thing that would silently restart.
	clear_move_destination()
	follower.set_path(PackedVector3Array())
	_buffer_kind = ""
	_buffer_axis = Vector2.ZERO
	_play(ProdConfig.CLIP_PLAYER_ATTACK, ProdConfig.DIAG_ATTACK_DESIGN_NAME)

func _release_bolt() -> void:
	if bolt_parent == null:
		return
	var dir := _shot_aim_dir
	if dir.length() < 0.001:
		dir = aim_dir
	var b := DiagnosticBolt.new()
	b.build(dir)
	bolt_parent.add_child(b)
	var muzzle := global_position + Vector3(0, 1.15, 0) + dir * 0.45
	b.global_position = muzzle
	shots_fired += 1
	shot_dirs.append(dir)
	bolt_released.emit(muzzle, dir)

## The ground point, stated as a function so no caller is ever tempted to read
## the visual instead.
func ground_point() -> Vector3:
	return global_position

## The probe takes damage so the enemy's committed shape has a real consequence.
## There is NO death, respawn, penalty or recovery model here -- DEATH AND
## RECOVERY is canonical design this foundation is not authorized to implement.
func receive_damage(amount: float, from: Vector3) -> void:
	life.apply(amount, from)
