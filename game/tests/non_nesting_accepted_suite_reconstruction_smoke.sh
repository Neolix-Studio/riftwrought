#!/usr/bin/env bash
# Riftwrought — Verification Maintenance V1: Non-Nesting Accepted-Suite Reconstruction smoke checks (decision D-342).
#
# THIS IS NOT A GATE, AND IT RUNS NO LOCKED CHAIN AND NO ACCEPTED SUITE. IT IS HEADLESS ONLY: IT HAS NO RENDERED
# MODE AND OPENS NO WINDOW.
#
# D-342 moved every pair list the accepted suites J4 to J10 carried as string constants — each cascade had
# copied the previous ones, escaped once more, into the next — into one flat, content-addressed store under
# tests/provenance/, read by one engine there. No production file moved. What this script proves:
#
#   1. the engine, the new verification and the seven migrated verifications parse, and this runner and the
#      six migrated runners pass `bash -n`;
#   2. the engine, the store, the new verification and all twenty accepted J-suite files are at their D-342
#      hashes, each pin refusing a file with one byte appended; the store directory holds exactly the engine and
#      the store; every production file is unchanged — one digest over every file under scripts/, scenes/,
#      data/, addons/ and assets/ and project.godot, every `.DS_Store` pruned — and J9's and J10's accepted
#      production walks, re-made exactly as their runners make them, still give the digests those runners pin;
#      and this runner and the six migrated runners are executable;
#   3. the pinned verification passes headless, proved in BOTH directions against a replay of its own log — its
#      check count, its owed count, the exact owed SET and this run's own token — with the measured lines read
#      out of the log; zero SCRIPT ERROR, zero engine ERROR and zero engine WARNING; and the synthetic files its
#      dry run wrote into this run's temporary directory are gone;
#   4. `project.godot` is untouched: 31 actions, the Prototype App entrypoint, the same nine sections, no
#      `[autoload]`;
#   5. every protected file, the whole `.godot/` directory, every production file and every evidence frame under
#      docs/testing/ are BYTE-IDENTICAL across the run, the project owner's own user:// files are untouched, and
#      Godot's own user://logs/ did not move;
#   6. this run's temporary directory is gone and no other one is left behind.
#
# Everything this script writes goes into one `mktemp -d` directory, removed on every exit — Godot's own file log
# for every invocation included. Every walk this script makes prunes `.DS_Store`, and none reaches the
# repository's `assets/` directory.
#
# Usage, from the repository root:
#   game/tests/non_nesting_accepted_suite_reconstruction_smoke.sh

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves.
RUN_STARTED_AT="$(date +%s)"
RUN_TOKEN="vm1-${RUN_STARTED_AT}-$$-${RANDOM}"

reached_end=0
scratch=()
on_exit() {
	local code=$?
	for path in "${scratch[@]+"${scratch[@]}"}"; do
		rm -rf "$path"
	done
	if [[ "$reached_end" != "1" ]]; then
		printf '\nNON-NESTING ACCEPTED-SUITE RECONSTRUCTION SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMP_ROOT="${TMPDIR:-/tmp}"
TEMP_ROOT="${TEMP_ROOT%/}"
TEMP_STEM="riftwrought_vm1"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=23
EXPECTED_OWED_CHECKS=13
OWED_SET="the_engine_and_the_store_are_at_their_pinned_hashes_and_nothing_else_is_stored, the_store_parses_canonically_and_every_record_is_what_it_names, the_reference_and_version_graphs_are_acyclic, every_record_is_accounted_for_and_every_pinned_name_resolves, the_thirteen_migrated_files_rebuild_to_their_d341_bytes, every_promised_historical_version_rebuilds_byte_for_byte, no_accepted_suite_embeds_another_suites_body_or_nests_pairs, one_byte_mutation_and_truncation_are_refused, missing_duplicated_reordered_and_misnamed_records_are_refused, a_wrong_target_path_pin_or_engine_is_refused, the_production_walks_and_the_legacy_exception_are_unchanged, every_accepted_suite_keeps_its_assertions_verdict_permissions_and_run_mode, a_synthetic_one_line_change_grows_the_store_by_its_delta_alone"
VERIFICATION_TIMEOUT=600

EXPECTED_INPUT_ACTIONS=31
EXPECTED_MAIN_SCENE="res://scenes/app/prototype_app.tscn"
EXPECTED_SECTIONS="application audio debug display editor_plugins input layer_names navigation rendering"

# Every production file, as D-341 left it and D-342 did not touch: files under scripts/, scenes/, data/, addons/ and
# assets/ and project.godot, every `.DS_Store` pruned, each line `sha256  path`, sorted, digested.
EXPECTED_PRODUCTION_FILES=864
EXPECTED_PRODUCTION_DIGEST="770fc7a255dc75f94a45026d749cfdccc2f072aac50ab8ec4b3c48255e0de42d"

THIS_VERIFICATION="tests/non_nesting_accepted_suite_reconstruction_verification.gd"
THIS_SMOKE="tests/non_nesting_accepted_suite_reconstruction_smoke.sh"
ENGINE="tests/provenance/accepted_suite_provenance.gd"
STORE="tests/provenance/d342_accepted_suite_history.provenance"
# First-MVP Gameplay J11 (decision D-344) added a second, immutable store file beside the first.
STORE_J11="tests/provenance/d344_gate_1d_route_continuity.provenance"
PROVENANCE_DIR="tests/provenance"
SLICE="scripts/first_mvp/severed_threshold/broken_watch_slice.gd"
LAYOUT="scripts/first_mvp/severed_threshold/broken_watch_layout.gd"
J1_VERIFICATION="tests/first_mvp_modal_left_click_verification.gd"
J1_SMOKE="tests/first_mvp_modal_left_click_smoke.sh"
J2_VERIFICATION="tests/fallen_modal_life_state_verification.gd"
J2_SMOKE="tests/fallen_modal_life_state_smoke.sh"
J3_VERIFICATION="tests/pending_fallen_restart_verification.gd"
J3_SMOKE="tests/pending_fallen_restart_smoke.sh"
J4_VERIFICATION="tests/fallen_delay_item_interaction_verification.gd"
J4_SMOKE="tests/fallen_delay_item_interaction_smoke.sh"
J5_VERIFICATION="tests/fallen_delay_drop_highlight_verification.gd"
J5_SMOKE="tests/fallen_delay_drop_highlight_smoke.sh"
J6_VERIFICATION="tests/combat_hud_fractional_fill_verification.gd"
J6_SMOKE="tests/combat_hud_fractional_fill_smoke.sh"
J7_VERIFICATION="tests/enemy_hover_life_fractional_fill_verification.gd"
J7_SMOKE="tests/enemy_hover_life_fractional_fill_smoke.sh"
J8_VERIFICATION="tests/combat_hud_safe_bottom_placement_verification.gd"
J8_SMOKE="tests/combat_hud_safe_bottom_placement_smoke.sh"
J9_VERIFICATION="tests/guaranteed_drop_defeated_enemy_binding_verification.gd"
J9_SMOKE="tests/guaranteed_drop_defeated_enemy_binding_smoke.sh"
J10_VERIFICATION="tests/restart_position_stability_verification.gd"
J10_SMOKE="tests/restart_position_stability_smoke.sh"

# The engine, the store, this runner's own verification and the twenty accepted J-suite files, at their D-342
# hashes: the thirteen D-342 migrated at their new ones, the seven it left alone at their D-341 ones.
# First-MVP Gameplay J11 (D-344) moved this runner's rows again, one for one, when Gate 1D's slice came to open Riftfall Landing's Watch Breach far cap in its own composition.
D342_ROWS=(
	"$ENGINE|fadbdfeb"
	"$STORE|3b38ca4d"
	"$STORE_J11|0ab807ed"
	"$THIS_VERIFICATION|03c174ad"
	"$J1_VERIFICATION|d12ad271"
	"$J1_SMOKE|977c05bd"
	"$J2_VERIFICATION|72e39a8a"
	"$J2_SMOKE|9e0977fb"
	"$J3_VERIFICATION|7d0e3f08"
	"$J3_SMOKE|54a4464a"
	"$J4_VERIFICATION|8aad4262"
	"$J4_SMOKE|939d9b48"
	"$J5_VERIFICATION|beb94aa0"
	"$J5_SMOKE|6f792a38"
	"$J6_VERIFICATION|8c653002"
	"$J6_SMOKE|51d64a23"
	"$J7_VERIFICATION|bf92c1ec"
	"$J7_SMOKE|64a84a9d"
	"$J8_VERIFICATION|2ca75553"
	"$J8_SMOKE|f562e165"
	"$J9_VERIFICATION|aaa9e1d3"
	"$J9_SMOKE|94b5e6c9"
	"$J10_VERIFICATION|1588cff8"
	"$J10_SMOKE|34db74ce"
)
MIGRATED_VERIFICATIONS=("$J4_VERIFICATION" "$J5_VERIFICATION" "$J6_VERIFICATION" "$J7_VERIFICATION" "$J8_VERIFICATION" "$J9_VERIFICATION" "$J10_VERIFICATION")
MIGRATED_RUNNERS=("$J5_SMOKE" "$J6_SMOKE" "$J7_SMOKE" "$J8_SMOKE" "$J9_SMOKE" "$J10_SMOKE")

# Fingerprinted before and after the run: everything the rows name, the production files the migrated suites
# read, the project owner's composed zone, and the two handoff documents.
PRESERVED_FILES=(
	"$ENGINE"
	"$STORE"
	"$STORE_J11"
	"$THIS_VERIFICATION"
	"$J1_VERIFICATION" "$J1_SMOKE" "$J2_VERIFICATION" "$J2_SMOKE" "$J3_VERIFICATION" "$J3_SMOKE"
	"$J4_VERIFICATION" "$J4_SMOKE" "$J5_VERIFICATION" "$J5_SMOKE" "$J6_VERIFICATION" "$J6_SMOKE"
	"$J7_VERIFICATION" "$J7_SMOKE" "$J8_VERIFICATION" "$J8_SMOKE" "$J9_VERIFICATION" "$J9_SMOKE"
	"$J10_VERIFICATION" "$J10_SMOKE"
	"$SLICE"
	"$LAYOUT"
	"scripts/ui/first_mvp_combat_hud.gd"
	"project.godot"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"../CLAUDE.md"
	"../README.md"
)

failures=0
step() { printf '\n=== %s\n' "$1"; }
pass() { printf '  PASS  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; failures=$((failures + 1)); }

fingerprint() {
	if [[ -f "$1" ]]; then
		shasum -a 256 "$1" | awk '{print $1}'
	else
		echo "MISSING"
	fi
}

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

# Every file in a directory by name, size and modification time, or "absent"; `.DS_Store` pruned.
directory_listing() {
	if [[ -d "$1" ]]; then
		(cd "$1" && find . -type f ! -name .DS_Store -print0 | sort -z | xargs -0 stat -f '%N %z %m')
	else
		printf 'absent'
	fi
}

godot_fingerprint() {
	(cd "$PROJECT_DIR" && find .godot -type f ! -name .DS_Store -print0 | sort -z | xargs -0 shasum -a 256 | shasum -a 256 | cut -d' ' -f1)
}
godot_file_count() {
	find "$PROJECT_DIR/.godot" -type f ! -name .DS_Store | wc -l | tr -d ' '
}

# Every evidence frame and report under docs/testing/, by path and content, every `.DS_Store` pruned.
evidence_fingerprint() {
	(cd "$PROJECT_DIR/../docs/testing" && find . -type f ! -name .DS_Store -print0 | sort -z | xargs -0 shasum -a 256 | shasum -a 256 | cut -d' ' -f1)
}
evidence_file_count() {
	find "$PROJECT_DIR/../docs/testing" -type f ! -name .DS_Store | wc -l | tr -d ' '
}

# Every production file, by path and content, every `.DS_Store` pruned.
production_listing() {
	(cd "$PROJECT_DIR" && find scripts scenes data addons assets project.godot -type f ! -name .DS_Store -print0 \
		| sort -z | xargs -0 shasum -a 256)
}

# J9's and J10's accepted production walks, exactly as their own runners make them.
j9_walk() {
	(cd "$PROJECT_DIR" && find scripts scenes data addons assets project.godot -type f ! -name .DS_Store ! -path "$SLICE" -print0 \
		| sort -z | xargs -0 shasum -a 256)
}
j10_walk() {
	(cd "$PROJECT_DIR" && find scripts scenes data addons assets project.godot -type f ! -name .DS_Store ! -path "$SLICE" ! -path "$LAYOUT" -print0 \
		| sort -z | xargs -0 shasum -a 256)
}
pinned_digest() {
	sed -n 's/^EXPECTED_PRODUCTION_DIGEST="\([0-9a-f]*\)"$/\1/p' "$PROJECT_DIR/$1" | tail -1
}
pinned_count() {
	sed -n 's/^EXPECTED_PRODUCTION_FILES=\([0-9]*\)$/\1/p' "$PROJECT_DIR/$1" | tail -1
}

leftover_count() {
	find "$TEMP_ROOT" -maxdepth 1 -name "$TEMP_STEM.*" 2>/dev/null | wc -l | tr -d ' '
}

assert_no_script_error() {
	local what="$1" logfile="$2" found
	found="$(grep -cE "SCRIPT ERROR|String formatting error|Parse Error" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$found" == "0" ]]; then
		pass "$what produced no SCRIPT ERROR"
	else
		fail "$what produced $found script error line(s)"
		grep -A3 -E "SCRIPT ERROR|String formatting error|Parse Error" "$logfile" | head -20 | sed 's/^/        /'
	fi
}

# Engine ERROR and WARNING lines are both refused outright: this verification loads no scene, so not even the
# accepted navigation bake's two precision lines may appear.
assert_engine_output() {
	local what="$1" logfile="$2" errors warnings
	errors="$(grep -cE "^ERROR:" "$logfile" 2>/dev/null | tr -d ' ')"
	warnings="$(grep -cE "^WARNING:" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$errors" == "0" && "$warnings" == "0" ]]; then
		pass "$what produced no engine ERROR and no engine WARNING"
	else
		fail "$what produced $errors engine ERROR line(s) and $warnings WARNING line(s)"
		grep -A2 -E "^(ERROR|WARNING):" "$logfile" | head -20 | sed 's/^/        /'
	fi
}

assert_log_is_fresh() {
	local logfile="$1" written
	if [[ ! -f "$logfile" ]]; then
		fail "$logfile was never written"
		return
	fi
	written="$(stat -f %m "$logfile" 2>/dev/null || echo 0)"
	if [[ "$written" -ge "$RUN_STARTED_AT" ]]; then
		pass "$(basename "$logfile") was written by THIS run"
	else
		fail "$(basename "$logfile") is older than this run — a stale log answered for it"
	fi
}

# The verification prints the token this run handed it; a log from any other run carries another one.
assert_run_token() {
	local logfile="$1" replay="$2"
	if grep -qxF "  run token: $RUN_TOKEN" "$logfile"; then
		pass "$(basename "$logfile") carries this run's own token $RUN_TOKEN"
	else
		fail "$(basename "$logfile") does not carry this run's token — it was not written for this run"
	fi
	sed "s/  run token: $RUN_TOKEN/  run token: ${RUN_TOKEN}0/" "$logfile" > "$replay"
	if ! grep -qxF "  run token: $RUN_TOKEN" "$replay" && grep -qE "^  run token: " "$replay"; then
		pass "and that pin refuses a replay of the same log carrying another run's token"
	else
		fail "the token pin accepts another run's log and therefore proves nothing"
	fi
}

read_check_count() {
	grep -ohE "$1: PASS \([0-9]+ checks\)" "$2" \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

run_verification() {
	local logfile="$1"
	shift
	perl -e 'alarm shift; exec @ARGV' "$VERIFICATION_TIMEOUT" "$GODOT" "$@" > "$logfile" 2>&1
}

BANNER="NON-NESTING ACCEPTED-SUITE RECONSTRUCTION VERIFICATION"

# Counted BEFORE this run makes its own.
stale_before="$(leftover_count)"

work="$(mktemp -d -t "$TEMP_STEM")"
scratch+=("$work")

printf 'Riftwrought — Verification Maintenance V1: Non-Nesting Accepted-Suite Reconstruction smoke checks (D-342)\n'
printf 'project: %s\n' "$PROJECT_DIR"
printf 'run token: %s\n' "$RUN_TOKEN"
printf 'headless only — this runner has no rendered mode and opens no window\n'

# --------------------------------------------------------------------------
step "0. Engine, leftovers, and a fingerprint of everything this work must not disturb"

installed="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$installed"
if [[ "$installed" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION, found $installed"
fi

if [[ "$stale_before" == "0" ]]; then
	pass "no temporary directory of this runner was left behind by an earlier run"
else
	fail "$stale_before temporary director(y/ies) of this runner from an earlier run remain in $TEMP_ROOT — remove them"
	find "$TEMP_ROOT" -maxdepth 1 -name "$TEMP_STEM.*" | sed 's/^/        /'
fi

declare -a BEFORE_HASHES
missing_preserved=0
for i in "${!PRESERVED_FILES[@]}"; do
	BEFORE_HASHES[$i]="$(fingerprint "$PROJECT_DIR/${PRESERVED_FILES[$i]}")"
	if [[ "${BEFORE_HASHES[$i]}" == "MISSING" ]]; then
		fail "protected file ${PRESERVED_FILES[$i]} does not exist"
		missing_preserved=$((missing_preserved + 1))
	fi
done
if [[ "$missing_preserved" == "0" ]]; then
	pass "${#PRESERVED_FILES[@]} protected file(s) fingerprinted"
fi

godot_before="$(godot_fingerprint)"
godot_count_before="$(godot_file_count)"
pass ".godot/ fingerprinted: $godot_count_before files"
evidence_before="$(evidence_fingerprint)"
evidence_count_before="$(evidence_file_count)"
pass "docs/testing/ fingerprinted: $evidence_count_before evidence frames and reports (.DS_Store pruned)"

project_name="$(sed -n 's/^config\/name="\(.*\)"[[:space:]]*$/\1/p' "$PROJECT_DIR/project.godot" | head -1)"
production_dir="$HOME/Library/Application Support/Godot/app_userdata/$project_name"
settings_before="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_before="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_before="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
logs_before="$(directory_listing "$production_dir/logs")"
pass "the project owner's own three user:// files and Godot's user://logs/ listing fingerprinted"

# --------------------------------------------------------------------------
step "1. The engine, the verification and the migrated verifications parse; this runner and the migrated runners pass bash -n"

for relative in "$ENGINE" "$THIS_VERIFICATION" "${MIGRATED_VERIFICATIONS[@]}"; do
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --log-file "$work/parse.log" --check-only --script "res://$relative" 2>&1 \
		| grep -v '^Godot Engine')"
	if [[ -z "$out" ]]; then
		pass "$relative parses"
	else
		fail "$relative does not parse"
		printf '%s\n' "$out" | head -10 | sed 's/^/        /'
	fi
done
for relative in "$THIS_SMOKE" "${MIGRATED_RUNNERS[@]}"; do
	if bash -n "$PROJECT_DIR/$relative" 2>"$work/bash_n.txt"; then
		pass "$relative passes bash -n"
	else
		fail "$relative fails bash -n"
		head -5 "$work/bash_n.txt" | sed 's/^/        /'
	fi
done

# --------------------------------------------------------------------------
step "2. The engine, the store, the verification and the twenty accepted J-suite files are at their D-342 hashes; no production file moved"

for row in "${D342_ROWS[@]}"; do
	relative="${row%%|*}"
	prefix="${row##*|}"
	actual="$(fingerprint "$PROJECT_DIR/$relative")"
	moved="$({ cat "$PROJECT_DIR/$relative"; printf 'x'; } | shasum -a 256 | cut -d' ' -f1)"
	if [[ "$actual" == "$prefix"* && "$moved" != "$prefix"* ]]; then
		pass "$relative is at $prefix, and the pin refuses the file with one byte appended (${moved:0:8})"
	else
		fail "$relative is at ${actual:0:8}, not $prefix (or its pin accepts a moved file: ${moved:0:8})"
	fi
done

stored="$(cd "$PROJECT_DIR/$PROVENANCE_DIR" && find . -mindepth 1 ! -name .DS_Store | sort | tr '\n' ' ' | sed 's/ $//')"
if [[ "$stored" == "./$(basename "$ENGINE") ./$(basename "$STORE") ./$(basename "$STORE_J11")" ]]; then
	pass "$PROVENANCE_DIR/ holds exactly the engine and the two store files (.DS_Store pruned)"
else
	fail "$PROVENANCE_DIR/ holds: $stored"
fi

listing="$work/production.txt"
production_listing > "$listing"
production_files="$(wc -l < "$listing" | tr -d ' ')"
production_digest="$(shasum -a 256 < "$listing" | cut -d' ' -f1)"
if [[ "$production_files" == "$EXPECTED_PRODUCTION_FILES" && "$production_digest" == "$EXPECTED_PRODUCTION_DIGEST" ]]; then
	pass "every production file is as D-341 left it: $production_files files, digest ${production_digest:0:8}"
else
	fail "the production tree moved: $production_files files, digest ${production_digest:0:8}, not $EXPECTED_PRODUCTION_FILES / ${EXPECTED_PRODUCTION_DIGEST:0:8}"
fi
moved_digest="$(sed '1s/$/x/' "$listing" | shasum -a 256 | cut -d' ' -f1)"
if [[ "$moved_digest" != "$EXPECTED_PRODUCTION_DIGEST" && "$moved_digest" != "$production_digest" ]]; then
	pass "and that pin refuses a listing with one line moved (${moved_digest:0:8})"
else
	fail "the production pin accepts a moved listing and therefore proves nothing"
fi

j9_listing="$work/j9_walk.txt"
j9_walk > "$j9_listing"
j9_files="$(wc -l < "$j9_listing" | tr -d ' ')"
j9_digest="$(shasum -a 256 < "$j9_listing" | cut -d' ' -f1)"
if [[ "$j9_files" == "$(pinned_count "$J9_SMOKE")" && "$j9_digest" == "$(pinned_digest "$J9_SMOKE")" ]]; then
	pass "J9's accepted production walk, re-made as its runner makes it, still gives $j9_files files and ${j9_digest:0:8}, the values that runner pins"
else
	fail "J9's accepted production walk gives $j9_files files and ${j9_digest:0:8}, not the $(pinned_count "$J9_SMOKE") / $(pinned_digest "$J9_SMOKE") its runner pins"
fi
j10_listing="$work/j10_walk.txt"
j10_walk > "$j10_listing"
j10_files="$(wc -l < "$j10_listing" | tr -d ' ')"
j10_digest="$(shasum -a 256 < "$j10_listing" | cut -d' ' -f1)"
if [[ "$j10_files" == "$(pinned_count "$J10_SMOKE")" && "$j10_digest" == "$(pinned_digest "$J10_SMOKE")" ]]; then
	pass "J10's accepted production walk, re-made as its runner makes it, still gives $j10_files files and ${j10_digest:0:8}, the values that runner pins"
else
	fail "J10's accepted production walk gives $j10_files files and ${j10_digest:0:8}, not the $(pinned_count "$J10_SMOKE") / $(pinned_digest "$J10_SMOKE") its runner pins"
fi
printf '  the four legacy runners walk .DS_Store files under D-338; this script does not re-make their walks, and its verification proves their walk and digest lines are D-341'"'"'s\n'

for runner in "$THIS_SMOKE" "${MIGRATED_RUNNERS[@]}"; do
	if [[ -x "$PROJECT_DIR/$runner" ]]; then
		pass "$runner is executable"
	else
		fail "$runner is not executable"
	fi
done

# --------------------------------------------------------------------------
step "3. The pinned verification passes headless, proved in BOTH directions"

mkdir -p "$work/scratch"
verify_log="$work/verify.log"
run_verification "$verify_log" --headless --path "$PROJECT_DIR" --log-file "$work/godot_file.log" \
	--script "res://$THIS_VERIFICATION" -- --run-token "$RUN_TOKEN" --scratch "$work/scratch"
verify_status=$?
printf '  verification exit status: %s\n' "$verify_status"
assert_log_is_fresh "$verify_log"
assert_run_token "$verify_log" "$work/token_replay.log"
assert_no_script_error "the headless verification" "$verify_log"
assert_engine_output "the headless verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
elif [[ "$verify_status" == "142" ]]; then
	fail "the verification did not finish within $VERIFICATION_TIMEOUT s and was killed"
else
	fail "the verification exited $verify_status"
	grep -E "FAIL:" "$verify_log" | head -25 | cut -c1-400 | sed 's/^/        /'
fi

if [[ -z "$(ls -A "$work/scratch" 2>/dev/null)" ]]; then
	pass "the verification's synthetic dry run removed every file it wrote to this run's temporary directory"
else
	fail "the synthetic dry run left files behind: $(ls -A "$work/scratch" | tr '\n' ' ')"
fi

count="$(read_check_count "$BANNER" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: each pin must refuse a replay of this run's own log with its
# value moved, and must READ the moved value.
replay="$work/replay.log"
sed "s/$BANNER: PASS ($EXPECTED_CHECKS checks)/$BANNER: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "$BANNER" "$replay")"
if [[ -z "$count" ]]; then
	fail "the verification printed no count line, so the count pin proves nothing this run"
elif [[ "$replay_count" == "$((EXPECTED_CHECKS + 1))" && "$replay_count" != "$EXPECTED_CHECKS" ]]; then
	pass "and that pin reads a log whose count moved by one as $replay_count, refusing it"
else
	fail "the count pin read '${replay_count:-nothing}' from a moved log and therefore proves nothing"
fi

owed_line="  $EXPECTED_OWED_CHECKS of $EXPECTED_OWED_CHECKS owed checks completed"
if grep -qxF "$owed_line" "$verify_log"; then
	pass "all $EXPECTED_OWED_CHECKS owed checks reached their last line"
else
	fail "the owed-count report is missing or short"
	grep -E "owed checks" "$verify_log" | sed 's/^/        /'
fi
sed "s/$owed_line/  $((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS owed checks completed/" "$verify_log" > "$replay"
if ! grep -qxF "$owed_line" "$replay" && grep -qxF "  $((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS owed checks completed" "$replay"; then
	pass "and that pin refuses a replay reporting $((EXPECTED_OWED_CHECKS - 1)) of $EXPECTED_OWED_CHECKS"
else
	fail "the owed-count pin accepts a short replay and therefore proves nothing"
fi

# The owed SET, name for name and in order: this script's own list against the one the run printed.
set_line="  completed: $OWED_SET"
set_names="$(printf '%s' "$OWED_SET" | tr ',' '\n' | sed 's/^ //' | grep -c .)"
if [[ "$set_names" == "$EXPECTED_OWED_CHECKS" ]] && grep -qxF "$set_line" "$verify_log"; then
	pass "the run completed exactly the $set_names owed checks this script names, in order"
else
	fail "the completed set differs from the $set_names names this script owes"
	grep -E "^  completed:" "$verify_log" | cut -c1-200 | sed 's/^/        /'
fi
first_name="${OWED_SET%%, *}"
sed "s/  completed: $first_name, /  completed: /" "$verify_log" > "$replay"
if ! grep -qxF "$set_line" "$replay" && grep -qE "^  completed: " "$replay"; then
	pass "and that pin refuses a replay whose set lacks $first_name"
else
	fail "the owed-set pin accepts a replay missing a name and therefore proves nothing"
fi

# The measurements this work exists to make, read out of the run's own log.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the engine is at fadbdfeb, 20280 bytes; 2 store file(s): d342_accepted_suite_history.provenance at 3b38ca4d, 412215 bytes, d344_gate_1d_route_continuity.provenance at 0ab807ed, 83610 bytes
res://tests/provenance/ holds exactly the engine and 2 store file(s) (.DS_Store pruned), and no directory
the 7 migrated verifications pin that engine by SHA-256 and resolve nothing without it; J1's, J2's and J3's pin none
737 texts, 104 pair lists and 165 edges, every one hashing to its name; 281951 literal bytes, 381 whole pair lists written as one `%` line each and 13 texts as one `&` line each
parsed and re-serialised, each of the 2 store file(s) is its own bytes: the format is canonical
the reference graph is acyclic: the deepest text reaches 8 levels of references, each a line of its own, never an escaped copy
the version graph is acyclic: 132 file states over 22 files, the longest chain 8 steps, every step putting back an older decision than the one before it
the migrated verifications pin 334 pair lists by SHA-256 (102 distinct), each stored and applied by an edge to the very file it names; the other 2 are D-342's put-backs for J10's verification and runner, which no accepted suite reads and this suite pins
every one of the 104 stored pair lists is pinned, and every stored text belongs to a pair list or a reference: nothing in the store is unaccounted for
put back, the 13 are byte for byte 5c8e9b07, dceea6f9, b1b456bd, f7144aac, 6cf22e7d, 0b816f06, 0dbde2d8, b709813c, 900c8d9e, ae964685, 1f2a43b1, 51108a47, 20b7a562 (53 replaced blocks, each unique when its turn comes)
together they were 6646434 bytes at D-341 and are 1007903 now
all 165 edges hold from the live files: every one of the 132 stored states rebuilds, byte for byte, from the file as it stands
81 reads of the migrated suites replayed through their own layers — D-342's first — and their own pinned prefixes, each ending at the SHA-256 that suite pins
J3's three reads replayed through the pairs it still carries inline: the slice, J1 and J2 are, byte for byte, e6bbb174, 2606fd80 and d78c5ae1
history: broken_watch_slice.gd: now d4e839fb, D-344 put back 883ef25e, D-340 put back 942aee83, D-338 put back f83e9436, D-330 put back c204a087
history: first_mvp_combat_hud.gd: now ee485029, D-336 put back 38c485cb, D-334 put back aff939f3
history: combat_hud_fractional_fill_smoke.sh: now 51d64a23, D-344 put back be9f6f47, D-342 put back 6cf22e7d, D-340 put back a444af4b, D-338 put back a5744db6, D-336 put back 1c2f1d12, D-334 put back d69585af
history: combat_hud_fractional_fill_verification.gd: now 8c653002, D-344 put back d23c5fdc, D-342 put back f7144aac, D-340 put back d38624c8, D-338 put back 333c1674, D-336 put back 423858a2, D-334 put back c5a873fd
history: combat_hud_safe_bottom_placement_smoke.sh: now f562e165, D-344 put back 95506b40, D-342 put back 900c8d9e, D-340 put back 8c13aa43, D-338 put back cc7e665a
history: combat_hud_safe_bottom_placement_verification.gd: now 2ca75553, D-344 put back bfab962c, D-342 put back b709813c, D-340 put back c980d240, D-338 put back 117ab87b
history: enemy_hover_life_fractional_fill_smoke.sh: now 64a84a9d, D-344 put back 85a49a22, D-342 put back 0dbde2d8, D-340 put back 22a95042, D-338 put back 5aa1ec83, D-336 put back ab84b56b
history: enemy_hover_life_fractional_fill_verification.gd: now bf92c1ec, D-344 put back 09e25736, D-342 put back 0b816f06, D-340 put back 2187ccb1, D-338 put back fde101de, D-336 put back 5063a690
history: fallen_delay_drop_highlight_smoke.sh: now 6f792a38, D-344 put back 08aa2d0b, D-342 put back b1b456bd, D-340 put back fea9988e, D-338 put back d2772373, D-336 put back aeba508d, D-334 put back f5451331, D-332 put back 36583a6d
history: fallen_delay_drop_highlight_verification.gd: now beb94aa0, D-344 put back 6204a260, D-342 put back dceea6f9, D-340 put back b735e6c7, D-338 put back c9648eea, D-336 put back 44ed4bdf, D-334 put back 733d4af8, D-332 put back d782328a
history: fallen_delay_item_interaction_smoke.sh: now 939d9b48, D-344 put back 0fd60eb7, D-340 put back e14e996b, D-338 put back cb520369, D-336 put back d7cf4498, D-334 put back b7ff3d66, D-332 put back ffbb4b7b, D-330 put back 8b55c045
history: fallen_delay_item_interaction_verification.gd: now 8aad4262, D-344 put back 15352d8a, D-342 put back 5c8e9b07, D-340 put back eff592af, D-338 put back 3deeb26a, D-336 put back 611891a3, D-334 put back 308fe51a, D-332 put back 7ad7dd67, D-330 put back 409b540d
history: fallen_modal_life_state_verification.gd: now 72e39a8a, D-344 put back 935a37e9, D-340 put back 6acc1e0c, D-338 put back d5407c7c, D-336 put back eb7f4153, D-334 put back f065a48d, D-332 put back ca594f7d, D-330 put back a3f97de5, D-328 put back b04b0a1e
history: first_mvp_modal_left_click_verification.gd: now d12ad271, D-344 put back 75f26486, D-340 put back acbd3892, D-338 put back 8c0e290c, D-330 put back c6fe40f1, D-328 put back 2f5a32ca
history: global_damage_live_application_smoke.sh: now ccef4a26, D-336 put back 803b8a7f, D-334 put back 4f8cad92, D-332 put back 63722475
history: guaranteed_drop_defeated_enemy_binding_smoke.sh: now 94b5e6c9, D-344 put back 22544403, D-342 put back 1f2a43b1, D-340 put back 56258899
history: guaranteed_drop_defeated_enemy_binding_verification.gd: now aaa9e1d3, D-344 put back e526397b, D-342 put back ae964685, D-340 put back 368f584e
history: maximum_life_live_application_smoke.sh: now e3887f96, D-336 put back 657c0b17, D-334 put back e5d90d8e, D-332 put back 12fa3bc4
history: pending_fallen_restart_smoke.sh: now 54a4464a, D-344 put back 9a860bca, D-340 put back ec5bc37f, D-338 put back 689284cc, D-336 put back 67cf7ba9, D-334 put back f7b48202, D-332 put back 6e4120a3, D-330 put back 5c45961b, D-328 put back 1789de06
history: pending_fallen_restart_verification.gd: now 7d0e3f08, D-344 put back 53c37976, D-340 put back dc9be60f, D-338 put back 1062c1db, D-336 put back 520d9543, D-334 put back 68a1227e, D-332 put back b2cfc253, D-330 put back 565a0a4f, D-328 put back 51c8560c
history: restart_position_stability_smoke.sh: now 34db74ce, D-344 put back 02f03162, D-342 put back 20b7a562
history: restart_position_stability_verification.gd: now 1588cff8, D-344 put back bf25715a, D-342 put back 51108a47
none of the 20 accepted suite files holds another's body, raw or escaped, in any of the 380 pairings
pair text is still held inline only by J3's own seven layers — edits to the slice, J1 and J2, which hold no pair text themselves — and by six suites' own production pairs: 74 strings, 12951 bytes, none of them nesting a stored text or pair list
the longest line in any accepted suite file is 3015 characters; at D-341 it was 1335201
one byte changed at offset 514: refused — text 001c6202 is misnamed: its content hashes to 68abce72
cut to half its 412215 bytes: refused — d342_accepted_suite_history.provenance: text a5c459f1 is never closed
one byte appended: refused — d342_accepted_suite_history.provenance ends inside a line; its final newline removed: refused — d342_accepted_suite_history.provenance ends inside a line
a text a pair list names, left out: refused — a reference names a missing text a010666c
the same text held twice: refused — d342_accepted_suite_history.provenance: text a010666c is duplicated
the first two texts swapped: refused — d342_accepted_suite_history.provenance: records out of order at 1 001c62022b0fede52cecc9a887699c79f6406c
a pair list's 6 pairs in reverse order: refused — pair list 0536dabb is misnamed: its lines hash to b3b657f8
a text stored under a name one character off its own, in the last place: refused — text a010666c is misnamed: its content hashes to a010666c
a text nothing names, added: refused — text 79c697f4 is referenced by nothing
the pair list that puts D-342 back for fallen_delay_item_interaction_verification.gd, left out: refused — an edge for fallen_delay_item_interaction_verification.gd names a missing pair list e48a940f — and its name resolves to nothing
D-342's edge for fallen_delay_item_interaction_verification.gd holds; the same edge claiming another target, or claimed for fallen_delay_drop_highlight_verification.gd, does not
J10's own D-340 pairs for combat_hud_fractional_fill_smoke.sh applied to the file as it stands, without D-342 put back first, do not reach the D-339 file
J10's pin for first_mvp_modal_left_click_verification.gd with one character moved resolves to nothing, and its read fails: its own pairs (0) rebuild 75f26486, not acbd3892
all 7 migrated verifications resolve only while the engine hashes to their pin; the engine with one byte appended does not
6 production-walk lines across the accepted runners are exactly D-341's; every EXPECTED_PRODUCTION line is D-341's or moved inside a pair D-344 records
the four legacy runners (fallen_delay_drop_highlight_smoke.sh, combat_hud_fractional_fill_smoke.sh, enemy_hover_life_fractional_fill_smoke.sh, combat_hud_safe_bottom_placement_smoke.sh) still read their seven .DS_Store files under D-338's narrow exception, and no other runner does; every walk this maintenance runner makes prunes them
the 10 verifications keep every owed-check list and their 259 _expect calls, as at D-341; 54 functional or measured line(s) moved in all, every one inside a pair D-344 records
the 10 runners moved nothing but their hash rows and one comment line each; each keeps its verdict lines (26 in all), its mode and its run mode — J1's and J5's still render, the rest are headless
every verification is 644 and every runner 755; this maintenance runner is 755, has no rendered mode and takes no screenshot
one line added to the slice moves 21 files: broken_watch_slice.gd, first_mvp_modal_left_click_verification.gd, fallen_modal_life_state_verification.gd, pending_fallen_restart_verification.gd, pending_fallen_restart_smoke.sh, fallen_delay_item_interaction_verification.gd, fallen_delay_item_interaction_smoke.sh, fallen_delay_drop_highlight_verification.gd, fallen_delay_drop_highlight_smoke.sh, combat_hud_fractional_fill_verification.gd, combat_hud_fractional_fill_smoke.sh, enemy_hover_life_fractional_fill_verification.gd, enemy_hover_life_fractional_fill_smoke.sh, combat_hud_safe_bottom_placement_verification.gd, combat_hud_safe_bottom_placement_smoke.sh, guaranteed_drop_defeated_enemy_binding_verification.gd, guaranteed_drop_defeated_enemy_binding_smoke.sh, restart_position_stability_verification.gd, restart_position_stability_smoke.sh, non_nesting_accepted_suite_reconstruction_verification.gd, non_nesting_accepted_suite_reconstruction_smoke.sh
the new store file: 41140 bytes, 37 texts, 18 pair lists, 19 edges — every text one literal segment, 0 references, and no existing record rewritten
the moved suite files grow by 17711 bytes in all, 3828 at most (restart_position_stability_verification.gd); no earlier text, pair list or suite body is escaped into any of it
every one of the 19 new edges puts its file back to the state it holds now, and the store with the new file beside it is valid
modelled, not written: each later suite's check lines would also nest one `.get(path, ...)` per new layer; constant per reading line
22 synthetic files were written to the temporary directory and all removed again
MEASURED

# --------------------------------------------------------------------------
step "4. project.godot is untouched"

project_godot="$PROJECT_DIR/project.godot"
actions="$(sed -n '/^\[input\]/,/^\[layer_names\]/p' "$project_godot" | grep -cE '^[a-zA-Z_0-9]+=')"
if [[ "$actions" == "$EXPECTED_INPUT_ACTIONS" ]]; then
	pass "the InputMap still declares exactly $EXPECTED_INPUT_ACTIONS actions"
else
	fail "the InputMap declares $actions actions, not $EXPECTED_INPUT_ACTIONS"
fi
main_scene="$(grep -oE 'run/main_scene="[^"]+"' "$project_godot" | head -1 | sed -E 's/run\/main_scene="([^"]+)"/\1/')"
if [[ "$main_scene" == "$EXPECTED_MAIN_SCENE" ]]; then
	pass "the entrypoint is still $EXPECTED_MAIN_SCENE"
else
	fail "the entrypoint is '$main_scene', not $EXPECTED_MAIN_SCENE"
fi
sections="$(grep -oE '^\[[a-z_]+\]$' "$project_godot" | tr -d '[]' | sort | tr '\n' ' ' | sed 's/ $//')"
if [[ "$sections" == "$EXPECTED_SECTIONS" ]]; then
	pass "the same nine sections, no new one"
else
	fail "project.godot's sections are '$sections'"
fi
if grep -q '^\[autoload\]' "$project_godot"; then
	fail "an [autoload] section was added"
else
	pass "there is still no [autoload]"
fi

# --------------------------------------------------------------------------
step "5. Every protected file, every production file, .godot/ and every evidence frame are byte-identical, and the owner's files and logs are untouched"

changed=0
for i in "${!PRESERVED_FILES[@]}"; do
	after="$(fingerprint "$PROJECT_DIR/${PRESERVED_FILES[$i]}")"
	if [[ "$after" != "${BEFORE_HASHES[$i]}" ]]; then
		fail "${PRESERVED_FILES[$i]} CHANGED during this run"
		changed=$((changed + 1))
	fi
done
if [[ "$changed" == "0" && "$missing_preserved" == "0" ]]; then
	pass "all ${#PRESERVED_FILES[@]} protected files are byte-identical"
fi

production_after="$(production_listing | shasum -a 256 | cut -d' ' -f1)"
if [[ "$production_after" == "$EXPECTED_PRODUCTION_DIGEST" ]]; then
	pass "every production file is still as D-341 left it after the run"
else
	fail "a production file changed during this run"
fi

godot_after="$(godot_fingerprint)"
godot_count_after="$(godot_file_count)"
if [[ "$godot_after" == "$godot_before" && "$godot_count_after" == "$godot_count_before" ]]; then
	pass ".godot/ is byte-identical: $godot_count_after files, the same content"
else
	fail ".godot/ changed during this run: $godot_count_before -> $godot_count_after files"
fi

evidence_after="$(evidence_fingerprint)"
evidence_count_after="$(evidence_file_count)"
if [[ "$evidence_after" == "$evidence_before" && "$evidence_count_after" == "$evidence_count_before" ]]; then
	pass "docs/testing/ is byte-identical: $evidence_count_after evidence frames and reports, the same content"
else
	fail "docs/testing/ changed during this run: $evidence_count_before -> $evidence_count_after files"
fi

settings_after="$(state_fingerprint "$production_dir/prototype_settings.cfg")"
lab_after="$(state_fingerprint "$production_dir/prototype_zero.cfg")"
character_after="$(state_fingerprint "$production_dir/riftwrought_character.cfg")"
if [[ "$settings_after" == "$settings_before" && "$lab_after" == "$lab_before" \
		&& "$character_after" == "$character_before" ]]; then
	pass "the project owner's own prototype_settings.cfg, prototype_zero.cfg and riftwrought_character.cfg are unchanged (the last $character_after)"
else
	fail "a file in the project owner's own user:// directory changed during this run"
fi
logs_after="$(directory_listing "$production_dir/logs")"
if [[ "$logs_after" == "$logs_before" ]]; then
	pass "Godot's own user://logs/ is unchanged — every invocation logged into this run's temporary directory"
else
	fail "Godot's own user://logs/ changed during this run"
fi

# --------------------------------------------------------------------------
step "6. This run's temporary directory is removed and nothing of it is left behind"

rm -rf "$work"
if [[ ! -e "$work" && "$(leftover_count)" == "0" ]]; then
	pass "the temporary directory is gone and no $TEMP_STEM.* directory remains in $TEMP_ROOT"
else
	fail "a temporary directory of this runner remains in $TEMP_ROOT"
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'NON-NESTING ACCEPTED-SUITE RECONSTRUCTION SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; headless; %s protected files, every production file, .godot/ and docs/testing/ byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf 'Verification Maintenance V1 — Non-Nesting Accepted-Suite Reconstruction — ACCEPTED\n'
	printf 'VERDICT: PASS — Verification Maintenance V1 is accepted.\n'
	printf 'D-223 remains OPEN.\n'
	reached_end=1
	exit 0
else
	printf 'NON-NESTING ACCEPTED-SUITE RECONSTRUCTION SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
