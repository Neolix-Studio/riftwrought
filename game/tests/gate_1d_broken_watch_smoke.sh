#!/usr/bin/env bash
# Riftwrought — First-MVP Gate 1D smoke checks: Broken Watch Combat & Loot Slice.
#
# Gate 1D (D-217) is the first playable combat-and-equipment portion of The
# Severed Threshold: Riftfall Landing's accepted Greybox V2 + Visual Review
# foundation, one new authored space (Broken Watch), the reused Prototype Zero
# combat kernel wired by composition, production per-use mouse targeting, one
# guaranteed weapon improvement, and the smallest truthful pickup/compare/equip
# flow. It does not build the Nexus Threshold, and it does not touch a single
# closed-gate file.
#
# PROPORTIONAL VERIFICATION, PER THE GATE 1D BRIEF: this does not re-derive or
# repeat the inherited chain's own hundreds of assertions. It runs that chain
# ONCE (step 1) and trusts its own pinned counts, then adds only what the
# chain cannot know — that Gate 1D's own new scene, kernel wiring, and asset
# usage are correct.
#
# THE LOCKED CHAIN RUNS FIRST AND STOPS EVERYTHING ON ANY REGRESSION.
# `gate_1c_riftfall_landing_smoke.sh` runs the whole ladder back to Gate A.
#
# IT NEVER TOUCHES THE PROJECT OWNER'S OWN SAVED STATE. Broken Watch writes no
# save and no settings file — it constructs neither `PrototypeSettings` nor
# `PrototypeLabState` and is never loaded through `PrototypeApp`. This script
# also fingerprints the two real files before and after the whole run.
#
# AUTOMATED CHECKS CANNOT ANSWER THE GOVERNING QUESTIONS, AND THAT IS THE
# POINT. Whether Quick Strike feels satisfying, whether the Graveblade reads,
# whether the drop feels meaningful, and whether the power increase is
# perceptible are for the project owner's own mouse-and-controller playtest.
# See docs/testing/FIRST_MVP_GATE_1D_BROKEN_WATCH_REPORT.md.
#
# Usage, from the repository root:
#   game/tests/gate_1d_broken_watch_smoke.sh

set -uo pipefail

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_DIR="$(cd "$PROJECT_DIR/.." && pwd)"
SLICE_SCENE="res://scenes/first_mvp/severed_threshold/broken_watch_slice.tscn"
APP_SCENE="res://scenes/app/prototype_app.tscn"

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

# This suite's own count, pinned from the first passing frozen-tree run and
# proved in BOTH directions below, exactly as every prior gate's runner pins
# its own.
EXPECTED_GATE_1D=129

# §4: the third-party inventory Gate 1D must not move. It extracts nothing —
# every dressing piece it places is read from the two already-accepted asset
# records (RiftfallLandingLayout.payload() and approved_environment_palette.gd)
# and every model it reaches for was already on disk under D-215 or D-216.
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

# Three steps, not one: the first digit in "GATE 1D VERIFICATION" is the 1 of
# "1D", so bare-digit extraction from the whole line would read 1.
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

printf 'Riftwrought — First-MVP Gate 1D smoke checks (Broken Watch Combat & Loot Slice)\n'
printf 'project: %s\n' "$PROJECT_DIR"

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
printf '  production settings before: %s\n' "$production_settings_before"
printf '  production lab state before: %s\n' "$production_lab_before"

step "1. The complete locked chain (Gate 1C -> 1B -> 1A -> F -> E -> D -> C -> B -> A)"
if bash "$PROJECT_DIR/tests/gate_1c_riftfall_landing_smoke.sh" \
	> /tmp/riftwrought_gate_1d_chain.log 2>&1; then
	pass "gate_1c_riftfall_landing_smoke.sh still passes with Gate 1D present"
else
	fail "the inherited chain regressed"
	grep -E "FAIL" /tmp/riftwrought_gate_1d_chain.log | head -20 | sed 's/^/        /'
fi
check_chain_row /tmp/riftwrought_gate_1d_chain.log "Gate B" "$EXPECTED_GATE_B"
check_chain_row /tmp/riftwrought_gate_1d_chain.log "Gate C" "$EXPECTED_GATE_C"
check_chain_row /tmp/riftwrought_gate_1d_chain.log "Gate D" "$EXPECTED_GATE_D"
check_chain_row /tmp/riftwrought_gate_1d_chain.log "Gate E" "$EXPECTED_GATE_E"
check_chain_row /tmp/riftwrought_gate_1d_chain.log "Gate F" "$EXPECTED_GATE_F"
check_chain_row /tmp/riftwrought_gate_1d_chain.log "Gate 1A" "$EXPECTED_GATE_1A"
check_chain_row /tmp/riftwrought_gate_1d_chain.log "Gate 1B" "$EXPECTED_GATE_1B"
# TWO DIFFERENT LOG SHAPES AT TWO DIFFERENT REMOVES, and conflating them is a
# documented past bug in this project's own runners (see gate_1c_riftfall_landing_smoke.sh's
# own comment on this exact distinction). Gate 1C's own step 6 prints the
# COHESION verification's raw "LABEL: PASS (N checks)" line to ITS OWN stdout via
# a bare grep, one hop from cohesion — but Gate 1C's own step 1 reads Gate B
# through Gate 1B via `check_count`, which never re-prints THEIR raw lines, only
# ITS OWN wrapped "PASS <label> <N> checks, unchanged" summary. So from Gate 1D's
# remove (one hop further out than Gate 1C's), the COHESION line has already been
# wrapped once and needs `check_chain_row`, exactly like Gate B..1B below it —
# while GATE 1C VERIFICATION's own raw line is still one hop fresh and stays a
# `check_count`.
check_chain_row /tmp/riftwrought_gate_1d_chain.log "GATE 1B COHESION VERIFICATION" "$EXPECTED_COHESION"
check_count /tmp/riftwrought_gate_1d_chain.log "GATE 1C VERIFICATION" "$EXPECTED_GATE_1C"

step "2. Broken Watch imports, parses, and boots headlessly"
if "$GODOT" --headless --path "$PROJECT_DIR" --import > /tmp/riftwrought_gate_1d_import.log 2>&1; then
	pass "the project imports with Gate 1D's scenes and scripts present"
else
	fail "the headless import failed"
	tail -20 /tmp/riftwrought_gate_1d_import.log | sed 's/^/        /'
fi
for script in "$PROJECT_DIR"/scripts/first_mvp/severed_threshold/broken_watch_layout.gd \
	"$PROJECT_DIR"/scripts/first_mvp/severed_threshold/broken_watch_slice.gd \
	"$PROJECT_DIR"/scripts/items/player_loadout.gd \
	"$PROJECT_DIR"/scripts/items/first_mvp_item_drop.gd \
	"$PROJECT_DIR"/scripts/ui/first_mvp_modal.gd \
	"$PROJECT_DIR"/scripts/ui/first_mvp_item_comparison.gd \
	"$PROJECT_DIR"/scripts/ui/first_mvp_fallen_overlay.gd \
	"$PROJECT_DIR"/scripts/ui/first_mvp_combat_hud.gd \
	"$PROJECT_DIR"/tests/gate_1d_broken_watch_verification.gd; do
	rel="${script#"$PROJECT_DIR"/}"
	"$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$rel" \
		> /tmp/riftwrought_gate_1d_parse.log 2>&1
	if grep -qE "Parse Error|Compile Error|Failed to load script" /tmp/riftwrought_gate_1d_parse.log; then
		fail "$rel does not parse"
		tail -10 /tmp/riftwrought_gate_1d_parse.log | sed 's/^/        /'
	else
		pass "$rel"
	fi
done
if "$GODOT" --headless --path "$PROJECT_DIR" "$SLICE_SCENE" --quit-after 150 \
	> /tmp/riftwrought_gate_1d_scene.log 2>&1; then
	assert_no_script_error "broken_watch_slice.tscn" /tmp/riftwrought_gate_1d_scene.log
else
	fail "broken_watch_slice.tscn does not start"
	tail -20 /tmp/riftwrought_gate_1d_scene.log | sed 's/^/        /'
fi

step "3. Gate 1D added no third-party asset"
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
	pass "the third-party inventory is unchanged at $EXPECTED_THIRD_PARTY; every Broken Watch
        dressing piece is read from the D-215/D-216 accepted records, none extracted new"
else
	fail "the third-party inventory moved to $third_party_count"
fi
input_actions="$(awk '/^\[input\]/{f=1;next} /^\[/{f=0} f && /^[a-zA-Z_]+=\{/{c++} END{print c+0}' \
	"$PROJECT_DIR/project.godot")"
if [[ "$input_actions" == "$EXPECTED_INPUT_ACTIONS" ]]; then
	pass "InputMap still declares exactly $EXPECTED_INPUT_ACTIONS actions; Gate 1D added none"
else
	fail "InputMap declares $input_actions actions, not the locked $EXPECTED_INPUT_ACTIONS"
fi
if grep -q '^\[autoload\]' "$PROJECT_DIR/project.godot"; then
	fail "an [autoload] section exists; Gate 1D must add none"
else
	pass "no [autoload] section exists"
fi

step "4. Gate 1D verification (headless, isolated, non-writing)"
if "$GODOT" --headless --path "$PROJECT_DIR" "$SLICE_SCENE" -- --verify-1d \
	> /tmp/riftwrought_gate_1d_verify.log 2>&1; then
	:
fi
assert_no_script_error "the headless Gate 1D verification" /tmp/riftwrought_gate_1d_verify.log

assert_gate_1d_count() {
	local logfile="$1" expected="${2:-$EXPECTED_GATE_1D}" found
	found="$(count_from "$logfile" "GATE 1D VERIFICATION")"
	[[ -n "$found" && "$found" == "$expected" ]]
}
# Proved in BOTH directions against a replay of this run's own log: a guard
# that accepts everything protects nothing.
gate_1d_replay="$(mktemp -t riftwrought_gate_1d_pin_replay)"
trap 'rm -f "$gate_1d_replay"' EXIT
sed "s/GATE 1D VERIFICATION: PASS ($EXPECTED_GATE_1D checks)/GATE 1D VERIFICATION: PASS ($((EXPECTED_GATE_1D + 1)) checks)/" \
	/tmp/riftwrought_gate_1d_verify.log > "$gate_1d_replay"
if assert_gate_1d_count "$gate_1d_replay"; then
	fail "the $EXPECTED_GATE_1D pin accepted a replayed log reporting $((EXPECTED_GATE_1D + 1)) checks"
else
	pass "the pin rejects an altered replayed count ($((EXPECTED_GATE_1D + 1)) is refused)"
fi
if assert_gate_1d_count /tmp/riftwrought_gate_1d_verify.log; then
	grep -E "GATE 1D VERIFICATION: PASS" /tmp/riftwrought_gate_1d_verify.log | sed 's/^/  /'
	pass "the assembled slice, Landing's preserved foundation, Broken Watch's own
        structure, the one continuous navigation bake, the reused combat kernel,
        per-use mouse targeting, unmodified controller targeting, the first
        encounter and guaranteed drop, idempotent ownership, the comparison and
        equip flow, the second unscaled encounter, Fallen and Restart, the exit
        boundary, and every excluded system's absence"
else
	fail "the Gate 1D verification did not pass at $EXPECTED_GATE_1D checks"
	grep -E "FAIL:|VERIFICATION" /tmp/riftwrought_gate_1d_verify.log | sed 's/^/        /' || true
	tail -20 /tmp/riftwrought_gate_1d_verify.log | sed 's/^/        /'
fi

step "5. Gate 1D writes nothing, and the storage guard still refuses production"
settings_mid="$(state_fingerprint "$production_settings")"
lab_mid="$(state_fingerprint "$production_lab")"
if [[ "$settings_mid" == "$production_settings_before" && "$lab_mid" == "$production_lab_before" ]]; then
	pass "the production files are unchanged after every run above"
else
	fail "a run above changed the project owner's own files"
	printf '        settings before %s\n        settings after  %s\n' \
		"$production_settings_before" "$settings_mid"
	printf '        lab before      %s\n        lab after       %s\n' \
		"$production_lab_before" "$lab_mid"
fi
if "$GODOT" --headless --path "$PROJECT_DIR" -- --check-state-dir --state-dir "$production_dir" \
	> /tmp/riftwrought_gate_1d_guard.log 2>&1; then
	fail "the storage guard accepted the production directory"
else
	if grep -qE "refusing to start|own user data directory" /tmp/riftwrought_gate_1d_guard.log; then
		pass "the D-192 guard still refuses the production directory, without writing"
	else
		fail "the storage guard did not report a refusal"
		tail -10 /tmp/riftwrought_gate_1d_guard.log | sed 's/^/        /'
	fi
fi

step "6. Excluded systems remain absent"
# D-219 REPLACES TWO OF THESE ONE FOR ONE. Gate 1E is authorized and delivered,
# so "no Gate 1E specification or report exists" became false BY AUTHORIZATION and
# the boundary moves to the next milestone. Note the exact filenames: the two rows
# this replaces named `FIRST_MVP_GATE_1E_SPECIFICATION.md` and
# `FIRST_MVP_GATE_1E_REPORT.md`, which are NOT the names Gate 1E actually uses —
# left as they were they would have kept passing for the wrong reason, the same
# accident that let Gate 1C's `FIRST_MVP_GATE_1D_SPECIFICATION.md` row survive
# D-217 untouched. Neither `pass` nor `fail` is a verification check, so no pinned
# count moves.
for absent in "$REPO_DIR/design/FIRST_MVP_GATE_1F_FIRST_FOOTING_SPECIFICATION.md" \
	"$REPO_DIR/docs/testing/FIRST_MVP_GATE_1F_FIRST_FOOTING_REPORT.md" \
	"$REPO_DIR/docs/testing/FIRST_MVP_VERTICAL_SLICE_REPORT.md"; do
	if [[ -f "$absent" ]]; then
		fail "$(basename "$absent") exists; that work is not authorized"
	else
		pass "$(basename "$absent") does not exist"
	fi
done
for present in "$REPO_DIR/design/FIRST_MVP_GATE_1D_BROKEN_WATCH_COMBAT_AND_LOOT_SLICE_SPECIFICATION.md" \
	"$REPO_DIR/docs/testing/FIRST_MVP_GATE_1D_BROKEN_WATCH_REPORT.md" \
	"$REPO_DIR/design/FIRST_MVP_GATE_1E_NEXUS_THRESHOLD_AND_THE_NEXUS_ANSWERS_SPECIFICATION.md" \
	"$REPO_DIR/docs/testing/FIRST_MVP_GATE_1E_NEXUS_THRESHOLD_REPORT.md"; do
	if [[ -f "$present" ]]; then
		pass "$(basename "$present") exists"
	else
		fail "$(basename "$present") is missing; D-217/D-219 require it"
	fi
done

printf '\n'
if [[ "$failures" -eq 0 ]]; then
	printf 'GATE 1D SMOKE CHECKS: PASS\n'
	cat <<'NOTE'
Automated checks can prove structure, navigation, kernel reuse, targeting
discipline, the reward door's idempotence, and the exit boundary. They cannot
answer the questions Gate 1D exists to ask: does this feel like the beginning
of an ARPG, is Quick Strike satisfying, is the Graveblade readable, does the
drop feel meaningful, is the power increase obvious, and do mouse and
controller both feel natural? GATE 1D REMAINS OPEN. Only the project owner can
decide that, with mouse and controller, per
docs/testing/FIRST_MVP_GATE_1D_BROKEN_WATCH_REPORT.md.
No result here authorizes the Nexus Threshold, the Rift Nexus, the wider
Severed Threshold route beyond Broken Watch, Mara, dialogue, the Foundation
Cache, the Passive Web, Rift Shards, Rift Echo, Augments, the Forge, random
loot tables, procedural generation, saves, final UI, final VFX, or final audio.
NOTE
	exit 0
else
	printf 'GATE 1D SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	exit 1
fi
