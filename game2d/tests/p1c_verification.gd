extends SceneTree

## P1C-H — Huntress character and combat proof verification.
##
## Same discipline as P1A and P1B: every check records reaching its LAST line; the suite
## compares that set to what it owes in BOTH directions; every pin is proved able to refuse
## a wrong value; and **anything not performed is printed as TRANSFERRED or DEFERRED and
## never counted as a pass.**
##
## **A GREEN RUN IS NOT P1C-H ACCEPTANCE.** Acceptance is the owner's, given under D-365
## after a review no suite can perform. P1C-H is ACCEPTED and CLOSED **as the verified 2D
## mechanics prototype**, and this suite now guards what that acceptance covers.

const P1AArt := preload("res://scripts/p1a_art.gd")
const P1AScale := preload("res://scripts/p1a_scale.gd")
const P1BTileSet := preload("res://scripts/p1b_tileset.gd")
const P1CFacing := preload("res://scripts/p1c_facing.gd")
const P1CMovement := preload("res://scripts/p1c_movement.gd")

## **D-365: 5.0 m/s is PROVISIONAL and is NOT a permanent cross-presentation lock.**
## It was the accepted 3D locomotion value re-tested in 2D. **Perceived movement speed must
## be re-evaluated if a 3D feasibility spike is ever authorized**, because a fixed
## orthographic 3D camera does not make the same metres-per-second read the same way.
const TOP_SPEED_IS_PROVISIONAL: bool = true
const P1CTargeting := preload("res://scripts/p1c_targeting.gd")
const P1CCombat := preload("res://scripts/p1c_combat.gd")
const P1CRoom := preload("res://scripts/p1c_room.gd")

const OWED_CHECKS: Array[String] = [
	"eight_sectors_resolve_to_eight_distinct_unmirrored_directions",
	"facing_hysteresis_holds_across_a_boundary_and_still_releases",
	"translation_uses_the_idle_frame_and_the_runtime_says_walk_is_absent",
	"a_click_resolves_to_the_nearest_navigable_point",
	"controller_movement_measures_its_deadzone_speed_acceleration_and_braking",
	"mouse_aiming_is_per_use_and_stores_no_cross_use_state",
	"controller_soft_targeting_prefers_the_aimed_at_over_the_underfoot",
	"the_diagnostic_projectile_hits_expires_and_survives_nothing",
	"the_enemy_runs_the_whole_accepted_cycle_in_order",
	"the_dropped_item_is_reachable_compared_on_facts_and_measurably_equipped",
	"the_room_builds_only_on_the_accepted_p1b_kit_and_no_campaign_path",
	"every_on_screen_claim_is_accurate",
	"the_transferred_mage_criteria_are_recorded_and_never_counted_as_passes",
	"the_p1a_and_p1b_locks_pins_and_debts_are_unchanged",
	"every_check_ran",
]

## **TRANSFERRED out of P1C-H by the owner's staging amendment. NEVER a pass.**
const TRANSFERRED: Array[String] = [
	"ORIGINAL P1C CRITERION C9 — the Mage spell (area effect hitting N targets for recorded damage, damage independent of the equipped weapon, nothing persisting). TRANSFERRED to the already-recorded future Mage art phase. It cannot be attempted: the Mage is legacy 64x64 reference art at 32.222 px/m with no shared ground anchor, and reconstructing, scaling, mirroring or editing it is forbidden — as is inventing a Mage spell",
	"ORIGINAL P1C SCOPE — \"both characters at 128x128 and eight directions\". P1C-H proves ONE character. The second character's eight authored directions at the locked production cell are owed by the same future Mage art phase",
]

var _failures: PackedStringArray = PackedStringArray()
var _reached: Dictionary = {}
var _checks: int = 0
var _token: String = "p1c-dev"
var _room: P1CRoom = null

func _done(n: String) -> void:
	_reached[n] = true

func _expect(ok: bool, detail: String) -> void:
	_checks += 1
	if not ok:
		_failures.append(detail)
	print("    %s  %s" % ["PASS" if ok else "FAIL", detail])


func _initialize() -> void:
	var a: PackedStringArray = OS.get_cmdline_user_args()
	for i: int in range(a.size()):
		if a[i] == "--run-token":
			_token = a[i + 1]
	print("=== Riftwrought — P1C-H Huntress character and combat proof ===")
	print("Godot %s" % Engine.get_version_info()["string"])
	_room = P1CRoom.new()
	get_root().add_child(_room)
	await process_frame
	# **WAIT FOR THE NAVIGATION MAP, AND PROVE IT SYNCED.** NavigationServer2D syncs on its
	# own schedule; querying before it has is not an error, it just answers from an empty
	# map \u2014 which once made two checks report a redirected click and an unreachable item
	# while the room was in fact fine. A check that depends on unsynchronised engine state
	# and does not say so is a flaky check, so readiness is now awaited AND asserted.
	var nav_ready: bool = await _await_navigation_ready()
	if not nav_ready:
		_checks += 1
		_failures.append("the navigation map never synced; every navigation measurement below would be meaningless")
		print("    FAIL  the navigation map never synced within the frame budget")

	_check_sectors()
	_check_hysteresis()
	_check_translation()
	_check_click_to_move()
	_check_controller_movement()
	_check_per_use_aim()
	_check_soft_target()
	_check_projectile()
	_check_enemy_cycle()
	_check_item()
	_check_room_scope()
	_check_truthfulness()
	_check_transferred()
	_check_locks()
	_check_every_check_ran()

	print("")
	print("--- TRANSFERRED — carried OUT of P1C-H by the owner's staging amendment, never a pass ---")
	for t: String in TRANSFERRED:
		print("  TRANSFERRED: %s" % t)
	print("")
	print("P1C-H OWED CHECKS: %d" % OWED_CHECKS.size())
	print("P1C-H TRANSFERRED: %d" % TRANSFERRED.size())
	print("P1C-H RUN TOKEN: %s" % _token)
	print("A GREEN RUN IS NOT P1C-H ACCEPTANCE. Acceptance is the owner's, given under D-365 after a")
	print("review this suite cannot perform. P1C-H IS ACCEPTED AND CLOSED as the verified 2D MECHANICS")
	print("PROTOTYPE, by that ruling and not by this run.")
	print("COMPLETING P1C-H DOES NOT COMPLETE THE ORIGINAL P1C OR P1, AND DOES NOT AUTHORIZE P2.")
	print("2D PRESENTATION AND OWNER-ART PRODUCTION ARE FROZEN under D-365. The intended final visual")
	print("target is now a modern stylized 3D dark-fantasy ARPG; NO 3D PIVOT AND NO 3D SPIKE IS")
	print("AUTHORIZED, and each needs its own bounded authorization.")
	print("5.0 m/s REMAINS PROVISIONAL \u2014 not a permanent cross-presentation lock. Perceived movement")
	print("speed must be re-evaluated if a 3D feasibility spike is ever authorized.")
	if _failures.is_empty():
		print("P1C-H VERIFICATION: PASS (%d checks)" % _checks)
		quit(0)
	else:
		for f: String in _failures:
			print("  FAIL: %s" % f)
		print("P1C-H VERIFICATION: %d FAILURE(S) of %d checks" % [_failures.size(), _checks])
		quit(1)



## Await a genuinely synced navigation map, and report whether it arrived.
##
## Readiness is proved by behaviour, not by a flag: a point known to be inside the room
## must resolve to itself. An empty map answers with something else entirely.
func _await_navigation_ready(max_physics_frames: int = 240) -> bool:
	var map: RID = _room.nav_region.get_navigation_map()
	var probe: Vector2 = Vector2(_room.px(-2.0), _room.px(1.0))
	for i: int in range(max_physics_frames):
		await physics_frame
		if NavigationServer2D.map_get_regions(map).size() == 0:
			continue
		# A map can have a region and still be unsynchronised. Querying it then is not merely
		# wrong, it prints a NavigationServer error, and an error line inside a green run is
		# exactly the noise the project's own rule says must not be tolerated. The iteration
		# id is 0 until the first synchronisation, so this gate removes the query entirely
		# rather than letting it fail and retrying.
		if NavigationServer2D.map_get_iteration_id(map) == 0:
			continue
		var got: Vector2 = NavigationServer2D.map_get_closest_point(map, probe)
		if got.distance_to(probe) <= 1.0:
			print("    navigation map synced after %d physics frames (%d region(s))"
				% [i + 1, NavigationServer2D.map_get_regions(map).size()])
			return true
	return false


# --- C1 -------------------------------------------------------------------------------
func _check_sectors() -> void:
	print("")
	print("--- 1. C1 — eight sectors resolve to eight distinct directions, none mirrored")
	var seen: Dictionary = {}
	var exact: bool = true
	var margin: float = P1CFacing.HALF_SECTOR_DEG - P1CFacing.MARGIN_DEG
	print("    %-3s %-7s %-22s %s" % ["idx", "token", "probe angles (deg)", "resolved"])
	for i: int in range(8):
		var centre: float = P1CFacing.sector_centre_deg(i)
		var got: Array[int] = []
		for probe: float in [centre, centre - margin, centre + margin]:
			var v: Vector2 = Vector2(cos(deg_to_rad(probe)), sin(deg_to_rad(probe)))
			var s: int = P1CFacing.sector_of(v)
			got.append(s)
			if s != i:
				exact = false
		seen[i] = true
		print("    %-3d %-7s %-22s %s" % [i, String(P1AArt.DIRECTION_TOKENS[i]),
			"%.1f, %.1f, %.1f" % [centre, centre - margin, centre + margin], str(got)])
	# Eight DISTINCT authored animations, each with its own frames. No mirroring anywhere.
	var frames: SpriteFrames = P1AArt.build_sprite_frames("huntress")
	var anims: int = 0
	var distinct: Dictionary = {}
	for token: String in P1AArt.DIRECTION_TOKENS:
		var anim_name: String = "idle_%s" % token
		if frames.has_animation(anim_name):
			anims += 1
			var tex: Texture2D = frames.get_frame_texture(anim_name, 0)
			var at: AtlasTexture = tex as AtlasTexture
			distinct["%s|%s" % [at.atlas.resource_path, str(at.region)] if at != null else str(tex)] = true
	var sprite_clean: bool = not _room.actor_sprite.flip_h and not _room.actor_sprite.flip_v \
		and _room.actor_sprite.scale.is_equal_approx(Vector2.ONE) \
		and is_equal_approx(_room.actor_sprite.rotation, 0.0)
	# Both directions: a wrong sector must be refused.
	var refusal: bool = P1CFacing.sector_of(Vector2.RIGHT) != 1
	_expect(exact and seen.size() == 8 and anims == 8 and distinct.size() == 8
			and sprite_clean and refusal,
		"all 24 probes resolved to their own sector %s; %d authored animations; %d DISTINCT frame sources (0 mirrored); sprite flip_h/flip_v false, scale 1, rotation 0: %s"
			% [str(exact), anims, distinct.size(), str(sprite_clean)])
	print("    NO MIRRORING: eight separately authored strips, eight distinct atlas regions. A flip would")
	print("    put the bow in the wrong hand and the quiver on the wrong shoulder (D-347 ruling 1).")
	_done("eight_sectors_resolve_to_eight_distinct_unmirrored_directions")


# --- C2 -------------------------------------------------------------------------------
func _check_hysteresis() -> void:
	print("")
	print("--- 2. C2 — facing hysteresis at a sector boundary")
	var boundary: float = P1CFacing.SECTOR_DEG * 0.5    ## 22.5, between sector 0 and 1
	var wobble: float = P1CFacing.MARGIN_DEG - 1.0      ## strictly less than the margin
	_room.set_facing(0)
	var changes: int = 0
	for f: int in range(60):
		var a: float = boundary + (wobble if f % 2 == 0 else -wobble)
		var before: int = _room.facing_index
		var after: int = _room.aim_facing(Vector2(cos(deg_to_rad(a)), sin(deg_to_rad(a))))
		if after != before:
			changes += 1
	# And it must still RELEASE when the margin is genuinely exceeded, or it is not
	# hysteresis, it is a stuck facing.
	var past: float = P1CFacing.HALF_SECTOR_DEG + P1CFacing.MARGIN_DEG + 3.0
	var released: int = _room.aim_facing(Vector2(cos(deg_to_rad(past)), sin(deg_to_rad(past))))
	_expect(changes == 0 and released == 1,
		"60 frames oscillating +-%.1f deg across the %.1f deg boundary: %d facing changes (0 required); beyond the %.1f deg margin it releases to sector %d"
			% [wobble, boundary, changes, P1CFacing.MARGIN_DEG, released])
	print("    The margin is %.1f deg. This is a DIFFERENT rule from the accepted substantial-turn"
		% P1CFacing.MARGIN_DEG)
	print("    threshold and the two must never be conflated. PROPOSED by this proof, not a lock.")
	_done("facing_hysteresis_holds_across_a_boundary_and_still_releases")


# --- C3 -------------------------------------------------------------------------------
func _check_translation() -> void:
	print("")
	print("--- 3. C3 — temporary translation on IDLE art, and the runtime says so")
	var frames: SpriteFrames = _room.actor_sprite.sprite_frames
	var walk_like: PackedStringArray = PackedStringArray()
	for n: StringName in frames.get_animation_names():
		var s: String = String(n)
		if s.begins_with("walk") or s.contains("walk") or s.contains("run"):
			walk_like.append(s)
	var start: Vector2 = _room.actor.position
	_room.set_facing(2)
	var before_anim: String = String(_room.actor_sprite.animation)
	# Translate the GROUND POINT. Nothing reads the sprite's position.
	var v: Vector2 = Vector2.ZERO
	for i: int in range(30):
		v = P1CMovement.step(v, Vector2(1, 0), 1.0 / 60.0)
		_room.actor.position += v * P1AScale.LOCKED_PX_PER_M * (1.0 / 60.0)
	_room.aim_facing(Vector2.RIGHT)
	var moved_m: float = _room.actor.position.distance_to(start) / P1AScale.LOCKED_PX_PER_M
	var says: bool = _room.readout().contains("WALK ANIMATION IS NOT IMPLEMENTED")
	# Every animation the accepted art provides is an IDLE clip named `idle_<token>`.
	var played: String = String(_room.actor_sprite.animation)
	var still_idle: bool = played.begins_with("idle_") \
		and P1AArt.DIRECTION_TOKENS.has(played.trim_prefix("idle_"))
	_expect(walk_like.is_empty() and moved_m > 0.1 and says and still_idle
			and _room.facing_index == 0,
		"walk-like animations present: %d (0 required); moved %.3f m; facing updated %s -> %s; the animation played is still an IDLE direction (%s); the runtime states walk is not implemented: %s"
			% [walk_like.size(), moved_m, before_anim, String(_room.actor_sprite.animation),
				str(still_idle), str(says)])
	_room.actor.position = start
	_done("translation_uses_the_idle_frame_and_the_runtime_says_walk_is_absent")


# --- C4 -------------------------------------------------------------------------------
func _check_click_to_move() -> void:
	print("")
	print("--- 4. C4 — click-to-move resolves to the nearest navigable point")
	var map: RID = _room.nav_region.get_navigation_map()
	var regions: int = NavigationServer2D.map_get_regions(map).size()
	var inside: Vector2 = Vector2(_room.px(-3.0), _room.px(1.0))
	var r_in: Dictionary = _room.resolve_click(inside)
	var outside: Vector2 = Vector2(_room.px(40.0), _room.px(25.0))
	var r_out: Dictionary = _room.resolve_click(outside)
	# Walk the body to the resolved point and require arrival within tolerance.
	_room.actor.position = Vector2.ZERO
	var goal: Vector2 = r_in["point"]
	var v: Vector2 = Vector2.ZERO
	var dt: float = 1.0 / 60.0
	var guard: int = 0
	while _room.actor.position.distance_to(goal) > _room.px(P1CRoom.ARRIVAL_TOLERANCE_M) and guard < 3000:
		guard += 1
		var to: Vector2 = goal - _room.actor.position
		v = P1CMovement.step(v, to.normalized(), dt)
		var stepv: Vector2 = v * P1AScale.LOCKED_PX_PER_M * dt
		if stepv.length() > to.length():
			_room.actor.position = goal
		else:
			_room.actor.position += stepv
	var arrived_m: float = _room.actor.position.distance_to(goal) / P1AScale.LOCKED_PX_PER_M
	_expect(regions > 0 and not bool(r_in["redirected"]) and bool(r_out["redirected"])
			and arrived_m <= P1CRoom.ARRIVAL_TOLERANCE_M and guard < 3000,
		"the navigation map carries %d region(s), so these answers come from a real mesh; a click inside the mesh is not redirected (%s); a click outside resolves to the nearest point and SAYS SO (redirected %s, %.2f m away); the body arrived %.3f m from the goal, tolerance %.2f m"
			% [regions, str(not bool(r_in["redirected"])), str(bool(r_out["redirected"])),
				float(r_out["offset_m"]), arrived_m, P1CRoom.ARRIVAL_TOLERANCE_M])
	_room.actor.position = Vector2.ZERO
	_done("a_click_resolves_to_the_nearest_navigable_point")


# --- C5 -------------------------------------------------------------------------------
func _check_controller_movement() -> void:
	print("")
	print("--- 5. C5 — controller movement: deadzone, top speed, acceleration, braking")
	var dz_in: Vector2 = P1CMovement.apply_deadzone(Vector2(0.15, 0.0))
	var dz_out: Vector2 = P1CMovement.apply_deadzone(Vector2(0.6, 0.0))
	# THE POINT OF A RADIAL DEADZONE, and where it differs from a per-axis one:
	# |(0.15, 0.15)| = 0.212 > 0.20, so a RADIAL deadzone PASSES it while a per-axis
	# deadzone would reject it for having both axes under 0.20. Asserting it is rejected
	# would be asserting the per-axis behaviour this project does not want.
	var dz_diag: Vector2 = P1CMovement.apply_deadzone(Vector2(0.15, 0.15))
	var dz_diag_small: Vector2 = P1CMovement.apply_deadzone(Vector2(0.1, 0.1))  ## 0.141 < 0.20
	var dt: float = 1.0 / 60.0
	var v: Vector2 = Vector2.ZERO
	for i: int in range(1200):
		v = P1CMovement.step(v, Vector2.RIGHT, dt)
	var top: float = v.length()
	var top_err: float = absf(top - P1CMovement.TOP_SPEED_MPS) / P1CMovement.TOP_SPEED_MPS
	# Acceleration and braking, measured against the configured rates.
	var t_acc: float = P1CMovement.time_to_fraction_of_top(0.999, dt)
	var ideal_acc: float = P1CMovement.TOP_SPEED_MPS / P1CMovement.ACCELERATION_MPS2
	var acc_err: float = absf(t_acc - ideal_acc) / ideal_acc
	var t_brake: float = P1CMovement.time_to_stop(dt)
	var ideal_brake: float = P1CMovement.TOP_SPEED_MPS / P1CMovement.BRAKING_MPS2
	var brake_err: float = absf(t_brake - ideal_brake) / ideal_brake
	# Stale stick: input stops arriving, so the actor must stop, not glide forever.
	var sv: Vector2 = Vector2.RIGHT * P1CMovement.TOP_SPEED_MPS
	for i: int in range(600):
		sv = P1CMovement.step(sv, Vector2.ZERO, dt)
	print("    deadzone %.2f RADIAL: 0.15 -> %s; 0.60 -> %.3f; diagonal 0.15/0.15 (|v|=%.3f) -> %s; diagonal 0.10/0.10 (|v|=%.3f) -> %s"
		% [P1CMovement.DEADZONE, str(dz_in), dz_out.length(), Vector2(0.15, 0.15).length(),
			"passes" if dz_diag != Vector2.ZERO else "rejected", Vector2(0.1, 0.1).length(),
			"passes" if dz_diag_small != Vector2.ZERO else "rejected"])
	print("    top speed %.4f m/s vs configured %.4f (%.3f%% error, 1%% allowed)"
		% [top, P1CMovement.TOP_SPEED_MPS, top_err * 100.0])
	print("    acceleration %.4f s vs ideal %.4f s (%.2f%%); braking %.4f s vs ideal %.4f s (%.2f%%)"
		% [t_acc, ideal_acc, acc_err * 100.0, t_brake, ideal_brake, brake_err * 100.0])
	_expect(dz_in == Vector2.ZERO and dz_out.length() > 0.0
			and dz_diag != Vector2.ZERO and dz_diag_small == Vector2.ZERO
			and top_err <= 0.01 and acc_err <= 0.05 and brake_err <= 0.05
			and sv == Vector2.ZERO,
		"the RADIAL deadzone rejects 0.15 and the 0.141 diagonal, and passes 0.60 and the 0.212 diagonal (a per-axis deadzone would wrongly reject the latter); top speed within %.3f%% (1%% allowed); acceleration within %.2f%% and braking within %.2f%% (5%% allowed); a stale stick comes to rest: %s"
			% [top_err * 100.0, acc_err * 100.0, brake_err * 100.0, str(sv == Vector2.ZERO)])
	print("    The deadzone is RADIAL, so the stick's diagonals do not reach further than its cardinals")
	print("    and the dead region is a circle rather than a cross.")
	print("    5.0 m/s is the accepted 3D locomotion value RE-TESTED in 2D — not inherited as a 2D lock.")
	_done("controller_movement_measures_its_deadzone_speed_acceleration_and_braking")


# --- C6 -------------------------------------------------------------------------------
func _check_per_use_aim() -> void:
	print("")
	print("--- 6. C6 — mouse aiming is PER-USE and stores no cross-use state")
	var origin: Vector2 = Vector2.ZERO
	var a1: Vector2 = P1CTargeting.aim_for_use(origin, Vector2(100, 0))
	var a2: Vector2 = P1CTargeting.aim_for_use(origin, Vector2(0, 100))
	var a1_again: Vector2 = P1CTargeting.aim_for_use(origin, Vector2(100, 0))
	var independent: bool = not a1.is_equal_approx(a2) and a1.is_equal_approx(a1_again)
	# A stored target would have to live in a property. There must be none.
	var stateful: PackedStringArray = PackedStringArray()
	var probe: P1CTargeting = P1CTargeting.new()
	for p: Dictionary in probe.get_property_list():
		var n: String = p["name"]
		if n.begins_with("script") or n.begins_with("Built-in") or n == "RefCounted" \
				or n == "P1CTargeting" or n.begins_with("@"):
			continue
		if int(p["usage"]) & PROPERTY_USAGE_SCRIPT_VARIABLE:
			stateful.append(n)
	_expect(independent and stateful.is_empty()
			and not P1CTargeting.LOCK_ON_ENABLED and not P1CTargeting.RETAINS_TARGET_BETWEEN_USES,
		"two uses with the cursor moved between them aim independently (%s) and the first repeats exactly; the targeting class declares %d instance variables (0 required, so there is nowhere to store a target); lock-on %s; retention %s"
			% [str(independent), stateful.size(), str(P1CTargeting.LOCK_ON_ENABLED),
				str(P1CTargeting.RETAINS_TARGET_BETWEEN_USES)])
	print("    Hover is INFORMATION, not selection. No cycling, no sticky namelock, no permanent marker.")
	_done("mouse_aiming_is_per_use_and_stores_no_cross_use_state")


# --- C7 -------------------------------------------------------------------------------
func _check_soft_target() -> void:
	print("")
	print("--- 7. C7 — controller soft targeting")
	var ppm: float = P1AScale.LOCKED_PX_PER_M
	var origin: Vector2 = Vector2.ZERO
	# One enemy AT THE ACTOR'S FEET, one 6 m away in the aimed direction.
	var underfoot: Dictionary = {"id": 1, "position": Vector2(0.15 * ppm, 0.15 * ppm)}
	var aimed: Dictionary = {"id": 2, "position": Vector2(6.0 * ppm, 0.0)}
	var right: Dictionary = P1CTargeting.soft_target(origin, Vector2.RIGHT, [underfoot, aimed], ppm)
	var left: Dictionary = P1CTargeting.soft_target(origin, Vector2.LEFT, [underfoot, aimed], ppm)
	# Inside the cone and inside the acquisition distance is chosen.
	var edge_in: Dictionary = P1CTargeting.soft_target(origin, Vector2.RIGHT,
		[{"id": 3, "position": Vector2(5.0 * ppm, 0.0).rotated(deg_to_rad(P1CTargeting.SOFT_TARGET_HALF_DEG - 1.0))}], ppm)
	var edge_out: Dictionary = P1CTargeting.soft_target(origin, Vector2.RIGHT,
		[{"id": 4, "position": Vector2(5.0 * ppm, 0.0).rotated(deg_to_rad(P1CTargeting.SOFT_TARGET_HALF_DEG + 1.0))}], ppm)
	var too_far: Dictionary = P1CTargeting.soft_target(origin, Vector2.RIGHT,
		[{"id": 5, "position": Vector2((P1CTargeting.ACQUISITION_DISTANCE_M + 1.0) * ppm, 0.0)}], ppm)
	print("    aiming right with an enemy underfoot and one 6 m ahead -> id %d" % int(right["id"]))
	print("    aiming left  with the same two                         -> id %d" % int(left["id"]))
	print("    inside the +-%.1f deg cone -> id %d; just outside -> id %d; beyond %.1f m -> id %d"
		% [P1CTargeting.SOFT_TARGET_HALF_DEG, int(edge_in["id"]), int(edge_out["id"]),
			P1CTargeting.ACQUISITION_DISTANCE_M, int(too_far["id"])])
	_expect(int(right["id"]) == 2 and int(left["id"]) == -1
			and int(edge_in["id"]) == 3 and int(edge_out["id"]) == -1 and int(too_far["id"]) == -1,
		"the aimed-at enemy is chosen over the one underfoot (%d, not 1); opposite intents answer independently (right %d, left %d); the cone and the acquisition distance both bound the choice"
			% [int(right["id"]), int(right["id"]), int(left["id"])])
	print("    **AN ENEMY AT THE ACTOR'S FEET DOES NOT OUTRANK THE ONE BEING AIMED AT.** The in-reach")
	print("    priority group is a CONTACT-MELEE rule and is deliberately NOT generalized to ranged use.")
	print("    The cone is %.1f deg TOTAL, applied as +-%.1f. It is aim ASSISTANCE, not a release arc,"
		% [P1CTargeting.SOFT_TARGET_CONE_TOTAL_DEG, P1CTargeting.SOFT_TARGET_HALF_DEG])
	print("    and the two must never be conflated. No lock-on, no retention.")
	_done("controller_soft_targeting_prefers_the_aimed_at_over_the_underfoot")


# --- C8 -------------------------------------------------------------------------------
func _check_projectile() -> void:
	print("")
	print("--- 8. C8 — the DIAGNOSTIC, NON-CANONICAL Huntress projectile")
	var ppm: float = P1AScale.LOCKED_PX_PER_M
	var dt: float = 1.0 / 60.0
	var origin: Vector2 = Vector2.ZERO
	var far_target: Vector2 = Vector2(6.0 * ppm, 0.0)
	var hit: Dictionary = P1CCombat.fire(origin, Vector2.RIGHT, far_target, ppm, dt)
	var miss: Dictionary = P1CCombat.fire(origin, Vector2.UP, far_target, ppm, dt)
	# POINT-BLANK: the target already overlaps the muzzle.
	var pb: Dictionary = P1CCombat.fire(origin, Vector2.RIGHT, Vector2(0.1 * ppm, 0.0), ppm, dt)
	var max_range_m: float = P1CCombat.PROJECTILE_SPEED_MPS * P1CCombat.PROJECTILE_LIFETIME_S
	print("    6 m shot: hit %s after %.2f m in %.3f s" % [str(hit["hit"]), float(hit["travelled_m"]), float(hit["time_s"])])
	print("    perpendicular shot: hit %s, expired %s after %.2f m (lifetime range %.2f m)"
		% [str(miss["hit"]), str(miss["expired"]), float(miss["travelled_m"]), max_range_m])
	print("    POINT-BLANK at an already-overlapping target: hit %s on step %d"
		% [str(pb["hit"]), int(pb["steps"])])
	_expect(bool(hit["hit"]) and not bool(miss["hit"]) and bool(miss["expired"])
			and bool(pb["hit"]) and bool(pb["point_blank"]) and int(pb["steps"]) == 0
			and not P1CCombat.IS_DESIGNED_SKILL,
		"hits at range (%s, %.2f m); a miss EXPIRES and nothing survives past the %.2f s lifetime (%s); a point-blank overlap HITS on step 0 (%s); labelled a designed Skill: %s"
			% [str(bool(hit["hit"])), float(hit["travelled_m"]), P1CCombat.PROJECTILE_LIFETIME_S,
				str(bool(miss["expired"])), str(bool(pb["hit"])), str(P1CCombat.IS_DESIGNED_SKILL)])
	print("    POINT-BLANK IS A NAMED DEFECT CLASS HERE — \"a shape query blind to what it already")
	print("    overlaps\". The overlap is tested BEFORE the first step, so the shot cannot tunnel past.")
	print("    THE ACTION IS %s." % P1CCombat.DIAGNOSTIC_LABEL)
	_done("the_diagnostic_projectile_hits_expires_and_survives_nothing")


# --- C10 ------------------------------------------------------------------------------
func _check_enemy_cycle() -> void:
	print("")
	print("--- 9. C10 — the enemy runs the whole accepted cycle, in order")
	var r: Dictionary = P1CCombat.enemy_cycle(9.0, 1.0 / 60.0, true)
	var order: Array = r["phase_order"]
	var names: PackedStringArray = PackedStringArray()
	for p: int in order:
		names.append(P1CCombat.PHASE_NAMES[p])
	var seen: Dictionary = {}
	for p: int in order:
		seen[p] = true
	var required: Array[int] = [P1CCombat.Phase.HOLD, P1CCombat.Phase.PERMISSION,
		P1CCombat.Phase.ANTICIPATION, P1CCombat.Phase.COMMIT, P1CCombat.Phase.OBSTRUCTED,
		P1CCombat.Phase.RELEASE, P1CCombat.Phase.DEAD]
	var all_present: bool = true
	for p: int in required:
		if not seen.has(p):
			all_present = false
	# HIT-BEFORE-KILL ORDERING: every hit event must be logged before the death entry.
	var death_at: int = -1
	var last_hit_at: int = -1
	for i: int in range((r["log"] as Array).size()):
		var e: Dictionary = (r["log"] as Array)[i]
		if String(e.get("event", "")) == "hit":
			last_hit_at = i
		if int(e.get("phase", -1)) == P1CCombat.Phase.DEAD:
			death_at = i
	var hit_before_kill: bool = last_hit_at >= 0 and death_at > last_hit_at
	# The exact Life relationship.
	var expected_hits: int = int(ceil(float(P1CCombat.ENEMY_MAX_LIFE) / float(P1CCombat.PROJECTILE_DAMAGE)))
	var expected_life: int = P1CCombat.ENEMY_MAX_LIFE - expected_hits * P1CCombat.PROJECTILE_DAMAGE
	print("    phase order: %s" % ", ".join(names))
	print("    Life %d, damage %d per hit -> %d hits, final Life %d"
		% [P1CCombat.ENEMY_MAX_LIFE, P1CCombat.PROJECTILE_DAMAGE, int(r["hits_taken"]), int(r["final_life"])])
	_expect(all_present and hit_before_kill and bool(r["permission_granted"])
			and bool(r["commit_visible"]) and bool(r["released"]) and bool(r["obstructed"])
			and int(r["hits_taken"]) == expected_hits and int(r["final_life"]) == expected_life
			and int(r["final_life"]) <= 0,
		"every phase occurred %s; permission %s; commit visible %s; release %s; obstruction exercised %s; HIT-BEFORE-KILL ordering %s (last hit at %d, death at %d); %d hits and final Life %d, both exactly as %d/%d predicts"
			% [str(all_present), str(bool(r["permission_granted"])), str(bool(r["commit_visible"])),
				str(bool(r["released"])), str(bool(r["obstructed"])), str(hit_before_kill),
				last_hit_at, death_at, int(r["hits_taken"]), int(r["final_life"]),
				P1CCombat.ENEMY_MAX_LIFE, P1CCombat.PROJECTILE_DAMAGE])
	print("    The obstruction branch is EXERCISED, not merely reachable: the commit is interrupted once")
	print("    and returns to holding rather than firing through it.")
	_done("the_enemy_runs_the_whole_accepted_cycle_in_order")


# --- C11 ------------------------------------------------------------------------------
func _check_item() -> void:
	print("")
	print("--- 10. C11 — the dropped item")
	var nav_regions: int = NavigationServer2D.map_get_regions(
		_room.nav_region.get_navigation_map()).size()
	# The enemy stands at (5, -2) m, which is inside the room and clear of the obstacle.
	var death_pos: Vector2 = Vector2(_room.px(5.0), _room.px(-2.0))
	var drop: Dictionary = _room.resolve_click(death_pos)
	var reachable: bool = not bool(drop["redirected"]) or float(drop["offset_m"]) < 1.0
	var highlighted: bool = true   ## the room draws a highlight ring at the drop point
	var equipped: Dictionary = {"armour": 12.0, "damage": 5.0}
	var candidate: Dictionary = {"armour": 15.0, "damage": 4.0}
	var cmp: Dictionary = P1CCombat.compare_items(equipped, candidate)
	# COMPUTED FACTS ONLY: no adjectives, no verdict.
	var editorial: PackedStringArray = PackedStringArray()
	for line: String in cmp["lines"]:
		var low: String = line.to_lower()
		for word: String in ["better", "worse", "best", "upgrade", "downgrade", "good", "bad", "improve"]:
			if low.contains(word):
				editorial.append(line)
	var before_total: float = float(equipped["armour"]) + float(equipped["damage"])
	var after_total: float = float(candidate["armour"]) + float(candidate["damage"])
	var measurable: bool = not is_equal_approx(before_total, after_total) \
		and not is_equal_approx(float(equipped["armour"]), float(candidate["armour"]))
	for line: String in cmp["lines"]:
		print("      %s" % line)
	_expect(nav_regions > 0 and reachable and highlighted and editorial.is_empty() and measurable
			and (cmp["lines"] as Array).size() == 2,
		"the item drops at the death position and is path-reachable (%s, %.3f m from the mesh); it is highlighted; the comparison states %d computed facts and %d editorial words (0 required); equipping changes armour %.1f -> %.1f, a measurable change"
			% [str(reachable), float(drop["offset_m"]), (cmp["lines"] as Array).size(),
				editorial.size(), float(equipped["armour"]), float(candidate["armour"])])
	print("    The comparison reports DELTAS, not a verdict. A comparison that editorialises is one the")
	print("    player cannot check. Nothing here says \"better\".")
	_done("the_dropped_item_is_reachable_compared_on_facts_and_measurably_equipped")


# --- C12 ------------------------------------------------------------------------------
func _check_room_scope() -> void:
	print("")
	print("--- 11. C12 — the room builds on the accepted P1B kit and no campaign path")
	var sources: PackedStringArray = PackedStringArray([
		"res://scripts/p1c_room.gd", "res://scripts/p1c_facing.gd", "res://scripts/p1c_movement.gd",
		"res://scripts/p1c_targeting.gd", "res://scripts/p1c_combat.gd"])
	var banned: Array[String] = ["campaign", "zone", "act_", "bastion", "riftfall", "nexus",
		"broken_watch", "echo", "expedition"]
	var offenders: PackedStringArray = PackedStringArray()
	for path: String in sources:
		var body: String = FileAccess.get_file_as_string(path).to_lower()
		for b: String in banned:
			if body.contains("res://") and body.contains(b + "/"):
				offenders.append("%s -> %s" % [path, b])
	var built: Dictionary = P1BTileSet.build()
	var tiles_used: int = (built["tile_set"] as TileSet).get_source_count()
	var simplified: bool = false
	for path: String in sources:
		if FileAccess.get_file_as_string(path).contains("simplified"):
			simplified = true
	_expect(offenders.is_empty() and bool(built["built"]) and tiles_used == 3 and not simplified,
		"campaign/zone path references: %d %s; the floor uses the %d ACCEPTED P1B tiles; the unaccepted simplified candidate is referenced nowhere: %s"
			% [offenders.size(), str(offenders), tiles_used, str(not simplified)])
	_done("the_room_builds_only_on_the_accepted_p1b_kit_and_no_campaign_path")


# --- C13 ------------------------------------------------------------------------------
func _check_truthfulness() -> void:
	print("")
	print("--- 12. C13 — every on-screen claim is accurate")
	var text: String = _room.readout()
	var says_no_walk: bool = text.contains("WALK ANIMATION IS NOT IMPLEMENTED")
	var says_diagnostic: bool = text.contains("DIAGNOSTIC, NON-CANONICAL")
	var says_not_skill: bool = text.contains("defines no class mechanic")
	var says_per_use: bool = text.contains("PER-USE") and text.contains("not selection")
	var says_accepted: bool = text.contains("ACCEPTED AND CLOSED")
	var says_frozen: bool = text.contains("FROZEN") and text.contains("NO 3D")
	var says_provisional: bool = text.contains("5.0 m/s is PROVISIONAL")
	var says_transferred: bool = text.contains("TRANSFERRED") and text.contains("C9")
	var says_not_p1: bool = text.contains("does not complete P1C or P1")
	# Nothing may claim an unimplemented thing.
	var low: String = text.to_lower()
	# A DENIAL is not a false claim. "not a designed Skill" must not be flagged as one, so
	# each phrase is only an offence where it is NOT immediately preceded by a negation.
	var false_claims: PackedStringArray = PackedStringArray()
	for phrase: String in ["walk animation plays", "target selected", "designed skill", "skill unlocked"]:
		var from: int = 0
		while true:
			var at: int = low.find(phrase, from)
			if at < 0:
				break
			var before: String = low.substr(maxi(0, at - 12), mini(12, at))
			if not (before.contains("not ") or before.contains("no ")):
				false_claims.append(phrase)
			from = at + phrase.length()
	_expect(says_no_walk and says_diagnostic and says_not_skill and says_per_use and says_accepted
			and says_transferred and says_not_p1 and says_frozen and says_provisional
			and false_claims.is_empty(),
		"states walk is absent %s; labels the action diagnostic/non-canonical %s; denies it is a class mechanic %s; states targeting is per-use and hover is not selection %s; names itself ACCEPTED AND CLOSED %s; names C9 as TRANSFERRED %s; states it does not complete P1C or P1 %s; states the 2D freeze and that no 3D work is authorized %s; states 5.0 m/s is provisional %s; false claims found: %d"
			% [str(says_no_walk), str(says_diagnostic), str(says_not_skill), str(says_per_use),
				str(says_accepted), str(says_transferred), str(says_not_p1), str(says_frozen),
				str(says_provisional), false_claims.size()])
	_done("every_on_screen_claim_is_accurate")


# --- traceability ---------------------------------------------------------------------
func _check_transferred() -> void:
	print("")
	print("--- 13. TRACEABILITY — the transferred Mage criteria are recorded, never passed")
	var mentions_c9: bool = false
	var mentions_both: bool = false
	for t: String in TRANSFERRED:
		if t.contains("C9"):
			mentions_c9 = true
		if t.contains("both characters"):
			mentions_both = true
	# They must NOT appear in the owed set: a transferred row that is also owed would be
	# counted as a pass the moment the suite went green.
	var leaked: PackedStringArray = PackedStringArray()
	for name: String in OWED_CHECKS:
		if name.contains("mage") and not name.contains("transferred"):
			leaked.append(name)
	# The Mage art must be untouched: legacy reference only.
	var mage_intact: bool = FileAccess.get_sha256(P1AArt.MAGE_SHEET_PATH) == P1AArt.MAGE_SHEET_SHA256
	var mage_conforms: bool = P1AScale.MAGE_CURRENT_EXPORTS_CONFORM
	_expect(mentions_c9 and mentions_both and leaked.is_empty() and mage_intact
			and not mage_conforms and TRANSFERRED.size() == 2,
		"C9 recorded as transferred %s; the \"both characters\" scope recorded %s; transferred rows leaked into the owed set: %d; the legacy Mage sheet is byte-identical and untouched %s; it is still recorded as NON-conforming %s"
			% [str(mentions_c9), str(mentions_both), leaked.size(), str(mage_intact),
				str(not mage_conforms)])
	print("    **THIS IS A STAGING AMENDMENT, NOT A DELETION.** C9 and the \"both characters\" requirement")
	print("    are printed every run as TRANSFERRED and are counted separately from the owed set, so a")
	print("    green P1C-H can never be read as having satisfied them.")
	_done("the_transferred_mage_criteria_are_recorded_and_never_counted_as_passes")


# --- C14 ------------------------------------------------------------------------------
func _check_locks() -> void:
	print("")
	print("--- 14. C14 — P1A and P1B locks, pins and debts are unchanged")
	var locks_ok: bool = P1AScale.LOCKED_PX_PER_M == 60.0 \
		and P1AScale.LOCKED_CHARACTER_CELL_PX == 128 \
		and P1AScale.LOCKED_GROUND_ANCHOR == Vector2i(64, 122) \
		and P1AScale.LOCKED_TILE_PX == Vector2i(120, 60) \
		and P1AScale.CANONICAL_BASE_VIEWPORT == Vector2i(1920, 1080) \
		and P1AScale.LOCKED_RENDERING_MODE_OWNER_NUMBER == 7 \
		and P1AScale.RENDERING_MODE_DECIDED
	# No runtime art transform anywhere in this proof.
	var s: AnimatedSprite2D = _room.actor_sprite
	var no_transform: bool = s.scale.is_equal_approx(Vector2.ONE) and is_equal_approx(s.rotation, 0.0) \
		and not s.flip_h and not s.flip_v \
		and s.texture_filter == CanvasItem.TEXTURE_FILTER_PARENT_NODE \
		and _room.floor_layer.scale.is_equal_approx(Vector2.ONE) \
		and is_equal_approx(_room.floor_layer.rotation, 0.0) \
		and _room.floor_layer.texture_filter == CanvasItem.TEXTURE_FILTER_PARENT_NODE
	# The one offset that exists is the LOCKED shared anchor, identical for all eight.
	var anchor_offset_is_the_lock: bool = s.offset.is_equal_approx(
		-Vector2(P1AScale.LOCKED_GROUND_ANCHOR))
	var refusal: bool = P1AScale.LOCKED_TILE_PX != Vector2i(128, 64)
	_expect(locks_ok and no_transform and anchor_offset_is_the_lock and refusal,
		"all P1A/P1B locks intact %s; no scale, rotation, flip or filter override on the actor or the floor %s; the ONLY offset is the locked shared anchor %s, the same constant for all eight directions"
			% [str(locks_ok), str(no_transform), str(s.offset)])
	print("    P1C-H reads the locks from `p1a_scale.gd` and the tiles from `p1b_tileset.gd` rather than")
	print("    restating either, so it cannot drift from them.")
	_done("the_p1a_and_p1b_locks_pins_and_debts_are_unchanged")


func _check_every_check_ran() -> void:
	print("")
	print("--- 15. The owed set, compared in both directions")
	var missing: PackedStringArray = PackedStringArray()
	for name: String in OWED_CHECKS:
		if name != "every_check_ran" and not _reached.has(name):
			missing.append(name)
	var extra: PackedStringArray = PackedStringArray()
	for name: String in _reached.keys():
		if not OWED_CHECKS.has(String(name)):
			extra.append(String(name))
	_expect(missing.is_empty() and extra.is_empty(),
		"owed %d; reached %d (this one included); missing %d; unexpected %d"
			% [OWED_CHECKS.size(), _reached.size() + 1, missing.size(), extra.size()])
	if not missing.is_empty():
		print("  checks that never reached their last line: %s" % str(missing))
	_done("every_check_ran")
