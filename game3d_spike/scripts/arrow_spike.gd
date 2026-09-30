class_name ArrowSpike
extends Area3D

## THE ONE EXPLICITLY DIAGNOSTIC, NON-CANONICAL PROJECTILE.
##
## CLAUDE.md 3.5 permits P1-era work exactly ONE explicitly diagnostic,
## non-canonical projectile action, WHICH MUST BE LABELLED DIAGNOSTIC IN THE
## RUNTIME. This is that action.
##
## IT IS NOT A DESIGNED SKILL. It defines NO Huntress class mechanic. Accepting
## it would not promote any mechanic, and a canonical Huntress class
## specification remains a P2 prerequisite that does not exist.

signal despawned(reason: String)

const DIAGNOSTIC := true
const LABEL := SpikeConfig.PROJECTILE_LABEL

var direction: Vector3 = Vector3.FORWARD
var travelled: float = 0.0
var owner_is_player: bool = true
var _dead: bool = false

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2  # enemy bodies
	monitoring = true
	var shape := CollisionShape3D.new()
	var sph := SphereShape3D.new()
	sph.radius = 0.28
	shape.shape = sph
	add_child(shape)
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	if _dead:
		return
	var step := SpikeConfig.ARROW_SPEED_MPS * delta
	global_position += direction * step
	travelled += step
	if travelled >= SpikeConfig.ARROW_RANGE_M:
		_despawn("miss_range")

func _on_body_entered(b: Node) -> void:
	_try_hit(b)

func _on_area_entered(a: Node) -> void:
	_try_hit(a)

func _try_hit(n: Node) -> void:
	if _dead:
		return
	var e := n
	while e != null and not (e is EnemySpike):
		e = e.get_parent()
	if e == null:
		return
	(e as EnemySpike).take_hit(SpikeConfig.ARROW_DAMAGE, global_position)
	_despawn("hit")

func _despawn(reason: String) -> void:
	if _dead:
		return
	_dead = true
	despawned.emit(reason)
	queue_free()
