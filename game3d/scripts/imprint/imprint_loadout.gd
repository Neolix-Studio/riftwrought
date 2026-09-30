class_name ImprintLoadout
extends RefCounted

## THE LOADOUT — EIGHT active bindings, a SEPARATE Persistent Loadout, and one
## global Configuration Capacity budget.
##
## ============================================================================
## BINDINGS AND EQUIPPED CONFIGURATIONS ARE DIFFERENT THINGS.
## ============================================================================
## The owner's instruction is exact: "Treat bindings and equipped configurations
## as distinct concepts. DO NOT SILENTLY REWRITE EIGHT BINDINGS INTO SIX."
##
##   * `bindings` has EXACTLY EIGHT entries, ALWAYS. That is canonical --
##     `design/SKILLS_AND_SKILL_MODIFICATION.md` section 11, D-079, and the UI
##     document all say eight, in primary and shifted banks of four.
##   * UP TO EIGHT of them may hold a Configuration -- ONE PER BINDING -- and
##     that is the CURRENT WORKING BASELINE, not a lock (D-378 OD-09).
##
## From D-375 until D-380 a PROVISIONAL CANDIDATE cap of six
## (`CANDIDATE_ACTIVE_CONFIGURATIONS`) refused a seventh Configuration here --
## true when written, and D-376's working baseline. D-378 OD-09 removed it: "no
## separate arbitrary six-Configuration cap; global Capacity limits how deeply
## the loadout can be modified." So `bind()` now refuses only what is INVALID or a
## binding that DOES NOT EXIST, and a heavily modified loadout meets the Capacity
## budget in `revalidate()` instead of a slot count.
##
## An empty binding is a real state, and three of the eight start empty on
## purpose, so the distinction is VISIBLE rather than merely asserted.
##
## ---------------------------------------------------------------------------
## THE PERSISTENT LOADOUT DOES NOT CONSUME A BINDING, AND HAS NO SLOT CAP.
## ---------------------------------------------------------------------------
## Canon, section 15: "The UI places Persistent Skills in a separate Persistent
## Loadout rather than requiring one of the eight actively pressed combat
## bindings."
##
## From D-375 until D-380 a PROVISIONAL CANDIDATE cap of four refused a fifth
## Persistent Configuration here, with conflict X-02 printed beside it. D-376
## RESOLVED X-02 AGAINST THE CANDIDATE -- D-079's "NO ARBITRARY first-MVP
## Persistent-slot cap beyond legal Reservation and compatibility" STANDS -- but
## changed nothing in this project, so the cap went on being enforced. D-380
## MEASURED that and REMOVED it. Persistents are now limited NATURALLY: an
## unsupportable reservation or an over-Capacity loadout deactivates, with its
## arithmetic, in `revalidate()`.
##
## ---------------------------------------------------------------------------
## AN INVALID OR OVER-CAPACITY LOADOUT IS NEVER SILENTLY LEFT ACTIVE.
## ---------------------------------------------------------------------------
## The owner: "Removing a simulated gear bonus must produce an explicit,
## understandable result. Never silently leave an invalid build active."
## Canon, section 15: "If a loadout can no longer support its reservations,
## affected Skills deactivate with a clear explanation."
##
## `revalidate()` is the ONE place that decides, it DEACTIVATES rather than
## clamping, and every deactivation carries the arithmetic that caused it.
##
## EVERY NUMBER HERE IS PROVISIONAL.

var library: ImprintLibrary = null
## id -> SkillConfiguration
var configurations: Dictionary = {}

## EXACTLY EIGHT, ALWAYS. "" means an empty binding.
var bindings: Array[String] = []
## The separate Persistent Loadout.
var persistent: Array[String] = []

## ============================================================================
## THE SIMULATED GEAR CONTRIBUTION. IT IS A SCALAR, NOT AN EQUIPMENT SYSTEM.
## ============================================================================
## The owner: "Gear may contribute a modest bonus, represented diagnostically;
## DO NOT BUILD AN EQUIPMENT SYSTEM." So this is one boolean and one integer.
## There is no item, no affix, no slot, no inventory and no randomness anywhere
## in this project, and the suite asserts that.
var gear_bonus_active: bool = true

## Configuration id -> the reason it was deactivated. NEVER silent.
var deactivated: Dictionary = {}
## The human-readable account of the last revalidation.
var last_report: Array[String] = []
var revalidations: int = 0
var deactivation_events: int = 0
var binds_refused: int = 0
var last_refusal: String = ""

func _init(p_library: ImprintLibrary, p_configurations: Dictionary) -> void:
	library = p_library
	configurations = p_configurations
	bindings = []
	for i in ImprintConfig.CANON_ACTIVE_BINDINGS:
		bindings.append("")

# --------------------------------------------------------------- bindings ----

func binding_count() -> int:
	return bindings.size()

func configuration(id: String) -> SkillConfiguration:
	return configurations.get(id, null)

## Places a Configuration in one of the eight bindings.
##
## AN INVALID CONFIGURATION CANNOT BE EQUIPPED -- canon, section 10. The refusal
## states which problem stopped it, because "invalid" on its own is not an
## explanation.
func bind(index: int, cfg_id: String) -> Dictionary:
	if index < 0 or index >= bindings.size():
		return _refuse("binding %d does not exist; there are exactly %d active bindings"
			% [index + 1, bindings.size()])
	if cfg_id == "":
		bindings[index] = ""
		return {"ok": true, "reason": ""}
	var cfg := configuration(cfg_id)
	if cfg == null:
		return _refuse("no Configuration '%s' exists" % cfg_id)
	var v := cfg.validate()
	if not v["valid"]:
		return _refuse("'%s' is INVALID and cannot be equipped: %s"
			% [cfg_id, str(v["problems"])])
	# NO SEPARATE CAP (D-378 OD-09). One Configuration per binding is the whole
	# structural limit: assigning replaces whatever this binding held, and the
	# array has eight entries. DEPTH is limited by Capacity, in `revalidate()`.
	bindings[index] = cfg_id
	return {"ok": true, "reason": ""}

func unbind(index: int) -> void:
	if index >= 0 and index < bindings.size():
		bindings[index] = ""

func add_persistent(cfg_id: String) -> Dictionary:
	var cfg := configuration(cfg_id)
	if cfg == null:
		return _refuse("no Configuration '%s' exists" % cfg_id)
	if not cfg.is_valid():
		return _refuse("'%s' is INVALID and cannot be equipped" % cfg_id)
	if persistent.has(cfg_id):
		return _refuse("'%s' is already in the Persistent Loadout" % cfg_id)
	# NO ARBITRARY SLOT CAP (D-079 stands; D-376 X-02; D-378 OD-07). Reservation,
	# compatibility and Capacity are judged in `revalidate()`, which deactivates
	# what cannot be supported and says why -- the NATURAL limit.
	persistent.append(cfg_id)
	return {"ok": true, "reason": ""}

func remove_persistent(cfg_id: String) -> void:
	persistent.erase(cfg_id)

func _refuse(reason: String) -> Dictionary:
	binds_refused += 1
	last_refusal = reason
	return {"ok": false, "reason": reason}

## (`_active_ids_excluding()`, which existed only to count against the six cap,
## was removed with it under D-380.)

## The Configurations that are bound AND not deactivated.
func active_configuration_ids() -> Array:
	var out: Array = []
	for b in bindings:
		if b != "" and not deactivated.has(b):
			out.append(b)
	return out

## Every bound Configuration, deactivated or not. The panel needs both, because
## a deactivated Configuration must remain VISIBLE with its reason.
func bound_configuration_ids() -> Array:
	var out: Array = []
	for b in bindings:
		if b != "":
			out.append(b)
	return out

func active_persistent_ids() -> Array:
	var out: Array = []
	for p in persistent:
		if not deactivated.has(p):
			out.append(p)
	return out

func equipped_active_count() -> int:
	return active_configuration_ids().size()

func empty_binding_count() -> int:
	var n := 0
	for b in bindings:
		if b == "":
			n += 1
	return n

# --------------------------------------------------------------- capacity ----

func capacity_from_progression() -> int:
	return ImprintConfig.CAPACITY_FROM_PROGRESSION

func capacity_from_gear() -> int:
	return ImprintConfig.CAPACITY_GEAR_BONUS_DIAGNOSTIC if gear_bonus_active else 0

func capacity_total() -> int:
	return capacity_from_progression() + capacity_from_gear()

## What the ACTIVE loadout costs. A deactivated Configuration costs nothing,
## which is what makes deactivation a real resolution rather than a label.
func capacity_used() -> int:
	var total := 0
	for id in active_configuration_ids():
		total += (configuration(String(id)) as SkillConfiguration).capacity_cost()
	for id in active_persistent_ids():
		total += (configuration(String(id)) as SkillConfiguration).capacity_cost()
	return total

## What it WOULD cost with nothing deactivated -- the figure the over-Capacity
## explanation has to quote, or the arithmetic makes no sense.
func capacity_demanded() -> int:
	var total := 0
	for id in bound_configuration_ids():
		total += (configuration(String(id)) as SkillConfiguration).capacity_cost()
	for id in persistent:
		total += (configuration(String(id)) as SkillConfiguration).capacity_cost()
	return total

func capacity_available() -> int:
	return capacity_total() - capacity_used()

## Every source, with its share, so "most base Capacity comes from character
## progression" is arithmetic rather than an adjective.
func capacity_sources() -> Array:
	var total := capacity_total()
	var prog := capacity_from_progression()
	var gear := capacity_from_gear()
	return [
		["character progression", prog,
		 "%.1f%% of the total — the MAJORITY, by design" % (100.0 * float(prog) / float(maxi(1, total)))],
		["simulated gear bonus (DIAGNOSTIC)", gear,
		 "%.1f%% of the total — a MODEST bonus. There is NO equipment system here"
		 % (100.0 * float(gear) / float(maxi(1, total)))],
	]

## The number of modifier slots the ACTIVE loadout is currently sustaining --
## the quantity the ruling says Capacity limits.
func sustained_modifier_slots() -> int:
	var n := 0
	for id in active_configuration_ids():
		n += (configuration(String(id)) as SkillConfiguration).modifier_count()
	for id in active_persistent_ids():
		n += (configuration(String(id)) as SkillConfiguration).modifier_count()
	return n

# ------------------------------------------------------------ reservation ----

## Reservation, summed across the Persistent Loadout, PER RESOURCE.
##
## The two resources are summed SEPARATELY and each Configuration contributes to
## EXACTLY ONE of them, because `SkillConfiguration.resolve()` writes a single
## `reserve_resource` field. "Both" is not a state this arithmetic can reach.
func reservation() -> Dictionary:
	var mana := 0.0
	var life := 0.0
	var rows: Array = []
	for id in active_persistent_ids():
		var cfg := configuration(String(id)) as SkillConfiguration
		var res := cfg.resolve()
		var amount := float(res["reserve_amount"])
		var which := String(res["reserve_resource"])
		if which == "mana":
			mana += amount
		elif which == "life":
			life += amount
		rows.append({
			"id": id, "resource": which, "amount": amount,
			"fraction": float(res["reserve_fraction"]),
			"rank": int(res["rank"]),
			# D-380: what a Life row was converted FROM, so proportionality is
			# visible rather than asserted.
			"mana_basis": float(res.get("reserve_fraction_mana_basis", 0.0)),
			"ratio": float(res.get("conversion_ratio", 0.0)),
		})
	return {"mana": mana, "life": life, "rows": rows}

# ------------------------------------------------------------ revalidation ---

## ============================================================================
## THE ONE PLACE THAT DECIDES WHETHER THE LOADOUT IS LEGAL.
## ============================================================================
## It runs on every change the panel makes, and it NEVER leaves an illegal state
## active. Three things can make a loadout illegal, and each produces its own
## explicit, arithmetic-bearing account:
##   1. a Configuration became INVALID (a Transform removed an enabling tag, an
##      Effective Rank exceeded its mastery, a modifier lost its class);
##   2. the loadout demands more Capacity than it has;
##   3. the reservations cannot be supported.
##
## Deactivation walks the ACTIVE bindings from the LAST to the first, so the
## Configuration the player most recently reached for is the last to go.
func revalidate(pool: ResourcePool) -> Dictionary:
	revalidations += 1
	deactivated = {}
	last_report = []

	# --- 1. INVALID CONFIGURATIONS ------------------------------------------
	for id in bound_configuration_ids() + persistent:
		var cfg := configuration(String(id)) as SkillConfiguration
		var v := cfg.validate()
		if not v["valid"]:
			deactivated[id] = "INVALID: %s" % str(v["problems"])
			deactivation_events += 1
			last_report.append("DEACTIVATED %s — %s" % [id, deactivated[id]])

	# --- 2. CAPACITY ---------------------------------------------------------
	var demanded := capacity_demanded()
	var total := capacity_total()
	if capacity_used() > total:
		var shortfall := capacity_used() - total
		last_report.append("OVER CAPACITY by %d: the loadout demands %d and the budget is %d "
			% [shortfall, capacity_used(), total]
			+ "(%d from character progression + %d from the simulated gear bonus). "
			% [capacity_from_progression(), capacity_from_gear()]
			+ "THE BUILD IS NOT LEFT ACTIVE.")
		# Walk the bindings backwards, deactivating until the budget holds.
		var i := bindings.size() - 1
		while i >= 0 and capacity_used() > total:
			var b := bindings[i]
			if b != "" and not deactivated.has(b):
				var cost := (configuration(b) as SkillConfiguration).capacity_cost()
				deactivated[b] = ("OVER CAPACITY: deactivated to recover %d Capacity, because the "
					+ "loadout demanded %d against a budget of %d") % [cost, demanded, total]
				deactivation_events += 1
				last_report.append("DEACTIVATED binding %d (%s) — recovered %d Capacity; "
					% [i + 1, b, cost]
					+ "now using %d of %d" % [capacity_used(), total])
			i -= 1
		# Persistent Configurations are the LAST resort, because a reservation
		# that vanishes changes the whole build rather than one button.
		var k := persistent.size() - 1
		while k >= 0 and capacity_used() > total:
			var pid: String = persistent[k]
			if not deactivated.has(pid):
				var pcost := (configuration(pid) as SkillConfiguration).capacity_cost()
				deactivated[pid] = ("OVER CAPACITY: the Persistent Configuration was deactivated "
					+ "LAST, recovering %d Capacity") % pcost
				deactivation_events += 1
				last_report.append("DEACTIVATED Persistent %s — recovered %d Capacity" % [pid, pcost])
			k -= 1

	# --- 3. RESERVATION ------------------------------------------------------
	# Canon, section 15: "If a loadout can no longer support its reservations,
	# affected Skills deactivate with a clear explanation."
	var res := reservation()
	while float(res["mana"]) >= ImprintConfig.MANA_MAX and not active_persistent_ids().is_empty():
		var victim: String = String(active_persistent_ids().back())
		deactivated[victim] = ("RESERVATION UNSUPPORTABLE: the Persistent Loadout reserved %.1f of "
			+ "%.1f maximum Mana, which would leave nothing usable") % [res["mana"], ImprintConfig.MANA_MAX]
		deactivation_events += 1
		last_report.append("DEACTIVATED %s — %s" % [victim, deactivated[victim]])
		res = reservation()
	while float(res["life"]) >= ImprintConfig.LIFE_MAX and not active_persistent_ids().is_empty():
		var victim2: String = String(active_persistent_ids().back())
		deactivated[victim2] = ("RESERVATION UNSUPPORTABLE: the Persistent Loadout reserved %.1f of "
			+ "%.1f maximum Life") % [res["life"], ImprintConfig.LIFE_MAX]
		deactivation_events += 1
		last_report.append("DEACTIVATED %s — %s" % [victim2, deactivated[victim2]])
		res = reservation()

	# --- APPLY ---------------------------------------------------------------
	if pool != null:
		pool.set_reservation(float(res["mana"]), float(res["life"]))

	if last_report.is_empty():
		last_report.append("LOADOUT VALID — using %d of %d Capacity (%d free), sustaining %d modifier slot(s)"
			% [capacity_used(), capacity_total(), capacity_available(), sustained_modifier_slots()])

	return {
		"valid": deactivated.is_empty(),
		"deactivated": deactivated.duplicate(),
		"report": last_report.duplicate(),
		"capacity_used": capacity_used(),
		"capacity_total": capacity_total(),
		"capacity_demanded": demanded,
		"reservation": res,
	}

# ------------------------------------------------------------------- xp ------

## ============================================================================
## EVERY IMPRINT THE ACTIVE LOADOUT HOLDS, DUPLICATES INCLUDED.
## ============================================================================
## Deliberately WITH duplicates. The de-duplication belongs to the library,
## where the mastery record lives, and handing it a clean list here would hide
## the very defect the owner asked to be controlled for. The library counts what
## it collapses.
func equipped_imprint_ids_with_duplicates() -> Array:
	var out: Array = []
	for id in active_configuration_ids():
		out.append_array((configuration(String(id)) as SkillConfiguration).imprint_ids())
	for id in active_persistent_ids():
		out.append_array((configuration(String(id)) as SkillConfiguration).imprint_ids())
	return out
