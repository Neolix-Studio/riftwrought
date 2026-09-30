#!/usr/bin/env bash
# Riftwrought — First-MVP Gate 1E smoke checks: Nexus Threshold & The Nexus Answers.
#
# Gate 1E (D-219) completes the canonical opening: Riftfall Landing -> Broken
# Watch -> Nexus Threshold -> the Rift Nexus, with a character who owns Level,
# XP, Passive points, Skills and equipment and who survives quitting. It adds
# two authored spaces, the Anchor's recognition beat, Mara Veyl, the first
# conversation, the first guaranteed milestone Passive point, the Riftmarked
# Origin Ring, the Foundation Cache, the three Foundation Skills, and a versioned
# local character save. It stops at a visibly closed route toward First Footing.
#
# PROPORTIONAL VERIFICATION, PER THE GATE 1E BRIEF: "Use focused verification
# during implementation. Do not repeatedly rerun the complete archaeological
# gate ladder. When the tree is frozen, run the inherited regression chain once
# plus focused Gate 1E verification." That is exactly this script's shape — the
# chain runs ONCE in step 1 and is trusted at its own pinned counts.
#
# IT NEVER TOUCHES THE PROJECT OWNER'S OWN SAVED STATE. The canonical opening
# writes a THIRD file, `user://riftwrought_character.cfg`, and every run here is
# handed an isolated `--state-dir` under `mktemp -d`. The two Prototype Zero
# files are fingerprinted before and after the whole run, and `CharacterSave`'s
# refusal of both is proved inside the engine in both directions.
#
# AUTOMATED CHECKS CANNOT ANSWER THE GOVERNING QUESTIONS, AND THAT IS THE POINT.
# Whether the Nexus feels like a payoff, whether Mara feels grounded, whether the
# first Passive point is exciting, whether the Origin Ring is understandable, and
# whether the three Foundation directions are immediately distinguishable are for
# the project owner's own mouse-and-controller playtest.
# See docs/testing/FIRST_MVP_GATE_1E_NEXUS_THRESHOLD_REPORT.md.
#
# Usage, from the repository root:
#   game/tests/gate_1e_canonical_opening_smoke.sh

set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_DIR="$(cd "$PROJECT_DIR/.." && pwd)"
OPENING_SCENE="res://scenes/first_mvp/canonical_opening/canonical_opening.tscn"
PRACTICE_SCENE="res://scenes/first_mvp/canonical_opening/foundation_skill_practice.tscn"

# The inherited locked ladder, read back out of the chain's own output.
EXPECTED_GATE_B=106
EXPECTED_GATE_C=209
EXPECTED_GATE_D=230
EXPECTED_GATE_E=713
EXPECTED_GATE_F=1008
EXPECTED_GATE_1A=284
EXPECTED_GATE_1B=678
EXPECTED_COHESION=613
EXPECTED_GATE_1C=200
EXPECTED_GATE_1D=129

# This suite's own two counts, pinned from the first passing frozen-tree run and
# proved in BOTH directions below, exactly as every prior gate's runner pins its
# own. A guard that accepts everything protects nothing.
EXPECTED_GATE_1E=557
EXPECTED_GATE_1E_SKILLS=102

# §21: Gate 1E extracted nothing. Every dressing piece both new layouts place is
# read from the two already-accepted asset records, and the placeholder weapon
# and NPC presentations are project-authored primitive geometry and an existing
# rig — no new asset search, no new pack, no new extraction.
EXPECTED_THIRD_PARTY_PAYLOADS=185
EXPECTED_THIRD_PARTY=187
EXPECTED_INPUT_ACTIONS=31

failures=0
pass() { printf '  PASS  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; failures=$((failures + 1)); }
step() { printf '\n=== %s\n' "$1"; }

# A run that reports PASS while a script error scrolled past is not a pass
# (D-201's lesson, kept alive in every runner since).
assert_no_script_error() {
	local what="$1" logfile="$2" found
	found="$(grep -c "SCRIPT ERROR" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$found" == "0" ]]; then
		pass "$what produced no SCRIPT ERROR"
	else
		fail "$what produced $found SCRIPT ERROR line(s)"
		grep -A3 "SCRIPT ERROR" "$logfile" | head -20 | sed 's/^/        /'
	fi
}

# Three steps, not one: the first digit in "GATE 1E VERIFICATION" is the 1 of
# "1E", so bare-digit extraction from the whole line would read 1.
count_from() {
	local logfile="$1" label="$2"
	grep -ohE "$label: PASS \([0-9]+ checks\)" "$logfile" 2>/dev/null \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

check_count() {
	local logfile="$1" label="$2" expected="$3" found
	found="$(count_from "$logfile" "$label")"
	if [[ -n "$found" && "$found" == "$expected" ]]; then
		pass "$label  $expected checks, unchanged"
	else
		fail "$label reported '${found:-nothing}', not the locked $expected"
	fi
}

check_chain_row() {
	local logfile="$1" label="$2" expected="$3"
	if grep -qE "PASS +${label}[[:space:]]+${expected} checks, unchanged" "$logfile"; then
		pass "$label  $expected checks, unchanged (via the inherited chain)"
	else
		fail "the chain did not report $label at the locked $expected"
		grep -E "PASS +${label}" "$logfile" | head -2 | sed 's/^/        /' || true
	fi
}

project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
production_settings="$production_dir/prototype_settings.cfg"
production_lab="$production_dir/prototype_zero.cfg"
production_character="$production_dir/riftwrought_character.cfg"

state_fingerprint() {
	if [[ -f "$1" ]]; then
		printf '%s bytes, sha256 %s, mtime %s' \
			"$(wc -c < "$1" | tr -d ' ')" \
			"$(shasum -a 256 "$1" | cut -d' ' -f1)" \
			"$(stat -f %m "$1")"
	else
		printf 'absent'
	fi
}

STATE_DIR="$(mktemp -d -t riftwrought_gate_1e_state)"
trap 'rm -rf "$STATE_DIR"' EXIT

printf 'Riftwrought — First-MVP Gate 1E smoke checks (Nexus Threshold & The Nexus Answers)\n'
printf 'project: %s\n' "$PROJECT_DIR"
printf 'isolated character storage: %s\n' "$STATE_DIR"

step "0. Engine baseline and the project owner's own files"
installed="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$installed"
if [[ "$installed" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION, found $installed"
fi
production_settings_before="$(state_fingerprint "$production_settings")"
production_lab_before="$(state_fingerprint "$production_lab")"
production_character_before="$(state_fingerprint "$production_character")"
printf '  production settings before:  %s\n' "$production_settings_before"
printf '  production lab state before: %s\n' "$production_lab_before"
printf '  production character before: %s\n' "$production_character_before"

step "1. The complete locked chain (Gate 1D -> 1C -> 1B -> 1A -> F -> E -> D -> C -> B -> A)"
if bash "$PROJECT_DIR/tests/gate_1d_broken_watch_smoke.sh" \
	> /tmp/riftwrought_gate_1e_chain.log 2>&1; then
	pass "gate_1d_broken_watch_smoke.sh still passes with Gate 1E present"
else
	fail "the inherited chain regressed"
	grep -E "FAIL" /tmp/riftwrought_gate_1e_chain.log | head -20 | sed 's/^/        /'
fi
# TWO LOG SHAPES AT TWO REMOVES, and conflating them is a documented past bug in
# this project's own runners. Gate 1D prints its OWN wrapped "PASS <label> <N>
# checks, unchanged" summary for everything it read through the chain, and its
# own raw "GATE 1D VERIFICATION: PASS (N checks)" line for itself. From Gate 1E's
# remove, everything Gate 1D wrapped needs `check_chain_row`, while Gate 1D's own
# raw line is still one hop fresh and stays a `check_count`.
check_chain_row /tmp/riftwrought_gate_1e_chain.log "Gate B" "$EXPECTED_GATE_B"
check_chain_row /tmp/riftwrought_gate_1e_chain.log "Gate C" "$EXPECTED_GATE_C"
check_chain_row /tmp/riftwrought_gate_1e_chain.log "Gate D" "$EXPECTED_GATE_D"
check_chain_row /tmp/riftwrought_gate_1e_chain.log "Gate E" "$EXPECTED_GATE_E"
check_chain_row /tmp/riftwrought_gate_1e_chain.log "Gate F" "$EXPECTED_GATE_F"
check_chain_row /tmp/riftwrought_gate_1e_chain.log "Gate 1A" "$EXPECTED_GATE_1A"
check_chain_row /tmp/riftwrought_gate_1e_chain.log "Gate 1B" "$EXPECTED_GATE_1B"
check_chain_row /tmp/riftwrought_gate_1e_chain.log "GATE 1B COHESION VERIFICATION" "$EXPECTED_COHESION"
check_chain_row /tmp/riftwrought_gate_1e_chain.log "GATE 1C VERIFICATION" "$EXPECTED_GATE_1C"
check_count /tmp/riftwrought_gate_1e_chain.log "GATE 1D VERIFICATION" "$EXPECTED_GATE_1D"

step "2. The canonical opening imports, parses, and boots headlessly"
if "$GODOT" --headless --path "$PROJECT_DIR" --import > /tmp/riftwrought_gate_1e_import.log 2>&1; then
	pass "the project imports with Gate 1E's scenes, scripts and data present"
else
	fail "the headless import failed"
	tail -20 /tmp/riftwrought_gate_1e_import.log | sed 's/^/        /'
fi
for script in \
	"$PROJECT_DIR"/scripts/passives/passive_node_data.gd \
	"$PROJECT_DIR"/scripts/passives/passive_graph.gd \
	"$PROJECT_DIR"/scripts/passives/passive_effects.gd \
	"$PROJECT_DIR"/scripts/passives/passive_allocation.gd \
	"$PROJECT_DIR"/scripts/character/experience_table.gd \
	"$PROJECT_DIR"/scripts/character/character_state.gd \
	"$PROJECT_DIR"/scripts/character/character_save.gd \
	"$PROJECT_DIR"/scripts/items/first_mvp_weapon_record.gd \
	"$PROJECT_DIR"/scripts/items/first_mvp_equipment.gd \
	"$PROJECT_DIR"/scripts/combat/first_mvp_damage_event.gd \
	"$PROJECT_DIR"/scripts/skills/first_mvp_skill_data.gd \
	"$PROJECT_DIR"/scripts/skills/first_mvp_skill_action.gd \
	"$PROJECT_DIR"/scripts/skills/first_mvp_skill_projectile.gd \
	"$PROJECT_DIR"/scripts/skills/first_mvp_active_bindings.gd \
	"$PROJECT_DIR"/scripts/skills/first_mvp_skill_library.gd \
	"$PROJECT_DIR"/scripts/first_mvp/severed_threshold/nexus_threshold_layout.gd \
	"$PROJECT_DIR"/scripts/first_mvp/nexus/rift_nexus_layout.gd \
	"$PROJECT_DIR"/scripts/first_mvp/nexus/rift_anchor.gd \
	"$PROJECT_DIR"/scripts/first_mvp/nexus/mara_veyl.gd \
	"$PROJECT_DIR"/scripts/first_mvp/nexus/first_mvp_dialogue.gd \
	"$PROJECT_DIR"/scripts/first_mvp/canonical_opening/canonical_opening_runtime.gd \
	"$PROJECT_DIR"/scripts/first_mvp/canonical_opening/foundation_skill_practice.gd \
	"$PROJECT_DIR"/scripts/ui/canonical_opening_hud.gd \
	"$PROJECT_DIR"/scripts/ui/nexus_dialogue_panel.gd \
	"$PROJECT_DIR"/scripts/ui/origin_ring_panel.gd \
	"$PROJECT_DIR"/scripts/ui/foundation_cache_panel.gd \
	"$PROJECT_DIR"/tests/gate_1e_canonical_opening_verification.gd \
	"$PROJECT_DIR"/tests/gate_1e_foundation_skills_verification.gd; do
	rel="${script#"$PROJECT_DIR"/}"
	"$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$rel" \
		> /tmp/riftwrought_gate_1e_parse.log 2>&1
	if grep -qE "Parse Error|Compile Error|Failed to load script" /tmp/riftwrought_gate_1e_parse.log; then
		fail "$rel does not parse"
		tail -10 /tmp/riftwrought_gate_1e_parse.log | sed 's/^/        /'
	else
		pass "$rel"
	fi
done
if "$GODOT" --headless --path "$PROJECT_DIR" "$OPENING_SCENE" --quit-after 180 \
	-- --state-dir "$STATE_DIR" --start-fresh > /tmp/riftwrought_gate_1e_scene.log 2>&1; then
	assert_no_script_error "canonical_opening.tscn" /tmp/riftwrought_gate_1e_scene.log
else
	fail "canonical_opening.tscn does not start"
	tail -20 /tmp/riftwrought_gate_1e_scene.log | sed 's/^/        /'
fi
if "$GODOT" --headless --path "$PROJECT_DIR" "$PRACTICE_SCENE" --quit-after 150 \
	> /tmp/riftwrought_gate_1e_practice_boot.log 2>&1; then
	assert_no_script_error "foundation_skill_practice.tscn" /tmp/riftwrought_gate_1e_practice_boot.log
else
	fail "foundation_skill_practice.tscn does not start"
	tail -20 /tmp/riftwrought_gate_1e_practice_boot.log | sed 's/^/        /'
fi

step "3. Gate 1E added no third-party asset and no InputMap action"
third_party_payloads="$(find "$PROJECT_DIR/assets/third_party" -type f \
	! -name '*.import' ! -name '.DS_Store' ! -name '*.md' | wc -l | tr -d ' ')"
d202_source_maps=0
for note in "$PROJECT_DIR/assets/third_party/kenney/SOURCE_AND_LICENSE.md" \
	"$PROJECT_DIR/assets/third_party/quaternius/SOURCE_AND_LICENSE.md"; do
	[[ -f "$note" ]] && d202_source_maps=$((d202_source_maps + 1))
done
third_party_count=$((third_party_payloads + d202_source_maps))
printf '  %s payload files + %s source maps = %s (authorized: %s + 2 = %s)\n' \
	"$third_party_payloads" "$d202_source_maps" "$third_party_count" \
	"$EXPECTED_THIRD_PARTY_PAYLOADS" "$EXPECTED_THIRD_PARTY"
if [[ "$third_party_payloads" == "$EXPECTED_THIRD_PARTY_PAYLOADS" \
	&& "$third_party_count" == "$EXPECTED_THIRD_PARTY" ]]; then
	pass "the third-party inventory is unchanged at $EXPECTED_THIRD_PARTY; both new layouts read
        every path from the D-215/D-216 accepted records, and no NPC or weapon asset was added"
else
	fail "the third-party inventory moved to $third_party_count"
fi
input_actions="$(awk '/^\[input\]/{f=1;next} /^\[/{f=0} f && /^[a-zA-Z_]+=\{/{c++} END{print c+0}' \
	"$PROJECT_DIR/project.godot")"
if [[ "$input_actions" == "$EXPECTED_INPUT_ACTIONS" ]]; then
	pass "InputMap still declares exactly $EXPECTED_INPUT_ACTIONS actions; Gate 1E added none"
else
	fail "InputMap declares $input_actions actions, not the locked $EXPECTED_INPUT_ACTIONS"
fi
if grep -q '^\[autoload\]' "$PROJECT_DIR/project.godot"; then
	fail "an [autoload] section exists; Gate 1E must add none"
else
	pass "no [autoload] section exists"
fi
main_scene="$(sed -n 's/^run\/main_scene="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
if [[ "$main_scene" == "res://scenes/app/prototype_app.tscn" ]]; then
	pass "the project entrypoint is still the Prototype App; the first MVP did not take it over"
else
	fail "the project entrypoint moved to $main_scene"
fi

step "4. The stray Riftfall_Landing.tscn is gone and unreferenced (D-218)"
if [[ -e "$PROJECT_DIR/scenes/first_mvp/Riftfall_Landing.tscn" ]]; then
	fail "the stray capital-R Riftfall_Landing.tscn still exists"
else
	pass "game/scenes/first_mvp/Riftfall_Landing.tscn no longer exists"
fi
# THIS GUARD CAUGHT ITS OWN AUTHOR, exactly as the Zone Composer's addon scan did
# under D-215. Scanning the whole project for the UID matched THIS FILE, because
# the line below has to name the UID in order to look for it. The scan is
# therefore narrowed to the three trees plus the one file where a real reference
# could actually live — a scene, a script, a resource, or the project file — none
# of which can legitimately name a deleted scene. `tests/` is deliberately
# excluded, and the exclusion is a statement about where references live rather
# than a convenience: a runner naming a UID in a grep is not a reference to it.
stray_refs="$(grep -rl "587ujeyew07x" \
	"$PROJECT_DIR/scenes" "$PROJECT_DIR/scripts" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/project.godot" 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$stray_refs" == "0" ]]; then
	pass "its UID uid://587ujeyew07x is named by no scene, script, resource or project entry"
else
	fail "$stray_refs file(s) still reference the deleted scene's UID"
	grep -rl "587ujeyew07x" \
		"$PROJECT_DIR/scenes" "$PROJECT_DIR/scripts" "$PROJECT_DIR/data" \
		"$PROJECT_DIR/project.godot" 2>/dev/null | sed 's/^/        /'
fi

step "5. Gate 1E verification (headless, isolated storage)"
if "$GODOT" --headless --path "$PROJECT_DIR" "$OPENING_SCENE" \
	-- --verify-1e --state-dir "$STATE_DIR" --start-fresh \
	> /tmp/riftwrought_gate_1e_verify.log 2>&1; then
	:
fi
assert_no_script_error "the headless Gate 1E verification" /tmp/riftwrought_gate_1e_verify.log

assert_gate_1e_count() {
	local logfile="$1" expected="${2:-$EXPECTED_GATE_1E}" found
	found="$(count_from "$logfile" "GATE 1E VERIFICATION")"
	[[ -n "$found" && "$found" == "$expected" ]]
}
# Proved in BOTH directions against a replay of this run's own log.
gate_1e_replay="$(mktemp -t riftwrought_gate_1e_pin_replay)"
trap 'rm -f "$gate_1e_replay"; rm -rf "$STATE_DIR"' EXIT
sed "s/GATE 1E VERIFICATION: PASS ($EXPECTED_GATE_1E checks)/GATE 1E VERIFICATION: PASS ($((EXPECTED_GATE_1E + 1)) checks)/" \
	/tmp/riftwrought_gate_1e_verify.log > "$gate_1e_replay"
if assert_gate_1e_count "$gate_1e_replay"; then
	fail "the $EXPECTED_GATE_1E pin accepted a replayed log reporting $((EXPECTED_GATE_1E + 1)) checks"
else
	pass "the pin rejects an altered replayed count ($((EXPECTED_GATE_1E + 1)) is refused)"
fi
if assert_gate_1e_count /tmp/riftwrought_gate_1e_verify.log; then
	grep -E "GATE 1E VERIFICATION: PASS" /tmp/riftwrought_gate_1e_verify.log | sed 's/^/  /'
	pass "the integrated opening, Gate 1D preserved, one continuous navigation mesh across
        four spaces, the Nexus Threshold's shape, the Rift Nexus shell, the safe region,
        Mara past the danger, recognition once and before explanation, the four-fact
        conversation, the one milestone Passive point, the Origin Ring graph and its
        allocation, preview and free refund, the honesty condition, the Foundation Cache's
        three options and single grant, non-duplicating experience, the save round trip,
        the storage refusal, the First Footing boundary, every excluded system's absence,
        and Prototype Zero unchanged"
else
	fail "the Gate 1E verification did not pass at $EXPECTED_GATE_1E checks"
	grep -E "FAIL:|VERIFICATION" /tmp/riftwrought_gate_1e_verify.log | sed 's/^/        /' || true
	tail -20 /tmp/riftwrought_gate_1e_verify.log | sed 's/^/        /'
fi

step "6. The three Foundation Skills (developer-only practice range)"
if "$GODOT" --headless --path "$PROJECT_DIR" "$PRACTICE_SCENE" --quit-after 5000 \
	-- --verify-skills > /tmp/riftwrought_gate_1e_skills.log 2>&1; then
	:
fi
assert_no_script_error "the Foundation Skills verification" /tmp/riftwrought_gate_1e_skills.log

assert_skills_count() {
	local logfile="$1" expected="${2:-$EXPECTED_GATE_1E_SKILLS}" found
	found="$(count_from "$logfile" "GATE 1E SKILLS VERIFICATION")"
	[[ -n "$found" && "$found" == "$expected" ]]
}
skills_replay="$(mktemp -t riftwrought_gate_1e_skills_replay)"
trap 'rm -f "$gate_1e_replay" "$skills_replay"; rm -rf "$STATE_DIR"' EXIT
sed "s/GATE 1E SKILLS VERIFICATION: PASS ($EXPECTED_GATE_1E_SKILLS checks)/GATE 1E SKILLS VERIFICATION: PASS ($((EXPECTED_GATE_1E_SKILLS + 1)) checks)/" \
	/tmp/riftwrought_gate_1e_skills.log > "$skills_replay"
if assert_skills_count "$skills_replay"; then
	fail "the $EXPECTED_GATE_1E_SKILLS pin accepted a replayed log reporting $((EXPECTED_GATE_1E_SKILLS + 1)) checks"
else
	pass "the pin rejects an altered replayed count ($((EXPECTED_GATE_1E_SKILLS + 1)) is refused)"
fi
if assert_skills_count /tmp/riftwrought_gate_1e_skills.log; then
	grep -E "GATE 1E SKILLS VERIFICATION: PASS" /tmp/riftwrought_gate_1e_skills.log | sed 's/^/  /'
	pass "three canonical records, ONE shared Skill machine, truthful weapon requirements,
        Faultbreaker's Area Hit, Splinter Shot's single projectile, Emberbolt's
        weapon-independent Fire, the refused single-target archetype, the cost and cancel
        rules, and three private runtime records"
else
	fail "the Foundation Skills verification did not pass at $EXPECTED_GATE_1E_SKILLS checks"
	grep -E "FAIL:|VERIFICATION" /tmp/riftwrought_gate_1e_skills.log | sed 's/^/        /' || true
fi

step "7. Nothing reached the project owner's own files"
settings_after="$(state_fingerprint "$production_settings")"
lab_after="$(state_fingerprint "$production_lab")"
character_after="$(state_fingerprint "$production_character")"
if [[ "$settings_after" == "$production_settings_before" \
	&& "$lab_after" == "$production_lab_before" \
	&& "$character_after" == "$production_character_before" ]]; then
	pass "all three production files are unchanged after every run above"
else
	fail "a run above changed one of the project owner's own files"
	printf '        settings  before %s\n        settings  after  %s\n' \
		"$production_settings_before" "$settings_after"
	printf '        lab       before %s\n        lab       after  %s\n' \
		"$production_lab_before" "$lab_after"
	printf '        character before %s\n        character after  %s\n' \
		"$production_character_before" "$character_after"
fi
# The isolated directory really was used, so the absence above is not an absence
# proved about the wrong place. A guard that could never fire is not a guard.
if [[ -f "$STATE_DIR/riftwrought_character.cfg" ]]; then
	pass "the isolated character file was genuinely written ($(wc -c < "$STATE_DIR/riftwrought_character.cfg" | tr -d ' ') bytes)"
else
	fail "no character file was written to the isolated directory; the storage checks proved nothing"
fi
if "$GODOT" --headless --path "$PROJECT_DIR" -- --check-state-dir --state-dir "$production_dir" \
	> /tmp/riftwrought_gate_1e_guard.log 2>&1; then
	fail "the storage guard accepted the production directory"
else
	if grep -qE "refusing to start|own user data directory" /tmp/riftwrought_gate_1e_guard.log; then
		pass "the D-192 guard still refuses the production directory, without writing"
	else
		fail "the storage guard did not report a refusal"
		tail -10 /tmp/riftwrought_gate_1e_guard.log | sed 's/^/        /'
	fi
fi

step "8. The next milestone remains unstarted"
for absent in "$REPO_DIR/design/FIRST_MVP_GATE_1F_FIRST_FOOTING_SPECIFICATION.md" \
	"$REPO_DIR/docs/testing/FIRST_MVP_GATE_1F_FIRST_FOOTING_REPORT.md" \
	"$REPO_DIR/docs/testing/FIRST_MVP_VERTICAL_SLICE_REPORT.md" \
	"$PROJECT_DIR/scripts/first_mvp/first_footing.gd" \
	"$PROJECT_DIR/scenes/first_mvp/first_footing.tscn" \
	"$PROJECT_DIR/scripts/first_mvp/run_graph.gd" \
	"$PROJECT_DIR/scripts/first_mvp/module_library.gd"; do
	if [[ -e "$absent" ]]; then
		fail "$(basename "$absent") exists; that work is not authorized"
	else
		pass "$(basename "$absent") does not exist"
	fi
done
for present in "$REPO_DIR/design/FIRST_MVP_GATE_1E_NEXUS_THRESHOLD_AND_THE_NEXUS_ANSWERS_SPECIFICATION.md" \
	"$REPO_DIR/docs/testing/FIRST_MVP_GATE_1E_NEXUS_THRESHOLD_REPORT.md"; do
	if [[ -f "$present" ]]; then
		pass "$(basename "$present") exists"
	else
		fail "$(basename "$present") is missing; D-219 requires it"
	fi
done

printf '\n'
if [[ "$failures" -eq 0 ]]; then
	printf 'GATE 1E SMOKE CHECKS: PASS\n'
	cat <<'NOTE'
Automated checks can prove that the four spaces are one continuous walkable
composition, that the Nexus beats fire once and in order, that the Origin Ring
and the Foundation Cache obey their rules, that nothing duplicates through a
reload, and that every excluded system is absent. They cannot answer the
questions Gate 1E exists to ask: does arriving in the Nexus feel like a real
payoff, does Mara feel grounded rather than like an exposition machine, does the
Nexus reaction make the Mark feel important without declaring the character
chosen, is the first Passive point exciting, is the Origin Ring understandable,
does free respecialization feel safe, are the three Foundation directions
immediately distinguishable, does the Cache make it completely clear the choice
is only what to explore first, does loading back into the character feel
trustworthy, and at the First Footing exit do you want to go and try the new
Skill? GATE 1E REMAINS OPEN. Only the project owner can decide that, with mouse
and controller, per
docs/testing/FIRST_MVP_GATE_1E_NEXUS_THRESHOLD_REPORT.md.
No result here authorizes First Footing, Marrowshot, Rift Step, Rift Shards,
Rift Echo, Shaping, Augments, the Shaping Board, the full 66-node Passive Web,
attribute clusters, Keystones, the Forge, crafting, Run Assembly, Pursuits,
Distortions, Rift Intensity, procedural generation, the Vault, the Reliquary,
the full Wrought Archive, additional NPCs, cinematics, voice acting, full
character creation, a second character or profile interface, random loot,
random affixes, ailments, a broad control system, new enemy types, another
environment-art pass, new map tooling, or a new asset search.
NOTE
	exit 0
else
	printf 'GATE 1E SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	exit 1
fi
