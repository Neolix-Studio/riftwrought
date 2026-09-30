class_name HoundTargeting
extends RefCounted

## HOW A KINDRED HOUND CHOOSES — the accepted rule, and nothing else (D-396).
##
## ============================================================================
## THE RULE, AS THE OWNER ACCEPTED IT (D-394 ruling 3) AND ORDERED IT (D-396):
## ============================================================================
##   1. RETAIN the current target while it remains alive, eligible, reachable and
##      within the leash;
##   2. otherwise choose the NEAREST reachable eligible enemy TO THAT HOUND among
##      candidates inside the HUNTRESS-CENTRED acquisition range;
##   3. an EXACT distance tie goes to the LOWER stable combat-entity ID;
##   4. never engine iteration order, node name, memory identity, a designation or
##      Huntress's Mark.
##
## Read with D-391 rulings 3 and 4: eligibility is the GENERAL enemy-eligibility
## rule (`HitEligibility`), and engagement also needs a reachable navigation
## path. The acquisition and leash distances are measured FROM THE HUNTRESS;
## "nearest" is measured FROM THE HOUND. "Exact" is exact: no tolerance is set.
##
## PURE AND STATIC, so the D-396 suite can drive it with exact positions and a
## reachability function of its own choosing. Reachability is a Callable taking a
## registry record and returning a bool; the live hound passes a path query.
##
## ORDER DECIDES NOTHING: candidates are read from the area's registry in its
## registration order, and the choice is a minimum over distance, then over
## `CombatEntityRegistry.precedes()`. Nothing here reads a node's name, its
## instance id or its position in a scene tree.

const RETAINED := "RETAINED"
const ACQUIRED := "ACQUIRED"
const ACQUIRED_TIE := "ACQUIRED (TIE)"
const ABANDONED_LEASH := "ABANDONED — BEYOND THE LEASH"
const ABANDONED_INVALID := "ABANDONED — NO LONGER ELIGIBLE"
const ABANDONED_UNREACHABLE := "ABANDONED — UNREACHABLE"
const NONE := "NONE"

static func planar(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()

static func position_of(record: Dictionary) -> Vector3:
	var n = record.get("node", null)
	if n == null or not is_instance_valid(n) or not (n is Node3D):
		return Vector3.INF
	return (n as Node3D).global_position

## The body radius a bite measures to: the entity's own answer if it gives one,
## else the ordinary enemy's accepted radius.
static func radius_of(record: Dictionary) -> float:
	var n = record.get("node", null)
	if n != null and is_instance_valid(n) and n.has_method("combat_body_radius"):
		return float(n.call("combat_body_radius"))
	return ProdConfig.ENEMY_BODY_RADIUS

## THE CHEAP CHECK, run EVERY physics step on a retained target: eligibility and
## the leash. No path query -- so an abandonment on death or on crossing the leash
## happens on the step it becomes true. Returns {"valid", "code", "why"}.
static func still_eligible_and_leashed(record: Dictionary, handler_pos: Vector3) -> Dictionary:
	var e := HitEligibility.evaluate(record)
	if not bool(e["eligible"]):
		return {"valid": false, "code": ABANDONED_INVALID, "why": String(e["reason"])}
	var d := planar(handler_pos, position_of(record))
	if d > HoundConfig.LEASH_RANGE_M:
		return {"valid": false, "code": ABANDONED_LEASH,
			"why": "%.2f m from the Huntress, beyond the %.1f m leash" % [d, HoundConfig.LEASH_RANGE_M]}
	return {"valid": true, "code": RETAINED, "why": "%.2f m from the Huntress" % d}

## THE FULL RETENTION TEST: eligibility, the leash, and a reachable path.
## NOT the acquisition range -- a retained target may be anywhere inside the leash.
static func retain_check(record: Dictionary, handler_pos: Vector3, reach: Callable) -> Dictionary:
	var q := still_eligible_and_leashed(record, handler_pos)
	if not bool(q["valid"]):
		return q
	if not bool(reach.call(record)):
		return {"valid": false, "code": ABANDONED_UNREACHABLE, "why": "no navigation path ends within bite distance"}
	return q

## THE CHOICE among candidates: inside the Huntress-centred acquisition range,
## eligible, reachable; the nearest to the hound; an exact tie to the lower ID.
## Returns {"record", "distance", "tie_ids", "considered", "refusals"}.
static func choose(records: Array, hound_pos: Vector3, handler_pos: Vector3,
		registry: CombatEntityRegistry, reach: Callable) -> Dictionary:
	var best: Dictionary = {}
	var best_d := INF
	var tie_ids: Array[String] = []
	var considered := 0
	var refusals: Array[String] = []
	for rec in records:
		var r: Dictionary = rec
		var id := String(r.get("id", ""))
		var e := HitEligibility.evaluate(r)
		if not bool(e["eligible"]):
			refusals.append("%s: %s" % [id, String(e["reason"])])
			continue
		var hd := planar(handler_pos, position_of(r))
		if hd > HoundConfig.ACQUISITION_RANGE_M:
			refusals.append("%s: %.2f m from the Huntress, outside the %.1f m acquisition range"
				% [id, hd, HoundConfig.ACQUISITION_RANGE_M])
			continue
		if not bool(reach.call(r)):
			refusals.append("%s: unreachable" % id)
			continue
		considered += 1
		var d := planar(hound_pos, position_of(r))
		if best.is_empty() or d < best_d:
			best = r
			best_d = d
			tie_ids = [id]
		elif d == best_d:
			# EXACT: no tolerance is set. The lower combat-entity ID wins, through
			# the registry's one ordering -- never the display string.
			tie_ids.append(id)
			if registry.precedes(id, String(best.get("id", ""))):
				best = r
	return {"record": best, "distance": best_d, "tie_ids": tie_ids, "considered": considered,
		"refusals": refusals}

## THE WHOLE DECISION for one hound: retain, else choose, else none. Returns
## {"record", "code", "text", "distance", "tie_ids", "abandoned", "abandon_code",
## "abandon_id"}.
static func decide(current: Dictionary, records: Array, hound_pos: Vector3, handler_pos: Vector3,
		registry: CombatEntityRegistry, reach: Callable) -> Dictionary:
	var abandoned := ""
	var abandon_code := ""
	var abandon_id := ""
	if not current.is_empty():
		var v := retain_check(current, handler_pos, reach)
		if bool(v["valid"]):
			return {"record": current, "code": RETAINED, "abandoned": "", "abandon_code": "", "abandon_id": "",
				"text": "%s %s — still eligible, reachable, inside the leash (%s)"
					% [RETAINED, String(current.get("id", "")), String(v["why"])],
				"distance": planar(hound_pos, position_of(current)), "tie_ids": []}
		abandon_code = String(v["code"])
		abandon_id = String(current.get("id", ""))
		abandoned = "%s %s (%s)" % [abandon_code, abandon_id, String(v["why"])]
	var c := choose(records, hound_pos, handler_pos, registry, reach)
	var rec: Dictionary = c["record"]
	if rec.is_empty():
		return {"record": {}, "code": NONE, "abandoned": abandoned, "abandon_code": abandon_code, "abandon_id": abandon_id,
			"text": ("%s; " % abandoned if abandoned != "" else "")
				+ "NO TARGET — none eligible and reachable inside %.1f m of the Huntress; FOLLOWING" % HoundConfig.ACQUISITION_RANGE_M,
			"distance": INF, "tie_ids": []}
	var tie: Array = c["tie_ids"]
	var code := ACQUIRED_TIE if tie.size() > 1 else ACQUIRED
	var text := "%s %s — nearest to this hound (%.2f m) inside %.1f m of the Huntress" \
		% [code, String(rec.get("id", "")), float(c["distance"]), HoundConfig.ACQUISITION_RANGE_M]
	if tie.size() > 1:
		text += "; exact tie %s -> the lower combat-entity ID" % str(tie)
	if abandoned != "":
		text = "%s; %s" % [abandoned, text]
	return {"record": rec, "code": code, "abandoned": abandoned, "abandon_code": abandon_code, "abandon_id": abandon_id, "text": text,
		"distance": float(c["distance"]), "tie_ids": tie}
