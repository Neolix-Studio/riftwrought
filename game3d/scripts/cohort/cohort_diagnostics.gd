class_name CohortDiagnostics
extends Node

## THE D-398 DIAGNOSTIC MODES — a stress population and a travel speed, for the
## owner's live review. NEITHER IS GAMEPLAY.
##
## ============================================================================
## "Add diagnostic stress modes for 2, 6, 10 and 15 mobile minions and
## provisional travel-speed modes representing ordinary, fast and extreme
## late-game movement. These modes must not change the canonical pack size,
## reservation, Capacity, damage or Skill definition. Clearly label them as
## diagnostic."
## ============================================================================
##   * THE POPULATION is the pack PLUS diagnostic stress minions. The pack stays
##     the Configuration's `pack_size`; the stress minions are a separate,
##     labelled list in `HoundRuntime` that exists only beside a living pack.
##   * THE SPEED scales her ACCEPTED top speed through ONE declared seam on the
##     controller (`diagnostic_travel_speed_scale`, 1.0 in normal play).
##     `ProdConfig.TOP_SPEED_MPS` is not touched; ORDINARY is exactly it.
##
## THE TWO CONTROLS ARE REVIEW CONTROLS, NOT COMMANDS: they address no minion,
## and nothing in scripts/hounds/ reads them. At launch: population 2, ORDINARY.

var hounds: HoundRuntime = null
var player: PlayerController = null
var population_index: int = 0
var speed_index: int = 0

## Diagnostics the suite reads. LOGS, not control state.
var population_changes: int = 0
var speed_changes: int = 0

func setup(p_hounds: HoundRuntime, p_player: PlayerController) -> void:
	hounds = p_hounds
	player = p_player
	_apply()

func _physics_process(_delta: float) -> void:
	if InputMap.has_action(CohortConfig.POPULATION_ACTION) and Input.is_action_just_pressed(CohortConfig.POPULATION_ACTION):
		cycle_population()
	if InputMap.has_action(CohortConfig.SPEED_ACTION) and Input.is_action_just_pressed(CohortConfig.SPEED_ACTION):
		cycle_speed()

func cycle_population() -> void:
	population_index = (population_index + 1) % CohortConfig.POPULATIONS.size()
	population_changes += 1
	_apply()

func cycle_speed() -> void:
	speed_index = (speed_index + 1) % CohortConfig.speed_modes().size()
	speed_changes += 1
	_apply()

## Sets a population by value (2, 6, 10 or 15) -- for the captures and the suite.
func set_population(total: int) -> void:
	var i := CohortConfig.POPULATIONS.find(total)
	if i < 0:
		return
	if i != population_index:
		population_changes += 1
	population_index = i
	_apply()

## Sets a travel speed by name (ORDINARY, FAST or EXTREME).
func set_speed(mode_name: String) -> void:
	var modes := CohortConfig.speed_modes()
	for i in modes.size():
		if String(modes[i][0]) == mode_name:
			if i != speed_index:
				speed_changes += 1
			speed_index = i
			_apply()
			return

func population() -> int:
	return int(CohortConfig.POPULATIONS[population_index])

func speed_name() -> String:
	return String(CohortConfig.speed_modes()[speed_index][0])

func speed_scale() -> float:
	return float(CohortConfig.speed_modes()[speed_index][1])

func _apply() -> void:
	if hounds != null:
		hounds.set_diagnostic_population(population())
	if player != null:
		player.diagnostic_travel_speed_scale = speed_scale()
