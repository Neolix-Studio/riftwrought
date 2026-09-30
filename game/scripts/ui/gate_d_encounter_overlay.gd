class_name GateDEncounterOverlay
extends Control
## Prototype Zero — Graveblade encounter instrumentation (specification §22).
##
## Authored in Gate D, when the room held exactly one Graveblade. Gate E's repeat
## loop spawns waves of up to three, and this card still shows ONE — the first
## living one — so every line that could be mistaken for a statement about the
## whole room now names the enemy it is describing. The Gate E lab panel lists
## the full roster.
##
## Development instrumentation, NOT the Prototype HUD from §17 and NOT Gate F's
## Fallen overlay: there is no Wroughtglass reservoir, no Skill bank, no Rift
## Shards, no minimap, no Restart button, and no pause. The Life readouts here
## are debug numbers with bars behind them.
##
## It exists so the eight things D-181 asks to be judgeable can actually be
## judged while playing:
##
##   awareness and chase          the state line and the distance
##   attack permission            who holds the coordinator's one slot
##   wind-up and commitment       the phase, the commit countdown, and the locked
##                                direction in degrees
##   release and genuine miss     the last release outcome and why
##   player and enemy Life        both bars
##   successful damage            the last DamageEvent, in full
##   enemy death                  the ordered kill line
##   player mechanical death      the FALLEN line with its killing source
##
## The always-visible card is small. The ordered event trace is behind F3.

const SLATE: Color = Color(0.075, 0.082, 0.098, 0.88)
const IRON: Color = Color(0.24, 0.26, 0.30)
const COPPER: Color = Color(0.85, 0.58, 0.30)
const TEXT: Color = Color(0.84, 0.86, 0.90)
const BLOOD: Color = Color(0.86, 0.34, 0.30)
const BONE: Color = Color(0.80, 0.78, 0.70)

var room: PrototypeZeroRoom

## Seconds of the player's damage flash still to run. Restrained diagnostic
## feedback so a Hit can be SEEN landing, not Gate F's synchronised feedback pass.
var _player_flash: float = 0.0

var _life_label: Label
var _life_bar: ProgressBar
var _enemy_label: Label
var _enemy_bar: ProgressBar
var _state_line: RichTextLabel
var _fallen_line: RichTextLabel
var _trace_panel: PanelContainer
var _trace: RichTextLabel


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()


func bind_room(owner_room: PrototypeZeroRoom) -> void:
	room = owner_room
	room.player.took_damage.connect(_on_player_damaged)


func _on_player_damaged(_event: DamageEvent) -> void:
	_player_flash = 1.0


func toggle_detail() -> void:
	_trace_panel.visible = not _trace_panel.visible


func set_detail_visible(value: bool) -> void:
	_trace_panel.visible = value


func _build() -> void:
	# Top centre: the one band of screen the Gate B instruction cards, the leak
	# test, the Gate C combat card, and the Gate B event log all leave clear. It
	# is also where specification §17 eventually puts enemy identity, so the
	# instrumentation is not sitting where the real HUD will not.
	var card: PanelContainer = _panel()
	card.set_anchors_preset(Control.PRESET_CENTER_TOP)
	card.position = Vector2(-200, 14)
	card.custom_minimum_size = Vector2(400, 0)
	var box: VBoxContainer = VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	# EVERGREEN COPY. This said "one Graveblade", which was true for the whole of
	# Gate D and stopped being true the moment Gate E's repeat loop spawned a wave
	# of two. The card still shows ONE Graveblade — the tracked one — and now says
	# so rather than implying there is only one to show.
	box.add_child(_label("Gate D — Graveblade combat", 17, COPPER))

	_life_label = _label("Life 500 / 500", 14, TEXT)
	_life_bar = _bar(BONE)
	box.add_child(_life_label)
	box.add_child(_life_bar)

	_enemy_label = _label("Graveblade 300 / 300", 14, TEXT)
	_enemy_bar = _bar(BLOOD)
	box.add_child(_enemy_label)
	box.add_child(_enemy_bar)

	_state_line = _rich(13)
	box.add_child(_state_line)
	_fallen_line = _rich(15)
	box.add_child(_fallen_line)
	card.add_child(box)
	add_child(card)

	# Right column, BELOW the Gate B F3 block rather than across it, and above the
	# Gate C combat card in the lower right.
	_trace_panel = _panel()
	_trace_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_trace_panel.position = Vector2(-486, 400)
	_trace_panel.custom_minimum_size = Vector2(458, 0)
	_trace = _rich(13)
	_trace_panel.add_child(_trace)
	_trace_panel.visible = false
	add_child(_trace_panel)


func _process(delta: float) -> void:
	if room == null or room.player == null:
		return
	_player_flash = maxf(_player_flash - delta * 2.5, 0.0)
	_update_life()
	_update_state()
	if _trace_panel.visible:
		_update_trace()


func _update_life() -> void:
	var player: PrototypePlayer = room.player
	_life_bar.max_value = player.max_life
	_life_bar.value = player.life
	_life_label.text = "Life %.0f / %.0f    (%.0f per Quick Strike)" % [
		player.life, player.max_life, player.physical_damage,
	]
	_life_label.add_theme_color_override("font_color", TEXT.lerp(BLOOD, _player_flash))

	# `room.graveblade` is the first LIVING Graveblade, so during a Gate E wave
	# this row is one of several. It names which, rather than letting a single
	# Life bar read as the whole wave.
	var enemy: PrototypeGraveblade = room.graveblade
	if enemy == null:
		_enemy_bar.value = 0.0
		_enemy_label.text = "Graveblade — none active"
		return
	var alive: int = room.living_graveblade_count()
	_enemy_bar.max_value = enemy.data.max_life
	_enemy_bar.value = enemy.life
	_enemy_label.text = "%s %.0f / %.0f    (%.0f per Hit, %d to kill it)%s" % [
		enemy.name, enemy.life, enemy.data.max_life, enemy.data.physical_damage,
		enemy.data.hits_to_defeat(room.player.physical_damage),
		"    tracked — 1 of %d alive" % alive if alive > 1 else "",
	]


func _update_state() -> void:
	var enemy: PrototypeGraveblade = room.graveblade
	if enemy == null:
		# This used to say "F11 restores the encounter", which is false during
		# UPGRADE_ON_GROUND and PASSIVE_READY: having no active Graveblade is
		# INTENDED in both, and F11 there restores the stage rather than an enemy.
		# The Gate E card already states the current stage, so this says only what
		# it can see and leaves the explanation to the surface that owns it.
		_state_line.text = "[color=#7b828d]No active Graveblade in the room.[/color]"
	else:
		var permission: String = "held" if room.attack_coordinator.holds_permission(enemy) else "not held"
		var commitment: String = "tracking"
		if enemy.committed and enemy.is_attacking():
			commitment = "COMMITTED %.0f deg" % rad_to_deg(atan2(
				enemy.release_direction.x, enemy.release_direction.z))
		elif enemy.state == PrototypeGraveblade.State.ATTACK_WINDUP:
			commitment = "commits in %.2f s" % maxf(enemy.data.commit_time() - enemy.state_time, 0.0)
		var outcome: String = "none yet"
		if not enemy.last_release.is_empty():
			outcome = "use %d %s — %s" % [
				enemy.last_release["use_id"], enemy.last_release["outcome"],
				enemy.last_release["reason"],
			]
		_state_line.text = (
			"[color=#7b828d]state[/color] [color=#d6dae1]%s[/color]  %.2f s   " % [
				enemy.state_name(), enemy.state_time,
			] +
			"[color=#7b828d]%.2f m away[/color]\n" % enemy.distance_to_player() +
			"[color=#7b828d]permission[/color] %s   [color=#7b828d]direction[/color] %s\n" % [
				permission, commitment,
			] +
			"[color=#7b828d]last release[/color] %s" % outcome
		)

	if room.player.is_alive():
		_fallen_line.text = ""
		return
	# Gate D owns MECHANICAL death only. This one truthful line is the whole of
	# it; the Fallen overlay and the trusted Restart flow are Gate F.
	var event: DamageEvent = room.player.last_damage_taken
	_fallen_line.text = "[color=#e0574e][b]FALLEN[/b] — %s — Melee Hit — %.0f Physical Damage[/color]\n[color=#7b828d]Gate D owns mechanical death only. F11 resets the encounter.[/color]" % [
		room.graveblade.data.display_name if room.graveblade != null else "Graveblade",
		event.raw_physical_damage if event != null else 0.0,
	]


## The ordered Hit / kill / fall trace. Order is the thing Gate D has to prove,
## so it is shown as a sequence rather than as counters.
func _update_trace() -> void:
	var enemy: PrototypeGraveblade = room.graveblade
	var lines: PackedStringArray = PackedStringArray()
	lines.append("[color=#d9954c][b]Gate D encounter (F3)[/b][/color]")
	if enemy != null:
		# One tracked enemy, named. The Gate E F3 panel lists the whole roster.
		lines.append("tracked    %s  %s  %.2f s   Life %.0f/%.0f   %.2f m" % [
			enemy.name, enemy.state_name(), enemy.state_time, enemy.life,
			enemy.data.max_life, enemy.distance_to_player(),
		])
		lines.append("attacks    %d started, %d released, %d queries, %d hit, %d missed" % [
			enemy.attacks_started, enemy.attacks_released, enemy.release_queries,
			enemy.attacks_hit, enemy.attacks_missed,
		])
		lines.append("commitment %s   cooldown %.2f s   reactions %d" % [
			"locked" if enemy.committed else "open",
			enemy.commitment_cooldown_remaining(), enemy.hit_reactions,
		])
	lines.append("coordinator holder %s   %d requests, %d grants, %d refusals" % [
		room.attack_coordinator.holder().name if room.attack_coordinator.holder() != null else "none",
		room.attack_coordinator.requests, room.attack_coordinator.grants,
		room.attack_coordinator.refusals,
	])
	# D-186. The group handoff is the one coordinator rule a player can feel, so
	# it is shown as a live countdown rather than inferred from a refusal string.
	lines.append("group handoff  %s   %d started, %d refused   after %s" % [
		"—" if not room.attack_coordinator.group_handoff_active()
			else "%.2f s of %.2f s" % [
				room.attack_coordinator.group_handoff_remaining(),
				room.attack_coordinator.group_handoff_delay,
			],
		room.attack_coordinator.handoffs_started, room.attack_coordinator.handoff_refusals,
		room.attack_coordinator.last_handoff_source,
	])
	lines.append("last decision  %s" % room.attack_coordinator.last_decision)
	lines.append("player damage  %d DamageEvents taken, %d dealt" % [
		room.player.damage_taken_events, room.player.attack.damage_events,
	])
	lines.append("[color=#7b828d]ordered events, oldest first:[/color]")
	var shown: int = mini(room.combat_events.size(), 8)
	for index: int in range(room.combat_events.size() - shown, room.combat_events.size()):
		var entry: Dictionary = room.combat_events[index]
		lines.append("  %-12s use %-3d %-5.0f dmg  %s" % [
			entry["kind"], entry["use_id"], entry["damage"], entry["detail"],
		])
	if room.combat_events.is_empty():
		lines.append("  (nothing yet)")
	_trace.text = "\n".join(lines)


# --- Small builders ----------------------------------------------------------

func _panel() -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = SLATE
	style.border_color = IRON
	style.set_border_width_all(1)
	style.set_corner_radius_all(3)
	style.set_content_margin_all(12)
	panel.add_theme_stylebox_override("panel", style)
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	return panel


func _bar(colour: Color) -> ProgressBar:
	var bar: ProgressBar = ProgressBar.new()
	bar.show_percentage = false
	bar.custom_minimum_size = Vector2(0, 10)
	var fill: StyleBoxFlat = StyleBoxFlat.new()
	fill.bg_color = colour
	fill.set_corner_radius_all(2)
	bar.add_theme_stylebox_override("fill", fill)
	return bar


func _label(text: String, size: int, colour: Color) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", colour)
	return label


func _rich(size: int) -> RichTextLabel:
	var rich: RichTextLabel = RichTextLabel.new()
	rich.bbcode_enabled = true
	rich.fit_content = true
	rich.scroll_active = false
	rich.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rich.add_theme_font_size_override("normal_font_size", size)
	rich.add_theme_font_size_override("bold_font_size", size)
	rich.add_theme_color_override("default_color", TEXT)
	return rich
