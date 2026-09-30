class_name StandInHound
extends Node3D

## DIAGNOSTIC HOUND STAND-IN — NO HOUND ART PROVEN.
##
## ============================================================================
## PROCEDURAL PRIMITIVES ONLY. IT PROVES BEHAVIOUR, NEVER ART.
## ============================================================================
## A capsule body, a box head and snout, four cylinder legs and a tail -- engine
## primitives built here. NO imported mesh, NO Ultimate Monsters dog (excluded by
## standing ruling), and NO claim that any hound asset is feasible (DF-08). The
## label above it says so in the world, on every frame.
##
## ============================================================================
## AUTONOMOUS. THERE IS NO COMMAND PATH OF ANY KIND.
## ============================================================================
## No input action reaches it and no method takes a player-chosen target (S-02).
## Canon §0.5.3 item 6 and §0.5.6: autonomous allies "prefer the Prey when it is
## within their normal acquisition reach. Otherwise they continue using their
## autonomous targeting." Beasts act autonomously, with "no routine commands".
##
## THE CHOICE, every re-evaluation and on every Prey change:
##   1. if the Prey is ALIVE, within acquisition reach, and REACHABLE BY PATH
##      from the hound -> the Prey;
##   2. otherwise the NEAREST eligible target, ties broken by NAME -- never by
##      engine iteration order;
##   3. otherwise follow the Huntress.
##
## ---------------------------------------------------------------------------
## WHERE "ACQUISITION REACH" IS MEASURED FROM -- A DIAGNOSTIC CHOICE, NOT A RULING
## ---------------------------------------------------------------------------
## Canon says allies prefer the Prey "within their normal acquisition reach" and
## does not fix the reference point. Measured from the HOUND, a hound engaged at
## one target can never follow a Prey switch to a target beyond its reach -- the
## first rendered run showed exactly that, and it reads as "the hound ignores
## Prey". This stand-in measures reach from the HUNTRESS: the pack works the
## ground around its handler, and where she stands decides what is in reach.
## That choice is printed, reported and OWED to the owner; it decides nothing
## for the product.
##
## ITS BITES CAN NEVER DESIGNATE OR REPLACE PREY: it never calls PreyState, and
## its damage arrives at the target tagged "minion" (S-08, P-09).

var huntress: Node3D
var prey: PreyState
var targets_provider: Callable = Callable()

var target: TargetDummy = null
var target_reason: String = "none"          ## "PREY" | "AUTONOMOUS" | "none"
## Why the Prey was NOT taken, when it exists and was not: for the HUD.
var prey_skip_reason: String = ""
var speed: float = 0.0
var bites: int = 0
var thinks: int = 0
var choices: Array = []                     ## [frame, target name, reason]
var follower := NavService.PathFollower.new()

var _think_t: float = 0.0
var _bite_t: float = 0.0
var _lunge_t: float = -1.0
var _gait: float = 0.0
var _body: Node3D
var _legs: Array[MeshInstance3D] = []
var _label: Label3D
var _target_line: MeshInstance3D
var _line_im: ImmediateMesh
var _map: RID

func build() -> void:
	name = "StandInHound"
	_body = Node3D.new()
	_body.name = "HoundPrimitives"
	add_child(_body)
	var fur := StandardMaterial3D.new()
	fur.albedo_color = Color(0.36, 0.33, 0.29)
	fur.roughness = 0.95
	var dark := StandardMaterial3D.new()
	dark.albedo_color = Color(0.16, 0.15, 0.14)
	var torso := MeshInstance3D.new()
	var cap := CapsuleMesh.new()
	cap.radius = 0.17; cap.height = 0.78
	torso.mesh = cap
	torso.material_override = fur
	torso.rotation_degrees = Vector3(90, 0, 0)
	torso.position = Vector3(0, 0.50, 0)
	_body.add_child(torso)
	var head := MeshInstance3D.new()
	var hb := BoxMesh.new()
	hb.size = Vector3(0.22, 0.22, 0.26)
	head.mesh = hb
	head.material_override = fur
	head.position = Vector3(0, 0.66, 0.44)
	_body.add_child(head)
	var snout := MeshInstance3D.new()
	var sb := BoxMesh.new()
	sb.size = Vector3(0.12, 0.10, 0.16)
	snout.mesh = sb
	snout.material_override = dark
	snout.position = Vector3(0, 0.61, 0.62)
	_body.add_child(snout)
	for e in [[-0.13, 0.12], [-0.13, -0.28], [0.13, 0.12], [0.13, -0.28]]:
		var leg := MeshInstance3D.new()
		var lc := CylinderMesh.new()
		lc.top_radius = 0.045; lc.bottom_radius = 0.035; lc.height = 0.42
		leg.mesh = lc
		leg.material_override = dark
		leg.position = Vector3(float(e[0]) * 0.8, 0.21, float(e[1]))
		_body.add_child(leg)
		_legs.append(leg)
	var tail := MeshInstance3D.new()
	var tc := CylinderMesh.new()
	tc.top_radius = 0.02; tc.bottom_radius = 0.04; tc.height = 0.34
	tail.mesh = tc
	tail.material_override = fur
	tail.rotation_degrees = Vector3(-55, 0, 0)
	tail.position = Vector3(0, 0.62, -0.50)
	_body.add_child(tail)
	# THE ALLY RING -- a SEGMENTED ring, so it can never be mistaken for the
	# solid Prey ring by shape (not only by colour).
	var rm := StandardMaterial3D.new()
	rm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	rm.albedo_color = Color(0.45, 0.80, 1.0)
	for k in 8:
		var seg := MeshInstance3D.new()
		var bx := BoxMesh.new()
		bx.size = Vector3(0.16, 0.02, 0.04)
		seg.mesh = bx
		seg.material_override = rm
		var ang := TAU * float(k) / 8.0
		seg.position = Vector3(sin(ang) * 0.46, 0.07, cos(ang) * 0.46)
		seg.rotation = Vector3(0, ang + PI * 0.5, 0)
		add_child(seg)
	_label = Label3D.new()
	_label.name = "HoundLabel"
	_label.text = SpikeConfig.HOUND_LABEL
	_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_label.no_depth_test = true
	_label.layers = SpikeConfig.LABEL_RENDER_LAYER
	_label.font_size = 24
	_label.outline_size = 10
	_label.pixel_size = 0.005
	_label.modulate = Color(0.70, 0.90, 1.0)
	_label.position = Vector3(0, 0.95, 0)
	add_child(_label)
	GroundShadow.attach_to(self, SpikeConfig.HOUND_RADIUS_M)
	_line_im = ImmediateMesh.new()
	_target_line = MeshInstance3D.new()
	_target_line.name = "HoundTargetLine"
	_target_line.top_level = true
	_target_line.mesh = _line_im
	var lm := StandardMaterial3D.new()
	lm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	lm.albedo_color = Color(0.45, 0.80, 1.0, 0.8)
	lm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_target_line.material_override = lm
	add_child(_target_line)

func label_text() -> String:
	return _label.text

func connect_prey(p: PreyState) -> void:
	prey = p
	prey.prey_changed.connect(func(_t): think())

func _candidates() -> Array:
	return targets_provider.call() if targets_provider.is_valid() else []

## Is `t` a target the hound may take right now? Alive, in reach, on the leash,
## and REACHABLE BY PATH -- a path that actually ENDS next to it.
func eligible(t: TargetDummy) -> bool:
	return eligibility(t) == ""

## "" when eligible; otherwise the reason it is not.
func eligibility(t: TargetDummy) -> String:
	if t == null or not is_instance_valid(t) or not t.is_inside_tree():
		return "gone"
	if not t.alive:
		return "dead"
	var centre: Vector3 = huntress.global_position if huntress != null else global_position
	if NavService.planar_distance(centre, t.global_position) > SpikeConfig.HOUND_ACQUIRE_M:
		return "out of reach"
	if not reachable(t.global_position):
		return "unreachable by path"
	return ""

func reachable(p: Vector3) -> bool:
	if not _map.is_valid():
		_map = NavService.map_rid_for(self)
	var tol := SpikeConfig.TARGET_RADIUS_M + ProdConfig.NAV_AGENT_RADIUS + SpikeConfig.HOUND_BITE_REACH_M + 0.10
	var r := NavService.reachable(_map, global_position, p, tol)
	return bool(r["reachable"])

## THE CHOICE. Deterministic: Prey first when eligible; otherwise nearest, ties
## by name.
func think() -> void:
	# At shutdown a target leaving the tree clears Prey, which asks for a new
	# choice; nothing outside the tree has a position to choose by.
	if not is_inside_tree():
		return
	thinks += 1
	var chosen: TargetDummy = null
	var reason := "none"
	prey_skip_reason = ""
	var prey_why := eligibility(prey.current) if prey != null and prey.current != null else "no prey"
	if prey != null and prey.current != null and prey_why == "":
		chosen = prey.current
		reason = "PREY"
	else:
		if prey != null and prey.current != null:
			prey_skip_reason = prey_why
		var best: TargetDummy = null
		var best_d := INF
		var cands := _candidates()
		cands.sort_custom(func(a, b): return String((a as Node).name) < String((b as Node).name))
		for c in cands:
			var t := c as TargetDummy
			if not eligible(t):
				continue
			var d := NavService.planar_distance(global_position, t.global_position)
			if d < best_d - 0.0001:
				best = t
				best_d = d
		if best != null:
			chosen = best
			reason = "AUTONOMOUS"
	if chosen != target or reason != target_reason:
		choices.append([Engine.get_physics_frames(), chosen.label_text if chosen != null else "none", reason])
	target = chosen
	target_reason = reason

func _physics_process(delta: float) -> void:
	step(delta)

func step(delta: float) -> void:
	_think_t -= delta
	if _think_t <= 0.0:
		_think_t = SpikeConfig.HOUND_THINK_S
		think()
	if not _map.is_valid():
		_map = NavService.map_rid_for(self)
	var goal: Vector3
	var stop_at: float
	if target != null and is_instance_valid(target) and target.alive:
		goal = target.global_position
		stop_at = SpikeConfig.TARGET_RADIUS_M + SpikeConfig.HOUND_RADIUS_M + SpikeConfig.HOUND_BITE_REACH_M
	elif huntress != null:
		goal = huntress.global_position + Vector3(1.3, 0, 1.1)
		stop_at = 0.45
	else:
		goal = global_position
		stop_at = 1.0
	var dist := NavService.planar_distance(global_position, goal)
	var moving := dist > stop_at
	if moving:
		if follower.finished() or follower.repaths == 0 or Engine.get_physics_frames() % 12 == 0:
			follower.repath(_map, global_position, NavService.nearest_point(_map, goal))
		var dir := follower.steer(global_position)
		if dir == Vector3.ZERO:
			dir = (goal - global_position)
			dir.y = 0.0
			dir = dir.normalized()
		var step_m := minf(SpikeConfig.HOUND_SPEED_MPS * delta, dist - stop_at)
		global_position += dir * step_m
		global_position.y = 0.0
		speed = step_m / delta
		if dir.length() > 0.001:
			rotation.y = lerp_angle(rotation.y, atan2(dir.x, dir.z), clampf(delta * 12.0, 0.0, 1.0))
	else:
		speed = 0.0
		if target != null and is_instance_valid(target) and target.alive:
			var to := target.global_position - global_position
			rotation.y = lerp_angle(rotation.y, atan2(to.x, to.z), clampf(delta * 12.0, 0.0, 1.0))
	# --- the bite ------------------------------------------------------------
	_bite_t -= delta
	if target != null and is_instance_valid(target) and target.alive and not moving and _bite_t <= 0.0:
		_bite_t = SpikeConfig.HOUND_BITE_INTERVAL_S
		# TAGGED "minion". The hound never calls PreyState.designate.
		target.receive_damage(SpikeConfig.HOUND_BITE_DAMAGE, global_position, "minion")
		bites += 1
		_lunge_t = 0.0
	_animate(delta)
	_draw_line()

func _animate(delta: float) -> void:
	_gait += delta * (6.0 + speed * 2.5)
	var amp := clampf(speed / SpikeConfig.HOUND_SPEED_MPS, 0.0, 1.0) * 0.55
	for i in _legs.size():
		var ph := _gait + (PI if i == 1 or i == 2 else 0.0)
		_legs[i].rotation.x = sin(ph) * amp
	var lunge := 0.0
	if _lunge_t >= 0.0:
		_lunge_t += delta
		lunge = sin(clampf(_lunge_t / 0.18, 0.0, 1.0) * PI) * 0.18
		if _lunge_t > 0.18:
			_lunge_t = -1.0
	_body.position = Vector3(0, absf(sin(_gait)) * 0.03 * amp, lunge)
	_body.rotation.x = -lunge * 0.8

func _draw_line() -> void:
	_line_im.clear_surfaces()
	if target == null or not is_instance_valid(target) or not target.alive:
		return
	_line_im.surface_begin(Mesh.PRIMITIVE_LINES)
	var a := global_position + Vector3(0, 0.09, 0)
	var b := target.global_position + Vector3(0, 0.09, 0)
	var n := 10
	for k in n:
		if k % 2 == 1:
			continue
		_line_im.surface_add_vertex(a.lerp(b, float(k) / n))
		_line_im.surface_add_vertex(a.lerp(b, float(k + 1) / n))
	_line_im.surface_end()

func target_name() -> String:
	return target.label_text if target != null and is_instance_valid(target) else "none"
