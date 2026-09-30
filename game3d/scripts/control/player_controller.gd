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
##   (D-404: "owns navigation" was true when written. Since D-404 a MOUSE order
##   asks navigation for NOTHING -- it goes straight at the clicked point and
##   stops at the first blocker, through `DirectClickOrder`. The stick, enemies,
##   hounds and the cohort are unchanged.)
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
## (True when written, at D-370. Since D-385 her canonical specification exists
## in design/, and since D-392 this controller carries her through the Huntress
## runtime: a PLACEHOLDER bow and placeholder animation drawn by a separate layer,
## and Splinter Shot used through the Imprint architecture. THIS FILE still
## defines no class mechanic; its one addition is the facing seam below.)

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
## D-404: RETAINED, INERT (DD-18). The player never gives it a path any more;
## accepted fixtures in five suites call its `set_path()` to clear it, and the
## accepted L22 reads its advance tolerance. Until D-404 every click order was
## routed through it -- true when written.
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
## D-404: A CLICK IS NEVER REDIRECTED ANY MORE, so these three are ALWAYS false /
## 0.0 / 0. They are kept, not deleted, because the overlay and accepted checks
## read them -- and reading false there is the truth. Until D-404 an order was
## resolved to the nearest navigable point and a redirect of more than 0.10 m
## was reported here: true when written.
var last_command_was_redirected: bool = false
var last_command_redirect_m: float = 0.0
var commands_issued: int = 0
var commands_redirected: int = 0

## ============================================================================
## D-404: THE DIRECT-CLICK ORDER. A MOUSE ORDER GOES STRAIGHT AND STOPS AT THE
## FIRST BLOCKER.
## ============================================================================
## The owner: "I want the player to move directly toward the clicked point and
## run into the obstacle. The player should have to issue additional movement
## clicks to navigate around it." `click_order` holds the current order's state
## and logs; `DirectClickOrder.sweep()` is the one place a click step meets the
## world. THE STICK IS UNCHANGED and still slides along walls, as accepted.
var click_order := DirectClickOrder.new()
## True for the ONE physics step `_wish_direction()` returned a click direction
## in. Read once by `step()` to choose the click sweep over `move_and_slide()`.
var _click_step: bool = false
## The contacts the LAST blocked click order stopped against, and where she
## stood. While she is still there (DirectClickConfig.CONTACT_HOLD_M), an order
## pointing INTO one of them stops at once -- which is what stops a held cursor
## from creeping along a wall by the engine's collision margin every frame.
var _contacts: Array[Dictionary] = []
var _contact_at: Vector3 = Vector3.ZERO

## Diagnostics the suite reads. These are LOGS, not control state.
##
## D-400: `last_wish` is the direction the motor was asked for on the last step --
## a LOG of what was commanded, written after the wish is resolved and read by
## nothing in gameplay. It exists so a check can compare the COMMANDED direction
## with the RESULTING velocity on the SAME frame, which is the whole claim the
## redirection makes; deriving it a second time in the suite would be comparing
## the suite's arithmetic with itself.
var last_wish: Vector3 = Vector3.ZERO
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

## ============================================================================
## D-398: THE ONE DIAGNOSTIC TRAVEL-SPEED SEAM. 1.0 IN NORMAL PLAY.
## ============================================================================
## The owner's D-398 ruling asks for "provisional travel-speed modes representing
## ordinary, fast and extreme late-game movement" so the mobile-minion cohort can
## be judged at speed. `CohortDiagnostics` is the ONLY writer; it scales the
## ACCEPTED top speed for the owner's review. `ProdConfig.TOP_SPEED_MPS` is NOT
## changed -- 3.889 m/s stays D-367's provisional starting candidate -- and at 1.0
## this controller moves exactly as accepted. It is NOT a movement Skill.
var diagnostic_travel_speed_scale: float = 1.0

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
	# D-404: STILL KEPT, and for a MEASURED reason -- the accepted F70 reads its
	# radius -- but it is given NO target and routes NOTHING (DD-17). Since D-404
	# a mouse order does not steer by the PathFollower either.
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

## CLICK-TO-MOVE — the canonical mouse scheme. D-404: DIRECT, NOT ROUTED.
##
## ============================================================================
## THE CLICKED POINT IS THE DESTINATION. NOTHING IS SNAPPED OR ROUTED.
## ============================================================================
## Until D-404 this read -- TRUE WHEN WRITTEN, and accepted under D-373:
##     var map := NavService.map_rid_for(self)
##     var snapped := NavService.nearest_point(map, world_point)
##     ... report the redirect ...
##     move_destination = snapped
##     follower.repath(map, global_position, snapped)
## -- "The commanded point is resolved to the NEAREST NAVIGABLE POINT", and the
## order followed a navigation path round anything in the way. The owner's D-404
## ruling ends both: "Store the actual clicked ground point as the destination.
## Do not snap that destination to the nearest navigation point. Do not ask
## NavigationServer3D for a player path. Do not feed the order through
## NavService.PathFollower."
##
## An off-mesh click is therefore NOT dropped and NOT moved: it is stored exactly,
## and she walks straight at it until something stops her.
func command_move_to(world_point: Vector3) -> Vector3:
	commands_issued += 1
	var dest := Vector3(world_point.x, 0.0, world_point.z)
	last_command_redirect_m = 0.0
	last_command_was_redirected = false
	move_destination = dest
	click_order.begin(global_position, dest)
	return dest

func clear_move_destination() -> void:
	move_destination = null
	# D-404: an order cleared by anything other than its own arrival or collision
	# -- a stick input, an action beginning, a fixture -- was CANCELLED.
	if click_order.active:
		click_order.finish(DirectClickOrder.STOP_CANCELLED)

# ----------------------------------------------------------------- physics ---

func _physics_process(delta: float) -> void:
	step(delta)

## Separated from `_physics_process` so the suite can drive exact steps.
func step(delta: float) -> void:
	intent.sample()
	_cooldown = maxf(0.0, _cooldown - delta)
	_click_step = false

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
		# D-400 LEAVES THIS RATE EXACTLY AS ACCEPTED (LD-02).
		velocity = motor.brake(ProdConfig.ACTION_BRAKE_MPS2, delta)
	else:
		# ================================================================
		# D-400: THE WISH IS RESOLVED FIRST, THEN THE CEILING IS READ.
		# ================================================================
		# `_wish_direction()` has SIDE EFFECTS -- it issues a held click order,
		# clears an order that has arrived, and clears one whose path ran out --
		# and `_arrival_speed_cap()` reads exactly that state. Leaving both in one
		# argument list would make the behaviour depend on GDScript's evaluation
		# order, which is not a property to rely on. So they are two statements,
		# in the order the meaning requires.
		var top: float = ProdConfig.TOP_SPEED_MPS * diagnostic_travel_speed_scale
		var wish := _wish_direction()
		last_wish = wish
		velocity = motor.step(wish, top, delta, _arrival_speed_cap(top))
	velocity.y = 0.0
	# ========================================================================
	# D-404: A CLICK STEP SWEEPS STRAIGHT AND STOPS AT THE FIRST BLOCKER.
	# ========================================================================
	# Everything else -- the stick, a committed action's brake, and ordinary
	# braking after an order ends -- still resolves collision with the ACCEPTED
	# `move_and_slide()` below, exactly as before. Until D-404 every step did.
	if _click_step:
		_direct_click_step(delta)
	else:
		move_and_slide()
	# The simulation is a PLANE. Height is presentation, never a coordinate.
	global_position.y = 0.0

	# --- FACE. Continuous yaw, rate-limited, toward the AIM. -----------------
	#
	# FACING IS NEVER SUPPRESSED, by either policy: a commitment stops the feet,
	# not the head, and the owner's instruction is explicit that the actor may
	# face the sampled aim direction during the action.
	#
	# D-392: WHILE A SUBSYSTEM HOLDS FACING, the same rate-limited yaw turns
	# toward the HELD (mechanical) facing instead of the live aim. With no hold --
	# the diagnostic bolt, and all locomotion -- this is exactly the accepted
	# behaviour: `F73` is untouched.
	if visual != null and commitment.allows_facing():
		if _facing_hold_active:
			visual.rotation.y = yaw_driver.step(_facing_hold_yaw, delta)
		elif aim_dir.length() > 0.001:
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
		click_order.finish(DirectClickOrder.STOP_ARRIVED)
		clear_move_destination()
		return Vector3.ZERO
	# ========================================================================
	# D-404: STRAIGHT AT THE CLICKED POINT, RE-DERIVED FROM WHERE SHE IS NOW.
	# ========================================================================
	# Until D-404 this read `var dir := follower.steer(global_position)` and
	# cleared the order when the path ran out -- TRUE WHEN WRITTEN. There is no
	# path now: the direction is the straight line from her ground point to the
	# clicked one, every step.
	var dir := dest - global_position
	dir.y = 0.0
	dir = dir.normalized()
	# ALREADY AGAINST A BLOCKER SHE IS POINTING INTO: the order stops here, and
	# she does not move. A held cursor behind a wall re-issues this every frame,
	# and every frame it stops -- no creeping, no oscillation, no routing.
	var held_contact := _into_remembered_contact(dir)
	if not held_contact.is_empty():
		click_order.record_contact(held_contact["point"], held_contact["normal"], String(held_contact["collider"]))
		click_order.stopped_at_existing_contact = true
		_stop_click_order_at_contact()
		return Vector3.ZERO
	_click_step = true
	return dir

## ============================================================================
## THE ARRIVAL SPEED CAP — D-400 item 10, AND IT INTRODUCES NO TUNABLE.
## ============================================================================
## "Prevent destination overshoot ... at every diagnostic speed." At the accepted
## speed the actor already stops inside the accepted arrival tolerance; at the
## D-398 EXTREME diagnostic speed its braking distance is longer than that
## tolerance, so without a cap it would run past the point it was sent to.
##
## The cap is the fastest speed from which the ORDINARY acceleration rate can
## still bring the actor to rest inside the distance that is actually left --
## `GroundMotion.arrival_speed_ceiling`. Both inputs already exist: the rate is
## the registered one, and the distance is the follower's OWN remaining path
## length, which follows the corners rather than cutting across them. NOTHING NEW
## IS TUNED HERE, and at the accepted speed the cap never binds at all.
##
## Returns a NEGATIVE value when there is no order, meaning "no cap".
func _arrival_speed_cap(top: float) -> float:
	if move_destination == null:
		return -1.0
	var dest: Vector3 = move_destination
	# D-404: THE DISTANCE LEFT IS THE STRAIGHT DISTANCE, because a click order now
	# goes straight. Until D-404 this read the follower's remaining PATH length and
	# fell back to exactly this whenever the follower had no path -- true when
	# written. The ceiling itself is the accepted one, and introduces nothing.
	var remaining := NavService.planar_distance(global_position, dest)
	return minf(top, GroundMotion.arrival_speed_ceiling(remaining, top))

## ============================================================================
## D-404: ONE CLICK STEP, AND HOW IT ENDS AT A BLOCKER.
## ============================================================================
## The motor has already produced this step's velocity by the ACCEPTED
## arithmetic. This moves the body along it with one continuous sweep; if
## anything blocks it, the order ends AT the contact, the order is cleared, and
## she is at rest -- no slide, no reroute, no carry-over into the next frame.
##
## SETTING THE MOTOR TO REST HERE IS A COLLISION, NOT A BRAKE. It is not the
## ACTION brake, which D-401 forbids replacing with an instantaneous speed clear
## and which is untouched: a committed action never reaches this function,
## because `step()` sends it to `motor.brake()` and `move_and_slide()`.
func _direct_click_step(delta: float) -> void:
	var r := DirectClickOrder.sweep(self, velocity * delta)
	click_order.sweeps += int(r["sweeps"])
	if int(r["sweeps"]) > 1:
		click_order.floor_resweeps += int(r["sweeps"]) - 1
	click_order.travelled_m += Vector3(r["moved"]).length()
	if not bool(r["blocked"]):
		return
	var n := Vector3(r["normal"])
	n.y = 0.0
	n = n.normalized()
	click_order.record_contact(Vector3(r["point"]), n, String(r["collider"]))
	# Remember it. A second contact at the SAME spot (a corner) is added to the
	# first; a contact anywhere else replaces them.
	var here := Vector3(global_position.x, 0.0, global_position.z)
	if _contacts.is_empty() or NavService.planar_distance(here, _contact_at) > DirectClickConfig.CONTACT_HOLD_M:
		_contacts.clear()
	_contact_at = here
	_contacts.append({"normal": n, "point": Vector3(r["point"]), "collider": String(r["collider"])})
	_stop_click_order_at_contact()

## The order ends at the contact: cleared, COLLIDED, and at rest.
func _stop_click_order_at_contact() -> void:
	click_order.finish(DirectClickOrder.STOP_COLLIDED)
	move_destination = null
	motor.reset()
	velocity = Vector3.ZERO

## The remembered contact a direction points INTO, if she is still where she was
## stopped against it; otherwise an empty Dictionary. A direction exactly
## parallel to the wall, or away from it, is not into it -- and moves.
func _into_remembered_contact(dir: Vector3) -> Dictionary:
	if _contacts.is_empty():
		return {}
	var here := Vector3(global_position.x, 0.0, global_position.z)
	if NavService.planar_distance(here, _contact_at) > DirectClickConfig.CONTACT_HOLD_M:
		_contacts.clear()
		return {}
	for c in _contacts:
		if dir.dot(Vector3(c["normal"])) < -DirectClickConfig.INTO_EPSILON:
			return c
	return {}

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

## ============================================================================
## THE FACING HOLD — A SEAM FOR A SUBSYSTEM, ADDED UNDER D-392.
## ============================================================================
## The owner's D-391 ruling 2 for Splinter Shot: "Facing snaps mechanically to
## the sampled aim when Splinter Shot begins. The attack does not wait for a
## separate turning phase. Visual rotation may blend, but Huntress must visibly
## align before release. Aim and facing remain fixed through release; normal
## control resumes after release or recovery cancellation."
##
## Until D-392 this controller had ONE facing -- the rate-limited visual yaw,
## turning toward the LIVE aim even during a committed action (`F73`) -- and no
## mechanical facing at all: true when written, and still exactly what happens
## with no hold. The hold adds the MECHANICAL facing as a separate quantity:
##   * `hold_facing(yaw)` -- the mechanical facing SNAPS to `yaw` on this call;
##     the VISUAL keeps blending toward it at the ACCEPTED rate (no second rate);
##   * `release_facing_hold()` -- normal control resumes.
## It is the same kind of seam D-375 added (`commit_subsystem_action`): it adds
## no policy, no cancel window and no tunable, and nothing here decides WHEN to
## hold -- the Skill that needs it does. It is NOT named `begin_*`: it is not an
## attack entry point, and `F51` still counts exactly one.
var _facing_hold_active: bool = false
var _facing_hold_yaw: float = 0.0
var facing_holds: int = 0

func hold_facing(yaw: float) -> void:
	_facing_hold_active = true
	_facing_hold_yaw = wrapf(yaw, -PI, PI)
	facing_holds += 1

func release_facing_hold() -> void:
	_facing_hold_active = false

func facing_hold_active() -> bool:
	return _facing_hold_active

## The MECHANICAL facing: the held yaw while a hold is active; otherwise the live
## aim's yaw, which the visual follows at the accepted rate.
func mechanical_facing_yaw() -> float:
	if _facing_hold_active:
		return _facing_hold_yaw
	return YawDriver.yaw_to(aim_dir)

## The ground point, stated as a function so no caller is ever tempted to read
## the visual instead.
func ground_point() -> Vector3:
	return global_position

## The probe takes damage so the enemy's committed shape has a real consequence.
## There is NO death, respawn, penalty or recovery model here -- DEATH AND
## RECOVERY is canonical design this foundation is not authorized to implement.
func receive_damage(amount: float, from: Vector3) -> void:
	life.apply(amount, from)
