#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation H5 smoke checks: the run-owned Experience
# Mote field and its deterministic collection sweep (decision D-279).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# Foundation H5 adds TWO pure-logic scripts under `scripts/pickups/` — an
# in-memory field that belongs to one exact signed run seed, makes and owns its
# Experience Mote drops from positions and amounts a caller supplies, and sweeps
# every drop not yet collected in the order it was made, delegating each attempt
# to the accepted drop; and the value one sweep answers with. No scene, no
# resource, no asset, no InputMap action, no entrypoint change, nothing written to
# disk, and NOTHING THAT RUNS CREATES OR SWEEPS A FIELD.
#
# IT DOES NOT RERUN THE FOUNDATIONS IT COMPOSES. Four accepted suites moved one for
# one because the field names their classes or shares their directory — H4, whose
# blanket unwired scan became a per-file, per-token table granting the field the
# drop's class and its collection call; H3, whose reader table granted the field
# the result class alone, and whose directory pin gained two scripts; H2, whose
# directory pin gained two scripts; and G4, whose reader table gained one row —
# and each is rerun by its own runner at its own unchanged count.
#
# What this script proves:
#
#   1. the new scripts parse;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line and
#      the measurements it exists to make read out of that log;
#   3. from outside the engine: the field declares exactly its two bare fields
#      and nine functions, no constant, static state or signal; it counts but
#      computes nothing else, carries no literal but 0 and 1, sorts nothing,
#      removes nothing and hands out neither the list nor a drop; it makes its
#      drops in one place, appends in one place and asks each drop once; it
#      refuses a missing run, then an incoherent field, then another run's seed,
#      before the first drop is asked; the result holds scalars and one private
#      copy of the indices; neither reads storage, randomness, ambient state,
#      physics or scenes, or names content or a guarded token it is not granted;
#      of every project class — READ from the `class_name` lines under `scripts/`
#      and `addons/` — the field names exactly its five and the result exactly
#      itself; nothing that runs names either — Foundation H6's enemy mote
#      emission, which nothing creates, is granted the field's class and its
#      drop-making call alone (D-281), Foundation H7's Graveblade mote binding,
#      which nothing creates, the field's class alone (D-283), and Foundation H8's
#      Experience Mote runtime, which nothing creates, the field's class, the
#      result's class and the sweep call (D-286); and the verification names no
#      file under `tests/` but its own;
#   4. `scripts/pickups/` holds exactly H2's two scripts, H3's two, H4's one,
#      H5's two, and their uid files;
#   5. the files this work could conceivably have disturbed — the project owner's
#      loading teaser among them — are BYTE-IDENTICAL ACROSS THE RUN.
#
# Usage, from the repository root:
#   game/tests/rift_mote_field_smoke.sh

set -uo pipefail

# Assigned at the TOP of the script, never beside the function it serves: a
# shell evaluates an assignment only when execution REACHES it, and Gate 1E's
# first staleness guard failed every read for exactly that reason.
RUN_STARTED_AT="$(date +%s)"

# A SCRIPT THAT DIES HALFWAY MUST NOT REPORT SUCCESS. `reached_end` is set by
# exactly one line, immediately before the final verdict.
reached_end=0
scratch_replay=""
on_exit() {
	local code=$?
	[[ -n "$scratch_replay" ]] && rm -f "$scratch_replay"
	if [[ "$reached_end" != "1" ]]; then
		printf '\nRIFT MOTE FIELD SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_mote_field_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=438

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added.
EXPECTED_OWED_CHECKS=18

FIELD="scripts/pickups/rift_mote_field.gd"
RESULT="scripts/pickups/rift_mote_sweep_result.gd"
THIS_VERIFICATION="tests/rift_mote_field_verification.gd"

PARSED_SCRIPTS=(
	"$FIELD"
	"$RESULT"
	"$THIS_VERIFICATION"
)

# The only project classes each file may name, in C-locale sort order.
EXPECTED_FIELD_NAMED="RiftMoteCollectionResult RiftMoteDrop RiftMoteField RiftMoteSweepResult RiftRunLevelCoordinator"
EXPECTED_RESULT_NAMED="RiftMoteSweepResult"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. The project settings, the
# canonical combat record, the project owner's composed zone, the project owner's
# loading teaser (pre-existing work this foundation does not touch), the accepted
# mechanisms the field composes or stands on — H4's drop, H3's attempt and result,
# H2's query and reading, H1's mote, G4's coordinator and its record, the
# one-level lifecycle and its receipt under the run — the build and the stat
# scripts the range is taken from, the two passive-card record scripts that own
# the shipped Pickup Radius magnitude, the experience track that owns Experience
# Gain and the overflow refusal, and the dropped item that owns today's manual
# pickup distance.
PRESERVED_FILES=(
	"project.godot"
	"data/prototype_zero/quick_strike.tres"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"assets/prototype/ui/loading/riftwrought-loading-teaser-v1.png"
	"scripts/pickups/rift_mote_drop.gd"
	"scripts/pickups/rift_mote_collection_attempt.gd"
	"scripts/pickups/rift_mote_collection_result.gd"
	"scripts/pickups/rift_mote_pickup_query.gd"
	"scripts/pickups/rift_mote_pickup_reading.gd"
	"scripts/experience/rift_experience_mote.gd"
	"scripts/levels/rift_run_level_coordinator.gd"
	"scripts/levels/rift_run_level_up_result.gd"
	"scripts/levels/rift_level_up_coordinator.gd"
	"scripts/levels/rift_level_up_result.gd"
	"scripts/runs/rift_run_build.gd"
	"scripts/stats/player_stats.gd"
	"scripts/stats/player_stat_totals.gd"
	"scripts/stats/player_stat_value.gd"
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/experience/rift_experience_track.gd"
	"scripts/items/first_mvp_item_drop.gd"
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

# D-201's lesson, kept alive in every runner since: a run that reports PASS
# while a script error scrolled past is not a pass.
assert_no_script_error() {
	local what="$1" logfile="$2" found
	found="$(grep -cE "SCRIPT ERROR|String formatting error" "$logfile" 2>/dev/null | tr -d ' ')"
	if [[ "$found" == "0" ]]; then
		pass "$what produced no SCRIPT ERROR"
	else
		fail "$what produced $found engine error line(s)"
		grep -A3 -E "SCRIPT ERROR|String formatting error" "$logfile" | head -20 | sed 's/^/        /'
	fi
}

# `/tmp` is never cleared between runs, so a file from an earlier — possibly
# interrupted — invocation must never answer for this one.
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

read_check_count() {
	grep -ohE "$1: PASS \([0-9]+ checks\)" "$2" \
		| grep -ohE '[0-9]+ checks' | grep -ohE '[0-9]+' | head -1
}

# Code with every comment line and every string literal removed, so a scan can
# tell the file's plain-English promises and its messages from what it does.
bare_code() {
	grep -vE '^[[:space:]]*#' "$1" | sed -E 's/"([^"\\]|\\.)*"/""/g'
}

printf 'Riftwrought — Roguelite Foundation H5: run-owned mote field and deterministic collection sweep (D-279)\n'
printf 'project: %s\n' "$PROJECT_DIR"

# --------------------------------------------------------------------------
step "0. Godot version"
version="$("$GODOT" --version 2>/dev/null | tail -1)"
printf '  installed: %s\n' "$version"
if [[ "$version" == "$EXPECTED_VERSION"* ]]; then
	pass "matches the locked $EXPECTED_VERSION baseline"
else
	fail "expected $EXPECTED_VERSION (locked by D-167)"
fi

# The before-fingerprints, taken before anything runs.
declare -a before_prints=()
for file in "${PRESERVED_FILES[@]}"; do
	before_prints+=("$(fingerprint "$PROJECT_DIR/$file")")
done

# --------------------------------------------------------------------------
step "1. Every new script parses"
for script in "${PARSED_SCRIPTS[@]}"; do
	if [[ ! -f "$PROJECT_DIR/$script" ]]; then
		fail "$script is missing"
		continue
	fi
	out="$("$GODOT" --headless --path "$PROJECT_DIR" --check-only --script "res://$script" 2>&1 \
		| grep -v '^Godot Engine')"
	if [[ -z "$out" ]]; then
		pass "$script"
	else
		fail "$script does not parse"
		printf '%s\n' "$out" | head -10 | sed 's/^/        /'
	fi
done

# --------------------------------------------------------------------------
step "2. The pinned verification passes, proved in BOTH directions"
verify_log="/tmp/riftwrought_rift_mote_field_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless field verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT MOTE FIELD VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one, and the negative direction must READ the moved
# number, because a bare `!=` is satisfied by the empty string on exactly the
# runs where a broken suite needs catching.
replay="$(mktemp -t riftwrought_rift_mote_field_replay)"
scratch_replay="$replay"
sed "s/RIFT MOTE FIELD VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT MOTE FIELD VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT MOTE FIELD VERIFICATION" "$replay")"
if [[ -z "$count" ]]; then
	fail "the verification printed no count line, so the count pin proves nothing this run"
elif [[ "$replay_count" == "$((EXPECTED_CHECKS + 1))" ]]; then
	pass "and that pin reads a log whose count moved by one as $replay_count, refusing it"
else
	fail "the count pin read '${replay_count:-nothing}' from a moved log and therefore proves nothing"
fi

if grep -qE "^  $EXPECTED_OWED_CHECKS of $EXPECTED_OWED_CHECKS owed checks completed" "$verify_log"; then
	pass "all $EXPECTED_OWED_CHECKS owed checks reached their last line"
else
	fail "the owed-set report is missing or short"
	grep -E "owed checks" "$verify_log" | sed 's/^/        /'
fi

# The measurements this foundation exists to make, read out of the run's own log
# rather than restated here. `--` before the pattern is D-244's lesson kept: a
# measured line that begins with a dash is read by grep as an option bundle. Two
# lines are pinned only up to a number that grows with the project.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
the constructor takes 1 argument and no method defaults one; 6 of 6 fields read back their exact signed seed; each starts with 0 drops
the empty field's sweep: sweep of 0 drops: 0 skipped as already collected, 0 attempted — 0 collected [], 0 out of range, 0 refused; a stranger run is still refused whole
the count grew 1, 2, 3, 4, 5, 6; from the player the even entries (1.5 m) collected at [0, 2, 4] and the odd ones (3.0 m) were 3 out of range
9 non-finite positions and 5 unusable amounts: 14 of 14 refused, 14 quoting the drop's own problem word for word; the field unchanged; a drop wrong in both answers 'an Experience Mote drop's position must have a finite x, y and z, not (nan, 0.0, 0.0)'
the refusals took no index (the next valid drop swept as entry 2); 5e-324 and 1.7e+308 were kept as given and each paid exactly
2 equal drops of 25 delivered 50.0, each once; 2 equal drops of 1.7e+308 at one position: entry 0 collected, entry 1 refused ('adding 1.7e+308 to 1.7e+308 would make the stored progress unusable') and still uncollected
run seed 100 refused ('this Experience Mote field belongs to run seed 99, not to run seed 100; it may be swept only into the run that dropped its motes')
5 of 5 wrong-run sweeps answered exactly that with nothing attempted, skipped or collected — at the player, at (nan, inf, -inf), against an open offer, and after one and after every collection — where a twin field in its own run answers 'the player position must have a finite x, y and z, not (nan, inf, -inf)' for all 3 drops
no run: 'an Experience Mote field must be swept into a run, and none was given'; the owning run then collected [0, 2] of the same field and, after moving, 75.0
0 and 4294967296 each refused the other's field ('this Experience Mote field belongs to run seed 0, not to run seed 4294967296; it may be swept only into the run that dropped its motes' / 'this Experience Mote field belongs to run seed 4294967296, not to run seed 0; it may be swept only into the run that dropped its motes') and each collected its own
seeds 0, 4294967296, -9223372036854775808, -1, 4294967295, 9223372036854775807: 6 of 36 field-run pairs swept (each field by its own run); 30 refused whole naming both seeds in full, 12 of them seeds that agree in their low 32 bits
the pickup query calls entries [0, 2, 3, 5, 7] in range at 2.5 m; the sweep collected [0, 2, 3, 5, 7] (1.5 m, 2.5 m on -x, 2.5 m on a 3-4-5 diagonal, one spacing within 2.5 m, 0.0 m, 2.5 m above) and found 3 out of range
the nearest drop, entry 7 at 0.0 m, was collected at position 5 of 5; a reading changed three ways left the result at [0, 2, 3, 5, 7]
after the baseline collected 5, three sweeps from new positions collected [1] skipping 5 then [4] skipping 6 then [6] skipping 7; the field then held 8 collected and delivered 200.0
4 of 4 later sweeps — one from a non-finite position — skipped all 8, attempted 0 and paid nothing
entries 0 and 1 hold 1.7e+308, entry 1 nearer: collected [0, 2], 1 refused ('adding 1.7e+308 to 1.7e+308 would make the stored progress unusable', equal to the drop's own answer), 1 out of range; entry 0 stayed paid
from a non-finite position: 2 skipped, 2 refused, first reason 'the player position must have a finite x, y and z, not (nan, 0.0, 0.0)'; nothing moved
level 1 requires 100.0; the sweep collected [0, 1, 2, 3, 4] and delivered 125.0: still level 1, offer open: false
the field's own sweep reached 100.0; while the offer stood two sweeps refused 4 in-range drops ('an offer is open; it must be resolved before further experience is recorded', equal to the drop's own answer) and found 4 out of range, collecting nothing; the run unmoved
after the choice (level 2) the same field collected [4, 6] and still found 2 out of range
the baseline sweep collected [0, 2, 3, 4] and left entry 1 out of range at 2.5 m; it delivered 100.0, and no offer opened by itself
run seed 0, level 1 Utility lane: card_magnetism chosen; Pickup Radius total 0.25; the resweep skipped 4 and collected [1] within 3.125 m; the award stayed 25.0
a 240-drop grid swept 4 times: 0 skipped + 240 attempted = 240; 81 collected + 159 out of range + 0 refused | 81 skipped + 159 attempted = 240; 48 collected + 111 out of range + 0 refused | 129 skipped + 111 attempted = 240; 51 collected + 60 out of range + 0 refused | 180 skipped + 60 attempted = 240; 0 collected + 60 out of range + 0 refused
every collected list equal to the pickup query's own in-range entries, ascending; a twin field answered identically every time; 180 collected, 60 not, 4500.0 delivered
an assigned packed array is shared in this engine; the value's indices stayed [0, 2] after the caller's array and a reading were each changed
18 of 18 contradictions caught by problem(), 4 of 4 coherent controls accepted; 9 fields, 0 object references
6 argument-free readings answer 0 objects or arrays; the methods declaring an object answer are _init, sweep_collection, and the sweep's is the value checked above
2 fields (_run_seed:int, _drops:Array<RiftMoteDrop>), declared bare; the seed written only by the constructor and the list only by one append; 9 methods pinned, none defaulting an argument or taking a drop; 0 removal, reset, copy, transfer, teardown, setter or signal members
6 spawn, 6 validity and 20 sweep steps in order, each once; 7 gates each return on the next line; 15 return lines pinned, none handing out a drop or the list
0 hits for distance or radius formulas, percentages, experience arithmetic, requirements, offer seeds, content, sorting, removal, nodes, signals, scenes, physics or files; literals ["0", "1"] in the field and ["0", "1"] in the result
the field names only RiftMoteCollectionResult, RiftMoteDrop, RiftMoteField, RiftMoteSweepResult, RiftRunLevelCoordinator; the result names only RiftMoteSweepResult; their names overlap 0 other class names;
0 unauthorized project files create, fill or sweep a field (4 readers granted by file and token); scripts/pickups/ holds 7 scripts; 31 actions;
39 whole-sweep refusals and 44 completed sweeps collecting 413 drops were asserted across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. Two bare fields, counting only, ownership before the first drop, five named classes, and nothing that runs creates a field"
shape=0

field_code="$(bare_code "$PROJECT_DIR/$FIELD")"
result_code="$(bare_code "$PROJECT_DIR/$RESULT")"

fields="$(grep -E '^var ' <<< "$field_code" | tr '\n' '|')"
if [[ "$fields" != "var _run_seed: int|var _drops: Array[RiftMoteDrop]|" ]]; then
	fail "the field declares the fields: ${fields:-none} — not exactly two, bare, in order"
	shape=$((shape + 1))
fi
if grep -qE '^(static|const|signal|enum|@)' <<< "$field_code"; then
	fail "the field declares static state, a constant, a signal, an enum or an annotation"
	shape=$((shape + 1))
fi
functions="$(grep -oE '^func [a-z_]+\(' <<< "$field_code" | tr '\n' ' ')"
if [[ "$functions" != "func _init( func spawn_drop( func run_seed( func drop_count( func uncollected_count( func collected_count( func problem( func sweep_collection( func describe( " ]]; then
	fail "the field declares the functions: ${functions:-none}"
	shape=$((shape + 1))
fi
result_fields="$(grep -oE '^var [a-z_]+' <<< "$result_code" | tr '\n' ' ')"
if [[ "$result_fields" != "var ok var failure_reason var total_count var skipped_count var attempted_count var out_of_range_count var item_refusal_count var first_item_refusal_reason var _collected_indices " ]]; then
	fail "the result declares the fields: ${result_fields:-none}"
	shape=$((shape + 1))
fi
result_functions="$(grep -oE '^(static )?func [a-z_]+\(' <<< "$result_code" | tr '\n' ' ')"
if [[ "$result_functions" != "static func refused( static func completed( func collected_indices( func collected_count( func problem( func describe( " ]]; then
	fail "the result declares the functions: ${result_functions:-none}"
	shape=$((shape + 1))
fi
# COUNTING ONLY: no multiplication, division or bit operation; `+` only as the
# field's five `+= 1` counters and the result's three sums of its own counts; one
# derived subtraction in each; literals 0 and 1 only.
if grep -qE '[*/&|^]|<<|>>' <<< "$field_code$result_code"; then
	fail "H5 multiplies, divides or operates on bits"
	shape=$((shape + 1))
fi
if [[ "$(grep -oF '+' <<< "$field_code" | wc -l | tr -d ' ')" != "5" \
		|| "$(grep -oF '+= 1' <<< "$field_code" | wc -l | tr -d ' ')" != "5" \
		|| "$(grep -oF '+' <<< "$result_code" | wc -l | tr -d ' ')" != "3" ]]; then
	fail "H5 adds something other than its counters and the result's own sums"
	shape=$((shape + 1))
fi
if [[ "$(sed 's/->//g' <<< "$field_code" | grep -oF -- '-' | wc -l | tr -d ' ')" != "1" \
		|| "$(sed 's/->//g' <<< "$result_code" | grep -oF -- '-' | wc -l | tr -d ' ')" != "1" ]]; then
	fail "H5 subtracts or negates more than its one derived count and its one start marker"
	shape=$((shape + 1))
fi
literals="$(grep -oE '(^|[^A-Za-z0-9_.])[0-9][0-9_.]*' <<< "$field_code$result_code" | grep -oE '[0-9][0-9_.]*' | LC_ALL=C sort -u | tr '\n' ' ')"
if [[ "$literals" != "0 1 " ]]; then
	fail "H5 carries the literals: ${literals:-none}"
	shape=$((shape + 1))
fi
if grep -qE 'sqrt|abs\(|pow\(|min\(|max\(|clamp|value_of|total_for|\.x|\.y|\.z|distance|radius|stat_totals|run_build|choose\(|open_|evaluate\(|Dictionary|set\(|setget|signal|emit|connect\(|Node|Area|Shape|sort|shuffle|reverse|bsearch|erase|remove|clear\(|pop_|insert\(|resize|fill\(|append_array|push_front|free\(|await|_process' <<< "$field_code$result_code"; then
	fail "H5 restates a formula, reads a coordinate, asks another step of the run, sorts, removes, or signals"
	shape=$((shape + 1))
fi
if grep -qF 'duplicate' <<< "$field_code" || [[ "$(grep -oF '.duplicate()' <<< "$result_code" | wc -l | tr -d ' ')" != "2" ]]; then
	fail "the field copies something, or the result does not copy its indices in and out"
	shape=$((shape + 1))
fi
if [[ "$(grep -oF '.new(' <<< "$field_code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF 'RiftMoteDrop.new(_run_seed, drop_position, base_experience)' <<< "$field_code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF '_drops.append(' <<< "$field_code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF '.attempt_collection(' <<< "$field_code" | wc -l | tr -d ' ')" != "1" ]]; then
	fail "the field does not make its drops in one place, append in one place and ask each drop in one place"
	shape=$((shape + 1))
fi
if grep -qE 'return _drops$|return _drops\[|return _drops[^.]|return drop$' <<< "$field_code"; then
	fail "the field returns its drop list or a drop"
	shape=$((shape + 1))
fi
# THE ORDER, BY LINE: a missing run, then an incoherent field, then ownership, then
# the loop that asks each drop — and a drop is appended only after its own problem.
no_run_line="$(grep -nF 'if run == null:' "$PROJECT_DIR/$FIELD" | cut -d: -f1)"
incoherent_line="$(grep -nF 'var incoherent: String = problem()' "$PROJECT_DIR/$FIELD" | cut -d: -f1)"
owner_line="$(grep -nF 'if run.run_seed() != _run_seed:' "$PROJECT_DIR/$FIELD" | cut -d: -f1)"
asked_line="$(grep -nF 'var answer: RiftMoteCollectionResult = drop.attempt_collection(player_position, run)' "$PROJECT_DIR/$FIELD" | cut -d: -f1)"
made_line="$(grep -nF 'var drop: RiftMoteDrop = RiftMoteDrop.new(' "$PROJECT_DIR/$FIELD" | cut -d: -f1)"
checked_line="$(grep -nF 'var invalid: String = drop.problem()' "$PROJECT_DIR/$FIELD" | head -1 | cut -d: -f1)"
append_line="$(grep -nF '_drops.append(drop)' "$PROJECT_DIR/$FIELD" | cut -d: -f1)"
if [[ -z "$no_run_line" || -z "$incoherent_line" || -z "$owner_line" || -z "$asked_line" \
		|| "$no_run_line" -ge "$incoherent_line" || "$incoherent_line" -ge "$owner_line" || "$owner_line" -ge "$asked_line" ]]; then
	fail "the sweep does not refuse no run, then an incoherent field, then another run's seed, before asking a drop (lines ${no_run_line:-?} / ${incoherent_line:-?} / ${owner_line:-?} / ${asked_line:-?})"
	shape=$((shape + 1))
fi
if [[ -z "$made_line" || -z "$checked_line" || -z "$append_line" \
		|| "$made_line" -ge "$checked_line" || "$checked_line" -ge "$append_line" ]]; then
	fail "a drop is not made, then asked its problem, then appended (lines ${made_line:-?} / ${checked_line:-?} / ${append_line:-?})"
	shape=$((shape + 1))
fi
if grep -qE 'user://|ConfigFile|ResourceSaver|ResourceLoader|FileAccess|randi|randf|randomize|RandomNumberGenerator|Time\.|OS\.|Engine\.|ProjectSettings|InputMap|preload\(|load\(|get_tree|get_node|Node3D|Area3D|CollisionShape|PhysicsServer|NavigationServer|NavigationAgent|distance_to|distance_squared_to|length\(|global_position|Transform3D' \
		"$PROJECT_DIR/$FIELD" "$PROJECT_DIR/$RESULT"; then
	fail "H5 reads storage, randomness, ambient engine state, physics, navigation or a node"
	shape=$((shape + 1))
fi
# Content, and every accepted scan's guarded token H5 is not granted — raw,
# comments included.
if grep -qE 'card_[a-z]+|[Mm]agnetism|quick_strike|Graveblade|Skill|[Ee]nemy|PICKUP_RADIUS|EXPERIENCE_GAIN|RiftMotePickup|RiftMoteCollectionAttempt|PlayerStat|RiftRunBuild|RiftRunLevelUpResult|RiftLevelRequirement|RiftLevelOfferSeed|RiftOffer|requirement_for|offer_root_seed|open_current_offer|award_experience|next_level_coordinator|collect_into|RiftExperienceMote|rift_experience_mote|rift_mote_drop|rift_mote_collection|rift_mote_pickup|\.tscn|scenes/' \
		"$PROJECT_DIR/$FIELD" "$PROJECT_DIR/$RESULT"; then
	fail "H5 names content, a formula constant, another step of the run, or a guarded token it is not granted"
	shape=$((shape + 1))
fi
if [[ "$shape" == "0" ]]; then
	pass "two bare fields and nine functions; nine result fields and six functions; counting only, literals 0 and 1; no formula, sort, removal or copy in the field; one make, one append, one ask; no run, then incoherent, then ownership, before any drop; no ambient read and no content"
fi

# EVERY PROJECT CLASS, READ FROM ITS OWN `class_name` LINE — never typed here.
declare -a project_classes=()
while IFS= read -r name; do [[ -n "$name" ]] && project_classes+=("$name"); done \
	< <(grep -rhoE '^class_name [A-Za-z0-9_]+' "$PROJECT_DIR/scripts" "$PROJECT_DIR/addons" 2>/dev/null \
		| awk '{print $2}' | LC_ALL=C sort -u)
field_named=""
result_named=""
for name in "${project_classes[@]}"; do
	grep -qF "$name" "$PROJECT_DIR/$FIELD" && field_named="$field_named$name "
	grep -qF "$name" "$PROJECT_DIR/$RESULT" && result_named="$result_named$name "
done
if [[ "${#project_classes[@]}" -lt 100 ]]; then
	fail "only ${#project_classes[@]} project classes were read — the class scan may be inert"
elif [[ "$field_named" == "$EXPECTED_FIELD_NAMED " && "$result_named" == "$EXPECTED_RESULT_NAMED " ]]; then
	pass "of ${#project_classes[@]} project classes the field names exactly $EXPECTED_FIELD_NAMED and the result exactly $EXPECTED_RESULT_NAMED"
else
	fail "the field names: ${field_named:-nothing}; the result names: ${result_named:-nothing}"
fi

searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "${searched:-0}" -gt 100 ]]; then
	pass "the shell-side scan read $searched project files"
else
	fail "the shell-side scan found only ${searched:-0} project files, so it proves nothing"
fi

# NOTHING THAT RUNS CREATES, FILLS OR SWEEPS A FIELD.
unwired=0
for token in "RiftMoteField" "rift_mote_field" "RiftMoteSweepResult" "rift_mote_sweep_result" "spawn_drop(" "sweep_collection("; do
	while IFS= read -r hit; do
		case "$hit" in
			*/"$FIELD"|*/"$FIELD".uid|*/"$RESULT"|*/"$RESULT".uid) continue ;;
		esac
		# D-281: Foundation H6's enemy mote emission is handed a field and asks it to
		# make one drop — granted the field's class and the drop-making call, never
		# either file name, the result or the sweep. Recorded in the verification's
		# per-file, per-token reader table. Nothing creates an emission.
		if [[ "$token" == "RiftMoteField" || "$token" == "spawn_drop(" ]]; then
			case "$hit" in
				*/scripts/experience/rift_enemy_mote_emission.gd) continue ;;
			esac
		fi
		# D-283: Foundation H7's Graveblade mote binding is handed a field, asks it
		# only its own problem and run seed, and passes it to its one emission —
		# granted the field's class alone, never the drop-making call, either file
		# name, the result or the sweep. Recorded in the verification's per-file,
		# per-token reader table. Nothing creates a binding.
		if [[ "$token" == "RiftMoteField" ]]; then
			case "$hit" in
				*/scripts/experience/rift_graveblade_mote_binding.gd) continue ;;
			esac
		fi
		# D-286: Foundation H8's Experience Mote runtime makes and owns one field,
		# reads its counts and asks it to sweep itself into the run, answering the
		# sweep's own value — granted the field's class, the result's class and the
		# sweep call, never the drop-making call or either file name. Recorded in the
		# verification's per-file, per-token reader table. Nothing creates a runtime.
		if [[ "$token" == "RiftMoteField" || "$token" == "RiftMoteSweepResult" || "$token" == "sweep_collection(" ]]; then
			case "$hit" in
				*/scripts/experience/rift_mote_runtime.gd) continue ;;
			esac
		fi
		# D-288: the Roguelite Experience Collection Greybox Review reads the value
		# H8's sweep answers with, to mirror each collected index onto its marker —
		# granted the result's class alone, never the field, the drop-making call,
		# the sweep call or either file name. Recorded in the verification's
		# per-file, per-token reader table. It sweeps only through H8.
		if [[ "$token" == "RiftMoteSweepResult" ]]; then
			case "$hit" in
				*/scripts/roguelite/experience/roguelite_experience_collection_review.gd) continue ;;
			esac
		fi
		fail "$(basename "$hit") names $token"
		unwired=$((unwired + 1))
	done < <(grep -rlF "$token" "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null)
	if grep -qF "$token" "$PROJECT_DIR/project.godot"; then
		fail "project.godot names $token"
		unwired=$((unwired + 1))
	fi
done
if grep -qE 'RiftMoteField|rift_mote_field|spawn_drop\(|sweep_collection\(' "$PROJECT_DIR/$RESULT"; then
	fail "the result names the field"
	unwired=$((unwired + 1))
fi
if grep -q '\[autoload\]' "$PROJECT_DIR/project.godot"; then
	fail "project.godot declares an [autoload] section"
	unwired=$((unwired + 1))
fi
if [[ "$unwired" == "0" ]]; then
	pass "nothing under scripts/, scenes/, data/ or addons/ and nothing in project.godot names the field or its result, fills a field or sweeps one, but H6's granted emission, H7's granted binding, H8's granted runtime, and the experience collection review, granted the result's class alone"
fi

# THE VERIFICATION READS NO OTHER SUITE.
others="$(grep -oE 'res://tests/[A-Za-z0-9_./-]+' "$PROJECT_DIR/$THIS_VERIFICATION" | sort -u \
	| grep -vxF "res://$THIS_VERIFICATION" | tr '\n' ' ')"
if [[ -z "${others// /}" ]] && grep -qF "res://$THIS_VERIFICATION" "$PROJECT_DIR/$THIS_VERIFICATION"; then
	pass "the verification names no file under tests/ but its own"
else
	fail "the verification names another test file: ${others:-none, and not even its own}"
fi

# --------------------------------------------------------------------------
step "4. scripts/pickups/ holds exactly H2's two scripts, H3's two, H4's one and H5's two"
unexpected=0
while IFS= read -r entry; do
	case "$(basename "$entry")" in
		rift_mote_pickup_query.gd|rift_mote_pickup_query.gd.uid| \
		rift_mote_pickup_reading.gd|rift_mote_pickup_reading.gd.uid| \
		rift_mote_collection_attempt.gd|rift_mote_collection_attempt.gd.uid| \
		rift_mote_collection_result.gd|rift_mote_collection_result.gd.uid| \
		rift_mote_drop.gd|rift_mote_drop.gd.uid| \
		rift_mote_field.gd|rift_mote_field.gd.uid| \
		rift_mote_sweep_result.gd|rift_mote_sweep_result.gd.uid)
			continue ;;
	esac
	fail "scripts/pickups/ holds the unexpected file $(basename "$entry")"
	unexpected=$((unexpected + 1))
done < <(find "$PROJECT_DIR/scripts/pickups" -type f 2>/dev/null)
gd_count="$(find "$PROJECT_DIR/scripts/pickups" -type f -name '*.gd' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$gd_count" != "7" ]]; then
	fail "scripts/pickups/ holds $gd_count scripts, not 7"
elif [[ "$unexpected" == "0" ]]; then
	pass "scripts/pickups/ holds exactly its seven scripts and their seven uid files"
fi

# --------------------------------------------------------------------------
step "5. Nothing that already existed changed during the run"
index=0
moved=0
for file in "${PRESERVED_FILES[@]}"; do
	after="$(fingerprint "$PROJECT_DIR/$file")"
	if [[ "$after" == "MISSING" ]]; then
		fail "$file is missing"
		moved=$((moved + 1))
	elif [[ "$after" != "${before_prints[$index]}" ]]; then
		fail "$file changed during this run"
		moved=$((moved + 1))
	fi
	index=$((index + 1))
done
if [[ "$moved" == "0" ]]; then
	pass "${#PRESERVED_FILES[@]} protected files are byte-identical before and after"
fi

# --------------------------------------------------------------------------
printf '\n'
if [[ "$failures" == "0" ]]; then
	printf 'RIFT MOTE FIELD SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation H5 — Run-Owned Mote Field and Deterministic Collection\n'
	printf '  Sweep — is DELIVERED under D-279 and ACCEPTED and CLOSED at the run-owned\n'
	printf '  deterministic mote-field sweep mechanism level under D-280.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT MOTE FIELD SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
