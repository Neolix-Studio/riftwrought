class_name P1AActor
extends Node2D

## P1A — one displayed character.
##
## The NODE POSITION IS THE GROUND POINT — the feet, not the centre. The sprite is
## offset so that the shared frame anchor lands on this node's origin, and the shadow
## and the ground crosshair are drawn AT the origin. Nothing in P1A reads the sprite's
## own position.
##
## P1A displays. It does not move, collide, navigate, target or fight.

const SHADOW: Color = Color(0, 0, 0, 0.42)
const GROUND_MARK: Color = Color(0.988, 0.427, 0.427, 0.9)
const STANCE_MARK: Color = Color(0.310, 0.831, 0.616, 0.9)

var character: String = "mage"
var direction_token: String = "s"
var sprite_scale: int = 1
var show_markers: bool = true

## The shared anchor, in CELL-LOCAL pixels. ONE constant per character, produced by one
## shared rule: horizontal centre of the cell, and the row immediately below the
## measured ground row. It is NOT a per-frame value, and P1A does not silently
## compensate for frames that disagree with it.
var anchor: Vector2i = Vector2i.ZERO

## Measured for the frame currently shown — used only to draw the diagnostic markers.
var measured_stance_mid: float = -1.0
var measured_body_px: int = 0

var _sprite: AnimatedSprite2D
var _substitute: bool = false


func _ready() -> void:
	_sprite = AnimatedSprite2D.new()
	_sprite.name = "Body"
	_sprite.centered = false
	_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_sprite.z_as_relative = true
	_sprite.z_index = 0
	add_child(_sprite)
	y_sort_enabled = true


func apply(new_character: String, new_anchor: Vector2i, frames: SpriteFrames) -> void:
	character = new_character
	anchor = new_anchor
	_sprite.sprite_frames = frames
	_refresh()


func set_direction(token: String) -> void:
	direction_token = token
	_refresh()


func set_sprite_scale(value: int) -> void:
	sprite_scale = maxi(1, value)
	_refresh()


## Freeze the idle clip on a chosen frame.
##
## The evidence capture needs this. `AnimatedSprite2D` advances on real time while the
## deterministic pan advances on a frame index, so without freezing, a probe that asks
## "did the character re-rasterise" would be answered by the idle animation instead. The
## owner-facing tool never freezes; only the capture does, and it says so.
func freeze_animation(frozen: bool, at_frame: int = 0) -> void:
	if _sprite == null:
		return
	if frozen:
		_sprite.stop()
		_sprite.frame = at_frame
	else:
		_sprite.play()


func is_substitute_direction() -> bool:
	return _substitute


func _refresh() -> void:
	if _sprite == null or _sprite.sprite_frames == null:
		return
	var choice: Dictionary = P1AArt.animation_for(character, direction_token)
	_substitute = bool(choice["is_substitute"])
	var anim: String = String(choice["animation"])
	if _sprite.sprite_frames.has_animation(anim):
		_sprite.animation = anim
		_sprite.play()
	# Integral scale only. A1 forbids a non-integral sprite scale, so this is an int.
	_sprite.scale = Vector2(float(sprite_scale), float(sprite_scale))
	_sprite.offset = Vector2(-float(anchor.x), -float(anchor.y))
	queue_redraw()


func _process(_delta: float) -> void:
	if show_markers:
		queue_redraw()


func _draw() -> void:
	if not show_markers:
		return
	var s: float = float(sprite_scale)
	# The shadow stays at the ground point. A 2:1 ellipse, because the ground plane is
	# drawn in isometric perspective even though the simulation is isotropic.
	var rw: float = 16.0 * s
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.5))
	draw_circle(Vector2.ZERO, rw, SHADOW)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# The ground point itself.
	draw_line(Vector2(-6.0 * s, 0.0), Vector2(6.0 * s, 0.0), GROUND_MARK, 1.0)
	draw_line(Vector2(0.0, -6.0 * s), Vector2(0.0, 6.0 * s), GROUND_MARK, 1.0)
	# Where this frame's drawn stance actually sits, relative to the shared anchor.
	# When the two do not coincide, the gap is the anchor drift — drawn rather than
	# hidden, because that is the whole point of A3.
	if measured_stance_mid >= 0.0:
		var dx: float = (measured_stance_mid - float(anchor.x)) * s
		draw_line(Vector2(dx, -10.0 * s), Vector2(dx, 4.0 * s), STANCE_MARK, 1.0)
