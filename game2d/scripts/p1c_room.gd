class_name P1CRoom
extends Node2D

## P1C-H — the bounded Huntress proof room.
##
## **It is built ONLY on the accepted P1B proof kit and the locked P1A configuration.**
## It references no campaign or zone path, contains no tileset beyond the three accepted
## tiles, and defines no class mechanics.
##
## **NO RUNTIME ART TRANSFORM.** Every sprite is drawn at scale (1, 1), rotation 0, with no
## filter override and no flip. The ONE offset applied is the single shared ground anchor
## (64, 122) that P1A locked — the same constant for all eight directions, which is what
## makes the actor's position its GROUND POINT. That is the accepted anchor, not a
## per-direction or per-frame correction, and none of the latter exists anywhere.

const P1AArt := preload("res://scripts/p1a_art.gd")
const P1AScale := preload("res://scripts/p1a_scale.gd")
const P1BTileSet := preload("res://scripts/p1b_tileset.gd")
const P1CFacing := preload("res://scripts/p1c_facing.gd")
const P1CMovement := preload("res://scripts/p1c_movement.gd")
const P1CTargeting := preload("res://scripts/p1c_targeting.gd")
const P1CCombat := preload("res://scripts/p1c_combat.gd")

## The walkable rectangle, in metres, centred on the origin.
const ROOM_M: Vector2 = Vector2(18.0, 12.0)
## One blocking obstacle, so "nearest navigable point" and obstruction are real.
const OBSTACLE_M: Rect2 = Rect2(2.0, -1.5, 3.0, 3.0)
const ARRIVAL_TOLERANCE_M: float = 0.20

var floor_layer: TileMapLayer
var nav_region: NavigationRegion2D
var actor: Node2D
var actor_sprite: AnimatedSprite2D
var enemy: Node2D
var hud: Label

var facing_index: int = -1
var velocity_mps: Vector2 = Vector2.ZERO
var move_goal: Variant = null
var last_click_was_redirected: bool = false

func px(m: float) -> float:
	return m * P1AScale.LOCKED_PX_PER_M


func _ready() -> void:
	_build_floor()
	_build_navigation()
	_build_actor()
	_build_enemy()
	_build_hud()


## The floor: the three ACCEPTED P1B tiles, nothing else.
func _build_floor() -> void:
	var built: Dictionary = P1BTileSet.build()
	floor_layer = TileMapLayer.new()
	floor_layer.tile_set = built["tile_set"]
	add_child(floor_layer)
	if not bool(built["built"]):
		return
	var slate: int = -1
	var ts: TileSet = built["tile_set"]
	for i: int in range(ts.get_source_count()):
		var sid: int = ts.get_source_id(i)
		var src: TileSetAtlasSource = ts.get_source(sid) as TileSetAtlasSource
		if src != null and src.texture.resource_path.get_file() == P1BTileSet.GROUND_SLATE:
			slate = sid
	if slate < 0:
		return
	for cy: int in range(-14, 15):
		for cx: int in range(-14, 15):
			floor_layer.set_cell(Vector2i(cx, cy), slate, Vector2i.ZERO)


## Navigation baked ONCE for this room, from its own authored geometry.
func _build_navigation() -> void:
	nav_region = NavigationRegion2D.new()
	var poly: NavigationPolygon = NavigationPolygon.new()
	var half: Vector2 = Vector2(px(ROOM_M.x) * 0.5, px(ROOM_M.y) * 0.5)
	var outline: PackedVector2Array = PackedVector2Array([
		Vector2(-half.x, -half.y), Vector2(half.x, -half.y),
		Vector2(half.x, half.y), Vector2(-half.x, half.y)])
	poly.add_outline(outline)
	# The obstacle, wound the opposite way so it becomes a hole rather than a region.
	var o: Rect2 = Rect2(px(OBSTACLE_M.position.x), px(OBSTACLE_M.position.y),
		px(OBSTACLE_M.size.x), px(OBSTACLE_M.size.y))
	poly.add_outline(PackedVector2Array([
		o.position, Vector2(o.position.x, o.end.y), o.end, Vector2(o.end.x, o.position.y)]))
	poly.make_polygons_from_outlines()
	nav_region.navigation_polygon = poly
	add_child(nav_region)


func _build_actor() -> void:
	actor = Node2D.new()          ## its POSITION IS ITS GROUND POINT
	add_child(actor)
	actor_sprite = AnimatedSprite2D.new()
	actor_sprite.sprite_frames = P1AArt.build_sprite_frames("huntress")
	actor_sprite.centered = false
	# The single shared anchor P1A locked. Same constant for all eight directions.
	actor_sprite.offset = -Vector2(P1AScale.LOCKED_GROUND_ANCHOR)
	actor_sprite.scale = Vector2.ONE
	actor_sprite.rotation = 0.0
	actor_sprite.flip_h = false
	actor_sprite.flip_v = false
	actor.add_child(actor_sprite)
	set_facing(2)   ## "s"
	actor_sprite.play()


func _build_enemy() -> void:
	enemy = Node2D.new()
	enemy.position = Vector2(px(5.0), px(-2.0))
	add_child(enemy)


func _build_hud() -> void:
	hud = Label.new()
	hud.position = Vector2(14, 10)
	hud.add_theme_font_size_override("font_size", 15)
	hud.add_theme_color_override("font_color", Color(1, 1, 1))
	hud.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	hud.add_theme_constant_override("outline_size", 5)
	add_child(hud)
	hud.text = readout()


## Every on-screen claim, and nothing it cannot back up.
func readout() -> String:
	var lines: PackedStringArray = PackedStringArray()
	lines.append("RIFTWROUGHT — P1C-H  Huntress character & combat proof   [ACCEPTED AND CLOSED — D-365]")
	lines.append("Accepted as the verified 2D MECHANICS PROTOTYPE. 2D presentation and owner-art production are")
	lines.append("FROZEN. The intended final visual target is now a modern stylized 3D dark-fantasy ARPG; NO 3D")
	lines.append("pivot and NO 3D spike is authorized, and this art remains valid prototype/reference material.")
	lines.append("")
	lines.append("WALK ANIMATION IS NOT IMPLEMENTED. The actor TRANSLATES using the IDLE frame of its current")
	lines.append("facing. No walk, attack, cast, hurt or death animation exists for any character.")
	lines.append("")
	lines.append("The projectile action is %s." % P1CCombat.DIAGNOSTIC_LABEL)
	lines.append("It defines no class mechanic. A canonical Huntress class specification is a P2 prerequisite")
	lines.append("and this is not it.")
	lines.append("")
	lines.append("Targeting is PER-USE. Hover is information, not selection. There is no lock-on, no target")
	lines.append("cycling, no sticky namelock and no globally selected enemy.")
	lines.append("")
	lines.append("facing   sector %d (%s) of 8 authored directions — NO mirroring, NO rotation, NO scaling" % [
		facing_index, P1AArt.DIRECTION_TOKENS[facing_index] if facing_index >= 0 else "-"])
	lines.append("locked   mode 7 · 1920x1080 · %.1f px/m · cell %d · anchor %s · tile %s (P1A/P1B)" % [
		P1AScale.LOCKED_PX_PER_M, P1AScale.LOCKED_CHARACTER_CELL_PX,
		str(P1AScale.LOCKED_GROUND_ANCHOR), str(P1AScale.LOCKED_TILE_PX)])
	lines.append("")
	lines.append("P1C-H IS THE HUNTRESS-FIRST SUBSTAGE. The original P1C Mage spell criterion (C9) and its")
	lines.append("\"both characters\" requirement are TRANSFERRED to the future Mage art phase — NOT passed,")
	lines.append("NOT deleted. Completing P1C-H does not complete P1C or P1, and does not authorize P2.")
	lines.append("")
	lines.append("Movement speed 5.0 m/s is PROVISIONAL, not a permanent cross-presentation lock. It must be")
	lines.append("re-evaluated if a 3D feasibility spike is ever authorized.")
	return "\n".join(lines)


func set_facing(index: int) -> void:
	if index < 0 or index >= P1AArt.DIRECTION_TOKENS.size():
		return
	facing_index = index
	# The accepted SpriteFrames names its animations `idle_<token>`, and every one of them
	# is an IDLE clip. There is no `walk_*` animation to select, which is why the runtime
	# says so on screen.
	var anim: String = "idle_%s" % String(P1AArt.DIRECTION_TOKENS[index])
	if actor_sprite != null and actor_sprite.sprite_frames.has_animation(anim):
		actor_sprite.animation = anim


## Aim the facing, with hysteresis. Returns the sector actually drawn.
func aim_facing(v: Vector2) -> int:
	var next: int = P1CFacing.sector_with_hysteresis(v, facing_index)
	if next != facing_index:
		set_facing(next)
	return facing_index


## C4 — resolve a click to the nearest navigable point.
func resolve_click(world: Vector2) -> Dictionary:
	var map: RID = nav_region.get_navigation_map()
	var closest: Vector2 = NavigationServer2D.map_get_closest_point(map, world)
	var off: float = closest.distance_to(world) / P1AScale.LOCKED_PX_PER_M
	last_click_was_redirected = off > 0.001
	return {"point": closest, "redirected": last_click_was_redirected, "offset_m": off}
