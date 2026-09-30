class_name HitEligibility
extends RefCounted

## WHO AN ARROW MAY HIT — enemy eligibility, a GENERAL combat rule (D-392, D-393).
##
## ============================================================================
## "An eligible enemy is an alive, hostile, targetable combat entity that can
## legally receive the Skill's Hit. This includes ordinary enemies, elites,
## bosses and hostile summons such as the Warden's skeletons. It excludes allies,
## dead or dying actors, scenery, destructibles and enemies currently
## untargetable or invulnerable." (D-391 ruling 4; since D-393 a general combat
## rule, `CHARACTER_CLASS_PHILOSOPHY.md` section 0.5.16.)
## ============================================================================
##
## FOUR CONJUNCTS AND NOTHING ELSE. A hostile's CATEGORY plays NO part: an
## ordinary enemy, an elite, a boss and a hostile summon are judged by exactly the
## same four questions, and the D-392 suite plants a category exclusion to prove
## a check would catch one.
##
## THE EXCLUSIONS NAME CONDITIONS, THEY CREATE NO STATE. Nothing in game3d/ ever
## makes an ordinary enemy untargetable or invulnerable; the predicate asks the
## entity through two OPTIONAL queries (`combat_is_targetable`,
## `combat_is_invulnerable`) that no gameplay class implements -- only the
## suite's test-only stubs do. Scenery and destructibles never reach here: the
## registry refuses to register either.
##
## AN UNMODIFIED ARROW'S "FIRST ELIGIBLE TARGET" (D-390 ruling 4) IS AN ENEMY
## THIS PREDICATE ACCEPTS. Anything else in its path is passed through; world
## geometry stops it without a Hit (SplinterArrow).

## Returns {"eligible": bool, "reason": String}. The reason names the FIRST
## conjunct that failed, in a fixed order, so a refusal is always explained.
static func evaluate(record: Dictionary) -> Dictionary:
	if record.is_empty():
		return _no("not a registered combat entity")
	var node = record.get("node", null)
	if node == null or not is_instance_valid(node) or not (node as Node).is_inside_tree():
		return _no("no longer present in the area")
	# 1. ALIVE — dead AND dying are excluded. `is_dead()` is the accepted
	#    enemy's own answer, and it is true from the first frame of DYING.
	if node.has_method("is_dead") and bool(node.call("is_dead")):
		return _no("not alive (dead or dying)")
	# 2. HOSTILE.
	if String(record.get("faction", "")) != "hostile":
		return _no("not hostile (%s)" % String(record.get("category", "?")))
	# 3. TARGETABLE — a condition, asked, never stored here.
	if node.has_method("combat_is_targetable") and not bool(node.call("combat_is_targetable")):
		return _no("currently untargetable")
	# 4. ABLE TO LEGALLY RECEIVE THE HIT — invulnerable, or no Hit receiver.
	if node.has_method("combat_is_invulnerable") and bool(node.call("combat_is_invulnerable")):
		return _no("currently invulnerable — cannot legally receive the Hit")
	if not node.has_method("receive_damage"):
		return _no("cannot legally receive the Hit (no Hit receiver)")
	return {"eligible": true, "reason": "alive, hostile, targetable and able to receive the Hit"}

static func _no(reason: String) -> Dictionary:
	return {"eligible": false, "reason": reason}
