extends SceneTree

## RIFTWROUGHT — D-378 ALIGNMENT STAGE VERIFICATION  (D-380, 2026-09-18)
##
## ============================================================================
## THIS IS A THIRD SUITE. THE TWO ACCEPTED ONES ARE RE-RUN AS REGRESSIONS.
## ============================================================================
## `tests/foundation_verification.gd` (the ACCEPTED D-373 baseline) is NOT
## EDITED AT ALL. `tests/imprint_verification.gd` (ACCEPTED under D-376) keeps
## its 101 executable checks -- 101 - 0 + 0 = 101 -- with the checks whose rule
## D-376 or D-378 replaced re-scoped one for one, and its eight MO- rows moved to
## a printed DISCHARGED block (24 -> 16 deferred). Both run first, as
## regressions, in `tests/alignment_smoke.sh`.
##
## ============================================================================
## UNITS. NINE COUNTS EXIST IN THIS PROJECT AND NONE IS A SYNONYM FOR ANOTHER.
## ============================================================================
##   D-380 OWED CRITERIA     162  docs/testing/D380_ALIGNMENT_OWED_CRITERIA_INVENTORY.md
##   D-380 EXECUTABLE CHECKS  40  this suite
##   D-380 RUNNER CHECKS      21  tests/alignment_smoke.sh
##   D-375 OWED CRITERIA     149 · D-375 EXECUTABLE CHECKS 101 · D-375 RUNNER CHECKS 26
##   D-370 OWED CRITERIA     125 · D-370 EXECUTABLE CHECKS  85 · D-370 RUNNER CHECKS 20
##
## 162 is not 40. 40 is not 21. Anyone restating any of them must carry its unit
## and its decision with it.
##
## D-382 (the owner's clarification of D-381 and ruling on AD-11) moved them again:
##   criteria 146 + 16 = 162 · checks 35 + 5 = 40 (A36-A40) · rows 16 - 1 = 15
##   printed as DEFERRED / OWED-TO-OWNER, with AD-11 moved -- text preserved --
##   to a printed DISCHARGED block. Re-scoped one for one: F57 (foundation), A03,
##   A28, A29, A30, A32, A35, and in the runner T09, T13, T17 and T21.
##
## THE D-381 REVIEWABILITY CORRECTION MOVED THREE OF THEM, AND NOTHING ELSE:
##   criteria 121 + 25 = 146 · checks 28 + 7 = 35 (A29-A35) · rows 14 + 2 = 16
##   (AD-11, AM-05). The runner stays 21: T09, T13, T17, T19 and T21 were
##   re-scoped in place, one for one. Four D-380 checks were re-scoped (A03, A24,
##   A26, A28), each with its arithmetic stated in its own body. At D-380's
##   delivery these read 121 · 28 · 21 and 14 rows -- true when written.
##
## ============================================================================
## IT VERIFIES A STAGE DELIVERED OPEN. IT IS A SEMANTIC ALIGNMENT, NOT TUNING.
## ============================================================================
## The owner: "This is a semantic alignment stage, not Huntress implementation,
## not progression tuning, and not authorization for P2 or another Machinations
## model." It locks no number and adopts no D-378 test candidate.
##
## The standing verification rules are applied verbatim: a named owed list
## compared in BOTH directions · every check records reaching its LAST line · a
## missing check function is a FAIL and never a skip · every negative control is
## PROVED ABLE TO REFUSE · an assertion that something did not happen asserts the
## action FIRED FIRST · an unperformed check is DEFERRED and names where it
## returns.

const OWED := [
	# --- A. THE FIRST ACT: the accepted-stage reconciliation (D-376 section 7) ---
	"A01_state_names_all_three_stages_truthfully",
	"A02_the_eight_mo_rows_are_discharged_with_history_preserved",
	"A03_the_four_truthfulness_pins_moved_together_and_none_was_weakened",
	# --- B. OD-01: a newly learned Imprint starts at rank 1 / 0 XP ------------
	"A04_a_newly_learned_imprint_starts_at_rank_1_with_0_xp",
	"A05_no_acquisition_rank_floor_is_representable_and_seeding_is_declared",
	"A06_accelerated_catch_up_remains_bounded_for_a_new_imprint",
	# --- C. OD-05: regeneration from unreserved maximum Mana ------------------
	"A07_regeneration_is_computed_from_unreserved_maximum_mana",
	"A08_the_live_loadout_regenerates_from_its_own_unreserved_pool",
	# --- D. OD-06: percentage reservation, proportional conversion ------------
	"A09_persistent_reservation_is_percentage_only",
	"A10_mana_to_life_conversion_is_proportional",
	"A11_the_flat_life_tithe_is_gone_and_exactly_one_resource_is_reserved",
	# --- E. OD-09: up to eight, one per binding -------------------------------
	"A12_up_to_eight_active_configurations_one_per_binding",
	"A13_empty_bindings_stay_valid_and_bindings_stay_distinct",
	"A14_global_capacity_limits_how_deeply_the_loadout_is_modified",
	# --- F. OD-07.2 / D-376 X-02: no arbitrary Persistent slot cap ------------
	"A15_persistent_configurations_have_no_arbitrary_slot_cap",
	# --- G. OD-12: purely beneficial Augments ---------------------------------
	"A16_purely_beneficial_augments_are_legal_and_silent_ones_are_not",
	# --- H. ALREADY SATISFIED, CANDIDATES, AND WHAT MUST NOT MOVE -------------
	"A17_no_universal_transform_capacity_surcharge",
	"A18_low_and_middle_ranks_keep_their_measured_rational_uses",
	"A19_no_d378_test_candidate_is_promoted",
	"A20_no_pacing_or_tuning_value_moved",
	# --- I. REGISTRIES, THE MAP, AND THE PANEL --------------------------------
	"A21_every_value_this_stage_introduces_is_registered_provisional",
	"A22_the_d378_map_is_exhaustive_and_uses_only_four_dispositions",
	"A23_the_panel_states_every_aligned_rule_to_a_viewer",
	"A24_the_panel_keeps_its_controls_and_remains_a_developer_surface",
	# --- J. PRESERVATION AND SCOPE --------------------------------------------
	"A25_the_accepted_architecture_holds_on_the_aligned_rules",
	"A26_no_new_content_imprint_configuration_script_asset_or_input_action",
	"A27_the_denials_are_present_and_the_guard_can_fail",
	"A28_the_units_are_named_at_this_surface",
	# --- K. THE D-381 REVIEWABILITY CORRECTION (inside the D-380 stage) -------
	"A29_the_developer_panel_is_hidden_by_default_and_keeps_its_toggle",
	"A30_the_review_hud_is_visible_compact_and_clear_of_the_centre_and_the_overlay",
	"A31_the_hud_reads_the_live_gameplay_objects_and_hard_codes_no_value",
	"A32_reserved_segments_are_patterned_and_bounded_in_every_reservation_state",
	"A33_one_diagnostic_input_cycles_off_mana_life_off_through_the_real_input_path",
	"A34_learning_truth_and_the_configuration_count_are_live_and_do_not_overclaim",
	"A35_the_correction_adds_no_content_or_tuning_and_preserves_d380_behaviour",
	# --- L. D-382: a Life reservation governs live Health (the ruling on AD-11) --
	"A36_entering_life_conversion_clamps_live_health_in_the_same_transition",
	"A37_removing_or_reducing_the_reservation_does_not_heal",
	"A38_damage_and_every_raise_of_live_health_respect_usable_health",
	"A39_mana_reservation_never_changes_current_health",
	"A40_the_hud_and_gameplay_read_the_same_live_state_after_the_ruling",
]

## ============================================================================
## ROWS THIS STAGE DOES NOT PASS AND DOES NOT PRETEND TO.
## ============================================================================
## Printed and counted every run as DEFERRED or OWED-TO-OWNER, NEVER as passes.
const DEFERRED_ROWS := [
	["AD-01 OD-11 limited unequipped progression (~25 %, stopping below on-curve mastery)", "DEFERRED",
	 "A D-378 TEST CANDIDATE, NOT IMPLEMENTED: an unequipped Imprint still receives EXACTLY 0 "
	 + "(A19). Adopting it would turn a candidate into a production value. RETURNS TO: a "
	 + "separately authorized progression-tuning stage and the next model iteration."],
	["AD-02 OD-07.1 minimum Persistent Capacity cost 1 and/or a ~3 % reservation floor", "DEFERRED",
	 "A D-378 TEST CANDIDATE, NOT IMPLEMENTED. The D-375 Persistent base cost already happens to "
	 + "be 1; that is recorded as a coincidence and is NOT a promotion. RETURNS TO: the same stage."],
	["AD-03 OD-10.2 rank-scaled Capacity at meaningful rank milestones", "DEFERRED",
	 "A D-378 TEST CANDIDATE, NOT IMPLEMENTED: Capacity reads no Effective Rank (A17). RETURNS TO: "
	 + "the same stage."],
	["AD-04 OD-06.3 a ~2x Mana->Life conversion ratio", "DEFERRED",
	 "A D-378 TEST CANDIDATE, NOT ADOPTED: the runtime ratio is the prototype-derived 1.444 "
	 + "(PROVISIONAL). Changing it is one constant, and is the owner's call. RETURNS TO: the same stage."],
	["AD-05 OD-08.2 ~24 middle / 30-36 level-100 Capacity bands on a 100-level axis", "DEFERRED",
	 "D-378 TEST BANDS, NOT ADOPTED: the provisional 30 + 5 is unchanged (A20), and no character "
	 + "level system exists here. RETURNS TO: the same stage."],
	["AD-06 OD-04.2 stepped Capacity costs, thresholds or cadence interactions for low ranks", "DEFERRED",
	 "D-378 CANDIDATE MECHANISMS, NOT IMPLEMENTED. The low-rank uses that ALREADY exist are "
	 + "measured (A18). RETURNS TO: the same stage."],
	["AD-07 OD-05.2 Mana on kill, leech, recoup, flat regeneration; a separate boss sustain test", "DEFERRED",
	 "None of these channels exists here. The ruling says they must be included BEFORE FINAL "
	 + "TUNING, which this stage is forbidden. RETURNS TO: a separately authorized stage."],
	["AD-08 OD-02 / OD-03 rank pacing and the rank-power share", "DEFERRED",
	 "Tuning DIRECTIONS. The rank cap (20), the linear curve and the catch-up values are "
	 + "UNCHANGED and PROVISIONAL (A20). RETURNS TO: a separately authorized tuning pass."],
	["AD-09 OD-14 Mana Guard and bonus Skill Ranks", "DEFERRED",
	 "Neither mechanic exists here, and none is added (A26). RETURNS TO: their own mechanics "
	 + "stage, then modelling before any number is tuned."],
	["AD-10 a LIVE seven- or eight-Configuration loadout", "DEFERRED",
	 "The diagnostic content holds FIVE Active Configurations, and composing more would be "
	 + "content this stage may not add. The rule is PROVED on scratch loadouts (A12, A14) and SHOWN "
	 + "on the panel's D-378 ALIGNMENT page. RETURNS TO: the owner's decision, or a content stage."],
]

## ============================================================================
## ROWS ANSWERED BY A LATER RULING — printed every run under DISCHARGED, their
## ORIGINAL TEXT PRESERVED VERBATIM, so the history cannot be lost by answering it.
## ============================================================================
## RECONCILED UNDER D-392, AS ITS FIRST ACT, EXACTLY AS D-383 SECTION 6
## RECOMMENDED. `AM-01` ... `AM-05` printed as OWED-TO-OWNER on every run from
## D-380 / D-381 until D-392 -- TRUE WHEN WRITTEN. D-383's live review answered
## or closed all five, but the owner forbade changing the artifact to earn that
## acceptance, so the suite went on printing them as owed: accepted historical
## state, declared by D-383 section 6. The D-392 ruling authorizes the repair:
## "update the runtime state and discharged owner-review rows, and re-pin all
## corresponding truthfulness guards together." SO THEY MOVED, each with its
## ORIGINAL TEXT PRESERVED VERBATIM and D-383's answer AT THE LEVEL THE OWNER
## GAVE IT -- AM-03 and AM-04 were closed by acceptance of the rule and NO felt
## judgment is inferred. The pinned rows moved 15 -> 10 in the same change as
## the runner's PIN_A_DEFERRED and T09. 15 - 5 = 10; 1 + 5 = 6; ZERO DELETED.
const DISCHARGED_ROWS := [
	["AD-11 live Health is NOT reduced by a Life reservation (the D-375 ceiling model)", "DISCHARGED — D-382",
	 "ORIGINAL ROW TEXT, PRESERVED VERBATIM: \"DEFERRED\" — FOUND BY THE D-381 HUD, DISCLOSED AND NOT FIXED: "
	 + "since D-375 a Life reservation lowers the ResourcePool's usable Life CEILING, but the player's live "
	 + "Health ledger (Damageable, accepted foundation behaviour) never reads it -- so with LIFE CONVERSION "
	 + "on, live Health can sit ABOVE usable Health. The HUD draws that truthfully and prints a warning "
	 + "(A32). Enforcing the cap would change gameplay, which the correction is forbidden. RETURNS TO: a "
	 + "separately authorized stage. || THE OWNER'S D-382 RULING ANSWERED IT: \"Life reservation must affect "
	 + "live Health correctly\" — current Health = min(current Health, usable Health) in the same transition; "
	 + "removing or reducing a reservation is not healing; healing stays capped. IMPLEMENTED in "
	 + "Damageable.set_ceiling and ResourcePool.set_reservation, and PROVED by A36-A40."],
	["AM-01 does regeneration from UNRESERVED maximum Mana create the intended reservation pressure, or merely starve a build?",
	 "DISCHARGED — D-383",
	 "THE OWNER'S D-383 LIVE REVIEW: ANSWERED DIRECTLY — \"the Mana pressure feels appropriate for this prototype\". || ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + "MEASURED: with the aura reserving Mana the build regenerates 16.85 Mana/s; converted to Life, " + "22.00 Mana/s (A08). Whether that pressure FEELS intended is the owner's. RETURNS TO: owner " + "live review." + "'"],
	["AM-02 does the PROPORTIONAL Mana->Life conversion read as a fair, understandable trade?",
	 "DISCHARGED — D-383",
	 "THE OWNER'S D-383 LIVE REVIEW: ANSWERED DIRECTLY, in the owner's terms (conceptual sense; 'fair' was not separately judged) — \"exchanging Mana reservation for Life reservation makes conceptual sense\". || ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + "MEASURED: Life reserved = the Mana fraction the aura would reserve x a PROVISIONAL ratio " + "(A10). Whether the trade reads well is the owner's. RETURNS TO: owner live review." + "'"],
	["AM-03 does 'up to eight, one per binding, Capacity limits depth' read correctly with five Configurations to equip live?",
	 "DISCHARGED — D-383",
	 "THE OWNER'S D-383 LIVE REVIEW: CLOSED BY ACCEPTANCE OF THE RULE ITSELF — NO separate felt judgment was given, and NONE is inferred — the owner accepted \"up to eight equipped Active Configurations, one per binding\". || ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + "MEASURED on scratch loadouts: eight lightly modified Configurations all fit; eight heavily " + "modified ones meet the Capacity budget (A12, A14). RETURNS TO: owner live review." + "'"],
	["AM-04 does 'learned at rank 1 / 0 XP, then DIAGNOSTIC SEEDING' read truthfully as a stand-in for an established character?",
	 "DISCHARGED — D-383",
	 "THE OWNER'S D-383 LIVE REVIEW: CLOSED BY ACCEPTANCE OF THE RULE and of the HUD that states it — NO separate felt judgment is inferred — the owner accepted \"newly learned Imprints beginning at Mastered Rank 1 with 0 XP\". || ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + "MEASURED: every Imprint's acquisition record says rank 1 / 0 XP, and the seeded ranks are " + "counted and printed (A04, A05). RETURNS TO: owner live review." + "'"],
	["AM-05 does the compact review HUD make the D-378 resource behaviour reviewable WHILE PLAYING?",
	 "DISCHARGED — D-383",
	 "THE OWNER'S D-383 LIVE REVIEW: ANSWERED DIRECTLY — \"The compact HUD makes the system comfortably reviewable while playing\". || ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): '" + "MEASURED: the panel is hidden at launch (A29); the HUD sits clear of the centre and the overlay " + "(A30), reads only live gameplay objects (A31), draws reserved zones as hatched, bounded " + "segments (A32), and one input cycles the three states (A33). Whether that is reviewable in " + "play is the owner's. RETURNS TO: owner live review." + "'"]
]

## The ONE deliberately planted bad value, so a guard can be proved able to fail.
const PLANTED_CLAIM := "Alignment_Stage_Locks_The_Rank_Cap_THIS_IS_FORBIDDEN"

## The D-375 Imprint Library, exactly as accepted -- 14 ids, 4 + 7 + 3.
const D375_IMPRINT_IDS := [
	"AUGMENT_IMPRINT_DIAG_EXTENDED_WARD", "AUGMENT_IMPRINT_DIAG_FORKING",
	"AUGMENT_IMPRINT_DIAG_LIFE_TITHE", "AUGMENT_IMPRINT_DIAG_PACK_INSTINCT",
	"AUGMENT_IMPRINT_DIAG_SPLIT_VOLLEY", "AUGMENT_IMPRINT_DIAG_SUREFOOT_RELEASE",
	"AUGMENT_IMPRINT_DIAG_TEMPERED_DRAW", "SKILL_IMPRINT_DIAG_BEAST_PACK",
	"SKILL_IMPRINT_DIAG_PACK_WARD", "SKILL_IMPRINT_DIAG_STORM_SHOT",
	"SKILL_IMPRINT_DIAG_WARD_BALLISTA", "TRANSFORM_IMPRINT_DIAG_SIEGE_ANCHOR",
	"TRANSFORM_IMPRINT_DIAG_SPLINTER_RAIN", "TRANSFORM_IMPRINT_DIAG_TEMPEST_ORBIT",
]

## The runtime scripts as they stood before D-380. THIS STAGE ADDS NONE.
const RUNTIME_SCRIPTS_BEFORE := [
	"res://scripts/assets/asset_manifest.gd", "res://scripts/assets/rig_corpus.gd",
	"res://scripts/combat/damageable.gd", "res://scripts/combat/diagnostic_bolt.gd",
	"res://scripts/combat/ordinary_enemy.gd", "res://scripts/combat/telegraph.gd",
	"res://scripts/control/action_commitment.gd", "res://scripts/control/input_intent.gd",
	"res://scripts/control/locomotion_motor.gd", "res://scripts/control/player_controller.gd",
	"res://scripts/control/yaw_driver.gd", "res://scripts/core/prod_config.gd",
	"res://scripts/debug/debug_overlay.gd", "res://scripts/foundation_main.gd",
	"res://scripts/imprint/diag_ballista.gd", "res://scripts/imprint/diag_beast.gd",
	"res://scripts/imprint/diag_imprint_content.gd", "res://scripts/imprint/diag_projectile.gd",
	"res://scripts/imprint/imprint.gd", "res://scripts/imprint/imprint_config.gd",
	"res://scripts/imprint/imprint_library.gd", "res://scripts/imprint/imprint_loadout.gd",
	"res://scripts/imprint/loadout_panel.gd", "res://scripts/imprint/resource_pool.gd",
	"res://scripts/imprint/skill_configuration.gd", "res://scripts/imprint/skill_runtime.gd",
	"res://scripts/view/ground_shadow.gd", "res://scripts/view/iso_camera_rig.gd",
	"res://scripts/world/nav_service.gd", "res://scripts/world/production_arena.gd",
]

## ============================================================================
## ADDED UNDER D-392 FOR A26's ONE-FOR-ONE RE-SCOPE: the runtime scripts the
## HUNTRESS SPLINTER SHOT STAGE adds (15, all under scripts/huntress/), and the
## EXACT Huntress-named declarations it needs OUTSIDE that directory -- the
## composition hooks. Anything else still fails A26.
## RE-SCOPED UNDER D-393, one for one: the list read 17 until the owner removed
## Prey -- huntress_prey.gd and prey_marker.gd left, and prey_eligibility.gd was
## replaced by hit_eligibility.gd, the same predicate as a general rule
## (17 - 3 + 1 = 15). True when written.
## ============================================================================
const D392_RUNTIME_SCRIPTS := [
	"res://scripts/huntress/arrow_collision.gd", "res://scripts/huntress/bone_pose.gd",
	"res://scripts/huntress/bow_presentation.gd", "res://scripts/huntress/bow_retargeter.gd",
	"res://scripts/huntress/combat_entity_registry.gd", "res://scripts/huntress/huntress_bow_animator.gd",
	"res://scripts/huntress/hit_eligibility.gd",
	"res://scripts/huntress/huntress_config.gd", "res://scripts/huntress/huntress_content.gd",
	"res://scripts/huntress/huntress_pose_modifier.gd",
	"res://scripts/huntress/huntress_review_hud.gd", "res://scripts/huntress/huntress_runtime.gd",
	"res://scripts/huntress/impact_flash.gd", "res://scripts/huntress/kaykit_clip_source.gd",
	"res://scripts/huntress/splinter_arrow.gd",
]
const D392_DECLARED_HUNTRESS_HOOKS := [
	"foundation_main.gd: huntress", "foundation_main.gd: huntress_hud",
	"skill_runtime.gd: huntress",
]

## ============================================================================
## ADDED UNDER D-396 FOR A26's ONE-FOR-ONE RE-SCOPE: the runtime scripts the
## KINDRED HOUNDS STAGE adds (7, all under scripts/hounds/). It needs NO new
## Huntress-named declaration outside scripts/huntress/ -- the hooks above are
## unchanged, and the Huntress is the pack's `handler` in its code.
## ============================================================================
const D396_RUNTIME_SCRIPTS := [
	"res://scripts/hounds/hound_config.gd", "res://scripts/hounds/hound_content.gd",
	"res://scripts/hounds/hound_review_hud.gd", "res://scripts/hounds/hound_runtime.gd",
	"res://scripts/hounds/hound_stand_in.gd", "res://scripts/hounds/hound_targeting.gd",
	"res://scripts/hounds/kindred_hound.gd",
]

## ============================================================================
## ADDED UNDER D-398 FOR A26's ONE-FOR-ONE RE-SCOPE: the runtime scripts the
## MOBILE MINION COHESION STAGE adds (7, all under scripts/cohort/). It needs NO
## new Huntress-named declaration outside scripts/huntress/ -- the hooks above are
## unchanged -- and adds no Imprint, Configuration, entry point or asset.
## ============================================================================
const D398_RUNTIME_SCRIPTS := [
	"res://scripts/cohort/attack_positions.gd", "res://scripts/cohort/cohort_config.gd",
	"res://scripts/cohort/cohort_diagnostics.gd", "res://scripts/cohort/cohort_formation.gd",
	"res://scripts/cohort/cohort_review_hud.gd", "res://scripts/cohort/formation_profile.gd",
	"res://scripts/cohort/mobile_cohort.gd",
]

## ============================================================================
## ADDED UNDER D-400 FOR A26's ONE-FOR-ONE RE-SCOPE: the TWO runtime scripts the
## PLAYER LOCOMOTION REDIRECTION STAGE adds, both under scripts/locomotion/.
## Anything else still fails A26, and no other pin in A26 moves: D-400 adds no
## Imprint, Configuration, action entry point, asset, scene, input action or
## Huntress hook.
## ============================================================================
const D400_RUNTIME_SCRIPTS := [
	"res://scripts/locomotion/ground_motion.gd", "res://scripts/locomotion/locomotion_config.gd",
]

## The SIX runtime scripts the D-402 Cinder Field stage declares. 62 + 6 = 68.
const D402_RUNTIME_SCRIPTS := [
	"res://scripts/cinder/cinder_config.gd", "res://scripts/cinder/cinder_content.gd",
	"res://scripts/cinder/cinder_ground.gd", "res://scripts/cinder/cinder_review_hud.gd",
	"res://scripts/cinder/cinder_runtime.gd", "res://scripts/cinder/cinder_trap.gd",
]

## ============================================================================
## ADDED UNDER D-404 FOR A26's ONE-FOR-ONE RE-SCOPE: the FOUR runtime scripts the
## PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE adds, all under scripts/click/.
## 68 + 4 = 72. Anything else still fails A26, and no other pin in A26 moves:
## D-404 adds no Imprint, Configuration, action entry point, asset, scene, input
## action or Huntress hook.
## ============================================================================
const D404_RUNTIME_SCRIPTS := [
	"res://scripts/click/direct_click_config.gd", "res://scripts/click/direct_click_gizmo.gd",
	"res://scripts/click/direct_click_order.gd", "res://scripts/click/direct_click_review_hud.gd",
]

## Every runtime declaration whose NAME begins with `huntress` -- `var huntress`,
## `var huntress_hud`, `func huntress_x` -- in lower-cased CODE (comments
## stripped by the caller). Class names such as `HuntressConfig` are
## `huntressconfig` and are matched too, by prefix.
static func _huntress_declarations(code: String) -> Array:
	var out: Array = []
	var re := RegEx.new()
	re.compile("(?m)^\\s*(func|var|const|class_name)\\s+(huntress[a-z0-9_]*)")
	for m in re.search_all(code):
		out.append(m.get_string(2))
	return out

## ============================================================================
## EVERY NUMERIC ImprintConfig CONSTANT, AS D-375 LEFT IT. VALUE BY VALUE.
## ============================================================================
## The owner: "Do not lock or invent: rank cap; XP thresholds, curve or catch-up
## values; ... Capacity totals or costs; reservation percentages; ... final
## Mana/Life values." So A20 pins EVERY numeric constant this stage did not
## replace, against the D-375 figure, in BOTH directions -- a constant that moved
## fails, and a numeric constant that APPEARED without being declared fails.
## 104 unchanged + 5 removed = the 109 D-375 numeric constants; 104 + 3 added = 107 now.
const D375_NUMERIC := {
	"CANON_MODIFIER_SLOTS_MAX": 4, "CANON_TRANSFORMS_MAX_PER_CONFIGURATION": 1,
	"CANON_ACTIVE_BINDINGS": 8, "RANK_MIN": 1, "RANK_MAX": 20, "XP_PER_RANK_STEP": 120.0,
	"COMBAT_PROGRESS_PER_ENEMY_DEFEATED": 60.0, "CATCHUP_PER_RANK_BEHIND": 0.5,
	"CATCHUP_MULTIPLIER_MAX": 4.0, "CAPACITY_FROM_PROGRESSION": 30,
	"CAPACITY_GEAR_BONUS_DIAGNOSTIC": 5, "CAPACITY_BASE_PRIMARY": 3,
	"CAPACITY_BASE_SECONDARY": 2, "CAPACITY_BASE_PERSISTENT": 1,
	"CAPACITY_PER_MODIFIER_PRIMARY": 2, "CAPACITY_PER_MODIFIER_SECONDARY": 2,
	"CAPACITY_PER_MODIFIER_PERSISTENT": 1, "MANA_MAX": 500.0, "LIFE_MAX": 300.0,
	"AURA_RESERVE_FRACTION_AT_RANK_1": 0.18, "AURA_RESERVE_FRACTION_PER_RANK": 0.006,
	"AURA_BEAST_DAMAGE_BONUS_AT_RANK_1": 0.20, "AURA_BEAST_DAMAGE_BONUS_PER_RANK": 0.02,
	"STORM_DAMAGE_AT_RANK_1": 26.0, "STORM_DAMAGE_PER_RANK": 3.1, "STORM_MANA_AT_RANK_1": 12.0,
	"STORM_MANA_PER_RANK": 0.36, "STORM_COOLDOWN_AT_RANK_1": 0.55,
	"STORM_COOLDOWN_PER_RANK": -0.0055, "STORM_ACTION_DURATION": 0.50,
	"STORM_PROJECTILE_SPEED": 26.0, "STORM_PROJECTILE_RANGE": 17.0,
	"STORM_PROJECTILE_RADIUS": 0.30, "BALLISTA_DAMAGE_AT_RANK_1": 11.0,
	"BALLISTA_DAMAGE_PER_RANK": 1.05, "BALLISTA_MANA_AT_RANK_1": 26.0,
	"BALLISTA_MANA_PER_RANK": 0.9, "BALLISTA_COOLDOWN": 2.60, "BALLISTA_ACTION_DURATION": 0.55,
	"BALLISTA_DURATION_AT_RANK_1": 7.0, "BALLISTA_DURATION_PER_RANK": 0.55,
	"BALLISTA_FIRE_INTERVAL": 0.85, "BALLISTA_ACQUIRE_RANGE": 12.0, "BALLISTA_INSTANCES_MAX": 2,
	"BALLISTA_PLACE_RANGE": 9.0, "BEAST_DAMAGE_AT_RANK_1": 7.0, "BEAST_DAMAGE_PER_RANK": 0.62,
	"BEAST_MANA_AT_RANK_1": 34.0, "BEAST_MANA_PER_RANK": 1.1, "BEAST_COOLDOWN": 4.00,
	"BEAST_ACTION_DURATION": 0.60, "BEAST_ATTACK_INTERVAL": 1.05, "BEAST_ATTACK_RANGE": 1.60,
	"BEAST_ACQUIRE_RANGE": 13.0, "BEAST_FOLLOW_DISTANCE": 2.40, "BEAST_SPEED_MPS": 4.30,
	"BEAST_BODY_RADIUS": 0.34, "BEAST_VISUAL_SCALE": 0.62, "BEAST_COUNT_AT_RANK_1": 1,
	"BEAST_COUNT_RANK_STEP": 7, "SPLIT_VOLLEY_EXTRA_AT_RANK_1": 1, "SPLIT_VOLLEY_RANK_STEP": 7,
	"SPLIT_VOLLEY_SPREAD_DEG": 13.0, "SPLIT_VOLLEY_MANA_SURCHARGE_AT_RANK_1": 4.0,
	"SPLIT_VOLLEY_MANA_SURCHARGE_PER_RANK": 0.22, "FORK_CHILDREN": 2, "FORK_MAX_GENERATIONS": 1,
	"FORK_ANGLE_DEG": 34.0, "FORK_DAMAGE_FRACTION_AT_RANK_1": 0.42,
	"FORK_DAMAGE_FRACTION_PER_RANK": 0.011, "FORK_MANA_SURCHARGE": 5.0,
	"FORK_MANA_SURCHARGE_PER_RANK": 0.30, "TEMPERED_MORE_DAMAGE_AT_RANK_1": 0.18,
	"TEMPERED_MORE_DAMAGE_PER_RANK": 0.012, "TEMPERED_MANA_SURCHARGE_AT_RANK_1": 6.0,
	"TEMPERED_MANA_SURCHARGE_PER_RANK": 0.3, "TEMPERED_ACTION_DURATION_ADD": 0.08,
	"SUREFOOT_LESS_DAMAGE_AT_RANK_1": 0.16, "SUREFOOT_LESS_DAMAGE_PER_RANK": -0.006,
	"SUREFOOT_ACTION_DURATION_MULT": 0.74, "SUREFOOT_ACTION_DURATION_MULT_PER_RANK": -0.004,
	"SUREFOOT_MANA_SURCHARGE": 3.0, "EXTENDED_WARD_DURATION_MULT_AT_RANK_1": 1.30,
	"EXTENDED_WARD_DURATION_MULT_PER_RANK": 0.02, "EXTENDED_WARD_MANA_SURCHARGE": 7.0,
	"EXTENDED_WARD_MANA_PER_RANK": 0.40, "PACK_INSTINCT_EXTRA_BEASTS": 1,
	"PACK_INSTINCT_LESS_DAMAGE_AT_RANK_1": 0.22, "PACK_INSTINCT_LESS_DAMAGE_PER_RANK": -0.009,
	"PACK_INSTINCT_MANA_SURCHARGE": 9.0, "PACK_INSTINCT_MANA_PER_RANK": -0.25,
	"ORBIT_DURATION_AT_RANK_1": 2.4, "ORBIT_DURATION_PER_RANK": 0.13,
	"ORBIT_PULSE_INTERVAL_AT_RANK_1": 0.46, "ORBIT_PULSE_INTERVAL_PER_RANK": -0.009,
	"ORBIT_RADIUS": 3.10, "ORBIT_MANA_SURCHARGE": 11.0, "RAIN_VOLLEYS_AT_RANK_1": 2,
	"RAIN_VOLLEY_RANK_STEP": 5, "RAIN_MANA_SURCHARGE": 9.0, "RAIN_MANA_PER_RANK": 0.45,
	"ANCHOR_DURATION_MULT": 3.40, "ANCHOR_MANA_SURCHARGE": 13.0, "ANCHOR_MANA_PER_RANK": 0.90,
}
## REMOVED by D-380, each with its ruling. They must be ABSENT.
const D380_REMOVED := {
	"CANDIDATE_ACTIVE_CONFIGURATIONS": "OD-09", "CANDIDATE_PERSISTENT_CONFIGURATIONS": "D-376 X-02 / OD-07",
	"MANA_REGEN_PER_S": "OD-05", "LIFE_TITHE_FRACTION_AT_RANK_1": "OD-06",
	"LIFE_TITHE_FRACTION_PER_RANK": "OD-06",
}
## ADDED by D-380, each DERIVED from a value that was already there. 5 out, 3 in.
const D380_ADDED := {
	"MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S": 0.044,
	"LIFE_CONVERSION_RATIO_AT_RANK_1": 1.444,
	"LIFE_CONVERSION_RATIO_PER_RANK": -0.0154,
}

var reached := {}
var results := {}
var notes := {}

var main: Node
var player: PlayerController
var cam: IsoCameraRig
var skills: SkillRuntime
var panel: LoadoutPanel
## D-381: the review HUD and the accepted F1 overlay, and what launch showed.
var review_hud: ReviewHud
var overlay: DebugOverlay
var launch := {}

func _initialize() -> void:
	print("========================================================================")
	print("RIFTWROUGHT — %s VERIFICATION  (%s, %s)"
		% [ImprintConfig.ALIGNMENT_STAGE, ImprintConfig.ALIGNMENT_DECISION,
		   ImprintConfig.ALIGNMENT_DATE])
	print("STATE: %s" % ProdConfig.STATE)
	# D-392 (first act): this read "Verifying a STAGE DELIVERED OPEN" until D-392
	# -- true when written; D-383 accepted and closed the stage.
	# D-396 (first act): "under the D-392 HUNTRESS SPLINTER SHOT STAGE" until D-396.
	print("Verifying a stage ACCEPTED and CLOSED under D-383 (delivered OPEN under D-380), re-run")
	print("as a REGRESSION under the D-396 KINDRED HOUNDS STAGE: the Imprint runtime ALIGNED")
	print("with the owner's D-378 rulings. It is NOT Huntress implementation and NOT progression")
	print("tuning. It completes no phase, authorizes no phase, LOCKS NO NUMBER and ADOPTS NO D-378")
	print("TEST CANDIDATE.")
	print("OWED EXECUTABLE CHECKS: %d   DEFERRED/OWED-TO-OWNER ROWS: %d   DISCHARGED: %d"
		% [OWED.size(), DEFERRED_ROWS.size(), DISCHARGED_ROWS.size()])
	print("(The D-380 owed-criteria INVENTORY counts 162 CRITERIA — 121 + 25 under D-381 + 16 under D-382. Different unit.)")
	print("(The D-375 suite counts 101 EXECUTABLE CHECKS and the D-370 suite 85. Different")
	print(" decisions, different units. None is a synonym for another.)")
	print("========================================================================")

	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	for i in 16:
		await process_frame

	# ========================================================================
	# D-396 — THE DECLARED FIXTURE: THE ACCEPTED LOADOUT, RESTORED.
	# ========================================================================
	# Since D-396 the scene composes the Kindred Hounds stage and its REVIEW
	# loadout: Kindred Hounds replace the diagnostic aura as the one Persistent,
	# the D-381 reservation cycle drives THEM, binding 4 is unbound, and two
	# autonomous hounds bite registered enemies. This ACCEPTED suite measures the
	# aura's reservation cycle, its Health clamp and its HUD with exact figures, so
	# the loadout it was accepted with (the D-392 loadout, no pack, the cycle on the
	# aura) is restored through the runtime's OWN loadout operations BEFORE the
	# launch capture. It adds no check and removes none; the D-396 suite proves the
	# restoration exact and measures the review loadout itself.
	main.get("hounds").restore_accepted_d392_loadout()
	await physics_frame

	player = main.get("player")
	cam = main.get("cam")
	skills = main.get("skills")
	panel = main.get("imprint_panel")
	review_hud = main.get("review_hud")
	overlay = main.get("hud")
	# WHAT LAUNCH SHOWED, captured BEFORE any check touches anything (D-381).
	launch = {
		"panel_enabled": panel.enabled, "panel_visible": panel.visible,
		"hud_enabled": review_hud != null and review_hud.enabled,
		"hud_visible": review_hud != null and review_hud.visible,
		# D-392: the Splinter Shot review HUD, captured at launch beside the D-381 one.
		"d392_hud_enabled": main.get("huntress_hud") != null and main.get("huntress_hud").enabled,
		"d392_hud_visible": main.get("huntress_hud") != null and main.get("huntress_hud").visible,
		"overlay_enabled": overlay.enabled, "overlay_visible": overlay.visible,
		"health_life": player.life.life, "health_ceiling": player.life.ceiling,
		"state": skills.reservation_state(),
		"mana_reserved": skills.pool.mana_reserved, "life_reserved": skills.pool.life_reserved,
	}

	# THE SCENE'S OWN ENEMIES ARE FROZEN AND MADE UNKILLABLE, exactly as the
	# accepted Imprint suite does: a death would award combat progress and move
	# the very ranks and XP these checks measure.
	for e in main.get("enemies"):
		e.debug_freeze_ai = true
		e.life = Damageable.new(1000000.0)
	skills.set_safe_state_override(true)

	for id in OWED:
		await _run(id)

	_report()
	quit(0 if _all_ok() else 1)

func _run(id: String) -> void:
	# A MISSING METHOD IS A FAIL, NOT A SKIP.
	var m := "chk_" + id
	if not has_method(m):
		results[id] = false
		_note(id, "NO CHECK FUNCTION `%s` EXISTS — the suite owes a check it never wrote." % m)
		return
	var ok = await Callable(self, m).call()
	results[id] = ok

func _reached(id: String) -> void:
	reached[id] = true

func _note(id: String, s: String) -> void:
	notes[id] = s

# ------------------------------------------------------------- utilities ----

func _phys(n: int) -> void:
	for i in n:
		await physics_frame

func _read_text(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return ""
	var s := f.get_as_text()
	f.close()
	return s

func _walk(path: String, out: Array) -> void:
	var d := DirAccess.open(path)
	if d == null:
		return
	d.list_dir_begin()
	var n := d.get_next()
	while n != "":
		if n.begins_with("."):
			n = d.get_next()
			continue
		var full := path.path_join(n)
		if d.current_is_dir():
			_walk(full, out)
		else:
			out.append(full)
		n = d.get_next()
	d.list_dir_end()

func _runtime_script_files() -> Array:
	var all: Array = []
	_walk("res://scripts", all)
	var out: Array = []
	for f in all:
		if String(f).ends_with(".gd"):
			out.append(String(f))
	out.sort()
	return out

func _constants(path: String) -> Dictionary:
	var scr: Script = load(path)
	return scr.get_script_constant_map()

func _config_constants() -> Dictionary:
	return _constants("res://scripts/imprint/imprint_config.gd")

## The arity of a script method, read from the script itself. -1 when absent.
func _arity(path: String, method: String) -> int:
	var scr: Script = load(path)
	for m in scr.get_script_method_list():
		if String(m["name"]) == method:
			return (m["args"] as Array).size()
	return -1

## Keys of `consts` that contain EVERY token in `tokens`. Used by the candidate
## and surcharge guards, and proved able to fail against a planted dictionary.
static func _keys_with_all(consts: Dictionary, tokens: Array) -> Array:
	var hits: Array = []
	for k in consts.keys():
		var key := String(k).to_upper()
		var all := true
		for t in tokens:
			if key.find(String(t).to_upper()) < 0:
				all = false
		if all:
			hits.append(String(k))
	return hits

## A precise declaration scanner (the accepted suite's criterion): `func`,
## `var`, `const` or `class_name` followed by the token or token_ .
func _declarations_naming(text: String, tokens: Array) -> Array:
	var hits: Array[String] = []
	for raw in tokens:
		var tok := String(raw)
		var re := RegEx.new()
		var esc := tok.replace("_", "\\_")
		re.compile("(?m)^\\s*(func|var|const|class_name)\\s+" + esc + "(?![A-Za-z0-9])")
		if re.search(text) != null:
			hits.append(tok)
	return hits

## ============================================================================
## CODE ONLY. Added after the FIRST final run exposed two guards that fired on
## DATED HISTORY COMMENTS -- the comments that quote the removed `learn(imp,
## rank)` call and the removed CANDIDATE_ACTIVE_CONFIGURATIONS constant, which
## this project's discipline REQUIRES to be kept. A guard that cannot tell a
## history note from code is noise (the accepted suite's own I44 lesson), so the
## source-scanning guards read code lines only -- and each is proved able to fail
## against a planted CODE line.
static func _code_only(text: String) -> String:
	var out := PackedStringArray()
	for line in text.split("\n"):
		if String(line).strip_edges().begins_with("#"):
			continue
		out.append(String(line))
	return "\n".join(out)

## A FRESH diagnostic library -- learned at rank 1 / 0 XP, then seeded -- so
## no check disturbs the build under review.
func _scratch_library() -> ImprintLibrary:
	return DiagImprintContent.build_library()

func _cfg(lib: ImprintLibrary, cid: String, skill: String, mods: Array) -> SkillConfiguration:
	var c := SkillConfiguration.new(cid, lib)
	c.set_skill(skill)
	for m in mods:
		c.install(String(m))
	return c

## The eight LIGHTLY modified Configurations the panel trial also uses.
func _light_eight(lib: ImprintLibrary) -> Dictionary:
	var C := DiagImprintContent
	var out := {}
	out["L_bow"] = _cfg(lib, "L_bow", C.SKILL_STORM, [])
	out["L_bow_split"] = _cfg(lib, "L_bow_split", C.SKILL_STORM, [C.AUG_SPLIT])
	out["L_bow_fork"] = _cfg(lib, "L_bow_fork", C.SKILL_STORM, [C.AUG_FORK])
	out["L_bow_tempered"] = _cfg(lib, "L_bow_tempered", C.SKILL_STORM, [C.AUG_TEMPERED])
	out["L_ballista"] = _cfg(lib, "L_ballista", C.SKILL_BALLISTA, [])
	out["L_ballista_ward"] = _cfg(lib, "L_ballista_ward", C.SKILL_BALLISTA, [C.AUG_WARD])
	out["L_beasts"] = _cfg(lib, "L_beasts", C.SKILL_BEASTS, [])
	out["L_beasts_pack"] = _cfg(lib, "L_beasts_pack", C.SKILL_BEASTS, [C.AUG_PACK])
	return out

## The eight HEAVILY modified Configurations.
func _heavy_eight(lib: ImprintLibrary) -> Dictionary:
	var C := DiagImprintContent
	var out := {}
	out["H_bow_full"] = _cfg(lib, "H_bow_full", C.SKILL_STORM,
		[C.AUG_SPLIT, C.AUG_FORK, C.AUG_TEMPERED, C.AUG_SUREFOOT])
	out["H_bow_three"] = _cfg(lib, "H_bow_three", C.SKILL_STORM,
		[C.AUG_SPLIT, C.AUG_FORK, C.AUG_TEMPERED])
	out["H_orbit"] = _cfg(lib, "H_orbit", C.SKILL_STORM, [C.AUG_TEMPERED, C.XF_ORBIT])
	out["H_rain"] = _cfg(lib, "H_rain", C.SKILL_STORM, [C.XF_RAIN, C.AUG_SPLIT])
	out["H_ballista"] = _cfg(lib, "H_ballista", C.SKILL_BALLISTA, [C.AUG_WARD, C.AUG_SPLIT])
	out["H_anchor"] = _cfg(lib, "H_anchor", C.SKILL_BALLISTA, [C.XF_ANCHOR])
	out["H_beasts"] = _cfg(lib, "H_beasts", C.SKILL_BEASTS, [C.AUG_PACK, C.AUG_TEMPERED])
	out["H_beasts_pack"] = _cfg(lib, "H_beasts_pack", C.SKILL_BEASTS, [C.AUG_PACK])
	return out

func _bind_all(lo: ImprintLoadout, cfgs: Dictionary) -> int:
	var bound := 0
	var i := 0
	for cid in cfgs:
		if lo.bind(i, String(cid))["ok"]:
			bound += 1
		i += 1
	return bound

func _all_pages_text() -> String:
	var was := panel.page
	var t := ""
	for p in LoadoutPanel.PAGES.size():
		panel.page = p
		panel.refresh()
		t += panel.compose() + "\n"
	panel.page = was
	panel.refresh()
	return t

func _page_text(page_name: String) -> String:
	var was := panel.page
	panel.page = LoadoutPanel.PAGES.find(page_name)
	panel.refresh()
	var t := panel.compose()
	panel.page = was
	panel.refresh()
	return t

# ============================================================================
# A. THE FIRST ACT — the accepted-stage reconciliation D-376 section 7 recommended
# ============================================================================

func chk_A01_state_names_all_three_stages_truthfully() -> bool:
	# ========================================================================
	# RE-PINNED UNDER D-392, AS ITS FIRST ACT. THE ID IS UNCHANGED.
	# ========================================================================
	# From D-380 until D-392 this pinned the THREE-stage line ending "D-378
	# ALIGNMENT STAGE DELIVERED and OPEN pending owner live review (D-380)" --
	# TRUE WHEN WRITTEN. D-383 accepted and closed that stage and D-383 section 6
	# recommended the repair; the D-392 ruling authorizes it. The pin is STILL
	# EXACT-LINE, and it GAINS an absence check: the D-380-era clause must be
	# GONE, exactly as the D-375-era clause had to be at D-380. The id keeps its
	# words "all three stages" -- the three ACCEPTED ones are all named, and the
	# fourth fact is the new stage's open state.
	#
	# RE-PINNED AGAIN UNDER D-396, AS ITS FIRST ACT (D-394 section 7). From D-392
	# until D-396 the fourth fact was "HUNTRESS SPLINTER SHOT STAGE DELIVERED and
	# OPEN pending owner live review (D-392)" -- TRUE WHEN WRITTEN. D-394 accepted
	# that stage. The pin is STILL EXACT-LINE, now FIVE facts, and it GAINS an
	# absence check for the D-392-era clause.
	#
	# RE-PINNED A THIRD TIME UNDER D-398, AS ITS FIRST ACT (D-397 section 6). From
	# D-396 until D-398 the fifth fact was "KINDRED HOUNDS STAGE DELIVERED and OPEN
	# pending owner live review (D-396)" -- TRUE WHEN WRITTEN. D-397 accepted that
	# stage. The pin is STILL EXACT-LINE, now SIX facts, and it GAINS an absence
	# check for the D-396-era clause.
	#
	# RE-PINNED A FOURTH TIME UNDER D-400, AS ITS FIRST ACT. From D-398 until D-400
	# the sixth fact was "MOBILE MINION COHESION STAGE DELIVERED and OPEN pending
	# owner live review (D-398)" -- TRUE WHEN WRITTEN. D-400 accepted that stage.
	# The pin is STILL EXACT-LINE, now SEVEN facts, and it GAINS an absence check
	# for the D-398-era clause.
	#
	# RE-PINNED A FIFTH TIME UNDER D-402, AS ITS FIRST ACT (D-401 section 6). From
	# D-400 until D-402 the seventh fact was "PLAYER LOCOMOTION REDIRECTION STAGE
	# DELIVERED and OPEN pending owner live review (D-400)" -- TRUE WHEN WRITTEN.
	# D-401 accepted that stage. The pin is STILL EXACT-LINE, now EIGHT facts, and
	# it GAINS an absence check for the D-400-era clause.
	#
	# RE-PINNED A SIXTH TIME UNDER D-404, AS ITS FIRST ACT. From D-402 until D-404
	# the eighth fact was "CINDER FIELD STAGE DELIVERED and OPEN pending owner live
	# review (D-402)" -- TRUE WHEN WRITTEN. D-403 accepted that stage. The pin is
	# STILL EXACT-LINE, now NINE facts, and it GAINS an absence check for the
	# D-402-era clause.
	var expect := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE ACCEPTED and CLOSED (D-403) · PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)"
	var st := ProdConfig.STATE
	var exact := st == expect
	var d375_gone := st.find("IMPRINT STAGE DELIVERED and OPEN") < 0 \
		and st.find("D-378 ALIGNMENT STAGE DELIVERED and OPEN") < 0 \
		and st.find("HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN") < 0 \
		and st.find("KINDRED HOUNDS STAGE DELIVERED and OPEN") < 0 \
		and st.find("MOBILE MINION COHESION STAGE DELIVERED and OPEN") < 0 \
		and st.find("PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN") < 0 \
		and st.find("CINDER FIELD STAGE DELIVERED and OPEN") < 0
	var bare_gone := st != "DELIVERED and OPEN pending owner live review"
	# ONE SOURCE OF STATE: exactly one runtime declaration of `const STATE`, in
	# ProdConfig. Every other surface READS it.
	var definers: Array[String] = []
	for f in _runtime_script_files():
		if _declarations_naming(_read_text(String(f)), ["STATE"]).size() > 0:
			definers.append(String(f).get_file())
	var one_source := definers.size() == 1 and definers[0] == "prod_config.gd"
	# The surfaces that print it read the constant rather than a copy.
	var overlay_reads := _read_text("res://scripts/debug/debug_overlay.gd").find("ProdConfig.STATE") >= 0
	var panel_reads := _read_text("res://scripts/imprint/loadout_panel.gd").find("ProdConfig.STATE") >= 0
	# THE GUARD MUST BE ABLE TO FAIL: the counter sees a planted second definer.
	var guard := _declarations_naming("const STATE := \"x\"", ["STATE"]).size() == 1
	var ok := exact and d375_gone and bare_gone and one_source and overlay_reads and panel_reads and guard
	_note("A01_state_names_all_three_stages_truthfully",
		"STATE = '%s' — EXACTLY the nine-fact line (D-404 first act; the eight-fact line from D-402, the seven-fact line from D-400, the six-fact from D-398, the five-fact from D-396, the four-fact from D-392, the three-stage D-380 line before)=%s; the D-375-era 'IMPRINT STAGE DELIVERED and OPEN', D-380-era 'D-378 ALIGNMENT STAGE DELIVERED and OPEN', D-392-era 'HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN', D-396-era 'KINDRED HOUNDS STAGE DELIVERED and OPEN', D-398-era 'MOBILE MINION COHESION STAGE DELIVERED and OPEN' D-400-era 'PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN' and D-402-era 'CINDER FIELD STAGE DELIVERED and OPEN' clauses are gone=%s; the bare D-370 string is gone=%s | ONE source of state: runtime declarations of STATE %s=%s, read by the overlay=%s and the panel=%s | the definer counter is PROVED able to see a planted one=%s"
		% [st, str(exact), str(d375_gone), str(bare_gone), str(definers), str(one_source),
		   str(overlay_reads), str(panel_reads), str(guard)])
	_reached("A01_state_names_all_three_stages_truthfully")
	return ok

func chk_A02_the_eight_mo_rows_are_discharged_with_history_preserved() -> bool:
	# Judged from the ACCEPTED SUITE ITSELF: its constants, and its source.
	var consts := _constants("res://tests/imprint_verification.gd")
	var deferred: Array = consts.get("DEFERRED_ROWS", [])
	var discharged: Array = consts.get("DISCHARGED_ROWS", [])
	var sixteen := deferred.size() == 16
	var eight := discharged.size() == 8
	var titles_ok := true
	var kinds_ok := true
	for i in discharged.size():
		var row: Array = discharged[i]
		if not String(row[0]).begins_with("MO-0%d" % (i + 1)):
			titles_ok = false
		if String(row[1]) != "DISCHARGED — D-376" \
				or String(row[2]).find("ORIGINAL ROW TEXT, PRESERVED VERBATIM") < 0 \
				or String(row[2]).find("THE OWNER'S D-376 LIVE REVIEW ANSWERED IT") < 0:
			kinds_ok = false
	var no_mo_owed := true
	for row in deferred:
		if String(row[0]).begins_with("MO-") or String(row[1]) == "OWED-TO-OWNER":
			no_mo_owed = false
	# EACH ORIGINAL TEXT IS STILL THERE, by a phrase unique to it -- searched in
	# the CONSTANT'S OWN STRINGS, not the source: the source splits a long string
	# across `" + "` continuations (fixed after the first final run, where
	# "CONFLICT X-02 IS THE LIVE QUESTION" was reported lost for exactly that reason).
	var src := _read_text("res://tests/imprint_verification.gd")
	var carried := ""
	for row in discharged:
		carried += String(row[2]) + "\n"
	var phrases := ["THE RULING ASKS THIS DIRECTLY", "cannot be bricked by levelling (I37)",
		"different delivery, different damage sources", "LEGIBLE AND USEFUL",
		"CONFLICT X-02 IS THE LIVE QUESTION", "or feels like watching",
		"reads as a NEW SKILL", "PAUSING THE WORLD"]
	var lost: Array[String] = []
	for p in phrases:
		if carried.find(String(p)) < 0:
			lost.append(String(p))
	# THE SEARCH CAN FAIL: a phrase that is not in the rows is reported lost.
	var search_guard := carried.find("A PHRASE NO DISCHARGED ROW CONTAINS") < 0
	# AND NO ROW IS DECLARED OWED-TO-OWNER any more. The needle is a row KIND.
	var no_owed_kind := src.find("\"OWED-TO-OWNER\",") < 0
	# THE PIN MOVED IN THE SAME CHANGE.
	var runner := _read_text("res://tests/imprint_smoke.sh")
	var repinned := runner.find("\nPIN_I_DEFERRED=16\n") >= 0 and runner.find("\nPIN_I_DEFERRED=24\n") < 0
	var ok := sixteen and eight and titles_ok and kinds_ok and no_mo_owed and lost.is_empty() \
		and no_owed_kind and repinned and search_guard
	_note("A02_the_eight_mo_rows_are_discharged_with_history_preserved",
		"the accepted Imprint suite now carries %d DEFERRED/STILL OWED rows=%s and %d DISCHARGED rows=%s, MO-01..MO-08 in order=%s, each 'DISCHARGED — D-376' with the owner's answer AND its ORIGINAL TEXT PRESERVED VERBATIM=%s | no MO- row and no OWED-TO-OWNER row remains owed=%s/%s | every original text is still present in the rows' own strings (lost: %s; the search can fail=%s) | the runner's deferred pin moved 24 -> 16 IN THE SAME CHANGE=%s. 24 - 8 = 16, ZERO ROWS DELETED."
		% [deferred.size(), str(sixteen), discharged.size(), str(eight), str(titles_ok),
		   str(kinds_ok), str(no_mo_owed), str(no_owed_kind), str(lost), str(search_guard), str(repinned)])
	_reached("A02_the_eight_mo_rows_are_discharged_with_history_preserved")
	return ok

## The state-pin audit, as a function so it can be PROVED able to refuse a
## planted stale runner.
func _runner_pins_current(text: String) -> bool:
	# RE-PINNED UNDER D-392 (first act): the truthfulness strings now carry the
	# D-383 clause and the D-392 clause, and the D-380-era PIN must be absent.
	# Until D-392 this required the D-380 clause "D-378 ALIGNMENT STAGE DELIVERED
	# and OPEN pending owner live review (D-380)" -- true when written.
	# RE-PINNED UNDER D-396 (first act): the D-392 clause gives way to the D-394
	# clause and the D-396 clause, and the D-392-era PIN must be absent. Until D-396
	# this required "HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN pending owner
	# live review (D-392)" -- true when written.
	# RE-PINNED UNDER D-398 (first act): the D-396 clause gives way to the D-397
	# clause and the D-398 clause, and the D-396-era PIN must be absent. Until D-398
	# this required "KINDRED HOUNDS STAGE DELIVERED and OPEN pending owner live
	# review (D-396)" -- true when written.
	var line := "STATE_EXPECT=\"STATE: %s\"" % ProdConfig.STATE
	var d375_pin := "STATE_EXPECT=\"STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE DELIVERED and OPEN pending owner live review (D-375)\""
	var d380_pin := "STATE_EXPECT=\"STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE DELIVERED and OPEN pending owner live review (D-380)\""
	var d392_pin := "STATE_EXPECT=\"STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN pending owner live review (D-392)\""
	var d396_pin := "STATE_EXPECT=\"STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE DELIVERED and OPEN pending owner live review (D-396)\""
	# RE-PINNED UNDER D-400 (first act): the D-398 clause gives way to the D-400
	# acceptance clause and the D-400 open clause, and the D-398-era PIN must be
	# absent. Until D-400 this required "MOBILE MINION COHESION STAGE DELIVERED and
	# OPEN pending owner live review (D-398)" -- true when written.
	var d398_pin := "STATE_EXPECT=\"STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE DELIVERED and OPEN pending owner live review (D-398)\""
	# RE-PINNED UNDER D-402 (first act): the D-400 clause gives way to the D-401
	# acceptance and the D-402 open clause, and the D-400-era PIN must be absent.
	# Until D-402 this required "PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED and
	# OPEN pending owner live review (D-400)" -- true when written.
	var d400_pin := "STATE_EXPECT=\"STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN pending owner live review (D-400)\""
	# RE-PINNED UNDER D-404 (first act): the D-402 clause gives way to the D-403
	# acceptance and the D-404 open clause, and the D-402-era PIN must be absent.
	# Until D-404 this required "CINDER FIELD STAGE DELIVERED and OPEN pending owner
	# live review (D-402)" -- true when written.
	var d402_pin := "STATE_EXPECT=\"STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE DELIVERED and OPEN pending owner live review (D-402)\""
	return text.find(line) >= 0 and text.find(d375_pin) < 0 and text.find(d380_pin) < 0 \
		and text.find(d392_pin) < 0 and text.find(d396_pin) < 0 and text.find(d398_pin) < 0 \
		and text.find(d400_pin) < 0 and text.find(d402_pin) < 0 \
		and text.find("\"IMPRINT STAGE ACCEPTED and CLOSED (D-376)\"") >= 0 \
		and text.find("\"D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383)\"") >= 0 \
		and text.find("\"HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394)\"") >= 0 \
		and text.find("\"KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397)\"") >= 0 \
		and text.find("\"MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399)\"") >= 0 \
		and text.find("\"PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401)\"") >= 0 \
		and text.find("\"CINDER FIELD STAGE ACCEPTED and CLOSED (D-403)\"") >= 0 \
		and text.find("\"PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)\"") >= 0 \
		and text.find("\"IMPRINT STAGE DELIVERED and OPEN pending owner live review (D-375)\" \\") < 0

func chk_A03_the_four_truthfulness_pins_moved_together_and_none_was_weakened() -> bool:
	var imp := _read_text("res://tests/imprint_smoke.sh")
	var fnd := _read_text("res://tests/foundation_smoke.sh")
	var aln := _read_text("res://tests/alignment_smoke.sh")
	# S14 / S16 / S17 and R08 carry the CURRENT line and strings, and NOT the old.
	var imp_current := _runner_pins_current(imp)
	var fnd_current := _runner_pins_current(fnd)
	var aln_current := aln.find("STATE_EXPECT=\"STATE: %s\"" % ProdConfig.STATE) >= 0
	# THE PINS ARE STILL EXACT-LINE, AND THE REFUSAL PROOFS ARE STILL THERE.
	var exact_imp := imp.find("if [ \"$LINE\" != \"$STATE_EXPECT\" ]; then") >= 0
	var exact_fnd := fnd.find("if [ \"$STATE_LINE\" = \"$STATE_EXPECT\" ]; then") >= 0
	var refusal := imp.find("sed 's/ACCEPTED and CLOSED/DELIVERED and OPEN/'") >= 0 \
		and fnd.find("sed 's/ACCEPTED and CLOSED/DELIVERED and OPEN/'") >= 0
	# D-396 (first act): and the D-392-era absence checks, in both runners.
	var absence := imp.find("grep -qxF \"$STATE_D400_LINE\"") >= 0 \
		and fnd.find("grep -qxF \"$STATE_D400_LINE\"") >= 0 \
		and imp.find("grep -qxF \"$STATE_D375_LINE\"") >= 0 \
		and fnd.find("grep -qxF \"$STATE_D375_LINE\"") >= 0 \
		and imp.find("grep -qxF \"$STATE_D380_LINE\"") >= 0 \
		and fnd.find("grep -qxF \"$STATE_D380_LINE\"") >= 0 \
		and imp.find("grep -qxF \"$STATE_D392_LINE\"") >= 0 \
		and fnd.find("grep -qxF \"$STATE_D392_LINE\"") >= 0 \
		and imp.find("grep -qxF \"$STATE_D396_LINE\"") >= 0 \
		and fnd.find("grep -qxF \"$STATE_D396_LINE\"") >= 0 \
		and imp.find("grep -qxF \"$STATE_D398_LINE\"") >= 0 \
		and fnd.find("grep -qxF \"$STATE_D398_LINE\"") >= 0 \
		and imp.find("grep -qxF \"$STATE_D402_LINE\"") >= 0 \
		and fnd.find("grep -qxF \"$STATE_D402_LINE\"") >= 0
	# NO COUNT THAT SHOULD NOT MOVE HAS MOVED.
	var counts := imp.find("\nPIN_F_CHECKS=85\n") >= 0 and imp.find("\nPIN_F_DEFERRED=11\n") >= 0 \
		and imp.find("\nPIN_I_CHECKS=101\n") >= 0 and imp.find("\nPIN_I_DEFERRED=16\n") >= 0 \
		and fnd.find("\nPIN_CHECKS=85\n") >= 0 and fnd.find("\nPIN_DEFERRED=11\n") >= 0
	# The accepted foundation suite was not edited to make any of this pass: it
	# asserts nothing about the state, and its 85 owed checks are all present.
	var fsrc := _read_text("res://tests/foundation_verification.gd")
	var i := fsrc.find("const OWED := [")
	var j := fsrc.find("\n]\n", i)
	var f_owed := fsrc.substr(i, j - i).count("\n\t\"F")
	# RE-SCOPED UNDER D-381, one for one: the foundation suite WAS edited once
	# more -- F69's declared action list, 25 + 1 = 26, which the correction's
	# ruling authorizes -- so "not edited" became "edited ONLY inside F69". Every
	# D-381 mention must lie inside F69's body; one anywhere else fails.
	var f69_at := fsrc.find("func chk_F69_")
	var f69_end := fsrc.find("\nfunc ", f69_at + 1)
	var d381_outside := 0
	var at := fsrc.find("D-381")
	while at >= 0:
		if at < f69_at or at > f69_end:
			d381_outside += 1
		at = fsrc.find("D-381", at + 1)
	var d381_in_f69 := fsrc.substr(f69_at, f69_end - f69_at).count("D-381")
	# RE-SCOPED UNDER D-382, one for one: F57 was edited once more -- its pinned
	# launch default flipped to HIDDEN, which the owner ruled -- so every D-382
	# mention must lie inside F57's body, and one anywhere else fails.
	var f57_at := fsrc.find("func chk_F57_")
	var f57_end := fsrc.find("\nfunc ", f57_at + 1)
	var d382_outside := 0
	var at2 := fsrc.find("D-382")
	while at2 >= 0:
		if at2 < f57_at or at2 > f57_end:
			d382_outside += 1
		at2 = fsrc.find("D-382", at2 + 1)
	var d382_in_f57 := fsrc.substr(f57_at, f57_end - f57_at).count("D-382")
	# RE-SCOPED UNDER D-392, one for one: F04 was edited -- its declared
	# third-party trees 1 -> 2, the D-392 placeholder tree authorized by the
	# ruling -- so every D-392 mention must lie inside F04's body, and one
	# anywhere else fails. (Until D-392 no D-392 clause existed -- true when written.)
	var f04_at := fsrc.find("func chk_F04_")
	var f04_end := fsrc.find("\nfunc ", f04_at + 1)
	var d392_outside := 0
	var at3 := fsrc.find("D-392")
	while at3 >= 0:
		if at3 < f04_at or at3 > f04_end:
			d392_outside += 1
		at3 = fsrc.find("D-392", at3 + 1)
	var d392_in_f04 := fsrc.substr(f04_at, f04_end - f04_at).count("D-392")
	# RE-SCOPED UNDER D-396, one for one: the foundation suite was edited in TWO
	# places -- F69's declared action list, 26 + 1 = 27 (the ruling's diagnostic
	# review control), and `_initialize`, where the DECLARED fixture restores the
	# accepted D-392 loadout (the autonomous pack would otherwise contaminate its
	# measurements). Every D-396 mention must lie inside F69's body or
	# `_initialize`'s, and one anywhere else fails.
	var init_at := fsrc.find("func _initialize()")
	var init_end := fsrc.find("\nfunc ", init_at + 1)
	var d396_outside := 0
	var at4 := fsrc.find("D-396")
	while at4 >= 0:
		var in_f69 := at4 > f69_at and at4 < f69_end
		var in_init := at4 > init_at and at4 < init_end
		if not in_f69 and not in_init:
			d396_outside += 1
		at4 = fsrc.find("D-396", at4 + 1)
	var d396_in_f69 := fsrc.substr(f69_at, f69_end - f69_at).count("D-396")
	var d396_in_init := fsrc.substr(init_at, init_end - init_at).count("D-396")
	# RE-SCOPED UNDER D-398, one for one: the foundation suite was edited in ONE
	# place -- F69's declared action list, 27 + 2 = 29 (the ruling's two
	# diagnostic stress and travel-speed modes) -- so every D-398 mention must lie
	# inside F69's body, and one anywhere else fails.
	var d398_outside := 0
	var at5 := fsrc.find("D-398")
	while at5 >= 0:
		if at5 < f69_at or at5 > f69_end:
			d398_outside += 1
		at5 = fsrc.find("D-398", at5 + 1)
	var d398_in_f69 := fsrc.substr(f69_at, f69_end - f69_at).count("D-398")
	var foundation_untouched := f_owed == 85 and fsrc.find("DISCHARGED — D-373") >= 0 \
		and fsrc.find("D-380") < 0 and f69_at >= 0 and d381_outside == 0 and d381_in_f69 >= 1 \
		and f57_at >= 0 and d382_outside == 0 and d382_in_f57 >= 1 \
		and f04_at >= 0 and d392_outside == 0 and d392_in_f04 >= 1 \
		and init_at >= 0 and d396_outside == 0 and d396_in_f69 >= 1 and d396_in_init >= 1 \
		and d398_outside == 0 and d398_in_f69 >= 1
	# THE AUDIT MUST BE ABLE TO FAIL: a runner still carrying the D-375 pin is refused.
	var planted := imp.replace("STATE_EXPECT=\"STATE: %s\"" % ProdConfig.STATE,
		"STATE_EXPECT=\"STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE DELIVERED and OPEN pending owner live review (D-375)\"")
	# D-392: and a runner still carrying the D-380-era pin is refused too.
	var planted380 := imp.replace("STATE_EXPECT=\"STATE: %s\"" % ProdConfig.STATE,
		"STATE_EXPECT=\"STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE DELIVERED and OPEN pending owner live review (D-380)\"")
	# D-396: and a runner still carrying the D-392-era pin is refused too.
	var planted392 := imp.replace("STATE_EXPECT=\"STATE: %s\"" % ProdConfig.STATE,
		"STATE_EXPECT=\"STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN pending owner live review (D-392)\"")
	# D-398: and a runner still carrying the D-396-era pin is refused too.
	var planted396 := imp.replace("STATE_EXPECT=\"STATE: %s\"" % ProdConfig.STATE,
		"STATE_EXPECT=\"STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE DELIVERED and OPEN pending owner live review (D-396)\"")
	# D-400: and a runner still carrying the D-398-era pin is refused too.
	var planted398 := imp.replace("STATE_EXPECT=\"STATE: %s\"" % ProdConfig.STATE,
		"STATE_EXPECT=\"STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE DELIVERED and OPEN pending owner live review (D-398)\"")
	# D-402: and a runner still carrying the D-400-era pin is refused too.
	var planted400 := imp.replace("STATE_EXPECT=\"STATE: %s\"" % ProdConfig.STATE,
		"STATE_EXPECT=\"STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN pending owner live review (D-400)\"")
	# D-404: and a runner still carrying the D-402-era pin is refused too.
	var planted402 := imp.replace("STATE_EXPECT=\"STATE: %s\"" % ProdConfig.STATE,
		"STATE_EXPECT=\"STATE: FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE ACCEPTED and CLOSED (D-376) · D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) · HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394) · KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397) · MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399) · PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401) · CINDER FIELD STAGE DELIVERED and OPEN pending owner live review (D-402)\"")
	var guard := not _runner_pins_current(planted) and not _runner_pins_current(planted380) \
		and not _runner_pins_current(planted392) and not _runner_pins_current(planted396) \
		and not _runner_pins_current(planted398) and not _runner_pins_current(planted400) \
		and not _runner_pins_current(planted402)
	var ok := imp_current and fnd_current and aln_current and exact_imp and exact_fnd \
		and refusal and absence and counts and foundation_untouched and guard
	_note("A03_the_four_truthfulness_pins_moved_together_and_none_was_weakened",
		"RE-SCOPED UNDER D-402 AND D-404 (first acts): S14/S16/S17 carry the CURRENT nine-fact line and strings and none of the seven superseded ones=%s · R08 likewise=%s · the D-380 runner pins the same line=%s | both state pins are still EXACT-LINE=%s/%s, both refusal proofs remain=%s and both carry the D-375-line, the D-380-line, (D-402) the D-400-line AND (D-404) the D-402-line absence checks=%s | 85/11 and 101/16 pinned, and 85/11 in the foundation runner=%s | the foundation suite still owes %d checks, still records M-04 DISCHARGED, was NOT edited for D-380, under D-381 was edited ONLY inside F69 (%d D-381 mention(s) in F69, %d outside), under D-382 ONLY inside F57 (%d D-382 mention(s) in F57, %d outside), under D-392 ONLY inside F04 (%d D-392 mention(s) in F04, %d outside), under D-396 ONLY inside F69 and the declared fixture in _initialize (%d in F69, %d in _initialize, %d outside) and under D-398 ONLY inside F69 (%d in F69, %d outside)=%s | the audit REFUSES a planted runner still carrying the D-375 pin, the D-380 pin, (D-396) the D-392-era pin, (D-398) the D-396-era pin, (D-400) the D-398-era pin, (D-402) the D-400-era pin or (D-404) the D-402-era pin=%s. RE-PINNED UNDER D-392, D-396, D-398, D-400 AND D-402 (first acts): S14, S16, S17, R08 AND T09/T11/T12/T13/T20 MOVED TOGETHER; NO GUARD WAS WEAKENED."
		% [str(imp_current), str(fnd_current), str(aln_current), str(exact_imp), str(exact_fnd),
		   str(refusal), str(absence), str(counts), f_owed, d381_in_f69, d381_outside,
		   d382_in_f57, d382_outside, d392_in_f04, d392_outside, d396_in_f69, d396_in_init, d396_outside,
		   d398_in_f69, d398_outside, str(foundation_untouched), str(guard)])
	_reached("A03_the_four_truthfulness_pins_moved_together_and_none_was_weakened")
	return ok

# ============================================================================
# B. OD-01 — A NEWLY LEARNED IMPRINT STARTS AT MASTERED RANK 1 WITH 0 XP
# ============================================================================

func chk_A04_a_newly_learned_imprint_starts_at_rank_1_with_0_xp() -> bool:
	# EVERY diagnostic Imprint, learned into an EMPTY library.
	var source := _scratch_library()
	var fresh := ImprintLibrary.new()
	var bad: Array[String] = []
	var kinds := {}
	for id in source.ids():
		var imp := source.get_imprint(String(id))
		var learned := fresh.learn(imp)
		var rec := fresh.acquisition_record(String(id))
		if not learned or fresh.mastered(String(id)) != 1 or not is_equal_approx(fresh.xp(String(id)), 0.0) \
				or fresh.selectable_ranks(String(id)) != [1] \
				or int(rec.get("rank", -1)) != 1 or not is_equal_approx(float(rec.get("xp", -1.0)), 0.0) \
				or not is_equal_approx(fresh.total_progress_units(String(id)), 0.0) \
				or not is_equal_approx(fresh.xp_to_next(String(id)), ImprintLibrary.xp_to_advance_from(1)):
			bad.append(String(id))
		kinds[imp.kind] = true
	var all_kinds := kinds.size() == 3
	# A BRAND-NEW fixture Imprint -- not diagnostic content, never in the live
	# library -- behaves the same.
	var fixture := Imprint.new("SKILL_IMPRINT_DIAG_TEST_FIXTURE_NEW", "Test Fixture", Imprint.Kind.SKILL)
	fresh.learn(fixture)
	var fixture_ok := fresh.mastered(fixture.id) == 1 and is_equal_approx(fresh.xp(fixture.id), 0.0)
	# THE LIVE LIBRARY TOO: every acquisition record says 1 / 0 XP, even though
	# the seeded ranks are higher.
	var live := skills.library
	var live_bad: Array[String] = []
	for id in live.ids():
		var r := live.acquisition_record(String(id))
		if int(r.get("rank", -1)) != 1 or not is_equal_approx(float(r.get("xp", -1.0)), 0.0):
			live_bad.append(String(id))
	# RE-SCOPED UNDER D-392, one for one: 14 -> 14 + 1 = 15. The live library now
	# also holds the canonical Splinter Shot -- learned through the same learn(),
	# at rank 1 / 0 XP, and covered by the loop above like every other record.
	# Until D-392 this pinned 14 -- true when written.
	# RE-SCOPED AGAIN UNDER D-396, one for one: 15 -> 15 + 1 = 16 -- the live
	# library also holds the canonical Kindred Hounds, learned through the same
	# learn() at rank 1 / 0 XP and covered by the loop above.
	# RE-SCOPED UNDER D-402, one for one: 16 + 1 = 17 -- the live library also
	# holds the canonical Cinder Field, learned through the same learn() at
	# rank 1 / 0 XP and covered by the loop above. `fresh` is built from the
	# DIAGNOSTIC content alone and stays 15.
	var fixture_not_live := not live.knows(fixture.id) and live.count() == 17 \
		and live.knows(HuntressContent.SKILL_SPLINTER_SHOT) and live.knows(HoundContent.SKILL_KINDRED_HOUNDS) \
		and live.knows(CinderContent.SKILL_CINDER_FIELD)
	var ok := bad.is_empty() and all_kinds and fixture_ok and live_bad.is_empty() \
		and fixture_not_live and fresh.count() == 15
	_note("A04_a_newly_learned_imprint_starts_at_rank_1_with_0_xp",
		"all %d diagnostic Imprints, learned into an EMPTY library, start at Mastered Rank 1 with 0 XP, ONLY rank 1 selectable, 0 progress units and %.0f XP to rank 2 (offenders: %s) — all three Imprint types covered=%s | a brand-new fixture Imprint does the same=%s | in the LIVE library all 14 acquisition records say rank 1 / 0 XP (offenders: %s) and the fixture never entered it=%s. D-378 OD-01."
		% [source.count(), ImprintLibrary.xp_to_advance_from(1), str(bad), str(all_kinds),
		   str(fixture_ok), str(live_bad), str(fixture_not_live)])
	_reached("A04_a_newly_learned_imprint_starts_at_rank_1_with_0_xp")
	return ok

func chk_A05_no_acquisition_rank_floor_is_representable_and_seeding_is_declared() -> bool:
	var lib_path := "res://scripts/imprint/imprint_library.gd"
	# STRUCTURAL: `learn()` takes exactly ONE argument -- a floor cannot be passed.
	var learn_arity := _arity(lib_path, "learn")
	# THE ARITY READER MUST BE ABLE TO SEE A SECOND ARGUMENT: it does, on a
	# method that has one.
	var reader_works := _arity(lib_path, "set_mastered_at_least") == 2 \
		and _arity(lib_path, "diagnostic_seed_prior_mastery") == 2
	# The content never calls learn() with a second argument.
	var content := _read_text("res://scripts/imprint/diag_imprint_content.gd")
	var re := RegEx.new()
	re.compile("lib\\.learn\\([^)]*,")
	var two_arg_calls := re.search_all(_code_only(content)).size()
	# PROVED ABLE TO FAIL on a planted CODE line -- and PROVED to ignore a
	# history comment quoting the removed call.
	var planted_hits := re.search_all(_code_only("\tlib.learn(imp, 20)\n")).size()
	var comment_ignored := re.search_all(_code_only("\t# lib.learn(imp, 20) was the D-375 call\n")).size() == 0
	# THE SEEDING IS DECLARED, COUNTED, AFTER LEARNING, AND EQUAL TO THE TABLE.
	var live := skills.library
	var seeds_ok := live.diagnostic_seeds == 14
	var wrong: Array[String] = []
	for id in DiagImprintContent.STARTING_MASTERY:
		if live.seeded_rank(String(id)) != int(DiagImprintContent.STARTING_MASTERY[id]) \
				or live.mastered(String(id)) < live.seeded_rank(String(id)):
			wrong.append(String(id))
	# Seeding refuses an unknown Imprint and can never LOWER a rank.
	var scratch := _scratch_library()
	var unknown_refused := not scratch.diagnostic_seed_prior_mastery("NOT_AN_IMPRINT", 5)
	var before := scratch.mastered(DiagImprintContent.SKILL_STORM)
	scratch.diagnostic_seed_prior_mastery(DiagImprintContent.SKILL_STORM, 2)
	var never_lowers := scratch.mastered(DiagImprintContent.SKILL_STORM) == before
	# And the viewer is told.
	var lib_text := _page_text("IMPRINT LIBRARY")
	var told := lib_text.find("LEARNED at Mastered Rank 1 / 0 XP") >= 0 \
		and lib_text.find("DECLARED DIAGNOSTIC SEEDING (14 seeds)") >= 0
	var ok := learn_arity == 1 and reader_works and two_arg_calls == 0 and planted_hits == 1 \
		and comment_ignored and seeds_ok and wrong.is_empty() and unknown_refused and never_lowers and told
	_note("A05_no_acquisition_rank_floor_is_representable_and_seeding_is_declared",
		"learn() takes %d argument — a floor CANNOT be passed=%s (the arity reader sees 2 on set_mastered_at_least and on the seeding call=%s) | the diagnostic content makes %d two-argument learn() calls IN CODE (the pattern catches a planted code line: %d, and ignores a history comment quoting the old call=%s) | %d DECLARED DIAGNOSTIC SEEDS, each equal to STARTING_MASTERY (mismatches: %s) | seeding refuses an unknown Imprint=%s and never lowers a rank=%s | the IMPRINT LIBRARY page tells the viewer=%s. From D-375 until D-380 learn() accepted a rank; D-378 OD-01 removed it."
		% [learn_arity, str(learn_arity == 1), str(reader_works), two_arg_calls, planted_hits, str(comment_ignored),
		   live.diagnostic_seeds, str(wrong), str(unknown_refused), str(never_lowers), str(told)])
	_reached("A05_no_acquisition_rank_floor_is_representable_and_seeding_is_declared")
	return ok

func chk_A06_accelerated_catch_up_remains_bounded_for_a_new_imprint() -> bool:
	# OD-01: "Accelerated catch-up remains part of the architecture." A freshly
	# learned Imprint on an ESTABLISHED character (progression rank 16) catches
	# up faster -- boundedly -- than one on a character level with it.
	var source := _scratch_library()
	var C := DiagImprintContent
	var ahead := ImprintLibrary.new()
	ahead.character_progress_rank = 16
	ahead.learn(source.get_imprint(C.AUG_FORK))
	var level := ImprintLibrary.new()
	level.character_progress_rank = 1
	level.learn(source.get_imprint(C.AUG_FORK))
	var m_ahead := ahead.catchup_multiplier(C.AUG_FORK)
	var m_level := level.catchup_multiplier(C.AUG_FORK)
	var bounded := is_equal_approx(m_ahead, ImprintConfig.CATCHUP_MULTIPLIER_MAX) \
		and is_equal_approx(m_level, 1.0)
	# THE AWARD FIRES FIRST, then the difference is measured.
	var ra := ahead.award_combat_progress(60.0, [C.AUG_FORK])
	var rl := level.award_combat_progress(60.0, [C.AUG_FORK])
	var fired := ahead.awards == 1 and level.awards == 1 \
		and (ra["rows"] as Array).size() == 1 and (rl["rows"] as Array).size() == 1
	var gained_ahead := ahead.total_progress_units(C.AUG_FORK)
	var gained_level := level.total_progress_units(C.AUG_FORK)
	var accelerated := is_equal_approx(gained_ahead, 60.0 * m_ahead) \
		and is_equal_approx(gained_level, 60.0) and gained_ahead > gained_level
	var ranked := ahead.mastered(C.AUG_FORK) > level.mastered(C.AUG_FORK)
	var unchanged := is_equal_approx(ImprintConfig.CATCHUP_PER_RANK_BEHIND, 0.5) \
		and is_equal_approx(ImprintConfig.CATCHUP_MULTIPLIER_MAX, 4.0)
	var ok := bounded and fired and accelerated and ranked and unchanged
	_note("A06_accelerated_catch_up_remains_bounded_for_a_new_imprint",
		"a freshly learned Imprint on a character at progression rank 16 gets %.2fx — the CEILING — and on a level character %.2fx=%s | ONE award of 60 FIRED on each=%s and granted %.1f against %.1f=%s, leaving Mastered Rank %d against %d=%s | the catch-up constants are UNCHANGED at 0.5 per rank and a 4.0x ceiling=%s. The catch-up CURVE stays PROVISIONAL."
		% [m_ahead, m_level, str(bounded), str(fired), gained_ahead, gained_level,
		   str(accelerated), ahead.mastered(C.AUG_FORK), level.mastered(C.AUG_FORK),
		   str(ranked), str(unchanged)])
	_reached("A06_accelerated_catch_up_remains_bounded_for_a_new_imprint")
	return ok

# ============================================================================
# C. OD-05 — REGENERATION FROM UNRESERVED MAXIMUM MANA
# ============================================================================

func chk_A07_regeneration_is_computed_from_unreserved_maximum_mana() -> bool:
	# THE OWNER'S OWN WORKED EXAMPLE, against the RULE (the rate is a parameter):
	# 100 maximum, 20 reserved, 80 unreserved, 2 % -> 1.6 Mana/s.
	var worked := is_equal_approx(ResourcePool.regen_rate_of(100.0 - 20.0, 0.02), 1.6)
	# The prototype's pool, 20 % reserved -- canon's own 500 / 20 % example.
	var p := ResourcePool.new()
	p.set_reservation(100.0, 0.0)
	var expect := ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S * 400.0
	var rate_right := is_equal_approx(p.regen_per_second(), expect) \
		and is_equal_approx(p.unreserved_maximum(), 400.0)
	# NEVER FROM CURRENT MANA: the same gain per second from EMPTY and from HIGH.
	p.mana_current = 0.0
	p.regenerate(1.0)
	var gain_empty := p.mana_current
	p.mana_current = 350.0
	p.regenerate(1.0)
	var gain_high := p.mana_current - 350.0
	var independent := is_equal_approx(gain_empty, expect) and is_equal_approx(gain_high, expect)
	# THE NEGATIVE CONTROL: a CURRENT-based rate would have given NOTHING from
	# empty -- so this check can tell the two rules apart, and would fail on it.
	var current_based_from_empty := ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S * 0.0
	var distinguishes := not is_equal_approx(current_based_from_empty, gain_empty)
	# NEVER PAST THE UNRESERVED POOL.
	p.mana_current = 399.0
	p.regenerate(5.0)
	var capped := is_equal_approx(p.mana_current, 400.0)
	# NOTHING RESERVED: EXACTLY the accepted prototype's former 22.0 Mana/s.
	var q := ResourcePool.new()
	var unreserved_same := is_equal_approx(q.regen_per_second(), 22.0)
	# The flat constant is gone, and regenerate() reads the unreserved basis.
	var consts := _config_constants()
	var flat_gone := not consts.has("MANA_REGEN_PER_S")
	var src := _read_text("res://scripts/imprint/resource_pool.gd")
	var reads_basis := src.find("MANA_REGEN_PER_S") < 0 \
		and src.find("regen_rate_of(unreserved_maximum()") >= 0
	var ok := worked and rate_right and independent and distinguishes and capped \
		and unreserved_same and flat_gone and reads_basis
	_note("A07_regeneration_is_computed_from_unreserved_maximum_mana",
		"the owner's worked example (100 max, 20 reserved, 2 %%) gives 1.6 Mana/s=%s | 20 %% reserved of 500: %.3f/s = %.1f%% x 400 unreserved=%s | the SAME %.3f gained per second from EMPTY and %.3f from 350 — independent of current Mana=%s, where a current-based rule would have given %.3f from empty, so the check can tell the two apart=%s | never past the unreserved pool=%s | with NOTHING reserved the rate is exactly the prototype's former 22.00/s=%s | MANA_REGEN_PER_S is gone=%s and regenerate() reads the unreserved basis=%s. D-378 OD-05; THE RATE IS PROVISIONAL."
		% [str(worked), p.regen_per_second(), ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S * 100.0,
		   str(rate_right), gain_empty, gain_high, str(independent), current_based_from_empty,
		   str(distinguishes), str(capped), str(unreserved_same), str(flat_gone), str(reads_basis)])
	_reached("A07_regeneration_is_computed_from_unreserved_maximum_mana")
	return ok

func chk_A08_the_live_loadout_regenerates_from_its_own_unreserved_pool() -> bool:
	# THROUGH THE RUNTIME, over real physics frames -- the wiring from
	# SkillRuntime.step() to the pool, not the pool on its own.
	var tps := float(Engine.physics_ticks_per_second)
	var n := 30
	skills.set_safe_state_override(true)
	# STATE A — the aura reserves MANA.
	skills.set_life_tithe(false)
	skills.loadout.revalidate(skills.pool)
	await _phys(1)
	var reserved_a := skills.pool.mana_reserved
	var rate_a := skills.pool.regen_per_second()
	var expect_a := ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S * (ImprintConfig.MANA_MAX - reserved_a)
	skills.pool.mana_current = 0.0
	await _phys(n)
	var gain_a := skills.pool.mana_current
	# STATE B — converted to LIFE; the whole Mana pool is unreserved.
	skills.set_life_tithe(true)
	await _phys(1)
	var reserved_b := skills.pool.mana_reserved
	var rate_b := skills.pool.regen_per_second()
	skills.pool.mana_current = 0.0
	await _phys(n)
	var gain_b := skills.pool.mana_current
	var fired := reserved_a > 0.0 and is_equal_approx(reserved_b, 0.0)
	var a_right := is_equal_approx(rate_a, expect_a) and absf(gain_a - rate_a * float(n) / tps) <= 0.01
	var b_right := is_equal_approx(rate_b, ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S * ImprintConfig.MANA_MAX) \
		and absf(gain_b - rate_b * float(n) / tps) <= 0.01
	# PROPORTIONAL TO THE UNRESERVED MAXIMUM, measured rather than computed.
	var ratio_measured := gain_a / maxf(0.0001, gain_b)
	var ratio_expected := (ImprintConfig.MANA_MAX - reserved_a) / ImprintConfig.MANA_MAX
	var proportional := absf(ratio_measured - ratio_expected) <= 0.002
	# The viewer sees the basis.
	panel.refresh()
	var shown := _page_text("OVERVIEW").find("x UNRESERVED maximum") >= 0 \
		and _page_text("OVERVIEW").find("never current Mana") >= 0
	# RESTORE the build under review.
	skills.set_life_tithe(false)
	skills.loadout.revalidate(skills.pool)
	skills.pool.refill()
	var ok := fired and a_right and b_right and proportional and shown
	_note("A08_the_live_loadout_regenerates_from_its_own_unreserved_pool",
		"THE AURA ON MANA: %.1f reserved, the runtime regenerated %.3f over %d physics frames at %.3f/s = %.1f%% x %.1f unreserved=%s | CONVERTED TO LIFE: %.1f Mana reserved=%s, %.3f regenerated at %.3f/s=%s | the measured ratio %.4f equals the unreserved ratio %.4f=%s | the overview shows the basis=%s. Reservation now costs regeneration as well as buffer — the pressure D-378 OD-05 calls INTENTIONAL."
		% [reserved_a, gain_a, n, rate_a, ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S * 100.0,
		   ImprintConfig.MANA_MAX - reserved_a, str(a_right), reserved_b, str(fired), gain_b, rate_b,
		   str(b_right), ratio_measured, ratio_expected, str(proportional), str(shown)])
	_reached("A08_the_live_loadout_regenerates_from_its_own_unreserved_pool")
	return ok

# ============================================================================
# D. OD-06 — PERCENTAGE RESERVATION, PROPORTIONAL CONVERSION, NO FLAT TITHE
# ============================================================================

func chk_A09_persistent_reservation_is_percentage_only() -> bool:
	var lib := _scratch_library()
	var C := DiagImprintContent
	var rows: Array[String] = []
	var bad: Array[String] = []
	var states := 0
	for aura_rank in [1, 5, 10]:
		for conv_rank in [0, 1, 4]:
			var c := SkillConfiguration.new("T_pct", lib)
			c.set_skill(C.SKILL_AURA)
			c.set_effective_rank(C.SKILL_AURA, int(aura_rank))
			if int(conv_rank) > 0:
				c.install(C.AUG_TITHE)
				c.set_effective_rank(C.AUG_TITHE, int(conv_rank))
			var r := c.resolve()
			var which := String(r["reserve_resource"])
			var maxv := ImprintConfig.MANA_MAX if which == "mana" else ImprintConfig.LIFE_MAX
			var frac := float(r["reserve_fraction"])
			var amount := float(r["reserve_amount"])
			states += 1
			if not is_equal_approx(amount, maxv * frac) or frac <= 0.0 or frac >= 1.0:
				bad.append("aura %d / conversion %d: %s %.4f of %.1f = %.2f" % [aura_rank, conv_rank, which, frac, maxv, amount])
			rows.append("%d/%d %s %.1f%%" % [aura_rank, conv_rank, which, frac * 100.0])
	# THE LOADOUT'S SUMS ARE SUMS OF FRACTIONS OF A MAXIMUM.
	var lo := skills.loadout
	var sum := lo.reservation()
	var expect_mana := 0.0
	for row in sum["rows"]:
		if String(row["resource"]) == "mana":
			expect_mana += ImprintConfig.MANA_MAX * float(row["fraction"])
	var sums_right := is_equal_approx(float(sum["mana"]), expect_mana)
	# NO FLAT-RESERVATION CONSTANT EXISTS -- and the scan is PROVED able to see one.
	var consts := _config_constants()
	var flat_keys := _keys_with_all(consts, ["RESERVE", "FLAT"]) + _keys_with_all(consts, ["RESERVE", "AMOUNT"]) \
		+ _keys_with_all(consts, ["TITHE"])
	var guard := _keys_with_all({"AURA_RESERVE_FLAT_MANA": 40.0}, ["RESERVE", "FLAT"]).size() == 1
	var ok := bad.is_empty() and states == 9 and sums_right and flat_keys.is_empty() and guard
	_note("A09_persistent_reservation_is_percentage_only",
		"%d reservation states (aura rank 1/5/10 x conversion off/rank 1/rank 4) each reserve EXACTLY fraction x maximum of ONE resource: %s (offenders: %s) | the live loadout's Mana sum is a sum of fractions of 500=%s | NO flat-reservation or tithe constant exists (%s), and the scan is PROVED able to see a planted one=%s. D-378 OD-06: ALL Persistent reservation is a percentage."
		% [states, str(rows), str(bad), str(sums_right), str(flat_keys), str(guard)])
	_reached("A09_persistent_reservation_is_percentage_only")
	return ok

func chk_A10_mana_to_life_conversion_is_proportional() -> bool:
	var lib := _scratch_library()
	var C := DiagImprintContent
	var cases: Array[String] = []
	var exact := true
	var life := {}
	var basis := {}
	for aura_rank in [1, 10]:
		for conv_rank in [1, 4]:
			var c := SkillConfiguration.new("T_prop", lib)
			c.set_skill(C.SKILL_AURA)
			c.set_effective_rank(C.SKILL_AURA, int(aura_rank))
			c.install(C.AUG_TITHE)
			c.set_effective_rank(C.AUG_TITHE, int(conv_rank))
			var r := c.resolve()
			var mana_basis := float(r["reserve_fraction_mana_basis"])
			var ratio := float(r["conversion_ratio"])
			var expect_ratio := ImprintConfig.LIFE_CONVERSION_RATIO_AT_RANK_1 \
				* (1.0 + ImprintConfig.LIFE_CONVERSION_RATIO_PER_RANK * float(int(conv_rank) - 1))
			var expect_basis := ImprintConfig.AURA_RESERVE_FRACTION_AT_RANK_1 \
				+ ImprintConfig.AURA_RESERVE_FRACTION_PER_RANK * float(int(aura_rank) - 1)
			var lf := float(r["reserve_fraction"])
			if String(r["reserve_resource"]) != "life" or not is_equal_approx(ratio, expect_ratio) \
					or not is_equal_approx(mana_basis, expect_basis) \
					or not is_equal_approx(lf, mana_basis * ratio) \
					or not is_equal_approx(float(r["reserve_amount"]), ImprintConfig.LIFE_MAX * lf):
				exact = false
			life["%d/%d" % [aura_rank, conv_rank]] = lf
			basis[aura_rank] = mana_basis
			cases.append("aura %d x conversion %d: %.2f%% Mana basis x %.4f = %.2f%% of Life (%.1f)"
				% [aura_rank, conv_rank, mana_basis * 100.0, ratio, lf * 100.0, lf * ImprintConfig.LIFE_MAX])
	# PROPORTIONAL: a bigger effect costs proportionally more Life.
	var scale_life := float(life["10/1"]) / float(life["1/1"])
	var scale_mana := float(basis[10]) / float(basis[1])
	var proportional := is_equal_approx(scale_life, scale_mana) and scale_life > 1.0
	# The Imprint's own rank makes the conversion more efficient.
	var improves := float(life["10/4"]) < float(life["10/1"])
	# The live figures the owner will see.
	var live := skills.library.mastered(C.AUG_TITHE)
	var live_ratio := SkillConfiguration.conversion_ratio_at(live)
	var ok := exact and proportional and improves and cases.size() == 4
	_note("A10_mana_to_life_conversion_is_proportional",
		"%s — every case EXACT (resource, ratio, basis, fraction, amount)=%s | raising the aura from rank 1 to 10 scales its Mana basis x%.4f and its Life reservation x%.4f — PROPORTIONAL=%s | the conversion Imprint's own rank lowers the cost=%s | live: conversion rank %d, ratio %.4f. D-378 OD-06; the ratio is PROVISIONAL and is NOT the ~2x candidate."
		% [str(cases), str(exact), scale_mana, scale_life, str(proportional), str(improves),
		   live, live_ratio])
	_reached("A10_mana_to_life_conversion_is_proportional")
	return ok

func chk_A11_the_flat_life_tithe_is_gone_and_exactly_one_resource_is_reserved() -> bool:
	var consts := _config_constants()
	var constants_gone := not consts.has("LIFE_TITHE_FRACTION_AT_RANK_1") \
		and not consts.has("LIFE_TITHE_FRACTION_PER_RANK")
	# THE FLAT RULE IS NOT IN EFFECT: under it, the aura's rank could not move
	# Life at all; now it does. And the old flat figure differs from the live one.
	var lib := _scratch_library()
	var C := DiagImprintContent
	var a := SkillConfiguration.new("T_flat_a", lib)
	a.set_skill(C.SKILL_AURA)
	a.set_effective_rank(C.SKILL_AURA, 1)
	a.install(C.AUG_TITHE)
	var b := SkillConfiguration.new("T_flat_b", lib)
	b.set_skill(C.SKILL_AURA)
	b.install(C.AUG_TITHE)
	var moves_with_effect := not is_equal_approx(float(a.resolve()["reserve_amount"]),
		float(b.resolve()["reserve_amount"]))
	var conv_rank := lib.mastered(C.AUG_TITHE)
	var old_flat_life := ImprintConfig.LIFE_MAX * (0.26 - 0.004 * float(conv_rank - 1))
	var live_life := float(b.resolve()["reserve_amount"])
	var differs := absf(old_flat_life - live_life) > 1.0
	# EXACTLY ONE RESOURCE, LIVE, IN BOTH STATES -- the action fires first.
	skills.set_safe_state_override(true)
	var r1 := skills.set_life_tithe(true)
	var life_state := bool(r1["ok"]) and skills.pool.life_reserved > 0.0 \
		and is_equal_approx(skills.pool.mana_reserved, 0.0) and not skills.pool.reserves_both()
	var r2 := skills.set_life_tithe(false)
	var mana_state := bool(r2["ok"]) and skills.pool.mana_reserved > 0.0 \
		and is_equal_approx(skills.pool.life_reserved, 0.0) and not skills.pool.reserves_both()
	skills.loadout.revalidate(skills.pool)
	skills.pool.refill()
	# The name changed with the rule; the viewer never reads "Life Tithe".
	var named := (skills.library.get_imprint(C.AUG_TITHE) as Imprint).display_name == "Life Conversion"
	var text := _all_pages_text()
	var no_tithe_text := text.find("Life Tithe") < 0 and text.findn("tithe is the DEARER") < 0
	var ok := constants_gone and moves_with_effect and differs and life_state and mana_state \
		and named and no_tithe_text
	_note("A11_the_flat_life_tithe_is_gone_and_exactly_one_resource_is_reserved",
		"both LIFE_TITHE constants are GONE=%s | the Life cost now MOVES with the effect it converts (aura rank 1: %.1f, rank %d: %.1f)=%s, where the flat rule could not | at conversion rank %d the old flat rule would reserve %.1f Life and the live rule reserves %.1f=%s | LIVE, converted: Life only, Mana EXACTLY 0=%s; restored: Mana only, Life EXACTLY 0=%s | the modifier is displayed 'Life Conversion'=%s and no page shows 'Life Tithe' or the old tithe text=%s. D-378 OD-06: NO FLAT LIFE TITHE."
		% [str(constants_gone), float(a.resolve()["reserve_amount"]), lib.mastered(C.SKILL_AURA),
		   live_life, str(moves_with_effect), conv_rank, old_flat_life, live_life, str(differs),
		   str(life_state), str(mana_state), str(named), str(no_tithe_text)])
	_reached("A11_the_flat_life_tithe_is_gone_and_exactly_one_resource_is_reserved")
	return ok

# ============================================================================
# E. OD-09 — UP TO EIGHT EQUIPPED ACTIVE CONFIGURATIONS, ONE PER BINDING
# ============================================================================

func chk_A12_up_to_eight_active_configurations_one_per_binding() -> bool:
	var lib := _scratch_library()
	var cfgs := _light_eight(lib)
	var valid := 0
	for cid in cfgs:
		if (cfgs[cid] as SkillConfiguration).is_valid():
			valid += 1
	var lo := ImprintLoadout.new(lib, cfgs)
	lo.gear_bonus_active = true
	var refused_before := lo.binds_refused
	var bound := _bind_all(lo, cfgs)
	var eight := bound == 8 and lo.equipped_active_count() == 8 and lo.empty_binding_count() == 0 \
		and lo.binds_refused == refused_before
	var distinct := {}
	for b in lo.bindings:
		distinct[b] = true
	var one_per_binding := distinct.size() == 8
	# A NINTH BINDING DOES NOT EXIST.
	var ninth := lo.bind(8, "L_bow")
	var ninth_refused: bool = not ninth["ok"] and String(ninth["reason"]).findn("does not exist") >= 0
	# ALL EIGHT STAY ACTIVE: the lightly modified set fits the budget.
	var r := lo.revalidate(ResourcePool.new())
	var all_active := (r["deactivated"] as Dictionary).is_empty() \
		and lo.active_configuration_ids().size() == 8
	# ONE PER BINDING: re-binding a binding REPLACES what it held.
	lo.bind(0, "L_beasts_pack")
	var replaced := lo.bindings[0] == "L_beasts_pack" and lo.binding_count() == 8
	# THE SIX IS GONE FROM THE SOURCE AS WELL AS THE BEHAVIOUR.
	var src := _code_only(_read_text("res://scripts/imprint/imprint_loadout.gd"))
	var no_cap_code := src.find("CANDIDATE_ACTIVE") < 0 and not _config_constants().has("CANDIDATE_ACTIVE_CONFIGURATIONS") \
		and _code_only("\tif would > ImprintConfig.CANDIDATE_ACTIVE_CONFIGURATIONS:\n").find("CANDIDATE_ACTIVE") >= 0
	# And the panel's live trial says the same.
	var trial := skills.alignment_trials()
	var trial_ok := String(trial[0][1]) == "8 OF 8 BOUND, ALL ACTIVE"
	var ok := valid == 8 and eight and one_per_binding and ninth_refused and all_active \
		and replaced and no_cap_code and trial_ok
	_note("A12_up_to_eight_active_configurations_one_per_binding",
		"eight DISTINCT valid Configurations (%d valid) bound to the eight bindings, the seventh and eighth included, with NO refusal=%s — one per binding=%s | a NINTH binding does not exist=%s ('%s') | revalidated against a %d budget (%d used) ALL EIGHT stay active=%s | re-binding a binding replaces what it held=%s | no six-cap CODE or constant remains, and the code scan sees a planted cap line=%s | the panel's live trial reads '%s'=%s. D-378 OD-09: a CURRENT WORKING BASELINE, not a lock."
		% [valid, str(eight), str(one_per_binding), str(ninth_refused), String(ninth["reason"]),
		   int(r["capacity_total"]), int(r["capacity_used"]), str(all_active), str(replaced),
		   str(no_cap_code), String(trial[0][1]), str(trial_ok)])
	_reached("A12_up_to_eight_active_configurations_one_per_binding")
	return ok

func chk_A13_empty_bindings_stay_valid_and_bindings_stay_distinct() -> bool:
	# LIVE: five equipped, three empty -- and the loadout is VALID.
	# RE-SCOPED UNDER D-392, one for one: 5 + 1 = 6 equipped, 3 - 1 = 2 empty --
	# Splinter Shot takes binding 6. The binding count is STILL 8, the loadout is
	# STILL valid, and bindings 7 and 8 are STILL empty and valid.
	var lo := skills.loadout
	skills.set_gear_bonus(true)
	var live_r := lo.revalidate(skills.pool)
	var live_ok := lo.binding_count() == 8 and lo.equipped_active_count() == 6 \
		and lo.empty_binding_count() == 2 and bool(live_r["valid"]) \
		and lo.bindings[HuntressContent.BINDING_INDEX] == HuntressContent.CFG_SPLINTER_SHOT \
		and lo.bindings[6] == "" and lo.bindings[7] == ""
	# SCRATCH: 0, 8 and 6 equipped -- the binding count NEVER changes.
	var lib := _scratch_library()
	var cfgs := _light_eight(lib)
	var s := ImprintLoadout.new(lib, cfgs)
	var zero := s.binding_count() == 8 and s.equipped_active_count() == 0 and s.empty_binding_count() == 8
	_bind_all(s, cfgs)
	var full := s.binding_count() == 8 and s.equipped_active_count() == 8 and s.empty_binding_count() == 0
	s.unbind(2)
	s.unbind(5)
	var partial := s.binding_count() == 8 and s.equipped_active_count() == 6 and s.empty_binding_count() == 2
	var still_valid := bool(s.revalidate(ResourcePool.new())["valid"])
	# BINDINGS and EQUIPPED CONFIGURATIONS are still two different things, and
	# the panel says so.
	var says := _page_text("OVERVIEW").find("BINDINGS AND EQUIPPED CONFIGURATIONS ARE DIFFERENT THINGS") >= 0 \
		and _page_text("OVERVIEW").find("empty is valid") >= 0
	var ok := live_ok and zero and full and partial and still_valid and says
	_note("A13_empty_bindings_stay_valid_and_bindings_stay_distinct",
		"LIVE (re-scoped under D-392): 8 bindings, 6 equipped (Splinter Shot on binding 6), 2 EMPTY (7 and 8), and the loadout is VALID=%s | SCRATCH: 8 bindings with 0 equipped=%s, with 8=%s, and with 6 after two unbinds=%s, still valid=%s — THE BINDING COUNT NEVER MOVES | the overview names the two concepts apart and says empty is valid=%s. The limit coincides with the binding count; the concepts are NOT merged."
		% [str(live_ok), str(zero), str(full), str(partial), str(still_valid), str(says)])
	_reached("A13_empty_bindings_stay_valid_and_bindings_stay_distinct")
	return ok

func chk_A14_global_capacity_limits_how_deeply_the_loadout_is_modified() -> bool:
	var lib := _scratch_library()
	var heavy := _heavy_eight(lib)
	var lo := ImprintLoadout.new(lib, heavy)
	lo.gear_bonus_active = true
	var bound := _bind_all(lo, heavy)
	var demanded := lo.capacity_demanded()
	var r := lo.revalidate(ResourcePool.new())
	var dead: Dictionary = r["deactivated"]
	var over := demanded > int(r["capacity_total"])
	var limited := not dead.is_empty() and int(r["capacity_used"]) <= int(r["capacity_total"])
	var explained := true
	for k in dead:
		var why := String(dead[k])
		if why.findn("OVER CAPACITY") < 0 or why.find(str(demanded)) < 0:
			explained = false
	# FROM THE LAST BINDING BACKWARDS, so the first binding survives.
	var first_survives := not dead.has(lo.bindings[0])
	var last_first := dead.has(lo.bindings[7])
	# THE CONTRAST: the SAME COUNT, lightly modified, fits -- so the limit is the
	# budget and not a number of Configurations.
	var light := _light_eight(lib)
	var lo2 := ImprintLoadout.new(lib, light)
	lo2.gear_bonus_active = true
	_bind_all(lo2, light)
	var fits := (lo2.revalidate(ResourcePool.new())["deactivated"] as Dictionary).is_empty()
	# And removing the diagnostic gear bonus tightens it further.
	lo.gear_bonus_active = false
	var r_off := lo.revalidate(ResourcePool.new())
	var tighter := (r_off["deactivated"] as Dictionary).size() > dead.size()
	var ok := bound == 8 and over and limited and explained and first_survives and last_first \
		and fits and tighter
	_note("A14_global_capacity_limits_how_deeply_the_loadout_is_modified",
		"eight HEAVILY modified Configurations all bound (%d) and demanded %d against a budget of %d=%s | revalidation deactivated %d, leaving %d used=%s, every deactivation carrying OVER CAPACITY and the %d demanded=%s, walking from the LAST binding (last gone=%s, first kept=%s) | the SAME COUNT lightly modified FITS=%s | without the diagnostic gear bonus %d are deactivated=%s. D-378 OD-09: global Capacity limits how deeply the loadout is modified."
		% [bound, demanded, int(r["capacity_total"]), str(over), dead.size(), int(r["capacity_used"]),
		   str(limited), demanded, str(explained), str(last_first), str(first_survives), str(fits),
		   (r_off["deactivated"] as Dictionary).size(), str(tighter)])
	_reached("A14_global_capacity_limits_how_deeply_the_loadout_is_modified")
	return ok

# ============================================================================
# F. OD-07.2 / D-376 X-02 — NO ARBITRARY PERSISTENT SLOT CAP
# ============================================================================

func chk_A15_persistent_configurations_have_no_arbitrary_slot_cap() -> bool:
	var lib := _scratch_library()
	var C := DiagImprintContent
	var mk := func(n: int) -> ImprintLoadout:
		var cfgs := {}
		for i in n:
			var c := SkillConfiguration.new("P_%d" % i, lib)
			c.set_skill(C.SKILL_AURA)
			c.set_effective_rank(C.SKILL_AURA, 1)
			cfgs["P_%d" % i] = c
		var lo := ImprintLoadout.new(lib, cfgs)
		lo.gear_bonus_active = true
		return lo
	# FIVE rank-1 auras: 90 % of maximum Mana -- MORE than the withdrawn cap of
	# four, and ALL of them ACTIVE, because nothing natural is exceeded.
	var five: ImprintLoadout = mk.call(5)
	var accepted5 := 0
	for i in 5:
		if five.add_persistent("P_%d" % i)["ok"]:
			accepted5 += 1
	var r5 := five.revalidate(ResourcePool.new())
	var five_active := accepted5 == 5 and (r5["deactivated"] as Dictionary).is_empty() \
		and five.active_persistent_ids().size() == 5
	# SIX: 108 % -- still ACCEPTED by add_persistent, and the NATURAL limit
	# (reservation) deactivates one, with its explanation.
	var six: ImprintLoadout = mk.call(6)
	var accepted6 := 0
	for i in 6:
		if six.add_persistent("P_%d" % i)["ok"]:
			accepted6 += 1
	var r6 := six.revalidate(ResourcePool.new())
	var dead6: Dictionary = r6["deactivated"]
	var natural := accepted6 == 6 and dead6.size() == 1
	var why := ""
	for k in dead6:
		why = String(dead6[k])
	var explained := why.findn("RESERVATION UNSUPPORTABLE") >= 0 and why.findn("slot") < 0
	var supported := float((r6["reservation"] as Dictionary)["mana"]) < ImprintConfig.MANA_MAX
	var src := _code_only(_read_text("res://scripts/imprint/imprint_loadout.gd"))
	var no_cap_code := src.find("CANDIDATE_PERSISTENT") < 0 \
		and not _config_constants().has("CANDIDATE_PERSISTENT_CONFIGURATIONS")
	var trial := skills.alignment_trials()
	var trial_ok := String(trial[2][1]) == "6 OF 6 ACCEPTED, 1 DEACTIVATED BY RESERVATION"
	var ok := five_active and natural and explained and supported and no_cap_code and trial_ok
	_note("A15_persistent_configurations_have_no_arbitrary_slot_cap",
		"FIVE Persistent Configurations — one more than the withdrawn cap of four — were accepted (%d) and ALL stay ACTIVE=%s | SIX were all accepted (%d) and the NATURAL limit deactivated %d=%s with the reason '%s'=%s, leaving the reservation supportable=%s | no four-cap code or constant remains=%s | the panel's live trial reads '%s'=%s. D-079 stands (D-376 X-02); D-378 OD-07: no arbitrary Persistent slot cap."
		% [accepted5, str(five_active), accepted6, dead6.size(), str(natural), why,
		   str(explained), str(supported), str(no_cap_code), String(trial[2][1]), str(trial_ok)])
	_reached("A15_persistent_configurations_have_no_arbitrary_slot_cap")
	return ok

# ============================================================================
# G. OD-12 — PURELY BENEFICIAL AUGMENTS ARE LEGAL
# ============================================================================

func chk_A16_purely_beneficial_augments_are_legal_and_silent_ones_are_not() -> bool:
	# A TEST FIXTURE, NOT CONTENT: learned only into a SCRATCH library, and
	# asserted never to reach the live one.
	var lib := _scratch_library()
	var C := DiagImprintContent
	var pure := Imprint.new("AUGMENT_IMPRINT_DIAG_TEST_FIXTURE_PURE_BENEFIT", "Test Fixture Pure",
		Imprint.Kind.AUGMENT)
	pure.requires_tags.assign(["Projectile"])
	pure.affects.assign(["projectile count"])
	pure.tradeoff = ""
	lib.learn(pure)
	var c := SkillConfiguration.new("T_pure", lib)
	c.set_skill(C.SKILL_STORM)
	var ins := c.install(pure.id)
	var v := c.validate()
	var legal: bool = ins["ok"] and v["valid"]
	var no_free_power := true
	for p in v["problems"]:
		if String(p).findn("FREE POWER") >= 0 or String(p).findn("tradeoff") >= 0:
			no_free_power = false
	var cfgs := {"T_pure": c}
	var lo := ImprintLoadout.new(lib, cfgs)
	var bound: bool = lo.bind(0, "T_pure")["ok"]
	var says := false
	for line in c.explain():
		if String(line).find("purely beneficial") >= 0:
			says = true
	# THE SILENT-MODIFIER REFUSAL IS KEPT.
	var silent := Imprint.new("AUGMENT_IMPRINT_DIAG_TEST_FIXTURE_SILENT", "Test Fixture Silent",
		Imprint.Kind.AUGMENT)
	silent.requires_tags.assign(["Projectile"])
	lib.learn(silent)
	var c2 := SkillConfiguration.new("T_silent", lib)
	c2.set_skill(C.SKILL_STORM)
	c2.install(silent.id)
	var v2 := c2.validate()
	var caught := false
	for p in v2["problems"]:
		if String(p).findn("SILENT MODIFIER") >= 0:
			caught = true
	cfgs["T_silent"] = c2
	var refused: bool = not lo.bind(1, "T_silent")["ok"]
	# THE SOURCE no longer appends the refusal; the fixtures never reach the build.
	var src := _read_text("res://scripts/imprint/skill_configuration.gd")
	var removed := src.find("problems.append(\"FREE POWER") < 0
	var not_live := not skills.library.knows(pure.id) and not skills.library.knows(silent.id)
	var ok := legal and no_free_power and bound and says and caught and refused and removed and not_live
	_note("A16_purely_beneficial_augments_are_legal_and_silent_ones_are_not",
		"a purely beneficial TEST FIXTURE Augment (affects projectile count, NO tradeoff) installed and validated=%s with no free-power problem=%s, BOUND to a binding=%s, and its explanation says 'purely beneficial'=%s | a SILENT fixture (affects nothing) is still refused as a SILENT MODIFIER=%s and cannot be bound=%s | the 'FREE POWER' refusal is gone from the source=%s | neither fixture reached the live library=%s. D-378 OD-12; the D-375 'free power' half of I25 is REMOVED and COMPENSATED here."
		% [str(legal), str(no_free_power), str(bound), str(says), str(caught), str(refused),
		   str(removed), str(not_live)])
	_reached("A16_purely_beneficial_augments_are_legal_and_silent_ones_are_not")
	return ok

# ============================================================================
# H. ALREADY SATISFIED, CANDIDATES NOT PROMOTED, AND WHAT MUST NOT MOVE
# ============================================================================

func chk_A17_no_universal_transform_capacity_surcharge() -> bool:
	var lib := _scratch_library()
	var C := DiagImprintContent
	var pairs := [
		[C.SKILL_STORM, C.XF_RAIN, C.AUG_SPLIT],
		[C.SKILL_BALLISTA, C.XF_ANCHOR, C.AUG_WARD],
		[C.SKILL_STORM, C.XF_ORBIT, C.AUG_TEMPERED],
	]
	var rows: Array[String] = []
	var equal := true
	for p in pairs:
		var t := _cfg(lib, "T_xf", String(p[0]), [p[1]])
		var a := _cfg(lib, "T_aug", String(p[0]), [p[2]])
		if t.transform_count() != 1 or a.transform_count() != 0 or t.capacity_cost() != a.capacity_cost():
			equal = false
		rows.append("%s: Transform %d = Augment %d" % [String(p[0]).replace("SKILL_IMPRINT_DIAG_", ""),
			t.capacity_cost(), a.capacity_cost()])
	# AND NO RANK MILESTONE MOVES CAPACITY: the same Configuration costs the same
	# at Effective Rank 1 and at its Mastered Rank.
	var r := _cfg(lib, "T_rank", C.SKILL_STORM, [C.AUG_SPLIT])
	r.set_effective_rank(C.SKILL_STORM, 1)
	var low := r.capacity_cost()
	r.set_effective_rank(C.SKILL_STORM, lib.mastered(C.SKILL_STORM))
	var rank_blind := r.capacity_cost() == low
	# NO SURCHARGE CONSTANT, and the scan is PROVED able to see one.
	var consts := _config_constants()
	var xf_keys := _keys_with_all(consts, ["TRANSFORM"])
	var only_canon: bool = xf_keys.size() == 1 and String(xf_keys[0]) == "CANON_TRANSFORMS_MAX_PER_CONFIGURATION"
	var guard := _keys_with_all({"CAPACITY_TRANSFORM_SURCHARGE": 2}, ["TRANSFORM"]).size() == 1
	var ok := equal and rank_blind and only_canon and guard
	_note("A17_no_universal_transform_capacity_surcharge",
		"a Transform costs EXACTLY what an Augment in the same slot costs: %s=%s | Capacity does not move with Effective Rank (%d at rank 1 and at mastery)=%s | the only TRANSFORM constant is the canonical one-per-Configuration limit %s=%s, and the scan sees a planted surcharge=%s. D-378 OD-10.1: ALREADY SATISFIED, now guarded."
		% [str(rows), str(equal), low, str(rank_blind), str(xf_keys), str(only_canon), str(guard)])
	_reached("A17_no_universal_transform_capacity_surcharge")
	return ok

func chk_A18_low_and_middle_ranks_keep_their_measured_rational_uses() -> bool:
	# OD-04: "Low and middle Effective Ranks should have rational uses, not merely
	# be technically selectable." MEASURED in the behaviour that ALREADY exists --
	# no mechanism is added, and the candidate mechanisms stay deferred.
	var lib := _scratch_library()
	var C := DiagImprintContent
	var s := _cfg(lib, "T_low", C.SKILL_STORM, [])
	var costs: Array[float] = []
	for rk in [1, 10, 20]:
		s.set_effective_rank(C.SKILL_STORM, int(rk))
		costs.append(float(s.resolve()["mana_cost"]))
	var cheaper := costs[0] < costs[1] and costs[1] < costs[2]
	# A LOWER-RANK AURA reserves less -- and, since OD-05, leaves MORE regeneration.
	var a := _cfg(lib, "T_aura_low", C.SKILL_AURA, [])
	a.set_effective_rank(C.SKILL_AURA, 1)
	var f1 := float(a.resolve()["reserve_fraction"])
	a.set_effective_rank(C.SKILL_AURA, lib.mastered(C.SKILL_AURA))
	var f_hi := float(a.resolve()["reserve_fraction"])
	var regen_low := ResourcePool.regen_rate_of(ImprintConfig.MANA_MAX * (1.0 - f1),
		ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S)
	var regen_hi := ResourcePool.regen_rate_of(ImprintConfig.MANA_MAX * (1.0 - f_hi),
		ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S)
	var reserves_less := f1 < f_hi and regen_low > regen_hi
	var ok := cheaper and reserves_less
	_note("A18_low_and_middle_ranks_keep_their_measured_rational_uses",
		"the bow Skill costs %.2f / %.2f / %.2f Mana at Effective Rank 1 / 10 / 20 — a low rank is CHEAPER to sustain=%s | the aura reserves %.1f%% at rank 1 against %.1f%% at rank %d, leaving %.2f against %.2f Mana/s of regeneration=%s. D-378 OD-04.1: ALREADY SATISFIED by existing PROVISIONAL behaviour; the stepped-Capacity / threshold / cadence mechanisms are CANDIDATES and are NOT implemented (AD-06)."
		% [costs[0], costs[1], costs[2], str(cheaper), f1 * 100.0, f_hi * 100.0,
		   lib.mastered(C.SKILL_AURA), regen_low, regen_hi, str(reserves_less)])
	_reached("A18_low_and_middle_ranks_keep_their_measured_rational_uses")
	return ok

func chk_A19_no_d378_test_candidate_is_promoted() -> bool:
	# ========================================================================
	# "DO NOT SILENTLY TURN A TEST CANDIDATE INTO A PRODUCTION VALUE."
	# ========================================================================
	# OD-11: an UNEQUIPPED Imprint receives EXACTLY 0 -- the award fires first.
	var lib := skills.library
	var absent := DiagImprintContent.AUG_SUREFOOT
	var in_loadout := false
	for id in skills.loadout.equipped_imprint_ids_with_duplicates():
		if String(id) == absent:
			in_loadout = true
	var before := lib.total_progress_units(absent)
	var awards_before := lib.awards
	skills.award_combat_progress(100.0)
	var fired := lib.awards == awards_before + 1
	var unequipped_zero := is_equal_approx(lib.total_progress_units(absent), before)
	# NO CANDIDATE CONSTANT: floor, unequipped fraction, milestone, band, level
	# 100, threshold, surcharge -- and the scan is PROVED able to see them.
	var consts := _config_constants()
	var probes := [["FLOOR"], ["UNEQUIPPED"], ["MILESTONE"], ["BAND"], ["LEVEL"],
		["THRESHOLD"], ["SURCHARGE", "TRANSFORM"], ["CAPACITY", "RANK"]]
	var hits: Array = []
	for p in probes:
		hits.append_array(_keys_with_all(consts, p))
	var planted := {"UNEQUIPPED_XP_FRACTION": 0.25, "PERSISTENT_RESERVE_FLOOR": 0.03,
		"CAPACITY_RANK_MILESTONE": 5}
	var planted_hits: Array = []
	for p in probes:
		planted_hits.append_array(_keys_with_all(planted, p))
	var guard := planted_hits.size() >= 3
	# OD-06.3: the ratio is the prototype-derived 1.444, NOT ~2x, and says so.
	var ratio_not_candidate := is_equal_approx(ImprintConfig.LIFE_CONVERSION_RATIO_AT_RANK_1, 1.444) \
		and absf(ImprintConfig.LIFE_CONVERSION_RATIO_AT_RANK_1 - 2.0) > 0.5
	var ratio_labelled := false
	for row in ImprintConfig.provisional_registry():
		if String(row[0]) == "Mana->Life conversion ratio at rank 1" \
				and String(row[2]).find("~2x candidate is NOT adopted") >= 0:
			ratio_labelled = true
	# OD-07.1: no floor in the reservation code (the D-375 tithe floor went with it).
	var src := _read_text("res://scripts/imprint/skill_configuration.gd")
	var no_floor := src.find("maxf(0.02") < 0
	# OD-08.2: the provisional 30 + 5 is unchanged -- no band adopted.
	var no_band := ImprintConfig.CAPACITY_FROM_PROGRESSION == 30 \
		and ImprintConfig.CAPACITY_GEAR_BONUS_DIAGNOSTIC == 5
	# OD-07.1: the Persistent base cost of 1 PREDATES D-378 and is not cited as it.
	var coincidence_only := ImprintConfig.CAPACITY_BASE_PERSISTENT == 1
	for row in ImprintConfig.provisional_registry():
		if String(row[0]) == "Capacity base, persistent Skill" and String(row[2]).find("OD-07") >= 0:
			coincidence_only = false
	var ok := not in_loadout and fired and unequipped_zero and hits.is_empty() and guard \
		and ratio_not_candidate and ratio_labelled and no_floor and no_band and coincidence_only
	_note("A19_no_d378_test_candidate_is_promoted",
		"OD-11: '%s' is NOT equipped=%s; an award FIRED=%s and it received EXACTLY 0=%s | candidate-named constants (floor, unequipped, milestone, band, level, threshold, Transform surcharge, rank-scaled Capacity): %s (must be none), and the scan catches %d planted ones=%s | OD-06.3: the ratio is %.3f, NOT ~2x=%s, and its registry row says the ~2x candidate is NOT adopted=%s | OD-07.1: no reservation floor in the pipeline=%s; the Persistent base cost of 1 predates D-378 and is NOT cited as OD-07=%s | OD-08.2: Capacity stays the provisional 30 + 5=%s. NO TEST CANDIDATE WAS TURNED INTO A PRODUCTION VALUE."
		% [absent, str(not in_loadout), str(fired), str(unequipped_zero), str(hits),
		   planted_hits.size(), str(guard), ImprintConfig.LIFE_CONVERSION_RATIO_AT_RANK_1,
		   str(ratio_not_candidate), str(ratio_labelled), str(no_floor), str(coincidence_only),
		   str(no_band)])
	_reached("A19_no_d378_test_candidate_is_promoted")
	return ok

func chk_A20_no_pacing_or_tuning_value_moved() -> bool:
	var consts := _config_constants()
	var moved: Array[String] = []
	var missing: Array[String] = []
	for k in D375_NUMERIC:
		if not consts.has(k):
			missing.append(String(k))
		elif not is_equal_approx(float(consts[k]), float(D375_NUMERIC[k])):
			moved.append("%s: %s -> %s" % [k, str(D375_NUMERIC[k]), str(consts[k])])
	var still_present: Array[String] = []
	for k in D380_REMOVED:
		if consts.has(k):
			still_present.append(String(k))
	# BOTH DIRECTIONS: a numeric constant nobody declared is a failure too.
	var undeclared: Array[String] = []
	for k in consts:
		var v = consts[k]
		if (typeof(v) == TYPE_INT or typeof(v) == TYPE_FLOAT) \
				and not D375_NUMERIC.has(k) and not D380_ADDED.has(k):
			undeclared.append(String(k))
	var added_right := true
	for k in D380_ADDED:
		if not consts.has(k) or not is_equal_approx(float(consts[k]), float(D380_ADDED[k])):
			added_right = false
	# EACH ADDITION IS DERIVED FROM A VALUE THAT WAS ALREADY THERE.
	var derived := is_equal_approx(ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S, 22.0 / 500.0) \
		and absf(ImprintConfig.LIFE_CONVERSION_RATIO_AT_RANK_1 - 0.26 / 0.18) < 0.001 \
		and absf(ImprintConfig.LIFE_CONVERSION_RATIO_PER_RANK - (-0.004 / 0.26)) < 0.0001
	# THE SEEDING TABLE AND THE CHARACTER RANK ARE UNCHANGED.
	var seeds_same := DiagImprintContent.STARTING_CHARACTER_RANK == 16 \
		and int(DiagImprintContent.STARTING_MASTERY[DiagImprintContent.SKILL_STORM]) == 20 \
		and int(DiagImprintContent.STARTING_MASTERY[DiagImprintContent.AUG_TITHE]) == 4
	# NO LEVELLING-TIME, HOURS OR "PRACTICAL CONFIGURATIONS" VALUE EXISTS.
	var no_time := _keys_with_all(consts, ["HOUR"]).is_empty() and _keys_with_all(consts, ["TIME_TO"]).is_empty() \
		and _keys_with_all(consts, ["LEVELLING"]).is_empty() and _keys_with_all(consts, ["PRACTICAL"]).is_empty()
	var ok := moved.is_empty() and missing.is_empty() and still_present.is_empty() \
		and undeclared.is_empty() and added_right and derived and seeds_same and no_time \
		and D375_NUMERIC.size() == 104 and D380_REMOVED.size() == 5 and D380_ADDED.size() == 3
	_note("A20_no_pacing_or_tuning_value_moved",
		"%d D-375 numeric constants checked ONE BY ONE — moved: %s, missing: %s | the %d REMOVED are gone (still present: %s) | undeclared numeric constants: %s | the %d ADDED hold their values=%s and are each DERIVED from a value that was already there (22/500, 0.26/0.18, -0.004/0.26)=%s | the seeding table and character rank are unchanged=%s | no levelling-time, hours or practical-Configuration value exists=%s. The rank cap, XP curve, catch-up, Capacity, reservation and Mana/Life values did NOT move."
		% [D375_NUMERIC.size(), str(moved), str(missing), D380_REMOVED.size(), str(still_present),
		   str(undeclared), D380_ADDED.size(), str(added_right), str(derived), str(seeds_same),
		   str(no_time)])
	_reached("A20_no_pacing_or_tuning_value_moved")
	return ok

# ============================================================================
# I. REGISTRIES, THE MAP, AND THE PANEL
# ============================================================================

func chk_A21_every_value_this_stage_introduces_is_registered_provisional() -> bool:
	var reg := ImprintConfig.provisional_registry()
	var labels := {}
	for row in reg:
		labels[String(row[0])] = row
	var new_rows := ["Mana regeneration rate (of UNRESERVED maximum, per s)",
		"Mana->Life conversion ratio at rank 1", "Mana->Life conversion ratio change per rank (relative)"]
	var bad: Array[String] = []
	for n in new_rows:
		if not labels.has(n):
			bad.append("%s missing" % n)
			continue
		var t := String(labels[n][2])
		if t.find("PROVISIONAL") < 0 or t.find("D-380") < 0 or t.find("DERIVED") < 0 or t.find("NOT") < 0:
			bad.append("%s under-labelled" % n)
	var gone := not labels.has("candidate active Configurations") \
		and not labels.has("candidate Persistent Configurations") \
		and not labels.has("Mana regeneration (per s)") \
		and not labels.has("Life tithe reservation at rank 1") \
		and not labels.has("Life tithe reservation per rank")
	var arithmetic := reg.size() == 66
	var all_labelled := true
	for row in reg:
		if String(row[2]).find("PROVISIONAL") < 0:
			all_labelled = false
	# THE WORKING BASELINE IS ITS OWN CATEGORY, disjoint from the other two.
	var wb := ImprintConfig.working_baseline_registry()
	var wb_ok := wb.size() == 2 and String(wb[0][0]) == "equipped Active Configurations" \
		and String(wb[0][2]).find("CURRENT WORKING BASELINE") >= 0 \
		and String(wb[0][2]).find("NOT a lock") >= 0
	var disjoint := true
	for row in wb:
		if labels.has(String(row[0])):
			disjoint = false
		for c in ImprintConfig.canonical_registry():
			if String(c[0]) == String(row[0]):
				disjoint = false
	var ok := bad.is_empty() and gone and arithmetic and all_labelled and wb_ok and disjoint
	_note("A21_every_value_this_stage_introduces_is_registered_provisional",
		"the three values this stage introduces are registered PROVISIONAL, D-380, DERIVED and 'NOT' a lock or an adoption (problems: %s) | the five rows whose values no longer exist are gone=%s | %d rows = 68 - 5 + 3=%s, every one carrying PROVISIONAL=%s | the WORKING BASELINE is a THIRD category — up to eight, one per binding, NOT a lock=%s — disjoint from canon and from tunable numbers=%s."
		% [str(bad), str(gone), reg.size(), str(arithmetic), str(all_labelled), str(wb_ok),
		   str(disjoint)])
	_reached("A21_every_value_this_stage_introduces_is_registered_provisional")
	return ok

## Validates a map; PROVED able to refuse a planted bad row.
static func _map_problems(rows: Array) -> Array:
	var problems: Array = []
	var seen := {}
	var bases := {}
	for row in rows:
		var id := String(row[0])
		if seen.has(id):
			problems.append("duplicate %s" % id)
		seen[id] = true
		if not ImprintConfig.DISPOSITIONS.has(String(row[1])):
			problems.append("%s has disposition '%s'" % [id, String(row[1])])
		if String(row[2]).length() == 0 or String(row[2]).length() > 60 or String(row[3]).length() < 20:
			problems.append("%s label/detail" % id)
		bases[id.split(".")[0]] = true
	for i in range(1, 17):
		if not bases.has("OD-%02d" % i):
			problems.append("OD-%02d unmapped" % i)
	for b in bases:
		var n := int(String(b).substr(3))
		if n < 1 or n > 16:
			problems.append("%s is not a D-378 ruling" % b)
	return problems

func chk_A22_the_d378_map_is_exhaustive_and_uses_only_four_dispositions() -> bool:
	var rows := ImprintConfig.d378_alignment()
	var problems := _map_problems(rows)
	var tally := {}
	for row in rows:
		tally[String(row[1])] = int(tally.get(String(row[1]), 0)) + 1
	var counts := rows.size() == 27 and int(tally.get("IMPLEMENTED", 0)) == 6 \
		and int(tally.get("ALREADY SATISFIED", 0)) == 5 \
		and int(tally.get("DEFERRED — CANDIDATE ONLY", 0)) == 6 \
		and int(tally.get("OUT OF SCOPE", 0)) == 10
	# EVERY IMPLEMENTED PART HAS A RECORDED RUNTIME CHANGE -- six and six.
	var changes := ImprintConfig.alignment_changes()
	var change_ids := ""
	for c in changes:
		change_ids += String(c[0]) + " "
	var matched := changes.size() == 6
	for need in ["OD-01", "OD-05", "OD-06", "OD-07", "OD-09", "OD-12"]:
		if change_ids.find(String(need)) < 0:
			matched = false
	# THE VALIDATOR MUST BE ABLE TO FAIL.
	var planted := rows.duplicate()
	planted.append(["OD-17", "PARTIALLY DONE", "invented", "a planted row that must be refused"])
	var guard := _map_problems(planted).size() >= 2
	# THE VIEWER SEES EVERY PART.
	var page := _page_text("D-378 ALIGNMENT")
	var unseen: Array[String] = []
	for row in rows:
		if page.find(String(row[0])) < 0:
			unseen.append(String(row[0]))
	var ok := problems.is_empty() and counts and matched and guard and unseen.is_empty()
	_note("A22_the_d378_map_is_exhaustive_and_uses_only_four_dispositions",
		"%d parts cover OD-01..OD-16 in BOTH directions, each with exactly one of the four dispositions (problems: %s) | tally %s = 6 + 5 + 6 + 10=%s | each of the six IMPLEMENTED parts has a recorded before/after runtime change=%s | the validator REFUSES a planted OD-17 'PARTIALLY DONE' row=%s | every part is shown on the D-378 ALIGNMENT page (unseen: %s). The runner compares this map with the inventory document row for row (T15)."
		% [rows.size(), str(problems), str(tally), str(counts), str(matched), str(guard), str(unseen)])
	_reached("A22_the_d378_map_is_exhaustive_and_uses_only_four_dispositions")
	return ok

func chk_A23_the_panel_states_every_aligned_rule_to_a_viewer() -> bool:
	var overview := _page_text("OVERVIEW")
	var library := _page_text("IMPRINT LIBRARY")
	var comparisons := _page_text("THE SIX COMPARISONS")
	var page := _page_text("D-378 ALIGNMENT")
	var required := [
		[overview, "UP TO 8"], [overview, "ONE PER BINDING, no separate six cap"],
		[overview, "CURRENT WORKING BASELINE (D-378 OD-09), NOT a lock"],
		[overview, "NO arbitrary slot cap"], [overview, "x UNRESERVED maximum"],
		[overview, "X-02 RESOLVED BY D-376"],
		[library, "LEARNED at Mastered Rank 1 / 0 XP"], [library, "Life Conversion"],
		[comparisons, "PROPORTIONAL"], [comparisons, "UNRESERVED maximum Mana"],
		[page, "NOTHING IS LOCKED; NO TEST CANDIDATE IS ADOPTED"],
		[page, "OD-05  regeneration"], [page, "the flat Life tithe is GONE"],
		[page, "8 OF 8 BOUND, ALL ACTIVE"], [page, "DEACTIVATED BY CAPACITY"],
		[page, "6 OF 6 ACCEPTED, 1 DEACTIVATED BY RESERVATION"],
		[page, "purely beneficial Augments are LEGAL"],
		[page, "NOT ADOPTED — D-378 TEST CANDIDATES"],
	]
	var missing: Array[String] = []
	for r in required:
		if String(r[0]).find(String(r[1])) < 0:
			missing.append(String(r[1]))
	# THE STALE TEXT IS GONE FROM EVERY PAGE.
	var all := _all_pages_text()
	var stale: Array[String] = []
	for s in ["of a PROVISIONAL CANDIDATE", "NOT rewritten to 6", "Life Tithe installed",
			"the Life tithe is the DEARER", "The candidate of 4 is UNDER REVIEW"]:
		if all.find(String(s)) >= 0:
			stale.append(String(s))
	var ok := missing.is_empty() and stale.is_empty()
	_note("A23_the_panel_states_every_aligned_rule_to_a_viewer",
		"%d required statements across the OVERVIEW, IMPRINT LIBRARY, THE SIX COMPARISONS and D-378 ALIGNMENT pages (missing: %s) | the D-375 candidate and tithe texts are GONE from every page (still present: %s). READING THE WORDS PROVES THEY EXIST, NOT THAT ANYONE CAN SEE THEM — the two D-380 captures are rendered and looked at."
		% [required.size(), str(missing), str(stale)])
	_reached("A23_the_panel_states_every_aligned_rule_to_a_viewer")
	return ok

func chk_A24_the_panel_keeps_its_controls_and_remains_a_developer_surface() -> bool:
	var d375_rows := ["simulated gear Capacity bonus",
		"Persistent reservation resource (Mana / Life)",
		"attempt a SECOND Transform (must be refused)",
		"cycle binding 1's Effective Rank (low / middle / maximum)",
		"DIAGNOSTIC safe-state override", "page"]
	var rows_same := LoadoutPanel.ROWS == d375_rows
	var d375_pages := ["OVERVIEW", "CONFIGURATIONS", "IMPRINT LIBRARY", "COMPATIBILITY TRIALS",
		"THE SIX COMPARISONS"]
	var pages_ok := LoadoutPanel.PAGES.size() == 6 \
		and LoadoutPanel.PAGES.slice(0, 5) == d375_pages and LoadoutPanel.PAGES[5] == "D-378 ALIGNMENT"
	# RE-SCOPED UNDER D-381, one for one: 25 + 1 = 26. D-380 added NO input
	# action (true when written); the D-381 correction adds EXACTLY ONE, which its
	# ruling authorizes -- and A33 proves it is that one and nothing else.
	var proj := _read_text("res://project.godot")
	var re := RegEx.new()
	re.compile("(?m)^[a-z_][a-z_0-9]*=\\{$")
	var all_actions := re.search_all(proj).size()
	var re2 := RegEx.new()
	re2.compile("(?m)^imprint_[a-z_0-9]+=\\{$")
	var imprint_actions := re2.search_all(proj).size()
	# RE-SCOPED UNDER D-396, one for one: 26 + 1 = 27 -- the ruling's diagnostic
	# review control, `diagnostic_hound_fall`, named so no other addition passes.
	# RE-SCOPED UNDER D-398, one for one: 27 + 2 = 29 -- the ruling's two
	# diagnostic stress and travel-speed modes, both named.
	var actions_same := all_actions == 29 and imprint_actions == 12 \
		and proj.find("\ndiagnostic_reservation_cycle={\n") >= 0 \
		and proj.find("\ndiagnostic_hound_fall={\n") >= 0 \
		and proj.find("\ndiagnostic_stress_population={\n") >= 0 \
		and proj.find("\ndiagnostic_travel_speed={\n") >= 0
	# STILL A DEVELOPER SURFACE, on the new page too.
	var page := _page_text("D-378 ALIGNMENT")
	var denies := page.findn("DEVELOPER surface") >= 0 and page.findn("NOT a UI foundation") >= 0
	var src := _read_text("res://scripts/imprint/loadout_panel.gd")
	var no_entry := src.find("LineEdit") < 0 and src.find("TextEdit") < 0 and src.find("SpinBox") < 0
	var ok := rows_same and pages_ok and actions_same and denies and no_entry
	_note("A24_the_panel_keeps_its_controls_and_remains_a_developer_surface",
		"the six focus rows are EXACTLY the D-375 six=%s | the pages are the D-375 five plus 'D-378 ALIGNMENT' (5 + 1 = 6)=%s | project.godot declares %d input actions, %d of them the Imprint stage's — D-380 added none, D-381 added EXACTLY the one diagnostic reservation cycle (25 + 1 = 26), D-396 EXACTLY the diagnostic hound fall (26 + 1 = 27) and D-398 EXACTLY the diagnostic stress-population and travel-speed modes (27 + 2 = 29)=%s | the new page still says DEVELOPER surface and NOT a UI foundation=%s, and no text-entry control exists=%s. NO production UI was begun."
		% [str(rows_same), str(pages_ok), all_actions, imprint_actions, str(actions_same),
		   str(denies), str(no_entry)])
	_reached("A24_the_panel_keeps_its_controls_and_remains_a_developer_surface")
	return ok

# ============================================================================
# J. PRESERVATION AND SCOPE
# ============================================================================

func chk_A25_the_accepted_architecture_holds_on_the_aligned_rules() -> bool:
	# Built on the ALIGNED rules -- eight bindings filled, a heavy loadout -- the
	# accepted architecture still holds, one rule at a time.
	var lib := _scratch_library()
	var C := DiagImprintContent
	var heavy := _heavy_eight(lib)
	var shape_ok := true
	for cid in heavy:
		var c := heavy[cid] as SkillConfiguration
		if c.skill_id == "" or c.modifier_count() > 4 or c.transform_count() > 1:
			shape_ok = false
	# A FIFTH modifier is still refused by the SLOT rule, a SECOND Transform by
	# the TRANSFORM rule.
	var fifth := (heavy["H_bow_full"] as SkillConfiguration).install(C.XF_RAIN)
	var fifth_refused: bool = not fifth["ok"] and String(fifth["reason"]).findn("FIFTH") >= 0
	var second := (heavy["H_orbit"] as SkillConfiguration).install(C.XF_RAIN)
	var second_refused: bool = not second["ok"] and String(second["reason"]).findn("SECOND TRANSFORM") >= 0
	# MASTERED IS NOT EFFECTIVE: a selection above mastery is refused; below it is kept.
	var c2 := heavy["H_anchor"] as SkillConfiguration
	var above := c2.set_effective_rank(C.SKILL_BALLISTA, lib.mastered(C.SKILL_BALLISTA) + 1)
	var below := c2.set_effective_rank(C.SKILL_BALLISTA, 1)
	var ranks_ok: bool = not above["ok"] and below["ok"] and c2.skill_rank() == 1 \
		and lib.mastered(C.SKILL_BALLISTA) > 1
	# ONE AWARD PER DISTINCT IMPRINT on the full eight-binding loadout.
	var lo := ImprintLoadout.new(lib, heavy)
	lo.gear_bonus_active = true
	_bind_all(lo, heavy)
	lo.revalidate(ResourcePool.new())
	var ids := lo.equipped_imprint_ids_with_duplicates()
	var tempered_count := 0
	for id in ids:
		if String(id) == C.AUG_TEMPERED:
			tempered_count += 1
	var before := lib.total_progress_units(C.AUG_TEMPERED)
	var report := lib.award_combat_progress(50.0, ids)
	var gained := lib.total_progress_units(C.AUG_TEMPERED) - before
	var once := absf(gained - 50.0 * lib.catchup_multiplier(C.AUG_TEMPERED)) <= 0.01 \
		or lib.mastered(C.AUG_TEMPERED) >= ImprintConfig.RANK_MAX
	var collapsed := int(report["duplicates_collapsed"]) == ids.size() - int(report["distinct"]) \
		and int(report["duplicates_collapsed"]) >= 1
	var ok := shape_ok and fifth_refused and second_refused and ranks_ok and tempered_count >= 2 \
		and once and collapsed
	_note("A25_the_accepted_architecture_holds_on_the_aligned_rules",
		"on eight heavily modified Configurations: one Skill Imprint, at most four shared slots and at most one Transform each=%s | a FIFTH modifier is refused by the SLOT rule=%s and a SECOND Transform by the TRANSFORM rule=%s | Mastered Rank stays distinct from Effective Rank: above mastery refused, rank 1 kept=%s | on the full eight-binding loadout Tempered Draw appears %d times yet ONE award granted it %.2f — once=%s — with %d duplicate id(s) collapsed=%s. Button presses still grant nothing (I41), autonomous sources still work (I71, I74, I75)."
		% [str(shape_ok), str(fifth_refused), str(second_refused), str(ranks_ok), tempered_count,
		   gained, str(once), int(report["duplicates_collapsed"]), str(collapsed)])
	_reached("A25_the_accepted_architecture_holds_on_the_aligned_rules")
	return ok

func chk_A26_no_new_content_imprint_configuration_script_asset_or_input_action() -> bool:
	# ========================================================================
	# RE-SCOPED UNDER D-392, ONE FOR ONE. THE ID IS D-380's AND WAS TRUE OF IT.
	# ========================================================================
	# D-380 added no content, Imprint, Configuration, script, asset or input
	# action (D-381 then declared ONE script and ONE input). The D-392 ruling
	# authorizes exactly the Huntress Splinter Shot stage's additions, and each
	# pin moves by EXACTLY that, stated below; everything else still refuses:
	#   * the library: D-375's 14 ids + Splinter Shot = 15;
	#   * the Configurations: D-375's six + CFG_SPLINTER_SHOT = 7;
	#   * the action entry points: 5 + 1 = 6;
	#   * the runtime scripts: 31 + the 15 declared D-392 scripts = 46 (17 and 48
	#     until D-393 removed Prey -- true when written);
	#   * the D-370 manifest's 5 packs and 29 files: UNCHANGED (D-392's intake is a
	#     SEPARATE declared block); the input actions: UNCHANGED at 26;
	#   * a runtime declaration naming the Huntress: ONLY under scripts/huntress/,
	#     plus EXACTLY the declared composition hooks outside it -- any other
	#     still fails, and the scan is still proved able to see a planted one.
	#
	# RE-SCOPED AGAIN UNDER D-396, ONE FOR ONE. The D-396 ruling authorizes the
	# Kindred Hounds stage's additions, and each pin moves by EXACTLY that:
	#   * the library: 15 + Kindred Hounds = 16;
	#   * the Configurations: 7 + CFG_KINDRED_HOUNDS = 8;
	#   * the Skill system's entry points: 6 + 1 = 7 (a Persistent Skill Imprint
	#     counts, exactly as the diagnostic aura has since D-375);
	#   * the runtime scripts: 46 + the 7 declared D-396 scripts = 53;
	#   * the manifest's 5 packs and 29 files: UNCHANGED (D-396 imports NOTHING);
	#   * the Huntress-named declarations outside scripts/huntress/: UNCHANGED.
	#
	# RE-SCOPED A THIRD TIME UNDER D-398, ONE FOR ONE. The D-398 ruling authorizes
	# the mobile minion cohesion stage's additions, and only one pin moves:
	#   * the runtime scripts: 53 + the 7 declared D-398 scripts = 60;
	#   * the library (16), the Configurations (8), the entry points (7), the
	#     manifest (5 packs, 29 files) and the Huntress-named declarations outside
	#     scripts/huntress/: UNCHANGED -- D-398 adds no Imprint, Configuration,
	#     entry point, asset or Huntress hook.
	#
	# RE-SCOPED A FOURTH TIME UNDER D-400, ONE FOR ONE. The D-400 ruling authorizes
	# the player locomotion redirection stage's additions, and only one pin moves:
	#   * the runtime scripts: 60 + the 2 declared D-400 scripts = 62;
	#   * the library (16), the Configurations (8), the entry points (7), the
	#     manifest (5 packs, 29 files), the scenes (1) and the Huntress-named
	#     declarations outside scripts/huntress/: UNCHANGED -- D-400 adds no
	#     Imprint, Configuration, entry point, asset, scene or Huntress hook, and
	#     NO input action either.
	#
	# RE-SCOPED A FIFTH TIME UNDER D-402, ONE FOR ONE. The D-402 ruling authorizes
	# ONE canonical ACTIVE Skill Imprint, Cinder Field, and the extraction of
	# EXACTLY two placeholder models from an ALREADY-DECLARED pack. Five pins move,
	# each by exactly what the ruling adds:
	#   * the library: 16 + 1 = 17 (Cinder Field);
	#   * the Configurations: 8 + 1 = 9 (its one unmodified Configuration);
	#   * the entry points: 7 + 1 = 8 (a Skill Imprint IS an entry point);
	#   * the manifest's files: 29 + 4 = 33; the PACK count stays 5;
	#   * the runtime scripts: 62 + the 6 declared D-402 scripts = 68.
	# The scenes (1) and the Huntress-named declarations outside scripts/huntress/
	# are UNCHANGED, and NO input action is added.
	# RE-SCOPED UNDER D-404, ONE FOR ONE, and ONE pin moves: the runtime scripts,
	# 68 + the 4 declared scripts/click/ files = 72. D-404 adds no Imprint,
	# Configuration, entry point, asset, scene, input action or Huntress hook.
	var live: Array = skills.library.ids()
	var want_ids: Array = D375_IMPRINT_IDS.duplicate()
	want_ids.append(HuntressContent.SKILL_SPLINTER_SHOT)
	want_ids.append(HoundContent.SKILL_KINDRED_HOUNDS)
	want_ids.append(CinderContent.SKILL_CINDER_FIELD)
	want_ids.sort()
	var live_sorted: Array = live.duplicate()
	live_sorted.sort()
	var imprints_same := live_sorted == want_ids and skills.library.count() == 17
	var cfg_ids: Array = skills.loadout.configurations.keys()
	cfg_ids.sort()
	var want: Array = DiagImprintContent.ALL_CONFIGURATIONS.duplicate()
	want.append(HuntressContent.CFG_SPLINTER_SHOT)
	want.append(HoundContent.CFG_KINDRED_HOUNDS)
	want.append(CinderContent.CFG_CINDER_FIELD)
	want.sort()
	var cfgs_same := cfg_ids == want and want.size() == 9
	var entry_points := SkillRuntime.all_action_entry_points().size() == 8
	var declared := 0
	for p in AssetManifest.packs():
		declared += (p["files"] as Array).size()
	# RE-SCOPED UNDER D-402, ONE FOR ONE: 29 + 4 = 33. The PACK count is unmoved
	# at 5 -- the four files joined an ALREADY-DECLARED pack -- and the guard is
	# still an exact equality. Until D-402 this required 29: true when written.
	var assets_same := AssetManifest.packs().size() == 5 and declared == 33
	var scripts := _runtime_script_files()
	# RE-SCOPED UNDER D-381, one for one: 30 + 1 = 31. The name of this check is
	# D-380's and was true of the D-380 delivery; the correction adds EXACTLY ONE
	# runtime script, the diagnostic review HUD, which A30 and A31 guard.
	var want_scripts: Array = RUNTIME_SCRIPTS_BEFORE.duplicate()
	want_scripts.append("res://scripts/imprint/review_hud.gd")
	want_scripts.append_array(D392_RUNTIME_SCRIPTS)
	want_scripts.append_array(D396_RUNTIME_SCRIPTS)
	want_scripts.append_array(D398_RUNTIME_SCRIPTS)
	want_scripts.append_array(D400_RUNTIME_SCRIPTS)
	want_scripts.append_array(D402_RUNTIME_SCRIPTS)
	# RE-SCOPED UNDER D-404, ONE FOR ONE: 68 + 4 = 72, the four scripts/click/
	# files. Still an EXACT set equality in both directions. Until D-404 this
	# required 68 -- true when written.
	want_scripts.append_array(D404_RUNTIME_SCRIPTS)
	want_scripts.sort()
	var scripts_same := scripts == want_scripts and scripts.size() == 72 \
		and D392_RUNTIME_SCRIPTS.size() == 15 and D396_RUNTIME_SCRIPTS.size() == 7 \
		and D398_RUNTIME_SCRIPTS.size() == 7 and D400_RUNTIME_SCRIPTS.size() == 2 \
		and D402_RUNTIME_SCRIPTS.size() == 6 and D404_RUNTIME_SCRIPTS.size() == 4
	var scenes: Array = []
	_walk("res://scenes", scenes)
	var scenes_same := scenes.size() == 1 and String(scenes[0]) == "res://scenes/main.tscn"
	# OD-14, and the Huntress: no declaration names Mana Guard, a bonus rank or
	# the Huntress in the RUNTIME.
	var hits: Array[String] = []
	var hooks_seen: Array[String] = []
	for f in scripts:
		var path := String(f)
		for t in _declarations_naming(_read_text(path).to_lower(), ["mana_guard", "bonus_rank"]):
			hits.append("%s: %s" % [path.get_file(), t])
		if path.begins_with("res://scripts/huntress/"):
			continue
		for hook in _huntress_declarations(_code_only(_read_text(path)).to_lower()):
			var key := "%s: %s" % [path.get_file(), hook]
			if D392_DECLARED_HUNTRESS_HOOKS.has(key):
				hooks_seen.append(key)
			else:
				hits.append(key)
	hooks_seen.sort()
	var want_hooks: Array = D392_DECLARED_HUNTRESS_HOOKS.duplicate()
	want_hooks.sort()
	var hooks_exact := hooks_seen == want_hooks
	var guard := _declarations_naming("func mana_guard() -> void:", ["mana_guard"]).size() == 1 \
		and _huntress_declarations("var huntress_planted := 1").size() == 1
	var ok := imprints_same and cfgs_same and entry_points and assets_same and scripts_same \
		and scenes_same and hits.is_empty() and guard and hooks_exact
	_note("A26_no_new_content_imprint_configuration_script_asset_or_input_action",
		"RE-SCOPED UNDER D-404, ONE FOR ONE: the runtime scripts are now 68 + 4 = 72 (the four scripts/click/ files), and nothing else in this check moved | RE-SCOPED UNDER D-392, D-396 AND D-398: the live Imprint Library is EXACTLY D-375's 14 ids + Splinter Shot + Kindred Hounds (14 + 1 + 1 = 16)=%s · the Configurations EXACTLY its six + CFG_SPLINTER_SHOT + CFG_KINDRED_HOUNDS (6 + 1 + 1 = 8)=%s · action entry points 5 + 1 + 1 = 7=%s · 5 packs and 29 declared third-party files in the D-370 block, UNCHANGED=%s · the runtime scripts EXACTLY the 30 before D-380, the ONE D-381 review HUD, the 15 declared D-392 scripts, the 7 declared D-396 scripts, the 7 declared D-398 scripts and the 2 declared D-400 scripts (30 + 1 + 15 + 7 + 7 + 2 = 62; 17 and 48 until D-393 removed Prey)=%s · one scene=%s | runtime declarations naming Mana Guard or a bonus rank, or naming the Huntress OUTSIDE scripts/huntress/ other than the declared hooks %s: %s (must be none; the scans see a planted one=%s) | the declared hooks are present EXACTLY=%s. D-380 added NO content, scene or asset; D-381 declared ONE script and ONE input action (A30, A33); D-392, D-396, D-398 and D-400 declare their own, each verified by its own suite."
		% [str(imprints_same), str(cfgs_same), str(entry_points), str(assets_same),
		   str(scripts_same), str(scenes_same), str(D392_DECLARED_HUNTRESS_HOOKS), str(hits),
		   str(guard), str(hooks_exact)])
	_reached("A26_no_new_content_imprint_configuration_script_asset_or_input_action")
	return ok

func chk_A27_the_denials_are_present_and_the_guard_can_fail() -> bool:
	var d := ImprintConfig.alignment_denials()
	var joined := "\n".join(d)
	var needles := ["IS NOT Huntress implementation", "IS NOT progression tuning",
		"DOES NOT AUTHORIZE P2", "BUILDS NO Machinations model", "ADOPTS NO D-378 TEST CANDIDATE",
		"LOCKS NO NUMBER", "NO canonical Huntress class specification",
		"adds NO Imprint, NO Configuration, NO asset, NO input action",
		"MODIFIES NO accepted D-373 value"]
	var missing: Array[String] = []
	for n in needles:
		if joined.find(String(n)) < 0:
			missing.append(String(n))
	# A CLAIM NOBODY CAN FAIL IS NOT A BOUNDARY.
	var forbidden := ["the rank cap is locked", "the XP curve is final", "~2x is adopted",
		"unequipped progression is implemented", "P2 is authorized", "the Huntress roster is final",
		"final balance is locked"]
	var text := _all_pages_text() + "\n" + joined
	var found: Array[String] = []
	for f in forbidden:
		if text.findn(String(f)) >= 0:
			found.append(String(f))
	var planted := text + "\n" + PLANTED_CLAIM + "\nthe rank cap is locked"
	var guard := false
	for f in forbidden:
		if planted.findn(String(f)) >= 0:
			guard = true
	var ok := d.size() >= 7 and missing.is_empty() and found.is_empty() and guard
	_note("A27_the_denials_are_present_and_the_guard_can_fail",
		"%d D-380 denials declared and printed in the banner; every load-bearing phrase is present (missing: %s) | no forbidden lock or completion claim appears on any panel page or in the denials (found: %s) | the scan is PROVED able to refuse a planted claim=%s"
		% [d.size(), str(missing), str(found), str(guard)])
	_reached("A27_the_denials_are_present_and_the_guard_can_fail")
	return ok

func chk_A28_the_units_are_named_at_this_surface() -> bool:
	var src := _read_text("res://tests/alignment_verification.gd")
	var names_all := src.find("D-380 OWED CRITERIA") >= 0 and src.find("D-380 EXECUTABLE CHECKS") >= 0 \
		and src.find("D-380 RUNNER CHECKS") >= 0 and src.find("D-375 EXECUTABLE CHECKS 101") >= 0 \
		and src.find("D-370 EXECUTABLE CHECKS  85") >= 0
	var says_distinct := src.findn("none is a synonym for another") >= 0
	# RE-SCOPED UNDER D-381: 28 + 7 = 35 checks, 121 + 25 = 146 criteria.
	# RE-SCOPED UNDER D-382: 35 + 5 = 40 checks, 146 + 16 = 162 criteria.
	var distinct := OWED.size() == 40 and OWED.size() != 162 and OWED.size() != 21
	# The two accepted suites' counts, counted from their own sources.
	var isrc := _read_text("res://tests/imprint_verification.gd")
	var i := isrc.find("const OWED := [")
	var j := isrc.find("\n]\n", i)
	var imprint_owed := isrc.substr(i, j - i).count("\n\t\"I")
	var fsrc := _read_text("res://tests/foundation_verification.gd")
	var k := fsrc.find("const OWED := [")
	var l := fsrc.find("\n]\n", k)
	var foundation_owed := fsrc.substr(k, l - k).count("\n\t\"F")
	var runner := _read_text("res://tests/alignment_smoke.sh")
	var runner_names := runner.find("162 OWED CRITERIA") >= 0 and runner.find("21 RUNNER CHECKS") >= 0
	var ok := names_all and says_distinct and distinct and imprint_owed == 101 \
		and foundation_owed == 85 and runner_names
	_note("A28_the_units_are_named_at_this_surface",
		"this suite names the D-380, D-375 and D-370 counts with their units=%s and says none is a synonym for another=%s | it owes %d EXECUTABLE CHECKS (28 + 7 under D-381 + 5 under D-382), not the inventory's 162 CRITERIA (121 + 25 + 16) nor the runner's 21 RUNNER CHECKS=%s | the accepted suites still owe %d and %d, counted from their own sources | the runner names its own units=%s"
		% [str(names_all), str(says_distinct), OWED.size(), str(distinct), imprint_owed,
		   foundation_owed, str(runner_names)])
	_reached("A28_the_units_are_named_at_this_surface")
	return ok

# ============================================================================
# K. THE D-381 REVIEWABILITY CORRECTION — inside the D-380 stage, still OPEN
# ============================================================================
# The owner: "The large developer panel prevents me from playing and
# understanding the resource behaviour simultaneously." These seven checks prove
# the correction does what was asked and nothing else. The HUD is DIAGNOSTIC
# REVIEW UI, NOT a UI foundation.

## Drives the diagnostic cycle until the live state is `want`. Returns the number
## of cycles it took, or -1 if it never got there.
func _cycle_to(want: String) -> int:
	var n := 0
	while n < 4 and skills.reservation_state() != want:
		skills.cycle_reservation_state()
		n += 1
	return n if skills.reservation_state() == want else -1

## Every Control under a node, for the mouse-filter and font checks.
func _controls_under(n: Node, out: Array) -> void:
	for c in n.get_children():
		if c is Control:
			out.append(c)
		_controls_under(c, out)

## Numeric literals in CODE lines only -- the D-380 lesson: a guard must not
## fire on a history comment.
static func _numeric_literals(code: String) -> Array:
	var re := RegEx.new()
	re.compile("(?<![A-Za-z_0-9.])-?[0-9]+(\\.[0-9]+)?(?![A-Za-z_0-9])")
	var out: Array = []
	for m in re.search_all(_code_only(code)):
		out.append(float(m.get_string()))
	return out

func chk_A29_the_developer_panel_is_hidden_by_default_and_keeps_its_toggle() -> bool:
	# AT LAUNCH, captured before any check ran: the panel hidden, the HUD shown,
	# and -- RE-SCOPED UNDER D-382, one for one -- the F1 overlay HIDDEN too. The
	# owner: "I meant BOTH developer surfaces." Until D-382 this asserted the
	# overlay was UNCHANGED (still on) -- true when written.
	var hidden := not bool(launch["panel_enabled"]) and not bool(launch["panel_visible"])
	# RE-SCOPED UNDER D-392, one for one: the LAUNCH review HUD is now the D-392
	# Splinter Shot HUD, and the D-381 HUD is RETAINED but hidden at launch -- the
	# owner's D-392 ruling: "retain a small playable review HUD showing only
	# information needed to review Splinter Shot, action state and current Prey".
	# Until D-392 this required the D-381 HUD shown at launch -- true when written.
	# Both developer surfaces are STILL hidden, and every toggle below is unchanged.
	var hud_on := not bool(launch["hud_enabled"]) and not bool(launch["hud_visible"]) \
		and bool(launch["d392_hud_enabled"]) and bool(launch["d392_hud_visible"])
	var d392_hud: HuntressReviewHud = main.get("huntress_hud")
	var overlay_hidden := not bool(launch["overlay_enabled"]) and not bool(launch["overlay_visible"])
	# THE EXISTING TOGGLE, THROUGH THE REAL INPUT PATH: the `imprint_panel` action
	# is pressed on a PROCESS frame and the panel's own `_process` reacts to it.
	var toggles_before := panel.toggles
	await process_frame
	Input.action_press("imprint_panel")
	await process_frame
	Input.action_release("imprint_panel")
	await process_frame
	var opened := panel.enabled and panel.visible
	Input.action_press("imprint_panel")
	await process_frame
	Input.action_release("imprint_panel")
	await process_frame
	var closed := not panel.enabled and not panel.visible
	var two_toggles := panel.toggles == toggles_before + 2
	# THE TOGGLE IS THE ONE THAT EXISTED: F2 and pad BACK, as D-375 bound them.
	var keys: Array = []
	for ev in InputMap.action_get_events("imprint_panel"):
		if ev is InputEventKey:
			keys.append((ev as InputEventKey).physical_keycode)
		elif ev is InputEventJoypadButton:
			keys.append("pad%d" % (ev as InputEventJoypadButton).button_index)
	var same_toggle := keys.has(KEY_F2) and keys.size() == 2
	# THE PANEL'S CONTENT IS UNCHANGED: its six rows and six pages (A24 pins them).
	var content_same := LoadoutPanel.ROWS.size() == 6 and LoadoutPanel.PAGES.size() == 6
	# THE PANEL'S TOGGLE LEFT THE OVERLAY ALONE -- the surfaces are INDEPENDENT.
	var overlay_untouched := not overlay.enabled and not overlay.visible
	# D-382: THE OVERLAY'S OWN EXISTING TOGGLE (F1 / pad Y), THROUGH THE REAL INPUT
	# PATH, and it leaves the panel and the HUD alone.
	var ov_toggles_before := overlay.toggles
	await process_frame
	Input.action_press("toggle_overlay")
	await process_frame
	Input.action_release("toggle_overlay")
	await process_frame
	var ov_opened := overlay.enabled and overlay.visible and not panel.enabled \
		and not review_hud.enabled and d392_hud.enabled
	Input.action_press("toggle_overlay")
	await process_frame
	Input.action_release("toggle_overlay")
	await process_frame
	var ov_closed := not overlay.enabled and not overlay.visible \
		and overlay.toggles == ov_toggles_before + 2 and not review_hud.enabled and d392_hud.enabled
	var ov_keys: Array = []
	for ev in InputMap.action_get_events("toggle_overlay"):
		if ev is InputEventKey:
			ov_keys.append((ev as InputEventKey).physical_keycode)
	var ov_same_toggle := ov_keys == [KEY_F1]
	# THE COMPOSITION ROOT SAYS SO IN CODE -- and the guard can fail.
	var src := _code_only(_read_text("res://scripts/foundation_main.gd"))
	var ov_hidden_in_code := src.find("hud.build()\n\thud.set_enabled(false)") >= 0 \
		and src.find("hud.build()\n\thud.set_enabled(true)") < 0
	var at_ready := src.find("imprint_panel.build()\n\t# D-381") >= 0 \
		or src.find("imprint_panel.set_enabled(false)") >= 0
	var no_open := src.find("imprint_panel.build()\n\timprint_panel.set_enabled(true)") < 0
	var planted := src.replace("imprint_panel.set_enabled(false)", "imprint_panel.set_enabled(true)")
	var guard := planted.find("imprint_panel.set_enabled(false)") < 0
	var ok := hidden and hud_on and overlay_hidden and opened and closed and two_toggles \
		and same_toggle and content_same and at_ready and no_open and guard \
		and overlay_untouched and ov_opened and ov_closed and ov_same_toggle and ov_hidden_in_code
	_note("A29_the_developer_panel_is_hidden_by_default_and_keeps_its_toggle",
		"AT LAUNCH: the developer panel is hidden=%s, the D-392 Splinter Shot review HUD is shown and the D-381 HUD is retained but hidden (re-scoped under D-392)=%s, and the F1 overlay is ALSO hidden (D-382)=%s | THROUGH THE REAL INPUT PATH the existing `imprint_panel` action opens it=%s and closes it=%s (exactly 2 toggles=%s), bound as before (F2 + pad BACK: %s)=%s, leaving the overlay untouched=%s | the existing `toggle_overlay` action (F1: %s)=%s opens the overlay=%s and closes it again (exactly 2 toggles)=%s, leaving the panel and the HUD untouched — the two surfaces are INDEPENDENT | its rows and pages are unchanged=%s | the composition root hides the panel=%s and the overlay=%s in code and no longer opens the panel=%s, and the scan refuses a planted re-open=%s"
		% [str(hidden), str(hud_on), str(overlay_hidden), str(opened), str(closed), str(two_toggles),
		   str(keys), str(same_toggle), str(overlay_untouched), str(ov_keys), str(ov_same_toggle),
		   str(ov_opened), str(ov_closed), str(content_same), str(at_ready), str(ov_hidden_in_code),
		   str(no_open), str(guard)])
	_reached("A29_the_developer_panel_is_hidden_by_default_and_keeps_its_toggle")
	return ok

func chk_A30_the_review_hud_is_visible_compact_and_clear_of_the_centre_and_the_overlay() -> bool:
	# ========================================================================
	# RE-SCOPED UNDER D-382: MEASURED IN THE INTENDED 1920 x 1080 REVIEW VIEW.
	# ========================================================================
	# A headless run has a 64 x 64 dummy root window, which `canvas_items` +
	# `expand` stretches into a 1920 x 1920 view -- and at D-381 this check
	# measured THERE (the HUD at y 1696), true but not of the frame the owner
	# plays in. The owner: "correct A30 so its placement assertion evaluates the
	# intended 1920x1080 review viewport". The root is set to 1920 x 1080 for this
	# check and RESTORED after it. The HUD was NOT moved.
	var saved_root_size := root.size
	root.size = Vector2i(1920, 1080)
	# The overlay starts hidden (D-382) and composes its text only while shown, so
	# it is shown for the measurement -- the frame the owner sees after pressing F1.
	var ov_was := overlay.enabled
	overlay.set_enabled(true)
	overlay.refresh()
	review_hud.set_enabled(true)
	review_hud.refresh()
	for i in 4:
		await process_frame
	var view: Rect2 = review_hud.body.get_viewport_rect()
	var is_review_view := view.size == Vector2(1920, 1080) and view.position == Vector2.ZERO
	var r := review_hud.body_rect()
	var area_share := (r.size.x * r.size.y) / maxf(1.0, view.size.x * view.size.y)
	# THE CENTRAL PLAY AREA: the middle half of the screen in each axis.
	var centre := Rect2(view.size * 0.25, view.size * 0.5)
	var clear_of_centre := not r.intersects(centre)
	# The player, where the camera actually projects them.
	var player_px: Vector2 = cam.cam.unproject_position(player.global_position)
	var clear_of_player := not r.has_point(player_px)
	# THE ACCEPTED F1 OVERLAY, which fills the left column when shown (hidden at
	# launch since D-382) -- the first render put the HUD beneath it, found only
	# by looking.
	var ov := overlay.get_node("OverlayPanel") as Control
	var ov_rect := ov.get_global_rect()
	var clear_of_overlay := not r.intersects(ov_rect)
	var inside := view.encloses(r) and r.size.x > 100.0 and r.size.y > 60.0
	var bottom_right := r.position.x > view.size.x * 0.5 and r.position.y > view.size.y * 0.5
	# IT MUST NOT EAT A CLICK: click-to-move is canonical, so every Control in it
	# ignores the mouse.
	var ctrls: Array = []
	_controls_under(review_hud, ctrls)
	var eats: Array[String] = []
	var small: Array[String] = []
	for c in ctrls:
		if (c as Control).mouse_filter != Control.MOUSE_FILTER_IGNORE:
			eats.append(String((c as Control).name))
		if c is Label and (c as Label).get_theme_font_size("font_size") < 14:
			small.append(String((c as Label).name))
	var under_layers := review_hud.layer < overlay.layer and review_hud.layer < panel.layer
	# THE GUARD CAN FAIL: a rectangle in the centre is refused.
	var guard := Rect2(view.size * 0.4, Vector2(100, 100)).intersects(centre)
	# AND THE D-381 FRAME IS REFUSED: the placement it measured (y 1696 in a
	# 1920 x 1920 view) does not fit the 1920 x 1080 review view at all.
	var old_frame_refused := not Rect2(Vector2.ZERO, Vector2(1920, 1080)).encloses(
		Rect2(Vector2(1203, 1696), Vector2(701, 208)))
	overlay.set_enabled(ov_was)
	root.size = saved_root_size
	for i in 2:
		await process_frame
	var restored := root.size == saved_root_size
	var ok := is_review_view and review_hud.enabled and review_hud.visible and inside and clear_of_centre \
		and clear_of_player and clear_of_overlay and bottom_right and area_share <= 0.12 \
		and eats.is_empty() and small.is_empty() and ctrls.size() > 5 and under_layers and guard \
		and old_frame_refused and restored
	_note("A30_the_review_hud_is_visible_compact_and_clear_of_the_centre_and_the_overlay",
		"MEASURED IN THE 1920 x 1080 REVIEW VIEW (D-382)=%s; the D-381 1920 x 1920 placement is refused by it=%s; the headless root restored to %s afterwards=%s | the HUD is shown=%s at %s in a %s view (inside it=%s, bottom-right=%s) | it covers %.1f%% of the screen (<= 12%%) | clear of the central play area %s=%s, of the player at %s=%s, and of the F1 overlay when shown %s=%s | %d Controls, every one MOUSE_FILTER_IGNORE so click-to-move is never eaten (offenders: %s) | no label below 14 px (offenders: %s) | layer %d sits beneath the overlay's %d and the panel's %d=%s | the centre test refuses a planted central rectangle=%s. NOT a UI foundation; its size and place are PROVISIONAL."
		% [str(is_review_view), str(old_frame_refused), str(saved_root_size), str(restored),
		   str(review_hud.visible), str(r), str(view.size), str(inside), str(bottom_right),
		   area_share * 100.0, str(centre), str(clear_of_centre), str(player_px), str(clear_of_player),
		   str(ov_rect), str(clear_of_overlay), ctrls.size(), str(eats), str(small),
		   review_hud.layer, overlay.layer, panel.layer, str(under_layers), str(guard)])
	_reached("A30_the_review_hud_is_visible_compact_and_clear_of_the_centre_and_the_overlay")
	return ok

func chk_A31_the_hud_reads_the_live_gameplay_objects_and_hard_codes_no_value() -> bool:
	# 1. IDENTITY, NOT EQUALITY: the HUD holds the very objects gameplay uses.
	var same_pool := is_same(review_hud.pool_source(), skills.pool)
	var same_health := is_same(review_hud.health_source(), player.life)
	var same_runtime := is_same(review_hud.runtime, skills) and is_same(skills.player, player)
	# 2. GAMEPLAY MOVES IT. A real hit through the player's own damage path...
	var saved_life := player.life.life
	var saved_hits := player.life.hits_taken
	var saved_total := player.life.total_damage
	var saved_events: Array[String] = player.life.events.duplicate()
	player.receive_damage(37.0, player.global_position + Vector3(1, 0, 0))
	var s1 := review_hud.snapshot()
	var hit_seen := is_equal_approx(float(s1["health_current"]), saved_life - 37.0) \
		and is_equal_approx(float(s1["health_current"]), player.life.life)
	player.life.life = saved_life
	player.life.hits_taken = saved_hits
	player.life.total_damage = saved_total
	player.life.events = saved_events
	# ...and a real Skill Use through the live use path.
	skills.pool.refill()
	skills.clear_cooldowns()
	cam.debug_cursor_override = player.global_position + Vector3(0, 0, -6)
	await _phys(2)
	var mana_before := skills.pool.mana_current
	var used: Dictionary = skills.use_binding(0)
	var s2 := review_hud.snapshot()
	var spend_seen: bool = used["ok"] and float(s2["mana_current"]) < mana_before \
		and is_equal_approx(float(s2["mana_current"]), skills.pool.mana_current)
	cam.debug_cursor_override = null
	var g := 0
	while player.commitment.active and g < 120:
		await physics_frame
		g += 1
	skills.pool.refill()
	# 3. PLANTED LIVE VALUES that no constant holds: the HUD must show THEM.
	var saved_mana_max := skills.pool.mana_max
	var saved_max_life := player.life.max_life
	skills.pool.mana_max = 777.0
	player.life.max_life = 432.0
	var s3 := review_hud.snapshot()
	var t3 := review_hud.compose_lines()
	var planted_seen := is_equal_approx(float(s3["mana_max"]), 777.0) \
		and is_equal_approx(float(s3["health_max"]), 432.0) \
		and String(t3["mana"]).find("777 max") >= 0 and String(t3["health"]).find("432 max") >= 0 \
		and is_equal_approx(float(s3["mana_regen"]), skills.pool.regen_per_second())
	skills.pool.mana_max = saved_mana_max
	player.life.max_life = saved_max_life
	skills.pool.refill()
	# 4. EVERY FIELD EQUALS THE LIVE SOURCE, NOW.
	var s := review_hud.snapshot()
	var fields_live := is_equal_approx(float(s["mana_current"]), skills.pool.mana_current) \
		and is_equal_approx(float(s["mana_max"]), skills.pool.mana_max) \
		and is_equal_approx(float(s["mana_reserved"]), skills.pool.mana_reserved) \
		and is_equal_approx(float(s["mana_usable"]), skills.pool.mana_usable()) \
		and is_equal_approx(float(s["mana_regen"]), skills.pool.regen_per_second()) \
		and is_equal_approx(float(s["health_current"]), player.life.life) \
		and is_equal_approx(float(s["health_max"]), player.life.max_life) \
		and is_equal_approx(float(s["health_reserved"]), skills.pool.life_reserved) \
		and is_equal_approx(float(s["health_usable"]), skills.pool.life_usable()) \
		and String(s["state"]) == skills.reservation_state()
	# The two maxima the HUD reads describe ONE Health: a divergence would be shown
	# rather than hidden, and today there is none.
	var one_health := is_equal_approx(player.life.max_life, skills.pool.life_max)
	# 5. THE SOURCE HOLDS NO RESOURCE VALUE: no resource constant is referenced,
	# and no numeric literal in CODE equals one.
	var src := _read_text("res://scripts/imprint/review_hud.gd")
	var code := _code_only(src)
	var refs: Array[String] = []
	for tok in ["MANA_MAX", "LIFE_MAX", "MANA_REGEN", "AURA_RESERVE", "LIFE_CONVERSION",
			"Damageable.new", "ResourcePool.new"]:
		if code.find(String(tok)) >= 0:
			refs.append(String(tok))
	var resource_values := [ImprintConfig.MANA_MAX, ImprintConfig.LIFE_MAX,
		ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S, ImprintConfig.LIFE_CONVERSION_RATIO_AT_RANK_1,
		ImprintConfig.AURA_RESERVE_FRACTION_AT_RANK_1, ImprintConfig.MANA_MAX * ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S,
		saved_max_life]
	var literal_hits: Array = []
	for v in _numeric_literals(src):
		for rv in resource_values:
			if is_equal_approx(float(v), float(rv)):
				literal_hits.append(v)
	# THE SCAN CAN FAIL on a planted CODE line, and IGNORES a planted COMMENT.
	var caught := false
	for v in _numeric_literals(src + "\n\tvar shown_max := 500.0\n"):
		if is_equal_approx(float(v), ImprintConfig.MANA_MAX):
			caught = true
	var ignored := true
	for v in _numeric_literals(src + "\n\t# the max was 500.0 once\n"):
		if is_equal_approx(float(v), ImprintConfig.MANA_MAX):
			ignored = false
	var ok := same_pool and same_health and same_runtime and hit_seen and spend_seen \
		and planted_seen and fields_live and one_health and refs.is_empty() and literal_hits.is_empty() \
		and caught and ignored
	_note("A31_the_hud_reads_the_live_gameplay_objects_and_hard_codes_no_value",
		"IDENTITY: the HUD's Mana source IS the SkillRuntime pool=%s, its Health source IS the player's Damageable=%s, its runtime IS the scene's=%s | GAMEPLAY MOVES IT: a 37-point hit through receive_damage() shows at once=%s; a real Skill Use through use_binding() shows its spend=%s | PLANTED LIVE VALUES no constant holds (Mana max 777, Health max 432) are what it shows=%s | every field equals its live source now=%s, and the two Health maxima agree=%s | its CODE references no resource constant (found: %s) and no numeric literal in it equals a resource value (found: %s) — the scan catches a planted code literal=%s and ignores a planted comment=%s. THE HUD OWNS NO NUMBER."
		% [str(same_pool), str(same_health), str(same_runtime), str(hit_seen), str(spend_seen),
		   str(planted_seen), str(fields_live), str(one_health), str(refs), str(literal_hits),
		   str(caught), str(ignored)])
	_reached("A31_the_hud_reads_the_live_gameplay_objects_and_hard_codes_no_value")
	return ok

func chk_A32_reserved_segments_are_patterned_and_bounded_in_every_reservation_state() -> bool:
	var rows: Array[String] = []
	var all_ok := true
	var saw := {}
	for want in ["OFF", "MANA RESERVATION", "LIFE CONVERSION"]:
		var reached_state := _cycle_to(String(want)) >= 0
		skills.pool.refill()
		review_hud.refresh()
		var m := review_hud.bar_model("mana")
		var h := review_hud.bar_model("health")
		var m_res := _segment(m, "reserved")
		var h_res := _segment(h, "reserved")
		var ok_state := reached_state
		match String(want):
			"OFF":
				ok_state = ok_state and m_res.is_empty() and h_res.is_empty() \
					and is_zero_approx(skills.pool.mana_reserved) and is_zero_approx(skills.pool.life_reserved)
			"MANA RESERVATION":
				ok_state = ok_state and h_res.is_empty() and _patterned(m, skills.pool.mana_usable(),
					skills.pool.mana_max) and skills.pool.mana_reserved > 0.0
			"LIFE CONVERSION":
				ok_state = ok_state and m_res.is_empty() and _patterned(h, skills.pool.life_usable(),
					player.life.max_life) and skills.pool.life_reserved > 0.0
		ok_state = ok_state and not skills.pool.reserves_both()
		# WHAT IS DRAWN IS WHAT IS MODELLED: the bars carry exactly these models.
		ok_state = ok_state and review_hud.mana_bar.model == m and review_hud.health_bar.model == h
		# THE STATE LINE NAMES THE STATE, AND THE PAID RESOURCE.
		var line := String(review_hud.compose_lines()["state"])
		var names_it := line.find("RESERVATION: %s" % want) >= 0
		if String(want) == "MANA RESERVATION":
			names_it = names_it and line.find("paid from Mana") >= 0
		elif String(want) == "LIFE CONVERSION":
			names_it = names_it and line.find("Mana reserves 0") >= 0
		ok_state = ok_state and names_it
		saw[want] = ok_state
		all_ok = all_ok and ok_state
		rows.append("%s: mana reserved %.1f (segment %s), health reserved %.1f (segment %s)=%s"
			% [want, skills.pool.mana_reserved, str(not m_res.is_empty()), skills.pool.life_reserved,
			   str(not h_res.is_empty()), str(ok_state)])
	# ========================================================================
	# RE-SCOPED UNDER D-382, ONE FOR ONE. At D-381 this block asserted the
	# DISCLOSED LIMIT (AD-11): in LIFE CONVERSION full live Health sat ABOVE usable
	# Health and the HUD warned -- true when written. The owner then ruled that a
	# Life reservation must lower live Health, so the SAME state now asserts the
	# opposite: live Health is CLAMPED to usable Health and the HUD is quiet. The
	# alarm itself is kept, and is PROVED still able to fire if the rule breaks.
	# ========================================================================
	player.life.reset()
	_cycle_to("LIFE CONVERSION")
	review_hud.refresh()
	var h2 := review_hud.bar_model("health")
	var exceeds: bool = h2["current_exceeds_usable"]
	var clamped := is_equal_approx(player.life.life, skills.pool.life_usable())
	var warns := String(review_hud.compose_lines()["warning"]) != ""
	# A BROKEN INVARIANT IS STILL REPORTED: bypass the ceiling on purpose, and the
	# HUD raises its alarm; restoring the ceiling from the pool clamps it back.
	player.life.ceiling = INF
	player.life.life = player.life.max_life
	var alarm := String(review_hud.compose_lines()["warning"]).find("INVARIANT BROKEN") >= 0
	skills.pool.set_reservation(skills.pool.mana_reserved, skills.pool.life_reserved)
	var quiet := String(review_hud.compose_lines()["warning"]) == "" \
		and is_equal_approx(player.life.life, skills.pool.life_usable())
	var disclosed := false
	for d in ImprintConfig.reviewability_denials():
		if String(d).find("RESOLVED UNDER D-382") >= 0 \
				and String(d).find("current Health = min(current Health, usable Health)") >= 0:
			disclosed = true
	# NOT COLOUR ALONE: three distinct SHAPE cues, none of them a colour.
	var src := _code_only(_read_text("res://scripts/imprint/review_hud.gd"))
	var shapes := src.find("\"hatched\"") >= 0 and src.find("\"tick\"") >= 0 \
		and src.find("\"RESERVED\"") >= 0 and src.find("draw_line(") >= 0
	# BACK TO THE LAUNCH STATE.
	var restored := _cycle_to(String(launch["state"])) >= 0 \
		and is_equal_approx(skills.pool.mana_reserved, float(launch["mana_reserved"]))
	skills.pool.refill()
	# THE GUARD CAN FAIL: a model with no reserved segment is not "patterned".
	var guard := not _patterned({"segments": [], "usable_fraction": 0.5, "reserved": 10.0}, 50.0, 100.0)
	var ok := all_ok and saw.size() == 3 and not exceeds and clamped and not warns and alarm \
		and quiet and disclosed and shapes and restored and guard
	_note("A32_reserved_segments_are_patterned_and_bounded_in_every_reservation_state",
		"%s | NOT COLOUR ALONE: the reserved zone is HATCHED, bounded by a TICK and LABELLED 'RESERVED' in the drawing code=%s | AD-11, RESOLVED UNDER D-382: with LIFE CONVERSION entered at full Health, live Health exceeds usable Health=%s (must be false) because it is CLAMPED to it=%s, and the HUD warns=%s (must be false); the alarm still fires on a deliberately broken invariant=%s and goes quiet once the pool restores the ceiling=%s; the denials state the resolution=%s | back at the launch state (%s) with the launch reservation=%s | a model without a reserved segment is refused=%s"
		% [" · ".join(rows), str(shapes), str(exceeds), str(clamped), str(warns), str(alarm),
		   str(quiet), str(disclosed),
		   String(launch["state"]), str(restored), str(guard)])
	_reached("A32_reserved_segments_are_patterned_and_bounded_in_every_reservation_state")
	return ok

func _segment(model: Dictionary, part: String) -> Dictionary:
	for seg in model.get("segments", []):
		if String(seg["part"]) == part:
			return seg
	return {}

## A reserved segment that is HATCHED, starts EXACTLY at the usable boundary,
## runs to the end, and has a TICK at that boundary.
func _patterned(model: Dictionary, usable: float, maximum: float) -> bool:
	var res := _segment(model, "reserved")
	var tick := _segment(model, "usable_boundary")
	if res.is_empty() or tick.is_empty() or maximum <= 0.0:
		return false
	var at := usable / maximum
	return String(res["pattern"]) == "hatched" and is_equal_approx(float(res["from"]), at) \
		and is_equal_approx(float(res["to"]), 1.0) and String(tick["pattern"]) == "tick" \
		and is_equal_approx(float(tick["at"]), at) \
		and is_equal_approx(float(model["reserved_fraction"]), 1.0 - at)

func chk_A33_one_diagnostic_input_cycles_off_mana_life_off_through_the_real_input_path() -> bool:
	var action := SkillRuntime.RESERVATION_CYCLE_ACTION
	# EXACTLY ONE NEW ACTION, bound to ONE key and ONE pad button, and neither is
	# bound to anything else.
	var keys: Array = []
	var pads: Array = []
	for ev in InputMap.action_get_events(action):
		if ev is InputEventKey:
			keys.append((ev as InputEventKey).physical_keycode)
		elif ev is InputEventJoypadButton:
			pads.append((ev as InputEventJoypadButton).button_index)
	var bound := keys == [KEY_R] and pads == [JOY_BUTTON_RIGHT_STICK]
	var clashes: Array[String] = []
	for a in InputMap.get_actions():
		if String(a) == action or String(a).begins_with("ui_"):
			continue
		for ev in InputMap.action_get_events(a):
			if ev is InputEventKey and (ev as InputEventKey).physical_keycode == KEY_R:
				clashes.append(String(a))
			elif ev is InputEventJoypadButton and (ev as InputEventJoypadButton).button_index == JOY_BUTTON_RIGHT_STICK:
				clashes.append(String(a))
	# THE REAL INPUT PATH: the action pressed on a PHYSICS frame, read by the
	# SkillRuntime's own _physics_process -- the path a key press takes.
	var start := skills.reservation_state()
	var seq: Array[String] = [start]
	var per_press_ok := true
	for i in 3:
		var before := skills.reservation_cycles
		await physics_frame
		Input.action_press(action)
		await physics_frame
		await physics_frame              # HELD for two frames: must still fire ONCE
		Input.action_release(action)
		await physics_frame
		if skills.reservation_cycles != before + 1:
			per_press_ok = false
		seq.append(skills.reservation_state())
	var order := ["OFF", "MANA RESERVATION", "LIFE CONVERSION"]
	var steps_ok := true
	for i in 3:
		var a := order.find(seq[i])
		var b := order.find(seq[i + 1])
		if a < 0 or b != (a + 1) % 3:
			steps_ok = false
	var full_circle := seq[3] == start
	# EACH STATE IS THE POOL'S TRUTH, not a label.
	var truths: Array[String] = []
	for want in order:
		_cycle_to(String(want))
		var mr := skills.pool.mana_reserved
		var lr := skills.pool.life_reserved
		var t := false
		match String(want):
			"OFF": t = is_zero_approx(mr) and is_zero_approx(lr)
			"MANA RESERVATION": t = mr > 0.0 and is_zero_approx(lr)
			"LIFE CONVERSION": t = lr > 0.0 and is_zero_approx(mr)
		truths.append("%s=%s" % [want, str(t)])
	var truths_ok := truths.all(func(x): return String(x).ends_with("=true"))
	# THE SAFE-STATE GATE STILL APPLIES: with the diagnostic override OFF and an
	# action committed, a press is REFUSED, counted, and changes nothing.
	_cycle_to(String(launch["state"]))
	skills.set_safe_state_override(false)
	skills.clear_cooldowns()
	player.begin_attack()
	var committed := player.commitment.active
	var refused_before := skills.edits_refused
	var state_before := skills.reservation_state()
	skills.cycle_reservation_state()
	var gated := committed and skills.edits_refused == refused_before + 1 \
		and skills.reservation_state() == state_before
	var shows_refusal := String(review_hud.compose_lines()["hint"]).find("REFUSED") >= 0
	skills.set_safe_state_override(true)
	var g := 0
	while player.commitment.active and g < 120:
		await physics_frame
		g += 1
	skills.last_reservation_result = ""
	# THE HINT IS DERIVED FROM THE INPUT MAP: add a key, and the hint names it.
	var hint := review_hud.control_hint()
	var names_now := hint.find("R") >= 0 and hint.find("OFF → MANA RESERVATION → LIFE CONVERSION → OFF") >= 0
	var extra := InputEventKey.new()
	extra.physical_keycode = KEY_F9
	InputMap.action_add_event(action, extra)
	var follows := review_hud.control_hint().find("F9") >= 0
	InputMap.action_erase_event(action, extra)
	var back := review_hud.control_hint() == hint
	var ok := bound and clashes.is_empty() and per_press_ok and steps_ok and full_circle \
		and truths_ok and gated and shows_refusal and names_now and follows and back \
		and skills.reservation_state() == String(launch["state"])
	_note("A33_one_diagnostic_input_cycles_off_mana_life_off_through_the_real_input_path",
		"ONE diagnostic action `%s`, bound to key R and the pad's right-stick click only=%s, clashing with no other action (clashes: %s) | THROUGH THE REAL INPUT PATH, three presses — each HELD two physics frames — gave %s: one cycle per press=%s, each step OFF → MANA RESERVATION → LIFE CONVERSION → OFF=%s, and back where it began=%s | each state is the POOL'S truth: %s | the canonical safe-state gate still applies — with the override off and an action committed the press is REFUSED and counted, and nothing changes=%s, and the HUD says REFUSED=%s | the hint is derived from the InputMap: it names R and the cycle=%s, names an added key at once=%s, and returns when it is removed=%s"
		% [action, str(bound), str(clashes), str(seq), str(per_press_ok), str(steps_ok),
		   str(full_circle), str(truths), str(gated), str(shows_refusal), str(names_now),
		   str(follows), str(back)])
	_reached("A33_one_diagnostic_input_cycles_off_mana_life_off_through_the_real_input_path")
	return ok

func chk_A34_learning_truth_and_the_configuration_count_are_live_and_do_not_overclaim() -> bool:
	var lib := skills.library
	var lo := skills.loadout
	var s := review_hud.snapshot()
	var t := review_hud.compose_lines()
	# LEARNING TRUTH, counted from the live acquisition records and seeds.
	var at_rank_1 := 0
	var seeded := 0
	for id in lib.ids():
		var rec := lib.acquisition_record(String(id))
		if int(rec.get("rank", -1)) == 1 and is_zero_approx(float(rec.get("xp", -1.0))):
			at_rank_1 += 1
		if lib.seeded_rank(String(id)) > 1:
			seeded += 1
	var counts_live := int(s["learned"]) == lib.count() and int(s["learned_at_rank_1"]) == at_rank_1 \
		and int(s["pre_earned"]) == seeded and at_rank_1 == lib.count()
	var imprint_line := String(t["imprints"])
	var says_rule := imprint_line.find("newly learned = Rank 1 · 0 XP") >= 0 \
		and imprint_line.find("DIAGNOSTIC PRE-EARNED PROGRESS") >= 0 \
		and imprint_line.find("(%d of %d)" % [at_rank_1, lib.count()]) >= 0
	# A PLANTED acquisition record at rank 3 is COUNTED against the rule, not hidden.
	var first := String(lib.ids()[0])
	var saved: Dictionary = lib._acquired[first].duplicate()
	lib._acquired[first] = {"rank": 3, "xp": 0.0}
	var dropped := int(review_hud.snapshot()["learned_at_rank_1"]) == lib.count() - 1
	lib._acquired[first] = saved
	# CONFIGURATIONS, from the live loadout: equipped of the canonical bindings.
	var cfg_line := String(t["configurations"])
	var cfg_live := int(s["equipped"]) == lo.equipped_active_count() and int(s["bindings"]) == lo.binding_count() \
		and cfg_line.find("%d equipped / %d supported" % [lo.equipped_active_count(), lo.binding_count()]) >= 0 \
		and cfg_line.find("diagnostic, not production Skills") >= 0
	# Unbinding one Configuration moves the count at once; rebinding restores it.
	var bindings_before: Array = lo.bindings.duplicate()
	var cid := String(lo.bindings[0])
	lo.unbind(0)
	lo.revalidate(skills.pool)
	var moved := String(review_hud.compose_lines()["configurations"]).find(
		"%d equipped / %d supported" % [lo.equipped_active_count(), lo.binding_count()]) >= 0 \
		and lo.equipped_active_count() == int(s["equipped"]) - 1
	lo.bind(0, cid)
	lo.revalidate(skills.pool)
	skills.pool.refill()
	var restored: bool = lo.bindings == bindings_before and lo.equipped_active_count() == int(s["equipped"])
	# IT DOES NOT IMPLY THAT EIGHT PRODUCTION SKILLS EXIST.
	var all_text := "\n".join(PackedStringArray(review_hud.compose_lines().values()))
	var forbidden := ["8 skills", "eight skills", "8 production", "production skills exist",
		"huntress", "skill roster", "8 equipped"]
	var found: Array[String] = []
	for f in forbidden:
		if all_text.findn(String(f)) >= 0:
			found.append(String(f))
	var guard := false
	for f in forbidden:
		if (all_text + "\nEight Skills are ready").findn(String(f)) >= 0:
			guard = true
	var ok := counts_live and says_rule and dropped and cfg_live and moved and restored \
		and found.is_empty() and guard
	_note("A34_learning_truth_and_the_configuration_count_are_live_and_do_not_overclaim",
		"LEARNING: '%s' — counted from the live acquisition records (%d of %d at rank 1 / 0 XP) and seeds (%d DIAGNOSTIC PRE-EARNED)=%s, stated as the rule=%s; a planted rank-3 acquisition record is counted AGAINST it=%s | CONFIGURATIONS: '%s' — from the live loadout=%s; unbinding one moves it at once=%s and rebinding restores the loadout exactly=%s | it claims no eight production Skills (found: %s; the scan refuses a planted claim=%s)"
		% [imprint_line, at_rank_1, lib.count(), seeded, str(counts_live), str(says_rule), str(dropped),
		   cfg_line, str(cfg_live), str(moved), str(restored), str(found), str(guard)])
	_reached("A34_learning_truth_and_the_configuration_count_are_live_and_do_not_overclaim")
	return ok

func chk_A35_the_correction_adds_no_content_or_tuning_and_preserves_d380_behaviour() -> bool:
	# LOSSLESS: a full cycle returns EXACTLY the launch reservation and regen.
	_cycle_to(String(launch["state"]))
	skills.pool.refill()
	var mana0 := skills.pool.mana_reserved
	var life0 := skills.pool.life_reserved
	var regen0 := skills.pool.regen_per_second()
	for i in 3:
		skills.cycle_reservation_state()
	skills.pool.refill()
	var lossless := is_equal_approx(skills.pool.mana_reserved, mana0) \
		and is_equal_approx(skills.pool.life_reserved, life0) \
		and is_equal_approx(skills.pool.regen_per_second(), regen0) \
		and is_equal_approx(mana0, float(launch["mana_reserved"])) \
		and skills.reservation_state() == String(launch["state"])
	# THE CYCLE ADDS NO RULE: its body uses ONLY operations that already existed.
	var rt := _read_text("res://scripts/imprint/skill_runtime.gd")
	var i := rt.find("func cycle_reservation_state()")
	var j := rt.find("\n# ====", i)
	var body := _code_only(rt.substr(i, j - i))
	var uses_existing := body.find("request_edit(") >= 0 and body.find("loadout.revalidate(pool)") >= 0 \
		and body.find(".install(") >= 0 and body.find(".remove(") >= 0 \
		and body.find("add_persistent(") >= 0 and body.find("remove_persistent(") >= 0
	var writes_pool := body.find("pool.mana_") >= 0 or body.find("pool.life_") >= 0 \
		or body.find("set_reservation(") >= 0
	# NO NEW NUMERIC TUNING CONSTANT in the two changed rule-bearing scripts.
	var numeric_new: Array[String] = []
	for path in ["res://scripts/imprint/skill_runtime.gd", "res://scripts/imprint/review_hud.gd"]:
		var cm := _constants(path)
		for k in cm.keys():
			if typeof(cm[k]) == TYPE_FLOAT or typeof(cm[k]) == TYPE_INT:
				numeric_new.append("%s.%s" % [String(path).get_file(), String(k)])
	# NO NEW CONTENT, ASSET OR SCENE (A26 pins the rest), and the HUD script is
	# DIAGNOSTIC: it declares no inventory, Skill menu or character sheet.
	var hud_code := _code_only(_read_text("res://scripts/imprint/review_hud.gd")).to_lower()
	var ui_found := _declarations_naming(hud_code, ["inventory", "skill_menu", "character_sheet",
		"equipment", "item"])
	var imports := hud_code.find("load(") >= 0 or hud_code.find("preload(") >= 0 \
		or hud_code.find("res://") >= 0
	# THE CORRECTION'S OWN DENIALS: present, disclosing WHY, and printed.
	var d := ImprintConfig.reviewability_denials()
	var joined := "\n".join(d)
	var needles := ["NOT HUMAN-REVIEWABLE DURING PLAY", "IS NOT a production UI foundation",
		"OWNS NO NUMBER", "EXACTLY ONE diagnostic input action", "NO tuning change",
		"HIDES the developer panel by default", "RESOLVED UNDER D-382",
		"D-382 changes NO tuning value", "the F1 overlay ALSO starts hidden"]
	# RE-SCOPED UNDER D-382, one for one: the needle "DISCLOSED, NOT FIXED" became
	# "RESOLVED UNDER D-382" because the denial it pinned is no longer true, and
	# two needles were added for the D-382 denial and the overlay. 7 + 2 = 9
	# needles; 7 + 1 = 8 denials.
	var missing: Array[String] = []
	for n in needles:
		if joined.find(String(n)) < 0:
			missing.append(String(n))
	var printed := _read_text("res://scripts/foundation_main.gd").find("ImprintConfig.reviewability_denials()") >= 0
	# THE STATE: RE-PINNED UNDER D-392 (first act). Until D-392 this asserted
	# "the correction accepts nothing: D-380 stays DELIVERED and OPEN" -- TRUE
	# WHEN WRITTEN. D-383 accepted and closed the stage; the D-392 ruling
	# reconciled the line. The correction STILL accepted nothing of its own: the
	# acceptance is D-383's, and the line must now say so -- and must not still
	# carry the D-380-era clause.
	var state_same := ProdConfig.STATE.find("D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383)") >= 0 \
		and ProdConfig.STATE.find("D-378 ALIGNMENT STAGE DELIVERED and OPEN") < 0
	# THE GUARD CAN FAIL: a planted rule-bearing pool write is seen.
	var guard := ("\n\tpool.mana_reserved = 0.0\n").find("pool.mana_") >= 0
	var ok := lossless and uses_existing and not writes_pool and numeric_new.is_empty() \
		and ui_found.is_empty() and not imports and missing.is_empty() and d.size() == 8 \
		and printed and state_same and guard
	_note("A35_the_correction_adds_no_content_or_tuning_and_preserves_d380_behaviour",
		"a full OFF → MANA → LIFE → OFF cycle is LOSSLESS — the launch reservation (%.2f Mana) and regeneration (%.2f/s) return exactly=%s | the cycle uses ONLY pre-existing operations (the safe-state gate, install/remove, add/remove Persistent, revalidate)=%s and writes the pool directly nowhere=%s | NO numeric constant was added to the runtime or the HUD (found: %s) | the HUD declares no inventory, Skill menu, character sheet, equipment or item (found: %s) and loads no resource or asset=%s | %d D-381/D-382 denials (7 + 1), disclosing why the correction exists, all load-bearing phrases present (missing: %s), printed in the banner=%s | the state line reads D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383) and no longer the D-380-era clause (re-pinned under D-392)=%s | the pool-write scan sees a planted one=%s"
		% [mana0, regen0, str(lossless), str(uses_existing), str(not writes_pool), str(numeric_new),
		   str(ui_found), str(not imports), d.size(), str(missing), str(printed), str(state_same), str(guard)])
	_reached("A35_the_correction_adds_no_content_or_tuning_and_preserves_d380_behaviour")
	return ok

# ============================================================================
# L. D-382 — A LIFE RESERVATION GOVERNS LIVE HEALTH (the owner's ruling on AD-11)
# ============================================================================
# The owner: "Life reservation must affect live Health correctly. When a Life
# reservation is activated or increased: current_health = min(current_health,
# usable_health). This must happen in the same state transition that changes the
# reservation. When Life reservation is removed or reduced: usable Health
# increases; current Health does not automatically increase; removing a
# reservation is not healing. Healing must remain capped by usable Health."
#
# PREMISE, READ IN CODE: there is NO healing mechanic in `game3d/` -- nothing in
# the runtime raises live Health. The ledger's only raise path is
# `Damageable.reset()`, which the verification harness uses. The cap is therefore
# enforced at the LEDGER, on every write that would raise live Health, and A38
# proves it on `reset()` and on a direct write standing in for any future heal.

## The live state at FULL Health with NO Life reserved.
func _full_health_off() -> void:
	_cycle_to("OFF")
	player.life.reset()
	skills.pool.refill()

## Cycles the aura's Effective Rank until it equals `want`. Returns false if the
## cycle never reaches it.
func _aura_rank_to(want: int) -> bool:
	var cfg := skills.loadout.configuration(DiagImprintContent.CFG_AURA) as SkillConfiguration
	var n := 0
	while n < 4 and cfg.effective_rank(cfg.skill_id) != want:
		skills.cycle_effective_rank(DiagImprintContent.CFG_AURA)
		n += 1
	return cfg.effective_rank(cfg.skill_id) == want

func _aura_rank() -> int:
	var cfg := skills.loadout.configuration(DiagImprintContent.CFG_AURA) as SkillConfiguration
	return cfg.effective_rank(cfg.skill_id)

func chk_A36_entering_life_conversion_clamps_live_health_in_the_same_transition() -> bool:
	# THE LINK: the LIVE pool governs the player's own ledger; a scratch pool none.
	var linked := is_same(skills.pool.health, player.life)
	var scratch_unlinked := ResourcePool.new().health == null
	var launch_rank := _aura_rank()
	# 1. MANA RESERVATION -> LIFE CONVERSION at FULL Health, and NO frame elapses
	#    between the call and the reading: the SAME transition.
	_full_health_off()
	_cycle_to("MANA RESERVATION")
	var full := player.life.life
	var hits0 := player.life.hits_taken
	var dmg0 := player.life.total_damage
	var clamps0 := player.life.ceiling_clamps
	skills.cycle_reservation_state()
	var usable := skills.pool.life_usable()
	var same_transition := skills.reservation_state() == "LIFE CONVERSION" \
		and is_equal_approx(full, player.life.max_life) and usable < full \
		and is_equal_approx(player.life.life, usable) and is_equal_approx(player.life.ceiling, usable)
	# A CEILING CHANGE, NOT DAMAGE: no hit, no damage total, no death.
	var not_damage := player.life.hits_taken == hits0 \
		and is_equal_approx(player.life.total_damage, dmg0) and not player.life.dead \
		and player.life.ceiling_clamps == clamps0 + 1
	# 2. THROUGH THE REAL INPUT PATH: R pressed on a physics frame at full Health.
	#    The SAME press pattern A33 proves: held two physics frames, released, one
	#    frame to settle, then read. (The first final run of D-382 read after ONE
	#    held frame, before the press had been processed, and failed here while the
	#    runtime was right -- a throwaway probe showed the press land a frame later
	#    with Health clamped to usable. Disclosed in the D-382 report.)
	_full_health_off()
	_cycle_to("MANA RESERVATION")
	player.life.reset()
	var cycles_before := skills.reservation_cycles
	await physics_frame
	Input.action_press(SkillRuntime.RESERVATION_CYCLE_ACTION)
	await physics_frame
	await physics_frame
	Input.action_release(SkillRuntime.RESERVATION_CYCLE_ACTION)
	await physics_frame
	var via_input := skills.reservation_cycles == cycles_before + 1 \
		and skills.reservation_state() == "LIFE CONVERSION" \
		and is_equal_approx(player.life.life, skills.pool.life_usable()) \
		and skills.pool.life_usable() < player.life.max_life
	# 3. THROUGH THE PANEL'S EXISTING ROW (`set_life_tithe`) at full Health.
	_full_health_off()
	_cycle_to("MANA RESERVATION")
	player.life.reset()
	skills.set_life_tithe(true)
	var via_panel := skills.reservation_state() == "LIFE CONVERSION" \
		and is_equal_approx(player.life.life, skills.pool.life_usable())
	# 4. INCREASED: LIFE CONVERSION at Effective Rank 1, then raised twice. Each
	#    increase clamps live Health FURTHER, in the call that raised it.
	var at_low := _aura_rank_to(ImprintConfig.RANK_MIN)
	player.life.reset()
	var u1 := skills.pool.life_usable()
	var full_at_u1 := is_equal_approx(player.life.life, u1)
	var steps: Array[String] = []
	var increases_clamp := at_low and full_at_u1
	for i in 2:
		var reserved_before := skills.pool.life_reserved
		skills.cycle_effective_rank(DiagImprintContent.CFG_AURA)
		var grew := skills.pool.life_reserved > reserved_before + 0.001
		var ok_step := grew and is_equal_approx(player.life.life, skills.pool.life_usable())
		steps.append("rank %d: reserved %.1f -> usable %.1f, Health %.1f=%s"
			% [_aura_rank(), skills.pool.life_reserved, skills.pool.life_usable(), player.life.life, str(ok_step)])
		increases_clamp = increases_clamp and ok_step
	# THE GUARD CAN FAIL, BOTH WAYS: an UNLINKED scratch ledger is untouched when
	# a scratch pool reserves Life, and the same ledger IS clamped once linked.
	var s_pool := ResourcePool.new()
	var s_life := Damageable.new(300.0)
	s_pool.set_reservation(0.0, 90.0)
	var unlinked_untouched := is_equal_approx(s_life.life, 300.0)
	s_pool.health = s_life
	s_pool.set_reservation(0.0, 90.0)
	var linked_clamps := is_equal_approx(s_life.life, 210.0)
	# BACK TO LAUNCH: the launch rank, the launch state, full Health.
	_aura_rank_to(launch_rank)
	_full_health_off()
	_cycle_to(String(launch["state"]))
	player.life.reset()
	var ok := linked and scratch_unlinked and same_transition and not_damage and via_input \
		and via_panel and increases_clamp and unlinked_untouched and linked_clamps \
		and _aura_rank() == launch_rank
	_note("A36_entering_life_conversion_clamps_live_health_in_the_same_transition",
		"the LIVE pool governs the player's own Health ledger=%s, a scratch pool governs none=%s | entering LIFE CONVERSION at FULL Health (%.1f) sets live Health to the new usable %.1f in the SAME call, with no frame elapsed=%s — a ceiling change, NOT damage (no hit, no damage total, no death)=%s | through the REAL input path (R on a physics frame)=%s and through the panel's existing row=%s | INCREASED: from Effective Rank 1 (usable %.1f, full)=%s each raise clamps FURTHER: %s | the guard sees both ways: an unlinked ledger stays at 300=%s and the same ledger, once linked, is clamped to 210=%s | restored to rank %d and the launch state"
		% [str(linked), str(scratch_unlinked), full, usable, str(same_transition), str(not_damage),
		   str(via_input), str(via_panel), u1, str(full_at_u1), " · ".join(steps),
		   str(unlinked_untouched), str(linked_clamps), launch_rank])
	_reached("A36_entering_life_conversion_clamps_live_health_in_the_same_transition")
	return ok

func chk_A37_removing_or_reducing_the_reservation_does_not_heal() -> bool:
	var launch_rank := _aura_rank()
	# REMOVED: clamped in LIFE CONVERSION, then OFF. Usable rises; Health stays.
	_full_health_off()
	_cycle_to("LIFE CONVERSION")
	var clamped := player.life.life
	var usable_in := skills.pool.life_usable()
	var was_clamped := is_equal_approx(clamped, usable_in) and clamped < player.life.max_life
	skills.cycle_reservation_state()          # LIFE CONVERSION -> OFF
	var removed_fired := skills.reservation_state() == "OFF" and is_zero_approx(skills.pool.life_reserved)
	var not_healed_off := is_equal_approx(player.life.life, clamped) \
		and is_equal_approx(skills.pool.life_usable(), player.life.max_life) \
		and is_equal_approx(player.life.ceiling, player.life.max_life)
	# AND TIME HEALS NOTHING EITHER: sixty physics frames later it is unchanged.
	await _phys(60)
	var still := is_equal_approx(player.life.life, clamped)
	# REMOVED through the panel's row instead: LIFE -> MANA RESERVATION.
	_full_health_off()
	_cycle_to("LIFE CONVERSION")
	var clamped2 := player.life.life
	skills.set_life_tithe(false)
	var panel_fired := skills.reservation_state() == "MANA RESERVATION" and is_zero_approx(skills.pool.life_reserved)
	var not_healed_panel := is_equal_approx(player.life.life, clamped2)
	# REDUCED, not removed: LIFE CONVERSION at the maximum rank, then rank 1.
	_full_health_off()
	_cycle_to("LIFE CONVERSION")
	var at_cap := _aura_rank_to(skills.library.mastered(DiagImprintContent.SKILL_AURA))
	player.life.reset()
	var clamped3 := player.life.life
	var reserved_hi := skills.pool.life_reserved
	_aura_rank_to(ImprintConfig.RANK_MIN)
	var reduced_fired := skills.pool.life_reserved < reserved_hi - 0.001 \
		and skills.pool.life_usable() > clamped3 + 0.001
	var not_healed_reduced := is_equal_approx(player.life.life, clamped3)
	# THE GUARD CAN FAIL: a ledger that DID heal on removal is refused.
	var g := Damageable.new(300.0)
	g.set_ceiling(200.0)
	g.set_ceiling(300.0)
	var guard := is_equal_approx(g.life, 200.0) and not is_equal_approx(g.life, 300.0)
	_aura_rank_to(launch_rank)
	_full_health_off()
	_cycle_to(String(launch["state"]))
	player.life.reset()
	var ok := was_clamped and removed_fired and not_healed_off and still and panel_fired \
		and not_healed_panel and at_cap and reduced_fired and not_healed_reduced and guard
	_note("A37_removing_or_reducing_the_reservation_does_not_heal",
		"clamped in LIFE CONVERSION at %.1f=%s | REMOVED through the cycle (fired=%s): usable rose to %.1f and live Health stayed %.1f=%s, and sixty physics frames later still had not risen=%s | REMOVED through the panel's row (fired=%s): Health stayed=%s | REDUCED from the maximum rank to rank 1 (fired=%s): usable rose above %.1f and Health stayed=%s | REMOVING A RESERVATION IS NOT HEALING | the guard: a ledger whose ceiling rises from 200 to 300 stays at 200=%s"
		% [clamped, str(was_clamped), str(removed_fired), player.life.max_life, clamped,
		   str(not_healed_off), str(still), str(panel_fired), str(not_healed_panel),
		   str(reduced_fired), clamped3, str(not_healed_reduced), str(guard)])
	_reached("A37_removing_or_reducing_the_reservation_does_not_heal")
	return ok

func chk_A38_damage_and_every_raise_of_live_health_respect_usable_health() -> bool:
	# THE PREMISE, READ IN CODE: no runtime script declares a healing function.
	var heal_decls: Array[String] = []
	for f in _runtime_script_files():
		for t in _declarations_naming(_code_only(_read_text(String(f))).to_lower(), ["heal"]):
			heal_decls.append("%s: %s" % [String(f).get_file(), t])
	var scan_can_fail := _declarations_naming("func heal(amount: float) -> void:", ["heal"]).size() == 1
	# DAMAGE, while Life is reserved: it comes off the CLAMPED value, normally.
	_full_health_off()
	_cycle_to("LIFE CONVERSION")
	var u := skills.pool.life_usable()
	var hits0 := player.life.hits_taken
	player.receive_damage(40.0, player.global_position + Vector3(1, 0, 0))
	var damage_ok := player.life.hits_taken == hits0 + 1 and is_equal_approx(player.life.life, u - 40.0)
	# THE ONE EXISTING RAISE PATH, `reset()`: capped at USABLE, not maximum.
	player.life.reset()
	var reset_capped := is_equal_approx(player.life.life, u) and u < player.life.max_life
	# ANY OTHER RAISE -- a direct write standing in for a future heal -- is capped.
	player.receive_damage(60.0, player.global_position + Vector3(1, 0, 0))
	player.life.life = player.life.life + 500.0
	var write_capped := is_equal_approx(player.life.life, u)
	# WITH NOTHING RESERVED, a raise may reach the full maximum again.
	_cycle_to("OFF")
	player.life.reset()
	var full_when_free := is_equal_approx(player.life.life, player.life.max_life)
	# DEATH IS UNTOUCHED: a lethal hit still kills, in order, under a reservation.
	var probe := Damageable.new(300.0)
	probe.set_ceiling(200.0)
	probe.apply(250.0, Vector3.ZERO)
	var death_ok := probe.dead and probe.hit_preceded_death() and is_zero_approx(probe.life)
	# ENEMIES ARE UNGOVERNED: their ledgers carry no ceiling.
	var enemies_free := true
	for e in main.get("enemies"):
		if e.life.ceiling != INF:
			enemies_free = false
	_cycle_to(String(launch["state"]))
	player.life.reset()
	var ok := heal_decls.is_empty() and scan_can_fail and damage_ok and reset_capped \
		and write_capped and full_when_free and death_ok and enemies_free
	_note("A38_damage_and_every_raise_of_live_health_respect_usable_health",
		"PREMISE, READ IN CODE: no runtime script declares a healing function (found: %s; the scan catches a planted one=%s) — the ledger's only raise path is reset() | DAMAGE under a Life reservation comes off the clamped value: %.1f - 40 = %.1f, one hit recorded=%s | reset() is CAPPED at usable %.1f, not the maximum %.1f=%s | a direct raise of +500 (standing in for any future heal) is capped at usable=%s | with nothing reserved a raise reaches the maximum again=%s | a lethal hit under a ceiling still kills, hit-before-death=%s | enemy ledgers carry no ceiling=%s"
		% [str(heal_decls), str(scan_can_fail), u, u - 40.0, str(damage_ok), u, player.life.max_life,
		   str(reset_capped), str(write_capped), str(full_when_free), str(death_ok), str(enemies_free)])
	_reached("A38_damage_and_every_raise_of_live_health_respect_usable_health")
	return ok

func chk_A39_mana_reservation_never_changes_current_health() -> bool:
	var launch_rank := _aura_rank()
	var rows: Array[String] = []
	var all_ok := true
	# AT FULL HEALTH AND AT A DAMAGED HEALTH, a Mana reservation moves nothing.
	for start_damage in [0.0, 55.0]:
		_full_health_off()
		if start_damage > 0.0:
			player.receive_damage(start_damage, player.global_position + Vector3(1, 0, 0))
		var h0 := player.life.life
		var ceiling0 := player.life.ceiling
		skills.cycle_reservation_state()            # OFF -> MANA RESERVATION
		var fired := skills.reservation_state() == "MANA RESERVATION" and skills.pool.mana_reserved > 0.0
		var same := is_equal_approx(player.life.life, h0) and is_equal_approx(player.life.ceiling, ceiling0)
		# RAISING AND LOWERING THE MANA RESERVATION: still nothing.
		var mana_moves := 0
		for i in 3:
			var m_before := skills.pool.mana_reserved
			skills.cycle_effective_rank(DiagImprintContent.CFG_AURA)
			if not is_equal_approx(skills.pool.mana_reserved, m_before):
				mana_moves += 1
			if not is_equal_approx(player.life.life, h0):
				same = false
		var ok_row := fired and same and mana_moves >= 2
		all_ok = all_ok and ok_row
		rows.append("start %.1f: OFF -> MANA fired=%s, the Mana reservation moved %d times, Health stayed %.1f=%s"
			% [h0, str(fired), mana_moves, player.life.life, str(ok_row)])
	# A MANA-ONLY WRITE STRAIGHT TO THE LIVE POOL: nothing.
	var h1 := player.life.life
	skills.pool.set_reservation(123.0, 0.0)
	var direct_same := is_equal_approx(player.life.life, h1)
	skills.loadout.revalidate(skills.pool)
	# THE CONTROL -- the measurement CAN see a change: MANA -> LIFE clamps it.
	_aura_rank_to(launch_rank)
	_full_health_off()
	_cycle_to("MANA RESERVATION")
	player.life.reset()
	var before_life := player.life.life
	skills.cycle_reservation_state()
	var control := player.life.life < before_life - 0.001
	_cycle_to(String(launch["state"]))
	player.life.reset()
	var ok := all_ok and direct_same and control and _aura_rank() == launch_rank
	_note("A39_mana_reservation_never_changes_current_health",
		"%s | a Mana-only reservation written straight to the live pool changed nothing=%s | THE CONTROL: the same measurement sees MANA -> LIFE CONVERSION lower Health=%s, so an unchanged reading means unchanged, not unseen"
		% [" · ".join(rows), str(direct_same), str(control)])
	_reached("A39_mana_reservation_never_changes_current_health")
	return ok

func chk_A40_the_hud_and_gameplay_read_the_same_live_state_after_the_ruling() -> bool:
	# ONE LEDGER, THREE READERS: gameplay, the pool's ceiling push, and the HUD.
	var one_ledger := is_same(review_hud.health_source(), player.life) \
		and is_same(skills.pool.health, player.life) and is_same(review_hud.pool_source(), skills.pool)
	var rows: Array[String] = []
	var all_ok := true
	for want in ["OFF", "MANA RESERVATION", "LIFE CONVERSION"]:
		for dmg in [0.0, 70.0]:
			_full_health_off()
			_cycle_to(String(want))
			player.life.reset()
			if dmg > 0.0:
				player.receive_damage(dmg, player.global_position + Vector3(1, 0, 0))
			review_hud.refresh()
			var s := review_hud.snapshot()
			var m := review_hud.bar_model("health")
			var ok_row := is_equal_approx(float(s["health_current"]), player.life.life) \
				and is_equal_approx(float(s["health_usable"]), skills.pool.life_usable()) \
				and is_equal_approx(float(s["health_usable"]), player.life.ceiling) \
				and float(s["health_current"]) <= float(s["health_usable"]) + 0.001 \
				and not bool(m["current_exceeds_usable"]) \
				and String(review_hud.compose_lines()["warning"]) == "" \
				and review_hud.health_bar.model == m
			all_ok = all_ok and ok_row
			rows.append("%s, %.0f damage: HUD %.1f of usable %.1f = live %.1f / ceiling %.1f=%s"
				% [want, dmg, float(s["health_current"]), float(s["health_usable"]), player.life.life,
				   player.life.ceiling, str(ok_row)])
	# THE LIFE LINE READS CURRENT == USABLE AT FULL HEALTH UNDER CONVERSION.
	_full_health_off()
	_cycle_to("LIFE CONVERSION")
	player.life.reset()
	var line := String(review_hud.compose_lines()["health"])
	var equal_text := line.find("%.0f current · %.0f usable" % [player.life.life, skills.pool.life_usable()]) >= 0 \
		and is_equal_approx(player.life.life, skills.pool.life_usable())
	# BACK TO LAUNCH, and it is the launch picture again.
	_cycle_to(String(launch["state"]))
	player.life.reset()
	skills.pool.refill()
	var back := is_equal_approx(player.life.life, float(launch["health_life"])) \
		and is_equal_approx(skills.pool.mana_reserved, float(launch["mana_reserved"])) \
		and skills.reservation_state() == String(launch["state"])
	var ok := one_ledger and all_ok and equal_text and back
	_note("A40_the_hud_and_gameplay_read_the_same_live_state_after_the_ruling",
		"ONE ledger, read by gameplay, the pool's ceiling and the HUD=%s | %s | under LIFE CONVERSION at full Health the HUD line reads '%s' — current EQUALS usable=%s | back at the launch picture (%s, Health %.1f)=%s"
		% [str(one_ledger), " · ".join(rows), line, str(equal_text), String(launch["state"]),
		   player.life.life, str(back)])
	_reached("A40_the_hud_and_gameplay_read_the_same_live_state_after_the_ruling")
	return ok

# ------------------------------------------------------------------ report ---

func _all_ok() -> bool:
	for id in OWED:
		if not reached.has(id) or results.get(id, null) != true:
			return false
	for id in reached.keys():
		if not OWED.has(id):
			return false
	return true

func _report() -> void:
	print("")
	print("------------------------------------------------------------------------")
	print("RESULTS — %s (%s)" % [ImprintConfig.ALIGNMENT_STAGE, ImprintConfig.ALIGNMENT_DECISION])
	print("------------------------------------------------------------------------")
	var passed := 0
	var failed := 0
	for id in OWED:
		var r = results.get(id, null)
		var state := "FAIL"
		if not reached.has(id):
			state = "UNREACHED"
		elif r == true:
			state = "PASS"
			passed += 1
		if state != "PASS":
			failed += 1
		print("  [%-9s] %s" % [state, id])
		if notes.has(id):
			print("               %s" % notes[id])

	print("")
	print("DEFERRED / OWED-TO-OWNER — recorded as such, NEVER as passes:")
	for row in DEFERRED_ROWS:
		print("  [%-14s] %s" % [row[1], row[0]])
		print("                   %s" % row[2])
	print("")
	print("DISCHARGED by a later owner ruling — history preserved, and NOT a pass of this suite:")
	for row in DISCHARGED_ROWS:
		print("  [%s] %s" % [row[1], row[0]])
		print("                   %s" % row[2])

	var owed_not_reached: Array[String] = []
	for id in OWED:
		if not reached.has(id):
			owed_not_reached.append(id)
	var reached_not_owed: Array[String] = []
	for id in reached.keys():
		if not OWED.has(id):
			reached_not_owed.append(id)

	print("")
	print("OWED vs REACHED (both directions):")
	print("  owed=%d  reached=%d  owed-but-not-reached=%d %s  reached-but-not-owed=%d %s"
		% [OWED.size(), reached.size(), owed_not_reached.size(),
		   str(owed_not_reached), reached_not_owed.size(), str(reached_not_owed)])

	print("")
	var tally := {}
	for row in ImprintConfig.d378_alignment():
		tally[String(row[1])] = int(tally.get(String(row[1]), 0)) + 1
	print("THE D-378 MAP (printed in full in the banner above): %d parts — %s"
		% [ImprintConfig.d378_alignment().size(), str(tally)])
	for d in ImprintConfig.alignment_denials():
		print("  %s" % d)
	print("")
	print("UNITS: %d EXECUTABLE CHECKS here · 162 OWED CRITERIA in the D-380 inventory ·"
		% OWED.size())
	print("       21 RUNNER CHECKS in tests/alignment_smoke.sh · and the ACCEPTED D-375 and")
	print("       D-370 suites' 101 and 85 EXECUTABLE CHECKS are DIFFERENT decisions' numbers.")
	print("       Different unit. None is a synonym for another.")
	print("")
	var verdict := "PASS" if _all_ok() else "FAIL"
	print("ALIGNMENT VERIFICATION: %s (%d checks: %d passed, %d failed/unreached, %d deferred)"
		% [verdict, OWED.size(), passed, failed, DEFERRED_ROWS.size()])
	print("STATE: %s" % ProdConfig.STATE)
	print("------------------------------------------------------------------------")
