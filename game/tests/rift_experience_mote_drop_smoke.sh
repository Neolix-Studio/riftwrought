#!/usr/bin/env bash
# Riftwrought — Roguelite Foundation H4 smoke checks: run-owned Experience Mote
# drop state (decision D-277).
#
# THIS IS NOT A GATE, AND IT DELIBERATELY RUNS NO LOCKED CHAIN.
#
# Foundation H4 adds ONE pure-logic script under `scripts/pickups/` — an in-memory
# drop that binds one exact signed run seed, one fixed world position and one
# Experience Mote it makes and never hands out, and that may be collected only
# into the run whose seed owns it: offered to any other run it refuses before
# anything is measured or collected; offered to its own run it hands the whole
# attempt to the accepted single-mote collection attempt and returns its answer
# unchanged. No scene, no resource, no asset, no InputMap action, no entrypoint
# change, nothing written to disk, and NOTHING THAT RUNS CREATES A DROP.
#
# IT DOES NOT RERUN THE FOUNDATIONS IT COMPOSES. Four accepted suites moved one for
# one because the drop names their classes or shares their directory — H1, whose
# unwired scan gained one per-file, per-token grant (the mote's class only); H2,
# the same grant and its directory pin one script; H3, whose blanket unwired scan
# became a per-file, per-token table granting the drop the attempt's and result's
# classes, and its directory pin one script; and G4, whose reader table gained one
# row — and each is rerun by its own runner at its own unchanged count.
#
# What this script proves:
#
#   1. the new scripts parse;
#   2. the pinned verification passes, proved in BOTH directions against a
#      replay of its own log, with every owed check reaching its last line and
#      the measurements it exists to make read out of that log;
#   3. from outside the engine: the drop declares exactly its three bare fields
#      and eight functions, no constant, static state or signal; it performs no
#      arithmetic, carries no numeric literal, restates no formula, scans nothing
#      and creates nothing but its one mote; it refuses an invalid drop, then a
#      missing run, then a run of another seed, before the one hand-over to the
#      collection attempt, and never returns the mote; it reads no storage,
#      randomness, ambient state, physics or scenes, and names no content and none
#      of the mote's guarded tokens but its class; of every project class — READ
#      from the `class_name` lines under `scripts/` and `addons/` — it names
#      exactly its five; nothing that runs names it — Foundation H5's field,
#      which nothing creates, is the one file granted the drop's class and its
#      collection call (D-279); and the verification names no file under `tests/`
#      but its own;
#   4. `scripts/pickups/` holds exactly H2's two scripts, H3's two, H4's one,
#      H5's two (D-279), and their uid files;
#   5. the files this work could conceivably have disturbed are BYTE-IDENTICAL
#      ACROSS THE RUN.
#
# Usage, from the repository root:
#   game/tests/rift_experience_mote_drop_smoke.sh

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
		printf '\nRIFT EXPERIENCE MOTE DROP SMOKE CHECKS: ABORTED before the end of the script\n'
		printf '  the run stopped early (exit %s) — nothing after that point was proved\n' "$code"
		exit 1
	fi
	exit "$code"
}
trap on_exit EXIT

GODOT="${GODOT:-/Applications/Godot.app/Contents/MacOS/Godot}"
EXPECTED_VERSION="4.7.2.stable"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VERIFICATION="res://tests/rift_experience_mote_drop_verification.gd"

# Pinned, and proved in both directions below.
EXPECTED_CHECKS=651

# The number of check FUNCTIONS the suite owes, separate from the number of
# assertions. Pinned as a variable rather than written into the grep, because
# hard-coding it into the pattern goes stale the moment a check is added.
EXPECTED_OWED_CHECKS=15

DROP="scripts/pickups/rift_mote_drop.gd"
THIS_VERIFICATION="tests/rift_experience_mote_drop_verification.gd"

PARSED_SCRIPTS=(
	"$DROP"
	"$THIS_VERIFICATION"
)

DROP_CLASS="RiftMoteDrop"

# The only project classes the drop may name, in C-locale sort order.
EXPECTED_DROP_NAMED="RiftExperienceMote RiftMoteCollectionAttempt RiftMoteCollectionResult RiftMoteDrop RiftRunLevelCoordinator"

# DELIBERATELY SHORT, AND NOT A WHOLE-PROJECT CATALOGUE. The project settings, the
# canonical combat record, the project owner's composed zone, the four accepted
# mechanisms the drop composes or delegates through — H1's mote, H3's attempt and
# result, H2's query and reading beneath them, G4's coordinator and its record —
# the one-level lifecycle and its receipt under the run, the build and the stat
# scripts the range is taken from, the two passive-card record scripts that own
# the shipped Pickup Radius magnitude, the experience track that owns Experience
# Gain, and the dropped item that owns today's manual pickup distance.
PRESERVED_FILES=(
	"project.godot"
	"data/prototype_zero/quick_strike.tres"
	"scenes/first_mvp/zone_composer_practice.tscn"
	"scripts/experience/rift_experience_mote.gd"
	"scripts/pickups/rift_mote_collection_attempt.gd"
	"scripts/pickups/rift_mote_collection_result.gd"
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

printf 'Riftwrought — Roguelite Foundation H4: run-owned Experience Mote drop state (D-277)\n'
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
verify_log="/tmp/riftwrought_rift_experience_mote_drop_verify.log"
"$GODOT" --headless --path "$PROJECT_DIR" --script "$VERIFICATION" > "$verify_log" 2>&1
verify_status=$?
assert_log_is_fresh "$verify_log"
assert_no_script_error "the headless drop verification" "$verify_log"

if [[ "$verify_status" == "0" ]]; then
	pass "the verification exited 0"
else
	fail "the verification exited $verify_status"
	grep -E "^  FAIL" "$verify_log" | head -20 | sed 's/^/        /'
fi

count="$(read_check_count "RIFT EXPERIENCE MOTE DROP VERIFICATION" "$verify_log")"
if [[ "$count" == "$EXPECTED_CHECKS" ]]; then
	pass "verification passes at the pinned $EXPECTED_CHECKS checks"
else
	fail "verification reports ${count:-no} checks, not $EXPECTED_CHECKS"
fi

# A guard that accepts everything protects nothing: the pin must refuse a log
# whose count moved by one, and the negative direction must READ the moved
# number, because a bare `!=` is satisfied by the empty string on exactly the
# runs where a broken suite needs catching.
replay="$(mktemp -t riftwrought_rift_experience_mote_drop_replay)"
scratch_replay="$replay"
sed "s/RIFT EXPERIENCE MOTE DROP VERIFICATION: PASS ($EXPECTED_CHECKS checks)/RIFT EXPERIENCE MOTE DROP VERIFICATION: PASS ($((EXPECTED_CHECKS + 1)) checks)/" \
	"$verify_log" > "$replay"
replay_count="$(read_check_count "RIFT EXPERIENCE MOTE DROP VERIFICATION" "$replay")"
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
18 drops over 6 signed seeds and the bases 25.0, 0.10000000000000001, 7.5: each reads back its exact seed, position and base, uncollected and valid
25.0, 0.10000000000000001, 7.5: each collected once by its owning run at 1.5 m within 2.5 m, equal to H3's own answer; each award exactly its base
a second and third attempt refused through H3 ('this Experience Mote has already been collected; no pickup range is measured for it'), equal to H3's own answer; 25.0 paid once; the run and the drop unmoved
out of range at 3.0 m against 2.5 m, equal to H3's own answer; 0 of 100 repeats disagree; the drop and the run unmoved; with the player beside it the same drop paid 25.0 once
run seed 100 refused ('this Experience Mote drop belongs to run seed 99, not to run seed 100; it may be collected only into the run that dropped it')
4 of 4 wrong-run attempts answered exactly that with distance inf and radius 0.0 — in range, at (nan, inf, -inf), against an open offer, and after collection — where H3 answers 'the player position must have a finite x, y and z, not (nan, inf, -inf)', the offer 'an offer is open; it must be resolved before further experience is recorded' and the collected mote 'this Experience Mote has already been collected; no pickup range is measured for it'; the owning run then collected 25.0 once
both seeds read 0 in their low 32 bits; 2 of 2 crossed attempts refused ('this Experience Mote drop belongs to run seed 0, not to run seed 4294967296; it may be collected only into the run that dropped it' / 'this Experience Mote drop belongs to run seed 4294967296, not to run seed 0; it may be collected only into the run that dropped it'); each run then collected 25.0 and 25.0 from its own drop
seeds 0, 4294967296, -9223372036854775808, -1, 4294967295, 9223372036854775807: 6 of 36 drop-run pairs collected (each drop by its own run); 30 refused naming both seeds in full, 12 of them seeds that agree in their low 32 bits
9 non-finite components (NaN, +inf, -inf in x, y and z): 9 refused with the drop's own problem, before a missing run and before ownership, never H3's; the run unmoved
order: an invalid drop before a missing run ('an Experience Mote drop must be collected into a run, and none was given') before ownership before delegation; H3 would have answered the drop at (nan, 0.5, -4.5) with 'the mote position must have a finite x, y and z, not (nan, 0.5, -4.5)'
zero, negative, not a number, positive infinity, negative infinity: 10 of 10 refusals quoted the mote's own problem word for word, never collected; the run unmoved; a drop wrong in both answers 'an Experience Mote drop's position must have a finite x, y and z, not (nan, 0.0, 0.0)'
while the offer stood: the 3.0 m drop out of range at 3.0 m; the in-range drop refused twice ('an offer is open; it must be resolved before further experience is recorded'), equal to H3's own answer, uncollected; after the choice the same drop paid 25.0 once
run seed 0, level 1 Utility lane: card_magnetism chosen; Pickup Radius total 0.25
the same drop at 3.0 m: out of range at 2.5 m before the card, collected at 3.125 m after it, equal to H2's own reading; the award stayed exactly 25.0
the 3.125 m boundary collected; 3.1250002384185791 m out of range; a drop of run seed 4294967296 in that range refused for ownership
a reading changed three ways left the drop at (13.0, 0.5, -6.0); after answers [refused, refused, out of range, refused, collected, refused] it still lies at (13.0, 0.5, -6.0) with run seed 99
6 argument-free readings answer 0 objects; the collection attempt answers H3's result with 0 object references; 2 equal drops delivered 50.0, each once
3 fields (_run_seed:int, _position:Vector3, _mote:Object<RiftExperienceMote>), each declared bare and written only by the constructor; 8 methods pinned, none defaulting an argument; 0 reset, copy, move, transfer, setter or signal members
3 constructor, 3 validity and 6 collection steps in order, each once; 5 gates each return on the next line; the hand-over to H3 is the last statement; 7 lines touch the mote, none returning it; literals []
0 hits for distance formulas, Pickup Radius, percentages, requirements, offer seeds, cards, Skills, enemies, nodes, signals, scenes, collision, files, arrays, scans or setters
the drop names only RiftExperienceMote, RiftMoteCollectionAttempt, RiftMoteCollectionResult, RiftMoteDrop, RiftRunLevelCoordinator; its name overlaps 0 other class names;
0 unauthorized project files create or collect a drop (1 reader granted by file and token); scripts/pickups/ holds 7 scripts; 31 actions;
80 refusals, 4 out-of-range answers and 21 collections were driven across this suite
MEASURED

# --------------------------------------------------------------------------
step "3. Three bare fields, no arithmetic, ownership before the one hand-over, five named classes, and nothing that runs creates a drop"
shape=0

# Comment lines are stripped: the file says in plain English what it does not
# do, and a scan that cannot tell the promise from the breach is worthless —
# Gate 1C's lesson, kept.
drop_code="$(grep -vE '^[[:space:]]*#' "$PROJECT_DIR/$DROP")"

fields="$(grep -E '^var ' <<< "$drop_code" | tr '\n' '|')"
if [[ "$fields" != "var _run_seed: int|var _position: Vector3|var _mote: RiftExperienceMote|" ]]; then
	fail "the drop declares the fields: ${fields:-none} — not exactly three, bare, in order"
	shape=$((shape + 1))
fi
if grep -qE '^(static|const|signal|enum|@)' <<< "$drop_code"; then
	fail "the drop declares static state, a constant, a signal, an enum or an annotation"
	shape=$((shape + 1))
fi
functions="$(grep -oE '^func [a-z_]+\(' <<< "$drop_code" | tr '\n' ' ')"
if [[ "$functions" != "func _init( func run_seed( func position( func base_experience( func is_collected( func problem( func attempt_collection( func describe( " ]]; then
	fail "the drop declares the functions: ${functions:-none}"
	shape=$((shape + 1))
fi
if grep -qE '[*/+&|^]|<<|>>' <<< "$drop_code"; then
	fail "the drop performs arithmetic or a bit operation"
	shape=$((shape + 1))
fi
if sed 's/->//g' <<< "$drop_code" | grep -qF -- '-'; then
	fail "the drop subtracts or negates something"
	shape=$((shape + 1))
fi
if grep -qE '(^|[^A-Za-z0-9_.])[0-9]' <<< "$drop_code"; then
	fail "the drop carries a numeric literal"
	shape=$((shape + 1))
fi
if grep -qE 'sqrt|abs\(|pow\(|min\(|max\(|clamp|value_of|total_for|\.x|\.y|\.z|stat_totals|run_build|choose\(|open_|evaluate\(|Array|Dictionary|duplicate|set\(|setget|signal|emit|connect\(|Node|Area|Shape|Skill|[Ee]nemy|free\(' <<< "$drop_code"; then
	fail "the drop restates a formula, reads a coordinate, asks another step of the run, copies, sets or creates something"
	shape=$((shape + 1))
fi
if grep -qE '^[[:space:]]*(for|while|match) ' <<< "$drop_code"; then
	fail "the drop loops"
	shape=$((shape + 1))
fi
if [[ "$(grep -oF '.new(' <<< "$drop_code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF 'RiftExperienceMote.new(for_base_experience)' <<< "$drop_code" | wc -l | tr -d ' ')" != "1" \
		|| "$(grep -oF 'RiftMoteCollectionAttempt.attempt(' <<< "$drop_code" | wc -l | tr -d ' ')" != "1" ]]; then
	fail "the drop does not make exactly its one mote and hand over exactly once"
	shape=$((shape + 1))
fi
if grep -qE 'return _mote$|return _mote[^.]' <<< "$drop_code"; then
	fail "the drop returns its mote"
	shape=$((shape + 1))
fi
# THE ORDER, BY LINE: invalid, then a missing run, then ownership, then the hand-over.
invalid_line="$(grep -nF 'var invalid: String = problem()' "$PROJECT_DIR/$DROP" | cut -d: -f1)"
no_run_line="$(grep -nF 'if run == null:' "$PROJECT_DIR/$DROP" | cut -d: -f1)"
owner_line="$(grep -nF 'if run.run_seed() != _run_seed:' "$PROJECT_DIR/$DROP" | cut -d: -f1)"
handover_line="$(grep -nF 'return RiftMoteCollectionAttempt.attempt(player_position, _position, _mote, run)' "$PROJECT_DIR/$DROP" | cut -d: -f1)"
if [[ -z "$invalid_line" || -z "$no_run_line" || -z "$owner_line" || -z "$handover_line" \
		|| "$invalid_line" -ge "$no_run_line" || "$no_run_line" -ge "$owner_line" || "$owner_line" -ge "$handover_line" ]]; then
	fail "the drop does not refuse invalid, then no run, then another run's seed, before handing over (lines ${invalid_line:-?} / ${no_run_line:-?} / ${owner_line:-?} / ${handover_line:-?})"
	shape=$((shape + 1))
fi
if grep -qE 'user://|ConfigFile|ResourceSaver|ResourceLoader|FileAccess|randi|randf|randomize|RandomNumberGenerator|Time\.|OS\.|Engine\.|ProjectSettings|InputMap|preload\(|load\(|get_tree|get_node|Node3D|Area3D|CollisionShape|PhysicsServer|NavigationServer|NavigationAgent|distance_to|distance_squared_to|length\(|global_position|Transform3D' "$PROJECT_DIR/$DROP"; then
	fail "the drop reads storage, randomness, ambient engine state, physics, navigation or a node"
	shape=$((shape + 1))
fi
# The mote's own guarded tokens, other than its class: the drop never names the
# mote's file and never calls a collection, so H1's grant is the class alone.
if grep -qE 'card_[a-z]+|[Mm]agnetism|PICKUP_RADIUS|EXPERIENCE_GAIN|quick_strike|reaching_edge|sweeping_edge|Graveblade|RiftMotePickup|PlayerStat|RiftRunBuild|RiftRunLevelUpResult|RiftLevelRequirement|RiftLevelOfferSeed|requirement_for|offer_root_seed|open_current_offer|award_experience|next_level_coordinator|collect_into|rift_experience_mote|\.tscn|scenes/' "$PROJECT_DIR/$DROP"; then
	fail "the drop names a card, a Skill, a stat, a formula, another step of the run, the mote's file, a collection call or a scene"
	shape=$((shape + 1))
fi
if [[ "$shape" == "0" ]]; then
	pass "three bare fields and eight functions; no arithmetic, literal, formula, copy, setter, scan or loop; one mote made, never returned; invalid, then no run, then ownership, then one hand-over; no ambient read and no content"
fi

# EVERY PROJECT CLASS, READ FROM ITS OWN `class_name` LINE — never typed here.
declare -a project_classes=()
while IFS= read -r name; do [[ -n "$name" ]] && project_classes+=("$name"); done \
	< <(grep -rhoE '^class_name [A-Za-z0-9_]+' "$PROJECT_DIR/scripts" "$PROJECT_DIR/addons" 2>/dev/null \
		| awk '{print $2}' | LC_ALL=C sort -u)
drop_named=""
for name in "${project_classes[@]}"; do
	grep -qF "$name" "$PROJECT_DIR/$DROP" && drop_named="$drop_named$name "
done
if [[ "${#project_classes[@]}" -lt 100 ]]; then
	fail "only ${#project_classes[@]} project classes were read — the class scan may be inert"
elif [[ "$drop_named" == "$EXPECTED_DROP_NAMED " ]]; then
	pass "of ${#project_classes[@]} project classes the drop names exactly $EXPECTED_DROP_NAMED"
else
	fail "the drop names: ${drop_named:-nothing}"
fi

searched="$(find "$PROJECT_DIR/scripts" "$PROJECT_DIR/scenes" "$PROJECT_DIR/data" \
	"$PROJECT_DIR/addons" -type f \( -name '*.gd' -o -name '*.tscn' -o -name '*.tres' \) \
	2>/dev/null | wc -l | tr -d ' ')"
if [[ "${searched:-0}" -gt 100 ]]; then
	pass "the shell-side scan read $searched project files"
else
	fail "the shell-side scan found only ${searched:-0} project files, so it proves nothing"
fi

# NOTHING THAT RUNS CREATES OR COLLECTS A DROP. D-279: Foundation H5's field makes
# its drops and asks each to attempt its collection, so it is granted the drop's
# class and the collection call — never the drop's file name — in the
# verification's per-file, per-token reader table. Nothing that runs creates a
# field.
unwired=0
for token in "$DROP_CLASS" "rift_mote_drop" "attempt_collection("; do
	while IFS= read -r hit; do
		case "$hit" in
			*/"$DROP"|*/"$DROP".uid) continue ;;
		esac
		if [[ "$token" == "$DROP_CLASS" || "$token" == "attempt_collection(" ]]; then
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
if grep -q '\[autoload\]' "$PROJECT_DIR/project.godot"; then
	fail "project.godot declares an [autoload] section"
	unwired=$((unwired + 1))
fi
if [[ "$unwired" == "0" ]]; then
	pass "nothing under scripts/, scenes/, data/ or addons/ and nothing in project.godot names the drop or asks it to collect but H5's granted field, which nothing creates"
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
	printf 'RIFT EXPERIENCE MOTE DROP SMOKE CHECKS: PASS\n'
	printf '  %s checks; %s of %s owed; %s protected files byte-identical\n' \
		"$EXPECTED_CHECKS" "$EXPECTED_OWED_CHECKS" "$EXPECTED_OWED_CHECKS" "${#PRESERVED_FILES[@]}"
	printf '  Roguelite Foundation H4 — Run-Owned Experience Mote Drop State — is\n'
	printf '  DELIVERED under D-277, CORRECTED under D-278, and ACCEPTED and CLOSED at\n'
	printf '  the run-owned fixed-position Experience Mote drop-state mechanism level\n'
	printf '  under D-278.\n'
	reached_end=1
	exit 0
else
	printf 'RIFT EXPERIENCE MOTE DROP SMOKE CHECKS: %d FAILURE(S)\n' "$failures"
	reached_end=1
	exit 1
fi
