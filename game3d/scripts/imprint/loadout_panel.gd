class_name LoadoutPanel
extends CanvasLayer

## THE LOADOUT AND TESTING PANEL — a DEVELOPER surface for the live review.
##
## ============================================================================
## THIS IS NOT A UI FOUNDATION, AND IT MUST NEVER BE MISTAKEN FOR ONE.
## ============================================================================
## P1A transferred "HUD, menu, text and accessibility suitability at arbitrary
## output resolutions" to a later UI foundation, and THAT DEBT IS UNCHANGED.
## `CLAUDE.md` section 12 forbids beginning a UI foundation. Nothing here is
## styled, scaled, localised, themed or made accessible, and none of it is a
## claim about the eventual Shaping Board.
##
## It exists for one reason the ruling states directly: *"Show enough information
## in the UI for us to judge whether Capacity creates meaningful choices or
## merely annoyance."*
##
## ---------------------------------------------------------------------------
## EXPLICIT FOCUS AND SPATIAL NAVIGATION. NO TYPED TEXT. NO DRAG PRECISION.
## ---------------------------------------------------------------------------
## `CLAUDE.md` section 8: "Controller completeness is a hard scope condition
## across every surface, not only combat. Explicit focus and spatial navigation
## rather than hover; no typed text and no drag precision required anywhere."
##
## So every command is a NAMED, REMAPPABLE InputMap action; focus is an explicit
## index the panel draws; and there is no text field and no draggable thing
## anywhere. The panel's controller bindings deliberately avoid the D-pad, which
## the accepted foundation already uses for zoom -- a same-context conflict is
## not something this stage may resolve on the owner's behalf.
##
## ---------------------------------------------------------------------------
## IT SEPARATES A DIAGNOSTIC IMPRINT FROM A CANONICAL SKILL, EVERYWHERE.
## ---------------------------------------------------------------------------
## The accepted overlay prints the DESIGN name and the SOURCE CLIP name side by
## side so a borrowed clip is never presented as a designed move. The same
## discipline applies here: every Imprint is printed with its DIAGNOSTIC label,
## and the panel states what this stage does not finalize.

## D-380 ADDED ONE PAGE -- 5 + 1 = 6 -- and NO CONTROL: the six focus rows below
## and their four named input actions are unchanged. The new page shows the
## D-378 map and the aligned rules with live numbers.
const PAGES := ["OVERVIEW", "CONFIGURATIONS", "IMPRINT LIBRARY", "COMPATIBILITY TRIALS",
	"THE SIX COMPARISONS", "D-378 ALIGNMENT"]

## The focusable rows. EXPLICIT FOCUS: the panel owns an index and draws it.
const ROWS := [
	"simulated gear Capacity bonus",
	"Persistent reservation resource (Mana / Life)",
	"attempt a SECOND Transform (must be refused)",
	"cycle binding 1's Effective Rank (low / middle / maximum)",
	"DIAGNOSTIC safe-state override",
	"page",
]

var runtime: SkillRuntime
var label: RichTextLabel
var enabled: bool = false
var focus_index: int = 0
var page: int = 0

## Diagnostics the suite reads.
var toggles: int = 0
var activations: int = 0
var last_text: String = ""
var last_action_result: String = ""

## ============================================================================
## LAID OUT WITH A CONTAINER, BECAUSE AN ANCHOR PUT IT OFF SCREEN.
## ============================================================================
## The first version used `PRESET_TOP_RIGHT` plus `position = (16, 16)`. With
## both horizontal anchors at 1.0, that offset is measured FROM THE RIGHT EDGE,
## so a 980-pixel panel was placed 16 pixels PAST the right edge of a 1920-pixel
## frame and rendered entirely off screen.
##
## NO CHECK IN THIS SUITE WOULD EVER HAVE CAUGHT THAT. `compose()` returned the
## full text, the node was `visible`, and every content assertion passed against
## a panel nobody could see. THE RENDERED FRAME CAUGHT IT -- which is exactly why
## this project's rule is to render the evidence and look at it, and exactly the
## defect class `CLAUDE.md` section 5.2 names: "defects visible only in a
## rendered frame -- draw order, anchors, shimmer, layout, off-screen surfaces."
##
## So the layout is now a CONTAINER with an expanding spacer. It is correct at
## any output size and involves no arithmetic against a resolution.
func build() -> void:
	layer = 11
	var frame := Control.new()
	frame.name = "LoadoutPanelFrame"
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.offset_left = 16.0
	frame.offset_top = 16.0
	frame.offset_right = -16.0
	frame.offset_bottom = -16.0
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(frame)

	var row := HBoxContainer.new()
	row.name = "LoadoutPanelRow"
	row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(row)

	# The spacer takes every pixel the panel does not, which is what pushes the
	# panel to the right edge WITHOUT any reference to the output width.
	var spacer := Control.new()
	spacer.name = "LoadoutPanelSpacer"
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_child(spacer)

	var panel := PanelContainer.new()
	panel.name = "LoadoutPanelRoot"
	panel.custom_minimum_size = Vector2(940, 0)
	# SHRINK_BEGIN keeps it at the TOP instead of being stretched down the frame.
	panel.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.02, 0.02, 0.05, 0.90)
	sb.content_margin_left = 14
	sb.content_margin_right = 14
	sb.content_margin_top = 10
	sb.content_margin_bottom = 10
	panel.add_theme_stylebox_override("panel", sb)
	row.add_child(panel)

	label = RichTextLabel.new()
	label.name = "LoadoutPanelText"
	label.bbcode_enabled = true
	label.fit_content = true
	label.scroll_active = false
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	# A DEVELOPER SURFACE, so the type is made small enough to fit a long page
	# rather than pretty. NOTHING HERE IS A CLAIM ABOUT THE EVENTUAL HUD, and the
	# readable-minimum-text-size obligation stays with the UI foundation.
	label.add_theme_font_size_override("normal_font_size", 12)
	label.add_theme_font_size_override("bold_font_size", 12)
	label.add_theme_font_size_override("italics_font_size", 12)
	label.add_theme_font_size_override("mono_font_size", 12)
	panel.add_child(label)
	set_enabled(false)

func set_enabled(on: bool) -> void:
	if enabled != on:
		toggles += 1
	enabled = on
	visible = on

func _process(_delta: float) -> void:
	if InputMap.has_action("imprint_panel") and Input.is_action_just_pressed("imprint_panel"):
		set_enabled(not enabled)
	if not enabled:
		return
	if InputMap.has_action("imprint_panel_prev") and Input.is_action_just_pressed("imprint_panel_prev"):
		focus_index = (focus_index - 1 + ROWS.size()) % ROWS.size()
	if InputMap.has_action("imprint_panel_next") and Input.is_action_just_pressed("imprint_panel_next"):
		focus_index = (focus_index + 1) % ROWS.size()
	if InputMap.has_action("imprint_panel_activate") \
			and Input.is_action_just_pressed("imprint_panel_activate"):
		activate_focused()
	refresh()

## Activates the focused row. ONE entry point, so the suite can drive the panel
## without a device and assert exactly what a player would get.
func activate_focused() -> String:
	activations += 1
	if runtime == null:
		last_action_result = "no runtime"
		return last_action_result
	match focus_index:
		0:
			var r := runtime.set_gear_bonus(not runtime.loadout.gear_bonus_active)
			last_action_result = ("gear bonus %s — %s"
				% ["ON" if runtime.loadout.gear_bonus_active else "OFF",
				   str(r.get("report", r.get("reason", "")))])
		1:
			var cfg := runtime.loadout.configuration(DiagImprintContent.CFG_AURA) as SkillConfiguration
			var have: bool = cfg != null and cfg.has_modifier(DiagImprintContent.AUG_TITHE)
			var r2 := runtime.set_life_tithe(not have)
			last_action_result = ("reservation resource is now %s — %s"
				% [("LIFE" if not have else "MANA"), str(r2.get("reason", ""))])
		2:
			var r3 := runtime.attempt_second_transform()
			last_action_result = ("second Transform %s — %s"
				% [("REFUSED" if not r3["ok"] else "ACCEPTED (DEFECT)"), String(r3["reason"])])
		3:
			var r4 := runtime.cycle_effective_rank(DiagImprintContent.CFG_VOLLEY)
			last_action_result = "Effective Rank cycled — %s" % String(r4.get("reason", "ok"))
		4:
			runtime.set_safe_state_override(not runtime.diagnostic_safe_state_override)
			last_action_result = ("DIAGNOSTIC safe-state override %s"
				% ["ON" if runtime.diagnostic_safe_state_override else "OFF"])
		5:
			page = (page + 1) % PAGES.size()
			last_action_result = "page -> %s" % PAGES[page]
	return last_action_result

func refresh() -> void:
	if label == null:
		return
	label.text = compose()
	last_text = label.get_parsed_text()

## Composed as plain data so the verification suite can read exactly what a
## viewer reads. Reading the right words out of a control tree proves the words
## exist, not that anyone can see them -- which is why the rendered evidence is
## captured as well.
func compose() -> String:
	var L: Array[String] = []
	if runtime == null:
		return "no runtime"
	var lo := runtime.loadout
	var lib := runtime.library
	var pool := runtime.pool
	var res := lo.reservation()

	L.append("[b]RIFTWROUGHT — %s  (%s, %s) · aligned with D-378 under %s[/b]"
		% [ImprintConfig.STAGE, ImprintConfig.DECISION, ImprintConfig.DATE,
		   ImprintConfig.ALIGNMENT_DECISION])
	L.append("[color=#ffd479]STATE: %s[/color]" % ProdConfig.STATE)
	L.append("[color=#ff9b9b]DIAGNOSTIC SKILL ARCHITECTURE TEST. It does NOT finalize the Huntress "
		+ "roster, Rift Shards, slot counts, the rank cap, Capacity values, the XP curve, "
		+ "reservation values or balance.[/color]")
	L.append("[color=#9fd3ff]This panel is a DEVELOPER surface and is NOT a UI foundation.[/color]")
	L.append("")
	L.append("PAGE [b]%s[/b]  (%d of %d)    F2 hides · Up/Down (LB/RB) move focus · Enter (A) activates"
		% [PAGES[page], page + 1, PAGES.size()])
	L.append("")

	# --- THE FOCUSABLE ROWS, ON EVERY PAGE -----------------------------------
	L.append("[b]CONTROLS — explicit focus, no typed text, no drag[/b]")
	for i in ROWS.size():
		var marker := "[color=#ffd479]>[/color]" if i == focus_index else " "
		L.append("  %s %-46s %s" % [marker, ROWS[i], _row_state(i)])
	if runtime.last_trial_result != "":
		L.append("    last trial: %s" % runtime.last_trial_result)
	if last_action_result != "":
		L.append("    last action: %s" % last_action_result)
	L.append("")

	match page:
		0: _page_overview(L, lo, pool, res)
		1: _page_configurations(L, lo)
		2: _page_library(L, lib)
		3: _page_trials(L)
		4: _page_comparisons(L, lo, pool, res)
		5: _page_alignment(L, lo, pool, res)

	return "\n".join(L)

func _row_state(i: int) -> String:
	var lo := runtime.loadout
	match i:
		0:
			return "[b]%s[/b]  (+%d Capacity when ON)" % [
				"ON" if lo.gear_bonus_active else "OFF",
				ImprintConfig.CAPACITY_GEAR_BONUS_DIAGNOSTIC]
		1:
			var cfg := lo.configuration(DiagImprintContent.CFG_AURA) as SkillConfiguration
			var have: bool = cfg != null and cfg.has_modifier(DiagImprintContent.AUG_TITHE)
			# D-381: the new diagnostic cycle can take the Persistent Configuration
			# OUT of the loadout, and "MANA (base)" would then describe a
			# reservation that is not being paid. The state is read from the same
			# live function the review HUD uses.
			if runtime.reservation_state() == "OFF":
				return "[b]OFF[/b]  (no Persistent reservation — cycle with the review HUD's input)"
			return "[b]%s[/b]" % ("LIFE (Life Conversion installed — PROPORTIONAL)" if have
				else "MANA (base)")
		2:
			return "attempts %d, refusals %d" % [runtime.second_transform_attempts,
				runtime.second_transform_refusals]
		3:
			var c := lo.configuration(DiagImprintContent.CFG_VOLLEY) as SkillConfiguration
			return "Effective Rank [b]%d[/b] of a Mastered %d" % [c.skill_rank(),
				runtime.library.mastered(c.skill_id)]
		4:
			return "[b]%s[/b]   canonical verdict: %s" % [
				"ON — edits permitted in combat (DIAGNOSTIC)" if runtime.diagnostic_safe_state_override
					else "OFF — the canonical refusal applies",
				runtime.safe_state_reason()]
		5:
			return PAGES[page]
	return ""

# ------------------------------------------------------------------ pages ----

func _page_overview(L: Array[String], lo: ImprintLoadout, pool: ResourcePool,
		res: Dictionary) -> void:
	L.append("[b]BINDINGS AND EQUIPPED CONFIGURATIONS ARE DIFFERENT THINGS[/b]")
	L.append("  active input bindings      [b]%d[/b]   CANONICAL (SKILLS section 11, D-079) — never rewritten into six"
		% lo.binding_count())
	L.append("  equipped Active Configs    [b]%d[/b] of UP TO %d — ONE PER BINDING, no separate six cap   (%d binding(s) empty, and empty is valid)"
		% [lo.equipped_active_count(), lo.binding_count(), lo.empty_binding_count()])
	L.append("    [i]CURRENT WORKING BASELINE (D-378 OD-09), NOT a lock. Global Capacity limits how deeply the loadout is modified.[/i]")
	L.append("  Persistent Configurations  [b]%d[/b] — NO arbitrary slot cap: reservation, compatibility and Capacity limit them"
		% lo.active_persistent_ids().size())
	L.append("  [color=#9fd3ff]X-02 RESOLVED BY D-376: D-079's refusal of an arbitrary Persistent-slot cap stands; "
		+ "the four-slot candidate was WITHDRAWN and, under D-380, REMOVED from the runtime.[/color]")
	L.append("")
	for i in lo.bindings.size():
		var b: String = lo.bindings[i]
		if b == "":
			L.append("  binding %d   [i](empty — pressing it does nothing, and it says so)[/i]" % (i + 1))
			continue
		var cfg := lo.configuration(b) as SkillConfiguration
		var cd := runtime.cooldown_remaining(cfg.skill_id)
		var dead: String = ("  [color=#ff6666]DEACTIVATED: %s[/color]" % lo.deactivated[b]) \
			if lo.deactivated.has(b) else ""
		L.append("  binding %d   %-26s rank %2d  cost %5.1f Mana  cd %4.2f/%4.2f s  Capacity %d%s"
			% [i + 1, b, cfg.skill_rank(), float(cfg.resolve()["mana_cost"]), cd,
			   float(cfg.resolve()["cooldown"]), cfg.capacity_cost(), dead])
	L.append("")
	L.append("[b]CONFIGURATION CAPACITY[/b]   used [b]%d[/b] of [b]%d[/b]   (%d free, sustaining %d modifier slot(s))"
		% [lo.capacity_used(), lo.capacity_total(), lo.capacity_available(),
		   lo.sustained_modifier_slots()])
	for row in lo.capacity_sources():
		L.append("    %-38s %3d   %s" % [row[0], row[1], row[2]])
	L.append("    the loadout DEMANDS %d with nothing deactivated" % lo.capacity_demanded())
	for r in lo.last_report:
		L.append("    [color=#ffd479]%s[/color]" % r)
	L.append("")
	L.append("[b]RESOURCES AND RESERVATION[/b]")
	L.append("    Mana   max %6.1f   reserved [b]%6.1f[/b]   usable %6.1f   current %6.1f"
		% [pool.mana_max, pool.mana_reserved, pool.mana_usable(), pool.mana_current])
	L.append("    Life   max %6.1f   reserved [b]%6.1f[/b]   usable %6.1f"
		% [pool.life_max, pool.life_reserved, pool.life_usable()])
	L.append("    Mana regeneration [b]%.2f[/b]/s = %.1f%% x UNRESERVED maximum %.1f (max - reserved) — never current Mana (D-378 OD-05)"
		% [pool.regen_per_second(), ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S * 100.0,
		   pool.unreserved_maximum()])
	L.append("    EXACTLY ONE RESOURCE IS RESERVED, NEVER BOTH — both non-zero: [b]%s[/b]"
		% str(pool.reserves_both()))
	for row in res["rows"]:
		var conv := ""
		if String(row["resource"]) == "life":
			conv = "  = %.1f%% Mana basis x ratio %.4f — PROPORTIONAL" % [
				float(row["mana_basis"]) * 100.0, float(row["ratio"])]
		L.append("      %-24s reserves %-5s %6.1f  (%.1f%% at rank %d)%s"
			% [row["id"], String(row["resource"]).to_upper(), row["amount"],
			   float(row["fraction"]) * 100.0, row["rank"], conv])
	L.append("    the aura currently adds [b]%.0f%%[/b] to every beast's damage"
		% (runtime.aura_beast_bonus() * 100.0))
	L.append("")
	L.append("[b]LIVE ENTITIES[/b]   ballistae %d   beasts %d   orbits %d   Skill Uses %d   releases %d   uses refused %d"
		% [runtime.ballistae.size(), runtime.beasts.size(), runtime.orbits.size(),
		   runtime.skill_uses, runtime.releases, runtime.uses_refused])
	if runtime.last_refusal != "":
		L.append("    last refusal: %s" % runtime.last_refusal)
	L.append("")
	L.append("[b]DAMAGE BY SOURCE[/b]   (the bow versus the autonomous sources)")
	var led := SkillRuntime.ledger()
	var tot := SkillRuntime.ledger_total()
	if tot <= 0.0:
		L.append("    nothing dealt yet — press a binding")
	else:
		for k in ["player_direct", "ballista", "beast"]:
			L.append("    %-16s %8.1f   %5.1f%% of %.1f"
				% [k, float(led.get(k, 0.0)), 100.0 * SkillRuntime.ledger_share(k), tot])
	L.append("")
	L.append("[b]DECLARED CONFLICTS — measured, and printed rather than filed away[/b]")
	for c in ImprintConfig.declared_conflicts():
		L.append("  [color=#ff9b9b]%s[/color]  %s" % [c[0], c[1]])

func _page_configurations(L: Array[String], lo: ImprintLoadout) -> void:
	L.append("[b]THE THREE REPRESENTATIVE CONFIGURATIONS[/b]  (diagnostic content — NOT the Huntress roster)")
	for cid in DiagImprintContent.THE_THREE_REPRESENTATIVE:
		var cfg := lo.configuration(String(cid)) as SkillConfiguration
		for line in cfg.explain():
			L.append("  %s" % line)
		L.append("")
	L.append("[b]SUPPORTING CONFIGURATIONS — each exists to make a required comparison possible[/b]")
	for row in DiagImprintContent.SUPPORTING_CONFIGURATIONS:
		var cfg2 := lo.configuration(String(row[0])) as SkillConfiguration
		L.append("  [i]why: %s[/i]" % row[1])
		for line in cfg2.explain():
			L.append("  %s" % line)
		L.append("")

func _page_library(L: Array[String], lib: ImprintLibrary) -> void:
	L.append("[b]THE IMPRINT LIBRARY[/b]   %d learned · %d Skill, %d Augment, %d Transform · "
		% [lib.count(), lib.count_of_kind(Imprint.Kind.SKILL),
		   lib.count_of_kind(Imprint.Kind.AUGMENT), lib.count_of_kind(Imprint.Kind.TRANSFORM)]
		+ "character progression rank %d · %d duplicate learn(s) ignored"
		% [lib.character_progress_rank, lib.duplicate_learns_ignored])
	var at_one := 0
	for aid in lib.ids():
		var rec := lib.acquisition_record(String(aid))
		if int(rec.get("rank", -1)) == ImprintConfig.RANK_MIN and is_equal_approx(float(rec.get("xp", -1.0)), 0.0):
			at_one += 1
	L.append("  [color=#9fd3ff]D-378 OD-01: %d of %d Imprints were LEARNED at Mastered Rank 1 / 0 XP. The ranks below are "
		% [at_one, lib.count()]
		+ "DECLARED DIAGNOSTIC SEEDING (%d seeds) — a stand-in for progression already earned, NOT an acquisition floor.[/color]"
		% lib.diagnostic_seeds)
	L.append("  %-18s %-24s %-8s %-9s %-20s %s"
		% ["TYPE", "NAME", "MASTERED", "CATCH-UP", "XP PROGRESS", "RANK MOVES (beyond damage)"])
	for id in lib.ids():
		var imp := lib.get_imprint(String(id)) as Imprint
		var used_in: Array[String] = []
		for cid in DiagImprintContent.ALL_CONFIGURATIONS:
			var cfg := runtime.loadout.configuration(String(cid)) as SkillConfiguration
			if cfg != null and cfg.imprint_ids().has(String(id)):
				used_in.append(String(cid).replace("CFG_DIAG_", ""))
		L.append("  %-18s %-24s %4d/%-3d %8.2fx %7.1f / %-7.1f  %s"
			% [imp.kind_name().replace(" IMPRINT", ""), imp.display_name,
			   lib.mastered(String(id)), ImprintConfig.RANK_MAX,
			   lib.catchup_multiplier(String(id)), lib.xp(String(id)),
			   lib.xp_to_next(String(id)), str(imp.rank_moves)])
		if not used_in.is_empty():
			L.append("        used in %d Configuration(s): %s   [i]ONE mastery record, ONE XP award[/i]"
				% [used_in.size(), ", ".join(used_in)])
	L.append("")
	L.append("  [i]XP comes from AWARDED COMBAT PROGRESS (%d awards so far, %d duplicate id(s) "
		% [lib.awards, lib.last_award_collapsed]
		+ "collapsed in the last award). Button-use frequency grants NOTHING.[/i]")
	L.append("  [i]The catch-up multiplier is BOUNDED at %.1fx. An Imprint at or above the "
		% ImprintConfig.CATCHUP_MULTIPLIER_MAX
		+ "character's progression rank gets exactly 1.00x.[/i]")

func _page_trials(L: Array[String]) -> void:
	L.append("[b]COMPATIBILITY TRIALS — computed live on SCRATCH Configurations[/b]")
	L.append("  [i]They never touch the live loadout, so showing a result cannot change the build "
		+ "under review.[/i]")
	L.append("")
	for t in runtime.compatibility_trials():
		L.append("  %-58s [b]%s[/b]" % [t[0], t[1]])
		L.append("      %s" % t[2])
		L.append("")

func _page_comparisons(L: Array[String], lo: ImprintLoadout, pool: ResourcePool,
		res: Dictionary) -> void:
	L.append("[b]THE SIX COMPARISONS THE RULING ASKS FOR[/b]")
	L.append("")
	# 1 — the same Skill at low and high Effective Rank.
	var hi := lo.configuration(DiagImprintContent.CFG_VOLLEY) as SkillConfiguration
	var low := lo.configuration(DiagImprintContent.CFG_LOW) as SkillConfiguration
	var rh := hi.resolve()
	var rl := low.resolve()
	L.append("[b]1. THE SAME SKILL IMPRINT AT LOW AND HIGH EFFECTIVE RANK[/b]  (one learned Imprint, two Configurations)")
	L.append("     %-22s %-10s %-10s %-10s %-10s %s"
		% ["", "rank", "damage", "Mana", "cooldown", "projectiles"])
	L.append("     %-22s %-10d %-10.1f %-10.1f %-10.3f %d"
		% ["high", int(rh["rank"]), float(rh["damage"]), float(rh["mana_cost"]),
		   float(rh["cooldown"]), int(rh["projectiles"])])
	L.append("     %-22s %-10d %-10.1f %-10.1f %-10.3f %d"
		% ["low", int(rl["rank"]), float(rl["damage"]), float(rl["mana_cost"]),
		   float(rl["cooldown"]), int(rl["projectiles"])])
	L.append("     [i]Rank moves MORE than damage: the Mana cost and the cooldown move too. And "
		+ "both Configurations SHARE the Skill Imprint's cooldown — %.3f s remaining now.[/i]"
		% runtime.cooldown_remaining(hi.skill_id))
	L.append("")
	# 2 — a legal and an illegal second Transform.
	L.append("[b]2. A LEGAL AND AN ILLEGAL SECOND TRANSFORM[/b]")
	for t in runtime.compatibility_trials():
		if String(t[0]).begins_with("SECOND TRANSFORM") or String(t[0]).begins_with("LEGAL FIRST"):
			L.append("     %-56s [b]%s[/b]" % [t[0], t[1]])
			L.append("         %s" % t[2])
	L.append("")
	# 3 — a legal and an over-Capacity loadout.
	L.append("[b]3. A LEGAL LOADOUT AND AN OVER-CAPACITY LOADOUT[/b]")
	L.append("     with the gear bonus ON : budget %d = %d progression + %d gear"
		% [ImprintConfig.CAPACITY_FROM_PROGRESSION + ImprintConfig.CAPACITY_GEAR_BONUS_DIAGNOSTIC,
		   ImprintConfig.CAPACITY_FROM_PROGRESSION, ImprintConfig.CAPACITY_GEAR_BONUS_DIAGNOSTIC])
	L.append("     with the gear bonus OFF: budget %d, against a demand of %d"
		% [ImprintConfig.CAPACITY_FROM_PROGRESSION, lo.capacity_demanded()])
	L.append("     right now: gear is [b]%s[/b], budget %d, demand %d, used %d — %s"
		% ["ON" if lo.gear_bonus_active else "OFF", lo.capacity_total(),
		   lo.capacity_demanded(), lo.capacity_used(),
		   "LEGAL" if lo.deactivated.is_empty() else "OVER CAPACITY, and NOT left active"])
	L.append("     [i]Toggle row 1 to see it. Removing the gear bonus produces an EXPLICIT result: "
		+ "the shortfall is named and a Configuration is deactivated with its reason.[/i]")
	L.append("")
	# 4 — Mana reservation versus Life reservation.
	L.append("[b]4. MANA RESERVATION VERSUS LIFE RESERVATION[/b]  (toggle row 2)")
	L.append("     Mana reserved %6.1f of %6.1f   ·   Life reserved %6.1f of %6.1f   ·   BOTH: %s"
		% [pool.mana_reserved, pool.mana_max, pool.life_reserved, pool.life_max,
		   str(pool.reserves_both())])
	for row in res["rows"]:
		L.append("     %-24s reserves %-5s %6.1f (%.1f%%)"
			% [row["id"], String(row["resource"]).to_upper(), row["amount"],
			   float(row["fraction"]) * 100.0])
	var regen := runtime.regeneration_comparison()
	L.append("     [i]Since D-380 the conversion is PROPORTIONAL (D-378 OD-06): Life reserved = the Mana fraction the "
		+ "aura would reserve x a PROVISIONAL ratio, and there is no flat Life tithe. Regeneration runs on "
		+ "UNRESERVED maximum Mana (OD-05): %.2f/s with the aura on Mana, %.2f/s once it is converted to Life.[/i]"
		% [float(regen["aura_on_mana"]), float(regen["aura_on_life"])])
	L.append("")
	# 5 — ordinary bow damage versus autonomous beast-primary damage.
	L.append("[b]5. ORDINARY BOW DAMAGE VERSUS AUTONOMOUS BEAST-PRIMARY DAMAGE[/b]")
	var led := SkillRuntime.ledger()
	var tot := SkillRuntime.ledger_total()
	if tot <= 0.0:
		L.append("     nothing dealt yet — press binding 1 (bow) and binding 3 (beasts)")
	else:
		L.append("     bow (player_direct) %8.1f  %5.1f%%   ballista %8.1f  %5.1f%%   beasts %8.1f  %5.1f%%"
			% [float(led.get("player_direct", 0.0)), 100.0 * SkillRuntime.ledger_share("player_direct"),
			   float(led.get("ballista", 0.0)), 100.0 * SkillRuntime.ledger_share("ballista"),
			   float(led.get("beast", 0.0)), 100.0 * SkillRuntime.ledger_share("beast")])
	L.append("     beasts summoned %d · strikes %d · damage %.1f — and NO command input exists for them"
		% [DiagBeast.summoned_total, DiagBeast.strikes_total, DiagBeast.damage_total])
	L.append("")
	# 6 — reuse of one Augment without duplicated mastery or XP.
	L.append("[b]6. REUSE OF ONE AUGMENT WITHOUT DUPLICATED MASTERY OR XP[/b]")
	for aid in [DiagImprintContent.AUG_SPLIT, DiagImprintContent.AUG_TEMPERED]:
		var uses: Array[String] = []
		for cid in DiagImprintContent.ALL_CONFIGURATIONS:
			var cfg := lo.configuration(String(cid)) as SkillConfiguration
			if cfg != null and cfg.has_modifier(String(aid)):
				uses.append(String(cid).replace("CFG_DIAG_", ""))
		var imp := runtime.library.get_imprint(String(aid)) as Imprint
		L.append("     %-18s in %d Configuration(s): %-34s ONE Mastered Rank %d, ONE XP total %.1f"
			% [imp.display_name, uses.size(), ", ".join(uses),
			   runtime.library.mastered(String(aid)),
			   runtime.library.total_progress_units(String(aid))])
	L.append("     [i]The last award collapsed %d duplicate id(s) before granting anything.[/i]"
		% runtime.library.last_award_collapsed)

## ============================================================================
## THE D-378 ALIGNMENT PAGE (D-380). The map, and the aligned rules with LIVE numbers.
## ============================================================================
## Every D-378 ruling in exactly one of the four dispositions the owner named,
## and -- for each rule this stage IMPLEMENTED -- the number the running build is
## producing right now. The "up to eight" and "no Persistent slot cap" rows are
## computed on SCRATCH loadouts (`SkillRuntime.alignment_trials()`), because the
## diagnostic content holds five Active Configurations and composing more would
## be content this stage may not add. NOTHING HERE IS A LOCK.
func _page_alignment(L: Array[String], lo: ImprintLoadout, pool: ResourcePool,
		_res: Dictionary) -> void:
	L.append("[b]D-378 ALIGNMENT (%s, %s) — every ruling in ONE of four dispositions. NOTHING IS LOCKED; NO TEST CANDIDATE IS ADOPTED.[/b]"
		% [ImprintConfig.ALIGNMENT_DECISION, ImprintConfig.ALIGNMENT_DATE])
	var tally := {}
	for row in ImprintConfig.d378_alignment():
		tally[String(row[1])] = int(tally.get(String(row[1]), 0)) + 1
		L.append("  %-8s %-26s %s" % [row[0], row[1], row[2]])
	var parts: Array[String] = []
	for d in ImprintConfig.DISPOSITIONS:
		parts.append("%s %d" % [d, int(tally.get(String(d), 0))])
	L.append("  [i]%s — %d parts covering OD-01 to OD-16[/i]" % [" · ".join(parts),
		ImprintConfig.d378_alignment().size()])
	L.append("")
	L.append("[b]THE IMPLEMENTED RULES, LIVE[/b]")
	var regen := runtime.regeneration_comparison()
	L.append("  OD-05  regeneration [b]%.2f[/b]/s now = %.1f%% x UNRESERVED maximum %.1f · aura on Mana %.2f/s · converted to Life %.2f/s"
		% [pool.regen_per_second(), ImprintConfig.MANA_REGEN_FRACTION_OF_UNRESERVED_PER_S * 100.0,
		   pool.unreserved_maximum(), float(regen["aura_on_mana"]), float(regen["aura_on_life"])])
	var aura := lo.configuration(DiagImprintContent.CFG_AURA) as SkillConfiguration
	if aura != null:
		var ratio_now := SkillConfiguration.conversion_ratio_at(runtime.library.mastered(DiagImprintContent.AUG_TITHE))
		var basis := float(aura.resolve().get("reserve_fraction_mana_basis", 0.0))
		L.append("  OD-06  conversion: %.1f%% Mana basis x ratio %.4f (rank %d) = %.1f%% of maximum Life = %.1f Life · the flat Life tithe is GONE"
			% [basis * 100.0, ratio_now, runtime.library.mastered(DiagImprintContent.AUG_TITHE),
			   basis * ratio_now * 100.0, basis * ratio_now * ImprintConfig.LIFE_MAX])
	for t in runtime.alignment_trials():
		L.append("  %s — [b]%s[/b]" % [t[0], t[1]])
		L.append("      %s" % t[2])
	L.append("  OD-12  purely beneficial Augments are LEGAL: validate() no longer requires a tradeoff; a SILENT modifier is still refused")
	L.append("  OD-01  %d Imprints learned at Mastered Rank 1 / 0 XP, then %d DECLARED DIAGNOSTIC SEEDS (see IMPRINT LIBRARY)"
		% [runtime.library.count(), runtime.library.diagnostic_seeds])
	L.append("")
	L.append("[color=#ff9b9b]NOT ADOPTED — D-378 TEST CANDIDATES: ~25 % unequipped XP · ~3 % floor · ~2x ratio · milestone Capacity · 24 / 30-36 Capacity bands.[/color]")
