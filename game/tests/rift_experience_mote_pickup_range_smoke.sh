#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation H2 smoke checks: planar Experience Mote
# pickup range (decision D-273).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# Foundation H2 adds TWO pure-logic scripts under `scripts/pickups/` — a stateless
# query that answers whether a world position is within the player's effective
# Experience Mote Pickup Radius (a 2.5 m greybox base, measured on the X/Z plane,
# boundary included, the radius taken from the accepted stat calculation), and the
# reading it answers with. No scene, no resource, no asset, no InputMap action, no
# entrypoint change, nothing written to disk, and NOTHING THAT RUNS CALLS IT.
#
# IT DOES NOT RERUN THE FOUNDATIONS IT STANDS BESIDE. One accepted suite moved one
# for one because the query exists — C1, whose per-file, per-class reader table
# gained one row for the query — and it is rerun by its own runner at its own
# unchanged count. H1 is not rerun: no H1 file and no H1 allowlist changed, and
# this script fingerprints H1's files and re-asserts from outside the engine that
# nothing but the mote names the mote.
#
# What this script proves:
#
#   1. the new scripts parse;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line and
#      the measurements it exists to make read out of that log;
#   3. from outside the engine: the query holds no field, asks the accepted stat
#      calculation exactly once, reads no height component, restates no
#      percentage and carries no literal but 2.5 and 0.0; neither file reads
#      storage, randomness, ambient state, physics or scenes, or names content; of
#      every project class — READ from the `class_name` lines under `scripts/` and
#      `addons/` — the query names exactly its five and the reading exactly
#      itself; nothing that runs names either class; NOTHING BUT THE MOTE NAMES OR
#      COLLECTS THE MOTE — Foundation H3's collection attempt, which nothing runs,
#      is the one file granted the query, the reading, the mote's class and the
#      collection call (D-275), Foundation H4's drop, which nothing creates, the
#      mote's class alone (D-277), and Foundation H6's enemy mote emission, which
#      nothing creates, the mote's class alone (D-281); and the verification names
#      no file under `tests/` but its own;
#   4. `scripts/pickups/` holds exactly the query, the reading, Foundation H3's
#      attempt and result (D-275), Foundation H4's drop (D-277), Foundation H5's
#      field and sweep result (D-279), and their uid files;
#   5. the files this work could conceivably have disturbed are BYTE-IDENTICAL
#      ACROSS THE RUN.
#
# Usage, from the repository root:
#   game/tests/rift_experience_mote_pickup_range_smoke.sh

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
		printf '\nRIFT EXPERIENCE MOTE PICKUP RANGE SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_experience_mote_pickup_range_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=639

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added.
EXPECTED_OWED_CHECKS=11

QUERY="scripts/pickups/rift_mote_pickup_query.gd"
READING="scripts/pickups/rift_mote_pickup_reading.gd"
THIS_VERIFICATION="tests/rift_experience_mote_pickup_range_verification.gd"
MOTE="scripts/experience/rift_experience_mote.gd"

PARSED_SCRIPTS=(
	"$QUERY"
	"$READING"
	"$THIS_VERIFICATION"
)

QUERY_CLASS="RiftMotePickupQuery"
READING_CLASS="RiftMotePickupReading"

# The only project classes each file may name, in C-locale sort order.
EXPECTED_QUERY_NAMED="PlayerStatTotals PlayerStatValue PlayerStats RiftMotePickupQuery RiftMotePickupReading"
EXPECTED_READING_NAMED="RiftMotePickupReading"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. The project settings, the
# project owner's composed zone, Foundation H1's mote and both of its test files
# (which H2 must neither edit nor name), the four accepted stat scripts the query
# asks and must not edit, the two passive-card record scripts that own the shipped
# Pickup Radius magnitude, the run-level coordinator and its record, the run build
# that holds a live accumulator, the experience track and its reading, and the
# dropped item that owns today's manual pickup distance, which Pickup Radius must
# never reach.
PRESERVED_FILES=(
	"project.godot"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"scripts/experience/rift_experience_mote.gd"
	"tests/rift_experience_mote_verification.gd"
	"tests/rift_experience_mote_smoke.sh"
	"scripts/stats/player_stats.gd"
	"scripts/stats/player_stat_totals.gd"
	"scripts/stats/player_stat_value.gd"
	"scripts/stats/player_stat_definition.gd"
	"scripts/stats/passive_card_definition.gd"
	"scripts/stats/passive_card_catalogue.gd"
	"scripts/levels/rift_run_level_coordinator.gd"
	"scripts/levels/rift_run_level_up_result.gd"
	"scripts/runs/rift_run_build.gd"
	"scripts/experience/rift_experience_track.gd"
	"scripts/experience/rift_experience_reading.gd"
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

printf 'Riftwrought — Roguelite Foundation H2: planar Experience Mote pickup range (D-273)\n'
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
verify_log="/tmp/riftwrought_rift_experience_mote_pickup_range_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless pickup-range verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT EXPERIENCE MOTE PICKUP RANGE VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one, and the negative direction must READ the moved
# number, because a bare `!=` is satisfied by the empty string on exactly the
# runs where a broken suite needs catching.
replay="$(mktemp -t riftwrought_rift_experience_mote_pickup_range_replay)"
scratch_replay="$replay"
sed "s/RIFT EXPERIENCE MOTE PICKUP RANGE VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT EXPERIENCE MOTE PICKUP RANGE VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT EXPERIENCE MOTE PICKUP RANGE VERIFICATION" "$replay")"
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
baseline: effective radius 2.5 m from base 2.5 m, equal to the accepted calculation's own answer; modifiers to 3 other stats leave it at 2.5 m
+25% Pickup Radius: effective radius 3.125 m from base 2.5 m, equal to the accepted calculation's own answer (scale 1.25)
baseline boundary: 2.5 m in range, 2.5000002384185791 m out, 2.4999997615814209 m in, on 4 axes and a 3-4-5 diagonal
+25% boundary: 3.125 m in range, 3.1250002384185791 m out, 3.1249997615814209 m in, on 4 axes and a 3-4-5 diagonal
a 3.0 m mote: out of range at baseline, in range at +25%
10 on-boundary readings carry distance == radius exactly (an exclusive < refuses all 10); 10 just-outside readings exceed it by at most 2.384185791015625e-07 m (a 0.000001 m slack admits all 10); 10 just-inside in range
planar (x, z) separations: (1.5, 2.0) -> 2.5 m, (-1.5, -2.0) -> 2.5 m, (3.0, 4.0) -> 5.0 m, (3.0, 4.0) -> 5.0 m, (1.875, 2.5) -> 3.125 m
height ignored across 15 height pairs up to 3.4028234663852886e+38 m: 2.5 m in range and 2.50000019073486746 m out of range every time; a 3D distance would put the 1.75 m-high boundary mote at 3.05163890393342552 m, out of range
a 1e39 m height is stored as inf and refused; the farthest expressible pair is 9.624638193047006e+38 m apart, out of range
swap: 7 pairs x 2 radii, each distance bit-identical and each verdict unchanged
translation by 3 offsets up to 1048576 m (and a 3e+38 m height): 30 comparisons, each distance bit-identical and each verdict unchanged
limit: translating the 2.5000002384185791 m mote by 1024 m stores it at 1026.5 m (spacing 2^-13 m there), exactly on the boundary and in range
18 non-finite components (NaN, +inf, -inf in x, y and z of either position) and missing totals: each refused with radius 0.0, distance inf, in range false, the question kept
order: player before mote before totals; 6 tampered readings caught by the reading's own guard
+1e308: the accumulator accepted it; the query refused ('the effective Pickup Radius could not be calculated: pickup_radius: base 2.500000 at a scale of…'), quoting the accepted calculation verbatim; the mote at the player's own position in range: false
6 orderings of +0.1/+0.3/+0.7: one radius, 5.25 m, each the accepted calculation's own answer, and the 5.25 m boundary mote in range in all 6 (summed naively they give 5.24999999999999911 and 5.25 m)
+25% twice: 3.75 m (compounding would give 3.90625 m), so a 3.79999995231628418 m mote is out; +25% three times, and +25% with +50% either way: 4.375 m
no cap: +300% -> 10.0 m, +100000% -> 2502.5 m, each boundary mote in range
0 instance fields, 0 script variables, 1 constant ({ &"BASE_PICKUP_RADIUS": 2.5 }), 1 method; 0 of 100 identical questions disagree, and one asked after three others agrees
the totals unchanged by the query; an answer already given unmoved by a later modifier; the reading holds 8 fields and 0 object references
the query asks the accepted calculation once, reads x and z and never y, compares once with <=; literals ["0.0", "2.5"]; the reading performs no arithmetic
the query names only PlayerStatTotals, PlayerStatValue, PlayerStats, RiftMotePickupQuery, RiftMotePickupReading; the reading names only RiftMotePickupReading
0 unauthorized project files name the pickup query or its reading, or name or collect the Experience Mote beside its own file (3 readers granted by file and token); scripts/pickups/ holds 7 scripts
24 refusals and 142 measurements were driven across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. No field, one question, no height, two named sets, and nothing that runs calls it"
shape=0

# Comment lines are stripped: both files say in plain English what they do not
# do, and a scan that cannot tell the promise from the breach is worthless —
# Gate 1C's lesson, kept.
query_code="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$QUERY")"
reading_code="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$READING")"
if grep -qE '^(static )?var ' <<< "$query_code"; then
	fail "the query declares a field or static state"
	shape=$((shape + 1))
fi
if [[ "$(grep -oF 'totals.value_of(PlayerStats.PICKUP_RADIUS, BASE_PICKUP_RADIUS)' <<< "$query_code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF 'value_of(' <<< "$query_code" | wc -l | tr -d ' ')" != "1" ]]; then
	fail "the query does not ask the accepted calculation exactly once, for Pickup Radius, from its base"
	shape=$((shape + 1))
fi
if grep -qF '.y' <<< "$query_code"; then
	fail "the query reads a height component"
	shape=$((shape + 1))
fi
if grep -qE 'total_for|contributions_for|apply|scale|clamp|minf|maxf|min\(|max\(|pow\(|1\.0 \+' <<< "$query_code"; then
	fail "the query restates, applies, caps or floors a percentage"
	shape=$((shape + 1))
fi
strays="$(grep -oE '[0-9]+\.[0-9]+' <<< "$query_code" | grep -vxE '0\.0|2\.5' | sort -u | tr '\n' ' ')"
if [[ -n "${strays// /}" ]]; then
	fail "the query carries the floating-point literal(s) ${strays}"
	shape=$((shape + 1))
fi
if grep -qE 'sqrt|[*+]' <<< "$reading_code"; then
	fail "the reading performs arithmetic"
	shape=$((shape + 1))
fi
for script in "$QUERY" "$READING"; do
	if grep -qE 'user://|ConfigFile|ResourceSaver|ResourceLoader|FileAccess|randi|randf|randomize|RandomNumberGenerator|Time\.|OS\.|Engine\.|ProjectSettings|InputMap|preload\(|load\(|get_tree|get_node|Node3D|Area3D|CollisionShape|PhysicsServer|NavigationServer|NavigationAgent|distance_to|distance_squared_to|length\(|length_squared|global_position|Transform3D' "$PROJECT_DIR/$script"; then
		fail "$script reads storage, randomness, ambient engine state, physics, navigation or a node"
		shape=$((shape + 1))
	fi
	if grep -qE 'RiftExperienceMote|rift_experience_mote|collect_into|award_experience|RiftRunLevelCoordinator|RiftRunBuild|stat_totals|card_[a-z]+|[Mm]agnetism|interaction_range|PrototypePlayer|Graveblade|enemy|quick_strike|\.tscn|scenes/' "$PROJECT_DIR/$script"; then
		fail "$script names the mote, the run, a card, an actor, an enemy or a scene"
		shape=$((shape + 1))
	fi
done
if grep -qF 'PlayerStat' "$PROJECT_DIR/$READING"; then
	fail "the reading names a stat class"
	shape=$((shape + 1))
fi
if [[ "$shape" == "0" ]]; then
	pass "the query holds no field, asks the accepted calculation once, reads no height and restates no percentage; the reading does no arithmetic; neither reads ambient state, physics or scenes, or names the mote, the run, a card, an actor or an enemy"
fi

# EVERY PROJECT CLASS, READ FROM ITS OWN `class_name` LINE — never typed here.
declare -a project_classes=()
while IFS= read -r name; do [[ -n "$name" ]] && project_classes+=("$name"); done \
	< <(grep -rhoE '^class_name [A-Za-z0-9_]+' "$PROJECT_DIR/scripts" "$PROJECT_DIR/addons" 2>/dev/null \
		| awk '{print $2}' | LC_ALL=C sort -u)
query_named=""
reading_named=""
for name in "${project_classes[@]}"; do
	grep -qF "$name" "$PROJECT_DIR/$QUERY" && query_named="$query_named$name "
	grep -qF "$name" "$PROJECT_DIR/$READING" && reading_named="$reading_named$name "
done
if [[ "${#project_classes[@]}" -lt 100 ]]; then
	fail "only ${#project_classes[@]} project classes were read — the class scan may be inert"
elif [[ "$query_named" == "$EXPECTED_QUERY_NAMED " && "$reading_named" == "$EXPECTED_READING_NAMED " ]]; then
	pass "of ${#project_classes[@]} project classes the query names exactly $EXPECTED_QUERY_NAMED and the reading exactly $EXPECTED_READING_NAMED"
else
	fail "the query names: ${query_named:-nothing}; the reading names: ${reading_named:-nothing}"
fi

searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "${searched:-0}" -gt 100 ]]; then
	pass "the shell-side scan read $searched project files"
else
	fail "the shell-side scan found only ${searched:-0} project files, so it proves nothing"
fi

# NOTHING THAT RUNS CALLS THE QUERY OR BUILDS ITS READING. D-275: Foundation H3's
# collection attempt asks the query and reads its reading, and is granted both by
# file in the verification's per-file, per-token reader table. Nothing runs it.
ATTEMPT="scripts/pickups/rift_mote_collection_attempt.gd"
DROP="scripts/pickups/rift_mote_drop.gd"
unwired=0
for token in "$QUERY_CLASS" "$READING_CLASS"; do
	while IFS= read -r hit; do
		case "$hit" in
			*/"$QUERY"|*/"$READING"|*/"$ATTEMPT") continue ;;
		esac
		fail "$(basename "$hit") names $token"
		unwired=$((unwired + 1))
	done < <(grep -rlF "$token" "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" \
		"$PROJECT_DIR/data" "$PROJECT_DIR/addons" 2>/dev/null)
	if grep -qF "$token" "$PROJECT_DIR/project.godot"; then
		fail "project.godot names $token"
		unwired=$((unwired + 1))
	fi
done

# AND FOUNDATION H1 STAYS UNWIRED: nothing but the mote names or collects the
# mote — the same three tokens H1's own runner scans for, typed here rather than
# read from it, and the pickup files are NOT exempt.
for token in "RiftExperienceMote" "rift_experience_mote" "collect_into("; do
	while IFS= read -r hit; do
		case "$hit" in
			*/"$MOTE"|*/"$MOTE".uid) continue ;;
		esac
		# D-275: the attempt asks a supplied mote to collect itself, only when it is
		# within range — granted the mote's class and the collection call, never the
		# mote's file name.
		if [[ "$token" != "rift_experience_mote" ]]; then
			case "$hit" in
				*/"$ATTEMPT") continue ;;
			esac
		fi
		# D-277: the drop makes and holds one mote and hands it to the attempt —
		# granted the mote's class alone, never the collection call or its file name.
		# D-281: H6's enemy mote emission makes a temporary mote only to ask its own
		# problem — granted the mote's class alone, too.
		if [[ "$token" == "RiftExperienceMote" ]]; then
			case "$hit" in
				*/"$DROP") continue ;;
				*/scripts/experience/rift_enemy_mote_emission.gd) continue ;;
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
if grep -q '\[autoload\]' "$PROJECT_DIR/project.godot"; then
	fail "project.godot declares an [autoload] section"
	unwired=$((unwired + 1))
fi
if [[ "$unwired" == "0" ]]; then
	pass "nothing under scripts/, scenes/, data/ or addons/ and nothing in project.godot names the query or its reading, and nothing but the mote names or collects the mote, but H3's granted caller, H4's granted holder and H6's granted validator, which nothing runs"
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
step "4. scripts/pickups/ holds exactly the query, its reading, H3's attempt and result, H4's drop, and H5's field and sweep result"
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
	printf 'RIFT EXPERIENCE MOTE PICKUP RANGE SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation H2 — Planar Experience-Mote Pickup Range — is\n'
	printf '  DELIVERED under D-273, CORRECTED under D-274, and ACCEPTED and CLOSED at\n'
	printf '  the planar Experience-Mote pickup-range mechanism level under D-274.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT EXPERIENCE MOTE PICKUP RANGE SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
