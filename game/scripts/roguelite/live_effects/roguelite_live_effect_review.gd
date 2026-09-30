class_name RogueliteLiveEffectReview
extends RogueliteLevelUpChoiceReview
## Riftwrought — Roguelite I3: Live Level-Up Effect Application Review V1
## (decision D-295).
##
## THE ONE QUESTION THIS SCENE ASKS: does the first level-up choice FEEL like it did
## something?
##
##     collect real Experience Motes -> exactly the Level 1 requirement -> the
##         accepted three-card panel opens and holds the world still -> one card is
##         chosen -> the run's whole temporary build is applied to the character
##         -> play resumes with the chosen effect LIVE -> the receipt says what is
##         live -> the expedition ends and every value returns to its baseline
##
## A choice that leaves the run the next level's experience does not resume play: that
## level's own offer takes the cards' place with the whole build already live, and play
## resumes — and the receipt shows — only after the choice that closes the panel
## (Roguelite I11, D-314; Roguelite I12, D-316).
##
##
## IT IS THE ACCEPTED LEVEL-UP CHOICE REVIEW (I2), WHOLE, WITH ONE LAYER ON TOP
## ---------------------------------------------------------------------------
## The scene INHERITS I2's accepted scene and this script EXTENDS I2's runtime. The
## route, the motes, the offer, the panel, the choice transaction and the receipt
## are I2's and H9's, unedited and uncopied. Five inherited methods are overridden,
## and four call the method they override:
##   * `_build_run_surfaces()` states this review's panel note, adds one live line to
##     the receipt and states the receipt's own note;
##   * `choose_offered_lane()` lets I2's accepted transaction run whole, then — only
##     if it succeeded — applies the expedition's whole temporary build;
##   * `_discard_mote_runtime()` lets H9 and I2 end the expedition, then restores
##     every baseline;
##   * `_refresh_receipt()` shows the live line beside I2's receipt, and hides it
##     whenever an offer stands;
## and the fifth, `_maybe_start_verification()`, answers this review's own flag, so
## neither accepted suite can start here.
##
##
## THE BUILD IS THE AUTHORITY, AND IT IS READ WHOLE
## ---------------------------------------------------------------------------
## After a successful choice the Experience Mote runtime is asked for the run's
## temporary build — the run's own independent copy — and that complete snapshot is
## handed to the one application seam with the player and the accepted loop's own
## movement baseline. The seam derives every covered value from the whole build and
## from the accepted baselines, and writes them only if every one is coherent. The
## receipt and the card are never read to decide an effect: the live line is the
## seam's own account of what it made live.
##
## "LIVE NOW" HEADS ONLY WHAT WAS WRITTEN TO THE CHARACTER (D-297). A stat the build
## holds but the seam did not make live — deferred by this review, or applied by the
## run's own mote path — is listed after the live values under its own separate
## heading, each line saying which, so a held stat can never read as live.
##
## IT HAPPENS BEFORE ANOTHER FRAME. Inside the same call that took the lane, I2's
## transaction either closes the panel and lifts the pause or — when the experience the
## run kept already meets the next level's requirement — shows that level's own offer in
## the panel's place and keeps the world held (Roguelite I11, D-314). The application
## follows in that same call either way, so no physics or process frame can run between
## a successful choice and its live values: behind a chained offer they are already live
## on the held character. The frame on which it happened is recorded.
##
##
## EVERY EXPEDITION'S EFFECTS END WITH IT
## ---------------------------------------------------------------------------
## Death (at the Fallen overlay's return to the Nexus), F5, completion and the start
## of the next expedition all pass through `_discard_mote_runtime()`. Each one then
## applies an EMPTY build through the same seam, which restores every covered value
## from the canonical Skill record the player's action keeps and from the accepted
## movement baseline — without remembering which card was chosen, because an empty
## build needs nothing to be remembered. Nothing reaches the Nexus or the next run.
##
## WHAT IT DOES NOT DO. No level-up of its own: every later level and every chained
## offer is I2's (Roguelite I11, D-314), and each successful choice among them is applied
## here exactly as the first is. No Area behaviour or extra target; no value of its own
## for any rank — every rank's value, rank two's included since Roguelite I4 (D-298), is
## the seam's reading of the catalogue; no stat made live by the review itself — the damage
## stat the build holds (Roguelite I13, D-318) and its Life stat (Roguelite I14, D-320) are
## made live by the seam like every covered value, and the seam's own account says so; no
## card, HUD or effect art; no saving; nothing written anywhere; no InputMap action. It names no
## Skill, support, card, stat or value of its own: every one of those belongs to the
## seam and the accepted catalogues.
##
## Run it with Run Current Scene — never Run Project — or:
##   godot --path game res://scenes/roguelite/roguelite_live_effect_review.tscn -- --seed 99

const LIVE_EFFECT_VERIFICATION_SCRIPT: String = "res://tests/roguelite_live_effect_review_verification.gd"

## The note beneath the three cards in this scene, replacing I2's greybox note,
## which would be false here.
const PANEL_NOTE: String = "Covered effects are applied immediately for this expedition. Final values and presentation are not locked."

## The receipt's own note in this scene, replacing I2's, which would be false here.
const RECEIPT_LIVE_NOTE: String = "Applied to the character now; every value returns to its baseline when this expedition ends."

## The receipt's live line: a heading for the values written to the character, a
## separate heading for the held stats that were not, and the line for neither.
const LIVE_PREFIX: String = "Live now — "
const HELD_HEADING: String = "Held, not live on the character:"
const NOTHING_CHANGED: String = "No covered value changed"

## Review instrumentation, read by the receipt and the verification.
var applications_made: int = 0
var application_refusals: int = 0
var restorations_made: int = 0
## The seam's last answer for a choice, and for a restoration. Values: holding them
## moves nothing.
var last_application: RiftBuildApplicationResult = null
var last_restoration: RiftBuildApplicationResult = null
## The engine's frame counters at the moment of the last application.
var last_application_physics_frame: int = -1
var last_application_process_frame: int = -1

var _live_line: String = ""
var _receipt_live: Label


# --- Assembly: I2's surfaces, then this review's note and line ---------------------

func _build_run_surfaces() -> void:
	super()
	level_up_panel.set_note_text(PANEL_NOTE)
	_receipt_live = _receipt_line("", 12, RogueliteExperienceReviewHud.TEXT)
	var box: Node = _receipt_note.get_parent()
	box.add_child(_receipt_live)
	## Beneath I2's level line and above the note, inside H9's review panel.
	box.move_child(_receipt_live, _receipt_note.get_index())
	_receipt_note.text = RECEIPT_LIVE_NOTE
	_refresh_receipt()
	log_event("live effects", "live level-up effect layer assembled on the accepted choice review")


# --- The choice, then its effects ----------------------------------------------------

## I2's accepted transaction runs whole: the lane goes to the run, a refusal keeps the
## same offer open, and a success becomes I2's receipt and either closes the panel or,
## with the next level owed, leaves that level's offer standing in its place (D-314).
## Only when it succeeded is the whole temporary build applied — in this same call.
func choose_offered_lane(lane: int) -> void:
	var taken_before: int = choices_taken
	super(lane)
	if choices_taken == taken_before:
		return
	_apply_expedition_build()


## Reads the run's whole temporary build and hands that snapshot to the seam.
func _apply_expedition_build() -> void:
	var build: RiftRunBuild = mote_runtime.run_build()
	var result: RiftBuildApplicationResult = RiftBuildApplication.apply(build, player, ACCEPTED_MAX_SPEED)
	last_application = result
	last_application_physics_frame = Engine.get_physics_frames()
	last_application_process_frame = Engine.get_process_frames()
	if result.ok:
		applications_made += 1
		_live_line = live_receipt_for(result)
		log_event("live effects", "applied: %s" % result.describe())
	else:
		application_refusals += 1
		_live_line = live_receipt_for(result)
		_note_refusal("live effects not applied", result.failure_reason)
		log_event("live effects", "refused: %s" % result.failure_reason)
	_refresh_receipt()
	_refresh_run_hud()


# --- Every expedition's end ------------------------------------------------------------

## H9 lets the expedition's Experience Mote state go and I2 its offer state; then every
## covered value returns to its baseline through the same seam.
func _discard_mote_runtime(reason: String) -> void:
	super(reason)
	_restore_baselines(reason)


## An EMPTY build through the one seam: every covered value derived from the canonical
## Skill record and the accepted movement baseline, and nothing remembered.
func _restore_baselines(reason: String) -> void:
	var result: RiftBuildApplicationResult = RiftBuildApplication.apply(RiftRunBuild.new(), player, ACCEPTED_MAX_SPEED)
	last_restoration = result
	last_application = null
	_live_line = ""
	if result.ok:
		restorations_made += 1
		log_event("live effects", "every baseline restored (%s): %s" % [reason, result.describe()])
	else:
		push_error("RogueliteLiveEffectReview: baselines were not restored: %s" % result.failure_reason)
		_note_refusal("baselines not restored", result.failure_reason)
	_refresh_receipt()


# --- The receipt ------------------------------------------------------------------------

## The live line beside I2's receipt, under the rule I2 keeps for the receipt it sits in:
## WHILE AN OFFER STANDS IT IS HIDDEN (D-315 ruling 2; Roguelite I12, D-316). A choice that
## leaves the next level owed has already made its values live on the held character when
## that level's offer takes the cards' place; the line saying so waits, hidden, and is
## shown only once the panel has closed — by then written by the closing choice's own
## application, and describing the whole build.
func _refresh_receipt() -> void:
	super()
	if _receipt_live == null:
		return
	var standing: bool = level_up_panel != null and level_up_panel.is_open
	_receipt_live.visible = not standing and not receipt_text("choice").is_empty() and not _live_line.is_empty()
	_receipt_live.text = _live_line


## The receipt's live line for one application — a pure reading of the seam's result.
## "Live now" heads only the values the seam wrote to the character; every stat the
## build holds that the seam did not make live follows under its own heading, each
## line saying why. A refusal says it was not applied (D-297).
static func live_receipt_for(result: RiftBuildApplicationResult) -> String:
	if result == null:
		return ""
	if not result.ok:
		return "Not applied — %s" % result.failure_reason
	var sections: PackedStringArray = PackedStringArray()
	var applied: PackedStringArray = result.applied_lines()
	if not applied.is_empty():
		sections.append(LIVE_PREFIX + "\n".join(applied))
	var held: PackedStringArray = result.held_lines()
	if not held.is_empty():
		sections.append(HELD_HEADING + "\n" + "\n".join(held))
	return "\n".join(sections) if not sections.is_empty() else NOTHING_CHANGED


# --- Readings for the verification and the evidence frames ---------------------------------

func live_receipt_text() -> String:
	return _live_line


func live_receipt_control() -> Label:
	return _receipt_live


# --- This review's own verification ---------------------------------------------------------

## Replaces I2's flag, so I2's accepted suite can never start in this scene and this
## review's suite has its own.
func _maybe_start_verification() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if not arguments.has("--verify-live-effects"):
		return
	var script: GDScript = load(LIVE_EFFECT_VERIFICATION_SCRIPT) as GDScript
	var runner: Node = Node.new()
	runner.name = "RogueliteLiveEffectReviewVerification"
	runner.set_script(script)
	runner.set("review", self)
	runner.set("arguments", arguments)
	add_child(runner)
