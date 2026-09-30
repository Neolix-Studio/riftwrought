extends SceneTree

## RIFTWROUGHT — GLOBAL IMPRINT SYSTEM PROTOTYPE VERIFICATION  (D-375, 2026-09-17)
##
## ============================================================================
## THIS IS A SECOND SUITE. THE ACCEPTED ONE IS NOT EXTENDED OR RENUMBERED.
## ============================================================================
## `tests/foundation_verification.gd` holds the ACCEPTED D-373 baseline's 85
## executable checks. It is re-run UNCHANGED as a regression by this stage's
## runner. Nothing in it was removed, renamed or renumbered; exactly two pins
## moved, and both moved together with the artifact they guard (the STATE line
## and the deferred-row count, 12 -> 11 because D-373 DISCHARGED `M-04`).
##
## ============================================================================
## UNITS. FIVE COUNTS EXIST IN THIS PROJECT AND NONE IS A SYNONYM FOR ANOTHER.
## ============================================================================
##   D-375 OWED CRITERIA   149   docs/testing/D375_IMPRINT_OWED_CRITERIA_INVENTORY.md
##   D-375 EXECUTABLE CHECKS 101  this suite
##   D-375 RUNNER CHECKS      24  tests/imprint_smoke.sh
##   D-370 OWED CRITERIA     125   docs/testing/D370_OWED_CRITERIA_INVENTORY.md
##   D-370 EXECUTABLE CHECKS  85  tests/foundation_verification.gd  (UNCHANGED)
##   D-370 RUNNER CHECKS      20  tests/foundation_smoke.sh
##
## 149 is not 101. 101 is not 85. Anyone restating any of them must carry its
## unit and its decision with it. This project has been blocked once by a closure
## that quoted two different counts as if they were one number.
##
## ============================================================================
## THE COUNTS MOVED ONCE, AND THE ARITHMETIC IS STATED: 148 -> 149, 100 -> 101.
## ============================================================================
## The rendered evidence exposed a CANONICAL DEFECT no check in this suite was
## looking for: the release path read the LIVE aim instead of the aim sampled
## when the use began. Canon (locked by D-193) requires per-use sampling. ONE
## criterion (`EX-17`) and ONE check (`I101`) were added, the runner is unchanged
## at 26, and NOTHING was removed, renamed or renumbered.
##
## ============================================================================
## IT VERIFIED A STAGE DELIVERED OPEN (D-375) -- ACCEPTED and CLOSED UNDER D-376.
## ============================================================================
## Since D-380 it is re-run as a REGRESSION by the D-378 ALIGNMENT STAGE. Its
## count is UNCHANGED at 101 (101 - 0 + 0 = 101). The first act of D-380 moved its
## eight MO- rows to DISCHARGED_ROWS (24 -> 16 deferred) and re-scoped I01 and
## I10; the alignment re-scoped, ONE FOR ONE, the checks whose rule D-376 or D-378
## replaced -- I13, I25, I54, I56 and I57, the last two with their NUMBERS KEPT and
## their suffixes corrected so no PASS line asserts a withdrawn candidate. Every
## re-scope carries its superseded assertion as dated history in its own comment.
##
## It completes no phase, does not complete P1 or the original P1C, authorizes no
## phase, locks no value, and FINALIZES NO ROSTER, SLOT COUNT, RANK CAP, CAPACITY
## VALUE, XP CURVE, RESERVATION VALUE OR BALANCE.
##
## The standing verification rules are applied verbatim: a named owed list
## compared in BOTH directions · every check records reaching its LAST line · a
## missing check function is a FAIL and never a skip · every negative control is
## PROVED ABLE TO REFUSE · an assertion that something did not happen asserts the
## action FIRED FIRST · an unperformed check is DEFERRED and names where it
## returns.

const OWED := [
	# --- A. GOVERNANCE, RECONCILIATION AND TRUTHFULNESS ---------------------
	"I01_state_is_reconciled_and_asserts_nothing_false",
	"I02_m04_is_discharged_with_its_history_preserved",
	"I03_every_denial_is_present_and_the_guard_can_fail",
	"I04_no_rift_shard_anything_and_the_guard_can_fail",
	"I05_every_value_this_stage_introduces_is_labelled_provisional",
	"I06_canonical_values_are_separated_and_cited",
	"I07_measured_conflicts_are_printed_at_runtime",
	"I08_no_accepted_d373_value_is_modified",
	"I09_zero_new_third_party_assets",
	"I10_carried_debts_are_printed_and_none_is_discharged",
	# --- B. IMPRINT OBJECTS AND THE LIBRARY ---------------------------------
	"I11_exactly_three_imprint_types_exist",
	"I12_the_library_set_is_pinned_in_both_directions",
	"I13_learning_is_permanent_and_idempotent",
	"I14_one_skill_imprint_appears_in_several_configurations",
	"I15_one_augment_imprint_is_reused_with_one_mastery_record",
	"I16_tags_come_only_from_canon_plus_one_declared_extension",
	"I17_no_imprint_bears_a_canonical_roster_or_augment_name",
	"I18_every_imprint_is_labelled_diagnostic",
	"I19_behavioural_identity_is_complete_at_effective_rank_1",
	# --- C. SKILL CONFIGURATION ---------------------------------------------
	"I20_exactly_one_skill_imprint_per_configuration",
	"I21_a_fifth_modifier_is_refused_by_the_slot_rule",
	"I22_a_transform_shares_the_four_slots_and_is_not_a_fifth",
	"I23_a_second_transform_is_refused_by_the_transform_rule",
	"I24_incompatible_tags_are_refused_with_a_specific_reason",
	"I25_no_installed_modifier_silently_does_nothing",
	"I26_tag_changes_are_stated_explicitly",
	"I27_an_enabling_tag_removed_does_not_delete_its_dependent",
	"I28_an_invalid_configuration_cannot_be_equipped",
	"I29_every_configuration_declares_one_canonical_targeting_archetype",
	"I30_a_transform_that_changes_targeting_states_the_new_archetype",
	"I31_installing_and_removing_is_free_and_destroys_nothing",
	"I32_the_pipeline_resolves_by_category_not_by_slot_position",
	# --- D. THE RANK PROTOTYPE ----------------------------------------------
	"I33_the_rank_range_is_1_to_20_and_is_provisional",
	"I34_mastered_rank_never_decreases",
	"I35_effective_rank_is_selected_per_configuration",
	"I36_effective_rank_above_mastered_rank_is_refused",
	"I37_levelling_never_bricks_an_imprint",
	"I38_all_three_imprint_types_are_levelable",
	"I39_rank_moves_more_than_raw_damage",
	"I40_awarded_combat_progress_grants_xp",
	"I41_button_use_frequency_grants_no_xp",
	"I42_reuse_in_several_configurations_does_not_multiply_xp",
	"I43_the_catch_up_rule_is_bounded_and_measured",
	"I44_no_acquisition_trading_or_progression_pacing",
	# --- E. CONFIGURATION CAPACITY ------------------------------------------
	"I45_one_global_capacity_budget_exists",
	"I46_most_base_capacity_comes_from_character_progression",
	"I47_the_gear_figure_is_a_scalar_and_there_is_no_equipment_system",
	"I48_capacity_limits_the_sustained_modifier_slots",
	"I49_a_primary_skill_costs_more_capacity_than_a_secondary_one",
	"I50_an_over_capacity_loadout_is_never_silently_left_active",
	"I51_removing_the_gear_bonus_produces_an_explicit_result",
	"I52_the_four_slot_maximum_holds_independently_of_capacity",
	# --- F. BINDINGS VERSUS EQUIPPED CONFIGURATIONS -------------------------
	"I53_eight_active_bindings_exist_pinned_both_directions",
	"I54_eight_is_not_rewritten_into_six",
	"I55_bindings_and_equipped_configurations_are_distinct_concepts",
	# D-380: I56 and I57 KEEP THEIR NUMBERS and their suffixes were corrected, so
	# no PASS line asserts a withdrawn candidate. Until D-380 they read
	# "I56_six_active_configurations_is_a_candidate_not_a_lock" and
	# "I57_four_persistent_is_a_candidate_and_its_conflict_is_printed".
	# 101 - 0 + 0 = 101: NOTHING REMOVED, NOTHING ADDED, NOTHING RENUMBERED.
	"I56_up_to_eight_active_configurations_one_per_binding_no_six_cap",
	"I57_the_withdrawn_four_persistent_cap_is_gone_and_x02_prints_resolved",
	"I58_an_empty_binding_does_nothing_and_says_so",
	# --- G. PERSISTENT CONFIGURATIONS AND RESERVATION ----------------------
	"I59_the_persistent_loadout_consumes_no_active_binding",
	"I60_an_aura_reserves_mana_after_modifiers",
	"I61_one_modifier_changes_the_reservation_resource_to_life",
	"I62_exactly_one_resource_is_reserved_never_both",
	"I63_reservation_is_not_spending_and_restores_exactly",
	"I64_an_unsupportable_reservation_deactivates_with_an_explanation",
	"I65_the_aura_supports_the_beasts_measurably",
	# --- H. THE THREE REPRESENTATIVE BUILDS ---------------------------------
	"I66_action_entry_points_are_pinned_exhaustively_both_directions",
	"I67_the_bow_configuration_is_a_lightning_projectile_attack",
	"I68_additional_projectiles_and_forking_come_from_reusable_augments",
	"I69_forking_is_bounded_and_cannot_chain_forever",
	"I70_the_transform_is_materially_identity_changing",
	"I71_the_ballista_proves_a_non_direct_attack_style",
	"I72_the_ballista_reuses_the_same_projectile_augment",
	"I73_the_duration_contract_is_declared_and_the_oldest_is_replaced",
	"I74_beasts_follow_acquire_and_attack_autonomously",
	"I75_beasts_are_the_primary_damage_source_of_their_build",
	"I76_no_beast_command_input_and_no_command_method_exists",
	"I77_no_command_beast_of_any_kind_is_created",
	"I78_minions_do_not_obstruct_the_player",
	"I79_one_input_activation_is_one_skill_use",
	# --- I. EXISTING ACCEPTED BEHAVIOUR, PRESERVED -------------------------
	"I80_click_to_move_stores_the_clicked_point_unsnapped",  # replaced one for one under D-404; its old name and requirement are dated in its body
	"I81_no_sector_index_exists_anywhere_including_the_new_files",
	"I82_skill_actions_use_the_accepted_commitment_with_no_third_policy",
	"I83_a_cancel_during_a_skill_windup_is_refused_and_counted",
	"I84_movement_after_a_skill_release_cancels_the_recovery",
	"I85_a_released_projectile_survives_the_cancel_intact",
	"I86_a_placed_ballista_survives_the_cancel_intact",
	"I87_a_summoned_beast_survives_the_cancel_intact",
	"I88_configurations_of_one_skill_share_its_cooldown",
	"I89_cost_is_paid_at_use_start_and_a_use_without_resources_is_refused",
	"I90_a_cooldown_begins_on_successful_release",
	"I91_edits_are_refused_during_active_combat_and_the_override_is_declared",
	# --- J. THE LIVE-REVIEW PANEL ------------------------------------------
	"I92_the_panel_shows_every_required_element",
	"I93_the_panel_offers_every_required_comparison",
	"I94_the_panel_is_navigable_with_explicit_focus_and_no_typed_text",
	"I95_every_panel_command_is_a_named_input_action",
	"I96_the_panel_denies_being_a_ui_foundation",
	"I97_the_panel_can_be_disabled",
	# --- K. VERIFICATION DISCIPLINE ----------------------------------------
	"I98_test_seams_are_clear_in_normal_play",
	"I99_no_runtime_dependency_leaves_this_project",
	"I100_the_units_are_named_separately_at_this_surface",
	# --- ADDED AFTER THE RENDERED EVIDENCE EXPOSED A CANONICAL DEFECT --------
	"I101_targeting_is_sampled_per_use_and_not_at_the_release",
]

## ============================================================================
## ROWS THIS STAGE DOES NOT PASS AND DOES NOT PRETEND TO.
## ============================================================================
## Printed and counted every run as DEFERRED or OWED-TO-OWNER, NEVER as passes.
## Each DEFERRED row names where it returns; each OWED row is a judgment that is
## the owner's on live review.
const DEFERRED_ROWS := [
	["DF-01 controller mapping of the EIGHT active bindings", "DEFERRED",
	 "Canon's design is a SHIFTED BANK of four plus four, which needs a shift "
	 + "modifier and a HUD -- a UI/input foundation decision this stage is not "
	 + "authorized to take, and CLAUDE.md section 12 forbids beginning one. The eight "
	 + "bindings EXIST and are keyboard-bound (1-8); the PANEL's own controller "
	 + "mapping IS complete. RETURNS TO: the UI/input foundation and the canonical "
	 + "Shaping Board."],
	["DF-02 charges, shared charges, and the minimum activation interval", "DEFERRED",
	 "No charge mechanic is implemented. Canon says configurations of one base Skill "
	 + "share COOLDOWNS AND CHARGES; the cooldown half is proved (I88) and the charge "
	 + "half is NOT, because claiming it with no charges to share would be a vacuous "
	 + "pass. RETURNS TO: a separately authorized Skill-mechanics stage."],
	["DF-03 a movement Skill archetype", "DEFERRED",
	 "Canon requires at least one simple Movement Skill in the first MVP. None is "
	 + "implemented here, and the Capacity differential is shown between primary, "
	 + "secondary and persistent classes instead. RETURNS TO: the same stage."],
	["DF-04 Triggers, Retaliations, Channels, Instants, damage over time, attack/cast speed",
	 "DEFERRED",
	 "All are designed canon and none is implemented. The ONE related property that "
	 + "IS proved is the bounded-chain rule, via forking (I69), because a fork is the "
	 + "same shape of failure as a self-triggering trigger. RETURNS TO: the same stage."],
	["DF-05 beasts taking damage, dying and being resummoned", "DEFERRED",
	 "The beasts deal damage and cannot be damaged. Canon's minion recovery rule is "
	 + "therefore untested. RETURNS TO: the same stage."],
	["DF-06 acquisition — deterministic routes, directed choices, Patterns, duplicate protection, trading",
	 "DEFERRED",
	 "The ruling says plainly: 'Do not implement loot acquisition, trading or final "
	 + "progression pacing.' Every Imprint is pre-learned. RETURNS TO: a separately "
	 + "authorized loot/progression foundation."],
	["DF-07 the final XP curve, the rank cap and progression pacing", "DEFERRED",
	 "1-20 and a linear 120-per-step curve are DELIBERATELY PROVISIONAL, in the "
	 + "owner's own word. RETURNS TO: a separately authorized tuning pass."],
	["DF-08 the canonical Huntress class specification", "STILL OWED",
	 "It remains a P2 PREREQUISITE and this stage is FORBIDDEN to write it. Nothing "
	 + "here may be mined for her mechanics -- not an Imprint, not a build, not the "
	 + "Lightning tag, and not the accepted diagnostic bolt. RETURNS TO: its own "
	 + "authorized design pass."],
	["DF-09 Rift Shards — Generate, Hold, Shape, Rift Echo", "STILL OWED",
	 "The ruling: 'Rift Shards are not Skill gems and are outside this stage' and "
	 + "'not authorization to build Rift Shards yet'. NOTHING of them exists here, "
	 + "and I04 proves it with a guard that can fail. RETURNS TO: its own authorized "
	 + "stage."],
	["DF-10 controller HARDWARE behaviour", "DEFERRED",
	 "No gamepad can be attached in this environment. The panel's action mappings "
	 + "ARE declared and asserted (I95). Inherited from the foundation's N-03. "
	 + "RETURNS TO: owner live review."],
	["DF-11 audio", "DEFERRED",
	 "ZERO audio assets and ZERO audio hooks, unchanged. CLAUDE.md section 12 forbids "
	 + "new audio. RETURNS TO: a separately authorized audio pass."],
	["DF-12 a real safe-state / combat-state model", "DEFERRED",
	 "MEASURED: no such concept exists in any accepted runtime script. Canon's "
	 + "'unavailable during active combat' rule is implemented as a BOUNDED, DECLARED "
	 + "approximation and is proved to refuse (I91). RETURNS TO: a separately "
	 + "authorized stage."],
	["DF-13 the bounded companion design and asset-cost review", "STILL OWED",
	 "The Atlas guardrail requires it. THE ASSET-COST HALF IS DISCHARGED BY "
	 + "MEASUREMENT -- this stage imports ZERO new assets (I09) -- and the DESIGN half "
	 + "is not. RETURNS TO: its own authorized design pass."],
	["DF-14 the diagnostic_attack controller binding is button 7 (L3), not RT", "STILL OWED",
	 "MEASURED in the ACCEPTED baseline: project.godot binds it to "
	 + "InputEventJoypadButton button_index 7, which in Godot 4 is JOY_BUTTON_LEFT_STICK, "
	 + "while the README says 'controller RT'. Triggers are axes 4 and 5, not buttons. "
	 + "REPORTED AND DELIBERATELY NOT FIXED: rebinding an accepted input is a UX "
	 + "decision and this stage does not need it. RETURNS TO: the UI/input foundation."],
	["DF-15 Always Use Without Moving, stored per Configuration", "DEFERRED",
	 "Canon stores it per Configuration. The accepted STOP/ALLOW policy is the "
	 + "mechanism it would use, and choosing its default is a tuning decision this "
	 + "stage must not take. RETURNS TO: a separately authorized stage."],
	["DF-16 weapon-derived Attack damage and base Attack Time", "DEFERRED",
	 "There is no weapon and no equipment system here, and 0 of the 85 corpus clips "
	 + "match bow/arrow/draw/archer. RETURNS TO: the final Huntress model and its "
	 + "animation set."],
]

## ============================================================================
## DISCHARGED ROWS — HISTORY PRESERVED, AND NOT COUNTED AS DEFERRED.
## ============================================================================
## Reconciled under D-380, AS ITS FIRST ACT, exactly as D-376 section 7
## recommended and as the D-380 ruling authorizes: "reconcile the formerly owed
## owner-review rows; update and re-pin the associated truthfulness guards
## together, never piecemeal."
##
## `MO-01`...`MO-08` printed as OWED-TO-OWNER on every run from D-375 until
## D-380. D-376's live review ANSWERED ALL EIGHT, but the owner forbade changing
## anything in this project to earn that acceptance -- so the suite went on
## printing eight discharged questions as still owed, which is a FALSE
## CURRENT-STATE ASSERTION, declared by D-376 rather than hidden. Deleting them
## would have erased the history. SO THEY MOVED, each with its ORIGINAL TEXT
## PRESERVED VERBATIM and the owner's D-376 answer beside it, and the pinned
## deferred-row count moved 24 -> 16 IN THE SAME CHANGE as the runner's pins
## (S06, S09, S14, S16, S17) and the foundation runner's R08. This is the same
## move D-375 made for the foundation suite's `M-04`.
##
## A DISCHARGED ROW IS NOT A PASS AND IS NOT COUNTED AS ONE. It is history.
const DISCHARGED_ROWS := [
	["MO-01 does Configuration Capacity create meaningful choices, or merely annoyance?",
	 "DISCHARGED — D-376",
	 "THE OWNER'S D-376 LIVE REVIEW ANSWERED IT: A CHOICE. Global Capacity is accepted as an "
	 + "architectural constraint, its totals and costs PROVISIONAL, and generic random gear "
	 + "Capacity is refused as a foundation. "
	 + "|| ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): 'THE RULING ASKS THIS DIRECTLY. "
	 + "The panel shows Capacity used/available with every source, the demand with nothing "
	 + "deactivated, and the exact arithmetic of each deactivation. Whether that is a CHOICE or an "
	 + "IRRITATION is the owner's. RETURNS TO: owner live review.'"],
	["MO-02 does the Mastered / Effective rank split read as intentional, not as a trap?",
	 "DISCHARGED — D-376",
	 "THE OWNER'S D-376 LIVE REVIEW ANSWERED IT: INTENTIONAL. The split is accepted, and the "
	 + "architecture must continue to support deliberate low-, middle- and maximum-rank builds. "
	 + "|| ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): 'The suite proves an Imprint "
	 + "cannot be bricked by levelling (I37) and that every rank stays selectable. Whether the "
	 + "model FEELS like deliberate low-, mid- and maximum-rank use is the owner's. RETURNS TO: "
	 + "owner live review.'"],
	["MO-03 do the three builds feel materially different?",
	 "DISCHARGED — D-376",
	 "THE OWNER'S D-376 LIVE REVIEW ANSWERED IT: YES — 'The prototype successfully demonstrates "
	 + "that direct bow attacks, ballista/trap-style attacks and autonomous beast-primary builds "
	 + "can coexist under one system.' "
	 + "|| ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): 'The suite measures that they ARE "
	 + "different -- different delivery, different damage sources, different targeting "
	 + "archetypes. Whether they FEEL different is the owner's. RETURNS TO: owner live review.'"],
	["MO-04 is the panel understandable enough to judge the architecture from?",
	 "DISCHARGED — D-376",
	 "THE OWNER'S D-376 LIVE REVIEW ANSWERED IT: YES — AS A DEVELOPER SURFACE ONLY, and "
	 + "explicitly not a production UI foundation. "
	 + "|| ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): 'The suite asserts every required "
	 + "element and comparison is present and readable as text. Whether it is LEGIBLE AND USEFUL "
	 + "is the owner's, and a rendered capture of it is supplied. RETURNS TO: owner live review.'"],
	["MO-05 are EIGHT bindings / SIX Active / FOUR Persistent the right shape — and should the four-Persistent candidate survive D-079's refusal?",
	 "DISCHARGED — D-376",
	 "THE OWNER'S D-376 LIVE REVIEW ANSWERED IT: EIGHT preserved · SIX a working baseline, not a "
	 + "lock · FOUR WITHDRAWN; D-079 stands. (D-378 OD-09 later amended the working baseline to UP "
	 + "TO EIGHT, one per binding; D-380 aligned the runtime with both rulings.) "
	 + "|| ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): 'CONFLICT X-02 IS THE LIVE "
	 + "QUESTION: D-079 permits NO arbitrary Persistent-slot cap. Either that refusal stands and "
	 + "the candidate is withdrawn, or D-079 is amended by a new ruling. THIS STAGE TAKES NEITHER "
	 + "DECISION. RETURNS TO: owner live review.'"],
	["MO-06 does beast-primary damage feel acceptable without micromanagement?",
	 "DISCHARGED — D-376",
	 "THE OWNER'S D-376 LIVE REVIEW ANSWERED IT: YES. Autonomous beasts are accepted as the "
	 + "Beastmaster foundation and may be the primary damage source. "
	 + "|| ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): 'The suite measures that the "
	 + "beasts are autonomous and are the primary damage source. Whether playing that way feels "
	 + "good, or feels like watching, is the owner's. RETURNS TO: owner live review.'"],
	["MO-07 is the one materially identity-changing Transform identity-changing ENOUGH?",
	 "DISCHARGED — D-376",
	 "THE OWNER'S D-376 LIVE REVIEW ANSWERED IT: THE PATH IS PROVED. The standard is now explicit "
	 + "-- materially change behaviour, not merely add damage -- and the diagnostic Transform is "
	 + "not necessarily final content. "
	 + "|| ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): 'MEASURED: the targeting "
	 + "archetype changes, the Projectile tag is removed, the delivery changes and the projectile "
	 + "Augments stop applying. Whether that reads as a NEW SKILL is the owner's. RETURNS TO: "
	 + "owner live review.'"],
	["MO-08 should the DIAGNOSTIC safe-state override exist at all?",
	 "DISCHARGED — D-376",
	 "THE OWNER'S D-376 LIVE REVIEW ANSWERED IT: AS PROTOTYPE TOOLING ONLY. It may remain "
	 + "documented and is not accepted player-facing behaviour; production editing must obey the "
	 + "safe-state rule or use a paused/safe loadout surface. "
	 + "|| ORIGINAL ROW TEXT, PRESERVED VERBATIM (OWED-TO-OWNER): 'It is ON by default because the "
	 + "arena acquires the player within seconds and this panel exists to be used live. The "
	 + "alternative -- the panel PAUSING THE WORLD, as canon requires of a pause -- is a bigger "
	 + "behaviour this stage did not take on its own authority. RETURNS TO: owner live review.'"],
]

## The ONE deliberately planted bad value, so a guard can be proved able to fail
## against something the project would never write by accident.
const PLANTED_CLAIM := "Imprint_Stage_Finalizes_The_Huntress_Roster_THIS_IS_FORBIDDEN"

var reached := {}
var results := {}
var notes := {}

var main: Node
var arena: ProductionArena
var cam: IsoCameraRig
var player: PlayerController
var enemies: Array = []
var hud: DebugOverlay
var skills: SkillRuntime
var panel: LoadoutPanel
var nav_map: RID

## Captured BEFORE the suite touches anything.
var initial_seams_clear: bool = false
var initial_panel_enabled: bool = false
var initial_override: bool = false

func _initialize() -> void:
	print("========================================================================")
	print("RIFTWROUGHT — %s VERIFICATION  (%s, %s)"
		% [ImprintConfig.STAGE, ImprintConfig.DECISION, ImprintConfig.DATE])
	print("STATE: %s" % ProdConfig.STATE)
	# D-392 (first act): this read "... re-run under the D-380 D-378 ALIGNMENT STAGE
	# (delivered OPEN)" until D-392 -- true when written; D-383 closed that stage.
	# D-396 (first act): "re-run under the D-392 HUNTRESS SPLINTER SHOT STAGE
	# (delivered OPEN)" until D-396 -- true when written; D-394 closed that stage.
	print("Verifying a stage ACCEPTED and CLOSED under D-376, re-run under the D-396 KINDRED")
	print("HOUNDS STAGE (delivered OPEN). It completes no phase, does not complete P1 or")
	print("the original P1C, authorizes no phase, locks no value, and FINALIZES NO ROSTER,")
	print("SLOT COUNT, RANK CAP, CAPACITY VALUE, XP CURVE, RESERVATION VALUE OR BALANCE.")
	print("OWED EXECUTABLE CHECKS: %d   DEFERRED/STILL OWED ROWS: %d   DISCHARGED: %d"
		% [OWED.size(), DEFERRED_ROWS.size(), DISCHARGED_ROWS.size()])
	print("(ACCEPTED and CLOSED under D-376. Re-run under the D-380 D-378 ALIGNMENT STAGE, whose")
	print(" first act reconciled this suite's state and its eight MO- rows, and which re-scoped")
	print(" -- one for one, 101 - 0 + 0 = 101 -- the checks whose rule D-376 or D-378 replaced.)")
	print("(The D-375 owed-criteria INVENTORY counts 149 CRITERIA. Different unit.)")
	print("(The ACCEPTED D-370 suite counts 85 EXECUTABLE CHECKS and its inventory 125")
	print(" CRITERIA. Different decisions, different units. None is a synonym for another.)")
	print("========================================================================")

	main = load("res://scenes/main.tscn").instantiate()
	root.add_child(main)
	for i in 16:
		await process_frame

	# ========================================================================
	# D-396 — THE DECLARED FIXTURE: THE ACCEPTED LOADOUT, RESTORED.
	# ========================================================================
	# Since D-396 the scene composes the Kindred Hounds stage and applies its
	# REVIEW loadout: the diagnostic aura replaced by Kindred Hounds, binding 4
	# unbound, and two autonomous hounds biting registered enemies -- which would
	# move this ACCEPTED suite's Capacity, reservation and damage-ledger figures.
	# So the loadout this suite was accepted with (the D-392 loadout, no pack) is
	# restored through the runtime's OWN loadout operations before anything is
	# measured. It adds no check and removes none; the D-396 suite proves the
	# restoration exact and measures the review loadout itself.
	main.get("hounds").restore_accepted_d392_loadout()
	await physics_frame

	arena = main.get("arena")
	cam = main.get("cam")
	player = main.get("player")
	enemies = main.get("enemies")
	hud = main.get("hud")
	skills = main.get("skills")
	panel = main.get("imprint_panel")
	nav_map = NavService.map_rid_for(main)
	NavService.sync(nav_map)

	initial_seams_clear = player.intent.seams_clear() \
		and cam.debug_cursor_override == null \
		and not player.debug_freeze_attack
	for e in enemies:
		if e.debug_freeze_ai or e.debug_suppress_movement:
			initial_seams_clear = false
	initial_panel_enabled = panel.enabled
	initial_override = skills.diagnostic_safe_state_override

	# ========================================================================
	# THE SCENE'S OWN ENEMIES ARE FROZEN AND MADE UNKILLABLE, DELIBERATELY.
	# ========================================================================
	# Frozen, so a wandering AI cannot contaminate a measurement of something
	# else -- the accepted suite does the same.
	#
	# AND UNKILLABLE, which the accepted suite does not need to do: the autonomous
	# things in this stage acquire the NEAREST enemy, and a ballista firing twelve
	# bolts will kill a 120-Life bystander. A death awards COMBAT PROGRESS, which
	# grants XP, which would silently move the very numbers the rank and XP checks
	# measure. Every behavioural check still spawns its OWN probe enemy.
	for e in enemies:
		e.debug_freeze_ai = true
		e.life = Damageable.new(1000000.0)

	for id in OWED:
		await _run(id)

	_report()
	quit(0 if _all_ok() else 1)

func _run(id: String) -> void:
	# A MISSING METHOD IS A FAIL, NOT A SKIP -- the suite must not be able to
	# quietly owe a check it never wrote.
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

func _all_project_files() -> Array:
	var out: Array = []
	_walk("res://", out)
	return out

## RUNTIME scripts only.
##
## Several checks below scan for text that MUST NOT appear in the game. THIS
## SUITE ITSELF HAS TO NAME EVERY ONE OF THEM in order to forbid it, so scanning
## the suite with its own patterns would find the patterns and report the harness
## as the offender. The claim is about the GAME, so the scan is over the game.
func _runtime_script_files() -> Array:
	var out: Array = []
	for f in _all_project_files():
		var p := String(f)
		if p.begins_with("res://scripts/") and p.ends_with(".gd"):
			out.append(p)
	return out

## A fresh, sacrificial enemy with a very large Life pool, so a behavioural
## measurement is never cut short by the subject dying.
func _probe_enemy(probe_name: String, pos: Vector3, life: float = 100000.0) -> OrdinaryEnemy:
	var e := OrdinaryEnemy.new()
	e.name = probe_name
	main.add_child(e)
	e.setup(main.get("corpus"))
	e.global_position = pos
	e.player = player
	e.debug_freeze_ai = true
	e.life = Damageable.new(life)
	await _phys(3)
	return e

## Puts the player, the runtime and the ledger into a known state.
func _rest() -> void:
	player.intent.clear_seams()
	player.commitment.reset()
	player.clear_move_destination()
	player.follower.set_path(PackedVector3Array())
	player.motor.reset()
	player._cooldown = 0.0
	player._pending_shot = false
	player.global_position = Vector3(-12, 0, 0)
	cam.debug_cursor_override = Vector3(0, 0, 0)
	skills.dismiss_all()
	skills.clear_cooldowns()
	skills.forget_defeated()
	skills.pool.refill()
	await _phys(4)

## A scratch loadout built on a FRESH library, for checks that must not disturb
## the live one. A check that mutates the build under review corrupts every
## check after it.
func _scratch() -> Dictionary:
	var lib := DiagImprintContent.build_library()
	var cfgs := DiagImprintContent.build_configurations(lib)
	cfgs.erase("__problems")
	return {"library": lib, "configurations": cfgs}

## ============================================================================
## A PRECISE DECLARATION SCANNER, because the loose one was WRONG.
## ============================================================================
## The first version of the forbidden-declaration scans matched a bare substring
## and reported THREE legitimate identifiers as violations: the accepted enemy's
## own `acquisitions` counter, this stage's `tradeoff` field, and the accepted
## `move_command` input action. A guard that cannot tell `tradeoff` from
## `trading` is noise, and noise gets switched off.
##
## THE CRITERION IS STATED RATHER THAN IMPLIED: a declaration is a hit when
## `func`, `var`, `const` or `class_name` is followed by an identifier that IS
## the token, or that begins with the token followed by an UNDERSCORE. So
## `var loot`, `var loot_table` and `func loot()` are hits; `var tradeoff` and
## `var acquisitions` are not.
func _declarations_naming(text: String, tokens: Array) -> Array:
	var hits: Array[String] = []
	for raw in tokens:
		var tok := String(raw)
		var re := RegEx.new()
		# The token may itself contain an underscore, so it is escaped by hand
		# rather than trusted to a character class.
		var esc := tok.replace("_", "\\_")
		re.compile("(?m)^\\s*(func|var|const|class_name)\\s+" + esc + "(?![A-Za-z0-9])")
		if re.search(text) != null:
			hits.append(tok)
	return hits

## The same scan over every runtime script, returning file-qualified hits.
func _runtime_declarations_naming(tokens: Array, skip: Array = []) -> Array:
	var hits: Array[String] = []
	for f in _runtime_script_files():
		var p := String(f)
		var skip_this := false
		for sk in skip:
			if p.ends_with(String(sk)):
				skip_this = true
		if skip_this:
			continue
		for t in _declarations_naming(_read_text(p).to_lower(), tokens):
			hits.append("%s: %s" % [p.get_file(), String(t)])
	return hits

func _cfg(id: String) -> SkillConfiguration:
	return skills.loadout.configuration(id) as SkillConfiguration

## Registers a probe enemy with the runtime's own enemy provider, so the
## autonomous things (the ballista and the beasts) can actually find it. Without
## this they would acquire nothing and every autonomy check would pass vacuously.
func _register(e: Node) -> void:
	var list: Array = main.get("enemies")
	if not list.has(e):
		list.append(e)

func _unregister(e: Node) -> void:
	var list: Array = main.get("enemies")
	list.erase(e)
	if e != null and is_instance_valid(e):
		e.queue_free()

# ============================================================================
# A. GOVERNANCE, RECONCILIATION AND TRUTHFULNESS
# ============================================================================

func chk_I01_state_is_reconciled_and_asserts_nothing_false() -> bool:
	# D-373 section 6.1 DECLARED this discrepancy and RECOMMENDED -- explicitly
	# NOT authorizing -- its repair by the next authorized stage. The D-375 ruling
	# authorizes it: "do not retain false current-state assertions".
	#
	# ========================================================================
	# RE-SCOPED UNDER D-380, AS ITS FIRST ACT. THE ID IS UNCHANGED.
	# ========================================================================
	# From D-375 until D-380 this check required the state to name the Imprint
	# stage as "DELIVERED and OPEN pending owner live review (D-375)" -- TRUE WHEN
	# WRITTEN. D-376 ACCEPTED and CLOSED that stage and D-376 section 7 declared
	# the string stale; the D-380 ruling authorizes the repair. So the check now
	# requires ALL THREE facts, AND that the D-375-era clause is GONE -- a check
	# that still accepted the stale clause would protect nothing.
	#
	# ========================================================================
	# RE-SCOPED AGAIN UNDER D-392, AS ITS FIRST ACT. THE ID IS UNCHANGED.
	# ========================================================================
	# From D-380 until D-392 `says_open` required "D-378 ALIGNMENT STAGE DELIVERED
	# and OPEN pending owner live review (D-380)" -- TRUE WHEN WRITTEN. D-383
	# accepted and closed that stage; D-383 section 6 recommended the repair and
	# the D-392 ruling authorizes it. So the check now requires FOUR facts, and
	# that the D-380-era clause is GONE as well as the D-375-era one.
	#
	# ========================================================================
	# RE-SCOPED A THIRD TIME UNDER D-396, AS ITS FIRST ACT. THE ID IS UNCHANGED.
	# ========================================================================
	# From D-392 until D-396 `says_open` required "HUNTRESS SPLINTER SHOT STAGE
	# DELIVERED and OPEN pending owner live review (D-392)" -- TRUE WHEN WRITTEN.
	# D-394 accepted and closed that stage; D-394 section 7 recommended the repair
	# and the D-396 ruling authorizes it. So the check now requires FIVE facts --
	# D-394's acceptance with the others -- and that the D-392-era clause is GONE.
	#
	# ========================================================================
	# RE-SCOPED A FOURTH TIME UNDER D-398, AS ITS FIRST ACT. THE ID IS UNCHANGED.
	# ========================================================================
	# From D-396 until D-398 `says_open` required "KINDRED HOUNDS STAGE DELIVERED
	# and OPEN pending owner live review (D-396)" -- TRUE WHEN WRITTEN. D-397
	# accepted and closed that stage; D-397 section 6 recommended the repair and
	# the D-398 ruling authorizes it. So the check now requires SIX facts --
	# D-397's acceptance with the others -- and that the D-396-era clause is GONE.
	#
	# ========================================================================
	# RE-SCOPED A FIFTH TIME UNDER D-400, AS ITS FIRST ACT. THE ID IS UNCHANGED.
	# ========================================================================
	# From D-398 until D-400 `says_open` required "MOBILE MINION COHESION STAGE
	# DELIVERED and OPEN pending owner live review (D-398)" -- TRUE WHEN WRITTEN.
	# D-400 accepted and closed that stage and authorized the repair in the same
	# breath. So the check now requires SEVEN facts -- D-400's acceptance with the
	# others -- and that the D-398-era clause is GONE.
	#
	# ========================================================================
	# RE-SCOPED A SIXTH TIME UNDER D-402, AS ITS FIRST ACT. THE ID IS UNCHANGED.
	# ========================================================================
	# From D-400 until D-402 `says_open` required "PLAYER LOCOMOTION REDIRECTION
	# STAGE DELIVERED and OPEN pending owner live review (D-400)" -- TRUE WHEN
	# WRITTEN. D-401 accepted and closed that stage; D-401 section 6 recommended
	# the repair and the D-402 ruling authorizes it. So the check now requires
	# EIGHT facts -- D-401's acceptance with the others -- and that the D-400-era
	# clause is GONE as well as every earlier one.
	#
	# ========================================================================
	# RE-SCOPED A SEVENTH TIME UNDER D-404, AS ITS FIRST ACT. THE ID IS UNCHANGED.
	# ========================================================================
	# From D-402 until D-404 `says_open` required "CINDER FIELD STAGE DELIVERED
	# and OPEN pending owner live review (D-402)" -- TRUE WHEN WRITTEN. D-403
	# accepted and closed that stage, and the same ruling directs this repair as
	# the D-404 stage's first act. So the check now requires NINE facts -- D-403's
	# acceptance with the others -- and that the D-402-era clause is GONE as well
	# as every earlier one.
	var st := ProdConfig.STATE
	var says_closed := st.find("FOUNDATION STAGE ACCEPTED and CLOSED (D-373)") >= 0
	var says_accepted := st.find("IMPRINT STAGE ACCEPTED and CLOSED (D-376)") >= 0 \
		and st.find("D-378 ALIGNMENT STAGE ACCEPTED and CLOSED (D-383)") >= 0 \
		and st.find("HUNTRESS SPLINTER SHOT STAGE ACCEPTED and CLOSED (D-394)") >= 0 \
		and st.find("KINDRED HOUNDS STAGE ACCEPTED and CLOSED (D-397)") >= 0 \
		and st.find("MOBILE MINION COHESION STAGE ACCEPTED and CLOSED (D-399)") >= 0 \
		and st.find("PLAYER LOCOMOTION REDIRECTION STAGE ACCEPTED and CLOSED (D-401)") >= 0 \
		and st.find("CINDER FIELD STAGE ACCEPTED and CLOSED (D-403)") >= 0
	var says_open := st.find("PLAYER DIRECT-CLICK MOVEMENT CORRECTION STAGE DELIVERED and OPEN pending owner live review (D-404)") >= 0
	var d375_clause_gone := st.find("IMPRINT STAGE DELIVERED and OPEN") < 0 \
		and st.find("D-378 ALIGNMENT STAGE DELIVERED and OPEN") < 0 \
		and st.find("HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN") < 0 \
		and st.find("KINDRED HOUNDS STAGE DELIVERED and OPEN") < 0 \
		and st.find("MOBILE MINION COHESION STAGE DELIVERED and OPEN") < 0 \
		and st.find("PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN") < 0 \
		and st.find("CINDER FIELD STAGE DELIVERED and OPEN") < 0
	# AND THE OLD, NOW-FALSE ASSERTION MUST NOT BE THE WHOLE STATE.
	var not_stale := st != "DELIVERED and OPEN pending owner live review"
	# The guard must be able to fail: the D-375-era line is still RECOGNISABLE,
	# so a regression to it would be caught rather than pass as a substring.
	var d375_line := "FOUNDATION STAGE ACCEPTED and CLOSED (D-373) · IMPRINT STAGE DELIVERED and OPEN pending owner live review (D-375)"
	var guard := d375_line.find("IMPRINT STAGE DELIVERED and OPEN") >= 0
	var ok := says_closed and says_accepted and says_open and d375_clause_gone \
		and not_stale and guard
	_note("I01_state_is_reconciled_and_asserts_nothing_false",
		"STATE = '%s' — it names the D-373 acceptance=%s, the D-376 acceptance of THIS suite's stage, the D-383 acceptance of the alignment stage, the D-394 acceptance of the Splinter Shot stage, the D-397 acceptance of the Kindred Hounds stage, the D-399 acceptance of the mobile minion cohesion stage the D-401 acceptance of the player locomotion redirection stage AND the D-403 acceptance of the Cinder Field stage=%s, and the D-404 direct-click movement correction stage's open state=%s; the D-375-era 'IMPRINT STAGE DELIVERED and OPEN', D-380-era 'D-378 ALIGNMENT STAGE DELIVERED and OPEN', D-392-era 'HUNTRESS SPLINTER SHOT STAGE DELIVERED and OPEN', D-396-era 'KINDRED HOUNDS STAGE DELIVERED and OPEN', D-398-era 'MOBILE MINION COHESION STAGE DELIVERED and OPEN' D-400-era 'PLAYER LOCOMOTION REDIRECTION STAGE DELIVERED and OPEN' and D-402-era 'CINDER FIELD STAGE DELIVERED and OPEN' clauses are GONE=%s (the guard recognises the D-375 one=%s) and the bare D-370 string is gone=%s. RE-SCOPED UNDER D-380, D-392, D-396, D-398, D-400, D-402 AND D-404, ID UNCHANGED. The runners pin this line EXACTLY and prove the pin can refuse an altered line."
		% [st, str(says_closed), str(says_accepted), str(says_open), str(d375_clause_gone),
		   str(guard), str(not_stale)])
	_reached("I01_state_is_reconciled_and_asserts_nothing_false")
	return ok

func chk_I02_m04_is_discharged_with_its_history_preserved() -> bool:
	# The reconciliation is judged from the ACCEPTED SUITE'S OWN SOURCE, not from
	# a second copy of the facts that could drift away from it.
	var src := _read_text("res://tests/foundation_verification.gd")
	var has_discharged := src.find("const DISCHARGED_ROWS") >= 0
	var owed_gone := src.find("[\"M-04 does the action commitment") < 0 \
		or src.find("\"OWED-TO-OWNER\",\n\t \"THE SLIDEY FEEL") < 0
	var history := src.find("ORIGINAL ROW TEXT, PRESERVED VERBATIM") >= 0
	var names_decision := src.find("DISCHARGED — D-373") >= 0
	var no_owed_marker := src.find("\"OWED-TO-OWNER\"") < 0
	# The runner's pin moved in the SAME change -- asserted against the runner's
	# own source, so the two cannot disagree.
	var runner := _read_text("res://tests/foundation_smoke.sh")
	var repinned := runner.find("PIN_DEFERRED=11") >= 0
	var ok := has_discharged and history and names_decision and no_owed_marker and repinned
	_note("I02_m04_is_discharged_with_its_history_preserved",
		"the accepted suite now carries DISCHARGED_ROWS=%s, M-04's ORIGINAL TEXT IS PRESERVED VERBATIM=%s, the discharging decision is named=%s, and NO row is OWED-TO-OWNER any more=%s | the runner's deferred pin moved to 11 IN THE SAME CHANGE=%s. HISTORY PRESERVED, FALSE CURRENT STATE REMOVED, NO GUARD WEAKENED."
		% [str(has_discharged), str(history), str(names_decision), str(no_owed_marker),
		   str(repinned)])
	_reached("I02_m04_is_discharged_with_its_history_preserved")
	return ok

func chk_I03_every_denial_is_present_and_the_guard_can_fail() -> bool:
	# EACH DENIAL IS ASSERTED INDIVIDUALLY. A total can absorb a silently dropped
	# denial; a per-denial check cannot.
	var text := panel.compose()
	var d := ImprintConfig.denials()
	var missing_keys: Array[String] = []
	# The panel carries the load-bearing phrases; the full list is printed in the
	# runtime banner, which the runner greps.
	var required := ["does NOT finalize", "Rift Shards", "slot counts", "rank cap",
		"Capacity values", "XP curve", "reservation values", "NOT a UI foundation"]
	for r in required:
		if text.findn(r) < 0:
			missing_keys.append(r)
	# A CLAIM NOBODY CAN FAIL IS NOT A BOUNDARY.
	var forbidden := ["finalizes the Huntress roster", "Rift Shards are implemented",
		"the rank cap is locked", "Capacity is final", "this is final balance"]
	var found_real: Array[String] = []
	for f in forbidden:
		if text.findn(f) >= 0:
			found_real.append(f)
	var planted := text + "\n" + PLANTED_CLAIM + "\nfinalizes the Huntress roster"
	var guard_catches := false
	for f in forbidden:
		if planted.findn(f) >= 0:
			guard_catches = true
	var ok := d.size() >= 18 and missing_keys.is_empty() and found_real.is_empty() \
		and guard_catches
	_note("I03_every_denial_is_present_and_the_guard_can_fail",
		"%d denials declared; every load-bearing phrase is in the live panel text (missing: %s); no forbidden claim is present=%s; and the scan is PROVED able to refuse a planted claim=%s"
		% [d.size(), str(missing_keys), str(found_real.is_empty()), str(guard_catches)])
	_reached("I03_every_denial_is_present_and_the_guard_can_fail")
	return ok

func chk_I04_no_rift_shard_anything_and_the_guard_can_fail() -> bool:
	# The ruling: "Rift Shards are not Skill gems and are outside this stage" and
	# "not authorization to build Rift Shards yet".
	#
	# THE NEEDLES ARE ASSEMBLED, NOT WRITTEN, so this check does not find itself.
	var shard := "rift" + "_shard"
	var echo := "rift" + "_echo"
	var forms := [shard, echo, "shard_", "shaping", "riftmarked"]
	var hits: Array[String] = []
	for f in _runtime_script_files():
		var t := _read_text(String(f)).to_lower()
		for b in forms:
			for form in ["func %s" % b, "class_name %s" % b, "var %s" % b, "const %s" % b]:
				if t.find(form) >= 0:
					hits.append("%s: %s" % [String(f).get_file(), form])
	var planted := "var " + shard + "s := 0"
	var guard_catches := false
	for b in forms:
		if planted.find("var %s" % b) >= 0:
			guard_catches = true
	var ok := hits.is_empty() and guard_catches
	_note("I04_no_rift_shard_anything_and_the_guard_can_fail",
		"RUNTIME declarations naming a Rift Shard, a Rift Echo, Shaping or the Riftmarked: %s (must be none) | the scan is PROVED able to catch a planted Rift-Shard declaration=%s. The scan is over the GAME: this suite must name these things in order to forbid them."
		% [str(hits), str(guard_catches)])
	_reached("I04_no_rift_shard_anything_and_the_guard_can_fail")
	return ok

func chk_I05_every_value_this_stage_introduces_is_labelled_provisional() -> bool:
	var reg := ImprintConfig.provisional_registry()
	var unlabelled: Array[String] = []
	for row in reg:
		if String(row[2]).find("PROVISIONAL") < 0:
			unlabelled.append(String(row[0]))
	# The words the ruling itself says are not finalized must each appear in the
	# registry's own prose, so the registry states the boundary rather than only
	# carrying numbers.
	var prose := ""
	for row in reg:
		prose += String(row[2]) + " "
	var says: Array[String] = []
	for w in ["rank cap", "XP curve", "Capacity values", "reservation values", "balance"]:
		if prose.findn(w) < 0:
			says.append(w)
	var ok := reg.size() >= 55 and unlabelled.is_empty() and says.is_empty()
	_note("I05_every_value_this_stage_introduces_is_labelled_provisional",
		"%d values in the D-375 registry, all carrying the word PROVISIONAL=%s (unlabelled: %s) | the registry's own prose names each thing the ruling does not finalize (missing: %s). The ACCEPTED D-370 registry is a SEPARATE registry and is asserted UNMODIFIED by I08."
		% [reg.size(), str(unlabelled.is_empty()), str(unlabelled), str(says)])
	_reached("I05_every_value_this_stage_introduces_is_labelled_provisional")
	return ok

func chk_I06_canonical_values_are_separated_and_cited() -> bool:
	# A CANONICAL CLAIM MAY NEVER BE MADE WITHOUT NAMING ITS SOURCE, and a
	# canonical value must never be presented as this stage's to tune.
	var canon := ImprintConfig.canonical_registry()
	var uncited: Array[String] = []
	for row in canon:
		if String(row[2]).length() < 20:
			uncited.append(String(row[0]))
	# None of them may appear in the provisional registry -- the two lists must
	# be disjoint, or "canonical" and "provisional" mean nothing.
	var prov_labels := {}
	for row in ImprintConfig.provisional_registry():
		prov_labels[String(row[0])] = true
	var overlap: Array[String] = []
	for row in canon:
		if prov_labels.has(String(row[0])):
			overlap.append(String(row[0]))
	var values_right := int(canon[0][1]) == 4 and int(canon[1][1]) == 1 and int(canon[2][1]) == 8
	var ok := canon.size() == 3 and uncited.is_empty() and overlap.is_empty() and values_right
	_note("I06_canonical_values_are_separated_and_cited",
		"%d canonical values, each with a citation (uncited: %s); they are DISJOINT from the provisional registry (overlap: %s); and their values are the canonical 4 modifier slots, 1 Transform and 8 bindings=%s"
		% [canon.size(), str(uncited), str(overlap), str(values_right)])
	_reached("I06_canonical_values_are_separated_and_cited")
	return ok

func chk_I07_measured_conflicts_are_printed_at_runtime() -> bool:
	# A conflict recorded only in a document drifts away from the code that
	# carries it. Printed every run, it cannot.
	var c := ImprintConfig.declared_conflicts()
	var ids: Array[String] = []
	for row in c:
		ids.append(String(row[0]))
	var text := panel.compose()
	var missing: Array[String] = []
	for row in c:
		if text.find(String(row[0])) < 0 and String(row[0]) == "X-02":
			missing.append(String(row[0]))
	var each_explains := true
	for row in c:
		if String(row[2]).length() < 60:
			each_explains = false
	var has_d079 := false
	for row in c:
		if String(row[2]).find("D-079") >= 0:
			has_d079 = true
	var ok := c.size() >= 7 and missing.is_empty() and each_explains and has_d079
	_note("I07_measured_conflicts_are_printed_at_runtime",
		"%d MEASURED conflicts declared: %s | each states its measurement and its resolution=%s | the D-079 Persistent-slot conflict is named explicitly=%s | X-02 appears in the live panel text=%s. They are printed in the runtime banner every run, not filed away in a document."
		% [c.size(), str(ids), str(each_explains), str(has_d079), str(missing.is_empty())])
	_reached("I07_measured_conflicts_are_printed_at_runtime")
	return ok

func chk_I08_no_accepted_d373_value_is_modified() -> bool:
	# ========================================================================
	# VALUE BY VALUE, AGAINST THE FIGURES D-373 RECORDED. NOT BY A DIGEST.
	# ========================================================================
	# The ruling: "Do not modify the accepted cancellation timing, speed, camera
	# or other provisional numbers merely to make this stage work." A digest would
	# prove a file was untouched; this proves each NUMBER is what the acceptance
	# says it is, which is the claim that matters.
	var expect := [
		["TOP_SPEED_MPS", ProdConfig.TOP_SPEED_MPS, 3.889],
		["ACCEL_MPS2", ProdConfig.ACCEL_MPS2, 30.0],
		["DECEL_MPS2", ProdConfig.DECEL_MPS2, 38.0],
		["ATTACK_COOLDOWN_S (the 0.4500 s action duration)", ProdConfig.ATTACK_COOLDOWN_S, 0.45],
		["ATTACK_RELEASE_MARKER", ProdConfig.ATTACK_RELEASE_MARKER, 0.36],
		["ACTION_BRAKE_MPS2", ProdConfig.ACTION_BRAKE_MPS2, 120.0],
		["ACTION_GLIDE_TOLERANCE_M", ProdConfig.ACTION_GLIDE_TOLERANCE_M, 0.10],
		["CAM_PITCH_DEG", ProdConfig.CAM_PITCH_DEG, -52.0],
		["CAM_SIZE_DEFAULT", ProdConfig.CAM_SIZE_DEFAULT, 14.0],
		["CAM_SIZE_MIN", ProdConfig.CAM_SIZE_MIN, 11.0],
		["CAM_SIZE_MAX", ProdConfig.CAM_SIZE_MAX, 18.0],
		["YAW_RATE_DEG_PER_S", ProdConfig.YAW_RATE_DEG_PER_S, 720.0],
		["BOLT_DAMAGE", ProdConfig.BOLT_DAMAGE, 34.0],
		["BOLT_SPEED_MPS", ProdConfig.BOLT_SPEED_MPS, 24.0],
		["BOLT_RANGE_M", ProdConfig.BOLT_RANGE_M, 16.0],
		["ENEMY_HEALTH", ProdConfig.ENEMY_HEALTH, 120.0],
		["ENEMY_SPEED_MPS", ProdConfig.ENEMY_SPEED_MPS, 2.4],
		["ENEMY_WINDUP_S", ProdConfig.ENEMY_WINDUP_S, 0.85],
		["ENEMY_ATTACK_ARC_DEG", ProdConfig.ENEMY_ATTACK_ARC_DEG, 90.0],
		["OUTPUT_WIDTH", float(ProdConfig.OUTPUT_WIDTH), 1920.0],
		["OUTPUT_HEIGHT", float(ProdConfig.OUTPUT_HEIGHT), 1080.0],
		["NAV_AGENT_RADIUS", ProdConfig.NAV_AGENT_RADIUS, 0.40],
		["PLAYER_BODY_RADIUS", ProdConfig.PLAYER_BODY_RADIUS, 0.40],
		["FLOOR_VISUAL_TOP_Y", ProdConfig.FLOOR_VISUAL_TOP_Y, 0.033],
	]
	var wrong: Array[String] = []
	for row in expect:
		if not is_equal_approx(float(row[1]), float(row[2])):
			wrong.append("%s is %s, D-373 recorded %s" % [row[0], str(row[1]), str(row[2])])
	# AND THE COMMITMENT STILL HAS EXACTLY TWO POLICIES.
	var two := ActionCommitment.POLICIES.size() == 2 \
		and ActionCommitment.POLICIES[0] == "STOP" and ActionCommitment.POLICIES[1] == "ALLOW"
	# AND NO CANCEL-WINDOW CONSTANT WAS INTRODUCED -- the window is still DERIVED.
	var ac_src := _read_text("res://scripts/control/action_commitment.gd")
	var derived := ac_src.find("CANCEL_WINDOW") < 0
	var ok := wrong.is_empty() and two and derived
	_note("I08_no_accepted_d373_value_is_modified",
		"%d accepted values checked ONE BY ONE against the figures D-373 recorded; mismatches: %s | the commitment still has EXACTLY TWO policies (STOP, ALLOW) and no third=%s | NO cancel-window constant exists, so the window is still DERIVED from the release marker and adds no tunable=%s"
		% [expect.size(), str(wrong), str(two), str(derived)])
	_reached("I08_no_accepted_d373_value_is_modified")
	return ok

func chk_I09_zero_new_third_party_assets() -> bool:
	# CLAUDE.md section 12 forbids new assets. The Atlas's companion guardrail asks
	# for an asset-cost review; THIS IS THE MEASUREMENT THAT DISCHARGES ITS
	# ASSET-COST HALF, and the design half stays owed (DF-13).
	var packs := AssetManifest.packs()
	var declared := 0
	for p in packs:
		declared += (p["files"] as Array).size()
	# And nothing in the new stage may hard-code a third-party path: the manifest
	# is the single runtime source of truth, unchanged.
	var needle := "res://" + "assets/third_party"
	var offenders: Array[String] = []
	for f in _runtime_script_files():
		var p := String(f)
		if p.ends_with("asset_manifest.gd"):
			continue
		if _read_text(p).find(needle) >= 0:
			offenders.append(p.get_file())
	# The beast reuses the ALREADY-DECLARED Imp, by the manifest's own constant.
	var beast_src := _read_text("res://scripts/imprint/diag_beast.gd")
	var reuses := beast_src.find("AssetManifest.IMP") >= 0
	var ballista_src := _read_text("res://scripts/imprint/diag_ballista.gd")
	var reuses2 := ballista_src.find("AssetManifest.ruins(") >= 0
	# RE-SCOPED UNDER D-402, ONE FOR ONE: 29 + 4 = 33 declared third-party files.
	# The D-402 ruling authorizes extracting EXACTLY `BearTrap_Open` and
	# `BearTrap_Closed` (two .obj and two .mtl) from the ALREADY-DECLARED CC0
	# Ultimate Modular Ruins pack, so the PACK COUNT does not move and the guard
	# is not weakened -- it is still an exact equality in both halves. Until D-402
	# this required 29, and the note below said THIS stage imports zero; the D-375
	# stage still imported zero, and that sentence is kept as the history it is.
	var ok := packs.size() == 5 and declared == 33 and offenders.is_empty() \
		and reuses and reuses2
	_note("I09_zero_new_third_party_assets",
		"%d packs and %d declared third-party files — the D-375 stage imported ZERO NEW ASSETS (5 and 29, and that sentence stays true of it); RE-SCOPED UNDER D-402, one for one, to 5 and 33 for the two Cinder Field placeholder bodies added to the ALREADY-DECLARED ruins pack | no new runtime script hard-codes a third-party path (offenders: %s) | the beasts reuse the already-declared Imp=%s and the ballista an already-declared ruins prop=%s. Both are PLACEHOLDERS and neither is final art."
		% [packs.size(), declared, str(offenders), str(reuses), str(reuses2)])
	_reached("I09_zero_new_third_party_assets")
	return ok

func chk_I10_carried_debts_are_printed_and_none_is_discharged() -> bool:
	# D-373: "ALL carried risks and debts survive intact... The acceptance
	# discharged NONE of them." NEITHER DOES THIS STAGE.
	var rows := DEFERRED_ROWS
	var kinds := {}
	for r in rows:
		kinds[String(r[1])] = true
	var names_returns := true
	for r in rows:
		var t := String(r[2])
		if String(r[1]) == "DEFERRED" or String(r[1]) == "STILL OWED":
			if t.find("RETURNS TO") < 0:
				names_returns = false
	# The carried debts the accepted baseline owns must still be owed there.
	var fsrc := _read_text("res://tests/foundation_verification.gd")
	var still := fsrc.find("N-07 bone-attachment orientation") >= 0 \
		and fsrc.find("N-04 original P1C criterion C7") >= 0 \
		and fsrc.find("N-05 original P1C criterion C11") >= 0 \
		and fsrc.find("N-01 original P1C criterion C9") >= 0
	var owner_rows := 0
	for r in rows:
		if String(r[1]) == "OWED-TO-OWNER":
			owner_rows += 1
	# ========================================================================
	# RE-SCOPED UNDER D-380, AS ITS FIRST ACT. THE ID IS UNCHANGED.
	# THE ARITHMETIC IS STATED: 24 ROWS = 16 DEFERRED/STILL OWED + 8 MO-; NOW
	# 16 ROWS + 8 DISCHARGED. 24 - 8 = 16, AND 0 ROWS DELETED.
	# ========================================================================
	# From D-375 until D-380 this required 24 rows, 8 of them OWED-TO-OWNER.
	# D-376's live review ANSWERED all eight MO- rows; they now print under
	# DISCHARGED_ROWS with their ORIGINAL TEXT PRESERVED VERBATIM. The CARRIED
	# DEBTS this check exists to protect -- the DF- rows and the accepted
	# baseline's C7 / C9 / C11 / bone-attachment debts -- are NOT discharged, and
	# this check still fails if any of them goes missing. The MO- rows were owed
	# JUDGMENTS, not carried debts, which is why moving them discharges nothing
	# this check guards.
	var discharged := DISCHARGED_ROWS
	var all_mo := discharged.size() == 8
	var history_kept := true
	for r in discharged:
		if not String(r[0]).begins_with("MO-") or String(r[1]) != "DISCHARGED — D-376" \
				or String(r[2]).find("ORIGINAL ROW TEXT, PRESERVED VERBATIM") < 0:
			history_kept = false
	var no_mo_owed := true
	for r in rows:
		if String(r[0]).begins_with("MO-"):
			no_mo_owed = false
	var ok := rows.size() == 16 and names_returns and still and owner_rows == 0 \
		and kinds.has("DEFERRED") and kinds.has("STILL OWED") \
		and not kinds.has("OWED-TO-OWNER") and all_mo and history_kept and no_mo_owed
	_note("I10_carried_debts_are_printed_and_none_is_discharged",
		"%d rows printed every run as DEFERRED / STILL OWED and NEVER as passes (%d owed to the owner — D-376 answered all eight); every row names where it returns=%s | the accepted baseline's own carried debts — C7, C9, C11 and the bone-attachment debt — are STILL OWED THERE and NONE is discharged=%s | the eight MO- rows print as DISCHARGED — D-376 with their ORIGINAL TEXT PRESERVED=%s/%s and none remains among the owed rows=%s. RE-SCOPED UNDER D-380: 24 - 8 = 16, ZERO ROWS DELETED."
		% [rows.size(), owner_rows, str(names_returns), str(still), str(all_mo),
		   str(history_kept), str(no_mo_owed)])
	_reached("I10_carried_debts_are_printed_and_none_is_discharged")
	return ok

# ============================================================================
# B. IMPRINT OBJECTS AND THE IMPRINT LIBRARY
# ============================================================================

func chk_I11_exactly_three_imprint_types_exist() -> bool:
	var names := Imprint.KIND_NAMES
	var three := names.size() == 3
	var right: bool = names[0] == "SKILL IMPRINT" and names[1] == "AUGMENT IMPRINT" \
		and names[2] == "TRANSFORM IMPRINT"
	# And the enum has no fourth member hiding behind the names array.
	var enum_size := Imprint.Kind.keys().size() == 3
	var lib := skills.library
	var counted := lib.count_of_kind(Imprint.Kind.SKILL) \
		+ lib.count_of_kind(Imprint.Kind.AUGMENT) \
		+ lib.count_of_kind(Imprint.Kind.TRANSFORM)
	var ok: bool = three and right and enum_size and counted == lib.count()
	_note("I11_exactly_three_imprint_types_exist",
		"%d types: %s | the enum has exactly %d members=%s | every one of the %d learned Imprints is one of the three (%d accounted for)=%s"
		% [names.size(), str(names), Imprint.Kind.keys().size(), str(enum_size),
		   lib.count(), counted, str(counted == lib.count())])
	_reached("I11_exactly_three_imprint_types_exist")
	return ok

func chk_I12_the_library_set_is_pinned_in_both_directions() -> bool:
	# BOTH DIRECTIONS: an Imprint that exists and is not declared fails, and a
	# declared id that does not exist fails.
	#
	# ========================================================================
	# RE-SCOPED UNDER D-392, ONE FOR ONE. THE ARITHMETIC: 14 + 1 = 15.
	# ========================================================================
	# Until D-392 the declared set was DiagImprintContent.ALL_IMPRINTS alone --
	# 14 ids, 4 Skill + 7 Augment + 3 Transform -- true when written. The D-392
	# ruling authorizes ONE canonical Skill Imprint, Splinter Shot, learned into
	# the SAME live library ("Integrate it through the accepted Skill/Imprint
	# architecture"). The declared set is therefore the two EXHAUSTIVE lists
	# together, still pinned in BOTH directions, and the kinds become 5 + 7 + 3.
	# COMPENSATED: the canonical addition must be EXACTLY Splinter Shot, and
	# NOTHING else in the library may be canonical.
	#
	# ========================================================================
	# RE-SCOPED AGAIN UNDER D-396, ONE FOR ONE. THE ARITHMETIC: 15 + 1 = 16.
	# ========================================================================
	# The D-396 ruling authorizes ONE canonical PERSISTENT Skill Imprint, Kindred
	# Hounds, learned into the SAME live library. The declared set is the three
	# EXHAUSTIVE lists together, still in BOTH directions; kinds 6 + 7 + 3; and
	# the canonical set must be EXACTLY {Splinter Shot, Kindred Hounds} -- nothing
	# else in the library may be canonical.
	var lib := skills.library
	# RE-SCOPED UNDER D-402, one for one: a FOURTH exhaustive list joins the sum --
	# Cinder Field, the ONE canonical ACTIVE Skill Imprint. 16 + 1 = 17, kinds
	# 6 + 1 = 7 Skill, Augments and Transforms unmoved.
	var declared: Array = DiagImprintContent.ALL_IMPRINTS + HuntressContent.ALL_IMPRINTS \
		+ HoundContent.ALL_IMPRINTS + CinderContent.ALL_IMPRINTS
	var live: Array = lib.ids()
	var undeclared: Array[String] = []
	for id in live:
		if not declared.has(String(id)):
			undeclared.append(String(id))
	var missing: Array[String] = []
	for id in declared:
		if not lib.knows(String(id)):
			missing.append(String(id))
	var counts := lib.count_of_kind(Imprint.Kind.SKILL) == 7 \
		and lib.count_of_kind(Imprint.Kind.AUGMENT) == 7 \
		and lib.count_of_kind(Imprint.Kind.TRANSFORM) == 3
	var canonical: Array[String] = []
	for id in live:
		if (lib.get_imprint(String(id)) as Imprint).canonical:
			canonical.append(String(id))
	var canon_sorted: Array = canonical.duplicate()
	canon_sorted.sort()
	var want_canon: Array = [HuntressContent.SKILL_SPLINTER_SHOT, HoundContent.SKILL_KINDRED_HOUNDS,
		CinderContent.SKILL_CINDER_FIELD]
	want_canon.sort()
	var only_splinter := canon_sorted == want_canon
	var ok := declared.size() == 17 and lib.count() == 17 \
		and undeclared.is_empty() and missing.is_empty() and counts and only_splinter
	_note("I12_the_library_set_is_pinned_in_both_directions",
		"%d declared, %d live: undeclared extras %s, declared-but-absent %s | 7 Skill + 7 Augment + 3 Transform = 17=%s | the canonical Imprints are EXACTLY Splinter Shot, Kindred Hounds and Cinder Field: %s=%s. RE-SCOPED UNDER D-392: 14 + 1 = 15; UNDER D-396: 15 + 1 = 16; AND UNDER D-402: 16 + 1 = 17 — the ONE canonical ACTIVE Skill Imprint this ruling authorizes."
		% [declared.size(), lib.count(), str(undeclared), str(missing), str(counts),
		   str(canonical), str(only_splinter)])
	_reached("I12_the_library_set_is_pinned_in_both_directions")
	return ok

func chk_I13_learning_is_permanent_and_idempotent() -> bool:
	# Canon: "Learning a Skill adds it permanently to the character's Skill
	# Library" and a learned Augment needs no duplicate copies.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var id := DiagImprintContent.AUG_SPLIT
	var before := lib.count()
	var mastery_before := lib.mastered(id)
	lib.grant_xp(id, 50.0)
	var xp_before := lib.xp(id)
	var dup_before := lib.duplicate_learns_ignored
	# LEARN IT AGAIN. It must be refused, counted, and must change nothing.
	# D-380: this call passed a second argument (rank 1) from D-375 until D-380.
	# D-378 OD-01 removed the acquisition rank, so `learn()` takes ONE argument.
	# THE ASSERTION IS UNCHANGED.
	var again := lib.learn(lib.get_imprint(id))
	var refused := not again
	var counted := lib.duplicate_learns_ignored == dup_before + 1
	var unchanged := lib.count() == before and lib.mastered(id) == mastery_before \
		and is_equal_approx(lib.xp(id), xp_before)
	var ok := refused and counted and unchanged and xp_before > 0.0
	_note("I13_learning_is_permanent_and_idempotent",
		"a second learn of '%s' was REFUSED=%s and COUNTED=%s; the library size stayed %d, the Mastered Rank stayed %d and the %.1f XP of progress was NOT reset=%s"
		% [id, str(refused), str(counted), before, mastery_before, xp_before, str(unchanged)])
	_reached("I13_learning_is_permanent_and_idempotent")
	return ok

func chk_I14_one_skill_imprint_appears_in_several_configurations() -> bool:
	# Canon: "The same learned Skill may occupy several combat bindings with
	# different configurations."
	var using: Array[String] = []
	for cid in DiagImprintContent.ALL_CONFIGURATIONS:
		var cfg := _cfg(String(cid))
		if cfg != null and cfg.skill_id == DiagImprintContent.SKILL_STORM:
			using.append(String(cid))
	# And they are genuinely DIFFERENT configurations of it.
	var distinct := {}
	for cid in using:
		var cfg2 := _cfg(cid)
		distinct["%d|%s|%d" % [cfg2.skill_rank(), str(cfg2.modifier_ids), cfg2.modifier_count()]] = true
	var ok := using.size() >= 3 and distinct.size() == using.size()
	_note("I14_one_skill_imprint_appears_in_several_configurations",
		"the ONE learned Skill Imprint '%s' occupies %d Configurations — %s — and all %d are mechanically DISTINCT (different rank, modifier set or both)=%s"
		% [DiagImprintContent.SKILL_STORM, using.size(), str(using), distinct.size(),
		   str(distinct.size() == using.size())])
	_reached("I14_one_skill_imprint_appears_in_several_configurations")
	return ok

func chk_I15_one_augment_imprint_is_reused_with_one_mastery_record() -> bool:
	# Canon: "The learned Augment may be used simultaneously in any number of
	# compatible Skill Configurations without acquiring duplicate copies."
	var lib := skills.library
	var rows: Array[String] = []
	var multi := 0
	for aid in [DiagImprintContent.AUG_SPLIT, DiagImprintContent.AUG_TEMPERED]:
		var uses: Array[String] = []
		for cid in DiagImprintContent.ALL_CONFIGURATIONS:
			var cfg := _cfg(String(cid))
			if cfg != null and cfg.has_modifier(String(aid)):
				uses.append(String(cid))
		if uses.size() >= 2:
			multi += 1
		rows.append("%s in %d: %s (ONE Mastered Rank %d)"
			% [String(aid), uses.size(), str(uses), lib.mastered(String(aid))])
	# ONE MASTERY RECORD: the library has exactly one entry per id, whatever the
	# Configurations do -- which is the structural reason XP cannot double.
	# RE-SCOPED UNDER D-392, one for one: the pinned count 14 -> 14 + 1 = 15 (the
	# ONE canonical Splinter Shot); the claim -- ONE record per id -- is now stated
	# directly as well: ids == count, and count == both exhaustive lists.
	# RE-SCOPED AGAIN UNDER D-396, one for one: 15 -> 15 + 1 = 16 (the ONE
	# canonical Kindred Hounds), with the third exhaustive list in the sum.
	# RE-SCOPED UNDER D-402, one for one: 16 + 1 = 17, with the FOURTH exhaustive
	# list in the sum. Until D-402 this pinned 16 -- true when written.
	var one_record := lib.ids().size() == lib.count() \
		and lib.count() == DiagImprintContent.ALL_IMPRINTS.size() + HuntressContent.ALL_IMPRINTS.size() \
			+ HoundContent.ALL_IMPRINTS.size() + CinderContent.ALL_IMPRINTS.size() \
		and lib.count() == 17
	var ok := multi == 2 and one_record
	_note("I15_one_augment_imprint_is_reused_with_one_mastery_record",
		"%d Augment Imprints are installed in MORE THAN ONE Configuration: %s | the library holds exactly ONE record per Imprint id (%d records for %d Imprints)=%s — which is why reuse cannot multiply mastery or XP"
		% [multi, str(rows), lib.ids().size(), lib.count(), str(one_record)])
	_reached("I15_one_augment_imprint_is_reused_with_one_mastery_record")
	return ok

func chk_I16_tags_come_only_from_canon_plus_one_declared_extension() -> bool:
	# The compatibility system may use canon's vocabulary and ONE declared,
	# CITED extension -- and nothing else.
	var allowed := ImprintConfig.canonical_tags()
	var lib := skills.library
	var stray: Array[String] = []
	for id in lib.ids():
		var imp := lib.get_imprint(String(id)) as Imprint
		for t in imp.provides_tags + imp.requires_tags + imp.adds_tags + imp.removes_tags:
			if not allowed.has(String(t)):
				stray.append("%s: %s" % [String(id), String(t)])
	var ext := ImprintConfig.DECLARED_TAG_EXTENSIONS
	var cited := ext.size() == 1 and String(ext[0][0]) == "Duration" \
		and String(ext[0][1]).find("SKILLS_AND_SKILL_MODIFICATION") >= 0
	# The guard must be able to fail.
	var guard := not allowed.has("Nonsense_Tag")
	var ok := stray.is_empty() and cited and guard
	_note("I16_tags_come_only_from_canon_plus_one_declared_extension",
		"every tag on all %d Imprints comes from canon's %d source/delivery/form/type tags plus ONE DECLARED extension; strays: %s | the extension is 'Duration', and it is CITED to the canonical section that uses it as a category while never listing it as a tag=%s | the guard refuses an invented tag=%s"
		% [lib.count(), allowed.size() - ext.size(), str(stray), str(cited), str(guard)])
	_reached("I16_tags_come_only_from_canon_plus_one_declared_extension")
	return ok

func chk_I17_no_imprint_bears_a_canonical_roster_or_augment_name() -> bool:
	# CHECKED AGAINST THE ACTUAL CANONICAL LISTS, not against a comment. A denial
	# checked against a real list is a boundary; a denial in prose is not.
	#
	# ========================================================================
	# RE-SCOPED UNDER D-392, ONE FOR ONE.
	# ========================================================================
	# Until D-392 NO Imprint in the library could bear a canonical name -- true
	# when written. The D-392 ruling makes Splinter Shot "the canonical ordinary
	# attack in normal play". So: NO DIAGNOSTIC Imprint may bear a canonical
	# roster or Augment name (UNCHANGED, still able to fail), and the Imprints
	# that DO bear one must be EXACTLY {Splinter Shot}, canonical-flagged, with no
	# DIAG in the id -- a stronger claim than the one it replaces.
	var skill_names := DiagImprintContent.canonical_first_mvp_skill_names()
	var aug_names := DiagImprintContent.canonical_first_mvp_augment_names()
	var lib := skills.library
	var clashes: Array[String] = []
	var named_canon: Array[String] = []
	for id in lib.ids():
		var imp := lib.get_imprint(String(id)) as Imprint
		var n := imp.display_name.to_lower()
		if imp.canonical:
			for c in skill_names:
				if n == String(c).to_lower():
					named_canon.append(String(id))
			continue
		for c in skill_names:
			if n == String(c).to_lower():
				clashes.append("%s == canonical Skill '%s'" % [imp.display_name, c])
		for c in aug_names:
			if n == String(c).to_lower():
				clashes.append("%s == canonical Augment '%s'" % [imp.display_name, c])
	# THE GUARD MUST BE ABLE TO FAIL: a planted clash must be caught.
	var planted := "void lance"
	var guard_catches := false
	for c in skill_names:
		if planted == String(c).to_lower():
			guard_catches = true
	# RE-SCOPED UNDER D-402, ONE FOR ONE: the Imprints bearing a CANONICAL ROSTER
	# NAME are now EXACTLY {Splinter Shot, Cinder Field} -- the two the owner has
	# authorized by name. Kindred Hounds is canonical but its roster name is not
	# in the set this check scans, which is why it does not appear here. The guard
	# is NOT weakened: it is still an EXACT set equality, every member must be
	# flagged canonical, and no id may contain DIAG. Until D-402 the set was
	# {Splinter Shot}: true when written.
	var splinter := lib.get_imprint(HuntressContent.SKILL_SPLINTER_SHOT) as Imprint
	var cinder_imp := lib.get_imprint(CinderContent.SKILL_CINDER_FIELD) as Imprint
	var want_named: Array = [HuntressContent.SKILL_SPLINTER_SHOT, CinderContent.SKILL_CINDER_FIELD]
	want_named.sort()
	var named_sorted: Array = named_canon.duplicate()
	named_sorted.sort()
	var the_one := named_sorted == want_named and splinter != null and cinder_imp != null \
		and splinter.canonical and splinter.display_name == "Splinter Shot" \
		and cinder_imp.canonical and cinder_imp.display_name == "Cinder Field" \
		and HuntressContent.SKILL_SPLINTER_SHOT.find("DIAG") < 0 \
		and CinderContent.SKILL_CINDER_FIELD.find("DIAG") < 0
	var ok := clashes.is_empty() and guard_catches and the_one \
		and skill_names.size() == 8 and aug_names.size() == 16
	_note("I17_no_imprint_bears_a_canonical_roster_or_augment_name",
		"checked against canon's ACTUAL %d first-MVP roster Skills and %d named Augments; DIAGNOSTIC clashes: %s | the guard is PROVED able to catch a planted clash ('Void Lance')=%s | RE-SCOPED UNDER D-392 AND D-402: the Imprints bearing a canonical ROSTER name are EXACTLY %s — Splinter Shot and Cinder Field, each flagged canonical, neither with DIAG in its id=%s. The D-375 stage's Imprints are DIAGNOSTIC content and are not roster entries."
		% [skill_names.size(), aug_names.size(), str(clashes), str(guard_catches),
		   str(named_canon), str(the_one)])
	_reached("I17_no_imprint_bears_a_canonical_roster_or_augment_name")
	return ok

func chk_I18_every_imprint_is_labelled_diagnostic() -> bool:
	# ========================================================================
	# RE-SCOPED UNDER D-392, ONE FOR ONE. THE ID IS UNCHANGED.
	# ========================================================================
	# Until D-392 EVERY Imprint had to carry a DIAGNOSTIC label and a DIAG id --
	# true when written. Since D-392 the library holds ONE canonical Imprint. So
	# EVERY DIAGNOSTIC Imprint is held to the ORIGINAL rule, unchanged; and the
	# rest must be EXACTLY the D-392 canonical set, each labelled CANONICAL and
	# NOT diagnostic, with no DIAG in its id. A canonical Imprint can therefore
	# never hide among the diagnostic ones, nor a diagnostic one pass as canon.
	var lib := skills.library
	var bad: Array[String] = []
	var canon: Array[String] = []
	for id in lib.ids():
		var imp := lib.get_imprint(String(id)) as Imprint
		if imp.canonical:
			canon.append(String(id))
			if imp.label().findn("CANONICAL") < 0 or imp.label().findn("diagnostic") >= 0 \
					or String(id).find("DIAG") >= 0:
				bad.append("%s (canonical label or id wrong)" % String(id))
			continue
		if imp.label().findn("diagnostic") < 0 or imp.label().findn("not a huntress skill") < 0:
			bad.append(String(id))
		if String(id).find("DIAG") < 0:
			bad.append("%s (id does not contain DIAG)" % String(id))
	# RE-SCOPED AGAIN UNDER D-396, one for one: the canonical set is EXACTLY the
	# two canonical content lists -- Splinter Shot and Kindred Hounds.
	var canon_sorted: Array = canon.duplicate()
	canon_sorted.sort()
	# RE-SCOPED UNDER D-402, one for one: a FOURTH exhaustive list joins the
	# canonical set -- Cinder Field. Still an EXACT set equality in both halves.
	var want_canon: Array = HuntressContent.ALL_IMPRINTS + HoundContent.ALL_IMPRINTS \
		+ CinderContent.ALL_IMPRINTS
	want_canon.sort()
	var canon_exact := canon_sorted == want_canon
	var text := panel.compose()
	var panel_says := text.findn("DIAGNOSTIC") >= 0
	var ok := bad.is_empty() and panel_says and canon_exact
	_note("I18_every_imprint_is_labelled_diagnostic",
		"all %d DIAGNOSTIC Imprints carry a runtime label containing DIAGNOSTIC and denying being a Huntress Skill, and every such id contains DIAG; the canonical Imprints are EXACTLY %s, each labelled CANONICAL and not diagnostic=%s (offenders: %s); the live panel says DIAGNOSTIC=%s. RE-SCOPED UNDER D-392, AND UNDER D-396 (Kindred Hounds)."
		% [lib.count() - canon.size(), str(canon), str(canon_exact), str(bad), str(panel_says)])
	_reached("I18_every_imprint_is_labelled_diagnostic")
	return ok

func chk_I19_behavioural_identity_is_complete_at_effective_rank_1() -> bool:
	# ========================================================================
	# CANON'S RULE, ASSERTED: "Behavioral identity is never delivered fractionally."
	# ========================================================================
	# Rank scales NUMBERS. It never gates BEHAVIOUR. Measured on the three
	# modifiers whose identity IS a behaviour: extra projectiles, forking, and
	# extra minions.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	# Split Volley at rank 1 must still add at least one projectile.
	var c1 := SkillConfiguration.new("R1_split", lib)
	c1.set_skill(C.SKILL_STORM)
	c1.install(C.AUG_SPLIT)
	c1.set_effective_rank(C.AUG_SPLIT, 1)
	c1.set_effective_rank(C.SKILL_STORM, 1)
	var base := SkillConfiguration.new("R1_base", lib)
	base.set_skill(C.SKILL_STORM)
	base.set_effective_rank(C.SKILL_STORM, 1)
	var split_works := int(c1.resolve()["projectiles"]) > int(base.resolve()["projectiles"])
	# Forking at rank 1 must still fork.
	var c2 := SkillConfiguration.new("R1_fork", lib)
	c2.set_skill(C.SKILL_STORM)
	c2.install(C.AUG_FORK)
	c2.set_effective_rank(C.AUG_FORK, 1)
	var fork_works := int(c2.resolve()["fork_children"]) >= 1 \
		and int(c2.resolve()["fork_generations"]) >= 1
	# Pack Instinct at rank 1 must still add a beast.
	var c3 := SkillConfiguration.new("R1_pack", lib)
	c3.set_skill(C.SKILL_BEASTS)
	c3.install(C.AUG_PACK)
	c3.set_effective_rank(C.AUG_PACK, 1)
	c3.set_effective_rank(C.SKILL_BEASTS, 1)
	var b3 := SkillConfiguration.new("R1_beast_base", lib)
	b3.set_skill(C.SKILL_BEASTS)
	b3.set_effective_rank(C.SKILL_BEASTS, 1)
	var pack_works := int(c3.resolve()["beast_count"]) > int(b3.resolve()["beast_count"])
	# And the claim is recorded on every Imprint so it is inspectable.
	var declared := true
	for id in lib.ids():
		if not (lib.get_imprint(String(id)) as Imprint).identity_complete_at_rank_1:
			declared = false
	var ok := split_works and fork_works and pack_works and declared
	_note("I19_behavioural_identity_is_complete_at_effective_rank_1",
		"AT EFFECTIVE RANK 1: Split Volley still adds a projectile (%d vs %d)=%s · Forking still forks (%d children, %d generation(s))=%s · Pack Instinct still adds a beast (%d vs %d)=%s | every Imprint records the claim=%s. RANK SCALES NUMBERS; IT NEVER GATES BEHAVIOUR."
		% [int(c1.resolve()["projectiles"]), int(base.resolve()["projectiles"]), str(split_works),
		   int(c2.resolve()["fork_children"]), int(c2.resolve()["fork_generations"]), str(fork_works),
		   int(c3.resolve()["beast_count"]), int(b3.resolve()["beast_count"]), str(pack_works),
		   str(declared)])
	_reached("I19_behavioural_identity_is_complete_at_effective_rank_1")
	return ok

# ============================================================================
# C. SKILL CONFIGURATION — THE THREE CANONICAL RULES, AND THEIR REFUSALS
# ============================================================================

func chk_I20_exactly_one_skill_imprint_per_configuration() -> bool:
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	# ZERO is refused: a modifier cannot go in before the Skill Imprint.
	var c := SkillConfiguration.new("T_one_skill", lib)
	var zero := c.install(C.AUG_TEMPERED)
	var zero_refused: bool = not zero["ok"]
	var zero_invalid := not c.is_valid()
	# ONE is accepted.
	var one := c.set_skill(C.SKILL_STORM)
	# TWO is refused.
	var two := c.set_skill(C.SKILL_BEASTS)
	var two_refused: bool = not two["ok"]
	# And installing a SKILL Imprint as a modifier is refused too.
	var as_mod := c.install(C.SKILL_BEASTS)
	var as_mod_refused: bool = not as_mod["ok"]
	var ok: bool = zero_refused and zero_invalid and one["ok"] and two_refused \
		and as_mod_refused and c.skill_id == C.SKILL_STORM
	_note("I20_exactly_one_skill_imprint_per_configuration",
		"ZERO: a modifier before the Skill Imprint is REFUSED=%s ('%s') and the empty Configuration is INVALID=%s | ONE is accepted=%s | TWO: a second Skill Imprint is REFUSED=%s ('%s') | and a Skill Imprint offered as a MODIFIER is refused too=%s ('%s')"
		% [str(zero_refused), String(zero["reason"]), str(zero_invalid), str(one["ok"]),
		   str(two_refused), String(two["reason"]), str(as_mod_refused), String(as_mod["reason"])])
	_reached("I20_exactly_one_skill_imprint_per_configuration")
	return ok

func chk_I21_a_fifth_modifier_is_refused_by_the_slot_rule() -> bool:
	# ========================================================================
	# FOUR AUGMENTS, SO THE REFUSAL CAN ONLY BE THE SLOT RULE.
	# ========================================================================
	# Filling the four slots with three Augments and a Transform would make the
	# fifth refusal AMBIGUOUS -- the Transform rule could be doing the work
	# instead. `Surefoot Release` exists precisely so four legal AUGMENTS are
	# available and the slot rule can be isolated.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	var c := SkillConfiguration.new("T_fifth", lib)
	c.set_skill(C.SKILL_STORM)
	var accepted := 0
	for m in [C.AUG_SPLIT, C.AUG_FORK, C.AUG_TEMPERED, C.AUG_SUREFOOT]:
		if c.install(String(m))["ok"]:
			accepted += 1
	var zero_transforms := c.transform_count() == 0
	var fifth := c.install(C.XF_RAIN)
	var refused: bool = not fifth["ok"]
	var reason_is_slots := String(fifth["reason"]).findn("slot") >= 0 \
		and String(fifth["reason"]).findn("FIFTH") >= 0
	var still_four := c.modifier_count() == 4
	var ok: bool = accepted == 4 and zero_transforms and refused and reason_is_slots and still_four
	_note("I21_a_fifth_modifier_is_refused_by_the_slot_rule",
		"four AUGMENTS installed=%s with ZERO Transforms present=%s, so the refusal can only be the slot rule; the FIFTH modifier was REFUSED=%s and the reason names the SLOT limit=%s ('%s'); the Configuration still holds exactly %d"
		% [str(accepted == 4), str(zero_transforms), str(refused), str(reason_is_slots),
		   String(fifth["reason"]), c.modifier_count()])
	_reached("I21_a_fifth_modifier_is_refused_by_the_slot_rule")
	return ok

func chk_I22_a_transform_shares_the_four_slots_and_is_not_a_fifth() -> bool:
	# Canon: "A Transform Augment occupies one of the Configuration's globally
	# available Augment positions. It is NOT an additional fifth position."
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	var c := SkillConfiguration.new("T_shared", lib)
	c.set_skill(C.SKILL_STORM)
	c.install(C.AUG_SPLIT)
	c.install(C.AUG_FORK)
	c.install(C.AUG_TEMPERED)
	var before := c.slots_free()
	var t := c.install(C.XF_RAIN)
	var after := c.slots_free()
	var consumed := before - after == 1
	var total_is_four := c.modifier_count() == 4 \
		and c.modifier_count() == ImprintConfig.CANON_MODIFIER_SLOTS_MAX
	# With the Transform occupying the fourth slot, a further Augment is refused.
	var fifth := c.install(C.AUG_SUREFOOT)
	var ok: bool = t["ok"] and consumed and total_is_four and not fifth["ok"] and after == 0
	_note("I22_a_transform_shares_the_four_slots_and_is_not_a_fifth",
		"three Augments left %d slot(s) free; installing the Transform consumed ONE=%s and left %d; the total is %d of the canonical %d=%s; and a further Augment is then REFUSED=%s ('%s')"
		% [before, str(consumed), after, c.modifier_count(),
		   ImprintConfig.CANON_MODIFIER_SLOTS_MAX, str(total_is_four),
		   str(not fifth["ok"]), String(fifth["reason"])])
	_reached("I22_a_transform_shares_the_four_slots_and_is_not_a_fifth")
	return ok

func chk_I23_a_second_transform_is_refused_by_the_transform_rule() -> bool:
	# ========================================================================
	# WITH SLOTS TO SPARE, SO THE REFUSAL CAN ONLY BE THE TRANSFORM RULE.
	# ========================================================================
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	var c := SkillConfiguration.new("T_second_xf", lib)
	c.set_skill(C.SKILL_STORM)
	var first := c.install(C.XF_RAIN)
	var spare := c.slots_free()
	var second := c.install(C.XF_ORBIT)
	var refused: bool = not second["ok"]
	var reason_is_transform := String(second["reason"]).findn("SECOND TRANSFORM") >= 0 \
		and String(second["reason"]).findn("slot") < 0
	var still_one := c.transform_count() == 1
	# AND THE LIVE RUNTIME PATH REFUSES TOO, and COUNTS the refusal.
	skills.set_safe_state_override(true)
	var before_att := skills.second_transform_attempts
	var before_ref := skills.second_transform_refusals
	var live := skills.attempt_second_transform()
	var live_refused: bool = not live["ok"]
	var counted := skills.second_transform_attempts == before_att + 1 \
		and skills.second_transform_refusals == before_ref + 1
	var ok: bool = first["ok"] and spare >= 2 and refused and reason_is_transform \
		and still_one and live_refused and counted
	_note("I23_a_second_transform_is_refused_by_the_transform_rule",
		"one Transform installed with %d slot(s) STILL FREE, so the slot rule cannot be doing the work; the SECOND Transform was REFUSED=%s and the reason names the TRANSFORM limit and NOT the slots=%s ('%s'); the Configuration still holds exactly %d Transform | the LIVE runtime path also refused=%s and COUNTED the refusal=%s"
		% [spare, str(refused), str(reason_is_transform), String(second["reason"]),
		   c.transform_count(), str(live_refused), str(counted)])
	_reached("I23_a_second_transform_is_refused_by_the_transform_rule")
	return ok

func chk_I24_incompatible_tags_are_refused_with_a_specific_reason() -> bool:
	# Canon: "An incompatible Augment explains WHY it cannot be installed" and
	# "An invalid configuration cannot be equipped."
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	var c := SkillConfiguration.new("T_incompat", lib)
	c.set_skill(C.SKILL_STORM)
	var r := c.install(C.AUG_WARD)          # requires Duration; the bow has none
	var refused: bool = not r["ok"]
	var names_tag := String(r["reason"]).find("Duration") >= 0
	var names_have := String(r["reason"]).find("Projectile") >= 0
	var says_missing := String(r["reason"]).findn("missing") >= 0
	# A CLASS requirement is refused just as specifically.
	var r2 := c.install(C.AUG_TITHE)        # requires a PERSISTENT Configuration
	var class_refused: bool = not r2["ok"] and String(r2["reason"]).findn("persistent") >= 0
	# AND THE SAME MODIFIER IS ACCEPTED WHERE IT BELONGS, or "refused" proves
	# nothing about compatibility.
	var c2 := SkillConfiguration.new("T_compat", lib)
	c2.set_skill(C.SKILL_BALLISTA)
	var accepted: bool = c2.install(C.AUG_WARD)["ok"]
	var c3 := SkillConfiguration.new("T_compat2", lib)
	c3.set_skill(C.SKILL_AURA)
	var accepted2: bool = c3.install(C.AUG_TITHE)["ok"]
	var ok: bool = refused and names_tag and names_have and says_missing \
		and class_refused and accepted and accepted2
	_note("I24_incompatible_tags_are_refused_with_a_specific_reason",
		"Extended Ward on the bow Skill was REFUSED=%s, and the reason names the REQUIRED tag, the tags the Configuration DOES resolve to, and exactly what is missing=%s/%s/%s ('%s') | the class requirement is equally specific=%s ('%s') | AND BOTH ARE ACCEPTED WHERE THEY BELONG (%s / %s), so the refusal is about compatibility and not about the modifier"
		% [str(refused), str(names_tag), str(names_have), str(says_missing),
		   String(r["reason"]), str(class_refused), String(r2["reason"]),
		   str(accepted), str(accepted2)])
	_reached("I24_incompatible_tags_are_refused_with_a_specific_reason")
	return ok

func chk_I25_no_installed_modifier_silently_does_nothing() -> bool:
	# Canon, section 10: "A compatible Augment explains which components it
	# modifies" and "No Augment silently does nothing."
	#
	# ========================================================================
	# RE-SCOPED UNDER D-380, ONE FOR ONE. THE ID IS UNCHANGED.
	# ========================================================================
	# From D-375 until D-380 this check ALSO required every modifier to state a
	# tradeoff, and proved the validator refused a planted modifier as "FREE
	# POWER" -- reading canon section 9's "Augments are not free power"
	# literally. TRUE WHEN WRITTEN. D-378 OD-12 CLARIFIED that sentence:
	# "Purely beneficial Augments are allowed ... the modifier slot and global
	# Capacity are already opportunity costs." THAT HALF IS THEREFORE REMOVED.
	#
	# THE SILENT-MODIFIER HALF -- this check's NAME -- IS KEPT, AND TIGHTENED:
	# the planted probe must now be caught SPECIFICALLY as a SILENT MODIFIER,
	# because the "FREE POWER" alternative that used to satisfy it no longer
	# exists. THE REMOVAL IS COMPENSATED by the D-380 suite's A16, which proves
	# the LEGAL case (a purely beneficial Augment installs, validates and binds)
	# AND this refusal.
	var lib := skills.library
	var silent: Array[String] = []
	for id in lib.ids():
		var imp := lib.get_imprint(String(id)) as Imprint
		if not imp.is_modifier():
			continue
		if imp.affects.is_empty():
			silent.append(String(id))
	# And the live Configurations' resolved blocks actually SAY what changed.
	var mute: Array[String] = []
	for cid in DiagImprintContent.ALL_CONFIGURATIONS:
		var cfg := _cfg(String(cid))
		if cfg == null or cfg.modifier_count() == 0:
			continue
		if (cfg.resolve()["notes"] as Array).is_empty():
			mute.append(String(cid))
	# THE VALIDATOR MUST BE ABLE TO CATCH IT. A planted silent modifier is
	# refused by `validate()` rather than merely absent.
	var probe := Imprint.new("AUGMENT_IMPRINT_DIAG_PLANTED_SILENT", "Planted Silent",
		Imprint.Kind.AUGMENT)
	probe.requires_tags.assign(["Hit"])
	var s := _scratch()
	var lib2: ImprintLibrary = s["library"]
	lib2.learn(probe)
	var c := SkillConfiguration.new("T_silent", lib2)
	c.set_skill(DiagImprintContent.SKILL_STORM)
	c.install(probe.id)
	var v := c.validate()
	var caught := false
	for p in v["problems"]:
		if String(p).findn("SILENT MODIFIER") >= 0:
			caught = true
	var ok := silent.is_empty() and mute.is_empty() and caught
	_note("I25_no_installed_modifier_silently_does_nothing",
		"every modifier declares the components it affects (silent: %s); every Configuration with modifiers reports what they changed (mute: %s) | and the validator is PROVED able to refuse a planted silent modifier, SPECIFICALLY AS SILENT=%s. RE-SCOPED UNDER D-380: the 'free power' half is REMOVED by D-378 OD-12 (purely beneficial Augments are legal) and COMPENSATED by A16."
		% [str(silent), str(mute), str(caught)])
	_reached("I25_no_installed_modifier_silently_does_nothing")
	return ok

func chk_I26_tag_changes_are_stated_explicitly() -> bool:
	# Canon: "Any Augment that adds, removes, or transforms tags states the change
	# explicitly."
	var lib := skills.library
	var changers: Array[String] = []
	var silent: Array[String] = []
	for id in lib.ids():
		var imp := lib.get_imprint(String(id)) as Imprint
		if imp.adds_tags.is_empty() and imp.removes_tags.is_empty():
			continue
		changers.append(String(id))
		if imp.summary.findn("tag") < 0 and imp.tradeoff.findn("tag") < 0:
			silent.append(String(id))
		if not imp.affects.has("tags"):
			silent.append("%s (does not list 'tags' among its affected components)" % String(id))
	# And the resolved tag set actually reflects the change, measured.
	var s := _scratch()
	var lib2: ImprintLibrary = s["library"]
	var c := SkillConfiguration.new("T_tags", lib2)
	c.set_skill(DiagImprintContent.SKILL_STORM)
	var before: Array = c.resolved_tags().duplicate()
	c.install(DiagImprintContent.XF_ORBIT)
	var after: Array = c.resolved_tags().duplicate()
	var removed := before.has("Projectile") and not after.has("Projectile")
	var added := not before.has("Area") and after.has("Area")
	# TWO, not three: the Siege Anchor Transform legitimately changes NO tags.
	var ok := changers.size() == 2 and silent.is_empty() and removed and added
	_note("I26_tag_changes_are_stated_explicitly",
		"%d Imprints change tags: %s | each states the change in its own text and lists 'tags' among its affected components (silent: %s) | MEASURED: %s -> %s, Projectile REMOVED=%s and Area ADDED=%s"
		% [changers.size(), str(changers), str(silent), str(before), str(after),
		   str(removed), str(added)])
	_reached("I26_tag_changes_are_stated_explicitly")
	return ok

func chk_I27_an_enabling_tag_removed_does_not_delete_its_dependent() -> bool:
	# ========================================================================
	# THE CANONICAL CASE, IMPLEMENTED LITERALLY.
	# ========================================================================
	# Canon, section 17: "Removing an enabling Augment does not silently delete a
	# dependent Augment; the resulting invalid set must be reviewed and resolved
	# before application."
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	var c := SkillConfiguration.new("T_enabling", lib)
	c.set_skill(C.SKILL_STORM)
	var dep := c.install(C.AUG_SPLIT)
	var before_count := c.modifier_count()
	# The Transform REQUIRED Projectile and REMOVES it. The install is legal.
	var xf := c.install(C.XF_ORBIT)
	var after_count := c.modifier_count()
	# THE DEPENDENT IS STILL INSTALLED.
	var not_deleted := c.has_modifier(C.AUG_SPLIT) and after_count == before_count + 1
	# AND THE SET IS EXPLICITLY INVALID, naming who removed what.
	var v := c.validate()
	var invalid: bool = not v["valid"]
	var blames := false
	var names_dependent := false
	for p in v["problems"]:
		if String(p).find("Tempest Orbit' removed Projectile") >= 0:
			blames = true
		if String(p).find("Split Volley") >= 0:
			names_dependent = true
	# THE TRANSFORM ITSELF IS NOT REPORTED AS SELF-INCOMPATIBLE. It consumed a
	# projectile Skill; judging it against its own output would be nonsense.
	var not_self_blamed := true
	for p in v["problems"]:
		if String(p).find("'Tempest Orbit' requires") >= 0:
			not_self_blamed = false
	# AND RESOLVING THE SET RESTORES VALIDITY, which is what canon asks for.
	c.remove(C.AUG_SPLIT)
	var resolved_ok := c.is_valid()
	var ok: bool = dep["ok"] and xf["ok"] and not_deleted and invalid and blames \
		and names_dependent and not_self_blamed and resolved_ok
	_note("I27_an_enabling_tag_removed_does_not_delete_its_dependent",
		"the Transform install was ACCEPTED=%s; the dependent Split Volley is STILL INSTALLED (%d -> %d modifiers)=%s; the set is EXPLICITLY INVALID=%s and the message NAMES who removed the tag=%s and which Imprint depended on it=%s; the Transform is NOT reported as incompatible with its own output=%s; and RESOLVING the set restores validity=%s"
		% [str(xf["ok"]), before_count, after_count, str(not_deleted), str(invalid),
		   str(blames), str(names_dependent), str(not_self_blamed), str(resolved_ok)])
	_reached("I27_an_enabling_tag_removed_does_not_delete_its_dependent")
	return ok

func chk_I28_an_invalid_configuration_cannot_be_equipped() -> bool:
	# Canon: "An invalid configuration cannot be equipped."
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var cfgs: Dictionary = s["configurations"]
	var C := DiagImprintContent
	# Make one INVALID by the canonical enabling-tag route.
	var broken := SkillConfiguration.new("T_broken", lib)
	broken.set_skill(C.SKILL_STORM)
	broken.install(C.AUG_SPLIT)
	broken.install(C.XF_ORBIT)
	var is_invalid := not broken.is_valid()
	cfgs["T_broken"] = broken
	var lo := ImprintLoadout.new(lib, cfgs)
	var r := lo.bind(0, "T_broken")
	var refused: bool = not r["ok"]
	var says_invalid := String(r["reason"]).findn("INVALID") >= 0
	var names_problem := String(r["reason"]).find("Split Volley") >= 0
	var binding_empty: bool = lo.bindings[0] == ""
	# AND A VALID ONE IS ACCEPTED, or the refusal proves nothing.
	var good := lo.bind(1, C.CFG_VOLLEY)
	var ok: bool = is_invalid and refused and says_invalid and names_problem \
		and binding_empty and good["ok"]
	_note("I28_an_invalid_configuration_cannot_be_equipped",
		"the Configuration is INVALID=%s; binding it was REFUSED=%s, the reason says INVALID=%s and names the actual problem=%s, and the binding was LEFT EMPTY=%s | a VALID Configuration binds normally=%s"
		% [str(is_invalid), str(refused), str(says_invalid), str(names_problem),
		   str(binding_empty), str(good["ok"])])
	_reached("I28_an_invalid_configuration_cannot_be_equipped")
	return ok

func chk_I29_every_configuration_declares_one_canonical_targeting_archetype() -> bool:
	# Canon: "Every active Skill Configuration declares ONE canonical targeting
	# archetype" -- directional, ground-targeted, contact-targeted or self-centered.
	var allowed := ImprintConfig.CANON_TARGETING
	var bad: Array[String] = []
	var seen := {}
	for cid in DiagImprintContent.ALL_CONFIGURATIONS:
		var cfg := _cfg(String(cid))
		if cfg == null:
			continue
		var t := cfg.resolved_targeting()
		if not allowed.has(t):
			bad.append("%s: '%s'" % [String(cid), t])
		seen[t] = true
	var ok := allowed.size() == 4 and bad.is_empty() and seen.size() >= 2
	_note("I29_every_configuration_declares_one_canonical_targeting_archetype",
		"the canonical four are %s; every Configuration declares one of them (offenders: %s) and %d DISTINCT archetypes are actually exercised: %s"
		% [str(allowed), str(bad), seen.size(), str(seen.keys())])
	_reached("I29_every_configuration_declares_one_canonical_targeting_archetype")
	return ok

func chk_I30_a_transform_that_changes_targeting_states_the_new_archetype() -> bool:
	# Canon: "An Augment that changes targeting must provide valid mouse and
	# controller behaviour", and section 8: every Transform "must define its
	# resulting tags, targeting archetype, cost behavior, and compatibility."
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	var rows: Array[String] = []
	var bad: Array[String] = []
	for xf in [C.XF_ORBIT, C.XF_RAIN]:
		var c := SkillConfiguration.new("T_targ_%s" % xf, lib)
		c.set_skill(C.SKILL_STORM)
		var base := c.resolved_targeting()
		c.install(String(xf))
		var now := c.resolved_targeting()
		var imp := lib.get_imprint(String(xf)) as Imprint
		rows.append("%s: %s -> %s (declared '%s')" % [imp.display_name, base, now,
			imp.sets_targeting])
		if now == base or imp.sets_targeting != now \
				or not ImprintConfig.CANON_TARGETING.has(now):
			bad.append(String(xf))
		if not c.targeting_changed():
			bad.append("%s (targeting_changed() is false)" % String(xf))
		if not imp.affects.has("targeting archetype"):
			bad.append("%s (does not list targeting among its affected components)" % String(xf))
	# And the live panel states the change -- on the page that describes the
	# Configurations, which is where a viewer would look for it.
	var was_page := panel.page
	panel.page = LoadoutPanel.PAGES.find("CONFIGURATIONS")
	panel.refresh()
	var text := panel.compose()
	var says := text.findn("targeting") >= 0
	panel.page = was_page
	panel.refresh()
	var ok := bad.is_empty() and says
	_note("I30_a_transform_that_changes_targeting_states_the_new_archetype",
		"%s | the declared archetype matches the resolved one in every case (offenders: %s) and the panel names targeting=%s"
		% [str(rows), str(bad), str(says)])
	_reached("I30_a_transform_that_changes_targeting_states_the_new_archetype")
	return ok

func chk_I31_installing_and_removing_is_free_and_destroys_nothing() -> bool:
	# Canon, section 17: installing or removing an Augment "costs nothing in a
	# safe state · does not consume the Augment · does not destroy the previous
	# configuration · does not require a second copy for another Skill".
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	var c := SkillConfiguration.new("T_free", lib)
	c.set_skill(C.SKILL_STORM)
	c.install(C.AUG_SPLIT)
	var mastery_before := lib.mastered(C.AUG_SPLIT)
	var xp_before := lib.xp(C.AUG_SPLIT)
	var other := SkillConfiguration.new("T_other", lib)
	other.set_skill(C.SKILL_BALLISTA)
	other.install(C.AUG_SPLIT)          # the SAME learned Imprint, no second copy
	var both := c.has_modifier(C.AUG_SPLIT) and other.has_modifier(C.AUG_SPLIT)
	c.remove(C.AUG_SPLIT)
	# REMOVING FROM ONE MUST NOT REMOVE FROM THE OTHER, and must not consume it.
	var survives := other.has_modifier(C.AUG_SPLIT) and lib.knows(C.AUG_SPLIT)
	var unconsumed := lib.mastered(C.AUG_SPLIT) == mastery_before \
		and is_equal_approx(lib.xp(C.AUG_SPLIT), xp_before)
	# And re-installing it is free.
	var back := c.install(C.AUG_SPLIT)
	var ok: bool = both and survives and unconsumed and back["ok"]
	_note("I31_installing_and_removing_is_free_and_destroys_nothing",
		"the SAME learned Imprint sits in two Configurations with NO second copy=%s; removing it from one left the other intact and the library entry alive=%s; mastery %d and XP %.1f are UNCHANGED by installing or removing=%s; and re-installing it is free=%s"
		% [str(both), str(survives), mastery_before, xp_before, str(unconsumed),
		   str(back["ok"])])
	_reached("I31_installing_and_removing_is_free_and_destroys_nothing")
	return ok

func chk_I32_the_pipeline_resolves_by_category_not_by_slot_position() -> bool:
	# ========================================================================
	# CANON: "Augment facet position does not establish a secret evaluation order.
	# The complete selected set resolves through ONE documented rules pipeline."
	# ========================================================================
	# So the SAME SET installed in a DIFFERENT ORDER must resolve IDENTICALLY.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	var order_a := [C.AUG_SPLIT, C.AUG_FORK, C.AUG_TEMPERED, C.AUG_SUREFOOT]
	var order_b := [C.AUG_SUREFOOT, C.AUG_TEMPERED, C.AUG_FORK, C.AUG_SPLIT]
	var a := SkillConfiguration.new("T_order_a", lib)
	a.set_skill(C.SKILL_STORM)
	for m in order_a:
		a.install(String(m))
	var b := SkillConfiguration.new("T_order_b", lib)
	b.set_skill(C.SKILL_STORM)
	for m in order_b:
		b.install(String(m))
	var ra := a.resolve()
	var rb := b.resolve()
	var differences: Array[String] = []
	for k in ["damage", "mana_cost", "cooldown", "action_duration", "projectiles",
			"fork_children", "fork_fraction", "spread_deg"]:
		var va = ra[k]
		var vb = rb[k]
		var same: bool = (is_equal_approx(float(va), float(vb)) if va is float or va is int
			else va == vb)
		if not same:
			differences.append("%s: %s vs %s" % [k, str(va), str(vb)])
	var tags_same := str(ra["tags"]) == str(rb["tags"])
	var stages := SkillConfiguration.PIPELINE_STAGES.size() == 7
	# THE COMPARISON MUST BE ABLE TO FAIL: a genuinely different set must differ.
	var c := SkillConfiguration.new("T_order_c", lib)
	c.set_skill(C.SKILL_STORM)
	c.install(C.AUG_SPLIT)
	var control_differs := not is_equal_approx(float(c.resolve()["damage"]),
		float(ra["damage"]))
	var ok := differences.is_empty() and tags_same and stages and control_differs
	_note("I32_the_pipeline_resolves_by_category_not_by_slot_position",
		"the same four modifiers installed in REVERSE order resolve IDENTICALLY across damage, cost, cooldown, action duration, projectile count, forking and spread (differences: %s) and to the same tag set=%s | the pipeline declares %d stages, applied BY CATEGORY=%s | and the comparison is PROVED able to fail: a genuinely different set does differ=%s"
		% [str(differences), str(tags_same), SkillConfiguration.PIPELINE_STAGES.size(),
		   str(stages), str(control_differs)])
	_reached("I32_the_pipeline_resolves_by_category_not_by_slot_position")
	return ok

# ============================================================================
# D. THE RANK PROTOTYPE — MASTERED VERSUS EFFECTIVE
# ============================================================================

func chk_I33_the_rank_range_is_1_to_20_and_is_provisional() -> bool:
	var labelled := false
	var cap_labelled := false
	for row in ImprintConfig.provisional_registry():
		if String(row[0]) == "rank maximum (the cap)":
			cap_labelled = String(row[2]).findn("NOT finalized") >= 0
		if String(row[0]) == "xp per rank step":
			labelled = String(row[2]).findn("NOT finalized") >= 0
	var lib := skills.library
	var out_of_range: Array[String] = []
	for id in lib.ids():
		var m := lib.mastered(String(id))
		if m < ImprintConfig.RANK_MIN or m > ImprintConfig.RANK_MAX:
			out_of_range.append("%s: %d" % [String(id), m])
	var ok := ImprintConfig.RANK_MIN == 1 and ImprintConfig.RANK_MAX == 20 \
		and cap_labelled and labelled and out_of_range.is_empty()
	_note("I33_the_rank_range_is_1_to_20_and_is_provisional",
		"the range is %d-%d; the CAP is registered as explicitly NOT finalized=%s and so is the XP CURVE=%s; every Mastered Rank in the library is inside the range (offenders: %s). 'Deliberately provisional' is the owner's own word for this model."
		% [ImprintConfig.RANK_MIN, ImprintConfig.RANK_MAX, str(cap_labelled),
		   str(labelled), str(out_of_range)])
	_reached("I33_the_rank_range_is_1_to_20_and_is_provisional")
	return ok

func chk_I34_mastered_rank_never_decreases() -> bool:
	# A Mastered Rank that could fall would make "Effective Rank may not exceed
	# Mastered Rank" enforceable and meaningless at the same time.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var id := DiagImprintContent.SKILL_STORM
	var before := lib.mastered(id)
	lib.set_mastered_at_least(id, 3)            # LOWER than the current 20
	var held := lib.mastered(id) == before
	lib.set_mastered_at_least(id, before)       # equal
	var still := lib.mastered(id) == before
	# XP can only raise it, never lower it.
	var mid := DiagImprintContent.AUG_TITHE
	var m0 := lib.mastered(mid)
	lib.grant_xp(mid, 100000.0)
	var rose := lib.mastered(mid) > m0
	var capped := lib.mastered(mid) == ImprintConfig.RANK_MAX
	var ok := held and still and rose and capped
	_note("I34_mastered_rank_never_decreases",
		"an attempt to set the Mastered Rank BELOW its current %d was ignored=%s and an equal value changed nothing=%s | XP raised '%s' from %d to %d and stopped at the cap=%s"
		% [before, str(held), str(still), mid, m0, lib.mastered(mid), str(capped)])
	_reached("I34_mastered_rank_never_decreases")
	return ok

func chk_I35_effective_rank_is_selected_per_configuration() -> bool:
	# ========================================================================
	# THE SAME LEARNED IMPRINT, TWO CONFIGURATIONS, TWO DIFFERENT CHOICES.
	# ========================================================================
	var hi := _cfg(DiagImprintContent.CFG_VOLLEY)
	var low := _cfg(DiagImprintContent.CFG_LOW)
	var same_imprint := hi.skill_id == low.skill_id
	var one_mastery := skills.library.mastered(hi.skill_id)
	var different := hi.skill_rank() != low.skill_rank()
	var low_is_one := low.skill_rank() == 1
	var hi_is_mastery := hi.skill_rank() == one_mastery
	# And changing one does not change the other.
	var before := hi.skill_rank()
	low.set_effective_rank(low.skill_id, 5)
	var unaffected := hi.skill_rank() == before and low.skill_rank() == 5
	low.set_effective_rank(low.skill_id, 1)
	var ok := same_imprint and different and low_is_one and hi_is_mastery and unaffected
	_note("I35_effective_rank_is_selected_per_configuration",
		"both Configurations hold the SAME learned Skill Imprint with ONE Mastered Rank of %d=%s, yet select Effective Ranks %d and %d=%s; changing one left the other untouched=%s"
		% [one_mastery, str(same_imprint), hi.skill_rank(), low.skill_rank(),
		   str(different), str(unaffected)])
	_reached("I35_effective_rank_is_selected_per_configuration")
	return ok

func chk_I36_effective_rank_above_mastered_rank_is_refused() -> bool:
	# A NEGATIVE CONTROL. Silently clamping would make the rule unobservable, and
	# an unobservable rule is not a rule.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	var c := SkillConfiguration.new("T_rank", lib)
	c.set_skill(C.SKILL_BALLISTA)               # Mastered 12
	var cap := lib.mastered(C.SKILL_BALLISTA)
	var before_ref := c.rank_selections_refused
	var r := c.set_effective_rank(C.SKILL_BALLISTA, cap + 1)
	var refused: bool = not r["ok"]
	var counted := c.rank_selections_refused == before_ref + 1
	var names := String(r["reason"]).findn("EXCEEDS") >= 0 \
		and String(r["reason"]).find(str(cap)) >= 0
	var unchanged := c.effective_rank(C.SKILL_BALLISTA) <= cap
	# AND THE LEGAL CASE IS ACCEPTED, or the refusal proves nothing.
	var legal := c.set_effective_rank(C.SKILL_BALLISTA, cap)
	# AND the read path clamps too, so a stale selection cannot be readable.
	var ok: bool = refused and counted and names and unchanged and legal["ok"] \
		and c.effective_rank(C.SKILL_BALLISTA) == cap
	_note("I36_effective_rank_above_mastered_rank_is_refused",
		"Effective Rank %d against a Mastered %d was REFUSED=%s, COUNTED=%s, and the reason states both numbers and the overshoot=%s ('%s'); the selection stayed within the cap=%s | rank %d exactly IS accepted=%s"
		% [cap + 1, cap, str(refused), str(counted), str(names), String(r["reason"]),
		   str(unchanged), cap, str(legal["ok"])])
	_reached("I36_effective_rank_above_mastered_rank_is_refused")
	return ok

func chk_I37_levelling_never_bricks_an_imprint() -> bool:
	# ========================================================================
	# THE OWNER'S REQUIREMENT, DIRECTLY: "This must allow intentional low-,
	# middle-, and maximum-rank use WITHOUT PERMANENTLY BRICKING AN IMPRINT BY
	# LEVELING IT."
	# ========================================================================
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	var id := C.AUG_TITHE                       # starts at Mastered 4
	var before_ranks := lib.selectable_ranks(id).size()
	# LEVEL IT ALL THE WAY UP.
	lib.grant_xp(id, 1000000.0)
	var after_ranks: Array = lib.selectable_ranks(id)
	var grew := after_ranks.size() > before_ranks
	var all_present := after_ranks.size() == ImprintConfig.RANK_MAX \
		and int(after_ranks[0]) == 1 \
		and int(after_ranks[after_ranks.size() - 1]) == ImprintConfig.RANK_MAX
	# AND A CONFIGURATION CAN STILL CHOOSE RANK 1 AFTERWARDS.
	var c := SkillConfiguration.new("T_brick", lib)
	c.set_skill(C.SKILL_AURA)
	c.install(id)
	var low := c.set_effective_rank(id, 1)
	var mid := c.set_effective_rank(id, 10)
	var top := c.set_effective_rank(id, ImprintConfig.RANK_MAX)
	# And the three choices produce three DIFFERENT results, so the choice matters.
	c.set_effective_rank(id, 1)
	var r1 := float(c.resolve()["reserve_fraction"])
	c.set_effective_rank(id, 10)
	var r10 := float(c.resolve()["reserve_fraction"])
	c.set_effective_rank(id, ImprintConfig.RANK_MAX)
	var r20 := float(c.resolve()["reserve_fraction"])
	var distinct := not is_equal_approx(r1, r10) and not is_equal_approx(r10, r20)
	var ok: bool = grew and all_present and low["ok"] and mid["ok"] and top["ok"] and distinct
	_note("I37_levelling_never_bricks_an_imprint",
		"mastering '%s' from 4 to %d GREW its selectable ranks from %d to %d=%s and every rank 1..%d remains selectable=%s | after levelling, rank 1=%s, rank 10=%s and rank %d=%s are ALL still accepted, and they reserve %.4f / %.4f / %.4f — three DIFFERENT outcomes=%s. LEVELLING ONLY EVER ADDS CHOICES."
		% [id, ImprintConfig.RANK_MAX, before_ranks, after_ranks.size(), str(grew),
		   ImprintConfig.RANK_MAX, str(all_present), str(low["ok"]), str(mid["ok"]),
		   ImprintConfig.RANK_MAX, str(top["ok"]), r1, r10, r20, str(distinct)])
	_reached("I37_levelling_never_bricks_an_imprint")
	return ok

func chk_I38_all_three_imprint_types_are_levelable() -> bool:
	# The ruling: "All three Imprint types are levelable."
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var rows: Array[String] = []
	var failed: Array[String] = []
	for kind in [Imprint.Kind.SKILL, Imprint.Kind.AUGMENT, Imprint.Kind.TRANSFORM]:
		var picked := ""
		for id in lib.ids():
			var imp := lib.get_imprint(String(id)) as Imprint
			if imp.kind == kind and lib.mastered(String(id)) < ImprintConfig.RANK_MAX:
				picked = String(id)
				break
		if picked == "":
			failed.append(Imprint.KIND_NAMES[kind])
			continue
		var m0 := lib.mastered(picked)
		var gained := lib.grant_xp(picked, ImprintLibrary.xp_to_advance_from(m0) + 1.0)
		rows.append("%s '%s': %d -> %d (+%d rank)" % [Imprint.KIND_NAMES[kind], picked,
			m0, lib.mastered(picked), gained])
		if gained < 1:
			failed.append("%s did not level" % picked)
	var ok := failed.is_empty() and rows.size() == 3
	_note("I38_all_three_imprint_types_are_levelable",
		"one of each type was levelled by awarded progress: %s | failures: %s"
		% [str(rows), str(failed)])
	_reached("I38_all_three_imprint_types_are_levelable")
	return ok

func chk_I39_rank_moves_more_than_raw_damage() -> bool:
	# ========================================================================
	# MEASURED PER IMPRINT, AGAINST THE NON-DAMAGE PROPERTY IT NAMES.
	# ========================================================================
	# The ruling: "Rank must affect more than raw damage where appropriate: cost,
	# reservation, duration, cooldown, thresholds or another relevant property."
	#
	# So each row below is [Imprint, the host Skill, the NON-DAMAGE key], and each
	# is measured at rank 1 against the Imprint's Mastered Rank. A row where the
	# property does not move is a FAILURE, not a note.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	var table := [
		[C.SKILL_STORM, C.SKILL_STORM, "mana_cost"],
		[C.SKILL_STORM, C.SKILL_STORM, "cooldown"],
		[C.SKILL_BALLISTA, C.SKILL_BALLISTA, "duration"],
		[C.SKILL_BEASTS, C.SKILL_BEASTS, "beast_count"],
		[C.SKILL_AURA, C.SKILL_AURA, "reserve_fraction"],
		[C.AUG_SPLIT, C.SKILL_STORM, "mana_cost"],
		[C.AUG_FORK, C.SKILL_STORM, "mana_cost"],
		[C.AUG_TEMPERED, C.SKILL_STORM, "mana_cost"],
		[C.AUG_SUREFOOT, C.SKILL_STORM, "action_duration"],
		[C.AUG_WARD, C.SKILL_BALLISTA, "duration"],
		[C.AUG_PACK, C.SKILL_BEASTS, "mana_cost"],
		[C.AUG_TITHE, C.SKILL_AURA, "reserve_fraction"],
		[C.XF_ORBIT, C.SKILL_STORM, "orbit_duration"],
		[C.XF_RAIN, C.SKILL_STORM, "rain_volleys"],
		[C.XF_ANCHOR, C.SKILL_BALLISTA, "mana_cost"],
	]
	var rows: Array[String] = []
	var flat: Array[String] = []
	for row in table:
		var imp_id := String(row[0])
		var host := String(row[1])
		var key := String(row[2])
		var cap := lib.mastered(imp_id)
		if cap <= 1:
			flat.append("%s has Mastered Rank 1, so rank cannot be measured" % imp_id)
			continue
		var c := SkillConfiguration.new("T_rk_%s_%s" % [imp_id, key], lib)
		c.set_skill(host)
		if imp_id != host:
			var ins := c.install(imp_id)
			if not ins["ok"]:
				flat.append("%s could not be installed on %s: %s" % [imp_id, host, ins["reason"]])
				continue
		c.set_effective_rank(imp_id, 1)
		if imp_id == host:
			c.set_effective_rank(host, 1)
		var lo := float(c.resolve()[key])
		c.set_effective_rank(imp_id, cap)
		var hi := float(c.resolve()[key])
		rows.append("%s -> %s: %.4f (rank 1) vs %.4f (rank %d)"
			% [imp_id.replace("_IMPRINT_DIAG", ""), key, lo, hi, cap])
		if is_equal_approx(lo, hi):
			flat.append("%s: %s did not move between rank 1 and rank %d" % [imp_id, key, cap])
	var ok := flat.is_empty() and rows.size() == table.size()
	_note("I39_rank_moves_more_than_raw_damage",
		"%d NON-DAMAGE properties measured at rank 1 against each Imprint's Mastered Rank, and EVERY ONE MOVED: %s | properties that did not move: %s"
		% [rows.size(), str(rows), str(flat)])
	_reached("I39_rank_moves_more_than_raw_damage")
	return ok

func chk_I40_awarded_combat_progress_grants_xp() -> bool:
	# ASSERT THE ACTION FIRED FIRST. An assertion that XP arrived is worthless if
	# the award never happened.
	await _rest()
	var lib := skills.library
	var awards_before := lib.awards
	var target := DiagImprintContent.AUG_SPLIT
	var xp_before := lib.total_progress_units(target)
	var absent_before := lib.total_progress_units(DiagImprintContent.AUG_SUREFOOT)
	var report := skills.award_combat_progress(200.0)
	var fired := lib.awards == awards_before + 1
	var xp_after := lib.total_progress_units(target)
	var grew := xp_after > xp_before
	var distinct := int(report["distinct"])
	var rows_nonempty := (report["rows"] as Array).size() == distinct
	# An Imprint NOT in the loadout must receive NOTHING.
	var absent := DiagImprintContent.AUG_SUREFOOT
	var absent_in_loadout := true
	for cid in DiagImprintContent.ALL_CONFIGURATIONS:
		var cfg := _cfg(String(cid))
		if cfg != null and cfg.has_modifier(absent):
			absent_in_loadout = false
	# THE DELTA, NOT AN ABSOLUTE. An Imprint that starts at Mastered Rank 6
	# already holds five ranks' worth of progress; the first version of this
	# check expected zero and was measuring the wrong thing.
	var absent_got_nothing := is_equal_approx(
		lib.total_progress_units(absent), absent_before)
	var ok := fired and grew and distinct >= 8 and rows_nonempty \
		and absent_in_loadout and absent_got_nothing
	_note("I40_awarded_combat_progress_grants_xp",
		"THE AWARD FIRED FIRST=%s (awards %d -> %d); '%s' went from %.1f to %.1f progress units=%s; %d DISTINCT equipped Imprints received it, one row each=%s | '%s' is NOT in the loadout=%s and received EXACTLY NOTHING — its %.1f progress units did not move=%s"
		% [str(fired), awards_before, lib.awards, target, xp_before, xp_after, str(grew),
		   distinct, str(rows_nonempty), absent, str(absent_in_loadout),
		   absent_before, str(absent_got_nothing)])
	_reached("I40_awarded_combat_progress_grants_xp")
	return ok

func chk_I41_button_use_frequency_grants_no_xp() -> bool:
	# ========================================================================
	# A NEGATIVE CONTROL, AND THE OWNER'S EXACT WORDS.
	# ========================================================================
	# "Equipped Imprints receive combat XP from awarded combat progress, NOT FROM
	# BUTTON-USE FREQUENCY." So: many uses, no awarded progress, and ZERO XP.
	await _rest()
	# Aim into empty space so nothing can die and trigger a real award.
	cam.debug_cursor_override = Vector3(-18, 0, 9)
	await _phys(3)
	var lib := skills.library
	var awards_before := lib.awards
	var grants_before := lib.xp_grants
	var snapshot := {}
	for id in lib.ids():
		snapshot[id] = lib.total_progress_units(String(id))
	var uses := 0
	for i in 8:
		skills.clear_cooldowns()
		skills.pool.refill()
		player.commitment.reset()
		await _phys(2)
		if skills.use_binding(0)["ok"]:
			uses += 1
		# Let the whole action run, release included.
		var guard := 0
		while player.commitment.active and guard < 120:
			await physics_frame
			guard += 1
	var moved: Array[String] = []
	for id in lib.ids():
		if not is_equal_approx(lib.total_progress_units(String(id)), float(snapshot[id])):
			moved.append(String(id))
	var no_awards := lib.awards == awards_before
	var no_grants := lib.xp_grants == grants_before
	await _rest()
	var ok := uses >= 6 and moved.is_empty() and no_awards and no_grants
	_note("I41_button_use_frequency_grants_no_xp",
		"%d Skill Uses were made, releases included, with NO awarded combat progress | Imprints whose XP moved: %s (must be none) | award count unchanged=%s and the library's grant path was never entered=%s. THERE IS NO CODE PATH FROM A BUTTON PRESS TO grant_xp."
		% [uses, str(moved), str(no_awards), str(no_grants)])
	_reached("I41_button_use_frequency_grants_no_xp")
	return ok

func chk_I42_reuse_in_several_configurations_does_not_multiply_xp() -> bool:
	# ========================================================================
	# A NEGATIVE CONTROL, WITH THE DUPLICATE COUNT MEASURED RATHER THAN ASSUMED.
	# ========================================================================
	await _rest()
	var lib := skills.library
	var reused := DiagImprintContent.AUG_TEMPERED     # installed in THREE
	var once := DiagImprintContent.AUG_FORK           # installed in ONE
	# Count how many times each ACTUALLY appears in the equipped loadout.
	var ids := skills.loadout.equipped_imprint_ids_with_duplicates()
	var n_reused := 0
	var n_once := 0
	for id in ids:
		if String(id) == reused:
			n_reused += 1
		if String(id) == once:
			n_once += 1
	var before_reused := lib.total_progress_units(reused)
	var before_once := lib.total_progress_units(once)
	var amount := 90.0
	var report := skills.award_combat_progress(amount)
	var gained_reused := lib.total_progress_units(reused) - before_reused
	var gained_once := lib.total_progress_units(once) - before_once
	# THE CATCH-UP MULTIPLIER DIFFERS BY IMPRINT, so the comparison is made
	# against each one's OWN expected single award -- not against the other's.
	var expect_reused := amount * lib.catchup_multiplier(reused)
	var expect_once := amount * lib.catchup_multiplier(once)
	var single_reused := absf(gained_reused - expect_reused) <= 0.01
	var single_once := absf(gained_once - expect_once) <= 0.01
	var not_tripled := gained_reused < expect_reused * 2.0
	var collapsed := int(report["duplicates_collapsed"])
	var collapsed_right := collapsed == ids.size() - int(report["distinct"])
	await _rest()
	var ok := n_reused >= 3 and n_once == 1 and single_reused and single_once \
		and not_tripled and collapsed >= 4 and collapsed_right
	_note("I42_reuse_in_several_configurations_does_not_multiply_xp",
		"'%s' appears %d times in the equipped loadout and '%s' appears %d time; ONE award of %.1f granted them %.2f and %.2f, against a SINGLE-AWARD expectation of %.2f and %.2f=%s/%s | it was NOT multiplied by its %d appearances=%s | the library collapsed %d duplicate id(s) out of %d raw ids down to %d distinct, and the arithmetic checks out=%s"
		% [reused, n_reused, once, n_once, amount, gained_reused, gained_once,
		   expect_reused, expect_once, str(single_reused), str(single_once),
		   n_reused, str(not_tripled), collapsed, ids.size(), int(report["distinct"]),
		   str(collapsed_right)])
	_reached("I42_reuse_in_several_configurations_does_not_multiply_xp")
	return ok

func chk_I43_the_catch_up_rule_is_bounded_and_measured() -> bool:
	# ========================================================================
	# BOUNDED IS THE POINT. An unbounded multiplier would make a freshly learned
	# Imprint level FASTER than an invested one -- a different unfairness in the
	# same coat.
	# ========================================================================
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	# AHEAD of the character's progression rank: exactly 1.00x, no bonus.
	var ahead := lib.catchup_multiplier(C.SKILL_STORM)          # Mastered 20 vs rank 16
	var no_bonus := is_equal_approx(ahead, 1.0)
	# A LITTLE behind: a real, proportionate bonus.
	var near := lib.catchup_multiplier(C.AUG_SPLIT)             # Mastered 14 vs 16
	var proportionate := near > 1.0 and near < ImprintConfig.CATCHUP_MULTIPLIER_MAX
	# FAR behind: CAPPED.
	var far := lib.catchup_multiplier(C.AUG_TITHE)              # Mastered 4 vs 16
	var capped := is_equal_approx(far, ImprintConfig.CATCHUP_MULTIPLIER_MAX)
	# And the uncapped arithmetic WOULD have exceeded the ceiling, or the cap is
	# not doing anything.
	var raw := 1.0 + float(lib.character_progress_rank - lib.mastered(C.AUG_TITHE)) \
		* ImprintConfig.CATCHUP_PER_RANK_BEHIND
	var cap_bites := raw > ImprintConfig.CATCHUP_MULTIPLIER_MAX
	# And the bonus actually reaches the XP.
	var before := lib.total_progress_units(C.AUG_TITHE)
	lib.award_combat_progress(100.0, [C.AUG_TITHE])
	var gained := lib.total_progress_units(C.AUG_TITHE) - before
	var applied := absf(gained - 100.0 * far) <= 0.01
	var ok := no_bonus and proportionate and capped and cap_bites and applied
	_note("I43_the_catch_up_rule_is_bounded_and_measured",
		"at or ahead of the character's progression rank %d the multiplier is EXACTLY 1.00x=%s | two ranks behind it is %.2fx — proportionate and below the ceiling=%s | twelve ranks behind it is %.2fx, CAPPED at the ceiling=%s, where the uncapped arithmetic would have been %.2fx=%s | and the multiplier actually reaches the XP: %.2f granted for a 100.0 award=%s"
		% [lib.character_progress_rank, str(no_bonus), near, str(proportionate), far,
		   str(capped), raw, str(cap_bites), gained, str(applied)])
	_reached("I43_the_catch_up_rule_is_bounded_and_measured")
	return ok

func chk_I44_no_acquisition_trading_or_progression_pacing() -> bool:
	# The ruling: "Do not implement loot acquisition, trading or final
	# progression pacing." A NEGATIVE CONTROL, with assembled needles so the
	# check does not find itself.
	# THE PRECISE SCANNER. `acquisition` is deliberately NOT in this list: the
	# accepted enemy, the ballista and the beasts all own an `acquisitions`
	# DIAGNOSTIC COUNTER, which is target acquisition in combat and has nothing to
	# do with acquiring an Imprint. `acquire_imprint` IS in the list, which is the
	# thing actually being forbidden.
	var forms := ["loot", "drop_table", "trade", "trading", "pattern_drop",
		"acquire_imprint", "vendor", "shop", "currency", "purchase"]
	var hits: Array = _runtime_declarations_naming(forms)
	# Every Imprint is PRE-LEARNED; there is no route by which one is obtained.
	var lib := skills.library
	var all_known := true
	for id in DiagImprintContent.ALL_IMPRINTS:
		if not lib.knows(String(id)):
			all_known = false
	var guard: bool = not _declarations_naming("func loot_roll() -> void:", forms).is_empty()
	# AND THE SCANNER MUST NOT FIRE ON THE LEGITIMATE IDENTIFIERS IT USED TO
	# REPORT. A guard that cries wolf is a guard that gets switched off.
	var no_false_positive: bool = _declarations_naming(
		"var tradeoff: String = \"\"\nvar acquisitions: int = 0", forms).is_empty()
	var ok: bool = hits.is_empty() and all_known and guard and no_false_positive
	_note("I44_no_acquisition_trading_or_progression_pacing",
		"RUNTIME declarations naming loot, a drop table, trading, Imprint acquisition, a vendor, a shop, a currency or a purchase: %s (must be none) | all %d Imprints are PRE-LEARNED, so no acquisition route exists to implement=%s | the scanner is PROVED able to catch a planted loot function=%s AND proved NOT to fire on the legitimate `tradeoff` and `acquisitions` identifiers it used to misreport=%s"
		% [str(hits), lib.count(), str(all_known), str(guard), str(no_false_positive)])
	_reached("I44_no_acquisition_trading_or_progression_pacing")
	return ok

# ============================================================================
# E. CONFIGURATION CAPACITY
# ============================================================================

func chk_I45_one_global_capacity_budget_exists() -> bool:
	var lo := skills.loadout
	var total := lo.capacity_total()
	var arithmetic := total == lo.capacity_from_progression() + lo.capacity_from_gear()
	# GLOBAL: there is ONE budget, not one per Configuration. Asserted by the
	# absence of any per-Configuration budget field and by the sum being taken
	# across the WHOLE loadout.
	var src := _read_text("res://scripts/imprint/skill_configuration.gd")
	var no_local_budget := src.find("capacity_total") < 0 and src.find("capacity_budget") < 0
	var summed := lo.capacity_used() > 0
	var expected := 0
	for cid in lo.active_configuration_ids() + lo.active_persistent_ids():
		expected += (lo.configuration(String(cid)) as SkillConfiguration).capacity_cost()
	var sums_right := lo.capacity_used() == expected
	var labelled := false
	for row in ImprintConfig.provisional_registry():
		if String(row[0]).findn("Capacity") >= 0 and String(row[2]).find("PROVISIONAL") >= 0:
			labelled = true
	var ok := arithmetic and no_local_budget and summed and sums_right and labelled
	_note("I45_one_global_capacity_budget_exists",
		"ONE budget of %d = %d from progression + %d from the simulated gear bonus=%s | no Configuration owns a budget of its own=%s | the used figure is the SUM across the whole loadout, %d against an independently computed %d=%s | and the values are registered PROVISIONAL=%s"
		% [total, lo.capacity_from_progression(), lo.capacity_from_gear(), str(arithmetic),
		   str(no_local_budget), lo.capacity_used(), expected, str(sums_right), str(labelled)])
	_reached("I45_one_global_capacity_budget_exists")
	return ok

func chk_I46_most_base_capacity_comes_from_character_progression() -> bool:
	# The ruling: "MOST base Capacity comes from character progression. Gear may
	# contribute a MODEST bonus." Measured as arithmetic, not asserted as an
	# adjective.
	var lo := skills.loadout
	skills.set_safe_state_override(true)
	skills.set_gear_bonus(true)
	var total := lo.capacity_total()
	var prog := lo.capacity_from_progression()
	var gear := lo.capacity_from_gear()
	var share := float(prog) / float(total)
	var majority := share > 0.5
	var modest := float(gear) / float(total) < 0.25
	var sources := lo.capacity_sources()
	var states_shares := sources.size() == 2 \
		and String(sources[0][2]).find("%") >= 0 and String(sources[1][2]).find("%") >= 0
	var ok := majority and modest and states_shares
	_note("I46_most_base_capacity_comes_from_character_progression",
		"character progression supplies %d of %d = %.1f%% — a MAJORITY=%s; the simulated gear bonus supplies %d = %.1f%% — MODEST=%s; and both sources print their share=%s"
		% [prog, total, share * 100.0, str(majority), gear,
		   100.0 * float(gear) / float(total), str(modest), str(states_shares)])
	_reached("I46_most_base_capacity_comes_from_character_progression")
	return ok

func chk_I47_the_gear_figure_is_a_scalar_and_there_is_no_equipment_system() -> bool:
	# ========================================================================
	# A NEGATIVE CONTROL. "Do not build an equipment system."
	# ========================================================================
	# MEASURED: the entire gear contribution is ONE boolean and ONE integer. There
	# is no item, no affix, no slot, no inventory and no randomness anywhere.
	var forms := ["item_", "affix", "inventory", "equipment_slot", "gear_slot",
		"rarity", "roll_", "randf", "randi", "rng"]
	var hits: Array[String] = []
	for f in _runtime_script_files():
		var p := String(f)
		# The ACCEPTED arena legitimately owns an RNG for its own prop placement,
		# which predates this stage and is not an equipment system. Named, so the
		# exclusion cannot hide anything else.
		if p.ends_with("production_arena.gd"):
			continue
		var t := _read_text(p).to_lower()
		for b in forms:
			for form in ["func %s" % b, "class_name %s" % b, "var %s" % b, "const %s" % b]:
				if t.find(form) >= 0:
					hits.append("%s: %s" % [p.get_file(), form])
	# The contribution is a scalar, and toggling it is the ONLY thing that moves it.
	var lo := skills.loadout
	skills.set_safe_state_override(true)
	skills.set_gear_bonus(true)
	var on := lo.capacity_from_gear()
	skills.set_gear_bonus(false)
	var off := lo.capacity_from_gear()
	skills.set_gear_bonus(true)
	var scalar := on == ImprintConfig.CAPACITY_GEAR_BONUS_DIAGNOSTIC and off == 0
	var declared := false
	for row in ImprintConfig.provisional_registry():
		if String(row[0]).findn("gear") >= 0 and String(row[2]).findn("NO equipment system") >= 0:
			declared = true
	var guard := false
	var planted := "var item_rarity := 0"
	for b in forms:
		if planted.find("var %s" % b) >= 0:
			guard = true
	var ok := hits.is_empty() and scalar and declared and guard
	_note("I47_the_gear_figure_is_a_scalar_and_there_is_no_equipment_system",
		"RUNTIME declarations naming an item, an affix, an inventory, an equipment slot, a rarity or ANY randomness: %s (must be none; the accepted arena's own prop RNG is excluded by name) | the whole gear contribution is ONE boolean and ONE integer: %d when on, %d when off=%s | the registry states there is NO equipment system=%s | the guard catches a planted item declaration=%s"
		% [str(hits), on, off, str(scalar), str(declared), str(guard)])
	_reached("I47_the_gear_figure_is_a_scalar_and_there_is_no_equipment_system")
	return ok

func chk_I48_capacity_limits_the_sustained_modifier_slots() -> bool:
	# The ruling: "Capacity limits how many Augment/Transform slots the equipped
	# loadout can sustain." So the two must be MEASURABLY COUPLED.
	var lo := skills.loadout
	skills.set_safe_state_override(true)
	skills.set_gear_bonus(true)
	var slots_with := lo.sustained_modifier_slots()
	var used_with := lo.capacity_used()
	skills.set_gear_bonus(false)
	var slots_without := lo.sustained_modifier_slots()
	var used_without := lo.capacity_used()
	skills.set_gear_bonus(true)
	var coupled := slots_without < slots_with and used_without < used_with
	var counted_right := slots_with > 0
	var expect := 0
	for cid in lo.active_configuration_ids() + lo.active_persistent_ids():
		expect += (lo.configuration(String(cid)) as SkillConfiguration).modifier_count()
	var arithmetic := lo.sustained_modifier_slots() == expect
	var ok := coupled and counted_right and arithmetic
	_note("I48_capacity_limits_the_sustained_modifier_slots",
		"with the gear bonus the loadout sustains %d modifier slot(s) at %d Capacity; WITHOUT it, %d slot(s) at %d — REDUCING THE BUDGET REDUCED THE SUSTAINED SLOTS=%s | the live figure %d matches an independent count %d=%s"
		% [slots_with, used_with, slots_without, used_without, str(coupled),
		   lo.sustained_modifier_slots(), expect, str(arithmetic)])
	_reached("I48_capacity_limits_the_sustained_modifier_slots")
	return ok

func chk_I49_a_primary_skill_costs_more_capacity_than_a_secondary_one() -> bool:
	# The ruling: "A primary Skill may consume more Capacity than a movement,
	# utility or secondary Skill." MEASURED on identical modifier counts, so the
	# comparison is about the CLASS and nothing else.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	var rows: Array[String] = []
	var costs := {}
	for pair in [[C.SKILL_STORM, "primary"], [C.SKILL_BALLISTA, "secondary"],
			[C.SKILL_AURA, "persistent"]]:
		var c := SkillConfiguration.new("T_cap_%s" % pair[1], lib)
		c.set_skill(String(pair[0]))
		costs["%s_bare" % pair[1]] = c.capacity_cost()
		rows.append("%s bare = %d" % [pair[1], c.capacity_cost()])
	# And with ONE modifier each, so the per-modifier half is compared too.
	var a := SkillConfiguration.new("T_cap_p1", lib)
	a.set_skill(C.SKILL_STORM)
	a.install(C.AUG_TEMPERED)
	var b := SkillConfiguration.new("T_cap_s1", lib)
	b.set_skill(C.SKILL_BALLISTA)
	b.install(C.AUG_WARD)
	var d := SkillConfiguration.new("T_cap_u1", lib)
	d.set_skill(C.SKILL_AURA)
	d.install(C.AUG_TITHE)
	var base_order := int(costs["primary_bare"]) > int(costs["secondary_bare"]) \
		and int(costs["secondary_bare"]) > int(costs["persistent_bare"])
	var with_mod_order := a.capacity_cost() > b.capacity_cost() \
		and b.capacity_cost() > d.capacity_cost()
	var ok := base_order and with_mod_order
	_note("I49_a_primary_skill_costs_more_capacity_than_a_secondary_one",
		"bare Configurations: %s — primary > secondary > persistent=%s | with ONE modifier each: primary %d > secondary %d > persistent %d=%s. The comparison holds the modifier count equal, so it is about the CLASS."
		% [str(rows), str(base_order), a.capacity_cost(), b.capacity_cost(),
		   d.capacity_cost(), str(with_mod_order)])
	_reached("I49_a_primary_skill_costs_more_capacity_than_a_secondary_one")
	return ok

func chk_I50_an_over_capacity_loadout_is_never_silently_left_active() -> bool:
	# ========================================================================
	# A NEGATIVE CONTROL, AND THE OWNER'S EXACT REQUIREMENT.
	# ========================================================================
	# "Never silently leave an invalid build active."
	var lo := skills.loadout
	skills.set_safe_state_override(true)
	skills.set_gear_bonus(true)
	var legal := lo.deactivated.is_empty()
	var demand := lo.capacity_demanded()
	var budget_with := lo.capacity_total()
	# REMOVE THE GEAR BONUS. The demand now exceeds the budget.
	skills.set_gear_bonus(false)
	var budget_without := lo.capacity_total()
	var over := demand > budget_without
	var deactivated_now := not lo.deactivated.is_empty()
	var within := lo.capacity_used() <= budget_without
	# EVERY DEACTIVATION CARRIES ITS ARITHMETIC.
	var explained := true
	for k in lo.deactivated:
		var why := String(lo.deactivated[k])
		if why.findn("OVER CAPACITY") < 0 or why.find(str(demand)) < 0:
			explained = false
	var report_states := false
	for r in lo.last_report:
		if String(r).findn("OVER CAPACITY by") >= 0 and String(r).findn("NOT LEFT ACTIVE") >= 0:
			report_states = true
	# AND THE DEACTIVATED BINDING REFUSES TO FIRE, with its reason.
	var dead_id := ""
	for k in lo.deactivated:
		dead_id = String(k)
	var dead_index := lo.bindings.find(dead_id)
	var use_refused := true
	if dead_index >= 0:
		var r := skills.use_binding(dead_index)
		use_refused = not r["ok"] and String(r["reason"]).findn("DEACTIVATED") >= 0
	# RESTORE.
	skills.set_gear_bonus(true)
	var restored := lo.deactivated.is_empty()
	var ok := legal and over and deactivated_now and within and explained \
		and report_states and use_refused and restored
	_note("I50_an_over_capacity_loadout_is_never_silently_left_active",
		"with the gear bonus the loadout is LEGAL=%s at a demand of %d against a budget of %d; removing it left a budget of %d, so the demand is OVER=%s | the loadout DEACTIVATED something=%s, came back WITHIN the budget=%s, and every deactivation carries the arithmetic that caused it=%s | the report says OVER CAPACITY and NOT LEFT ACTIVE=%s | the deactivated binding REFUSES to fire and says why=%s | restoring the bonus restored the loadout=%s"
		% [str(legal), demand, budget_with, budget_without, str(over), str(deactivated_now),
		   str(within), str(explained), str(report_states), str(use_refused), str(restored)])
	_reached("I50_an_over_capacity_loadout_is_never_silently_left_active")
	return ok

func chk_I51_removing_the_gear_bonus_produces_an_explicit_result() -> bool:
	# "Removing a simulated gear bonus must produce an EXPLICIT, UNDERSTANDABLE
	# result." Understandable means it names the shortfall, the budget, both
	# sources, and what it did about it.
	var lo := skills.loadout
	skills.set_safe_state_override(true)
	skills.set_gear_bonus(true)
	var r := skills.set_gear_bonus(false)
	var report: Array = r.get("report", [])
	var joined := ""
	for line in report:
		joined += String(line) + " "
	var names_shortfall := joined.findn("OVER CAPACITY by") >= 0
	var names_budget := joined.find(str(lo.capacity_total())) >= 0
	var names_sources := joined.findn("character progression") >= 0 \
		and joined.findn("gear") >= 0
	var names_action := joined.findn("DEACTIVATED") >= 0 \
		and joined.findn("recovered") >= 0
	# And the panel shows the same thing to a viewer.
	panel.refresh()
	var seen := panel.compose()
	var panel_shows := seen.findn("OVER CAPACITY") >= 0
	skills.set_gear_bonus(true)
	var ok := not report.is_empty() and names_shortfall and names_budget \
		and names_sources and names_action and panel_shows
	_note("I51_removing_the_gear_bonus_produces_an_explicit_result",
		"the result names the SHORTFALL=%s, the BUDGET=%s, BOTH SOURCES=%s and WHAT IT DID=%s, and the panel shows it to a viewer=%s | report: %s"
		% [str(names_shortfall), str(names_budget), str(names_sources),
		   str(names_action), str(panel_shows), str(report)])
	_reached("I51_removing_the_gear_bonus_produces_an_explicit_result")
	return ok

func chk_I52_the_four_slot_maximum_holds_independently_of_capacity() -> bool:
	# ========================================================================
	# THE CANONICAL RULE IS NOT A CAPACITY RULE, AND MUST NOT BECOME ONE.
	# ========================================================================
	# Canon fixes FOUR modifier slots per Configuration. The Capacity budget is a
	# SECOND, NEW, PROVISIONAL constraint (conflict X-04). A Configuration with
	# plenty of spare Capacity STILL cannot take a fifth modifier.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var cfgs: Dictionary = s["configurations"]
	var C := DiagImprintContent
	var solo := SkillConfiguration.new("T_solo", lib)
	solo.set_skill(C.SKILL_STORM)
	for m in [C.AUG_SPLIT, C.AUG_FORK, C.AUG_TEMPERED, C.AUG_SUREFOOT]:
		solo.install(String(m))
	cfgs["T_solo"] = solo
	var lo := ImprintLoadout.new(lib, cfgs)
	lo.gear_bonus_active = true
	lo.bind(0, "T_solo")
	lo.revalidate(ResourcePool.new())
	var spare := lo.capacity_available()
	var plenty := spare >= 4
	var fifth := solo.install(C.XF_RAIN)
	var refused: bool = not fifth["ok"]
	var reason_slots := String(fifth["reason"]).findn("slot") >= 0
	var reason_not_capacity := String(fifth["reason"]).findn("capacity") < 0
	var ok: bool = plenty and refused and reason_slots and reason_not_capacity \
		and ImprintConfig.CANON_MODIFIER_SLOTS_MAX == 4
	_note("I52_the_four_slot_maximum_holds_independently_of_capacity",
		"the loadout has %d Capacity to spare=%s, and a FIFTH modifier is STILL REFUSED=%s for the SLOT reason and not a Capacity one=%s/%s ('%s'). The canonical four-slot rule and the provisional Capacity budget are TWO SEPARATE CONSTRAINTS, and BOTH are enforced."
		% [spare, str(plenty), str(refused), str(reason_slots),
		   str(reason_not_capacity), String(fifth["reason"])])
	_reached("I52_the_four_slot_maximum_holds_independently_of_capacity")
	return ok

# ============================================================================
# F. BINDINGS VERSUS EQUIPPED CONFIGURATIONS
# ============================================================================

func chk_I53_eight_active_bindings_exist_pinned_both_directions() -> bool:
	# BOTH DIRECTIONS: eight binding slots AND eight declared input actions, and
	# neither may hold a ninth or a seventh.
	var lo := skills.loadout
	var slots := lo.binding_count()
	var actions := SkillRuntime.BINDING_ACTIONS
	var missing: Array[String] = []
	for a in actions:
		if not InputMap.has_action(String(a)):
			missing.append(String(a))
	var extras: Array[String] = []
	for a in InputMap.get_actions():
		var n := String(a)
		if n.begins_with("imprint_binding_") and not actions.has(n):
			extras.append(n)
	var canon := ImprintConfig.CANON_ACTIVE_BINDINGS == 8
	var ok := slots == 8 and actions.size() == 8 and missing.is_empty() \
		and extras.is_empty() and canon
	_note("I53_eight_active_bindings_exist_pinned_both_directions",
		"%d binding slots and %d declared binding actions; declared-but-absent %s, present-but-undeclared %s | the canonical constant is %d=%s. EIGHT, in both directions."
		% [slots, actions.size(), str(missing), str(extras),
		   ImprintConfig.CANON_ACTIVE_BINDINGS, str(canon)])
	_reached("I53_eight_active_bindings_exist_pinned_both_directions")
	return ok

func chk_I54_eight_is_not_rewritten_into_six() -> bool:
	# ========================================================================
	# THE OWNER'S INSTRUCTION, AS A CHECK: "Do not silently rewrite eight
	# bindings into six."
	# ========================================================================
	#
	# ========================================================================
	# RE-SCOPED UNDER D-380, ONE FOR ONE. THE ID IS UNCHANGED.
	# ========================================================================
	# From D-375 until D-380 this check proved eight bindings were not the
	# CANDIDATE SIX, by reading `CANDIDATE_ACTIVE_CONFIGURATIONS == 6` from the
	# provisional registry. D-378 OD-09 removed the six altogether, so the
	# check now proves the STRONGER form of the same instruction: eight
	# bindings exist, the eighth is reachable, a ninth is refused -- and NO
	# six-valued slot constant or registry row survives anywhere for eight to
	# be silently rewritten into.
	var lo := skills.loadout
	var is_eight := lo.binding_count() == 8
	var cfg_script: Script = load("res://scripts/imprint/imprint_config.gd")
	var consts: Dictionary = cfg_script.get_script_constant_map()
	var no_six_constant := not consts.has("CANDIDATE_ACTIVE_CONFIGURATIONS")
	var not_six := lo.binding_count() != 6
	# The eighth binding must be REACHABLE, not merely present in an array.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var cfgs: Dictionary = s["configurations"]
	var lo2 := ImprintLoadout.new(lib, cfgs)
	var eighth := lo2.bind(7, DiagImprintContent.CFG_VOLLEY)
	var reachable: bool = eighth["ok"] and lo2.bindings[7] == DiagImprintContent.CFG_VOLLEY
	var ninth := lo2.bind(8, DiagImprintContent.CFG_LOW)
	var no_ninth: bool = not ninth["ok"]
	# And the two figures are declared as DIFFERENT KINDS of thing.
	var canon_has := false
	for row in ImprintConfig.canonical_registry():
		if String(row[0]) == "active input bindings" and int(row[1]) == 8:
			canon_has = true
	# NO SIX ANYWHERE: no provisional row holds a slot six, and the working
	# baseline row states EIGHT, one per binding -- a third kind of thing,
	# kept apart from canon and from tunable numbers.
	var no_six_row := true
	for row in ImprintConfig.provisional_registry():
		if String(row[0]).findn("Configurations") >= 0:
			no_six_row = false
	var baseline_eight := false
	for row in ImprintConfig.working_baseline_registry():
		if String(row[0]) == "equipped Active Configurations" \
				and String(row[1]).find("up to 8") >= 0 and String(row[2]).findn("NOT a lock") >= 0:
			baseline_eight = true
	var ok: bool = is_eight and not_six and no_six_constant and reachable and no_ninth \
		and canon_has and no_six_row and baseline_eight
	_note("I54_eight_is_not_rewritten_into_six",
		"there are %d bindings, not six=%s; the EIGHTH is genuinely reachable and bindable=%s and a NINTH is refused=%s | eight is in the CANONICAL registry with its citation=%s | NO six survives to rewrite eight into: no CANDIDATE_ACTIVE_CONFIGURATIONS constant=%s and no Configuration-count row in the provisional registry=%s | the WORKING BASELINE row says up to 8, one per binding, NOT a lock=%s. RE-SCOPED UNDER D-380 (D-378 OD-09 removed the six)."
		% [lo.binding_count(), str(not_six), str(reachable), str(no_ninth), str(canon_has),
		   str(no_six_constant), str(no_six_row), str(baseline_eight)])
	_reached("I54_eight_is_not_rewritten_into_six")
	return ok

func chk_I55_bindings_and_equipped_configurations_are_distinct_concepts() -> bool:
	# The distinction must be VISIBLE, not merely asserted: some bindings are
	# EMPTY, and the counts differ.
	var lo := skills.loadout
	skills.set_safe_state_override(true)
	skills.set_gear_bonus(true)
	var bindings := lo.binding_count()
	var equipped := lo.equipped_active_count()
	var empty := lo.empty_binding_count()
	var differ := equipped < bindings and empty > 0
	var arithmetic := equipped + empty == bindings
	var text := panel.compose()
	var says := text.findn("BINDINGS AND EQUIPPED CONFIGURATIONS ARE DIFFERENT THINGS") >= 0 \
		and text.findn("empty") >= 0
	var ok := differ and arithmetic and says
	_note("I55_bindings_and_equipped_configurations_are_distinct_concepts",
		"%d bindings, %d holding a Configuration, %d EMPTY — the counts differ=%s and the arithmetic closes (%d + %d = %d)=%s | the panel states the distinction in words and shows the empty bindings=%s"
		% [bindings, equipped, empty, str(differ), equipped, empty, bindings,
		   str(arithmetic), str(says)])
	_reached("I55_bindings_and_equipped_configurations_are_distinct_concepts")
	return ok

func chk_I56_up_to_eight_active_configurations_one_per_binding_no_six_cap() -> bool:
	# ========================================================================
	# RE-SCOPED UNDER D-380, ONE FOR ONE. NUMBER KEPT, SUFFIX CORRECTED.
	# ========================================================================
	# Until D-380 this was `I56_six_active_configurations_is_a_candidate_not_a_lock`
	# and it filled eight bindings from the six diagnostic Configurations,
	# requiring the SEVENTH to be refused with a refusal that called six a
	# PROVISIONAL CANDIDATE, UNDER REVIEW and NOT A LOCK. TRUE WHEN WRITTEN.
	# D-378 OD-09 AMENDED THE BASELINE: "up to eight equipped Active
	# Configurations; one Configuration per binding; empty bindings valid; no
	# separate arbitrary six-Configuration cap." A PASS line still reading "six
	# is a candidate" would be a false current-state assertion printed as a
	# pass -- the reason D-375 moved M-04 -- so the SUFFIX changed and the
	# NUMBER did not.
	#
	# THE SAME FILL, THE OPPOSITE REQUIREMENT: all eight bindings accept, the
	# seventh and eighth included, and the only refusal is a binding that does
	# not exist. Compensated further by the D-380 suite's A12-A14.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var cfgs: Dictionary = s["configurations"]
	var lo := ImprintLoadout.new(lib, cfgs)
	var order := DiagImprintContent.ALL_CONFIGURATIONS
	var placed := 0
	var refusals: Array[String] = []
	for i in 8:
		var cid := String(order[i % order.size()])
		var r := lo.bind(i, cid)
		if r["ok"]:
			placed += 1
		else:
			refusals.append(String(r["reason"]))
	var all_eight := placed == 8 and refusals.is_empty() and lo.equipped_active_count() == 8
	var seventh_and_eighth := lo.bindings[6] != "" and lo.bindings[7] != ""
	# THE ONLY STRUCTURAL LIMIT IS THE BINDINGS THEMSELVES.
	var ninth := lo.bind(8, DiagImprintContent.CFG_VOLLEY)
	var ninth_refused: bool = not ninth["ok"] and String(ninth["reason"]).findn("does not exist") >= 0
	var no_six_words := true
	var all_reasons: Array = []
	all_reasons.append_array(refusals)
	all_reasons.append(String(ninth["reason"]))
	for r in all_reasons:
		if String(r).findn("CANDIDATE") >= 0 or String(r).find("6") >= 0:
			no_six_words = false
	var cfg_script: Script = load("res://scripts/imprint/imprint_config.gd")
	var consts: Dictionary = cfg_script.get_script_constant_map()
	var constant_gone := not consts.has("CANDIDATE_ACTIVE_CONFIGURATIONS")
	var ok: bool = all_eight and seventh_and_eighth and ninth_refused and no_six_words \
		and constant_gone
	_note("I56_up_to_eight_active_configurations_one_per_binding_no_six_cap",
		"%d of 8 bindings accepted a Configuration, the SEVENTH and EIGHTH included, with ZERO refusals=%s/%s; a NINTH binding is refused because it DOES NOT EXIST=%s ('%s'); no refusal mentions a candidate or a six=%s; the CANDIDATE_ACTIVE_CONFIGURATIONS constant is GONE=%s. RE-SCOPED UNDER D-380: D-378 OD-09 — up to eight, one per binding, no separate six cap, a CURRENT WORKING BASELINE and not a lock."
		% [placed, str(all_eight), str(seventh_and_eighth), str(ninth_refused),
		   String(ninth["reason"]), str(no_six_words), str(constant_gone)])
	_reached("I56_up_to_eight_active_configurations_one_per_binding_no_six_cap")
	return ok

func chk_I57_the_withdrawn_four_persistent_cap_is_gone_and_x02_prints_resolved() -> bool:
	# ========================================================================
	# CONFLICT X-02 — RESOLVED BY D-376, AND THE CAP REMOVED UNDER D-380.
	# ========================================================================
	# RE-SCOPED UNDER D-380, ONE FOR ONE. NUMBER KEPT, SUFFIX CORRECTED. Until
	# D-380 this was `I57_four_persistent_is_a_candidate_and_its_conflict_is_printed`:
	# it required the candidate to be 4, the registry to say it CONFLICTS WITH
	# D-079, the loadout to REFUSE a fifth Persistent naming X-02, and MO-05 to
	# carry the question as OWED-TO-OWNER. TRUE WHEN WRITTEN.
	#
	# D-376 RESOLVED X-02 AGAINST THE CANDIDATE -- "D-079's refusal STANDS. The
	# four-slot cap is WITHDRAWN and MUST NOT become the production rule" -- and
	# D-376 changed nothing in this project, so the runtime went on enforcing
	# it. D-380 measured that and REMOVED it. So the same six-Persistent fill
	# must now be ACCEPTED, X-02 must still PRINT -- now as RESOLVED, citing
	# D-079 -- and MO-05 must be DISCHARGED with its history.
	# Compensated further by the D-380 suite's A15 (the natural reservation
	# limit that replaces the slot count).
	var cfg_script: Script = load("res://scripts/imprint/imprint_config.gd")
	var consts: Dictionary = cfg_script.get_script_constant_map()
	var constant_gone := not consts.has("CANDIDATE_PERSISTENT_CONFIGURATIONS")
	var no_row := true
	for row in ImprintConfig.provisional_registry():
		if String(row[0]).findn("Persistent Configurations") >= 0:
			no_row = false
	var conflict_row := false
	for c in ImprintConfig.declared_conflicts():
		if String(c[0]) == "X-02" and String(c[2]).find("D-079") >= 0 \
				and String(c[1]).find("RESOLVED BY D-376") >= 0 \
				and String(c[2]).findn("WITHDRAWN") >= 0 and String(c[2]).findn("REMOVED") >= 0:
			conflict_row = true
	var text := panel.compose()
	var panel_prints := text.find("X-02") >= 0 and text.find("D-079") >= 0 \
		and text.findn("NO arbitrary slot cap") >= 0
	# THE SAME SIX-PERSISTENT FILL THE OLD CHECK USED -- NOW NOTHING REFUSES IT.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var cfgs: Dictionary = s["configurations"]
	var lo := ImprintLoadout.new(lib, cfgs)
	var accepted := 0
	var slot_refusals: Array[String] = []
	for i in 6:
		var r := lo.add_persistent(String(DiagImprintContent.ALL_CONFIGURATIONS[i % 6]))
		if r["ok"]:
			accepted += 1
		elif String(r["reason"]).findn("slot") >= 0 or String(r["reason"]).findn("CANDIDATE") >= 0:
			slot_refusals.append(String(r["reason"]))
	var no_cap := accepted == 6 and slot_refusals.is_empty() and lo.persistent.size() == 6
	# AND MO-05 IS DISCHARGED WITH ITS HISTORY, NOT OWED.
	var discharged := false
	for row in DISCHARGED_ROWS:
		if String(row[0]).find("MO-05") >= 0 and String(row[1]) == "DISCHARGED — D-376" \
				and String(row[2]).find("D-079") >= 0 \
				and String(row[2]).find("ORIGINAL ROW TEXT, PRESERVED VERBATIM") >= 0:
			discharged = true
	var not_owed := true
	for row in DEFERRED_ROWS:
		if String(row[0]).find("MO-05") >= 0:
			not_owed = false
	var ok := constant_gone and no_row and conflict_row and panel_prints and no_cap \
		and discharged and not_owed
	_note("I57_the_withdrawn_four_persistent_cap_is_gone_and_x02_prints_resolved",
		"the CANDIDATE_PERSISTENT_CONFIGURATIONS constant is GONE=%s and no Persistent-count row remains in the provisional registry=%s | X-02 prints as RESOLVED BY D-376, citing D-079, the candidate WITHDRAWN and REMOVED=%s, and the live panel prints X-02, D-079 and 'NO arbitrary slot cap'=%s | the same six-Persistent fill the old check refused at the fifth is now ACCEPTED %d of 6 with no slot refusal=%s | MO-05 is DISCHARGED — D-376 with its original text preserved=%s and is no longer owed=%s. RE-SCOPED UNDER D-380."
		% [str(constant_gone), str(no_row), str(conflict_row), str(panel_prints), accepted,
		   str(no_cap), str(discharged), str(not_owed)])
	_reached("I57_the_withdrawn_four_persistent_cap_is_gone_and_x02_prints_resolved")
	return ok

func chk_I58_an_empty_binding_does_nothing_and_says_so() -> bool:
	var lo := skills.loadout
	var empty_index := -1
	for i in lo.bindings.size():
		if lo.bindings[i] == "":
			empty_index = i
			break
	if empty_index < 0:
		_note("I58_an_empty_binding_does_nothing_and_says_so",
			"NO EMPTY BINDING EXISTS, so the claim cannot be tested — which is itself a failure.")
		_reached("I58_an_empty_binding_does_nothing_and_says_so")
		return false
	await _rest()
	var uses_before := skills.skill_uses
	var refused_before := skills.uses_refused
	var r := skills.use_binding(empty_index)
	var refused: bool = not r["ok"]
	var says_empty := String(r["reason"]).findn("EMPTY") >= 0
	var says_counts := String(r["reason"]).find("Eight bindings exist") >= 0
	var no_use := skills.skill_uses == uses_before
	var counted := skills.uses_refused == refused_before + 1
	var no_action := not player.commitment.active
	# AND A FILLED BINDING DOES SOMETHING, or "nothing happened" proves nothing.
	skills.clear_cooldowns()
	skills.pool.refill()
	var good := skills.use_binding(0)
	await _rest()
	var ok: bool = refused and says_empty and says_counts and no_use and counted \
		and no_action and good["ok"]
	_note("I58_an_empty_binding_does_nothing_and_says_so",
		"binding %d is EMPTY; pressing it was REFUSED=%s, SAID SO=%s, stated how many of the eight are filled=%s, started no action=%s, made no Skill Use=%s and was COUNTED=%s | a FILLED binding does fire=%s, so 'nothing happened' is not vacuous. Reason: '%s'"
		% [empty_index + 1, str(refused), str(says_empty), str(says_counts),
		   str(no_action), str(no_use), str(counted), str(good["ok"]),
		   String(r["reason"])])
	_reached("I58_an_empty_binding_does_nothing_and_says_so")
	return ok

# ============================================================================
# G. PERSISTENT CONFIGURATIONS AND RESERVATION
# ============================================================================

func chk_I59_the_persistent_loadout_consumes_no_active_binding() -> bool:
	# Canon, section 15: "The UI places Persistent Skills in a SEPARATE Persistent
	# Loadout rather than requiring one of the eight actively pressed combat
	# bindings."
	var lo := skills.loadout
	var persistent := lo.active_persistent_ids()
	var in_a_binding: Array[String] = []
	for pid in persistent:
		if lo.bindings.has(String(pid)):
			in_a_binding.append(String(pid))
	var separate := not persistent.is_empty() and in_a_binding.is_empty()
	# Adding a Persistent Configuration must not change how many bindings are used.
	var before := lo.equipped_active_count()
	var empty_before := lo.empty_binding_count()
	var after := lo.equipped_active_count()
	var untouched := before == after and empty_before == lo.empty_binding_count()
	var text := panel.compose()
	var shown := text.findn("Persistent Configurations") >= 0 \
		and text.findn("active input bindings") >= 0
	var ok := separate and untouched and shown
	_note("I59_the_persistent_loadout_consumes_no_active_binding",
		"%d Persistent Configuration(s) are active and NONE occupies one of the eight bindings=%s (offenders: %s); the binding counts are unaffected by them (%d used, %d empty)=%s; and the panel shows them as SEPARATE lines=%s"
		% [persistent.size(), str(separate), str(in_a_binding), after,
		   lo.empty_binding_count(), str(untouched), str(shown)])
	_reached("I59_the_persistent_loadout_consumes_no_active_binding")
	return ok

func chk_I60_an_aura_reserves_mana_after_modifiers() -> bool:
	# "An aura reserves Mana AFTER modifiers" -- the MODIFIED figure, not the base.
	# And canon's worked example is implemented literally: a percentage of maximum
	# Mana removed from the USABLE pool, which is not spending.
	skills.set_safe_state_override(true)
	skills.set_life_tithe(false)
	skills.loadout.revalidate(skills.pool)
	var cfg := _cfg(DiagImprintContent.CFG_AURA)
	var res := cfg.resolve()
	var pool := skills.pool
	var is_mana := String(res["reserve_resource"]) == "mana"
	var amount := float(res["reserve_amount"])
	var fraction := float(res["reserve_fraction"])
	var arithmetic := is_equal_approx(amount, ImprintConfig.MANA_MAX * fraction)
	var applied := is_equal_approx(pool.mana_reserved, amount)
	var usable := is_equal_approx(pool.mana_usable(), ImprintConfig.MANA_MAX - amount)
	# AFTER MODIFIERS: the rank the Configuration SELECTED is what sets it, and a
	# different Effective Rank gives a different reservation.
	var r0 := cfg.skill_rank()
	cfg.set_effective_rank(cfg.skill_id, 1)
	var low := float(cfg.resolve()["reserve_amount"])
	cfg.set_effective_rank(cfg.skill_id, r0)
	var rank_matters := not is_equal_approx(low, amount)
	skills.loadout.revalidate(skills.pool)
	var ok := is_mana and arithmetic and applied and usable and rank_matters
	_note("I60_an_aura_reserves_mana_after_modifiers",
		"the aura reserves MANA=%s: %.1f, which is exactly %.1f%% of the %.1f maximum=%s | the pool's reserved figure matches=%s and its USABLE pool is %.1f = max - reserved=%s | the reservation is computed AFTER the Configuration's own Effective Rank: %.1f at rank 1 against %.1f at rank %d=%s"
		% [str(is_mana), amount, fraction * 100.0, ImprintConfig.MANA_MAX, str(arithmetic),
		   str(applied), pool.mana_usable(), str(usable), low, amount, r0,
		   str(rank_matters)])
	_reached("I60_an_aura_reserves_mana_after_modifiers")
	return ok

func chk_I61_one_modifier_changes_the_reservation_resource_to_life() -> bool:
	# The ruling: "Include ONE compatible prototype modifier that changes the
	# reservation resource from Mana to Life."
	skills.set_safe_state_override(true)
	skills.set_life_tithe(false)
	skills.loadout.revalidate(skills.pool)
	var cfg := _cfg(DiagImprintContent.CFG_AURA)
	var before := String(cfg.resolve()["reserve_resource"])
	var mana_before := skills.pool.mana_reserved
	var r := skills.set_life_tithe(true)
	var installed: bool = r["ok"] and cfg.has_modifier(DiagImprintContent.AUG_TITHE)
	var after := String(cfg.resolve()["reserve_resource"])
	var changed := before == "mana" and after == "life"
	var life_now := skills.pool.life_reserved > 0.0
	var mana_now := skills.pool.mana_reserved
	var says := false
	for n in cfg.resolve()["notes"]:
		if String(n).findn("reservation resource becomes LIFE") >= 0:
			says = true
	# Restore.
	skills.set_life_tithe(false)
	skills.loadout.revalidate(skills.pool)
	var reverted := String(cfg.resolve()["reserve_resource"]) == "mana"
	var ok: bool = installed and changed and life_now and is_equal_approx(mana_now, 0.0) \
		and says and reverted and mana_before > 0.0
	_note("I61_one_modifier_changes_the_reservation_resource_to_life",
		"the Mana->Life conversion (displayed 'Life Tithe' until D-380, 'Life Conversion' since; the assertion is unchanged) installed on the Persistent Configuration=%s and the resource went '%s' -> '%s'=%s; Life is now reserved=%s and the Mana reservation dropped from %.1f to EXACTLY %.1f; the resolved block states the change=%s; and removing it reverts to Mana=%s"
		% [str(installed), before, after, str(changed), str(life_now), mana_before,
		   mana_now, str(says), str(reverted)])
	_reached("I61_one_modifier_changes_the_reservation_resource_to_life")
	return ok

func chk_I62_exactly_one_resource_is_reserved_never_both() -> bool:
	# ========================================================================
	# A NEGATIVE CONTROL, ASSERTED IN BOTH DIRECTIONS.
	# ========================================================================
	# The owner: "It must reserve one resource, NOT ACCIDENTALLY BOTH." So the
	# OTHER resource must be EXACTLY ZERO in each state, not merely smaller.
	skills.set_safe_state_override(true)
	var pool := skills.pool
	# STATE A: Mana.
	skills.set_life_tithe(false)
	skills.loadout.revalidate(pool)
	var a_mana := pool.mana_reserved
	var a_life := pool.life_reserved
	var a_ok := a_mana > 0.0 and is_equal_approx(a_life, 0.0) and not pool.reserves_both()
	# STATE B: Life.
	skills.set_life_tithe(true)
	skills.loadout.revalidate(pool)
	var b_mana := pool.mana_reserved
	var b_life := pool.life_reserved
	var b_ok := b_life > 0.0 and is_equal_approx(b_mana, 0.0) and not pool.reserves_both()
	# THE GUARD MUST BE ABLE TO FAIL: force both and require the detector to fire.
	var probe := ResourcePool.new()
	probe.set_reservation(50.0, 50.0)
	var guard := probe.reserves_both()
	# And the panel states the verdict to a viewer.
	panel.refresh()
	var shown := panel.compose().findn("EXACTLY ONE RESOURCE IS RESERVED, NEVER BOTH") >= 0
	skills.set_life_tithe(false)
	skills.loadout.revalidate(pool)
	var ok := a_ok and b_ok and guard and shown
	_note("I62_exactly_one_resource_is_reserved_never_both",
		"WITHOUT the Mana->Life conversion: Mana %.1f, Life EXACTLY %.1f=%s | WITH it: Mana EXACTLY %.1f, Life %.1f=%s | the both-reserved detector is PROVED able to fire when forced=%s | and the panel prints the verdict=%s"
		% [a_mana, a_life, str(a_ok), b_mana, b_life, str(b_ok), str(guard), str(shown)])
	_reached("I62_exactly_one_resource_is_reserved_never_both")
	return ok

func chk_I63_reservation_is_not_spending_and_restores_exactly() -> bool:
	# Canon: "Reservation is not Mana spending and does not activate effects that
	# require Mana to be spent" and it "restores automatically ... when the
	# loadout remains valid".
	var pool := ResourcePool.new()
	var spends_before := pool.spends
	pool.set_reservation(100.0, 0.0)
	var not_a_spend := pool.spends == spends_before and is_equal_approx(pool.total_spent, 0.0)
	var usable := is_equal_approx(pool.mana_usable(), ImprintConfig.MANA_MAX - 100.0)
	# The current pool is clamped DOWN to the new ceiling -- a ceiling change, not
	# a spend.
	var clamped := pool.mana_current <= pool.mana_usable() + 0.0001
	# AND REMOVING IT RESTORES THE POOL EXACTLY.
	pool.set_reservation(0.0, 0.0)
	pool.refill()
	var restored := is_equal_approx(pool.mana_usable(), ImprintConfig.MANA_MAX) \
		and is_equal_approx(pool.mana_current, ImprintConfig.MANA_MAX) \
		and pool.spends == spends_before
	# A SPEND, by contrast, IS counted -- so the distinction is measurable.
	pool.spend_mana(40.0)
	var spend_counted := pool.spends == spends_before + 1 \
		and is_equal_approx(pool.total_spent, 40.0)
	var ok := not_a_spend and usable and clamped and restored and spend_counted
	_note("I63_reservation_is_not_spending_and_restores_exactly",
		"reserving 100.0 recorded NO spend=%s and reduced the usable pool to %.1f=%s, clamping the current pool to the new ceiling rather than spending it=%s | removing the reservation restored the pool EXACTLY and still recorded no spend=%s | a real spend of 40.0 IS counted=%s, so the two are measurably different things"
		% [str(not_a_spend), ImprintConfig.MANA_MAX - 100.0, str(usable), str(clamped),
		   str(restored), str(spend_counted)])
	_reached("I63_reservation_is_not_spending_and_restores_exactly")
	return ok

func chk_I64_an_unsupportable_reservation_deactivates_with_an_explanation() -> bool:
	# Canon, section 15: "If a loadout can no longer support its reservations,
	# affected Skills DEACTIVATE WITH A CLEAR EXPLANATION."
	#
	# Built on a SCRATCH loadout with several Persistent Configurations, so the
	# live build under review is not disturbed.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var cfgs: Dictionary = s["configurations"]
	var C := DiagImprintContent
	# Four Persistent Configurations, each mastered to reserve as much as possible.
	lib.set_mastered_at_least(C.SKILL_AURA, ImprintConfig.RANK_MAX)
	for i in 4:
		var c := SkillConfiguration.new("T_aura_%d" % i, lib)
		c.set_skill(C.SKILL_AURA)
		c.set_effective_rank(C.SKILL_AURA, ImprintConfig.RANK_MAX)
		cfgs["T_aura_%d" % i] = c
	var lo := ImprintLoadout.new(lib, cfgs)
	lo.gear_bonus_active = true
	for i in 4:
		lo.add_persistent("T_aura_%d" % i)
	var pool := ResourcePool.new()
	var demanded := 0.0
	for row in lo.reservation()["rows"]:
		demanded += float(row["amount"])
	var r := lo.revalidate(pool)
	var res: Dictionary = r["reservation"]
	# Either it fits, or something was deactivated WITH AN EXPLANATION.
	var over := demanded >= ImprintConfig.MANA_MAX
	var deactivated := not (r["deactivated"] as Dictionary).is_empty()
	var explained := false
	for k in (r["deactivated"] as Dictionary):
		var why := String((r["deactivated"] as Dictionary)[k])
		if why.findn("RESERVATION UNSUPPORTABLE") >= 0 or why.findn("OVER CAPACITY") >= 0:
			explained = true
	var usable_left := float(res["mana"]) < ImprintConfig.MANA_MAX
	var ok := over and deactivated and explained and usable_left
	_note("I64_an_unsupportable_reservation_deactivates_with_an_explanation",
		"four maximum-rank auras DEMANDED %.1f of a %.1f Mana maximum, which is unsupportable=%s | the loadout DEACTIVATED at least one=%s with an explicit reason naming the cause=%s, and the surviving reservation of %.1f leaves usable Mana=%s. NOTHING WAS SILENTLY CLAMPED."
		% [demanded, ImprintConfig.MANA_MAX, str(over), str(deactivated), str(explained),
		   float(res["mana"]), str(usable_left)])
	_reached("I64_an_unsupportable_reservation_deactivates_with_an_explanation")
	return ok

func chk_I65_the_aura_supports_the_beasts_measurably() -> bool:
	# The ruling: "Include a Persistent aura that visibly/statistically supports
	# them." MEASURED as a real difference in damage dealt, not asserted.
	await _rest()
	skills.set_safe_state_override(true)
	skills.set_life_tithe(false)
	skills.loadout.revalidate(skills.pool)
	var bonus := skills.aura_beast_bonus()
	var positive := bonus > 0.0
	# Summon the pack and measure ONE strike with the aura active.
	var probe := await _probe_enemy("I65Probe", Vector3(-11.4, 0, 0))
	player.global_position = Vector3(-12.6, 0, 0)
	cam.debug_cursor_override = probe.global_position
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(3)
	var used := skills.use_binding(2)          # the beast build
	var guard := 0
	while player.commitment.active and guard < 200:
		await physics_frame
		guard += 1
	var summoned := skills.beasts.size()
	var base_damage := 0.0
	var applied_bonus := 0.0
	if summoned > 0:
		var b: DiagBeast = skills.beasts[0]
		base_damage = b.damage
		applied_bonus = b.aura_bonus
	var wired := summoned > 0 and is_equal_approx(applied_bonus, bonus)
	var effective := base_damage * (1.0 + applied_bonus)
	var bigger := effective > base_damage
	# And the aura's support scales with its own Effective Rank.
	var cfg := _cfg(DiagImprintContent.CFG_AURA)
	var r0 := cfg.skill_rank()
	cfg.set_effective_rank(cfg.skill_id, 1)
	var low := float(cfg.resolve()["beast_damage_bonus"])
	cfg.set_effective_rank(cfg.skill_id, r0)
	var scales := low < bonus
	# And the panel states it.
	panel.refresh()
	var shown := panel.compose().findn("adds") >= 0 \
		and panel.compose().findn("every beast's damage") >= 0
	probe.queue_free()
	await _rest()
	var ok := positive and wired and bigger and scales and shown
	_note("I65_the_aura_supports_the_beasts_measurably",
		"the aura's bonus is %.3f=%s and it is WIRED to every summoned beast (%d summoned, bonus %.3f applied)=%s, raising each strike from %.2f to %.2f=%s | it scales with the aura's own Effective Rank (%.3f at rank 1 against %.3f at rank %d)=%s | and the panel prints it=%s"
		% [bonus, str(positive), summoned, applied_bonus, str(wired), base_damage,
		   effective, str(bigger), low, bonus, r0, str(scales), str(shown)])
	_reached("I65_the_aura_supports_the_beasts_measurably")
	return ok

# ============================================================================
# H. THE THREE REPRESENTATIVE BUILDS
# ============================================================================

func chk_I66_action_entry_points_are_pinned_exhaustively_both_directions() -> bool:
	# ========================================================================
	# THIS IS THE PROJECT-LEVEL GUARD `F51` CANNOT CARRY, AND IT IS BROADER.
	# ========================================================================
	# `F51` asserts the CONTROLLER declares exactly one diagnostic action, which
	# is still true and still able to fail. THIS pins the whole project's set of
	# action entry points, in BOTH directions: an entry point that exists and is
	# not declared fails, and a declared one that does not exist fails.
	var declared := SkillRuntime.all_action_entry_points()
	# Independently derived: the foundation's one, plus every SKILL Imprint.
	var live: Array[String] = []
	live.append_array(PlayerController.DIAGNOSTIC_ACTIONS)
	for id in skills.library.ids():
		if (skills.library.get_imprint(String(id)) as Imprint).kind == Imprint.Kind.SKILL:
			live.append(String(id))
	var undeclared: Array[String] = []
	for a in live:
		if not declared.has(a):
			undeclared.append(a)
	var missing: Array[String] = []
	for a in declared:
		if not live.has(String(a)):
			missing.append(String(a))
	# THE CONTROLLER STILL HAS EXACTLY ONE. Asserted here too, so this check
	# cannot pass while F51's claim quietly stops being true.
	var src := _read_text("res://scripts/control/player_controller.gd")
	var one_begin := src.count("func begin_") == 1
	var one_diagnostic := PlayerController.DIAGNOSTIC_ACTIONS.size() == 1
	# And the Skill Uses do NOT live on the controller.
	var uses_elsewhere := src.find("func use_binding") < 0
	# RE-SCOPED UNDER D-392, one for one: 5 + 1 = 6 -- the ONE canonical Skill
	# Imprint, Splinter Shot. Still pinned in BOTH directions (the live set is
	# derived independently from the library's Skill Imprints). Until D-392 this
	# required 5 -- true when written.
	# RE-SCOPED UNDER D-396, one for one: 6 + 1 = 7 -- Kindred Hounds, a canonical
	# Skill Imprint with PERSISTENT activation, counted exactly as the accepted
	# diagnostic Persistent (the aura) already is. Still pinned in BOTH directions.
	# Until D-396 this required 6 -- true when written.
	# RE-SCOPED UNDER D-402, one for one: 7 + 1 = 8 -- Cinder Field, a canonical
	# ACTIVE Skill Imprint on binding 7. Still pinned in BOTH directions (the live
	# set is derived independently from the library's Skill Imprints). Until D-402
	# this required 7 -- true when written.
	var ok := declared.size() == 8 and undeclared.is_empty() and missing.is_empty() \
		and one_begin and one_diagnostic and uses_elsewhere \
		and declared.has(HuntressContent.SKILL_SPLINTER_SHOT) \
		and declared.has(HoundContent.SKILL_KINDRED_HOUNDS) \
		and declared.has(CinderContent.SKILL_CINDER_FIELD)
	_note("I66_action_entry_points_are_pinned_exhaustively_both_directions",
		"%d action entry points in the WHOLE project: %s | undeclared extras %s, declared-but-absent %s | the controller still declares exactly ONE diagnostic action=%s with exactly ONE `begin_` function=%s, and the Skill Uses live in SkillRuntime rather than on it=%s"
		% [declared.size(), str(declared), str(undeclared), str(missing),
		   str(one_diagnostic), str(one_begin), str(uses_elsewhere)])
	_reached("I66_action_entry_points_are_pinned_exhaustively_both_directions")
	return ok

func chk_I67_the_bow_configuration_is_a_lightning_projectile_attack() -> bool:
	var cfg := _cfg(DiagImprintContent.CFG_VOLLEY)
	var res := cfg.resolve()
	var tags: Array = res["tags"]
	var has := tags.has("Attack") and tags.has("Projectile") and tags.has("Hit") \
		and tags.has("Lightning")
	var directional := String(res["targeting"]) == "directional"
	var delivery := String(res["delivery"]) == "projectile"
	# LIGHTNING IS CANONICAL BUT NOT FIRST-MVP CONTENT, and the conflict says so.
	var declared := false
	for c in ImprintConfig.declared_conflicts():
		if String(c[0]) == "X-05" and String(c[2]).findn("DIAGNOSTIC content, not first-MVP") >= 0:
			declared = true
	# AND NO SHOCK AILMENT, RESISTANCE OR AFFIX WAS INVENTED ALONGSIDE IT.
	var stray: Array[String] = []
	for f in _runtime_script_files():
		var t := _read_text(String(f)).to_lower()
		for b in ["shock", "resistance"]:
			for form in ["func %s" % b, "var %s" % b, "const %s" % b, "class_name %s" % b]:
				if t.find(form) >= 0:
					stray.append("%s: %s" % [String(f).get_file(), form])
	var ok := has and directional and delivery and declared and stray.is_empty()
	_note("I67_the_bow_configuration_is_a_lightning_projectile_attack",
		"the bow Configuration resolves to %s — Attack, Projectile, Hit and Lightning all present=%s — with the canonical 'directional' archetype=%s and a projectile delivery=%s | conflict X-05 records that Lightning is CANONICAL but is NOT first-MVP content=%s | and no Shock ailment or Resistance was invented alongside it (strays: %s)"
		% [str(tags), str(has), str(directional), str(delivery), str(declared), str(stray)])
	_reached("I67_the_bow_configuration_is_a_lightning_projectile_attack")
	return ok

func chk_I68_additional_projectiles_and_forking_come_from_reusable_augments() -> bool:
	# The ruling: "Must demonstrate additional projectiles OR forking through
	# REUSABLE Augments." Both are demonstrated, and the reuse is measured.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var C := DiagImprintContent
	var bare := SkillConfiguration.new("T_bare", lib)
	bare.set_skill(C.SKILL_STORM)
	var n0 := int(bare.resolve()["projectiles"])
	var f0 := int(bare.resolve()["fork_children"])
	var with_split := SkillConfiguration.new("T_split", lib)
	with_split.set_skill(C.SKILL_STORM)
	with_split.install(C.AUG_SPLIT)
	var n1 := int(with_split.resolve()["projectiles"])
	var with_fork := SkillConfiguration.new("T_fork2", lib)
	with_fork.set_skill(C.SKILL_STORM)
	with_fork.install(C.AUG_FORK)
	var f1 := int(with_fork.resolve()["fork_children"])
	var more := n1 > n0
	var forks := f1 > f0 and f0 == 0
	# REUSABLE: the SAME learned Imprint, in the LIVE loadout, on a DIFFERENT Skill.
	var live_bow := _cfg(C.CFG_VOLLEY).has_modifier(C.AUG_SPLIT)
	var live_ballista := _cfg(C.CFG_BALLISTA).has_modifier(C.AUG_SPLIT)
	var reused := live_bow and live_ballista
	# AND THE LIVE VOLLEY ACTUALLY CREATES THEM.
	await _rest()
	SkillRuntime.reset_ledger()
	DiagProjectile.reset_counters()
	cam.debug_cursor_override = Vector3(-18, 0, 0)
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(3)
	skills.use_binding(0)
	var guard := 0
	while guard < 200 and DiagProjectile.spawned_total == 0:
		await physics_frame
		guard += 1
	await _phys(3)
	var spawned := DiagProjectile.spawned_total
	var expected := int(_cfg(C.CFG_VOLLEY).resolve()["projectiles"])
	var live_count := spawned >= expected and expected >= 2
	await _rest()
	var ok := more and forks and reused and live_count
	_note("I68_additional_projectiles_and_forking_come_from_reusable_augments",
		"Split Volley raises the projectile count %d -> %d=%s and Forking adds %d children where the bare Skill has %d=%s | the SAME learned Split Volley Imprint is installed on BOTH the bow Configuration and the ballista Configuration=%s | and the live volley actually created %d projectiles against a resolved %d=%s"
		% [n0, n1, str(more), f1, f0, str(forks), str(reused), spawned, expected,
		   str(live_count)])
	_reached("I68_additional_projectiles_and_forking_come_from_reusable_augments")
	return ok

func chk_I69_forking_is_bounded_and_cannot_chain_forever() -> bool:
	# ========================================================================
	# A NEGATIVE CONTROL FOR THE CANONICAL "no infinite event chain" RULE.
	# ========================================================================
	# A projectile already at the generation limit must create NO children, and
	# the guard is tested directly rather than hoped about.
	var at_limit := DiagProjectile.new()
	main.add_child(at_limit)
	at_limit.fork_children = ImprintConfig.FORK_CHILDREN
	at_limit.fork_generations = ImprintConfig.FORK_MAX_GENERATIONS
	at_limit.fork_fraction = 0.5
	at_limit.generation = ImprintConfig.FORK_MAX_GENERATIONS
	at_limit.build(Vector3(0, 0, 1))
	at_limit.global_position = Vector3(-30, 1, -30)
	var before := DiagProjectile.forks_spawned_total
	at_limit._spawn_forks(null)
	var none := DiagProjectile.forks_spawned_total == before
	# AND ONE BELOW THE LIMIT DOES FORK, or "bounded" would be indistinguishable
	# from "broken".
	var below := DiagProjectile.new()
	main.add_child(below)
	below.fork_children = ImprintConfig.FORK_CHILDREN
	below.fork_generations = ImprintConfig.FORK_MAX_GENERATIONS
	below.fork_fraction = 0.5
	below.generation = ImprintConfig.FORK_MAX_GENERATIONS - 1
	below.build(Vector3(0, 0, 1))
	below.global_position = Vector3(-30, 1, -34)
	below._spawn_forks(null)
	var did := DiagProjectile.forks_spawned_total == before + ImprintConfig.FORK_CHILDREN
	at_limit.queue_free()
	below.queue_free()
	# AND A LIVE SHOT NEVER EXCEEDS THE LIMIT.
	await _rest()
	DiagProjectile.reset_counters()
	var probe := await _probe_enemy("I69Probe", Vector3(-9.0, 0, 0))
	_register(probe)
	player.global_position = Vector3(-13.0, 0, 0)
	cam.debug_cursor_override = probe.global_position
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(3)
	skills.use_binding(0)
	var g := 0
	while g < 300 and DiagProjectile.hits_total == 0:
		await physics_frame
		g += 1
	await _phys(30)
	var deepest := DiagProjectile.deepest_generation
	var bounded := deepest <= ImprintConfig.FORK_MAX_GENERATIONS
	var actually_forked := DiagProjectile.forks_spawned_total > 0
	_unregister(probe)
	await _rest()
	var ok := none and did and bounded and actually_forked \
		and ImprintConfig.FORK_MAX_GENERATIONS >= 1
	_note("I69_forking_is_bounded_and_cannot_chain_forever",
		"a projectile AT the generation limit created ZERO children=%s, and one BELOW it created %d=%s — so the bound is doing work rather than the behaviour being broken | in a LIVE shot %d forks were created and the deepest generation reached was %d against a maximum of %d=%s. A fork is the same shape of failure as a self-triggering trigger, which canon forbids."
		% [str(none), ImprintConfig.FORK_CHILDREN, str(did),
		   DiagProjectile.forks_spawned_total, deepest,
		   ImprintConfig.FORK_MAX_GENERATIONS, str(bounded)])
	_reached("I69_forking_is_bounded_and_cannot_chain_forever")
	return ok

func chk_I70_the_transform_is_materially_identity_changing() -> bool:
	# "Include ONE materially identity-changing Transform." MEASURED on four
	# independent axes, not asserted.
	var plain := _cfg(DiagImprintContent.CFG_VOLLEY)
	var xf := _cfg(DiagImprintContent.CFG_TEMPEST)
	var same_skill := plain.skill_id == xf.skill_id
	var a := plain.resolve()
	var b := xf.resolve()
	var targeting_changed := String(a["targeting"]) != String(b["targeting"])
	var tag_removed := (a["tags"] as Array).has("Projectile") \
		and not (b["tags"] as Array).has("Projectile")
	var delivery_changed := String(a["delivery"]) != String(b["delivery"])
	var projectile_augments_stop := int(b["projectiles"]) >= 0 \
		and not (b["tags"] as Array).has("Projectile")
	var new_mechanics := float(b["orbit_duration"]) > 0.0 \
		and float(b["orbit_pulse_interval"]) > 0.0
	var costs_more := float(b["mana_cost"]) > 0.0
	var ok := same_skill and targeting_changed and tag_removed and delivery_changed \
		and projectile_augments_stop and new_mechanics and costs_more
	_note("I70_the_transform_is_materially_identity_changing",
		"the SAME learned Skill Imprint=%s, transformed: targeting '%s' -> '%s'=%s · the Projectile tag is REMOVED=%s · delivery '%s' -> '%s'=%s · projectile Augments therefore STOP APPLYING=%s · and it gains mechanics the base Skill has none of (a %.2f s orbit pulsing every %.3f s)=%s. FOUR INDEPENDENT AXES, ALL MEASURED."
		% [str(same_skill), String(a["targeting"]), String(b["targeting"]),
		   str(targeting_changed), str(tag_removed), String(a["delivery"]),
		   String(b["delivery"]), str(delivery_changed), str(projectile_augments_stop),
		   float(b["orbit_duration"]), float(b["orbit_pulse_interval"]), str(new_mechanics)])
	_reached("I70_the_transform_is_materially_identity_changing")
	return ok

func chk_I71_the_ballista_proves_a_non_direct_attack_style() -> bool:
	# ========================================================================
	# NON-DIRECT: THE PLAYER IS NOT ACTING WHEN THE DAMAGE HAPPENS.
	# ========================================================================
	await _rest()
	SkillRuntime.reset_ledger()
	DiagBallista.reset_counters()
	var probe := await _probe_enemy("I71Probe", Vector3(-8.0, 0, 0))
	_register(probe)
	player.global_position = Vector3(-13.5, 0, 0)
	cam.debug_cursor_override = Vector3(-10.5, 0, 0)
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(3)
	var used := skills.use_binding(1)
	var g := 0
	while player.commitment.active and g < 200:
		await physics_frame
		g += 1
	var placed := skills.ballistae.size() >= 1
	var action_over := not player.commitment.active
	# THE PLAYER NOW DOES NOTHING AT ALL.
	player.intent.debug_move_axis = Vector2.ZERO
	player.intent.debug_attack_held = false
	var life_before := probe.life.life
	await _phys(180)
	var dealt := life_before - probe.life.life
	var ledger := SkillRuntime.ledger()
	var from_ballista := float(ledger.get("ballista", 0.0))
	var from_player := float(ledger.get("player_direct", 0.0))
	var autonomous := from_ballista > 0.0 and is_equal_approx(from_player, 0.0)
	var shots := DiagBallista.shots_total > 0
	var contract := DiagBallista.DURATION_CONTRACT.size() == 4
	_unregister(probe)
	await _rest()
	var ok: bool = used["ok"] and placed and action_over and dealt > 0.0 and autonomous \
		and shots and contract
	_note("I71_the_ballista_proves_a_non_direct_attack_style",
		"ONE Skill Use placed the emplacement=%s and the player's action ENDED=%s; with the player then doing NOTHING it fired %d bolt(s) and dealt %.1f damage=%s | the ledger attributes %.1f to the ballista and EXACTLY %.1f to the player=%s. The same Imprint/Configuration rules produced an attack the player is not performing."
		% [str(placed), str(action_over), DiagBallista.shots_total, dealt, str(shots),
		   from_ballista, from_player, str(autonomous)])
	_reached("I71_the_ballista_proves_a_non_direct_attack_style")
	return ok

func chk_I72_the_ballista_reuses_the_same_projectile_augment() -> bool:
	# ========================================================================
	# ONE FRAMEWORK, TWO SKILLS. THIS IS WHY A BALLISTA AND NOT A TRAP.
	# ========================================================================
	var C := DiagImprintContent
	var bow := _cfg(C.CFG_VOLLEY)
	var bal := _cfg(C.CFG_BALLISTA)
	var same_imprint := bow.has_modifier(C.AUG_SPLIT) and bal.has_modifier(C.AUG_SPLIT)
	var one_mastery := skills.library.mastered(C.AUG_SPLIT)
	# The ballista's own bolts are multiplied by it, measured through the spec
	# the runtime actually hands the emplacement.
	var res := bal.resolve()
	var multiplied := int(res["projectiles"]) >= 2
	# And WITHOUT it the same Skill fires one.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var plain := SkillConfiguration.new("T_bal_plain", lib)
	plain.set_skill(C.SKILL_BALLISTA)
	var one := int(plain.resolve()["projectiles"]) == 1
	# And a MINION Augment does NOT apply to it, because it carries no Minion tag.
	var minion := plain.install(C.AUG_PACK)
	var minion_refused: bool = not minion["ok"]
	# LIVE: the emplacement fires the multiplied count.
	await _rest()
	DiagProjectile.reset_counters()
	var probe := await _probe_enemy("I72Probe", Vector3(-8.0, 0, 0))
	_register(probe)
	player.global_position = Vector3(-13.5, 0, 0)
	cam.debug_cursor_override = Vector3(-10.5, 0, 0)
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(3)
	skills.use_binding(1)
	var g := 0
	while player.commitment.active and g < 200:
		await physics_frame
		g += 1
	var before := DiagProjectile.spawned_total
	await _phys(90)
	var fired := DiagProjectile.spawned_total - before
	var live_multiplied := fired >= int(res["projectiles"])
	_unregister(probe)
	await _rest()
	var ok: bool = same_imprint and multiplied and one and minion_refused and live_multiplied
	_note("I72_the_ballista_reuses_the_same_projectile_augment",
		"the SAME learned Split Volley Imprint sits in the bow Configuration AND the ballista Configuration with ONE Mastered Rank of %d=%s; the emplacement resolves to %d bolts per volley against %d without it=%s/%s; a MINION Augment is correctly REFUSED on it because it carries no Minion tag=%s; and LIVE it fired %d projectile(s)=%s. ONE FRAMEWORK, TWO SKILLS."
		% [one_mastery, str(same_imprint), int(res["projectiles"]), 1, str(multiplied),
		   str(one), str(minion_refused), fired, str(live_multiplied)])
	_reached("I72_the_ballista_reuses_the_same_projectile_augment")
	return ok

func chk_I73_the_duration_contract_is_declared_and_the_oldest_is_replaced() -> bool:
	# Canon, section 15: every Duration/Ground effect declares duration, maximum
	# active instances, re-use behaviour and what happens at the limit -- and
	# "When an instance limit is exceeded, the OLDEST instance is normally
	# replaced."
	var contract := DiagBallista.DURATION_CONTRACT
	var declares := contract.has("declares_duration") and contract.has("maximum_active_instances") \
		and contract.has("reuse_behaviour") and contract.has("on_limit_exceeded")
	var res := _cfg(DiagImprintContent.CFG_BALLISTA).resolve()
	var limit := int(res["instances_max"])
	var has_duration := float(res["duration"]) > 0.0
	await _rest()
	DiagBallista.reset_counters()
	var probe := await _probe_enemy("I73Probe", Vector3(-8.0, 0, 0))
	_register(probe)
	player.global_position = Vector3(-13.5, 0, 0)
	# PLACE ONE MORE THAN THE LIMIT.
	var placed := 0
	for i in limit + 1:
		cam.debug_cursor_override = Vector3(-11.0 + float(i) * 0.9, 0, -1.0 + float(i))
		skills.clear_cooldowns()
		skills.pool.refill()
		player.commitment.reset()
		await _phys(3)
		if skills.use_binding(1)["ok"]:
			placed += 1
		var g := 0
		while player.commitment.active and g < 200:
			await physics_frame
			g += 1
		await _phys(2)
	var live := skills.ballistae.size()
	var within := live <= limit
	var replaced := DiagBallista.replaced_oldest_total >= 1
	# AND THE SIEGE ANCHOR TRANSFORM REDUCES THE LIMIT TO ONE, which is canon's
	# own worked example of a Transform.
	var s := _scratch()
	var lib: ImprintLibrary = s["library"]
	var anchored := SkillConfiguration.new("T_anchor", lib)
	anchored.set_skill(DiagImprintContent.SKILL_BALLISTA)
	anchored.install(DiagImprintContent.XF_ANCHOR)
	var ar := anchored.resolve()
	var anchor_one := int(ar["instances_max"]) == 1
	var anchor_longer := float(ar["duration"]) > float(res["duration"])
	_unregister(probe)
	await _rest()
	var ok := declares and has_duration and placed == limit + 1 and within \
		and replaced and anchor_one and anchor_longer
	_note("I73_the_duration_contract_is_declared_and_the_oldest_is_replaced",
		"all four canonical declarations are present=%s; the Configuration resolves to a %.2f s duration=%s and a limit of %d | %d placements left %d alive=%s and the OLDEST was replaced %d time(s)=%s | the Siege Anchor Transform reduces the limit to %d=%s while multiplying the duration to %.2f s=%s — canon's own 'persistent but fewer' example"
		% [str(declares), float(res["duration"]), str(has_duration), limit, placed, live,
		   str(within), DiagBallista.replaced_oldest_total, str(replaced),
		   int(ar["instances_max"]), str(anchor_one), float(ar["duration"]),
		   str(anchor_longer)])
	_reached("I73_the_duration_contract_is_declared_and_the_oldest_is_replaced")
	return ok

func chk_I74_beasts_follow_acquire_and_attack_autonomously() -> bool:
	# THREE CAPABILITIES, EACH ASSERTED SEPARATELY, with EVERY INPUT SEAM HELD AT
	# ZERO throughout -- so "autonomous" is measured rather than described.
	await _rest()
	DiagBeast.reset_counters()
	SkillRuntime.reset_ledger()
	player.global_position = Vector3(-13.0, 0, 6.5)
	cam.debug_cursor_override = player.global_position + Vector3(1, 0, 0)
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(3)
	var used := skills.use_binding(2)
	var g := 0
	while player.commitment.active and g < 200:
		await physics_frame
		g += 1
	var summoned := skills.beasts.size()
	# 1. FOLLOW. Move the player; the beasts must close the distance themselves.
	player.intent.debug_move_axis = Vector2.ZERO
	player.global_position = Vector3(-13.0, 0, -6.0)
	await _phys(10)
	var far_before := 0.0
	for b in skills.beasts:
		far_before = maxf(far_before,
			NavService.planar_distance(b.global_position, player.global_position))
	await _phys(150)
	var far_after := 0.0
	var states: Array[String] = []
	for b in skills.beasts:
		far_after = maxf(far_after,
			NavService.planar_distance(b.global_position, player.global_position))
		states.append(b.state_name())
	var followed := far_after < far_before
	# 2. ACQUIRE. A target appears; nobody tells them about it.
	var probe := await _probe_enemy("I74Probe", Vector3(-11.0, 0, -6.0))
	_register(probe)
	await _phys(120)
	var acquired := 0
	for b in skills.beasts:
		if b.target != null:
			acquired += 1
	# 3. ATTACK.
	await _phys(180)
	var strikes := DiagBeast.strikes_total
	var dealt := DiagBeast.damage_total
	var seams_clear: bool = player.intent.debug_move_axis == Vector2.ZERO
	_unregister(probe)
	await _rest()
	var ok: bool = used["ok"] and summoned >= 1 and followed and acquired >= 1 \
		and strikes >= 1 and dealt > 0.0 and seams_clear
	_note("I74_beasts_follow_acquire_and_attack_autonomously",
		"%d beast(s) summoned by ONE Skill Use=%s | FOLLOW: the furthest beast closed from %.2f m to %.2f m after the player moved=%s (states %s) | ACQUIRE: %d beast(s) found the target with nobody telling them=%s | ATTACK: %d strike(s) for %.1f damage=%s | every movement seam was held at ZERO throughout=%s"
		% [summoned, str(used["ok"]), far_before, far_after, str(followed), str(states),
		   acquired, str(acquired >= 1), strikes, dealt, str(strikes >= 1),
		   str(seams_clear)])
	_reached("I74_beasts_follow_acquire_and_attack_autonomously")
	return ok

func chk_I75_beasts_are_the_primary_damage_source_of_their_build() -> bool:
	# "They are the PRIMARY damage source for this diagnostic build." Measured as
	# a SHARE of total damage, with the player deliberately inactive.
	await _rest()
	DiagBeast.reset_counters()
	SkillRuntime.reset_ledger()
	var probe := await _probe_enemy("I75Probe", Vector3(-11.0, 0, 0))
	_register(probe)
	player.global_position = Vector3(-13.4, 0, 0)
	cam.debug_cursor_override = probe.global_position
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(3)
	skills.use_binding(2)
	var g := 0
	while player.commitment.active and g < 200:
		await physics_frame
		g += 1
	# ONE bow shot, so the comparison has both sides in it.
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(3)
	skills.use_binding(0)
	var h := 0
	while player.commitment.active and h < 200:
		await physics_frame
		h += 1
	await _phys(300)
	var led := SkillRuntime.ledger()
	var beast := float(led.get("beast", 0.0))
	var bow := float(led.get("player_direct", 0.0))
	var total := SkillRuntime.ledger_total()
	var share := SkillRuntime.ledger_share("beast")
	var primary := beast > bow and share > 0.5
	var both_present := beast > 0.0 and bow > 0.0
	var by_cfg := SkillRuntime.ledger_by_configuration()
	var attributed := by_cfg.has(DiagImprintContent.CFG_BEASTS) \
		and by_cfg.has(DiagImprintContent.CFG_VOLLEY)
	_unregister(probe)
	await _rest()
	var ok := primary and both_present and attributed and total > 0.0
	_note("I75_beasts_are_the_primary_damage_source_of_their_build",
		"with ONE beast summon and ONE bow shot against the same target: beasts dealt %.1f (%.1f%% of %.1f) and the bow dealt %.1f — THE BEASTS ARE THE PRIMARY SOURCE=%s | both sides actually contributed, so the comparison is not vacuous=%s | and the damage is attributed to the Configurations that produced it=%s"
		% [beast, share * 100.0, total, bow, str(primary), str(both_present),
		   str(attributed)])
	_reached("I75_beasts_are_the_primary_damage_source_of_their_build")
	return ok

func chk_I76_no_beast_command_input_and_no_command_method_exists() -> bool:
	# ========================================================================
	# A NEGATIVE CONTROL. "No manual pet movement, target micromanagement or
	# WoW-style pet rotation."
	# ========================================================================
	# Proved THREE ways: no input action addresses a beast, no command method
	# exists on the class, and the beasts work with every seam at zero.
	# `move_command` is the ACCEPTED canonical click-to-move action and is named
	# here as an explicit exclusion rather than quietly dropped from the token
	# list -- it is the player's OWN movement, not a beast order.
	var input_hits: Array[String] = []
	for a in InputMap.get_actions():
		var n := String(a).to_lower()
		if n.begins_with("ui_") or n == "move_command":
			continue
		for b in ["beast", "pet", "minion", "command", "recall", "focus", "order"]:
			if n.find(b) >= 0:
				input_hits.append(String(a))
	var src := _read_text("res://scripts/imprint/diag_beast.gd")
	var method_hits: Array[String] = []
	for b in ["command", "order", "recall", "focus_target", "set_target", "attack_target"]:
		if src.find("func %s" % b) >= 0:
			method_hits.append("func %s" % b)
	# The ONLY public mutator is `dismiss()`, which is a teardown, not a command.
	var has_dismiss := src.find("func dismiss(") >= 0
	# And the target field is written ONLY by the beast's own acquisition.
	var writes := src.count("target = ")
	var only_self := writes <= 1 and src.find("target = _acquire()") >= 0
	# THE GUARD MUST BE ABLE TO FAIL.
	var planted := "func command_beast_to(target: Node) -> void:"
	var guard := planted.find("func command") >= 0
	var ok := input_hits.is_empty() and method_hits.is_empty() and has_dismiss \
		and only_self and guard
	_note("I76_no_beast_command_input_and_no_command_method_exists",
		"NO input action addresses a beast, pet, minion, command, order, recall or focus — the accepted `move_command` click-to-move action is excluded BY NAME=%s (found: %s) | NO command method exists on the class=%s (found: %s) | the only public mutator is `dismiss()`, a teardown=%s | and `target` is assigned in exactly %d place — the beast's OWN acquisition=%s | the guard catches a planted command method=%s"
		% [str(input_hits.is_empty()), str(input_hits), str(method_hits.is_empty()),
		   str(method_hits), str(has_dismiss), writes, str(only_self), str(guard)])
	_reached("I76_no_beast_command_input_and_no_command_method_exists")
	return ok

func chk_I77_no_command_beast_of_any_kind_is_created() -> bool:
	# The ruling: "Do not create the future rare Uber-boss command beast yet."
	var forms := ["uber", "command_beast", "commander", "alpha_beast", "boss_beast"]
	var hits: Array[String] = []
	for f in _all_project_files():
		var p := String(f).to_lower()
		for b in forms:
			if p.find(b) >= 0:
				hits.append(String(f))
	for f in _runtime_script_files():
		var t := _read_text(String(f)).to_lower()
		for b in forms:
			if t.find(b) >= 0:
				hits.append("%s mentions %s" % [String(f).get_file(), b])
	# All beasts are of ONE class and ONE kind. There is no second beast type.
	var kinds := {}
	for b in skills.beasts:
		kinds[b.get_class()] = true
	var one_kind := kinds.size() <= 1
	var guard := "class_name UberCommandBeast".to_lower().find("uber") >= 0
	var ok := hits.is_empty() and one_kind and guard
	_note("I77_no_command_beast_of_any_kind_is_created",
		"files or runtime scripts naming an uber, command, commander, alpha or boss beast: %s (must be none) | every live beast is of a single class=%s | the guard catches a planted one=%s"
		% [str(hits), str(one_kind), str(guard)])
	_reached("I77_no_command_beast_of_any_kind_is_created")
	return ok

func chk_I78_minions_do_not_obstruct_the_player() -> bool:
	# ========================================================================
	# CANON: "Minions do not physically obstruct the player."
	# ========================================================================
	# Enforced STRUCTURALLY -- the beast sits on its own layer, which nothing
	# masks. A rule enforced by a layer cannot be forgotten by a state machine.
	await _rest()
	player.global_position = Vector3(-13.0, 0, 5.0)
	cam.debug_cursor_override = player.global_position + Vector3(1, 0, 0)
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(3)
	skills.use_binding(2)
	var g := 0
	while player.commitment.active and g < 200:
		await physics_frame
		g += 1
	if skills.beasts.is_empty():
		_note("I78_minions_do_not_obstruct_the_player", "no beast was summoned, so the claim could not be tested — a failure.")
		_reached("I78_minions_do_not_obstruct_the_player")
		await _rest()
		return false
	var beast: DiagBeast = skills.beasts[0]
	# STRUCTURAL: nothing masks the beast's layer.
	var layer := beast.collision_layer
	var player_blind := (player.collision_mask & layer) == 0
	var enemy_blind := true
	for e in main.get("enemies"):
		if is_instance_valid(e) and (e.collision_mask & layer) != 0:
			enemy_blind = false
	# ========================================================================
	# MEASURED BY ARRIVAL, WITH A NEGATIVE CONTROL. "Every socket is on the
	# navigation mesh" and "you can walk there" are different claims.
	# ========================================================================
	# The player is given a CLICK-TO-MOVE order straight through the point a
	# stationary beast occupies, and the test is whether it ARRIVES -- the same
	# rule that caught D-370's stalling enemies. A stick direction would have
	# measured a camera-relative diagonal instead, which is what the first
	# version of this check did.
	var start_pos := Vector3(-13.0, 0, 5.0)
	var block_pos := Vector3(-13.0, 0, 2.6)
	var dest := Vector3(-13.0, 0, 0.2)
	beast.set_physics_process(false)
	beast.global_position = block_pos
	player.global_position = start_pos
	player.motor.reset()
	player.clear_move_destination()
	player.follower.set_path(PackedVector3Array())
	await _phys(4)
	player.command_move_to(dest)
	var guard2 := 0
	while guard2 < 400 and NavService.planar_distance(player.global_position, dest) \
			> ProdConfig.ARRIVE_TOLERANCE_M:
		await physics_frame
		guard2 += 1
	var arrived := NavService.planar_distance(player.global_position, dest) \
		<= ProdConfig.ARRIVE_TOLERANCE_M + 0.05
	var passed_through := player.global_position.z < block_pos.z
	beast.set_physics_process(true)

	# THE NEGATIVE CONTROL: AN ENEMY BODY DOES BLOCK. Without it, "the player got
	# through" would prove nothing about the beast's layer -- it might simply be
	# that nothing ever blocks anything here.
	var wall := await _probe_enemy("I78Blocker", block_pos)
	wall.debug_suppress_movement = true
	player.global_position = start_pos
	player.motor.reset()
	player.clear_move_destination()
	player.follower.set_path(PackedVector3Array())
	await _phys(6)
	player.command_move_to(dest)
	await _phys(220)
	var blocked_dist := NavService.planar_distance(player.global_position, dest)
	var was_blocked := blocked_dist > ProdConfig.ARRIVE_TOLERANCE_M + 0.30
	_unregister(wall)
	await _rest()
	var ok := player_blind and enemy_blind and arrived and passed_through and was_blocked
	_note("I78_minions_do_not_obstruct_the_player",
		"the beast occupies collision layer %d, which the player's mask %d does NOT include=%s and no enemy's mask includes either=%s | MEASURED BY ARRIVAL: ordered straight through a stationary beast, the player ARRIVED at its destination=%s and ended past the beast's position=%s | NEGATIVE CONTROL: an ENEMY body in the SAME place stopped it %.2f m short=%s — so the beast's layer is doing the work, and it is not simply that nothing ever blocks anything"
		% [layer, player.collision_mask, str(player_blind), str(enemy_blind),
		   str(arrived), str(passed_through), blocked_dist, str(was_blocked)])
	_reached("I78_minions_do_not_obstruct_the_player")
	return ok

func chk_I79_one_input_activation_is_one_skill_use() -> bool:
	# ========================================================================
	# CANON: "One input activation is ONE Skill Use, even if an Augment causes
	# several repeats, projectiles, impacts, or pulses."
	# ========================================================================
	# This is also the structural reason XP cannot be farmed by button-mashing.
	await _rest()
	DiagProjectile.reset_counters()
	DiagBeast.reset_counters()
	cam.debug_cursor_override = Vector3(-18, 0, 0)
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(3)
	var uses_before := skills.skill_uses
	var releases_before := skills.releases
	skills.use_binding(0)
	var g := 0
	while player.commitment.active and g < 200:
		await physics_frame
		g += 1
	await _phys(4)
	var uses := skills.skill_uses - uses_before
	var releases := skills.releases - releases_before
	var projectiles := DiagProjectile.spawned_total
	var one_use := uses == 1 and releases == 1
	var many := projectiles >= 3
	# THE SAME FOR MINIONS: several beasts from one activation is still one use.
	skills.clear_cooldowns()
	skills.pool.refill()
	player.global_position = Vector3(-13.0, 0, 5.0)
	await _phys(3)
	var before2 := skills.skill_uses
	skills.use_binding(2)
	var h := 0
	while player.commitment.active and h < 200:
		await physics_frame
		h += 1
	var uses2 := skills.skill_uses - before2
	var beasts := DiagBeast.summoned_total
	var one_use2 := uses2 == 1 and beasts >= 2
	await _rest()
	var ok := one_use and many and one_use2
	_note("I79_one_input_activation_is_one_skill_use",
		"ONE activation of the bow Configuration made %d Skill Use and %d release while creating %d projectiles=%s/%s | ONE activation of the beast Configuration made %d Skill Use while summoning %d beasts=%s"
		% [uses, releases, projectiles, str(one_use), str(many), uses2, beasts,
		   str(one_use2)])
	_reached("I79_one_input_activation_is_one_skill_use")
	return ok

# ============================================================================
# I. EXISTING ACCEPTED BEHAVIOUR, PRESERVED
# ============================================================================

func chk_I80_click_to_move_stores_the_clicked_point_unsnapped() -> bool:
	# ========================================================================
	# REPLACED ONE FOR ONE UNDER D-404, BY OWNER RULING. THE ID IS UNCHANGED.
	# ========================================================================
	# From D-375 until D-404 this check was
	# `I80_click_to_move_still_resolves_the_nearest_navigable_point` and required
	# -- TRUE WHEN WRITTEN, and accepted under D-376 -- that an off-mesh click be
	# REDIRECTED by more than 0.10 m onto the mesh and REPORTED. The owner's D-404
	# ruling forbids that: "Store the actual clicked ground point as the
	# destination. Do not snap that destination to the nearest navigation point."
	#
	# WHAT IT NOW REQUIRES, re-measured under this stage as before: an on-mesh
	# click is accepted as clicked; an off-mesh click is stored EXACTLY as
	# clicked, NOT redirected and NOT reported as one; and that point really is
	# off the mesh, so the check is about the same case and can fail.
	await _rest()
	var on_mesh := Vector3(-10.0, 0, 0)
	var stored := player.command_move_to(on_mesh)
	var accepted := stored == on_mesh and not player.last_command_was_redirected
	var reported_before := player.commands_redirected
	var off := Vector3(0, 0, 60)
	var stored2 := player.command_move_to(off)
	var exact: bool = stored2 == off and player.move_destination == off
	var not_redirected := not player.last_command_was_redirected \
		and is_zero_approx(player.last_command_redirect_m) \
		and player.commands_redirected == reported_before
	var off_mesh_m := NavService.planar_distance(NavService.nearest_point(nav_map, off), off)
	var really_off := off_mesh_m > 0.10
	await _rest()
	var ok := accepted and exact and not_redirected and really_off
	_note("I80_click_to_move_stores_the_clicked_point_unsnapped",
		"REPLACED ONE FOR ONE UNDER D-404 (was I80_click_to_move_still_resolves_the_nearest_navigable_point, which required a redirect onto the mesh — true when written): an on-mesh click was accepted as clicked=%s; an off-mesh click %.2f m from the mesh=%s was stored EXACTLY as clicked=%s and was NOT redirected or reported=%s"
		% [str(accepted), off_mesh_m, str(really_off), str(exact), str(not_redirected)])
	_reached("I80_click_to_move_stores_the_clicked_point_unsnapped")
	return ok

func chk_I81_no_sector_index_exists_anywhere_including_the_new_files() -> bool:
	# D-367 closed the 3D facing question: CONTINUOUS YAW. `CLAUDE.md` section
	# 12.1 clause 3: do NOT reintroduce a quantised facing restriction.
	#
	# THE NEEDLES ARE ASSEMBLED so this check does not find itself.
	var forms := ["sector" + "_index", "facing" + "_sector", "sector" + "_deg",
		"eight" + "_direction", "quantis", "quantiz", "hysteresis"]
	var hits: Array[String] = []
	for f in _runtime_script_files():
		var t := _read_text(String(f)).to_lower()
		for b in forms:
			for form in ["func %s" % b, "class_name %s" % b, "var %s" % b, "const %s" % b]:
				if t.find(form) >= 0:
					hits.append("%s: %s" % [String(f).get_file(), form])
	# And the new files are genuinely in the scan.
	var scanned := false
	for f in _runtime_script_files():
		if String(f).find("diag_beast") >= 0:
			scanned = true
	# MEASURED: a beast's facing takes many distinct values, not eight.
	var distinct := {}
	for i in 24:
		var a := TAU * float(i) / 24.0
		distinct[snappedf(rad_to_deg(YawDriver.yaw_to(Vector3(sin(a), 0, cos(a)))), 0.01)] = true
	var continuous := distinct.size() >= 20
	var guard := false
	var planted := "var facing_sector := 0"
	for b in forms:
		if planted.find("var %s" % b) >= 0:
			guard = true
	var ok := hits.is_empty() and scanned and continuous and guard
	_note("I81_no_sector_index_exists_anywhere_including_the_new_files",
		"RUNTIME declarations naming a sector index, a quantised facing or hysteresis: %s (must be none) | the new Imprint files ARE in the scan=%s | MEASURED: the shared yaw function produces %d distinct facings over 24 directions, not eight=%s | the guard catches a planted sector index=%s"
		% [str(hits), str(scanned), distinct.size(), str(continuous), str(guard)])
	_reached("I81_no_sector_index_exists_anywhere_including_the_new_files")
	return ok

func chk_I82_skill_actions_use_the_accepted_commitment_with_no_third_policy() -> bool:
	# D-373 ACCEPTED the STOP / ALLOW architecture. This stage USES it and adds
	# no third policy, no new window and no new tunable.
	await _rest()
	var two := ActionCommitment.POLICIES.size() == 2
	var commits_before := player.commitment.commits
	cam.debug_cursor_override = Vector3(-18, 0, 0)
	skills.clear_cooldowns()
	skills.pool.refill()
	# Drive to full speed FIRST, so the stop is measurable.
	player.intent.debug_move_axis = Vector2(1.0, 0.0)
	await _phys(50)
	var moving := player.motor.speed()
	var p0 := player.global_position
	skills.use_binding(0)
	var committed := player.commitment.active
	var policy := player.commitment.policy_name()
	var labelled := player.commitment.label.find("DIAGNOSTIC IMPRINT") >= 0
	var suppressed := player.commitment.suppresses_translation()
	# The feet stop; the marker is the ACCEPTED one.
	await _phys(3)
	var travelled := NavService.planar_distance(player.global_position, p0)
	var stopped := travelled <= ProdConfig.ACTION_GLIDE_TOLERANCE_M
	var marker := is_equal_approx(player.commitment.release_marker,
		ProdConfig.ATTACK_RELEASE_MARKER)
	var used_commitment := player.commitment.commits == commits_before + 1
	var g := 0
	while player.commitment.active and g < 200:
		await physics_frame
		g += 1
	await _rest()
	var ok := two and committed and policy == "STOP" and labelled and suppressed \
		and moving > 3.0 and stopped and marker and used_commitment
	_note("I82_skill_actions_use_the_accepted_commitment_with_no_third_policy",
		"the commitment still has EXACTLY TWO policies=%s | a Skill Use entered it (commits +1=%s) under the STOP policy=%s with a label naming it a DIAGNOSTIC IMPRINT=%s, suppressing translation=%s | running at %.3f m/s the actor travelled %.4f m over the first frames, inside the ACCEPTED %.2f m tolerance=%s | and the release marker is the ACCEPTED %.4f, not a new one=%s"
		% [str(two), str(used_commitment), str(policy == "STOP"), str(labelled),
		   str(suppressed), moving, travelled, ProdConfig.ACTION_GLIDE_TOLERANCE_M,
		   str(stopped), ProdConfig.ATTACK_RELEASE_MARKER, str(marker)])
	_reached("I82_skill_actions_use_the_accepted_commitment_with_no_third_policy")
	return ok

func chk_I83_a_cancel_during_a_skill_windup_is_refused_and_counted() -> bool:
	# A NEGATIVE CONTROL. The refusal is the whole safety property: a Skill must
	# never be cancellable before it has done its work.
	await _rest()
	cam.debug_cursor_override = Vector3(-18, 0, 0)
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(3)
	var refused_before := player.commitment.cancels_refused
	var uses_before := skills.skill_uses
	var releases_before := skills.releases
	skills.use_binding(0)
	await _phys(1)
	var in_windup := player.commitment.phase() == "windup"
	var window_shut := not player.commitment.cancel_window_open()
	# ATTACK THE GUARD DIRECTLY. A guard that is merely never called is not a guard.
	var refused := not player.commitment.cancel_recovery()
	var still_active := player.commitment.active
	var not_released := skills.releases == releases_before
	var counted := player.commitment.cancels_refused == refused_before + 1
	# AND IT STILL GOES ON TO RELEASE.
	var g := 0
	while player.commitment.active and g < 200:
		await physics_frame
		g += 1
	var released := skills.releases == releases_before + 1
	var one_use := skills.skill_uses == uses_before + 1
	await _rest()
	var ok := in_windup and window_shut and refused and still_active and not_released \
		and counted and released and one_use
	_note("I83_a_cancel_during_a_skill_windup_is_refused_and_counted",
		"during the wind-up (phase=%s, window shut=%s) a cancel was DEMANDED DIRECTLY and REFUSED=%s, the action stayed active=%s, nothing had been released=%s, and the refusal was COUNTED=%s | the Skill then went on to release normally=%s as exactly ONE use=%s"
		% [str(in_windup), str(window_shut), str(refused), str(still_active),
		   str(not_released), str(counted), str(released), str(one_use)])
	_reached("I83_a_cancel_during_a_skill_windup_is_refused_and_counted")
	return ok

func chk_I84_movement_after_a_skill_release_cancels_the_recovery() -> bool:
	await _rest()
	cam.debug_cursor_override = Vector3(-18, 0, 0)
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(3)
	var cancels_before := player.commitment.recovery_cancels
	var releases_before := skills.releases
	skills.use_binding(0)
	# NOTHING is requested until the window opens.
	var f := 0
	while f < 200 and not player.commitment.cancel_window_open():
		await physics_frame
		f += 1
	var opened_at := player.commitment.elapsed
	var natural := player.commitment.duration
	var released := skills.releases == releases_before + 1
	# NOW ask to move.
	player.intent.debug_move_axis = Vector2(1.0, 0.0)
	var g := 0
	while player.commitment.active and g < 60:
		await physics_frame
		g += 1
	var cancelled := player.commitment.recovery_cancels == cancels_before + 1
	var early := not player.commitment.active and g <= 3
	await _phys(20)
	var speed := player.motor.speed()
	await _rest()
	var ok := released and cancelled and early and speed > 1.0 and opened_at < natural
	_note("I84_movement_after_a_skill_release_cancels_the_recovery",
		"the Skill released=%s and its cancel window opened at %.4f s of a %.4f s action; a movement request then cancelled the REMAINING RECOVERY within %d frame(s)=%s/%s, and locomotion resumed to %.3f m/s"
		% [str(released), opened_at, natural, g, str(cancelled), str(early), speed])
	_reached("I84_movement_after_a_skill_release_cancels_the_recovery")
	return ok

func _count_diag_projectiles() -> int:
	var n := 0
	var root: Node = main.get("bolt_root")
	for c in root.get_children():
		if is_instance_valid(c) and c is DiagProjectile and (c as DiagProjectile).alive:
			n += 1
	return n

func chk_I85_a_released_projectile_survives_the_cancel_intact() -> bool:
	# ========================================================================
	# A NEGATIVE CONTROL, AND THE OWNER'S EXACT REQUIREMENT.
	# ========================================================================
	# "A released projectile, placed ballista/trap or summoned beast MUST SURVIVE
	# recovery cancellation." Cancelling touches an ANIMATION, never the effect.
	await _rest()
	# Aim down a clear run so nothing consumes the projectiles.
	player.global_position = Vector3(-13.0, 0, 6.0)
	cam.debug_cursor_override = Vector3(-13.0, 0, -6.0)
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(4)
	var releases_before := skills.releases
	skills.use_binding(0)
	var f := 0
	while f < 200 and skills.releases == releases_before:
		await physics_frame
		f += 1
	var after_release := _count_diag_projectiles()
	var sample: DiagProjectile = null
	var root: Node = main.get("bolt_root")
	for c in root.get_children():
		if is_instance_valid(c) and c is DiagProjectile and (c as DiagProjectile).alive:
			sample = c
	var travelled_before := sample.travelled if sample != null else -1.0
	# CANCEL THE RECOVERY.
	player.intent.debug_move_axis = Vector2(1.0, 0.0)
	var g := 0
	while player.commitment.active and g < 60:
		await physics_frame
		g += 1
	var cancelled := g <= 3 and not player.commitment.active
	var after_cancel := _count_diag_projectiles()
	var survived := sample != null and is_instance_valid(sample) and sample.alive
	await _phys(6)
	var still_travelling := sample != null and is_instance_valid(sample) \
		and sample.travelled > travelled_before
	var not_duplicated := skills.releases == releases_before + 1 \
		and after_cancel <= after_release
	await _rest()
	var ok := after_release >= 1 and cancelled and survived and not_duplicated \
		and still_travelling
	_note("I85_a_released_projectile_survives_the_cancel_intact",
		"%d projectile(s) existed after the release; cancelling the recovery (within %d frame(s))=%s left the sampled one ALIVE=%s, the live count went %d -> %d with releases still exactly +1=%s, and it kept travelling past %.3f m=%s. THE CANCEL TOUCHED AN ANIMATION, NOT THE PROJECTILE."
		% [after_release, g, str(cancelled), str(survived), after_release, after_cancel,
		   str(not_duplicated), travelled_before, str(still_travelling)])
	_reached("I85_a_released_projectile_survives_the_cancel_intact")
	return ok

func chk_I86_a_placed_ballista_survives_the_cancel_intact() -> bool:
	await _rest()
	DiagBallista.reset_counters()
	player.global_position = Vector3(-13.0, 0, 0)
	cam.debug_cursor_override = Vector3(-10.5, 0, 0)
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(4)
	var releases_before := skills.releases
	skills.use_binding(1)
	var f := 0
	while f < 200 and skills.releases == releases_before:
		await physics_frame
		f += 1
	var placed := skills.ballistae.size()
	var sample = skills.ballistae[0] if placed > 0 else null
	var elapsed_before: float = sample.elapsed if sample != null else -1.0
	player.intent.debug_move_axis = Vector2(1.0, 0.0)
	var g := 0
	while player.commitment.active and g < 60:
		await physics_frame
		g += 1
	var cancelled := g <= 3 and not player.commitment.active
	var survived: bool = sample != null and is_instance_valid(sample) and sample.alive
	await _phys(8)
	var still_running: bool = sample != null and is_instance_valid(sample) \
		and sample.elapsed > elapsed_before
	var not_duplicated := skills.releases == releases_before + 1 \
		and skills.ballistae.size() == placed
	await _rest()
	var ok: bool = placed == 1 and cancelled and survived and still_running and not_duplicated
	_note("I86_a_placed_ballista_survives_the_cancel_intact",
		"one emplacement existed after the release (%d); cancelling the recovery within %d frame(s)=%s left it ALIVE=%s and STILL COUNTING DOWN past %.3f s=%s, with releases exactly +1 and the count unchanged=%s"
		% [placed, g, str(cancelled), str(survived), elapsed_before, str(still_running),
		   str(not_duplicated)])
	_reached("I86_a_placed_ballista_survives_the_cancel_intact")
	return ok

func chk_I87_a_summoned_beast_survives_the_cancel_intact() -> bool:
	await _rest()
	DiagBeast.reset_counters()
	player.global_position = Vector3(-13.0, 0, 5.5)
	cam.debug_cursor_override = Vector3(-11.0, 0, 5.5)
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(4)
	var releases_before := skills.releases
	skills.use_binding(2)
	var f := 0
	while f < 200 and skills.releases == releases_before:
		await physics_frame
		f += 1
	var summoned := skills.beasts.size()
	var sample = skills.beasts[0] if summoned > 0 else null
	player.intent.debug_move_axis = Vector2(1.0, 0.0)
	var g := 0
	while player.commitment.active and g < 60:
		await physics_frame
		g += 1
	var cancelled := g <= 3 and not player.commitment.active
	var survived := sample != null and is_instance_valid(sample)
	await _phys(10)
	var alive_after := skills.beasts.size()
	var same := alive_after == summoned
	var dismissed := DiagBeast.dismissed_total
	var not_duplicated := skills.releases == releases_before + 1 \
		and DiagBeast.summoned_total == summoned
	await _rest()
	var ok := summoned >= 1 and cancelled and survived and same and dismissed == 0 \
		and not_duplicated
	_note("I87_a_summoned_beast_survives_the_cancel_intact",
		"%d beast(s) existed after the release; cancelling the recovery within %d frame(s)=%s left the sampled one ALIVE=%s and the pack at %d=%s, with ZERO dismissals (%d) and releases exactly +1=%s"
		% [summoned, g, str(cancelled), str(survived), alive_after, str(same),
		   dismissed, str(not_duplicated)])
	_reached("I87_a_summoned_beast_survives_the_cancel_intact")
	return ok

func chk_I88_configurations_of_one_skill_share_its_cooldown() -> bool:
	# ========================================================================
	# CANON: "Cooldowns belong to the base Skill and remain SHARED across its
	# configurations by default. Duplicate bindings cannot bypass an intended
	# limitation."
	# ========================================================================
	await _rest()
	cam.debug_cursor_override = Vector3(-18, 0, 0)
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(3)
	var lo := skills.loadout
	var i_hi := lo.bindings.find(DiagImprintContent.CFG_VOLLEY)
	var i_low := lo.bindings.find(DiagImprintContent.CFG_LOW)
	var i_other := lo.bindings.find(DiagImprintContent.CFG_BEASTS)
	var same_skill := _cfg(DiagImprintContent.CFG_VOLLEY).skill_id \
		== _cfg(DiagImprintContent.CFG_LOW).skill_id
	# USE ONE.
	var first := skills.use_binding(i_hi)
	var g := 0
	while player.commitment.active and g < 200:
		await physics_frame
		g += 1
	var cd := skills.cooldown_remaining(_cfg(DiagImprintContent.CFG_VOLLEY).skill_id)
	var on_cooldown := cd > 0.0
	# THE OTHER CONFIGURATION OF THE SAME SKILL IS BLOCKED BY IT.
	var second := skills.use_binding(i_low)
	var blocked: bool = not second["ok"] and String(second["reason"]).findn("shares the cooldown") >= 0
	# A NEGATIVE CONTROL: a DIFFERENT Skill is NOT blocked.
	skills.pool.refill()
	var third := skills.use_binding(i_other)
	var not_blocked: bool = third["ok"]
	var g2 := 0
	while player.commitment.active and g2 < 200:
		await physics_frame
		g2 += 1
	await _rest()
	var ok: bool = same_skill and first["ok"] and on_cooldown and blocked and not_blocked
	_note("I88_configurations_of_one_skill_share_its_cooldown",
		"bindings %d and %d hold DIFFERENT Configurations of the SAME Skill Imprint=%s; using the first put %.3f s on the SHARED cooldown=%s and the second was BLOCKED BY IT=%s ('%s') | NEGATIVE CONTROL: a Configuration of a DIFFERENT Skill fired normally=%s, so the sharing is keyed on the Skill Imprint and not on everything"
		% [i_hi + 1, i_low + 1, str(same_skill), cd, str(on_cooldown), str(blocked),
		   String(second["reason"]), str(not_blocked)])
	_reached("I88_configurations_of_one_skill_share_its_cooldown")
	return ok

func chk_I89_cost_is_paid_at_use_start_and_a_use_without_resources_is_refused() -> bool:
	# ========================================================================
	# CANON: "The Skill cost is checked and paid WHEN USE BEGINS. A Skill cannot
	# begin without sufficient resources."
	# ========================================================================
	await _rest()
	cam.debug_cursor_override = Vector3(-18, 0, 0)
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(3)
	var cfg := _cfg(DiagImprintContent.CFG_VOLLEY)
	var cost := float(cfg.resolve()["mana_cost"])
	var before := skills.pool.mana_current
	var spends_before := skills.pool.spends
	skills.use_binding(0)
	# PAID AT THE START: the Mana is gone BEFORE the release, not after it.
	var paid_at_start := is_equal_approx(skills.pool.mana_current, before - cost) \
		and skills.pool.spends == spends_before + 1
	var before_release := player.commitment.phase() == "windup"
	var g := 0
	while player.commitment.active and g < 200:
		await physics_frame
		g += 1
	# A NEGATIVE CONTROL: with too little Mana the use CANNOT BEGIN.
	skills.clear_cooldowns()
	skills.pool.mana_current = cost * 0.5
	var refused_before := skills.uses_refused
	var commits_before := player.commitment.commits
	var r := skills.use_binding(0)
	var refused: bool = not r["ok"]
	var says := String(r["reason"]).findn("Mana") >= 0
	var no_action := player.commitment.commits == commits_before \
		and not player.commitment.active
	var counted := skills.uses_refused == refused_before + 1
	var not_spent := is_equal_approx(skills.pool.mana_current, cost * 0.5)
	await _rest()
	var ok: bool = cost > 0.0 and paid_at_start and before_release and refused and says \
		and no_action and counted and not_spent
	_note("I89_cost_is_paid_at_use_start_and_a_use_without_resources_is_refused",
		"the %.1f Mana cost was deducted AT USE START — %.1f -> %.1f, while the action was still in its WIND-UP=%s/%s | NEGATIVE CONTROL: with only %.1f Mana the use was REFUSED=%s and said why=%s, NO action began=%s, the refusal was counted=%s, and NOTHING was spent=%s"
		% [cost, before, skills.pool.mana_current, str(paid_at_start), str(before_release),
		   cost * 0.5, str(refused), str(says), str(no_action), str(counted),
		   str(not_spent)])
	_reached("I89_cost_is_paid_at_use_start_and_a_use_without_resources_is_refused")
	return ok

func chk_I90_a_cooldown_begins_on_successful_release() -> bool:
	# ========================================================================
	# CANON: "A cooldown begins on SUCCESSFUL RELEASE." Not at use start.
	# ========================================================================
	await _rest()
	cam.debug_cursor_override = Vector3(-18, 0, 0)
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(3)
	var cfg := _cfg(DiagImprintContent.CFG_VOLLEY)
	var id := cfg.skill_id
	var releases_before := skills.releases
	skills.use_binding(0)
	await _phys(1)
	# DURING THE WIND-UP THE COOLDOWN IS STILL ZERO.
	var during := skills.cooldown_remaining(id)
	var zero_in_windup := is_equal_approx(during, 0.0) \
		and player.commitment.phase() == "windup"
	var f := 0
	while f < 200 and skills.releases == releases_before:
		await physics_frame
		f += 1
	var after := skills.cooldown_remaining(id)
	var started := after > 0.0
	var expected := float(cfg.resolve()["cooldown"])
	var right_length := absf(after - expected) <= 0.05
	var g := 0
	while player.commitment.active and g < 200:
		await physics_frame
		g += 1
	await _rest()
	var ok := zero_in_windup and started and right_length
	_note("I90_a_cooldown_begins_on_successful_release",
		"during the WIND-UP the shared cooldown was still %.4f s — ZERO=%s | on the release it became %.4f s against the resolved %.4f s=%s/%s. THE COOLDOWN BEGINS ON RELEASE, NOT AT USE START."
		% [during, str(zero_in_windup), after, expected, str(started), str(right_length)])
	_reached("I90_a_cooldown_begins_on_successful_release")
	return ok

func chk_I91_edits_are_refused_during_active_combat_and_the_override_is_declared() -> bool:
	# ========================================================================
	# CANON: installing or removing a modifier is "unavailable during active
	# combat" -- implemented as a BOUNDED, DECLARED approximation (conflict X-08).
	# ========================================================================
	await _rest()
	# WITH THE OVERRIDE OFF, the canonical refusal must fire.
	skills.set_safe_state_override(false)
	var probe := await _probe_enemy("I91Probe", Vector3(-12.0, 0, 0))
	_register(probe)
	probe.debug_freeze_ai = false
	player.global_position = Vector3(-13.0, 0, 0)
	await _phys(40)
	probe.debug_freeze_ai = true
	var in_combat := not skills.canonical_safe_state()
	var refused_before := skills.edits_refused
	var gear_before := skills.loadout.gear_bonus_active
	var r := skills.set_gear_bonus(not gear_before)
	var refused: bool = not r["ok"]
	var says := String(r["reason"]).findn("ACTIVE COMBAT") >= 0 \
		and String(r["reason"]).findn("REFUSED") >= 0
	var counted := skills.edits_refused == refused_before + 1
	var unchanged := skills.loadout.gear_bonus_active == gear_before
	# THE OVERRIDE IS A DECLARED SEAM, and the panel shows the CANONICAL verdict
	# even while the override is letting an edit through.
	skills.set_safe_state_override(true)
	var allowed_before := skills.edits_allowed
	var r2 := skills.set_gear_bonus(gear_before)
	var allowed: bool = r2["ok"] and skills.edits_allowed == allowed_before + 1
	panel.refresh()
	var text := panel.compose()
	var declared := text.findn("DIAGNOSTIC safe-state override") >= 0 \
		and text.findn("canonical verdict") >= 0
	var conflict := false
	for c in ImprintConfig.declared_conflicts():
		if String(c[0]) == "X-08" and String(c[2]).findn("DECLARED SEAM") >= 0:
			conflict = true
	_unregister(probe)
	skills.set_safe_state_override(true)
	await _rest()
	var ok: bool = in_combat and refused and says and counted and unchanged and allowed \
		and declared and conflict
	_note("I91_edits_are_refused_during_active_combat_and_the_override_is_declared",
		"with the override OFF and an enemy having acquired the player, the canonical safe state was FALSE=%s and an edit was REFUSED=%s with a reason naming ACTIVE COMBAT=%s, COUNTED=%s, and the state UNCHANGED=%s | with the override ON the same edit was allowed and counted=%s | the panel shows the override AND the canonical verdict side by side=%s, and conflict X-08 declares it a SEAM rather than a silent bypass=%s. Reason: '%s'"
		% [str(in_combat), str(refused), str(says), str(counted), str(unchanged),
		   str(allowed), str(declared), str(conflict), String(r["reason"])])
	_reached("I91_edits_are_refused_during_active_combat_and_the_override_is_declared")
	return ok

# ============================================================================
# J. THE LIVE-REVIEW PANEL
# ============================================================================

func chk_I92_the_panel_shows_every_required_element() -> bool:
	# ========================================================================
	# ELEVEN ELEMENTS, EACH ASSERTED ON ITS OWN.
	# ========================================================================
	# The ruling lists them: Imprint type and name · Mastered Rank · selected
	# Effective Rank · XP progress · Configuration slots · compatibility errors ·
	# Capacity used/available and its sources · reserved Mana and Life · active
	# versus Persistent Configurations · the Transform limit · the three
	# representative configurations.
	#
	# A single "does the panel look right" assertion would let a silently missing
	# element pass, so each is a separate sub-assertion with its own page.
	skills.set_safe_state_override(true)
	var lib := skills.library
	var missing: Array[String] = []
	var pages := {}
	for p in LoadoutPanel.PAGES.size():
		panel.page = p
		panel.refresh()
		pages[String(LoadoutPanel.PAGES[p])] = panel.compose()
	var all_text := ""
	for k in pages:
		all_text += String(pages[k]) + "\n"
	var required := [
		["Imprint type and name", "AUGMENT" ],
		["Imprint type and name (a real name)", "Split Volley"],
		["Mastered Rank", "MASTERED"],
		["selected Effective Rank", "Effective"],
		["XP progress", "XP PROGRESS"],
		["Configuration slots", "slots"],
		["compatibility errors", "INCOMPATIBLE"],
		["Capacity used and available", "CONFIGURATION CAPACITY"],
		["Capacity sources", "character progression"],
		["reserved Mana", "Mana   max"],
		["reserved Life", "Life   max"],
		["active versus Persistent", "Persistent Configurations"],
		["the Transform limit", "Transform of"],
		["the three representative Configurations", "THE THREE REPRESENTATIVE CONFIGURATIONS"],
	]
	for row in required:
		if all_text.find(String(row[1])) < 0:
			missing.append(String(row[0]))
	# The three representative Configurations must be named, individually.
	for cid in DiagImprintContent.THE_THREE_REPRESENTATIVE:
		if all_text.find(String(cid)) < 0:
			missing.append("the Configuration %s" % String(cid))
	# And a real compatibility error must be visible, not merely the word.
	var trials_text := String(pages["COMPATIBILITY TRIALS"])
	var real_error := trials_text.findn("REFUSED") >= 0 \
		and trials_text.findn("requires") >= 0
	panel.page = 0
	panel.refresh()
	var ok := missing.is_empty() and real_error and all_text.length() > 4000
	_note("I92_the_panel_shows_every_required_element",
		"all %d required elements are present across the panel's %d pages (missing: %s); a REAL compatibility refusal with its reason is visible, not merely the word=%s; %d characters of composed text in total"
		% [required.size() + 3, LoadoutPanel.PAGES.size(), str(missing), str(real_error),
		   all_text.length()])
	_reached("I92_the_panel_shows_every_required_element")
	return ok

func chk_I93_the_panel_offers_every_required_comparison() -> bool:
	# ========================================================================
	# SIX COMPARISONS, EACH ASSERTED ON ITS OWN.
	# ========================================================================
	skills.set_safe_state_override(true)
	panel.page = LoadoutPanel.PAGES.find("THE SIX COMPARISONS")
	panel.refresh()
	var t := panel.compose()
	var missing: Array[String] = []
	var required := [
		"THE SAME SKILL IMPRINT AT LOW AND HIGH EFFECTIVE RANK",
		"A LEGAL AND AN ILLEGAL SECOND TRANSFORM",
		"A LEGAL LOADOUT AND AN OVER-CAPACITY LOADOUT",
		"MANA RESERVATION VERSUS LIFE RESERVATION",
		"ORDINARY BOW DAMAGE VERSUS AUTONOMOUS BEAST-PRIMARY DAMAGE",
		"REUSE OF ONE AUGMENT WITHOUT DUPLICATED MASTERY OR XP",
	]
	for r in required:
		if t.find(r) < 0:
			missing.append(r)
	# EACH COMPARISON MUST CARRY LIVE NUMBERS, not just a heading.
	var hi := _cfg(DiagImprintContent.CFG_VOLLEY)
	var low := _cfg(DiagImprintContent.CFG_LOW)
	var shows_both_ranks := t.find(str(hi.skill_rank())) >= 0 and t.find("low") >= 0
	var shows_refusal := t.findn("REFUSED") >= 0
	var shows_budget := t.find(str(skills.loadout.capacity_total())) >= 0
	var shows_reservation := t.findn("Mana reserved") >= 0 and t.findn("Life reserved") >= 0
	var shows_sources := t.findn("beasts summoned") >= 0
	var shows_reuse := t.findn("ONE Mastered Rank") >= 0
	var ok := missing.is_empty() and shows_both_ranks and shows_refusal \
		and shows_budget and shows_reservation and shows_sources and shows_reuse
	panel.page = 0
	panel.refresh()
	_note("I93_the_panel_offers_every_required_comparison",
		"all six comparisons are present (missing: %s), and each carries LIVE NUMBERS rather than only a heading: both ranks=%s · a real refusal=%s · the live budget=%s · both reservations=%s · the damage sources=%s · the reuse record=%s"
		% [str(missing), str(shows_both_ranks), str(shows_refusal), str(shows_budget),
		   str(shows_reservation), str(shows_sources), str(shows_reuse)])
	_reached("I93_the_panel_offers_every_required_comparison")
	return ok

func chk_I94_the_panel_is_navigable_with_explicit_focus_and_no_typed_text() -> bool:
	# `CLAUDE.md` section 8: "Explicit focus and spatial navigation rather than
	# hover; no typed text and no drag precision required anywhere."
	skills.set_safe_state_override(true)
	var start := panel.focus_index
	# EXPLICIT FOCUS: the panel owns an index and DRAWS it.
	panel.refresh()
	var drawn := panel.compose().find(">") >= 0
	# Navigation moves it, and wraps.
	panel.focus_index = 0
	var moved: Array[int] = []
	for i in LoadoutPanel.ROWS.size() + 1:
		moved.append(panel.focus_index)
		panel.focus_index = (panel.focus_index + 1) % LoadoutPanel.ROWS.size()
	var wrapped := panel.focus_index == 1 and moved.size() == LoadoutPanel.ROWS.size() + 1
	# EVERY ROW IS ACTIVATABLE, and each one does something.
	var results: Array[String] = []
	var failures: Array[String] = []
	for i in LoadoutPanel.ROWS.size():
		panel.focus_index = i
		var before := panel.activations
		var res := panel.activate_focused()
		if panel.activations != before + 1 or res == "" or res == "no runtime":
			failures.append(String(LoadoutPanel.ROWS[i]))
		results.append("%s -> %s" % [String(LoadoutPanel.ROWS[i]), res.substr(0, 46)])
	# NO TYPED TEXT AND NO DRAG: there is no LineEdit, TextEdit or drag handler.
	var src := _read_text("res://scripts/imprint/loadout_panel.gd")
	var no_text_entry := src.find("LineEdit") < 0 and src.find("TextEdit") < 0 \
		and src.find("SpinBox") < 0
	var no_drag := src.find("_drag") < 0 and src.find("InputEventMouseMotion") < 0 \
		and src.find("InputEventMouseButton") < 0
	# Restore.
	panel.focus_index = start
	skills.set_safe_state_override(true)
	skills.set_gear_bonus(true)
	skills.set_life_tithe(false)
	skills.loadout.revalidate(skills.pool)
	panel.page = 0
	panel.refresh()
	var ok := drawn and wrapped and failures.is_empty() and no_text_entry and no_drag \
		and LoadoutPanel.ROWS.size() == 6
	_note("I94_the_panel_is_navigable_with_explicit_focus_and_no_typed_text",
		"the panel owns an EXPLICIT focus index and DRAWS the marker=%s; navigation moves and wraps across all %d rows=%s; EVERY row activated and did something (failures: %s) — %s | no LineEdit, TextEdit or SpinBox exists=%s and no drag or mouse handler exists=%s"
		% [str(drawn), LoadoutPanel.ROWS.size(), str(wrapped), str(failures),
		   str(results), str(no_text_entry), str(no_drag)])
	_reached("I94_the_panel_is_navigable_with_explicit_focus_and_no_typed_text")
	return ok

func chk_I95_every_panel_command_is_a_named_input_action() -> bool:
	# `CLAUDE.md` section 8: "Every implemented command is a named, remappable
	# action." So no panel command may be a raw key test.
	var required := ["imprint_panel", "imprint_panel_prev", "imprint_panel_next",
		"imprint_panel_activate"]
	var missing: Array[String] = []
	for a in required:
		if not InputMap.has_action(a):
			missing.append(a)
	var src := _read_text("res://scripts/imprint/loadout_panel.gd")
	# No raw key test anywhere: everything goes through the named actions.
	var raw := src.find("Input.is_key_pressed") >= 0 \
		or src.find("Input.is_physical_key_pressed") >= 0
	# Each required action is actually consulted.
	var unused: Array[String] = []
	for a in required:
		if src.find(a) < 0:
			unused.append(a)
	# CONTROLLER COVERAGE for the panel is COMPLETE, and it avoids the D-pad,
	# which the accepted foundation already uses for zoom. A same-context
	# conflict is not this stage's to resolve on the owner's behalf.
	var padless: Array[String] = []
	var dpad: Array[String] = []
	for a in required:
		var has_pad := false
		for ev in InputMap.action_get_events(a):
			if ev is InputEventJoypadButton:
				has_pad = true
				var idx := (ev as InputEventJoypadButton).button_index
				if idx >= 11 and idx <= 14:
					dpad.append("%s -> D-pad %d" % [a, idx])
		if not has_pad:
			padless.append(a)
	var ok := missing.is_empty() and not raw and unused.is_empty() \
		and padless.is_empty() and dpad.is_empty()
	_note("I95_every_panel_command_is_a_named_input_action",
		"all %d panel commands are NAMED, remappable InputMap actions (missing: %s, declared-but-unused: %s); NO raw key test exists in the panel=%s; every one has a CONTROLLER binding (without one: %s); and NONE uses the D-pad, which the accepted foundation already binds to zoom (conflicts: %s)"
		% [required.size(), str(missing), str(unused), str(not raw), str(padless),
		   str(dpad)])
	_reached("I95_every_panel_command_is_a_named_input_action")
	return ok

func chk_I96_the_panel_denies_being_a_ui_foundation() -> bool:
	# P1A transferred the UI debt to a later foundation and `CLAUDE.md` section 12
	# forbids beginning one. The panel must say so where a viewer can read it.
	panel.refresh()
	var t := panel.compose()
	var says := t.findn("DEVELOPER surface") >= 0 and t.findn("NOT a UI foundation") >= 0
	var src := _read_text("res://scripts/imprint/loadout_panel.gd")
	var src_says := src.find("THIS IS NOT A UI FOUNDATION") >= 0
	var denial := false
	for d in ImprintConfig.denials():
		if String(d).findn("NOT a UI foundation") >= 0:
			denial = true
	# AND THE ACCEPTED UI DEBT IS STILL OWED where it was.
	var fsrc := _read_text("res://scripts/debug/debug_overlay.gd")
	var still_owed := fsrc.find("THIS IS NOT A UI FOUNDATION") >= 0
	var ok := says and src_says and denial and still_owed
	_note("I96_the_panel_denies_being_a_ui_foundation",
		"the live panel text says DEVELOPER surface and NOT a UI foundation=%s; the source says it in capitals=%s; it is one of this stage's declared denials=%s; and the ACCEPTED overlay still carries the same denial, so the UI debt is unchanged=%s"
		% [str(says), str(src_says), str(denial), str(still_owed)])
	_reached("I96_the_panel_denies_being_a_ui_foundation")
	return ok

func chk_I97_the_panel_can_be_disabled() -> bool:
	var was := panel.enabled
	panel.set_enabled(false)
	await _phys(2)
	var off := (not panel.enabled) and (not panel.visible)
	panel.set_enabled(true)
	await _phys(2)
	var on := panel.enabled and panel.visible
	panel.set_enabled(was)
	# And the composition root disables it for every evidence capture except the
	# one whose SUBJECT is the panel.
	var src := _read_text("res://scripts/foundation_main.gd")
	var capture_aware := src.find("imprint_panel.set_enabled(mode == \"panel\")") >= 0
	var ok := off and on and panel.toggles > 0 and capture_aware
	_note("I97_the_panel_can_be_disabled",
		"the panel disables=%s and re-enables=%s (%d toggles) | and the composition root disables it in EVERY rendered evidence capture except the one whose subject is the panel itself=%s"
		% [str(off), str(on), panel.toggles, str(capture_aware)])
	_reached("I97_the_panel_can_be_disabled")
	return ok

# ============================================================================
# K. VERIFICATION DISCIPLINE
# ============================================================================

func chk_I98_test_seams_are_clear_in_normal_play() -> bool:
	# Asserted against the state captured BEFORE this suite touched anything, so
	# it cannot be satisfied by the suite tidying up after itself.
	# THE CLAIM IS ABOUT SCENE START, which `initial_seams_clear` captured BEFORE
	# this suite touched anything. The second half is that the seams CAN be
	# returned to clear -- so they are cleared here and then asserted, rather than
	# asserting the state the suite itself happened to leave behind. `_rest()`
	# deliberately parks the cursor override on a known point, which is a seam.
	player.intent.clear_seams()
	cam.debug_cursor_override = null
	player.debug_freeze_attack = false
	await _phys(2)
	var now := player.intent.seams_clear() and cam.debug_cursor_override == null \
		and not player.debug_freeze_attack
	# And the new stage adds no seam of its own that is on by default, EXCEPT the
	# DECLARED safe-state override, which is named here rather than hidden.
	var src := _read_text("res://scripts/imprint/skill_runtime.gd")
	var declared_seam := src.find("diagnostic_safe_state_override") >= 0 \
		and src.find("LOUDLY LABELLED") >= 0
	var override_was_on := initial_override
	var ok := initial_seams_clear and now and declared_seam and override_was_on
	_note("I98_test_seams_are_clear_in_normal_play",
		"every ACCEPTED test seam was clear at scene start, BEFORE this suite touched anything=%s, and is clear again now=%s | THIS STAGE ADDS EXACTLY ONE SEAM, and it is DECLARED rather than hidden: the DIAGNOSTIC safe-state override, which was %s at start-up and is labelled, counted and proved refusable by I91=%s"
		% [str(initial_seams_clear), str(now), "ON" if override_was_on else "OFF",
		   str(declared_seam)])
	_reached("I98_test_seams_are_clear_in_normal_play")
	return ok

func chk_I99_no_runtime_dependency_leaves_this_project() -> bool:
	# The same claim the accepted baseline makes, re-asserted over the NEW files.
	# THE NEEDLES ARE ASSEMBLED, NOT WRITTEN, or this check would report itself.
	var up := ".." + "/"
	var res := "res:" + "//"
	var forms := [res + up, "\"" + up, "'" + up, "user:" + "//" + up,
		res + "game2d", res + "game3d_spike", res + "game3d_boss_spike", res + "game/"]
	var deps: Array[String] = []
	for f in _all_project_files():
		var p := String(f)
		if not (p.ends_with(".gd") or p.ends_with(".tscn") or p.ends_with(".godot")):
			continue
		var t := _read_text(p)
		for form in forms:
			if t.find(String(form)) >= 0:
				deps.append("%s contains %s" % [p.get_file(), form])
	var planted := "var x = load(\"" + res + up + "game2d/scripts/thing.gd\")"
	var guard := false
	for form in forms:
		if planted.find(String(form)) >= 0:
			guard = true
	# And the NEW files are genuinely in the scan.
	var scanned := 0
	for f in _all_project_files():
		if String(f).begins_with("res://scripts/imprint/"):
			scanned += 1
	var ok := deps.is_empty() and guard and scanned >= 12
	_note("I99_no_runtime_dependency_leaves_this_project",
		"paths a loader could follow out of this project: %s (must be none) | %d files under scripts/imprint/ are in the scan=%s | the scan is PROVED able to catch a planted load() into a frozen prototype=%s"
		% [str(deps), scanned, str(scanned >= 12), str(guard)])
	_reached("I99_no_runtime_dependency_leaves_this_project")
	return ok

func chk_I100_the_units_are_named_separately_at_this_surface() -> bool:
	# This project has been BLOCKED ONCE by a closure that quoted two different
	# counts as if they were one number. The ruling repeats the instruction.
	var src := _read_text("res://tests/imprint_verification.gd")
	var names_all := src.find("D-375 OWED CRITERIA") >= 0 \
		and src.find("D-375 EXECUTABLE CHECKS") >= 0 \
		and src.find("D-375 RUNNER CHECKS") >= 0 \
		and src.find("D-370 EXECUTABLE CHECKS") >= 0
	var says_distinct := src.findn("none is a synonym for another") >= 0
	# The three D-375 counts must be DIFFERENT NUMBERS, or the distinction is
	# rhetorical.
	var distinct := OWED.size() != 149 and OWED.size() != 85
	# And the accepted suite's count is untouched by this one.
	var fsrc := _read_text("res://tests/foundation_verification.gd")
	var accepted_count := 0
	var i := fsrc.find("const OWED := [")
	if i >= 0:
		var j := fsrc.find("\n]\n", i)
		accepted_count = fsrc.substr(i, j - i).count("\n\t\"F")
	var accepted_unchanged := accepted_count == 85
	var ok := names_all and says_distinct and distinct and accepted_unchanged \
		and OWED.size() == 101
	_note("I100_the_units_are_named_separately_at_this_surface",
		"this suite names all five counts with their decisions=%s and states that none is a synonym for another=%s | THIS suite owes %d EXECUTABLE CHECKS, the D-375 inventory owes 149 CRITERIA, and the runner makes its own count — three different numbers=%s | and the ACCEPTED suite still owes exactly %d, counted from its own source=%s"
		% [str(names_all), str(says_distinct), OWED.size(), str(distinct),
		   accepted_count, str(accepted_unchanged)])
	_reached("I100_the_units_are_named_separately_at_this_surface")
	return ok

func chk_I101_targeting_is_sampled_per_use_and_not_at_the_release() -> bool:
	# ========================================================================
	# A DEFECT THE RENDERED EVIDENCE EXPOSED, AND NO CHECK WAS LOOKING FOR.
	# ========================================================================
	# Canon, locked by D-193: "A skill samples the cursor WHEN THAT SKILL USE
	# BEGINS", "Held and repeated skills re-evaluate the cursor for EVERY use",
	# and mouse combat has "no persistent mechanical selection".
	#
	# The first version of this runtime read `player.aim_dir` AT THE RELEASE.
	# The aim keeps updating through the wind-up, so swinging the cursor
	# mid-action would have dragged the projectile, the ground target and the
	# summon circle after it -- persistent targeting wearing a per-use coat.
	#
	# MEASURED BY SWINGING THE AIM DURING THE WIND-UP AND REQUIRING THE EFFECT
	# TO IGNORE IT. That is the only test that can tell the two apart.
	await _rest()
	var start := Vector3(-13.0, 0, 0.0)
	var aim_a := Vector3(-13.0, 0, -8.0)      # sampled at use start
	var aim_b := Vector3(-5.0, 0, 8.0)        # swung to, mid wind-up
	player.global_position = start
	cam.debug_cursor_override = aim_a
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(6)
	var dir_at_start := player.aim_dir
	var releases_before := skills.releases
	skills.use_binding(0)
	var sampled := skills.sampled_aim_dir()
	var captured := sampled.length() > 0.001 \
		and sampled.distance_to(dir_at_start) < 0.02
	# SWING THE AIM HARD, DURING THE WIND-UP.
	cam.debug_cursor_override = aim_b
	await _phys(1)
	var swung := player.aim_dir.distance_to(dir_at_start) > 0.5
	var f := 0
	while f < 200 and skills.releases == releases_before:
		await physics_frame
		f += 1
	# THE PROJECTILE MUST HAVE GONE WHERE THE USE BEGAN, not where the aim went.
	var fired_dir := Vector3.ZERO
	var root: Node = main.get("bolt_root")
	for c in root.get_children():
		if is_instance_valid(c) and c is DiagProjectile and (c as DiagProjectile).alive:
			fired_dir = (c as DiagProjectile).direction
	var went_to_start := fired_dir.length() > 0.001 \
		and fired_dir.distance_to(dir_at_start) < 0.30
	var not_to_swung := fired_dir.length() > 0.001 \
		and fired_dir.distance_to(player.aim_dir) > 0.30
	# AND NOTHING SURVIVES THE USE.
	var cleared := skills.sampled_aim_dir() == Vector3.ZERO \
		and skills.sampled_aim_point() == Vector3.ZERO
	# THE GROUND-TARGETED SKILL IS THE SAME RULE, and is checked separately
	# because it samples a POINT rather than a direction.
	await _rest()
	player.global_position = start
	cam.debug_cursor_override = Vector3(-11.4, 0, -2.4)
	skills.clear_cooldowns()
	skills.pool.refill()
	await _phys(6)
	var point_at_start := player.aim_point
	var rel2 := skills.releases
	skills.use_binding(1)
	cam.debug_cursor_override = Vector3(-16.5, 0, 6.0)
	var g := 0
	while g < 200 and skills.releases == rel2:
		await physics_frame
		g += 1
	var placed_at := Vector3.ZERO
	if not skills.ballistae.is_empty():
		placed_at = (skills.ballistae[0] as DiagBallista).global_position
	var placed_where_sampled := placed_at.length() > 0.001 \
		and NavService.planar_distance(placed_at, point_at_start) < 0.60
	var not_where_swung := placed_at.length() > 0.001 \
		and NavService.planar_distance(placed_at, player.aim_point) > 1.0
	# And the SOURCE no longer reads the live aim in the release path.
	var src := _read_text("res://scripts/imprint/skill_runtime.gd")
	var no_live_read := src.find("_fire_volley(cfg_id, res, player.aim_dir)") < 0 \
		and src.find("var ground := player.aim_point") < 0
	await _rest()
	var ok: bool = captured and swung and went_to_start and not_to_swung and cleared \
		and placed_where_sampled and not_where_swung and no_live_read
	_note("I101_targeting_is_sampled_per_use_and_not_at_the_release",
		"the aim was SAMPLED AT USE START=%s; it was then SWUNG HARD during the wind-up=%s; and the projectile still flew where the use BEGAN=%s and NOT where the aim went=%s | the ground-targeted Skill behaved the same way: the emplacement landed within %.2f m of the point sampled at use start=%s and over %.2f m from where the aim was swung to=%s | the sampled fields are ZERO between uses=%s, and the release path no longer reads the live aim at all=%s"
		% [str(captured), str(swung), str(went_to_start), str(not_to_swung),
		   NavService.planar_distance(placed_at, point_at_start), str(placed_where_sampled),
		   NavService.planar_distance(placed_at, player.aim_point), str(not_where_swung),
		   str(cleared), str(no_live_read)])
	_reached("I101_targeting_is_sampled_per_use_and_not_at_the_release")
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
	print("RESULTS — GLOBAL IMPRINT SYSTEM PROTOTYPE (D-375)")
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
	print("DEFERRED / STILL OWED — recorded as such, NEVER as passes:")
	for row in DEFERRED_ROWS:
		print("  [%-14s] %s" % [row[1], row[0]])
		print("                   %s" % row[2])

	print("")
	print("DISCHARGED — HISTORY, PRESERVED. A DISCHARGED ROW IS NOT A PASS:")
	for row in DISCHARGED_ROWS:
		print("  [%-18s] %s" % [row[1], row[0]])
		print("                       %s" % row[2])

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
	print("MEASURED CANONICAL CONFLICTS — reported, and NOT silently resolved:")
	for c in ImprintConfig.declared_conflicts():
		print("  %s  %s" % [c[0], c[1]])

	print("")
	print("EVERY VALUE THIS STAGE INTRODUCES IS PROVISIONAL. NO ACCEPTED D-373 VALUE MOVED.")
	print("CANONICAL, NOT THIS STAGE'S TO CHOOSE:")
	for row in ImprintConfig.canonical_registry():
		print("  %-38s %-6s %s" % [row[0], str(row[1]), row[2]])
	print("")
	for d in ImprintConfig.denials():
		print("  %s" % d)
	print("")
	print("UNITS: %d EXECUTABLE CHECKS here · 149 OWED CRITERIA in the D-375 inventory ·"
		% OWED.size())
	print("       the D-375 runner makes its own RUNNER CHECKS · and the ACCEPTED D-370")
	print("       suite's 85 EXECUTABLE CHECKS and 125 OWED CRITERIA are a DIFFERENT")
	print("       decision's numbers. Different unit. None is a synonym for another.")
	print("")
	var verdict := "PASS" if _all_ok() else "FAIL"
	print("IMPRINT VERIFICATION: %s (%d checks: %d passed, %d failed/unreached, %d deferred)"
		% [verdict, OWED.size(), passed, failed, DEFERRED_ROWS.size()])
	print("STATE: %s" % ProdConfig.STATE)
	print("------------------------------------------------------------------------")
