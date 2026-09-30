#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation H3 smoke checks: a stat-aware single-mote
# collection attempt (decision D-275).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# Foundation H3 adds TWO pure-logic scripts under `scripts/pickups/` — a stateless
# coordinator that attempts to collect one supplied Experience Mote from one
# supplied world position (it asks the run for a copy of its build's stat totals,
# asks the accepted pickup-range query whether the mote is within the effective
# Pickup Radius, and only then asks the mote to collect itself into the run), and
# the three-state result it answers with: refused, out of range, or collected. No
# scene, no resource, no asset, no InputMap action, no entrypoint change, nothing
# written to disk, and NOTHING THAT RUNS CALLS IT.
#
# IT DOES NOT RERUN THE FOUNDATIONS IT COMPOSES. Four accepted suites moved one for
# one because the attempt names their classes — H1 and H2, whose unwired scans
# gained one per-file, per-token grant (and H2's directory pin two scripts), G4,
# whose reader table gained one row, and C1, whose reader table gained one row —
# and each is rerun by its own runner at its own unchanged count.
#
# What this script proves:
#
#   1. the new scripts parse;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line and
#      the measurements it exists to make read out of that log;
#   3. from outside the engine: the attempt declares no field, constant or
#      constructor and exactly one function; it performs no arithmetic, carries no
#      floating-point literal, restates no formula, mutates nothing, scans
#      nothing and creates nothing; it asks the query once and the mote once, the
#      mote only on the line after the out-of-range return; the result performs no
#      arithmetic and carries no literal but 0.0; neither reads storage,
#      randomness, ambient state, physics or scenes, or names content; of every
#      project class — READ from the `class_name` lines under `scripts/` and
#      `addons/` — the attempt names exactly its seven and the result exactly
#      itself; nothing that runs names either class — Foundation H4's drop, which
#      nothing creates, is the one file granted both class names (D-277), and
#      Foundation H5's field, which nothing creates, the result's class alone
#      (D-279); and the verification names no file under `tests/` but its own;
#   4. `scripts/pickups/` holds exactly H2's two scripts, H3's two, H4's one
#      (D-277), H5's two (D-279), and their uid files;
#   5. the files this work could conceivably have disturbed are BYTE-IDENTICAL
#      ACROSS THE RUN.
#
# Usage, from the repository root:
#   game/tests/rift_mote_collection_attempt_smoke.sh

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
		printf '\nRIFT MOTE COLLECTION ATTEMPT SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_mote_collection_attempt_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=353

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added.
EXPECTED_OWED_CHECKS=12

ATTEMPT="scripts/pickups/rift_mote_collection_attempt.gd"
RESULT="scripts/pickups/rift_mote_collection_result.gd"
THIS_VERIFICATION="tests/rift_mote_collection_attempt_verification.gd"

PARSED_SCRIPTS=(
	"$ATTEMPT"
	"$RESULT"
	"$THIS_VERIFICATION"
)

ATTEMPT_CLASS="RiftMoteCollectionAttempt"
RESULT_CLASS="RiftMoteCollectionResult"

# The only project classes each file may name, in C-locale sort order.
EXPECTED_ATTEMPT_NAMED="PlayerStatTotals RiftExperienceMote RiftMoteCollectionAttempt RiftMoteCollectionResult RiftMotePickupQuery RiftMotePickupReading RiftRunLevelCoordinator"
EXPECTED_RESULT_NAMED="RiftMoteCollectionResult"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. The project settings, the
# canonical combat record, the project owner's composed zone, the three accepted
# mechanisms the attempt composes — H1's mote, H2's query and reading, G4's
# coordinator and its record — the one-level lifecycle and its receipt under the
# run, the build and the stat scripts whose totals the attempt forwards, the two
# passive-card record scripts that own the shipped Pickup Radius magnitude, the
# experience track that owns Experience Gain, and the dropped item that owns
# today's manual pickup distance, which Pickup Radius must never reach.
PRESERVED_FILES=(
	"project.godot"
	"data/prototype_zero/quick_strike.tres"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"scripts/experience/rift_experience_mote.gd"
	"scripts/pickups/rift_mote_pickup_query.gd"
	"scripts/pickups/rift_mote_pickup_reading.gd"
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

printf 'Riftwrought — Roguelite Foundation H3: stat-aware single-mote collection attempt (D-275)\n'
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
verify_log="/tmp/riftwrought_rift_mote_collection_attempt_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless collection-attempt verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT MOTE COLLECTION ATTEMPT VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one, and the negative direction must READ the moved
# number, because a bare `!=` is satisfied by the empty string on exactly the
# runs where a broken suite needs catching.
replay="$(mktemp -t riftwrought_rift_mote_collection_attempt_replay)"
scratch_replay="$replay"
sed "s/RIFT MOTE COLLECTION ATTEMPT VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT MOTE COLLECTION ATTEMPT VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT MOTE COLLECTION ATTEMPT VERIFICATION" "$replay")"
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
# measured line that begins with a dash is read by grep as an option bundle.
while IFS= read -r line; do
	if grep -qF -- "$line" "$verify_log"; then
		pass "measured: ${line}"
	else
		fail "the verification log does not report: ${line}"
	fi
done <<'MEASURED'
25.0, 0.10000000000000001, 7.5: each collected at 1.5 m within the 2.5 m baseline radius, equal to H2's own reading; each award exactly its base
the retry refused ('this Experience Mote has already been collected; no pickup range is measured for it'), and refused identically at non-finite positions; the run, the mote and a second run unmoved; 25.0 awarded once
baseline 3.0 m: out of range at 3.0 m against 2.5 m, three times; the mote uncollected and the run unmoved; brought within range it paid 25.0 once
baseline boundary: 5 on-boundary motes collected at distance == radius == 2.5 m; 4 at 2.5000002384185791 m out of range; 4 at 2.4999997615814209 m collected
while the offer stood: 3.0 m out of range with the mote never asked; in range refused twice ('an offer is open; it must be resolved before further experience is recorded'), equal to the mote's own answer; after the choice the same mote at the same position paid 25.0 once
run seed 0, level 1 Utility lane: card_magnetism chosen; Pickup Radius total 0.25; Experience Gain 0.0
3.0 m: out of range at 2.5 m before the card; collected at 3.125 m after it, equal to H2's own reading; the award stayed exactly 25.0
the 3.125 m boundary collected; 3.1250002384185791 m out of range
order: no mote before no run before an invalid mote before any measurement; zero, negative, not a number, positive infinity, negative infinity: each refused with its own problem
18 non-finite components (NaN, +inf, -inf in x, y and z of either position): 18 refused quoting H2 verbatim with nothing measured; the mote then collected
2 motes of 25.0 at one position: 50.0 delivered, each once; one's out-of-range answer left the other alone; both repeats refused
36 of 36 tampered results caught; 6 constructor-built controls coherent with exactly one outcome; the refused distance is inf and the refused radius 0.0, as H2's
0 instance fields, 0 script variables, 0 constants, 1 method; 0 of 100 identical questions disagree, and one asked after three others agrees
the result holds 4 fields (outcome, failure_reason, planar_distance, effective_radius) and 0 object references; 8 methods
16 attempt steps in order, each once; 7 gates each return on the next line; the mote is asked only after the out-of-range return; literals attempt [], result ["0.0"]
0 hits for percentages, base radii, distance formulas, experience formulas, cards, Skills, mutations, stored positions, scans, nodes, areas, shapes or signals
the attempt names only PlayerStatTotals, RiftExperienceMote, RiftMoteCollectionAttempt, RiftMoteCollectionResult, RiftMotePickupQuery, RiftMotePickupReading, RiftRunLevelCoordinator; the result names only RiftMoteCollectionResult
0 unauthorized project files name the attempt or its result (2 readers granted by file and token); scripts/pickups/ holds 7 scripts; 31 actions
37 refusals, 12 out-of-range answers and 21 collections were driven across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. No state, no arithmetic, the mote asked only in range, two named sets, and nothing that runs calls it"
shape=0

# Comment lines are stripped: both files say in plain English what they do not
# do, and a scan that cannot tell the promise from the breach is worthless —
# Gate 1C's lesson, kept.
attempt_code="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$ATTEMPT")"
result_code="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$RESULT")"

if grep -qE '^(static var|var|const|signal|@)' <<< "$attempt_code"; then
	fail "the attempt declares a field, static state, a constant, a signal or an annotation"
	shape=$((shape + 1))
fi
functions="$(grep -E '^(static )?func ' <<< "$attempt_code")"
if [[ "$(grep -c . <<< "$functions" | tr -d ' ')" != "1" || "$functions" != "static func attempt(" ]]; then
	fail "the attempt declares functions other than the one static attempt: ${functions:-none}"
	shape=$((shape + 1))
fi
if grep -qE '[*/+&|^%]|<<|>>' <<< "$attempt_code"; then
	fail "the attempt performs arithmetic or a bit operation"
	shape=$((shape + 1))
fi
if sed 's/->//g' <<< "$attempt_code" | grep -qF -- '-'; then
	fail "the attempt subtracts or negates something"
	shape=$((shape + 1))
fi
if grep -qE '[0-9]+\.[0-9]+' <<< "$attempt_code"; then
	fail "the attempt carries a floating-point literal"
	shape=$((shape + 1))
fi
if grep -qE 'value_of|total_for|contributions_for|apply|clamp|sqrt|abs\(|min\(|max\(|pow\(|\.x|\.y|\.z|acquire|rank_support|\.add\(|consume|choose\(|\.new\(|signal|emit|connect\(|Array|Dictionary|Node|Area|Shape' <<< "$attempt_code"; then
	fail "the attempt restates a formula, reads a coordinate, mutates a build or ledger, or creates something"
	shape=$((shape + 1))
fi
if grep -qE '^[[:space:]]*(for|while) ' <<< "$attempt_code" || grep -qE '^[[:space:]]*(for|while) ' <<< "$result_code"; then
	fail "an H3 file loops"
	shape=$((shape + 1))
fi
if [[ "$(grep -oF '.collect_into(' <<< "$attempt_code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF 'RiftMotePickupQuery.evaluate(' <<< "$attempt_code" | wc -l | tr -d ' ')" != "1" ]]; then
	fail "the attempt does not ask the query once and the mote once"
	shape=$((shape + 1))
fi
out_of_range_line="$(grep -nF 'return RiftMoteCollectionResult.out_of_range(' "$PROJECT_DIR/$ATTEMPT" | cut -d: -f1)"
collect_line="$(grep -nF 'mote.collect_into(run)' "$PROJECT_DIR/$ATTEMPT" | cut -d: -f1)"
if [[ -z "$out_of_range_line" || -z "$collect_line" || "$collect_line" != "$((out_of_range_line + 1))" ]]; then
	fail "the mote is not asked on the line after the out-of-range return (lines ${out_of_range_line:-?} / ${collect_line:-?})"
	shape=$((shape + 1))
fi
if grep -qE '[*/+]' <<< "$result_code" || sed 's/->//g' <<< "$result_code" | grep -qF -- '-'; then
	fail "the result performs arithmetic"
	shape=$((shape + 1))
fi
strays="$(grep -oE '[0-9]+\.[0-9]+' <<< "$result_code" | grep -vx '0.0' | sort -u | tr '\n' ' ')"
if [[ -n "${strays// /}" ]] || grep -qE '^static var' <<< "$result_code"; then
	fail "the result carries the floating-point literal(s) ${strays:-none}, or static state"
	shape=$((shape + 1))
fi
for script in "$ATTEMPT" "$RESULT"; do
	if grep -qE 'user://|ConfigFile|ResourceSaver|ResourceLoader|FileAccess|randi|randf|randomize|RandomNumberGenerator|Time\.|OS\.|Engine\.|ProjectSettings|InputMap|preload\(|load\(|get_tree|get_node|Node3D|Area3D|CollisionShape|PhysicsServer|NavigationServer|NavigationAgent|distance_to|distance_squared_to|length\(|global_position|Transform3D' "$PROJECT_DIR/$script"; then
		fail "$script reads storage, randomness, ambient engine state, physics, navigation or a node"
		shape=$((shape + 1))
	fi
	if grep -qE 'card_[a-z]+|[Mm]agnetism|PICKUP_RADIUS|EXPERIENCE_GAIN|quick_strike|reaching_edge|sweeping_edge|Graveblade|award_experience|open_current_offer|next_level_coordinator|rift_experience_mote|\.tscn|scenes/' "$PROJECT_DIR/$script"; then
		fail "$script names a card, a Skill, a stat, a formula constant, another run operation or a scene"
		shape=$((shape + 1))
	fi
done
if grep -qF 'collect_into(' "$PROJECT_DIR/$RESULT"; then
	fail "the result calls a collection"
	shape=$((shape + 1))
fi
if [[ "$shape" == "0" ]]; then
	pass "the attempt holds no state and one function, performs no arithmetic, restates, mutates, scans and creates nothing, and asks the mote once, on the line after the out-of-range return; the result does no arithmetic; neither reads ambient state, physics or scenes, or names content"
fi

# EVERY PROJECT CLASS, READ FROM ITS OWN `class_name` LINE — never typed here.
declare -a project_classes=()
while IFS= read -r name; do [[ -n "$name" ]] && project_classes+=("$name"); done \
	< <(grep -rhoE '^class_name [A-Za-z0-9_]+' "$PROJECT_DIR/scripts" "$PROJECT_DIR/addons" 2>/dev/null \
		| awk '{print $2}' | LC_ALL=C sort -u)
attempt_named=""
result_named=""
for name in "${project_classes[@]}"; do
	grep -qF "$name" "$PROJECT_DIR/$ATTEMPT" && attempt_named="$attempt_named$name "
	grep -qF "$name" "$PROJECT_DIR/$RESULT" && result_named="$result_named$name "
done
if [[ "${#project_classes[@]}" -lt 100 ]]; then
	fail "only ${#project_classes[@]} project classes were read — the class scan may be inert"
elif [[ "$attempt_named" == "$EXPECTED_ATTEMPT_NAMED " && "$result_named" == "$EXPECTED_RESULT_NAMED " ]]; then
	pass "of ${#project_classes[@]} project classes the attempt names exactly $EXPECTED_ATTEMPT_NAMED and the result exactly $EXPECTED_RESULT_NAMED"
else
	fail "the attempt names: ${attempt_named:-nothing}; the result names: ${result_named:-nothing}"
fi

searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "${searched:-0}" -gt 100 ]]; then
	pass "the shell-side scan read $searched project files"
else
	fail "the shell-side scan found only ${searched:-0} project files, so it proves nothing"
fi

# NOTHING THAT RUNS CALLS THE ATTEMPT OR BUILDS ITS RESULT. D-277: Foundation H4's
# drop hands its collection to the attempt and answers with its result, so it is
# granted both class names — never either file name — in the verification's
# per-file, per-token reader table. Nothing that runs creates a drop. D-279:
# Foundation H5's field reads the result each drop answers with, so it is granted
# the result's class alone — never the attempt's, never either file name.
unwired=0
for token in "$ATTEMPT_CLASS" "$RESULT_CLASS" "rift_mote_collection_attempt" "rift_mote_collection_result"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/"$ATTEMPT"|*/"$ATTEMPT".uid|*/"$RESULT"|*/"$RESULT".uid) continue ;;
		esac
		if [[ "$token" == "$ATTEMPT_CLASS" || "$token" == "$RESULT_CLASS" ]]; then
			case "$hit" in
				*/scripts/pickups/rift_mote_drop.gd) continue ;;
			esac
		fi
		if [[ "$token" == "$RESULT_CLASS" ]]; then
			case "$hit" in
				*/scripts/pickups/rift_mote_field.gd) continue ;;
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
if grep -qF "$ATTEMPT_CLASS" "$PROJECT_DIR/$RESULT"; then
	fail "the result names the attempt"
	unwired=$((unwired + 1))
fi
if grep -q '\[autoload\]' "$PROJECT_DIR/project.godot"; then
	fail "project.godot declares an [autoload] section"
	unwired=$((unwired + 1))
fi
if [[ "$unwired" == "0" ]]; then
	pass "nothing under scripts/, scenes/, data/ or addons/ and nothing in project.godot names the attempt or its result but H4's granted drop and H5's granted field, which nothing creates"
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
	printf 'RIFT MOTE COLLECTION ATTEMPT SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation H3 — Stat-Aware Single-Mote Collection Attempt — is\n'
	printf '  DELIVERED under D-275 and ACCEPTED and CLOSED at the stat-aware single-mote\n'
	printf '  collection-attempt mechanism level under D-276.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT MOTE COLLECTION ATTEMPT SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
