class_name RiftMoteRuntime
extends RefCounted
## Riftwrought — Roguelite Foundation H8: the Experience Mote subsystem of one Rift
## run, owned whole — its run, its mote field and every Graveblade binding it has
## connected — behind two mote operations, a handful of scalar readings, and, since
## Foundation I1, its run's own level-up offer, opened and taken only when asked.
##
## THE ONE THING IT PROVES. The chain
##
##     register a Graveblade -> keep its binding -> its real death drops a mote
##         -> an explicit sweep collects that mote into the run
##
## runs end to end through one object, with no part of it handed out. A runtime is
## made for one exact run seed. It makes that run (Foundation G4) and a mote field of
## the same seed (Foundation H5), and begins with no binding. Asked to register one
## live Graveblade with an amount, it makes that Graveblade's one binding (Foundation
## H7) from its own run's seed, that Graveblade, its own field and exactly that
## amount, asks the binding to connect, and keeps it only if it connected. Asked to
## sweep at the player's position, it sweeps its own field into its own run and
## returns the field's own answer.
##
##
## IT HOLDS THREE THINGS, AND NOTHING ELSE
## ---------------------------------------------------------------------------
## The run, the field, and the bindings that connected, each keyed by the exact
## Graveblade it hears. The run seed is not stored a second time: the run already
## holds it and is asked whenever it is needed. No count, amount, position, level,
## drop, offer, answer or history is kept here — each is already owned below and is
## asked at the moment it is read, and a second copy of any of it would be a second
## thing that could be wrong.
##
## THE KEY IS THE GRAVEBLADE ITSELF — never its node name, its display name, a room,
## an index, its record, the attacker a death names, or a seed. Two Graveblades that
## share a name are two keys.
##
## NOTHING LIVE IS HANDED OUT. No reading returns the run, the field, a binding, the
## key collection, a Graveblade or an offer. Every mote reading is a scalar; every
## offer reading is the run's own independent copy; the two operations that answer an
## object answer the field's own sweep value and the run's own level-up record,
## neither of which holds any of them; and, since Roguelite I3 (D-295), one reading
## hands out the run's temporary build — as the run's own independent COPY. This
## runtime may hand out a copied build value; it never hands out the build the run
## owns and goes on using, and it keeps no build of its own.
##
## THE COLLECTION IS WALKED THROUGH ITS KEYS AND ITS VALUES, NEVER DIRECTLY. Measured
## in a scratch probe made for this foundation: iterating a typed dictionary one of
## whose keys has been freed raises an engine error and stops early, while asking it
## for its keys or its values does not.
##
##
## THE BINDINGS ARE OWNED HERE, STRONGLY (D-285)
## ---------------------------------------------------------------------------
## A binding does not keep itself alive: its signal connection names it without
## holding it. The collection here is what holds each one, so its connection keeps
## working for as long as this runtime lives, after every local reference made while
## registering is gone. A binding stays here after its Graveblade dies, with its
## answer, until the whole runtime is let go — and letting the runtime go lets every
## binding and its connection go with it. There is no unregistering, pruning, reset,
## clear, re-arm, transfer or reuse: a new run is a new runtime.
##
##
## THE REGISTRATION ORDER IS THE CONTRACT
## ---------------------------------------------------------------------------
## 1. No Graveblade refuses.
## 2. A runtime whose own run and field are not coherent refuses, with the reason.
## 3. A Graveblade already registered here refuses — before any binding is made, so
##    a second registration can add neither a binding nor a callback.
## 4. Only then is one binding made, from this run's exact seed, that Graveblade,
##    this field and exactly the amount given.
## 5. The binding is asked to connect to that Graveblade's death.
## 6. If it refuses, its reason is returned unchanged and the binding is let go:
##    nothing was kept and nothing listens, so the same Graveblade may be registered
##    again, while it still lives, with an amount that is accepted.
## 7. Only after it connected is it kept, keyed by that Graveblade.
##
##
## THE SWEEP IS THE FIELD'S
## ---------------------------------------------------------------------------
## A sweep asks this runtime's field to sweep itself into this runtime's run for the
## position given, and returns the field's answer exactly as it came back. Pickup
## range, order, Experience Gain, awards and refusals are all decided below, and
## nothing here restates them. Nothing sweeps on its own: no clock, no process step
## and no timer asks — only a caller. A death drops a mote and awards nothing;
## experience moves only when a sweep collects a mote in range; and reaching a
## level's requirement through a sweep opens nothing and advances nothing.
##
##
## THE LEVEL-UP OFFER IS THE RUN'S, AND ONLY ITS OWNER ASKS (Foundation I1, D-291)
## ---------------------------------------------------------------------------
## A caller may ask this runtime to open the current level's offer, read the offer
## that stands, and take one lane of it. Each of those is one line handing the
## question to the run and returning the run's answer exactly as it came back. The
## run (Foundation G4) alone decides whether the current requirement is met, which
## root seed the offer is composed from, what the offer holds, whether a lane may be
## taken, what taking it grants, and the one level it advances — and every refusal
## it gives comes back here word for word.
##
## THE CALLER SUPPLIES WHAT AN OFFER IS COMPOSED FROM, EVERY TIME. The equipped Skill
## profiles, the support definitions and the passive-card definitions arrive as
## arguments and are handed straight on; none of them is kept, and no record, id or
## constant of any of them is named in this file.
##
## NOTHING OF THE OFFER IS KEPT HERE. No offer, lane, identity, seed, requirement or
## level-up record is cached, and no fourth field exists to hold one. Every offer
## reading is the run's own copy, and the record a choice answers is the run's own,
## handed on and let go.
##
## NOTHING OPENS ON ITS OWN. Not when a sweep reaches the requirement, not after a
## choice leaves surplus experience behind, and not after a refusal: an offer opens
## only when a caller asks for one, and taking a lane opens nothing further.
##
## WHAT IT DOES NOT DO. It opens, offers and chooses nothing on its own, and holds no
## offer, catalogue, build or level-up record; names no amount, enemy family, room, round or
## encounter; finds no enemy on its own; tracks no player; shows, moves and saves
## nothing. It is not a node: no scene, no signal of its own, no clock, no random
## source, no file. Nothing that runs creates a runtime.

## The one run this subsystem belongs to (Foundation G4), made here from the exact
## seed given. Never handed out.
var _run: RiftRunLevelCoordinator

## That run's mote field (Foundation H5), made here from the same exact seed. Never
## handed out.
var _field: RiftMoteField

## Every binding (Foundation H7) that connected, keyed by the exact Graveblade it
## hears. Only ever added to; never handed out and never walked directly.
var _bindings: Dictionary[PrototypeGraveblade, RiftGravebladeMoteBinding] = {}


## A new Experience Mote subsystem of the run seeded `for_run_seed`: that run, a
## mote field of the same seed, and no binding. Nothing is looked up, connected,
## swept, awarded, levelled or offered.
func _init(for_run_seed: int) -> void:
	_run = RiftRunLevelCoordinator.new(for_run_seed)
	_field = RiftMoteField.new(for_run_seed)


# --- Registering a Graveblade -----------------------------------------------------

## Registers one live Graveblade, whose mote will carry `base_experience`, in the
## order the header states. Returns "" when its binding connected and was kept, or
## the single plain-language reason it was not — in which case nothing was kept and
## nothing listens.
func register_graveblade(enemy: PrototypeGraveblade, base_experience: float) -> String:
	if enemy == null:
		return "a run's Experience Mote runtime registers a Graveblade, and none was given"
	var incoherent: String = _owned_problem()
	if not incoherent.is_empty():
		return incoherent
	if _bindings.has(enemy):
		return "this Graveblade is already registered with this run's Experience Mote runtime; it registers nothing again"
	var binding: RiftGravebladeMoteBinding = RiftGravebladeMoteBinding.new(_run.run_seed(), enemy, _field, base_experience)
	var refusal: String = binding.connect_to_death()
	if not refusal.is_empty():
		return refusal
	_bindings[enemy] = binding
	return ""


# --- Sweeping -----------------------------------------------------------------------

## Sweeps this runtime's field into this runtime's run for a player standing at
## `player_position`, and returns the field's own answer unchanged.
func sweep_at(player_position: Vector3) -> RiftMoteSweepResult:
	return _field.sweep_collection(player_position, _run)


# --- The current level's offer, asked of the run (Foundation I1) ---------------------
#
# One line each, handing the question to the run and returning its own answer. No
# readiness, seed, lane, identity, build change or level is decided, checked or
# copied here.

## Asks the run to open the current level's offer from the equipped Skill profiles,
## the support definitions and the passive-card definitions the caller supplies.
## Returns the run's answer unchanged: "" when the offer opened, or the run's own
## reason when it did not.
func open_level_up_offer(
	profiles: Array[SkillTagProfile],
	definitions: Array[SupportDefinition],
	cards: Array[PassiveCardDefinition]
) -> String:
	return _run.open_current_offer(profiles, definitions, cards)


## The standing offer's root seed, as the run answers it — meaningful only while
## `is_offer_active()`.
func offer_root_seed() -> int:
	return _run.offer_root_seed()


## The standing offer's lanes in their composed order, as the run's own copy.
func offer_lanes() -> Array[int]:
	return _run.offer_lanes()


## The mechanical identity one lane of the standing offer would grant, as the run's
## own copy.
func offer_identity_for(lane: int) -> PackedStringArray:
	return _run.offer_identity_for(lane)


## The standing offer's Support content kind, as the run answers it (Roguelite I10,
## D-312) — the offer contract's unresolved value while no offer stands.
func offer_support_content_kind() -> int:
	return _run.offer_support_content_kind()


## The passive category a standing passive-fallback Support lane draws from, as the run
## answers it (Roguelite I10, D-312) — the no-fallback sentinel otherwise.
func offer_support_fallback_category() -> int:
	return _run.offer_support_fallback_category()


## The requirement frozen when the standing offer opened, as the run answers it.
func frozen_offer_requirement() -> float:
	return _run.frozen_requirement()


## Asks the run to take one lane of its standing offer, and returns the run's own
## level-up record unchanged. Nothing of it is kept here.
func choose_level_up_lane(lane: int) -> RiftRunLevelUpResult:
	return _run.choose(lane)


# --- The run's temporary build, as a copy (Roguelite I3, D-295) ------------------------
#
# One line, handing the question to the run and returning its answer. Nothing of the
# build is kept, checked or copied here: the copy the caller receives is the run's own.

## The run's temporary build, as the run's own independent copy — the one value its
## owner reads to apply what this expedition has chosen. Changing the copy cannot
## change this run.
func run_build() -> RiftRunBuild:
	return _run.run_build()


# --- Reading the runtime --------------------------------------------------------------
#
# Scalars only, every one asked of its owner at the moment it is read, and
# deliberately no setter and no way to reach the run, the field, a binding or a
# Graveblade.

func run_seed() -> int:
	return _run.run_seed()


func level() -> int:
	return _run.level()


## The current level's experience progress, as the run answers it.
func experience() -> float:
	return _run.experience()


func is_offer_active() -> bool:
	return _run.is_offer_active()


func binding_count() -> int:
	return _bindings.size()


func drop_count() -> int:
	return _field.drop_count()


func collected_count() -> int:
	return _field.collected_count()


func uncollected_count() -> int:
	return _field.uncollected_count()


## Whether `enemy` is registered here. False — never an error — for no Graveblade.
func is_registered(enemy: PrototypeGraveblade) -> bool:
	return enemy != null and _bindings.has(enemy)


## Whether `enemy`'s binding has heard its death. False for a Graveblade that is not
## registered here: failing closed, it has heard nothing this runtime knows of.
func has_observed_death(enemy: PrototypeGraveblade) -> bool:
	return is_registered(enemy) and _bindings[enemy].has_observed_death()


## `enemy`'s binding's retained answer, exactly as the binding keeps it — "" before its
## death is heard and when its mote was dropped, the refusal otherwise. For a
## Graveblade that is not registered here it is this plain-language diagnostic instead,
## which is never "".
func emission_answer(enemy: PrototypeGraveblade) -> String:
	if not is_registered(enemy):
		return "that Graveblade is not registered with this run's Experience Mote runtime, so it has no emission answer"
	return _bindings[enemy].emission_answer()


# --- Coherence -------------------------------------------------------------------------

## Returns "" when this runtime's run and field are coherent together and every entry
## is a Graveblade that still exists, holding a binding that connected — or the first
## thing that is not, as one plain-language reason. Only what this runtime owns is
## checked: each binding answers for its own Graveblade, field and emission.
func problem() -> String:
	var owned: String = _owned_problem()
	if not owned.is_empty():
		return owned
	for key: Variant in _bindings.keys():
		if key == null:
			return "a Graveblade registered with this run's Experience Mote runtime no longer exists"
		if not (key is PrototypeGraveblade):
			return "an entry of this run's Experience Mote runtime is not keyed by a Graveblade"
	for value: Variant in _bindings.values():
		if value == null or not (value is RiftGravebladeMoteBinding):
			return "an entry of this run's Experience Mote runtime holds no Graveblade binding"
		if not (value as RiftGravebladeMoteBinding).has_connected():
			return "an entry of this run's Experience Mote runtime holds a binding that never connected"
	return ""


## The run and the field, together: both exist, the field is coherent by its own
## rule, and both answer the same whole run seed.
func _owned_problem() -> String:
	if _run == null:
		return "this Experience Mote runtime holds no run"
	if _field == null:
		return "this Experience Mote runtime holds no mote field"
	var incoherent: String = _field.problem()
	if not incoherent.is_empty():
		return incoherent
	if _field.run_seed() != _run.run_seed():
		return "this Experience Mote runtime's mote field belongs to run seed %d, not to its run's seed %d; it registers nothing" % [
			_field.run_seed(), _run.run_seed(),
		]
	return ""
